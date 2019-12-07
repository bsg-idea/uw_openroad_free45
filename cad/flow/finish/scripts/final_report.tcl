set lib_file $::env(LIB_FILE)
set lef_file $::env(LEF_FILE)

read_liberty $lib_file
read_lef $lef_file
read_def $::env(FINISH_REPORT_IN_DEF)
read_sdc $::env(FINISH_REPORT_IN_SDC)

log_begin ../reports/final_report.rpt

report_checks -path_delay min
report_checks -path_delay max
report_checks -unconstrained

report_tns
report_wns

report_power

report_design_area

log_end

exit
