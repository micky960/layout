#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Thu Mar  1 13:15:11 2018                
#                                                     
#######################################################

#@(#)CDS: Innovus v16.15-s078_1 (64bit) 02/24/2017 14:23 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute 16.15-s078_1 NR170210-1329/16_15-UB (database version 2.30, 373.6.1) {superthreading v1.33}
#@(#)CDS: AAE 16.15-s013 (64bit) 02/24/2017 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 16.15-s018_1 () Feb 24 2017 05:09:43 ( )
#@(#)CDS: SYNTECH 16.15-s004_1 () Jan 10 2017 07:20:10 ( )
#@(#)CDS: CPE v16.15-s060
#@(#)CDS: IQRC/TQRC 15.2.6-s621 (64bit) Thu Oct 27 23:06:47 PDT 2016 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getDrawView
loadWorkspace -name Physical
set defHierChar /
set init_design_settop 0
set init_pwr_net VDD
set init_gnd_net VSS
set init_lef_file /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/lef/sc9_cmos10lpe_base_hvt.lef
set init_mmmc_file ../../../scripts/design.view
set init_verilog inputs/design.v
set pegDefaultResScaleFactor 1.000000
set pegDetailResScaleFactor 1.000000
set timing_library_float_precision_tol 0.000010
init_design
win
