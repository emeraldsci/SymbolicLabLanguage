(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDynamicLightScattering*)


DefineOptions[PlotDynamicLightScattering,
	optionsJoin[
		(* this creates secondary data *)
		generateSharedOptions[Object[Data,DynamicLightScattering], MassDistribution, PlotTypes -> {LinePlot}],
		Options:>{
			ModifyOptions[EmeraldListLinePlot,
				{
					{OptionName->Filling,Default->Bottom,Category->"Hidden"},
					{OptionName->Scale, Category->"Hidden"}
				}
			]
		}
	],
	SharedOptions :> {
		EmeraldListLinePlot
	}
];

Error::NoDynamicLightScatteringDataToPlot = "The protocol object does not contain any associated dynamic light scattering data.";
Error::DynamicLightScatteringProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotDynamicLightScattering or PlotObject on an individual data object to identify the missing values.";

PlotDynamicLightScattering[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotDynamicLightScattering]]:=rawToPacket[primaryData,Object[Data,DynamicLightScattering],PlotDynamicLightScattering,SafeOptions[PlotDynamicLightScattering, ToList[inputOptions]]];

(* Protocol Overload *)
PlotDynamicLightScattering[
	obj: Alternatives[ObjectP[Object[Protocol, DynamicLightScattering]], ObjectP[Object[Protocol, ThermalShift]]],
	ops: OptionsPattern[PlotDynamicLightScattering]
] := Module[{listedOptions, safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* IMPORTANT - we can't call SafeOptions because listed options that only apply when mapping are handled by packetToELLP *)
	(* Make sure we're working with a list of options *)
	listedOptions = ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps = SafeOptions[PlotDynamicLightScattering, listedOptions];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, Alternatives[{ObjectP[Object[Data, DynamicLightScattering]]..}, {ObjectP[Object[Data, MeltingCurve]]..}]],
		Message[Error::NoDynamicLightScatteringDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotDynamicLightScattering[data, Sequence @@ ReplaceRule[listedOptions, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotDynamicLightScattering[#, Sequence @@ ReplaceRule[listedOptions, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::DynamicLightScatteringProtocolDataNotPlotted];
		Return[$Failed],
		Nothing
	];

	(* If Result was requested, output the plots in slide view, unless there is only one plot then we can just show it not in slide view. *)
	outputPlot = If[MemberQ[output, Result],
		If[Length[plots] > 1,
			SlideView[plots],
			First[plots]
		]
	];

	(* If Options were requested, just take the first set of options since they are the same for all plots. Make it a List first just in case there is only one option set. *)
	outputOptions = If[MemberQ[output, Options],
		First[ToList[resolvedOptions]]
	];

	(* Prepare our final result *)
	finalResult = output /. {
		Result -> outputPlot,
		Options -> outputOptions,
		Preview -> previewPlot,
		Tests -> {}
	};

	(* Return the result *)
	If[
		Length[finalResult] == 1,
		First[finalResult],
		finalResult
	]
];

PlotDynamicLightScattering[infs:ListableP[ObjectP[Object[Data, DynamicLightScattering]]] | ListableP[ObjectP[Object[Data, MeltingCurve]]],inputOptions:OptionsPattern[PlotDynamicLightScattering]]:=Module[
	{
		listedOptions,listedOptionKeys,primaryDataQ,scaleQ,frameLabelQ,packets,assayTypes,
		resolvedAssayType,resolvedPrimaryData,resolvedScale,resolvedOptionRules,assayFormFactor,massDistribution
	},

	(* IMPORTANT - we can't call SafeOptions because listed options that only apply when mapping are handled by packetToELLP *)
	(* Make sure we're working with a list of options *)
	listedOptions=ToList[inputOptions];

	(* Get the Keys of the listed options *)
	listedOptionKeys=Keys[listedOptions];


	(* Define some Booleans to see if PrimaryData, Scale, or FrameLabel were given by the user *)
	primaryDataQ=ContainsAll[listedOptionKeys, {PrimaryData}];
	scaleQ=ContainsAll[listedOptionKeys, {Scale}];
	frameLabelQ=ContainsAll[listedOptionKeys, {FrameLabel}];


	packets=Download[Flatten[ToList[infs]]];

	(* Get the AssayFormFactor (which is not already in the data object explicitly) *)
	assayFormFactor = If[MatchQ[First[Lookup[packets,Instrument]], ObjectP[Object[Instrument,DLSPlateReader]]],
		Plate,
		Capillary
	];

	(* Get the AssayTypes *)
	assayTypes=Lookup[packets,AssayType];

	(* Get the mass distribution (proxy to figure out for CS packets if we're dealing with consolidated or non-consolidated *)
	massDistribution=Lookup[packets,MassDistribution,Null];

	(* Find the most common AssayType *)
	resolvedAssayType=First[First[
		Reverse[
			SortBy[
				Tally[assayTypes],
				Part[#,2]&
			]
		]
	]];

	(* Resolve the PrimaryData *)
	resolvedPrimaryData=Switch[{resolvedAssayType,assayFormFactor},

		(* We decide based on the AssayType and AssayFormFactor *)
		{SizingPolydispersity, _},
			MassDistribution,
		{IsothermalStability, _},
			ZAverageDiameters,
		{ColloidalStability, Capillary},
			DiffusionInteractionParameterData,
		{ColloidalStability, Plate},
			If[NullQ[#],ZAverageDiameters,MassDistribution]&/@massDistribution,
		{MeltingCurve, _},
			MassDistribution
	];


	(* Resolve the Scale *)
	resolvedScale=Switch[resolvedAssayType,

		(* Other cases, we decide based on the AssayType *)
		SizingPolydispersity,
			LogLinear,
		_,
			Linear
	];

	(* Define the option rules we need to update based on the above *)
	resolvedOptionRules=Switch[{primaryDataQ,scaleQ,frameLabelQ,resolvedAssayType,assayFormFactor},

		(* If the user has not specified any of these options, we resolved defaults, and only include the frame label if SizingPolydispersity *)
		{False,False,False,SizingPolydispersity, _},
			{PrimaryData->resolvedPrimaryData,Scale->resolvedScale,FrameLabel->{"Particle Size (nm)", "Intensity (AU)"}},
		{False,False,False,IsothermalStability, _},
			{PrimaryData->resolvedPrimaryData,Scale->resolvedScale,FrameLabel->{"Time (s)", "Z-Average Diameter (nm)"}},
		{False,False,False,ColloidalStability, Plate},
			{PrimaryData->resolvedPrimaryData,Scale->resolvedScale,FrameLabel->(If[MatchQ[#, ZAverageDiameters],{"Mass Concentration (mg/mL)", "Z-Average Diameter (nm)"},{"Particle Size (nm)", "Intensity (AU)"}]&/@resolvedPrimaryData)},
		{False,False,False,ColloidalStability, Capillary},
			{PrimaryData->resolvedPrimaryData,Scale->resolvedScale,FrameLabel->{"Mass Concentration (mg/mL)", "Diffusion Coefficient (sq.m./s)"}},
		{False,False,False,MeltingCurve, _},
			{PrimaryData->resolvedPrimaryData,Scale->resolvedScale,FrameLabel->{"Particle Size (nm)", "Intensity (AU)"}},

		(* If the user has specified the PrimaryData, but only the primary data, we accept it *)
		{True,False,False,_,_},
			{Scale->resolvedScale},

		(* If the user has specified the Scale and only the Scale, we accept it, include frame label based on AssayType *)
		{False,True,False,SizingPolydispersity,_},
			{PrimaryData->resolvedPrimaryData,FrameLabel->{"Particle Size (nm)", "Intensity (AU)"}},
		{False,True,False,IsothermalStability,_},
			{PrimaryData->resolvedPrimaryData,FrameLabel->{"Time (s)", "Z-Average Diameter (nm)"}},
		{False,True,False,ColloidalStability,Plate},
			{PrimaryData->resolvedPrimaryData,FrameLabel->(If[MatchQ[#, ZAverageDiameters],{"Mass Concentration (mg/mL)", "Z-Average Diameter (nm)"},{"Particle Size (nm)", "Intensity (AU)"}]&/@resolvedPrimaryData)},
		{False,True,False,ColloidalStability, Capillary},
			{PrimaryData->resolvedPrimaryData,FrameLabel->{"Mass Concentration (mg/mL)", "Diffusion Coefficient (sq.m./s)"}},
		{False,True,False,MeltingCurve,_},
			{PrimaryData->resolvedPrimaryData,FrameLabel->{"Particle Size (nm)", "Intensity (AU)"}},

		(* If the user has specified the FrameLabel and only the frame label, we accept it *)
		{False,False,True,_,_},
			{PrimaryData->resolvedPrimaryData,Scale->resolvedScale},

		(* If the user has specified both the PrimaryData and Scale, we do nothing *)
		{True,True,_,_,_},
			{},

		(* If the user has specified the PrimaryData and the Frame label, we include the Scale *)
		{True,False,True,_,_},
			{Scale->resolvedScale},

		(* If the user has specified the Scale and the Frame label, we include the PrimaryData *)
		{False,True,True,_,_},
			{PrimaryData->resolvedPrimaryData},

		(* Catch all that shouldn't come up *)
		{_,_,_,_,_},
			{}
	];

	packetToELLP[ToList[infs],PlotDynamicLightScattering,ReplaceRule[listedOptions,resolvedOptionRules]]
];

(* because only 1 generateSharedOptions call works per option definition we need to create a new one for melting curve data *)
DefineOptions[PlotDynamicLightScatteringMeltingCurve,
	optionsJoin[
		(* this creates secondary data *)
		generateSharedOptions[Object[Data,MeltingCurve], {InitialMassDistribution, FinalMassDistribution}, PlotTypes -> {LinePlot}],
		Options:>{
			ModifyOptions[EmeraldListLinePlot,
				{
					{OptionName->Filling,Default->Bottom,Category->"Hidden"},
					{OptionName->Scale, Category->"Hidden"}
				}
			]
		}
	],
	SharedOptions :> {
		EmeraldListLinePlot
	}
];

(* Error for melting curve data *)
Error::NoDynamicLightScatteringData = "The object, `1`, does not contain dynamic light scattering data";

(* Listable overload for plotDLS *)
PlotDynamicLightScattering[infs:{ObjectP[Object[Data, MeltingCurve]]..},inputOptions:OptionsPattern[PlotDynamicLightScatteringMeltingCurve]]:=Module[
	{
		myPlots, downloadedPackets
	},

	(* expand and split up input options *)
	splitRules = If[MatchQ[ToList[inputOptions], {}],
		ConstantArray[{}, Length[infs]],
		(* expand options to be the same length *)
		expandedOptions = SciCompFramework`Private`ExpandOptions[PlotDynamicLightScatteringMeltingCurve, infs, ToList[inputOptions], Identity];

		(* separate into different option sets *)
		Transpose[Thread /@ expandedOptions]

	]; 

	(* create plots for each data *)
	myPlots = MapThread[
		PlotDynamicLightScattering[#1, #2]&,
		{infs, splitRules}
	];

	(* check if all plots failed, then return $Failed *)
	If[MatchQ[myPlots, ListableP[$Failed]],
		(* return the array of $Faileds *)
		Return[myPlots]
	];

	(* join with a slideview *)
	SlideView[myPlots]
];

(* Overload for melting curve data *)
PlotDynamicLightScattering[infs:ObjectP[Object[Data, MeltingCurve]],inputOptions:OptionsPattern[PlotDynamicLightScatteringMeltingCurve]]:=Module[
	{
		dynamicLightScatteringMeasurements, initialMassDistribution, finalMassDistribution, deafultOptions, plotOptions,
		frameLabel, filling, plotLabel
	},

	(* download nessary data *)
	{
		dynamicLightScatteringMeasurements,
		initialMassDistribution,
		finalMassDistribution
	}= Download[infs,
		{
			DynamicLightScatteringMeasurements,
			InitialMassDistribution,
			FinalMassDistribution
		}
	];

	(* check if DLS data exists *)
	If[MatchQ[dynamicLightScatteringMeasurements, {}],
		Message[Error::NoDynamicLightScatteringData, infs];
		Return[$Failed]
	];

	(* resolve options *)
	(* lookup options from input options that we have special defaults for if not specified *)
	{
		frameLabel,
		filling,
		plotLabel,
		primaryData
	} = Lookup[ToList[inputOptions],
		{
			FrameLabel,
			Filling,
			PlotLabel,
			PrimaryData
		},
		Automatic
	];

	(* check if we are plotting the initial and final mass/intensity distributions *)
	defualtPlotQ = MatchQ[primaryData,
		Automatic | ListableP[Alternatives[InitialMassDistribution, FinalMassDistribution, InitialIntensityDistribution, FinalIntensityDistribution]]
	];

	(* only add particle size labels if plotting particles sizes *)
	frameLabel = If[MatchQ[frameLabel, Automatic] && defualtPlotQ,
		{"Particle Size (nm)", "Intensity (AU)"},
		Automatic
	];

	(* only fill if plotting mass distributions *)
	filling = If[MatchQ[filling, Automatic] && defualtPlotQ,
		Bottom,
		None
	];

	(* always default to objects unless otherwise specified *)
	plotLabel = If[MatchQ[plotLabel, Automatic],
		infs,
		plotLabel
	];

	(* condense options for replacement *)
	resolvedOptions = {
		Scale -> LogLinear,
		FrameLabel -> frameLabel,
		Filling -> filling,
		PlotLabel -> plotLabel
	};

	packetToELLP[ToList[infs],PlotDynamicLightScatteringMeltingCurve, ReplaceRule[ToList[inputOptions], resolvedOptions]]

];
