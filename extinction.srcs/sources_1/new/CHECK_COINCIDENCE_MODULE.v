module CHECK_COINCIDENCE_MODULE
    #(parameter WIDTH=3) (
        input   wire                CLK,
        input   wire                RST,
        input   wire    [63:0]      MPPC,  // MPPC
        input   wire     [1:0]      EPMT,  // extra pmt
        input   wire     [7:0]      OLDHOD,
        input   wire                TC1,
        input   wire                TC2,
        input   wire                BC1,
        input   wire                BC2,
        input   wire                OHAOR,
        output  wire                COINC,
        output  reg     [73:0]      SIGOUT /// 64+2(Ext)+8(OldHodo)
);

    //// Stretch the signal width of each PMT counter
    //// so technically the size of a coincidence window
    //// is to become 3 CLK cycles
    reg [WIDTH-1:0] regTC1;
    reg [WIDTH-1:0] regTC2;
    reg [WIDTH-1:0] regBC1;
    reg [WIDTH-1:0] regBC2;
    reg [WIDTH-1:0] regOHAOR; /// all or of old hodoscope

    always @(posedge CLK) begin
        if(RST) begin
            regTC1[WIDTH-1:0]  <= 0;
            regTC2[WIDTH-1:0]  <= 0;
            regBC1[WIDTH-1:0]  <= 0;
            regBC2[WIDTH-1:0]  <= 0;
            regOHAOR[WIDTH-1:0]<= 0;
        end else begin
            regTC1[WIDTH-1:0]  <= {regTC1[WIDTH-2:0],TC1};
            regTC2[WIDTH-1:0]  <= {regTC2[WIDTH-2:0],TC2};
            regBC1[WIDTH-1:0]  <= {regBC1[WIDTH-2:0],BC1};
            regBC2[WIDTH-1:0]  <= {regBC2[WIDTH-2:0],BC2};
            regOHAOR[WIDTH-1:0]<= {regOHAOR[WIDTH-2:0],OHAOR};
        end
    end

    wire    TC1_ON  ;
    wire    TC2_ON  ;
    wire    BC1_ON  ;
    wire    BC2_ON  ;
    wire    OHAOR_ON;

    assign TC1_ON = |regTC1;
    assign TC2_ON = |regTC2;
    assign BC1_ON = |regBC1;
    assign BC2_ON = |regBC2;
    assign OHAOR_ON = |regOHAOR;
    assign COINC = TC1_ON & TC2_ON & BC1_ON & BC2_ON & OHAOR_ON;

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
