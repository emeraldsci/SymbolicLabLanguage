(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCoulterCount*)


DefineOptions[PlotCoulterCount,
	Options :> {
		(* Hide these options *)
		ModifyOptions[EmeraldListLinePlot,
			{
				ErrorBars, ErrorType, InterpolationOrder,
				Peaks, PeakLabels, PeakLabelStyle,
				SecondYCoordinates, SecondYColors, SecondYRange, SecondYStyle, SecondYUnit, TargetUnits,
				Fractions, FractionColor, FractionHighlights, FractionHighlightColor,
				Ladder, Display,
				PeakSplitting, PeakPointSize, PeakPointColor, PeakWidthColor, PeakAreaColor
			},
			Category -> "Hidden"
		]
	},
	SharedOptions :> {EmeraldListLinePlot}
];

PlotCoulterCount[objs:ListableP[ObjectP[Object[Data, CoulterCount]], 2], inputOptions:OptionsPattern[]] := Module[
	{
		originalOps, safeOps, output, dataPackets, plotDatas, legends, frameLabel, setDefaultOption,
		plotOptions, plot, mostlyResolvedOps, resolvedOps
	},

	(* Convert the original options into a list *)
	originalOps = ToList[inputOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps = SafeOptions[PlotCoulterCount, ToList[inputOptions]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = Lookup[safeOps, Output];

	(*perform our download*)
	dataPackets = Quiet[
		Download[
			ToList[objs],
			Packet[DiameterDistribution]
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* get the plot data *)
	{plotDatas, legends} = Transpose[Map[
		Function[{dataPacket},
			Module[{plotData, legend},
				(* get the plot data *)
				plotData = Module[{diamDistQAList, diamCountAssocList, combinedDiameterCountAssoc},
					(* The diameter distribution stored in the data object is a list of QuantityArrays *)
					diamDistQAList = Lookup[dataPacket, DiameterDistribution];
					diamCountAssocList = Map[
						(* We cannot directly Rule@@@ since each distribution is a quantity array, so have to do this weird thing to get rid of the _QuantityArray head *)
						Association[Rule @@@ #]&,
						diamDistQAList
					];
					(* Merge the associations by adding the count up *)
					combinedDiameterCountAssoc = Merge[diamCountAssocList, Total];
					(* From the combined data, generate the data that we will be using for plotting *)
					Transpose[{Keys[combinedDiameterCountAssoc], Values[combinedDiameterCountAssoc]}]
				];

				(* create the legends *)
				legend = ToString[Lookup[dataPacket, Object]];

				(* Return *)
				{plotData, legend}
			]
		],
		dataPackets
	]];

	(* get the frame label *)
	frameLabel = {"Particle Diameter (\[Micro]m)", "Particle Count"};

	(* Helper function for setting default options *)
	setDefaultOption[op_Symbol, default_] := If[MatchQ[Lookup[originalOps, op], _Missing],
		Rule[op, default],
		Rule[op, Lookup[originalOps, op]]
	];

	(* Override unspecified input options with surface tension specific formatting *)
	plotOptions = ReplaceRule[safeOps,
		{
			(* Set specific defaults *)
			setDefaultOption[Filling, Axis],
			setDefaultOption[Joined, True],
			setDefaultOption[Zoomable, True],
			setDefaultOption[Scale, Linear],
			setDefaultOption[FrameLabel, frameLabel],
			setDefaultOption[Legend, legends]
		}
	];

	(* --- Call EmeraldListLinePlot and get resolved options --- *)

	(* Call one of the MegaPlots.m functions, typically EmeraldListLinePlot, and get those resolved options *)
	{plot, mostlyResolvedOps} = EmeraldListLinePlot[plotDatas,
		ReplaceRule[plotOptions,
			{Output -> {Result, Options}}
		]
	];

	(* Safe options with resolved options from the underlying plot function (plot range, frame, etc.) subbed in *)
	resolvedOps = ReplaceRule[safeOps, mostlyResolvedOps, Append -> False];

	(* Return the requested outputs *)
	output /. {
		Result -> plot,
		Options -> resolvedOps,
		Preview -> plot /. If[MemberQ[originalOps, ImageSize -> _], {}, {Rule[ImageSize, _] :> Rule[ImageSize, Full]}],
		Tests -> {}
	}
];
