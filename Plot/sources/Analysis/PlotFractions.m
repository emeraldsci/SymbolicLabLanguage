(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFractions*)


DefineOptions[PlotFractions,
	Options :> {
		{
			OptionName -> Range,
			Default -> {0,30},
			Description -> "The range of expected times of the samples.",
			AllowNull -> True,
			Category -> "Fractions",
			Widget->{
				"Min"->Widget[Type->Number,Pattern:>GreaterEqualP[0.]],
				"Max"->Widget[Type->Number,Pattern:>GreaterEqualP[0.]]
			}
		},
		{
			OptionName -> FractionLabels,
			Default -> Automatic,
			Description -> "Labels to display during mouseover of fractions.",
			ResolutionDescription -> "Automatic uses samples names if possible, and otherwise defaults to well positions.",
			AllowNull -> False,
			Category -> "Fractions",
			Widget->Adder[Alternatives[
				"String"->Widget[Type->String,Pattern:>_String,Size->Word],
				"Other"->Widget[Type->Expression,Pattern:>_,Size->Word]
			]]
		},

		(* Hide these options because thye get overidden *)
		ModifyOptions[PlotChromatography,{Display,PrimaryData,SecondaryData,LinkedObjects,Ladder},Category->"Hidden"]
	},
	SharedOptions:>{PlotChromatography}
];


(* Core functionality *)
PlotFractions[fracsCollected:{FractionP...}|{{Null, Null, Null}}, fracsPicked:{FractionP...}|{{Null, Null, Null}}, fig_Graphics, ops:OptionsPattern[]]:=Module[{plotRange, xrange},
	xrange=OptionDefault[OptionValue[Range]];
	plotRange=PlotRange/.AbsoluteOptions[fig,PlotRange];
	Zoomable[Show[
		(* Original figure *)
		fig,
		(* Fractions *)
		If[fracsCollected =!= {{Null,Null,Null}},
			Graphics[Core`Private`fractionEpilog[fracsCollected,
				PlotRange->plotRange,
				FractionHighlights->fracsPicked,
				FractionLabels->OptionValue[FractionLabels],
				FractionColor->OptionValue[FractionColor],
				FractionHighlightColor->OptionValue[FractionHighlightColor]
			]],
			Unevaluated[Sequence[]]
		],
		(* Range boundaries *)
		If[xrange===Null,
			{},
			Graphics[{Dashing[Large],Line[{{xrange[[1]],0},{xrange[[1]],5000}}],Line[{{xrange[[2]],0},{xrange[[2]],5000}}]}]
		]
	]]
];


(* Command Builder Overload *)
PlotFractions[input:ObjectP[Object[Analysis,Fractions]]|LinkP[Object[Analysis,Fractions]], ops:OptionsPattern[PlotFractions]]:=Module[
	{
		originalOps,safeOps,output,referenceObject,chromatogramFigure,samplesCollected,fracPacket,
		referencePacket,plotOps,download,fractionsCollected,mostlyResolvedOps,resolvedOps,finalPlot,
		resolvedFractionLabels
	},

	(* Convert the original options to a list *)
	originalOps=ToList[ops];

	(* Check options pattern and return a list of all options *)
	safeOps=SafeOptions[PlotFractions,originalOps];

	(* Requested output for command builder *)
	output=Lookup[safeOps,Output];

	(*first perform our download*)
	download=Download[input,{
		All,
		Packet[Reference[{Fractions, SamplesOut}]]
	}];

	(* Strip any Append or Replace key heads from the packet download *)
	fracPacket = Analysis`Private`stripAppendReplaceKeyHeads[First@download];

	(*get the reference packet*)
	referencePacket=download[[2]];

	(* Download the reference object and samples collected *)
	referenceObject = Download[referencePacket,Object];
	samplesCollected = Download[referencePacket, SamplesOut]/.x_Link:>Download[x,Object];

	(* Pass options from PlotFractions to PlotChromatography *)
	plotOps=ToList@stringOptionsToSymbolOptions[PassOptions[PlotFractions,PlotChromatography,ops]];

	(* Call PlotChromatography to get the figure and most of the options resolved *)
	{chromatogramFigure,mostlyResolvedOps}=PlotChromatography[referenceObject,
		ReplaceRule[plotOps,{
			Display->{Peaks},
			PrimaryData->Absorbance,
			SecondaryData->{},
			Zoomable->False,
			Output->{Result,Options}
		}]
	];

	(* Grab collected fractions. TODO: is the 4,5,3 indexing a hardcode? should fix. *)
	{fractionsCollected}=Lookup[referencePacket,Fractions]/.{x_Association:>Values[x][[{4, 5, 3}]]};

	(* Generate the final plot *)
	finalPlot=PlotFractions[
		fractionsCollected,
		FractionsPicked/.fracPacket,
		chromatogramFigure,
		ops,
		FractionLabels->samplesCollected
	];

	(* Ugly way of pulling resolved FractionLabels from the final graphic, pending a rework of Core`FractionEpilog *)
	resolvedFractionLabels=(
		(* Extract the mouseovers and take only the expression where the mouseover is on *)
		Part[#,2]&/@Cases[Unzoomable[finalPlot],_Mouseover,Infinity]
	)/.{
		(* Extract string from the text labels *)
		{___,Text[Style[str_,___],___]}:>str
	};

	(* Resolve remaining options *)
	resolvedOps=ReplaceRule[safeOps,mostlyResolvedOps]/.{
		(* Ugly resolution of fractionlabels option *)
		Rule[FractionLabels,Automatic]->Rule[FractionLabels,resolvedFractionLabels]
	};

	(* Return the requested outputs *)
	output/.{
		Result->finalPlot,
		Preview->finalPlot/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Options->resolvedOps,
		Tests->{}
	}
];
