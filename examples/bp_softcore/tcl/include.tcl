#------------------------------------------------------------
# Do NOT arbitrarily change the order of files. Some module
# and macro definitions may be needed by the subsequent files
#------------------------------------------------------------

set BASEJUMP_STL_DIR  $::env(BASEJUMP_STL_DIR)
set BLACKPARROT_DIR   $::env(BLACKPARROT_DIR)

set BP_COMMON_DIR     $BLACKPARROT_DIR/bp_common
set BP_TOP_DIR        $BLACKPARROT_DIR/bp_top
set BP_FE_DIR         $BLACKPARROT_DIR/bp_fe
set BP_BE_DIR         $BLACKPARROT_DIR/bp_be
set BP_ME_DIR         $BLACKPARROT_DIR/bp_me

set SVERILOG_INCLUDE_PATHS [join "
  $BASEJUMP_STL_DIR/bsg_dataflow
  $BASEJUMP_STL_DIR/bsg_mem
  $BASEJUMP_STL_DIR/bsg_misc
  $BASEJUMP_STL_DIR/bsg_test
  $BASEJUMP_STL_DIR/bsg_noc
  $BP_COMMON_DIR/src/include
  $BP_FE_DIR/src/include
  $BP_BE_DIR/src/include
  $BP_BE_DIR/src/include/bp_be_dcache
  $BP_ME_DIR/src/include/v
  $BP_TOP_DIR/src/include
"]

