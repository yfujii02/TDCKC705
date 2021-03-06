`timescale 1ns / 1ps

module DATA_SEND_MCS(
    input   wire              RST,
    input   wire              CLK,
    input   wire              ENABLE,
    input   wire     [3:0]    BUFLABEL,
    input   wire              TCP_FULL,
    output  reg     [10:0]    LENGTH,
    input   wire    [15:0]    SPLCOUNT,
    input   wire    [15:0]    EM_COUNT,
    input   wire    [31:0]    NMRSYNC,
    output  reg               EOD,
    input   wire [74*16-1:0]  DCOUNTER,
    output  reg      [7:0]    DOUT,
    output  wire              SEND_EN,
    output  reg               RD_RDY // read ready, but sending is not started yet
);
    parameter  MAXCOUNT = 18'd161040; // 2*(64+10)*1088 (MPPC Data+PMT Data) + 8*2 (header&footer) byte
    parameter  MAXCWOHD = 18'd161032; // Max count without header
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

    reg        [2:0]  regDlyENABLE ;
    reg  [74*16-1:0]  regDCOUNTER  ;
    reg               RD_ENABLE    ;
    reg               irRD_RDY     ;
    always@ (posedge CLK) begin
        if(RST) begin
            regDlyENABLE <= 3'd0;
            irRD_RDY     <= 1'b0;
            RD_RDY       <= 1'b0;
            RD_ENABLE    <= 1'b0;
        end else begin
            regDlyENABLE <= {regDlyENABLE[1:0],ENABLE};
            if(regDlyENABLE[2:0]==3'b100) begin
                irRD_RDY <= 1'b1;
                RD_RDY   <= 1'b1;
            end else begin
                irRD_RDY <= (EOD)? 1'b0 : irRD_RDY;
                RD_RDY   <= (irRD_RDY&SEND_EN)? 1'b0 : RD_RDY;
            end
            RD_ENABLE <= irRD_RDY;
        end
    end

    reg     [15:0]  irSPLCOUNT;
    reg     [15:0]  irEM_COUNT;
    reg     [31:0]  irNMRSYNC ;
    always@ (posedge CLK) begin
        if(RST) begin
            irSPLCOUNT <= 16'd0;
            irEM_COUNT <= 16'd0;
            irNMRSYNC  <= 32'd0;
        end else begin
            if(regDlyENABLE[1:0]==2'b01) begin
                irSPLCOUNT <= SPLCOUNT;
            end
            if(regDlyENABLE[1:0]==2'b10) begin
                irEM_COUNT <= EM_COUNT;
                irNMRSYNC  <= NMRSYNC ; /// Record the number of MR sync when writing has finished in the RAM
            end
        end
    end

    parameter    MAXWAIT = 7'd96;/// Additional 96 CLKs waiting to shift the data
    reg           shift_wait_hi;
    reg    [6:0]  shift_wait_cnt;

    assign R_EN   = RD_ENABLE & ~TCP_FULL & (txcount<=MAXCOUNT) & ~shift & ~shift_wait_hi;
    assign shift  = (eachCNTR==MAXBYTE)? 1'b1 : 1'b0;
    assign rdBusy = (txcount<MAXCOUNT) & ~TCP_FULL & ~shift & ~shift_wait_hi;

    always@ (posedge CLK) begin
        if(RST) begin
            shift_wait_hi  <= 1'b0;
        end else begin
            if(shift)begin
                shift_wait_hi <= 1'b1;
            end else begin
                shift_wait_hi <= (shift_wait_cnt==MAXWAIT)? 1'b0 : shift_wait_hi;
            end
        end
    end
    always@ (posedge CLK) begin
        if(RST) begin
            shift_wait_cnt <= 7'd0;
        end else begin
            if(shift_wait_hi==1'b1)begin
                shift_wait_cnt <= shift_wait_cnt + 7'd1;
            end else begin
                shift_wait_cnt <= 7'd0;
            end
        end
    end

    always@ (posedge CLK) begin
        if(RST) begin
            txcount     <= MAXCOUNT;
        end else begin
            if(EOD) begin
                txcount <= MAXCOUNT;
            end else begin
                txcount <= (R_EN)? txcount - 18'd1 : txcount;
            end
        end
    end

    wire    [17:0] count_sub;
    assign count_sub = txcount-MAXCWOHD;
    always@ (posedge CLK) begin
        if(RST) begin
            dlyTXCOUNT  <= MAXCOUNT;
            dlyRdBusy   <=  1'b0   ;
            dlyHdCOUNT  <=  4'b1000;
            eachCNTR    <=  8'd0   ;
            LENGTH      <= 11'd0   ;
            regDCOUNTER <= 1184'd0 ;
        end else begin
            dlyTXCOUNT  <= txcount;
            dlyRdBusy   <= rdBusy ;
            if(ENABLE) begin
                LENGTH  <= 11'd0;
                eachCNTR<=  8'd0;
            end else begin
                if(txcount>=MAXCWOHD) begin
                    dlyHdCOUNT  <= count_sub[3:0];
                    regDCOUNTER <= DCOUNTER;
                end else begin
                    dlyHdCOUNT  <= 4'b1000;
                    if(shift) begin
                        eachCNTR <= 8'd0;
                        LENGTH   <= LENGTH + 11'd1;
                        regDCOUNTER <= DCOUNTER;
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
    wire    CNTROdd;
    assign CNTROdd = dlyEachCNTR[0];

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
                        3'h2: DOUT <= {4'h0,BUFLABEL[3:0]};
                        3'h1: DOUT <= irSPLCOUNT[15: 8];
                        3'h0: DOUT <= irSPLCOUNT[ 7: 0];
                    endcase
                end else if(dlyTXCOUNT>=18'd8) begin /// send data
                    case(dlyEachCNTR[7:1])
                        7'd0:    DOUT <= (CNTROdd==1'b1)? regDCOUNTER[ 0*16+7: 0*16+0] : regDCOUNTER[ 0*16+15: 0*16+8];
                        7'd1:    DOUT <= (CNTROdd==1'b1)? regDCOUNTER[ 1*16+7: 1*16+0] : regDCOUNTER[ 1*16+15: 1*16+8];
                        7'd2:    DOUT <= (CNTROdd==1'b1)? regDCOUNTER[ 2*16+7: 2*16+0] : regDCOUNTER[ 2*16+15: 2*16+8];
                        7'd3:    DOUT <= (CNTROdd==1'b1)? regDCOUNTER[ 3*16+7: 3*16+0] : regDCOUNTER[ 3*16+15: 3*16+8];
                        7'd4:    DOUT <= (CNTROdd==1'b1)? regDCOUNTER[ 4*16+7: 4*16+0] : regDCOUNTER[ 4*16+15: 4*16+8];
                        7'd5:    DOUT <= (CNTROdd==1'b1)? regDCOUNTER[ 5*16+7: 5*16+0] : regDCOUNTER[ 5*16+15: 5*16+8];
                        7'd6:    DOUT <= (CNTROdd==1'b1)? regDCOUNTER[ 6*16+7: 6*16+0] : regDCOUNTER[ 6*16+15: 6*16+8];
                        7'd7:    DOUT <= (CNTROdd==1'b1)? regDCOUNTER[ 7*16+7: 7*16+0] : regDCOUNTER[ 7*16+15: 7*16+8];
                        7'd8:    DOUT <= (CNTROdd==1'b1)? regDCOUNTER[ 8*16+7: 8*16+0] : regDCOUNTER[ 8*16+15: 8*16+8];
                        7'd9:    DOUT <= (CNTROdd==1'b1)? regDCOUNTER[ 9*16+7: 9*16+0] : regDCOUNTER[ 9*16+15: 9*16+8];
                        7'd10:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[10*16+7:10*16+0] : regDCOUNTER[10*16+15:10*16+8];
                        7'd11:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[11*16+7:11*16+0] : regDCOUNTER[11*16+15:11*16+8];
                        7'd12:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[12*16+7:12*16+0] : regDCOUNTER[12*16+15:12*16+8];
                        7'd13:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[13*16+7:13*16+0] : regDCOUNTER[13*16+15:13*16+8];
                        7'd14:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[14*16+7:14*16+0] : regDCOUNTER[14*16+15:14*16+8];
                        7'd15:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[15*16+7:15*16+0] : regDCOUNTER[15*16+15:15*16+8];
                        7'd16:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[16*16+7:16*16+0] : regDCOUNTER[16*16+15:16*16+8];
                        7'd17:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[17*16+7:17*16+0] : regDCOUNTER[17*16+15:17*16+8];
                        7'd18:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[18*16+7:18*16+0] : regDCOUNTER[18*16+15:18*16+8];
                        7'd19:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[19*16+7:19*16+0] : regDCOUNTER[19*16+15:19*16+8];
                        7'd20:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[20*16+7:20*16+0] : regDCOUNTER[20*16+15:20*16+8];
                        7'd21:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[21*16+7:21*16+0] : regDCOUNTER[21*16+15:21*16+8];
                        7'd22:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[22*16+7:22*16+0] : regDCOUNTER[22*16+15:22*16+8];
                        7'd23:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[23*16+7:23*16+0] : regDCOUNTER[23*16+15:23*16+8];
                        7'd24:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[24*16+7:24*16+0] : regDCOUNTER[24*16+15:24*16+8];
                        7'd25:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[25*16+7:25*16+0] : regDCOUNTER[25*16+15:25*16+8];
                        7'd26:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[26*16+7:26*16+0] : regDCOUNTER[26*16+15:26*16+8];
                        7'd27:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[27*16+7:27*16+0] : regDCOUNTER[27*16+15:27*16+8];
                        7'd28:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[28*16+7:28*16+0] : regDCOUNTER[28*16+15:28*16+8];
                        7'd29:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[29*16+7:29*16+0] : regDCOUNTER[29*16+15:29*16+8];
                        7'd30:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[30*16+7:30*16+0] : regDCOUNTER[30*16+15:30*16+8];
                        7'd31:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[31*16+7:31*16+0] : regDCOUNTER[31*16+15:31*16+8];
                        7'd32:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[32*16+7:32*16+0] : regDCOUNTER[32*16+15:32*16+8];
                        7'd33:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[33*16+7:33*16+0] : regDCOUNTER[33*16+15:33*16+8];
                        7'd34:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[34*16+7:34*16+0] : regDCOUNTER[34*16+15:34*16+8];
                        7'd35:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[35*16+7:35*16+0] : regDCOUNTER[35*16+15:35*16+8];
                        7'd36:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[36*16+7:36*16+0] : regDCOUNTER[36*16+15:36*16+8];
                        7'd37:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[37*16+7:37*16+0] : regDCOUNTER[37*16+15:37*16+8];
                        7'd38:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[38*16+7:38*16+0] : regDCOUNTER[38*16+15:38*16+8];
                        7'd39:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[39*16+7:39*16+0] : regDCOUNTER[39*16+15:39*16+8];
                        7'd40:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[40*16+7:40*16+0] : regDCOUNTER[40*16+15:40*16+8];
                        7'd41:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[41*16+7:41*16+0] : regDCOUNTER[41*16+15:41*16+8];
                        7'd42:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[42*16+7:42*16+0] : regDCOUNTER[42*16+15:42*16+8];
                        7'd43:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[43*16+7:43*16+0] : regDCOUNTER[43*16+15:43*16+8];
                        7'd44:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[44*16+7:44*16+0] : regDCOUNTER[44*16+15:44*16+8];
                        7'd45:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[45*16+7:45*16+0] : regDCOUNTER[45*16+15:45*16+8];
                        7'd46:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[46*16+7:46*16+0] : regDCOUNTER[46*16+15:46*16+8];
                        7'd47:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[47*16+7:47*16+0] : regDCOUNTER[47*16+15:47*16+8];
                        7'd48:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[48*16+7:48*16+0] : regDCOUNTER[48*16+15:48*16+8];
                        7'd49:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[49*16+7:49*16+0] : regDCOUNTER[49*16+15:49*16+8];
                        7'd50:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[50*16+7:50*16+0] : regDCOUNTER[50*16+15:50*16+8];
                        7'd51:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[51*16+7:51*16+0] : regDCOUNTER[51*16+15:51*16+8];
                        7'd52:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[52*16+7:52*16+0] : regDCOUNTER[52*16+15:52*16+8];
                        7'd53:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[53*16+7:53*16+0] : regDCOUNTER[53*16+15:53*16+8];
                        7'd54:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[54*16+7:54*16+0] : regDCOUNTER[54*16+15:54*16+8];
                        7'd55:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[55*16+7:55*16+0] : regDCOUNTER[55*16+15:55*16+8];
                        7'd56:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[56*16+7:56*16+0] : regDCOUNTER[56*16+15:56*16+8];
                        7'd57:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[57*16+7:57*16+0] : regDCOUNTER[57*16+15:57*16+8];
                        7'd58:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[58*16+7:58*16+0] : regDCOUNTER[58*16+15:58*16+8];
                        7'd59:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[59*16+7:59*16+0] : regDCOUNTER[59*16+15:59*16+8];
                        7'd60:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[60*16+7:60*16+0] : regDCOUNTER[60*16+15:60*16+8];
                        7'd61:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[61*16+7:61*16+0] : regDCOUNTER[61*16+15:61*16+8];
                        7'd62:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[62*16+7:62*16+0] : regDCOUNTER[62*16+15:62*16+8];
                        7'd63:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[63*16+7:63*16+0] : regDCOUNTER[63*16+15:63*16+8];
                        7'd64:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[64*16+7:64*16+0] : regDCOUNTER[64*16+15:64*16+8];
                        7'd65:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[65*16+7:65*16+0] : regDCOUNTER[65*16+15:65*16+8];
                        7'd66:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[66*16+7:66*16+0] : regDCOUNTER[66*16+15:66*16+8];
                        7'd67:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[67*16+7:67*16+0] : regDCOUNTER[67*16+15:67*16+8];
                        7'd68:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[68*16+7:68*16+0] : regDCOUNTER[68*16+15:68*16+8];
                        7'd69:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[69*16+7:69*16+0] : regDCOUNTER[69*16+15:69*16+8];
                        7'd70:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[70*16+7:70*16+0] : regDCOUNTER[70*16+15:70*16+8];
                        7'd71:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[71*16+7:71*16+0] : regDCOUNTER[71*16+15:71*16+8];
                        7'd72:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[72*16+7:72*16+0] : regDCOUNTER[72*16+15:72*16+8];
                        7'd73:   DOUT <= (CNTROdd==1'b1)? regDCOUNTER[73*16+7:73*16+0] : regDCOUNTER[73*16+15:73*16+8];
                        //7'd72:   DOUT <= (CNTROdd==1'b1)? 8'h55 : 8'h66; // for debug
                        //7'd73:   DOUT <= (CNTROdd==1'b1)? 8'h55 : 8'h66; // for debug
                        default: DOUT <= 8'hCC;
                    endcase
                end else begin /// send footer
                    case(dlyTXCOUNT[2:0])
                        3'h7: DOUT <= 8'hFF;
                        3'h6: DOUT <= 8'hFF;
                        3'h5: DOUT <= irEM_COUNT[15:8];
                        3'h4: DOUT <= irEM_COUNT[ 7:0];
                        3'h3: DOUT <= irNMRSYNC[31:24];
                        3'h2: DOUT <= irNMRSYNC[23:16];
                        3'h1: DOUT <= irNMRSYNC[15: 8];
                        3'h0: DOUT <= irNMRSYNC[ 7: 0];
                    endcase
                    if(dlyTXCOUNT==18'd0) begin
                        EOD <= 1'b1;
                    end
                end
            end else begin
                DOUT <= 8'd0;
            end
        end
    end

    always@ (posedge CLK) begin
        dlyRdBusy2 <= dlyRdBusy;
    end

    assign SEND_EN = dlyRdBusy2;
endmodule
