
source ../../../scripts/design.globals

init_design

floorplan \
	-r 1.0 0.3 4 4 4 4

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
#source <>
#foreach el $net_list {
#	setAttribute -net $el -bottom_preferred_routing_layer 5 -preferred_routing_layer_effort high
#
#}
#
set net_list {key_logic_0_14 key_logic_0_9 key_logic_0_39 key_logic_0_34 key_logic_0_26 key_logic_0_24 key_logic_0_56 key_logic_0_11 key_logic_0_67 key_logic_0_63 key_logic_0_0 key_logic_1_6 key_logic_0_71 key_logic_0_77 key_logic_1_8 key_logic_0_60 key_logic_0_17 key_logic_0_91 key_logic_0_27 key_logic_0_43 key_logic_1_1 key_logic_0_10 key_logic_0_25 key_logic_0_69 key_logic_0_59 key_logic_0_51 key_logic_0_21 key_logic_0_74 key_logic_0_58 key_logic_0_41 key_logic_0_7 key_logic_0_4 key_logic_1_5 key_logic_0_20 key_logic_0_32 key_logic_0_50 key_logic_1_16 key_logic_0_42 key_logic_0_15 key_logic_0_23 key_logic_0_22 key_logic_1_4 key_logic_0_6 key_logic_0_64 key_logic_0_57 key_logic_0_62 key_logic_0_73 key_logic_0_19 key_logic_0_5 key_logic_0_2 key_logic_0_61 key_logic_0_55 key_logic_0_54 key_logic_0_90 key_logic_1_31 key_logic_0_70 key_logic_0_18 key_logic_0_52 key_logic_0_46 key_logic_0_48 key_logic_0_49 key_logic_0_84 key_logic_0_82 key_logic_0_16 key_logic_1_3 key_logic_1_23 key_logic_1_26 key_logic_0_87 key_logic_0_88 key_logic_0_37 key_logic_0_36 key_logic_1_7 key_logic_1_2 key_logic_1_30 key_logic_1_12 key_logic_0_80 key_logic_0_81 key_logic_1_22 key_logic_0_83 key_logic_1_14 key_logic_0_76 key_logic_1_19 key_logic_1_18 key_logic_0_75 key_logic_1_27 key_logic_0_33 key_logic_0_29 key_logic_1_13 key_logic_0_68 key_logic_0_78 key_logic_1_10 key_logic_1_34 key_logic_1_33 key_logic_1_32 key_logic_1_21 key_logic_1_20 key_logic_1_9 key_logic_0_85 key_logic_1_24 key_logic_1_25 key_logic_0_38 key_logic_0_40 key_logic_0_72 key_logic_1_29 key_logic_1_28 key_logic_0_12 key_logic_0_66 key_logic_0_79 key_logic_0_86 key_logic_1_11 key_logic_0_1 key_logic_0_44 key_logic_0_45 key_logic_0_47 key_logic_0_53 key_logic_0_35 key_logic_0_65 key_logic_1_17 key_logic_0_28 key_logic_0_30 key_logic_0_31 key_logic_0_89 key_logic_0_13 key_logic_0_8 key_logic_1_0 key_logic_1_15 key_logic_0_3}
setAttribute -net $net_list  -bottom_preferred_routing_layer 8 -preferred_routing_layer_effort hard

set_dont_touch [get_cells UTIE*]
set_dont_touch_network [get_pins UTIE*_CELL*/*]

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
