(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* Option Definitions *)

DefineOptions[ExperimentMeasureMeltingPoint,
	Options :> {

		(*General Options*)
		{
			OptionName -> MeasurementMethod,
			Default -> Pharmacopeia,
			Description -> "Determines the method to adjust the instrument's temperature sensor. When set to Pharmacopeia or Thermodynamic, the temperature sensor is calibrated using the corresponding standard. The Pharmacopeia method ignores that the furnace temperature exceeds the sample temperature during heating, making the measured melting temperature dependent on the ramp rate.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Pharmacopeia, Thermodynamic]
			]
		},

		IndexMatching[
			IndexMatchingInput -> "experiment samples",

			{
				OptionName -> OrderOfOperations,
				Default -> Automatic,
				Description -> "Determines the order of grinding and desiccation steps. {Desiccate, Grind} indicates that, first, the sample is dried via a desiccator, then it is ground into a fine powder via a grinder, then loaded into a capillary tube.",
				ResolutionDescription -> "Automatically set to {Desiccate, Grind} if both Desiccate and Grind are set to True.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Adder[Widget[Type -> Enumeration, Pattern :> Alternatives[Desiccate , Grind]]]
			},
			{
				OptionName -> ExpectedMeltingPoint,
				Default -> Automatic,
				ResolutionDescription -> "Automatically set to the sample's dominant composition model's MeltingPoint.",
				Description -> "If the approximate melting point is provided, the StartTemperature and EndTemperature will be automatically set to 5 Celsius below and above the ExpectedMeltingPoint and TemperatureRampRate will be set to 1 Celsius/Minute, otherwise, StartTemperature and EndTemperature will be set to 40 Celsius and 300 Celsius and TemperatureRampRate will be set to 10 Celsius/Minute.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Unknown]
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[25 Celsius, 400 Celsius, 0.1 Celsius],
						Units -> Alternatives[Celsius, Kelvin, Fahrenheit]
					]
				]
			},
			{
				OptionName -> NumberOfReplicates,
				Default -> Automatic,
				Description -> "Determines the number of melting point capillaries to be packed with the same sample and read. If the sample is prepacked in a melting point capillary tube, NumberOfReplicates must be set to Null. Null indicates that 1 capillary tube is to be packed by the sample.",
				ResolutionDescription -> "Automatically set to 3 if the sample is not prepacked in a melting point capillary tube.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[2, 6, 1]
				]
			},
			{
				OptionName -> Amount,
				Default -> Automatic,
				Description -> "Determines the sample quantity for desiccation and/or grinding. If either Desiccate or Grind is True, it specifies the amount of sample to be desiccated and/or ground before packing into a melting point capillary. If both are False, the amount is ignored. If set to Null, the sample is packed directly from its container without grinding or desiccation.",
				ResolutionDescription -> "Automatically set to 1 Gram or All whichever is less if Desiccate or Grind is True.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Alternatives[
					"Mass" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Milligram, $MaxTransferMass],
						Units -> {1, {Gram, {Gram, Milligram}}}
					],
					"All" -> Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
				]
			},
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the input samples, for use in downstream unit operations. Null indicates the sample is not transferred to another container and is desiccated in its primary container.",
				AllowNull -> True,
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
				Description -> "A user defined word or phrase used to identify the container that the samples are desiccated in, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> PreparedSampleLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the sample collected at the end of the desiccation step, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			(*Grinding*)
			{
				OptionName -> Grind,
				Default -> Automatic,
				Description -> "Determines if the sample is ground to a fine powder (to reduce the size of powder particles) via a lab mill (grinder) before measuring the melting point. Smaller powder particles enhance heat transfer and reproducibility of the measurements.",
				ResolutionDescription -> "Automatically set to False if the sample is prepacked in a melting point capillary tube or Amount is set Null. Otherwise set to True.",
				AllowNull -> False,
				Category -> "Grinding",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> GrinderType,
				Default -> Automatic,
				Description -> "Type of grinder that is used for reducing the size of the powder particles (grinding the sample into a fine powder) before packing the sample into a melting point capillary and measuring the melting temperature. Options include BallMill, KnifeMill, and automated MortarGrinder. BallMill consists of a rotating or vibrating grinding container with sample and hard balls inside in which the size reduction occurs through impact/friction of hard balls on/with the solid particles. KnifeMill consists of rotating sharp blades in which size reduction occurs through cutting of the solid particles into smaller pieces. Automated MortarGrinder consists of a rotating bowl (mortar) with the sample inside and an angled revolving column (pestle) in which size reduction occurs through pressure and friction between mortar, pestle, and sample particles.",
				ResolutionDescription -> "Automatically set to the type of the grinder that is determined by PreferredGrinder function if Grind is set to True.",
				AllowNull -> True,
				Category -> "Grinding",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> GrinderTypeP
				]
			},
			{
				OptionName -> Grinder,
				Default -> Automatic,
				Description -> "The instrument that is used to grind the sample into a fine powder if Grind is True.",
				ResolutionDescription -> "Automatically determined by PreferredGrinder function.",
				AllowNull -> True,
				Category -> "Grinding",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Instrument, Grinder], Object[Instrument, Grinder]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Grinders"
						}
					}
				]
			},
			{
				OptionName -> Fineness,
				Default -> Automatic,
				Description -> "The approximate size of the largest particle in a solid sample. Fineness, Amount, and BulkDensity are used to determine a suitable Grinder using PreferredGrinder function if Grind is set to True and Grinder is not specified.",
				ResolutionDescription -> "Automatically set to 1 Millimeter if Grind is set to True.",
				AllowNull -> True,
				Category -> "Grinding",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Micrometer, 80 Millimeter, 1 Micrometer],
					Units -> {1, {Millimeter, {Millimeter, Micrometer}}}
				]
			},
			{
				OptionName -> BulkDensity,
				Default -> Automatic,
				Description -> "The mass of a volume unit of the powder. The volume for calculating BulkDensity includes the volumes of particles, internal pores, and inter-particle void spaces. This parameter is used to calculate the volume of a powder from its mass (Amount). The volume, in turn, is used along with the fineness in PreferredGrinder to determine a suitable Grinder if Grind is set to True and Grinder is not specified.",
				ResolutionDescription -> "Automatically set to 1 g/mL if Grind is set to True .",
				AllowNull -> True,
				Category -> "Grinding",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[
						1 Milligram/Milliliter,
						25 Gram/Milliliter,
						1 Milligram/Milliliter
					],
					Units -> CompoundUnit[
						{1, {Gram, {Milligram, Gram, Kilogram}}},
						{-1, {Milliliter, {Microliter, Milliliter, Liter}}}
					]
				]
			},
			{
				OptionName -> GrindingContainer,
				Default -> Automatic,
				Description ->
					"The container that the sample is transferred into for the grinding process if Grind is set to True. Refer to instrumentation table in help files for more information about the containers that are used for each model of grinders.",
				ResolutionDescription -> "Automatically set to a suitable container based on the selected grinder Instrument and Amount of the sample.",
				AllowNull -> True,
				Category -> "Grinding",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Container, Vessel],
						Object[Container, Vessel],
						Model[Container, GrindingContainer],
						Object[Container, GrindingContainer]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Tubes & Vials"
						},
						{
							Object[Catalog, "Root"],
							"Containers",
							"Grinding Containers"
						}
					}
				]
			},
			{
				OptionName -> GrindingBead,
				Default -> Automatic,
				Description -> "In ball mills, grinding beads or grinding balls are used along with the sample inside the grinding container to beat and crush the sample into fine particles as a result rapid mechanical movements of the grinding container.",
				ResolutionDescription -> "Automatically set 2.8 mm stainless steel if Grind is set to True and GrinderType is set to BallMill.",
				AllowNull -> True,
				Category -> "Grinding",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Item, GrindingBead], Object[Item, GrindingBead]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Grinding",
							"Grinding Beads"
						}
					}
				]
			},
			{
				OptionName -> NumberOfGrindingBeads,
				Default -> Automatic,
				Description -> "In ball mills, determines how many grinding beads or grinding balls are used along with the sample inside the grinding container to beat and crush the sample into fine particles.",
				ResolutionDescription -> "Automatically set to a number of grinding beads that roughly have the same volume as the sample if Grind is set to True and GrinderType is set to BallMill. The number is estimated based on the estimated volume of the sample and diameter of the selected GrindingBead, considering 50% of packing void volume. When calculated automatically, NumberOfGrindingBeads will not be less than 1 or greater than 20.",
				AllowNull -> True,
				Category -> "Grinding",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 20, 1]
				]
			},
			{
				OptionName -> GrindingRate,
				Default -> Automatic,
				Description -> "Indicates the speed of the circular motion exerted by grinders to pulverize the samples into smaller powder particles.",
				ResolutionDescription -> "Automatically set to the default RPM for the selected Grinder according to the values in Table x.x, if Grind is set to True.",
				AllowNull -> True,
				Category -> "Grinding",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 RPM, 25000 RPM],
						Units -> RPM
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.01 Hertz, 420 Hertz],
						Units -> Hertz
					]
				]
			},
			{
				OptionName -> GrindingTime,
				Default -> Automatic,
				Description -> "Determines the duration for which the solid substance is ground into a fine powder in the grinder.",
				ResolutionDescription -> "Automatically set to a default value based on the selected Grinder according to table x.x if Grind is set to True.",
				AllowNull -> True,
				Category -> "Grinding",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Second, $MaxExperimentTime, 1 Second],
					Units -> {1, {Second, {Second, Minute, Hour}}}
				]
			},
			{
				OptionName -> NumberOfGrindingSteps,
				Default -> Automatic,
				Description -> "Determines how many times the grinding process is repeated to completely grind the sample and prevent excessive heating of the sample. Between each grinding step there is a cooling time that the grinder is switched off to cool down the sample and prevent excessive rise in sample's temperature.",
				ResolutionDescription -> "Automatically set to 1 if Grind is True.",
				AllowNull -> True,
				Category -> "Grinding",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 50, 1]
				]
			},
			{
				OptionName -> CoolingTime,
				Default -> Automatic,
				Description -> "Determines the duration of time between each grinding step that the grinder is switched off to cool down the sample and prevent excessive rise in the sample's temperature.",
				ResolutionDescription -> "Automatically set to 30 Second if Grind is set to True and NumberOfGrindingSteps is greater than 1.",
				AllowNull -> True,
				Category -> "Grinding",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Second, $MaxExperimentTime, 1 Second],
					Units -> {1, {Second, {Second, Minute, Hour}}}
				]
			},
			{
				OptionName -> GrindingProfile,
				Default -> Automatic,
				Description -> "A set of steps of the grinding process, with each step provided as {grinding rate, grinding time} or as {wait time} indicating a cooling period to prevent the sample from overheating.",
				ResolutionDescription -> "Automatically set to reflect the selections of GrindingRate, GrindingTime, NumberOfGrindingSteps, and CoolingTime if Grind is set to True.",
				AllowNull -> True,
				Category -> "Grinding",
				Widget -> Adder[Alternatives[
					"Grinding" -> {
						"Rate" -> Widget[
							Type -> Quantity,
							Pattern :> Alternatives[RangeP[0 RPM, 25000 RPM], RangeP[0 Hertz, 420 Hertz]],
							Units -> Alternatives[RPM, Hertz]
						],
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[1 Second, $MaxExperimentTime, 1 Second],
							Units -> {1, {Second, {Second, Minute, Hour}}}
						]
					},
					"Cooling" -> {
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[1 Second, $MaxExperimentTime, 1 Second],
							Units -> {1, {Second, {Second, Minute, Hour}}}
						]
					}
				]]
			},

			(* Desiccation *)
			{
				OptionName -> Desiccate,
				Default -> Automatic,
				Description -> "Determines if the sample is dried (removing water or solvent molecules) via a desiccator or an oven before loading into a capillary and measuring the melting point. Water or solvent molecules can act as an impurity and may affect the observed melting range.",
				ResolutionDescription -> "Automatically set to False the sample is prepacked into a melting point capillary or Amount is set Null.",
				AllowNull -> False,
				Category -> "Desiccation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> SampleContainer,
				Default -> Automatic,
				Description -> "The container that the sample Amount is transferred into prior to desiccating in a bell jar if Desiccate is set to True. The container's lid is off during desiccation. Null indicates the sample is desiccated in its primary container.",
				ResolutionDescription -> "Automatically set to Null if Desiccate is False or Amount is set to All; otherwise, it is calculated by the PreferredContainer function. If Desiccate is True, Null indicates that the sample is desiccated in its primary container without being transferred to another.",
				AllowNull -> True,
				Category -> "Desiccation",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Tubes & Vials"
						}
					}
				]
			}
		],
		{
			OptionName -> DesiccationMethod,
			Default -> Automatic,
			Description -> "Method of drying the sample (removing water or solvent molecules from the solid sample). Options include StandardDesiccant, Vacuum, and DesiccantUnderVacuum. StandardDesiccant involves utilizing a sealed bell jar desiccator that exposes the sample to a chemical desiccant that absorbs water molecules from the exposed sample. DesiccantUnderVacuum is similar to StandardDesiccant but includes creating a vacuum inside the bell jar via pumping out the air by a vacuum pump. Vacuum just includes creating a vacuum by a vacuum pump and desiccant is NOT used inside the desiccator.",
			ResolutionDescription -> "Automatically set to StandardDesiccant if Desiccate is True.",
			AllowNull -> True,
			Category -> "Desiccation",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> DesiccationMethodP
			]
		},
		{
			OptionName -> Desiccant,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample before grinding and/or packing the sample into a melting point capillary tube prior to the measurement.",
			ResolutionDescription -> "Automatically set to Model[Sample, \"Indicating Drierite\"] if Desiccate is set to True",
			Category -> "Desiccation",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Consumable], Object[Item, Consumable], Model[Sample], Object[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Reagents",
						"Desiccants"
					}
				}
			]
		},
		{
			OptionName -> DesiccantPhase,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The physical state of the desiccant in the desiccator which dries the exposed sample by absorbing water molecules from the sample.",
			ResolutionDescription -> "Automatically set to the physical state of the selected desiccant if Desiccate is set to True.",
			Category -> "Desiccation",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Solid, Liquid]
			]
		},
		{
			OptionName -> CheckDesiccant,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "Indicates if the color of the desiccant is verified and is thrown out before the experiment begins if the color indicates it is expired.",
			ResolutionDescription -> "Automatically set to True if Desiccant model is Model[Sample, \"Indicating Drierite\"].",
			Category -> "Desiccation",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> DesiccantAmount,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The mass of a solid or the volume of a liquid hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample before grinding and/or packing the sample into a melting point capillary tube prior to the measurement.",
			ResolutionDescription -> "Automatically set to 100 Gram or Milliliter if Desiccate is set to True and DesiccantPhase is Solid or Liquid.",
			Category -> "Desiccation",
			Widget -> Alternatives[
				"Mass" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Gram, $MaxTransferMass, 1 Gram],
					Units -> {1, {Gram, {Gram, Kilogram}}}
				],
				"Volume" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Milliliter, $MaxTransferVolume, 1 Milliliter],
					Units -> {1, {Milliliter, {Milliliter, Liter}}}
				]
			]
		},
		{
			OptionName -> DesiccantStorageCondition,
			Default -> Automatic,
			Description -> "The storage conditions of the desiccant after the protocol is completed.",
			ResolutionDescription -> "Automatically set to Disposal if Desiccant is not Null.",
			AllowNull -> True,
			Category -> "Storage Information",
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP | Desiccated | VacuumDesiccated | RefrigeratorDesiccated | Disposal
				],
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[StorageCondition]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Storage Conditions"
						}
					}
				]
			]
		},
		{
			OptionName -> DesiccantStorageContainer,
			Default -> Automatic,
			Description -> "The desired container that the desiccant is transferred into after desiccation. If Not specified, it is determined by PreferredContainer function.",
			ResolutionDescription -> "Automatically set to Null if DesiccantStorageCondition is Disposal, otherwise, calculated by PreferredContainer function.",
			AllowNull -> True,
			Category -> "Storage Information",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Containers",
						"Tubes & Vials"
					}
				}
			]
		},
		{
			OptionName -> Desiccator,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The instrument that is used to dry (remove water or solvent molecules from) the sample prior to measuring the sample's melting point.",
			ResolutionDescription -> "Automatically set to Model[Instrument, Desiccator, \"Bel-Art Space Saver Vacuum Desiccator\"] if Desiccate is set to True.",
			Category -> "Desiccation",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, Desiccator], Object[Instrument, Desiccator]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Desiccators",
						"Open Sample Desiccators"
					}
				}
			]
		},
		{
			OptionName -> DesiccationTime,
			Default -> Automatic,
			Description -> "Determines how long the sample is dried via desiccator prior to packing the sample into the capillary and measuring the melting point, if OrderOfOperations is set to {Grind, Desiccate}.",
			ResolutionDescription -> "Automatically set to 5 Hours if Desiccate is set to True.",
			AllowNull -> True,
			Category -> "Desiccation",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[1 Minute, $MaxExperimentTime, 1 Minute],
				Units -> {1, {Hour, {Minute, Hour, Day}}}
			]
		},

		IndexMatching[
			IndexMatchingInput -> "experiment samples",

			(*Capillary Packing*)
			(* Polymer sealing clay is used to seal the capillaries. other options: Soldering Iron, Plasma Lighter *)
			{
				OptionName -> SealCapillary,
				Default -> Automatic,
				Description -> "Indicates if the top end of the melting point capillary is sealed with sealing clay after packing the sample. If the sample sublimates or decomposes it is recommended to seal the capillary.",
				ResolutionDescription -> "Automatically set to True if EndTemperature is less than 20 Celsius below the sample's BoilingPoint.",
				AllowNull -> True,
				Category -> "Packing",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> True | False
				]
			}
		],

		(* The Experiment: Measuring Melting Point *)
		{
			OptionName -> Instrument,
			Default -> Automatic,
			Description -> "The instrument that is used to measure the melting point of solid substances by applying an increasing temperature gradient to the samples that are packed into capillary tubes and monitoring phase transitions over the course of time.",
			ResolutionDescription -> "Automatically set to an available melting point apparatus depending on the EndTemperature and NumberOfReplicates.",
			AllowNull -> False,
			Category -> "Measurement",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, MeltingPointApparatus], Object[Instrument, MeltingPointApparatus]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Melting Point"
					}
				}
			]
		},

		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> StartTemperature,
				Default -> Automatic,
				Description -> "The initial temperature of the chamber that holds the capillaries before sweeping the temperature to the EndTemperature. Typically set to 5 Celsius below the ExpectedMeltingPoint if known.",
				ResolutionDescription -> "Automatically set to 5 Celsius below the ExpectedMeltingPoint. If ExpectedMeltingPoint is Unknown, automatically set to 40 Celsius.",
				AllowNull -> False,
				Category -> "Measurement",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[25 Celsius, 400 Celsius, 0.1 Celsius],
					Units -> Alternatives[Celsius, Kelvin, Fahrenheit]
				]
			},
			{
				OptionName -> EquilibrationTime,
				Default -> 30 Second,
				Description -> "Time duration to equilibrate the sample capillary at the StartTemperature before starting the temperature ramp.",
				AllowNull -> False,
				Category -> "Measurement",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Second, 120 Second, 1 Second],
					Units -> {1, {Second, {Second, Minute}}}
				]
			},
			{
				OptionName -> EndTemperature,
				Default -> Automatic,
				Description -> "The final temperature to conclude the temperature sweep of the chamber that holds the capillaries. Typically set to 5 Celsius above the ExpectedMeltingPoint if known.",
				ResolutionDescription -> "Automatically set to 5 Celsius above the ExpectedMeltingPoint. If ExpectedMeltingPoint is set to Unknown, the measurement automatically stops after the sample melts.",
				AllowNull -> False,
				Category -> "Measurement",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[25 Celsius, 400 Celsius, 0.1 Celsius],
					Units -> Alternatives[Celsius, Kelvin, Fahrenheit]
				]
			},
			{
				OptionName -> TemperatureRampRate,
				Default -> Automatic,
				Description -> "Determines the speed of the temperature at which it is swept from the StartTemperature to the EndTemperature.",
				ResolutionDescription -> "Automatically set to 10 Celsius/Minute if ExpectedMeltingPoint is Unknown or 1 Celsius/Minute if ExpectedMeltingPoint is Unknown. If RampTime, StartTemperature, and EndTemperature are set, TemperatureRampRate will be calculated from those three options.",
				AllowNull -> False,
				Category -> "Measurement",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Celsius/Minute, 20 Celsius/Minute, 0.1 Celsius/Minute],
					Units -> CompoundUnit[{1, {Celsius, {Celsius, Kelvin, Fahrenheit}}}, {-1, {Minute, {Second, Minute}}}]
				]
			},
			{
				OptionName -> RampTime,
				Default -> Automatic,
				Description -> "Duration of temperature sweep between the StartTemperature and EndTemperature. If it is changed to a user-defined value, TemperatureRampRate will be adjusted accordingly.",
				ResolutionDescription -> "Automatically calculated based on the set values of StartTemperature, EndTemperature, and TemperatureRampRate.",
				AllowNull -> False,
				Category -> "Measurement",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, 3750 Minute, 1 Second],
					Units :> {1, {Minute, {Second, Minute, Hour}}}
				]
			},

			(*Storage Information*)
			{
				OptionName -> PreparedSampleStorageCondition,
				Default -> Null,
				Description -> "The non-default conditions under which the prepared sample remaining after grinding and/or desiccating is stored after the protocol is completed. If left unset, the prepared sample will be stored according to its corresponding input sample's StorageCondition or its model's DefaultStorageCondition.",
				AllowNull -> True,
				Category -> "Storage Information",
				(* Null indicates the storage conditions is inherited from the model *)
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> SampleStorageTypeP | Desiccated | VacuumDesiccated | RefrigeratorDesiccated | Disposal
					],
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[StorageCondition]],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Storage Conditions"
							}
						}
					]
				]
			},
			{
				OptionName -> CapillaryStorageCondition,
				Default -> Disposal,
				Description -> "Determines the destiny of the sample-packed melting point capillaries after the experiment. The used melting point capillary tube can be retained in case it is needed for repeating the melting point experiment on the same capillary tube.",
				AllowNull -> False,
				Category -> "Storage Information",
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> SampleStorageTypeP | Desiccated | VacuumDesiccated | RefrigeratorDesiccated | Disposal
					],
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[StorageCondition]],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Storage Conditions"
							}
						}
					]
				]
			}
		],
		PreparatoryUnitOperationsOption,
		ProtocolOptions,
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 1 Gram."
			}
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Vessel, \"2 mL conical tube (no skirt) with cap and sealing ring\"]."
			}
		],
		SimulationOption,
		NonBiologyPostProcessingOptions
	}
];

(* ::Subsection::Closed:: *)
(* ExperimentMeasureMeltingPoint Errors and Warnings *)
Error::NonSolidSample = "The samples `1` do not have a Solid state and cannot be processed. Remove these samples from the function input.";
Error::UnusedOptions = "`1`";
Error::RequiredPreparationOptions = "`1`";
Error::RequiredDesiccateOptions = "`1`";
Error::RequiredGrindOptions = "`1`";
Error::OrderOfOperationsMismatch = "The specified OrderOfOperations, `1`, does not match Desiccate and Grind options for Sample(s) `2`. OrderOfOperation must be set to {Desiccate, Grind} or {Grind, Desiccate} if both Desiccate and Grind are True; otherwise, it should be Null. Alternatively, leave it unspecified to calculate automatically.";
Error::InvalidExpectedMeltingPoint = "ExpectedMeltingPoint for samples `1` is set to a value that is out of the instrument's temperature range. Set the ExpectedMeltingPoint option to a value between 25.1 and `2`.";
Error::InvalidStartEndTemperatures = "EndTemperature must be greater than StartTemperature for the following samples: `1`.";
Warning::MismatchedRampRateAndTime = "TemperatureRampRate and RampTime are set to mismatching values for the following samples: `1`. TemperatureRampRate is adjusted to a value that matches RampTime.";
Error::InvalidNumberOfReplicates = "Sample(s) `1` are prepacked in melting point capillary tubes. Therefore, NumberOfReplicates must be Null for these samples. NumberOfReplicates determines how many melting point capillaries are packed with the same sample. If the sample is prepacked in a melting point capillary, NumberOfReplicates must be set to Null. If the sample is not prepacked, NumberOfReplicates of Null, 2, or 3, respectively, indicate that 1, 2, or 3 capillaries are to be packed with the same sample.";
Error::InvalidPreparedSampleStorageCondition = "Storage conditions of the sample(s) `1` are not informed, therefore, PreparedSampleStorageCondition of the corresponding prepared samples cannot be automatically determined. Please specify PreparedSampleStorageCondition in options or update the StorageCondition of sample(s) `1` or DefaultStorageCondition of the sample model(s).";
Error::LongExperimentTime = "The estimated total experiment time is greater than the maximum allowed experiment time, `1`. Please reduce the experiment times or number of samples.";
Error::NoAvailableMeltingPointInstruments = "There's no melting point instruments at your experiment sites, `1`.";
Error::InvalidInstrument = "The specified instrument, `1`, does not exist at your allowed experiment sites, `2`.";
Error::InvalidEndTemperatures = "The specified EndTemperature, `1`, for samples `2` are greater than the MaxTemperature of the `3`.";
Error::HighNumberOfReplicates = "The specified NumberOfReplicates, `1`, for samples `2` are greater than the NumberOfMeltingPointCapillarySlots of the `3`.";


(* ::Subsection::Closed:: *)
(* ExperimentMeasureMeltingPoint *)

(*Mixed Input*)
ExperimentMeasureMeltingPoint[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
	{listedContainers, listedOptions, outputSpecification, output, gatherTests, containerToSampleResult, samples,
		sampleOptions, containerToSampleTests, containerToSampleOutput, validSamplePreparationResult, containerToSampleSimulation,
		mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation},

	(*Determine the requested return value from the function*)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests = MemberQ[output, Tests];

	(*Make sure inputs are lists.*)
	{listedContainers, listedOptions} = {ToList[myInputs], ToList[myOptions]};

	(*First, simulate our sample preparation.*)
	validSamplePreparationResult = Check[
		(*Simulate sample preparation.*)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentMeasureMeltingPoint,
			listedContainers,
			listedOptions,
			DefaultPreparedModelAmount -> 1 Gram,
			DefaultPreparedModelContainer -> Model[Container, Vessel, "2 mL conical tube (no skirt) with cap and sealing ring"]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(*If we are given an invalid define name, return early.*)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(*Return early.*)
		(*Note: We've already thrown a message above in simulateSamplePreparationPackets.*)
		Return[$Failed]
	];

	(*Convert our given containers into samples and sample index-matched options.*)
	containerToSampleResult = If[gatherTests,
		(*We are gathering tests. This silences any messages being thrown.*)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentMeasureMeltingPoint,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result, Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(*Therefore, we have to run the tests to see if we encountered a failure.*)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentMeasureMeltingPoint,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output -> {Result, Simulation},
				Simulation -> updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult, $Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification /. {
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null,
			InvalidInputs -> {},
			InvalidOptions -> {}
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentMeasureMeltingPoint[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];

(* Sample input/core overload*)
ExperimentMeasureMeltingPoint[mySamples : ListableP[ObjectP[{Object[Sample], Model[Sample]}]], myOptions : OptionsPattern[]] := Module[
	{
		listedSamples, listedOptions, outputSpecification, output, gatherTests, site, meltingPointInstrumentObjects,
		validSamplePreparationResult, samplesWithPreparedSamples, personID, meltingPointInstrumentModelFields,
		optionsWithPreparedSamples, safeOps, safeOpsTests, capillarySeal,
		grinderFields, packingDeviceFields, packingDevices,
		validLengths, validLengthTests, instruments, allMeltingPointInstrumentModels,
		templatedOptions, templateTests, inheritedOptions, desiccatorModels, grinders,
		expandedSafeOps, capillaryContainers, packetObjectSample, preferredContainers,
		containerOutObjects, containerOutModels, desiccatorObjects,
		instrumentObjects, allObjects, allContainers, objectSampleFields,
		modelSampleFields, modelContainerFields, objectContainerFields,
		updatedSimulation, upload, confirm, canaryBranch, fastTrack, parentProtocol, cache,
		meltingPointInstrumentFields, allGrindingBeadModels,
		downloadedStuff, cacheBall, resolvedOptionsResult,
		resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions,
		returnEarlyQ, performSimulationQ, grindingContainers, grindingBeads,
		samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed,
		safeOptionsNamed, allContainerModels, specifiedDesiccant,
		protocolPacketWithResources, resourcePacketTests, result,
		simulatedProtocol, simulation, capillaryRod
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentMeasureMeltingPoint,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentMeasureMeltingPoint, optionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentMeasureMeltingPoint, optionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(* replace all objects referenced by Name to ID *)
	{samplesWithPreparedSamples, safeOps, optionsWithPreparedSamples} = sanitizeInputs[samplesWithPreparedSamplesNamed, safeOptionsNamed, optionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentMeasureMeltingPoint, {samplesWithPreparedSamples}, optionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentMeasureMeltingPoint, {samplesWithPreparedSamples}, optionsWithPreparedSamples], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentMeasureMeltingPoint, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentMeasureMeltingPoint, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(*get assorted hidden options*)
	{upload, confirm, canaryBranch, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(*Expand index-matching options*)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentMeasureMeltingPoint, {samplesWithPreparedSamples}, inheritedOptions]];

	(*--- memoized Search for and Download all the information we need for resolver and resource packets function---*)
	{
		instruments,
		instrumentObjects,
		capillaryContainers,
		grindingContainers,
		grindingBeads,
		packingDevices,
		capillaryRod
	} = meltingPointSearch["Memoization"];

	(*Capillary seal*)
	capillarySeal = {Model[Item, Consumable, "HemataSeal"]};

	(* all possible containers that the resolver might use*)
	preferredContainers = DeleteDuplicates[
		Flatten[{
			PreferredContainer[All, Type -> All],
			PreferredContainer[All, LightSensitive -> True, Type -> All]
		}]
	];

	(* any container the user provided (in case it's not on the PreferredContainer list) *)
	containerOutObjects = DeleteDuplicates[Cases[
		Flatten[Lookup[expandedSafeOps, {SampleContainer, ContainerOut}]],
		ObjectP[Object]
	]];
	containerOutModels = DeleteDuplicates[Cases[
		Flatten[Lookup[expandedSafeOps, {SampleContainer, ContainerOut}]],
		ObjectP[Model]
	]];

	desiccatorObjects = Cases[instrumentObjects, ObjectP[Object[Instrument, Desiccator]]];
	meltingPointInstrumentObjects = Cases[instrumentObjects, ObjectP[Object[Instrument, MeltingPointApparatus]]];

	(* split things into groups by types (since we'll be downloading different things from different types of objects) *)
	allObjects = DeleteDuplicates[Flatten[{instruments, preferredContainers, containerOutModels, containerOutObjects, capillaryContainers, grindingContainers}]];
	instruments = Cases[allObjects, ObjectP[Model[Instrument]]];
	grinders = Cases[instruments, ObjectP[Model[Instrument, Grinder]]];
	desiccatorModels = Cases[instruments, ObjectP[Model[Instrument, Desiccator]]];
	allMeltingPointInstrumentModels = Cases[instruments, ObjectP[Model[Instrument, MeltingPointApparatus]]];
	allContainerModels = Flatten[{
		Cases[allObjects, ObjectP[{Model[Container, Vessel], Model[Container, Capillary], Model[Container, GrindingContainer]}]],
		Cases[KeyDrop[inheritedOptions, {Cache, Simulation}], ObjectReferenceP[{Model[Container]}], Infinity],

		(*Desiccant Container*)
		{Model[Container, Vessel, "id:4pO6dMOxdbJM"]} (* Pyrex Crystallization Dish *)
	}];

	allContainers = Flatten[{
		Cases[
			KeyDrop[inheritedOptions, {Cache, Simulation}],
			ObjectReferenceP[Object[Container]],
			Infinity
		]
	}];

	allGrindingBeadModels = Flatten[{
		Cases[allObjects, ObjectP[Model[Item, GrindingBead]]],
		Cases[KeyDrop[inheritedOptions, {Cache, Simulation}], ObjectReferenceP[Model[Item, GrindingBead]], Infinity]
	}];

	(*articulate all the fields needed*)
	objectSampleFields = Union[SamplePreparationCacheFields[Object[Sample]], {Composition, MeltingPoint, BoilingPoint}];
	modelSampleFields = Union[SamplePreparationCacheFields[Model[Sample]], {DefaultStorageCondition, MeltingPoint, BoilingPoint}];
	objectContainerFields = Union[SamplePreparationCacheFields[Object[Container]]];
	modelContainerFields = Union[SamplePreparationCacheFields[Model[Container]]];
	meltingPointInstrumentModelFields = {Name, Measurands, NumberOfMeltingPointCapillarySlots, MinTemperature, MaxTemperature, MinTemperatureRampRate, MaxTemperatureRampRate};
	meltingPointInstrumentFields = {Model, Site};
	grinderFields = {Name, GrinderType, Objects, MinAmount, MaxAmount, MinTime, MaxTime, FeedFineness, MaxGrindingRate, MinGrindingRate, Positions, AssociatedAccessories};
	packingDeviceFields = {Name, NumberOfCapillaries};

	(* in the past including all these different through-link traversals in the main Download call made things slow because there would be duplicates if you have many samples in a plate *)
	(* that should not be a problem anymore with engineering's changes to make Download faster there; we can split this into multiples later if that no longer remains true *)
	packetObjectSample = {
		Packet[Sequence @@ objectSampleFields],
		Packet[Container[objectContainerFields]],
		Packet[Container[Model][modelContainerFields]],
		Packet[Model[modelSampleFields]],
		Packet[Model[Hold[Composition[[All, 2]]]][modelSampleFields]]
	};

	(*Lookup specified Desiccant *)
	(* Lookup specified Desiccant *)
	specifiedDesiccant = Cases[Flatten[{
		Lookup[expandedSafeOps, Desiccant],
		Model[Sample, "id:GmzlKjzrmB85"], (*Indicating Drierite*)
		Model[Sample, "id:Vrbp1jG80ZnE"] (*Sulfuric acid*)
	}], ObjectP[]];

	(* look up site and PersonID to download available experiments sites and instrument models *)
	site = $Site;
	personID = $PersonID;

	(* download all the things *)
	downloadedStuff = Quiet[
		Download[
			{
				samplesWithPreparedSamples,
				allMeltingPointInstrumentModels,
				allContainerModels,
				allContainers,
				(*5*)allGrindingBeadModels,
				ToList[specifiedDesiccant],
				grinders,
				desiccatorModels,
				packingDevices,
				(*10*)capillarySeal,
				capillaryRod,
				desiccatorObjects,
				ToList[personID],
				(*14*)meltingPointInstrumentObjects
			},
			Evaluate[
				{
					packetObjectSample,
					{Evaluate[Packet @@ meltingPointInstrumentModelFields]},
					{Evaluate[Packet @@ modelContainerFields]},
					(* all basic container models (from PreferredContainers) *)
					{
						Evaluate[Packet @@ objectContainerFields],
						Packet[Model[modelContainerFields]]
					},
					(*5*){Packet[Diameter]},
					{Packet[State, Mass, Volume, Status, Model, Density, StorageCondition, DefaultStorageCondition]},
					{Evaluate[Packet @@ grinderFields]},
					{Packet[Name, Positions, SampleType]},
					{Evaluate[Packet @@ packingDeviceFields]},
					(*10*){Packet[Name]},
					{Packet[Name]},
					{Packet[Model]},
					{
						Packet[FinancingTeams, FirstName, LastName, Email, TeamEmailPreference, NotebookEmailPreferences, Site],
						Packet[FinancingTeams[ExperimentSites]]
					},
					(*14*){Evaluate[Packet @@ meltingPointInstrumentFields]}
				}
			],
			Cache -> cache,
			Simulation -> updatedSimulation,
			Date -> Now
		],
		{Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* get all the cache and put it together *)
	cacheBall = FlattenCachePackets[{cache, Cases[Flatten[downloadedStuff], PacketP[]]}];

	(* Build the resolved options *)
	resolvedOptionsResult = Check[
		{resolvedOptions, resolvedOptionsTests} = If[gatherTests,
			resolveExperimentMeasureMeltingPointOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
			{resolveExperimentMeasureMeltingPointOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> Result], {}}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentMeasureMeltingPoint,
		resolvedOptions,
		Ignore -> listedOptions,
		Messages -> False
	];


	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	(*performSimulationQ = MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];*)

	performSimulationQ = MemberQ[output, Result | Simulation];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
			Options -> RemoveHiddenOptions[ExperimentMeasureMeltingPoint, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(*Build packets with resources*)
	{protocolPacketWithResources, resourcePacketTests} = Which[
		returnEarlyQ,
			{$Failed, {}},
		gatherTests,
			measureMeltingPointResourcePackets[
				samplesWithPreparedSamples,
				templatedOptions,
				resolvedOptions,
				collapsedResolvedOptions,
				Cache -> cacheBall,
				Simulation -> updatedSimulation,
				Output -> {Result, Tests}
			],
		True,
			{
				measureMeltingPointResourcePackets[
					samplesWithPreparedSamples,
					templatedOptions,
					resolvedOptions,
					collapsedResolvedOptions,
					Cache -> cacheBall,
					Simulation -> updatedSimulation,
					Output -> Result
				],
				{}
			}
	];

	(* --- Simulation --- *)
	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = Which[
		MatchQ[protocolPacketWithResources, $Failed], {$Failed, Simulation[]},
		performSimulationQ,
			simulateExperimentMeasureMeltingPoint[
				protocolPacketWithResources[[1]], (* protocolPacket *)
				Flatten[ToList[protocolPacketWithResources[[2]]]], (* unitOperationPackets *)
				ToList[samplesWithPreparedSamples],
				resolvedOptions,
				Cache -> cacheBall,
				Simulation -> updatedSimulation
			],
		True, {Null, Null}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentMeasureMeltingPoint, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	result = If[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[protocolPacketWithResources, $Failed], $Failed,

		(* Actually upload our protocol object. We are being called as a sub-protocol in ExperimentManualSamplePreparation. *)
		UploadProtocol[
			protocolPacketWithResources[[1]], (*protocolPacket*)
			ToList[protocolPacketWithResources[[2]]], (*unitOperationPackets*)
			Upload -> Lookup[safeOps, Upload],
			Confirm -> Lookup[safeOps, Confirm],
			CanaryBranch -> Lookup[safeOps, CanaryBranch],
			ParentProtocol -> Lookup[safeOps, ParentProtocol],
			Priority -> Lookup[safeOps, Priority],
			StartDate -> Lookup[safeOps, StartDate],
			HoldOrder -> Lookup[safeOps, HoldOrder],
			QueuePosition -> Lookup[safeOps, QueuePosition],
			ConstellationMessage -> {Object[Protocol, MeasureMeltingPoint]},
			Cache -> cacheBall,
			Simulation -> updatedSimulation
		]
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> result,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentMeasureMeltingPoint, collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation
	}
];

(* ::Subsection::Closed:: *)
(*resolveExperimentMeasureMeltingPointOptions*)

DefineOptions[
	resolveExperimentMeasureMeltingPointOptions,
	Options :> {HelperOutputOption, SimulationOption, CacheOption}
];

resolveExperimentMeasureMeltingPointOptions[myInputSamples : {ObjectP[Object[Sample]]...}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentMeasureMeltingPointOptions]] := Module[
	{
		outputSpecification, output, gatherTests, cache, simulation, unresolvedGrindingRates, orderMismatches, site,
		samplePrepOptions, measureMeltingPointOptions, unresolvedGrindingTimes, orderOptionMismatches, resolvedGrinderTypes,
		simulatedSamples, mismatchedRampRateRampTimeTest, grinderTypeChangeQs, resolvedDesiccationTime, resolvedDesiccator,
		resolvedSampleLabel, resolvedSampleContainerLabel, resolvedAmounts, resolvedDesiccationMethod, resolvedGrinders,
		resolvedSamplePrepOptions, updatedSimulation, samplePrepTests, resolvedGrindingProfiles, grindTargetOptions,
		samplePackets, modelPackets, sampleContainerPacketsWithNulls, resolvedNumberOfGrindingSteps, allPrepackedQ,
		sampleContainerModelPacketsWithNulls, temperatureUnit, resolvedGrindingTimes, resolvedGrindingRates, personID,
		resolvedOrderOfOperations, invalidStartEndTemperatures, resolvedGrindingContainers, desiccateTargetOptions,
		startEndTemperatureInvalidOptions, startEndTemperatureInvalidTest, resolvedBulkDensities, resolvedGrindValues,
		invalidOrders, mismatchedRampRateRampTimeOptions, resolvedFinenesses, resolvedDesiccateValues, onSiteInstrumentModels,
		resolvedExpectedMeltingPoint, resolvedNumberOfReplicates, valueChangedQs, realDesiccateQs, possibleInstrumentModels,
		resolvedSealCapillary, unresolvedMeasurementMethod, invalidNumbersOfReplicates, resolvedOptionValues, desiredInstrumentModels,
		numberOfReplicatesMismatchedOptions, numberOfReplicatesMismatchedTest, prepackedSamplePrepUnneededOptions,
		capillaryStorageCondition, amountStorageConditionMismatches, unresolvedOptionValues, prepareQs, financingTeams,
		amountChangedQs, samplePreparationOptionNames, allPrepackedErrorOptions, allNoPrepErrorOptions, experimentSites,
		resolvedStartTemperature, equilibrationTime, grinderChangedQs, finenessChangedQs, bulkDensityChangedQs,
		grindingContainerChangedQs, grindingRateChangedQs, grindingTimeChangedQs, numberOfGrindingStepsChangedQs,
		grindingProfileChangesQs, desiccationMethodChangedQ, desiccatorChangedQ, desiccationTimeChangedQ,
		resolvedEndTemperature, resolvedTemperatureRampRate, resolvedRampTime, rampRateChangeWarnings, availableMaxTemperatures,
		preparedSampleStorageCondition, resolvedPreparedSampleLabel, resolvedAmount, multipleDesiccateOptionNames,
		cacheBall, unresolvedGrinderTypes, unresolvedGrinders, unresolvedFinenesses, requiredDesiccateSingletonOptionNames,
		unresolvedBulkDensities, unresolvedGrindingContainers, unresolvedNumbersOfGrindingSteps, errorNumbers,
		unresolvedGrindingProfiles, sampleDownloads, fastAssoc, sampleContainerModelPackets, sampleContainerPackets,
		messages, discardedSamplePackets, discardedInvalidInputs, errorTuples, errorToSampleRules, noPrepUnneededOptions,
		discardedTest, mapThreadFriendlyOptions, desiccatePrepackedMismatches, requiredGrindOptionNames, availableMaxSlots,
		measureMeltingPointOptionAssociation, optionPrecisions, prepackedDesiccateUnneededOptions, uniqueErrorAssociations,
		roundedMeasureMeltingPointOptions, precisionTests, noDesiccateQ, allOptionNames, uniqueErrorLists,
		nonSolidSamplePackets, nonSolidSampleInvalidInputs, noGrindQ, noGrindUnneededOptions, formattedErrorLists,
		nonSolidSampleTest, desiccateOptions, sampleObjects, noDesiccateUnneededOptions, allMultipleOptionNames,
		missingMassSamplePackets, missingMassInvalidInputs, prepackedGrindUnneededOptions, allDesiccateOptionNames,
		missingMassTest, desiccateSamples, desiccateResolvedOptionsResult, singletonDesiccateOptionNames,
		grindTests, grindResolvedOptionsResult, renamedGrindOptions, prepackedGrindMessageQ, prepackedPrepMessageQ,
		rawGrindOptionValues, grindOptionValues, grindOptionNames, grindSamples, requiredDesiccateMultipleOptionNames,
		invalidExpectedMeltingPoints, desiccateQs, grindQs, realGrindQs, noPrepMessageQ, groupedErrorLists,
		prepackedQs, desiccateTests, expectedMeltingPointInvalidOptions, desiccant, unresolvedDesiccant,
		expectedMeltingPointInvalidTest, unresolvedDesiccationMethod, requiredSingletonDesiccateOptions, suitableInstruments,
		amount, desiccationMethod, unresolvedDesiccantPhase, prepackedDesiccateMessageQ, noPrepTests, availableMaxSlot,
		resolvedPostProcessingOptions, resolvedOptions, desiccantPhase, requiredSingletonDesiccateOptionTests,
		desiccantAmount, unresolvedInstrument, unresolvedDesiccantAmount, unresolvedDesiccationTime, availableMaxTemperature,
		desiccantStorageCondition, unresolvedDesiccantStorageCondition, invalidPreparedSampleStorageConditions,
		desiccantStorageContainer, unresolvedDesiccantStorageContainer, desiccateGrindOptionMismatches, resolvedInstrument,
		desiccator, unresolvedDesiccator, desiccationTime, resolvedSampleContainer, orderOptionMismatchTests,
		resolvedDesiccateIndexMatchedOptions, resolvedDesiccateSingletonOptions, grindOptionNamesWithAmount,
		halfResolvedGrinderType, halfResolvedGrinder, halfResolvedFineness, desiccateGrindOptionMismatchTests,
		halfResolvedBulkDensity, halfResolvedGrindingContainer, halfResolvedGrindingBead, groupedMeltingPointOptions,
		halfResolvedNumberOfGrindingBeads, halfResolvedGrindingRate, halfResolvedGrindingTime, longExperimentTimeTest,
		halfResolvedNumberOfGrindingSteps, halfResolvedCoolingTime, halfResolvedGrindingProfile, groupedRampTimes,
		resolvedGrindOptions, grindOptions, optionValues, noGrindOptions, noGrindOptionValues, groupedEquilibrationTimes,
		renamedGrindResolvedOptionsResult, grindPrepackedMismatches, grindGrinderTypeMismatches, groupedNumberOfReplicates,
		prepackedGrinderTypeMismatches, prepackedGrinderMismatches, grindGrinderMismatches, groupedSampleLengths,
		prepackedFinenessMismatches, grindFinenessMismatches, prepackedBulkDensityMismatches, grindBulkDensityMismatches,
		prepackedGrindingContainerMismatches, grindGrindingContainerMismatches, noGrindMessageQ, grindingProfiles,
		amountPrepackedMismatches, amountDesiccateMismatches, amountGrindMismatches, longExperimentTimeOptions,
		prepackedGrindingBeadMismatches, grindGrindingBeadMismatches, noDesiccateMessageQ, sampleModels, grindInvalidOptions,
		prepackedNumberOfGrindingBeadsMismatches, grindNumberOfGrindingBeadsMismatches, availableInstrumentTuples,
		prepackedGrindingRateMismatches, grindGrindingRateMismatches, doubleTrueRequiredSamplePreparationOptionNames,
		prepackedGrindingTimeMismatches, grindGrindingTimeMismatches, singleTrueRequiredSamplePreparationOptionNames,
		prepackedCoolingTimeMismatches, grindCoolingTimeMismatches, totalDesiccationTime, totalGrindTime,
		prepackedNumberOfGrindingStepsMismatches, grindNumberOfGrindingStepsMismatches, totalMeltingPointTime,
		prepackedGrindingProfileMismatches, grindGrindingProfileMismatches, totalEstimatedExperimentTime,
		prepackedSampleContainerMismatches, desiccateSampleContainerMismatches, invalidPreparedSampleStorageConditionsOptions,
		invalidInputs, invalidOptions, allTests, invalidPreparedSampleStorageConditionsTest, invalidEndTemperatures,
		endTemperatureInvalidOptions, endTemperatureInvalidTest, maxResolvedEndTemperature, invalidInstrumentTests,
		highNumbersOfReplicates, highNumberOfReplicatesTest, highNumberOfReplicatesOptions, desiccateInvalidOptions,
		maxResolvedNumberOfReplicates, meltingPointInstrumentObjects, meltingPointInstrumentObjectPackets,
		meltingPointInstrumentSites, allMeltingPointInstrumentModels, meltingPointInstrumentTuples, resolvedInstrumentModel,
		numberOfCapillarySlots, defaultMaxTemperature, defaultMaxNumberOfCapillarySlots, unresolvedInstrumentModel,
		noAvailableInstrumentQ, noAvailableInstruments, noAvailableInstrumentTests, invalidInstrumentQ, invalidInstruments,
		checkDesiccant, unresolvedCheckDesiccant, compositionModelPackets
	},

	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Separate out our MeasureMeltingPoint options from our Sample Prep options. *)
	{samplePrepOptions, measureMeltingPointOptions} = splitPrepOptions[myOptions];

	(* Resolve our sample prep options (only if the sample prep option is not true) *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentMeasureMeltingPoint, myInputSamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentMeasureMeltingPoint, myInputSamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> Result], {}}
	];

	(* Extract the packets that we need from our downloaded cache. *)
	(* need to do this even if we have caching because of the simulation stuff *)
	sampleDownloads = Quiet[Download[
		simulatedSamples,
		{
			Packet[Name, Volume, Mass, State, Status, Container, Solvent, Position, Composition, MeltingPoint, BoilingPoint, Model, StorageCondition, DefaultStorageCondition],
			Packet[Model[{DefaultStorageCondition, MeltingPoint, BoilingPoint, State}]],
			Packet[Model[Composition[[All, 2]][{DefaultStorageCondition, MeltingPoint, BoilingPoint, State}]]],
			Packet[Container[{Object, Model}]],
			Packet[Container[Model[{MaxVolume}]]]
		},
		Simulation -> updatedSimulation
	], {Download::FieldDoesntExist, Download::NotLinkField}];

	(* combine the cache together *)
	cacheBall = FlattenCachePackets[{
		cache,
		sampleDownloads
	}];

	(* generate a fast cache association *)
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(* Get the downloaded mess into a usable form *)
	{
		samplePackets,
		modelPackets,
		compositionModelPackets,
		sampleContainerPacketsWithNulls,
		sampleContainerModelPacketsWithNulls
	} = Transpose[sampleDownloads];

	(* look up sample models *)
	sampleModels = Lookup[samplePackets, Model, Null];

	(*Lookup some singleton options*)
	{
		unresolvedMeasurementMethod,
		unresolvedInstrument,
		unresolvedDesiccationMethod,
		unresolvedDesiccant,
		unresolvedDesiccantPhase,
		unresolvedDesiccantAmount,
		unresolvedDesiccator,
		unresolvedDesiccationTime,
		unresolvedDesiccantStorageContainer,
		unresolvedDesiccantStorageCondition,
		unresolvedCheckDesiccant
	} = Lookup[
		myOptions,
		{
			MeasurementMethod,
			Instrument,
			DesiccationMethod,
			Desiccant,
			DesiccantPhase,
			DesiccantAmount,
			Desiccator,
			DesiccationTime,
			DesiccantStorageContainer,
			DesiccantStorageCondition,
			CheckDesiccant
		}
	];

	(* If the sample is discarded, it doesn't have a container, so the corresponding container packet is Null. Make these packets {} instead so that we can call Lookup on them like we would on a packet. *)
	sampleContainerModelPackets = Replace[sampleContainerModelPacketsWithNulls, {Null -> {}}, 1];
	sampleContainerPackets = Replace[sampleContainerPacketsWithNulls, {Null -> {}}, 1];

	(*-- INPUT VALIDATION CHECKS --*)

	(* NOTE: MAKE SURE NONE OF THE SAMPLES ARE DISCARDED - *)
	(* Get the samples from samplePackets that are discarded. *)
	discardedSamplePackets = Select[Flatten[samplePackets], MatchQ[Lookup[#, Status], Discarded]&];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs = Lookup[discardedSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> cacheBall]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall] <> " are not discarded:", True, False]
			];
			passingTest = If[Length[discardedInvalidInputs] == Length[myInputSamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[myInputSamples, discardedInvalidInputs], Cache -> cacheBall] <> " are not discarded:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(*NOTE: MAKE SURE THE SAMPLES ARE SOLID*)
	(*Get the samples that are not solids. cannot measure melting points of non-solid samples*)
	nonSolidSamplePackets = Select[samplePackets, Not[MatchQ[Lookup[#, State], Solid | Null]]&];

	(* Keep track of samples that are not Solid *)
	nonSolidSampleInvalidInputs = Lookup[nonSolidSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[nonSolidSampleInvalidInputs] > 0 && messages,
		Message[Error::NonSolidSample, ObjectToString[nonSolidSampleInvalidInputs, Cache -> cacheBall]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	nonSolidSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[nonSolidSampleInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[nonSolidSampleInvalidInputs, Cache -> cacheBall] <> " have a Solid State:", True, False]
			];

			passingTest = If[Length[nonSolidSampleInvalidInputs] == Length[myInputSamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[myInputSamples, nonSolidSampleInvalidInputs], Cache -> cacheBall] <> " have a Solid State:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* NOTE: MAKE SURE THE SAMPLES HAVE A MASS IF THEY'RE a SOLID - *)
	(* Get the samples that do not have a MASS but are a solid *)
	missingMassSamplePackets = Select[Flatten[samplePackets],
		!MatchQ[Lookup[#, Container], ObjectP[Object[Container, Capillary]]] && NullQ[Lookup[#, Mass]]&];

	(* Keep track of samples that do not have mass but are a solid *)
	missingMassInvalidInputs = Lookup[missingMassSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[missingMassInvalidInputs] > 0 && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::MissingMassInformation, ObjectToString[missingMassInvalidInputs, Cache -> cacheBall]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	missingMassTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[missingMassInvalidInputs] == 0,
				Nothing,
				Warning["Input samples " <> ObjectToString[missingMassInvalidInputs, Cache -> cacheBall] <> " contain mass information:", True, False]
			];

			passingTest = If[Length[missingMassInvalidInputs] == Length[myInputSamples],
				Nothing,
				Warning["Input samples " <> ObjectToString[Complement[myInputSamples, missingMassInvalidInputs], Cache -> cacheBall] <> " contain mass information:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)
	(* Convert list of rules to Association so we can Lookup,Append,Join as usual. *)
	measureMeltingPointOptionAssociation = Association[measureMeltingPointOptions];

	(* TemperatureUnit used to be an option for the user to determine the unit of temperature unit of the instrument. now it is defaulted to Celsius *)
	temperatureUnit = Celsius;

	(* find available Instruments *)
	site = $Site;
	personID = $PersonID;

	(* lookup the model of the unresolved and resolved instrument *)
	unresolvedInstrumentModel = If[
		MatchQ[unresolvedInstrument, ObjectP[Object[Instrument, MeltingPointApparatus]]],
		Download[fastAssocLookup[fastAssoc, unresolvedInstrument, Model], Object],
		unresolvedInstrument
	];

	(* default instrument model: this is only used if no instrument model is found so that the code does not break down *)
	meltingPointInstrumentObjectPackets = Cases[fastAssoc, ObjectP[Object[Instrument, MeltingPointApparatus]]];
	meltingPointInstrumentObjects = DeleteDuplicates[Download[Lookup[meltingPointInstrumentObjectPackets, Object], Object]];
	allMeltingPointInstrumentModels = DeleteDuplicates[Download[Lookup[meltingPointInstrumentObjectPackets, Model], Object]];
	meltingPointInstrumentSites = DeleteDuplicates[Download[Lookup[meltingPointInstrumentObjectPackets, Site], Object]];

	(* create a tuple of instruments *)
	meltingPointInstrumentTuples = Transpose[{meltingPointInstrumentObjects, allMeltingPointInstrumentModels, meltingPointInstrumentSites}];

	(* instruments that exist on the user $Site *)
	onSiteInstrumentModels = Cases[meltingPointInstrumentTuples, {
		instrumentObject:ObjectP[Object[Instrument, MeltingPointApparatus]],
		instrumentModel:ObjectP[Model[Instrument, MeltingPointApparatus]],
		instrumentSite:ObjectP[site]
	} :> instrumentModel];

	financingTeams = Download[fastAssocLookup[fastAssoc, personID, FinancingTeams], Object];
	experimentSites = DeleteDuplicates[Download[Flatten[{
		site,
		fastAssocLookup[fastAssoc, financingTeams, ExperimentSites]
	}], Object]];

	(* instrument models that match the user's $Site or ExperimentSites *)
	possibleInstrumentModels = Flatten[Cases[meltingPointInstrumentTuples, {
		instrumentObject:ObjectP[Object[Instrument, MeltingPointApparatus]],
		instrumentModel:ObjectP[Model[Instrument, MeltingPointApparatus]],
		instrumentSite:ObjectP[experimentSites]
	} :> instrumentModel]];

	desiredInstrumentModels = If[
		MatchQ[unresolvedInstrument, Automatic],

		DeleteDuplicates[Flatten[Prepend[possibleInstrumentModels, onSiteInstrumentModels]]],

		Flatten[Cases[meltingPointInstrumentTuples, {
			instrumentObject:ObjectP[Object[Instrument, MeltingPointApparatus]],
			instrumentModel:ObjectP[unresolvedInstrumentModel],
			instrumentSite:ObjectP[experimentSites]
		} :> instrumentModel]]
	];

	(* the max number of capillary slots and temperatures provided by all ECL instruments at all sites *)
	defaultMaxTemperature = Max[fastAssocLookup[fastAssoc, allMeltingPointInstrumentModels, MaxTemperature]];

	defaultMaxNumberOfCapillarySlots = Max[fastAssocLookup[fastAssoc, allMeltingPointInstrumentModels, NumberOfMeltingPointCapillarySlots]];

		(* lookup max temperature and max number of capillary slots in the instruments *)
	availableMaxTemperatures = fastAssocLookup[fastAssoc, desiredInstrumentModels, MaxTemperature];
	availableMaxTemperature = Which[
		MatchQ[unresolvedInstrumentModel, ObjectP[Model[Instrument, MeltingPointApparatus]]],
			fastAssocLookup[fastAssoc, unresolvedInstrumentModel, MaxTemperature],

		MatchQ[availableMaxTemperatures, {TemperatureP..}],
			Max[fastAssocLookup[fastAssoc, possibleInstrumentModels, MaxTemperature]],

		(* if no suitable instrument found, give it a default value so the code does not break down *)
		True,
			defaultMaxTemperature
	];

	availableMaxSlots = fastAssocLookup[fastAssoc, desiredInstrumentModels, NumberOfMeltingPointCapillarySlots];

	availableMaxSlot = Which[
		MatchQ[unresolvedInstrumentModel, ObjectP[Model[Instrument, MeltingPointApparatus]]],
			fastAssocLookup[fastAssoc, unresolvedInstrumentModel, NumberOfMeltingPointCapillarySlots],

		MatchQ[possibleInstrumentModels, {ObjectP[]..}],
			Max[fastAssocLookup[fastAssoc, possibleInstrumentModels, NumberOfMeltingPointCapillarySlots]],

		(* if no suitable instrument found, give it a default value so the code does not break down *)
		True,
			defaultMaxNumberOfCapillarySlots
	];

	(* create a tuple of available instruments and their features *)
	availableInstrumentTuples = Transpose[{desiredInstrumentModels, availableMaxTemperatures, availableMaxSlots}];

	(*Define the options and associated precisions that we need to check*)
	optionPrecisions = {
		{Amount, 10^-3Gram},
		{ExpectedMeltingPoint, Quantity[10^-1, temperatureUnit]},
		{StartTemperature, Quantity[10^-1, temperatureUnit]},
		{EquilibrationTime, 1Second},
		{EndTemperature, Quantity[10^-1, temperatureUnit]},
		{TemperatureRampRate, Quantity[10^-1, Quantity[temperatureUnit] / Minute]},
		{RampTime, 1Second}
	};

	(* round values for options based on option precisions *)
	{roundedMeasureMeltingPointOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[measureMeltingPointOptionAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], AvoidZero -> True, Output -> {Result, Tests}],
		{RoundOptionPrecision[measureMeltingPointOptionAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], AvoidZero -> True], Null}
	];

	(* -- RESOLVE INDEX-MATCHED OPTIONS *)

	(* NOTE: MAPPING*)
	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentMeasureMeltingPoint, roundedMeasureMeltingPointOptions];

	(* big MapThread to get all the options resolved *)
	{
		(*1*)resolvedOrderOfOperations,
		resolvedExpectedMeltingPoint,
		resolvedNumberOfReplicates,
		resolvedAmount,
		resolvedPreparedSampleLabel,
		grindQs,
		halfResolvedGrinderType,
		halfResolvedGrinder,
		halfResolvedFineness,
		halfResolvedBulkDensity,
		(*11*)halfResolvedGrindingContainer,
		halfResolvedGrindingBead,
		halfResolvedNumberOfGrindingBeads,
		halfResolvedGrindingRate,
		halfResolvedGrindingTime,
		halfResolvedNumberOfGrindingSteps,
		halfResolvedCoolingTime,
		halfResolvedGrindingProfile,
		desiccateQs,
		resolvedSampleContainer,
		(*21*)resolvedSealCapillary,
		resolvedStartTemperature,
		equilibrationTime,
		resolvedEndTemperature,
		resolvedTemperatureRampRate,
		resolvedRampTime,
		preparedSampleStorageCondition,
		capillaryStorageCondition,
		invalidOrders,
		invalidExpectedMeltingPoints,
		(*31*)invalidStartEndTemperatures,
		rampRateChangeWarnings,
		amountStorageConditionMismatches,
		invalidNumbersOfReplicates,
		prepackedQs,
		desiccatePrepackedMismatches,
		grindPrepackedMismatches,
		grindGrinderTypeMismatches,
		prepackedGrinderTypeMismatches,
		prepackedGrinderMismatches,
		(*41*)grindGrinderMismatches,
		prepackedFinenessMismatches,
		grindFinenessMismatches,
		prepackedBulkDensityMismatches,
		grindBulkDensityMismatches,
		prepackedGrindingContainerMismatches,
		grindGrindingContainerMismatches,
		prepackedGrindingBeadMismatches,
		grindGrindingBeadMismatches,
		prepackedNumberOfGrindingBeadsMismatches,
		(*51*)grindNumberOfGrindingBeadsMismatches,
		prepackedGrindingRateMismatches,
		grindGrindingRateMismatches,
		prepackedGrindingTimeMismatches,
		grindGrindingTimeMismatches,
		prepackedNumberOfGrindingStepsMismatches,
		grindNumberOfGrindingStepsMismatches,
		prepackedCoolingTimeMismatches,
		grindCoolingTimeMismatches,
		prepackedGrindingProfileMismatches,
		(*61*)grindGrindingProfileMismatches,
		prepackedSampleContainerMismatches,
		desiccateSampleContainerMismatches,
		resolvedSampleLabel,
		amountPrepackedMismatches,
		resolvedSampleContainerLabel,
		amountDesiccateMismatches,
		amountGrindMismatches,
		unresolvedGrindingRates,
		unresolvedGrindingTimes,
		(*71*)orderMismatches,
		unresolvedGrinderTypes,
		unresolvedGrinders,
		unresolvedFinenesses,
		unresolvedBulkDensities,
		unresolvedGrindingContainers,
		unresolvedNumbersOfGrindingSteps,
		unresolvedGrindingProfiles,
		grinderTypeChangeQs,
		grinderChangedQs,
		(*81*)finenessChangedQs,
		bulkDensityChangedQs,
		grindingContainerChangedQs,
		grindingRateChangedQs,
		grindingTimeChangedQs,
		numberOfGrindingStepsChangedQs,
		grindingProfileChangesQs,
		amountChangedQs,
		invalidPreparedSampleStorageConditions,
		invalidEndTemperatures,
		(*91*)highNumbersOfReplicates
	} = Transpose[
		MapThread[
			Function[{samplePacket, modelPacket, options, sampleContainerPacket, sampleContainerModelPacket},
				Module[
					{
						convertedStartTemperature, rampRateChangeWarning, correctOrderPattern, orderMismatch,
						unresolvedDesiccate, desiccateQ, unresolvedGrind, grindQ, grinderTypeChangeQ,
						unresolvedOrderOfOperations, orderOfOperations, grinderChangedQ, highNumberOfReplicates,
						finenessChangedQ, bulkDensityChangedQ, grindingContainerChangedQ, grindingRateChangedQ,
						grindingTimeChangedQ, numberOfGrindingStepsChangedQ, grindingProfileChangesQ, amountChangedQ,
						rampTimeQ, rampRateQ, invalidPreparedSampleStorageCondition, dominantComponentBoilingPoint,
						expectedMeltingPoint, invalidExpectedMeltingPoint, invalidEndTemperature,
						massComponents, sortedComponents, dominantComponent, dominantComponentMeltingPoint,
						sealCapillary, unroundedStartTemperature, startTemperature,
						equilibrationTime, endTemperature, temperatureRampRate,
						rampTime, unresolvedSampleLabel,
						unresolvedSampleContainerLabel, sampleContainerLabel,
						unresolvedPreparedSampleLabel, sampleContainer,
						unresolvedExpectedMeltingPoint, unresolvedNumberOfReplicates,
						numberOfReplicates, invalidNumberOfReplicates, unresolvedAmount,
						unresolvedSealCapillary, prepackedQ, desiccatePrepackedMismatch, amountStorageConditionMismatch,
						unresolvedStartTemperature, grindPrepackedMismatch,
						amountPrepackedMismatch,
						unresolvedEndTemperature, unresolvedTemperatureRampRate, unresolvedRampTime,
						unroundedEndTemperature, convertedEndTemperature,
						unresolvedPreparedSampleStorageCondition, unresolvedCapillaryStorageCondition,
						invalidOrderOfOperations, unroundedTemperatureRampRate,
						invalidStartEndTemperature, convertedTemperatureRampRate,
						grinderType, grinder, fineness, bulkDensity, grindingContainer, grindingBead,
						numberOfGrindingBeads, grindingRate, grindingTime, numberOfGrindingSteps,
						coolingTime, grindingProfile, preparedSampleLabel,
						unresolvedSampleContainer, unresolvedGrinderType, unresolvedGrinder, unresolvedFineness,
						unresolvedBulkDensity, unresolvedGrindingContainer, unresolvedGrindingBead,
						unresolvedNumberOfGrindingBeads, unresolvedGrindingRate, unresolvedGrindingTime,
						unresolvedNumberOfGrindingSteps, unresolvedCoolingTime, unresolvedGrindingProfile,
						grindGrinderTypeMismatch, prepackedGrinderTypeMismatch,
						prepackedGrinderMismatch, grindGrinderMismatch, sampleLabel,
						prepackedFinenessMismatch, grindFinenessMismatch,
						prepackedBulkDensityMismatch, grindBulkDensityMismatch,
						prepackedGrindingContainerMismatch, grindGrindingContainerMismatch,
						prepackedGrindingBeadMismatch, grindGrindingBeadMismatch,
						prepackedNumberOfGrindingBeadsMismatch, grindNumberOfGrindingBeadsMismatch,
						prepackedGrindingRateMismatch, grindGrindingRateMismatch,
						prepackedGrindingTimeMismatch, grindGrindingTimeMismatch,
						prepackedNumberOfGrindingStepsMismatch, grindNumberOfGrindingStepsMismatch,
						prepackedCoolingTimeMismatch, grindCoolingTimeMismatch,
						prepackedGrindingProfileMismatch, grindGrindingProfileMismatch,
						prepackedSampleContainerMismatch, desiccateSampleContainerMismatch, errorCheckingVariables,
						amountDesiccateMismatch, amountGrindMismatch
					},

					(* error checking variables *)
					errorCheckingVariables = {
						(*1*)invalidOrderOfOperations,
						invalidExpectedMeltingPoint,
						invalidStartEndTemperature,
						rampRateChangeWarning,
						amountStorageConditionMismatch,
						invalidNumberOfReplicates,
						desiccatePrepackedMismatch,
						grindPrepackedMismatch,
						grindGrinderTypeMismatch,
						prepackedGrinderTypeMismatch,
						(*11*)prepackedGrinderMismatch,
						grindGrinderMismatch,
						prepackedFinenessMismatch,
						grindFinenessMismatch,
						prepackedBulkDensityMismatch,
						grindBulkDensityMismatch,
						prepackedGrindingContainerMismatch,
						grindGrindingContainerMismatch,
						prepackedGrindingBeadMismatch,
						grindGrindingBeadMismatch,
						(*21*)prepackedNumberOfGrindingBeadsMismatch,
						grindNumberOfGrindingBeadsMismatch,
						prepackedGrindingRateMismatch,
						grindGrindingRateMismatch,
						prepackedGrindingTimeMismatch,
						grindGrindingTimeMismatch,
						prepackedNumberOfGrindingStepsMismatch,
						grindNumberOfGrindingStepsMismatch,
						prepackedCoolingTimeMismatch,
						grindCoolingTimeMismatch,
						(*31*)prepackedGrindingProfileMismatch,
						grindGrindingProfileMismatch,
						prepackedSampleContainerMismatch,
						desiccateSampleContainerMismatch,
						amountPrepackedMismatch,
						amountDesiccateMismatch,
						amountGrindMismatch,
						orderMismatch,
						(*39*)invalidPreparedSampleStorageCondition
					};

					Evaluate[errorCheckingVariables] = ConstantArray[False, Length[errorCheckingVariables]];

					(* pull out all the relevant unresolved options*)
					{
						(*1*)unresolvedOrderOfOperations,
						unresolvedExpectedMeltingPoint,
						unresolvedNumberOfReplicates,
						unresolvedSealCapillary,
						unresolvedStartTemperature,
						equilibrationTime,
						unresolvedEndTemperature,
						unresolvedTemperatureRampRate,
						unresolvedRampTime,
						unresolvedPreparedSampleStorageCondition,
						(*11*)unresolvedCapillaryStorageCondition,
						unresolvedDesiccate,
						unresolvedGrind,
						unresolvedAmount,
						unresolvedSampleContainer,
						unresolvedGrinderType,
						unresolvedGrinder,
						unresolvedFineness,
						unresolvedBulkDensity,
						unresolvedGrindingContainer,
						(*21*)unresolvedGrindingBead,
						unresolvedNumberOfGrindingBeads,
						unresolvedGrindingRate,
						unresolvedGrindingTime,
						unresolvedNumberOfGrindingSteps,
						unresolvedCoolingTime,
						unresolvedGrindingProfile,
						unresolvedPreparedSampleLabel,
						unresolvedSampleLabel,
						(*30*)unresolvedSampleContainerLabel
					} = Lookup[
						options,
						{
							(*1*)OrderOfOperations,
							ExpectedMeltingPoint,
							NumberOfReplicates,
							SealCapillary,
							StartTemperature,
							EquilibrationTime,
							EndTemperature,
							TemperatureRampRate,
							RampTime,
							PreparedSampleStorageCondition,
							(*11*)CapillaryStorageCondition,
							Desiccate,
							Grind,
							Amount,
							SampleContainer,
							GrinderType,
							Grinder,
							Fineness,
							BulkDensity,
							GrindingContainer,
							(*21*)GrindingBead,
							NumberOfGrindingBeads,
							GrindingRate,
							GrindingTime,
							NumberOfGrindingSteps,
							CoolingTime,
							GrindingProfile,
							PreparedSampleLabel,
							SampleLabel,
							(*30*)SampleContainerLabel
						}
					];

					(* --- Resolve IndexMatched Options --- *)

					(*--------------------*)
					(*--------------------*)
					(* High level options *)
					(*--------------------*)
					(*--------------------*)

					(*Determine the type of the sample: prepacked if sample's container is a capillary, not packed if sample's container is not a capillary?*)
					prepackedQ = If[MatchQ[Lookup[sampleContainerPacket, Object], ObjectP[Object[Container, Capillary]]], True, False];

					(*Master Switch: Desiccate. If The sample is in a capillary, resolve to False, otherwise True. *)
					desiccateQ = Which[
						MatchQ[unresolvedDesiccate, Except[Automatic]], unresolvedDesiccate,
						MatchQ[unresolvedDesiccate, Automatic] && (prepackedQ || NullQ[unresolvedAmount]), False,
						True, True
					];

					(* Master Switch: Grind. If The sample is in a capillary, resolve to False, otherwise True. *)
					grindQ = Which[
						MatchQ[unresolvedGrind, Except[Automatic]], unresolvedGrind,
						MatchQ[unresolvedGrind, Automatic] && (prepackedQ || NullQ[unresolvedAmount]), False,
						True, True
					];

					(* SampleLabel; Default: Automatic *)
					sampleLabel = Which[
						MatchQ[unresolvedSampleLabel, Except[Automatic]], unresolvedSampleLabel,
						And[MatchQ[simulation, SimulationP], MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[samplePacket, Object]]],
						Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[samplePacket, Object]],
						True, "sample " <> StringDrop[Lookup[samplePacket, ID], 3]
					];

					(*Resolve OrderOfOperation. if both Desiccate and Grind are True, resolve to {Desiccate, Grind}, otherwise Null *)
					orderOfOperations = Which[
						MatchQ[unresolvedOrderOfOperations, Except[Automatic]], unresolvedOrderOfOperations,
						MatchQ[unresolvedOrderOfOperations, Automatic] && !prepackedQ && MatchQ[{desiccateQ, grindQ}, {True, True}], {Desiccate, Grind},
						True, Null
					];

					(* Throw an error if OrderOfOperation does not match with specified Desiccate and Grind *)
					correctOrderPattern = Switch[{prepackedQ, desiccateQ, grindQ},
						{True, _, _}, Null,
						{_, True, True}, {Desiccate, Grind} | {Grind, Desiccate},
						{_, True, False}, {Desiccate} | Null,
						{_, False, True}, {Grind} | Null,
						{_, False, False}, Null
					];

					(* flip the error switch if:
						1. OrderOfOperations does not match the pattern
						2. prepacked sample *)
					invalidOrderOfOperations = prepackedQ && !NullQ[orderOfOperations];
					orderMismatch = !prepackedQ && !MatchQ[orderOfOperations, correctOrderPattern];

					(*Resolve Amount: Amount determines the amount of the sample to be desiccated or ground. Amount is only needed when Desiccate or Grind is True. if both are False, Amount is ignored. *)
					{amount, amountChangedQ} = Which[
						prepackedQ,
							{unresolvedAmount /. Automatic :> Null, False},

						And[
							grindQ || desiccateQ,
							NullQ[unresolvedAmount]
						],
							{
								If[
									GreaterEqualQ[(Lookup[samplePacket, Mass] /. {Null | {} -> 1Gram}), 1 Gram],
									1 Gram,
									All
								],
								True
							},

						And[
							grindQ || desiccateQ,
							MatchQ[unresolvedAmount, Except[Automatic]]
						],
							{unresolvedAmount, False},

						grindQ || desiccateQ,
							{
								If[
									GreaterEqualQ[(Lookup[samplePacket, Mass] /. {Null | {} -> 1Gram}), 1 Gram],
									1 Gram,
									All
								],
								False
							},

						True,
							{Null, False}
					];

					(*flip an error switch if the sample is prepacked but Amount is informed. Throw the warning only if Amount is not automatically resolved*)
					amountPrepackedMismatch = TrueQ[prepackedQ] && !NullQ[amount] && !MatchQ[unresolvedAmount, Automatic];

					(*Resolve PreparedSampleLabel*)
					preparedSampleLabel = Which[
						MatchQ[unresolvedPreparedSampleLabel, Except[Automatic]],
						unresolvedPreparedSampleLabel,
						prepackedQ,
						Null,
						!NullQ[amount],
						CreateUniqueLabel["prepared sample "],
						True,
						Null
					];

					(*Resolve PreparedSampleStorageCondition*)
					(*flip an error switch if amount is Null but PreparedSampleStorageCondition is not Null*)
					amountStorageConditionMismatch = If[
						NullQ[amount] && !NullQ[unresolvedPreparedSampleStorageCondition],
						True,
						False
					];

					(*Throw an error if PreparedSampleStorageCondition resolves to Null*)
					invalidPreparedSampleStorageCondition = And[
						!prepackedQ,
						desiccateQ || grindQ,
						NullQ[unresolvedPreparedSampleStorageCondition],
						NullQ[Lookup[samplePacket, StorageCondition, Null]],
						Or[
							NullQ[modelPacket],
							NullQ[Lookup[modelPacket, DefaultStorageCondition, Null]]
						]
					];

					(*-----------------------------------*)
					(*-----------------------------------*)
					(* resolve Desiccate-related options *)
					(*-----------------------------------*)
					(*-----------------------------------*)
					(*flip an error switch if the sample is prepacked but Desiccate is True*)
					desiccatePrepackedMismatch = If[prepackedQ && desiccateQ, True, False];

					(* SampleContainer; Default: Automatic; Null indicates Input Sample's Container. If Desiccate is False or Amount is set to a value other than All, the specified amount of the sample is transferred into a SampleContainer determined by PreferredContainer*)
					sampleContainer = Which[
						MatchQ[unresolvedSampleContainer, Except[Automatic]],
							unresolvedSampleContainer,

						MatchQ[amount, Except[All | Null]] && TrueQ[desiccateQ],
							PreferredContainer[amount],

						True,
							Null
					];

					(* SampleContainerLabel; Default: Automatic.
					SampleContainer refers to the container that contains the sample during desiccation. *)
					sampleContainerLabel = Which[
						MatchQ[unresolvedSampleContainerLabel, Except[Automatic]],
						unresolvedSampleContainerLabel,
						And[
							MatchQ[simulation, SimulationP],
							MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[sampleContainerPacket, Object]]
						],
						Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[sampleContainerPacket, Object]],
						NullQ[sampleContainer],
						CreateUniqueLabel["input container " <> StringDrop[Lookup[sampleContainerPacket, ID], 3]],
						True,
						CreateUniqueLabel["sample container " <> StringDrop[Download[sampleContainer, ID], 3]]
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but SampleContainer is not Null or Automatic*)
					prepackedSampleContainerMismatch = If[prepackedQ && !desiccateQ && !MatchQ[unresolvedSampleContainer, Null | Automatic], True, False];

					(*flip an error switch if the sample is not prepacked and Desiccate is False but SampleContainer is not Null*)
					desiccateSampleContainerMismatch = If[!prepackedQ && !desiccateQ && !MatchQ[unresolvedSampleContainer, Null | Automatic], True, False];

					(*flip an error switch if the desiccateQ is True and unresolvedAmount is Null*)
					amountDesiccateMismatch = If[desiccateQ && NullQ[unresolvedAmount], True, False];



					(*-------------------------------*)
					(*-------------------------------*)
					(* resolve Grind-related options *)
					(*-------------------------------*)
					(*-------------------------------*)

					(*resolve Grind-related options: If Grind is True, Grind options will resolve by ExperimentGrind after the Big MapThread. Here, Grind-related options are resolved only if Grind is False*)

					(*flip an error switch if the sample is prepacked but Grind is True*)
					grindPrepackedMismatch = If[prepackedQ && grindQ, True, False];

					(*flip an error switch if the grindQ is True and unresolvedAmount is Null*)
					amountGrindMismatch = If[grindQ && NullQ[unresolvedAmount], True, False];


					(*Resolve GrinderType*)
					(* if Grind is True but we are in Error State, we need to change the user-specified value to successfully run the Grind resolver. these cases are tracked to change the value back to the user-specified value at the end of the resolver *)
					{grinderType, grinderTypeChangeQ} = Switch[{grindQ, unresolvedGrinderType},
						(* if Grind is False, GrinderType is Null *)
						{False, Automatic},
							{Null, False},

						(* if Grind is True but GrinderType is Null, it's an error state; set it to Automatic to be resolved by Grind resolver *)
						{True, Null},
							{Automatic, True},

						(* no need to change the value in other cases:
							{False, Except[Automatic]}: error state; won't go to Grind resolver;
							{True, Automatic | Except[Automatic}: handled by ExperimentGrind resolver. *)
						{_, _},
							{unresolvedGrinderType, False}
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but GrinderType is not Null*)
					prepackedGrinderTypeMismatch = If[prepackedQ && MatchQ[unresolvedGrinderType, Except[Null | Automatic]], True, False];

					(* flip an error switch if:
						 Grind is False but GrinderType is not Null or Automatic
						 OR
						 Grind is True but GrinderType is Null *)
					grindGrinderTypeMismatch = If[
						Or[
							grindQ && NullQ[unresolvedGrinderType],
							!grindQ && MatchQ[unresolvedGrinderType, Except[Null|Automatic]]
						],
						True,
						False
					];

					(*Resolve Grinder*)
					{grinder, grinderChangedQ} = Switch[{grindQ, unresolvedGrinder},
						(* if Grind is False, Grinder is Null *)
						{False, Automatic},
							{Null, False},

						(* if Grind is True but Grinder is Null, it's an error state; set it to Automatic to be resolved by Grind resolver *)
						{True, Null},
							{Automatic, True},

						(* no need to change the value in other cases:
							{False, Except[Automatic]}: error state; won't go to Grind resolver;
							{True, Automatic | Except[Automatic}: handled by ExperimentGrind resolver. *)
						{_, _},
							{unresolvedGrinder, False}
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but Grinder is not Null*)
					prepackedGrinderMismatch = If[prepackedQ && MatchQ[unresolvedGrinder, Except[Null | Automatic]], True, False];

					(* flip an error switch if:
						 Grind is False but Grinder is not Null or Automatic
						 OR
						 Grind is True but Grinder is Null *)
					grindGrinderMismatch = If[
						Or[
							grindQ && NullQ[unresolvedGrinder],
							!grindQ && MatchQ[unresolvedGrinder, Except[Null|Automatic]]
						],
						True,
						False
					];

					(*Resolve Fineness*)
					{fineness, finenessChangedQ} = Switch[{grindQ, unresolvedFineness},
						(* if Grind is False, Fineness is Null *)
						{False, Automatic},
							{Null, False},

						(* if Grind is True and specified Fineness Automatic, resolve to default *)
						{True, Automatic},
							{1 Millimeter, False},

						(* if Grind is True but Fineness is Null, it's an error state; set it to default *)
						{True, Null},
							{1 Millimeter, True},

						(* no need to change the value in other cases:
							{False, Except[Automatic]}: error state; won't go to Grind resolver;
							{True, Except[Automatic}: handled by ExperimentGrind resolver. *)
						{_, _},
							{unresolvedFineness, False}
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but Fineness is not Null*)
					prepackedFinenessMismatch = If[prepackedQ && MatchQ[unresolvedFineness, Except[Null|Automatic]], True, False];

					(* flip an error switch if:
						 Grind is False but Fineness is not Null or Automatic
						 OR
						 Grind is True but Fineness is Null *)
					grindFinenessMismatch = If[
						Or[
							grindQ && NullQ[unresolvedFineness],
							!grindQ && MatchQ[unresolvedFineness, Except[Null|Automatic]]
						],
						True,
						False
					];

					(*Resolve BulkDensity*)
					{bulkDensity, bulkDensityChangedQ} = Switch[{grindQ, unresolvedBulkDensity},
						(* if Grind is False, BulkDensity is Null *)
						{False, Automatic},
							{Null, False},

						(* if Grind is True and specified BulkDensity Automatic, resolve to default *)
						{True, Automatic},
							{1 Gram / Milliliter, False},

						(* if Grind is True but BulkDensity is Null, it's an error state; set it to default *)
						{True, Null},
							{1 Gram / Milliliter, True},

						(* no need to change the value in other cases:
							{False, Except[Automatic]}: error state; won't go to Grind resolver;
							{True, Except[Automatic}: handled by ExperimentGrind resolver. *)
						{_, _},
							{unresolvedBulkDensity, False}
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but BulkDensity is not Null*)
					prepackedBulkDensityMismatch = If[prepackedQ && MatchQ[unresolvedBulkDensity, Except[Null|Automatic]], True, False];

					(* flip an error switch if:
						 Grind is False but BulkDensity is not Null or Automatic
						 OR
						 Grind is True but BulkDensity is Null *)
					grindBulkDensityMismatch = If[
						Or[
							grindQ && NullQ[unresolvedBulkDensity],
							!grindQ && MatchQ[unresolvedBulkDensity, Except[Null|Automatic]]
						],
						True,
						False
					];

					(*Resolve GrindingContainer*)
					{grindingContainer, grindingContainerChangedQ} = Switch[{grindQ, unresolvedGrindingContainer},
						(* if Grind is False, GrindingContainer is Null *)
						{False, Automatic},
							{Null, False},

						(* if Grind is True but GrindingContainer is Null, it's an error state; set it to Automatic to be resolved by Grind resolver *)
						{True, Null},
							{Automatic, True},

						(* no need to change the value in other cases:
							{False, Except[Automatic]}: error state; won't go to Grind resolver;
							{True, Automatic | Except[Automatic}: handled by ExperimentGrind resolver. *)
						{_, _},
							{unresolvedGrindingContainer, False}
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but GrindingContainer is not Null*)
					prepackedGrindingContainerMismatch = If[prepackedQ && MatchQ[unresolvedGrindingContainer, Except[Null | Automatic]], True, False];

					(* flip an error switch if:
						 Grind is False but GrindingContainer is not Null or Automatic
						 OR
						 Grind is True but GrindingContainer is Null *)
					grindGrindingContainerMismatch = If[
						Or[
							grindQ && NullQ[unresolvedGrindingContainer],
							!grindQ && MatchQ[unresolvedGrindingContainer, Except[Null|Automatic]]
						],
						True,
						False
					];

					(*Resolve GrindingBead*)
					grindingBead = If[
						!grindQ && MatchQ[unresolvedGrindingBead, Automatic],
						Null,
						unresolvedGrindingBead
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but GrindingBead is not Null*)
					prepackedGrindingBeadMismatch = If[prepackedQ && MatchQ[unresolvedGrindingBead, Except[Null | Automatic]], True, False];

					(*flip an error switch if Grind is False but GrindingBead is not Null*)
					grindGrindingBeadMismatch = If[!grindQ && MatchQ[unresolvedGrindingBead, Except[Null | Automatic]], True, False];

					(*Resolve NumberOfGrindingBeads*)
					numberOfGrindingBeads = If[
						!grindQ && MatchQ[unresolvedNumberOfGrindingBeads, Automatic],
						Null,
						unresolvedNumberOfGrindingBeads
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but NumberOfGrindingBeads is not Null*)
					prepackedNumberOfGrindingBeadsMismatch = If[prepackedQ && MatchQ[unresolvedNumberOfGrindingBeads, Except[Null | Automatic]], True, False];

					(*flip an error switch if the sample is Grind is False but NumberOfGrindingBeads is not Null*)
					grindNumberOfGrindingBeadsMismatch = If[!grindQ && MatchQ[unresolvedNumberOfGrindingBeads, Except[Null | Automatic]], True, False];

					(* Resolve GrindingRate *)
					{grindingRate, grindingRateChangedQ} = Switch[{grindQ, unresolvedGrindingRate},
						(* if Grind is False, GrindingRate is Null *)
						{False, Automatic},
							{Null, False},

						(* if Grind is True but GrindingRate is Null, it's an error state; set it to Automatic to be resolved by Grind resolver *)
						{True, Null},
							{Automatic, True},

						(* no need to change the value in other cases:
							{False, Except[Automatic]}: error state; won't go to Grind resolver;
							{True, Automatic | Except[Automatic}: handled by ExperimentGrind resolver. *)
						{_,_},
							{unresolvedGrindingRate, False}
					];

					(* flip an error switch if the sample is prepacked in a melting point capillary but GrindingRate is not Null *)
					prepackedGrindingRateMismatch = If[prepackedQ && MatchQ[unresolvedGrindingRate, Except[Null | Automatic]], True, False];

					(* flip an error switch if:
					 	Grind is False but GrindingRate is not Null or Automatic
					 	OR
					 	Grind is True but GrindingRate is Null *)
					grindGrindingRateMismatch = If[
						Or[
							grindQ && NullQ[unresolvedGrindingRate],
							!grindQ && MatchQ[unresolvedGrindingRate, Except[Null|Automatic]]
						],
						True,
						False
					];

					(* Resolve GrindingTime *)
					{grindingTime, grindingTimeChangedQ} = Switch[{grindQ, unresolvedGrindingTime},
						(* if Grind is False, GrindingTime is Null *)
						{False, Automatic},
							{Null, False},

						(* if Grind is True but GrindingTime is Null, it's an error state; set it to Automatic to be resolved by Grind resolver *)
						{True, Null},
							{Automatic, True},

						(* no need to change the value in other cases:
							{False, Except[Automatic]}: error state; won't go to Grind resolver;
							{True, Automatic | Except[Automatic}: handled by ExperimentGrind resolver. *)
						{_,_},
							{unresolvedGrindingTime, False}
					];

					(* flip an error switch if the sample is prepacked in a melting point capillary but GrindingTime is not Null *)
					prepackedGrindingTimeMismatch = If[prepackedQ && MatchQ[unresolvedGrindingTime, Except[Null | Automatic]], True, False];


					(* flip an error switch if:
						Grind is False but GrindingTime is not Null or Automatic
						OR
						Grind is True but GrindingTime is Null *)
					grindGrindingTimeMismatch = If[
						Or[
							grindQ && NullQ[unresolvedGrindingTime],
							!grindQ && MatchQ[unresolvedGrindingTime, Except[Null|Automatic]]
						],
						True,
						False
					];

					(*Resolve NumberOfGrindingSteps*)
					{numberOfGrindingSteps, numberOfGrindingStepsChangedQ} = Switch[{grindQ, unresolvedNumberOfGrindingSteps},
						(* if Grind is False, NumberOfGrindingSteps is Null *)
						{False, Automatic},
							{Null, False},

						(* if Grind is True but NumberOfGrindingSteps is Null, it's an error state; set it to Automatic to be resolved by Grind resolver *)
						{True, Null},
							{Automatic, True},

						(* no need to change the value in other cases:
							{False, Except[Automatic]}: error state; won't go to Grind resolver;
							{True, Automatic | Except[Automatic}: handled by ExperimentGrind resolver. *)
						{_,_},
							{unresolvedNumberOfGrindingSteps, False}
					];

					(* flip an error switch if the sample is prepacked in a melting point capillary but NumberOfGrindingSteps is not Null *)
					prepackedNumberOfGrindingStepsMismatch = If[prepackedQ && MatchQ[unresolvedNumberOfGrindingSteps, Except[Null | Automatic]], True, False];


					(* flip an error switch if:
						Grind is False but NumberOfGrindingSteps is not Null or Automatic
						OR
						Grind is True but NumberOfGrindingSteps is Null *)
					grindNumberOfGrindingStepsMismatch = If[
						Or[
							grindQ && NullQ[unresolvedNumberOfGrindingSteps],
							!grindQ && MatchQ[unresolvedNumberOfGrindingSteps, Except[Null|Automatic]]
						],
						True,
						False
					];

					(*Resolve CoolingTime*)
					coolingTime = If[
						!grindQ && MatchQ[unresolvedCoolingTime, Automatic],
						Null,
						unresolvedCoolingTime
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but CoolingTime is not Null*)
					prepackedCoolingTimeMismatch = If[prepackedQ && MatchQ[unresolvedCoolingTime, Except[Null|Automatic]], True, False];

					(*flip an error switch if Grind is False but CoolingTime is not Null*)
					grindCoolingTimeMismatch = If[!grindQ && MatchQ[unresolvedCoolingTime, Except[Null|Automatic]], True, False];

					(*Resolve GrindingProfile*)
					{grindingProfile, grindingProfileChangesQ} = Switch[{grindQ, unresolvedGrindingProfile},
						(* if Grind is False, GrindingProfile is Null *)
						{False, Automatic},
							{Null, False},

						(* if Grind is True but GrindingProfile is Null, it's an error state; set it to Automatic to be resolved by Grind resolver *)
						{True, Null},
							{Automatic, True},

						(* no need to change the value in other cases:
							{False, Except[Automatic]}: error state; won't go to Grind resolver;
							{True, Automatic | Except[Automatic}: handled by ExperimentGrind resolver. *)
						{_,_},
							{unresolvedGrindingProfile, False}
					];

					(* flip an error switch if the sample is prepacked in a melting point capillary but GrindingProfile is not Null *)
					prepackedGrindingProfileMismatch = If[prepackedQ && MatchQ[unresolvedGrindingProfile, Except[Null|Automatic]], True, False];


					(* flip an error switch if:
						Grind is False but GrindingProfile is not Null or Automatic
						OR
						Grind is True but GrindingProfile is Null *)
					grindGrindingProfileMismatch = If[
						Or[
							grindQ && NullQ[unresolvedGrindingProfile],
							!grindQ && MatchQ[unresolvedGrindingProfile, Except[Null|Automatic]]
						],
						True,
						False
					];
					(*End of Grind-Related options*)


					(*Resolve ExpectedMeltingPoint: If it is not specified, automatically set to the MP of the dominant component*)
					(*Extract composition components that have amounts that indicate they are solid.
					If there is no composition, then massComponents is Null;
					if Composition has only one component, then massComponents is that single component*)
					massComponents = Which[
						MatchQ[samplePacket[Composition], Null | {Null} | {{Null}} | {} | {{}}], Null,
						Length[samplePacket[Composition]] == 1, samplePacket[Composition][[All, {1, 2}]],
						Length[samplePacket[Composition]] > 1, Cases[samplePacket[Composition], {MassPercentP | MassConcentrationP, ObjectP[], _}][[All, {1, 2}]]
					];

					(*Sort components based on amount. if massComponents is Null, sortedComponents is Null*)
					sortedComponents = If[MatchQ[massComponents, Null | {}], Null, Sort[massComponents]];

					(*Extract the Identity Model: If length of *)
					dominantComponent = If[MatchQ[sortedComponents, Null], Null, Download[Last[sortedComponents][[2]], Object]];
					dominantComponentMeltingPoint = fastAssocLookup[fastAssoc, dominantComponent, MeltingPoint];
					dominantComponentBoilingPoint = fastAssocLookup[fastAssoc, dominantComponent, BoilingPoint];

					expectedMeltingPoint = Which[
						MatchQ[unresolvedExpectedMeltingPoint, Except[Automatic]],
							unresolvedExpectedMeltingPoint,

						(*Set expectedMeltingPoint to SamplePacket's MeltingPoint if it is informed*)
						And[
							MatchQ[unresolvedExpectedMeltingPoint, Automatic],
							!NullQ[Download[samplePacket, MeltingPoint]],
							Download[samplePacket, MeltingPoint] >= 25.1Celsius,
							Download[samplePacket, MeltingPoint] <= availableMaxTemperature
						],
							N[Round[Download[samplePacket, MeltingPoint], Rationalize[0.1]]],

						(*Set expectedMeltingPoint to the dominant component's MeltingPoint if it is informed*)
						And[
							MatchQ[unresolvedExpectedMeltingPoint, Automatic],
							TemperatureQ[dominantComponentMeltingPoint],
							dominantComponentMeltingPoint >= 25.1Celsius,
							dominantComponentMeltingPoint <= availableMaxTemperature
						],
							N[Round[fastAssocLookup[fastAssoc, dominantComponent, MeltingPoint], Rationalize[0.1]]],

						(*Otherwise set expectedMeltingPoint Unknown*)
						True,
							Unknown
					];

					(*Invalid ExpectedMeltingPoint option*)
					invalidExpectedMeltingPoint = If[
						expectedMeltingPoint < 25.1Celsius || expectedMeltingPoint >= availableMaxTemperature,
						True,
						False
					];


					(*Resolve NumberOfReplicates*)
					numberOfReplicates = Which[
						MatchQ[unresolvedNumberOfReplicates, Except[Automatic]], unresolvedNumberOfReplicates,
						MatchQ[unresolvedNumberOfReplicates, Automatic] && prepackedQ, Null,
						True, 3
					];

					(* flip a switch if NumberOfReplicates is greater than the available number of capillary slots *)
					highNumberOfReplicates = !prepackedQ && GreaterQ[numberOfReplicates /. Null -> 1, availableMaxSlot];

					(* flip a switch if the sample is prepacked and NumberOfReplicates is not Null *)
					invalidNumberOfReplicates = prepackedQ && !MatchQ[numberOfReplicates, Null];

					(*Resolve StartTemperature*)
					unroundedStartTemperature = Which[
						MatchQ[unresolvedStartTemperature, Except[Automatic]],
							unresolvedStartTemperature,
						MatchQ[unresolvedStartTemperature, Automatic] && MatchQ[expectedMeltingPoint, TemperatureP],
							Max[expectedMeltingPoint - Quantity[5, "DegreesCelsiusDifference"], 25Celsius],
						True,
							40Celsius
					];

					(*Convert unit to TemperatureUnit*)
					convertedStartTemperature = UnitConvert[unroundedStartTemperature, temperatureUnit];

					(*round StartTemperature to 1 decimal place*)
					startTemperature = N[Round[convertedStartTemperature, Rationalize[0.1]]];

					(*Resolve EndTemperature*)
					unroundedEndTemperature = Which[
						MatchQ[unresolvedEndTemperature, Except[Automatic]],
							unresolvedEndTemperature,
						MatchQ[unresolvedEndTemperature, Automatic] && MatchQ[expectedMeltingPoint, TemperatureP],
							Min[expectedMeltingPoint + Quantity[5, "DegreesCelsiusDifference"], availableMaxTemperature],
						True,
							300Celsius
					];

					(*Convert unit to TemperatureUnit*)
					convertedEndTemperature = UnitConvert[unroundedEndTemperature, temperatureUnit];

					(*round StartTemperature to 1 decimal place*)
					endTemperature = N[Round[convertedEndTemperature, Rationalize[0.1]]];

					(* flip an error switch if EndTemperature is greater than the available max temperature *)
					invalidEndTemperature = GreaterQ[endTemperature, availableMaxTemperature];

					(* flip an error switch if startTemperature is greater than or equal to endTemperature *)
					invalidStartEndTemperature = GreaterEqualQ[startTemperature, endTemperature];

					(*Resolve SealCapillary*)
					sealCapillary = Which[

						MatchQ[unresolvedSealCapillary, Except[Automatic]],
							unresolvedSealCapillary,

						And[
							MatchQ[unresolvedSealCapillary, Automatic],
							!NullQ[Download[samplePacket, BoilingPoint]],
							Download[samplePacket, BoilingPoint] - Quantity[20, "DegreesCelsiusDifference"] < endTemperature
						],
							True,

						(*Set SealCapillary to True if the dominant component's BoilingPoint is informed and it is less than 20C greater than the EndTemperature*)
						And[
							MatchQ[unresolvedSealCapillary, Automatic],
							TemperatureQ[dominantComponentBoilingPoint],
							dominantComponentBoilingPoint - Quantity[20, "DegreesCelsiusDifference"] < endTemperature
						],
							True,

						True,
							False
					];

					(*Resolve RampTime and TemperatureRampRate. These two are related to each other, so should be resolved together*)
					(*Is RampTime specified by user or not?*)
					rampTimeQ = MatchQ[unresolvedRampTime, Except[Automatic]];

					(*Is TemperatureRampRate specified by user or not?*)
					rampRateQ = MatchQ[unresolvedTemperatureRampRate, Except[Automatic]];

					(*If rampTimeQ is True, calculate TemperatureRampRate. In this case it doesn't matter
					 what TemperatureRampRate is set to. will throw a Warning if we change a specified TemperatureRampRate*)
					unroundedTemperatureRampRate = If[rampTimeQ,
						Max[(endTemperature - startTemperature) / unresolvedRampTime, 0.1 Celsius/Minute],
						Which[
							MatchQ[unresolvedTemperatureRampRate, Except[Automatic]], unresolvedTemperatureRampRate,
							MatchQ[unresolvedTemperatureRampRate, Automatic] && MatchQ[expectedMeltingPoint, Unknown], 10Celsius / Minute,
							MatchQ[unresolvedTemperatureRampRate, Automatic] && MatchQ[expectedMeltingPoint, TemperatureP], 1Celsius / Minute
						]
					];

					(*Convert unit to TemperatureUnit/Minute*)
					convertedTemperatureRampRate = UnitConvert[unroundedTemperatureRampRate, temperatureUnit / Minute];

					(*round TemperatureRampRate to 1 decimal place*)
					temperatureRampRate = N[Round[convertedTemperatureRampRate, Rationalize[0.1]]];

					(*Resolve RampTime*)
					(*calculate unrounded RampTime.*)
					rampTime = If[rampTimeQ, unresolvedRampTime,
						(endTemperature - startTemperature) / temperatureRampRate
					];

					(*flip an error switch if both TemperatureRampRate and RampTime are specified by user and we changed TemperatureRampRate*)
					rampRateChangeWarning = If[
						rampTimeQ && rampRateQ &&
							!EqualQ[unroundedTemperatureRampRate, unresolvedTemperatureRampRate],
						True, False
					];

					{
						(*1*)orderOfOperations,
						expectedMeltingPoint,
						numberOfReplicates,
						amount,
						preparedSampleLabel,
						grindQ,
						grinderType,
						grinder,
						fineness,
						bulkDensity,
						(*11*)grindingContainer,
						grindingBead,
						numberOfGrindingBeads,
						grindingRate,
						grindingTime,
						numberOfGrindingSteps,
						coolingTime,
						grindingProfile,
						desiccateQ,
						sampleContainer,
						(*21*)sealCapillary,
						startTemperature,
						equilibrationTime,
						endTemperature,
						temperatureRampRate,
						rampTime,
						unresolvedPreparedSampleStorageCondition,
						unresolvedCapillaryStorageCondition,
						invalidOrderOfOperations,
						invalidExpectedMeltingPoint,
						(*31*)invalidStartEndTemperature,
						rampRateChangeWarning,
						amountStorageConditionMismatch,
						invalidNumberOfReplicates,
						prepackedQ,
						desiccatePrepackedMismatch,
						grindPrepackedMismatch,
						grindGrinderTypeMismatch,
						prepackedGrinderTypeMismatch,
						prepackedGrinderMismatch,
						(*41*)grindGrinderMismatch,
						prepackedFinenessMismatch,
						grindFinenessMismatch,
						prepackedBulkDensityMismatch,
						grindBulkDensityMismatch,
						prepackedGrindingContainerMismatch,
						grindGrindingContainerMismatch,
						prepackedGrindingBeadMismatch,
						grindGrindingBeadMismatch,
						prepackedNumberOfGrindingBeadsMismatch,
						(*51*)grindNumberOfGrindingBeadsMismatch,
						prepackedGrindingRateMismatch,
						grindGrindingRateMismatch,
						prepackedGrindingTimeMismatch,
						grindGrindingTimeMismatch,
						prepackedNumberOfGrindingStepsMismatch,
						grindNumberOfGrindingStepsMismatch,
						prepackedCoolingTimeMismatch,
						grindCoolingTimeMismatch,
						prepackedGrindingProfileMismatch,
						(*61*)grindGrindingProfileMismatch,
						prepackedSampleContainerMismatch,
						desiccateSampleContainerMismatch,
						sampleLabel,
						amountPrepackedMismatch,
						sampleContainerLabel,
						amountDesiccateMismatch,
						amountGrindMismatch,
						unresolvedGrindingRate,
						unresolvedGrindingTime,
						(*71*)orderMismatch,
						unresolvedGrinderType,
						unresolvedGrinder,
						unresolvedFineness,
						unresolvedBulkDensity,
						unresolvedGrindingContainer,
						unresolvedNumberOfGrindingSteps,
						unresolvedGrindingProfile,
						grinderTypeChangeQ,
						grinderChangedQ,
						(*81*)finenessChangedQ,
						bulkDensityChangedQ,
						grindingContainerChangedQ,
						grindingRateChangedQ,
						grindingTimeChangedQ,
						numberOfGrindingStepsChangedQ,
						grindingProfileChangesQ,
						amountChangedQ,
						invalidPreparedSampleStorageCondition,
						invalidEndTemperature,
						(*91*)highNumberOfReplicates
					}
				]
			],
			{samplePackets, modelPackets, mapThreadFriendlyOptions, sampleContainerPackets, sampleContainerModelPackets}
		]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(*------------------------------------------*)
	(*------------------------------------------*)
	(*--- Overall Sample-prep related Errors ---*)
	(*------------------------------------------*)
	(*------------------------------------------*)
	(* since Desiccate and Grind resolvers are run and they throw errors on the fly, here Overall sample-prep related errors are thrown for better organizing purposes *)

	(* define some variables *)
	(* Desiccate-related options *)

	(*Non-index matching option names that are use in this experiment for Desiccate*)
	singletonDesiccateOptionNames = {Desiccant, DesiccantAmount, DesiccantPhase, Desiccator, DesiccationTime, DesiccantStorageContainer, DesiccantStorageCondition, DesiccationMethod, CheckDesiccant};

	(*Index matching option names that are use in this experiment for Desiccate*)
	multipleDesiccateOptionNames = {SampleContainer};

	(* all desiccate options combined *)
	allDesiccateOptionNames = Flatten[{singletonDesiccateOptionNames, multipleDesiccateOptionNames}];

	(* Grind-related options *)
	grindOptionNames = {
		GrinderType, Grinder, Fineness, BulkDensity, GrindingContainer,
		GrindingBead, NumberOfGrindingBeads, GrindingRate, GrindingTime, NumberOfGrindingSteps,
		CoolingTime, GrindingProfile
	};

	(* Amount should be added to GrindOptionsNames to be used for ExperimentGrind *)
	grindOptionNamesWithAmount = Flatten[{Amount, grindOptionNames}];

	(* general sample preparation options *)
	samplePreparationOptionNames = {Amount, OrderOfOperations, PreparedSampleStorageCondition};
	singleTrueRequiredSamplePreparationOptionNames = {Amount};
	doubleTrueRequiredSamplePreparationOptionNames = {Amount, OrderOfOperations};

	(* combine all options *)
	allOptionNames = DeleteDuplicates[Flatten[{singletonDesiccateOptionNames, multipleDesiccateOptionNames, grindOptionNames}]];
	allMultipleOptionNames = DeleteDuplicates[Flatten[{samplePreparationOptionNames, multipleDesiccateOptionNames, grindOptionNames}]];

	(* required Desiccate-related options when Desiccate is True *)
	requiredDesiccateSingletonOptionNames = {DesiccationMethod, Desiccator, DesiccationTime};
	requiredDesiccateMultipleOptionNames = {Amount};

	(* required Grind-related options when Grind is True *)
	requiredGrindOptionNames = {
		GrinderType, Grinder, Amount, Fineness, BulkDensity, GrindingContainer,
		GrindingRate, GrindingTime, NumberOfGrindingSteps, GrindingProfile
	};

	(* are all samples in capillaries? *)
	allPrepackedQ = And@@prepackedQs;

	(* if Desiccate is set to True by the user but the sample is prepacked, realDesiccateQs should be False *)
	realDesiccateQs = MapThread[And, {desiccateQs, Not /@ prepackedQs}];

	(* if Grind is set to True by the user but the sample is prepacked, realGrindQs should be False *)
	realGrindQs = MapThread[And, {grindQs, Not /@ prepackedQs}];

	(* does the sample go through any of Desiccate or Grind steps? *)
	prepareQs = MapThread[#1 || #2&, {desiccateQs, grindQs}];

	(* is Desiccate False for all samples *)
	noDesiccateQ = !Or@@realDesiccateQs;

	(* is Grind False for all samples *)
	noGrindQ = !Or@@realGrindQs;


	(*--------------------------*)
	(*--------------------------*)
	(*--- High-Level Error 1 ---*)
	(*--------------------------*)
	(*--------------------------*)
	(* if all samples are prepacked or Desiccate and Grind are False for all samples, no Desiccate or Grind options should be set. Throw an error if otherwise *)
	(* find options that are not Automatic or Null when all samples are prepacked, or Desiccate or Grind is False for all samples *)
	(* unneeded Desiccate options due to all samples being prepacked *)
	prepackedDesiccateUnneededOptions = If[allPrepackedQ,
		Join[
			If[Or@@desiccateQs, {Desiccate}, {}],
			PickList[allDesiccateOptionNames, Lookup[measureMeltingPointOptions, allDesiccateOptionNames], Except[ListableP[Automatic | Null]]]
		],
		{}
	];

	(* unneeded Grind options due to all samples being prepacked *)
	prepackedGrindUnneededOptions = If[allPrepackedQ,
		Join[
			If[Or@@grindQs, {Grind}, {}],
			PickList[grindOptionNames, Lookup[measureMeltingPointOptions, grindOptionNames], Except[ListableP[Automatic | Null]]]
		],
		{}
	];

	(* unneeded sample prep options due to all samples being prepacked *)
	prepackedSamplePrepUnneededOptions = If[allPrepackedQ,
		PickList[samplePreparationOptionNames, Lookup[measureMeltingPointOptions, samplePreparationOptionNames], Except[ListableP[Automatic | Null]]],
		{}
	];

	(* combine all prepacked error options *)
	allPrepackedErrorOptions = DeleteDuplicates[Flatten[{prepackedSamplePrepUnneededOptions, prepackedDesiccateUnneededOptions, prepackedGrindUnneededOptions}]];

	(* unneeded Desiccate options due to Desiccate being False for all samples *)
	noDesiccateUnneededOptions = If[noDesiccateQ,
		PickList[allDesiccateOptionNames, Lookup[measureMeltingPointOptions, allDesiccateOptionNames], Except[ListableP[Automatic | Null]]],
		{}
	];

	(* unneeded Grind options due to Grind being False for all samples *)
	noGrindUnneededOptions = If[noGrindQ,
		PickList[grindOptionNames, Lookup[measureMeltingPointOptions, grindOptionNames], Except[ListableP[Automatic | Null]]],
		{}
	];

	(* unneeded sample prep options due to all samples being prepacked *)
	noPrepUnneededOptions = If[noGrindQ && noDesiccateQ,
		PickList[samplePreparationOptionNames, Lookup[measureMeltingPointOptions, samplePreparationOptionNames], Except[ListableP[Automatic | Null]]],
		{}
	];

	(* combine all no-prep error options *)
	allNoPrepErrorOptions = DeleteDuplicates[Flatten[{noPrepUnneededOptions, noDesiccateUnneededOptions, noGrindUnneededOptions}]];


	(* if we throw this high level error, no other desiccate/grind-related errors should be thrown *)
	prepackedDesiccateMessageQ = !MatchQ[prepackedDesiccateUnneededOptions,{}];
	prepackedGrindMessageQ = !MatchQ[prepackedGrindUnneededOptions,{}];
	prepackedPrepMessageQ = !MatchQ[prepackedSamplePrepUnneededOptions,{}];
	noDesiccateMessageQ = !MatchQ[noDesiccateUnneededOptions,{}];
	noGrindMessageQ = !MatchQ[noGrindUnneededOptions,{}];
	noPrepMessageQ = !MatchQ[noPrepUnneededOptions,{}];

	(* if all samples are prepacked or Desiccate and Grind are False for all samples, no Desiccate or Grind options should be set. Throw an error if otherwise *)
	noPrepTests = Switch[{prepackedDesiccateMessageQ || prepackedPrepMessageQ, prepackedGrindMessageQ || prepackedPrepMessageQ, noDesiccateMessageQ || noPrepMessageQ, noGrindMessageQ || noPrepMessageQ},

		(* if the sample is prepacked but Desiccate or Grind is True or Desiccate-/Grind-related options are specified, throw an error *)
		{True, _, _, _} | {_, True, _, _},
			If[messages,
				Message[
					Error::UnusedOptions,
						If[MatchQ[DeleteCases[allPrepackedErrorOptions, Desiccate | Grind], {}],
							"All input samples are in capillaries, therefore, they cannot be desiccated and/or ground. Please set Desiccate and Grind to False for all samples.",
							"All input samples are in capillaries, therefore, they cannot be desiccated and/or ground. Please set Desiccate and Grind to False and set the following options to Null or leave them unspecified to be calculated automatically: " <> ObjectToString[DeleteCases[allPrepackedErrorOptions, Desiccate | Grind]] <> "."
						]
					]
			];
			If[gatherTests,
				Test["If all samples are prepacked, Desiccate and Grind are False and no Desiccate- and Grind-related options are specified:", True, MatchQ[allPrepackedErrorOptions,{}]],
				{}
			],

		(* If not all samples are prepacked and Desiccate/Grind are False for all samples but Desiccate-/Grind-related options are specified, throw an error *)
		{_, _, True, True},
			If[messages,
				Message[
					Error::UnusedOptions,
					"Desiccate and Grind are set to False, therefore, no desiccation or grinding options should be specified. Please set Desiccate or Grind to True or set the following options to Null or leave them unspecified to be calculated automatically: " <> ObjectToString[allNoPrepErrorOptions] <> "."
				]
			];
			If[gatherTests,
				Test["No Desiccate- and Grind-related options are specified when Desiccate and Grind are both False:", True, MatchQ[allNoPrepErrorOptions,{}]],
				{}
			],

		(* If not all samples are prepacked and Desiccate is False for all samples but Desiccate-related options are specified, throw an error *)
		{_, _, True, _},
			If[messages,
				Message[
					Error::UnusedOptions,
					"Desiccate is set to False, therefore, no desiccation options should be specified. Please set Desiccate to True or set the following options to Null or leave them unspecified to be calculated automatically: " <> ObjectToString[DeleteDuplicates[Flatten[{noDesiccateUnneededOptions}]]] <> "."
				]
			];
			If[gatherTests,
				Test["No Desiccate-related options are specified when Desiccate is False:", True, MatchQ[DeleteDuplicates[Flatten[{noDesiccateUnneededOptions}]],{}]],
				{}
			],

		(* If not all samples are prepacked and Grind is False for all samples but Grind-related options are specified, throw an error *)
		{_, _, _, True},
			If[messages,
				Message[
					Error::UnusedOptions,
					"Grind is set to False, therefore, no grinding options should be specified. Please set Grind to True or set the following options to Null or leave them unspecified to be calculated automatically: " <> ObjectToString[DeleteDuplicates[Flatten[{noGrindUnneededOptions}]]] <> "."
				]
			];
			If[gatherTests,
				Test["No Grind-related options are specified when Grind is False:", True, MatchQ[DeleteDuplicates[Flatten[{noGrindUnneededOptions}]],{}]],
				{}
			]
	];

	(*--------------------------*)
	(*--------------------------*)
	(*--- High-Level Error 2 ---*)
	(*--------------------------*)
	(*--------------------------*)
	(* if Desiccate is True for non-capillary samples, Desiccate-related singleton options should not be Null. Throw an error otherwise *)
	(* find options that are Null when all samples are prepacked, or Desiccate or Grind is False for all samples *)

	requiredSingletonDesiccateOptions = If[Or@@realDesiccateQs,
		PickList[requiredDesiccateSingletonOptionNames, Lookup[measureMeltingPointOptions, requiredDesiccateSingletonOptionNames], Null],
		{}
	];

	(* throw an error if any Desiccate-related singleton options have been set to Null when Desiccate is True for at least one sample *)
	If[messages && !MatchQ[requiredSingletonDesiccateOptions, {}],
		Message[
			Error::RequiredDesiccateOptions,
			"Desiccate is set to True for samples " <> ObjectToString[PickList[myInputSamples, realDesiccateQs]] <> ". Therefore, Desiccate-related options should be specified. Please set the following options to non-Null values or leave them unspecified to be calculated automatically: " <> ObjectToString[requiredSingletonDesiccateOptions] <> "."
		]
	];

	(* Define the tests the user will see for the above messages *)
	requiredSingletonDesiccateOptionTests = If[gatherTests,
		Test["If Desiccate is True for at least one sample that is not in a capillary, Desiccate-related options are specified.", True, MatchQ[requiredSingletonDesiccateOptions,{}]],
		Nothing
	];



	(*--------------------------*)
	(*--------------------------*)
	(*--- High-Level Error 3 ---*)
	(*--------------------------*)
	(*--------------------------*)
	(* check if prepacked status matches with Desiccate/Grind and other related options. throw errors for mismatches *)
	(*
		These are possible error cases:
			1. the sample is in a capillary, Desiccate/Grind is True, desiccate/grind-related options are not specified
			2. the sample is in a capillary, Desiccate/Grind is True or False, desiccate/grind-related options are specified
			3-5. the sample is not in capillary, Desiccate or Grind is True, desiccate/grind-related options are set to Null
			6-8. the sample is not in capillary, Desiccate or Grind is False, desiccate/grind-related options are specified
	 *)
	errorTuples = MapThread[
		Function[{prepackedQ, desiccateQ, grindQ, specifiedOptions},
			Switch[{prepackedQ, desiccateQ, grindQ},
				(* prepacked sample, with Desiccate or Grind -> True *)
				{True, True, _} | {True, _, True},
					With[{errorOptions = PickList[allMultipleOptionNames, Lookup[specifiedOptions, allMultipleOptionNames], Except[Automatic | Null]]},
						If[MatchQ[errorOptions, {}],
							(* error case1: if no Desiccate/Grind-related option is specified, throw an error about Desiccate/Grind not being False *)
							{{PickList[{Desiccate, Grind}, {desiccateQ, grindQ}]}, 1},
							(* error case2: if Desiccate/Grind-related option are specified, throw an error about Desiccate/Grind not being False and options being specified *)
							{errorOptions, 2}
						]
					],

				(* error case2: Desiccate/Grind are False but Desiccate/Grind-related option are specified, throw an error about options being specified *)
				{True, False, False},
					With[{errorOptions = PickList[allMultipleOptionNames, Lookup[specifiedOptions, allMultipleOptionNames], Except[Automatic | Null]]},
						{errorOptions, 2}
					],

				(* error case 3 *)
				(* in this case, we should make sure that the required options are not set to Null if Desiccate and Grind are True *)
				{False, True, True},
					Module[{errorOptions, optionsToLookup},
						optionsToLookup = DeleteDuplicates[Flatten[{requiredDesiccateMultipleOptionNames, requiredGrindOptionNames, doubleTrueRequiredSamplePreparationOptionNames}]];
						errorOptions = PickList[optionsToLookup, Lookup[specifiedOptions, optionsToLookup], Null];
						{errorOptions, 3}
					],

				{False, True, False},
					Module[{requiredErrorOptions, requiredOptionsToLookup, unneededErrorOptions, unneededOptionsToLookUp},
						(* error case 4: make sure that the required options are not set to Null if only Desiccate is True  *)
						requiredOptionsToLookup = DeleteDuplicates[Flatten[{requiredDesiccateMultipleOptionNames, singleTrueRequiredSamplePreparationOptionNames}]];
						requiredErrorOptions = PickList[requiredOptionsToLookup, Lookup[specifiedOptions, requiredOptionsToLookup], Null];
						(* error case 8: make sure that Grind-related options are not specified when Grind is False  *)
						unneededOptionsToLookUp = grindOptionNames;
						unneededErrorOptions = PickList[unneededOptionsToLookUp, Lookup[specifiedOptions, unneededOptionsToLookUp], Except[Automatic | Null]];
						{{requiredErrorOptions, 4}, {unneededErrorOptions, 8}}
					],

				{False, False, True},
					Module[{requiredErrorOptions, requiredOptionsToLookup, unneededErrorOptions, unneededOptionsToLookUp},
						(* error case 5: make sure that the required options are not set to Null if only Grind is True  *)
						requiredOptionsToLookup = DeleteDuplicates[Flatten[{requiredGrindOptionNames, singleTrueRequiredSamplePreparationOptionNames}]];
						requiredErrorOptions = PickList[requiredOptionsToLookup, Lookup[specifiedOptions, requiredOptionsToLookup], Null];
						(* error case 7: make sure that Desiccate-related options are not specified when Desiccate is False  *)
						unneededOptionsToLookUp = multipleDesiccateOptionNames;
						unneededErrorOptions = PickList[unneededOptionsToLookUp, Lookup[specifiedOptions, unneededOptionsToLookUp], Except[Automatic | Null]];
						{{requiredErrorOptions, 5}, {unneededErrorOptions, 7}}
					],

				(* error case 6: make sure that Desiccate/Grind-related options are not specified when both are False  *)
				{False, False, False},
					Module[{errorOptions, optionsToLookup},
						optionsToLookup = allMultipleOptionNames;
						errorOptions = PickList[optionsToLookup, Lookup[specifiedOptions, optionsToLookup], Except[Automatic | Null]];
						{errorOptions, 6}
					],

				(* other cases (if Any!) are not wrong; don't require error *)
				_,
					Nothing
			]
		],
		{prepackedQs, desiccateQs, grindQs, mapThreadFriendlyOptions}
	];

	(* extract data from the error tuples *)
	(* error codes that were thrown *)
	errorNumbers = Sort[DeleteDuplicates[Cases[Flatten[errorTuples], _Integer]]];

	(* rules that related each error options and error codes to each sample *)
	errorToSampleRules = MapThread[Rule, {errorTuples, myInputSamples}] /. Rule[list : {{_, _} ..}, obj__] :> Sequence @@ Map[Rule[#, obj] &, list];

	(* group samples with similar errors *)
	uniqueErrorAssociations = GroupBy[errorToSampleRules, First -> Last];

	(* convert the association to list *)
	uniqueErrorLists = List @@@ Normal[uniqueErrorAssociations];

	(* reformat error lists; bring the error code upfront to group error-samples tuples by error codes *)
	formattedErrorLists = Flatten[Cases[uniqueErrorLists, pairs : {{{__}, #}, inputSamples_} :> {pairs[[1, 2]], {Flatten[{pairs[[1, 1]]}], inputSamples}}]& /@ errorNumbers, 1];

	(* group error-samples tuples by error codes *)
	groupedErrorLists = GroupBy[formattedErrorLists, First -> Last];

	(* gather all options with errors *)
	desiccateGrindOptionMismatches = DeleteDuplicates[Intersection[Flatten[formattedErrorLists], Flatten[{Desiccate, Grind, allOptionNames}]]];

	(* throw error based on the error codes *)
	desiccateGrindOptionMismatchTests = If[
		Or[
			allPrepackedQ,
			noDesiccateQ && noGrindQ
		],
		{},
		MapThread[
			Module[{errorCode, optionSampleTuples, inputSamples},
				errorCode = #1;
				optionSampleTuples = #2;
				inputSamples = DeleteDuplicates[Flatten[optionSampleTuples[[All, 2]]]];
				Switch[errorCode,
					1,
						If[messages && !allPrepackedQ,
							Message[
								Error::UnusedOptions,
								"Samples " <> ObjectToString[inputSamples] <> " are in melting point capillaries, therefore, cannot be desiccated or ground. Please set both Desiccate and Grind to False for those sample(s)."
							]
						];
						If[gatherTests && !allPrepackedQ,
							{
								Test["Desiccate and Grind are False for " <> ObjectToString[Flatten[inputSamples]] <> " which are in melting point capillaries: ", True, False],
								Test["Desiccate and Grind are False for " <> ObjectToString[Complement[myInputSamples, inputSamples]] <> " which are in melting point capillaries: ", True, True]
							},
							{}
						],
					2,
						If[messages && !allPrepackedQ,
							Message[
								Error::UnusedOptions,
								"Sample(s) " <> ObjectToString[inputSamples] <> " are in melting point capillaries, therefore, cannot be desiccated or ground. Please set both Desiccate and Grind to False for those sample(s) and set the following options to Null or leave them unspecified to be calculated automatically: " <> ObjectToString[StringRiffle[StringRiffle[#, " for "]& /@ optionSampleTuples, "; "]] <> "."
							]
						];
						If[gatherTests && !allPrepackedQ,
							{
								Test["Desiccate- and Grind-related options are not specified for " <> ObjectToString[inputSamples] <> " which are in melting point capillaries: ", True, False],
								Test["Desiccate- and Grind-related options are not specified for " <> ObjectToString[Complement[myInputSamples, inputSamples]] <> " which are in melting point capillaries: ", True, True]
							},
							{}
						],
					3,
						If[messages,
							Message[
								Error::RequiredPreparationOptions,
								"Desiccate- and Grind-related options should be specified when Desiccate and Grind are True. Please set the following options to non-Null values or leave them unspecified to be calculated automatically: " <> StringRiffle[StringRiffle[#, " for "]& /@ optionSampleTuples, "; "] <> "."
							]
						];
						If[gatherTests,
							{
								Test["Desiccate and Grind are True for " <> ObjectToString[inputSamples] <> ", therefore, Desiccate- and Grind-related options are specified for those samples:", True, False],
								Test["Desiccate and Grind are True for " <> ObjectToString[Complement[myInputSamples, inputSamples]] <> ", therefore, Desiccate- and Grind-related options are specified for those samples:", True, True]
							},
							{}
						],
					4,
						If[messages,
							Message[
								Error::RequiredDesiccateOptions,
								"If Desiccate is set to True, Desiccate-related options should be specified. Please set the following options to non-Null values or leave them unspecified to be calculated automatically: " <> StringRiffle[StringRiffle[#, " for "]& /@ optionSampleTuples, "; "] <> "."
							]
						];
						If[gatherTests,
							{
								Test["Desiccate is True for " <> ObjectToString[inputSamples] <> ", therefore, Desiccate-related options are specified for those samples:", True, False],
								Test["Desiccate is True for " <> ObjectToString[Complement[myInputSamples, inputSamples]] <> ", therefore, Desiccate-related options are specified for those samples:", True, True]
							},
							{}
						],
					5,
						If[messages,
							Message[
								Error::RequiredGrindOptions,
								"If Grind is set to True, Grind-related options should be specified. Please set the following options to non-Null values or leave them unspecified to be calculated automatically: " <> StringRiffle[StringRiffle[#, " for "]& /@ optionSampleTuples, "; "] <> "."
							]
						];
						If[gatherTests,
							{
								Test["Grind is True for " <> ObjectToString[inputSamples] <> ", therefore, Grind-related options are specified for those samples:", True, False],
								Test["Grind is True for " <> ObjectToString[Complement[myInputSamples, inputSamples]] <> ", therefore, Grind-related options are specified for those samples:", True, True]
							},
							{}
						],
					6,
					If[messages && !allPrepackedQ && !noDesiccateQ && !noGrindQ,
						Message[
							Error::UnusedOptions,
							"If Desiccate and Grind are set to False, Desiccate- and Grind-related options should be Null. Please set the following options to Null or leave them unspecified to be calculated automatically: " <> StringRiffle[StringRiffle[#, " for "]& /@ optionSampleTuples, "; "] <> "."
						]
					];
					If[gatherTests && !allPrepackedQ && !noDesiccateQ && !noGrindQ,
						{
							Test["Desiccate is set to False for samples " <> ObjectToString[inputSamples] <> ". Therefore, Desiccate-related options are Null for those samples: ", True, False],
							Test["Desiccate is set to False for samples " <> ObjectToString[Complement[myInputSamples, inputSamples]] <> ". Therefore, Desiccate-related options are Null for those samples: ", True, True]
						},
						{}
					],
					7,
						If[messages && !allPrepackedQ && !noDesiccateQ,
							Message[
								Error::UnusedOptions,
								"If Desiccate is set to False, Desiccate-related options should be Null. Please set the following options to Null or leave them unspecified to be calculated automatically: " <> StringRiffle[StringRiffle[#, " for "]& /@ optionSampleTuples, "; "] <> "."
							]
						];
						If[gatherTests && !allPrepackedQ && !noDesiccateQ,
							{
								Test["Desiccate is set to False for samples " <> ObjectToString[inputSamples] <> ". Therefore, Desiccate-related options are Null for those samples: ", True, False],
								Test["Desiccate is set to False for samples " <> ObjectToString[Complement[myInputSamples, inputSamples]] <> ". Therefore, Desiccate-related options are Null for those samples: ", True, True]
							},
							{}
						],
					8,
						If[messages && !allPrepackedQ && !noGrindQ,
							Message[
								Error::UnusedOptions,
								"If Grind is set to False, Grind-related options should be Null. Please set the following options to Null or leave them unspecified to be calculated automatically: " <> StringRiffle[StringRiffle[#, " for "]& /@ optionSampleTuples, "; "] <> "."
							]
						];
						If[gatherTests && !allPrepackedQ && !noGrindQ,
							{
								Test["Grind is set to False for samples " <> ObjectToString[inputSamples] <> ". Therefore, Grind-related options are Null for those samples: ", True, False],
								Test["Grind is set to False for samples " <> ObjectToString[Complement[myInputSamples, inputSamples]] <> ". Therefore, Grind-related options are Null for those samples: ", True, True]
							},
							{}
						]
				]
			]&,
			{Keys[groupedErrorLists], Values[groupedErrorLists] /. sample:ObjectP[Object[Sample]] :> ObjectToString[sample]}
		]
	];


	(*throw an error if OrderOfOperations does not match Grind and Desiccate options*)
	orderOptionMismatches = If[MemberQ[orderMismatches, True] && messages,
		(
			Message[
				Error::OrderOfOperationsMismatch,
				ObjectToString[PickList[resolvedOrderOfOperations, orderMismatches], Cache -> cacheBall],
				ObjectToString[PickList[simulatedSamples, orderMismatches], Cache -> cacheBall]
			];
			{OrderOfOperations}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	orderOptionMismatchTests = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, orderMismatches];
			passingInputs = PickList[simulatedSamples, orderMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["OrderOfOperations matches Grind and Desiccate for samples " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["OrderOfOperations matches Grind and Desiccate for samples " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but NumberOfReplicates is not Null*)
	numberOfReplicatesMismatchedOptions = If[MemberQ[invalidNumbersOfReplicates, True] && messages,
		(
			Message[
				Error::InvalidNumberOfReplicates,
				ObjectToString[PickList[simulatedSamples, invalidNumbersOfReplicates], Cache -> cacheBall]
			];
			{NumberOfReplicates}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	numberOfReplicatesMismatchedTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, invalidNumbersOfReplicates];
			passingInputs = PickList[simulatedSamples, invalidNumbersOfReplicates, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, NumberOfReplicates is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, NumberOfReplicates is Null for the following samples: " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* throw an error if PreparedSampleStorageCondition is resolved to Null for any samples *)
	invalidPreparedSampleStorageConditionsOptions = If[MemberQ[invalidPreparedSampleStorageConditions, True] && messages,
		(
			Message[
				Error::InvalidPreparedSampleStorageCondition,
				ObjectToString[PickList[simulatedSamples, invalidPreparedSampleStorageConditions], Cache -> cacheBall]];
			{PreparedSampleStorageCondition}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	invalidPreparedSampleStorageConditionsTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, invalidPreparedSampleStorageConditions];
			passingInputs = PickList[simulatedSamples, invalidPreparedSampleStorageConditions, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " have a valid PreparedSampleStorageCondition.", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " have a valid PreparedSampleStorageCondition.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];


	(*---------------------------------*)
	(*---------------------------------*)
	(*--- Resolve Desiccate options ---*)
	(*---------------------------------*)
	(*---------------------------------*)

	(*resolve singleton options: If Desiccate is True, Desiccate options will resolve by ExperimentDesiccate.
	Here, Desiccate-related options are resolved only if Desiccate is False*)

	(*Resolve DesiccationMethod*)
	{desiccationMethod, desiccationMethodChangedQ} = Switch[{Or@@realDesiccateQs, unresolvedDesiccationMethod},
		(*if Desiccate is False for all samples, DesiccationMethod is resolved to Null*)
		{False, Automatic},
			{Null, False},

		(*if Desiccate is True for at least one sample, DesiccationMethod is resolved to StandardDesiccant*)
		{True, Automatic},
			{StandardDesiccant, False},

		(* if Desiccate is True but DesiccationMethod is Null, it is in an error state. change DesiccationMethod to default so that Desiccate resolver does not break *)
		{True, Null},
			{
				If[NullQ[unresolvedDesiccant], Vacuum, StandardDesiccant],
				True
			},

		(*other cases are ok to leave it as is*)
		{_, _},
			{unresolvedDesiccationMethod, False}
	];

	(*Resolve Desiccant*)
	desiccant = If[
		!Or@@realDesiccateQs && MatchQ[unresolvedDesiccant, Automatic],
		Null,
		unresolvedDesiccant
	];

	(*Resolve DesiccantPhase*)
	desiccantPhase = If[
		!Or@@realDesiccateQs && MatchQ[unresolvedDesiccantPhase, Automatic],
		Null,
		unresolvedDesiccantPhase
	];

	(* Resolve CheckDesiccant *)
	checkDesiccant = If[
		!Or@@realDesiccateQs && MatchQ[unresolvedCheckDesiccant, Automatic],
		Null,
		unresolvedCheckDesiccant
	];

	(*Resolve DesiccantAmount*)
	desiccantAmount = If[
		!Or@@realDesiccateQs && MatchQ[unresolvedDesiccantAmount, Automatic],
		Null,
		unresolvedDesiccantAmount
	];

	(* DesiccantStorageCondition; Default: Automatic; If not specified, it is set to Disposal*)
	desiccantStorageCondition = If[
		!Or@@realDesiccateQs && MatchQ[unresolvedDesiccantStorageCondition, Automatic],
		Null,
		unresolvedDesiccantStorageCondition
	];

	(* DesiccantStorageContainer; Default: Automatic; If not specified, it is determined by PreferredContainer*)

	desiccantStorageContainer = If[
		!Or@@realDesiccateQs && MatchQ[unresolvedDesiccantStorageContainer, Automatic],
		Null,
		unresolvedDesiccantStorageContainer
	];

	(*Resolve Desiccator*)
	{desiccator, desiccatorChangedQ} = Switch[{Or@@realDesiccateQs, unresolvedDesiccator},
		(*if Desiccate is False for all samples, Desiccator is resolved to Null*)
		{False, Automatic},
			{Null, False},

		(*if Desiccate is True for at least one sample, Desiccator is resolved to the default desiccator*)
		{True, Automatic},
			{Model[Instrument, Desiccator, "Bel-Art Space Saver Vacuum Desiccator"], False},

		(* if Desiccate is True but DesiccationMethod is Null, it is in an error state. change DesiccationMethod to default so that Desiccate resolver does not break *)
		{True, Null},
			{Model[Instrument, Desiccator, "Bel-Art Space Saver Vacuum Desiccator"], True},

		(*other cases are ok to leave it as is*)
		{_, _},
			{unresolvedDesiccator, False}
	];

	(*Resolve DesiccationTime*)
	{desiccationTime, desiccationTimeChangedQ} = Switch[{Or@@realDesiccateQs, unresolvedDesiccationTime},
		(* if Desiccate is False for all samples, DesiccationTime is resolved to Null *)
		{False, Automatic},
			{Null, False},

		(* if Desiccate is True for at least one sample, DesiccationTime is resolved to default *)
		{True, Automatic},
			{5 Hour, False},

		(* if Desiccate is True but desiccationTime is Null, it is in an error state. change DesiccationTime to default so that Desiccate resolver does not break *)
		{True, Null},
			{5 Hour, True},

		(* other cases are ok to leave it as is *)
		{_, _},
			{unresolvedDesiccationTime, False}
	];

	(*Determine samples that should be desiccated: desiccateSamples*)
	sampleObjects = Lookup[samplePackets, Object];
	desiccateSamples = PickList[sampleObjects, realDesiccateQs];

	desiccateOptions = {
		Amount -> PickList[resolvedAmount, realDesiccateQs],
		SampleContainer -> PickList[resolvedSampleContainer, realDesiccateQs],
		SampleContainerLabel -> PickList[resolvedSampleContainerLabel, realDesiccateQs],
		Method -> desiccationMethod,
		Desiccant -> desiccant,
		CheckDesiccant -> checkDesiccant,
		DesiccantPhase -> desiccantPhase,
		DesiccantAmount -> desiccantAmount,
		DesiccantStorageCondition -> desiccantStorageCondition,
		DesiccantStorageContainer -> desiccantStorageContainer,
		Desiccator -> desiccator,
		Time -> desiccationTime
	};

	(* Build the resolved desiccate options IF Desiccate is True for at least one sample *)
	(* define these invalid option/input tracker constants, to be populated by ExperimentDesiccate *)
	$DesiccateInvalidInputs = {};
	$DesiccateInvalidOptions = {};

	(* below SamplesOutStorageCondition -> AmbientStorage is just added to avoid throwing error by Desiccate function. the real storage condition of samples are determined by PreparedSampleStorageCondition option in MeasureMeltingPoint *)
	{desiccateResolvedOptionsResult, desiccateTests} = Which[
		MemberQ[realDesiccateQs, True] && gatherTests,
			Quiet[
				ExperimentDesiccate[desiccateSamples, Join[desiccateOptions, {SamplesOutStorageCondition -> AmbientStorage, Simulation -> updatedSimulation, Cache -> cacheBall, OptionsResolverOnly -> True, Output -> {Options, Tests}}]],
				{
					Error::NonSolidSample,
					Error::MissingMassInformation,
					Error::InvalidSamplesOutStorageCondition,
					Error::InvalidOption,
					Error::InvalidInput
				}
			],
		MemberQ[realDesiccateQs, True] && !gatherTests,
			{
				Quiet[
					ExperimentDesiccate[desiccateSamples, Join[desiccateOptions, {SamplesOutStorageCondition -> AmbientStorage, Simulation -> updatedSimulation, Cache -> cacheBall, OptionsResolverOnly -> True, Output -> Options}]],
					{
						Error::NonSolidSample,
						Error::MissingMassInformation,
						Error::InvalidSamplesOutStorageCondition,
						Error::InvalidOption,
						Error::InvalidInput
					}
				],
				{}
			},
		True,
			{{}, {}}
	];

	(*Get needed resolved options form ExperimentDesiccate; Rename Method and Time back to DesiccationMethod and DesiccationTime*)
	resolvedDesiccateSingletonOptions = Normal[
		Which[
			MemberQ[realDesiccateQs, True],
				KeyTake[
					desiccateResolvedOptionsResult,
					{Method, Desiccant, CheckDesiccant, DesiccantPhase, DesiccantAmount, DesiccantStorageCondition, DesiccantStorageContainer, Desiccator, Time}
				],

			!MemberQ[realDesiccateQs, True],
				KeyTake[
					desiccateOptions,
					{Method, Desiccant, CheckDesiccant, DesiccantPhase, DesiccantAmount, DesiccantStorageCondition, DesiccantStorageContainer, Desiccator, Time}
				]
		]
	] /. {Time -> DesiccationTime, Method -> DesiccationMethod};

	(* any invalid options thrown by Desiccate *)
	desiccateInvalidOptions = Intersection[$DesiccateInvalidOptions, {Method, Desiccant, CheckDesiccant, DesiccantPhase, DesiccantAmount, DesiccantStorageCondition, DesiccantStorageContainer, Desiccator, Time}] /. {Time -> DesiccationTime, Method -> DesiccationMethod};

	(*select resolved desiccate-related index-matched options using RiffleAlternatives.
	The only desiccate-related index-matched option is SampleContainer*)
	resolvedDesiccateIndexMatchedOptions = {SampleContainer -> RiffleAlternatives[

		(*True list is options of samples that were resolved by ExperimentDesiccate*)
		Lookup[desiccateResolvedOptionsResult, SampleContainer, {}],

		(*False list is the options of samples that were not resolved by ExperimentDesiccate*)
		PickList[resolvedSampleContainer, realDesiccateQs, False],

		realDesiccateQs
	]};
	(*End of resolving Desiccate-related options*)

	(*-----------------------------*)
	(*-----------------------------*)
	(*--- Resolve Grind options ---*)
	(*-----------------------------*)
	(*-----------------------------*)


	(*Determine samples that should be ground*)
	grindSamples = PickList[sampleObjects, realGrindQs];

	optionValues = {resolvedAmount, halfResolvedGrinderType, halfResolvedGrinder, halfResolvedFineness,
		halfResolvedBulkDensity, halfResolvedGrindingContainer, halfResolvedGrindingBead,
		halfResolvedNumberOfGrindingBeads, halfResolvedGrindingRate, halfResolvedGrindingTime,
		halfResolvedNumberOfGrindingSteps, halfResolvedCoolingTime, halfResolvedGrindingProfile};

	(*pick options of samples that should be ground*)
	rawGrindOptionValues = PickList[#, realGrindQs]& /@ optionValues;

	grindOptionValues = If[
		MemberQ[realGrindQs, True],
		Join[{rawGrindOptionValues[[1]]}, Rest[rawGrindOptionValues]],
		rawGrindOptionValues
	];

	(*pick options of samples that should not be ground*)
	noGrindOptionValues = PickList[#, realGrindQs, False]& /@ optionValues;

	(*make a list of rules for grind options*)
	grindOptions = MapThread[Rule, {grindOptionNamesWithAmount, grindOptionValues}];

	(*make a list of rules for grind options of samples that should not be ground*)
	noGrindOptions = MapThread[Rule, {grindOptionNamesWithAmount, noGrindOptionValues}];

	(*Grinder and GrindingTime should change to Instrument and Time to be used in ExperimentGrind*)
	renamedGrindOptions = Map[(Keys[#] /. {Grinder -> Instrument, GrindingTime -> Time}) -> Values[#]&, grindOptions];

	(* Build the resolved grind options *)

	(* define these invalid option/input tracker constants, to be populated by ExperimentGrind *)
	$GrindInvalidInputs = {};
	$GrindInvalidOptions = {};

	(* below SamplesOutStorageCondition -> AmbientStorage is just added to avoid throwing error by Grind function. the real storage condition of samples are determined by PreparedSampleStorageCondition option in MeasureMeltingPoint *)
	{grindResolvedOptionsResult, grindTests} = Which[
		MemberQ[realGrindQs, True] && gatherTests,
			Quiet[
				ExperimentGrind[grindSamples, Join[renamedGrindOptions, {SamplesOutStorageCondition -> AmbientStorage, Simulation -> updatedSimulation, Cache -> cacheBall, OptionsResolverOnly -> True, Output -> {Options, Tests}}]],
				{
					Error::NonSolidSample,
					Warning::MissingMassInformation,
					Error::InvalidSamplesOutStorageCondition,
					Error::InvalidOption,
					Error::InvalidInput
				}
			],
		MemberQ[realGrindQs, True] && !gatherTests,
			{
				Quiet[
					ExperimentGrind[grindSamples, Join[renamedGrindOptions, {SamplesOutStorageCondition -> AmbientStorage, Simulation -> updatedSimulation, Cache -> cacheBall, OptionsResolverOnly -> True, Output -> Options}]],
					{
						Error::NonSolidSample,
						Warning::MissingMassInformation,
						Error::InvalidSamplesOutStorageCondition,
						Error::InvalidOption,
						Error::InvalidInput
					}
				],
				{}
			},
		True,
			{{}, {}}
	];

	(*Get needed resolved options form ExperimentGrind; Rename Instrument and Time back to Grinder and GrindingTime*)
	renamedGrindResolvedOptionsResult = Map[(Keys[#] /. {Instrument -> Grinder, Time -> GrindingTime}) -> Values[#]&, grindResolvedOptionsResult];

	(*select resolved grind-related index-matched options using RiffleAlternatives*)
	resolvedGrindOptions = MapThread[
		#1 -> RiffleAlternatives[

			(*True list is options of samples that were resolved by ExperimentGrind*)
			Lookup[renamedGrindResolvedOptionsResult, #1, {}],

			(*False list is the options of samples that were not resolved by ExperimentGrind*)
			Lookup[#2, #1],

			realGrindQs
		]&, {grindOptionNamesWithAmount, noGrindOptions}
	];

	(* any invalid options thrown by Grind *)
	grindInvalidOptions = $GrindInvalidOptions /. {Instrument -> Grinder, Time -> GrindingTime};


	(*End of resolving Grind-related options*)

	(*------------------------------------------*)
	(*------------------------------------------*)
	(*--- MeasureMeltingPoint-related errors ---*)
	(*------------------------------------------*)
	(*------------------------------------------*)

	(* resolve instrument and throw errors if needed *)

	(* max of the resolved EndTemperatures *)
	maxResolvedEndTemperature = Max[resolvedEndTemperature];

	(* max of the resolved NumberOfReplicates *)
	maxResolvedNumberOfReplicates = Max[resolvedNumberOfReplicates /. Null :> 1];

	(* all suitable instruments *)
	suitableInstruments = Cases[availableInstrumentTuples, {
		meltingPointInstrument:ObjectP[Model[Instrument, MeltingPointApparatus]],
		instrumentMaxTemperature:GreaterEqualP[maxResolvedEndTemperature],
		instrumentMaxSlots:GreaterEqualP[maxResolvedNumberOfReplicates]
	} :> meltingPointInstrument];

	(* resolve the instrument: select the first suitable instrument. onsite instruments are added first in this list *)
	resolvedInstrument = If[
		MatchQ[unresolvedInstrument, Automatic],
		First[suitableInstruments, Automatic],
		unresolvedInstrument
	];

	(* lookup the model of the resolved instrument *)
	resolvedInstrumentModel = If[
		MatchQ[resolvedInstrument, ObjectP[Object[Instrument, MeltingPointApparatus]]],
		fastAssocLookup[fastAssoc, resolvedInstrument, Model],
		resolvedInstrument
	];

	(* lookup the number of capillary slots of the resolved instrument *)
	numberOfCapillarySlots = If[
		MatchQ[resolvedInstrumentModel, ObjectP[Model[Instrument, MeltingPointApparatus]]],
		fastAssocLookup[fastAssoc, resolvedInstrumentModel, NumberOfMeltingPointCapillarySlots],
		(* if resolvedInstrumentModel is not a Model, give numberOfCapillarySlots a default number so the code does not break *)
		3
	];

	(* Throw an error if no instrument found at any site at all, not even considering NumberOfReplicates or EndTemperature *)
	noAvailableInstrumentQ = MatchQ[possibleInstrumentModels, {}];

	noAvailableInstruments = If[
		messages && noAvailableInstrumentQ,

		(
			Message[
				Error::NoAvailableMeltingPointInstruments,
				ObjectToString[experimentSites, Cache -> cacheBall]
			];
			{Instrument}
		),

		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	noAvailableInstrumentTests = If[
		gatherTests,

		Test["At least one melting point apparatus exists at any of the allowed experiment sites (" <> ObjectToString[experimentSites, Cache -> cacheBall] <> ").", True, !noAvailableInstrumentQ],

		{}
	];

	(* Throw an error if the user specified an instrument but it is not included in the desiredInstrumentModels list *)
	invalidInstrumentQ = And[
		MatchQ[unresolvedInstrumentModel, ObjectP[Model[Instrument, MeltingPointApparatus]]],
		!MemberQ[desiredInstrumentModels, ObjectP[unresolvedInstrumentModel]]
	];

	invalidInstruments = If[
		messages && invalidInstrumentQ,
		(
			Message[
				Error::InvalidInstrument,
				ObjectToString[unresolvedInstrument, Cache -> cacheBall],
				ObjectToString[experimentSites, Cache -> cacheBall]
			];
			{Instrument}
		),

		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	invalidInstrumentTests = If[
		gatherTests,

		Test["The selected melting point apparatus exists at any of the allowed experiment sites (" <> ObjectToString[experimentSites, Cache -> cacheBall] <> ").", True, !invalidInstrumentQ],

		{}
	];


	(*throw an error if ExpectedMeltingPoint is set to greater than availableMaxTemperature or below 25 Celsius*)
	expectedMeltingPointInvalidOptions = If[MemberQ[invalidExpectedMeltingPoints, True] && messages,
		(
			Message[
				Error::InvalidExpectedMeltingPoint,
				ObjectToString[PickList[simulatedSamples, invalidExpectedMeltingPoints], Cache -> cacheBall],
				ObjectToString[availableMaxTemperature, Cache -> cacheBall]
			];
			{ExpectedMeltingPoint}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	expectedMeltingPointInvalidTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, invalidExpectedMeltingPoints];
			passingInputs = PickList[simulatedSamples, invalidExpectedMeltingPoints, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["ExpectedMeltingPoint is set to a valid value (between 25 and " <> ObjectToString[availableMaxTemperature, Cache -> cacheBall] <> ") for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["ExpectedMeltingPoint is set to a valid value (between 25 and " <> ObjectToString[availableMaxTemperature, Cache -> cacheBall] <> ") for the following samples: " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* throw an error if EndTemperature is greater than the available max temperature *)
	endTemperatureInvalidOptions = Which[
		And[
			messages,
			MemberQ[invalidEndTemperatures, True],
			MatchQ[unresolvedInstrumentModel, ObjectP[Model[Instrument, MeltingPointApparatus]]],
			!invalidInstrumentQ,
			!noAvailableInstrumentQ
		],

			(
				Message[
					Error::InvalidEndTemperatures,
					ObjectToString[PickList[resolvedEndTemperature, invalidEndTemperatures], Cache -> cacheBall],
					ObjectToString[PickList[simulatedSamples, invalidEndTemperatures], Cache -> cacheBall],
					"specified melting point instrument, " <> ObjectToString[unresolvedInstrument, Cache -> cacheBall]
				];
				{EndTemperature, Instrument}
			),

		And[
			messages,
			MemberQ[invalidEndTemperatures, True],
			!invalidInstrumentQ,
			!noAvailableInstrumentQ
		],

			(
				Message[
					Error::InvalidEndTemperatures,
					ObjectToString[PickList[resolvedEndTemperature, invalidEndTemperatures], Cache -> cacheBall],
					ObjectToString[PickList[simulatedSamples, invalidEndTemperatures], Cache -> cacheBall],
					"available melting point instruments at your allowed experiment sites " <> ObjectToString[experimentSites, Cache -> cacheBall]
				];
				{EndTemperature, Instrument}
			),

		True,
			{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	endTemperatureInvalidTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, invalidEndTemperatures];
			passingInputs = PickList[simulatedSamples, invalidEndTemperatures, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The specified EndTemperature is less than or equal to the MaxTemperature of the available instruments: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The specified EndTemperature is less than or equal to the MaxTemperature of the available instruments: " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if StartTemperature is greater than or equal to EndTemperature*)
	startEndTemperatureInvalidOptions = If[MemberQ[invalidStartEndTemperatures, True] && messages,
		(
			Message[
				Error::InvalidStartEndTemperatures,
				ObjectToString[PickList[simulatedSamples, invalidStartEndTemperatures], Cache -> cacheBall]
			];
			{StartTemperature, EndTemperature}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	startEndTemperatureInvalidTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, invalidStartEndTemperatures];
			passingInputs = PickList[simulatedSamples, invalidStartEndTemperatures, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["StartTemperature is less than EndTemperature for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["StartTemperature is less than EndTemperature for the following samples: " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* throw an error if specified NumberOfReplicates are greater than the number of capillary slots *)
	highNumberOfReplicatesOptions = Which[
		And[
			messages,
			MemberQ[highNumbersOfReplicates, True],
			MatchQ[unresolvedInstrument, ObjectP[]],
			!invalidInstrumentQ,
			!noAvailableInstrumentQ
		],
			(
				Message[
					Error::HighNumberOfReplicates,
					ObjectToString[PickList[resolvedNumberOfReplicates, highNumbersOfReplicates], Cache -> cacheBall],
					ObjectToString[PickList[simulatedSamples, highNumbersOfReplicates], Cache -> cacheBall],
					"specified melting point instrument, " <> ObjectToString[unresolvedInstrument, Cache -> cacheBall]
				];
				{NumberOfReplicates, Instrument}
			),

		And[
			messages,
			MemberQ[highNumbersOfReplicates, True],
			!invalidInstrumentQ,
			!noAvailableInstrumentQ
		],
			(
				Message[
					Error::HighNumberOfReplicates,
					ObjectToString[PickList[resolvedNumberOfReplicates, highNumbersOfReplicates], Cache -> cacheBall],
					ObjectToString[PickList[simulatedSamples, highNumbersOfReplicates], Cache -> cacheBall],
					"available melting point instruments at your allowed experiment sites " <> ObjectToString[experimentSites, Cache -> cacheBall]
				];
				{NumberOfReplicates}
			),

		True,
			{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	highNumberOfReplicatesTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, highNumbersOfReplicates];
			passingInputs = PickList[simulatedSamples, highNumbersOfReplicates, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[
				And[
					Length[failingInputs] > 0,
					MemberQ[highNumbersOfReplicates, True],
					MatchQ[unresolvedInstrument, ObjectP[]],
					!invalidInstrumentQ,
					!noAvailableInstrumentQ
				],

				Test["The specified NumbersOfReplicates " <> resolvedNumberOfReplicates <> " is less than or equal to the NumberOfMeltingPointCapillarySlots of the specified instrument: " <> ObjectToString[resolvedInstrument, Cache -> cacheBall] <> " for samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],

				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[
				And[
					Length[passingInputs] > 0,
					MemberQ[highNumbersOfReplicates, True],
					MatchQ[unresolvedInstrument, ObjectP[]],
					!invalidInstrumentQ,
					!noAvailableInstrumentQ
				],

				Test["The specified NumbersOfReplicates " <> resolvedNumberOfReplicates <> " is less than or equal to the NumberOfMeltingPointCapillarySlots of the specified instrument: " <> ObjectToString[resolvedInstrument, Cache -> cacheBall] <> " for samples: " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ".", True, True],

				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];


	(*throw a warning if TemperatureRampRate and RampTime were both specified by user and we changed TemperatureRampRate to match RampTime*)
	mismatchedRampRateRampTimeOptions = If[MemberQ[rampRateChangeWarnings, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::MismatchedRampRateAndTime,
				ObjectToString[PickList[simulatedSamples, rampRateChangeWarnings], Cache -> cacheBall]
			];
			{TemperatureRampRate, RampTime}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	mismatchedRampRateRampTimeTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, rampRateChangeWarnings];
			passingInputs = PickList[simulatedSamples, rampRateChangeWarnings, False];

			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["TemperatureRampRate and RampTime are set to matching values for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];

			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["TemperatureRampRate and RampTime are set to matching values for the following samples: " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* estimate the total experiment time and throw an error if it is more than $MaxExperimentTime *)
	grindingProfiles = Lookup[resolvedGrindOptions, GrindingProfile];

	(* estimated total Desiccate time *)
	totalDesiccationTime = If[TimeQ[resolvedDesiccationTime],
		UnitConvert[resolvedDesiccationTime, Hour] + 1 Hour,
		0 Hour
	];

	(* estimated total Grind time *)
	totalGrindTime = With[{grindTime = Plus @@ Cases[Flatten[grindingProfiles], TimeP]},
		If[TimeQ[grindTime],
			UnitConvert[grindTime, Hour] + 1 Hour,
			0 Hour
		]
	];

	groupedMeltingPointOptions = Lookup[Experiment`Private`groupByKey[
		{
			NumberOfReplicates -> resolvedNumberOfReplicates,
			StartTemperature -> resolvedStartTemperature,
			EquilibrationTime -> equilibrationTime,
			EndTemperature -> resolvedEndTemperature,
			TemperatureRampRate -> resolvedTemperatureRampRate,
			RampTime -> resolvedRampTime,
			Prepacked -> prepackedQs
		},
		{NumberOfReplicates, StartTemperature, EquilibrationTime, EndTemperature, TemperatureRampRate, RampTime, Prepacked}
	][[All, 2]], {RampTime, EquilibrationTime, NumberOfReplicates}];

	(* estimated total MeasureMeltingPoint time *)
	groupedRampTimes = groupedMeltingPointOptions[[All, 1, 1]];
	groupedEquilibrationTimes = groupedMeltingPointOptions[[All, 2, 1]];
	groupedNumberOfReplicates = groupedMeltingPointOptions[[All, 3]];
	groupedSampleLengths = Length /@ groupedNumberOfReplicates;

	totalMeltingPointTime = Plus @@ MapThread[If[NullQ[#1[[1]]],
		UnitConvert[Ceiling[#2 / numberOfCapillarySlots] * (#3 + #4), Hour] + 1 Hour,
		UnitConvert[#2 * (#3 + #4), Hour] + 1 Hour
	]&, {groupedNumberOfReplicates, groupedSampleLengths, groupedRampTimes, groupedEquilibrationTimes}];

	(* estimated total experiment time *)
	totalEstimatedExperimentTime = totalDesiccationTime + totalGrindTime + totalMeltingPointTime + Length[PickList[myInputSamples, prepackedQs, False]] * Hour;

	(* throw an error if it is more than $MaxExperimentTime *)
	longExperimentTimeOptions = If[messages && totalEstimatedExperimentTime > $MaxExperimentTime,
		(
			Message[
				Error::LongExperimentTime,
				$MaxExperimentTime
			];
			Flatten[{
				PickList[{DesiccationTime, GrindingTime}, {Or @@ realDesiccateQs, Or @@ realGrindQs}],
				RampTime
			}]
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	longExperimentTimeTest = If[gatherTests,
		Test["The estimated total experiment time is less than the allowed maximum experiment time (" <>  ObjectToString[$MaxExperimentTime] <> ").", True, totalEstimatedExperimentTime <= $MaxExperimentTime],
		{}
	];

	(* some user-specified variables that caused Error State may have changed in order to successfully run Grind and Desiccate resolvers.
	 These variables are set back to the user-specified values here *)
	grindTargetOptions = {
		GrinderType, Grinder, Fineness, BulkDensity, GrindingContainer,
		GrindingRate, GrindingTime, NumberOfGrindingSteps, GrindingProfile, Amount
	};

	desiccateTargetOptions = {DesiccationMethod, Desiccator, DesiccationTime};

	valueChangedQs = {
		grinderTypeChangeQs, grinderChangedQs, finenessChangedQs, bulkDensityChangedQs, grindingContainerChangedQs,
		grindingRateChangedQs, grindingTimeChangedQs, numberOfGrindingStepsChangedQs, grindingProfileChangesQs,
		amountChangedQs, ToList[desiccationMethodChangedQ], ToList[desiccatorChangedQ], ToList[desiccationTimeChangedQ]
	};

	unresolvedOptionValues = ToList /@ Lookup[roundedMeasureMeltingPointOptions, Join[grindTargetOptions, desiccateTargetOptions]];

	resolvedGrindValues = Lookup[resolvedGrindOptions, grindTargetOptions];

	resolvedDesiccateValues = ToList /@ Lookup[resolvedDesiccateSingletonOptions, desiccateTargetOptions];

	resolvedOptionValues = Join[resolvedGrindValues, resolvedDesiccateValues];

	{
		resolvedGrinderTypes,
		resolvedGrinders,
		resolvedFinenesses,
		resolvedBulkDensities,
		resolvedGrindingContainers,
		resolvedGrindingRates,
		resolvedGrindingTimes,
		resolvedNumberOfGrindingSteps,
		resolvedGrindingProfiles,
		resolvedAmounts,
		{resolvedDesiccationMethod},
		{resolvedDesiccator},
		{resolvedDesiccationTime}
	} = MapThread[
		Function[{changedQs, unresolvedValues, resolvedValues},
			MapThread[If[#1, #2, #3]&, {changedQs, unresolvedValues, resolvedValues}]],
		{valueChangedQs, unresolvedOptionValues, resolvedOptionValues}
	];


	(*------------------------------*)
	(*------------------------------*)
	(*--- Final Resolved Options ---*)
	(*------------------------------*)
	(*------------------------------*)

	(* gather all the resolved options together *)
	(* doing this ReplaceRule ensures that any newly-added defaulted ProtocolOptions are going to be just included in myOptions*)
	resolvedOptions = ReplaceRule[
		myOptions,
		Flatten[{
			MeasurementMethod -> unresolvedMeasurementMethod,
			OrderOfOperations -> resolvedOrderOfOperations,
			ExpectedMeltingPoint -> resolvedExpectedMeltingPoint,
			NumberOfReplicates -> resolvedNumberOfReplicates,
			Amount -> resolvedAmounts,
			SampleLabel -> resolvedSampleLabel,
			SampleContainerLabel -> resolvedSampleContainerLabel,
			PreparedSampleLabel -> resolvedPreparedSampleLabel,
			Grind -> grindQs,
			GrinderType -> resolvedGrinderTypes,
			Grinder -> resolvedGrinders,
			Fineness -> resolvedFinenesses,
			BulkDensity -> resolvedBulkDensities,
			GrindingContainer -> resolvedGrindingContainers,
			GrindingBead -> Lookup[resolvedGrindOptions, GrindingBead],
			NumberOfGrindingBeads -> Lookup[resolvedGrindOptions, NumberOfGrindingBeads],
			GrindingRate -> resolvedGrindingRates,
			GrindingTime -> resolvedGrindingTimes,
			NumberOfGrindingSteps -> resolvedNumberOfGrindingSteps,
			CoolingTime -> Lookup[resolvedGrindOptions, CoolingTime],
			GrindingProfile -> resolvedGrindingProfiles,
			Desiccate -> desiccateQs,
			SampleContainer -> Lookup[resolvedDesiccateIndexMatchedOptions, SampleContainer],
			DesiccationMethod -> resolvedDesiccationMethod,
			Desiccant -> Lookup[resolvedDesiccateSingletonOptions, Desiccant],
			DesiccantPhase -> Lookup[resolvedDesiccateSingletonOptions, DesiccantPhase],
			CheckDesiccant -> Lookup[resolvedDesiccateSingletonOptions, CheckDesiccant],
			DesiccantAmount -> Lookup[resolvedDesiccateSingletonOptions, DesiccantAmount],
			DesiccantStorageCondition -> Lookup[resolvedDesiccateSingletonOptions, DesiccantStorageCondition],
			DesiccantStorageContainer -> Lookup[resolvedDesiccateSingletonOptions, DesiccantStorageContainer],
			Desiccator -> resolvedDesiccator,
			DesiccationTime -> resolvedDesiccationTime,
			SealCapillary -> resolvedSealCapillary,
			Instrument -> resolvedInstrument,
			StartTemperature -> resolvedStartTemperature,
			EquilibrationTime -> equilibrationTime,
			EndTemperature -> resolvedEndTemperature,
			TemperatureRampRate -> resolvedTemperatureRampRate,
			RampTime -> resolvedRampTime,
			PreparedSampleStorageCondition -> preparedSampleStorageCondition,
			CapillaryStorageCondition -> capillaryStorageCondition,
			resolvedPostProcessingOptions
		}]
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{
		$DesiccateInvalidInputs,
		$GrindInvalidInputs,
		nonSolidSampleInvalidInputs,
		discardedInvalidInputs
	}]];

	(* gather all the invalid options together *)
	invalidOptions = DeleteDuplicates[Flatten[{
		desiccateInvalidOptions,
		grindInvalidOptions,
		prepackedSamplePrepUnneededOptions,
		noPrepUnneededOptions,
		prepackedDesiccateUnneededOptions,
		requiredSingletonDesiccateOptions,
		noDesiccateUnneededOptions,
		prepackedGrindUnneededOptions,
		noGrindUnneededOptions,
		desiccateGrindOptionMismatches,
		orderOptionMismatches,
		numberOfReplicatesMismatchedOptions,
		highNumberOfReplicatesOptions,
		invalidPreparedSampleStorageConditionsOptions,
		noAvailableInstruments,
		invalidInstruments,
		expectedMeltingPointInvalidOptions,
		endTemperatureInvalidOptions,
		startEndTemperatureInvalidOptions,
		longExperimentTimeOptions
	}]];


	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[messages && Length[invalidInputs] > 0,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[messages && Length[invalidOptions] > 0,
		Message[Error::InvalidOption, invalidOptions]
	];


	(* get all the tests together *)
	allTests = Cases[Flatten[{
		samplePrepTests,
		discardedTest,
		missingMassTest,
		nonSolidSampleTest,
		precisionTests,
		noPrepTests,
		requiredSingletonDesiccateOptionTests,
		desiccateGrindOptionMismatchTests,
		orderOptionMismatchTests,
		invalidPreparedSampleStorageConditionsTest,
		numberOfReplicatesMismatchedTest,
		highNumberOfReplicatesTest,
		desiccateTests,
		grindTests,
		noAvailableInstrumentTests,
		invalidInstrumentTests,
		expectedMeltingPointInvalidTest,
		endTemperatureInvalidTest,
		startEndTemperatureInvalidTest,
		mismatchedRampRateRampTimeTest,
		longExperimentTimeTest
	}], TestP];

	(* return our resolved options and/or tests *)
	outputSpecification /. {Result -> resolvedOptions, Tests -> allTests}
];

(* ::Subsection::Closed:: *)
(*measureMeltingPointResourcePackets*)

DefineOptions[measureMeltingPointResourcePackets,
	Options :> {
		CacheOption,
		HelperOutputOption,
		SimulationOption
	}
];

measureMeltingPointResourcePackets[
	mySamples : {ObjectP[Object[Sample]]..},
	myUnresolvedOptions : {___Rule},
	myResolvedOptions : {___Rule},
	myCollapsedResolvedOptions : {___Rule},
	myOptions : OptionsPattern[]
] := Module[
	{
		safeOps, outputSpecification, output, gatherTests, messages, desiccator, desiccantStorageCondition,
		cache, simulation, fastAssoc, simulatedSamples, desiccationTime, realDesiccateQs,allMeltingPointInstrumentModels,
		updatedSimulation, containersIn, simulatedSampleContainers, simulatedSampleContainerModels, samplesInResources,
		desiccantResources, inputSampleContainers, desiccantStorageContainerResources, numberOfCapillarySlots,
		capillaryNumbers, prepackedQ, meltingPointCapillaries, meltingPointCapillary, defaultMeltingPointInstrumentModel,
		capillaryResourceNames, capillaryResources, preparationUnitOperations, packingDevices, samplesToSkip,
		capillarySeal, capillarySealResource, capillarySealResources, packingDevice, rawPreparationUnitOperations,
		sampleContainerResources, grindingContainerResources, grind1Qs, grind2Qs, checkDesiccant,
		grind1Samples, desiccateSamples, grind2Samples, grindOptionNames, grindOptions, grind1Options,
		grind2Options, packingDeviceResource, allInstruments, totalGrindTimes, desiccatorResources,
		grinderResourceRules, grinderResources, mergedGrinderTimes, grinderTimeRules, containersInResources,
		desiccationMethod, desiccant, desiccantPhase, desiccantAmount, desiccantStorageContainer,
		measurementMethod, orderOfOperations, expectedMeltingPoint, numberOfReplicates,
		sealCapillary, instrument, startTemperature, equilibrationTime, endTemperature, temperatureRampRate, rampTime,
		preparedSampleStorageCondition, capillaryStorageCondition, desiccateQs,
		realGrindQs, grindQs, amount, sampleContainer, grinderType, grinder, fineness, bulkDensity,
		grindingContainer, grindingBead, numberOfGrindingBeads, grindingRate, rawGrindingProfile,
		grindingTime, numberOfGrindingSteps, coolingTime, grindingProfile, preparedSampleLabel, instrumentTag,
		grindingBeadResourceRules, mergedBeadsAndNumbers, samplePrepTime, experimentTime, postProcessingTime,
		sampleGroupedOptions, BatchSamplesByReplicates, beadsAndNumbers, sampleLabel,
		sampleContainerLabel, unitOperationPackets, instrumentResources, grindingBeadResources,
		numericAmount, grind1OptionRules, nonIndexMatchedDesiccateOptionNames, indexMatchedDesiccateOptionNames,
		nonIndexMatchedDesiccateOptions, indexMatchedDesiccateOptions,storageTime,
		desiccateIndexMatchedOptions, desiccateNonIndexMatchedOptionRules, desiccateIndexMatchedOptionRules, grind2OptionRules,
		groupedOptions, protocolPacket, totalInstrumentTime, sharedFieldPacket, finalizedPacket, instrumentModel,
		grindingContainerModel, allResourceBlobs, capillaryRod, capillaryRodResources,
		fulfillable, frqTests, previewRule, optionsRule, testsRule, resultRule,
		transfer1Qs, transfer2Qs, transfer3Qs, labelFinder, samplesInLabels,
		processesQ, notPrepackedInputSamples, numberOfGrind1Samples, numberOfDesiccateSamples, numberOfGrind2Samples
	},

	(*get the safe options for this function*)
	safeOps = SafeOptions[measureMeltingPointResourcePackets, ToList[myOptions]];

	(* pull out the output options *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(*decide if we are gathering tests or throwing messages*)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(*lookup helper options*)
	{cache, simulation} = Lookup[safeOps, {Cache, Simulation}];

	(*make the fast association*)
	fastAssoc = makeFastAssocFromCache[cache];

	(*simulate the sample preparation stuff so we have the right containers if we are aliquoting*)
	{simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentMeasureMeltingPoint, mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation];

	(*this is the only real Download I need to do, which is to get the simulated sample containers*)
	{containersIn, simulatedSampleContainers} = Download[{mySamples, simulatedSamples}, Container[Object], Cache -> cache, Simulation -> updatedSimulation];
	containersInResources = Resource[Sample -> #, Name->ToString[Unique[]]]& /@ containersIn;

	(* lookup option values*)
	{
		(*1*)orderOfOperations,
		(*2*)expectedMeltingPoint,
		(*3*)numberOfReplicates,
		(*4*)amount,
		(*5*)preparedSampleLabel,
		(*7*)grindQs,
		(*8*)grinderType,
		(*9*)grinder,
		(*10*)fineness,
		(*11*)bulkDensity,
		(*12*)grindingContainer,
		(*13*)grindingBead,
		(*14*)numberOfGrindingBeads,
		(*15*)grindingRate,
		(*16*)grindingTime,
		(*17*)numberOfGrindingSteps,
		(*18*)coolingTime,
		(*19*)rawGrindingProfile,
		(*20*)desiccateQs,
		(*21*)sampleContainer,
		(*22*)desiccationMethod,
		(*23*)desiccant,
		(*24*)desiccantPhase,
		(*25*)desiccantAmount,
		(*26*)desiccator,
		(*27*)desiccationTime,
		(*28*)sealCapillary,
		(*29*)instrument,
		(*30*)startTemperature,
		(*31*)equilibrationTime,
		(*32*)endTemperature,
		(*33*)temperatureRampRate,
		(*34*)rampTime,
		(*37*)preparedSampleStorageCondition,
		(*38*)capillaryStorageCondition,
		(*40*)sampleLabel,
		(*41*)sampleContainerLabel,
		(*42*)measurementMethod,
		(*43*)desiccantStorageContainer,
		(*44*)desiccantStorageCondition,
		(*45*)checkDesiccant
	} = Lookup[
		myResolvedOptions,
		{
			(*1*)OrderOfOperations,
			(*2*)ExpectedMeltingPoint,
			(*3*)NumberOfReplicates,
			(*4*)Amount,
			(*5*)PreparedSampleLabel,
			(*7*)Grind,
			(*8*)GrinderType,
			(*9*)Grinder,
			(*10*)Fineness,
			(*11*)BulkDensity,
			(*12*)GrindingContainer,
			(*13*)GrindingBead,
			(*14*)NumberOfGrindingBeads,
			(*15*)GrindingRate,
			(*16*)GrindingTime,
			(*17*)NumberOfGrindingSteps,
			(*18*)CoolingTime,
			(*19*)GrindingProfile,
			(*20*)Desiccate,
			(*21*)SampleContainer,
			(*22*)DesiccationMethod,
			(*23*)Desiccant,
			(*24*)DesiccantPhase,
			(*25*)DesiccantAmount,
			(*26*)Desiccator,
			(*27*)DesiccationTime,
			(*28*)SealCapillary,
			(*29*)Instrument,
			(*30*)StartTemperature,
			(*31*)EquilibrationTime,
			(*32*)EndTemperature,
			(*33*)TemperatureRampRate,
			(*34*)RampTime,
			(*37*)PreparedSampleStorageCondition,
			(*38*)CapillaryStorageCondition,
			(*40*)SampleLabel,
			(*41*)SampleContainerLabel,
			(*42*)MeasurementMethod,
			(*43*)DesiccantStorageContainer,
			(*44*)DesiccantStorageCondition,
			(*45*)CheckDesiccant
		}
	];

	(* instrument models *)
	allMeltingPointInstrumentModels = DeleteDuplicates@Lookup[
		Cases[fastAssoc, ObjectP[Model[Instrument, MeltingPointApparatus]]], Object
	];

	defaultMeltingPointInstrumentModel = First[allMeltingPointInstrumentModels];


	(*capillary model*)
	meltingPointCapillaries = DeleteDuplicates@Lookup[
		Cases[fastAssoc, ObjectP[Model[Container, Capillary]]], Object
	];

	meltingPointCapillary = First[meltingPointCapillaries];

	(* Capillary Rod *)
	capillaryRod = DeleteDuplicates@Lookup[
		Cases[fastAssoc, ObjectP[Model[Item, Rod]]], Object
	];

	(*capillary seal model: Model[Item,Consumable,"HemataSeal"]*)
	capillarySeal = Model[Item, Consumable, "id:Z1lqpMlr30vo"];

	(*Determine samples that are prepacked in capillary tubes*)
	inputSampleContainers = Lookup[fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples, Container];

	prepackedQ = Map[If[
		MatchQ[#1, ObjectP[Object[Container, Capillary]]], True, False
	]&, inputSampleContainers];

	(* samples in capillaries are not ground or desiccated. realGrindQs and realDesiccateQs indicate samples that are Grind/Desiccate -> True, and are not prepacked in capillaries *)
	realDesiccateQs = MapThread[And, {desiccateQs, Not /@ prepackedQ}];
	realGrindQs = MapThread[And, {grindQs, Not /@ prepackedQ}];

	(* --- Make all the resources needed in the experiment --- *)
	(*Update amount value to quantity if it is resolved to All*)
	(* if amount is set to All and Mass is not informed, use 1 Gram *)
	numericAmount = MapThread[If[
		MatchQ[#1, All | Null],
		fastAssocLookup[fastAssoc, #2, Mass],
		#1
	]&, {amount, ToList[mySamples]}];

	(* the samples that SamplesMustBeMoved warning should be skipped (the ones that Amount is not All) *)
	samplesToSkip = MapThread[If[
		MatchQ[#1, Except[All | Null]],
		#2,
		Nothing
	]&, {amount, ToList[mySamples]}];

	(*SampleIn Resources: if the sample is prepacked, its container (capillary tube) is used for resources. If the sample is not prepacked, it is treated normally*)
	samplesInResources = MapThread[If[TrueQ[#1] || NullQ[#4],
		Resource[Sample -> #2, Name -> #3],
		Resource[Sample -> #2, Name -> #3, Amount -> #4]]&,
		{prepackedQ, ToList[mySamples], sampleLabel, numericAmount}
	];

	(* --- Instrument Resources --- *)
	(*Combine all instruments (melting point apparatus, desiccator, grinder)*)
	allInstruments = Flatten[Join[ToList[instrument], grinder, ToList[desiccator]] /. Null -> {}];

	(*Make a list of tags for each unique instrument*)
	instrumentTag = Map[# -> ToString[Unique[]]&, DeleteDuplicates[allInstruments]
	];

	(*Desiccator resource*)
	desiccatorResources = If[MemberQ[{desiccator, desiccationTime}, Null], Null,
		Link[Resource[Instrument -> desiccator, Time -> desiccationTime, Name -> desiccator /. instrumentTag]]
	];

	(* GrindingProfile is in the form of {{GrindingRate, GrindingTime}|{GrindingTime}..}, The former indicates a grinding step and the latter indicates a cooling step. The grinding profile should be expanded to the form of {{Grinding|Cooling, GrindingRate, GrindingTime}..} *)
	grindingProfile = Map[
		If[MatchQ[#, {TimeP}],
			ReleaseHold[Prepend[#, Hold[Sequence@@{Cooling, 0 RPM}]]],
			Prepend[#, Grinding]
	]&,
		rawGrindingProfile,
		{2}
	];

	(*Calculate the time required for grinding from GrindingProfile. If GrindingProfile is Null, it is replaced by {{0,0,-5Minute}} to prevent error. -5Minute corrects for the 5 minute additional time for samples that need grinding*)
	totalGrindTimes = Map[Total, (grindingProfile /. {Null -> {{0, 0, -5Minute}}})[[All, All, 3]]];
	grinderTimeRules = MapThread[#1 -> #2&, {grinder, (totalGrindTimes + 5Minute)}];

	(*merge the grinder and time rules*)
	mergedGrinderTimes = Merge[grinderTimeRules, Total];

	(* make grinder resources *)
	(* For Manual preparation, do this trick with the grinder tags to ensure we don't have duplicate grinder resources *)
	grinderResourceRules = KeyValueMap[
		If[NullQ[#1], Nothing,
			#1 -> Link[Resource[
				Instrument -> #1, Time -> (#2 + 5Minute), Name -> (#1 /. instrumentTag)]]
		]&,
		mergedGrinderTimes
	];

	grinderResources = MapThread[If[MatchQ[#1, False], Null, #2 /. grinderResourceRules]&,
		{realGrindQs, grinder}
	];

	(*time needed for malting point apparatus*)
	totalInstrumentTime = Total[rampTime + equilibrationTime + 10Minute];

	(* make Instrument (melting point apparatus) resources *)
	instrumentResources = Link[Resource[
		Instrument -> instrument /. Automatic -> defaultMeltingPointInstrumentModel, Time -> totalInstrumentTime, Name -> CreateUniqueLabel["Melting Point Apparatus"]
	]];

	(* --- Resources for Desiccate --- *)
	(* Desiccant resource if not Null *)
	desiccantResources = If[NullQ[desiccant], Null,
		Link[Resource[
			Sample -> desiccant,
			Container -> Model[Container, Vessel, "id:4pO6dMOxdbJM"], (* Pyrex Crystallization Dish *)
			Amount -> desiccantAmount,
			ExactAmount -> True,
			(* 10% Tolerance (or 0.01 Gram/Milliliter, whichever is greater): The mass/volume that the desiccant is allowed to deviate from the requested Amount when fulfilling the sample, because ExactAmount is True. Desiccant can rarely be a liquid, like concentrated Sulfuric acid *)
			Tolerance -> Max[0.1 * desiccantAmount, If[VolumeQ[desiccantAmount], 0.01 Milliliter, 0.01 Gram]],
			RentContainer -> True,
			AutomaticDisposal -> False
		]]
	];

	(* DesiccantStorageContainer resource if not Null *)
	desiccantStorageContainerResources = If[
		NullQ[desiccantStorageContainer],
		Null,
		Link[Resource[
			Sample -> desiccantStorageContainer,
			Name -> CreateUniqueLabel["Desiccant Storage Container Container "]
		]]
	];

	(* SampleContainer resource if not Null *)
	sampleContainerResources = If[
		NullQ[#1],
		Null,
		Link[Resource[
			Sample -> #,
			Name -> CreateUniqueLabel["Sample Container "]
		]]
	]& /@ sampleContainer;

	(* --- Resources for Grind --- *)
	(*GrindingContainer Resources*)
	grindingContainerResources = Map[If[NullQ[#], Null,
		Resource[Sample -> #, Name -> CreateUniqueLabel["Grinding Container "]]]&,
		grindingContainer
	];

	(*merge the grinding beads and amounts together*)
	beadsAndNumbers = MapThread[If[NullQ[#1], Nothing,
		Download[#1, Object] -> #2]&, {grindingBead, numberOfGrindingBeads}
	];
	mergedBeadsAndNumbers = Merge[beadsAndNumbers, Total];

	(*make resource replace rules for the beads, but not yet index matching*)
	grindingBeadResourceRules = KeyValueMap[
		#1 -> Resource[Sample -> #1, Amount -> #2, Name -> ToString[Unique[]]]&,
		mergedBeadsAndNumbers
	];

	(*GrindingBead resources with the replace rules we made above*)
	grindingBeadResources = Download[grindingBead, Object] /. grindingBeadResourceRules;

	(* --- Melting Point Measurement Resources --- *)
	(*number of capillaries needed for each sample*)
	capillaryNumbers = MapThread[If[TrueQ[#1], 0, #2]&,
		{prepackedQ, numberOfReplicates /. {Null -> 1}}];

	(*Names for capillary resources*)
	capillaryResourceNames = Table[CreateUniqueLabel["Capillary "], Plus @@ capillaryNumbers];

	(*Capillary resources*)
	capillaryResources = If[
		MatchQ[capillaryResourceNames, {}], Null,
		Link[Resource[Sample -> meltingPointCapillary, Name -> #]]& /@ capillaryResourceNames
	];

	(* Rod resources *)
	capillaryRodResources = If[NullQ[capillaryResources], Null, Resource[Sample -> First[capillaryRod]]];

	(*packing device resource*)
	packingDevices = Lookup[Cases[fastAssoc, ObjectP[Model[Instrument, PackingDevice]]], Object];
	packingDevice = First[packingDevices];

	packingDeviceResource = If[
		Total[capillaryNumbers] > 0,
		Link[Resource[Instrument -> packingDevice, Time -> Total[capillaryNumbers] * 5Minute]],
		Null
	];

	(*if SealCapillary is True, HemataSeal is needed. HemataSeal is a polymer clay used to seal capillaries*)
	capillarySealResource = Link[Resource[Sample -> capillarySeal, Name -> ToString[Unique[]]]];

	(*Capillary Seal resources*)
	capillarySealResources = Map[If[#, capillarySealResource, Null]&, sealCapillary];

	grindingContainerModel = If[
		MatchQ[#, ObjectP[Object]],
		fastAssocLookup[fastAssoc, #, Model],
		#
	]& /@ grindingContainer;

	instrumentModel = If[
		MatchQ[instrument, ObjectP[Object]],
		fastAssocLookup[fastAssoc, instrument, Model],
		instrument
	];

	(*-----------------------------------------------*)
	(*-----------------------------------------------*)
	(*-------Sample Preparation UnitOperations-------*)
	(*-----------------------------------------------*)
	(*-----------------------------------------------*)

	(* samples may need to be desiccated or ground before being used for measuring melting point *)
	(* the following code block determines the samples that should be desiccated or ground, as well as the operation order *)
	(*
		These are all possible cases for Grind and Desiccate steps:
	 	1. No desiccate, No Grind
	 	2. Only Desiccate
	 	3. Only Grind
	 	4. First Desiccate, Then Grind
	 	5. First Grind some sample, Then Desiccate all samples, Then Grind some other samples

	 	depending on the containers that the samples are in and containers that are specified for desiccation and grinding, Transfer UOs may be used as well.

	 *)

	(* input samples that are not already prepacked into a capillary *)
	notPrepackedInputSamples = PickList[ToList[mySamples], prepackedQ, False];

	(* input container models *)
	simulatedSampleContainerModels = Download[fastAssocLookup[fastAssoc, simulatedSampleContainers, Model], Object];


	(**********************************************)
	(**** variables related to the first grind ****)
	(**********************************************)

	(* A list of booleans to determine which samples should be ground first (before desiccate) *)
	(* grind1Qs is True only for samples that are not prepacked. If the sample is prepacked but Grind is set to True, an error will be thrown and grind1Qs still will be False *)
	grind1Qs = MapThread[TrueQ[#1] && (!TrueQ[#2] || MatchQ[#3, ({Grind, _} | Null)])&, {realGrindQs, realDesiccateQs, orderOfOperations}];

	(* not-prepacked samples that should be ground first *)
	grind1Samples = PickList[ToList[mySamples], grind1Qs];
	numberOfGrind1Samples = Length[grind1Samples];

	(*option names that are use in this experiment for Grind*)
	grindOptionNames = {
		Amount, BulkDensity, CoolingTime, Fineness, GrinderType, GrindingBead,
		GrindingContainer, GrindingProfile, GrindingRate, Grinder,
		NumberOfGrindingBeads, NumberOfGrindingSteps, SampleLabel, GrindingTime};

	(*Values of Grind options*)
	grindOptions = Lookup[Join[myResolvedOptions, myUnresolvedOptions], grindOptionNames];

	(*grind option values for samples that should be ground first (before desiccate). In MM12, Transpose[{}] = error, so {} should be replaced with {{}, {}} *)
	grind1Options = Transpose[PickList[Transpose[grindOptions], grind1Qs] /. {} -> {{}, {}}];

	(*grind option rules for samples that should be ground first (before desiccate). In MM12, Transpose[{}] = error, so {} should be replaced with {{}, {}} *)
	grind1OptionRules = If[NullQ[grind1Options /. {{} -> Null}], Null,
		MapThread[Rule, {grindOptionNames /. {Grinder -> Instrument, GrindingTime -> Time}, grind1Options /. {} -> {{}, {}}}]
	];

	(****************************************)
	(**** variables related to desiccate ****)
	(****************************************)

	(*Samples that should be desiccated*)
	desiccateSamples = PickList[ToList[mySamples], realDesiccateQs];
	numberOfDesiccateSamples = Length[desiccateSamples];

	(***********************************************)
	(**** variables related to the second grind ****)
	(***********************************************)

	(* grind2Qs is True only for samples that are not prepacked. If the sample is prepacked but Grind is set to True, an error will be thrown and grind2Qs still will be False *)
	grind2Qs = MapThread[TrueQ[#1] && TrueQ[#2] && MatchQ[#3, ({_, Grind} | Null)]&, {realGrindQs, realDesiccateQs, orderOfOperations}];

	(*Samples that should be ground second*)
	grind2Samples = PickList[ToList[mySamples], grind2Qs];
	numberOfGrind2Samples = Length[grind2Samples];

	(*grind options for samples that should be ground second (after desiccate). In MM12, Transpose[{}] = error, so {} should be replaced with {{}, {}}  *)
	grind2Options = Transpose[PickList[Transpose[grindOptions], grind2Qs] /. {} -> {{}, {}}];

	(*grind option rules for samples that should be ground second (after desiccate), In MM12, Transpose[{}] = error, so {} should be replaced with {{}, {}} *)
	grind2OptionRules = If[NullQ[grind2Options /. {{} -> Null}], Null,
		MapThread[Rule, {grindOptionNames /. {Grinder -> Instrument, GrindingTime -> Time}, grind2Options /. {} -> {{}, {}}}]
	];


	(***************************)
	(**** Desiccate Options ****)
	(***************************)

	(*Non-index matching option names that are use in this experiment for Desiccate*)
	nonIndexMatchedDesiccateOptionNames = {Desiccant, CheckDesiccant, DesiccantAmount, DesiccantPhase, Desiccator, DesiccationTime, DesiccantStorageCondition, DesiccantStorageContainer, DesiccationMethod};

	(*Index matching option names that are use in this experiment for Desiccate*)
	indexMatchedDesiccateOptionNames = {Amount, SampleContainer, SampleContainerLabel, SampleLabel};

	(*Values of Non-index matching Desiccate options*)
	nonIndexMatchedDesiccateOptions = Lookup[Join[myResolvedOptions, myUnresolvedOptions], nonIndexMatchedDesiccateOptionNames];

	(*NonIndexMatched desiccate option rules for samples that should be desiccated *)
	desiccateNonIndexMatchedOptionRules = If[NullQ[nonIndexMatchedDesiccateOptions /. {{} -> Null}], Null,
		MapThread[Rule, {nonIndexMatchedDesiccateOptionNames /. {DesiccationTime -> Time, DesiccationMethod -> Method}, nonIndexMatchedDesiccateOptions}]
	];

	(*Values of index matching Desiccate options*)
	indexMatchedDesiccateOptions = Lookup[Join[myResolvedOptions, myUnresolvedOptions], indexMatchedDesiccateOptionNames];

	(*Values of index matching Desiccate options for samples that should be desiccated. In MM12, Transpose[{}] = error, so {} should be replaced with {{}, {}} *)
	desiccateIndexMatchedOptions = Transpose[PickList[Transpose[indexMatchedDesiccateOptions], realDesiccateQs] /. {} -> {{}, {}}];

	(*IndexMatched desiccate option rules for samples that should be desiccated *)
	desiccateIndexMatchedOptionRules = If[NullQ[desiccateIndexMatchedOptions /. {{} -> Null}], {},
		MapThread[Rule, {indexMatchedDesiccateOptionNames, desiccateIndexMatchedOptions}]
	];


	(*******************************************)
	(**** Explicit Transfer Unit Operations ****)
	(*******************************************)

	(* Grind and Desiccate rely on implicit Transfer triggered by Resource Generation when needed; however, when Grind or Desiccate are created as subprotocols inside a protocol by UOs, Resource Generation does not create the necessary Transfer protocols, therefore, an explicit generation of Transfer protocols is needed when for transferring SamplesIn into GrindingContainer or SampleContainer when needed. *)

	(* Transfers needed for SamplesIn for first Grind *)
	transfer1Qs = MapThread[
		If[
			(*
				no need to do Transfer1 for a sample if:
			 	1. the sample is not going through the first grind experiment
			 	2. the grinding container that is going to be used in the first grind experiment is the same as the sample's current container or its model and amount is All
			*)
			!TrueQ[#1] || (MatchQ[#2, ObjectP[{#3, #4}]] && MatchQ[#5, All]),
			False,
			True
		]&,
		{grind1Qs, grindingContainer, simulatedSampleContainers, simulatedSampleContainerModels, amount}
	];

	(* Transfers needed for SamplesIn that are going to be desiccated *)
	transfer2Qs = MapThread[
		Function[{grind1Q, desiccateQ, desiccateSampleContainer, sampleInContainer, SampleInContainerModels, sampleAmount},
			If[
				Or[
					(* if the sample is not desiccated, no need to transfer *)
					!TrueQ[desiccateQ],
					(* if the sample is first ground then desiccated, DesiccantContainer option will be determined in Grind UO using ContainerOut, so no need to transfer here *)
					TrueQ[grind1Q] && TrueQ[desiccateQ],
					(* if the SampleContainer is Null, no need to transfer. the sample will be desiccated in its current container *)
					NullQ[desiccateSampleContainer],
					(* if the specified SampleContainer matches the current SamplesIn container or its model and amount is All no need to transfer *)
					MatchQ[sampleInContainer, ObjectP[{SampleInContainerModels, desiccateSampleContainer}]] && MatchQ[sampleAmount, All]
				],
				False,
				True
			]
		],
		{grind1Qs, realDesiccateQs, sampleContainer, simulatedSampleContainers, simulatedSampleContainerModels, amount}
	];

	(* Transfers needed for SamplesIn for second Grind. *)
	transfer3Qs = MapThread[
		Function[{desiccateQ, grind2Q, grind2SampleInContainer, grindSampleInContainerModels, grindSampleContainer},
			If[
				Or[
					(* if the sample is not ground after desiccation, no need to transfer *)
					!TrueQ[grind2Q],
					(* if the sample was desiccated and it is going to be ground, GrindingContainer will be determined in Desiccate UO, so transfer2Qs is False if the sample is desiccated then ground *)
					TrueQ[desiccateQ] && TrueQ[grind2Q],
					(* if the specified GrindingContainer matches the current SamplesIn container or its model, no need to transfer *)
					MatchQ[grind2SampleInContainer, ObjectP[{grindSampleInContainerModels, grindSampleContainer}]]
				],
				False,
				True
			]
		],
		{realDesiccateQs, grind2Qs, sampleContainer, simulatedSampleContainers, simulatedSampleContainerModels}
	];

	(* labels for SamplesIn for different processes for tracking purposes *)
	(*
	 	there are a maximum of 6 processes that need labels for samples:
	 	Transfer 1,	Grind 1, Transfer 2, Desiccate, Transfer 3, Grind 2
	 	By determining the process number, a suitable pre-determined label is used for SamplesIn and SamplesOut in UOs
	 *)
	(* format: {{sample1 -> "label1 1", sample1 -> "label1 2", ..., sample1 -> "label1 6"}, ...} *)
	samplesInLabels = Join[{# -> #}, Table[# -> CreateUniqueLabel[ToString[#]], 6]] & /@ ToList[mySamples];

	(* the processes that each sample goes through. A list of Booleans for each sample *)
	processesQ = Transpose @ {transfer1Qs, grind1Qs, transfer2Qs, realDesiccateQs, transfer3Qs, grind2Qs};

	(* this function finds the correct sample labels for each primitive *)
	labelFinder[processNumber_Integer] := Module[{actualPositions, lastProcessNumbers},

		(* the number of the processes that the sample was used in. For example, if transfer1, grind1, and transfer2 are done but sample1 was transferred at Transfer1 and ground at Grind1 but did not participate in Transfer2, the actual position for sample1 would be {{1},{2} *)
		(* any sample not participated at any processes has an actualPosition of {{0}} *)
		actualPositions = (Position[#, True] /. {{} -> {{0}}}) & /@ (processesQ[[All, 1 ;; processNumber]]);

		(* the number of the last process that each sample was used in *)
		lastProcessNumbers = Max /@ (Sequence @@ Flatten[actualPositions, {3}]);

		(* the rule that should be used to replace the input sample object with a label *)
		MapThread[#1[[#2 + 1]] &, {samplesInLabels, lastProcessNumbers}]
	];

	(********************************************)
	(**** sample preparation unit operations ****)
	(********************************************)
	rawPreparationUnitOperations = {
		If[
			!MemberQ[transfer1Qs, True],
			Nothing,
			Transfer[
				Source -> PickList[ToList[mySamples], transfer1Qs],
				Destination -> PickList[grindingContainer, transfer1Qs],
				Amount -> PickList[numericAmount, transfer1Qs],
				DestinationLabel -> PickList[ToList[mySamples], transfer1Qs] /. samplesInLabels[[All, 2]]
			]
		],
		If[
			!MemberQ[grind1Qs, True],
			Nothing,
			Grind[
				Sample -> PickList[ToList[mySamples], grind1Qs] /. labelFinder[1],
				SampleOutLabel -> PickList[ToList[mySamples], grind1Qs] /. samplesInLabels[[All, 3]],
				Sequence @@ Normal@KeyDrop[grind1OptionRules, {SampleOutLabel, SampleLabel}],
				ContainerOut -> MapThread[Which[
					!TrueQ[#1], Nothing,
					TrueQ[#2], #3,
					True, Automatic
				]&, {grind1Qs, realDesiccateQs, sampleContainer}]
			]
		],
		If[
			!MemberQ[transfer2Qs, True],
			Nothing,
			Transfer[
				Source -> PickList[ToList[mySamples], transfer2Qs] /. labelFinder[2],
				Destination -> PickList[sampleContainer, transfer2Qs],
				Amount -> PickList[numericAmount, transfer2Qs],
				DestinationLabel -> PickList[ToList[mySamples], transfer2Qs] /. samplesInLabels[[All, 4]]
			]
		],
		If[
			!MemberQ[realDesiccateQs, True],
			Nothing,
			Desiccate[
				Sample -> PickList[ToList[mySamples], realDesiccateQs] /. labelFinder[3],
				SampleOutLabel -> PickList[ToList[mySamples], realDesiccateQs] /. samplesInLabels[[All, 5]],
				Sequence @@ Normal@KeyDrop[desiccateNonIndexMatchedOptionRules, SampleOutLabel],
				(* Since samples have already been moved if needed in the previous step, we don't need to include SampleContainer and Amount here. Otherwise, ExperimentDesiccate might trigger an additional transfer round. *)
				Sequence @@ Normal@KeyDrop[desiccateIndexMatchedOptionRules, {SampleLabel, SampleContainer, Amount}],
				ContainerOut -> MapThread[Which[
					!TrueQ[#1], Nothing,
					TrueQ[#2], #3,
					True, Null
				]&, {realDesiccateQs, grind2Qs, grindingContainer}]
			]
		],
		If[
			!MemberQ[transfer3Qs, True],
			Nothing,
			Transfer[
				Source -> PickList[ToList[mySamples], transfer3Qs] /. labelFinder[4],
				Destination -> PickList[grindingContainer, transfer3Qs],
				Amount -> PickList[numericAmount, transfer3Qs],
				DestinationLabel -> PickList[ToList[mySamples], transfer3Qs] /. samplesInLabels[[All, 6]]
			]
		],
		If[
			!MemberQ[grind2Qs, True],
			Nothing,
			Grind[
				Sample -> PickList[ToList[mySamples], grind2Qs] /. labelFinder[5],
				Sequence @@ Normal@KeyDrop[grind2OptionRules, {SampleOutLabel, SampleLabel}]
			]
		]
	};

	(* change the format of GrindingProfile to match GrindingProfile option pattern  *)
	preparationUnitOperations = rawPreparationUnitOperations /. {
		({Grinding, rate : RPMP | FrequencyP, time : TimeP} :> {rate, time}),
		({Cooling, rate_, time : TimeP} :> {time})
	};

	(*------------------------------------------------------*)
	(*-------End of Sample Preparation UnitOperations-------*)
	(*------------------------------------------------------*)

	(* group relevant options into batches *)
	(* NOTE THAT I HAVE TO REPLICATE THIS CODE TO SOME DEGREE IN grindPopulateWorkingSamples SO IF THE LOGIC CHANGES HERE CHANGE IT THERE TOO*)
	groupedOptions = Experiment`Private`groupByKey[
		{
			(*General*)
			Sample -> Link /@ samplesInResources,
			WorkingSample -> Link /@ ToList[mySamples],
			OrderOfOperations -> orderOfOperations,
			ExpectedMeltingPoint -> expectedMeltingPoint,
			NumberOfReplicates -> numberOfReplicates,
			Amount -> numericAmount,
			SampleLabel -> sampleLabel,
			SampleContainerLabel -> sampleContainerLabel,
			PreparedSampleLabel -> preparedSampleLabel,

			(*Grind*)
			Grind -> grindQs,
			GrinderType -> grinderType,
			Grinder -> grinderResources,
			Fineness -> fineness,
			BulkDensity -> bulkDensity,
			GrindingContainer -> grindingContainerResources,
			GrindingBead -> grindingBeadResources,
			NumberOfGrindingBeads -> numberOfGrindingBeads,
			GrindingRate -> grindingRate,
			GrindingTime -> grindingTime,
			NumberOfGrindingSteps -> numberOfGrindingSteps,
			CoolingTime -> coolingTime,
			GrindingProfile -> grindingProfile,

			(*Desiccate*)
			Desiccate -> desiccateQs,
			SampleContainer -> sampleContainerResources,

			(*MeltingPointCapillary Packing*)
			Prepacked -> prepackedQ,
			SealCapillary -> sealCapillary,
			Seals -> capillarySealResources,
			NumberOfCapillaries -> capillaryNumbers,

			(*Measurement*)
			StartTemperature -> startTemperature,
			EquilibrationTime -> equilibrationTime,
			EndTemperature -> endTemperature,
			TemperatureRampRate -> temperatureRampRate,
			RampTime -> rampTime,
			(*Storage*)
			PreparedSampleStorageCondition -> preparedSampleStorageCondition,
			CapillaryStorageCondition -> capillaryStorageCondition
		},
		{NumberOfReplicates, StartTemperature, EquilibrationTime, EndTemperature, TemperatureRampRate, RampTime, Prepacked}
	];

	(* The melting point instruments can measure three (MP80) or six (MP90) capillaries at the same time. so we need to create BatchedUnitOperations based on NumberOfReplicates. However, the sample preparation procedure in MeasureMeltingPoint procedures has the following restrictions:
	 1. If NumberOfReplicates > 1, there should be only one SamplesIn in the BatchedUnitOperations
	 2. If NumberOfReplicates = 1, there can be multiple SamplesIn in the BatchedUnitOperations (so there is a 1:1 ratio between the SamplesIn and WorkingCapillaries so it can easily loop over both of them.)
	 *)
	numberOfCapillarySlots = fastAssocLookup[fastAssoc, instrumentModel, NumberOfMeltingPointCapillarySlots];

	BatchSamplesByReplicates[groupedOption : {_Rule..}] := Module[
		{
			expandedOptions, mapFriendlyOptions, numberOfSamplesInEachBatch,
			partitionedOptions, collapsedOptions, mergedOptions
		},

		(* if NumberOfReplicates (which is similar to NumberOfCapillaries) is greater than one, put one SampleIn in each batch, otherwise, put as much as numberOfCapillarySlots of the instrument *)
		numberOfSamplesInEachBatch = If[
			(First@Lookup[groupedOption, NumberOfCapillaries] /. Null :> 1) > 1,
			1,
			numberOfCapillarySlots
		];

		(* create 1:1 option->value lists:
			input: {option1 -> {value1, value2, value3}, option2 -> {value4, value5, value6}
			output: {
				{option1 -> value1, option1 -> value2, option1 -> value3},
				{option2 -> value4, option2 -> value5, option2 -> value6}
			}
		*)
		expandedOptions = Thread /@ groupedOption;

		(* create a list of map friendly options *)
		mapFriendlyOptions = Transpose@expandedOptions;

		(* group options up to numberOfCapillarySlots *)
		partitionedOptions = Partition[mapFriendlyOptions, UpTo[numberOfSamplesInEachBatch]];

		(* collapse options *)
		collapsedOptions = Map[Transpose, partitionedOptions];

		(* merge all in one list *)
		mergedOptions = Sequence @@ Normal[Map[Merge[#, Join]&, collapsedOptions]]

	];

	(*group samples in three*)
	sampleGroupedOptions = Map[BatchSamplesByReplicates, groupedOptions[[All, 2]]];

	(* Check point time calculations *)
	samplePrepTime = (2 Hour + Total[mergedGrinderTimes] + desiccationTime /. Null -> 0);
	experimentTime = (1 Hour + totalInstrumentTime);
	postProcessingTime = 2 Hour;
	storageTime = 2 Hour;


	(* Preparing protocol and unitOperationObject packets *)
	(* Preparing unitOperationObject *)
	unitOperationPackets = Map[
		Function[{options},
			Module[{nonHiddenOptions},

				(* Only include non-hidden options from Transfer. *)
				nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, MeasureMeltingPoint]];

				UploadUnitOperation[
					MeasureMeltingPoint @@ ReplaceRule[
						Cases[myResolvedOptions, Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
						{
							(*General*)
							Sample -> Lookup[options, Sample],
							MeasurementMethod -> measurementMethod,
							OrderOfOperations -> Lookup[options, OrderOfOperations],
							ExpectedMeltingPoint -> Lookup[options, ExpectedMeltingPoint],

							(*NumberOfReplicates keeps populating by itself and it is a single field but NumbersOfReplications is a Multiple field so it throws an error trying to put NumbersOfReplicates in NumberOfReplicates. So I set NumberOfReplicates to Null, so it doesn't get populated automatically by a multiple field and throw an error*)
							NumbersOfReplicates -> Lookup[options, NumberOfReplicates],
							NumberOfReplicates -> Null,

							Amount -> Lookup[options, Amount],
							(*Labels*)
							SampleLabel -> Lookup[options, SampleLabel],
							SampleContainerLabel -> Lookup[options, SampleContainerLabel],
							PreparedSampleLabel -> Lookup[options, PreparedSampleLabel],
							(*Grind*)
							Grind -> Lookup[options, Grind],
							GrinderType -> Lookup[options, GrinderType],
							Grinder -> Lookup[options, Grinder],
							Fineness -> Lookup[options, Fineness],
							BulkDensity -> Lookup[options, BulkDensity],
							GrindingContainer -> Lookup[options, GrindingContainer],
							GrindingBead -> Lookup[options, GrindingBead],
							NumberOfGrindingBeads -> Lookup[options, NumberOfGrindingBeads],
							GrindingRate -> Lookup[options, GrindingRate],
							GrindingTime -> Lookup[options, GrindingTime],
							NumberOfGrindingSteps -> Lookup[options, NumberOfGrindingSteps],
							CoolingTime -> Lookup[options, CoolingTime],
							GrindingProfile -> Lookup[options, GrindingProfile],
							(*Desiccate*)
							Desiccate -> Lookup[options, Desiccate],
							SampleContainer -> Lookup[options, SampleContainer],
							(*Desiccate single fields*)
							DesiccationMethod -> desiccationMethod,
							Desiccant -> desiccantResources,
							CheckDesiccant -> checkDesiccant,
							DesiccantPhase -> desiccantPhase,
							DesiccantAmount -> desiccantAmount,
							DesiccantStorageContainer -> desiccantStorageContainerResources,
							Desiccator -> desiccatorResources,
							DesiccationTime -> desiccationTime,
							(*Sample preparation UO*)
							SamplePreparationUnitOperations -> preparationUnitOperations,
							(*Packing*)
							Prepacked -> Lookup[options, Prepacked],
							SealCapillary -> Lookup[options, SealCapillary],
							CapillaryResource -> Flatten@Lookup[options, CapillaryResource],
							NumberOfCapillaries -> Lookup[options, NumberOfCapillaries],
							Seals -> Lookup[options, Seals],
							(*Measurement*)
							Instrument -> Link[instrument],
							StartTemperature -> Lookup[options, StartTemperature],
							EquilibrationTime -> Lookup[options, EquilibrationTime],
							EndTemperature -> Lookup[options, EndTemperature],
							TemperatureRampRate -> Lookup[options, TemperatureRampRate],
							RampTime -> Lookup[options, RampTime],
							(*Storage*)
							DesiccantStorageCondition -> desiccantStorageCondition,
							PreparedSampleStorageCondition -> Lookup[options, PreparedSampleStorageCondition],
							CapillaryStorageCondition -> Lookup[options, CapillaryStorageCondition]
						}
					],
					UnitOperationType -> Batched,
					FastTrack -> True,
					Upload -> False
				]
			]
		],
		sampleGroupedOptions
	];

	(*---Generate the protocol packet---*)
	protocolPacket = Join[
		<|
			Object -> CreateID[Object[Protocol, MeasureMeltingPoint]],
			Type -> Object[Protocol, MeasureMeltingPoint],
			Replace[SamplesIn] -> Map[Link[#, Protocols]&, samplesInResources],
			Replace[ContainersIn] -> Map[Link[#, Protocols]&, containersInResources],
			(*General*)
			Replace[OrdersOfOperations] -> orderOfOperations,
			MeasurementMethod -> measurementMethod,
			Replace[ExpectedMeltingPoints] -> expectedMeltingPoint,
			Replace[NumbersOfReplicates] -> numberOfReplicates,
			Replace[Amounts] -> numericAmount,
			Rod -> capillaryRodResources,
			(*Labels*)
			Replace[SampleLabels] -> sampleLabel,
			Replace[SampleContainerLabels] -> sampleContainerLabel,
			Replace[PreparedSampleLabels] -> preparedSampleLabel,
			(*Grind*)
			Replace[Grind] -> grindQs,
			Replace[GrinderTypes] -> grinderType,
			Replace[Grinders] -> grinderResources,
			Replace[Finenesses] -> fineness,
			Replace[BulkDensities] -> bulkDensity,
			Replace[GrindingContainers] -> grindingContainerResources,
			Replace[GrindingBeads] -> grindingBeadResources,
			Replace[NumbersOfGrindingBeads] -> numberOfGrindingBeads,
			Replace[GrindingRates] -> grindingRate,
			Replace[GrindingTimes] -> grindingTime,
			Replace[NumbersOfGrindingSteps] -> numberOfGrindingSteps,
			Replace[CoolingTimes] -> coolingTime,
			Replace[GrindingProfiles] -> grindingProfile,
			(*Desiccate*)
			Replace[Desiccate] -> desiccateQs,
			Replace[SampleContainers] -> sampleContainerResources,
			DesiccationMethod -> desiccationMethod,
			Desiccant -> desiccantResources,
			CheckDesiccant -> checkDesiccant,
			DesiccantPhase -> desiccantPhase,
			DesiccantAmount -> desiccantAmount,
			DesiccantStorageContainer -> desiccantStorageContainerResources,
			Desiccator -> desiccatorResources,
			DesiccationTime -> desiccationTime,
			(*Sample preparation UO*)
			Replace[SamplePreparationUnitOperations] -> preparationUnitOperations,
			(*Packing*)
			Replace[Prepacked] -> prepackedQ,
			Replace[SealCapillary] -> sealCapillary,
			Replace[Seals] -> capillarySealResources,
			Replace[CapillaryResource] -> capillaryResources,
			Replace[NumberOfCapillaries] -> capillaryNumbers,
			PackingDevice -> packingDeviceResource,
			(*Measurement*)
			Instrument -> instrumentResources,
			Replace[StartTemperatures] -> startTemperature,
			Replace[EquilibrationTimes] -> equilibrationTime,
			Replace[EndTemperatures] -> endTemperature,
			Replace[TemperatureRampRates] -> temperatureRampRate,
			Replace[RampTimes] -> rampTime,
			(*Storage*)
			DesiccantStorageCondition -> desiccantStorageCondition /. x:ObjectP[] :> Link[x],
			Replace[PreparedSampleStorageConditions] -> preparedSampleStorageCondition /. x:ObjectP[] :> Link[x],
			Replace[CapillaryStorageConditions] -> capillaryStorageCondition,

			(* Post-processing options *)
			ImageSample -> Lookup[myResolvedOptions, ImageSample],
			MeasureWeight -> Lookup[myResolvedOptions, MeasureWeight],
			MeasureVolume -> Lookup[myResolvedOptions, MeasureVolume],

			UnresolvedOptions -> myUnresolvedOptions,
			ResolvedOptions -> myResolvedOptions,
			Replace[Checkpoints] -> {
				{"Resource Picking and Sample Preparation", samplePrepTime, "Samples are gathered from storage and processed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> samplePrepTime]]},
				{"Running Experiment", experimentTime, "Melting points of samples are measured.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> experimentTime]]},
				{"Post-Processing", postProcessingTime, "Any volume/weight measurement or imaging of samples are performed post experiment.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> postProcessingTime]]},
				{"Returning Materials", storageTime, "Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> storageTime]]}
			},
			Replace[BatchedUnitOperations] -> (Link[#, Protocol]&) /@ ToList[Lookup[unitOperationPackets, Object]]
		|>
	];

	(*generate a packet with the shared fields*)
	sharedFieldPacket = populateSamplePrepFields[ToList[mySamples], myResolvedOptions, Cache -> cache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Simulation -> updatedSimulation, Site -> Lookup[myResolvedOptions, Site], SkipSampleMovementWarning -> samplesToSkip,Cache -> cache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Simulation -> updatedSimulation, Messages -> messages, Site -> Lookup[myResolvedOptions, Site], SkipSampleMovementWarning -> samplesToSkip, Cache -> cache], Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule = Preview -> Null;

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[ExperimentMeasureMeltingPoint, myResolvedOptions],
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		{finalizedPacket, unitOperationPackets},
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}
];

(* ::Subsection::Closed:: *)
(*simulateExperimentMeasureMeltingPoint*)

DefineOptions[
	simulateExperimentMeasureMeltingPoint,
	Options :> {CacheOption, SimulationOption, ParentProtocolOption}
];

simulateExperimentMeasureMeltingPoint[
	myProtocolPacket : PacketP[Object[Protocol, MeasureMeltingPoint]] | $Failed | Null,
	myUnitOperationPackets : {PacketP[Object[UnitOperation, MeasureMeltingPoint]]..} | $Failed,
	mySamples : {ObjectP[Object[Sample]]...},
	myResolvedOptions : {_Rule...},
	myResolutionOptions : OptionsPattern[simulateExperimentMeasureMeltingPoint]
] := Module[
	{
		amount, cache, capillarySourceSample, capillaryNumbers, capillaryResourceNames, capillaryResources, currentSimulation,
		desiccateQs, fastAssoc, grindQs, inputSampleContainers, inputSampleModel, mapThreadFriendlyOptions, meltingPointCapillaries,
		meltingPointCapillary, newSamplePackets, numberOfReplicates, numericAmount, prepackedQ, preparedSampleObject, preparedSampleLabel,
		protocolObject, sampleContainerLabel, sampleContainer, sampleContainerResources, sampleLabel, samplesInResources,
		sealCapillary, simulatedCapillaryDestination, simulatedCapillaryObjects, simulatedNewSamples, simulatedPreparedSampleDestination,
		simulatedSampleContainer, simulation, simulationWithLabels, sourceSamplePackets, uploadSampleTransferPackets,
		simulatedGrindingContainerResources, simulatedPreparedSampleContainer, preparedSampleSources, preparedSampleQs, newSampleDestinations,
		grindingContainer, simulatedSampleContainers, simulatedGrindingContainers
	},

	(* Lookup our cache and simulation and make our fast association *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
	fastAssoc = makeFastAssocFromCache[cache];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = Which[
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myProtocolPacket, $Failed],
			SimulateCreateID[Object[Protocol, MeasureMeltingPoint]],

		True,
			Lookup[myProtocolPacket, Object]
	];

	(* lookup some option values*)
	{
		(*3*)numberOfReplicates,
		(*4*)amount,
		(*5*)preparedSampleLabel,
		(*7*)grindQs,
		(*20*)desiccateQs,
		(*21*)sampleContainer,
		(*28*)sealCapillary,
		(*40*)sampleLabel,
		(*41*)sampleContainerLabel,
		grindingContainer
	} = Lookup[
		myResolvedOptions,
		{
			(*3*)NumberOfReplicates,
			(*4*)Amount,
			(*5*)PreparedSampleLabel,
			(*7*)Grind,
			(*20*)Desiccate,
			(*21*)SampleContainer,
			(*28*)SealCapillary,
			(*40*)SampleLabel,
			(*41*)SampleContainerLabel,
			GrindingContainer
		}
	];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
		ExperimentMeasureMeltingPoint,
		myResolvedOptions
	];

	(* NOTE: The following is code from the resource packets function. It should be kept in sync. *)
	(* We basically just run the part of the resource packets function here that we can be sure is error-proof. *)

	(*capillary model*)
	meltingPointCapillaries = DeleteDuplicates@Lookup[
		Cases[fastAssoc, ObjectP[Model[Container, Capillary]]], Object
	];

	meltingPointCapillary = First[meltingPointCapillaries];

	(* Download containers from our sample packets. *)
	{
		sourceSamplePackets
	} = Download[
		{
			mySamples
		},
		Cache -> cache,
		Simulation -> simulation
	];

	sourceSamplePackets = Flatten[sourceSamplePackets];

	(*Determine samples that are prepacked in capillary tubes*)
	inputSampleContainers = Lookup[#, Container]& /@ sourceSamplePackets;

	prepackedQ = Map[If[
		MatchQ[#1, ObjectP[Object[Container, Capillary]]], True, False
	]&, inputSampleContainers];

	preparedSampleQs = MapThread[!#1 && MemberQ[{#2, #3}, ObjectP[]] &, {prepackedQ, sampleContainer, grindingContainer}];

	(* --- Make resources needed in the simulation --- *)
	(*Update amount value to quantity if it is resolved to All*)
	numericAmount = MapThread[
		Which[
			TrueQ[#1] && MatchQ[#2, All], fastAssocLookup[fastAssoc, #3, Mass],
			TrueQ[#1] && MatchQ[#2, Null], 1 Gram,
			TrueQ[#1], #2,
			True, Null
		]&,
		{preparedSampleQs, amount, ToList[mySamples]}
	];

	(*SampleIn Resources: if the sample is prepacked, its container (capillary tube) is used for resources. If the sample is not prepacked, it is treated normally*)
	samplesInResources = MapThread[If[TrueQ[#1] || NullQ[#4],
		Resource[Sample -> #2, Name -> #3],
		Resource[Sample -> #2, Name -> #3, Amount -> #4]]&,
		{prepackedQ, ToList[mySamples], sampleLabel, numericAmount}
	];

	(* --- Melting Point Measurement Resources --- *)
	(*number of capillaries needed for each sample*)
	capillaryNumbers = MapThread[If[TrueQ[#1], 0, #2]&,
		{prepackedQ, numberOfReplicates /. {Null -> 1}}];

	(*Names for capillary resources*)
	capillaryResourceNames = ConstantArray[CreateUniqueLabel["Capillary "], #]& /@ capillaryNumbers;

	(*Capillary resources*)
	capillaryResources = Flatten@Map[
		If[
			Length[#] < 1, Null,
			(Map[Link[Resource[Sample -> meltingPointCapillary, Name -> #]]&, #])]&,
		capillaryResourceNames
	];

	(* SampleContainer resource if not Null *)
	sampleContainerResources = If[
		NullQ[#1],
		Null,
		Link[Resource[Sample -> #, Name -> CreateUniqueLabel["Simulation SampleContainer "]]]]& /@ sampleContainer;

	(* --- Resources for PreparedSample --- *)
	simulatedGrindingContainerResources = If[
		!NullQ[#],
		Resource[Sample -> PreferredContainer[#], Name -> CreateUniqueLabel["Simulation preparedSampleContainerLabel "]],
		Null
		]& /@ numericAmount;

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation = If[

		(* If we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
		(* and skipped resource packet generation. *)
		MatchQ[myProtocolPacket, $Failed],
		Module[
			{
				simulatedUnitOperationIDs, measureMeltingPointUnitOperationPackets, protocolPacket
			},

			(* Simulate the creation of MeasureMeltingPoint UnitOperation IDs. *)
			simulatedUnitOperationIDs = SimulateCreateID[ConstantArray[Object[UnitOperation, MeasureMeltingPoint], Length[sourceSamplePackets]]];


			(* Make UnitOperations packets for the MeasureMeltingPoint. *)
			(* NOTE: Once again this is an excerpt from the resource packets function, just for the important fields that *)
			(* are error proof. *)
			measureMeltingPointUnitOperationPackets = MapThread[
				Function[{sourcePacket, options, unitOperationID},
					With[{sampleLabel = Lookup[options, SampleLabel]},
						<|
							Object -> unitOperationID,
							Protocol -> Link[protocolObject, BatchedUnitOperations],
							Replace[NumbersOfReplicates] -> {Lookup[options, NumberOfReplicates]},
							Replace[AmountVariableUnit] -> {Lookup[options, Amount] /. {All -> Null}},
							Replace[AmountExpression] -> {Lookup[options, Amount] /. {_?QuantityQ -> Null}},
							Replace[PreparedSampleLabel] -> {Lookup[options, PreparedSampleLabel]},
							Replace[Grind] -> {Lookup[options, Grind]},
							Replace[SampleLink] -> {Resource[Sample -> Lookup[sourcePacket, Object], Name -> If[StringQ[sampleLabel], sampleLabel, ToString[Unique[]]]]},
							Replace[SampleLabel] -> {sampleLabel},
							Replace[Desiccate] -> {Lookup[options, Desiccate]},
							Replace[SampleContainer] -> If[
								NullQ[Lookup[options, SampleContainer]], {Null},
								sampleContainerResources
							],
							Replace[SealCapillary] -> {Lookup[options, SealCapillary]},
							Replace[SampleContainerLabel] -> {Lookup[options, SampleContainerLabel]}
						|>
					]
				],
				{
					sourceSamplePackets,
					mapThreadFriendlyOptions,
					simulatedUnitOperationIDs
				}
			];

			(* Make the MeasureMeltingPoint Protocol. *)
			protocolPacket = <|
				Object -> protocolObject,
				Replace[SamplesIn] -> (Resource[Sample -> #]&) /@ mySamples,
				Replace[BatchedUnitOperations] -> (Link[#, Protocol]&) /@ simulatedUnitOperationIDs,
				Replace[SampleContainers] -> sampleContainerResources,
				Replace[CapillaryResource] -> (Link[#]&) /@ capillaryResources,
				(* there is no actual PreparedSampleContainer. The samples that are transferred to another containers and for desiccation and/or grinding purposes are considered PreparedSamples. their containers are determined by SampleContainer and GrindingContainer options *)
				Replace[GrindingContainers] -> (Link[#]&) /@ simulatedGrindingContainerResources,
				ResolvedOptions -> myResolvedOptions
			|>;

			SimulateResources[protocolPacket, measureMeltingPointUnitOperationPackets, Simulation -> simulation]
		],

		(* Otherwise, our resource packets went fine and we have an Object[Protocol, MeasureMeltingPoint]. *)
		SimulateResources[myProtocolPacket, myUnitOperationPackets, ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null], Simulation -> simulation]
	];

	{
		simulatedSampleContainers,
		simulatedGrindingContainers,
		simulatedCapillaryObjects,
		simulatedSampleContainer
	} = Download[protocolObject,
		{
			SampleContainers,
			GrindingContainers,
			CapillaryResource,
			SampleContainers
		},
		Simulation -> currentSimulation
	];

	(*Create new samples for simulating transfer*)
	simulatedPreparedSampleContainer = If[MatchQ[myProtocolPacket, $Failed],
		simulatedGrindingContainers,
		MapThread[If[MatchQ[#1, ObjectP[]], #1, #2]&, {simulatedGrindingContainers, simulatedSampleContainers}]
	];

	(*Add position "A1" to destination containers to create destination locations*)
	simulatedCapillaryDestination = Map[If[NullQ[#], Null, {"A1", #}]&, simulatedCapillaryObjects];

	simulatedPreparedSampleDestination = Map[If[NullQ[#], Null, {"A1", #}]&, simulatedPreparedSampleContainer];

	(*Models of input samples*)
	inputSampleModel = If[MatchQ[#, ObjectP[Model[Sample]]], #, fastAssocLookup[fastAssoc, #, Model]]& /@ ToList[mySamples];

	capillaryNumbers = MapThread[If[TrueQ[#1], 0, #2]&,
		{prepackedQ, numberOfReplicates /. {Null -> 1}}];

	(*Models of samples that g o into the capillaries*)
	capillarySourceSample = Flatten@MapThread[ConstantArray[#1, #2]&, {ToList[mySamples], capillaryNumbers}];

	(* prepared samples *)
	preparedSampleSources = MapThread[
		If[
			!NullQ[#1],
			#2,
			Nothing
		]&,
		{numericAmount, ToList[mySamples]}
	];

	newSampleDestinations = DeleteCases[Join[simulatedCapillaryDestination, simulatedPreparedSampleDestination], Null];

	(* create sample out packets for anything that doesn't have sample in it already, this is pre-allocation for UploadSampleTransfer *)
	newSamplePackets = UploadSample[
		(* Note: UploadSample takes in {} if there is no Model and we have no idea what's in it, which is the case here *)
		ConstantArray[{}, Length[newSampleDestinations]],
		newSampleDestinations,
		State -> ConstantArray[Solid, Length[newSampleDestinations]],
		InitialAmount -> ConstantArray[Null, Length[newSampleDestinations]],
		Simulation -> currentSimulation,
		UpdatedBy -> protocolObject,
		FastTrack -> True,
		Upload -> False
	];

	(* update our simulation with new sample packets*)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[newSamplePackets]];

	(*Lookup Object[Sample]s from newSamplePackets*)
	simulatedNewSamples = DeleteDuplicates[Cases[Lookup[newSamplePackets, Object], ObjectReferenceP[Object[Sample]]]];

	(* Call UploadSampleTransfer on our source and destination samples. *)
	uploadSampleTransferPackets = UploadSampleTransfer[
		Join[capillarySourceSample, preparedSampleSources],
		simulatedNewSamples,
		(*here we assume the amount of sample in the capillary is 5 mg. can be updated to a more accurate amount if needed*)
		Join[ConstantArray[5Milligram, Length[capillarySourceSample]], numericAmount /. Null -> Nothing],
		Upload -> False,
		FastTrack -> True,
		Simulation -> currentSimulation,
		UpdatedBy -> protocolObject
	];

	(*update our simulation with UploadSampleTransferPackets*)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[uploadSampleTransferPackets]];

	preparedSampleObject = Flatten@Download[simulatedPreparedSampleContainer, Contents[[All, 2]][Object], Simulation -> currentSimulation];

	(* Uploaded Labels *)
	simulationWithLabels = Simulation[
		Labels -> Join[
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], mySamples}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], simulatedSampleContainer}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, PreparedSampleLabel]], preparedSampleObject}],
				{_String, ObjectP[]}
			]
		],
		LabelFields -> Join[
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], (Field[SampleLink[[#]]]&) /@ Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], (Field[SampleContainer[[#]]]&) /@ Range[Length[simulatedSampleContainer]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, PreparedSampleLabel]], (Field[PreparedSample[[#]]]&) /@ Range[Length[preparedSampleObject]]}],
				{_String, _}
			]
		]
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation, simulationWithLabels]
	}
];



(* ::Subsection::Closed:: *)
(*Define Author for primitive head*)
Authors[MeasureMeltingPoint] := {"mohamad.zandian"};

(* ::Subsection::Closed:: *)
(*ExperimentMeasureMeltingPointOptions*)


DefineOptions[ExperimentMeasureMeltingPointOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}

	},
	SharedOptions :> {ExperimentMeasureMeltingPoint}];

ExperimentMeasureMeltingPointOptions[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentMeasureMeltingPoint *)
	options = ExperimentMeasureMeltingPoint[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentMeasureMeltingPoint],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentMeasureMeltingPointQ*)


DefineOptions[ValidExperimentMeasureMeltingPointQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentMeasureMeltingPoint}
];


ValidExperimentMeasureMeltingPointQ[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
	{listedOptions, preparedOptions, experimentMeasureMeltingPointTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentMeasureMeltingPoint *)
	experimentMeasureMeltingPointTests = ExperimentMeasureMeltingPoint[myInputs, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[experimentMeasureMeltingPointTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[ToList[myInputs], _String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[myInputs], _String], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, experimentMeasureMeltingPointTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentMeasureMeltingPointQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentMeasureMeltingPointQ"]
];

(* ::Subsection::Closed:: *)
(*ExperimentMeasureMeltingPointPreview*)

DefineOptions[ExperimentMeasureMeltingPointPreview,
	SharedOptions :> {ExperimentMeasureMeltingPoint}
];

ExperimentMeasureMeltingPointPreview[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the options for ExperimentMeasureMeltingPoint *)
	ExperimentMeasureMeltingPoint[myInputs, Append[noOutputOptions, Output -> Preview]]];

(* ::Subsection::Closed:: *)
(*meltingPointSearch*)
(* Find everything needed for ExperimentMeasureMeltingPoint *)
(* Memoizes the result after first execution to avoid repeated database trips within a single kernel session.*)
meltingPointSearch[fakeString : _String] := meltingPointSearch[fakeString] = Module[{},
	(*Add allCounterweightsSearch to list of Memoized functions*)
	AppendTo[$Memoization, Experiment`Private`meltingPointSearch];
	Search[
		{
			{Model[Instrument, Desiccator], Model[Instrument, Grinder], Model[Instrument, MeltingPointApparatus], Model[Instrument, PackingDevice]},
			{Object[Instrument, Desiccator], Object[Instrument, Grinder], Object[Instrument, MeltingPointApparatus]},
			{Model[Container, Capillary]},
			{Model[Container, GrindingContainer]},
			{Model[Item, GrindingBead]},
			{Model[Instrument, PackingDevice]},
			{Model[Item, Rod]}
		},
		{
			Deprecated != True && DeveloperObject != True,
			Status != Retired && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			DeveloperObject != True && Deprecated != True,
			DeveloperObject != True && Deprecated != True,
			DeveloperObject != True && Deprecated != True,
			DeveloperObject != True && Deprecated != True && Footprint == CapillaryTube
		}
	]
];