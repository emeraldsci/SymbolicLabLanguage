(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotNMR2D*)


DefineOptions[PlotNMR2D,
	Options:>{
		{
			OptionName -> SymmetryFilter,
			Default -> False,
			Description -> "Specify if the data should be symmetrized before plotting.",
			ResolutionDescription -> "By default, no symmetrization is done.",
			AllowNull -> False,
			Category -> "Data Processing",
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[True,False]]
		},
		{
			OptionName -> NoiseThreshold,
			Default -> Automatic,
			Description -> "The minimum intensity magnitude below which no contours will be drawn (i.e. signals with intensity below this value will never be considered peaks).",
			ResolutionDescription -> "By default, the noise threshold is calculated automatically by determining the standard deviation of intensity in the baseline signal.",
			AllowNull -> False,
			Category -> "Contours",
			Widget -> Widget[Type->Number,Pattern:>GreaterP[0.0]]
		},
		{
			OptionName -> Contours,
			Default -> Automatic,
			Description -> "Specify either an integer number of contours or a list of intensity values at which contours should be drawn in the output contour plot.",
			ResolutionDescription -> "By default, contours is set to a list of pre-computed contours for the input data.",
			AllowNull -> False,
			Category -> "Contours",
			Widget -> Alternatives[
				"Number of Contours"->Widget[Type->Number,Pattern:>GreaterP[1,1]],
				"Contour Intensities"->Adder[Widget[Type->Number,Pattern:>GreaterP[0.0]]]
			]
		},
		ModifyOptions[EmeraldListLinePlot,
			{
				{OptionName -> AspectRatio, Default -> 1 / GoldenRatio},
				{OptionName -> PlotRange},
				{OptionName -> ScaleY, Default -> 1},
				{OptionName -> PlotLabel, Default -> Automatic, Description -> "Label of the plot. If Automatic, the data ID will be used."},
				{OptionName -> FrameLabel, Default -> {{None, "f1 Chemical Shift (ppm)"}, {"f2 Chemical Shift (ppm)", None}}},
				{OptionName -> Frame, Default -> True},
				{OptionName -> GridLines, Default -> Automatic},
				{OptionName -> GridLinesStyle, Default -> Dotted}
			}
		],
		ModifyOptions[EmeraldListLinePlot,{Reflected,ScalingFunctions},Category->"Hidden"],
		OutputOption
	},
	SharedOptions :> {
		ModifyOptions["Shared",EmeraldListLinePlot,{{OptionName->Zoomable, Default->True}}],
		{EmeraldListLinePlot,{ImageSize,PlotRange,RotateLabel,LabelStyle,ScaleX,FrameStyle,FrameTicks,FrameTicksStyle,Prolog,Epilog}}
	}
];

Error::NoNMR2DDataToPlot = "The protocol object does not contain any associated NMR2D data.";
Error::NMR2DProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotNMR2D or PlotObject on an individual data object to identify the missing values.";

(* Protocol Overload *)
PlotNMR2D[
	obj: ObjectP[Object[Protocol, NMR2D]],
	ops: OptionsPattern[PlotNMR2D]
] := Module[{listedOptions, safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* get the listed options and inputs *)
	listedOptions = ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotNMR2D, listedOptions];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, NMR2D]]..}],
		Message[Error::NoNMR2DDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotNMR2D[data, Sequence @@ ReplaceRule[listedOptions, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotNMR2D[#, Sequence @@ ReplaceRule[listedOptions, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::NMR2DProtocolDataNotPlotted];
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

(*** Primary Overload ***)
(* PlotNMR2D[myDataObjs:plotInputP, myOptions:OptionsPattern[PlotNMR2D]]:= *)
PlotNMR2D[myDataObjs:ListableP[ObjectP[{Object[Data,NMR],Object[Data, NMR2D]}],2], myOptions:OptionsPattern[PlotNMR2D]]:=Module[
	{
		listedDataObjs, listedOptions, output, safeOps, plotOps, scalingFunctions, preResolvedPreSafeOptions,
		frameTicks, frameTicksStyle, expTypes, allTooltips, contourValues, recursiveContourLines,
		indirectNuclei, dataPackets, contourLines, coloredContourLines, valuesToLinesRules,
		recursiveContourValues, all2DSpectra, xRanges, yRanges, plotRanges,
		byteCounts, paredEpilogs, objPlots, dynamicPlots,
		specifiedPlotLabels, expandedPlotLabels, resolvedPlotLabels,
		mostlyResolvedOpsPerObj, resolvedOpsPerObj, combinedResolvedOps,
		precomputedContours, recomputeContoursQ, resolvedContourOps
	},

	(* get the listed options and inputs *)
	listedOptions = ToList[myOptions];
	listedDataObjs = ToList[myDataObjs];

	(* Safeoptions is done later, so resolve output based on input options *)
	output=Lookup[listedOptions,Output,Result];

	(* Check if we need to recompute contours, or if we can use the pre-computed contours from the data object *)
	recomputeContoursQ=Or[
		(* Recompute needed if applying symmetry filter *)
		MatchQ[OptionValue[SymmetryFilter],True],
		(* Recompute needed if either NoiseThreshold or Contours have been explicitly set *)
		!MatchQ[OptionValue[NoiseThreshold],Automatic],
		!MatchQ[OptionValue[Contours],Automatic]
	];

	(* need to Download some values from the data objects right up front *)
	(* Download the data we are going to plot *)
	dataPackets = Download[listedDataObjs, Packet[ExperimentType, IndirectNucleus, Contours, NMR2DSpectrum]];

	(* pull out the ExperimentType, IndirectNucleus, and Contours fields *)
	expTypes = Lookup[dataPackets, ExperimentType];
	indirectNuclei = Lookup[dataPackets, IndirectNucleus];
	precomputedContours = Lookup[dataPackets, Contours];
	all2DSpectra = Lookup[dataPackets, NMR2DSpectrum];

	(* Compute new contours if requested *)
	allTooltips=If[recomputeContoursQ,
		recomputeContours[dataPackets,listedOptions],
		precomputedContours
	];

	(* pull out the x and y ranges *)
	xRanges = Map[
		Unitless[MinMax[#[[All, 1]]], PPM]&,
		all2DSpectra
	];
	yRanges = Map[
		Unitless[MinMax[#[[All, 2]]], PPM]&,
		all2DSpectra
	];

	(* --- pre-resolve values that 2D NMR always wants --- *)

	(* get the ScalingFunctions that we are going to pass to EmeraldListLinePlot *)
	scalingFunctions = Which[
		MemberQ[listedOptions, ScalingFunctions -> _], Lookup[listedOptions, ScalingFunctions],
		MemberQ[listedOptions, Reflected -> False], None,
		True, {"Reverse", "Reverse"}
	];

	(* set the FrameTicksStyle to ensure that you have the labels on the bottom and right of the graph, but the ticks on all four sides *)
	frameTicks = If[MemberQ[listedOptions, FrameTicks -> _],
		Lookup[listedOptions, FrameTicks],
		{All, All}
	];
	frameTicksStyle = If[MemberQ[listedOptions, FrameTicksStyle -> _],
		Lookup[listedOptions, FrameTicksStyle],
		{{Directive[FontOpacity -> 0, FontSize -> 0], Directive[FontOpacity -> 1, FontSize -> 14]}, {Directive[FontOpacity -> 1, FontSize -> 14], Directive[FontOpacity -> 0, FontSize -> 0]}}
	];

	(* set the PlotRange option; if it is specify then respect that, but otherwise use what was calculated from the data *)
	plotRanges = MapThread[
		If[MemberQ[listedOptions, PlotRange -> _],
			Lookup[listedOptions, PlotRange],
			{#1, #2}
		]&,
		{xRanges, yRanges}
	];

	(* pull out the plot labels *)
	specifiedPlotLabels = If[MemberQ[listedOptions, PlotLabel -> _],
		Lookup[listedOptions, PlotLabel],
		Automatic
	];

	(* expand the PlotLabel option *)
	expandedPlotLabels = If[MatchQ[specifiedPlotLabels, _List] && Length[specifiedPlotLabels] == Length[listedDataObjs],
		specifiedPlotLabels,
		ConstantArray[specifiedPlotLabels, Length[listedDataObjs]]
	];

	(* resolve the different plot labels *)
	resolvedPlotLabels = MapThread[
		If[MatchQ[#2, Automatic],
			ToString[#1],
			#2
		]&,
		{Download[listedDataObjs, Object], expandedPlotLabels}
	];

	(* pre-resolved pre-safe-options *)
	preResolvedPreSafeOptions = MapThread[
		ReplaceRule[listedOptions, {ScalingFunctions -> scalingFunctions, FrameTicks -> frameTicks, FrameTicksStyle -> frameTicksStyle, PlotRange -> RoundReals[#1,3], PlotLabel -> #2}]&,
		{plotRanges, resolvedPlotLabels}
	];

	(* get the safe options *)
	safeOps=SafeOptions[PlotNMR2D,#]&/@preResolvedPreSafeOptions;

	(* Extract only options which should go to ELLP *)
	plotOps=Map[
		(ToList@stringOptionsToSymbolOptions[PassOptions[PlotNMR2D,EmeraldListLinePlot,#]])&,
		safeOps
	];

	(* --- get the values for the tooltips and make them colorful (Blue for positive, Darker[Cyan] for negative) --- *)

	(* pull out the tooltip values *)
	contourValues=Map[
		Last[#]&,
		allTooltips,
		{2}
	];

	(* Resolve the contour options if they are automatic *)
	resolvedContourOps=MapThread[
		#1/.{
			Rule[Contours,Automatic]->Rule[Contours,Sort[#2]],
			Rule[NoiseThreshold,Automatic]->Rule[NoiseThreshold,Min[#2]]
		}&,
		{safeOps,contourValues}
	];

	(* get the contour lines only *)
	contourLines = Map[
		Cases[#, _Line, {2}]&,
		allTooltips,
		{2}
	];

	(* get the colored contour lines *)
	coloredContourLines = MapThread[
		Function[{valuesPerDataObj, linesPerDataObj},
			MapThread[
				If[#1 > 0,
					Style[#2, Blue],
					Style[#2, Darker[Cyan]]
				]&,
				{valuesPerDataObj, linesPerDataObj}
			]
		],
		{contourValues, contourLines}
	];

	(* make replace rules for each entry converting the contour values to the contour lines *)
	valuesToLinesRules = MapThread[
		AssociationThread[#1, #2]&,
		{contourValues, coloredContourLines}
	];

	(* use FoldList to progressively remove the smallest contours and only leaves the highest ones *)
	(* for instance, {-4, -2, -1, 1, 2, 4} becomes {-4, -2, 2, 4} becomes {-4, 4} becomes {}, and we keep all of these except the {} *)
	recursiveContourValues = Map[
		Function[{contourValuesPerDataObj},
			(* every one of these ends with {} and we don't want that there *)
			DeleteCases[FoldList[
				Function[{currentList},
					Select[currentList, Not[MatchQ[Abs[#], Min[Abs[currentList]]]]&]
				],
				contourValuesPerDataObj,
				DeleteDuplicates[Abs[contourValuesPerDataObj]]
			], {}]
		],
		contourValues
	];

	(* make the recursive contour lines *)
	recursiveContourLines = MapThread[
		#1 /. #2&,
		{recursiveContourValues, valuesToLinesRules}
	];

	(* get the ByteCounts of all the options *)
	byteCounts = Map[
		ByteCount[#]&,
		recursiveContourLines,
		{2}
	];

	(* delete the epilogs that are more than 6 MB because they make the frontend way way way too slow and are probably not useful anyway *)
	(* don't do this if there is only one plot anyway *)
	paredEpilogs = MapThread[
		Function[{epilogsPerDataObj, byteCountsPerDataObj},
			With[
				{
					smallestEpilogs = PickList[epilogsPerDataObj, byteCountsPerDataObj, Min[byteCountsPerDataObj]],
					smallEpilogOnly = PickList[epilogsPerDataObj, byteCountsPerDataObj, LessP[20000000]]
				},
				If[MatchQ[smallEpilogOnly, {}],
					smallestEpilogs,
					smallEpilogOnly
				]
			]
		],
		{recursiveContourLines, byteCounts}
	];

	(* make all the plots; the actual graphic is in the Epilog which gets added at the end; the plot itself is Null *)
	(* this is because using ELLP directly is prohibitively slow *)
	objPlots = MapThread[
		Function[{ops, epilogs},
			Map[
				EmeraldListLinePlot[Null, ReplaceRule[ops,{Output->Result, Epilog -> #}]]&,
				epilogs
			]
		],
		{plotOps, paredEpilogs}
	];

	(* Get the resolved options per plot function *)
	mostlyResolvedOpsPerObj = Map[
		DeleteCases[
			EmeraldListLinePlot[Null, ReplaceRule[#,{Output->Options}]],
			(Output->_)|(PlotRange->_)
		]&,
		plotOps
	];

	(* Finish resolving the options *)
	resolvedOpsPerObj=MapThread[
		ReplaceRule[#1,#2,Append->False]&,
		{resolvedContourOps,mostlyResolvedOpsPerObj}
	];

	(* Combined resolved options. If all inputs have same option return that option value, else return Automatic *)
	combinedResolvedOps=MapThread[
		If[CountDistinct[List@##]>1,First@#->Automatic,#1]&,
		resolvedOpsPerObj
	];

	(* make and return the dynamic plots with sliders *)
	dynamicPlots = MapThread[
		Function[{plots, contourVals},
			If[Length[plots] == 1,
				plots[[1]],
				DynamicModule[{var=1},
					Column[
						{
							Dynamic[plots[[var]]],
							Slider[Dynamic[var], {1, Length[plots], 1}],
							Dynamic[Style["Contour Level: "<>ToString@NumberForm[Part[Reverse@contourVals,var],DigitBlock->3], Medium, FontWeight -> Bold, FontFamily -> "Arial"]]
						},
						Center
					]
				]
			]
		],
		{objPlots, contourValues}
	];

	(* Format the output differently if we have a single input vs multiple inputs *)
	If[MatchQ[myDataObjs, ObjectP[Object[Data, NMR2D]]],
		(* Single Input *)
		output/.{
			Result->First[dynamicPlots],
			Preview->Pane[First[dynamicPlots],Alignment->Center,ImageSize->Full,ImageSizeAction->"ShrinkToFit"],
			Options->First[resolvedOpsPerObj],
			Tests->{}
		},
		(* Multiple inputs *)
		output/.{
			Result->dynamicPlots,
			Preview->SlideView[dynamicPlots,Alignment->Center,ImageSize->Full],
			Options->combinedResolvedOps,
			Tests->{}
		}
	]
];


(* Recompute contours if necessary based on option specification *)
recomputeContours[dataPacks_,listedOps:{(_Rule|_RuleDelayed)..}]:=Module[
	{
		symmetryOption,noiseOption,contourOption,expTypes,nmr2DSpectra,
		unitlessSpectra,maxValues,minValues,xRanges,yRanges,
		numberOfContours,rawContourLevels,contourLevels,
		rawInterpolations,interpolations,plots
	},

	(* Pull out option values *)
	symmetryOption=Lookup[listedOps,SymmetryFilter,False];
	noiseOption=Lookup[listedOps,NoiseThreshold,Automatic];
	contourOption=Lookup[listedOps,Contours,Automatic];

	(* Pull out plotting-related fields from input data packets *)
	expTypes=Lookup[dataPacks,ExperimentType];
	nmr2DSpectra=Lookup[dataPacks,NMR2DSpectrum];

	(* Work with unitless arrays for speed *)
	unitlessSpectra=Unitless[nmr2DSpectra];

	(* get the highest-absolute-value values *)
	(* doing Max[Abs[MinMax[blah]]] rather than just Max[Abs[blah]] becuase the former is much faster *)
	maxValues=Map[
		Max[Abs[MinMax[#[[All,3]]]]]&,
		unitlessSpectra
	];

	(* Estimate thresholds for noise *)
	minValues=If[MatchQ[noiseOption,Automatic],
		Map[
				automaticThresholdNarrowPeaks[Abs[#[[All,3]]]]&,
				unitlessSpectra
		],
		Repeat[noiseOption,Length[unitlessSpectra]]
	];

	(* get the x and y ranges that ContourPlot needs *)
	xRanges=MinMax[#[[All,1]]]&/@unitlessSpectra;
	yRanges=MinMax[#[[All,2]]]&/@unitlessSpectra;

	(* If Contours was set as an integer use that, otherwise use a default value *)
	numberOfContours=If[MatchQ[contourOption,_Integer],
		contourOption,
		20
	];

	(* Generate contour levels according to the given range *)
	rawContourLevels=MapThread[
		If[MatchQ[contourOption,_List],
			(* Use list of contours if they were specified *)
			Sort[contourOption],
			(* Generate a log range between min and max values  *)
			roundedLogSpace[#1,#2,numberOfContours]
		]&,
		{minValues,maxValues}
	];

	(* Add negative contour levels for experiment types with negative peaks *)
	contourLevels=MapThread[
		If[MatchQ[#2, DQFCOSY|TOCSY|HSQC|HSQCTOCSY],
			Sort[Join[-1*#, #]],
			#1
		]&,
		{rawContourLevels, expTypes}
	];

	(* Linear interpolations of the data for making contours *)
	rawInterpolations=Interpolation[#,InterpolationOrder->1]&/@unitlessSpectra;

	(* Use interpolations to apply symmetry filtering, if requested *)
	interpolations=If[TrueQ[symmetryOption],
		Map[
			Function[{x,y},Min[#[x,y],#[y,x]]]&,
			rawInterpolations
		],
		rawInterpolations
	];

	(* Generate plots to extract tooltips from *)
	plots=MapThread[
		Function[{interp, xRange, yRange, contours},
			With[
				{
					plot=Quiet[
						ContourPlot[interp[x, y],
							{x, xRange[[1]], xRange[[2]]},
							{y, yRange[[1]], yRange[[2]]},
							Contours -> contours,
							PlotPoints -> 100,
							PlotRange -> All,
							ScalingFunctions -> {"Reverse", "Reverse"},
							ContourShading -> None
						]
					]
				},
				Normal[plot]
			]
		],
		{interpolations, xRanges, yRanges, contourLevels}
	];

	(* pull out the tooltip values from the plots *)
	(* the Tooltips are stored at levelspec 4 *)
	Map[
		Cases[#, _Tooltip, {4}]&,
		plots
	]
];


(* Thresholding algorithm from KHou for estimating the threshold for signal vs. noise, when peaks are narrow (e.g. NMR, LCMS) *)
automaticThresholdNarrowPeaks[intensities_]:=Module[
	{medianFactor,logIntensities,logThreshold},

	(* In data characterized by a few sharp peaks, the median is an estimate of the baseline noise *)
	medianFactor=2*Median[intensities];

	(* We want to threshold noise from peaks; however, peaks can vary in height greatly, so log-scale the data so large intensities are "closer" *)
	logIntensities=Log[N[intensities+medianFactor]];

	(* Use a 1D k-means with 2 clusters to split up noise from peaks *)
	logThreshold=FindThreshold[logIntensities,Method->"Cluster"];

	(* Transform back to original units *)
	RoundReals[Exp[logThreshold]-medianFactor,2]
];


(* Generate n logarithmically spaced points, rounded to two sig figs, between two values *)
roundedLogSpace[minVal_,maxVal_,n_Integer]:=Module[
	{minLog,maxLog,logPts,realPts},

	(* End points in log space. Round the maximum down to the nearest power of 10 *)
	minLog=Log10[minVal];
	maxLog=Floor[Log10[maxVal]];

	(* Gridpoints in log space *)
	logPts=N@Range[minLog,maxLog,(maxLog-minLog)/(n-1)];

	(* Convert back to real space *)
	realPts=Power[10,logPts];

	(* Round the output to two sig figs *)
	RoundReals[realPts,2]
];
