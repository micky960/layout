#This is copied from template
setMultiCpu -localCpu 24
set design [getenv DESIGN]
source ../../../scripts/design.globals

init_design

floorplan \
	-r 1.0 0.7 6 6 6 6

saveDesign database/design.fplan.enc

set_interactive_constraint_modes design

addRing  \
	-skip_via_on_pin Standardcell   \
	-stacked_via_top_layer metal10  \
	-type core_rings                \
	-nets {VDD VSS}                 \
	-follow core                    \
	-stacked_via_bottom_layer metal1 \
	-layer {bottom metal9 top metal9 right metal10 left metal10} \
	-width 0.8                      \
	-spacing 0.8                   \
	-offset 0.095

setDesignMode \
	-process 45

globalNetConnect  VDD \
	-pin VDD \
	-type pgpin \
	-all

globalNetConnect  VSS \
	-pin VSS \
	-type pgpin \
	-all

#createBusGuide -netGroup netGroup1 -centerLine 4421.8 10749.36 4960.8 10749.36 -width 120 -layer METAL4:METAL8 

sroute \
	-connect { blockPin padPin padRing corePin floatingStripe } \
	-layerChangeRange { metal1 metal10 } \
	-blockPinTarget { nearestTarget } \
	-padPinPortConnect { allPort oneGeom } \
	-padPinTarget { nearestTarget } \
	-corePinTarget { firstAfterRowEnd } \
	-floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } \
	-allowJogging 1 \
	-crossoverViaLayerRange { metal1 metal10 } \
	-nets { VDD VSS } \
	-allowLayerChange 1 \
	-blockPin useLef \
	-targetViaLayerRange { metal1 metal10 }

saveDesign database/design.pplan.enc

setAnalysisMode \
	-cppr both \
	-clockGatingCheck true \
	-timeBorrowing true \
	-useOutputPinCap true \
	-sequentialConstProp false \
	-timingSelfLoopsNoSkew false \
	-enableMultipleDriveNet true \
	-clkSrcPath true \
	-warn true \
	-usefulSkew false \
	-analysisType onChipVariation \
	-log true

setEndCapMode \
	-reset

setEndCapMode \
	-boundary_tap false

setPlaceMode \
	-reset

setPlaceMode \
	-congEffort high \
	-timingDriven 1 \
	-modulePlan 1 \
	-clkGateAware 1 \
	-powerDriven 1 \
	-ignoreScan 1 \
	-reorderScan 1 \
	-ignoreSpare 1 \
	-placeIOPins 1 \
	-moduleAwareSpare 0 \
	-checkPinLayerForAccess {  1 } \
	-preserveRouting 0 \
	-rmAffectedRouting 0 \
	-checkRoute 0 \
	-swapEEQ 0

#set_dont_touch [get_cells u_*_buf_inst]
#set_dont_touch_network [get_pins u_*_buf_inst/*]
#source /home/projects/date_19/src/scripts/eco.tcl


place_opt_design

saveDesign database/design_place.enc

#setTieHiLoMode -cell {LOGIC1_X1 LOGIC0_X1} -prefix TIE_CELL
#addTieHiLo

checkPlace

#setAttribute -net *buf_key_logic* -bottom_preferred_routing_layer 9 -preferred_routing_layer_effort high

trialRoute \
	-maxRouteLayer 10

extractRC

timeDesign \
	-preCTS \
	-idealClock \
	-pathReports \
	-drvReports \
	-slackReports \
	-numPaths 50 \
	-prefix design_preCTS \
	-outDir rpts/timingReports


setNanoRouteMode \
	-quiet \
	-timingEngine {} \
	-routeWithSiPostRouteFix 0 \
	-drouteStartIteration default \
	-routeTopRoutingLayer default \
	-routeBottomRoutingLayer default \
	-drouteEndIteration default \
	-routeWithTimingDriven true \
	-routeWithSiDriven false 


#source ./inputs/nets.tcl
##setAttribute -net $net_list -bottom_preferred_routing_layer 8 -preferred_routing_layer_effort hard
#foreach el $net_list {
#	setAttribute -net $el -bottom_preferred_routing_layer 10 -preferred_routing_layer_effort hard
#
#}

#foreach_in_collection n [get_nets -filter "full_name =~ *buf_key_logic*"] {
	#set name [get_object_name $n]
	#setAttribute -net *buf_key_logic* -bottom_preferred_routing_layer 9 -preferred_routing_layer_effort high
#}
routeDesign \
	-globalDetail


#routeDesign \
#	-globalDetail

saveDesign database/design_route.enc

setDelayCalMode -SIAware false
optDesign -postRoute
extractRC
saveDesign database/design_postroute.enc


report_area > rpts/design_orig_area.rpt
report_power > rpts/design_orig_power.rpt
report_timing > rpts/design_orig_timing.rpt

get_metric design.util >> rpts/design_orig_metrics.rpt
get_metric place.totalNetLength >> rpts/design_orig_metrics.rpt
get_metric design.pinDensity >> rpts/design_orig_metrics.rpt
reportWire design_wirelen_via_orig -detail

set_global report_timing_format {instance pin cell net slew load delay arrival}
report_timing


global dbgLefDefOutVersion
set dbgLefDefOutVersion 5.8

defOut \
	-floorplan \
	-netlist \
	-routing outputs/design_orig.def

saveNetlist \
	-excludeLeafCell outputs/design_orig.v
report_area   > area.rpt
report_power  > power.rpt
report_timing > timing.rpt

get_metric design.util          > design_metrics.rpt
get_metric place.totalNetLength > net_length_metrics.rpt
get_metric design.pinDensity    > pin_density_metrics.rpt
reportWire                        via_wire.rpt -detail
verify_drc  -report               drc.rpt

exit

#source /home/projects/date_19/src/scripts/eco.tcl
#loadECO -postMask /home/projects/date_19/src/scripts/eco_$design.eco 
#selectNet eco*
#setNanoRouteMode -routeBottomRoutingLayer 9 -routeWithEco true -routeSelectedNetOnly true
#globalDetailRoute
#
#
#defOut \
#	-floorplan \
#	-netlist \
#	-routing outputs/design_eco.def
#
#saveNetlist \
#	-excludeLeafCell outputs/design_eco.v
#
#
#
######setNanoRouteMode  -routeWithEco true -routeSelectedNetOnly true
######ecoDefIn outputs/design_eco.def  -postMask  -reportFile ecoDefIn.rpt
######ecoRoute -modifyOnlyLayers 9:10 
