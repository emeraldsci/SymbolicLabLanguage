(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*plotObject input patterns*)

(* ::Subsubsection::Closed:: *)
(*Object[Data,AlphaScreen]*)

(*Object[Data,AbsorbanceSpectroscopy*)
(* not allow nested lists *)
(*plotInputPattern[Object[Data,type:AbsorbanceSpectroscopy]] := {ObjectP[Object[Data,type]]..}*)

plotInputPattern[Object[Data,type:(AlphaScreen)]] := Alternatives[
	ObjectP[Object[Data,type]],
	{ObjectP[Object[Data,type]]..},
	{{ObjectP[Object[Data,type]]..}..}
]


(* ::Subsubsection::Closed:: *)
(*Object[Data,Volume]*)

plotInputPattern[Object[Data,type:Volume]] := Alternatives[
	{ObjectP[Object[Data,type]]..},
	{{ObjectP[Object[Data,type]]..}..}
]

(* ::Subsubsection::Closed:: *)
(*Object[Data,FluorescenceIntensity]*)

plotInputPattern[Object[Data,type:FluorescenceIntensity]] := Alternatives[
	ObjectP[Object[Data,type]],
	{ObjectP[Object[Data,type]]..},
	{{ObjectP[Object[Data,type]]..}..}
]


(* ::Subsubsection::Closed:: *)
(*Object[Data,FluorescenceThermodynamics]*)


plotInputPattern[Object[Data,type:(FluorescenceThermodynamics)]]:=Alternatives[
	{{{ObjectP[Object[Data,type]]..}..}..},
	{{ObjectP[Object[Data,type]]..}..},
	{ObjectP[Object[Data,type]]..},
	ObjectP[Object[Data,type]]
]


(* ::Subsubsection::Closed:: *)
(* Simple listable *)


plotInputPattern[Object[Data,type:(qPCR|RamanSpectroscopy|ChromatographyMassSpectra|NMR2D)]]:=Alternatives[
	ObjectP[Object[Data,type]],
	{ObjectP[Object[Data,type]]..}
];



(* ::Subsubsection::Closed:: *)
(*other*)


plotInputPattern[type:TypeP[]]:=Alternatives[
	ObjectP[type],
	{ObjectP[type]..},
	{{ObjectP[type]..}..}
];


(* ::Subsection:: *)
(*plotObject redirects*)


(* ::Subsubsection:: *)
(*Object[Data,AbsorbanceKinetics]*)


(* Chromatography *)
plotObject[in:plotInputPattern[Object[Data,AbsorbanceKinetics]],ops:OptionsPattern[PlotAbsorbanceKinetics]]:=PlotAbsorbanceKinetics[in,ops];

plotObject[AbsorbanceKinetics,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotAbsorbanceKinetics]]:=PlotAbsorbanceKinetics[xy,ops];


(* ::Subsubsection:: *)
(*Object[Data, CyclicVoltammetry]*)


(* CyclicVoltammetry *)
plotObject[in: plotInputPattern[Object[Data, CyclicVoltammetry]], ops: OptionsPattern[PlotCyclicVoltammetry]] :=
	PlotCyclicVoltammetry[in,ops];


(* ::Subsubsection:: *)
(*Object[Data, IRSpectroscopy]*)


(* IR *)
plotObject[in:plotInputPattern[Object[Data,IRSpectroscopy]],ops:OptionsPattern[PlotIRSpectroscopy]]:=
		PlotIRSpectroscopy[in,ops];
plotObject[IR,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotIRSpectroscopy]]:=
		PlotIRSpectroscopy[xy,ops];

(* ::Subsubsection:: *)
(*Object[Data, MeltingPoint]*)

(* MeasureMeltingPoint *)
plotObject[in:plotInputPattern[Object[Data,MeltingPoint]],ops:OptionsPattern[PlotMeasureMeltingPoint]]:=
	PlotMeasureMeltingPoint[in,ops];


(* ::Subsubsection:: *)
(*Object[Data,Western]*)


plotObject[in:plotInputPattern[Object[Data,Western]],ops:OptionsPattern[PlotWestern]]:=
		PlotWestern[in,ops]
plotObject[Western,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotWestern]]:=
		PlotWestern[xy,ops]



(* ::Subsubsection:: *)
(*Object[Data,AgaroseGelElectrophoresis]*)


plotObject[in:plotInputPattern[Object[Data,AgaroseGelElectrophoresis]],ops:OptionsPattern[PlotAgarose]]:=
		PlotAgarose[in,ops]
plotObject[AgaroseGelElectrophoresis,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotAgarose]]:=
		PlotAgarose[xy,ops]

(* ::Subsubsection:: *)
(*Object[Data,CapillaryGelElectrophoresisSDS]*)


plotObject[in:plotInputPattern[Object[Data,CapillaryGelElectrophoresisSDS]],ops:OptionsPattern[PlotCapillaryGelElectrophoresisSDS]]:=PlotCapillaryGelElectrophoresisSDS[in,ops];


(* ::Subsubsection:: *)
(*Object[Data,CapillaryIsoelectricFocusing]*)


plotObject[in:plotInputPattern[Object[Data,CapillaryIsoelectricFocusing]],ops:OptionsPattern[PlotCapillaryIsoelectricFocusing]]:=PlotCapillaryIsoelectricFocusing[in,ops];


(* ::Subsubsection:: *)
(*Object[Data,Chromatography]*)


(* Chromatography *)
plotObject[in:plotInputPattern[Object[Data,Chromatography]],ops:OptionsPattern[PlotChromatography]]:=PlotChromatography[in,ops];
plotObject[Chromatography,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotChromatography]]:=PlotChromatography[xy,ops];



(* ::Subsubsection:: *)
(*Object[Data,ChromatographyMassSpectra]*)


plotObject[in:plotInputPattern[Object[Data,ChromatographyMassSpectra]],ops:OptionsPattern[PlotChromatographyMassSpectra]]:=PlotChromatographyMassSpectra[in,ops];


(* ::Subsubsection:: *)
(*Object[Data,CrossFlowFiltration]*)


plotObject[in:ObjectP[Object[Data,CrossFlowFiltration]],ops:OptionsPattern[PlotCrossFlowFiltration]]:=PlotCrossFlowFiltration[in,ops];
plotObject[in:{ObjectP[Object[Data,CrossFlowFiltration]]..},ops:OptionsPattern[PlotCrossFlowFiltration]]:=PlotCrossFlowFiltration[#,ops]&/@in;


(* ::Subsubsection:: *)
(*Object[Data, DifferentialScanningCalorimetry*)


plotObject[myDataObject:plotInputPattern[Object[Data,DifferentialScanningCalorimetry]], ops:OptionsPattern[PlotDifferentialScanningCalorimetry]]:=PlotDifferentialScanningCalorimetry[myDataObject, ops];



(* ::Subsubsection:: *)
(*Object[Data,DynamicLightScattering]*)


plotObject[in:plotInputPattern[Object[Data,DynamicLightScattering]],ops:OptionsPattern[PlotDynamicLightScattering]]:=
		PlotDynamicLightScattering[in,ops]
plotObject[DynamicLightScattering,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotDynamicLightScattering]]:=
		PlotDynamicLightScattering[xy,ops]


(* ::Subsubsection:: *)
(*Object[Data, ELISA]*)


plotObject[myDataObject:plotInputPattern[Object[Data,ELISA]], ops:OptionsPattern[PlotELISA]]:=PlotELISA[myDataObject, ops];


(* ::Subsubsection:: *)
(*Object[Data,FragmentAnalysis]*)


plotObject[in:plotInputPattern[Object[Data,FragmentAnalysis]],ops:OptionsPattern[PlotFragmentAnalysis]]:=
	PlotFragmentAnalysis[in,ops]
plotObject[FragmentAnalysis,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotFragmentAnalysis]]:=
	PlotFragmentAnalysis[xy,ops]

(* ::Subsubsection:: *)
(*Object[Data,FreezeCells]*)


plotObject[in:ObjectP[Object[Data,FreezeCells]],ops:OptionsPattern[PlotFreezeCells]]:=PlotFreezeCells[in,ops];

(* ::Subsubsection:: *)
(* Object[Data, ICPMS] *)

plotObject[in: plotInputPattern[Object[Data, ICPMS]], ops: OptionsPattern[PlotICPMS]] := PlotICPMS[in, ops];


(* ::Subsubsection:: *)
(*Object[Data,AbsorbanceSpectroscopy]*)

(* single data or list of data case *)
plotObject[in:ObjectP[Object[Data,AbsorbanceSpectroscopy]]|{ObjectP[Object[Data,AbsorbanceSpectroscopy]]..},ops:OptionsPattern[PlotAbsorbanceSpectroscopy]]:=PlotAbsorbanceSpectroscopy[in,ops]

(* nested list of input case *)
plotObject[in:{{ObjectP[Object[Data,AbsorbanceSpectroscopy]]..}..},ops:OptionsPattern[PlotAbsorbanceSpectroscopy]]:=
    Module[{spectra, shapedSpectra, numberOfPartitions, partitionLengths, legends},

		numberOfPartitions=Dimensions[in][[1]];
		partitionLengths=Length/@in;

		(* flatten input list so we can batch download all data at once *)
		spectra=Download[Flatten[in], AbsorbanceSpectrum];

		(* then reshape data back to the original shape *)
		shapedSpectra=TakeList[spectra, partitionLengths];

		(* create legends for each group of data, pick the middle position in each group to get separate color for groups. set all other legends to Null *)
		legends=Map[Join[
			ConstantArray[Null,Floor[partitionLengths[[#]]/2]],
			{"Group "<>ToString[#]},
			ConstantArray[Null,Ceiling[partitionLengths[[#]]/2-1]]
		]&,Range[numberOfPartitions]];

		PlotObject[shapedSpectra,ops,Legend->legends]
]

plotObject[in1:plotInputPattern[Object[Data,AbsorbanceSpectroscopy]],in2:plotInputPattern[Object[Data,AbsorbanceSpectroscopy]],ops:OptionsPattern[PlotAbsorbanceSpectroscopy]]:=
		PlotAbsorbanceSpectroscopy[in1,in2,ops]
plotObject[AbsorbanceSpectroscopy,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotAbsorbanceSpectroscopy]]:=
		PlotAbsorbanceSpectroscopy[xy,ops]


(* ::Subsubsection:: *)
(*Object[Data,MeltingCurve]*)


(* AbsorbanceThermodynamics *)
plotObject[in:plotInputPattern[Object[Data,MeltingCurve]],ops:OptionsPattern[PlotAbsorbanceThermodynamics]]:=
		PlotAbsorbanceThermodynamics[in,ops]
plotObject[AbsorbanceThermodynamics,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotAbsorbanceThermodynamics]]:=
		PlotAbsorbanceThermodynamics[xy,ops]


(* ::Subsubsection:: *)
(*Object[Data,NMR]*)


(* NMR *)
plotObject[in:plotInputPattern[Object[Data,NMR]],ops:OptionsPattern[PlotNMR]]:=
		PlotNMR[in,ops]
plotObject[NMR,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotNMR]]:=
		PlotNMR[xy,ops]


(* ::Subsubsection:: *)
(*Object[Data, NMR2D]*)


(* NMR2D *)
plotObject[in:plotInputPattern[Object[Data,NMR2D]],ops:OptionsPattern[NMR2D]]:=PlotNMR2D[in, ops];


(* ::Subsubsection:: *)
(*Object[Data,MassSpectrometry]*)


(* MassSpectrometry *)
plotObject[in:plotInputPattern[Object[Data,MassSpectrometry]],ops:OptionsPattern[PlotMassSpectrometry]]:=
		PlotMassSpectrometry[in,ops]
plotObject[MassSpectrometry,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotMassSpectrometry]]:=
		PlotMassSpectrometry[xy,ops]



(* ::Subsubsection:: *)
(*Object[Data,CircularDichroism]*)

plotObject[in:plotInputPattern[Object[Data,CircularDichroism]],ops:OptionsPattern[PlotCircularDichroism]]:=
	PlotCircularDichroism[in,ops]
plotObject[CircularDichroism,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotCircularDichroism]]:=
	PlotCircularDichroism[xy,ops]



(* ::Subsubsection:: *)
(*Object[Data, CoulterCount]*)


plotObject[in:plotInputPattern[Object[Data, CoulterCount]], ops:OptionsPattern[PlotCoulterCount]] := PlotCoulterCount[in, ops]



(* ::Subsubsection::Closed:: *)
(*Object[Data,AlphaScreen]*)


plotObject[in:plotInputPattern[Object[Data,AlphaScreen]],ops:OptionsPattern[PlotAlphaScreen]]:=
	PlotAlphaScreen[in,ops]

plotObject[in:Alternatives[
	PatternSequence[ObjectP[Object[Data,AlphaScreen]]],
	PatternSequence[{ObjectP[Object[Data,AlphaScreen]]..},{ObjectP[Object[Data,AlphaScreen]]..}],
	PatternSequence[{{ObjectP[Object[Data,AlphaScreen]]..}..},{{ObjectP[Object[Data,AlphaScreen]]..}..}]
],ops:OptionsPattern[PlotAlphaScreen]]:=PlotAlphaScreen[in,ops]



plotObject[AlphaScreen,inten:({_?NumericQ..}|{_?(UnitsQ[#,RLU]&)..}|{{_?NumericQ..}..}|{{_?(UnitsQ[#,RLU]&)..}..}),ops:OptionsPattern[PlotAlphaScreen]]:=
	PlotAlphaScreen[inten,ops]

plotObject[AlphaScreen,in:Alternatives[
	PatternSequence[{_?NumericQ..},{_?NumericQ..}],
	PatternSequence[{_?(UnitsQ[#,RLU]&)..},{_?(UnitsQ[#,RLU]&)..}],
	PatternSequence[{{_?NumericQ..}..},{{_?NumericQ..}..}],
	PatternSequence[{{_?(UnitsQ[#,RLU]&)..}..},{{_?(UnitsQ[#,RLU]&)..}..}]
],ops:OptionsPattern[PlotAlphaScreen]]:=PlotAlphaScreen[in,ops]


(* ::Subsubsection::Closed:: *)
(*Object[Data,FluorescenceIntensity]*)


plotObject[in:plotInputPattern[Object[Data,FluorescenceIntensity]],ops:OptionsPattern[PlotFluorescenceIntensity]]:=
		PlotFluorescenceIntensity[in,ops]

plotObject[in:Alternatives[
	PatternSequence[{ObjectP[Object[Data,FluorescenceIntensity]]..},{ObjectP[Object[Data,FluorescenceIntensity]]..}],
	PatternSequence[{{ObjectP[Object[Data,FluorescenceIntensity]]..}..},{{ObjectP[Object[Data,FluorescenceIntensity]]..}..}]
],ops:OptionsPattern[PlotFluorescenceIntensity]]:=	PlotFluorescenceIntensity[in,ops]



plotObject[FluorescenceIntensity,inten:({_?NumericQ..}|{_?FluorescenceQ..}|{{_?NumericQ..}..}|{{_?FluorescenceQ..}..}),ops:OptionsPattern[PlotFluorescenceIntensity]]:=
		PlotFluorescenceIntensity[inten,ops]

plotObject[FluorescenceIntensity,in:Alternatives[
	PatternSequence[{_?NumericQ..},{_?NumericQ..}],
	PatternSequence[{_?FluorescenceQ..},{_?FluorescenceQ..}],
	PatternSequence[{{_?NumericQ..}..},{{_?NumericQ..}..}],
	PatternSequence[{{_?FluorescenceQ..}..},{{_?FluorescenceQ..}..}]
],ops:OptionsPattern[PlotFluorescenceIntensity]]:=	PlotFluorescenceIntensity[in,ops]




(* ::Subsubsection:: *)
(*Object[Data,FluorescenceThermodynamics]*)


plotObject[in:plotInputPattern[Object[Data,FluorescenceThermodynamics]],ops:OptionsPattern[PlotFluorescenceThermodynamics]]:=
		PlotFluorescenceThermodynamics[in,ops]
plotObject[FluorescenceThermodynamics,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP...}...}|{{{CoordinatesP...}...}...}),ops:OptionsPattern[PlotFluorescenceThermodynamics]]:=
		PlotFluorescenceThermodynamics[xy,ops]



(* ::Subsubsection:: *)
(*Object[Data,FluorescenceKinetics]*)


(* Fluorescence Kinetics  *)
plotObject[in:plotInputPattern[Object[Data,FluorescenceKinetics]],ops:OptionsPattern[PlotFluorescenceKinetics]]:=
		PlotFluorescenceKinetics[in,ops]
plotObject[FluorescenceKinetics,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotFluorescenceKinetics]]:=
		PlotFluorescenceKinetics[xy,ops]


(* ::Subsubsection:: *)
(*Object[Data, FluorescencePolarization]*)

(* Fluorescence Kinetics  *)
plotObject[in: plotInputPattern[Object[Data, FluorescencePolarization]], ops: OptionsPattern[PlotFluorescencePolarization]]:=
	PlotFluorescencePolarization[in, ops]


(* ::Subsubsection:: *)
(*Object[Data, FluorescencePolarizationKinetics]*)

(* Fluorescence Kinetics  *)
plotObject[in: plotInputPattern[Object[Data, FluorescencePolarizationKinetics]], ops: OptionsPattern[PlotFluorescencePolarizationKinetics]]:=
	PlotFluorescencePolarizationKinetics[in, ops]


(* ::Subsubsection:: *)
(*Object[Data,FluorescenceSpectroscopy]*)


(* FluorescenceSpectroscopy *)
plotObject[in:plotInputPattern[Object[Data,FluorescenceSpectroscopy]],ops:OptionsPattern[PlotFluorescenceSpectroscopy]]:=
		PlotFluorescenceSpectroscopy[in,ops]
plotObject[FluorescenceSpectroscopy,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotFluorescenceSpectroscopy]]:=
		PlotFluorescenceSpectroscopy[xy,ops]


(* ::Subsubsection:: *)
(*Object[Data,LuminescenceKinetics]*)


(* Luminescence Kinetics  *)
plotObject[in:plotInputPattern[Object[Data,LuminescenceKinetics]],ops:OptionsPattern[PlotLuminescenceKinetics]]:=
	PlotLuminescenceKinetics[in,ops]
plotObject[LuminescenceKinetics,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotLuminescenceKinetics]]:=
	PlotLuminescenceKinetics[xy,ops]


(* ::Subsubsection:: *)
(*Object[Data,LuminescenceSpectroscopy]*)


(* LuminescenceSpectroscopy *)
plotObject[in:plotInputPattern[Object[Data,LuminescenceSpectroscopy]],ops:OptionsPattern[PlotLuminescenceSpectroscopy]]:=
	PlotLuminescenceSpectroscopy[in,ops]
plotObject[LuminescenceSpectroscopy,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotLuminescenceSpectroscopy]]:=
	PlotLuminescenceSpectroscopy[xy,ops]


(* ::Subsubsection:: *)
(*Object[Data,Nephelometry]*)

(* Nephelometry *)
plotObject[in:plotInputPattern[Object[Data,Nephelometry]],ops:OptionsPattern[PlotNephelometry]]:=PlotNephelometry[in,ops];


(* ::Subsubsection:: *)
(*Object[Data,NephelometryKinetics]*)

(* Nephelometry *)
plotObject[in:plotInputPattern[Object[Data,NephelometryKinetics]],ops:OptionsPattern[PlotNephelometryKinetics]]:=PlotNephelometryKinetics[in,ops];




(* ::Subsubsection:: *)
(*Object[Data,VacuumEvaporation]*)


plotObject[appData:ObjectP[Object[Data,VacuumEvaporation]], ops:OptionsPattern[PlotVacuumEvaporation]] := PlotVacuumEvaporation[appData, ops]


(* ::Subsubsection:: *)
(*Object[Data,Microscope]*)


(* Microscope *)
plotObject[in:ListableP[ObjectReferenceP[Object[Data,Microscope]]],ops:OptionsPattern[]]:=plotObject[Download[in],ops];
plotObject[in:ListableP[PacketP[Object[Data,Microscope]]],ops:OptionsPattern[]]:=PlotMicroscope[in,ops];
plotObject[Microscope,in:(_Graphics|_Image),ops:OptionsPattern[PlotMicroscope]]:=PlotMicroscope[in,ops]


(* ::Subsubsection:: *)
(*Object[Data,PAGE]*)


(* PAGE *)
plotObject[in:plotInputPattern[Object[Data,PAGE]],ops:OptionsPattern[PlotPAGE]]:=PlotPAGE[in,ops]
plotObject[PAGE,in:(_Graphics|_Image),ops:OptionsPattern[PlotPAGE]]:=PlotPAGE[in,ops]



(* ::Subsubsection:: *)
(*Object[Data,TLC]*)


plotObject[in:plotInputPattern[Object[Data,TLC]],ops:OptionsPattern[PlotPAGE]]:=PlotTLC[in,ops]
plotObject[TLC,in:(_Graphics|_Image),ops:OptionsPattern[PlotPAGE]]:=PlotTLC[in,ops]


(* ::Subsubsection:: *)
(*Object[Data,qPCR]*)


plotObject[in:plotInputPattern[Object[Data,qPCR]],ops:OptionsPattern[PlotqPCR]]:=PlotqPCR[in,ops]


(* ::Subsubsection:: *)
(*Object[Data,DigitalPCR]*)


plotObject[in:plotInputPattern[Object[Data,DigitalPCR]],ops:OptionsPattern[PlotDigitalPCR]]:=PlotDigitalPCR[in,ops]


(* ::Subsubsection:: *)
(*Object[Data,DynamicFoamAnalysis]*)


plotObject[in:plotInputPattern[Object[Data,DynamicFoamAnalysis]],ops:OptionsPattern[PlotDynamicFoamAnalysis]]:=PlotDynamicFoamAnalysis[in,ops]


(* ::Subsubsection:: *)
(*Object[Data,RamanSpectroscopy]*)


plotObject[in:plotInputPattern[Object[Data,RamanSpectroscopy]],ops:OptionsPattern[PlotRamanSpectroscopy]]:=PlotRamanSpectroscopy[in,ops];


(* ::Subsubsection:: *)
(*Object[Data,Volume]*)


plotObject[in:plotInputPattern[Object[Data,Volume]],ops:OptionsPattern[PlotVolume]]:=
		PlotVolume[in,ops]

plotObject[in:Alternatives[
	PatternSequence[{ObjectP[Object[Data,Volume]]..},{ObjectP[Object[Data,Volume]]..}],
	PatternSequence[{{ObjectP[Object[Data,Volume]]..}..},{{ObjectP[Object[Data,Volume]]..}..}]
],ops:OptionsPattern[PlotVolume]]:=	PlotVolume[in,ops]



(* ::Subsubsection:: *)
(*Object[Data,BioLayerInterferometry]*)


plotObject[
	in:(ObjectP[Object[Data, BioLayerInterferometry]]|{ObjectP[Object[Data, BioLayerInterferometry]]..}),
	ops:OptionsPattern[PlotBioLayerInterferometry]
]:= PlotBioLayerInterferometry[in, ops];


(* ::Subsubsection:: *)
(*Object[Data,Temperature] & Object[Data, RelativeHumidity]*)


(* Environmental Data  *)
plotObject[in:plotInputPattern[Object[Data,Temperature]],opts:OptionsPattern[PlotSensor]]:=
		PlotSensor[in,opts]


plotObject[in:plotInputPattern[Object[Data,RelativeHumidity]],opts:OptionsPattern[PlotSensor]]:=
		PlotSensor[in,opts]



plotObject[Volume,inten:({_?NumericQ..}|{_?DistanceQ..}|{{_?NumericQ..}..}|{{_?DistanceQ..}..}),ops:OptionsPattern[PlotFluorescenceIntensity]]:=
		PlotVolume[inten,ops]

plotObject[Volume,in:Alternatives[
	PatternSequence[{_?NumericQ..},{_?NumericQ..}],
	PatternSequence[{_?DistanceQ..},{_?DistanceQ..}],
	PatternSequence[{{_?NumericQ..}..},{{_?NumericQ..}..}],
	PatternSequence[{{_?DistanceQ..}..},{{_?DistanceQ..}..}]
],ops:OptionsPattern[PlotVolume]]:=	PlotVolume[in,ops]



(* ::Subsubsection:: *)
(*Object[Data,Conductivity]*)


plotObject[in:ObjectP[Object[Data,Conductivity]],ops:OptionsPattern[PlotConductivity]]:=PlotConductivity[in,ops];



(* ::Subsubsection:: *)
(*Object[Data,Sensor]*)


(* Specific overload for pH. *)
plotObject[in:ObjectP[Object[Data,pH]],ops:OptionsPattern[PlotpH]]:=PlotpH[in,ops];


(* Plots a data object or a data InfoP*)
plotObject[in:(ObjectP[List@@SensorDataTypeP]),ops:OptionsPattern[PlotSensor]]:=
		PlotSensor[in,ops]



(* Plots a data object or a data InfoP*)
plotObject[in:({SLObjectPLP[List@@SensorDataTypeP]..}),ops:OptionsPattern[PlotSensor]]:=
		PlotSensor[in,ops]



(* Plot a list of datapoint*)
plotObject[in:(DateCoordinateP|{{_?DateObjectQ, _?UnitsQ}..}|{{DateCoordinateP|{{_?DateObjectQ, _?UnitsQ}..}}..}),ops:OptionsPattern[PlotSensor]]:=
		PlotSensor[in,ops]

(* ::Subsubsection:: *)
(*Object[Data,DissolvedOxygen]*)


plotObject[
	in:(ObjectP[Object[Data,DissolvedOxygen]]|{ObjectP[Object[Data, DissolvedOxygen]]..}),
	ops:OptionsPattern[PlotDissolvedOxygen]
]:=PlotDissolvedOxygen[in,ops];


(* ::Subsubsection:: *)
(*Trajectory*)


(* Trajectory *)
plotObject[traj:(_Trajectory|{_Trajectory..}),ops:OptionsPattern[PlotTrajectory]]:=
	PlotTrajectory[traj,ops]

plotObject[packet:PacketP[Object[Simulation,MeltingCurve]],ops:OptionsPattern[PlotTrajectory]]:=
	PlotTrajectory[({MeltingCurve, CoolingCurve}/.packet),ops]

plotObject[obj:ObjectP[Object[Simulation,MeltingCurve]],ops:OptionsPattern[PlotTrajectory]]:=
	PlotTrajectory[(obj[{MeltingCurve, CoolingCurve}]),ops]

plotObject[arg:(ListableP[ObjectP[Object[Simulation,Kinetics]]]|ListableP[TrajectoryP]),rest___]:=PlotTrajectory[arg,rest];


(* ::Subsubsection:: *)
(*State*)


plotObject[s_State,ops:OptionsPattern[PlotState]]:=PlotState[s,ops]
plotObject[obj:ObjectP[Object[Simulation,Equilibrium]],ops:OptionsPattern[PlotState]]:=PlotState[obj,ops]


(* ::Subsubsection:: *)
(*Object[User,Emerald]*)


Options[plotEmerald]={ImageSize->{Automatic,500}};
plotObject[in:ObjectP[Object[User,Emerald]],ops:OptionsPattern[plotEmerald]]:=With[
	{img=ImportCloudFile[Download[in,PhotoFile]]},
	Switch[img,
		_Image, ImageResize[img,OptionValue[ImageSize]],
		Null, Null
	]
]
plotObject[in:ObjectP[Object[User]],OptionsPattern[plotEmerald]]:=Null;


(* ::Subsubsection:: *)
(*Object[Data,FlowCytometry]*)


plotObject[FlowCytometry,raw:ListableP[_?NumericQ|_?FluorescenceQ,{1,3}],ops:OptionsPattern[]]:=PlotFlowCytometry[raw,ops]
plotObject[in:plotInputPattern[Object[Data,FlowCytometry]],ops:OptionsPattern[]]:=PlotFlowCytometry[in,ops]


(* ::Subsubsection:: *)
(*Object[Data, XRayDiffraction*)


plotObject[myDataObject:plotInputPattern[Object[Data,XRayDiffraction]], ops:OptionsPattern[PlotPowderXRD]]:=PlotPowderXRD[myDataObject, ops];


(* ::Subsubsection:: *)
(*Object[Data,DNASequencing]*)


(* DNASequencing *)
plotObject[in:plotInputPattern[Object[Data,DNASequencing]],ops:OptionsPattern[PlotDNASequencing]]:=PlotDNASequencing[in,ops];

plotObject[DNASequencing,xy:(CoordinatesP|{CoordinatesP..}|{{CoordinatesP..}..}),ops:OptionsPattern[PlotDNASequencing]]:=PlotDNASequencing[xy,ops];


(* ::Subsubsection:: *)
(*Object[Simulation, ReactionMechanism]*)


plotObject[mech:ListableP[_ReactionMechanism],rest___]:=PlotReactionMechanism[mech,rest];
plotObject[in:ObjectP[Object[Simulation,ReactionMechanism]],rest___]:=PlotReactionMechanism[in,rest];


(* ::Subsubsection:: *)
(*Object[Simulation,PrimerSet]*)


plotObject[in:ObjectP[Object[Simulation,PrimerSet]],ops:OptionsPattern[PlotProbeConcentration]]:=
		PlotProbeConcentration[in,ops];


(* ::Subsubsection:: *)
(*Object[Simulation,Folding]*)


plotObject[in:ObjectP[Object[Simulation,Folding]],ops:OptionsPattern[PlotProbeConcentration]]:= With[
	{packet = Download[in, Packet[FoldedStructures, ResolvedOptions]]},
	ReplaceAll[
		OptionValue[Output],
		{
			Result -> Lookup[packet,FoldedStructures],
			Options -> Lookup[packet,ResolvedOptions],
			Tests -> {}
		}
	]
];

(* ::Subsubsection:: *)
(*Object[Simulation,EquilibriumConstant]*)


plotObject[in:ObjectP[Object[Simulation,EquilibriumConstant]],ops:OptionsPattern[PlotReactionMechanism]]:=PlotReactionMechanism[ReactionMechanism[Download[in,Reaction]]];
plotObject[in:{ObjectP[Object[Simulation,EquilibriumConstant]]..},ops:OptionsPattern[PlotReactionMechanism]]:=consolidateRawListedOutputs[plotObject[#,ops]&/@in,PlotObject,ops];


(* ::Subsubsection:: *)
(*Model[Sample]*)


(* If we're plotting a Model[Sample], try to plot all of the component identity models *)
plotObject[in:ObjectP[Model[Sample]],ops:OptionsPattern[]]:=Module[
	{compositions,groupedTypes,safeOps,outputResult,outputOptions,resolvedOptions,flattenedResult,listedOutput},

	(* get the compositions *)
	(* we may have {Null, Null} entry in Composition indicating unknown impurity that we need to remove *)
	compositions=DeleteCases[Download[in,Composition[[All,2]][{Object,Type}]],Null];

	(* group the components by type so components of the same type will be sent as a list to the same overloads *)
	groupedTypes=Values[GroupBy[compositions,Last->First]];

	(* Specify internal options so we only compute result/option *)
	safeOps=SafeOptions[PlotObject,ToList@ops];

	(* plot everything based on its identity model type *)
	listedOutput=Quiet[
		plotObject[#,Sequence@@ReplaceRule[safeOps,Output->{Result,Options}]]&/@groupedTypes,
		{Warning::UnknownOption}
	];

	(* separate results and options into separate lists *)
	{outputResult,outputOptions}=Transpose@Flatten[listedOutput,Length@Dimensions@listedOutput-2];

	(* flatten result *)
	flattenedResult=Flatten@ToList@outputResult;

	(* consolidate options into single list, restoring the requested output  *)
	resolvedOptions=If[MatchQ[outputOptions,$Failed|{$Failed}],
		$Failed,
		ReplaceRule[
			(* preserve options that were resolved to the same value for all inputs. Any options resolved to different values between inputs are set to Automatic. *)
			MapThread[If[CountDistinct[List@##]>1,First@#->Automatic,Sequence@@DeleteDuplicates[List@##]]&,outputOptions],
			Output->Lookup[safeOps,Output]
		]
	];

	(* Return desired output *)
	Lookup[safeOps,Output]/.{
		Result:>If[Length@flattenedResult==1,First@flattenedResult,flattenedResult],
		Options:>resolvedOptions,
		Preview:>If[Length@outputResult==1,First@outputResult,outputResult],
		Tests->{}
	}
];

(* If we're trying to plot an IdentityModel that's not covered by an overload than return nothing *)
plotObject[in:IdentityModelTypeP,ops:OptionsPattern[]]:=Nothing;

(* If we're trying to plot a list of IdentityModels map over them to send them to potential plotting functions *)
plotObject[in:{IdentityModelTypeP..},ops:OptionsPattern[]]:=plotObject/@in;

(* plotting proteins and antibodies *)
plotObject[in:ListableP[ObjectP[Model[Molecule,Protein]]],ops:OptionsPattern[PlotProtein]]:=PlotProtein[in,PassOptions[PlotObject,PlotProtein,ops]];

(* plotting cells *)
plotObject[in:ListableP[ObjectP[Model[Cell]]],ops:OptionsPattern[PlotMicroscope]]:=PlotMicroscope[in,ops];

(* plotting proteins and antibodies *)
plotObject[in:ListableP[ObjectP[Model[Molecule,Transcript]]],ops:OptionsPattern[PlotTranscript]]:=PlotTranscript[in,ops];

(* plotting all other molecules *)
PlotObject::NoStructureAvailable = "No Molecule or StructureImageFile is set for `1`";
plotObject[in:ListableP[ObjectP[Model[Molecule]]],ops:OptionsPattern[]]:=Module[
	{objects,names,molecules,imageCloudFiles,images,nameImageTuples,structurelessObjects,structures,namedStructures,safeOps,result},

	(* download the names structures and image files of the molecules *)
	{objects,names,molecules,imageCloudFiles}=Transpose[
		Quiet[
			Download[ToList[in],{Object,Name,Molecule,StructureImageFile}],
			Download::FieldDoesntExist
		]
	];

	(* import the cloud files *)
	images=Quiet[
		ImportCloudFile[imageCloudFiles],
		{Warning::UnableToExpandInputs}
	];

	(* create pairs of {name,image}, with image cloud files > Molecule *)
	nameImageTuples=MapThread[
		Function[{object,name,molecule,image},
			{
				If[!NullQ[name],
					name,
					object
				],
				Which[
					!NullQ[image],image,
					!NullQ[molecule],molecule,
					!NullQ[name],name,
					True,ToString[object]
				]
			}
		],
		{objects,names,molecules,images}
	];

	(* find any inputs that have no image to display *)
	structurelessObjects=Extract[in,Position[nameImageTuples,{_,Null}]];

	(* throw a message if any imageless inputs are found *)
	If[Length[structurelessObjects]>0,
		Message[PlotObject::NoStructureAvailable, structurelessObjects]
	];

	(* select those inputs that have something to display *)
	structures=Cases[nameImageTuples,Except[{_,Null}]];

	(* print each structure with its name above it *)
	namedStructures=Column[#,Center]&/@structures;

	(* final result *)
	result=If[MatchQ[in,_List],
		namedStructures,
		FirstOrDefault[namedStructures,Null]
	];

	safeOps=SafeOptions[PlotObject,ToList@ops];
	Lookup[safeOps,Output]/.{
		Result:>If[MatchQ[result,_List],Flatten@result,result],
		Preview:>result,
		Options:>safeOps,
		Tests->{}
	}
];


(* ::Subsubsection:: *)
(*Object[Method,Gradient]*)


plotObject[gradientObject:ObjectP[Object[Method,Gradient]],ops:OptionsPattern[PlotGradient]]:=PlotGradient[gradientObject,ops];


(* ::Subsubsection:: *)
(*Object[Method,SupercriticalFluidGradient]*)


plotObject[gradientObject:ObjectP[Object[Method,SupercriticalFluidGradient]],ops:OptionsPattern[PlotGradient]]:=PlotGradient[gradientObject,ops];


(* ::Subsubsection:: *)
(*Object[Method,IonChromatographyGradient*)


plotObject[gradientObject:ObjectP[Object[Method,IonChromatographyGradient]],ops:OptionsPattern[PlotGradient]]:=PlotGradient[gradientObject,ops];


(* ::Subsubsection:: *)
(*Object[Method,GasChromatography]*)


plotObject[gasChromatographyMethodObject:ObjectP[Object[Method,GasChromatography]],ops:OptionsPattern[PlotGasChromatographyMethod]]:=PlotGasChromatographyMethod[gasChromatographyMethodObject,ops]



(* ::Subsubsection:: *)
(*Object[Sample]*)


plotObject[mySample:ObjectP[Object[Sample]],ops:OptionsPattern[]]:=Module[
	{linkFreeAppearanceLog, splitAppearanceLog, mostRecentAppearanceEntries, resizedImages,safeOps},

	safeOps=SafeOptions[PlotImage,ToList@PassOptions[PlotImage,ToList@ops]];

	(* Get the full appearance log for the sample, removing links so it can be split based on protocol identity below *)
	linkFreeAppearanceLog = ReplaceAll[Download[mySample, AppearanceLog], link:LinkP[] :> First[link]];

	(* Split based on common protocols and take all log entries from the most recent protocol *)
	mostRecentAppearanceEntries = LastOrDefault[SplitBy[linkFreeAppearanceLog, Last]];

	(* If there is appearance data for the sample, call PlotImage on it *)
	If[MatchQ[mostRecentAppearanceEntries,Null],
		Null,
		Module[
			{listedOutputs,result,options},
			listedOutputs=Quiet[PlotImage[#,Sequence@@ReplaceRule[safeOps,Output->{Result,Options}]]&/@mostRecentAppearanceEntries[[All,2]], {Warning::UnusedPlotImageOption}];
			X=listedOutputs;
			{result,options}=consolidateRawListedOutputs[listedOutputs,PlotImage,{Output->{Result,Options}}];
			Lookup[safeOps,Output]/.{
				Result:>Row[result],
				Preview:>Row[result],
				Options->options,
				Tests->{}
			}
		]
	]
];


(* ::Subsubsection:: *)
(*Object[Sample, Wizard]*)


plotObject[Object[Sample, Wizard, "1"]]:=ImportCloudFile[Object[EmeraldCloudFile, "id:WNa4ZjKb7qRD"]];


(* ::Subsubsection:: *)
(*Object[Analysis,Thermodynamics]*)


(* Overload to plot mega function *)
plotObject[in:ListableP[ObjectP[Object[Analysis,Thermodynamics]]],ops:OptionsPattern[PlotThermodynamics]]:=PlotThermodynamics[in,ops]

(* ::Subsubsection:: *)
(*Object[Analysis,DynamicLightScatteringLoading]*)
plotObject[in:ObjectP[Object[Analysis,DynamicLightScatteringLoading]],ops:OptionsPattern[PlotDynamicLightScatteringLoading]]:=PlotDynamicLightScatteringLoading[in,ops]


(* ::Subsubsection:: *)
(*Object[Analysis,DynamicLightScattering]*)
plotObject[in:ObjectP[Object[Analysis,DynamicLightScattering]],ops:OptionsPattern[PlotDynamicLightScatteringAnalysis]]:=PlotDynamicLightScatteringAnalysis[in,ops]


(* ::Subsubsection:: *)
(*Object[Data,pHAdjustment]*)
plotObject[in:ObjectP[Object[Data,pHAdjustment]],ops:OptionsPattern[PlotAdjustpH]]:=PlotAdjustpH[in,ops];


(* ::Subsubsection:: *)
(* Specific overload for Inventories *)
plotObject[in:ListableP[ObjectP[Object[Inventory]]],ops:OptionsPattern[PlotInventoryLevels]]:=PlotInventoryLevels[in,ops];


(* ::Subsubsection:: *)
(*Object[Analysis, ParallelLine]*)


plotObject[input:ObjectP[Object[Analysis, ParallelLine]], ops:OptionsPattern[]] := Module[
	{pckt, dataSTD, datAnalyte, bestFitFcnSTD, bestFitFcnAnalyte, bestFitExprSTD, bestFitExprAnalyte, EC50STD, EC50Analyte, EC50DashedLine,finalGraphic,resolvedOps},

	(* Resolve options - if PlotType is Automatic set it to Linear  *)
	resolvedOps=SafeOptions[PlotFit,(ToList@ops)/.(Rule[PlotType,Automatic]:>Rule[PlotType,Linear])];

	pckt = Download[input];

	{dataSTD, datAnalyte, bestFitFcnSTD, bestFitFcnAnalyte, bestFitExprSTD, bestFitExprAnalyte, EC50STD, EC50Analyte} = {
		pckt[DataPointsStandard],
		pckt[DataPointsAnalyte],
		pckt[BestFitFunction][[1,1]],
		pckt[BestFitFunction][[1,2]],
		pckt[BestFitExpression][[1,1]],
		pckt[BestFitExpression][[1,2]],
		Analysis`Private`selectInflectionPoint[pckt[BestFitParametersStandard]][[1,2]],
		Analysis`Private`selectInflectionPoint[pckt[BestFitParametersAnalyte]][[1,2]]
	};

	EC50DashedLine = Graphics[
		{
			Dashed, Orange, Thickness[0.005], Line[{{EC50STD, 0}, {EC50STD, bestFitExprSTD/.{x->EC50STD}}}],
			Orange, Thickness[0.005], Arrow[{{EC50STD, bestFitExprSTD/.{x->EC50STD}}, {EC50Analyte, bestFitExprAnalyte/.{x->EC50Analyte}}}],
			Dashed, Orange, Thickness[0.005], Line[{{EC50Analyte, 0}, {EC50Analyte, bestFitExprAnalyte/.{x->EC50Analyte}}}]
		}
	];

	(* Generate graphic *)
	finalGraphic=Zoomable@Show[
		PlotFit[dataSTD, bestFitFcnSTD, Display->{DataError}, TargetUnits->pckt[DataUnits], PassOptions[PlotFit,PlotFit,Normal[pckt]]],
		PlotFit[datAnalyte, bestFitFcnAnalyte, Display->{DataError}, TargetUnits->pckt[DataUnits], PassOptions[PlotFit,PlotFit,Normal[pckt]]],
		EC50DashedLine
	];

	(* Return desired output *)
	Lookup[resolvedOps,Output]/.{
		Result:>finalGraphic,
		Preview:>finalGraphic,
		Options->resolvedOps,
		Tests->{}
	}

];


plotObject[inputs:{ObjectP[Object[Analysis, ParallelLine]]..}, ops:OptionsPattern[PlotFit]]:=consolidateRawListedOutputs[plotObject[#,ops]&/@inputs,PlotObject,ops];


(* ::Subsubsection::Closed:: *)
(*Object[Analysis,Composition]*)


(*plotObject[input:ObjectP[Object[Analysis, Composition]], ops:OptionsPattern[PlotFit]]:=TabView[{
	"Samples"->PlotTable[
		Transpose[Download[input,{SamplesIn,AliquotSamples,AliquotDilutionRatio,Data,SampleModels,SampleAreas,SampleConcentrations}]],
		TableHeadings->{None,{"Sample","Aliquot Sample","Dilution Ratio","Data","Analyte","PeakArea","Concentration"}},
		Alignment->{Center,Center}
	],
	"Standards"->PlotTable[
		Transpose[Lookup[input,{Standards,StandardModels,StandardAreas,StandardConcentrations}]],
		TableHeadings->{None,{"Standard","Analyte","PeakArea","Concentration"}},
		Alignment->{Center,Center}
	]
},Alignment->{Center,Top}]*)


(* ::Subsubsection:: *)
(*Object[Qualification, HPLC]*)


plotObject[input:ObjectP[Object[Qualification,HPLC]], ops:OptionsPattern[PlotChromatography]]:=Module[
	{dilutions,dataPackets,gradientEndTime,standardOptions,fullOptions,plot},

	(* download the data *)
	{dilutions,dataPackets}=Download[input,
		{
			DetectorLinearityTests[[All,DilutionFactor]],
			Packet[DetectorLinearityTests[[All,Data]][{AbsorbanceWavelength,SamplesIn,Absorbance,Pressure,SecondaryAbsorbance,Conductance,MinAbsorbanceWavelength,MaxAbsorbanceWavelength,Fluorescence}]]
		}
	];

	(* don't return anything if no data has been parsed *)
	If[MatchQ[dataPackets,{Null...}],
		Return[Null]
	];

	(* find out what to set the x-range max to *)
	gradientEndTime=Lookup[dataPackets[[1]],Absorbance][[-1,1]];

	(* Make some nice options to give to PlotChromatography *)
	standardOptions={
		SecondaryData->{},
		Filling->None,
		PlotRange->{{0,gradientEndTime},Automatic},
		Ladder->Null,
		LegendPlacement->Right,
		Legend->(ToString[#,StandardForm]<>"x"&/@dilutions)
	};

	(* Use the standard options we like, but override and add any explicitly set options *)
	fullOptions=ReplaceRule[standardOptions,ToList[ops]];


	(* plot the results *)
	plot=PlotChromatography[dataPackets,
		fullOptions
	]
];


(* ::Subsubsection:: *)
(*Object[Calibration,Sensor,pH]*)


plotObject[input:ObjectP[Object[Calibration,Sensor,pH]], ops:OptionsPattern[]]:=plotObject[input[FitAnalysis],ops];

(* ::Subsubsection:: *)
(*plotObject overloads for protocol objects*)
plotObject[input:ObjectP[Object[Protocol, AbsorbanceKinetics]], ops:OptionsPattern[PlotAbsorbanceKinetics]] := PlotAbsorbanceKinetics[input, ops];
plotObject[input:ObjectP[Object[Protocol, AbsorbanceQuantification]], ops:OptionsPattern[PlotAbsorbanceQuantification]] := PlotAbsorbanceQuantification[input, ops];
plotObject[input:ObjectP[Object[Protocol, AbsorbanceSpectroscopy]], ops:OptionsPattern[PlotAbsorbanceSpectroscopy]] := PlotAbsorbanceSpectroscopy[input, ops];
plotObject[input:ObjectP[Object[Protocol, TotalProteinQuantification]], ops:OptionsPattern[PlotAbsorbanceSpectroscopy]] := PlotAbsorbanceSpectroscopy[input, ops];
plotObject[input:ObjectP[Object[Protocol, ThermalShift]], ops:OptionsPattern[PlotAbsorbanceThermodynamics]] := PlotAbsorbanceThermodynamics[input, ops];
plotObject[input:ObjectP[Object[Protocol, UVMelting]], ops:OptionsPattern[PlotAbsorbanceThermodynamics]] := PlotAbsorbanceThermodynamics[input, ops];
plotObject[input:ObjectP[Object[Protocol, AgaroseGelElectrophoresis]], ops:OptionsPattern[PlotAgarose]] := PlotAgarose[input, ops];
plotObject[input:ObjectP[Object[Protocol, AlphaScreen]], ops:OptionsPattern[PlotAlphaScreen]] := PlotAlphaScreen[input, ops];
plotObject[input:ObjectP[Object[Protocol, BioLayerInterferometry]], ops:OptionsPattern[PlotBioLayerInterferometry]] := PlotBioLayerInterferometry[input, ops];
plotObject[input:ObjectP[Object[Protocol, CapillaryGelElectrophoresisSDS]], ops:OptionsPattern[PlotCapillaryGelElectrophoresisSDS]] := PlotCapillaryGelElectrophoresisSDS[input, ops];
plotObject[input:ObjectP[Object[Protocol, CapillaryIsoelectricFocusing]], ops:OptionsPattern[PlotCapillaryIsoelectricFocusing]] := PlotCapillaryIsoelectricFocusing[input, ops];
plotObject[input:ObjectP[Object[Protocol, FPLC]], ops:OptionsPattern[PlotChromatography]] := PlotChromatography[input, ops];
plotObject[input:ObjectP[Object[Protocol, GasChromatography]], ops:OptionsPattern[PlotChromatography]] := PlotChromatography[input, ops];
plotObject[input:ObjectP[Object[Protocol, HPLC]], ops:OptionsPattern[PlotChromatography]] := PlotChromatography[input, ops];
plotObject[input:ObjectP[Object[Protocol, IonChromatography]], ops:OptionsPattern[PlotChromatography]] := PlotChromatography[input, ops];
plotObject[input:ObjectP[Object[Protocol, SupercriticalFluidChromatography]], ops:OptionsPattern[PlotChromatography]] := PlotChromatography[input, ops];
plotObject[input:ObjectP[Object[Protocol, LCMS]], ops:OptionsPattern[PlotChromatographyMassSpectra]] := PlotChromatographyMassSpectra[input, ops];
plotObject[input:ObjectP[Object[Protocol, CircularDichroism]], ops:OptionsPattern[PlotCircularDichroism]] := PlotCircularDichroism[input, ops];
plotObject[input:ObjectP[Object[Protocol, MeasureConductivity]], ops:OptionsPattern[PlotConductivity]] := PlotConductivity[input, ops];
plotObject[input:ObjectP[Object[Protocol, CoulterCount]], ops:OptionsPattern[PlotCoulterCount]] := PlotCoulterCount[input, ops];
plotObject[input:ObjectP[Object[Protocol, MeasureSurfaceTension]], ops:OptionsPattern[PlotCriticalMicelleConcentration]] := PlotCriticalMicelleConcentration[input, ops];
plotObject[input:ObjectP[Object[Protocol, CyclicVoltammetry]], ops:OptionsPattern[PlotCyclicVoltammetry]] := PlotCyclicVoltammetry[input, ops];
plotObject[input:ObjectP[Object[Protocol, DifferentialScanningCalorimetry]], ops:OptionsPattern[PlotDifferentialScanningCalorimetry]] := PlotDifferentialScanningCalorimetry[input, ops];
plotObject[input:ObjectP[Object[Protocol, DigitalPCR]], ops:OptionsPattern[PlotDigitalPCR]] := PlotDigitalPCR[input, ops];
plotObject[input:ObjectP[Object[Protocol, MeasureDissolvedOxygen]], ops:OptionsPattern[PlotDissolvedOxygen]] := PlotDissolvedOxygen[input, ops];
plotObject[input:ObjectP[Object[Protocol, DNASequencing]], ops:OptionsPattern[PlotDNASequencing]] := PlotDNASequencing[input, ops];
plotObject[input:ObjectP[Object[Protocol, DynamicFoamAnalysis]], ops:OptionsPattern[PlotDynamicFoamAnalysis]] := PlotDynamicFoamAnalysis[input, ops];
plotObject[input:ObjectP[Object[Protocol, DynamicLightScattering]], ops:OptionsPattern[PlotDynamicLightScattering]] := PlotDynamicLightScattering[input, ops];
plotObject[input:ObjectP[Object[Protocol, ELISA]], ops:OptionsPattern[PlotELISA]] := PlotELISA[input, ops];
plotObject[input:ObjectP[Object[Protocol, CapillaryELISA]], ops:OptionsPattern[PlotELISA]] := PlotELISA[input, ops];
plotObject[input:ObjectP[Object[Protocol, FlowCytometry]], ops:OptionsPattern[PlotFlowCytometry]] := PlotFlowCytometry[input, ops];
plotObject[input:ObjectP[Object[Protocol, FluorescenceIntensity]], ops:OptionsPattern[PlotFluorescenceIntensity]] := PlotFluorescenceIntensity[input, ops];
plotObject[input:ObjectP[Object[Protocol, FluorescenceKinetics]], ops:OptionsPattern[PlotFluorescenceKinetics]] := PlotFluorescenceKinetics[input, ops];
plotObject[input:ObjectP[Object[Protocol, FluorescenceSpectroscopy]], ops:OptionsPattern[PlotFluorescenceSpectroscopy]] := PlotFluorescenceSpectroscopy[input, ops];
plotObject[input:ObjectP[Object[Protocol, FluorescenceThermodynamics]], ops:OptionsPattern[PlotFluorescenceThermodynamics]] := PlotFluorescenceThermodynamics[input, ops];
plotObject[input:ObjectP[Object[Protocol, FragmentAnalysis]], ops:OptionsPattern[PlotFragmentAnalysis]] := PlotFragmentAnalysis[input, ops];
plotObject[input:ObjectP[Object[Protocol, ICPMS]], ops:OptionsPattern[PlotICPMS]] := PlotICPMS[input, ops];
plotObject[input:ObjectP[Object[Protocol, IRSpectroscopy]], ops:OptionsPattern[PlotIRSpectroscopy]] := PlotIRSpectroscopy[input, ops];
plotObject[input:ObjectP[Object[Protocol, LuminescenceKinetics]], ops:OptionsPattern[PlotLuminescenceKinetics]] := PlotLuminescenceKinetics[input, ops];
plotObject[input:ObjectP[Object[Protocol, LuminescenceSpectroscopy]], ops:OptionsPattern[PlotLuminescenceSpectroscopy]] := PlotLuminescenceSpectroscopy[input, ops];
plotObject[input:ObjectP[Object[Protocol, MassSpectrometry]], ops:OptionsPattern[PlotMassSpectrometry]] := PlotMassSpectrometry[input, ops];
plotObject[input:ObjectP[Object[Protocol, MeasureMeltingPoint]], ops:OptionsPattern[PlotMeasureMeltingPoint]] := PlotMeasureMeltingPoint[input, ops];
plotObject[input:ObjectP[Object[Protocol, NephelometryKinetics]], ops:OptionsPattern[PlotNephelometryKinetics]] := PlotNephelometryKinetics[input, ops];
plotObject[input:ObjectP[Object[Protocol, NMR]], ops:OptionsPattern[PlotNMR]] := PlotNMR[input, ops];
plotObject[input:ObjectP[Object[Protocol, NMR2D]], ops:OptionsPattern[PlotNMR2D]] := PlotNMR2D[input, ops];
plotObject[input:ObjectP[Object[Protocol, PAGE]], ops:OptionsPattern[PlotPAGE]] := PlotPAGE[input, ops];
plotObject[input:ObjectP[Object[Protocol, MeasurepH]], ops:OptionsPattern[PlotpH]] := PlotpH[input, ops];
plotObject[input:ObjectP[Object[Protocol, PowderXRD]], ops:OptionsPattern[PlotPowderXRD]] := PlotPowderXRD[input, ops];
plotObject[input:ObjectP[Object[Protocol, qPCR]], ops:OptionsPattern[PlotqPCR]] := PlotqPCR[input, ops];
plotObject[input:ObjectP[Object[Protocol, RamanSpectroscopy]], ops:OptionsPattern[PlotRamanSpectroscopy]] := PlotRamanSpectroscopy[input, ops];
plotObject[input:ObjectP[Object[Protocol, MeasureSurfaceTension]], ops:OptionsPattern[PlotSurfaceTension]] := PlotSurfaceTension[input, ops];
plotObject[input:ObjectP[Object[Protocol, TotalProteinDetection]], ops:OptionsPattern[PlotWestern]] := PlotWestern[input, ops];
plotObject[input:ObjectP[Object[Protocol, Western]], ops:OptionsPattern[PlotWestern]] := PlotWestern[input, ops];
plotObject[input:ObjectP[Object[Protocol, AdjustpH]], ops:OptionsPattern[PlotAdjustpH]] := PlotAdjustpH[input, ops];

(* ::Subsubsection:: *)
(*plotObject overloads for analysis and data objects*)

plotObject[input:ListableP[ObjectP[Object[Data, Microscope]]], ops:OptionsPattern[PlotMicroscope]] := PlotMicroscope[input, ops];

plotObject[input:ListableP[ObjectP[Object[Analysis, AbsorbanceQuantification]]], ops:OptionsPattern[PlotAbsorbanceQuantification]] := PlotAbsorbanceQuantification[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, CellCount]]], ops:OptionsPattern[PlotCellCount]] := PlotCellCount[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, Colonies]]], ops:OptionsPattern[PlotColonies]] := PlotColonies[input, ops];
plotObject[input:ObjectP[Object[Analysis, ColonyGrowth]], ops:OptionsPattern[PlotColonyGrowth]] := PlotColonyGrowth[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, CopyNumber]]], ops:OptionsPattern[PlotCopyNumber]] := PlotCopyNumber[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, CriticalMicelleConcentration]]], ops:OptionsPattern[PlotCriticalMicelleConcentration]] := PlotCriticalMicelleConcentration[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, BindingQuantitation]]], ops:OptionsPattern[PlotBindingQuantitation]]:=PlotBindingQuantitation[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, EpitopeBinning]]], ops:OptionsPattern[PlotEpitopeBinning]]:=PlotEpitopeBinning[input, ops];

plotObject[input:ListableP[ObjectP[Object[Analysis, Fit]]], ops:OptionsPattern[PlotFit]] := PlotFit[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, Fractions]]], ops:OptionsPattern[PlotFractions]] := PlotFractions[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, Gating]]], ops:OptionsPattern[PlotGating]] := PlotGating[input, ops];
plotObject[input:ObjectP[Object[Analysis, ImageExposure]], ops:OptionsPattern[PlotImageExposure]] := PlotImageExposure[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, Kinetics]]], ops:OptionsPattern[PlotKineticRates]] := PlotKineticRates[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, Ladder]]], ops:OptionsPattern[PlotLadder]] := PlotLadder[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, MeltingPoint]]], ops:OptionsPattern[PlotMeltingPoint]] := PlotMeltingPoint[input, ops];

plotObject[input:ListableP[ObjectP[Object[Analysis, MicroscopeOverlay]]], ops:OptionsPattern[PlotMicroscopeOverlay]] := PlotMicroscopeOverlay[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, Peaks]]], ops:OptionsPattern[PlotPeaks]] := PlotPeaks[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, QuantificationCycle]]], ops:OptionsPattern[PlotQuantificationCycle]] := PlotQuantificationCycle[input, ops];
plotObject[input:ListableP[ObjectP[Object[Data, SurfaceTension]]], ops:OptionsPattern[PlotSurfaceTension]] := PlotSurfaceTension[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, Thermodynamics]]], ops:OptionsPattern[PlotThermodynamics]] := PlotThermodynamics[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, StandardCurve]]], ops:OptionsPattern[PlotStandardCurve]] := PlotStandardCurve[input, ops];
plotObject[input:ListableP[ObjectP[Object[Analysis, DNASequencing]]], ops:OptionsPattern[PlotDNASequencingAnalysis]]:=PlotDNASequencingAnalysis[input, ops];

plotObject[input:ListableP[ObjectP[Object[Analysis, Smoothing]]], ops:OptionsPattern[PlotSmoothing]] := PlotSmoothing[input, ops];

(* Plot ImageFile of these types *)
plotObject[input:ListableP[ObjectP[{Object[Instrument],Model[Instrument], Object[Part], Model[Part], Object[Sensor], Model[Sensor], Object[Item], Model[Item], Object[Plumbing], Model[Plumbing], Object[Wiring], Model[Wiring], Object[Product]}]],ops:OptionsPattern[plotCloudFile]]:=plotCloudFile[input,ops];

plotObject[input:ListableP[ObjectP[Model[Container]]], ops:OptionsPattern[PlotImage]] := PlotImage[input, ops];

plotObject[input:ListableP[ObjectP[Object[Data, Appearance]]], ops:OptionsPattern[PlotImage]] := PlotImage[input, ops];

plotObject[input:ListableP[ObjectP[Object[Data, Volume]]], ops:OptionsPattern[PlotVolume]] := PlotVolume[ToList[input], ops];

plotObject[image:ListableP[_Image | _Graphics | EmeraldCloudFileP],ops:OptionsPattern[PlotImage]]:=PlotImage[image,ops];

plotObject[input:ListableP[ObjectP[Object[EmeraldCloudFile]]],ops:OptionsPattern[PlotImage]]:=PlotCloudFile[input,ops];

plotObject[input:ListableP[ObjectP[{Object[MassFragmentationSpectrum], Object[Simulation, FragmentationSpectra]}]], ops:OptionsPattern[PlotPeptideFragmentationSpectraSimulation]]:=PlotPeptideFragmentationSpectraSimulation[input, ops];

plotObject[input:ListableP[ObjectP[Object[Analysis, MassSpectrumDeconvolution]]], ops:OptionsPattern[EmeraldListLinePlot]] := Analysis`Private`plotObjectMassSpectrumDeconvolution[input, ops];


(* ::Subsection::Closed:: *)
(*plotObject raw definitions*)


(* ::Subsubsection:: *)
(*plotObject*)


plotObject[in_,ops:OptionsPattern[]]:=Module[{plotType,plotFunction},
	plotType=Lookup[{ops,PlotType->Automatic},PlotType];
	plotFunction=resolvePlotFunction[in,plotType];
	If[MatchQ[plotFunction,$Failed],Return[Null]];
	plotFunction[in,Sequence@@FilterRules[{ops},Options[plotFunction]]]
];


(* ::Subsubsection:: *)
(*resolvePlotFunction*)


(* Explicitly resolve all the plotObject overloads that use a Module rather than directly calling another function *)
resolvePlotFunction[input:ObjectP[Object[Sample]],plotType_]:=PlotImage;
(*resolvePlotFunction[input:ObjectP[Object[Sample]],plotType_]:=DynamicImage;*)
resolvePlotFunction[input:ObjectP[Object[Analysis, ParallelLine]],plotType_]:=PlotFit;


resolvePlotFunction[in_,plotType:ListPlot3D]:=EmeraldListPlot3D;
resolvePlotFunction[in_,plotType:ListPointPlot3D]:=EmeraldListPointPlot3D;
resolvePlotFunction[in_,plotType:ListContourPlot]:=EmeraldListContourPlot;
resolvePlotFunction[in_,plotType:BarChart]:=EmeraldBarChart;
resolvePlotFunction[in_,plotType:PieChart]:=EmeraldPieChart;
resolvePlotFunction[in_,plotType:Histogram]:=EmeraldHistogram;
resolvePlotFunction[in_,plotType:BoxWhiskerChart]:=EmeraldBoxWhiskerChart;
resolvePlotFunction[in_,plotType:(LinePlot|ListPlot|ListLinePlot)]:=EmeraldListLinePlot;
resolvePlotFunction[in_,plotType:(DatePlot|DateListPlot)]:=EmeraldDateListPlot;
resolvePlotFunction[in_,plotType:ListPlot3D]:=EmeraldListPlot3D;

resolvePlotFunction[in:{{(_?QuantityQ|Null),(_?QuantityQ|Null),(_?QuantityQ|Null)}..},plotType:Automatic]:=EmeraldListPlot3D;
resolvePlotFunction[in:QuantityArrayRawPCoordinates3D,plotType:Automatic]:=EmeraldListPlot3D;

resolvePlotFunction[in:ListableP[Null,2],plotType:Automatic]:=EmeraldListLinePlot

listLinePlotArgP = oneDataSetP|{(oneDataSetP|{oneDataSetP..})..};
resolvePlotFunction[in:listLinePlotArgP,plotType:Automatic]:=EmeraldListLinePlot;

dateListPlotArgP = oneDateListDataSetP|{(oneDateListDataSetP|{oneDateListDataSetP..})..};
resolvePlotFunction[in:dateListPlotArgP,plotType:Automatic]:=EmeraldDateListPlot;


(* 3D plots *)
resolvePlotFunction[in:nullQuantity3DP,plotType:Automatic]:=EmeraldListPlot3D;
resolvePlotFunction[in:{nullQuantity3DP..},plotType:Automatic]:=EmeraldListPlot3D



(* BOX WHISKER CHART
	- Triply listed scalar elements has to be this
*)
resolvePlotFunction[in:{{oneChartDataSetP..}..},plotType:Automatic]:=EmeraldBoxWhiskerChart;
resolvePlotFunction[in:QuantityArrayP[3],plotType:Automatic]:=EmeraldBoxWhiskerChart


(* BAR CHART
	- Single or double list, where number of elements is small
*)
resolvePlotFunction[in:oneChartDataSetP,plotType:Automatic]:=EmeraldBarChart /; Length[in]<=50
resolvePlotFunction[in:{oneChartDataSetP..},plotType:Automatic]:=EmeraldBarChart /; Max[Map[Length,in]]<=50

(* HISTOGRAM
	- Single or double list, where number of elements is largs
*)
resolvePlotFunction[in:oneChartDataSetP,plotType:Automatic]:=EmeraldHistogram
resolvePlotFunction[in:{oneChartDataSetP..},plotType:Automatic]:=EmeraldHistogram

(* EmpiricalDistribution *)
resolvePlotFunction[in:EmpiricalDistributionP[],plotType:Automatic]:=PlotDistribution
resolvePlotFunction[in:{EmpiricalDistributionP[]..},plotType:Automatic]:=PlotDistribution
resolvePlotFunction[in_?DistributionParameterQ,plotType:Automatic]:=PlotDistribution


resolvePlotFunction[___]:=$Failed;


(* ::Subsection:: *)
(*plotCloudFile*)


DefineOptions[plotCloudFile,
	Options:>{
		{
			OptionName->ImageSize,
			Default->Automatic,
			Description->"Indicates the desired width of the image",
			AllowNull->False,
			Category->"Protocol",
			Widget-> Widget[Type->Number,Pattern:>GreaterP[0]]
		},

		OutputOption

	},
	SharedOptions:>{Image}
]

(*plotCloudFile[object:ObjectP[],ops:OptionsPattern[plotCloudFile]]:=First[plotCloudFile[{object},ops]]*)
plotCloudFile[objects:ListableP[ObjectP[]],ops:OptionsPattern[plotCloudFile]]:=Module[
	{safeOps,suppliedImageSize,imageSize,updatedOps,imageDownload,images,opsWithoutAutomaticColor,output,finalPlot},

	(* Resolve ImageSize - use smaller value for container models since they are often super tall images*)
	safeOps=SafeOptions[plotCloudFile,ToList[ops]];
	suppliedImageSize=Lookup[safeOps,ImageSize];
	imageSize=If[MatchQ[suppliedImageSize,Automatic],
		If[MatchQ[First[Commonest[Download[ToList@objects,Type]]],TypeP[Model[Container]]],
			200,
			500
		],
		suppliedImageSize
	];
	updatedOps=ReplaceRule[safeOps,ImageSize->imageSize];

	(* If ColorSpace->Automatic, Image sometimes turns the image blue. To prevent this, remove this option if the value is automatic.*)
	(* NOTE: PassOptions adds the ColorSpace -> Automatic option, so we have to filer it out here. *)
	opsWithoutAutomaticColor=DeleteCases[ToList[PassOptions[Image, updatedOps]], ColorSpace->Automatic];

	(* Download cloud file images. If the image is not available from the object, we can use model's image *)
	imageDownload=Quiet[
		Download[
			ToList@objects,
			{ImageFile,Model[ImageFile]}
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];
	images=Map[
		Which[
			(* Input ImageFile directly *)
			MatchQ[#[[1]],ObjectP[]],
			ImportCloudFile[#[[1]]],
			(* Input Model ImageFile directly *)
			MatchQ[#[[2]],ObjectP[]],
			ImportCloudFile[#[[2]]],
			True,Null
		]&,
		imageDownload
	];

	(* Generate final plot *)
	finalPlot=Map[
		If[MatchQ[#,Null],
			Null,
			Image[#,opsWithoutAutomaticColor]
		]&,
		images
	];

	output=Lookup[safeOps,Output];
	output/.{
		Result->If[MatchQ[objects,_List],finalPlot,First@finalPlot],
		Preview->If[MatchQ[objects,_List],SlideView@ToList@finalPlot,First@finalPlot],
		Options->updatedOps,
		Tests->{}
	}

];



(* ::Subsection:: *)
(*PlotObject Public Function*)


(* ::Subsubsection:: *)
(* PlotObject Supported Functions *)


(* All generic plots defined in Megaplots.m *)
emeraldPlots={
	EmeraldListLinePlot,EmeraldDateListPlot,EmeraldBarChart,EmeraldPieChart,
	EmeraldBoxWhiskerChart,EmeraldHistogram,EmeraldSmoothHistogram,EmeraldListContourPlot,
	EmeraldListPointPlot3D,EmeraldListPlot3D,EmeraldHistogram3D,EmeraldSmoothHistogram3D
};

(* All Analysis/Data/Simulation/Visualized PlotObject redirects defined below. Hardcoding these here because generating them using DownValues[] entails a download call and misses all the redirects defined below this line in the file.  *)
analysisPlots={
	PlotAbsorbanceQuantification,
	PlotCellCount,
	PlotCopyNumber,
	PlotFit,
	PlotFractions,
	PlotGating,
	PlotKineticRates,
	PlotLadder,
	PlotMeltingPoint,
	PlotMicroscopeOverlay,
	PlotPeaks,
	PlotQuantificationCycle,
	PlotSmoothing,
	PlotStandardCurve,
	PlotThermodynamics,
	Analysis`Private`plotObjectMassSpectrumDeconvolution
};

dataPlots={
	PlotAbsorbanceKinetics,PlotAbsorbanceSpectroscopy,PlotAbsorbanceThermodynamics,
	PlotAgarose, PlotAlphaScreen, PlotBindingKinetics, PlotBindingQuantitation,PlotBioLayerInterferometry, PlotCapillaryGelElectrophoresisSDS,
	PlotCapillaryIsoelectricFocusing, PlotChromatography, PlotCoulterCount,
	PlotCrossFlowFiltration,PlotConductivity,PlotCriticalMicelleConcentration, PlotCyclicVoltammetry, PlotDifferentialScanningCalorimetry,
	PlotDissolvedOxygen, PlotDNASequencing, PlotDynamicLightScattering, PlotELISA, PlotICPMS, PlotEpitopeBinning,PlotFlowCytometry,PlotFluorescenceIntensity,
	PlotFluorescenceKinetics,PlotFluorescenceSpectroscopy,PlotFluorescenceThermodynamics,PlotFragmentAnalysis,PlotFreezeCells,
	PlotGasChromatographyMethod,PlotGradient,PlotIRSpectroscopy,PlotLuminescenceKinetics,
	PlotLuminescenceSpectroscopy,PlotMassSpectrometry, PlotMeasureMeltingPoint, PlotMicroscope, PlotNephelometry, PlotNephelometryKinetics, PlotNMR,PlotNMR2D,
	PlotPAGE,PlotpH,PlotPowderXRD,PlotCrystallizationImagingLog,PlotqPCR,PlotDigitalPCR,PlotRamanSpectroscopy,PlotSensor,
	PlotSurfaceTension,PlotTLC,PlotVacuumEvaporation,PlotVolume,PlotWestern,PlotCircularDichroism,
	PlotChromatographyMassSpectra,PlotDynamicFoamAnalysis,PlotAdjustpH
};

simulationPlots={
	PlotProbeConcentration,
	PlotReactionMechanism,
	PlotState,
	PlotTrajectory,
	PlotPeptideFragmentationSpectraSimulation
};

visualizePlots={
	PlotCloudFile,
	PlotImage,
	PlotProtein,
	PlotTranscript,
	PlotVirus
};

(* List all functions which can be called by PlotObject *)
allPlotFunctions=Join[emeraldPlots,analysisPlots,dataPlots,simulationPlots,visualizePlots];

(* List of all functions which operate on objects and not raw data (no emeraldPlots) *)
objectPlotFunctions=Join[analysisPlots,dataPlots,simulationPlots,visualizePlots];



(* ::Subsubsection:: *)
(*PlotObject Options*)


(*
	this is weird.
	when PlotObjectOptions is referenced (in the future by DefineOptions),
	it's going to trigger this DefineOptionsSet call and then clear this from itself.
	This is all to prevent a bunch of plot option loading from happening before they're needed.
*)
PlotObjectOptions := Module[
	{generateOptionDefinition,allOptionDefinitions,groupedOptionDefinitions,finalOptionDefinitions},

	(* clear this definition we're inside *)
	PlotObjectOptions =. ;

	(* Format an option definition based on existing definitions *)
	generateOptionDefinition[singleOptionDefs:{_Association..}]:=Module[
		{opName,categories,category,desc,resDescs,resolvedResDesc,allowNull,groupedWidgets,combinedWidget,defaultValues,default},

		(* Resolve the name of the option being processed *)
		opName=First[Lookup[#,"OptionSymbol"]&/@singleOptionDefs];

		(* Use the most common option category, only using Hidden if nothing else is available *)
		categories=DeleteCases[Lookup[#,"Category"]&/@singleOptionDefs,_Missing];
		category=Which[
			Length@DeleteDuplicates@categories==0,"Hidden",
			Length@DeleteDuplicates@categories==1,First@Commonest@categories,
			True,First@Commonest@Select[categories,!StringMatchQ[#,"Hidden"]&]
		];

		(* Take the most common description among possible options *)
		desc=First@Commonest@DeleteCases[Lookup[#,"Description"]&/@singleOptionDefs,_Missing];

		(* Determine an appropriate default value *)
		defaultValues=ReleaseHold/@DeleteCases[Lookup[#,"Default"]&/@singleOptionDefs,_Missing];
		default=If[
			MatchQ[opName,Output],
			Result,
			If[
				(* If a single default exists, use it *)
				Length@defaultValues==1,
				First@defaultValues,

				(* If multiple defaults exist and any are Automatic, use Automatic, otherwise use the most common default *)
				If[MemberQ[defaultValues,Automatic],Automatic,First@Commonest@defaultValues]
			]
		];

		(* ResolutionDescription is not required so we need to check that at least one exists *)
		resDescs=DeleteCases[Lookup[#,"ResolutionDescription"]&/@singleOptionDefs,_Missing];
		resolvedResDesc=If[MatchQ[resDescs,{}],
			None,
			First@Commonest@resDescs
		];

		(* AllowNull\[Rule]True for all options, because there aren't any options used by all downstream functions *)
		allowNull=True;

		(* Group widgets by (common widget)\[Rule](functions using that widget) *)
		groupedWidgets=Normal@GroupBy[
			DeleteCases[(Rule@@Lookup[#,{"Symbol","Widget"}])&/@singleOptionDefs,Rule[_,_Missing|Null],1],
			Last->First
		];

		(* If every function uses the same widget, then just use that widget. Otherwise, generate alternatives *)
		combinedWidget=Which[
			(* No widgets found *)
			Length[groupedWidgets]===0,Widget[Type->Expression,Pattern:>_,Size->Line],

			(* groupedWidgets has the form {widget\[Rule]{funcs}} *)
			Length[groupedWidgets]===1,First@First@groupedWidgets,

			(* Convert to a list of rules of the form {funcs which use this}\[Rule]Widget[] *)
			True,Alternatives@@((ToString[Last[#]]->First[#])&/@groupedWidgets)
		];

		(* Output the combined option definition for opName for PlotObject, with merged widgets *)
		{
			OptionName->opName,
			Default->default,
			Description->desc,
			ResolutionDescription->resolvedResDesc,
			AllowNull->allowNull,
			Category->category,
			Widget->combinedWidget
		}
	];

	(* Generate a list of all plot options present in all possible plot functions that could be called *)
	allOptionDefinitions=Map[
		Function[{fname},
			Rule[
				Lookup[#,"OptionSymbol"],
				KeyTake[#,{"OptionSymbol","Symbol","Default","Description","ResolutionDescription","AllowNull","Category","Widget"}]
			]&/@OptionDefinition[fname]
		],
		allPlotFunctions
	];

	(* Group option definitions by name *)
	groupedOptionDefinitions=DeleteDuplicates/@GroupBy[Select[Flatten[allOptionDefinitions],!MatchQ[First@#,Output]&],First->Last];

	(* Generate options using the existing definitions from downstream functions *)
	finalOptionDefinitions=generateOptionDefinition/@Values[groupedOptionDefinitions];

	(* Define an option set for PlotObject *)
	With[{objOps=finalOptionDefinitions},
		DefineOptionSet[PlotObjectOptions:>objOps]
	];

	Options[PlotObjectOptions];

	(* return the symbol we're in *)
	PlotObjectOptions
];


DefineOptions[PlotObject,
	Options:>{
		{
			OptionName->PlotFunction,
			Default->Automatic,
			Description->"The name of the underlying PlotFunction which PlotObject calls to plot the input.",
			ResolutionDescription->"If set to Automatic, a PlotFunction is selected based on the input type.",
			AllowNull->False,
			Category->"Hidden",
			Widget->Widget[Type->Expression,Pattern:>_Symbol,Size->Word]
		},

		(* Options inherited from all subfunction calls *)
		PlotObjectOptions,

		(* Output option for the command builder *)
		OutputOption
	}
];


(* ::Subsubsection:: *)
(* PlotObject Main Function*)

(* short-circuit for no input *)
PlotObject[{}]={};

(* Command Builder overload *)
PlotObject[in__,ops:OptionsPattern[]]:=Module[
	{
		safeOps,plotType,output,plotFunc,resolvedPlotFunc,getOptionSymbols,unusedOpsRules,
		internalOps,result,preview,resolvedInternalOps,safeResolvedInternalOps,plotCallResults,resolvedOps,
		plotOps,preResolvedPlotLabel,plotResult, plotFuncOptionNames, functionContainsPlotLabelQ, plotLabelNullOrNone
	},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[PlotObject,ToList[ops]];

	plotType=Lookup[safeOps,PlotType];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* Extract the plot function which PlotObject will forward to *)
	plotFunc=ReplaceAll[
		(* Use DownValues to figure out what Plot function will be called based on inputs *)
		Hold[plotObject[in,ops]]/.DownValues[plotObject],
		(* Use Holds to extract the function name so that it doesn't evaluate *)
		{Hold[fname_[stuff___]]:>fname}
	];

	(* If the plot function didn't resolve based on overload then call internal helpers *)
	resolvedPlotFunc=If[plotFunc===Module,
		resolvePlotFunction[in,Lookup[safeOps,PlotType]],
		plotFunc
	];

	(* Extract only option names (not defaults) and convert to symbols *)
	getOptionSymbols[sym_]:=ToExpression/@First/@Options[sym];

	(* Set all unused functions to Null *)
	unusedOpsRules=Rule[#,Null]&/@Complement[
		getOptionSymbols[safeOps],
		getOptionSymbols[resolvedPlotFunc]
	];

	(* get the option names for the plot function *)
	plotFuncOptionNames = Keys[SafeOptions[resolvedPlotFunc]];
	functionContainsPlotLabelQ = MemberQ[plotFuncOptionNames, PlotLabel];

	(* Ops to be passed to the resolved plot function type *)
	internalOps=Join[
		ToList[ops],
		(* Only include PlotType for raw data inputs *)
		If[plotFunc===Module,{PlotType->plotType},{}]
	];

	(* pick None or Null for the "empty" PlotLabel value becuase for some ridiculous reason some PlotObject functions can take None but not Null and some vice versa *)
	plotLabelNullOrNone = With[{plotLabelDefinition = FirstCase[OptionDefinition[resolvedPlotFunc], KeyValuePattern[{"OptionName" -> "PlotLabel"}], <||>]},
		If[MatchQ[None, ReleaseHold[Lookup[plotLabelDefinition, "SingletonPattern"]]],
			None,
			Null
		]
	];

	(* pre resolve the PlotLabel to be None or Null if we have a single object or multiple objects without Map -> True *)
	preResolvedPlotLabel = Which[
		(* if we don't have PlotLabel, this is just dumb *)
		Not[functionContainsPlotLabelQ], Null,
		Not[MatchQ[Lookup[safeOps, PlotLabel], Automatic]], Lookup[safeOps, PlotLabel],
		Not[TrueQ[Lookup[safeOps, Map]]] && MatchQ[ToList[in], {ObjectP[]..}], plotLabelNullOrNone,
		MatchQ[ToList[in], {ObjectP[]}], plotLabelNullOrNone,
		True, Automatic
	];

	(* Get both Result and Options *)
	(* plotObject will take any object and try to plot it. If it can't it will return Null *)
	(* be robust to that case since Inspect is always trying to call PlotObject on every object *)
	plotCallResults=plotObject[
		in,
		Sequence@@ReplaceRule[
			internalOps,
			{
				Output->{Result,Options},
				(* if we actually have a PlotLabel option and it's something besides Automatic, set it here according to the pre-resolution *)
				(* note also that we can't just pass Automatic because some of the plot functions don't let you do Automatic *)
				If[functionContainsPlotLabelQ && Not[MatchQ[preResolvedPlotLabel, Automatic]],
					PlotLabel -> preResolvedPlotLabel,
					Nothing
				]
			}
		]
	];
	{plotResult,plotOps}=Which[
	    ListQ[plotCallResults]&&Length[plotCallResults]==2,plotCallResults,
	    SameLengthQ[plotCallResults,in],Transpose[plotCallResults],
		True,{Null,Null}
	];

	(* Catch in case the plot function does not return the correct format when given multile output specs *)
	(* As of 1/24/22, this catches an error in PlotDigitalPCR, and hardens PlotObject to similar errors *)
	If[MatchQ[plotResult,{_,{_Rule..}}],
		plotResult=FirstOrDefault[plotResult,$Failed];
	];

	(* Resolve the options to plotObject by calling downstream plot function *)
	resolvedInternalOps=Quiet@Check[
	  plotOps,
		internalOps,
		{OptionValue::nodef}
	];

	(* Error checking in case option resolution failed *)
	safeResolvedInternalOps=If[MatchQ[resolvedInternalOps,{(_Rule|_RuleDelayed)..}],
		resolvedInternalOps,
		{}
	];

	(* Resolve the options to plotObject by setting unused options to Null so they're hidden in command builder *)
	resolvedOps=ReplaceRule[
		safeOps,
		Join[safeResolvedInternalOps,unusedOpsRules],
		Append->False
	];

	(* Compute the result if requested *)
	result=If[MemberQ[ToList[output],Result],
		plotResult,
		Null
	];

	(* Compute the preview if requested*)
	preview=If[MemberQ[ToList[output],Preview],
		plotObject[in,Sequence@@ReplaceRule[internalOps,{Output->Preview}]],
		Null
	];

	(* Return the requested outputs *)
	output/.{
		Result->result,
		Options->ReplaceRule[resolvedOps,PlotFunction->resolvedPlotFunc],
		Preview->preview,
		Tests->{}
	}
];

(* Helper Function to get the downstream plot function used by PlotObject *)
PlotObjectFunction[in_,ops:OptionsPattern[]]:=Quiet@Lookup[
	Check[
		PlotObject[in,Sequence@@ReplaceRule[ToList[ops],Output->Options]],
		{PlotFunction->$Failed}
	],
	PlotFunction
];
