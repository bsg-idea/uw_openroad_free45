source $::env(PNR_FLOW_DIR)/scripts/common_utils.tcl

open_design results/fp.def results/fp.sdc

set_wire_rc -layer metal3
global_placement -timing_driven -density 0.50

set dont_use_cells ""
foreach cell $::env(DONT_USE_CELLS) {
  lappend dont_use_cells [get_full_name [get_lib_cells */$cell]]
}

set buf [get_lib_cell */BUF_X1]

buffer_ports -buffer_cell $buf
resize -resize -dont_use $dont_use_cells

repair_max_cap -buffer_cell $buf
repair_max_slew -buffer_cell $buf
repair_tie_fanout -max_fanout 30 NangateOpenCellLibrary/LOGIC0_X1/Z
repair_tie_fanout -max_fanout 30 NangateOpenCellLibrary/LOGIC1_X1/Z
repair_max_fanout -max_fanout 30 -buffer_cell $buf
repair_hold_violations -buffer_cell $buf

set_placement_padding -global -left 0 -right 5
detailed_placement
check_placement

finish place

