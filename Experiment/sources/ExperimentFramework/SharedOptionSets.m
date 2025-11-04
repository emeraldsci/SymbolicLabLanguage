(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Option Sets *)


(* ::Subsection::Closed:: *)
(*Sample Manipulation Widget*)


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
		}],
		OpenPaths -> {
			{
				Object[Catalog, "Root"],
				"Materials"
			},
			{
				Object[Catalog, "Root"],
				"Containers"
			}
		}
	],
	"Position" -> {
		"Container" -> Widget[
			Type -> Object,
			Pattern :> ObjectP[{Object[Container],Model[Container]}],
			OpenPaths -> {
				{
					Object[Catalog, "Root"],
					"Containers"
				}
			}
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
			PreparedContainer -> False,
			OpenPaths -> {
				{
					Object[Catalog, "Root"],
					"Labware",
					"Pipette Tips"
				}
			}
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
		Orientation -> Vertical

	],
	Optional[DynamicAspiration] -> Widget[
		Type->Enumeration,
		Pattern:>BooleanP,
		PatternTooltip -> "Indicates if droplet formation should be prevented during liquid transfer. This should only be used for solvents that have high vapor pressure."
	]
};


sampleManipulationWidget=Adder[Widget[
							Type->Primitive,
							Pattern:>SampleManipulationP,
							PrimitiveTypes->{Define,Transfer,Mix,Aliquot,Consolidation,FillToVolume,Incubate,Filter,Wait,Centrifuge, Resuspend},
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
											PreparedContainer -> False,
											OpenPaths -> {
												{
													Object[Catalog, "Root"],
													"Materials"
												}
											}
										],
										"Position" -> {
											"Container" -> Widget[
												Type -> Object,
												Pattern :> ObjectP[{Object[Container],Model[Container]}],
												PatternTooltip -> "The container in a {container, well} position tuple which is referenced by the Name in this Define primitive.",
												PreparedSample -> False,
												PreparedContainer -> False,
												OpenPaths -> {
													{
														Object[Catalog, "Root"],
														"Containers"
													}
												}
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
										PreparedContainer -> False,
										OpenPaths -> {
											{
												Object[Catalog, "Root"],
												"Containers"
											}
										}
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
										PreparedContainer -> False,
										OpenPaths -> {
											{
												Object[Catalog, "Root"],
												"Materials"
											}
										}
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
											PreparedContainer -> False,
											OpenPaths -> {
												{
													Object[Catalog, "Root"],
													"Storage Conditions"
												}
											}
										]
									],
									Optional[ExpirationDate] -> Widget[
										Type -> Date,
										Pattern :> _?DateObjectQ,
										TimeSelector -> True,
										PatternTooltip -> "If a new sample will be created in the defined position, this option specifies the expiration date of the created sample."
									],
									Optional[TransportTemperature] -> Widget[
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
											PreparedContainer -> False,
											OpenPaths -> {
												{
													Object[Catalog, "Root"],
													"Storage Conditions"
												}
											}
										]
									],
									Optional[DefaultTransportTemperature] -> Widget[
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
									],
									(* Key added for ExperimentAcousticLiquidHandling *)
									Optional[InWellSeparation]->Widget[
										Type->Enumeration,
										Pattern:>BooleanP,
										PatternTooltip->"Indicates how the droplets of different samples are transferred into the same destination well. If True, the droplets will be spatially separated such that they would not mix with each other until additional volume is added to the well."
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
										Widget[
											Type -> Object,
											Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
											OpenPaths -> {
												{
													Object[Catalog, "Root"],
													"Instruments",
													"Mixing Devices"
												}
											}
										],
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

									(* Key added for ExperimentAcousticLiquidHandling *)
									Optional[InWellSeparation]->Widget[
										Type->Enumeration,
										Pattern:>BooleanP,
										PatternTooltip->"Indicates how the droplets of different samples are transferred into the same destination well. If True, the droplets will be spatially separated such that they would not mix with each other until additional volume is added to the well."
									],

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

									(* Key added for ExperimentAcousticLiquidHandling *)
									Optional[InWellSeparation]->Widget[
										Type->Enumeration,
										Pattern:>BooleanP,
										PatternTooltip->"Indicates how the droplets of different samples are transferred into the same destination well. If True, the droplets will be spatially separated such that they would not mix with each other until additional volume is added to the well."
									],

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
												Widget[
													Type -> Object,
													Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
													OpenPaths -> {
														{
															Object[Catalog, "Root"],
															"Instruments",
															"Mixing Devices"
														}
													}
												],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
											]
										],
										Alternatives[
											Widget[
												Type -> Object,
												Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
												OpenPaths -> {
													{
														Object[Catalog, "Root"],
														"Instruments",
														"Mixing Devices"
													}
												}
											],
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
												Widget[
													Type -> Object,
													Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
													OpenPaths -> {
														{
															Object[Catalog, "Root"],
															"Instruments",
															"Mixing Devices"
														}
													}
												],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
											]
										],
										Alternatives[
											Widget[
												Type -> Object,
												Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
												OpenPaths -> {
													{
														Object[Catalog, "Root"],
														"Instruments",
														"Mixing Devices"
													}
												}
											],
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
											Pattern :> ObjectP[{Object[Container, Plate], Model[Container, Plate]}],
											OpenPaths -> {
												{
													Object[Catalog, "Root"],
													"Containers",
													"Plates"
												}
											}
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
											}],
											OpenPaths -> {
												{
													Object[Catalog, "Root"],
													"Containers",
													"Filters"
												},
												{
													Object[Catalog, "Root"],
													"Labware",
													"Filters"
												}
											}
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
									Optional[MembraneMaterial] -> Widget[
										Type -> Enumeration,
										Pattern :> Alternatives[
											Automatic,
											FilterMembraneMaterialP
										]
									],
									Optional[PoreSize] -> Widget[
										Type -> Enumeration,
										Pattern :> Alternatives[
											Automatic,
											FilterSizeP
										]
									],
									Optional[FiltrationType] -> Widget[
										Type -> Enumeration,
										Pattern :> Alternatives[
											Automatic,
											FiltrationTypeP
										]
									],
									Optional[Instrument] -> Alternatives[
										Widget[
											Type -> Object,
											Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
											OpenPaths -> {
												{
													Object[Catalog, "Root"],
													"Instruments",
													"Mixing Devices"
												}
											}
										],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null,Automatic]]
									],
									Optional[FilterHousing] -> Alternatives[
										"Object" -> Widget[
											Type -> Object,
											Pattern :> ObjectP[{
												Model[Instrument,FilterHousing],
												Object[Instrument,FilterHousing]
											}],
											OpenPaths -> {
												{
													Object[Catalog, "Root"],
													"Instruments",
													"Dead-End Filtering Devices"
												}
											}
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
											}],
											OpenPaths -> {
												{
													Object[Catalog, "Root"],
													"Containers",
													"Syringes"
												}
											}
										],
										"Automatic" -> Widget[
											Type -> Enumeration,
											Pattern :> Alternatives[Automatic,Null]
										]
									],
									Optional[Sterile] -> Widget[Type -> Enumeration,Pattern :> BooleanP],
									Optional[MolecularWeightCutoff] -> Widget[
										Type -> Enumeration,
										Pattern :> Alternatives[
											Automatic,
											FilterMolecularWeightCutoffP
										]
									],
									Optional[PrefilterMembraneMaterial] -> Widget[
										Type -> Enumeration,
										Pattern :> Alternatives[
											Automatic,
											FilterMembraneMaterialP
										]
									],
									Optional[PrefilterPoreSize] -> Widget[
										Type -> Enumeration,
										Pattern :> Alternatives[
											Automatic,
											FilterSizeP
										]
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
												Widget[
													Type -> Object,
													Pattern :> ObjectP[{Object[Instrument,Centrifuge],Model[Instrument,Centrifuge]}],
													OpenPaths -> {
														{
															Object[Catalog, "Root"],
															"Instruments",
															"Centrifugation",
															"Centrifuges"
														},
														{
															Object[Catalog, "Root"],
															"Instruments",
															"Centrifugation",
															"Microcentrifuges"
														},
														{
															Object[Catalog, "Root"],
															"Instruments",
															"Centrifugation",
															"Robotic Compatible Microcentrifuges"
														},
														{
															Object[Catalog, "Root"],
															"Instruments",
															"Centrifugation",
															"Ultracentrifuges"
														}
													}
												],
												Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
											]
										],
										Alternatives[
											Widget[
												Type -> Object,
												Pattern :> ObjectP[{Object[Instrument,Centrifuge],Model[Instrument,Centrifuge]}],
												OpenPaths -> {
													{
														Object[Catalog, "Root"],
														"Instruments",
														"Centrifugation",
														"Centrifuges"
													},
													{
														Object[Catalog, "Root"],
														"Instruments",
														"Centrifugation",
														"Microcentrifuges"
													},
													{
														Object[Catalog, "Root"],
														"Instruments",
														"Centrifugation",
														"Robotic Compatible Microcentrifuges"
													},
													{
														Object[Catalog, "Root"],
														"Instruments",
														"Centrifugation",
														"Ultracentrifuges"
													}
												}
											],
											Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
										]
									],
									Optional[Intensity] -> Alternatives[
										Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units->Alternatives[RPM]],
										Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units->Alternatives[GravitationalAcceleration]]
									]
								}
							}
						]];


(* ::Subsection::Closed:: *)
(*Protocol Options*)


(* ::Subsubsection::Closed:: *)
(*ProtocolTemplateOption*)


DefineOptionSet[ProtocolTemplateOption:>{
	{
		OptionName -> Template,
		Default -> Null,
		Description -> "A template protocol whose methodology should be reproduced in running this experiment. Option values will be inherited from the template protocol, but can be individually overridden by directly specifying values for those options to this Experiment function.",
		AllowNull -> True,
		Category -> "Organizational Information",
		Widget -> Alternatives[
			Widget[Type->Object,Pattern:>ObjectP[Object[Protocol]],ObjectTypes->{Object[Protocol]}],
			Widget[
				Type -> FieldReference,
				Pattern :>FieldReferenceP[Object[Protocol], {UnresolvedOptions, ResolvedOptions}],
				PatternTooltip -> "An object of type or subtype of Object[Protocol] with UnresolvedOptions, ResolvedOptions specified."
			]
		]
	}
}];


(* ::Subsubsection::Closed:: *)
(*AnalyticalNumberOfReplicatesOption*)


DefineOptionSet[AnalyticalNumberOfReplicatesOption:>{
	{
		OptionName->NumberOfReplicates,
		Default->Null,
		Description->"Number of times each of the input samples should be analyzed using identical experimental parameters.",
		AllowNull->True,
		Category->"General",
		Widget->Widget[Type->Number,Pattern:>GreaterEqualP[2,1]]
	}
}];


(* ::Subsubsection::Closed:: *)
(*SterileOption*)


DefineOptionSet[SterileOption:>{
	{
		OptionName -> Sterile,
		Default -> Automatic,
		Description -> "Indicates if the protocol should be performed in a sterile environment.",
		AllowNull -> False,
		Category -> "General",
		Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
	}
}];


(* ::Subsubsection::Closed:: *)
(*ParentProtocolOption*)


DefineOptionSet[ParentProtocolOption:>{
	{
		OptionName -> ParentProtocol,
		Default -> Null,
		Description -> "The protocol which is directly generating this experiment during execution.",
		AllowNull -> True,
		Category -> "Hidden",
		Widget -> Widget[Type->Object,Pattern:>ObjectP[ProtocolTypes[Output -> Short]],ObjectTypes->ProtocolTypes[Output -> Short]]
	}
}];


(* ::Subsubsection::Closed:: *)
(*SubprotocolDescriptionOption *)


DefineOptionSet[SubprotocolDescriptionOption:>{
	{
		OptionName -> SubprotocolDescription,
		Default -> Null,
		Description -> "The protocol which is directly generating this experiment during execution.",
		AllowNull -> True,
		Category -> "Hidden",
		Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
	}
}];



(* ::Subsubsection::Closed:: *)
(*OperatorOption*)


DefineOptionSet[
	OperatorOption:>{
		{
			OptionName->Operator,
			Default->Null,
			Description->"Specifies the operator or model of operator who may run this protocol. If Null, any operator may run this protocol.",
			AllowNull->True,
			Category->"Hidden",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[User,Emerald],Object[User,Emerald]}],
				ObjectTypes->{Model[User,Emerald],Object[User,Emerald]}
			]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*InterruptibleOption*)


DefineOptionSet[
	InterruptibleOption:>{
		{
			OptionName->Interruptible,
			Default->True,
			Description->"Indicates if this protocol can be temporarily put on hold while the operator of this protocol is assigned to another priority protocol.",
			AllowNull->True,
			Category->"Hidden",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*OptionsResolverOnlyOption*)


DefineOptionSet[
	OptionsResolverOnlyOption:>{
		{
			OptionName -> OptionsResolverOnly,
			Default -> False,
			Description -> "Indicates if only the options resolver should be run to the exclusion of the resource packets and simulation functions.  If Output -> Options and OptionsResolverOnly -> True, then the function returns immediately after the options resolver.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ConfirmOption*)


DefineOptionSet[ConfirmOption:>{
	{
		OptionName->Confirm,
		Default->False,
		Description->"Indicates if the protocols generated should be confirmed for execution immediately upon creation and skip the InCart status.",
		AllowNull->False,
		Category->"Hidden",
		Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
	}
}];


(* ::Subsubsection::Closed:: *)
(*ConfirmOptionDefaultTrue*)


DefineOptionSet[ConfirmOptionDefaultTrue:>{
	{
		OptionName->Confirm,
		Default->True,
		Description->"Indicates if the protocols generated should be confirmed for execution immediately upon creation and skip the InCart status.",
		AllowNull->False,
		Category->"Hidden",
		Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
	}
}];

(* ::Subsubsection::Closed:: *)
(*ConfirmOptionDefaultAutomatic*)


DefineOptionSet[ConfirmOptionDefaultAutomatic:>{
	{
		OptionName->Confirm,
		Default->Automatic,
		Description->"Indicates if the protocols generated should be confirmed for execution immediately upon creation and skip the InCart status.",
		ResolutionDescription->"Resolves to True if Upload->True and resolves to False if Upload->False.",
		AllowNull->False,
		Category->"Hidden",
		Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,BooleanP]]
	}
}];



(* ::Subsubsection::Closed:: *)
(*SimulateProcedureOption*)


DefineOptionSet[SimulateProcedureOption:>{
	{
		OptionName->SimulateProcedure,
		Default->False,
		Description->"Indicates if a simulated protocol object should be returned as the output Result instead of an InCart protocol.",
		AllowNull->False,
		Category->"Hidden",
		Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
	}
}];

(* ::Subsubsection::Closed:: *)
(*ExperimentOutputOption*)


DefineOptionSet[
	ExperimentOutputOption:>{
		{
			OptionName->Output,
			Default->Result,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Simulation, RunTime]],
				Adder[Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Simulation, RunTime]]]
			],
			Description->"Indicate what the function should return.",
			Category->"Hidden"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*SiteOption*)


DefineOptionSet[
	SiteOption:>{
		{
			OptionName->Site,
			Default->Automatic,
			AllowNull->False,
			Widget -> Widget[
				Type->Object,
				Pattern :> ObjectP[Object[Container,Site]]
			],
			Description -> "The site at which the protocol should be executed.",
			ResolutionDescription -> "Automatically resolves based on the instruments and samples needed to execute the protocol.",
			Category->"Hidden"
		}
	}
];

(*CanaryBranchOption*)
DefineOptionSet[
	CanaryBranchOption :> {
		{
			OptionName -> CanaryBranch,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> _?StringQ, Size -> Word],
			Description -> "Specifies the canary branch from which the protocol should be run, if any.",
			Category -> "Hidden"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ResolverOutputOption*)


DefineOptionSet[
	ResolverOutputOption:>{
		{
			Output -> Result,
			ListableP[Result|Tests],
			"Indicate what the helper function that does not need the Preview or Options output should return.",
			Category->Hidden
		}
	}
];

DefineOptionSet[
	RoboticParserOutputOption:>{
		{
			Output -> Result,
			ListableP[Result|Simulation],
			"Indicate what the robotic parser should return.",
			Category->Hidden
		}
	}
];

(* ::Subsubsection::Closed:: *)
(*DeckPlacementsOption*)


DefineOptionSet[
	DeckPlacementsOption:>{
		{
			DeckPlacements -> {},
			{{ObjectP[Object[Container],Object[Sample],Object[Item]], {LocationPositionP..}}..},
			"A list of deck placements used to set-up the robotic liquid handler deck, in the form {{ObjectToPlace, Placement Tree}..}."
		}
	}
];

(* ::Subsubsection::Closed:: *)
(*VesselRackPlacementsOption*)


DefineOptionSet[
	VesselRackPlacementsOption:>{
		{
			VesselRackPlacements -> {},
			{{ObjectP[Object[Container],Object[Sample],Object[Item]],ObjectP[Model[Container, Rack]],LocationPositionP}..},
			"List of placements of vials into automation-friendly vial racks, in the form {{Object To Place, Rack Model, Position in Rack}..}."
		}
	}
];

(* ::Subsubsection::Closed:: *)
(*PrimitiveOutputOption*)


DefineOptionSet[
	PrimitiveOutputOption :> {
		{
			OptionName -> Output,
			Default -> Options,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[Type -> Enumeration, Pattern :> Alternatives[Options, Tests, RunTime, Simulation, Resources, WorkCellIdlingConditions]],
				Adder[Widget[Type -> Enumeration, Pattern :> Alternatives[Options, Tests, RunTime, Simulation, Resources, WorkCellIdlingConditions]]]
			],
			Description -> "Indicate what the function should return.",
			Category -> "Hidden"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ProtocolOptions*)


DefineOptionSet[
	ProtocolOptions:>{
		CacheOption,
		FastTrackOption,
		ProtocolTemplateOption,
		ParentProtocolOption,
		OperatorOption,
		InterruptibleOption,
		OptionsResolverOnlyOption,
		ConfirmOption,
		NameOption,
		UploadOption,
		ExperimentOutputOption,
		EmailOption,
		HoldOrderOption,
		PriorityOption,
		StartDateOption,
		QueuePositionOption,
		SiteOption,
		CanaryBranchOption
	}
];


(* ::Subsection::Closed:: *)
(*Sample Prep Options *)


(* ::Subsubsection::Closed:: *)
(*IncubatePrepOptions*)


DefineOptionSet[
	IncubatePrepOptions:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Incubate,
				Default -> Automatic,
				Description -> "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment.",
				AllowNull -> False,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName -> Thaw,
				Default -> Automatic,
				Description -> "Indicates if any frozen SamplesIn should be incubated until visibly liquid prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName -> IncubationTemperature,
				Default -> Automatic,
				Description -> "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]],
					Widget[Type->Quantity,Pattern:>RangeP[$MinIncubationTemperature, 140 Celsius],Units->{Celsius,{Fahrenheit, Celsius}}]
				]
			},
			{
				OptionName -> IncubationTime,
				Default -> Automatic,
				Description -> "Duration for which SamplesIn should be incubated at the IncubationTemperature prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[1 Minute, $MaxExperimentTime],Units->{Hour,{Hour,Minute,Second}}]
			},
			{
				OptionName -> AnnealingTime,
				Default -> Automatic,
				Description -> "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute, $MaxExperimentTime],Units->{Hour,{Hour,Minute,Second}}]
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*IncubatePrepOptionsNew*)


DefineOptionSet[
	IncubatePrepOptionsNew:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Incubate,
				Default -> Automatic,
				Description -> "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified).",
				ResolutionDescription -> "Resolves to True if any of the corresponding Incubation options are set. Otherwise, resolves to False.",
				AllowNull -> False,
				Category -> "Preparatory Incubation",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName -> IncubationTemperature,
				Default -> Automatic,
				Description -> "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Incubation",
				Widget -> Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]],
					Widget[Type->Quantity,Pattern:>RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],Units->{Celsius,{Fahrenheit, Celsius}}]
				]
			},
			{
				OptionName -> IncubationTime,
				Default -> Automatic,
				Description -> "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Incubation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[1 Minute, $MaxExperimentTime],Units->{Hour,{Hour,Minute,Second}}]
			},
			{
				OptionName -> Mix,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this sample should be mixed while incubated, prior to starting the experiment.",
				ResolutionDescription -> "Automatically resolves to True if any Mix related options are set. Otherwise, resolves to False.",
				Category->"Preparatory Incubation"
			},
			{
				OptionName -> MixType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> MixTypeP],
				Description -> "Indicates the style of motion used to mix the sample, prior to starting the experiment.",
				ResolutionDescription -> "Automatically resolves based on the container of the sample and the Mix option.",
				Category->"Preparatory Incubation"
			},
			{
				OptionName -> MixUntilDissolved,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> (BooleanP)],
				Description -> "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute. Any mixing/incubation will occur prior to starting the experiment.",
				ResolutionDescription -> "Automatically resolves to True if MaxIncubationTime or MaxNumberOfMixes is set.",
				Category->"Preparatory Incubation"
			},
			{
				OptionName -> MaxIncubationTime,
				Default -> Automatic,
				Description -> "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. This occurs prior to starting the experiment.",
				ResolutionDescription -> "Automatically resolves based on MixType, MixUntilDissolved, and the container of the given sample.",
				AllowNull -> True,
				Category -> "Preparatory Incubation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[1 Minute, $MaxExperimentTime],Units->{Hour,{Hour,Minute,Second}}]
			},
			{
				OptionName -> IncubationInstrument,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type->Object,
					Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Mixing Devices"
						}
					}
				],
				Description -> "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment.",
				ResolutionDescription -> "Automatically resolves based on the options Mix, Temperature, MixType and container of the sample.",
				Category->"Preparatory Incubation"
			},
			{
				OptionName -> AnnealingTime,
				Default -> Automatic,
				Description -> "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Incubation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute, $MaxExperimentTime],Units->{Hour,{Hour,Minute,Second}}]
			},
			{
				OptionName -> IncubateAliquotContainer,
				Default -> Automatic,
				Description -> "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Incubation",
				Widget -> Alternatives[
					Widget[
						Type->Object,
						Pattern:>ObjectP[Model[Container]],
						ObjectTypes->{Model[Container]},
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					],
					{
						"Index" -> Alternatives[
							Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic, Null]
							]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Containers"
									}
								}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					}
				]
			},
			{
				OptionName -> IncubateAliquotDestinationWell,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size->Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Category -> "Preparatory Incubation",
				Description -> "The desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed.",
				ResolutionDescription -> "Automatically resolves to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells."
			},
			{
				OptionName -> IncubateAliquot,
				Default -> Automatic,
				Description -> "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation.",
				ResolutionDescription -> "Automatically set as the smaller between the current sample volume and the maximum volume of the destination container.",
				AllowNull -> True,
				Category -> "Preparatory Incubation",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				]
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*IncubatePrepOptionsNestedIndexMatching*)


DefineOptionSet[
	IncubatePrepOptionsNestedIndexMatching:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Incubate,
				Default -> Automatic,
				Description -> "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified).",
				ResolutionDescription -> "Resolves to True if any of the corresponding Incubation options are set. Otherwise, resolves to False.",
				AllowNull -> False,
				Category -> "Preparatory Incubation",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				NestedIndexMatching -> True
			},
			{
				OptionName -> IncubationTemperature,
				Default -> Automatic,
				Description -> "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Incubation",
				Widget -> Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]],
					Widget[Type->Quantity,Pattern:>RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],Units->{Celsius,{Fahrenheit, Celsius}}]
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> IncubationTime,
				Default -> Automatic,
				Description -> "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Incubation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[1 Minute, $MaxExperimentTime],Units->{Hour,{Hour,Minute,Second}}],
				NestedIndexMatching -> True
			},
			{
				OptionName -> Mix,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this sample should be mixed while incubated, prior to starting the experiment.",
				ResolutionDescription -> "Automatically resolves to True if any Mix related options are set. Otherwise, resolves to False.",
				Category->"Preparatory Incubation",
				NestedIndexMatching -> True
			},
			{
				OptionName -> MixType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> MixTypeP],
				Description -> "Indicates the style of motion used to mix the sample, prior to starting the experiment.",
				ResolutionDescription -> "Automatically resolves based on the container of the sample and the Mix option.",
				Category->"Preparatory Incubation",
				NestedIndexMatching -> True
			},
			{
				OptionName -> MixUntilDissolved,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> (BooleanP)],
				Description -> "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute. Any mixing/incubation will occur prior to starting the experiment.",
				ResolutionDescription -> "Automatically resolves to True if MaxIncubationTime or MaxNumberOfMixes is set.",
				Category->"Preparatory Incubation",
				NestedIndexMatching -> True
			},
			{
				OptionName -> MaxIncubationTime,
				Default -> Automatic,
				Description -> "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. This occurs prior to starting the experiment.",
				ResolutionDescription -> "Automatically resolves based on MixType, MixUntilDissolved, and the container of the given sample.",
				AllowNull -> True,
				Category -> "Preparatory Incubation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[1 Minute, $MaxExperimentTime],Units->{Hour,{Hour,Minute,Second}}],
				NestedIndexMatching -> True
			},
			{
				OptionName -> IncubationInstrument,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type->Object,
					Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Mixing Devices"
						}
					}
				],
				Description -> "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment.",
				ResolutionDescription -> "Automatically resolves based on the options Mix, Temperature, MixType and container of the sample.",
				Category->"Preparatory Incubation",
				NestedIndexMatching -> True
			},
			{
				OptionName -> AnnealingTime,
				Default -> Automatic,
				Description -> "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Incubation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute, $MaxExperimentTime],Units->{Hour,{Hour,Minute,Second}}],
				NestedIndexMatching -> True
			},
			{
				OptionName -> IncubateAliquotContainer,
				Default -> Automatic,
				Description -> "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Incubation",
				Widget -> Alternatives[
					Widget[
						Type->Object,
						Pattern:>ObjectP[Model[Container]],
						ObjectTypes->{Model[Container]},
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					],
					{
						"Index" -> Alternatives[
							Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic, Null]
							]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Containers"
									}
								}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					}
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> IncubateAliquotDestinationWell,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size->Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Category -> "Preparatory Incubation",
				Description -> "The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed.",
				ResolutionDescription -> "Automatically resolves to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells.",
				NestedIndexMatching -> True
			},
			{
				OptionName -> IncubateAliquot,
				Default -> Automatic,
				Description -> "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation.",
				ResolutionDescription -> "Automatically set as the smaller between the current sample volume and the maximum volume of the destination container.",
				AllowNull -> True,
				Category -> "Preparatory Incubation",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				NestedIndexMatching -> True
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*MixPrepOptions*)


(* DEPRECATED: DO NOT USE. *)

DefineOptionSet[
	MixPrepOptions:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Mix,
				Default -> Automatic,
				Description -> "Indicates if the SamplesIn should be mixed prior to starting the experiment or any aliquoting. If Incubate->True, then the same is both Mixed and Incubated at the same time.",
				AllowNull -> False,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName -> MixType,
				Default -> Automatic,
				Description -> "The style of motion used to mix the SamplesIn prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Enumeration,Pattern:>MixTypeP]
			},
			{
				OptionName -> MixRate,
				Default -> Automatic,
				Description -> "Frequency of rotation the mixing instrument should use to mix the SamplesIn prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[$MinMixRate, $MaxMixRate],Units->RPM]
			},
			{
				OptionName -> MixTime,
				Default -> Automatic,
				Description -> "Duration for which the SamplesIn should be mixed prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[1 Second,$MaxExperimentTime],Units->Alternatives[Second,Minute,Hour]]
			},
			{
				OptionName -> NumberOfMixes,
				Default -> Automatic,
				Description -> "Number of times the SamplesIn should be mixed via pipetting up and down or inversion of the container prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Number,Pattern:>RangeP[1, 50, 1]]
			},
			{
				OptionName -> MixVolume,
				Default -> Automatic,
				Description -> "The volume of the sample that should be pipetted up and down to mix by pipetting prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[1 Microliter, 5 Milliliter],Units:>Milliliter]
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*CentrifugePrepOptions*)


(* DEPRECATED: DO NOT USE. *)
DefineOptionSet[
	CentrifugePrepOptions:>{
		IndexMatching[IndexMatchingInput->"experiment samples",
			{
				OptionName -> Centrifuge,
				Default -> Automatic,
				Description -> "Indicates if the SamplesIn should be centrifuged prior to starting the experiment.",
				AllowNull -> False,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName -> CentrifugeRate,
				Default -> Automatic,
				Description -> "The rotational speed at which the SamplesIn should be centrifuged prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 RPM, 14800 RPM],Units->RPM]
			},
			{
				OptionName -> CentrifugeForce,
				Default -> Automatic,
				Description -> "The force with which the SamplesIn should be centrifuged prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 GravitationalAcceleration, 16162.5 GravitationalAcceleration],Units->GravitationalAcceleration]
			},
			{
				OptionName -> CentrifugeTime,
				Default -> Automatic,
				Description -> "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute, 99 Minute],Units->{Minute,{Minute,Second}}]
			},
			{
				OptionName -> CentrifugeTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the centrifuge chamber should be held while the SamplesIn are being centrifuged prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[-10 Celsius, 40 Celsius],Units->{Celsius,{Fahrenheit, Celsius}}]
			}
	]
	}
];


(* ::Subsubsection::Closed:: *)
(*CentrifugePrepOptionsNew*)


DefineOptionSet[
	CentrifugePrepOptionsNew:>{
		IndexMatching[IndexMatchingInput->"experiment samples",
			{
				OptionName -> Centrifuge,
				Default -> Automatic,
				Description -> "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified).",
				ResolutionDescription -> "Resolves to True if any of the corresponding Centrifuge options are set. Otherwise, resolves to False.",
				AllowNull -> False,
				Category -> "Preparatory Centrifugation",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName -> CentrifugeInstrument,
				Default->Automatic,
				AllowNull -> True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Centrifuges"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Microcentrifuges"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Robotic Compatible Microcentrifuges"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Ultracentrifuges"
						}
					}
				],
				Category -> "Preparatory Centrifugation",
				Description->"The centrifuge that will be used to spin the provided samples prior to starting the experiment."
			},
			{
				OptionName -> CentrifugeIntensity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units->Alternatives[RPM]],
					Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units->Alternatives[GravitationalAcceleration]]
				],
				Category -> "Preparatory Centrifugation",
				Description -> "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment."
			},
			{
				OptionName -> CentrifugeTime,
				Default -> Automatic,
				Description -> "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Centrifugation",
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Minute], Units->{Minute,{Minute,Second}}]
			},
			{
				OptionName -> CentrifugeTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Centrifugation",
				Widget -> Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Ambient]],
					Widget[Type->Quantity, Pattern:>RangeP[-10 Celsius,40Celsius], Units->{Celsius,{Fahrenheit, Celsius,Kelvin}}]
				]
			},
			{
				OptionName -> CentrifugeAliquotContainer,
				Default -> Automatic,
				Description -> "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Centrifugation",
				Widget -> Alternatives[
					Widget[
						Type->Object,
						Pattern:>ObjectP[Model[Container]],
						ObjectTypes->{Model[Container]},
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					],
					{
						"Index" -> Alternatives[
							Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic, Null]
							]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Containers"
									}
								}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					}
				]
			},
			{
				OptionName -> CentrifugeAliquotDestinationWell,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size->Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Category -> "Preparatory Centrifugation",
				Description -> "The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed.",
				ResolutionDescription -> "Automatically resolves to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells."
			},
			{
				OptionName -> CentrifugeAliquot,
				Default -> Automatic,
				Description -> "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation.",
				ResolutionDescription -> "Automatically set as the smaller between the current sample volume and the maximum volume of the destination container.",
				AllowNull -> True,
				Category -> "Preparatory Centrifugation",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				]
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*CentrifugePrepOptionsNestedIndexMatching*)


DefineOptionSet[
	CentrifugePrepOptionsNestedIndexMatching:>{
		IndexMatching[IndexMatchingInput->"experiment samples",
			{
				OptionName -> Centrifuge,
				Default -> Automatic,
				Description -> "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified).",
				ResolutionDescription -> "Resolves to True if any of the corresponding Centrifuge options are set. Otherwise, resolves to False.",
				AllowNull -> False,
				Category -> "Preparatory Centrifugation",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				NestedIndexMatching -> True
			},
			{
				OptionName -> CentrifugeInstrument,
				Default->Automatic,
				AllowNull -> True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Centrifuges"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Microcentrifuges"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Robotic Compatible Microcentrifuges"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Ultracentrifuges"
						}
					}
				],
				Category -> "Preparatory Centrifugation",
				Description->"The centrifuge that will be used to spin the provided samples prior to starting the experiment.",
				NestedIndexMatching -> True
			},
			{
				OptionName -> CentrifugeIntensity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units->Alternatives[RPM]],
					Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units->Alternatives[GravitationalAcceleration]]
				],
				Category -> "Preparatory Centrifugation",
				Description -> "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment.",
				NestedIndexMatching -> True
			},
			{
				OptionName -> CentrifugeTime,
				Default -> Automatic,
				Description -> "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Centrifugation",
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Minute], Units->{Minute,{Minute,Second}}],
				NestedIndexMatching -> True
			},
			{
				OptionName -> CentrifugeTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Centrifugation",
				Widget -> Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Ambient]],
					Widget[Type->Quantity, Pattern:>RangeP[-10 Celsius,40Celsius], Units->{Celsius,{Fahrenheit, Celsius,Kelvin}}]
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> CentrifugeAliquotDestinationWell,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size->Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Category -> "Preparatory Centrifugation",
				Description -> "The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed.",
				ResolutionDescription -> "Automatically resolves to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells.",
				NestedIndexMatching -> True
			},
			{
				OptionName -> CentrifugeAliquotContainer,
				Default -> Automatic,
				Description -> "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Centrifugation",
				Widget -> Alternatives[
					Widget[
						Type->Object,
						Pattern:>ObjectP[Model[Container]],
						ObjectTypes->{Model[Container]},
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					],
					{
						"Index" -> Alternatives[
							Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic, Null]
							]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Containers"
									}
								}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					}
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> CentrifugeAliquot,
				Default -> Automatic,
				Description -> "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation.",
				ResolutionDescription -> "Automatically set as the smaller between the current sample volume and the maximum volume of the destination container.",
				AllowNull -> True,
				Category -> "Preparatory Centrifugation",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				NestedIndexMatching -> True
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*FilterPrepOptions*)


(* DEPRECATED: DO NOT USE. *)
DefineOptionSet[
	FilterPrepOptions:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Filtration,
				Default -> Automatic,
				Description -> "Indicates if the SamplesIn should be filter prior to starting the experiment.",
				AllowNull -> False,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName -> FiltrationType,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>FiltrationTypeP],
				Category -> "Sample Preparation",
				Description->"The type of filtration method that should be used to perform the filtration.",
				ResolutionDescription->"Will automatically resolve to a filtration type appropriate for the volume of sample being filtered."
			},
			{
				OptionName -> Filter,
				Default -> Automatic,
				Description -> "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Container, Plate, Filter], Object[Container, Plate, Filter],
						Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
						Model[Item,Filter], Object[Item,Filter]
					}],
					ObjectTypes->{
						Model[Container, Plate, Filter], Object[Container, Plate, Filter],
						Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
						Model[Item,Filter], Object[Item,Filter]
					},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Filters"
						},
						{
							Object[Catalog, "Root"],
							"Labware",
							"Filters"
						}
					}
				]
			},
			{
				OptionName -> FilterMaterial,
				Default -> Automatic,
				Description -> "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Enumeration,Pattern:>FilterMembraneMaterialP]
			},
			{
				OptionName -> FilterPoreSize,
				Default -> Automatic,
				Description -> "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Enumeration,Pattern:>FilterSizeP]
			},
			{
				OptionName->FilterContainerOut,
				Default->Automatic,
				Description->"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the Volume of the sample. For plates, attempts to fill all wells of a single plate with the same model before using another one.",
				AllowNull->False,
				Category->"Sample Preparation",
				Widget->Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container], Object[Container]}],
						ObjectTypes -> {Model[Container], Object[Container]},
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					],
					{
						"Index" -> Alternatives[
							Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Containers"
									}
								}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					}
				]
			}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*FilterPrepOptionsNew*)


DefineOptionSet[
	FilterPrepOptionsNew:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Filtration,
				Default -> Automatic,
				Description -> "Indicates if the SamplesIn should be filter prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified).",
				ResolutionDescription -> "Resolves to True if any of the corresponding Filter options are set. Otherwise, resolves to False.",
				AllowNull -> False,
				Category -> "Preparatory Filtering",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName -> FiltrationType,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>FiltrationTypeP],
				Category -> "Preparatory Filtering",
				Description->"The type of filtration method that should be used to perform the filtration.",
				ResolutionDescription->"Will automatically resolve to a filtration type appropriate for the volume of sample being filtered."
			},
			{
				OptionName->FilterInstrument,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Instrument,FilterBlock],
						Object[Instrument,FilterBlock],
						Model[Instrument,PeristalticPump],
						Object[Instrument,PeristalticPump],
						Model[Instrument,VacuumPump],
						Object[Instrument,VacuumPump],
						Model[Instrument,Centrifuge],
						Object[Instrument,Centrifuge],
						Model[Instrument,SyringePump],
						Object[Instrument,SyringePump]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Dead-End Filtering Devices"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Pumps",
							"Vacuum Pumps"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Centrifuges"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Microcentrifuges"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Robotic Compatible Microcentrifuges"
						}
					}
				],
				Description->"The instrument that should be used to perform the filtration.",
				ResolutionDescription->"Will automatically resolved to an instrument appropriate for the filtration type.",
				Category->"Preparatory Filtering"
			},
			{
				OptionName -> Filter,
				Default -> Automatic,
				Description -> "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment.",
				ResolutionDescription->"Will automatically resolve to a filter appropriate for the filtration type and instrument.",
				AllowNull -> True,
				Category -> "Preparatory Filtering",
				Widget -> Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Container,Plate,Filter],
						Model[Container,Vessel,Filter],
						Model[Item,Filter]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Filters"
						},
						{
							Object[Catalog, "Root"],
							"Labware",
							"Filters"
						}
					}
				]
			},
			{
				OptionName -> FilterMaterial,
				Default -> Automatic,
				Description -> "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment.",
				ResolutionDescription -> "Resolves to an appropriate filter material for the given sample is Filtration is set to True.",
				AllowNull -> True,
				Category -> "Preparatory Filtering",
				Widget -> Widget[Type->Enumeration,Pattern:>FilterMembraneMaterialP]
			},
			{
				OptionName->PrefilterMaterial,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>FilterMembraneMaterialP],
				Description->"The material from which the prefilter filtration membrane should be made of to remove impurities from the SamplesIn prior to starting the experiment.",
				ResolutionDescription->"By default, no prefiltration is performed on samples, even when Filter->True.",
				Category->"Preparatory Filtering"
			},
			{
				OptionName -> FilterPoreSize,
				Default -> Automatic,
				Description -> "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment.",
				ResolutionDescription -> "Resolves to an appropriate filter pore size for the given sample is Filtration is set to True.",
				AllowNull -> True,
				Category -> "Preparatory Filtering",
				Widget -> Widget[Type->Enumeration,Pattern:>FilterSizeP]
			},
			{
				OptionName->PrefilterPoreSize,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>FilterSizeP],
				Description->"The pore size of the filter; all particles larger than this should be removed during the filtration.",
				ResolutionDescription->"By default, no prefiltration is performed on samples, even when Filter->True.",
				Category->"Preparatory Filtering"
			},
			(* Options for filtering by syringe *)
			{
				OptionName->FilterSyringe,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Container,Syringe],
						Object[Container,Syringe]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Syringes"
						}
					}
				],
				Description->"The syringe used to force that sample through a filter.",
				ResolutionDescription->"Resolves to an syringe appropriate to the volume of sample being filtered, if Filtration is set to True.",
				Category->"Preparatory Filtering"
			},
			{
				OptionName->FilterHousing,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Instrument, FilterHousing],
						Object[Instrument, FilterHousing],
						Model[Instrument, FilterBlock],
						Object[Instrument, FilterBlock]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Dead-End Filtering Devices"
						}
					}
				],
				Description->"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane.",
				ResolutionDescription->"Resolve to an housing capable of holding the size of the membrane being used, if filter with Membrane FilterType is being used and Filtration is set to True.",
				Category->"Preparatory Filtering"
			},
			(* Options for filtering by centrifuge *)
			{
				OptionName->FilterIntensity,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern :> GreaterP[0 RPM],Units->Alternatives[RPM]],
					Widget[Type->Quantity,Pattern :> GreaterP[0 GravitationalAcceleration],Units->Alternatives[GravitationalAcceleration]]
				],
				Category->"Preparatory Filtering",
				Description->"The rotational speed or force at which the samples will be centrifuged during filtration.",
				ResolutionDescription->"Will automatically resolve to 2000 GravitationalAcceleration if FiltrationType is Centrifuge and Filtration is True."
			},
			{
				OptionName->FilterTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern :> GreaterP[0 Minute],Units->{Hour,{Hour,Minute,Second}}],
				Category->"Preparatory Filtering",
				Description->"The amount of time for which the samples will be centrifuged during filtration.",
				ResolutionDescription->"Will automatically resolve to 5 Minute if FiltrationType is Centrifuge and Filtration is True."
			},
			{
				OptionName->FilterTemperature,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>GreaterEqualP[4 Celsius],Units->{Celsius,{Celsius,Fahrenheit,Kelvin}}]
				],
				Category->"Preparatory Filtering",
				Description->"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration.",
				ResolutionDescription->"Will automatically resolve to 22 Celsius if FiltrationType is Centrifuge and Filtration is True."
			},
			{
				OptionName->FilterContainerOut,
				Default->Automatic,
				Description->"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the Volume of the sample. For plates, attempts to fill all wells of a single plate with the same model before using another one.",
				AllowNull->True,
				Category->"Preparatory Filtering",
				Widget->Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container], Object[Container]}],
						ObjectTypes -> {Model[Container], Object[Container]},
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					],
					{
						"Index" -> Alternatives[
							Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Containers"
									}
								}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					}
				]
			},
			{
				OptionName -> FilterAliquotDestinationWell,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size->Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Category -> "Preparatory Filtering",
				Description -> "The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed.",
				ResolutionDescription -> "Automatically resolves to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells."
			},
			{
				OptionName -> FilterAliquotContainer,
				Default -> Automatic,
				Description -> "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Filtering",
				Widget -> Alternatives[
					Widget[
						Type->Object,
						Pattern:>ObjectP[Model[Container]],
						ObjectTypes->{Model[Container]},
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					],
					{
						"Index" -> Alternatives[
							Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic, Null]
							]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Containers"
									}
								}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					}
				]
			},
			{
				OptionName -> FilterAliquot,
				Default -> Automatic,
				Description -> "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration.",
				ResolutionDescription -> "Automatically set as the smaller between the current sample volume and the maximum volume of the destination container.",
				AllowNull -> True,
				Category -> "Preparatory Filtering",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				]
			},
			{
				OptionName->FilterSterile,
				Default->Automatic,
				Description->"Indicates if the filtration of the samples should be done in a sterile environment.",
				ResolutionDescription->"Resolve to False if Filtration is indicated. If sterile filtration is desired, this option must manually be set to True.",
				AllowNull->True,
				Category->"Preparatory Filtering",
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
			}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*FilterPrepOptionsNestedIndexMatching*)


DefineOptionSet[
	FilterPrepOptionsNestedIndexMatching:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Filtration,
				Default -> Automatic,
				Description -> "Indicates if the SamplesIn should be filter prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified).",
				ResolutionDescription -> "Resolves to True if any of the corresponding Filter options are set. Otherwise, resolves to False.",
				AllowNull -> False,
				Category -> "Preparatory Filtering",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				NestedIndexMatching -> True
			},
			{
				OptionName -> FiltrationType,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>FiltrationTypeP],
				Category -> "Preparatory Filtering",
				Description->"The type of filtration method that should be used to perform the filtration.",
				ResolutionDescription->"Will automatically resolve to a filtration type appropriate for the volume of sample being filtered.",
				NestedIndexMatching -> True
			},
			{
				OptionName->FilterInstrument,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Instrument,FilterBlock],
						Object[Instrument,FilterBlock],
						Model[Instrument,PeristalticPump],
						Object[Instrument,PeristalticPump],
						Model[Instrument,VacuumPump],
						Object[Instrument,VacuumPump],
						Model[Instrument,Centrifuge],
						Object[Instrument,Centrifuge],
						Model[Instrument,SyringePump],
						Object[Instrument,SyringePump]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Dead-End Filtering Devices"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Pumps",
							"Vacuum Pumps"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Centrifuges"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Microcentrifuges"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Robotic Compatible Microcentrifuges"
						}
					}
				],
				Description->"The instrument that should be used to perform the filtration.",
				ResolutionDescription->"Will automatically resolved to an instrument appropriate for the filtration type.",
				NestedIndexMatching -> True,
				Category->"Preparatory Filtering"
			},
			{
				OptionName -> Filter,
				Default -> Automatic,
				Description -> "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment.",
				ResolutionDescription->"Will automatically resolve to a filter appropriate for the filtration type and instrument.",
				AllowNull -> True,
				Category -> "Preparatory Filtering",
				Widget -> Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Container,Plate,Filter],
						Model[Container,Vessel,Filter],
						Model[Item,Filter]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Filters"
						},
						{
							Object[Catalog, "Root"],
							"Labware",
							"Filters"
						}
					}
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> FilterMaterial,
				Default -> Automatic,
				Description -> "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment.",
				ResolutionDescription -> "Resolves to an appropriate filter material for the given sample is Filtration is set to True.",
				AllowNull -> True,
				Category -> "Preparatory Filtering",
				Widget -> Widget[Type->Enumeration,Pattern:>FilterMembraneMaterialP],
				NestedIndexMatching -> True
			},
			{
				OptionName->PrefilterMaterial,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>FilterMembraneMaterialP],
				Description->"The material from which the prefilter filtration membrane should be made of to remove impurities from the SamplesIn prior to starting the experiment.",
				ResolutionDescription->"By default, no prefiltration is performed on samples, even when Filter->True.",
				NestedIndexMatching -> True,
				Category->"Preparatory Filtering"
			},
			{
				OptionName -> FilterPoreSize,
				Default -> Automatic,
				Description -> "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment.",
				ResolutionDescription -> "Resolves to an appropriate filter pore size for the given sample is Filtration is set to True.",
				AllowNull -> True,
				Category -> "Preparatory Filtering",
				Widget -> Widget[Type->Enumeration,Pattern:>FilterSizeP],
				NestedIndexMatching -> True
			},
			{
				OptionName->PrefilterPoreSize,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>FilterSizeP],
				Description->"The pore size of the filter; all particles larger than this should be removed during the filtration.",
				ResolutionDescription->"By default, no prefiltration is performed on samples, even when Filter->True.",
				NestedIndexMatching -> True,
				Category->"Preparatory Filtering"
			},
			(* Options for filtering by syringe *)
			{
				OptionName->FilterSyringe,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Container,Syringe],
						Object[Container,Syringe]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Syringes"
						}
					}
				],
				Description->"The syringe used to force that sample through a filter.",
				ResolutionDescription->"Resolves to an syringe appropriate to the volume of sample being filtered, if Filtration is set to True.",
				NestedIndexMatching -> True,
				Category->"Preparatory Filtering"
			},
			{
				OptionName->FilterHousing,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Instrument, FilterHousing],
						Object[Instrument, FilterHousing],
						Model[Instrument, FilterBlock],
						Object[Instrument, FilterBlock]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Dead-End Filtering Devices"
						}
					}
				],
				Description->"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane.",
				ResolutionDescription->"Resolve to an housing capable of holding the size of the membrane being used, if filter with Membrane FilterType is being used and Filtration is set to True.",
				NestedIndexMatching -> True,
				Category->"Preparatory Filtering"
			},
			(* Options for filtering by centrifuge *)
			{
				OptionName->FilterIntensity,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern :> GreaterP[0 RPM],Units->Alternatives[RPM]],
					Widget[Type->Quantity,Pattern :> GreaterP[0 GravitationalAcceleration],Units->Alternatives[GravitationalAcceleration]]
				],
				Category->"Preparatory Filtering",
				Description->"The rotational speed or force at which the samples will be centrifuged during filtration.",
				ResolutionDescription->"Will automatically resolve to 2000 GravitationalAcceleration if FiltrationType is Centrifuge and Filtration is True.",
				NestedIndexMatching -> True
			},
			{
				OptionName->FilterTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern :> GreaterP[0 Minute],Units->{Hour,{Hour,Minute,Second}}],
				Category->"Preparatory Filtering",
				Description->"The amount of time for which the samples will be centrifuged during filtration.",
				ResolutionDescription->"Will automatically resolve to 5 Minute if FiltrationType is Centrifuge and Filtration is True.",
				NestedIndexMatching -> True
			},
			{
				OptionName->FilterTemperature,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>GreaterEqualP[4 Celsius],Units->{Celsius,{Celsius,Fahrenheit,Kelvin}}]
				],
				Category->"Preparatory Filtering",
				Description->"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration.",
				ResolutionDescription->"Will automatically resolve to 22 Celsius if FiltrationType is Centrifuge and Filtration is True.",
				NestedIndexMatching -> True
			},
			{
				OptionName->FilterContainerOut,
				Default->Automatic,
				Description->"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the Volume of the sample. For plates, attempts to fill all wells of a single plate with the same model before using another one.",
				AllowNull->True,
				Category->"Preparatory Filtering",
				Widget->Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container], Object[Container]}],
						ObjectTypes -> {Model[Container], Object[Container]},
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					],
					{
						"Index" -> Alternatives[
							Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Containers"
									}
								}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					}
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> FilterAliquotDestinationWell,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size->Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Category -> "Preparatory Filtering",
				Description -> "The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed.",
				ResolutionDescription -> "Automatically resolves to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells.",
				NestedIndexMatching -> True
			},
			{
				OptionName -> FilterAliquotContainer,
				Default -> Automatic,
				Description -> "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment.",
				AllowNull -> True,
				Category -> "Preparatory Filtering",
				Widget -> Alternatives[
					Widget[
						Type->Object,
						Pattern:>ObjectP[Model[Container]],
						ObjectTypes->{Model[Container]},
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					],
					{
						"Index" -> Alternatives[
							Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic, Null]
							]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Containers"
									}
								}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					}
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> FilterAliquot,
				Default -> Automatic,
				Description -> "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration.",
				ResolutionDescription -> "Automatically set as the smaller between the current sample volume and the maximum volume of the destination container.",
				AllowNull -> True,
				Category -> "Preparatory Filtering",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				NestedIndexMatching -> True
			},
			{
				OptionName->FilterSterile,
				Default->Automatic,
				Description->"Indicates if the filtration of the samples should be done in a sterile environment.",
				ResolutionDescription->"Resolve to False if Filtration is indicated. If sterile filtration is desired, this option must manually be set to True.",
				AllowNull->True,
				Category->"Preparatory Filtering",
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				NestedIndexMatching -> True
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PreparatoryUnitOperationsOption*)

DefineOptionSet[
	PreparatoryUnitOperationsOption:>{
		{
			OptionName->PreparatoryUnitOperations,
			Default->Null,
			Description->"Specifies a sequence of transferring, aliquoting, consolidating, or mixing of new or existing samples before the main experiment. These prepared samples can be used in the main experiment by referencing their defined name. For more information, please reference the documentation for ExperimentSamplePreparation.",
			AllowNull->True,
			Category->"Sample Preparation",
			Widget->Adder[
				Alternatives[
					Widget[
						Type -> UnitOperationMethod,
						Pattern :> Alternatives[
							ManualSamplePreparationMethodP,
							RoboticSamplePreparationMethodP
						],
						ECL`Methods->{ManualSamplePreparation, RoboticSamplePreparation},
						Widget->Widget[Type -> UnitOperation, Pattern :> SamplePreparationP]
					],
					Widget[Type -> UnitOperation, Pattern :> SamplePreparationP]
				]
			]
		}
	}
];

(* ::Subsubsection::Closed:: *)
(*SamplePrepOptionsNestedIndexMatching*)


DefineOptionSet[
	SamplePrepOptionsNestedIndexMatching:>{
		PreparatoryUnitOperationsOption,
		IncubatePrepOptionsNestedIndexMatching,
		CentrifugePrepOptionsNestedIndexMatching,
		FilterPrepOptionsNestedIndexMatching
	}
];

(* This new version of the sample prep options has the sample preparation option. *)
DefineOptionSet[
	SamplePrepOptions:>{
		PreparatoryUnitOperationsOption,
		IncubatePrepOptionsNew,
		CentrifugePrepOptionsNew,
		FilterPrepOptionsNew
	}
];


(* ::Subsection::Closed:: *)
(*Aliquot Options*)


(* ::Subsubsection::Closed:: *)
(*AliquotOptions*)


DefineOptionSet[
	AliquotOptions:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Aliquot,
				Default -> Automatic,
				Description -> "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment. Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times. Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified).",
				AllowNull -> False,
				Category -> "Aliquoting",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			(* NOTE: This is only used in the primitive framework and is hidden in the standalone functions. *)
			{
				OptionName -> AliquotSampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples after they are aliquotted, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName -> AliquotAmount,
				Default -> Automatic,
				Description -> "The amount of a sample that should be transferred from the input samples into aliquots.",
				ResolutionDescription -> "Automatically set as the smaller between the current sample volume and the maximum volume of the destination container if a liquid, or the current Mass or Count if a solid or counted item, respectively.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Alternatives[
					"Volume"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					"Mass"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Milligram, 20 Kilogram],
						Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
					],
					"Count"->Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Unit, 1 Unit],
						Units -> {1, {Unit, {Unit}}}
					],
					"Count"->Widget[
						Type -> Number,
						Pattern :> GreaterP[0., 1.]
					],
					"All"->Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				]
			},
			{
				OptionName -> TargetConcentration,
				Default -> Automatic,
				Description -> "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment.",
				ResolutionDescription -> "Automatically calculated based on aliquot and buffer volumes.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Molar] | GreaterP[0 Gram / Liter],
					Units -> Alternatives[
						{1, {Micromolar, {Micromolar, Millimolar, Molar}}},
						CompoundUnit[
							{1, {Gram, {Gram, Microgram, Milligram}}},
							{-1, {Liter, {Liter, Microliter, Milliliter}}}
						]
					]
				]
			},
			{
				OptionName -> TargetConcentrationAnalyte,
				Default -> Automatic,
				Description -> "The substance whose final concentration is attained with the TargetConcentration option.",
				ResolutionDescription -> "Automatically set to the first value in the Analytes field of the input sample, or, if not populated, to the first analyte in the Composition field of the input sample, or if none exist, the first identity model of any kind in the Composition field.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[IdentityModelTypes],
					ObjectTypes -> IdentityModelTypes,
					PreparedSample -> False,
					PreparedContainer -> False
				]
			},
			{
				OptionName -> AssayVolume,
				Default -> Automatic,
				Description -> "The desired total volume of the aliquoted sample plus dilution buffer.",
				ResolutionDescription -> "Automatically determined based on Volume and TargetConcentration option values.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Microliter,20 Liter],
					Units->{Liter,{Microliter,Milliliter,Liter}}
				]
			},
			{
				OptionName -> ConcentratedBuffer,
				Default -> Automatic,
				Description -> "The concentrated buffer which should be diluted by the BufferDilutionFactor in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent). The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the AliquotAmount and the total AssayVolume.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Buffers"
						}
					}
				]
			},
			{
				OptionName -> BufferDilutionFactor,
				Default -> Automatic,
				Description -> "The dilution factor by which the concentrated buffer should be diluted in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent). The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the AliquotAmount and the total AssayVolume.",
				ResolutionDescription -> "If ConcentratedBuffer is specified, automatically set to the ConcentratedBufferDilutionFactor of that sample; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[Type->Number,Pattern:>GreaterEqualP[1]]
			},
			{
				OptionName -> BufferDiluent,
				Default -> Automatic,
				Description -> "The buffer used to dilute the aliquot sample such that ConcentratedBuffer is diluted by BufferDilutionFactor in the final solution. The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the AliquotAmount and the total AssayVolume.",
				ResolutionDescription -> "Automatically resolves to Model[Sample, \"Milli-Q water\"] if ConcentratedBuffer is specified; otherwise, resolves to Null.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type->Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Water"
						}
					}
				]
			},
			{
				OptionName -> AssayBuffer,
				Default -> Automatic,
				Description -> "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume.",
				ResolutionDescription -> "Automatically resolves to Model[Sample, \"Milli-Q water\"] if ConcentratedBuffer is not specified; otherwise, resolves to Null.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type->Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Water"
						}
					}
				]
			},
			{
				OptionName -> AliquotSampleStorageCondition,
				Default -> Automatic,
				Description -> "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
			}
		],
		{
			OptionName -> DestinationWell,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size->Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Adder[
					Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic,Null],
							PatternTooltip -> "Enumeration must be any well from A1 to H12."
						],
						Widget[
							Type -> String,
							Pattern :> WellPositionP,
							Size->Line,
							PatternTooltip -> "Enumeration must be any well from A1 to H12."
						]
					]
				]
			],
			Category -> "Aliquoting",
			Description -> "The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed.",
			ResolutionDescription -> "Automatically resolves to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells."
		},
		{
			OptionName -> AliquotContainer,
			Default -> Automatic,
			Description -> "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired.  This option will resolve to be the length of the SamplesIn * NumberOfReplicates.",
			ResolutionDescription -> "Automatically set as the PreferredContainer for the AssayVolume of the sample.  For plates, attempts to fill all wells of a single plate with the same model before aliquoting into the next.",
			AllowNull -> True,
			Category -> "Aliquoting",
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container], Object[Container]}],
					ObjectTypes -> {Model[Container], Object[Container]},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic, Null]
				],
				{
					"Index" -> Alternatives[
						Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					],
					"Container" -> Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container], Object[Container]}],
							ObjectTypes -> {Model[Container], Object[Container]},
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Containers"
								}
							}
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					]
				},
				Adder[
					Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container], Object[Container]}],
							ObjectTypes -> {Model[Container], Object[Container]},
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Containers"
								}
							}
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic,Null]
						]
					]
				],
				Adder[
					Alternatives[
						{
							"Index" -> Alternatives[
								Widget[
									Type -> Number,
									Pattern :> GreaterEqualP[1, 1]
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic, Null]
								]
							],
							"Container" -> Alternatives[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[{Model[Container], Object[Container]}],
									ObjectTypes -> {Model[Container], Object[Container]},
									OpenPaths -> {
										{
											Object[Catalog, "Root"],
											"Containers"
										}
									}
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic, Null]
								]
							]
						},
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					]
				]
			]
		},
		{
			OptionName -> AliquotPreparation,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type->Enumeration,Pattern:> PreparationMethodP],
			Description -> "Indicates the desired scale at which liquid handling used to generate aliquots will occur.",
			ResolutionDescription -> "Automatic resolution will occur based on manipulation volumes and container types.",
			Category -> "Aliquoting"
		},
		{
			OptionName -> ConsolidateAliquots,
			Default -> Automatic,
			Description -> "Indicates if identical aliquots should be prepared in the same container/position.",
			AllowNull -> True,
			Category -> "Aliquoting",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*AliquotOptionsPooled*)


DefineOptionSet[
	AliquotOptionsPooled:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Aliquot,
				Default -> Automatic,
				Description -> "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment. Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times. Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified).",
				AllowNull -> False,
				Category -> "Aliquoting",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			(* NOTE: This is only used in the primitive framework and is hidden in the standalone functions. *)
			{
				OptionName -> AliquotSampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples after they are aliquotted, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			(* Only AliquotAmount and TargetConcentration are index-matched to the individual samples. Everything else is matched to the pool. *)
			{
				OptionName -> AliquotAmount,
				Default -> Automatic,
				Description -> "The amount of a sample that should be transferred from the input samples into aliquots.",
				ResolutionDescription -> "Automatically set as the smaller between the current sample volume and the maximum volume of the destination container if a liquid, or the current Mass or Count if a solid or counted item, respectively.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Volume"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					"Mass"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Milligram, 20 Kilogram],
						Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
					],
					"Count"->Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Unit, 1 Unit],
						Units -> {1, {Unit, {Unit}}}
					],
					"Count"->Widget[
						Type -> Number,
						Pattern :> GreaterP[0., 1.]
					],
					"All"->Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				Category -> "Aliquoting",
				NestedIndexMatching -> True
			},
			{
				OptionName -> TargetConcentration,
				Default -> Automatic,
				Description -> "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment.",
				ResolutionDescription -> "Automatically calculated based on aliquot and buffer volumes.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Molar] | GreaterP[0 Gram / Liter],
					Units -> Alternatives[
						{1, {Micromolar, {Micromolar, Millimolar, Molar}}},
						CompoundUnit[
							{1, {Gram, {Gram, Microgram, Milligram}}},
							{-1, {Liter, {Liter, Microliter, Milliliter}}}
						]
					]
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> TargetConcentrationAnalyte,
				Default -> Automatic,
				Description -> "The substance whose final concentration is attained with the TargetConcentration option.",
				ResolutionDescription -> "Automatically set to the first value in the Analytes field of the input sample, or, if not populated, to the first analyte in the Composition field of the input sample, or if none exist, the first identity model of any kind in the Composition field.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[IdentityModelTypes],
					ObjectTypes -> IdentityModelTypes,
					PreparedSample -> False,
					PreparedContainer -> False
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> AssayVolume,
				Default -> Automatic,
				Description -> "The desired total volume of the aliquoted sample plus dilution buffer.",
				ResolutionDescription -> "Automatically determined based on Volume and TargetConcentration option values.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Microliter,20 Liter],
					Units->{Liter,{Microliter,Milliliter,Liter}}
				]
			},
			{
				OptionName -> ConcentratedBuffer,
				Default -> Automatic,
				Description -> "The concentrated buffer which should be diluted by the BufferDilutionFactor in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent). The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the AliquotAmount and the total AssayVolume.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Buffers"
						}
					}
				]
			},
			{
				OptionName -> BufferDilutionFactor,
				Default -> Automatic,
				Description -> "The dilution factor by which the concentrated buffer should be diluted in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent). The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the AliquotAmount and the total AssayVolume.",
				ResolutionDescription -> "If ConcentratedBuffer is specified, automatically set to the ConcentratedBufferDilutionFactor of that sample; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[Type->Number,Pattern:>GreaterEqualP[1]]
			},
			{
				OptionName -> BufferDiluent,
				Default -> Automatic,
				Description -> "The buffer used to dilute the aliquot sample such that ConcentratedBuffer is diluted by BufferDilutionFactor in the final solution. The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the AliquotAmount and the total AssayVolume.",
				ResolutionDescription -> "Automatically resolves to Model[Sample, \"Milli-Q water\"] if ConcentratedBuffer is specified; otherwise, resolves to Null.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type->Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Water"
						}
					}
				]
			},
			{
				OptionName -> AssayBuffer,
				Default -> Automatic,
				Description -> "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume.",
				ResolutionDescription -> "Automatically resolves to Model[Sample, \"Milli-Q water\"] if ConcentratedBuffer is not specified; otherwise, resolves to Null.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type->Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Water"
						}
					}
				]
			},
			{
				OptionName -> AliquotSampleStorageCondition,
				Default -> Automatic,
				Description -> "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
			}
		],
		{
			OptionName -> DestinationWell,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size->Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Adder[
					Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :>Alternatives[Automatic,Null],
							PatternTooltip -> "Enumeration must be any well from A1 to H12."
						],
						Widget[
							Type -> String,
							Pattern :> WellPositionP,
							Size->Line,
							PatternTooltip -> "Enumeration must be any well from A1 to H12."
						]
					]
				]
			],
			Category -> "Aliquoting",
			Description -> "The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed.",
			ResolutionDescription -> "Automatically resolves to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells."
		},
		{
			OptionName -> AliquotContainer,
			Default -> Automatic,
			Description -> "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired.  This option will resolve to be the length of the SamplesIn * NumberOfReplicates.",
			ResolutionDescription -> "Automatically set as the PreferredContainer for the AssayVolume of the sample.  For plates, attempts to fill all wells of a single plate with the same model before aliquoting into the next.",
			AllowNull -> True,
			Category -> "Aliquoting",
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container], Object[Container]}],
					ObjectTypes -> {Model[Container], Object[Container]},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic, Null]
				],
				{
					"Index" -> Alternatives[
						Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					],
					"Container" -> Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container], Object[Container]}],
							ObjectTypes -> {Model[Container], Object[Container]},
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Containers"
								}
							}
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					]
				},
				Adder[
					Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container], Object[Container]}],
							ObjectTypes -> {Model[Container], Object[Container]},
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Containers"
								}
							}
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic,Null]
						]
					]
				],
				Adder[
					Alternatives[
						{
							"Index" -> Alternatives[
								Widget[
									Type -> Number,
									Pattern :> GreaterEqualP[1, 1]
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic, Null]
								]
							],
							"Container" -> Alternatives[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[{Model[Container], Object[Container]}],
									ObjectTypes -> {Model[Container], Object[Container]},
									OpenPaths -> {
										{
											Object[Catalog, "Root"],
											"Containers"
										}
									}
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic, Null]
								]
							]
						},
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					]
				]
			]
		},
		{
			OptionName -> AliquotPreparation,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type->Enumeration,Pattern:>PreparationMethodP],
			Description -> "Indicates the desired scale at which liquid handling used to generate aliquots will occur.",
			ResolutionDescription -> "Automatic resolution will occur based on manipulation volumes and container types.",
			Category -> "Aliquoting"
		},
		{
			OptionName -> ConsolidateAliquots,
			Default -> Automatic,
			Description -> "Indicates if identical aliquots should be prepared in the same container/position.",
			AllowNull -> True,
			Category -> "Aliquoting",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*AliquotOptionsNestedIndexMatching*)


DefineOptionSet[
	AliquotOptionsNestedIndexMatching:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Aliquot,
				Default -> Automatic,
				Description -> "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment. Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times. Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified).",
				AllowNull -> False,
				Category -> "Aliquoting",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				NestedIndexMatching -> True
			},
			(* TODO figure out how to handle SampleVolumeRangeP - instead $MinVolume and $MixVolume *)
			{
				OptionName -> AliquotAmount,
				Default -> Automatic,
				Description -> "The amount of a sample that should be transferred from the input samples into aliquots.",
				ResolutionDescription -> "Automatically set as the smaller between the current sample volume and the maximum volume of the destination container if a liquid, or the current Mass or Count if a solid or counted item, respectively.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Alternatives[
					"Volume"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					"Mass"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Milligram, 20 Kilogram],
						Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
					],
					"Count"->Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Unit, 1 Unit],
						Units -> {1, {Unit, {Unit}}}
					],
					"Count"->Widget[
						Type -> Number,
						Pattern :> GreaterP[0., 1.]
					],
					"All"->Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> AliquotSampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples after they are aliquotted, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				NestedIndexMatching->True,
				UnitOperation->True
			},
			{
				OptionName -> TargetConcentration,
				Default -> Automatic,
				Description -> "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment.",
				ResolutionDescription -> "Automatically calculated based on aliquot and buffer volumes.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Molar] | GreaterP[0 Gram / Liter],
					Units -> Alternatives[
						{1, {Micromolar, {Micromolar, Millimolar, Molar}}},
						CompoundUnit[
							{1, {Gram, {Gram, Microgram, Milligram}}},
							{-1, {Liter, {Liter, Microliter, Milliliter}}}
						]
					]
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> TargetConcentrationAnalyte,
				Default -> Automatic,
				Description -> "The substance whose final concentration is attained with the TargetConcentration option.",
				ResolutionDescription -> "Automatically set to the first value in the Analytes field of the input sample, or, if not populated, to the first analyte in the Composition field of the input sample, or if none exist, the first identity model of any kind in the Composition field.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[IdentityModelTypes],
					ObjectTypes -> IdentityModelTypes,
					PreparedSample -> False,
					PreparedContainer -> False
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> AssayVolume,
				Default -> Automatic,
				Description -> "The desired total volume of the aliquoted sample plus dilution buffer.",
				ResolutionDescription -> "Automatically determined based on Volume and TargetConcentration option values.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Microliter,20 Liter],
					Units->{Liter,{Microliter,Milliliter,Liter}}
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> ConcentratedBuffer,
				Default -> Automatic,
				Description -> "The concentrated buffer which should be diluted by the BufferDilutionFactor in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent). The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the AliquotAmount and the total AssayVolume.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Buffers"
						}
					}
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> BufferDilutionFactor,
				Default -> Automatic,
				Description -> "The dilution factor by which the concentrated buffer should be diluted in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent). The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the AliquotAmount and the total AssayVolume.",
				ResolutionDescription -> "If ConcentratedBuffer is specified, automatically set to the ConcentratedBufferDilutionFactor of that sample; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[Type->Number,Pattern:>GreaterEqualP[1]],
				NestedIndexMatching -> True
			},
			{
				OptionName -> BufferDiluent,
				Default -> Automatic,
				Description -> "The buffer used to dilute the aliquot sample such that ConcentratedBuffer is diluted by BufferDilutionFactor in the final solution. The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the AliquotAmount and the total AssayVolume.",
				ResolutionDescription -> "Automatically resolves to Model[Sample, \"Milli-Q water\"] if ConcentratedBuffer is specified; otherwise, resolves to Null.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type->Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Water"
						}
					}
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> AssayBuffer,
				Default -> Automatic,
				Description -> "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume.",
				ResolutionDescription -> "Automatically resolves to Model[Sample, \"Milli-Q water\"] if ConcentratedBuffer is not specified; otherwise, resolves to Null.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[
					Type->Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Water"
						}
					}
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> AliquotSampleStorageCondition,
				Default -> Automatic,
				Description -> "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				NestedIndexMatching -> True
			}
		],
		{
			OptionName -> DestinationWell,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size->Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Adder[
					Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic,Null],
							PatternTooltip -> "Enumeration must be any well from A1 to H12."
						],
						Widget[
							Type -> String,
							Pattern :> WellPositionP,
							Size->Line,
							PatternTooltip -> "Enumeration must be any well from A1 to H12."
						]
					]
				]
			],
			NestedIndexMatching -> True,
			Category -> "Aliquoting",
			Description -> "The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed.",
			ResolutionDescription -> "Automatically resolves to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells."
		},
		{
			OptionName -> AliquotContainer,
			Default -> Automatic,
			Description -> "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired.  This option will resolve to be the length of the SamplesIn * NumberOfReplicates.",
			ResolutionDescription -> "Automatically set as the PreferredContainer for the AssayVolume of the sample.  For plates, attempts to fill all wells of a single plate with the same model before aliquoting into the next.",
			AllowNull -> True,
			Category -> "Aliquoting",
			NestedIndexMatching -> True,
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container], Object[Container]}],
					ObjectTypes -> {Model[Container], Object[Container]},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic, Null]
				],
				{
					"Index" -> Alternatives[
						Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					],
					"Container" -> Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container], Object[Container]}],
							ObjectTypes -> {Model[Container], Object[Container]},
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Containers"
								}
							}
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					]
				},
				Adder[
					Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container], Object[Container]}],
							ObjectTypes -> {Model[Container], Object[Container]},
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Containers"
								}
							}
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic,Null]
						]
					]
				],
				Adder[
					Alternatives[
						{
							"Index" -> Alternatives[
								Widget[
									Type -> Number,
									Pattern :> GreaterEqualP[1, 1]
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic, Null]
								]
							],
							"Container" -> Alternatives[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[{Model[Container], Object[Container]}],
									ObjectTypes -> {Model[Container], Object[Container]},
									OpenPaths -> {
										{
											Object[Catalog, "Root"],
											"Containers"
										}
									}
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic, Null]
								]
							]
						},
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					]
				]
			]
		},
		{
			OptionName -> AliquotPreparation,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type->Enumeration,Pattern:>PreparationMethodP],
			Description -> "Indicates the desired scale at which liquid handling used to generate aliquots will occur.",
			ResolutionDescription -> "Automatic resolution will occur based on manipulation volumes and container types.",
			Category -> "Aliquoting"
		},
		{
			OptionName -> ConsolidateAliquots,
			Default -> Automatic,
			Description -> "Indicates if identical aliquots should be prepared in the same container/position.",
			AllowNull -> True,
			Category -> "Aliquoting",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		}
	}
];


(* ::Subsection::Closed:: *)
(*Aliquot Prep Options*)


(* ::Subsubsection::Closed:: *)
(*AliquotIncubateOptions*)


DefineOptionSet[
	AliquotIncubateOptions:>{
		IndexMatching[
		    IndexMatchingInput->"experiment samples",
			{
				OptionName -> AliquotIncubate,
				Default -> Automatic,
				Description -> "Indicates if the AliquotSamples should be incubated at a fixed temperature prior to starting the experiment.",
				AllowNull -> True,
				Category -> "AliquotPrep",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName -> AliquotIncubationTemperature,
				Default -> Automatic,
				Description -> "Temperature at which the AliquotSamples should be incubated for the duration of the AliquotIncubationTime prior to starting the experiment.",
				AllowNull -> True,
				Category -> "AliquotPrep",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[$MinIncubationTemperature, 140 Celsius],Units->Alternatives[Fahrenheit,Celsius]]
			},
			{
				OptionName -> AliquotIncubationTime,
				Default -> Automatic,
				Description -> "Duration for which AliquotSamples should be incubated at the AliquotIncubationTemperature prior to starting the experiment.",
				AllowNull -> True,
				Category -> "AliquotPrep",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[1 Minute, $MaxExperimentTime],Units->Alternatives[Second,Minute,Hour]]
			},
			{
				OptionName -> AliquotAnnealingTime,
				Default -> Automatic,
				Description -> "Minimum duration for which the AliquotSamples should remain in the incubator allowing the system to settle to room temperature after the AliquotIncubationTime has passed but prior to starting the experiment.",
				AllowNull -> True,
				Category -> "AliquotPrep",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute, $MaxExperimentTime],Units->Alternatives[Second,Minute,Hour]]
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*AliquotMixOptions*)


DefineOptionSet[
	AliquotMixOptions:>{
	IndexMatching[
		IndexMatchingInput->"experiment samples",
		{
			OptionName -> AliquotMix,
			Default -> Automatic,
			Description -> "Indicates if the AliquotSamples should be mixed prior to starting the experiment.",
			AllowNull -> True,
			Category -> "AliquotPrep",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> AliquotMixType,
			Default -> Automatic,
			Description -> "The style of motion used to mix the AliquotSamples prior to starting the experiment.",
			AllowNull -> True,
			Category -> "AliquotPrep",
			Widget -> Widget[Type->Enumeration,Pattern:>MixTypeP]
		},
		{
			OptionName -> AliquotMixRate,
			Default -> Automatic,
			Description -> "Frequency of rotation the mixing instrument should use to mix the AliquotSamples prior to starting the experiment.",
			AllowNull -> True,
			Category -> "AliquotPrep",
			Widget -> Widget[Type->Quantity,Pattern:>RangeP[$MinMixRate, $MaxMixRate],Units->RPM]
		},
		{
			OptionName -> AliquotMixTime,
			Default -> Automatic,
			Description -> "Duration for which the AliquotSamples should be mixed prior to starting the experiment.",
			AllowNull -> True,
			Category -> "AliquotPrep",
			Widget -> Widget[Type->Quantity,Pattern:>RangeP[1 Second,$MaxExperimentTime],Units->Alternatives[Second,Minute,Hour]]
		},
		{
			OptionName -> AliquotNumberOfMixes,
			Default -> Automatic,
			Description -> "Number of times the AliquotSamples should be mixed via pipetting up and down or inversion of the container prior to starting the experiment.",
			AllowNull -> True,
			Category -> "AliquotPrep",
			Widget -> Widget[Type->Number,Pattern:>RangeP[1, 50, 1]]
		},
		{
			OptionName -> AliquotMixVolume,
			Default -> Automatic,
			Description -> "For each AliquotSample, the volume of the sample that should be pipetted up and down to mix by pipetting prior to starting the experiment.",
			AllowNull -> True,
			Category -> "AliquotPrep",
			Widget -> Widget[Type->Quantity,Pattern:>RangeP[1 Microliter, 5 Milliliter],Units->Milliliter]
		}
	]
	}
];


(* ::Subsubsection::Closed:: *)
(*AliquotCentrifugeOptions*)


DefineOptionSet[
	AliquotCentrifugeOptions:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> AliquotCentrifuge,
				Default -> Automatic,
				Description -> "Indicates if the AliquotSamples should be centrifuged prior to starting the experiment.",
				AllowNull -> True,
				Category -> "AliquotPrep",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName -> AliquotCentrifugeRate,
				Default -> Automatic,
				Description -> "The rotational speed at which the AliquotSamples should be centrifuged prior to starting the experiment.",
				AllowNull -> True,
				Category -> "AliquotPrep",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 RPM, 14800 RPM],Units->RPM]
			},
			{
				OptionName -> AliquotCentrifugeForce,
				Default -> Automatic,
				Description -> "The force with which the AliquotSamples should be centrifuged prior to starting the experiment.",
				AllowNull -> True,
				Category -> "AliquotPrep",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 GravitationalAcceleration, 16162.5 GravitationalAcceleration],Units->GravitationalAcceleration]
			},
			{
				OptionName -> AliquotCentrifugeTime,
				Default -> Automatic,
				Description -> "The amount of time for which the AliquotSamples should be centrifuged prior to starting the experiment.",
				AllowNull -> True,
				Category -> "AliquotPrep",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute, 99 Minute],Units->Alternatives[Second,Minute]]
			},
			{
				OptionName -> AliquotCentrifugeTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the centrifuge chamber should be held while the AliquotSamples are being centrifuged prior to starting the experiment.",
				AllowNull -> True,
				Category -> "AliquotPrep",
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[4 Celsius, 40 Celsius],Units->Alternatives[Celsius,Fahrenheit]]
			},
			{
				OptionName -> AliquotPreparation,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type->Enumeration,Pattern:>PreparationMethodP],
				Description -> "Indicates the desired scale at which liquid handling used to generate aliquots will occur.",
				ResolutionDescription -> "Automatic resolution will occur based on manipulation volumes and container types.",
				Category -> "Aliquoting"
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*AliquotFilterOptions*)


DefineOptionSet[
	AliquotFilterOptions:>{
		IndexMatching[
		    IndexMatchingInput->"experiment samples",
			{
				OptionName -> AliquotFiltration,
				Default -> Automatic,
				Description -> "Indicates if the AliquotSamples should be filter prior to starting the experiment.",
				AllowNull -> True,
				Category -> "AliquotPrep",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName -> AliquotFiltrationType,
				Default -> Automatic,
				Description -> "The manner in which force is provided to drive the liquid thought the filter when removing impurities from the AliquotSamples prior to starting the experiment.",
				AllowNull -> True,
				Category -> "AliquotPrep",
				Widget -> Widget[Type->Enumeration,Pattern:>FiltrationTypeP]
			},
			{
				OptionName -> AliquotFilter,
				Default -> Automatic,
				Description -> "The filter that should be used to remove impurities from the AliquotSamples prior to starting the experiment.",
				AllowNull -> True,
				Category -> "AliquotPrep",
				Widget -> Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Container, Plate, Filter], Object[Container, Plate, Filter],
						Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
						Model[Item,Filter], Object[Item,Filter]
					}],
					ObjectTypes->{
						Model[Container, Plate, Filter], Object[Container, Plate, Filter],
						Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
						Model[Item,Filter], Object[Item,Filter]
					},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Filters"
						},
						{
							Object[Catalog, "Root"],
							"Labware",
							"Filters"
						}
					}
				]
			},
			{
				OptionName -> AliquotFilterMaterial,
				Default -> Automatic,
				Description -> "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment.",
				AllowNull -> True,
				Category -> "AliquotPrep",
				Widget -> Widget[Type->Enumeration,Pattern:>FilterMembraneMaterialP]
			},
			{
				OptionName -> AliquotFilterPoreSize,
				Default -> Automatic,
				Description -> "The pore size of the filter that should be used when removing impurities from the AliquotSamples prior to starting the experiment.",
				AllowNull -> True,
				Category -> "AliquotPrep",
				Widget -> Widget[Type->Enumeration,Pattern:>FilterSizeP]
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*AliquotPrepOptions*)


DefineOptionSet[
	AliquotPrepOptions:>{
		AliquotIncubateOptions,
		AliquotMixOptions,
		AliquotCentrifugeOptions,
		AliquotFilterOptions
	}
];


(* ::Subsection::Closed:: *)
(*SamplesIn Storage Option*)


DefineOptionSet[
	SamplesInStorageOption:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> SamplesInStorageCondition,
				Default -> Null,
				Description -> "The non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed. If left unset, SamplesIn will be stored according to their current StorageCondition.",
				AllowNull -> True,
				Category -> "Post Experiment",
				(* Null indicates the storage conditions will be inherited from the model *)
				Widget -> Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
				]
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*SamplesInStorageOptions*)


DefineOptionSet[
	SamplesInStorageOptions:>{
		SamplesInStorageOption
	}
];


(* ::Subsubsection::Closed:: *)
(*PooledSamplesInStorageOption*)


DefineOptionSet[
	PooledSamplesInStorageOption:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> SamplesInStorageCondition,
				Default -> Null,
				Description -> "The non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed. If left unset, SamplesIn will be stored according to their current StorageCondition.",
				AllowNull -> True,
				Category -> "Post Experiment",
				(* Null indicates the storage conditions will be inherited from the model *)
				Widget -> Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
				],
				NestedIndexMatching -> True
			}
		]
	}
];


(* ::Subsection::Closed:: *)
(*SamplesOut Storage Options*)


(* ::Subsubsection::Closed:: *)
(*ContainerOutOption*)


DefineOptionSet[
	ContainerOutOption:>{
		{
			OptionName -> ContainerOut,
			Default -> Automatic,
			Description -> "The desired container generated samples should be produced in or transferred into by the end of the experiment.",
			AllowNull -> True,
			Category -> "Post Experiment",
			Widget -> Widget[
				Type->Object,
				Pattern:>ObjectP[Model[Container]],
				ObjectTypes->{Model[Container]},
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Containers"
					}
				}
			]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*SamplesOutStorageOption*)


DefineOptionSet[
	SamplesOutStorageOption:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> SamplesOutStorageCondition,
				Default -> Null,
				Description -> "The non-default conditions under which any new samples generated by this experiment should be stored after the protocol is completed. If left unset, the new samples will be stored according to their Models' DefaultStorageCondition.",
				AllowNull -> True,
				Category -> "Post Experiment",
				(* Null indicates the storage conditions will be inherited from the model *)
				Widget -> Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
				]
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*SamplesOutStorageOptions*)


DefineOptionSet[
	SamplesOutStorageOptions:>{
		SamplesOutStorageOption
	}
];


(* ::Subsubsection::Closed:: *)
(*PreparedResourcesOption*)

DefineOptionSet[
	PreparedResourcesOption:>{
		{
			OptionName->PreparedResources,
			Default->{},
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ListableP[ObjectP[Object[Resource,Sample]]],ObjectTypes->{Object[Resource,Sample]}],
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]]
			],
			Description->"Model resources in the ParentProtocol that are being transferred into an appropriate container model by this experiment call.",
			Category->"Hidden"
		}
	}
];

(* ::Subsubsection::Closed:: *)
(*OrderFulfilledOption*)

DefineOptionSet[
	OrderFulfilledOption :> {
		{
			OptionName -> OrderFulfilled,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Object[Transaction, Order]]]],
			Description -> "The inventory order that is requesting sample transfers.",
			Category -> "Hidden"
		}
	}
];

(* ::Subsection::Closed:: *)
(*Post Processing Options*)


(* ::Subsubsection::Closed:: *)
(*MeasureWeightOption*)


DefineOptionSet[
	MeasureWeightOption:>{
		{
			OptionName -> MeasureWeight,
			Default -> Automatic,
			Description -> "Indicates if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment. Please note that public samples are weighed regardless of the value of this option.",
			AllowNull -> True,
			Category -> "Post Experiment",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		}
	}
];



(* ::Subsubsection::Closed:: *)
(*MeasureVolumeOption*)


DefineOptionSet[
	MeasureVolumeOption:>{
		{
			OptionName -> MeasureVolume,
			Default -> Automatic,
			Description -> "Indicates if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment. Please note that public samples are volume measured regardless of the value of this option.",
			AllowNull -> True,
			Category -> "Post Experiment",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ImageSampleOption*)


DefineOptionSet[
	ImageSampleOption:>{
		{
			OptionName -> ImageSample,
			Default -> Automatic,
			Description -> "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment. Please note that public samples are imaged regardless of the value of this option.",
			AllowNull -> True,
			Category -> "Post Experiment",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		}
	}
];

DefineOptionSet[
	NonBiologyPostProcessingOptions:>{
		MeasureWeightOption,
		MeasureVolumeOption,
		ImageSampleOption
	}
];

DefineOptionSet[
	BiologyPostProcessingOptions:>{
		ModifyOptions[MeasureWeightOption,
			MeasureWeight,
			Default -> False
		],
		ModifyOptions[MeasureVolumeOption,
			MeasureVolume,
			Default -> False
		],
		ModifyOptions[ImageSampleOption,
			ImageSample,
			Default -> False
		]
	}
];

(* ::Subsection::Closed:: *)
(*Prep Experiment Options*)


(* ::Subsubsection::Closed:: *)
(*OverrideOptions*)


DefineOptionSet[
	OverrideOptions:>{
		IndexMatching[
		    IndexMatchingInput->"experiment samples",
			{
				OptionName -> ContainerModelOverride,
				Default -> Automatic,
				Description -> "The model container which the SamplesIn are expected to be residing within during this subprotocol after previous preparation subprotocols have finished, overriding the current database value for the sample's container model.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[Type->Object,Pattern:>ObjectP[{Model[Container]}],ObjectTypes->{Model[Container]}]
			},
			{
				OptionName -> AmountOverride,
				Default -> Automatic,
				Description -> "The amount of sample that is expected to be had during this subprotocol after previous preparation subprotocols have finished, overriding the current database value for the sample's amount.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Alternatives[
					Widget[Type->Quantity,Pattern:>GreaterP[1 Microliter],Units->Milliliter],
					Widget[Type->Quantity,Pattern:>GreaterP[1 Microgram],Units->Gram]
				]
			},
			{
				OptionName -> SampleIDOverride,
				Default -> Automatic,
				Description -> "Provides a unique ID for each unique sample created during aliquoting.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[Type->String,Pattern:>_String,Size->Word]
			},
			{
				OptionName -> ContainerIDOverride,
				Default -> Automatic,
				Description -> "Provides an ID representing the container the sample should be moved into during aliquoting.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[Type->String,Pattern:>_String,Size->Word]
			},
			{
				OptionName -> Override,
				Default -> False,
				Description -> "Indicates if options should be resolved for samples which don't yet exist by using the values supplied in the override options in lieu of downloading that information.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*TargetOptions*)


DefineOptionSet[
	TargetOptions :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> TargetContainerModel,
				Default -> Automatic,
				Description -> "The model of container in which the sample should reside following sample preparation in order to ensure that the sample will be in a container compatible with the instrument(s) used in the experiment.",
				AllowNull -> False,
				Category -> "Hidden",
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Container]}], ObjectTypes -> {Model[Container]}]
			},
			{
				OptionName -> TargetSampleGrouping,
				Default -> Automatic,
				Description -> "A container identifier that indicates which samples should reside in the same containers following sample preparation in order to ensure that the sample will be in a container compatible with the instrument(s) used in the experiment.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[Type->String,Pattern:>_String,Size->Word]
			}
		]
	}
];


(* ::Subsubsection:: *)
(*WeightStabilityDurationOption*)

DefineOptionSet[
	WeightStabilityDurationOption :> {
		{
			OptionName -> WeightStabilityDuration,
			Default -> Automatic,
			Description -> "The duration for which the balance reading needs to stay within a range defined by MaxWeightVariation before being considered stable and captured when measuring the weight of the samples of interest.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Second], Units :> Second]
		}
	}
];



(* ::Subsubsection:: *)
(*MaxWeightVariationOption*)


DefineOptionSet[
	MaxWeightVariationOption :> {
		{
			OptionName -> MaxWeightVariation,
			Default -> Automatic,
			Description -> "The max allowed amplitude the balance readings can fluctuate within for a duration defined by WeightStabilityDuration before being considered stable and captured when measuring the weight of the samples of interest.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Milligram], Units :> {1, {Milligram, {Microgram, Milligram, Gram}}}]
		}
	}
];

(* ::Subsubsection:: *)
(*TareWeightStabilityDurationOption*)

DefineOptionSet[
	TareWeightStabilityDurationOption :> {
		{
			OptionName -> TareWeightStabilityDuration,
			Default -> Automatic,
			Description -> "The duration for which the balance reading needs to stay within a range defined by MaxWeightVariation before being considered stable and captured when no sample is placed on the balance.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Second], Units :> Second]
		}
	}
];



(* ::Subsubsection:: *)
(*MaxTareWeightVariationOption*)


DefineOptionSet[
	MaxTareWeightVariationOption :> {
		{
			OptionName -> MaxTareWeightVariation,
			Default -> Automatic,
			Description -> "The max allowed amplitude the balance readings can fluctuate within for a duration defined by WeightStabilityDuration before being considered stable and captured when no sample is placed on the balance.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Milligram], Units :> {1, {Milligram, {Microgram, Milligram, Gram}}}]
		}
	}
];




(* ::Subsubsection::Closed:: *)
(*InSitu Option*)


DefineOptionSet[
	InSituOption :> {
		{
			OptionName -> InSitu,
			Default -> False,
			Description -> "Indicates if the protocol should run the experiment on the SamplesIn leaving them in their current location and state rather than moving them back and forth from storage or their previous location in a parent protocol.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
		}
	}
];

(* ::Subsubsection::Closed:: *)
(*KeepInstruments Option*)


DefineOptionSet[
	KeepInstrumentOption :> {
		{
			OptionName -> KeepInstruments,
			Default -> False,
			Description -> "Indicates if transfer instruments are released and moved back to the previous location after completing this protocol.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			]
		}
	}
];

(* ::Subsubsection::Closed:: *)
(*PreparationOption*)


DefineOptionSet[
	PreparationOption :> {
		{
			OptionName -> Preparation,
			Default -> Automatic,
			Description -> "Indicates if this unit operation is carried out primarily robotically or manually. Manual unit operations are executed by a laboratory operator and robotic unit operations are executed by a liquid handling work cell.",
			AllowNull -> False,
			Category -> "General",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>PreparationMethodP
			]
		}
	}
];

DefineOptionSet[
	RoboticPreparationOption :> {
		{
			OptionName -> Preparation,
			Default -> Robotic,
			Description -> "Indicates if this unit operation is carried out primarily robotically or manually. Manual unit operations are executed by a laboratory operator and robotic unit operations are executed by a liquid handling work cell.",
			AllowNull -> False,
			Category -> "General",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[Robotic]
			]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*WorkCellOption*)


DefineOptionSet[
	WorkCellOption :> {
		{
			OptionName -> WorkCell,
			(* NOTE: Not including qPix in this pattern because qPix isn't used by the regular UO primitives. *)
			Widget -> Widget[Type -> Enumeration,Pattern :> STAR | bioSTAR | microbioSTAR],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "The automated workstation with a collection of integrated instruments on which this unit operation will be will be performed if Preparation -> Robotic.",
			Category -> "General",
			ResolutionDescription -> "Automatically set to STAR if Preparation->Robotic."
		}
	}
];

(* ::Subsubsection::Closed:: *)
(*BiologyWorkCellOption*)


DefineOptionSet[
	BiologyWorkCellOption :> {
		{
			OptionName -> WorkCell,
			(* NOTE: Excluding STAR for biology experiments*)
			Widget -> Widget[Type -> Enumeration,Pattern :> bioSTAR | microbioSTAR],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Indicates the work cell that this primitive will be run on if Preparation->Robotic.",
			Category -> "General",
			ResolutionDescription -> "Automatically set to microbioSTAR when all samples' cell types are either Microbial or Null, otherwise set to bioSTAR when all samples' cell types are either Mammalian or Null, if Preparation->Robotic."
		}
	}
];
(* ::Subsection::Closed:: *)
(*Assay Plate Options*)


(* ::Subsubsection::Closed:: *)
(*MoatOptions*)


DefineOptionSet[MoatOptions :> {
	{
		OptionName->MoatSize,
		Default->Automatic,
		Description->"Indicates the number of concentric perimeters of wells which should be should be filled with MoatBuffer in order to decrease evaporation from the assay samples during the run.",
		AllowNull->True,
		Widget->Widget[Type->Number,Pattern:>GreaterP[0,1]],
		Category->"Sample Handling"
	},
	{
		OptionName->MoatVolume,
		Default->Automatic,
		Description->"Indicates the volume which should be added to each moat well.",
		ResolutionDescription->"Automatically set to the RecommendedFillVolume of the assay plate if informed, or 75% of the MaxVolume of the assay plate if not, if any other moat options are specified.",
		AllowNull->True,
		Widget->Widget[
			Type->Quantity,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter
		],
		Category->"Sample Handling"
	},
	{
		OptionName->MoatBuffer,
		Default->Automatic,
		Description->"Indicates the buffer which should be used to fill each moat well.",
		AllowNull->True,
		Widget->Widget[
			Type->Object,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			OpenPaths -> {
				{
					Object[Catalog, "Root"],
					"Materials",
					"Reagents",
					"Buffers"
				}
			}
		],
		Category->"Sample Handling"
	}
}];

(* ::Subsubsection:: *)
(* SampleLabelOptions *)
DefineOptionSet[SampleLabelOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName -> SampleLabel,
			Default -> Automatic,
			Description->"A user defined word or phrase used to identify the input samples, for use in downstream unit operations.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line
			],
			UnitOperation -> True
		},
		{
			OptionName -> SampleContainerLabel,
			Default -> Automatic,
			Description->"A user defined word or phrase used to identify the containers of the input samples, for use in downstream unit operations.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line
			],
			UnitOperation -> True
		}
	]
}];

(* ::Subsubsection::Closed:: *)
(*BlankLabelOptions*)


DefineOptionSet[BlankLabelOptions :> {
	IndexMatching[
		{
			OptionName->BlankLabel,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->String,Pattern:>_String,Size->Line],
			Description->"A user defined word or phrase used to identify the blank samples, for use in downstream unit operations.",
			Category->"General",
			UnitOperation->True
		},
		IndexMatchingInput->"experiment samples"
	]
}];



(* ::Subsection::Closed:: *)
(*Funtopia Shared Options*)


DefineOptionSet[
	NonBiologyFuntopiaSharedOptions:>{
		ProtocolOptions,
		SamplePrepOptions,
		AliquotOptions,
		NonBiologyPostProcessingOptions
	}
];

DefineOptionSet[
	BiologyFuntopiaSharedOptions:>{
		ProtocolOptions,
		SamplePrepOptions,
		AliquotOptions,
		BiologyPostProcessingOptions
	}
];


DefineOptionSet[
	NonBiologyFuntopiaSharedOptionsPooled:>{
		ProtocolOptions,
		SamplePrepOptionsNestedIndexMatching,
		AliquotOptionsPooled,
		NonBiologyPostProcessingOptions
	}
];

DefineOptionSet[
	BiologyFuntopiaSharedOptionsPooled:>{
		ProtocolOptions,
		SamplePrepOptionsNestedIndexMatching,
		AliquotOptionsPooled,
		BiologyPostProcessingOptions
	}
];

DefineOptionSet[
	NonBiologyFuntopiaSharedOptionsNestedIndexMatching:>{
		ProtocolOptions,
		SamplePrepOptionsNestedIndexMatching,
		AliquotOptionsNestedIndexMatching,
		ImageSampleOption
	}
];

DefineOptionSet[
	BiologyFuntopiaSharedOptionsNestedIndexMatching:>{
		ProtocolOptions,
		SamplePrepOptionsNestedIndexMatching,
		AliquotOptionsNestedIndexMatching,
		ModifyOptions[ImageSampleOption,
			ImageSample,
			Default -> False
		]
	}
];

(* ::Subsection::Closed:: *)
(*ModelInputOptions*)

DefineOptionSet[
	ModelInputOptions :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> PreparedModelContainer,
				Default -> Automatic,
				Description -> "Indicates the container in which a Model[Sample] specified as input to the experiment function will be prepared.",
				ResolutionDescription -> "If PreparedModelAmount is set to All and when the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise set to Model[Container, Vessel, \"2mL Tube\"].",
				AllowNull -> True,
				Category -> "Model Input",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Container]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				]
			},
			{
				OptionName -> PreparedModelAmount,
				Default -> Automatic,
				Description -> "Indicates the amount of a Model[Sample] specified as input to the experiment function that will be prepared in the PreparedModelContainer. When set to All and the input model sample is not preparable, the entire amount of the input model sample that comes from one of the Products is prepared. The selected product must have both Amount and DefaultContainerModel populated, and it must not be a KitProduct. When set to All and the input model is preparable such as water, 1 Milliliter of the input model sample is prepared.",
				ResolutionDescription -> "Automatically set to 1 Milliliter.",
				AllowNull -> True,
				Category -> "Model Input",
				Widget -> Alternatives[
					"Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					"Mass" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Milligram, 20 Kilogram],
						Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
					],
					"Count" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Unit, 1 Unit],
						Units -> {1, {Unit, {Unit}}}
					],
					"Count" -> Widget[
						Type -> Number,
						Pattern :> GreaterP[0., 1.]
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				]
			}
		]
	}
];



(* ::Subsection:: *)
(*Pipetting Parameters Option Set*)


DefineOptionSet[
	pipettingParameterOptions:>{
		{
			OptionName -> TipType,
			Default -> Automatic,
			Description -> "The tip to use to transfer liquid in the manipulation.",
			ResolutionDescription -> "Automatically resolves based on the amount being transferred or TipSize specification.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>TipTypeP],
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Item,Tips]]
				]
			]
		},
		{
			OptionName -> TipSize,
			Default -> Automatic,
			Description -> "The maximum volume of the tip used to transfer liquid in the manipulation.",
			ResolutionDescription -> "Automatically resolves based on the amount being transferred orr the TipType specified.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Microliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			]
		},
		{
			OptionName -> AspirationRate,
			Default -> Automatic,
			Description -> "The speed at which liquid should be drawn up into the pipette tip.",
			ResolutionDescription -> "Automatically resolves from DispenseRate if it is specified, otherwise resolves to 100 Microliter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.4 Microliter/Second,500 Microliter/Second],
				Units -> CompoundUnit[
					{1,{Milliliter,{Microliter,Milliliter,Liter}}},
					{-1,{Second,{Second,Minute}}}
				]
			]
		},
		{
			OptionName -> DispenseRate,
			Default -> Automatic,
			Description -> "The speed at which liquid should be expelled from the pipette tip.",
			ResolutionDescription -> "Automatically resolves from AspirationRate if it is specified, otherwise resolves to 100 Microliter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.4 Microliter/Second,500 Microliter/Second],
				Units -> CompoundUnit[
					{1,{Milliliter,{Microliter,Milliliter,Liter}}},
					{-1,{Second,{Second,Minute}}}
				]
			]
		},
		{
			OptionName -> OverAspirationVolume,
			Default -> Automatic,
			Description -> "The volume of air drawn into the pipette tip at the end of the aspiration of a liquid.",
			ResolutionDescription -> "Automatically resolves from OverDispenseVolume if it is specified, otherwise resolves to 5 Microliter.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter,50 Microliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			]
		},
		{
			OptionName -> OverDispenseVolume,
			Default -> Automatic,
			Description -> "The volume of air blown out at the end of the dispensing of a liquid.",
			ResolutionDescription -> "Automatically resolves to 5 Microliter.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter,300 Microliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			]
		},
		{
			OptionName -> AspirationWithdrawalRate,
			Default -> Automatic,
			Description -> "The speed at which the pipette is removed from the liquid after an aspiration.",
			ResolutionDescription -> "Automatically resolves from DispenseWithdrawalRate if it is specified, otherwise resolves to 2 Millimeter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.3 Millimeter/Second, 160 Millimeter/Second],
				Units -> CompoundUnit[
					{1,{Millimeter,{Millimeter,Micrometer}}},
					{-1,{Second,{Second,Minute}}}
				]
			]
		},
		{
			OptionName -> DispenseWithdrawalRate,
			Default -> Automatic,
			Description -> "The speed at which the pipette is removed from the liquid after a dispense.",
			ResolutionDescription -> "Automatically resolves from AspirationWithdrawalRate if it is specified, otherwise resolves to 2 Millimeter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.3 Millimeter/Second, 160 Millimeter/Second],
				Units -> CompoundUnit[
					{1,{Millimeter,{Millimeter,Micrometer}}},
					{-1,{Second,{Second,Minute}}}
				]
			]
		},
		{
			OptionName -> AspirationEquilibrationTime,
			Default -> Automatic,
			Description -> "The delay length the pipette waits after aspirating before it is removed from the liquid.",
			ResolutionDescription -> "Automatically resolves from DispenseEquilibrationTime if it is specified, otherwise resolves to 1 Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 9.9 Second],
				Units -> {Second,{Second,Minute}}
			]
		},
		{
			OptionName -> DispenseEquilibrationTime,
			Default -> Automatic,
			Description -> "The delay length the pipette waits after dispensing before it is removed from the liquid.",
			ResolutionDescription -> "Automatically resolves from AspirationEquilibrationTime if it is specified, otherwise resolves to 1 Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 9.9 Second],
				Units -> {Second,{Second,Minute}}
			]
		},
		{
			OptionName -> AspirationMix,
			Default -> Automatic,
			Description -> "Indicates if the source should be mixed before it is aspirated.",
			ResolutionDescription -> "Automatically resolves to True if other aspiration mix parameters are specified, otherwise False.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> DispenseMix,
			Default -> Automatic,
			Description -> "Indicates if the destination should be mixed after the source is dispensed.",
			ResolutionDescription -> "Automatically resolves to True if other dispense mix parameters are specified, otherwise False.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> AspirationMixVolume,
			Default -> Automatic,
			Description -> "The volume quickly aspirated and dispensed to mix the source sample before it is aspirated.",
			ResolutionDescription -> "Automatically resolves to half the volume of the source if AspirationMix is True.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter,970 Microliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			]
		},
		{
			OptionName -> DispenseMixVolume,
			Default -> Automatic,
			Description -> "The volume quickly aspirated and dispensed to mix the destination sample after the source is dispensed.",
			ResolutionDescription -> "Automatically resolves to half the volume of the destination if DispenseMix is True.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter,970 Microliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			]
		},
		{
			OptionName -> AspirationNumberOfMixes,
			Default -> Automatic,
			Description -> "The number of times the source is quickly aspirated and dispensed to mix the source sample before it is aspirated.",
			ResolutionDescription -> "Automatically resolves to three if AspirationMix is True.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[Type -> Number,Pattern :> GreaterEqualP[0]]
		},
		{
			OptionName -> DispenseNumberOfMixes,
			Default -> Automatic,
			Description -> "The number of times the destination is quickly aspirated and dispensed to mix the destination sample after the source is dispensed.",
			ResolutionDescription -> "Automatically resolves to three if DispenseMix is True.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[Type -> Number,Pattern :> GreaterEqualP[0]]
		},
		{
			OptionName -> AspirationMixRate,
			Default -> Automatic,
			Description -> "The speed at which liquid is aspirated and dispensed in a liquid before it is aspirated.",
			ResolutionDescription -> "Automatically resolves from DispenseMixRate or AspirationRate if either is specified, otherwise resolves to 100 Microliter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.4 Microliter/Second,500 Microliter/Second],
				Units -> CompoundUnit[
					{1,{Milliliter,{Microliter,Milliliter,Liter}}},
					{-1,{Second,{Second,Minute}}}
				]
			]
		},
		{
			OptionName -> DispenseMixRate,
			Default -> Automatic,
			Description -> "The speed at which liquid is aspirated and dispensed in a liquid after a dispense.",
			ResolutionDescription -> "Automatically resolves from AspirationMixRate or DispenseRate if either is specified, otherwise resolves to 100 Microliter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.4 Microliter/Second,500 Microliter/Second],
				Units -> CompoundUnit[
					{1,{Milliliter,{Microliter,Milliliter,Liter}}},
					{-1,{Second,{Second,Minute}}}
				]
			]
		},
		{
			OptionName -> AspirationPosition,
			Default -> Automatic,
			Description -> "The location from which liquid should be aspirated. Top will aspirate AspirationPositionOffset below the Top of the container, Bottom will aspirate AspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate AspirationPositionOffset below the liquid level of the sample in the container, and TouchOff will touch the bottom of the container before moving the specified AspirationPositionOffset above the bottom of the container to start aspirate the sample.",
			ResolutionDescription -> "Automatically set to the AspirationPosition in the PipettingMethod if it is specified and Preparation->Robotic, otherwise resolves to LiquidLevel if Preparation->Robotic.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PipettingPositionP
			]
		},
		{
			OptionName -> DispensePosition,
			Default -> Automatic,
			Description -> "The location from which liquid should be dispensed. Top will dispense DispensePositionOffset below the Top of the container, Bottom will dispense DispensePositionOffset above the Bottom of the container, LiquidLevel will dispense DispensePositionOffset below the liquid level of the sample in the container, and TouchOff will touch the bottom of the container before moving the specified DispensePositionOffset above the bottom of the container to start dispensing the sample.",
			ResolutionDescription -> "Automatically set to the DispensePosition in the PipettingMethod if it is specified and Preparation->Robotic, otherwise resolves to LiquidLevel if Preparation->Robotic.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PipettingPositionP
			]
		},
		{
			OptionName -> AspirationPositionOffset,
			Default -> Automatic,
			Description -> "The distance from the top or bottom of the container, depending on AspirationPosition, from which liquid should be aspirated.",
			ResolutionDescription -> "Automatically resolves from DispensePositionOffset if it is specified, or if AspirationPosition is not Null resolves to 2 Millimeter, otherwise resolves to Null and is determined at runtime by inspecting a sample's container type.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Millimeter],
				Units -> {Millimeter,{Millimeter}}
			]
		},
		{
			OptionName -> DispensePositionOffset,
			Default -> Automatic,
			Description -> "The distance from the top or bottom of the container, depending on DispensePosition, from which liquid should be dispensed.",
			ResolutionDescription -> "Automatically resolves from AspirationPositionOffset if it is specified, or if DispensePosition is not Null resolves to 2 Millimeter, otherwise resolves to Null and is determined at runtime by inspecting a sample's container type.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Millimeter],
				Units -> {Millimeter,{Millimeter}}
			]
		},
		{
			OptionName -> CorrectionCurve,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume.",
			ResolutionDescription -> "Automatically resolves from PipettingMethod if it is specified, or the default correction curve empirically determined for water.",
			Category -> "Pipetting",
			Widget -> Adder[
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
				Orientation -> Vertical
			]
		},
		{
			OptionName -> DynamicAspiration,
			Default -> Automatic,
			Description -> "Indicates if droplet formation should be prevented during liquid transfer. This should only be used for solvents that have high vapor pressure.",
			ResolutionDescription -> "Automatically resolves to False if unspecified.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		}
	}
];

