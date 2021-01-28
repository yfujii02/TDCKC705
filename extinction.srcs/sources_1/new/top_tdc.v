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
    output   wire    [31:0]    SPILLCOUNT     ,
    output   wire     [7:0]    OUTDATA        ,
    output   wire              SEND_EN        ,
    output   wire              DEBUG_DATA_EN  ,
    output   wire              DEBUG_DATA_END ,
    output   wire     [7:0]    DEBUG_DLY_EN   ,
    output   wire              DEBUG_RD_EN    ,
    output   wire     [7:0]    DEBUG_CNT      ,
    output   wire    [15:0]    DEBUG_FIFO_CNT ,
    output   wire     [7:0]    DEBUG_SPLOFFCNT,
    output   wire     [2:0]    DEBUG_DLYSPLCNT
    );
//*******************************************************************************
//
//     Get spill information
//
//*******************************************************************************
    wire            SPILL_EDGE ;
    wire    [15:0]  EM_COUNT   ;
    GET_SPILLINFO get_spillInfo(
        .RESET     (RESET     ),
        .CLK_200M  (CLK_200M  ),
        .PSPILL    (PSPILL    ),
        .MR_SYNC   (MR_SYNC   ),
        .SPILLCOUNT(SPILLCOUNT),
        .SPILL_EDGE(SPL_EDGE  ),
        .SPILL_EDGE(SPL_END   ),
        .EV_MATCH  (EV_MATCH  ),
        .EM_COUNT  (EM_COUNT  ),
        .DEBUG_SPLOFFCNT(DEBUG_SPLOFFCNT),
        .DEBUG_DLYSPLCNT(DEBUG_DLYSPLCNT)
    );

    always@ (posedge CLK_200M) begin
        if(RESET)begin
            COUNTER   <= 32'd0;
        end else begin
            if(SPILL_EDGE)begin
                COUNTER   <= 32'd0;
            end else begin
                COUNTER   <= COUNTER + 32'd1;
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
        .DOUT       (OUTDATA[7:0]    ), // out: Output data [7:0]                           
        .SEND_EN    (SEND_EN         ), // out: Send packet enable                          
        .TCP_FULL   (TCP_BUSY        ), // in : TCP Full flag                               
        .DEBUG_DATA_EN (DEBUG_DATA_EN       ), // out:
        .DEBUG_DATA_END(DEBUG_DATA_END      ), // out:
        .DEBUG_DLY_EN  (DEBUG_DLY_EN[7:0]   ), // out:
        .DEBUG_RD_EN   (DEBUG_RD_EN         ), // out:
        .DEBUG_CNT     (DEBUG_CNT[7:0]      ), // out:
        .DEBUG_FIFO_CNT(DEBUG_FIFO_CNT[15:0])  // out:
    );
endmodule
