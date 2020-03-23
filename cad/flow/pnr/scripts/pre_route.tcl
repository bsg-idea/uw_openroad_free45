source $::env(PNR_FLOW_DIR)/scripts/common_utils.tcl

open_design results/cts.def results/cts.sdc

set_wire_rc -layer metal3

fastroute -output_file results/route.guide \
          -max_routing_layer 10 \
          -unidirectional_routing true \
          -capacity_adjustment 0.15 \
          -layers_adjustments {{2 0.5} {3 0.5}} \
          -overflow_iterations 200

finish pre_route

