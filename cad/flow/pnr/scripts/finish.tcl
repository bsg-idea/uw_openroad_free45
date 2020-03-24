source $::env(PNR_FLOW_DIR)/scripts/common_utils.tcl

puts "[INFO] Opening design."
open_design results/route.def results/route.sdc

puts "[INFO] Wrapping-up."
wrapup finish

