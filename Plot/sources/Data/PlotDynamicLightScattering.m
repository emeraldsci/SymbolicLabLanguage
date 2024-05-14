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

PlotDynamicLightScattering[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotDynamicLightScattering]]:=rawToPacket[primaryData,Object[Data,DynamicLightScattering],PlotDynamicLightScattering,SafeOptions[PlotDynamicLightScattering, ToList[inputOptions]]];
PlotDynamicLightScattering[infs:ListableP[ObjectP[Object[Data, DynamicLightScattering]]],inputOptions:OptionsPattern[PlotDynamicLightScattering]]:=Module[
	{
		listedOptions,listedOptionKeys,primaryDataQ,scaleQ,frameLabelQ,packets,assayTypes,
		resolvedAssayType,resolvedPrimaryData,resolvedScale,resolvedOptionRules
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

	(* Get the AssayTypes *)
	assayTypes=Lookup[packets,AssayType];

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
	resolvedPrimaryData=Switch[resolvedAssayType,

		(* We decide based on the AssayType *)
		SizingPolydispersity,
			MassDistribution,
		IsothermalStability,
			ZAverageDiameters,
		B22kD,
			DiffusionInteractionParameterData,
		_,
			KirkwoodBuffIntegral
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
	resolvedOptionRules=Switch[{primaryDataQ,scaleQ,frameLabelQ,resolvedAssayType},

		(* If the user has not specified any of these options, we resolved defaults, and only include the frame label if SizingPolydispersity *)
		{False,False,False,SizingPolydispersity},
			{PrimaryData->resolvedPrimaryData,Scale->resolvedScale,FrameLabel->{"Particle Size (nm)", "Intensity (AU)"}},
		{False,False,False,IsothermalStability},
			{PrimaryData->resolvedPrimaryData,Scale->resolvedScale,FrameLabel->{"Time (s)", "Z-Average Diameter (nm)"}},
		{False,False,False,B22kD},
			{PrimaryData->resolvedPrimaryData,Scale->resolvedScale,FrameLabel->{"Mass Concentration (mg/mL)", "Diffusion Coefficient (sq.m./s)"}},
		{False,False,False,G22},
			{PrimaryData->resolvedPrimaryData,Scale->resolvedScale,FrameLabel->{"Mass Concentration (mg/mL)", "Kirkwood-Buff Integral (mL/g)"}},

		(* If the user has specified the PrimaryData, but only the primary data, we accept it *)
		{True,False,False,_},
			{Scale->resolvedScale},

		(* If the user has specified the Scale and only the Scale, we accept it, include frame label based on AssayType *)
		{False,True,False,SizingPolydispersity},
			{PrimaryData->resolvedPrimaryData,FrameLabel->{"Particle Size (nm)", "Intensity (AU)"}},
		{False,True,False,IsothermalStability},
			{PrimaryData->resolvedPrimaryData,FrameLabel->{"Time (s)", "Z-Average Diameter (nm)"}},
		{False,True,False,B22kD},
			{PrimaryData->resolvedPrimaryData,FrameLabel->{"Mass Concentration (mg/mL)", "Diffusion Coefficient (sq.m./s)"}},
		{False,True,False,G22},
			{PrimaryData->resolvedPrimaryData,FrameLabel->{"Mass Concentration (mg/mL)", "Kirkwood-Buff Integral (mL/g)"}},

		(* If the user has specified the FrameLabel and only the frame label, we accept it *)
		{False,False,True,_},
			{PrimaryData->resolvedPrimaryData,Scale->resolvedScale},

		(* If the user has specified both the PrimaryData and Scale, we do nothing *)
		{True,True,_,_},
			{},

		(* If the user has specified the PrimaryData and the Frame label, we include the Scale *)
		{True,False,True,_},
			{Scale->resolvedScale},

		(* If the user has specified the Scale and the Frame label, we include the PrimaryData *)
		{False,True,True,_},
			{PrimaryData->resolvedPrimaryData},

		(* Catch all that shouldn't come up *)
		{_,_,_,_},
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
