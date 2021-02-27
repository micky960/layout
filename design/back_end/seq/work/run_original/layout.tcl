
source ../../../scripts/design.globals

init_design

floorplan \
	-r 1.0 0.7 4 4 4 4

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


place_opt_design

setTieHiLoMode -cell {LOGIC1_X1 LOGIC0_X1} -prefix TIE_CELL
addTieHiLo

checkPlace

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

saveDesign database/design_place.enc

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

routeDesign \
	-globalDetail

saveDesign database/design_route.enc


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
