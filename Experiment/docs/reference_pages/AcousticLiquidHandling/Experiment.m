(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentAcousticLiquidHandling Input Widget*)

(* a widget for specifying  Source(s) in an input primitive for ExperimentAcousticLiquidHandling *)
acousticLiquidHandlingSourceWidgetPattern:=acousticLiquidHandlingSourceWidgetPattern=Alternatives[
	"Object"->Widget[
		Type->Object,
		Pattern:>ObjectP[Object[Sample]]
	],
	"Position"->{
		"Container"->Widget[
			Type->Object,
			Pattern:>ObjectP[Object[Container]]
		],
		"Well"->Widget[
			Type->String,
			Pattern:>WellPositionP,
			Size->Line,
			PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"
		]
	}
];

(* a widget for specifying  Destination(s) in an input primitive for ExperimentAcousticLiquidHandling *)
acousticLiquidHandlingDestinationWidgetPattern:=acousticLiquidHandlingDestinationWidgetPattern=Alternatives[
	"Object"->Widget[
		Type->Object,
		Pattern:>ObjectP[Object[Sample]]
	],
	"Position"->{
		"Container"->Widget[
			Type->Object,
			Pattern:>ObjectP[{Object[Container],Model[Container]}]
		],
		"Well"->Widget[
			Type->String,
			Pattern:>WellPositionP,
			Size->Line,
			PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"
		]
	}
];

acousticLiquidHandlingInputPatternWidget=Widget[
	Type->Primitive,
	Pattern:>SampleManipulationP,
	PrimitiveTypes->{Transfer,Aliquot,Consolidation},
	PrimitiveKeyValuePairs->{
		Transfer->{
			Source->acousticLiquidHandlingSourceWidgetPattern,
			Destination->acousticLiquidHandlingDestinationWidgetPattern,
			Amount->Widget[
				Type->Quantity,
				Pattern:>GreaterEqualP[0*Nanoliter],
				Units->{Nanoliter,{Nanoliter,Microliter}}
			],
			Optional[InWellSeparation]->Widget[
				Type->Enumeration,
				Pattern:>BooleanP,
				PatternTooltip->"Indicates how the droplets of different samples are transferred into the same destination well. If True, the droplets will be spatially separated such that they would not mix with each other until additional volume is added to the well."
			]
		},
		Aliquot->{
			Source->acousticLiquidHandlingSourceWidgetPattern,
			Destinations->Adder[acousticLiquidHandlingDestinationWidgetPattern],
			Amounts->Adder[
				Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Nanoliter],
					Units->{Nanoliter,{Nanoliter,Microliter}}
				]
			],
			Optional[InWellSeparation]->Widget[
				Type->Enumeration,
				Pattern:>BooleanP,
				PatternTooltip->"Indicates how the droplets of different samples are transferred into the same destination well. If True, the droplets will be spatially separated such that they would not mix with each other until additional volume is added to the well."
			]
		},
		Consolidation->{
			Sources->Adder[acousticLiquidHandlingSourceWidgetPattern],
			Destination->acousticLiquidHandlingDestinationWidgetPattern,
			Amounts->Adder[
				Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Nanoliter],
					Units->{Nanoliter,{Nanoliter,Microliter}}
				]
			],
			Optional[InWellSeparation]->Widget[
				Type->Enumeration,
				Pattern:>BooleanP,
				PatternTooltip->"Indicates how the droplets of different samples are transferred into the same destination well. If True, the droplets will be spatially separated such that they would not mix with each other until additional volume is added to the well."
			]
		}
	}
];


(* ::Subsubsection:: *)
(*ExperimentAcousticLiquidHandling*)


DefineUsage[ExperimentAcousticLiquidHandling,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAcousticLiquidHandling[Primitives]","Protocol"},
				Description->"generates a liquid transfer 'Protocol' to accomplish 'primitives', which involves one or several steps of transferring the samples specified in 'primitives'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Primitives",
							Description->"The liquid transfer to be performed by an acoustic liquid handler.",
							Widget->acousticLiquidHandlingInputPatternWidget,
							Expandable->False,
							NestedIndexMatching->False
						},
						IndexName->"experiment primitives"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"A protocol containing instructions to perform the requested sample transfer with the acoustic liquid handler.",
						Pattern:>ListableP[ObjectP[Object[Protocol,AcousticLiquidHandling]]]
					}
				}
			}
		},
		MoreInformation->{
			"The acoustic liquid handler can transfer liquid sample between 2.5 Nanoliter and 5 Microliter."
		},
		SeeAlso->{
			"ExperimentSampleManipulation",
			"ExperimentAliquot",
			"Transfer",
			"Aliquot",
			"Consolidation",
			"ExperimentAcousticLiquidHandlingOptions",
			"ExperimentAcousticLiquidHandlingPreview",
			"ValidExperimentAcousticLiquidHandlingQ"
		},
		Author->{
			"clayton.schwarz",
			"varoth.lilascharoen",
			"steven"
		}
	}
];