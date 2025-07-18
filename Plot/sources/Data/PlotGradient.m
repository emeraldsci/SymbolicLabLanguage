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
			Description->"Indicates which buffers should be included on the plot. CO2 can only be selected if an Object[Method, SupercriticalFluidGradient] is used as input. BufferE, BufferF, BufferG, and BufferH are only compatible with ObjectP[Object[Method, Gradient]",
			AllowNull->False,
			Category->"Gradient",
			Widget->Alternatives[
				"Single" -> Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,CO2,BufferA,BufferB,BufferC,BufferD,BufferE,BufferF,BufferG,BufferH]],
				"Multiple" -> Adder[Widget[Type->Enumeration,Pattern:>Alternatives[CO2,BufferA,BufferB,BufferC,BufferD,BufferE,BufferF,BufferG,BufferH]]]
			]
		}
	},
	SharedOptions :> {
		EmeraldListLinePlot
	}
];

Warning::NoBuffersCompatibleWithGradient = "None of the selected buffers or eluents for the Buffers option are present in `1`. Only `2` are present in an `3` and automatically selected buffers are displayed instead.";
Warning::BufferNotCompatibleWithGradient = "The selected buffer or eluent `1` for the Buffers option is not present in `2`. Only `3` are present in an `2`.";
Warning::BufferNotCompatibleWithAnionGradient = "The selected buffer or eluent `1` for the Buffers option is not present in `2`. Only BufferA is present in an `3` in combination with an AnionGradient and will be displayed instead. ";

(* Listable overload *)
PlotGradient[myObjects:{ObjectP[{Object[Method, Gradient], Object[Method, IonChromatographyGradient], Object[Method, SupercriticalFluidGradient]}] ..},myOps:OptionsPattern[PlotGradient]]:=Module[
	{packets},

	(* Download packets from all objects *)
	packets=Download[myObjects];

	(* Map over the packets *)
	PlotGradient[#,myOps]&/@packets
];

PlotGradient[myObject:ObjectP[{Object[Method, Gradient], Object[Method, IonChromatographyGradient], Object[Method, SupercriticalFluidGradient]}], myOps:OptionsPattern[PlotGradient]]:=Module[
	{
		originalOps,safeOps,output,plotData,specificOptions,plotOptions,
		plot,mostlyResolvedOps,resolvedOps,finalResolvedOps,

		(* PlotGradient variables *)
		object, type, frameLabel, gradientField, myPacket,domains,xUnits,bufferOption,bufferToIndex,buffersToInclude,bufferIndices,legend,plotRange
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

	(*The type of Method to be plot. This information is used to determine which fields to download*)
	{type,object} = Lookup[myPacket,{Type,Object}];

	(*Each type has a different field for the gradient. The fields are determined based on the type, and for Object[Method,IonChromatographyGradient] whether CationGradient Or AnionGradient is not an empty list or Null *)
	(*Additionally, the bufferToIndex is picked. This index indicate which data in the gradient list corresponds to the given buffers.*)
	{gradientField,bufferToIndex} = Which[
		MatchQ[type,Object[Method,Gradient]],
		{Gradient,{BufferA->2,BufferB->3,BufferC->4,BufferD->5,BufferE->6,BufferF->7,BufferG->8,BufferH->9}},
		MatchQ[type,Object[Method,SupercriticalFluidGradient]],
		{Gradient,{CO2->2, BufferA->3,BufferB->4,BufferC->5,BufferD->6}},
		MatchQ[type,Object[Method,IonChromatographyGradient]]&&!MatchQ[Lookup[myPacket,CationGradient],(Null|{})],
		{CationGradient,{BufferA->2,BufferB->3,BufferC->4,BufferD->5}},
		MatchQ[type,Object[Method,IonChromatographyGradient]]&&!MatchQ[Lookup[myPacket,AnionGradient],(Null|{})],
		{AnionGradient, {BufferA->2}}
	];

	(*The gradient data*)
	domains = Lookup[myPacket,gradientField	];

	(*The units for the data*)
	xUnits = (gradientField/.LegacySLL`Private`typeUnits[type])[[1]];

	bufferOption = ToList[OptionDefault[OptionValue[Buffers]]];

	(*Determine which buffers/eluents to include based on the Buffer option input*)
	buffersToInclude=Switch[bufferOption,
		(*Automatic only includes buffers that are not null throughout the whole list*)
		{Automatic},Map[
			If[!MatchQ[domains[[All,Last[#]]],{0.` Percent..}],
				First[#],
				Nothing
			]&,
			bufferToIndex
		],
		(*All includes buffers that are not null throughout the whole list*)
		{All},bufferToIndex[[All,1]],
		(*Othwerise, use the user specified buffers. This module checks if the buffer is part of the gradient. Only buffers that are relevant to the given gradient will be used for the output.*)
		(*Use the same conditions as automatic if none of the user specified buffers are compatible with the gradient*)
		_,Module[{allowedBufferQ, allowedBufferList},
				(*Determine if the eluent/buffer given in the Buffers option is a part of the gradient using the keys of bufferToIndex variable*)
			allowedBufferQ = Map[MatchQ[#, Alternatives@@Keys[bufferToIndex]]&, bufferOption];
				allowedBufferList = PickList[bufferOption, MatchQ[#, allowedBufferQ]&/@bufferOption];

				Which[
					(*Use the Buffer option input if all  input buffers match those in the gradient.*)
					And@@allowedBufferQ,
					bufferOption,
					(*If it is an emtpy list, use the same settings as automatic*)
					MatchQ[allowedBufferList,{}],
					Map[
						If[!MatchQ[domains[[All,Last[#]]],{0.` Percent..}],
							First[#],
							Nothing
						]&,
						bufferToIndex
						],
						(*If the list is not empty, use the options that are given and are allowed*)
					!MatchQ[allowedBufferList,{}],
					allowedBufferList
				]
			]
	];

	(*Give a warning if the given buffers do not match those of the gradient given*)
	If[!MatchQ[bufferOption, Alternatives[{All}, {Automatic}]]&&!MatchQ[buffersToInclude, bufferOption],
		If[MatchQ[type,Object[Method,IonChromatographyGradient]]&&!MatchQ[Lookup[myPacket,AnionGradient],(Null|{})],
			Message[Warning::BufferNotCompatibleWithAnionGradient,	PickList[bufferOption,MatchQ[#, Alternatives@@Keys[bufferToIndex]]&/@bufferOption, False], object, type],
			If[MatchQ[PickList[bufferOption,MatchQ[#, Alternatives@@Keys[bufferToIndex]]&/@bufferOption],(Null|{})],
				Message[Warning::NoBuffersCompatibleWithGradient, object, Keys[bufferToIndex], type],
				Message[Warning::BufferNotCompatibleWithGradient,	PickList[bufferOption,MatchQ[#, Alternatives@@Keys[bufferToIndex]]&/@bufferOption, False], object, Keys[bufferToIndex]]
			]
		]
	];

	bufferIndices = ToList[Replace[buffersToInclude,bufferToIndex,{1}]];

	legend = If[MatchQ[OptionDefault[OptionValue[Legend]],Automatic],
		ToString/@buffersToInclude,
		OptionDefault[OptionValue[Legend]]
	];

	(* Resolve the raw numerical data that will be plotted *)
	plotData=domains[[All,{1,#}]]&/@bufferIndices;

	(*Determine the frame label. if an AnionGradient is plotted, it should be Eleunt Concentration on the Y axis instead of Composition*)
	frameLabel = If[MatchQ[type,Object[Method,IonChromatographyGradient]]&&!MatchQ[Lookup[myPacket,AnionGradient],(Null|{})],
		{"Time (Minutes)","Eluent Concentration (mM)"},
		{"Time (Minutes)","Composition"}
	];

	(* Options specific to your function which do not get passed directly to the underlying plot *)
	specificOptions={
		FrameLabel-> frameLabel,
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
