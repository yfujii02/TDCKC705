module CHECK_COINCIDENCE_MODULE
    #(parameter WIDTH=4) (
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
        output  reg     [73:0]      SIGOUT /// 64+2(Ext)+8(OldHodo)
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
