module CHECK_COINCIDENCE_MODULE
    #(parameter WIDTH=6) (
        input   wire                CLK,
        input   wire                RST,
        input   wire    [63:0]      MPPC,  // MPPC
        input   wire     [1:0]      EPMT,  // extra pmt
        input   wire     [7:0]      OLDHOD,
        input   wire                TC0,
        input   wire                TC1,
        input   wire                BH0,
        input   wire                BH1,
        input   wire                OHAOR,
        output  wire                COINC,
        output  reg     [73:0]      SIGOUT, /// 64+2(Ext)+8(OldHodo)
        output  reg     [15:0]      cnt1,
        output  reg     [15:0]      cnt2,
        output  reg     [15:0]      cnt3,
        output  reg     [15:0]      cnt4 
);

    //// Stretch the signal width of each PMT counter
    //// so technically the size of a coincidence window
    //// is to become 3 CLK cycles
    reg [WIDTH-1:0] regTC0;
    reg [WIDTH-1:0] regTC1;
    reg [WIDTH-1:0] regBH0;
    reg [WIDTH-1:0] regBH1;
    reg [WIDTH-1:0] regOHAOR; /// all or of old hodoscope

    always @(posedge CLK) begin
        if(RST) begin
            regTC0[WIDTH-1:0]  <= 0;
            regTC1[WIDTH-1:0]  <= 0;
            regBH0[WIDTH-1:0]  <= 0;
            regBH1[WIDTH-1:0]  <= 0;
            regOHAOR[WIDTH-1:0]<= 0;
        end else begin
            regTC0[WIDTH-1:0]  <= {regTC0[WIDTH-2:0],TC0};
            regTC1[WIDTH-1:0]  <= {regTC1[WIDTH-2:0],TC1};
            regBH0[WIDTH-1:0]  <= {regBH0[WIDTH-2:0],BH0};
            regBH1[WIDTH-1:0]  <= {regBH1[WIDTH-2:0],BH1};
            regOHAOR[WIDTH-1:0]<= {regOHAOR[WIDTH-2:0],OHAOR};
        end
    end

    wire    TC0_ON  ;
    wire    TC1_ON  ;
    wire    BH0_ON  ;
    wire    BH1_ON  ;
    wire    OHAOR_ON;

    assign TC0_ON = |regTC0;
    assign TC1_ON = |regTC1;
    assign BH0_ON = |regBH0;
    assign BH1_ON = |regBH1;
    assign OHAOR_ON = |regOHAOR;
    assign COINC = TC0_ON & TC1_ON & BH0_ON & BH1_ON & OHAOR_ON;

    reg    [4:0] coinLen;
    reg   [15:0] regCnt1;
    reg   [15:0] regCnt2;
    reg   [15:0] regCnt3;
    reg   [15:0] regCnt4;
    always @(posedge CLK) begin
        if(RST) begin
            coinLen[4:0] <= 5'd0;
        end else begin
            coinLen[4:0] <= {coinLen[3:0], COINC};
        end

        if(RST) begin
            cnt1[15:0] <= 16'd0;
            cnt2[15:0] <= 16'd0;
            cnt3[15:0] <= 16'd0;
            cnt4[15:0] <= 16'd0;
            regCnt1[15:0] <= 16'd0;
            regCnt2[15:0] <= 16'd0;
            regCnt3[15:0] <= 16'd0;
            regCnt4[15:0] <= 16'd0;
        end else begin
            case(coinLen[4:0])
                5'b11110: regCnt4 <= regCnt4+1;
                5'b01110: regCnt3 <= regCnt3+1;
                5'b00110: regCnt2 <= regCnt2+1;
                5'b00010: regCnt1 <= regCnt1+1;
            endcase

            cnt1 <= regCnt1;
            cnt2 <= regCnt2;
            cnt3 <= regCnt3;
            cnt4 <= regCnt4;
        end
    end
    
    always @(posedge CLK) begin
        if(RST) begin
            SIGOUT <= 74'd0;
        end else begin
            if(COINC) begin
                SIGOUT <= {OLDHOD,EPMT,MPPC};
            end else begin
                SIGOUT <= 74'd0;
            end
        end
    end
endmodule
