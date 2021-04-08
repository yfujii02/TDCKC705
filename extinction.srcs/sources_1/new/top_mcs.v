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
    input   wire            SPLCNT_RST     ,
    input   wire            INT_SPLCNT_RST ,
    input   wire    [7:0]   INT_SPLCNT_RSTT,
    output  wire            EX_SPLCNT_RST  ,

    input   wire   [63:0]   SIGNAL    ,
    input   wire            PSPILL    ,
    input   wire            MR_SYNC   ,
    input   wire    [1:0]   BH        , // Beamline hodoscope
    input   wire    [1:0]   TC        , // Timing counter
    input   wire            OLDH_ALL  , // Old hodoscope ALL OR
    input   wire    [1:0]   NEWH      , // PMT from new hodoscope
    input   wire    [7:0]   OLDH      , // PMT from old hodoscope
    input   wire   [15:0]   EV_MATCH  ,
    input   wire            TCP_BUSY  ,
    input   wire            START     ,
    input   wire    [3:0]   BOARD_ID  ,
    output  wire   [31:0]   SPILLCOUNT,
    input   wire   [ 3:0]   SPILLDIV  ,
    output  reg    [ 7:0]   OUTDATA   ,
    output  reg             SEND_EN   ,
    output  wire   [ 7:0]   BUF_SWITCH,
    output  wire    [7:0]   DEBUG_SPLOFFCNT,
    output  wire    [2:0]   DEBUG_DLYSPLCNT
    );

    parameter NBUF     =  3; /// Number of cyclic buffers
    parameter NCHANNEL = 74; /// PMT(10) + MPPC(64)
    parameter DWIDTH   = 16; /// Width of each data/bin
    parameter DWIDTH_BUF = NCHANNEL*DWIDTH;

    //*******************************************************************************
    //
    //     Get spill information
    //
    //*******************************************************************************
    wire            SPILL_EDGE ;
//    wire    [15:0]  EM_COUNT   ;

    GET_SPILLINFO get_spillInfo(
        .RESET     (RESET     ),
        .CLK_200M  (CLK_200M  ),
        .SPLCNT_RST(SPLCNT_RST),
        .INT_SPLCNT_RST (INT_SPLCNT_RST      ),
        .INT_SPLCNT_RSTT(INT_SPLCNT_RSTT[7:0]),
        .EX_SPLCNT_RST  (EXOUT_SPLCNT_RST    ),
        .PSPILL    (PSPILL    ),
        .MR_SYNC   (MR_SYNC   ),
        .SPILLCOUNT(SPILLCOUNT),
        .SPILL_EDGE(SPILL_EDGE),
        .SPILL_END (          ),
//        .EV_MATCH  (EV_MATCH  ),
//        .EM_COUNT  (EM_COUNT  ),
        .DEBUG_SPLOFFCNT(DEBUG_SPLOFFCNT),
        .DEBUG_DLYSPLCNT(DEBUG_DLYSPLCNT)
    );

    wire    [NCHANNEL-1:0]    INPUT   ;
    CHECK_COINCIDENCE_MODULE make_coincidence(
        .CLK   (CLK_200M    ),
        .RST   (RESET       ),
        .MPPC  (SIGNAL[63:0]),  // MPPC
        .EPMT  (NEWH[1:0]   ),  // extra pmt
        .OLDHOD(OLDH[7:0]   ),
        .TC0   (TC[0]       ),
        .TC1   (TC[1]       ),
        .BH0   (BH[0]       ),
        .BH1   (BH[1]       ),
        .OHAOR (OLDH_ALL    ),
        .COINC (COIN        ),
        .SIGOUT(INPUT[73:0] )
    );

    reg             ENABLE  ; // Enable on until the spill end
    reg      [2:0]  enWrite ; // Enable switch for writing the data
    reg             enWriteMSB; // 1 clk delayed MSB of en write
    reg     [31:0]  NMRSYNC ; // Number of MRSync
    reg     [31:0]  regNSYNC; // Register to keep the number of MRSYNC
    reg             sw_mem  ;
    reg      [1:0]  irSw_mem; // To check the rising edge of sw_mem
    always @ (posedge CLK_200M) begin
        if(RESET) begin
            ENABLE    <=  1'b0;
            enWrite   <=  3'd0;
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
                    if (NMRSYNC==32'd1) begin
                        enWrite   <= 3'd1;
                    end else begin
                        enWrite   <= (irSw_mem==2'b01)? {enWrite[1:0],enWriteMSB} : enWrite;
                    end
                end else begin
                    enWrite <= 3'd0;
                    ENABLE  <= 1'b0;
                end
            end else begin
                enWrite   <= 3'd0;
                ENABLE    <= 1'b0;
                NMRSYNC   <= 32'd0;
            end
        end
    end
    always @ (posedge CLK_200M) begin
        enWriteMSB <= enWrite[2];
    end

    always @ (posedge CLK_200M) begin
        if(RESET) begin
            irSw_mem <= 2'd0;
        end else begin
            irSw_mem <= {irSw_mem[0],sw_mem};
        end
    end

    //*******************************************************************************
    //
    // Switch the memory buffer to be used to write the signal
    //  by cycling "sw_mem" every NMRSYNC
    //
    //*******************************************************************************
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

    wire    [4*NBUF-1:0]   label;
    assign label={4'd2,4'd1,4'd0}; /// FIXME constant labels for each buffer

    reg  [11*NBUF-1:0]   relCNTR; // counter relative to MR_SYNC
    wire   [NBUF-1:0]    EOD    ;
    reg    [2*NBUF-1:0]  regEOD ; // Reg to check Edge of EOD
    reg    [NBUF-1:0]    edgeEOD; // Edge of EOD
    reg    [NBUF-1:0]    regRST ;
    //*******************************************************************************
    //
    //  Store the counter / bin / channel into the BRAM every "N"
    //   selected by changing the register value
    //  Once it reaches the selected value, switch to the next BRAM, and
    //   start sending the data from the previous BRAM to SiTCP module
    //
    //*******************************************************************************
genvar i;
generate
    for (i = 0; i < NBUF; i = i+1) begin: CHECK_EOD
        always@ (posedge CLK_200M) begin
            if(RESET)begin
                regEOD[2*i+1:2*i]  <= 2'd0;
                edgeEOD[i]         <= 1'b0;
                regRST[i]          <= 1'b1;
                relCNTR[11*i+10:11*i] <= 11'd0;
            end else begin
                regEOD[2*i+1:2*i]  <= {regEOD[2*i],EOD[i]};
                edgeEOD[i]         <= (regEOD[2*i+1:2*i]==2'b01)? 1'b1 : 1'b0;
                regRST[i]          <= 1'b0;
                if (MR_SYNC) begin
                    relCNTR[11*i+10:11*i] <= 11'd0;
                end else begin
                    relCNTR[11*i+10:11*i] <= relCNTR[11*i+10:11*i] + 11'd1;
                end
            end
        end
    end
endgenerate

    wire    [NBUF*DWIDTH_BUF-1:0] DCOUNTER_INT;
    wire            [11*NBUF-1:0] LENGTH_INT  ;
generate
    for (i = 0; i < NBUF; i = i+1) begin: BUF_LOOP
        SHIFT_COUNTER_ALL shift_cntr_eachbuf(
            .RST    (regRST[i]),        // input reset signal
            .CLK    (CLK_200M ),        // input clock
            .EN     (enWrite[i]&START), // input enable writing
            .SIG    (INPUT    ),        // input signal
            .EOD    (edgeEOD[i]),       // end of data sending for this memory block
            .RELCNTR(relCNTR[11*i+10:11*i]),        // counter w.r.t. MR sync
            .RLENGTH(LENGTH_INT[i*11+10:i*11]), // input address from send module corresponding to RelCounter
            .COUNTER(DCOUNTER_INT[(i+1)*DWIDTH_BUF-1:i*DWIDTH_BUF]) // output data
        );
    end
endgenerate

    wire  [NBUF-1:0]    sendEn  ;
    wire  [NBUF-1:0]    readRdy ;
    wire  [NBUF-1:0]    SEND_EN_INT ;
    wire  [8*NBUF-1:0]  OUTDATA_INT;
    wire  [NBUF-1:0]    send_others;
generate
    for (i = 0; i < NBUF; i = i+1) begin: SEND_LOOP
        DATA_SEND_MCS data_send_mcs0(
            .RST     (regRST[i] ),  // input reset
            .CLK     (CLK_200M  ),  // input clock
            .ENABLE  (enWrite[i]&START        ), // write enable for mem buffer which also control the data send start
            .BUFLABEL(label[4*(i+1)-1:4*i]    ), // label of buffer put in the header
            .TCP_FULL(TCP_BUSY|send_others[i] ), // input TCP busy or other channel is sending data
            .LENGTH  (LENGTH_INT[i*11+10:i*11]), // output address to be used in the memory buffer
            .SPLCOUNT(SPILLCOUNT[15:0]        ), // spill id
//            .EM_COUNT(EM_COUNT  ),  // input event muching (just the width of signal changing each spill
            .EM_COUNT(EV_MATCH  ),  // input event muching (just the width of signal changing each spill
            .NMRSYNC (regNSYNC  ),  // counter of MRSync from spill start
            .EOD     (EOD[i]    ),  // output end of data sending
            .DCOUNTER(DCOUNTER_INT[(i+1)*DWIDTH_BUF-1:i*DWIDTH_BUF]), // input data 16-bit * NChannel
            .DOUT    (OUTDATA_INT[8*(i+1)-1:8*i]),                    // output a decoded 8-bit packet
            .SEND_EN (SEND_EN_INT[i]), // output enable to send a packet
            .RD_RDY  (readRdy[i]    )  // output indicating this module is ready to send data
        );
    end
endgenerate

/// TODO below part should be modified to the flexible number of buffers later..
    sendStatus(.CLK  (CLK_200M),
               .RST  (RESET   ),
               .WRITE(enWrite ),
               .EOD  (edgeEOD ),
               .READY(readRdy ),
               .SEND (sendEn  )
    );
    always @(posedge CLK_200M)begin
        if (RESET) begin
            OUTDATA <= 8'h0;
            SEND_EN <= 1'b0;
        end else begin
            if (sendEn[0])begin
                OUTDATA <= OUTDATA_INT[8*1-1:8*0];
                SEND_EN <= SEND_EN_INT[0];
            end else if (sendEn[1])begin
                OUTDATA <= OUTDATA_INT[8*2-1:8*1];
                SEND_EN <= SEND_EN_INT[1];
            end else if (sendEn[2])begin
                OUTDATA <= OUTDATA_INT[8*3-1:8*2];
                SEND_EN <= SEND_EN_INT[2];
            //end else if (sendEn[3])begin
            //    OUTDATA <= OUTDATA_INT[8*4-1:8*3];
            //    SEND_EN <= SEND_EN_INT[3];
            end else begin
                OUTDATA <= 8'hBB;
                SEND_EN <= 1'b0;
            end
        end
    end
    //assign  send_others[3:0] = {|{sendEn[2:0]},|{sendEn[3],sendEn[1:0]},
    //                            |{sendEn[3:2],sendEn[0]},|{sendEn[3:1]}};
    assign  send_others[2:0] = {|sendEn[1:0], |{sendEn[2],sendEn[0]},|{sendEn[2:1]}};

    assign BUF_SWITCH = {SEND_EN_INT,enWrite};
endmodule

module sendStatus(
    input   wire         CLK,
    input   wire         RST,
    input   wire  [2:0]  WRITE,
    input   wire  [2:0]  EOD,
    input   wire  [2:0]  READY, /// data is ready to be read
    output  wire  [2:0]  SEND
);
    reg [5:0]   irWrite;

    always @(posedge CLK)begin
        if (RST) begin
            irWrite <= 6'd0;
        end else begin
            irWrite <= {irWrite[4],WRITE[2],
                        irWrite[2],WRITE[1],irWrite[0],WRITE[0]};
        end
    end

    reg [3:0]   irSend;
    always @(posedge CLK)begin
        if (RST) begin
            irSend <= 3'd0;
        end else begin
            if (|SEND == 1'b0) begin
                if (irWrite[1:0]==2'b10) begin
                    irSend <= 3'b001;
                end else if (irWrite[3:2]==2'b10) begin
                    irSend <= 3'b010;
                end else if (irWrite[5:4]==2'b10) begin
                    irSend <= 3'b100;
                end
            end else begin
                if (|(EOD&SEND)) begin /// Data sending at some channel is finished
                    if (|READY) begin  /// If there are any channel ready to be read, let's shift the read flag
                        irSend <= {irSend[1:0],SEND[2]};
                    end else begin     /// Otherwise, let's wait for some channel becomes ready
                        irSend <= 4'd0;
                    end
                end
            end
        end
    end
    reg [2:0]   dlySend;
    always @(posedge CLK)begin
        dlySend <= irSend;
    end
    assign SEND = dlySend;
endmodule
