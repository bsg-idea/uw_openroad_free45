# Read liberty files
read_liberty $::env(LIB_FILE)

# Read lef def and sdc
read_lef $::env(LEF_FILE)
read_def $::env(PLACE_RESIZE_IN_DEF)
read_sdc $::env(PLACE_RESIZE_IN_SDC)

# Set res and cap
set_wire_rc -resistance $::env(RES_UNIT_PER_MICRON) -capacitance $::env(CAP_UNIT_PER_MICRON)

# initial report
report_checks > $::env(PLACE_RUN_DIR)/reports/pre_resize.checks.rpt
report_tns    > $::env(PLACE_RUN_DIR)/reports/pre_resize.tns.rpt
report_wns    > $::env(PLACE_RUN_DIR)/reports/pre_resize.wns.rpt

# Perform resizing and buffering
set dont_use_cells ""
#foreach cell $::env(DONT_USE_CELLS) {
#  set dont_use_cells "$dont_use_cells [get_full_name [get_lib_cells */$cell]]"
#}

# DISABLED repair max slew due to crashes running some designs
       # -repair_max_slew \

resize -buffer_inputs \
       -buffer_outputs \
       -resize \
       -repair_max_cap \
       -buffer_cell [get_full_name [get_lib_cells */BUF_X4]] \
       ;#-buffer_cell [get_full_name [get_lib_cells */$::env(RESIZER_BUF_CELL)]] \
       ;#-dont_use $dont_use_cells


# final report
report_checks      > $::env(PLACE_RUN_DIR)/reports/post_resize.checks.rpt
report_tns         > $::env(PLACE_RUN_DIR)/reports/post_resize.tns.rpt
report_wns         > $::env(PLACE_RUN_DIR)/reports/post_resize.wns.rpt
report_design_area

# write output
write_def $::env(PLACE_RESIZE_OUT_DEF)
write_verilog $::env(PLACE_RESIZE_OUT_V)

exit

