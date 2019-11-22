set period  10
set in_dly  [expr $period / 2]
set out_dly [expr $period / 2]

set clk_port  [get_ports clk_i]
set in_ports  [remove_from_collection [all_inputs] [get_ports clk_i]]
set out_ports [all_outputs]

create_clock -name clk -period $period $clk_port
set_input_delay -clock clk $in_dly $in_ports
set_output_delay -clock clk $out_dly $out_ports
