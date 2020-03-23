yosys -import

# Grab environment variables and paths
set DESIGN_NAME   $::env(DESIGN_NAME)
set V_FILE        $::env(SV2V_RUN_DIR)/results/${DESIGN_NAME}.v
set SDC_FILE      $::env(SV2V_RUN_DIR)/results/${DESIGN_NAME}.sdc
set LIB_FILE      $::env(PDKMOD_LIB_FILE)
set CLOCK_PERIOD  [expr $::env(CLOCK_PERIOD) * 1000]

# Run synthesis
read_verilog -sv ${V_FILE}
synth -top ${DESIGN_NAME} -flatten
opt -purge
dfflibmap -liberty ${LIB_FILE}
opt
abc -D ${CLOCK_PERIOD} -constr ${SDC_FILE} -liberty ${LIB_FILE} -script "+read_constr,${SDC_FILE};strash;ifraig;retime,-D,{D},-M,6;strash;dch,-f;map,-p,-M,1,{D},-f;topo;dnsize;buffer,-p;upsize;" -showtmp
hilomap -singleton -hicell LOGIC1_X1 Z -locell LOGIC0_X1 Z
setundef -zero
splitnets
insbuf -buf BUF_X1 A Z
opt_clean -purge

# Reports
tee -o reports/check.rpt check
tee -o reports/stats.rpt stat -liberty ${LIB_FILE}

# Results
write_verilog -noattr -noexpr -nohex -nodec results/synth.v
file copy ${SDC_FILE} results/synth.sdc

