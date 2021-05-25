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
        output  reg     [15:0]      cnt4,
        input   wire                enTC0, 
        input   wire                enTC1, 
        input   wire                enBH0, 
        input   wire                enBH1,
        input   wire                enOHAOR 
);

    //// Stretch the signal width of each PMT counter
    //// so technically the size of a coincidence window
    //// is to become 3 CLK cycles
    reg [WIDTH-1:0] regTC0;
    reg [WIDTH-1:0] regTC1;
    reg [WIDTH-1:0] regBH0;
    reg [WIDTH-1:0] regBH1;
    reg [WIDTH-1:0] regOHAOR; /// all or of old hodoscope
    reg [1:0]       regTmpTC0;
    reg [1:0]       regTmpTC1;
    reg [1:0]       regTmpBH0;
    reg [1:0]       regTmpBH1;
    reg [1:0]       regTmpOhaor;

    always @(posedge CLK) begin
        if(RST) begin
            regTmpTC0[1:0]     <= 2'd0;  
            regTmpTC1[1:0]     <= 2'd0;  
            regTmpBH0[1:0]     <= 2'd0;  
            regTmpBH1[1:0]     <= 2'd0;  
            regTmpOhaor[1:0]   <= 2'd0;
            regTC0[WIDTH-1:0]  <= 0;
            regTC1[WIDTH-1:0]  <= 0;
            regBH0[WIDTH-1:0]  <= 0;
            regBH1[WIDTH-1:0]  <= 0;
            regOHAOR[WIDTH-1:0]<= 0;
        end else begin
            regTmpTC0[0]       <= enTC0 ? TC0 : 1'b1;  
            regTmpTC1[0]       <= enTC1 ? TC1 : 1'b1;  
            regTmpBH0[0]       <= enBH0 ? BH0 : 1'b1;  
            regTmpBH1[0]       <= enBH1 ? BH1 : 1'b1;  
            regTmpOhaor[0]     <= enOHAOR ? OHAOR : 1'b1;
            regTmpTC0[1]       <= regTmpTC0[0];  
            regTmpTC1[1]       <= regTmpTC1[0];  
            regTmpBH0[1]       <= regTmpBH0[0];  
            regTmpBH1[1]       <= regTmpBH1[0];  
            regTmpOhaor[1]     <= regTmpOhaor[0];
            regTC0[WIDTH-1:0]  <= {regTC0[WIDTH-2:0],regTmpTC0[1]};
            regTC1[WIDTH-1:0]  <= {regTC1[WIDTH-2:0],regTmpTC1[1]};
            regBH0[WIDTH-1:0]  <= {regBH0[WIDTH-2:0],regTmpBH0[1]};
            regBH1[WIDTH-1:0]  <= {regBH1[WIDTH-2:0],regTmpBH1[1]};
            regOHAOR[WIDTH-1:0]<= {regOHAOR[WIDTH-2:0],regTmpOhaor[1]};
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

    reg   [127:0]   regTmpMppc;
    reg   [3:0]     regTmpEpmt;
    reg   [15:0]    regTmpOldhod;
    
    always @(posedge CLK) begin
        if(RST) begin
            SIGOUT <= 74'd0;
            regTmpMppc[127:0] <= 128'd0;
            regTmpEpmt[3:0]   <= 4'd0;
            regTmpOldhod[15:0]<= 16'd0;
        end else begin
            regTmpMppc[127:0] <= {regTmpMppc[63:0], MPPC[63:0]};
            regTmpEpmt[3:0]   <= {regTmpEpmt[1:0], EPMT[1:0]};
            regTmpOldhod[15:0]<= {regTmpOldhod[7:0], OLDHOD[7:0]};

            if(COINC) begin
                SIGOUT <= {regTmpOldhod[15:8],regTmpEpmt[3:2],regTmpMppc[127:64]};
            end else begin
                SIGOUT <= 74'd0;
            end
        end
    end
endmodule
