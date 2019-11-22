# bsg_target_design.include.tcl
# Warning: do not print anything to stdout in this file!

# source target design's include dirs
source $::env(DESIGN_DIR)/tcl/include.tcl

set final_sverilog_include_paths [list]
foreach incdir $SVERILOG_INCLUDE_PATHS {
  # replace 'portable' directories with the target process
  # TODO: for now, no replacements are done to the packaging directory
  #lappend final_sverilog_include_paths [regsub -all portable $incdir $::env(BSG_PACKAGING_FOUNDRY)]
  lappend final_sverilog_include_paths $incdir
}

# finalized list of include dirs
set final_sverilog_include_paths [join "$final_sverilog_include_paths"]

