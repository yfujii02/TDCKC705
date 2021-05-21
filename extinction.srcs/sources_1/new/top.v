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
        input    wire    [1:0]   GPIO_SMA_IN    ,
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


    wire    SPLCNT_RST_EN  ;
    wire    EXIN_SPLCNT_RST;
    wire    EXOUT_SPLCNT_RST;
//    assign  EXIN_SPLCNT_RST = SPLCNT_RST_EN ? GPIO_SMA0_IN : 1'b0;
//    assign  GPIO_SMA1_OUT   = EXOUT_SPLCNT_RST;

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
    wire    [15:0]    EV_MATCH      ; // Event matching signal spill-by-spill
    wire    [63:0]    SIGNAL        ;
//    wire    [63:0]    TEST_SIGNAL   ;
    wire     [1:0]    BH            ; // Beam hodoscope
    wire     [1:0]    TC            ; // Timing counter
    wire     [7:0]    OLDH          ; // Old hodoscope
    wire     [1:0]    NEWH          ; // New hodoscope PMT
    wire              OLDH_ALL      ; // ALL OR of Old hodoscope

    wire    [63:0]    CHMASK0       ; // mask channel if corresponding bit is high
    wire    [14:0]    CHMASK1       ; // mask for non-main counter channels
    wire              TEST_PSPILL_EN; // Tset spill enable
    wire              TEST_MRSYNC_EN; // Tset MR sync enable
    wire              TEST_PSPILL   ; // Test spill signal
    wire              TEST_MRSYNC   ; // Test MR sync signal
    wire     [7:0]    DLYL_PSPILL   ; // Delay for spill singal
    wire     [7:0]    DLYL_MRSYNC   ; // Delay for MR sync
    wire     [7:0]    DLYL_EVMATCH  ; // Delay for Event matching
    wire    [15:0]    DLYL_BH       ; // Delay for Beam hodoscope
    wire    [15:0]    DLYL_TC       ; // Delay for Timing counter
    wire     [7:0]    DLYL_MPPC     ; // Delay for MPPC
    wire     [7:0]    DLYL_OLD_PMT  ; // Delay for PMT
    wire     [7:0]    DLYL_ALLOLD_PMT; // Delay for PMT
    wire     [7:0]    DLYL_NEW_PMT  ; // Delay for PMT

    wire    [63:0]    SIGTEST  ;
    wire     [1:0]    SEE_EDGE_TC;
    wire     [1:0]    SEE_EDGE_BH;
    wire              SEE_EDGE_OLDHALL;

    PREPROCESSOR PREPROCESSOR(
        .SYSCLK       (CLK_200M         ), // in : System clock
        .SYSRST       (TCP_RST          ), // in : System reset
        .PSPILL_IN    (GPIO_SMA_IN[0]   ), // in : PSPILL input
        .EV_MATCH_IN  (GPIO_SMA_IN[1]   ), // in : Event matching
        .LA_HPC_P     (LA_HPC_P[31:0]   ), // in : Connector
        .LA_HPC_N     (LA_HPC_N[31:0]   ), // in : Connector
        .LA_LPC_P     (LA_LPC_P[31:0]   ), // in : Connector
        .LA_LPC_N     (LA_LPC_N[31:0]   ), // in : Connector
        .HA_HPC_P     (HA_HPC_P[19:0]   ), // in : Connector
        .HA_HPC_N     (HA_HPC_N[19:0]   ), // in : Connector
        .DLYL_PSPILL  (DLYL_PSPILL[7:0] ), // in : Delay for spill singal
        .DLYL_MRSYNC  (DLYL_MRSYNC[7:0] ), // in : Delay for MR sync
        .DLYL_EVMATCH (DLYL_EVMATCH[7:0]), // in : Delay for Event matching
        .DLYL_BH      (DLYL_BH[15:0]    ), // in : Delay for Beam hodoscope
        .DLYL_TC      (DLYL_TC[15:0]    ), // in : Delay for Timing counter
        .DLYL_MPPC    (DLYL_MPPC[7:0]   ), // in : Delay for MPPC
        .DLYL_OLD_PMT (DLYL_OLD_PMT[7:0]), // in : Delay for PMT
        .DLYL_ALLOLD_PMT (DLYL_ALLOLD_PMT[7:0]), // in : Delay for PMT
        .DLYL_NEW_PMT (DLYL_NEW_PMT[7:0]), // in : Delay for PMT
        .CHMASK0      (CHMASK0[63:0]    ), // in : mask channel if corresponding bit is high
        .CHMASK1      (CHMASK1[14:0]    ), // in : mask for non-main counter channels
        .PSPILL       (PSPILL_FMC       ), // out: Spill signal (P3)
        .MR_SYNC      (MR_SYNC_FMC      ), // out: MR sync
        .EV_MATCH     (EV_MATCH         ), // out: Event-matching signal
        .BH           (BH[1:0]          ), // out: Beam hodoscope
        .TC           (TC[1:0]          ), // out: Beam hodoscope
        .OLDH_ALL     (OLDH_ALL         ), // out: Old hodoscope signal (ALL OR)
        .OLDH         (OLDH[7:0]        ), // out: Old hodoscope signal
        .NEWH         (NEWH[1:0]        ), // out: New hodoscope signal PMT
        .SIGNAL       (SIGNAL[63:0]     ), // out: New hodoscope signal MPPC
        .SEE_EDGE_TC  (SEE_EDGE_TC[1:0] ),
        .SEE_EDGE_BH  (SEE_EDGE_BH[1:0] ),
        .SEE_EDGE_OLDHALL  (SEE_EDGE_OLDHALL ) 
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
    wire            SYS_RST  ;

    kc705sitcp(
        .SYSCLK_200MP_IN(SYSCLK_200MP_IN), // in : From 200MHz Oscillator module
        .SYSCLK_200MN_IN(SYSCLK_200MN_IN), // in : From 200MHz Oscillator module
        .CLK_200M       (CLK_200M       ), // out: Clock (200MHz)
        .TCP_RST        (TCP_RST        ), // out: TCP reset
        .SYS_RST        (SYS_RST        ),
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
    wire   [15:0]  cnt1;
    wire   [15:0]  cnt2;
    wire   [15:0]  cnt3;
    wire   [15:0]  cnt4;
//    assign SPLCNT_RST = EXOUT_SPLCNT_RST | EXIN_SPLCNT_RST;
    assign BOARD_ID = {1'b0,GPIO_SWITCH[3:1]};

    wire    [3:0]  SPILLDIV;
    wire    [7:0]  dbg_buf_switch;

    //wire   [63:0]  SIG_IN;
    //assign SIG_IN = (RUN_MODE[2:0]==3'h7)? TEST_SIGNAL : SIGNAL;
    reg  TCP_NOACK;
    always @(posedge CLK_200M)begin
        if (TCP_RST) begin
            TCP_NOACK <= 1'b1;
        end else begin
            TCP_NOACK <= ~TCP_OPEN_ACK;
        end
    end
    top_mcs top_mcs(
    // system
        .RESET      ((SYS_RST|RUN_RESET)),
        .CLK_200M   (CLK_200M     ),
//        .SPLCNT_RST     (SPLCNT_RST          ), // in : Spill count reset
        .SPLCNT_RST     (1'b0                ), // in : Spill count reset
        .INT_SPLCNT_RST (INT_SPLCNT_RST      ), // in : (In) Spl cnt reset
        .INT_SPLCNT_RSTT(INT_SPLCNT_RSTT[7:0]), // in : (In) Spl cnt reset timing from spill end
        .EX_SPLCNT_RST  (EXOUT_SPLCNT_RST    ), // out: (Ex) Spl cnt reset
    //
        .SIGNAL     (SIGNAL[63:0] ),
        //.SIGNAL     (SIG_IN[63:0] ),
        .PSPILL     (PSPILL       ),
        .MR_SYNC    (MR_SYNC      ),
        .BH         (BH[1:0]      ),
        .TC         (TC[1:0]      ),
        .OLDH_ALL   (OLDH_ALL     ),
        .NEWH       (NEWH[1:0]    ),
        .OLDH       (OLDH[7:0]    ),
        .EV_MATCH   (EV_MATCH     ),
        .TCP_BUSY   (FIFO_FULL    ), // Busy flag for DAQ to pend the data sending
        .START      (RUN_START    ), // Start signal to send the data
        .BOARD_ID   (BOARD_ID[3:0]),
        .SPILLCOUNT (SPILLCOUNT[31:0]),
        .SPILLDIV   (SPILLDIV[3:0]),
        .OUTDATA    (OUTDATA      ), // Output data into SiTCP
        .SEND_EN    (TCP_TX_EN    ), // Output data enable SiTCP
        .BUF_SWITCH (dbg_buf_switch),
        .DEBUG_SPLOFFCNT(debug_sploffcnt),
        .DEBUG_DLYSPLCNT(debug_dlysplcnt),
        .cnt1(cnt1),
        .cnt2(cnt2),
        .cnt3(cnt3),
        .cnt4(cnt4)
    );

    wire    [7:0]   DELAY_TEST;

//-----------------------------------------------------------
//  UDP Slow Controler
//-----------------------------------------------------------
    wire    [31:0]    TEST_PSPILL_POS;
    wire    [31:0]    TEST_PSPILL_NEG;
    wire    [31:0]    TEST_MRSYNC_FRQ;

    wire   REG_START;
    wire   REG_RESET;

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
        .REG_START          (REG_START            ), // out: Start data transferring (0: stop, 1: start)
        .REG_RESET          (REG_RESET            ), // out: Reset
        .REG_HEADER         (HEADER[31:0]         ), // out: Header
        .REG_FOOTER         (FOOTER[31:0]         ), // out: Footer
        .REG_CHMASK0        (CHMASK0[63:0]        ), // out: Mask channel selector
        .REG_CHMASK1        (CHMASK1[14:0]        ), // out: Mask channel selector
        .REG_SPLCNT_RST_EN  (SPLCNT_RST_EN        ), // out: Enable spill count reset
        .REG_SPLCNT_RST     (INT_SPLCNT_RST       ), // out: Spill count reset
        .REG_SPLCNT_RSTT    (INT_SPLCNT_RSTT[7:0] ), // out: Spill count reset timing from spill end (def: 1us)
        .REG_TEST_PSPILL_EN (TEST_PSPILL_EN       ), // out: Test spill enable 
        .REG_SPLDIV         (SPILLDIV[3:0]        ), // out: Determine the number of MR sync to divide a spill
        .REG_TEST_MRSYNC_EN (TEST_MRSYNC_EN       ), // out: Test MR sync enable
        .REG_TEST_PSPILL_POS(TEST_PSPILL_POS[31:0]), // out: Time width of test spill (Pos.)
        .REG_TEST_PSPILL_NEG(TEST_PSPILL_NEG[31:0]), // out: Time width of test spill (Neg.)
        .REG_TEST_MRSYNC_FRQ(TEST_MRSYNC_FRQ[31:0]), // out: Test MR sync frequency
        .REG_DLYL_PSPILL    (DLYL_PSPILL[7:0]     ), // out: Delay for spill singal
        .REG_DLYL_MRSYNC    (DLYL_MRSYNC[7:0]     ), // out: Delay for MR sync
        .REG_DLYL_EVMATCH   (DLYL_EVMATCH[7:0]    ), // out: Delay for Event matching
        .REG_DLYL_BH        (DLYL_BH[15:0]        ), // out: Delay for Beam hodoscope
        .REG_DLYL_TC        (DLYL_TC[15:0]        ), // out: Delay for Timing counter
        .REG_DLYL_MPPC      (DLYL_MPPC[7:0]       ), // out: Delay for MPPC
        .REG_DLYL_OLD_PMT   (DLYL_OLD_PMT[7:0]    ), // out: Delay for Old PMT
        .REG_DLYL_ALLOLD_PMT(DLYL_ALLOLD_PMT[7:0] ), // out: Delay for Old PMT
        .REG_DLYL_NEW_PMT   (DLYL_NEW_PMT[7:0]    ), // out: Delay for New PMT
        .REG_CNT1 (cnt1),
        .REG_CNT2 (cnt2),
        .REG_CNT3 (cnt3),
        .REG_CNT4 (cnt4),
        .REG_SEE_EDGE_TC (SEE_EDGE_TC[1:0]),
        .REG_SEE_EDGE_BH (SEE_EDGE_BH[1:0]),
        .REG_SEE_EDGE_OLDHALL (SEE_EDGE_OLDHALL) 
    );

   BUFG BUFSTART( .O(RUN_START), .I(REG_START));
   BUFG BUFRESET( .O(RUN_RESET), .I(REG_RESET));

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
//    reg   [63:0]    irTestSignal;
//    reg   [63:0]    irTestSignal_dly1;
//    reg   [63:0]    irTestSignal_dly2;
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
    reg [1:0] irCLK_10M;
    always@(posedge CLK_200M) begin
        if(TCP_RST) begin
            irMrsyncPulse[2:0] <= 3'd0;
//            irTestSignal[63:0] <= 64'd0;
//            irCLK_10M[1:0]     <= 2'd0;
        end else begin
            irMrsyncPulse[2:0] <= {irMrsyncPulse[1:0], irTestMrsync};
//            irCLK_10M[1:0]     <= {irCLK_10M[0],CLK_10M};
//            if (irMrsyncPulse[2:1]==2'b01) begin
//                irTestSignal[63:0] <= {16'd1,16'd1,16'd1,16'd1};
//            end else if (irCLK_10M[1:0]==2'b01)begin
//                irTestSignal[63:0] <= {irTestSignal[62:0],irTestSignal_dly1[63]};
//            end
        end
    end
/*
    always@(posedge CLK_200M) begin
        irTestSignal_dly1 <= irTestSignal;
    end
    reg [127:0] regTestSig;
genvar i;
generate
    for (i = 0; i < 64; i = i+1) begin
        always@(posedge CLK_200M) begin
            if(TCP_RST) begin
                regTestSig[2*i+1:2*i] <= 2'd0;
                irTestSignal_dly2[i]  <= 1'b0;
            end else begin
                regTestSig[2*i+1:2*i] <= {regTestSig[2*i],irTestSignal_dly1[i]};
                irTestSignal_dly2[i]  <= (regTestSig[2*i+1:2*i]==2'b01)? 1'b1 : 1'b0; 
            end
        end
    end
endgenerate
*/
    assign TEST_MRSYNC = (irMrsyncPulse[2:1]==2'b01) & TEST_PSPILL ? 1'b1 : 1'b0;
//    assign TEST_SIGNAL = irTestSignal_dly2;

    
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
/*
    ila_0 ila_0(
        .trig_in(PSPILL   ),
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
        .probe15(debug_data_end         )//,
        //.probe16(debug_rd_en            )
    );*/

endmodule
