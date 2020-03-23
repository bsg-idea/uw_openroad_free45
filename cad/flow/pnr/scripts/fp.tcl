source $::env(PNR_FLOW_DIR)/scripts/common_utils.tcl

open_design $::env(SYNTH_RUN_DIR)/results/synth.v \
            $::env(SYNTH_RUN_DIR)/results/synth.sdc \
            $::env(DESIGN_NAME)

if { [info exists ::env(FP_DIE_AREA)] && $::env(FP_DIE_AREA) != "" } {
  initialize_floorplan -die_area $::env(FP_DIE_AREA) \
                       -core_area $::env(FP_CORE_AREA) \
                       -tracks $::env(TRACKS_INFO_FILE) \
                       -site FreePDK45_38x28_10R_NP_162NW_34O
} else {
  initialize_floorplan -utilization $::env(FP_UTILIZATION) \
                       -aspect_ratio $::env(FP_ASPECT_RATIO) \
                       -core_space $::env(FP_CORE_SPACE) \
                       -tracks $::env(TRACKS_INFO_FILE) \
                       -site FreePDK45_38x28_10R_NP_162NW_34O
}

io_placer -random -hor_layer 3 -ver_layer 2

set_wire_rc -layer metal3
global_placement -timing_driven -density 0.50

if { [has_macros] } {
  macro_placement -global_config $::env(IP_GLOBAL_CFG)
}

pdngen $::env(PDN_CFG) -verbose

finish fp

