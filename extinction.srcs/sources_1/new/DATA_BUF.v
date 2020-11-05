`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  KEK-IPNS
// Engineer: Yuki Fujii
// 
// Create Date: 2017/10/25 09:18:02
// Design Name: 
// Module Name: DATA_BUF
// Project Name: Data buffer for Multi Channel Scaler using Nexys4 Artix-7 Educational Board
// Target Devices: Nexys4
// Tool Versions:  v0
// Description:  Data buffer consisits of multi block memories
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DATA_BUF(
    RST,      // in  System Reset
    CLK,      // in  System CLK
    TX_CLK,   // in  TX CLk
    COUNTER,  // in  Counter value [31:0]
    HEADER,   // in  Header (Header[7:0] SPILL Count [7:0])
    SIG,      // in  Signal [15:0]
    DOUT,     // out Output data [7:0]
    W_CS,     // out Write internal chip select
    R_CS,     // out Read  internal chip select
    R_EN,     // out Read  enable
    SEND_EN,  // out Send data enable
    WCOUNT,   // out Read  Event counter
    RCOUNT,   // out Write Event counter
    TXCOUNT,  // out Tx counter
    TCP_FULL  // in  TCP Full flag
);
    parameter NMEM    = 24    ; // number of memories
    input             RST     ;
    input             CLK     ;
    input             TX_CLK  ;
    input   [31:0]    COUNTER ;
    input   [15:0]    HEADER  ;
    input   [15:0]    SIG     ;
    output   [7:0]    DOUT    ;
    output  [NMEM-1:0]    W_CS;
    output  [NMEM-1:0]    R_CS;
    output            R_EN    ;
    output            SEND_EN ;
    output  [23:0]    WCOUNT  ;
    output  [23:0]    RCOUNT  ;
    output   [3:0]    TXCOUNT ;
    input             TCP_FULL;


    reg      [7:0]    DOUT    ;
    reg [NMEM-1:0]    W_CS    ;
    reg [NMEM-1:0]    R_CS    ;
    wire              R_EN    ;
    wire              SEND_EN ;
    reg     [23:0]    WCOUNT  ; // number of written data
    reg     [23:0]    RCOUNT  ; // number of read data

    always@ (posedge CLK) begin
        if(RST)begin
            WCOUNT <= 24'd0;
        end else begin
            if (|SIG)begin
                WCOUNT <= WCOUNT + 24'd1;
            end
        end
    end
/*
    wire    [NMEM*2-1:0]    status; // status bit for each block RAM [1:0]
                                    //  2'b00: not written yet, or read DONE
                                    //  2'b01: being written now
                                    //  2'b10: become FULL, ready to be read
                                    //  2'b11: being read
*/
    wire     [9:0]    waddr ;
    wire     [9:0]    raddr ;

    wire    [23:0]    wcnt_pluse_1; // used for write chip select
    wire    [23:0]    rcnt_pluse_1; // used for read  chip select
    assign wcnt_pluse_1 = WCOUNT + 24'd1;
    assign rcnt_pluse_1 = RCOUNT + 24'd1;

    always@ (posedge CLK)begin
        if(RST)begin
            W_CS <= 24'd0;
        end else begin
            //case(WCOUNT[14:10])
            case(wcnt_pluse_1[14:10])
                5'h00: W_CS <= 24'b0000_0000_0000_0000_0000_0001;
                5'h01: W_CS <= 24'b0000_0000_0000_0000_0000_0010;
                5'h02: W_CS <= 24'b0000_0000_0000_0000_0000_0100;
                5'h03: W_CS <= 24'b0000_0000_0000_0000_0000_1000;
                5'h04: W_CS <= 24'b0000_0000_0000_0000_0001_0000;
                5'h05: W_CS <= 24'b0000_0000_0000_0000_0010_0000;
                5'h06: W_CS <= 24'b0000_0000_0000_0000_0100_0000;
                5'h07: W_CS <= 24'b0000_0000_0000_0000_1000_0000;
                5'h08: W_CS <= 24'b0000_0000_0000_0001_0000_0000;
                5'h09: W_CS <= 24'b0000_0000_0000_0010_0000_0000;
                5'h0A: W_CS <= 24'b0000_0000_0000_0100_0000_0000;
                5'h0B: W_CS <= 24'b0000_0000_0000_1000_0000_0000;
                5'h0C: W_CS <= 24'b0000_0000_0001_0000_0000_0000;
                5'h0D: W_CS <= 24'b0000_0000_0010_0000_0000_0000;
                5'h0E: W_CS <= 24'b0000_0000_0100_0000_0000_0000;
                5'h0F: W_CS <= 24'b0000_0000_1000_0000_0000_0000;
                5'h10: W_CS <= 24'b0000_0001_0000_0000_0000_0000;
                5'h11: W_CS <= 24'b0000_0010_0000_0000_0000_0000;
                5'h12: W_CS <= 24'b0000_0100_0000_0000_0000_0000;
                5'h13: W_CS <= 24'b0000_1000_0000_0000_0000_0000;
                5'h14: W_CS <= 24'b0001_0000_0000_0000_0000_0000;
                5'h15: W_CS <= 24'b0010_0000_0000_0000_0000_0000;
                5'h16: W_CS <= 24'b0100_0000_0000_0000_0000_0000;
                5'h17: W_CS <= 24'b1000_0000_0000_0000_0000_0000;
            endcase
        end
    end
    assign waddr = WCOUNT[9:0];

///// Parallel memory blick...
    wire    [NMEM*32-1:0]    rd0;
    wire    [NMEM*32-1:0]    rd1;

genvar i;
generate
for (i = 0; i < NMEM; i = i+1) begin: mem0
    //  1st block
    blk_mem_gen_0 blkmem0(
        .addra(waddr  ),
        .clka (CLK    ),
        .dina ({HEADER,SIG}),
        .ena  (W_CS[i]),
        .wea  (1'b1   ),
        .addrb(raddr  ),
        .clkb (TX_CLK ),
        .doutb(rd0[(i+1)*32-1:i*32]),
        //.enb  (R_CS[i])
        .enb  (1'b1)
    );
end
endgenerate

generate
for (i = 0; i < NMEM; i = i+1) begin: mem1
    //  1st block
    blk_mem_gen_0 blkmem1(
        .addra(waddr  ),
        .clka (CLK    ),
        .dina (COUNTER),
        .ena  (W_CS[i]),
        .wea  (1'b1   ),
        .addrb(raddr  ),
        .clkb (TX_CLK ),
        .doutb(rd1[(i+1)*32-1:i*32]),
        //.enb  (R_CS[i])
        .enb  (1'b1)
    );
end
endgenerate

///// 32-bit to 8-bit decoder...
    reg      [3:0]    TXCOUNT ; // TXCOUNT[3]==1: Not send data...
    reg      [7:0]    rdData ; // send data
    reg     [63:0]    rdSel  ; // selected data

    always@ (posedge TX_CLK) begin
        if(RST)begin
            R_CS <= 16'd0;
        end else begin
            //case(RCOUNT[14:10])
            case(rcnt_pluse_1[14:10])
                5'h00: R_CS <= 24'b0000_0000_0000_0000_0000_0001;
                5'h01: R_CS <= 24'b0000_0000_0000_0000_0000_0010;
                5'h02: R_CS <= 24'b0000_0000_0000_0000_0000_0100;
                5'h03: R_CS <= 24'b0000_0000_0000_0000_0000_1000;
                5'h04: R_CS <= 24'b0000_0000_0000_0000_0001_0000;
                5'h05: R_CS <= 24'b0000_0000_0000_0000_0010_0000;
                5'h06: R_CS <= 24'b0000_0000_0000_0000_0100_0000;
                5'h07: R_CS <= 24'b0000_0000_0000_0000_1000_0000;
                5'h08: R_CS <= 24'b0000_0000_0000_0001_0000_0000;
                5'h09: R_CS <= 24'b0000_0000_0000_0010_0000_0000;
                5'h0A: R_CS <= 24'b0000_0000_0000_0100_0000_0000;
                5'h0B: R_CS <= 24'b0000_0000_0000_1000_0000_0000;
                5'h0C: R_CS <= 24'b0000_0000_0001_0000_0000_0000;
                5'h0D: R_CS <= 24'b0000_0000_0010_0000_0000_0000;
                5'h0E: R_CS <= 24'b0000_0000_0100_0000_0000_0000;
                5'h0F: R_CS <= 24'b0000_0000_1000_0000_0000_0000;
                5'h10: R_CS <= 24'b0000_0001_0000_0000_0000_0000;
                5'h11: R_CS <= 24'b0000_0010_0000_0000_0000_0000;
                5'h12: R_CS <= 24'b0000_0100_0000_0000_0000_0000;
                5'h13: R_CS <= 24'b0000_1000_0000_0000_0000_0000;
                5'h14: R_CS <= 24'b0001_0000_0000_0000_0000_0000;
                5'h15: R_CS <= 24'b0010_0000_0000_0000_0000_0000;
                5'h16: R_CS <= 24'b0100_0000_0000_0000_0000_0000;
                5'h17: R_CS <= 24'b1000_0000_0000_0000_0000_0000;
            endcase
        end
    end

    reg     checkHd; // check header "FF" is ok or not
    wire    rdEn;
    assign  rdEn  = (|R_CS) & ~TCP_FULL & (|W_CS) & (WCOUNT>24'd0) & checkHd & ~RST;
    assign  raddr = RCOUNT[9:0];

    always@ (posedge TX_CLK) begin
        if(RST)begin
            TXCOUNT <=  4'b1000;
            rdSel   <=  64'd0;
            checkHd <= 1'b0;
        end else begin

            if(!rdEn)begin
                TXCOUNT[3]   <= 1'b1;
                //// try to read 1st data, or failed data again, reset TX counter...
                TXCOUNT[2:0] <= 3'd0;
                //case(RCOUNT[14:10]) /// Depending on NMEM...
                case(rcnt_pluse_1[14:10]) /// Depending on NMEM...
                    5'h00: rdSel <= {rd1[ 1*32-1: 0*32],rd0[ 1*32-1: 0*32]};
                    5'h01: rdSel <= {rd1[ 2*32-1: 1*32],rd0[ 2*32-1: 1*32]};
                    5'h02: rdSel <= {rd1[ 3*32-1: 2*32],rd0[ 3*32-1: 2*32]};
                    5'h03: rdSel <= {rd1[ 4*32-1: 3*32],rd0[ 4*32-1: 3*32]};
                    5'h04: rdSel <= {rd1[ 5*32-1: 4*32],rd0[ 5*32-1: 4*32]};
                    5'h05: rdSel <= {rd1[ 6*32-1: 5*32],rd0[ 6*32-1: 5*32]};
                    5'h06: rdSel <= {rd1[ 7*32-1: 6*32],rd0[ 7*32-1: 6*32]};
                    5'h07: rdSel <= {rd1[ 8*32-1: 7*32],rd0[ 8*32-1: 7*32]};
                    5'h08: rdSel <= {rd1[ 9*32-1: 8*32],rd0[ 9*32-1: 8*32]};
                    5'h09: rdSel <= {rd1[10*32-1: 9*32],rd0[10*32-1: 9*32]};
                    5'h0A: rdSel <= {rd1[11*32-1:10*32],rd0[11*32-1:10*32]};
                    5'h0B: rdSel <= {rd1[12*32-1:11*32],rd0[12*32-1:11*32]};
                    5'h0C: rdSel <= {rd1[13*32-1:12*32],rd0[13*32-1:12*32]};
                    5'h0D: rdSel <= {rd1[14*32-1:13*32],rd0[14*32-1:13*32]};
                    5'h0E: rdSel <= {rd1[15*32-1:14*32],rd0[15*32-1:14*32]};
                    5'h0F: rdSel <= {rd1[16*32-1:15*32],rd0[16*32-1:15*32]};
                    5'h10: rdSel <= {rd1[17*32-1:16*32],rd0[17*32-1:16*32]};
                    5'h11: rdSel <= {rd1[18*32-1:17*32],rd0[18*32-1:17*32]};
                    5'h12: rdSel <= {rd1[19*32-1:18*32],rd0[19*32-1:18*32]};
                    5'h13: rdSel <= {rd1[20*32-1:19*32],rd0[20*32-1:19*32]};
                    5'h14: rdSel <= {rd1[21*32-1:20*32],rd0[21*32-1:20*32]};
                    5'h15: rdSel <= {rd1[22*32-1:21*32],rd0[22*32-1:21*32]};
                    5'h16: rdSel <= {rd1[23*32-1:22*32],rd0[23*32-1:22*32]};
                    5'h17: rdSel <= {rd1[24*32-1:23*32],rd0[24*32-1:23*32]};
                    default: rdSel <= 64'hFF_FF_FF_FF_00_00_00_00;
                endcase
                checkHd <= (rdSel[31:24]==8'hFF)? 1'b1 : 1'b0;
            end else begin
                if(TXCOUNT[3])begin
                    TXCOUNT[3]   <= 1'b0;
                    TXCOUNT[2:0] <= 3'd6; // skip...
                end else begin
                    TXCOUNT[2:0] <= TXCOUNT[2:0]+3'd1;
                end

                if(TXCOUNT[2:0]==3'd7)begin // Read the next data...
                    //case(RCOUNT[14:10]) /// Depending on NMEM...
                    case(rcnt_pluse_1[14:10]) /// Depending on NMEM...
                        5'h00: rdSel <= {rd1[ 1*32-1: 0*32],rd0[ 1*32-1: 0*32]};
                        5'h01: rdSel <= {rd1[ 2*32-1: 1*32],rd0[ 2*32-1: 1*32]};
                        5'h02: rdSel <= {rd1[ 3*32-1: 2*32],rd0[ 3*32-1: 2*32]};
                        5'h03: rdSel <= {rd1[ 4*32-1: 3*32],rd0[ 4*32-1: 3*32]};
                        5'h04: rdSel <= {rd1[ 5*32-1: 4*32],rd0[ 5*32-1: 4*32]};
                        5'h05: rdSel <= {rd1[ 6*32-1: 5*32],rd0[ 6*32-1: 5*32]};
                        5'h06: rdSel <= {rd1[ 7*32-1: 6*32],rd0[ 7*32-1: 6*32]};
                        5'h07: rdSel <= {rd1[ 8*32-1: 7*32],rd0[ 8*32-1: 7*32]};
                        5'h08: rdSel <= {rd1[ 9*32-1: 8*32],rd0[ 9*32-1: 8*32]};
                        5'h09: rdSel <= {rd1[10*32-1: 9*32],rd0[10*32-1: 9*32]};
                        5'h0A: rdSel <= {rd1[11*32-1:10*32],rd0[11*32-1:10*32]};
                        5'h0B: rdSel <= {rd1[12*32-1:11*32],rd0[12*32-1:11*32]};
                        5'h0C: rdSel <= {rd1[13*32-1:12*32],rd0[13*32-1:12*32]};
                        5'h0D: rdSel <= {rd1[14*32-1:13*32],rd0[14*32-1:13*32]};
                        5'h0E: rdSel <= {rd1[15*32-1:14*32],rd0[15*32-1:14*32]};
                        5'h0F: rdSel <= {rd1[16*32-1:15*32],rd0[16*32-1:15*32]};
                        5'h10: rdSel <= {rd1[17*32-1:16*32],rd0[17*32-1:16*32]};
                        5'h11: rdSel <= {rd1[18*32-1:17*32],rd0[18*32-1:17*32]};
                        5'h12: rdSel <= {rd1[19*32-1:18*32],rd0[19*32-1:18*32]};
                        5'h13: rdSel <= {rd1[20*32-1:19*32],rd0[20*32-1:19*32]};
                        5'h14: rdSel <= {rd1[21*32-1:20*32],rd0[21*32-1:20*32]};
                        5'h15: rdSel <= {rd1[22*32-1:21*32],rd0[22*32-1:21*32]};
                        5'h16: rdSel <= {rd1[23*32-1:22*32],rd0[23*32-1:22*32]};
                        5'h17: rdSel <= {rd1[24*32-1:23*32],rd0[24*32-1:23*32]};
                        default: rdSel <= 64'hFF_FF_FF_FF_00_00_00_00;
                    endcase
                    checkHd <= (rdSel[31:24]==8'hFF)? 1'b1 : 1'b0;
                end
            end

        end
    end

    reg sendData;

    always@ (posedge TX_CLK) begin
        if(RST)begin
            RCOUNT <= 24'd0;
            DOUT   <= 8'd0;
            sendData <= 1'b0;
        end else begin
            //if(TXCOUNT[3]==1'b0)begin
            if(rdEn)begin
                case(TXCOUNT[2:0])
                    3'd3: DOUT <= rdSel[8*0+7:8*0];
                    3'd2: DOUT <= rdSel[8*1+7:8*1];
                    3'd1: DOUT <= rdSel[8*2+7:8*2];
                    3'd0: DOUT <= rdSel[8*3+7:8*3];
                    3'd7: DOUT <= rdSel[8*4+7:8*4];
                    3'd6: DOUT <= rdSel[8*5+7:8*5];
                    3'd5: DOUT <= rdSel[8*6+7:8*6];
                    3'd4: DOUT <= rdSel[8*7+7:8*7];
                endcase
                sendData <= 1'b1;
                RCOUNT <= (TXCOUNT==3'd7)? RCOUNT + 24'd1 : RCOUNT;
                //RCOUNT <= (TXCOUNT==3'd1)? RCOUNT + 24'd1 : RCOUNT;
                //RCOUNT <= (TXCOUNT==3'd2)? RCOUNT + 24'd1 : RCOUNT;
            end else begin
                DOUT <= 8'h00;
                sendData <= 1'b0;
            end
        end
    end

    assign R_EN    = rdEn;
    assign SEND_EN = sendData;

endmodule
