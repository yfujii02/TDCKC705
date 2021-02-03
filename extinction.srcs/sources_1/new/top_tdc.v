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
    input    wire              RESET          ,
    input    wire              CLK_200M       ,
    input    wire              SPLCNT_RST     ,
    input    wire              INT_SPLCNT_RST ,
    input    wire     [7:0]    INT_SPLCNT_RSTT,
    output   wire              EX_SPLCNT_RST  ,

    input    wire    [63:0]    SIGNAL         ,
    input    wire              PSPILL         ,
    input    wire              MR_SYNC        ,
    input    wire    [11:0]    OLDH           ,
    input    wire              EV_MATCH       ,
    input    wire              TCP_BUSY       ,
    input    wire              START          ,
    input    wire     [3:0]    BOARD_ID       ,
    input    wire    [31:0]    HEADER         ,
    input    wire    [31:0]    FOOTER         ,
    output   wire              TRIGGER_INT    ,
    
    output   wire              FIFO_EMPTY     , // out: FIFO empty 
    output   wire              FIFO_READY     , // out: FIFO ready 
    input    wire              FIFO_RD_EN     , // in : FIFO read enable
    output   wire   [111:0]    DATA_OUT       , // out: FIFO data out
    output   wire              DATA_VALID     , // out: FIFO data valid

    output   wire    [31:0]    SPILLCOUNT     ,
    output   wire     [7:0]    OUTDATA        ,
    output   wire              SEND_EN        ,
    output   wire              DEBUG_DATA_EN  ,
    output   wire              DEBUG_DATA_END ,
    output   wire     [7:0]    DEBUG_DLY_EN   ,
    output   wire              DEBUG_RD_EN    ,
    output   wire     [7:0]    DEBUG_CNT      ,
    output   wire     [7:0]    DEBUG_SPLOFFCNT,
    output   wire     [2:0]    DEBUG_DLYSPLCNT
    );
//*******************************************************************************
//
//     TDC count-up
//
//*******************************************************************************
    reg      [1:0]    SPL_REG     ;
    reg               SPL_EDGE    ;
    reg               SPL_END     ;
    reg      [1:0]    EM_REG      ;
    reg               EM_EDGE     ;
    reg     [31:0]    COUNTER     ;
    reg     [31:0]    irSPILLCOUNT; // Spill counter
    assign SPILLCOUNT = irSPILLCOUNT;

    always@ (posedge CLK_200M) begin
        if(RESET)begin
            SPL_REG      <= 2'b00;
            SPL_EDGE     <= 1'b0;
            SPL_END      <= 1'b0;
            irSPILLCOUNT <= 32'd0;

            EM_REG       <= 2'b00;
            EM_EDGE      <= 1'b0;
        end else begin
            SPL_REG      <= {SPL_REG[0],PSPILL};
            SPL_EDGE     <= (SPL_REG==2'b01);
            SPL_END      <= (SPL_REG==2'b10);
            if(SPLCNT_RST) begin
              irSPILLCOUNT <= 32'd0;
            end else begin
              irSPILLCOUNT <= (SPL_END==1'b1) ? irSPILLCOUNT+32'd1 : irSPILLCOUNT;
            end

            EM_REG       <= {EM_REG[0],EV_MATCH};
            EM_EDGE      <= (EM_REG==2'b01);
        end
    end

    reg     [7:0]    spl_off_cnt ;
    reg     [2:0]    dlySplCntRst;
    always@(posedge CLK_200M) begin
        if(RESET || SPL_END)begin
            spl_off_cnt[7:0] <= 8'd0;
        end else if(spl_off_cnt[7:0]==8'hFF) begin
            spl_off_cnt[7:0] <= spl_off_cnt[7:0];
        end else begin
            spl_off_cnt[7:0] <= spl_off_cnt[7:0] + 8'd1;
        end

        if(RESET) begin
            dlySplCntRst[2:0] <= 3'b000;
        end else if(INT_SPLCNT_RST) begin
            dlySplCntRst[2:0] <= 3'b111;
        end else if(spl_off_cnt[7:0]==INT_SPLCNT_RSTT[7:0]) begin
            dlySplCntRst[2:0] <= dlySplCntRst[0] ? 3'b010 : {dlySplCntRst[1:0], 1'b0};
        end else begin
            dlySplCntRst[2:0] <= dlySplCntRst[0] ? 3'b111 : {dlySplCntRst[1:0], 1'b0};
        end
    end
    assign EX_SPLCNT_RST = dlySplCntRst[2] ^ dlySplCntRst[1]; // H within 2 CLK
    assign DEBUG_SPLOFFCNT[7:0] = spl_off_cnt[7:0];
    assign DEBUG_DLYSPLCNT[2:0] = dlySplCntRst[2:0];

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

    DATA_BUF_singleBRAM2 DATA_BUF(
        .RST        (RESET           ), // in : System Reset                                
        .CLK        (CLK_200M        ), // in : System CLK                                  
        .DATA_TRG   (irDATATRG       ), // in : Trigger for signals                         
        .COUNTER    (irCOUNTER[31:0] ), // in : Counter value [31:0]                        
        .SPLSTART   (SPL_EDGE        ), // in : Start Spill (Enable When Spill Signal Comes)
        .SPLEND     (SPL_END         ), // in : End Spill                                   
        .SPLCOUNT   (SPILLCOUNT[15:0]), // in : Header (Header[7:0] SPILL Count [7:0])      
        .SIG        (irSIG[76:0]     ), // in : MRSYNC[76], OLDH[76:64], Hodoscope[63:0]    
        .START      (START           ), // in : DAQ start signal                            
        .EMCOUNT    (regEMCNTR[15:0] ), // in : Event matching count [15:0]                 
        .BOARD_ID   (BOARD_ID[3:0]   ), // in : Board ID [3:0]
        .HEADER     (HEADER[31:0]    ), // in : Header [83:0]
        .FOOTER     (FOOTER[31:0]    ), // in : Footer [83:0]
        .TRIGGER_INT(TRIGGER_INT     ), // out: Internal trigger to readout the data        

        .FIFO_EMPTY (FIFO_EMPTY      ), // out: FIFO empty
        .FIFO_READY (FIFO_READY      ), // out: FIFO ready
        .FIFO_RD_EN (FIFO_RD_EN      ), // in : FIFO read enable
        .DATA_OUT   (DATA_OUT[111:0] ), // out: FIFO data out
        .DATA_VALID (DATA_VALID      ), // out: FIFO data valid

        .DOUT       (OUTDATA[7:0]    ), // out: Output data [7:0]                           
        .SEND_EN    (SEND_EN         ), // out: Send packet enable                          
        .TCP_FULL   (TCP_BUSY        ), // in : TCP Full flag                               
        .DEBUG_DATA_EN (DEBUG_DATA_EN       ), // out:
        .DEBUG_DATA_END(DEBUG_DATA_END      ), // out:
        .DEBUG_DLY_EN  (DEBUG_DLY_EN[7:0]   ), // out:
        .DEBUG_RD_EN   (DEBUG_RD_EN         ), // out:
        .DEBUG_CNT     (DEBUG_CNT[7:0]      )  // out:
    );
endmodule
