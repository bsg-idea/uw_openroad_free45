
#=================================================
# Open Design
#=================================================

proc open_design { v_or_def sdc {design_name ""} } {
  read_lef $::env(PDK_TECH_LEF_FILE)
  read_lef $::env(PDK_LEF_FILE)
  foreach lef_file [glob -nocomplain -directory $::env(FAKERAM_RUN_DIR) -- */*.lef] {
    read_lef $lef_file
  }
  read_liberty $::env(PDK_LIB_FILE)
  foreach lib_file [glob -nocomplain -directory $::env(FAKERAM_RUN_DIR) -- */*.lib] {
    read_liberty $lib_file
  }
  if { [file extension $v_or_def] == ".v" } {
    read_verilog $v_or_def
    link_design $design_name
  } else {
    read_def $v_or_def
  }
  read_sdc $sdc
}

#=================================================
# Has Macros
#=================================================

proc has_macros {} {
  foreach inst [[[[::ord::get_db] getChip] getBlock] getInsts] {
    if { [string match [[$inst getMaster] getType] "BLOCK"] } {
      return 1
    }
  }
  return 0
}

#=================================================
# Wrap-up
#=================================================

proc wrapup { p } {
  wrapup_reports $p
  wrapup_results $p
  exit
}

#=================================================
# Wrap-up Reports
#=================================================

proc wrapup_reports { p } {
  log_begin ./reports/$p.floating_nets.rpt;             report_floating_nets;                               log_end
  log_begin ./reports/$p.checks.rpt;                    report_checks;                                      log_end
  log_begin ./reports/$p.checks.min.rpt;                report_checks -path_delay min;                      log_end
  log_begin ./reports/$p.checks.max.rpt;                report_checks -path_delay max;                      log_end
  log_begin ./reports/$p.checks.unconstrained.rpt;      report_checks -unconstrained;                       log_end
  log_begin ./reports/$p.checks.max_trans.all_viol.rpt; report_check_types -max_transition -all_violators;  log_end
  log_begin ./reports/$p.power.rpt;                     report_power;                                       log_end
  log_begin ./reports/$p.tns.rpt;                       report_tns;                                         log_end
  log_begin ./reports/$p.wns.rpt;                       report_wns;                                         log_end
  log_begin ./reports/$p.design_area.rpt;               report_design_area;                                 log_end
}

#=================================================
# Wrap-up Results
#=================================================

proc wrapup_results { p } {
  write_def     ./results/$p.def
  write_verilog ./results/$p.v
  write_sdc     ./results/$p.sdc
}

#=================================================
# Log prefix
#=================================================

proc DEBUG {} {
  return "\[BSG-DEBUG\]"
}

proc INFO {} {
  return "\[BSG-INFO\]"
}

proc WARN {} {
  return "\[BSG-WARN\]"
}

proc ERROR {} {
  return "\[BSG-ERROR\]"
}

