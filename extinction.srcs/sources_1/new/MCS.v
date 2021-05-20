`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////
//
////////////////////////
// !!! THIS IS FROM THE PREVIOUS 8GEV EXTINCTION MEASUREMENT ONLY FOR THE REFERENCE !!!
////////////////////////
// Multi-Channel Scalar
//  16 channel, maximum 1088 CLK ticks -> corresponding to 5.44us time window with 200MHz CLK
////  16 channel, maximum 688 CLK ticks -> corresponding to 5.5us time window with 125MHz CLK
//  relative to the start timing.
//
//  Data format is as follows:
//  HEADER: 64-bit
//   AA AA AA AA 00 00 SPLCOUNT[15:0]
//
//  16ch + Event matching DATA: 72-bit
//      0:   CH0[23:0],CH1[23:0],...,CH14[23:0],CH15[23:0],CH17[23:0]
//      1:   CH0[23:0],CH1[23:0],...,CH14[23:0],CH15[23:0],CH17[23:0]
//      2:   CH0[23:0],CH1[23:0],...,CH14[23:0],CH15[23:0],CH17[23:0]
//     ...   ...
////   1086:   CH0[23:0],CH1[23:0],...,CH14[23:0],CH15[23:0],CH17[23:0]
////   1087:   CH0[23:0],CH1[23:0],...,CH14[23:0],CH15[23:0],CH17[23:0]
//    686:   CH0[23:0],CH1[23:0],...,CH14[23:0],CH15[23:0],CH17[23:0]
//    687:   CH0[23:0],CH1[23:0],...,CH14[23:0],CH15[23:0],CH17[23:0]
//
//  FOOTER: 64-bit
//   FF FF FF FF NMRSYNC[31:0]
//
/////////////////////////////////////////////////////////////////////

module MCS(
    RST,
    CLK,
    TX_CLK,
    SPLGATE,
    SPLCOUNT,
    SIG,
    DOUT,
    SEND_EN,
    TCP_FULL,
    LENGTH,
    TXCOUNT
);
    //parameter  NLEN = 1088;
    parameter  NLEN = 688;


    input           RST     ;
    input           CLK     ;
    input           TX_CLK  ;
    input           SPLGATE;
    input   [15:0]  SPLCOUNT;
    input   [17:0]  SIG     ; // SIG[17] Event matching, SIG[16] MRSync, SIG[15:0] Counter signals
    output   [7:0]  DOUT    ;
    output          SEND_EN ;
    input           TCP_FULL;
    output  [10:0]  LENGTH  ; // debug
    output  [15:0]  TXCOUNT ; // debug

    reg      [7:0]  DOUT    ;
    wire            R_EN    ;
    wire            SEND_EN ;


    wire    [23:0]  COUNTER00;
    wire    [23:0]  COUNTER01;
    wire    [23:0]  COUNTER02;
    wire    [23:0]  COUNTER03;
    wire    [23:0]  COUNTER04;
    wire    [23:0]  COUNTER05;
    wire    [23:0]  COUNTER06;
    wire    [23:0]  COUNTER07;
    wire    [23:0]  COUNTER08;
    wire    [23:0]  COUNTER09;
    wire    [23:0]  COUNTER10;
    wire    [23:0]  COUNTER11;
    wire    [23:0]  COUNTER12;
    wire    [23:0]  COUNTER13;
    wire    [23:0]  COUNTER14;
    wire    [23:0]  COUNTER15;
    wire    [23:0]  COUNTER17; // For Event matching signal

    reg             ENABLE  ; // Enable on until the spill end
    reg     [31:0]  NMRSYNC ; // Number of MRSync
    reg     [10:0]  CNTR_REL; // Relative counter

    reg     [31:0]  rNMRSYNC;

    always@ (posedge CLK) begin
        if(RST)begin
            ENABLE    <=  1'b0;
            NMRSYNC   <= 32'd0;
            CNTR_REL  <= 11'd0;
            rNMRSYNC  <= 32'd0;
        end else begin
            if (SPLGATE)begin
                if (NMRSYNC>32'd0) begin
                    ENABLE    <= 1'b1;
                end
                rNMRSYNC  <= NMRSYNC;
            end else begin
                ENABLE    <= 1'b0;
                NMRSYNC   <= 32'd0;
            end

            if(SIG[16])begin
                CNTR_REL <= 11'd0;
                if(SPLGATE) begin
                    NMRSYNC <= NMRSYNC + 32'd1;
                end
            end else begin
                CNTR_REL <= CNTR_REL + 11'd1;
            end
        end
    end

    reg          EOD    ; // End of Data sending
    reg   [1:0]  regEOD ; // Reg to check Edge of EOD
    reg          edgeEOD; // Edge of EOD
    reg  [10:0]  LENGTH ; // CLK tick to be read

    always@ (posedge CLK) begin
        if(RST)begin
            regEOD  <=  2'd0;
            edgeEOD <=  1'b0;
        end else begin
            regEOD  <= {regEOD[0],EOD};
            edgeEOD <= (regEOD==2'b01);
        end
    end

    SHIFT_COUNTER counter00(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[0]   ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER00)
    );
    SHIFT_COUNTER counter01(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[1]   ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER01)
    );
    SHIFT_COUNTER counter02(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[2]   ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER02)
    );
    SHIFT_COUNTER counter03(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[3]   ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER03)
    );
    SHIFT_COUNTER counter04(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[4]   ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER04)
    );
    SHIFT_COUNTER counter05(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[5]   ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER05)
    );
    SHIFT_COUNTER counter06(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[6]   ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER06)
    );
    SHIFT_COUNTER counter07(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[7]   ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER07)
    );
    SHIFT_COUNTER counter08(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[8]   ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER08)
    );
    SHIFT_COUNTER counter09(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[9]   ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER09)
    );
    SHIFT_COUNTER counter10(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[10]  ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER10)
    );
    SHIFT_COUNTER counter11(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[11]  ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER11)
    );
    SHIFT_COUNTER counter12(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[12]  ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER12)
    );
    SHIFT_COUNTER counter13(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[13]  ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER13)
    );
    SHIFT_COUNTER counter14(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[14]  ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER14)
    );
    SHIFT_COUNTER counter15(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[15]  ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER15)
    );
    SHIFT_COUNTER counter17(
        .RST    (RST      ),
        .CLK    (CLK      ),
        .EN     (ENABLE   ),
        .SIG    (SIG[17]  ),
        .EOD    (edgeEOD  ),
        .RELCNTR(CNTR_REL ),
        .RLENGTH(LENGTH   ),
        .COUNTER(COUNTER17)
    );

    reg               RD_ENABLE    ; // Enable data reading 4 CLKs after Spill disabled
    reg        [3:0]  regDlyENABLE ;

    always@ (posedge CLK) begin
        if(RST) begin
            regDlyENABLE <= 4'd0;
            RD_ENABLE    <= 1'b0;
        end else begin
            regDlyENABLE <= {regDlyENABLE[2:0],ENABLE};
            if(regDlyENABLE[3:0]==4'b1000) begin
                RD_ENABLE <= 1'b1;
            end else if(EOD) begin
                RD_ENABLE <= 1'b0;
            end
        end
    end

    parameter  MAXCOUNT = 16'd55504; // 3*17*1088 (Data+Event matching) + 8*2 (header&footer) byte
    parameter  MAXLEN   =  11'd1088; // Maximum data length w/o header&footer
    //parameter  MAXCOUNT = 16'd35104; // 3*17*688 (Data+Event matching) + 8*2 (header&footer) byte
    //parameter  MAXLEN   =   11'd688; // Maximum data length w/o header&footer
    parameter  MAXBYTE  =   6'd51  ; // =3*17, Maximum byte per each CLK tick...

    reg       [15:0]  TXCOUNT      ; // tx counter including header and footer
    reg       [15:0]  dlyTXCOUNT   ;
    reg        [3:0]  dlyHdCOUNT   ; // header read counter
    wire              rdBusy       ;
    reg               dlyRdBusy    ;
    reg               dlyRdBusy2   ;
    reg        [5:0]  eachCNTR     ; // 0--51 to read data/(CLK tick), 3-byte * 17 = 51. if 51, interrupt..

    wire              SHIFT        ;

    assign SHIFT  = (eachCNTR==MAXBYTE)? 1'b1 : 1'b0;

    assign R_EN   = RD_ENABLE & ~TCP_FULL & (TXCOUNT<=MAXCOUNT) & ~SHIFT;
    assign rdBusy = (TXCOUNT<MAXCOUNT) & ~TCP_FULL & ~SHIFT;

    always@ (posedge TX_CLK) begin
        if(RST) begin
            TXCOUNT     <= MAXCOUNT;
        end else begin
            if(R_EN) begin
                TXCOUNT <= TXCOUNT - 16'd1;
            end else if(EOD) begin
                TXCOUNT <= MAXCOUNT;
            end
        end
    end

    always@ (posedge TX_CLK) begin
        if(RST) begin
            dlyTXCOUNT  <= 16'hFFFF;
            dlyRdBusy   <=  1'b0   ;
            dlyHdCOUNT  <=  4'b1000;
            eachCNTR    <=  6'd0   ;
            LENGTH      <= 11'd0   ;
        end else begin
            dlyTXCOUNT  <= TXCOUNT;
            dlyRdBusy   <= rdBusy ;
            if(ENABLE) begin
                LENGTH  <= 11'd0;
                eachCNTR<=  6'd0;
            end else begin
                if(TXCOUNT+16'd8>=MAXCOUNT) begin
                    dlyHdCOUNT  <= TXCOUNT+16'd8-MAXCOUNT;
                end else begin
                    dlyHdCOUNT  <= 4'b1000;
                    if(SHIFT) begin
                        eachCNTR <= 6'd0;
                        LENGTH   <= LENGTH + 11'd1;
                    end else begin
                        eachCNTR <= (R_EN)? eachCNTR + 6'd1 : eachCNTR;
                    end
                end
            end
        end
    end

    reg   [5:0]  dlyEachCNTR;
    always@ (posedge TX_CLK) begin
        if(RST) begin
            dlyEachCNTR <=  6'd0   ;
        end else begin
            dlyEachCNTR <= eachCNTR;
        end
    end


    always@ (posedge TX_CLK) begin
        if(RST) begin
            DOUT   <=  8'd0;
            EOD    <=  1'b0;
        end else begin
            if(ENABLE) begin
                EOD <= 1'b0;
            end else if(dlyRdBusy) begin
                if(~dlyHdCOUNT[3]) begin /// send header
                    case(dlyHdCOUNT[2:0])
                        3'h7: DOUT <= 8'hAA;
                        3'h6: DOUT <= 8'hAA;
                        3'h5: DOUT <= 8'hAA;
                        3'h4: DOUT <= 8'hAA;
                        3'h3: DOUT <= 8'h00;
                        3'h2: DOUT <= 8'h00;
                        3'h1: DOUT <= SPLCOUNT[15: 8];
                        3'h0: DOUT <= SPLCOUNT[ 7: 0];
                    endcase
                end else if(dlyTXCOUNT>=16'd8) begin /// send data
                    case(dlyEachCNTR[5:0])
                        6'h00: DOUT <= COUNTER00[23:16];
                        6'h01: DOUT <= COUNTER00[15: 8];
                        6'h02: DOUT <= COUNTER00[ 7: 0];
                        6'h03: DOUT <= COUNTER01[23:16];
                        6'h04: DOUT <= COUNTER01[15: 8];
                        6'h05: DOUT <= COUNTER01[ 7: 0];
                        6'h06: DOUT <= COUNTER02[23:16];
                        6'h07: DOUT <= COUNTER02[15: 8];
                        6'h08: DOUT <= COUNTER02[ 7: 0];
                        6'h09: DOUT <= COUNTER03[23:16];
                        6'h0A: DOUT <= COUNTER03[15: 8];
                        6'h0B: DOUT <= COUNTER03[ 7: 0];
                        6'h0C: DOUT <= COUNTER04[23:16];
                        6'h0D: DOUT <= COUNTER04[15: 8];
                        6'h0E: DOUT <= COUNTER04[ 7: 0];
                        6'h0F: DOUT <= COUNTER05[23:16];
                        6'h10: DOUT <= COUNTER05[15: 8];
                        6'h11: DOUT <= COUNTER05[ 7: 0];
                        6'h12: DOUT <= COUNTER06[23:16];
                        6'h13: DOUT <= COUNTER06[15: 8];
                        6'h14: DOUT <= COUNTER06[ 7: 0];
                        6'h15: DOUT <= COUNTER07[23:16];
                        6'h16: DOUT <= COUNTER07[15: 8];
                        6'h17: DOUT <= COUNTER07[ 7: 0];
                        6'h18: DOUT <= COUNTER08[23:16];
                        6'h19: DOUT <= COUNTER08[15: 8];
                        6'h1A: DOUT <= COUNTER08[ 7: 0];
                        6'h1B: DOUT <= COUNTER09[23:16];
                        6'h1C: DOUT <= COUNTER09[15: 8];
                        6'h1D: DOUT <= COUNTER09[ 7: 0];
                        6'h1E: DOUT <= COUNTER10[23:16];
                        6'h1F: DOUT <= COUNTER10[15: 8];
                        6'h20: DOUT <= COUNTER10[ 7: 0];
                        6'h21: DOUT <= COUNTER11[23:16];
                        6'h22: DOUT <= COUNTER11[15: 8];
                        6'h23: DOUT <= COUNTER11[ 7: 0];
                        6'h24: DOUT <= COUNTER12[23:16];
                        6'h25: DOUT <= COUNTER12[15: 8];
                        6'h26: DOUT <= COUNTER12[ 7: 0];
                        6'h27: DOUT <= COUNTER13[23:16];
                        6'h28: DOUT <= COUNTER13[15: 8];
                        6'h29: DOUT <= COUNTER13[ 7: 0];
                        6'h2A: DOUT <= COUNTER14[23:16];
                        6'h2B: DOUT <= COUNTER14[15: 8];
                        6'h2C: DOUT <= COUNTER14[ 7: 0];
                        6'h2D: DOUT <= COUNTER15[23:16];
                        6'h2E: DOUT <= COUNTER15[15: 8];
                        6'h2F: DOUT <= COUNTER15[ 7: 0];
                        6'h3A: DOUT <= COUNTER17[23:16];
                        6'h3B: DOUT <= COUNTER17[15: 8];
                        6'h3C: DOUT <= COUNTER17[ 7: 0];
                        default: DOUT <= 8'h0;
                    endcase
                end else begin /// send footer
                    case(dlyTXCOUNT[2:0])
                        3'h7: DOUT <= 8'hFF;
                        3'h6: DOUT <= 8'hFF;
                        3'h5: DOUT <= 8'hFF;
                        3'h4: DOUT <= 8'hFF;
                        3'h3: DOUT <= rNMRSYNC[31:24];
                        3'h2: DOUT <= rNMRSYNC[23:16];
                        3'h1: DOUT <= rNMRSYNC[15: 8];
                        3'h0: DOUT <= rNMRSYNC[ 7: 0];
                    endcase
                    if(dlyTXCOUNT[2:0]==3'h0) begin
                       EOD <= 1'b1;
                    end
                end
            end else begin
                DOUT <= 8'd0;
            end
        end
    end

    always@ (posedge TX_CLK) begin
        if(RST) begin
            dlyRdBusy2 <= 1'b0;
        end else begin
            dlyRdBusy2 <= dlyRdBusy;
        end
    end

    assign SEND_EN = dlyRdBusy2;

endmodule
