(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentQuantifyCells*)


DefineTests[ExperimentQuantifyCells,
	{
		Example[{Basic, "Returns a protocol to quantify the cell concentration for a list of cell samples:"},
			ExperimentQuantifyCells[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID]
				},
				Methods -> {Absorbance, Nephelometry},
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, QuantifyCells]],
				{__Rule}
			}
		],
		Example[{Basic, "Returns a robotic cell preparation protocol to quantify the cell concentration for a list of cell samples with Preparation -> Robotic:"},
			ExperimentQuantifyCells[
				{Object[Sample, "test sample 3 for ExperimentQuantifyCells "<>$SessionUUID], Object[Sample, "test sample 8 for ExperimentQuantifyCells "<>$SessionUUID]},
				Methods -> {Absorbance, Nephelometry},
				AbsorbanceBlank -> Object[Sample, "test sample 9 for ExperimentQuantifyCells "<>$SessionUUID],
				NephelometryBlank -> Object[Sample, "test sample 9 for ExperimentQuantifyCells "<>$SessionUUID],
				Preparation -> Robotic
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]]
		],
		Example[{Additional, "Correctly assign the sample labels to be the aliquot labels from previous experiment if MultiMethodAliquots is set to Shared:"},
			prot = ExperimentQuantifyCells[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID]
				},
				MultiMethodAliquots -> Shared,
				SampleLabel -> {"my original sample 1", "my original sample 2"},
				Methods -> {Nephelometry, Absorbance},
				NephelometryAliquot -> {True, False},
				NephelometryAliquotContainer -> {Model[Container, Plate, "id:n0k9mGzRaaBn"], Automatic} (* Model[Container, Plate, "96-well UV-Star Plate"] *)
			];
			Download[prot, QuantificationPrimitives][[-1]][Sample],
			{Except["my original sample 1", _String], "my original sample 2"},
			Variables :> {prot}
		],
		Test["When the child protocol aliquots, we don't propagate the newly created aliquot label upstream:",
			{prot,simulation} = ExperimentQuantifyCells[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID]
				},
				MultiMethodAliquots -> Shared,
				SampleLabel -> {"my original sample 1", "my original sample 2"},
				Methods -> {Nephelometry, Absorbance},
				NephelometryAliquot -> {True, False},
				NephelometryAliquotContainer -> {Model[Container, Plate, "id:n0k9mGzRaaBn"], Automatic}, (* Model[Container, Plate, "96-well UV-Star Plate"] *)
				Output->{Result,Simulation}
			];
			simulatedLabels=simulation[[1]][Labels][[All,1]],
			{_?(StringFreeQ[#,"aliquot sample"]&)..},
			Variables :> {prot,simulation,simulatedLabels},
			SubCategory->"Aliquot labels"
		],
		Example[{Additional, "Correctly assign the sample labels to be the input sample labels if MultiMethodAliquots is set to Individual:"},
			prot = ExperimentQuantifyCells[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID]
				},
				MultiMethodAliquots -> Individual,
				SampleLabel -> {"my original sample 1", "my original sample 2"},
				Methods -> {Nephelometry, Absorbance},
				NephelometryAliquot -> {True, False},
				NephelometryAliquotContainer -> {Model[Container, Plate, "id:n0k9mGzRaaBn"], Automatic} (* Model[Container, Plate, "96-well UV-Star Plate"] *)
			];
			Download[prot, QuantificationPrimitives][[-1]][Sample],
			{"my original sample 1", "my original sample 2"},
			Variables :> {prot}
		],
		Example[{Additional, "Create valid method primitives for shared aliquot multi method primitives:"},
			prot = ExperimentQuantifyCells[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID]
				},
				MultiMethodAliquots -> Shared,
				SampleLabel -> {"my original sample 1", "my original sample 2"},
				Methods -> {Nephelometry, Absorbance},
				NephelometryAliquot -> {True, False},
				NephelometryAliquotContainer -> {Model[Container, Plate, "id:n0k9mGzRaaBn"], Automatic} (* Model[Container, Plate, "96-well UV-Star Plate"] *)
			];
			ValidExperimentCellPreparationQ[Download[prot, QuantificationPrimitives]],
			True,
			Variables :> {prot}
		],
		Example[{Additional, "Create valid method primitives for multi method primitives with individual aliquots:"},
			prot = ExperimentQuantifyCells[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID]
				},
				MultiMethodAliquots -> Individual,
				SampleLabel -> {"my original sample 1", "my original sample 2"},
				Methods -> {Absorbance, Nephelometry},
				NephelometryAliquot -> {True, False},
				NephelometryAliquotContainer -> {Model[Container, Plate, "id:n0k9mGzRaaBn"], Automatic} (* Model[Container, Plate, "96-well UV-Star Plate"] *)
			];
			ValidExperimentCellPreparationQ[Download[prot, QuantificationPrimitives]],
			True,
			Variables :> {prot}
		],
		Example[{Additional, "Simulate composition change with proper quantification unit for each input sample after experiment:"},
			simulation = ExperimentQuantifyCells[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 7 for ExperimentQuantifyCells "<>$SessionUUID]
				},
				MultiMethodAliquots -> Individual,
				Methods -> {Nephelometry, Absorbance},
				Output -> Simulation
			];
			oldComp = Download[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 7 for ExperimentQuantifyCells "<>$SessionUUID]
				},
				Composition
			];
			simulatedComp = Download[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 7 for ExperimentQuantifyCells "<>$SessionUUID]
				},
				Composition,
				Simulation -> simulation
			];
			(* sample 1 and sample 2 gets updated accordingly, sample 7 does not b/c it has more than 1 components *)
			{simulatedComp[[1, 1, 1]], simulatedComp[[2, 1, 1]], simulatedComp[[3, All, 1]]},
			{10000 * EmeraldCell / Milliliter, 0.8 * OD600, oldComp[[3, All, 1]]},
			EquivalenceFunction -> Equal,
			Variables :> {simulation, oldComp, simulatedComp},
			Messages :> {Warning::AmbiguousAnalyte}
		],
		(*
		Example[{Additional, "Simulate volume changes correctly for each labelled sample when aliquots from previous experiment:"},
			simulation = ExperimentQuantifyCells[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID]
				},
				MultiMethodAliquots -> Shared,
				SampleLabel -> {"my original sample 1", "my original sample 2"},
				Methods -> {Nephelometry, Absorbance},
				NephelometryAliquot -> {True, False},
				NephelometryAliquotAmount -> {200 * Microliter, Automatic},
				NephelometryAliquotContainer -> {Model[Container, Plate, "id:n0k9mGzRaaBn"], Automatic}, (* Model[Container, Plate, "96-well UV-Star Plate"] *)
				AbsorbanceMethod -> PlateReader,
				AbsorbanceAliquot -> {True, True},
				AbsorbanceAliquotAmount -> 200 * Microliter,
				Output -> Simulation
			];
			Download[
				LookupLabeledObject[simulation, {"my original sample 1", "my original sample 2", "neph aliquot"}],
				Volume,
				Simulation -> simulation
			],
			{
				Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID][Volume] - 200 * Microliter,
				Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID][Volume] - 200 * Microliter,
				0 * Microliter
			},
			EquivalenceFunction -> Equal,
			Variables :> {simulation}
		],
		Example[{Additional, "Simulate volume changes correctly for each labelled sample when individual aliquots are taken from the input samples:"},
			simulation = ExperimentQuantifyCells[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID]
				},
				MultiMethodAliquots -> Individual,
				SampleLabel -> {"my original sample 1", "my original sample 2"},
				Methods -> {Nephelometry, Absorbance},
				NephelometryAliquot -> {True, False},
				NephelometryAliquotAmount -> {200 * Microliter, Automatic},
				NephelometryAliquotContainer -> {Model[Container, Plate, "id:n0k9mGzRaaBn"], Automatic}, (* Model[Container, Plate, "96-well UV-Star Plate"] *)
				AbsorbanceMethod -> PlateReader,
				AbsorbanceAliquot -> {True, True},
				AbsorbanceAliquotAmount -> 200 * Microliter,
				Output -> Simulation
			];
			Download[
				LookupLabeledObject[simulation, {"my original sample 1", "my original sample 2", "neph aliquot"}],
				Volume,
				Simulation -> simulation
			],
			{
				Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID][Volume] - 400 * Microliter,
				Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID][Volume] - 200 * Microliter,
				200 * Microliter
			},
			Variables :> {simulation}
		],
		*)
		Example[{Options, "Preparation", "Preparation is resolved to Manual if any Aliquot options is specified or needed:"},
			Lookup[
				ExperimentQuantifyCells[
					{Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID], Object[Sample, "test sample 3 for ExperimentQuantifyCells "<>$SessionUUID]},
					Methods -> {Absorbance, Nephelometry},
					AbsorbanceAliquot -> {True, Automatic},
					Output -> Options
				],
				Preparation
			],
			Manual
		],
		Example[{Options, "Preparation", "Preparation can be set to Robotic if samples are in a suitable container:"},
			Lookup[
				ExperimentQuantifyCells[
					{Object[Sample, "test sample 3 for ExperimentQuantifyCells "<>$SessionUUID], Object[Sample, "test sample 8 for ExperimentQuantifyCells "<>$SessionUUID]},
					Methods -> {Absorbance, Nephelometry},
					AbsorbanceBlank -> Object[Sample, "test sample 9 for ExperimentQuantifyCells "<>$SessionUUID],
					NephelometryBlank -> Object[Sample, "test sample 9 for ExperimentQuantifyCells "<>$SessionUUID],
					Preparation -> Robotic,
					Output -> Options
				],
				Preparation
			],
			Robotic
		],
		Test["Throw error properly if there are conflicting Preparation options:",
			ExperimentQuantifyCells[
				{Object[Sample, "test sample 3 for ExperimentQuantifyCells "<>$SessionUUID], Object[Sample, "test sample 8 for ExperimentQuantifyCells "<>$SessionUUID]},
				Methods -> {Absorbance, Nephelometry},
				Preparation -> Robotic,
				AbsorbanceBlank -> Object[Sample, "test sample 9 for ExperimentQuantifyCells "<>$SessionUUID],
				NephelometryBlank -> Object[Sample, "test sample 9 for ExperimentQuantifyCells "<>$SessionUUID],
				NephelometryAliquot -> {True, Automatic},
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::ConflictingMethodRequirements, Error::InvalidOption}
		],
		Example[{Options, "WorkCell", "WorkCell is resolved to Null if Preparation is not Robotic:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Wavelength -> 600 * Nanometer,
					Preparation -> Manual,
					Output -> Options
				],
				WorkCell
			],
			Null
		],
		Example[{Options, "WorkCell", "WorkCell is resolved to a proper workcell if Preparation is Robotic:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 3 for ExperimentQuantifyCells "<>$SessionUUID],
					Wavelength -> 600 * Nanometer,
					AbsorbanceBlank -> Object[Sample, "test sample 9 for ExperimentQuantifyCells "<>$SessionUUID],
					Preparation -> Robotic,
					Output -> Options
				],
				WorkCell
			],
			WorkCellP
		],

		Example[{Options, "Methods", "Methods include Absorbance and Nephelometry if any Absorbance or Nephelometry options are set:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Wavelength -> 600 * Nanometer,
					NephelometryAliquot -> True,
					Output -> Options
				],
				Methods
			],
			{Absorbance, Nephelometry}
		],
		Example[{Options, "Methods", "Methods include Absorbance if Instruments include plate reader or spectrophotometer:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Instruments -> Object[Instrument, PlateReader, "test plate reader 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Output -> Options
				],
				Methods
			],
			Absorbance
		],
		Example[{Options, "Methods", "Methods include Nephelometry if Instruments include nephelometer:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Instruments -> Object[Instrument, Nephelometer, "test nephelometer 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Output -> Options
				],
				Methods
			],
			Nephelometry
		],
		Example[{Options, "Methods", "Methods include the instrumentation that can directly measure the QuantificationUnit:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					QuantificationUnit -> "OD600",
					Output -> Options
				],
				Methods
			],
			Absorbance
		],
		Example[{Options, "Methods", "Methods defaults to include the instrumentation where there exists a standard curve to convert to the desired QuantificationUnit:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					QuantificationUnit -> "EmeraldCell/Milliliter",
					Output -> Options
				],
				Methods
			],
			Nephelometry
		],
		Example[{Options, "Methods", "Methods defaults to include Absorbance if there does not exist a standard curve to convert to the desired QuantificationUnit:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID],
					QuantificationUnit -> "EmeraldCell/Milliliter",
					Output -> Options
				],
				Methods
			],
			Absorbance,
			Messages :> {Warning::NoStandardCurveCoefficientAvailable}
		],
		Example[{Options, "Methods", "If a method-specific required options is specified to Null, exclude it from resolved Methods:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					AbsorbanceAliquot -> Null,
					Output -> Options
				],
				Methods
			],
			Nephelometry
		],
		Example[{Options, "Instruments", "Instruments include the plate reader/spectrometer for Absorbance, and nephelometer for Nephelometry Methods:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID],
					Methods -> {Nephelometry, Absorbance},
					Output -> Options
				],
				Instruments
			],
			{
				ObjectP[{Model[Instrument, Nephelometer]}],
				ObjectP[{Model[Instrument, PlateReader], Model[Instrument, Spectrophotometer]}]
			}
		],
		Example[{Options, "Instruments", "Instruments set to the same instrument object used by the standard curve:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 3 for ExperimentQuantifyCells "<>$SessionUUID],
					Methods -> {Nephelometry, Absorbance},
					Output -> Options
				],
				Instruments
			],
			{
				_,
				ObjectP[{Object[Instrument, PlateReader, "test plate reader 1 for ExperimentQuantifyCells "<>$SessionUUID]}]
			}
		],
		Example[{Options, "QuantificationUnit", "QuantificationUnit set to \"EmeraldCell/Milliliter\" if standard curve exists to convert the raw experimental result to Cell/mL:"},
			Lookup[
				ExperimentQuantifyCells[
					{
						Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
						Object[Sample, "test sample 3 for ExperimentQuantifyCells "<>$SessionUUID]
					},
					Methods -> {Nephelometry, Absorbance},
					Output -> Options
				],
				{NephelometryStandardCurve, QuantificationUnit}
			],
			{
				{ObjectP[Object[Analysis, StandardCurve, "test standard curve 1 RNU to Cell/mL for ExperimentQuantifyCells "<>$SessionUUID]], Null},
				"EmeraldCell/Milliliter"
			}
		],
		Example[{Options, "QuantificationUnit", "QuantificationUnit set to raw experimental unit if there does not exist a standard curve to covert to Cell/mL:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID],
					Methods -> Absorbance,
					Output -> Options
				],
				QuantificationUnit
			],
			"OD600"
		],
		Example[{Options, "AbsorbanceBlankMeasurement", "The masterswitch for blank measurement is preresolved to False if any blank measurement option is specified to Null:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID],
					Methods -> Absorbance,
					AbsorbanceBlank -> Null,
					Output -> Options
				],
				AbsorbanceBlankMeasurement
			],
			False
		],
		Example[{Options, "NephelometryBlankMeasurement", "The masterswitch for blank measurement is preresolved to False if any blank measurement option is specified to Null:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID],
					Methods -> Nephelometry,
					NephelometryBlankVolume -> Null,
					Output -> Options
				],
				NephelometryBlankMeasurement
			],
			False,
			Messages :> {Warning::NoStandardCurveCoefficientAvailable}
		],
		Example[{Options, "AbsorbanceStandardCurve", "AbsorbanceStandardCurve is set to a curve that can be used to convert from the raw experimental unit to QuantificationUnit:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 3 for ExperimentQuantifyCells "<>$SessionUUID],
					Methods -> Absorbance,
					QuantificationUnit -> "EmeraldCell/Milliliter",
					Output -> Options
				],
				AbsorbanceStandardCurve
			],
			ObjectP[Object[Analysis, StandardCurve, "test standard curve 2 OD600 to Cell/mL for ExperimentQuantifyCells "<>$SessionUUID]]
		],
		Example[{Options, "NephelometryStandardCurve", "NephelometryStandardCurve is set to a curve that can be used to convert from the raw experimental unit to QuantificationUnit:"},
			Lookup[
				ExperimentQuantifyCells[
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Methods -> Nephelometry,
					QuantificationUnit -> "EmeraldCell/Milliliter",
					Output -> Options
				],
				NephelometryStandardCurve
			],
			ObjectP[Object[Analysis, StandardCurve, "test standard curve 1 RNU to Cell/mL for ExperimentQuantifyCells "<>$SessionUUID]]
		],
		Example[{Options, "MultiMethodAliquots", "When setting MultiMethodAliquots to be Shared to share aliquots, second aliquot master switch is set to False if sample has already been aliquotted to a suitable container model in the previous experiment aliquotting step:"},
			Lookup[
				ExperimentQuantifyCells[
					{Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID], Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID]},
					MultiMethodAliquots -> Shared,
					Methods -> {Nephelometry, Absorbance},
					NephelometryAliquotContainer -> Model[Container, Plate, "id:n0k9mGzRaaBn"], (* Model[Container, Plate, "96-well UV-Star Plate"] *)
					AbsorbanceMethod -> PlateReader,
					Output -> Options
				],
				AbsorbanceAliquot
			],
			False
		],
		Example[{Options, "MultiMethodAliquots", "When setting MultiMethodAliquots to be Individual to avoid sharing aliquots, second aliquot master switch is set to True if sample needs to be transferred to an instrument-compatible container type:"},
			Lookup[
				ExperimentQuantifyCells[
					{Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID], Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID]},
					MultiMethodAliquots -> Individual,
					Methods -> {Nephelometry, Absorbance},
					NephelometryAliquotContainer -> Model[Container, Plate, "id:n0k9mGzRaaBn"], (* Model[Container, Plate, "96-well UV-Star Plate"] *)
					AbsorbanceMethod -> PlateReader,
					Output -> Options
				],
				AbsorbanceAliquot
			],
			True
		],
		Example[{Options, "NumberOfReplicates", "Generate a protocol and correctly simulate aliquots when specified a NumberOfReplicates:"},
			protocol = ExperimentQuantifyCells[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCells " <> $SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCells " <> $SessionUUID]
				},
				Methods -> {Nephelometry, Absorbance},
				NumberOfReplicates -> 2
			];
			primitives = Download[protocol, QuantificationPrimitives];
			(* check the primitives resolved options. *)
			(* We kinda have to check it this way since these labels don't get propogated upstream, and the resolved primitive options is hidden option. *)
			Lookup[#[[1]], AliquotSampleLabel, Nothing] & /@ primitives,
			(* Nephelometry has 4 aliquot in total, and Absorbance reuses them by default *)
			{
				{_String, _String, _String, _String},
				{Null, Null, Null, Null}
			},
			Variables :> {protocol, primitives}
		],

		Example[{Messages, "DiscardedSamples", "If the provided sample is discarded, an error will be thrown:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 4 for ExperimentQuantifyCells "<>$SessionUUID],
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DeprecatedModels", "If the provided sample has a Deprecated model, an error will be thrown:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 5 for ExperimentQuantifyCells "<>$SessionUUID],
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages, "NonLiquidSamples", "If the provided sample is not Liquid, an error will be thrown:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 6 for ExperimentQuantifyCells "<>$SessionUUID],
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {
				Error::NonLiquidSample,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DuplicatedMethods", "If a quantification method is specified more than once, an error will be thrown:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
				Methods -> {Absorbance, Absorbance, Nephelometry},
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {
				Error::DuplicatedMethods,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NoQuantifyCellsMethodToUse", "If Methods is not specified, while there are specified Nulls in required options for both Absorbance and Nephelometry, an error will be thrown:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 1 for ExperimentQuantifyCells " <> $SessionUUID],
				NephelometryAliquot -> Null,
				AbsorbanceAliquot -> Null,
				Output -> {Result, Options}],
			{$Failed, {__Rule}},
			Messages :> {
				Error::NoQuantifyCellsMethodToUse,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingMethodOptions", "Methods and method-specific options are compatible. If a method is specified, its required method-specific options cannot be specified as Null:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
				Methods -> Nephelometry, BeamAperture -> Null
			],
			$Failed,
			Messages :> {
				Error::Pattern,
				Error::ConflictingMethodOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingMethodOptions", "Methods and method-specific options are compatible. If Methods is specified to not include a method, the required method-specific options of this excluded method cannot be specified as not Null:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
				Methods -> {Absorbance},
				NephelometryAliquot -> True,
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {
				Error::ConflictingMethodOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingMethodOptions", "Methods and method-specific options are compatible. If in conflict with the specifid methods, method-specific standard curve and standard coefficient options also trigger the error:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 1 for ExperimentQuantifyCells " <> $SessionUUID],
				Methods -> Absorbance,
				QuantificationUnit -> "EmeraldCell/Milliliter",
				NephelometryStandardCurve -> Object[Analysis, StandardCurve, "test standard curve 3 AbsorbanceUnit to Cell/mL for ExperimentQuantifyCells " <> $SessionUUID],
				Output -> {Result, Options}],
			{$Failed, {__Rule}},
			Messages :> {
				Error::ConflictingMethodOptions,
				Warning::NoStandardCurveCoefficientAvailable,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NoStandardCurveCoefficientAvailable", "Throw a warning if we cannot find a standard curve that converts the raw experimental result to the target quantification unit:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID],
				Methods -> Absorbance,
				QuantificationUnit -> "EmeraldCell/Milliliter",
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, QuantifyCells]], {__Rule}},
			Messages :> {Warning::NoStandardCurveCoefficientAvailable}
		],
		Example[{Messages, "AlternativeStandardCurveAvailable", "Throw a warning if the specified standard curve can not convert the raw experimental result to the target quantification unit becuase it fails the instrument and wavelength check for Absorbance method, but we found an alternative:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 1 for ExperimentQuantifyCells " <> $SessionUUID],
				Methods -> Absorbance,
				QuantificationUnit -> "EmeraldCell/Milliliter",
				AbsorbanceStandardCurve -> Object[Analysis, StandardCurve, "test standard curve 3 AbsorbanceUnit to Cell/mL for ExperimentQuantifyCells " <> $SessionUUID],
				Wavelength -> 600 Nanometer, (* Specified standard curve's protocol has 500nm *)
				Instruments -> Model[Instrument, Spectrophotometer, "id:01G6nvwR99K1"],(* Specified standard curve's protocol is using a plate reader *)
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, QuantifyCells]], {__Rule}},
			Messages :> {Warning::NoStandardCurveCoefficientAvailable}
		],
		Example[{Messages, "AlternativeStandardCurveAvailable", "Throw a warning if the specified standard curve can not convert the raw experimental result to the target quantification unit but we found an alternative:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
				Methods -> Nephelometry,
				QuantificationUnit -> "EmeraldCell/Milliliter",
				NephelometryStandardCurve -> Object[Analysis, StandardCurve, "test standard curve 2 OD600 to Cell/mL for ExperimentQuantifyCells "<>$SessionUUID],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, QuantifyCells]], {__Rule}},
			Messages :> {Warning::AlternativeStandardCurveAvailable}
		],
		Example[{Messages, "RedundantStandardCurve", "Throw a warning if we do not need a standard curve to convert to the quantification unit:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
				Methods -> Absorbance,
				QuantificationUnit -> "OD600",
				AbsorbanceStandardCurve -> Object[Analysis, StandardCurve, "test standard curve 2 OD600 to Cell/mL for ExperimentQuantifyCells "<>$SessionUUID],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, QuantifyCells]], {__Rule}},
			Messages :> {Warning::RedundantStandardCurve}
		],
		Example[{Messages, "RecoupContamination", "Throw a warning if RecoupSample is set to True while input sample contain cell samples:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
				RecoupSample -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, QuantifyCells]], {__Rule}},
			Messages :> {Warning::RecoupContamination}
		],
		Example[{Messages, "MissingQuantificationUnit", "Throw an error if StandardCoefficient is specified but QuantificationUnit is not:"},
			ExperimentQuantifyCells[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID]
				},
				Methods -> {Nephelometry, Absorbance},
				AbsorbanceStandardCoefficient -> {Null, 100},
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {
				Error::MissingQuantificationUnit,
				Error::InvalidOption
			}
		],

		(* ODNE tests *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentQuantifyCells[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentQuantifyCells[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentQuantifyCells[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentQuantifyCells[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Plate, "96-well UV-Star Plate"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					{{0.2 * OD600, Model[Cell, Bacteria, "test cell model 1 for ExperimentQuantifyCells "<>$SessionUUID]}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}, (* Model[Molecule, "Water"] *)
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 20 Milliliter,
					Living -> True,
					Status -> Available,
					State -> Liquid
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentQuantifyCells[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Plate, "96-well UV-Star Plate"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					{{0.2 * OD600, Model[Cell, Bacteria, "test cell model 1 for ExperimentQuantifyCells "<>$SessionUUID]}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}, (* Model[Molecule, "Water"] *)
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 20 Milliliter,
					Living -> True,
					Status -> Available,
					State -> Liquid
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentQuantifyCells[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],

		(* resolveAliquotOptions tests *)
		Example[{Messages, "AliquotOptionMismatch", "Methods and method-specific aliquot options are compatible. If Methods is specified to include a method and aliquot is required, the required method-specific aliquot options cannot be specified as not Null:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
				Methods -> {Absorbance, Nephelometry},
				AbsorbanceAliquotContainer -> Null,
				NephelometryDestinationWell -> Null,
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {
				Error::AliquotOptionMismatch,
				Error::AliquotOptionMismatch
			}
		],

		(* Plate reader temperature equilibration time test*)
		Example[{Messages, "TemperatureNoEquilibration", "A warning will be shown if AcquisitionTemperature is set above Ambient and EquilibrationTime is set to zero for Absorbance and Nephelometry:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
				Methods -> {Absorbance, Nephelometry},
				AbsorbanceAcquisitionTemperature -> 30 Celsius,
				AbsorbanceEquilibrationTime -> 0 Minute,
				Output -> Options
			],
			{__Rule},
			Messages :> {
				Warning::TemperatureNoEquilibration
			}
		],
		Example[{Additional, "A protocol can be generated with warning if there is no standard curve either specified or found for the cell:"},
			ExperimentQuantifyCells[
				Object[Sample, "test sample 10 for ExperimentQuantifyCells "<>$SessionUUID],
				Methods -> Nephelometry,
				QuantificationUnit -> "OD600"
			],
			ObjectP[Object[Protocol, QuantifyCells]],
			Messages :> {Warning::NoStandardCurveCoefficientAvailable}
		]
	},
	SetUp :> {
		$CreatedObjects = {};
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::DeprecatedProduct];
		Off[Warning::SampleMustBeMoved];
		Off[Warning::AliquotRequired];
	},
	TearDown :> {
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::DeprecatedProduct];
		On[Warning::SampleMustBeMoved];
		On[Warning::AliquotRequired];
	},
	SymbolSetUp :> {
		experimentQuantifyCellsTestCleanup[];

		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{
					testBench, modelCell1, modelCell2, modelCell3, sampleModel1,
					sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10,
					container1, container2, container3, container4, container5, container6, container7, container8, container9, container10,
					plateReader, nephelometer, liquidHandler, stdCurve1, stdCurve2, stdCurve3,
					absProtocol1, absProtocol2, nephProtocol1, tubingIDs, valveIDs
				},
				(* reserve id for a list of objects we are going to create *)
				{
					testBench,
					modelCell1,
					modelCell2,
					modelCell3,
					sample1,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					sample9,
					sample10,
					sampleModel1,
					container1,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7,
					container8,
					container9,
					container10,
					plateReader,
					nephelometer,
					liquidHandler,
					stdCurve1,
					stdCurve2,
					stdCurve3,
					absProtocol1,
					absProtocol2,
					nephProtocol1
				} = CreateID[{
					Object[Container, Bench],
					Model[Cell, Bacteria],
					Model[Cell, Bacteria],
					Model[Cell, Bacteria],
					Object[Sample],
					Object[Sample],
					Object[Sample],
					Object[Sample],
					Object[Sample],
					Object[Sample],
					Object[Sample],
					Object[Sample],
					Object[Sample],
					Object[Sample],
					Model[Sample],
					Object[Container, Vessel],
					Object[Container, Vessel],
					Object[Container, Plate],
					Object[Container, Plate],
					Object[Container, Plate],
					Object[Container, Vessel],
					Object[Container, Vessel],
					Object[Container, Plate],
					Object[Container, Plate],
					Object[Container, Vessel],
					Object[Instrument, PlateReader],
					Object[Instrument, Nephelometer],
					Object[Instrument, LiquidHandler],
					Object[Analysis, StandardCurve],
					Object[Analysis, StandardCurve],
					Object[Analysis, StandardCurve],
					Object[Protocol, AbsorbanceIntensity],
					Object[Protocol, AbsorbanceIntensity],
					Object[Protocol, Nephelometry]
				}];

				(* create bench, model cells, instruments etc *)
				tubingIDs = CreateID[ConstantArray[Object[Plumbing, Tubing], 4]];
				valveIDs = CreateID[ConstantArray[Object[Plumbing, Valve], 3]];
				Upload[{
					<|
						Object -> testBench,
						Name -> "test bench for ExperimentQuantifyCells "<>$SessionUUID,
						Model -> Link[Model[Container, Bench, "id:bq9LA0JlA7Ad"], Objects], (* Model[Container, Bench, "The Bench of Testing"] *)
						Site -> Link[$Site]
					|>,
					<|
						Object -> modelCell1,
						Name -> "test cell model 1 for ExperimentQuantifyCells "<>$SessionUUID,
						CellType -> Bacterial,
						Replace[StandardCurves] -> {Link[stdCurve1]},
						Replace[StandardCurveProtocols] -> {Link[nephProtocol1]}
					|>,
					<|
						Object -> modelCell2,
						Name -> "test cell model 2 for ExperimentQuantifyCells "<>$SessionUUID,
						CellType -> Bacterial
					|>,
					<|
						Object -> modelCell3,
						Name -> "test cell model 3 for ExperimentQuantifyCells "<>$SessionUUID,
						CellType -> Bacterial,
						Replace[StandardCurves] -> {Link[stdCurve2]},
						Replace[StandardCurveProtocols] -> {Link[absProtocol1]}
					|>,
					<|
						Object -> liquidHandler,
						Name -> "test liquid handler 1 for ExperimentQuantifyCells "<>$SessionUUID,
						Model -> Link[Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"], Objects] (* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
					|>,
					<|
						Object -> plateReader,
						Name -> "test plate reader 1 for ExperimentQuantifyCells "<>$SessionUUID,
						Model -> Link[Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"], Objects], (* Model[Instrument, PlateReader, "CLARIOstar Plus with ACU"] *)
						Site -> Link[$Site],
						IntegratedLiquidHandler -> Link[liquidHandler, IntegratedPlateReader]
					|>,
					<|
						Object -> nephelometer,
						Name -> "test nephelometer 1 for ExperimentQuantifyCells "<>$SessionUUID,
						Model -> Link[Model[Instrument, Nephelometer, "id:J8AY5jDLZN8Z"], Objects], (* Model[Instrument, Nephelometer, "NEPHELOstar Plus"] *)
						Replace[ConnectedPlumbing] -> {
							Link[valveIDs[[1]], ConnectedLocation],
							Link[tubingIDs[[1]], ConnectedLocation],
							Link[tubingIDs[[2]], ConnectedLocation],
							Link[valveIDs[[2]], ConnectedLocation],
							Link[tubingIDs[[3]], ConnectedLocation],
							Link[tubingIDs[[4]], ConnectedLocation],
							Link[valveIDs[[3]], ConnectedLocation]
						},
						Site -> Link[$Site],
						IntegratedLiquidHandler -> Link[liquidHandler, IntegratedNephelometer]
					|>,
					<|
						Object -> absProtocol1,
						Name -> "test abs intensity protocol 1 for ExperimentQuantifyCells "<>$SessionUUID,
						Instrument -> Link[plateReader]
					|>,
					<|
						Object -> absProtocol2,
						Name -> "test abs intensity protocol 2 for ExperimentQuantifyCells "<>$SessionUUID,
						Instrument -> Link[plateReader],
						Replace[Wavelengths] -> {500 Nanometer}
					|>,
					<|
						Object -> nephProtocol1,
						Name -> "test neph protocol 1 for ExperimentQuantifyCells "<>$SessionUUID,
						Instrument -> Link[nephelometer]
					|>,
					<|
						Object -> stdCurve1,
						Name -> "test standard curve 1 RNU to Cell/mL for ExperimentQuantifyCells "<>$SessionUUID,
						BestFitFunction -> QuantityFunction[#^2&, RelativeNephelometricUnit, EmeraldCell / Milliliter],
						Replace[StandardDataUnits] -> {RelativeNephelometricUnit, EmeraldCell / Milliliter},
						Protocol -> Link[nephProtocol1]
					|>,
					<|
						Object -> stdCurve2,
						Name -> "test standard curve 2 OD600 to Cell/mL for ExperimentQuantifyCells "<>$SessionUUID,
						BestFitFunction -> QuantityFunction[#^2&, OD600, EmeraldCell / Milliliter],
						Replace[StandardDataUnits] -> {OD600, EmeraldCell / Milliliter},
						Protocol -> Link[absProtocol1]
					|>,
					<|
						Object -> stdCurve3,
						Name -> "test standard curve 3 AbsorbanceUnit to Cell/mL for ExperimentQuantifyCells "<>$SessionUUID,
						BestFitFunction -> QuantityFunction[#^2&, AbsorbanceUnit, EmeraldCell / Milliliter],
						Replace[StandardDataUnits] -> {AbsorbanceUnit, EmeraldCell / Milliliter},
						Protocol -> Link[absProtocol2]
					|>,
					<|
						Object -> sampleModel1,
						Name -> "test sample model 1 for ExperimentQuantifyCells "<>$SessionUUID,
						Replace[Composition] -> {
							{1000 * EmeraldCell / Milliliter, Link[modelCell2]},
							{100 * VolumePercent, Link[Model[Molecule, "id:vXl9j57PmP5D"]]}
						},
						Deprecated -> True,
						DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]] (* Model[StorageCondition, "Ambient Storage"] *)
					|>
				}];

				(* make container *)
				UploadSample[
					{
						Model[Container, Vessel, "id:bq9LA0dBGGR6"], (* Model[Container, Vessel, "50mL Tube"] *)
						Model[Container, Vessel, "id:bq9LA0dBGGR6"], (* Model[Container, Vessel, "50mL Tube"] *)
						Model[Container, Plate, "id:n0k9mGzRaaBn"], (* Model[Container, Plate, "96-well UV-Star Plate"] *)
						Model[Container, Plate, "id:n0k9mGzRaaBn"], (* Model[Container, Plate, "96-well UV-Star Plate"] *)
						Model[Container, Plate, "id:n0k9mGzRaaBn"], (* Model[Container, Plate, "96-well UV-Star Plate"] *)
						Model[Container, Vessel, "id:bq9LA0dBGGR6"], (* Model[Container, Vessel, "50mL Tube"] *)
						Model[Container, Vessel, "id:bq9LA0dBGGR6"], (* Model[Container, Vessel, "50mL Tube"] *)
						Model[Container, Plate, "id:n0k9mGzRaaBn"], (* Model[Container, Plate, "96-well UV-Star Plate"] *)
						Model[Container, Plate, "id:n0k9mGzRaaBn"], (* Model[Container, Plate, "96-well UV-Star Plate"] *)
						Model[Container, Vessel, "id:bq9LA0dBGGR6"] (* Model[Container, Vessel, "50mL Tube"] *)
					},
					{
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench}
					},
					Name -> {
						"test container 1 for ExperimentQuantifyCells "<>$SessionUUID,
						"test container 2 for ExperimentQuantifyCells "<>$SessionUUID,
						"test container 3 for ExperimentQuantifyCells "<>$SessionUUID,
						"test container 4 for ExperimentQuantifyCells "<>$SessionUUID,
						"test container 5 for ExperimentQuantifyCells "<>$SessionUUID,
						"test container 6 for ExperimentQuantifyCells "<>$SessionUUID,
						"test container 7 for ExperimentQuantifyCells "<>$SessionUUID,
						"test container 8 for ExperimentQuantifyCells "<>$SessionUUID,
						"test container 9 for ExperimentQuantifyCells "<>$SessionUUID,
						"test container 10 for ExperimentQuantifyCells "<>$SessionUUID
					},
					ID -> Download[{
						container1,
						container2,
						container3,
						container4,
						container5,
						container6,
						container7,
						container8,
						container9,
						container10
					}, ID]
				];

				(* make sample *)
				UploadSample[
					{
						{{0.2 * OD600, modelCell1}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}, (* Model[Molecule, "Water"] *)
						{{1000 * EmeraldCell / Milliliter, modelCell2}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}, (* Model[Molecule, "Water"] *)
						{{0.8 * OD600, modelCell3}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}, (* Model[Molecule, "Water"] *)
						{{1000 * EmeraldCell / Milliliter, modelCell2}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}, (* Model[Molecule, "Water"] *)
						sampleModel1,
						{{1000 * EmeraldCell / Milliliter, modelCell2}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}},
						{{0.2 * OD600, modelCell1}, {1000 * EmeraldCell / Milliliter, modelCell2}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}},
						{{0.8 * OD600, modelCell3}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}, (* Model[Molecule, "Water"] *)
						Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
						{{1000 * EmeraldCell / Milliliter, modelCell2}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}
					},
					{
						{"A1", container1},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7},
						{"A1", container8},
						{"A1", container9},
						{"A1", container10}
					},
					Name -> {
						"test sample 1 for ExperimentQuantifyCells "<>$SessionUUID,
						"test sample 2 for ExperimentQuantifyCells "<>$SessionUUID,
						"test sample 3 for ExperimentQuantifyCells "<>$SessionUUID,
						"test sample 4 for ExperimentQuantifyCells "<>$SessionUUID,
						"test sample 5 for ExperimentQuantifyCells "<>$SessionUUID,
						"test sample 6 for ExperimentQuantifyCells "<>$SessionUUID,
						"test sample 7 for ExperimentQuantifyCells "<>$SessionUUID,
						"test sample 8 for ExperimentQuantifyCells "<>$SessionUUID,
						"test sample 9 for ExperimentQuantifyCells "<>$SessionUUID,
						"test sample 10 for ExperimentQuantifyCells "<>$SessionUUID
					},
					ID -> Download[{
						sample1,
						sample2,
						sample3,
						sample4,
						sample5,
						sample6,
						sample7,
						sample8,
						sample9,
						sample10
					}, ID],
					Living -> True,
					Status -> Available,
					State -> {
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Solid,
						Liquid,
						Liquid,
						Liquid,
						Liquid
					},
					InitialAmount -> {
						20 * Milliliter,
						20 * Milliliter,
						200 * Microliter,
						200 * Microliter,
						200 * Microliter,
						0.5 * Gram,
						20 * Milliliter,
						200 * Microliter,
						200 * Microliter,
						20 Milliliter
					}
				];

				(* further updates to samples *)
				UploadSampleStatus[sample4, Discarded, Force -> True];
				UploadLocation[sample4, Waste, FastTrack->True];
			]
		]
	},
	SymbolTearDown :> {
		experimentQuantifyCellsTestCleanup[];
	}
];


experimentQuantifyCellsTestCleanup[] := Module[{objects, objectsExistQ},
	(* List all test objects to erase. Can use SetUpTestObjects[]+ObjectToString[] to get the comprehensive list. *)
	objects = {
		Object[Container, Bench, "test bench for ExperimentQuantifyCells "<>$SessionUUID],
		Model[Cell, Bacteria, "test cell model 1 for ExperimentQuantifyCells "<>$SessionUUID],
		Model[Cell, Bacteria, "test cell model 2 for ExperimentQuantifyCells "<>$SessionUUID],
		Model[Cell, Bacteria, "test cell model 3 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Sample, "test sample 1 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Sample, "test sample 2 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Sample, "test sample 3 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Sample, "test sample 4 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Sample, "test sample 5 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Sample, "test sample 6 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Sample, "test sample 7 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Sample, "test sample 8 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Sample, "test sample 9 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Sample, "test sample 10 for ExperimentQuantifyCells "<>$SessionUUID],
		Model[Sample, "test sample model 1 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Container, Vessel, "test container 1 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Container, Vessel, "test container 2 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Container, Plate, "test container 3 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Container, Plate, "test container 4 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Container, Plate, "test container 5 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Container, Vessel, "test container 6 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Container, Vessel, "test container 7 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Container, Plate, "test container 8 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Container, Plate, "test container 9 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Container, Vessel, "test container 10 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Instrument, PlateReader, "test plate reader 1 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Instrument, Nephelometer, "test nephelometer 1 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Instrument, LiquidHandler, "test liquid handler 1 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Analysis, StandardCurve, "test standard curve 1 RNU to Cell/mL for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Analysis, StandardCurve, "test standard curve 2 OD600 to Cell/mL for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Analysis, StandardCurve, "test standard curve 3 AbsorbanceUnit to Cell/mL for ExperimentQuantifyCells " <> $SessionUUID],
		Object[Protocol, AbsorbanceIntensity, "test abs intensity protocol 1 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Protocol, AbsorbanceIntensity, "test abs intensity protocol 2 for ExperimentQuantifyCells "<>$SessionUUID],
		Object[Protocol, Nephelometry, "test neph protocol 1 for ExperimentQuantifyCells "<>$SessionUUID]
	};

	(* Check whether the names we want to give below already exist in the database *)
	objectsExistQ = DatabaseMemberQ[objects];

	(* Erase any objects that we failed to erase in the last unit test. *)
	Quiet[EraseObject[PickList[objects, objectsExistQ], Force -> True, Verbose -> False]]
];




(* ::Subsection:: *)
(*QuantifyCells*)


DefineTests[QuantifyCells,
	{
		Example[{Basic, "Returns a MCP protocol to quantify the cell concentration for a list of cell samples:"},
			ExperimentCellPreparation[
				{
					LabelSample[
						Sample -> {
							Object[Sample, "test sample 1 for QuantifyCells "<>$SessionUUID],
							Object[Sample, "test sample 2 for QuantifyCells "<>$SessionUUID]
						},
						Label -> {
							"my sample 1",
							"my sample 2"
						}
					],
					QuantifyCells[
						Sample -> {
							"my sample 1",
							"my sample 2"
						},
						Methods -> {Absorbance, Nephelometry}
					]
				}
			],
			ObjectP[Object[Protocol, ManualCellPreparation]]
		],
		Example[{Basic, "Returns a RCP protocol to quantify the cell concentration for a list of cell samples with Preparation -> Robotic:"},
			ExperimentCellPreparation[
				{
					LabelContainer[
						Container -> Object[Container, Plate, "test container 3 for QuantifyCells "<>$SessionUUID],
						Label -> "test plate"
					],
					Transfer[
						Source -> Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
						Destination -> "test plate",
						DestinationWell -> "A3",
						Amount -> 200 * Microliter,
						DestinationLabel -> "blank sample"
					],
					QuantifyCells[
						Sample -> {Object[Sample, "test sample 3 for QuantifyCells "<>$SessionUUID], Object[Sample, "test sample 4 for QuantifyCells "<>$SessionUUID]},
						Methods -> {Absorbance, Nephelometry},
						AbsorbanceBlank -> "blank sample",
						NephelometryBlank -> "blank sample",
						Preparation -> Robotic
					]
				}
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]]
		],
		Example[{Basic, "Enqueue a series of primitives:"},
			ExperimentCellPreparation[
				{
					LabelSample[
						Sample -> {
							Object[Sample, "test sample 1 for QuantifyCells "<>$SessionUUID],
							Object[Sample, "test sample 2 for QuantifyCells "<>$SessionUUID]
						},
						Label -> {
							"my sample 1",
							"my sample 2"
						}
					],
					LabelContainer[
						Container -> {
							Model[Container, Plate, "96-well Greiner Tissue Culture Plate, Untreated"]
						},
						Label -> {
							"my plate"
						}
					],
					Transfer[
						Source -> {"my sample 1", "my sample 2"},
						Destination -> {"my plate", "my plate"},
						DestinationWell -> {"A1", "A2"},
						Amount -> {200 * Microliter, 200 * Microliter},
						SterileTechnique -> True,
						DestinationLabel -> {"my sample 1 on plate", "my sample 2 on plate"},
						ImageSample->False,
						MeasureVolume->False,
						MeasureWeight->False
					],
					QuantifyCells[
						Sample -> {"my sample 1 on plate", "my sample 2 on plate"},
						Methods -> {Absorbance, Nephelometry}
					]
				}
			],
			ObjectP[Object[Protocol, ManualCellPreparation]]
		],
		Example[{Basic, "Cannot run as Sample Prep Primitives b/c this is a Cell Prep only function:"},
			ExperimentSamplePreparation[
				{
					LabelSample[
						Sample -> {
							Object[Sample, "test sample 1 for QuantifyCells "<>$SessionUUID],
							Object[Sample, "test sample 2 for QuantifyCells "<>$SessionUUID]
						},
						Label -> {
							"my sample 1",
							"my sample 2"
						}
					],
					LabelContainer[
						Container -> {
							Model[Container, Plate, "id:n0k9mGzRaaBn"]
						},
						Label -> {
							"my plate"
						}
					],
					Transfer[
						Source -> {"my sample 1", "my sample 2"},
						Destination -> {"my plate", "my plate"},
						DestinationWell -> {"A1", "A2"},
						Amount -> {200 * Microliter, 200 * Microliter},
						SterileTechnique -> True,
						DestinationLabel -> {"my sample 1 on plate", "my sample 2 on plate"}
					],
					QuantifyCells[
						Sample -> {"my sample 1 on plate", "my sample 2 on plate"},
						Methods -> {Absorbance, Nephelometry}
					]
				}
			],
			$Failed,
			Messages :> {
				Error::InvalidUnitOperationHeads,
				Error::InvalidInput
			},
			TimeConstraint -> 1000
		],
		Example[{Basic, "Any potential issues with provided inputs/options will be displayed:"},
			ExperimentCellPreparation[{
				QuantifyCells[
					Sample -> Object[Sample, "test sample 1 for QuantifyCells "<>$SessionUUID],
					Methods -> {Absorbance, Absorbance, Nephelometry}
				]
			}],
			$Failed,
			Messages :> {Error::DuplicatedMethods, Error::InvalidInput}
		]
	},
	SetUp :> {
		$CreatedObjects = {};
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::DeprecatedProduct];
		Off[Warning::SampleMustBeMoved];
		Off[Warning::AliquotRequired];
	},
	TearDown :> {
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::DeprecatedProduct];
		On[Warning::SampleMustBeMoved];
		On[Warning::AliquotRequired];
	},
	SymbolSetUp :> {
		quantifyCellsTestCleanUp[];

		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{testBench, modelCell1, modelCell2, sample1, sample2, sample3, sample4, container1, container2, container3, stdCurve, nephProtocol, nephelometer, liquidHandler,tubingIDs,valveIDs},

				(* reserve id for a list of objects we are going to create *)
				{
					testBench,
					modelCell1,
					modelCell2,
					sample1,
					sample2,
					sample3,
					sample4,
					container1,
					container2,
					container3,
					stdCurve,
					nephProtocol,
					nephelometer,
					liquidHandler
				} = CreateID[{
					Object[Container, Bench],
					Model[Cell, Bacteria],
					Model[Cell, Bacteria],
					Object[Sample],
					Object[Sample],
					Object[Sample],
					Object[Sample],
					Object[Container, Vessel],
					Object[Container, Vessel],
					Object[Container, Plate],
					Object[Analysis, StandardCurve],
					Object[Protocol, Nephelometry],
					Object[Instrument, Nephelometer],
					Object[Instrument, LiquidHandler]
				}];

				(* create bench, model cells, instrument, etc *)
				tubingIDs = CreateID[ConstantArray[Object[Plumbing, Tubing], 4]];
				valveIDs = CreateID[ConstantArray[Object[Plumbing, Valve], 3]];
				Upload[{
					<|
						Object -> testBench,
						Name -> "test bench for QuantifyCells "<>$SessionUUID,
						Model -> Link[Model[Container, Bench, "id:bq9LA0JlA7Ad"], Objects], (* Model[Container, Bench, "The Bench of Testing"] *)
						Site -> Link[$Site]
					|>,
					<|
						Object -> modelCell1,
						Name -> "test cell model 1 for QuantifyCells "<>$SessionUUID,
						CellType -> Bacterial,
						Replace[StandardCurves] -> {Link[stdCurve]},
						Replace[StandardCurveProtocols] -> {Link[nephProtocol]}
					|>,
					<|
						Object -> modelCell2,
						Name -> "test cell model 2 for QuantifyCells "<>$SessionUUID,
						CellType -> Bacterial
					|>,
					<|
						Object -> liquidHandler,
						Name -> "test liquid handler 1 for QuantifyCells "<>$SessionUUID,
						Model -> Link[Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"], Objects] (* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
					|>,
					<|
						Object -> nephelometer,
						Name -> "test nephelometer 1 for QuantifyCells "<>$SessionUUID,
						Model -> Link[Model[Instrument, Nephelometer, "id:J8AY5jDLZN8Z"], Objects], (* Model[Instrument, Nephelometer, "NEPHELOstar Plus"] *)
						Site -> Link[$Site],
						Replace[ConnectedPlumbing] -> {
							Link[valveIDs[[1]], ConnectedLocation],
							Link[tubingIDs[[1]], ConnectedLocation],
							Link[tubingIDs[[2]], ConnectedLocation],
							Link[valveIDs[[2]], ConnectedLocation],
							Link[tubingIDs[[3]], ConnectedLocation],
							Link[tubingIDs[[4]], ConnectedLocation],
							Link[valveIDs[[3]], ConnectedLocation]
						},
						IntegratedLiquidHandler -> Link[liquidHandler, IntegratedNephelometer]
					|>,
					<|
						Object -> nephProtocol,
						Name -> "test neph protocol 1 for QuantifyCells "<>$SessionUUID,
						Instrument -> Link[nephelometer]
					|>,
					<|
						Object -> stdCurve,
						Name -> "test standard curve 1 RNU to Cell/mL for QuantifyCells "<>$SessionUUID,
						BestFitFunction -> QuantityFunction[#^2&, RelativeNephelometricUnit, EmeraldCell / Milliliter],
						Replace[StandardDataUnits] -> {RelativeNephelometricUnit, EmeraldCell / Milliliter},
						Protocol -> Link[nephProtocol]
					|>
				}];

				(* make container *)
				UploadSample[
					{
						Model[Container, Vessel, "id:bq9LA0dBGGR6"], (* Model[Container, Vessel, "50mL Tube"] *)
						Model[Container, Vessel, "id:bq9LA0dBGGR6"], (* Model[Container, Vessel, "50mL Tube"] *)
						Model[Container, Plate, "id:n0k9mGzRaaBn"] (* Model[Container, Plate, "96-well UV-Star Plate"] *)
					},
					{
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench}
					},
					Name -> {
						"test container 1 for QuantifyCells "<>$SessionUUID,
						"test container 2 for QuantifyCells "<>$SessionUUID,
						"test container 3 for QuantifyCells "<>$SessionUUID
					},
					ID -> Download[{
						container1,
						container2,
						container3
					}, ID]
				];

				(* make sample *)
				UploadSample[
					{
						{{0.2 * OD600, modelCell1}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}, (* Model[Molecule, "Water"] *)
						{{1000 * EmeraldCell / Milliliter, modelCell2}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}, (* Model[Molecule, "Water"] *)
						{{0.2 * OD600, modelCell1}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}, (* Model[Molecule, "Water"] *)
						{{1000 * EmeraldCell / Milliliter, modelCell2}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}} (* Model[Molecule, "Water"] *)
					},
					{
						{"A1", container1},
						{"A1", container2},
						{"A1", container3},
						{"A2", container3}
					},
					Name -> {
						"test sample 1 for QuantifyCells "<>$SessionUUID,
						"test sample 2 for QuantifyCells "<>$SessionUUID,
						"test sample 3 for QuantifyCells "<>$SessionUUID,
						"test sample 4 for QuantifyCells "<>$SessionUUID
					},
					ID -> Download[{
						sample1,
						sample2,
						sample3,
						sample4
					}, ID],
					Living -> True,
					Status -> Available,
					State -> Liquid,
					InitialAmount -> {
						20 * Milliliter,
						20 * Milliliter,
						200 * Microliter,
						200 * Microliter
					}
				]
			]
		]
	},
	SymbolTearDown :> {
		quantifyCellsTestCleanUp[];
	}
];


quantifyCellsTestCleanUp[] := Module[{objects, objectsExistQ},
	(* List all test objects to erase. Can use SetUpTestObjects[]+ObjectToString[] to get the comprehensive list. *)
	objects = {
		Object[Container, Bench, "test bench for QuantifyCells "<>$SessionUUID],
		Model[Cell, Bacteria, "test cell model 1 for QuantifyCells "<>$SessionUUID],
		Model[Cell, Bacteria, "test cell model 2 for QuantifyCells "<>$SessionUUID],
		Object[Sample, "test sample 1 for QuantifyCells "<>$SessionUUID],
		Object[Sample, "test sample 2 for QuantifyCells "<>$SessionUUID],
		Object[Sample, "test sample 3 for QuantifyCells "<>$SessionUUID],
		Object[Sample, "test sample 4 for QuantifyCells "<>$SessionUUID],
		Object[Container, Vessel, "test container 1 for QuantifyCells "<>$SessionUUID],
		Object[Container, Vessel, "test container 2 for QuantifyCells "<>$SessionUUID],
		Object[Container, Plate, "test container 3 for QuantifyCells "<>$SessionUUID],
		Object[Analysis, StandardCurve, "test standard curve 1 RNU to Cell/mL for QuantifyCells "<>$SessionUUID],
		Object[Protocol, Nephelometry, "test neph protocol 1 for QuantifyCells "<>$SessionUUID],
		Object[Instrument, Nephelometer, "test nephelometer 1 for QuantifyCells "<>$SessionUUID],
		Object[Instrument, LiquidHandler, "test liquid handler 1 for QuantifyCells "<>$SessionUUID]
	};

	(* Check whether the names we want to give below already exist in the database *)
	objectsExistQ = DatabaseMemberQ[objects];

	(* Erase any objects that we failed to erase in the last unit test. *)
	Quiet[EraseObject[PickList[objects, objectsExistQ], Force -> True, Verbose -> False]]
];
