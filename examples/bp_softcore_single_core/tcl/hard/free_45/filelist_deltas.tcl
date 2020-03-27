#------------------------------------------------------------
# Do NOT arbitrarily change the order of files. Some module
# and macro definitions may be needed by the subsequent files
#------------------------------------------------------------

set DESIGN_DIR        $::env(DESIGN_DIR)
set BASEJUMP_STL_DIR  $::env(BASEJUMP_STL_DIR)
set BLACKPARROT_DIR   $::env(BLACKPARROT_DIR)

set BP_COMMON_DIR     $BLACKPARROT_DIR/bp_common
set BP_TOP_DIR        $BLACKPARROT_DIR/bp_top
set BP_FE_DIR         $BLACKPARROT_DIR/bp_fe
set BP_BE_DIR         $BLACKPARROT_DIR/bp_be
set BP_ME_DIR         $BLACKPARROT_DIR/bp_me

set HARD_SWAP_FILELIST [join "
  $DESIGN_DIR/v/hard/free_45/bsg_mem/bsg_mem_1rw_sync.v
  $DESIGN_DIR/v/hard/free_45/bsg_mem/bsg_mem_1rw_sync_mask_write_byte.v
  $DESIGN_DIR/v/hard/free_45/bsg_mem/bsg_mem_1rw_sync_mask_write_bit.v
"]

set NETLIST_SOURCE_FILES [join "
"]

set NEW_SVERILOG_SOURCE_FILES [join "
"]

