# bsg_target_design.generage_flist.tcl

# Get the design's filelist and include directory list
source $::env(SV2V_FLOW_DIR)/scripts/bsg_target_design.filelist.tcl
source $::env(SV2V_FLOW_DIR)/scripts/bsg_target_design.include.tcl

# Output include directories
foreach i $final_sverilog_include_paths {
  puts "+incdir+$i"
}

# Output hdl files
foreach i $all_final_source_files {
  puts "$i"
}

