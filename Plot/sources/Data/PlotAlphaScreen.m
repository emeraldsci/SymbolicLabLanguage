(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAlphaScreen*)


DefineOptions[PlotAlphaScreen,
	Options :> {
		{
			OptionName->DataSet,
			Default->Intensity,
			Description->"Determines which field to use as the source of data in the data object.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[Intensity]],
			Category->"Data Processing"
		},
		{
			OptionName->PlotType,
			Default->Automatic,
			Description->"Determines if Histograms, BoxWhiskerCharts, BarCharts or ScatterPlot are desired for the data.  If Automatic, for a single list of intensities Histogram is assumed, and a list of list assumes BoxWhiskerChart. ScatterPlot is only used when a list of secondary variable values is provided in the input.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:> Histogram | BoxWhiskerChart | BarChart | ScatterPlot],
			Category->"Plot Style"
		},
		{
			OptionName->TargetUnits,
			Default->Automatic,
			Description-> "Intensity Units to be used in the plot.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[RLU,Kilo*RLU,Milli*RLU,Micro*RLU,Centi*RLU]],
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
		EmeraldHistogram,
		EmeraldListLinePlot
	}
];


resolveAlphaScreenPlotType[plotType:(Histogram|BarChart|BoxWhiskerChart),in_]:=plotType;
resolveAlphaScreenPlotType[Automatic,QuantityArrayP[1]]:=Histogram;
resolveAlphaScreenPlotType[Automatic,{QuantityArrayP[1]..}]:=BoxWhiskerChart;
resolveAlphaScreenPlotType[Automatic,QuantityArrayP[2]]:=BoxWhiskerChart;
resolveAlphaScreenPlotType[Automatic,{Except[_List]..}]:=Histogram;
resolveAlphaScreenPlotType[Automatic,{{Except[_List]..}..}]:=BoxWhiskerChart;

PlotAlphaScreen[in:ListableP[{(_?NumericQ|_?(UnitsQ[#,RLU]&))..}|QuantityArrayP[{RLU..}]]|QuantityArrayP[{{RLU..}..}],ops:OptionsPattern[]]:= Module[
	{safeOps, plotType, plot, mostlyResolvedOptions,resolvedOptions, output},
	safeOps = SafeOptions[PlotAlphaScreen, ToList[ops]];
	plotType = resolveAlphaScreenPlotType[Lookup[safeOps,PlotType],in];
	output = Lookup[safeOps,Output];
	{plot, mostlyResolvedOptions}=Switch[plotType,
		Histogram, plotAlphaScreenHistogram[in,ReplaceRule[safeOps, {Output->{Result,Options}}]],
		BarChart, plotAlphaScreenBarChart[in,ReplaceRule[safeOps, {Output->{Result,Options}}]],
		BoxWhiskerChart, plotAlphaScreenBoxWhiskerChart[in,ReplaceRule[safeOps, {Output->{Result,Options}}]]
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
plotAlphaScreenHistogram[in_,safeOps_List]:=Module[
	{unresolvedLegend,resolvedLegend},

	(* --- Legend --- *)
	unresolvedLegend =  Lookup[safeOps,Legend];
	resolvedLegend = Core`Private`resolvePlotLegends[unresolvedLegend,PassOptions[PlotAlphaScreen,Core`Private`resolvePlotLegends,safeOps]];

	(* Plot the data as a histogram *)
	EmeraldHistogram[in,
		ChartLegends-> resolvedLegend,
		PassOptions[PlotAlphaScreen,EmeraldHistogram,safeOps]
	]

];


(* Core function for BoxWhiskerChart *)
plotAlphaScreenBoxWhiskerChart[in_,safeOps_List]:=Module[
	{boxWhiskerType,unresolvedLegend,resolvedLegend},

	boxWhiskerType = Lookup[safeOps,BoxWhiskerType];

	(* --- Legend --- *)
	unresolvedLegend = Lookup[safeOps,Legend];
	resolvedLegend = Core`Private`resolvePlotLegends[unresolvedLegend,PassOptions[PlotAlphaScreen,Core`Private`resolvePlotLegends,safeOps]];

	(* Plot the data *)
	EmeraldBoxWhiskerChart[in,boxWhiskerType,
		ChartElementFunction->"BoxWhisker",
		ChartLegends-> resolvedLegend,
		PassOptions[PlotAlphaScreen,EmeraldBoxWhiskerChart,safeOps]
	]

];


(* Core function for Barchart *)
plotAlphaScreenBarChart[in_,safeOps_List]:=Module[
	{unresolvedLegend,resolvedLegend},

	(* --- Legend --- *)
	unresolvedLegend = Lookup[safeOps,Legend];
	resolvedLegend = Core`Private`resolvePlotLegends[unresolvedLegend,PassOptions[PlotAlphaScreen,Core`Private`resolvePlotLegends,safeOps]];

	(* Plot the data *)
	EmeraldBarChart[in,
		ChartLabels -> resolvedLegend,
		PlotRangeClipping -> True,
		PassOptions[PlotAlphaScreen,EmeraldBarChart,safeOps]
	]

];

(* scatter plot overload *)
Warning::ScatterPlotOverride="When a secondary variable is given with AlphaScreen data in PlotAlphaScreen, only ScatterPlot can be plotted. The specified PlotType `1` will be ignored.";
Error::InputDifferentLength="The group of AlphaScreen data has a length of `1`, but the group of the secondary variable has a length of `2`. Please make sure they have same length.";
Error::DataEntriesDifferentLength="The group of AlphaScreen data has a length of `1`, but the group of the secondary variable has a length of `2`. Please make sure they have same length.";
Error::NoAlphaScreenDataToPlot = "The protocol object does not contain any associated alpha screen data.";
Error::AlphaScreenProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotAlphaScreen or PlotObject on an individual data object to identify the missing values.";


PlotAlphaScreen[in:ListableP[{(_?NumericQ|_?(UnitsQ[#,RLU]&))..}|QuantityArrayP[{RLU..}]]|QuantityArrayP[{{RLU..}..}],xValues:ListableP[{(_?NumericQ|_?QuantityQ)..}|QuantityArrayP[]],ops:OptionsPattern[]]:= Module[
	{safeOps, plotType, plot, mostlyResolvedOptions,resolvedOptions, output},
	safeOps = SafeOptions[PlotAlphaScreen, ToList[ops]];
	plotType = Lookup[safeOps,PlotType];
	output = Lookup[safeOps,Output];

	(* when two input are provided to the function, the plot type should be ScatterPlot *)
	(* if it is not ScatterPlot, throw a warning; and continue assuming doing ScatterPlot *)
	If[MatchQ[plotType,Except[Automatic|ScatterPlot]],
		Message[Warning::ScatterPlotOverride,plotType]
	];

	(* if two input lists have different length, throw and error *)
	If[!MatchQ[Length[in],Length[xValues]],
		Message[Error::InputDifferentLength,Length[in],Length[xValues]];
		Return[$Failed],
		Nothing
	];

	{plot, mostlyResolvedOptions}=plotAlphaScreenScatter[in,xValues,ReplaceRule[safeOps, {Output->{Result,Options}}]];

	resolvedOptions = ReplaceRule[safeOps,FilterRules[Join[mostlyResolvedOptions,{PlotType->ScatterPlot}],Except[Output]],Append->False];
	output/.{
		Result->plot,
		Preview->Show[plot,ImageSize->Full],
		Options->resolvedOptions,
		Tests->{}
	}
];

(* Core function for scatter plot *)
(* single group overload *)
plotAlphaScreenScatter[in:{(_?NumericQ|_?(UnitsQ[#,RLU]&))..}|QuantityArrayP[{RLU..}],xValue:{(_?NumericQ|_?QuantityQ)..}|QuantityArrayP[],safeOps_List]:=plotAlphaScreenScatter[{in},{xValue},safeOps];

plotAlphaScreenScatter[in:{{(_?NumericQ|_?(UnitsQ[#,RLU]&))..}..}| {QuantityArrayP[{RLU..}]..},xValues: {{(_?NumericQ | _?QuantityQ)..}..}| {QuantityArrayP[]..},safeOps_List]:=Module[
	{unresolvedLegend,resolvedLegend,sameLengthQ,xyDatas},

	(* --- Legend --- *)
	unresolvedLegend = Lookup[safeOps,Legend];
	resolvedLegend = Core`Private`resolvePlotLegends[unresolvedLegend,PassOptions[PlotAlphaScreen,Core`Private`resolvePlotLegends,safeOps]];

	(* Check if x and y values have same lengths *)
	sameLengthQ=MapThread[Function[{yValue, xValue},
		Length[yValue]==Length[xValue]
	],{in,xValues}];

	(* Throw an error if any of the data set have different length *)
	If[MemberQ[sameLengthQ,False],
		Message[Error::DataEntriesDifferentLength,PickList[in,sameLengthQ,False],PickList[xValues,sameLengthQ,False]];
		Return[$Failed],
		Nothing
	];

	(* Transpose the input to match the pattern for EmeraldListLinePlot *)
	xyDatas=MapThread[Function[{yData, xData},
		Transpose[{xData,yData}]
	],{in,xValues}];

	(* Plot the data *)
	EmeraldListLinePlot[xyDatas,
		Legend -> resolvedLegend,
		PlotRangeClipping -> True,
		PassOptions[PlotAlphaScreen,EmeraldListLinePlot,safeOps]
	]

];


(* --- SLL Data --- *)

(* protocol overload *)
PlotAlphaScreen[
	obj: ObjectP[Object[Protocol, AlphaScreen]],
	ops: OptionsPattern[PlotAlphaScreen]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotAlphaScreen, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, AlphaScreen]]..}],
		Message[Error::NoAlphaScreenDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotAlphaScreen[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotAlphaScreen[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::AlphaScreenProtocolDataNotPlotted];
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

PlotAlphaScreen[datas:ObjectP[Object[Data,AlphaScreen]],ops:OptionsPattern[]]:=PlotAlphaScreen[{datas},ops];

PlotAlphaScreen[datas:{ObjectP[Object[Data,AlphaScreen]]..},ops:OptionsPattern[]]:=Module[
	{safeOps,dataFieldName,packets,intensities},

	(* get safeOps *)
	safeOps = SafeOptions[PlotAlphaScreen, ToList[ops]];
	{dataFieldName} = Lookup[safeOps,{DataSet}];

	(* For each data object get value at data set, emission wavelengths *)
	packets=Download[datas,Packet[dataFieldName]];

	intensities=Lookup[#,dataFieldName]&/@packets;

	If[!MatchQ[intensities,{UnitsP[]...}],
		$Failed,
		PlotAlphaScreen[intensities,safeOps]
	]
];

PlotAlphaScreen[datas:{{ObjectP[Object[Data,AlphaScreen]]..}..},ops:OptionsPattern[]]:=Module[
	{safeOps,dataFieldName,packetsLists,intensities},

	(* get safeOps *)
	safeOps = SafeOptions[PlotAlphaScreen, ToList[ops]];
	{dataFieldName} = Lookup[safeOps,{DataSet}];

	(* For each data object get value at data set, emission wavelengths *)
	packetsLists=Download[datas,Packet[dataFieldName]];

	intensities=Map[
		Function[packets,Lookup[#,dataFieldName]&/@packets],
		packetsLists,
		{1}
	];

	If[!MatchQ[intensities,{{UnitsP[]...}...}],
		$Failed,
		PlotAlphaScreen[intensities,safeOps]
	]
];

(* ScatterPlot overload *)
PlotAlphaScreen[datas:{ObjectP[Object[Data,AlphaScreen]]..},xValues:{(_?NumericQ|_?QuantityQ)..}|QuantityArrayP[],ops:OptionsPattern[]]:=Module[
	{safeOps,dataFieldName,packets,intensities},

	(* get safeOps *)
	safeOps = SafeOptions[PlotAlphaScreen, ToList[ops]];
	{dataFieldName} = Lookup[safeOps,{DataSet}];

	(* For each data object get value at data set, emission wavelengths *)
	packets=Download[datas,Packet[dataFieldName]];

	intensities=Lookup[#,dataFieldName]&/@packets;

	If[!MatchQ[intensities,{UnitsP[]...}],
		$Failed,
		PlotAlphaScreen[intensities,xValues,safeOps]
	]
];

PlotAlphaScreen[datas:{{ObjectP[Object[Data,AlphaScreen]]..}..},xValues:{{(_?NumericQ | _?QuantityQ)..}..}| {QuantityArrayP[]..},ops:OptionsPattern[]]:=Module[
	{safeOps,dataFieldName,packetsLists,intensities},

	(* get safeOps *)
	safeOps = SafeOptions[PlotAlphaScreen, ToList[ops]];
	{dataFieldName} = Lookup[safeOps,{DataSet}];

	(* For each data object get value at data set, emission wavelengths *)
	packetsLists=Download[datas,Packet[dataFieldName]];

	intensities=Map[
		Function[packets,Lookup[#,dataFieldName]&/@packets],
		packetsLists,
		{1}
	];

	If[!MatchQ[intensities,{{UnitsP[]...}...}],
		$Failed,
		PlotAlphaScreen[intensities,safeOps]
	]
];

