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
        input    wire    [1:0]   SW_DEBUG  , // Debug signals from SW13

        // Connected wire w/ DDR3
        inout    wire   [63:0]   ddr3_dq       ,
        inout    wire    [7:0]   ddr3_dqs_n    ,
        inout    wire    [7:0]   ddr3_dqs_p    ,
        output   wire   [13:0]   ddr3_addr     ,
        output   wire    [2:0]   ddr3_ba       ,
        output   wire            ddr3_ras_n    ,
        output   wire            ddr3_cas_n    ,
        output   wire            ddr3_we_n     ,
        output   wire            ddr3_reset_n  ,
        output   wire    [0:0]   ddr3_ck_p     ,
        output   wire    [0:0]   ddr3_ck_n     ,
        output   wire    [0:0]   ddr3_cke      ,
        output   wire    [0:0]   ddr3_cs_n     ,
        output   wire    [7:0]   ddr3_dm       ,
        output   wire    [0:0]   ddr3_odt       
    );

    wire    SPLCNT_RST_EN  ;
    wire    EXIN_SPLCNT_RST;
    wire    EXOUT_SPLCNT_RST;
    assign  EXIN_SPLCNT_RST = SPLCNT_RST_EN ? GPIO_SMA0_IN : 1'b0;
    assign  GPIO_SMA1_OUT   = EXOUT_SPLCNT_RST;

    wire             CLK_200M     ;
    wire             TCP_OPEN_ACK ;
    wire             FIFO_FULL    ;
    wire             TCP_RST      ;

    wire    [2:0]    RUN_MODE     ;
    wire             RUN_START    ;
    wire             RUN_RESET    ;

//-----------------------------------------------------------
//  Pre-processing for counter signals, SPILL, and MR sync
//-----------------------------------------------------------
    wire              PSPILL        ; // P0 for resetting counter
    wire              PSPILL_FMC    ; // P0 for resetting counter from FMC
    wire              MR_SYNC_FMC   ; // MR sync
    wire              MR_SYNC       ; // MR sync
    wire              EV_MATCH      ; // Event matching signal spill-by-spill
    wire    [63:0]    SIGNAL        ;
    wire    [11:0]    OLDH          ; // PMT and old hodoscope

    wire    [63:0]    CHMASK0       ; // mask channel if corresponding bit is high
    wire    [14:0]    CHMASK1       ; // mask for non-main counter channels
    wire              TEST_PSPILL_EN; // Tset spill enable
    wire              TEST_MRSYNC_EN; // Tset MR sync enable
    wire              TEST_PSPILL   ; // Test spill signal
    wire              TEST_MRSYNC   ; // Test MR sync signal
    wire     [7:0]    DLY_PSPILL    ; // Delay for spill singal
    wire     [7:0]    DLY_MRSYNC    ; // Delay for MR sync
    wire     [7:0]    DLY_EVMATCH   ; // Delay for Event matching
    wire     [7:0]    DLY_MPPC      ; // Delay for MPPC
    wire    [95:0]    DLY_PMT       ; // Delay for PMT

    PREPROCESSOR PREPROCESSOR(
        .SYSCLK       (CLK_200M         ), // in : System clock
        .SYSRST       (TCP_RST          ), // in : System reset
        .LA_HPC_P     (LA_HPC_P[31:0]   ), // in : Connector
        .LA_HPC_N     (LA_HPC_N[31:0]   ), // in : Connector
        .LA_LPC_P     (LA_LPC_P[31:0]   ), // in : Connector
        .LA_LPC_N     (LA_LPC_N[31:0]   ), // in : Connector
        .HA_HPC_P     (HA_HPC_P[19:0]   ), // in : Connector
        .HA_HPC_N     (HA_HPC_N[19:0]   ), // in : Connector
        .DLY_PSPILL   (DLY_PSPILL[7:0]  ), // in : Delay for spill singal
        .DLY_MRSYNC   (DLY_MRSYNC[7:0]  ), // in : Delay for MR sync
        .DLY_EVMATCH  (DLY_EVMATCH[7:0] ), // in : Delay for Event matching
        .DLY_MPPC     (DLY_MPPC[7:0]    ), // in : Delay for MPPC
        .DLY_PMT      (DLY_PMT[95:0]    ), // in : Delay for PMT
        .CHMASK0      (CHMASK0[63:0]    ), // in : mask channel if corresponding bit is high
        .CHMASK1      (CHMASK1[14:0]    ), // in : mask for non-main counter channels
        .PSPILL       (PSPILL_FMC       ), // out: Spill signal (P3)
        .MR_SYNC      (MR_SYNC_FMC      ), // out: MR sync
        .EV_MATCH     (EV_MATCH         ), // out: Event-matching signal
        .SIGNAL       (SIGNAL[63:0]     ), // out: New hodoscope signal
        .OLDH         (OLDH[11:0]       )  // out: Old hodoscope signal
    );
     
    assign PSPILL  = TEST_PSPILL_EN ? TEST_PSPILL : PSPILL_FMC;  // Use SMA0 for SPILL signal
    assign MR_SYNC = TEST_MRSYNC_EN ? TEST_MRSYNC : MR_SYNC_FMC; // Use SMA1 for MR sync dummy


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
    
    wire            user_rst;

    kc705sitcp(
        //.SYSCLK_200MP_IN(SYSCLK_200MP_IN), // in : From 200MHz Oscillator module
        //.SYSCLK_200MN_IN(SYSCLK_200MN_IN), // in : From 200MHz Oscillator module
        //.CLK_200M       (CLK_200M       ), // out: Clock (200MHz)
        .CLK_200M       (CLK_200M       ), // in : Clock (200MHz)
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
        //.SW_N           (SW_N           ), // in :
        .SW_N           (user_rst       ), // in :
        .SOFT_RESET     (user_rst       ), // in : Software reset signal
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

    wire           FIFO_EMPTY     ;
    wire           FIFO_READY     ;
    wire           FIFO_RD_EN     ;
    wire  [111:0]  DATA_OUT       ;
    wire           DATA_VALID     ;

    wire           debug_data_en ;
    wire           debug_data_end;
    wire    [7:0]  debug_dly_en;
    wire           debug_rd_en; 
    wire    [7:0]  debug_cnt;
    wire    [7:0]  debug_sploffcnt;
    wire    [2:0]  debug_dlysplcnt;
    assign SPLCNT_RST = EXOUT_SPLCNT_RST | EXIN_SPLCNT_RST;
    assign BOARD_ID = {1'b0,GPIO_SWITCH[3:1]};

    top_tdc top_tdc(
        // System
        .RESET          (~TCP_OPEN_ACK            ), // in : System Reset
        .CLK_200M       (CLK_200M                 ), // in : Clock
        .SPLCNT_RST     (SPLCNT_RST               ), // in : Spill count reset
        .INT_SPLCNT_RST (INT_SPLCNT_RST           ), // in : (In) Spl cnt reset
        .INT_SPLCNT_RSTT(INT_SPLCNT_RSTT[7:0]     ), // in : (In) Spl cnt reset timing from spill end
        .EX_SPLCNT_RST  (EXOUT_SPLCNT_RST         ), // out: (Ex) Spl cnt reset
        // Counter data
        .SIGNAL         (SIGNAL[63:0]             ), // in : New hodoscope signals
        .PSPILL         (PSPILL                   ), // in : SPILL signal
        .MR_SYNC        (MR_SYNC                  ), // in : MR sync signal
        .OLDH           (OLDH[11:0]               ), // in : Old hodoscope signals
        .EV_MATCH       (EV_MATCH                 ), // in : Event-mathcing signal
        .TCP_BUSY       (FIFO_FULL                ), // in : Busy flag for DAQ to pend the data sending
        .START          (RUN_START                ), // in : Start signal to send the data
        .BOARD_ID       (BOARD_ID[3:0]            ), // in : Board ID
        .HEADER         (HEADER[31:0]             ), // in : Header data
        .FOOTER         (FOOTER[31:0]             ), // in : Footer data
        .TRIGGER_INT    (TRIGGER_INT              ), // out:
        .SPILLCOUNT     (SPILLCOUNT[31:0]         ), // out: Spill count

        .FIFO_EMPTY     (FIFO_EMPTY               ), // out: FIFO empty
        .FIFO_RD_EN     (FIFO_RD_EN               ), // in : FIFO read enable
        .DATA_OUT       (DATA_OUT[111:0]          ), // out: FIFO data out
        .DATA_VALID     (DATA_VALID               ), // out: FIFO data valid

        // TCP/IP output data
        .OUTDATA        (             ), // out: Output data into SiTCP
        .SEND_EN        (             ), // out: Output data enable SiTCP
        // Debug pins
        .DEBUG_DATA_EN  (debug_data_en  ), // out:
        .DEBUG_DATA_END (debug_data_end ), // out:
        .DEBUG_DLY_EN   (debug_dly_en   ), // out:
        .DEBUG_RD_EN    (debug_rd_en    ), // out:
        .DEBUG_CNT      (debug_cnt      ), // out:
        .DEBUG_SPLOFFCNT(debug_sploffcnt), // out:
        .DEBUG_DLYSPLCNT(debug_dlysplcnt)  // out:
    );

    wire     [27:0]   app_addr;
    wire      [2:0]   app_cmd;
    wire              app_en;
    wire     [31:0]   app_wdf_data;
    wire              app_wdf_end;
    wire              app_wdf_wren;
    wire     [31:0]   app_rd_data;
    wire              app_rd_data_end;
    wire              app_rd_data_valid;
    wire              app_rdy;
    wire              app_wdf_rdy;
    wire              init_calib_complete;

    wire              test_val;
    wire              test_empty;
    wire              memory_data_val;
    wire      [7:0]   memory_data;

    wire              dram_ren;
    wire              dram_wen;
    wire    [27:0]    dram_addr;
    wire    [31:0]    dram_wdata;
    wire    [31:0]    dram_rdata;
    wire              dram_rdata_valid;
    wire              dram_ready;
    wire              dram_wdf_ready;
    wire              dram_wdone;
    wire              dram_writting;
    wire              dram_rdata104;
    wire              dram_reg_data;
    wire      [2:0]   dram_reg_dat;

    wire      [7:0]   rva_cnt;
    wire      [7:0]   ren_cnt;

    DDR3_IF DDR3_IF(
        // System
        .CLK_200MP     (SYSCLK_200MP_IN ), // in :
        .CLK_200MN     (SYSCLK_200MN_IN ), // in :
        .SYSRST        (SW_N            ), // in :
        
        .USER_CLK      (CLK_200M        ), // out: user clock
        .USER_RST      (user_rst        ), // out: user reset signal

        // Connected wires w/ DDR3                               
        .DDR3_DQ       (ddr3_dq[63:0]   ), // in :
        .DDR3_DQS_N    (ddr3_dqs_n[7:0] ), // in :
        .DDR3_DQS_P    (ddr3_dqs_p[7:0] ), // in :
        .DDR3_ADDR     (ddr3_addr[13:0] ), // out:
        .DDR3_BA       (ddr3_ba[2:0]    ), // out:
        .DDR3_RAS_N    (ddr3_ras_n      ), // out:
        .DDR3_CAS_N    (ddr3_cas_n      ), // out:
        .DDR3_WE_N     (ddr3_we_n       ), // out:
        .DDR3_RESET_N  (ddr3_reset_n    ), // out:
        .DDR3_CK_P     (ddr3_ck_p       ), // out:
        .DDR3_CK_N     (ddr3_ck_n       ), // out:
        .DDR3_CKE      (ddr3_cke        ), // out:
        .DDR3_CS_N     (ddr3_cs_n       ), // out:
        .DDR3_DM       (ddr3_dm[7:0]    ), // out:
        .DDR3_ODT      (ddr3_odt        ), // out:
        
        .app_addr2          (app_addr[27:0]       ),
        .app_cmd2           (app_cmd[2:0]         ),
        .app_en2            (app_en               ),
        .app_rdy2           (app_rdy              ),
        .app_wdf_data2      (app_wdf_data[31:0]   ),
        .app_wdf_end2       (app_wdf_end          ),
        .app_wdf_wren2      (app_wdf_wren         ),
        .app_wdf_rdy2       (app_wdf_rdy          ),
        .app_rd_data2       (app_rd_data[31:0]    ),
        .app_rd_data_end2   (app_rd_data_end      ),
        .app_rd_data_valid2 (app_rd_data_valid    ),
        .init_calib_complete(init_calib_complete  ),

        //.WR_DATA_VAL      (test_val         ),
        //.DATA_FIFO_EMPTY  (test_empty       ),
        .DATA_FIFO_EMPTY  (FIFO_EMPTY       ),
        .DATA_FIFO_READY  (FIFO_READY       ),
        .DATA_FIFO_RD     (FIFO_RD_EN       ),
        .WR_DATA          (DATA_OUT[111:0]  ),
        .WR_DATA_VAL      (DATA_VALID       ),
        .SITCP_FIFO_FULL  (FIFO_FULL        ),
        .TCP_OPEN_ACK     (TCP_OPEN_ACK     ),
        .OUT              (OUTDATA[7:0]     ),
        .OUTVAL           (TCP_TX_EN        ),

        .debug_ren         (dram_ren),
        .debug_wen         (dram_wen),
        .debug_addr        (dram_addr),
        .debug_wdata       (dram_wdata),
        .debug_rdata       (dram_rdata),
        .debug_rdata_valid (dram_rdata_valid),
        .debug_ready       (dram_ready),
        .debug_wdf_ready   (dram_wdf_ready),
        .debug_wdone       (dram_wdone),
        .debug_writting    (dram_writting),
        .debug_dram_rdata  (dram_rdata104),
        .debug_reg_data    (dram_reg_data),
        .debug_reg_dat     (dram_reg_dat),
        .debug_rva_cnt     (rva_cnt),
        .debug_ren_cnt     (ren_cnt)
    );
    assign  memory_data_val = TCP_TX_EN;
    assign  memory_data[7:0] = OUTDATA[7:0];


//-----------------------------------------------------------
//  UDP Slow Controler
//-----------------------------------------------------------
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
        .REG_CHMASK0        (CHMASK0[63:0]        ), // out: Mask channel selector
        .REG_CHMASK1        (CHMASK1[14:0]        ), // out: Mask channel selector
        .REG_SPLCNT_RST_EN  (SPLCNT_RST_EN        ), // out: Enable spill count reset
        .REG_SPLCNT_RST     (INT_SPLCNT_RST       ), // out: Spill count reset
        .REG_SPLCNT_RSTT    (INT_SPLCNT_RSTT[7:0] ), // out: Spill count reset timing from spill end (def: 1us)
        .REG_TEST_PSPILL_EN (TEST_PSPILL_EN       ), // out: Test spill enable 
        .REG_TEST_MRSYNC_EN (TEST_MRSYNC_EN       ), // out: Test MR sync enable
        .REG_TEST_PSPILL_POS(TEST_PSPILL_POS[31:0]), // out: Time width of test spill (Pos.)
        .REG_TEST_PSPILL_NEG(TEST_PSPILL_NEG[31:0]), // out: Time width of test spill (Neg.)
        .REG_TEST_MRSYNC_FRQ(TEST_MRSYNC_FRQ[31:0]), // out: Test MR sync frequency
        .REG_DLY_PSPILL     (DLY_PSPILL[7:0]      ), // out: Delay for spill singal
        .REG_DLY_MRSYNC     (DLY_MRSYNC[7:0]      ), // out: Delay for MR sync
        .REG_DLY_EVMATCH    (DLY_EVMATCH[7:0]     ), // out: Delay for Event matching
        .REG_DLY_MPPC       (DLY_MPPC[7:0]        ), // out: Delay for MPPC
        .REG_DLY_PMT        (DLY_PMT[95:0]        ), // out: Delay for PMT
        .REG_TEST_VAL       (test_val             ), // out:
        .REG_TEST_EMP       (test_empty           )  // out:
    );


//-----------------------------------------------------------
//  Debug
//-----------------------------------------------------------
    wire  CLK_10M;
    wire  PLL_CLKFB;
    wire  LOCKED;
    PLLE2_BASE #(
        .CLKFBOUT_MULT     (5),
        .CLKIN1_PERIOD     (5.000),
        .CLKOUT0_DIVIDE    (100),
        .CLKOUT0_DUTY_CYCLE(0.500),
        .DIVCLK_DIVIDE     (1)
    ) 
    PLLE2_DEBUG(
        .CLKFBOUT          (PLL_CLKFB),
        .CLKOUT0           (CLK_10M),
        .CLKOUT1           (),
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
    reg    [1:0]    irTestSpill;
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
            irTestSpill[1:0] <= 2'b00;
        end else if(irSpillTime[31:0]==TEST_PSPILL_POS[30:0]) begin
            irTestSpill[1:0] <= {irTestSpill[0],1'b1};
        end else if(irSpillTime[31:0]==(TEST_PSPILL_POS[30:0]+TEST_PSPILL_NEG[30:0])) begin
            irTestSpill[1:0] <= {irTestSpill[0],1'b0};
        end else begin
            irTestSpill[1:0] <= irTestSpill[1:0];
        end
    end
    assign TEST_PSPILL = irTestSpill[1];

    /// Generate a pseudo MR sync signal
    reg             irTestMrsync;
    reg   [31:0]    irMrsyncTime;
    reg    [2:0]    irMrsyncPulse;
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
            irMrsyncPulse[2:0] <= 3'd0;
        end else begin
            irMrsyncPulse[2:0] <= {irMrsyncPulse[1:0], irTestMrsync};
        end
    end
    assign TEST_MRSYNC = (irMrsyncPulse[2:1]==2'b01) & TEST_PSPILL ? 1'b1 : 1'b0;

    
    reg   irInitCalibComp;
    always@(posedge CLK_200M) begin
        if(user_rst) begin 
            irInitCalibComp <= 1'b0;
        end else if (init_calib_complete) begin
            irInitCalibComp <= 1'b1;
        end else begin
            irInitCalibComp <= irInitCalibComp;
        end
    end
    //assign GPIO_LED = SPILLCOUNT[3:0];
    //assign GPIO_LED = SPILLCOUNT[31:28];
    assign GPIO_LED = {2'b11,app_rdy,irInitCalibComp};

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
        .probe1 ({FIFO_EMPTY, FIFO_RD_EN, TCP_OPEN_ACK, dram_writting,DATA_VALID,DATA_OUT[104],dram_rdata104,dram_reg_data}),
        .probe2 (DATA_OUT[103:96]     ),
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
        .probe16(debug_rd_en            ),
        
        .probe17(app_addr[27:0]         ),
        .probe18(app_cmd[2:0]           ),
        .probe19(app_en                 ),
        .probe20(app_rdy                ),
        .probe21(app_wdf_data[31:0]     ),
        .probe22(app_wdf_end            ),
        .probe23(app_wdf_wren           ),
        .probe24(app_wdf_rdy            ),
        .probe25(app_rd_data[31:0]      ),
        .probe26(app_rd_data_end        ),
        .probe27(app_rd_data_valid      ),
        .probe28(init_calib_complete    ),
        .probe29(memory_data_val        ),
        .probe30(memory_data[7:0]       ),
        .probe31(dram_ren               ),
        .probe32(dram_wen               ),
        .probe33(dram_addr[27:0]        ),
        .probe34(dram_wdata[31:0]       ),
        .probe35(dram_rdata[31:0]       ),
        .probe36(dram_rdata_valid       ),
        .probe37(dram_ready             ),
        .probe38(dram_wdf_ready         ),
        .probe39(dram_wdone             ),
        .probe40(DATA_OUT[53:27]        ),
        .probe41({rva_cnt[7:0], ren_cnt[7:0],dram_reg_dat[2:0],DATA_OUT[111:104]})
    );

endmodule
