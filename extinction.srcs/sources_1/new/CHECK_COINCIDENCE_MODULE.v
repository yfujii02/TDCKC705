module
    CHECK_COINCIDENCE_MODULE(
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
        output  wire    [71:0]      SIGOUT /// 64+2(Ext)+8(OldHodo)
);

endmodule
