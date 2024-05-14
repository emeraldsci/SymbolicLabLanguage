(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFluorescenceIntensity*)


DefineOptions[PlotFluorescenceIntensity,
	Options :> {
		{
			OptionName-> ExcitationWavelength,
			Default->Automatic,
			Description->"Indicates that only data generated using this excitation wavelength should be plotted.",
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> RangeP[0Nanometer,1000Nanometer], Units->Nanometer],
			Category->"Data Processing"
		},
		{
			OptionName->EmissionWavelength,
			Default->Automatic,
			Description->"Indicates that only data generated using this emission wavelength should be plotted.",
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> RangeP[0Nanometer,1000Nanometer], Units->Nanometer],
			Category->"Data Processing"
		},
		{
			OptionName->DataSet,
			Default->Intensities,
			Description->"Determines which field to use as the source of data in the data object.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Intensities|DualEmissionIntensities],
			Category->"Data Processing"
		},
		{
			OptionName->PlotType,
			Default->Automatic,
			Description->"Determines if Histograms, BoxWiskerCharts, or BarCharts are desired for the data.  If Automatic, for a single list of intensities Histogram is assumed, and a list of list assumes BoxWiskerChart.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:> Histogram | BoxWhiskerChart | BarChart],
			Category->"Plot Style"
		},
		{
			OptionName->TargetUnits,
			Default->Automatic,
			Description-> "Intensity Units to be used in the plot.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[RFU,Kilo*RFU,Milli*RFU,Micro*RFU,Centi*RFU]],
			Category->"Plot Style"
		},
		{
			OptionName->Legend,
			Default->None,
			Description->"List of text descriptions of each data set in the plot.",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type -> String, Pattern :> ListableP[_?StringQ], Size -> Line],
				Widget[Type->Enumeration, Pattern:>Null|None]
			],
			Category->"Legend"
		},
		{
			OptionName->BoxWhiskerType,
			Default->"Outliers",
			Description->"The style defining the box and whisker plot.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>"Notched" | "Outliers" | "Median" | "Basic" | "Mean" | "Diamond"],
			Category->"Plot Style"
		},
		{
			OptionName->ChartLabels,
			Default->None,
			Description->"List of labels to provide for each box category in the BoxWhisker plot type.",
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->String, Pattern:> ListableP[_?StringQ], Size-> Line],
				Widget[Type->Enumeration, Pattern:> Alternatives[None]]
			],
			Category->"Plot Labeling"
		}
	},
	SharedOptions :> {
		EmeraldBoxWhiskerChart,
		EmeraldHistogram
	}
];


Error::MismatchedWavelengthsAndIntensities="The intensity readings and emission wavelengths are different lengths in `1` and so the wavelength associated with a given intensity cannot be determined. Please ValidObjectQ on your data objects to verify it is correct. You can also directly send the intensities you wish to plot.";
Warning::DuplicateWavelengths="Multiple intensity readings at the requested wavelength were found for `1`. The first reading will be shown.";
Error::NoDataAtWavelength="No data appears to have been recorded at the requested wavelength. Please check the EmissionWavelengths field of `1` to see the wavelengths at which data was recorded.";


resolveFluorescenceIntensityPlotType[plotType:(Histogram|BarChart|BoxWhiskerChart),in_]:=plotType;
resolveFluorescenceIntensityPlotType[Automatic,QuantityArrayP[1]]:=Histogram;
resolveFluorescenceIntensityPlotType[Automatic,{QuantityArrayP[1]..}]:=BoxWhiskerChart;
resolveFluorescenceIntensityPlotType[Automatic,QuantityArrayP[2]]:=BoxWhiskerChart;
resolveFluorescenceIntensityPlotType[Automatic,{Except[_List]..}]:=Histogram;
resolveFluorescenceIntensityPlotType[Automatic,{{Except[_List]..}..}]:=BoxWhiskerChart;

PlotFluorescenceIntensity[in:ListableP[{(_?NumericQ|_?FluorescenceQ)..}|QuantityArrayP[{RFU..}]]|QuantityArrayP[{{RFU..}..}],ops:OptionsPattern[]]:= Module[
	{safeOps, plotType, plot, mostlyResolvedOptions,resolvedOptions, output},
	safeOps = SafeOptions[PlotFluorescenceIntensity, ToList[ops]];
	plotType = resolveFluorescenceIntensityPlotType[Lookup[safeOps,PlotType],in];
	output = Lookup[safeOps,Output];
	{plot, mostlyResolvedOptions}=Switch[plotType,
		Histogram, plotFluorescenceIntensityHistogram[in,ReplaceRule[safeOps, {Output->{Result,Options}}]],
		BarChart, plotFluorescenceIntensityBarChart[in,ReplaceRule[safeOps, {Output->{Result,Options}}]],
		BoxWhiskerChart, plotFluorescenceIntensityBoxWhiskerChart[in,ReplaceRule[safeOps, {Output->{Result,Options}}]]
	];
	resolvedOptions = ReplaceRule[safeOps,FilterRules[Join[mostlyResolvedOptions,{PlotType->plotType}],Except[Output]],Append->False];
	output/.{
		Result->plot,
		Preview->Show[plot,ImageSize->Full],
		Options->resolvedOptions,
		Tests->{}
	}
];


(* Core function for Histogram *)
plotFluorescenceIntensityHistogram[in_,safeOps_List]:=Module[
	{unresolvedLegend,resolvedLegend},

	(* --- Legend --- *)
	unresolvedLegend =  Lookup[safeOps,Legend];
	resolvedLegend = Core`Private`resolvePlotLegends[unresolvedLegend,PassOptions[PlotFluorescenceIntensity,Core`Private`resolvePlotLegends,safeOps]];

	(* Plot the data as a histogram *)
	EmeraldHistogram[in,
		ChartLegends-> resolvedLegend,
		PassOptions[PlotFluorescenceIntensity,EmeraldHistogram,safeOps]
	]

];


(* Core function for BoxWhiskerChart *)
plotFluorescenceIntensityBoxWhiskerChart[in_,safeOps_List]:=Module[
	{boxWhiskerType,unresolvedLegend,resolvedLegend},

	boxWhiskerType = Lookup[safeOps,BoxWhiskerType];

	(* --- Legend --- *)
	unresolvedLegend = Lookup[safeOps,Legend];
	resolvedLegend = Core`Private`resolvePlotLegends[unresolvedLegend,PassOptions[PlotFluorescenceIntensity,Core`Private`resolvePlotLegends,safeOps]];

	(* Plot the data *)
	EmeraldBoxWhiskerChart[in,boxWhiskerType,
		ChartElementFunction->"BoxWhisker",
		ChartLegends-> resolvedLegend,
		PassOptions[PlotFluorescenceIntensity,EmeraldBoxWhiskerChart,safeOps]
	]

];


(* Core function for Barchart *)
plotFluorescenceIntensityBarChart[in_,safeOps_List]:=Module[
	{unresolvedLegend,resolvedLegend},

	(* --- Legend --- *)
	unresolvedLegend = Lookup[safeOps,Legend];
	resolvedLegend = Core`Private`resolvePlotLegends[unresolvedLegend,PassOptions[PlotFluorescenceIntensity,Core`Private`resolvePlotLegends,safeOps]];

	(* Plot the data *)
	EmeraldBarChart[in,
		ChartLabels -> resolvedLegend,
		PlotRangeClipping -> True,
		PassOptions[PlotFluorescenceIntensity,EmeraldBarChart,safeOps]
	]

];


(* --- SLL Data --- *)
PlotFluorescenceIntensity[datas:ObjectP[Object[Data,FluorescenceIntensity]],ops:OptionsPattern[]]:=PlotFluorescenceIntensity[{datas},ops];

PlotFluorescenceIntensity[datas:{ObjectP[Object[Data,FluorescenceIntensity]]..},ops:OptionsPattern[]]:=Module[
	{safeOps,dataFieldName,requestedExcitationWavelength,requestedEmissionWavelength,packets,excitationWavelength,emissionWavelength,intensities},

	(* get safeOps *)
	safeOps = SafeOptions[PlotFluorescenceIntensity, ToList[ops]];
	{dataFieldName,requestedExcitationWavelength,requestedEmissionWavelength} = Lookup[safeOps,{DataSet,ExcitationWavelength,EmissionWavelength}];

	(* For each data object get value at data set, emission wavelengths *)
	packets=Download[datas,Packet[dataFieldName,ExcitationWavelengths,EmissionWavelengths]];

	(* Use the first wavelength if unspecified *)
	excitationWavelength = If[MatchQ[requestedExcitationWavelength,Automatic],
		First[Lookup[packets[[1]],ExcitationWavelengths],Null],
		requestedExcitationWavelength
	];
	emissionWavelength = If[MatchQ[requestedEmissionWavelength,Automatic],
		First[Lookup[packets[[1]],EmissionWavelengths],Null],
		requestedEmissionWavelength
	];

	intensities=intensityAtWavelength[#,excitationWavelength,emissionWavelength,dataFieldName]&/@packets;

	If[!MatchQ[intensities,{UnitsP[]...}],
		$Failed,
		PlotFluorescenceIntensity[intensities, Sequence@@ReplaceRule[safeOps,{ExcitationWavelength->excitationWavelength, EmissionWavelength->emissionWavelength}]]
	]
];

PlotFluorescenceIntensity[datas:{{ObjectP[Object[Data,FluorescenceIntensity]]..}..},ops:OptionsPattern[]]:=Module[
	{safeOps,dataFieldName,requestedExcitationWavelength,requestedEmissionWavelength,packetsLists,excitationWavelength,emissionWavelength,intensities},

	(* get safeOps *)
	safeOps = SafeOptions[PlotFluorescenceIntensity, ToList[ops]];
	{dataFieldName,requestedExcitationWavelength,requestedEmissionWavelength} = Lookup[safeOps,{DataSet,ExcitationWavelength,EmissionWavelength}];

	(* For each data object get value at data set, emission wavelengths *)
	packetsLists=Download[datas,Packet[dataFieldName,EmissionWavelengths,ExcitationWavelengths]];

	(* Use the first wavelength if unspecified *)
	excitationWavelength = If[MatchQ[requestedExcitationWavelength,Automatic],
		First[Lookup[packetsLists[[1,1]],ExcitationWavelengths],Null],
		requestedExcitationWavelength
	];
	emissionWavelength = If[MatchQ[requestedEmissionWavelength,Automatic],
		First[Lookup[packetsLists[[1,1]],EmissionWavelengths],Null],
		requestedEmissionWavelength
	];

	intensities=Map[
		Function[packets,intensityAtWavelength[#,excitationWavelength,emissionWavelength,dataFieldName]&/@packets],
		packetsLists,
		{1}
	];

	If[!MatchQ[intensities,{{UnitsP[]...}...}],
		$Failed,
		PlotFluorescenceIntensity[intensities,  Sequence@@ReplaceRule[safeOps,{ExcitationWavelength->excitationWavelength, EmissionWavelength->emissionWavelength}]]
	]
];


(*
	intensityAtWavelength - returns the data value in the requested field (data will be extracted at the requested wavelength if a multiple is requested)
		Inputs:
			packet:PacketP[Object[Data,FluorescenceIntensity]] - packet for which data is being plotted
			excitationWavelength:DistanceP - excitation wavelength for which intensity should be shown
			emissionWavelength:DistanceP - emission wavelength for which intensity should be shown
			dataFieldName:_Symbol - field which should be pulled from Object[Data,FluorescenceIntensity] and plotted (e.g. Intensities, DualEmissionIntensities)
		Outputs:
			dataValue:UnitsP - value of the field
*)
intensityAtWavelength[packet_,excitationWavelength_,emissionWavelength_,dataFieldName_]:=Module[{object,dataFieldValue,excitationWavelengths,emissionWavelengths},

	(* Get field we're plotting and corresponding emission *)
	{object,dataFieldValue,excitationWavelengths,emissionWavelengths}=Lookup[packet,{Object,dataFieldName,ExcitationWavelengths,EmissionWavelengths}];

	(* Extract intensity corresponding to requested wavelength *)
	If[ListQ[dataFieldValue],
		If[SameLengthQ[dataFieldValue,excitationWavelengths,emissionWavelengths],
			Module[{valuesAtWavelength},

				(* Intensities at the wavelength *)
				valuesAtWavelength=MapThread[
					(* Use Round since out of database numbers will come with extra precision - e.g. 620.` *)
					If[MatchQ[Round[#2],Round[excitationWavelength]]&&MatchQ[Round[#3],Round[emissionWavelength]],
						#1,
						Nothing
					]&,
					{dataFieldValue,excitationWavelengths,emissionWavelengths}
				];

				(* We only expect to find one reading per wavelength, indicate if we found multiple matches *)
				Which[
					Length[valuesAtWavelength]==0,Message[Error::NoDataAtWavelength,Object];$Failed,
					Length[valuesAtWavelength]>1,Message[Warning::DuplicateWavelengths,Object];FirstOrDefault[valuesAtWavelength],
					True,FirstOrDefault[valuesAtWavelength]
				]
			],
			(* Error if wavelength/intensity are not index-matched as expected *)
			Message[Error::MismatchedWavelengthsAndIntensities,Object];$Failed
		],
		(* Already a single - no need to find value of interest *)
		dataFieldValue
	]
];
