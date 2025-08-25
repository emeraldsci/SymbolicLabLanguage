(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCoulterCount*)


DefineOptions[PlotCoulterCount,
	Options :> {
		{
			OptionName -> DiameterDistribution,
			Description -> "The distribution of the diameter of particles to display on the plot.",
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Expression,
				Pattern :> NullP | (ListableP[UnitCoordinatesP[], 2] | ListableP[QuantityArrayP[], 2]),
				Size -> Paragraph
			],
			Category -> "Raw Data"
		},
		{
			OptionName -> UnblankedDiameterDistribution,
			Description -> "The distribution of the diameter of particles without background subtraction to display on the plot.",
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Expression,
				Pattern :> NullP | (ListableP[UnitCoordinatesP[], 2] | ListableP[QuantityArrayP[], 2]),
				Size -> Paragraph
			],
			Category -> "Raw Data"
		},
		(* primary data *)
		ModifyOptions[
			PrimaryDataOption,
			Default -> Automatic,
			Widget -> Alternatives[
				Widget[Type -> Enumeration, Pattern :> DiameterDistribution | UnblankedDiameterDistribution],
				Adder[Widget[Type -> Enumeration, Pattern :> DiameterDistribution | UnblankedDiameterDistribution]]
			],
			Category -> "Primary Data"
		],
		ModifyOptions[IncludeReplicatesOption, Category -> "Primary Data"],
		(* Change default Display options *)
		ModifyOptions[
			DisplayOption,
			Default -> {Peaks},
			Widget -> Alternatives[
				Widget[Type -> Enumeration, Pattern :> Alternatives[{}]],
				Adder[Widget[Type -> Enumeration, Pattern :> Peaks | Fractions | Ladder]]
			],
			Category -> "General"
		],
		(* Set default Peaks/Fractions/Ladders to {} so widget appears in command builder *)
		ModifyOptions[EmeraldListLinePlot, {Peaks}, Default -> {}],
		(* Change OptionFunctions widget to accept empty list *)
		ModifyOptions[
			OptionFunctionsOption,
			Widget -> Alternatives[
				Widget[Type -> Enumeration, Pattern :> Alternatives[{}]],
				Adder[Widget[Type -> Expression, Pattern :> _Symbol, Size -> Line]]
			],
			Category -> "Hidden"
		],
		(* Hide these options *)
		ModifyOptions[EmeraldListLinePlot,
			{
				ErrorBars, ErrorType, InterpolationOrder,
				SecondYCoordinates, SecondYColors, SecondYRange, SecondYStyle, SecondYUnit, TargetUnits,
				Fractions, FractionColor, FractionHighlights, FractionHighlightColor, Ladder,
				PeakSplitting, PeakPointSize, PeakPointColor, PeakWidthColor, PeakAreaColor,
				FrameUnits, Scale, Prolog, Epilog
			},
			Category -> "Hidden"
		]
	},
	SharedOptions :> {EmeraldListLinePlot}
];

Error::NoCoulterCountDataToPlot = "The protocol object does not contain any associated coulter count data.";
Error::PlotCoulterCountProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotCoulterCount or PlotObject on an individual data object to identify the missing values.";

(* overload for raw 2D data input *)
PlotCoulterCount[primaryData:rawPlotInputP, inputOptions:OptionsPattern[]] := Module[
	{originalOps, safeOps, resolvedPrimaryData, combinedOps, ellpOutput},

	originalOps = ToList[inputOptions];

	safeOps = SafeOptions[PlotCoulterCount, ToList[inputOptions]];

	(* resolve primary data option *)
	resolvedPrimaryData = If[MatchQ[Lookup[safeOps, PrimaryData], Except[Automatic]],
		Lookup[safeOps, PrimaryData],
		DiameterDistribution
	];

	(* combine options *)
	combinedOps = ReplaceRule[
		originalOps,
		{PrimaryData -> resolvedPrimaryData}
	];

	(* call ELLP *)
	ellpOutput = rawToPacket[primaryData, Object[Data, CoulterCount], PlotCoulterCount, combinedOps];
	processELLPOutput[ellpOutput, safeOps, combinedOps]
];

(* Protocol Overload *)
PlotCoulterCount[
	obj: ObjectP[Object[Protocol, CoulterCount]],
	ops: OptionsPattern[PlotCoulterCount]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotCoulterCount, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, CoulterCount]]..}],
		Message[Error::NoCoulterCountDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotCoulterCount[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotCoulterCount[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::PlotCoulterCountProtocolDataNotPlotted];
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


(* overload for data object input *)
PlotCoulterCount[objs:ListableP[ObjectP[Object[Data, CoulterCount]], 2], inputOptions:OptionsPattern[PlotAbsorbanceSpectroscopy]] := Module[
	{
		originalOps, safeOps, dataPackets, listedObjs, dataTypes, diamDistQAs, unblankedDiamDistQAs, coordinateQ, resolvedPrimaryData, dataPacketsWithMergedData,
		setDefaultOption, legends, combinedOps, ellpOutput
	},

	originalOps = ToList[inputOptions];

	safeOps = SafeOptions[PlotCoulterCount, originalOps];

	(* get the listed object *)
	listedObjs = ToList[objs];

	(* download *)
	dataPackets = Quiet[
		Download[listedObjs,
			Packet[DataType, DiameterDistribution, UnblankedDiameterDistribution, DiameterPeaksAnalyses]
		],
		{Download::FieldDoesntExist, Download::NotLinkField, Download::MissingField}
	];

	{dataTypes, diamDistQAs, unblankedDiamDistQAs} = Transpose[Lookup[dataPackets,
		{DataType, DiameterDistribution, UnblankedDiameterDistribution}
	]];

	(* if all these values are $Failed, that means we are dealing with a pseudo data packet where the original input is coordinate *)
	coordinateQ = And[
		MatchQ[Lookup[dataPackets, ID], {"id:packetplaceholder"..}],
		MatchQ[dataTypes, {$Failed..}],
		MatchQ[diamDistQAs, {$Failed..}],
		MatchQ[unblankedDiamDistQAs, {$Failed..}]
	];

	(* resolve primary data option *)
	resolvedPrimaryData = Which[
		MatchQ[Lookup[safeOps, PrimaryData], Except[Automatic]],
		Lookup[safeOps, PrimaryData],
		(* set to unblanked diam distribution field only when we are fed with a bunch blank data objects *)
		MatchQ[dataTypes, {Blank..}],
		UnblankedDiameterDistribution,
		True,
		DiameterDistribution
	];

	dataPacketsWithMergedData = If[coordinateQ,
		(* no need to try to merge data if we are dealing with a coordinate input *)
		dataPackets,
		(* special treatment that we need to: 1) merge the data when NumberOfReadings > 1, 2) populate the merged data to the desired PrimaryData field for real data object *)
		MapThread[
			Function[{dataType, diamDistQAList, unblankedDiamDistQAList, packet},
				Module[{dataToLookAt, diamCountAssocList, combinedDiameterCountAssoc, mergedData},


					(* determine the data to look at *)
					dataToLookAt = If[MatchQ[dataType, Blank],
						unblankedDiamDistQAList,
						diamDistQAList
					];

					(* return early if this is already a merged data *)
					If[MatchQ[dataToLookAt, QuantityCoordinatesP[{Micrometer, None}]],
						Return[dataToLookAt, Module]
					];

					(* other prepare an association for merging the count *)
					diamCountAssocList = Map[
						(* We cannot directly Rule@@@ since each distribution is a quantity array, so have to do this weird thing to get rid of the _QuantityArray head *)
						Association[Rule @@@ #]&,
						dataToLookAt
					];

					(* Merge the associations by adding the count up *)
					combinedDiameterCountAssoc = Merge[diamCountAssocList, Total];

					(* Convert the merged association back to quantity arrays *)
					mergedData = QuantityArray[KeyValueMap[{##}&, combinedDiameterCountAssoc]];

					(* update the data packet *)
					Join[
						packet,
						<|resolvedPrimaryData -> mergedData|>
					]
				]
			],
			{dataTypes, diamDistQAs, unblankedDiamDistQAs, dataPackets}
		]
	];

	(* Helper function for setting default options *)
	setDefaultOption[op_Symbol, default_] := If[MatchQ[Lookup[originalOps, op], _Missing],
		op -> default,
		op -> Lookup[originalOps, op]
	];

	legends = If[coordinateQ,
		"data set "<>ToString[#]& /@ Range[Length[dataPackets]],
		ECL`InternalUpload`ObjectToString /@ dataPackets
	];

	(* combine options with the input options so we can append Epilogs automatically with packetToELLP helper *)
	combinedOps = ReplaceRule[
		originalOps,
		{
			PrimaryData -> resolvedPrimaryData,
			(* Set specific defaults *)
			setDefaultOption[Filling, Axis],
			setDefaultOption[FillingStyle, Opacity[0.75]],
			setDefaultOption[Joined, True],
			setDefaultOption[Zoomable, True],
			setDefaultOption[Scale, Linear],
			setDefaultOption[FrameLabel, {"Particle Diameter (\[Micro]m)", "Particle Count"}],
			setDefaultOption[Legend, legends]
		}
	];

	(* call ELLP *)
	ellpOutput = packetToELLP[dataPacketsWithMergedData, PlotCoulterCount, combinedOps];
	processELLPOutput[ellpOutput, safeOps, combinedOps]
];

