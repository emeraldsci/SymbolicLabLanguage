(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotPAGE*)


DefineOptions[PlotPAGE,
	optionsJoin[
		Options :> {
			{
				OptionName->IncludeLadder,
				Description->"If true, any ladders associated with the data will also be plotted.",
				Default->True,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>Alternatives[BooleanP]],
				Category->"Data Specification"
			},
			ModifyOptions[EmeraldListLinePlot,
				{
					{
						OptionName->Filling,
						Default->Bottom,
						Description->"Indicates how the region under the spectrum should be shaded.",
						Category->"Hidden"
					}
				}
			],
			ModifyOptions[ImagesOption,
				{
					{
						OptionName->Images,
						Default->Automatic,
						Widget->Alternatives[
							Adder[Widget[Type->Enumeration, Pattern:>Alternatives[LowExposureLaneImage,MediumLowExposureLaneImage,MediumHighExposureLaneImage,HighExposureLaneImage,OptimalLaneImage]]],
							Widget[Type->Enumeration, Pattern:>Alternatives[Null]]
						],
						Category->"Hidden"
					}
				}
			],
			ModifyOptions[LinkedObjectsOption,
				{
					{
						OptionName->LinkedObjects,
						Default->{LadderData},
						Widget->Alternatives[
							Adder[Widget[Type->Enumeration, Pattern:>Alternatives[LadderData]]],
							Widget[Type->Enumeration, Pattern:>Alternatives[NeighboringLanes]],
							Widget[Type->Enumeration, Pattern:>Alternatives[Null]]
							],
						Category->"Hidden"
					}
				}
			]
		},
		generateSharedOptions[Object[Data, PAGE], OptimalLaneIntensity, PlotTypes -> {LinePlot}, Display -> {Peaks, Ladder}, DefaultUpdates -> {FrameLabel -> {"Distance", "Summed Pixel Intensity."}}]
	],
	SharedOptions :> {
		EmeraldListLinePlot
	}];

Error::NoPAGEDataToPlot = "The protocol object does not contain any associated PAGE data.";
Error::PAGEProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotPAGE or PlotObject on an individual data object to identify the missing values.";

PlotPAGE[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotPAGE]]:=rawToPacket[primaryData,Object[Data,PAGE],PlotPAGE,SafeOptions[PlotPAGE, ToList[inputOptions]]];
(* PlotPAGE[infs:plotInputP,inputOptions:OptionsPattern[PlotPAGE]]:= *)
PlotPAGE[infs:ListableP[ObjectP[Object[Data,PAGE]],2],inputOptions:OptionsPattern[PlotPAGE]]:=Module[
	{safeOps, imagesOption,primaryDataOption,resolvedImages,resolvedOptions, preResolvedPlotLabel},

	safeOps = SafeOptions[PlotPAGE, ToList[inputOptions]];

	imagesOption=Lookup[ToList[safeOps],Images,Automatic];
	primaryDataOption=Lookup[ToList[safeOps],PrimaryData,{}];

	resolvedImages=If[MatchQ[imagesOption,Automatic],
		(* Check if we have PrimaryData specified *)
		Which[
			MatchQ[primaryDataOption,Automatic|{}],{OptimalLaneImage},
			MatchQ[primaryDataOption,LowExposureLaneIntensity|MediumLowExposureLaneIntensity|MediumHighExposureLaneIntensity|HighExposureLaneIntensity|OptimalLaneIntensity],
			{primaryDataOption/.{LowExposureLaneIntensity->LowExposureLaneImage,MediumLowExposureLaneIntensity->MediumLowExposureLaneImage,MediumHighExposureLaneIntensity->MediumHighExposureLaneImage,HighExposureLaneIntensity->HighExposureLaneImage,OptimalLaneIntensity->OptimalLaneImage}},
			True,
			Cases[
				ToList[primaryDataOption],
				LowExposureLaneIntensity|MediumLowExposureLaneIntensity|MediumHighExposureLaneIntensity|HighExposureLaneIntensity|OptimalLaneIntensity
			]/.{LowExposureLaneIntensity->LowExposureLaneImage,MediumLowExposureLaneIntensity->MediumLowExposureLaneImage,MediumHighExposureLaneIntensity->MediumHighExposureLaneImage,HighExposureLaneIntensity->HighExposureLaneImage,OptimalLaneIntensity->OptimalLaneImage}
		],
		imagesOption
	];

	(* pre resolve the PlotLabel to be Null if we have a single object or multiple objects without Map -> True *)
	preResolvedPlotLabel = Which[
		Not[MatchQ[Lookup[safeOps, PlotLabel], Automatic]], Lookup[safeOps, PlotLabel],
		Not[TrueQ[Lookup[safeOps, Map]]] && ListQ[infs], Null,
		MatchQ[infs, ObjectP[]], Null,
		True, Automatic
	];

	resolvedOptions=ReplaceRule[safeOps, {Images -> resolvedImages, PlotLabel -> preResolvedPlotLabel}];

	packetToELLP[infs,PlotPAGE,resolvedOptions]
];

(* Protocol Overload *)
PlotPAGE[
	obj: ObjectP[Object[Protocol, PAGE]],
	ops: OptionsPattern[PlotPAGE]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotPAGE, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, PAGE]]..}],
		Message[Error::NoPAGEDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotPAGE[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotPAGE[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::PAGEProtocolDataNotPlotted];
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
