# CFG Flash

set_max_delay -datapath_only -from [get_pins -hier *SCK_O_reg_reg/C] -to [get_pins -hier *USRCCLKO] 1.500
set_min_delay -from [get_pins -hier *SCK_O_reg_reg/C] -to [get_pins -hier *USRCCLKO] 0.100

create_generated_clock -name clk_sck -source [get_pins -hierarchical *axi_cfg_flash/ext_spi_clk] -edges {3 5 7} -edge_shift {7.500 7.500 7.500} [get_pins -hierarchical *USRCCLKO]

set_input_delay -clock clk_sck -clock_fall -max 8.100 [get_ports CFG_FLASH_*]
set_input_delay -clock clk_sck -clock_fall -min 2.450 [get_ports CFG_FLASH_*]
set_multicycle_path -setup -from clk_sck -to [get_clocks -of_objects [get_pins -hierarchical */ext_spi_clk]] 2
set_multicycle_path -hold -end -from clk_sck -to [get_clocks -of_objects [get_pins -hierarchical */ext_spi_clk]] 1

set_output_delay -clock clk_sck -max 3.050 [get_ports CFG_FLASH_*]
set_output_delay -clock clk_sck -min -2.950 [get_ports CFG_FLASH_*]
set_multicycle_path -setup -start -from [get_clocks -of_objects [get_pins -hierarchical */ext_spi_clk]] -to clk_sck 2
set_multicycle_path -hold -from [get_clocks -of_objects [get_pins -hierarchical */ext_spi_clk]] -to clk_sck 1


# VGA

set vga_clk clk_vga_zencove_clk_wiz_0_0
set_output_delay -clock $vga_clk -min -add_delay -1.000 [get_ports {VGA_*}]
set_output_delay -clock $vga_clk -max -add_delay 2.000 [get_ports {VGA_*}]


# Ethernet

set_input_delay -clock MII_rx_clk -min 10  [get_ports [list MII_rx_dv  MII_rx_er MII_rxd*]]
set_input_delay -clock MII_rx_clk -max [expr 40-10]  [get_ports [list MII_rx_dv  MII_rx_er MII_rxd*]]
set_output_delay -clock MII_tx_clk -min 0  [get_ports [list MII_tx_en  MII_txd*]]
set_output_delay -clock MII_tx_clk -max 12  [get_ports [list MII_tx_en  MII_txd*]]

# USB UTMI

create_clock -period 16.667 -name utmi_clk -waveform {0.000 8.333} [get_ports UTMI_clk]
set_output_delay -clock [get_clocks utmi_clk] -min -add_delay 0.000 [get_ports {UTMI_data[*]}]
set_output_delay -clock [get_clocks utmi_clk] -max -add_delay 2.000 [get_ports {UTMI_data[*]}]
set_output_delay -clock [get_clocks utmi_clk] -min -add_delay 0.000 [get_ports UTMI_txvalid]
set_output_delay -clock [get_clocks utmi_clk] -max -add_delay 2.000 [get_ports UTMI_txvalid]

# GPIO

set periph_clk clk_peripheral_zencove_clk_wiz_0_0

set_output_delay 0 -clock $periph_clk [get_ports [list num_* led* UART_txd MII_rst_n DDR3_reset_n PS2_*]]
set_false_path -to [get_ports [list num_* led* btn* switch* UART_txd MII_rst_n DDR3_reset_n PS2_*]]

set_input_delay 0 -clock $periph_clk [get_ports [list btn_key_row* btn_step* switch* rst_n UART_rxd PS2_*]]
set_false_path -from [get_ports [list btn_key_row* btn_step* switch* rst_n UART_rxd PS2_*]]
