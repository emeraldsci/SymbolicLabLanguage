(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentSampleManipulation*)


objectSpecificationWidgetPattern:=objectSpecificationWidgetPattern=Alternatives[
	(* the first widget which is different types of objects or models *)
	"Object" -> Widget[
		Type -> Object,
		Pattern :> ObjectP[{
			Object[Container,Vessel],
			Object[Container,ReactionVessel],
			Object[Container,Cuvette],
			Object[Sample],
			Model[Sample],
			Model[Container,Vessel],
			Model[Container,ReactionVessel],
			Model[Container,Cuvette]
		}]
	],
	"Position" -> {
		"Container" -> Widget[
			Type -> Object,
			Pattern :> ObjectP[{Object[Container],Model[Container]}]
		],
		"Well" -> Widget[
			Type -> String,
			Pattern :> WellPositionP,
			Size -> Line,
			PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"
		]
	}
];


pipettingParameterWidgets:=pipettingParameterWidgets={
	Optional[TipType] -> Alternatives[
		"Tip Type" -> Widget[
			Type -> Enumeration,
			Pattern :> TipTypeP,
			PatternTooltip -> "The tip type to use to transfer liquid in the manipulation."
		],
		"Tip Model" -> Widget[
			Type -> Object,
			Pattern :> ObjectP[Model[Item,Tips]],
			PatternTooltip -> "The tip model to use to transfer liquid in the manipulation.",
			PreparedContainer -> False
		]
	],
	Optional[TipSize] -> Widget[
		Type -> Quantity,
		Pattern :> GreaterP[0 Microliter],
		Units -> {Microliter,{Microliter,Milliliter}},
		PatternTooltip -> "The maximum volume of the tip used to transfer liquid in the manipulation."
	],
	Optional[AspirationRate] -> Widget[
		Type -> Quantity,
		Pattern :> RangeP[0.4 Microliter/Second,250 Microliter/Second],
		Units -> CompoundUnit[
			{1,{Milliliter,{Microliter,Milliliter,Liter}}},
			{-1,{Second,{Second,Minute}}}
		],
		PatternTooltip -> "The speed at which liquid should be drawn up into the pipette tip."
	],
	Optional[DispenseRate] -> Widget[
		Type -> Quantity,
		Pattern :> RangeP[0.4 Microliter/Second,250 Microliter/Second],
		Units -> CompoundUnit[
			{1,{Milliliter,{Microliter,Milliliter,Liter}}},
			{-1,{Second,{Second,Minute}}}
		],
		PatternTooltip -> "The speed at which liquid should be expelled from the pipette tip."
	],
	Optional[OverAspirationVolume] -> Widget[
		Type -> Quantity,
		Pattern :> RangeP[0 Microliter,50 Microliter],
		Units -> {Microliter,{Microliter,Milliliter}},
		PatternTooltip -> "The volume of air drawn into the pipette tip at the end of the aspiration of a liquid."
	],
	Optional[OverDispenseVolume] -> Widget[
		Type -> Quantity,
		Pattern :> RangeP[0 Microliter,300 Microliter],
		Units -> {Microliter,{Microliter,Milliliter}},
		PatternTooltip -> "The volume of air drawn blown out at the end of the dispensing of a liquid."
	],
	Optional[AspirationWithdrawalRate] -> Widget[
		Type -> Quantity,
		Pattern :> RangeP[0.3 Millimeter/Second, 160 Millimeter/Second],
		Units -> CompoundUnit[
			{1,{Millimeter,{Millimeter,Micrometer}}},
			{-1,{Second,{Second,Minute}}}
		],
		PatternTooltip -> "The speed at which the pipette is removed from the liquid after an aspiration."
	],
	Optional[DispenseWithdrawalRate] -> Widget[
		Type -> Quantity,
		Pattern :> RangeP[0.3 Millimeter/Second, 160 Millimeter/Second],
		Units -> CompoundUnit[
			{1,{Millimeter,{Millimeter,Micrometer}}},
			{-1,{Second,{Second,Minute}}}
		],
		PatternTooltip -> "The speed at which the pipette is removed from the liquid after a dispense."
	],
	Optional[AspirationEquilibrationTime] -> Widget[
		Type -> Quantity,
		Pattern :> RangeP[0 Second, 9.9 Second],
		Units -> {Second,{Second,Minute}},
		PatternTooltip -> "The delay length the pipette waits after aspirating before it is removed from the liquid."
	],
	Optional[DispenseEquilibrationTime] -> Widget[
		Type -> Quantity,
		Pattern :> RangeP[0 Second, 9.9 Second],
		Units -> {Second,{Second,Minute}},
		PatternTooltip -> "The delay length the pipette waits after dispensing before it is removed from the liquid."
	],
	Optional[AspirationMix] -> Widget[
		Type->Enumeration,
		Pattern:>BooleanP,
		PatternTooltip -> "Indicates if the source should be mixed before it is aspirated."
	],
	Optional[DispenseMix] -> Widget[
		Type->Enumeration,
		Pattern:>BooleanP,
		PatternTooltip -> "Indicates if the destination should be mixed after the source is dispensed."
	],
	Optional[AspirationMixVolume] -> Widget[
		Type -> Quantity,
		Pattern :> RangeP[0 Microliter,970 Microliter],
		Units -> {Microliter,{Microliter,Milliliter}},
		PatternTooltip -> "The volume quickly aspirated and dispensed to mix the source sample before it is aspirated."
	],
	Optional[DispenseMixVolume] -> Widget[
		Type -> Quantity,
		Pattern :> RangeP[0 Microliter,970 Microliter],
		Units -> {Microliter,{Microliter,Milliliter}},
		PatternTooltip -> "The volume quickly aspirated and dispensed to mix the destination sample after the source is dispensed."
	],
	Optional[AspirationNumberOfMixes] -> Widget[
		Type -> Number,
		Pattern :> GreaterEqualP[0],
		PatternTooltip -> "The number of times the source is quickly aspirated and dispensed to mix the source sample before it is aspirated."
	],
	Optional[DispenseNumberOfMixes] -> Widget[
		Type -> Number,
		Pattern :> GreaterEqualP[0],
		PatternTooltip -> "The number of times the destination is quickly aspirated and dispensed to mix the destination sample after the source is dispensed."
	],
	Optional[AspirationMixRate] -> Widget[
		Type -> Quantity,
		Pattern :> RangeP[0.4 Microliter/Second,250 Microliter/Second],
		Units -> CompoundUnit[
			{1,{Milliliter,{Microliter,Milliliter,Liter}}},
			{-1,{Second,{Second,Minute}}}
		],
		PatternTooltip -> "The speed at which liquid is aspirated and dispensed in a liquid before it is aspirated."
	],
	Optional[DispenseMixRate] -> Widget[
		Type -> Quantity,
		Pattern :> RangeP[0.4 Microliter/Second,250 Microliter/Second],
		Units -> CompoundUnit[
			{1,{Milliliter,{Microliter,Milliliter,Liter}}},
			{-1,{Second,{Second,Minute}}}
		],
		PatternTooltip -> "The speed at which liquid is aspirated and dispensed in a liquid after a dispense."
	],
	Optional[AspirationPosition] -> Widget[
		Type -> Enumeration,
		Pattern :> PipettingPositionP,
		PatternTooltip -> "The location from which liquid should be aspirated."
	],
	Optional[DispensePosition] -> Widget[
		Type -> Enumeration,
		Pattern :> PipettingPositionP,
		PatternTooltip -> "The location from which liquid should be dispensed."
	],
	Optional[AspirationPositionOffset] -> Widget[
		Type -> Quantity,
		Pattern :> GreaterEqualP[0 Millimeter],
		Units -> {Millimeter,{Millimeter}},
		PatternTooltip -> "The distance from the top or bottom of the container, depending on AspirationPosition, from which liquid should be aspirated."
	],
	Optional[DispensePositionOffset] -> Widget[
		Type -> Quantity,
		Pattern :> GreaterEqualP[0 Millimeter],
		Units -> {Millimeter,{Millimeter}},
		PatternTooltip -> "The distance from the top or bottom of the container, depending on DispensePosition, from which liquid should be dispensed."
	],
	Optional[CorrectionCurve] -> Adder[
		{
			"Target Volume" -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 1000 Microliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			],
			"Actual Volume" -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 1250 Microliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			]
		},
		Orientation -> Vertical,
		PatternTooltip -> "The relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume."
	],
	Optional[DynamicAspiration] -> Widget[
		Type->Enumeration,
		Pattern:>BooleanP,
		PatternTooltip -> "Indicates if droplet formation should be prevented during liquid transfer. This should only be used for solvents that have high vapor pressure."
	]
};

sampleManipulationPWidget=Adder[Widget[
	Type->Primitive,
	Pattern:>SampleManipulationP,
	PrimitiveTypes->{Define,Transfer,Mix,Aliquot,Consolidation,FillToVolume,Incubate,Filter,MoveToMagnet,RemoveFromMagnet,Wait,Centrifuge,ReadPlate,Resuspend},
	PrimitiveKeyValuePairs -> {
		Define -> {
			Name -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line
			],
			Optional[Sample] -> Alternatives[
				"Sample" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample],Model[Sample]}],
					PatternTooltip -> "The sample or model object whose referenced name is defined by this Define primitive.",
					PreparedSample -> False,
					PreparedContainer -> False
				],
				"Position" -> {
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Container],Model[Container]}],
						PatternTooltip -> "The container in a {container, well} position tuple which is referenced by the Name in this Define primitive.",
						PreparedSample -> False,
						PreparedContainer -> False
					],
					"Well" -> Widget[
						Type -> String,
						Pattern :> WellPositionP,
						Size -> Line,
						PatternTooltip -> "The well in a {container, well} position tuple which is referenced by the Name in this Define primitive."
					]
				}
			],
			Optional[Container] -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Container],Model[Container]}],
				PatternTooltip -> "The container object whose reference name is defined by this Define primitive.",
				PreparedSample -> False,
				PreparedContainer -> False
			],
			Optional[Well] -> Widget[
				Type -> String,
				Pattern :> WellPositionP,
				Size -> Line,
				PatternTooltip -> "The container well of the sample whose reference name is defined by this Define primitive."
			],
			Optional[ContainerName] -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line,
				PatternTooltip -> "If a specified sample is named, it's container can be named using this option."
			],
			Optional[Model] -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample]}],
				PatternTooltip -> "If a new sample will be created in the defined position, this option specifies the model of the created sample.",
				PreparedSample -> False,
				PreparedContainer -> False
			],
			Optional[StorageCondition] -> Alternatives[
				"Storage Type" -> Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP,
					PatternTooltip -> "If a new sample will be created in the defined position, this option specifies the enumerated storage condition type of the created sample."
				],
				"Storage Object" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[StorageCondition]],
					PatternTooltip -> "If a new sample will be created in the defined position, this option specifies the model representing the storage condition of the created sample.",
					PreparedSample -> False,
					PreparedContainer -> False
				]
			],
			Optional[ExpirationDate] -> Widget[
				Type -> Date,
				Pattern :> _?DateObjectQ,
				TimeSelector -> True,
				PatternTooltip -> "If a new sample will be created in the defined position, this option specifies the expiration date of the created sample."
			],
			Optional[TransportWarmed] -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Kelvin],
				Units -> Celsius,
				PatternTooltip -> "If a new sample will be created in the defined position, this option specifies the temperature at which it should be transported."
			],
			Optional[ModelName] -> Widget[
				Type -> String,
				Pattern :> WellPositionP,
				Size -> Line,
				PatternTooltip -> "If a new sample will be created in the defined position, a new model will be created with this name."
			],
			Optional[ModelType] ->Widget[
				Type -> Expression,
				Pattern :> TypeP[Model[Sample]],
				Size -> Line,
				PatternTooltip -> "If a new sample will be created in the defined position, a new model will be created with this type."
			],
			Optional[State] -> Widget[
				Type -> Enumeration,
				Pattern :> ModelStateP,
				PatternTooltip -> "If a new sample will be created in the defined position, a new model will be created with this state."
			],
			Optional[Expires] -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP,
				PatternTooltip -> "If a new sample will be created in the defined position, a new model will be created with this expiration value."
			],
			Optional[ShelfLife] -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Day],
				Units -> Day,
				PatternTooltip -> "If a new sample will be created in the defined position, a new model will be created with this shelf life."
			],
			Optional[UnsealedShelfLife] -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Day],
				Units -> Day,
				PatternTooltip -> "If a new sample will be created in the defined position, a new model will be created with this unsealed shelf life."
			],
			Optional[DefaultStorageCondition] -> Alternatives[
				"Storage Type" -> Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP,
					PatternTooltip -> "If a new sample will be created in the defined position, a new model will be created with this enumerated storage condition type of the created sample."
				],
				"Storage Object" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[StorageCondition]],
					PatternTooltip -> "If a new sample will be created in the defined position, a new model will be created with this model representing the storage condition of the created sample.",
					PreparedSample -> False,
					PreparedContainer -> False
				]
			],
			Optional[DefaultTransportWarmed] -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Kelvin],
				Units -> Celsius,
				PatternTooltip -> "If a new sample will be created in the defined position, a new model will be created with this default transportation temperature."
			]
		},
		Transfer -> {
			Source -> objectSpecificationWidgetPattern,
			Destination -> objectSpecificationWidgetPattern,
			Amount -> Alternatives[
				"Volume" -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0*Microliter],
					Units -> {Microliter,{Microliter,Milliliter,Liter}}
				],
				"Mass" -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0*Gram],
					Units -> {Gram,{Microgram,Milligram,Gram,Kilogram}}
				],
				"Count" -> Widget[
					Type -> Number,
					Pattern :> GreaterEqualP[0, 1]
				]
			],
			Sequence@@pipettingParameterWidgets,
			Optional[Resuspension] -> Widget[
				Type->Enumeration,
				Pattern :> BooleanP,
				PatternTooltip -> "Indicates if this transfer is resuspending a solid. If True, liquid will be dispensed at the top of the destination's container."
			],
			Optional[TransferType] -> Widget[
				Type->Enumeration,
				Pattern :> (Liquid|Slurry|Solid|Solvent),
				PatternTooltip -> "Describes the sample consistency being transferred. Unspecified pipetting parameters may be resolved based on this value."
			]
		},

		FillToVolume -> {
			Source -> objectSpecificationWidgetPattern,
			Destination -> objectSpecificationWidgetPattern,
			FinalVolume -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0*Microliter],
				Units -> {Microliter,{Microliter,Milliliter,Liter}}
			],
			Optional[TransferType] -> Widget[
				Type->Enumeration,
				Pattern :> (Liquid|Slurry|Solid|Solvent),
				PatternTooltip -> "Describes the sample consistency being transferred. Unspecified pipetting parameters may be resolved based on this value."
			]
		},
		Resuspend -> {
			Sample -> objectSpecificationWidgetPattern,
			Volume -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[1 Microliter, 20 Liter],
				Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
			],
			Optional[Diluent] -> objectSpecificationWidgetPattern,
			Optional[MixType] -> Alternatives[
				Widget[Type -> Enumeration,Pattern :> MixTypeP],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			Optional[MixUntilDissolved] -> Alternatives[
				Widget[Type -> Enumeration,Pattern :> BooleanP],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			Optional[MixVolume] -> Alternatives[
				Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			Optional[NumberOfMixes] -> Alternatives[
				Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			Optional[MaxNumberOfMixes] -> Alternatives[
				Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			Optional[IncubationTime] -> Widget[Type->Quantity,Pattern :> RangeP[0 Minute,72 Hour],Units -> {Minute,{Minute,Second}}],
			Optional[MaxIncubationTime] -> Alternatives[
				Widget[Type->Quantity,Pattern :> RangeP[0 Minute,72 Hour],Units -> {Minute,{Minute,Second}}],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			Optional[IncubationInstrument] -> Alternatives[
				Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			Optional[IncubationTemperature] -> Widget[Type -> Quantity,Pattern :> GreaterEqualP[4 Celsius],Units -> Celsius],
			Optional[AnnealingTime] -> Widget[Type->Quantity,Pattern :> GreaterEqualP[0 Minute],Units -> {Minute,{Minute,Second}}],
			Sequence@@pipettingParameterWidgets
		},
		Aliquot->{
			Source -> objectSpecificationWidgetPattern,
			Destinations -> Adder[objectSpecificationWidgetPattern],
			Amounts ->Alternatives[
				"Volume" -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0*Microliter],
					Units -> {Microliter,{Microliter,Milliliter,Liter}}
				],
				"Mass" -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0*Gram],
					Units -> {Gram,{Microgram,Milligram,Gram,Kilogram}}
				],
				"Count" -> Widget[
					Type -> Number,
					Pattern :> GreaterEqualP[0, 1]
				],
				Adder[
					Alternatives[
						"Volume" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0*Microliter],
							Units -> {Microliter,{Microliter,Milliliter,Liter}}
						],
						"Mass" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0*Gram],
							Units -> {Gram,{Microgram,Milligram,Gram,Kilogram}}
						],
						"Count" -> Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[0, 1]
						]
					]
				]
			],
			Optional[TransferType]->Widget[Type->Enumeration,Pattern:>(Liquid|Slurry|Solid)],

			Sequence@@pipettingParameterWidgets
		},

		Consolidation->{
			Sources -> Adder[objectSpecificationWidgetPattern],
			Destination -> objectSpecificationWidgetPattern,
			Amounts -> Adder[
				Alternatives[
					"Volume" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0*Microliter],
						Units -> {Microliter,{Microliter,Milliliter,Liter}}
					],
					"Mass" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0*Gram],
						Units -> {Gram,{Microgram,Milligram,Gram,Kilogram}}
					],
					"Count" -> Widget[
						Type -> Number,
						Pattern :> GreaterEqualP[0, 1]
					]
				]
			],
			Optional[TransferType]->Widget[Type->Enumeration,Pattern:>(Liquid|Slurry|Solid)],

			Sequence@@pipettingParameterWidgets
		},

		Mix -> {
			Sample -> Alternatives[
				Adder[objectSpecificationWidgetPattern],
				objectSpecificationWidgetPattern
			],
			Optional[NumberOfMixes] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[MixVolume] -> Alternatives[
				Adder[
					Alternatives[

						Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
		(* Keys that are shared between Micro and Macro *)
			Time -> Alternatives[
				Adder[Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}]],
				Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}]
			],
			Optional[Temperature] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient]]
					]
				],
				Alternatives[
					Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient]]
				]
			],
			Optional[MixRate] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
		(* Keys that are specific to Micro *)
			Optional[Preheat] -> Alternatives[
				Adder[Widget[Type -> Enumeration,Pattern :> BooleanP]],
				Widget[Type -> Enumeration,Pattern :> BooleanP]
			],
			Optional[ResidualIncubation] -> Alternatives[
				Adder[Widget[Type -> Enumeration,Pattern :> BooleanP]],
				Widget[Type -> Enumeration,Pattern :> BooleanP]
			],
			Optional[ResidualTemperature] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient,Null]]
					]
				],
				Alternatives[
					Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient,Null]]
				]
			],
			Optional[ResidualMix] -> Alternatives[
				Adder[Widget[Type -> Enumeration,Pattern :> BooleanP]],
				Widget[Type -> Enumeration,Pattern :> BooleanP]
			],
			Optional[ResidualMixRate] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
		(* Keys that are specific to macro *)
			Optional[MixType] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Enumeration,Pattern :> MixTypeP],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Enumeration,Pattern :> MixTypeP],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[Instrument] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[MixUntilDissolved] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Enumeration,Pattern :> BooleanP],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Enumeration,Pattern :> BooleanP],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[MaxNumberOfMixes] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[MaxTime] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[AnnealingTime] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type->Quantity,Pattern :> GreaterEqualP[0 Minute],Units -> {Minute,{Minute,Second}}],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type->Quantity,Pattern :> GreaterEqualP[0 Minute],Units -> {Minute,{Minute,Second}}],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			]
		},

		Incubate -> {
			Sample -> Alternatives[
				Adder[objectSpecificationWidgetPattern],
				objectSpecificationWidgetPattern
			],
		(* Keys that are shared between Micro and Macro *)
			Time -> Alternatives[
				Adder[Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}]],
				Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}]
			],
			Optional[Temperature] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient]]
					]
				],
				Alternatives[
					Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient]]
				]
			],
			Optional[MixRate] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
		(* Keys that are specific to Micro *)
			Optional[Preheat] -> Alternatives[
				Adder[Widget[Type -> Enumeration,Pattern :> BooleanP]],
				Widget[Type -> Enumeration,Pattern :> BooleanP]
			],
			Optional[ResidualIncubation] -> Alternatives[
				Adder[Widget[Type -> Enumeration,Pattern :> BooleanP]],
				Widget[Type -> Enumeration,Pattern :> BooleanP]
			],
			Optional[ResidualTemperature] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient,Null]]
					]
				],
				Alternatives[
					Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient,Null]]
				]
			],
			Optional[ResidualMix] -> Alternatives[
				Adder[Widget[Type -> Enumeration,Pattern :> BooleanP]],
				Widget[Type -> Enumeration,Pattern :> BooleanP]
			],
			Optional[ResidualMixRate] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
		(* Keys that are specific to macro *)
			Optional[MixType] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Enumeration,Pattern :> MixTypeP],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Enumeration,Pattern :> MixTypeP],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[Instrument] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[NumberOfMixes] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[MixVolume] -> Alternatives[
				Adder[
					Alternatives[

						Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[MixUntilDissolved] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Enumeration,Pattern :> BooleanP],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Enumeration,Pattern :> BooleanP],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[MaxNumberOfMixes] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[MaxTime] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[AnnealingTime] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type->Quantity,Pattern :> GreaterEqualP[0 Minute],Units -> {Minute,{Minute,Second}}],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type->Quantity,Pattern :> GreaterEqualP[0 Minute],Units -> {Minute,{Minute,Second}}],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			]
		},
		Filter -> {
			Sample -> Alternatives[
				Adder[objectSpecificationWidgetPattern],
				objectSpecificationWidgetPattern
			],
		(* Keys that are shared between Micro and Macro *)
			Optional[Time] -> Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
			Optional[Pressure] -> Widget[Type->Quantity,Pattern :> RangeP[1 PSI,40 PSI],Units -> {PSI,{PSI,Bar,Pascal}}],
			Optional[CollectionContainer] -> Alternatives[
				"Object" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Container, Plate], Model[Container, Plate]}]
				],
				"Defined Reference" -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				]
			],
			Optional[Filter] -> Alternatives[
				"Object" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Container, Plate, Filter],
						Object[Container, Plate, Filter],
						Model[Container, Vessel, Filter],
						Object[Container, Vessel, Filter],
						Model[Item,Filter],
						Object[Item,Filter]
					}]
				],
				"Defined Reference" -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				"Automatic" -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic]
				]
			],
			Optional[FilterStorageCondition] -> Alternatives[
				"Storage Type" -> Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP|Disposal
				],
				"Storage Object" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[StorageCondition]],
					PreparedSample -> False,
					PreparedContainer -> False
				],
				"Automatic" -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic]
				]
			],
			Optional[MembraneMaterial] -> Widget[
				Type -> Enumeration,
				Pattern :> Append[FilterMembraneMaterialP,Automatic]
			],
			Optional[PoreSize] -> Widget[
				Type -> Enumeration,
				Pattern :> Append[FilterSizeP,Automatic]
			],
			Optional[FiltrationType] -> Widget[
				Type -> Enumeration,
				Pattern :> Append[FiltrationTypeP,Automatic]
			],
			Optional[Instrument] -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]
				],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null,Automatic]]
			],
			Optional[FilterHousing] -> Alternatives[
				"Object" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Instrument,FilterHousing],
						Object[Instrument,FilterHousing]
					}]
				],
				"Automatic" -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic,Null]
				]
			],
			Optional[Syringe] -> Alternatives[
				"Object" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Container,Syringe],
						Object[Container,Syringe]
					}]
				],
				"Automatic" -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic,Null]
				]
			],
			Optional[Sterile] -> Widget[Type -> Enumeration,Pattern :> BooleanP],
			Optional[MolecularWeightCutoff] -> Widget[
				Type -> Enumeration,
				Pattern :> Append[FilterMolecularWeightCutoffP,Automatic]
			],
			Optional[PrefilterMembraneMaterial] -> Widget[
				Type -> Enumeration,
				Pattern :> Append[FilterMembraneMaterialP,Automatic]
			],
			Optional[PrefilterPoreSize] -> Widget[
				Type -> Enumeration,
				Pattern :> Append[FilterSizeP,Automatic]
			],
			Optional[Temperature] -> Alternatives[
				Widget[Type -> Quantity,Pattern :> GreaterEqualP[4 Celsius],Units -> Celsius],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic,Null]]
			],
			Optional[Intensity] -> Alternatives[
				Widget[Type -> Quantity,Pattern :> GreaterP[0 RPM],Units -> {RPM,{RPM,GravitationalAcceleration}}],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic,Null]]
			]
		},
		MoveToMagnet->{
			Sample->objectSpecificationWidgetPattern
		},
		RemoveFromMagnet->{
			Sample->objectSpecificationWidgetPattern
		},
		Wait -> {
			Duration->Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Second],
				Units -> {Second,{Second,Minute}}
			]
		},
		Centrifuge -> {
			Sample -> Alternatives[
				Adder[objectSpecificationWidgetPattern],
				objectSpecificationWidgetPattern
			],
			Time -> Alternatives[
				Adder[Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}]],
				Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}]
			],
			Optional[Temperature] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient]]
					]
				],
				Alternatives[
					Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient]]
				]
			],
			Optional[Instrument] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Object,Pattern :> ObjectP[{Object[Instrument,Centrifuge],Model[Instrument,Centrifuge]}]],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Object,Pattern :> ObjectP[{Object[Instrument,Centrifuge],Model[Instrument,Centrifuge]}]],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[Intensity] -> Alternatives[
				Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units->Alternatives[RPM]],
				Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units->Alternatives[GravitationalAcceleration]]
			]
		},
		ReadPlate -> {
			Sample -> Alternatives[
				Adder[objectSpecificationWidgetPattern],
				objectSpecificationWidgetPattern
			],
			Blank -> Alternatives[
				Adder[objectSpecificationWidgetPattern],
				objectSpecificationWidgetPattern
			],
			Type -> Widget[Type -> Enumeration, Pattern :> ReadPlateTypeP],
			Optional[BlankAbsorbance] -> Widget[Type->Enumeration,Pattern:>Append[BooleanP,Automatic]],
			Optional[Mode] -> Widget[Type -> Enumeration, Pattern :> (Fluorescence|TimeResolvedFluorescence|Automatic)],
			Optional[Wavelength] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type->Quantity,Pattern:>RangeP[220 Nanometer,1000 Nanometer],Units:>Nanometer],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic,Null]]
					]
				],
				Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[220 Nanometer,1000 Nanometer],Units:>Nanometer],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic,Null]]
				]
			],
			Optional[ExcitationWavelength] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic,Null]]
					]
				],
				Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic,Null]]
				]
			],
			Optional[EmissionWavelength] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic,Null]]
					]
				],
				Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic,Null]]
				]
			],
			Optional[WavelengthSelection] -> Widget[Type->Enumeration,Pattern:>LuminescenceWavelengthSelectionP],
			Optional[PrimaryInjectionSample] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Widget[Type -> Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			Optional[SecondaryInjectionSample] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[TertiaryInjectionSample] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[QuaternaryInjectionSample] -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[PrimaryInjectionVolume] -> Alternatives[
				Adder[
					Alternatives[
						Widget[
							Type->Quantity,
							Pattern:>RangeP[0.5 Microliter,300 Microliter],
							Units->Microliter
						],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.5 Microliter,300 Microliter],
						Units->Microliter
					],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[SecondaryInjectionVolume] -> Alternatives[
				Adder[
					Alternatives[
						Widget[
							Type->Quantity,
							Pattern:>RangeP[0.5 Microliter,300 Microliter],
							Units->Microliter
						],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.5 Microliter,300 Microliter],
						Units->Microliter
					],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[TertiaryInjectionVolume] -> Alternatives[
				Adder[
					Alternatives[
						Widget[
							Type->Quantity,
							Pattern:>RangeP[0.5 Microliter,300 Microliter],
							Units->Microliter
						],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.5 Microliter,300 Microliter],
						Units->Microliter
					],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[QuaternaryInjectionVolume] -> Alternatives[
				Adder[
					Alternatives[
						Widget[
							Type->Quantity,
							Pattern:>RangeP[0.5 Microliter,300 Microliter],
							Units->Microliter
						],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.5 Microliter,300 Microliter],
						Units->Microliter
					],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Optional[Gain] -> Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[1 Percent,95 Percent],Units:>Percent],
				Widget[Type->Quantity,Pattern:>RangeP[1 Microvolt,4095 Microvolt],Units:>Microvolt],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic]]
			],
			Optional[DelayTime] -> Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[0 Microsecond,8000 Microsecond],Units:>{1,{Microsecond,{Microsecond,Millisecond,Second}}}],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic]]
			],
			Optional[ReadTime] -> Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[1 Microsecond,10000 Microsecond],Units:>{1,{Microsecond,{Microsecond,Millisecond,Second}}}],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic]]
			],
			Optional[ReadLocation] -> Widget[Type->Enumeration,Pattern:>Append[ReadLocationP,Automatic]],
			Optional[Temperature] -> Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[$AmbientTemperature,45 Celsius],Units:>{1,{Celsius,{Celsius,Fahrenheit}}}],
				Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
			],
			Optional[EquilibrationTime] -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute,1 Hour],Units:>{1,{Minute,{Second,Minute,Hour}}}],
			Optional[NumberOfReadings] -> Widget[Type->Number,Pattern:>RangeP[1,200]],
			Optional[AdjustmentSample] -> Alternatives[
				objectSpecificationWidgetPattern,
				Widget[Type->Enumeration,Pattern:>Alternatives[FullPlate,Automatic]]
			],
			Optional[FocalHeight] -> Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[0 Millimeter,25 Millimeter],Units:>Millimeter],
				Widget[Type->Enumeration,Pattern:>Alternatives[Auto,Automatic]]
			],
			Optional[PrimaryInjectionFlowRate] -> Widget[Type->Enumeration,Pattern:>Append[BMGFlowRateP,Automatic]],
			Optional[SecondaryInjectionFlowRate] -> Widget[Type->Enumeration,Pattern:>Append[BMGFlowRateP,Automatic]],
			Optional[TertiaryInjectionFlowRate] -> Widget[Type->Enumeration,Pattern:>Append[BMGFlowRateP,Automatic]],
			Optional[QuaternaryInjectionFlowRate] -> Widget[Type->Enumeration,Pattern:>Append[BMGFlowRateP,Automatic]],
			Optional[PlateReaderMix] -> Widget[Type->Enumeration,Pattern:>Append[BooleanP,Automatic]],
			Optional[PlateReaderMixTime] -> Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[1 Second,1 Hour],Units:>{1,{Second,{Second,Minute,Hour}}}],
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
			],
			Optional[PlateReaderMixRate] -> Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[100 RPM,700 RPM],Units:>RPM],
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
			],
			Optional[PlateReaderMixMode] -> Widget[Type->Enumeration,Pattern:>Append[MechanicalShakingP,Automatic]],
			Optional[ReadDirection] -> Widget[Type->Enumeration,Pattern:>Append[ReadDirectionP,Automatic]],
			Optional[InjectionSampleStorageCondition] -> Widget[Type->Enumeration,Pattern:>(SampleStorageTypeP|Disposal|Null)],
			Optional[RunTime] -> Widget[Type->Quantity,Pattern:>GreaterP[0 Second],Units:>{Hour,{Hour,Minute,Second}}],
			Optional[ReadOrder] -> Widget[Type->Enumeration,Pattern:>ReadOrderP],
			Optional[PlateReaderMixSchedule] -> Widget[Type->Enumeration,Pattern:>MixingScheduleP],
			Optional[PrimaryInjectionTime] -> Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Second],Units->Second],
			Optional[SecondaryInjectionTime] -> Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Second],Units->Second],
			Optional[TertiaryInjectionTime] -> Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Second],Units->Second],
			Optional[QuaternaryInjectionTime] -> Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Second],Units->Second],
			Optional[SpectralScan] -> Alternatives[
				Adder[Widget[Type->Enumeration,Pattern:>FluorescenceScanTypeP]],
				Widget[Type->Enumeration,Pattern:>Append[FluorescenceScanTypeP,Automatic]]
			],
			Optional[ExcitationWavelengthRange] -> Alternatives[
				Span[
					Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
					Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer]
				],
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
			],
			Optional[EmissionWavelengthRange] -> Alternatives[
				Span[
					Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
					Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer]
				],
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
			],
			Optional[ExcitationScanGain] -> Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[0 Percent,95 Percent],Units:>Percent],
				Widget[Type->Quantity,Pattern:>RangeP[0 Microvolt,4095 Microvolt],Units:>Microvolt],
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
			],
			Optional[AdjustmentEmissionWavelength] -> Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
			],
			Optional[AdjustmentExcitationWavelength] -> Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
			],
			Optional[IntegrationTime] -> Widget[Type->Quantity,Pattern:>RangeP[0.01 Second,100 Second],Units:>{1,{Second,{Microsecond,Millisecond,Second}}}],
			Optional[QuantificationWavelength] -> Alternatives[
				Adder[
					Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Nanometer, 1000 Nanometer],
							Units -> Alternatives[Nanometer]
						],
						Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
					]
				],
				Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Nanometer, 1000 Nanometer],
						Units -> Alternatives[Nanometer]
					],
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
				]
			],
			Optional[QuantifyConcentration] -> Alternatives[
				Adder[Widget[Type ->Enumeration, Pattern :> Append[BooleanP,Automatic]]],
				Widget[Type ->Enumeration, Pattern :> Append[BooleanP,Automatic]]
			]
		},
		Cover -> {
			Sample -> objectSpecificationWidgetPattern,
			Optional[Cover] -> Alternatives[
				Alternatives[
					Widget[Type -> Object,Pattern :> ObjectP[{Object[Item,Lid],Model[Item,Lid]}]],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic]]
				],
				Adder[
					Alternatives[
						Widget[Type -> Object,Pattern :> ObjectP[{Object[Item,Lid],Model[Item,Lid]}]],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic]]
					]
				]
			]
		},
		Uncover -> {
			Sample -> objectSpecificationWidgetPattern
		}
	}
]];

DefineUsage[ExperimentSampleManipulation,
		{
		BasicDefinitions -> {
		(* Basic definition Primitive *)
			{
				Definition -> {"ExperimentSampleManipulation[Primitives]", "Protocol"},
				Description -> "generates a sample manipulation 'Protocol' to accomplish 'primitives', which involves one or several steps of transfering, aliquoting, consolidating, or mixing of the samples specified in 'primitives'.",
				Inputs :> {
					{
						InputName->"Primitives",
						Description -> "The sample manipulations to be performed.",
						Widget-> sampleManipulationPWidget
					}
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "The protocol object describing the sample manipulation experiment.",
						Pattern :> ListableP[ObjectP[Object[Protocol,SampleManipulation]]]
					}
				}
			}
		},
		MoreInformation -> {
			"There are several different base levels of 'primitives': Transfer, Aliquot, Consolidation, Mix, FillToVolume, Incubate, Filter, Wait, MoveToMagnet, and RemoveFromMagnet.",
			"Manipulations that exceed 5 mL or use containers not automation-friendly, will be performed as a macro manipulation.",
			"Transfer has the fields: Source, Destination, Amount, Resuspension, TransferType.",
			"Aliquot has the fields: Source, Destinations, Amounts, TransferType.",
			"Consolidation has the fields: Sources, Destination, Amounts, TransferType.",
			"Mix has the fields: Source, MixVolume, MixCount.",
			"FillToVolume has the fields: Source, Destination, FinalVolume, TransferType.",
			"Incubate has the fields: Sample, Time, Temperature, MixRate, and the micro specific fields: Preheat, ResidualIncubation, ResidualTemperature, ResidualMix, ResidualMixRate, and the macro specific fields: MixType, Instrument, NumberOfMixes, MixVolume, MixUntilDissolved, MaxNumberOfMixes, MaxTime and AnnealingTime.",
			"Filter has the fields: Sample, Pressure, Time, CollectionContainer, Filter, MembraneMaterial, PoreSize, FiltrationType, Instrument, FilterHousing, Syringe, MolecularWeightCutoff, PrefilterMembraneMaterial, PrefilterPoreSize, Temperature, and Intensity.",
			"Wait has the field: Duration.",
			"MoveToMagnet has the field: Sample.",
			"RemoveFromMagnet has the field: Sample.",
			"Sources may be samples, or container locations.",
			"Destinations may be samples, models, container locations, or model containers."
			(* TODO add technical specifications from website. This is split into 1) Micro Liquid Handling, 2) Macro Liquid Handling, 3) Solid handling sub-milligram 4) Solid handling milligram scale 5) Solid handling (gram to kg) (DOUBLECHECK WITH CAM) *)

			(* "Technical Specifications:", *)
			(* Use a Grid to list information from the website *)
			(* Grid[{
				{"Overhead Imaging","3.15 megapixel images"},
				{SpanFromAbove,"Top or bottom LED illumination"},
				{"Side-On Imaging","5 megapixel images"},
				{SpanFromAbove,"4mm, 6mm, or 12 mm focal length lenses"},
				{"Workflow Integrations","Can be combined stepwise with any macro liquid handling, solid handling, and any other preparatory or analytical methods listed."},
				{SpanFromAbove,"Can utilize any liquid or solid reagent sources allowed under Emerald's safety requirements and state regulations."}
			},Alignment\[Rule]Left]	*)
		},
		SeeAlso -> {
			"Transfer",
			"Mix",
			"Aliquot",
			"Consolidation",
			"FillToVolume",
			"Incubate",
			"Pellet",
			"Wait",
			"Define",
			"Filter",
			"Centrifuge",
			"Cover",
			"Uncover",
			"ExperimentSampleManipulationOptions",
			"ValidSampleManipulationSampleQ",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentMeasureWeight",
			"ExperimentImageSample",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author -> {"robert", "alou"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ExperimentSampleManipulationOptions*)


DefineUsage[ExperimentSampleManipulationOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentSampleManipulationOptions[Primitives]", "ResolvedOptions"},
				Description -> "returns the resolved options for ExperimentSampleManipulation when it is called on 'primitives'.",
				Inputs :> {
					{
						InputName->"Primitives",
						Description -> "The sample manipulations to be performed.",
						Widget-> sampleManipulationPWidget
					}
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentSampleManipulation is called on 'primitives'.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentSampleManipulation if it were called on 'primitives'."
		},
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"ExperimentSampleManipulationPreview",
			"ValidExperimentSampleManipulationQ"
		},
		Author -> {"robert", "alou", "waltraud.mair"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ExperimentSampleManipulationPreview*)


DefineUsage[ExperimentSampleManipulationPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentSampleManipulationPreview[Primitives]", "Preview"},
				Description -> "returns the graphical preview for ExperimentSampleManipulation when it is called on 'mySampleManipulation'.",
				Inputs :> {
					{
						InputName->"Primitives",
						Description -> "The sample manipulations to be performed.",
						Widget-> sampleManipulationPWidget
					}
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview of the protocol object to be uploaded when calling ExperimentSampleManipulation on 'primitives'.",
						Pattern :>  ListableP[ObjectP[Object[Protocol,SampleManipulation]]]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"ExperimentSampleManipulationOptions",
			"ValidExperimentSampleManipulationQ"
		},
		Author -> {"robert", "alou", "waltraud.mair"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentSampleManipulationQ*)


DefineUsage[ValidExperimentSampleManipulationQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentSampleManipulationQ[Primitives]", "Booleans"},
				Description -> "checks whether the provided 'primitives' and the specified options are valid for calling ExperimentSampleManipulation.",
				Inputs :> {
					{
						InputName->"Primitives",
						Description -> "The sample manipulations to be performed.",
						Widget-> sampleManipulationPWidget
					}
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Returns a boolean for whether or not the ExperimentSampleManipulation call is valid.",
						Pattern :>  _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"ExperimentSampleManipulationOptions",
			"ExperimentSampleManipulationPreview"
		},
		Author -> {"robert", "alou", "waltraud.mair"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Transfer*)


DefineUsage[Transfer,
	{
		BasicDefinitions -> {
			{"Transfer[transferRules]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes a transfer of a source to a destination."}
		},
		Input:>{
			{
				"transferRules",
				{
					Source-> (NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP}),

					Amount->(GreaterEqualP[0 Milliliter]|GreaterEqualP[0 Gram]|GreaterEqualP[0, 1]),

					Destination-> (NonSelfContainedSampleP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP})
				},
				"The list of key/value pairs specifying the samples, amounts, and destination involved in the transfer primitive."
			}
		},
		Output:>{
			{"primitive",_Transfer,"A sample manipulation primitive containing information for specification and execution of a general sample transfer."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Mix",
			"Aliquot",
			"FillToVolume",
			"Incubate",
			"Pellet",
			"Wait",
			"Define",
			"Filter",
			"Centrifuge",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"robert", "alou"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Consolidation*)


DefineUsage[Consolidation,
	{
		BasicDefinitions -> {
			{"Consolidation[consolidationRules]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes a transfer of multiple sources to a single destination."}
		},
		Input:>{
			{
				"consolidationRules",
				{
					Sources->{(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP})..},
					Amounts->{GreaterEqualP[0 Milliliter]..}|{GreaterEqualP[0 Gram]|GreaterEqualP[0, 1]..},
					Destination->
					(NonSelfContainedSampleP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP})
				},
				"The list of key/value pairs describing the transfer of specified amounts of multiple sources and their destination."
			}
		},
		Output:>{
			{"primitive",_Consolidation,"A sample manipulation primitive containing information for specification and execution of a consolidation of multiple samples into a single location."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Mix",
			"Aliquot",
			"FillToVolume",
			"Incubate",
			"Pellet",
			"Wait",
			"Define",
			"Filter",
			"Centrifuge",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"robert", "alou"}
	}
];



(* ::Subsubsection::Closed:: *)
(*Resuspend*)


DefineUsage[Resuspend,
	{
		BasicDefinitions -> {
			{"Resuspend[resuspendRules]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes the resuspension of a sample in solvent."}
		},
		Input:>{
			{
				"resuspendRules",
				{
					Source->
					(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP}),
					Volume->GreaterEqualP[0 Milliliter]
				},
				"The list of key/value pairs specifying the samples and volume of solvent to transfer into the sample."
			}
		},
		Output:>{
			{"primitive",_Resuspend,"A sample manipulation primitive containing information for specification and execution of the resuspension of a sample."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"ExperimentResuspend",
			"Mix",
			"Aliquot",
			"FillToVolume",
			"Incubate",
			"Pellet",
			"Wait",
			"Define",
			"Filter",
			"Centrifuge"
		},
		Author->{"daniel.shlian"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Aliquot*)


DefineUsage[Aliquot,
	{
		BasicDefinitions -> {
			{"Aliquot[aliquotRules]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes aliquoting of a single source to multiple destinations."}
		},
		Input:>{
			{
				"aliquotRules",
				{
					Source->				{(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP})..},
					Amounts->{GreaterEqualP[0 Milliliter]..}|{GreaterEqualP[0 Gram]|GreaterEqualP[0, 1]..},
					Destinations->(NonSelfContainedSampleP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP})
				},
				"The list of key/value pairs describing the source sample, amounts to aliquot, and destinations."
			}
		},
		Output:>{
			{"primitive",_Aliquot,"A sample manipulation primitive containing information for specification and execution of a general sample aliquoting."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Mix",
			"Transfer",
			"Consolidation",
			"FillToVolume",
			"Incubate",
			"Pellet",
			"Wait",
			"Define",
			"Filter",
			"Centrifuge",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"robert", "alou"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Mix*)


DefineUsage[Mix,
	{
		BasicDefinitions -> {
			{"Mix[Sample]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes mixing a sample using bench-top instrumentation or by pipetting on a micro liquid handling robot."}
		},
		MoreInformation->{
			"Mix can be performed on both micro and macro liquid handling scale.",
			"Mixing on micro liquid handling scale is always performed by pipetting and requires the keys MixVolume and NumberOfMixes.",
			"For mixing on micro liquid handling scale, Preheat, MixFlowRate, MixPosition, MixPositionOffset, CorrectionCurve, as well as TipSize and TipType are optional keys.",
			"If the MixVolume and NumberOfMixes keys are specified, the liquid handling scale will resolve to micro liquid handling, unless LiquidHandlingScale is specified to MacroLiquidHandling or other manipulations require macro.",
			"Mix on macro liquid handling scale can be performed using all mix types also offered by ExperimentMix (for available types, see MixTypeP).",
			"If MixType is set to anything except Pipette, and/or Instrument is specified, the liquid handling scale automatically resolves to MacroLiquidHandling.",
			"For mixing on macro liquid handling scale, ExperimentSampleManipulation will automatically choose the optimal mixing technique and/or parameters if not all necessary keys are provided, according to ExperimentMix option resolution behaviour."
		},
		Input:>{
			{
				"Sample",
				(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP}),
				"The sample to be mixed."
			}
		},
		Output:>{
			{"primitive",_Mix,"A sample manipulation primitive containing information for specification and execution of mixing a sample."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Transfer",
			"Aliquot",
			"Consolidation",
			"FillToVolume",
			"Incubate",
			"Pellet",
			"Wait",
			"Define",
			"Filter",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"robert", "alou"}
	}
];


(* ::Subsubsection::Closed:: *)
(*FillToVolume*)


DefineUsage[FillToVolume,
	{
		BasicDefinitions -> {
			{"FillToVolume[fillToVolumeRules]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes transfering a source into a destination until a desired volume is reached."}
		},
		MoreInformation->{
			"The destination container will be filled with the source up to the specified volume using a series of successively smaller transfers.",
			"The volume log of samples prepared using a FillToVolume primitive will contain records of each transfer in the series as well as a final entry set to the volume specified in the FillToVolume primitive.",
			"A single fill to volume can be used for each destination container per each ExperimentSampleManipulation call.",
			"FillToVolume must be performed on the macro liquid handling scale due to the nature of its manipulation."
		},
		Input:>{
			{
				"fillToVolumeRules",
				{
					Source->		(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP}),
					Destination->(NonSelfContainedSampleP|ObjectP[{Object[Container,Vessel]}]|modelVesselP),
					FinalVolume->GreaterEqualP[0 Microliter]
				},
				"The list of key/value pairs describing the sample, destination, and final volume after completion of the tranfser."
			}
		},
		Output:>{
			{"primitive",_FillToVolume,"A sample manipulation primitive containing information for specification and execution of a general sample transfer."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Mix",
			"Aliquot",
			"Consolidation",
			"Incubate",
			"Pellet",
			"Wait",
			"Define",
			"Filter",
			"Centrifuge",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"robert", "alou"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Incubate*)


DefineUsage[Incubate,
	{
		BasicDefinitions -> {
			{"Incubate[Sample]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes incubating and mixing a sample at a specified temperature and shaking rate for a specified amount of time."}
		},
		MoreInformation->{
			"Incubate can be performed on both micro and macro liquid handling scale.",
			"Time and Temperature are required fields for micro liquid handling scale, MixRate is optional.",
			"MixRate, ResidualIncubation, ResidualTemperature, ResidualMix, and ResidualMixRate are optional keys not specific to either scale.",
			"Preheat is an optional keys specific to  micro liquid handling. If specified, the scale will resolve to micro, if possible. Do not specify these keys if MacroLiquidHandling scale is desired.",
			"MixType,Instrument, NumberOfMixes, MixVolume, MixUntilDissolved, MaxNumberOfMixes, MaxTime and AnnealingTime are optional keys specific to macro liquid handling. If specified, the scale will resolve to macro, if possible. Do not specify these keys if MicroLiquidHandling scale is desired.",
			"On the macro liquid handling scale, ResidualMixRate and ResidualTemperature must be identical to MixRate and Temperature, if specified. If ResidualMixRate and/or ResidualTemperature are specified, while MixRate and/or Temperature are left empty, MixRate and Temperature will automatically resolve to the values specified in ResidualMixRate an/or ResidualTemperature. If mixing is occurring, and ResidualIncubation is set to True, then ResidualMix cannot be set to False. Reversely, if ResidualMix is set to True, ResidualIncubation cannot be set to False.",
			"If no scale-specific key is specified, the liquid handling scale will resolve to micro liquid handling, unless LiquidHandlingScale is specified to MacroLiquidHandling or other manipulations require macro.",
			"For incubating on macro liquid handling scale, the resolution of keys that are not specified is identical to the option resolution behavior in ExperimentIncubate."
		},
		Input:>{
			{
				"Sample",
				(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP}),
				"The sample to be incubated."
			}
		},
		Output:>{
			{"primitive",_Incubate,"A sample manipulation primitive containing information for specification and execution of incubating a sample."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Transfer",
			"Aliquot",
			"Consolidation",
			"Mix",
			"Wait",
			"Define",
			"Filter",
			"Centrifuge",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"robert", "alou"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Centrifuge*)


DefineUsage[Centrifuge,
	{
		BasicDefinitions -> {
			{"Centrifuge[centrifugeRules]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes centrifuging a sample at a specified intensity for a specified amount of time."}
		},
		MoreInformation->{
			"Currently Centrifuge can only used on a macro liquid handling scale.",
			"Any or all of the following keys can be specified: Time, Intensity, Temperature, Instrument."
		},
		Input:>{
			{
				"centrifugeRules",
				{
					Sample-> ListableP[(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP})],
					Time->ListableP[GreaterEqualP[0 Minute]],
					Intensity->Automatic|Null|GreaterP[0 RPM]|GreaterP[0 GravitationalAcceleration],
					Temperature->ListableP[Ambient|TemperatureP],
					Instrument->ListableP[ObjectP[{Model[Instrument,Centrifuge],Model[Instrument,Centrifuge]}]|Null]
				},
				"The list of key/value pairs that specify the samples and their centrifugation parameters."
			}
		},
		Output:>{
			{"primitive",_Centrifuge,"A sample manipulation primitive containing information about how a sample should be centrifuged."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Transfer",
			"Aliquot",
			"Consolidation",
			"Mix",
			"Wait",
			"Define",
			"Filter",
			"Incubate",
			"Pellet",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"robert", "alou"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Pellet*)


DefineUsage[Pellet,
	{
		BasicDefinitions -> {
			{"Pellet[pelletRules]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes pelleting a sample at a specified intensity for a specified amount of time."}
		},
		MoreInformation->{
			"Currently pelleting can only used on a macro liquid handling scale due to operators having to visually determine the boundary between the pellet and the supernatant.",
			"For more information about Pelleting, please refer to the ExperimentPellet help file."
		},
		With[{
				insertMe = Sequence @@ (# -> Lookup[FirstCase[OptionDefinition[ExperimentPellet], KeyValuePattern["OptionSymbol" -> #]], "Pattern"]&) /@ {
					SupernatantVolume, SupernatantTransferInstrument,
					ResuspensionVolume, ResuspensionInstrument, ResuspensionMix,
					ResuspensionMixType, ResuspensionMixUntilDissolved,
					ResuspensionMixInstrument, ResuspensionMixTime,
					ResuspensionMixMaxTime, ResuspensionMixDutyCycle,
					ResuspensionMixRate, ResuspensionNumberOfMixes,
					ResuspensionMaxNumberOfMixes, ResuspensionMixVolume,
					ResuspensionMixTemperature, ResuspensionMixMaxTemperature,
					ResuspensionMixAmplitude
				}
			},
			Input:>{
				{
					"pelletRules",
					{
						Sample -> ListableP[ObjectP[{Object[Sample], Object[Container]}]],
						Instrument -> ListableP[Automatic | ObjectP[{Model[Instrument,Centrifuge],Object[Instrument,Centrifuge]}]],
						Intensity -> ListableP[Automatic | GreaterP[0 RPM] | GreaterP[0 GravitationalAcceleration]],
						Time -> ListableP[Automatic | TimeP],
						Temperature -> ListableP[Automatic | Ambient | RangeP[4 Celsius,40 Celsius]],

						SupernatantDestination->ListableP[ObjectP[{Object[Sample], Object[Container]}]|Waste],
						ResuspensionSource->ListableP[ObjectP[{Object[Sample], Object[Container]}]],

						(* Copy over the options from ExperimentPellet. *)
						insertMe
					},
					"Specific key/value pairs specifying the samples/containers to be involved in the pellet primitive."
				}
			}
		],
		Output:>{
			{"primitive",_Pellet,"A sample manipulation primitive containing information about how a sample should be pelleted."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Transfer",
			"Aliquot",
			"Consolidation",
			"Mix",
			"Wait",
			"Define",
			"Filter",
			"Incubate",
			"Pellet",
			"ExperimentPellet",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"taylor.hochuli", "harrison.gronlund"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Wait*)


DefineUsage[Wait,
	{
		BasicDefinitions -> {
			{"Wait[duration]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes the pausing of a specified duration."}
		},
		MoreInformation->{
			"Wait can be used on both micro and macro liquid handling scale.",
			"Note that if the liquid handling scale is set or resolved to macro liquid handling and Duration is specified to a value above 15 minutes, the time of the wait step may be inexact.",
			"If a wait step is executed at the end of a series of sample manipulation primitives, the samples will be kept for the specified duration at room temperature before storing them away."
		},
		Input:>{
				{
					"duration",
					GreaterP[0 Second],
					"The amount of time to pause during execution of primitives."
				}
		},
		Output:>{
			{"primitive",_Wait,"A sample manipulation primitive containing information for specification and execution of a wait step."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Transfer",
			"Mix",
			"Aliquot",
			"FillToVolume",
			"Incubate",
			"Pellet",
			"Define",
			"Filter",
			"Centrifuge"
		},
		Author->{"robert", "alou"}
	}
];



(* ::Subsubsection::Closed:: *)
(*Define*)


DefineUsage[Define,
	{
		BasicDefinitions -> {
			{"Define[name]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes the definition of a sample, container, or model's name reference in other primitives."}
		},
		Input:>{
			{
				"name",
				_String,
				"The named reference to a sample, container, or model."
			}
		},
		Output:>{
			{"primitive",_Define,"A sample manipulation primitive containing information for a named reference in a set of primitives."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Transfer",
			"Mix",
			"Aliquot",
			"FillToVolume",
			"Incubate",
			"Pellet",
			"Filter",
			"Wait",
			"Centrifuge"
		},
		Author->{"robert", "alou"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Filter*)


DefineUsage[Filter,
	{
		BasicDefinitions -> {
			{"Filter[Sample]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes filtering a sample through a specified filter by applying a specified pressure for a specified amount of time."}
		},
		MoreInformation->{
			"Filter can be performed on both micro and macro liquid handling scale.",
			"Micro liquid handling scale requires the Filter plate to be either Model[Container, Plate, Filter, \"Plate Filter, GlassFiber, 30.0um, 1mL\"] or Model[Container, Plate, Filter, \"Plate Filter, GlassFiber, 30.0um, 2mL\"].",
			"Micro liquid handling scale requires the CollectionContainer to be Model[Container, Plate, Filter, \"96-well 2mL Deep Well Plate\"].",
			"Keys shared among micro and macro are: Sample, Time, CollectionContainer. Note that Time in micro liquid handling denotes the amount of time that the specified pressure is applied, while in macro liquid handling it denotes the time of centrifugation (if type Centrifuge) or pressure being applied (type PeristalticPump). Furthermore, in macro liquid handling, CollectionContainer is identical to ContainerOut in ExperimentFilter which determines the container the sample's filtrate is collected.",
			"Micro liquid handling: Time and Pressure are required fields if requesting or resolving to micro liquid handling scale, CollectionContainer is optional. Pressure is a key specific to micro liquid handling. If specified, the scale will resolve to micro, if possible. Do not specify the Pressure key if MacroLiquidHandling scale is desired.",
			"Macro liquid handling: Filter, MembraneMaterial, PoreSize, FiltrationType, Instrument, FilterHousing, Syringe, MolecularWeightCutoff, PrefilterMembraneMaterial, PrefilterPoreSize, Temperature, and Intensity are keys specific for MacroLiquidHandling. If specified, the scale will resolve to macro, if possible. Do not specify any of these keys if MicroLiquidHandling scale is desired.",
			"For filter primitives on macro liquid handling scale, the resolution of keys set to Automatic or keys not specified is identical to the option resolution behavior in ExperimentFilter.",
			"For filter primitives on macro liquid handling scale, the key Sample must point to a sample that is inside a container from which the filtration can readily occur without additional transfers. The CollectionContainer is required to be a container in which the filtrate can directly be collected without an intermediate container. Should your sample or desired final container not meet these requirements, user Transfer primitives before and/or after the filter primitive (see examples in ExperimentSampleManipulation documentation).",
			"Suitable Macro filter primitive Sample's and CollectionContainer container types:",
			Grid[{
				{"Filtration Type", "Sample's container", "Collection container"},
				{"PeristalticPump", "Any Object[Container,Vessel]", "Any Object[Container,Vessel] that can hold the sample's volume"},
				{"Syringe", "Any Object[Container,Vessel]", "Any Object[Container,Vessel] that can hold the sample's volume"},
				{"Vacuum (with Instrument being Filterblock)", "Object[Container,Plate,Filter] with 96 wells", "Model/Object[Container, Plate, \"96-well 2mL Deep Well Plate\"]"},
				{"Vacuum (with Filter being Model[Item,Filter]", "Any Object[Container,Vessel]", "Any Object[Container,Vessel] that can hold the sample's volume"},
				{"Vacuum (with Filter being Model[Container,Filter]", "Currently not supported", "Currently not supported"},
				{"Centrifuge (with Filter being Model[Container,Filter]","Currently not supported", "Currently not supported"}
			}]

			},
		Input:>{
			{
				"Sample",
				ListableP[(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP})],
				"The sample/container to be filtered."
			}
		},
		Output:>{
			{"primitive",_Filter,"A sample manipulation primitive containing information for specification and execution of filtering a sample."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Transfer",
			"Aliquot",
			"Consolidation",
			"Mix",
			"Wait",
			"Define",
			"Incubate",
			"Pellet",
			"Centrifuge",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"robert", "alou"}
	}
];



(* ::Subsubsection::Closed:: *)
(*MoveToMagnet*)


DefineUsage[MoveToMagnet,
	{
		BasicDefinitions->{
			{"MoveToMagnet[Sample]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes subjecting a sample to magnetization."}
		},
		MoreInformation->{
			"Only 96-well plates are currently supported for MoveToMagnet primitives."
		},
		Input:>{
			{
				"Sample",
				(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP}),
				"The sample/container to be magnetized."
			}
		},
		Output:>{
			{"primitive",_MoveToMagnet,"A sample manipulation primitive containing information for specification and execution of the magnetization of a sample."}
		},
		Sync->Automatic,
		SeeAlso->{
			"ExperimentSampleManipulation",
			"RemoveFromMagnet",
			"Define",
			"Transfer",
			"Aliquot",
			"Mix",
			"Incubate",
			"Wait",
			"Filter"
		},
		Author->{"melanie.reschke", "yanzhe.zhu"}
	}
];



(* ::Subsubsection::Closed:: *)
(*RemoveFromMagnet*)


DefineUsage[RemoveFromMagnet,
	{
		BasicDefinitions->{
			{"RemoveFromMagnet[Sample]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes removing a sample from magnetization."}
		},
		MoreInformation->{
			"Only 96-well plates are currently supported for RemoveFromMagnet primitives."
		},
		Input:>{
			{
				"Sample",
				(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP}),
				"The sample/container to be removed from magnetization."
			}
		},
		Output:>{
			{"primitive",_RemoveFromMagnet,"A sample manipulation primitive containing information for specification and execution of the removal of a sample from magnetization."}
		},
		Sync->Automatic,
		SeeAlso->{
			"ExperimentSampleManipulation",
			"MoveToMagnet",
			"Define",
			"Transfer",
			"Aliquot",
			"Mix",
			"Incubate",
			"Wait",
			"Filter"
		},
		Author->{"melanie.reschke", "yanzhe.zhu"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ReadPlate*)


DefineUsage[ReadPlate,
	{
		BasicDefinitions -> {
			{"ReadPlate[Sample]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes placing a plate into a plate-reader instrument and reading it under a certain set of specified parameters."}
		},
		MoreInformation->{},
		Input:>{
			{
				"Sample",
				ListableP[(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP})],
				"The sample whose absorbance/fluorescence/luminescence should be read."
			}
		},
		Output:>{
			{"primitive",_ReadPlate,"A sample manipulation primitive containing information for specification and execution of reading a plate in a plate reader."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Transfer",
			"Aliquot",
			"Consolidation",
			"Mix",
			"Wait",
			"Define",
			"Incubate",
			"Pellet",
			"Centrifuge",
			"Filter",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"robert", "alou"}
	}
];



(* ::Subsubsection::Closed:: *)
(*Cover*)


DefineUsage[Cover,
	{
		BasicDefinitions -> {
			{"Cover[Sample]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes placing a lid onto a plate."}
		},
		MoreInformation->{},
		Input:>{
			{
				"Sample",
				ListableP[(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP})],
				"The sample who should be covered."
			}
		},
		Output:>{
			{"primitive",_Cover,"A sample manipulation primitive containing information for specification and execution of lidding a plate."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Uncover",
			"Transfer",
			"Aliquot",
			"Consolidation",
			"Mix",
			"Wait",
			"Define",
			"Incubate",
			"Pellet",
			"Centrifuge",
			"Filter",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"robert"}
	}
];

(* ::Subsubsection::Closed:: *)
(*Uncover*)


DefineUsage[Uncover,
	{
		BasicDefinitions -> {
			{"Uncover[Sample]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes removing a lid from a plate."}
		},
		MoreInformation->{},
		Input:>{
			{
				"Sample",
				ListableP[(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP})],
				"The sample who should be uncovered."
			}
		},
		Output:>{
			{"primitive",_Uncover,"A sample manipulation primitive containing information for specification and execution of removing a lid from a plate."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Cover",
			"Transfer",
			"Aliquot",
			"Consolidation",
			"Mix",
			"Wait",
			"Define",
			"Incubate",
			"Pellet",
			"Centrifuge",
			"Filter",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"robert"}
	}
];



(* ::Subsubsection::Closed:: *)
(*OptimizePrimitives*)


DefineUsage[OptimizePrimitives,
		{
		BasicDefinitions -> {
		(* Basic definition Primitive *)
			{
				Definition -> {"OptimizePrimitives[myPrimitives]", "optimizedPrimitives"},
				Description -> "transforms 'myPrimitives' into a set of primitives that are formatted to be executed most efficiently by a liquid handler.",
				Inputs :> {
					{
						InputName -> "myPrimitives",
						Description -> "The sample manipulation primitives to be optimized.",
						Widget-> Adder[Widget[
							Type->Primitive,
							Pattern:>SampleManipulationP,
							PrimitiveTypes->{Transfer,Mix,Aliquot,Consolidation,FillToVolume,Incubate,Wait,Define},
							PrimitiveKeyValuePairs -> {
								Transfer->{
									Source->Alternatives[
										(* the first widget which is different types of objects or models *)
										Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette],Object[Sample],Model[Sample],Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette]}]],
										(* the second widget where user defines plate plus position *)
										{
											"Plate"->Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Plate],Model[Container,Plate]}]],
											"Well Position"->Widget[Type->String,Pattern:>WellPositionP,Size->Word,PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"]
										}
									],
									Destination->Alternatives[
										(* the first widget which is different types of objects or models (except Model[Sample]) *)
										Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette],Object[Sample],Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette]}]],
										(* the second widget where user defines plate plus position *)
										{
										"Plate"->Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Plate],Model[Container,Plate]}]],
										"Well Position"->Widget[Type->String,Pattern:>WellPositionP,Size->Word,PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"]
										}
									],
									Amount->Alternatives[
										Widget[
											Type->Quantity,
											Pattern:>(GreaterEqualP[0*Microliter]|GreaterEqualP[0*Gram]),
											Units->Alternatives[
												{Microliter,{Microliter,Milliliter,Liter}},
												{Gram,{Microgram,Milligram,Gram,Kilogram}}]
										],
										Widget[
											Type -> Number,
											Pattern :> GreaterEqualP[0, 1]
										]
									],
									Resuspension->Widget[Type->Enumeration,Pattern:>BooleanP],
									TransferType->Widget[Type->Enumeration,Pattern:>(Liquid|Slurry|Solid|Solvent)]
								},

								FillToVolume->{
									Source->Alternatives[
										(* the first widget which is different types of objects or models *)
										Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette],Object[Sample],Model[Sample],Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette]}]],
										(* the second widget where user defines plate plus position *)
										{
										"Plate"->Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Plate],Model[Container,Plate]}]],
										"Well Position"->Widget[Type->String,Pattern:>WellPositionP,Size->Word,PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"]
										}
									],
									Destination->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Object[Container,Vessel],Model[Container,Vessel]}]],
									FinalVolume->Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
									TransferType->Widget[Type->Enumeration,Pattern:>(Liquid|Slurry|Solid)]
								},

								Aliquot->{
									Source->Alternatives[
										(* the first widget which is different types of objects or models *)
										Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette],Object[Sample],Model[Sample],Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette]}]],
										(* the second widget where user defines plate plus position *)
										{
										"Plate"->Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Plate],Model[Container,Plate]}]],
										"Well Position"->Widget[Type->String,Pattern:>WellPositionP,Size->Word,PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"]
										}
									],
									Destinations-> Adder[
										Alternatives[
											(* the first widget which is different types of objects or models (except Model[Sample]) *)
											Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Object[Container,Vessel],Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette]}]],
											(* the second widget where user defines plate plus position *)
											{
											"Plate"->Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Plate],Model[Container,Plate]}]],
											"Well Position"->Widget[Type->String,Pattern:>WellPositionP,Size->Word,PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"]
											}
										]
									],
									Amounts ->Alternatives[
										Widget[
											Type->Quantity,
											Pattern:>(GreaterEqualP[0*Microliter]|GreaterEqualP[0*Gram]),
											Units->Alternatives[
												{Microliter,{Microliter,Milliliter,Liter}},
												{Gram,{Microgram,Milligram,Gram,Kilogram}}
											]
										],
										Widget[
											Type->Number,
											Pattern:>GreaterEqualP[0,1]
										],
										Adder[
											Alternatives[
												Widget[
													Type->Quantity,
													Pattern:>(GreaterEqualP[0*Microliter]|GreaterEqualP[0*Gram]),
													Units->Alternatives[
														{Microliter,{Microliter,Milliliter,Liter}},
														{Gram,{Microgram,Milligram,Gram,Kilogram}}
													]
												],
												Widget[
													Type->Number,
													Pattern:>GreaterEqualP[0,1]
												]
											]
										]
									],
									TransferType->Widget[Type->Enumeration,Pattern:>(Liquid|Slurry|Solid)]
								},

								Consolidation->{
									Sources->Adder[
									Alternatives[
										(* here comes the first widget which is different types of objects or models *)
										Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette],Object[Sample],Model[Sample],Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette]}]],
										(* here comes the widget where user defines plate plus position *)
										{
										"Plate"->Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Plate],Model[Container,Plate]}]],
										"Well Position"->Widget[Type->String,Pattern:>WellPositionP,Size->Word,PatternTooltip->"A well position in a plate specified in the form of a letter character followed by a non-zero digit, for example A1"]
										}
									]
									],
									Destination->Alternatives[
										(* the first widget which is different types of objects or models (except Model[Sample]) *)
										Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette],Object[Sample],Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette]}]],
										(* the second widget where user defines plate plus position *)
										{
										"Plate"->Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Plate],Model[Container,Plate]}]],
										"Well Position"->Widget[Type->String,Pattern:>WellPositionP,Size->Word,PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"]
										}
									],
									Amounts->Adder[
										Alternatives[
											Widget[
												Type->Quantity,
												Pattern:>(GreaterEqualP[0*Microliter]|GreaterEqualP[0*Gram]),
												Units->Alternatives[
													{Microliter,{Microliter,Milliliter,Liter}},
													{Gram,{Microgram,Milligram,Gram,Kilogram}}]
											],
											Widget[
												Type -> Number,
												Pattern :> GreaterEqualP[0, 1]
											]
										]
									],
									TransferType->Widget[Type->Enumeration,Pattern:>(Liquid|Slurry|Solid)]
								},

								Mix->{
									Source->Alternatives[
										(* the first widget which is different types of objects or models *)
										Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette],Object[Sample],Model[Sample],Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette]}]],
										(* the second widget where user defines plate plus position *)
										{
										"Plate"->Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Plate],Model[Container,Plate]}]],
										"Well Position"->Widget[Type->String,Pattern:>WellPositionP,Size->Word,PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"]
										}
									],
									MixVolume->Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
									MixCount->Widget[Type->Number,Pattern:>GreaterEqualP[1]]
								},

								Incubate -> {
									Sample -> Alternatives[
										Adder[
											Alternatives[
												(* the first widget which is different types of objects or models *)
												Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette],Object[Sample],Model[Sample],Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette]}]],
												(* the second widget where user defines plate plus position *)
												{
													"Plate"->Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Plate],Model[Container,Plate]}]],
													"Well Position"->Widget[Type->String,Pattern:>WellPositionP,Size->Word,PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"]
												}
											]
										],
										Alternatives[
											(* the first widget which is different types of objects or models *)
											Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette],Object[Sample],Model[Sample],Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette]}]],
											(* the second widget where user defines plate plus position *)
											{
												"Plate"->Widget[Type->Object,Pattern:>ObjectP[{Object[Container,Plate],Model[Container,Plate]}]],
												"Well Position"->Widget[Type->String,Pattern:>WellPositionP,Size->Word,PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"]
											}
										]
									],
									(* Keys that are shared between Micro and Macro *)
									Time -> Alternatives[
										Adder[Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}]],
										Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}]
									],
									Temperature -> Alternatives[
										Adder[
											Alternatives[
												Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient]]
											]
										],
										Alternatives[
											Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
											Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient]]
										]
									],
									MixRate -> Alternatives[
										Adder[
											Alternatives[
												Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
											]
										],
										Alternatives[
											Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
											Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
										]
									],
								(* Keys that are specific to Micro *)
									Preheat -> Alternatives[
										Adder[Widget[Type -> Enumeration,Pattern :> BooleanP]],
										Widget[Type -> Enumeration,Pattern :> BooleanP]
									],
									ResidualIncubation -> Alternatives[
										Adder[Widget[Type -> Enumeration,Pattern :> BooleanP]],
										Widget[Type -> Enumeration,Pattern :> BooleanP]
									],
									ResidualTemperature -> Alternatives[
										Adder[
											Alternatives[
												Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient,Null]]
											]
										],
										Alternatives[
											Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
											Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient,Null]]
										]
									],
									ResidualMix -> Alternatives[
										Adder[Widget[Type -> Enumeration,Pattern :> BooleanP]],
										Widget[Type -> Enumeration,Pattern :> BooleanP]
									],
									ResidualMixRate -> Alternatives[
										Adder[
											Alternatives[
												Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
											]
										],
										Alternatives[
											Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
											Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
										]
									],
									(* Keys that are specific to macro *)
									MixType -> Alternatives[
										Adder[
											Alternatives[
												Widget[Type -> Enumeration,Pattern :> MixTypeP],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
											]
										],
										Alternatives[
											Widget[Type -> Enumeration,Pattern :> MixTypeP],
											Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
										]
									],
									Instrument -> Alternatives[
										Adder[
											Alternatives[
												Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
											]
										],
										Alternatives[
											Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
											Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
										]
									],
									NumberOfMixes -> Alternatives[
										Adder[
											Alternatives[
												Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
											]
										],
										Alternatives[
											Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
											Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
										]
									],
									MixVolume->Alternatives[
										Adder[
											Alternatives[

												Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
											]
										],
										Alternatives[
											Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
											Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
										]
									],
									MixUntilDissolved -> Alternatives[
										Adder[
											Alternatives[
												Widget[Type -> Enumeration,Pattern :> BooleanP],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
											]
										],
										Alternatives[
											Widget[Type -> Enumeration,Pattern :> BooleanP],
											Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
										]
									],
									MaxNumberOfMixes -> Alternatives[
										Adder[
											Alternatives[
												Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
											]
										],
										Alternatives[
											Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
											Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
										]
									],
									MaxTime -> Alternatives[
										Adder[
											Alternatives[
												Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
											]
										],
										Alternatives[
											Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
											Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
										]
									],
									AnnealingTime -> Alternatives[
										Adder[
											Alternatives[
												Widget[Type->Quantity,Pattern :> GreaterEqualP[0 Minute],Units -> {Minute,{Minute,Second}}],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
											]
										],
										Alternatives[
											Widget[Type->Quantity,Pattern :> GreaterEqualP[0 Minute],Units -> {Minute,{Minute,Second}}],
											Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
										]
									]
								},
								Wait->{
									Duration->Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0 Second],
										Units -> {Second,{Second,Minute}}
									]
								},
								Define -> {
									Name -> Widget[
										Type -> String,
										Pattern :> _String,
										Size -> Line
									],
									Sample -> Alternatives[
										Widget[
											Type -> Object,
											Pattern :> ObjectP[{
												Object[Sample],
												Model[Sample]
											}]
										],
										{
											"Container" -> Widget[
												Type -> Object,
												Pattern :> ObjectP[{
													Object[Container],
													Model[Container]
												}]
											],
											"Well" -> Widget[
												Type -> String,
												Pattern :> WellPositionP,
												Size -> Line
											]
										}
									]
								}
							}
						]]
					}
				},
				Outputs :> {
					{
						OutputName -> "optimizedPrimitives",
						Description -> "A set of transformed primitives that are formatted to be most efficient for the liquid handler to execute.",
						Pattern :> {SampleManipulationP...}
					}
				}
			}
		},
		MoreInformation -> {
			"In general, the optimal format for liquid handler execution is the use of as many pipetting channels simultaneously.",
			"To acheive this, pipetting steps from input primitives are merged into primitives that use as many channels as possible.",
			"Each element in the index-matching Source, Destination, Amount lists represents the pipetting performed by a single channel.",
			"If a source list has multiple values, it means that the same pipetting tip will aspirate from multiple positions.",
			"Similarly, if a destination list has multiple values, it means that the same pipetting tip will dispense to multiple positions.",
			"The order of source to destination liquid transfers is preserved during optimization."
		},
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Transfer",
			"Mix",
			"Aliquot",
			"Consolidation",
			"FillToVolume",
			"Incubate",
			"Pellet",
			"Wait",
			"Define",
			"Filter",
			"Centrifuge"
		},
		Author -> {"robert", "alou"}
	}
];


(* ::Subsubsection:: *)
(*ImportSampleManipulation*)
DefineUsage[ImportSampleManipulation,
	{
		BasicDefinitions->{
			{
				Definition->{"ImportSampleManipulation[filePaths]","primitives"},
				Description->"given 'filePaths' to an excel file(s) of the appropriate format, will return a corresponding list of Sample Manipulation 'primitives'.",
				Inputs:>{
					{
						InputName->"filePaths",
						Description->"Path on local computer to an excel file(s) to be translated to Sample Manipulation primitives.",
						Widget->Widget[Type->String,Pattern:>FilePathP,Size->Word]
					}
				},
				Outputs:>{
					{
						OutputName->"primitives",
						Description->"Sample manipulation primitives corresponding to input.",
						Pattern:>ListableP[{SampleManipulationP..}]
					}
				}
			},
			{
				Definition->{"ImportSampleManipulation[cloudFiles]","primitives"},
				Description->"given 'cloudFiles' to an excel file(s) of the appropriate format, will return a corresponding list of Sample Manipulation 'primitives'.",
				Inputs:>{
					{
						InputName->"cloudFiles",
						Description->"EmeraldCloudFiles corresponding to an excel file(s) to be translated to Sample Manipulation primitives.",
						Widget->Widget[Type->Expression,Pattern:>ObjectP[Object[EmeraldCloudFile]],Size->Word]
					}
				},
				Outputs:>{
					{
						OutputName->"primitives",
						Description->"Sample manipulation primitives corresponding to input.",
						Pattern:>ListableP[{SampleManipulationP..}]
					}
				}
			},
			{
				Definition->{"ImportSampleManipulation[rawData]","primitives"},
				Description->"given 'rawData' corresponding to an excel file(s) of the appropriate format, will return a corresponding list of Sample Manipulation 'primitives'.",
				Inputs:>{
					{
						InputName->"rawData",
						Description->"RawData corresponding to an excel file(s) to be translated to Sample Manipulation primitives.",
						Widget->Widget[Type->Expression,Pattern:>{{(_String|NumericP|BooleanP)..}..},Size->Paragraph]
					}
				},
				Outputs:>{
					{
						OutputName->"primitives",
						Description->"Sample manipulation primitives corresponding to input.",
						Pattern:>ListableP[{SampleManipulationP..}]
					}
				}
			},
			{
				Definition->{"ImportSampleManipulation[inputs]","primitives"},
				Description->"given 'inputs' of the appropriate format, will return a corresponding list of Sample Manipulation 'primitives'.",
				Inputs:>{
					{
						InputName->"inputs",
						Description->"A list of paths on local computer,cloud files, or raw data corresponding to excel file(s) to be translated to Sample Manipulation primitives.",
						Widget->Widget[Type->Expression,Pattern:>{Alternatives[ObjectP[Object[EmeraldCloudFile]],FilePathP,{{(_String|NumericP|BooleanP)..}..}]..},Size->Paragraph]
					}
				},
				Outputs:>{
					{
						OutputName->"primitives",
						Description->"Sample manipulation primitives corresponding to input.",
						Pattern:>ListableP[{_Primitive ..}]
					}
				}
			}
		},
		SeeAlso->{
			"ValidImportSampleManipulationQ",
			"ExperimentSampleManipulation",
			"ValidExperimentSampleManipulationQ",
			"OptimizePrimitives"
		},
		Author->{"ben", "olatunde.olademehin", "harrison.gronlund"}
	}
];


(* ::Subsubsection:: *)
(*ValidImportSampleManipulationQ*)
DefineUsage[ValidImportSampleManipulationQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidImportSampleManipulationQ[filePaths]","testSummary"},
				Description->"given 'filePaths' to an excel file(s) of the appropriate format, will return a corresponding list of Sample Manipulation 'primitives'.",
				Inputs:>{
					{
						InputName->"filePaths",
						Description->"Path on local computer to an excel file(s) to be translated to Sample Manipulation primitives.",
						Widget->Widget[Type->String,Pattern:>FilePathP,Size->Word]
					}
				},
				Outputs:>{
					{
						OutputName->"testSummary",
						Description->"Test summary determining whether the excel files corresponding to the given file paths have a valid format.",
						Pattern:>ListableP[_EmeraldTestSummary]
					}
				}
			},
			{
				Definition->{"ValidImportSampleManipulationQ[cloudFiles]","testSummary"},
				Description->"given 'cloudFiles' to an excel file(s) of the appropriate format, will return a corresponding list of Sample Manipulation 'primitives'.",
				Inputs:>{
					{
						InputName->"cloudFiles",
						Description->"EmeraldCloudFiles corresponding to an excel file(s) to be translated to Sample Manipulation primitives.",
						Widget->Widget[Type->Expression,Pattern:>ObjectP[Object[EmeraldCloudFile]],Size->Word]
					}
				},
				Outputs:>{
					{
						OutputName->"testSummary",
						Description->"Test summary determining whether the excel files corresponding to the given file paths have a valid format.",
						Pattern:>ListableP[_EmeraldTestSummary]
					}
				}
			},
			{
				Definition->{"ValidImportSampleManipulationQ[rawData]","testSummary"},
				Description->"given 'rawData' corresponding to an excel file(s) of the appropriate format, will return a corresponding list of Sample Manipulation 'primitives'.",
				Inputs:>{
					{
						InputName->"rawData",
						Description->"RawData corresponding to an excel file(s) to be translated to Sample Manipulation primitives.",
						Widget->Widget[Type->Expression,Pattern:>{{(_String|NumericP|BooleanP)..}..},Size->Paragraph]
					}
				},
				Outputs:>{
					{
						OutputName->"testSummary",
						Description->"Test summary determining whether the excel files corresponding to the given file paths have a valid format.",
						Pattern:>ListableP[_EmeraldTestSummary]
					}
				}
			},
			{
				Definition->{"ValidImportSampleManipulationQ[inputs]","testSummary"},
				Description->"given 'inputs' of the appropriate format, will return a corresponding list of Sample Manipulation 'primitives'.",
				Inputs:>{
					{
						InputName->"inputs",
						Description->"A list of paths on local computer,cloud files, or raw data corresponding to excel file(s) to be translated to Sample Manipulation primitives.",
						Widget->Widget[Type->Expression,Pattern:>{Alternatives[ObjectP[Object[EmeraldCloudFile]],FilePathP,{{(_String|NumericP|BooleanP)..}..}]..},Size->Paragraph]
					}
				},
				Outputs:>{
					{
						OutputName->"testSummary",
						Description->"Test summary determining whether the excel files corresponding to the given file paths have a valid format.",
						Pattern:>ListableP[_EmeraldTestSummary]
					}
				}
			}
		},
		MoreInformation->{
			"For more information on how to format valid files and examples see the help file of ImportSampleManipulation"
		},
		SeeAlso->{
			"ImportSampleManipulation",
			"ExperimentSampleManipulation",
			"ValidExperimentSampleManipulationQ",
			"OptimizePrimitives"
		},
		Author->{"ben", "olatunde.olademehin", "harrison.gronlund"}
	}
];

(* ::Subsubsection::Closed:: *)
(*Filter*)


DefineUsage[SolidPhaseExtraction,
	{
		BasicDefinitions -> {
			{"SolidPhaseExtraction[Sample]","primitive","generates an ExperimentSampleManipulation-compatible 'primitive' that describes solid phase extraction a sample through a specified extraction cartridge by applying a specified pressure for a specified amount of time."}
		},
		MoreInformation->{
		},
		Input:>{
			{
				"Sample",
				ListableP[(NonSelfContainedSampleP|NonSelfContainedSampleModelP|ObjectP[{Model[Container,Vessel],Model[Container,ReactionVessel],Model[Container,Cuvette],Object[Container,Vessel],Object[Container,ReactionVessel],Object[Container,Cuvette]}]|{ObjectP[{Model[Container,Plate],Object[Container,Plate]}],WellP})],
				"The sample/container to be extracted."
			}
		},
		Output:>{
			{"primitive",_Filter,"A sample manipulation primitive containing information for specification and execution of filtering a sample."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Transfer",
			"Aliquot",
			"Consolidation",
			"Mix",
			"Wait",
			"Define",
			"Incubate",
			"Pellet",
			"Centrifuge",
			"ExperimentStockSolution",
			"ExperimentIncubate",
			"ExperimentMeasureVolume",
			"ExperimentHPLC",
			"ExperimentMassSpectrometry"
		},
		Author->{"robert","waltraud.mair"}
	}
];