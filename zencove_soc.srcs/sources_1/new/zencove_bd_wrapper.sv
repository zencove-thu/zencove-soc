`timescale 1ns / 1ps
`include "iobuf_helper.svh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2022 11:07:15 PM
// Design Name: 
// Module Name: zencove_bd_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module zencove_bd_wrapper (input wire clk,
                        input wire rst_n,

                        inout wire CFG_FLASH_mosi,
                        inout wire CFG_FLASH_miso,
                        inout wire CFG_FLASH_ss,

                        output wire [12:0] DDR3_addr,
                        output wire [2:0] DDR3_ba,
                        output wire DDR3_cas_n,
                        output wire [0:0] DDR3_ck_n,
                        output wire [0:0] DDR3_ck_p,
                        output wire [0:0] DDR3_cke,
                        output wire [1:0] DDR3_dm,
                        inout wire [15:0] DDR3_dq,
                        inout wire [1:0] DDR3_dqs_n,
                        inout wire [1:0] DDR3_dqs_p,
                        output wire [0:0] DDR3_odt,
                        output wire DDR3_ras_n,
                        output wire DDR3_reset_n,
                        output wire DDR3_we_n,

                        output wire LCD_csel,
                        inout wire [15:0] LCD_data_tri_io,
                        output wire LCD_nrst,
                        output wire LCD_rd,
                        output wire LCD_rs,
                        output wire LCD_wr,
                        output wire LCD_lighton,

                        output wire MDIO_mdc,
                        inout wire MDIO_mdio_io,
                        input wire MII_col,
                        input wire MII_crs,
                        output wire MII_rst_n,
                        input wire MII_rx_clk,
                        input wire MII_rx_dv,
                        input wire MII_rx_er,
                        input wire [3:0] MII_rxd,
                        input wire MII_tx_clk,
                        output wire MII_tx_en,
                        output wire MII_tx_er,
                        output wire [3:0] MII_txd,

                        inout wire PS2_clk_tri_io,
                        inout wire PS2_dat_tri_io,

                        inout wire SPI_FLASH_mosi,
                        inout wire SPI_FLASH_miso,
                        inout wire SPI_FLASH_io2,
                        inout wire SPI_FLASH_io3,
                        inout wire SPI_FLASH_sck,
                        inout wire SPI_FLASH_ss,

                        input wire UART_rxd,
                        output wire UART_txd,

                        inout wire [3:0] VGA_r,
                        inout wire [3:0] VGA_g,
                        inout wire [3:0] VGA_b,
                        output wire VGA_hsync,
                        output wire VGA_vsync,

                        output wire [3:0] btn_key_col,
                        input wire [3:0] btn_key_row,
                        input wire [1:0] btn_step,

                        output wire [15:0] led,
                        output wire [1:0] led_rg0,
                        output wire [1:0] led_rg1,
                        output wire [7:0] num_seg,
                        output wire [7:0] num_csn,
                        input wire [7:0] switch,
                        output wire [7:0] led_mat_row,
                        output wire [7:0] led_mat_col,
                        
                        // USB
    input  wire       UTMI_clk,
    inout  wire [7:0] UTMI_data,
    output wire       UTMI_reset,
    input  wire       UTMI_txready,
    input  wire       UTMI_rxvalid,
    input  wire       UTMI_rxactive,
    input  wire       UTMI_rxerror,
    input  wire [1:0] UTMI_linestate,
    input  wire       UTMI_hostdisc,
    input  wire       UTMI_iddig,
    input  wire       UTMI_vbusvalid,
    input  wire       UTMI_sessend,
    output wire       UTMI_txvalid,
    output wire [1:0] UTMI_opmode,
    output wire [1:0] UTMI_xcvrsel,
    output wire       UTMI_termsel,
    output wire       UTMI_dppulldown,
    output wire       UTMI_dmpulldown,
    output wire       UTMI_idpullup,
    output wire       UTMI_chrgvbus,
    output wire       UTMI_dischrgvbus,
    output wire       UTMI_suspend_n,

                        input wire EJTAG_trst,
                        input wire EJTAG_tck,
                        input wire EJTAG_tdi,
                        input wire EJTAG_tms,
                        output wire EJTAG_tdo);
    
    
    // CFG FLASH
    wire CFG_FLASH_io0_i;
    wire CFG_FLASH_io0_o;
    wire CFG_FLASH_io0_t;
    wire CFG_FLASH_io1_i;
    wire CFG_FLASH_io1_o;
    wire CFG_FLASH_io1_t;
    wire CFG_FLASH_ss_i;
    wire CFG_FLASH_ss_o;
    wire CFG_FLASH_ss_t;
    
    IOBUF CFG_FLASH_io0_iobuf
    (.I(CFG_FLASH_io0_o),
    .IO(CFG_FLASH_mosi),
    .O(CFG_FLASH_io0_i),
    .T(CFG_FLASH_io0_t));
    IOBUF CFG_FLASH_io1_iobuf
    (.I(CFG_FLASH_io1_o),
    .IO(CFG_FLASH_miso),
    .O(CFG_FLASH_io1_i),
    .T(CFG_FLASH_io1_t));
    IOBUF CFG_FLASH_ss_iobuf
    (.I(CFG_FLASH_ss_o),
    .IO(CFG_FLASH_ss),
    .O(CFG_FLASH_ss_i),
    .T(CFG_FLASH_ss_t));
    
    // VGA
    wire  [5:0] VGA_red, VGA_green, VGA_blue;
    genvar VGA_i;
    generate
    for (VGA_i = 0; VGA_i < 4; VGA_i = VGA_i+1) begin : VGA_gen
    //match on-board DAC built by resistor
    assign VGA_r[VGA_i] = VGA_red[VGA_i+2] ? 1'b1 : 1'bZ;
    assign VGA_g[VGA_i] = VGA_green[VGA_i+2] ? 1'b1 : 1'bZ;
    assign VGA_b[VGA_i] = VGA_blue[VGA_i+2] ? 1'b1 : 1'bZ;
    end
    endgenerate
    
    // LCD
    assign LCD_lighton = 1'b1;
    wire [15:0] LCD_data_tri_i, LCD_data_tri_o, LCD_data_tri_t;
    genvar lcd_i;
    generate
    for(lcd_i = 0; lcd_i<16; lcd_i = lcd_i+1)begin : lcd_data
    IOBUF lcd_buf(
    .IO(LCD_data_tri_io[lcd_i]),
    .O(LCD_data_tri_i[lcd_i]),
    .I(LCD_data_tri_o[lcd_i]),
    .T(LCD_data_tri_t[lcd_i])
    );
    end
    endgenerate
    
    // USB
    `IOBUF_GEN_VEC_UNIFORM_SIMPLE(UTMI_data);
    
    //ethernet
    wire MDIO_mdio_i;
    wire MDIO_mdio_o;
    wire MDIO_mdio_t;
    IOBUF MDIO_mdio_iobuf
    (.I(MDIO_mdio_o),
    .IO(MDIO_mdio_io),
    .O(MDIO_mdio_i),
    .T(MDIO_mdio_t));
    assign MII_tx_er = 1'b0;
    
    
    // PS2
    wire PS2_clk_tri_i;
    wire PS2_clk_tri_o;
    wire PS2_clk_tri_t;
    
    wire PS2_dat_tri_i;
    wire PS2_dat_tri_o;
    wire PS2_dat_tri_t;
    IOBUF PS2_clk_tri_iobuf
    (.I(PS2_clk_tri_o),
    .IO(PS2_clk_tri_io),
    .O(PS2_clk_tri_i),
    .T(PS2_clk_tri_t));
    IOBUF PS2_dat_tri_iobuf
    (.I(PS2_dat_tri_o),
    .IO(PS2_dat_tri_io),
    .O(PS2_dat_tri_i),
    .T(PS2_dat_tri_t));
    
    
    // plugable SPI FLASH
    wire SPI_FLASH_io0_i;
    wire SPI_FLASH_io0_o;
    wire SPI_FLASH_io0_t;
    
    wire SPI_FLASH_io1_i;
    wire SPI_FLASH_io1_o;
    wire SPI_FLASH_io1_t;
    
    wire SPI_FLASH_io2_i;
    wire SPI_FLASH_io2_o;
    wire SPI_FLASH_io2_t;
    
    wire SPI_FLASH_io3_i;
    wire SPI_FLASH_io3_o;
    wire SPI_FLASH_io3_t;
    
    wire SPI_FLASH_sck_i;
    wire SPI_FLASH_sck_o;
    wire SPI_FLASH_sck_t;
    
    wire SPI_FLASH_ss_i;
    wire SPI_FLASH_ss_o;
    wire SPI_FLASH_ss_t;
    
    
    IOBUF SPI_FLASH_io0_iobuf
    (.I(SPI_FLASH_io0_o),
    .IO(SPI_FLASH_mosi),
    .O(SPI_FLASH_io0_i),
    .T(SPI_FLASH_io0_t));
    IOBUF SPI_FLASH_io1_iobuf
    (.I(SPI_FLASH_io1_o),
    .IO(SPI_FLASH_miso),
    .O(SPI_FLASH_io1_i),
    .T(SPI_FLASH_io1_t));
    IOBUF SPI_FLASH_io2_iobuf
    (.I(SPI_FLASH_io2_o),
    .IO(SPI_FLASH_io2),
    .O(SPI_FLASH_io2_i),
    .T(SPI_FLASH_io2_t));
    IOBUF SPI_FLASH_io3_iobuf
    (.I(SPI_FLASH_io3_o),
    .IO(SPI_FLASH_io3),
    .O(SPI_FLASH_io3_i),
    .T(SPI_FLASH_io3_t));
    IOBUF SPI_FLASH_sck_iobuf
    (.I(SPI_FLASH_sck_o),
    .IO(SPI_FLASH_sck),
    .O(SPI_FLASH_sck_i),
    .T(SPI_FLASH_sck_t));
    IOBUF SPI_FLASH_ss_iobuf
    (.I(SPI_FLASH_ss_o),
    .IO(SPI_FLASH_ss),
    .O(SPI_FLASH_ss_i),
    .T(SPI_FLASH_ss_t));
    
    
    zencove zencove_bd_1
    (
    .clk(clk),
    .rst_n(rst_n),
    .CFG_FLASH_io0_i(CFG_FLASH_io0_i),
    .CFG_FLASH_io0_o(CFG_FLASH_io0_o),
    .CFG_FLASH_io0_t(CFG_FLASH_io0_t),
    .CFG_FLASH_io1_i(CFG_FLASH_io1_i),
    .CFG_FLASH_io1_o(CFG_FLASH_io1_o),
    .CFG_FLASH_io1_t(CFG_FLASH_io1_t),
    .CFG_FLASH_ss_i(CFG_FLASH_ss_i),
    .CFG_FLASH_ss_o(CFG_FLASH_ss_o),
    .CFG_FLASH_ss_t(CFG_FLASH_ss_t),
    
    .DDR3_addr(DDR3_addr),
    .DDR3_ba(DDR3_ba),
    .DDR3_cas_n(DDR3_cas_n),
    .DDR3_ck_n(DDR3_ck_n),
    .DDR3_ck_p(DDR3_ck_p),
    .DDR3_cke(DDR3_cke),
    .DDR3_dm(DDR3_dm),
    .DDR3_dq(DDR3_dq),
    .DDR3_dqs_n(DDR3_dqs_n),
    .DDR3_dqs_p(DDR3_dqs_p),
    .DDR3_odt(DDR3_odt),
    .DDR3_ras_n(DDR3_ras_n),
    .DDR3_reset_n(DDR3_reset_n),
    .DDR3_we_n(DDR3_we_n),
    
    .LCD_csel(LCD_csel),
    .LCD_data_tri_i(LCD_data_tri_i),
    .LCD_data_tri_o(LCD_data_tri_o),
    .LCD_data_tri_t(LCD_data_tri_t),
    .LCD_nrst(LCD_nrst),
    .LCD_rd(LCD_rd),
    .LCD_rs(LCD_rs),
    .LCD_wr(LCD_wr),
    
    .MDIO_mdc(MDIO_mdc),
    .MDIO_mdio_i(MDIO_mdio_i),
    .MDIO_mdio_o(MDIO_mdio_o),
    .MDIO_mdio_t(MDIO_mdio_t),
    .MII_col(MII_col),
    .MII_crs(MII_crs),
    .MII_rst_n(MII_rst_n),
    .MII_rx_clk(MII_rx_clk),
    .MII_rx_dv(MII_rx_dv),
    .MII_rx_er(MII_rx_er),
    .MII_rxd(MII_rxd),
    .MII_tx_clk(MII_tx_clk),
    .MII_tx_en(MII_tx_en),
    .MII_txd(MII_txd),
    
    .PS2_clk_tri_i(PS2_clk_tri_i),
    .PS2_clk_tri_o(PS2_clk_tri_o),
    .PS2_clk_tri_t(PS2_clk_tri_t),
    .PS2_dat_tri_i(PS2_dat_tri_i),
    .PS2_dat_tri_o(PS2_dat_tri_o),
    .PS2_dat_tri_t(PS2_dat_tri_t),
    
    .SPI_FLASH_io0_i(SPI_FLASH_io0_i),
    .SPI_FLASH_io0_o(SPI_FLASH_io0_o),
    .SPI_FLASH_io0_t(SPI_FLASH_io0_t),
    .SPI_FLASH_io1_i(SPI_FLASH_io1_i),
    .SPI_FLASH_io1_o(SPI_FLASH_io1_o),
    .SPI_FLASH_io1_t(SPI_FLASH_io1_t),
    .SPI_FLASH_io2_i(SPI_FLASH_io2_i),
    .SPI_FLASH_io2_o(SPI_FLASH_io2_o),
    .SPI_FLASH_io2_t(SPI_FLASH_io2_t),
    .SPI_FLASH_io3_i(SPI_FLASH_io3_i),
    .SPI_FLASH_io3_o(SPI_FLASH_io3_o),
    .SPI_FLASH_io3_t(SPI_FLASH_io3_t),
    .SPI_FLASH_sck_i(SPI_FLASH_sck_i),
    .SPI_FLASH_sck_o(SPI_FLASH_sck_o),
    .SPI_FLASH_sck_t(SPI_FLASH_sck_t),
    .SPI_FLASH_ss_i(SPI_FLASH_ss_i),
    .SPI_FLASH_ss_o(SPI_FLASH_ss_o),
    .SPI_FLASH_ss_t(SPI_FLASH_ss_t),
    
    .UART_baudoutn(),
    .UART_ctsn(1'b0),
    .UART_dcdn(1'b0),
    .UART_ddis(),
    .UART_dsrn(1'b0),
    .UART_dtrn(),
    .UART_out1n(),
    .UART_out2n(),
    .UART_ri(1'b1),
    .UART_rtsn(),
    .UART_rxd(UART_rxd),
    .UART_rxrdyn(),
    .UART_txd(UART_txd),
    .UART_txrdyn(),
    
    .VGA_blue(VGA_blue),
    .VGA_clk(),
    .VGA_de(),
    .VGA_dps(),
    .VGA_green(VGA_green),
    .VGA_hsync(VGA_hsync),
    .VGA_red(VGA_red),
    .VGA_vsync(VGA_vsync),
    
    // USB
    .UTMI_clk,
    .UTMI_data_i,
    .UTMI_data_o,
    .UTMI_data_t,
    .UTMI_reset,
    .UTMI_txready,
    .UTMI_rxvalid,
    .UTMI_rxactive,
    .UTMI_rxerror,
    .UTMI_linestate,
    .UTMI_hostdisc,
    .UTMI_iddig,
    .UTMI_vbusvalid,
    .UTMI_sessend,
    .UTMI_txvalid,
    .UTMI_opmode,
    .UTMI_xcvrsel,
    .UTMI_termsel,
    .UTMI_dppulldown,
    .UTMI_dmpulldown,
    .UTMI_idpullup,
    .UTMI_chrgvbus,
    .UTMI_dischrgvbus,
    .UTMI_suspend_n,
    
    .btn_key_col(btn_key_col),
    .btn_key_row(btn_key_row),
    .btn_step(btn_step),
    .led(led),
    .led_rg0(led_rg0),
    .led_rg1(led_rg1),
    .num_seg(num_seg),
    .num_csn(num_csn),
    .led_mat_row,
    .led_mat_col,
    .switch(switch));
endmodule

