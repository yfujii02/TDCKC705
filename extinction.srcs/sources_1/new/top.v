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
        // Reset switch
        input    wire            SW_N           ,
        // Reset SMA
        input    wire            GPIO_SMA0_IN   ,
        output   wire            GPIO_SMA1_OUT  ,
        // Test inputs
        input    wire    [3:0]   GPIO_SWITCH    ,
        // Test outputs
        output   wire    [3:0]   GPIO_LED       , /// GPIO_LED_[4,5,6,7]
        // Connect EEPROM
        inout    wire            I2C_SDA   ,
        output   wire            I2C_SCL   ,
        // Input signals...
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

    wire    EXIN_SPLCNT_RST;
    wire    EXOUT_SPLCNT_RST;
    assign  EXIN_SPLCNT_RST = ~GPIO_SMA0_IN;
    assign  GPIO_SMA1_OUT   = EXOUT_SPLCNT_RST;

//-----------------------------------------------------------
//  Pre-processing for counter signals, SPILL, and MR sync
//-----------------------------------------------------------
    wire    [19:0]    HA_HPC        ; // for additional information
    wire    [31:0]    LA_HPC        ; // for main counters
    wire    [31:0]    LA_LPC        ; // for main counters
    wire    [63:0]    SIGNAL        ;
    wire              PSPILL        ; // P0 for resetting counter
    wire              PSPILL_FMC    ; // P0 for resetting counter from FMC
    wire              MR_SYNC_FMC   ; // MR sync
    wire              MR_SYNC       ; // MR sync
    wire              EV_MATCH      ; // Event matching signal spill-by-spill
    wire    [11:0]    OLDH          ; // PMT and old hodoscope

    wire              TEST_PSPILL_EN; // Tset spill enable
    wire              TEST_MRSYNC_EN; // Tset MR sync enable
    wire              TEST_PSPILL   ; // Test spill signal
    wire              TEST_MRSYNC   ; // Test MR sync signal
    wire    [63:0]    CHMASK        ; // mask channel if corresponding bit is high
    wire    [14:0]    CHMASK2       ; // mask for non-main counter channels
     
    /// Differential to signle
    genvar i;
    generate
    for (i = 0; i < 32; i = i+1) begin: LVDS_BUF_LA
        IBUFDS #(.IOSTANDARD("LVDS_25"),.DIFF_TERM("TRUE"))
            LVDS_BUF0(.O(LA_HPC[i]),.I(LA_HPC_P[i]),.IB(LA_HPC_N[i]));
        IBUFDS #(.IOSTANDARD("LVDS_25"),.DIFF_TERM("TRUE"))
            LVDS_BUF1(.O(LA_LPC[i]),.I(LA_LPC_P[i]),.IB(LA_LPC_N[i]));
    end
    endgenerate
    generate
    for (i = 0; i < 20; i = i+1) begin: LVDS_BUF_HA
        IBUFDS #(.IOSTANDARD("LVDS_25"),.DIFF_TERM("TRUE"))
            LVDS_BUF2(.O(HA_HPC[i]),.I(HA_HPC_P[i]),.IB(HA_HPC_N[i]));
    end
    endgenerate
    generate

    /// mask signals by using the register
    assign    SIGNAL = ~CHMASK & {LA_HPC,LA_LPC};
//    assign    {OLDH,EV_MATCH,MR_SYNC_FMC,PSPILL_FMC} = (GPIO_SWITCH[3:1]==3'b111)?
//                     {13'd0,SW_DEBUG[1:0]} : ~CHMASK2 & {HA_HPC[16:10], HA_HPC[7:3], HA_HPC[2:0]};
    assign    {OLDH,EV_MATCH,MR_SYNC_FMC,PSPILL_FMC} = ~CHMASK2 & {HA_HPC[16:10], HA_HPC[7:3], HA_HPC[2:0]};
    
    assign PSPILL  = TEST_PSPILL_EN ? TEST_PSPILL : PSPILL_FMC;  // Use SMA0 for SPILL signal
    assign MR_SYNC = TEST_MRSYNC_EN ? TEST_MRSYNC : MR_SYNC_FMC; // Use SMA1 for MR sync dummy

    wire             CLK_200M     ;
    wire             TCP_OPEN_ACK ;
    wire             FIFO_FULL    ;
    wire             TCP_RST      ;

    wire    [2:0]    RUN_MODE     ;
    wire             RUN_START    ;
    wire             RUN_RESET    ;

    reg    [63:0]    regSIG       ;
    reg   [127:0]    sigEdge      ;

    reg    [11:0]    regOLDH      ; // from old hodoscope and other PMTs
    reg    [23:0]    oldhEdge     ; // detect the edge timing

    reg     [1:0]    syncEdge     ;
    reg              regSync      ;

    /// Signal-edge detection
    // loop for the MPPC signals
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
    endgenerate
    // loop for the PMT signals
    generate
    for (i = 0; i < 12; i = i+1) begin: OLDH_EDGE
        always@ (posedge CLK_200M) begin
            if(TCP_RST)begin
                regOLDH[i]          <= 1'd0;
                oldhEdge[2*i+1:2*i] <= 2'd0;
            end else begin
                oldhEdge[2*i+1:2*i] <= {oldhEdge[2*i],OLDH[i]};
                regOLDH[i]          <= (oldhEdge[2*i+1:2*i]==2'b01);
            end
        end
    end
    endgenerate
    generate
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


//-----------------------------------------------------------
//  SiTCP
//-----------------------------------------------------------
    wire   [31:0]   RBCP_ADDR;
    wire    [7:0]   RBCP_WD  ;
    wire            RBCP_WE  ;
    wire            RBCP_RE  ;
    wire            RBCP_ACK ;
    wire    [7:0]   RBCP_RD  ;
    wire    [7:0]   OUTDATA  ;
    wire            TCP_TX_EN;

    kc705sitcp(
        .SYSCLK_200MP_IN(SYSCLK_200MP_IN), // in : From 200MHz Oscillator module
        .SYSCLK_200MN_IN(SYSCLK_200MN_IN), // in : From 200MHz Oscillator module
        .CLK_200M       (CLK_200M       ), // out: Clock (200MHz)
        .TCP_RST        (TCP_RST        ), // out: TCP reset
        // EtherNet        
        .GMII_RSTn      (GMII_RSTn      ), // out:
        .GMII_TX_EN     (GMII_TX_EN     ), // out:
        .GMII_TXD       (GMII_TXD       ), // out:
        .GMII_TX_ER     (GMII_TX_ER     ), // out:
        .GMII_TX_CLK    (GMII_TX_CLK    ), // in :
        .GMII_GTXCLK    (GMII_GTXCLK    ), // out:
        .GMII_RX_CLK    (GMII_RX_CLK    ), // in :
        .GMII_RX_DV     (GMII_RX_DV     ), // in :
        .GMII_RXD       (GMII_RXD       ), // in :
        .GMII_RX_ER     (GMII_RX_ER     ), // in :
        .GMII_CRS       (GMII_CRS       ), // in :
        .GMII_COL       (GMII_COL       ), // in :
        .GMII_MDIO      (GMII_MDIO      ), // in :
        .GMII_MDC       (GMII_MDC       ), // out:
        // SiTCP status
        .TCP_OPEN_ACK   (TCP_OPEN_ACK   ), // out: TCP Open acknowlegde (0: close, 1: open)
        .FIFO_FULL      (FIFO_FULL      ), // out: Almost fill in FIFO for SiTCP
        // Input data to be sent
        .TCP_TX_DATA_IN (OUTDATA[7:0]   ), // in : TCP/IP output data
        .TCP_TX_EN_IN   (TCP_TX_EN      ), // in : TCP/IP output data enable
        // Reset switch           switch
        .SW_N           (SW_N           ), // in :
        .SOFT_RESET     (RUN_RESET      ), // in : Software reset signal
        .GPIO_SWITCH_0  (GPIO_SWITCH[0] ), // in :
        // Connect EEPROM
        .I2C_SDA        (I2C_SDA        ), // in :
        .I2C_SCL        (I2C_SCL        ), // in :
        // RBCP
        .RBCP_ADDR      (RBCP_ADDR[31:0]), // out:
        .RBCP_WD        (RBCP_WD[7:0]   ), // out:
        .RBCP_WE        (RBCP_WE        ), // out:
        .RBCP_RE        (RBCP_RE        ), // out:
        .RBCP_ACK       (RBCP_ACK       ), // in :
        .RBCP_RD        (RBCP_RD[7:0]   )  // in :
    );


//-----------------------------------------------------------
//  TDC module
//-----------------------------------------------------------
    wire           INT_SPLCNT_RST ;
    wire           SPLCNT_RST     ;
    wire    [7:0]  INT_SPLCNT_RSTT;
    wire   [31:0]  HEADER         ; 
    wire   [31:0]  FOOTER         ;
    wire           TRIGGER_INT    ;
    wire    [3:0]  BOARD_ID       ;
    wire   [31:0]  SPILLCOUNT     ;
    wire           debug_data_en ;
    wire           debug_data_end;
    wire    [7:0]  debug_dly_en;
    wire           debug_rd_en; 
    wire    [7:0]  debug_cnt;   
    wire   [15:0]  debug_fifo_cnt;
    wire    [7:0]  debug_sploffcnt;
    wire    [2:0]  debug_dlysplcnt;
    assign SPLCNT_RST = EXOUT_SPLCNT_RST | EXIN_SPLCNT_RST;
    assign BOARD_ID = {1'b0,GPIO_SWITCH[3:1]};

    top_tdc top_tdc(
        // System
        .RESET          ((~TCP_OPEN_ACK|RUN_RESET)), // in : System Reset
        .CLK_200M       (CLK_200M                 ), // in : Clock
        .SPLCNT_RST     (SPLCNT_RST               ), // in : Spill count reset
        .INT_SPLCNT_RST (INT_SPLCNT_RST           ), // in : (In) Spl cnt reset
        .INT_SPLCNT_RSTT(INT_SPLCNT_RSTT[7:0]     ), // in : (In) Spl cnt reset timing from spill end
        .EX_SPLCNT_RST  (EXOUT_SPLCNT_RST         ), // out: (Ex) Spl cnt reset
        // Counter data
        .SIGNAL         (regSIG[63:0]             ), // in : New hodoscope signals
        .PSPILL         (PSPILL                   ), // in : SPILL signal
        .MR_SYNC        (regSync                  ), // in : MR sync signal
        .OLDH           (regOLDH[11:0]            ), // in : Old hodoscope signals
        .EV_MATCH       (EV_MATCH                 ), // in : Event-mathcing signal
        .TCP_BUSY       (FIFO_FULL                ), // in : Busy flag for DAQ to pend the data sending
        .START          (RUN_START                ), // in : Start signal to send the data
        .BOARD_ID       (BOARD_ID[3:0]            ), // in : Board ID
        .HEADER         (HEADER[31:0]             ), // in : Header data
        .FOOTER         (FOOTER[31:0]             ), // in : Footer data
        .TRIGGER_INT    (TRIGGER_INT              ), // out:
        .SPILLCOUNT     (SPILLCOUNT[31:0]         ), // out: Spill count
        // TCP/IP output data
        .OUTDATA        (OUTDATA[7:0]             ), // out: Output data into SiTCP
        .SEND_EN        (TCP_TX_EN                ), // out: Output data enable SiTCP
        // Debug pins
        .DEBUG_DATA_EN  (debug_data_en  ), // out:
        .DEBUG_DATA_END (debug_data_end ), // out:
        .DEBUG_DLY_EN   (debug_dly_en   ), // out:
        .DEBUG_RD_EN    (debug_rd_en    ), // out:
        .DEBUG_CNT      (debug_cnt      ), // out:
        .DEBUG_FIFO_CNT (debug_fifo_cnt ), // out:
        .DEBUG_SPLOFFCNT(debug_sploffcnt), // out:
        .DEBUG_DLYSPLCNT(debug_dlysplcnt)  // out:
    );


//-----------------------------------------------------------
//  UDP Slow Controler
//-----------------------------------------------------------
    wire              FMC_DBG;
    wire    [31:0]    TEST_PSPILL_POS;
    wire    [31:0]    TEST_PSPILL_NEG;
    wire    [31:0]    TEST_MRSYNC_FRQ;
    LOC_REG LOC_REG(
        // System
        .CLK                (CLK_200M             ), // in : Clock
        .RST                (TCP_RST              ), // in : System reset
        // Control
        .LOC_ADDR           (RBCP_ADDR[31:0]      ), // in : Address
        .LOC_WD             (RBCP_WD[7:0]         ), // in : Data
        .LOC_WE             (RBCP_WE              ), // in : Write enable
        .LOC_RE             (RBCP_RE              ), // in : Read enable
        .LOC_ACK            (RBCP_ACK             ), // out: Access acknowledge
        .LOC_RD             (RBCP_RD[7:0]         ), // out: Read data
        // Registers        
        .BOARD_ID           (BOARD_ID[3:0]        ), // in : Board ID
        .SPILLCOUNT         (SPILLCOUNT[31:0]     ), // in : Spill count
        .REG_MODE           (RUN_MODE[2:0]        ), // out: Mode select (000: TDC, 001: MCS, 111: Test)
        .REG_START          (RUN_START            ), // out: Start data transferring (0: stop, 1: start)
        .REG_RESET          (RUN_RESET            ), // out: Reset
        .REG_HEADER         (HEADER[31:0]         ), // out: Header
        .REG_FOOTER         (FOOTER[31:0]         ), // out: Footer
        .REG_CHMASK         (CHMASK[63:0]         ), // out: Mask channel selector
        .REG_CHMASK2        (CHMASK2[14:0]        ), // out: Mask channel selector
        .REG_FMC_DBG        (FMC_DBG              ), // out: Enable FMC debug pin (HPC_LA33,32)
        .REG_SPLCNT_RST     (INT_SPLCNT_RST       ), // out: Spill count reset
        .REG_SPLCNT_RSTT    (INT_SPLCNT_RSTT[7:0] ), // out: Spill count reset timing from spill end (def: 1us)
        .REG_TEST_PSPILL_EN (TEST_PSPILL_EN       ), // out: Test spill enable 
        .REG_TEST_MRSYNC_EN (TEST_MRSYNC_EN       ), // out: Test MR sync enable
        .REG_TEST_PSPILL_POS(TEST_PSPILL_POS[31:0]), // out: Time width of test spill (Pos.)
        .REG_TEST_PSPILL_NEG(TEST_PSPILL_NEG[31:0]), // out: Time width of test spill (Neg.)
        .REG_TEST_MRSYNC_FRQ(TEST_MRSYNC_FRQ[31:0])  // out: Test MR sync frequency
    );


//-----------------------------------------------------------
//  Debug
//-----------------------------------------------------------
    wire  CLK_100M;
    wire  CLK_10M;
    wire  PLL_CLKFB;
    wire  LOCKED;
    PLLE2_BASE #(
        .CLKFBOUT_MULT     (5),
        .CLKIN1_PERIOD     (5.000),
        .CLKOUT0_DIVIDE    (10),
        .CLKOUT0_DUTY_CYCLE(0.500),
        .CLKOUT1_DIVIDE    (100),
        .CLKOUT1_DUTY_CYCLE(0.500),
        .DIVCLK_DIVIDE     (1)
    ) 
    PLLE2_DEBUG(
        .CLKFBOUT          (PLL_CLKFB),
        .CLKOUT0           (CLK_100M),
        .CLKOUT1           (CLK_10M),
        .CLKOUT2           (),
        .CLKOUT3           (),
        .CLKOUT4           (),
        .CLKOUT5           (),
        .LOCKED            (LOCKED),
        .CLKFBIN           (PLL_CLKFB),
        .CLKIN1            (CLK_200M),
        .PWRDWN            (1'b0),
        .RST               (1'b0)
    );

    /// Generate a pseudo spill signal
    reg             irTestSpill;
    reg   [31:0]    irSpillTime;
    always@(posedge CLK_10M) begin
        if(TCP_RST) begin
            irSpillTime[31:0] <= 32'd1;
        end else if(irSpillTime[31:0]==(TEST_PSPILL_POS[30:0]+TEST_PSPILL_NEG[30:0]))begin
            irSpillTime[31:0] <= 32'd1;
        end else begin
            irSpillTime[31:0] <= irSpillTime[31:0] + 32'd1;
        end

        if(TCP_RST) begin
            irTestSpill <= 1'b0;
        end else if(irSpillTime[31:0]==TEST_PSPILL_POS[30:0]) begin
            irTestSpill <= 1'b1;
        end else if(irSpillTime[31:0]==(TEST_PSPILL_POS[30:0]+TEST_PSPILL_NEG[30:0])) begin
            irTestSpill <= 1'b0;
        end else begin
            irTestSpill <= irTestSpill;
        end
    end
    assign TEST_PSPILL = irTestSpill;

    /// Generate a pseudo MR sync signal
    reg             irTestMrsync;
    reg   [31:0]    irMrsyncTime;
    reg    [1:0]    irMrsyncPulse;
    always@(posedge CLK_10M) begin
        if(TCP_RST) begin
            irMrsyncTime[31:0] <= 32'd1;
        end else if(irMrsyncTime[31:0]==TEST_MRSYNC_FRQ[31:0]) begin
            irMrsyncTime[31:0] <= 32'd1;
        end else begin
            irMrsyncTime[31:0] <= irMrsyncTime[31:0] + 32'd1;
        end

        if(irMrsyncTime[31:0]==TEST_MRSYNC_FRQ[31:0]) begin
            irTestMrsync <= 1'b1;
        end else begin
            irTestMrsync <= 1'b0;
        end
    end
    always@(posedge CLK_200M) begin
        if(TCP_RST) begin
            irMrsyncPulse[1:0] <= 2'd0;
        end else begin
            irMrsyncPulse[1:0] <= {irMrsyncPulse[0], irTestMrsync};
        end
    end
    assign TEST_MRSYNC = (irMrsyncPulse[1:0]==2'b01) & TEST_PSPILL ? 1'b1 : 1'b0;

    
    //assign GPIO_LED = SPILLCOUNT[3:0];
    assign GPIO_LED = SPILLCOUNT[31:28];

    reg [4:0] debug_pause;
    always@(posedge CLK_200M) begin
        if(TCP_RST)begin 
          debug_pause[4:0] <= 5'd0;
        end else begin
          debug_pause[4:0] <= {debug_pause[3:0],FIFO_FULL};
        end
    end

    ila_0 ila_0(
        //.trig_in(PSPILL   ),
        .clk    (CLK_200M ),
        // 8 bits per each
        .probe0 (OUTDATA  ),
        .probe1 (debug_fifo_cnt[15:8]   ),
        .probe2 (debug_fifo_cnt[ 7:0]   ),
        .probe3 (debug_dly_en[7:0]      ),
        .probe4 (debug_cnt[7:0]         ),
        .probe5 ({TEST_PSPILL,TEST_MRSYNC,1'b0,debug_pause[4:0]}),
        .probe6 (debug_sploffcnt        ),
        .probe7 ({irMrsyncTime[2:0],EXIN_SPLCNT_RST,EXOUT_SPLCNT_RST,debug_dlysplcnt} ),
        // Single bit per each
        .probe8 (RUN_START              ),
        .probe9 (TCP_TX_EN              ),
        .probe10(FIFO_FULL              ),
        .probe11(PSPILL                 ),
        .probe12(MR_SYNC                ),
        .probe13(TRIGGER_INT            ),
        .probe14(debug_data_en          ),
        .probe15(debug_data_end         ),
        .probe16(debug_rd_en            )
    );

endmodule
