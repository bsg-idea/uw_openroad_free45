source $::env(PNR_FLOW_DIR)/scripts/common_utils.tcl

puts "[INFO] Opening design."
open_design $::env(SYNTH_RUN_DIR)/results/synth.v \
            $::env(SYNTH_RUN_DIR)/results/synth.sdc \
            $::env(DESIGN_NAME)

if { [info exists ::env(FP_DIE_AREA)] && $::env(FP_DIE_AREA) != "" } {
  puts "[INFO] Initializing floorplan (die_area={$::env(FP_DIE_AREA)}, core_area={$::env(FP_CORE_AREA)})."
  initialize_floorplan -die_area $::env(FP_DIE_AREA) \
                       -core_area $::env(FP_CORE_AREA) \
                       -tracks $::env(TRACKS_INFO_FILE) \
                       -site FreePDK45_38x28_10R_NP_162NW_34O
} else {
  puts "[INFO] Initializing floorplan (util=$::env(FP_UTILIZATION), aspect_ratio=$::env(FP_ASPECT_RATIO), core_space=$::env(FP_CORE_SPACE))."
  initialize_floorplan -utilization [expr $::env(FP_UTILIZATION)*100.0] \
                       -aspect_ratio $::env(FP_ASPECT_RATIO) \
                       -core_space $::env(FP_CORE_SPACE) \
                       -tracks $::env(TRACKS_INFO_FILE) \
                       -site FreePDK45_38x28_10R_NP_162NW_34O
}

puts "[INFO] Placing top-level ports (hor=3, ver=2)."
io_placer -random -hor_layer 3 -ver_layer 2

puts "[INFO] Performing global placement (density=$::env(PLACEMENT_DENSITY))."
set_wire_rc -layer metal3
global_placement -timing_driven -density $::env(PLACEMENT_DENSITY)

if { [has_macros] } {
  puts "[INFO] Performing macro placement."
  macro_placement -global_config $::env(IP_GLOBAL_CFG)
} else {
  puts "[INFO] No macros found, skipping macro placement."
}

puts "[INFO] Performing power network synthesis."
pdngen $::env(PDN_CFG) -verbose

puts "[INFO] Wrapping-up."
wrapup fp

