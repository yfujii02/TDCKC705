`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  KEK-IPNS
// Engineer: Yuki Fujii
// 
// Create Date: 2017/10/25 09:18:02
// Design Name: 
// Module Name: DATA_BUF
// Project Name: Data buffer for Multi Channel Scaler using KC705 Educational Board
// Target Devices: KC705
// Tool Versions:  v1
// Description:  Data buffer consisits of multi block memories
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DATA_BUF_singleBRAM2(
    RST,      // in  System Reset
    CLK,      // in  System CLK
    DATA_TRG, // in  Trigger for signals
    COUNTER,  // in  Counter value [31:0]
    SPLSTART, // in  Start Spill (Enable When Spill Signal Comes)
    SPLEND,   // in  End Spill
    SPLCOUNT, // in  Header (Header[7:0] SPILL Count [7:0])
    SIG,      // in  MRSYNC[65], COINC[64], Hodoscope[63:0]
    START,    // in  DAQ start signal
    EMCOUNT,  // in  Event matching count [15:0]
    BOARD_ID, // in  Board ID [3:0]
    HEADER,   // in  Header [83:0]
    FOOTER,   // in  Footer [83:0]
    TRIGGER_INT, // out Internal trigger to readout the data
    DOUT,        // out Output data [7:0]
    SEND_EN,     // out Send packet enable
    TCP_FULL,    // in  TCP Full flag
    DEBUG_DATA_EN,
    DEBUG_DATA_END,
    DEBUG_DLY_EN,
    DEBUG_RD_EN,
    DEBUG_CNT,
    DEBUG_FIFO_CNT
);
    input             RST     ;
    input             CLK     ;
    input             DATA_TRG;
    input   [31:0]    COUNTER ;
    input             SPLSTART;
    input             SPLEND  ;
    input   [15:0]    SPLCOUNT;
    input   [76:0]    SIG     ; // MRSYNC[76], OLDH[75:64], Hodoscope[63:0]
    input             START   ;
    input   [15:0]    EMCOUNT ;
    input    [3:0]    BOARD_ID;
    input   [83:0]    HEADER  ;
    input   [83:0]    FOOTER  ;
    output            TRIGGER_INT;
    output   [7:0]    DOUT    ;
    output            SEND_EN ;
    input             TCP_FULL;
    output            DEBUG_DATA_EN;
    output            DEBUG_DATA_END;
    output  [  7:0]   DEBUG_DLY_EN;
    output            DEBUG_RD_EN;
    output   [7:0]    DEBUG_CNT;
    output  [15:0]    DEBUG_FIFO_CNT;

    reg               ENABLE  ; // Enable on until the spill end

    reg    [103:0]    DIN     ; // 8*13
    reg               W_EN    ;
    reg      [2:0]    endReg  ;
    reg      [1:0]    regFFull; // fifo full

    wire            fifo_rd_en;
    wire            fifo_wr_en;
    wire            fifo_full ;
    wire            fifo_empty;
    wire   [103:0]  data_out  ;
    wire   [ 16:0]  data_count;
    wire            sbiterr   ;
    wire            dbiterr   ;

    /// Current data size = 13-bytes, to make the data rate as small as possible.
    /// possible option is to make counter 27-bits to 32-bits and make it 14-bytes
    /// for analysis convenience and redundancy. To be decided later...
    always@ (posedge CLK) begin
        if(RST)begin
            DIN     <= 104'd0;
            W_EN    <=  1'b0;
            ENABLE  <=  1'b0;
            endReg  <=  3'd0;
            regFFull<=  2'd0;
        end else begin
            endReg <= {endReg[1:0],SPLEND};
            if (SPLSTART)begin
                ENABLE <= 1'b1;
                DIN    <= 104'h0246_8ACE_ECA8_6420_048C_26AE_EA;
                //DIN    <= {BOARD_ID[3:0],SPLCOUNT[15:0],HEADER}; // HEADER = 20'hA_BB_00 + 
                                                                 //  REG_HEADER[31:0]x2 = 84-bits
                W_EN   <= 1'b1;
            end else if (SPLEND)begin
                ENABLE <= 1'b0;
                DIN    <= 104'h1357_9BDF_FDB9_7531_159D_37BF_FB;
                //DIN    <= {EMCOUNT[15:0],4'h0,FOOTER}; // FOOTER = 20'hF_EE_00 +
                                                       //   REG_FOOTER[31:0]x2 = 84-bits
            end else if (endReg[1])begin
                W_EN   <= 1'b1;
            end else if (endReg[2])begin
                W_EN   <= 1'b0;
            end

            if (ENABLE)begin
                regFFull <= {regFFull[0],fifo_full};
                if (DATA_TRG && ~fifo_full) begin
                    DIN    <= {SIG[76:0],COUNTER[26:0]}; // 104-bits
                                                         // {MainHodo[63:0],PMR[11:0],MR_Sync,COUNTER[26:0]}
                                                         // COUNTER start from SPILL signal
                                                         //  and increment with 200MHz SYSCLK

                    W_EN   <= 1'b1;
                end else begin
                    W_EN   <= 1'b0;
                end
            end
        end
    end

///// fifo
    wire              SYSCLKR      ;
    wire              reg_sysrstA  ;
    wire              reg_sysrstB  ;
    wire              reg_sysrstTmp;
    BUFR BUFR_RAD(.I(CLK), .O(SYSCLKR));
    FD FD_RESET_TMP (.C(SYSCLKR), .Q(reg_sysrstTmp), .D(RST));
    FD FD_RESET_A (.C(SYSCLKR), .Q(reg_sysrstA), .D(reg_sysrstTmp));
    FD FD_RESET_B (.C(SYSCLKR), .Q(reg_sysrstB), .D(reg_sysrstTmp));

    assign fifo_wr_en = W_EN;

    assign TRIGGER_INT = (START==1'b1)? ~fifo_empty && ~TCP_FULL : 1'b0;

    fifo_generator_0 fifo(
        .clk            (SYSCLKR         ), // in : System Clock
        .srst           (reg_sysrstA     ), // in : System Reset
        .din            (DIN[103:0]      ), // in : Input data [63:0]
        .wr_en          (fifo_wr_en      ), // in : Write Enable
        .rd_en          (fifo_rd_en      ), // in : Read Enable
        .dout           (data_out[103:0] ), // out: Output Data [63:0]
        .full           (fifo_full       ), // out: FIFO Full
        .empty          (fifo_empty      ), // out: FIFO Empty
        .data_count     (data_count[16:0])  // out: # of data in FIFO
    );
//        .sbiterr        (sbiterr         ), // out: Single Bit Error
//        .dbiterr        (dbiterr         )  // out: Double Bit Error
//    );

    OUT_DATA_PACK OUT_DATA_PACK(
        .SYSCLK         (SYSCLKR              ), // in
        .SYSRST         (reg_sysrstB          ), // in
        .TRIGGER        (TRIGGER_INT          ), // in
        .DATA           (data_out[103:0]      ), // in
        .FIFO_RD_EN     (fifo_rd_en           ), // out
        .OUT_VALID      (SEND_EN              ), // out
        .OUT            (DOUT[7:0]            ), // out
        .DEBUG_DATA_EN  (DEBUG_DATA_EN        ), // out
        .DEBUG_DATA_END (DEBUG_DATA_END       ), // out
        .DEBUG_DLY_EN   (DEBUG_DLY_EN         ), // out
        .DEBUG_RD_EN    (DEBUG_RD_EN          ), // out
        .DEBUG_CNT      (DEBUG_CNT            )  // out
    );
endmodule

module OUT_DATA_PACK(
    input           SYSCLK,
    input           SYSRST,
    input           TRIGGER,
    input   [103:0] DATA,
    output          FIFO_RD_EN,
    output          OUT_VALID,
    output  [  7:0] OUT,
    output          DEBUG_DATA_EN,
    output          DEBUG_DATA_END,
    output  [  7:0] DEBUG_DLY_EN,
    output          DEBUG_RD_EN,
    output  [  7:0] DEBUG_CNT
    );
    
    reg         data_en;
    reg         data_end;
    wire        footer_flag;
    assign DEBUG_DATA_EN  = data_en;
    assign DEBUG_DATA_END = data_end;
    always@(posedge SYSCLK) begin
        if(SYSRST) begin
            data_en <= 1'b0;
        end else if(TRIGGER) begin
            data_en <= 1'b1;
        end else if(data_end) begin
            data_en <= 1'b0;
        end else begin
            data_en <= data_en;
        end
    end
    
    reg [3:0]  count;
    always@(posedge SYSCLK) begin
        if(SYSRST) begin
            count[3:0] <= 4'd0;
        end else if(~data_en) begin // Reset count when it reaches the maximum
            count[3:0] <= 4'd0;
        end else if (data_en) begin
            count[3:0] <= count[3:0] + 4'd1;
        end
    end
    
    always@(posedge SYSCLK) begin
        if(SYSRST) begin
            data_end <= 1'b0;
        end else if(data_en && count[3:0]==4'd13)begin
            data_end <= 1'b1;
        end else begin
            data_end <= 1'b0;
        end
    end
    
    reg     [11:0]  count_tmp ;
    reg      [2:0]  data_outEN;
    /// 2 CLKs delay to account for the data reading from FIFO
    ///  and 1 CLK to wait for the data_out <= reg_data
    always@(posedge SYSCLK) begin
        count_tmp[11:0] <= {count_tmp[7:0], count[3:0]};
        data_outEN[2:0] <= {data_outEN[1:0],(data_en & ~data_end)};
    end
    
    reg rd_en;
    always@(posedge SYSCLK) begin
        if(SYSRST) begin
            rd_en <= 1'b0;
        end else if (data_en && (count[3:0]==4'h0)) begin
            rd_en <= 1'b1; /// Read enable only when FIFO is not empty and counter is ready to receive the new data
        end else begin
            rd_en <= 1'b0;
        end
    end
    assign FIFO_RD_EN = rd_en & ~data_end; // 1CLK wait to read the data if it has just finished sending the data..
   
    wire         out_val;
    /// valid=H only when shifted counter value is non-zero
    assign out_val = data_outEN[2] & (count_tmp[11:8]!=4'd0) & (count_tmp[11:8]<4'd14);
    assign OUT_VALID = out_val;

    reg     [103:0]     reg_data;
    always@(posedge SYSCLK) begin
        reg_data[103:0] <= DATA[103:0];
    end
    
    wire    [7:0]   data_out_tmp;
    reg     [7:0]   data_out;
    wire    [3:0]   data_out_count;
    assign data_out_count = count_tmp[11:8];
    always@(posedge SYSCLK) begin
        case(data_out_count)
            4'd0:    data_out[7:0] <= reg_data[103: 96];
            4'd1:    data_out[7:0] <= reg_data[ 95: 88];
            4'd2:    data_out[7:0] <= reg_data[ 87: 80];
            4'd3:    data_out[7:0] <= reg_data[ 79: 72];
            4'd4:    data_out[7:0] <= reg_data[ 71: 64];
            4'd5:    data_out[7:0] <= reg_data[ 63: 56];
            4'd6:    data_out[7:0] <= reg_data[ 55: 48];
            4'd7:    data_out[7:0] <= reg_data[ 47: 40];
            4'd8:    data_out[7:0] <= reg_data[ 39: 32];
            4'd9:    data_out[7:0] <= reg_data[ 31: 24];
            4'd10:   data_out[7:0] <= reg_data[ 23: 16];
            4'd11:   data_out[7:0] <= reg_data[ 15:  8];
            4'd12:   data_out[7:0] <= reg_data[  7:  0];
            default: data_out[7:0] <= 8'hFF;
        endcase
    end
    assign OUT[7:0] = out_val ? data_out[7:0] : 8'hCC;

    assign DEBUG_CNT[7:0] = count_tmp[11:4];
    assign DEBUG_DLY_EN[7:0] = {5'd0,data_en,data_end,rd_en};
    assign DEBUG_DATA_EN  = data_en;
    assign DEBUG_DATA_END = data_end;
    assign DEBUG_RD_EN    = rd_en;
    
endmodule
