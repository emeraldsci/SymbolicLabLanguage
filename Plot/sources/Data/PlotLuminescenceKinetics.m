(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotLuminescenceKinetics*)


DefineOptions[PlotLuminescenceKinetics,
	optionsJoin[
		generateSharedOptions[
			Object[Data,LuminescenceKinetics],
			EmissionTrajectories,
			PlotTypes->{LinePlot},
			SecondaryData->{},
			CategoryUpdates->{
				OptionFunctions->"Hidden",
				Display->"Hidden",
				PrimaryData->"Data Specifications",
				SecondaryData->"Secondary Data",
				IncludeReplicates->"Hidden",
				EmissionTrajectories->"Hidden",
				DualEmissionTrajectories->"Hidden",
				Temperature->"Hidden"
			},
			AllowNullUpdates->{
			}
		],
		Options:>{
			
			ModifyOptions[EmeraldListLinePlot,{SecondYCoordinates},Category->"Hidden"],
			
			ModifyOptions[
				EmeraldListLinePlot,
				{
					{
						OptionName->Scale,
						AllowNull->False
					},
					{
						OptionName->ErrorBars,
						Category->"Hidden"
					},					
					{
						OptionName->ErrorType,
						Category->"Hidden"
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
					}
					
				}
			],
			
			ModifyOptions[EmeraldListLinePlot,{Reflected,Peaks,PeakLabels,PeakLabelStyle,Ladder},Category->"Hidden"]
		
		}
	],
	SharedOptions :> {
		{PlotFluorescenceKinetics,{EmissionWavelength,DualEmissionWavelength}},
		EmeraldListLinePlot
	}
];

Error::NoLuminescenceKineticsDataToPlot = "The protocol object does not contain any associated luminescence kinetics data.";
Error::LuminescenceKineticsProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotLuminescenceKinetics or PlotObject on an individual data object to identify the missing values.";

(* Raw Definition *)
PlotLuminescenceKinetics[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotLuminescenceKinetics]]:=Module[
	{safeOps,ellpOutput},
	safeOps=SafeOptions[PlotLuminescenceKinetics, ToList[inputOptions]];
	ellpOutput=rawToPacket[primaryData,Object[Data,LuminescenceKinetics],PlotLuminescenceKinetics,safeOps];
	processELLPOutput[ellpOutput,safeOps]
];

(* Protocol Overload *)
PlotLuminescenceKinetics[
	obj: ObjectP[Object[Protocol, LuminescenceKinetics]],
	ops: OptionsPattern[PlotLuminescenceKinetics]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotLuminescenceKinetics, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, LuminescenceKinetics]]..}],
		Message[Error::NoLuminescenceKineticsDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotLuminescenceKinetics[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotLuminescenceKinetics[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::LuminescenceKineticsProtocolDataNotPlotted];
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
(* PlotLuminescenceKinetics[infs:plotInputP,inputOptions:OptionsPattern[PlotLuminescenceKinetics]]:= *)
PlotLuminescenceKinetics[infs:ListableP[ObjectP[Object[Data,LuminescenceKinetics]],2],inputOptions:OptionsPattern[PlotLuminescenceKinetics]]:=Module[
	{safeOps},
	safeOps=SafeOptions[PlotLuminescenceKinetics,ToList@inputOptions];
	processELLPOutput[PlotFluorescenceKinetics[infs,inputOptions],safeOps]
];
