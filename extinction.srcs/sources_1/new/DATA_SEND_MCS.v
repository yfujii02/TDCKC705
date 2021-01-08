`timescale 1ns / 1ps

module DATA_SEND_MCS(
);

    assign R_EN   = RD_ENABLE & ~TCP_FULL & (TXCOUNT<=MAXCOUNT) & ~SHIFT;
    assign rdBusy = (TXCOUNT<MAXCOUNT) & ~TCP_FULL & ~SHIFT;

    always@ (posedge TX_CLK) begin
        if(RST) begin
            TXCOUNT     <= MAXCOUNT;
        end else begin
            if(R_EN) begin
                TXCOUNT <= TXCOUNT - 16'd1;
            end else if(EOD) begin
                TXCOUNT <= MAXCOUNT;
            end
        end
    end

    always@ (posedge TX_CLK) begin
        if(RST) begin
            dlyTXCOUNT  <= 16'hFFFF;
            dlyRdBusy   <=  1'b0   ;
            dlyHdCOUNT  <=  4'b1000;
            eachCNTR    <=  6'd0   ;
            LENGTH      <= 11'd0   ;
        end else begin
            dlyTXCOUNT  <= TXCOUNT;
            dlyRdBusy   <= rdBusy ;
            if(ENABLE) begin
                LENGTH  <= 11'd0;
                eachCNTR<=  6'd0;
            end else begin
                if(TXCOUNT+16'd8>=MAXCOUNT) begin
                    dlyHdCOUNT  <= TXCOUNT+16'd8-MAXCOUNT;
                end else begin
                    dlyHdCOUNT  <= 4'b1000;
                    if(SHIFT) begin
                        eachCNTR <= 6'd0;
                        LENGTH   <= LENGTH + 11'd1;
                    end else begin
                        eachCNTR <= (R_EN)? eachCNTR + 6'd1 : eachCNTR;
                    end
                end
            end
        end
    end

    reg   [5:0]  dlyEachCNTR;
    always@ (posedge TX_CLK) begin
        if(RST) begin
            dlyEachCNTR <=  6'd0   ;
        end else begin
            dlyEachCNTR <= eachCNTR;
        end
    end


    always@ (posedge TX_CLK) begin
        if(RST) begin
            DOUT   <=  8'd0;
            EOD    <=  1'b0;
        end else begin
            if(ENABLE) begin
                EOD <= 1'b0;
            end else if(dlyRdBusy) begin
                if(~dlyHdCOUNT[3]) begin /// send header
                    case(dlyHdCOUNT[2:0])
                        3'h7: DOUT <= 8'hAA;
                        3'h6: DOUT <= 8'hAA;
                        3'h5: DOUT <= 8'hAA;
                        3'h4: DOUT <= 8'hAA;
                        3'h3: DOUT <= 8'h00;
                        3'h2: DOUT <= 8'h00;
                        3'h1: DOUT <= SPLCOUNT[15: 8];
                        3'h0: DOUT <= SPLCOUNT[ 7: 0];
                    endcase
                end else if(dlyTXCOUNT>=16'd8) begin /// send data
                    case(dlyEachCNTR[5:0])
                        6'h00: DOUT <= COUNTER00[23:16];
                        6'h01: DOUT <= COUNTER00[15: 8];
                        6'h02: DOUT <= COUNTER00[ 7: 0];
                        6'h03: DOUT <= COUNTER01[23:16];
                        6'h04: DOUT <= COUNTER01[15: 8];
                        6'h05: DOUT <= COUNTER01[ 7: 0];
                        6'h06: DOUT <= COUNTER02[23:16];
                        6'h07: DOUT <= COUNTER02[15: 8];
                        6'h08: DOUT <= COUNTER02[ 7: 0];
                        6'h09: DOUT <= COUNTER03[23:16];
                        6'h0A: DOUT <= COUNTER03[15: 8];
                        6'h0B: DOUT <= COUNTER03[ 7: 0];
                        6'h0C: DOUT <= COUNTER04[23:16];
                        6'h0D: DOUT <= COUNTER04[15: 8];
                        6'h0E: DOUT <= COUNTER04[ 7: 0];
                        6'h0F: DOUT <= COUNTER05[23:16];
                        6'h10: DOUT <= COUNTER05[15: 8];
                        6'h11: DOUT <= COUNTER05[ 7: 0];
                        6'h12: DOUT <= COUNTER06[23:16];
                        6'h13: DOUT <= COUNTER06[15: 8];
                        6'h14: DOUT <= COUNTER06[ 7: 0];
                        6'h15: DOUT <= COUNTER07[23:16];
                        6'h16: DOUT <= COUNTER07[15: 8];
                        6'h17: DOUT <= COUNTER07[ 7: 0];
                        6'h18: DOUT <= COUNTER08[23:16];
                        6'h19: DOUT <= COUNTER08[15: 8];
                        6'h1A: DOUT <= COUNTER08[ 7: 0];
                        6'h1B: DOUT <= COUNTER09[23:16];
                        6'h1C: DOUT <= COUNTER09[15: 8];
                        6'h1D: DOUT <= COUNTER09[ 7: 0];
                        6'h1E: DOUT <= COUNTER10[23:16];
                        6'h1F: DOUT <= COUNTER10[15: 8];
                        6'h20: DOUT <= COUNTER10[ 7: 0];
                        6'h21: DOUT <= COUNTER11[23:16];
                        6'h22: DOUT <= COUNTER11[15: 8];
                        6'h23: DOUT <= COUNTER11[ 7: 0];
                        6'h24: DOUT <= COUNTER12[23:16];
                        6'h25: DOUT <= COUNTER12[15: 8];
                        6'h26: DOUT <= COUNTER12[ 7: 0];
                        6'h27: DOUT <= COUNTER13[23:16];
                        6'h28: DOUT <= COUNTER13[15: 8];
                        6'h29: DOUT <= COUNTER13[ 7: 0];
                        6'h2A: DOUT <= COUNTER14[23:16];
                        6'h2B: DOUT <= COUNTER14[15: 8];
                        6'h2C: DOUT <= COUNTER14[ 7: 0];
                        6'h2D: DOUT <= COUNTER15[23:16];
                        6'h2E: DOUT <= COUNTER15[15: 8];
                        6'h2F: DOUT <= COUNTER15[ 7: 0];
                        6'h3A: DOUT <= COUNTER17[23:16];
                        6'h3B: DOUT <= COUNTER17[15: 8];
                        6'h3C: DOUT <= COUNTER17[ 7: 0];
                        default: DOUT <= 8'h0;
                    endcase
                end else begin /// send footer
                    case(dlyTXCOUNT[2:0])
                        3'h7: DOUT <= 8'hFF;
                        3'h6: DOUT <= 8'hFF;
                        3'h5: DOUT <= 8'hFF;
                        3'h4: DOUT <= 8'hFF;
                        3'h3: DOUT <= rNMRSYNC[31:24];
                        3'h2: DOUT <= rNMRSYNC[23:16];
                        3'h1: DOUT <= rNMRSYNC[15: 8];
                        3'h0: DOUT <= rNMRSYNC[ 7: 0];
                    endcase
                    if(dlyTXCOUNT[2:0]==3'h0) begin
                       EOD <= 1'b1;
                    end
                end
            end else begin
                DOUT <= 8'd0;
            end
        end
    end

    always@ (posedge TX_CLK) begin
        if(RST) begin
            dlyRdBusy2 <= 1'b0;
        end else begin
            dlyRdBusy2 <= dlyRdBusy;
        end
    end

    assign SEND_EN = dlyRdBusy2;
endmodule
