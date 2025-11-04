(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(*IncubateCells*)

(* ::Subsubsection::Closed:: *)
(*Options and Lookups*)
DefineOptions[
	ExperimentIncubateCells,
	Options :> {
		PreparationOption,
		BiologyWorkCellOption,
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
				Description -> "The type of the most abundant cells that are thought to be present in this sample. Options include Bacterial, Mammalian, and Yeast.",
				ResolutionDescription -> "Automatically set to match the value of CellType of the input sample if it is populated, or set to Mammalian if CultureAdhesion is Adherent or if WorkCell is bioSTAR. If the cell type is unknown, automatically set to Bacterial.",
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
				Description -> "The manner of cell growth the cells in the sample are thought to employ. Options include SolidMedia, Suspension, and Adherent. SolidMedia cells grow in colonies on a nutrient rich substrate, suspended cells grow free floating in liquid media, and adherent cells grow attached to a substrate.",
				ResolutionDescription -> "Automatically set to match the CultureAdhesion value of the input sample if it is populated, or set to Adherent if CellType is Mammalian, or set to SolidMedia if the State value of the input sample is Solid. Otherwise set to Suspension.",
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
					Pattern :> IncubatedCellSampleStorageTypeP|AmbientStorage|Refrigerator|Disposal
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
		SimulationOption
	}
];

(* Incubator model to preferred container lookup *)
incubatorToPreferredContainerLookup = <|
	(*"Cytomat HERAcell 240i TT 10"*)
	Model[Instrument, Incubator, "id:Z1lqpMGjeKN9"] -> Model[Container, Plate, "id:E8zoYveRlldX"],(*"24-well Tissue Culture Plate"*)
	(*"Bactomat HERAcell 240i TT 10 for Bacteria"*)
	Model[Instrument, Incubator, "id:xRO9n3vk1JbO"] -> Model[Container, Plate, "id:O81aEBZjRXvx"],(* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
	(*"Bactomat HERAcell 240i TT 10 for Yeast"*)
	Model[Instrument, Incubator, "id:7X104vK9ZbLR"] -> Model[Container, Plate, "id:O81aEBZjRXvx"],(* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
	(*"Innova 44 for Bacterial Plates"*)
	Model[Instrument, Incubator, "id:AEqRl954Gpjw"] -> Model[Container, Plate, "id:jLq9jXY4kkMq"],(*"24-well Round Bottom Deep Well Plate, Sterile"*)
	(*"Innova 44 for Bacterial Flasks"*)
	Model[Instrument, Incubator, "id:D8KAEvdqzXok"] -> Model[Container, Vessel, "id:N80DNjlYwwjo"],(* 125 mL Erlenmeyer Flask *)
	(*"Innova 44 for Yeast Plates"*)
	Model[Instrument, Incubator, "id:O81aEB4kJJre"] -> Model[Container, Plate, "id:jLq9jXY4kkMq"],(*"24-well Round Bottom Deep Well Plate, Sterile"*)
	(*"Innova 44 for Yeast Flasks"*)
	Model[Instrument, Incubator, "id:rea9jl1orkAx"] -> Model[Container, Vessel, "id:N80DNjlYwwjo"],(* 125 mL Erlenmeyer Flask *)
	(*"STX44-ICBT with Humidity Control"*)
	Model[Instrument, Incubator, "id:AEqRl954GpOw"] -> Model[Container, Plate, "id:E8zoYveRlldX"],(*"24-well Tissue Culture Plate"*)
	(*"STX44-ICBT with Shaking"*)
	Model[Instrument, Incubator, "id:N80DNjlYwELl"] -> Model[Container, Plate, "id:jLq9jXY4kkMq"],(*"24-well Round Bottom Deep Well Plate, Sterile"*)
	(*"Multitron Pro with 3mm Orbit"*)
	Model[Instrument, Incubator, "id:GmzlKjY5EEG9"] -> Model[Container, Plate, "id:jLq9jXY4kkMq"],(*"24-well Round Bottom Deep Well Plate, Sterile"*)
	(*"Multitron Pro with 25mm Orbit"*)
	Model[Instrument, Incubator, "id:AEqRl954GG0l"]-> Model[Container, Vessel, "id:N80DNjlYwwjo"](* 125 mL Erlenmeyer Flask *)
|>;

(* Incubator to allowed CultureAdhesion lookup *)
(* Note: this is temporarily hard-coded before I figure out how we can have it live in instrument model packet *)
incubatorToAllowedCultureAdhesionLookup = <|
	(*"Cytomat HERAcell 240i TT 10"*)
	Model[Instrument, Incubator, "id:Z1lqpMGjeKN9"] -> {Adherent},
	(*"Bactomat HERAcell 240i TT 10 for Bacteria"*)
	Model[Instrument, Incubator, "id:xRO9n3vk1JbO"] -> {SolidMedia},
	(*"Bactomat HERAcell 240i TT 10 for Yeast"*)
	Model[Instrument, Incubator, "id:7X104vK9ZbLR"] -> {SolidMedia},
	(*"Innova 44 for Bacterial Plates"*)
	Model[Instrument, Incubator, "id:AEqRl954Gpjw"] -> {Suspension},
	(*"Innova 44 for Bacterial Flasks"*)
	Model[Instrument, Incubator, "id:D8KAEvdqzXok"] -> {Suspension},
	(*"Innova 44 for Yeast Plates"*)
	Model[Instrument, Incubator, "id:O81aEB4kJJre"] -> {Suspension},
	(*"Innova 44 for Yeast Flasks"*)
	Model[Instrument, Incubator, "id:rea9jl1orkAx"] -> {Suspension},
	(*"STX44-ICBT with Humidity Control"*)
	Model[Instrument, Incubator, "id:AEqRl954GpOw"] -> {Adherent},
	(*"STX44-ICBT with Shaking"*)
	Model[Instrument, Incubator, "id:N80DNjlYwELl"] -> {Suspension},
	(*"Multitron Pro with 3mm Orbit"*)
	Model[Instrument, Incubator, "id:GmzlKjY5EEG9"] -> {Suspension, SolidMedia},
	(*"Multitron Pro with 25mm Orbit"*)
	Model[Instrument, Incubator, "id:AEqRl954GG0l"]-> {Suspension, SolidMedia}
|>;

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

(* Use of the liquid handler-integrated incubator occupies the entire liquid handler for the duration of incubation. To limit this, *)
(* the max duration of cell culture when Preparation -> Robotic is stored as $MaxRoboticIncubationTime and can be found in Constants.m  *)

(* Patterns specific to ExperimentIncubateCells *)
(* This is to accommodate the slightly awkward placement of a tube rack inside the plate incubator *)
plateIncubatorFootprintsP = Alternatives[Plate, Conical15mLTube];

(* ::Subsubsection::Closed:: *)
(*ExperimentIncubateCells Source Code*)

(* Container Overload *)
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
					{Packet[Model, Manufacturer, Mode, CellType], Packet[Model[Manufacturer, Mode, CellType]]},
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
(*Errors and warnings*)
(* Invalid Inputs - New style for shared messages *)
Error::DiscardedSample = "`1` `2`";
Error::DeprecatedModel = "`1` `2`";
Error::GaseousSamples = "`1` `2`";
Warning::EmptySamples = "`1`. `2`";
Error::ConflictingIncubationWorkCells = "Robotic IncubateCells protocol or unit operation requires a single WorkCell for all input samples. `1`. `2`. Please `3` in order to submit a valid IncubateCells protocol or unit operation.";
(* Invalid Inputs *)
Error::InvalidPlateSamples = "ExperimentIncubateCells stores prepared plates inside of a cell incubator, keeping all samples in each plate together. `1`. Please use ExperimentTransfer to transfer `2` to avoid culturing additional samples or specify `3`.";
Warning::UnsealedCellCultureVessels = "ExperimentIncubateCells requires cell culture vessels to be covered before incubation to prevent contamination. `1` `2``3` without any cover. `4` will be covered automatically before being stored inside of a cell incubator.";
Error::UnsupportedCellTypes = "`1`. `2`. Please contact Scientific Solutions team if you have a sample that falls outside current support.";
Warning::CellTypeNotSpecified = "The cell types supported at ECL include Mammalian, Bacterial, and Yeast. `1` no cell type detected in the CellType field, and the CellType option is not specified. For `2`, the CellType option will default to Bacterial. If this is not desired, please specify a different cell type or use UploadSampleProperties to define the CellType of the sample(s).";
Warning::CultureAdhesionNotSpecified = "`1`. `2` no cell culture type detected in the CultureAdhesion field, and the CultureAdhesion option is not specified. `3`. If this is not desired, please specify a different cell culture type or use UploadSampleProperties to define the CultureAdhesion of the sample(s).";
Error::InvalidIncubationConditions = "The supported default incubation conditions are MammalianIncubation, BacterialIncubation, BacterialShakingIncubation, YeastIncubation, and YeastShakingIncubation. `1` the IncubationCondition option specified as `2`. If you have a desired IncubationCondition that falls outside our current default incubation conditions, please choose Custom and configure Temperature, CarbonDioxide, RelativeHumidity, ShakingRate and ShakingRadius settings.";
Error::TooManyIncubationSamples = "`1`. Please split the experiment call into multiple in order to not exceed the capacity of the incubator(s).";
(* Invalid Options *)
Error::IncubationMaxTemperature = "Temperature cannot be set above the MaxTemperature of cell culture vessels. `1` `2``3` MaxTemperature(s) of `4`. Please lower the Temperature to specify a valid protocol.";
Warning::ConflictingCellType = "`1`. `2` the CellType option specified as `3` but the CellType field is `4`. For these sample(s), the specified CellType option will be used. If this is not desired, please set the CellType option to match the CellType field or let it set automatically.";
Error::ConflictingCellType = "`1`. `2` the CellType option specified as `3` but the CellType field is `4`. For these sample(s), please ensure the CellType option match the CellType field in the objects or use UploadSampleProperties to define the CellType field of the sample(s), or let the option be set automatically.";
Error::ConflictingCultureAdhesion = "`1`. `2`. For these sample(s), please ensure the CultureAdhesion option matches `3` or use UploadSampleProperties to define `3`.";
Error::ConflictingShakingConditions = "There are conflicts detected in shaking options. `1`. `2` Please change `3` settings to a valid combination or let them be set automatically.";
Error::UnsupportedCellCultureType = "`1`. `2`. `3`";
Error::ConflictingCellTypeWithCultureAdhesion = "`1`. `2`. For these sample(s), `3`.";
Error::ConflictingCultureAdhesionWithContainer = "`1`. `2` CultureAdhesion specified in the option as `3` and `4`. For these sample(s), `5`.";
Error::ConflictingIncubationConditionsForSameContainer = "`1`. `2`. Please use ExperimentTransfer to transfer the input samples into different containers if different incubation or storage conditions are desired or allow the conflicting options to be set automatically, or specify the same options for each sample in the same container.";
Warning::ConflictingCellTypeWithStorageCondition = "`1` If this is undesired, please specify an alternative SamplesOutStorageCondition or let it be set automatically.";
Error::ConflictingCellTypeWithStorageCondition = "If stored in incubators, mammalian and microbial cells are kept separate to prevent contamination. `1` If this is undesired, please specify an alternative SamplesOutStorageCondition or let it be set automatically.";
Warning::ShakingRecommendedForStorageCondition = "In suspension cultures, shaking helps prevent cell settling, improves gas exchange, and ensures uniform nutrient availability. `1` CultureAdhesion specified in the option as Suspension and SamplesOutStorageCondition specified in the option as `2`. If this is not desired, please specify SamplesOutStorageCondition to `3`.";
(* Incubator Errors and warnings *)
Error::TooManyCustomIncubationConditions = "`1` `2`. Please either use default incubation conditions to allow the use of shared incubator devices, or split the experiment call into separate protocols.";
Warning::CustomIncubationConditionNotSpecified = "Custom incubators can be configured with specific temperature, carbon dioxide percentage, relative humidity percentage, and shaking conditions. `1` the IncubationCondition specified as Custom and `2` are left unspecified and default value(s) will be used. If this is not desired, please specify `2`.";
Warning::ConflictingCellTypeWithIncubator = "`1`If this is undesired, please specify an alternative incubator or let it be set automatically.";
Error::IncubatorIsIncompatible = "`1` `2``3`Please specify an alternative incubator or let it be set automatically.";
Error::ConflictingIncubatorWithSettings = "`1` `2``3`";
Error::InvalidCellIncubationContainers = "`1` `2``3`To view complete lists of accepted container models for potential incubators, please use IncubateCellsDevices[All, <myCellTypeAndCultureAdhesionOptions>].";
Error::NoIncubatorForSettings = "`1` `2``3``4`";
Error::NoIncubatorForContainersAndSettings = "`1` `2` `3` `4`To view complete lists of accepted container models for potential incubators, please use IncubateCellsDevices[All, <myOptions>].";
Warning::ConflictingCellTypeWithIncubationCondition = "`1`If this is undesired, please specify an alternative incubation condition or let it be set automatically.";
Error::IncubationConditionIsIncompatible = "`1` `2``3`Please specify an alternative incubation condition or let it be set automatically.";
Error::ConflictingIncubationConditionWithSettings = "`1` `2``3`";
Error::ConflictingIncubatorIncubationCondition = "`1` `2``3`Please specify an alternative incubator or incubation condition, or let one of them be set automatically.";
(* v2 Errors and warnings *)
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
(*resolveExperimentIncubateCellsOptions*)

DefineOptions[
	resolveExperimentIncubateCellsOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentIncubateCellsOptions[mySamples: {ObjectP[Object[Sample]]...}, myOptions: {_Rule...}, myResolutionOptions: OptionsPattern[resolveExperimentIncubateCellsOptions]] := Module[
	{
		(* Setup *)
		outputSpecification, output, gatherTests, messages, notInEngine, cacheBall, simulation, fastAssoc, confirm, canaryBranch,
		template, fastTrack, operator, parentProtocol, upload, outputOption, quantificationOptionsExceptAliquoting,
		quantificationAliquotingOptions, samplePackets, sampleModelPackets, sampleContainerPackets, sampleContainerModelPackets,
		sampleContainerHeights, sampleContainerFootprints, fastAssocKeysIDOnly, incubatorPackets, rackPackets, deckPackets,
		storageConditionPackets, plateReaderInstrumentPacket, incubationConditionOptionDefinition, incubationConditionSymbols,
		allowedStorageConditionSymbols, customIncubatorPackets, customIncubators, incubationConditionIncubatorLookup,
		incubatorIncubationConditionLookup,
		(* Input invalidation check *)
		discardedSamplePackets, discardedInvalidInputs, discardedTest, deprecatedSampleModelPackets, deprecatedSampleModelInputs,
		deprecatedSampleInputs, deprecatedTest, gaseousSampleInputs, gaseousSampleTest, mainCellIdentityModels, sampleCellTypes,
		validCellTypeQs, invalidCellTypeSamples, invalidCellTypeCellTypes, invalidCellTypeTest, inputContainerContents,
		stowawaySamples, uniqueStowawaySamples, invalidPlateSampleInputs, invalidPlateSampleContainers, invalidPlateSampleTest,
		talliedSamples, duplicateSamples, duplicateSamplesTest, missingVolumeInvalidCases, missingVolumeTest,
		(* Option precision check *)
		roundedIncubateCellsOptions, precisionTests,
		(* MapThread propagation *)
		mapThreadFriendlyOptionsNotPropagated, indexMatchingOptionNames, nonAutomaticOptionsPerContainer,
		mergedNonAutomaticOptionsPerContainer, mapThreadFriendlyOptions,
		(* General Options and Labels *)
		preparationResult, allowedPreparation, preparationTest, resolvedPreparation, roboticPrimitiveQ, performSimulationQ,
		workCellResult, allowedWorkCell, workCellTest, resolvedWorkCell, resolvedSampleLabels, resolvedSampleContainerLabels,
		allDoublingTimes, resolvedIncubationStrategy, resolvedTime, resolvedQuantificationInterval, specifiedQuantificationInstrument,
		resolvedQuantificationMethod, semiResolvedQuantificationInstrument, maxNumberOfQuantifications, resolvedQuantificationBlankMeasurementBool,
		preResolvedQuantificationAliquotBool, resolvedRecoupSampleBool, email,
		(* Conflicting Check I *)
		conflictingWorkCellAndPreparationQ, conflictingWorkCellAndPreparationOptions, conflictingWorkCellAndPreparationTest,
		coveredContainerQs, uncoveredSamples, uncoveredContainers, uncoveredSampleInputs, uncoveredContainerTest,
		(* MapThread IncubationCondition options and errors *)
		incubationConditionOptions, optionsToPullOut, cellTypes, cultureAdhesions, temperatures, carbonDioxidePercentages,
		relativeHumidities, shaking, shakingRates, semiResolvedShakingRadii, samplesOutStorageCondition, incubationCondition,
		cellTypesFromSample, cultureAdhesionsFromSample, minQuantificationTargets, quantificationTolerances, quantificationAliquotContainers,
		quantificationAliquotVolumes, quantificationBlanks, quantificationWavelengths, quantificationStandardCurves,
		conflictingShakingConditionsErrors, conflictingCellTypeErrors, conflictingCellTypeWarnings,
		conflictingCultureAdhesionErrors, invalidIncubationConditionErrors, conflictingCellTypeAdhesionErrors,
		unsupportedCellCultureTypeErrors, conflictingCellTypeWithIncubatorWarnings, conflictingCultureAdhesionWithContainerErrors,
		conflictingCellTypeWithStorageConditionErrors, conflictingCultureAdhesionWithStorageConditionWarnings,
		cellTypeNotSpecifiedWarnings, cultureAdhesionNotSpecifiedWarnings, customIncubationConditionNotSpecifiedWarnings,
		minTargetNoneWarningBools, unspecifiedMapThreadOptions, conflictingCellTypeWithStorageConditionWarnings,
		conflictingCellTypeWithIncubationConditionWarnings, conflictingIncubatorIncubationConditionErrors,
		incubationConditionCellTypes,
		(* Incubators and other Post-MapThread Resolutions *)
		resolvedFailureResponse, discardUponFailureWarningBool, sampleContainerModels, conflictFreeShaking, conflictFreeShakingRates,
		conflictFreeSemiResolvedShakingRadii, specifiedIncubationSettings, specifiedIncubators, allUniqueSpecifiedIncubators,
		incubationConditionOptionsForNoIncubatorErrors, specifiedIncubationSettingsForNoIncubatorErrors,
		possibleIncubators, possibleIncubatorPackets, rawIncubators, defaultIncubatorForNull, incubators, noResolvedIncubatorBools,
		resolvedShakingRadiiPreRounding, resolvedShakingRadii, conflictFreeShakingRadii,
		(* v2 quantification-related error pre-resolving checking *)
		conflictingQuantificationMethodAndInstrumentError, conflictingQuantificationMethodAndInstrumentOptions,
		conflictingQuantificationMethodAndInstrumentOptionsTest, conflictingQuantificationOptionsCases, conflictingQuantificationOptions,
		conflictingQuantificationOptionsTest, conflictingQuantificationAliquotOptionsCases, conflictingQuantificationAliquotOptions,
		conflictingQuantificationAliquotOptionsTest, unsuitableQuantificationIntervalCases, unsuitableQuantificationIntervalOptions,
		unsuitableQuantificationIntervalTest, quantificationTargetUnitsMismatchCases, quantificationTargetUnitsMismatchOptions,
		quantificationTargetUnitsMismatchTest, extraneousQuantifyColoniesOptions, extraneousQuantifyColoniesOptionsCases,
		extraneousQuantifyColoniesOptionsTest, failureResponseNotSupportedCases, failureResponseNotSupportedOptions,
		failureResponseNotSupportedTest, aliquotRecoupMismatchQ, aliquotRecoupMismatchedOptions, aliquotRecoupMismatchTest,
		errorChecksBeforeQuantification,
		(* v2 quantification-options resolver *)
		quantificationProtocolPacket, quantificationSimulation, resolvedQuantificationOptions, finalQuantificationInstrument,
		finalAliquotBools, resolvedAliquotBool, finalAliquotVolumes, finalAliquotContainers, finalStandardCurves, finalWavelengths,
		finalBlanks, simulationWithQuantification, mixedAliquotingQ,
		(* v2 quantification-related error post-resolving checking *)
		mixedQuantificationAliquotRequirementsOptions, mixedQuantificationAliquotRequirementsOptionsTests, quantificationAliquotRequiredQ,
		quantificationAliquotRequiredTest, quantificationAliquotRecommendedQ, quantificationAliquotRecommendedTest,
		conflictingIncubationStrategyCases, conflictingIncubationStrategyTest, noQuantificationTargetCases, conflictingIncubationStrategyOptions,
		excessiveQuantificationAliquotVolumeRequiredCases, excessiveQuantificationAliquotVolumeRequiredOptions,
		excessiveQuantificationAliquotVolumeRequiredTest,
		(* Combine *)
		resolvedOptions, resolvedMapThreadOptions,
		(* Conflicting Check II *)
		containersToSamples, incubatorsToContainers, incubatorFootprints, incubatorsOverCapacityAmounts, incubatorOverCapacityIncubators,
		incubatorOverCapacityCapacities, incubatorsOverCapacityFootprints, incubatorsOverCapacityQuantities, tooManySamples,
		tooManySamplesTest, groupedSamplesContainersAndOptions, inconsistentOptionsPerContainer, samplesWithSameContainerConflictingOptions,
		containersWithSameContainerConflictingOptions, conflictingIncubationConditionsForSameContainerOptions,
		conflictingIncubationConditionsForSameContainerTests, temperatureAboveMaxTemperatureQs, incubationMaxTemperatureOptions,
		temperatureAboveMaxTemperatureContainers, incubationMaxTemperatureTests, resolvedUnspecifiedOptions, customIncubationWarningSamples,
		customIncubationWarningUnspecifiedOptionNames, customIncubationWarningResolvedOptions, customIncubationNotSpecifiedTest,
		invalidShakingConditionsOptions, invalidShakingConditionsTests, conflictingCellTypeErrorOptions, conflictingCellTypeTests,
		cellTypeNotSpecifiedTests, conflictingCultureAdhesionOptions, conflictingCultureAdhesionCases, conflictingCultureAdhesionTests,
		cultureAdhesionNotSpecifiedTests, conflictingCellTypeAdhesionOptions, conflictingCellTypeAdhesionTests,
		conflictingCultureAdhesionWithContainerOptions, conflictingCultureAdhesionWithContainerTests, invalidIncubationConditionOptions,
		invalidIncubationConditionTest, unsupportedCellCultureTypeCases, unsupportedCellCultureTypeOptions, unsupportedCellCultureTypeTests,
		conflictingCellTypeWithStorageConditionWarningTests, conflictingCellTypeWithStorageConditionOptions, conflictingCellTypeWithStorageConditionTests,
		recommendedSCForSuspension, conflictingCultureAdhesionWithStorageConditionTests,
		(* Various modes of no compatible incubators *)
		noCompatibleIncubatorErrors, possibleIncubatorContainers, possibleIncubatorsNoSettings, possibleIncubatorNoSettingPackets,
		possibleIncubatorContainersNoSettings, possibleIncubatorContainersNoSettingPackets, whyCantIPickThisIncubator,
		whyCantIPickThisIncubationCondition, suggestSettingChangesForIncubators, containerCompatibleWithIncubatorsQs,
		additionalIncubatorCompatibilityInvalidInputs, noCompatibleIncubatorsInfoAssocs, groupedNoCompatibleIncubatorAssocs,
		invalidCellIncubationContainersAssocs, invalidCellIncubationContainersInvalidInputs, invalidCellIncubationContainersTests,
		noIncubatorForSettingsAssocs, noIncubatorForSettingsInvalidOptions, noIncubatorForSettingsTests,
		noIncubatorForContainersAndSettingsAssocs, noIncubatorForContainersAndSettingsTests,
		noIncubatorForContainersAndSettingsInvalidOptions, noCompatibleIncubatorTests,
		(* IncubationCondition is incompatible *)
		specifiedIncubationConditions, uniqueSpecifiedIncubationConditions, incubationConditionModelToSymbol, incubationConditionAllowedFootprints,
		incubationConditionIsIncompatibleErrors, incubationConditionIsIncompatibleAssocs, groupedIncubationConditionIsIncompatibleAssocs,
		incubationConditionIsIncompatibleUseAlternativesAssocs, incubationConditionIsIncompatibleUseAlternativesInvalidOptions, specifiedConflictingCellTypeQs,
		incubationConditionIsIncompatibleUseAlternativesTests, conflictingIncubationConditionWithSettingsAssocs,
		conflictingIncubationConditionWithSettingsInvalidOptions, conflictingIncubationConditionWithSettingsTests,
		conflictingIncubatorIncubationConditionInvalidOptions, conflictingIncubatorIncubationConditionTests,
		(* Various modes of specified incubator is incompatible *)
		groupedIncubatorIsIncompatibleAllAssocs, incubatorIsIncompatibleAllAssocs, incubatorIsIncompatibleAssocs,
		incubatorIsIncompatibleInvalidOptions, incubatorIsIncompatibleTests,
		conflictingIncubatorWithSettingsAssocs, conflictingIncubatorWithSettingsInvalidOptions, conflictingIncubatorWithSettingsTests,
		uniqueCustomIncubators, invalidCustomIncubatorsTests, invalidCustomIncubatorsOptions,
		conflictingCellTypeWithIncubatorTests, conflictingCellTypeWithIncubationConditionTests,
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
		Null|$Failed -> <||>, {1}
	];

	(* Get the height of the containers and the footprint (will be needed later) *)
	{sampleContainerHeights, sampleContainerFootprints} = Transpose[Map[
		If[MatchQ[#, PacketP[Model[Container]]],
			(* If the container model packet is actually a packet, not $Failed because our invalid sample may not have a container, do the lookups *)
			{
				(* Dimensions must be populated here; otherwise this will throw an error, but that is probably ok because if we have no Dimensions we are hosed no matter what *)
				Lookup[#, Dimensions][[3]],
				Lookup[#, Footprint]
			},
			{Null, Null} (*Otherwise do not trainwreck error here*)
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
	incubationConditionSymbols = {MammalianIncubation, BacterialIncubation, BacterialShakingIncubation, YeastIncubation, YeastShakingIncubation};
	allowedStorageConditionSymbols = Cases[Lookup[incubationConditionOptionDefinition, "SingletonPattern"], SampleStorageTypeP | Custom, Infinity];

	(* Custom incubators objects and models. If ProvidedStorageCondition is Null, then they must be custom incubators *)
	(* don't love this hard coding *)
	customIncubatorPackets = Cases[incubatorPackets, KeyValuePattern[ProvidedStorageCondition -> Null]];
	customIncubators = Lookup[customIncubatorPackets, Object, {}];

	(* Build a lookup from incubator model to the incubation condition symbol it provides *)
	incubationConditionIncubatorLookup = Append[
		(* All default incubators can be looked up in fast assoc. Merge so that the association creates a list of compatible incubators for each incubation condition symbol *)
		Merge[
			Map[
				Function[defaultIncubator,
					(* incubation condition symbol -> incubator model *)
					Association[fastAssocLookup[fastAssoc, defaultIncubator, {ProvidedStorageCondition, StorageCondition}] -> defaultIncubator]
				],
				DeleteCases[Lookup[incubatorPackets, Object, {}], ObjectP[customIncubators]]
			],
			Identity
		],
		(* All custom incubators provide custom incubation condition *)
		Custom -> customIncubators
	];
	(* Reverse the lookup. This works now based on that each incubator corresponds to one incubation condition. *)
	incubatorIncubationConditionLookup = Association@Flatten[KeyValueMap[
		Function[{incubationCondition, incubatorList},
			(# -> incubationCondition) & /@ incubatorList
		],
		incubationConditionIncubatorLookup
	]];

	(* Local helper to convert any specified incubation condition object to symbol *)
	incubationConditionModelToSymbol[incubationCondition: Alternatives[Custom, Sequence@@incubationConditionSymbols, ObjectP[Model[StorageCondition]]]] := If[MatchQ[incubationCondition, ObjectP[Model[StorageCondition]]],
		(* Specified a model, fetch its packet *)
		fastAssocLookup[fastAssoc, incubationCondition, StorageCondition],
		(* Specified a symbol *)
		incubationCondition
	];

	(*-- INPUT VALIDATION CHECKS --*)
	(* 1.) Get the samples from mySamples that are discarded. *)
	discardedSamplePackets = Cases[samplePackets, KeyValuePattern[Status -> Discarded]];
	discardedInvalidInputs = Lookup[discardedSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Module[{reasonClause, actionClause},
			reasonClause = StringJoin[
				Capitalize@samplesForMessages[discardedInvalidInputs, mySamples, Cache -> cacheBall, Simulation -> simulation],
				" ",
				hasOrHave[discardedInvalidInputs],
				" a Status of Discarded and cannot be used for this experiment."
			];
			actionClause = StringJoin[
				"Please provide ",
				If[Length[discardedInvalidInputs] > 1,
					"alternative non-discarded samples to use.",
					"an alternative non-discarded sample to use."
				]
			];

			Message[Error::DiscardedSample,
				reasonClause,
				actionClause
			]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall, Simulation -> simulation] <> " are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, discardedInvalidInputs], Cache -> cacheBall, Simulation -> simulation] <> " are not discarded:", True, True]
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

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
	If[Length[deprecatedSampleModelInputs] > 0 && messages,
		Module[{uniqueDeprecatedModels, reasonClause, actionClause},
			uniqueDeprecatedModels = DeleteDuplicates[deprecatedSampleModelInputs];
			reasonClause = StringJoin[
				Capitalize@samplesForMessages[deprecatedSampleInputs, mySamples, Cache -> cacheBall, Simulation -> simulation],
				" ",
				hasOrHave[deprecatedSampleInputs],
				If[Length[deprecatedSampleInputs] > 1,
					" deprecated models,",
					" a deprecated model,"
				],
				" and cannot be used for this experiment."
			];
			actionClause = StringJoin[
				"Please check the Deprecated field of ",
				If[Length[deprecatedSampleModelInputs] > 1,
					"the sample models and use alternative samples with non-deprecated models.",
					"the sample model and use an alternative sample with a non-deprecated model."
				]
			];

			Message[Error::DeprecatedModel,
				reasonClause,
				actionClause
			]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedSampleInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[deprecatedSampleInputs, Cache -> cacheBall, Simulation -> simulation] <> " have models that are not Deprecated:", True, False]
			];

			passingTest = If[Length[deprecatedSampleInputs] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, deprecatedSampleInputs], Cache -> cacheBall, Simulation -> simulation] <> " have models that are not Deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* 3.) Check that the user didn't give us any gaseous samples. *)
	gaseousSampleInputs = MapThread[
		If[MatchQ[Lookup[#1, State], Gas],
			#2,
			Nothing
		]&,
		{samplePackets, mySamples, Range[Length@mySamples]}
	];

	If[Length[gaseousSampleInputs] > 0 && messages,
		Module[{reasonClause, actionClause},
			reasonClause = StringJoin[
				Capitalize@samplesForMessages[gaseousSampleInputs, mySamples, Cache -> cacheBall, Simulation -> simulation],
				" ",
				hasOrHave[gaseousSampleInputs],
				" a State of Gas and cannot be used for this experiment."
			];
			actionClause = StringJoin[
				"Please provide ",
				If[Length[gaseousSampleInputs] > 1,
					"alternative liquid or solid samples to use.",
					"an alternative liquid or solid sample to use."
				]
			];
			Message[
				Error::GaseousSamples,
				reasonClause,
				actionClause
			]
		]
	];

	gaseousSampleTest = If[Length[gaseousSampleInputs] == 0,
		Test["None of the source samples that are specified to be incubated have State->Gas:", True, True],
		Test["None of the source samples that are specified to be incubated have State->Gas:", False, True]
	];


	(* 4.) Get whether the input cell types are supported *)

	(* first get the main cell object in the composition; if this is a mixture it will pick the one with the highest concentration *)
	mainCellIdentityModels = selectMainCellFromSample[mySamples, Cache -> cacheBall, Simulation -> simulation];

	(* Determine what kind of cells the input samples are *)
	sampleCellTypes = lookUpCellTypes[samplePackets, sampleModelPackets, mainCellIdentityModels, Cache -> cacheBall];

	(* Note here that Null is acceptable because we're going to assume it's Bacterial later *)
	validCellTypeQs = MatchQ[#, Mammalian|Yeast|Bacterial|Null]& /@ sampleCellTypes;
	invalidCellTypeSamples = Lookup[PickList[samplePackets, validCellTypeQs, False], Object, {}];
	invalidCellTypeCellTypes = PickList[sampleCellTypes, validCellTypeQs, False];

	If[Length[invalidCellTypeSamples] > 0 && messages,
		Message[
			Error::UnsupportedCellTypes,
			(*1*)"ExperimentIncubateCells only supports mammalian, bacterial and yeast cell cultures",
			(*2*)StringJoin[
				Capitalize@samplesForMessages[invalidCellTypeSamples, mySamples, Cache -> cacheBall, Simulation -> simulation],(* Potentially collapse to the sample or all samples instead of ID here *)
				" ",
				hasOrHave[invalidCellTypeSamples],
				" CellType detected as ",
				joinClauses@invalidCellTypeCellTypes,
			" from the CellType field of the ",
			pluralize[invalidCellTypeSamples, "object", "objects"]
			]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidCellTypeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidCellTypeSamples] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[invalidCellTypeSamples, Cache -> cacheBall, Simulation -> simulation] <> " are of supported cell types (Bacterial, Mammalian, or Yeast):", True, False]
			];

			passingTest = If[Length[invalidCellTypeSamples] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, invalidCellTypeSamples], Cache -> cacheBall, Simulation -> simulation] <> " are of supported cell types (Bacterial, Mammalian, or Yeast):", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* 5.) Get whether there are stowaway samples inside the input plates.  We're forbidding users from incubating samples when there are other samples in the plate already *)
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
	uniqueStowawaySamples = DeleteDuplicates@DeleteCases[stowawaySamples, {}];
	invalidPlateSampleInputs = Lookup[
		PickList[samplePackets, stowawaySamples, Except[{}]],
		Object,
		{}
	];
	invalidPlateSampleContainers = If[!MatchQ[invalidPlateSampleInputs, {}],
		DeleteDuplicates@MapThread[
			If[MemberQ[invalidPlateSampleInputs, ObjectP[#1]],
				Lookup[#2, Object],
				Nothing
			]&,
			{mySamples, sampleContainerPackets}
		],
		{}
	];

	(* Following new format of error message and detects singular/plural and flatten all values *)
	If[Length[invalidPlateSampleInputs] > 0 && messages,
		Module[{reasonClause},
			(* Here we try to not have a super long message by not displaying either sample or container IDs *)
			reasonClause = StringJoin[
				Capitalize@samplesForMessages[invalidPlateSampleInputs, mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
				" ",
				pluralize[invalidPlateSampleInputs, "reside"],
				Which[
					Length[invalidPlateSampleContainers] == 1, " in container ",
					Length[invalidPlateSampleContainers] > $MaxNumberOfErrorDetails, " in containers",
					True, " in containers "
				],
				If[Length[invalidPlateSampleContainers] > $MaxNumberOfErrorDetails,
					"",(* if too many containers (currently >3), do not display their ids *)
					samplesForMessages[invalidPlateSampleContainers, CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation](* we have to display all the containers ID since invalid inputs do not display container id*)
				],
				Which[
					Length[invalidPlateSampleContainers] == 1 && Length[Flatten@uniqueStowawaySamples] == 1,
						StringJoin[
							" with 1 additional sample ",
							ObjectToString[Flatten[uniqueStowawaySamples][[1]], Cache -> cacheBall, Simulation -> simulation],
							", which is not specified as input sample"
						],
					Length[invalidPlateSampleContainers] == 1,
						StringJoin[
							" with ",
							ToString[Length[Flatten@uniqueStowawaySamples]],
							" additional samples, which are not specified as input samples"
						],
					Length[invalidPlateSampleContainers] > $MaxNumberOfErrorDetails,
						" with additional samples, which are not specified as input samples",
					True,
						StringJoin[
							" with each container holding ",
							joinClauses[Map[Length[#]&, uniqueStowawaySamples], DuplicatesRemoval -> False],
							" additional samples, respectively"
						]
				]
			];
			Message[
				Error::InvalidPlateSamples,
				reasonClause,
				If[Length[invalidPlateSampleInputs] == 1,
					"the input sample into an empty container",
					"the input samples into empty containers"
				],
				If[Length[invalidPlateSampleContainers] == 1 && Length[Flatten@uniqueStowawaySamples] == 1,
					"the additional sample as input sample as well",
					"all of the additional samples as input samples as well"
				]
			]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidPlateSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidPlateSampleInputs] == 0,
				Nothing,
				Test["The input samples " <> ObjectToString[invalidPlateSampleInputs, Cache -> cacheBall, Simulation -> simulation] <> " are in containers that do not have additional samples other than input samples in them:", True, False]
			];

			passingTest = If[Length[invalidPlateSampleInputs] == Length[mySamples],
				Nothing,
				Test["The input samples " <> ObjectToString[Complement[mySamples, invalidPlateSampleInputs], Cache -> cacheBall, Simulation -> simulation] <> " are in containers that do not have additional samples other than input samples in them:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* 6.) Throw an error if we have duplicate samples provided *)
	talliedSamples = Tally[mySamples];
	duplicateSamples = Cases[talliedSamples, {sample_, tally:GreaterEqualP[2]} :> sample];

	If[Length[duplicateSamples] > 0 && messages,
		Message[Error::DuplicatedSamples, samplesForMessages[duplicateSamples, CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation], "ExperimentIncubateCells"]
	];

	duplicateSamplesTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[duplicateSamples] == 0,
				Nothing,
				Test["The input samples " <> ObjectToString[duplicateSamples, Cache -> cacheBall, Simulation -> simulation] <> " have not been specified more than once:", True, False]
			];

			passingTest = If[Length[duplicateSamples] == Length[mySamples],
				Nothing,
				Test["The input samples " <> ObjectToString[Complement[mySamples, duplicateSamples], Cache -> cacheBall, Simulation -> simulation] <> " have not been specified more than once:", True, True]
			];

			{failingTest, passingTest}
		]
	];


	(* 6.) Throw a warning is we have liquid samples without volume (or low volume) or solid samples without mass (or low mass) *)
	(* Note:for gaseous samples, no need to throw more error *)
	missingVolumeInvalidCases = MapThread[
		Function[{samplePacket, sampleContainerPacket},
			Module[{maxVol, lowLiquidVol, lowSolidMass},
				maxVol = Lookup[sampleContainerPacket, MaxVolume];
				(* 100 Microliter and 100 Milligram are defined in individualStorageItems in ProcedureFramework for determine empty samples *)
				lowLiquidVol = If[MatchQ[maxVol, VolumeP],
					SafeRound[Min[maxVol, Max[0.01*maxVol, 100 Microliter]], 1 Microliter],
					100 Microliter
				];
				lowSolidMass = If[MatchQ[maxVol, VolumeP],
					SafeRound[Min[0.997*maxVol Gram/Milliliter, Max[(0.01*0.997*maxVol Gram/Milliliter), 100 Milligram]], 1 Milligram],
					100 Milligram
				];
				Which[
					MatchQ[Lookup[samplePacket, {State, Volume}], {Liquid, LessP[lowLiquidVol]}],
						{Lookup[samplePacket, Object], Liquid, Low},
					MatchQ[Lookup[samplePacket, {State, Mass}], {Solid, LessP[lowSolidMass]}],
						{Lookup[samplePacket, Object], Solid, Low},
					MatchQ[Lookup[samplePacket, {State, Volume}], {Liquid, Null}],
						{Lookup[samplePacket, Object], Liquid, Null},
					MatchQ[Lookup[samplePacket, {State, Mass}], {Solid, Null}],
						{Lookup[samplePacket, Object], Solid, Null},
					True,
						Nothing
				]
			]
		],
		{samplePackets, sampleContainerModelPackets}
	];

	If[Length[missingVolumeInvalidCases] > 0 && messages,
		Module[{groupedErrorDetails, reasonClause, actionClause},
			groupedErrorDetails = GroupBy[missingVolumeInvalidCases, Rest];
			reasonClause = If[Length[Keys[groupedErrorDetails]] > $MaxNumberOfErrorDetails,
				StringJoin[
					Capitalize@samplesForMessages[missingVolumeInvalidCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
					" either have missing or low amount"
				],
				joinClauses[
					Map[
						StringJoin[
							samplesForMessages[groupedErrorDetails[#][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
							" ",
							hasOrHave[groupedErrorDetails[#]],
							If[MatchQ[groupedErrorDetails[#][[All, 3]], {Low..}],
								" low amount recorded in the field ",
								" missing "
							],
							If[MatchQ[groupedErrorDetails[#][[All, 2]], {Solid..}],
								"Mass",
								"Volume"
							],
							If[MatchQ[groupedErrorDetails[#][[All, 3]], {Null..}],
								" information",
								""
							]
						]&,
						Keys[groupedErrorDetails]
					],
					CaseAdjustment -> True
				]
			];
			actionClause = If[Or[
				TrueQ[$IncubateCellsIncubateOnly],
				!MatchQ[resolvedFailureResponse, Freeze],
				MatchQ[resolvedFailureResponse, Freeze] && MemberQ[missingVolumeInvalidCases, Except[{ObjectP[], Liquid, Null}]]
			],
				If[Length[missingVolumeInvalidCases] > 1,
					"ExperimentIncubateCells will still incubate these samples, however, there is not enough media to guarantee proper cell growth.",
					"ExperimentIncubateCells will still incubate this sample, however, there is not enough media to guarantee proper cell growth."
				],
				"The MaxVolume of the source containers will be used when determining the cryogenic vials to store the sample(s)."
			];
			Message[Warning::EmptySamples,
				reasonClause,
				actionClause
			]
		]
	];

	missingVolumeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[missingVolumeInvalidCases] == 0,
				Nothing,
				Warning["The input samples " <> ObjectToString[missingVolumeInvalidCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation] <> " have valid volume or mass information:", True, False]
			];

			passingTest = If[Length[missingVolumeInvalidCases] == Length[mySamples],
				Nothing,
				Warning["The input samples " <> ObjectToString[Complement[mySamples, missingVolumeInvalidCases[[All, 1]]], Cache -> cacheBall, Simulation -> simulation] <> " have valid volume or mass information:", True, True]
			];

			{failingTest, passingTest}
		]
	];


	(*-- OPTION PRECISION CHECKS --*)

	{roundedIncubateCellsOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[
			(* dropping these two keys because they are often huge and make variables unnecessarily take up memory + become unreadable *)
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


	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(*---  Resolve the Preparation to determine liquidhandling scale, then do this for WorkCell too  ---*)
	preparationResult = Check[
		{allowedPreparation, preparationTest} = If[gatherTests,
			resolveIncubateCellsMethod[mySamples, ReplaceRule[myOptions, {Cache -> cacheBall, Simulation -> simulation, Output -> {Result, Tests}}]],
			{
				resolveIncubateCellsMethod[mySamples, ReplaceRule[myOptions, {Cache -> cacheBall, Simulation -> simulation, Output -> Result}]],
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
				resolveIncubateCellsWorkCell[mySamples, ReplaceRule[Normal[roundedIncubateCellsOptions, Association], {Cache -> cacheBall, Simulation -> simulation, Output -> {Result, Tests}}]],
			True,
				{
					resolveIncubateCellsWorkCell[mySamples, ReplaceRule[Normal[roundedIncubateCellsOptions, Association], {Cache -> cacheBall, Simulation -> simulation, Output -> Result}]],
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

	(* Get the resolved Email option; for this experiment, the default is True *)
	email = Which[
		MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[parentProtocol], True,
		MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[parentProtocol, ObjectP[ProtocolTypes[]]], False,
		True, Lookup[myOptions, Email]
	];

	(*-- CONFLICTING OPTIONS CHECKS I --*)
	(* 1.) If Preparation -> Robotic, WorkCell can't be Null. If Preparation -> Manual, WorkCell can't be specified *)
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
		Test["If Preparation -> Robotic, WorkCell must not be Null. If Preparation -> Manual, WorkCell must not be specified:",
			conflictingWorkCellAndPreparationQ,
			False
		]
	];

	(* 2.) Get whether the input samples are in covered containers *)
	coveredContainerQs = Not[NullQ[#]]& /@ Lookup[sampleContainerPackets, Cover, {}];
	uncoveredSamples = PickList[samplePackets, coveredContainerQs, False];
	uncoveredContainers = DeleteDuplicates@PickList[sampleContainerPackets, coveredContainerQs, False];

	(* If we're doing robotic this is always {} *)
	uncoveredSampleInputs = If[MatchQ[resolvedPreparation, Robotic],
		{},
		Lookup[uncoveredSamples, Object, {}]
	];

	If[Length[uncoveredSampleInputs] > 0 && messages,
		Message[
			Warning::UnsealedCellCultureVessels,
			(*1*)Capitalize@samplesForMessages[uncoveredSampleInputs, mySamples, Cache -> cacheBall, Simulation -> simulation],(* Potentially collapse to the sample or all samples instead of ID here *)
			(*2*)Which[
				Length[uncoveredSampleInputs] == 1 && Length[uncoveredContainers] == 1, "resides in container ",
				Length[uncoveredContainers] == 1, "reside in container ",
				True, "reside in containers "
			],
			(*3*)samplesForMessages[uncoveredContainers, CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],(* we have to display all the containers ID since invalid inputs do not display container id*)
			(*4*)If[Length[uncoveredContainers] > 1,
				"These cell culture vessels",
				"This cell culture vessel"
			]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	uncoveredContainerTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[uncoveredSampleInputs] == 0,
				Nothing,
				Warning["Our input samples " <> ObjectToString[uncoveredSampleInputs, Cache -> cacheBall, Simulation -> simulation] <> " are in covered containers if Preparation -> Manual:", True, False]
			];

			passingTest = If[Length[uncoveredSampleInputs] == Length[mySamples],
				Nothing,
				Warning["Our input samples " <> ObjectToString[Complement[mySamples, uncoveredSampleInputs], Cache -> cacheBall, Simulation -> simulation] <> " are in covered containers if Preparation -> Manual:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(*-- RESOLVE MAPTHREAD EXPERIMENT OPTIONS --*)

	(* Options that Custom needs specified *)
	(* want this outside of the MapThread because want to use it below *)
	(* Evaluate for each sample if there is any incubation condition option specified *)
	incubationConditionOptions = {
		Temperature,
		CarbonDioxide,
		RelativeHumidity,
		Shake,
		ShakingRadius,
		ShakingRate
	};
	optionsToPullOut = Join[
		{
		CellType,
		CultureAdhesion,
		Incubator
		},
		incubationConditionOptions
	];

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
		(* Errors and warnings*)
		(*20*)conflictingShakingConditionsErrors,
		(*21a*)conflictingCellTypeErrors,
		(*21b*)conflictingCellTypeWarnings,
		(*22*)conflictingCultureAdhesionErrors,
		(*23*)invalidIncubationConditionErrors,
		(*24*)conflictingCellTypeAdhesionErrors,
		(*25*)unsupportedCellCultureTypeErrors,
		(*26*)conflictingCellTypeWithIncubatorWarnings,
		(*27*)conflictingCultureAdhesionWithContainerErrors,
		(*28*)conflictingCellTypeWithStorageConditionErrors,
		(*29*)conflictingCultureAdhesionWithStorageConditionWarnings,
		(*30*)cellTypeNotSpecifiedWarnings,
		(*31*)cultureAdhesionNotSpecifiedWarnings,
		(*32*)customIncubationConditionNotSpecifiedWarnings,
		(*33*)minTargetNoneWarningBools,
		(*34*)unspecifiedMapThreadOptions,
		(*35*)conflictingCellTypeWithStorageConditionWarnings,
		(*36*)conflictingCellTypeWithIncubationConditionWarnings,
		(*37*)incubationConditionCellTypes,
		(*38*)conflictingIncubatorIncubationConditionErrors
	} = Transpose[MapThread[
		Function[{mySample, options, mainCellIdentityModel},
			Module[
				{
					samplePacket, modelPacket, containerModelPacket, containerPacket, mainCellIdentityModelPacket, sampleState,
					specifiedCellType, specifiedCultureAdhesion, specifiedIncubationCondition, specifiedIncubator, specifiedTemperature,
					specifiedCarbonDioxide, specifiedRelativeHumidity, specifiedShake, specifiedShakingRadius, specifiedShakingRate,
					specifiedSamplesOutStorageCondition, specifiedMinQuantificationTarget, specifiedQuantificationTolerance,
					specifiedQuantificationAliquotContainer, specifiedQuantificationAliquotVolume, specifiedQuantificationBlank,
					specifiedQuantificationWavelength, specifiedQuantificationStandardCurve, customOptionsToPullOut, unspecifiedOptions,
					customIncubationConditionNotSpecifiedWarning, specifiedIncubatorModelPacket, cellTypeFromSample, resolvedCellType,
					conflictingCellTypeError, conflictingCellTypeWarning, cellTypeNotSpecifiedWarning, cultureAdhesionFromSample,
					resolvedCultureAdhesion, conflictingCultureAdhesionError, cultureAdhesionNotSpecifiedWarning, conflictingCellTypeAdhesionError,
					conflictingCultureAdhesionWithContainerError, incubationConditionPattern, incubationConditionFromOptions,
					resolvedIncubationCondition, resolvedIncubationConditionPacket, incubationConditionCellType,
					conflictingCellTypeWithIncubationConditionWarning, invalidIncubationConditionError,
					conflictingIncubatorIncubationConditionError, resolvedTemperature, resolvedRelativeHumidity, resolvedCarbonDioxidePercentage,
					resolvedShaking, resolvedShakingRate, semiResolvedShakingRadius, semiResolvedShakingRadiusBadFloat,
					conflictingShakingConditionsError, samplesOutStorageConditionPattern, samplesOutStorageConditionPacketForCustom,
					resolvedSamplesOutStorageCondition, inheritedSamplesOutStorageConditionQ, unsupportedCellCultureTypeError,
					incubatorCellTypes, conflictingCellTypeWithIncubatorWarning, resolvedSamplesOutStorageConditionSymbol,
					resolvedSamplesOutStorageConditionObject, conflictingCellTypeWithStorageConditionWarning,
					conflictingCellTypeWithStorageConditionError, conflictingCultureAdhesionWithStorageConditionWarning,
					resolvedMinQuantificationTarget, minTargetNoneWarningBool, resolvedQuantificationTolerance,
					semiResolvedQuantificationAliquotContainer, semiResolvedQuantificationAliquotVolume,
					semiResolvedQuantificationBlank, semiResolvedQuantificationWavelength, semiResolvedQuantificationStandardCurve
				},

				(* Lookup information about our sample and container packets *)
				samplePacket = fetchPacketFromFastAssoc[mySample, fastAssoc];
				modelPacket = fastAssocPacketLookup[fastAssoc, mySample, Model];
				containerPacket = fastAssocPacketLookup[fastAssoc, mySample, Container];
				containerModelPacket = fastAssocPacketLookup[fastAssoc, mySample, {Container, Model}];
				mainCellIdentityModelPacket = fetchPacketFromFastAssoc[mainCellIdentityModel, fastAssoc];
				sampleState = Lookup[samplePacket, State, Null];

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
				(* Note: Shake is not True, do not need ShakingRadius or ShakingRate *)
				customOptionsToPullOut = If[MatchQ[specifiedShake, False],
					DeleteCases[optionsToPullOut, CellType|CultureAdhesion|Shake|ShakingRadius|ShakingRate],
					DeleteCases[optionsToPullOut, CellType|CultureAdhesion]
				];
				unspecifiedOptions = PickList[
					customOptionsToPullOut,
					Lookup[options, customOptionsToPullOut],
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
				resolvedCellType = Which[
					(* if CellType was specified, use it *)
					MatchQ[specifiedCellType, CellTypeP], specifiedCellType,
					(* if CellType was not specified but we could figure it out from the sample, go with that *)
					(* Note: for Plant | Insect | Fungal inherit from Object, do not use them. UnsupportedCellTypes error has been thrown *)
					MatchQ[cellTypeFromSample, Mammalian|Bacterial|Yeast], cellTypeFromSample,
					(* if CellType was not specified and we couldn't figure it out from the sample, default to Bacterial *)
					True, Bacterial
				];
				(* if CellType was specified but it conflicts with the fields in the Sample, go with what was specified but flip error/warning switch *)
				conflictingCellTypeError = If[And[
					MatchQ[specifiedCellType, CellTypeP],
					MatchQ[cellTypeFromSample, Mammalian|Bacterial|Yeast],
					Or[
						MatchQ[specifiedCellType, Mammalian] && MatchQ[cellTypeFromSample, MicrobialCellTypeP],
						MatchQ[cellTypeFromSample, Mammalian] && MatchQ[specifiedCellType, MicrobialCellTypeP]
					]
				],
					True,
					False
				];
				conflictingCellTypeWarning = If[And[
					MatchQ[specifiedCellType, CellTypeP],
					MatchQ[cellTypeFromSample, Mammalian|Bacterial|Yeast],
					Or[
						MatchQ[specifiedCellType, Yeast] && MatchQ[cellTypeFromSample, Bacterial],
						MatchQ[cellTypeFromSample, Yeast] && MatchQ[specifiedCellType, Bacterial]
					]
				],
					True,
					False
				];
				(* if CellType was not specified and we couldn't figure it out from the sample, default to Bacterial and flip warning switch *)
				cellTypeNotSpecifiedWarning = If[And[
					!MatchQ[sampleState, Gas],
					!MatchQ[specifiedCellType, CellTypeP],
					!MatchQ[cellTypeFromSample, CellTypeP]
				],
					True,
					False
				];

				(* Get the CultureAdhesion that we can discern from the sample *)
				cultureAdhesionFromSample = Which[
					(* if the sample has a CultureAdhesion, use that *)
					MatchQ[Lookup[samplePacket, CultureAdhesion], CultureAdhesionP], Lookup[samplePacket, CultureAdhesion],
					(* if sample doesn't have it but its model does, use that *)
					Not[NullQ[modelPacket]] && MatchQ[Lookup[modelPacket, CultureAdhesion], CultureAdhesionP], Lookup[modelPacket, CultureAdhesion],
					(* otherwise, we have no idea and pick Null *)
					True, Null
				];

				(* Resolve the CultureAdhesion option *)
				resolvedCultureAdhesion = Which[
					MatchQ[specifiedCultureAdhesion, CultureAdhesionP],
						(* if CultureAdhesion was specified, use it *)
						specifiedCultureAdhesion,
					MatchQ[cultureAdhesionFromSample, CultureAdhesionP],
						(* if CultureAdhesion was not specified but we could figure it out from the sample, go with that *)
						cultureAdhesionFromSample,
					True,
						(* if CultureAdhesion was not specified and we couldn't figure it out from the sample, resolve based on state and cell type *)
						(* Note:if state of sample is gas, we do not throw warning *)
						Which[
							MatchQ[resolvedCellType, Bacterial|Yeast] && MatchQ[sampleState, Solid],
								SolidMedia,
							MatchQ[resolvedCellType, Bacterial|Yeast],
								Suspension,
							True,
								Adherent
						]
				];
				(* if CultureAdhesion was specified but it conflicts with the fields in the Sample, go with what was specified but flip error switch *)
				conflictingCultureAdhesionError = If[And[
					MatchQ[specifiedCultureAdhesion, CultureAdhesionP],
					Or[
						MatchQ[cultureAdhesionFromSample, CultureAdhesionP] && !MatchQ[specifiedCultureAdhesion, cultureAdhesionFromSample],
						MatchQ[sampleState, Solid] && MatchQ[specifiedCultureAdhesion, Suspension|Adherent],
						MatchQ[sampleState, Liquid] && MatchQ[specifiedCultureAdhesion, SolidMedia]
					]
				],
					True,
					False
				];
				(* if CultureAdhesion was not specified and we couldn't figure it out from the sample, flip warning switch *)
				cultureAdhesionNotSpecifiedWarning = If[And[
					!MatchQ[sampleState, Gas],
					!MatchQ[specifiedCultureAdhesion, CultureAdhesionP],
					!MatchQ[cultureAdhesionFromSample, CultureAdhesionP]
				],
					True,
					False
				];

				(* Flip error switch if we're doing Mammalian samples with SolidMedia, or if we're doing Yeast/Bacterial with Adherent *)
				conflictingCellTypeAdhesionError = Or[
					MatchQ[resolvedCellType, Mammalian] && MatchQ[specifiedCultureAdhesion, SolidMedia],
					MatchQ[resolvedCellType, Bacterial|Yeast] && MatchQ[specifiedCultureAdhesion, Adherent]
				];

				(* Flip error switch if the container type doesn't work with the culture adhesion *)
				(* solid media or adherent must be in a plate *)
				(* Don't throw this error to recommend transfer if the sample is already discarded, and thats why it's not in a plate *)
				conflictingCultureAdhesionWithContainerError = And[
					MatchQ[resolvedCultureAdhesion, SolidMedia|Adherent],
					Not[MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]]],
					Not[MatchQ[mySample, ObjectP[discardedInvalidInputs]]]
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
					If[RPMQ[specifiedShakingRate] && MatchQ[Lookup[containerModelPacket/. $Failed -> <||>, Footprint, Null], plateIncubatorFootprintsP],
						PlateShakingRate -> EqualP[specifiedShakingRate],
						Nothing
					],
					If[RPMQ[specifiedShakingRate] && !MatchQ[Lookup[containerModelPacket/. $Failed -> <||>, Footprint, Null], plateIncubatorFootprintsP],
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
					True, incubationConditionModelToSymbol[incubationConditionFromOptions]
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
				(* Lookup the cell type associated with the incubation condition *)
				incubationConditionCellType = If[MatchQ[resolvedIncubationConditionPacket, ObjectP[Model[StorageCondition]]],
					Lookup[resolvedIncubationConditionPacket, CellType],
					Null
				];
				(* Soft warning when the specified incubation condition CellTypes does not match the resolved CellType option, but both are microbial. *)
				conflictingCellTypeWithIncubationConditionWarning = Which[
					(* If the incubation condition is not a cell incubation one, we throw the invalid error *)
					MatchQ[Lookup[resolvedIncubationConditionPacket CellType], Null],
						False,
					(*If the user did not specify an incubation condition directly. (i.e. we resolved it based on Incubator, there will be an incubator warning) )*)
					MatchQ[specifiedIncubationCondition, Automatic],
						False,
					(* if CellType is bacterial and the IncubationCondition is for yeast, throw warning *)
					(* Need to exclude the case where cell type we pulled from sample is not a currently supported one and we default to Bacterial. This should be changed whenever we change validCellTypeQs evaluation in future. *)
					And[
						MatchQ[resolvedCellType, Bacterial],
						MatchQ[cellTypeFromSample, Mammalian|Yeast|Bacterial|Null],
						MatchQ[incubationConditionCellType, Yeast]
					],
						True,
					(* if CellType is yeast and the IncubationCondition is for bacterial, throw warning *)
					And[
						MatchQ[resolvedCellType, Yeast],
						MatchQ[incubationConditionCellType, Bacterial]
					],
						True,
					True,
						False
				];

				(* Flip error switch for if IncubationCondition is specified and is not an actual IncubationCondition *)
				(* This needs to happen before specific incubation setting resolvers so that we can decide to disregard the invalid incubation condition and go down the Which call *)
				invalidIncubationConditionError = Or[
					MatchQ[specifiedIncubationCondition, ObjectP[Model[StorageCondition]]] && Not[MemberQ[allowedStorageConditionSymbols, fastAssocLookup[fastAssoc, specifiedIncubationCondition, StorageCondition]]],
					MatchQ[specifiedIncubationCondition, SampleStorageTypeP] && Not[MemberQ[allowedStorageConditionSymbols, specifiedIncubationCondition]]
				];

				(* Check if both incubator and incubation condition are specified and they are in conflict *)
				conflictingIncubatorIncubationConditionError = Which[
					And[
						(* Incubation condition is specified as a symbol*)
						MemberQ[Append[incubationConditionSymbols, Custom], specifiedIncubationCondition],
						(* Incubator is also specified *)
						MatchQ[specifiedIncubator, ObjectP[]]
					],
						(* Then we compares the symbols to tell if the condition provided by the incubator matches the specified incubation condition *)
						!MemberQ[
							Lookup[incubationConditionIncubatorLookup, specifiedIncubationCondition],
							Lookup[specifiedIncubatorModelPacket, Object]
						],
					And[
						(* Incubation condition is specified as a symbol*)
						MatchQ[specifiedIncubationCondition, ObjectP[Model[StorageCondition]]],
						(* The specified incubation condition is a valid cell incubation one. *)
						!invalidIncubationConditionError,
						(* Incubator is also specified *)
						MatchQ[specifiedIncubator, ObjectP[]]
					],
						(* Then we compares the object to tell if the condition provided by the incubator matches the specified incubation condition *)
						!MemberQ[
							Lookup[incubationConditionIncubatorLookup, fastAssocLookup[fastAssoc, specifiedIncubationCondition, StorageCondition]],
							Lookup[specifiedIncubatorModelPacket, Object]
						],
					(* Otherwise they are not in conflict *)
					True,
						False
				];

				(* Resolve the Temperature option *)
				resolvedTemperature = Which[
					(* If the user directly provided a Temperature, use that*)
					TemperatureQ[specifiedTemperature], specifiedTemperature,
					(* if IncubationCondition is not custom and it was not a specified invalid one, take the temperature from that *)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						!invalidIncubationConditionError
					],
						SafeRound[Lookup[resolvedIncubationConditionPacket, Temperature], 1 Celsius],
					(* if an incubator was specified and it has a DefaultTemperature, go with that; I don't expect this to usually be populated for custom incubators but we can have this here in case *)
					Not[NullQ[specifiedIncubatorModelPacket]] && TemperatureQ[Lookup[specifiedIncubatorModelPacket, DefaultTemperature]],
						SafeRound[Lookup[specifiedIncubatorModelPacket, DefaultTemperature], 1 Celsius],
					(* otherwise, default to 37 Celsius for Mammalian and Bacterial cells, and 30 Celsius for Yeast *)
					MatchQ[resolvedCellType, Yeast], 30 Celsius,
					True, 37 Celsius
				];

				(* Resolve the RelativeHumidity option *)
				resolvedRelativeHumidity = Which[
					(* If the user directly provided a RelativeHumidity, use that *)
					PercentQ[specifiedRelativeHumidity],
						specifiedRelativeHumidity,
					(* if IncubationCondition is not custom and it was not a specified invalid one, take the humidity from that *)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						!invalidIncubationConditionError
					],
						SafeRound[Lookup[resolvedIncubationConditionPacket, Humidity], 1 Percent],
					(* if an incubator was specified and it has a DefaultRelativeHumidity, go with that; I don't expect this to usually be populated for custom incubators but we can have this here in case *)
					Not[NullQ[specifiedIncubatorModelPacket]] && PercentQ[Lookup[specifiedIncubatorModelPacket, DefaultRelativeHumidity]],
						SafeRound[Lookup[specifiedIncubatorModelPacket, DefaultRelativeHumidity], 1 Percent],
					(* otherwise, default to 93 Celsius for Mammalian, and Null otherwise *)
					MatchQ[resolvedCellType, Mammalian],
						93 Percent,
					True,
						Null
				];

				(* Resolve the CarbonDioxide option *)
				resolvedCarbonDioxidePercentage = Which[
					(* If the user directly provided a CarbonDioxide value, use that *)
					PercentQ[specifiedCarbonDioxide],
						specifiedCarbonDioxide,
					(* if IncubationCondition is not custom and it was not a specified invalid one, take the CarbonDioxide from that *)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						!invalidIncubationConditionError
					],
						SafeRound[Lookup[resolvedIncubationConditionPacket, CarbonDioxide], 1 Percent],
					(* if an incubator was specified and it has a DefaultCarbonDioxide, go with that; I don't expect this to usually be populated for custom incubators but we can have this here in case *)
					Not[NullQ[specifiedIncubatorModelPacket]] && PercentQ[Lookup[specifiedIncubatorModelPacket, DefaultCarbonDioxide]],
						SafeRound[Lookup[specifiedIncubatorModelPacket, DefaultCarbonDioxide], 1 Percent],
					(* otherwise, default to 5 Percent for Mammalian, and Null otherwise *)
					MatchQ[resolvedCellType, Mammalian],
						5 Percent,
					True,
						Null
				];

				(* Resolve the Shake option *)
				resolvedShaking = Which[
					(* If the user directly provided Shaking as True, use that*)
					BooleanQ[specifiedShake], specifiedShake,
					(*If Shaking is Automatic and either ShakingRate or ShakingRadius is specified, set Shake to True*)
					RPMQ[specifiedShakingRate] || DistanceQ[specifiedShakingRadius], True,
					NullQ[specifiedShakingRate] || NullQ[specifiedShakingRadius], False,
					(* if IncubationCondition is not custom, it was not a specified invalid one, and ShakingRadius is populated, then True *)
					(* note that I don't need to check ShakingRadius _and_ ShakingRate because both are populated together *)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						Not[NullQ[Lookup[resolvedIncubationConditionPacket, ShakingRadius]]],
						!invalidIncubationConditionError
					], True,
					(* if an incubator was specified and it has a DefaultShakingRate, Shake is True; we need this logic here so that all shaking options have a similar tiered logic in the Which call, so that we are less like resolve to conflicting shaking conditions *)
					Not[NullQ[specifiedIncubatorModelPacket]] && RPMQ[Lookup[specifiedIncubatorModelPacket, DefaultShakingRate]],
						True,
					(* if none of the shaking options are specified and we're in a custom incubation, then suspensions cells should shake and others should not. *)
					(* Note that it is possible to have Suspension but we respect user input of shaking option set to Null. *)
					MatchQ[resolvedCultureAdhesion, Suspension] && MatchQ[resolvedIncubationConditionPacket, Custom], True,
					True, False
				];

				(* Resolve the ShakingRate option *)
				resolvedShakingRate = Which[
					(* If the user directly provided a ShakingRate, use that, even if it is Null *)
					MatchQ[specifiedShakingRate, Except[Automatic]], specifiedShakingRate,
					(* If shaking radius is specified, default to 200 RPM so we don't end up with empty possible incubators due to the same conflict already checked by ConflictingShakingConditions*)
					MatchQ[specifiedShakingRadius, Except[Automatic|Null]],
						200 RPM,
					(* if Shake is resolved to False, then Null *)
					Not[resolvedShaking],
						Null,
					(* if IncubationCondition is not custom, it was not a specified invalid one, and ShakingRate is populated, then use the Plate/VesselShakingRate *)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						!invalidIncubationConditionError,
						MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]],
						Not[NullQ[Lookup[resolvedIncubationConditionPacket, PlateShakingRate]]],
						TrueQ[resolvedShaking]
					],
						SafeRound[Lookup[resolvedIncubationConditionPacket, PlateShakingRate], 1 RPM],
					(* Similarly for plates, do not resolve to conflicting shaking options based on incubation condition *)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						!invalidIncubationConditionError,
						MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]],
						NullQ[Lookup[resolvedIncubationConditionPacket, PlateShakingRate]],
						!TrueQ[resolvedShaking]
					],
						Null,
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						!invalidIncubationConditionError,
						MatchQ[containerModelPacket, PacketP[Model[Container, Vessel]]],
						Not[NullQ[Lookup[resolvedIncubationConditionPacket, VesselShakingRate]]],
						TrueQ[resolvedShaking]
					],
						SafeRound[Lookup[resolvedIncubationConditionPacket, VesselShakingRate], 1 RPM],
					(* Similarly for vessels, do not resolve to conflicting shaking options based on incubation condition *)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						!invalidIncubationConditionError,
						MatchQ[containerModelPacket, PacketP[Model[Container, Vessel]]],
						NullQ[Lookup[resolvedIncubationConditionPacket, VesselShakingRate]],
						!TrueQ[resolvedShaking]
					],
						Null,
					(* if an incubator was specified and it has a DefaultShakingRate, go with that; I don't expect this to usually be populated for custom incubators but we can have this here in case *)
					Not[NullQ[specifiedIncubatorModelPacket]] && RPMQ[Lookup[specifiedIncubatorModelPacket, DefaultShakingRate]],
						SafeRound[Lookup[specifiedIncubatorModelPacket, DefaultShakingRate], 1 RPM],
					(* if we have nothing else to go on, then do 200 RPM *)
					True,
						200 RPM
				];

				(* Resolve the ShakingRadius option *)
				semiResolvedShakingRadiusBadFloat = Which[
					(* If the user directly provided a ShakingRadius, use that, even if it is Null*)
					MatchQ[specifiedShakingRadius, Except[Automatic]],
						specifiedShakingRadius,
					(* If shaking rate is specified, don't null it just yet so we don't end up with empty possible incubators due to the same conflict already checked by ConflictingShakingConditions*)
					MatchQ[specifiedShakingRate, Except[Automatic|Null]] || TrueQ[resolvedShaking],
						Automatic,
					(* if Shake is resolved to False, then Null *)
					Not[resolvedShaking],
						Null,
					(* if IncubationCondition is not custom, it was not a specified invalid one, and ShakingRadius is populated, then use the ShakingRadius *)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						!invalidIncubationConditionError,
						Not[NullQ[Lookup[resolvedIncubationConditionPacket, ShakingRadius]]],
						TrueQ[resolvedShaking]
					],
						Lookup[resolvedIncubationConditionPacket, ShakingRadius],
					(*  Do not resolve to conflicting shaking options based on incubation condition*)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						!invalidIncubationConditionError,
						NullQ[Lookup[resolvedIncubationConditionPacket, ShakingRadius]],
						!TrueQ[resolvedShaking]
					],
						Null,
					(* if an Incubator was specified and it has ShakingRadius, go with that *)
					Not[NullQ[specifiedIncubatorModelPacket]] && DistanceQ[Lookup[specifiedIncubatorModelPacket, ShakingRadius]],
						Lookup[specifiedIncubatorModelPacket, ShakingRadius],
					(* otherwise this is staying Automatic and we're going to figure it out when we have an incubator *)
					True,
						Automatic
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

					Which[
						(* If the resolved culture adhesion is suspension, we do not resolve to no shake, and later throw a warning complaining about it (Warning::ShakingRecommendedForStorageCondition) *)
						(* This will need to be revisited if recommendedSCForSuspension logic changes *)
						MatchQ[resolvedCultureAdhesion, Suspension] && MatchQ[resolvedCellType, Yeast|Bacterial],
							ShakingRadius -> Except[Null],
						(* Mammalian cells are not being shaked, otherwise we won't find any storage condition for mammalian cells *)
						MatchQ[resolvedCellType, Mammalian],
							ShakingRadius -> Null,
						(* checking all three of these options because of the case where a user specifies conflicting shaking options (i.e., Shake -> False, ShakingRate -> 200 RPM) *)
						(* if the user does that, we're already going to throw an error, but if we don't check all three,
						we're potentially going to go down a path that will cause us to throw even more messages, which customers will (rightly) find annoying and unhelpful*)
						resolvedShaking || DistanceQ[semiResolvedShakingRadius] || RPMQ[resolvedShakingRate],
							ShakingRadius -> Except[Null],
						True,
							ShakingRadius -> Null
					]
				}];

				(* Given all the specified options, pick an incubation condition that would fit *)
				samplesOutStorageConditionPacketForCustom = FirstCase[storageConditionPackets, samplesOutStorageConditionPattern];

				(* Resolve the SamplesOutStorageCondition option *)
				(* Use inheritedSamplesOutStorageConditionQ to keep track if we resolved this SamplesOutStorageCondition solely based on the resolved IncubationCondition. If so, we do not further throw errors about conflicts with SamplesOutStorageCondition with CellType and CultureAdhesion *)
				{resolvedSamplesOutStorageCondition, inheritedSamplesOutStorageConditionQ} = Which[
					(* if samples out storage condition is specified, use it *)
					Not[MatchQ[specifiedSamplesOutStorageCondition, Automatic]],
						{specifiedSamplesOutStorageCondition, False},
					(* if IncubationCondition is not custom, then get the incubation condition *)
					(* note that we somehow have a non-cell-culture incubation condition here, don't resolve to that because things are already borked and we don't want to throw unnecessary options together with the necessary ones  *)
					MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]] && Not[NullQ[Lookup[resolvedIncubationConditionPacket, CellType]]],
						{Lookup[resolvedIncubationConditionPacket, StorageCondition], True},
					(* if IncubationCondition is custom, then pick a storage condition based only on CellType and CultureAdhesion (and just pick something based on CellType otherwise) *)
					MatchQ[resolvedIncubationCondition,Custom] && MatchQ[samplesOutStorageConditionPacketForCustom, PacketP[Model[StorageCondition]]],
						{Lookup[samplesOutStorageConditionPacketForCustom, StorageCondition], False},
					(* if we somehow can't find anything, just go to fridge to avoid throwing too many errors, especially not for values we resolved to *)
					True,
						{Refrigerator, False}
				];

				(* Flip error switch if doing Mammalian and Suspension (not currently supported) *)
				unsupportedCellCultureTypeError = MatchQ[resolvedCellType, Mammalian] && MatchQ[resolvedCultureAdhesion, Suspension];

				(* Get the cell types compatible with the specified incubator *)
				incubatorCellTypes = If[NullQ[specifiedIncubatorModelPacket],
					Null,
					Lookup[specifiedIncubatorModelPacket, CellTypes]
				];
				(* Soft warning when the specified incubator CellTypes does not match the resolved CellType option, but both are microbial. *)
				(* Need to exclude the case where cell type we pulled from sample is not a currently supported one and we default to Bacterial. This should be changed whenever we change validCellTypeQs evaluation in future. *)
				conflictingCellTypeWithIncubatorWarning = And[
					Not[NullQ[incubatorCellTypes]],
					Not[MemberQ[incubatorCellTypes, resolvedCellType]],
					MatchQ[incubatorCellTypes, {MicrobialCellTypeP..}],
					MatchQ[resolvedCellType, MicrobialCellTypeP],
					MatchQ[cellTypeFromSample, Mammalian|Yeast|Bacterial|Null]
				];

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

				(* Soft warning when the specified storage condition CellTypes does not match the resolved CellType option, but both are microbial. *)
				conflictingCellTypeWithStorageConditionWarning = Which[
					(* Disposal and Refrigerator always ok *)
					(* Always skip if we resolved SamplesOutStorageCondition based on IncubationCondition *)
					Or[
						MatchQ[resolvedSamplesOutStorageConditionSymbol, Disposal|Refrigerator|Ambient],
						TrueQ[inheritedSamplesOutStorageConditionQ]
					],
						False,
					(* if CellType is bacterial and the SamplesOutStorageCondition is for yeast, throw warning *)
					(* Need to exclude the case where cell type we pulled from sample is not a currently supported one and we default to Bacterial. This should be changed whenever we change validCellTypeQs evaluation in future. *)
					And[
						MatchQ[resolvedCellType, Bacterial],
						MatchQ[cellTypeFromSample, Mammalian|Yeast|Bacterial|Null],
						MatchQ[resolvedSamplesOutStorageConditionSymbol, YeastIncubation|YeastShakingIncubation]
					],
						True,
					(* if CellType is yeast and the SamplesOutStorageCondition is for bacterial, throw warning *)
					And[
						MatchQ[resolvedCellType, Yeast],
						MatchQ[resolvedSamplesOutStorageConditionSymbol, BacterialIncubation|BacterialShakingIncubation]
					],
						True,
					True,
						False
				];

				(* Flip error switch for if the SamplesOutStorageCondition doesn't agree with what the cells are *)
				conflictingCellTypeWithStorageConditionError = Which[
					(* Disposal and Refrigerator always ok *)
					(* Always skip if we resolved SamplesOutStorageCondition based on IncubationCondition *)
					Or[
						MatchQ[resolvedSamplesOutStorageConditionSymbol, Except[IncubatedCellSampleStorageTypeP]],
						TrueQ[inheritedSamplesOutStorageConditionQ],
						conflictingCellTypeWithStorageConditionWarning
					], False,
					(* if CellType is Mammalian, then we need MammalianIncubation *)
					MatchQ[resolvedCellType, Mammalian], Not[MatchQ[resolvedSamplesOutStorageConditionSymbol, MammalianIncubation]],
					(* if CellType is Bacterial|Yeast, then we need SamplesOutStorageCondition to be default microbial incubation conditions *)
					MatchQ[resolvedCellType, MicrobialCellTypeP], Not[MatchQ[resolvedSamplesOutStorageConditionSymbol, BacterialIncubation|BacterialShakingIncubation|YeastIncubation|YeastShakingIncubation]],
					(* fallback; shouldn't get here *)
					True, False
				];

				(* Flip warning switch for if we are trying to store suspension samples in an incubator without shaking. But do not error if the storage condition is just a continuance of the incubation condition. *)
				conflictingCultureAdhesionWithStorageConditionWarning = If[Or[
					MatchQ[resolvedSamplesOutStorageConditionSymbol, Except[IncubatedCellSampleStorageTypeP]],
					NullQ[resolvedSamplesOutStorageConditionObject],
					TrueQ[inheritedSamplesOutStorageConditionQ],
					TrueQ[conflictingCellTypeWithStorageConditionError]
				],
					(* Disposal|Refrigerator|Ambient is always ok. Always skip if we resolved SamplesOutStorageCondition based on IncubationCondition *)
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
					(* Errors and warnings*)
					(*20*)conflictingShakingConditionsError,
					(*21a*)conflictingCellTypeError,
					(*21b*)conflictingCellTypeWarning,
					(*22*)conflictingCultureAdhesionError,
					(*23*)invalidIncubationConditionError,
					(*24*)conflictingCellTypeAdhesionError,
					(*25*)unsupportedCellCultureTypeError,
					(*26*)conflictingCellTypeWithIncubatorWarning,
					(*27*)conflictingCultureAdhesionWithContainerError,
					(*28*)conflictingCellTypeWithStorageConditionError,
					(*29*)conflictingCultureAdhesionWithStorageConditionWarning,
					(*30*)cellTypeNotSpecifiedWarning,
					(*31*)cultureAdhesionNotSpecifiedWarning,
					(*32*)customIncubationConditionNotSpecifiedWarning,
					(*33*)minTargetNoneWarningBool,
					(*34*)unspecifiedOptions,
					(*35*)conflictingCellTypeWithStorageConditionWarning,
					(*36*)conflictingCellTypeWithIncubationConditionWarning,
					(*37*)incubationConditionCellType,
					(*38*)conflictingIncubatorIncubationConditionError
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

	(* Process the shaking options for use in IncubateCellsDevices calls so that we don't get no incubators just because the user specified conflicting shaking conditions. We would have already errored out for that. *)
	(* If there is no conflict detected, use as they are resolved *)
	(* If there is conflict, generally we use the Shake->True and non-Null rate and radius to resolve incubators *)
	(* For Shake masterswitch, if it is specified  *)
	{conflictFreeShaking, conflictFreeShakingRates, conflictFreeSemiResolvedShakingRadii} = Transpose@MapThread[
		Function[{conflictQ, cellType, shake, shakingRate, shakingRadius},
			Which[
				TrueQ[conflictQ] && MatchQ[cellType, Mammalian],
					(* There is conflict and the resolved cell type is Mammalian, there must be at least 1 option suggest shaking is False. Use Shake -> False and Null values *)
					{False, shakingRate, shakingRadius} /. (_Quantity) -> Automatic,
				TrueQ[conflictQ],
					(* There is conflict and the resolved cell type is not Mammalian, there must be at least 1 option suggest shaking is true. Use Shake -> True and non-Null values *)
					{True, shakingRate, shakingRadius} /. Null -> Automatic,
				True,
					(* No conflict, use resolved value *)
					{shake, shakingRate, shakingRadius}
			]
		],
		{conflictingShakingConditionsErrors, cellTypes, shaking, shakingRates, semiResolvedShakingRadii}
	];
	(* Pull incubation setting options out for incubator-related error checking. NoCompatibleIncubatorXX needs to consider the specified preparation, but other application does not. *)
	incubationConditionOptionsForNoIncubatorErrors = Append[incubationConditionOptions, Preparation];
	(* Evaluate for each sample if there is any incubation condition option specified *)
	specifiedIncubationSettingsForNoIncubatorErrors = Map[
		Function[unresolvedOptions,
			Normal[KeyTake[
				unresolvedOptions,
				PickList[
					incubationConditionOptionsForNoIncubatorErrors,
					Lookup[unresolvedOptions, incubationConditionOptionsForNoIncubatorErrors],
					Except[Automatic]
				]
			],Association]
		],
		mapThreadFriendlyOptions
	];
	(* For other applications, do no consider specified Preparation. Especially IncubatorIsIncompatibleError, as it is already checked in the method resolver *)
	specifiedIncubationSettings = Normal[KeyDrop[#, Preparation], Association] & /@ specifiedIncubationSettingsForNoIncubatorErrors;

	specifiedIncubators = Lookup[mapThreadFriendlyOptions, Incubator];

	(* Get a duplicate-free list of specified incubator objects/models *)
	allUniqueSpecifiedIncubators = DeleteDuplicates@Cases[specifiedIncubators, ObjectP[]];
	(* Call IncubateCellsDevices to find all compatible incubators. If a list other than {} is returned, check the mode and return one valid instrument model*)
	(* We need to treat the options differently based on if we have the Incubator specified, because it is possible that we resolved to empty possible incubator because some options we resolved based on the specified incubator. We need this info when generating reccomendations for IncubatorIsIncompatible *)
	possibleIncubators = Module[{sanitizedIncubationSettings, mapThreadFriendlySanitizedIncubationSettings},
		(* Basically if an incubator is specified for a sample, we only use the incubation setting option value if it is user-specified, otherwise we use resolved value *)
		sanitizedIncubationSettings = MapThread[
			Function[{specifiedIncubator, unresolvedOptions, conflictingShakingConditionsError,
				temperature, carbonDioxidePercentage, relativeHumidity, conflictFreeShake, conflictFreeShakingRate,
				conflictFreeSemiResolvedShakingRadius},
				Which[
					MatchQ[specifiedIncubator, ObjectP[]] && TrueQ[conflictingShakingConditionsError],
						(* Incubator is specified and there is conflict in shaking options, use user specified setting only, do not use our resolved value, and use the conflict free shaking options *)
						Association@ReplaceRule[
							{
								Temperature -> temperature,
								CarbonDioxide -> carbonDioxidePercentage,
								RelativeHumidity -> relativeHumidity,
								Shake -> conflictFreeShake,
								ShakingRate -> conflictFreeShakingRate,
								ShakingRadius -> conflictFreeSemiResolvedShakingRadius
							},
							Normal[KeyDrop[unresolvedOptions, {Shake, ShakingRadius, ShakingRate}], Association],
							Append -> False
						],
					(* Incubator is specified is there is no conflict in shaking options, just swap with specified values *)
					MatchQ[specifiedIncubator, ObjectP[]],
						Association@ReplaceRule[
							{
								Temperature -> temperature,
								CarbonDioxide -> carbonDioxidePercentage,
								RelativeHumidity -> relativeHumidity,
								Shake -> conflictFreeShake,
								ShakingRate -> conflictFreeShakingRate,
								ShakingRadius -> conflictFreeSemiResolvedShakingRadius
							},
							Normal[unresolvedOptions, Association],
							Append -> False
						],
					True,
						(* Incubator is not specified, use resolved value *)
						<|
							Temperature -> temperature,
							CarbonDioxide -> carbonDioxidePercentage,
							RelativeHumidity -> relativeHumidity,
							Shake -> conflictFreeShake,
							ShakingRate -> conflictFreeShakingRate,
							ShakingRadius -> conflictFreeSemiResolvedShakingRadius
						|>
				]
			],
			{
				(* User specification info *)
				specifiedIncubators, mapThreadFriendlyOptions, conflictingShakingConditionsErrors,
				(* Resolved values *)
				temperatures, carbonDioxidePercentages, relativeHumidities, conflictFreeShaking, conflictFreeShakingRates,
				conflictFreeSemiResolvedShakingRadii
			}
		];
		mapThreadFriendlySanitizedIncubationSettings = Merge[sanitizedIncubationSettings, Identity];
		(* Call IncubateCellsDevices based on the sanitized settings *)
		IncubateCellsDevices[
			sampleContainerModels,
			CellType -> cellTypes,
			CultureAdhesion -> cultureAdhesions,
			Temperature -> Lookup[mapThreadFriendlySanitizedIncubationSettings, Temperature],
			CarbonDioxide -> Lookup[mapThreadFriendlySanitizedIncubationSettings, CarbonDioxide],
			RelativeHumidity -> Lookup[mapThreadFriendlySanitizedIncubationSettings, RelativeHumidity],
			Shake -> Lookup[mapThreadFriendlySanitizedIncubationSettings, Shake],
			ShakingRate -> Lookup[mapThreadFriendlySanitizedIncubationSettings, ShakingRate],
			ShakingRadius -> Lookup[mapThreadFriendlySanitizedIncubationSettings, ShakingRadius],
			Preparation -> resolvedPreparation,
			Cache -> cacheBall,
			Simulation -> simulation
		]
	];
	possibleIncubatorPackets = Map[
		fetchPacketFromFastAssoc[#, fastAssoc]&,
		possibleIncubators,
		{2}
	];

	(* Resolve the incubator based on the information we had above from IncubateCellsDevices and the MapThread *)
	rawIncubators = MapThread[
		Function[{potentialIncubatorPacketsPerSample, desiredIncubator, resolvedCondition, invalidIncubationConditionError},
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
				(* If we have a valid non-custom incubator. Do not use the custom ones *)
				!TrueQ[invalidIncubationConditionError],
					SelectFirst[
						Lookup[potentialIncubatorPacketsPerSample, Object],
						Not[MemberQ[customIncubators, #]]&,
						Null
					],
				(* Catch-all: If we can avoid picking a custom incubator here, let's do it *)
				True,
					SelectFirst[
						Lookup[potentialIncubatorPacketsPerSample, Object],
						Not[MemberQ[customIncubators, #]]&,
						(* if we can't find any non-custom incubators, just pick whatever we can find*)
						FirstOrDefault[Lookup[potentialIncubatorPacketsPerSample, Object]]
					]
			]
		],
		{possibleIncubatorPackets, Lookup[mapThreadFriendlyOptions, Incubator], incubationCondition, invalidIncubationConditionErrors}
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

	(* Finally resolve the ShakingRadius now that we know the incubator we're using. But do not pull from the dummy incubator that we just return when there's no compatible ones found.  *)
	resolvedShakingRadiiPreRounding = MapThread[
		Function[{incubator, resolvedShaking, shakingRadius},
			Which[
				(* Pull it from the resolved incubator *)
				MatchQ[shakingRadius, Automatic] && TrueQ[resolvedShaking],
					fastAssocLookup[fastAssoc, incubator, ShakingRadius],
				(* ResolvedShaking is False *)
				MatchQ[shakingRadius, Automatic],
					Null,
				True,
					shakingRadius
			]
		],
		{incubators, shaking, semiResolvedShakingRadii}
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

	(* Build a list of resolved shaking radii that is conflict free with other shaking options to input to IncubateCellsDevices *)
	conflictFreeShakingRadii = MapThread[
		Function[{conflictQ, cellType, shakingRadius},
			Which[
				TrueQ[conflictQ] && MatchQ[cellType, Mammalian],
				(* There is conflict and the resolved cell type is Mammalian, there must be at least 1 option suggest shaking is False. Use Shake -> False and Null values *)
					shakingRadius /. (_Quantity) -> Automatic,
				(* There is conflict and the resolved cell type is not Mammalian, there must be at least 1 option suggest shaking is true. Use Shake -> True and non-Null values *)
				TrueQ[conflictQ],
					shakingRadius /. Null -> Automatic,
				True,
				(* No conflict, use as is *)
					shakingRadius
			]
		],
		{conflictingShakingConditionsErrors, cellTypes, resolvedShakingRadii}
	];


	(*-- v2 quantification-related error checking --*)
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
				ObjectToString[resolvedQuantificationMethod, Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[semiResolvedQuantificationInstrument, Cache -> cacheBall, Simulation -> simulation]
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
				Test["The QuantificationInstrument and QuantificationMethod for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " are compatible with one another:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The QuantificationInstrument and QuantificationMethod for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " are compatible with one another:", True, True]
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
				ObjectToString[conflictingQuantificationOptionsCases[[All,1]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[conflictingQuantificationOptionsCases[[All,2]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[conflictingQuantificationOptionsCases[[All,3]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[conflictingQuantificationOptionsCases[[All,4]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[conflictingQuantificationOptionsCases[[All,5]], Cache -> cacheBall, Simulation -> simulation],
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
				Test["The FailureResponse, QuantificationTarget and QuantificationTolerance options for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " are compatible with one another:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The FailureResponse, QuantificationTarget and QuantificationTolerance options for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " are compatible with one another:", True, True]
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
				ObjectToString[conflictingQuantificationAliquotOptionsCases[[All,1]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[conflictingQuantificationAliquotOptionsCases[[All,2]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[conflictingQuantificationAliquotOptionsCases[[All,3]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[preResolvedQuantificationAliquotBool, Cache -> cacheBall, Simulation -> simulation],
				conflictingQuantificationAliquotOptionsCases[[All, 4]]
			];
			Append[conflictingQuantificationAliquotOptionsCases[[All, 2]], QuantificationAliquot]
		),
		{}
	];

	conflictingQuantificationAliquotOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingQuantificationAliquotOptionsCases[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The QuantificationAliquotVolume and QuantificationAliquotContainer options for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " are compatible with the QuantificationAliquot option:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The QuantificationAliquotVolume and QuantificationAliquotContainer options for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " are compatible with the QuantificationAliquot option:", True, True]
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
				ObjectToString[unsuitableQuantificationIntervalCases[[1]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[unsuitableQuantificationIntervalCases[[2]], Cache -> cacheBall, Simulation -> simulation]
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
				Test["The QuantificationInterval for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " is no shorter than 1 Hour and no longer than the Time:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The QuantificationInterval for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " is no shorter than 1 Hour and no longer than the Time:", True, True]
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
				ObjectToString[quantificationTargetUnitsMismatchCases[[All,1]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[quantificationTargetUnitsMismatchCases[[All,2]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[quantificationTargetUnitsMismatchCases[[All,3]], Cache -> cacheBall, Simulation -> simulation],
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
				Test["The QuantificationTolerance for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " must be given as a Percent or in the same units as the MinQuantificationTarget is the MinQuantificationTarget is a quantity:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The QuantificationTolerance for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " must be given as a Percent or in the same units as the MinQuantificationTarget is the MinQuantificationTarget is a quantity:", True, True]
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
				ObjectToString[extraneousQuantifyColoniesOptionsCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[extraneousQuantifyColoniesOptionsCases[[All, 2]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[extraneousQuantifyColoniesOptionsCases[[All, 3]], Cache -> cacheBall, Simulation -> simulation],
				extraneousQuantifyColoniesOptionsCases[[All, 4]]
			];
			DeleteDuplicates @ Flatten[{QuantificationMethod, extraneousQuantifyColoniesOptionsCases[[All, 2]]}]
		),
		{}
	];

	extraneousQuantifyColoniesOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = extraneousQuantifyColoniesOptionsCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["None of the options QuantificationAliquot, QuantificationAliquotContainer, QuantificationAliquotVolume, QuantificationBlankMeasurement, QuantificationBlank, QuantificationWavelength, or QuantificationStandardCurve are specified (or True) for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if the QuantificationMethod is ColonyCount:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["None of the options QuantificationAliquot, QuantificationAliquotContainer, QuantificationAliquotVolume, QuantificationBlankMeasurement, QuantificationBlank, QuantificationWavelength, or QuantificationStandardCurve are specified (or True) for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if the QuantificationMethod is ColonyCount:", True, True]
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

				(* Get the current volumes of all the input samples. If no Volume is populated, use the MaxVolume of source containers *)
				(* The warning has been thrown as MissingVolumeInformation *)
				inputSampleVolumes = MapThread[
					If[MatchQ[#1, VolumeP],
						#1,
						Lookup[#2, MaxVolume]
					]&,
					{Lookup[samplePackets, Volume], sampleContainerModelPackets}
				];

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
				"The FailureResponse is Freeze, and the samples " <> ObjectToString[nonSuspensionSamplesToFreeze, Cache -> cacheBall, Simulation -> simulation] <> " at indices " <> ToString[nonSuspensionIndices] <> " have CultureAdhesion set to " <> ObjectToString[nonSuspensionCultureAdhesions, Cache -> cacheBall, Simulation -> simulation] <> ". The Freeze FailureResponse is only compatible with Suspension samples.",
			(* We don't allow Freeze if the experiment demands more than 1 Mr Frosty Rack. *)
			!NullQ[replicatesRequired] && GreaterQ[replicatesRequired, frostyRackNumPositions],
				"The FailureResponse is Freeze and the largest input sample has a volume of " <> ToString[largestSampleVolume] <> ". In the event of failure, the input samples will be transferred into " <> ToString[replicatesRequired] <> " cryogenic vials of " <> ObjectToString[cryoVialModel, Cache -> cacheBall, Simulation -> simulation] <> " to accommodate the sample volume and added cryoprotectant volume. This would require the use of more than one insulated cooler rack of " <> ObjectToString[frostyRackModel, Cache -> cacheBall, Simulation -> simulation] <> ", which has " <> ToString[frostyRackNumPositions] <> " positions. Due to equipment constraints, the Freeze FailureResponse is only available for protocols which require no more than one full insulated cooler rack in the event of failure.",
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
				Test["The FailureResponse for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " is not Incubate if the IncubationCondition is Custom and is not Freeze if the samples are not Suspension samples, or if the Freeze response requires more than one insulated cooler rack:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The FailureResponse for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " is not Incubate if the IncubationCondition is Custom and is not Freeze if the samples are not Suspension samples, or if the Freeze response requires more than one insulated cooler rack:", True, True]
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

	(*-- v2 quantification-related error post-resolving checking --*)
	(* Throw an error if ExperimentQuantifyCells resolves the QuantificationAliquot option but gives a mix of True and False. *)
	(* The scenario which requires us to throw this error is pretty unlikely - e.g. the user has multiple samples and some but not all *)
	(* are compatible with the quantification instrument and the user doesn't set any aliquoting options explicitly. *)
	mixedQuantificationAliquotRequirementsOptions = If[MatchQ[mixedAliquotingQ, True] && messages,
		(
			Message[
				Error::MixedQuantificationAliquotRequirements,
				ObjectToString[mySamples, Cache -> cacheBall, Simulation -> simulation],
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
				Test["Some but not all of the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> " require aliquoting for quantification, but QuantificationAliquot is not explicitly set to True:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The QuantificationAliquot option resolved to either all True, all False, or all Null for the following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ":", True, True],
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
				Warning["QuantificationAliquot does not resolve to True from Automatic:", True, False]
			];

			passingTest = If[quantificationAliquotRequiredQ,
				Nothing,
				Warning["QuantificationAliquot does not resolve to True from Automatic:", True, True]
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
				Warning["QuantificationAliquot is not False while QuantificationMethod is Absorbance or Nephelometry:", True, False]
			];

			passingTest = If[quantificationAliquotRecommendedQ,
				Nothing,
				Warning["QuantificationAliquot is not False while QuantificationMethod is Absorbance or Nephelometry:", True, True]
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
				ObjectToString[conflictingIncubationStrategyCases[[All,1]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[conflictingIncubationStrategyCases[[All,2]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[conflictingIncubationStrategyCases[[All,3]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[conflictingIncubationStrategyCases[[All,4]], Cache -> cacheBall, Simulation -> simulation],
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
				Test["Quantification options are specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if and only if the IncubationStrategy is QuantificationTarget:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["Quantification options are specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if and only if the IncubationStrategy is QuantificationTarget:", True, True]
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
					!TrueQ[resolvedRecoupSampleBool]
				],
				{sample, aliquotVolume, resolvedQuantificationInterval, resolvedTime, (maxNumberOfQuantifications * aliquotVolume), sampleVolume, index},
				Nothing
			]
		],
		{
			mySamples,
			finalAliquotVolumes,
			MapThread[If[MatchQ[#1, VolumeP], #1, Lookup[#2, MaxVolume]]&, {Lookup[samplePackets, Volume], sampleContainerModelPackets}],
			Range[Length[mySamples]]
		}
	];

	excessiveQuantificationAliquotVolumeRequiredOptions = If[MatchQ[Length[excessiveQuantificationAliquotVolumeRequiredCases], GreaterP[0]] && messages,
		(
			Message[
				Error::ExcessiveQuantificationAliquotVolumeRequired,
				ObjectToString[excessiveQuantificationAliquotVolumeRequiredCases[[All,1]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[excessiveQuantificationAliquotVolumeRequiredCases[[All,2]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[excessiveQuantificationAliquotVolumeRequiredCases[[All,3]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[excessiveQuantificationAliquotVolumeRequiredCases[[All,4]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[excessiveQuantificationAliquotVolumeRequiredCases[[All,5]], Cache -> cacheBall, Simulation -> simulation],
				ObjectToString[excessiveQuantificationAliquotVolumeRequiredCases[[All,6]], Cache -> cacheBall, Simulation -> simulation],
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
				Test["The QuantificationAliquotVolume times the maximum number of quantifications for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " does not exceed the available sample volume while QuantificationRecoupSample is False:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The QuantificationAliquotVolume times the maximum number of quantifications for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " does not exceed the available sample volume while QuantificationRecoupSample is False:", True, True]
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
			ObjectToString[resolvedFailureResponse, Cache -> cacheBall, Simulation -> simulation],
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
			ObjectToString[noQuantificationTargetCases[[All,1]], Cache -> cacheBall, Simulation -> simulation],
			noQuantificationTargetCases[[All, 2]]
		];
	];


	(*-- Combine v1 and v2 resolved options --*)
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

	(*-- CONFLICTING OPTIONS CHECKS II --*)

	(* 1.)TooManyIncubationSamples *)
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
	(* here for each failure, we're going to have a list of length four, where the first value is the incubator, the second is the capacity number, the third is the footprint, and the fourth is the value we actually have *)
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
			joinClauses[
				MapThread[
					StringJoin[ObjectToString[#1, Cache -> cacheBall, Simulation -> simulation], " has enough space for ", ToString[#2], " containers with Footprint as ", ToString[#3], " but ", ToString[#4], " containers were specified instead"]&,
					{incubatorOverCapacityIncubators, incubatorOverCapacityCapacities, incubatorsOverCapacityFootprints, incubatorsOverCapacityQuantities}
				],
				CaseAdjustment -> True
			]
		]
	];

	tooManySamplesTest = If[gatherTests,
		Test["Too many samples are not provided for a given incubator:",
			incubatorOverCapacityIncubators,
			{}
		]

	];


	(* 2.)ConflictingIncubationConditionsForSameContainer *)
	(* Gather the samples that are in the same container together with their options *)
	groupedSamplesContainersAndOptions = GatherBy[
		Transpose[{
			mySamples,
			sampleContainerPackets,
			MapThread[
				Join[#1, {SpecifiedSamplesOutStorageCondition -> #2, SamplesOutStorageCondition -> #3, IncubationCondition -> #4}]&,
				{specifiedIncubationSettings, Lookup[mapThreadFriendlyOptions, SamplesOutStorageCondition], samplesOutStorageCondition, Lookup[mapThreadFriendlyOptions, IncubationCondition]}
			]
		}],
		#[[2]]&
	];

	(* Get the options that are not the same across the board for each container *)
	inconsistentOptionsPerContainer = Map[
		Function[{samplesContainersAndOptions},
			Map[
				Function[{optionToCheck},
					Which[
						(* Is all samples sharing the same container has the option set the same? *)
						SameQ @@ Lookup[samplesContainersAndOptions[[All, 3]], optionToCheck],
							Nothing,
						(* Are these samples grouped together because are discarded and do not have a container? i.e. Container -> Null *)
						MatchQ[samplesContainersAndOptions[[All, 2]], {<||>..}],
							Nothing,
						(* For SamplesOutStorageCondition, if not specified, the option is resolved with other specified optionsToPullOut or IncubationCondition so no need to throw again *)
						MatchQ[optionToCheck, SamplesOutStorageCondition] && SameQ @@ DeleteCases[Lookup[samplesContainersAndOptions[[All, 3]], SpecifiedSamplesOutStorageCondition], Automatic],
							Nothing,
						(* For IncubationCondition, if not specified, the option is resolved with other specified optionsToPullOut so no need to throw again *)
						MatchQ[optionToCheck, IncubationCondition],
							Module[{specifiedIncubationConditions, specifiedIncubationSymbols},
								specifiedIncubationConditions = DeleteCases[Lookup[samplesContainersAndOptions[[All, 3]], IncubationCondition], Automatic];
								(* Convert Model SC to SC symbol if applicable *)
								specifiedIncubationSymbols = Map[
									If[MatchQ[#, ObjectP[]],
										fastAssocLookup[fastAssoc, #, StorageCondition],
										#
									]&,
									specifiedIncubationConditions
								];
								If[SameQ @@ specifiedIncubationSymbols,
									Nothing,
									IncubationCondition
								]
							],
						True,
							optionToCheck
					]
				],
				Join[optionsToPullOut, {SamplesOutStorageCondition, IncubationCondition}]
			]
		],
		groupedSamplesContainersAndOptions
	];

	(* Get the samples that have conflicting options for the same container *)
	samplesWithSameContainerConflictingOptions = MapThread[
		Function[{samplesContainersAndOptions, inconsistentOptions},
			If[MatchQ[inconsistentOptions, {}],
				{},
				samplesContainersAndOptions[[All, 1]]
			]
		],
		{groupedSamplesContainersAndOptions, inconsistentOptionsPerContainer}
	];

	containersWithSameContainerConflictingOptions = Map[
		If[!MatchQ[#, {}],
			Download[fastAssocLookup[fastAssoc, First[#], Container], Object],
			Null
		]&,
		samplesWithSameContainerConflictingOptions
	];

	(* Throw an error if we have these same-container samples with different options specified/inherited *)
	conflictingIncubationConditionsForSameContainerOptions = If[MemberQ[inconsistentOptionsPerContainer, Except[{}]] && messages,
		Module[{captureSentence, reasonClause},
			captureSentence = Which[
				MatchQ[Flatten@inconsistentOptionsPerContainer, {SamplesOutStorageCondition..}],
					"At the end ExperimentIncubateCells, prepared plates are stored as a unit, keeping all samples in each plate together",
				MemberQ[Flatten@inconsistentOptionsPerContainer, SamplesOutStorageCondition],
					"During the experiment, ExperimentIncubateCells places prepared plates in a cell incubator and stores them at the end, maintaining all samples on each plate together",
				True,
					"ExperimentIncubateCells places prepared plates inside of a cell incubator, keeping all samples in each plate together"
			];
			reasonClause = If[Length[DeleteCases[inconsistentOptionsPerContainer, {}]] > $MaxNumberOfErrorDetails,
				StringJoin[
					Capitalize@samplesForMessages[Flatten@PickList[samplesWithSameContainerConflictingOptions, inconsistentOptionsPerContainer, Except[{}]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
					" have options ",
					joinClauses@Flatten[inconsistentOptionsPerContainer],
					" specified differently"
				],
				joinClauses@MapThread[
					If[!MatchQ[#3, {}],
						StringJoin[
							Capitalize@samplesForMessages[#1, mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
							" reside in the same container ",
							ObjectToString[#2, Cache -> cacheBall, Simulation -> simulation],
							Which[
								MemberQ[#3, SamplesOutStorageCondition] && Length[#3] > 1,
									" while incubation option(s) " <> joinClauses[DeleteCases[#3, SamplesOutStorageCondition]] <> " and SamplesOutStorageCondition are specified differently",
								MemberQ[#3, SamplesOutStorageCondition] && Length[#3] == 1,
									" while SamplesOutStorageCondition is specified differently",
								Length[#3] > 1,
									" while incubation options " <> joinClauses[#3] <> " are specified differently",
								True,
									" while incubation option " <> ToString[#3[[1]]] <> " is specified differently"
							]
						],
						Nothing
					]&,
					{samplesWithSameContainerConflictingOptions, containersWithSameContainerConflictingOptions, inconsistentOptionsPerContainer}
				]
			];
			Message[
				Error::ConflictingIncubationConditionsForSameContainer,
				captureSentence,
				reasonClause
			];
			DeleteDuplicates[Flatten[inconsistentOptionsPerContainer]]
		],
		{}
	];

	conflictingIncubationConditionsForSameContainerTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, inconsistentOptionsPerContainer, Except[{}]];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, "<>ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation]<>",have the same incubation conditions as all other samples in the same container:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, "<>ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation]<>",have the same incubation conditions as all other samples in the same container:",True,True],
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


	(* 3.)IncubationMaxTemperature *)
	(* If the Temperature is greater than the MaxTemperature of an input container, throw an error *)
	temperatureAboveMaxTemperatureQs = MapThread[
		With[{maxTemp = Lookup[#1, MaxTemperature, Null]},
			TemperatureQ[maxTemp] && maxTemp < #2
		]&,
		{sampleContainerModelPackets, temperatures}
	];

	temperatureAboveMaxTemperatureContainers = If[MemberQ[temperatureAboveMaxTemperatureQs, True],
		DeleteDuplicates@MapThread[
			If[TrueQ[#1],
				Lookup[#2, Object],
				Nothing
			]&,
			{temperatureAboveMaxTemperatureQs, sampleContainerPackets}
		],
		{}
	];

	incubationMaxTemperatureOptions = If[MemberQ[temperatureAboveMaxTemperatureQs, True] && messages,
		(
			Message[
				Error::IncubationMaxTemperature,
				(*1*)Capitalize@samplesForMessages[PickList[mySamples, temperatureAboveMaxTemperatureQs], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Potentially collapse to the sample or all samples instead of ID here *)
				(*2*)StringJoin[
					pluralize[PickList[mySamples, temperatureAboveMaxTemperatureQs], "reside"],
					If[Length[temperatureAboveMaxTemperatureContainers] == 1,
						" in container ",
						" in containers "
					]
				],
				(*3*)StringJoin[
					samplesForMessages[temperatureAboveMaxTemperatureContainers, CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],(* we have to display all the containers ID since invalid inputs do not display container id*)
					", which ",
					hasOrHave[temperatureAboveMaxTemperatureContainers]
				],
				(*4*)joinClauses[Map[fastAssocLookup[fastAssoc, #, {Model, MaxTemperature}]&, temperatureAboveMaxTemperatureContainers]]
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
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", do not have Temperature set higher than the MaxTemperature of their containers:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", do not have Temperature set higher than the MaxTemperature of their containers:", True, True],
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


	(* 4.)CustomIncubationConditionNotSpecified *)
	(* If IncubationCondition was set to Custom but not all incubation conditions were specified, throw a warning saying what we resolved them to *)
	resolvedUnspecifiedOptions = Lookup[resolvedOptions, unspecifiedMapThreadOptions];
	customIncubationWarningSamples = PickList[mySamples, customIncubationConditionNotSpecifiedWarnings];
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
			StringJoin[
				Capitalize@samplesForMessages[customIncubationWarningSamples, mySamples, Cache -> cacheBall, Simulation -> simulation], (* Potentially collapse the samples *)
				" ",
				hasOrHave[customIncubationWarningSamples]
			],
			joinClauses@DeleteDuplicates[Flatten@customIncubationWarningUnspecifiedOptionNames],
			Which[
				MemberQ[Flatten@customIncubationWarningUnspecifiedOptionNames, Incubator] && Length[DeleteDuplicates[Flatten@customIncubationWarningUnspecifiedOptionNames]] > 2,
					"the Incubator and incubator settings " <> joinClauses[DeleteCases[DeleteDuplicates[Flatten@customIncubationWarningUnspecifiedOptionNames], Incubator]],
				MemberQ[Flatten@customIncubationWarningUnspecifiedOptionNames, Incubator],
					"the Incubator and incubator setting " <> ToString[FirstCase[Flatten@customIncubationWarningUnspecifiedOptionNames, Except[Incubator]]],
				Length[DeleteDuplicates[Flatten@customIncubationWarningUnspecifiedOptionNames]] > 1,
					"the incubator settings " <> joinClauses[DeleteDuplicates[Flatten@customIncubationWarningUnspecifiedOptionNames]],
				True,
					"the incubator setting " <> ToString[First[Flatten@customIncubationWarningUnspecifiedOptionNames]]
			]
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
				Warning["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", if IncubationCondition is set to Custom, all incubation conditions are directly specified rather than automatically set:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs]>0,
				Warning["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", if IncubationCondition is set to Custom, all incubation conditions are directly specified rather than automatically set:", True, True],
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


	(* 5.)ConflictingShakingConditions *)
	(* Invalid shaking conditions options error check *)
	invalidShakingConditionsOptions = If[Or @@ conflictingShakingConditionsErrors && !gatherTests,
		Module[
			{
				invalidSamples, invalidSpecifiedShakingOptions, groupedSamplesBasedOnShakingOptions, allInvalidShakingOptions,
				reasonClause, explanationClause
			},
			(* Get the samples that correspond to this error. *)
			invalidSamples = PickList[mySamples, conflictingShakingConditionsErrors];
			(* Gather the set of shake options where the errors are detected *)
			invalidSpecifiedShakingOptions = Map[
				Function[unresolvedOptions,
					Normal[
						KeyTake[
							unresolvedOptions,
							PickList[
								{Shake, ShakingRate, ShakingRadius},
								Lookup[unresolvedOptions, {Shake, ShakingRate, ShakingRadius}],
								Except[Automatic]
							]
						],
						Association
					]
				],
				PickList[mapThreadFriendlyOptions, conflictingShakingConditionsErrors]
			];
			(* Group based on invalid shaking options are specified *)
			groupedSamplesBasedOnShakingOptions = GroupBy[Transpose@{invalidSamples, invalidSpecifiedShakingOptions}, Last];
			(* Sum a list of duplicate-free invalid shaking option keys *)
			allInvalidShakingOptions = DeleteDuplicates[Flatten[Keys[invalidSpecifiedShakingOptions]]];

			(* Build clauses *)
			(* 1. explain specifically which sample specified what conflicting options *)
			(* 2. key of non-false/null options *)
			(* 3. all duplicate free invalid option keys *)
			reasonClause =  If[Length[Keys[groupedSamplesBasedOnShakingOptions]] > $MaxNumberOfErrorDetails,
				(* Too many ways of conflicts, only points out samples and join with the capture sentence *)
				StringJoin[
					"for ",
					samplesForMessages[invalidSamples, mySamples, Cache -> cacheBall, Simulation -> simulation]
				],
				(* Less than N ways of conflicts, spell them out *)
				joinClauses[
					KeyValueMap[
						Function[{shakingOptions, sampleShakingOptionsTuple},
							StringJoin[
								(* xx is specified as xx, xx is  specified as xx, and xx is specified as xx *)
								joinClauses @ Map[
									StringJoin[ToString[Keys[#]], " is specified as ", ToString[Values[#]]]&,
									shakingOptions
								],
								" for ",
								samplesForMessages[sampleShakingOptionsTuple[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation]
							]
						],
						groupedSamplesBasedOnShakingOptions
					]
				]
			];
			(* Note that here we have 2 clauses to join at most, if this ever need to go beyond 2, we can't use joinClauses directly for complete sentences like this, as it might expand to blahA., blahB., blahC.*)
			explanationClause = joinClauses[{
				If[MemberQ[Lookup[invalidSpecifiedShakingOptions, Shake, Null], Except[False]],
					(* If the invalid options contain a Shake -> True include the following clause *)
					"When Shake is True, ShakingRate and ShakingRadius must both be populated.",
					Nothing
				],
				If[MemberQ[Lookup[invalidSpecifiedShakingOptions, Shake, Null], Except[True]],
					(* If the invalid options contain a Shake -> True include the following clause *)
					"When Shake is False, ShakingRate and ShakingRadius must both be Null.",
					Nothing
				]
			}, ConjunctionWord -> "", CaseAdjustment -> False];

			(* Throw the corresponding error. *)
			Message[
				Error::ConflictingShakingConditions,
				reasonClause,
				explanationClause,
				joinClauses[allInvalidShakingOptions]
			];

			(* Return our invalid options. *)
			allInvalidShakingOptions
		],
		{}
	];

	(* Create the corresponding test for the invalid options. *)
	invalidShakingConditionsTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingShakingConditionsErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have selected shaking options compatible with each other", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have selected shaking options compatible with each other", True, True],
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


	(* 6.)ConflictingCellType Warning and Error *)
	(* Conflicting CellType options error check *)
	conflictingCellTypeErrorOptions = If[Or @@ conflictingCellTypeErrors && !gatherTests,
		(* Throw the corresponding error. *)
		Message[Error::ConflictingCellType,
			"Mammalian and microbial cells are not cultured together due to their differing incubation requirements and the need to avoid contamination",
			StringJoin[
				Capitalize@samplesForMessages[PickList[mySamples, conflictingCellTypeErrors], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
				" ",
				hasOrHave[PickList[mySamples, conflictingCellTypeErrors]]
			],
			joinClauses[PickList[cellTypes, conflictingCellTypeErrors]],
			joinClauses[PickList[cellTypesFromSample, conflictingCellTypeErrors]]
		];

		(* Return our invalid options. *)
		{CellType},
		{}
	];

	If[MemberQ[conflictingCellTypeWarnings, True] && messages,
		Message[Warning::ConflictingCellType,
			"Bacterial and yeast cells require slightly different incubation conditions",
			StringJoin[
				Capitalize@samplesForMessages[PickList[mySamples, conflictingCellTypeWarnings], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
				" ",
				hasOrHave[PickList[mySamples, conflictingCellTypeWarnings]]
			],
			joinClauses[PickList[cellTypes, conflictingCellTypeWarnings]],
			joinClauses[PickList[cellTypesFromSample, conflictingCellTypeWarnings]]
		]
	];

	(* Create the corresponding test for the invalid options. *)
	conflictingCellTypeTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, Transpose[{conflictingCellTypeErrors, conflictingCellTypeWarnings}], {True, _}|{_, True}];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have a CellType that matches the CellType option value provided", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have a CellType that matches the CellType option value provided", True, True],
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


	(* 7.)CellTypeNotSpecified *)
	(* CellType not specified options warning check *)
	If[Or@@cellTypeNotSpecifiedWarnings && !gatherTests && notInEngine,
		Message[
			Warning::CellTypeNotSpecified,
			(*1*)(* Potentially collapse to the sample or all samples instead of ID here *)
				StringJoin[
					Capitalize@samplesForMessages[PickList[mySamples, cellTypeNotSpecifiedWarnings], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
					" ",
					hasOrHave[PickList[mySamples, cellTypeNotSpecifiedWarnings]]
				],
			(*2*)pluralize[PickList[mySamples, cellTypeNotSpecifiedWarnings], "this sample", "these samples"]
		]
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
				Warning["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have a CellType specified (as an option or in the Model)", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have a CellType specified (as an option or in the Model)", True, True],
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


	(* 8.)ConflictingCultureAdhesion *)
	(* Conflicting CultureAdhesion options error check *)
	conflictingCultureAdhesionOptions = If[MemberQ[conflictingCultureAdhesionErrors, True],
		{CultureAdhesion},
		{}
	];

	conflictingCultureAdhesionCases = If[MemberQ[conflictingCultureAdhesionErrors, True],
		MapThread[
			Which[
				TrueQ[#3] && (MatchQ[#2, #4] || !MatchQ[#4, CultureAdhesionP]),
					{Lookup[#1, Object], State, Lookup[#1, State], #2},
				TrueQ[#3] && MatchQ[Lookup[#1, State], Solid] && MatchQ[#2, SolidMedia] && !MatchQ[#2, #4],
					{Lookup[#1, Object], CultureAdhesion, #4, #2},
				TrueQ[#3] && MatchQ[Lookup[#1, State], Liquid] && MatchQ[#2, Adherent|Suspension] && !MatchQ[#2, #4],
					{Lookup[#1, Object], CultureAdhesion, #4, #2},
				True,
					{Lookup[#1, Object], {State, CultureAdhesion}, {Lookup[#1, State], #4}, #2}
			]&,
			{samplePackets, cultureAdhesions, conflictingCultureAdhesionErrors, cultureAdhesionsFromSample}
		],
		{}
	];

	If[!MatchQ[conflictingCultureAdhesionOptions, {}] && !gatherTests && notInEngine,
		Module[{groupedErrorSamples, briefMessage, errorMessage, actionMessage},
			groupedErrorSamples = GroupBy[conflictingCultureAdhesionCases, Rest];
			(* Error-type specific brief description *)
			briefMessage = If[Length[Keys[groupedErrorSamples]] > $MaxNumberOfErrorDetails,
				"The CultureAdhesion option should match the values specified in the CultureAdhesion field and be consistent with the objects' State",
				joinClauses[
					Flatten@{
						If[MemberQ[Flatten[conflictingCultureAdhesionCases[[All, 2]]], State],
							Map[
								Which[
									MemberQ[ToList@#[[2]], State] && MatchQ[#[[4]], Adherent],
										"Adherent cell culture type is only valid when growing cells in media with Liquid State",
									MemberQ[ToList@#[[2]], State] && MatchQ[#[[4]], Suspension],
										"Suspension cell culture type is only valid when growing cells in media with Liquid State",
									MemberQ[ToList@#[[2]], State] && MatchQ[#[[4]], SolidMedia],
										"SolidMedia cell culture type is only valid when growing cells in media with Solid State",
									True, Nothing
								]&,
								conflictingCultureAdhesionCases
							],
							Nothing
						],
						If[MemberQ[Flatten[conflictingCultureAdhesionCases[[All, 2]]], CultureAdhesion],
							"the cell culture type detected in the CultureAdhesion field and the specified CultureAdhesion option should match with each other",
							Nothing
						]
					},
					CaseAdjustment -> True
				]
			];
			(* Error-type specific error description *)
			errorMessage = If[Length[Keys[groupedErrorSamples]] > $MaxNumberOfErrorDetails,
				StringJoin[
					(* Potentially collapse to the sample or all samples instead of ID here *)
					StringJoin[
						Capitalize@samplesForMessages[conflictingCultureAdhesionCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
						" ",
						hasOrHave[conflictingCultureAdhesionCases[[All, 1]]]
					],
					Which[
						MemberQ[Flatten[conflictingCultureAdhesionCases[[All, 2]]], State] && MemberQ[Flatten[conflictingCultureAdhesionCases[[All, 2]]], CultureAdhesion],
							" inconsistencies between the CultureAdhesion option and the values in the CultureAdhesion and State fields",
						Length[conflictingCultureAdhesionCases] == 1,
							" an inconsistency between the CultureAdhesion option and the field " <> ToString[conflictingCultureAdhesionCases[[All, 2]][[1]]],
						True,
							" inconsistencies between the CultureAdhesion option and the field " <> ToString[conflictingCultureAdhesionCases[[All, 2]][[1]]]
					]
				],
				joinClauses[
					Map[
						Function[{groupedKey},
							Module[{groupedCases},
								groupedCases = Lookup[groupedErrorSamples, Key[groupedKey]];
								If[MatchQ[groupedKey[[1]], {State, CultureAdhesion}],
									StringJoin[
										samplesForMessages[groupedCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
										" ",
										hasOrHave[groupedCases[[All, 1]]],
										" the CultureAdhesion option specified as ",
										joinClauses[groupedCases[[All, 4]]],
										" while the ",
										joinClauses[groupedCases[[All, 2]][[1]]],
										" fields for the ",
										pluralize[groupedCases[[All, 1]], " sample", " samples"],
										" are ",
										joinClauses[groupedCases[[All, 3]][[1]]]
									],
									StringJoin[
										samplesForMessages[groupedCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
										" ",
										hasOrHave[groupedCases[[All, 1]]],
										" the CultureAdhesion option specified as ",
										joinClauses[groupedCases[[All, 4]]],
										" while the ",
										joinClauses[groupedCases[[All, 2]]],
										" field for the ",
										pluralize[groupedCases[[All, 1]], " sample", " samples"],
										" is ",
										joinClauses[groupedCases[[All, 3]]]
									]
								]
							]
						],
						Keys[groupedErrorSamples]
					],
					CaseAdjustment -> True
				]
			];
			actionMessage = If[MemberQ[Flatten[conflictingCultureAdhesionCases[[All, 2]]], State] && MemberQ[Flatten[conflictingCultureAdhesionCases[[All, 2]]], CultureAdhesion],
				"the CultureAdhesion and State fields of the sample(s)",
				"the " <> ToString[conflictingCultureAdhesionCases[[All, 2]][[1]]] <> " field of the sample(s)"
			];
			Message[Error::ConflictingCultureAdhesion,
				briefMessage,
				errorMessage,
				actionMessage
			]
		]
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
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have a CultureAdhesion that matches the CultureAdhesion option value provided", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have a CultureAdhesion that matches the CultureAdhesion option value provided", True, True],
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


	(* 9.)CultureAdhesionNotSpecified *)
	(* CultureAdhesion not specified options warning check *)
	If[Or @@ cultureAdhesionNotSpecifiedWarnings && !gatherTests && notInEngine,
		Module[{groupedDefaultCultureAdhesions, captureSentence, reasonClause, actionClause},
			groupedDefaultCultureAdhesions = GroupBy[Transpose@{PickList[mySamples, cultureAdhesionNotSpecifiedWarnings], PickList[cultureAdhesions, cultureAdhesionNotSpecifiedWarnings, True]}, Last];
			captureSentence = joinClauses@MapThread[
				Which[
					MatchQ[#3, False], Nothing,
					TrueQ[#2], "The types of culture adhesion supported at ECL include Suspension, Adherent, and SolidMedia",
					MatchQ[#1, Bacterial|Yeast], "The types of culture adhesion supported for microbial cells at ECL include Suspension and SolidMedia",
					MatchQ[#1, Mammalian], "The type of culture adhesion supported at ECL for mammalian cells is Adherent",(* If we have Suspension in the future, add here *)
					True, "The types of culture adhesion supported at ECL include Suspension, Adherent, and SolidMedia"
				]&,
				{cellTypes, cellTypeNotSpecifiedWarnings, cultureAdhesionNotSpecifiedWarnings}
			];
			reasonClause = StringJoin[
				Capitalize@samplesForMessages[PickList[mySamples, cultureAdhesionNotSpecifiedWarnings], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
				" ",
				hasOrHave[PickList[mySamples, cultureAdhesionNotSpecifiedWarnings]]
			];
			actionClause = Which[
				Length[Keys[groupedDefaultCultureAdhesions]] == 1,
					StringJoin[
						"For ",
						pluralize[PickList[mySamples, cultureAdhesionNotSpecifiedWarnings], "this sample, ", "these samples, "],
						"the CultureAdhesion option will default to ",
						ToString[Keys[groupedDefaultCultureAdhesions][[1]]]
					],
				Length[Keys[groupedDefaultCultureAdhesions]] > $MaxNumberOfErrorDetails,
					StringJoin[
						"For these samples, the CultureAdhesion option will default to ",
						joinClauses[Keys[groupedDefaultCultureAdhesions]]
					],
				True,
					joinClauses[
						Map[
							StringJoin[
								"for ",
								samplesForMessages[Lookup[groupedDefaultCultureAdhesions, #][[All, 1]], Cache -> cacheBall, Simulation -> simulation],
								", the CultureAdhesion option will default to ",
								ToString[#]
							]&,
							Keys[groupedDefaultCultureAdhesions]
						],
						CaseAdjustment -> True
					]
			];
			Message[
				Warning::CultureAdhesionNotSpecified,
				captureSentence,
				reasonClause,
				actionClause
			]
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
				Warning["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have a CultureAdhesion specified (as an option or in the Model)", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have a CultureAdhesion specified (as an option or in the Model)", True, True],
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


	(* 10.)ConflictingCellTypeWithCultureAdhesion *)
	(* Can't do Mammalian + SolidMedia, or Yeast|Bacterial + Adherent *)
	conflictingCellTypeAdhesionOptions = If[MemberQ[conflictingCellTypeAdhesionErrors, True] && messages,
		Module[{briefMessage, errorCases, groupedErrorSamples, errorMessage, actionMessage},
			(* No need to collapse the brief message since only 2 variations *)
			briefMessage = joinClauses[
				MapThread[
					Which[
						TrueQ[#2] && MatchQ[#1, Mammalian], "CultureAdhesion cannot be SolidMedia when CellType is Mammalian",
						TrueQ[#2], "CultureAdhesion cannot be Adherent when CellType is " <> ToString[#1],
						True, Nothing
					]&,
					{cellTypes, conflictingCellTypeAdhesionErrors}
				]
			];
			(* Display how the options values are resolved, if both objects field and options have the same value, use option first *)
			errorCases = MapThread[
				Function[{sample, conflictingCellTypeAdhesionQ, resolvedCultureAdhesion, resolvedCellType, objectCultureAdhesion, objectCellType, specifiedCultureAdhesion, specifiedCellType},
					Which[
						!TrueQ[conflictingCellTypeAdhesionQ],
							Nothing,
						And[
							MatchQ[resolvedCellType, Bacterial|Yeast],
							MatchQ[resolvedCultureAdhesion, Adherent]
						],
							Which[
								MatchQ[specifiedCellType, Bacterial|Yeast] && MatchQ[specifiedCultureAdhesion, Adherent], {sample, resolvedCultureAdhesion, resolvedCellType, {CultureAdhesion, CellType}},
								!MatchQ[specifiedCellType, Bacterial|Yeast] && MatchQ[objectCellType, Bacterial|Yeast] && MatchQ[specifiedCultureAdhesion, Adherent], {sample, resolvedCultureAdhesion, resolvedCellType, {CultureAdhesion, Object}},
								!MatchQ[specifiedCellType, Bacterial|Yeast] && !MatchQ[objectCellType, Bacterial|Yeast] && MatchQ[specifiedCultureAdhesion, Adherent], {sample, resolvedCultureAdhesion, resolvedCellType, {CultureAdhesion, Default}},
								MatchQ[specifiedCellType, Bacterial|Yeast] && MatchQ[objectCultureAdhesion, Adherent] && !MatchQ[specifiedCultureAdhesion, Adherent], {sample, resolvedCultureAdhesion, resolvedCellType, {Object, CellType}},
								MatchQ[specifiedCellType, Bacterial|Yeast] && !MatchQ[objectCultureAdhesion, Adherent] && !MatchQ[specifiedCultureAdhesion, Adherent], {sample, resolvedCultureAdhesion, resolvedCellType, {Default, CellType}},
								!MatchQ[objectCultureAdhesion, Adherent] && !MatchQ[objectCellType, Bacterial|Yeast], {sample, resolvedCultureAdhesion, resolvedCellType, {Default, Default}},
								True, {sample, resolvedCultureAdhesion, resolvedCellType, {Object, Object}}
							],
						True,
							Which[
								MatchQ[specifiedCellType, Mammalian] && MatchQ[specifiedCultureAdhesion, SolidMedia], {sample, resolvedCultureAdhesion, resolvedCellType, {CultureAdhesion, CellType}},
								!MatchQ[specifiedCellType, Mammalian] && MatchQ[objectCellType, Mammalian] && MatchQ[specifiedCultureAdhesion, SolidMedia], {sample, resolvedCultureAdhesion, resolvedCellType, {CultureAdhesion, Object}},
								!MatchQ[specifiedCellType, Mammalian] && !MatchQ[objectCellType, Mammalian] && MatchQ[specifiedCultureAdhesion, SolidMedia], {sample, resolvedCultureAdhesion, resolvedCellType, {CultureAdhesion, Default}},
								MatchQ[specifiedCellType, Mammalian] && MatchQ[objectCultureAdhesion, SolidMedia] && !MatchQ[specifiedCultureAdhesion, SolidMedia], {sample, resolvedCultureAdhesion, resolvedCellType, {Object, CellType}},
								MatchQ[specifiedCellType, Mammalian] && !MatchQ[objectCultureAdhesion, SolidMedia] && !MatchQ[specifiedCultureAdhesion, SolidMedia], {sample, resolvedCultureAdhesion, resolvedCellType, {Default, CellType}},
								!MatchQ[objectCultureAdhesion, SolidMedia] && !MatchQ[objectCellType, Mammalian], {sample, resolvedCultureAdhesion, resolvedCellType, {Default, Default}},
								True, {sample, resolvedCultureAdhesion, resolvedCellType, {Object, Object}}
							]
					]
				],
				{mySamples, conflictingCellTypeAdhesionErrors, cultureAdhesions, cellTypes, cultureAdhesionsFromSample, cellTypesFromSample, Lookup[mapThreadFriendlyOptions, CultureAdhesion], Lookup[mapThreadFriendlyOptions, CellType]}
			];
			groupedErrorSamples = GroupBy[errorCases, Last];
			errorMessage = If[Length[Keys[groupedErrorSamples]] > $MaxNumberOfErrorDetails,
				StringJoin[
					(* Potentially collapse to the sample or all samples instead of ID here *)
					StringJoin[
						Capitalize@samplesForMessages[errorCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
						" ",
						hasOrHave[errorCases]
					],
					" conflicts between the CultureAdhesion and CellType"
				],
				joinClauses[
					Map[
						Function[{groupedKey},
							Module[{groupedCases},
								groupedCases = Lookup[groupedErrorSamples, Key[groupedKey]];
								Which[
									MatchQ[groupedKey, {Object, Object}],
										StringJoin[
											samplesForMessages[groupedCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
											" ",
											hasOrHave[groupedCases[[All, 1]]],
											" the CultureAdhesion detected in the object as ",
											joinClauses[groupedCases[[All, 2]]],
											" while the CellType detected in the object as ",
											joinClauses[groupedCases[[All, 3]]]
										],
									MatchQ[groupedKey, {Object, CellType}],
										StringJoin[
											samplesForMessages[groupedCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
											" ",
											hasOrHave[groupedCases[[All, 1]]],
											" the CultureAdhesion detected in the object as ",
											joinClauses[groupedCases[[All, 2]]],
											" while the CellType option specified as ",
											joinClauses[groupedCases[[All, 3]]]
										],
									MatchQ[groupedKey, {CultureAdhesion, Object}],
										StringJoin[
											samplesForMessages[groupedCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
											" ",
											hasOrHave[groupedCases[[All, 1]]],
											" the CultureAdhesion option specified as ",
											joinClauses[groupedCases[[All, 2]]],
											" while the CellType detected in the object as ",
											joinClauses[groupedCases[[All, 3]]]
										],
									MatchQ[groupedKey, {Default, CellType}],
										StringJoin[
											samplesForMessages[groupedCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
											" ",
											hasOrHave[groupedCases[[All, 1]]],
											" the CultureAdhesion default to ",
											joinClauses[groupedCases[[All, 2]]],
											" while the CellType option specified as ",
											joinClauses[groupedCases[[All, 3]]]
										],
									MatchQ[groupedKey, {CultureAdhesion, Default}],
										StringJoin[
											samplesForMessages[groupedCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
											" ",
											hasOrHave[groupedCases[[All, 1]]],
											" the CultureAdhesion option specified as ",
											joinClauses[groupedCases[[All, 2]]],
											" while the CellType default to ",
											joinClauses[groupedCases[[All, 3]]]
										],
									MatchQ[groupedKey, {Default, Default}],
										StringJoin[
											samplesForMessages[groupedCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
											" ",
											hasOrHave[groupedCases[[All, 1]]],
											" the CultureAdhesion default to ",
											joinClauses[groupedCases[[All, 2]]],
											" while the CellType default to ",
											joinClauses[groupedCases[[All, 3]]]
										],
									True,
										StringJoin[
											samplesForMessages[groupedCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
											" ",
											hasOrHave[groupedCases[[All, 1]]],
											" the CultureAdhesion option specified as ",
											joinClauses[groupedCases[[All, 2]]],
											" while the CellType option specified as ",
											joinClauses[groupedCases[[All, 3]]]
										]
								]
							]
						],
						Keys[groupedErrorSamples]
					],
					CaseAdjustment -> True
				]
			];
			actionMessage = Which[
				MemberQ[Flatten@Keys[groupedErrorSamples], Object] && MemberQ[Flatten@Keys[groupedErrorSamples], Except[Object]],
					"please change these option(s) or use UploadSampleProperties to define those field(s) to specify a valid protocol",
				!MemberQ[Flatten@Keys[groupedErrorSamples], Object],
					"please change these options to specify a valid protocol",
				True,
					"please change use UploadSampleProperties to define those fields to specify a valid protocol"
			];
			Message[
				Error::ConflictingCellTypeWithCultureAdhesion,
				briefMessage,
				errorMessage,
				actionMessage
			];
			{CultureAdhesion, CellType}
		],
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
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", don't try Mammalian+SolidMedia, or Bacterial|Yeast+Adherent:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", don't try Mammalian+SolidMedia, or Bacterial|Yeast+Adherent:", True, True],
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


	(* 11.)ConflictingCultureAdhesionWithContainer *)
	(* If samples are not in plates, can't be be SolidMedia or Adherent *)
	conflictingCultureAdhesionWithContainerOptions = If[MemberQ[conflictingCultureAdhesionWithContainerErrors, True] && messages,
		Module[{invalidSamples, briefMessage, actionMessage},
			invalidSamples = PickList[mySamples, conflictingCultureAdhesionWithContainerErrors];
			briefMessage = joinClauses[
				MapThread[
					Which[
						TrueQ[#3] && MatchQ[#2, Adherent], "Adherent cell culture type is only supported when growing cells in liquid media in plate-type cell culture vessels",
						TrueQ[#3] && MatchQ[#2, SolidMedia], "SolidMedia cell culture type is only supported when growing cells in solid media in plate-type cell culture vessels",
						True, Nothing
					]&,
					{samplePackets, cultureAdhesions, conflictingCultureAdhesionWithContainerErrors, sampleContainerPackets}
				]
			];
			actionMessage = joinClauses[
				MapThread[
					Which[
						TrueQ[#3] && MatchQ[#2, Adherent],
						"please dissociate adherent cells from the current container(s) and use ExperimentTransfer to transfer the cells into plate-type cell culture vessel(s) with liquid media",
						TrueQ[#3] && MatchQ[#2, SolidMedia],
						"please use ExperimentPickColonies to transfer colonies from the current container(s) into plate-type cell culture vessel(s) with solid media",
						True, Nothing
					]&,
					{samplePackets, cultureAdhesions, conflictingCultureAdhesionWithContainerErrors, sampleContainerPackets}
				]
			];
			Message[
				Error::ConflictingCultureAdhesionWithContainer,
				briefMessage,
				StringJoin[
					If[!SameQ@@PickList[cultureAdhesions, conflictingCultureAdhesionWithContainerErrors],
						samplesForMessages[invalidSamples, Cache -> cacheBall, Simulation -> simulation],
						Capitalize@samplesForMessages[invalidSamples, mySamples, Cache -> cacheBall, Simulation -> simulation](* potentially collapse samples *)
					],
					" ",
					hasOrHave[invalidSamples]
				],
				joinClauses@PickList[cultureAdhesions, conflictingCultureAdhesionWithContainerErrors],
				StringJoin[
					If[Length[invalidSamples] == 1, "is in a container", "are in container(s)"],
					" with Footprint of ",
					joinClauses@PickList[sampleContainerFootprints, conflictingCultureAdhesionWithContainerErrors]
				],
				actionMessage
			];
			{CultureAdhesion}
		],
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
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", are in plates if CultureAdhesion is SolidMedia or Adherent:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", are in plates if CultureAdhesion is SolidMedia or Adherent:", True, True],
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


	(* 12.)InvalidIncubationConditions *)
	(* If IncubationCondition was set to a non-incubation storage type, throw an error *)
	invalidIncubationConditionOptions = If[MemberQ[invalidIncubationConditionErrors, True] && messages,
		(
			Message[
				Error::InvalidIncubationConditions,
				StringJoin[
					Capitalize@samplesForMessages[PickList[mySamples, invalidIncubationConditionErrors], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
					" ",
					hasOrHave[PickList[mySamples, invalidIncubationConditionErrors]]
				],
				joinClauses[Map[ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]&, PickList[incubationCondition, invalidIncubationConditionErrors]]]
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
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have a specified IncubationCondition that is currently supported:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have a specified IncubationCondition that is currently supported:", True, True],
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


	(* 13.)UnsupportedCellCultureType *)
	(* Can't do Mammalian + Suspension right now  *)
	(* Distinguish whether the Suspension value is inherited from Object or from specified option *)
	unsupportedCellCultureTypeCases = MapThread[
		Which[
			MatchQ[#2, False], Nothing,
			MatchQ[#3, Suspension], {#1, CultureAdhesion},
			MatchQ[#4, Suspension], {#1, Object},
			True, {#1, State}
		]&,
		{mySamples, unsupportedCellCultureTypeErrors, Lookup[mapThreadFriendlyOptions, CultureAdhesion], cultureAdhesionsFromSample}
	];
	unsupportedCellCultureTypeOptions = If[MemberQ[unsupportedCellCultureTypeErrors, True] && messages,
		Module[{groupedErrorDetails, errorClause, actionClause},
			(* Group by how CultureAdhesion is determined *)
			groupedErrorDetails = GroupBy[unsupportedCellCultureTypeCases, Last];
			(* Return the joined clauses stating what's wrong *)
			errorClause = joinClauses[
				Map[
					StringJoin[
						Capitalize@samplesForMessages[groupedErrorDetails[#][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
						pluralize[groupedErrorDetails[#], " requires mammalian suspension cell culture", " require mammalian suspension cell culture"],
						" since CultureAdhesion is",
						Which[
							MatchQ[groupedErrorDetails[#][[All, 2]], {Object..}],
								" detected as Suspension from the CultureAdhesion field of the object(s)",
							MatchQ[groupedErrorDetails[#][[All, 2]], {CultureAdhesion..}],
								" specified as Suspension for the CultureAdhesion option",
							True,
								" default to Suspension based on the State field of the object(s)"
						]
					]&,
					Keys[groupedErrorDetails]
				],
				CaseAdjustment -> True
			];
			actionClause = If[MemberQ[unsupportedCellCultureTypeCases[[All, 2]], Object|State],
				"Please contact Scientific Solutions team if you have a sample that falls outside current support",
				"Please change the CultureAdhesion option to Adherent if mammalian adherent cell culture is desired or contact Scientific Solutions team if you have a sample that falls outside current support"
			];

			Message[
				Error::UnsupportedCellCultureType,
				"ExperimentIncubateCells only supports adherent cell culture type for mammalian samples",
				errorClause,
				actionClause
			];
			{CultureAdhesion, CellType}
		],
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
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", do not request the currently unsupported Mammalian Suspension culture:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", do not request the currently unsupported Mammalian Suspension culture:", True, True],
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

	(* A list of index-matching-to-sample boolean list of whether there was conflict between user-specified CellType vs detected. This is being by many warnings and errors that we need to specified whether the bad cell type was specified *)
	specifiedConflictingCellTypeQs = Transpose@MapThread[
		Function[{conflictWarning, conflictError},
			conflictWarning || conflictError
		],
		{conflictingCellTypeWarnings, conflictingCellTypeErrors}
	];

	(* 14.)ConflictingCellTypeWithStorageCondition *)
	(* Throw a soft warning if the StorageCondition specified is intended for a different microbial cell type from the sample *)
	If[MemberQ[conflictingCellTypeWithStorageConditionWarnings, True] && messages,
		Module[{warningTuples, warningGroupedTuples, warningClause},
			warningTuples = MapThread[
				Function[{sample, warningBool, cellType, specifiedStorageCondition},
					If[TrueQ[warningBool],
						{specifiedStorageCondition, sample, cellType},
						Nothing
					]
				],
				{
					mySamples,
					conflictingCellTypeWithStorageConditionWarnings,
					cellTypes,
					samplesOutStorageCondition
				}
			];
			(* Group by specified StorageConditions *)
			warningGroupedTuples = GroupBy[warningTuples, First];
			(* Return the joined clauses stating what's wrong *)
			warningClause = StringJoin @@ KeyValueMap[
				Function[{storageCondition, tuple},
					StringJoin[
						Capitalize@samplesForMessages[tuple[[All, 2]], mySamples, Cache -> cacheBall, Simulation -> simulation],
						" ",
						isOrAre[tuple[[All, 2]]],
						(* whether the cell types were specified or detected *)
						Module[{invalidSamplesSpecifiedConflictingCellTypeQs},
							invalidSamplesSpecifiedConflictingCellTypeQs = PickList[specifiedConflictingCellTypeQs, mySamples, ObjectP[tuple[[All, 2]]]];
							Which[
								(* all were specified conflicting with sample *)
								AllTrue[invalidSamplesSpecifiedConflictingCellTypeQs, TrueQ],
									" specified to have a " <> joinClauses[tuple[[All, 3]], CaseAdjustment -> True] <> " CellType",
								(* some specified conflicting with sample *)
								AnyTrue[invalidSamplesSpecifiedConflictingCellTypeQs, TrueQ],
									" specified or detected to have a " <> joinClauses[tuple[[All, 3]], CaseAdjustment -> True] <> " CellType",
								(* none were specified conflicting with sample *)
								True,
									" detected to have a " <> joinClauses[tuple[[All, 3]], CaseAdjustment -> True] <> " CellType"
							]
						],
						", but ",
						isOrAre[tuple[[All, 2]]],
						" specified to be stored under ",
						If[MatchQ[storageCondition, ObjectP[]],
							ObjectToString[storageCondition, Cache -> cacheBall, Simulation -> simulation],
							ToString[storageCondition]
						],
						" after cell incubation. "
					]
				],
				warningGroupedTuples
			];
			Message[
				Warning::ConflictingCellTypeWithStorageCondition,
				warningClause
			]
		]
	];

	conflictingCellTypeWithStorageConditionWarningTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingCellTypeWithStorageConditionWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> " do not specify SamplesOutStorageConditions that is intended for a different microbial cell type than the samples' cell types:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> " do not specify SamplesOutStorageConditions that is intended for a different microbial cell type than the samples' cell types:", True, True],
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


	(* 15.)ConflictingCellTypeWithStorageCondition *)
	(* Hard error version of warning ConflictingCellTypeWithStorageCondition *)
	(* If not disposing of things, then SamplesOutStorageCondition must be in agreement with what kind of cells we have *)
	conflictingCellTypeWithStorageConditionOptions = If[MemberQ[conflictingCellTypeWithStorageConditionErrors, True] && messages,
		Module[{errorTuples, errorGroupedTuples, errorClause},
			errorTuples = MapThread[
				Function[{sample, errorBool, cellType, specifiedStorageCondition},
					If[TrueQ[errorBool],
						{specifiedStorageCondition, sample, cellType},
						Nothing
					]
				],
				{
					mySamples,
					conflictingCellTypeWithStorageConditionErrors,
					cellTypes,
					samplesOutStorageCondition
				}
			];
			(* Group by specified StorageConditions *)
			errorGroupedTuples = GroupBy[errorTuples, First];
			(* Return the joined clauses stating what's wrong *)
			errorClause = StringJoin @@ KeyValueMap[
					Function[{storageCondition, tuple},
						StringJoin[
							Capitalize@samplesForMessages[tuple[[All, 2]], mySamples, Cache -> cacheBall, Simulation -> simulation],
							" ",
							isOrAre[tuple[[All, 2]]],
							(* whether the cell types were specified or detected *)
							Module[{invalidSamplesSpecifiedConflictingCellTypeQs},
								invalidSamplesSpecifiedConflictingCellTypeQs = PickList[specifiedConflictingCellTypeQs, mySamples, ObjectP[tuple[[All, 2]]]];
								Which[
									(* all were specified conflicting with sample *)
									AllTrue[invalidSamplesSpecifiedConflictingCellTypeQs, TrueQ],
										" specified to have a " <> joinClauses[tuple[[All, 3]], CaseAdjustment -> True] <> " CellType",
									(* some specified conflicting with sample *)
									AnyTrue[invalidSamplesSpecifiedConflictingCellTypeQs, TrueQ],
										" specified or detected to have a " <> joinClauses[tuple[[All, 3]], CaseAdjustment -> True] <> " CellType",
									(* none were specified conflicting with sample *)
									True,
										 "detected to have a " <> joinClauses[tuple[[All, 3]], CaseAdjustment -> True] <> " CellType"
								]
							],
							", but ",
							isOrAre[tuple[[All, 2]]],
							" specified to be stored under ",
							If[MatchQ[storageCondition, ObjectP[]],
								ObjectToString[storageCondition, Cache -> cacheBall, Simulation -> simulation],
								ToString[storageCondition]
							],
							" after cell incubation. "
						]
					],
					errorGroupedTuples
				];
			Message[
				Error::ConflictingCellTypeWithStorageCondition,
				errorClause
			];
			{CellType, SamplesOutStorageCondition}
		],
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
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have SamplesOutStorageCondition that are consistent with their CellType:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have SamplesOutStorageCondition that are consistent with their CellTyps:", True, True],
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


	(* 16.)ShakingRecommendedForStorageCondition *)
	(* If not disposing of things or putting things in fridge/ambient, then warn the user if SamplesOutStorageCondition is not in agreement with Suspension CultureAdhesion *)
	recommendedSCForSuspension = MapThread[
		Which[
			TrueQ[#2] && MatchQ[#1, Mammalian], Null,(*Note:we do not recommended anything for mammalian suspension since it is not supported *)
			TrueQ[#2] && MatchQ[#1, Bacterial], BacterialShakingIncubation,
			TrueQ[#2] && MatchQ[#1, Yeast], YeastShakingIncubation,
			True, Null
		]&,
		{cellTypes, conflictingCultureAdhesionWithStorageConditionWarnings}
	];
	If[MemberQ[recommendedSCForSuspension, BacterialShakingIncubation|YeastShakingIncubation] && messages,
		(
			Message[
				Warning::ShakingRecommendedForStorageCondition,
				StringJoin[
					Capitalize@samplesForMessages[PickList[mySamples, recommendedSCForSuspension, BacterialShakingIncubation | YeastShakingIncubation], mySamples, Cache -> cacheBall, Simulation -> simulation], (* potentially collapse samples *)
					" ",
					hasOrHave[PickList[mySamples, recommendedSCForSuspension, BacterialShakingIncubation | YeastShakingIncubation]]
				],
				joinClauses@PickList[samplesOutStorageCondition, recommendedSCForSuspension, BacterialShakingIncubation | YeastShakingIncubation],
				joinClauses@DeleteCases[recommendedSCForSuspension, Null]
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
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have SamplesOutStorageCondition that are consistent with their CultureAdhesion shaking requirement:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have SamplesOutStorageCondition that are consistent with their CultureAdhesion shaking requirement:", True, True],
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
	(*------------------------ Local helpers for incubator error checking ----------------------------*)
	(* Overload that takes a list of incubator packets. go through the settings vs each incubator. Output a pair of {incubator, change of settings} that requires least changes *)
	whyCantIPickThisIncubator[potentialIncubatorPackets: {PacketP[Model[Instrument,Incubator]]..}, incubationSettings:{(_Rule)..}, userOptions: {(_Rule)...}, inputIncubationCondition: Alternatives[Null,Automatic, Custom, Sequence@@incubationConditionSymbols, ObjectP[Model[StorageCondition]]],numberOfExamples_Integer] := Module[
		{
			incompatibleIncubators, userSpecifiedKeys, requiredChangesToSpecified,
			requiredChanges, incubatorChangesTuples, minimalChangesIncompatibleIncubators,
			specifiedIncubationConditionSymbol, specifiedIncubationConditionAllowedIncubators, incubationConditionAllowedIncubatorChangesTuples
		},
		(* Determine the IncubationCondition symbol if the user specified a valid incubation condition. Otherwise it is Nulled *)
		specifiedIncubationConditionSymbol = If[MatchQ[inputIncubationCondition, Alternatives[Custom, Sequence@@incubationConditionSymbols, ObjectP[Model[StorageCondition]]]],
			incubationConditionModelToSymbol[inputIncubationCondition],
			Null
		];
		(* Find the incubators allowed by the specified incubation condition if any *)
		specifiedIncubationConditionAllowedIncubators = If[!NullQ[specifiedIncubationConditionSymbol],
			Lookup[incubationConditionIncubatorLookup, specifiedIncubationConditionSymbol],
			{}
		];
		(* Get all the incubator models *)
		incompatibleIncubators =  Lookup[potentialIncubatorPackets, Object];
		(* User input keys *)
		userSpecifiedKeys = Keys[Select[Normal[userOptions, Association], MatchQ[Values[#], Except[Automatic]] &]];
		(* For each incubator model, calculate the changed needed *)
		requiredChanges = whyCantIPickThisIncubator[#, incubationSettings]& /@ potentialIncubatorPackets;
		(* Screen the required changes list to container only those with user specified options *)
		requiredChangesToSpecified = Cases[#, {Alternatives@@userSpecifiedKeys, _}] &/@ requiredChanges;
		(* Construct a tuples of {incubator, corresponding changes to user specified options} and sort by less changes required*)
		incubatorChangesTuples = Transpose[{incompatibleIncubators, requiredChangesToSpecified}];
		(* Prioritize using incubator allowed by the specified incubation condition *)
		incubationConditionAllowedIncubatorChangesTuples = If[ContainsAny[specifiedIncubationConditionAllowedIncubators, incompatibleIncubators],
			(* If IC-allowed incubators contain any of the incubators found that can be used with some setting changes, suggest this one *)
			Cases[incubatorChangesTuples, {ObjectP[specifiedIncubationConditionAllowedIncubators], _}],
			{}
		];
		(* Calculate top-N minimal changes required incubator tuples *)
		minimalChangesIncompatibleIncubators =  MinimalBy[incubatorChangesTuples, Length[Last[#]]&, UpTo[numberOfExamples]];

		(* Return tuples selectively *)
		Which[
			Length[incubationConditionAllowedIncubatorChangesTuples] > 0,
			(* If specified incubation conditions has incubators available, return that tuples, otherwise return the minimal changes ones *)
				incubationConditionAllowedIncubatorChangesTuples,
			(* We dont have incubation condition allowed incubator but we did get a valid incubation condition symbol, then return the minimal changes ones but append a change of incubation condition tuple to each *)
			!NullQ[specifiedIncubationConditionSymbol],
				{#[[1]], Prepend[#[[2]], {IncubationCondition, incubatorIncubationConditionLookup[#[[1]]]}]}& /@ minimalChangesIncompatibleIncubators,
			(* Otherwise return the minimal changes ones untouched *)
			True,
				minimalChangesIncompatibleIncubators
		]
	];
	(* Define a local helper core that takes an incubator model packet and a list of incubation settings, to generate a list of settings that made using this incubator impossible *)
	whyCantIPickThisIncubator[potentialIncubatorPacket: PacketP[Model[Instrument,Incubator]], incubationSettings:{(_Rule)...}] := Module[
		{optionsWithDefault, defaultRules, optionsWithRange, rangeRules},
		(*Corresponding incubation setting option with field name in incubator model packet *)
		optionsWithDefault = {
			Preparation -> Mode,
			ShakingRadius -> ShakingRadius,
			CarbonDioxide -> DefaultCarbonDioxide,
			Temperature -> DefaultTemperature,
			RelativeHumidity -> DefaultRelativeHumidity,
			ShakingRate -> DefaultShakingRate
		};
		optionsWithRange = {
			CarbonDioxide -> {MinCarbonDioxide, MaxCarbonDioxide},
			Temperature -> {MinTemperature, MaxTemperature},
			RelativeHumidity -> {MinRelativeHumidity, MaxRelativeHumidity},
			ShakingRate -> {MinShakingRate, MaxShakingRate}
		};
		(* For options with possible default, look up their default values and build a rules list *)
		defaultRules =  MapThread[
			Function[{option, default},
				option -> default
			],
			{
				Keys[optionsWithDefault],
				Lookup[potentialIncubatorPacket, Values[optionsWithDefault]]
			}
		];
		(* For options with possible range, look up their range and build a rules list *)
		rangeRules = MapThread[
			Function[{option, lowerLimit, upperLimit},
				option -> {lowerLimit, upperLimit}
			],
			{
				Keys[optionsWithRange],
				Lookup[potentialIncubatorPacket, Values[optionsWithRange][[All,1]]],
				Lookup[potentialIncubatorPacket, Values[optionsWithRange][[All,2]]]
			}
		];

		(* If the given value is not supported, return the key and supported value or range *)
		KeyValueMap[
			Function[{key, value},
				Switch[key,
					(* Preparation has to match exactly with incubator mode *)
					Preparation,
					If[MatchQ[Lookup[defaultRules, key], value],
						Nothing,
						(* Does not match, output*)
						{key, Lookup[defaultRules, key]}
					],
					ShakingRadius,
					(* ShakingRadius also has to exactly match but need to use EqualQ when it is a quantity *)
					If[Or[
						(* Both null is okay*)
						NullQ[Lookup[defaultRules, key]] && NullQ[value],
						(* Both quantity and they equal *)
						And[
							MatchQ[value, _Quantity],
							MatchQ[Lookup[defaultRules, key], _Quantity],
							EqualQ[Lookup[defaultRules, key], value]
						]
					],
						Nothing,
						(* Does not match, output*)
						{key, Lookup[defaultRules, key]}
					],

					(* These two can have Ambient and that is okay with instrument having a range or not *)
					Alternatives[CarbonDioxide, RelativeHumidity],
					Module[{incubatorDefault, incubatorRange},
						incubatorDefault = Lookup[defaultRules, key];
						incubatorRange = Lookup[rangeRules, key];
						Which[
							(* Incubator does not have ability to adjust, specified value cannot be non-ambient *)
							And[
								NullQ[incubatorDefault] || And[
									(* CarbonDioxide might be stored as 0% in incubator model. This is also effectively Null for CO2 *)
									MatchQ[key, CarbonDioxide],
									MatchQ[incubatorDefault, EqualP[0 Percent]]
								],
								MatchQ[incubatorRange, {Null, Null}] || MatchQ[incubatorRange, {EqualP[0 Percent], EqualP[0 Percent]}],
								MatchQ[value, Except[Ambient]]
							],
							{key, Ambient},

							(* Incubator has a default but it does not match the value or is ambient *)
							And[
								MatchQ[incubatorDefault, _Quantity],
								GreaterQ[incubatorDefault, 0 Percent],
								Or[
									MatchQ[value, Ambient],
									MatchQ[value, _Quantity] && !EqualQ[incubatorDefault, value]
								]
							],
							{key, incubatorDefault},
							(* Incubator has a valid range but the specified quantity is not in it*)
							(* Note that for incubators support a range of CO2 and RH, it is okay to say Ambient. We just turn off their controls.*)
							And[
								MatchQ[incubatorRange, {_Quantity, _Quantity}],
								MatchQ[value, _Quantity],
								!MatchQ[value, RangeP[Sequence@@incubatorRange]]
							],
							{key, incubatorRange},
							True,
							Nothing
						]
					],
					(* Shake is a bit weird, it is not a field in incubator packet. For default incubators, if ShakingRate is populated, Shake has to be True, otherwise Shake has to be False. For custom incubators, the ShakingRate is a range, but can be turned off, so shake can be anything. *)
					Shake,
					Module[{incubatorDefaultShakingRate, incubatorDefaultShakingRadius},
						incubatorDefaultShakingRate = Lookup[defaultRules, ShakingRate];
						incubatorDefaultShakingRadius = Lookup[defaultRules, ShakingRadius];
						Which[
							(* This is a default non-shaking incubator, but Shake is set to True *)
							And[
								NullQ[incubatorDefaultShakingRadius],
								TrueQ[value]
							],
							{key, False},
							(* This is a default shaking incubator, but Shake is set to False *)
							And[
								MatchQ[incubatorDefaultShakingRate, _Quantity],
								!TrueQ[value]
							],
							{key, True},
							True,
							Nothing
						]
					],
					Alternatives[ShakingRate, Temperature],
					Module[{incubatorDefault, incubatorRange},
						incubatorDefault = Lookup[defaultRules, key];
						incubatorRange = Lookup[rangeRules, key];
						Which[
							(* Incubator does not shake but shaking rate is specified to other than Null. This not applicable to Temperature *)
							And[
								NullQ[incubatorDefault],
								MatchQ[incubatorRange, {Null, Null}],
								MatchQ[value, Except[Null]]
							],
							{key, Null},
							(* Incubator has a default but it does not match the value or is Null *)
							And[
								MatchQ[incubatorDefault, _Quantity],
								Or[
									MatchQ[value, Null],
									MatchQ[value, _Quantity] && !EqualQ[incubatorDefault, value]
								]
							],
							{key, incubatorDefault},
							(* Incubator has a valid range but it does not fall in *)
							And[
								MatchQ[incubatorRange, {_Quantity, _Quantity}],
								MatchQ[value, _Quantity],
								!MatchQ[value, RangeP[Sequence@@incubatorRange]]
							],
							{key, incubatorRange},
							True,
							Nothing
						]
					],
					(* Shake is conflict is checked in ConflictingShakingConditions*)
					_,
					Nothing
				]
			],
			Association[incubationSettings]
		]
	];

	(* Define a local helper core that takes an incubation condition model packet and a list of incubation settings, to generate a list of settings that made using this incubator impossible *)
	(* This is a much simpler helper than whyCantIPickThisIncubator as the keys are named the same, and there is no "range", if there's a value in the packet, it has to match *)
	whyCantIPickThisIncubationCondition[incubationConditionPacket: PacketP[Model[StorageCondition]], incubationSettings:{(_Rule)...}] := KeyValueMap[
		Function[{key, value},
			Module[{incubationConditionValue},
				(* Get the value for the key from the incubation condition packet *)
				incubationConditionValue =Which[
					MatchQ[key, Shake],
					(* Shake is kind of special because it is not a key in the incubation condition, but is inferrable *)
						MatchQ[Lookup[incubationConditionPacket, ShakingRate], _Quantity],
					MatchQ[key, CarbonDioxide|RelativeHumidity],
					(* No-nothing value for CO2 and RH are Ambient *)
						Lookup[incubationConditionPacket, key, Ambient],
					True,
						Lookup[incubationConditionPacket, key, Null]
				];

				(* Compare and return if conflict is detected *)
				If[
					Or[
						(* Both Boolean and they match *)
						MatchQ[incubationConditionValue, value],
						(* Both null is okay*)
						MatchQ[incubationConditionValue, Null|Ambient] && MatchQ[value, Null|Ambient],
						(* Both quantity and they equal *)
						And[
							MatchQ[value, _Quantity],
							MatchQ[incubationConditionValue, _Quantity],
							EqualQ[incubationConditionValue, value]
						]
					],
					Nothing,
					(* Does not match, output*)
					{key, incubationConditionValue}
				]
			]
		],
		Association[incubationSettings]
	];

	(* Define a local helper to build sentence that contains suggestions to change the settings for failure mode 3 *)
	suggestSettingChangesForIncubators[settingChangeIncubators: {ObjectP[]..}, settingChangeTuples:{{{_Symbol,_}..}..}] := joinClauses[
		MapThread[
			Function[{incubator, changeTuples},
				StringJoin[
					joinClauses[
						Map[
							Function[changeTuple,
								StringJoin[
									"set ",
									(* what option *)
									ToString[changeTuple[[1]]],
									If[MatchQ[changeTuple[[2]], _List],
										(* It has a range that fitting there is okay *)
										" to between " <> ToString[changeTuple[[2, 1]]] <> " and " <> ToString[changeTuple[[2, 2]]],
										(* It has a single default value that has to match *)
										" to " <> ToString[changeTuple[[2]]]
									]
								]
							],
							changeTuples
						],
						ConjunctionWord -> "and"
					],
					" in order to use ",
					ObjectToString[incubator, Cache -> cacheBall, Simulation -> simulation]
				]
			],
			{settingChangeIncubators, settingChangeTuples}
		],
		ConjunctionWord -> "or"
	];
	(* Overload for 1 set of incubator and change tuples, to be used for ConflictingIncubatorWithSettings*)
	suggestSettingChangesForIncubators[settingChangeIncubators_String, settingChangeTuples:{{_Symbol,_}..}] := StringJoin[
		joinClauses[
			Map[
				Function[changeTuple,
					StringJoin[
						"set ",
						(* what option *)
						ToString[changeTuple[[1]]],
						If[MatchQ[changeTuple[[2]], _List],
							(* It has a range that fitting there is okay *)
							" to between " <> ToString[changeTuple[[2, 1]]] <> " and " <> ToString[changeTuple[[2, 2]]],
							(* It has a single default value that has to match *)
							" to " <> ToString[changeTuple[[2]]]
						]
					]
				],
				settingChangeTuples
			],
			ConjunctionWord -> "and"
		],
		" in order to use ",
		settingChangeIncubators
	];
	(* Overload for 1 set of incubation condition and change tuples, to be used for ConflictingIncubationConditionWithSettings (in a slightly different way from the above that we are acturally explaning what the set IC supports) *)
	suggestSettingChangesForIncubators[settingChangeIncubationCondition: Alternatives[Custom, Sequence@@incubationConditionSymbols, ObjectP[Model[StorageCondition]]], settingChangeTuples:{{_Symbol,_}..}] := StringJoin[
		(* The specified IncubationCondition *)
		If[MatchQ[settingChangeIncubationCondition, ObjectP[]],
			ObjectToString[settingChangeIncubationCondition, Cache -> cacheBall, Simulation -> simulation],
			ToString[settingChangeIncubationCondition]
		],
		" requires ",
		joinClauses[
			Map[
				Function[changeTuple,
					StringJoin[
						ToString[changeTuple[[1]]],
						" to be ",
						(* what option *)
						If[MatchQ[changeTuple[[2]], _List],
							(* It has a range that fitting there is okay *)
							"between " <> ToString[changeTuple[[2, 1]]] <> " and " <> ToString[changeTuple[[2, 2]]],
							(* It has a single default value that has to match *)
							ToString[changeTuple[[2]]]
						]
					]
				],
				settingChangeTuples
			],
			ConjunctionWord -> "and"
		]
	];

	(*------------------------ End of Local helpers for incubator error checking --------------------------*)

	(* Error checking against specified IncubationCondition, mirroring IncubatorIsIncompatibleXX *)

	(* Note that IncubationConditionIsIncompatibleXX error checks need to happen before NoCompatibleIncubatorsXX because it is possible that some specified settings are grabbed from the specified incubation condition, which is a valid cell incubation one  but just incompatible with the sample. In that case we only wants to throw the error about incubation condition is incompatible, is it therefore implied there's no incubator for that sample. *)

	(* Is the container itself generally incubator-compatible? *)
	containerCompatibleWithIncubatorsQs = MemberQ[allCellIncubationContainersSearch["Memoization"], ObjectP[#]]& /@ sampleContainerModels;
	(* A list of invalid input to capture all post tier-1 cases when the container is also generally bad. *)
	additionalIncubatorCompatibilityInvalidInputs = PickList[mySamples, containerCompatibleWithIncubatorsQs, False];

	(* Get unique specified incubation conditions *)
	specifiedIncubationConditions = Lookup[mapThreadFriendlyOptions, IncubationCondition];
	uniqueSpecifiedIncubationConditions = DeleteDuplicates@Cases[specifiedIncubationConditions, Except[Custom | Automatic]];


	(* Local helper to get compatible container footprint from a incubation condition symbol *)
	incubationConditionAllowedFootprints[incubationConditionSymbol: Alternatives[Custom, Sequence@@incubationConditionSymbols]] := DeleteDuplicates@Flatten[
		Map[
			Function[compatibleIncubator,
				(* Lookup the allowed footprints in each incubator *)
				Keys[Lookup[$CellIncubatorMaxCapacity, compatibleIncubator]]
			],
			Lookup[incubationConditionIncubatorLookup, incubationConditionSymbol]
		]
	];

	(* The big MapThread below goes through the similar 2 tiers described in IncubatorIsIncompatibleXX and builds associations of info for different incubation-condition-is-incompatible errors generated for each sample *)
	(* Each association contains the following Keys *)
	(* -ErrorName- the name of the error it triggers: "IncubationConditionIsIncompatible" | "ConflictingIncubationConditionWithSettings" *)
	(* -Sample- the sample for this info association: ObjectP[Object[Sample]] *)
	(* -SpecifiedIncubationCondition- the Model or symbol of specified incubation condition for this sample: ObjectP[Model[StorageCondition]] | StorageConditionP *)
	(* -SampleCompatibilityPair- (only for IncubationConditionIsIncompatible) a list of conflicting pair of container footprints and cell type allowed by specified incubator v.s. determined for the sample: {{allowedFootprints, sampleContainerFootprint}|{Null, Null},{allowedCellType, resolvedCellType}|{Null, Null}}*)
	(* -PossibleIncubationConditions- (only for IncubationConditionIsIncompatible) a list of incubation conditions allowing the specified options and cell type *)
	(* -ConflictingOptionKeys- (only for ConflictingIncubationConditionWithSettings) which of the incubationConditionOptions the user specified that is not allowed by the specified incubator: Alternatives[Temperature, CarbonDioxide, RelativeHumidity, Shake, ShakingRadius, ShakingRate] *)
	(* -ChangeTuples- (only for ConflictingIncubationConditionWithSettings) a list of required option changes to use the specified incubationCondition: {{optionKey, desiredValue}..} *)

	incubationConditionIsIncompatibleAssocs = MapThread[
		Function[
			{
				mySample,
				sampleContainerFootprint,
				containerCompatibleWithIncubatorsQ,
				specifiedIncubationCondition,
				cellType,
				unresolvedIncubationOptions,
				conflictingCellTypeWithIncubationConditionWarning,
				validSampleCellTypeQ,
				invalidIncubationConditionError
			},

			If[And[
				MatchQ[specifiedIncubationCondition, Alternatives[Sequence@@incubationConditionSymbols, ObjectP[Model[StorageCondition]]]],
				!TrueQ[invalidIncubationConditionError]
			],
				(* Only enters module when there is non-custom specified incubationCondition and we do not already know it is a storage condition invalid as an incubation condition *)
				Module[
					{
						specifiedIncubationConditionSymbol, allIncubationConditionPackets, specifiedIncubationConditionPacket,
						sampleCompatibleIncubationConditions, conflictsWithAllIncubationConditions, allowedIncubationConditions,
						conflictsWithSpecifiedIncubationCondition, incubationConditionAllowedCellType, specifiedIncubationConditionAllowedFootprints,
						sampleCompatibilityPairs, invalidSampleCompatibilityPairs
					},

					(* If the incubator is specified to be an object, get its model, otherwise leave as it is *)
					specifiedIncubationConditionSymbol = incubationConditionModelToSymbol[specifiedIncubationCondition];

					(* Grab all the Model[StorageCondition] packets from the symbols *)
					allIncubationConditionPackets = FirstCase[storageConditionPackets, KeyValuePattern[StorageCondition -> #]]& /@ incubationConditionSymbols;
					(* If the incubator is specified to be an object, get its model, otherwise leave as it is *)
					specifiedIncubationConditionPacket = FirstCase[allIncubationConditionPackets, KeyValuePattern[StorageCondition -> specifiedIncubationConditionSymbol]];
					(* Screen all incubation conditions based on cell type and allowed container footprint *)
					sampleCompatibleIncubationConditions = Lookup[
						Select[
							allIncubationConditionPackets,
							And[
								MatchQ[Lookup[#, CellType], cellType],
								MemberQ[incubationConditionAllowedFootprints[Lookup[#, StorageCondition]], sampleContainerFootprint]
							]&
						],
						StorageCondition,
						{}
					];

					(* Call the helper to get a list of conflicts *)
					conflictsWithAllIncubationConditions = whyCantIPickThisIncubationCondition[#, unresolvedIncubationOptions]& /@ allIncubationConditionPackets;

					(* check conflict with specified incubation condition *)
					conflictsWithSpecifiedIncubationCondition = First[PickList[conflictsWithAllIncubationConditions, incubationConditionSymbols, specifiedIncubationConditionSymbol]];

					(* See what containers and cell type are allowed by the specified incubation condition *)
					incubationConditionAllowedCellType = Lookup[specifiedIncubationConditionPacket, CellType];
					specifiedIncubationConditionAllowedFootprints = incubationConditionAllowedFootprints[specifiedIncubationConditionSymbol];

					(* compare footprints and cell type compatibilities and construct a list  *)
					sampleCompatibilityPairs = MapThread[
						Function[{allowedValues, currentValue},
							If[MemberQ[ToList[allowedValues], currentValue],
								(* If the value is allowed, null it *)
								{Null, Null},
								{allowedValues, currentValue}
							]
						],
						{
							{specifiedIncubationConditionAllowedFootprints, incubationConditionAllowedCellType},
							{sampleContainerFootprint, cellType}
						}
					];

					(* In addition to if the value is allowed by the incubator, also check if it is resolved to a default or checked in other higher level "invalid" errors so that we do not throw this error about it *)
					invalidSampleCompatibilityPairs = {
						(* Container compatibility *)
						(*  If any of the non-discarded sample is not in a totally invalid container but the container footprint does not fit *)
						If[Or[
							!containerCompatibleWithIncubatorsQ,
							MatchQ[mySample, ObjectP[discardedInvalidInputs]]
						],
							{Null, Null},
							sampleCompatibilityPairs[[1]]
						],
						(* If the cell type is not allowed and it is not the warning-only case, i.e. yeast v.s. Bacterial *)
						If[conflictingCellTypeWithIncubationConditionWarning || !validSampleCellTypeQ,
							{Null, Null},
							sampleCompatibilityPairs[[2]]
						]
					};


					(* Find one that is compatible with the sample (container footprint and cell type) and settings *)
					allowedIncubationConditions = Intersection[
						sampleCompatibleIncubationConditions,
						PickList[incubationConditionSymbols, conflictsWithAllIncubationConditions, {}]
					];

					(* Check through the tiers *)
					Which[
						(* Tier 1: if any of the footprint and cell type is incompatible but have not triggered higher level message *)
						!MatchQ[invalidSampleCompatibilityPairs, {{Null, Null}..}],
						(* Return the tier 1 assoc *)
						<|
							ErrorName -> "IncubationConditionIsIncompatible",
							Sample -> mySample,
							SpecifiedIncubationCondition -> specifiedIncubationCondition,
							SampleCompatibilityPairs -> invalidSampleCompatibilityPairs,
							PossibleIncubationConditions -> Join[
								allowedIncubationConditions,
								(* Add Custom if it qualifies for the container *)
								{
									If[MemberQ[incubationConditionAllowedFootprints[Custom], sampleContainerFootprint],
										Custom,
										Nothing
									]
								}
							]
						|>,
						(* Tier 2 *)
						Length[conflictsWithSpecifiedIncubationCondition] > 0,
						(* Return the tier 2 assoc *)
						<|
							ErrorName -> "ConflictingIncubationConditionWithSettings",
							Sample -> mySample,
							SpecifiedIncubationCondition -> specifiedIncubationCondition,
							ConflictingOptionKeys -> Intersection[Keys[unresolvedIncubationOptions], conflictsWithSpecifiedIncubationCondition[[All, 1]]],
							ChangeTuples -> conflictsWithSpecifiedIncubationCondition,
							PossibleIncubationConditions -> Join[
								allowedIncubationConditions,
								(* Add Custom if it qualifies for the container *)
								{
									If[MemberQ[incubationConditionAllowedFootprints[Custom], sampleContainerFootprint],
										Custom,
										Nothing
									]
								}
							]
						|>,
						True,
						Nothing
					]
				],
				Nothing
			]
		],
		{
			mySamples,
			sampleContainerFootprints,
			containerCompatibleWithIncubatorsQs,
			specifiedIncubationConditions,
			cellTypes,
			specifiedIncubationSettings,
			conflictingCellTypeWithIncubationConditionWarnings,
			validCellTypeQs,
			invalidIncubationConditionErrors
		}
	];

	(* Group by error mode and suggestions *)
	groupedIncubationConditionIsIncompatibleAssocs = GroupBy[incubationConditionIsIncompatibleAssocs, Lookup[#, ErrorName]&];

	(* Construct message for tier-1 IncubationConditionIsIncompatible *)
	incubationConditionIsIncompatibleUseAlternativesAssocs = Lookup[groupedIncubationConditionIsIncompatibleAssocs, "IncubationConditionIsIncompatible", {}];

	incubationConditionIsIncompatibleUseAlternativesInvalidOptions = If[Length[incubationConditionIsIncompatibleUseAlternativesAssocs] > 0 && !gatherTests,
		Module[
			{
				uniqueIncompatibleSpecifiedIncubationConditions, cellTypeFailureSamples,
				captureSentence, firstClauseGroups, firstClause, secondClause, secondClauseGroups,
				invalidSamples, invalidIncubationConditions, sampleCompatibilityPairs, compatibleIncubationConditions
			},

			(* Pull samples and additional info from the associations *)
			{invalidSamples, invalidIncubationConditions, sampleCompatibilityPairs, compatibleIncubationConditions} = Transpose@Lookup[
				incubationConditionIsIncompatibleUseAlternativesAssocs,
				{Sample, SpecifiedIncubationCondition, SampleCompatibilityPairs, PossibleIncubationConditions}
			];
			(* Get unique incubation conditions that fail this way *)
			uniqueIncompatibleSpecifiedIncubationConditions = DeleteDuplicates[invalidIncubationConditions];
			(* samples that fails due to resolved cell types *)
			cellTypeFailureSamples = PickList[invalidSamples, sampleCompatibilityPairs[[All, 2]], Except[ListableP[{Null, Null}]]];

			(* Capture sentence that does not have details *)
			captureSentence = StringJoin[
				Which[
					(* We only have 1 incubation condition in the call*)
					Length[uniqueSpecifiedIncubationConditions] == 1,
						"The specified IncubationCondition is ",
					(* We have more than 1 incubation condition in the call and all are invalid *)
					Length[uniqueSpecifiedIncubationConditions] == Length[uniqueIncompatibleSpecifiedIncubationConditions],
						"The specified IncubationCondition are ",
					(* Only one incubation condition among all specified is invalid *)
					Length[invalidSamples] == 1,
						"A specified IncubationCondition is ",
					True,
						"Some specified IncubationCondition are "
				],
				"incompatible with ",
				joinClauses[
					{
						If[MatchQ[sampleCompatibilityPairs[[All,1]], ListableP[{Null, Null}]],
							Nothing,
							"the container"
						],
						Which[
							MatchQ[sampleCompatibilityPairs[[All, 2]], ListableP[{Null, Null}]],
								Nothing,
							(* There are samples failing due to cell type, was it specified or detected? *)
							MemberQ[PickList[specifiedConflictingCellTypeQs, mySamples, ObjectP[cellTypeFailureSamples]], True],
								"the specified CellType",
							(* Otherwise the failing cell type was either not specified or specified consistent with sample, no need to make the distinction *)
							True,
								"the CellType"
						]
					}
				],
				" for ",
				Which[
					(* We only have 1 sample in the call*)
					Length[mySamples] == 1,
						"the sample.",
					(* We have more than 1 sample in the call and all are invalid *)
					Length[mySamples] == Length[invalidSamples],
						"the samples.",
					(* Only one sample among all input is invalid *)
					Length[invalidSamples] == 1,
						"one of the input samples.",
					True,
						"some of the input samples."
				]
			];

			(* FirstClause says whats wrong: Specified xx *)
			firstClauseGroups = GroupBy[Transpose[{invalidSamples, sampleCompatibilityPairs, invalidIncubationConditions}], Last];
			firstClause = If[Length[Keys[firstClauseGroups]] > $MaxNumberOfErrorDetails,
				StringJoin[
					"Please check Figure 3.1 in the \"Experiment Options\" section of the ExperimentIncubateCells helpfile for the allowed samples and the \"Instrumentation\" section for the allowed containers for ",
					If[
						(* Multiple incubators triggered*)
						Length[invalidIncubationConditions] == Length[specifiedIncubationConditions],
						"each of the specified IncubationCondition",
						(* There are part(s) of all specified incubators that needed checking *)
						True,
						"the specified IncubationCondition " <> joinClauses[
							If[MatchQ[#, ObjectP[]],
								ObjectToString[#, Cache -> cacheBall, Simulation -> simulation],
								ToString[#]
							]& /@ invalidIncubationConditions
						]
					],
					". "
				],
				StringJoin @@ KeyValueMap[
					Function[{specifiedIncubationCondition, sampleCompatibilityConditionTuple},
						StringJoin[
							If[MatchQ[specifiedIncubationCondition, ObjectP[]],
								ObjectToString[specifiedIncubationCondition, Cache -> cacheBall, Simulation -> simulation],
								ToString[specifiedIncubationCondition]
							],
							" ",
							(* The specified condition allows.. *)
							joinClauses[{
								(* container footprint *)
								If[MatchQ[sampleCompatibilityConditionTuple[[All, 2, 1]], ListableP[{Null, Null}]],
									Nothing,
									StringJoin[
										"supports containers with a ",
										joinClauses[
											Flatten[
												(* Remove those with compatible footprints*)
												DeleteCases[sampleCompatibilityConditionTuple[[All, 2, 1, 1]], Null]
											]
										],
										" Footprint"
									]
								],
								(* cell type *)
								If[MatchQ[sampleCompatibilityConditionTuple[[All, 2, 2]], ListableP[{Null, Null}]],
									Nothing,
									StringJoin[
										"allows ",
										joinClauses[
											Flatten[
												DeleteCases[sampleCompatibilityConditionTuple[[All, 2, 2, 1]], Null
												]
											]
										],
										" cells"
									]
								]}
							],
							" but ",
							(* But the sample .. *)
							joinClauses[{
								(* container footprint *)
								If[MatchQ[sampleCompatibilityConditionTuple[[All, 2, 1]], ListableP[{Null, Null}]],
									Nothing,
									Module[{invalidContainerSamples, invalidContainers},
										(* Pick the samples that fails because of the container is not allowed. We need this because it is possible that a sample only fails because of cell type *)
										invalidContainerSamples = PickList[
											(* samples *)
											sampleCompatibilityConditionTuple[[All, 1]],
											(* corresponding container compatibility tuple*)
											sampleCompatibilityConditionTuple[[All, 2, 1]],
											Except[{Null, Null}]
										];
										invalidContainers = Flatten[DeleteCases[sampleCompatibilityConditionTuple[[All, 2, 1, 2]], Null]];
										(* Write the string *)
										StringJoin[
											Which[
												(* We only have 1 sample in the call*)
												Length[mySamples] == 1,
													"the sample container has ",
												(* We have more than 1 sample in the call and all are invalid this way *)
												Length[mySamples] == Length[invalidContainerSamples],
													"the samples containers have ",
												(* We have part of the input samples failing this way, need to point out which object(s) *)
												Length[invalidContainerSamples] == 1,
													"the container of " <> samplesForMessages[invalidContainerSamples, Cache -> cacheBall, Simulation -> simulation] <> " has ",
												True,
													"the containers of " <> samplesForMessages[invalidContainerSamples, Cache -> cacheBall, Simulation -> simulation] <> " have "
											],
											"a Footprint of ",
											joinClauses[invalidContainers]
										]
									]
								],
								(* cell type *)
								If[MatchQ[sampleCompatibilityConditionTuple[[All, 2, 2]], ListableP[{Null, Null}]],
									Nothing,
									Module[{conflictingCellTypeSamples, invalidCellTypes, invalidCellTypeWasSpecifiedQs},
										(* Pick the samples that fails because of the cell type is not allowed. We need this because it is possible that a sample only fails because of container *)
										conflictingCellTypeSamples = PickList[
											(* samples *)
											sampleCompatibilityConditionTuple[[All, 1]],
											(* corresponding cell type compatibility tuple*)
											sampleCompatibilityConditionTuple[[All, 2, 2]],
											Except[{Null, Null}]
										];
										invalidCellTypes = Flatten[DeleteCases[sampleCompatibilityConditionTuple[[All, 2, 2, 2]], Null]];
										invalidCellTypeWasSpecifiedQs = PickList[specifiedConflictingCellTypeQs, mySamples, ObjectP[conflictingCellTypeSamples]];
										(* Write the string *)
										StringJoin[
											Which[
												(* We only have 1 sample in the call*)
												Length[mySamples] == 1,
													"the sample is ",
												(* We have more than 1 sample in the call and all are invalid this way *)
												Length[mySamples] == Length[conflictingCellTypeSamples],
													"all samples are ",
												(* same set of samples already spelled out in container one above *)
												Length[conflictingCellTypeSamples] == 1 && !MatchQ[sampleCompatibilityConditionTuple[[All, 2, 1]], ListableP[{Null, Null}]],
													"this sample is ",
												(* We have one of the input samples failing this way, need to point out which object(s) *)
												Length[conflictingCellTypeSamples] == 1,
													samplesForMessages[conflictingCellTypeSamples, Cache -> cacheBall, Simulation -> simulation] <> " is ",
												(* We have some of input samples failing this way but the container one already listed out the samples *)
												!MatchQ[sampleCompatibilityConditionTuple[[All, 2, 1]], ListableP[{Null, Null}]],
													"these samples are ",
												True,
													samplesForMessages[conflictingCellTypeSamples, Cache -> cacheBall, Simulation -> simulation] <> " are "
											],
											If[MemberQ[invalidCellTypeWasSpecifiedQs, True],
												"specified to be ",
												""
											],
											joinClauses[invalidCellTypes]
										]
									]
								]}
							],
							". "
						]
					],
					firstClauseGroups
				]
			];

			(* Second clause gives recommendations *)
			secondClauseGroups = GroupBy[Transpose[{invalidSamples, sampleCompatibilityPairs, compatibleIncubationConditions}], Last];
			secondClause = If[Length[Keys[secondClauseGroups]] > $MaxNumberOfSuggestedActions,
				(* If too many actions, will just use the concluding sentence in the message to suggest change it, since we already point to specific sections in helpfile.*)
				"",
				StringJoin @@ KeyValueMap[
					Function[{compatibleIncubationConditions, sampleCompatibilityAllowedIncubationConditionsTuple},
						If[Length[compatibleIncubationConditions] > 0,
							(* If we have recommendations of IC *)
							StringJoin[
								joinClauses[
									compatibleIncubationConditions,
									ConjunctionWord -> "or"
								],
								" can be used instead for the container ",
								Which[
									MatchQ[sampleCompatibilityAllowedIncubationConditionsTuple[[All, 2, 2]], ListableP[{Null, Null}]],
										"",
									(* There are samples failing due to cell type, was it specified or detected? *)
									MemberQ[PickList[specifiedConflictingCellTypeQs, mySamples, ObjectP[sampleCompatibilityAllowedIncubationConditionsTuple[[All, 1]]]], True],
										"and the specified CellType ",
									(* Otherwise the failing cell type was either not specified or specified consistent with sample, no need to make the distinction *)
									True,
										"and the CellType "
								],
								"of ",
								Which[
									(* A single sample is all we have that triggered this message *)
									Length[invalidSamples] == 1,
										"this sample",
									(* Multiple samples triggered one set of corrective action*)
									Length[sampleCompatibilityAllowedIncubationConditionsTuple[[All, 1]]] == Length[invalidSamples],
										"these samples",
									(* There are multiple recommendations. List them out. *)
									True,
										samplesForMessages[sampleCompatibilityAllowedIncubationConditionsTuple[[All, 1]], Cache -> cacheBall, Simulation -> simulation]
								],
								". "
							],
							(* We do not have any IC that can support the container and condition. Suggest an aliquot to use custom *)
							StringJoin[
								"Please use ExperimentTransfer to transfer ",
								Which[
									(* A single sample is all we have that triggered this message *)
									Length[invalidSamples] == 1,
										"this sample",
									(* Multiple samples triggered one set of corrective action*)
									Length[sampleCompatibilityAllowedIncubationConditionsTuple[[All, 1]]] == Length[invalidSamples],
										"these samples",
									(* There are multiple recommendations. List them out. *)
									True,
										"the sample(s) " <> samplesForMessages[sampleCompatibilityAllowedIncubationConditionsTuple[[All, 1]], Cache -> cacheBall, Simulation -> simulation]
								],
								If[Length[sampleCompatibilityAllowedIncubationConditionsTuple[[All, 1]]] == 1,
									" to a compatible container such as ",
									" to compatible containers such as "
								],
								Module[{samples, resolvedCellTypeForSamples, customIncubatorForICs},
									samples = sampleCompatibilityAllowedIncubationConditionsTuple[[All, 1]];
									resolvedCellTypeForSamples = PickList[cellTypes, mySamples, ObjectP[samples]];
									(* Compile a list of custom incubator to lookup the preferred container to transfer to, depending what cell types these samples were resolved to have. *)
									customIncubatorForICs = {
										If[MemberQ[resolvedCellTypeForSamples, Mammalian],
											(*"Cytomat HERAcell 240i TT 10"*)
											Model[Instrument, Incubator, "id:Z1lqpMGjeKN9"],
											Nothing
										],
										If[MemberQ[resolvedCellTypeForSamples, MicrobialCellTypeP],
											(*"Bactomat HERAcell 240i TT 10 for Bacteria"*)
											Model[Instrument, Incubator, "id:xRO9n3vk1JbO"],
											Nothing
										]
									};
									joinClauses[
										ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@ Lookup[incubatorToPreferredContainerLookup, customIncubatorForICs],
										ConjunctionWord -> "or"
									]
								],
								" in order to use Custom as IncubationCondition. "
							]
						]
					],
					secondClauseGroups
				]
			];
			(* Throw the corresponding error. *)
			Message[Error::IncubationConditionIsIncompatible,
				captureSentence,
				firstClause,
				secondClause
			];
			(* Return our invalid options. *)
			{IncubationCondition}
		],
		(* Return our invalid options. *)
		{}
	];

	(* Create the corresponding test for the invalid options. *)
	incubationConditionIsIncompatibleUseAlternativesTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = DeleteDuplicates[Lookup[incubationConditionIsIncompatibleUseAlternativesAssocs, Sample, {}]];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", has the incubation condition compatible with the sample if specified:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs]>0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", has the incubation condition compatible with the sample if specified:", True, True],
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

	(* Construct message for Tier 2 *)
	conflictingIncubationConditionWithSettingsAssocs = Lookup[groupedIncubationConditionIsIncompatibleAssocs, "ConflictingIncubationConditionWithSettings", {}];

	conflictingIncubationConditionWithSettingsInvalidOptions = If[Length[conflictingIncubationConditionWithSettingsAssocs] > 0 && !gatherTests,
		Module[
			{
				captureSentence, firstClauseGroups, firstClause, secondClause, secondClauseGroups, invalidSamples, invalidIncubationConditions,
				compatibleIncubationConditions, invalidOptionKeys, incubationConditionChangeTuples,uniqueIncompatibleSpecifiedIncubationConditions
			},

			(* Pull samples and additional info from the associations *)
			{invalidSamples, invalidIncubationConditions, invalidOptionKeys, incubationConditionChangeTuples, compatibleIncubationConditions} = Transpose@Lookup[
				conflictingIncubationConditionWithSettingsAssocs,
				{Sample, SpecifiedIncubationCondition, ConflictingOptionKeys, ChangeTuples, PossibleIncubationConditions}
			];
			(* Get unique incubation conditions that fail this way *)
			uniqueIncompatibleSpecifiedIncubationConditions = DeleteDuplicates[invalidIncubationConditions];

			(* Capture sentence that does not have details *)
			captureSentence = StringJoin[
				Which[
					(* We only have 1 incubation condition in the call*)
					Length[uniqueSpecifiedIncubationConditions] == 1,
						"The specified IncubationCondition does ",
					(* We have more than 1 incubation condition in the call and all are invalid *)
					Length[uniqueSpecifiedIncubationConditions] == Length[uniqueIncompatibleSpecifiedIncubationConditions],
						"The specified IncubationCondition do ",
					(* Only one incubation condition among all specified is invalid *)
					Length[invalidSamples] == 1,
						"A specified IncubationCondition does ",
					True,
						"Some specified IncubationCondition do "
				],
				"not support the specified incubation setting(s)",
				Which[
					(* We only have 1 sample in the call, hence one set of incubation settings *)
					Length[mySamples] == 1,
						".",
					(* We have more than 1 sample in the call and all are invalid *)
					Length[mySamples] == Length[invalidSamples],
						" for the samples.",
					(* Only one sample among all input is invalid *)
					Length[invalidSamples] == 1,
						" for one of the input samples.",
					True,
						" for some of the input samples."
				]
			];

			(* FirstClause says whats wrong: sample has specified incubationCondition model of xx. group the tuples based on specified incubationConditions. *)
			firstClauseGroups = GroupBy[Transpose[{invalidSamples, incubationConditionChangeTuples, invalidIncubationConditions}], Last];

			firstClause = If[Length[Keys[firstClauseGroups]] > $MaxNumberOfErrorDetails,
				StringJoin[
					"Please check Figure 3.2 to 3.5 in the \"Experiment Options\" section of the ExperimentIncubateCells helpfile for the allowed incubation settings for ",
					If[(* Multiple incubators triggered*)
						Length[invalidIncubationConditions] == Length[specifiedIncubationConditions],
						"each of the specified IncubationCondition",
						(* There are part(s) of all specified incubators that needed checking *)
						True,
						"the specified IncubationCondition " <> joinClauses[
							If[MatchQ[#, ObjectP[]],
								ObjectToString[#, Cache -> cacheBall, Simulation -> simulation],
								ToString[#]
							]& /@ invalidIncubationConditions
						]
					],
					". "
				],
				StringJoin @@ KeyValueMap[
					Function[{specifiedIncubationCondition, sampleIncubationConditionChangeTuple},
						StringJoin[
							(* No need to do additional capitalization because this starts withe the specified IC *)
							suggestSettingChangesForIncubators[
								specifiedIncubationCondition,
								Flatten[sampleIncubationConditionChangeTuple[[All, 2]], 1]
							],
							Which[
								(* We only have 1 sample in the call*)
								Length[mySamples] == 1,
									"",
								(* We have more than 1 sample in the call and all are invalid this way *)
								Length[mySamples] == Length[sampleIncubationConditionChangeTuple[[All, 1]]],
									" for all samples",
								(* We have part of the input samples failing this way, need to point out which object(s) *)
								True,
									" for " <> samplesForMessages[sampleIncubationConditionChangeTuple[[All, 1]], Cache -> cacheBall, Simulation -> simulation]
							],
							". "
						]
					],
					firstClauseGroups
				]
			];
			(* Second sentence gives suggestion based on what options need to be changed. *)
			secondClauseGroups = GroupBy[Transpose[{invalidSamples, compatibleIncubationConditions, invalidOptionKeys}], Last];
			secondClause = If[Length[Keys[secondClauseGroups]] > $MaxNumberOfSuggestedActions,
				StringJoin[
					"Please update the ",
					joinClauses[Flatten[invalidOptionKeys]],
					" settings accordingly for ",
					samplesForMessages[invalidSamples, mySamples, Cache -> cacheBall, Simulation -> simulation],
					", or set an alternative IncubationCondition for these samples. "
				],
				StringJoin @@ KeyValueMap[
					Function[{optionKeys, sampleKeyCompatibleICsTuple},
						StringJoin[
							Which[
								(* A single sample is all we have that triggered this message *)
								Length[invalidSamples] == 1,
									"Please ",
								(* Multiple samples triggered one set of corrective action*)
								Length[sampleKeyCompatibleICsTuple[[All, 1]]] == Length[invalidSamples],
									"Please ",
								(* There are multiple recommendations. List them out. *)
								True,
									"For " <> samplesForMessages[sampleKeyCompatibleICsTuple[[All, 1]], Cache -> cacheBall, Simulation -> simulation] <> ", please "
							],
							"update the ",
							joinClauses[optionKeys],
							pluralize[optionKeys, " setting", " settings"],
							(* If we have compatible IC recommendation, also list them out *)
							If[MatchQ[sampleKeyCompatibleICsTuple[[All, 2]], {{}..}],
								". ",
								StringJoin[
									", or alternatively set IncubationCondition to ",
									joinClauses[Flatten[sampleKeyCompatibleICsTuple[[All, 2]]], ConjunctionWord -> "or"],
									". "
								]
							]
						]
					],
					secondClauseGroups
				]
			];
			(* Throw the corresponding error. *)
			Message[Error::ConflictingIncubationConditionWithSettings,
				captureSentence, firstClause, secondClause
			];
			(* Return our invalid options. *)
			{IncubationCondition}
		],
		{}
	];

	(* Create the corresponding test for the invalid options. *)
	conflictingIncubationConditionWithSettingsTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = DeleteDuplicates[Lookup[conflictingIncubationConditionWithSettingsAssocs, Sample, {}]];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", has the incubationCondition compatible with the incubation condition options if specified:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs]>0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", has the incubationCondition compatible with the incubation condition options if specified:", True, True],
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

	(* Construct a list of whether the samples have triggered any IncubationConditionIsIncompatibleXX error, to be used in NoCompatibleIncubatorXX error checking below. *)
	incubationConditionIsIncompatibleErrors = MemberQ[Lookup[incubationConditionIsIncompatibleAssocs, Sample, Null], ObjectP[#]]& /@ mySamples;

	(*-- No compatible incubator options error check --*)
	noCompatibleIncubatorErrors = MapThread[
		Function[{
			possibleIncubatorsPerSample, validCellTypeQ, unsupportedCellCultureTypeError,
			incubationConditionIsIncompatibleError, conflictingCultureAdhesionWithContainerError},
			And[
				MatchQ[possibleIncubatorsPerSample, ({}|Null)],
				(* If unsupported cell type or cell culture type is triggered, no compatible incubator is implied. No transfer or change of settings will matter. Do not throw this message. *)
				!TrueQ[unsupportedCellCultureTypeError],
				validCellTypeQ,
				(* We are already throwing IncubationConditionIsIncompatibleXX, we will suggest changes there instead *)
				!TrueQ[incubationConditionIsIncompatibleError],
				(* If ConflictingCultureAdhesionWithContainer (e.g. SolidMedia or Adherent in a plate) is triggered, although we are not gonna be able to find an incubator, the message is already suggesting transfer. so no need to throw this error and recommend the same thing *)
				!TrueQ[conflictingCultureAdhesionWithContainerError],
				(* We are not already throwing conflicting unit operation requirement error *)
				MatchQ[preparationResult, Except[$Failed]]
			]
		],
		{
			possibleIncubators, validCellTypeQs, unsupportedCellCultureTypeErrors,
			incubationConditionIsIncompatibleErrors, conflictingCultureAdhesionWithContainerErrors
		}
	];
	(* shaking conflict is already checked. For the potential incubators search below. *)

	(* If we have any noCompatibleIncubatorError, call IncubateCells devices again to gather a nested list with All container overload to evaluate if an aliquot would lead to any incubator *)
	possibleIncubatorContainers = If[MemberQ[noCompatibleIncubatorErrors, True],
		IncubateCellsDevices[
			All,
			CellType -> cellTypes,
			CultureAdhesion -> cultureAdhesions,
			Temperature -> temperatures,
			CarbonDioxide -> carbonDioxidePercentages,
			RelativeHumidity -> relativeHumidities,
			Shake -> conflictFreeShaking,
			ShakingRate -> conflictFreeShakingRates,
			ShakingRadius -> conflictFreeShakingRadii,
			Preparation -> resolvedPreparation,
			Cache -> cacheBall,
			Simulation -> simulation
		],
		(* Make any list with correct length just so the mapthread below will not crash *)
		ConstantArray[Null, Length[noCompatibleIncubatorErrors]]
	];

	(* If we have any noCompatibleIncubatorError, call IncubateCells devices again to gather a nested list with the sample properties and original container model but no incubation settings *)
	possibleIncubatorsNoSettings = If[MemberQ[noCompatibleIncubatorErrors, True],
		IncubateCellsDevices[
			sampleContainerModels,
			CellType -> cellTypes,
			CultureAdhesion -> cultureAdhesions,
			Cache -> cacheBall,
			Simulation -> simulation
		],
		(* Make any list with correct length just so the mapthread below will not crash *)
		ConstantArray[Null, Length[noCompatibleIncubatorErrors]]
	];
	possibleIncubatorNoSettingPackets = Map[
		fetchPacketFromFastAssoc[#, fastAssoc]&,
		possibleIncubatorsNoSettings,
		{2}
	];

	(* If we have any noCompatibleIncubatorError, call IncubateCells devices again to gather a nested list with All container overload and no incubation settings to evaluate if it leads to any incubator *)
	possibleIncubatorContainersNoSettings = If[MemberQ[noCompatibleIncubatorErrors, True],
		IncubateCellsDevices[
			All,
			CellType -> cellTypes,
			CultureAdhesion -> cultureAdhesions,
			Cache -> cacheBall,
			Simulation -> simulation
		],
		(* Make any list with correct length just so the mapthread below will not crash *)
		ConstantArray[Null, Length[noCompatibleIncubatorErrors]]
	];

	possibleIncubatorContainersNoSettingPackets = Map[
		fetchPacketFromFastAssoc[#[[1]], fastAssoc]&,
		possibleIncubatorContainersNoSettings,
		{2}
	];

	(* If we ended up with any empty list of compatible incubators, we need to do a 4-tiered check to decide what we suggest to the user. *)
	(* Although these will eventually end up in 4 error messages, they are mutually exclusive, so should still be done in a Which call *)
	(* Tier 1 - InvalidCellIncubationContainers: no incubation setting options specified or there are existing conflict in CellType/CultureAdhesion. Error when container footprint is incompatible with any incubator. *)
	(* Tier 2 - NoIncubatorForSettings: there is incubator found with sample in current container, need to change options. And if there is incubator found with given incubation condition options, suggest aliquot.  *)
	(* Tier 3 - NoIncubatorForContainersAndSettings: there is incubator compatible if aliquot and change condition options. Note that this can only be triggered if the container is generally incompatible with any incubator.  *)
	(* (Tier 4 - Catch-All should not get here) *)
	(* Tier 1&3 contribute to InvalidInput *)
	(* Tier 2&3 contribute to InvalidOptions *)
	(* For the nature of the experiment, samples comes first, it makes no sense to suggest an incubator that fulfills all settings without fitting the sample. *)

	(* The big MapThread below goes through the tiers described above and builds associations of info for different no-compatible-incubator errors generated for each sample *)
	(* Each association contains the following Keys *)
	(* -ErrorName- the name of the error it triggers: "InvalidCellIncubationContainers" | "NoIncubatorForSettings" | "NoIncubatorForContainersAndSettings" *)
	(* -Sample- the sample for this info association: ObjectP[Object[Sample]] *)
	(* -ContainerFootprint- the footprint of sample container model: FootprintP *)
	(* -PossibleAliquotIncubators- a list of incubators we recommend found by evaluation of possibleIncubatorContainers or possibleIncubatorContainersNoSettings, which basically calls IncubateCellsDevices[All, ..] overload: {ObjectP[Model[Instrument]]..} *)
	(* -UserSpecifiedOptionKeys- which of the incubationConditionOptions the user specified: Alternatives[Temperature, CarbonDioxide, RelativeHumidity, Shake, ShakingRadius, ShakingRate] *)
	(* -PossibleIncubatorChangeTuples- a list of pairs of incubator we recommend and corresponding required option changes to use the incubator: {{ObjectP[Model[Instrument]], {{optionKey, desiredValueOrRange}..}}..} *)

	(* The resulted tuples have a format of {{groupingCriteria, sample, additionalInfo}..} *)
	noCompatibleIncubatorsInfoAssocs = MapThread[
		Function[{
			mySample, sampleContainerModel, sampleContainerFootprint, containerCompatibleWithIncubatorsQ,
			noCompatibleIncubatorError, incubationConditionIsIncompatibleError, invalidIncubationConditionError, unresolvedIncubationOptions, specifiedIncubator, specifiedIncubationCondition, conflictingCultureAdhesionWithContainerError,
			conflictingCellTypeAdhesionError, possibleIncubatorContainersPerSample, possibleIncubatorsNoSettingsPerSample,
			possibleIncubatorNoSettingPacketsPerSample, possibleIncubatorContainersNoSettingsPerSample,
			possibleIncubatorContainersNoSettingPacketsPerSample, temperature, carbonDioxidePercentage, relativeHumidity,
			shakingRate, shakingRadius
		},
			Which[
				(* If there is any incubator found or higher level messages are thrown, do not throw this message *)
				!TrueQ[noCompatibleIncubatorError],
					Nothing,
				(* Tier 1 InvalidCellIncubationContainers *)
				(* If this conflict is detected, we are not gonna be able to find an incubator for this combination of sample properties anyway. We are going to suggest checking sample properties options there, so here we only check container footprint and incubation settings for the container footprint. *)
				conflictingCellTypeAdhesionError,
					(* If the container footprint is okay, do not throw this error, we do not want to suggest any incubator yet since we limited knowledge of the correct sample properties and which incubator to go to *)
					If[TrueQ[containerCompatibleWithIncubatorsQ],
						Nothing,

						<|
							ErrorName -> "InvalidCellIncubationContainers",
							Sample -> mySample,
							ContainerFootprint -> sampleContainerFootprint,
							PossibleAliquotIncubators -> {}
						|>
					],
				(* Tier 1 InvalidCellIncubationContainers *)
				(* Otherwise we have valid sample properties that should be able to have an incubator without incubation settings, a i.e. combination of CellType + CultureAdhesion with potential aliquots. If no incubation settings is actually given or specified options are okay just need to aliquot, we can suggest specific incubator and aliquot container *)
				And[
					!containerCompatibleWithIncubatorsQ || NullQ[sampleContainerFootprint],
					(* The sample is not already discarded (so as to have a Null container footprint). Note that we do have many container models with a Null footprint *)
					Not[MatchQ[mySample, ObjectP[discardedInvalidInputs]]],
					Length[unresolvedIncubationOptions] == 0 || Length[possibleIncubatorContainersPerSample] > 0
				],
					<|
						ErrorName -> "InvalidCellIncubationContainers",
						Sample -> mySample,
						ContainerFootprint -> sampleContainerFootprint,
						PossibleAliquotIncubators -> possibleIncubatorContainersPerSample[[All, 1]]
					|>,

				(* Tier 2 NoIncubatorForSettings *)
				(* Aliquoting with all settings kept does not lead to any compatible incubator. Generally invalid container is implied. Then we check if losing settings give us any incubators *)
				(* Do not suggest change options here if an incubator is specified *)
				And[
					!MatchQ[specifiedIncubator, ObjectP[]],
					Length[possibleIncubatorsNoSettingsPerSample] > 0,
					Length[unresolvedIncubationOptions] > 0
				],
					(*Yes it does, check the first resulted incubator and give a list of rules that made it impossible to use *)
					Module[{incubatorAndOptionChangeTuples},
						(* Call the local helper to generate tuples of the format {{incubator, {option, suggestedChange}}..} *)
						incubatorAndOptionChangeTuples = whyCantIPickThisIncubator[
							possibleIncubatorNoSettingPacketsPerSample,
							{
								Temperature -> temperature,
								CarbonDioxide -> carbonDioxidePercentage,
								RelativeHumidity -> relativeHumidity,
								ShakingRate -> shakingRate,
								ShakingRadius -> shakingRadius,
								Preparation -> resolvedPreparation
							},
							unresolvedIncubationOptions,
							(* If the specified incubation condition is an invalid one or it is already conflicting with either the cell type, container or options, it is throwing an error, no need to input to the helper *)
							If[invalidIncubationConditionError||incubationConditionIsIncompatibleError,
								Null,
								(* Here we are guaranteed to feed the helper a valid cell incubation one *)
								specifiedIncubationCondition
							],
							3 (* Number of examples generated *)
						];
						(* Return *)
						<|
							ErrorName -> "NoIncubatorForSettings",
							Sample -> mySample,
							ContainerFootprint -> sampleContainerFootprint,
							UserSpecifiedOptionKeys -> Keys[unresolvedIncubationOptions],
							PossibleIncubatorChangeTuples -> incubatorAndOptionChangeTuples,
							PossibleAliquotIncubators -> possibleIncubatorContainersPerSample[[All, 1]]
						|>
					],
				(* Do not suggest change options here if an incubator is specified *)
				And[
					!MatchQ[specifiedIncubator, ObjectP[]],
					!containerCompatibleWithIncubatorsQ || NullQ[sampleContainerFootprint],
					(* The sample is not already discarded (so as to have a Null container footprint). Note that we do have many container models with a Null footprint *)
					Not[MatchQ[mySample, ObjectP[discardedInvalidInputs]]],
					Length[possibleIncubatorContainersNoSettingsPerSample] > 0
				],
					(* Tier 3 NoIncubatorForContainersAndSettings *)
					(* With aliquotting and change some settings we have incubator compatible *)
					Module[{incubatorAndOptionChangeTuples},
						(* Call the local helper to generate tuples of the format {{incubator, {option, suggestedChange}}..} *)
						incubatorAndOptionChangeTuples = whyCantIPickThisIncubator[
							possibleIncubatorContainersNoSettingPacketsPerSample,
							{
								Temperature -> temperature,
								CarbonDioxide -> carbonDioxidePercentage,
								RelativeHumidity -> relativeHumidity,
								ShakingRate -> shakingRate,
								ShakingRadius -> shakingRadius,
								Preparation -> resolvedPreparation
							},
							unresolvedIncubationOptions,
							(* If the specified incubation condition is an invalid one or it is already conflicting with either the cell type, container or options, it is throwing an error, no need to input to the helper *)
							If[invalidIncubationConditionError||incubationConditionIsIncompatibleError,
								Null,
								(* Here we are guaranteed to feed the helper a valid cell incubation one *)
								specifiedIncubationCondition
							],
							1 (* Number of examples generated *)
						];
						(* Return *)
						<|
							ErrorName -> "NoIncubatorForContainersAndSettings",
							Sample -> mySample,
							ContainerFootprint -> sampleContainerFootprint,
							UserSpecifiedOptionKeys -> Keys[unresolvedIncubationOptions],
							PossibleIncubatorChangeTuples -> incubatorAndOptionChangeTuples
						|>
					],
				True,
					(* Should not get here. This would mean we either have a bug that it should have landed in a branch above but it didn't, or we are missing some other error checking *)
					<|
						ErrorName -> Null,
						Sample -> mySample,
						ContainerFootprint -> sampleContainerFootprint
					|>
			]
		],
		{
			mySamples, sampleContainerModels, sampleContainerFootprints, containerCompatibleWithIncubatorsQs,
			noCompatibleIncubatorErrors, incubationConditionIsIncompatibleErrors, invalidIncubationConditionErrors, specifiedIncubationSettingsForNoIncubatorErrors, specifiedIncubators, specifiedIncubationConditions,
			(* Other errors that trigger may failure mode 2*)
			conflictingCultureAdhesionWithContainerErrors, conflictingCellTypeAdhesionErrors,
			(* Results of alternatives IncubateCellsDevices*)
			possibleIncubatorContainers, possibleIncubatorsNoSettings, possibleIncubatorNoSettingPackets, possibleIncubatorContainersNoSettings, possibleIncubatorContainersNoSettingPackets,
			(* Settings *)
			temperatures, carbonDioxidePercentages, relativeHumidities, shakingRates, resolvedShakingRadii
		}
	];
	(* Group by error name *)
	groupedNoCompatibleIncubatorAssocs = GroupBy[noCompatibleIncubatorsInfoAssocs, Lookup[#, ErrorName]&];

	(* Constructing message for Tier 1 - generally bad container not compatible with any incubators *)
	(* Note that this is a much higher level message that is thrown regardless of where the Incubator is specified. We include additional clause if any is specified. *)
	invalidCellIncubationContainersAssocs = Lookup[groupedNoCompatibleIncubatorAssocs, "InvalidCellIncubationContainers", {}];

	invalidCellIncubationContainersInvalidInputs = If[Length[invalidCellIncubationContainersAssocs] > 0 && !gatherTests,
		Module[{invalidSamples, invalidSampleContainerFootprints, invalidSamplePotentialIncubators,
			captureSentence, firstClauseGroups, firstClause, secondClauseGroups, secondClause
		},
			(* Pull samples and additional info from the associations *)
			{invalidSamples, invalidSampleContainerFootprints, invalidSamplePotentialIncubators} = Transpose@Lookup[
				invalidCellIncubationContainersAssocs,
				{Sample, ContainerFootprint, PossibleAliquotIncubators}
			];

			(* Capture sentence that does not have details *)
			captureSentence = Which[
				(* We only have 1 sample in the call*)
				Length[mySamples] == 1,
					"No cell incubator accepts the sample in its current container.",
				(* We have more than 1 sample in the call and all are invalid *)
				Length[mySamples] == Length[invalidSamples],
					"No cell incubator accepts the samples in their current containers.",
				(* Only one sample among all input is invalid *)
				Length[invalidSamples] == 1,
					"No cell incubator accepts one of the input samples in its current container.",
				True,
					"No cell incubator accepts some of the input samples in their current containers."
			];
			(* First clause explains whats wrong. It takes format of Sample xx is in container with footprint xx that is not compatible with any incubator. *)
			firstClauseGroups = GroupBy[Transpose[{invalidSamples, invalidSampleContainerFootprints}], Last];
			(* The reason clause does not get very long even when we have >3 footprints to complain about *)
			firstClause = StringJoin[
				joinClauses[
					KeyValueMap[
						Function[{footprint, sampleFootprintTuple},
							StringJoin[
								Which[
									(* We only have 1 sample in the call*)
									Length[mySamples] == 1,
										"the sample",
									(* We have more than 1 sample in the call and all are invalid this way *)
									Length[mySamples] == Length[sampleFootprintTuple[[All, 1]]],
										"the samples",
									(* We have part of the input samples failing this way, need to point out which object(s) *)
									True,
										samplesForMessages[sampleFootprintTuple[[All, 1]], Cache -> cacheBall, Simulation -> simulation]
								],
								pluralize[sampleFootprintTuple[[All, 1]], " is in a container", " are in containers"],
								" with a ",
								ToString[footprint],
								" Footprint"
							]
						],
						firstClauseGroups
					],
					CaseAdjustment -> True
				],
				If[Length[firstClauseGroups] > 1,
					". These container footprints are not supported by any cell incubator",
					", which is not supported by any cell incubator"
				],
				Switch[Length[allUniqueSpecifiedIncubators],
					1,
					", including the specified incubator " <> joinClauses[
						ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@ allUniqueSpecifiedIncubators,
						ConjunctionWord -> "and"] <> ". ",
					GreaterP[1],
					", including the specified incubators " <> joinClauses[
						ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@ allUniqueSpecifiedIncubators, ConjunctionWord -> "and"
					] <> ". ",
					_,
					". "
				]
			];

			(* Second sentence gives suggestion based on which incubator can be used. *)
			(* For cases when there are other errors with cell type and culture adhesion, we do not recommend aliquot containers. *)
			secondClauseGroups = GroupBy[Transpose[{invalidSamples, invalidSamplePotentialIncubators}], Last];
			secondClause = If[Length[Keys[secondClauseGroups]] > $MaxNumberOfSuggestedActions,
				StringJoin[
					"Please check the \"Preferred Input Container\" section of the ExperimentIncubateCells helpfile for containers accepted by cell incubators, and then use ExperimentTransfer to transfer these samples to compatible containers. "
				],
				StringJoin @@ KeyValueMap[
					Function[{potentialIncubators, samplePotentialIncubatorsTuple},
						StringJoin[
							"Please use ExperimentTransfer to transfer ",
							Which[
								(* A single sample is all we have that triggered this message *)
								Length[invalidSamples] == 1,
									"this sample",
								(* Multiple samples triggered one set of corrective action*)
								Length[samplePotentialIncubatorsTuple[[All, 1]]] == Length[invalidSamples],
									"these samples",
								(* There are multiple recommendations. List them out. *)
								True,
									samplesForMessages[samplePotentialIncubatorsTuple[[All, 1]], Cache -> cacheBall, Simulation -> simulation]
							],
							If[Length[samplePotentialIncubatorsTuple[[All, 1]]] == 1,
								" to a compatible container",
								" to compatible containers"
							],
							If[MatchQ[potentialIncubators, {}],
								". ",
								(* Give recommendations if we have *)
								StringJoin[
									" such as ",
									joinClauses[
										ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@ Lookup[incubatorToPreferredContainerLookup, potentialIncubators],
										ConjunctionWord -> "or"
									],
									" in order to use ",
									joinClauses[
										ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@ potentialIncubators,
										ConjunctionWord -> "or"
									],
									". "
								]
							]
						]
					],
					secondClauseGroups
				]
			];

			(* Throw the corresponding error. *)
			Message[Error::InvalidCellIncubationContainers,
				captureSentence,
				firstClause,
				secondClause
			];

			(* Return our invalid inputs. *)
			invalidSamples
		],
		{}
	];

	(* Create the corresponding test for the invalid options. *)
	invalidCellIncubationContainersTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = DeleteDuplicates[Lookup[invalidCellIncubationContainersAssocs, Sample, {}]];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", are in a valid container for cell incubation:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", are in a valid container for cell incubation:", True, True],
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

	(* Constructing message for Tier 2 - incubator found with changing some incubation options. And suggest aliquot if there any incubator support all specified options *)
	noIncubatorForSettingsAssocs = Lookup[groupedNoCompatibleIncubatorAssocs, "NoIncubatorForSettings", {}];

	noIncubatorForSettingsInvalidOptions = If[Length[noIncubatorForSettingsAssocs] > 0 && !gatherTests,
		(* Throw the corresponding error. *)
		Module[{invalidSamples, invalidSampleContainerFootprints, incubatorChangeTuples, alternativeFirstTwoClauses,
			invalidSampleSpecifiedOptionKeys, invalidSamplePotentialIncubators, captureSentence, firstClauseGroups,
			firstClause, secondClauseGroups, secondClause, thirdClauseGroups, thirdClause},

			(* Pull samples and additional info from the associations *)
			{invalidSamples, invalidSampleContainerFootprints, invalidSampleSpecifiedOptionKeys, incubatorChangeTuples, invalidSamplePotentialIncubators} = Transpose@Lookup[
				noIncubatorForSettingsAssocs,
				{Sample, ContainerFootprint, UserSpecifiedOptionKeys, PossibleIncubatorChangeTuples, PossibleAliquotIncubators}
			];

			(* Capture sentence that does not have details *)
			captureSentence = StringJoin[
				"No cell incubator can simultaneously fit the input sample container(s) and support the specified incubation setting(s)",
				Which[
					(* We only have 1 sample in the call*)
					Length[mySamples] == 1,
						"",
					(* We have more than 1 sample in the call and all are invalid *)
					Length[mySamples] == Length[invalidSamples],
						" for all input samples",
					(* Only one sample among all input is invalid *)
					Length[invalidSamples] == 1,
						" for one of the input samples",
					True,
						" for some of the input samples"
				],
				"."
			];

			(* First clause explains whats wrong. It takes format of Sample xx has specified option(s) of xx, which is/are not compatible with any incubator that support the specified the container footprint of xx.  *)
			(* Grouped by if the same set of options is specified *)
			firstClauseGroups = GroupBy[Transpose[{invalidSamples, invalidSampleContainerFootprints, invalidSampleSpecifiedOptionKeys}], Last];
			firstClause = StringJoin @@ KeyValueMap[
				Function[{specifiedOptionKeys, sampleFootprintOptionsTuple},
					StringJoin[
						Which[
							(* We only have 1 sample in the call*)
							Length[mySamples] == 1,
								"The sample",
							(* We have more than 1 sample in the call and all are invalid this way *)
							Length[mySamples] == Length[sampleFootprintOptionsTuple[[All, 1]]],
								"The samples",
							(* We have part of the input samples failing this way, need to point out which object(s) *)
							True,
								Capitalize @ samplesForMessages[sampleFootprintOptionsTuple[[All, 1]], Cache -> cacheBall, Simulation -> simulation]
						],
						pluralize[sampleFootprintOptionsTuple[[All, 1]], " is in a container", " are in containers"],
						" with a ",
						joinClauses[sampleFootprintOptionsTuple[[All, 2]]],
						" Footprint, which ",
						hasOrHave[sampleFootprintOptionsTuple[[All, 2]]],
						" compatible incubator(s) but they do not support the specified ",
						joinClauses[specifiedOptionKeys],
						" setting(s). "
					]
				],
				firstClauseGroups
			];
			(* Second sentence gives suggestion based on which incubator can be used and what options need to be changed. *)
			secondClauseGroups = GroupBy[Transpose[{invalidSamples, incubatorChangeTuples}], Last];
			secondClause = StringJoin @@ KeyValueMap[
				Function[{incubatorChangeTuples, sampleChangeTuple},
					StringJoin[
						"For ",
						Which[
							(* A single sample is all we have that triggered this message *)
							Length[invalidSamples] == 1,
								"this sample",
							(* Multiple samples triggered one set of corrective action*)
							Length[sampleChangeTuple[[All, 1]]] == Length[invalidSamples],
								"these samples",
							(* There are multiple recommendations. List them out. *)
							True,
								samplesForMessages[sampleChangeTuple[[All, 1]], Cache -> cacheBall, Simulation -> simulation]
						],
						", please ",
						suggestSettingChangesForIncubators[incubatorChangeTuples[[All, 1]], incubatorChangeTuples[[All, 2]]],
						". "
					]
				],
				secondClauseGroups
			];
			(* If either one is longer than the constant, collapse into one *)
			alternativeFirstTwoClauses = If[Or[
				Length[Keys[firstClauseGroups]] > $MaxNumberOfErrorDetails,
				Length[Keys[secondClauseGroups]] > $MaxNumberOfSuggestedActions
			],
				StringJoin[
					"Please check the \"Instrumentation\" section of the ExperimentIncubateCells helpfile for the allowed ",
					joinClauses[Flatten[invalidSampleSpecifiedOptionKeys]],
					" settings for incubators that fit containers with a ",
					joinClauses[invalidSampleContainerFootprints, ConjunctionWord -> "or"],
					" Footprint. Then update the options accordingly for ",
					samplesForMessages[invalidSamples, mySamples, Cache -> cacheBall, Simulation -> simulation],
					". "
				],
				Null
			];
			(* Third clause gives alternative suggestion if aliquot to another container can lead to incubator that can achieve all specified options *)
			thirdClauseGroups = KeyDrop[GroupBy[Transpose[{invalidSamples, invalidSamplePotentialIncubators}], Last], {{}}];
			thirdClause = Which[
				MatchQ[thirdClauseGroups, <||>],
					"",
				Length[Keys[thirdClauseGroups]] > $MaxNumberOfSuggestedActions,
					StringJoin[
						"Alternatively, please check the \"Instrumentation\" section of the ExperimentIncubateCells helpfile for incubators that support the specified options, for example, ",
						joinClauses[
							ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@ Keys[thirdClauseGroups],
							ConjunctionWord -> "or"
						],
						". Then use ExperimentTransfer to transfer ", samplesForMessages[Flatten[Values[thirdClauseGroups][[All,All,1]]], mySamples, Cache -> cacheBall, Simulation -> simulation],
						" to compatible containers. "
					],
				True,
					StringJoin[
						"Alternatively, you can use ExperimentTransfer to ",
						joinClauses[
							KeyValueMap[
								Function[{potentialIncubators, samplePotentialIncubatorsTuple},
									StringJoin[
										Which[
											(* A single sample is all we have that triggered this message *)
											Length[invalidSamples] == 1,
												"transfer this sample",
											(* Multiple samples triggered one set of corrective action*)
											Length[samplePotentialIncubatorsTuple[[All, 1]]] == Length[invalidSamples],
												"transfer these samples",
											(* There are multiple recommendations. List them out. *)
											True,
												"transfer " <> samplesForMessages[samplePotentialIncubatorsTuple[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation]
										],
										If[Length[samplePotentialIncubatorsTuple[[All, 1]]] == 1,
											" to a compatible container such as ",
											" to compatible containers such as "
										],
										joinClauses[
											ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@ Lookup[incubatorToPreferredContainerLookup, potentialIncubators],
											ConjunctionWord -> "or"
										],
										" in order to use ",
										joinClauses[
											ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@ potentialIncubators,
											ConjunctionWord -> "or"
										]
									]
								],
								thirdClauseGroups
							]
						],
						". ",
						"To view complete lists of accepted container models for potential incubators, please use IncubateCellsDevices[All, <myOptions>]. "
					]
			];

			(* Throw the message *)
			Message[Error::NoIncubatorForSettings,
				captureSentence,
				Sequence @@ If[NullQ[alternativeFirstTwoClauses],
					{firstClause, secondClause},
					{"", alternativeFirstTwoClauses}
				],
				thirdClause
			];

			(* Return the combined specified options *)
			invalidSampleSpecifiedOptionKeys
		],
		{}
	];

	(* Create the corresponding test for the invalid options. *)
	noIncubatorForSettingsTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = DeleteDuplicates[Lookup[invalidCellIncubationContainersAssocs, Sample, {}]];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have specified incubation condition options that are compatible with cell incubators that support container footprints:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs]>0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have specified incubation condition options that are compatible with cell incubators that support container footprints:", True, True],
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

	(* Constructing message for Tier 3 - container is generally invalid and with aliquot incubator is found with changed incubation options *)
	noIncubatorForContainersAndSettingsAssocs = Lookup[groupedNoCompatibleIncubatorAssocs, "NoIncubatorForContainersAndSettings", {}];

	noIncubatorForContainersAndSettingsInvalidOptions = If[Length[noIncubatorForContainersAndSettingsAssocs] > 0 && !gatherTests,
		Module[{invalidSamples, invalidSampleContainerFootprints, incubatorChangeTuples, invalidSampleSpecifiedOptionKeys,
			captureSentence, firstClauseGroups, firstClause, secondClauseGroups, secondClause, thirdClause, thirdClauseGroups, alternativeLastTwoClauses},

			(* Pull samples and additional info from the associations *)
			{invalidSamples, invalidSampleContainerFootprints, invalidSampleSpecifiedOptionKeys, incubatorChangeTuples} = Transpose@Lookup[
				noIncubatorForContainersAndSettingsAssocs,
				{Sample, ContainerFootprint, UserSpecifiedOptionKeys, PossibleIncubatorChangeTuples}
			];

			(* Capture sentence that does not have details *)
			captureSentence = StringJoin[
				"No cell incubator can accommodate ",
				Which[
					(* We only have 1 sample in the call*)
					Length[mySamples] == 1,
						"the sample in its current container",
					(* We have more than 1 sample in the call and all are invalid *)
					Length[mySamples] == Length[invalidSamples],
						"the samples in their current containers",
					(* Only one sample among all input is invalid *)
					Length[invalidSamples] == 1,
						"one of the input samples in its current container",
					True,
						"some of the input samples in their current containers"
				],
				" or support the specified incubation setting(s)."
			];

			(* First clause explains whats wrong. It takes format of Sample xx resides in container with footprint of and has specified option(s) of xx, which is/are not compatible with any incubator that support the specified the container footprint of xx.  *)
			(* First clause explains whats wrong. It takes format of Sample xx is in container with footprint xx that is not compatible with any incubator. *)
			firstClauseGroups = GroupBy[Transpose[{invalidSamples, invalidSampleContainerFootprints}], Last];
			(* Similar to InvalidCellIncubationContainers, the reason clause does not get very long even when we have >3 footprints to complain about *)
			firstClause = StringJoin[
				joinClauses[
					KeyValueMap[
						Function[{footprint, sampleFootprintTuple},
							StringJoin[
								Which[
									(* We only have 1 sample in the call*)
									Length[mySamples] == 1,
										"the sample",
									(* We have more than 1 sample in the call and all are invalid this way *)
									Length[mySamples] == Length[sampleFootprintTuple[[All, 1]]],
										"the samples",
									(* We have part of the input samples failing this way, need to point out which object(s) *)
									True,
										samplesForMessages[sampleFootprintTuple[[All, 1]], Cache -> cacheBall, Simulation -> simulation]
								],
								pluralize[sampleFootprintTuple[[All, 1]], " is in a container", " are in containers"],
								" with a ",
								ToString[footprint],
								" Footprint"
							]
						],
						firstClauseGroups
					],
					CaseAdjustment -> True
				],
				If[Length[firstClauseGroups] > 1,
					". These container footprints are not supported by any cell incubator.",
					", which is not supported by any cell incubator."
				]
			];

			(* Second clause further explains whats wrong. The combined specified options also not supported by any incubator for the sample. *)
			(* Grouped by if the same set of options is specified *)
			secondClauseGroups = GroupBy[Transpose[{invalidSamples, invalidSampleSpecifiedOptionKeys}], Last];
			secondClause = StringJoin[
				"In addition, even with potential aliquoting already considered, no cell incubator can support ",
				joinClauses[
					KeyValueMap[
						Function[{specifiedOptionKeys, sampleOptionsTuple},
							StringJoin[
								"the combination of the specified ",
								joinClauses[specifiedOptionKeys],
								" setting(s) for the incubation of ",
								Which[
									(* A single sample is all we have that triggered this message *)
									Length[invalidSamples] == 1,
										"this sample",
									(* Multiple samples triggered one set of corrective action*)
									Length[sampleOptionsTuple[[All, 1]]] == Length[invalidSamples],
										"these samples",
									(* There are multiple recommendations. List them out. *)
									True,
										samplesForMessages[sampleOptionsTuple[[All, 1]], Cache -> cacheBall, Simulation -> simulation]
								]
							]
						],
						secondClauseGroups
					],
					CaseAdjustment -> False,
					ConjunctionWord -> "and"
				],
				"."
			];
			(* Third clause gives suggestion. Suggest change of settings and aliquot container *)
			thirdClauseGroups = GroupBy[Transpose[{invalidSamples, incubatorChangeTuples}], Last];
			thirdClause = StringJoin@@KeyValueMap[
				Function[{incubatorChangeTuples, sampleChangeTuple},
					StringJoin[
						"Please Use ExperimentTransfer to transfer ",
						Which[
							(* A single sample is all we have that triggered this message *)
							Length[invalidSamples] == 1,
								"this sample",
							(* Multiple samples triggered one set of corrective action*)
							Length[sampleChangeTuple[[All, 1]]] == Length[invalidSamples],
								"these samples",
							(* There are multiple recommendations. List them out. *)
							True,
								samplesForMessages[sampleChangeTuple[[All, 1]], Cache -> cacheBall, Simulation -> simulation]
						],
						If[Length[sampleChangeTuple[[All, 1]]] == 1,
							" to a compatible container such as ",
							" to compatible containers such as "
						],
						joinClauses[
							ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@ Lookup[incubatorToPreferredContainerLookup, incubatorChangeTuples[[All, 1]]],
							ConjunctionWord -> "or"
						],
						", then please ",
						suggestSettingChangesForIncubators[incubatorChangeTuples[[All, 1]], incubatorChangeTuples[[All, 2]]],
						". "
					]
				],
				thirdClauseGroups
			];
			(* If any one is longer than the constant, collapse into one *)
			alternativeLastTwoClauses = If[Or[
				Length[Keys[secondClauseGroups]] > $MaxNumberOfErrorDetails,
				Length[Keys[thirdClauseGroups]] > $MaxNumberOfSuggestedActions
			],
				StringJoin[
					"In addition, even with potential aliquoting already considered, no cell incubator can support the specified combinations of ", joinClauses[Flatten[invalidSampleSpecifiedOptionKeys], ConjunctionWord -> "and/or"],
					" settings for these samples. First, please check the \"Preferred Input Container\" section of the ExperimentIncubateCells helpfile for containers accepted by cell incubators, and then use ExperimentTransfer to transfer these samples to compatible containers. Second, please check the \"Instrumentation\" section of the ExperimentIncubateCells helpfile for the allowed incubation settings for incubators that fit the aliquoted samples, for example, ",
					joinClauses[
						ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@ DeleteDuplicates@Flatten[Keys[thirdClauseGroups][[All,All,1]]],
						ConjunctionWord -> "or"
					],
					", and then update the options accordingly."
				],
				Null
			];
			(* Throw the corresponding error. *)
			Message[Error::NoIncubatorForContainersAndSettings,
				captureSentence,
				firstClause,
				Sequence @@ If[NullQ[alternativeLastTwoClauses],
					{secondClause, thirdClause},
					{"", alternativeLastTwoClauses}
				]
			];
			(* Return Incubator as an invalid option *)
			invalidSampleSpecifiedOptionKeys
		],
		{}
	];

	(* Create the corresponding test for the invalid options. *)
	noIncubatorForContainersAndSettingsTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = DeleteDuplicates[Lookup[noIncubatorForContainersAndSettingsAssocs, Sample, {}]];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have container footprint and specified incubation condition options that are compatible with at least one cell incubators", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs]>0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have container footprint and specified incubation condition options that are compatible with at least one cell incubators", True, True],
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
	(* This has two tiers that will eventually throw 2 different messages: *)
	(* 1. If there is conflict with container footprint or cell type, suggest alternatives. *)
	(* 2. If there is conflict with incubation condition options, suggest change options *)
	(* The big MapThread below goes through the 2 tiers described above and builds associations of info for different incubator-is-incompatible errors generated for each sample *)
	(* Each association contains the following Keys *)
	(* -ErrorName- the name of the error it triggers: "IncubatorIsIncompatible" | "ConflictingIncubatorWithSettings" *)
	(* -Sample- the sample for this info association: ObjectP[Object[Sample]] *)
	(* -SpecifiedIncubator- the object or model of specified incubator for this sample: ObjectP[{Object[Instrument], Model[Instrument]}] *)
	(* -SampleCompatibilityPairs- (only for IncubatorIsIncompatible) 3 lists of conflicting pairs of container footprint or cell type or culture adhesion value allowed by specified incubator v.s. determined for the sample, if actual value is allowed the pair is {Null, Null}: {{allowedFootprint, sampleContainerFootprint}|{Null, Null}, {allowedCellType, resolvedCellType}|{Null, Null}, {allowedCultureAdhesion, resolvedCultureAdhesion}|{Null, Null} *)
	(* -PossibleIncubators- (only for IncubatorIsIncompatible) a list of incubators allowing the resolved Footrprint/CellType/CultureAdhesion *)
	(* -ConflictingOptionKeys- (only for ConflictingIncubatorWithSettings) which of the incubationConditionOptions the user specified that is not allowed by the specified incubator: Alternatives[Temperature, CarbonDioxide, RelativeHumidity, Shake, ShakingRadius, ShakingRate] *)
	(* -ChangeTuples- (only for ConflictingIncubatorWithSettings) a list of required option changes to use the specified incubator: {{optionKey, desiredValueOrRange}..} *)

	(* {Number, sample, specifiedIncubator, additionalInfo} *)
	incubatorIsIncompatibleAllAssocs = MapThread[
		Function[{mySample, specifiedIncubator, allowedIncubators, sampleContainerFootprint, cellType, cultureAdhesion,
			unresolvedIncubationOptions, conflictingCellTypeWithIncubatorWarning, validSampleCellTypeQ,containerCompatibleWithIncubatorsQ},
			If[MatchQ[specifiedIncubator, ObjectP[]],
				(* Only enters module when there is an object specified as incubator *)
				Module[{specifiedIncubatorModelPacket, incubatorContainerAllowedFootprints, conflictingIncubationConditions,
					incubatorAllowedCultureAdhesion, incubatorAllowedCellTypes, sampleCompatibilityPairs, invalidSampleCompatibilityPairs},
					(* If the incubator is specified to be an object, get its model, otherwise leave as it is *)
					specifiedIncubatorModelPacket = If[MatchQ[specifiedIncubator,ObjectP[Object[Instrument, Incubator]]],
						fastAssocPacketLookup[fastAssoc, specifiedIncubator, Model],
						fetchPacketFromFastAssoc[specifiedIncubator, fastAssoc]
					];
					(* Find what footprint and sample properties are allowed on this incubator *)
					incubatorContainerAllowedFootprints = Keys[Lookup[$CellIncubatorMaxCapacity, Download[specifiedIncubatorModelPacket, Object]]];
					incubatorAllowedCultureAdhesion = Lookup[incubatorToAllowedCultureAdhesionLookup, Download[specifiedIncubatorModelPacket, Object]];
					incubatorAllowedCellTypes = Lookup[specifiedIncubatorModelPacket, CellTypes];
					(* compare footprints, culture adhesion and cell type compatibilities and construct a list  *)
					sampleCompatibilityPairs = MapThread[
						Function[{allowedValues, currentValue},
							If[MemberQ[allowedValues, currentValue],
								(* If the value is allowed, null it *)
								{Null, Null},
								{allowedValues, currentValue}
							]
						],
						{
							{incubatorContainerAllowedFootprints, incubatorAllowedCellTypes, incubatorAllowedCultureAdhesion},
							{sampleContainerFootprint, cellType, cultureAdhesion}
						}
					];
					(* In addition to if the value is allowed by the incubator, also check if it is resolved to a default or checked in other higher level "invalid" errors so that we do not throw this error about it *)
					invalidSampleCompatibilityPairs = {
						(* Container compatibility *)
						(*  If any of the sample is not in a totally invalid container but the container footprint does not fit *)
						If[Or[
							!containerCompatibleWithIncubatorsQ,
							MatchQ[mySample, ObjectP[discardedInvalidInputs]]
						],
							{Null, Null},
							sampleCompatibilityPairs[[1]]
						],
						(* If the cell type is not allowed and it is not the warning-only case, i.e. yeast v.s. Bacterial *)
						If[conflictingCellTypeWithIncubatorWarning || !validSampleCellTypeQ,
							{Null, Null},
							sampleCompatibilityPairs[[2]]
						],
						sampleCompatibilityPairs[[3]]
					};

					(* these gives us what incubation condition options is conflicting with the specified incubator *)
					conflictingIncubationConditions = whyCantIPickThisIncubator[specifiedIncubatorModelPacket, unresolvedIncubationOptions];

					(* Check through the tiers *)
					Which[
						(* Tier 1: if any of the footprint, culture type, culture adhesion is compatible but have not triggered higher level message *)
						!MatchQ[invalidSampleCompatibilityPairs, {{Null, Null}..}],
							(* Return the tier 1 assoc *)
							<|
								ErrorName -> "IncubatorIsIncompatible",
								Sample -> mySample,
								SpecifiedIncubator -> specifiedIncubator,
								SampleCompatibilityPairs -> invalidSampleCompatibilityPairs,
								PossibleIncubators -> allowedIncubators
							|>,
						(* Tier 2 *)
						Length[conflictingIncubationConditions] > 0,
							(* Return the tier 2 assoc *)
							<|
								ErrorName -> "ConflictingIncubatorWithSettings",
								Sample -> mySample,
								SpecifiedIncubator -> specifiedIncubator,
								ConflictingOptionKeys -> Intersection[Keys[unresolvedIncubationOptions], conflictingIncubationConditions[[All, 1]]],
								ChangeTuples -> conflictingIncubationConditions
							|>,
						True,
							Nothing
					]
				],
				Nothing
			]
		],
		{
			mySamples, specifiedIncubators, possibleIncubators, sampleContainerFootprints, cellTypes, cultureAdhesions,
			specifiedIncubationSettings, conflictingCellTypeWithIncubatorWarnings, validCellTypeQs, containerCompatibleWithIncubatorsQs
		}
	];

	(* Group by error mode and suggestions *)
	groupedIncubatorIsIncompatibleAllAssocs = GroupBy[incubatorIsIncompatibleAllAssocs, Lookup[#, ErrorName]&];

	(* Construct message for Tier 1 *)
	incubatorIsIncompatibleAssocs = Lookup[groupedIncubatorIsIncompatibleAllAssocs, "IncubatorIsIncompatible", {}];

	incubatorIsIncompatibleInvalidOptions = If[Length[incubatorIsIncompatibleAssocs] > 0 && !gatherTests,
		Module[
			{
				captureSentence, firstClauseGroups, firstClause, secondClause, secondClauseGroups, invalidSamples, invalidIncubators,
				sampleCompatibilityPairs, compatibleIncubators, cellTypeFailureSamples, cultureAdhesionFailureSamples
			},

			(* Pull samples and additional info from the associations *)
			{invalidSamples, invalidIncubators, sampleCompatibilityPairs, compatibleIncubators} = Transpose@Lookup[
				incubatorIsIncompatibleAssocs,
				{Sample, SpecifiedIncubator, SampleCompatibilityPairs, PossibleIncubators}
			];

			(* samples that fails due to resolved cell types *)
			cellTypeFailureSamples = PickList[invalidSamples, sampleCompatibilityPairs[[All, 2]], Except[ListableP[{Null, Null}]]];

			(* samples that fails due to resolved culture adhesions *)
			cultureAdhesionFailureSamples = PickList[invalidSamples, sampleCompatibilityPairs[[All, 3]], Except[ListableP[{Null, Null}]]];

			(* Capture sentence that does not have details *)
			captureSentence = StringJoin[
				Which[
					Length[allUniqueSpecifiedIncubators] == 1,
					(* There is only one incubator specified and it triggered this error *)
						"The specified cell incubator does ",
					(* There is more than 1 incubator specified, but all specified incubators are invalid *)
					Length[invalidIncubators] == Length[specifiedIncubators],
						"All specified cell incubators do ",
					(* One of many specified cell incubators is invalid *)
					Length[invalidIncubators] == 1,
						"One of the specified cell incubators does ",
					True,
						"Some of the specified cell incubators do "
				],
				"not support ",
				joinClauses[
					{
						If[MatchQ[sampleCompatibilityPairs[[All,1]], ListableP[{Null, Null}]],
							Nothing,
							"the container"
						],
						Which[
							MatchQ[sampleCompatibilityPairs[[All, 2]], ListableP[{Null, Null}]],
								Nothing,
							(* There are samples failing due to cell type, was it specified or detected? *)
							MemberQ[PickList[specifiedConflictingCellTypeQs, mySamples, ObjectP[cellTypeFailureSamples]], True],
								"the specified CellType",
							(* Otherwise the failing cell type was either not specified or specified consistent with sample, no need to make the distinction *)
							True,
								"the CellType"
						],
						Which[
							MatchQ[sampleCompatibilityPairs[[All, 3]], ListableP[{Null, Null}]],
								Nothing,
							(* There are samples failing due to cell type, was it specified or detected? *)
							MemberQ[PickList[conflictingCultureAdhesionErrors, mySamples, ObjectP[cultureAdhesionFailureSamples]], True],
								"the specified CultureAdhesion",
							(* Otherwise the failing cell type was either not specified or specified consistent with sample, no need to make the distinction *)
							True,
								"the CultureAdhesion"
						]
					}
				],
				" of ",
				Which[
					(* We only have 1 sample in the call*)
					Length[mySamples] == 1,
						"the sample.",
					(* We have more than 1 sample in the call and all are invalid *)
					Length[mySamples] == Length[invalidSamples],
						"the samples.",
					(* Only one sample among all input is invalid *)
					Length[invalidSamples] == 1,
						"one of the input samples.",
					True,
						"some of the input samples."
				]
			];

			(* FirstClause says whats wrong: sample has specified incubator model of xx. group the tuples based on specified incubators. *)
			(* ReasonClauses, footprint + cell type + options *)

			firstClauseGroups = GroupBy[Transpose[{invalidSamples, sampleCompatibilityPairs, invalidIncubators}], Last];
			firstClause = If[Length[Keys[firstClauseGroups]] > $MaxNumberOfErrorDetails,
				StringJoin[
					"Please check the \"Instrumentation\" section of the ExperimentIncubateCells helpfile for the allowed samples and containers for ",
					Which[
						(* A specified incubator is all we have that triggered this message *)
						Length[invalidIncubators] == 1,
							"the specified incubator",
						(* Multiple incubators triggered*)
						Length[invalidIncubators] == Length[specifiedIncubators],
							"the specified incubators",
						(* There are part(s) of all specified incubators that needed checking *)
						True,
							samplesForMessages[invalidIncubators, Cache -> cacheBall, Simulation -> simulation, CollapseForDisplay -> False]
					],
					". "
				],
				StringJoin @@ KeyValueMap[
					Function[{specifiedIncubator, sampleCompatibilityIncubatorTuple},
						StringJoin[
							"The specified incubator ",
							ObjectToString[specifiedIncubator, Cache -> cacheBall, Simulation -> simulation],
							" cannot be used for ",
							samplesForMessages[sampleCompatibilityIncubatorTuple[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
							", because ",
							joinClauses[{
								(* container footprint *)
								If[MatchQ[sampleCompatibilityIncubatorTuple[[All, 2, 1]], ListableP[{Null, Null}]],
									Nothing,
									StringJoin[
										"the incubator allows containers with a Footprint of ",
										joinClauses[DeleteCases[Flatten[sampleCompatibilityIncubatorTuple[[All, 2, 1, 1]]], Null]],
										" but ",
										pluralize[sampleCompatibilityIncubatorTuple[[All, 1]], "the sample is in a container ", "the samples are in containers "],
										"with a ",
										joinClauses[DeleteCases[sampleCompatibilityIncubatorTuple[[All, 2, 1, 2]], Null]],
										" Footprint"
									]
								],
								(* cell type *)
								If[MatchQ[sampleCompatibilityIncubatorTuple[[All, 2, 2]], ListableP[{Null, Null}]],
									Nothing,
									StringJoin[
										"the incubator allows ",
										joinClauses[DeleteCases[Flatten[sampleCompatibilityIncubatorTuple[[All, 2, 2, 1]]], Null]],
										" samples but ",
										Module[{conflictingCellTypeSamples, invalidCellTypes, invalidCellTypeWasSpecifiedQs},
											(* Pick the samples that fails because of the cell type is not allowed. We need this because it is possible that a sample only fails because of container *)
											conflictingCellTypeSamples = PickList[
												(* samples *)
												sampleCompatibilityIncubatorTuple[[All, 1]],
												(* corresponding cell type compatibility tuple*)
												sampleCompatibilityIncubatorTuple[[All, 2, 2]],
												Except[{Null, Null}]
											];
											invalidCellTypes = Flatten[DeleteCases[sampleCompatibilityIncubatorTuple[[All, 2, 2, 2]], Null]];
											invalidCellTypeWasSpecifiedQs = PickList[specifiedConflictingCellTypeQs, mySamples, ObjectP[conflictingCellTypeSamples]];
											(* Write the string *)
											StringJoin[
												samplesForMessages[conflictingCellTypeSamples, mySamples, Cache -> cacheBall, Simulation -> simulation],
												" ",
												isOrAre[conflictingCellTypeSamples],
												If[MemberQ[invalidCellTypeWasSpecifiedQs, True],
													" specified to be ",
													" "
												],
												joinClauses[invalidCellTypes]
											]
										]
									]
								],
								(* culture adhesion *)
								If[MatchQ[sampleCompatibilityIncubatorTuple[[All, 2, 3]], ListableP[{Null, Null}]],
									Nothing,
									StringJoin[
										"the incubator allows ",
										joinClauses[DeleteCases[Flatten[sampleCompatibilityIncubatorTuple[[All, 2, 3, 1]]], Null]],
										" samples but ",
										Module[{invalidCultureAdhesionSamples, invalidCultureAdhesions, invalidCultureAdhesionWasSpecifiedQs},
											(* Pick the samples that fails because of the cell type is not allowed. We need this because it is possible that a sample only fails because of container *)
											invalidCultureAdhesionSamples = PickList[
												(* samples *)
												sampleCompatibilityIncubatorTuple[[All, 1]],
												(* corresponding culture adhesion compatibility tuple*)
												sampleCompatibilityIncubatorTuple[[All, 2, 3]],
												Except[{Null, Null}]
											];
											invalidCultureAdhesions = Flatten[DeleteCases[sampleCompatibilityIncubatorTuple[[All, 2, 3, 2]], Null]];
											invalidCultureAdhesionWasSpecifiedQs = PickList[conflictingCultureAdhesionErrors, mySamples, ObjectP[invalidCultureAdhesionSamples]];
											(* Write the string *)
											StringJoin[
												samplesForMessages[invalidCultureAdhesionSamples, mySamples, Cache -> cacheBall, Simulation -> simulation],
												" ",
												isOrAre[invalidCultureAdhesionSamples],
												If[MemberQ[invalidCultureAdhesionWasSpecifiedQs, True],
													" specified to be ",
													" "
												],
												joinClauses[invalidCultureAdhesions]
											]
										]
									]
								]
							}],
							". "
						]
					],
					firstClauseGroups
				]
			];
			(* Second clause gives recommendations *)
			secondClauseGroups = GroupBy[Transpose[{invalidSamples, compatibleIncubators}], Last];
			secondClause = If[Length[Keys[secondClauseGroups]] > $MaxNumberOfSuggestedActions,
				StringJoin[
					"Please use IncubateCellsDevices[mySamples, <myOptions>] to search for compatible incubators for ",
					samplesForMessages[invalidSamples, mySamples, Cache -> cacheBall, Simulation -> simulation],
					". "
				],
				StringJoin @@ KeyValueMap[
					Function[{compatibleIncubatorsPerSample, sampleAllowedIncubatorsTuple},
						(* If there is recommended incubator. *)
						If[Length[compatibleIncubatorsPerSample] > 0,
							StringJoin[
								Which[
									(* A single sample is all we have that triggered this message *)
									Length[invalidSamples] == 1,
										"This sample",
									(* Multiple samples triggered one set of corrective action*)
									Length[sampleAllowedIncubatorsTuple[[All, 1]]] == Length[invalidSamples],
										"These samples",
									(* There are multiple recommendations. List them out. *)
									True,
										Capitalize@samplesForMessages[sampleAllowedIncubatorsTuple[[All, 1]], Cache -> cacheBall, Simulation -> simulation]
								],
								" can be incubated in ",
								joinClauses[
									ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@ compatibleIncubatorsPerSample,
									ConjunctionWord -> "or"
								],
								" instead. "
							],
							StringJoin[
								"Use IncubateCellsDevices[mySamples, <myOptions>] to search for compatible incubators for ",
								Which[
									(* A single sample is all we have that triggered this message *)
									Length[invalidSamples] == 1,
										"this sample",
									(* Multiple samples triggered one set of corrective action*)
									Length[sampleAllowedIncubatorsTuple[[All, 1]]] == Length[invalidSamples],
										"these samples",
									(* There are multiple recommendations. List them out. *)
									True,
										samplesForMessages[sampleAllowedIncubatorsTuple[[All, 1]], Cache -> cacheBall, Simulation -> simulation]
								],
								". "
							]
						]
					],
					secondClauseGroups
				]
			];
			(* Throw the corresponding error. *)
			Message[Error::IncubatorIsIncompatible,
				captureSentence,
				firstClause,
				secondClause
			];
			(* Return our invalid options. *)
			{Incubator}
		],
		(* Return our invalid options. *)
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	incubatorIsIncompatibleTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = DeleteDuplicates[Lookup[incubatorIsIncompatibleAssocs, Sample, {}]];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", has the incubator compatible with the sample if specified:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", has the incubator compatible with the sample if specified:", True, True],
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

	(* IncubatorIsIncompatible Tier-2: conflict in incubation condition options*)

	(* Construct message for Tier 2 *)
	conflictingIncubatorWithSettingsAssocs = Lookup[groupedIncubatorIsIncompatibleAllAssocs, "ConflictingIncubatorWithSettings", {}];

	conflictingIncubatorWithSettingsInvalidOptions = If[Length[conflictingIncubatorWithSettingsAssocs] > 0 && !gatherTests,
		Module[{captureSentence, firstClauseGroups, firstClause, secondClause, secondClauseGroups,
			invalidSamples, invalidIncubators, invalidOptionKeys, incubatorChangeTuples},

			(* Pull samples and additional info from the associations *)
			{invalidSamples, invalidIncubators, invalidOptionKeys, incubatorChangeTuples} = Transpose@Lookup[
				conflictingIncubatorWithSettingsAssocs,
				{Sample, SpecifiedIncubator, ConflictingOptionKeys, ChangeTuples}
			];

			(* Capture sentence that does not have details *)
			captureSentence = StringJoin[
				"Specified ",
				pluralize[allUniqueSpecifiedIncubators, "cell incubator does ", "cell incubators do "],
				"not support the specified incubation setting(s) for ",
				Which[
					(* We only have 1 sample in the call*)
					Length[mySamples] == 1,
						"the sample.",
					(* We have more than 1 sample in the call and all are invalid *)
					Length[mySamples] == Length[invalidSamples],
						"the samples.",
					(* Only one sample among all input is invalid *)
					Length[invalidSamples] == 1,
						"one of the input samples.",
					True,
						"some of the input samples."
				]
			];

			(* FirstClause says whats wrong: sample has specified incubator model of xx. group the tuples based on specified incubators. *)
			(* ReasonClauses, footprint + cell type + options *)

			firstClauseGroups = GroupBy[Transpose[{invalidSamples, invalidOptionKeys, invalidIncubators}], Last];

			firstClause = If[Length[Keys[firstClauseGroups]] > $MaxNumberOfErrorDetails,
				StringJoin[
					"Please check the Instrumentation section of the ExperimentIncubateCells helpfile for the allowed ",
					joinClauses[Flatten[invalidOptionKeys]],
					" settings for ",
					Which[
						(* A specified incubator is all we have that triggered this message *)
						Length[invalidIncubators] == 1,
							"the specified incubator",
						(* Multiple incubators triggered*)
						Length[invalidIncubators] == Length[specifiedIncubators],
							"the specified incubators",
						(* There are part(s) of all specified incubators that needed checking *)
						True,
							samplesForMessages[invalidIncubators, CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation]
					],
					". "
				],
				StringJoin @@ KeyValueMap[
					Function[{specifiedIncubator, sampleInvalidOptionsIncubatorTuple},
						StringJoin[
							"The specified incubator ",
							ObjectToString[specifiedIncubator, Cache -> cacheBall, Simulation -> simulation],
							" cannot achieve the specified ",
							joinClauses[DeleteDuplicates@Flatten[sampleInvalidOptionsIncubatorTuple[[All, 2]]]],
							" setting(s)",
							Which[
								(* A single sample is all we have that triggered this message *)
								Length[mySamples] == 1,
									"",
								(* Multiple samples triggered one set of corrective action*)
								Length[sampleInvalidOptionsIncubatorTuple[[All, 1]]] == Length[mySamples],
									"",
								(* There are multiple recommendations. List them out. *)
								True,
									" for the incubation of " <> samplesForMessages[sampleInvalidOptionsIncubatorTuple[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation]
							],
							". "
						]
					],
					firstClauseGroups
				]
			];
			(* Second sentence gives suggestion based on what options need to be changed. *)
			secondClauseGroups = GroupBy[Transpose[{invalidSamples, invalidIncubators, incubatorChangeTuples}], Last];
			secondClause = If[Length[Keys[secondClauseGroups]] > $MaxNumberOfSuggestedActions,
				StringJoin[
					"Please update the options accordingly for ",
					samplesForMessages[invalidSamples, mySamples, Cache -> cacheBall, Simulation -> simulation],
					". "
				],
				StringJoin @@ KeyValueMap[
					Function[{incubatorChangeTuples, sampleIncubatorChangeTuple},
						StringJoin[
							Which[
								(* A single sample is all we have that triggered this message *)
								Length[invalidSamples] == 1,
									"You can ",
								(* Multiple samples triggered one set of corrective action*)
								Length[sampleIncubatorChangeTuple[[All, 1]]] == Length[invalidSamples],
									"You can ",
								(* There are multiple recommendations. List them out. *)
								True,
									"For " <> samplesForMessages[sampleIncubatorChangeTuple[[All, 1]], Cache -> cacheBall, Simulation -> simulation] <> ", you can "
							],
							suggestSettingChangesForIncubators[
								If[Length[DeleteDuplicates[invalidIncubators]] == 1,
									(* A single sample is all we have that triggered this message *)
									"this incubator",
									(* Multiple samples triggered one set of corrective action*)
									samplesForMessages[sampleIncubatorChangeTuple[[All, 2]], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation]
								],
								incubatorChangeTuples
							],
							". "
						]
					],
					secondClauseGroups
				]
			];
			(* Throw the corresponding error. *)
			Message[Error::ConflictingIncubatorWithSettings,
				captureSentence, firstClause, secondClause
			];
			(* Return our invalid options. *)
			{Incubator}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	conflictingIncubatorWithSettingsTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = DeleteDuplicates[Lookup[conflictingIncubatorWithSettingsAssocs, Sample, {}]];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", has the incubator compatible with the incubation condition options if specified:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", has the incubator compatible with the incubation condition options if specified:", True, True],
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
	(* all unique custom incubators involved *)
	uniqueCustomIncubators = DeleteDuplicates[Cases[Download[rawIncubators, Object], Alternatives @@ customIncubators]];
	(* More than 1 custom incubator is not allowed, throw an error *)
	invalidCustomIncubatorsOptions = If[Length[uniqueCustomIncubators] > 1 && !gatherTests,
		Module[{invalidSamples, invalidCustomIncubators, sampleToSpecifiedCustomIncubatorQs,
			captureSentence, firstClauseGroups, firstClause},
			(* Get the samples and corresponding resolved custom incubator that is involved in this error. *)
			invalidSamples = PickList[mySamples, rawIncubators, Alternatives @@ customIncubators];
			invalidCustomIncubators = Cases[rawIncubators, Alternatives @@ customIncubators];
			(* For each invalid sample, is this custom incubator directly specified? *)
			sampleToSpecifiedCustomIncubatorQs = AssociationThread[mySamples -> (MemberQ[customIncubators, #]& /@ specifiedIncubators)];
			(* Construct a capture sentence with no technical details, only include how many unique custom incubators are involved. *)
			captureSentence = StringJoin[
				"Only one custom incubator can be used per protocol, however, ",
				IntegerName[Length[uniqueCustomIncubators], "English"],
				" are being used."
			];
			(* Further expanded reason clause explains what incubators are directly specified, what incubators is resolved based on *)
			firstClauseGroups = GroupBy[Transpose[{invalidSamples, invalidCustomIncubators}], Last];
			(* We are guaranteed to be talking about only part of all samples in each clause due to the nature of this message, so no need to worry about ommiting object IDs *)
			(* Here the groups are based on different custom incubators specified/required. We at most have 4, and it would be confusing to not spell out specified vs required and which samples. Not shortening this message based on the constant for now *)
			firstClause = Capitalize @ joinClauses[
				KeyValueMap[
					Function[{resolvedCustomIncubator, sampleIncubatorTuple},
						StringJoin[
							"custom incubator ",
							ObjectToString[resolvedCustomIncubator, Cache -> cacheBall, Simulation -> simulation],
							" ",
							(* Further group by specified v.s. resolved *)
							Module[{invalidSamplesPerIncubator, samplesWithIncubatorSpecified, samplesWithIncubatorResolved},
								invalidSamplesPerIncubator = sampleIncubatorTuple[[All, 1]];
								samplesWithIncubatorSpecified = PickList[invalidSamplesPerIncubator, Lookup[sampleToSpecifiedCustomIncubatorQs, invalidSamplesPerIncubator], True];
								samplesWithIncubatorResolved = Complement[invalidSamplesPerIncubator, samplesWithIncubatorSpecified];
								(* Return clause based on if any sample is specified *)
								joinClauses[{
									If[Length[samplesWithIncubatorSpecified] > 0,
										"is specified for " <> samplesForMessages[samplesWithIncubatorSpecified, Cache -> cacheBall, Simulation -> simulation],
										Nothing
									],
									If[Length[samplesWithIncubatorResolved] > 0,
										"is required for " <> samplesForMessages[samplesWithIncubatorResolved, Cache -> cacheBall, Simulation -> simulation],
										Nothing
									]
								}]
							]
						]
					],
					firstClauseGroups
				]
			];
			(* Throw the corresponding error. *)
			Message[Error::TooManyCustomIncubationConditions,
				captureSentence,
				firstClause
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
			failingInputs = PickList[mySamples, rawIncubators, Alternatives @@ customIncubators];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", all only utilize one custom incubator to incubate the samples with the provided options", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", all only utilize one custom incubator to incubate the samples with the provided options", True, True],
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


	(* 14.)ConflictingCellTypeWithIncubator *)
	(* Throw a soft warning if the incubator specified is intended for a different microbial cell type from the sample *)
	If[MemberQ[conflictingCellTypeWithIncubatorWarnings, True] && messages,
		Module[{warningTuples, warningGroupedTuples, warningClauses},
			warningTuples = MapThread[
				Function[{sample, warningBool, cellType, specifiedIncubator, allowedCellTypes},
					If[TrueQ[warningBool],
						{specifiedIncubator, sample, cellType, allowedCellTypes},
						Nothing
					]
				],
				{
					mySamples,
					conflictingCellTypeWithIncubatorWarnings,
					cellTypes,
					incubators,
					fastAssocLookup[fastAssoc, #, CellTypes]& /@ incubators
				}
			];
			(* Group by specified incubators *)
			warningGroupedTuples = GroupBy[warningTuples, First];
			(* Return the joined clauses stating what's wrong *)
			warningClauses = StringJoin @@ KeyValueMap[
				Function[{incubator, tuple},
					StringJoin[
						Capitalize@samplesForMessages[tuple[[All, 2]], mySamples, Cache -> cacheBall, Simulation -> simulation],
						If[Length[tuple[[All, 2]]] > 1,
							" are ",
							" is "
						],
						(* whether the cell types were specified or detected *)
						Module[{invalidSamplesSpecifiedConflictingCellTypeQs},
							invalidSamplesSpecifiedConflictingCellTypeQs = PickList[specifiedConflictingCellTypeQs, mySamples, ObjectP[tuple[[All, 2]]]];
							Which[
								(* all were specified conflicting with sample *)
								AllTrue[invalidSamplesSpecifiedConflictingCellTypeQs, TrueQ],
									"specified to have a " <> joinClauses[tuple[[All, 3]], CaseAdjustment -> True] <> " CellType",
								(* some specified conflicting with sample *)
								AnyTrue[invalidSamplesSpecifiedConflictingCellTypeQs, TrueQ],
									"specified or detected to have a " <> joinClauses[tuple[[All, 3]], CaseAdjustment -> True] <> " CellType",
								(* none were specified conflicting with sample *)
								True,
									"detected to have a " <> joinClauses[tuple[[All, 3]], CaseAdjustment -> True] <> " CellType"
							]
						],
						", but ",
						If[Length[tuple[[All, 2]]] > 1,
							"are ",
							"is "
						],
						"specified to be incubated in ",
						ObjectToString[incubator, Cache -> cacheBall, Simulation -> simulation],
						", which is designated for incubation of ",
						joinClauses[Flatten[tuple[[All, 4]]]],
						" cells. "
					]
				],
				warningGroupedTuples
			];
			Message[
				Warning::ConflictingCellTypeWithIncubator,
				warningClauses
			]
		]
	];

	conflictingCellTypeWithIncubatorTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingCellTypeWithIncubatorWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> " only specify Incubators that are compatible with the samples' cell types:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> " only specify Incubators that are compatible with the samples' cell types:", True, True],
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

	(* Throw a soft warning if the IncubationCondition specified is intended for a different microbial cell type from the sample *)
	If[MemberQ[conflictingCellTypeWithIncubationConditionWarnings, True] && messages,
		Module[{warningTuples, warningGroupedTuples, warningClause},
			warningTuples = MapThread[
				Function[{sample, warningBool, cellType, specifiedIncubationCondition},
					If[TrueQ[warningBool],
						{specifiedIncubationCondition, sample, cellType},
						Nothing
					]
				],
				{
					mySamples,
					conflictingCellTypeWithIncubationConditionWarnings,
					cellTypes,
					Lookup[resolvedOptions, IncubationCondition]
				}
			];
			(* Group by specified IncubationConditions *)
			warningGroupedTuples = GroupBy[warningTuples, First];
			(* Return the joined clauses stating what's wrong *)
			warningClause = StringJoin @@ KeyValueMap[
				Function[{incubationCondition, tuple},
					StringJoin[
						Capitalize@samplesForMessages[tuple[[All, 2]], mySamples, Cache -> cacheBall, Simulation -> simulation],
						If[Length[tuple[[All, 2]]] > 1,
							" are ",
							" is "
						],
						(* whether the cell types were specified or detected *)
						Module[{invalidSamplesSpecifiedConflictingCellTypeQs},
							invalidSamplesSpecifiedConflictingCellTypeQs = PickList[specifiedConflictingCellTypeQs, mySamples, ObjectP[tuple[[All, 2]]]];
							Which[
								(* all were specified conflicting with sample *)
								AllTrue[invalidSamplesSpecifiedConflictingCellTypeQs, TrueQ],
									"specified to have a " <> joinClauses[tuple[[All, 3]], CaseAdjustment -> True] <> " CellType",
								(* some were specified conflicting with sample *)
								AnyTrue[invalidSamplesSpecifiedConflictingCellTypeQs, TrueQ],
									"specified or detected to have a " <> joinClauses[tuple[[All, 3]], CaseAdjustment -> True] <> " CellType",
								(* none were specified conflicting with sample *)
								True,
									"detected to have a " <> joinClauses[tuple[[All, 3]], CaseAdjustment -> True] <> " CellType"
							]
						],
						", but ",
						isOrAre[tuple[[All, 2]]],
						" specified to be incubated under ",
						If[MatchQ[incubationCondition, ObjectP[]],
							ObjectToString[incubationCondition, Cache -> cacheBall, Simulation -> simulation],
							ToString[incubationCondition]
						],
						". "
					]
				],
				warningGroupedTuples
			];
			Message[
				Warning::ConflictingCellTypeWithIncubationCondition,
				warningClause
			]
		]
	];

	conflictingCellTypeWithIncubationConditionTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, unsupportedCellCultureTypeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> " do not specify IncubationCondition that is intended for a different microbial cell type than the samples' cell types:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> " do not specify IncubationCondition that is intended for a different microbial cell type than the samples' cell types:", True, True],
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

	(* Conflict check for specified Incubator and Specified IncubationCondition *)
	conflictingIncubatorIncubationConditionInvalidOptions = If[MemberQ[conflictingIncubatorIncubationConditionErrors, True] && messages,
		Module[{invalidSamples, invalidSpecifiedIncubationConditions, invalidIncubators, groupedBySpecifiedIncubators,
			specifiedIncubationConditionSymbols, reasonClauses, uniqueIncubationConditionSymbols, compatibleIncubatorsClauses},

			(* For which samples *)
			invalidSamples = PickList[mySamples, conflictingIncubatorIncubationConditionErrors];
			(* What are the invalid specified incubation conditions *)
			invalidSpecifiedIncubationConditions = PickList[specifiedIncubationConditions, conflictingIncubatorIncubationConditionErrors];
			specifiedIncubationConditionSymbols = incubationConditionModelToSymbol[#]& /@ invalidSpecifiedIncubationConditions;
			(* What are the invalid specified incubators *)
			invalidIncubators = PickList[specifiedIncubators, conflictingIncubatorIncubationConditionErrors];
			(* Groups by specified incubators *)
			groupedBySpecifiedIncubators =  GroupBy[Transpose@{invalidSamples, invalidSpecifiedIncubationConditions, invalidIncubators}, Last];

			(* Generate the clauses further explain *)
			reasonClauses = StringJoin @@ KeyValueMap[
				Function[{specifiedIncubator, sampleIncubationConditionIncubatorTuple},
					StringJoin[
						"The specified incubator ",
						ObjectToString[specifiedIncubator, Cache -> cacheBall, Simulation -> simulation],
						" provides an incubation condition of ",
						ObjectToString[
							If[MatchQ[specifiedIncubator, ObjectP[Model[Instrument]]],
								fastAssocLookup[fastAssoc, specifiedIncubator, ProvidedStorageCondition],
								fastAssocLookup[fastAssoc, specifiedIncubator, {Model, ProvidedStorageCondition}]
							] /. Null -> Custom , Cache -> cacheBall
						],
						" for ",
						samplesForMessages[sampleIncubationConditionIncubatorTuple[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
						If[Length[sampleIncubationConditionIncubatorTuple[[All, 1]]] == 1,
							" which is ",
							" which are "
						],
						"specified to be incubated under ",
						joinClauses[ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@ sampleIncubationConditionIncubatorTuple[[All,2]]],
						". "
					]
				],
				groupedBySpecifiedIncubators
			];
			(* Depending on how many incubations we are further explaining the corresponding incubators, use different clauses *)
			uniqueIncubationConditionSymbols = DeleteDuplicates[specifiedIncubationConditionSymbols];
			(* Clause suggest possible incubators from the specified incubation condition *)
			compatibleIncubatorsClauses = If[Length[uniqueIncubationConditionSymbols] == 1,
				StringJoin[
					"This incubation condition can be provided by ",
					joinClauses[ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@ Lookup[incubationConditionIncubatorLookup, uniqueIncubationConditionSymbols[[1]]]],
					". "
				],
				(* More than one, expand and join clause *)
				StringJoin @@ Map[
					Function[singleIncubationConditionSymbol,
						StringJoin[
							ToString[singleIncubationConditionSymbol],
							" can be provided by ",
							joinClauses[ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@  Lookup[incubationConditionIncubatorLookup, singleIncubationConditionSymbol]],
							". "
						]
					],
					DeleteDuplicates[specifiedIncubationConditionSymbols]
				]
			];

			Message[
				Error::ConflictingIncubatorIncubationCondition,
				"The specified Incubator cannot provide the specified IncubationCondition.",
				reasonClauses,
				compatibleIncubatorsClauses
			];
			(* Return invalid options *)
			{IncubationCondition, Incubator}
		],
		{}
	];
	(* conflictingIncubatorIncubationConditionTests *)
	conflictingIncubatorIncubationConditionTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingIncubatorIncubationConditionErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> " do not specify IncubationCondition that is not provided by the specified incubator:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> " do not specify IncubationCondition that is not provided by the specified incubator:", True, True],
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



	(* -- MESSAGE AND RETURN --*)



	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[
			{
				discardedInvalidInputs,
				deprecatedSampleInputs,
				gaseousSampleInputs[[All,1]],
				invalidCellTypeSamples,
				invalidPlateSampleInputs,
				duplicateSamples,
				invalidCellIncubationContainersInvalidInputs,
				additionalIncubatorCompatibilityInvalidInputs,
				tooManySamples
			}
		]
	];
	invalidOptions = DeleteDuplicates[Flatten[
			{
				invalidShakingConditionsOptions,
				conflictingWorkCellAndPreparationOptions,
				conflictingCellTypeErrorOptions,
				conflictingCultureAdhesionOptions,
				invalidCustomIncubatorsOptions,
				invalidIncubationConditionOptions,
				conflictingCellTypeAdhesionOptions,
				unsupportedCellCultureTypeOptions,
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
				noIncubatorForSettingsInvalidOptions,
				incubatorIsIncompatibleInvalidOptions,
				conflictingIncubatorWithSettingsInvalidOptions,
				incubationConditionIsIncompatibleUseAlternativesInvalidOptions,
				conflictingIncubationConditionWithSettingsInvalidOptions,
				conflictingIncubatorIncubationConditionInvalidOptions,
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
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall, Simulation -> simulation]]
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
			gaseousSampleTest,
			uncoveredContainerTest,
			invalidCellTypeTest,
			invalidPlateSampleTest,
			duplicateSamplesTest,
			missingVolumeTest,
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
			quantificationAliquotRequiredTest,
			quantificationAliquotRecommendedTest,
			invalidCellIncubationContainersTests,
			noIncubatorForSettingsTests,
			noIncubatorForContainersAndSettingsTests,
			incubatorIsIncompatibleTests,
			conflictingIncubatorWithSettingsTests,
			incubationConditionIsIncompatibleUseAlternativesTests,
			conflictingIncubationConditionWithSettingsTests,
			conflictingCellTypeWithStorageConditionWarningTests,
			conflictingCellTypeWithIncubationConditionTests,
			conflictingIncubatorIncubationConditionTests
		}], _EmeraldTest]
	}
];

(* ::Subsubsection::Closed:: *)
(*incubateCellsResourcePackets*)


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
		previewRule, optionsRule, nonHiddenOptions, nonHiddenOptionsWithoutTarget, safeOps, cache, fastAssoc, containerPackets, sampleContainerModelPackets, preparation,
		incubationConditions, containers, containerMovesToDifferentStorageConditionQs, labelSamplePrimitive, allPrimitivesExceptIncubateCells,
		containerStoredInNonIncubatorQs, nonIncubationStorageContainerObjs, nonIncubationStorageContainerResources,
		defaultIncubatorQs, nonIncubationStorageContainerConditions, postDefaultIncubationContainerObjs,
		postDefaultIncubationContainerResources, defaultIncubationContainerObjs, defaultIncubationContainerResources,
		shakes, shakingRadii, unitOperationPacket, simulationWithRoboticUOs, runTime, fastAssocKeysIDOnly, storageConditionPackets,
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
	sampleContainerModelPackets = Replace[
		fastAssocPacketLookup[fastAssoc, #, {Container, Model}]& /@ mySamples,
		Null|$Failed -> <||>, {1}
	];
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
		{incubationConditionSymbols, resolvedStorageConditions}
	];

	(* Determine if a given container is going to be stored not in an incubator after the experiment *)
	containerStoredInNonIncubatorQs = Map[
		Function[{storageConditionSymbol},
			!MemberQ[incubationStorageConditionSymbols, storageConditionSymbol]
		],
		resolvedStorageConditions
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
	nonIncubationStorageContainerConditions = PickList[resolvedStorageConditions, containerStoredInNonIncubatorQs];

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
				(* Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station for Microbiology"] *)
				Bacterial -> Model[Instrument, HandlingStation, BiosafetyCabinet, "id:54n6evJ3G4nl"],
				(* Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station for Tissue Culture"] *)
				Mammalian -> Model[Instrument, HandlingStation, BiosafetyCabinet, "id:AEqRl9xveX7p"],
				(* Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station for Microbiology"] *)
				Yeast | Plant | Insect | Fungal -> Model[Instrument, HandlingStation, BiosafetyCabinet, "id:54n6evJ3G4nl"]
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
			(* Get the current volumes of all the input samples. If no Volume is populated, use the MaxVolume of source containers *)
			(* The warning has been thrown as MissingVolumeInformation *)
			inputSampleVolumes = MapThread[
				If[MatchQ[#1, VolumeP],
					#1,
					Lookup[#2, MaxVolume]
				]&,
				{Lookup[samplePackets, Volume], sampleContainerModelPackets}
			];

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
			SamplesOutStorageCondition -> Extract[resolvedStorageConditions, uniqueContainerPositions],
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
					(* QuantifyColonies for quantification, as this requires two different workcells and is a fringe use case to begin with. *)
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
				Replace[SamplesOutStorage] -> resolvedStorageConditions,
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

(* ::Subsubsection::Closed:: *)
(*simulateExperimentIncubateCells*)

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
(*Memoized Searches*)
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
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent, 1 Percent],
						Units -> Percent
					]
				],
				Description -> "Percent CO2 at which the SamplesIn should be incubated.",
				ResolutionDescription -> "Resolves to 5% if the CellType is Mammalian for this sample, otherwise resolves to the default percentage for the specified CellType.",
				Category -> "General"
			},
			{
				OptionName -> RelativeHumidity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent, 1 Percent],
						Units -> Percent
					]
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
				desiredCultureAdhesion,
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
							incubator, incubatorCellTypes, incubatorMaxTemperature, incubatorMinTemperature, incubatorMaxCarbonDioxidePercentage,
							incubatorMinCarbonDioxidePercentage, incubatorMaxRelativeHumidity, incubatorMinRelativeHumidity,
							incubatorMaxShakingRate, incubatorMinShakingRate, incubatorShakingRadius, loadingMode, shakeQ,
							incubatorDefaultTemperature, incubatorDefaultCarbonDioxidePercentage, incubatorDefaultRelativeHumidity,
							incubatorDefaultShakingRate, cellTypeCompatible, temperatureCompatible, carbonDioxidePercentageCompatible,
							relativeHumidityCompatible, shakingRateCompatible, shakingRadiusCompatible, prepMethodCompatible, cultureAdhesionCompatible
						},

						(* Get info about the incubator *)
						{incubator, incubatorCellTypes, incubatorMaxTemperature, incubatorMinTemperature, incubatorDefaultTemperature,
							incubatorMaxCarbonDioxidePercentage, incubatorMinCarbonDioxidePercentage, incubatorDefaultCarbonDioxidePercentage,
							incubatorMaxRelativeHumidity, incubatorMinRelativeHumidity, incubatorDefaultRelativeHumidity,
							incubatorMaxShakingRate, incubatorMinShakingRate, incubatorDefaultShakingRate, incubatorShakingRadius, loadingMode
						} = Lookup[
							incubatorPacket,
							{Object, CellTypes, MaxTemperature, MinTemperature, DefaultTemperature, MaxCarbonDioxide, MinCarbonDioxide, DefaultCarbonDioxide, MaxRelativeHumidity, MinRelativeHumidity, DefaultRelativeHumidity, MaxShakingRate, MinShakingRate, DefaultShakingRate, ShakingRadius, Mode},
							Null
						];
						(*TODO: Possibly check the cellType of the samples in the container if we want to do any resolving in this function *)
						(* If no CellType is provided, assume that this is a broad check for any incubator of any CellType and set this to True.
						 If a desired CellType is provided, see if it is one of the allowed CellType for this instrument *)
						cellTypeCompatible = If[MatchQ[desiredCellType, (Null | Automatic)],
							True,
							MemberQ[incubatorCellTypes, desiredCellType]
						];

						cultureAdhesionCompatible = If[MatchQ[desiredCultureAdhesion, (Null| Automatic)],
							True,
							MemberQ[Lookup[incubatorToAllowedCultureAdhesionLookup, incubator], desiredCultureAdhesion]
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
								MatchQ[desiredRelativeHumidity, Null|Ambient],

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
								MatchQ[desiredRelativeHumidity, Null|Ambient]

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
						If[MatchQ[{cellTypeCompatible, cultureAdhesionCompatible, temperatureCompatible, carbonDioxidePercentageCompatible, relativeHumidityCompatible,
							shakingRateCompatible, shakingRadiusCompatible, prepMethodCompatible}, {True..}],
							incubator,
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
			cultureAdhesionOption,
			(temperatureOption /. {Ambient -> 22Celsius}),
			(carbonDioxidePercentageOption /. {Ambient|Null -> 0. Percent}),
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


(* ::Subsection:: *)
(*IncubateCells Resolvers *)

(*::Subsubsection::Closed:: *)
(*resolveIncubateCellsMethod and resolveIncubateCellsWorkCell*)

(* these two functions serve different purposes but are extremely similar on the inside so they are just wrappers for a shared internal function *)
DefineOptions[resolveIncubateCellsMethod,
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
	{
		listedInputs, safeOps, outputSpecification, output, cache, simulation, specifiedPreparation, specifiedWorkCell,
		incubator, time, quantificationMethod, quantificationInstrument, gatherTests, fastAssoc, inputContainers, inputSamples,
		inputInstruments, inputInstrumentModels, downloadedPacketsFromContainers, downloadedPacketsFromSamples, downloadedPacketsFromInstruments,
		downloadedPacketsFromInstrumentModels, allModelContainerPackets, allModelContainerFootprints, allInstrumentObjects,
		allInstrumentModelPackets, allFootprintsRobotCompatibleQ, allSamplePackets, roboticIncubators, manualIncubators,
		compositionCellTypes, allSampleCellTypes, optionsCellTypes, allCellTypes, allSampleCultureAdhesions, optionsCultureAdhesions,
		allSampleObjects, cultureAdhesionClause, allCultureAdhesions, workCellBasedOnCellType, incubatorCellTypes,
		workCellBasedOnIncubators, manualRequirementStrings, roboticRequirementStrings, methodResult, bioSTARRequirementStrings,
		microbioSTARRequirementStrings, workCellResult, tests
	},

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
	fastAssoc = makeFastAssocFromCache[cache];

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
		downloadedPacketsFromInstruments,
		downloadedPacketsFromInstrumentModels
	} = Quiet[
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
					Packet[Contents[[All, 2]][{CellType, CultureAdhesion, Composition}]]
				},
				{
					(* getting Model container packet from Object[Sample]*)
					Packet[Container[Model][Footprint]],
					(* getting sample packet from Object[Sample] *)
					Packet[CellType, CultureAdhesion, Composition]
				},
				(* getting the model packet from the Object[Instrument] *)
				{Packet[Model[{Mode, CellTypes}]]},
				(* getting the model packet from the Model[Instrument] *)
				{Packet[Mode, CellTypes]}
			},
			Cache -> cache,
			Simulation -> simulation
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	(* Deconvolute the Download above *)
	allModelContainerPackets = Cases[Flatten[{downloadedPacketsFromContainers, downloadedPacketsFromSamples}], PacketP[Model[Container]]];
	allSamplePackets = Cases[Flatten[{downloadedPacketsFromContainers, downloadedPacketsFromSamples}], PacketP[Object[Sample]]];
	allInstrumentModelPackets = Cases[Flatten[{downloadedPacketsFromInstruments, downloadedPacketsFromInstrumentModels}], PacketP[Model[Instrument]]];

	(* Determine if all the container model packets in question can fit on the liquid handler *)
	allModelContainerFootprints = Lookup[allModelContainerPackets, Footprint, {}];
	allFootprintsRobotCompatibleQ = MatchQ[allModelContainerFootprints, {LiquidHandlerCompatibleFootprintP..}];

	(* Determine whether we're using a robotic/manual incubator *)
	{roboticIncubators, manualIncubators} =If[MatchQ[allInstrumentModelPackets, {}],
		{{}, {}},
		{
			PickList[Join[inputInstruments, inputInstrumentModels], Lookup[allInstrumentModelPackets, Mode], Robotic],
			PickList[Join[inputInstruments, inputInstrumentModels], Lookup[allInstrumentModelPackets, Mode], Manual]
		}
	];

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
	(* In case the value from Object and option are not the same, use the option. A ConflictingCellType error will be thrown in the experiment *)
	optionsCellTypes = If[Length[allSamplePackets] > Length[ToList[Lookup[safeOps, CellType]]],
		ConstantArray[ToList[Lookup[safeOps, CellType]][[1]], Length[allSamplePackets]],
		ToList[Lookup[safeOps, CellType]]
	];
	allCellTypes = MapThread[
		If[MatchQ[#2, Mammalian|Bacterial|Yeast],
			#2,
			#1
		]&,
		{allSampleCellTypes, optionsCellTypes}
	];

	(* Get all the CultureAdhesions of the samples *)
	(* if we can't figure it out from the CultureAdhesion field, go to the Composition field.  If we can't figure it out from there, look at what was specified *)
	allSampleCultureAdhesions = Map[
		Function[{samplePacket},
			If[MatchQ[Lookup[samplePacket, CultureAdhesion], CultureAdhesionP],
				Lookup[samplePacket, CultureAdhesion],
				Null
			]
		],
		allSamplePackets
	];
	allSampleObjects = Lookup[allSamplePackets, Object];
	(* Figure out the CultureAdhesions specified in the options, then smash it all together *)
	optionsCultureAdhesions = ToList[Lookup[safeOps, CultureAdhesion]];
	allCultureAdhesions = Cases[Flatten[{allSampleCultureAdhesions, optionsCultureAdhesions}], CultureAdhesionP|Null];
	(* Build a sentence to identify which sample or specified option for which sample got SolidMedia*)
	cultureAdhesionClause = If[MemberQ[allCultureAdhesions, SolidMedia],
		(* If samples got CultureAdhesion field set to SolidMedia*)
		If[MemberQ[allSampleCultureAdhesions, SolidMedia] && !MemberQ[optionsCultureAdhesions, SolidMedia],
			StringJoin[
				"detected as SolidMedia for ",
				(* potentially collapse to all samples *)
				samplesForMessages[
					PickList[allSampleObjects, allSampleCultureAdhesions, SolidMedia],
					allSampleObjects,
					Cache -> cache,
					Simulation -> simulation
				]
			],
			(* If samples got option CultureAdhesion specified as SolidMedia *)
			StringJoin[
				"specified as SolidMedia for ",
				(* potentially collapse to all samples *)
				samplesForMessages[
					PickList[allSampleObjects, optionsCultureAdhesions, SolidMedia],
					allSampleObjects,
					Cache -> cache,
					Simulation -> simulation
				]
			]
		],
		Null
	];

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
			Which[
				MatchQ[allModelContainerFootprints, {Except[Plate]}],
					"the sample container does not have Plate footprint for Robotic incubation",
				MatchQ[allModelContainerFootprints, {Except[Plate]..}],
					"the sample containers do not have Plate footprint for Robotic incubation",
				True,
					"some of the sample containers do not have Plate footprint for Robotic incubation"
			],
			Nothing
		],
		If[MatchQ[time, GreaterP[$MaxRoboticIncubationTime]],
			"the specified Time of "<> ToString[time] <> " exceeds the maximum time (" <> ToString[$MaxRoboticIncubationTime] <> ") allowed for incubation with Robotic preparation",
			Nothing
		],
		If[MemberQ[allCultureAdhesions, SolidMedia],
			"CultureAdhesion is " <> cultureAdhesionClause <> " which requires inverting the plate that is not allowed in Robotic preparation",
			Nothing
		],
		Module[{manualOnlyValues},
			(* Mark any that do not match indexed Automatic|Custom *)
			manualOnlyValues = Select[
				ToList@Lookup[safeOps, IncubationCondition, Automatic],
				(!MatchQ[#, ListableP[Automatic|Custom]]&)
			];

			If[Length[manualOnlyValues] > 0,
				"the manual-only incubation condition(s) " <> joinClauses[manualOnlyValues] <> " are specified",
				Nothing
			]
		],
		If[Length[manualIncubators] > 0,
			(* the manualOnlyValues are actually incubators objects or models, using samplesForMessages to convert them nicely to named objects *)
			"the manual-only incubator(s) " <> samplesForMessages[manualIncubators, Cache -> cache, Simulation -> simulation] <> " are specified",
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
		If[Length[roboticIncubators] > 0,
			(* the manualOnlyValues are actually incubators objects or models, using samplesForMessages to convert them nicely to named objects *)
			"the robotic-only incubator(s) " <> samplesForMessages[roboticIncubators, Cache -> cache, Simulation -> simulation] <> " are specified",
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
		(* If we have manual/robotic requirement *)
		Length[manualRequirementStrings] > 0, Manual,
		Length[roboticRequirementStrings] > 0, Robotic,
		(* Otherwise, allow both *)
		True, {Manual, Robotic}
	];

	(* Create a list of reasons why we need WorkCell -> bioSTAR. *)
	bioSTARRequirementStrings = {
		If[MatchQ[specifiedWorkCell, bioSTAR],
			{"the WorkCell option is set to bioSTAR by the user", WorkCell},
			Nothing
		],
		If[MemberQ[optionsCellTypes, NonMicrobialCellTypeP],
			{"the specified CellType option includes a non-microbial cell type", CellType},
			Nothing
		],
		If[MatchQ[optionsCellTypes, ListableP[Automatic]] && MemberQ[allSampleCellTypes, NonMicrobialCellTypeP],
			{"the input sample(s) have a non-microbial cell type specified in the CellType field", Object},
			Nothing
		],
		If[MemberQ[incubatorCellTypes, NonMicrobialCellTypeP],
			{"the specified Incubator option includes an incubator for a non-microbial cell type", Incubator},
			Nothing
		]
	};

	(* Create a list of reasons why we need WorkCell -> microbioSTAR. *)
	microbioSTARRequirementStrings = {
		If[MatchQ[specifiedWorkCell, microbioSTAR],
			{"the WorkCell option is set to microbioSTAR by the user", WorkCell},
			Nothing
		],
		If[MemberQ[optionsCellTypes, MicrobialCellTypeP],
			{"the specified CellType option includes a microbial cell type", CellType},
			Nothing
		],
		If[MatchQ[optionsCellTypes, ListableP[Automatic]] && MemberQ[allSampleCellTypes, MicrobialCellTypeP],
			{"the input sample(s) have a microbial cell type specified in the CellType field", Object},
			Nothing
		],
		If[MemberQ[incubatorCellTypes, MicrobialCellTypeP],
			{"the specified Incubator option includes an incubator for a microbial cell type", Incubator},
			Nothing
		]
	};

	(* Throw an error if we don't have a work cell we can use *)
	(* only bother with this if we're using Robotic anyway *)
	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[MatchQ[myMethodOrWorkCell, WorkCell] && MemberQ[ToList[methodResult], Robotic] && Length[bioSTARRequirementStrings] > 0 && Length[microbioSTARRequirementStrings] > 0 && !gatherTests,
		Module[{conflictingOptions},
			conflictingOptions = Join[bioSTARRequirementStrings[[All, 2]], microbioSTARRequirementStrings[[All, 2]]];
			(* NOTE: Blocking $MessagePrePrint stops our error message from being truncated with ... if it gets too long. *)
			Block[{$MessagePrePrint},
				Message[
					Error::ConflictingIncubationWorkCells,
					If[Length[bioSTARRequirementStrings] == 1,
						StringJoin[
							"The following requirement can only be performed on a bioSTAR: ",
							bioSTARRequirementStrings[[All, 1]]
						],
						StringJoin[
							"The following requirements can only be performed on a bioSTAR:",
							listToString[bioSTARRequirementStrings[[All, 1]]]
						]
					],
					If[Length[microbioSTARRequirementStrings] == 1,
						StringJoin[
							"The following requirement can only be performed on a microbioSTAR: ",
							microbioSTARRequirementStrings[[All, 1]]
						],
						StringJoin[
							"The following requirements can only be performed on a microbioSTAR:",
							listToString[microbioSTARRequirementStrings[[All, 1]]]
						]
					],
					Which[
						MemberQ[conflictingOptions, Object] && Length[DeleteCases[conflictingOptions, Object]] == 0,
							"verify the cell type specified in the CellType field is correct",
						MemberQ[conflictingOptions, Object],
							StringJoin[
							"verify the cell type specified in the CellType field is correct and change the specified option(s) ",
								joinClauses[DeleteCases[conflictingOptions, Object]]
							],
						True,
							StringJoin[
								"change the specified option(s) ",
								joinClauses[conflictingOptions]
							]
					]
				]
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
