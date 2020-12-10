`timescale 1ns / 1ps
//-------------------------------------------------------------------//
//
//    System      : KC705
//
//    Module      : KC705 Evaluation Board
//
//    Description : Top Module of KC705 Evaluation Board
//
//    file    : KC705 Evaluation Board
//
//    Note    :
//
//
//-------------------------------------------------------------------//

module
    top(
    // System
        input    wire            SYSCLK_200MP_IN,    // From 200MHz Oscillator module
        input    wire            SYSCLK_200MN_IN,    // From 200MHz Oscillator module
    // EtherNet
        output   wire            GMII_RSTn      ,
        output   wire            GMII_TX_EN     ,
        output   wire    [7:0]   GMII_TXD       ,
        output   wire            GMII_TX_ER     ,
        input    wire            GMII_TX_CLK    ,
        output   wire            GMII_GTXCLK    ,

        input    wire            GMII_RX_CLK    ,
        input    wire            GMII_RX_DV     ,
        input    wire    [7:0]   GMII_RXD       ,
        input    wire            GMII_RX_ER     ,
        input    wire            GMII_CRS       ,
        input    wire            GMII_COL       ,

        inout    wire            GMII_MDIO      ,
        output   wire            GMII_MDC       ,
    // reset switch
        input    wire            SW_N           ,
    // test inputs
        input    wire    [3:0]   GPIO_SWITCH    ,
        input    wire    [1:0]   GPIO_SMA       ,
    // test outputs
        output   wire    [3:0]   GPIO_LED       , /// GPIO_LED_[4,5,6,7]
    //connect EEPROM
        inout    wire            I2C_SDA   ,
        output   wire            I2C_SCL   ,
    // input signals...
        input    wire   [31:0]   LA_HPC_P  , // Connector J1 : 0-19
                                             //           J20:20-27
                                             //           J16:28-31 on XM105
        input    wire   [31:0]   LA_HPC_N  , // Connector J1 : 0-19
                                             //           J20:20-27
                                             //           J16:28-31 on XM105
        input    wire   [19:0]   HA_HPC_P  , // Connector J3     on XM105
        input    wire   [19:0]   HA_HPC_N  , // Connector J3     on XM105
        input    wire   [31:0]   LA_LPC_P  , // Connector J1 : 0-19
                                             //           J20:20-27
                                             //           J16:28-31 on XM105
        input    wire   [31:0]   LA_LPC_N  , // Connector J1 : 0-19
                                             //           J20:20-27
                                             //           J16:28-31 on XM105
        input    wire    [1:0]   SW_DEBUG    // Debug signals from SW13
    );

    wire    [19:0]    HA_HPC   ; // for additional information
    wire    [31:0]    LA_HPC   ; // for main counters
    wire    [31:0]    LA_LPC   ; // for main counters
    wire    [63:0]    SIGNAL   ;
    wire              PSPILL   ; // P0 for resetting counter
    wire              MR_SYNC  ; // MR sync
    wire              EV_MATCH ; // Event matching signal spill-by-spill
    wire              COINC    ; // coincidence signal from other pion counters

    wire    [63:0]    CHMASK   ; // mask channel if corresponding bit is high
    assign    SIGNAL = ~CHMASK & {LA_HPC,LA_LPC};
    //assign    {EV_MATCH,COINC,MR_SYNC,PSPILL} = (GPIO_SWITCH[3:1]==3'b111)? {2'b00,GPIO_SMA[1:0]} : HA_HPC[3:0];
    assign    {EV_MATCH,COINC,MR_SYNC,PSPILL} = (GPIO_SWITCH[3:1]==3'b111)? {2'b00,SW_DEBUG[1:0]} : HA_HPC[3:0];

genvar i;
generate
for (i = 0; i < 32; i = i+1) begin: LVDS_BUF_LA
    IBUFDS #(.IOSTANDARD("LVDS_25")) LVDS_BUF0(.O(LA_HPC[i]),.I(LA_HPC_P[i]),.IB(LA_HPC_N[i]));
    IBUFDS #(.IOSTANDARD("LVDS_25")) LVDS_BUF1(.O(LA_LPC[i]),.I(LA_LPC_P[i]),.IB(LA_LPC_N[i]));
end
endgenerate
generate
for (i = 0; i < 20; i = i+1) begin: LVDS_BUF_HA
    IBUFDS #(.IOSTANDARD("LVDS_25")) LVDS_BUF2(.O(HA_HPC[i]),.I(HA_HPC_P[i]),.IB(HA_HPC_N[i]));
end
endgenerate
generate

    wire             CLK_200M  ;
    wire             FIFO_FULL ;
    wire             TCP_RST   ;

    wire    [2:0]    RUN_MODE  ;
    wire             RUN_START ;
    wire             RUN_RESET ;

    reg    [63:0]    regSIG    ;
    reg   [127:0]    sigEdge   ;
    reg     [1:0]    syncEdge  ;
    reg              regSync   ;

for (i = 0; i < 64; i = i+1) begin: SIG_EDGE
    always@ (posedge CLK_200M) begin
        if(TCP_RST)begin
            regSIG[i]          <= 1'd0;
            sigEdge[2*i+1:2*i] <= 2'd0;
        end else begin
            sigEdge[2*i+1:2*i] <= {sigEdge[2*i],SIGNAL[i]};
            regSIG[i]          <= (sigEdge[2*i+1:2*i]==2'b01);
        end
    end
end
    always@ (posedge CLK_200M) begin
        if(TCP_RST)begin
            regSync       <= 1'd0;
            syncEdge[1:0] <= 2'd0;
        end else begin
            regSync       <= (syncEdge[1:0]==2'b01);
            syncEdge[1:0] <= {syncEdge[0],MR_SYNC};
        end
    end
endgenerate
    wire   [31:0]   RBCP_ADDR;
    wire    [7:0]   RBCP_WD  ;
    wire            RBCP_WE  ;
    wire            RBCP_RE  ;
    wire            RBCP_ACK ;
    wire    [7:0]   RBCP_RD  ;
    wire    [7:0]   OUTDATA  ;
    wire            TCP_TX_EN;

    kc705sitcp(
        .SYSCLK_200MP_IN(SYSCLK_200MP_IN), // From 200MHz Oscillator module
        .SYSCLK_200MN_IN(SYSCLK_200MN_IN), // From 200MHz Oscillator module
        .CLK_200M       (CLK_200M       ),
        .TCP_RST        (TCP_RST        ),
    // EtherNet              Net
        .GMII_RSTn      (GMII_RSTn      ),
        .GMII_TX_EN     (GMII_TX_EN     ),
        .GMII_TXD       (GMII_TXD       ),
        .GMII_TX_ER     (GMII_TX_ER     ),
        .GMII_TX_CLK    (GMII_TX_CLK    ),
        .GMII_GTXCLK    (GMII_GTXCLK    ),
        .GMII_RX_CLK    (GMII_RX_CLK    ),
        .GMII_RX_DV     (GMII_RX_DV     ),
        .GMII_RXD       (GMII_RXD       ),
        .GMII_RX_ER     (GMII_RX_ER     ),
        .GMII_CRS       (GMII_CRS       ),
        .GMII_COL       (GMII_COL       ),
        .GMII_MDIO      (GMII_MDIO      ),
        .GMII_MDC       (GMII_MDC       ),
    // sitcp status
        .FIFO_FULL      (FIFO_FULL      ),
    // input data to be sent
        .TCP_TX_DATA_IN (OUTDATA[7:0]   ),
        .TCP_TX_EN_IN   (TCP_TX_EN      ),
    // reset switch           switch
        .SW_N           (SW_N           ),
        .SOFT_RESET     (RUN_RESET      ),
        .GPIO_SWITCH_0  (GPIO_SWITCH[0] ),
        //connect EEPROM
        .I2C_SDA        (I2C_SDA        ),
        .I2C_SCL        (I2C_SCL        ),
    // RBCP
        .RBCP_ADDR      (RBCP_ADDR[31:0]),
        .RBCP_WD        (RBCP_WD[7:0]   ),
        .RBCP_WE        (RBCP_WE        ),
        .RBCP_RE        (RBCP_RE        ),
        .RBCP_ACK       (RBCP_ACK       ),
        .RBCP_RD        (RBCP_RD[7:0]   )
    );

    //reg    [15:0]  COUNTER10M; // 10MHz counter
    wire   [31:0]  HEADER     ;
    wire   [31:0]  FOOTER     ;
    wire           TRIGGER_INT;
    wire    [3:0]  BOARD_ID   ;
    wire   [15:0]  SPILLCOUNT ;
    wire           debug_data_en ;
    wire           debug_data_end;
    wire  [15:0]   debug_fifo_cnt;
    assign BOARD_ID = {1'b0,GPIO_SWITCH[3:1]};

    top_tdc top_tdc(
    // system
        .RESET      ((TCP_RST|RUN_RESET)),
        .CLK_200M   (CLK_200M     ),
    //
        .SIGNAL     (regSIG       ),
        .PSPILL     (PSPILL       ),
        .MR_SYNC    (regSync      ),
        .COINC      (COINC        ),
        .EV_MATCH   (EV_MATCH     ),
        .TCP_BUSY   (FIFO_FULL    ), // Busy flag for DAQ to pend the data sending
        .START      (RUN_START    ), // Start signal to send the data
        .BOARD_ID   (BOARD_ID[3:0]),
        .HEADER     (HEADER[31:0] ),
        .FOOTER     (FOOTER[31:0] ),
        .TRIGGER_INT(TRIGGER_INT  ),
        .SPILLCOUNT (SPILLCOUNT   ),
        .OUTDATA    (OUTDATA      ), // Output data into SiTCP
        .SEND_EN    (TCP_TX_EN    ), // Output data enable SiTCP
        .DEBUG_DATA_EN (debug_data_en ),
        .DEBUG_DATA_END(debug_data_end),
        .DEBUG_FIFO_CNT(debug_fifo_cnt)
    );

    LOC_REG LOC_REG(
        // System
        .CLK        (CLK_200M        ),
        .RST        (TCP_RST         ),
        // Control
        .LOC_ADDR   (RBCP_ADDR[31:0] ),
        .LOC_WD     (RBCP_WD[7:0]    ),
        .LOC_WE     (RBCP_WE         ),
        .LOC_RE     (RBCP_RE         ),
        .LOC_ACK    (RBCP_ACK        ),
        .LOC_RD     (RBCP_RD[7:0]    ),
        // Registers
        .BOARD_ID   (BOARD_ID[3:0]   ),
        .SPILLCOUNT (SPILLCOUNT[15:0]),
        .REG_MODE   (RUN_MODE[2:0]   ),
        .REG_START  (RUN_START       ),
        .REG_RESET  (RUN_RESET       ),
        .REG_HEADER (HEADER[31:0]    ),
        .REG_FOOTER (FOOTER[31:0]    ),
        .REG_CHMASK (CHMASK[63:0]    )
    );

    assign GPIO_LED = SPILLCOUNT[3:0];

    ila_0 ila_0(
        .trig_in(PSPILL   ),
        .clk    (CLK_200M ),
// 8 bits per each
        .probe0 (OUTDATA  ),
        .probe1 (debug_fifo_cnt[15:8]),
        .probe2 (debug_fifo_cnt[ 7:0]),
        .probe3 (8'd0),
        .probe4 (8'd0),
        .probe5 (8'd0),
        .probe6 (8'd0),
        .probe7 (8'd0),
// single bit per each
        .probe8 (RUN_START),
        .probe9 (TCP_TX_EN),
        .probe10(FIFO_FULL),
        .probe11(PSPILL   ),
        .probe12(MR_SYNC  ),
        .probe13(TRIGGER_INT),
        .probe14(debug_data_en),
        .probe15(debug_data_end)
    );

endmodule
