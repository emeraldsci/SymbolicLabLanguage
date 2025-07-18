(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotICPMS*)


(*PlotICPMS Options*)
DefineOptions[PlotICPMS,
	optionsJoin[
		(* In order to let the x-axis showing Mass-To-Charge Ratio (m/z) as the unit, the frame label is hard coded here. will change after we add m/z to EmeraldUnit*)
		generateSharedOptions[Object[Data, ICPMS], MassSpectrum, PlotTypes -> {LinePlot}, Display -> {Peaks}, DefaultUpdates -> {OptionFunctions -> {molecularWeightEpilogs},FrameUnits->{None,None},FrameLabel -> {"Mass-to-Charge Ratio (m/z)", None, None, None}}],
		Options :>{
			{
				OptionName->TickColor,
				Default-> Opacity[0.5, RGBColor[0.75, 0., 0.25]],
				Description->"The color of the molecular weight ticks.",
				Category->"MolecularWeightEpilog",
				AllowNull->True,
				Widget->Widget[Type->Expression,Pattern:>_Opacity|ColorP,Size->Line]
			},
			{
				OptionName->TickStyle,
				Default->{Thickness[Large]},
				Description->"The style for the text labeling the molecular weight ticks.",
				Category->"MolecularWeightEpilog",
				AllowNull->True,
				Widget->Adder[Widget[Type->Expression,Pattern:>LineStyleP,Size->Line]]
			},
			{
				OptionName->TickSize,
				Default-> 0.5,
				Description-> "The fraction of the plot height each primary molecular weight ticks should occupy.",
				Category->"MolecularWeightEpilog",
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern:>RangeP[0,1]]
			},
			{
				OptionName->TickLabel,
				Default-> True,
				Description->"Indicates if the primary molecular weight ticks should be labeled.",
				Category->"MolecularWeightEpilog",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
			}
		}
	],
	SharedOptions :> {
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->Frame,Default->{True,False,False,False}},
				{OptionName->LabelStyle,Default->{Bold, 12, FontFamily -> "Arial"}},
				{OptionName->Filling,Default->Bottom}
			}
		],

		EmeraldListLinePlot
	}
];

Error::NoICPMSDataToPlot = "The protocol object does not contain any associated ICPMS data.";
Error::ICPMSProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotICPMS or PlotObject on an individual data object to identify the missing values.";

(* PlotICPMS raw plot overload *)
PlotICPMS[myInput:rawPlotInputP, myOps:OptionsPattern[PlotICPMS]]:=Module[
	{originalOps,safeOps,plotData,specificOptions,plotOptions,plotOutputs},

	(* Convert the original options into a list *)
	originalOps=ToList[myOps];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotICPMS,ToList[myOps]];

	(* Options specific to your function which do not get passed directly to the underlying plot *)
	specificOptions=Normal@KeyTake[safeOps,{TickColor,TickStyle,TickSize,TickLabel}];

	(* Call rawToPacket[] *)
	plotOutputs=rawToPacket[
		myInput,
		Object[Data,ICPMS],
		PlotICPMS,
		(* NOTE - rawToPacket takes safeOps, not originalOps *)
		safeOps
	];

	(* Use the processELLPOutput helper *)
	processELLPOutput[plotOutputs,safeOps,specificOptions]
];

(* Protocol Overload *)
PlotICPMS[
	obj: ObjectP[Object[Protocol, ICPMS]],
	ops: OptionsPattern[PlotICPMS]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotICPMS, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, ICPMS]]..}],
		Message[Error::NoICPMSDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotICPMS[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotICPMS[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::ICPMSProtocolDataNotPlotted];
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

(* PlotICPMS Data Object overload *)
(* PlotICPMS[myInput:plotInputP, myOps:OptionsPattern[PlotICPMS]]:= *)
PlotICPMS[myInput:ListableP[ObjectP[{Object[Data, ICPMS],Object[Data, ChromatographyMassSpectra],Object[Data, MassSpectrometry]}],2], myOps:OptionsPattern[PlotICPMS]]:=Module[
	{originalOps,safeOps,specificOptions,packets},

	(* Convert the original options into a list *)
	originalOps=ToList[myOps];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotICPMS,ToList[myOps]];

	(* Options specific to your function which do not get passed directly to the underlying plot *)
	specificOptions=Normal@KeyTake[safeOps,{TickColor,TickStyle,TickSize,TickLabel}];

	packets=Download[Flatten[ToList[myInput]]];


	(* Call packetToELLP or rawToPacket[] *)
	Module[
		{plotOutputs},
		plotOutputs=packetToELLP[
			myInput,
			PlotICPMS,
			(* NOTE - packetToELLP takes originalOps, not safeOps *)
			originalOps
		];
		(* Use the processELLPOutput helper *)
		processELLPOutput[plotOutputs,safeOps,specificOptions]

	]

];
