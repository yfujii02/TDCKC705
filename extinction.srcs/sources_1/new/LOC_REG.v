`timescale 1ns / 1ps
/*******************************************************************************
*                                                                              *
* System      : BELLE-II CDC readout module                                    *
* Module      : LOC_REG                                                        *
* Version     : v 3.2.0 2011/04/04                                             *
*                                                                              *
* Description : Slow control; registers                                        *
*                                                                              *
* Designer    : Tomohisa Uchida                                                *
*                                                                              *
*                Copyright (c) 2011 Tomohisa Uchida                            *
*                All rights reserved                                           *
*                Modified by Yuki Fujii, Monash University                     *
*                                                                              *
*******************************************************************************/


module LOC_REG(
    input   wire            CLK         ,    // Clock
    input   wire            RST         ,    // System reset

    // Register I/F
    input   wire    [31:0]  LOC_ADDR    ,    // Address[31:0]
    input   wire     [7:0]  LOC_WD      ,    // Data[7:0]
    input   wire            LOC_WE      ,    // Write enable
    input                   LOC_RE      ,    // Read enable
    output  wire            LOC_ACK     ,    // Access acknowledge
    output  wire     [7:0]  LOC_RD      ,    // Read data[7:0]
    // Registers
<<<<<<< HEAD
    BOARD_ID            ,    // in     : Board ID [3:0]
    SPILLCOUNT          ,    // in     : Spill count [15:0]
    GPIO_SMA_IN         ,    // in     : GPIO SMA Input
    REG_MODE            ,    // out    : Mode select [2:0]
                             //           000: TDC
                             //           001: MCS
                             //           010-110: Reserved
                             //           111: Test mode (internal pattern)
    REG_START           ,    // out    : Start data transferring (0: stop, 1:start)
    REG_RESET           ,    // out    : RESET
    REG_HEADER          ,    // out    : Header
    REG_FOOTER          ,    // out    : Header
    REG_GPIO_POLER      ,    // out    : Pole selector for GPIO SMA
    REG_CHMASK0         ,    // out    : mask input channels
    REG_CHMASK1         ,    // out    : mask input channels 2
    REG_SPLCNT_RST      ,    // out    : spill count reset
    REG_TEST_PSPILL_EN  ,    // out    : test spill enable
    REG_TEST_MRSYNC_EN  ,    // out    : tset MR sync enable
    REG_TEST_PSPILL_POS ,    // out    : time width of test spill (Pos.)
    REG_TEST_PSPILL_NEG ,    // out    : time width of test spill (Pos.)
    REG_TEST_MRSYNC_FRQ ,    // out    : Tset MR sync frequency
    REG_DLYL_PSPILL     ,    // out    : Delay for spill signal
    REG_DLYL_MRSYNC     ,    // out    : Delay for MR sync
    REG_DLYL_EVMATCH    ,    // out    : Delay for Event matching
    REG_DLYL_BH         ,    // out    : Delay for Beam hodoscope
    REG_DLYL_TC         ,    // out    : Delay for Timing counter
    REG_DLYL_MPPC       ,    // out    : Delay for MPPC
    REG_DLYL_OLD_PMT    ,    // out    : Delay for Old hodoscope PMT
    REG_DLYL_ALLOLD_PMT ,    // out    : Delay for Old hodoscope PMT
    REG_DLYL_NEW_PMT    ,    // out    : Delay for New hodoscope PMT
    CNT_GPIO0           ,
    CNT_GPIO1
);

//-------- Input/Output -------------
    input            CLK                ;
    input            RST                ;

    input    [31:0]  LOC_ADDR           ;
    input     [7:0]  LOC_WD             ;
    input            LOC_WE             ;
    input            LOC_RE             ;
    output           LOC_ACK            ;
    output    [7:0]  LOC_RD             ;

    input     [3:0]  BOARD_ID           ;
    input    [31:0]  SPILLCOUNT         ;
    input     [1:0]  GPIO_SMA_IN        ;
    output    [2:0]  REG_MODE           ;
    output           REG_START          ;
    output           REG_RESET          ;

    output   [31:0]  REG_HEADER         ;
    output   [31:0]  REG_FOOTER         ;

    output    [1:0]  REG_GPIO_POLER     ;
    
    output   [63:0]  REG_CHMASK0        ;
    output   [15:0]  REG_CHMASK1        ;

    output           REG_SPLCNT_RST     ;

    output           REG_TEST_PSPILL_EN ;
    output           REG_TEST_MRSYNC_EN ;
    output   [31:0]  REG_TEST_PSPILL_POS;
    output   [31:0]  REG_TEST_PSPILL_NEG;
    output   [31:0]  REG_TEST_MRSYNC_FRQ;

    output    [7:0]  REG_DLYL_PSPILL    ;
    output    [7:0]  REG_DLYL_MRSYNC    ;
    output    [7:0]  REG_DLYL_EVMATCH   ;
    output   [15:0]  REG_DLYL_BH        ;
    output   [15:0]  REG_DLYL_TC        ;
    output    [7:0]  REG_DLYL_MPPC      ;
    output    [7:0]  REG_DLYL_OLD_PMT   ;
    output    [7:0]  REG_DLYL_ALLOLD_PMT;
    output    [7:0]  REG_DLYL_NEW_PMT   ;

    input     [7:0]  CNT_GPIO0          ;
    input     [7:0]  CNT_GPIO1          ;

=======
    input   wire     [3:0]  BOARD_ID    ,    // Board ID [3:0]
    input   wire    [31:0]  SPILLCOUNT  ,    // Spill count [15:0]
    output  wire     [2:0]  REG_MODE    ,    // Mode select [2:0]
                                             // [2]==1: Use internal test pins
                                             //  ==111: Use internal test pins for sig ch[0]&[2] as well
    // DAQ related
    output  wire            REG_START   ,    // Start data transferring (0: stop, 1:start)
    output  wire            REG_RESET   ,    // RESET
    output  wire    [31:0]  REG_HEADER  ,    // Header for TDC
    output  wire    [31:0]  REG_FOOTER  ,    // Footer for TDC
    // Specific for MCS
    output  wire    [ 3:0]  REG_SPLDIV,      // Divide a spill in MCS readout mode
                                             //  if #of MRSync reaches N=[2^(REG_SPLDIV)]*1024
    // Debug
    output  wire    [63:0]  REG_CHMASK0 ,    // mask input channels
    output  wire    [14:0]  REG_CHMASK1 ,    // mask input channels (OLDH)
    output  wire            REG_SPLCNT_RST_EN   ,    // out    : enalbe spill count reset
    output  wire            REG_SPLCNT_RST      ,    // out    : spill count reset
    output  wire     [7:0]  REG_SPLCNT_RSTT     ,    // out    : spill count reset timing from spill end
    output  wire            REG_TEST_PSPILL_EN  ,    // out    : test spill enable
    output  wire            REG_TEST_MRSYNC_EN  ,    // out    : tset MR sync enable
    output  wire    [31:0]  REG_TEST_PSPILL_POS ,    // out    : time width of test spill (Pos.)
    output  wire    [31:0]  REG_TEST_PSPILL_NEG ,    // out    : time width of test spill (Pos.)
    output  wire    [31:0]  REG_TEST_MRSYNC_FRQ ,    // out    : Tset MR sync frequency
    output  wire     [7:0]  REG_DLYL_PSPILL      ,    // out    : Delay for spill signal
    output  wire     [7:0]  REG_DLYL_MRSYNC      ,    // out    : Delay for MR sync
    output  wire     [7:0]  REG_DLYL_EVMATCH     ,    // out    : Delay for Event matching
    output  wire    [15:0]  REG_DLYL_BH          ,    // out    : Delay for BH
    output  wire    [15:0]  REG_DLYL_TC          ,    // out    : Delay for TC
    output  wire     [7:0]  REG_DLYL_MPPC        ,    // out    : Delay for MPPC
    output  wire     [7:0]  REG_DLYL_OLD_PMT     ,    // out    : Delay for New PMT
    output  wire     [7:0]  REG_DLYL_ALLOLD_PMT  ,    // out    : Delay for New PMT
    output  wire     [7:0]  REG_DLYL_NEW_PMT          // out    : Delay for Old PMT
);
>>>>>>> 82d30bcdddea1ab3a785b38cc9ca2d00db4d7f72
//------------------------------------------------------------------------------
//    Input buffer
//------------------------------------------------------------------------------
    reg       [3:0]  regCs           ;
    reg      [10:0]  irAddr          ;
    reg              irWe            ;
    reg              irRe            ;
    reg       [7:0]  irWd            ;

    always@ (posedge CLK) begin
        regCs[0]     <= (LOC_ADDR[31:4]==28'h0);
        regCs[1]     <= (LOC_ADDR[31:4]==28'h1);
        regCs[2]     <= (LOC_ADDR[31:4]==28'h2);
        regCs[3]     <= (LOC_ADDR[31:4]==28'h3);

        irAddr[10:0] <= LOC_ADDR[10:0];
        irWe         <= LOC_WE;
        irRe         <= LOC_RE;
        irWd[7:0]    <= LOC_WD[7:0];
    end

//------------------------------------------------------------------------------
//    Receive
//------------------------------------------------------------------------------
    reg     [2:0]    x00_Reg   ;
    reg     [7:0]    x01_Reg   ;
    reg     [7:0]    x02_Reg   ;
    reg     [7:0]    x03_Reg   ;
    reg     [7:0]    x04_Reg   ;
    reg     [7:0]    x05_Reg   ;
    reg     [7:0]    x06_Reg   ;
    reg     [7:0]    x07_Reg   ;
    reg     [7:0]    x08_Reg   ;
    reg     [7:0]    x09_Reg   ;
    reg     [7:0]    x0A_Reg   ;
    reg     [7:0]    x0B_Reg   ;
    reg     [7:0]    x0C_Reg   ;
    reg     [7:0]    x0D_Reg   ;
    reg     [7:0]    x0E_Reg   ;
    reg     [7:0]    x0F_Reg   ;

    reg     [7:0]    x10_Reg   ;
    reg     [7:0]    x11_Reg   ;
    reg     [7:0]    x12_Reg   ;
    reg     [7:0]    x13_Reg   ;
    reg     [7:0]    x14_Reg   ;
    reg     [7:0]    x15_Reg   ;
    reg     [7:0]    x16_Reg   ;
    reg     [7:0]    x17_Reg   ;
    reg     [7:0]    x18_Reg   ;
    reg     [7:0]    x19_Reg   ;
    reg     [3:0]    x1A_Reg   ; // Spill Div for MCS
    reg     [7:0]    x1B_Reg   ; // NC
    reg     [7:0]    x1C_Reg   ; // NC
    reg              x1D_Reg   ; // 
    reg     [2:0]    irX1D_Reg ; // 
    reg     [7:0]    x1E_Reg   ; // NC
    reg     [7:0]    x1F_Reg   ; // NC

    reg     [7:0]    x20_Reg   ;
    reg     [7:0]    x21_Reg   ;
    reg     [7:0]    x22_Reg   ;
    reg     [7:0]    x23_Reg   ;
    reg     [7:0]    x24_Reg   ;
    reg     [7:0]    x25_Reg   ;
    reg     [7:0]    x26_Reg   ;
    reg     [7:0]    x27_Reg   ;
    reg     [7:0]    x28_Reg   ;
    reg     [7:0]    x29_Reg   ;
    reg     [7:0]    x2A_Reg   ;
    reg     [7:0]    x2B_Reg   ; 
    reg     [7:0]    x2C_Reg   ;
    reg     [7:0]    x2D_Reg   ;
    reg     [7:0]    x2E_Reg   ; // NC
    reg     [1:0]    x2F_Reg   ; // Pole selector for GPIO SMA

    reg     [7:0]    x30_Reg   ; // Delay for PSPILL
    reg     [7:0]    x31_Reg   ; // Delay for MR sync
    reg     [7:0]    x32_Reg   ; // Delay for Event matching
    reg     [7:0]    x33_Reg   ; // Delay for Beam hodoscope [15:0]
<<<<<<< HEAD
    reg     [7:0]    x34_Reg   ; // Delay for Beam hodoscope [7:0]
    reg     [7:0]    x35_Reg   ; // Delay for Timing counter [15:0]
    reg     [7:0]    x36_Reg   ; // Delay for Timing counter [7:0] 
    reg     [7:0]    x37_Reg   ; // Delay for MPPC
    reg     [7:0]    x38_Reg   ; // Delay for Old hodoscope PMT
    reg     [7:0]    x39_Reg   ; // Delay for All Old hodoscope PMTs
    reg     [7:0]    x3A_Reg   ; // Delay for New hodoscope PMT
    reg     [7:0]    x3B_Reg   ; // NC
    reg     [7:0]    x3C_Reg   ; // NC
    reg     [7:0]    x3D_Reg   ; // NC
    reg     [7:0]    x3E_Reg   ; // NC
    reg     [7:0]    x3F_Reg   ; // NC
=======
    reg     [7:0]    x34_Reg   ; // Delay for Beam hodoscope [ 7:0]
    reg     [7:0]    x35_Reg   ; // Delay for Timing counter [15:0]
    reg     [7:0]    x36_Reg   ; // Delay for Timing counter [ 7:0]
    reg     [7:0]    x37_Reg   ; // Delay for MPPC               
    reg     [7:0]    x38_Reg   ; // Delay for Old hodoscope PMT  
    reg     [7:0]    x39_Reg   ; // Delay for All Old hodoscope PMT  
    reg     [7:0]    x3A_Reg   ; // Delay for New hodoscope PMT    
    reg     [7:0]    x3B_Reg   ; // NC                           
    reg     [7:0]    x3C_Reg   ; // NC                           
    reg     [7:0]    x3D_Reg   ; // NC                           
    reg     [7:0]    x3E_Reg   ; // NC                           
    reg     [7:0]    x3F_Reg   ; // NC                           
>>>>>>> 82d30bcdddea1ab3a785b38cc9ca2d00db4d7f72

    always@ (posedge CLK or posedge RST) begin
        if(RST)begin
///////////////////////////////////////////////////////
// Default Setup
///////////////////////////////////////////////////////
            // Trigger mode select, default [no trigger]
            x00_Reg[2:0]    <= 3'd0;    // Trigger Mode [2:0]
            // Data length in CLK length default [0x0BEBC200 = 1sec]
            x01_Reg[7:0]    <= 8'h00;   // Start
            x02_Reg[7:0]    <= 8'h00;   // Reset
            x03_Reg[7:0]    <= {4'd0,BOARD_ID[3:0]}; // Board ID
            x04_Reg[7:0]    <= SPILLCOUNT[31:24];   // Spill count
            x05_Reg[7:0]    <= SPILLCOUNT[23:16];   // Spill count
            x06_Reg[7:0]    <= SPILLCOUNT[15: 8];   // Spill count
            x07_Reg[7:0]    <= SPILLCOUNT[ 7: 0];   // Spill count
            x08_Reg[7:0]    <= 8'h01;   // Header
            x09_Reg[7:0]    <= 8'h23;   // Header
            x0A_Reg[7:0]    <= 8'h45;   // Header
            x0B_Reg[7:0]    <= 8'h67;   // Header
            x0C_Reg[7:0]    <= 8'hAA;   // Footer
            x0D_Reg[7:0]    <= 8'hAA;   // Footer
            x0E_Reg[7:0]    <= 8'hAA;   // Footer
            x0F_Reg[7:0]    <= 8'hAA;   // Footer

            x10_Reg[7:0]    <= 8'h00;   //
            x11_Reg[7:0]    <= 8'h00;   //
            x12_Reg[7:0]    <= 8'h00;   //
            x13_Reg[7:0]    <= 8'h00;   //
            x14_Reg[7:0]    <= 8'h00;   //
            x15_Reg[7:0]    <= 8'h00;   //
            x16_Reg[7:0]    <= 8'h00;   //
            x17_Reg[7:0]    <= 8'h00;   //
            x18_Reg[7:0]    <= 8'h00;   //
            x19_Reg[7:0]    <= 8'h00;   //
            x1A_Reg[3:0]    <= 4'hF;    // Spill Div for MCS
            x1B_Reg[7:0]    <= 8'h10;   // NC
            x1C_Reg[7:0]    <= 8'h1C;   //
            x1D_Reg         <= 1'h0;    // Spill count reset
            irX1D_Reg[2:0]  <= 3'h0;    // 
            x1E_Reg[7:0]    <= 8'h1E;   // NC
            x1F_Reg[7:0]    <= 8'h1F;   // NC

            x20_Reg[7:0]    <= 8'h00;   // Time width of test spill (Pos.) [31:24]
            x21_Reg[7:0]    <= 8'h4C;   // Time width of test spill (Pos.) [23:16]
            x22_Reg[7:0]    <= 8'h4B;   // Time width of test spill (Pos.) [15:8]
            x23_Reg[7:0]    <= 8'h40;   // Time width of test spill (Pos.) [7:0] (def. 0.5ms)
            x24_Reg[7:0]    <= 8'h00;   // Time width of test spill (Neg.)
            x25_Reg[7:0]    <= 8'h4C;   // Time width of test spill (Neg.)
            x26_Reg[7:0]    <= 8'h4B;   // Time width of test spill (Neg.)
            x27_Reg[7:0]    <= 8'h40;   // Time width of test spill (Neg.) (def. 0.5ms)
            x28_Reg[7:0]    <= 8'h00;   // Test MR sync frequency
            x29_Reg[7:0]    <= 8'h00;   // Test MR sync frequency
            x2A_Reg[7:0]    <= 8'h00;   // Test MR sync frequency
            x2B_Reg[7:0]    <= 8'h0A;   // Test MR sync frequency (def. 1MHz, 1us)
            x2C_Reg         <= 1'h0;    // Test spill enable
            x2D_Reg         <= 1'h0;    // Test spill enable
            x2E_Reg[7:0]    <= 8'h00;   // NC
            x2F_Reg[1:0]    <= 2'b11;   // Pole selector for GPIO SMA

            x30_Reg[7:0]    <= 8'h00;   // Delay for PSPILL        
            x31_Reg[7:0]    <= 8'h00;   // Delay for MR sync       
            x32_Reg[7:0]    <= 8'h00;   // Delay for Event matching
<<<<<<< HEAD
            x33_Reg[7:0]    <= 8'h00;   // Delay for Beam hodoscope [15:0]           
            x34_Reg[7:0]    <= 8'h00;   // Delay for Beam hodoscope [7:0]          
            x35_Reg[7:0]    <= 8'h00;   // Delay for Timing counter [15:0]           
            x36_Reg[7:0]    <= 8'h00;   // Delay for Timing counter [7:0]            
            x37_Reg[7:0]    <= 8'h00;   // Delay for MPPC                     
            x38_Reg[7:0]    <= 8'h00;   // Delay for Old hodoscope PMT        
            x39_Reg[7:0]    <= 8'h00;   // Delay for All Old hodoscope PMTs        
            x3A_Reg[7:0]    <= 8'h00;   // Delay for New hodoscope PMT        
            x3B_Reg[7:0]    <= 8'h3B;   // NC                                 
            x3C_Reg[7:0]    <= 8'h3C;   // NC                                 
            x3D_Reg[7:0]    <= 8'h3D;   // NC                                 
            x3E_Reg[7:0]    <= 8'h3E;   // NC                                 
            x3F_Reg[7:0]    <= 8'h3F;   // NC                                 
=======
            x33_Reg[7:0]    <= 8'h00;   // Delay for Beam hodoscope [15:0]
            x34_Reg[7:0]    <= 8'h00;   // Delay for Beam hodoscope [ 7:0]
            x35_Reg[7:0]    <= 8'h00;   // Delay for Timing counter [15:0]
            x36_Reg[7:0]    <= 8'h00;   // Delay for Timing counter [ 7:0]
            x37_Reg[7:0]    <= 8'h00;   // Delay for MPPC                 
            x38_Reg[7:0]    <= 8'h00;   // Delay for Old hodoscope PMT    
            x39_Reg[7:0]    <= 8'h00;   // Delay for All Old hodoscope PMT
            x3A_Reg[7:0]    <= 8'h00;   // Delay for New hodoscope PMT    
            x3B_Reg[7:0]    <= 8'h00;   //  NC                         
            x3C_Reg[7:0]    <= 8'h00;   //  NC                         
            x3D_Reg[7:0]    <= 8'h00;   //  NC                         
            x3E_Reg[7:0]    <= 8'h00;   //  NC                         
            x3F_Reg[7:0]    <= 8'h00;   //  NC                         
>>>>>>> 82d30bcdddea1ab3a785b38cc9ca2d00db4d7f72

///////////////////////////////////////////////////////
// Write Registers
///////////////////////////////////////////////////////
        end else begin
            //// Following register values shoudl not be overwritten by UDP
            x03_Reg[7:0]    <= {4'd0,BOARD_ID[3:0]};
            x04_Reg[7:0]    <= SPILLCOUNT[31:24];
            x05_Reg[7:0]    <= SPILLCOUNT[23:16];
            x06_Reg[7:0]    <= SPILLCOUNT[15: 8];
            x07_Reg[7:0]    <= SPILLCOUNT[ 7: 0];

            if(irWe)begin
                x00_Reg[2:0]    <= (regCs[0] & (irAddr[3:0]==4'h0) ? irWd[2:0] : x00_Reg[2:0]);
                x01_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'h1) ? irWd[7:0] : x01_Reg[7:0]);
                x02_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'h2) ? irWd[7:0] : x02_Reg[7:0]);

                //// Header
                x08_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'h8) ? irWd[7:0] : x08_Reg[7:0]);
                x09_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'h9) ? irWd[7:0] : x09_Reg[7:0]);
                x0A_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'hA) ? irWd[7:0] : x0A_Reg[7:0]);
                x0B_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x0B_Reg[7:0]);
                //// Footer
                x0C_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'hC) ? irWd[7:0] : x0C_Reg[7:0]);
                x0D_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'hD) ? irWd[7:0] : x0D_Reg[7:0]);
                x0E_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'hE) ? irWd[7:0] : x0E_Reg[7:0]);
                x0F_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'hF) ? irWd[7:0] : x0F_Reg[7:0]);

                x10_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h0) ? irWd[7:0] : x10_Reg[7:0]);
                x11_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h1) ? irWd[7:0] : x11_Reg[7:0]);
                x12_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h2) ? irWd[7:0] : x12_Reg[7:0]);
                x13_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h3) ? irWd[7:0] : x13_Reg[7:0]);
                x14_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h4) ? irWd[7:0] : x14_Reg[7:0]);
                x15_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h5) ? irWd[7:0] : x15_Reg[7:0]);
                x16_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h6) ? irWd[7:0] : x16_Reg[7:0]);
                x17_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h7) ? irWd[7:0] : x17_Reg[7:0]);
                x18_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h8) ? irWd[7:0] : x18_Reg[7:0]);
                x19_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h9) ? irWd[7:0] : x19_Reg[7:0]);

                x1A_Reg[3:0]    <= (regCs[1] & (irAddr[3:0]==4'hA) ? irWd[3:0] : x1A_Reg[3:0]);
                x1B_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x1B_Reg[7:0]);

                x1D_Reg         <= (regCs[1] & (irAddr[3:0]==4'hD) ? irWd[0:0] : x1D_Reg);
                x1E_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'hE) ? irWd[7:0] : x1E_Reg[7:0]);
                x1F_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'hF) ? irWd[7:0] : x1F_Reg[7:0]);

                x20_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h0) ? irWd[7:0] : x20_Reg[7:0]);
                x21_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h1) ? irWd[7:0] : x21_Reg[7:0]);
                x22_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h2) ? irWd[7:0] : x22_Reg[7:0]);
                x23_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h3) ? irWd[7:0] : x23_Reg[7:0]);
                x24_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h4) ? irWd[7:0] : x24_Reg[7:0]);
                x25_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h5) ? irWd[7:0] : x25_Reg[7:0]);
                x26_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h6) ? irWd[7:0] : x26_Reg[7:0]);
                x27_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h7) ? irWd[7:0] : x27_Reg[7:0]);
                x28_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h8) ? irWd[7:0] : x28_Reg[7:0]);
                x29_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h9) ? irWd[7:0] : x29_Reg[7:0]);
                x2A_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'hA) ? irWd[7:0] : x2A_Reg[7:0]);
                x2B_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x2B_Reg[7:0]);
                x2C_Reg         <= (regCs[2] & (irAddr[3:0]==4'hC) ? irWd[0:0] : x2C_Reg     );
                x2D_Reg         <= (regCs[2] & (irAddr[3:0]==4'hD) ? irWd[0:0] : x2D_Reg     );
                x2F_Reg[1:0]    <= (regCs[2] & (irAddr[3:0]==4'hF) ? irWd[1:0] : x2F_Reg[1:0]);

                x30_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h0) ? irWd[7:0] : x30_Reg[7:0]);
                x31_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h1) ? irWd[7:0] : x31_Reg[7:0]);
                x32_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h2) ? irWd[7:0] : x32_Reg[7:0]);
                x33_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h3) ? irWd[7:0] : x33_Reg[7:0]);
                x34_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h4) ? irWd[7:0] : x34_Reg[7:0]);
                x35_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h5) ? irWd[7:0] : x35_Reg[7:0]);
                x36_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h6) ? irWd[7:0] : x36_Reg[7:0]);
                x37_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h7) ? irWd[7:0] : x37_Reg[7:0]);
                x38_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h8) ? irWd[7:0] : x38_Reg[7:0]);
                x39_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h9) ? irWd[7:0] : x39_Reg[7:0]);
                x3A_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'hA) ? irWd[7:0] : x3A_Reg[7:0]);
                x3B_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x3B_Reg[7:0]);
                x3C_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'hC) ? irWd[7:0] : x3C_Reg[7:0]);
                x3D_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'hD) ? irWd[7:0] : x3D_Reg[7:0]);
                x3E_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'hE) ? irWd[7:0] : x3E_Reg[7:0]);
                x3F_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'hF) ? irWd[7:0] : x3F_Reg[7:0]);
                
            end else begin
                x1D_Reg <= (~irX1D_Reg[2]) & x1D_Reg; // High only within 1CLK
            end
            irX1D_Reg[2:0] <= {irX1D_Reg[1:0], x1D_Reg};
        end
    end

    reg      [7:0]    rdDataA ;
    reg      [7:0]    rdDataB ;
    reg      [7:0]    rdDataC ;
    reg      [7:0]    rdDataD ;
    reg      [3:0]    regRv   ;
    reg               regAck  ;


///////////////////////////////////////////////////////
// Setup Read Registers
///////////////////////////////////////////////////////
    always@ (posedge CLK) begin
        case(irAddr[3:0]) /// FPGA setup, DAQ setup
            4'h0:    rdDataA[7:0]    <= {5'd0,x00_Reg[2:0]}; // Trigger Mode
            4'h1:    rdDataA[7:0]    <= x01_Reg[7:0];        // Start DAQ
            4'h2:    rdDataA[7:0]    <= x02_Reg[7:0];        // Reset
            4'h3:    rdDataA[7:0]    <= x03_Reg[7:0];        // Board ID
            4'h4:    rdDataA[7:0]    <= x04_Reg[7:0];        // Spill count [31:24]
            4'h5:    rdDataA[7:0]    <= x05_Reg[7:0];        // Spill count [23:16]
            4'h6:    rdDataA[7:0]    <= x06_Reg[7:0];        // Spill count [15: 8]
            4'h7:    rdDataA[7:0]    <= x07_Reg[7:0];        // Spill count [ 7: 0]
            4'h8:    rdDataA[7:0]    <= x08_Reg[7:0];        // Header
            4'h9:    rdDataA[7:0]    <= x09_Reg[7:0];        // Header
            4'hA:    rdDataA[7:0]    <= x0A_Reg[7:0];        // Header
            4'hB:    rdDataA[7:0]    <= x0B_Reg[7:0];        // Header
            4'hC:    rdDataA[7:0]    <= x0C_Reg[7:0];        // Footer
            4'hD:    rdDataA[7:0]    <= x0D_Reg[7:0];        // Footer
            4'hE:    rdDataA[7:0]    <= x0E_Reg[7:0];        // Footer
            4'hF:    rdDataA[7:0]    <= x0F_Reg[7:0];        // Footer
        endcase
        case(irAddr[3:0]) /// channel mask
            4'h0:    rdDataB[7:0]    <= x10_Reg[7:0];      // Channel mask [63:56]
            4'h1:    rdDataB[7:0]    <= x11_Reg[7:0];      // Channel mask [55:48]
            4'h2:    rdDataB[7:0]    <= x12_Reg[7:0];      // Channel mask [47:40]
            4'h3:    rdDataB[7:0]    <= x13_Reg[7:0];      // Channel mask [39:32]
            4'h4:    rdDataB[7:0]    <= x14_Reg[7:0];      // Channel mask [31:24]
            4'h5:    rdDataB[7:0]    <= x15_Reg[7:0];      // Channel mask [23:16]
            4'h6:    rdDataB[7:0]    <= x16_Reg[7:0];      // Channel mask [15: 8]
            4'h7:    rdDataB[7:0]    <= x17_Reg[7:0];      // Channel mask [ 7: 0]
            4'h8:    rdDataB[7:0]    <= x18_Reg[7:0];      // Channel mask 2 [14:8] ([7]:nc)
            4'h9:    rdDataB[7:0]    <= x19_Reg[7:0];      // Channel mask 2 [ 7:0]
            4'hA:    rdDataB[7:0]    <= {4'h0,x1A_Reg[3:0]};// Spill Div for MCS
            4'hB:    rdDataB[7:0]    <= x1B_Reg[7:0];      // NC
            4'hC:    rdDataB[7:0]    <= 8'h1C;    // NC
            4'hD:    rdDataB[7:0]    <= {7'd0,x1D_Reg};    // SPLCNT reset
            4'hE:    rdDataB[7:0]    <= CNT_GPIO0[7:0];    // NC
            4'hF:    rdDataB[7:0]    <= CNT_GPIO1[7:0];    // NC
        endcase
        case(irAddr[3:0]) /// Test pulse setting
            4'h0:    rdDataC[7:0]    <= x20_Reg[7:0];        // T width of test spill (Pos.) [31:24]
            4'h1:    rdDataC[7:0]    <= x21_Reg[7:0];        // T width of test spill (Pos.) [23:16]
            4'h2:    rdDataC[7:0]    <= x22_Reg[7:0];        // T width of test spill (Pos.) [15: 8]
            4'h3:    rdDataC[7:0]    <= x23_Reg[7:0];        // T width of test spill (Pos.) [ 7: 0]
            4'h4:    rdDataC[7:0]    <= x24_Reg[7:0];        // T width of test spill (Neg.) [31:24]
            4'h5:    rdDataC[7:0]    <= x25_Reg[7:0];        // T width of test spill (Neg.) [23:16]
            4'h6:    rdDataC[7:0]    <= x26_Reg[7:0];        // T width of test spill (Neg.) [15: 8]
            4'h7:    rdDataC[7:0]    <= x27_Reg[7:0];        // T width of test spill (Neg.) [ 7: 0]
            4'h8:    rdDataC[7:0]    <= x28_Reg[7:0];        // Test MR sync frequency 
            4'h9:    rdDataC[7:0]    <= x29_Reg[7:0];        // Test MR sync frequency 
            4'hA:    rdDataC[7:0]    <= x2A_Reg[7:0];        // Test MR sync frequency 
            4'hB:    rdDataC[7:0]    <= x2B_Reg[7:0];        // Test MR sync frequency 
            4'hC:    rdDataC[7:0]    <= {7'd0, x2C_Reg};     // Test spill enable
            4'hD:    rdDataC[7:0]    <= {7'd0, x2D_Reg};     // Test MR sync enable
            4'hE:    rdDataC[7:0]    <= {6'd0, GPIO_SMA_IN}; // GPIO SMA Input
            4'hF:    rdDataC[7:0]    <= {6'd0, x2F_Reg[1:0]};// Pole selector for GPIO SMA
        endcase
        case(irAddr[3:0]) /// 
            4'h0:    rdDataD[7:0]    <= x30_Reg[7:0];        // Delay for PSPILL        
            4'h1:    rdDataD[7:0]    <= x31_Reg[7:0];        // Delay for MR sync       
            4'h2:    rdDataD[7:0]    <= x32_Reg[7:0];        // Delay for Event matching
            4'h3:    rdDataD[7:0]    <= x33_Reg[7:0];        // Delay for Beam hodoscope [15:0]
<<<<<<< HEAD
            4'h4:    rdDataD[7:0]    <= x34_Reg[7:0];        // Delay for Beam hodoscope [7:0] 
            4'h5:    rdDataD[7:0]    <= x35_Reg[7:0];        // Delay for Timing counter [15:0]
            4'h6:    rdDataD[7:0]    <= x36_Reg[7:0];        // Delay for Timing counter [7:0] 
            4'h7:    rdDataD[7:0]    <= x37_Reg[7:0];        // Delay for MPPC                   
            4'h8:    rdDataD[7:0]    <= x38_Reg[7:0];        // Delay for Old hodoscope PMT      
            4'h9:    rdDataD[7:0]    <= x39_Reg[7:0];        // Delay for All Old hodoscope PMTs
            4'hA:    rdDataD[7:0]    <= x3A_Reg[7:0];        // Delay for New hodoscope PMT      
            4'hB:    rdDataD[7:0]    <= x3B_Reg[7:0];        // NC                               
            4'hC:    rdDataD[7:0]    <= x3C_Reg[7:0];        // NC                               
            4'hD:    rdDataD[7:0]    <= x3D_Reg[7:0];        // NC                               
            4'hE:    rdDataD[7:0]    <= x3E_Reg[7:0];        // NC                               
            4'hF:    rdDataD[7:0]    <= x3F_Reg[7:0];        // NC                               
=======
            4'h4:    rdDataD[7:0]    <= x34_Reg[7:0];        // Delay for Beam hodoscope [ 7:0]
            4'h5:    rdDataD[7:0]    <= x35_Reg[7:0];        // Delay for Timing counter [15:0]
            4'h6:    rdDataD[7:0]    <= x36_Reg[7:0];        // Delay for Timing counter [ 7:0]
            4'h7:    rdDataD[7:0]    <= x37_Reg[7:0];        // Delay for MPPC                 
            4'h8:    rdDataD[7:0]    <= x38_Reg[7:0];        // Delay for Old hodoscope PMT    
            4'h9:    rdDataD[7:0]    <= x39_Reg[7:0];        // Delay for All Old hodoscope PMT
            4'hA:    rdDataD[7:0]    <= x3A_Reg[7:0];        // Delay for New hodoscope PMT    
            4'hB:    rdDataD[7:0]    <= x3B_Reg[7:0];        // NC                         
            4'hC:    rdDataD[7:0]    <= x3C_Reg[7:0];        // NC                         
            4'hD:    rdDataD[7:0]    <= x3D_Reg[7:0];        // NC                         
            4'hE:    rdDataD[7:0]    <= x3E_Reg[7:0];        // NC                         
            4'hF:    rdDataD[7:0]    <= x3F_Reg[7:0];        // NC                         
>>>>>>> 82d30bcdddea1ab3a785b38cc9ca2d00db4d7f72
        endcase

        regRv[3:0]    <= (irRe    ? regCs[3:0] : 8'd0);
        regAck        <= (|regCs[3:0]) & (irWe | irRe);
    end

    reg     [7:0]    orRd ;
    reg              orAck;

    always@ (posedge CLK) begin
        orRd[7:0]  <=   (regRv[0]  ? rdDataA[7:0] : 8'd0)|
                        (regRv[1]  ? rdDataB[7:0] : 8'd0)|
                        (regRv[2]  ? rdDataC[7:0] : 8'd0)|
                        (regRv[3]  ? rdDataD[7:0] : 8'd0);
        orAck      <=   regAck;
    end

    assign  LOC_ACK        = orAck     ;
    assign  LOC_RD[7:0]    = orRd[7:0] ;

    assign  REG_MODE[2:0]  = x00_Reg[2:0];
    assign  REG_START      = x01_Reg[0];   // Start data transfer
    assign  REG_RESET      = x02_Reg[0];   // Reset status

    assign  REG_HEADER[31:0] = {x08_Reg[7:0],x09_Reg[7:0],x0A_Reg[7:0],x0B_Reg[7:0]}; // Header
    assign  REG_FOOTER[31:0] = {x0C_Reg[7:0],x0D_Reg[7:0],x0E_Reg[7:0],x0F_Reg[7:0]}; // Footer

    assign  REG_GPIO_POLER[1:0] = x2F_Reg[1:0];

    assign  REG_CHMASK0[63:0]  = {x10_Reg[7:0],x11_Reg[7:0],x12_Reg[7:0],x13_Reg[7:0],
                                 x14_Reg[7:0],x15_Reg[7:0],x16_Reg[7:0],x17_Reg[7:0]};
    assign  REG_CHMASK1[15:0] = {x18_Reg[7:0],x19_Reg[7:0]};

    assign  REG_SPLCNT_RST       = x1D_Reg;

    assign  REG_TEST_PSPILL_EN        = x2C_Reg;
    assign  REG_TEST_MRSYNC_EN        = x2D_Reg;
    assign  REG_TEST_PSPILL_POS[31:0] = {x20_Reg[7:0],x21_Reg[7:0],x22_Reg[7:0],x23_Reg[7:0]};
    assign  REG_TEST_PSPILL_NEG[31:0] = {x24_Reg[7:0],x25_Reg[7:0],x26_Reg[7:0],x27_Reg[7:0]};
    assign  REG_TEST_MRSYNC_FRQ[31:0] = {x28_Reg[7:0],x29_Reg[7:0],x2A_Reg[7:0],x2B_Reg[7:0]};

<<<<<<< HEAD
    assign  REG_DLYL_PSPILL[7:0]     = x30_Reg[7:0];
    assign  REG_DLYL_MRSYNC[7:0]     = x31_Reg[7:0];
    assign  REG_DLYL_EVMATCH[7:0]    = x32_Reg[7:0];
    assign  REG_DLYL_BH[15:0]        = {x33_Reg[7:0], x34_Reg[7:0]};
    assign  REG_DLYL_TC[15:0]        = {x35_Reg[7:0], x36_Reg[7:0]};
    assign  REG_DLYL_MPPC[7:0]       = x37_Reg[7:0];
    assign  REG_DLYL_OLD_PMT[7:0]    = x38_Reg[7:0];
    assign  REG_DLYL_ALLOLD_PMT[7:0] = x39_Reg[7:0];
    assign  REG_DLYL_NEW_PMT[7:0]    = x3A_Reg[7:0];
//assign  REG_DLY_PMT[95:0]    = {x3F_Reg[7:0], x3E_Reg[7:0], x3D_Reg[7:0], x3C_Reg[7:0], x3B_Reg[7:0], x3A_Reg[7:0], x39_Reg[7:0], x38_Reg[7:0], x37_Reg[7:0], x36_Reg[7:0], x35_Reg[7:0], x34_Reg[7:0]};

=======
    assign  REG_DLYL_PSPILL[7:0]  = x30_Reg[7:0];
    assign  REG_DLYL_MRSYNC[7:0]  = x31_Reg[7:0];
    assign  REG_DLYL_EVMATCH[7:0] = x32_Reg[7:0];
    assign  REG_DLYL_BH[15:8]     = x33_Reg[7:0];
    assign  REG_DLYL_BH[7:0]      = x34_Reg[7:0];
    assign  REG_DLYL_TC[15:8]     = x35_Reg[7:0];
    assign  REG_DLYL_TC[7:0]      = x36_Reg[7:0];
    assign  REG_DLYL_MPPC[7:0]    = x37_Reg[7:0];
    assign  REG_DLYL_OLD_PMT[7:0] = x38_Reg[7:0];
    assign  REG_DLYL_ALLOLD_PMT[7:0] = x39_Reg[7:0];
    assign  REG_DLYL_NEW_PMT[7:0] = x3A_Reg[7:0];
//    assign  REG_DLYL_PMT[95:0]    = {x3F_Reg[7:0], x3E_Reg[7:0], x3D_Reg[7:0], x3C_Reg[7:0], x3B_Reg[7:0], x3A_Reg[7:0], x39_Reg[7:0], x38_Reg[7:0], x37_Reg[7:0], x36_Reg[7:0], x35_Reg[7:0], x34_Reg[7:0]};

    assign  REG_SPLDIV[3:0] = x1A_Reg[3:0];
>>>>>>> 82d30bcdddea1ab3a785b38cc9ca2d00db4d7f72
endmodule
