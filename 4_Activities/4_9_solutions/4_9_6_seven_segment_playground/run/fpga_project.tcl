# Synthesis and Place & Route settings

set_device GW1NR-LV9QN88PC6/I5 -name GW1NR-9 -device_version C

set_option -synthesis_tool gowinsynthesis
set_option -output_base_name fpga_project
set_option -top_module board_specific_top
set_option -verilog_std sysv2017

set_option -use_mspi_as_gpio 1
set_option -use_sspi_as_gpio 1
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/4_Activities/4_9_solutions/4_9_6_seven_segment_playground/hackathon_top.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/boards/tang_nano_9k_lcd_480_272_tm1638_hackathon/board_specific_top.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/boards/tang_nano_9k_lcd_480_272_tm1638_hackathon/gowin_rpll.v
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/audio_pwm.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/digilent_pmod_mic3_spi_receiver.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/dvi.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/hub75e_led_matrix.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/i2s_audio_out.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/imitate_reset_on_power_up.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/inmp441_mic_i2s_receiver.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/inmp441_mic_i2s_receiver_alt.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/inmp441_mic_i2s_receiver_new.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/lcd_480_272.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/lcd_480_272_ml6485.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/lcd_800_480.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/sigma_delta_dac.v
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/slow_clk_gen.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/tm1638_board.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/tm1638_registers.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/tm1638_using_graphics.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/tm1638_virtual_switches.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/peripherals/vga.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/labs/common/convert.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/labs/common/counter_with_enable.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/labs/common/seven_segment_display.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/labs/common/shift_reg.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/labs/common/strobe_gen.sv
add_file -type verilog c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/labs/common/tb_lcd_display.sv
add_file -type cst c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/boards/tang_nano_9k_lcd_480_272_tm1638_hackathon/board_specific.cst
add_file -type sdc c:/Users/SUSHEMER/OneDrive/Documentos/GitHub/systemverilog-basic/boards/tang_nano_9k_lcd_480_272_tm1638_hackathon/board_specific.sdc
run all
