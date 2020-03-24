source $::env(PNR_FLOW_DIR)/scripts/common_utils.tcl

puts "[INFO] Opening design."
open_design results/cts.def results/cts.sdc

puts "[INFO] Performing global routing."
set_wire_rc -layer metal3
fastroute -output_file results/pre_route.guide \
          -max_routing_layer 10 \
          -unidirectional_routing true \
          -capacity_adjustment 0.15 \
          -layers_adjustments {{2 0.5} {3 0.5}} \
          -overflow_iterations 200

puts "[INFO] Wrapping-up."
wrapup pre_route

