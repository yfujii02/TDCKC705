
module GET_SPILLINFO(
    input    wire           RESET      ,
    input    wire           CLK_200M   ,
    input    wire           PSPILL     ,
    input    wire           MR_SYNC    ,
    output   wire   [31:0]  SPILLCOUNT ,
    output   reg            SPILL_EDGE ,
    input    wire           EV_MATCH   ,
    output   reg    [15:0]  EM_COUNT
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
            irSPILLCOUNT <= 32'd0;

            EM_REG     <= 2'b00;
            EM_EDGE    <= 1'b0;
        end else begin
            SPL_REG    <= {SPL_REG[0],PSPILL};
            SPILL_EDGE   <= (SPL_REG==2'b01);
            irSPILLCOUNT <= (SPL_REG==2'b10)? irSPILLCOUNT+32'd1 : irSPILLCOUNT;

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

endmodule
