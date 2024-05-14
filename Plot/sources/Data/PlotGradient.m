(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotGradient*)


(* ::Subsubsection:: *)
(*PlotGradient*)

DefineOptions[PlotGradient,
	Options :> {
		{
			OptionName->Buffers,
			Default->Automatic,
			Description->"Indicates which buffers should be included on the plot.",
			AllowNull->False,
			Category->"Gradient",
			Widget->Alternatives[
				"Single" -> Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,BufferA,BufferB,BufferC,BufferD,BufferE,BufferF,BufferG,BufferH]],
				"Multiple" -> Adder[Widget[Type->Enumeration,Pattern:>Alternatives[BufferA,BufferB,BufferC,BufferD,BufferE,BufferF,BufferG,BufferH]]]
			]
		}
	},
	SharedOptions :> {
		EmeraldListLinePlot
	}
];

(* Listable overload *)
PlotGradient[myObjects:{ObjectP[Object[Method,Gradient]]..},myOps:OptionsPattern[PlotGradient]]:=Module[
	{packets},

	(* Download packets from all objects *)
	packets=Download[myObjects];

	(* Map over the packets *)
	PlotGradient[#,myOps]&/@packets
];

PlotGradient[myObject:ObjectP[Object[Method,Gradient]], myOps:OptionsPattern[PlotGradient]]:=Module[
	{
		originalOps,safeOps,output,plotData,specificOptions,plotOptions,
		plot,mostlyResolvedOps,resolvedOps,finalResolvedOps,

		(* PlotGradient variables *)
		myPacket,domains,xUnits,bufferOption,bufferToIndex,buffersToInclude,bufferIndices,legend,plotRange
	},

	(* Convert the original options into a list *)
	originalOps=ToList[myOps];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotGradient,ToList[myOps]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(****** Existing Plot Code ******)

	(* Download all the object information into a packet *)
	myPacket=Switch[myObject,
		PacketP[],myObject,
		_,Download[myObject]
	];

	domains = myPacket[Gradient];
	xUnits = (Gradient/.LegacySLL`Private`typeUnits[Object[Method,Gradient]])[[1]];

	bufferOption = OptionDefault[OptionValue[Buffers]];

	bufferToIndex = {BufferA->2,BufferB->3,BufferC->4,BufferD->5,BufferE->6,BufferF->7,BufferG->8,BufferH->9};

	buffersToInclude=Switch[bufferOption,
		Automatic,Map[
			If[!MatchQ[domains[[All,Last[#]]],{0.` Percent..}],
				First[#],
				Nothing
			]&,
			bufferToIndex
		],
		All,bufferToIndex[[All,1]],
		_,ToList[bufferOption]
	];

	bufferIndices = ToList[Replace[buffersToInclude,bufferToIndex,{1}]];

	legend = If[MatchQ[OptionDefault[OptionValue[Legend]],Automatic],
		ToString/@buffersToInclude,
		OptionDefault[OptionValue[Legend]]
	];

	(* Resolve the raw numerical data that will be plotted *)
	plotData=domains[[All,{1,#}]]&/@bufferIndices;

	(* Options specific to your function which do not get passed directly to the underlying plot *)
	specificOptions={
		FrameLabel->{"Time","Composition"},
		Legend->legend
	};

	(* Resolve all options which should go to the plot function, if applicable *)
	plotOptions=ReplaceRule[{stringOptionsToSymbolOptions[PassOptions[PlotGradient,EmeraldListLinePlot,safeOps]]}, specificOptions];

	(* Call one of the MegaPlots.m functions, typically EmeraldListLinePlot, and get those resolved options *)
	{plot,mostlyResolvedOps}=EmeraldListLinePlot[plotData,
		ReplaceRule[plotOptions,
			{Output->{Result,Options}}
		]
	];

	(* Safe options with resolved options from the underlying plot function (plot range, frame, etc.) subbed in *)
	resolvedOps=ReplaceRule[safeOps,mostlyResolvedOps,Append->False];

	(* Any special resolutions specific to your plot (which are not covered by underlying plot function) *)
	finalResolvedOps=ReplaceRule[resolvedOps,
		(* Any custom options which need special resolution *)
		specificOptions,
		Append->False
	];

	(* Return the requested outputs *)
	output/.{
		Result->plot,
		Options->finalResolvedOps,
		Preview->plot,
		Tests->{}
	}
]
