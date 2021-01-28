
module GET_SPILLINFO(
    input    wire           RESET      ,
    input    wire           CLK_200M   ,
    input    wire           SPLCNT_RST     ,
    input    wire           INT_SPLCNT_RST ,
    input    wire   [7:0]   INT_SPLCNT_RSTT,
    output   wire           EX_SPLCNT_RST  ,
    input    wire           PSPILL     ,
    input    wire           MR_SYNC    ,
    output   wire   [31:0]  SPILLCOUNT ,
    output   reg            SPILL_EDGE ,
    output   reg            SPILL_END  ,
    input    wire           EV_MATCH   ,
    output   reg    [15:0]  EM_COUNT   ,
    output   wire    [7:0]  DEBUG_SPLOFFCNT,
    output   wire    [2:0]  DEBUG_DLYSPLCNT
);

    reg      [1:0]    SPL_REG   ;
    reg      [1:0]    EM_REG    ;
    reg               EM_EDGE   ;
    reg     [31:0]  irSPILLCOUNT; // Spill counter
    assign SPILLCOUNT = irSPILLCOUNT;

    always@ (posedge CLK_200M) begin
        if(RESET)begin
            SPL_REG    <= 2'b00;
            SPILL_EDGE <= 1'b0;
            SPILL_END  <= 1'b0;
            irSPILLCOUNT <= 32'd0;

            EM_REG     <= 2'b00;
            EM_EDGE    <= 1'b0;
        end else begin
            SPL_REG    <= {SPL_REG[0],PSPILL};
            SPILL_EDGE   <= (SPL_REG==2'b01);
            SPILL_END    <= (SPL_REG==2'b10);
            if(SPLCNT_RST) begin
              irSPILLCOUNT <= 32'd0;
            end else begin
              irSPILLCOUNT <= (SPILL_END==1'b1)? irSPILLCOUNT+32'd1 : irSPILLCOUNT;
            end

            EM_REG     <= {EM_REG[0],EV_MATCH};
            EM_EDGE    <= (EM_REG==2'b01);
        end
    end

    reg    [15:0]    EMCOUNTER ; // Counter for Event matching signal
    reg              EMDONE    ;
    reg              EN_EMCOUNT;

    always@ (posedge CLK_200M) begin
        if(RESET)begin
            EMCOUNTER <= 16'd0;
            EM_COUNT  <= 16'd0;
            EN_EMCOUNT<=  1'b0;
            EMDONE    <=  1'b0;
        end else begin
            if(SPILL_EDGE)begin
                EMCOUNTER <= 16'd0;
                EM_COUNT  <= 16'd0;
                EN_EMCOUNT<=  1'b0;
                EMDONE    <=  1'b0;
            end
            if(MR_SYNC & ~EMDONE)begin
                if(EM_EDGE & (EMCOUNTER==16'd0))begin
                    EN_EMCOUNT <=  1'b1;
                end
            end
            if(EN_EMCOUNT & ~EMDONE)begin
                EMCOUNTER  <= EMCOUNTER + 16'd1;
            end
            if(EMCOUNTER>16'd0 & EM_EDGE & (EM_COUNT==16'd0))begin
                EN_EMCOUNT <= 1'b0;
                EM_COUNT   <= EMCOUNTER;
                EMDONE     <= 1'b1;
            end
        end
    end

    reg     [7:0]    spl_off_cnt ;
    reg     [2:0]    dlySplCntRst;
    always@(posedge CLK_200M) begin
        if(RESET || SPILL_END)begin
            spl_off_cnt[7:0] <= 8'd0;
        end else if(spl_off_cnt[7:0]==8'hFF) begin
            spl_off_cnt[7:0] <= spl_off_cnt[7:0];
        end else begin
            spl_off_cnt[7:0] <= spl_off_cnt[7:0] + 8'd1;
        end

        if(RESET) begin
            dlySplCntRst[2:0] <= 3'b000;
        end else if(INT_SPLCNT_RST) begin
            dlySplCntRst[2:0] <= 3'b111;
        end else if(spl_off_cnt[7:0]==INT_SPLCNT_RSTT[7:0]) begin
            dlySplCntRst[2:0] <= dlySplCntRst[0] ? 3'b010 : {dlySplCntRst[1:0], 1'b0};
        end else begin
            dlySplCntRst[2:0] <= dlySplCntRst[0] ? 3'b111 : {dlySplCntRst[1:0], 1'b0};
        end
    end
    assign EX_SPLCNT_RST = dlySplCntRst[2] ^ dlySplCntRst[1]; // H within 2 CLK
    assign DEBUG_SPLOFFCNT[7:0] = spl_off_cnt[7:0];
    assign DEBUG_DLYSPLCNT[2:0] = dlySplCntRst[2:0];
endmodule
