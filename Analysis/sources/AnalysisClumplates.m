

Clump[{
	SaveAs -> "CoordinatesListXY",
	Coordinates,
	Clumplate->True,
	TargetUnits->Automatic,
	Units :> With[
		{tu = $This[TargetUnits]}, 
		If[tu===Automatic,
			QuantityUnit[First[First[$This[Coordinates]]]],
			tu
		]
	],
	Magnitudes :> Map[QuantityMagnitude[#, $This[Units]]&,$This[Coordinates]],
	CoordinateBounds :> Map[CoordinateBounds[#]&,$This[Coordinates]],
	Domain :> $This[CoordinateBounds][[;;,1]],
	Range :> $This[CoordinateBounds][[;;,2]],
	DomainMagnitudes :> Map[QuantityMagnitude[#,First[$This[Units]]]&,$This[Domain]],
	RangeMagnitudes :> Map[QuantityMagnitude[#,Last[$This[Units]]]&,$This[Range]]
}];




AnalysisFunctionClumplate = Clump[{
	SaveAs -> "AnalyzeFunction",
	InheritFrom -> "FunctionIndexMatched",
	Clumplate->True,
	SetTriggers:>Null,
	FunctionName,
	Index,
	IndexLength :> Length[$This[Index]],
	Indices :> Range[$This[IndexLength]],
	
	StaticFigure,
	InterfaceElements -> {},
	<|
		Name->Previews,
		Static->True,
		Expression :> Map[With[{sf=$This[StaticFigure,{#}],dps=$This[InterfaceElements,{#}]},
		MakePreviewFunction[

		]]&,$This[Indices]]
	|>,
	DynamicPrimitives->{},
	EventActions->{},
	<|
		Name->PreviewsOld,
		Static->True,
		Expression :> Map[With[{sf=$This[StaticFigure,{#}],dps=$This[DynamicPrimitives,{#}],
		eas=$This[EventActions,{#}]},
		EventHandler[
			Show[sf, Graphics[dps]],
			eas
		]]&,$This[Indices]]
	|>,
	<|
		"Name"->"PreviewOld",
		"Static"->True,
		"Expression" :> Module[{},
			makeCommandBuilderLinks[$This[FunctionName],Unique["dvClump"],$This];
			If[$This[IndexLength]===1,
				First[$This[PreviewsOld]],
				SlideView[$This[PreviewsOld]]
			]
		]
	|>,
	ActiveIndex -> 1,
	<|
		"Name"->"Preview",
		"Static"->True,
		"Expression" :> Module[{},
			makeCommandBuilderLinks[$This[FunctionName],Unique["dvClump"],$This];
			If[$This[IndexLength]===1,
				First[$This[Previews]],
				SlideView[$This[Previews]]
			]
		]
	|>,
	SafeOptions :> SafeOptions[$This[FunctionName],$This[UnresolvedOptions]],
	DefaultedOptions :> (
		Association@SciCompFramework`Private`ExpandOptions[$This[FunctionName],$This[IndexLength], $This[SafeOptions], SymbolToString]
	),
	Result :> MapThread[If[TrueQ[#1],Upload[#2],#2]&,{$This[Upload],$This[Packet]}],
	ResolvedOptions :> {},
	Options :> $This[ResolvedOptions],
  	Out :> With[{c=$This}, c[First[c[Output]/.Preview->PreviewOld]]]
	(* Out :> $This *)
}
]

