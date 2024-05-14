(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotSurfaceTension*)

DefineOptions[PlotSurfaceTension,
	Options:>{
		(* Hide these options *)
		ModifyOptions[EmeraldListLinePlot,
			{
				ErrorBars,ErrorType,InterpolationOrder,
				Peaks,PeakLabels,PeakLabelStyle,
				SecondYCoordinates,SecondYColors,SecondYRange,SecondYStyle,SecondYUnit,TargetUnits,
				Fractions,FractionColor,FractionHighlights,FractionHighlightColor,
				Ladder,Display,
				PeakSplitting,PeakPointSize,PeakPointColor,PeakWidthColor,PeakAreaColor
			},
			Category->"Hidden"
		]
	},
	SharedOptions:>{EmeraldListLinePlot}
];


(*Function for plotting unanalyzed SurfaceTension data objects*)
PlotSurfaceTension[
	objs:ListableP[ObjectReferenceP[Object[Data,SurfaceTension]]|LinkP[Object[Data,SurfaceTension]]|PacketP[Object[Data, SurfaceTension]]],
	ops:OptionsPattern[PlotSurfaceTension]
]:=Module[
	{
		surfaceTensions ,dilutionFactors,originalOps,safeOps,plotOptions,plotData,output,
		plot,mostlyResolvedOps,resolvedOps,setDefaultOption
	},

	(* Convert the original options into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotSurfaceTension,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(*********************************)

	(* Resolve the raw numerical data that you will plot *)
	surfaceTensions=Download[objs,{SurfaceTensions}];

	dilutionFactors=Download[objs,{DilutionFactors}];

	plotData=Transpose[{Flatten[dilutionFactors],Flatten[surfaceTensions]}];

	(* Helper function for setting default options *)
	setDefaultOption[op_Symbol,default_]:=If[MatchQ[Lookup[originalOps,op],_Missing],
		Rule[op,default],
		Rule[op,Lookup[originalOps,op]]
	];

	(* Override unspecified input options with surface tension specific formatting *)
	plotOptions=ReplaceRule[safeOps,
		{
			(* Set specific defaults *)
			setDefaultOption[Joined,False],
			setDefaultOption[Scale,LogLinear],
			setDefaultOption[FrameLabel,{"Dilution Factors","Surface Tension (mNewton/Meter)"}]
		}
	];
	(*********************************)

	(* Call EmeraldListLinePlot and get those resolved options *)
	{plot,mostlyResolvedOps}=EmeraldListLinePlot[plotData,
		ReplaceRule[plotOptions,
			{Output->{Result,Options}}
		]
	];

	(* Safe options with resolved options from the underlying plot function (plot range, frame, etc.) subbed in *)
	resolvedOps=ReplaceRule[safeOps,mostlyResolvedOps,Append->False];

	(* Return the requested outputs *)
	output/.{
		Result->plot,
		Options->resolvedOps,
		Preview->plot/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Tests->{}
	}
];
