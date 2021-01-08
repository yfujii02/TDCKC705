`timescale 1ns / 1ps

module DATA_SEND_MCS(
    input   wire              RST,
    input   wire              CLK,
    input   wire              TCP_FULL,
    output  reg               EOD,
    input   wire    [15:0]    DCOUNTER[0:73],
    output  reg      [7:0]    DOUT,
    output  wire              SEND_EN
);
    parameter  MAXCOUNT = 18'd161040; // 2*(64+10)*1088 (MPPC Data+PMT Data) + 8*2 (header&footer) byte
    parameter  MAXLEN   =   11'd1088; // Maximum data length w/o header&footer
    parameter  MAXBYTE  =    8'd148 ; // =2*(64+10), Maximum byte per each CLK tick...
    reg       [17:0]  txcount      ; // tx counter including header and footer
    reg       [17:0]  dlyTXCOUNT   ;
    reg        [3:0]  dlyHdCOUNT   ; // header read counter
    wire              rdBusy       ;
    reg               dlyRdBusy    ;
    reg               dlyRdBusy2   ;
    reg        [7:0]  eachCNTR     ; // 0--148 to read data/(CLK tick), 2-byte * (64+10) = 148. if 148, interrupt..
    wire              shift        ;

    assign R_EN   = RD_ENABLE & ~TCP_FULL & (txcount<=MAXCOUNT) & ~shift;
    assign shift  = (eachCNTR==MAXBYTE)? 1'b1 : 1'b0;
    assign rdBusy = (TXCOUNT<MAXCOUNT) & ~TCP_FULL & ~shift;

    always@ (posedge CLK) begin
        if(RST) begin
            txcount     <= MAXCOUNT;
        end else begin
            if(R_EN) begin
                txcount <= txcount - 18'd1;
            end else if(EOD) begin
                txcount <= MAXCOUNT;
            end
        end
    end

    always@ (posedge CLK) begin
        if(RST) begin
            dlyTXCOUNT  <= 18'h3FFFF;
            dlyRdBusy   <=  1'b0   ;
            dlyHdCOUNT  <=  4'b1000;
            eachCNTR    <=  8'd0   ;
            LENGTH      <= 11'd0   ;
        end else begin
            dlyTXCOUNT  <= txcount;
            dlyRdBusy   <= rdBusy ;
            if(ENABLE) begin
                LENGTH  <= 11'd0;
                eachCNTR<=  8'd0;
            end else begin
                if(txcount+18'd8>=MAXCOUNT) begin
                    dlyHdCOUNT  <= txcount+18'd8-MAXCOUNT;
                end else begin
                    dlyHdCOUNT  <= 4'b1000;
                    if(shift) begin
                        eachCNTR <= 8'd0;
                        LENGTH   <= LENGTH + 11'd1;
                    end else begin
                        eachCNTR <= (R_EN)? eachCNTR + 8'd1 : eachCNTR;
                    end
                end
            end
        end
    end

    reg   [7:0]  dlyEachCNTR;
    always@ (posedge CLK) begin
        if(RST) begin
            dlyEachCNTR <=  8'd0   ;
        end else begin
            dlyEachCNTR <= eachCNTR;
        end
    end

    always@ (posedge CLK) begin
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
                end else if(dlyTXCOUNT>=18'd8) begin /// send data
                    case(dlyEachCNTR[7:1])
                        7'd0:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 0][7:0] : DCOUNTER[ 0][15:8];
                        7'd1:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 1][7:0] : DCOUNTER[ 1][15:8];
                        7'd2:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 2][7:0] : DCOUNTER[ 2][15:8];
                        7'd3:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 3][7:0] : DCOUNTER[ 3][15:8];
                        7'd4:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 4][7:0] : DCOUNTER[ 4][15:8];
                        7'd5:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 5][7:0] : DCOUNTER[ 5][15:8];
                        7'd6:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 6][7:0] : DCOUNTER[ 6][15:8];
                        7'd7:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 7][7:0] : DCOUNTER[ 7][15:8];
                        7'd8:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 8][7:0] : DCOUNTER[ 8][15:8];
                        7'd9:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 9][7:0] : DCOUNTER[ 9][15:8];
                        7'd10:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[10][7:0] : DCOUNTER[10][15:8];
                        7'd11:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[11][7:0] : DCOUNTER[11][15:8];
                        7'd12:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[12][7:0] : DCOUNTER[12][15:8];
                        7'd13:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[13][7:0] : DCOUNTER[13][15:8];
                        7'd14:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[14][7:0] : DCOUNTER[14][15:8];
                        7'd15:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[15][7:0] : DCOUNTER[15][15:8];
                        7'd16:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[16][7:0] : DCOUNTER[16][15:8];
                        7'd17:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[17][7:0] : DCOUNTER[17][15:8];
                        7'd18:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[18][7:0] : DCOUNTER[18][15:8];
                        7'd19:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[19][7:0] : DCOUNTER[19][15:8];
                        7'd20:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[20][7:0] : DCOUNTER[20][15:8];
                        7'd21:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[21][7:0] : DCOUNTER[21][15:8];
                        7'd22:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[22][7:0] : DCOUNTER[22][15:8];
                        7'd23:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[23][7:0] : DCOUNTER[23][15:8];
                        7'd24:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[24][7:0] : DCOUNTER[24][15:8];
                        7'd25:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[25][7:0] : DCOUNTER[25][15:8];
                        7'd26:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[26][7:0] : DCOUNTER[26][15:8];
                        7'd27:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[27][7:0] : DCOUNTER[27][15:8];
                        7'd28:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[28][7:0] : DCOUNTER[28][15:8];
                        7'd29:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[29][7:0] : DCOUNTER[29][15:8];
                        7'd30:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[30][7:0] : DCOUNTER[30][15:8];
                        7'd31:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[31][7:0] : DCOUNTER[31][15:8];
                        7'd32:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[32][7:0] : DCOUNTER[32][15:8];
                        7'd33:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[33][7:0] : DCOUNTER[33][15:8];
                        7'd34:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[34][7:0] : DCOUNTER[34][15:8];
                        7'd35:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[35][7:0] : DCOUNTER[35][15:8];
                        7'd36:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[36][7:0] : DCOUNTER[36][15:8];
                        7'd37:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[37][7:0] : DCOUNTER[37][15:8];
                        7'd38:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[38][7:0] : DCOUNTER[38][15:8];
                        7'd39:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[39][7:0] : DCOUNTER[39][15:8];
                        7'd40:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[40][7:0] : DCOUNTER[40][15:8];
                        7'd41:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[41][7:0] : DCOUNTER[41][15:8];
                        7'd42:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[42][7:0] : DCOUNTER[42][15:8];
                        7'd43:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[43][7:0] : DCOUNTER[43][15:8];
                        7'd44:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[44][7:0] : DCOUNTER[44][15:8];
                        7'd45:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[45][7:0] : DCOUNTER[45][15:8];
                        7'd46:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[46][7:0] : DCOUNTER[46][15:8];
                        7'd47:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[47][7:0] : DCOUNTER[47][15:8];
                        7'd48:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[48][7:0] : DCOUNTER[48][15:8];
                        7'd49:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[49][7:0] : DCOUNTER[49][15:8];
                        7'd50:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[50][7:0] : DCOUNTER[50][15:8];
                        7'd51:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[51][7:0] : DCOUNTER[51][15:8];
                        7'd52:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[52][7:0] : DCOUNTER[52][15:8];
                        7'd53:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[53][7:0] : DCOUNTER[53][15:8];
                        7'd54:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[54][7:0] : DCOUNTER[54][15:8];
                        7'd55:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[55][7:0] : DCOUNTER[55][15:8];
                        7'd56:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[56][7:0] : DCOUNTER[56][15:8];
                        7'd57:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[57][7:0] : DCOUNTER[57][15:8];
                        7'd58:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[58][7:0] : DCOUNTER[58][15:8];
                        7'd59:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[59][7:0] : DCOUNTER[59][15:8];
                        7'd60:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[60][7:0] : DCOUNTER[60][15:8];
                        7'd61:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[61][7:0] : DCOUNTER[61][15:8];
                        7'd62:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[62][7:0] : DCOUNTER[62][15:8];
                        7'd63:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[63][7:0] : DCOUNTER[63][15:8];
                        7'd64:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[64][7:0] : DCOUNTER[64][15:8];
                        7'd65:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[65][7:0] : DCOUNTER[65][15:8];
                        7'd66:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[66][7:0] : DCOUNTER[66][15:8];
                        7'd67:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[67][7:0] : DCOUNTER[67][15:8];
                        7'd68:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[68][7:0] : DCOUNTER[68][15:8];
                        7'd69:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[69][7:0] : DCOUNTER[69][15:8];
                        7'd70:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[70][7:0] : DCOUNTER[70][15:8];
                        7'd71:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[71][7:0] : DCOUNTER[71][15:8];
                        7'd72:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[72][7:0] : DCOUNTER[72][15:8];
                        7'd73:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[73][7:0] : DCOUNTER[73][15:8];
                        default: DOUT <= 8'hCC;
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

    always@ (posedge CLK) begin
        if(RST) begin
            dlyRdBusy2 <= 1'b0;
        end else begin
            dlyRdBusy2 <= dlyRdBusy;
        end
    end

    assign SEND_EN = dlyRdBusy2;
endmodule
