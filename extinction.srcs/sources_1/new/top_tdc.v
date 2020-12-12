`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2020 14:17:43
// Design Name: 
// Module Name: top_tdc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_tdc(
    input    wire              RESET      ,
    input    wire              CLK_200M   ,

    input    wire    [63:0]    SIGNAL     ,
    input    wire              PSPILL     ,
    input    wire              MR_SYNC    ,
    input    wire    [11:0]    OLDH       ,
    input    wire              EV_MATCH   ,
    input    wire              TCP_BUSY   ,
    input    wire              START      ,
    input    wire    [3:0]     BOARD_ID   ,
    input    wire   [31:0]     HEADER     ,
    input    wire   [31:0]     FOOTER     ,
    output   wire              TRIGGER_INT,
    output   wire   [15:0]     SPILLCOUNT ,
    output   wire    [7:0]     OUTDATA    ,
    output   wire              SEND_EN    ,
    output   wire              DEBUG_DATA_EN,
    output   wire              DEBUG_DATA_END,
    output   wire   [15:0]     DEBUG_FIFO_CNT
    );
//*******************************************************************************
//
//     TDC count-up
//
//*******************************************************************************
    reg      [1:0]    SPL_REG   ;
    reg               SPL_EDGE  ;
    reg               SPL_END   ;
    reg      [1:0]    EM_REG    ;
    reg               EM_EDGE   ;
    reg     [31:0]    COUNTER   ;
    reg     [15:0]  irSPILLCOUNT; // Spill counter
    assign SPILLCOUNT = irSPILLCOUNT;

    always@ (posedge CLK_200M) begin
        if(RESET)begin
            SPL_REG    <= 2'b00;
            SPL_EDGE   <= 1'b0;
            SPL_END    <= 1'b0;
            irSPILLCOUNT <= 16'd0;

            EM_REG     <= 2'b00;
            EM_EDGE    <= 1'b0;
        end else begin
            SPL_REG    <= {SPL_REG[0],PSPILL};
            SPL_EDGE   <= (SPL_REG==2'b01);
            SPL_END    <= (SPL_REG==2'b10);
            irSPILLCOUNT <= (SPL_END==1'b1)? irSPILLCOUNT+16'd1 : irSPILLCOUNT;

            EM_REG     <= {EM_REG[0],EV_MATCH};
            EM_EDGE    <= (EM_REG==2'b01);
        end
    end

    reg    [15:0]    EMCOUNTER ; // Counter for Event matching signal
    reg              EMDONE    ;
    reg    [15:0]    regEMCNTR ;
    reg              EN_EMCOUNT;

    always@ (posedge CLK_200M) begin
        if(RESET)begin
            COUNTER   <= 32'd0;
            EMCOUNTER <= 16'd0;
            regEMCNTR <= 16'd0;
            EN_EMCOUNT<=  1'b0;
            EMDONE    <=  1'b0;
        end else begin
            if(SPL_EDGE)begin
                COUNTER   <= 32'd0;
                EMCOUNTER <= 16'd0;
                regEMCNTR <= 16'd0;
                EN_EMCOUNT<=  1'b0;
                EMDONE    <=  1'b0;
            end else begin
                COUNTER   <= COUNTER + 32'd1;
            end

            if(MR_SYNC & ~EMDONE)begin
                if(EM_EDGE & (EMCOUNTER==16'd0))begin
                    EN_EMCOUNT <=  1'b1;
                end
            end
            if(EN_EMCOUNT & ~EMDONE)begin
                EMCOUNTER  <= EMCOUNTER + 16'd1;
            end
            if(EMCOUNTER>16'd0 & EM_EDGE & (regEMCNTR==16'd0))begin
                EN_EMCOUNT <= 1'b0;
                regEMCNTR  <= EMCOUNTER;
                EMDONE     <= 1'b1;
            end
        end
    end

    wire    [76:0]  SIG;
    assign SIG[76:0] = {SIGNAL[63:0],OLDH[11:0],MR_SYNC};

    reg     [76:0]  irSIG;
    reg     [31:0]  irCOUNTER;
    reg             irDATATRG;
    always@ (posedge CLK_200M) begin
        if(RESET)begin
            irSIG[76:0]     <= 77'd0;
            irCOUNTER[31:0] <= 32'd0;
            irDATATRG       <= 1'b0;
        end else begin
            if(|SIG)begin
                irCOUNTER[31:0] <= COUNTER[31:0];
                irDATATRG       <= 1'b1;
            end else begin
                irCOUNTER[31:0] <= irCOUNTER[31:0];
                irDATATRG       <= 1'b0;
            end
            irSIG[76:0] <= SIG[76:0];
        end
    end

    wire    [83:0]  irHeader;
    wire    [83:0]  irFooter;
    assign irHeader = {20'hA_BB_00,HEADER[31:0],HEADER[31:0]};
    assign irFooter = {20'hF_EE_00,FOOTER[31:0],FOOTER[31:0]};

    DATA_BUF_singleBRAM2 DATA_BUF(
        .RST     (RESET       ),
        .CLK     (CLK_200M    ),
        .DATA_TRG(irDATATRG   ),
        .COUNTER (irCOUNTER   ),
        .SPLSTART(SPL_EDGE    ),
        .SPLEND  (SPL_END     ),
        .SPLCOUNT(SPILLCOUNT  ),
        .SIG     (irSIG[76:0] ),
        .START   (START       ),
        .EMCOUNT (regEMCNTR   ),
        .BOARD_ID(BOARD_ID    ), // in [ 3:0]
        .HEADER  (irHeader    ), // in [83:0]
        .FOOTER  (irFooter    ), // in [83:0]
        .TRIGGER_INT(TRIGGER_INT),
        .DOUT    (OUTDATA[7:0]),
        .SEND_EN (SEND_EN     ),
        .TCP_FULL(TCP_BUSY    ),
        .DEBUG_DATA_EN (DEBUG_DATA_EN),
        .DEBUG_DATA_END(DEBUG_DATA_END),
        .DEBUG_FIFO_CNT(DEBUG_FIFO_CNT)
    );
endmodule
