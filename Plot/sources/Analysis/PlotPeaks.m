(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*PlotPeaks*)


DefineOptions[PlotPeaks,
	Options :> {
		(*** Peaks Options ***)
		{
			OptionName->Display,
			Default->Purity,
			Description->"The type of peak information to be plotted. Purity and Area can be plotted as either a barchart or a piechart.  Height and HalfHeightWidth will only be plotted as a barchart.",
			AllowNull->False,
			Category->"Peaks",
			Widget->Widget[Type->Enumeration,Pattern:>Purity|Area|Height|HalfHeightWidth]
		},
		{
			OptionName->PlotType,
			Default->Automatic,
			Description->"Specify what type of plot to use when plotting peaks.",
			ResolutionDescription->"If Automatic, a piechart will be plotted if Display is set to either Purity or Area, and a barchart will be plotted if Display is set to either Height or HalfHeightWidth.",
			AllowNull->False,
			Category->"Peaks",
			Widget->Widget[Type->Enumeration,Pattern:>BarChart|PieChart|Preview]
		},
		{
			OptionName->Peaks,
			Default->All,
			Description->"Specify which peaks should be plotted by index. If a pair of indices or listed indices is provided, the first will be plotted normalized against the second.",
			AllowNull->False,
			Category->"Peaks",
			Widget->Alternatives[
				"All Peaks"->Widget[Type->Enumeration,Pattern:>Alternatives[All]],
				"Single Index"->Widget[Type->Number,Pattern:>GreaterP[0,1],PatternTooltip->"Positive integer index of peaks to plot."],
				"Multiple Indices"->Adder[Widget[Type->Number,Pattern:>GreaterP[0,1],PatternTooltip->"Positive integer index of peaks to plot."]],
				"Normalized Peaks"->{""->{
					"Plot"->Widget[Type->Expression,Pattern:>(All|_Integer|{_Integer..}),Size->Line,PatternTooltip->"Either All, or a list of positive integer indices."],
					"Normalized To"->Widget[Type->Expression,Pattern:>(All|_Integer|{_Integer..}),Size->Line,PatternTooltip->"Either All, or a list of positive integer indices."]
				}}
			]
		},

		(*** Plot Labeling ***)
		{
			OptionName->ChartLabels,
			Default->Automatic,
			Description->"Specify the labels to add to the peaks piechart or barchart.",
			ResolutionDescription->"If Automatic, the labels for the chart will be the peak indices.",
			AllowNull->False,
			Category->"Plot Labeling",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				"Specify Labels"->Adder[Alternatives[
					"Integer"->Widget[Type->Number,Pattern:>GreaterP[0,1]],
					"String"->Widget[Type->String,Pattern:>_String,Size->Word]
				]]
			]
		},
		{
			OptionName->ChartLabelOrientation,
			Default->Automatic,
			Description->"Sets the orientation of the labels below each bar in a barchart.",
			ResolutionDescription->"If Automatic, and the ChartLabels are integers, the orientation will resolve to Horizontal. If the ChartLabels are strings, the orientation will resolve to Vertical.",
			AllowNull->True,
			Category->"Plot Labeling",
			Widget->Widget[Type->Enumeration,Pattern:>Horizontal|Vertical]
		},
		{
			OptionName -> ChartLabelStyle,
			Default -> {14,Bold,FontFamily->"Arial"},
			Description -> "The styling which should be used for chart labels.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget ->Alternatives[
				"Color"->Widget[Type->Enumeration,Pattern:>Alternatives[Red,Green,Blue,Black,White,Gray,Cyan,Magenta,Yellow,Brown,Orange,Pink,Purple]],
				{
					"Font Size"->Widget[Type->Number,Pattern:>GreaterP[0]],
					"Font Type"->Alternatives[
						Widget[Type->Expression,Pattern:>_,Size->Line],
						Widget[Type->Enumeration,Pattern:>Alternatives[Bold,Italic,Underlined]],
						Widget[Type->Color,Pattern:>ColorP]
					],
					"Font Family"->Alternatives[
						Widget[Type->Expression,Pattern:>_Rule,Size->Line,PatternTooltip->"The font family of the label, in the form FontFamily->_String."]
					]
				},
				Widget[Type -> Expression, Pattern :>_, Size -> Line, PatternTooltip->"The LabelStyle can be set to any valid graphics directive. Evaluate ?LabelStyle in the notebook for more information."]
			]
		},

		(* Change defaults of these options *)
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->ImageSize,Default->500},
				{OptionName->AspectRatio,Default->Automatic},
				{OptionName->Frame,Default->Automatic}
			}
		],
		ModifyOptions[LegendOption,Default->None,Category->"Hidden"],
		ModifyOptions[LegendPlacementOption,Default->Right,Category->"Hidden"],
		ModifyOptions[BoxesOption,Default->True,Category->"Hidden"],

		(* Hide these options *)
		ModifyOptions[EmeraldPieChart,
			{SectorOrigin,ChartBaseStyle,ChartLayout,LabelStyle},
			Category->"Hidden"
		]
	},
	SharedOptions:>{
		EmeraldPieChart,
		{EmeraldBarChart,{BarSpacing,ErrorBars,ErrorType,FrameUnits,Zoomable}}
	}
];


PlotPeaks::DifferentDataFamilies="Your provided input, `1`, is a mix of various data families: `2`.  The PlotPeaks function can only plot one data family at a time.";
PlotPeaks::NoPeaks="One or more of your inputs does not have picked peaks.  Please use the peaks function to pick peaks for your data or exclude your data from plotting if no peaks can be picked.";
PlotPeaks::TooFewPeaks="Your provided input, `1`, has fewer picked peaks than required by your Peaks option.  Defaulting to `2`.";
PlotPeaks::DeprecatedOptions="The options, `1`, are deprecated and were removed from the analysis."


(* --- helper function to pull the peak objects out of the data objects --- *)
getPeaksFromData[dataObj:ListableP[PacketP[Object[Data]],2],opts:OptionsPattern[PlotPeaks]]:=Module[
	{peakField,peaksID},

	(* figure out which type of peaks we are dealing with so we can pull them out of the data object *)
	peakField=FirstOrDefault[LegacySLL`Private`typeToPeaksSourceFields[First[Flatten[ToList[Type/.dataObj]]]]];

	(* pull out the peaks and peak data *)
	peaksID = Switch[dataObj,
		PacketP[Object[Data]],LastOrDefault[peakField/.dataObj],
		{PacketP[Object[Data]]..},Last/@(peakField/.dataObj),
		{{PacketP[Object[Data]]..}..},(Last/@#)&/@(peakField/.dataObj)
	]
];


(* --- helper function to pull the peak objects out of the analysis objects --- *)
getPeaksFromAnalysis[peaksObj:PacketP[Object[Analysis,Peaks]],display:(Purity|Area|Height|HalfHeightWidth),peaksIndexRaw:(All|ListableP[_Integer])]:=Module[
	{peaksToDisplay,peaksIndex},

	(* pull all of the peaks data to be displayed out of the Object[Analysis,Peaks] object *)
	peaksToDisplay = If[MatchQ[display,Purity],
		Unitless[(RelativeArea/.(display/.peaksObj))],
		(display/.peaksObj)
	];

	(* if the peaks data is empty, we must return an error message *)
	If[MatchQ[peaksToDisplay,{}],
		Message[PlotPeaks::NoPeaks,Object/.peaksObj];
		Return[]
	];

	(* check that if the raw peaks index is not All, that there are not fewer peaks in the object than required by the raw peaks index *)
	peaksIndex = Switch[peaksIndexRaw,
		(* if the peak index is all, we can just use that *)
		All,peaksIndexRaw,
		(* if the peak index is an integer greater than the length of the peak list, pull out the last peak in the list, and otherwise use the peak index *)
		_Integer,If[peaksIndexRaw>Length[peaksToDisplay],
			Message[PlotPeaks::TooFewPeaks,Object/.peaksObj,"using the last peak in the list"];
			Length[peaksToDisplay],
			peaksIndexRaw
		],
		(* if the peak index is a list of integers, the max of which is greater than the length of the peak list, default to pulling all the peaks, and otherwise use the peak index *)
		{_Integer..},If[Max[peaksIndexRaw]>Length[peaksToDisplay],
			Message[PlotPeaks::TooFewPeaks,Object/.peaksObj,"Peaks->All"];
			All,
			peaksIndexRaw
		]
	];

	peaksToDisplay[[peaksIndex]]

];

getPeaksFromAnalysis[peaksObj:({PacketP[Object[Analysis,Peaks]]..}|{{PacketP[Object[Analysis,Peaks]]..}..}),display:(Purity|Area|Height|HalfHeightWidth),peaksIndexRaw:(All|ListableP[_Integer])]:=
	getPeaksFromAnalysis[#,display,peaksIndexRaw]&/@peaksObj;


(* helper function to decide whether to pass off to a pie chart or a bar chart based on options *)
barOrPieChart[purity:(ListableP[PacketP[Object[Analysis,Peaks]],2]),displayPattern_,opts:OptionsPattern[PlotPeaks]]:=Module[
	{plotType,display,peaksOpt},

	(* pull out some option values *)
	plotType = OptionValue[PlotType];
	display = OptionValue[Display];
	peaksOpt = OptionValue[Peaks];

	(* based on the above option values, pass off to core function *)
	Switch[plotType,
		Automatic,If[MatchQ[display,displayPattern],
			plotPeaksPieChart[purity,opts],
			If[MatchQ[peaksOpt,All],
				plotPeaksBarChart[purity,opts],
				plotPeaksBarChartSelected[purity,opts]
			]
		],
		PieChart,plotPeaksPieChart[purity,opts],
		BarChart,If[MatchQ[peaksOpt,All],
			plotPeaksBarChart[purity,opts],
			plotPeaksBarChartSelected[purity,opts]
		]
	]
];

(* --- Function that passes off 2 lists of SLL input to internal helpers depending on requested peaks --- *)
PlotPeaks[peaksObjA:ListableP[PacketP[Object[Analysis,Peaks]],2],peaksObjB:ListableP[PacketP[Object[Analysis,Peaks]],2],opts:OptionsPattern[PlotPeaks]]:=
	Module[{passingOptions},
		passingOptions=ReplaceRule[{opts},{Peaks->{{OptionDefault[OptionValue[Peaks],Verbose->False],OptionDefault[OptionValue[Peaks],Verbose->False]}}}];
		Switch[OptionDefault[OptionValue[Peaks],Verbose->False],
			{{All|ListableP[_Integer],All|ListableP[_Integer]}},plotPeaksNormalized[peaksObjA,peaksObjB,opts],
			_Integer|{_Integer..}|All,plotPeaksNormalized[peaksObjA,peaksObjB,passingOptions]
		]
	];

(*PlotPeaks calls AnalyzePeaksPreview to generate the plot.  But since we do not want to include interactive elements
included in the output, we use $fromPlotPeaks to indicate to AnalyzePeaksPreview if it was called from PlotPeaks.  If it is,
then AnalyzePeaksPreview will return the unadorned plot.*)
Plot`Private`$fromPlotPeaks=False;

(* --- Function that passes off SLL input to internal helpers depending on plot type and requested peaks --- *)
PlotPeaks[rawPurity:(ListableP[PacketP[Object[Analysis,Peaks]],2]),opts:OptionsPattern[PlotPeaks]]:=Module[
	{defaultedOptions,purity,display,plotType,resolvedPlotType,peaksOpt,peakType},

	(* default all the options first *)
	defaultedOptions=SafeOptions[PlotPeaks, ToList[opts]];

	(* Strip upload formatting *)
	purity=Analysis`Private`stripAppendReplaceKeyHeads[rawPurity];

	(* flatten purity to avoid issues with double listedness *)
	flattenedPurity = If[MatchQ[Head[purity], List],
		Flatten[purity],
		purity
	];

	(* pull out some option values *)
	display = Display/.defaultedOptions;
	plotType = PlotType/.defaultedOptions;
	peaksOpt = Peaks/.defaultedOptions;

	(* Peak type for each peak packet input, accounting for list dimensions *)
	peakType=purity/.{peakPacket:PacketP[Object[Analysis,Peaks]]:>Lookup[Lookup[peakPacket,ResolvedOptions,{}],ECL`PeakType,Null]};

	(* Short-circuit: If the Peaks analysis was for NMR Data, then set plotType to Spectrum if the Reference field is populated. *)
	resolvedPlotType=If[MatchQ[plotType,Automatic]&&MatchQ[peakType,ListableP[NMR]]&&MatchQ[Lookup[flattenedPurity,Reference,Null],Except[Null|{}]],
		Spectrum,
		plotType
	];

	(* Short-circuit: if PlotType is Spectrum, then overlay peaks over reference data *)
	If[MatchQ[resolvedPlotType,Spectrum],
		Return[plotPeaksWithSpectra[flattenedPurity,Lookup[defaultedOptions,Output]]]
	];

	(* Short-circuit if there is a reference for AnalyzePeaksPreview and PlotType is not specified *)
	resolvedPlotType=If[
		(
			MatchQ[plotType,Automatic]&&
			MatchQ[peakType,Except[ListableP[NMR]]|ListableP[ListableP[Null]]]&&
			MatchQ[Lookup[flattenedPurity, Reference, Null], Except[Null|{}]]
		),

		Preview,
		plotType
	];

	If[MatchQ[resolvedPlotType,Preview],
		Return[analyzePeaksPreview[flattenedPurity,Lookup[defaultedOptions,Output], defaultedOptions]]
	];

	(* pass off to the correct function *)
	Switch[peaksOpt,
		All, barOrPieChart[purity,(Purity|Area),Sequence@@defaultedOptions],
		{{All|ListableP[_Integer],All|ListableP[_Integer]}},plotPeaksNormalized[purity,purity,Sequence@@defaultedOptions],
		{_Integer..},barOrPieChart[purity,Purity,Sequence@@defaultedOptions],
		_Integer,plotPeaksBarChartSelected[purity,Sequence@@defaultedOptions]
	]
];

(* Return the preview from the peaks analysis function *)
analyzePeaksPreview[peaksObj:ListableP[PacketP[Object[Analysis,Peaks]]], output_, plotOptions_]:=Module[
	{referencesAndOptions, references, options, deprecatedPeaksOptions, existingOptions},

	(* batch download or lookup objects *)
	referencesAndOptions = Download[peaksObj,
		{
			Reference,
			UnresolvedOptions
		}
	];

	(* Split the references and options *)
	{references, options}= referenceOptionSplit[referencesAndOptions];

	(* Unused peaks options that will error if passed to peaks *)
	deprecatedPeaksOptions = {
		App, ApplyAll, AppTest, Area, AssignmentTolerance,
		ConsolidateGlobalThreshold, ConsolidateLocalThreshold,
		DefaultParameter, FastTrack, Image, Index, Inform, InvertIntensity,
		KnownSplittings, LadderLengths, LadderPeaks, LadderSizes, Length,
		Method, Number, Options, PeakOptions, PeakSplitting, PlotLabel,
		Reference, ReferencePeak, RelativePeakAssignments, Return, Rotate,
		Smooth, StandardPeaks, StandardSizes, Trim, UnitTest, Width, Window
	};

	(* remove context from deprecated peaks *)
	deprecatedPeaksOptions = SymbolName /@ deprecatedPeaksOptions;
	deprecatedPeaksOptions = Symbol /@ deprecatedPeaksOptions;

	(* Remove null values from options for KeyDrop*)
	options = options/.Null->{};

	(* remove deprecated options *)
	existingOptions = Normal[KeyDrop[#, deprecatedPeaksOptions]]&/@options;

	(* find deprecated options *)
	deprecatedOptions = Complement[Flatten[Keys[options]], Flatten[Keys[existingOptions]]];

	(* warning about those deprecated options *)
	If[Length[deprecatedOptions]>0,
		Message[PlotPeaks::DeprecatedOptions, deprecatedOptions]
	];

	(* update old rule listedness to the current set up *)
	existingOptions = ReplaceAll[
		existingOptions,
		{
			(* Update domain listability *)
			Rule[Domain, {val1_?NumericQ, val2_?NumericQ}] :> Rule[Domain, {{val1, val2}}],
			Rule[Baseline, {baseline_}] :> Rule[Baseline, baseline]
		}
	];

	(* for the baseline option change Global to Domain *)
	existingOptions = ReplaceAll[
		existingOptions,
		{
			(* Global to domain *)
			ECL`GlobalConstant -> ECL`DomainConstant,
  			ECL`GlobalLinear -> ECL`DomainLinear,
			ECL`GlobalNonlinear -> ECL`DomainNonlinear
		}
	];

	(* If output is preview or result show the preview, otherwise return the options and an empty list for test.
	Here we set $fromPlotPeaks=True to let AnalyzePeaksPreview know that the call is coming from PlotPeaks and
	that the returned plot should be free in interactive elements.*)
	Block[{Plot`Private`$fromPlotPeaks=True, pkOpNames = Symbol/@Keys[Options[ECL`AnalyzePeaks]], apkOpNames = Symbol/@Keys[Options[ECL`AdvancedAnalyzePeaks]]},

		(*Instead, try:
		 result = ECL`AnalyzePeaksPreview[references, existingOptions]*)

		result = MapThread[
			If[ ContainsAny[Keys[#2], Complement[apkOpNames,pkOpNames]], (* object came from AdvancedAnalyzePeaks *)
				ECL`AdvancedAnalyzePeaksPreview[#1, FilterRules[Download[#3, ResolvedOptions], {PeakThresholds,UnknownPeakThresholds,ManualPeaks,ExpectedPeaks}]],
				ECL`AnalyzePeaksPreview[#1, #2]
			]&,
			{references, existingOptions, ToList[peaksObj]}
		]

	];

	(* If plot length is > 1, use a tabview, otherwise just return the plot *)
	result = If[Length[result]>1,
		TabView[result],
		First[result]
	];

	(* Set most options to null because AnalyzePeaksPreview does not have many plotting options *)
	resolvedOps=ReplaceRule[plotOptions,
		{
			PlotType->Preview,
			Display->Preview,
			Peaks->All,
			Legend->Null,
			ChartLabels->Null,

			Output->output,
			AspectRatio-> Null,
			Frame->Null,
			ChartStyle->Null,
			ColorFunction->Null,
			PlotRange->Null,
			FrameLabel->Null,
			PolarAxesOrigin->Null,
			PolarTicks->Null,
			AxesOrigin->Null,
			BaselinePosition->Null,
			ColorOutput->Null,
			ContentSelectable->Null,
			CoordinatesToolOptions->Null,
			ImageSizeRaw->Null,
			LabelingSize->Null,
			PlotRangePadding->Null,
			PlotRegion->Null,
			PlotTheme->Null,
			PreserveImageOptions->Null,
			LegendAppearance->Null,
			Method->Null,

			(* Null out options specific to Bar Chart *)
			ChartLabelOrientation->Null,
			BarSpacing->Null,
			ErrorBars->Null,
			ErrorType->Null,
			FrameUnits->Null,
			TargetUnits->Null,
			Zoomable->False,
			SectorOrigin->Null,
			ChartBaseStyle->Null,
			ChartLayout->Null,

			(* Null out options specific to Pie Chart *)
			SectorSpacing->Null,
			ChartElementFunction->Null,
			LabelingFunction -> Null

		},
		Append->True
	];

	output/.{
		Result->result,
		Options->resolvedOps,
		Preview->result,
		Tests->{}
	}

];
(* multiple objects *)
referenceOptionSplit[toSplit:{{{___}..}..}]:={toSplit[[;;,1]], toSplit[[;;,2]]}
referenceOptionSplit[toSplit:{{___}..}]:={toSplit[[;;,1]], toSplit[[;;,2]]}

(* single object *)
referenceOptionSplit[toSplit:{{___},{___}}]:={{toSplit[[1]]}, {toSplit[[2]]}}


(* Overload which Plots SLL input as an overlay/epilog on the data peaks were picked from *)

(* Unwrap a single packet in a list *)
plotPeaksWithSpectra[pkts:{PacketP[Object[Analysis,Peaks]]},output_]:=plotPeaksWithSpectra[First[pkts],output];
(* If multiple objects were provided, generate a slide-view for each plot *)
plotPeaksWithSpectra[pkts:{PacketP[Object[Analysis,Peaks]]..},output_]:=SlideView[plotPeaksWithSpectra[#,output]&/@pkts];
(* For a single Object[Analysis,Peaks] packet, overlay the plot with its data *)
plotPeaksWithSpectra[pkt:PacketP[Object[Analysis,Peaks]],output_]:=Module[
	{dataObject},

	(* Obtain an object reference to the source data *)
	dataObject=Lookup[pkt,Reference];

	(* If the dataObject has a valid plot preview, then overlay peaks. Otherwise, return Failed *)
	If[ValidGraphicsQ[PlotObject[dataObject,Peaks->Null]],
		PlotObject[dataObject,Peaks->pkt,Output->output],
		$Failed
	]
];



(* --- Function that passes off PurityP input to internal helpers depending on plot type --- *)
PlotPeaks[purity:PurityP,opts:OptionsPattern[PlotPeaks]]:=
	Switch[OptionDefault[OptionValue[PlotType],Verbose->False],
		(Automatic|PieChart),plotPeaksPieChart[purity,opts],
		BarChart,plotPeaksBarChart[purity,opts]
	];

(* --- listable PurityP input --- *)
PlotPeaks[purity:{PurityP..},opts:OptionsPattern[PlotPeaks]]:=
	PlotPeaks[#,opts]&/@purity

PlotPeaks[purity:{{PurityP..}..},opts:OptionsPattern[PlotPeaks]]:=
	PlotPeaks[#,opts]&/@purity


(* --- Helper function to make a pie chart from peak purity --- *)
plotPeaksPieChart[purity:PurityP,opts:OptionsPattern[PlotPeaks]]:=Module[
	{
		defaultedOptions,chartLabelsOpt,peaksOptRaw,peaksOpt,areas,relAreas,labels,chartLabels,
		outsideLabel,insideLabel,puritiesToPlot,unresolvedLegend,resolvedLegend,
		result,mostlyResolvedOps,preview,tests,resolvedOps
	},

	(* check that there is a purity to plot as a pie chart at all, and if not, return *)
	If[MatchQ[Area/.purity,{0|0.}],
		Return[Message[PlotPeaks::NoPeaks]]
	];

	(* default all the options first *)
	defaultedOptions=SafeOptions[PlotPeaks,ToList[opts]];

	(* Output option for the builder *)
	output=Lookup[defaultedOptions,Output];

	(* pull out some option values *)
	chartLabelsOpt = ChartLabels/.defaultedOptions;
	peaksOptRaw = Peaks/.defaultedOptions;

	(* if the peaks option is not all, check that there are at least as many peaks in the purity input as are requested by the Peaks option *)
	peaksOpt = If[MatchQ[peaksOptRaw,All],
		peaksOptRaw,
		(* if more peaks are requested than exist, throw an error and default to All, otherwise use the provided option *)
		If[Max[peaksOptRaw]>Length[(Area/.purity)],
			Message[PlotPeaks::TooFewPeaks];
			All,
			peaksOptRaw
		]
	];

	(* pull the areas, relative areas, and labels from the peak purity *)
	areas = ToList[(Area/.purity)[[peaksOpt]]];
	relAreas = ToList[(RelativeArea/.purity)[[peaksOpt]]];
	labels = ToList[(PeakLabels/.purity)[[peaksOpt]]];

	(* Generate the outside label to match the information stored in PeakLabels *)
	chartLabels = If[MatchQ[chartLabelsOpt,Automatic],
		labels,
		ToString/@chartLabelsOpt
	];
	outsideLabel=Style[#,{Bold,FontSize->Scaled[0.05],FontFamily->"Arial"}]&/@chartLabels;

	(* Generate the inside label as a piechart of the absolute area labeled with the unit shorthand of the relative area (%) *)
	puritiesToPlot = MapThread[Labeled[#1,Style[#2,{Bold,FontSize->Scaled[0.06],FontFamily->"Arial"}]]&,{areas,UnitForm[Round[relAreas,0.1]]}];

	(* --- Legend --- *)
	unresolvedLegend = OptionValue[Legend];
	resolvedLegend = Core`Private`resolvePlotLegends[unresolvedLegend,PassOptions[PlotPeaks,Core`Private`resolvePlotLegends,opts]];

	(* plot the pie chart *)
	{result,mostlyResolvedOps,preview,tests}=EmeraldPieChart[puritiesToPlot,
		ReplaceRule[
			ToList@stringOptionsToSymbolOptions[PassOptions[PlotPeaks,EmeraldPieChart,opts]],
			{
				(* Default aspect ratio for PieChart is 1 *)
				AspectRatio->Lookup[defaultedOptions,AspectRatio]/.{Automatic->1},
				Frame->Lookup[defaultedOptions,Frame]/.{Automatic->False},
				(* Always force these options *)
				ChartLabels->Placed[outsideLabel,"RadialCallout"],
				ChartLegends->resolvedLegend,
				ImagePadding->{{50,50},{Automatic,Automatic}},
				Axes->False,
				SectorOrigin->{\[Pi]/2,"Clockwise"},
				Output->{Result,Options,Preview,Tests}
			}
		]
	];

	(* Swap in options from PlotPeaks not present in EmeraldPieChart *)
	resolvedOps=ReplaceRule[mostlyResolvedOps,
		{
			PlotType->PieChart,
			Peaks->peaksOpt,
			Legend->Null,
			ChartLabels->chartLabels,
			Display->Lookup[defaultedOptions,Display]/.{Automatic->Purity},
			Output->output,

			(* Null out options specific to Bar Chart *)
			ChartLabelOrientation->Null,
			BarSpacing->Null,
			ErrorBars->Null,
			ErrorType->Null,
			FrameUnits->Null,
			TargetUnits->Null,
			Zoomable->False
		},
		Append->True
	];

	(* Return the requested output *)
	output/.{
		Result->result,
		Options->resolvedOps,
		Preview->preview/.{Rule[ImageSize,_]:>Rule[ImageSize,Full]},
		Tests->{}
	}

]

(* --- PacketP[Object[Analysis,Peaks]]: purity pie chart plotting --- *)
plotPeaksPieChart[peaksObj: PacketP[Object[Analysis, Peaks]], opts: OptionsPattern[PlotPeaks]] := Module[
	{purityList},
	purityList = packetToPurityFamily[peaksObj];
	Switch[Length[purityList],
		0, Null,
		1, PlotPeaks[purityList[[1]], opts],
		_, Grid[{PlotPeaks[#, opts] & /@ purityList}]
	]
];

plotPeaksPieChart[peaksObj: {PacketP[Object[Analysis, Peaks]]..}, opts: OptionsPattern[PlotPeaks]] :=
	plotPeaksPieChart[#, opts] & /@ peaksObj;

plotPeaksPieChart[peaksObj: {{PacketP[Object[Analysis, Peaks]]..}..}, opts: OptionsPattern[PlotPeaks]] :=
	plotPeaksPieChart[#, opts] & /@ peaksObj;


packetToPurityFamily[pkt: PacketP[Object[Analysis, Peaks]]] := Module[
	{purity, parentList, labels, areas, largestPeakIndex, safeParentList, families},

	(* Download fields of interest from the packet *)
	{purity, parentList, labels, areas} = Lookup[pkt, {Purity, ParentPeak, PeakLabel, Area}];

	(* Index of peak with largest area, needed if no Parent Peaks were supplied *)
	largestPeakIndex=If[MatchQ[areas,Except[Null|{}]],
		FirstPosition[areas, Max[areas]][[1]],
		Null
	];

	(* If the parent list from the packet was empty, default all peaks to use the largest peak as a parent *)
	safeParentList=If[MatchQ[parentList,({}|Null)]&&MatchQ[largestPeakIndex,Except[Null]],
		Repeat[Part[labels,largestPeakIndex],Length[labels]],
		parentList
	];

	(* Construct purity families *)
	families = GroupBy[MapThread[Append[#1, #2] &, {Most[Transpose[Values[purity]]], safeParentList}], Last];

	(* Values from the families *)
	Values[Map[Function[{oneFamily}, MapThread[#1 -> #2 &, {{Area, RelativeArea, PeakLabels}, Transpose[Most /@ oneFamily]}]], families]]
];


(* --- raw numbers core bar chart helper function --- *)
plotPeaksBarChartCore[datas:ListableP[_?NumericQ,3],opts:OptionsPattern[PlotPeaks]]:=Module[
	{
		defaultedOptions,output,labelOrientationOpt,chartLabelOpt,labelOrientation,
		labels,placedLabels,plotDatas,result,mostlyResolvedOps,preview,tests,resolvedOps
	},

	(* default all the options first *)
	defaultedOptions=SafeOptions[PlotPeaks,ToList[opts]];

	(* Output option for the builder *)
	output=Lookup[defaultedOptions,Output];

	(* pull out some option values *)
	labelOrientationOpt = ChartLabelOrientation/.defaultedOptions;
	chartLabelOpt = ChartLabels/.defaultedOptions;

	(* set the chart label orientation *)
	labelOrientation = If[MatchQ[labelOrientationOpt,Automatic],
		If[MatchQ[chartLabelOpt,{_Integer..}],
			Horizontal,
			Vertical
		],
		labelOrientationOpt
	];

	(* set the chart labels *)
	labels = If[MatchQ[chartLabelOpt,Automatic],
		{},
		ToString/@(chartLabelOpt)
	];

	placedLabels = If[MatchQ[labelOrientation,Vertical],
		Placed[labels, Axis, Rotate[#, Pi/2] &],
		labels
	];

	(* wrap up the datas to get them ready for plotting *)
	plotDatas=Switch[datas,
		{{_?NumericQ}..},{Flatten@datas},
		_,datas
	];

	plotDatas = Switch[plotDatas,
		{{{NumberP..}..}..},
			Apply[Replicates,plotDatas,{2}],
		{{NumberP..}..},
			Apply[Replicates,plotDatas,{1}],
		_,
			plotDatas
	];

	(* plot the bar chart *)
	{result,mostlyResolvedOps,preview,tests}=EmeraldBarChart[plotDatas,
		ReplaceRule[
			ToList@stringOptionsToSymbolOptions[PassOptions[PlotPeaks,EmeraldBarChart,defaultedOptions]],
			{
				(* Always force these options *)
				FrameTicks->Automatic,
				ChartLabels->placedLabels,
				AspectRatio->Lookup[defaultedOptions,AspectRatio]/.{Automatic->GoldenRatio^(-1)},
				PlotRange->Lookup[defaultedOptions,PlotRange]/.{Automatic->{Automatic, {0, Automatic}}},
				PlotRangeClipping->True,
				Output->{Result,Options,Preview,Tests}
			}
		]
	];

	(* Swap in options from PlotPeaks not present in EmeraldBarChart *)
	resolvedOps=ReplaceRule[mostlyResolvedOps,
		{
			PlotType->BarChart,
			ChartLabelOrientation->labelOrientation,
			Peaks->Lookup[defaultedOptions,Peaks],
			ChartLabels->labels,
			Display->Lookup[defaultedOptions,Display]/.{Automatic->Purity},
			Output->output,
			(* Null out options specific to Pie Chart *)
			SectorSpacing->Null,
			ChartElementFunction->Null
		},
		Append->True
	];

	(* Return the requested output *)
	output/.{
		Result->result,
		Options->FilterRules[resolvedOps,ToExpression/@First/@Options[PlotPeaks]],
		Preview->preview/.{Rule[ImageSize,_]:>Rule[ImageSize,Full]},
		Tests->{}
	}
]


(* --- Helper function to make a bar chart from peak purity --- *)
plotPeaksBarChart[purity:PurityP,opts:OptionsPattern[PlotPeaks]]:=Module[
	{defaultedOptions,labelOrientationOpt,chartLabelOpt,areas,relAreas,labels,areasToPlot,plotrange,labelOrientation,chartLabels,frameLabel},

	(* default all the options first *)
	defaultedOptions = SafeOptions[PlotPeaks, ToList[opts]];

	(* pull out some option values *)
	chartLabelOpt = ChartLabels/.defaultedOptions;

	(* pull the areas, relative areas, and labels from the peak purity *)
	areas = Area/.purity;
	relAreas = RelativeArea/.purity;
	labels = PeakLabels/.purity;

	(* Format the relative areas to be plotted *)
	(*areasToPlot = List/@Unitless[relAreas];*)
	areasToPlot = Unitless[relAreas];

	(* set the chart labels *)
	chartLabels = If[MatchQ[chartLabelOpt,Automatic],
		labels,
		ToString/@chartLabelOpt
	];

	(* set the frame label *)
	frameLabel = If[MatchQ[FrameLabel/.defaultedOptions,Automatic],
		{"Peaks","Percent Peak Area"},
		FrameLabel/.defaultedOptions
	];

	(* plot the bar chart *)
	plotPeaksBarChartCore[
		areasToPlot,
		FrameLabel->frameLabel,
		ChartLabels->chartLabels,
		(* Sequence@@defaultedOptions *)
		Sequence@@FilterRules[{defaultedOptions},DeleteCases[defaultedOptions,Rule[FrameLabel|ChartLabels,_]]]
	]

]


(* --- PacketP[Object[Analysis,Peaks]]: plotting peak purity, area, height, or width as a bar chart --- *)
plotPeaksBarChart[peaksObj:PacketP[Object[Analysis,Peaks]],opts:OptionsPattern[PlotPeaks]]:=Module[
	{defaultedOptions,display,peakStuffToPlot},

	(* default all the options first *)
	defaultedOptions = SafeOptions[PlotPeaks, ToList[opts]];

	(* pull out some option values *)
	display = Display/.defaultedOptions;

	(* pull out the stuff to be plotted *)
	peakStuffToPlot = display/.peaksObj;

	(* plot as a bar chart *)
	If[MatchQ[(Display/.defaultedOptions),Purity],
		(* if plotting peak purity, just pass on to helper function *)

		plotPeaksBarChart[peakStuffToPlot,opts],
		(* if plotting peak area, height, or width, do a little more formatting work and then plot as a bar chart *)
		Module[
			{chartLabelOpt,labels,frameLabel},

			(* pull out additional option values *)
			chartLabelOpt = ChartLabels/.defaultedOptions;

			(* set the chart labels *)
			labels = If[MatchQ[chartLabelOpt,Automatic],
				Table["Peak "<>ToString[i],{i,Length[peakStuffToPlot]}],
				ToString/@chartLabelOpt
			];

			(* set the frame label *)
			frameLabel = If[MatchQ[FrameLabel/.defaultedOptions,Automatic],
				{"Peaks","Peak "<>ToString[display]},
				FrameLabel/.defaultedOptions
			];

			(* plot the bar chart *)
			plotPeaksBarChartCore[
				peakStuffToPlot,
				FrameLabel->frameLabel,
				ChartLabels->labels,
				(* Sequence@@defaultedOptions *)
				Sequence@@FilterRules[{defaultedOptions},DeleteCases[defaultedOptions,Rule[FrameLabel|ChartLabels,_]]]
			]
		]
	]

]

(* --- Listable --- *)
plotPeaksBarChart[peaksObj:({PacketP[Object[Analysis,Peaks]]..}|{{PacketP[Object[Analysis,Peaks]]..}..}),opts:OptionsPattern[PlotPeaks]]:=Module[
	{defaultedOptions},

	(* default all the options *)
	defaultedOptions = SafeOptions[PlotPeaks, ToList[opts]];

	(* pass to core function *)
	plotPeaksBarChart[#,Sequence@@defaultedOptions]&/@peaksObj

]


(* --- {PacketP[Object[Analysis,Peaks]]..}: plotting selected peak purity, area, height, or width as a bar chart --- *)
plotPeaksBarChartSelected[peaksObj:{PacketP[Object[Analysis,Peaks]]..},opts:OptionsPattern[PlotPeaks]]:=Module[
	{defaultedOptions,display,peaksOpt,chartLabelOpt,peakData,peaksStuffToPlot,labels,frameLabel},

	(* default all the options *)
	defaultedOptions = SafeOptions[PlotPeaks, ToList[opts]];

	(* pull out some option values *)
	display = (Display/.defaultedOptions);
	peaksOpt = Peaks/.defaultedOptions;
	chartLabelOpt = ChartLabels/.defaultedOptions;

	(* pull out the selected data to be plotted *)
	peakData = getPeaksFromAnalysis[peaksObj,display,peaksOpt];

	(* format the data to be plotted *)
	peaksStuffToPlot = Switch[peaksOpt,
		{_Integer},peakData,
		{_Integer..},List/@#&/@peakData,
		_Integer,peakData
	];

	(* set the chart labels *)
	labels = If[MatchQ[chartLabelOpt,Automatic],
		ToString/@(Object/.peaksObj),
		ToString/@(chartLabelOpt)
	];

	(* set the frame label *)
	frameLabel = If[MatchQ[FrameLabel/.defaultedOptions,Automatic],
		{"Peaks","Peak "<>ToString[display]},
		FrameLabel/.defaultedOptions
	];

	(* plot the bar chart *)
	plotPeaksBarChartCore[
		peaksStuffToPlot,
		FrameLabel->frameLabel,
		ChartLabels->labels,
		(* Sequence@@defaultedOptions *)
		Sequence@@FilterRules[{defaultedOptions},DeleteCases[defaultedOptions,Rule[FrameLabel|ChartLabels,_]]]
	]

]

(* --- Reverse Listable --- *)
plotPeaksBarChartSelected[peaksObj:PacketP[Object[Analysis,Peaks]],opts:OptionsPattern[PlotPeaks]]:=
	plotPeaksBarChartSelected[{peaksObj},opts]

(* --- Map! --- *)
plotPeaksBarChartSelected[peaksObj:{{PacketP[Object[Analysis,Peaks]]..}..},opts:OptionsPattern[PlotPeaks]]:=
	plotPeaksBarChartSelected[#,opts]&/@peaksObj



(* --- plotting normalized peak information when given two sets of peaks objects --- *)
plotPeaksNormalized[peaksObjA:{{PacketP[Object[Analysis,Peaks]]..}..},peaksObjB:{{PacketP[Object[Analysis,Peaks]]..}..},opts:OptionsPattern[PlotPeaks]]:=Module[
	{defaultedOptions,display,peaksOpt,peakDataA,peakDataB,toPlot,frameLabel},

	(* default all the options *)
	defaultedOptions = SafeOptions[PlotPeaks, ToList[opts]];

	(* pull out some option values *)
	display = Display/.defaultedOptions;
	peaksOpt = Peaks/.defaultedOptions;

	(* pull out the indexed data to be plotted *)
	peakDataA = getPeaksFromAnalysis[peaksObjA,display,First[First[peaksOpt]]];
	peakDataB = getPeaksFromAnalysis[peaksObjB,display,Last[First[peaksOpt]]];

	(* normalize the data *)
	toPlot = Quiet[peakDataA/peakDataB]/.{Indeterminate->0};

	(* set the frame label *)
	frameLabel = If[MatchQ[FrameLabel/.defaultedOptions,Automatic],
		{"Peaks","Normalized Peak "<>ToString[(Display/.defaultedOptions)]},
		FrameLabel/.defaultedOptions
	];

	(* plot the bar chart *)
	plotPeaksBarChartCore[
		toPlot,
		FrameLabel->frameLabel,
		(* Sequence@@defaultedOptions *)
		Sequence@@FilterRules[{defaultedOptions},DeleteCases[defaultedOptions,Rule[FrameLabel,_]]]
	]

]

(* --- Reverse Listable --- *)
plotPeaksNormalized[peaksObjA:{PacketP[Object[Analysis,Peaks]]..},peaksObjB:{PacketP[Object[Analysis,Peaks]]..},opts:OptionsPattern[PlotPeaks]]:=
	plotPeaksNormalized[List/@peaksObjA,List/@peaksObjB,opts]

plotPeaksNormalized[peaksObjA:PacketP[Object[Analysis,Peaks]],peaksObjB:PacketP[Object[Analysis,Peaks]],opts:OptionsPattern[PlotPeaks]]:=
	plotPeaksNormalized[{{peaksObjA}},{{peaksObjB}},opts]


(* --- Error Message --- *)
PlotPeaks[dataObjA:ListableP[PacketP[Object[Data]],2],dataObjB:ListableP[PacketP[Object[Data]],2],opts:OptionsPattern[PlotPeaks]]:=
	Message[PlotPeaks::DifferentDataFamilies,Flatten[Object/.{dataObjA,dataObjB}],DeleteDuplicates[Flatten[Type/.{dataObjA,dataObjB}]]]/;!MatchQ[Length[DeleteDuplicates[Flatten[Type/.{dataObjA,dataObjB}]]],1]

(* --- PacketP[Object[Data]]: plotting normalized peaks with two data sets --- *)
PlotPeaks[dataObjA:ListableP[PacketP[Object[Data]],2],dataObjB:ListableP[PacketP[Object[Data]],2],opts:OptionsPattern[PlotPeaks]]:=Module[
	{defaultedOptions,peakField,peaksIDA,peaksIDB},

	(* default all the options *)
	defaultedOptions = SafeOptions[PlotPeaks, ToList[opts]];

	(* pull out the peaks and peak data *)
	peaksIDA = getPeaksFromData[dataObjA];
	peaksIDB = getPeaksFromData[dataObjB];

	(* if one or more of the data objects doesn't have associated peaks, return an error message *)
	If[MemberQ[Flatten[{peaksIDA,peaksIDB}],Null],
		Message[PlotPeaks::NoPeaks,Flatten[Object/.{dataObjA,dataObjB}]],
		(* pass to core function *)
		PlotPeaks[peaksIDA,peaksIDB,Sequence@@defaultedOptions]
	]

]


(* --- PacketP[Object[Data]] --- *)

(* --- PacketP[Object[Data]]: plotting all peak purities as a bar chart or pie chart --- *)
PlotPeaks[dataObj:ListableP[PacketP[Object[Data]],2],opts:OptionsPattern[PlotPeaks]]:=
	Switch[dataObj,
		PacketP[Object[Data]],If[MatchQ[getPeaksFromData[dataObj],Null],
				Message[PlotPeaks::NoPeaks,Flatten[Object/.dataObj]],
				PlotPeaks[dataToPurity[dataObj],opts]
			],
		{PacketP[Object[Data]]..},If[MemberQ[getPeaksFromData[#]&/@dataObj,Null],
				Message[PlotPeaks::NoPeaks,Flatten[Object/.dataObj]],
				PlotPeaks[dataToPurity[#]&/@dataObj,opts]
			],
		{{PacketP[Object[Data]]..}..},PlotPeaks[#,opts]&/@dataObj
	]/;And[MatchQ[OptionDefault[OptionValue[Display],Verbose->False],Purity],MatchQ[OptionDefault[OptionValue[Peaks],Verbose->False],All]]


dataToPurity[obj: ObjectP[]] := Module[
	{peaksField, peaksSourceField, peaksID},

	peaksField = FirstOrDefault[LegacySLL`Private`typeToPeaksFields[obj[Type]]];
	peaksSourceField = FirstOrDefault[LegacySLL`Private`typeToPeaksSourceFields[obj[Type]]];
	peaksID = LastOrDefault[obj[peaksSourceField]];
	If[MatchQ[peaksID, Null], Message[PlotPeaks::NoPeaks]; Return[Null]];

	peaksID
];


(* --- Error Message --- *)
PlotPeaks[dataObj:ListableP[PacketP[Object[Data]],2],opts:OptionsPattern[PlotPeaks]]:=
	Message[PlotPeaks::DifferentDataFamilies,Flatten[{Object/.dataObj}],DeleteDuplicates[Flatten[{Type/.dataObj}]]]/;!MatchQ[Length[DeleteDuplicates[Flatten[{Type/.dataObj}]]],1]

PlotPeaks[dataObj:ListableP[PacketP[Object[Data]],2],opts:OptionsPattern[PlotPeaks]]:=
	Message[PlotPeaks::NoPeaks,Flatten[Object/.dataObj]]/;MemberQ[Flatten[{getPeaksFromData[dataObj]}],Null]

(* --- PacketP[Object[Data]]: plotting peak areas, heights, widths, or (not all) purities as a bar chart or pie chart --- *)
PlotPeaks[dataObj:ListableP[PacketP[Object[Data]],2],opts:OptionsPattern[PlotPeaks]]:=Module[
	{defaultedOptions,peakField,peaksID},

	(* default all the options *)
	defaultedOptions = SafeOptions[PlotPeaks, ToList[opts]];

	(* pull out the peaks and peak data *)
	peaksID = getPeaksFromData[dataObj];

	(* return if different families flag occurs *)
	If[MatchQ[peaksID,False],Return[]];

	(* pass to core function *)
	PlotPeaks[peaksID,Sequence@@defaultedOptions]

]/;!And[MatchQ[OptionDefault[OptionValue[Display],Verbose->False],Purity],MatchQ[OptionDefault[OptionValue[Peaks],Verbose->False],All]]


(* --- Objects --- *)
PlotPeaks[peaksObjA:ListableP[(objectOrLinkP[Object[Analysis,Peaks]]),1],peaksObjB:ListableP[(objectOrLinkP[Object[Analysis,Peaks]]),1],opts:OptionsPattern[PlotPeaks]]:=
		PlotPeaks[Download[peaksObjA],Download[peaksObjB],opts]
PlotPeaks[peaksObjA:ListableP[(objectOrLinkP[Object[Analysis,Peaks]]),{2}],peaksObjB:ListableP[(objectOrLinkP[Object[Analysis,Peaks]]),{2}],opts:OptionsPattern[PlotPeaks]]:=
		PlotPeaks[Download/@peaksObjA,Download/@peaksObjB,opts]

PlotPeaks[peaksObjA:ListableP[(objectOrLinkP[Object[Data]]),1],peaksObjB:ListableP[(objectOrLinkP[Object[Data]]),1],opts:OptionsPattern[PlotPeaks]]:=
	PlotPeaks[Download[peaksObjA],Download[peaksObjB],opts]
PlotPeaks[peaksObjA:ListableP[(objectOrLinkP[Object[Data]]),{2}],peaksObjB:ListableP[(objectOrLinkP[Object[Data]]),{2}],opts:OptionsPattern[PlotPeaks]]:=
		PlotPeaks[Download/@peaksObjA,Download/@peaksObjB,opts]


PlotPeaks[peaksObj:(ListableP[objectOrLinkP[Object[Analysis,Peaks]],1]|ListableP[objectOrLinkP[Object[Data]],1]),opts:OptionsPattern[PlotPeaks]]:=
	PlotPeaks[Download[peaksObj],opts]
PlotPeaks[peaksObj:(ListableP[objectOrLinkP[Object[Analysis,Peaks]],{2}]|ListableP[objectOrLinkP[Object[Data]],{2}]),opts:OptionsPattern[PlotPeaks]]:=
		PlotPeaks[Download/@peaksObj,opts]
