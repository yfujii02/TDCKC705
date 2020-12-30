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


module DATA_BUF_singleBRAM(
    RST,      // in  System Reset
    CLK,      // in  System CLK
    TX_CLK,   // in  TX CLk
    COUNTER,  // in  Counter value [31:0]
    SPLSTART, // in  Start Spill (Enable When Spill Signal Comes)
    SPLEND,   // in  End Spill
    SPLCOUNT, // in  Header (Header[7:0] SPILL Count [7:0])
    SIG,      // in  MRSYNC[16], Hodoscope[15:0]
    EMCOUNT,  // in  Event matching count [15:0]
    DOUT,     // out Output data [7:0]
    SDATA,    // out Output data for check [55:0]
    R_EN,     // out Read  enable
    SEND_EN,  // out Send data enable
    WCOUNT,   // out Read  Event counter
    RCOUNT,   // out Write Event counter
    TXCOUNT,  // out Tx counter
    TCP_FULL  // in  TCP Full flag
);
    input             RST     ;
    input             CLK     ;
    input             TX_CLK  ;
    input   [31:0]    COUNTER ;
    input             SPLSTART;
    input             SPLEND  ;
    input   [15:0]    SPLCOUNT;
    input   [16:0]    SIG     ; // SIG[16]==MRSYNC
    input   [15:0]    EMCOUNT ;
    output   [7:0]    DOUT    ;
    output  [55:0]    SDATA   ;
    output            R_EN    ;
    output            SEND_EN ;
    output  [31:0]    WCOUNT  ;
    output  [31:0]    RCOUNT  ;
    output   [3:0]    TXCOUNT ;
    input             TCP_FULL;


    reg      [7:0]    DOUT    ;
    reg               ENABLE  ; // Enable on until the spill end
    wire              R_EN    ;
    wire              SEND_EN ;
    reg     [31:0]    WCOUNT  ; // number of written data
    reg     [31:0]    RCOUNT  ; // number of read data

    reg     [55:0]    DIN     ;
    reg               W_EN    ;
    reg      [2:0]    endReg  ;

    always@ (posedge CLK) begin
        if(RST)begin
            DIN    <= 56'd0;
            WCOUNT <= 32'd0;
            W_EN   <=  1'b0;
            ENABLE <=  1'b0;
            endReg <=  3'd0;
        end else begin
            endReg <= {endReg[1:0],SPLEND};
            if (SPLSTART)begin
                ENABLE <= 1'b1;
                WCOUNT <= WCOUNT + 32'd1;
                DIN    <= {40'hAA_AA_AA_AA_AA,SPLCOUNT};
                W_EN   <= 1'b1;
            end else if (SPLEND)begin
                ENABLE <= 1'b0;
            end else if (endReg[1])begin
                WCOUNT <= WCOUNT + 32'd1;
                //DIN    <= {24'hFF_FF_FF,COUNTER};
                DIN    <= {40'hFF_FF_FF_FF_FF,EMCOUNT};
                W_EN   <= 1'b1;
            end else if (endReg[2])begin
                W_EN   <= 1'b0;
            end

            if (ENABLE)begin
                DIN    <= {7'b0000000,SIG[16:0],COUNTER};
                if (|SIG)begin
                    WCOUNT <= WCOUNT + 32'd1;
                    W_EN   <= 1'b1;
                end else begin
                    W_EN   <= 1'b0;
                end
            end
        end
    end
/*
    reg     [31:0]    dlyWCNT ; // number of written data
    reg               dlyW_EN ;
    always@ (posedge CLK) begin
        if(RST)begin
            dlyWCNT <= 32'd0;
            dlyW_EN <=  1'b0;
        end else begin
            dlyWCNT <= WCOUNT;
            dlyW_EN <= W_EN;
        end
    end
*/
    //wire    [15:0]    waddr ;
    //wire    [15:0]    raddr ;
    wire    [16:0]    waddr ; // KC705
    wire    [16:0]    raddr ; // KC705
    wire    [55:0]    rdata ;

    //assign waddr = WCOUNT[15:0];
    //assign raddr = RCOUNT[15:0]+16'd1;
    assign waddr = WCOUNT[16:0];       // KC705
    assign raddr = RCOUNT[16:0]+17'd1; // KC705

///// Memory block...
    blk_mem_gen_1 blkmem(
        .addra(waddr  ),
        .clka (CLK    ),
        .dina (DIN    ),
        .ena  (W_EN   ),
        .wea  (1'b1   ),
        .addrb(raddr  ),
        .clkb (TX_CLK ),
        .doutb(rdata  ),
        .enb  (1'b1   )
    );

///// 32-bit to 8-bit decoder...
    reg      [3:0]    TXCOUNT   ; // TXCOUNT[3]==1: Not send data...
    reg      [7:0]    rdData    ; // send data
    reg     [55:0]    rdReg     ; // selected data
    wire              rdEn      ; // data read enable
    wire              rdBusy    ; // data send enable

    assign  rdEn   = TXCOUNT[3] & (WCOUNT>32'd0) & (WCOUNT-RCOUNT>32'd0);
    assign  rdBusy = ~TXCOUNT[3] & (WCOUNT>32'd0) & (WCOUNT-RCOUNT>32'd0) & ~TCP_FULL;

    always@ (posedge TX_CLK) begin
        if(RST)begin
            TXCOUNT    <=  4'b1000;
            rdReg      <=  56'd0  ;
        end else begin
            if(rdEn)begin
                TXCOUNT <= 4'b0110;
                rdReg   <= rdata;
            end else if ((WCOUNT>32'd0) & (WCOUNT-RCOUNT>32'd0) & ~TCP_FULL) begin
                TXCOUNT <= TXCOUNT-4'd1;
            end else begin
                TXCOUNT <= TXCOUNT;
            end
        end
    end

    reg      [3:0]    dlyTXCOUNT;
    reg               dlyRdBusy ;
    always@ (posedge TX_CLK) begin
        if(RST)begin
            dlyTXCOUNT <=  4'hF ;
            dlyRdBusy  <=  1'b0 ;
        end else begin
            dlyTXCOUNT <= TXCOUNT;
            dlyRdBusy  <= rdBusy ;
        end
    end

    reg               sendData  ;

    always@ (posedge TX_CLK) begin
        if(RST)begin
            RCOUNT   <= 32'd0;
            DOUT     <=  8'd0;
            sendData <=  1'b0;
        end else begin
            if(dlyRdBusy)begin
                case(dlyTXCOUNT[2:0])
                    3'd0: DOUT <= rdReg[8*0+7:8*0];
                    3'd1: DOUT <= rdReg[8*1+7:8*1];
                    3'd2: DOUT <= rdReg[8*2+7:8*2];
                    3'd3: DOUT <= rdReg[8*3+7:8*3];
                    3'd4: DOUT <= rdReg[8*4+7:8*4];
                    3'd5: DOUT <= rdReg[8*5+7:8*5];
                    3'd6: DOUT <= rdReg[8*6+7:8*6];
                endcase
                sendData <= 1'b1;
                RCOUNT   <= (dlyTXCOUNT==4'd0)? RCOUNT + 32'd1 : RCOUNT;
            end else begin
                DOUT     <=  8'd0;
                sendData <=  1'b0;
            end
        end
    end

    assign R_EN    = rdEn    ;
    assign SEND_EN = sendData;
    assign SDATA   = rdReg   ;

endmodule
