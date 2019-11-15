yosys -import

# COMMON SETUP
set design_name  $::env(DESIGN_NAME)
set lib_file     $::env(LIB_FILE)
set clock_period $::env(CLOCK_PERIOD)
set clock_port   $::env(CLOCK_PORT)
set run_dir      $::env(SYNTH_RUN_DIR)
set in_v_file    $::env(SYNTH_YOSYS_IN_V)
set in_sdc_file  $::env(SYNTH_YOSYS_IN_SDC)
set out_v_file   $::env(SYNTH_YOSYS_OUT_V)

read_verilog $in_v_file
hierarchy -check -top $design_name
synth -top $design_name -flatten
opt -purge
techmap
dfflibmap -liberty $lib_file
opt

abc -D $clock_period   \
    -constr  $in_sdc_file \
    -liberty $lib_file \
    -showtmp           \
    -script [join "
      +read_constr,$in_sdc_file;
      strash;
      ifraig;
      retime,-D,{D},-M,6;
      strash;
      dch,-f;
      map,-p,-M,1,{D},-f;
      topo;
      dnsize;
      buffer,-p;
      upsize;
    "]

hilomap -hicell LOGIC1_X1 Z -locell LOGIC0_X1 Z
setundef -zero
splitnets
insbuf -buf BUF_X1 A Z
opt_clean -purge

tee -o $run_dir/reports/synth_check.txt check
tee -o $run_dir/reports/synth_stat.txt stat -liberty $lib_file
write_verilog -noattr -noexpr -nohex -nodec $out_v_file

