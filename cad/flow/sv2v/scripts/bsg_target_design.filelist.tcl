# bsg_target_design.filelist.tcl
# Warning: do not print anything to stdout in this file!

# source target design's filelist and filelist_deltas
source $::env(DESIGN_DIR)/tcl/filelist.tcl

if { [file exists $::env(DESIGN_DIR)/tcl/hard/free_45/filelist_deltas.tcl] } {
  source $::env(DESIGN_DIR)/tcl/hard/free_45/filelist_deltas.tcl
} else {
  set HARD_SWAP_FILELIST [join ""]
  set NETLIST_SOURCE_FILES [join ""]
  set NEW_SVERILOG_SOURCE_FILES [join ""]
}

# get names of all modules to hard-swap
set hard_swap_module_list [list]
foreach f $HARD_SWAP_FILELIST {
  lappend hard_swap_module_list [file rootname [file tail $f]]
}

# generate a new list of source files while performing hard-swapping
set sverilog_source_files [list]
foreach f $SVERILOG_SOURCE_FILES {
  set module_name [file rootname [file tail $f]]
  set idx [lsearch $hard_swap_module_list $module_name]
  if {$idx == -1} {
    lappend sverilog_source_files $f
  } else {
    lappend sverilog_source_files [lindex $HARD_SWAP_FILELIST $idx]
  }
}

# finalized list of pre-synthesized source files
set final_netlist_source_files $NETLIST_SOURCE_FILES

# finalized list of source files that need synthesizing
set final_sverilog_source_files [concat $sverilog_source_files $NEW_SVERILOG_SOURCE_FILES]

# all source files (including pre-synthesized netlist files)
set all_final_source_files [concat $final_netlist_source_files $final_sverilog_source_files]

