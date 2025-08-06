(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCriticalMicelleConcentration*)


DefineOptions[PlotCriticalMicelleConcentration,
	Options:>{
		(* Hide these options *)
		ModifyOptions[EmeraldListLinePlot,
			{
				ErrorBars,ErrorType,InterpolationOrder,
				Peaks,PeakLabels,PeakLabelStyle,
				SecondYCoordinates,SecondYColors,SecondYRange,SecondYStyle,SecondYUnit,TargetUnits,
				Fractions,FractionColor,FractionHighlights,FractionHighlightColor,
				Ladder,Display,Scale,
				PeakSplitting,PeakPointSize,PeakPointColor,PeakWidthColor,PeakAreaColor
			},
			Category->"Hidden"
		]
	},
	SharedOptions:>{EmeraldListLinePlot}
];


(*Messages*)
Warning::CriticalMicelleConcentrationAnalysisMissing="There is no AnalyzeCriticalMicelleConcentration analysis object linked to the input SurfaceTension data object(s). If you would like the data to be fit, please run AnalyzeCriticalMicelleConcentration on the data objects.";
Error::NoSurfaceTensionDataToPlot = "The protocol object does not contain any associated surface tension data.";
Error::MeasureSufacceTensionProtocolCMCDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotCriticalMicelleConcentration, PlotSurfaceTension or PlotObject on an individual data object to identify the missing values.";

(* Protocol Overload *)
PlotCriticalMicelleConcentration[
	obj: ObjectP[Object[Protocol, MeasureSurfaceTension]],
	ops: OptionsPattern[PlotCriticalMicelleConcentration]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotCriticalMicelleConcentration, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, SurfaceTension]]..}],
		Message[Error::NoSurfaceTensionDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotCriticalMicelleConcentration[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotCriticalMicelleConcentration[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::MeasureSufacceTensionProtocolCMCDataNotPlotted];
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

(*Function overload accepting one or more SurfaceTension data objects*)
PlotCriticalMicelleConcentration[
	objs:ListableP[ObjectReferenceP[Object[Data,SurfaceTension]]|LinkP[Object[Data,SurfaceTension]]],
	ops:OptionsPattern[PlotCriticalMicelleConcentration]
]:=Module[{cmcAnalysisObjs},

	cmcAnalysisObjs=Flatten[Download[Download[objs,CriticalMicelleConcentrationAnalyses],Object]];

	If[MatchQ[cmcAnalysisObjs,{}],
		Return[Message[Warning::CriticalMicelleConcentrationAnalysisMissing];
		PlotSurfaceTension[
			objs,
			ops
		]
		],
		PlotCriticalMicelleConcentration[
			Last[cmcAnalysisObjs],
			ops
		]
	]
];

(*Function overload accepting one or more AnalyzeCriticalMicelleConcentration analysis objects*)
PlotCriticalMicelleConcentration[
	objs:ListableP[ObjectReferenceP[Object[Analysis,CriticalMicelleConcentration]]|LinkP[Object[Analysis,CriticalMicelleConcentration]]],
	ops:OptionsPattern[PlotCriticalMicelleConcentration]
]:=PlotCriticalMicelleConcentration[
	Download[ToList[objs],Packet[Concentrations,SurfaceTensions,PreMicellarFit, PostMicellarFit, ResolvedOptions, CriticalMicelleConcentration
	]],
	ops
];

(*Function overload accepting a list of CriticalMicelleConcentration analysis packets*)
PlotCriticalMicelleConcentration[
	cMCPackets:ListableP[PacketP[Object[Analysis,CriticalMicelleConcentration]]],
	ops:OptionsPattern[PlotCriticalMicelleConcentration]
]:=Module[{preMicellarFitExpression,postMicellarFitExpression,preMicellarFit, postMicellarFit,listedCmcPackets},

	(* Get the analysis packet to plot *)
	listedCmcPackets=Analysis`Private`stripAppendReplaceKeyHeads[DeleteDuplicates[ToList[cMCPackets]]];

	(*Look up some values from the analysis packets*)
	{preMicellarFit, postMicellarFit}=
		Transpose[Lookup[listedCmcPackets, {PreMicellarFit, PostMicellarFit
		}
		]];

	preMicellarFit=If[MatchQ[preMicellarFit,{Null..}],{Null},Download[preMicellarFit,Packet[BestFitExpression]]];
	postMicellarFit=If[MatchQ[postMicellarFit,{Null..}],{Null},Download[postMicellarFit,Packet[BestFitExpression]]];

	PlotCriticalMicelleConcentration[cMCPackets,preMicellarFit,postMicellarFit,ops]
];

(*Main function accepting a list of CriticalMicelleConcentration analysis packets and the fit packets*)
PlotCriticalMicelleConcentration[
	cMCPackets:ListableP[PacketP[Object[Analysis,CriticalMicelleConcentration]]],
	preMicellarFitExpressionPackets:ListableP[PacketP[Object[Analysis,Fit]]|Null],
	postMicellarFitExpressionPackets:ListableP[PacketP[Object[Analysis,Fit]]|Null],
	ops:OptionsPattern[PlotCriticalMicelleConcentration]
]:=Module[
	{
		listedCmcPackets,concentrations,surfaceTensions,preMicellarFit, postMicellarFit,
		criticalMicelleConcentration,apparentPartitioningCoefficient,
		surfaceExcessConcentration,crossSectionalArea, resolvedOptions, minConcentration, maxConcentration,
			preMicelleFitMin, preMicelleFitMax, postMicelleFitMin, postMicelleFitMax, postMicellarFitExpression, preMicellarFitExpression,
		diluentSurfaceTension,noZeroData, minST, maxST, preMicellarRange, postMicellarRange,preMicellarDomain, postMicellarDomain, molarBool,
		originalOps,safeOps,output,plotData,setDefaultOption,plotOptions,plot,mostlyResolvedOps,resolvedOps
	},

	(* Convert the original options into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotCriticalMicelleConcentration,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* Resolve the raw numerical data that you will plot *)
	(* Get the analysis packet to plot *)
	listedCmcPackets=Analysis`Private`stripAppendReplaceKeyHeads[DeleteDuplicates[ToList[cMCPackets]]];

	(*Look up some values from the analysis packets*)
	{concentrations,surfaceTensions,preMicellarFit, postMicellarFit,
		 resolvedOptions,criticalMicelleConcentration}=
      Transpose[Lookup[listedCmcPackets, {
				Concentrations, SurfaceTensions, PreMicellarFit, PostMicellarFit,
				ResolvedOptions, CriticalMicelleConcentration
			}
	]];

	(*Resolve the plotting values*)
	noZeroData=If[MatchQ[Unitless[First[#]], Alternatives[0.,0]], Nothing, #] & /@Transpose[{Flatten[concentrations],Flatten[surfaceTensions]}];

	diluentSurfaceTension=Last[Lookup[resolvedOptions,DiluentSurfaceTension]];
	preMicellarRange=First[ToList[Lookup[resolvedOptions,PreMicellarRange]]];
	postMicellarRange=First[ToList[Lookup[resolvedOptions,PostMicellarRange]]];
	preMicellarDomain=First[ToList[Lookup[resolvedOptions,PreMicellarDomain]]];
	postMicellarDomain=First[ToList[Lookup[resolvedOptions,PostMicellarDomain]]];

	preMicellarFitExpression=If[MatchQ[preMicellarFitExpressionPackets,{Null}],Null,Lookup[Last[preMicellarFitExpressionPackets],BestFitExpression]];
	postMicellarFitExpression=If[MatchQ[postMicellarFitExpressionPackets,{Null}],Null,Lookup[Last[postMicellarFitExpressionPackets],BestFitExpression]];

	minConcentration=Min[Select[Flatten[concentrations],MatchQ[First[#],GreaterP[0]]&]];
	maxConcentration=Max[Flatten[concentrations]];
	minST=Min[Flatten[surfaceTensions]];
	maxST=Max[Flatten[surfaceTensions]];

	molarBool=MatchQ[Quiet[Unitless[Flatten[concentrations],Molar]],$Failed|{$Failed..}];

	preMicelleFitMin=If[MatchQ[preMicellarFitExpression,Except[Null|$Failed]],preMicellarFitExpression /. (x -> If[molarBool,Log[Unitless[minConcentration]],Log[Unitless[minConcentration, Molar]]])];
	preMicelleFitMax=If[MatchQ[preMicellarFitExpression,Except[Null|$Failed]],preMicellarFitExpression /. (x -> If[molarBool,Log[Unitless[maxConcentration]],Log[Unitless[maxConcentration, Molar]]])];
	postMicelleFitMin=If[MatchQ[postMicellarFitExpression,Except[Null|$Failed]],postMicellarFitExpression /. (x -> If[molarBool,Log[Unitless[minConcentration]],Log[Unitless[minConcentration, Molar]]])];
	postMicelleFitMax=If[MatchQ[postMicellarFitExpression,Except[Null|$Failed]],postMicellarFitExpression /. (x -> If[molarBool,Log[Unitless[maxConcentration]],Log[Unitless[maxConcentration, Molar]]])];

	plotData={Transpose[{Flatten[concentrations],Flatten[surfaceTensions]}],
		If[MatchQ[preMicellarFitExpression,Except[Null|$Failed]],{{minConcentration,preMicelleFitMin*Milli Newton/Meter},{maxConcentration,preMicelleFitMax*Milli Newton/Meter}}],
		If[MatchQ[postMicellarFitExpression,Except[Null|$Failed]],{{minConcentration,postMicelleFitMin*Milli Newton/Meter},{maxConcentration,postMicelleFitMax*Milli Newton/Meter}}]
	};

	(* Helper function for setting default options *)
	setDefaultOption[op_Symbol,default_]:=If[MatchQ[Lookup[originalOps,op],_Missing],
		Rule[op,default],
		Rule[op,Lookup[originalOps,op]]
	];

	(* Override unspecified input options with standard-curve specific formatting *)
	plotOptions=ReplaceRule[safeOps,
		{
			setDefaultOption[ScalingFunctions,{"Log", None}],
			setDefaultOption[Legend,{"Surface Tension", "PreMicellar Fit", "PostMicellar Fit"}],
			setDefaultOption[LegendPlacement,Bottom],
			setDefaultOption[Joined,{False,True,True,True}],
			setDefaultOption[PlotStyle,{Automatic,Automatic,Automatic}],
			setDefaultOption[PlotRange,{{minConcentration*0.9, maxConcentration*1.1}, {minST*0.9, maxST*1.1}}],
			setDefaultOption[FrameLabel,{Row@{"Concentration (",Last[First[Flatten[concentrations]]],")"},"Surface Tension (mNewton/Meter)"}],
			setDefaultOption[Epilog,
				{
						(*tooltips over data*)
					Opacity[0],
					Tooltip[
						Point[{Log[Unitless[First[#]]], Unitless[Last[#]]}],
						#
					] & /@ noZeroData,
					(* pre fit regions*)
					ColorData[97][2],
					Opacity[0.09],
					If[
						MatchQ[preMicellarRange,Null],
						Rectangle[{Log[Unitless[First[preMicellarDomain]]],0},{Log[Unitless[Last[preMicellarDomain]]],100}],
						Rectangle[{-10000,Unitless[First[preMicellarRange]]},{10000,Unitless[Last[preMicellarRange]]}]
					],
					(*post fit regions*)
					ColorData[97][3],
					Opacity[0.09],
					If[
						MatchQ[postMicellarRange,Null],
						Rectangle[{Log[Unitless[First[postMicellarDomain]]],0},{Log[Unitless[Last[postMicellarDomain]]],100}],
						Rectangle[{-10000,Unitless[First[postMicellarRange]]},{10000,Unitless[Last[postMicellarRange]]}]
					]
				}
			]
		}
	];

	(* Call EmeraldListLinePlot and get those resolved options *)
	{plot,mostlyResolvedOps}=EmeraldListLinePlot[plotData,
		ReplaceRule[plotOptions,
			{Output->{Result,Options}}
		]
	];

	(* Safe options with resolved options from the underlying plot function (plot range, frame, etc.) subbed in *)
	resolvedOps=ReplaceRule[safeOps,
		mostlyResolvedOps,
		Append->False];

	(* Return the requested outputs *)
	output/.{
		Result->plot,
		Options->resolvedOps,
		Preview->plot,
		Tests->{}
	}

];
