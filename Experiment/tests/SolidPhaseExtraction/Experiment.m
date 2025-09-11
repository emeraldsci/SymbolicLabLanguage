(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*ExperimentSolidPhaseExtraction*)


DefineTests[ExperimentSolidPhaseExtraction,
	{
		Example[{Basic, "Purify a single sample by solid phase extraction:"},
			ExperimentSolidPhaseExtraction[
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Output -> Options
			],
			{_Rule...}
		],
		Example[
			{Basic, "A single list of samples will purify each sample in its own Cartridge (each sample will be in its own unique pool):"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Output -> Options
			],
			{_Rule...}
		],
		Example[
			{Basic, "Samples contained in the same pool are added to the same Cartridge, and are purified together:"},
			ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					{
						Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 7 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					}
				}, Output -> Options],
			{_Rule...}
		],
		Example[{Basic, "Purify a single sample by solid phase extraction on the liquid handler using the MPE2:"},
			ExperimentSolidPhaseExtraction[
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				LoadingSampleVolume -> 0.3 Milliliter,
				ExtractionMethod -> Pressure,
				Preparation -> Robotic
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			TimeConstraint -> 600
		],
		Example[{Basic, "Purify a single sample by solid phase extraction on the liquid handler using the centrifuge (currently we have no VSpin-compatible SPE cartridges because they're all too tall, so this will return $Failed):"},
			ExperimentSolidPhaseExtraction[
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				LoadingSampleVolume -> 0.3 Milliliter,
				ExtractionMethod -> Centrifuge,
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {
				Error::UnusableCentrifuge,
				Error::NoUsableCentrifuge,
				Error::InvalidInput
			},
			TimeConstraint -> 600
		],

		Example[{Additional, "Purify multiple samples, including pooling, when doing Robotic SPE on MPE2:"},
			ExperimentSolidPhaseExtraction[
				{
					{Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID], Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> {{0.1 Milliliter, 0.1 Milliliter}, 0.3 Milliliter},
				ExtractionMethod -> Pressure,
				Preparation -> Robotic
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Additional, "Purify multiple samples, including pooling, when doing Robotic SPE on Centrifuge (currently we have no VSpin-compatible SPE cartridges because they're all too tall, so this will return $Failed):"},
			ExperimentSolidPhaseExtraction[
				{
					{Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID], Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> {{0.1 Milliliter, 0.1 Milliliter}, 0.3 Milliliter},
				ExtractionMethod -> Centrifuge,
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {
				Error::UnusableCentrifuge,
				Error::NoUsableCentrifuge,
				Error::InvalidInput
			}
		],
		(* ---  Message Unit Tests --- *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentSolidPhaseExtraction[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentSolidPhaseExtraction[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentSolidPhaseExtraction[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentSolidPhaseExtraction[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentSolidPhaseExtraction[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentSolidPhaseExtraction[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "mtwarningExtractionStrategyElutingIncompatible", "ExtractionStrategy Negative should not have any MobileOptions step after LoadingSample:"},
			ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ExtractionStrategy -> Negative,
				Eluting -> True
			],
			ObjectP[Object[Protocol, SolidPhaseExtraction]],
			Messages :> {
				Warning::mtwarningExtractionStrategyElutingIncompatible
			}
		],

		Example[{Messages, "TooLargeRequestVolume", "The LoadingSampleVolume is larger than the volume that SamplesIn have:"},
			ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 100 Milliliter
			],
			$Failed,
			Messages :> {
				Error::TooLargeRequestVolume,
				Error::InvalidOption
			}
		],

		Example[{Messages, "ConflictingMobilePhaseOptions", "The MobilePhase options are conflicting, resulted in failure to find the most optimum Instrument:"},
			ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 0.5 Milliliter,
				LoadingSampleCentrifugeIntensity -> 1000 RPM,
				LoadingSampleDispenseRate -> 5 Milliliter / Minute
			],
			$Failed,
			Messages :> {
				Error::ConflictingMobilePhaseOptions,
				Error::InvalidOption
			}
		],

		Example[{Messages, "GX271tooManyCollectionPlate", "Too many CollectionContainer on the Deck of GX-271 LiquidHandler:"},
			ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
				ExtractionCartridge -> Model[Container, ExtractionCartridge, "id:O81aEBZvdGMD"],
				PreFlushing -> False,
				Conditioning -> False,
				WashingSolution -> Model[Sample, "Milli-Q water"],
				CollectWashingSolution -> True,
				ElutingSolution -> Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages :> {
				Error::SPECannotSupportSamples,
				Error::GX271tooManyCollectionPlate,
				Error::InvalidOption
			}
		],

		Example[{Messages, "SPECannotSupportVolume", "The LoadingSample Volume cannot be supported by current ExperimentSolidPhaseExtraction:"},
			ExperimentSolidPhaseExtraction[
				Object[Sample, "Test Sample 8 - 500 mL in Bottle 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				LoadingSampleVolume -> 500 Milliliter
			],
			$Failed,
			Messages :> {
				Error::SPECannotSupportVolume,
				Error::SPECannotSupportSamples,
				Error::InvalidOption
			}
		],

		Example[{Messages, "SPECannotSupportExtractionMethod", "ExtractionMethod cannot be supported by current SolidPhaseExtraction:"},
			ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ExtractionMethod -> Pipette
			],
			$Failed,
			Messages :> {
				Error::SPECannotSupportSamples,
				Error::SPECannotSupportExtractionMethod,
				Error::InvalidOption
			}
		],

		Example[{Messages, "SPECentrifugeIntensityTooHigh", "CentrifugeIntensity options is too high for SolidPhaseExtraction supporting centrifuge Instrument:"},
			ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 0.5 Milliliter,
				ElutingSolutionCentrifugeIntensity -> 10000 RPM
			],
			$Failed,
			Messages :> {
				Error::SPECentrifugeIntensityTooHigh,
				Error::InvalidOption
			}
		],

		Example[{Messages, "SPEExtractionCartidgeTooLargeForInstrument", "ExtractionCartridge is too large and cannot fit in the Instrument:"},
			ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
				ExtractionCartridge -> Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge 6 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::SPEExtractionCartidgeTooLargeForInstrument,
				Error::InvalidOption
			}
		],

		Example[{Messages, "SPEExtractionCartridgeAndSorbentMismatch", "The supplied ExtractionSorbent and the Sobent indicated by ExtractionCartridge are in conflict:"},
			ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
				ExtractionCartridge -> Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				ExtractionSorbent -> Silica,
				ElutingSolutionCentrifugeIntensity -> 10000 RPM
			],
			$Failed,
			Messages :> {
				Error::SPECannotSupportSamples,
				Warning::SPEExtractionCartridgeAndSorbentMismatch,
				Error::InvalidOption
			}
		],

		Example[{Messages, "SPEExtractionCartridgeAndSorbentMismatch", "The supplied ExtractionSorbent and the Sobent indicated by ExtractionCartridge are in conflict:"},
			ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
				ExtractionCartridge -> Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				ExtractionSorbent -> Silica,
				ElutingSolutionCentrifugeIntensity -> 10000 RPM
			],
			$Failed,
			Messages :> {
				Error::SPECannotSupportSamples,
				Warning::SPEExtractionCartridgeAndSorbentMismatch,
				Error::InvalidOption
			}
		],

		Example[{Messages, "PressureMustBeBoolean", "Instrument FilterBlock cannot regulate pressure, thus Pressure options will be converted to boolean:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 1 Milliliter,
				Instrument -> Model[Instrument, FilterBlock, "id:rea9jl1orrGr"],
				PreFlushingSolutionPressure -> 10 PSI
			],
			ObjectP[Object[Protocol, SolidPhaseExtraction]],
			Messages :> {
				Warning::PressureMustBeBoolean
			}
		],

		Example[{Messages, "errorAmbientOnlyInstrument", "The chosen Instrument can only run SolidPhaseExtraction at Ambient Temperature:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
				ExtractionTemperature -> 40 Celsius
			],
			$Failed,
			Messages :> {
				Error::errorAmbientOnlyInstrument,
				Error::InvalidOption
			}
		],

		Example[{Messages, "ExtractionTemperatureOutOfBound", "SolidPhaseExtraction cannot support indicated ExtractionTemperature:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 0.5 Milliliter,
				ExtractionTemperature -> -15 Celsius,
				Instrument -> Model[Instrument, Centrifuge, "Eppendorf 5920R"]
			],
			$Failed,
			Messages :> {
				Error::ExtractionTemperatureOutOfBound,
				Error::InvalidOption
			}
		],

		Example[{Messages, "incompatibleInstrumentAndCollectionContainer", "The supplied CollectionContainer is not compatible with Instrument that will perform SolidPhaseExtraction:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
				ElutingSolutionCollectionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
			],
			$Failed,
			Messages :> {
				Error::incompatibleInstrumentAndCollectionContainer,
				Error::InvalidOption
			}
		],

		Example[{Messages, "PositiveStrategyWithoutEluting", "Requesting ExtractionStrategy Positive but not collecting Eluent:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 1 Milliliter,
				ExtractionStrategy -> Positive,
				CollectLoadingSampleFlowthrough -> True,
				CollectElutingSolution -> False
			],
			ObjectP[Object[Protocol, SolidPhaseExtraction]],
			Messages :> {
				Warning::PositiveStrategyWithoutEluting
			}
		],

		Example[{Messages, "mtwarningExtractionStrategyElutingIncompatible", "ExtractionStrategy Negative is now switched to Positive because ElutingSolution is defined:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ExtractionStrategy -> Negative,
				ElutingSolution -> Model[Sample, "Milli-Q water"]
			],
			ObjectP[Object[Protocol, SolidPhaseExtraction]],
			Messages :> {
				Warning::mtwarningExtractionStrategyElutingIncompatible
			}
		],

		Example[{Messages, "ExtractionStrategyWashingSwitchIncompatible", "ExtractionStrategy Negative is now switched to Positive because WashingSolution is defined:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ExtractionStrategy -> Negative,
				WashingSolution -> Model[Sample, "Milli-Q water"]
			],
			ObjectP[Object[Protocol, SolidPhaseExtraction]],
			Messages :> {
				Warning::ExtractionStrategyWashingSwitchIncompatible
			}
		],

		Example[{Messages, "ExtractionStrategySecondaryWashingSwitchIncompatible", "ExtractionStrategy Negative is now switched to Positive because SecondaryWashingSolution is defined:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ExtractionStrategy -> Negative,
				WashingSolution -> Model[Sample, "Milli-Q water"],
				SecondaryWashingSolution -> Model[Sample, "Milli-Q water"],
				CollectSecondaryWashingSolution -> False
			],
			ObjectP[Object[Protocol, SolidPhaseExtraction]],
			Messages :> {
				Warning::ExtractionStrategyWashingSwitchIncompatible,
				Warning::ExtractionStrategySecondaryWashingSwitchIncompatible
			}
		],

		Example[{Messages, "ExtractionStrategyTertiaryWashingSwitchIncompatible", "ExtractionStrategy Negative is now switched to Positive because TertiaryWashingSolution is defined:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ExtractionStrategy -> Negative,
				WashingSolution -> Model[Sample, "Milli-Q water"],
				SecondaryWashingSolution -> Model[Sample, "Milli-Q water"],
				TertiaryWashingSolution -> Model[Sample, "Milli-Q water"]
			],
			ObjectP[Object[Protocol, SolidPhaseExtraction]],
			Messages :> {
				Warning::ExtractionStrategyWashingSwitchIncompatible,
				Warning::ExtractionStrategySecondaryWashingSwitchIncompatible,
				Warning::ExtractionStrategyTertiaryWashingSwitchIncompatible
			}
		],

		Example[{Messages, "skippedWashingError", "SecondaryWashing options is defined, while Washing options are not used first:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Washing -> False,
				SecondaryWashing -> True
			],
			$Failed,
			Messages :> {
				Error::skippedWashingError,
				Error::InvalidOption
			}
		],

		Example[{Messages, "skippedSecondaryWashingError", "TertiaryWashing options is defined, while SecondaryWashing options are not used first:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Washing -> True,
				SecondaryWashing -> False,
				TertiaryWashing -> True
			],
			$Failed,
			Messages :> {
				Error::skippedSecondaryWashingError,
				Error::InvalidOption
			}
		],

		Example[{Messages, "GX271tooManySolutionBottle", "Gilson GX271 can hold only 1 type of Secondary or Tertiary WashingSolution:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
				PreFlushingSolution -> Model[Sample, "Milli-Q water"],
				ConditioningSolution -> Model[Sample, "Milli-Q water"],
				WashingSolution -> Model[Sample, "Milli-Q water"],
				ElutingSolution -> Model[Sample, "Milli-Q water"],
				SecondaryWashingSolution -> Model[Sample, "Methanol"],
				TertiaryWashingSolution -> Model[Sample, "Acetic acid"]
			],
			$Failed,
			Messages :> {
				Error::GX271tooManySolutionBottle,
				Error::InvalidOption
			}
		],

		Example[{Messages, "SPEInstrumentCannotSupportRinseAndReload", "SecondaryWashing options is defined, while Washing options are not used first:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 0.5 Milliliter,
				Instrument -> Model[Instrument, FilterBlock, "id:rea9jl1orrGr"],
				QuantitativeLoadingSample -> True,
				PreFlushingSolution -> Model[Sample, "Milli-Q water"],
				ConditioningSolution -> Model[Sample, "Milli-Q water"],
				WashingSolution -> Model[Sample, "Milli-Q water"],
				ElutingSolution -> Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages :> {
				Error::SPEInstrumentCannotSupportRinseAndReload,
				Error::InvalidOption
			}
		],

		Example[{Messages, "SPEInstrumentCannotSupportSolution", "MobilePhase Volume options are too large for SolidPhaseExtraction to be performed:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, FilterBlock, "id:rea9jl1orrGr"],
				PreFlushingSolutionVolume -> 500 Milliliter,
				PreFlushingSolution -> Model[Sample, "Milli-Q water"],
				ConditioningSolution -> Model[Sample, "Milli-Q water"],
				WashingSolution -> Model[Sample, "Milli-Q water"],
				ElutingSolution -> Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages :> {
				Error::SPECannotSupportSamples,
				Error::SPECannotSupportSolutionVolume,
				Error::SPEInstrumentCannotSupportSolutionVolume,
				Error::InvalidOption
			}
		],

		Example[{Messages, "SPEInstrumentCannotSupportSolutionVolume", "MobilePhase Volume options are too large for the chosen Instrument:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, FilterBlock, "id:rea9jl1orrGr"],
				PreFlushingSolutionVolume -> 500 Milliliter,
				PreFlushingSolution -> Model[Sample, "Milli-Q water"],
				ConditioningSolution -> Model[Sample, "Milli-Q water"],
				WashingSolution -> Model[Sample, "Milli-Q water"],
				ElutingSolution -> Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages :> {
				Error::SPECannotSupportSamples,
				Error::SPECannotSupportSolutionVolume,
				Error::SPEInstrumentCannotSupportSolutionVolume,
				Error::InvalidOption
			}
		],

		Example[{Messages, "NotSPEInstrument", "The chosen Instrument is not Instrument for SolidPhaseExtraction:"},
			ExperimentSolidPhaseExtraction[
				{
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, LiquidHandler, "id:6V0npvK611P6"]
			],
			$Failed,
			Messages :> {
				Error::SPECannotSupportSamples,
				Error::NotSPEInstrument,
				Error::InvalidOption
			}
		],

		Example[{Messages, "SPEInputLiquidHandlerIncompatible", "The chosen input samples cannot be LiquidHandlerIncompatible if Preparation -> Robotic:"},
			ExperimentSolidPhaseExtraction[
				Object[Sample, "Test Sample 9 - 2 mL in Tube 4 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {
				Error::SPEInputLiquidHandlerIncompatible,
				Error::InvalidInput
			}
		],

		Example[{Messages, "SPESolutionsLiquidHandlerIncompatible", "The chosen solution options cannot be LiquidHandlerIncompatible if Preparation -> Robotic:"},
			ExperimentSolidPhaseExtraction[
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				PreFlushingSolution -> Model[Sample, "Sulfuric acid"],
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {
				Error::SPESolutionsLiquidHandlerIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SPEManualCurrentlyNotSupported", "Don't allow Manual SPE for the time being:"},
			Block[{$SPERoboticOnly = True},
				ExperimentSolidPhaseExtraction[
					Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Instrument -> Model[Instrument, PressureManifold, "Biotage PRESSURE+ 48 Positive Pressure Manifold"]
				]
			],
			$Failed,
			Messages :> {
				Error::SPEManualCurrentlyNotSupported,
				Error::InvalidOption
			}
		],
		(* Labeling Options *)
		Example[
			{Options, SampleLabel, "The SampleLabel option allows labeling of SamplesIn:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				SampleLabel -> {{"Sample1", "Sample2"}, "Sample3"},
				Output -> Options
			], SampleLabel],
			{{"Sample1", "Sample2"}, {"Sample3"}}
		],
		Example[
			{Options, PreFlushingSampleOutLabel, "The PreFlushingSampleOutLabel allows labeling of collected SamplesOut from PreFlushing:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				CollectPreFlushingSolution -> True,
				PreFlushingSampleOutLabel -> {"PreFlushingSample1", "PreFlushingSample2"},
				Output -> Options
			], PreFlushingSampleOutLabel],
			{"PreFlushingSample1", "PreFlushingSample2"}
		],
		Example[
			{Options, ConditioningSampleOutLabel, "The ConditioningSampleOutLabel allows labeling of collected SamplesOut from Conditioning:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				CollectConditioningSolution -> True,
				ConditioningSampleOutLabel -> {"ConditioningSample1", "ConditioningSample2"},
				Output -> Options
			], ConditioningSampleOutLabel],
			{"ConditioningSample1", "ConditioningSample2"}
		],
		Example[
			{Options, LoadingSampleFlowthroughSampleOutLabel, "The LoadingSampleFlowthroughSampleOutLabel allows labeling of collected SamplesOut from LoadingSampleFlowthrough:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				CollectLoadingSampleFlowthrough -> True,
				LoadingSampleFlowthroughSampleOutLabel -> {"LoadingSampleFlowthroughSample1", "LoadingSampleFlowthroughSample2"},
				Output -> Options
			], LoadingSampleFlowthroughSampleOutLabel],
			{"LoadingSampleFlowthroughSample1", "LoadingSampleFlowthroughSample2"}
		],
		Example[
			{Options, WashingSampleOutLabel, "The WashingSampleOutLabel allows labeling of collected SamplesOut from Washing:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				CollectWashingSolution -> True,
				WashingSampleOutLabel -> {"WashingSample1", "WashingSample2"},
				Output -> Options
			], WashingSampleOutLabel],
			{"WashingSample1", "WashingSample2"}
		],
		Example[
			{Options, SecondaryWashingSampleOutLabel, "The SecondaryWashingSampleOutLabel allows labeling of collected SamplesOut from SecondaryWashing:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				SecondaryWashing -> True,
				CollectSecondaryWashingSolution -> True,
				SecondaryWashingSampleOutLabel -> {"SecondaryWashingSample1", "SecondaryWashingSample2"},
				Output -> Options
			], SecondaryWashingSampleOutLabel],
			{"SecondaryWashingSample1", "SecondaryWashingSample2"}
		],
		Example[
			{Options, TertiaryWashingSampleOutLabel, "The TertiaryWashingSampleOutLabel allows labeling of collected SamplesOut from TertiaryWashing:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				SecondaryWashing -> True,
				TertiaryWashing -> True,
				CollectTertiaryWashingSolution -> True,
				TertiaryWashingSampleOutLabel -> {"TertiaryWashingSample1", "TertiaryWashingSample2"},
				Output -> Options
			], TertiaryWashingSampleOutLabel],
			{"TertiaryWashingSample1", "TertiaryWashingSample2"}
		],
		Example[
			{Options, ElutingSampleOutLabel, "The ElutingSampleOutLabel allows labeling of collected SamplesOut from Eluting:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				CollectElutingSolution -> True,
				ElutingSampleOutLabel -> {"ElutingSample1", "ElutingSample2"},
				Output -> Options
			], ElutingSampleOutLabel],
			{"ElutingSample1", "ElutingSample2"}
		],
		Example[
			{Options, SampleOutLabel, "The SampleOutLabel allows labeling of collected SamplesOut in the order of PreFlushignSolutionSampleOut, ConditioningSolutionSampleOut, LoadingSampleFlowthroughSampleOut, WashingSolutionSampleOut, SecondaryWashingSolutionSampleOut, TertiaryWashingSolutionSample and ElutingSolutionSampleOut:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				CollectElutingSolution -> True,
				SampleOutLabel -> {"SampleOut1", "SampleOut2"},
				Output -> Options
			], SampleOutLabel],
			{"SampleOut1", "SampleOut2"}
		],

		Example[
			{Options, ContainerOutLabel, "The SampleOutLabel allows labeling of container that holds the sample that becomes the SamplesOut:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				CollectElutingSolution -> True,
				ContainerOutLabel -> {"ContainerOut1", "ContainerOut2"},
				Output -> Options
			], ContainerOutLabel],
			{"ContainerOut1", "ContainerOut2"}
		],

		Example[
			{Options, ExtractionCartridgeLabel, "The ExtractionCartridgeLabel allows labeling of extraction cartridge that is used to perform solid phase extraction for each sample pool:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ExtractionCartridgeLabel -> {"SPECartridge1", "SPECartridge2"},
				Output -> Options
			], ExtractionCartridgeLabel],
			{"SPECartridge1", "SPECartridge2"}
		],

		Example[
			{Options, SourceContainerLabel, "The SourceContainerLabel allows labeling of container of the SamplesIn:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				SourceContainerLabel -> {{"Container1", "Container1"}, {"Container1"}},
				Output -> Options
			], SourceContainerLabel],
			{{"Container1", "Container1"}, {"Container1"}}
		],
		Example[
			{Options, PreFlushingSolutionLabel, "The PreFlushingSolutionLabel option allows labelling of the name for PreFlushingSolution in each sample pool:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				PreFlushingSolutionLabel -> {"PreFlush1", "PreFlush2"},
				Output -> Options
			], PreFlushingSolutionLabel],
			{"PreFlush1", "PreFlush2"}
		],

		Example[
			{Options, ConditioningSolutionLabel, "The ConditioningSolutionLabel option allows labelling of the name for PreFlushingSolution in each sample pool:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ConditioningSolutionLabel -> {"Conditioning1", "Conditioning2"},
				Output -> Options
			], ConditioningSolutionLabel],
			{"Conditioning1", "Conditioning2"}
		],

		Example[
			{Options, WashingSolutionLabel, "The WashingSolutionLabel option allows labelling of the name for PreFlushingSolution in each sample pool:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				WashingSolutionLabel -> {"Washing1", "Washing2"},
				Output -> Options
			], WashingSolutionLabel],
			{"Washing1", "Washing2"}
		],

		Example[
			{Options, SecondaryWashingSolutionLabel, "The SecondaryWashingSolutionLabel option allows labelling of the name for PreFlushingSolution in each sample pool:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Washing -> True,
				SecondaryWashing -> True,
				SecondaryWashingSolutionLabel -> {"SecondaryWashing1", "SecondaryWashing2"},
				Output -> Options
			], SecondaryWashingSolutionLabel],
			{"SecondaryWashing1", "SecondaryWashing2"}
		],

		Example[
			{Options, TertiaryWashingSolutionLabel, "The TertiaryWashingSolutionLabel option allows labelling of the name for TertiaryWashingSolution in each sample pool:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Washing -> True,
				SecondaryWashing -> True,
				TertiaryWashing -> True,
				TertiaryWashingSolutionLabel -> {"TertiaryWashing1", "TertiaryWashing2"},
				Output -> Options
			], TertiaryWashingSolutionLabel],
			{"TertiaryWashing1", "TertiaryWashing2"}
		],

		Example[
			{Options, ElutingSolutionLabel, "The ElutingSolutionLabel option allows labelling of the name for ElutingSolution in each sample pool:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ElutingSolutionLabel -> {"Eluting1", "Eluting2"},
				Output -> Options
			], ElutingSolutionLabel],
			{"Eluting1", "Eluting2"}
		],

		(* ---  Extraction Option Unit Tests --- *)
		Example[
			{Options, ExtractionMode, "The ExtractionMode option allows specification of the type of extraction to be performed for each sample pool:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ExtractionMode -> {ReversePhase, NormalPhase},
				Output -> Options
			], Warning::SamplesOutOfStock], ExtractionMode],
			{ReversePhase, NormalPhase}
		],

		Example[
			{Options, ExtractionMethod, "The ExtractionMethod option allows specification of the type of force that is used to flush fluid or sample through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ExtractionMethod -> Injection,
				Output -> Options
			], ExtractionMethod],
			Injection

		],

		Example[
			{Options, ExtractionTemperature, "The ExtractionTemperature options allows specification of the temperature for extraction to be performed for each sample pool:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ExtractionTemperature -> {25 Celsius, 25 Celsius},
				Output -> Options
			], ExtractionTemperature],
			{25 Celsius, 25 Celsius}
		],

		Example[
			{Options, ExtractionStrategy, "The ExtractionStrategy option allows specification of the type of extraction to be performed for each sample pool:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 1.1 Milliliter,
				ExtractionStrategy -> {Positive, Negative},
				Output -> Options
			], ExtractionStrategy],
			{Positive, Negative}
		],

		Example[
			{Options, ExtractionStrategy, "The ExtractionStrategy option allows Negative for all the samples in the experiment call:"},
			Lookup[ExperimentSolidPhaseExtraction[Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				LoadingSampleVolume -> 1.1 Milliliter,
				ExtractionStrategy -> Negative,
				Output -> Options
			], ExtractionStrategy],
			Negative
		],

		Example[
			{Options, Instrument, "The Instrument option allows specification of instrument to use for the entire protocol:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Object[Instrument, LiquidHandler, "Test Gilson LiquidHandler 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Output -> Options
			], Instrument],
			ObjectP[Object[Instrument, LiquidHandler, "Test Gilson LiquidHandler 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]]
		],

		Example[
			{Options, LoadingSampleVolume, "The LoadingSampleVolume option allows specification of the volume of each individual sample that is loaded into the corresponding sample pool's Cartridge:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> {{0.5 Milliliter, 0.5 Milliliter}, {1 Milliliter}},
				Output -> Options
			], LoadingSampleVolume],
			{
				{0.5 Milliliter, 0.5 Milliliter}, {1 Milliliter}
			},
			EquivalenceFunction -> Equal
		],

		Example[
			{Options, LoadingSampleDispenseRate, "LoadingSampleDispenseRate options allows specification of the rate at which the sample will be loaded into the extraction cartridge:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleDispenseRate -> {3 Milliliter / Minute, 2 Milliliter / Minute},
				Output -> Options
			], LoadingSampleDispenseRate],
			{3 Milliliter / Minute, 2 Milliliter / Minute}
		],

		Example[
			{Options, LoadingSampleTemperature, "LoadingSampleTemperature options allows specification of the temperature at which the sample will be loaded into the extraction cartridge:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleTemperature -> {{25 Celsius, 25 Celsius}, {25 Celsius}},
				Output -> Options
			], LoadingSampleTemperature],
			{{25 Celsius, 25 Celsius}, {25 Celsius}}
		],

		Example[
			{Options, LoadingSampleTemperatureEquilibrationTime, "LoadingSampleTemperatureEquilibrationTime options allows specification of the amount of time for sample to be incubated at LoadingSampleTemperature before loading on to ExtractionCartridge:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleTemperatureEquilibrationTime -> {{1 Minute, 1 Minute}, {1 Minute}},
				Output -> Options
			], LoadingSampleTemperatureEquilibrationTime],
			{{1 Minute, 1 Minute}, {1 Minute}}
		],

		Example[
			{Options, QuantitativeLoadingSample, "QuantitativeLoadingSample options allows specification whether the original container of the sample to be rinse and with ConditioningSolution or QuantitativeLoadingSampleSolution and the transfer the rinsed liquid to ExtractionCartridge:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				QuantitativeLoadingSample -> True,
				Output -> Options
			], QuantitativeLoadingSample],
			True
		],

		Example[
			{Options, QuantitativeLoadingSampleSolution, "QuantitativeLoadingSampleSolution options allows specification of the solution used to rinsed LoadingSample container:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				QuantitativeLoadingSampleSolution -> Model[Sample, "Milli-Q water"],
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Output -> Options
			], QuantitativeLoadingSampleSolution],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],

		Example[
			{Options, QuantitativeLoadingSampleVolume, "QuantitativeLoadingSampleVolume options allows specification of the Volume of the solution that will be used to rinse LoadingSample container:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				QuantitativeLoadingSampleVolume -> 0.5 Milliliter,
				Output -> Options
			], QuantitativeLoadingSampleVolume],
			500. Microliter (*Unit scaled result*)
		],

		Example[
			{Options, CollectLoadingSampleFlowthrough, "CollectLoadingSampleFlowthrough options allows specification to collect the LoadingSample flowthrough or not:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				CollectLoadingSampleFlowthrough -> True,
				Output -> Options
			], CollectLoadingSampleFlowthrough],
			True
		],

		Example[
			{Options, LoadingSampleFlowthroughContainer, "LoadingSampleFlowthroughContainer options allows specification of container that will be used to collect LoadingSampleFlowthrough:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				LoadingSampleFlowthroughContainer -> Model[Container, Vessel, "15mL Tube"],
				Output -> Options
			], LoadingSampleFlowthroughContainer],
			ObjectP[Model[Container, Vessel, "15mL Tube"]]
		],

		Example[
			{Options, LoadingSampleDrainTime, "LoadingSampleDrainTime options allows specification of the amount of time for Centrifugal or Pressure force to be applied to LoadingSample:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				LoadingSampleDrainTime -> 1 Minute,
				Output -> Options
			], LoadingSampleDrainTime],
			1 Minute
		],

		Example[
			{Options, LoadingSampleUntilDrained, "LoadingSampleUntilDrained options allows indication if LoadingSample is continually flushed through the cartridge in cycle of every LoadingSampleDrainTime until it is drained entirely, or until MaxPreFlushingDrainTime has been reached::"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				LoadingSampleUntilDrained -> True,
				Output -> Options
			], LoadingSampleUntilDrained],
			True
		],

		Example[
			{Options, MaxLoadingSampleDrainTime, "MaxLoadingSampleDrainTime options allows specification of maximum amount of time to try and force the totality of LoadingSample to go through ExtractionCartridge:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				MaxLoadingSampleDrainTime -> {1 Minute, 1 Minute},
				Output -> Options
			], MaxLoadingSampleDrainTime],
			{1 Minute, 1 Minute}
		],

		Example[
			{Options, LoadingSampleCentrifugeIntensity, "LoadingSampleCentrifugeIntensity options allows specification of centifugal force that apply to LoadingSample to go through Extractioncartridge:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 0.5 Milliliter,
				Instrument -> Model[Instrument, Centrifuge, "id:eGakldJEz14E"],
				LoadingSampleCentrifugeIntensity -> 1000 RPM,
				Output -> Options
			], LoadingSampleCentrifugeIntensity],
			1000 RPM
		],

		Example[
			{Options, LoadingSamplePressure, "LoadingSamplePressure options allows specification of air pressure force that apply to LoadingSample to go through Extractioncartridge:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				LoadingSamplePressure -> 5 PSI,
				Output -> Options
			], LoadingSamplePressure],
			5 PSI
		],

		(* Extraction *)
		Example[
			{Options, ExtractionSorbent, "ExtractionSorbent options allows specification of the sorbent of ExtractionCartridge that will be used in SolidPhaseExtraction:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ExtractionSorbent -> C18,
				Output -> Options
			], ExtractionSorbent],
			C18
		],

		Example[
			{Options, ExtractionCartridge, "ExtractionCartridge options allows specification of the ExtractionCartridge to be used in SolidPhaseExtraction:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ExtractionCartridge -> {
					Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 2 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Output -> Options
			], ExtractionCartridge],
			{
				ObjectP[Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]],
				ObjectP[Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 2 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]]
			}
		],

		(* PreFlushing Options *)
		Example[
			{Options, PreFlushing, "PreFlush options allows specification whether ExtractionCartridge is to be washed with PreFlushing Solution before loading with LoadingSample:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				PreFlushing -> True,
				Output -> Options
			], PreFlushing],
			True
		],

		Example[
			{Options, PreFlushingSolution, "PreFlushingSolution options allows specification of solution that is used to wash ExtractionCartridge before loading with LoadingSample:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				PreFlushingSolution -> Model[Sample, "Milli-Q water"],
				Output -> Options
			], PreFlushingSolution],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],

		Example[
			{Options, PreFlushingSolutionVolume, "PreFlushingSolutionVolume options allows specification of the PreFlushingSolution volume to be used:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				PreFlushingSolutionVolume -> 3 Milliliter,
				Output -> Options
			], PreFlushingSolutionVolume],
			3 Milliliter
		],

		Example[
			{Options, PreFlushingSolutionTemperature, "PreFlushingSolutionTemperature options allows specification of the temperature of PreFlushingSolution that is to be flushed through ExtractionSorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				PreFlushingSolutionTemperature -> 25 Celsius,
				Output -> Options
			], PreFlushingSolutionTemperature],
			25 Celsius
		],

		Example[
			{Options, PreFlushingSolutionTemperatureEquilibrationTime, "PreFlushingSolutionTemperatureEquilibrationTime options allows specification of the amount of time for PreFlushingSolution to be incubated at specified PreFlushingSolutionTemperature:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				PreFlushingSolutionTemperatureEquilibrationTime -> 1 Minute,
				Output -> Options
			], PreFlushingSolutionTemperatureEquilibrationTime],
			1 Minute
		],

		Example[
			{Options, CollectPreFlushingSolution, "CollectPreFlushingSolution options allows specification to indicate if the PreFlushingSolution is collected after flushed through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				CollectPreFlushingSolution -> True,
				Output -> Options
			], CollectPreFlushingSolution],
			True
		],

		Example[
			{Options, PreFlushingSolutionCollectionContainer, "PreFlushingSolutionCollectionContainer options allows specification of the container that is used to accumulates any flow through solution in PreFlushing step:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
				PreFlushingSolutionCollectionContainer -> Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"],
				CollectElutingSolution -> False,
				Output -> Options
			], PreFlushingSolutionCollectionContainer],
			ObjectP[Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"]],
			Messages :> {
				Warning::PositiveStrategyWithoutEluting
			}
		],

		Example[
			{Options, PreFlushingSolutionDispenseRate, "PreFlushingSolutionDispenseRate options allows specification of the rate at which the PreFlushingSolution is applied to the sorbent by Instrument during Preflushing step:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
				PreFlushingSolutionDispenseRate -> 3 Milliliter / Minute,
				Output -> Options
			], PreFlushingSolutionDispenseRate],
			3 Milliliter / Minute
		],

		Example[
			{Options, PreFlushingSolutionDrainTime, "PreFlushingSolutionDrainTime options allows specification of The amount of time for PreFlushingSolution to be flushed through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				PreFlushingSolutionDrainTime -> 1 Minute,
				Output -> Options
			], PreFlushingSolutionDrainTime],
			1 Minute
		],

		Example[
			{Options, PreFlushingSolutionUntilDrained, "PreFlushingSolutionUntilDrained options allows indication if PreFlushingSolution is continually flushed through the cartridge in cycle of every PreFlushingDrainTime until it is drained entirely, or until MaxPreFlushingDrainTime has been reached:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				PreFlushingSolutionUntilDrained -> True,
				Output -> Options
			], PreFlushingSolutionUntilDrained],
			True
		],

		Example[
			{Options, MaxPreFlushingSolutionDrainTime, "MaxPreFlushingSolutionDrainTime options allows indication of the maximum amount of time to flush PreFlushingSolution through sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				MaxPreFlushingSolutionDrainTime -> 5 Minute,
				Output -> Options
			], MaxPreFlushingSolutionDrainTime],
			5 Minute
		],

		Example[
			{Options, PreFlushingSolutionCentrifugeIntensity, "PreFlushingSolutionCentrifugeIntensity options allows specification of the rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush PreFlushingSolution through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 0.5 Milliliter,
				Instrument -> Model[Instrument, Centrifuge, "id:eGakldJEz14E"],
				PreFlushingSolutionCentrifugeIntensity -> 1000 RPM,
				Output -> Options
			], PreFlushingSolutionCentrifugeIntensity],
			1000 RPM
		],

		Example[
			{Options, PreFlushingSolutionPressure, "PreFlushingSolutionPressure options allows specification of the target pressure applied to the ExtractionCartridge to flush PreFlushingSolution through the sorbent.:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				PreFlushingSolutionPressure -> 25 PSI,
				Output -> Options
			], PreFlushingSolutionPressure],
			25 PSI
		],

		(* Conditioning Options *)
		Example[
			{Options, Conditioning, "Conditioning options allows indication if sorbent is equilibrate with ConditioningSolution in order to chemically prepare the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Conditioning -> True,
				Output -> Options
			], Conditioning],
			True
		],

		Example[
			{Options, ConditioningSolution, "ConditioningSolution options allows specification of the solution that is flushed through the sorbent in order to chemically prepare the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ConditioningSolution -> Model[Sample, "Milli-Q water"],
				Output -> Options
			], ConditioningSolution],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],

		Example[
			{Options, ConditioningSolutionVolume, "ConditioningSolutionVolume options allows specification of the amount of ConditioningSolution that is flushed through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ConditioningSolutionVolume -> 3 Milliliter,
				Output -> Options
			], ConditioningSolutionVolume],
			3 Milliliter
		],

		Example[
			{Options, ConditioningSolutionTemperature, "ConditioningSolutionTemperature options allows specification of the temperature that ConditioningSolution is incubated for ConditioningSolutionTemperatureEquilibrationTime before being flushed through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ConditioningSolutionTemperature -> 25 Celsius,
				Output -> Options
			], ConditioningSolutionTemperature],
			25 Celsius
		],

		Example[
			{Options, ConditioningSolutionTemperatureEquilibrationTime, "ConditioningSolutionTemperatureEquilibrationTime options allows specification of the mount of time that ConditioningSolution is incubated to achieve the set ConditioningSolutionTemperature:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ConditioningSolutionTemperatureEquilibrationTime -> 5 Minute,
				Output -> Options
			], ConditioningSolutionTemperatureEquilibrationTime],
			5 Minute
		],

		Example[
			{Options, CollectConditioningSolution, "CollectConditioningSolution options allows indication if the ConditioningSolution is collected and saved after flushing through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				CollectConditioningSolution -> True,
				Output -> Options
			], CollectConditioningSolution],
			True
		],

		Example[
			{Options, ConditioningSolutionCollectionContainer, "ConditioningSolutionCollectionContainer options allows specification of the container that is used to accumulates any flow through solution in Conditioning step:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				ConditioningSolutionCollectionContainer -> Model[Container, Vessel, "15mL Tube"],
				Output -> Options
			], ConditioningSolutionCollectionContainer],
			ObjectP[Model[Container, Vessel, "15mL Tube"]]
		],

		Example[
			{Options, ConditioningSolutionDispenseRate, "ConditioningSolutionDispenseRate options allows specification of the rate at which the ConditioningSolution is applied to the sorbent by Instrument during Conditioning step:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
				ConditioningSolutionDispenseRate -> 3 Milliliter / Minute,
				Output -> Options
			], ConditioningSolutionDispenseRate],
			3 Milliliter / Minute
		],

		Example[
			{Options, ConditioningSolutionDrainTime, "ConditioningSolutionDrainTime options allows specification of the amount of time to set on the Instrument for ConditioningSolution to be flushed through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 0.5 Milliliter,
				Instrument -> Model[Instrument, Centrifuge, "id:eGakldJEz14E"],
				ConditioningSolutionDrainTime -> 1 Minute,
				Output -> Options
			], ConditioningSolutionDrainTime],
			1 Minute
		],

		Example[
			{Options, ConditioningSolutionUntilDrained, "ConditioningSolutionUntilDrained options allows indication if ConditioningSolution is continually flushed through the cartridge in cycle of every ConditioningDrainTime until it is drained entirely, or until MaxConditioningDrainTime has been reached:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				ConditioningSolutionUntilDrained -> True,
				Output -> Options
			], ConditioningSolutionUntilDrained],
			True
		],

		Example[
			{Options, MaxConditioningSolutionDrainTime, "MaxConditioningSolutionDrainTime options allows specification of the maximum amount of time to flush ConditioningSolution through sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 0.5 Milliliter,
				Instrument -> Model[Instrument, Centrifuge, "id:eGakldJEz14E"],
				MaxConditioningSolutionDrainTime -> 6 Minute,
				Output -> Options
			], MaxConditioningSolutionDrainTime],
			6 Minute
		],

		Example[
			{Options, ConditioningSolutionCentrifugeIntensity, "ConditioningSolutionCentrifugeIntensity options allows specification of the rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush ConditioningSolution through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 0.5 Milliliter,
				Instrument -> Model[Instrument, Centrifuge, "id:eGakldJEz14E"],
				ConditioningSolutionCentrifugeIntensity -> 1000 RPM,
				Output -> Options
			], ConditioningSolutionCentrifugeIntensity],
			1000 RPM
		],

		Example[
			{Options, ConditioningSolutionPressure, "ConditioningSolutionPressure options allows specification of the target pressure applied to the ExtractionCartridge to flush ConditioningSolution through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				ConditioningSolutionPressure -> 25 PSI,
				Output -> Options
			], ConditioningSolutionPressure],
			25 PSI
		],

		(* Washing Options *)
		Example[
			{Options, Washing, "Washing options allows indication if analyte-bound-sorbent is flushed with WashingSolution:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Washing -> True,
				Output -> Options
			], Washing],
			True
		],

		Example[
			{Options, WashingSolution, "WashingSolution options allows specification of the solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				WashingSolution -> Model[Sample, "Milli-Q water"],
				Output -> Options
			], WashingSolution],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],

		Example[
			{Options, WashingSolutionVolume, "WashingSolutionVolume options allows specification of the amount of WashingSolution that is flushed through the analyte-bound-sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				WashingSolutionVolume -> 3 Milliliter,
				Output -> Options
			], WashingSolutionVolume],
			3 Milliliter
		],

		Example[
			{Options, WashingSolutionTemperature, "WashingSolutionTemperature options allows specification of the temperature that WashingSolution is incubated for WashingSolutionTemperatureEquilibrationTime before being flushed through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				WashingSolutionTemperature -> 25 Celsius,
				Output -> Options
			], WashingSolutionTemperature],
			25 Celsius
		],

		Example[
			{Options, WashingSolutionTemperatureEquilibrationTime, "WashingSolutionTemperatureEquilibrationTime options allows specification of the amount of time that WashingSolution is incubated to achieve the set WashingSolutionTemperature:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				WashingSolutionTemperatureEquilibrationTime -> 1 Minute,
				Output -> Options
			], WashingSolutionTemperatureEquilibrationTime],
			1 Minute
		],

		Example[
			{Options, CollectWashingSolution, "CollectWashingSolution options allows indication if the WashingSolution is collected and saved after flushing through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				CollectWashingSolution -> True,
				Output -> Options
			], CollectWashingSolution],
			True
		],

		Example[
			{Options, WashingSolutionCollectionContainer, "WashingSolutionCollectionContainer options allows specification of the container that is used to accumulates any flow through solution in Washing step:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				WashingSolutionCollectionContainer -> Model[Container, Vessel, "15mL Tube"],
				Output -> Options
			], WashingSolutionCollectionContainer],
			ObjectP[Model[Container, Vessel, "15mL Tube"]]
		],

		Example[
			{Options, WashingSolutionDispenseRate, "WashingSolutionDispenseRate options allows specification of the rate at which the WashingSolution is applied to the sorbent by Instrument during Washing step:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
				WashingSolutionDispenseRate -> 3 Milliliter / Minute,
				Output -> Options
			], WashingSolutionDispenseRate],
			3 Milliliter / Minute
		],

		Example[
			{Options, WashingSolutionDrainTime, "WashingSolutionDrainTime options allows specification of the amount of time to set on the Instrument for WashingSolution to be flushed through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				WashingSolutionDrainTime -> 1 Minute,
				Output -> Options
			], WashingSolutionDrainTime],
			1 Minute
		],

		Example[
			{Options, WashingSolutionUntilDrained, "WashingSolutionUntilDrained options allows indication if WashingSolution is continually flushed through the cartridge in cycle of every WashingDrainTime until it is drained entirely, or until MaxWashingDrainTime has been reached:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				WashingSolutionUntilDrained -> True,
				Output -> Options
			], WashingSolutionUntilDrained],
			True
		],

		Example[
			{Options, MaxWashingSolutionDrainTime, "MaxWashingSolutionDrainTime options allows specification of the maximum amount of time to flush WashingSolution through sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				MaxWashingSolutionDrainTime -> 1 Minute,
				Output -> Options
			], MaxWashingSolutionDrainTime],
			1 Minute
		],

		Example[
			{Options, WashingSolutionCentrifugeIntensity, "WashingSolutionCentrifugeIntensity options allows specification of the rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush WashingSolution through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 0.5 Milliliter,
				Instrument -> Model[Instrument, Centrifuge, "id:eGakldJEz14E"],
				WashingSolutionCentrifugeIntensity -> 1000 RPM,
				Output -> Options
			], WashingSolutionCentrifugeIntensity],
			1000 RPM
		],

		Example[
			{Options, WashingSolutionPressure, "WashingSolutionPressure options allows specification of the target pressure applied to the ExtractionCartridge to flush WashingSolution through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				WashingSolutionPressure -> 25 PSI,
				Output -> Options
			], WashingSolutionPressure],
			25 PSI
		],

		(* SecondaryWashing Options *)
		Example[
			{Options, SecondaryWashing, "SecondaryWashing options allows indication if analyte-bound-sorbent is flushed with SecondaryWashingSolution:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				Output -> Options
			], SecondaryWashing],
			True
		],

		Example[
			{Options, SecondaryWashingSolution, "SecondaryWashingSolution options allows specification of the solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				WashingSolution -> Model[Sample, "Milli-Q water"],
				SecondaryWashingSolution -> Model[Sample, "Milli-Q water"],
				Output -> Options
			], SecondaryWashingSolution],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],

		Example[
			{Options, SecondaryWashingSolutionVolume, "SecondaryWashingSolutionVolume options allows specification of the amount of SecondaryWashingSolution that is flushed through the analyte-bound-sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				SecondaryWashingSolutionVolume -> 3 Milliliter,
				Output -> Options
			], SecondaryWashingSolutionVolume],
			3 Milliliter
		],

		Example[
			{Options, SecondaryWashingSolutionTemperature, "SecondaryWashingSolutionTemperature options allows specification of the temperature that SecondaryWashingSolution is incubated for SecondaryWashingSolutionTemperatureEquilibrationTime before being flushed through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				SecondaryWashingSolutionTemperature -> 25 Celsius,
				Output -> Options
			], SecondaryWashingSolutionTemperature],
			25 Celsius
		],

		Example[
			{Options, SecondaryWashingSolutionTemperatureEquilibrationTime, "SecondaryWashingSolutionTemperatureEquilibrationTime options allows specification of the amount of time that SecondaryWashingSolution is incubated to achieve the set SecondaryWashingSolutionTemperature:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				SecondaryWashingSolutionTemperatureEquilibrationTime -> 1 Minute,
				Output -> Options
			], SecondaryWashingSolutionTemperatureEquilibrationTime],
			1 Minute
		],

		Example[
			{Options, CollectSecondaryWashingSolution, "CollectSecondaryWashingSolution options allows indication if the SecondaryWashingSolution is collected and saved after flushing through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				CollectSecondaryWashingSolution -> True,
				Output -> Options
			], CollectSecondaryWashingSolution],
			True
		],

		Example[
			{Options, SecondaryWashingSolutionCollectionContainer, "SecondaryWashingSolutionCollectionContainer options allows specification of the container that is used to accumulates any flow through solution in SecondaryWashing step:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				SecondaryWashingSolutionCollectionContainer -> Model[Container, Vessel, "15mL Tube"],
				Output -> Options
			], SecondaryWashingSolutionCollectionContainer],
			ObjectP[Model[Container, Vessel, "15mL Tube"]]
		],

		Example[
			{Options, SecondaryWashingSolutionDispenseRate, "SecondaryWashingSolutionDispenseRate options allows specification of the rate at which the SecondaryWashingSolution is applied to the sorbent by Instrument during SecondaryWashing step:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Washing -> True,
				SecondaryWashing -> True,
				SecondaryWashingSolutionDispenseRate -> 3 Milliliter / Minute,
				Output -> Options
			], SecondaryWashingSolutionDispenseRate],
			3 Milliliter / Minute
		],

		Example[
			{Options, SecondaryWashingSolutionDrainTime, "SecondaryWashingSolutionDrainTime options allows specification of the amount of time to set on the Instrument for SecondaryWashingSolution to be flushed through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				SecondaryWashingSolutionDrainTime -> 1 Minute,
				Output -> Options
			], SecondaryWashingSolutionDrainTime],
			1 Minute
		],

		Example[
			{Options, SecondaryWashingSolutionUntilDrained, "SecondaryWashingSolutionUntilDrained options allows specification if SecondaryWashingSolution is continually flushed through the cartridge until it is drained entirely, or until MaxSecondaryWashingSolutionDrainTime:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				SecondaryWashingSolutionUntilDrained -> True,
				Output -> Options
			], SecondaryWashingSolutionUntilDrained],
			True
		],

		Example[
			{Options, MaxSecondaryWashingSolutionDrainTime, "MaxSecondaryWashingSolutionDrainTime options allows specification of the maximum amount of time to flush SecondaryWashingSolution through sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				MaxSecondaryWashingSolutionDrainTime -> 1 Minute,
				Output -> Options
			], MaxSecondaryWashingSolutionDrainTime],
			1 Minute
		],

		Example[
			{Options, SecondaryWashingSolutionCentrifugeIntensity, "SecondaryWashingSolutionCentrifugeIntensity options allows specification of the rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush SecondaryWashingSolution through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 0.5 Milliliter,
				Instrument -> Model[Instrument, Centrifuge, "id:eGakldJEz14E"],
				Washing -> True,
				SecondaryWashing -> True,
				SecondaryWashingSolutionCentrifugeIntensity -> 1000 RPM,
				Output -> Options
			], SecondaryWashingSolutionCentrifugeIntensity],
			1000 RPM
		],

		Example[
			{Options, SecondaryWashingSolutionPressure, "SecondaryWashingSolutionPressure options allows specification of the target pressure applied to the ExtractionCartridge to flush SecondaryWashingSolution through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				SecondaryWashingSolutionPressure -> 25 PSI,
				Output -> Options
			], SecondaryWashingSolutionPressure],
			25 PSI
		],

		(* TertiaryWashing Options *)
		Example[
			{Options, TertiaryWashing, "TertiaryWashing options allows indication if analyte-bound-sorbent is flushed with TertiaryWashingSolution:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				TertiaryWashing -> True,
				Output -> Options
			], TertiaryWashing],
			True
		],

		Example[
			{Options, TertiaryWashingSolution, "TertiaryWashingSolution options allows specification of the solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				TertiaryWashing -> True,
				TertiaryWashingSolution -> Model[Sample, "Milli-Q water"],
				Output -> Options
			], TertiaryWashingSolution],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],

		Example[
			{Options, TertiaryWashingSolutionVolume, "TertiaryWashingSolutionVolume options allows specification of the amount of TertiaryWashingSolution that is flushed through the analyte-bound-sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Washing -> True,
				SecondaryWashing -> True,
				TertiaryWashing -> True,
				TertiaryWashingSolutionVolume -> 3 Milliliter,
				Output -> Options
			], TertiaryWashingSolutionVolume],
			3 Milliliter
		],

		Example[
			{Options, TertiaryWashingSolutionTemperature, "TertiaryWashingSolutionTemperature options allows specification of the temperature that TertiaryWashingSolution is incubated for TertiaryWashingSolutionTemperatureEquilibrationTime before being flushed through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				TertiaryWashingSolutionTemperature -> 25 Celsius,
				Output -> Options
			], TertiaryWashingSolutionTemperature],
			25 Celsius
		],

		Example[
			{Options, TertiaryWashingSolutionTemperatureEquilibrationTime, "TertiaryWashingSolutionTemperatureEquilibrationTime options allows specification of the amount of time that TertiaryWashingSolution is incubated to achieve the set TertiaryWashingSolutionTemperature:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				TertiaryWashingSolutionTemperatureEquilibrationTime -> 1 Minute,
				Output -> Options
			], TertiaryWashingSolutionTemperatureEquilibrationTime],
			1 Minute
		],

		Example[
			{Options, CollectTertiaryWashingSolution, "CollectTertiaryWashingSolution options allows indication if the TertiaryWashingSolution is collected and saved after flushing through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				CollectTertiaryWashingSolution -> True,
				Output -> Options
			], CollectTertiaryWashingSolution],
			True
		],

		Example[
			{Options, TertiaryWashingSolutionCollectionContainer, "TertiaryWashingSolutionCollectionContainer options allows specification of the container that is used to accumulates any flow through solution in TertiaryWashing step:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				TertiaryWashingSolutionCollectionContainer -> Model[Container, Vessel, "15mL Tube"],
				Output -> Options
			], TertiaryWashingSolutionCollectionContainer],
			ObjectP[Model[Container, Vessel, "15mL Tube"]]
		],

		Example[
			{Options, TertiaryWashingSolutionDispenseRate, "TertiaryWashingSolutionDispenseRate options allows specification of the rate at which the TertiaryWashingSolution is applied to the sorbent by Instrument during TertiaryWashing step:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Washing -> True,
				SecondaryWashing -> True,
				TertiaryWashing -> True,
				TertiaryWashingSolutionDispenseRate -> 3 Milliliter / Minute,
				Output -> Options
			], TertiaryWashingSolutionDispenseRate],
			3 Milliliter / Minute
		],

		Example[
			{Options, TertiaryWashingSolutionDrainTime, "TertiaryWashingSolutionDrainTime options allows specification of the amount of time to set on the Instrument for TertiaryWashingSolution to be flushed through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				TertiaryWashingSolutionDrainTime -> 1 Minute,
				Output -> Options
			], TertiaryWashingSolutionDrainTime],
			1 Minute
		],

		Example[
			{Options, TertiaryWashingSolutionUntilDrained, "TertiaryWashingSolutionUntilDrained options allows specification if TertiaryWashingSolution is continually flushed through the cartridge until it is drained entirely, or until MaxTertiaryWashingSolutionDrainTime:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				TertiaryWashing -> True,
				TertiaryWashingSolutionUntilDrained -> True,
				Output -> Options
			], TertiaryWashingSolutionUntilDrained],
			True
		],

		Example[
			{Options, MaxTertiaryWashingSolutionDrainTime, "MaxTertiaryWashingSolutionDrainTime options allows specification of the maximum amount of time to flush TertiaryWashingSolution through sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				MaxTertiaryWashingSolutionDrainTime -> 1 Minute,
				Output -> Options
			], MaxTertiaryWashingSolutionDrainTime],
			1 Minute
		],

		Example[
			{Options, TertiaryWashingSolutionCentrifugeIntensity, "TertiaryWashingSolutionCentrifugeIntensity options allows specification of the rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush TertiaryWashingSolution through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 0.5 Milliliter,
				Instrument -> Model[Instrument, Centrifuge, "id:eGakldJEz14E"],
				Washing -> True,
				SecondaryWashing -> True,
				TertiaryWashing -> True,
				TertiaryWashingSolutionCentrifugeIntensity -> 1000 RPM,
				Output -> Options
			], TertiaryWashingSolutionCentrifugeIntensity],
			1000 RPM
		],

		Example[
			{Options, TertiaryWashingSolutionPressure, "TertiaryWashingSolutionPressure options allows specification of the target pressure applied to the ExtractionCartridge to flush TertiaryWashingSolution through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				Washing -> True,
				SecondaryWashing -> True,
				TertiaryWashingSolutionPressure -> 25 PSI,
				Output -> Options
			], TertiaryWashingSolutionPressure],
			25 PSI
		],

		(* Eluting Options *)
		Example[
			{Options, Eluting, "Eluting options allows specification if sorbent is flushed with ElutingSolution to release bound analyte from the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Eluting -> True,
				Output -> Options
			], Eluting],
			True
		],

		Example[
			{Options, ElutingSolution, "ElutingSolution options allows specification of the solution that is used to flush and release bound analyte from the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ElutingSolution -> Model[Sample, "Milli-Q water"],
				Output -> Options
			], ElutingSolution],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],

		Example[
			{Options, ElutingSolutionVolume, "ElutingSolutionVolume options allows specification of the amount of EluteSolution that is flushed through the sorbent to release analyte from the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ElutingSolutionVolume -> 3 Milliliter,
				Output -> Options
			], ElutingSolutionVolume],
			3 Milliliter
		],

		Example[
			{Options, ElutingSolutionTemperature, "ElutingSolutionTemperature options allows specification of the temperature that ElutingSolution is incubated for ElutingSolutionTemperatureEquilibrationTime before being loaded into the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ElutingSolutionTemperature -> 25 Celsius,
				Output -> Options
			], ElutingSolutionTemperature],
			25 Celsius
		],

		Example[
			{Options, ElutingSolutionTemperatureEquilibrationTime, "ElutingSolutionTemperatureEquilibrationTime options allows specification of the amount of time that ElutingSolution is incubated to achieve the set ElutingSolutionTemperature:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ElutingSolutionTemperatureEquilibrationTime -> 1 Minute,
				Output -> Options
			], ElutingSolutionTemperatureEquilibrationTime],
			1 Minute
		],

		Example[
			{Options, CollectElutingSolution, "CollectElutingSolution options allows specification if the ElutingSolution is collected and saved after flushing through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				CollectElutingSolution -> True,
				Output -> Options
			], CollectElutingSolution],
			True
		],

		Example[
			{Options, ElutingSolutionCollectionContainer, "ElutingSolutionCollectionContainer options allows specification of the container that is used to accumulates any flow through solution in Eluting step:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				ElutingSolutionCollectionContainer -> Model[Container, Vessel, "15mL Tube"],
				Output -> Options
			], ElutingSolutionCollectionContainer],
			ObjectP[Model[Container, Vessel, "15mL Tube"]]
		],

		Example[
			{Options, ElutingSolutionDispenseRate, "ElutingSolutionDispenseRate options allows specification of the rate at which the ElutingSolution is applied to the sorbent by Instrument during Eluting step:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
				ElutingSolutionDispenseRate -> 3 Milliliter / Minute,
				Output -> Options
			], ElutingSolutionDispenseRate],
			3 Milliliter / Minute
		],

		Example[
			{Options, ElutingSolutionDrainTime, "ElutingSolutionDrainTime options allows specification of the amount of time to set on the Instrument for ElutingSolution to be flushed through the sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
				ElutingSolutionDrainTime -> 1 Minute,
				Output -> Options
			], ElutingSolutionDrainTime],
			1 Minute
		],

		Example[
			{Options, ElutingSolutionUntilDrained, "ElutingSolutionUntilDrained options allows indication if ElutingSolution is continually flushed through the cartridge in cycle of every ElutingDrainTime until it is drained entirely, or until MaxElutingDrainTime has been reached:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				ElutingSolutionUntilDrained -> True,
				Output -> Options
			], ElutingSolutionUntilDrained],
			True
		],

		Example[
			{Options, MaxElutingSolutionDrainTime, "MaxElutingSolutionDrainTime options allows specification of the maximum amount of time to flush ElutingSolution through sorbent:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				MaxElutingSolutionDrainTime -> {1 Minute, 1 Minute},
				Output -> Options
			], MaxElutingSolutionDrainTime],
			{1 Minute, 1 Minute}
		],

		Example[
			{Options, ElutingSolutionCentrifugeIntensity, "ElutingSolutionCentrifugeIntensity options allows specification of the rate at which the sample will be loaded into the extraction cartridge:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				LoadingSampleVolume -> 0.5 Milliliter,
				Instrument -> Model[Instrument, Centrifuge, "id:eGakldJEz14E"],
				ElutingSolutionCentrifugeIntensity -> 1000 RPM,
				Output -> Options
			], ElutingSolutionCentrifugeIntensity],
			1000 RPM
		],

		Example[
			{Options, ElutingSolutionPressure, "ElutingSolutionPressure options allows specification of the rate at which the sample will be loaded into the extraction cartridge:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, PressureManifold, "id:zGj91a7mElrL"],
				ElutingSolutionPressure -> 25 PSI,
				Output -> Options
			], ElutingSolutionPressure],
			25 PSI
		],

		(* Unit Operation Options Test *)
		Example[
			{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentSolidPhaseExtraction[
				{
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"]
					},
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"]
					}
				},
				PreparedModelContainer -> Model[Container, Vessel, "2mL Tube"],
				PreparedModelAmount -> 0.5 Milliliter,
				Output -> Options
			];
			prepUOs = Lookup[options, PreparatoryUnitOperations];
			{
				prepUOs[[-1, 1]][Sample],
				prepUOs[[-1, 1]][Container],
				prepUOs[[-1, 1]][Amount],
				prepUOs[[-1, 1]][Well],
				prepUOs[[-1, 1]][ContainerLabel]
			},
			{
				{ObjectP[{Model[Sample, "id:8qZ1VWNmdLBD"], Model[Sample, StockSolution, "id:WNa4ZjKR9wpV"]}]..},
				{ObjectP[Model[Container, Vessel, "2mL Tube"]]..},
				{EqualP[0.5 Milliliter]..},
				{"A1"..},
				{_String, _String, _String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[
			{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared (robotic):"},
			protocol = ExperimentSolidPhaseExtraction[
				{
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"]
					}
				},
				PreparedModelContainer -> Model[Container, Vessel, "2mL Tube"],
				PreparedModelAmount -> 0.5 Milliliter,
				Preparation -> Robotic
			];
			outputUOs = Download[protocol, OutputUnitOperations];
			robotUOs = Download[outputUOs[[1]], RoboticUnitOperations];
			{
				Download[outputUOs[[1]], SampleExpression],
				robotUOs
			},
			{
				{{ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, StockSolution, "NaCl Solution in Water"]]}},
				{ObjectP[Object[UnitOperation, LabelSample]], ObjectP[Object[UnitOperation, LabelSample]], ObjectP[Object[UnitOperation, Filter]]}
			},
			Variables :> {options, prepUOs},
			TimeConstraint -> 1000
		],
		Example[
			{Options, PreparatoryUnitOperations, "Use PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			protocol = ExperimentSolidPhaseExtraction[
				{"SPE sample 1", "SPE sample 2"},
				Instrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "SPE Container 1",
						Container -> Model[Container, Vessel, "2mL Tube"]
					],
					LabelContainer[
						Label -> "SPE Container 2",
						Container -> Model[Container, Vessel, "2mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, StockSolution, "NaCl Solution in Water"],
						Amount -> 1 Milliliter,
						Destination -> "SPE Container 1"
					],
					Transfer[
						Source -> Model[Sample, StockSolution, "NaCl Solution in Water"],
						Amount -> 1 Milliliter,
						Destination -> "SPE Container 2"
					],
					LabelSample[
						Label -> "SPE sample 1",
						Sample -> {"A1", "SPE Container 1"}
					],
					LabelSample[
						Label -> "SPE sample 2",
						Sample -> {"A1", "SPE Container 2"}
					]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol},
			TimeConstraint -> 1000
		],

		(* Shared option tests *)
		Example[
			{Options, Name, "Name the protocol for SolidPhaseExtraction:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Name -> "Test SPE Protocol",
				Output -> Options
			], Name],
			"Test SPE Protocol"
		],
		Example[
			{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ImageSample -> False,
				Output -> Options
			], ImageSample],
			False
		],
		Example[
			{Options, Template, "Inherit options from a previously run protocol:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Template -> Object[Protocol, SolidPhaseExtraction, "Test Protocol (ExperimentSolidPhaseExtraction)" <> $SessionUUID, UnresolvedOptions],
				Output -> Options
			], Instrument],
			ObjectP[Model[Instrument, PressureManifold, "Biotage PRESSURE+ 48 Positive Pressure Manifold"]]
		],
		Example[
			{Options, Incubate, "Incubate SamplesIn prior to SolidPhaseExtraction:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Incubate -> True,
				Output -> Options
			], Incubate],
			True
		],
		(* ExperimentIncubate tests. *)
		Example[
			{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Incubate -> True,
				Output -> Options
			], Incubate],
			True
		],
		Example[
			{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment or any aliquoting:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				IncubationTemperature -> 40 Celsius,
				Output -> Options
			], IncubationTemperature],
			40 Celsius,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment or any aliquoting:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				IncubationTime -> 40 Minute,
				Output -> Options
			], IncubationTime],
			40 Minute,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment or any aliquoting:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				MaxIncubationTime -> 40 Minute,
				Output -> Options
			], MaxIncubationTime],
			40 Minute,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment or any aliquoting:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				IncubationInstrument -> Model[Instrument, HeatBlock, "Thermal-Lok  2510-1104"],
				Output -> Options
			], IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "Thermal-Lok  2510-1104"]]
		],
		Example[
			{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment or any aliquoting:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				AnnealingTime -> 40 Minute,
				Output -> Options
			], AnnealingTime],
			40 Minute,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				IncubateAliquot -> 1 Milliliter,
				IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			], IncubateAliquot],
			1 Milliliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				IncubateAliquot -> 1 Milliliter,
				IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			], IncubateAliquotContainer],
			{
				{
					{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}, {2, ObjectP[Model[Container, Vessel, "2mL Tube"]]}
				},
				{{3, ObjectP[Model[Container, Vessel, "2mL Tube"]]}}
			}
		],
		Example[
			{Options, IncubateAliquotDestinationWell,"Specify the position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				IncubateAliquotDestinationWell->"A1",
				Output -> Options
			], IncubateAliquotDestinationWell],
			"A1"
		],

		(* ExperimentMix tests. *)
		Example[
			{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment or any aliquoting:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Mix -> True,
				Output -> Options
			], Mix],
			True
		],
		Example[
			{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment or any aliquoting:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				MixType -> Vortex,
				Output -> Options
			], MixType],
			Vortex
		],
		Example[
			{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment or any aliquoting:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				MixUntilDissolved -> True,
				Output -> Options
			], MixUntilDissolved],
			True
		],

		(* ExperimentCentrifuge *)
		Example[
			{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Centrifuge -> True,
				Output -> Options
			], Centrifuge],
			True,
			Messages :> {
				Warning::SampleStowaways
			}
		],
		Example[
			{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"],
				Output -> Options
			], Warning::SampleStowaways], CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]]
		],
		Example[
			{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				CentrifugeIntensity -> 1000 RPM,
				Output -> Options
			], Warning::SampleStowaways], CentrifugeIntensity],
			1000 RPM
		],
		Example[
			{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				CentrifugeTime -> 5 Minute,
				Output -> Options
			], Warning::SampleStowaways], CentrifugeTime],
			5 Minute,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				CentrifugeTemperature -> 10 Celsius,
				Output -> Options
			], Warning::SampleStowaways], CentrifugeTemperature],
			10 Celsius,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				CentrifugeAliquot -> 1 Milliliter,
				CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"],
				Output -> Options
			], Warning::SampleStowaways], CentrifugeAliquot],
			1 Milliliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				CentrifugeAliquot -> 1 Milliliter,
				CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"],
				Output -> Options
			], Warning::SampleStowaways], CentrifugeAliquotContainer],
			{
				{
					{1, ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]},
					{2, ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]}
				},
				{
					{3, ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]}
				}
			}
		],
		Example[
			{Options, CentrifugeAliquotDestinationWell, "Indicates the position in the centrifuge aliquot container that the sample should be moved into:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				CentrifugeAliquot -> 1 Milliliter,
				CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"],
				CentrifugeAliquotDestinationWell -> "A1",
				Output -> Options
			], Warning::SampleStowaways], CentrifugeAliquotDestinationWell],
			"A1"
		],

		(*ExperimentFilter*)
		Example[
			{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Filtration -> True,
				Output -> Options
			], Warning::SampleStowaways], Filtration],
			True
		],
		Example[
			{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				FiltrationType -> Syringe,
				Output -> Options
			], Warning::SampleStowaways], FiltrationType],
			Syringe
		],
		Example[
			{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"],
				Output -> Options
			], Warning::SampleStowaways], FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]]
		],
		Example[
			{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Filter -> Model[Item, Filter, "Disk Filter, GxF/PTFE, 0.22um, 25mm"],
				Output -> Options
			], Warning::SampleStowaways], Filter],
			ObjectP[Model[Item, Filter, "Disk Filter, GxF/PTFE, 0.22um, 25mm"]]
		],
		Example[
			{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				FilterMaterial -> PES,
				Output -> Options
			], Warning::SampleStowaways], FilterMaterial],
			PES
		],
		Example[
			{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				PrefilterMaterial -> GxF,
				FilterMaterial -> PTFE,
				Output -> Options
			], Warning::SampleStowaways], PrefilterMaterial],
			GxF
		],
		Example[
			{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				FilterPoreSize -> 0.22 * Micrometer,
				Output -> Options
			], Warning::SampleStowaways], FilterPoreSize],
			0.22 Micrometer
		],
		Example[
			{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				PrefilterPoreSize -> 1. * Micrometer,
				FilterMaterial -> PTFE,
				Output -> Options
			], Warning::SampleStowaways], PrefilterPoreSize],
			1. * Micrometer
		],
		Example[
			{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				FiltrationType -> Syringe,
				FilterSyringe -> Model[Container, Syringe, "id:AEqRl9Kz1VD1"],
				Output -> Options
			], Warning::SampleStowaways], FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]]
		],
		Example[
			{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				FiltrationType -> Vacuum,
				FilterHousing -> Model[Instrument, FilterBlock, "Filter Block"],
				FilterAliquot -> 0.5 Milliliter,
				Output -> Options
			], Warning::SampleStowaways], FilterHousing],
			ObjectP[Model[Instrument, FilterBlock, "Filter Block"]]
		],
		Example[
			{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				FilterAliquot -> 1 Milliliter,
				FiltrationType -> Centrifuge,
				FilterIntensity -> 1000 * RPM,
				Output -> Options
			], Warning::SampleStowaways], FilterIntensity],
			1000 * RPM
		],
		Example[
			{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				FilterAliquot -> 1 Milliliter,
				FiltrationType -> Centrifuge,
				FilterTime -> 20 * Minute,
				Output -> Options
			], Warning::SampleStowaways], FilterTime],
			20 * Minute
		],
		Example[
			{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				FilterAliquot -> 1 Milliliter,
				FiltrationType -> Centrifuge,
				FilterTemperature -> 22 * Celsius,
				Output -> Options
			], Warning::SampleStowaways], FilterTemperature],
			22 * Celsius
		],
		Example[
			{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				FilterAliquot -> 1 * Milliliter,
				Output -> Options
			], Warning::SampleStowaways], FilterAliquot],
			1 * Milliliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				FilterAliquotContainer -> Model[Container, Vessel, "50mL Tube"],
				Output -> Options
			], Warning::SampleStowaways], FilterAliquotContainer],
			{
				{
					{1, ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]},
					{2, ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]}
				},
				{
					{3, ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]}
				}
			}
		],
		Example[
			{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				FilterContainerOut -> Model[Container, Vessel, "50mL Tube"],
				Output -> Options
			], Warning::SampleStowaways], FilterContainerOut],
			{
				{
					{1, ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]},
					{2, ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]}
				},
				{
					{3, ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]}
				}
			}
		],
		Example[
			{Options, FilterAliquotDestinationWell,"Specify the position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				FilterAliquotDestinationWell->"A1",
				Output -> Options
			], Warning::SampleStowaways], FilterAliquotDestinationWell],
			"A1"
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[
			{Options, FilterSterile,"Specify if the filtration of the samples should be done in a sterile environment:"},
			Lookup[Quiet[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				FilterSterile->True,
				Output -> Options
			], Warning::SampleStowaways], FilterSterile],
			True
		],*)

		(* post processing *)
		Example[
			{Options, MeasureVolume, "Specify if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				MeasureVolume -> False,
				Output -> Options
			], MeasureVolume],
			False
		],
		Example[
			{Options, MeasureWeight, "Specify if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				MeasureWeight-> False,
				Output -> Options
			], MeasureWeight],
			False
		],
		Example[
			{Options, SamplesInStorageCondition, "Use the SamplesInStorageCondition option to set the StorageCondition to which the SamplesIn will be set at the end of the protocol:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				SamplesInStorageCondition -> Refrigerator,
				Output -> Options
			], SamplesInStorageCondition],
			Refrigerator
		],
		Example[
			{Options, SamplesOutStorageCondition, "Use the SamplesOutStorageCondition option to set the StorageCondition to which the SamplesOut will be set at the end of the protocol:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				SamplesOutStorageCondition -> Refrigerator,
				Output -> Options
			], SamplesOutStorageCondition],
			Refrigerator
		],
		Example[
			{Options, ExtractionCartridgeStorageCondition, "Use the ExtractionCartridgeStorageCondition option to set the StorageCondition to which the ExtractionCartridge will be set at the end of the protocol:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				ExtractionCartridgeStorageCondition -> Refrigerator,
				Output -> Options
			], ExtractionCartridgeStorageCondition],
			Refrigerator
		],
		Example[
			{Options, Preparation, "Set whether to use the WorkCell or manual methods to perform this solid phase extraction:"},
			Lookup[ExperimentSolidPhaseExtraction[
				{
					{
						Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
						Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
				},
				Preparation -> Manual,
				Output -> Options
			], Preparation],
			Manual
		]

	},
	Parallel -> True,
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		(* want the manual tests to still pass even if we're not yet supporting in lab *)
		$SPERoboticOnly = False
	},
	(* need to put this in SetUp/TearDown because Parallel -> True *)
	SetUp :> (ClearMemoization[]; Off[Warning::SamplesOutOfStock]),
	TearDown :> (On[Warning::SamplesOutOfStock]),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[DeleteDuplicates[Flatten[{
				Download[
					Object[Protocol, SolidPhaseExtraction, "Test Protocol (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					{
						Object,
						ProcedureLog[Object],
						RequiredResources[[All, 1]][Object]
					}
				],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge 6 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 2 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 3 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Room, "Test Room (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Bench, "Test Bench (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 3 - 2 mL in Plate 2 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 4 - 2 mL in Tube 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 5 - 8 mL in Tube 2 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 7 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 1 - 96 well dwp (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 2 - 96 well dwp (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 1 - 50 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 2 - 50 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 3 - 50 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 4 - 50 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 8 - 500 mL in Bottle 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 9 - 2 mL in Tube 4 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Bottle 1 - 1L Glass Bottle (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Plate, Filter, "Test Plate SPE 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Model[Container, Plate, Filter, "Test Plate SPE Model (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Instrument, LiquidHandler, "Test Gilson LiquidHandler 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Gilson Waste Container (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
			}]], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjs, Force -> True, Verbose -> False]];

		];
		Module[
			{
				protocol,
				modelCartridge,
				modelCartridge6mL,
				objectCartridge1,
				objectCartridge2,
				objectCartridge3,
				room, bench,
				sample1, sample2, sample3, sample4, sample5, sample6, sample7,
				plate1, plate2, tube1, tube2, tube3,
				sample8, bottle1,
				sample9, tube4,
				plateFilter, plateFilterModel,
				instrumentGilson, gilsonWasteContainer
			},

			{
				(*1*)modelCartridge,
				(*2*)modelCartridge6mL,
				(*3*)room,
				(*4*)plateFilterModel,
				(*5*)instrumentGilson
			} = CreateID[{
				(*1*)Model[Container, ExtractionCartridge],
				(*2*)Model[Container, ExtractionCartridge],
				(*3*)Object[Container, Room],
				(*4*)Model[Container, Plate, Filter],
				(*5*)Object[Instrument, LiquidHandler]
			}];

			(* upload room and bench *)
			Upload[<|
				Object -> room,
				DeveloperObject -> True,
				Model -> Link[Model[Container, Room, "Chemistry Lab"], Objects],
				Name -> "Test Room (ExperimentSolidPhaseExtraction)" <> $SessionUUID
			|>];
			bench = UploadSample[
				Model[Container, Bench, "The Bench of Testing"],
				{"Bench Slot 4", room},
				Name -> "Test Bench (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
				FastTrack -> True
			];

			(* upload the model cartridge we're using to make containers *)
			Upload[<|
				Object -> modelCartridge,
				DeveloperObject -> True,
				Name -> "Test Model ExtractionCartridge (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
				MaxVolume -> 3 Milliliter,
				FunctionalGroup -> C18,
				SeparationMode -> ReversePhase,
				DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
			|>];

			{
				plate1,
				plate2,
				tube1,
				tube2,
				tube3,
				tube4,
				objectCartridge1,
				objectCartridge2,
				objectCartridge3,
				bottle1,
				plateFilter,
				gilsonWasteContainer
			} = UploadSample[
				{
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					modelCartridge,
					modelCartridge,
					modelCartridge,
					Model[Container, Vessel, "1L Glass Bottle"],
					Model[Container, Plate, Filter, "Sep-Pak C18 96-well Plate, 40 mg, Plate extraction cartridge"],
					Model[Container, Vessel, "10L Polypropylene Carboy"]

				},
				{
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench}
				},
				Name -> {
					"Test Plate 1 - 96 well dwp (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Plate 2 - 96 well dwp (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Tube 1 - 50 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Tube 2 - 50 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Tube 3 - 50 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Tube 4 - 50 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Object ExtractionCartridge 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Object ExtractionCartridge 2 (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Object ExtractionCartridge 3 (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Bottle 1 - 1L Glass Bottle (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Plate SPE 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Gilson Waste Container (ExperimentSolidPhaseExtraction)" <> $SessionUUID
				}
			];


			(*instruments, cartridge models, cartridge model plates*)
			Upload[{
				<|
					Object -> instrumentGilson,
					DeveloperObject -> True,
					Model -> Link[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"], Objects],
					Container -> Link[bench, Contents, 2],
					Name -> "Test Gilson LiquidHandler 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					WasteContainer -> Link[gilsonWasteContainer],
					Site -> Link[$Site]
				|>,
				<|
					Object -> modelCartridge6mL,
					DeveloperObject -> True,
					Name -> "Test Model ExtractionCartridge 6 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					MaxVolume -> 6 Milliliter,
					FunctionalGroup -> C18,
					SeparationMode -> ReversePhase,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>,
				<|
					Object -> plateFilterModel,
					DeveloperObject -> True,
					Name -> "Test Plate SPE Model (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					MaxVolume -> 1.1 Milliliter,
					FunctionalGroup -> C18,
					SeparationMode -> ReversePhase,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					NumberOfWells -> 96
				|>
			}];

			{
				sample4, sample5, sample1, sample2, sample3, sample6, sample7, sample8, sample9
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Sulfuric acid"]
				},
				{
					{"A1", tube1},
					{"A1", tube2},
					{"A1", plate1},
					{"A2", plate1},
					{"A1", plate2},
					{"A3", plate1},
					{"A4", plate1},
					{"A1", bottle1},
					{"A1", tube4}
				},
				Name -> {
					"Test Sample 4 - 2 mL in Tube 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 5 - 8 mL in Tube 2 (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 3 - 2 mL in Plate 2 (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 7 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 8 - 500 mL in Bottle 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 9 - 2 mL in Tube 4 (ExperimentSolidPhaseExtraction)" <> $SessionUUID
				},
				InitialAmount -> {
					2 Milliliter,
					8 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					500 Milliliter,
					2 Milliliter
				}
			];

			(* protocol *)
			protocol = Block[{$SPERoboticOnly = False},
				ExperimentSolidPhaseExtraction[
					{
						{
							Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
							Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
						},
						Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
					},
					Name -> "Test Protocol (ExperimentSolidPhaseExtraction)" <> $SessionUUID,
					Instrument -> Model[Instrument, PressureManifold, "Biotage PRESSURE+ 48 Positive Pressure Manifold"]
				]
			];

			Upload[<|Object -> #, DeveloperObject -> True|>& /@ {
				bench,
				plate1, plate2, tube1, tube2, tube3, objectCartridge1, objectCartridge2, objectCartridge3, bottle1, plateFilter, gilsonWasteContainer,
				sample4, sample5, sample1, sample2, sample3, sample6, sample7, sample8,
				protocol
			}]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[DeleteDuplicates[Flatten[{
				Download[
					Object[Protocol, SolidPhaseExtraction, "Test Protocol (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
					{
						Object,
						ProcedureLog[Object],
						RequiredResources[[All, 1]][Object]
					}
				],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge 6 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 2 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 3 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Room, "Test Room (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Bench, "Test Bench (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 3 - 2 mL in Plate 2 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 4 - 2 mL in Tube 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 5 - 8 mL in Tube 2 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 7 - 2 mL in Plate 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 1 - 96 well dwp (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 2 - 96 well dwp (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 1 - 50 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 2 - 50 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 3 - 50 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 4 - 50 mL (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 8 - 500 mL in Bottle 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 9 - 2 mL in Tube 4 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Bottle 1 - 1L Glass Bottle (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Plate, Filter, "Test Plate SPE 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Model[Container, Plate, Filter, "Test Plate SPE Model (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Instrument, LiquidHandler, "Test Gilson LiquidHandler 1 (ExperimentSolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Gilson Waste Container (ExperimentSolidPhaseExtraction)" <> $SessionUUID]
			}]], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjs, Force -> True, Verbose -> False]];

		]
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentSolidPhaseExtractionOptions*)
DefineTests[ExperimentSolidPhaseExtractionOptions,
	{
		Example[{Basic, "Return options for each sample used in solid phase extraction:"},
			ExperimentSolidPhaseExtractionOptions[
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID]
			],
			_Grid
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		(* want the manual tests to still pass even if we're not yet supporting in lab *)
		$SPERoboticOnly = False
	},
	SetUp :> (ClearMemoization[]),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[DeleteDuplicates[Flatten[{
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge 6 mL (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 2 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 3 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Room, "Test Room (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Bench, "Test Bench (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 3 - 2 mL in Plate 2 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 4 - 2 mL in Tube 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 5 - 8 mL in Tube 2 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 7 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 1 - 96 well dwp (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 2 - 96 well dwp (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 1 - 50 mL (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 2 - 50 mL (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 3 - 50 mL (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 8 - 500 mL in Bottle 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Vessel, "Test Bottle 1 - 1L Glass Bottle (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Plate, Filter, "Test Plate SPE 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Model[Container, Plate, Filter, "Test Plate SPE Model (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Instrument, LiquidHandler, "Test Gilson LiquidHandler 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Vessel, "Test Gilson Waste Container (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID]
			}]], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjs, Force -> True, Verbose -> False]];

		];
		Module[
			{
				modelCartridge,
				modelCartridge6mL,
				objectCartridge1,
				objectCartridge2,
				objectCartridge3,
				room, bench,
				sample1, sample2, sample3, sample4, sample5, sample6, sample7,
				plate1, plate2, tube1, tube2, tube3,
				sample8, bottle1,
				plateFilter, plateFilterModel,
				instrumentGilson, gilsonWasteContainer
			},

			{
				(*1*)modelCartridge,
				(*2*)modelCartridge6mL,
				(*3*)room,
				(*4*)plateFilterModel,
				(*5*)instrumentGilson
			} = CreateID[{
				(*1*)Model[Container, ExtractionCartridge],
				(*2*)Model[Container, ExtractionCartridge],
				(*3*)Object[Container, Room],
				(*4*)Model[Container, Plate, Filter],
				(*5*)Object[Instrument, LiquidHandler]
			}];

			(* upload room and bench *)
			Upload[<|
				Object -> room,
				DeveloperObject -> True,
				Model -> Link[Model[Container, Room, "Chemistry Lab"], Objects],
				Name -> "Test Room (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID
			|>];
			bench = UploadSample[
				Model[Container, Bench, "The Bench of Testing"],
				{"Bench Slot 4", room},
				Name -> "Test Bench (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
				FastTrack -> True
			];

			(* upload the model cartridge we're using to make containers *)
			Upload[<|
				Object -> modelCartridge,
				DeveloperObject -> True,
				Name -> "Test Model ExtractionCartridge (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
				MaxVolume -> 3 Milliliter,
				FunctionalGroup -> C18,
				SeparationMode -> ReversePhase,
				DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
			|>];

			{
				plate1,
				plate2,
				tube1,
				tube2,
				tube3,
				objectCartridge1,
				objectCartridge2,
				objectCartridge3,
				bottle1,
				plateFilter,
				gilsonWasteContainer
			} = UploadSample[
				{
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					modelCartridge,
					modelCartridge,
					modelCartridge,
					Model[Container, Vessel, "1L Glass Bottle"],
					Model[Container, Plate, Filter, "Sep-Pak C18 96-well Plate, 40 mg, Plate extraction cartridge"],
					Model[Container, Vessel, "10L Polypropylene Carboy"]

				},
				{
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench}
				},
				Name -> {
					"Test Plate 1 - 96 well dwp (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Plate 2 - 96 well dwp (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Tube 1 - 50 mL (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Tube 2 - 50 mL (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Tube 3 - 50 mL (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Object ExtractionCartridge 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Object ExtractionCartridge 2 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Object ExtractionCartridge 3 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Bottle 1 - 1L Glass Bottle (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Plate SPE 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Gilson Waste Container (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID
				}
			];


			(*instruments, cartridge models, cartridge model plates*)
			Upload[{
				<|
					Object -> instrumentGilson,
					DeveloperObject -> True,
					Model -> Link[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"], Objects],
					Container -> Link[bench, Contents, 2],
					Name -> "Test Gilson LiquidHandler 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					WasteContainer -> Link[gilsonWasteContainer]
				|>,
				<|
					Object -> modelCartridge6mL,
					DeveloperObject -> True,
					Name -> "Test Model ExtractionCartridge 6 mL (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					MaxVolume -> 6 Milliliter,
					FunctionalGroup -> C18,
					SeparationMode -> ReversePhase,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>,
				<|
					Object -> plateFilterModel,
					DeveloperObject -> True,
					Name -> "Test Plate SPE Model (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					MaxVolume -> 1.1 Milliliter,
					FunctionalGroup -> C18,
					SeparationMode -> ReversePhase,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					NumberOfWells -> 96
				|>
			}];

			{
				sample4, sample5, sample1, sample2, sample3, sample6, sample7, sample8
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", tube1},
					{"A1", tube2},
					{"A1", plate1},
					{"A2", plate1},
					{"A1", plate2},
					{"A3", plate1},
					{"A4", plate1},
					{"A1", bottle1}
				},
				Name -> {
					"Test Sample 4 - 2 mL in Tube 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Sample 5 - 8 mL in Tube 2 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Sample 3 - 2 mL in Plate 2 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Sample 7 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID,
					"Test Sample 8 - 500 mL in Bottle 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID
				},
				InitialAmount -> {
					2 Milliliter,
					8 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					500 Milliliter
				}
			];

			Upload[<|Object -> #, DeveloperObject -> True|>& /@ {
				bench,
				plate1, plate2, tube1, tube2, tube3, objectCartridge1, objectCartridge2, objectCartridge3, bottle1, plateFilter, gilsonWasteContainer,
				sample4, sample5, sample1, sample2, sample3, sample6, sample7, sample8
			}]
		]
	),
	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[DeleteDuplicates[Flatten[{
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge 6 mL (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 2 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 3 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Room, "Test Room (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Bench, "Test Bench (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 3 - 2 mL in Plate 2 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 4 - 2 mL in Tube 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 5 - 8 mL in Tube 2 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 7 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 1 - 96 well dwp (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 2 - 96 well dwp (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 1 - 50 mL (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 2 - 50 mL (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 3 - 50 mL (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Sample, "Test Sample 8 - 500 mL in Bottle 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Vessel, "Test Bottle 1 - 1L Glass Bottle (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Plate, Filter, "Test Plate SPE 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Model[Container, Plate, Filter, "Test Plate SPE Model (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Instrument, LiquidHandler, "Test Gilson LiquidHandler 1 (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID],
				Object[Container, Vessel, "Test Gilson Waste Container (ExperimentSolidPhaseExtractionOptions)" <> $SessionUUID]
			}]], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjs, Force -> True, Verbose -> False]];

		]
	}
];





(* ::Subsection::Closed:: *)
(*ExperimentSolidPhaseExtractionPreview*)
DefineTests[ExperimentSolidPhaseExtractionPreview,
	{
		Example[{Basic, "Return nothing for each sample used in solid phase extraction:"},
			ExperimentSolidPhaseExtractionPreview[
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID]
			],
			Null
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		(* want the manual tests to still pass even if we're not yet supporting in lab *)
		$SPERoboticOnly = False
	},
	SetUp :> (ClearMemoization[]),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Module[{objs, existingObjs},
			objs = {
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge 6 mL (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 2 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 3 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Room, "Test Room (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Bench, "Test Bench (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 3 - 2 mL in Plate 2 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 4 - 2 mL in Tube 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 5 - 8 mL in Tube 2 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 7 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 1 - 96 well dwp (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 2 - 96 well dwp (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 1 - 50 mL (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 2 - 50 mL (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 3 - 50 mL (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 8 - 500 mL in Bottle 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Vessel, "Test Bottle 1 - 1L Glass Bottle (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Plate, Filter, "Test Plate SPE 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Model[Container, Plate, Filter, "Test Plate SPE Model (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Instrument, LiquidHandler, "Test Gilson LiquidHandler 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Vessel, "Test Gilson Waste Container (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjs, Force -> True, Verbose -> False]];

		];
		Module[
			{
				modelCartridge,
				modelCartridge6mL,
				objectCartridge1,
				objectCartridge2,
				objectCartridge3,
				room, bench,
				sample1, sample2, sample3, sample4, sample5, sample6, sample7,
				plate1, plate2, tube1, tube2, tube3,
				sample8, bottle1,
				plateFilter, plateFilterModel,
				instrumentGilson, gilsonWasteContainer
			},

			{
				(*1*)modelCartridge,
				(*2*)modelCartridge6mL,
				(*3*)room,
				(*4*)plateFilterModel,
				(*5*)instrumentGilson
			} = CreateID[{
				(*1*)Model[Container, ExtractionCartridge],
				(*2*)Model[Container, ExtractionCartridge],
				(*3*)Object[Container, Room],
				(*4*)Model[Container, Plate, Filter],
				(*5*)Object[Instrument, LiquidHandler]
			}];

			(* upload room and bench *)
			Upload[<|
				Object -> room,
				DeveloperObject -> True,
				Model -> Link[Model[Container, Room, "Chemistry Lab"], Objects],
				Name -> "Test Room (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID
			|>];
			bench = UploadSample[
				Model[Container, Bench, "The Bench of Testing"],
				{"Bench Slot 4", room},
				Name -> "Test Bench (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
				FastTrack -> True
			];

			(* upload the model cartridge we're using to make containers *)
			Upload[<|
				Object -> modelCartridge,
				DeveloperObject -> True,
				Name -> "Test Model ExtractionCartridge (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
				MaxVolume -> 3 Milliliter,
				FunctionalGroup -> C18,
				SeparationMode -> ReversePhase,
				DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
			|>];

			{
				plate1,
				plate2,
				tube1,
				tube2,
				tube3,
				objectCartridge1,
				objectCartridge2,
				objectCartridge3,
				bottle1,
				plateFilter,
				gilsonWasteContainer
			} = UploadSample[
				{
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					modelCartridge,
					modelCartridge,
					modelCartridge,
					Model[Container, Vessel, "1L Glass Bottle"],
					Model[Container, Plate, Filter, "Sep-Pak C18 96-well Plate, 40 mg, Plate extraction cartridge"],
					Model[Container, Vessel, "10L Polypropylene Carboy"]

				},
				{
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench}
				},
				Name -> {
					"Test Plate 1 - 96 well dwp (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Plate 2 - 96 well dwp (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Tube 1 - 50 mL (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Tube 2 - 50 mL (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Tube 3 - 50 mL (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Object ExtractionCartridge 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Object ExtractionCartridge 2 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Object ExtractionCartridge 3 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Bottle 1 - 1L Glass Bottle (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Plate SPE 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Gilson Waste Container (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID
				}
			];


			(*instruments, cartridge models, cartridge model plates*)
			Upload[{
				<|
					Object -> instrumentGilson,
					DeveloperObject -> True,
					Model -> Link[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"], Objects],
					Container -> Link[bench, Contents, 2],
					Name -> "Test Gilson LiquidHandler 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					WasteContainer -> Link[gilsonWasteContainer]
				|>,
				<|
					Object -> modelCartridge6mL,
					DeveloperObject -> True,
					Name -> "Test Model ExtractionCartridge 6 mL (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					MaxVolume -> 6 Milliliter,
					FunctionalGroup -> C18,
					SeparationMode -> ReversePhase,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>,
				<|
					Object -> plateFilterModel,
					DeveloperObject -> True,
					Name -> "Test Plate SPE Model (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					MaxVolume -> 1.1 Milliliter,
					FunctionalGroup -> C18,
					SeparationMode -> ReversePhase,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					NumberOfWells -> 96
				|>
			}];

			{
				sample4, sample5, sample1, sample2, sample3, sample6, sample7, sample8
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", tube1},
					{"A1", tube2},
					{"A1", plate1},
					{"A2", plate1},
					{"A1", plate2},
					{"A3", plate1},
					{"A4", plate1},
					{"A1", bottle1}
				},
				Name -> {
					"Test Sample 4 - 2 mL in Tube 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Sample 5 - 8 mL in Tube 2 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Sample 3 - 2 mL in Plate 2 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Sample 7 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID,
					"Test Sample 8 - 500 mL in Bottle 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID
				},
				InitialAmount -> {
					2 Milliliter,
					8 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					500 Milliliter
				}
			];

			Upload[<|Object -> #, DeveloperObject -> True|>& /@ {
				bench,
				plate1, plate2, tube1, tube2, tube3, objectCartridge1, objectCartridge2, objectCartridge3, bottle1, plateFilter, gilsonWasteContainer,
				sample4, sample5, sample1, sample2, sample3, sample6, sample7, sample8
			}]
		]
	),
	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		Module[{objs, existingObjs},
			objs = {
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge 6 mL (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 2 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 3 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Room, "Test Room (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Bench, "Test Bench (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 3 - 2 mL in Plate 2 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 4 - 2 mL in Tube 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 5 - 8 mL in Tube 2 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 7 - 2 mL in Plate 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 1 - 96 well dwp (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 2 - 96 well dwp (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 1 - 50 mL (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 2 - 50 mL (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 3 - 50 mL (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Sample, "Test Sample 8 - 500 mL in Bottle 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Vessel, "Test Bottle 1 - 1L Glass Bottle (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Plate, Filter, "Test Plate SPE 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Model[Container, Plate, Filter, "Test Plate SPE Model (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Instrument, LiquidHandler, "Test Gilson LiquidHandler 1 (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID],
				Object[Container, Vessel, "Test Gilson Waste Container (ExperimentSolidPhaseExtractionPreview)" <> $SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjs, Force -> True, Verbose -> False]];

		]
	}
];



(* ::Subsection::Closed:: *)
(*ValidExperimentSolidPhaseExtractionQ*)
DefineTests[ValidExperimentSolidPhaseExtractionQ,
	{
		Example[{Basic, "Return boolean if the solid phase extraction can be run on the sample or not:"},
			ValidExperimentSolidPhaseExtractionQ[
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID]
			],
			True
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		(* want the manual tests to still pass even if we're not yet supporting in lab *)
		$SPERoboticOnly = False
	},
	SetUp :> (ClearMemoization[]),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[DeleteDuplicates[Flatten[{
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge 6 mL (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 2 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 3 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Room, "Test Room (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Bench, "Test Bench (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 3 - 2 mL in Plate 2 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 4 - 2 mL in Tube 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 5 - 8 mL in Tube 2 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 7 - 2 mL in Plate 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 1 - 96 well dwp (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 2 - 96 well dwp (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 1 - 50 mL (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 2 - 50 mL (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 3 - 50 mL (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 8 - 500 mL in Bottle 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Vessel, "Test Bottle 1 - 1L Glass Bottle (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Plate, Filter, "Test Plate SPE 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Model[Container, Plate, Filter, "Test Plate SPE Model (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Instrument, LiquidHandler, "Test Gilson LiquidHandler 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Vessel, "Test Gilson Waste Container (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID]
			}]], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjs, Force -> True, Verbose -> False]];

		];
		Module[
			{
				protocol,
				modelCartridge,
				modelCartridge6mL,
				objectCartridge1,
				objectCartridge2,
				objectCartridge3,
				room, bench,
				sample1, sample2, sample3, sample4, sample5, sample6, sample7,
				plate1, plate2, tube1, tube2, tube3,
				sample8, bottle1,
				plateFilter, plateFilterModel,
				instrumentGilson, gilsonWasteContainer
			},

			{
				(*1*)modelCartridge,
				(*2*)modelCartridge6mL,
				(*3*)room,
				(*4*)plateFilterModel,
				(*5*)instrumentGilson
			} = CreateID[{
				(*1*)Model[Container, ExtractionCartridge],
				(*2*)Model[Container, ExtractionCartridge],
				(*3*)Object[Container, Room],
				(*4*)Model[Container, Plate, Filter],
				(*5*)Object[Instrument, LiquidHandler]
			}];

			(* upload room and bench *)
			Upload[<|
				Object -> room,
				DeveloperObject -> True,
				Model -> Link[Model[Container, Room, "Chemistry Lab"], Objects],
				Name -> "Test Room (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID
			|>];
			bench = UploadSample[
				Model[Container, Bench, "The Bench of Testing"],
				{"Bench Slot 4", room},
				Name -> "Test Bench (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
				FastTrack -> True
			];

			(* upload the model cartridge we're using to make containers *)
			Upload[<|
				Object -> modelCartridge,
				DeveloperObject -> True,
				Name -> "Test Model ExtractionCartridge (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
				MaxVolume -> 3 Milliliter,
				FunctionalGroup -> C18,
				SeparationMode -> ReversePhase,
				DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
			|>];

			{
				plate1,
				plate2,
				tube1,
				tube2,
				tube3,
				objectCartridge1,
				objectCartridge2,
				objectCartridge3,
				bottle1,
				plateFilter,
				gilsonWasteContainer
			} = UploadSample[
				{
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					modelCartridge,
					modelCartridge,
					modelCartridge,
					Model[Container, Vessel, "1L Glass Bottle"],
					Model[Container, Plate, Filter, "Sep-Pak C18 96-well Plate, 40 mg, Plate extraction cartridge"],
					Model[Container, Vessel, "10L Polypropylene Carboy"]

				},
				{
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench}
				},
				Name -> {
					"Test Plate 1 - 96 well dwp (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Plate 2 - 96 well dwp (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Tube 1 - 50 mL (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Tube 2 - 50 mL (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Tube 3 - 50 mL (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Object ExtractionCartridge 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Object ExtractionCartridge 2 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Object ExtractionCartridge 3 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Bottle 1 - 1L Glass Bottle (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Plate SPE 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Gilson Waste Container (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID
				}
			];


			(*instruments, cartridge models, cartridge model plates*)
			Upload[{
				<|
					Object -> instrumentGilson,
					DeveloperObject -> True,
					Model -> Link[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"], Objects],
					Container -> Link[bench, Contents, 2],
					Name -> "Test Gilson LiquidHandler 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					WasteContainer -> Link[gilsonWasteContainer]
				|>,
				<|
					Object -> modelCartridge6mL,
					DeveloperObject -> True,
					Name -> "Test Model ExtractionCartridge 6 mL (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					MaxVolume -> 6 Milliliter,
					FunctionalGroup -> C18,
					SeparationMode -> ReversePhase,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>,
				<|
					Object -> plateFilterModel,
					DeveloperObject -> True,
					Name -> "Test Plate SPE Model (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					MaxVolume -> 1.1 Milliliter,
					FunctionalGroup -> C18,
					SeparationMode -> ReversePhase,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					NumberOfWells -> 96
				|>
			}];

			{
				sample4, sample5, sample1, sample2, sample3, sample6, sample7, sample8
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", tube1},
					{"A1", tube2},
					{"A1", plate1},
					{"A2", plate1},
					{"A1", plate2},
					{"A3", plate1},
					{"A4", plate1},
					{"A1", bottle1}
				},
				Name -> {
					"Test Sample 4 - 2 mL in Tube 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Sample 5 - 8 mL in Tube 2 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Sample 1 - 2 mL in Plate 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Sample 2 - 2 mL in Plate 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Sample 3 - 2 mL in Plate 2 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Sample 6 - 2 mL in Plate 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Sample 7 - 2 mL in Plate 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID,
					"Test Sample 8 - 500 mL in Bottle 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID
				},
				InitialAmount -> {
					2 Milliliter,
					8 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					500 Milliliter
				}
			];

			Upload[<|Object -> #, DeveloperObject -> True|>& /@ {
				bench,
				plate1, plate2, tube1, tube2, tube3, objectCartridge1, objectCartridge2, objectCartridge3, bottle1, plateFilter, gilsonWasteContainer,
				sample4, sample5, sample1, sample2, sample3, sample6, sample7, sample8
			}]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[DeleteDuplicates[Flatten[{
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge 6 mL (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 2 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 3 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Room, "Test Room (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Bench, "Test Bench (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 3 - 2 mL in Plate 2 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 4 - 2 mL in Tube 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 5 - 8 mL in Tube 2 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 7 - 2 mL in Plate 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 1 - 96 well dwp (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 2 - 96 well dwp (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 1 - 50 mL (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 2 - 50 mL (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 3 - 50 mL (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Sample, "Test Sample 8 - 500 mL in Bottle 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Vessel, "Test Bottle 1 - 1L Glass Bottle (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Plate, Filter, "Test Plate SPE 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Model[Container, Plate, Filter, "Test Plate SPE Model (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Instrument, LiquidHandler, "Test Gilson LiquidHandler 1 (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID],
				Object[Container, Vessel, "Test Gilson Waste Container (ValidExperimentSolidPhaseExtractionQ)" <> $SessionUUID]
			}]], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjs, Force -> True, Verbose -> False]];

		]
	)
];

(* ::Subsection::Closed:: *)
(*resolveSolidPhaseExtractionMethod*)
DefineTests[resolveSolidPhaseExtractionMethod,
	{
		Example[{Basic, "return preparation that will be used in solid phase extraction "},
			resolveSolidPhaseExtractionMethod[
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID]
			],
			Manual
		]
	},
	Stubs :> {
		$SPERoboticOnly = False,
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (ClearMemoization[]),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Module[
			{
				protocol,
				modelCartridge,
				modelCartridge6mL,
				objectCartridge1,
				objectCartridge2,
				objectCartridge3,
				allObjects, existObjects,
				room, bench,
				sample1, sample2, sample3, sample4, sample5, sample6, sample7,
				plate1, plate2, tube1, tube2, tube3,
				sample8, bottle1,
				plateFilter, plateFilterModel,
				instrumentGilson, gilsonWasteContainer
			},

			allObjects = {
				Object[Protocol, SolidPhaseExtraction, "Test Protocol (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge 6 mL (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 2 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 3 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Room, "Test Room (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Bench, "Test Bench (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 3 - 2 mL in Plate 2 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 4 - 2 mL in Tube 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 5 - 8 mL in Tube 2 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 7 - 2 mL in Plate 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 1 - 96 well dwp (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 2 - 96 well dwp (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 1 - 50 mL (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 2 - 50 mL (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 3 - 50 mL (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 8 - 500 mL in Bottle 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Vessel, "Test Bottle 1 - 1L Glass Bottle (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Plate, Filter, "Test Plate SPE 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Model[Container, Plate, Filter, "Test Plate SPE Model (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Instrument, LiquidHandler, "Test Gilson LiquidHandler 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Vessel, "Test Gilson Waste Container (resolveSolidPhaseExtractionMethod)" <> $SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existObjects = DatabaseMemberQ[allObjects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[allObjects, existObjects], Force -> True, Verbose -> False]];

			{
				protocol,
				modelCartridge,
				modelCartridge6mL,
				objectCartridge1,
				objectCartridge2,
				objectCartridge3,
				room, bench,
				sample1, sample2, sample3, sample4, sample5, sample6, sample7,
				plate1, plate2, tube1, tube2, tube3,
				sample8, bottle1,
				plateFilter, plateFilterModel,
				instrumentGilson,
				gilsonWasteContainer
			} = CreateID[Download[allObjects, Type]];

			(* upload room and bench *)
			Upload[<|
				Object -> room,
				DeveloperObject -> True,
				Model -> Link[Model[Container, Room, "Chemistry Lab"], Objects],
				Name -> "Test Room (resolveSolidPhaseExtractionMethod)" <> $SessionUUID
			|>];
			bench = UploadSample[
				Model[Container, Bench, "The Bench of Testing"],
				{"Bench Slot 4", room},
				Name -> "Test Bench (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
				FastTrack -> True
			];

			(* protocol *)
			protocol = Upload[<|
				Object -> protocol,
				DeveloperObject -> True,
				Name -> "Test Protocol (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
				Replace[Instrument] -> Link[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]]
			|>];

			(*instruments*)
			instrumentGilson = Upload[<|
				Object -> instrumentGilson,
				DeveloperObject -> True,
				Model -> Link[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"], Objects],
				Container -> Link[bench, Contents, 2],
				Name -> "Test Gilson LiquidHandler 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
				WasteContainer -> Link[gilsonWasteContainer]
			|>];

			(* upload cartridge model *)
			modelCartridge = Upload[<|
				Object -> modelCartridge,
				DeveloperObject -> True,
				Name -> "Test Model ExtractionCartridge (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
				MaxVolume -> 3 Milliliter,
				FunctionalGroup -> C18,
				SeparationMode -> ReversePhase,
				DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
			|>];

			(* upload cartridge model *)
			modelCartridge6mL = Upload[<|
				Object -> modelCartridge6mL,
				DeveloperObject -> True,
				Name -> "Test Model ExtractionCartridge 6 mL (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
				MaxVolume -> 6 Milliliter,
				FunctionalGroup -> C18,
				SeparationMode -> ReversePhase,
				DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
			|>];

			(* upload cartridge model plate *)
			plateFilterModel = Upload[<|
				Object -> plateFilterModel,
				DeveloperObject -> True,
				Name -> "Test Plate SPE Model (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
				MaxVolume -> 1.1 Milliliter,
				FunctionalGroup -> C18,
				SeparationMode -> ReversePhase,
				DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
				NumberOfWells -> 96
			|>];

			{
				plate1,
				plate2,
				tube1,
				tube2,
				tube3,
				objectCartridge1,
				objectCartridge2,
				objectCartridge3,
				bottle1,
				plateFilter,
				gilsonWasteContainer
			} = UploadSample[
				{
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
					Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
					Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
					Model[Container, Vessel, "1L Glass Bottle"],
					Model[Container, Plate, Filter, "Sep-Pak C18 96-well Plate, 40 mg, Plate extraction cartridge"],
					Model[Container, Vessel, "id:aXRlGnZmOOB9"]

				},
				{
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench}
				},
				Name -> {
					"Test Plate 1 - 96 well dwp (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Plate 2 - 96 well dwp (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Tube 1 - 50 mL (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Tube 2 - 50 mL (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Tube 3 - 50 mL (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Object ExtractionCartridge 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Object ExtractionCartridge 2 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Object ExtractionCartridge 3 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Bottle 1 - 1L Glass Bottle (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Plate SPE 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Gilson Waste Container (resolveSolidPhaseExtractionMethod)" <> $SessionUUID
				},
				FastTrack -> True
			];


			{
				sample4, sample5, sample1, sample2, sample3, sample6, sample7, sample8
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", tube1},
					{"A1", tube2},
					{"A1", plate1},
					{"A2", plate1},
					{"A1", plate2},
					{"A3", plate1},
					{"A4", plate1},
					{"A1", bottle1}
				},
				Name -> {
					"Test Sample 4 - 2 mL in Tube 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Sample 5 - 8 mL in Tube 2 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Sample 1 - 2 mL in Plate 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Sample 2 - 2 mL in Plate 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Sample 3 - 2 mL in Plate 2 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Sample 6 - 2 mL in Plate 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Sample 7 - 2 mL in Plate 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID,
					"Test Sample 8 - 500 mL in Bottle 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID
				},
				InitialAmount -> {
					2 Milliliter,
					8 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					500 Milliliter
				},
				FastTrack -> True
			];

			Upload[<|Object -> #, DeveloperObject -> True|>& /@ {
				bench,
				plate1,
				plate2,
				tube1,
				tube2,
				tube3,
				objectCartridge1,
				objectCartridge2,
				objectCartridge3,
				bottle1,
				plateFilter,
				gilsonWasteContainer,
				sample4, sample5, sample1, sample2, sample3, sample6, sample7, sample8
			}]
		]
	),
	SymbolTearDown :> (
		Module[
			{
				allObjects, existObjects
			},
			On[Warning::SamplesOutOfStock];
			allObjects = {
				Object[Protocol, SolidPhaseExtraction, "Test Protocol (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 2 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 3 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Room, "Test Room (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Bench, "Test Bench (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 3 - 2 mL in Plate 2 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 4 - 2 mL in Tube 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 5 - 8 mL in Tube 2 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 7 - 2 mL in Plate 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 1 - 96 well dwp (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 2 - 96 well dwp (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 1 - 50 mL (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 2 - 50 mL (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 3 - 50 mL (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Sample, "Test Sample 8 - 500 mL in Bottle 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Vessel, "Test Bottle 1 - 1L Glass Bottle (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Object[Container, Plate, Filter, "Test Plate SPE 1 (resolveSolidPhaseExtractionMethod)" <> $SessionUUID],
				Model[Container, Plate, Filter, "Test Plate SPE Model (resolveSolidPhaseExtractionMethod)" <> $SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existObjects = DatabaseMemberQ[allObjects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[allObjects, existObjects], Force -> True, Verbose -> False]]
		]
	)
];


(* ::Subsection::Closed:: *)
(*SolidPhaseExtraction*)
DefineTests[SolidPhaseExtraction,
	{
		Example[{Basic, "Return options for each sample used in solid phase extraction:"},
			Experiment[{
				SolidPhaseExtraction[
					Sample -> Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (SolidPhaseExtraction)"<>$SessionUUID]
				]
			}],
			ObjectP[Object[Protocol]]
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		(* want the manual tests to still pass even if we're not yet supporting in lab *)
		$SPERoboticOnly = False
	},
	SetUp :> (ClearMemoization[]),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[DeleteDuplicates[Flatten[{
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (SolidPhaseExtraction)" <> $SessionUUID],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge 6 mL (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 2 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 3 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Room, "Test Room (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Bench, "Test Bench (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 3 - 2 mL in Plate 2 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 4 - 2 mL in Tube 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 5 - 8 mL in Tube 2 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 7 - 2 mL in Plate 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 1 - 96 well dwp (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 2 - 96 well dwp (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 1 - 50 mL (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 2 - 50 mL (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 3 - 50 mL (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 8 - 500 mL in Bottle 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Bottle 1 - 1L Glass Bottle (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Plate, Filter, "Test Plate SPE 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Model[Container, Plate, Filter, "Test Plate SPE Model (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Instrument, LiquidHandler, "Test Gilson LiquidHandler 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Gilson Waste Container (SolidPhaseExtraction)" <> $SessionUUID]
			}]], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjs, Force -> True, Verbose -> False]];

		];
		Module[
			{
				modelCartridge,
				modelCartridge6mL,
				objectCartridge1,
				objectCartridge2,
				objectCartridge3,
				room, bench,
				sample1, sample2, sample3, sample4, sample5, sample6, sample7,
				plate1, plate2, tube1, tube2, tube3,
				sample8, bottle1,
				plateFilter, plateFilterModel,
				instrumentGilson, gilsonWasteContainer
			},

			{
				(*1*)modelCartridge,
				(*2*)modelCartridge6mL,
				(*3*)room,
				(*4*)plateFilterModel,
				(*5*)instrumentGilson
			} = CreateID[{
				(*1*)Model[Container, ExtractionCartridge],
				(*2*)Model[Container, ExtractionCartridge],
				(*3*)Object[Container, Room],
				(*4*)Model[Container, Plate, Filter],
				(*5*)Object[Instrument, LiquidHandler]
			}];

			(* upload room and bench *)
			Upload[<|
				Object -> room,
				DeveloperObject -> True,
				Model -> Link[Model[Container, Room, "Chemistry Lab"], Objects],
				Name -> "Test Room (SolidPhaseExtraction)" <> $SessionUUID
			|>];
			bench = UploadSample[
				Model[Container, Bench, "The Bench of Testing"],
				{"Bench Slot 4", room},
				Name -> "Test Bench (SolidPhaseExtraction)" <> $SessionUUID,
				FastTrack -> True
			];

			(* upload the model cartridge we're using to make containers *)
			Upload[<|
				Object -> modelCartridge,
				DeveloperObject -> True,
				Name -> "Test Model ExtractionCartridge (SolidPhaseExtraction)" <> $SessionUUID,
				MaxVolume -> 3 Milliliter,
				FunctionalGroup -> C18,
				SeparationMode -> ReversePhase,
				DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
			|>];

			{
				plate1,
				plate2,
				tube1,
				tube2,
				tube3,
				objectCartridge1,
				objectCartridge2,
				objectCartridge3,
				bottle1,
				plateFilter,
				gilsonWasteContainer
			} = UploadSample[
				{
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					modelCartridge,
					modelCartridge,
					modelCartridge,
					Model[Container, Vessel, "1L Glass Bottle"],
					Model[Container, Plate, Filter, "Sep-Pak C18 96-well Plate, 40 mg, Plate extraction cartridge"],
					Model[Container, Vessel, "10L Polypropylene Carboy"]

				},
				{
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench}
				},
				Name -> {
					"Test Plate 1 - 96 well dwp (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Plate 2 - 96 well dwp (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Tube 1 - 50 mL (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Tube 2 - 50 mL (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Tube 3 - 50 mL (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Object ExtractionCartridge 1 (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Object ExtractionCartridge 2 (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Object ExtractionCartridge 3 (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Bottle 1 - 1L Glass Bottle (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Plate SPE 1 (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Gilson Waste Container (SolidPhaseExtraction)" <> $SessionUUID
				}
			];


			(*instruments, cartridge models, cartridge model plates*)
			Upload[{
				<|
					Object -> instrumentGilson,
					DeveloperObject -> True,
					Model -> Link[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"], Objects],
					Container -> Link[bench, Contents, 2],
					Name -> "Test Gilson LiquidHandler 1 (SolidPhaseExtraction)" <> $SessionUUID,
					WasteContainer -> Link[gilsonWasteContainer]
				|>,
				<|
					Object -> modelCartridge6mL,
					DeveloperObject -> True,
					Name -> "Test Model ExtractionCartridge 6 mL (SolidPhaseExtraction)" <> $SessionUUID,
					MaxVolume -> 6 Milliliter,
					FunctionalGroup -> C18,
					SeparationMode -> ReversePhase,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>,
				<|
					Object -> plateFilterModel,
					DeveloperObject -> True,
					Name -> "Test Plate SPE Model (SolidPhaseExtraction)" <> $SessionUUID,
					MaxVolume -> 1.1 Milliliter,
					FunctionalGroup -> C18,
					SeparationMode -> ReversePhase,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					NumberOfWells -> 96
				|>
			}];

			{
				sample4, sample5, sample1, sample2, sample3, sample6, sample7, sample8
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", tube1},
					{"A1", tube2},
					{"A1", plate1},
					{"A2", plate1},
					{"A1", plate2},
					{"A3", plate1},
					{"A4", plate1},
					{"A1", bottle1}
				},
				Name -> {
					"Test Sample 4 - 2 mL in Tube 1 (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 5 - 8 mL in Tube 2 (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 1 - 2 mL in Plate 1 (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 2 - 2 mL in Plate 1 (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 3 - 2 mL in Plate 2 (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 6 - 2 mL in Plate 1 (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 7 - 2 mL in Plate 1 (SolidPhaseExtraction)" <> $SessionUUID,
					"Test Sample 8 - 500 mL in Bottle 1 (SolidPhaseExtraction)" <> $SessionUUID
				},
				InitialAmount -> {
					2 Milliliter,
					8 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					2 Milliliter,
					500 Milliliter
				}
			];

			Upload[<|Object -> #, DeveloperObject -> True|>& /@ {
				bench,
				plate1, plate2, tube1, tube2, tube3, objectCartridge1, objectCartridge2, objectCartridge3, bottle1, plateFilter, gilsonWasteContainer,
				sample4, sample5, sample1, sample2, sample3, sample6, sample7, sample8
			}]
		]
	),
	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[DeleteDuplicates[Flatten[{
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge (SolidPhaseExtraction)" <> $SessionUUID],
				Model[Container, ExtractionCartridge, "Test Model ExtractionCartridge 6 mL (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 2 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, ExtractionCartridge, "Test Object ExtractionCartridge 3 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Room, "Test Room (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Bench, "Test Bench (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 1 - 2 mL in Plate 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 2 - 2 mL in Plate 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 3 - 2 mL in Plate 2 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 4 - 2 mL in Tube 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 5 - 8 mL in Tube 2 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 6 - 2 mL in Plate 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 7 - 2 mL in Plate 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 1 - 96 well dwp (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Plate, "Test Plate 2 - 96 well dwp (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 1 - 50 mL (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 2 - 50 mL (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Tube 3 - 50 mL (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Sample, "Test Sample 8 - 500 mL in Bottle 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Bottle 1 - 1L Glass Bottle (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Plate, Filter, "Test Plate SPE 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Model[Container, Plate, Filter, "Test Plate SPE Model (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Instrument, LiquidHandler, "Test Gilson LiquidHandler 1 (SolidPhaseExtraction)" <> $SessionUUID],
				Object[Container, Vessel, "Test Gilson Waste Container (SolidPhaseExtraction)" <> $SessionUUID]
			}]], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjs, Force -> True, Verbose -> False]];

		]
	}
];





