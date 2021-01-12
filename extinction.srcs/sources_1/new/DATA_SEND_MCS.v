`timescale 1ns / 1ps

module DATA_SEND_MCS(
    input   wire              RST,
    input   wire              CLK,
    input   wire              ENABLE,
    input   wire              TCP_FULL,
    output  reg     [10:0]    LENGTH,
    input   wire    [15:0]    SPLCOUNT,
    input   wire    [15:0]    EM_COUNT,
    input   wire    [31:0]    NMRSYNC,
    output  reg               EOD,
    input   wire [74*16-1:0]  DCOUNTER,
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

    assign R_EN   = RD_ENABLE & ~TCP_FULL & (txcount<=MAXCOUNT) & ~shift;
    assign shift  = (eachCNTR==MAXBYTE)? 1'b1 : 1'b0;
    assign rdBusy = (txcount<MAXCOUNT) & ~TCP_FULL & ~shift;

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
                        7'd0:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 0*16+7: 0*16+0] : DCOUNTER[ 0*16+15: 0*16+8];
                        7'd1:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 1*16+7: 1*16+0] : DCOUNTER[ 1*16+15: 1*16+8];
                        7'd2:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 2*16+7: 2*16+0] : DCOUNTER[ 2*16+15: 2*16+8];
                        7'd3:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 3*16+7: 3*16+0] : DCOUNTER[ 3*16+15: 3*16+8];
                        7'd4:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 4*16+7: 4*16+0] : DCOUNTER[ 4*16+15: 4*16+8];
                        7'd5:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 5*16+7: 5*16+0] : DCOUNTER[ 5*16+15: 5*16+8];
                        7'd6:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 6*16+7: 6*16+0] : DCOUNTER[ 6*16+15: 6*16+8];
                        7'd7:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 7*16+7: 7*16+0] : DCOUNTER[ 7*16+15: 7*16+8];
                        7'd8:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 8*16+7: 8*16+0] : DCOUNTER[ 8*16+15: 8*16+8];
                        7'd9:    DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[ 9*16+7: 9*16+0] : DCOUNTER[ 9*16+15: 9*16+8];
                        7'd10:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[10*16+7:10*16+0] : DCOUNTER[10*16+15:10*16+8];
                        7'd11:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[11*16+7:11*16+0] : DCOUNTER[11*16+15:11*16+8];
                        7'd12:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[12*16+7:12*16+0] : DCOUNTER[12*16+15:12*16+8];
                        7'd13:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[13*16+7:13*16+0] : DCOUNTER[13*16+15:13*16+8];
                        7'd14:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[14*16+7:14*16+0] : DCOUNTER[14*16+15:14*16+8];
                        7'd15:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[15*16+7:15*16+0] : DCOUNTER[15*16+15:15*16+8];
                        7'd16:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[16*16+7:16*16+0] : DCOUNTER[16*16+15:16*16+8];
                        7'd17:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[17*16+7:17*16+0] : DCOUNTER[17*16+15:17*16+8];
                        7'd18:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[18*16+7:18*16+0] : DCOUNTER[18*16+15:18*16+8];
                        7'd19:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[19*16+7:19*16+0] : DCOUNTER[19*16+15:19*16+8];
                        7'd20:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[20*16+7:20*16+0] : DCOUNTER[20*16+15:20*16+8];
                        7'd21:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[21*16+7:21*16+0] : DCOUNTER[21*16+15:21*16+8];
                        7'd22:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[22*16+7:22*16+0] : DCOUNTER[22*16+15:22*16+8];
                        7'd23:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[23*16+7:23*16+0] : DCOUNTER[23*16+15:23*16+8];
                        7'd24:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[24*16+7:24*16+0] : DCOUNTER[24*16+15:24*16+8];
                        7'd25:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[25*16+7:25*16+0] : DCOUNTER[25*16+15:25*16+8];
                        7'd26:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[26*16+7:26*16+0] : DCOUNTER[26*16+15:26*16+8];
                        7'd27:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[27*16+7:27*16+0] : DCOUNTER[27*16+15:27*16+8];
                        7'd28:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[28*16+7:28*16+0] : DCOUNTER[28*16+15:28*16+8];
                        7'd29:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[29*16+7:29*16+0] : DCOUNTER[29*16+15:29*16+8];
                        7'd30:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[30*16+7:30*16+0] : DCOUNTER[30*16+15:30*16+8];
                        7'd31:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[31*16+7:31*16+0] : DCOUNTER[31*16+15:31*16+8];
                        7'd32:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[32*16+7:32*16+0] : DCOUNTER[32*16+15:32*16+8];
                        7'd33:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[33*16+7:33*16+0] : DCOUNTER[33*16+15:33*16+8];
                        7'd34:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[34*16+7:34*16+0] : DCOUNTER[34*16+15:34*16+8];
                        7'd35:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[35*16+7:35*16+0] : DCOUNTER[35*16+15:35*16+8];
                        7'd36:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[36*16+7:36*16+0] : DCOUNTER[36*16+15:36*16+8];
                        7'd37:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[37*16+7:37*16+0] : DCOUNTER[37*16+15:37*16+8];
                        7'd38:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[38*16+7:38*16+0] : DCOUNTER[38*16+15:38*16+8];
                        7'd39:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[39*16+7:39*16+0] : DCOUNTER[39*16+15:39*16+8];
                        7'd40:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[40*16+7:40*16+0] : DCOUNTER[40*16+15:40*16+8];
                        7'd41:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[41*16+7:41*16+0] : DCOUNTER[41*16+15:41*16+8];
                        7'd42:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[42*16+7:42*16+0] : DCOUNTER[42*16+15:42*16+8];
                        7'd43:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[43*16+7:43*16+0] : DCOUNTER[43*16+15:43*16+8];
                        7'd44:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[44*16+7:44*16+0] : DCOUNTER[44*16+15:44*16+8];
                        7'd45:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[45*16+7:45*16+0] : DCOUNTER[45*16+15:45*16+8];
                        7'd46:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[46*16+7:46*16+0] : DCOUNTER[46*16+15:46*16+8];
                        7'd47:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[47*16+7:47*16+0] : DCOUNTER[47*16+15:47*16+8];
                        7'd48:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[48*16+7:48*16+0] : DCOUNTER[48*16+15:48*16+8];
                        7'd49:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[49*16+7:49*16+0] : DCOUNTER[49*16+15:49*16+8];
                        7'd50:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[50*16+7:50*16+0] : DCOUNTER[50*16+15:50*16+8];
                        7'd51:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[51*16+7:51*16+0] : DCOUNTER[51*16+15:51*16+8];
                        7'd52:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[52*16+7:52*16+0] : DCOUNTER[52*16+15:52*16+8];
                        7'd53:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[53*16+7:53*16+0] : DCOUNTER[53*16+15:53*16+8];
                        7'd54:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[54*16+7:54*16+0] : DCOUNTER[54*16+15:54*16+8];
                        7'd55:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[55*16+7:55*16+0] : DCOUNTER[55*16+15:55*16+8];
                        7'd56:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[56*16+7:56*16+0] : DCOUNTER[56*16+15:56*16+8];
                        7'd57:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[57*16+7:57*16+0] : DCOUNTER[57*16+15:57*16+8];
                        7'd58:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[58*16+7:58*16+0] : DCOUNTER[58*16+15:58*16+8];
                        7'd59:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[59*16+7:59*16+0] : DCOUNTER[59*16+15:59*16+8];
                        7'd60:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[60*16+7:60*16+0] : DCOUNTER[60*16+15:60*16+8];
                        7'd61:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[61*16+7:61*16+0] : DCOUNTER[61*16+15:61*16+8];
                        7'd62:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[62*16+7:62*16+0] : DCOUNTER[62*16+15:62*16+8];
                        7'd63:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[63*16+7:63*16+0] : DCOUNTER[63*16+15:63*16+8];
                        7'd64:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[64*16+7:64*16+0] : DCOUNTER[64*16+15:64*16+8];
                        7'd65:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[65*16+7:65*16+0] : DCOUNTER[65*16+15:65*16+8];
                        7'd66:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[66*16+7:66*16+0] : DCOUNTER[66*16+15:66*16+8];
                        7'd67:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[67*16+7:67*16+0] : DCOUNTER[67*16+15:67*16+8];
                        7'd68:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[68*16+7:68*16+0] : DCOUNTER[68*16+15:68*16+8];
                        7'd69:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[69*16+7:69*16+0] : DCOUNTER[69*16+15:69*16+8];
                        7'd70:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[70*16+7:70*16+0] : DCOUNTER[70*16+15:70*16+8];
                        7'd71:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[71*16+7:71*16+0] : DCOUNTER[71*16+15:71*16+8];
                        7'd72:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[72*16+7:72*16+0] : DCOUNTER[72*16+15:72*16+8];
                        7'd73:   DOUT <= (dlyEachCNTR[0]==1'b1)? DCOUNTER[73*16+7:73*16+0] : DCOUNTER[73*16+15:73*16+8];
                        default: DOUT <= 8'hCC;
                    endcase
                end else begin /// send footer
                    case(dlyTXCOUNT[2:0])
                        3'h7: DOUT <= 8'hFF;
                        3'h6: DOUT <= 8'hFF;
                        3'h5: DOUT <= EM_COUNT[15:8];
                        3'h4: DOUT <= EM_COUNT[ 7:0];
                        3'h3: DOUT <= NMRSYNC[31:24];
                        3'h2: DOUT <= NMRSYNC[23:16];
                        3'h1: DOUT <= NMRSYNC[15: 8];
                        3'h0: DOUT <= NMRSYNC[ 7: 0];
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
