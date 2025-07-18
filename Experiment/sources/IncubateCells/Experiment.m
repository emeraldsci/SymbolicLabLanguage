(* ::Package:: *)

(* ::Title:: *)
(*Experiment IncubateCells: Source*)


(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*ExperimentIncubateCells*)


(* ::Subsection::Closed:: *)
(*Options*)
DefineOptions[
	ExperimentIncubateCells,
	Options :> {
		{
			OptionName -> Time,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Hour, $MaxCellIncubationTime],(*72 Hour*)
				Units ->  {Hour, {Hour, Day}}
			],
			Description -> If[TrueQ[$IncubateCellsIncubateOnly],
				(*v1*)
				"The duration during which the input cells are incubated inside of cell incubators.",
				(*v2*)
				"The duration during which the input cells are incubated inside of cell incubators. If the IncubationStrategy is QuantificationTarget, this option represents the maximum duration for which the cells are incubated while attempting to reach the MinQuantificationTarget; if this target is not reached within the specified Time, the FailureResponse is executed."],
			ResolutionDescription ->  If[TrueQ[$IncubateCellsIncubateOnly],
				(*v1*)
				"If Preparation is set to Robotic, automatically set to " <> ToString[$MaxRoboticIncubationTime] <> ". If Preparation is set to Manual, automatically set to the shorter time between " <> ToString[$MaxCellIncubationTime] <> " and 36 times the shortest DoublingTime of the cells in the sample.",
				(*v2*)
				"If Preparation is set to Robotic, automatically set to " <> ToString[$MaxRoboticIncubationTime] <> ". If Preparation is set to Manual and IncubationStrategy is set to Time, automatically set to the shorter time between " <> ToString[$MaxCellIncubationTime] <> " and 36 times the shortest DoublingTime of the cells in the sample. If Preparation is set to Manual and IncubationStrategy is set to QuantificationTarget, automatically set to 12 Hour."],
			Category -> "General"
		},

		(* Quantification Non-Index matching options *)
		{
			OptionName -> IncubationStrategy,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Time|QuantificationTarget
			],
			Description -> "The manner in which the end of the incubation period is determined. If the IncubationStrategy is Time, incubation will proceed until after the specified Time has elapsed from the beginning of incubation. If the IncubationStrategy is QuantificationTarget, incubation will proceed until either a) ALL of the samples in the protocol meet their respective MinQuantificationTargets or b) the Time has elapsed, whichever occurs first.",
			ResolutionDescription -> "If QuantificationMethod or any options defining quantification conditions are specified, automatically set to QuantificationTarget. Otherwise, automatically set to Time.",
			Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "General"]
		},
		{
			OptionName -> QuantificationMethod,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Nephelometry|Absorbance|ColonyCount
			],
			Description -> "The analytical method employed to assess the quantity or concentration of cells contained within the sample.",
			ResolutionDescription -> "If any options unique to a particular QuantificationMethod are specified, automatically set to that method. If IncubationStrategy is set to QuantificationTarget but no options unique to a quantification method are specified, automatically set to Absorbance.",
			Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "Quantification"]
		},
		{
			OptionName -> QuantificationInstrument,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[
					{
						Object[Instrument, Nephelometer],
						Object[Instrument, Spectrophotometer],
						Object[Instrument, PlateReader],
						Object[Instrument, ColonyHandler],
						Model[Instrument, Nephelometer],
						Model[Instrument, Spectrophotometer],
						Model[Instrument, PlateReader],
						Model[Instrument, ColonyHandler]
					}
				]
			],
			Description -> "The instrument used to assess the concentration of cells in the sample at every QuantificationInterval.",
			ResolutionDescription -> "If QuantificationMethod is not Null, automatically set to an instrument model appropriate for the specified QuantificationMethod and QuantificationWavelength.",
			Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "Quantification"]
		},
		{
			OptionName -> QuantificationInterval,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[1 Hour, $MaxCellIncubationTime],
				Units -> Hour
			],
			Description -> "The duration of time that elapses between each quantification of the cells in the sample.",
			ResolutionDescription -> "If IncubationStrategy is QuantificationTarget, automatically set to one-fifth of the Time or 1 Hour, whichever is greater.",
			Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "Quantification"]
		},
		{
			OptionName -> QuantificationAliquot,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if an aliquot of cell sample is transferred to a new container prior to quantification rather than being analyzed in the cell sample's current container.",
			ResolutionDescription -> "If any of QuantificationAliquotVolume, QuantificationAliquotContainer, or QuantificationRecoupSample are specified, automatically set to True. If none of these options are specified but the sample's current container is incompatible with the QuantificationInstrument, automatically set to True.",
			Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "Quantification"]
		},
		{
			OptionName -> QuantificationRecoupSample,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the sample is to be recovered back into its original container after measurement using the QuantificationMethod.",
			ResolutionDescription -> "If QuantificationAliquot is True, automatically set to False.",
			Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "Quantification"]
		},
		{
			OptionName -> FailureResponse,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Incubate|Freeze|Discard
			],
			Description -> "The manner in which the cell samples are to be processed in the event that the MinQuantificationTarget is not reached before the Time elapses from the beginning of cell incubation. Incubate specifies that the cell sample is to be kept in its current IncubationCondition and is not available for samples using a Custom incubation condition. Freeze specifies that, following addition of a volume of Model[Sample, \"Glycerol\"] equal to 10% of the current sample volume and distribution into cryogenic vials, the cell sample is to be frozen in an isopropanol-filled insulated cooler at -80 Celsius for 12 Hour before being transferred to cryogenic storage. Discard specifies that the sample and its container are to be safely disposed of. Due to equipment constraints, Freeze is only available for protocols with no more than 12 samples, and only suspension samples with a volume of 4.5 Milliliter or less can be frozen. Note that, in the current version of ExperimentIncubateCells, the FailureResponse will be initiated for all samples in a protocol if any one of the samples fails to meet its MinQuantificationTarget before the Time elapses.",
			ResolutionDescription -> "If IncubationStrategy is QuantificationTarget, automatically set to Discard.",
			Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "Quantification"]
		},
		{
			OptionName -> QuantificationBlankMeasurement,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if a blank measurement is to be recorded and used to subtract background noise from the quantification measurement.",
			ResolutionDescription -> "If QuantificationMethod is Absorbance or Nephelometry, automatically set to True.",
			Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "Quantification"]
		},
		(*Index-matching options*)
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the input samples to be incubated, for use in downstream unit operations.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				Category -> "General",
				UnitOperation -> True
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the container of the input samples to be incubated, for use in downstream unit operations.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				Category -> "General",
				UnitOperation -> True
			},
			{
				OptionName -> Incubator,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Instrument, Incubator], Object[Instrument, Incubator]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Storage Devices",
							"Incubators"
							(* Don't show mammalian incubators in catalog for now *)
							(* "Mammalian Cell Culture" *)
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Storage Devices",
							"Incubators",
							"Bacterial Cell Culture"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Storage Devices",
							"Incubators",
							"Yeast Cell Culture"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Storage Devices",
							"Incubators",
							"Custom Cell Culture"
						}
					}
				],
				Description -> "The instrument used to cultivate cell cultures under specified conditions, including, Temperature, CarbonDioxide, RelativeHumidity, ShakingRate, and ShakingRadius.",
				ResolutionDescription -> "If Preparation is set to Robotic, automatically set to Model[Instrument, Incubator, \"STX44-ICBT with Humidity Control\"] for Mammalian cell culture, or set to Model[Instrument, Incubator, \"STX44-ICBT with Shaking\"] for Bacterial and Yeast cell culture. If Preparation is Manual, is automatically set to an incubator that meets the requirements of desired incubation conditions (CellType, Temperature, CarbonDioxide, RelativeHumidity, Shake) and footprint of the container of the input sample. See the helpfile of the function IncubateCellsDevices for more information about operating parameters of all incubators." ,
				Category -> "General"
			},
			{
				OptionName -> Temperature,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					"Temperature" -> Widget[
						Type -> Enumeration,
						Pattern :> CellIncubationTemperatureP (* 30 C, 37 C *)
					],
					"Custom Temperature" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[$MinCellIncubationTemperature, $MaxCellIncubationTemperature], (* 28 Celsius, 80 Celsius *)
						Units -> Celsius
					]
				],
				Description -> "Temperature at which the input cells are incubated. 30 Degrees Celsius and 37 Degrees Celsius are supported by default cell culture incubation conditions. Alternatively, a customized temperature can be requested with a dedicated custom incubator between " <> ToString@$MinCellIncubationTemperature <> " and " <> ToString@$MaxCellIncubationTemperature <> " until the protocol is completed. See the IncubationCondition option for more information.",
				ResolutionDescription -> "Automatically set to match the Temperature field of specified IncubationCondition, see below table. If IncubationCondition is not provided, automatically set to 37 Celsius if CellType is Bacterial or Mammalian, or 30 Celsius if CellType is Yeast.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> Shake,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the input cells are shaken during incubation.",
				ResolutionDescription -> "Automatically set to True if ShakingRate or ShakingRadius are provided, or if IncubationCondition is BacterialShakingIncubation or YeastShakingIncubation. Otherwise, set to False.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> ShakingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"200 RPM" -> Widget[
						Type -> Enumeration,
						Pattern :> CellIncubationShakingRateP(*200 RPM*)
					],
					"Custom Shaking Rate" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[$MinCellIncubationShakingRate, $MaxCellIncubationShakingRate],(*20RPM,1000RPM*)
						Units -> RPM
					]
				],
				Description -> "The frequency at which the sample is agitated by movement in a circular motion. Currently, 200 RPM is supported by preset cell culture incubation conditions with shaking. Alternatively, a customized shaking rate can be requested with a dedicated custom incubator until the protocol is completed. See the IncubationCondition option for more information.",
				ResolutionDescription -> "If Shake is True, automatically set match the ShakingRate value of specified IncubationCondition if it is provided. If IncubationCondition is not provided, automatically set to 200 RPM.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> ShakingRadius,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CellIncubatorShakingRadiusP (*3 Millimeter, 25 Millimeter, 25.4 Millimeter*)
				],
				Description -> "The radius of the circle of orbital motion applied to the sample during incubation. The MultitronPro Incubators for plates has a 25 mm shaking radius, and the Innova Incubators have a 25.4 Millimeter shaking radius. See the Instrumentation section of the helpfile for more information.",
				ResolutionDescription -> "If Shake is True, automatically set to match the ShakingRadius value of specified IncubationCondition if it is provided, or set to the shaking radius of incubator.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> IncubationCondition,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					"Incubation Type" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[
							MammalianIncubation,
							BacterialIncubation,
							BacterialShakingIncubation,
							YeastIncubation,
							YeastShakingIncubation,
							Custom
						]
					],
					"Incubation Model" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[StorageCondition]],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Storage Conditions",
								"Incubation",
								"Cell Culture"
							}
						}
					]
				],
				Description -> "The type of incubation that defines the Temperature, Carbon Dioxide Percentage, Relative Humidity, Shaking Rate and Shaking Radius, under which the input cells are incubated. Custom incubation actively selects an incubator in the lab and uses a thread to incubate only the cells from this protocol for the specified Time. Selecting an IncubationCondition, through a symbol or an object, will passively store the cells for the specified time in a shared incubator, potentially with samples from other protocols. However, it will not consume a thread while the cells are inside the incubator. Currently, MammalianIncubation, BacterialIncubation, BacterialShakingIncubation, YeastIncubation, and YeastShakingIncubation are supported cell culture incubation conditions with shared incubators.",
				ResolutionDescription -> "Automatically set to a storage condition matching specified CellType, CultureAdhesion, Temperature, CarbonDioxide, RelativeHumidity, ShakingRate and ShakingRadius options, or set to Custom if no existing storage conditions can provide specified incubation condition options. If no Temperature, RelativeHumidity, CarbonDioxide, ShakingRate, or ShakingRadius are provided, automatically set based on the CellType and CultureAdhesion as described in the below table.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> CellType,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Bacterial, Mammalian, Yeast]
				],
				Description -> "The type of the most abundant cells that are thought to be present in this sample.",
				ResolutionDescription -> "Automatically set to match the value of CellType of the input sample if it is populated, or set to Mammalian if CultureAdhesion is Adherent or if WorkCell is bioSTAR. If there are multiple cell types in the input sample or if the cell type is unknown, automatically set to Null.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> CultureAdhesion,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CultureAdhesionP(*Adherent | Suspension | SolidMedia*)
				],
				Description -> "The manner of cell growth the cells in the sample are thought to employ (i.e., SolidMedia, Suspension, and Adherent). SolidMedia cells grow in colonies on a nutrient rich substrate, suspended cells grow free floating in liquid media, and adherent cells grow attached to a substrate.",
				ResolutionDescription -> "Automatically set to match the CultureAdhesion value of the input sample if it is populated. Otherwise set to Suspension.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> RelativeHumidity,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					"Ambient" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					],
					"93 Percent" -> Widget[
						Type -> Enumeration,
						Pattern :> CellIncubationRelativeHumidityP (* 93 Percent *)
					],
					"Custom" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					]
				],
				Description -> "Percent humidity at which the input cells are incubated. Currently, 93% Relative Humidity is supported by default cell culture incubation conditions. Alternatively, a customized relative humidity can be requested with a dedicated custom incubator until the protocol is completed. See the IncubationCondition option for more information.",
				ResolutionDescription -> "Automatically set to match the RelativeHumidity field of specified IncubationCondition, see below table. If IncubationCondition is not provided, automatically set to 93% if CellType is Mammalian, or Ambient if CellType is Bacterial or Yeast.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> CarbonDioxide,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					"Ambient" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					],
					"5 Percent" -> Widget[
						Type -> Enumeration,
						Pattern :> CellIncubationCarbonDioxideP (* 5 Percent *)
					],
					"Custom" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, $MaxCellIncubationCarbonDioxide],(*20 Percent*)
						Units -> Percent
					]
				],
				Description -> "Percent CO2 at which the input cells are incubated. Currently, 5% Carbon Dioxide is supported by default cell culture incubation conditions. Alternatively, a customized carbon dioxide percentage can be requested with a dedicated custom incubator until the protocol is completed. See the IncubationCondition option for more information.",
				ResolutionDescription -> "Automatically set to match the CarbonDioxide field of specified IncubationCondition, see below table. If IncubationCondition is not provided, automatically set to 5% if CellType is Mammalian, or Ambient if CellType is Bacterial or Yeast.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> SamplesOutStorageCondition,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> IncubatedCellSampleStorageTypeP|Disposal
				],
				Description -> "The conditions under which samples will be stored after the protocol is completed.",
				ResolutionDescription -> "If IncubationCondition is Custom, automatically set based on the CellType and CultureAdhesion of the cells. If CellType and CultureAdhesion are unknown, automatically set to BacterialIncubation if the container is a shallow plate, or BacterialShakingIncubation otherwise. If IncubationCondition is not Custom, automatically set to the IncubationCondition.",
				Category -> "Post Experiment"
			},

			(* Index-Matching Quantification Options *)

			(* Quantification Target and Time Options *)
			{
				OptionName -> MinQuantificationTarget,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Cell/Milliliter" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 (EmeraldCell/Milliliter), 10^(12) (EmeraldCell/Milliliter)],
						Units -> (EmeraldCell/Milliliter)
					],
					"OD600" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 OD600, 100 OD600],
						Units -> OD600
					],
					"CFU/Milliliter" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 (CFU/Milliliter), 10^(12) (CFU/Milliliter)],
						Units -> (CFU/Milliliter)
					],
					"Colony" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Colony, 10^(12) Colony],
						Units -> Colony
					],
					"None" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[None]
					]
				],
				Description -> "If IncubationStrategy is QuantificationTarget, the minimum concentration of cells in the sample which must be detected by the QuantificationMethod before incubation is ceased and the protocol proceeds to the next step. Note that if this value is provided with units of Cell/Milliter or OD600, that unit will be used as the QuantificationUnit for ExperimentQuantifyCells. If None is specified, quantification will occur at at every QuantificationInterval until the Time has elapsed to generate a growth curve, and ExperimentQuantifyCells will resolve the QuantificationUnit automatically.",
				ResolutionDescription -> "If IncubationStrategy is QuantificationTarget, automatically set to None.",
				Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "Quantification"]
			},
			{
				OptionName -> QuantificationTolerance,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Cell/Milliliter" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 (EmeraldCell/Milliliter), 10^(12) (EmeraldCell/Milliliter)],
						Units -> (EmeraldCell/Milliliter)
					],
					"OD600" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 OD600, 100 OD600],
						Units -> OD600
					],
					"CFU/Milliliter" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 (CFU/Milliliter), 10^(12) (CFU/Milliliter)],
						Units -> CFU/Milliliter
					],
					"Colony" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Colony, 10^(12) Colony],
						Units -> Colony
					],
					"Percent" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent, 1 Percent],
						Units -> Percent
					]
				],
				Description -> "The margin of error applied to the MinQualificationTarget such that, if the detected cell concentration exceeds the MinQuantificationTarget minus this value, the quantified concentration is considered to have met the target.",
				ResolutionDescription -> "If MinQuantificationTarget is not Null or None, automatically set to 10 Percent.",
				Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "Quantification"]
			},
			(* Aliquot Options for Quantification *)
			{
				OptionName -> QuantificationAliquotVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Microliter],
					Units -> {Microliter, {Microliter, Milliliter}}
				],
				Description -> "The volume of sample transferred to the QuantificationAliquotContainer to assess the concentration of cells using the QuantificationMethod.",
				ResolutionDescription -> "If QuantificationAliquot is True, automatically set to the RecommendedFillVolume (or MaxVolume if the RecommendedFillVolume is not known) of the AliquotContainer.",
				Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "Quantification"]
			},
			{
				OptionName -> QuantificationAliquotContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Container]]
				],
				Description -> "The container into which a portion of the cell sample is transferred in order to assess the concentration of cells in the sample.",
				ResolutionDescription -> "If QuantificationAliquot is True, automatically set to a container compatible with the QuantificationInstrument.",
				Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "Quantification"]
			},
			{
				OptionName -> QuantificationBlank,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}]
				],
				Description -> "The sample on which the blank measurement is recorded in order to subtract background noise from the quantification measurement.",
				ResolutionDescription -> "If QuantificationBlankMeasurement is True, automatically set to a solution with identical composition to the media in which the cell sample is being incubated.",
				Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "Quantification"]
			},
			{
				OptionName -> QuantificationWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[200 Nanometer, 1000 Nanometer, 1 Nanometer],
					Units -> Nanometer
				],
				Description -> "The wavelength at which the quantification measurement is recorded.",
				ResolutionDescription -> "If QuantificationMethod is Absorbance or Nephelometry, automatically set to 600 Nanometer.",
				Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "Quantification"]
			},
			{
				OptionName -> QuantificationStandardCurve,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Analysis, StandardCurve]]
				],
				Description -> "An empirically derived function used to convert the results of quantification measurements to a cell concentration, which is then compared to the MinQuantificationTarget.",
				ResolutionDescription -> "If QuantificationMethod is Absorbance or Nephelometry and an existing Object[Analysis, StandardCurve] is compatible with the instrument, sample, and unit conversion required for the experiment, automatically set to the appropriate Object[Analysis, StandardCurve].",
				Category -> If[TrueQ[$IncubateCellsIncubateOnly], "Hidden", "Quantification"]
			}
		],
		(* Shared Options *)
		ProtocolOptions,
		PreparationOption,
		BiologyWorkCellOption,
		SimulationOption
	}
];

(* Use of the liquid handler-integrated incubator occupies the entire liquid handler for the duration of incubation. To limit this, *)
(* the max duration of cell culture when Preparation -> Robotic is stored as $MaxRoboticIncubationTime and can be found in Constants.m  *)

(* Patterns specific to ExperimentIncubateCells *)
(* This is to accommodate the slightly awkward placement of a tube rack inside the plate incubator *)
plateIncubatorFootprintsP = Alternatives[Plate, Conical15mLTube];

(* ::Subsection::Closed:: *)
(*ExperimentIncubateCells *)

(* ::Subsection:: *)
(* Container and Prepared Samples Overload *)
ExperimentIncubateCells[myInputs: ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions: OptionsPattern[]] := Module[
	{
		listedContainers, listedOptions, outputSpecification, output, gatherTests, containerToSampleResult, containerToSampleOutput,
		samples, sampleOptions, containerToSampleTests, containerToSampleSimulation, mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples, updatedSimulation, validSamplePreparationResult
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Remove temporal links and named objects. *)
	{listedContainers, listedOptions} = {ToList[myInputs], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentIncubateCells,
			listedContainers,
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

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentIncubateCells,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result, Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentIncubateCells,
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
		ExperimentIncubateCells[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];


(*---Main function accepting sample objects as inputs---*)
ExperimentIncubateCells[mySamples: ListableP[ObjectP[Object[Sample]]], myOptions: OptionsPattern[]] := Module[
	{
		listedSamples, listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult, safeOps,
		safeOpsTests, validLengths, validLengthTests, uploadProtocolOptions, performSimulationQ, templatedOptions,
		templateTests, inheritedOptions, expandedSafeOps, cacheBall, resolvedOptionsResult, quantificationPacket, simulatedProtocol, simulationAfterResourcePackets,
		resolvedOptions, quantificationProtocolPacket, resolvedOptionsTests, resolvedOptionsSimulation, collapsedResolvedOptions, resourcePacketTests, incubators,
		incubationStorageConditions, sampleFields, modelSampleFields, objectContainerFields, modelContainerFields, incubatorRacks, specifiedQuantificationInstrument,
		incubatorDecks, incubatorInstrumentFields, incubatorRackFields, incubatorDeckFields, result, rootProtocol, uploadOverlockPacketQ, overclockPacket,
		samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, updatedSimulation, safeOptionsNamed, samplesWithPreparedSamples,
		optionsWithPreparedSamples, upload, confirm, canaryBranch, fastTrack, parentProtocol, cache, downloadedStuff, roboticQ, optionsResolverOnly, resourcePacketResult,
		returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ, protocolPacketWithResources, unitOperationPackets, roboticSimulation, failureResponseSimulation, roboticRunTime,
		totalTimesEstimate, incubateCellsSimulation, incubateCellsSimulationWithFailureResponse, resolvedOptionsFromQuantification
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
			ExperimentIncubateCells,
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
		SafeOptions[ExperimentIncubateCells, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentIncubateCells, listedOptions, AutoCorrect -> False], {}}
	];

	(* Replace all objects referenced by Name to ID *)
	{samplesWithPreparedSamples, safeOps, optionsWithPreparedSamples} = sanitizeInputs[samplesWithPreparedSamplesNamed, safeOptionsNamed, optionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null,
			RunTime -> 0 Minute
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentIncubateCells, {listedSamples}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentIncubateCells, {listedSamples}, listedOptions], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null,
			RunTime -> 0 Minute
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentIncubateCells, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentIncubateCells, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null,
			RunTime -> 0 Minute
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentIncubateCells, {ToList[listedSamples]}, inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* Get the incubators in the lab that are not deprecated. *)
	incubators = Flatten[{
		nonDeprecatedIncubatorsSearch["Memoization"],
		Cases[KeyDrop[ToList[myOptions],{Cache,Simulation}], ObjectReferenceP[{Object[Instrument, Incubator], Model[Instrument, Incubator]}], Infinity]
	}];

	(*Get all the possible incubator racks and decks that are not deprecated*)
	incubatorRacks = allIncubatorRacksSearch["Memoization"];
	incubatorDecks = allIncubatorDecksSearch["Memoization"];

	(* get all the incubation storage conditions *)
	incubationStorageConditions = allIncubationStorageConditions["Memoization"];

	(*Instrument, rack, and deck fields*)
	(* TODO possibly just kill this one too because I don't see why we'd need this in more than one place (maybe need it in IncubateCellsDevices) *)
	incubatorInstrumentFields = cellIncubatorInstrumentDownloadFields[];
	incubatorRackFields = cellIncubatorRackDownloadFields[];
	incubatorDeckFields = cellIncubatorDeckDownloadFields[];

	(* Sample Fields. *)
	sampleFields = SamplePreparationCacheFields[Object[Sample], Format -> Packet];
	modelSampleFields = SamplePreparationCacheFields[Model[Sample]];
	objectContainerFields = SamplePreparationCacheFields[Object[Container]];
	modelContainerFields = SamplePreparationCacheFields[Model[Container]];

	(* Get the QuantificationInstrument if the user specified it. We use this in the resolver to check plate compatibility for plate readers. *)
	specifiedQuantificationInstrument = If[MatchQ[Lookup[expandedSafeOps, QuantificationInstrument], Automatic|Null],
		{},
		Lookup[expandedSafeOps, QuantificationInstrument]
	];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	downloadedStuff = Check[
		Quiet[
			Download[
				{
					(* Download {CellTypes,ShakingRadius,Positions,MinTemperature,MaxTemperature,MinCO2,MaxCO2,MinHumidity,MaxHumidity} from our incubators. *)
					ToList[listedSamples],
					incubators,
					incubatorRacks,
					incubatorDecks,
					incubationStorageConditions,
					ToList[specifiedQuantificationInstrument],
					{parentProtocol} /. {Null -> Nothing}
				},
				{
					{
						sampleFields,
						Packet[Model[modelSampleFields]],
						Packet[Container[objectContainerFields]],
						Packet[Container[Model][modelContainerFields]],
						(* Downloads about composition components standard curves need to mirror ExperimentQuantifyCells *)
						Packet[Composition[[All, 2]][{CellType, CultureAdhesion, DoublingTime, StandardCurves, StandardCurveProtocols, Molecule, ExtinctionCoefficients, PolymerType, MolecularWeight, IncubationTemperature, Density}]],
						Packet[Composition[[All, 2]][StandardCurves][{DateCreated, InversePrediction, BestFitFunction, Protocol, StandardDataUnits}]],
						Packet[Composition[[All, 2]][StandardCurves][Protocol][Instrument, Wavelengths]],
						Packet[Composition[[All, 2]][StandardCurves][Protocol][Instrument][{Model, Status, WettedMaterials, PlateReaderMode, SamplingPatterns, IntegratedLiquidHandler}]],
						Packet[Composition[[All, 2]][StandardCurves][Protocol][Instrument][Model][{WettedMaterials, PlateReaderMode, SamplingPatterns, IntegratedLiquidHandlers}]]
					},
					{Evaluate[Packet[Sequence @@ incubatorInstrumentFields]]},
					{Evaluate[Packet[Sequence @@ incubatorRackFields]]},
					{Evaluate[Packet[Sequence @@ incubatorDeckFields]]},
					{Packet[StorageCondition, CellType, CultureHandling, Temperature, Humidity, Temperature, CarbonDioxide, ShakingRate, VesselShakingRate, PlateShakingRate, ShakingRadius]},
					{Packet[Manufacturer]},
					{Packet[RootProtocol]}
				},
				Cache -> cache,
				Simulation -> updatedSimulation,
				Date -> Now
			],
			{Download::FieldDoesntExist}
		],
		$Failed,
		{Download::ObjectDoesNotExist}
	];

	(* Get the RootProtocol *)
	rootProtocol = Lookup[Flatten[downloadedStuff[[-1]]], RootProtocol, {Null}][[1]];

	(* Return early if objects do not exist *)
	If[MatchQ[downloadedStuff, $Failed],
		Return[$Failed]
	];
	cacheBall = FlattenCachePackets[{cache, Cases[Flatten[downloadedStuff], PacketP[]]}];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ = MemberQ[output, Result|Simulation];

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		(
			{{resolvedOptions, quantificationProtocolPacket}, resolvedOptionsTests, resolvedOptionsSimulation} = If[performSimulationQ,
				resolveExperimentIncubateCellsOptions[
					samplesWithPreparedSamples,
					expandedSafeOps,
					Cache -> cacheBall,
					Simulation -> updatedSimulation,
					Output -> {Result, Tests, Simulation}
				],
				Module[{options, quantPacket, tests},
					{{options, quantPacket}, tests} = resolveExperimentIncubateCellsOptions[
						samplesWithPreparedSamples,
						expandedSafeOps,
						Cache -> cacheBall,
						Simulation -> updatedSimulation,
						Output -> {Result, Tests}
					];
					{{options, quantPacket}, tests, updatedSimulation}
				]
			];
			(* Therefore, we have to run the tests to see if we encountered a failure. *)
			If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
				{resolvedOptions, resolvedOptionsTests},
				$Failed
			]
		),

		(* We are not gathering tests. Simply check for Error::InvalidInput, Error::InvalidOption, and Error::ConflictingUnitOperationMethodRequirements *)
		Check[
			(
				resolvedOptionsTests = {};
				{{resolvedOptions, quantificationProtocolPacket}, resolvedOptionsSimulation} = If[performSimulationQ,
					resolveExperimentIncubateCellsOptions[
						samplesWithPreparedSamples,
						expandedSafeOps,
						Cache -> cacheBall,
						Simulation -> updatedSimulation,
						Output -> {Result, Simulation}
					],
					{
						resolveExperimentIncubateCellsOptions[
							samplesWithPreparedSamples,
							expandedSafeOps,
							Cache -> cacheBall,
							Simulation -> updatedSimulation
						],
						updatedSimulation
					}
				]
			),
			$Failed,
			{Error::InvalidInput, Error::InvalidOption, Error::ConflictingUnitOperationMethodRequirements}
		]
	];

	(* Isolate the quantification packet and make sure it matches the input pattern of the simulation function. *)
	quantificationPacket = ToList[quantificationProtocolPacket /. {{} -> Null}][[1]];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentIncubateCells,
		resolvedOptions,
		Ignore -> listedOptions,
		Messages -> False
	];

	(* Lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

	(* Run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	(* for now, just returning early always *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
			Options -> RemoveHiddenOptions[ExperimentIncubateCells, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> updatedSimulation
		}]
	];

	(* Lookup our resolved Preparation option and set a flag. *)
	roboticQ = MatchQ[Lookup[resolvedOptions, Preparation], Robotic];

	(* If we are aliquoting for quantification, we minimize the time that the cells spend outside the incubator by splitting *)
	(* the quantification subprotocol into a Transfer sub and an Abs/Neph sub without aliquoting, and we return the cells to *)
	(* their incubator(s) after the transfer. To do this we pass any resolved quantification options into the resource packets *)
	resolvedOptionsFromQuantification = If[MatchQ[quantificationPacket, PacketP[]],
		Lookup[quantificationPacket, ResolvedOptions],
		{}
	];

	(* Build packets with resources. Also return any simulation from the failure response. *)
	{
		resourcePacketResult,
		resourcePacketTests
	} = If[returnEarlyBecauseOptionsResolverOnly || returnEarlyBecauseFailuresQ,
		{ConstantArray[$Failed, 5], {}},
		Block[{$IncubateCellsQuantificationOptions = resolvedOptionsFromQuantification},
			If[gatherTests,
				incubateCellsResourcePackets[
					samplesWithPreparedSamples,
					templatedOptions,
					resolvedOptions,
					collapsedResolvedOptions,
					Cache -> cacheBall,
					Simulation -> updatedSimulation,
					Output -> {Result, Tests}
				],
				{
					incubateCellsResourcePackets[
						samplesWithPreparedSamples,
						templatedOptions,
						resolvedOptions,
						collapsedResolvedOptions,
						Cache -> cacheBall,
						Simulation -> updatedSimulation
					],
					{}
				}
			]
		]
	];
	(* If we did get the results with 5 variables we wanted, assign to each resource packet result, otherwise assign each a $Fail to avoid weird error *)
	{protocolPacketWithResources, unitOperationPackets, roboticSimulation, failureResponseSimulation, roboticRunTime} = If[Length[resourcePacketResult] == 5,
		resourcePacketResult,
		ConstantArray[$Failed, 5]
	];

	(* Determine which simulation to pass around following the resource packets. *)
	simulationAfterResourcePackets = If[roboticQ, roboticSimulation, resolvedOptionsSimulation];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, incubateCellsSimulation} = Which[
		(* If resource packets failed, do not attempt the simulation. *)
		MatchQ[protocolPacketWithResources, $Failed], {$Failed, updatedSimulation},
		(* We don't need to do this if we are robotic since RCP handles the simulation in that case. *)
		roboticQ && MatchQ[roboticSimulation, SimulationP], {Null, roboticSimulation},
		(* For manual, call the simulation function. *)
		performSimulationQ,
			simulateExperimentIncubateCells[
				protocolPacketWithResources,
				unitOperationPackets,
				quantificationPacket,
				ToList[samplesWithPreparedSamples],
				resolvedOptions,
				Cache -> cacheBall,
				Simulation -> simulationAfterResourcePackets
			],
		(* Failsafe evaluation *)
		True, {Null, simulationAfterResourcePackets}
	];

	(* Update the simulation with the failure response simulation. *)
	(* Note that there is nothing new here unless the FailureResponse is Freeze. *)
	incubateCellsSimulationWithFailureResponse = If[MatchQ[failureResponseSimulation, SimulationP],
		UpdateSimulation[simulationAfterResourcePackets, failureResponseSimulation],
		simulationAfterResourcePackets
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> If[roboticQ,
				resolvedOptions,
				RemoveHiddenOptions[ExperimentIncubateCells, collapsedResolvedOptions]
			],
			Preview -> Null,
			Simulation -> incubateCellsSimulationWithFailureResponse
		}]
	];

	(* IncubateCells protocols need Overclock -> True in order to ensure that even if the queue is full, we can handle the cells in a timely fashion *)
	(* Only need to bother if we're doing Manual or if we haven't failed in the resource packets *)
	uploadOverlockPacketQ = And[
		!roboticQ,
		!MatchQ[protocolPacketWithResources, $Failed],
		MatchQ[rootProtocol, ObjectP[]]
	];

	(* only add an overclocking packet for the root protocol if we are a subprotocol here *)
	(* doing this because UploadProtocol behaves oddly when you are uploading a packet and also have a different packet for the same object in the accessory packets overload *)
	(* thus, if this IncubateCells is the root protocol, we will have already populated that field in the resource packets function *)
	overclockPacket = If[uploadOverlockPacketQ,
		<|Object -> Download[rootProtocol, Object], Overclock -> True|>,
		Nothing
	];

	(* Estimate the time according to the method, adding in some buffer for resource picking, quantifications, etc. *)
	totalTimesEstimate = If[roboticQ,
		1.5 * roboticRunTime,
		1.5 * Lookup[resolvedOptions, Time]
	];

	(* Put the UploadProtocol options together so we don't have to type them out multiple times*)
	(* making it a sequence because UploadProtocol misbehaves with lists sometimes *)
	uploadProtocolOptions = Sequence[
		Upload -> Lookup[safeOps, Upload],
		Confirm -> Lookup[safeOps, Confirm],
		CanaryBranch -> Lookup[safeOps, CanaryBranch],
		ParentProtocol -> Lookup[safeOps, ParentProtocol],
		Priority -> Lookup[safeOps, Priority],
		StartDate -> Lookup[safeOps, StartDate],
		HoldOrder -> Lookup[safeOps, HoldOrder],
		QueuePosition -> Lookup[safeOps, QueuePosition],
		ConstellationMessage -> {Object[Protocol, IncubateCells]},
		Cache -> cacheBall,
		Simulation -> incubateCellsSimulationWithFailureResponse
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	result = Quiet[
		Which[
			(* If our resource packets failed, we can't upload anything. *)
			MatchQ[protocolPacketWithResources, $Failed],
			$Failed,

			(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
			(* Upload->False. *)
			roboticQ && MatchQ[Lookup[safeOps, Upload], False],
			unitOperationPackets,

			(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticCellPreparation with our primitive. *)
			roboticQ,
			Module[{primitive, nonHiddenOptions},
				(* Create our IncubateCells primitive to feed into ExperimentRoboticCellPreparation. *)
				primitive = IncubateCells @@ Join[
					{
						Sample -> mySamples
					},
					RemoveHiddenPrimitiveOptions[IncubateCells, ToList[myOptions]]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions = RemoveHiddenOptions[ExperimentIncubateCells, resolvedOptions];

				(* Memoize the value of ExperimentIncubateCells so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentIncubateCells, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache = <||>;

					DownValues[ExperimentIncubateCells] = {};

					ExperimentIncubateCells[___, options : OptionsPattern[]] := Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification = Lookup[ToList[options], Output];

						frameworkOutputSpecification /. {
							Result -> unitOperationPackets,
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> incubateCellsSimulationWithFailureResponse,
							RunTime -> totalTimesEstimate
						}
					];
					Module[{resolvedWorkCell},
						(* Look up which workcell we've chosen *)
						resolvedWorkCell = Lookup[resolvedOptions, WorkCell];

						(* Run the experiment *)
						ExperimentRoboticCellPreparation[
							{primitive},
							{
								Name -> Lookup[nonHiddenOptions, Name],
								Upload -> Lookup[safeOps, Upload],
								Confirm -> Lookup[safeOps, Confirm],
								CanaryBranch -> Lookup[safeOps, CanaryBranch],
								ParentProtocol -> Lookup[safeOps, ParentProtocol],
								Priority -> Lookup[safeOps, Priority],
								StartDate -> Lookup[safeOps, StartDate],
								HoldOrder -> Lookup[safeOps, HoldOrder],
								QueuePosition -> Lookup[safeOps, QueuePosition],
								Cache -> cacheBall
							}
						]
					]
				]
			],

			(* Actually upload our protocol object.  This is only for Manual. *)
			(* Note that since we only make batched unit operations sometimes and UploadProtocol can't take {} as the second argument, need to do this two different times *)
			MatchQ[unitOperationPackets, {}] && Not[MatchQ[overclockPacket, PacketP[]]],
			UploadProtocol[
				protocolPacketWithResources,
				uploadProtocolOptions
			],
			True,
			UploadProtocol[
				protocolPacketWithResources,
				Flatten[{unitOperationPackets, overclockPacket}],
				uploadProtocolOptions
			]
		],
		{Download::MissingCacheField}
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> result,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> If[roboticQ,
			collapsedResolvedOptions,
			RemoveHiddenOptions[ExperimentIncubateCells, collapsedResolvedOptions]
		],
		Preview -> Null,
		Simulation -> incubateCellsSimulationWithFailureResponse,
		RunTime -> totalTimesEstimate
	}
];


(* ::Subsubsection::Closed:: *)
(*Errors and warnings *)

Error::InvalidPlateSamples = "Sample(s) `1` are found in the same container as input sample(s) `2` but they are not specified as input samples. Since a plate is stored inside of the cell incubator as a whole during cell culture, please transfer sample(s) into an empty container beforehand.";
Error::UnsealedCellCultureVessels = "The sample(s) `1` at indices `2` are in a container `3` without any cover. Please cover `3` with suitable lid or cap beforehand.";
Error::UnsupportedCellTypes = "The CellType option of sample `1` at indices `2` is set to `3`. Currently, only Mammalian, Bacterial and Yeast cell culture are supported. Please contact us if you have a sample that falls outside our current support.";
Error::ConflictingIncubationWorkCells = "The following requirements can only be performed on a bioSTAR: `1`. However, the following requirements can only be performed on a microbioSTAR: `2`. Please resolve this conflict in order to submit a valid IncubateCells protocol or unit operation.";
Error::ConflictingWorkCellWithPreparation = "WorkCell option is set at `1` and Preparation option is set at `2`. If Preparation is Manual, WorkCell must be Null; if Preparation is Robotic, WorkCell must be populated. Please correct the values.";
Warning::CellTypeNotSpecified = "The sample(s) `1` have no CellType specified in the options or Object. For these sample(s), the CellType is defaulting to Bacterial. If this is not desired, please specify a CellType.";
Warning::CultureAdhesionNotSpecified = "The sample(s) `1` at indices `2` have no CultureAdhesion specified in the options or Object. For these sample(s), the CultureAdhesion is defaulting to `3`. If this is not desired, please specify a CultureAdhesion.";
Warning::CustomIncubationConditionNotSpecified = "For sample(s) `1` at indices `2` have IncubationCondition specified as Custom and option(s) `3` are defaulting to `4`. If this is not desired, please specify value for `3`.";
Error::InvalidIncubationConditions = "The sample(s) `1` at indices `2` have an IncubationCondition  specified as `3`. Currently, the supported default incubation conditions are MammalianIncubation, BacterialIncubation, BacterialShakingIncubation, YeastIncubation, and YeastShakingIncubation. If you have a desired IncubationCondition that falls outside our current default incubation conditions, please choose Custom and specify Temperature, CarbonDioxide, RelativeHumidity, ShakingRate and ShakingRadius options.";
Error::TooManyCustomIncubationConditions = "The sample(s) `1` have been specified to use different custom incubator(s) `2`, but only one custom incubator can be used per protocol (currently `3`). For these sample(s), either utilize default incubation conditions to use shared incubator devices, or split the experiment call into separate protocols.";
Error::ConflictingCellType = "The sample(s) `1` at indices `2` have a CellType specified in the option as `3` and CellType of the Object as `4`. For these sample(s), please specify the same CellType as the Object or let the option be set automatically.";
Error::ConflictingCultureAdhesion = "The sample(s) `1` at indices `2` have a CultureAdhesion specified in the option as `3` that does not match the current CultureAdhesion of the sample Object(s) `4`. For these sample(s), please specify the same CultureAdhesion as the Object or let the option be set automatically.";
Error::ConflictingShakingConditions = "The sample(s) `1` at indices `2` are specified with conflicting options for Shake (`3`), ShakingRate (`4`), and ShakingRadius (`5`). When Shake is True, ShakingRate and ShakingRadius must be populated. When Shake is False, ShakingRate and ShakingRadius should be Null. For these sample(s), please change these options to a valid combination or let them be set automatically.";
Error::UnsupportedCellCultureType = "The sample(s) `1` at indices `2` require Mammalian Suspension Cell Culture. Currently only Mammalian Adherent Cell Culture is supported. Please contact us if you have a sample that falls outside our current support.";
Error::ConflictingCellTypeWithCultureAdhesion = "The sample(s) `1` at indices `2` have a CultureAdhesion specified in the option as `3` and CellType specified in the option as `4`. When CellType is Mammalian, CultureAdhesion cannot be SolidMedia. When CellType is Bacterial or Yeast, CultureAdhesion cannot be Adherent. For these sample(s), please change these options to specify a valid protocol.";
Error::ConflictingCellTypeWithIncubator = "The sample(s) `1` at indices `2` have a CellType specified or automatically set in the option as `3` and Incubator specified as `4`. Incubator(s) `4` are only compatible with CellTypes `5`. Please change these options to specify a valid protocol.";
Error::ConflictingCultureAdhesionWithContainer = "The sample(s) `1` at indices `2` have a CultureAdhesion specified in the option as `3`. When samples are in plates, CultureAdhesion should be Adherent for liquid media and SolidMedia for solid media. For these sample(s), please specify the same CultureAdhesion as the Object or let the option be set automatically.";
Error::ConflictingIncubationConditionsForSameContainer = "The sample(s) `1` have different incubation settings `2`, but are in the same container as another sample. For these sample(s), either transfer to different containers, allow the conflicting incubation options to be set automatically, or specify the same incubation conditions for each sample in the same container.";
Error::ConflictingCellTypeWithStorageCondition = "The sample(s) `1` at indices `2` have a CellType specified in the option as `3` and SamplesOutStorageCondition specified in the option as `4`. `4` is not compatible with `3`. For these sample(s), please change these options to specify a valid protocol.";
Warning::ConflictingCultureAdhesionWithStorageCondition = "The sample(s) `1` at indices `2` have a CultureAdhesion specified in the option as `3` and SamplesOutStorageCondition specified in the option as `4`. `4` is not compatible with `3`. For these sample(s), please change these options to specify a valid protocol.";
Error::IncubationMaxTemperature = "The sample(s) `1` at indices `2` are in container(s) `3`, which have MaxTemperature(s) of, `4`. For these sample(s), Temperature cannot be set above the MaxTemperature of the given container(s). Please change these options to specify a valid protocol.";
Error::NoCompatibleIncubator = "The sample(s) `1` at indices `2` have no cell incubator instruments that are compatible with the footprint of the sample container and the option(s) specified (including specified incubator(s)).  To see the instruments that are compatible with this sample, use the function IncubateCellsDevices.";
Error::IncubatorIsIncompatible = "The sample(s) `1` at indices `2` have cell incubator specified as, `3`. However,  this sample can only be incubated in the following cell incubator models, `4`. Please use the function IncubateCellsDevices to select a compatible cell incubator, or allow Incubator to be set automatically.";
Error::InvalidPropertySamples = "The following sample(s) `1` have invalid sample state or amount. The states are `2`, the volumes are `3`, and the mass are `4`. Only solid and liquid samples with non-zero amount can be used.";
Error::TooManyIncubationSamples = "The following incubator(s) `1` have enough space for `2` `3`, but `4` were specified instead.  Please split the experiment call into multiple in order to not exceed the capacity of the incubators.";
Error::ConflictingIncubationStrategy = "The sample(s) `1` at indices `5` have the IncubationStrategy option set to `3`, but the `2` option is set to `4`. Please ensure that quantification options are specified if and only if IncubationStrategy is QuantificationTarget.";
Error::ConflictingQuantificationOptions = "The sample(s) `1` at indices `6` have the `2` option(s) set to `3`, but the `4` option(s) are set to `5`. Please ensure that all quantification options are compatible or allow them to resolve automatically in order to submit a valid experiment.";
Error::FailureResponseNotSupported = "The specified FailureResponse is incompatible with one or more of the input samples for the following reason: `1`";
Error::UnsuitableQuantificationInterval = "The QuantificationInterval option is set to `1` and the Time option is set to `2` for the experiment. When the IncubationStrategy is QuantificationTarget, please specify a QuantificationInterval less than or equal to the Time but no less than 1 Hour in order to submit a valid experiment.";
Error::ConflictingQuantificationMethodAndInstrument = "The QuantificationInstrument `2` is not capable of the QuantificationMethod `1`. Please ensure that the QuantificationInstrument and QuantificationMethod are compatible in order to submit a valid experiment.";
Error::ExcessiveQuantificationAliquotVolumeRequired = "The sample(s) `1` at indices `7` have the QuantificationAliquotVolume option set to `2` and the QuantificationRecoupSample option is set to False. Since the QuantificationInterval is `3` and the Time is `4`, it is possible that up to `5` will be removed from the sample(s) for quantification, exceeding the available sample volume of `6`. Please either set QuantificationRecoupSample to True (which increases the chance of contamination) or adjust these options to reduce the maximum volume of sample(s) to be aliquoted in order to submit a valid experiment.";
Error::QuantificationTargetUnitsMismatch = "The sample(s) `1` at indices `4` have the MinQuantificationTarget option specified as `2` and the QuantificationTolerance specified as `3`. Please ensure that the QuantificationTolerance, if specified, is given in the same units as the MinQuantificationTarget or as a Percent of the MinQuantificationTarget.";
Error::ExtraneousQuantifyColoniesOptions = "The sample(s) `1` at indices `4` have the `2` option(s) set to `3` while the QuantificationMethod is ColonyCount. ExperimentQuantifyColonies does not require a wavelength, standard curve, or blank measurement, and it does not currently support aliquoting. Please set all of these options to Null or allow them to resolve automatically in order to submit a valid experiment.";
Error::ConflictingQuantificationAliquotOptions = "The sample(s) `1` at indices `5` have the `2` option(s) set to `3` while QuantificationAliquot is `4`. Please ensure that the options QuantificationAliquotVolume, QuantificationAliquotContainer are specified for each sample if and only if QuantificationAliquot is True.";
Error::MixedQuantificationAliquotRequirements = "Due to procedural timing constraints in ExperimentIncubateCells, aliquoting for quantification must either occur for ALL samples or for NONE of the samples. However, the QuantificationAliquot option was not specified for this protocol, and the samples `1` at indices `3` have the following aliquot requirements: `2`, where True indicates that aliquoting is necessary either due to either a) the specification of one or more of the options QuantificationAliquotVolume, QuantificationAliquotContainer, or QuantificationRecoupSample, or b) an incompatibility between the sample's container and the QuantificationInstrument. Please either adjust the conditions of the experiment such that aliquoting is not needed for any sample or explicitly set QuantificationAliquot to True in order to submit a valid experiment.";
Error::AliquotRecoupMismatch = "The QuantificationRecoupSample option is set to True while QuantificationAliquot is False. Please either set QuantificationRecoupSample to False or QuantificationAliquot to True in order to submit a valid experiment.";
Warning::DiscardUponFailure = "The FailureResponse option will default to Discard when it is left unspecified and the IncubationStrategy is QuantificationTarget. Please specify Incubate or Freeze for this option if you do not intend for the samples to be discarded in the event that the MinQuantificationTarget is not obtained during this experiment.";
Warning::NoQuantificationTarget = "The sample(s) `1` at indices `2` have the MinQuantificationTarget option unspecified while the IncubationStrategy is QuantificationTarget. The MinQuantificationTarget will default to None. Quantification will occur at each QuantificationInterval until the Time has elapsed, generating a growth curve.";
Warning::GeneralFailureResponse = "The FailureResponse option is set to `1` with `2` input samples. Please note that, in the current version of ExperimentIncubateCells, the FailureResponse will be executed for ALL samples in a protocol if any of the samples fail to meet their respective MinQuantificationTargets. Consider running one sample at a time if you wish to avoid potential execution of the FailureResponse on samples which successfully meet their MinQuantificationTargets.";
Warning::QuantificationAliquotRequired = "The QuantificationAliquot option is defaulting to True because a) one or more of the options QuantificationAliquotVolume, QuantificationAliquotContainer, and QuantificationRecoupSample were specified for at least one sample or b) one or more samples are in a container which is not compatible with the QuantificationInstrument.";
Warning::QuantificationAliquotRecommended = "The QuantificationMethod option is `1` while Preparation is `2` and QuantificationAliquot is `3`. Under these circumstances, it is recommended to set QuantificationAliquot to True to minimize the duration for which the cell sample(s) are outside of the incubator(s). If QuantificationAliquot is False, the cell sample(s) remain outside of the incubator(s) until the quantification procedure is completed. If QuantificationAliquot is True, the source cell samples are returned to the incubators immediately after aliquots are transferred to new containers, and then the quantification measurement is performed on the aliquoted samples.";

(* ::Subsubsection::Closed:: *)
(*resolveExperimentIncubateCellsOptions *)

DefineOptions[
	resolveExperimentIncubateCellsOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentIncubateCellsOptions[mySamples: {ObjectP[Object[Sample]]...}, myOptions: {_Rule...}, myResolutionOptions: OptionsPattern[resolveExperimentIncubateCellsOptions]] := Module[
	{
		(* Setup *)
		outputSpecification, output, performSimulationQ, gatherTests, messages, notInEngine, cacheBall, simulation, fastAssoc,  confirm, canaryBranch,template,
		fastTrack, operator, parentProtocol, upload, outputOption, quantificationOptionsExceptAliquoting, quantificationAliquotingOptions,
		samplePackets, sampleModelPackets, sampleContainerPackets,
		sampleContainerModelPackets, sampleContainerHeights, sampleContainerFootprints, fastAssocKeysIDOnly, incubatorPackets,
		rackPackets, deckPackets, storageConditionPackets, plateReaderInstrumentPacket,
		incubationConditionOptionDefinition, allowedStorageConditionSymbols,
		customIncubatorPackets, customIncubators,
		(* Input invalidation check *)
		discardedSamplePackets, discardedInvalidInputs, discardedTest, deprecatedSampleModelPackets, deprecatedSampleModelInputs,
		deprecatedSampleInputs, deprecatedTest, mainCellIdentityModels, sampleCellTypes, validCellTypeQs, invalidCellTypeSamples,
		invalidCellTypePositions, invalidCellTypeCellTypes, invalidCellTypeTest, inputContainerContents, stowawaySamples,
		invalidPlateSampleInputs, invalidPlateSampleTest, talliedSamples, duplicateSamples, duplicateSamplesTest,
		invalidPropertySampleInputsRaw, invalidSamplePropertiesRaw,
		invalidPropertySampleInputs, invalidPropertySampleTest, invalidSampleProperties,
		(* Option precision check *)
		roundedIncubateCellsOptions, precisionTests,
		(* MapThread propagation*)
		mapThreadFriendlyOptionsNotPropagated, mapThreadFriendlyOptions, indexMatchingOptionNames, nonAutomaticOptionsPerContainer,
		mergedNonAutomaticOptionsPerContainer,
		(* Conflicting Check I *)
		preparationResult, allowedPreparation, preparationTest, resolvedPreparation, roboticPrimitiveQ, workCellResult,
		allowedWorkCell, workCellTest, resolvedWorkCell, conflictingWorkCellAndPreparationQ, conflictingWorkCellAndPreparationOptions,
		conflictingWorkCellAndPreparationTest, coveredContainerQs, uncoveredSamples, uncoveredSamplePositions, uncoveredContainers,
		uncoveredSampleInputs, uncoveredContainerTest,
		(* Singleton Options and Labels *)
		allDoublingTimes, resolvedTime, resolvedIncubationStrategy, resolvedQuantificationInterval, specifiedQuantificationInstrument, resolvedQuantificationMethod,
		semiResolvedQuantificationInstrument, maxNumberOfQuantifications, resolvedQuantificationBlankMeasurementBool, resolvedSampleLabels, resolvedSampleContainerLabels,
		preResolvedQuantificationAliquotBool, resolvedRecoupSampleBool,
		(* MapThread IncubationCondition options and errors *)
		optionsToPullOut, cellTypes, cultureAdhesions, temperatures, carbonDioxidePercentages, relativeHumidities,
		shaking, shakingRates, semiResolvedShakingRadii, samplesOutStorageCondition, incubationCondition, cellTypesFromSample,
		cultureAdhesionsFromSample, minQuantificationTargets, quantificationTolerances,
		quantificationAliquotContainers, quantificationAliquotVolumes,
		quantificationBlanks, quantificationWavelengths, quantificationStandardCurves,
		conflictingShakingConditionsErrors, conflictingCellTypeErrors, conflictingCultureAdhesionErrors,
		invalidIncubationConditionErrors, conflictingCellTypeAdhesionErrors, unsupportedCellCultureTypeErrors,
		conflictingCellTypeWithIncubatorErrors, conflictingCultureAdhesionWithContainerErrors,
		conflictingCellTypeWithStorageConditionErrors, conflictingCultureAdhesionWithStorageConditionWarnings,
		cellTypeNotSpecifiedWarnings, cultureAdhesionNotSpecifiedWarnings, customIncubationConditionNotSpecifiedWarnings,
		minTargetNoneWarningBools, unspecifiedMapThreadOptions,
		(* Incubators and other Post-MapThread Resolutions *)
		sampleContainerModels, possibleIncubatorPackets, possibleIncubators, rawIncubators, incubators, defaultIncubatorForNull, noResolvedIncubatorBools,
		resolvedShakingRadiiPreRounding, resolvedShakingRadii, resolvedFailureResponse, discardUponFailureWarningBool,
		(* Combine *)
		email, resolvedOptions, resolvedMapThreadOptions, finalQuantificationInstrument, finalAliquotBools, resolvedAliquotBool, finalAliquotVolumes,
		finalAliquotContainers, finalStandardCurves, finalWavelengths, finalBlanks, quantificationSimulation, simulationWithQuantification,
		quantificationProtocolPacket, resolvedQuantificationOptions, errorChecksBeforeQuantification, mixedAliquotingQ,
		(* Unresolvable option check *)
		containersToSamples, incubatorsToContainers, incubatorFootprints, incubatorsOverCapacityAmounts,
		(* Conflicting Check II *)
		tooManySamples, tooManySamplesTest, groupedSamplesContainersAndOptions, inconsistentOptionsPerContainer,
		samplesWithSameContainerConflictingOptions, samplesWithSameContainerConflictingErrors, conflictingIncubationConditionsForSameContainerOptions,
		conflictingIncubationConditionsForSameContainerTests, temperatureAboveMaxTemperatureQs, incubationMaxTemperatureOptions,
		incubationMaxTemperatureTests, resolvedUnspecifiedOptions, customIncubationWarningSamples, customIncubationWarningPositions,
		customIncubationWarningUnspecifiedOptionNames, customIncubationWarningResolvedOptions, customIncubationNotSpecifiedTest,
		noCompatibleIncubatorErrors, noCompatibleIncubatorTests, noCompatibleIncubatorsInvalidInputs,
		incubatorIsIncompatibleErrors, incubatorIsIncompatibleOptions, incubatorIsIncompatibleTests,
		firstCustomIncubator,
		invalidCustomIncubatorsTests, invalidCustomIncubatorsOptions, invalidCustomIncubatorsErrors,
		invalidShakingConditionsOptions, invalidShakingConditionsTests, conflictingCellTypeOptions, conflictingCellTypeTests,
		conflictingCultureAdhesionOptions, conflictingCultureAdhesionTests, cellTypeNotSpecifiedTests, cultureAdhesionNotSpecifiedTests,
		invalidIncubationConditionOptions, invalidIncubationConditionTest, conflictingCellTypeAdhesionOptions,
		conflictingCellTypeAdhesionTests, unsupportedCellCultureTypeOptions, unsupportedCellCultureTypeTests,
		conflictingCellTypeWithIncubatorOptions, conflictingCellTypeWithIncubatorTests, extraneousQuantifyColoniesOptionsTest,
		incubatorOverCapacityIncubators,  incubatorOverCapacityCapacities, incubatorsOverCapacityFootprints,
		incubatorsOverCapacityQuantities, conflictingCultureAdhesionWithContainerOptions, conflictingCultureAdhesionWithContainerTests,
		conflictingCellTypeWithStorageConditionOptions, conflictingCellTypeWithStorageConditionTests,
		mixedQuantificationAliquotRequirementsOptions, mixedQuantificationAliquotRequirementsOptionsTests,
		quantificationAliquotRequiredQ, quantificationAliquotRequiredTest, quantificationAliquotRecommendedQ, quantificationAliquotRecommendedTest,
		conflictingCultureAdhesionWithStorageConditionTests,
		conflictingIncubationStrategyCases, conflictingIncubationStrategyTest, unsuitableQuantificationIntervalCases, unsuitableQuantificationIntervalTest,
		conflictingQuantificationAliquotOptionsCases, conflictingQuantificationAliquotOptions, conflictingQuantificationAliquotOptionsTest,
		conflictingQuantificationOptionsCases, conflictingQuantificationOptionsTest, failureResponseNotSupportedTest, failureResponseNotSupportedCases,
		noQuantificationTargetCases, conflictingIncubationStrategyOptions, unsuitableQuantificationIntervalOptions, aliquotRecoupMismatchQ, aliquotRecoupMismatchedOptions, aliquotRecoupMismatchTest,
		excessiveQuantificationAliquotVolumeRequiredCases, excessiveQuantificationAliquotVolumeRequiredOptions, excessiveQuantificationAliquotVolumeRequiredTest,
		conflictingQuantificationOptions, failureResponseNotSupportedOptions, extraneousQuantifyColoniesOptions, extraneousQuantifyColoniesOptionsCases,
		conflictingQuantificationMethodAndInstrumentError, conflictingQuantificationMethodAndInstrumentOptions, conflictingQuantificationMethodAndInstrumentOptionsTest,
		quantificationTargetUnitsMismatchCases, quantificationTargetUnitsMismatchOptions, quantificationTargetUnitsMismatchTest,
		(* Wrap up *)
		invalidInputs, invalidOptions
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Determine if we are in Engine or not, in Engine we silence warnings*)
	notInEngine = !MatchQ[$ECLApplication, Engine];

	(* Fetch our cache from the parent function, and convert it to a fastAssoc for quick lookups *)
	cacheBall = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(* Get the options that do not need to be resolved directly from SafeOptions. *)
	{confirm, canaryBranch, template, fastTrack, operator, parentProtocol, upload, outputOption} = Lookup[
		myOptions,
		{Confirm, CanaryBranch, Template, FastTrack, Operator, ParentProtocol, Upload, Output}
	];

	(* Set variables with lists of the quantification-related options, for use in the resolver. *)
	(* The QuantificationAliquot Boolean is not included here, nor is the IncubationStrategy master switch. *)
	quantificationOptionsExceptAliquoting = {
		QuantificationMethod, MinQuantificationTarget, QuantificationTolerance, QuantificationInterval, FailureResponse,
		QuantificationInstrument, QuantificationBlank, QuantificationBlankMeasurement, QuantificationWavelength, QuantificationStandardCurve
	};
	quantificationAliquotingOptions = {QuantificationAliquotVolume, QuantificationAliquotContainer, QuantificationRecoupSample};

	(* Pull out packets from the fast association *)
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;
	sampleModelPackets = fastAssocPacketLookup[fastAssoc, #, Model]& /@ mySamples;
	sampleContainerPackets = Replace[
		fastAssocPacketLookup[fastAssoc, #, Container]& /@ mySamples,
		Null -> <||>, {1}];
	sampleContainerModelPackets = Replace[
		fastAssocPacketLookup[fastAssoc, #, {Container, Model}]& /@ mySamples,
		Null|$Failed -> <||>, {1}];

	(* Get the height of the containers and the footprint (will be needed later) *)
	{sampleContainerHeights, sampleContainerFootprints} = Transpose[Map[
		If[MatchQ[#,PacketP[Model[Container]]],
			(* If the container model packet is actually a packet, not $Failed because our invalid sample may not have a container, do the lookups *)
			{
				(* Dimensions must be populated here; otherwise this will throw an error, but that is probably ok because if we have no Dimensions we are hosed no matter what *)
				Lookup[#, Dimensions][[3]],
				Lookup[#, Footprint]
			},
			{Null,Null} (*Otherwise do not trainwreck error here*)
		]&,
		sampleContainerModelPackets
	]];

	(* the incubators/racks/decks are straightforward enough to get here by just matching on the types *)
	fastAssocKeysIDOnly = Select[Keys[fastAssoc], StringMatchQ[Last[#], ("id:"~~___)]&];
	incubatorPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Instrument, Incubator]]];
	rackPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Container, Rack]]];
	deckPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Container, Deck]]];
	storageConditionPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[StorageCondition]]];

	(* Get the packet for any specified plate reader or nephelometer - we'll use this to check plate compatibility. *)
	plateReaderInstrumentPacket = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[{
		Object[Instrument, PlateReader], Model[Instrument, PlateReader], Object[Instrument, Nephelometer], Model[Instrument, Nephelometer]
	}]];

	(* Pull out the allowed storage condition symbols for the IncubationCondition option *)
	incubationConditionOptionDefinition = FirstCase[OptionDefinition[ExperimentIncubateCells], KeyValuePattern["OptionName" -> "IncubationCondition"]];
	allowedStorageConditionSymbols = Cases[Lookup[incubationConditionOptionDefinition, "SingletonPattern"], SampleStorageTypeP|Custom, Infinity];

	(* Custom incubators objects and models. If ProvidedStorageCondition is Null, then they must be custom incubators *)
	(* don't love this hard coding *)
	customIncubatorPackets = Cases[incubatorPackets, KeyValuePattern[ProvidedStorageCondition -> Null]];
	customIncubators = Lookup[customIncubatorPackets, Object, {}];

	(*-- INPUT VALIDATION CHECKS --*)
	(* 1.) Get the samples from mySamples that are discarded. *)
	discardedSamplePackets = Cases[samplePackets, KeyValuePattern[Status -> Discarded]];
	discardedInvalidInputs = Lookup[discardedSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> cacheBall]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall] <> " are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, discardedInvalidInputs], Cache -> cacheBall] <> " are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* 2.) Get whether the samples have deprecated models. *)
	deprecatedSampleModelPackets = Cases[sampleModelPackets, KeyValuePattern[Deprecated -> True]];
	deprecatedSampleModelInputs = Lookup[deprecatedSampleModelPackets, Object, {}];
	deprecatedSampleInputs = Lookup[
		PickList[samplePackets, sampleModelPackets, KeyValuePattern[Deprecated -> True]],
		Object,
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[deprecatedSampleModelInputs] > 0 && messages,
		Message[Error::DeprecatedModels, ObjectToString[deprecatedSampleModelInputs, Cache -> cacheBall]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedSampleInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[deprecatedSampleInputs, Cache -> cacheBall] <> " have models that are not Deprecated:", True, False]
			];

			passingTest = If[Length[deprecatedSampleInputs] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, deprecatedSampleInputs], Cache -> cacheBall] <> " have models that are not Deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* 3.) Get whether the input cell types are supported *)

	(* first get the main cell object in the composition; if this is a mixture it will pick the one with the highest concentration *)
	mainCellIdentityModels = selectMainCellFromSample[mySamples, Cache -> cacheBall, Simulation -> simulation];

	(* Determine what kind of cells the input samples are *)
	sampleCellTypes = lookUpCellTypes[samplePackets, sampleModelPackets, mainCellIdentityModels, Cache -> cacheBall];

	(* Note here that Null is acceptable because we're going to assume it's Bacterial later *)
	validCellTypeQs = MatchQ[#, Mammalian|Yeast|Bacterial|Null]& /@ sampleCellTypes;
	invalidCellTypeSamples = Lookup[PickList[samplePackets, validCellTypeQs, False], Object, {}];
	invalidCellTypePositions = First /@ Position[validCellTypeQs, False];
	invalidCellTypeCellTypes = PickList[sampleCellTypes, validCellTypeQs, False];

	If[Length[invalidCellTypeSamples] > 0 && messages,
		Message[Error::UnsupportedCellTypes, ObjectToString[invalidCellTypeSamples, Cache -> cacheBall], invalidCellTypePositions, invalidCellTypeCellTypes]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidCellTypeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidCellTypeSamples] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[invalidCellTypeSamples, Cache -> cacheBall] <> " are of supported cell types (Bacterial, Mammalian, or Yeast):", True, False]
			];

			passingTest = If[Length[invalidCellTypeSamples] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, invalidCellTypeSamples], Cache -> cacheBall] <> " are of supported cell types (Bacterial, Mammalian, or Yeast):", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* 4.) Get whether there are stowaway samples inside the input plates.  We're forbidding users from incubating samples when there are other samples in the plate already *)
	inputContainerContents = Lookup[sampleContainerPackets, Contents, {}];
	stowawaySamples = Map[
		Function[{contents},
			Module[{contentsObjects},
				contentsObjects = Download[contents[[All, 2]], Object];
				Select[contentsObjects, Not[MemberQ[mySamples, #]]&]
			]
		],
		inputContainerContents
	];
	invalidPlateSampleInputs = Lookup[
		PickList[samplePackets, stowawaySamples, Except[{}]],
		Object,
		{}
	];

	If[Length[invalidPlateSampleInputs] > 0 && messages,
		Message[Error::InvalidPlateSamples, ObjectToString[#, Cache -> cacheBall]& /@ DeleteCases[stowawaySamples, {}], ObjectToString[invalidPlateSampleInputs, Cache -> cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidPlateSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidPlateSampleInputs] == 0,
				Nothing,
				Test["The input samples " <> ObjectToString[invalidPlateSampleInputs, Cache -> cacheBall] <> " are in containers that do not have other, not-provided samples in them:", True, False]
			];

			passingTest = If[Length[invalidPlateSampleInputs] == Length[mySamples],
				Nothing,
				Test["The input samples " <> ObjectToString[Complement[mySamples, invalidPlateSampleInputs], Cache -> cacheBall] <> " are in containers that do not have other, not-provided samples in them:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* 5.) Throw an error if we have duplicate samples provided *)
	talliedSamples = Tally[mySamples];
	duplicateSamples = Cases[talliedSamples, {sample_, tally:GreaterEqualP[2]} :> sample];

	If[Length[duplicateSamples] > 0 && messages,
		Message[Error::DuplicatedSamples, ObjectToString[duplicateSamples, Cache -> cacheBall], "ExperimentIncubateCells"]
	];
	duplicateSamplesTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[duplicateSamples] == 0,
				Nothing,
				Test["The input samples " <> ObjectToString[duplicateSamples, Cache -> cacheBall] <> " have not been specified more than once:", True, False]
			];

			passingTest = If[Length[duplicateSamples] == Length[mySamples],
				Nothing,
				Test["The input samples " <> ObjectToString[Complement[mySamples, duplicateSamples], Cache -> cacheBall] <> " have not been specified more than once:", True, True]
			];

			{failingTest, passingTest}
		]
	];

	(* 6.) Throw an error is we have samples with invalid properties, e.g. State -> Gas, Zero mass or volume *)
	{invalidPropertySampleInputsRaw, invalidSamplePropertiesRaw} = Transpose@Map[
		Function[samplePacket,
			Module[{sample, state, volume, mass},
				{sample, state, volume, mass} = Lookup[samplePacket, {Object, State, Volume, Mass}, Null];

				Switch[{state, volume, mass},
					(* The sample state is Gas or Null, invalid *)
					{Except[Liquid|Solid], _, _},
						{sample, {state, volume, mass}},
					(* The sample is a zero-volume liquid, invalid *)
					{Liquid, EqualP[0 Milliliter], _},
						{sample, {state, volume, mass}},
					(* The sample is a zero-mass solid, invalid *)
					{Solid, _, EqualP[0 Gram]},
					 	{sample, {state, volume, mass}},
					(* Otherwise all good *)
					_, {Null, Null}
				]
			]
		],
		samplePackets
	];

	invalidPropertySampleInputs = DeleteCases[invalidPropertySampleInputsRaw,Null];
	invalidSampleProperties = DeleteCases[invalidSamplePropertiesRaw,Null];

	If[Length[invalidPropertySampleInputs] > 0 && messages,
		Message[Error::InvalidPropertySamples,
			ObjectToString[invalidPropertySampleInputs, Cache -> cacheBall],
			invalidSampleProperties[[All,1]],
			invalidSampleProperties[[All,2]],
			invalidSampleProperties[[All,3]]
		]
	];

	invalidPropertySampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidPropertySampleInputs] == 0,
				Nothing,
				Test["The input samples " <> ObjectToString[invalidPropertySampleInputs, Cache -> cacheBall] <> " are Liquid or Solid with non-zero amount left:", True, False]
			];

			passingTest = If[Length[invalidPropertySampleInputs] == Length[mySamples],
				Nothing,
				Test["The input samples " <> ObjectToString[Complement[mySamples, invalidPropertySampleInputs], Cache -> cacheBall] <> " are Liquid or Solid with non-zero amount left:", True, True]
			];

			{failingTest, passingTest}
		]
	];

	(*-- OPTION PRECISION CHECKS --*)

	{roundedIncubateCellsOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[
			(* dropping these two keys because they are often huge and make variables unnecssarily take up memory + become unreadable *)
			KeyDrop[Association[myOptions], {Cache, Simulation}],
			{Temperature, Time, CarbonDioxide, RelativeHumidity, ShakingRate, QuantificationInterval, QuantificationAliquotVolume, QuantificationWavelength},
			{1 Celsius, 1 Minute, 1 Percent, 1 Percent, 1 RPM, 1 Minute, 10^(-1) Microliter, 1 Nanometer},
			Output -> {Result, Tests}
		],
		{
			RoundOptionPrecision[
				(* dropping these two keys because they are often huge and make variables unnecssarily take up memory + become unreadable *)
				KeyDrop[Association[myOptions], {Cache, Simulation}],
				{Temperature, Time, CarbonDioxide, RelativeHumidity, ShakingRate, QuantificationInterval, QuantificationAliquotVolume, QuantificationWavelength},
				{1 Celsius, 0.1 Hour, 1 Percent, 1 Percent, 1 RPM, 0.1 Hour, 10^(-1) Microliter, 1 Nanometer}
			],
			Null
		}
	];


	(* --- Propagate options specified for one sample in a container to all the other samples in that same container --- *)

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptionsNotPropagated = OptionsHandling`Private`mapThreadOptions[ExperimentIncubateCells, roundedIncubateCellsOptions];

	(* Make rules associating a given input container with the suite of specified options *)
	indexMatchingOptionNames = ToExpression[Lookup[
		Select[OptionDefinition[ExperimentIncubateCells], Not[NullQ[Lookup[#, "IndexMatchingInput"]]]&],
		"OptionName",
		{}
	]];
	nonAutomaticOptionsPerContainer = MapThread[
		Function[{sample, options},
			(* this is a weird use of Select *)
			(* basically select all the instances of our index matching options that don't have Automatic and return that association *)
			fastAssocLookup[fastAssoc, sample, {Container, Object}] -> Select[
				KeyTake[options, indexMatchingOptionNames],
				Not[MatchQ[#, Automatic]]&
			]
		],
		{mySamples, mapThreadFriendlyOptionsNotPropagated}
	];

	(* Merging them together is super weird because we call Merge twice! *)
	(* the format of the input will be something like this: *)
	(* {container1 -> <|Temperature -> 30 Celsius|>, container1 -> <|RelativeHumidity -> 94 Percent|>, container2 -> <||>} *)
	(* Merge[..., Merge[#, First] & ] will convert this to <|container1 -> <|Temperature -> 30 Celsius, RelativeHumidity -> 94 Percent|>, container2 -> <||>|> *)
	(* If I just did Merge[..., Join] then I would end up with <|container1 -> {<|Temperature -> 30 Celsius|>, <|RelativeHumidity -> 94 Percent|>}, container2 -> {<||>}|>*)
	(* that gets me part of the way there, but I need to merge the interior associations too *)
	(* the First part is also weird; if I put Join there then I end up with a list, when really I want only one value per container *)
	(* if someone happens to give me something like the following: *)
	(* {container1 -> <|Temperature -> 30 Celsius|>, container1 -> <|Temperature -> 37 Celsius|>, container2 -> <||>}*)
	(* then my First here does lose the information of the 37 Celsius; however, that is ok because in this case we are going to be throwing an error message later for conflicting incubation conditions *)
	(* thus, it doesn't really matter what I resolve to for the _other_ automatics, because both values will be invalid anyway *)
	mergedNonAutomaticOptionsPerContainer = Merge[nonAutomaticOptionsPerContainer, Merge[#, First] &];

	(* Propagate the options I am dealing with out *)
	mapThreadFriendlyOptions = MapThread[
		Function[{sample, options},
			(* Join the options we already have with the ones we're propagating out *)
			(* the Join will cause the second set of options to replace the first set if possible *)
			Join[
				options,
				Module[{container, containerOptions},
					(* get the container of the sample in question, and the associated options we want to propagate across this container that we calculated above *)
					container = fastAssocLookup[fastAssoc, sample, {Container, Object}];
					containerOptions = Lookup[mergedNonAutomaticOptionsPerContainer, container, <||>];

					(* for each option, if *)
					(* 1.) The specified value for that option is Automatic for the given sample *)
					(* 2.) A different sample in the same container has a value that is not Automatic *)
					(* then we propagate the non-Automatic value in the same container to this sample too *)
					Association[Map[
						Function[{optionName},
							If[MatchQ[Lookup[options, optionName], Automatic] && KeyExistsQ[containerOptions, optionName],
								optionName -> Lookup[containerOptions, optionName],
								Nothing
							]
						],
						indexMatchingOptionNames
					]]

				]
			]
		],
		{mySamples, mapThreadFriendlyOptionsNotPropagated}
	];


	(*-- CONFLICTING OPTIONS CHECKS --*)


	(*---  Resolve the Preparation to determine liquidhandling scale, then do this for WorkCell too  ---*)
	preparationResult = Check[
		{allowedPreparation, preparationTest} = If[gatherTests,
			resolveIncubateCellsMethod[mySamples, ReplaceRule[myOptions, {Cache -> cacheBall, Output -> {Result, Tests}}]],
			{
				resolveIncubateCellsMethod[mySamples, ReplaceRule[myOptions, {Cache -> cacheBall, Output -> Result}]],
				{}
			}
		],
		$Failed
	];

	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation = If[MatchQ[allowedPreparation, _List],
		First[allowedPreparation],
		allowedPreparation
	];

	(* Build a short hand for robotic primitive*)
	roboticPrimitiveQ = MatchQ[resolvedPreparation, Robotic];

	(* Determine whether we need to perform simulations for the quantification child functions in the resolver. *)
	performSimulationQ = MemberQ[output, Simulation] && !roboticPrimitiveQ;

	(* Do the same as above except with WorkCell *)
	workCellResult = Check[
		{allowedWorkCell, workCellTest} = Which[
			MatchQ[resolvedPreparation, Manual], {Null, Null},
			 gatherTests,
				resolveIncubateCellsWorkCell[mySamples, ReplaceRule[Normal[roundedIncubateCellsOptions, Association], {Cache -> cacheBall, Output -> {Result, Tests}}]],
			True,
				{
					resolveIncubateCellsWorkCell[mySamples, ReplaceRule[Normal[roundedIncubateCellsOptions, Association], {Cache -> cacheBall, Output -> Result}]],
					{}
				}
		],
		$Failed
	];

	(* If we have more than one allowable preparation method, choose microbioSTAR first because we're going to resolve to Bacterial below. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedWorkCell = Which[
		Not[MatchQ[Lookup[myOptions, WorkCell], Automatic]], Lookup[myOptions, WorkCell],
		ListQ[allowedWorkCell] && MemberQ[allowedWorkCell, microbioSTAR], microbioSTAR,
		ListQ[allowedWorkCell], FirstOrDefault[allowedWorkCell],
		True, allowedWorkCell
	];

	(* If Preparation -> Robotic, WorkCell can't be Null.  If Preparation -> Manual, WorkCell can't be specified *)
	conflictingWorkCellAndPreparationQ = Or[
		MatchQ[resolvedPreparation, Robotic] && NullQ[resolvedWorkCell],
		MatchQ[resolvedPreparation, Manual] && Not[NullQ[resolvedWorkCell]]
	];
	(* NOT throwing this message if we already thew Error::ConflictingIncubationWorkCells because if that message got thrown than our work cell is always Null and so this will always get thrown too *)
	conflictingWorkCellAndPreparationOptions = If[conflictingWorkCellAndPreparationQ && Not[MatchQ[workCellResult, $Failed]] && messages,
		(
			Message[Error::ConflictingWorkCellWithPreparation, resolvedWorkCell, resolvedPreparation];
			{WorkCell, Preparation}
		),
		{}
	];
	conflictingWorkCellAndPreparationTest = If[gatherTests,
		Test["If Preparation -> Robotic, WorkCell must not be Null.  If Preparation -> Manual, WorkCell must not be specified:",
			conflictingWorkCellAndPreparationQ,
			False
		]
	];

	(* Get whether the input samples are in covered containers *)
	coveredContainerQs = Not[NullQ[#]]& /@ Lookup[sampleContainerPackets, Cover, {}];
	uncoveredSamples = PickList[samplePackets, coveredContainerQs, False];
	uncoveredSamplePositions = First /@ Position[coveredContainerQs, False];
	uncoveredContainers = PickList[sampleContainerPackets, coveredContainerQs, False];

	(* If we're doing robotic this is always {} *)
	uncoveredSampleInputs = If[MatchQ[resolvedPreparation, Robotic],
		{},
		Lookup[uncoveredSamples, Object, {}]
	];

	If[Length[uncoveredSampleInputs] > 0 && messages,
		Message[Error::UnsealedCellCultureVessels, ObjectToString[uncoveredSampleInputs, Cache -> cacheBall], uncoveredSamplePositions, ObjectToString[uncoveredContainers, Cache -> cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	uncoveredContainerTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[uncoveredSampleInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[uncoveredSampleInputs, Cache -> cacheBall] <> " are in covered containers if Preparation -> Manual:", True, False]
			];

			passingTest = If[Length[uncoveredSampleInputs] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, uncoveredSampleInputs], Cache -> cacheBall] <> " are in covered containers if Preparation -> Manual:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* Resolve label options *)
	resolvedSampleLabels = Module[
		{specifiedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelLookup},
		(* Create a unique label for each unique sample in the input *)
		specifiedSampleObjects = Lookup[samplePackets, Object];
		uniqueSamples = DeleteDuplicates[specifiedSampleObjects];
		preResolvedSampleLabels = Table[CreateUniqueLabel["incubate cells input sample"], Length[uniqueSamples]];
		preResolvedSampleLabelLookup = MapThread[
			(#1 -> #2)&,
			{uniqueSamples, preResolvedSampleLabels}
		];
		(* Expand the sample-specific unique labels *)
		MapThread[
			Function[{object, label},
				Which[
					(* respect user specification *)
					MatchQ[label, Except[Automatic]],
					label,
					(* respect upstream LabelSample/LabelContainer input *)
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, object], _String],
					LookupObjectLabel[simulation, object],
					(* get a label from the lookup *)
					True,
					Lookup[preResolvedSampleLabelLookup, object]
				]
			],
			{specifiedSampleObjects, Lookup[myOptions, SampleLabel]}
		]
	];

	resolvedSampleContainerLabels = Module[
		{specifiedContainerObjects, uniqueContainers, preResolvedSampleContainerLabels, preResolvedContainerLabelLookup},
		(* Create a unique label for each unique container in the input *)
		specifiedContainerObjects = Download[Lookup[samplePackets, Container, {}], Object];
		uniqueContainers = DeleteDuplicates[specifiedContainerObjects];
		preResolvedSampleContainerLabels = Table[CreateUniqueLabel["incubate cells input sample container"], Length[uniqueContainers]];
		preResolvedContainerLabelLookup = MapThread[
			(#1 -> #2)&,
			{uniqueContainers, preResolvedSampleContainerLabels}
		];
		(* Expand the sample-specific unique labels *)
		MapThread[
			Function[{object, label},
				Which[
					(* respect user specification *)
					MatchQ[label, Except[Automatic]],
					label,
					(* respect upstream LabelSample/LabelContainer input *)
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, object], _String],
					LookupObjectLabel[simulation, object],
					(* get a label from the lookup *)
					True,
					Lookup[preResolvedContainerLabelLookup, object]
				]
			],
			{specifiedContainerObjects, Lookup[myOptions, SampleContainerLabel]}
		]
	];

	(* Get all the doubling times of the input cells  *)
	allDoublingTimes = fastAssocLookup[fastAssoc, #, DoublingTime]& /@ mainCellIdentityModels;

	(* Resolve the IncubationStrategy. *)
	resolvedIncubationStrategy = Which[
		(* If the user specified the option, use their specification. *)
		MatchQ[Lookup[myOptions, IncubationStrategy], Except[Automatic]], Lookup[myOptions, IncubationStrategy],
		(* If any of the options related to quantification are specified, set this to QuantificationTarget. *)
		MemberQ[Flatten @ Lookup[myOptions, Join[quantificationOptionsExceptAliquoting, quantificationAliquotingOptions, {QuantificationAliquot}]], Except[Null|False|Automatic]], QuantificationTarget,
		(* Otherwise, set this to Time. *)
		True, Time
	];

	(* Resolve the Time option *)
	resolvedTime = Which[
		(* always use user specified time if applicable *)
		TimeQ[Lookup[roundedIncubateCellsOptions, Time]],
			Lookup[roundedIncubateCellsOptions, Time],
		(* if we're robotic, we're rather limited; just take what the default is there *)
		roboticPrimitiveQ,
			$MaxRoboticIncubationTime,
		(* if the incubation Strategy is QuantificationTarget, set this to 12 Hour *)
		MatchQ[resolvedIncubationStrategy, QuantificationTarget],
			12 Hour,
		(* if we're manual and know the doubling times of our input samples, then take the shortest between $MaxCellIncubationTime and 36 * doubling time across the samples *)
		MemberQ[allDoublingTimes, TimeP],
			SafeRound[Min[Sequence @@ (36 * Cases[allDoublingTimes, TimeP]), $MaxCellIncubationTime], 0.1 Hour],
		(* otherwise, going with 12 hours *)
		True,
			12 Hour
	];

	(* Resolve the QuantificationInterval. *)
	resolvedQuantificationInterval = Which[
		(* If the user specified the option, use their specification. *)
		MatchQ[Lookup[roundedIncubateCellsOptions, QuantificationInterval], Except[Automatic]], Lookup[roundedIncubateCellsOptions, QuantificationInterval],
		(* If the IncubationStrategy is Time, set this to Null. *)
		MatchQ[resolvedIncubationStrategy, Time], Null,
		(* Otherwise, set this to the greater of one-fifth the time or one hour. *)
		True, Max[SafeRound[0.2 * resolvedTime, 0.1 Hour], 1 Hour]
	];

	(* Get the specified QuantificationInstrument because we're about to look it up a bunch of times. *)
	specifiedQuantificationInstrument = Lookup[myOptions, QuantificationInstrument];

	(* Resolve the QuantificationMethod. *)
	resolvedQuantificationMethod = Which[
		(* If the user specified the option, use their specification. *)
		MatchQ[Lookup[myOptions, QuantificationMethod], Except[Automatic]], Lookup[myOptions, QuantificationMethod],
		(* If the IncubationStrategy is Time, set this to Null. *)
		MatchQ[resolvedIncubationStrategy, Time], Null,
		(* If QuantificationInstrument is set and is specific to one method, use that method. *)
		MatchQ[specifiedQuantificationInstrument, ObjectP[{Object[Instrument, Nephelometer], Model[Instrument, Nephelometer]}]], Nephelometry,
		MatchQ[specifiedQuantificationInstrument, ObjectP[{Object[Instrument, ColonyHandler], Model[Instrument, ColonyHandler]}]], ColonyCount,
		MatchQ[specifiedQuantificationInstrument, ObjectP[{Object[Instrument, Spectrophotometer], Model[Instrument, Spectrophotometer], Object[Instrument, PlateReader], Model[Instrument, PlateReader]}]],
			Absorbance,
		(* If any samples have a Solid State, set this to ColonyCount. *)
		MemberQ[Lookup[samplePackets, State], Solid], ColonyCount,
		(* If any specified CultureAdhesion is SolidMedia or Adherent, set this to ColonyCount. *)
		MemberQ[Lookup[myOptions, CultureAdhesion], Alternatives[SolidMedia, Adherent]], ColonyCount,
		(* If the CultureAdhesion from any sample object is SolidMedia or Adherent, set this to ColonyCount. *)
		MemberQ[Lookup[samplePackets, CultureAdhesion], Alternatives[SolidMedia, Adherent]], ColonyCount,
		(* If the MinQuantificationTarget or QuantificationTolerance is given in Colony units, set this to ColonyCount. *)
		MemberQ[Units[Flatten @ Lookup[myOptions, {MinQuantificationTarget, QuantificationTolerance}]], Colony], ColonyCount,
		(* If any cuvettes are specified for the QuantificationAliquotContainer option, set this to Absorbance. *)
		MemberQ[Lookup[myOptions, QuantificationAliquotContainer], ObjectP[Model[Container, Cuvette]]], Absorbance,
		(* Otherwise, set this to Absorbance. *)
		True, Absorbance
	];

  (* Semi-Resolve the QuantificationInstrument. *)
	semiResolvedQuantificationInstrument = Which[
		(* If the user specified the option, use their specification. *)
		MatchQ[specifiedQuantificationInstrument, Except[Automatic]], specifiedQuantificationInstrument,
		(* If the IncubationStrategy is Time, set this to Null. *)
		MatchQ[resolvedIncubationStrategy, Time], Null,
		(* If the QuantificationMethod is ColonyCount, default to the QPix. *)
		MatchQ[resolvedQuantificationMethod, ColonyCount], Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"], (* Model[Instrument, ColonyHandler, "QPix 420 HT"] *)
		(* Otherwise, set this to Automatic and let QuantifyCells resolve it later. *)
    True, Automatic
	];

	(* Resolve the QuantificationBlankMeasurement Boolean. *)
	resolvedQuantificationBlankMeasurementBool = Which[
		(* If the user specified the option, use their specification. *)
		MatchQ[Lookup[myOptions, QuantificationBlankMeasurement], Except[Automatic]], Lookup[myOptions, QuantificationBlankMeasurement],
		(* If a QuantificationBlank is specified, set this to True. *)
		MemberQ[Lookup[myOptions, QuantificationBlank], ObjectP[]], True,
		(* If the IncubationStrategy is Time, set this to Null. *)
		MatchQ[resolvedIncubationStrategy, Time], Null,
		(* If the QuantificationMethod does not require a blank, set this to False. *)
		MatchQ[resolvedQuantificationMethod, ColonyCount], False,
		(* Otherwise, set this to True. *)
		True, True
	];

	(* Pre-Resolve the QuantificationAliquot Boolean. Note that if we aliquot any sample we must aliquot ALL samples because *)
	(* otherwise the timing of the procedure becomes untenable re: aliquoting, returning samples to incubators, and quantifying. *)
	(* We much prefer to resolve this here if at all possible, as otherwise we may have to wait until ExperimentQuantifyCells fully *)
	(* resolves the aliquoting options before we know whether we can continue or we have to error out. *)
	preResolvedQuantificationAliquotBool = Which[
		(* If the user specified the option, keep the specification. *)
		MatchQ[Lookup[myOptions, QuantificationAliquot], Except[Automatic]], Lookup[myOptions, QuantificationAliquot],
		(* If any of the options related to aliquoting are specified, set this to True. *)
		MemberQ[Flatten @ Lookup[myOptions, quantificationAliquotingOptions], Except[Null|False|Automatic]], True,
		(* If preparation is Robotic, we are not aliquoting. *)
		roboticPrimitiveQ, False,
		(* If the IncubationStrategy is Time, we will not aliquot as this feature is exclusive to quantification. *)
		MatchQ[resolvedIncubationStrategy, Time], Null,
		(* If the QuantificationStrategy is ColonyCount, we will not aliquot as this is not supported. *)
		MatchQ[resolvedQuantificationMethod, ColonyCount], False,
		(* If any specified CultureAdhesion is SolidMedia or Adherent, we are not aliquoting. *)
		MemberQ[Lookup[myOptions, CultureAdhesion], Alternatives[SolidMedia, Adherent]], False,
		(* If the CultureAdhesion from any sample object is SolidMedia or Adherent, we are not aliquoting. *)
		MemberQ[Lookup[samplePackets, CultureAdhesion], Alternatives[SolidMedia, Adherent]], False,
		(* If the State of any sample object is Solid, we are not aliquoting. *)
		MemberQ[Lookup[samplePackets, State], Solid], False,
		(* If the semiResolvedQuantificationInstrument is a PlateReader but any samples are not in plates, we have to aliquot. *)
		And[
			MatchQ[semiResolvedQuantificationInstrument, ObjectP[{
				Object[Instrument, PlateReader], Object[Instrument, Nephelometer], Model[Instrument, PlateReader], Model[Instrument, Nephelometer]
			}]],
			MemberQ[Lookup[sampleContainerModelPackets, Object, Null], Except[ObjectP[Model[Container, Plate]]]]
		], True,
		(* If the semiResolvedQuantificationInstrument is a Spectrophotometer but any samples are not in cuvettes, we have to aliquot. *)
		And[
			MatchQ[semiResolvedQuantificationInstrument, ObjectP[{Object[Instrument, Spectrophotometer], Model[Instrument, Spectrophotometer]}]],
			MemberQ[Lookup[sampleContainerModelPackets, Object, Null], Except[ObjectP[Model[Container, Cuvette]]]]
		], True,
		(* If QuantificationMethod is Absorbance and the quantification instrument is a BMG plate reader, we need to aliquot if any plates are not compatible. *)
		And[
			MatchQ[resolvedQuantificationMethod, Absorbance],
			MatchQ[semiResolvedQuantificationInstrument, ObjectP[]],
			MatchQ[Lookup[plateReaderInstrumentPacket, Manufacturer], {ObjectP[Object[Company, Supplier, "id:n0k9mGzREWm6"]]}], (* Object[Company, Supplier, "BMG LabTech"] *)
			MemberQ[Lookup[sampleContainerModelPackets, Object, Null], Except[ObjectP[List@@BMGCompatiblePlatesP[Absorbance]]]]
		], True,
		(* If QuantificationMethod is Nephelometry and the quantification instrument is a BMG plate reader, we need to aliquot if any plates are not compatible. *)
		And[
			MatchQ[resolvedQuantificationMethod, Nephelometry],
			MatchQ[semiResolvedQuantificationInstrument, ObjectP[]],
			MatchQ[Lookup[plateReaderInstrumentPacket, Manufacturer], ObjectP[Object[Company, Supplier, "id:n0k9mGzREWm6"]]], (* Object[Company, Supplier, "BMG LabTech"] *)
			MemberQ[Lookup[sampleContainerModelPackets, Object, Null], Except[ObjectP[List@@BMGCompatiblePlatesP[Nephelometry]]]]
		], True,
		(* Otherwise, set this to Automatic and let QuantifyCells resolve it. We'll then throw an error if we end up with a mix of True and False. *)
		True, Automatic
	];

	(* If we are aliquoting, it doesn't matter whether the QuantificationInstrument is in a sterile environment since the source cell sample *)
	(* will never be exposed to it. If we haven't fully resolved the instrument but can already tell that we ARE NOT aliquoting, set the *)
	(* instrument to Model[Instrument, PlateReader, "CLARIOstar Plus with ACU"] such that quantification will occur within a bioSTAR enclosure. *)
	(* We only need to do this for Absorbance because there are some benchtop absorbance instruments; we have no benchtop nephelometers. *)
	semiResolvedQuantificationInstrument = If[And[
		MatchQ[preResolvedQuantificationAliquotBool, False],
		MatchQ[resolvedQuantificationMethod, Absorbance],
		MatchQ[semiResolvedQuantificationInstrument, Automatic]
	],
		Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"], (* Model[Instrument, PlateReader, "CLARIOstar Plus with ACU"] *)
		semiResolvedQuantificationInstrument
	];

	(* Resolve the RecoupSample boolean. *)
	resolvedRecoupSampleBool = Which[
		(* If the user specified the option, keep the specification. *)
		MatchQ[Lookup[myOptions, QuantificationRecoupSample], Except[Automatic]], Lookup[myOptions, QuantificationRecoupSample],
		(* If we are aliquoting, set this to False. *)
		TrueQ[preResolvedQuantificationAliquotBool], False,
		(* If we are not aliquoting, set this to Null. *)
		True, Null
	];

	(* Get the maximum number of quantification steps possible by dividing the Time by the QuantificationInterval *)
	(* The If[] is to ensure this isn't 0 if the user gives us an interval longer than the time, which trips an error message after the resolver. *)
	maxNumberOfQuantifications = If[MatchQ[Floor[resolvedTime/resolvedQuantificationInterval], GreaterP[1]],
		Floor[resolvedTime/resolvedQuantificationInterval],
		1
	];

	(* Options that Custom needs specified *)
	(* want this outside of the MapThread because want to use it below *)
	optionsToPullOut = {
		CellType,
		CultureAdhesion,
		Incubator,
		Temperature,
		CarbonDioxide,
		RelativeHumidity,
		Shake,
		ShakingRadius,
		ShakingRate
	};

	(* MapThread over each of our samples. *)
	{
		(* Options *)
		(*1*)cellTypes,
		(*2*)cultureAdhesions,
		(*3*)temperatures,
		(*4*)carbonDioxidePercentages,
		(*5*)relativeHumidities,
		(*6*)shaking,
		(*7*)shakingRates,
		(*8*)semiResolvedShakingRadii,
		(*9*)samplesOutStorageCondition,
		(*10*)incubationCondition,
		(*11*)cellTypesFromSample,
		(*12*)cultureAdhesionsFromSample,
		(*13*)minQuantificationTargets,
		(*14*)quantificationTolerances,
		(*15*)quantificationAliquotContainers,
		(*16*)quantificationAliquotVolumes,
		(*17*)quantificationBlanks,
		(*18*)quantificationWavelengths,
		(*19*)quantificationStandardCurves,
    (* Errors *)
		(*20*)conflictingShakingConditionsErrors,
		(*21*)conflictingCellTypeErrors,
		(*22*)conflictingCultureAdhesionErrors,
		(*23*)invalidIncubationConditionErrors,
		(*24*)conflictingCellTypeAdhesionErrors,
		(*25*)unsupportedCellCultureTypeErrors,
		(*26*)conflictingCellTypeWithIncubatorErrors,
		(*27*)conflictingCultureAdhesionWithContainerErrors,
		(*28*)conflictingCellTypeWithStorageConditionErrors,
		(*29*)conflictingCultureAdhesionWithStorageConditionWarnings,
		(* Warnings *)
		(*30*)cellTypeNotSpecifiedWarnings,
		(*31*)cultureAdhesionNotSpecifiedWarnings,
		(*32*)customIncubationConditionNotSpecifiedWarnings,
		(*33*)minTargetNoneWarningBools,
		(*34*)unspecifiedMapThreadOptions
	} = Transpose[MapThread[
		Function[{mySample, options, mainCellIdentityModel},
			Module[
				{
					specifiedCellType, specifiedCultureAdhesion, modelPacket, resolvedCellType, resolvedCultureAdhesion,
					resolvedTemperature, resolvedCarbonDioxidePercentage, resolvedRelativeHumidity, resolvedShaking, resolvedShakingRate,
					semiResolvedShakingRadius, semiResolvedShakingRadiusBadFloat, samplePacket, containerModelPacket, containerPacket,
					mainCellIdentityModelPacket, specifiedIncubationCondition, specifiedIncubator, samplesOutStorageConditionPacketForCustom,
					conflictingShakingConditionsError, samplesOutStorageConditionPattern, conflictingCellTypeAdhesionError,
					conflictingCellTypeError, conflictingCultureAdhesionError, specifiedIncubatorModelPacket,
					conflictingCultureAdhesionWithContainerError, resolvedSamplesOutStorageConditionSymbol,
					resolvedSamplesOutStorageConditionObject, conflictingCellTypeWithStorageConditionError,
					conflictingCultureAdhesionWithStorageConditionWarning, cellTypeNotSpecifiedWarning, cultureAdhesionNotSpecifiedWarning,
					cellTypeFromSample, cultureAdhesionFromSample, resolvedMinQuantificationTarget, minTargetNoneWarningBool, resolvedQuantificationTolerance,
					semiResolvedQuantificationAliquotContainer, semiResolvedQuantificationAliquotVolume,
					semiResolvedQuantificationBlank, semiResolvedQuantificationWavelength, semiResolvedQuantificationStandardCurve,
					unsupportedCellCultureTypeError, incubatorCellTypes, conflictingCellTypeWithIncubatorError, specifiedTemperature, specifiedCarbonDioxide,
					specifiedRelativeHumidity, specifiedShake, specifiedShakingRadius, specifiedShakingRate, incubationConditionFromOptions, incubationConditionPattern,
					specifiedSamplesOutStorageCondition, specifiedMinQuantificationTarget, specifiedQuantificationTolerance,
					specifiedQuantificationAliquotContainer, specifiedQuantificationAliquotVolume, specifiedQuantificationBlank,
					specifiedQuantificationWavelength, specifiedQuantificationStandardCurve, resolvedIncubationCondition, resolvedIncubationConditionPacket,
					resolvedSamplesOutStorageCondition, customIncubationConditionNotSpecifiedWarning, unspecifiedOptions,
					invalidIncubationConditionError
				},

				(* Setup our error tracking variables *)
				{
					(* Hard errors *)
					conflictingShakingConditionsError,
					conflictingCellTypeError,
					conflictingCultureAdhesionError,
					invalidIncubationConditionError,
					conflictingCellTypeAdhesionError,
					unsupportedCellCultureTypeError,
					conflictingCellTypeWithIncubatorError,
					conflictingCultureAdhesionWithContainerError,
					conflictingCellTypeWithStorageConditionError,
					conflictingCultureAdhesionWithStorageConditionWarning,

					(* Warnings *)
					cellTypeNotSpecifiedWarning,
					cultureAdhesionNotSpecifiedWarning,
					customIncubationConditionNotSpecifiedWarning,
					minTargetNoneWarningBool
				} = ConstantArray[False, 14];

				(* Lookup information about our sample and container packets *)
				samplePacket = fetchPacketFromFastAssoc[mySample, fastAssoc];
				modelPacket = fastAssocPacketLookup[fastAssoc, mySample, Model];
				containerPacket = fastAssocPacketLookup[fastAssoc, mySample, Container];
				containerModelPacket = fastAssocPacketLookup[fastAssoc, mySample, {Container, Model}];
				mainCellIdentityModelPacket = fetchPacketFromFastAssoc[mainCellIdentityModel, fastAssoc];

				(* Pull out the specified options *)
				{
					specifiedCellType,
					specifiedCultureAdhesion,
					specifiedIncubationCondition,
					specifiedIncubator,
					specifiedTemperature,
					specifiedCarbonDioxide,
					specifiedRelativeHumidity,
					specifiedShake,
					specifiedShakingRadius,
					specifiedShakingRate,
					specifiedSamplesOutStorageCondition,
					specifiedMinQuantificationTarget,
					specifiedQuantificationTolerance,
					specifiedQuantificationAliquotContainer,
					specifiedQuantificationAliquotVolume,
					specifiedQuantificationBlank,
					specifiedQuantificationWavelength,
					specifiedQuantificationStandardCurve
				} = Lookup[
					options,
					{
						CellType,
						CultureAdhesion,
						IncubationCondition,
						Incubator,
						Temperature,
						CarbonDioxide,
						RelativeHumidity,
						Shake,
						ShakingRadius,
						ShakingRate,
						SamplesOutStorageCondition,
						MinQuantificationTarget,
						QuantificationTolerance,
						QuantificationAliquotContainer,
						QuantificationAliquotVolume,
						QuantificationBlank,
						QuantificationWavelength,
						QuantificationStandardCurve
					}
				];

				(* Get the options that were not specified up front here *)
				unspecifiedOptions = PickList[
					optionsToPullOut,
					Lookup[options, optionsToPullOut],
					Automatic
				];

				(* If IncubationCondition was set to Custom but unspecifiedOptions is not {}, then flip the warning saying user should specify them *)
				customIncubationConditionNotSpecifiedWarning = MatchQ[specifiedIncubationCondition, Custom] && Not[MatchQ[unspecifiedOptions, {}]];

				(* If we have a specified incubator, get the packet *)
				specifiedIncubatorModelPacket = Which[
					MatchQ[specifiedIncubator, ObjectP[Model[Instrument, Incubator]]], fetchPacketFromFastAssoc[specifiedIncubator, fastAssoc],
					MatchQ[specifiedIncubator, ObjectP[Object[Instrument, Incubator]]], fastAssocPacketLookup[fastAssoc, specifiedIncubator, Model],
					True, Null
				];

				(* Get the CellType that we can discern from the sample *)
				cellTypeFromSample = Which[
					(* if the sample has a CellType, use that *)
					MatchQ[Lookup[samplePacket, CellType], CellTypeP], Lookup[samplePacket, CellType],
					(* if sample doesn't have it but its model does, use that*)
					Not[NullQ[modelPacket]] && MatchQ[Lookup[modelPacket, CellType], CellTypeP], Lookup[modelPacket, CellType],
					(* if there is a cell type identity model in its composition, pick the most concentrated one *)
					MatchQ[mainCellIdentityModel, ObjectP[Model[Cell]]], Lookup[mainCellIdentityModelPacket, CellType],
					(* otherwise, we have no idea and pick Null *)
					True, Null
				];

				(* Resolve the CellType option as if it wasn't specified, and the CellTypeNotSpecified warning and the ConflictingCellTypeError *)
				{
					resolvedCellType,
					conflictingCellTypeError,
					cellTypeNotSpecifiedWarning
				} = Which[
					(* if CellType was specified but it conflicts with the fields in the Sample, go with what was specified but flip error switch *)
					MatchQ[specifiedCellType, CellTypeP] && MatchQ[cellTypeFromSample, CellTypeP] && specifiedCellType =!= cellTypeFromSample, {specifiedCellType, True, False},
					(* if CellType was specified otherwise, just go with it *)
					MatchQ[specifiedCellType, CellTypeP], {specifiedCellType, False, False},
					(* if CellType was not specified but we could figure it out from the sample, go with that *)
					MatchQ[cellTypeFromSample, CellTypeP], {cellTypeFromSample, False, False},
					(* if CellType was not specified and we couldn't figure it out from the sample, default to Bacterial and flip warning switch *)
					True, {Bacterial, False, True}
				];

				(* Get the CultureAdhesion that we can discern from the sample *)
				cultureAdhesionFromSample = Which[
					(* if the sample has a CultureAdhesion, use that *)
					MatchQ[Lookup[samplePacket, CultureAdhesion], CultureAdhesionP], Lookup[samplePacket, CultureAdhesion],
					(* if sample doesn't have it but its model does, use that*)
					Not[NullQ[modelPacket]] && MatchQ[Lookup[modelPacket, CultureAdhesion], CultureAdhesionP], Lookup[modelPacket, CultureAdhesion],
					(* otherwise, we have no idea and pick Null *)
					True, Null
				];

				(* Resolve the CultureAdhesion option if it wasn't specified, and the CultureAdhesionNotSpecified warning and the ConflictingClutureAdhesion error *)
				{
					resolvedCultureAdhesion,
					conflictingCultureAdhesionError,
					cultureAdhesionNotSpecifiedWarning
				} = Which[
					(* if CultureAdhesion was specified but it conflicts with the fields in the Sample, go with what was specified but flip error switch *)
					MatchQ[specifiedCultureAdhesion, CultureAdhesionP] && MatchQ[cultureAdhesionFromSample, CultureAdhesionP] && specifiedCultureAdhesion =!= cultureAdhesionFromSample, {specifiedCultureAdhesion, True, False},
					(* if CultureAdhesion was specified otherwise, just go with it*)
					MatchQ[specifiedCultureAdhesion, CultureAdhesionP], {specifiedCultureAdhesion, False, False},
					(* if CultureAdhesion was not specified but we could figure it out from the sample, go with that *)
					MatchQ[cultureAdhesionFromSample, CultureAdhesionP], {cultureAdhesionFromSample, False, False},
					(* if CultureAdhesion was not specified and we coudln't figure it out from the sample, default to Suspension and flip warning switch *)
					True, {Suspension, False, True}
				];

				(* Get the incubation condition from the specified options *)
				incubationConditionPattern = KeyValuePattern[{
					CellType -> resolvedCellType,
					If[TemperatureQ[specifiedTemperature],
						Temperature -> EqualP[specifiedTemperature],
						Nothing
					],
					If[PercentQ[specifiedCarbonDioxide],
						CarbonDioxide -> EqualP[specifiedCarbonDioxide],
						Nothing
					],
					If[PercentQ[specifiedRelativeHumidity],
						Humidity -> EqualP[specifiedRelativeHumidity],
						Nothing
					],
					(* If we've specified shaking radius, take it. If we haven't specified it and we know we're shaking (i.e. some shaking option is specified or CultureAdhesion -> *)
					(* Suspension, we need the shaking radius to not be Null. If we are not shaking, we need it to be Null. *)
					Which[
						DistanceQ[specifiedShakingRadius],
							ShakingRadius -> EqualP[specifiedShakingRadius],
						NullQ[specifiedShakingRate] || NullQ[specifiedShakingRadius],
							ShakingRadius -> Null,
						TrueQ[specifiedShake] || MatchQ[resolvedCultureAdhesion, Suspension] || RPMQ[specifiedShakingRate],
							ShakingRadius -> Except[Null],
						True,
							ShakingRadius -> Null
					],
					If[RPMQ[specifiedShakingRate] && MatchQ[Lookup[containerModelPacket, Footprint], plateIncubatorFootprintsP],
						PlateShakingRate -> EqualP[specifiedShakingRate],
						Nothing
					],
					If[RPMQ[specifiedShakingRate] && !MatchQ[Lookup[containerModelPacket, Footprint], plateIncubatorFootprintsP],
						VesselShakingRate -> EqualP[specifiedShakingRate],
						Nothing
					]
				}];

				(* Given all the specified options, pick an incubation condition that would fit *)
				(* if it's nothing, then we go to Custom *)
				(* certainly my Lookup trick here is a little goofy but it works (obviously Lookup will not work with Custom directly) *)
				incubationConditionFromOptions = Lookup[
					FirstCase[storageConditionPackets, incubationConditionPattern, <|Object -> Custom|>],
					Object
				];

				(* Resolve the incubation condition *)
				resolvedIncubationCondition = Which[
					(* if the user set it, use it *)
					Not[MatchQ[specifiedIncubationCondition, Automatic]], specifiedIncubationCondition,
					(* If preparation is Robotic, always custom *)
					MatchQ[resolvedPreparation, Robotic], Custom,
					(* if Incubator is specified and it's a custom incubator, set to Custom *)
					MatchQ[specifiedIncubator, ObjectP[]] && MemberQ[customIncubators, ObjectP[specifiedIncubator]], Custom,
					(* if Incubator is specified otherwise, get its ProvidedStorageCondition (replacing Null with Custom on the off chance we get that) *)
					MatchQ[specifiedIncubator, ObjectP[]], Download[Lookup[specifiedIncubatorModelPacket, ProvidedStorageCondition], Object] /. {Null -> Custom},
					(* otherwise we figured out incubation condition based on the specified options, so go with that *)
					True, incubationConditionFromOptions
				];

				(* Get the resolved incubation condition packet *)
				resolvedIncubationConditionPacket = Switch[resolvedIncubationCondition,
					(* if we have an object, take the object *)
					ObjectP[Model[StorageCondition]], fetchPacketFromFastAssoc[resolvedIncubationCondition, fastAssoc],
					(* if it's custom, then just stick with Custom *)
					Custom, Custom,
					(* otherwise need to get the first storage condition that matches the symbol we chose *)
					_, FirstCase[storageConditionPackets, KeyValuePattern[StorageCondition -> resolvedIncubationCondition]]
				];

				(* Resolve the Temperature option *)
				resolvedTemperature = Which[
					(* If the user directly provided a Temperature, use that*)
					TemperatureQ[specifiedTemperature], specifiedTemperature,
					(* if IncubationCondition is not custom, take the temperature from that *)
					MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]], Lookup[resolvedIncubationConditionPacket, Temperature],
					(* if an incubator was specified and it has a DefaultTemperature, go with that; I don't expect this to usually be populated for custom incubators but we can have this here in case *)
					Not[NullQ[specifiedIncubatorModelPacket]] && TemperatureQ[Lookup[specifiedIncubatorModelPacket, DefaultTemperature]], Lookup[specifiedIncubatorModelPacket, DefaultTemperature],
					(* otherwise, default to 37 Celsius for Mammalian and Bacterial cells, and 30 Celsius for Yeast *)
					MatchQ[resolvedCellType, Yeast], 30 Celsius,
					True, 37 Celsius
				];

				(* Resolve the RelativeHumidity option *)
				resolvedRelativeHumidity = Which[
					(* If the user directly provided a RelativeHumidity, use that *)
					PercentQ[specifiedRelativeHumidity], specifiedRelativeHumidity,
					(* if IncubationCondition is not custom, take the humidity from that *)
					MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]], Lookup[resolvedIncubationConditionPacket, Humidity],
					(* if an incubator was specified and it has a DefaultRelativeHumidity, go with that; I don't expect this to usually be populated for custom incubators but we can have this here in case *)
					Not[NullQ[specifiedIncubatorModelPacket]] && PercentQ[Lookup[specifiedIncubatorModelPacket, DefaultRelativeHumidity]], Lookup[specifiedIncubatorModelPacket, DefaultRelativeHumidity],
					(* otherwise, default to 93 Celsius for Mammalian, and Null otherwise *)
					MatchQ[resolvedCellType, Mammalian], 93 Percent,
					True, Null
				];

				(* Resolve the CarbonDioxide option *)
				resolvedCarbonDioxidePercentage = Which[
					(* If the user directly provided a CarbonDioxide value, use that *)
					PercentQ[specifiedCarbonDioxide], specifiedCarbonDioxide,
					(* if IncubationCondition is not custom, take the CarbonDioxide from that *)
					MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]], Lookup[resolvedIncubationConditionPacket, CarbonDioxide],
					(* if an incubator was specified and it has a DefaultCarbonDioxide, go with that; I don't expect this to usually be populated for custom incubators but we can have this here in case *)
					Not[NullQ[specifiedIncubatorModelPacket]] && PercentQ[Lookup[specifiedIncubatorModelPacket, DefaultCarbonDioxide]], Lookup[specifiedIncubatorModelPacket, DefaultCarbonDioxide],
					(* otherwise, default to 5 Percent for Mammalian, and Null otherwise *)
					MatchQ[resolvedCellType, Mammalian], 5 Percent,
					True, Null
				];

				(* Resolve the Shake option *)
				resolvedShaking = Which[
					(* If the user directly provided Shaking as True, use that*)
					BooleanQ[specifiedShake], specifiedShake,
					(*If Shaking is Automatic and either ShakingRate or ShakingRadius is specified, set Shake to True*)
					RPMQ[specifiedShakingRate] || DistanceQ[specifiedShakingRadius], True,
					(* if IncubationCondition is not custom and ShakingRadius is populated, then True *)
					(* note that I don't need to check ShakingRadius _and_ ShakingRate because both are populated together *)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						Not[NullQ[Lookup[resolvedIncubationConditionPacket, ShakingRadius]]]
					], True,
					(* if none of the shaking options are specified and we're in a custom incubation, then suspensions cells should shake and others should not. *)
					(* Note that it is possible to have Suspension but we respect user input of shaking option set to Null. *)
					MatchQ[resolvedCultureAdhesion, Suspension] && MatchQ[resolvedIncubationConditionPacket, Custom], True,
					True, False
				];

				(* Resolve the ShakingRate option *)
				resolvedShakingRate = Which[
					(* If the user directly provided a ShakingRate, use that, even if it is Null *)
					MatchQ[specifiedShakingRate, Except[Automatic]], specifiedShakingRate,
					(* if Shake is resolved to False, then Null *)
					Not[resolvedShaking], Null,
					(* if IncubationCondition is not custom and ShakingRate is populated, then use the Plate/VesselShakingRate *)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]],
						Not[NullQ[Lookup[resolvedIncubationConditionPacket, PlateShakingRate]]]
					], Lookup[resolvedIncubationConditionPacket, PlateShakingRate],
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						MatchQ[containerModelPacket, PacketP[Model[Container, Vessel]]],
						Not[NullQ[Lookup[resolvedIncubationConditionPacket, VesselShakingRate]]]
					], Lookup[resolvedIncubationConditionPacket, VesselShakingRate],
					(* if an incubator was specified and it has a DefaultShakingRate, go with that; I don't expect this to usually be populated for custom incubators but we can have this here in case *)
					Not[NullQ[specifiedIncubatorModelPacket]] && RPMQ[Lookup[specifiedIncubatorModelPacket, DefaultShakingRate]], Lookup[specifiedIncubatorModelPacket, DefaultShakingRate],
					(* if we have nothing else to go on, then do 200 RPM *)
					True, 200 RPM
				];

				(* Resolve the ShakingRadius option *)
				semiResolvedShakingRadiusBadFloat = Which[
					(* If the user directly provided a ShakingRadius, use that, even if it is Null*)
					MatchQ[specifiedShakingRadius, Except[Automatic]], specifiedShakingRadius,
					(* if Shake is resolved to False, then Null *)
					Not[resolvedShaking], Null,
					(* if IncubationCondition is not custom and ShakingRadius is populated, then use the ShakingRadius *)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						Not[NullQ[Lookup[resolvedIncubationConditionPacket, ShakingRadius]]]
					], Lookup[resolvedIncubationConditionPacket, ShakingRadius],
					(* if an Incubator was specified and it has ShakingRadius, go with that *)
					Not[NullQ[specifiedIncubatorModelPacket]] && DistanceQ[Lookup[specifiedIncubatorModelPacket, ShakingRadius]], Lookup[specifiedIncubatorModelPacket, ShakingRadius],
					(* otherwise this is staying Automatic and we're going to figure it out when we have an incubator *)
					True, Automatic
				];

				(* Because ShakingRadius is an enumeration, floating point numbers can mess us up here.  IncubateCellsDevices will break if given 25.40000000000002` Millimeter even though that is what was stored in the database *)
				(* so I need to do our quasi-rounding to avoid that *)
				semiResolvedShakingRadius = If[DistanceQ[semiResolvedShakingRadiusBadFloat],
					FirstOrDefault[MinimalBy[List @@ CellIncubatorShakingRadiusP, Abs[# - semiResolvedShakingRadiusBadFloat]&, 1]],
					semiResolvedShakingRadiusBadFloat
				];

				(* Flip the conflicting shaking conditions error if we are shaking and have ShakingRadius or ShakingRate to Null *)
				(* or if we are not shaking and ShakingRadius or ShakingRate are not Null *)
				conflictingShakingConditionsError = Or[
					resolvedShaking && (NullQ[resolvedShakingRate] || NullQ[semiResolvedShakingRadius]),
					Not[resolvedShaking] && (RPMQ[resolvedShakingRate] || DistanceQ[semiResolvedShakingRadius])
				];

				(* Get the incubation condition from the specified options *)
				(* this is _only_ to tell the shaking and cell type and nothing else because we don't use custom SamplesOutStorageConditions *)
				samplesOutStorageConditionPattern = KeyValuePattern[{
					CellType -> resolvedCellType,
					(* checking all three of these options because of the case where a user specifies conflicting shaking options (i.e., Shake -> False, ShakingRate -> 200 RPM) *)
					(* if the user does that, we're already going to throw an error, but if we don't check all three,
					we're potentially going to go down a path that will cause us to throw even more messages, which customers will (rightly) find annoying and unhelpful*)
					If[resolvedShaking || DistanceQ[semiResolvedShakingRadius] || RPMQ[resolvedShakingRate],
						ShakingRadius -> Except[Null],
						ShakingRadius -> Null
					]
				}];

				(* Given all the specified options, pick an incubation condition that would fit *)
				samplesOutStorageConditionPacketForCustom = FirstCase[storageConditionPackets, samplesOutStorageConditionPattern];

				(* Resolve the SamplesOutStorageCondition option *)
				resolvedSamplesOutStorageCondition = Which[
					(* if samples out storage condition is specified, use it *)
					Not[MatchQ[specifiedSamplesOutStorageCondition, Automatic]], specifiedSamplesOutStorageCondition,
					(* if IncubationCondition is not custom, then get the incubation condition *)
					(* note that we somehow have a non-cell-culture incubation condition here, don't resolve to that because things are already borked and we don't want to throw unnecessary options together with the necessary ones  *)
					MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]] && Not[NullQ[Lookup[resolvedIncubationConditionPacket, CellType]]], Lookup[resolvedIncubationConditionPacket, StorageCondition],
					(* if IncubationCondition is custom, then pick a storage condition based only on CellType and CultureAdhesion (and just pick something based on CellType otherwise) *)
					MatchQ[resolvedIncubationCondition,Custom] && MatchQ[samplesOutStorageConditionPacketForCustom, PacketP[Model[StorageCondition]]], Lookup[samplesOutStorageConditionPacketForCustom, StorageCondition],
					(* if we somehow can't find anything, just go to fridge to avoid throwing too many errors, especially not for values we resolved to *)
					True, Refrigerator
				];

				(* Flip error switch for if IncubationCondition is specified and is not an actual IncubationCondition *)
				invalidIncubationConditionError = Or[
					MatchQ[specifiedIncubationCondition, ObjectP[Model[StorageCondition]]] && Not[MemberQ[allowedStorageConditionSymbols, fastAssocLookup[fastAssoc, specifiedIncubationCondition, StorageCondition]]],
					MatchQ[specifiedIncubationCondition, SampleStorageTypeP] && Not[MemberQ[allowedStorageConditionSymbols, specifiedIncubationCondition]]
				];

				(* Flip error switch if we're doing Mammalian samples with SolidMedia, or if we're doing Yeast/Bacterial with Adherent *)
				conflictingCellTypeAdhesionError = Or[
					MatchQ[resolvedCellType, Mammalian] && MatchQ[resolvedCultureAdhesion, SolidMedia],
					MatchQ[resolvedCellType, Bacterial|Yeast] && MatchQ[resolvedCultureAdhesion, Adherent]
				];

				(* Flip error switch if doing Mammalian and Suspension (not currently supported) *)
				unsupportedCellCultureTypeError = MatchQ[resolvedCellType, Mammalian] && MatchQ[resolvedCultureAdhesion, Suspension];

				(* Get the cell types compatilbe with the specified incubator *)
				incubatorCellTypes = If[NullQ[specifiedIncubatorModelPacket],
					Null,
					Lookup[specifiedIncubatorModelPacket, CellTypes]
				];

				(* Flip error switch if specified incubator CellTypes doesn't match the resolved CellType option *)
				conflictingCellTypeWithIncubatorError = Not[NullQ[incubatorCellTypes]] && Not[MemberQ[incubatorCellTypes, resolvedCellType]];

				(* Flip error switch if the container type doesn't work with the culture adhesion *)
				(* solid media or adherent must be in a plate *)
				conflictingCultureAdhesionWithContainerError = MatchQ[resolvedCultureAdhesion, SolidMedia|Adherent] && Not[MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]]];

				(* Get the symbol form of the SamplesOutStorageCondition at this point because that's easier to deal with *)
				(* also get the object form if we don't have it already *)
				resolvedSamplesOutStorageConditionSymbol = If[MatchQ[resolvedSamplesOutStorageCondition, ObjectP[Model[StorageCondition]]],
					fastAssocLookup[fastAssoc, resolvedSamplesOutStorageCondition, StorageCondition],
					resolvedSamplesOutStorageCondition
				];
				resolvedSamplesOutStorageConditionObject = Switch[resolvedSamplesOutStorageCondition,
					Disposal, Null,
					ObjectP[Model[StorageCondition]], resolvedSamplesOutStorageCondition,
					_, Lookup[FirstCase[storageConditionPackets, KeyValuePattern[StorageCondition -> resolvedSamplesOutStorageCondition], <|Object -> Null|>], Object]
				];

				(* Flip error switch for if the SamplesOutStorageCondition doesn't agree with what the cells are *)
				conflictingCellTypeWithStorageConditionError = Which[
					(* Disposal and Refridgerator always ok *)
					MatchQ[resolvedSamplesOutStorageConditionSymbol, Disposal|Refrigerator|Ambient], False,
					(* if CellType is Mammalian, then we need MammalianIncubation *)
					MatchQ[resolvedCellType, Mammalian], Not[MatchQ[resolvedSamplesOutStorageConditionSymbol, MammalianIncubation]],
					(* if CellType is Bacterial, then we need SamplesOutStorageCondition to be BacterialIncubation or BacterialShakingIncubation *)
					MatchQ[resolvedCellType, Bacterial], Not[MatchQ[resolvedSamplesOutStorageConditionSymbol, BacterialIncubation|BacterialShakingIncubation]],
					(* if CellType is Yeast, then we need SamplesOutStorageCondition to be YeastIncubation or YeastShakingIncubation *)
					MatchQ[resolvedCellType, Yeast], Not[MatchQ[resolvedSamplesOutStorageConditionSymbol, YeastIncubation|YeastShakingIncubation]],
					(* fallback; shouldn't get here *)
					True, False
				];

				(* Flip warning switch for if we are trying to store suspension samples in an incubator without shaking. But do not error if the storage condition is just a continuance of the incubation condition. *)
				conflictingCultureAdhesionWithStorageConditionWarning = If[MatchQ[resolvedSamplesOutStorageConditionSymbol, Disposal|Refrigerator|Ambient] || NullQ[resolvedSamplesOutStorageConditionObject],
					(* Disposal|Refrigerator|Ambient is always ok *)
					False,
					(* if CultureAdhesion is Suspension, we warn the user if it's not a direct continuance of the incubation condition *)
					MatchQ[resolvedCultureAdhesion, Suspension] && NullQ[fastAssocLookup[fastAssoc, resolvedSamplesOutStorageConditionObject, ShakingRadius]] && !MatchQ[resolvedIncubationCondition, ObjectP[resolvedSamplesOutStorageConditionObject]]
				];

				(* RESOLVE INDEX-MATCHING QUANTIFICATION OPTIONS AND ASSOCIATED ERRORS/WARNINGS *)

				(* Resolve the MinQuantificationTarget. Also throw a warning if we resolve to None from Automatic. *)
				{resolvedMinQuantificationTarget, minTargetNoneWarningBool} = Which[
					(* If the user specified the option, use their specification. *)
					MatchQ[specifiedMinQuantificationTarget, Except[Automatic]], {specifiedMinQuantificationTarget, False},
					(* If the IncubationStrategy is Time, set this to Null. *)
					MatchQ[resolvedIncubationStrategy, Time], {Null, False},
					(* Otherwise, set this to None and throw the warning switch. *)
					True, {None, True}
				];

				(* Resolve the QuantificationTolerance. *)
				resolvedQuantificationTolerance = Which[
					(* If the user specified the option, use their specification. *)
					MatchQ[specifiedQuantificationTolerance, Except[Automatic]], specifiedQuantificationTolerance,
					(* If the MinQuantificationTarget is Null or None, set this to Null. *)
					MatchQ[resolvedMinQuantificationTarget, Alternatives[Null, None]], Null,
					(* Otherwise, set this to 10 Percent. *)
					True, 10 Percent
				];

				(* Resolve the QuantificationWavelength. *)
				semiResolvedQuantificationWavelength = Which[
					(* If the user specified the option, use their specification. *)
					MatchQ[specifiedQuantificationWavelength, Except[Automatic]], specifiedQuantificationWavelength,
					(* If QuantificationMethod is not Absorbance or Nephelometry, set this to Null. *)
					MatchQ[resolvedQuantificationMethod, Except[Absorbance|Nephelometry]], Null,
					(* Otherwise, set this Automatic and let QuantifyCells handle it. *)
					True, Automatic
				];

				(* Resolve the QuantificationBlank. *)
				semiResolvedQuantificationBlank = Which[
					(* If the user specified the option, use their specification. *)
					MatchQ[specifiedQuantificationBlank, Except[Automatic]], specifiedQuantificationBlank,
					(* If QuantificationBlankMeasurement is not True, set this to Null. *)
					MatchQ[resolvedQuantificationBlankMeasurementBool, Except[True]], Null,
					(* Set this to the Solvent field of the input sample, if available. *)
					MatchQ[Lookup[samplePacket, Solvent], ObjectP[]], Lookup[samplePacket, Solvent],
					(* Otherwise, set this to Milli-Q water. *)
					True, Model[Sample, "Milli-Q water"]
				];

				(* Resolve the QuantificationStandardCurve. Note that we may leave this as Automatic and pass it to QuantifyCells to resolve. *)
				semiResolvedQuantificationStandardCurve = Which[
					(* If the user specified the option, use their specification. *)
					MatchQ[specifiedQuantificationStandardCurve, Except[Automatic]], specifiedQuantificationStandardCurve,
					(* If the QuantificationMethod is not Absorbance or Nephelometry, set this to Null. *)
					MatchQ[resolvedQuantificationMethod, Except[Absorbance | Nephelometry]], Null,
					(* Otherwise, set this to Automatic and allow ExperimentQuantifyCells to resolve it. *)
					True, Automatic
				];

				(* Resolve the QuantificationAliquotContainer. *)
				semiResolvedQuantificationAliquotContainer = Which[
					(* If the user specified the option, use their specification. *)
					MatchQ[specifiedQuantificationAliquotContainer, Except[Automatic]], specifiedQuantificationAliquotContainer,
					(* If the QuantificationAliquot Boolean is False or Null, set this to Null. *)
					MatchQ[preResolvedQuantificationAliquotBool, False|Null], Null,
					(* Otherwise, set this to Automatic and let QuantifyCell resolve it. *)
					True, Automatic
				];

				(* Resolve the QuantificationAliquotVolume. *)
				semiResolvedQuantificationAliquotVolume = Which[
					(* If the user specified the option, use their specification. *)
					MatchQ[specifiedQuantificationAliquotVolume, Except[Automatic]], specifiedQuantificationAliquotVolume,
					(* If the QuantificationAliquot Boolean is False or Null, set this to Null. *)
					MatchQ[preResolvedQuantificationAliquotBool, False|Null], Null,
					(* Otherwise, set this Automatic and let QuantifyCells handle it. *)
					True, Automatic
				];

				(* Gather MapThread results *)
				{
					(* Options *)
					(*1*)resolvedCellType,
					(*2*)resolvedCultureAdhesion,
					(*3*)resolvedTemperature,
					(*4*)resolvedCarbonDioxidePercentage,
					(*5*)resolvedRelativeHumidity,
					(*6*)resolvedShaking,
					(*7*)resolvedShakingRate,
					(*8*)semiResolvedShakingRadius,
					(*9*)resolvedSamplesOutStorageCondition,
					(*10*)resolvedIncubationCondition,
					(*11*)cellTypeFromSample,
					(*12*)cultureAdhesionFromSample,
					(*13*)resolvedMinQuantificationTarget,
					(*14*)resolvedQuantificationTolerance,
					(*15*)semiResolvedQuantificationAliquotContainer,
					(*16*)semiResolvedQuantificationAliquotVolume,
					(*17*)semiResolvedQuantificationBlank,
					(*18*)semiResolvedQuantificationWavelength,
					(*19*)semiResolvedQuantificationStandardCurve,
					(* Errors *)
					(*20*)conflictingShakingConditionsError,
					(*21*)conflictingCellTypeError,
					(*22*)conflictingCultureAdhesionError,
					(*23*)invalidIncubationConditionError,
					(*24*)conflictingCellTypeAdhesionError,
					(*25*)unsupportedCellCultureTypeError,
					(*26*)conflictingCellTypeWithIncubatorError,
					(*27*)conflictingCultureAdhesionWithContainerError,
					(*28*)conflictingCellTypeWithStorageConditionError,
					(*29*)conflictingCultureAdhesionWithStorageConditionWarning,
					(* Warnings *)
					(*30*)cellTypeNotSpecifiedWarning,
					(*31*)cultureAdhesionNotSpecifiedWarning,
					(*32*)customIncubationConditionNotSpecifiedWarning,
					(*33*)minTargetNoneWarningBool,
					(*34*)unspecifiedOptions
				}
			]
		],
		{mySamples, mapThreadFriendlyOptions, mainCellIdentityModels}
	]];

	(* Resolve the FailureResponse. *)
	{resolvedFailureResponse, discardUponFailureWarningBool} = Which[
		(* If the user specified the option, use their specification. *)
		MatchQ[Lookup[myOptions, FailureResponse], Except[Automatic]], {Lookup[myOptions, FailureResponse], False},
		(* If all of the MinQuantificationTargets are Null or None, set this to Null. *)
		MatchQ[minQuantificationTargets, {Alternatives[Null, None]..}], {Null, False},
		(* Otherwise, set this to Discard and warn that all of the samples will be discarded in the failure scenario. *)
		True, {Discard, True}
	];

	(* To avoid mapping IncubateCellsDevices, once all other options are resolved in the MapThread above, pass the all the resolved options and the cache
		to IncubateCellsDevices (using sample's containers as inputs) *)

	(* Stash the container models to use as input. In case the sample does not have container model, just use a default plate model so that we have some incubator to proceed *)
	sampleContainerModels = Lookup[sampleContainerModelPackets, Object, Null] /. Null -> Model[Container,Plate,"id:O81aEBZjRXvx"] (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *);

	(* Call IncubateCellsDevices to find all compatible incubators. If a list other than {} is returned, check the mode and return one valid instrument model*)
	possibleIncubators = IncubateCellsDevices[
		sampleContainerModels,
		CellType -> cellTypes,
		CultureAdhesion -> cultureAdhesions,
		Temperature -> temperatures,
		CarbonDioxide -> carbonDioxidePercentages /. Ambient -> Null,
		RelativeHumidity -> relativeHumidities /. Ambient -> Null,
		Shake -> shaking,
		ShakingRate -> shakingRates,
		ShakingRadius -> semiResolvedShakingRadii,
		Preparation -> resolvedPreparation,
		Cache -> cacheBall,
		Simulation -> simulation
	];
	possibleIncubatorPackets = Map[
		fetchPacketFromFastAssoc[#, fastAssoc]&,
		possibleIncubators,
		{2}
	];

	(* Resolve the incubator based on the information we had above from IncubateCellsDevices and the MapThread *)
	rawIncubators = MapThread[
		Function[{potentialIncubatorPacketsPerSample, desiredIncubator, resolvedCondition},
			Which[
				(* If user specified, just go with that *)
				MatchQ[desiredIncubator, ObjectP[{Model[Instrument, Incubator], Object[Instrument, Incubator]}]], desiredIncubator,
				(* If potential incubators is {}, then we're just picking Null. The final returned value will be replaced to a real model below, and an error will be thrown *)
				MatchQ[potentialIncubatorPacketsPerSample, {}], Null,
				(* If we're dealing with Robotic and on the bioSTAR, pick a robotic NonMicrobial incubator, pick the one that matches the desired work cell *)
				(* doing this <|Object -> Null|> trick because obviously we can't do Lookup[Null, Object] and we're dealing with packets.  I know it's kind of dumb *)
				MatchQ[resolvedPreparation, Robotic] && MatchQ[resolvedWorkCell, bioSTAR],
					Lookup[
						FirstCase[potentialIncubatorPacketsPerSample, KeyValuePattern[{Mode -> Robotic, CellTypes -> {NonMicrobialCellTypeP..}}], <|Object -> Null|>],
						Object
					],
				(* If we're dealing with Robotic and on the microbioSTAR, pick a robotic NonMicrobial incubator, pick the one that matches the desired work cell *)
				MatchQ[resolvedPreparation, Robotic] && MatchQ[resolvedWorkCell, microbioSTAR],
					Lookup[
						FirstCase[potentialIncubatorPacketsPerSample, KeyValuePattern[{Mode -> Robotic, CellTypes -> {MicrobialCellTypeP..}}], <|Object -> Null|>],
						Object
					],
				(* If we have a Custom incubation condition, we need to pick an incubator that we can use *)
				(* to do this, pick the first potential incubator that is a custom incubator *)
				MatchQ[resolvedCondition, Custom],
					SelectFirst[Lookup[potentialIncubatorPacketsPerSample, Object], MemberQ[customIncubators, #]&, Null],
				(* If we can avoid picking a custom incubator here, let's do it *)
				True,
					SelectFirst[
						Lookup[potentialIncubatorPacketsPerSample, Object],
						Not[MemberQ[customIncubators, #]]&,
						(* if we can't find any non-custom incubators, just pick whatever we can find*)
						FirstOrDefault[Lookup[potentialIncubatorPacketsPerSample, Object]]
					]

			]
		],
		{possibleIncubatorPackets, Lookup[mapThreadFriendlyOptions, Incubator], incubationCondition}
	];
	(* If any incubator got resolved, use that as the default for Null cases. Otherwise just use a custom incubator *)
	defaultIncubatorForNull = FirstOrDefault[
		Cases[DeleteCases[rawIncubators, Null], ObjectP[]],
		Model[Instrument, Incubator, "id:AEqRl954GG0l"](*"Multitron Pro with 25mm Orbit"*)
	];

	(* Make a list of boolean to keep track whether an incubator was raw-resolved to Null. Because Incubator option is AllowNull -> False, we should never return Null, so we need to replace with a real model, but need to keep track so that in downstream error checking, we do not further error out because of the incubator model we picked. *)
	{incubators, noResolvedIncubatorBools} = Transpose@Map[
		Function[rawIncubator,
			If[NullQ[rawIncubator],
				{defaultIncubatorForNull, True},
				{rawIncubator, False}
			]
		],
		rawIncubators
	];

	(* Finally resolve the ShakingRadius now that we know the incubator we're using  *)
	resolvedShakingRadiiPreRounding = MapThread[
		Function[{incubator, shakingRadius},
			If[MatchQ[shakingRadius, Automatic],
				fastAssocLookup[fastAssoc, incubator, ShakingRadius],
				shakingRadius
			]
		],
		{incubators, semiResolvedShakingRadii}
	];

	(* Need to select the shaking radius closest to the values here *)
	(* this is admittedly super jank, but it's because the ShakingRadius is stored as a float inside the incubator, but ShakingRadius must match CellIncubatorShakingRadiusP exactly *)
	resolvedShakingRadii = Map[
		Function[{radius},
			Which[
				NullQ[radius], Null,
				MatchQ[radius, CellIncubatorShakingRadiusP], radius,
				True, FirstOrDefault[MinimalBy[List @@ CellIncubatorShakingRadiusP, Abs[# - radius]&, 1]]
			]
		],
		resolvedShakingRadiiPreRounding
	];

	(* Get the resolved Email option; for this experiment, the default is True *)
	email = Which[
		MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[parentProtocol], True,
		MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[parentProtocol, ObjectP[ProtocolTypes[]]], False,
		True, Lookup[myOptions, Email]
	];

	(* Do as much quantification-related error checking as possible before we call any Quantification experiments so that we know whether to run them. *)
	(* This is to avoid long wait times just to return errors. Any error checks involving options that are semi-resolved in the Incubate resolver and then *)
	(* fully resolved by the Quantify child function have to wait until after we run the child function's resolver. *)

	(* Check that the QuantificationMethod and QuantificationInstrument, if specified, are compatible and/or resolvable. *)
	conflictingQuantificationMethodAndInstrumentError = If[
		Or[
			And[
				MatchQ[resolvedQuantificationMethod, Absorbance],
				MatchQ[semiResolvedQuantificationInstrument, Except[Automatic|ObjectP[{Object[Instrument, PlateReader], Model[Instrument, PlateReader], Object[Instrument, Spectrophotometer], Model[Instrument, Spectrophotometer]}]]]
			],
			And[
				MatchQ[resolvedQuantificationMethod, Nephelometry],
				MatchQ[semiResolvedQuantificationInstrument, Except[Automatic|ObjectP[{Object[Instrument, Nephelometer], Model[Instrument, Nephelometer]}]]]
			],
			And[
				MatchQ[resolvedQuantificationMethod, ColonyCount],
				MatchQ[semiResolvedQuantificationInstrument, Except[Automatic|ObjectP[{Object[Instrument, ColonyHandler], Model[Instrument, ColonyHandler]}]]]
			]
		],
		{resolvedQuantificationMethod, semiResolvedQuantificationInstrument},
		{}
	];

	conflictingQuantificationMethodAndInstrumentOptions = If[MatchQ[Length[conflictingQuantificationMethodAndInstrumentError], GreaterP[0]] && messages,
		(
			Message[
				Error::ConflictingQuantificationMethodAndInstrument,
				ObjectToString[resolvedQuantificationMethod, Cache -> cacheBall],
				ObjectToString[semiResolvedQuantificationInstrument, Cache -> cacheBall]
			];
			{QuantificationMethod, QuantificationInstrument}
		),
		{}
	];

	conflictingQuantificationMethodAndInstrumentOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = If[MatchQ[conflictingQuantificationMethodAndInstrumentError, {}], {}, mySamples];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The QuantificationInstrument and QuantificationMethod for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " are compatible with one another:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The QuantificationInstrument and QuantificationMethod for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " are compatible with one another:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* Test for quantification options which are in direct conflict with one another. *)
	conflictingQuantificationOptionsCases = Join @@ MapThread[
		Function[
			{
				sample,
				target,
				tolerance,
				index
			},
			{
				If[MatchQ[target, Except[Null|None]] && MatchQ[tolerance, Null],
					{sample, MinQuantificationTarget, target, QuantificationTolerance, tolerance, index},
					Nothing
				],
				If[MatchQ[target, (Null|None)] && MatchQ[tolerance, Except[Null]],
					{sample, MinQuantificationTarget, target, QuantificationTolerance, tolerance, index},
					Nothing
				],
				If[MatchQ[target, Except[Null|None]] && MatchQ[resolvedFailureResponse, Null],
					{sample, MinQuantificationTarget, target, FailureResponse, resolvedFailureResponse, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			minQuantificationTargets,
			quantificationTolerances,
			Range[Length[mySamples]]
		}
	];

	conflictingQuantificationOptions = If[MatchQ[Length[conflictingQuantificationOptionsCases], GreaterP[0]] && messages,
		(
			Message[
				Error::ConflictingQuantificationOptions,
				ObjectToString[conflictingQuantificationOptionsCases[[All,1]], Cache -> cacheBall],
				ObjectToString[conflictingQuantificationOptionsCases[[All,2]], Cache -> cacheBall],
				ObjectToString[conflictingQuantificationOptionsCases[[All,3]], Cache -> cacheBall],
				ObjectToString[conflictingQuantificationOptionsCases[[All,4]], Cache -> cacheBall],
				ObjectToString[conflictingQuantificationOptionsCases[[All,5]], Cache -> cacheBall],
				conflictingQuantificationOptionsCases[[All, 6]]
			];
			DeleteDuplicates @ Flatten[{conflictingQuantificationOptionsCases[[All, {2, 4}]]}]
		),
		{}
	];

	conflictingQuantificationOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = If[MatchQ[conflictingQuantificationOptionsCases, {}], {}, mySamples];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The FailureResponse, QuantificationTarget and QuantificationTolerance options for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " are compatible with one another:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The FailureResponse, QuantificationTarget and QuantificationTolerance options for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " are compatible with one another:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Test for quantification aliquot options which are in direct conflict with one another. *)
	conflictingQuantificationAliquotOptionsCases = Join @@ MapThread[
		Function[
			{
				sample,
				aliquotContainer,
				aliquotVolume,
				index
			},
			{
				If[TrueQ[preResolvedQuantificationAliquotBool] && MatchQ[aliquotContainer, Null],
					{sample, QuantificationAliquotContainer, aliquotContainer, index},
					Nothing
				],
				If[TrueQ[preResolvedQuantificationAliquotBool] && MatchQ[aliquotVolume, Null],
					{sample, QuantificationAliquotVolume, aliquotVolume, index},
					Nothing
				],
				If[!MatchQ[preResolvedQuantificationAliquotBool, True|Automatic] && MatchQ[aliquotContainer, Except[Null]],
					{sample, QuantificationAliquotContainer, aliquotContainer, index},
					Nothing
				],
				If[!MatchQ[preResolvedQuantificationAliquotBool, True|Automatic] && MatchQ[aliquotVolume, Except[Null]],
					{sample, QuantificationAliquotVolume, aliquotVolume, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			quantificationAliquotContainers,
			quantificationAliquotVolumes,
			Range[Length[mySamples]]
		}
	];

	conflictingQuantificationAliquotOptions = If[MatchQ[Length[conflictingQuantificationAliquotOptionsCases], GreaterP[0]] && messages,
		(
			Message[
				Error::ConflictingQuantificationAliquotOptions,
				ObjectToString[conflictingQuantificationAliquotOptionsCases[[All,1]], Cache -> cacheBall],
				ObjectToString[conflictingQuantificationAliquotOptionsCases[[All,2]], Cache -> cacheBall],
				ObjectToString[conflictingQuantificationAliquotOptionsCases[[All,3]], Cache -> cacheBall],
				ObjectToString[preResolvedQuantificationAliquotBool, Cache -> cacheBall],
				conflictingQuantificationAliquotOptionsCases[[All, 4]]
			];
			Append[conflictingQuantificationAliquotOptionsCases[[All,2]], QuantificationAliquot]
		),
		{}
	];

	conflictingQuantificationAliquotOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingQuantificationAliquotOptionsCases[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The QuantificationAliquotVolume and QuantificationAliquotContainer options for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " are compatible with the QuantificationAliquot option:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The QuantificationAliquotVolume and QuantificationAliquotContainer options for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " are compatible with the QuantificationAliquot option:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that the resolvedQuantificationInterval is at least 1 Hour and no more than the maximum Time if we're quantifying. *)
	unsuitableQuantificationIntervalCases = If[
		And[
			!MatchQ[resolvedQuantificationInterval, RangeP[1 Hour, resolvedTime]],
			MatchQ[resolvedIncubationStrategy, QuantificationTarget]
		],
		{resolvedQuantificationInterval, resolvedTime},
		Nothing
	];

	unsuitableQuantificationIntervalOptions = If[MatchQ[Length[unsuitableQuantificationIntervalCases], GreaterP[0]] && messages,
		(
			Message[
				Error::UnsuitableQuantificationInterval,
				ObjectToString[unsuitableQuantificationIntervalCases[[1]], Cache -> cacheBall],
				ObjectToString[unsuitableQuantificationIntervalCases[[2]], Cache -> cacheBall]
			];
			{Time, QuantificationInterval}
		),
		{}
	];

	unsuitableQuantificationIntervalTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = If[MatchQ[unsuitableQuantificationIntervalCases, Nothing], {}, mySamples];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The QuantificationInterval for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " is no shorter than 1 Hour and no longer than the Time:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The QuantificationInterval for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " is no shorter than 1 Hour and no longer than the Time:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check to see if the user gave us a units mismatch for MinQuantificationTarget and QuantificationTolerance. *)
	(* Don't throw the error if either option is Null|None, or if the QuantificationTolerance is given as a Percent. *)
	quantificationTargetUnitsMismatchCases = MapThread[
		Function[
			{sample, target, tolerance, index},
			If[
				And[
					MatchQ[target, Except[Null|None]],
					MatchQ[tolerance, Except[Null]],
					!MatchQ[Units[target], Units[tolerance]],
					!MatchQ[Units[tolerance], Percent]
				],
				{sample, target, tolerance, index},
				Nothing
			]
		],
		{mySamples, minQuantificationTargets, quantificationTolerances, Range[Length[mySamples]]}
	];

	quantificationTargetUnitsMismatchOptions = If[MatchQ[Length[quantificationTargetUnitsMismatchCases], GreaterP[0]] && messages,
		(
			Message[
				Error::QuantificationTargetUnitsMismatch,
				ObjectToString[quantificationTargetUnitsMismatchCases[[All,1]], Cache -> cacheBall],
				ObjectToString[quantificationTargetUnitsMismatchCases[[All,2]], Cache -> cacheBall],
				ObjectToString[quantificationTargetUnitsMismatchCases[[All,3]], Cache -> cacheBall],
				quantificationTargetUnitsMismatchCases[[All, 4]]
			];
			{MinQuantificationTarget, QuantificationTolerance}
		),
		{}
	];

	quantificationTargetUnitsMismatchTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = quantificationTargetUnitsMismatchCases[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The QuantificationTolerance for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " must be given as a Percent or in the same units as the MinQuantificationTarget is the MinQuantificationTarget is a quantity:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The QuantificationTolerance for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " must be given as a Percent or in the same units as the MinQuantificationTarget is the MinQuantificationTarget is a quantity:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check whether some options that aren't relevant to QuantifyColonies have non-Null values. *)
	extraneousQuantifyColoniesOptionsCases = If[MatchQ[resolvedQuantificationMethod, ColonyCount],
		Join @@ MapThread[
			Function[
				{
					sample,
					aliquotContainer,
					aliquotVolume,
					blank,
					wavelength,
					curve,
					index
				},
				{
					If[!MatchQ[preResolvedQuantificationAliquotBool, (Null|False|Automatic)],
						{sample, QuantificationAliquot, preResolvedQuantificationAliquotBool, index},
						Nothing
					],
					If[!MatchQ[aliquotContainer, (Null|Automatic)],
						{sample, QuantificationAliquotContainer, aliquotContainer, index},
						Nothing
					],
					If[!MatchQ[aliquotVolume, (Null|Automatic)],
						{sample, QuantificationAliquotVolume, aliquotVolume, index},
						Nothing
					],
					If[!MatchQ[blank, (Null|False|Automatic)],
						{sample, QuantificationBlank, blank, index},
						Nothing
					],
					If[!MatchQ[wavelength, (Null|Automatic)],
						{sample, QuantificationWavelength, wavelength, index},
						Nothing
					],
					If[!MatchQ[curve, (Null|Automatic)],
						{sample, QuantificationStandardCurve, curve, index},
						Nothing
					]
				}
			],
			{
				mySamples,
				quantificationAliquotContainers,
				quantificationAliquotVolumes,
				quantificationBlanks,
				quantificationWavelengths,
				quantificationStandardCurves,
				Range[Length[mySamples]]
			}
		],
		{}
	];

	extraneousQuantifyColoniesOptions = If[MatchQ[Length[extraneousQuantifyColoniesOptionsCases], GreaterP[0]] && messages,
		(
			Message[
				Error::ExtraneousQuantifyColoniesOptions,
				ObjectToString[extraneousQuantifyColoniesOptionsCases[[All,1]], Cache -> cacheBall],
				ObjectToString[extraneousQuantifyColoniesOptionsCases[[All,2]], Cache -> cacheBall],
				ObjectToString[extraneousQuantifyColoniesOptionsCases[[All,3]], Cache -> cacheBall],
				extraneousQuantifyColoniesOptionsCases[[All, 4]]
			];
			DeleteDuplicates @ Flatten[{QuantificationMethod, extraneousQuantifyColoniesOptionsCases[[All,2]]}]
		),
		{}
	];

	extraneousQuantifyColoniesOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = extraneousQuantifyColoniesOptionsCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["None of the options QuantificationAliquot, QuantificationAliquotContainer, QuantificationAliquotVolume, QuantificationBlankMeasurement, QuantificationBlank, QuantificationWavelength, or QuantificationStandardCurve are specified (or True) for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if the QuantificationMethod is ColonyCount:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["None of the options QuantificationAliquot, QuantificationAliquotContainer, QuantificationAliquotVolume, QuantificationBlankMeasurement, QuantificationBlank, QuantificationWavelength, or QuantificationStandardCurve are specified (or True) for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if the QuantificationMethod is ColonyCount:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that the FailureResponse is not Incubate if we have a Custom incubation condition at any index, and that it is not Freeze if *)
	(* splitting the total volume into replicates would require more cryovials than a single Mr Frosty rack can hold. *)
	failureResponseNotSupportedCases = Module[
		{
			nonSuspensionSamplesToFreeze, nonSuspensionCultureAdhesions, nonSuspensionIndices, replicatesRequired,
			largestSampleVolume, cryoVialModel, frostyRackModel, frostyRackNumPositions, errorString
		},

		(* If applicable, find any samples which do not have a CultureAdhesion of Suspension. *)
		{nonSuspensionSamplesToFreeze, nonSuspensionCultureAdhesions, nonSuspensionIndices} = If[MatchQ[resolvedFailureResponse, Freeze] && MemberQ[cultureAdhesions, Except[Suspension]],
			Transpose @ MapThread[
				Function[
					{sample, cultureAdhesion, index},
					If[!MatchQ[cultureAdhesion, Suspension],
						{sample, cultureAdhesion, index},
						Nothing
					]
				],
				{mySamples, cultureAdhesions, Range[Length[mySamples]]}
			],
			{Null, Null, Null}
		];

		(* If applicable, determine the volumes and hardware required for a Freeze failure response. *)
		{replicatesRequired, largestSampleVolume, cryoVialModel, frostyRackModel, frostyRackNumPositions} = If[!MatchQ[resolvedFailureResponse, Freeze] || MemberQ[cultureAdhesions, Except[Suspension]],
			ConstantArray[Null, 5],
			Module[
				{inputSampleVolumes, failureSampleVolumes, largestSampleVolumeUponFailure, cryogenicSampleContainer, mrFrostyRack, rackPositions, numberOfCryovialsNeeded},

				(* Get the current volumes of all the input samples. *)
				inputSampleVolumes = ToList[Lookup[samplePackets, Volume]];

				(* Get the expected sample volumes upon failure, i.e. once we have already done the maximum number of quantifications. *)
				failureSampleVolumes = MapThread[
					Function[
						{inputVolume, aliquotVolume},
						If[!GreaterQ[aliquotVolume, 0 Milliliter] || TrueQ[resolvedRecoupSampleBool],
							(* If there is NOT a known aliquot volume for this sample (or if we are recouping the sample after aliquoting), use the input volume. *)
							(* If we do end up aliquoting, the sample volume will decrease, which will not hurt us here. *)
							inputVolume,
							(* If we're aliquoting and not recouping the aliquoted volume, assume that the volume upon failure is the input volume minus the aliquot volume. *)
							(* We only subtract the aliquot volume once (even though we could be aliquoting multiple times before failure) because there is a scenario in *)
							(* which we go into troubleshooting while the sample is in the incubator and exceed the total Time before doing the max number of quantifications. *)
							(* In other words, we're only guaranteed to aliquot one time, and it is safer to overestimate the sample volume here than to underestimate it. *)
							inputVolume - aliquotVolume
						]
					],
					{inputSampleVolumes, quantificationAliquotVolumes}
				];

				(* Get the largest sample volumes upon failure. *)
				largestSampleVolumeUponFailure = Max[failureSampleVolumes];

				(* Determine whether to use 2mL or 5mL vials and the corresponding Mr Frosty rack based on the largest sample volume. *)
				{cryogenicSampleContainer, mrFrostyRack, rackPositions} = If[MatchQ[largestSampleVolumeUponFailure, LessEqualP[1.2 Milliliter]],
					(* Model[Container, Vessel, "2mL Cryogenic Vial"] and Model[Container, Rack, InsulatedCooler, "2mL Mr. Frosty Rack"] *)
					{Model[Container, Vessel, "id:vXl9j5qEnnOB"], Model[Container, Rack, InsulatedCooler, "id:7X104vnMk93w"], 18},
					(* Model[Container, Vessel, "5mL Cryogenic Vial"] and Model[Container, Rack, InsulatedCooler, "5mL Mr. Frosty Rack"] *)
					{Model[Container, Vessel, "id:o1k9jAG1Nl57"], Model[Container, Rack, InsulatedCooler, "5mL Mr. Frosty Rack"], 12}
				];

				(* Determine the number of cryo vials we need based on the largest volume. *)
				numberOfCryovialsNeeded = If[MatchQ[cryogenicSampleContainer, ObjectP[Model[Container, Vessel, "id:vXl9j5qEnnOB"]]],
					Ceiling[largestSampleVolumeUponFailure / (1.2 Milliliter)],
					Ceiling[largestSampleVolumeUponFailure / (3 Milliliter)]
				];

				(* Return all of the parameters we need. *)
				{numberOfCryovialsNeeded, largestSampleVolumeUponFailure, cryogenicSampleContainer, mrFrostyRack, rackPositions}
			]
		];

		(* Generate the error string. *)
		errorString = Which[
			(* We can't use an Incubate FailureResponse for Custom incubation. *)
			MatchQ[resolvedFailureResponse, Incubate] && MemberQ[incubationCondition, Custom],
				"The FailureResponse is Incubate, and this is not available when a Custom IncubationCondition is specified for any sample(s).",
			(* We can't use Freeze if the CultureAdhesion is not Suspension for any sample. *)
			MemberQ[nonSuspensionSamplesToFreeze, ObjectP[]],
				"The FailureResponse is Freeze, and the samples " <> ObjectToString[nonSuspensionSamplesToFreeze, Cache -> cacheBall] <> " at indices " <> ToString[nonSuspensionIndices] <> " have CultureAdhesion set to " <> ObjectToString[nonSuspensionCultureAdhesions, Cache -> cacheBall] <> ". The Freeze FailureResponse is only compatible with Suspension samples.",
			(* We don't allow Freeze if the experiment demands more than 1 Mr Frosty Rack. *)
			!NullQ[replicatesRequired] && GreaterQ[replicatesRequired, frostyRackNumPositions],
				"The FailureResponse is Freeze and the largest input sample has a volume of " <> ToString[largestSampleVolume] <> ". In the event of failure, the input samples will be transferred into " <> ToString[replicatesRequired] <> " cryogenic vials of " <> ObjectToString[cryoVialModel, Cache -> cacheBall] <> " to accommodate the sample volume and added cryoprotectant volume. This would require the use of more than one insulated cooler rack of " <> ObjectToString[frostyRackModel, Cache -> cacheBall] <> ", which has " <> ToString[frostyRackNumPositions] <> " positions. Due to equipment constraints, the Freeze FailureResponse is only available for protocols which require no more than one full insulated cooler rack in the event of failure.",
			(* Otherwise, everything is cool. *)
			True, Null
		];

		(* Return the affected samples and error string. *)
		Which[
			(* If there are nonSuspensionSamplesToFreeze, these are the affected samples. *)
			MemberQ[nonSuspensionSamplesToFreeze, ObjectP[]], {nonSuspensionSamplesToFreeze, errorString},
			(* If there is an error string, all samples are affected. *)
			StringQ[errorString], {mySamples, errorString},
			(* Otherwise, return an empty list so we don't throw the error. *)
			True, {}
		]
	];

	failureResponseNotSupportedOptions = If[MatchQ[Length[failureResponseNotSupportedCases], GreaterP[0]] && messages,
		(
			Message[Error::FailureResponseNotSupported, failureResponseNotSupportedCases[[2]]];
			{FailureResponse}
		),
		{}
	];

	failureResponseNotSupportedTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = If[SameQ[failureResponseNotSupportedCases, {}], {}, failureResponseNotSupportedCases[[1]]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The FailureResponse for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " is not Incubate if the IncubationCondition is Custom and is not Freeze if the samples are not Suspension samples, or if the Freeze response requires more than one insulated cooler rack:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The FailureResponse for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " is not Incubate if the IncubationCondition is Custom and is not Freeze if the samples are not Suspension samples, or if the Freeze response requires more than one insulated cooler rack:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that QuantificationRecoupSample is not True while QuantificationAliquot is False. *)
	aliquotRecoupMismatchQ = And[
		TrueQ[Lookup[myOptions, QuantificationRecoupSample]],
		!TrueQ[preResolvedQuantificationAliquotBool]
	];

	aliquotRecoupMismatchedOptions = If[aliquotRecoupMismatchQ && messages,
		(
			Message[Error::AliquotRecoupMismatch];
			{QuantificationRecoupSample, QuantificationAliquot}
		),
		{}
	];

	aliquotRecoupMismatchTest = If[gatherTests,
		Module[{failingTest, passingTest},

			failingTest = If[!aliquotRecoupMismatchQ,
				Nothing,
				Test["QuantificationRecoupSample is not True while QuantificationAliquot is False:", True, False]
			];

			passingTest = If[aliquotRecoupMismatchQ,
				Nothing,
				Test["QuantificationRecoupSample is not True while QuantificationAliquot is False:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Gather all of the error checks and flatten them out. We're doing this to determine whether to actually run the quantify child functions. *)
	errorChecksBeforeQuantification = Flatten @ {
		conflictingQuantificationMethodAndInstrumentError,
    conflictingQuantificationOptionsCases,
		conflictingQuantificationAliquotOptionsCases,
		unsuitableQuantificationIntervalCases,
		quantificationTargetUnitsMismatchCases,
		extraneousQuantifyColoniesOptionsCases,
		failureResponseNotSupportedCases,
		aliquotRecoupMismatchedOptions
	};

	(* Run the Quantify child functions, if applicable. *)

	(* If we're quantifying, run the resolvers for QuantifyColonies or QuantifyCells as needed. *)
	(* If we're performing a simulation, we also get a protocol packet and a simulation. *)
	{quantificationProtocolPacket, quantificationSimulation, resolvedQuantificationOptions} = Which[
		(* If any of our error checks to this point have been tripped, skip this. *)
		MatchQ[Length[errorChecksBeforeQuantification], GreaterP[0]], {{}, {}, {}},
		(* If there are any Nulls in the singleton options required for quantification, skip this and move onto error checks. *)
		MemberQ[{resolvedQuantificationInterval, resolvedQuantificationMethod, semiResolvedQuantificationInstrument, resolvedQuantificationBlankMeasurementBool}, Null], {{}, {}, {}},
		(* If we're counting colonies, run QuantifyColonies. *)
		MatchQ[resolvedQuantificationMethod, ColonyCount],
			Module[
				{quantifyColoniesOutputOption, quantifyColoniesResolverOnlyOption, quantifyColoniesOptions, quantifyColoniesOptionNamesMap},

				(* If we are simulating, we need to include this in our output. If not, we only want the options. *)
				(* For the same reasons, we run OptionsResolverOnly if we don't need to simulate a Quantify function. *)
				{quantifyColoniesOutputOption, quantifyColoniesResolverOnlyOption} = If[performSimulationQ,
					{Output -> {Result, Simulation, Options}, OptionsResolverOnly -> False},
					{Output -> Options, OptionsResolverOnly -> True}
				];

				(* Set up our option specs for QuantifyColonies. *)
				quantifyColoniesOptions = {
					QuantificationInstrument -> semiResolvedQuantificationInstrument,
					quantifyColoniesOutputOption,
					quantifyColoniesResolverOnlyOption,
					Upload -> False
				};

        (* Map from the QuantifyCells option namespace to the namespace for IncubateCells. *)
				quantifyColoniesOptionNamesMap = {
					QuantificationInstrument -> ImagingInstrument
				};

				(* Call ModifyFunctionMessages to resolve the options and modify any messages. *)
				If[performSimulationQ,
					(* If we're simulating, we will obtain the protocol packet, simulation, and the options. *)
					Quiet[
						ModifyFunctionMessages[
							ExperimentQuantifyColonies,
							{mySamples},
							"",
							quantifyColoniesOptionNamesMap,
							quantifyColoniesOptions,
							Cache -> cacheBall,
							Simulation -> simulation,
							Output -> Result
						],
						{Download::MissingCacheField}
					],
					(* If we're not simulating, we only need the options but will assign the protocol packet and simulation variables as empty lists. *)
					{
						{},
						{},
						Quiet[
							ModifyFunctionMessages[
								ExperimentQuantifyColonies,
								{mySamples},
								"",
								quantifyColoniesOptionNamesMap,
								quantifyColoniesOptions,
								Cache -> cacheBall,
								Simulation -> simulation,
								Output -> Result
							],
							{Download::MissingCacheField}
						]
					}
				]

			],

		(* In any other case, we run QuantifyCells. *)
		True,
			Module[
				{
					aliquotOption, aliquotContainerOption, aliquotVolumeOption, blankBoolOption, blankOption, standardCurveOption,
					quantifyCellsOutputOption, quantifyCellsResolverOnlyOption, quantificationUnits, quantifyCellsOptions, quantifyCellsOptionNamesMap
				},

				(* The names of certain options in QuantifyCells depend upon the method, so use the correct ones here. *)
				{aliquotOption, aliquotContainerOption, aliquotVolumeOption, blankBoolOption, blankOption, standardCurveOption} = If[
					MatchQ[resolvedQuantificationMethod, Absorbance],
					{AbsorbanceAliquot, AbsorbanceAliquotContainer, AbsorbanceAliquotAmount, AbsorbanceBlankMeasurement, AbsorbanceBlank, AbsorbanceStandardCurve},
					{NephelometryAliquot, NephelometryAliquotContainer, NephelometryAliquotAmount, NephelometryBlankMeasurement, NephelometryBlank, NephelometryStandardCurve}
				];

				(* Get the quantification units from the MinQuantificationTargets. *)
				(* Convert any cell concentrations to just the units, and any Nones to Automatics so that ExperimentQuantifyCells can resolve them appropriately. *)
				quantificationUnits = If[MatchQ[Units[#], CellConcentrationUnitsP],
					(* Convert it to string form due to widget change in ExperimentQuantifyCells' QuantificationUnit option *)
					Units[#] /. $CellQuantificationUnitToStringLookup,
					Automatic
				] & /@ minQuantificationTargets;

				(* If we are simulating, we need to include this in our output. If not, we only want the options. *)
				(* For the same reasons, we run OptionsResolverOnly if we don't need to simulate a Quantify function. *)
				{quantifyCellsOutputOption, quantifyCellsResolverOnlyOption} = If[performSimulationQ,
					{Output -> {Result, Simulation, Options}, OptionsResolverOnly -> False},
					{Output -> Options, OptionsResolverOnly -> True}
				];

				(* Set up our option specs for QuantifyCells. *)
				quantifyCellsOptions = {
					SampleLabel -> resolvedSampleLabels,
					SampleContainerLabel -> resolvedSampleContainerLabels,
					QuantificationMethod -> resolvedQuantificationMethod,
					QuantificationInstrument -> semiResolvedQuantificationInstrument,
					QuantificationWavelength -> quantificationWavelengths,
					QuantificationUnit -> quantificationUnits,
					QuantificationAliquot -> preResolvedQuantificationAliquotBool,
					QuantificationBlankMeasurement -> resolvedQuantificationBlankMeasurementBool,
					QuantificationBlank -> quantificationBlanks,
					QuantificationAliquotContainer -> quantificationAliquotContainers,
					QuantificationAliquotVolume -> quantificationAliquotVolumes,
					QuantificationStandardCurve -> quantificationStandardCurves,
					RecoupSample -> resolvedRecoupSampleBool,
					Preparation -> resolvedPreparation,
					quantifyCellsOutputOption,
					quantifyCellsResolverOnlyOption,
					Upload -> False
				};

				(* Map from the QuantifyCells option namespace to the namespace for IncubateCells. *)
				quantifyCellsOptionNamesMap = {
					QuantificationMethod -> Methods,
					QuantificationInstrument -> Instruments,
					QuantificationWavelength -> Wavelength,
					QuantificationAliquot -> aliquotOption,
					QuantificationAliquotContainer -> aliquotContainerOption,
					QuantificationAliquotVolume -> aliquotVolumeOption,
					QuantificationBlankMeasurement -> blankBoolOption,
					QuantificationBlank -> blankOption,
					QuantificationStandardCurve -> standardCurveOption
				};

				(* Call ModifyFunctionMessages to resolve the options and modify any messages. *)
				If[performSimulationQ,
					(* If we're simulating, we will obtain the protocol packet, simulation, and the options. *)
					Quiet[
						ModifyFunctionMessages[
							ExperimentQuantifyCells,
							{mySamples},
							"",
							quantifyCellsOptionNamesMap,
							quantifyCellsOptions,
							Cache -> cacheBall,
							Simulation -> simulation,
							Output -> Result
						],
						{Download::MissingCacheField, Warning::AliquotRequired}(* Quieting AliquotRequired because ExperimentIncubateCells does its own QuantificationAliquotRequired checking *)
					],
					(* If we're not simulating, we only need the options but will assign the protocol packet and simulation variables as empty lists. *)
					{
						{},
						{},
						Quiet[
							ModifyFunctionMessages[
								ExperimentQuantifyCells,
								{mySamples},
								"",
								quantifyCellsOptionNamesMap,
								quantifyCellsOptions,
								Cache -> cacheBall,
								Simulation -> simulation,
								Output -> Result
							],
							{Download::MissingCacheField, Warning::AliquotRequired}(* Quieting AliquotRequired because ExperimentIncubateCells does its own QuantificationAliquotRequired checking *)
						]
					}
				]

			]
	];

	(* If we ran QuantifyCells, we may have further resolved the options at some indices, in which case we pass these values into the resolved options below. *)
	{
		finalQuantificationInstrument,
		finalAliquotBools,
		finalAliquotVolumes,
		finalAliquotContainers,
		finalStandardCurves,
		finalBlanks,
		finalWavelengths
	} = If[
		(* If we ran QuantifyCells, replace all of the following options. *)
		And[
			MatchQ[Length[resolvedQuantificationOptions], GreaterP[0]],
			MatchQ[resolvedQuantificationMethod, (Absorbance|Nephelometry)]
		],
			Lookup[resolvedQuantificationOptions,
				{
					QuantificationInstrument,
					QuantificationAliquot,
					QuantificationAliquotVolume,
					QuantificationAliquotContainer,
					QuantificationStandardCurve,
					QuantificationBlank,
					QuantificationWavelength
				}
			],
		(* Otherwise we didn't run a quantify function, so keep all of this as is. *)
		{
			semiResolvedQuantificationInstrument,
			Null,
			quantificationAliquotVolumes,
			quantificationAliquotContainers,
			quantificationStandardCurves,
			quantificationBlanks,
			quantificationWavelengths
		}
	];

	(* Determine whether our aliquoting boolean resolved in an acceptable way. *)
	{resolvedAliquotBool, mixedAliquotingQ} = Which[
		(* If we ended up with a singleton True, False or Null, keep it and throw no messages. *)
		MatchQ[finalAliquotBools, True|False|Null], {finalAliquotBools, False},
		(* If we get a list of all True, all False, or all Null, set this to the appropriate symbol but no message is needed. *)
		MatchQ[finalAliquotBools, {True..}|{False..}|{Null..}], {finalAliquotBools[[1]], False},
		(* Otherwise, we have a mix of different aliquoting options. Default to True and flip the error switch. *)
		True, {True, True}
	];

	(* If we ran a simulation for a quantify function, update the current simulation. *)
	simulationWithQuantification = If[MatchQ[quantificationSimulation, SimulationP],
		UpdateSimulation[simulation, quantificationSimulation],
		simulation
	];

	(* Combine the resolved options together at this point; everything after is error checking, and for the warning below I need this for better error checking *)
	resolvedOptions = ReplaceRule[
		myOptions,
		Flatten[{
			SampleLabel -> resolvedSampleLabels,
			SampleContainerLabel -> resolvedSampleContainerLabels,
			Incubator -> incubators,
			CellType -> cellTypes,
			CultureAdhesion -> cultureAdhesions,
			Temperature -> temperatures,
			CarbonDioxide -> carbonDioxidePercentages /. Null -> Ambient,
			RelativeHumidity -> relativeHumidities /. Null -> Ambient,
			Time -> resolvedTime,
			Shake -> shaking,
			ShakingRate -> shakingRates,
			ShakingRadius -> resolvedShakingRadii,
			IncubationCondition -> incubationCondition,
			SamplesOutStorageCondition -> samplesOutStorageCondition,
			IncubationStrategy -> resolvedIncubationStrategy,
			QuantificationMethod -> resolvedQuantificationMethod,
			QuantificationInstrument -> finalQuantificationInstrument,
			QuantificationInterval -> resolvedQuantificationInterval,
			MinQuantificationTarget -> minQuantificationTargets,
			QuantificationTolerance -> quantificationTolerances,
			QuantificationAliquot -> resolvedAliquotBool,
			QuantificationAliquotVolume -> finalAliquotVolumes,
			QuantificationAliquotContainer -> Cases[Flatten[finalAliquotContainers], (ObjectP[]|Null)],
			QuantificationRecoupSample -> resolvedRecoupSampleBool,
			QuantificationBlankMeasurement -> resolvedQuantificationBlankMeasurementBool,
			QuantificationBlank -> finalBlanks,
			QuantificationWavelength -> finalWavelengths,
			QuantificationStandardCurve -> finalStandardCurves,
			FailureResponse -> resolvedFailureResponse,
			Email -> email,
			Confirm -> confirm,
			CanaryBranch -> canaryBranch,
			Template -> template,
			Preparation -> resolvedPreparation,
			WorkCell -> resolvedWorkCell,
			(* explicitly overriding these options to be {} and Null to make things more manageable to pass around and also more readable *)
			Cache -> {},
			Simulation -> Null,
			FastTrack -> fastTrack,
			Operator -> operator,
			ParentProtocol -> parentProtocol,
			Upload -> upload,
			Output -> outputOption
		}]
	];

	(* Doing this because it makes the warning check below easier *)
	resolvedMapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentIncubateCells, resolvedOptions];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Make rules converting containers to the samples inside them *)
	containersToSamples = Merge[
		MapThread[
			#1 -> #2&,
			{Lookup[sampleContainerPackets, Object, Null], Lookup[samplePackets, Object]}
		],
		Join
	];

	(* Make rules converting incubators to the containers *)
	(* delete duplicates though *)
	incubatorsToContainers = Merge[
		MapThread[
			#1 -> #2&,
			{rawIncubators, Lookup[sampleContainerPackets, Object, Null]}
		],
		DeleteDuplicates[Join[#]] &
	];

	(* Tally the footprints for each incubator *)
	incubatorFootprints = Merge[
		KeyValueMap[
			Function[{incubator, containers},
				incubator -> fastAssocLookup[fastAssoc, #, {Model, Footprint}]& /@ containers
			],
			incubatorsToContainers
		],
		(* the assumption here is that we have only one footprint trying to go into each incubator; I think this is a reasonable assumption*)
		(* if this is not true then let's change it *)
		First[Tally[#]] &
	];

	(* Determine if the total of a given type of footprint has been exceeded for each incubator *)
	(* here for each failure, we're going to have a list of length four, where the first value is the incubator, the second is the capacity number, the third is the footprint, and the foruth is the value we actually have *)
	incubatorsOverCapacityAmounts = KeyValueMap[
		Function[{incubator, footprintTally},
			Module[{incubatorModel, maxCapacityAllFootprints, footprintOverLimitQ, capacity},

				(* If we had an incubator object at this point, convert it to a model *)
				incubatorModel = If[MatchQ[incubator, ObjectP[Object[Instrument, Incubator]]],
					fastAssocLookup[fastAssoc, incubator, Model],
					incubator
				];

				(* Determine the max capacity for the whole incubator (i.e., all footprints) *)
				maxCapacityAllFootprints = Lookup[$CellIncubatorMaxCapacity, incubatorModel, <||>];

				(* For each footprint that we're putting in a given incubator, determine if we've gone over the limit *)
				(* if we don't have the limit, just assume we're fine *)
				capacity = Lookup[maxCapacityAllFootprints, footprintTally[[1]], Null];
				footprintOverLimitQ = Not[NullQ[capacity]] && capacity < footprintTally[[2]];

				If[footprintOverLimitQ,
					{
						incubator,
						capacity,
						footprintTally[[1]],
						footprintTally[[2]]
					},
					Nothing
				]
			]
		],
		incubatorFootprints
	];

	incubatorOverCapacityIncubators = incubatorsOverCapacityAmounts[[All, 1]];
	incubatorOverCapacityCapacities = incubatorsOverCapacityAmounts[[All, 2]];
	incubatorsOverCapacityFootprints = incubatorsOverCapacityAmounts[[All, 3]];
	incubatorsOverCapacityQuantities = incubatorsOverCapacityAmounts[[All, 4]];

	tooManySamples = Flatten[{
		Map[
			Function[{incubator},
				With[{containers = Lookup[incubatorsToContainers, incubator]},
					Lookup[containersToSamples, #]& /@ containers
				]
			],
			incubatorOverCapacityIncubators
		]
	}];

	(* If we have too many samples for an incubator, throw an error: *)
	If[Not[MatchQ[incubatorsOverCapacityAmounts, {}]] && messages,
		Message[
			Error::TooManyIncubationSamples,
			ObjectToString[incubatorOverCapacityIncubators, Cache -> cacheBall],
			incubatorOverCapacityCapacities,
			incubatorsOverCapacityFootprints,
			incubatorsOverCapacityQuantities

		]
	];
	tooManySamplesTest = If[gatherTests,
		Test["Too many samples are not provided for a given incubator:",
			incubatorOverCapacityIncubators,
			{}
		]

	];

	(* Gather the samples that are in the same container together with their options *)
	groupedSamplesContainersAndOptions = GatherBy[
		Transpose[{mySamples, sampleContainerPackets, resolvedMapThreadOptions}],
		#[[2]]&
	];

	(* Get the options that are not the same across the board for each container *)
	inconsistentOptionsPerContainer = Map[
		Function[{samplesContainersAndOptions},
			Map[
				Function[{optionToCheck},
					If[SameQ @@ Lookup[samplesContainersAndOptions[[All, 3]], optionToCheck],
						Nothing,
						optionToCheck
					]
				],
				Append[optionsToPullOut, SamplesOutStorageCondition]
			]
		],
		groupedSamplesContainersAndOptions
	];

	(* Get the samples that have conflicting options for the same container *)
	samplesWithSameContainerConflictingOptions = MapThread[
		Function[{samplesContainersAndOptions, inconsistentOptions},
			If[MatchQ[inconsistentOptions, {}],
				Nothing,
				samplesContainersAndOptions[[All, 1]]
			]
		],
		{groupedSamplesContainersAndOptions, inconsistentOptionsPerContainer}
	];
	samplesWithSameContainerConflictingErrors = Not[MatchQ[#, {}]]& /@ inconsistentOptionsPerContainer;

	(* Throw an error if we have these same-container samples with different options specified *)
	conflictingIncubationConditionsForSameContainerOptions = If[MemberQ[samplesWithSameContainerConflictingErrors, True] && messages,
		(
			Message[
				Error::ConflictingIncubationConditionsForSameContainer,
				PickList[samplesWithSameContainerConflictingOptions, samplesWithSameContainerConflictingErrors],
				PickList[inconsistentOptionsPerContainer, samplesWithSameContainerConflictingErrors]
			];
			DeleteDuplicates[Flatten[inconsistentOptionsPerContainer]]
		),
		{}
	];
	conflictingIncubationConditionsForSameContainerTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySamples,samplesWithSameContainerConflictingErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>",have the same incubation conditions as all other samples in the same container:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>",have the same incubation conditions as all other samples in the same container:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If the Temperature is greater than the MaxTemperature of an input container, throw an error *)
	temperatureAboveMaxTemperatureQs = MapThread[
		With[{maxTemp = Lookup[#1, MaxTemperature, Null]},
			TemperatureQ[maxTemp] && maxTemp < #2
		]&,
		{sampleContainerModelPackets, temperatures}
	];
	incubationMaxTemperatureOptions = If[MemberQ[temperatureAboveMaxTemperatureQs, True] && messages,
		(
			Message[
				Error::IncubationMaxTemperature,
				ObjectToString[PickList[mySamples, temperatureAboveMaxTemperatureQs], Cache -> cacheBall],
				First /@ Position[temperatureAboveMaxTemperatureQs, True],
				ObjectToString[PickList[Lookup[sampleContainerModelPackets, Object, Null], temperatureAboveMaxTemperatureQs], Cache -> cacheBall],
				PickList[Lookup[sampleContainerModelPackets, MaxTemperature, Null], temperatureAboveMaxTemperatureQs]
			];
			{Temperature}
		),
		{}
	];
	incubationMaxTemperatureTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, temperatureAboveMaxTemperatureQs];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", do not have Temperature set higher than the MaxTemperature of their containers:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", do not have Temperature set higher than the MaxTemperature of their containers:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If IncubationCondition was set to Custom but not all incubation conditions were specified, throw a warning saying what we resolved them to *)
	resolvedUnspecifiedOptions = Lookup[resolvedOptions, unspecifiedMapThreadOptions];
	customIncubationWarningSamples = PickList[mySamples, customIncubationConditionNotSpecifiedWarnings];
	customIncubationWarningPositions = First /@ Position[customIncubationConditionNotSpecifiedWarnings, True];
	customIncubationWarningUnspecifiedOptionNames = PickList[unspecifiedMapThreadOptions, customIncubationConditionNotSpecifiedWarnings];
	customIncubationWarningResolvedOptions = MapThread[
		If[#1,
			Lookup[#2, #3],
			Nothing
		]&,
		{customIncubationConditionNotSpecifiedWarnings, resolvedMapThreadOptions, unspecifiedMapThreadOptions}
	];
	If[MemberQ[customIncubationConditionNotSpecifiedWarnings, True] && messages && notInEngine,
		Message[
			Warning::CustomIncubationConditionNotSpecified,
			ObjectToString[customIncubationWarningSamples, Cache -> cacheBall],
			customIncubationWarningPositions,
			customIncubationWarningUnspecifiedOptionNames,
			customIncubationWarningResolvedOptions
		]
	];
	customIncubationNotSpecifiedTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, customIncubationConditionNotSpecifiedWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Warning["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", if IncubationCondition is set to Custom, all incubation conditions are directly specified rather than automatically set:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs]>0,
				Warning["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", if IncubationCondition is set to Custom, all incubation conditions are directly specified rather than automatically set:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* No compatible incubator options error check *)
	noCompatibleIncubatorErrors = MatchQ[#, ({}|Null)]& /@ possibleIncubators;

	noCompatibleIncubatorsInvalidInputs = If[Or@@noCompatibleIncubatorErrors && !gatherTests,
		Module[{invalidSamples, invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples = PickList[mySamples, noCompatibleIncubatorErrors];
			invalidOptions = invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::NoCompatibleIncubator,
				ObjectToString[invalidSamples, Cache -> cacheBall],
				First /@ Position[noCompatibleIncubatorErrors, True]
			];

			(* Return our invalid inputs. *)
			invalidSamples
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	noCompatibleIncubatorTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, noCompatibleIncubatorErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have a valid incubator capable of incubating the samples with the provided options:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs]>0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have a valid incubator capable of incubating the samples with the provided options:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Incubator is incompatible error check *)
	incubatorIsIncompatibleErrors = MapThread[
		Function[{resolvedIncubator, allowedIncubators},
			Module[{resolvedIncubatorModel},
				(* If the incubator is specified to be an object, get its model, otherwise leave as it is *)
				resolvedIncubatorModel = If[MatchQ[resolvedIncubator,ObjectP[Object[Instrument, Incubator]]],
					fastAssocLookup[fastAssoc, resolvedIncubator, Model],
					resolvedIncubator
				];
				(* Determine whether to throw an error for this sample *)
				If[
					And[
						(* Empty possibleIncubators is caught by another error*)
						!MatchQ[allowedIncubators,({}|Null)],
						(* Incubator model is indeed a model *)
						MatchQ[resolvedIncubatorModel, ObjectP[Model[Instrument, Incubator]]],
						(* But incubator is not in possibleIncubators. Here we are guaranteed that this incubator is user-specified*)
						!MemberQ[allowedIncubators,ObjectP[resolvedIncubatorModel]]
					],
					True,
					False
				]
			]
		],
		{rawIncubators, possibleIncubators}
	];

	incubatorIsIncompatibleOptions = If[Or@@incubatorIsIncompatibleErrors && !gatherTests,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples = PickList[mySamples, incubatorIsIncompatibleErrors];

			(* Throw the corresponding error. *)
			Message[Error::IncubatorIsIncompatible,
				ObjectToString[invalidSamples, Cache -> cacheBall],
				First /@ Position[incubatorIsIncompatibleErrors, True],
				ObjectToString[PickList[incubators, incubatorIsIncompatibleErrors], Cache -> cacheBall],
				ObjectToString[PickList[possibleIncubators, incubatorIsIncompatibleErrors], Cache -> cacheBall]
			];

			(* Return our invalid options. *)
			{Incubator}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	incubatorIsIncompatibleTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, incubatorIsIncompatibleErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", has the incubator compatible if specified:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs]>0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", has the incubator compatible if specified:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	firstCustomIncubator = FirstCase[rawIncubators, Alternatives @@ customIncubators];
	(*Too many custom incubator options error check *)
	invalidCustomIncubatorsErrors = MatchQ[#, Alternatives @@ DeleteCases[customIncubators, firstCustomIncubator]]& /@ rawIncubators;

	invalidCustomIncubatorsOptions = If[Or @@ invalidCustomIncubatorsErrors && !gatherTests,
		Module[{invalidSamples, invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples = PickList[mySamples, invalidCustomIncubatorsErrors];
			invalidOptions = invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::TooManyCustomIncubationConditions,
				ObjectToString[invalidSamples, Cache -> cacheBall],
				ObjectToString[PickList[rawIncubators, invalidCustomIncubatorsErrors]],
				ObjectToString[firstCustomIncubator]
			];

			(* Return our invalid options. *)
			{Incubator}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	invalidCustomIncubatorsTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, invalidCustomIncubatorsErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", all only utilize one custom incubator to incubate the samples with the provided options", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", all only utilize one custom incubator to incubate the samples with the provided options", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Invalid shaking conditions options error check *)
	invalidShakingConditionsOptions = If[Or @@ conflictingShakingConditionsErrors && !gatherTests,
		Module[{invalidSamples, invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples = PickList[mySamples, conflictingShakingConditionsErrors];
			invalidOptions = invalidSamples;

			(* Throw the corresponding error. *)
			Message[
				Error::ConflictingShakingConditions,
				ObjectToString[invalidSamples, Cache -> cacheBall],
				First /@ Position[conflictingShakingConditionsErrors, True],
				PickList[shaking, conflictingShakingConditionsErrors],
				PickList[shakingRates, conflictingShakingConditionsErrors],
				PickList[resolvedShakingRadii, conflictingShakingConditionsErrors]
			];

			(* Return our invalid options. *)
			{Shake, ShakingRate, ShakingRadius}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	invalidShakingConditionsTests= If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingShakingConditionsErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have selected shaking options compatible with each other", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have selected shaking options compatible with each other", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Conflicting CellType options error check *)
	conflictingCellTypeOptions = If[Or @@ conflictingCellTypeErrors && !gatherTests,
		Module[{invalidSamples, invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples = PickList[mySamples, conflictingCellTypeErrors];
			invalidOptions = invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::ConflictingCellType,
				ObjectToString[invalidSamples, Cache -> cacheBall],
				First /@ Position[conflictingCellTypeErrors, True],
				PickList[cellTypes, conflictingCellTypeErrors],
				PickList[cellTypesFromSample, conflictingCellTypeErrors]
			];

			(* Return our invalid options. *)
			{CellType}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	conflictingCellTypeTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingCellTypeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have a CellType that matches the CellType option value provided", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have a CellType that matches the CellType option value provided", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Conflicting CultureAdhesion options error check *)
	conflictingCultureAdhesionOptions = If[Or @@ conflictingCultureAdhesionErrors && !gatherTests,
		Module[{invalidSamples, invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples = PickList[mySamples, conflictingCultureAdhesionErrors];
			invalidOptions = invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::ConflictingCultureAdhesion,
				ObjectToString[invalidSamples, Cache -> cacheBall],
				First /@ Position[conflictingCultureAdhesionErrors, True],
				PickList[cultureAdhesions, conflictingCultureAdhesionErrors],
				PickList[cultureAdhesionsFromSample, conflictingCultureAdhesionErrors]
			];

			(* Return our invalid options. *)
			{CultureAdhesion}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	conflictingCultureAdhesionTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingCultureAdhesionErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have a CultureAdhesion that matches the CultureAdhesion option value provided", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have a CultureAdhesion that matches the CultureAdhesion option value provided", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(* CellType not specified options warning check *)
	If[Or@@cellTypeNotSpecifiedWarnings&&!gatherTests && notInEngine,
		Message[Warning::CellTypeNotSpecified, ObjectToString[PickList[mySamples, cellTypeNotSpecifiedWarnings], Cache -> cacheBall]]
	];

	(* Create the corresponding test for the invalid options. *)
	cellTypeNotSpecifiedTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, cellTypeNotSpecifiedWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have a CellType specified (as an option or in the Model)", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have a CellType specified (as an option or in the Model)", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* CultureAdhesion not specified options warning check *)
	If[Or @@ cultureAdhesionNotSpecifiedWarnings && !gatherTests && notInEngine,
		Message[
			Warning::CultureAdhesionNotSpecified,
			ObjectToString[PickList[mySamples, cultureAdhesionNotSpecifiedWarnings], Cache -> cacheBall],
			First /@ Position[cultureAdhesionNotSpecifiedWarnings, True],
			PickList[cultureAdhesions, cultureAdhesionNotSpecifiedWarnings, True]
		]
	];
	(* Create the corresponding test for the invalid options. *)
	cultureAdhesionNotSpecifiedTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, cultureAdhesionNotSpecifiedWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have a CultureAdhesion specified (as an option or in the Model)", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have a CultureAdhesion specified (as an option or in the Model)", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If IncubationCondition was set to a non-incubation storage type, throw an error *)
	invalidIncubationConditionOptions = If[MemberQ[invalidIncubationConditionErrors, True] && messages,
		(
			Message[
				Error::InvalidIncubationConditions,
				ObjectToString[PickList[mySamples, invalidIncubationConditionErrors], Cache -> cacheBall],
				First /@ Position[invalidIncubationConditionErrors, True],
				ObjectToString[PickList[incubationCondition, invalidIncubationConditionErrors], Cache -> cacheBall]
			];
			{IncubationCondition}
		),
		{}
	];
	invalidIncubationConditionTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, invalidIncubationConditionErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have a specified IncubationCondition that is currently supported:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have a specified IncubationCondition that is currently supported:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Can't do Mammalian + SolidMedia, or Yeast|Bacterial + Adherent *)
	conflictingCellTypeAdhesionOptions = If[MemberQ[conflictingCellTypeAdhesionErrors, True] && messages,
		(
			Message[
				Error::ConflictingCellTypeWithCultureAdhesion,
				ObjectToString[PickList[mySamples, conflictingCellTypeAdhesionErrors], Cache -> cacheBall],
				First /@ Position[conflictingCellTypeAdhesionErrors, True],
				PickList[cultureAdhesions, conflictingCellTypeAdhesionErrors],
				PickList[cellTypes, conflictingCellTypeAdhesionErrors]
			];
			{CultureAdhesion, CellType}
		),
		{}
	];
	conflictingCellTypeAdhesionTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingCellTypeAdhesionErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", don't try Mammalian+SolidMedia, or Bacterial|Yeast+Adherent:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", don't try Mammalian+SolidMedia, or Bacterial|Yeast+Adherent:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Can't do Mammalian + Suspension right now  *)
	unsupportedCellCultureTypeOptions = If[MemberQ[unsupportedCellCultureTypeErrors, True] && messages,
		(
			Message[
				Error::UnsupportedCellCultureType,
				ObjectToString[PickList[mySamples, unsupportedCellCultureTypeErrors], Cache -> cacheBall],
				First /@ Position[unsupportedCellCultureTypeErrors, True]
			];
			{CultureAdhesion, CellType}
		),
		{}
	];
	unsupportedCellCultureTypeTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, unsupportedCellCultureTypeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", do not request the currently unsupported Mammalian Suspension culture:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", do not request the currently unsupported Mammalian Suspension culture:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Make sure we don't specify an incubator that conflicts with the input cell type *)
	conflictingCellTypeWithIncubatorOptions = If[MemberQ[conflictingCellTypeWithIncubatorErrors, True] && messages,
		(
			Message[
				Error::ConflictingCellTypeWithIncubator,
				ObjectToString[PickList[mySamples, conflictingCellTypeWithIncubatorErrors], Cache -> cacheBall],
				First /@ Position[conflictingCellTypeWithIncubatorErrors, True],
				PickList[cellTypes, conflictingCellTypeWithIncubatorErrors],
				ObjectToString[PickList[incubators, conflictingCellTypeWithIncubatorErrors], Cache -> cacheBall],
				fastAssocLookup[fastAssoc, #, CellTypes]& /@ PickList[incubators, conflictingCellTypeWithIncubatorErrors]
			];
			{Incubator, CellType}
		),
		{}
	];
	conflictingCellTypeWithIncubatorTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, unsupportedCellCultureTypeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " only specify Incubators that are compatible with the samples' cell types:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " only specify Incubators that are compatible with the samples' cell types:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If samples are not in plates, can't be be SolidMedia or Adherent *)
	conflictingCultureAdhesionWithContainerOptions = If[MemberQ[conflictingCultureAdhesionWithContainerErrors, True] && messages,
		(
			Message[
				Error::ConflictingCultureAdhesionWithContainer,
				ObjectToString[PickList[mySamples, conflictingCultureAdhesionWithContainerErrors], Cache -> cacheBall],
				First /@ Position[conflictingCultureAdhesionWithContainerErrors, True],
				PickList[cultureAdhesions, conflictingCultureAdhesionWithContainerErrors]
			];
			{CultureAdhesion}
		),
		{}
	];
	conflictingCultureAdhesionWithContainerTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingCultureAdhesionWithContainerErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", are in plates if CultureAdhesion is SolidMedia or Adherent:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", are in plates if CultureAdhesion is SolidMedia or Adherent:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If not disposing of things, then SamplesOutStorageCondition must be in agreement with what kind of cells we have *)
	conflictingCellTypeWithStorageConditionOptions = If[MemberQ[conflictingCellTypeWithStorageConditionErrors, True] && messages,
		(
			Message[
				Error::ConflictingCellTypeWithStorageCondition,
				ObjectToString[PickList[mySamples, conflictingCellTypeWithStorageConditionErrors], Cache -> cacheBall],
				First /@ Position[conflictingCellTypeWithStorageConditionErrors, True],
				PickList[cellTypes, conflictingCellTypeWithStorageConditionErrors],
				PickList[samplesOutStorageCondition, conflictingCellTypeWithStorageConditionErrors]
			];
			{CellType, SamplesOutStorageCondition}
		),
		{}
	];
	conflictingCellTypeWithStorageConditionTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingCellTypeWithStorageConditionErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have SamplesOutStorageCondition that are consistent with their CellType:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have SamplesOutStorageCondition that are consistent with their CellTyps:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If not disposing of things or putting things in fridge/ambient, then warn the user if SamplesOutStorageCondition is not in agreement with CultureAdhesion *)If[MemberQ[conflictingCultureAdhesionWithStorageConditionWarnings, True] && messages,
		(
			Message[
				Warning::ConflictingCultureAdhesionWithStorageCondition,
				ObjectToString[PickList[mySamples, conflictingCultureAdhesionWithStorageConditionWarnings], Cache -> cacheBall],
				First /@ Position[conflictingCultureAdhesionWithStorageConditionWarnings, True],
				PickList[cultureAdhesions, conflictingCultureAdhesionWithStorageConditionWarnings],
				PickList[samplesOutStorageCondition, conflictingCultureAdhesionWithStorageConditionWarnings]
			];
			{CultureAdhesion, SamplesOutStorageCondition}
		),
		{}
	];

	conflictingCultureAdhesionWithStorageConditionTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingCultureAdhesionWithStorageConditionWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have SamplesOutStorageCondition that are consistent with their CultureAdhesion:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have SamplesOutStorageCondition that are consistent with their CultureAdhesion:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Throw an error if ExperimentQuantifyCells resolves the QuantificationAliquot option but gives a mix of True and False. *)
	(* The scenario which requires us to throw this error is pretty unlikely - e.g. the user has multiple samples and some but not all *)
	(* are compatible with the quantification instrument and the user doesn't set any aliquoting options explicitly. *)
	mixedQuantificationAliquotRequirementsOptions = If[MatchQ[mixedAliquotingQ, True] && messages,
		(
			Message[
				Error::MixedQuantificationAliquotRequirements,
				ObjectToString[mySamples, Cache -> cacheBall],
				finalAliquotBools,
				Range[Length[mySamples]]
			];
			{QuantificationAliquot}
		),
		{}
	];
	mixedQuantificationAliquotRequirementsOptionsTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = If[MatchQ[mixedQuantificationAliquotRequirementsOptions, {}], {}, mySamples];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["Some but not all of the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " require aliquoting for quantification, but QuantificationAliquot is not explicitly set to True:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The QuantificationAliquot option resolved to either all True, all False, or all Null for the following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Throw a warning if QuantificationAliquot resolves to True from Automatic. *)
	quantificationAliquotRequiredQ = And[
		messages,
		notInEngine,
		MatchQ[Lookup[myOptions, QuantificationAliquot], Except[True]],
		TrueQ[resolvedAliquotBool],
		!TrueQ[mixedAliquotingQ] (* this message is likely to confuse the user if we're also throwing the mixed aliquoting message *)
	];
	If[quantificationAliquotRequiredQ, Message[Warning::QuantificationAliquotRequired]];

	(* Create the corresponding test for the invalid options. *)
	quantificationAliquotRequiredTest = If[gatherTests,
		Module[{failingTest, passingTest},

			failingTest = If[!quantificationAliquotRequiredQ,
				Nothing,
				Test["QuantificationAliquot does not resolve to True from Automatic:", True, False]
			];

			passingTest = If[quantificationAliquotRequiredQ,
				Nothing,
				Test["QuantificationAliquot does not resolve to True from Automatic:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Throw a warning if we're quantifying with Abs or Neph in a manual protocol and QuantificationAliquot is False. *)
	quantificationAliquotRecommendedQ = And[
		messages,
		notInEngine,
		MatchQ[resolvedQuantificationMethod, Absorbance|Nephelometry],
		MatchQ[resolvedPreparation, Manual],
		!MatchQ[resolvedAliquotBool, True],
		!MatchQ[Length[errorChecksBeforeQuantification], GreaterP[0]] (* if this matches, we didn't run QuantifyCells because there was a problem beforehand *)
	];
	If[quantificationAliquotRecommendedQ,
		Message[
			Warning::QuantificationAliquotRecommended,
			resolvedQuantificationMethod,
			resolvedPreparation,
			resolvedAliquotBool
		]
	];

	(* Create the corresponding test for the invalid options. *)
	quantificationAliquotRecommendedTest = If[gatherTests,
		Module[{failingTest, passingTest},

			failingTest = If[!quantificationAliquotRecommendedQ,
				Nothing,
				Test["QuantificationAliquot is not False while QuantificationMethod is Absorbance or Nephelometry:", True, False]
			];

			passingTest = If[quantificationAliquotRecommendedQ,
				Nothing,
				Test["QuantificationAliquot is not False while QuantificationMethod is Absorbance or Nephelometry:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* IncubationStrategy must be compatible with the settings of all quantification options. *)
	conflictingIncubationStrategyCases = Join @@ MapThread[
		Function[
			{
				sample,
				target,
				tolerance,
				wavelength,
				curve,
				index
			},
			{
				If[MatchQ[resolvedIncubationStrategy, Time] && MatchQ[target, Except[Null]],
					{sample, MinQuantificationTarget, resolvedIncubationStrategy, target, index},
					Nothing
				],
				If[MatchQ[resolvedIncubationStrategy, Time] && MatchQ[tolerance, Except[Null]],
					{sample, QuantificationTolerance, resolvedIncubationStrategy, tolerance, index},
					Nothing
				],
				If[MatchQ[resolvedIncubationStrategy, Time] && MatchQ[resolvedAliquotBool, True],
					{sample, QuantificationAliquot, resolvedIncubationStrategy, resolvedAliquotBool, index},
					Nothing
				],
				If[MatchQ[resolvedIncubationStrategy, Time] && MatchQ[resolvedQuantificationBlankMeasurementBool, True],
					{sample, QuantificationBlankMeasurement, resolvedIncubationStrategy, resolvedQuantificationBlankMeasurementBool, index},
					Nothing
				],
				If[MatchQ[resolvedIncubationStrategy, Time] && MatchQ[wavelength, Except[Null]],
					{sample, QuantificationWavelength, resolvedIncubationStrategy, wavelength, index},
					Nothing
				],
				If[MatchQ[resolvedIncubationStrategy, Time] && MatchQ[curve, Except[Null]],
					{sample, QuantificationStandardCurve, resolvedIncubationStrategy, curve, index},
					Nothing
				],
				If[MatchQ[resolvedIncubationStrategy, Time] && MatchQ[resolvedFailureResponse, Except[Null]],
					{sample, FailureResponse, resolvedIncubationStrategy, resolvedFailureResponse, index},
					Nothing
				],
				If[MatchQ[resolvedIncubationStrategy, Time] && MatchQ[finalQuantificationInstrument, Except[Null]],
					{sample, QuantificationInstrument, resolvedIncubationStrategy, finalQuantificationInstrument, index},
					Nothing
				],
				If[MatchQ[resolvedIncubationStrategy, QuantificationTarget] && MatchQ[finalQuantificationInstrument, Null],
					{sample, QuantificationInstrument, resolvedIncubationStrategy, finalQuantificationInstrument, index},
					Nothing
				],
				If[MatchQ[resolvedIncubationStrategy, Time] && MatchQ[resolvedQuantificationMethod, Except[Null]],
					{sample, QuantificationMethod, resolvedIncubationStrategy, resolvedQuantificationMethod, index},
					Nothing
				],
				If[MatchQ[resolvedIncubationStrategy, QuantificationTarget] && MatchQ[resolvedQuantificationMethod, Null],
					{sample, QuantificationMethod, resolvedIncubationStrategy, resolvedQuantificationMethod, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			minQuantificationTargets,
			quantificationTolerances,
			finalWavelengths,
			finalStandardCurves,
			Range[Length[mySamples]]
		}
	];

	conflictingIncubationStrategyOptions = If[MatchQ[Length[conflictingIncubationStrategyCases], GreaterP[0]] && messages,
		(
			Message[
				Error::ConflictingIncubationStrategy,
				ObjectToString[conflictingIncubationStrategyCases[[All,1]], Cache -> cacheBall],
				ObjectToString[conflictingIncubationStrategyCases[[All,2]], Cache -> cacheBall],
				ObjectToString[conflictingIncubationStrategyCases[[All,3]], Cache -> cacheBall],
				ObjectToString[conflictingIncubationStrategyCases[[All,4]], Cache -> cacheBall],
				conflictingIncubationStrategyCases[[All, 5]]
			];
			DeleteDuplicates @ Flatten[{IncubationStrategy, conflictingIncubationStrategyCases[[All,2]]}]
		),
		{}
	];

	conflictingIncubationStrategyTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingIncubationStrategyCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["Quantification options are specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if and only if the IncubationStrategy is QuantificationTarget:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["Quantification options are specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if and only if the IncubationStrategy is QuantificationTarget:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check whether the quantification schedule and aliquoting will require us to use more sample than we have available. *)
	excessiveQuantificationAliquotVolumeRequiredCases = MapThread[
		Function[
			{sample, aliquotVolume, sampleVolume, index},
			If[
				And[
					MatchQ[(maxNumberOfQuantifications * aliquotVolume), GreaterP[sampleVolume]],
          MatchQ[resolvedAliquotBool, True],
					!TrueQ[Lookup[resolvedOptions, QuantificationRecoupSample]]
				],
				{sample, aliquotVolume, resolvedQuantificationInterval, resolvedTime, (maxNumberOfQuantifications * aliquotVolume), sampleVolume, index},
				Nothing
			]
		],
		{
			mySamples,
			finalAliquotVolumes,
			Lookup[samplePackets, Volume, 0 Microliter],
			Range[Length[mySamples]]
		}
	];

	excessiveQuantificationAliquotVolumeRequiredOptions = If[MatchQ[Length[excessiveQuantificationAliquotVolumeRequiredCases], GreaterP[0]] && messages,
		(
			Message[
				Error::ExcessiveQuantificationAliquotVolumeRequired,
				ObjectToString[excessiveQuantificationAliquotVolumeRequiredCases[[All,1]], Cache -> cacheBall],
				ObjectToString[excessiveQuantificationAliquotVolumeRequiredCases[[All,2]], Cache -> cacheBall],
				ObjectToString[excessiveQuantificationAliquotVolumeRequiredCases[[All,3]], Cache -> cacheBall],
				ObjectToString[excessiveQuantificationAliquotVolumeRequiredCases[[All,4]], Cache -> cacheBall],
				ObjectToString[excessiveQuantificationAliquotVolumeRequiredCases[[All,5]], Cache -> cacheBall],
				ObjectToString[excessiveQuantificationAliquotVolumeRequiredCases[[All,6]], Cache -> cacheBall],
				excessiveQuantificationAliquotVolumeRequiredCases[[All,7]]
			];
			DeleteDuplicates @ Flatten[{QuantificationAliquot, QuantificationRecoupSample, QuantificationAliquotVolume, Time, QuantificationInterval}]
		),
		{}
	];

	excessiveQuantificationAliquotVolumeRequiredTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = excessiveQuantificationAliquotVolumeRequiredCases[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The QuantificationAliquotVolume times the maximum number of quantifications for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " does not exceed the available sample volume while QuantificationRecoupSample is False:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The QuantificationAliquotVolume times the maximum number of quantifications for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " does not exceed the available sample volume while QuantificationRecoupSample is False:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Throw a warning if the user doesn't specify FailureResponse and it resolves to Discard. *)
  If[MatchQ[discardUponFailureWarningBool, True] && messages && notInEngine,
    Message[Warning::DiscardUponFailure];
  ];

	(* Throw the GeneralFailureResponse warning if there is a non-Null FailureResponse and multiple samples are in the protocol. *)
	If[And[
		MatchQ[resolvedFailureResponse, Except[Null]],
		MatchQ[Length[mySamples], GreaterP[1]],
		messages,
		notInEngine
	],
		Message[
			Warning::GeneralFailureResponse,
			ObjectToString[resolvedFailureResponse, Cache -> cacheBall],
			Length[mySamples]
		];
	];

	(* Throw a warning to tell the user that the MinQuantificationTarget defaulted to None from Automatic. *)
	noQuantificationTargetCases = If[
		MemberQ[minTargetNoneWarningBools, True],
		Transpose @ {
			PickList[mySamples, minTargetNoneWarningBools],
			PickList[Range[Length[mySamples]], minTargetNoneWarningBools]
		},
		{}
	];

	If[MatchQ[Length[noQuantificationTargetCases], GreaterP[0]] && messages && notInEngine,
		Message[
			Warning::NoQuantificationTarget,
			ObjectToString[noQuantificationTargetCases[[All,1]], Cache -> cacheBall],
			noQuantificationTargetCases[[All, 2]]
		];
	];

	(* -- MESSAGE AND RETURN --*)



	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[
			{
				discardedInvalidInputs,
				deprecatedSampleInputs,
				invalidPropertySampleInputs,
				uncoveredSampleInputs,
				invalidCellTypeSamples,
				invalidPlateSampleInputs,
				duplicateSamples,
				noCompatibleIncubatorsInvalidInputs,
				tooManySamples
			}
		]
	];
	invalidOptions = DeleteDuplicates[Flatten[
			{
				invalidShakingConditionsOptions,
				conflictingWorkCellAndPreparationOptions,
				conflictingCellTypeOptions,
				conflictingCultureAdhesionOptions,
				invalidCustomIncubatorsOptions,
				invalidIncubationConditionOptions,
				conflictingCellTypeAdhesionOptions,
				unsupportedCellCultureTypeOptions,
				conflictingCellTypeWithIncubatorOptions,
				conflictingCultureAdhesionWithContainerOptions,
				conflictingCellTypeWithStorageConditionOptions,
				mixedQuantificationAliquotRequirementsOptions,
				conflictingIncubationConditionsForSameContainerOptions,
				incubationMaxTemperatureOptions,
				conflictingIncubationStrategyOptions,
				conflictingQuantificationAliquotOptions,
				unsuitableQuantificationIntervalOptions,
				conflictingQuantificationOptions,
				failureResponseNotSupportedOptions,
				conflictingQuantificationMethodAndInstrumentOptions,
				excessiveQuantificationAliquotVolumeRequiredOptions,
				quantificationTargetUnitsMismatchOptions,
				extraneousQuantifyColoniesOptions,
				aliquotRecoupMismatchedOptions,
				incubatorIsIncompatibleOptions,
				If[MatchQ[preparationResult, $Failed],
					{Preparation},
					Nothing
				],
				If[MatchQ[workCellResult, $Failed],
					{WorkCell},
					Nothing
				]
			}
		]
	];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs] > 0 && !gatherTests,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions] > 0 && !gatherTests,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> {resolvedOptions, quantificationProtocolPacket},
		Simulation -> simulationWithQuantification,
		Tests -> Cases[Flatten[{
			discardedTest,
			deprecatedTest,
			uncoveredContainerTest,
			invalidCellTypeTest,
			invalidPlateSampleTest,
			duplicateSamplesTest,
			invalidPropertySampleTest,
			conflictingWorkCellAndPreparationTest,
			precisionTests,
			preparationTest,
			invalidShakingConditionsTests,
			cellTypeNotSpecifiedTests,
			cultureAdhesionNotSpecifiedTests,
			conflictingCellTypeTests,
			conflictingCultureAdhesionTests,
			invalidCustomIncubatorsTests,
			noCompatibleIncubatorTests,
			customIncubationNotSpecifiedTest,
			invalidIncubationConditionTest,
			unsupportedCellCultureTypeTests,
			conflictingCellTypeAdhesionTests,
			conflictingCellTypeWithIncubatorTests,
			conflictingCultureAdhesionWithContainerTests,
			conflictingCellTypeWithStorageConditionTests,
			conflictingCultureAdhesionWithStorageConditionTests,
			mixedQuantificationAliquotRequirementsOptionsTests,
			conflictingIncubationConditionsForSameContainerTests,
			incubationMaxTemperatureTests,
			tooManySamplesTest,
			workCellTest,
			conflictingIncubationStrategyTest,
			conflictingQuantificationAliquotOptionsTest,
			unsuitableQuantificationIntervalTest,
			conflictingQuantificationOptionsTest,
			failureResponseNotSupportedTest,
			conflictingQuantificationMethodAndInstrumentOptionsTest,
			excessiveQuantificationAliquotVolumeRequiredTest,
			quantificationTargetUnitsMismatchTest,
			extraneousQuantifyColoniesOptionsTest,
			aliquotRecoupMismatchTest,
			incubatorIsIncompatibleTests,
			quantificationAliquotRequiredTest,
			quantificationAliquotRecommendedTest
		}], _EmeraldTest]
	}
];

(* ::Subsubsection::Closed:: *)
(* incubateCellsResourcePackets *)


DefineOptions[
	incubateCellsResourcePackets,
	Options :> {
		SimulationOption,
		CacheOption,
		HelperOutputOption
	}
];

incubateCellsResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, myCollapsedResolvedOptions: {___Rule}, ops:OptionsPattern[]] := Module[
	{
		unresolvedOptionsNoHidden, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages, simulation,
		samplePackets, inputContainersNoDupes, sampleResources, sampleContainerResources, allResourceBlobs, fulfillable, frqTests,
		testsRule, resultRule, customIncubationOptions, containerResourceRules, allIncubationStorageConditionSymbols,
		protocolID, unitOperationID, sampleLabels, sampleContainerLabels, cellTypes, cultureAdhesions, temperatures, carbonDioxidePercentages, relativeHumidities,
		time, shakingRates, incubators, resolvedStorageConditions, groupedOptions, customIncubators, uniqueContainerPositions,
		parentProtocol, failureResponse, quantificationMethod, quantificationInstrument, quantificationInterval,
		minQuantificationTargets, quantificationTolerances, quantificationAliquotBool, quantificationAliquotVolumes, quantificationAliquotContainers, quantificationRecoupSampleBool,
		quantificationBlanks, quantificationBlankMeasurement, quantificationWavelengths, quantificationStandardCurves, roboticQ, minQuantificationTargetsWithoutNone,
		instrumentResourcesLink, failureResponseUnitOperation, failureResponseSimulation, simulationWithFailureResponse, incubatorResources,
		previewRule, optionsRule, nonHiddenOptions, nonHiddenOptionsWithoutTarget, safeOps, cache, fastAssoc, containerPackets, preparation,
		incubationConditions, containers, containerMovesToDifferentStorageConditionQs, labelSamplePrimitive, allPrimitivesExceptIncubateCells,
		containerStoredInNonIncubatorQs, nonIncubationStorageContainerObjs, nonIncubationStorageContainerResources,
		defaultIncubatorQs, nonIncubationStorageContainerConditions, postDefaultIncubationContainerObjs,
		postDefaultIncubationContainerResources, defaultIncubationContainerObjs, defaultIncubationContainerResources,
		shakes, shakingRadii, samplesOutStorageConditionSymbols, unitOperationPacket, simulationWithRoboticUOs, runTime, fastAssocKeysIDOnly, storageConditionPackets,
		incubationConditionSymbols, incubationConditionObjects, incubationStorageConditionSymbols, maxNumberOfQuantifications, manualProtocolPacket,
		incubateCellsRoboticPrimitive, finalRoboticUnitOperationPackets, finalRoboticRunTime, quantificationAliquotUnitOperation, quantificationProcessingTimes
	},

	(* Get the collapsed unresolved index-matching options that don't include hidden options *)
	unresolvedOptionsNoHidden = RemoveHiddenOptions[ExperimentIncubateCells, myUnresolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentIncubateCells,
		RemoveHiddenOptions[ExperimentIncubateCells, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* Get the safe options for this function *)
	safeOps = SafeOptions[incubateCellsResourcePackets, ToList[ops]];

	(* Pull out the output options *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* Decide if we are gathering tests or throwing messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Lookup helper options *)
	{cache, simulation} = Lookup[safeOps, {Cache, Simulation}];

	(* Make the fast association *)
	fastAssoc = makeFastAssocFromCache[cache];

	(* Pull out the packets from the fast assoc *)
	fastAssocKeysIDOnly = Select[Keys[fastAssoc], StringMatchQ[Last[#], ("id:"~~___)]&];
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;
	containerPackets = fastAssocPacketLookup[fastAssoc, #, Container]& /@ mySamples;
	containers = Lookup[containerPackets, Object];
	storageConditionPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[StorageCondition]]];


	(* --- Make all the resources needed in the experiment --- *)

	(* -- Generate resources for the SamplesIn -- *)

	(* Prepare the sample resources *)
	sampleResources = Resource[Sample -> #, Name -> ToString[#]]& /@ mySamples;

	(* Pull out the necessary resolved options that need to be in discrete fields in the protocol object *)
	{
		sampleLabels,
		sampleContainerLabels,
		cellTypes,
		cultureAdhesions,
		temperatures,
		carbonDioxidePercentages,
		relativeHumidities,
		time,
		shakes,
		shakingRates,
		shakingRadii,
		incubators,
		resolvedStorageConditions,
		incubationConditions,
		preparation,
		parentProtocol,
		failureResponse,
		quantificationMethod,
		quantificationInstrument,
		quantificationInterval,
		minQuantificationTargets,
		quantificationTolerances,
		quantificationAliquotBool,
		quantificationAliquotVolumes,
		quantificationAliquotContainers,
		quantificationRecoupSampleBool,
		quantificationBlanks,
		quantificationBlankMeasurement,
		quantificationWavelengths,
		quantificationStandardCurves
	} = Lookup[myResolvedOptions,
		{
			SampleLabel,
			SampleContainerLabel,
			CellType,
			CultureAdhesion,
			Temperature,
			CarbonDioxide,
			RelativeHumidity,
			Time,
			Shake,
			ShakingRate,
			ShakingRadius,
			Incubator,
			SamplesOutStorageCondition,
			IncubationCondition,
			Preparation,
			ParentProtocol,
			FailureResponse,
			QuantificationMethod,
			QuantificationInstrument,
			QuantificationInterval,
			MinQuantificationTarget,
			QuantificationTolerance,
			QuantificationAliquot,
			QuantificationAliquotVolume,
			QuantificationAliquotContainer,
			QuantificationRecoupSample,
			QuantificationBlank,
			QuantificationBlankMeasurement,
			QuantificationWavelength,
			QuantificationStandardCurve
		}
	];

	(* Set a flag for our preparation option. *)
	roboticQ = MatchQ[preparation, Robotic];

	(* Get the max number of quantifications by dividing the Time by the interval. If we are NOT quantifying, set this to 0 since we use it to pad out some lists later. *)
	maxNumberOfQuantifications = If[TimeQ[quantificationInterval],
		Quotient[time, quantificationInterval],
		0
	];

	(* label primitives for SamplesIn, use ContainerLabel key to also label the ContainersIn *)
	labelSamplePrimitive = LabelSample[
		Sample -> mySamples,
		Label -> sampleLabels,
		ContainerLabel -> sampleContainerLabels
	];

	(* Prepare the container resources *)
	inputContainersNoDupes = DeleteDuplicates[containers];
	sampleContainerResources = Resource[Sample -> #, Name -> ToString[#]]& /@ inputContainersNoDupes;
	containerResourceRules = AssociationThread[inputContainersNoDupes, sampleContainerResources];

	(* Create a list of all of the possible incubation storage condition sybmols *)
	allIncubationStorageConditionSymbols = Lookup[storageConditionPackets,StorageCondition];
	
	(* Figure out the samples out storage condition symbol *)
	samplesOutStorageConditionSymbols = Map[
		If[MatchQ[#, ObjectP[Model[StorageCondition]]],
			fastAssocLookup[fastAssoc, #, StorageCondition],
			#
		]&,
		resolvedStorageConditions
	];

	(* Figure out the incubation condition symbols and objects *)
	incubationConditionSymbols = Map[
		If[MatchQ[#, ObjectP[Model[StorageCondition]]],
			fastAssocLookup[fastAssoc, #, StorageCondition],
			#
		]&,
		incubationConditions
	];
	incubationConditionObjects = Map[
		Which[
			(* custom doesn't have a storage condition object that goes with it *)
			MatchQ[#, Custom], Null,
			MatchQ[#, ObjectP[Model[StorageCondition]]], #,
			(* get the storage condition object that corresponds to the symbol we have already *)
			True, Lookup[FirstCase[storageConditionPackets, KeyValuePattern[StorageCondition -> #], <|Object -> Null|>], Object]
		]&,
		incubationConditions
	];
	incubationStorageConditionSymbols = Lookup[Cases[storageConditionPackets, KeyValuePattern[Object -> ObjectP[$IncubatorStorageConditions]]],StorageCondition];

	(* Determine if a given container needs to be stored in a different incubator than the one we incubated in *)
	(* this excludes all the custom ones *)
	containerMovesToDifferentStorageConditionQs = MapThread[
		Function[{incubationConditionSymbol, storageConditionSymbol},
			Not[MatchQ[incubationConditionSymbol, Custom]] && incubationConditionSymbol =!= storageConditionSymbol && MemberQ[incubationStorageConditionSymbols,incubationConditionSymbol]
		],
		{incubationConditionSymbols, samplesOutStorageConditionSymbols}
	];

	(* Determine if a given container is going to be stored not in an incubator after the experiment *)
	containerStoredInNonIncubatorQs = Map[
		Function[{storageConditionSymbol},
			!MemberQ[incubationStorageConditionSymbols, storageConditionSymbol]
		],
		samplesOutStorageConditionSymbols
	];

	(* Determine if a given container is going to be stored in a custom incubator or default incubator during the experiment *)
	defaultIncubatorQs = Map[
		!MatchQ[#, Custom]&,
		incubationConditions
	];

	(* Determine if a given container is going into a default incubation condition *)
	(* this is just everything that doesn't have Custom IncubationCondition *)
	(* don't need to do any of this for robotic; all Robotic are Custom anyway though so don't need to be explicit about Robotic here *)
	defaultIncubationContainerObjs = DeleteDuplicates[PickList[containers, defaultIncubatorQs]];
	defaultIncubationContainerResources = defaultIncubationContainerObjs /. containerResourceRules;

	(* Determine if a given container is going to be moved to non incubation condition after the experiment *)
	(* Note this container can be either a CustomIncubationConditionContainer or a DefaultIncubationConditionContainer *)
	nonIncubationStorageContainerObjs = PickList[containers, containerStoredInNonIncubatorQs];
	nonIncubationStorageContainerResources = nonIncubationStorageContainerObjs /. containerResourceRules;
	nonIncubationStorageContainerConditions = PickList[samplesOutStorageConditionSymbols, containerStoredInNonIncubatorQs];

	(* Generate the PostDefaultIncubationContainers field *)
	(* Determine if a given container is stored at default incubator, is it going to be stored in another default incubation condtion after the experiment*)
	postDefaultIncubationContainerObjs = DeleteDuplicates[PickList[containers, MapThread[And[#1, Not[#2], #3]&, {containerMovesToDifferentStorageConditionQs, containerStoredInNonIncubatorQs, defaultIncubatorQs}]]];
	postDefaultIncubationContainerResources = postDefaultIncubationContainerObjs /. containerResourceRules;

	(* If we have a custom incubator, make a resource for that incubator (note that we do NOT make resources for non-custom incubators) *)
	customIncubators = DeleteDuplicates[PickList[incubators, incubationConditions, Custom]];
	incubatorResources = Map[
		Resource[Instrument -> #, Time -> time, Name -> ToString[#]]&,
		customIncubators
	];
	instrumentResourcesLink = Link /@ (incubators /. AssociationThread[customIncubators, incubatorResources]);

	(* If we are aliquoting for quantification, we want to aliquot, return the source samples to their incubators, and then quantify on the aliquots. *)
	(* This is to minimize the time that the cells spend outside of the incubator during the quantification subprotocol, which likely takes multiple hours *)
	(* and is prolonged significantly if the protocol goes into troubleshooting. So here we build a transfer primitive which we will store in the protocol packet. *)
	quantificationAliquotUnitOperation = If[And[
		!MatchQ[quantificationAliquotBool, True],
		!roboticQ
	],
		(* If there's no manual quantification aliquoting (or no quantification altogether), we can just move on. *)
		Null,
		(* If we are aliquoting, build up a transfer unit operation from the relevant options. QAP == quantification aliquot primitive. *)
		Module[
			{optionNames, sampleLabelQAP, quantificationAliquotVolumeQAP, quantificationAliquotContainerQAP, destinationWellQAP, cellTypeToBSC},

			(* We don't support mixed quantification methods, so get the list of option names for either Absorbance or Nephelometry. *)
			optionNames = If[MatchQ[quantificationMethod, Absorbance],
				{SampleLabel, AbsorbanceAliquotAmount, AbsorbanceAliquotContainer, AbsorbanceDestinationWell},
				{SampleLabel, NephelometryAliquotAmount, NephelometryAliquotContainer, NephelometryDestinationWell}
			];

			(* Get the values from the quantification options. *)
			{sampleLabelQAP, quantificationAliquotVolumeQAP, quantificationAliquotContainerQAP, destinationWellQAP} = Lookup[$IncubateCellsQuantificationOptions, optionNames];

			(* Create a lookup from the cellType to the preferred BSC transfer environment. *)
			cellTypeToBSC = {
				(* Model[Instrument, BiosafetyCabinet, "Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Microbial)"] *)
				Bacterial -> Model[Instrument, BiosafetyCabinet, "id:WNa4ZjKZpBeL"],
				(* Model[Instrument, BiosafetyCabinet, "Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Tissue Culture)"] *)
				Mammalian -> Model[Instrument, BiosafetyCabinet, "id:dORYzZJzEBdE"],
				(* Model[Instrument, BiosafetyCabinet, "Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Microbial)"] *)
				Yeast | Plant | Insect | Fungal -> Model[Instrument, BiosafetyCabinet, "id:WNa4ZjKZpBeL"]
			};

			(* Generate the primitive. *)
			Transfer @ {
				Source -> sampleLabelQAP,
				Destination -> quantificationAliquotContainerQAP,
				Amount -> quantificationAliquotVolumeQAP,
				DestinationWell -> destinationWellQAP,
				TransferEnvironment -> cellTypes /. cellTypeToBSC,
				KeepSourceCovered -> True,
				KeepDestinationCovered -> True,
				SterileTechnique -> True,
				ImageSample -> False,
				MeasureWeight -> False,
				MeasureVolume -> False
			}
		]
	];

	(* In quantification protocols where we do not aliquot, the time the cells spend in the incubator is exactly the QuantificationInterval. HOWEVER, *)
	(* when we aliquot for quantification, the cells go back into the incubator after the aliquot and the processing step does not start right away. *)
	(* This leads to a disparity which we correct for later, storing the correct values in the field QuantificationProcessingTimes. IMPORTANTLY, this needs to have *)
	(* length == MaxNumberOfQuantifications whether we are aliquoting or not because we loop over this field in the procedure whenever we are quantifying. *)
	(* We initialize this here and will update it as needed during the procedure using the execute incubateCellsParseQuantification. *)
	quantificationProcessingTimes = If[MatchQ[quantificationMethod, Alternatives[Absorbance, Nephelometry, ColonyCount]],
		ConstantArray[quantificationInterval, maxNumberOfQuantifications],
		{}
	];

	(* If the FailureResponse is Freeze, we have to generate FreezeCells unit operations and store them in the IncubateCells protocol object. *)
	(* This normally wouldn't require running ExperimentFreezeCells here, but we also need to simulate the failure response, so we run the experiment *)
	(* function and pass the simulation from the resource packets into the main function after simulating everything else. *)
	{failureResponseUnitOperation, failureResponseSimulation} = If[
		(* For now, the only failure response we support that requires a unit operation is Freeze. *)
		!MatchQ[failureResponse, Freeze],
		{Null, Null},
		(* Note that we have to use either 2 mL or 5 mL cryovials because those fit our MrFrosty racks. We're going to add a 50% volume equivalent of cryoprotectant. *)
		(* So set the cutoff volumes to 3 mL for a 5mL cryovial and 1.2 mL for a 2mL vial (for a final max volume of 1.8 mL for a 2mL vial and 4.5 mL for a 5mL vial). *)
		(* We'll use the same size vial and hence the same size MrFrosty container for all samples to hopefully keep this as operationally simple as possible. *)
		Module[
			{
				inputSampleVolumes, failureSampleVolumes, largestSampleVolumeUponFailure, cryogenicSampleContainer,
				numberOfReplicates, freezeCellsResolvedOptions, freezeCellsProtocolPacketWithResources, freezeCellsSimulation, freezeCellsUnitOperation
			},

			(* Get the current volumes of all the input samples. *)
			inputSampleVolumes = ToList[Lookup[samplePackets, Volume]];

			(* The input sample volume we have to simulate is not the current volume of the sample but the volume *)
			(* of each sample upon failure, i.e. once we have already done the maximum number of quantifications. *)
			(* Get the sample volumes upon failure. *)
			failureSampleVolumes = MapThread[
				Function[
					{inputVolume, aliquotVolume},
					If[!quantificationAliquotBool || quantificationRecoupSampleBool,
						(* If the sample is not aliquoted OR if the aliquots are recouped, the sample volume upon failure is equal to the input volume. *)
						inputVolume,
						(* If we're aliquoting and not recouping the aliquoted volume, assume that the volume upon failure is the input volume minus the aliquot volume. *)
						(* We only subtract the aliquot volume once (even though we could be aliquoting multiple times before failure) because there is a scenario in *)
						(* which we go into troubleshooting while the sample is in the incubator and exceed the total Time before doing the max number of quantifications. *)
						(* In other words, we're only guaranteed to aliquot one time, and it is safer to overestimate the sample volume here than to underestimate it. *)
						inputVolume - aliquotVolume
					]
				],
				{inputSampleVolumes, quantificationAliquotVolumes}
			];

			(* Get the largest sample volumes upon failure. *)
			largestSampleVolumeUponFailure = Max[failureSampleVolumes];

			(* Determine whether to use 2mL or 5mL vials based on the largest sample volume. *)
			cryogenicSampleContainer = If[MatchQ[largestSampleVolumeUponFailure, LessEqualP[1.2 Milliliter]],
				Model[Container, Vessel, "id:vXl9j5qEnnOB"], (* Model[Container, Vessel, "2mL Cryogenic Vial"] *)
				Model[Container, Vessel, "id:o1k9jAG1Nl57"]  (* Model[Container, Vessel, "5mL Cryogenic Vial"] *)
			];

			(* Determine the number of replicates based on the largest volume. *)
			numberOfReplicates = If[MatchQ[cryogenicSampleContainer, ObjectP[Model[Container, Vessel, "id:vXl9j5qEnnOB"]]],
				Ceiling[largestSampleVolumeUponFailure / (1 Milliliter)],
				Ceiling[largestSampleVolumeUponFailure / (2.5 Milliliter)]
			];

			(* Run ExperimentFreezeCells to get the resolved options and simulation. *)
			{freezeCellsResolvedOptions, freezeCellsProtocolPacketWithResources, freezeCellsSimulation} = Quiet[
				ExperimentFreezeCells[
					mySamples,
					CellType -> cellTypes,
					CultureAdhesion -> cultureAdhesions,
					CryogenicSampleContainer -> cryogenicSampleContainer,
					FreezingStrategy -> InsulatedCooler,
					Aliquot -> True,
					AliquotVolume -> failureSampleVolumes/numberOfReplicates,
					CryoprotectionStrategy -> AddCryoprotectant,
					CryoprotectantSolution -> Model[Sample, StockSolution, "id:E8zoYvzX1NKB"], (* Model[Sample, StockSolution, "50% Glycerol in Milli-Q water, Autoclaved"] *)
					CryoprotectantSolutionVolume -> 0.5 * failureSampleVolumes/numberOfReplicates,
					NumberOfReplicates -> numberOfReplicates /. {1 -> Null},
					Output -> {Options, Result, Simulation},
					Simulation -> simulation,
					Cache -> cache,
					Upload -> False
				],
				(* Quieting FreezeCellsUnusedSample because we haven't passed any sample transfer simulations from the child Quantify function in and it will give false positives. *)
				(* Also Quiet warnings for instrument precision and replicate labels because we're very likely to trip these but they are not problematic. *)
				{Warning::FreezeCellsUnusedSample, Download::MissingCacheField, Warning::InstrumentPrecision, Warning::FreezeCellsReplicateLabels}
			];

			(* Note that we could in theory get a unit operation object from the above experiment call, but this would require us to upload. *)
			(* Instead, we generate the primitive from the resolved options and we don't upload anything to the database in doing so. *)
			(* We are casing out the options with Null values because they aren't needed and to guarantee that our unit op matches FreezeCellsP. *)
			(* Also remove the CryogenicSampleContainerLabel specification, so that we don't feed pre-expanded replicate labels into MCP. *)
			freezeCellsUnitOperation = FreezeCells @ {
				Sample -> mySamples,
				Sequence @@ Cases[freezeCellsResolvedOptions, Except[(_ -> Null) | (CryogenicSampleContainerLabel -> _)]]
			};

			(* Return the batched unit operations and the simulation. *)
			{freezeCellsUnitOperation, freezeCellsSimulation}
		]
	];

	(* Update our simulation with the failure response simulation. *)
	simulationWithFailureResponse = If[MatchQ[failureResponseSimulation, SimulationP],
		UpdateSimulation[simulation, failureResponseSimulation],
		simulation
	];

	(* --- Batch the manual stuff --- *)

	(* We want to work with everything in terms of Containers*)
	(* Get the first position of each unique container *)
	uniqueContainerPositions = FirstPosition[containers,#]&/@inputContainersNoDupes;

	(* Replace all Nones with Nulls in minQuantificationTargets so that we match the storage pattern for the protocol object. *)
	(* This is only necessary for the protocol object; we use splitfields for MinQuantificationTarget in the unit operation object. *)
	minQuantificationTargetsWithoutNone = minQuantificationTargets /. {None -> Null};
	
	(* Group the options by incubation condition; really all I want here are the custom incubations that I can then put together in a UnitOperation object *)
	(* the default incubations will get made during an execute function later *)
	groupedOptions = groupByKey[
		{
			Container -> Link /@ (Extract[containers, uniqueContainerPositions] /. containerResourceRules),
			Time -> time,
			CellType -> Extract[cellTypes, uniqueContainerPositions],
			CultureAdhesion -> Extract[cultureAdhesions, uniqueContainerPositions],
			Temperature -> Extract[temperatures, uniqueContainerPositions],
			CarbonDioxide -> Extract[carbonDioxidePercentages, uniqueContainerPositions],
			RelativeHumidity -> Extract[relativeHumidities, uniqueContainerPositions],
			Shake -> Extract[shakes, uniqueContainerPositions],
			ShakingRate -> Extract[shakingRates, uniqueContainerPositions],
			ShakingRadius -> Extract[shakingRadii, uniqueContainerPositions],
			Incubator -> Extract[instrumentResourcesLink, uniqueContainerPositions],
			SamplesOutStorageCondition -> Extract[samplesOutStorageConditionSymbols, uniqueContainerPositions],
			IncubationCondition -> Extract[incubationConditions, uniqueContainerPositions],
			FailureResponse -> failureResponse,
			QuantificationMethod -> quantificationMethod,
			QuantificationInstrument -> Link[quantificationInstrument],
			QuantificationInterval -> quantificationInterval,
			MinQuantificationTarget -> Extract[minQuantificationTargets, uniqueContainerPositions],
			QuantificationTolerance -> Extract[quantificationTolerances, uniqueContainerPositions],
			QuantificationAliquotVolume -> Extract[quantificationAliquotVolumes, uniqueContainerPositions],
			QuantificationRecoupSample -> quantificationRecoupSampleBool,
			QuantificationBlank -> Link /@ Extract[quantificationBlanks, uniqueContainerPositions],
			QuantificationWavelength -> Extract[quantificationWavelengths, uniqueContainerPositions],
			QuantificationStandardCurve -> Link /@ Extract[quantificationStandardCurves, uniqueContainerPositions]
		},
		(* note that we don't actually have to do any grouping if we're doing robotic *)
		If[roboticQ,
			{},
			{IncubationCondition}
		]
	];

	(* Get the custom incubation options *)
	customIncubationOptions = FirstCase[groupedOptions, {{IncubationCondition -> Custom}, customOptions:{__Rule}} :> customOptions, Null];

	(* Make the IDs for the protocol object and the unit operation objects *)
	{protocolID, unitOperationID} = Which[
		(* for robotic, don't need to do either of these *)
		roboticQ, {Null, Null},
		(* for manual with no custom, only need to make protocol object *)
		Not[MemberQ[incubationConditions, Custom]], {CreateID[Object[Protocol, IncubateCells]], {}},
		(* for manual with custom, we need to make precisely one unit operation object (because we can only have one custom batch) *)
		True, CreateID[{Object[Protocol, IncubateCells], Object[UnitOperation, IncubateCells]}]
	];

	(* Get all the non-hidden options that go into the unit operation objects *)
	nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, IncubateCells]];

	(* Drop the MinQuantificationTarget from the nonHiddenOptions so that we can add in the version without Nones later. *)
	nonHiddenOptionsWithoutTarget = DeleteCases[nonHiddenOptions, MinQuantificationTarget];

	(* Generate the relevant unit operation packets, simulation with robotic unit ops, and run time. *)
	{unitOperationPacket, simulationWithRoboticUOs, runTime} = Which[
		(* Nothing is needed here if we are doing manual incubation in default incubators only. *)
		!roboticQ && NullQ[customIncubationOptions],
			{{}, simulation, Null},
		(* If we're manual and have a custom incubator, generate a unit operation for custom incubation. *)
		!roboticQ,
			Module[{customUnitOperation, unitOpPacket},

				customUnitOperation = IncubateCells @@ ReplaceRule[
					Cases[myResolvedOptions, Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
					{
						Sample -> Lookup[customIncubationOptions, Container],
						Time -> Lookup[customIncubationOptions, Time],
						CellType -> Lookup[customIncubationOptions, CellType],
						CultureAdhesion -> Lookup[customIncubationOptions, CultureAdhesion],
						Temperature -> Lookup[customIncubationOptions, Temperature],
						CarbonDioxide -> Lookup[customIncubationOptions, CarbonDioxide],
						RelativeHumidity -> Lookup[customIncubationOptions, RelativeHumidity],
						Shake -> Lookup[customIncubationOptions, Shake],
						ShakingRate -> Lookup[customIncubationOptions, ShakingRate],
						ShakingRadius -> Lookup[customIncubationOptions, ShakingRadius],
						Incubator -> Lookup[customIncubationOptions, Incubator],
						SamplesOutStorageCondition -> Lookup[customIncubationOptions, SamplesOutStorageCondition],
						IncubationCondition -> Lookup[customIncubationOptions, IncubationCondition],
						FailureResponse -> Lookup[customIncubationOptions, FailureResponse],
						QuantificationMethod -> Lookup[customIncubationOptions, QuantificationMethod],
						QuantificationInstrument -> Lookup[customIncubationOptions, QuantificationInstrument],
						QuantificationInterval -> Lookup[customIncubationOptions, QuantificationInterval],
						MinQuantificationTarget -> Lookup[customIncubationOptions, MinQuantificationTarget],
						QuantificationTolerance -> Lookup[customIncubationOptions, QuantificationTolerance],
						QuantificationAliquotVolume -> Lookup[customIncubationOptions, QuantificationAliquotVolume],
						QuantificationRecoupSample -> Lookup[customIncubationOptions, QuantificationRecoupSample],
						QuantificationBlank -> Lookup[customIncubationOptions, QuantificationBlank],
						QuantificationWavelength -> Lookup[customIncubationOptions, QuantificationWavelength],
						QuantificationStandardCurve -> Lookup[customIncubationOptions, QuantificationStandardCurve]
					}
				];

				unitOpPacket = UploadUnitOperation[
					customUnitOperation,
					UnitOperationType -> Batched,
					Preparation -> Manual,
					FastTrack -> True,
					Upload -> False
				];

				(* Return *)
				{unitOpPacket, simulation, {}}
			],
		(* Robotic branch: here we need robotic unit operations, an updated simulation, and robotic run time. *)
		True,
			Module[
				{
					quantificationPrimitive, simulatedObjectsToLabel, myResolvedOptionsWithLabels, roboticUnitOperationPackets, roboticRunTime,
					roboticSimulation, incubateCellsPrimitive, outputUnitOperationPacket, roboticSimulationOutputUO
				},
				(* Generate the QuantifyCells primitive if we are quantifying. *)
				quantificationPrimitive = Which[
					(* If we're using Nephelometry, generate a QuantifyCells unit operation with Nephelometry options specified. *)
					MatchQ[quantificationMethod, Nephelometry],
						QuantifyCells @ {
							Sample -> sampleLabels,
							Instruments -> quantificationInstrument,
							NephelometryStandardCurve -> quantificationStandardCurves,
							NephelometryAliquotContainer -> quantificationAliquotContainers,
							NephelometryAliquotAmount -> quantificationAliquotVolumes,
							NephelometryBlank -> quantificationBlanks,
							NephelometryBlankMeasurement -> quantificationBlankMeasurement,
							Wavelength -> quantificationWavelengths,
							Preparation -> Robotic
						},
					(* If we're using Absorbance, generate a QuantifyCells unit operation with Absorbance options specified. *)
					MatchQ[quantificationMethod, Absorbance],
						QuantifyCells @ {
							Sample -> sampleLabels,
							Instruments -> quantificationInstrument,
							AbsorbanceStandardCurve -> quantificationStandardCurves,
							AbsorbanceAliquotContainer -> quantificationAliquotContainers,
							AbsorbanceAliquotAmount -> quantificationAliquotVolumes,
							AbsorbanceBlank -> quantificationBlanks,
							AbsorbanceBlankMeasurement -> quantificationBlankMeasurement,
							Wavelength -> quantificationWavelengths,
							Preparation -> Robotic
						},
					(* Otherwise we are not quantifying and we do not need to generate a unit operation here. *)
					(* Note that we do not currently support the combination of robotic incubate cells with *)
					(* QuantifyColonies for quantification, as this requires two different workcells and is a fringe usde case to begin with. *)
					True, {}
				];

				(* We need to run all primitives except for the IncubateCells primitive(s) through RCP to get unit op packets and simulation. *)
				(* Ideally we'd pass in the IncubateCells primitives, too, but this would cause an endless RCP cascade. *)
				allPrimitivesExceptIncubateCells = Flatten[{labelSamplePrimitive, ConstantArray[quantificationPrimitive, maxNumberOfQuantifications]}];

				{{roboticUnitOperationPackets, roboticRunTime}, roboticSimulation} = ExperimentRoboticCellPreparation[
					allPrimitivesExceptIncubateCells,
					UnitOperationPackets -> True,
					Output -> {Result, Simulation},
					FastTrack -> Lookup[myResolvedOptions, FastTrack],
					ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol],
					Name -> Lookup[myResolvedOptions, Name],
					Simulation -> simulation,
					Upload -> False,
					ImageSample -> Lookup[myResolvedOptions, ImageSample, False],
					MeasureVolume -> Lookup[myResolvedOptions, MeasureVolume, False],
					MeasureWeight -> Lookup[myResolvedOptions, MeasureWeight, False],
					Priority -> Lookup[myResolvedOptions, Priority],
					StartDate -> Lookup[myResolvedOptions, StartDate],
					HoldOrder -> Lookup[myResolvedOptions, HoldOrder],
					QueuePosition -> Lookup[myResolvedOptions, QueuePosition],
					(* We need to set OptimizeUnitOperations to False since the order very much matters for quantification. *)
					OptimizeUnitOperations -> False,
					CoverAtEnd -> False,
					Debug -> False
				];

				(* Combine the primitives to pass into RCP. *)
				incubateCellsRoboticPrimitive = Module[
					{quantifyQ, roboticIncubationTime},
					(* Set a flag for whether we are quantifying. *)
					quantifyQ = MatchQ[maxNumberOfQuantifications, GreaterP[0]];
					(* If we are quantifying, use the quantification interval for the time. Otherwise use the value of the Time option. *)
					roboticIncubationTime = If[quantifyQ, quantificationInterval, time];
					(* Now generate the primitive. *)
					IncubateCells @@ {
						SampleLabel -> sampleLabels,
						SampleContainerLabel -> sampleContainerLabels,
						CellType -> cellTypes,
						CultureAdhesion -> cultureAdhesions,
						Incubator -> instrumentResourcesLink,
						Time -> roboticIncubationTime,
						IncubationCondition -> Custom,
						Temperature -> temperatures,
						CarbonDioxide -> carbonDioxidePercentages,
						RelativeHumidity -> relativeHumidities,
						Shake -> shakes,
						ShakingRadius -> shakingRadii,
						ShakingRate -> shakingRates
					}
				];

				(* Generate the incubate cells robotic unit op packets and insert them into the list of robotic UO packets appropriately. *)
				finalRoboticUnitOperationPackets = Module[
					{numberOfIncubationCycles, incubateCellsRoboticUnitOperationPackets, sampleLink, modifiedIncubateCellsRoboticUnitOperationPackets},
					(* Find the number of incubation cycles we need, which is at least 1. *)
					numberOfIncubationCycles = Max[maxNumberOfQuantifications, 1];
					(* Generate the incubate cells robotic unit operations. *)
					incubateCellsRoboticUnitOperationPackets = UploadUnitOperation[
						ConstantArray[incubateCellsRoboticPrimitive, numberOfIncubationCycles],
						Preparation -> Robotic,
						UnitOperationType -> Output,
						FastTrack -> True,
						Upload -> False
					];
					(* Get SampleLink and ContainerLink from the LabelSample primitive. *)
					sampleLink = Lookup[roboticUnitOperationPackets[[1]], Replace[SampleLink]];
					(* Add the samples, containers, and their labels in. *)
					modifiedIncubateCellsRoboticUnitOperationPackets = Map[
						Function[{incubateCellsRoboticUOPacket},
							Join[
								incubateCellsRoboticUOPacket,
								Association[
									Replace[SampleLabel] -> sampleLabels,
									Replace[SampleContainerLabel] -> sampleContainerLabels,
									Replace[SampleLink] -> sampleLink,
									Replace[LabeledObjects] -> Transpose @ {sampleLabels, sampleLink}
								]
							]
						],
						incubateCellsRoboticUnitOperationPackets
					];
					(* Combine the robotic unit operation packets in the correct order. This looks rather hairy but the idea is to begin with our *)
					(* LabelSample primitive, then alternate between IncubateCells primitives and whatever primitives are needed for quantification. *)
					(* The ArrayReshape call partitions whatever primitives are generated for quantification into sublists, e.g. *)
					(*
						{
							Object[UnitOperation, QuantifyCells], Object[UnitOperation, LabelSample], Object[UnitOperation, AbsorbanceIntensity],
							Object[UnitOperation, QuantifyCells], Object[UnitOperation, LabelSample], Object[UnitOperation, AbsorbanceIntensity],
							Object[UnitOperation, QuantifyCells], Object[UnitOperation, LabelSample], Object[UnitOperation, AbsorbanceIntensity]
						}
						becomes
						{
							{Object[UnitOperation, QuantifyCells], Object[UnitOperation, LabelSample], Object[UnitOperation, AbsorbanceIntensity]},
							{Object[UnitOperation, QuantifyCells], Object[UnitOperation, LabelSample], Object[UnitOperation, AbsorbanceIntensity]},
							{Object[UnitOperation, QuantifyCells], Object[UnitOperation, LabelSample], Object[UnitOperation, AbsorbanceIntensity]}
						}
					*)
					(* We then use Riffle to slot in the IncubateCells primitives before each grouping of quantification primitives. *)
					Flatten[{
						roboticUnitOperationPackets[[1]],
						Riffle[
							modifiedIncubateCellsRoboticUnitOperationPackets,
							ArrayReshape[
								roboticUnitOperationPackets[[2;;]],
								{numberOfIncubationCycles, (Length[roboticUnitOperationPackets] - 1)/numberOfIncubationCycles}]
						]
					}]
				];

				(* determine which objects in the simulation are simulated and make replace rules for those *)
				simulatedObjectsToLabel = If[NullQ[roboticSimulation],
					{},
					Module[{allObjectsInSimulation, simulatedQ},
						(* Get all objects out of our simulation. *)
						allObjectsInSimulation = Download[Lookup[roboticSimulation[[1]], Labels][[All, 2]], Object];
						(* Figure out which objects are simulated. *)
						simulatedQ = Experiment`Private`simulatedObjectQs[allObjectsInSimulation, roboticSimulation];
						(Reverse /@ PickList[Lookup[roboticSimulation[[1]], Labels], simulatedQ]) /. {link_Link :> Download[link, Object]}
					]
				];

				(* get the resolved options with simulated objects replaced with labels *)
				myResolvedOptionsWithLabels = myResolvedOptions /. simulatedObjectsToLabel;

				(* Generate the incubate cells primitive(s). If we are quantifying more than one time, we set the time to the quantification interval *)
				(* and split the incubation into multiple IncubateCells unit operations, following each with a quantification unit operation. *)
				incubateCellsPrimitive = IncubateCells @@ Join[
					Cases[myResolvedOptionsWithLabels, Verbatim[Rule][Alternatives @@ nonHiddenOptionsWithoutTarget, _]],
					{
						Sample -> sampleResources,
						MinQuantificationTarget -> minQuantificationTargets,
						RoboticUnitOperations -> If[Length[finalRoboticUnitOperationPackets] == 0,
							{},
							(Link /@ Lookup[finalRoboticUnitOperationPackets, Object])
						]
					}
				];

				(* Upload the IncubateCells output unit operation. *)
				outputUnitOperationPacket = UploadUnitOperation[
					incubateCellsPrimitive,
					Preparation -> Robotic,
					UnitOperationType -> Output,
					FastTrack -> True,
					Upload -> False
				];

				roboticSimulationOutputUO = UpdateSimulation[
					roboticSimulation,
					Module[{protocolPacket},
						protocolPacket = <|
							Object -> SimulateCreateID[Object[Protocol, RoboticCellPreparation]],
							Replace[OutputUnitOperations] -> (Link[Lookup[outputUnitOperationPacket, Object], Protocol]),
							ResolvedOptions -> {}
						|>;
						SimulateResources[
							protocolPacket,
							Flatten[{outputUnitOperationPacket, finalRoboticUnitOperationPackets}],
							ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null],
							Simulation -> simulation
						]
					]
				];

				(* The final robotic run time is the one we got from RCP plus any incubation time. *)
				finalRoboticRunTime = If[MatchQ[maxNumberOfQuantifications, GreaterP[0]],
					maxNumberOfQuantifications * quantificationInterval,
					time
				];

				(* Return *)
				{Flatten @ {outputUnitOperationPacket, finalRoboticUnitOperationPackets}, roboticSimulationOutputUO, roboticRunTime + 10 Minute}
			]
	];

	(* Generate the raw protocol packet *)
	manualProtocolPacket = If[!roboticQ,
		Module[
			{safeQuantificationNumber},
			(* MaxNumberOfQuantifications and QuantificationsRemaining should be Null if we're not quantifying. *)
			safeQuantificationNumber = maxNumberOfQuantifications /. 0 -> Null;
			<|
				Object -> protocolID,
				Replace[BatchedUnitOperations] -> If[MatchQ[unitOperationPacket, {}],
					{},
					{Link[Lookup[unitOperationPacket, Object], Protocol]}
				],
				Name -> Lookup[myResolvedOptions, Name],
				Replace[SamplesIn] -> (Link[#, Protocols]& /@ sampleResources),
				Replace[ContainersIn] -> (Link[#, Protocols]& /@ sampleContainerResources),
				(* if we are in the root protocol here, then mark it as Overclock -> True *)
				(* if we're not in the root protocol here, then don't worry about it and in the parent function we will mark the root as Overclock -> True *)
				(* if we're robotic then it will get set in RCP itself *)
				If[NullQ[parentProtocol],
					Overclock -> True,
					Nothing
				],
				Time -> time,
				FailureResponse -> failureResponse,
				FailureResponseUnitOperation -> failureResponseUnitOperation,
				QuantificationMethod -> quantificationMethod,
				QuantificationInstrument -> Link[quantificationInstrument],
				QuantificationInterval -> quantificationInterval,
				MaxNumberOfQuantifications -> safeQuantificationNumber,
				QuantificationsRemaining -> safeQuantificationNumber,
				QuantificationRecoupSample -> quantificationRecoupSampleBool,
				Replace[Incubators] -> instrumentResourcesLink,
				Replace[IncubationConditions] -> incubationConditionSymbols,
				Replace[IncubationConditionObjects] -> Link[incubationConditionObjects],
				Replace[Temperatures] -> temperatures,
				Replace[RelativeHumidities] -> relativeHumidities /. Ambient -> Null,
				Replace[CarbonDioxide] -> carbonDioxidePercentages /. Ambient -> Null,
				Replace[CellTypes] -> cellTypes,
				Replace[CultureAdhesions] -> cultureAdhesions,
				Replace[ShakingRates] -> shakingRates,
				Replace[ShakingRadii] -> shakingRadii,
				Replace[DefaultIncubationContainers] -> (Link[#] & /@ defaultIncubationContainerResources),
				Replace[PostDefaultIncubationContainers] -> (Link[#]& /@ postDefaultIncubationContainerResources),
				Replace[NonIncubationStorageContainers] -> Link /@ nonIncubationStorageContainerResources,
				Replace[NonIncubationStorageContainerConditions] -> nonIncubationStorageContainerConditions,
				Replace[SamplesOutStorage] -> samplesOutStorageConditionSymbols,
				Replace[MinQuantificationTargets] -> minQuantificationTargetsWithoutNone,
				Replace[QuantificationTolerances] -> quantificationTolerances,
				Replace[QuantificationAliquotVolumes] -> quantificationAliquotVolumes,
				Replace[QuantificationAliquotContainers] -> Link /@ quantificationAliquotContainers,
				Replace[QuantificationAliquotUnitOperation] -> quantificationAliquotUnitOperation,
				Replace[QuantificationProcessingTimes] -> quantificationProcessingTimes,
				Replace[QuantificationBlanks] -> Link /@ quantificationBlanks,
				Replace[QuantificationWavelengths] -> quantificationWavelengths,
				Replace[QuantificationStandardCurves] -> Link /@ quantificationStandardCurves,
				UnresolvedOptions -> unresolvedOptionsNoHidden,
				ResolvedOptions -> resolvedOptionsNoHidden,
				Replace[Checkpoints] -> {
					{"Reserving Incubators", 5 Minute, "Reservations of StorageAvailability of Default incubators.", Link[Resource[Operator -> $BaselineOperator, Time -> 5 Minute]]},
					{"Loading Incubators", 30 Minute, "Store containers into cell incubators with desired incubation conditions-PreIncubation Loop.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
					{"Incubating Samples", time, "Keep containers inside of cell incubators with desired incubation conditions.", Link[Resource[Operator -> $BaselineOperator, Time -> time]]},
					{"Storing Samples", 30 Minute, "Store containers into SamplesOutStorageCondition -PostIncubation Loop.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]}
				}
			|>
		],
		{}
	];

	(* Get all of the resource out of the packet so they can be tested*)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[{unitOperationPacket, manualProtocolPacket}], _Resource, Infinity]];

	(* Call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		(* don't need to do this here because framework will already call it itself for the robotic case *)
		roboticQ, {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Site -> Lookup[myResolvedOptions, Site], Simulation -> simulationWithFailureResponse, Cache -> cache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Site -> Lookup[myResolvedOptions, Site], Simulation -> simulationWithFailureResponse, Messages -> messages, Cache -> cache], Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule = Preview -> Null;

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[ExperimentIncubateCells, myResolvedOptions],
		Null
	];

	(* Generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		{}
	];

	(* Generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> Which[
		!roboticQ && MemberQ[output, Result] && TrueQ[fulfillable],
			{manualProtocolPacket, unitOperationPacket, Null, failureResponseSimulation, Null},
		(* for robotic, the result is Null for the protocol packet (because we're going to generate the real thing later in RoboticCellPreparation) *)
		MemberQ[output, Result] && TrueQ[fulfillable],
			{Null, unitOperationPacket, simulationWithRoboticUOs, failureResponseSimulation, runTime},
		True, $Failed
	];

	(* Return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];

(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentIncubateCells,
	Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentIncubateCells[
	myProtocolPacket : (PacketP[Object[Protocol, IncubateCells], {Object, ResolvedOptions}] | $Failed | Null),
	myUnitOperationPackets : ListableP[(PacketP[]...) | $Failed],
	myQuantificationPacket : (PacketP[{Object[Protocol, QuantifyColonies], Object[UnitOperation, QuantifyColonies], Object[Protocol, QuantifyCells], Object[UnitOperation, QuantifyCells]}] | Null | $Failed),
	mySamples : {ObjectP[Object[Sample]]...},
	myResolvedOptions : {_Rule...},
	myResolutionOptions : OptionsPattern[simulateExperimentIncubateCells]
] := Module[
	{cache, simulation, fastAssoc, samplePackets, protocolObject, resolvedPreparation, fulfillmentSimulation, updatedSimulation, labelSimulation},

	(* Lookup our cache and simulation. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
	fastAssoc = makeFastAssocFromCache[cache];

	(* Download containers from our sample packets. *)
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;

	(* Lookup our resolved preparation option. *)
	resolvedPreparation = Lookup[myResolvedOptions, Preparation];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = Which[
		(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
		(* simulate an ID here in the simulation function in order to call SimulateResources. *)
		MatchQ[resolvedPreparation, Robotic],
			SimulateCreateID[Object[Protocol, RoboticCellPreparation]],
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myProtocolPacket, $Failed],
			SimulateCreateID[Object[Protocol, IncubateCells]],
		True,
			Lookup[myProtocolPacket, Object]
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	fulfillmentSimulation = Which[
		(* When Preparation -> Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticCellPreparation] so that we can call SimulateResources. *)
		MatchQ[myProtocolPacket, Null] && MatchQ[myUnitOperationPackets, ListableP[PacketP[Object[UnitOperation]]]],
			Module[{protocolPacket},
				protocolPacket = <|
					Object -> protocolObject,
					Replace[SamplesIn] -> (Resource[Sample -> #]&) /@ mySamples,
					(* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
					(* simulate resources will NOT simulate them for you. *)
					(* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
					Replace[RequiredObjects] -> DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type -> Except[Object[Resource, Instrument]]]], Infinity]
					],
					(* not sure when we'll ever need to do this but we can keep it for now *)
					Replace[RequiredInstruments] -> DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]], Infinity]
					],
					ResolvedOptions -> {}
				|>;

				SimulateResources[
					protocolPacket,
					ToList[myUnitOperationPackets],
					ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null],
					Cache -> cache,
					Simulation -> simulation
				]
			],

		(* Otherwise, our resource packets went fine and we have an Object[Protocol, IncubateCells]. *)
		True,
			SimulateResources[
				myProtocolPacket,
				ToList[myUnitOperationPackets],
				Cache -> cache,
				Simulation -> simulation
			]
	];

	(* Update the simulations with the quantifications. *)
	updatedSimulation = If[MatchQ[resolvedPreparation, Robotic],
		(* If we are Robotic, we do not need to update here since this was already done in the resource packets. *)
		simulation,
		(* For manual, we have to simulate all of the possible quantification steps here. *)
		Module[
			{
				simulationWithFirstQuantification, quantificationInterval, maxTime, maxQuantifications,
				quantificationType, resolvedQuantificationOptions, unresolvedQuantificationOptions,
				quantificationFunction, additionalSimulationsQ, updatedSimulationWithQuantifications
			},

			(* Update the fulfillment simulation with the quantification simulation from the resource packets. *)
			simulationWithFirstQuantification = UpdateSimulation[fulfillmentSimulation, simulation];
			(* Get the QuantificationInterval and Time fields from the IncubateCells protocol packet or unit operation packet if there is a custom condition. *)
			{quantificationInterval, maxTime} = If[NullQ[myProtocolPacket],
				Lookup[ToList[myUnitOperationPackets][[1]], {QuantificationInterval, Time}],
				Lookup[myProtocolPacket, {QuantificationInterval, Time}]
			];
			(* From these, calculate the maximum number of quantifications. *)
			maxQuantifications = If[NullQ[quantificationInterval],
				Null,
				Floor[maxTime/quantificationInterval]
			];
			(* Get the quantification type and the resolved and unresolved options from the quantification Packet *)
			{quantificationType, resolvedQuantificationOptions, unresolvedQuantificationOptions} = If[NullQ[myQuantificationPacket],
				{Null, Null, Null},
				Lookup[myQuantificationPacket, {Type, ResolvedOptions, UnresolvedOptions}]
			];
			(* Get the quantification function from the type. *)
			quantificationFunction = If[MatchQ[quantificationType, TypeP[]], quantificationType[[-1]], Null];

			(* We may need to perform successive simulations if we're running quantify cells with aliquoting turned on and the max number of quantifications is greater than one. *)
			(* We're making the conservative assumption that the maximum number of quantification events will always take place. *)
			(* We don't need to do this for QuantifyColonies because there is no aliquoting required in that case. *)
			additionalSimulationsQ = Which[
				(* If we are quantifying colonies or not quantifying at all, we don't need to run any more quantify simulations. *)
				MatchQ[quantificationFunction, QuantifyColonies|Null], False,
				(* If the max number of quantifications is one, we've already simulated that one quantification. *)
				MatchQ[maxQuantifications, LessP[2]], False,
				(* Else, we have to simulate every subsequent quantification. *)
				True, True
			];

			(* Run the simulation for the subsequent quantification steps, if applicable. *)
			updatedSimulationWithQuantifications = If[additionalSimulationsQ,
				Module[
					{
						checkpointsRule, quantificationPacketWithCheckpoints, quantificationSimulations, quantificationCounter, newestSimulation, simulationWithMostRecentQuantification
					},

					(* The checkpoints don't get passed into the quantification packet, and this can disrupt the processing of the operator *)
					(* resources when we run SimulateResources. To avoid this, we generate checkpoints with rough time estimates here. *)
					checkpointsRule = Replace[Checkpoints] -> {
						{"Quantifying Samples", 30 * Minute, "Cell concentrations of the input samples are measured by different experimental instrumentation specified in Methods.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 * Minute]]},
						{"Returning Materials", 20 * Minute, "Samples are retrieved from instrumentation and materials are cleaned and returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 20 * Minute]]}
					};
					(* Drop the existing checkpoints and replace with the ones we just created. *)
					(* Also make sure we're passing in the samples, which can be messed up here if these samples are simulated. *)
					quantificationPacketWithCheckpoints = Join[myQuantificationPacket, <|checkpointsRule, SamplesIn -> mySamples|>];

					(* Initialize a list of quantification simulations, starting with the one we got from calling the child experiment function in the resolver. *)
					(* Also set a quantification counter so we know when to stop looping. It starts at 2 because we've already simulated the first quantification. *)
					quantificationSimulations = {simulationWithFirstQuantification};
					quantificationCounter = 2;

					(* Simulate QuantifyCells for each subsequent quantification up until the maximum number of possible quantifications, updating along the way. *)
					(* This iterative simulation is not ideal, but it seems to be the least bad of all the alternatives for the time being. *)
					(* Remember that we already simulated once, so we're simulating one less than the max number of quantification rounds here. *)

					While[MatchQ[quantificationCounter, LessEqualP[maxQuantifications]],
							(* Now run the simulation for ExperimentQuantifyCells and take the second part of the output, since the first part is the protocol object. *)
							newestSimulation = simulateExperimentQuantifyCells[
								quantificationPacketWithCheckpoints,
								{},
								mySamples,
								unresolvedQuantificationOptions,
								resolvedQuantificationOptions,
								Cache -> cache,
								Simulation -> quantificationSimulations[[-1]]
							][[2]];
							(* Update the current simulation with this latest simulation. *)
							simulationWithMostRecentQuantification = UpdateSimulation[quantificationSimulations[[-1]], newestSimulation];
							(* Append this simulation to our list of quantification simulations. *)
							quantificationSimulations = Append[quantificationSimulations, simulationWithMostRecentQuantification];
							(* Iterate the quantifcation counter. *)
							quantificationCounter++
						];

					(* Once we've looped over all of the above, the list item in the quantificationSimulations list is the one we want. *)
					quantificationSimulations[[-1]]
				],
				(* If we didn't have to do any of the additional simulations, we just keep the first one. *)
				simulationWithFirstQuantification
			]
		]
	];

	(* --- Upload Labels for unit operations --- *)
	labelSimulation = Simulation[
		Labels -> Join[
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], Lookup[samplePackets, Object]}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Lookup[samplePackets, Container]}],
				{_String, ObjectP[]}
			]
		],
		LabelFields -> If[MatchQ[Lookup[myResolvedOptions, Preparation], Manual],
			Join[
				Rule @@@ Cases[
					Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&) /@ Range[Length[mySamples]]}],
					{_String, _}
				],
				Rule @@@ Cases[
					Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleLink[[#]][Container]]&) /@ Range[Length[mySamples]]}],
					{_String, _}
				]
			],
			{}
		]
	];

	(* Merge our packets with our simulation. *)
	{
		protocolObject,
		UpdateSimulation[updatedSimulation, labelSimulation]
	}
];

(* ::Subsubsection:: *)
(* Helper functions*)
(* nonDeprecatedIncubatorsSearch - memoized to prevent multiple round trips to the database in one kernel session*)
nonDeprecatedIncubatorsSearch[testString: _String] := nonDeprecatedIncubatorsSearch[testString] = Module[{},
	(*Add nonDeprecatedIncubatorsSearch to list of Memoized functions*)
	AppendTo[$Memoization, Experiment`Private`nonDeprecatedIncubatorsSearch];

	Flatten@Search[
		{
			Model[Instrument, Incubator]
		},
		(*don't want incubators that are not _cell_ incubators *)
		Deprecated == (False|Null) && DeveloperObject != True && CellTypes != Null
	]
];

(* Find all possible racks (we need this for determining if containers will fit in the incubator racks)
 Memoizes the result after first execution to avoid repeated database trips within a single kernel session.*)
allIncubatorRacksSearch[testString: _String] := allIncubatorRacksSearch[testString] = Module[{},
	(*Add allIncubatorRacksSearch to list of Memoized functions*)
	AppendTo[$Memoization, Experiment`Private`allIncubatorRacksSearch];
	Search[Model[Container, Rack], Deprecated != True && Footprint == CellIncubatorRackP, SubTypes -> False]
];

(* Find all possible Decks (we need this to see which racks are associated with each incubator for those that have them, and the dimension of the decks for those without racks)
 Memoizes the result after first execution to avoid repeated database trips within a single kernel session.*)
allIncubatorDecksSearch[testString: _String] :=allIncubatorDecksSearch[testString] = Module[{},
	(*Add allIncubatorDecksSearch to list of Memoized functions*)
	AppendTo[$Memoization, Experiment`Private`allIncubatorDecksSearch];
	Search[Model[Container, Deck], Deprecated != True && Footprint == CellIncubatorDeckP, SubTypes -> False]
];

(* find all possible incubation conditions; note that this, weirdly, includes _all_ storage conditions because we need information about non-incubation ones too (so that if someone tries something we know it's wrong I think?  maybe revisit this later) *)
allIncubationStorageConditions[testString_String] := allIncubationStorageConditions[testString] = Module[{},
	(*Add allIncubationStorageConditions to list of Memoized functions*)
	AppendTo[$Memoization, Experiment`Private`allIncubationStorageConditions];
	Search[Model[StorageCondition], DeveloperObject != True]
];

(* ::Subsubsection:: *)
(*compatibleCellIncubationContainers*)
allCellIncubationContainersSearch[testString: _String] := allCellIncubationContainersSearch[testString] = Module[{},
	(*Add compatibleCellIncubationContainers to list of Memoized functions*)
	AppendTo[$Memoization, Experiment`Private`allCellIncubationContainersSearch];
	Flatten@Search[
		{Model[Container, Plate], Model[Container, Vessel]},
		Footprint == (Erlenmeyer50mLFlask|Erlenmeyer125mLFlask|Erlenmeyer250mLFlask|Erlenmeyer500mLFlask|Erlenmeyer1000mLFlask|Plate|Conical15mLTube),
		SubTypes -> False
	]
];

(* ::Subsubsection:: *)
(*$CellIncubatorMaxCapacity*)

(* temporary variable storing the max capacity of all the relevant footprints of the incubator *)

(* FOR NOW HARD CODING BECAUSE IT IS NOT IMMEDIATELY OBVIOUS HOW TO STORE THIS IN CODE INTELLIGENTLY *)
(* making a lookup table for how many plates fit into each model of incubator we care about *)
$CellIncubatorMaxCapacity = <|
	(*"Multitron Pro with 3mm Orbit"*)
	Model[Instrument, Incubator, "id:GmzlKjY5EEG9"] -> <|Plate -> 20|>,
	(*"Multitron Pro with 25mm Orbit"*)
	Model[Instrument, Incubator, "id:AEqRl954GG0l"] -> <|Erlenmeyer1000mLFlask -> 6,  Erlenmeyer500mLFlask -> 8, Erlenmeyer250mLFlask -> 10|>,
	(*"STX44-ICBT with Humidity Control"*)
	Model[Instrument, Incubator, "id:AEqRl954GpOw"] -> <|Plate -> 20|>,
	(*"STX44-ICBT with Shaking"*)
	Model[Instrument, Incubator, "id:N80DNjlYwELl"] -> <|Plate -> 16|>,
	(*"Cytomat HERAcell 240i TT 10"*)
	Model[Instrument, Incubator, "id:Z1lqpMGjeKN9"] -> <|Plate -> 210|>,
	(*"Bactomat HERAcell 240i TT 10 for Yeast"*)
	Model[Instrument, Incubator, "id:7X104vK9ZbLR"] -> <|Plate -> 210|>,
	(*"Bactomat HERAcell 240i TT 10 for Bacteria"*)
	Model[Instrument, Incubator, "id:xRO9n3vk1JbO"] -> <|Plate -> 210|>,
	(*"Innova 44 for Yeast Plates"*)
	Model[Instrument, Incubator, "id:O81aEB4kJJre"] -> <|Plate -> 39, Conical15mLTube -> 31|>,
	(*"Innova 44 for Bacterial Plates"*)
	Model[Instrument, Incubator, "id:AEqRl954Gpjw"] -> <|Plate -> 39, Conical15mLTube -> 31|>,
	(*"Innova 44 for Bacterial Flasks"*)
	Model[Instrument, Incubator, "id:D8KAEvdqzXok"] -> <|Erlenmeyer1000mLFlask -> 6, Erlenmeyer250mLFlask -> 8, Erlenmeyer125mLFlask -> 11|>,
	(*"Innova 44 for Yeast Flasks"*)
	Model[Instrument, Incubator, "id:rea9jl1orkAx"] -> <|Erlenmeyer1000mLFlask -> 6, Erlenmeyer250mLFlask -> 8, Erlenmeyer125mLFlask -> 11|>
|>;


(* ::Subsection::Closed:: *)
(*IncubateCellsDevices*)

DefineOptions[IncubateCellsDevices,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> Temperature,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]],
					Widget[Type -> Quantity, Pattern :> GreaterP[0 Celsius], Units -> Celsius]
				],
				Description -> "Temperature at which the SamplesIn should be incubated.",
				ResolutionDescription -> "Resolves to 37 Celsius if the CellType is Mammalian for this sample, otherwise resolves to the default temperature for the specified CellType.",
				Category -> "General"
			},
			{
				OptionName -> CarbonDioxide,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent, 1 Percent],
					Units -> Percent
				],
				Description -> "Percent CO2 at which the SamplesIn should be incubated.",
				ResolutionDescription -> "Resolves to 5% if the CellType is Mammalian for this sample, otherwise resolves to the default percentage for the specified CellType.",
				Category -> "General"
			},
			{
				OptionName -> RelativeHumidity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent, 1 Percent],
					Units -> Percent
				],
				Description -> "Percent humidity at which the SamplesIn should be incubated.",
				ResolutionDescription -> "Resolves to 93% if the CellType is Mammalian, otherwise resolves to the default percentage for the specified CellType.",
				Category -> "General"
			},
			{
				OptionName -> Shake,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if any samples should be shaken during incubation.",
				ResolutionDescription -> "Resolves to True if any corresponding Shake options are set. Otherwise, resolves to False.",
				Category -> "General"
			},
			{
				OptionName -> ShakingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units -> RPM],
				Description -> "Frequency of rotation the shaking incubator instrument should use to mix the samples.",
				ResolutionDescription -> "Automatically set based on the sample container and instrument model.",
				Category -> "General"
			},
			{
				OptionName -> ShakingRadius,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CellIncubatorShakingRadiusP (*3 Millimeter, 25 Millimeter, 25.4 Millimeter*)
				],
				Description -> "Frequency of rotation the shaking incubator instrument should use to mix the samples.",
				ResolutionDescription -> "Automatically set based on the sample container and instrument model.",
				Category -> "General"
			},
			{
				OptionName -> CellType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> CellTypeP],
				Description -> "The primary types of cells that are contained within this sample.",
				ResolutionDescription -> "Automatically set based on the input. If left Null, this will resolve to Bacterial.",
				Category -> "General"
			},
			{
				OptionName -> CultureAdhesion,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> CultureAdhesionP],
				Description -> "The default type of cell culture (adherent or suspension) that should be performed when growing these cells.
				If a cell line can be cultured via an adherent or suspension culture, this is set to the most common cell culture type for the cell line.",
				ResolutionDescription -> "Automatically set based on the sample container and instrument model. If left Null, this will resolve to Suspension.",
				Category -> "General"
			}
		],
		PreparationOption,
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];


(* ::Subsubsection::Closed:: *)
(*IncubateCellsDevices - Messages*)


Error::OptionLengthDisagreement = "The options `1` do not have the same length. Please check that the lengths of any listed options match.";
Error::ConflictingIncubationConditionWithOptions = "The options `4` for inputs `1` are specified as `3`. But `1` have `4` set at `2`. Please choose a different StorageCondition as input or let the option value resolves automatically.";


(* ::Subsubsection::Closed:: *)
(* IncubateCellsDevices - Instrument Download Fields *)

cellIncubatorInstrumentDownloadFields[]:={
	Name,Model,Objects,Mode,CellTypes,ShakingRadius,MinShakingRate,MaxShakingRate,DefaultShakingRate,
	Positions,MinTemperature,MaxTemperature,DefaultTemperature,MinCarbonDioxide,MaxCarbonDioxide,DefaultCarbonDioxide,
	MinRelativeHumidity,MaxRelativeHumidity,DefaultRelativeHumidity,ProvidedStorageCondition
};

(* ::Subsubsection::Closed:: *)
(* IncubateCellsDevices - Rack Download Fields *)

cellIncubatorRackDownloadFields[]:={
	Name,Model,Container,Positions,Footprint,MinTemperature,MaxTemperature
};

(* ::Subsubsection::Closed:: *)
(* IncubateCellsDevices - Deck Download Fields *)

cellIncubatorDeckDownloadFields[]:={
	Name,Footprint,Container,Positions
};

(* ::Subsubsection::Closed:: *)
(*IncubateCellsDevices*)


(* Overload with no container inputs (to find all incubators that can attain the desired settings, regardless of container) *)
IncubateCellsDevices[myOptions: OptionsPattern[]] := IncubateCellsDevices[All, myOptions];

(* Main Overload with All (all possible container inputs) *)
IncubateCellsDevices[myInput: All, myOptions: OptionsPattern[]] := Module[
	{
		listedOptions, outputSpecification, output, gatherTests, safeOps,  safeOpsTests, cacheOption, simulation,
		cellTypeOption, cultureAdhesionOption, temperatureOption, carbonDioxidePercentageOption, relativeHumidityOption,
		shakingOption, shakingRateOption, shakingRadiusOption, prepModeOption, listedOptionLengths, optionLengthTest,
		expandedCellTypeOption, expandedCultureAdhesionOption, expandedTemperatureOption, expandedCarbonDioxidePercentageOption,
		expandedRelativeHumidityOption, expandedShakingOption, expandedShakingRateOption, expandedShakingRadiusOption,
		allCellIncubationContainers, incubatorInstruments, incubatorRacks, incubatorDecks, incubatorInstrumentFields,
		incubatorRackFields, incubatorDeckFields, downloadedStuff, expandedContainers, expandedCellTypeOptionByContainer,
		expandedCultureAdhesionOptionByContainer, expandedTemperatureOptionByContainer, expandedCarbonDioxidePercentageOptionByContainer,
		expandedRelativeHumidityOptionByContainer, expandedShakingOptionByContainer, expandedShakingRateOptionByContainer,
		expandedShakingRadiusOptionByContainer, containerOptionSets, uniqueOptionSets, uniqueContainers,
		uniqueCellType, uniqueCultureAdhesion, uniqueTemperature, uniqueCarbonDioxidePercentage, uniqueRelativeHumidity,
		uniqueShaking, uniqueShakingRate, uniqueShakingRadius, incubationDevicesByUniqueSet, setRules, resultRules,
		incubationDevicesBySet, incubatorsByOptionsByContainer, incubationContainerSetsByOptions, resultOutput
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOpsTests} = If[gatherTests,
		SafeOptions[IncubateCellsDevices, ToList[myOptions], AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[IncubateCellsDevices, ToList[myOptions], AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns return $Failed (or the tests up to this point)*)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests
		}]
	];

	(* Pull out options and assign them to variables *)
	{
		cacheOption,
		simulation,
		cellTypeOption,
		cultureAdhesionOption,
		temperatureOption,
		carbonDioxidePercentageOption,
		relativeHumidityOption,
		shakingOption,
		shakingRateOption,
		shakingRadiusOption,
		prepModeOption
	} = Lookup[safeOps,
		{
			Cache,
			Simulation,
			CellType,
			CultureAdhesion,
			Temperature,
			CarbonDioxide,
			RelativeHumidity,
			Shake,
			ShakingRate,
			ShakingRadius,
			Preparation
		}];

	(* This overload doesn't have any input, so we can't use the built in index matching checks to make sure the options are the right length/to expand the options.
	Instead, do this manually below. *)

	(* Figure out the length of each option that was provided as a list *)
	listedOptionLengths = Map[
		If[ListQ[#], Length[#], Nothing]&,
		{
			cellTypeOption,
			cultureAdhesionOption,
			temperatureOption,
			carbonDioxidePercentageOption,
			relativeHumidityOption,
			shakingOption,
			shakingRateOption,
			shakingRadiusOption
		}
	];

	(* Give an error if there are any listed options with differing lengths *)
	optionLengthTest = If[!Length[DeleteDuplicates[listedOptionLengths]] > 1,
		(* If the option lengths all match, give a passing test *)
		If[gatherTests,
			Test["The lengths of all listed options are the same:", True, True],
			Nothing
		],

		(* Otherwise, give an error*)
		If[gatherTests,
			Test["The lengths of these listed options are the same " <> ToString[
				PickList[{CellType, CultureAdhesion, Temperature, CarbonDioxide, RelativeHumidity, Shake, ShakingRate, ShakingRadius}, {cellTypeOption, cultureAdhesionOption, temperatureOption, carbonDioxidePercentageOption, relativeHumidityOption, shakingOption, shakingRateOption, shakingRadiusOption}, _List]] <> ":",
				False,
				True
			],
			Message[Error::OptionLengthDisagreement,
				PickList[{CellType, CultureAdhesion, Temperature, CarbonDioxide, RelativeHumidity, Shake, ShakingRate, ShakingRadius}, {cellTypeOption, cultureAdhesionOption, temperatureOption, carbonDioxidePercentageOption, relativeHumidityOption, shakingOption, shakingRateOption, shakingRadiusOption}, _List]
			];
			Nothing
		]
	];

	(* If there are any listed options with differing lengths return $Failed (or the tests up to this point)*)
	If[Length[DeleteDuplicates[listedOptionLengths]] > 1,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, optionLengthTest}]
		}]
	];

	(* Expand any singleton options *)
	{
		expandedCellTypeOption,
		expandedCultureAdhesionOption,
		expandedTemperatureOption,
		expandedCarbonDioxidePercentageOption,
		expandedRelativeHumidityOption,
		expandedShakingOption,
		expandedShakingRateOption,
		expandedShakingRadiusOption
	} = If[ListQ[#], #, ConstantArray[#, Max[listedOptionLengths, 1]]] & /@
		{
			cellTypeOption,
			cultureAdhesionOption,
			temperatureOption,
			carbonDioxidePercentageOption,
			relativeHumidityOption,
			shakingOption,
			shakingRateOption,
			shakingRadiusOption
		};

	(* Incubators and related parameters are stored in Model[Container,Plate]/Model[Container,Vessel]. Find all of these containers.
	(We need to know the incubator/deck/rack/container combo in order to determine if the container is compatible with the incubator) *)
	allCellIncubationContainers = allCellIncubationContainersSearch["Memoization"];

	(* Find all incubator-related objects (instruments, racks, and decks) from which we might need information *)
	(* Rather than downloading this information through links, we now need to find ALL incubator-related objects that we might need to look at *)
	(* Search for all incubator models in the lab to download from. *)
	incubatorInstruments = nonDeprecatedIncubatorsSearch["Memoization"];
	incubatorRacks = allIncubatorRacksSearch["Memoization"];
	incubatorDecks = allIncubatorDecksSearch["Memoization"];

	incubatorInstrumentFields = cellIncubatorInstrumentDownloadFields[];
	incubatorRackFields = cellIncubatorRackDownloadFields[];
	incubatorDeckFields = cellIncubatorDeckDownloadFields[];

	(* Downloaded stuff about the incubators/racks/decks that can be used for each container model *)
	downloadedStuff = Quiet[
		Download[
			{
				ToList[allCellIncubationContainers],
				incubatorInstruments,
				incubatorRacks,
				incubatorDecks
			},
			{
				{Packet[Footprint, Dimensions]},
				{Evaluate[Packet[Sequence @@ incubatorInstrumentFields]]},
				{Evaluate[Packet[Sequence @@ incubatorRackFields]]},
				{Evaluate[Packet[Sequence @@ incubatorDeckFields]]}
			},
			Cache -> cacheOption,
			Simulation -> simulation
		],
		Download::FieldDoesntExist
	];

	(* Expand the containers and options *)
	expandedContainers = ConstantArray[allCellIncubationContainers, Length[expandedTemperatureOption]];
	{
		expandedCellTypeOptionByContainer,
		expandedCultureAdhesionOptionByContainer,
		expandedTemperatureOptionByContainer,
		expandedCarbonDioxidePercentageOptionByContainer,
		expandedRelativeHumidityOptionByContainer,
		expandedShakingOptionByContainer,
		expandedShakingRateOptionByContainer,
		expandedShakingRadiusOptionByContainer
	} = Map[
		Flatten[Transpose[ConstantArray[#, Length[allCellIncubationContainers]]], 1]&,
		{
			expandedCellTypeOption,
			expandedCultureAdhesionOption,
			expandedTemperatureOption,
			expandedCarbonDioxidePercentageOption,
			expandedRelativeHumidityOption,
			expandedShakingOption,
			expandedShakingRateOption,
			expandedShakingRadiusOption
		}
	];

	(* Get each container with its options *)
	containerOptionSets = Transpose[{
		Flatten[expandedContainers],
		expandedCellTypeOptionByContainer,
		expandedCultureAdhesionOptionByContainer,
		expandedTemperatureOptionByContainer,
		expandedCarbonDioxidePercentageOptionByContainer,
		expandedRelativeHumidityOptionByContainer,
		expandedShakingOptionByContainer,
		expandedShakingRateOptionByContainer,
		expandedShakingRadiusOptionByContainer
	}];

	(* Get just unique container-option sets. *)
	uniqueOptionSets = DeleteDuplicates[containerOptionSets];

	{
		uniqueContainers,
		uniqueCellType,
		uniqueCultureAdhesion,
		uniqueTemperature,
		uniqueCarbonDioxidePercentage,
		uniqueRelativeHumidity,
		uniqueShaking,
		uniqueShakingRate,
		uniqueShakingRadius
	} = Transpose[uniqueOptionSets];

	(* For each unique container-option set, call the container overload on all incubatable container models *)
	(* Do not return tests from calling each unique container *)
	incubationDevicesByUniqueSet = IncubateCellsDevices[
		uniqueContainers,
		ReplaceRule[safeOps,
			{
				CellType -> uniqueCellType,
				CultureAdhesion -> uniqueCultureAdhesion,
				Temperature -> uniqueTemperature,
				CarbonDioxide -> uniqueCarbonDioxidePercentage,
				RelativeHumidity -> uniqueRelativeHumidity,
				Shake -> uniqueShaking,
				ShakingRate -> uniqueShakingRate,
				ShakingRadius -> uniqueShakingRadius,
				Cache -> Cases[Flatten[downloadedStuff], PacketP[]],
				Output -> Result
			}
		]
	];

	(* Order the incubation devices result by the original expanded option sets by using rules that relate each original set and each result to its index in the unique sets *)
	setRules = MapIndexed[Rule[#1, #2[[1]]] &, uniqueOptionSets];
	resultRules = MapIndexed[Rule[#2[[1]], #1] &, incubationDevicesByUniqueSet];
	incubationDevicesBySet = (containerOptionSets /. setRules) /. resultRules;

	(* Partition the result to reflect the incubators for each option set for each possible container *)
	incubatorsByOptionsByContainer = Unflatten[incubationDevicesBySet, expandedContainers];

	(* For each option set, return the incubators that would work along with the containers that the incubator is compatible with *)
	incubationContainerSetsByOptions = Map[
		Function[incubatorsByContainer,
			With[{
				(* Organize the containers and the incubators that would work for each container with the given settings into a list of {incubator,container} pairs *)
				incubatorContainerPairs = Flatten[
					MapThread[
						Function[{container, incubators},
							Map[
								Function[incubator,
									{incubator, container}
								],
								incubators
							]
						],
						{allCellIncubationContainers, incubatorsByContainer}
					],
					1]
				},
				(* Organize the info into a list in the form {{incubator, {containers}} .. } *)
				Map[{#[[1, 1]], #[[All, 2]]} &, GatherBy[incubatorContainerPairs, First]]
			]
		],
		incubatorsByOptionsByContainer
	];

	(* If none of the options were listed, remove one level of listing, otherwise return the incubator/container info as is *)
	resultOutput = If[MatchQ[listedOptionLengths, {}],
		First[incubationContainerSetsByOptions],
		incubationContainerSetsByOptions
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> resultOutput,
		Tests -> Flatten[{safeOpsTests, optionLengthTest}]
	}

];

(* Singleton overload *)
IncubateCellsDevices[myInput: ObjectP[{Model[Container], Object[Container], Object[Sample], Model[StorageCondition]}], myOptions: OptionsPattern[]] := Module[
	{
		listedOptions, outputSpecification, output, gatherTests, safeOps,  safeOpsTests, cellTypeOption, cultureAdhesionOption,
		temperatureOption, carbonDioxidePercentageOption, relativeHumidityOption, shakingOption, shakingRateOption,
		shakingRadiusOption, listedOptionLengths, optionLengthTest, expandedCellTypeOption, expandedCultureAdhesionOption,
		expandedTemperatureOption, expandedCarbonDioxidePercentageOption, expandedRelativeHumidityOption, expandedShakingOption,
		expandedShakingRateOption, expandedShakingRadiusOption, resultOutput
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOpsTests} = If[gatherTests,
		SafeOptions[IncubateCellsDevices, ToList[myOptions], AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[IncubateCellsDevices, ToList[myOptions], AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns return $Failed (or the tests up to this point)*)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests
		}]
	];

	(* Pull out options and assign them to variables *)
	{
		cellTypeOption,
		cultureAdhesionOption,
		temperatureOption,
		carbonDioxidePercentageOption,
		relativeHumidityOption,
		shakingOption,
		shakingRateOption,
		shakingRadiusOption
	} = Lookup[safeOps,
		{
			CellType,
			CultureAdhesion,
			Temperature,
			CarbonDioxide,
			RelativeHumidity,
			Shake,
			ShakingRate,
			ShakingRadius
		}];

	(* Figure out the length of each option that was provided as a list *)
	listedOptionLengths = Map[
		If[ListQ[#], Length[#], Nothing]&,
		{
			cellTypeOption,
			cultureAdhesionOption,
			temperatureOption,
			carbonDioxidePercentageOption,
			relativeHumidityOption,
			shakingOption,
			shakingRateOption,
			shakingRadiusOption
		}
	];

	(* Give an error if there are any listed options with differing lengths *)
	optionLengthTest = If[!Length[DeleteDuplicates[listedOptionLengths]] > 1,
		(* If the option lengths all match, give a passing test *)
		If[gatherTests,
			Test["The lengths of all listed options are the same:", True, True],
			Nothing
		],

		(* Otherwise, give an error*)
		If[gatherTests,
			Test["The lengths of these listed options are the same " <> ToString[
				PickList[{CellType, CultureAdhesion, Temperature, CarbonDioxide, RelativeHumidity, Shake, ShakingRate, ShakingRadius}, {cellTypeOption, cultureAdhesionOption, temperatureOption, carbonDioxidePercentageOption, relativeHumidityOption, shakingOption, shakingRateOption, shakingRadiusOption}, _List]] <> ":",
				False,
				True
			],
			Message[Error::OptionLengthDisagreement,
				PickList[{CellType, CultureAdhesion, Temperature, CarbonDioxide, RelativeHumidity, Shake, ShakingRate, ShakingRadius}, {cellTypeOption, cultureAdhesionOption, temperatureOption, carbonDioxidePercentageOption, relativeHumidityOption, shakingOption, shakingRateOption, shakingRadiusOption}, _List]
			];
			Nothing
		]
	];

	(* If there are any listed options with differing lengths return $Failed (or the tests up to this point)*)
	If[Length[DeleteDuplicates[listedOptionLengths]] > 1,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, optionLengthTest}]
		}]
	];

	(* Expand any singleton options *)
	{
		 expandedCellTypeOption,
		 expandedCultureAdhesionOption,
		 expandedTemperatureOption,
		 expandedCarbonDioxidePercentageOption,
		 expandedRelativeHumidityOption,
		 expandedShakingOption,
		 expandedShakingRateOption,
		 expandedShakingRadiusOption
	} = If[ListQ[#], #, ConstantArray[#, Max[listedOptionLengths, 1]]] & /@
     {
			 cellTypeOption,
			 cultureAdhesionOption,
			 temperatureOption,
			 carbonDioxidePercentageOption,
			 relativeHumidityOption,
			 shakingOption,
			 shakingRateOption,
			 shakingRadiusOption
		 };

	(* Call IncubateCellsDevices on the listed inputs *)
	output = IncubateCellsDevices[
		ConstantArray[myInput, Max[listedOptionLengths, 1]],
		ReplaceRule[safeOps,
			{
				 CellType -> expandedCellTypeOption,
				 CultureAdhesion -> expandedCultureAdhesionOption,
				 Temperature -> expandedTemperatureOption,
				 CarbonDioxide -> expandedCarbonDioxidePercentageOption,
				 RelativeHumidity -> expandedRelativeHumidityOption,
				 Shake -> expandedShakingOption,
				 ShakingRate -> expandedShakingRateOption,
				 ShakingRadius -> expandedShakingRadiusOption
			}
		]
	];


	resultOutput = Which[
		MatchQ[output, $Failed],
			$Failed,
		GreaterQ[Max[listedOptionLengths, 1], 1],
			output,
		True,
			FirstOrDefault[output, {}]
	];

	(* If the result is $Failed, return that. Otherwise, get the unlisted output. *)
	outputSpecification /. {
		Result -> resultOutput,
		Tests -> Flatten[{safeOpsTests, optionLengthTest}]
	}
];

(* StorageCondition overload *)
IncubateCellsDevices[myInputs: {___, ObjectP[Model[StorageCondition]], ___}, myOptions: OptionsPattern[]] := Module[
	{
		listedOptions, outputSpecification, output, cache, gatherTests, safeOps, safeOpsTests, validLengths, validLengthTests,
		expandedSafeOps, incubationStorageConditions, positionsOfStorageCondition, cellTypesFromSafeOps,
		temperaturesFromSafeOps, carbonDioxidesFromSafeOps, relativeHumiditiesFromSafeOps, shakingsFromSafeOps,
		shakingRatesFromSafeOps, shakingRadiiFromFromSafeOps, cultureAdhesionsFromSafeOps, prepModesFromSafeOps,
		updatedInputs, downloadedStuff, cellTypesFromStorageCondition, cultureAdhesionsFromStorageCondition,
		rawTemperaturesFromStorageCondition, rawCarbonDioxidesFromStorageCondition, rawRelativeHumiditiesFromStorageCondition,
		rawShakingRadiiFromStorageCondition, temperaturesFromStorageCondition, carbonDioxidesFromStorageCondition,
		relativeHumiditiesFromStorageCondition, shakingsFromStorageCondition, shakingRatesFromStorageCondition,
		possibleShakingRatesFromStorageConditions, shakingRadiiFromStorageCondition, prepModesFromStorageCondition,
		conflictingOptions, conflictingOptionTest, updatedOptions
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];
	cache = Lookup[listedOptions, Cache];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOpsTests} = If[gatherTests,
		SafeOptions[IncubateCellsDevices, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[IncubateCellsDevices, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns return $Failed  (or the tests up to this point)*)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[IncubateCellsDevices, {myInputs}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[IncubateCellsDevices, {myInputs}, listedOptions], {}}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}]
		}]
	];

	(* Expand any safe ops *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[IncubateCellsDevices, {ToList[myInputs]}, safeOps]];

	(* Extract StorageCondition inputs *)
	incubationStorageConditions = Cases[myInputs, ObjectP[Model[StorageCondition]]];
	(* Positions of extracted StorageCondition inputs from myInput *)
	positionsOfStorageCondition = Position[myInputs, ObjectP[Model[StorageCondition]]];
	(* Pull out options from safe ops *)
	cellTypesFromSafeOps = Extract[Lookup[expandedSafeOps, CellType], positionsOfStorageCondition];
	temperaturesFromSafeOps = Extract[Lookup[expandedSafeOps, Temperature], positionsOfStorageCondition];
	carbonDioxidesFromSafeOps = Extract[Lookup[expandedSafeOps, CarbonDioxide], positionsOfStorageCondition];
	relativeHumiditiesFromSafeOps = Extract[Lookup[expandedSafeOps, RelativeHumidity], positionsOfStorageCondition];
	shakingsFromSafeOps = Extract[Lookup[expandedSafeOps, Shake], positionsOfStorageCondition];
	shakingRatesFromSafeOps = Extract[Lookup[expandedSafeOps, ShakingRate], positionsOfStorageCondition];
	shakingRadiiFromFromSafeOps = Extract[Lookup[expandedSafeOps, ShakingRadius], positionsOfStorageCondition];
	cultureAdhesionsFromSafeOps = Extract[Lookup[expandedSafeOps, CultureAdhesion], positionsOfStorageCondition];
	prepModesFromSafeOps = ConstantArray[Lookup[expandedSafeOps, Preparation], Length[positionsOfStorageCondition]];(*Preparation is not index matching*)

	(* Big download *)
	downloadedStuff = Quiet[
		Download[
			incubationStorageConditions,
			Packet[CellType, CultureHandling, Temperature, Humidity, Temperature, CarbonDioxide, ShakingRate, VesselShakingRate, PlateShakingRate, ShakingRadius],
			Cache -> cache,
			Date -> Now
		],
		{Download::FieldDoesntExist}
	];

	(* We are updating the input at the position of Model[StorageCondition] to All *)
	updatedInputs = myInputs/.ObjectP[Model[StorageCondition]] :> All;

	(* Pull out options from StorageCondition *)
	{
		cellTypesFromStorageCondition,
		rawTemperaturesFromStorageCondition,
		rawCarbonDioxidesFromStorageCondition,
		rawRelativeHumiditiesFromStorageCondition,
		rawShakingRadiiFromStorageCondition
	} = Transpose@Map[
		Lookup[
			fetchPacketFromCache[#, downloadedStuff],
			{
				CellType,
				Temperature,
				CarbonDioxide,
				Humidity,
				ShakingRadius
			}
		]&,
		incubationStorageConditions
	];

	(* Since there are 2 shaking rates for each incubation condition (plate vs vessel) and we want to resolve both, we set it to Automatic when Shake is True *)
	{shakingsFromStorageCondition, shakingRatesFromStorageCondition, possibleShakingRatesFromStorageConditions} = Transpose@Map[
		Module[{possibleRates},
			possibleRates = Cases[Lookup[fetchPacketFromCache[#, downloadedStuff], {ShakingRate, PlateShakingRate, VesselShakingRate}], Except[Null]];
			If[MatchQ[possibleRates, {}],
				{False, Null, Null},
				{True, Automatic, possibleRates}
			]
		]&,
		incubationStorageConditions
	];


	cultureAdhesionsFromStorageCondition = MapThread[
		Module[{cultureHandling},
			cultureHandling = Lookup[fetchPacketFromCache[#1, downloadedStuff], CultureHandling];
			Which[
				MatchQ[cultureHandling, Microbial] && TrueQ[#2],
					Suspension,
				MatchQ[cultureHandling, Microbial],
					SolidMedia,
				MatchQ[cultureHandling, NonMicrobial],
					Adherent,
				True,
					Null
			]
		]&,
		{incubationStorageConditions, shakingsFromStorageCondition}
	];

	prepModesFromStorageCondition = ConstantArray[Manual, Length[incubationStorageConditions]];

	(* Round Temperature, CarbonDioxide, RelativeHumidity, and ShakingRadius *)
	(* Note when we look up values from SC, extra digit might be added *)
	temperaturesFromStorageCondition = SafeRound[rawTemperaturesFromStorageCondition, 1 Celsius];
	carbonDioxidesFromStorageCondition = SafeRound[rawCarbonDioxidesFromStorageCondition, 1 Percent];
	relativeHumiditiesFromStorageCondition = SafeRound[rawRelativeHumiditiesFromStorageCondition, 1 Percent];
	shakingRadiiFromStorageCondition = Map[
		If[!NullQ[#],
			(* Note: here we are not using CellIncubatorShakingRadiusP to ensure the digit *)
			First@Nearest[{3 Millimeter, 25 Millimeter, 25.4 Millimeter}, #](*CellIncubatorShakingRadiusP*)
		]&,
		rawShakingRadiiFromStorageCondition
	];


	(* Check conflicting between myOptions and desired options from Model[StorageCondition] *)
	conflictingOptions = Flatten[MapThread[
		{
			If[!MatchQ[#4, Automatic] && MatchQ[#3, #4],
				{#2, #3, #4, CellType},
				Nothing
			],
			If[!MatchQ[#6, Automatic] && !MatchQ[#5, #6],
				{#2, #5, #6, CultureAdhesion},
				Nothing
			],
			If[!MatchQ[#8, Automatic] && !EqualQ[#7, #8],
				{#2, #7, #8, Temperature},
				Nothing
			],
			If[!MatchQ[#10, Automatic] && !EqualQ[#9, #10],
				{#2, #9, #10, CarbonDioxide},
				Nothing
			],
			If[!MatchQ[#12, Automatic] && !EqualQ[#11, #12],
				{#2, #11, #12, RelativeHumidity},
				Nothing
			],
			If[!MatchQ[#14, Automatic] && MatchQ[#13, #14],
				{#2, #13, #14, Shake},
				Nothing
			],
			If[!MatchQ[#16, Automatic] && !EqualQ[#15, #16],
				{#2, #15, #16, ShakingRadius},
				Nothing
			],
			If[!MatchQ[#18, Automatic] && !MemberQ[#17, #18],
				{#2, #17, #18, ShakingRate},
				Nothing
			],
			If[!MatchQ[#20, Automatic] && MatchQ[#19, #20],
				{#2, #19, #20, Preparation},
				Nothing
			]
		}&,
		{
			Range[Length@incubationStorageConditions], incubationStorageConditions,
			cellTypesFromStorageCondition, cellTypesFromSafeOps,
			cultureAdhesionsFromStorageCondition, cultureAdhesionsFromSafeOps,
			temperaturesFromStorageCondition, temperaturesFromSafeOps,
			carbonDioxidesFromStorageCondition, carbonDioxidesFromSafeOps,
			relativeHumiditiesFromStorageCondition, relativeHumiditiesFromSafeOps,
			shakingsFromStorageCondition, shakingsFromSafeOps,
			shakingRadiiFromStorageCondition, shakingRadiiFromFromSafeOps,
			possibleShakingRatesFromStorageConditions, shakingRatesFromSafeOps,
			prepModesFromStorageCondition, prepModesFromSafeOps
		}
	], 1];

	(* Give an error if there are any conflicts between options and IncubationConditions *)
	conflictingOptionTest = If[MatchQ[conflictingOptions, {}],
		(* If the option lengths all match, give a passing test *)
		If[gatherTests,
			Test["The specified incubation option and IncubationCondition are not conflicted:", True, True],
			Nothing
		],

		(* Otherwise, give an error*)
		If[gatherTests,
			Test["The specified incubation options:" <> ToString[conflictingOptions[[All, 4]]] <> " are different from IncubationCondition for samples:" <> ToString[conflictingOptions[[All, 1]]] <> ":",
				False,
				True
			],
			Message[
				Error::ConflictingIncubationConditionWithOptions,
				conflictingOptions[[All, 1]],
				conflictingOptions[[All, 2]],
				conflictingOptions[[All, 3]],
				conflictingOptions[[All, 4]]
			];
			Nothing
		]
	];

	(* If there are any listed options with differing lengths return $Failed (or the tests up to this point)*)
	If[!MatchQ[conflictingOptions, {}],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, conflictingOptionTest}]
		}]
	];

	(* Replace the expanded safe options with options from storage conditions for inputs on positionsOfStorageCondition*)
	updatedOptions = {
		CellType -> ReplacePart[Lookup[expandedSafeOps, CellType], Thread[positionsOfStorageCondition -> cellTypesFromStorageCondition]],
		CultureAdhesion -> ReplacePart[Lookup[expandedSafeOps, CultureAdhesion], Thread[positionsOfStorageCondition -> cultureAdhesionsFromStorageCondition]],
		Temperature -> ReplacePart[Lookup[expandedSafeOps, Temperature], Thread[positionsOfStorageCondition -> temperaturesFromStorageCondition]],
		CarbonDioxide -> ReplacePart[Lookup[expandedSafeOps, CarbonDioxide], Thread[positionsOfStorageCondition -> carbonDioxidesFromStorageCondition]],
		RelativeHumidity -> ReplacePart[Lookup[expandedSafeOps, RelativeHumidity], Thread[positionsOfStorageCondition -> relativeHumiditiesFromStorageCondition]],
		Shake -> ReplacePart[Lookup[expandedSafeOps, Shake], Thread[positionsOfStorageCondition -> shakingsFromStorageCondition]],
		ShakingRate -> ReplacePart[Lookup[expandedSafeOps, ShakingRate], Thread[positionsOfStorageCondition -> shakingRatesFromStorageCondition]],
		ShakingRadius -> ReplacePart[Lookup[expandedSafeOps, ShakingRadius], Thread[positionsOfStorageCondition -> shakingRadiiFromStorageCondition]],
		Preparation -> Manual
	};

	(* Call IncubateCellsDevices on the listed inputs *)
	IncubateCellsDevices[updatedInputs, ReplaceRule[expandedSafeOps, updatedOptions]]
];

(* All containers overload *)
IncubateCellsDevices[myInputs: {___, All, ___}, myOptions: OptionsPattern[]] := Module[
	{
		listedOptions, outputSpecification, output, cache, gatherTests, safeOps, safeOpsTests, validLengths, validLengthTests,
		expandedSafeOps, croppedInputLists, croppedInputPositions, positionsOfAll, croppedOutputs, croppedTests, croppedExpandedSafeOps,
		allBranchOutputs, allBranchExpandedSafeOps, allBranchTests, resultOutput
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];
	cache = Lookup[listedOptions, Cache, {}];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOpsTests} = If[gatherTests,
		SafeOptions[IncubateCellsDevices, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[IncubateCellsDevices, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns return $Failed  (or the tests up to this point)*)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[IncubateCellsDevices, {myInputs}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[IncubateCellsDevices, {myInputs}, listedOptions], {}}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}]
		}]
	];

	(* Expand any safe ops *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[IncubateCellsDevices, {ToList[myInputs]}, safeOps]];

	(* Crop the input to only have Samples and Containers *)
	croppedInputLists = Cases[myInputs, ObjectP[{Model[Container], Object[Container], Object[Sample]}]];
	(* Positions of extracted StorageCondition inputs from myInput *)
	croppedInputPositions = Position[myInputs, ObjectP[{Model[Container], Object[Container], Object[Sample]}]];

	croppedExpandedSafeOps = {
		CellType -> Extract[Lookup[expandedSafeOps, CellType], croppedInputPositions];
		Temperature -> Extract[Lookup[expandedSafeOps, Temperature], croppedInputPositions];
		CarbonDioxide -> Extract[Lookup[expandedSafeOps, CarbonDioxide], croppedInputPositions];
		RelativeHumidity -> Extract[Lookup[expandedSafeOps, RelativeHumidity], croppedInputPositions];
		Shake -> Extract[Lookup[expandedSafeOps, Shake], croppedInputPositions];
		ShakingRate -> Extract[Lookup[expandedSafeOps, ShakingRate], croppedInputPositions];
		ShakingRadius -> Extract[Lookup[expandedSafeOps, ShakingRadius], croppedInputPositions];
		CultureAdhesion -> Extract[Lookup[expandedSafeOps, CultureAdhesion], croppedInputPositions];
		Preparation -> Lookup[expandedSafeOps, Preparation],
		Cache -> cache,
		Simulation -> Lookup[expandedSafeOps, Simulation]
	};

	{croppedOutputs, croppedTests} = Which[
		MatchQ[croppedInputLists, {}],
			{{}, {}},
		gatherTests,
			IncubateCellsDevices[croppedInputLists, Append[croppedExpandedSafeOps, Output -> {Result, Tests}]],
		True,
			{IncubateCellsDevices[croppedInputLists, Append[croppedExpandedSafeOps, Output -> Result]], {}}
	];

	(* Positions of All inputs from myInputs *)
	positionsOfAll = Position[myInputs, All];

	allBranchExpandedSafeOps = {
		CellType -> Extract[Lookup[expandedSafeOps, CellType], positionsOfAll],
		Temperature -> Extract[Lookup[expandedSafeOps, Temperature], positionsOfAll],
		CarbonDioxide -> Extract[Lookup[expandedSafeOps, CarbonDioxide], positionsOfAll],
		RelativeHumidity -> Extract[Lookup[expandedSafeOps, RelativeHumidity], positionsOfAll],
		Shake -> Extract[Lookup[expandedSafeOps, Shake], positionsOfAll],
		ShakingRate -> Extract[Lookup[expandedSafeOps, ShakingRate], positionsOfAll],
		ShakingRadius -> Extract[Lookup[expandedSafeOps, ShakingRadius], positionsOfAll],
		CultureAdhesion -> Extract[Lookup[expandedSafeOps, CultureAdhesion], positionsOfAll],
		Cache -> cache,
		Preparation -> Lookup[expandedSafeOps, Preparation],
		Simulation -> Lookup[expandedSafeOps, Simulation]
	};

	{allBranchOutputs, allBranchTests} = If[gatherTests,
		IncubateCellsDevices[All, Append[allBranchExpandedSafeOps, Output -> {Result, Tests}]],
		{IncubateCellsDevices[All, Append[allBranchExpandedSafeOps, Output -> Result]], {}}
	];

	(* Now we want to assemble the results from cropped sample branch and all branch back based on their original positions *)
	resultOutput = MapThread[
		If[MatchQ[#1, All],
			Extract[allBranchOutputs, FirstPosition[positionsOfAll, {#2}]],
			Extract[croppedOutputs, FirstPosition[croppedInputPositions, {#2}]]
		]&,
		{myInputs, Range[Length@myInputs]}
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> resultOutput,
		Tests -> Flatten[{safeOpsTests, croppedTests, allBranchTests}]
	}
];

(* Overload with container model/container/sample inputs (to find all incubators that can attain the desired settings AND fit the container) *)
IncubateCellsDevices[myInputs: {ObjectP[{Model[Container], Object[Container], Object[Sample]}]..}, myOptions: OptionsPattern[]] := Module[
	{
		listedOptions, outputSpecification, output,  gatherTests, safeOps, safeOpsTests, validLengths, validLengthTests,
		expandedSafeOps, cacheOption, simulation, cellTypeOption, cultureAdhesionOption, temperatureOption,
		carbonDioxidePercentageOption, relativeHumidityOption, shakingOption, shakingRateOption, shakingRadiusOption,
		prepMethodOption, allCellIncubationContainers, incubatorInstruments, incubatorRacks, incubatorDecks,
		incubatorInstrumentFields, incubatorRackFields, incubatorDeckFields, incubatorInstrumentPackets, incubatorRackPackets,
		incubatorDeckPackets, inputPackets, inputContainerFootprints, inputContainerPossibleIncubators,
		inputModelContainerPackets, inputObjectContainerPackets, inputSamplePackets, incubatorObjectPacketLookup,
		inputContainerPossibleIncubatorsPackets, compatibleIncubatorsByContainer
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOpsTests} = If[gatherTests,
		SafeOptions[IncubateCellsDevices, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[IncubateCellsDevices, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns return $Failed  (or the tests up to this point)*)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[IncubateCellsDevices, {myInputs}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[IncubateCellsDevices, {myInputs}, listedOptions], {}}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}]
		}]
	];

	(* Expand any safe ops *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[IncubateCellsDevices, {ToList[myInputs]}, safeOps]];

	(* Pull out options and assign them to variables *)
	{
		cacheOption,
		simulation,
		cellTypeOption,
		cultureAdhesionOption,
		temperatureOption,
		carbonDioxidePercentageOption,
		relativeHumidityOption,
		shakingOption,
		shakingRateOption,
		shakingRadiusOption,
		prepMethodOption
	} = Lookup[
		expandedSafeOps,
		{
			Cache,
			Simulation,
			CellType,
			CultureAdhesion,
			Temperature,
			CarbonDioxide,
			RelativeHumidity,
			Shake,
			ShakingRate,
			ShakingRadius,
			Preparation
		}
	];

	(* To avoid downloading through links, we must now do the following:
			- Get a list of all incubator-related objects (instrument/racks/decks)
			- Download sample container model footprints along with relevant information from all the above models
			- Run incubatorsForFootprint on all footprints
			- Cases out the packets for each container's incubator, rack, and deck packets
			- For each container, transpose the lists of packets so we have: {{all incubator packets},{all rack packets},{all deck packets}}
	*)

	(* Find all incubator-related objects (instruments, racks, and decks) from which we might need information *)
	(* Rather than downloading this information through links, we now need to find ALL incubator-related objects that we might need to look at *)
	(* The Search results should already be memoized, so extract types from the ordered list to avoid multiple database round-trips *)

	(* Incubators and related parameters are stored in Model[Container,Plate]/Model[Container,Vessel]. Find all of these containers.
	(We need to know the incubator/deck/rack/container combo in order to determine if the container is compatible with the incubator) *)
	allCellIncubationContainers = allCellIncubationContainersSearch["Memoization"];

	(* Search for all incubator models in the lab to download from. *)
	incubatorInstruments = nonDeprecatedIncubatorsSearch["Memoization"];
	incubatorRacks = allIncubatorRacksSearch["Memoization"];
	incubatorDecks = allIncubatorDecksSearch["Memoization"];

	incubatorInstrumentFields = cellIncubatorInstrumentDownloadFields[];
	incubatorRackFields = cellIncubatorRackDownloadFields[];
	incubatorDeckFields = cellIncubatorDeckDownloadFields[];

	(* Downloaded stuff about the incubators/racks/decks that can be used to incubate each container model *)
	{
		inputModelContainerPackets,
		inputObjectContainerPackets,
		inputSamplePackets,
		incubatorInstrumentPackets,
		incubatorRackPackets,
		incubatorDeckPackets
	} = Quiet[
		Download[
			{
				(* Inputs *)
				Cases[ToList[myInputs], ObjectP[Model[Container]]],
				Cases[ToList[myInputs], ObjectP[Object[Container]]],
				Cases[ToList[myInputs], ObjectP[Object[Sample]]],
				incubatorInstruments,
				incubatorRacks,
				incubatorDecks
			},
			{
				{Object, Packet[Footprint, Dimensions]},
				{Object, Packet[Model[{Footprint, Dimensions}]]},
				{Object, Packet[Container[Model][{Footprint, Dimensions}]]},
				{Evaluate[Packet[Sequence @@ incubatorInstrumentFields]]},
				{Evaluate[Packet[Sequence @@ incubatorRackFields]]},
				{Evaluate[Packet[Sequence @@ incubatorDeckFields]]}
			},
			Cache -> cacheOption,
			Simulation -> simulation
		],
		{Download::FieldDoesntExist}
	];

	(* Thread out input information back into the order that we got it from the user. *)
	inputPackets = ToList[myInputs] /. ((ObjectP[#[[1]]] -> #[[2]]&) /@ Join[inputModelContainerPackets, inputObjectContainerPackets, inputSamplePackets]);

	(* Pull out footprints for input containers *)
	inputContainerFootprints = Lookup[inputPackets, Footprint];

	(* Get incubator equipment ensembles (i.e., instrument/rack or instrument/deck) combos for each input container,
	passing in downloaded incubator equipment packets as cache *)
	inputContainerPossibleIncubators = incubatorsForFootprint[
		inputContainerFootprints,
		(If[MatchQ[#, Null] || MatchQ[Lookup[#, Dimensions], Null], Null, Lookup[#, Dimensions][[3]]]&) /@ inputPackets,
		incubatorInstrumentPackets,
		incubatorRackPackets,
		incubatorDeckPackets
	];

	(* Make a look up to replace all objects with packets as expected below *)
	incubatorObjectPacketLookup = Rule[Lookup[#, Object], #]& /@ Flatten[incubatorInstrumentPackets];

	(* Replace all objects with their corresponding packets *)
	inputContainerPossibleIncubatorsPackets = ReplaceAll[inputContainerPossibleIncubators, incubatorObjectPacketLookup];

	(* For each container input/option set combo, find the compatible incubators *)
	(* Outer MapThread: Iterate over containers, which may have multiple compatible incubator entries *)
	compatibleIncubatorsByContainer = DeleteDuplicates /@ MapThread[
		Function[
			{
				inputContainerPossibleIncubatorsPacket,
				desiredCellType,
				desiredTemperature,
				desiredCarbonDioxidePercentage,
				desiredRelativeHumidity,
				desiredShake,
				desiredShakingRate,
				desiredShakingRadius,
				inputPacket
			},
			(* Inner MapThread: Iterate over each possible incubator for each container *)
			MapThread[
				Function[{incubatorPacket},
					Module[
						{
							incubatorCellTypes, incubatorMaxTemperature, incubatorMinTemperature, incubatorMaxCarbonDioxidePercentage,
							incubatorMinCarbonDioxidePercentage, incubatorMaxRelativeHumidity, incubatorMinRelativeHumidity,
							incubatorMaxShakingRate, incubatorMinShakingRate, incubatorShakingRadius, loadingMode, shakeQ,
							incubatorDefaultTemperature, incubatorDefaultCarbonDioxidePercentage, incubatorDefaultRelativeHumidity,
							incubatorDefaultShakingRate, cellTypeCompatible, temperatureCompatible, carbonDioxidePercentageCompatible,
							relativeHumidityCompatible, shakingRateCompatible, shakingRadiusCompatible, prepMethodCompatible
						},

						(* Get info about the incubator *)
						{incubatorCellTypes, incubatorMaxTemperature, incubatorMinTemperature, incubatorDefaultTemperature,
							incubatorMaxCarbonDioxidePercentage, incubatorMinCarbonDioxidePercentage, incubatorDefaultCarbonDioxidePercentage,
							incubatorMaxRelativeHumidity, incubatorMinRelativeHumidity, incubatorDefaultRelativeHumidity,
							incubatorMaxShakingRate, incubatorMinShakingRate, incubatorDefaultShakingRate, incubatorShakingRadius, loadingMode
						} = Lookup[
							incubatorPacket,
							{CellTypes, MaxTemperature, MinTemperature, DefaultTemperature, MaxCarbonDioxide, MinCarbonDioxide, DefaultCarbonDioxide, MaxRelativeHumidity, MinRelativeHumidity, DefaultRelativeHumidity, MaxShakingRate, MinShakingRate, DefaultShakingRate, ShakingRadius, Mode},
							Null
						];
						(*TODO: Possibly check the cellType of the samples in the container if we want to do any resolving in this function *)
						(* If no CellType is provided, assume that this is a broad check for any incubator of any CellType and set this to True.
						 If a desired CellType is provided, see if it is one of the allowed CellType for this instrument *)
						cellTypeCompatible = If[MatchQ[desiredCellType, (Null | Automatic)],
							True,
							MemberQ[incubatorCellTypes, desiredCellType]
						];

						(* Check if the desired temperature setting is within the possible temperatures for this instrument *)
						temperatureCompatible = If[MatchQ[desiredTemperature, Automatic],
							True,
							If[MatchQ[incubatorDefaultTemperature, (Null | {} | $Failed)],
								(*If no defaultTemperature is informed, it is a custom incubator, so check the full operating range of the instrument *)
								RangeQ[(desiredTemperature /. Ambient -> 25 Celsius), {incubatorMinTemperature, incubatorMaxTemperature}],
								(*If a defaultTemperature is informed, it is a storage incubator, so check only the default value of the instrument *)
								RangeQ[(desiredTemperature /. Ambient -> 25 Celsius), {(incubatorDefaultTemperature - 0.1 Celsius), (incubatorDefaultTemperature + 0.1 Celsius)}]
							]
						];

						(* Check if the desired CO2 setting is within the possible ranges for this instrument *)
						carbonDioxidePercentageCompatible = If[MatchQ[desiredCarbonDioxidePercentage, Automatic],
							True,
							If[MatchQ[incubatorDefaultCarbonDioxidePercentage, (Null | {} | $Failed)],
								(*If no incubatorDefaultCarbonDioxidePercentage is informed, it is a custom incubator, so check the full operating range of the instrument *)
								RangeQ[desiredCarbonDioxidePercentage, {(incubatorMinCarbonDioxidePercentage /. Null -> 0 Percent), (incubatorMaxCarbonDioxidePercentage /. Null -> 0 Percent)}],
								(*If incubatorDefaultCarbonDioxidePercentage is informed, it is a storage incubator, so check only the default value of the instrument *)
								RangeQ[desiredCarbonDioxidePercentage, {(incubatorDefaultCarbonDioxidePercentage - 1 Percent), (incubatorDefaultCarbonDioxidePercentage + 1 Percent)}]
							]
						];

						(* Check if the desired relative humidity setting is within the possible ranges for this instrument *)
						relativeHumidityCompatible = If[MatchQ[desiredRelativeHumidity, Automatic],
							True,
							Which[
								(* If the incubator doesn't support humidity, the desired humidity must be Null. *)
								MatchQ[incubatorMinRelativeHumidity, Null] && MatchQ[incubatorMaxRelativeHumidity, Null],
								MatchQ[desiredRelativeHumidity, Null],

								(*If no incubatorDefaultRelativeHumidity is informed, it is a custom incubator, so check the full operating range of the instrument *)
								MatchQ[incubatorDefaultRelativeHumidity, PercentP],
								RangeQ[(desiredRelativeHumidity), {(incubatorDefaultRelativeHumidity - 1 Percent), (incubatorDefaultRelativeHumidity + 1 Percent)}],

								(*If incubatorDefaultRelativeHumidity is informed, it is a storage incubator, so check only the default value of the instrument *)
								MatchQ[desiredRelativeHumidity, PercentP],
								RangeQ[(desiredRelativeHumidity), {incubatorMinRelativeHumidity, incubatorMaxRelativeHumidity}],

								(*If incubatorMinRelativeHumidity incubatorMaxRelativeHumidity and desiredRelativeHumidity is informed, it is a storage incubator, so check only the default value of the instrument *)
								MatchQ[incubatorMinRelativeHumidity, PercentP] && MatchQ[incubatorMaxRelativeHumidity, PercentP] &&
									MatchQ[desiredRelativeHumidity, PercentP],
								RangeQ[(desiredRelativeHumidity), {incubatorMinRelativeHumidity, incubatorMaxRelativeHumidity}],

								(* If the incubator doesn't support humidity, the desired humidity must be Null. *)
								MatchQ[incubatorDefaultRelativeHumidity, Null] ,
								MatchQ[desiredRelativeHumidity, Null]

							]
						];

						(* Check if any specified option can resolve Shake Option *)
						shakeQ = Which[
							MatchQ[desiredShake, BooleanP], desiredShake,
							MatchQ[desiredShakingRate, GreaterP[0 RPM]], True,
							MatchQ[desiredShakingRadius, GreaterP[0 Millimeter]], True,
							True, Automatic
						];

						(* Check if the desired shaking rate is within the possible ranges for this instrument *)
						shakingRateCompatible = Which[
							(* If the incubator doesn't support shaking, the desired shaking must be Null. *)
							MatchQ[incubatorMinShakingRate, Null] && MatchQ[incubatorMaxShakingRate, Null] && MatchQ[incubatorDefaultShakingRate, Null],
								MatchQ[desiredShakingRate, Null|Automatic] && !TrueQ[shakeQ],
							(* If no incubatorDefaultShakingRate but min/max are informed, it is a custom incubator  *)
							MatchQ[incubatorDefaultShakingRate, Null],
								Or[
									RangeQ[desiredShakingRate, {((incubatorMinShakingRate /. Null -> 0 RPM) - 5 RPM), ((incubatorMaxShakingRate /. Null -> 0 RPM) + 5 RPM)}] && MatchQ[shakeQ, True|Automatic],
									MatchQ[desiredShakingRate, Null] && !TrueQ[shakeQ],
									MatchQ[desiredShakingRate, Automatic]
								],
							(* If incubatorDefaultShakingRate is informed, it is a default shaking incubator, so check only the default value of the instrument *)
							True,
								Or[
									EqualQ[desiredShakingRate, incubatorDefaultShakingRate] && MatchQ[shakeQ, True|Automatic],
									MatchQ[desiredShakingRate, Automatic] && MatchQ[shakeQ, True|Automatic]
								]
						];

						(* Check if the desired shaking radius matches this instrument within +/-0.05 Centimeter *)
						(* to account for the 2.5->2.54cm scenario and the fact this is a single field in the instrument model *)
						shakingRadiusCompatible = Which[
							(* If the incubator doesn't support shaking, the desired shaking must be Null. *)
							MatchQ[incubatorShakingRadius, Null],
								MatchQ[desiredShakingRadius, Null|Automatic] && !TrueQ[shakeQ],

							(* If no incubatorDefaultShakingRate, but shakingRadius is informed, it is a custom incubator *)
							(* NOTE: Definitely a little weird that we are using shaking rate in the shaking radius resolution, however *)
							(* we don't have specific 'custom' field, so this is a simple way to check *)
							(* If we are custom incubating, we can either shake or not shake. If we want to shake, make sure our radius is within *)
							(* the allowed tolerance *)
							MatchQ[incubatorDefaultShakingRate, Null],
								Or[
									RangeQ[desiredShakingRadius, {(incubatorShakingRadius - 0.01 Centimeter), (incubatorShakingRadius + 0.01 Centimeter)}] && MatchQ[shakeQ, True|Automatic],
									MatchQ[desiredShakingRadius, Null] && !TrueQ[shakeQ],
									MatchQ[desiredShakingRadius, Automatic]
								],
							(* If incubator default shaking rate is informed, it is a default incubator, so only check whether the value is in the tolerances *)
							True,
								Or[
									RangeQ[desiredShakingRadius, {(incubatorShakingRadius - 0.01 Centimeter), (incubatorShakingRadius + 0.01 Centimeter)}] && MatchQ[shakeQ, True|Automatic],
									MatchQ[desiredShakingRadius, Automatic] && MatchQ[shakeQ, True|Automatic]
								]
						];

						(* Check if the desired preparation method (mode) matches this instrument *)
						prepMethodCompatible = If[MatchQ[prepMethodOption, (Automatic | Null)],
							True,
							MatchQ[loadingMode, prepMethodOption]
						];
						(* If the incubator is compatible on all settings, return the incubator object. Otherwise return nothing. *)
						If[MatchQ[{cellTypeCompatible, temperatureCompatible, carbonDioxidePercentageCompatible, relativeHumidityCompatible,
							shakingRateCompatible, shakingRadiusCompatible, prepMethodCompatible}, {True..}],
							Lookup[incubatorPacket, Object, Nothing],
							Nothing
						]
					]
				],
				(* Each 'packets' entry is a set of {incubator packet..} that is index matched and set for MapThreading*)
				{inputContainerPossibleIncubatorsPacket}
			]
		],
		{
			inputContainerPossibleIncubatorsPackets,
			cellTypeOption,
			(temperatureOption /. {Ambient -> 22Celsius}),
			(carbonDioxidePercentageOption /. {Null -> 0. Percent}),
			relativeHumidityOption,
			shakingOption,
			shakingRateOption,
			shakingRadiusOption,
			inputPackets
		}
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> compatibleIncubatorsByContainer,
		Tests -> Flatten[{safeOpsTests, validLengthTests}]
	}
];

(* ::Subsubsection::Closed:: *)
(*incubatorsForFootprint*)

(* incubatorsForFootprint: traverses footprint graph for all provided incubator-related containers starting at the provided footprint(s)
and returns a list of paths terminating at incubators for the provided footprint(S)

	Inputs:
		myFootprint(s): Footprint(s) to use as starting point
		sampleContainerHeight: Height of the container to compare with the max height allowed in the incubator/rack/deck
		myIncubatorInstrumentPackets: List of packets of all incubator instruments that should be considered for use
		myIncubatorRackPackets: List of packets of all incubator racks that should be considered for use
		myIncubatorDeckPackets: List of packets of all incubator decks that should be considered for use
			- Packets must contain Footprint (where applicable) and Positions fields
	Outputs:
		For each provided footprint, a list of incubator-anchored paths that represent sets of {incubator,(rack|deck),footprint,MaxHeight}
		that can be used to incubate a container of that footprint
	*)
incubatorsForFootprint[
	myFootprint: FootprintP|Null,
	sampleContainerHeight: DistanceP,
	myIncubatorInstrumentPackets: ListableP[{PacketP[]..}],
	myIncubatorRackPackets: ListableP[{PacketP[]..}],
	myIncubatorDeckPackets: ListableP[{PacketP[]..}]
] := FirstOrDefault[
	incubatorsForFootprint[{myFootprint}, {sampleContainerHeight}, myIncubatorInstrumentPackets,myIncubatorRackPackets,myIncubatorDeckPackets]
];
incubatorsForFootprint[
	myFootprints: {(FootprintP | Null)..},
	sampleContainerHeights_List,
	myIncubatorInstrumentPackets: ListableP[{PacketP[]..}],
	myIncubatorRackPackets: ListableP[{PacketP[]..}],
	myIncubatorDeckPackets: ListableP[{PacketP[]..}]
] := Module[
	{
		incubatorModels, incubatorPositions, incubatorModelsAlternatives,
		decks, deckFootprints, deckPositions, incubatorsForDecks, incubatorsForDecksFootprints, incubatorDeckFootprints, deckFootprintToModelLookup,
		relevantDecks, relevantDecksPositions, relevantDecksFootprints, relevantDecksPositionsFootprints, relevantDecksMaxHeights,
		incubatorDeckCombos, decksWithFootprintsAndMaxHeights, relevantDecksReplaceRules,
		racks, rackFootprints, rackPositions, decksWithRacks, decksWithRacksRackFootprints,
		relevantRacks, relevantRacksPositions, relevantRacksFootprints, relevantRacksPositionsFootprints, relevantRacksMaxHeights,
		racksWithFootprintsAndMaxHeights, deckRackReplacementRules, incubatorDeckOrRackCombos,
		finalIncubatorDeckOrRackCombos, possibleIncubatorsByFootprint, openIncubatorShelfHeights, openFootprintIncubators,
		openIncubatorAndMaxHeightPairs, incubatorModelsWithDupes, incubatorDeckFootprintsFlat, incubatorPositionsWithDupes,
		finalIncubatorDeckOrRackCombosWithDupes
	},

	(* Stash the list of incubator models & their positions *)
	incubatorModels = Lookup[Flatten[myIncubatorInstrumentPackets], Object];
	incubatorPositions = Lookup[Flatten[myIncubatorInstrumentPackets], Positions];

	(* Stash all the footprints of the incubators' decks *)
	(* We don't want to inadvertently pick up sensor probes or storage slots *)
	incubatorDeckFootprints = DeleteCases[
		Lookup[#, Footprint],
		EnvironmentalSensorProbe
	]&/@incubatorPositions;

	incubatorDeckFootprintsFlat = Flatten[incubatorDeckFootprints];

	(* Since a given incubator model may have more than one deck, we need to keep our list lengths happy *)
	incubatorModelsWithDupes = Flatten[
		MapThread[
			ConstantArray[#1, Length[#2]]&,
			{incubatorModels, incubatorDeckFootprints}
		]
	];

	incubatorPositionsWithDupes = Flatten[
		MapThread[
			ConstantArray[#1, Length[#2]]&,
			{incubatorPositions, incubatorDeckFootprints}
		],
		1
	];

	(* Convert to a list of alternatives to help filtering out decks and racks below *)
	incubatorModelsAlternatives = Alternatives @@ incubatorModels;

	(* Lookup the deck, deck's footprint, and deckPositions from the packets *)
	{
		decks,
		deckFootprints,
		deckPositions
	} = {
		Lookup[Flatten[myIncubatorDeckPackets], Object],
		Lookup[Flatten[myIncubatorDeckPackets], Footprint],
		Lookup[Flatten[myIncubatorDeckPackets], Positions]
	};

	(* Get the incubators relevant to the decks from their Positions Footprint *)
	incubatorsForDecks = PickList[incubatorModelsWithDupes, (MatchQ[#, CellIncubatorDeckP]& /@ incubatorDeckFootprintsFlat)];

	(* Get the relevant incubators' deck Positions Footprint *)
	incubatorsForDecksFootprints = PickList[incubatorDeckFootprintsFlat, (MatchQ[#, CellIncubatorDeckP]& /@ incubatorDeckFootprintsFlat)];

	(* Filter out only the relevant decks that are in incubators *)
	relevantDecks =
		PickList[decks,
			MatchQ[#, CellIncubatorDeckP]& /@ deckFootprints
		];

	(* Stash the footprints of the relevant decks' themselves (the deck footprint, not the footprint of the deck's positions *)
	relevantDecksFootprints = PickList[deckFootprints, MatchQ[#, CellIncubatorDeckP]& /@ deckFootprints];

	(* Stash the positions of the relevant decks *)
	relevantDecksPositions = PickList[deckPositions, MatchQ[#, CellIncubatorDeckP]& /@ deckFootprints];

	(* Stash the incubator models with an open shelf footprint*)
	openFootprintIncubators = PickList[incubatorModelsWithDupes, (MatchQ[#, IncubatorShelf]& /@ incubatorDeckFootprintsFlat)];

	(* Stash the open shelf incubator position's max allowed height*)
	openIncubatorShelfHeights = Max[Lookup[#, MaxHeight]]& /@ PickList[incubatorPositionsWithDupes, (MatchQ[#, IncubatorShelf]& /@ incubatorDeckFootprintsFlat)];

	(* Pair the open shelf incubators with their max supported height*)
	openIncubatorAndMaxHeightPairs = Transpose[{openFootprintIncubators, openIncubatorShelfHeights}];

	(* Lookup the footprints of the relevant decks' positions, and remove any duplicates *)
	relevantDecksPositionsFootprints = DeleteDuplicates /@ (Lookup[#, Footprint]& /@ relevantDecksPositions);

	(* Lookup the MaxHeights of the relevant decks' positions *)
	relevantDecksMaxHeights = DeleteDuplicates /@ (Lookup[#, MaxHeight]& /@ relevantDecksPositions);

	(*Make a list of replacement rules to swap the deck footprints for their Model*)
	deckFootprintToModelLookup = Normal[AssociationThread[relevantDecksFootprints, relevantDecks]];

	(* Make an initial list of all the incubator models and their associated decks in the form {{incubator,deck}..} *)
	incubatorDeckCombos = Transpose[{Flatten[incubatorsForDecks], (Flatten[incubatorsForDecksFootprints] /. deckFootprintToModelLookup)}];

	(* Assemble the lists of footprints (if any footprint matches it should work with the container), get the Max of the MaxHeight values
	allowed in the decks (to keep this a single value for each list), and combine with the list of deck models.
	If there is no MaxHeight, assume the typical separation between shelves of 15 Centimeter *)
	decksWithFootprintsAndMaxHeights =
		Transpose[{
			Flatten[relevantDecks],
			relevantDecksPositionsFootprints,
			Max /@ (relevantDecksMaxHeights /. {Null -> .15 Meter})
		}];

	(* Make a list of replace rules to swap any deck models in the list of {{incubator,deck}..} to be in the form of {{incubator,deck,Footprins,MaxHeight}..}
	This is NOT applied at this point, since some incubator decks have racks. First get all the rack info, then apply this last. *)
	relevantDecksReplaceRules =
		Normal[AssociationThread[Flatten[relevantDecks], decksWithFootprintsAndMaxHeights]];

	(* Lookup the rack, rack's containers, and rackPositions from the packets *)
	{
		racks,
		rackFootprints,
		rackPositions
	} = {
		Lookup[Flatten[myIncubatorRackPackets], Object],
		Lookup[Flatten[myIncubatorRackPackets], Footprint],
		Lookup[Flatten[myIncubatorRackPackets], Positions]
	};

	(* Filter out only the decks that have racks from the list of incubator relevant decks *)
	decksWithRacks = PickList[relevantDecks, (MatchQ[First[#], CellIncubatorRackP]& /@ relevantDecksPositionsFootprints)];

	(* Filter out only the decks that have racks from the list of incubator relevant decks *)
	decksWithRacksRackFootprints = PickList[relevantDecksPositionsFootprints, (MatchQ[First[#], CellIncubatorRackP]& /@ relevantDecksPositionsFootprints)];

	(* Get the relevant racks whose Footprint is in the list of incubator relevant racks *)
	relevantRacks = PickList[racks, MatchQ[#, CellIncubatorRackP]& /@ rackFootprints];

	(* Use the same PickList to pull out the Footprint of the incubator relevant racks *)
	relevantRacksFootprints = PickList[rackFootprints, MatchQ[#, CellIncubatorRackP]& /@ rackFootprints];

	(* Use the same PickList to pull out the Positions of the incubator relevant racks *)
	relevantRacksPositions = PickList[rackPositions, MatchQ[#, CellIncubatorRackP]& /@ rackFootprints];

	(* Pull out the unique Footprints from the Positions of the incubator relevant racks *)
	(* NOTE that I am doing a big hack here to hard code that Model[Container, Rack, "Standard Well Microplate Holder Stack"] takes plates even though its position footprints are Open *)
	(* doing this because these stacks are special and take a stack of plates but that are all in the same position (i.e., A1)*)
	(* we need to do this because the StorageAvailability system doesn't work very smootholy with plate stacks, and the Open trick gets us around it *)
	(* but the Open trick messes up the footprint tracking here when it really should be a plate, so I need to manually set this back *)
	(* ideally in the future we would be able to have the footprint of these positions to just be Plate to begin with, but as of writing this this is not the case *)
	relevantRacksPositionsFootprints = MapThread[
		DeleteDuplicates[
			If[MatchQ[#1, Model[Container, Rack, "id:J8AY5jwzPPjK"]],(*Standard Well Microplate Holder Stack*)
				Lookup[#2, Footprint] /. {Open -> Plate},
				Lookup[#2, Footprint]
			]
		]&,
		{relevantRacks, relevantRacksPositions}
	];

	(* Pull out the unique MaxHeights from the Positions of the incubator relevant racks *)
	relevantRacksMaxHeights = DeleteDuplicates /@ (Lookup[#, MaxHeight]& /@ relevantRacksPositions);

	(* Combine the list of the incubator relevant racks with Alternatives of their available Footprints and the Max Height of each rack
	(if Null, assume the standard height of a plate), to make a list of {{rack,FootprintAlternatives,MaxHeight}..} *)
	racksWithFootprintsAndMaxHeights = Transpose[{relevantRacks, relevantRacksPositionsFootprints, (Max /@ (relevantRacksMaxHeights /. {Null -> 0.045 Meter}))}];

	(* Use the above list to swap out footprints of the deck's racks with the appropriate rack/footprints/height combo *)
	deckRackReplacementRules = Normal[
		AssociationThread[
			Flatten[decksWithRacks],
			decksWithRacksRackFootprints
		]
	] /. Normal[AssociationThread[relevantRacksFootprints, racksWithFootprintsAndMaxHeights]];

	(* Use the deck-> rack replacement rules to swap out any decks that have racks with the appropriate rack/footprints/height combo*)
	incubatorDeckOrRackCombos = incubatorDeckCombos /. deckRackReplacementRules;

	(* Finally, use the earlier replacement rules to replace any remaining decks in the list with the deck/footprints/height combo.
	Flatten each sublist to level 1, so the only remaining sublist is the list of possible footprints (everything else should be a single value).
	This should result in a final list of {{incubator,rack|deck,{footprints},maxheight}..} to compare the container with *)

	finalIncubatorDeckOrRackCombos = Flatten[#, 1]& /@ (incubatorDeckOrRackCombos /. relevantDecksReplaceRules);

	(* One last thing: if a given deck has racks with more than one footprint, we need to duplicate the incubator with that deck *)
	finalIncubatorDeckOrRackCombosWithDupes = Map[
		Function[
			{combo},
			If[MatchQ[combo[[2]], _List],
				Splice[
					Map[
						Function[
							{rack},
							Flatten[{First[combo], rack},	1]
						],
						Rest[combo]
					]
				],
				combo
			]
		],
		finalIncubatorDeckOrRackCombos
	];

	(* Pick out the possible incubators for each footprint and MaxHeight to return an
	index-matched list of incubators for each provided footprint/MaxHeight input *)
	possibleIncubatorsByFootprint = MapThread[
		Function[{myFootprint, myMaxHeight},
			(*Outer MapThread: If either the footprint or the max height is Null,give an empty list (e.g.no compatible incubators).
			As long as both the footprint and height are informed, pass the footprint and height to the inner MapThread across the possible incubators
			 to get the list of possible incubators that can work with the provided footprint and the max height of the sample's container.
			*)
			If[
				NullQ[myFootprint] || NullQ[myMaxHeight],
				{},
				(* Inner MapThread:
				 If no incubator/height combos match the footprint and maxheight, then return nothing as no standard incubators are compatible*)
				MapThread[
					Function[{incubator, rackOrDeck, footprints, maxHeight},
						Module[{possibleIncubators, openIncubators},
							possibleIncubators = If[MemberQ[footprints, myFootprint] && maxHeight >= myMaxHeight,
								incubator,
								Nothing
							];
							(*InnerMost Map: Check the open footprint incubator/max height pairs against the max height of the containers*)
							openIncubators = If[
								#[[2]] >= myMaxHeight,
								#[[1]],
								Nothing
							]& /@ openIncubatorAndMaxHeightPairs;
							Flatten[{possibleIncubators, openIncubators}]
						]
					],
					Transpose[finalIncubatorDeckOrRackCombosWithDupes]
				]
			]
		],
		{myFootprints, sampleContainerHeights}
	];
	DeleteDuplicates[Flatten[#]]& /@ possibleIncubatorsByFootprint
];

(* ::Section:: *)
(*End Private*)

(* ::Subsection:: *)
(*IncubateCells Resolvers *)

(*::Subsubsection::Closed:: *)
(*resolveIncubateCellsMethod and resolveIncubateCellsWorkCell*)

(* these two functions serve different purposes but are extremely similar on the inside so they are just wrappers for a shared internal function *)
DefineOptions[resolveIncubateCellsMethod,
	Options :> {
		{
			OptionName -> FromExperimentIncubateCells,
			Default -> False,
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[Type -> Enumeration, Pattern :> BooleanP]
			],
			Description -> "Indicates if this function is called inside of ExperimentIncubateCells (in which case we have all the Cache information and thus don't need to Download again).",
			Category -> "Hidden"
		}
	},
	SharedOptions :> {
		ExperimentIncubateCells,
		CacheOption,
		SimulationOption
	}
];

DefineOptions[resolveIncubateCellsWorkCell,
	SharedOptions :> {
		resolveIncubateCellsMethod
	}
];

(* call the core function with the Method input *)
resolveIncubateCellsMethod[
	myContainers: ListableP[(ObjectP[{Object[Container], Object[Sample]}] | Automatic)],
	myOptions: OptionsPattern[]
] := resolveIncubateCellsMethodCore[
	Method,
	myContainers,
	myOptions
];

(* call the core function with the WorkCell input *)
resolveIncubateCellsWorkCell[
	myContainers:ListableP[(ObjectP[{Object[Container], Object[Sample]}] | Automatic)],
	myOptions:OptionsPattern[]
] := resolveIncubateCellsMethodCore[
	WorkCell,
	myContainers,
	myOptions
];

(* NOTE: You should NOT throw messages in this function. Just return the methods by which you can perform your primitive with *)
(* the given options. *)
resolveIncubateCellsMethodCore[
	myMethodOrWorkCell: Method | WorkCell,
	myContainers: ListableP[(ObjectP[{Object[Container], Object[Sample]}] | Automatic)],
	myOptions: OptionsPattern[]
] := Module[
	{allSamplePackets, downloadedPacketsFromContainers,
		downloadedPacketsFromSamples, downloadedPacketsFronInstruments, downloadedPacketsFromInstrumentModels,
		cache, simulation, listedInputs, specifiedPreparation, safeOps, fastAssoc, quantificationMethod, quantificationInstrument,
		gatherTests, outputSpecification, output, tests, manualRequirementStrings, roboticRequirementStrings,
		allFootprintsRobotCompatibleQ, roboticIncubatorQ, fromExperimentIncubateCellsQ, specifiedWorkCell,
		allModelContainerPackets, allModelContainerFootprints, allInstrumentObjects, inputContainers, inputSamples,
		inputInstruments, inputInstrumentModels, allInstrumentModelPackets, incubator, time, compositionCellTypes,
		allSampleCellTypes, optionsCellTypes, allCellTypes, workCellBasedOnCellType, incubatorCellTypes, workCellResult,
		workCellBasedOnIncubators, bioSTARRequirementStrings, microbioSTARRequirementStrings, methodResult},

	(* Make sure these are a list *)
	listedInputs = ToList[myContainers];

	(* Get the safe options *)
	(* resolveIncubateCellsMethod and resolveIncubateCellsWorkCell have the same options so just pick one *)
	safeOps = SafeOptions[resolveIncubateCellsMethod, ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* pull out the cache, simulation, incubator, and specified preparation *)
	{
		cache, simulation, specifiedPreparation, specifiedWorkCell, incubator, time, quantificationMethod, quantificationInstrument
	} = Lookup[safeOps, {Cache, Simulation, Preparation, WorkCell, Incubator, Time, QuantificationMethod, QuantificationInstrument}];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Generate a fast assoc from the cache passed in; if we're from within ExperimentIncubateCells then we don't need to Download information over again *)
	fromExperimentIncubateCellsQ = Lookup[safeOps, FromExperimentIncubateCells];
	fastAssoc = If[fromExperimentIncubateCellsQ,
		makeFastAssocFromCache[cache],
		<||>
	];

	inputContainers = Cases[myContainers, ObjectP[Object[Container]]];
	inputSamples = Cases[myContainers, ObjectP[Object[Sample]]];
	inputInstruments = Cases[Flatten[{incubator, quantificationInstrument}], ObjectP[Object[Instrument]]];
	inputInstrumentModels = Cases[Flatten[{incubator, quantificationInstrument}], ObjectP[Model[Instrument]]];

	(* Download information that we need from our inputs and/or options. *)
	(* pull the information out of the fastAssoc and use that instead of the Download if we have it *)
	(* formatting is admittedly a little bit weird; deconvolute it below *)
	{
		downloadedPacketsFromContainers,
		downloadedPacketsFromSamples,
		downloadedPacketsFronInstruments,
		downloadedPacketsFromInstrumentModels
	} = If[Not[fromExperimentIncubateCellsQ],
		Quiet[
			Download[
				{
					inputContainers,
					inputSamples,
					inputInstruments,
					inputInstrumentModels
				},
				{

					{
						(* getting Model container packet from Object[Container]*)
						Packet[Model[Footprint]],
						(* getting contents packets from Object[Container] *)
						Packet[Contents[[All, 2]][{CellType, Composition}]]
					},
					{
						(* getting Model container packet from Object[Sample]*)
						Packet[Container[Model][Footprint]],
						(* getting sample packet from Object[Sample] *)
						Packet[CellType, Composition]
					},
					(* getting the model packet from the Object[Instrument] *)
					{Packet[Model[{Mode, CellTypes}]]},
					(* getting the model packet from the Model[Instrument] *)
					{Packet[Mode, CellTypes]}
				},
				Simulation -> simulation
			],
			{Download::NotLinkField, Download::FieldDoesntExist}
		],
		{
			(* same format as the Download above except pulling from the fastAssoc *)
			{
				fastAssocPacketLookup[fastAssoc, #, Model]& /@ inputContainers,
				Map[
					Function[{container},
						Map[
							Function[{content},
								fetchPacketFromFastAssoc[content, fastAssoc]
							],
							fastAssocLookup[fastAssoc, container, Contents][[All, 2]]
						]
					],
					inputContainers
				]
			},
			{
				fastAssocPacketLookup[fastAssoc, #, {Container, Model}]& /@ inputSamples,
				fetchPacketFromFastAssoc[#, fastAssoc]& /@ inputSamples
			},
			{fastAssocPacketLookup[fastAssoc, #, Model]& /@ inputInstruments},
			{fetchPacketFromFastAssoc[#, fastAssoc]& /@ inputInstrumentModels}
		}
	];

	(* Deconvolute the Download above *)
	allModelContainerPackets = Cases[Flatten[{downloadedPacketsFromContainers, downloadedPacketsFromSamples}], PacketP[Model[Container]]];
	allSamplePackets = Cases[Flatten[{downloadedPacketsFromContainers, downloadedPacketsFromSamples}], PacketP[Object[Sample]]];
	allInstrumentModelPackets = Cases[Flatten[{downloadedPacketsFronInstruments, downloadedPacketsFromInstrumentModels}], PacketP[Model[Instrument]]];

	(* Determine if all the container model packets in question can fit on the liquid handler *)
	allModelContainerFootprints = Lookup[allModelContainerPackets, Footprint, {}];
	allFootprintsRobotCompatibleQ = MatchQ[allModelContainerFootprints, {LiquidHandlerCompatibleFootprintP..}];

	(* Get all of our Model[Instrument]s *)
	allInstrumentObjects = Lookup[allInstrumentModelPackets, Object, {}];

	(* Determine whether we're using a robotic incubator; don't love this hardcoded list but going with it for now *)
	(* {Model[Instrument, Incubator, "STX44-ICBT with Humidity Control"], Model[Instrument, Incubator, "STX44-ICBT with Shaking"]} *)
	roboticIncubatorQ = MemberQ[allInstrumentObjects, ObjectP[{Model[Instrument, Incubator, "id:AEqRl954GpOw"], Model[Instrument, Incubator, "id:N80DNjlYwELl"]}]];

	(* Get all the CellTypes of the samples *)
	(* if we can't figure it out from the CellType field, go to the Composition field.  If we can't figure it out from there, look at what was specified *)
	compositionCellTypes = Map[
		Function[{composition},
			With[{reverseSortedIdentityModels = ReverseSortBy[composition, First][[All, 2]]},
				(* this [[2]] is definitely weird here; basically, I want Model[Cell, Bacterial, "id:lkjlkjlkj"] to become Bacterial *)
				Download[SelectFirst[reverseSortedIdentityModels, MatchQ[#, ObjectP[Model[Cell]]]&, {Null, Null}],Object][[2]]
			]
		],
		Lookup[allSamplePackets, Composition, {}]
	];
	allSampleCellTypes = MapThread[
		Function[{samplePacket, compositionCellType},
			Which[
				MatchQ[Lookup[samplePacket, CellType], CellTypeP], Lookup[samplePacket, CellType],
				MatchQ[compositionCellType, CellTypeP], compositionCellType,
				True, Null
			]
		],
		{allSamplePackets, compositionCellTypes}
	];

	(* Figure out the CellTypes specified in the options, then smash it all together *)
	optionsCellTypes = ToList[Lookup[safeOps, CellType]];
	allCellTypes = Cases[Flatten[{allSampleCellTypes, optionsCellTypes}], CellTypeP|Null];

	(* Determine what work cell we can use based on the cell type *)
	workCellBasedOnCellType = Which[
		(* if we're ONLY Nulls, then we don't know and can just pick either *)
		MatchQ[allCellTypes, {Null..}], {microbioSTAR, bioSTAR},
		(* if any CellType are NonMicrobial (or we have Nulls), need to use bioSTAR *)
		MatchQ[allCellTypes, {(NonMicrobialCellTypeP|Null)..}], {bioSTAR},
		(* if any CellType are Microbial (or we have Nulls), need to use microbioSTAR *)
		MatchQ[allCellTypes, {(MicrobialCellTypeP|Null)..}], {microbioSTAR},
		(* if somehow we have some microbial and some non microbial then we can't have any work cell and will throw an error below *)
		True, {}
	];

	(* Determine which work cell we can use based on the incubator(s) specified *)
	incubatorCellTypes = Flatten[Lookup[allInstrumentModelPackets, CellTypes, {}]];
	workCellBasedOnIncubators = Which[
		(* if we didn't specify an incubator, we don't have a preference at this point *)
		MatchQ[incubatorCellTypes, {}], {microbioSTAR, bioSTAR},
		MatchQ[incubatorCellTypes, {NonMicrobialCellTypeP..}], {bioSTAR},
		MatchQ[incubatorCellTypes, {MicrobialCellTypeP..}], {microbioSTAR},
		(* if we have a microbial and a non microbial incubator specified in the same protocol, then we need to throw an error because can't do both at once *)
		True, {}
	];

	(* Create a list of reasons why we need Preparation->Manual. *)
	manualRequirementStrings = {
		If[MatchQ[specifiedPreparation, Manual],
			"the Preparation option is set to Manual by the user",
			Nothing
		],
		If[MemberQ[allModelContainerFootprints, Except[Plate]],
			"the sample containers do not have Plate footprint for Robotic incubation",
			Nothing
		],
		If[MatchQ[time, GreaterP[$MaxRoboticIncubationTime]],
			"the specified Time of "<> ToString[time] <> " exceeds the maximum time (" <> ToString[$MaxRoboticIncubationTime] <> ") allowed for incubation with Robotic preparation",
			Nothing
		],
		If[MatchQ[quantificationMethod, ColonyCount],
			"the QuantificationMethod is ColonyCount, which is not compatible with Robotic incubation using a liquid handler and its integrations",
			Nothing
		],
		If[MemberQ[allInstrumentObjects, ObjectP[Model[Instrument, ColonyHandler]]],
			"the QuantificationInstrument is a colony handler, which is not compatible with Robotic incubation using a liquid handler and its integrations",
			Nothing
		]
	};

	(* Create a list of reasons why we need Preparation->Robotic. *)
	roboticRequirementStrings = {
		If[MatchQ[specifiedPreparation, Robotic],
			"the Preparation option is set to Robotic by the user",
			Nothing
		],
		If[roboticIncubatorQ,
			"the Robotic incubators are requested by the user",
			Nothing
		]
	};

	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[MatchQ[myMethodOrWorkCell, Method] && Length[manualRequirementStrings] > 0 && Length[roboticRequirementStrings] > 0 && !gatherTests,
		(* NOTE: Blocking $MessagePrePrint stops our error message from being truncated with ... if it gets too long. *)
		Block[{$MessagePrePrint},
			Message[
				Error::ConflictingUnitOperationMethodRequirements,
				listToString[manualRequirementStrings],
				listToString[roboticRequirementStrings]
			]
		]
	];

	(* Determine the method that can be performed (robotic|manual) *)
	methodResult = Which[
		(* Always respect the user's input *)
		!MatchQ[specifiedPreparation, Automatic], specifiedPreparation,
		(* If we have any non-plate footprints we definitely can only do this manually *)
		MemberQ[allModelContainerFootprints, Except[Plate]], Manual,
		(* If the Time exceeds the $MaxRoboticIncubationTime, we have to do Manual. *)
		MatchQ[time, GreaterP[$MaxRoboticIncubationTime]], Manual,
		(* If we are counting colonies, we have to do manual because Robotic would require multiple work cells (bioSTAR and QPix) *)
		MemberQ[allInstrumentObjects, ObjectP[Model[Instrument, ColonyHandler]]] || MatchQ[quantificationMethod, ColonyCount], Manual,
		(* If any robotic incubators are specified, it should be robotic *)
		roboticIncubatorQ, Robotic,
		(* Otherwise, allow both *)
		True, {Manual, Robotic}
	];

	(* Create a list of reasons why we need WorkCell -> bioSTAR. *)
	bioSTARRequirementStrings = {
		If[MatchQ[specifiedWorkCell, bioSTAR],
			"the WorkCell option is set to bioSTAR by the user",
			Nothing
		],
		If[MemberQ[optionsCellTypes, NonMicrobialCellTypeP],
			"the specified CellType option includes a non-microbial cell type",
			Nothing
		],
		If[MemberQ[allSampleCellTypes, NonMicrobialCellTypeP],
			"the input samples contain a non-microbial cell type",
			Nothing
		],
		If[MemberQ[incubatorCellTypes, NonMicrobialCellTypeP],
			"the specified Incubator option includes an incubator for a non-microbial cell type",
			Nothing
		]
	};

	(* Create a list of reasons why we need WorkCell -> microbioSTAR. *)
	microbioSTARRequirementStrings = {
		If[MatchQ[specifiedWorkCell, microbioSTAR],
			"the WorkCell option is set to microbioSTAR by the user",
			Nothing
		],
		If[MemberQ[optionsCellTypes, MicrobialCellTypeP],
			"the specified CellType option includes a microbial cell type",
			Nothing
		],
		If[MemberQ[allSampleCellTypes, MicrobialCellTypeP],
			"the input samples contain a microbial cell type",
			Nothing
		],
		If[MemberQ[incubatorCellTypes, MicrobialCellTypeP],
			"the specified Incubator option includes an incubator for a microbial cell type",
			Nothing
		]
	};

	(* Throw an error if we don't have a work cell we can use *)
	(* only bother with this if we're using Robotic anyway *)
	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[MatchQ[myMethodOrWorkCell, WorkCell] && MemberQ[ToList[methodResult], Robotic] && Length[bioSTARRequirementStrings] > 0 && Length[microbioSTARRequirementStrings] > 0 && !gatherTests,
		(* NOTE: Blocking $MessagePrePrint stops our error message from being truncated with ... if it gets too long. *)
		Block[{$MessagePrePrint},
			Message[
				Error::ConflictingIncubationWorkCells,
				listToString[bioSTARRequirementStrings],
				listToString[microbioSTARRequirementStrings]
			]
		]
	];

	(* Determine the method that can be performed (bioSTAR|microbioSTAR) *)
	(* Always respect the user's input *)
	workCellResult = If[!MatchQ[specifiedWorkCell, Automatic],
		specifiedWorkCell,
		(* doing unsorted because Intersection is dumb and it sorts *)
		UnsortedIntersection[workCellBasedOnCellType, workCellBasedOnIncubators]
	];

	tests = Which[
		MatchQ[gatherTests, False], {},
		MatchQ[myMethodOrWorkCell, Method],
			{Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the IncubateCells unit operation:",
				False,
				Length[manualRequirementStrings] > 0 && Length[roboticRequirementStrings] > 0
			]},
		True,
			{Test["There are not conflicting bioSTAR and microbioSTAR requirements when resolving the WorkCell method for the IncubateCells unit operation:",
				False,
				Length[manualRequirementStrings] > 0 && Length[roboticRequirementStrings] > 0
			]}
	];

	outputSpecification /. {Result -> If[MatchQ[myMethodOrWorkCell, Method], methodResult, workCellResult], Tests -> tests}

];

(* ::Subsection::Closed:: *)
(*ExperimentIncubateCellsPreview*)


DefineOptions[ExperimentIncubateCellsPreview,
	SharedOptions :> {ExperimentIncubateCells}
];


ExperimentIncubateCellsPreview[myInput: ListableP[ObjectP[{Object[Sample], Object[Container]}]|_String], myOptions: OptionsPattern[ExperimentIncubateCellsPreview]] := Module[
	{listedOptions},

	listedOptions = ToList[myOptions];

	ExperimentIncubateCells[myInput, ReplaceRule[listedOptions, Output -> Preview]]
];

(* ::Subsection::Closed:: *)

(*ExperimentIncubateCellsOptions*)


DefineOptions[ExperimentIncubateCellsOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentIncubateCells}
];


ExperimentIncubateCellsOptions[myInput: ListableP[ObjectP[{Object[Sample], Object[Container]}]|_String], myOptions: OptionsPattern[ExperimentIncubateCellsOptions]] := Module[
	{listedOptions, preparedOptions, resolvedOptions},

	listedOptions = ToList[myOptions];

	(* Send in the correct Output option and remove OutputFormat option *)
	preparedOptions = Normal@KeyDrop[Append[listedOptions, Output -> Options], {OutputFormat}];

	resolvedOptions  =ExperimentIncubateCells[myInput, preparedOptions];

	(* Return the option as a list or table *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]], Table]&&MatchQ[resolvedOptions ,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions, ExperimentIncubateCells],
		resolvedOptions
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentIncubateCellsQ*)

DefineOptions[ValidExperimentIncubateCellsQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentIncubateCells}
];


ValidExperimentIncubateCellsQ[myInput: ListableP[ObjectP[{Object[Sample], Object[Container]}]|_String], myOptions: OptionsPattern[ValidExperimentIncubateCellsQ]] := Module[
	{listedInput, listedOptions, preparedOptions, functionTests, initialTestDescription, allTests, safeOps, verbose, outputFormat},

	listedInput = ToList[myInput];
	listedOptions = ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = Normal@KeyDrop[Append[listedOptions, Output -> Tests], {Verbose, OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests = ExperimentIncubateCells[myInput, preparedOptions];

	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests = If[MatchQ[functionTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[{initialTest, validObjectBooleans, voqWarnings},
			initialTest = Test[initialTestDescription, True, True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[listedInput, _String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[ToString[#1, InputForm] <> " is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{DeleteCases[listedInput, _String], validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Join[{initialTest}, functionTests, voqWarnings]
		]
	];

	(* Lookup test running options *)
	safeOps = SafeOptions[ValidExperimentIncubateCellsQ, Normal@KeyTake[listedOptions, {Verbose, OutputFormat}]];
	{verbose, outputFormat} = Lookup[safeOps, {Verbose, OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentIncubateCells" -> allTests|>,
			Verbose -> verbose,
			OutputFormat -> outputFormat
		],
		"ExperimentIncubateCells"
	]
];

(* ::Section:: *)
(*End Private*)
