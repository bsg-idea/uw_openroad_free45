source $::env(PNR_FLOW_DIR)/scripts/common_utils.tcl

open_design results/place.def results/place.sdc

clock_tree_synthesis -lut_file "$::env(CTS_TECH_DIR)/lut.txt" \
                     -sol_list "$::env(CTS_TECH_DIR)/sol_list.txt" \
                     -root_buf "BUF_X4" \
                     -wire_unit 20

set_placement_padding -global -left 0 -right 5
detailed_placement
check_placement

finish cts

