(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotLuminescenceSpectroscopy*)


DefineOptions[PlotLuminescenceSpectroscopy,
	optionsJoin[
		generateSharedOptions[
			Object[Data,LuminescenceSpectroscopy],
			EmissionSpectrum,
			PlotTypes->{LinePlot},
			SecondaryData->{},
			Display->{Peaks},
			DefaultUpdates->{
				Peaks->{}
			},
			AllowNullUpdates->{
				Peaks->False
			},
			CategoryUpdates->{
				OptionFunctions->"Hidden",
				PrimaryData->"Data Specifications",
				SecondaryData->"Hidden",
				IncludeReplicates->"Hidden",
				Peaks->"Peaks",
				EmissionSpectrum->"Hidden"
			}
		],
		Options:>{
		
			ModifyOptions[EmeraldListLinePlot,{Reflected,SecondYUnit,SecondYCoordinates,SecondYColors,SecondYRange,SecondYStyle},Category->"Hidden"],
			ModifyOptions[EmeraldListLinePlot,{ErrorBars,ErrorType},Category->"Hidden"],
			
			ModifyOptions[EmeraldListLinePlot,
				{
					{
						OptionName->Scale,
						AllowNull->False
					},
					{
						OptionName->Fractions,
						AllowNull->False,
						Default->{},
						Category->"Fractions"
					},
					{
						OptionName->LegendLabel,
						AllowNull->False
					},				
					{
						OptionName->Filling,
						Default->Bottom
					}
				}
			]
		}
	],
	SharedOptions:>{EmeraldListLinePlot}
];

Error::NoLuminescenceSpectroscopyDataToPlot = "The protocol object does not contain any associated luminescence spectroscopy data.";
Error::LuminescenceSpectroscopyProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotLuminescenceSpectroscopy or PlotObject on an individual data object to identify the missing values.";

(* Raw Definition *)
PlotLuminescenceSpectroscopy[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotLuminescenceSpectroscopy]]:=Module[
	{safeOps,ellpOutput},
	safeOps=SafeOptions[PlotLuminescenceSpectroscopy, ToList[inputOptions]];
	ellpOutput=rawToPacket[primaryData,Object[Data,LuminescenceSpectroscopy],PlotLuminescenceSpectroscopy,safeOps];
	processELLPOutput[ellpOutput,safeOps]
];

(* Protocol Overload *)
PlotLuminescenceSpectroscopy[
	obj: ObjectP[Object[Protocol, LuminescenceSpectroscopy]],
	ops: OptionsPattern[PlotLuminescenceSpectroscopy]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotLuminescenceSpectroscopy, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, LuminescenceSpectroscopy]]..}],
		Message[Error::NoLuminescenceSpectroscopyDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	(* Passing ops input here instead of safeOps because the main function overload will do some option processing *)
	previewPlot = If[MemberQ[output, Preview],
		PlotLuminescenceSpectroscopy[data, Sequence @@ ReplaceRule[ops, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	(* Passing ops input here instead of safeOps because the main function overload will do some option processing *)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotLuminescenceSpectroscopy[#, Sequence @@ ReplaceRule[ops, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::LuminescenceSpectroscopyProtocolDataNotPlotted];
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

(* Packet Definition *)
(* PlotLuminescenceSpectroscopy[infs:plotInputP,inputOptions:OptionsPattern[PlotLuminescenceSpectroscopy]]:= *)
PlotLuminescenceSpectroscopy[infs:ListableP[ObjectP[Object[Data, LuminescenceSpectroscopy]],2],inputOptions:OptionsPattern[PlotLuminescenceSpectroscopy]]:=Module[
	{safeOps,ellpOutput},
	safeOps=SafeOptions[PlotLuminescenceSpectroscopy,ToList[inputOptions]];	
	ellpOutput=packetToELLP[infs,PlotLuminescenceSpectroscopy,{inputOptions}];
	processELLPOutput[ellpOutput,safeOps]
];
