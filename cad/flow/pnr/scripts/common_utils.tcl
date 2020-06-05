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
# All Macros
#=================================================

proc all_macros {} {
  set all_macros [list]
  foreach inst [[[[::ord::get_db] getChip] getBlock] getInsts] {
    if { [string match [[$inst getMaster] getType] "BLOCK"] } {
      lappend all_macros $inst
    }
  }
  return $all_macros
}

#=================================================
# All Terms
#=================================================

proc all_terms {} {
  set all_terms [list]
  foreach inst [[[[::ord::get_db] getChip] getBlock] getBTerms] {
    lappend all_terms $inst
  }
  return $all_terms
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

proc DEBUG {{prefix BSG}} {
  return "\[$prefix-DEBUG\]"
}

proc INFO {{prefix BSG}} {
  return "\[$prefix-INFO\]"
}

proc WARN {{prefix BSG}} {
  return "\[$prefix-WARN\]"
}

proc ERROR {{prefix BSG}} {
  return "\[$prefix-ERROR\]"
}

#=================================================
# Greatest Common Denominator (GCD)
#=================================================

proc gcd { a b {places 3}} {
  set s_a [expr round($a *10**$places)]
  set s_b [expr round($b *10**$places)]
  set d 0
  while { ($s_a%2)==0 && ($s_b%2)==0 } {
    set s_a [expr $s_a/2]
    set s_b [expr $s_b/2]
    incr d
  }
  while { $s_a != $s_b } {
    if { $s_a%2 == 0 } {
      set s_a [expr $s_a/2]
    } elseif { $s_b % 2 == 0 } {
      set s_b [expr $s_b/2]
    } elseif { $s_a > $s_b } {
      set s_a [expr ($s_a-$s_b)/2]
    } else {
      set s_b [expr ($s_b-$s_a)/2]
    }
  }
  return [expr double($s_a * 2**$d) / 10**$places]
}

#=================================================
# Least Common Multiple (LCM)
#=================================================

proc lcm { a b {places 3} } {
  return [expr ($a * $b) / [gcd $a $b $places]]
}

#=================================================
# Round Up To Nearest Multiple
#=================================================

proc round_up_to_nearest { number round_target {places 3} } {
  set s_number       [expr double(round($number*(10**$places)))]
  set s_round_target [expr double(round($round_target*(10**$places)))]
  set s_number_round [expr ceil($s_number/$s_round_target)*$s_round_target]
  set number_round   [expr $s_number_round/(10**$places)]
  return $number_round
}

#=================================================
# Round Down To Nearest Multiple
#=================================================

proc round_down_to_nearest { number round_target {places 3} } {
  set s_number       [expr double(round($number*(10**$places)))]
  set s_round_target [expr double(round($round_target*(10**$places)))]
  set s_number_round [expr floor($s_number/$s_round_target)*$s_round_target]
  set number_round   [expr $s_number_round/(10**$places)]
  return $number_round
}

#=================================================
# Round To Nearest Multiple
#=================================================

proc round_to_nearest { number round_target {places 3} } {
  set s_number       [expr double(round($number*(10**$places)))]
  set s_round_target [expr double(round($round_target*(10**$places)))]
  set s_number_round [expr round($s_number/$s_round_target)*$s_round_target]
  set number_round   [expr $s_number_round/(10**$places)]
  return $number_round
}

#=====================================================================
# IDF Procedures
#=====================================================================

set __idf_dict {}

#=================================================
# IDF Read
#=================================================

proc idf_read { idf_filename } {
  # Ideally, we would add the tcllib to the TCLLIBPATH environment variable or
  # the auto_path variable however that doesn't seem to work with the OpenROAD
  # tcl interpeter (there are errors reading the index pkg file). Thankfully,
  # the json read is simply enough that just sourcing the script seems to work
  # for what we need to do.
  set tcllib_json [glob -nocomplain "/usr/share/tcl8.*/tcllib-*/json/json.tcl"]
  if {$tcllib_json != ""} {
    source $tcllib_json
  } else {
    puts "[ERROR IDF] failed to load idf file (could not find tcllib json package)."
    return 1
  }

  if { [file exists $idf_filename] } {
    set fid [open $idf_filename r]
    set ::__idf_dict [::json::json2dict [read $fid]]
    close $fid
  } else {
    puts "[ERROR IDF] failed to load idf file (could not find idf file \"$idf_filename\")."
    return 1
  }

  return 0
}

#=================================================
# IDF Initialize Floorplan
#=================================================

proc idf_init_floorplan {} {
  if {$::__idf_dict == {}} {
    puts "[ERROR IDF] failed to perform idf floorplan initialization (idf not loaded, use \"idf_read <file>\" to load idf file first)."
    return 1
  }

  set cpp          $::env(PDK_CPP)
  set track_height $::env(PDK_TRACK_HEIGHT)
  puts "[INFO IDF] using cpp=$cpp"
  puts "[INFO IDF] using track height=$track_height"

  set die_llx [round_to_nearest [expr [dict get $::__idf_dict area die llx] * $cpp] 0.19]
  set die_lly [round_to_nearest [expr [dict get $::__idf_dict area die lly] * $track_height] 1.4]
  set die_urx [round_to_nearest [expr [dict get $::__idf_dict area die urx] * $cpp] 0.19]
  set die_ury [round_to_nearest [expr [dict get $::__idf_dict area die ury] * $track_height] 1.4]
  set die_area "$die_llx $die_lly $die_urx $die_ury"

  set core_llx [round_to_nearest [expr [dict get $::__idf_dict area core llx] * $cpp] 0.19]
  set core_lly [round_to_nearest [expr [dict get $::__idf_dict area core lly] * $track_height] 1.4]
  set core_urx [round_to_nearest [expr [dict get $::__idf_dict area core urx] * $cpp] 0.19]
  set core_ury [round_to_nearest [expr [dict get $::__idf_dict area core ury] * $track_height] 1.4]
  set core_area "$core_llx $core_lly $core_urx $core_ury"

  puts "[INFO IDF] Initializing floorplan (die_area={$die_area}, core_area={$core_area})."
  initialize_floorplan \
    -die_area $die_area \
    -core_area $core_area \
    -tracks $::env(TRACKS_INFO_FILE) \
    -site FreePDK45_38x28_10R_NP_162NW_34O
}

#=================================================
# IDF Place Ports
#=================================================

proc idf_place_ports {} {
  if {$::__idf_dict == {}} {
    puts "[ERROR IDF] failed to perform idf floorplan initialization (idf not loaded, use \"idf_read <file>\" to load idf file first)."
    return 1
  }

  set cpp          $::env(PDK_CPP)
  set track_height $::env(PDK_TRACK_HEIGHT)
  puts "[INFO IDF] using cpp=$cpp"
  puts "[INFO IDF] using track height=$track_height"

  set design_constraints {}
  foreach constr [dict get $::__idf_dict designs] {
    if {[dict get $constr name] == $::env(DESIGN_NAME)} {
      set design_constraints $constr
      break
    }
  }

  if {$design_constraints != {}} {
    puts "[INFO IDF] found constraints for current design \"$::env(DESIGN_NAME)\"."
  } else {
    puts "[WARN IDF] no constraints found for design \"$::env(DESIGN_NAME)\"."
    return 0
  }

  foreach constraint [dict get $design_constraints io_ports] {
    set name [dict get $constraint name]
    set x    [round_to_nearest [expr [dict get $constraint x] * $cpp] 0.19]
    set y    [round_to_nearest [expr [dict get $constraint y] * $track_height] 1.4]
    set side [dict get $constraint side]
    #set layer
  }

}

#=================================================
# IDF Place Macros
#=================================================

proc idf_place_macros {} {
  if {$::__idf_dict == {}} {
    puts "[ERROR IDF] failed to perform idf floorplan initialization (idf not loaded, use \"idf_read <file>\" to load idf file first)."
    return 1
  }

  set cpp          $::env(PDK_CPP)
  set track_height $::env(PDK_TRACK_HEIGHT)
  puts "[INFO IDF] using cpp=$cpp"
  puts "[INFO IDF] using track height=$track_height"

  set macros [all_macros]
  puts "[INFO IDF] design contains \"[llength $macros]\" macros."

  if { [llength $macros] == 0 } {
    puts "[INFO IDF] no macros found, skipping macro placement."
    return 0
  }

  set design_constraints {}
  foreach constr [dict get $::__idf_dict designs] {
    if {[dict get $constr name] == $::env(DESIGN_NAME)} {
      set design_constraints $constr
      break
    }
  }

  if {$design_constraints != {}} {
    puts "[INFO IDF] found constraints for current design \"$::env(DESIGN_NAME)\"."
  } else {
    puts "[WARN IDF] no constraints found for design \"$::env(DESIGN_NAME)\"."
    return 0
  }

  foreach constraint [dict get $design_constraints place] {
    set name [regsub -all {/} [dict get $constraint name] {.}]
    set x [round_to_nearest [expr [dict get $constraint x] * $cpp] 0.19]
    set y [round_to_nearest [expr [dict get $constraint y] * $track_height] 1.4]
    set orientation [dict get $constraint orientation]

    set inst {}
    foreach m $macros {
      if {[$m getName] == $name} {
        set inst $m
        break
      }
    }

    if {$inst != {}} {
      puts "[INFO IDF] placing \"$name\" at ($x, $y) with \"$orientation\" orientation."
      $m setLocation [expr int($x*2000)] [expr int($y*2000)]
      if {$orientation == "N"} {
        $m setLocationOrient R0
      } elseif {$orientation == "E"} {
        $m setLocationOrient R90
      } elseif {$orientation == "S"} {
        $m setLocationOrient R180
      } elseif {$orientation == "W"} {
        $m setLocationOrient R270
      } elseif {$orientation == "FN"} {
        $m setLocationOrient MY
      } elseif {$orientation == "FE"} {
        $m setLocationOrient MYR90
      } elseif {$orientation == "FS"} {
        $m setLocationOrient RX
      } elseif {$orientation == "FW"} {
        $m setLocationOrient RXR90
      } else {
        puts "[ERROR IDF] macro placement failed (unknown orientation \"$orientation\")."
        return 1
      }
      $m setPlacementStatus LOCKED
    } else {
      puts "[ERROR IDF] macro placement failed (could not find macro \"$name\")."
      return 1
    }
  }

  return 0
}

#=================================================
# IDF Relative Metal to Metal String
#=================================================

proc idf_rel_metal_to_metal { rel_metal } {
  switch $rel_metal {
    metal-B1    { return metal1  }
    metal-B2    { return metal2  }
    metal-B3    { return metal3  }
    metal-B4    { return metal4  }
    metal-B5    { return metal5  }
    metal-B6    { return metal6  }
    metal-B7    { return metal7  }
    metal-B8    { return metal8  }
    metal-B9    { return metal9  }
    metal-B10   { return metal10 }
    metal-T1    { return metal10 }
    metal-T2    { return metal9  }
    metal-T3    { return metal8  }
    metal-T4    { return metal7  }
    metal-T5    { return metal6  }
    metal-T6    { return metal5  }
    metal-T7    { return metal4  }
    metal-T8    { return metal3  }
    metal-T9    { return metal2  }
    metal-T10   { return metal1  }
    metal-BV1   { return metal1  }
    metal-BH1   { return metal2  }
    metal-BV2   { return metal3  }
    metal-BH2   { return metal4  }
    metal-BV3   { return metal5  }
    metal-BH3   { return metal6  }
    metal-BV4   { return metal7  }
    metal-BH4   { return metal8  }
    metal-BV5   { return metal9  }
    metal-BH5   { return metal10 }
    metal-TH1   { return metal10 }
    metal-TV1   { return metal9  }
    metal-TH2   { return metal8  }
    metal-TV2   { return metal7  }
    metal-TH3   { return metal6  }
    metal-TV3   { return metal5  }
    metal-TH4   { return metal4  }
    metal-TV4   { return metal3  }
    metal-TH5   { return metal2  }
    metal-TV5   { return metal1  }
    default {
      puts "[ERROR IDF] unknown relative metal name \"$rel_metal\"."
      return ""
    }
  }
}

