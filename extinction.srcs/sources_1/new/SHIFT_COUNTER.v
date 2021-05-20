module SHIFT_COUNTER_ALL
    #(parameter NCHANNEL=74,
      parameter DWIDTH=16) (
        input   wire                    RST,
        input   wire                    CLK,
        input   wire                    EN,
        input   wire    [NCHANNEL-1:0]  SIG,
        input   wire                    EOD,
        //input   wire    [10:0]          RELCNTR,
        input   wire                    MR_SYNC,
        input   wire    [10:0]          RLENGTH,
        output  wire    [NCHANNEL*DWIDTH-1:0]   COUNTER
    );
genvar i;
generate
    for (i = 0; i < NCHANNEL; i = i+1) begin: CHANNEL_BLK
        reg   [1:0]  regEOD;
        reg          edgeEOD;
        reg          regRST;
        reg          regEN;
        always@ (posedge CLK) begin
            if(RST) begin
                regEOD[1:0] <= 2'd0;
                edgeEOD     <= 1'b0;
                regRST      <= 1'b1;
            end else begin
                regEOD[1:0] <= {regEOD[0],EOD};
                edgeEOD     <= (regEOD[1:0]==2'b01)? 1'b1 : 1'b0;
                regRST      <= 1'b0;
            end
            regEN <= EN;
        end

        SHIFT_COUNTER_EACH shift_cntr(
            //.RST    (RST    ),
            .RST    (regRST ),
            .CLK    (CLK    ),
            .EN     (regEN  ),
            //.EN     (EN     ),
            .SIG    (SIG[i] ),
            .EOD    (edgeEOD    ), // end of data sending
            //.EOD    (EOD    ), // end of data sending
            //.RELCNTR(RELCNTR),
            .MR_SYNC(MR_SYNC),
            .RLENGTH(RLENGTH),
            .COUNTER(COUNTER[(i+1)*DWIDTH-1:i*DWIDTH])
        );
    end
endgenerate
endmodule


module SHIFT_COUNTER_EACH(
    input  wire           RST,
    input  wire           CLK,
    input  wire           EN,
    input  wire           SIG,
    input  wire           EOD,
    //input  wire  [10:0]   RELCNTR,
    input  wire           MR_SYNC,
    input  wire  [10:0]   RLENGTH,
    output wire  [15:0]   COUNTER
);

    reg         [15:0]  regCNTR ;
    reg          [1:0]  regEN   ;
    reg                 ROMODE  ; // readout mode...
    wire        [15:0]  wCNTR   ;
    wire        [10:0]  raddr   ;
    reg                 doRESET ;
    reg         [10:0]  RSTCNTR ;

    reg         [10:0]  RELCNTR ;
    always@ (posedge CLK) begin
        if(RST) begin
            RELCNTR <= 11'd0;
        end else begin
            if (MR_SYNC) begin
                RELCNTR <= 11'd0;
            end else begin
                RELCNTR <= RELCNTR+11'd1;
            end
        end
    end

    reg  [10:0]  dlyCNTR1CLK;
    reg  [10:0]  dlyCNTR2CLK;
    reg  [10:0]  dlyCNTR3CLK;

    assign wCNTR = regCNTR;
    assign raddr = (ROMODE==1'b1)? RLENGTH : RELCNTR;

    reg   regEOD0; 
    reg   regEOD1; 
    always@ (posedge CLK) begin
        if(RST) begin
            regEOD0 <= 1'b0;
            regEOD1 <= 1'b0;
        end else begin
            regEOD0 <= EOD;
            regEOD1 <= EOD;
        end
    end

    always@ (posedge CLK) begin
        if(RST) begin
            regCNTR <= 16'd0;
            ROMODE  <=  1'b0;
            regEN   <=  2'd0;
        end else begin
            regEN   <= {regEN[0],EN};
            if(regEOD0) begin          // End of data read
               ROMODE <= 1'b0;
            end else if(regEN==2'b10) begin // End of spill
               ROMODE <= 1'b1;
            end

            if(EN) begin
                regCNTR <= (SIG==1'b1)? COUNTER + 16'd1 : COUNTER;
            end else if (doRESET) begin
                regCNTR <= 16'd0;
            end

        end
    end

    always@ (posedge CLK) begin
        if(RST) begin
            doRESET <= 1'b1;
        end else begin
            if(regEN==2'b01 || RSTCNTR==11'd1153) begin
                doRESET <= 1'b0;
            end else if(regEOD1) begin
                doRESET <= 1'b1;
            end
        end
    end

    /// Loop for the reset counter to clear the RAM
    always@ (posedge CLK) begin
        if(RST) begin
            RSTCNTR <= 11'd0;
        end else begin
            if (doRESET) begin
                RSTCNTR <= RSTCNTR + 11'd1;
            end else begin
                RSTCNTR <= 11'd0;
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
        dlyCNTR2CLK <= dlyCNTR1CLK;
    end
    always@ (posedge CLK) begin
        dlyCNTR3CLK <= (doRESET==1'b1)? RSTCNTR : dlyCNTR2CLK;
    end

    //// The depth is again modified from 12 bits to "1152"
    ////  and one has to switch "read mode" RAM and "write mode" RAM
    ////  in the timing direction.. (name of the ip core is slightly confusing)
    bram_2byte_2K bram1152_0(
        // write memory
        .addra(dlyCNTR3CLK  ),
        .clka (CLK          ),
        .dina (wCNTR[15:0]  ),
        .ena  ((EN|doRESET) ),
        .wea  (1'b1         ),
        // read memory
        .addrb(raddr[10: 0] ),
        .clkb (CLK          ),
        .doutb(COUNTER[15:0]),
        .enb  (1'b1         ) 
    );

endmodule
