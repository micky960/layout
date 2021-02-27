if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name fast\
   -timing\
    [list ${::IMEX::libVar}/mmmc/NangateOpenCellLibrary_fast_ccs.lib]
create_library_set -name slow\
   -timing\
    [list ${::IMEX::libVar}/mmmc/NangateOpenCellLibrary_slow_ccs.lib]
create_rc_corner -name default_rc_corner\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0
create_delay_corner -name slow_max\
   -library_set slow
create_delay_corner -name fast_min\
   -library_set fast
create_constraint_mode -name design\
   -sdc_files\
    [list ${::IMEX::libVar}/mmmc/design.sdc]
create_analysis_view -name design_fast_min -constraint_mode design -delay_corner fast_min
create_analysis_view -name design_slow_max -constraint_mode design -delay_corner slow_max
set_analysis_view -setup [list design_slow_max] -hold [list design_fast_min]
