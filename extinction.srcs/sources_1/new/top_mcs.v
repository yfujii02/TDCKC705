`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2020 14:18:13
// Design Name: 
// Module Name: top_mcs
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
// Multi-Channel Scalar
//  64 channel, maximum 1088 CLK ticks -> corresponding to 5.44us time window with 200MHz CLK
//  relative to the start timing.
//
//  Data format is as follows:
//  HEADER: ??-bit
//   AA AA AA AA 00 00 SPLCOUNT[15:0]
//
//  64ch
//      0:   CH0[15:0],CH1[15:0],...,CH62[15:0],CH63[15:0]
//      1:   CH0[15:0],CH1[15:0],...,CH62[15:0],CH63[15:0]
//      2:   CH0[15:0],CH1[15:0],...,CH62[15:0],CH63[15:0]
//     ...   ...
//   1086:   CH0[15:0],CH1[15:0],...,CH62[15:0],CH63[15:0]
//   1087:   CH0[15:0],CH1[15:0],...,CH62[15:0],CH63[15:0]
//  FOOTER: ??-bit
//   FF FF FF FF NMRSYNC[31:0]
// 
//////////////////////////////////////////////////////////////////////////////////


module top_mcs(
    input   wire            RESET     ,
    input   wire            CLK_200M  ,
    input   wire   [63:0]   SIGNAL    ,
    input   wire            PSPILL    ,
    input   wire            MR_SYNC   ,
    input   wire   [11:0]   OLDH      , // PMT inputs including COINCIDENCE
    input   wire            EV_MATCH  ,
    input   wire            TCP_BUSY  ,
    input   wire            START     ,
    input   wire    [3:0]   BOARD_ID  ,
    output  wire   [ 7:0]   OUTDATA   ,
    output  wire            SEND_EN
    );
//*******************************************************************************
//
//     Get spill information
//
//*******************************************************************************
    wire            SPILL_EDGE ;
    wire    [31:0]  SPILLCOUNT ;
    wire    [15:0]  EM_COUNT   ;
    GET_SPILLINFO get_spillInfo(
        .RESET     (RESET     ),
        .CLK_200M  (CLK_200M  ),
        .PSPILL    (PSPILL    ),
        .MR_SYNC   (MR_SYNC   ),
        .SPILLCOUNT(SPILLCOUNT),
        .SPILL_EDGE(SPILL_EDGE),
        .EV_MATCH  (EV_MATCH  ),
        .EM_COUNT  (EM_COUNT  )
    );

    reg  [10:0]    relCNTR; // counter relative to MR_SYNC

    always @ (posedge CLK_200M) begin
        if(RESET) begin
            relCNTR <= 11'd0;
        end else begin
            if (MR_SYNC) begin
                relCNTR <= 11'd0;
            end else begin
                relCNTR <= relCNTR + 11'd1;
            end
        end
    end

    reg             ENABLE  ; // Enable on until the spill end
    reg     [31:0]  NMRSYNC ; // Number of MRSync

    always @ (posedge CLK_200M) begin
        if(RESET) begin
            ENABLE    <=  1'b0;
            NMRSYNC   <= 32'd0;
        end else begin
            if (PSPILL)begin
                if (MR_SYNC) begin
                    NMRSYNC <= NMRSYNC+32'd1;
                end
                if (NMRSYNC>32'd0) begin
                    ENABLE    <= 1'b1;
                end
            end else begin
                ENABLE    <= 1'b0;
                NMRSYNC   <= 32'd0;
            end
        end
    end

    parameter NCHANNEL = 74; /// PMT(10) + MPPC(64)
    parameter DLENGTH  = 16; /// Length of each data/bin

    wire                      EOD     ;
    wire    [NCHANNEL*16-1:0] DCOUNTER;
    wire               [10:0] LENGTH  ;
    wire    [NCHANNEL-1:0]    INPUT   ;
    assign INPUT = {OLDH[9:0],SIGNAL[63:0]}; /// read out 10 PMT channels 
                                             ///  including two ext. PMTs in the new hodoscope.
genvar i;
generate
    for (i = 0; i < NCHANNEL; i = i+1) begin: SUM_UP
        SHIFT_COUNTER shift_cntr(
            .RST    (RESET    ),
            .CLK    (CLK_200M ),
            .EN     (ENABLE&START),
            .SIG    (INPUT[i] ),
            .EOD    (EOD      ), // end of data sending
            .RELCNTR(relCNTR  ),
            .RLENGTH(LENGTH   ),
            .COUNTER(DCOUNTER[i*16+15:i*16])
        );
    end
endgenerate

    DATA_SEND_MCS data_send_mcs(
        .RST     (RESET     ),
        .CLK     (CLK_200M  ),
        .ENABLE  (ENABLE&START),
        .TCP_FULL(TCP_FULL  ),
        .LENGTH  (LENGTH    ),
        .SPLCOUNT(SPILLCOUNT[15:0]),
        .EM_COUNT(EM_COUNT  ),
        .NMRSYNC (NMRSYNC   ),
        .EOD     (EOD       ),
        .DCOUNTER(DCOUNTER  ),
        .DOUT    (OUTDATA   ),
        .SEND_EN (SEND_EN   )
    );

endmodule
