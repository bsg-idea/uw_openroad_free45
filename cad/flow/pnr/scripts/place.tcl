source $::env(PNR_FLOW_DIR)/scripts/common_utils.tcl

puts "[INFO] Opening design."
open_design results/fp.def results/fp.sdc

puts "[INFO] Performing global placement (density=$::env(PLACEMENT_DENSITY))."
set_wire_rc -layer metal3
global_placement -timing_driven -density $::env(PLACEMENT_DENSITY)

set buf [get_lib_cell */BUF_X1]

set dont_use_cells ""
foreach cell $::env(DONT_USE_CELLS) {
  lappend dont_use_cells [get_full_name [get_lib_cells */$cell]]
}
puts "[INFO] Marking cells as dont_use: $dont_use_cells."

puts "[INFO] Buffering top-level ports."
buffer_ports -buffer_cell $buf

puts "[INFO] Performing resizing."
resize -resize -dont_use $dont_use_cells

puts "[INFO] Repairing design DRVs."
repair_max_cap -buffer_cell $buf
repair_max_slew -buffer_cell $buf
repair_tie_fanout -max_fanout 30 NangateOpenCellLibrary/LOGIC0_X1/Z
repair_tie_fanout -max_fanout 30 NangateOpenCellLibrary/LOGIC1_X1/Z
repair_max_fanout -max_fanout 30 -buffer_cell $buf
repair_hold_violations -buffer_cell $buf

puts "[INFO] Performing detailed placement (pad_lef=0, pad_right=5)."
set_placement_padding -global -left 0 -right 5
detailed_placement

puts "[INFO] Checking placement legalization."
check_placement

puts "[INFO] Wrapping-up."
wrapup place

