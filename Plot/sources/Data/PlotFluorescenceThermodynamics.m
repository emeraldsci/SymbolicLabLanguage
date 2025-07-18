(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFluorescenceThermodynamics*)


DefineOptions[PlotFluorescenceThermodynamics,
	optionsJoin[
		generateSharedOptions[
			Object[Data, FluorescenceThermodynamics], 
			{CoolingCurve, MeltingCurve},
			PlotTypes->{LinePlot},
			DefaultUpdates->{
				IncludeReplicates->True,
				OptionFunctions->{arrowEpilog},
				Fractions->{}
			},
			AllowNullUpdates->{
				Fractions->False
			},
			CategoryUpdates->{
				CoolingCurve->"Hidden",
				MeltingCurve->"Hidden",
				RawCoolingCurve->"Hidden",
				RawMeltingCurve->"Hidden",
				SecondaryData->"Hidden",
				Display->"Hidden",
				IncludeReplicates->"Hidden",
				Peaks->"Hidden",
				OptionFunctions->"Hidden"
			}
		],
	Options:>{
	
			ModifyOptions[EmeraldListLinePlot,{Reflected,SecondYUnit,SecondYCoordinates,SecondYColors,SecondYRange,SecondYStyle},Category->"Hidden"],
			ModifyOptions[EmeraldListLinePlot,{PeakLabels,PeakLabelStyle,ErrorBars,ErrorType},Category->"Hidden"],
			ModifyOptions[EmeraldListLinePlot,
				{
					{
						OptionName->Scale,
						AllowNull->False,
						Category->"Hidden"
					}
				}
			],
			
			{
				OptionName->ArrowheadSize,
				Description->"The size of the arrows to lay atop the traces indicating the direction of the data.",
				Default->Medium,
				AllowNull->False,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Tiny|Small|Medium|Large],
					Widget[Type->Number,Pattern:>GreaterP[0],Min->0]
				],
				Category->"Plot Style"
			}
			
		}
	],
	SharedOptions :> {
		EmeraldListLinePlot
	}
];

Error::NoFluorescenceThermodynamicsDataToPlot = "The protocol object does not contain any associated fluorescence thermodynamics data.";
Error::FluorescenceThermodynamicsProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotFluorescenceThermodynamics or PlotObject on an individual data object to identify the missing values.";

(* Protocol Overload *)
PlotFluorescenceThermodynamics[
	obj: ObjectP[Object[Protocol, FluorescenceThermodynamics]],
	ops: OptionsPattern[PlotFluorescenceThermodynamics]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotFluorescenceThermodynamics, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, FluorescenceThermodynamics]]..}],
		Message[Error::NoFluorescenceThermodynamicsDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotFluorescenceThermodynamics[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotFluorescenceThermodynamics[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::FluorescenceThermodynamicsProtocolDataNotPlotted];
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
(* PlotFluorescenceThermodynamics[infs:plotInputP,inputOptions:OptionsPattern[PlotFluorescenceThermodynamics]]:= *)
PlotFluorescenceThermodynamics[infs:ListableP[ObjectP[Object[Data, FluorescenceThermodynamics]],2],inputOptions:OptionsPattern[PlotFluorescenceThermodynamics]]:=Module[
	{safeOps,ellpOutput},
	safeOps=SafeOptions[PlotFluorescenceThermodynamics,ToList[inputOptions]];	
	ellpOutput=packetToELLP[infs,PlotFluorescenceThermodynamics,{inputOptions}];
	processELLPOutput[ellpOutput,safeOps]
];
