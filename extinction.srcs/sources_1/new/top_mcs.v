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
    output  wire   [31:0]   SPILLCOUNT,
    input   wire   [ 3:0]   SPILLDIV  ,
    output  reg    [ 7:0]   OUTDATA   ,
    output  reg             SEND_EN
    );
//*******************************************************************************
//
//     Get spill information
//
//*******************************************************************************
    wire            SPILL_EDGE ;
    wire    [15:0]  EM_COUNT   ;
    GET_SPILLINFO get_spillInfo(
        .RESET     (~START    ),
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
    reg      [3:0]  enWrite ; // Enable switch for writing the data
    reg     [31:0]  NMRSYNC ; // Number of MRSync
    reg     [31:0]  regNSYNC; // Register to keep the number of MRSYNC
    reg             sw_mem  ;
    always @ (posedge CLK_200M) begin
        if(RESET) begin
            ENABLE    <=  1'b0;
            enWrite   <=  4'd0;
            NMRSYNC   <= 32'd0;
            regNSYNC  <= 32'd0;
        end else begin
            if (PSPILL&START)begin
                if (MR_SYNC) begin
                    NMRSYNC <= NMRSYNC+32'd1;
                end
                regNSYNC  <= NMRSYNC;
                if (NMRSYNC>32'd0) begin
                    ENABLE    <= 1'b1;
                end
                if (NMRSYNC==32'd1) begin
                    enWrite   <= 4'd1;
                end else begin
                    enWrite   <= (sw_mem==1'b1)? {enWrite[2:0],enWrite[3]} : enWrite;
                end
            end else begin
                enWrite   <= 4'd0;
                ENABLE    <= 1'b0;
                NMRSYNC   <= 32'd0;
            end
        end
    end

    always @ (posedge CLK_200M) begin
        if(RESET) begin
            sw_mem <= 1'b0;
        end else if (ENABLE) begin
            if ((|NMRSYNC[10:0])==1'b0) begin
                case (SPILLDIV)
                    4'h0 : sw_mem <= (NMRSYNC[11:11]==1'h1)? 1'b1 : 1'b0;
                    4'h1 : sw_mem <= (NMRSYNC[12:11]==2'h2)? 1'b1 : 1'b0;
                    4'h2 : sw_mem <= (NMRSYNC[13:11]==3'h4)? 1'b1 : 1'b0;
                    4'h3 : sw_mem <= (NMRSYNC[14:11]==4'h8)? 1'b1 : 1'b0;
                    4'h4 : sw_mem <= (NMRSYNC[15:11]==5'h10)? 1'b1 : 1'b0;
                    4'h5 : sw_mem <= (NMRSYNC[16:11]==6'h20)? 1'b1 : 1'b0;
                    4'h6 : sw_mem <= (NMRSYNC[17:11]==7'h40)? 1'b1 : 1'b0;
                    4'h7 : sw_mem <= (NMRSYNC[18:11]==8'h80)? 1'b1 : 1'b0;
                    4'h8 : sw_mem <= (NMRSYNC[19:11]==9'h100)? 1'b1 : 1'b0;
                    4'h9 : sw_mem <= (NMRSYNC[20:11]==10'h200)? 1'b1 : 1'b0;
                    default : sw_mem <= 1'b0;
                endcase
            end else begin
                sw_mem <= 1'b0;
            end
        end else begin
            sw_mem <= 1'b0;
        end
    end

    parameter NCHANNEL = 74; /// PMT(10) + MPPC(64)
    parameter DLENGTH  = 16; /// Length of each data/bin

    wire   [3:0]    EOD    ;
    reg    [7:0]  regEOD ; // Reg to check Edge of EOD
    reg    [3:0]    edgeEOD; // Edge of EOD
    always@ (posedge CLK_200M) begin
        if(RESET)begin
            regEOD[7:0]  <=  8'd0;
            edgeEOD[3:0] <=  4'd0;
        end else begin
            regEOD[7:0]  <= {regEOD[6],EOD[3],regEOD[4],EOD[2],regEOD[2],EOD[1],regEOD[0],EOD[0]};
            edgeEOD[3:0] <= {(regEOD[7:6]==2'b01),(regEOD[5:4]==2'b01),
                             (regEOD[3:2]==2'b01),(regEOD[1:0]==2'b01)};
        end
    end

    wire    [NCHANNEL*16-1:0] DCOUNTER0;
    wire    [NCHANNEL*16-1:0] DCOUNTER1;
    wire    [NCHANNEL*16-1:0] DCOUNTER2;
    wire    [NCHANNEL*16-1:0] DCOUNTER3;
    wire               [10:0] LENGTH0 ;
    wire               [10:0] LENGTH1 ;
    wire               [10:0] LENGTH2 ;
    wire               [10:0] LENGTH3 ;
    wire    [NCHANNEL-1:0]    INPUT   ;
    assign INPUT = {OLDH[9:0],SIGNAL[63:0]}; /// read out 10 PMT channels 
                                             ///  including two ext. PMTs in the new hodoscope.
genvar i;
generate
    for (i = 0; i < NCHANNEL; i = i+1) begin: SUM_UP
        SHIFT_COUNTER shift_cntr0(
            .RST    (RESET    ),
            .CLK    (CLK_200M ),
            .EN     (enWrite[0]&START),
            .SIG    (INPUT[i] ),
            .EOD    (edgeEOD[0]), // end of data sending
            .RELCNTR(relCNTR  ),
            .RLENGTH(LENGTH0  ),
            .COUNTER(DCOUNTER0[(i+1)*DLENGTH-1:i*DLENGTH])
        );
        SHIFT_COUNTER shift_cntr1(
            .RST    (RESET    ),
            .CLK    (CLK_200M ),
            .EN     (enWrite[1]&START),
            .SIG    (INPUT[i] ),
            .EOD    (edgeEOD[1]), // end of data sending
            .RELCNTR(relCNTR  ),
            .RLENGTH(LENGTH1  ),
            .COUNTER(DCOUNTER1[(i+1)*DLENGTH-1:i*DLENGTH])
        );
        SHIFT_COUNTER shift_cntr2(
            .RST    (RESET    ),
            .CLK    (CLK_200M ),
            .EN     (enWrite[2]&START),
            .SIG    (INPUT[i] ),
            .EOD    (edgeEOD[2]), // end of data sending
            .RELCNTR(relCNTR  ),
            .RLENGTH(LENGTH2  ),
            .COUNTER(DCOUNTER2[(i+1)*DLENGTH-1:i*DLENGTH])
        );
        SHIFT_COUNTER shift_cntr3(
            .RST    (RESET    ),
            .CLK    (CLK_200M ),
            .EN     (enWrite[3]&START),
            .SIG    (INPUT[i] ),
            .EOD    (edgeEOD[3]), // end of data sending
            .RELCNTR(relCNTR  ),
            .RLENGTH(LENGTH3  ),
            .COUNTER(DCOUNTER3[(i+1)*DLENGTH-1:i*DLENGTH])
        );
    end
endgenerate

    wire  [3:0]  sending;
    wire  [7:0]  OUTDATA0;
    wire  [7:0]  OUTDATA1;
    wire  [7:0]  OUTDATA2;
    wire  [7:0]  OUTDATA3;
    wire         SEND_EN0;
    wire         SEND_EN1;
    wire         SEND_EN2;
    wire         SEND_EN3;
generate
    for (i = 0; i < 4; i = i+1) begin: CHECK_DATA_SEND_STATUS
        sendStatus(.CLK  (CLK_200M),
                   .RST  (RESET   ),
                   .WRITE(enWrite[i]),
                   .EOD  (edgeEOD[i]),
                   .SEND (sending[i])
        );
    end
endgenerate

    always @(posedge CLK_200M)begin
        if (sending[0])begin
            OUTDATA <= OUTDATA0;
            SEND_EN <= SEND_EN0;
        end else if (sending[1])begin
            OUTDATA <= OUTDATA1;
            SEND_EN <= SEND_EN1;
        end else if (sending[2])begin
            OUTDATA <= OUTDATA2;
            SEND_EN <= SEND_EN2;
        end else if (sending[3])begin
            OUTDATA <= OUTDATA3;
            SEND_EN <= SEND_EN3;
        end else begin
            OUTDATA <= 8'hBB;
            SEND_EN <= 1'b0;
        end
    end

    wire    [3:0]   send_others;
    assign  send_others[3:0] = {|{sending[3:1]},|{sending[3:2],sending[0]},
                                |{sending[3],sending[1:0]},|{sending[2:0]}};
    DATA_SEND_MCS data_send_mcs0(
        .RST     (RESET     ),
        .CLK     (CLK_200M  ),
        .ENABLE  (enWrite[0]&START),
        .BUFLABEL(4'd0      ),
        .TCP_FULL(TCP_FULL|send_others[0]),
        .LENGTH  (LENGTH0   ),
        .SPLCOUNT(SPILLCOUNT[15:0]),
        .EM_COUNT(EM_COUNT  ),
        .NMRSYNC (regNSYNC  ),
        .EOD     (EOD[0]    ),
        .DCOUNTER(DCOUNTER0 ),
        .DOUT    (OUTDATA0  ),
        .SEND_EN (SEND_EN0  )
    );
    DATA_SEND_MCS data_send_mcs1(
        .RST     (RESET     ),
        .CLK     (CLK_200M  ),
        .ENABLE  (enWrite[1]&START),
        .BUFLABEL(4'd1      ),
        .TCP_FULL(TCP_FULL|send_others[1]),
        .LENGTH  (LENGTH1   ),
        .SPLCOUNT(SPILLCOUNT[15:0]),
        .EM_COUNT(EM_COUNT  ),
        .NMRSYNC (regNSYNC  ),
        .EOD     (EOD[1]    ),
        .DCOUNTER(DCOUNTER1 ),
        .DOUT    (OUTDATA1  ),
        .SEND_EN (SEND_EN1  )
    );
    DATA_SEND_MCS data_send_mcs2(
        .RST     (RESET     ),
        .CLK     (CLK_200M  ),
        .ENABLE  (enWrite[2]&START),
        .BUFLABEL(4'd2      ),
        .TCP_FULL(TCP_FULL|send_others[2]),
        .LENGTH  (LENGTH2   ),
        .SPLCOUNT(SPILLCOUNT[15:0]),
        .EM_COUNT(EM_COUNT  ),
        .NMRSYNC (regNSYNC  ),
        .EOD     (EOD[2]    ),
        .DCOUNTER(DCOUNTER2 ),
        .DOUT    (OUTDATA2  ),
        .SEND_EN (SEND_EN2  )
    );
    DATA_SEND_MCS data_send_mcs3(
        .RST     (RESET     ),
        .CLK     (CLK_200M  ),
        .ENABLE  (enWrite[3]&START),
        .BUFLABEL(4'd3      ),
        .TCP_FULL(TCP_FULL|send_others[3]),
        .LENGTH  (LENGTH3   ),
        .SPLCOUNT(SPILLCOUNT[15:0]),
        .EM_COUNT(EM_COUNT  ),
        .NMRSYNC (regNSYNC  ),
        .EOD     (EOD[3]    ),
        .DCOUNTER(DCOUNTER3 ),
        .DOUT    (OUTDATA3  ),
        .SEND_EN (SEND_EN3  )
    );

endmodule

module sendStatus(
    input   wire    CLK,
    input   wire    RST,
    input   wire    WRITE,
    input   wire    EOD,
    output  reg     SEND
);
    reg [1:0]   irWrite;

    always @(posedge CLK)begin
        if (RST) begin
            SEND    <= 1'b0;
            irWrite <= 2'd0;
        end else begin
            irWrite <= {irWrite[1],WRITE};
            if (irWrite==2'b10) begin
                SEND <= 1'b1;
            end else begin
                SEND <= (EOD==1'b1)? 1'b0 : SEND;
            end
        end
    end
endmodule
