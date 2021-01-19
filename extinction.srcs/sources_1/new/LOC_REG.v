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
    input   wire    CLK                 ,    // Clock
    input   wire    RST                 ,    // System reset

    // Register I/F
    input   wire    [31:0]  LOC_ADDR    ,    // Address[31:0]
    input   wire     [7:0]  LOC_WD      ,    // Data[7:0]
    input   wire            LOC_WE      ,    // Write enable
    input                   LOC_RE      ,    // Read enable
    output  wire            LOC_ACK     ,    // Access acknowledge
    output  wire     [7:0]  LOC_RD      ,    // Read data[7:0]
    // Registers
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
    output  wire    [63:0]  REG_CHMASK  ,    // mask input channels
    output  wire    [14:0]  REG_CHMASK2 ,    // mask input channels (OLDH)
    output  wire            REG_FMC_DBG ,    // enable FMC debug pin (HPC_LA33,32)
    output  wire     [7:0]  REG_DLY_TEST     // delay for fast_test signal [7:0]
);
//------------------------------------------------------------------------------
//    Input buffer
//------------------------------------------------------------------------------
    reg       [1:0]  regCs           ;
    reg      [10:0]  irAddr          ;
    reg              irWe            ;
    reg              irRe            ;
    reg       [7:0]  irWd            ;

    always@ (posedge CLK) begin
        regCs[0]     <= (LOC_ADDR[31:4]==28'h0);
        regCs[1]     <= (LOC_ADDR[31:4]==28'h1);
        //regCs[2]     <= (LOC_ADDR[31:4]==28'h2);

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
    reg              x1A_Reg   ;
    reg     [7:0]    x1B_Reg   ; // Delay for the test signal
    reg     [7:0]    x1C_Reg   ; // NC
    reg     [3:0]    x1D_Reg   ; // Spill Div for MCS
    reg     [7:0]    x1E_Reg   ; // NC
    reg     [7:0]    x1F_Reg   ; // NC

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

            x10_Reg[7:0]    <= 8'h00;
            x11_Reg[7:0]    <= 8'h00;   //
            x12_Reg[7:0]    <= 8'h00;   //
            x13_Reg[7:0]    <= 8'h00;   //
            x14_Reg[7:0]    <= 8'h00;   //
            x15_Reg[7:0]    <= 8'h00;   //
            x16_Reg[7:0]    <= 8'h00;   //
            x17_Reg[7:0]    <= 8'h00;   //
            x18_Reg[7:0]    <= 8'h00;   //
            x19_Reg[7:0]    <= 8'h00;   //
            x1A_Reg         <= 1'd0 ;   //
            x1B_Reg[7:0]    <= 8'h10;   // Delay for the test signal
            x1C_Reg[7:0]    <= 8'h1C;   //
            x1D_Reg[3:0]    <= 4'hF;    //
            x1E_Reg[7:0]    <= 8'hFF;   //
            x1F_Reg[7:0]    <= 8'hFF;   //

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
                x1A_Reg         <= (regCs[1] & (irAddr[3:0]==4'hA) ? irWd[0:0] : x1A_Reg);
                x1B_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x1B_Reg[7:0]);
                x1D_Reg[3:0]    <= (regCs[1] & (irAddr[3:0]==4'hD) ? irWd[3:0] : x1D_Reg[3:0]);
            end
        end
    end

    reg      [7:0]    rdDataA ;
    reg      [7:0]    rdDataB ;
    reg      [1:0]    regRv   ;
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
            4'h0:    rdDataB[7:0]    <= x10_Reg[7:0];    // Channel mask [63:56]
            4'h1:    rdDataB[7:0]    <= x11_Reg[7:0];    // Channel mask [55:48]
            4'h2:    rdDataB[7:0]    <= x12_Reg[7:0];    // Channel mask [47:40]
            4'h3:    rdDataB[7:0]    <= x13_Reg[7:0];    // Channel mask [39:32]
            4'h4:    rdDataB[7:0]    <= x14_Reg[7:0];    // Channel mask [31:24]
            4'h5:    rdDataB[7:0]    <= x15_Reg[7:0];    // Channel mask [23:16]
            4'h6:    rdDataB[7:0]    <= x16_Reg[7:0];    // Channel mask [15: 8]
            4'h7:    rdDataB[7:0]    <= x17_Reg[7:0];    // Channel mask [ 7: 0]
            4'h8:    rdDataB[7:0]    <= x18_Reg[7:0];    // Channel mask 2 [14:8] ([7]:nc)
            4'h9:    rdDataB[7:0]    <= x19_Reg[7:0];    // Channel mask 2 [ 7:0]
            4'hA:    rdDataB[7:0]    <= {7'd0,x1A_Reg};  // Using FMC debug
            4'hB:    rdDataB[7:0]    <= 8'h1B;    // NC
            4'hC:    rdDataB[7:0]    <= 8'h1C;    // NC
            4'hD:    rdDataB[7:0]    <= {4'h0,x1D_Reg[3:0]};// Spill Div for MCS
            4'hE:    rdDataB[7:0]    <= 8'h00;    // NC
            4'hF:    rdDataB[7:0]    <= 8'h00;    // NC
        endcase

        regRv[1:0]    <= (irRe    ? regCs[1:0] : 8'd0);
        regAck        <= (|regCs[1:0]) & (irWe | irRe);
    end

    reg     [7:0]    orRd ;
    reg              orAck;

    always@ (posedge CLK) begin
        orRd[7:0]  <=   (regRv[0]  ? rdDataA[7:0] : 8'd0)|
                        (regRv[1]  ? rdDataB[7:0] : 8'd0);
        orAck      <=   regAck;
    end

    assign  LOC_ACK        = orAck     ;
    assign  LOC_RD[7:0]    = orRd[7:0] ;

    assign  REG_MODE[2:0]  = x00_Reg[2:0];
    assign  REG_START      = x01_Reg[0];   // Start data transfer
    assign  REG_RESET      = x02_Reg[0];   // Reset status

    assign  REG_HEADER[31:0] = {x08_Reg[7:0],x09_Reg[7:0],x0A_Reg[7:0],x0B_Reg[7:0]}; // Header
    assign  REG_FOOTER[31:0] = {x0C_Reg[7:0],x0D_Reg[7:0],x0E_Reg[7:0],x0F_Reg[7:0]}; // Footer

    assign  REG_CHMASK[63:0]  = {x10_Reg[7:0],x11_Reg[7:0],x12_Reg[7:0],x13_Reg[7:0],
                                 x14_Reg[7:0],x15_Reg[7:0],x16_Reg[7:0],x17_Reg[7:0]};
    assign  REG_CHMASK2[14:0] = {x18_Reg[6:0],x19_Reg[7:0]};

    assign  REG_SPLDIV[3:0] = x1D_Reg[3:0];

    assign  REG_FMC_DBG     = x1A_Reg;
    assign  REG_DLY_TEST    = x1B_Reg[7:0]; // Delay for the test signal w.r.t TEST[0]
endmodule
