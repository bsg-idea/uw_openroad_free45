source $::env(PNR_FLOW_DIR)/scripts/common_utils.tcl

puts "[INFO] Opening design."
open_design results/place.def results/place.sdc

puts "[INFO] Performing clock tree synthesis."
clock_tree_synthesis -lut_file "$::env(CTS_TECH_DIR)/lut.txt" \
                     -sol_list "$::env(CTS_TECH_DIR)/sol_list.txt" \
                     -root_buf "BUF_X4" \
                     -wire_unit 20

puts "[INFO] Performing detailed placement (pad_lef=0, pad_right=5)."
set_placement_padding -global -left 0 -right 5
detailed_placement

puts "[INFO] Checking placement legalization."
check_placement

puts "[INFO] Wrapping-up."
wrapup cts

