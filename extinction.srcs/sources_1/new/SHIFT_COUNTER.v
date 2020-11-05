module SHIFT_COUNTER(
    RST,
    CLK,
    EN,
    SIG,
    EOD,
    RELCNTR,
    RLENGTH,
    COUNTER
);
    input               RST     ;
    input               CLK     ;
    input               EN      ;
    input               SIG     ;
    input               EOD     ;
    input       [10:0]  RELCNTR ;
    input       [10:0]  RLENGTH ;
    output      [23:0]  COUNTER ;

    reg         [23:0]  regCNTR ;
    reg          [1:0]  regEN   ;
    reg                 ROMODE  ; // readout mode...
    wire        [23:0]  wCNTR   ;
    wire        [23:0]  COUNTER ;
    wire        [10:0]  raddr   ;
    reg                 doRESET ;
    reg         [11:0]  RSTCNTR ;

    reg  [10:0]  dlyCNTR1CLK;
    reg  [10:0]  dlyCNTR2CLK;
    reg  [10:0]  dlyCNTR3CLK;

    assign wCNTR = regCNTR;
    assign raddr = (ROMODE==1'b1)? RLENGTH : RELCNTR;

    always@ (posedge CLK) begin
        if(RST) begin
            regCNTR <= 24'd0;
            ROMODE  <=  1'b0;
            regEN   <=  2'd0;
            doRESET <=  1'b1;
            RSTCNTR <= 12'd0;
        end else begin
            regEN   <= {regEN[0],EN};
            if(regEN==2'b10) begin // End of spill
               ROMODE <= 1'b1;
            end
            if(EOD) begin          // End of data read
               ROMODE <= 1'b0;
            end

            if(EN) begin
                regCNTR <= (SIG==1'b1)? COUNTER + 24'd1 : COUNTER;
            end else if(EOD) begin
                doRESET <=  1'b1;
            end else if (doRESET) begin
                regCNTR <= 24'd0;
            end

            RSTCNTR <= (doRESET)? RSTCNTR + 12'd1 : 12'd0;

            if (RSTCNTR==12'hFFF) begin
                doRESET  <=  1'b0;
                RSTCNTR  <= 12'd0;
            end
        end
    end

    always@ (posedge CLK) begin
        if(RST) begin
            dlyCNTR1CLK <= 11'd0;
        end else begin
            dlyCNTR1CLK <= RELCNTR;
        end
    end
    always@ (posedge CLK) begin
        if(RST) begin
            dlyCNTR2CLK <= 11'd0;
        end else begin
            dlyCNTR2CLK <= dlyCNTR1CLK;
        end
    end
    always@ (posedge CLK) begin
        if(RST) begin
            dlyCNTR3CLK <= 11'd0;
        end else begin
            dlyCNTR3CLK <= dlyCNTR2CLK;
        end
    end

    bram_3byte_2K bram(
        // write memory
        .addra(dlyCNTR3CLK  ),
        .clka (CLK          ),
        .dina (wCNTR        ),
        .ena  ((EN|doRESET) ),
        .wea  (1'b1         ),
        // read memory
        .addrb(raddr        ),
        .clkb (CLK          ),
        .doutb(COUNTER      ),
        .enb  (1'b1         ) 
    );

endmodule
