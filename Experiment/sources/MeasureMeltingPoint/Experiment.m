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
			Description -> "Determines the method used to adjust the measured temperatures obtained from the apparatus's temperature sensor. When set to \"Pharmacopeia\", the temperatures are adjusted using Pharmacopeia melting point standards; when set to \"Thermodynamic\", thermodynamic melting point standards are utilized for temperature adjustments. In \"Pharmacopeia\" mode, adjustments are based on experimental measurements following pharmacopeial guidelines. This method neglects the furnace temperature being slightly higher than the sample temperature during heating, leading to dependency on heating rate for comparability. In contrast, \"Thermodynamic\" mode provides a physically accurate melting point that represents the theoretical temperature at which a substance transitions from solid to liquid phase under standard conditions.",
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
				ResolutionDescription -> "Automatically set to {Desiccate, Grind} if both Desiccate and Grind are set to True. Set to {Desiccate} or {Grind} if only one is set to True.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[{Desiccate, Grind}, {Grind, Desiccate}]]
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
						Pattern :> RangeP[25 Celsius, 350 Celsius],
						Units -> Celsius
					]
				]
			},
			{
				OptionName -> NumberOfReplicates,
				Default -> Automatic,
				Description -> "Determines the number of melting point capillaries to be packed with the same sample and read. If the sample is prepacked in a melting point capillary tube, NumberOfReplicates must be set to Null. Otherwise, Null, 2, or 3, respectively, indicate that 1, 2, or 3 capillary tubes are to be packed by the same sample.",
				ResolutionDescription -> "Automatically set to 3 if the sample is not prepacked in a melting point capillary tube.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[2, 3, 1]
				]
			},
			{
				OptionName -> Amount,
				Default -> Automatic,
				Description -> "Determines how much sample to use in this experiment if Grind or Desiccate is True. If Grind is True, Amount determines how much sample to grind into a fine powder via a grinder before packing into a melting point capillary and measuring the melting point. If Desiccate is True, Amount determines how much sample to dry via a desiccator before packing into a melting point capillary and measuring the melting point. If both Grind and Desiccate are True, Amount determines how much sample to grind and desiccate, in the order determined by OrderOfOperations, before packing into a melting point capillary and measuring the melting point. If both Grind and Desiccate are false, the determined Amount is ignored in calculating other options. If Amount is set to Null, the sample is directly transferred to a melting point capillary from its original container without grinding or desiccation.",
				ResolutionDescription -> "Automatically set to 1 Gram or All whichever is less if Desiccate or Grind is True.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Alternatives[
					"Mass" -> Widget[Type -> Quantity, Pattern :> RangeP[0 Gram, $MaxTransferMass], Units -> Gram],
					"All" -> Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
				]
			},
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the input samples, for use in downstream unit operations.",
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
			{
				OptionName -> PreparedSampleContainerLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the The container that the PreparedSample is transferred into after the experiment if RecoupSample is True.",
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
				ResolutionDescription -> "Automatically set to False if the sample is prepacked in a melting point capillary tube. Otherwise set to True.",
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
					Pattern :> GreaterP[0 Millimeter],
					Units -> Millimeter
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
					Pattern :> GreaterP[0 Gram / Milliliter],
					Units -> CompoundUnit[{1, {Gram, {Milligram, Gram, Kilogram}}}, {-1, {Milliliter, {Microliter, Milliliter, Liter}}}]
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
					Pattern :> ObjectP[{Model[Container], Object[Container]}],
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
					Pattern :> GreaterEqualP[1, 1]
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
					"RPM" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[20 RPM, 25000 RPM],
						Units -> RPM
					],
					"Hertz" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.3 Hertz, 420 Hertz],
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
				Category -> "General",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, $MaxExperimentTime],
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
					Pattern :> RangeP[0 Minute, $MaxExperimentTime],
					Units -> {1, {Second, {Second, Minute, Hour}}}
				]
			},
			{
				OptionName -> GrindingProfile,
				Default -> Automatic,
				Description -> "A paired list of time and activities of the grinding process in the form of Activity (Grinding or Cooling), Duration, and GrindingRate.",
				ResolutionDescription -> "Automatically set to reflect the selections of GrindingRate, GrindingTime, NumberOfGrindingSteps, and CoolingTime if Grind is set to True.",
				AllowNull -> True,
				Category -> "Grinding",
				Widget -> Adder[
					{
						"Activity" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Grinding , Cooling]],
						"Rate" -> Widget[Type -> Quantity, Pattern :> RangeP[0 RPM, 25000 RPM], Units -> RPM],
						"Time" -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> {1, {Second, {Second, Minute, Hour}}}]
					}
				]
			},

			(* Desiccation *)
			{
				OptionName -> Desiccate,
				Default -> Automatic,
				Description -> "Determines if the sample is dried (removing water or solvent molecules) via a desiccator or an oven before loading into a capillary and measuring the melting point. Water or solvent molecules can act as an impurity and may affect the observed melting range.",
				ResolutionDescription -> "Automatically set to False if the StorageCondition of the input sample is set to a desiccator or the sample is prepacked into a melting point capillary.",
				AllowNull -> False,
				Category -> "Desiccation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> SampleContainer,
				Default -> Null,
				Description -> "The container that the sample Amount is transferred into prior to desiccating in a bell jar if Desiccate is set to True. The container's lid is off during desiccation.",
				AllowNull -> True,
				Category -> "Desiccation",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container], Object[Container]}],
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
			ResolutionDescription -> "Automatically set to Model[Sample, \"Indicating Drierite\"] if Desiccate is set to True".
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
		{  OptionName -> DesiccantPhase,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The physical state of the desiccant in the desiccator which dries the exposed sample by absorbing water molecules from the sample.",
			ResolutionDescription -> "Automatically set to the physical state of the selected desiccant if Desiccate is set to True.",
			Category -> "General",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Solid, Liquid]
			]
		},

		{  OptionName -> DesiccantAmount,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The mass of a solid or the volume of a liquid hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample before grinding and/or packing the sample into a melting point capillary tube prior to the measurement.",
			ResolutionDescription -> "Automatically set to 100 Gram or Milliliter if Desiccate is set to True and DesiccantPhase is Solid or Liquid.",
			Category -> "Desiccation",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> Alternatives[RangeP[0 Gram, $MaxTransferMass], RangeP[0 Milliliter, $MaxTransferVolume]],
				Units -> Alternatives[Gram, Milliliter]
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
						"Storage Devices",
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
				Pattern :> RangeP[0 Hour, $MaxExperimentTime],
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
			Default -> Model[Instrument, MeltingPointApparatus, "Melting Point System MP80"],
			Description -> "The instrument that is used to measure the melting point of solid substances by applying an increasing temperature gradient to the samples that are packed into capillary tubes and monitoring phase transitions over the course of time.",
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
					Pattern :> RangeP[25 Celsius, 350 Celsius],
					Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}
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
					Pattern :> RangeP[0 Second, 120 Second],
					Units -> {1, {Second, {Second, Minute}}}
				]
			},
			{
				OptionName -> EndTemperature,
				Default -> Automatic,
				Description -> "The final temperature to conclude the temperature sweep of the chamber that holds the capillaries. Typically set to 5 Celsius above the ExpectedMeltingPoint if known.",
				ResolutionDescription -> "Automatically set to 5 Celsius above the ExpectedMeltingPoint. If ExpectedMeltingPoint is set to Unknown, the measurement automatically stops after the sample melts.",
				AllowNull -> True,
				Category -> "Measurement",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[25 Celsius, 350 Celsius],
					Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}
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
					Pattern :> RangeP[0.1 Celsius / Minute, 20 Celsius / Minute],
					Units -> CompoundUnit[{1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}, {-1, {Minute, {Second, Minute, Hour}}}]
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
					Pattern :> RangeP[0 Minute, 3250 Minute],
					Units :> {1, {Minute, {Second, Minute, Hour}}}
				]
			},

			(*Storage Information*)
			{
				OptionName -> RecoupSample,
				Default -> Automatic,
				Description -> "Determines if the PreparedSample remaining after grinding and/or desiccating is retained or discarded after the needed amount of the sample is used for packing into the melting point capillary. If set to True, the remaining sample is retained, otherwise, it is discarded.",
				ResolutionDescription -> "Automatically set to False if Grind or Desiccate is True.",
				AllowNull -> True,
				Category -> "Storage Information",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> PreparedSampleContainer,
				Default -> Automatic,
				Description -> "The container that the PreparedSample remaining after grinding and/or desiccating is transferred into for storage after the completion of experiment if RecoupSample is True.",
				ResolutionDescription -> "Automatically set to the input sample's container if RecoupSample is True.",
				AllowNull -> True,
				Category -> "Storage Information",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container], Object[Container]}]
				]
			},
			{
				OptionName -> PreparedSampleStorageCondition,
				Default -> Null,
				Description -> "The non-default conditions under which the PreparedSample remaining after grinding and/or desiccating is stored after the protocol is completed. If left unset, the PreparedSample will be stored according to the corresponding input sample's StorageCondition.",
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
		Experiment`Private`PreparatoryPrimitivesOption,
		ProtocolOptions,
		SimulationOption,
		PostProcessingOptions
	}
];

(* ::Subsection::Closed:: *)
(* ExperimentMeasureMeltingPoint Errors and Warnings *)
Error::NonSolidSample = "The samples `1` do not have a Solid state and cannot be processed. Please remove these samples from the function input.";
Warning::ExtraneousOrderOfOperations = "OrderOfOperations is to be informed only if both Desiccate and Grind are set to True. Desiccate or Grind are set to False for samples `1`, however, OrderOfOperations is populated extraneously. Therefore, OrderOfOperations was ignored in calculating options for those samples.";
Error::UndefinedOrderOfOperations = "Sample(s) `1` are determined to be desiccated and ground (Desiccate and Grind both set to True), however, OrderOfOperations is set to Null. Please specify OrderOfOperations.";
Error::InvalidDesiccateOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be desiccated, however, Desiccate is set to True for these samples. Please set Desiccate to False for Sample(s) `1`.";
Error::InvalidSampleContainerOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be desiccated, however, SampleContainer is informed for these samples. Please set SampleContainer to Null or let it be calculated automatically for Sample(s) `1`.";
Error::SampleContainerMismatchOptions = "Desiccate is set to False for Sample(s) `1`, however, SampleContainer is informed for these samples. Please set SampleContainer to Null or let it be calculated automatically for Sample(s) `1`.";
Error::InvalidDesiccationMethodOptions = "All input samples are prepacked in melting point capillary tubes, therefore, cannot be desiccated. However, DesiccationMethod is not Null. Please set DesiccationMethod to Null or let it be calculated automatically.";
Error::DesiccationMethodMismatchOptions = "Desiccate is set to False for all samples, however, DesiccationMethod is not Null. Please set DesiccationMethod to Null or let it be calculated automatically.";
Error::InvalidDesiccantOptions = "All input samples are prepacked in melting point capillary tubes, therefore, cannot be desiccated. However, Desiccant is not Null. Please set Desiccant to Null or let it be calculated automatically.";
Error::DesiccantMismatchOptions = "Desiccate is set to False for all samples, however, Desiccant is not Null. Please set Desiccant to Null or let it be calculated automatically.";
Error::InvalidDesiccantPhaseOptions = "All input samples are prepacked in melting point capillary tubes, therefore, cannot be desiccated. However, DesiccantPhase is not Null. Please set DesiccantPhase to Null or let it be calculated automatically.";
Error::DesiccantPhaseMismatchOptions = "Desiccate is set to False for all samples, however, DesiccantPhase is not Null. Please set DesiccantPhase to Null or let it be calculated automatically.";
Error::InvalidDesiccantAmountOptions = "All input samples are prepacked in melting point capillary tubes, therefore, cannot be desiccated. However, DesiccantAmount is not Null. Please set DesiccantAmount to Null or let it be calculated automatically.";
Error::DesiccantAmountMismatchOptions = "Desiccate is set to False for all samples, however, DesiccantAmount is not Null. Please set DesiccantAmount to Null or let it be calculated automatically.";
Error::InvalidDesiccatorOptions = "All input samples are prepacked in melting point capillary tubes, therefore, cannot be desiccated. However, Desiccator is not Null. Please set Desiccator to Null or let it be calculated automatically.";
Error::DesiccatorMismatchOptions = "Desiccate is set to False for all samples, however, Desiccator is not Null. Please set Desiccator to Null or let it be calculated automatically.";
Error::InvalidDesiccationTimeOptions = "All input samples are prepacked in melting point capillary tubes, therefore, cannot be desiccated. However, DesiccationTime is not Null. Please set DesiccationTime to Null or let it be calculated automatically.";
Error::DesiccationTimeMismatchOptions = "Desiccate is set to False for all samples, however, DesiccationTime is not Null. Please set DesiccationTime to Null or let it be calculated automatically.";
Error::InvalidGrindOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be ground, however, Grind is set to True for these samples. Please set Grind to False for Sample(s) `1`.";
Error::InvalidGrinderTypeOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be ground, however, GrinderType is informed for these samples. Please set GrinderType to Null or let it be calculated automatically for Sample(s) `1`.";
Error::GrinderTypeMismatchOptions = "Grind is set to False for Sample(s) `1`, however, a Grind-related option (GrinderType) is informed for these samples. Please set GrinderType to Null or let it be calculated automatically for Sample(s) `1`.";
Error::InvalidGrinderOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be ground, however, Grinder is informed for these samples. Please set Grinder to Null or let it be calculated automatically for Sample(s) `1`.";
Error::GrinderMismatchOptions = "Grind is set to False for Sample(s) `1`, however, a Grind-related option (Grinder) is informed for these samples. Please set Grinder to Null or let it be calculated automatically for Sample(s) `1`.";
Error::InvalidFinenessOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be ground, however, a Grind-related option (Fineness) is informed for these samples. Please set Fineness to Null or let it be calculated automatically for Sample(s) `1`.";
Error::FinenessMismatchOptions = "Grind is set to False for Sample(s) `1`, however, Fineness is informed for these samples. Please set Fineness to Null or let it be calculated automatically for Sample(s) `1`.";
Error::InvalidBulkDensityOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be ground, however, BulkDensity is informed for these samples. Please set BulkDensity to Null or let it be calculated automatically for Sample(s) `1`.";
Error::BulkDensityMismatchOptions = "Grind is set to False for Sample(s) `1`, however, a Grind-related option (BulkDensity) is informed for these samples. Please set BulkDensity to Null or let it be calculated automatically for Sample(s) `1`.";
Error::InvalidGrindingContainerOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be ground, however, GrindingContainer is informed for these samples. Please set GrindingContainer to Null or let it be calculated automatically for Sample(s) `1`.";
Error::GrindingContainerMismatchOptions = "Grind is set to False for Sample(s) `1`, however, GrindingContainer is informed for these samples. Please set GrindingContainer to Null or let it be calculated automatically for Sample(s) `1`.";
Error::InvalidGrindingBeadOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be ground, however, GrindingBead is informed for these samples. Please set GrindingBead to Null or let it be calculated automatically for Sample(s) `1`.";
Error::GrindingBeadMismatchOptions = "Grind is set to False for Sample(s) `1`, however, a Grind-related option (GrindingBead) is informed for these samples. Please set GrindingBead to Null or let it be calculated automatically for Sample(s) `1`.";
Error::InvalidNumberOfGrindingBeadsOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be ground, however, NumberOfGrindingBeads is informed for these samples. Please set NumberOfGrindingBeads to Null or let it be calculated automatically for Sample(s) `1`.";
Error::NumberOfGrindingBeadsMismatchOptions = "Grind is set to False for Sample(s) `1`, however, NumberOfGrindingBeads is informed for these samples. Please set NumberOfGrindingBeads to Null or let it be calculated automatically for Sample(s) `1`.";
Error::InvalidGrindingRateOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be ground, however, GrindingRate is informed for these samples. Please set GrindingRate to Null or let it be calculated automatically for Sample(s) `1`.";
Error::GrindingRateMismatchOptions = "Grind is set to False for Sample(s) `1`, however, GrindingRate is informed for these samples. Please set GrindingRate to Null or let it be calculated automatically for Sample(s) `1`.";
Error::InvalidGrindingTimeOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be ground, however, GrindingTime is informed for these samples. Please set GrindingTime to Null or let it be calculated automatically for Sample(s) `1`.";
Error::GrindingTimeMismatchOptions = "Grind is set to False for Sample(s) `1`, however, GrindingTime is informed for these samples. Please set GrindingTime to Null or let it be calculated automatically for Sample(s) `1`.";
Error::InvalidNumberOfGrindingStepsOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be ground, however, NumberOfGrindingSteps is informed for these samples. Please set NumberOfGrindingSteps to Null or let it be calculated automatically for Sample(s) `1`.";
Error::NumberOfGrindingStepsMismatchOptions = "Grind is set to False for Sample(s) `1`, however, NumberOfGrindingSteps is informed for these samples. Please set NumberOfGrindingSteps to Null or let it be calculated automatically for Sample(s) `1`.";
Error::InvalidCoolingTimeOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be ground, however, CoolingTime is informed for these samples. Please set CoolingTime to Null or let it be calculated automatically for Sample(s) `1`.";
Error::CoolingTimeMismatchOptions = "Grind is set to False for Sample(s) `1`, however, a Grind-related option (CoolingTime) is informed for these samples. Please set CoolingTime to Null or let it be calculated automatically for Sample(s) `1`.";
Error::InvalidGrindingProfileOptions = "Sample(s) `1` are prepacked in melting point capillaries and cannot be ground, however, GrindingProfile is informed for these samples. Please set GrindingProfile to Null or let it be calculated automatically for Sample(s) `1`.";
Error::GrindingProfileMismatchOptions = "Grind is set to False for Sample(s) `1`, however, GrindingProfile is informed for these samples. Please set GrindingProfile to Null or let it be calculated automatically for Sample(s) `1`.";
Error::InvalidExpectedMeltingPoint = "ExpectedMeltingPoint for samples `1` is set to a value that is out of the instrument's temperature range. Please make sure that the ExpectedMeltingPoint is set to a value between 25.1 and 349.9 Celsius.";
Error::InvalidStartEndTemperatures = "StartTemperature is greater than EndTemperature for the following samples: `1`. Please make sure that StartTemperature is set to a value that is smaller than EndTemperature.";
Warning::MismatchedRampRateAndTime = "TemperatureRampRate and RampTime are set to mismatching values for the following samples: `1`. TemperatureRampRate is adjusted to a value that matches RampTime.";
Error::InvalidPreparedSampleContainer = "RecoupSample is False or Null in samples `1`, however, PreparedSampleContainer is informed. Please set PreparedSampleContainer to Null or set RecoupSample to True.";
Error::InvalidPreparedSampleStorageCondition = "RecoupSample is False or Null in samples `1`, however, PreparedSampleStorageCondition is informed. Please set PreparedSampleStorageCondition to Null or set RecoupSample to True.";
Error::InvalidNumberOfReplicates = "Sample(s) `1` are prepacked in melting point capillary tubes. Therefore, NumberOfReplicates must be Null for these samples. NumberOfReplicates determines how many melting point capillaries are packed with the same sample. If the sample is prepacked in a melting point capillary, NumberOfReplicates must be set to Null. If the sample is not prepacked, NumberOfReplicates of Null, 2, or 3, respectively, indicate that 1, 2, or 3 capillaries are to be packed with the same sample.";
Warning::MissingMassInformation = "The sample(s) `1` are missing mass information. 1 Gram will be considered to calculate automatic options.";
Error::NoPreparedSample = "Sample(s) `1` are prepacked in melting point capillary tubes but PreparedSampleContainer is set to True for these samples. No new samples are prepared by grinding or desiccation in this experiment for the samples that are already packed in melting point capillary tubes, therefore, there is no prepared sample to be transferred into PreparedSampleContainer for these samples. Please set PreparedSampleContainer to Null or let it be calculated automatically for sample(s) `1`.";
Error::NoPreparedSampleToRecoup = "Sample(s) `1` are prepacked in melting point capillary tubes but RecoupSample is set to True for these samples. No new samples are prepared by grinding or desiccation in this experiment for the samples that are already packed in melting point capillary tubes, therefore, there is no sample to recoup. Please set RecoupSample to Null or let it be calculated automatically for sample(s) `1`.";


(* ::Subsection::Closed:: *)
(* ExperimentMeasureMeltingPoint *)

(*Mixed Input*)
ExperimentMeasureMeltingPoint[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
	{listedContainers, listedOptions, outputSpecification, output, gatherTests, containerToSampleResult, samples,
		sampleOptions, containerToSampleTests, containerToSampleOutput, validSamplePreparationResult, containerToSampleSimulation,
		mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation},

	(*Determine the requested return value from the function*)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests = MemberQ[output, Tests];

	(*Remove temporal links and named objects.*)
	{listedContainers, listedOptions} = sanitizeInputs[ToList[myInputs], ToList[myOptions]];

	(*First, simulate our sample preparation.*)
	validSamplePreparationResult = Check[
		(*Simulate sample preparation.*)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentMeasureMeltingPoint,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
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
ExperimentMeasureMeltingPoint[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[]] := Module[
	{listedSamples, listedOptions, outputSpecification, output, gatherTests,
		validSamplePreparationResult, samplesWithPreparedSamples,
		optionsWithPreparedSamples, safeOps, safeOpsTests, capillarySeal,
		grinderFields, packingDeviceFields, packingDevices,
		validLengths, validLengthTests, instruments, meltingPointInstrumentModels,
		templatedOptions, templateTests, inheritedOptions, desiccators, grinders,
		expandedSafeOps, capillaryContainers, packetObjectSample, preferredContainers,
		containerOutObjects, containerOutModels, instrumentOption,
		instrumentObjects, allObjects, allContainers, objectSampleFields,
		modelSampleFields, modelContainerFields, objectContainerFields,
		updatedSimulation, upload, confirm, fastTrack, parentProtocol, cache,
		meltingPointInstrumentFields, allGrindingBeadModels,
		downloadedStuff, cacheBall, resolvedOptionsResult,
		resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions,
		returnEarlyQ, performSimulationQ, grindingContainers, grindingBeads,
		samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed,
		safeOptionsNamed, allContainerModels, specifiedDesiccant,
		protocolPacketWithResources, resourcePacketTests, postProcessingOptions, result,
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
		{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
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
	{samplesWithPreparedSamples, safeOps, optionsWithPreparedSamples} = sanitizeInputs[samplesWithPreparedSamplesNamed, safeOptionsNamed, optionsWithPreparedSamplesNamed];

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
	{upload, confirm, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, FastTrack, ParentProtocol, Cache}];

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

	(* gather the instrument option *)
	instrumentOption = Lookup[expandedSafeOps, Instrument];

	(* pull out any Object[Instrument]s in the Instrument option (since users can specify a mix of Objects, Models, and Automatic) *)
	instrumentObjects = Cases[Flatten[{instrumentOption}], ObjectP[Object[Instrument]]];

	(* split things into groups by types (since we'll be downloading different things from different types of objects) *)
	allObjects = DeleteDuplicates[Flatten[{instruments, preferredContainers, containerOutModels, containerOutObjects, capillaryContainers, grindingContainers}]];
	instruments = Cases[allObjects, ObjectP[Model[Instrument]]];
	grinders = Cases[instruments, ObjectP[Model[Instrument, Grinder]]];
	desiccators = Cases[instruments, ObjectP[Model[Instrument, Desiccator]]];
	meltingPointInstrumentModels = Cases[instruments, ObjectP[Model[Instrument, MeltingPointApparatus]]];
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
	modelSampleFields = Union[SamplePreparationCacheFields[Model[Sample]], {DefaultStorageCondition}];
	objectContainerFields = Union[SamplePreparationCacheFields[Object[Container]]];
	modelContainerFields = Union[SamplePreparationCacheFields[Model[Container]]];
	meltingPointInstrumentFields = {Name, Measurands, NumberOfMeltingPointCapillarySlots, StartTemperature, EndTemperature, MinTemperatureRampRate, MaxTemperatureRampRate};
	grinderFields = {Name, GrinderType, Objects, MinAmount, MaxAmount, MinTime, MaxTime, FeedFineness, MaxGrindingRate, MinGrindingRate};
	packingDeviceFields = {Name, NumberOfCapillaries};

	(* in the past including all these different through-link traversals in the main Download call made things slow because there would be duplicates if you have many samples in a plate *)
	(* that should not be a problem anymore with engineering's changes to make Download faster there; we can split this into multiples later if that no longer remains true *)
	packetObjectSample = {
		Packet[Sequence @@ objectSampleFields],
		Packet[Container[objectContainerFields]],
		Packet[Container[Model][modelContainerFields]],
		Packet[Model[modelSampleFields]],
		Packet[Model[{DefaultStorageCondition}]]
	};

	(*Lookup specified Desiccant *)
	(* Lookup specified Desiccant *)
	specifiedDesiccant = If[
		MatchQ[Lookup[expandedSafeOps, Desiccant], Automatic],
		{Model[Sample, "Indicating Drierite"], Model[Sample, "Sulfuric acid"]},
		Lookup[expandedSafeOps, Desiccant]
	];

	(* download all the things *)
	downloadedStuff = Quiet[
		Download[
			{
				(*1*)samplesWithPreparedSamples,
				(*2*)Flatten[Download[samplesWithPreparedSamples, Composition[[All, 2]], Simulation -> updatedSimulation]],
				(*3*)meltingPointInstrumentModels,
				(*4*)allContainerModels,
				(*5*)allContainers,
				(*6*)allGrindingBeadModels,
				(*7*)ToList[specifiedDesiccant],
				(*8*)grinders,
				(*9*)desiccators,
				(*10*)packingDevices,
				(*11*)capillarySeal,
				(*12*)capillaryRod
			},
			Evaluate[
				{
					(*1*)packetObjectSample,
					(*2*){Packet[State, MeltingPoint, BoilingPoint]},
					(*3*){Evaluate[Packet @@ meltingPointInstrumentFields]},
					(*4*){Evaluate[Packet @@ modelContainerFields]},
					(* all basic container models (from PreferredContainers) *)
					(*5*){
					Evaluate[Packet @@ objectContainerFields],
					Packet[Model[modelContainerFields]]
				},
					(*6*){Packet[Diameter]},
					(*7*){Packet[State, Mass, Volume, Status, Model]},
					(*8*){Evaluate[Packet @@ grinderFields]},
					(*9*){Packet[Name]},
					(*10*){Evaluate[Packet @@ packingDeviceFields]},
					(*11*){Packet[Name]},
					(*11*){Packet[Name]}
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

	performSimulationQ = MemberQ[output, Result | Simulation] && MatchQ[Lookup[resolvedOptions, PreparatoryPrimitives], Null | {}];

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
		returnEarlyQ, {$Failed, {}},
		gatherTests, measureMeltingPointResourcePackets[
			samplesWithPreparedSamples,
			templatedOptions,
			resolvedOptions,
			collapsedResolvedOptions,
			Cache -> cacheBall,
			Simulation -> updatedSimulation,
			Output -> {Result, Tests}
		],
		True, {measureMeltingPointResourcePackets[
			samplesWithPreparedSamples,
			templatedOptions,
			resolvedOptions,
			collapsedResolvedOptions,
			Cache -> cacheBall,
			Simulation -> updatedSimulation,
			Output -> Result
		],
			{}
		}];

	(* --- Simulation --- *)
	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentMeasureMeltingPoint[
			If[MatchQ[protocolPacketWithResources, $Failed],
				$Failed,
				protocolPacketWithResources[[1]] (* protocolPacket *)
			],
			If[MatchQ[protocolPacketWithResources, $Failed],
				$Failed,
				Flatten[ToList[protocolPacketWithResources[[2]]]] (* unitOperationPackets *)
			],
			ToList[samplesWithPreparedSamples],
			resolvedOptions,
			Cache -> cacheBall,
			Simulation -> updatedSimulation
		],
		{Null, Null}
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

	postProcessingOptions = Map[
		If[
			MatchQ[Lookup[safeOps, #], Except[Automatic]],
			# -> Lookup[safeOps, #],
			Nothing
		]&,
		{ImageSample, MeasureVolume, MeasureWeight}
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
		outputSpecification, output, gatherTests, cache, simulation,
		samplePrepOptions, measureMeltingPointOptions,
		simulatedSamples, mismatchedRampRateRampTimeTest,
		resolvedSampleLabel, resolvedSampleContainerLabel,
		resolvedSamplePrepOptions, updatedSimulation, samplePrepTests,
		samplePackets, modelPackets, sampleContainerPacketsWithNulls,
		sampleContainerModelPacketsWithNulls, temperatureUnit,
		resolvedOrderOfOperations, invalidStartEndTemperatures,
		startEndTemperatureInvalidOptions, startEndTemperatureInvalidTest,
		invalidOrders, orderTest, mismatchedRampRateRampTimeOptions,
		resolvedExpectedMeltingPoint, resolvedNumberOfReplicates,
		resolvedSealCapillary, unresolvedMeasurementMethod, invalidNumbersOfReplicates,
		numberOfReplicatesMismatchedOptions, numberOfReplicatesMismatchedTest,
		capillaryStorageCondition, recoupSampleContainerMismatchOptions,
		recoupSampleContainerMismatchTest, recoupStorageConditionMismatches,
		recoupStorageMismatchOptions, recoupStorageMismatchTest,
		resolvedStartTemperature, equilibrationTime,
		resolvedEndTemperature, resolvedTemperatureRampRate,
		resolvedRampTime, rampRateChangeWarnings,
		resolvedRecoupSample, resolvedPreparedSampleContainer,
		preparedSampleStorageCondition, resolvedPreparedSampleLabel,
		resolvedPreparedSampleContainerLabel, resolvedAmount,
		cacheBall,
		sampleDownloads, fastAssoc, recoupSampleContainerMismatches,
		sampleContainerModelPackets, sampleContainerPackets,
		messages, discardedSamplePackets, discardedInvalidInputs,
		discardedTest, mapThreadFriendlyOptions, desiccatePrepackedMismatches,
		measureMeltingPointOptionAssociation, optionPrecisions,
		roundedMeasureMeltingPointOptions, precisionTests,
		nonSolidSamplePackets, nonSolidSampleInvalidInputs,
		nonSolidSampleTest, desiccateOptions, sampleObjects,
		missingMassSamplePackets, missingMassInvalidInputs,
		missingMassTest, desiccateSamples,
		desiccateResolvedOptionsResult,
		grindTests, grindResolvedOptionsResult, renamedGrindOptions,
		grindOptionValues, grindOptionKeys, grindSamples,
		orderInvalidOptions, extraneousOrdersOfOperations,
		extraneousOrderTest, extraneousOrderOptions,
		invalidExpectedMeltingPoints, desiccateQs, grindQs, realGrindQs,
		prepackedQs, desiccateTests,
		expectedMeltingPointInvalidOptions, desiccant, unresolvedDesiccant,
		expectedMeltingPointInvalidTest, unresolvedDesiccationMethod,
		amount, desiccationMethod, unresolvedDesiccantPhase,
		resolvedPostProcessingOptions, resolvedOptions, desiccantPhase,
		desiccantAmount, unresolvedInstrument, unresolvedDesiccantAmount, unresolvedDesiccationTime,
		desiccator, unresolvedDesiccator, desiccationTime, sampleContainer,
		resolvedDesiccateIndexMatchedOptions, resolvedDesiccateSingletonOptions,
		halfResolvedGrinderType, halfResolvedGrinder, halfResolvedFineness,
		halfResolvedBulkDensity, halfResolvedGrindingContainer, halfResolvedGrindingBead,
		halfResolvedNumberOfGrindingBeads, halfResolvedGrindingRate, halfResolvedGrindingTime,
		halfResolvedNumberOfGrindingSteps, halfResolvedCoolingTime, halfResolvedGrindingProfile,
		resolvedGrindOptions, grindOptions, optionValues, noGrindOptions, noGrindOptionValues,
		renamedGrindResolvedOptionsResult, grindPrepackedMismatches, grindGrinderTypeMismatches,
		prepackedGrinderTypeMismatches, prepackedGrinderMismatches, grindGrinderMismatches,
		prepackedFinenessMismatches, grindFinenessMismatches, prepackedBulkDensityMismatches, grindBulkDensityMismatches,
		prepackedGrindingContainerMismatches, grindGrindingContainerMismatches,
		recoupPrepackedSampleMismatches, prepackedPreparedSampleContainerMismatches,
		prepackedGrindingBeadMismatches, grindGrindingBeadMismatches,
		prepackedNumberOfGrindingBeadsMismatches, grindNumberOfGrindingBeadsMismatches,
		prepackedGrindingRateMismatches, grindGrindingRateMismatches,
		prepackedGrindingTimeMismatches, grindGrindingTimeMismatches,
		prepackedCoolingTimeMismatches, grindCoolingTimeMismatches,
		prepackedNumberOfGrindingStepsMismatches, grindNumberOfGrindingStepsMismatches,
		prepackedGrindingProfileMismatches, grindGrindingProfileMismatches,
		desiccatePrepackedMismatchOptions, desiccatePrepackedMismatchTest,
		grindPrepackedMismatchOptions, grindPrepackedMismatchTest,
		prepackedGrinderTypeMismatchOptions, prepackedGrinderTypeMismatchTest,
		grindGrinderTypeMismatchOptions, grindGrinderTypeMismatchTest,
		prepackedGrinderMismatchTest, grindGrinderMismatchTest,
		prepackedFinenessMismatchTest, grindFinenessMismatchTest,
		prepackedBulkDensityMismatchTest, grindBulkDensityMismatchTest,
		prepackedGrindingContainerMismatchTest, grindGrindingContainerMismatchTest,
		prepackedGrindingBeadMismatchTest, grindGrindingBeadMismatchTest,
		prepackedNumberOfGrindingBeadsMismatchTest, grindNumberOfGrindingBeadsMismatchTest,
		prepackedGrindingRateMismatchTest, grindGrindingRateMismatchTest,
		prepackedGrindingTimeMismatchTest, grindGrindingTimeMismatchTest,
		prepackedNumberOfGrindingStepsMismatchTest, grindNumberOfGrindingStepsMismatchTest,
		prepackedCoolingTimeMismatchTest, grindCoolingTimeMismatchTest,
		prepackedGrindingProfileMismatchTest, grindGrindingProfileMismatchTest,
		prepackedGrinderMismatchOptions, grindGrinderMismatchOptions,
		prepackedFinenessMismatchOptions, grindFinenessMismatchOptions,
		prepackedBulkDensityMismatchOptions, grindBulkDensityMismatchOptions,
		prepackedGrindingContainerMismatchOptions, grindGrindingContainerMismatchOptions,
		prepackedGrindingBeadMismatchOptions, grindGrindingBeadMismatchOptions,
		prepackedNumberOfGrindingBeadsMismatchOptions, grindNumberOfGrindingBeadsMismatchOptions,
		prepackedGrindingRateMismatchOptions, grindGrindingRateMismatchOptions,
		prepackedGrindingTimeMismatchOptions, grindGrindingTimeMismatchOptions,
		prepackedNumberOfGrindingStepsMismatchOptions, grindNumberOfGrindingStepsMismatchOptions,
		prepackedCoolingTimeMismatchOptions, grindCoolingTimeMismatchOptions,
		prepackedGrindingProfileMismatchOptions, grindGrindingProfileMismatchOptions,
		prepackedSampleContainerMismatches, desiccateSampleContainerMismatches,
		prepackedSampleContainerMismatchOptions, prepackedSampleContainerMismatchTest,
		desiccateSampleContainerMismatchOptions, desiccateSampleContainerMismatchTest,
		prepackedDesiccationMethodMismatchOptions, prepackedDesiccationMethodMismatchTest,
		desiccateDesiccationMethodMismatchOptions, desiccateDesiccationMethodMismatchTest,
		prepackedDesiccantMismatchOptions, prepackedDesiccantMismatchTest,
		desiccateDesiccantMismatchOptions, desiccateDesiccantMismatchTest,
		prepackedDesiccantPhaseMismatchOptions, prepackedDesiccantPhaseMismatchTest,
		desiccateDesiccantPhaseMismatchOptions, desiccateDesiccantPhaseMismatchTest,
		prepackedDesiccantAmountMismatchOptions, prepackedDesiccantAmountMismatchTest,
		desiccateDesiccantAmountMismatchOptions, desiccateDesiccantAmountMismatchTest,
		prepackedDesiccatorMismatchOptions, prepackedDesiccatorMismatchTest,
		desiccateDesiccatorMismatchOptions, desiccateDesiccatorMismatchTest,
		mismatchedRecoupPrepackedOptions, mismatchedRecoupPrepackedTest,
		mismatchedPrepackedPreparedOptions, mismatchedPrepackedPreparedTest,
		prepackedDesiccationTimeMismatchOptions, prepackedDesiccationTimeMismatchTest,
		desiccateDesiccationTimeMismatchOptions, desiccateDesiccationTimeMismatchTest,
		invalidInputs, invalidOptions, allTests
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
			Packet[Name, Volume, Mass, State, Status, Container, Solvent, Position, Composition, MeltingPoint, BoilingPoint, Model],
			Packet[Model[{DefaultStorageCondition}]],
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
		sampleContainerPacketsWithNulls,
		sampleContainerModelPacketsWithNulls
	} = Transpose[sampleDownloads];

	(* If the sample is discarded, it doesn't have a container, so the corresponding container packet is Null.
			Make these packets {} instead so that we can call Lookup on them like we would on a packet. *)
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
	temperatureUnit = "DegreesCelsius";

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
		RoundOptionPrecision[measureMeltingPointOptionAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
		{RoundOptionPrecision[measureMeltingPointOptionAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]]], Null}
	];

	(* -- RESOLVE INDEX-MATCHED OPTIONS *)

	(* NOTE: MAPPING*)
	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentMeasureMeltingPoint, roundedMeasureMeltingPointOptions];

	(* big MapThread to get all the options resolved *)
	{
		(*1*)resolvedOrderOfOperations,
		(*2*)resolvedExpectedMeltingPoint,
		(*3*)resolvedNumberOfReplicates,
		(*4*)resolvedAmount,
		(*5*)resolvedPreparedSampleLabel,
		(*6*)resolvedPreparedSampleContainerLabel,
		(*7*)grindQs,
		(*8*)halfResolvedGrinderType,
		(*9*)halfResolvedGrinder,
		(*10*)halfResolvedFineness,
		(*11*)halfResolvedBulkDensity,
		(*12*)halfResolvedGrindingContainer,
		(*13*)halfResolvedGrindingBead,
		(*14*)halfResolvedNumberOfGrindingBeads,
		(*15*)halfResolvedGrindingRate,
		(*16*)halfResolvedGrindingTime,
		(*17*)halfResolvedNumberOfGrindingSteps,
		(*18*)halfResolvedCoolingTime,
		(*19*)halfResolvedGrindingProfile,
		(*20*)desiccateQs,
		(*21*)sampleContainer,
		(*22*)resolvedSealCapillary,
		(*24*)resolvedStartTemperature,
		(*25*)equilibrationTime,
		(*26*)resolvedEndTemperature,
		(*27*)resolvedTemperatureRampRate,
		(*28*)resolvedRampTime,
		(*29*)resolvedRecoupSample,
		(*30*)resolvedPreparedSampleContainer,
		(*31*)preparedSampleStorageCondition,
		(*32*)capillaryStorageCondition,
		(*33*)invalidOrders,
		(*34*)extraneousOrdersOfOperations,
		(*35*)invalidExpectedMeltingPoints,
		(*36*)invalidStartEndTemperatures,
		(*37*)rampRateChangeWarnings,
		(*38*)recoupSampleContainerMismatches,
		(*39*)recoupStorageConditionMismatches,
		(*40*)invalidNumbersOfReplicates,
		(*41*)prepackedQs,
		(*42*)desiccatePrepackedMismatches,
		(*43*)grindPrepackedMismatches,
		(*44*)grindGrinderTypeMismatches,
		(*45*)prepackedGrinderTypeMismatches,
		(*46*)prepackedGrinderMismatches,
		(*47*)grindGrinderMismatches,
		(*48*)prepackedFinenessMismatches,
		(*49*)grindFinenessMismatches,
		(*50*)prepackedBulkDensityMismatches,
		(*51*)grindBulkDensityMismatches,
		(*52*)prepackedGrindingContainerMismatches,
		(*53*)grindGrindingContainerMismatches,
		(*54*)prepackedGrindingBeadMismatches,
		(*55*)grindGrindingBeadMismatches,
		(*56*)prepackedNumberOfGrindingBeadsMismatches,
		(*57*)grindNumberOfGrindingBeadsMismatches,
		(*58*)prepackedGrindingRateMismatches,
		(*59*)grindGrindingRateMismatches,
		(*60*)prepackedGrindingTimeMismatches,
		(*61*)grindGrindingTimeMismatches,
		(*62*)prepackedNumberOfGrindingStepsMismatches,
		(*63*)grindNumberOfGrindingStepsMismatches,
		(*64*)prepackedCoolingTimeMismatches,
		(*65*)grindCoolingTimeMismatches,
		(*66*)prepackedGrindingProfileMismatches,
		(*67*)grindGrindingProfileMismatches,
		(*68*)prepackedSampleContainerMismatches,
		(*69*)desiccateSampleContainerMismatches,
		(*70*)resolvedSampleLabel,
		(*71*)recoupPrepackedSampleMismatches,
		(*72*)prepackedPreparedSampleContainerMismatches,
		(*73*)resolvedSampleContainerLabel
	} = Transpose[
		MapThread[
			Function[{samplePacket, modelPacket, options, sampleContainerPacket, sampleContainerModelPacket},
				Module[
					{
						convertedStartTemperature, rampRateChangeWarning,
						unresolvedDesiccate, desiccateQ, unresolvedGrind, grindQ,
						unresolvedOrderOfOperations, orderOfOperations,
						extraneousOrderOfOperations, rampTimeQ, rampRateQ,
						expectedMeltingPoint, invalidExpectedMeltingPoint,
						massComponents, sortedComponents, dominantComponent,
						sealCapillary, unroundedStartTemperature, startTemperature,
						equilibrationTime, endTemperature, temperatureRampRate,
						rampTime, recoupSample, preparedSampleContainer,
						unresolvedPreparedSampleContainerLabel, unresolvedSampleLabel,
						unresolvedSampleContainerLabel, sampleContainerLabel,
						unresolvedPreparedSampleLabel, capillaryStorageCondition,
						unresolvedExpectedMeltingPoint, unresolvedNumberOfReplicates,
						numberOfReplicates, invalidNumberOfReplicates, unresolvedAmount,
						unresolvedSealCapillary, prepackedQ, desiccatePrepackedMismatch,
						recoupSampleContainerMismatch, recoupStorageConditionMismatch,
						unresolvedStartTemperature, grindPrepackedMismatch,
						recoupPrepackedSampleMismatch, prepackedPreparedSampleContainerMismatch,
						unresolvedEndTemperature, unresolvedTemperatureRampRate, unresolvedRampTime,
						unroundedEndTemperature, convertedEndTemperature, unresolvedRecoupSample, unresolvedPreparedSampleContainer,
						unresolvedPreparedSampleStorageCondition, unresolvedCapillaryStorageCondition,
						invalidOrderOfOperations, unroundedTemperatureRampRate,
						invalidStartEndTemperature, convertedTemperatureRampRate,
						grinderType, grinder, fineness, bulkDensity, grindingContainer, grindingBead,
						numberOfGrindingBeads, grindingRate, grindingTime, numberOfGrindingSteps,
						coolingTime, grindingProfile, preparedSampleLabel, preparedSampleContainerLabel,
						unresolvedSampleContainer, unresolvedDesiccationMethod, unresolvedDesiccant,
						unresolvedDesiccantPhase, unresolvedDesiccantAmount, unresolvedDesiccator, unresolvedDesiccationTime,
						unresolvedGrinderType, unresolvedGrinder, unresolvedFineness,
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
						prepackedSampleContainerMismatch, desiccateSampleContainerMismatch
					},

					(* error checking variables *)
					{
						(*1*)extraneousOrderOfOperations,
						(*2*)invalidOrderOfOperations,
						(*3*)invalidExpectedMeltingPoint,
						(*4*)invalidStartEndTemperature,
						(*5*)rampRateChangeWarning,
						(*6*)recoupSampleContainerMismatch,
						(*7*)recoupStorageConditionMismatch,
						(*8*)invalidNumberOfReplicates,
						(*9*)desiccatePrepackedMismatch,
						(*10*)grindPrepackedMismatch,
						(*11*)grindGrinderTypeMismatch,
						(*12*)prepackedGrinderTypeMismatch,
						(*13*)prepackedGrinderMismatch,
						(*14*)grindGrinderMismatch,
						(*15*)prepackedFinenessMismatch,
						(*16*)grindFinenessMismatch,
						(*17*)prepackedBulkDensityMismatch,
						(*18*)grindBulkDensityMismatch,
						(*19*)prepackedGrindingContainerMismatch,
						(*20*)grindGrindingContainerMismatch,
						(*21*)prepackedGrindingBeadMismatch,
						(*22*)grindGrindingBeadMismatch,
						(*23*)prepackedNumberOfGrindingBeadsMismatch,
						(*24*)grindNumberOfGrindingBeadsMismatch,
						(*25*)prepackedGrindingRateMismatch,
						(*26*)grindGrindingRateMismatch,
						(*27*)prepackedGrindingTimeMismatch,
						(*28*)grindGrindingTimeMismatch,
						(*29*)prepackedNumberOfGrindingStepsMismatch,
						(*30*)grindNumberOfGrindingStepsMismatch,
						(*31*)prepackedCoolingTimeMismatch,
						(*32*)grindCoolingTimeMismatch,
						(*33*)prepackedGrindingProfileMismatch,
						(*34*)grindGrindingProfileMismatch,
						(*35*)prepackedSampleContainerMismatch,
						(*36*)desiccateSampleContainerMismatch,
						(*37*)recoupPrepackedSampleMismatch,
						(*38*)prepackedPreparedSampleContainerMismatch
					} = ConstantArray[False, 38];

					(* pull out all the relevant unresolved options*)
					{
						(*1*)unresolvedOrderOfOperations,
						(*2*)unresolvedExpectedMeltingPoint,
						(*3*)unresolvedNumberOfReplicates,
						(*4*)unresolvedSealCapillary,
						(*6*)unresolvedStartTemperature,
						(*7*)equilibrationTime,
						(*8*)unresolvedEndTemperature,
						(*9*)unresolvedTemperatureRampRate,
						(*10*)unresolvedRampTime,
						(*11*)unresolvedRecoupSample,
						(*12*)unresolvedPreparedSampleContainer,
						(*13*)unresolvedPreparedSampleStorageCondition,
						(*14*)unresolvedCapillaryStorageCondition,
						(*15*)unresolvedDesiccate,
						(*16*)unresolvedGrind,
						(*17*)unresolvedAmount,
						(*18*)unresolvedSampleContainer,
						(*19*)unresolvedGrinderType,
						(*20*)unresolvedGrinder,
						(*21*)unresolvedFineness,
						(*22*)unresolvedBulkDensity,
						(*23*)unresolvedGrindingContainer,
						(*24*)unresolvedGrindingBead,
						(*25*)unresolvedNumberOfGrindingBeads,
						(*26*)unresolvedGrindingRate,
						(*27*)unresolvedGrindingTime,
						(*28*)unresolvedNumberOfGrindingSteps,
						(*29*)unresolvedCoolingTime,
						(*30*)unresolvedGrindingProfile,
						(*31*)unresolvedPreparedSampleLabel,
						(*32*)unresolvedPreparedSampleContainerLabel,
						(*33*)unresolvedSampleLabel,
						(*34*)unresolvedSampleContainerLabel
					} = Lookup[
						options,
						{
							(*1*)OrderOfOperations,
							(*2*)ExpectedMeltingPoint,
							(*3*)NumberOfReplicates,
							(*4*)SealCapillary,
							(*6*)StartTemperature,
							(*7*)EquilibrationTime,
							(*8*)EndTemperature,
							(*9*)TemperatureRampRate,
							(*10*)RampTime,
							(*11*)RecoupSample,
							(*12*)PreparedSampleContainer,
							(*13*)PreparedSampleStorageCondition,
							(*14*)CapillaryStorageCondition,
							(*15*)Desiccate,
							(*16*)Grind,
							(*17*)Amount,
							(*18*)SampleContainer,
							(*19*)GrinderType,
							(*20*)Grinder,
							(*21*)Fineness,
							(*22*)BulkDensity,
							(*23*)GrindingContainer,
							(*24*)GrindingBead,
							(*25*)NumberOfGrindingBeads,
							(*26*)GrindingRate,
							(*27*)GrindingTime,
							(*28*)NumberOfGrindingSteps,
							(*29*)CoolingTime,
							(*30*)GrindingProfile,
							(*31*)PreparedSampleLabel,
							(*32*)PreparedSampleContainerLabel,
							(*33*)SampleLabel,
							(*34*)SampleContainerLabel
						}
					];

					(* --- Resolve IndexMatched Options --- *)

					(*Determine the type of the sample: prepacked if sample's container is a capillary, not packed if sample's container is not a capillary?*)
					prepackedQ = If[MatchQ[Lookup[sampleContainerPacket, Object], ObjectP[Object[Container, Capillary]]], True, False];

					(*Master Switch: Desiccate*)
					desiccateQ = Which[
						MatchQ[unresolvedDesiccate, Except[Automatic]], unresolvedDesiccate,
						MatchQ[unresolvedDesiccate, Automatic] && prepackedQ, False,
						True, True
					];

					(*flip an error switch if the sample is prepacked but Desiccate is True*)
					desiccatePrepackedMismatch = If[prepackedQ && desiccateQ, True, False];

					(*flip an error switch if the sample is prepacked in a melting point capillary but SampleContainer is not Null*)
					prepackedSampleContainerMismatch = If[prepackedQ && !desiccateQ && !NullQ[unresolvedSampleContainer], True, False];

					(*flip an error switch if the sample is Desiccate is False but SampleContainer is not Null*)
					desiccateSampleContainerMismatch = If[!prepackedQ && !desiccateQ && !NullQ[unresolvedSampleContainer], True, False];


					(*Master Switch: Grind*)
					grindQ = Which[
						MatchQ[unresolvedGrind, Except[Automatic]], unresolvedGrind,
						MatchQ[unresolvedGrind, Automatic] && prepackedQ, False,
						True, True
					];

					(*flip an error switch if the sample is prepacked but Grind is True*)
					grindPrepackedMismatch = If[prepackedQ && grindQ, True, False];

					(*resolve Grind-related options: If Grind is True, Grind options will resolve by ExperimentGrind
					after the Big MapThread. Here, Grind-related options are resolved only if Grind is False*)

					(*Resolve GrinderType*)
					grinderType = If[
						!grindQ && MatchQ[unresolvedGrinderType, Automatic],
						Null,
						unresolvedGrinderType
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but GrinderType is not Null*)
					prepackedGrinderTypeMismatch = If[prepackedQ && !grindQ && !NullQ[grinderType], True, False];

					(*flip an error switch if the sample is Grind is False but GrinderType is not Null*)
					grindGrinderTypeMismatch = If[!prepackedQ && !grindQ && !NullQ[grinderType], True, False];

					(*Resolve Grinder*)
					grinder = If[
						!grindQ && MatchQ[unresolvedGrinder, Automatic],
						Null,
						unresolvedGrinder
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but Grinder is not Null*)
					prepackedGrinderMismatch = If[prepackedQ && !grindQ && !NullQ[grinder], True, False];

					(*flip an error switch if the sample is Grind is False but Grinder is not Null*)
					grindGrinderMismatch = If[!prepackedQ && !grindQ && !NullQ[grinder], True, False];

					(*Resolve Fineness*)
					fineness = Which[
						!grindQ && MatchQ[unresolvedFineness, Automatic], Null,
						grindQ && MatchQ[unresolvedFineness, Automatic], 1Millimeter,
						True, unresolvedFineness
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but Fineness is not Null*)
					prepackedFinenessMismatch = If[prepackedQ && !grindQ && !NullQ[fineness], True, False];

					(*flip an error switch if the sample is Grind is False but Fineness is not Null*)
					grindFinenessMismatch = If[!prepackedQ && !grindQ && !NullQ[fineness], True, False];

					(*Resolve BulkDensity*)
					bulkDensity = Which[
						!grindQ && MatchQ[unresolvedBulkDensity, Automatic], Null,
						grindQ && MatchQ[unresolvedBulkDensity, Automatic], 1Gram / Milliliter,
						True, unresolvedBulkDensity
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but BulkDensity is not Null*)
					prepackedBulkDensityMismatch = If[prepackedQ && !grindQ && !NullQ[bulkDensity], True, False];

					(*flip an error switch if the sample is Grind is False but BulkDensity is not Null*)
					grindBulkDensityMismatch = If[!prepackedQ && !grindQ && !NullQ[bulkDensity], True, False];

					(*Resolve GrindingContainer*)
					grindingContainer = If[
						!grindQ && MatchQ[unresolvedGrindingContainer, Automatic],
						Null,
						unresolvedGrindingContainer
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but GrindingContainer is not Null*)
					prepackedGrindingContainerMismatch = If[prepackedQ && !grindQ && !NullQ[grindingContainer], True, False];

					(*flip an error switch if the sample is Grind is False but GrindingContainer is not Null*)
					grindGrindingContainerMismatch = If[!prepackedQ && !grindQ && !NullQ[grindingContainer], True, False];

					(*Resolve GrindingBead*)
					grindingBead = If[
						!grindQ && MatchQ[unresolvedGrindingBead, Automatic],
						Null,
						unresolvedGrindingBead
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but GrindingBead is not Null*)
					prepackedGrindingBeadMismatch = If[prepackedQ && !grindQ && !NullQ[grindingBead], True, False];

					(*flip an error switch if the sample is Grind is False but GrindingBead is not Null*)
					grindGrindingBeadMismatch = If[!prepackedQ && !grindQ && !NullQ[grindingBead], True, False];

					(*Resolve NumberOfGrindingBeads*)
					numberOfGrindingBeads = If[
						!grindQ && MatchQ[unresolvedNumberOfGrindingBeads, Automatic],
						Null,
						unresolvedNumberOfGrindingBeads
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but NumberOfGrindingBeads is not Null*)
					prepackedNumberOfGrindingBeadsMismatch = If[prepackedQ && !grindQ && !NullQ[numberOfGrindingBeads], True, False];

					(*flip an error switch if the sample is Grind is False but NumberOfGrindingBeads is not Null*)
					grindNumberOfGrindingBeadsMismatch = If[!prepackedQ && !grindQ && !NullQ[numberOfGrindingBeads], True, False];

					(*Resolve GrindingRate*)
					grindingRate = If[
						!grindQ && MatchQ[unresolvedGrindingRate, Automatic],
						Null,
						unresolvedGrindingRate
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but GrindingRate is not Null*)
					prepackedGrindingRateMismatch = If[prepackedQ && !grindQ && !NullQ[grindingRate], True, False];

					(*flip an error switch if the sample is Grind is False but GrindingRate is not Null*)
					grindGrindingRateMismatch = If[!prepackedQ && !grindQ && !NullQ[grindingRate], True, False];

					(*Resolve GrindingTime*)
					grindingTime = If[
						!grindQ && MatchQ[unresolvedGrindingTime, Automatic],
						Null,
						unresolvedGrindingTime
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but GrindingTime is not Null*)
					prepackedGrindingTimeMismatch = If[prepackedQ && !grindQ && !NullQ[grindingTime], True, False];

					(*flip an error switch if the sample is Grind is False but GrindingTime is not Null*)
					grindGrindingTimeMismatch = If[!prepackedQ && !grindQ && !NullQ[grindingTime], True, False];

					(*Resolve NumberOfGrindingSteps*)
					numberOfGrindingSteps = Which[
						!grindQ && MatchQ[unresolvedNumberOfGrindingSteps, Automatic], Null,
						grindQ && MatchQ[unresolvedNumberOfGrindingSteps, Automatic], 1,
						True, unresolvedNumberOfGrindingSteps
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but NumberOfGrindingSteps is not Null*)
					prepackedNumberOfGrindingStepsMismatch = If[prepackedQ && !grindQ && !NullQ[numberOfGrindingSteps], True, False];

					(*flip an error switch if the sample is Grind is False but NumberOfGrindingSteps is not Null*)
					grindNumberOfGrindingStepsMismatch = If[!prepackedQ && !grindQ && !NullQ[numberOfGrindingSteps], True, False];

					(*Resolve CoolingTime*)
					coolingTime = If[
						!grindQ && MatchQ[unresolvedCoolingTime, Automatic],
						Null,
						unresolvedCoolingTime
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but CoolingTime is not Null*)
					prepackedCoolingTimeMismatch = If[prepackedQ && !grindQ && !NullQ[coolingTime], True, False];

					(*flip an error switch if the sample is Grind is False but CoolingTime is not Null*)
					grindCoolingTimeMismatch = If[!prepackedQ && !grindQ && !NullQ[coolingTime], True, False];

					(*Resolve GrindingProfile*)
					grindingProfile = If[
						!grindQ && MatchQ[unresolvedGrindingProfile, Automatic],
						Null,
						unresolvedGrindingProfile
					];

					(*flip an error switch if the sample is prepacked in a melting point capillary but GrindingProfile is not Null*)
					prepackedGrindingProfileMismatch = If[prepackedQ && !grindQ && !NullQ[grindingProfile], True, False];

					(*flip an error switch if the sample is Grind is False but GrindingProfile is not Null*)
					grindGrindingProfileMismatch = If[!prepackedQ && !grindQ && !NullQ[grindingProfile], True, False];
					(*End of Grind-Related options*)

					(*Resolve OrderOfOperation*)
					orderOfOperations = Which[
						MatchQ[unresolvedOrderOfOperations, Except[Automatic]], unresolvedOrderOfOperations,
						MatchQ[unresolvedOrderOfOperations, Automatic] && MatchQ[{desiccateQ, grindQ}, {True, True}], {Desiccate, Grind},
						True, Null
					];

					(*Warning if OrderOfOperations is not set to Null but desiccateQ or grindQ is false.*)
					extraneousOrderOfOperations = If[!NullQ[orderOfOperations], !(desiccateQ && grindQ), False];

					(*Error if desiccateQ and grindQ are True but OrderOfOperations is Null*)
					invalidOrderOfOperations = If[NullQ[orderOfOperations], desiccateQ && grindQ, False];


					(*Resolve ExpectedMeltingPoint: If it is not specified, automatically set to the MP of the dominant component*)
					(*Extract composition components that have amounts that indicate they are solid.
					If there is no composition, then massComponents is Null;
					if Composition has only one component, then massComponents is that single component*)
					massComponents = Which[
						MatchQ[samplePacket[Composition], Null | {Null} | {{Null}} | {} | {{}}], Null,
						Length[samplePacket[Composition]] == 1, samplePacket[Composition],
						Length[samplePacket[Composition]] > 1, Cases[samplePacket[Composition], {MassPercentP | MassConcentrationP, ObjectP[]}]
					];

					(*Sort components based on amount. if massComponents is Null, sortedComponents is Null*)
					sortedComponents = If[MatchQ[massComponents, Null | {}], Null, Sort[massComponents]];

					(*Extract the Identity Model: If length of *)
					dominantComponent = If[MatchQ[sortedComponents, Null], Null, Download[Last[sortedComponents][[2]], Object]];

					expectedMeltingPoint = Which[
						MatchQ[unresolvedExpectedMeltingPoint, Except[Automatic]],
						unresolvedExpectedMeltingPoint,

						(*Set expectedMeltingPoint to SamplePacket's MeltingPoint if it is informed*)
						(MatchQ[unresolvedExpectedMeltingPoint, Automatic] &&
							!NullQ[Download[samplePacket, MeltingPoint]] &&
							Download[samplePacket, MeltingPoint] >= 25.1Celsius &&
							Download[samplePacket, MeltingPoint] <= 349.9Celsius),
						Download[samplePacket, MeltingPoint],

						(*Set expectedMeltingPoint to the dominant component's MeltingPoint if it is informed*)
						(MatchQ[unresolvedExpectedMeltingPoint, Automatic] &&
							!NullQ[fastAssocLookup[fastAssoc, dominantComponent, MeltingPoint]] &&
							fastAssocLookup[fastAssoc, dominantComponent, MeltingPoint] >= 25.1Celsius &&
							fastAssocLookup[fastAssoc, dominantComponent, MeltingPoint] <= 349.9Celsius),
						fastAssocLookup[fastAssoc, dominantComponent, MeltingPoint],

						(*Otherwise set expectedMeltingPoint Unknown*)
						True, Unknown
					];

					(*Invalid ExpectedMeltingPoint option*)
					invalidExpectedMeltingPoint = If[expectedMeltingPoint < 25.1Celsius || expectedMeltingPoint > 349.9Celsius, True, False];


					(*Resolve NumberOfReplicates*)
					numberOfReplicates = Which[
						MatchQ[unresolvedNumberOfReplicates, Except[Automatic]], unresolvedNumberOfReplicates,
						MatchQ[unresolvedNumberOfReplicates, Automatic] && prepackedQ, Null,
						True, 3
					];

					(*flip a switch if the sample is prepacked and NumberOfReplicates is not Null*)
					invalidNumberOfReplicates = If[
						prepackedQ && !MatchQ[numberOfReplicates, Null],
						True,
						False
					];

					(*Resolve Amount*)
					amount = Which[
						MatchQ[unresolvedAmount, Except[Automatic]], unresolvedAmount,
						MatchQ[unresolvedAmount, Automatic] && (grindQ || desiccateQ), Min[1Gram, Lookup[samplePacket, Mass] /. {Null | {} -> 1Gram}],
						MatchQ[unresolvedAmount, Automatic] && prepackedQ, Null,
						True, Null
					];

					(*Resolve StartTemperature*)
					unroundedStartTemperature = Which[
						MatchQ[unresolvedStartTemperature, Except[Automatic]],
						unresolvedStartTemperature,
						MatchQ[unresolvedStartTemperature, Automatic] && MatchQ[expectedMeltingPoint, TemperatureP],
						Max[expectedMeltingPoint - Quantity[5, "DegreesCelsiusDifference"], 25Celsius],
						True, 40Celsius
					];

					(*Convert unit to TemperatureUnit*)
					convertedStartTemperature = UnitConvert[unroundedStartTemperature, Quantity[temperatureUnit]];

					(*round StartTemperature to 1 decimal place*)
					startTemperature = Round[convertedStartTemperature, 0.1];


					(*Resolve EndTemperature*)
					unroundedEndTemperature = Which[
						MatchQ[unresolvedEndTemperature, Except[Automatic]],
						unresolvedEndTemperature,
						MatchQ[unresolvedEndTemperature, Automatic] && MatchQ[expectedMeltingPoint, TemperatureP],
						Min[expectedMeltingPoint + Quantity[5, "DegreesCelsiusDifference"], 350Celsius],
						True, 300Celsius
					];

					(*Convert unit to TemperatureUnit*)
					convertedEndTemperature = UnitConvert[unroundedEndTemperature, Quantity[temperatureUnit]];

					(*round StartTemperature to 1 decimal place*)
					endTemperature = Round[convertedEndTemperature, 0.1];

					(*flip an error switch if startTemperature is greater than or equal to endTemperature*)
					invalidStartEndTemperature = If[GreaterEqualQ[startTemperature, endTemperature], True, False];


					(*Resolve SealCapillary*)
					sealCapillary = Which[

						MatchQ[unresolvedSealCapillary, Except[Automatic]],
						unresolvedSealCapillary,

						MatchQ[unresolvedSealCapillary, Automatic] && !NullQ[Download[samplePacket, BoilingPoint]] && Download[samplePacket, BoilingPoint] - Quantity[20, "DegreesCelsiusDifference"] < endTemperature,
						True,

						(*Set SealCapillary to True if the dominant component's BoilingPoint is informed and it is less than 20C greater than the EndTemperature*)
						MatchQ[unresolvedSealCapillary, Automatic] && !NullQ[fastAssocLookup[fastAssoc, dominantComponent, BoilingPoint]] && fastAssocLookup[fastAssoc, dominantComponent, BoilingPoint] - Quantity[20, "DegreesCelsiusDifference"] < endTemperature,
						True,

						True, False
					];

					(*Resolve RampTime and TemperatureRampRate. These two are related to each other, so should be resolved together*)
					(*Is RampTime specified by user or not?*)
					rampTimeQ = MatchQ[unresolvedRampTime, Except[Automatic]];

					(*Is TemperatureRampRate specified by user or not?*)
					rampRateQ = MatchQ[unresolvedTemperatureRampRate, Except[Automatic]];

					(*If rampTimeQ is True, calculate TemperatureRampRate. In this case it doesn't matter
					 what TemperatureRampRate is set to. will throw a Warning if we change a specified TemperatureRampRate*)
					unroundedTemperatureRampRate = If[rampTimeQ,
						(endTemperature - startTemperature) / unresolvedRampTime,
						Which[
							MatchQ[unresolvedTemperatureRampRate, Except[Automatic]], unresolvedTemperatureRampRate,
							MatchQ[unresolvedTemperatureRampRate, Automatic] && MatchQ[expectedMeltingPoint, Unknown], 10Celsius / Minute,
							MatchQ[unresolvedTemperatureRampRate, Automatic] && MatchQ[expectedMeltingPoint, TemperatureP], 1Celsius / Minute
						]
					];

					(*Convert unit to TemperatureUnit/Minute*)
					convertedTemperatureRampRate = UnitConvert[unroundedTemperatureRampRate, Quantity[temperatureUnit] / Minute];

					(*round TemperatureRampRate to 1 decimal place*)
					temperatureRampRate = Round[convertedTemperatureRampRate, 0.1];

					(*Resolve RampTime*)
					(*calculate unrounded RampTime.*)
					rampTime = If[rampTimeQ, unresolvedRampTime,
						(endTemperature - startTemperature) / temperatureRampRate
					];

					(*flip an error switch if both TemperatureRampRate and RampTime are specified by user and we changed TemperatureRampRate*)
					rampRateChangeWarning = If[
						rampTimeQ && rampRateQ &&
							!MatchQ[unroundedTemperatureRampRate, unresolvedTemperatureRampRate],
						True, False
					];

					(*Resolve RecoupSample and PreparedSampleContainer*)
					{recoupSample, preparedSampleContainer} = Which[
						MatchQ[{unresolvedRecoupSample, unresolvedPreparedSampleContainer}, {Except[Automatic], Except[Automatic]}],
						{unresolvedRecoupSample, unresolvedPreparedSampleContainer},

						MatchQ[{unresolvedRecoupSample, unresolvedPreparedSampleContainer}, {Automatic, Null}],
						{False, Null},

						MatchQ[{unresolvedRecoupSample, unresolvedPreparedSampleContainer}, {Automatic, Except[Automatic]}],
						{If[prepackedQ, Null, True], unresolvedPreparedSampleContainer},

						MatchQ[{unresolvedRecoupSample, unresolvedPreparedSampleContainer}, {Null, Automatic}],
						{Null, Null},

						MatchQ[{unresolvedRecoupSample, unresolvedPreparedSampleContainer}, {True, Automatic}],
						{True, If[prepackedQ, Null, Lookup[sampleContainerPacket, Object]]},

						MatchQ[{unresolvedRecoupSample, unresolvedPreparedSampleContainer}, {Automatic, Automatic}] && !prepackedQ && (grindQ || desiccateQ),
						{False, Null},

						True,
						{Null, Null}
					];

					(*flip an error switch if the sample is prepacked but RecoupSample is True*)
					recoupPrepackedSampleMismatch = If[
						TrueQ[prepackedQ] && TrueQ[recoupSample],
						True, False
					];

					(*flip an error switch if RecoupSample is False or Null but PreparedSampleContainer is not Null*)
					recoupSampleContainerMismatch = If[
						MatchQ[recoupSample, False | Null] && !NullQ[preparedSampleContainer],
						True, False
					];

					(*flip an error switch if the sample is prepacked but PreparedSampleContainer 	is not Null*)
					prepackedPreparedSampleContainerMismatch = If[
						TrueQ[prepackedQ] && !NullQ[preparedSampleContainer],
						True, False
					];

					(* SampleLabel; Default: Automatic *)
					sampleLabel = Which[
						MatchQ[unresolvedSampleLabel, Except[Automatic]], unresolvedSampleLabel,
						And[MatchQ[simulation, SimulationP], MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[samplePacket, Object]]],
						Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[samplePacket, Object]],
						True, "sample " <> StringDrop[Lookup[samplePacket, ID], 3]
					];

					(* SampleContainerLabel; Default: Automatic *)
					sampleContainerLabel = Which[
						MatchQ[unresolvedSampleContainerLabel, Except[Automatic]], unresolvedSampleContainerLabel,
						And[MatchQ[simulation, SimulationP], MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[sampleContainerPacket, Object]]],
						Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[sampleContainerPacket, Object]],
						!NullQ[unresolvedSampleContainer], "sample container " <> StringDrop[ToString[unresolvedSampleContainer], 3],
						True, Null
					];

					(*Resolve PreparedSampleContainerLabel*)
					preparedSampleContainerLabel = Which[
						MatchQ[unresolvedPreparedSampleContainerLabel, Except[Automatic]],
						unresolvedPreparedSampleContainerLabel,
						!NullQ[preparedSampleContainer],
						CreateUniqueLabel["prepared sample container "],
						True, Null
					];

					(*Resolve PreparedSampleLabel*)
					preparedSampleLabel = Which[
						MatchQ[unresolvedPreparedSampleLabel, Except[Automatic]],
						unresolvedPreparedSampleLabel,
						prepackedQ,
						Null,
						MatchQ[recoupSample, True],
						CreateUniqueLabel["prepared sample "],
						True, Null
					];

					(*Resolve PreparedSampleStorageCondition*)
					(*flip an error switch if RecoupSample is False or Null but PreparedSampleStorageCondition is not Null*)
					recoupStorageConditionMismatch = If[
						MatchQ[recoupSample, False | Null] && !NullQ[unresolvedPreparedSampleStorageCondition],
						True, False
					];

					{
						(*1*)orderOfOperations,
						(*2*)expectedMeltingPoint,
						(*3*)numberOfReplicates,
						(*4*)amount,
						(*5*)preparedSampleLabel,
						(*6*)preparedSampleContainerLabel,
						(*7*)grindQ,
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
						(*19*)grindingProfile,
						(*20*)desiccateQ,
						(*21*)unresolvedSampleContainer,
						(*22*)sealCapillary,
						(*24*)startTemperature,
						(*25*)equilibrationTime,
						(*26*)endTemperature,
						(*27*)temperatureRampRate,
						(*28*)rampTime,
						(*29*)recoupSample,
						(*30*)preparedSampleContainer,
						(*31*)unresolvedPreparedSampleStorageCondition,
						(*32*)unresolvedCapillaryStorageCondition,
						(*33*)invalidOrderOfOperations,
						(*34*)extraneousOrderOfOperations,
						(*35*)invalidExpectedMeltingPoint,
						(*36*)invalidStartEndTemperature,
						(*37*)rampRateChangeWarning,
						(*38*)recoupSampleContainerMismatch,
						(*39*)recoupStorageConditionMismatch,
						(*40*)invalidNumberOfReplicates,
						(*41*)prepackedQ,
						(*42*)desiccatePrepackedMismatch,
						(*43*)grindPrepackedMismatch,
						(*44*)grindGrinderTypeMismatch,
						(*45*)prepackedGrinderTypeMismatch,
						(*46*)prepackedGrinderMismatch,
						(*47*)grindGrinderMismatch,
						(*48*)prepackedFinenessMismatch,
						(*49*)grindFinenessMismatch,
						(*50*)prepackedBulkDensityMismatch,
						(*51*)grindBulkDensityMismatch,
						(*52*)prepackedGrindingContainerMismatch,
						(*53*)grindGrindingContainerMismatch,
						(*54*)prepackedGrindingBeadMismatch,
						(*55*)grindGrindingBeadMismatch,
						(*56*)prepackedNumberOfGrindingBeadsMismatch,
						(*57*)grindNumberOfGrindingBeadsMismatch,
						(*58*)prepackedGrindingRateMismatch,
						(*59*)grindGrindingRateMismatch,
						(*60*)prepackedGrindingTimeMismatch,
						(*61*)grindGrindingTimeMismatch,
						(*62*)prepackedNumberOfGrindingStepsMismatch,
						(*63*)grindNumberOfGrindingStepsMismatch,
						(*64*)prepackedCoolingTimeMismatch,
						(*65*)grindCoolingTimeMismatch,
						(*66*)prepackedGrindingProfileMismatch,
						(*67*)grindGrindingProfileMismatch,
						(*68*)prepackedSampleContainerMismatch,
						(*69*)desiccateSampleContainerMismatch,
						(*70*)sampleLabel,
						(*71*)recoupPrepackedSampleMismatch,
						(*72*)prepackedPreparedSampleContainerMismatch,
						(*73*)sampleContainerLabel
					}
				]
			],
			{samplePackets, modelPackets, mapThreadFriendlyOptions, sampleContainerPackets, sampleContainerModelPackets}
		]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(*resolve singleton options: If Desiccate is True, Desiccate options will resolve by ExperimentDesiccate.
	Here, Desiccate-related options are resolved only if Desiccate is False*)
	(*Lookup singleton options*)
	{
        unresolvedMeasurementMethod,
		unresolvedInstrument,
		unresolvedDesiccationMethod,
		unresolvedDesiccant,
		unresolvedDesiccantPhase,
		unresolvedDesiccantAmount,
		unresolvedDesiccator,
		unresolvedDesiccationTime
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
			DesiccationTime
		}
	];

	(* Instrument does not need resolution. Default is informed and Null is not allowed *)

	(*Resolve DesiccationMethod*)
	desiccationMethod = Which[
		!MemberQ[desiccateQs, True] && MatchQ[unresolvedDesiccationMethod, Automatic], Null,
		MemberQ[desiccateQs, True] && MatchQ[unresolvedDesiccationMethod, Automatic], StandardDesiccant,
		True, unresolvedDesiccationMethod
	];

	(*Resolve Desiccant*)
	desiccant = If[
		!MemberQ[desiccateQs, True] && MatchQ[unresolvedDesiccant, Automatic],
		Null,
		unresolvedDesiccant
	];

	(*Resolve DesiccantPhase*)
	desiccantPhase = If[
		!MemberQ[desiccateQs, True] && MatchQ[unresolvedDesiccantPhase, Automatic],
		Null,
		unresolvedDesiccantPhase
	];

	(*Resolve DesiccantAmount*)
	desiccantAmount = If[
		!MemberQ[desiccateQs, True] && MatchQ[unresolvedDesiccantAmount, Automatic],
		Null,
		unresolvedDesiccantAmount
	];

	(*Resolve Desiccator*)
	desiccator = Which[
		!MemberQ[desiccateQs, True] && MatchQ[unresolvedDesiccator, Automatic],
		Null,
		MemberQ[desiccateQs, True] && MatchQ[unresolvedDesiccator, Automatic],
		Model[Instrument, Desiccator, "Bel-Art Space Saver Vacuum Desiccator"],
		True, unresolvedDesiccator
	];

	(*Resolve DesiccationTime*)
	desiccationTime = Which[
		!MemberQ[desiccateQs, True] && MatchQ[unresolvedDesiccationTime, Automatic],
		Null,
		MemberQ[desiccateQs, True] && MatchQ[unresolvedDesiccationTime, Automatic],
		5Hour,
		True, unresolvedDesiccationTime
	];

	(*Determine samples that should be desiccated: desiccateSamples*)
	sampleObjects = Lookup[samplePackets, Object];
	desiccateSamples = PickList[sampleObjects, desiccateQs];

	(*	(*Determine desiccateOptions and desiccateResolutionOptions for those samples*)
    desiccateOptionKeys={Amount,SampleContainer,DesiccationMethod,Desiccant,
      DesiccantPhase,DesiccantAmount,Desiccator,DesiccationTime};*)

	desiccateOptions = {
		Amount -> PickList[resolvedAmount, desiccateQs],
		SampleContainer -> PickList[sampleContainer, desiccateQs],
		Method -> desiccationMethod,
		Desiccant -> desiccant,
		DesiccantPhase -> desiccantPhase,
		DesiccantAmount -> desiccantAmount,
		Desiccator -> desiccator,
		Time -> desiccationTime
	};

	(* Build the resolved desiccate options IF Desiccate is True for at least one sample *)
	{desiccateResolvedOptionsResult, desiccateTests} = Which[
		MemberQ[desiccateQs, True] && gatherTests,
		Quiet[
			ExperimentDesiccate[desiccateSamples, Join[desiccateOptions, {Simulation -> updatedSimulation, Cache -> cacheBall, OptionsResolverOnly -> True, Output -> {Options, Tests}}]],
			{
				Error::MissingMassInformation,
				Error::InvalidInput
			}
		],
		MemberQ[desiccateQs, True] && !gatherTests,
		{
			Quiet[
				ExperimentDesiccate[desiccateSamples, Join[desiccateOptions, {Simulation -> updatedSimulation, Cache -> cacheBall, OptionsResolverOnly -> True, Output -> Options}]],
				{
					Error::MissingMassInformation,
					Error::InvalidInput
				}
			],
			{}
		},
		True, {{}, {}}
	];

	(*Get needed resolved options form ExperimentDesiccate; Rename Method and Time back to DesiccationMethod and DesiccationTime*)
	resolvedDesiccateSingletonOptions = Normal@Which[
		MemberQ[desiccateQs, True],
		KeyTake[desiccateResolvedOptionsResult,
			{Method, Desiccant, DesiccantPhase, DesiccantAmount, Desiccator, Time}
		],

		!MemberQ[desiccateQs, True],
		KeyTake[desiccateOptions, {Method, Desiccant, DesiccantPhase, DesiccantAmount, Desiccator, Time}
		]
	] /. {Time -> DesiccationTime, Method -> DesiccationMethod};

	(*select resolved desiccate-related index-matched options using RiffleAlternatives.
	The only desiccate-related index-matched option is SampleContainer*)
	resolvedDesiccateIndexMatchedOptions = {SampleContainer -> RiffleAlternatives[

		(*True list is options of samples that were resolved by ExperimentDesiccate*)
		Lookup[desiccateResolvedOptionsResult, SampleContainer, {}],

		(*False list is the options of samples that were not resolved by ExperimentDesiccate*)
		PickList[sampleContainer, Not /@ desiccateQs],

		desiccateQs
	]};
	(*End of resolving Desiccate-related options*)

	(* if Grind is set to True by the user but the sample is prepacked, realGrindQs should be False *)
	realGrindQs = MapThread[And, {grindQs, Not /@ prepackedQs}];

	(*Determine samples that should be ground*)
	grindSamples = PickList[sampleObjects, realGrindQs];

	(*Determine grindOptions for those samples*)
	grindOptionKeys = {Amount, GrinderType, Grinder, Fineness, BulkDensity, GrindingContainer,
		GrindingBead, NumberOfGrindingBeads, GrindingRate, GrindingTime, NumberOfGrindingSteps,
		CoolingTime, GrindingProfile};

	optionValues = {resolvedAmount, halfResolvedGrinderType, halfResolvedGrinder, halfResolvedFineness,
		halfResolvedBulkDensity, halfResolvedGrindingContainer, halfResolvedGrindingBead,
		halfResolvedNumberOfGrindingBeads, halfResolvedGrindingRate, halfResolvedGrindingTime,
		halfResolvedNumberOfGrindingSteps, halfResolvedCoolingTime, halfResolvedGrindingProfile};

	(*pick options of samples that should be ground*)
	grindOptionValues = PickList[#, realGrindQs]& /@ optionValues;

	(*pick options of samples that should not be ground*)
	noGrindOptionValues = PickList[#, Not /@ realGrindQs]& /@ optionValues;

	(*make a list of rules for grind options*)
	grindOptions = MapThread[Rule, {grindOptionKeys, grindOptionValues}];

	(*make a list of rules for grind options of samples that should not be ground*)
	noGrindOptions = MapThread[Rule, {grindOptionKeys, noGrindOptionValues}];

	(*Grinder and GrindingTime should change to Instrument and Time to be used in ExperimentDesiccate*)
	renamedGrindOptions = Map[(Keys[#] /. {Grinder -> Instrument, GrindingTime -> Time}) -> Values[#]&, grindOptions];

	(* Build the resolved grind options *)
	{grindResolvedOptionsResult, grindTests} = Which[
		MemberQ[realGrindQs, True] && gatherTests,
		Quiet[
			ExperimentGrind[grindSamples, Join[renamedGrindOptions, {Simulation -> updatedSimulation, Cache -> cacheBall, OptionsResolverOnly -> True, Output -> {Options, Tests}}]],
			{Warning::MissingMassInformation}
		],
		MemberQ[realGrindQs, True] && !gatherTests,
		{
			Quiet[
				ExperimentGrind[grindSamples, Join[renamedGrindOptions, {Simulation -> updatedSimulation, Cache -> cacheBall, OptionsResolverOnly -> True, Output -> Options}]],
				{Warning::MissingMassInformation}
			],
			{}
		},
		True, {{}, {}}
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
		]&, {grindOptionKeys, noGrindOptions}
	];

	(*End of resolving Grind-related options*)

	(***Error, Warning, and Test Definitions***)
	(*throw an error if the sample is prepacked but Desiccate is not Null*)
	desiccatePrepackedMismatchOptions = If[MemberQ[desiccatePrepackedMismatches, True] && messages,
		(
			Message[
				Error::InvalidDesiccateOptions,
				ObjectToString[PickList[simulatedSamples, desiccatePrepackedMismatches], Cache -> cacheBall]
			];
			{Desiccate}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	desiccatePrepackedMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, desiccatePrepackedMismatches];
			passingInputs = PickList[simulatedSamples, desiccatePrepackedMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, Desiccate is False for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, Desiccate is False for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if all samples are prepacked but DesiccationMethod is not Null*)
	prepackedDesiccationMethodMismatchOptions = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && !NullQ[desiccationMethod] && messages,
		(
			Message[
				Error::InvalidDesiccationMethodOptions,
				ObjectToString[PickList[simulatedSamples], Cache -> cacheBall]
			];
			{DesiccationMethod}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	prepackedDesiccationMethodMismatchTest = If[gatherTests,
		Module[{passingInputsTest, failingInputTest},
			(*Create the passing and failing tests*)
			failingInputTest = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && !NullQ[desiccationMethod],
				Test["If all input samples are prepacked in melting point capillaries, DesiccationMethod is Null.", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && NullQ[desiccationMethod],
				Test["If all input samples are prepacked in melting point capillaries, DesiccationMethod is Null.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if Desiccate is False for all samples but DesiccationMethod is not Null*)
	desiccateDesiccationMethodMismatchOptions = If[!MemberQ[desiccateQs, True] && !NullQ[desiccationMethod] && messages,
		(
			Message[
				Error::DesiccationMethodMismatchOptions,
				ObjectToString[PickList[simulatedSamples], Cache -> cacheBall]
			];
			{DesiccationMethod}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	desiccateDesiccationMethodMismatchTest = If[gatherTests,
		Module[{passingInputsTest, failingInputTest},
			(*Create the passing and failing tests*)
			failingInputTest = If[!MemberQ[prepackedQs, True] && !MemberQ[desiccateQs, True] && !NullQ[desiccationMethod],
				Test["If Desiccate is False for all input samples, DesiccationMethod is Null.", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[!MemberQ[prepackedQs, True] && !MemberQ[desiccateQs, True] && NullQ[desiccationMethod],
				Test["If Desiccate is False for all input samples, DesiccationMethod is Null.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if all samples are prepacked but Desiccant is not Null*)
	prepackedDesiccantMismatchOptions = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && !NullQ[desiccant] && messages,
		(
			Message[
				Error::InvalidDesiccantOptions,
				ObjectToString[PickList[simulatedSamples], Cache -> cacheBall]
			];
			{Desiccant}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	prepackedDesiccantMismatchTest = If[gatherTests,
		Module[{passingInputsTest, failingInputTest},
			(*Create the passing and failing tests*)
			failingInputTest = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && !NullQ[Desiccant],
				Test["If all input samples are prepacked in melting point capillaries, Desiccant is Null.", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && NullQ[Desiccant],
				Test["If all input samples are prepacked in melting point capillaries, Desiccant is Null.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if Desiccate is False for all samples but Desiccant is not Null*)
	desiccateDesiccantMismatchOptions = If[!MemberQ[desiccateQs, True] && !NullQ[desiccant] && messages,
		(
			Message[
				Error::DesiccantMismatchOptions,
				ObjectToString[PickList[simulatedSamples], Cache -> cacheBall]
			];
			{Desiccant}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	desiccateDesiccantMismatchTest = If[gatherTests,
		Module[{passingInputsTest, failingInputTest},
			(*Create the passing and failing tests*)
			failingInputTest = If[!MemberQ[prepackedQs, True] && !MemberQ[desiccateQs, True] && !NullQ[Desiccant],
				Test["If Desiccate is False for all input samples, Desiccant is Null.", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[!MemberQ[prepackedQs, True] && !MemberQ[desiccateQs, True] && NullQ[Desiccant],
				Test["If Desiccate is False for all input samples, Desiccant is Null.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if all samples are prepacked but DesiccantPhase is not Null*)
	prepackedDesiccantPhaseMismatchOptions = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && !NullQ[desiccantPhase] && messages,
		(
			Message[
				Error::InvalidDesiccantPhaseOptions,
				ObjectToString[PickList[simulatedSamples], Cache -> cacheBall]
			];
			{DesiccantPhase}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	prepackedDesiccantPhaseMismatchTest = If[gatherTests,
		Module[{passingInputsTest, failingInputTest},
			(*Create the passing and failing tests*)
			failingInputTest = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && !NullQ[DesiccantPhase],
				Test["If all input samples are prepacked in melting point capillaries, DesiccantPhase is Null.", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && NullQ[DesiccantPhase],
				Test["If all input samples are prepacked in melting point capillaries, DesiccantPhase is Null.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if Desiccate is False for all samples but DesiccantPhase is not Null*)
	desiccateDesiccantPhaseMismatchOptions = If[!MemberQ[desiccateQs, True] && !NullQ[desiccantPhase] && messages,
		(
			Message[
				Error::DesiccantPhaseMismatchOptions,
				ObjectToString[PickList[simulatedSamples], Cache -> cacheBall]
			];
			{DesiccantPhase}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	desiccateDesiccantPhaseMismatchTest = If[gatherTests,
		Module[{passingInputsTest, failingInputTest},
			(*Create the passing and failing tests*)
			failingInputTest = If[!MemberQ[prepackedQs, True] && !MemberQ[desiccateQs, True] && !NullQ[DesiccantPhase],
				Test["If Desiccate is False for all input samples, DesiccantPhase is Null.", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[!MemberQ[prepackedQs, True] && !MemberQ[desiccateQs, True] && NullQ[DesiccantPhase],
				Test["If Desiccate is False for all input samples, DesiccantPhase is Null.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if all samples are prepacked but DesiccantAmount is not Null*)
	prepackedDesiccantAmountMismatchOptions = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && !NullQ[desiccantAmount] && messages,
		(
			Message[
				Error::InvalidDesiccantAmountOptions,
				ObjectToString[PickList[simulatedSamples], Cache -> cacheBall]
			];
			{DesiccantAmount}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	prepackedDesiccantAmountMismatchTest = If[gatherTests,
		Module[{passingInputsTest, failingInputTest},
			(*Create the passing and failing tests*)
			failingInputTest = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && !NullQ[DesiccantAmount],
				Test["If all input samples are prepacked in melting point capillaries, DesiccantAmount is Null.", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && NullQ[DesiccantAmount],
				Test["If all input samples are prepacked in melting point capillaries, DesiccantAmount is Null.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if Desiccate is False for all samples but DesiccantAmount is not Null*)
	desiccateDesiccantAmountMismatchOptions = If[!MemberQ[desiccateQs, True] && !NullQ[desiccantAmount] && messages,
		(
			Message[
				Error::DesiccantAmountMismatchOptions,
				ObjectToString[PickList[simulatedSamples], Cache -> cacheBall]
			];
			{DesiccantAmount}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	desiccateDesiccantAmountMismatchTest = If[gatherTests,
		Module[{passingInputsTest, failingInputTest},
			(*Create the passing and failing tests*)
			failingInputTest = If[!MemberQ[prepackedQs, True] && !MemberQ[desiccateQs, True] && !NullQ[DesiccantAmount],
				Test["If Desiccate is False for all input samples, DesiccantAmount is Null.", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[!MemberQ[prepackedQs, True] && !MemberQ[desiccateQs, True] && NullQ[DesiccantAmount],
				Test["If Desiccate is False for all input samples, DesiccantAmount is Null.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if all samples are prepacked but Desiccator is not Null*)
	prepackedDesiccatorMismatchOptions = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && !NullQ[desiccator] && messages,
		(
			Message[
				Error::InvalidDesiccatorOptions,
				ObjectToString[PickList[simulatedSamples], Cache -> cacheBall]
			];
			{Desiccator}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	prepackedDesiccatorMismatchTest = If[gatherTests,
		Module[{passingInputsTest, failingInputTest},
			(*Create the passing and failing tests*)
			failingInputTest = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && !NullQ[Desiccator],
				Test["If all input samples are prepacked in melting point capillaries, Desiccator is Null.", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && NullQ[Desiccator],
				Test["If all input samples are prepacked in melting point capillaries, Desiccator is Null.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if Desiccate is False for all samples but Desiccator is not Null*)
	desiccateDesiccatorMismatchOptions = If[!MemberQ[desiccateQs, True] && !NullQ[desiccator] && messages,
		(
			Message[
				Error::DesiccatorMismatchOptions,
				ObjectToString[PickList[simulatedSamples], Cache -> cacheBall]
			];
			{Desiccator}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	desiccateDesiccatorMismatchTest = If[gatherTests,
		Module[{passingInputsTest, failingInputTest},
			(*Create the passing and failing tests*)
			failingInputTest = If[!MemberQ[prepackedQs, True] && !MemberQ[desiccateQs, True] && !NullQ[Desiccator],
				Test["If Desiccate is False for all input samples, Desiccator is Null.", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[!MemberQ[prepackedQs, True] && !MemberQ[desiccateQs, True] && NullQ[Desiccator],
				Test["If Desiccate is False for all input samples, Desiccator is Null.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if all samples are prepacked but DesiccationTime is not Null*)
	prepackedDesiccationTimeMismatchOptions = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && !NullQ[desiccationTime] && messages,
		(
			Message[
				Error::InvalidDesiccationTimeOptions,
				ObjectToString[PickList[simulatedSamples], Cache -> cacheBall]
			];
			{DesiccationTime}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	prepackedDesiccationTimeMismatchTest = If[gatherTests,
		Module[{passingInputsTest, failingInputTest},
			(*Create the passing and failing tests*)
			failingInputTest = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && !NullQ[DesiccationTime],
				Test["If all input samples are prepacked in melting point capillaries, DesiccationTime is Null.", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[!MemberQ[prepackedQs, False] && !MemberQ[desiccateQs, True] && NullQ[DesiccationTime],
				Test["If all input samples are prepacked in melting point capillaries, DesiccationTime is Null.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if Desiccate is False for all samples but DesiccationTime is not Null*)
	desiccateDesiccationTimeMismatchOptions = If[!MemberQ[desiccateQs, True] && !NullQ[desiccationTime] && messages,
		(
			Message[
				Error::DesiccationTimeMismatchOptions,
				ObjectToString[PickList[simulatedSamples], Cache -> cacheBall]
			];
			{DesiccationTime}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	desiccateDesiccationTimeMismatchTest = If[gatherTests,
		Module[{passingInputsTest, failingInputTest},
			(*Create the passing and failing tests*)
			failingInputTest = If[!MemberQ[prepackedQs, True] && !MemberQ[desiccateQs, True] && !NullQ[DesiccationTime],
				Test["If Desiccate is False for all input samples, DesiccationTime is Null.", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[!MemberQ[prepackedQs, True] && !MemberQ[desiccateQs, True] && NullQ[DesiccationTime],
				Test["If Desiccate is False for all input samples, DesiccationTime is Null.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but GrinderType is not Null*)
	prepackedSampleContainerMismatchOptions = If[MemberQ[prepackedSampleContainerMismatches, True] && messages,
		(
			Message[
				Error::InvalidSampleContainerOptions,
				ObjectToString[PickList[simulatedSamples, prepackedSampleContainerMismatches], Cache -> cacheBall]
			];
			{SampleContainer}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	prepackedSampleContainerMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, prepackedSampleContainerMismatches];
			passingInputs = PickList[simulatedSamples, prepackedSampleContainerMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, SampleContainer is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, SampleContainer is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if Grind is set to False but GrinderType is not Null*)
	desiccateSampleContainerMismatchOptions = If[MemberQ[desiccateSampleContainerMismatches, True] && messages,
		(
			Message[
				Error::SampleContainerMismatchOptions,
				ObjectToString[PickList[simulatedSamples, desiccateSampleContainerMismatches], Cache -> cacheBall]
			];
			{SampleContainer}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	desiccateSampleContainerMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, desiccateSampleContainerMismatches];
			passingInputs = PickList[simulatedSamples, desiccateSampleContainerMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If Desiccate is False, SampleContainer is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If Desiccate is False, SampleContainer is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but Grind is not Null*)
	grindPrepackedMismatchOptions = If[MemberQ[grindPrepackedMismatches, True] && messages,
		(
			Message[
				Error::InvalidGrindOptions,
				ObjectToString[PickList[simulatedSamples, grindPrepackedMismatches], Cache -> cacheBall]
			];
			{Grind}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	grindPrepackedMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, grindPrepackedMismatches];
			passingInputs = PickList[simulatedSamples, grindPrepackedMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, Grind is False for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, Grind is False for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but GrinderType is not Null*)
	prepackedGrinderTypeMismatchOptions = If[MemberQ[prepackedGrinderTypeMismatches, True] && messages,
		(
			Message[
				Error::InvalidGrinderTypeOptions,
				ObjectToString[PickList[simulatedSamples, prepackedGrinderTypeMismatches], Cache -> cacheBall]
			];
			{GrinderType}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	prepackedGrinderTypeMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, prepackedGrinderTypeMismatches];
			passingInputs = PickList[simulatedSamples, prepackedGrinderTypeMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, GrinderType is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, GrinderType is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if Grind is set to False but GrinderType is not Null*)
	grindGrinderTypeMismatchOptions = If[MemberQ[grindGrinderTypeMismatches, True] && messages,
		(
			Message[
				Error::GrinderTypeMismatchOptions,
				ObjectToString[PickList[simulatedSamples, grindGrinderTypeMismatches], Cache -> cacheBall]
			];
			{GrinderType}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	grindGrinderTypeMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, grindGrinderTypeMismatches];
			passingInputs = PickList[simulatedSamples, grindGrinderTypeMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If Grind is False, GrinderType is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If Grind is False, GrinderType is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but Grinder is not Null*)
	prepackedGrinderMismatchOptions = If[MemberQ[prepackedGrinderMismatches, True] && messages,
		(
			Message[
				Error::InvalidGrinderOptions,
				ObjectToString[PickList[simulatedSamples, prepackedGrinderMismatches], Cache -> cacheBall]
			];
			{Grinder}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	prepackedGrinderMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, prepackedGrinderMismatches];
			passingInputs = PickList[simulatedSamples, prepackedGrinderMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, Grinder is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, Grinder is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but Grinder is not Null*)
	grindGrinderMismatchOptions = If[MemberQ[grindGrinderMismatches, True] && messages,
		(
			Message[
				Error::GrinderMismatchOptions,
				ObjectToString[PickList[simulatedSamples, grindGrinderMismatches], Cache -> cacheBall]
			];
			{Grinder}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	grindGrinderMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, grindGrinderMismatches];
			passingInputs = PickList[simulatedSamples, grindGrinderMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If Grind is False, Grinder is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If Grind is False, Grinder is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but Fineness is not Null*)
	prepackedFinenessMismatchOptions = If[MemberQ[prepackedFinenessMismatches, True] && messages,
		(
			Message[
				Error::InvalidFinenessOptions,
				ObjectToString[PickList[simulatedSamples, prepackedFinenessMismatches], Cache -> cacheBall]
			];
			{Fineness}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	prepackedFinenessMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, prepackedFinenessMismatches];
			passingInputs = PickList[simulatedSamples, prepackedFinenessMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, Fineness is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, Fineness is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but Fineness is not Null*)
	grindFinenessMismatchOptions = If[MemberQ[grindFinenessMismatches, True] && messages,
		(
			Message[
				Error::FinenessMismatchOptions,
				ObjectToString[PickList[simulatedSamples, grindFinenessMismatches], Cache -> cacheBall]
			];
			{Fineness}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	grindFinenessMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, grindFinenessMismatches];
			passingInputs = PickList[simulatedSamples, grindFinenessMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If Grind is False, Fineness is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If Grind is False, Fineness is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but BulkDensity is not Null*)
	prepackedBulkDensityMismatchOptions = If[MemberQ[prepackedBulkDensityMismatches, True] && messages,
		(
			Message[
				Error::InvalidBulkDensityOptions,
				ObjectToString[PickList[simulatedSamples, prepackedBulkDensityMismatches], Cache -> cacheBall]
			];
			{BulkDensity}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	prepackedBulkDensityMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, prepackedBulkDensityMismatches];
			passingInputs = PickList[simulatedSamples, prepackedBulkDensityMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, BulkDensity is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, BulkDensity is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but BulkDensity is not Null*)
	grindBulkDensityMismatchOptions = If[MemberQ[grindBulkDensityMismatches, True] && messages,
		(
			Message[
				Error::BulkDensityMismatchOptions,
				ObjectToString[PickList[simulatedSamples, grindBulkDensityMismatches], Cache -> cacheBall]
			];
			{BulkDensity}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	grindBulkDensityMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, grindBulkDensityMismatches];
			passingInputs = PickList[simulatedSamples, grindBulkDensityMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If Grind is False, BulkDensity is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If Grind is False, BulkDensity is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but GrindingContainer is not Null*)
	prepackedGrindingContainerMismatchOptions = If[MemberQ[prepackedGrindingContainerMismatches, True] && messages,
		(
			Message[
				Error::InvalidGrindingContainerOptions,
				ObjectToString[PickList[simulatedSamples, prepackedGrindingContainerMismatches], Cache -> cacheBall]
			];
			{GrindingContainer}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	prepackedGrindingContainerMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, prepackedGrindingContainerMismatches];
			passingInputs = PickList[simulatedSamples, prepackedGrindingContainerMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, GrindingContainer is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, GrindingContainer is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but GrindingContainer is not Null*)
	grindGrindingContainerMismatchOptions = If[MemberQ[grindGrindingContainerMismatches, True] && messages,
		(
			Message[
				Error::GrindingContainerMismatchOptions,
				ObjectToString[PickList[simulatedSamples, grindGrindingContainerMismatches], Cache -> cacheBall]
			];
			{GrindingContainer}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	grindGrindingContainerMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, grindGrindingContainerMismatches];
			passingInputs = PickList[simulatedSamples, grindGrindingContainerMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If Grind is False, GrindingContainer is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If Grind is False, GrindingContainer is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but GrindingBead is not Null*)
	prepackedGrindingBeadMismatchOptions = If[MemberQ[prepackedGrindingBeadMismatches, True] && messages,
		(
			Message[
				Error::InvalidGrindingBeadOptions,
				ObjectToString[PickList[simulatedSamples, prepackedGrindingBeadMismatches], Cache -> cacheBall]
			];
			{GrindingBead}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	prepackedGrindingBeadMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, prepackedGrindingBeadMismatches];
			passingInputs = PickList[simulatedSamples, prepackedGrindingBeadMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, GrindingBead is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, GrindingBead is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but GrindingBead is not Null*)
	grindGrindingBeadMismatchOptions = If[MemberQ[grindGrindingBeadMismatches, True] && messages,
		(
			Message[
				Error::GrindingBeadMismatchOptions,
				ObjectToString[PickList[simulatedSamples, grindGrindingBeadMismatches], Cache -> cacheBall]
			];
			{GrindingBead}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	grindGrindingBeadMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, grindGrindingBeadMismatches];
			passingInputs = PickList[simulatedSamples, grindGrindingBeadMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If Grind is False, GrindingBead is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If Grind is False, GrindingBead is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but NumberOfGrindingBeads is not Null*)
	prepackedNumberOfGrindingBeadsMismatchOptions = If[MemberQ[prepackedNumberOfGrindingBeadsMismatches, True] && messages,
		(
			Message[
				Error::InvalidNumberOfGrindingBeadsOptions,
				ObjectToString[PickList[simulatedSamples, prepackedNumberOfGrindingBeadsMismatches], Cache -> cacheBall]
			];
			{NumberOfGrindingBeads}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	prepackedNumberOfGrindingBeadsMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, prepackedNumberOfGrindingBeadsMismatches];
			passingInputs = PickList[simulatedSamples, prepackedNumberOfGrindingBeadsMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, NumberOfGrindingBeads is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, NumberOfGrindingBeads is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but NumberOfGrindingBeads is not Null*)
	grindNumberOfGrindingBeadsMismatchOptions = If[MemberQ[grindNumberOfGrindingBeadsMismatches, True] && messages,
		(
			Message[
				Error::NumberOfGrindingBeadsMismatchOptions,
				ObjectToString[PickList[simulatedSamples, grindNumberOfGrindingBeadsMismatches], Cache -> cacheBall]
			];
			{NumberOfGrindingBeads}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	grindNumberOfGrindingBeadsMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, grindNumberOfGrindingBeadsMismatches];
			passingInputs = PickList[simulatedSamples, grindNumberOfGrindingBeadsMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If Grind is False, NumberOfGrindingBeads is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If Grind is False, NumberOfGrindingBeads is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but GrindingRate is not Null*)
	prepackedGrindingRateMismatchOptions = If[MemberQ[prepackedGrindingRateMismatches, True] && messages,
		(
			Message[
				Error::InvalidGrindingRateOptions,
				ObjectToString[PickList[simulatedSamples, prepackedGrindingRateMismatches], Cache -> cacheBall]
			];
			{GrindingRate}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	prepackedGrindingRateMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, prepackedGrindingRateMismatches];
			passingInputs = PickList[simulatedSamples, prepackedGrindingRateMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, GrindingRate is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, GrindingRate is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but GrindingRate is not Null*)
	grindGrindingRateMismatchOptions = If[MemberQ[grindGrindingRateMismatches, True] && messages,
		(
			Message[
				Error::GrindingRateMismatchOptions,
				ObjectToString[PickList[simulatedSamples, grindGrindingRateMismatches], Cache -> cacheBall]
			];
			{GrindingRate}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	grindGrindingRateMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, grindGrindingRateMismatches];
			passingInputs = PickList[simulatedSamples, grindGrindingRateMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If Grind is False, GrindingRate is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If Grind is False, GrindingRate is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but GrindingTime is not Null*)
	prepackedGrindingTimeMismatchOptions = If[MemberQ[prepackedGrindingTimeMismatches, True] && messages,
		(
			Message[
				Error::InvalidGrindingTimeOptions,
				ObjectToString[PickList[simulatedSamples, prepackedGrindingTimeMismatches], Cache -> cacheBall]
			];
			{GrindingTime}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	prepackedGrindingTimeMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, prepackedGrindingTimeMismatches];
			passingInputs = PickList[simulatedSamples, prepackedGrindingTimeMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, GrindingTime is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, GrindingTime is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but GrindingTime is not Null*)
	grindGrindingTimeMismatchOptions = If[MemberQ[grindGrindingTimeMismatches, True] && messages,
		(
			Message[
				Error::GrindingTimeMismatchOptions,
				ObjectToString[PickList[simulatedSamples, grindGrindingTimeMismatches], Cache -> cacheBall]
			];
			{GrindingTime}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	grindGrindingTimeMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, grindGrindingTimeMismatches];
			passingInputs = PickList[simulatedSamples, grindGrindingTimeMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If Grind is False, GrindingTime is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If Grind is False, GrindingTime is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but NumberOfGrindingSteps is not Null*)
	prepackedNumberOfGrindingStepsMismatchOptions = If[MemberQ[prepackedNumberOfGrindingStepsMismatches, True] && messages,
		(
			Message[
				Error::InvalidNumberOfGrindingStepsOptions,
				ObjectToString[PickList[simulatedSamples, prepackedNumberOfGrindingStepsMismatches], Cache -> cacheBall]
			];
			{NumberOfGrindingSteps}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	prepackedNumberOfGrindingStepsMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, prepackedNumberOfGrindingStepsMismatches];
			passingInputs = PickList[simulatedSamples, prepackedNumberOfGrindingStepsMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, NumberOfGrindingSteps is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, NumberOfGrindingSteps is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but NumberOfGrindingSteps is not Null*)
	grindNumberOfGrindingStepsMismatchOptions = If[MemberQ[grindNumberOfGrindingStepsMismatches, True] && messages,
		(
			Message[
				Error::NumberOfGrindingStepsMismatchOptions,
				ObjectToString[PickList[simulatedSamples, grindNumberOfGrindingStepsMismatches], Cache -> cacheBall]
			];
			{NumberOfGrindingSteps}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	grindNumberOfGrindingStepsMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, grindNumberOfGrindingStepsMismatches];
			passingInputs = PickList[simulatedSamples, grindNumberOfGrindingStepsMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If Grind is False, NumberOfGrindingSteps is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If Grind is False, NumberOfGrindingSteps is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but CoolingTime is not Null*)
	prepackedCoolingTimeMismatchOptions = If[MemberQ[prepackedCoolingTimeMismatches, True] && messages,
		(
			Message[
				Error::InvalidCoolingTimeOptions,
				ObjectToString[PickList[simulatedSamples, prepackedCoolingTimeMismatches], Cache -> cacheBall]
			];
			{CoolingTime}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	prepackedCoolingTimeMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, prepackedCoolingTimeMismatches];
			passingInputs = PickList[simulatedSamples, prepackedCoolingTimeMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, CoolingTime is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, CoolingTime is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but CoolingTime is not Null*)
	grindCoolingTimeMismatchOptions = If[MemberQ[grindCoolingTimeMismatches, True] && messages,
		(
			Message[
				Error::CoolingTimeMismatchOptions,
				ObjectToString[PickList[simulatedSamples, grindCoolingTimeMismatches], Cache -> cacheBall]
			];
			{CoolingTime}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	grindCoolingTimeMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, grindCoolingTimeMismatches];
			passingInputs = PickList[simulatedSamples, grindCoolingTimeMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If Grind is False, CoolingTime is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If Grind is False, CoolingTime is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but GrindingProfile is not Null*)
	prepackedGrindingProfileMismatchOptions = If[MemberQ[prepackedGrindingProfileMismatches, True] && messages,
		(
			Message[
				Error::InvalidGrindingProfileOptions,
				ObjectToString[PickList[simulatedSamples, prepackedGrindingProfileMismatches], Cache -> cacheBall]
			];
			{GrindingProfile}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	prepackedGrindingProfileMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, prepackedGrindingProfileMismatches];
			passingInputs = PickList[simulatedSamples, prepackedGrindingProfileMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, GrindingProfile is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the sample is prepacked in a melting point capillary, GrindingProfile is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if the sample is prepacked but GrindingProfile is not Null*)
	grindGrindingProfileMismatchOptions = If[MemberQ[grindGrindingProfileMismatches, True] && messages,
		(
			Message[
				Error::GrindingProfileMismatchOptions,
				ObjectToString[PickList[simulatedSamples, grindGrindingProfileMismatches], Cache -> cacheBall]
			];
			{GrindingProfile}
		),
		{}
	];

	(*Create appropriate tests if gathering them,or return {}*)
	grindGrindingProfileMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, grindGrindingProfileMismatches];
			passingInputs = PickList[simulatedSamples, grindGrindingProfileMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If Grind is False, GrindingProfile is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If Grind is False, GrindingProfile is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if Grind or Desiccate are set to False but OrderOfOperations is NOT set to Null*)
	extraneousOrderOptions = If[MemberQ[extraneousOrdersOfOperations, True] && messages,
		(
			Message[
				Warning::ExtraneousOrderOfOperations,
				ObjectToString[PickList[simulatedSamples, extraneousOrdersOfOperations], Cache -> cacheBall]
			];
			{OrderOfOperations}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	extraneousOrderTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, extraneousOrdersOfOperations];
			passingInputs = PickList[simulatedSamples, extraneousOrdersOfOperations, False];

			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["If Desiccate or Grind is set to False, OrderOfOperations is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];

			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["If Desiccate or Grind is set to False, OrderOfOperations is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if OrderOfOperations is Null but Desiccate and Grind are True*)
	orderInvalidOptions = If[MemberQ[invalidOrders, True] && messages,
		(
			Message[
				Error::UndefinedOrderOfOperations,
				ObjectToString[PickList[simulatedSamples, invalidOrders], Cache -> cacheBall]
			];
			{OrderOfOperations}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	orderTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, invalidOrders];
			passingInputs = PickList[simulatedSamples, invalidOrders, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " have valid OrderOfOperations if both Desiccate and Grind are set to True.", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " have valid OrderOfOperations if both Desiccate and Grind are set to True.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];


	(*throw an error if ExpectedMeltingPoint is set to greater than 349.9 Celsius or below 25 Celsius*)
	expectedMeltingPointInvalidOptions = If[MemberQ[invalidExpectedMeltingPoints, True] && messages,
		(
			Message[
				Error::InvalidExpectedMeltingPoint,
				ObjectToString[PickList[simulatedSamples, invalidExpectedMeltingPoints], Cache -> cacheBall]
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
				Test["ExpectedMeltingPoint is set to a valid value (between 25 and 349.9 Celsius) for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["ExpectedMeltingPoint is set to a valid value (between 25 and 349.9 Celsius) for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
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
				Test["StartTemperature is less than EndTemperature for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
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
				Warning["TemperatureRampRate and RampTime are set to matching values for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw a warning if the sample is prepacked but RecoupSample is not Null*)
	mismatchedRecoupPrepackedOptions = If[MemberQ[recoupPrepackedSampleMismatches, True] && messages,
		(
			Message[
				Error::NoPreparedSampleToRecoup,
				ObjectToString[PickList[simulatedSamples, recoupPrepackedSampleMismatches], Cache -> cacheBall]
			];
			{RecoupSample}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	mismatchedRecoupPrepackedTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, recoupPrepackedSampleMismatches];
			passingInputs = PickList[simulatedSamples, recoupPrepackedSampleMismatches, False];

			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["Recoup is Null for the following input samples which are prepacked in capillary tube: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];

			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["Recoup is Null for the following input samples which are prepacked in capillary tube: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw a warning if the sample is prepacked but PreparedSampleContainer is not Null*)
	mismatchedPrepackedPreparedOptions = If[MemberQ[prepackedPreparedSampleContainerMismatches, True] && messages,
		(
			Message[
				Error::NoPreparedSample,
				ObjectToString[PickList[simulatedSamples, prepackedPreparedSampleContainerMismatches], Cache -> cacheBall]
			];
			{PreparedSampleContainer}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	mismatchedPrepackedPreparedTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, prepackedPreparedSampleContainerMismatches];
			passingInputs = PickList[simulatedSamples, prepackedPreparedSampleContainerMismatches, False];

			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["PreparedSampleContainer is Null for the following input samples which are prepacked in capillary tube: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];

			(*Create a test for the passing inputs.*)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["PreparedSampleContainer is Null for the following input samples which are prepacked in capillary tube: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(*Return our created tests.*)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(*throw an error if RecoupSample is False but PreparedSampleContainer is not Null*)
	recoupSampleContainerMismatchOptions = If[MemberQ[recoupSampleContainerMismatches, True] && messages,
		(
			Message[
				Error::InvalidPreparedSampleContainer,
				ObjectToString[PickList[simulatedSamples, recoupSampleContainerMismatches], Cache -> cacheBall]
			];
			{RecoupSample, PreparedSampleContainer}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	recoupSampleContainerMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, recoupSampleContainerMismatches];
			passingInputs = PickList[simulatedSamples, recoupSampleContainerMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If RecoupSample is False or Null, PreparedSampleContainer is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If RecoupSample is False or Null, PreparedSampleContainer is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];


	(*throw an error if RecoupSample is False but PreparedSampleStorageCondition is not Null*)
	recoupStorageMismatchOptions = If[MemberQ[recoupStorageConditionMismatches, True] && messages,
		(
			Message[
				Error::InvalidPreparedSampleStorageCondition,
				ObjectToString[PickList[simulatedSamples, recoupStorageConditionMismatches], Cache -> cacheBall]
			];
			{RecoupSample, PreparedSampleStorageCondition}
		),
		{}
	];

	(*Create appropriate tests if gathering them, or return {}*)
	recoupStorageMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(*Get the failing and not failing samples*)
			failingInputs = PickList[simulatedSamples, recoupStorageConditionMismatches];
			passingInputs = PickList[simulatedSamples, recoupStorageConditionMismatches, False];
			(*Create the passing and failing tests*)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If RecoupSample is False or Null, PreparedSampleStorageCondition is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If RecoupSample is False or Null, PreparedSampleStorageCondition is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
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
				Test["If the sample is prepacked in a melting point capillary, NumberOfReplicates is Null for the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* gather all the resolved options together *)
	(* doing this ReplaceRule ensures that any newly-added defaulted ProtocolOptions are going to be just included in myOptions*)
	resolvedOptions = ReplaceRule[
		myOptions,
		Flatten[{
            MeasurementMethod -> unresolvedMeasurementMethod,
			OrderOfOperations -> resolvedOrderOfOperations,
			ExpectedMeltingPoint -> resolvedExpectedMeltingPoint,
			NumberOfReplicates -> resolvedNumberOfReplicates,
			Amount -> resolvedAmount,
			SampleLabel -> resolvedSampleLabel,
			SampleContainerLabel -> resolvedSampleContainerLabel,
			PreparedSampleLabel -> resolvedPreparedSampleLabel,
			PreparedSampleContainerLabel -> resolvedPreparedSampleContainerLabel,
			Grind -> grindQs,
			GrinderType -> Lookup[resolvedGrindOptions, GrinderType],
			Grinder -> Lookup[resolvedGrindOptions, Grinder],
			Fineness -> Lookup[resolvedGrindOptions, Fineness],
			BulkDensity -> Lookup[resolvedGrindOptions, BulkDensity],
			GrindingContainer -> Lookup[resolvedGrindOptions, GrindingContainer],
			GrindingBead -> Lookup[resolvedGrindOptions, GrindingBead],
			NumberOfGrindingBeads -> Lookup[resolvedGrindOptions, NumberOfGrindingBeads],
			GrindingRate -> Lookup[resolvedGrindOptions, GrindingRate],
			GrindingTime -> Lookup[resolvedGrindOptions, GrindingTime],
			NumberOfGrindingSteps -> Lookup[resolvedGrindOptions, NumberOfGrindingSteps],
			CoolingTime -> Lookup[resolvedGrindOptions, CoolingTime],
			GrindingProfile -> Lookup[resolvedGrindOptions, GrindingProfile],
			Desiccate -> desiccateQs,
			SampleContainer -> Lookup[resolvedDesiccateIndexMatchedOptions, SampleContainer],
			DesiccationMethod -> Lookup[resolvedDesiccateSingletonOptions, DesiccationMethod],
			Desiccant -> Lookup[resolvedDesiccateSingletonOptions, Desiccant],
			DesiccantPhase -> Lookup[resolvedDesiccateSingletonOptions, DesiccantPhase],
			DesiccantAmount -> Lookup[resolvedDesiccateSingletonOptions, DesiccantAmount],
			Desiccator -> Lookup[resolvedDesiccateSingletonOptions, Desiccator],
			DesiccationTime -> Lookup[resolvedDesiccateSingletonOptions, DesiccationTime],
			SealCapillary -> resolvedSealCapillary,
			Instrument -> unresolvedInstrument,
			StartTemperature -> resolvedStartTemperature,
			EquilibrationTime -> equilibrationTime,
			EndTemperature -> resolvedEndTemperature,
			TemperatureRampRate -> resolvedTemperatureRampRate,
			RampTime -> resolvedRampTime,
			RecoupSample -> resolvedRecoupSample,
			PreparedSampleContainer -> resolvedPreparedSampleContainer,
			PreparedSampleStorageCondition -> preparedSampleStorageCondition,
			CapillaryStorageCondition -> capillaryStorageCondition,
			resolvedPostProcessingOptions
		}]
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{
		nonSolidSampleInvalidInputs,
		discardedInvalidInputs
	}]];

	(* gather all the invalid options together *)
	invalidOptions = DeleteDuplicates[Flatten[{
		desiccatePrepackedMismatchOptions,
		prepackedSampleContainerMismatchOptions,
		desiccateSampleContainerMismatchOptions,
		prepackedDesiccationMethodMismatchOptions,
		desiccateDesiccationMethodMismatchOptions,
		prepackedDesiccantMismatchOptions,
		desiccateDesiccantMismatchOptions,
		prepackedDesiccantPhaseMismatchOptions,
		desiccateDesiccantPhaseMismatchOptions,
		prepackedDesiccantAmountMismatchOptions,
		desiccateDesiccantAmountMismatchOptions,
		prepackedDesiccatorMismatchOptions,
		desiccateDesiccatorMismatchOptions,
		prepackedDesiccationTimeMismatchOptions,
		desiccateDesiccationTimeMismatchOptions,
		grindPrepackedMismatchOptions,
		prepackedGrinderTypeMismatchOptions,
		grindGrinderTypeMismatchOptions,
		prepackedGrinderMismatchOptions,
		grindGrinderMismatchOptions,
		prepackedFinenessMismatchOptions,
		grindFinenessMismatchOptions,
		prepackedBulkDensityMismatchOptions,
		grindBulkDensityMismatchOptions,
		prepackedGrindingContainerMismatchOptions,
		grindGrindingContainerMismatchOptions,
		prepackedGrindingBeadMismatchOptions,
		grindGrindingBeadMismatchOptions,
		prepackedNumberOfGrindingBeadsMismatchOptions,
		grindNumberOfGrindingBeadsMismatchOptions,
		prepackedGrindingRateMismatchOptions,
		grindGrindingRateMismatchOptions,
		prepackedGrindingTimeMismatchOptions,
		grindGrindingTimeMismatchOptions,
		prepackedNumberOfGrindingStepsMismatchOptions,
		grindNumberOfGrindingStepsMismatchOptions,
		prepackedCoolingTimeMismatchOptions,
		grindCoolingTimeMismatchOptions,
		prepackedGrindingProfileMismatchOptions,
		grindGrindingProfileMismatchOptions,
		orderInvalidOptions,
		expectedMeltingPointInvalidOptions,
		startEndTemperatureInvalidOptions,
		recoupSampleContainerMismatchOptions,
		recoupStorageMismatchOptions,
		numberOfReplicatesMismatchedOptions,
		mismatchedRecoupPrepackedOptions,
		mismatchedPrepackedPreparedOptions
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
		extraneousOrderTest,
		desiccatePrepackedMismatchTest,
		prepackedSampleContainerMismatchTest,
		desiccateSampleContainerMismatchTest,
		prepackedDesiccationMethodMismatchTest,
		desiccateDesiccationMethodMismatchTest,
		prepackedDesiccantMismatchTest,
		desiccateDesiccantMismatchTest,
		prepackedDesiccantPhaseMismatchTest,
		desiccateDesiccantPhaseMismatchTest,
		prepackedDesiccantAmountMismatchTest,
		desiccateDesiccantAmountMismatchTest,
		prepackedDesiccatorMismatchTest,
		desiccateDesiccatorMismatchTest,
		prepackedDesiccationTimeMismatchTest,
		desiccateDesiccationTimeMismatchTest,
		grindPrepackedMismatchTest,
		prepackedGrinderTypeMismatchTest,
		prepackedGrinderMismatchTest,
		grindGrinderMismatchTest,
		prepackedFinenessMismatchTest,
		grindFinenessMismatchTest,
		prepackedBulkDensityMismatchTest,
		grindBulkDensityMismatchTest,
		prepackedGrindingContainerMismatchTest,
		grindGrindingContainerMismatchTest,
		prepackedGrindingBeadMismatchTest,
		grindGrindingBeadMismatchTest,
		prepackedNumberOfGrindingBeadsMismatchTest,
		grindNumberOfGrindingBeadsMismatchTest,
		prepackedGrindingRateMismatchTest,
		grindGrindingRateMismatchTest,
		prepackedGrindingTimeMismatchTest,
		grindGrindingTimeMismatchTest,
		prepackedNumberOfGrindingStepsMismatchTest,
		grindNumberOfGrindingStepsMismatchTest,
		prepackedCoolingTimeMismatchTest,
		grindCoolingTimeMismatchTest,
		prepackedGrindingProfileMismatchTest,
		grindGrindingProfileMismatchTest,
		grindGrinderTypeMismatchTest,
		orderTest,
		expectedMeltingPointInvalidTest,
		startEndTemperatureInvalidTest,
		mismatchedRampRateRampTimeTest,
		recoupSampleContainerMismatchTest,
		mismatchedRecoupPrepackedTest,
		mismatchedPrepackedPreparedTest,
		recoupStorageMismatchTest,
		numberOfReplicatesMismatchedTest,
		desiccateTests,
		grindTests
	}], TestP];

	(* pending to add updatedExperimentGrindSimulation to the Result *)
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
		safeOps, outputSpecification, output, gatherTests, messages, desiccator,
		cache, simulation, fastAssoc, simulatedSamples, desiccationTime,
		updatedSimulation, simulatedSampleContainers, samplesInResources,
		desiccantResources, inputSampleContainers,
		capillaryNumbers, prepackedQ, meltingPointCapillaries, meltingPointCapillary,
		capillaryResourceNames, capillaryResources,
		preparationUnitOperations, desiccateFirstOptions, packingDevices,
		capillarySeal, capillarySealResource, capillarySealResources, packingDevice,
		sampleContainerResources, grindingContainerResources,
		preparedSampleContainerResources, grindFirstQ, grindSecondQ,
		grindFirstSamples, grindSampleOutLabels, grindSampleToLabelRules,
		desiccateSamples, desiccateSampleOutLabels, desiccateSampleToLabelRules,
		grindSecondSamples, grindOptionKeys, grindOptions, grindFirstOptions,
		grindSecondOptions, packingDeviceResource, desiccateOptionKeys, desiccateOptions,
		allInstruments, instrumentTimeRules, totalGrindTimes, desiccatorResources,
		grinderResourceRules, grinderResources, mergedGrinderTimes, grinderTimeRules,
		desiccationMethod, desiccant, desiccantPhase, desiccantAmount,
        measurementMethod, orderOfOperations, expectedMeltingPoint, numberOfReplicates,
		sealCapillary, instrument, startTemperature, equilibrationTime, endTemperature,
		temperatureRampRate, rampTime, recoupSample, preparedSampleContainer,
		preparedSampleStorageCondition, capillaryStorageCondition, desiccateQs,
		realGrindQs, grindQs, amount, sampleContainer, grinderType, grinder, fineness, bulkDensity,
		grindingContainer, grindingBead, numberOfGrindingBeads, grindingRate,
		grindingTime, numberOfGrindingSteps, coolingTime, grindingProfile,
		preparedSampleLabel, preparedSampleContainerLabel, instrumentTag,
		instruments, grindingBeadResourceRules, mergedBeadsAndNumbers,
		sampleGroupedOptions, sampleGrouper, beadsAndNumbers, sampleLabel,
		sampleContainerLabel, unitOperationPackets,
		instrumentResources, grindingBeadResources,
		updatedPreparedSampleStorageCondition, sampleModels, numericAmount,
		updatedCapillaryStorageCondition, grindFirstOptionRules,
		nonIndexMatchedDesiccateOptionKeys, indexMatchedDesiccateOptionKeys,
		nonIndexMatchedDesiccateOptions, indexMatchedDesiccateOptions,
		desiccateFirstIndexMatchedOptions, desiccateFirstNonIndexMatchedOptionRules,
		desiccateFirstIndexMatchedOptionRules, grindSecondOptionRules,
		groupedOptions, protocolPacket, totalInstrumentTime,
		sharedFieldPacket, finalizedPacket, instrumentModel,
		grindingContainerModel, allResourceBlobs, capillaryRod, capillaryRodResources,
		fulfillable, frqTests, previewRule, optionsRule, testsRule, resultRule
	},

	(*get the safe options for this function*)
	safeOps = SafeOptions[measureMeltingPointResourcePackets, ToList[myOptions]];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentMeasureMeltingPoint,
		RemoveHiddenOptions[ExperimentMeasureMeltingPoint, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

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
	simulatedSampleContainers = Download[simulatedSamples, Container[Object], Cache -> cache, Simulation -> updatedSimulation];

	(* lookup option values*)
	{
		(*1*)orderOfOperations,
		(*2*)expectedMeltingPoint,
		(*3*)numberOfReplicates,
		(*4*)amount,
		(*5*)preparedSampleLabel,
		(*6*)preparedSampleContainerLabel,
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
		(*19*)grindingProfile,
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
		(*35*)recoupSample,
		(*36*)preparedSampleContainer,
		(*37*)preparedSampleStorageCondition,
		(*38*)capillaryStorageCondition,
		(*40*)sampleLabel,
		(*41*)sampleContainerLabel,
        (*42*)measurementMethod
	} = Lookup[
		myResolvedOptions,
		{
			(*1*)OrderOfOperations,
			(*2*)ExpectedMeltingPoint,
			(*3*)NumberOfReplicates,
			(*4*)Amount,
			(*5*)PreparedSampleLabel,
			(*6*)PreparedSampleContainerLabel,
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
			(*35*)RecoupSample,
			(*36*)PreparedSampleContainer,
			(*37*)PreparedSampleStorageCondition,
			(*38*)CapillaryStorageCondition,
			(*40*)SampleLabel,
			(*41*)SampleContainerLabel,
            (*42*)MeasurementMethod
		}
	];

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

	(* if the sample is prepacked but Grind is set to True by the user, the sample cannot be ground. realGrindQs determines when the Grind is True and the the sample is not prepacked *)
	realGrindQs = MapThread[And, {grindQs, Not /@ prepackedQ}];

	(* --- Make all the resources needed in the experiment --- *)
	(*Update amount value to quantity if it is resolved to All*)
	numericAmount = MapThread[If[
		MatchQ[#1, All], fastAssocLookup[fastAssoc, #2, Mass], #1
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
	desiccatorResources = If[MatchQ[desiccator, Null], Null,
		Link[Resource[Instrument -> desiccator, Time -> desiccationTime, Name -> desiccator /. instrumentTag]]
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
		Instrument -> instrument, Time -> totalInstrumentTime, Name -> CreateUniqueLabel["Melting Point Apparatus"]
	]];

	(* --- Resources for Desiccate --- *)
	(* Desiccant resource if not Null *)
	desiccantResources = If[NullQ[desiccant], Null,
		Link[Resource[
			Sample -> desiccant,
			Container -> Model[Container, Vessel, "id:4pO6dMOxdbJM"], (* Pyrex Crystallization Dish *)
			Amount -> desiccantAmount, RentContainer -> True]]
	];

	(* SampleContainer resource if not Null *)
	sampleContainerResources = If[
		NullQ[#1],
		Null,
		Link[Resource[Sample -> #, Name -> CreateUniqueLabel["Sample Container "]]]]& /@ sampleContainer;

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

	(* --- Resources for PreparedSample --- *)
	preparedSampleContainerResources = MapThread[If[TrueQ[#1] || NullQ[#2], Null,
		Resource[Sample -> #2, Name -> #3]]&,
		{prepackedQ, preparedSampleContainer, preparedSampleContainerLabel}
	];


	grindingContainerModel = If[
		MatchQ[#, ObjectP[Object]],
		fastAssocLookup[fastAssoc, #, Model],
		#
	]& /@ grindingContainer;

	instrumentModel = If[
		MatchQ[#, ObjectP[Object]],
		fastAssocLookup[fastAssoc, #, Model],
		#
	]& /@ instruments;

	(*Change PreparedSampleStorageCondition to Model's default if it is resolved to Null*)
	sampleModels = Download[fastAssocLookup[fastAssoc, #, Model], Object]& /@ ToList[mySamples];

	updatedPreparedSampleStorageCondition = MapThread[
		If[NullQ[#1] && !TrueQ[2] && (TrueQ[3] || TrueQ[4]), Download[fastAssocLookup[fastAssoc, #5, DefaultStorageCondition], Object], #1]&,
		{preparedSampleStorageCondition, prepackedQ, realGrindQs, desiccateQs, sampleModels}
	];

	(*Change CapillaryStorageCondition to Model's default if it is resolved to Null*)
	updatedCapillaryStorageCondition = MapThread[
		Which[
			NullQ[#1], Link@Download[fastAssocLookup[fastAssoc, #2, DefaultStorageCondition], Object],
			MatchQ[#1, ObjectP[Model[StorageCondition]]], Link@#1,
			True, #1]&,
		{capillaryStorageCondition, sampleModels}
	];

	(****This block is a sample preparation step for samples are set to be ground and/or desiccated. This is a three-step process. In the first step the samples that are {Grind->True and Desiccate->False} are ground with samples that are {Grind&Desiccate->True and OrderOfOperations->{Grind,Desiccate}}. the second step is a desiccation step for all samples that should be desiccated. The third step is another Grind step for samples that are {Grind&Desiccate->True and OrderOfOperations->{Desiccate,Grind}}****)

	(*Preparation steps: Grind and Desiccate before packing the sample into melting point capillary*)
	(*A list of booleans to determine which samples should be ground first (before desiccate) *)
	grindFirstQ = MapThread[TrueQ[#1] && (MatchQ[#3, ({Grind, _} | Null)] || !TrueQ[#2])&, {realGrindQs, desiccateQs, orderOfOperations}];

	(*A list of booleans to determine which samples should be ground second (after desiccate) *)
	grindSecondQ = MapThread[!TrueQ[#1] && TrueQ[#2] && MatchQ[#3, ({_, Grind} | Null)]&, {grindFirstQ, realGrindQs, orderOfOperations}];

	(*Samples that should be ground first*)
	grindFirstSamples = PickList[ToList[mySamples], grindFirstQ];
	grindSampleOutLabels = ToString[#, InputForm]& /@ grindFirstSamples;
	grindSampleToLabelRules = AssociationThread[grindFirstSamples, grindSampleOutLabels];

	(*Samples that should be desiccated*)
	desiccateSamples = PickList[ToList[mySamples], desiccateQs];
	desiccateSampleOutLabels = Map[
		If[StringQ[# /. grindSampleToLabelRules],
			Automatic,
			"SampleOut " <> StringDrop[Download[#, ID], 3]
		]&,
		desiccateSamples
	];

	desiccateSampleToLabelRules = AssociationThread[desiccateSamples, desiccateSampleOutLabels];

	(*Samples that should be ground second*)
	grindSecondSamples = PickList[ToList[mySamples], grindSecondQ];

	(*option names that are use in this experiment for Grind*)
	grindOptionKeys = {
		Amount, BulkDensity, CoolingTime, Fineness, GrinderType, GrindingBead,
		GrindingContainer, GrindingProfile, GrindingRate, Grinder,
		NumberOfGrindingBeads, NumberOfGrindingSteps, SampleLabel, GrindingTime};

	(*Values of Grind options*)
	grindOptions = Lookup[Join[myResolvedOptions, myUnresolvedOptions], grindOptionKeys];

	(*grind option values for samples that should be ground first (before desiccate). In MM12, Transpose[{}] = error, so {} should be replaced with {{}, {}} *)
	grindFirstOptions = Transpose[PickList[Transpose[grindOptions], grindFirstQ] /. {} -> {{}, {}}];

	(*grind option rules for samples that should be ground first (before desiccate). In MM12, Transpose[{}] = error, so {} should be replaced with {{}, {}} *)
	grindFirstOptionRules = If[NullQ[grindFirstOptions /. {{} -> Null}], Null,
		MapThread[Rule, {grindOptionKeys /. {Grinder -> Instrument, GrindingTime -> Time}, grindFirstOptions /. {} -> {{}, {}}}]
	];

	(*grind options for samples that should be ground second (after desiccate). In MM12, Transpose[{}] = error, so {} should be replaced with {{}, {}}  *)
	grindSecondOptions = Transpose[PickList[Transpose[grindOptions], grindSecondQ] /. {} -> {{}, {}}];

	(*grind option rules for samples that should be ground second (after desiccate), In MM12, Transpose[{}] = error, so {} should be replaced with {{}, {}} *)
	grindSecondOptionRules = If[NullQ[grindSecondOptions /. {{} -> Null}], Null,
		MapThread[Rule, {grindOptionKeys /. {Grinder -> Instrument, GrindingTime -> Time}, grindSecondOptions /. {} -> {{}, {}}}]
	];

	(*Non-indexmatching option names that are use in this experiment for Desiccate*)
	nonIndexMatchedDesiccateOptionKeys = {Desiccant, DesiccantAmount, DesiccantPhase, Desiccator, DesiccationTime};

	(*Indexmatching option names that are use in this experiment for Desiccate*)
	indexMatchedDesiccateOptionKeys = {Amount, SampleContainer, SampleContainerLabel, SampleLabel};

	(*Values of Non-indexmatching Desiccate options*)
	nonIndexMatchedDesiccateOptions = Lookup[Join[myResolvedOptions, myUnresolvedOptions], nonIndexMatchedDesiccateOptionKeys];

	(*NonIndexMatched desiccate option rules for samples that should be desiccated *)
	desiccateFirstNonIndexMatchedOptionRules = If[NullQ[nonIndexMatchedDesiccateOptions /. {{} -> Null}], Null,
		MapThread[Rule, {nonIndexMatchedDesiccateOptionKeys /. {DesiccationTime -> Time}, nonIndexMatchedDesiccateOptions}]
	];

	(*Values of indexmatching Desiccate options*)
	indexMatchedDesiccateOptions = Lookup[Join[myResolvedOptions, myUnresolvedOptions], indexMatchedDesiccateOptionKeys];

	(*Values of indexmatching Desiccate options for samples that should be desiccated. In MM12, Transpose[{}] = error, so {} should be replaced with {{}, {}} *)
	desiccateFirstIndexMatchedOptions = Transpose[PickList[Transpose[indexMatchedDesiccateOptions], desiccateQs] /. {} -> {{}, {}}];

	(*IndexMatched desiccate option rules for samples that should be desiccated *)
	desiccateFirstIndexMatchedOptionRules = If[NullQ[desiccateFirstIndexMatchedOptions /. {{} -> Null}], Null,
		MapThread[Rule, {indexMatchedDesiccateOptionKeys, desiccateFirstIndexMatchedOptions}]
	];

	preparationUnitOperations = Which[
		!MemberQ[realGrindQs, True] && !MemberQ[desiccateQs, True], Null,

		!MemberQ[realGrindQs, True] && MemberQ[desiccateQs, True],
		{
			Desiccate[
				Sample -> desiccateSamples /. grindSampleToLabelRules,
				Sequence @@ desiccateFirstNonIndexMatchedOptionRules,
				Sequence @@ desiccateFirstIndexMatchedOptionRules
			]
		},

		MemberQ[realGrindQs, True] && !MemberQ[desiccateQs, True],
		{
			Grind[
				Sample -> grindFirstSamples,
				Sequence @@ grindFirstOptionRules
			]
		},

		NullQ[grindSecondOptionRules],
		{
			Grind[
				Sample -> grindFirstSamples,
				SampleOutLabel -> grindSampleOutLabels,
				Sequence @@ Normal@KeyDrop[grindFirstOptionRules, SampleOutLabel]
			],
			Desiccate[
				Sample -> desiccateSamples /. grindSampleToLabelRules,
				SampleOutLabel -> desiccateSampleOutLabels,
				Sequence @@ Normal@KeyDrop[desiccateFirstNonIndexMatchedOptionRules, SampleOutLabel],
				Sequence @@ desiccateFirstIndexMatchedOptionRules
			]
		},

		NullQ[grindFirstOptionRules],
		{
			Desiccate[
				Sample -> desiccateSamples /. grindSampleToLabelRules,
				SampleOutLabel -> desiccateSampleOutLabels,
				Sequence @@ Normal@KeyDrop[desiccateFirstNonIndexMatchedOptionRules, SampleOutLabel],
				Sequence @@ desiccateFirstIndexMatchedOptionRules
			],
			Grind[
				(*Sample->grindSecondSamples/.desiccateSampleToLabelRules,*)
				Sequence @@ grindSecondOptionRules
			]
		},

		True,
		{
			Grind[
				Sample -> grindFirstSamples,
				SampleOutLabel -> grindSampleOutLabels,
				Sequence @@ Normal@KeyDrop[grindFirstOptionRules, SampleOutLabel]
			],
			Desiccate[
				Sample -> desiccateSamples /. grindSampleToLabelRules,
				SampleOutLabel -> desiccateSampleOutLabels,
				Sequence @@ Normal@KeyDrop[desiccateFirstNonIndexMatchedOptionRules, SampleOutLabel],
				Sequence @@ desiccateFirstIndexMatchedOptionRules
			],
			Grind[
				Sample -> grindSecondSamples /. desiccateSampleToLabelRules,
				Sequence @@ grindSecondOptionRules
			]
		}
	];
	(****End of Sample Preparation Step****)

	(* group relevant options into batches *)
	(* NOTE THAT I HAVE TO REPLICATE THIS CODE TO SOME DEGREE IN grindPopulateWorkingSamples SO IF THE LOGIC CHANGES HERE CHANGE IT THERE TOO*)
	(* note that we don't actually have to do any grouping if we're doing robotic, then we just want a list so we are just grouping by the preparation *)
	groupedOptions = Experiment`Private`groupByKey[
		{
			(*General*)
			Sample -> Link /@ samplesInResources,
			WorkingSample -> Link /@ ToList[mySamples],
			OrderOfOperations -> orderOfOperations,
			ExpectedMeltingPoint -> expectedMeltingPoint,
			NumberOfReplicates -> numberOfReplicates,
			Amount -> amount,
			SampleLabel -> sampleLabel,
			SampleContainerLabel -> sampleContainerLabel,
			PreparedSampleLabel -> preparedSampleLabel,
			PreparedSampleContainerLabel -> preparedSampleContainerLabel,

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
			RecoupSample -> recoupSample,
			PreparedSampleContainer -> preparedSampleContainerResources,
			PreparedSampleStorageCondition -> updatedPreparedSampleStorageCondition,
			CapillaryStorageCondition -> updatedCapillaryStorageCondition
		},
		{NumberOfReplicates, StartTemperature, EquilibrationTime, EndTemperature, TemperatureRampRate, RampTime, Prepacked}
	];

	(*The meltingPointApparatus can only measure three capillaries at the same time. so if the NumberOfReplicates is 3 or 2, no need to group the samples (beyond groupByKey). if NumberOfReplicates is Null or 1, group the samples further in groups of three. This way, there will be one UnitOperation consisting all samples that have 2 or 3 capillaries and other UnitOperation's that have 3 samples in them (each containing up to 3 capillaries*)
	sampleGrouper[groupedOption : {_Rule..}] := Module[
		{grouperFunction, expandedOptions, mapFriendlyOptions,
			partitionedOptions, collapsedOptions, mergedOptions},

		grouperFunction = Function[{groupMe, number},
			expandedOptions = Thread /@ groupMe;
			mapFriendlyOptions = Transpose@expandedOptions;
			partitionedOptions = Partition[mapFriendlyOptions, UpTo[number]];
			collapsedOptions = Map[Transpose, partitionedOptions];
			mergedOptions = Sequence @@ Normal[Map[Merge[#, Join]&, collapsedOptions]]
		];

		If[First@Lookup[groupedOption, NumberOfCapillaries] > 1,
			grouperFunction[groupedOption, 1],
			grouperFunction[groupedOption, 3]]
	];

	(*group samples in three*)
	sampleGroupedOptions = Map[sampleGrouper, groupedOptions[[All, 2]]];

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
							PreparedSampleContainerLabel -> Lookup[options, PreparedSampleContainerLabel],
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
							DesiccantPhase -> desiccantPhase,
							DesiccantAmount -> desiccantAmount,
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
							RecoupSample -> Lookup[options, RecoupSample],
							PreparedSampleContainer -> Lookup[options, PreparedSampleContainer],
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
			Replace[SamplesIn] -> samplesInResources,
			(*General*)
			Replace[OrdersOfOperations] -> orderOfOperations,
            MeasurementMethod -> measurementMethod,
            Replace[ExpectedMeltingPoints] -> expectedMeltingPoint,
			Replace[NumbersOfReplicates] -> numberOfReplicates,
			Replace[Amounts] -> amount,
			Rod -> capillaryRodResources,
			(*Labels*)
			Replace[SampleLabels] -> sampleLabel,
			Replace[SampleContainerLabels] -> sampleContainerLabel,
			Replace[PreparedSampleLabels] -> preparedSampleLabel,
			Replace[PreparedSampleContainerLabels] -> preparedSampleContainerLabel,
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
			DesiccantPhase -> desiccantPhase,
			DesiccantAmount -> desiccantAmount,
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
			Replace[RecoupSamples] -> recoupSample,
			Replace[PreparedSampleContainers] -> preparedSampleContainerResources,
			Replace[PreparedSampleStorageConditions] -> Link /@ updatedPreparedSampleStorageCondition,
			Replace[CapillaryStorageConditions] -> updatedCapillaryStorageCondition,

			UnresolvedOptions -> myUnresolvedOptions,
			ResolvedOptions -> myResolvedOptions,
			Replace[Checkpoints] -> {
				{"Picking Resources", 45Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 45Minute]]},
				{"Preparing Samples", Total@mergedGrinderTimes + desiccationTime /. Null -> 0, "Preprocessing, such as desiccation and grinding is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> (Total@mergedGrinderTimes + desiccationTime /. Null -> 0)]]},
				{"Running Experiment", totalInstrumentTime, "The samples are being ground into smaller particles via the grinders.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> totalInstrumentTime]]},
				{"Sample Post-Processing", 60Minute, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 60Minute]]},
				{"Returning Materials", 45Minute, "Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 45Minute]]}
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
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[protocolPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Simulation -> updatedSimulation, Site -> Lookup[myResolvedOptions, Site], Cache -> cache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Simulation -> updatedSimulation, Messages -> messages, Site -> Lookup[myResolvedOptions, Site], Cache -> cache], Null}
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
		{protocolPacket, unitOperationPackets},
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
		amount, cache, capillarySourceSample, capillaryNumbers, capillaryResourceNames, capillaryResources, currentSimulation, desiccateQs, fastAssoc, grindQs, inputSampleContainers, inputSampleModel, mapThreadFriendlyOptions, meltingPointCapillaries, meltingPointCapillary, newSamplePackets, numberOfReplicates, numericAmount, prepackedQ, preparedSampleContainer, preparedSampleContainerLabel, preparedSampleContainerResources, preparedSampleObject, preparedSampleLabel, protocolObject, recoupSourceSample, recoupSampleQ, sampleContainerLabel, sampleContainer, sampleContainerResources, sampleLabel, samplesInResources, sealCapillary, simulatedCapillaryDestination, simulatedCapillaryObjects, simulatedNewSamples, simulatedPreparedSampleContainer, simulatedPreparedSampleDestination, simulatedSampleContainer, simulation, simulationWithLabels, sourceSamplePackets, uploadSampleTransferPackets
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
		(*6*)preparedSampleContainerLabel,
		(*7*)grindQs,
		(*20*)desiccateQs,
		(*21*)sampleContainer,
		(*28*)sealCapillary,
		(*35*)recoupSampleQ,
		(*36*)preparedSampleContainer,
		(*40*)sampleLabel,
		(*41*)sampleContainerLabel
	} = Lookup[
		myResolvedOptions,
		{
			(*3*)NumberOfReplicates,
			(*4*)Amount,
			(*5*)PreparedSampleLabel,
			(*6*)PreparedSampleContainerLabel,
			(*7*)Grind,
			(*20*)Desiccate,
			(*21*)SampleContainer,
			(*28*)SealCapillary,
			(*35*)RecoupSample,
			(*36*)PreparedSampleContainer,
			(*40*)SampleLabel,
			(*41*)SampleContainerLabel
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

	(* --- Make resources needed in the simulation --- *)
	(*Update amount value to quantity if it is resolved to All*)
	numericAmount = MapThread[If[
		MatchQ[#1, All], fastAssocLookup[fastAssoc, #2, Mass], #1
	]&, {amount, ToList[mySamples]}];

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
	preparedSampleContainerResources = MapThread[
		If[
			TrueQ[#1] || NullQ[#2] || !TrueQ[#3],
			Null,
			Resource[Sample -> #2, Name -> CreateUniqueLabel["Simulation preparedSampleContainerLabel "]]]&,
		{prepackedQ, preparedSampleContainer, recoupSampleQ}
	];

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
							Replace[PreparedSampleContainer] -> preparedSampleContainerResources,
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
				Replace[PreparedSampleContainers] -> (Link[#]&) /@ preparedSampleContainerResources,
				ResolvedOptions -> myResolvedOptions
			|>;

			SimulateResources[protocolPacket, measureMeltingPointUnitOperationPackets, Simulation -> simulation]
		],

		(* Otherwise, our resource packets went fine and we have an Object[Protocol, MeasureMeltingPoint]. *)
		SimulateResources[myProtocolPacket, myUnitOperationPackets, ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null], Simulation -> simulation]
	];

	(*Download simulated preparedSampleContainer and Capillary Objects from simulation*)
	{
		simulatedPreparedSampleContainer,
		simulatedCapillaryObjects,
		simulatedSampleContainer
	} = Download[protocolObject,
		{
			PreparedSampleContainers,
			CapillaryResource,
			SampleContainers
		},
		Simulation -> currentSimulation
	];

	(*Create new samples for simulating transfer*)
	(*Add position "A1" to destination containers to create destination locations*)
	simulatedCapillaryDestination = Map[If[NullQ[#], Null, {"A1", #}]&, simulatedCapillaryObjects];

	simulatedPreparedSampleDestination = Map[If[NullQ[#], Null, {"A1", #}]&, simulatedPreparedSampleContainer];

	(*Models of input samples*)
	inputSampleModel = If[MatchQ[#, ObjectP[Model[Sample]]], #, fastAssocLookup[fastAssoc, #, Model]]& /@ ToList[mySamples];

	capillaryNumbers = MapThread[If[TrueQ[#1], 0, #2]&,
		{prepackedQ, numberOfReplicates /. {Null -> 1}}];

	(*Models of samples that g o into the capillaries*)
	capillarySourceSample = Flatten@MapThread[ConstantArray[#1, #2]&, {ToList[mySamples], capillaryNumbers}];

	(*Sample models that should be recouped*)
	recoupSourceSample = MapThread[If[!TrueQ[#1] && TrueQ[#2], #3, Nothing]&, {prepackedQ, recoupSampleQ, ToList[mySamples]}];

	(* create sample out packets for anything that doesn't have sample in it already, this is pre-allocation for UploadSampleTransfer *)
	newSamplePackets = UploadSample[
		(* Note: UploadSample takes in {} if there is no Model and we have no idea what's in it, which is the case here *)
		ConstantArray[{}, Length[DeleteCases[Join[simulatedCapillaryDestination, simulatedPreparedSampleDestination], Null]]],
		DeleteCases[Join[simulatedCapillaryDestination, simulatedPreparedSampleDestination], Null],
		State -> ConstantArray[Solid, Length[DeleteCases[Join[simulatedCapillaryDestination, simulatedPreparedSampleDestination], Null]]],
		InitialAmount -> ConstantArray[Null, Length[DeleteCases[Join[simulatedCapillaryDestination, simulatedPreparedSampleDestination], Null]]],
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
		Join[capillarySourceSample, recoupSourceSample],
		simulatedNewSamples,
		(*here we assume the amount of sample in the capillary is 5 mg. can be updated to a more accurate amount if needed*)
		Join[ConstantArray[5Milligram, Length[capillarySourceSample]], MapThread[If[!#1 && (#2 /. {Null -> False}), #3, Nothing]&, {prepackedQ, recoupSampleQ, amount}]],
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
			],
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, PreparedSampleContainerLabel]], simulatedPreparedSampleContainer}],
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
			],
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, PreparedSampleContainerLabel]], (Field[PreparedSampleContainer[[#]]]&) /@ Range[Length[simulatedPreparedSampleContainer]]}],
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
Authors[MeasureMeltingPoint] := {"Mohamad.Zandian"};

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

ExperimentMeasureMeltingPointOptions[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
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


ValidExperimentMeasureMeltingPointQ[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
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

ExperimentMeasureMeltingPointPreview[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
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