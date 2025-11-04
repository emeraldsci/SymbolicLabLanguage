(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentCoulterCount*)


DefineTests[ExperimentCoulterCount,
	{
		(* SampleLabel and SampleContainerLabel *)
		Example[{Options, "SampleLabel", "SampleLabel and SampleContainerLabel is automatically set:"},
			Lookup[
				ExperimentCoulterCount[
					{
						Object[Sample, "Test sample 6 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID]
					},
					Output -> Options],
				{SampleLabel, SampleContainerLabel}
			],
			{{__String}, {__String}}
		],
		(* ApertureDiameter *)
		Example[{Options, "ApertureDiameter", "If ApertureTube is set, ApertureDiameter is automatically set to the ApertureDiameter field of supplied ApertureTube model:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 6 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureTube -> Model[Part, ApertureTube, "id:bq9LA095YBNd"],
					Output -> Options],
				ApertureDiameter
			],
			100. * Micrometer,
			EquivalenceFunction -> Equal
		],
		Example[{Options, "ApertureDiameter", "If ApertureTube is set, ApertureDiameter is automatically set to the ApertureDiameter field of supplied ApertureTube object:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 6 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureTube -> Object[Part, ApertureTube, "Test ApertureTube object 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Output -> Options
				],
				ApertureDiameter
			],
			10. * Micrometer,
			EquivalenceFunction -> Equal
		],
		Example[{Options, "ApertureDiameter", "If input sample has a defined ParticleSize, set ApertureDiameter to a value that can accommodate the ParticleSize:"},
			GreaterEqual[
				Lookup[ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID], Output -> Options], ApertureDiameter],
				Mean[Download[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID], ParticleSize]]
			],
			True
		],
		Example[{Options, "ApertureDiameter", "If input sample's model has a defined NominalParticleSize, set ApertureDiameter to a value that can accommodate the NominalParticleSize:"},
			GreaterEqual[
				Lookup[ExperimentCoulterCount[Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID], Output -> Options], ApertureDiameter],
				Mean[Download[Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID], Model[NominalParticleSize]]]
			],
			True
		],
		Example[{Options, "ApertureDiameter", "If input sample's composition has a defined Diameter, set ApertureDiameter to a value that can accommodate the Diameter:"},
			GreaterEqual[
				Lookup[ExperimentCoulterCount[Object[Sample, "Test sample 3 for ExperimentCoulterCount unit test "<>$SessionUUID], Output -> Options], ApertureDiameter],
				Max[Cases[Quiet[Download[Object[Sample, "Test sample 3 for ExperimentCoulterCount unit test "<>$SessionUUID], Composition[[All, 2]][Diameter]]], DistanceP]]
			],
			True
		],
		Example[{Options, "ApertureDiameter", "ApertureDiameter is automatically set to 100 Micrometer if any input sample contains Mammalian CellType:"},
			Lookup[ExperimentCoulterCount[Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID], Output -> Options], ApertureDiameter],
			100. * Micrometer,
			EquivalenceFunction -> Equal
		],
		Example[{Options, "ApertureDiameter", "ApertureDiameter is automatically set to 30 Micrometer if any input sample contains Microbial CellType:"},
			Lookup[ExperimentCoulterCount[Object[Sample, "Test sample 5 for ExperimentCoulterCount unit test "<>$SessionUUID], Output -> Options], ApertureDiameter],
			30. * Micrometer,
			EquivalenceFunction -> Equal
		],
		Example[{Options, "ApertureDiameter", "ApertureDiameter is automatically set to the largest ApertureDiameter in lab if no Diameter, ParticleSize, or CellType information if available from any input samples:"},
			Lookup[ExperimentCoulterCount[Object[Sample, "Test sample 6 for ExperimentCoulterCount unit test "<>$SessionUUID], Output -> Options], ApertureDiameter],
			Max[List @@ CoulterCounterApertureDiameterP],
			EquivalenceFunction -> Equal
		],
		(* ApertureTube *)
		Example[{Options, "ApertureTube", "If ApertureDiameter is set, ApertureTube is automatically set to a model with ApertureDiameter field equal to the  supplied ApertureDiameter:"},
			Download[
				Lookup[
					ExperimentCoulterCount[Object[Sample, "Test sample 6 for ExperimentCoulterCount unit test "<>$SessionUUID],
						ApertureDiameter -> 100. * Micrometer,
						Output -> Options],
					ApertureTube
				],
				ApertureDiameter
			],
			100. * Micrometer,
			EquivalenceFunction -> Equal
		],
		(* ElectrolyteSolution *)
		Example[{Options, "ElectrolyteSolution", "If ApertureDiameter is larger than 30 Micrometer and Aqueous is the dominant phase, ElectrolyteSolution is automatically set to Model[Sample,\"Beckman Coulter ISOTON II Electrolyte Diluent\"]:"},
			Lookup[
				ExperimentCoulterCount[
					{
						(* Aqueous *)Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
						(* Aqueous *)Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
						(* Aqueous *)Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID],
						(* Aqueous *)Object[Sample, "Test sample 6 for ExperimentCoulterCount unit test "<>$SessionUUID]
					},
					ApertureDiameter -> 100. Micrometer,
					Output -> Options
				],
				ElectrolyteSolution
			],
			Model[Sample, "id:n0k9mGkbr8j6"] (* Model[Sample,"Beckman Coulter ISOTON II Electrolyte Diluent"] *)
		],
		Example[{Messages, "SolubleSamples", "Throw a warning if any input sample are soluble in the calculated ElectrolyteSolution:"},
			Lookup[
				ExperimentCoulterCount[
					{
						(* Aqueous *)Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
						(* Aqueous *)Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
						(* Aqueous *)Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID],
						(* Organic *)Object[Sample, "Test sample 5 for ExperimentCoulterCount unit test "<>$SessionUUID],
						(* Aqueous *)Object[Sample, "Test sample 6 for ExperimentCoulterCount unit test "<>$SessionUUID]
					},
					ApertureDiameter -> 100. Micrometer,
					Output -> Options
				],
				ElectrolyteSolution
			],
			Model[Sample, "id:n0k9mGkbr8j6"], (* Model[Sample,"Beckman Coulter ISOTON II Electrolyte Diluent"] *)
			SetUp :> {
				$CreatedObjects = {};
				ClearMemoization[];
				On[Warning::SolubleSamples]
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects];
				Off[Warning::SolubleSamples]
			},
			Messages :> {Warning::SolubleSamples}
		],
		(* SystemSuitabilityCheck *)
		Example[{Options, "SystemSuitabilityCheck", "SystemSuitabilityCheck is automatically set to True if any suitability options are not set to Null or Automatic:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityTolerance -> 3 * Percent,
					Output -> Options
				],
				SystemSuitabilityCheck
			],
			True
		],
		Example[{Options, "SystemSuitabilityCheck", "SystemSuitabilityCheck is automatically set to False if all suitability options are set to Null or Automatic:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityTolerance -> Null,
					SuitabilitySizeStandard -> {Null, Null},
					Output -> Options
				],
				SystemSuitabilityCheck
			],
			False
		],
		(* SystemSuitabilityTolerance *)
		Example[{Options, "SystemSuitabilityTolerance", "SystemSuitabilityTolerance is automatically set to 4 Percent if SystemSuitabilityCheck is set to True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					Output -> Options
				],
				SystemSuitabilityTolerance
			],
			4 * Percent,
			EquivalenceFunction -> Equal
		],
		(* SuitabilitySizeStandard option *)
		Example[{Options, "SuitabilitySizeStandard", "SuitabilitySizeStandard is automatically set with NominalParticleSizeDiameter smaller than or equal to ApertureDiameter (ApertureDiameter = 100 Micron case) if SystemSuitabilityCheck is True:"},
			{sizeStandard, apertureDiameter} = Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. * Micrometer,
					SystemSuitabilityCheck -> True,
					SuitabilityRunTime -> 10 Second,
					Output -> Options
				],
				{SuitabilitySizeStandard, ApertureDiameter}
			];
			Mean[Download[sizeStandard, NominalParticleSize]] <= apertureDiameter,
			True,
			Variables :> {sizeStandard, apertureDiameter}
		],
		Example[{Options, "SuitabilitySizeStandard", "SuitabilitySizeStandard is automatically set to comply with SuitabilityParticleSize if SystemSuitabilityCheck is True:"},
			Mean /@ Download[
				Lookup[
					ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
						ApertureDiameter -> 100. * Micrometer,
						SystemSuitabilityCheck -> True,
						SuitabilityParticleSize -> {10.2 Micrometer, Automatic},
						SuitabilityRunTime -> 10 Second,
						Output -> Options
					],
					SuitabilitySizeStandard
				],
				NominalParticleSize
			],
			{10.2 Micrometer, 20 Micrometer},
			EquivalenceFunction -> Equal
		],
		(* AbortOnSystemSuitabilityCheck *)
		Example[{Options, "AbortOnSystemSuitabilityCheck", "AbortOnSystemSuitabilityCheck is automatically set to False if SystemSuitabilityCheck is True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					Output -> Options
				],
				AbortOnSystemSuitabilityCheck
			],
			False
		],
		(* SuitabilityParticleSize option *)
		Example[{Options, "SuitabilityParticleSize", "SuitabilityParticleSize is automatically set to the NominalParticleSize of the Model of SuitabilitySizeStandard if SystemSuitabilityCheck is False:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. * Micrometer,
					SuitabilitySizeStandard -> {Model[Sample, "id:AEqRl9q8GNr1"], Model[Sample, "id:Y0lXejlLdv1v"]},
					Output -> Options
				],
				SuitabilityParticleSize
			],
			{5. * Micrometer, 50. * Micrometer},
			EquivalenceFunction -> Equal
		],
		(* SuitabilityTargetConcentration *)
		Example[{Options, "SuitabilityTargetConcentration", "SuitabilityTargetConcentration is automatically set to the value calculated from SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume if SystemSuitabilityCheck is True and particle concentration of the sample is known:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. * Micrometer,
					SystemSuitabilityCheck -> True,
					SuitabilitySizeStandard -> Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SuitabilitySampleAmount -> 20. * Milliliter,
					SuitabilityElectrolyteSampleDilutionVolume -> 5 * Milliliter,
					Output -> Options
				],
				SuitabilityTargetConcentration
			],
			Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID][Composition][[1, 1]] * 20 / 25,
			EquivalenceFunction -> Equal
		],
		(* SuitabilitySampleAmount *)
		Example[{Options, "SuitabilitySampleAmount", "SuitabilitySampleAmount is automatically set to 25 Milliliter if SystemSuitabilityCheck is True and sample concentration is less than or equal to SuitabilityTargetConcentration:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. * Micrometer,
					SystemSuitabilityCheck -> True,
					SuitabilityTargetConcentration -> 5 / 60221407600000000000 Mole / Milliliter,
					SuitabilitySizeStandard -> Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SuitabilityRunTime -> 10 Second,
					Output -> Options
				],
				SuitabilitySampleAmount
			],
			25 Milliliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SuitabilitySampleAmount", "SuitabilitySampleAmount is automatically set to the value calculated from sample concentration, SuitabilityElectrolyteSampleDilutionVolume, and SuitabilityTargetConcentration if SystemSuitabilityCheck is True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. * Micrometer,
					SystemSuitabilityCheck -> True,
					SuitabilityTargetConcentration -> 1 / 6022140760000000000000 Mole / Milliliter,
					SuitabilityElectrolyteSampleDilutionVolume -> 75 Milliliter,
					SuitabilitySizeStandard -> Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Output -> Options
				],
				SuitabilitySampleAmount
			],
			SafeRound[75 Milliliter / (Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID][Composition][[1, 1]] / (1 / 6022140760000000000000 Mole / Milliliter) - 1), 10^-1 Microliter],
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SuitabilitySampleAmount", "SuitabilitySampleAmount is automatically set to 1/999 of SuitabilityElectrolyteSampleDilutionVolume if SystemSuitabilityCheck is True and SuitabilityTargetConcentration is Null:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 3 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. * Micrometer,
					SystemSuitabilityCheck -> True,
					SuitabilityTargetConcentration -> Null,
					SuitabilityElectrolyteSampleDilutionVolume -> 75 Milliliter,
					SuitabilitySizeStandard -> Object[Sample, "Test sample 12 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Output -> Options
				],
				SuitabilitySampleAmount
			],
			SafeRound[75 Milliliter / 999, 10^-1 Microliter],
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SuitabilitySampleAmount", "SuitabilitySampleAmount is automatically set to 100 Microliter if SystemSuitabilityCheck is True and SuitabilityElectrolyteSampleDilutionVolume is not set:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. * Micrometer,
					SystemSuitabilityCheck -> True,
					SuitabilitySizeStandard -> Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Output -> Options
				],
				SuitabilitySampleAmount
			],
			100 Microliter,
			EquivalenceFunction -> Equal
		],
		(* SuitabilityElectrolyteSampleDilutionVolume *)
		Example[{Options, "SuitabilityElectrolyteSampleDilutionVolume", "SuitabilityElectrolyteSampleDilutionVolume is automatically set to the value calculated from sample concentration, SuitabilitySampleAmount, and SuitabilityTargetConcentration if SystemSuitabilityCheck is True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. * Micrometer,
					SystemSuitabilityCheck -> True,
					SuitabilityTargetConcentration -> 1 / 6022140760000000000000 Mole / Milliliter,
					SuitabilitySampleAmount -> 1 Milliliter,
					SuitabilitySizeStandard -> Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Output -> Options
				],
				SuitabilityElectrolyteSampleDilutionVolume
			],
			SafeRound[1 Milliliter * (Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID][Composition][[1, 1]] / (1 / 6022140760000000000000 Mole / Milliliter) - 1), 10^-1 * Microliter],
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SuitabilityElectrolyteSampleDilutionVolume", "SuitabilityElectrolyteSampleDilutionVolume is automatically set to 999 times of the SuitabilitySampleAmount if SystemSuitabilityCheck is True and SuitabilityTargetMeasurement is Null:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 3 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. * Micrometer,
					SystemSuitabilityCheck -> True,
					SuitabilityTargetConcentration -> Null,
					SuitabilitySampleAmount -> 0.2 Milliliter,
					SuitabilitySizeStandard -> Object[Sample, "Test sample 12 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Output -> Options
				],
				SuitabilityElectrolyteSampleDilutionVolume
			],
			SafeRound[0.2 Milliliter * 999, 10^-1 * Microliter],
			EquivalenceFunction -> Equal
		],
		(* SuitabilityMeasurementContainer *)
		Example[{Options, "SuitabilityMeasurementContainer", "SuitabilityMeasurementContainer is automatically resolved to accommodate the total volume of SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume if SystemSuitabilityCheck is True:"},
			Download[Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. * Micrometer,
					SystemSuitabilityCheck -> True,
					SuitabilitySizeStandard -> {Model[Sample, "id:Y0lXejlLdv1v"], Model[Sample, "id:AEqRl9q8GNr1"], Model[Sample, "id:AEqRl9q8GNr1"]},
					SuitabilitySampleAmount -> {1 * Milliliter, 1 * Milliliter, 20 * Milliliter},
					SuitabilityElectrolyteSampleDilutionVolume -> {80 * Milliliter, 150 * Milliliter, 300 * Milliliter},
					Output -> Options
				],
				SuitabilityMeasurementContainer
			], MaxVolume],
			{100 Milliliter, 200 Milliliter, 400 Milliliter},
			EquivalenceFunction -> Equal
		],
		(* SuitabilityDynamicDilute *)
		Example[{Options, "SuitabilityDynamicDilute", "SuitabilityDynamicDilute is automatically set to Null if all dynamic dilutions are set to Null:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityConstantDynamicDilutionFactor -> Null,
					SuitabilityCumulativeDynamicDilutionFactor -> {Null},
					SuitabilityMaxNumberOfDynamicDilutions -> Null,
					Output -> Options
				],
				SuitabilityDynamicDilute
			],
			False
		],
		(* SuitabilityConstantDynamicDilutionFactor *)
		Example[{Options, "SuitabilityConstantDynamicDilutionFactor", "SuitabilityConstantDynamicDilutionFactor is automatically set to the constant adjacent dilution factor from SuitabilityCumulativeDynamicDilutionFactor:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityCumulativeDynamicDilutionFactor -> {5, 25},
					Output -> Options
				],
				{SuitabilityConstantDynamicDilutionFactor, SuitabilityMaxNumberOfDynamicDilutions}
			],
			{5, 2},
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SuitabilityConstantDynamicDilutionFactor", "SuitabilityConstantDynamicDilutionFactor is automatically set to Null if the adjacent dilution factor from SuitabilityCumulativeDynamicDilutionFactor is not constant:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityCumulativeDynamicDilutionFactor -> {5, 25, 30, 50},
					Output -> Options
				],
				{SuitabilityConstantDynamicDilutionFactor, SuitabilityMaxNumberOfDynamicDilutions}
			],
			{Null, 4}
		],
		Example[{Options, "SuitabilityConstantDynamicDilutionFactor", "SuitabilityConstantDynamicDilutionFactor is automatically set to 10 if SuitabilityDynamicDilute is True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityDynamicDilute -> True,
					Output -> Options
				],
				{SuitabilityConstantDynamicDilutionFactor, SuitabilityCumulativeDynamicDilutionFactor, SuitabilityMaxNumberOfDynamicDilutions}
			],
			{2, {2, 4, 8}, 3},
			EquivalenceFunction -> Equal
		],
		(* SuitabilityCumulativeDynamicDilutionFactor *)
		Example[{Options, "SuitabilityCumulativeDynamicDilutionFactor", "SuitabilityCumulativeDynamicDilutionFactor is automatically set to the expanded list from SuitabilityConstantDynamicDilutionFactor and SuitabilityMaxNumberOfDynamicDilutions if DynamicDilute is True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityDynamicDilute -> True,
					SuitabilityConstantDynamicDilutionFactor -> 2,
					SuitabilityMaxNumberOfDynamicDilutions -> 5,
					Output -> Options
				],
				SuitabilityCumulativeDynamicDilutionFactor
			],
			{2, 4, 8, 16, 32},
			EquivalenceFunction -> Equal
		],
		(* SuitabilityMixRate *)
		Example[{Options, "SuitabilityMixRate", "SuitabilityMixRate is automatically set to 20 RPM if SystemSuitabilityCheck is True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					Output -> Options
				],
				SuitabilityMixRate
			],
			20 * RPM,
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SuitabilityMixRate", "SuitabilityMixRate is automatically set to Null if both SuitabilityMixTime and SuitabilityMixDirection are set to Null:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityMixTime -> Null,
					SuitabilityMixDirection -> Null,
					Output -> Options
				],
				SuitabilityMixRate
			],
			Null
		],
		(* SuitabilityMixTime *)
		Example[{Options, "SuitabilityMixTime", "SuitabilityMixTime is automatically set to 2 Minute if SystemSuitabilityCheck is True and SuitabilityMixRate is not set to 0*RPM or Null:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityMixRate -> 2 * RPM,
					Output -> Options
				],
				SuitabilityMixTime
			],
			2 * Minute,
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SuitabilityMixTime", "SuitabilityMixTime is automatically set to Null if SystemSuitabilityCheck is True and SuitabilityMixRate is 0*RPM:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityMixRate -> 0 * RPM,
					Output -> Options
				],
				SuitabilityMixTime
			],
			Null
		],
		(* SuitabilityMixDirection *)
		Example[{Options, "SuitabilityMixDirection", "SuitabilityMixDirection is automatically set to Clockwise if SystemSuitabilityCheck is True and SuitabilityMixRate is not set to 0*RPM or Null:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityMixRate -> 2 * RPM,
					Output -> Options
				],
				SuitabilityMixDirection
			],
			Clockwise
		],
		Example[{Options, "SuitabilityMixDirection", "SuitabilityMixDirection is automatically set to Null if SystemSuitabilityCheck is True and SuitabilityMixRate is 0*RPM:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityMixRate -> 0 * RPM,
					Output -> Options
				],
				SuitabilityMixDirection
			],
			Null
		],
		(* NumberOfSuitabilityReadings *)
		Example[{Options, "NumberOfSuitabilityReadings", "NumberOfSuitabilityReadings is automatically set to 1 if SystemSuitabilityCheck is True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					Output -> Options
				],
				NumberOfSuitabilityReadings
			],
			1
		],
		Example[{Options, "SuitabilityApertureCurrent", "SuitabilityApertureCurrent is automatically set to 1600uA if SystemSuitabilityCheck is True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					Output -> Options
				],
				SuitabilityApertureCurrent
			],
			1600 * Microampere,
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SuitabilityGain", "SuitabilityGain is automatically set to 2 if SystemSuitabilityCheck is True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					Output -> Options
				],
				SuitabilityGain
			],
			2,
			EquivalenceFunction -> Equal
		],
		(* SuitabilityFlowRate *)
		Example[{Options, "SuitabilityFlowRate", "SuitabilityFlowRate is automatically set to a value based on ElectrolyteSolution if ApertureDiameter is is less than or equal to 560 Micrometer if SystemSuitabilityCheck is True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. Micrometer,
					SystemSuitabilityCheck -> True,
					Output -> Options
				],
				SuitabilityFlowRate
			],
			UnitsP[Microliter / Second]
		],
		(* MinSuitabilityParticleSize *)
		Example[{Options, "MinSuitabilityParticleSize", "MinSuitabilityParticleSize is automatically set to 2% of the ApertureDiameter if SystemSuitabilityCheck is True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. Micrometer,
					SystemSuitabilityCheck -> True,
					Output -> Options
				],
				MinSuitabilityParticleSize
			],
			2.1 * Micrometer,
			EquivalenceFunction -> Equal
		],
		(* SuitabilityEquilibrationTime *)
		Example[{Options, "SuitabilityEquilibrationTime", "SuitabilityEquilibrationTime is automatically set to 3 Second if SystemSuitabilityCheck is True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					Output -> Options
				],
				SuitabilityEquilibrationTime
			],
			3 Second,
			EquivalenceFunction -> Equal
		],
		(* SuitabilityStopCondition *)
		Example[{Options, "SuitabilityStopCondition", "SuitabilityStopCondition is automatically set to Time if SystemSuitabilityCheck is True and SuitabilityRunTime is set:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityRunTime -> 60 * Second,
					Output -> Options
				],
				SuitabilityStopCondition
			],
			Time
		],
		Example[{Options, "SuitabilityStopCondition", "SuitabilityStopCondition is automatically set to Volume if SystemSuitabilityCheck is True and SuitabilityRunVolume is set:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityRunVolume -> 1.5 * Milliliter,
					Output -> Options
				],
				SuitabilityStopCondition
			],
			Volume
		],
		Example[{Options, "SuitabilityStopCondition", "SuitabilityStopCondition is automatically set to ModalCount if SystemSuitabilityCheck is True and SuitabilityModalCount is set:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityModalCount -> 3000,
					Output -> Options
				],
				SuitabilityStopCondition
			],
			ModalCount
		],
		Example[{Options, "SuitabilityStopCondition", "SuitabilityStopCondition is automatically set to TotalCount if SystemSuitabilityCheck is True and SuitabilityTotalCount is set:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityTotalCount -> 10000,
					Output -> Options
				],
				SuitabilityStopCondition
			],
			TotalCount
		],
		Example[{Options, "SuitabilityStopCondition", "SuitabilityStopCondition is automatically set to Volume if SystemSuitabilityCheck is True and none of the sub options is set:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					Output -> Options
				],
				SuitabilityStopCondition
			],
			Volume
		],
		(* SuitabilityRunTime *)
		Example[{Options, "SuitabilityRunTime", "SuitabilityRunTime is automatically set to 2 Minute if SystemSuitabilityCheck is True and SuitabilityStopCondition is Time:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityStopCondition -> Time,
					SuitabilitySampleAmount -> 3 Milliliter,
					SuitabilityElectrolyteSampleDilutionVolume -> 20 Milliliter,
					Output -> Options
				],
				SuitabilityRunTime
			],
			2 Minute,
			EquivalenceFunction -> Equal
		],
		(* SuitabilityRunVolume *)
		Example[{Options, "SuitabilityRunVolume", "SuitabilityRunVolume is automatically set to 1000 Microliter if SystemSuitabilityCheck is True and SuitabilityStopCondition is Volume:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityStopCondition -> Volume,
					Output -> Options
				],
				SuitabilityRunVolume
			],
			1000 Microliter,
			EquivalenceFunction -> Equal
		],
		(* SuitabilityModalCount *)
		Example[{Options, "SuitabilityModalCount", "SuitabilityModalCount is automatically set to 20000 if SystemSuitabilityCheck is True and SuitabilityStopCondition is ModalCount:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityStopCondition -> ModalCount,
					Output -> Options
				],
				SuitabilityModalCount
			],
			20000,
			EquivalenceFunction -> Equal
		],
		(* SuitabilityTotalCount *)
		Example[{Options, "SuitabilityTotalCount", "SuitabilityTotalCount is automatically set to 100000 if SystemSuitabilityCheck is True and SuitabilityStopCondition is TotalCount:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True,
					SuitabilityStopCondition -> TotalCount,
					Output -> Options
				],
				SuitabilityTotalCount
			],
			100000,
			EquivalenceFunction -> Equal
		],
		(* Dilute *)
		Example[{Options, "Dilute", "Dilute is automatically set to True if any of the dilution options is set:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					DilutionType -> Serial,
					Output -> Options
				],
				Dilute
			],
			True
		],
		Example[{Options, "Dilute", "Dilute is automatically set to True if the provided SampleAmount, and ElectrolyteSampleDilutionVolume makes a solution that is more concentrated than the user specified TargetMeasurementConcentration:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID],
					TargetMeasurementConcentration -> 10^6 EmeraldCell / Milliliter,
					SampleAmount -> 20 Milliliter,
					ElectrolyteSampleDilutionVolume -> 5 Milliliter,
					Output -> Options
				],
				Dilute
			],
			True
		],
		Example[{Options, "Dilute", "When the measurement concentration calculated from SampleAmount, and ElectrolyteSampleDilutionVolume and particle concentration of the sample is greater than the specified TargetMeasurementConcentration, Dilute is automatically set to True to dilute sample to meet the specified TargetMeasurementConcentration:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
					TargetMeasurementConcentration -> 1 / 180664222800000 Molar,
					SampleAmount -> 50. * Milliliter,
					ElectrolyteSampleDilutionVolume -> 25 * Milliliter,
					Output -> Options
				],
				{Dilute, CumulativeDilutionFactor}
			],
			{True, 2},
			EquivalenceFunction -> Equal
		],
		Example[{Options, "CumulativeDilutionFactor", "CumulativeDilutionFactor is automatically expanded to be a list if the value calculated from SampleAmount, and ElectrolyteSampleDilutionVolume and particle concentration of the sample is greater than the specified TargetMeasurementConcentration and Dilute is True:"},
			{Last[#], Length[#]}& /@ Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> True,
					DilutionType -> Serial,
					NumberOfDilutions -> 3,
					TargetMeasurementConcentration -> 1 / 180664222800000 Molar,
					SampleAmount -> 50. * Milliliter,
					ElectrolyteSampleDilutionVolume -> 25 * Milliliter,
					Output -> Options
				],
				CumulativeDilutionFactor
			],
			{{2, 3}},
			EquivalenceFunction -> Equal
		],
		Example[{Options, "CumulativeDilutionFactor", "When the measurement concentration calculated from SampleAmount, and ElectrolyteSampleDilutionVolume and particle concentration of the sample is greater than the specified TargetMeasurementConcentration, if user-specified dilution options provides a different concentration Dilute, an error will be thrown:"},
			Lookup[
				ExperimentCoulterCount[
					{
						Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID]
					},
					CumulativeDilutionFactor -> {3, Automatic, Automatic, Automatic},
					TransferVolume -> {Automatic, 5 Milliliter, 5 Milliliter, 5 Milliliter},
					TotalDilutionVolume -> {Automatic, Automatic, 15 Milliliter, Automatic},
					DiluentVolume -> {Automatic, Automatic, Automatic, 10 Milliliter},
					TargetMeasurementConcentration -> 1 / 180664222800000 Molar,
					SampleAmount -> 16. * Milliliter,
					ElectrolyteSampleDilutionVolume -> 8 * Milliliter,
					Output -> Options
				],
				{Dilute, CumulativeDilutionFactor}
			],
			{True, {{3}, {2}, {3}, {3}}},
			EquivalenceFunction -> Equal,
			Messages :> {Error::ConflictingSampleLoadingOptions, Error::InvalidOption}
		],
		Example[{Options, "Dilute", "Dilute is automatically set to False if the provided SampleAmount, and ElectrolyteSampleDilutionVolume makes a solution that is less or equally concentrated than the user specified TargetMeasurementConcentration:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID],
					TargetMeasurementConcentration -> 5 * 10^6 EmeraldCell / Milliliter,
					SampleAmount -> 45 Milliliter,
					ElectrolyteSampleDilutionVolume -> 45 Milliliter,
					Output -> Options
				],
				Dilute
			],
			False
		],
		(* DilutionType *)
		Example[{Options, "DilutionType", "DilutionType is automatically set to Linear if Dilute is set to True and we are only doing one dilution:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> True,
					NumberOfDilutions -> 1,
					Output -> Options
				],
				DilutionType
			],
			Linear
		],
		Example[{Options, "DilutionType", "DilutionType is automatically set to Serial if Dilute is set to True and we are doing more than one dilution indicated by NumberOfDilutions:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> True,
					NumberOfDilutions -> 2,
					Output -> Options
				],
				DilutionType
			],
			Serial
		],
		Example[{Options, "DilutionType", "DilutionType is automatically set to Serial if Dilute is set to True and we are doing more than one dilution indicated by other dilution options:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> True,
					TransferVolume -> {{10 Milliliter, 10 Milliliter}},
					Output -> Options
				],
				DilutionType
			],
			Serial
		],
		(* TargetMeasurementConcentration *)
		Example[{Options, "TargetMeasurementConcentration", "TargetMeasurementConcentration is automatically set to Null if particle concentration of the sample is unknown:"},
			Lookup[
				ExperimentCoulterCount[
					{
						Object[Sample, "Test sample 12 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 12 for ExperimentCoulterCount unit test "<>$SessionUUID]
					},
					Dilute -> {False, True},
					TransferVolume -> {Automatic, 5 Milliliter},
					DiluentVolume -> {Automatic, 15 Milliliter},
					SampleAmount -> 50. * Milliliter,
					ElectrolyteSampleDilutionVolume -> 25. * Milliliter,
					Output -> Options
				],
				TargetMeasurementConcentration
			],
			Null
		],
		Example[{Options, "TargetMeasurementConcentration", "TargetMeasurementConcentration is automatically set to the value calculated from SampleAmount and ElectrolyteSampleDilutionVolume if particle concentration of the sample is known:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> False,
					SampleAmount -> 50. * Milliliter,
					ElectrolyteSampleDilutionVolume -> 25 * Milliliter,
					Output -> Options
				],
				TargetMeasurementConcentration
			],
			Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID][Composition][[1, 1]] * 2 / 3,
			EquivalenceFunction -> Equal
		],
		Example[{Options, "TargetMeasurementConcentration", "TargetMeasurementConcentration is automatically set to the value calculated from SampleAmount and ElectrolyteSampleDilutionVolume if particle concentration of the sample is convertible to CellConcentration:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 11 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> False,
					SampleAmount -> 50. * Milliliter,
					ElectrolyteSampleDilutionVolume -> 25 * Milliliter,
					Output -> Options
				],
				TargetMeasurementConcentration
			],
			ConvertCellConcentration[
				Object[Sample, "Test sample 11 for ExperimentCoulterCount unit test "<>$SessionUUID][Composition][[1, 1]],
				EmeraldCell / Milliliter,
				Object[Sample, "Test sample 11 for ExperimentCoulterCount unit test "<>$SessionUUID][Composition][[1, 2]]
			] * 2 / 3,
			EquivalenceFunction -> Equal
		],
		Example[{Options, "TargetMeasurementConcentration", "TargetMeasurementConcentration is automatically set to the value calculated from SampleAmount and ElectrolytePercentage if particle concentration of the sample is known:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> False,
					SampleAmount -> 60. * Milliliter,
					ElectrolytePercentage -> 1 / 3,
					Output -> Options
				],
				TargetMeasurementConcentration
			],
			Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID][Composition][[1, 1]] * 2 / 3,
			EquivalenceFunction -> Equal
		],
		Example[{Options, "TargetMeasurementConcentration", "TargetMeasurementConcentration is automatically set to the value calculated from ElectrolyteSampleDilutionVolume and ElectrolytePercentage if particle concentration of the sample is known:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> False,
					ElectrolyteSampleDilutionVolume -> 25 * Milliliter,
					ElectrolytePercentage -> 1 / 3,
					Output -> Options
				],
				TargetMeasurementConcentration
			],
			Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID][Composition][[1, 1]] * 2 / 3,
			EquivalenceFunction -> Equal
		],
		Example[{Options, "TargetMeasurementConcentration", "TargetMeasurementConcentration is automatically set to the value calculated from SampleAmount, ElectrolyteSampleDilutionVolume, and CumulativeDilutionFactor if particle concentration of the sample is known:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> True,
					DilutionType -> Linear,
					CumulativeDilutionFactor -> 5,
					SampleAmount -> 50. * Milliliter,
					ElectrolyteSampleDilutionVolume -> 25 * Milliliter,
					Output -> Options
				],
				TargetMeasurementConcentration
			],
			Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID][Composition][[1, 1]] * 2 / 3 / 5,
			EquivalenceFunction -> Equal
		],
		(* SampleAmount *)
		Example[{Options, "SampleAmount", "{SampleAmount, ElectrolytePercentage, ElectrolyteSampleDilutionVolume} is automatically set to {25 Milliliter, 0 Percent, 0 Milliliter} if sample concentration is less than or equal to the supplied TargetMeasurementConcentration:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID],
					TargetMeasurementConcentration -> 1 / 60221407600000000000 Mole / Milliliter,
					Output -> Options
				],
				{SampleAmount, ElectrolytePercentage, ElectrolyteSampleDilutionVolume}
			],
			{25 Milliliter, 0 Percent, 0 Milliliter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SampleAmount", "{SampleAmount, ElectrolytePercentage, ElectrolyteSampleDilutionVolume} is automatically set to {25 Milliliter, 0 Percent, 0 Milliliter} if sample does not have concentration information but has electrolyte solution as the solvent:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 12 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ElectrolyteSolution -> Model[Sample, "id:n0k9mGkbr8j6"],
					Output -> Options
				],
				{TargetMeasurementConcentration, SampleAmount, ElectrolytePercentage, ElectrolyteSampleDilutionVolume}
			],
			{Null, 25 Milliliter, 0 Percent, 0 Milliliter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SampleAmount", "SampleAmount is automatically set to the value calculated from sample concentration, ElectrolyteSampleDilutionVolume, and TargetMeasurementConcentration:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> False,
					TargetMeasurementConcentration -> 1 / 6022140760000000000000 Mole / Milliliter,
					ElectrolyteSampleDilutionVolume -> 80 Milliliter,
					Output -> Options
				],
				SampleAmount
			],
			SafeRound[80 Milliliter / (Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID][Composition][[1, 1]] / (1 / 6022140760000000000000 Mole / Milliliter) - 1), 10^-1 Microliter],
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SampleAmount", "SampleAmount is automatically set to the value calculated from sample concentration, ElectrolyteSampleDilutionVolume, CumulativeDilutionFactor, and TargetMeasurementConcentration:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> True,
					DilutionType -> Linear,
					CumulativeDilutionFactor -> 5,
					TargetMeasurementConcentration -> 1 / 451660557000000000 Mole / Milliliter,
					ElectrolyteSampleDilutionVolume -> 25 * Milliliter,
					Output -> Options
				],
				SampleAmount
			],
			50 Milliliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SampleAmount", "SampleAmount is automatically set to the value calculated from ElectrolyteSampleDilutionVolume and ElectrolytePercentage:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 12 for ExperimentCoulterCount unit test "<>$SessionUUID],
					TargetMeasurementConcentration -> Null,
					ElectrolyteSampleDilutionVolume -> 80 Milliliter,
					ElectrolytePercentage -> 98 Percent,
					Output -> Options
				],
				SampleAmount
			],
			SafeRound[80 Milliliter * (1 / (98 Percent) - 1), 10^-1 Microliter],
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SampleAmount", "{SampleAmount, ElectrolytePercentage, ElectrolyteSampleDilutionVolume} is automatically set to {flat 25 Milliliter, 0 Percent, 0 Milliliter} if we are diluting with the specified ElectrolyteSolution and have already reached TargetMeasurementConcentration:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ElectrolyteSolution -> Model[Sample, StockSolution, "id:3em6Zvm8p8RM"],
					Dilute -> True,
					DilutionType -> Linear,
					Diluent -> Model[Sample, StockSolution, "id:3em6Zvm8p8RM"],
					TransferVolume -> 1 Milliliter,
					TargetMeasurementConcentration -> Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID][Composition][[1, 1]] * 1 / 32,
					DiluentVolume -> 31 Milliliter,
					Output -> Options
				],
				{SampleAmount, ElectrolytePercentage, ElectrolyteSampleDilutionVolume}
			],
			{25 Milliliter, 0 Percent, 0 Milliliter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SampleAmount", "{SampleAmount, ElectrolytePercentage, ElectrolyteSampleDilutionVolume} is automatically set to {the final dilution volume, 0 Percent, 0 Milliliter} if we are diluting with the specified ElectrolyteSolution with TargetMeasurementConcentration set to Null:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 12 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ElectrolyteSolution -> Model[Sample, StockSolution, "id:3em6Zvm8NzlM"],
					Dilute -> True,
					DilutionType -> Linear,
					Diluent -> Model[Sample, StockSolution, "id:3em6Zvm8NzlM"],
					TransferVolume -> 1 Milliliter,
					DiluentVolume -> 24 Milliliter,
					Output -> Options
				],
				{SampleAmount, ElectrolytePercentage, ElectrolyteSampleDilutionVolume}
			],
			{25 Milliliter, 0 Percent, 0 Milliliter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, "SampleAmount", "SampleAmount is automatically set to 1 Milliliter for liquid sample if ElectrolyteSampleDilutionVolume is not set:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> False,
					Output -> Options
				],
				SampleAmount
			],
			100 Microliter,
			EquivalenceFunction -> Equal
		],
		(*
		Commented out the tests for solid samples since they are not currently supported
		Example[{Options,"SampleAmount","SampleAmount is automatically set to 1 Gram for solid sample if ElectrolyteSampleDilutionVolume is not set:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample,"Test sample 10 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute->False,
					Output->Options
				],
				SampleAmount
			],
			1 Gram,
			EquivalenceFunction->Equal
		],
		*)
		(* ElectrolytePercentage *)
		Example[{Options, "ElectrolytePercentage", "ElectrolytePercentage is automatically set to the value calculated from ElectrolyteSampleDilutionVolume and SampleAmount:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> False,
					ElectrolyteSampleDilutionVolume -> 76 Milliliter,
					SampleAmount -> 4 Milliliter,
					Output -> Options
				],
				ElectrolytePercentage
			],
			95 Percent,
			EquivalenceFunction -> Equal
		],
		(*
		Commented out the tests for solid samples since they are not currently supported
		Example[{Options,"ElectrolytePercentage","ElectrolytePercentage is automatically set to the value calculated from ElectrolyteSampleDilutionVolume, SampleAmount, and Sample density:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample,"Test sample 10 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute->False,
					ElectrolyteSampleDilutionVolume->24 Milliliter,
					SampleAmount->1 Gram,
					Output->Options
				],
				ElectrolytePercentage
			],
			24 Milliliter/(1 Gram/Download[Object[Sample,"Test sample 10 for ExperimentCoulterCount unit test "<>$SessionUUID],Density]+24 Milliliter),
			EquivalenceFunction->Equal
		],
		*)
		Example[{Options, "ElectrolytePercentage", "ElectrolytePercentage is automatically set to the value calculated from TargetMeasurementConcentration, and SampleConcentration:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> False,
					TargetMeasurementConcentration -> 0.3 / 60221407600000000000 Mole / Milliliter,
					RunTime -> 10 Second,
					Output -> Options
				],
				ElectrolytePercentage
			],
			1 - (0.3 / 60221407600000000000 Mole / Milliliter) / Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID][Composition][[1, 1]],
			EquivalenceFunction -> Equal
		],
		(* ElectrolyteSampleDilutionVolume *)
		Example[{Options, "ElectrolyteSampleDilutionVolume", "ElectrolyteSampleDilutionVolume is automatically set to the value calculated from SampleAmount, and ElectrolytePercentage:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Dilute -> False,
					SampleAmount -> 40 Milliliter,
					ElectrolytePercentage -> 50 Percent,
					Output -> Options
				],
				ElectrolyteSampleDilutionVolume
			],
			40 Milliliter,
			EquivalenceFunction -> Equal
		],
		(* MeasurementContainer *)
		Example[{Options, "MeasurementContainer", "MeasurementContainer is automatically resolved to accommodate the total volume of SampleAmount and ElectrolyteSampleDilutionVolume:"},
			Download[Lookup[
				ExperimentCoulterCount[
					{
						Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 6 for ExperimentCoulterCount unit test "<>$SessionUUID]
					},
					SampleAmount -> {1 * Milliliter, 1 * Milliliter, 20 * Milliliter},
					ElectrolyteSampleDilutionVolume -> {80 * Milliliter, 150 * Milliliter, 300 * Milliliter},
					Output -> Options
				],
				MeasurementContainer
			], MaxVolume],
			{100 Milliliter, 200 Milliliter, 400 Milliliter},
			EquivalenceFunction -> Equal
		],
		(* DynamicDilute *)
		Example[{Options, "DynamicDilute", "DynamicDilute is automatically set to False if all dynamic dilutions are set to Null:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ConstantDynamicDilutionFactor -> Null,
					CumulativeDynamicDilutionFactor -> {Null},
					MaxNumberOfDynamicDilutions -> Null,
					Output -> Options
				],
				DynamicDilute
			],
			False
		],
		Example[{Options, "DynamicDilute", "DynamicDilute is automatically set to False if we can figure out TargetMeasurementConcentration:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID], Output -> Options],
				{TargetMeasurementConcentration, DynamicDilute}
			],
			{CellConcentrationP | CFUConcentrationP | OD600P | ConcentrationP, False}
		],
		Example[{Options, "DynamicDilute", "DynamicDilute is automatically set to False if DilutionStrategy is set to Series:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					DilutionStrategy -> Series,
					NumberOfDilutions -> 3,
					Output -> Options
				],
				DynamicDilute
			],
			False
		],
		(* ConstantDynamicDilutionFactor *)
		Example[{Options, "ConstantDynamicDilutionFactor", "ConstantDynamicDilutionFactor is automatically set to the constant adjacent dilution factor from CumulativeDynamicDilutionFactor:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					CumulativeDynamicDilutionFactor -> {5, 25},
					Output -> Options
				],
				{ConstantDynamicDilutionFactor, MaxNumberOfDynamicDilutions}
			],
			{5, 2},
			EquivalenceFunction -> Equal
		],
		Example[{Options, "ConstantDynamicDilutionFactor", "ConstantDynamicDilutionFactor is automatically set to Null if the adjacent dilution factor from CumulativeDynamicDilutionFactor is not constant:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					CumulativeDynamicDilutionFactor -> {5, 25, 30, 50},
					Output -> Options
				],
				{ConstantDynamicDilutionFactor, MaxNumberOfDynamicDilutions}
			],
			{Null, 4}
		],
		Example[{Options, "ConstantDynamicDilutionFactor", "ConstantDynamicDilutionFactor is automatically set to 10 if DynamicDilute is True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					DynamicDilute -> True,
					Output -> Options
				],
				{ConstantDynamicDilutionFactor, CumulativeDynamicDilutionFactor, MaxNumberOfDynamicDilutions}
			],
			{2, {2, 4, 8}, 3},
			EquivalenceFunction -> Equal
		],
		(* CumulativeDynamicDilutionFactor *)
		Example[{Options, "CumulativeDynamicDilutionFactor", "CumulativeDynamicDilutionFactor is automatically set to the expanded list from ConstantDynamicDilutionFactor and MaxNumberOfDynamicDilutions if DynamicDilute is True:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					DynamicDilute -> True,
					ConstantDynamicDilutionFactor -> 2,
					MaxNumberOfDynamicDilutions -> 5,
					Output -> Options
				],
				CumulativeDynamicDilutionFactor
			],
			{2, 4, 8, 16, 32},
			EquivalenceFunction -> Equal
		],
		(* MixRate *)
		Example[{Options, "MixRate", "MixRate is automatically set to Null if both MixTime and MixDirection are set to Null:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					MixDirection -> Null,
					MixTime -> Null,
					Output -> Options
				],
				MixRate
			],
			Null
		],
		(* MixTime *)
		Example[{Options, "MixTime", "MixTime is automatically set to 2 Minute if MixRate is not set to 0*RPM or Null:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					MixRate -> 2 * RPM,
					Output -> Options
				],
				MixTime
			],
			2 * Minute,
			EquivalenceFunction -> Equal
		],
		Example[{Options, "MixTime", "MixTime is automatically set to Null if MixRate is set to 0*RPM:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					MixRate -> 0 * RPM,
					Output -> Options
				],
				MixTime
			],
			Null
		],
		(* MixDirection *)
		Example[{Options, "MixDirection", "MixDirection is automatically set to Clockwise if MixRate is not set to 0*RPM or Null:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					MixRate -> 2 * RPM,
					Output -> Options
				],
				MixDirection
			],
			Clockwise
		],
		Example[{Options, "MixDirection", "MixDirection is automatically set to Null if MixRate is set to 0*RPM:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					MixRate -> 0 * RPM,
					Output -> Options
				],
				MixDirection
			],
			Null
		],
		(* FlowRate *)
		Example[{Options, "FlowRate", "FlowRate is automatically set to a value based on ElectrolyteSolution if ApertureDiameter is is less than or equal to 560 Micrometer:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. Micrometer,
					Output -> Options
				],
				FlowRate
			],
			UnitsP[Microliter / Second]
		],
		(* MinParticleSize *)
		Example[{Options, "MinParticleSize", "MinParticleSize is automatically set to 2.1% of the ApertureDiameter:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. Micrometer,
					Output -> Options
				],
				MinParticleSize
			],
			2.1 * Micrometer,
			EquivalenceFunction -> Equal
		],
		(* StopCondition *)
		Example[{Options, "StopCondition", "StopCondition is automatically set to Time if RunTime is set:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					RunTime -> 60 * Second,
					Output -> Options
				],
				StopCondition
			],
			Time
		],
		Example[{Options, "StopCondition", "StopCondition is automatically set to Volume if RunVolume is set:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					RunVolume -> 1.5 * Milliliter,
					Output -> Options
				],
				StopCondition
			],
			Volume
		],
		Example[{Options, "StopCondition", "StopCondition is automatically set to ModalCount if ModalCount is set:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ModalCount -> 3000,
					Output -> Options
				],
				StopCondition
			],
			ModalCount
		],
		Example[{Options, "StopCondition", "StopCondition is automatically set to TotalCount if TotalCount is set:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					TotalCount -> 10000,
					Output -> Options
				],
				StopCondition
			],
			TotalCount
		],
		Example[{Options, "StopCondition", "StopCondition is automatically set to Volume if none is set:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Output -> Options
				],
				StopCondition
			],
			Volume
		],
		(* RunTime *)
		Example[{Options, "RunTime", "RunTime is automatically set to 2 Minute if StopCondition is Time:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					StopCondition -> Time,
					Output -> Options
				],
				RunTime
			],
			2 Minute,
			EquivalenceFunction -> Equal
		],
		(* RunVolume *)
		Example[{Options, "RunVolume", "RunVolume is automatically set to 500 Microliter if StopCondition is Volume:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					StopCondition -> Volume,
					Output -> Options
				],
				RunVolume
			],
			1000 Microliter,
			EquivalenceFunction -> Equal
		],
		(* ModalCount *)
		Example[{Options, "ModalCount", "ModalCount is automatically set to 20000 if StopCondition is ModalCount:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					StopCondition -> ModalCount,
					Output -> Options
				],
				ModalCount
			],
			20000,
			EquivalenceFunction -> Equal
		],
		(* TotalCount *)
		Example[{Options, "TotalCount", "TotalCount is automatically set to 100000 if StopCondition is TotalCount:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					StopCondition -> TotalCount,
					Output -> Options
				],
				TotalCount
			],
			100000,
			EquivalenceFunction -> Equal
		],
		(* FlushFlowRate *)
		Example[{Options, "FlushFlowRate", "FlushFlowRate is automatically set to a value based on ElectrolyteSolution if ApertureDiameter is is less than or equal to 560 Micrometer:"},
			Lookup[
				ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					ApertureDiameter -> 100. Micrometer,
					Output -> Options
				],
				FlushFlowRate
			],
			UnitsP[Microliter / Second]
		],
		(* ElectrolyteSolutionVolume *)
		Example[{Options, "ElectrolyteSolutionVolume", "ElectrolyteSolutionVolume is automatically set to a value based on number of total flushes (determined by all samples, number of flushes needed etc):"},
			Lookup[
				ExperimentCoulterCount[{Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID], Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID]},
					SuitabilitySizeStandard -> {Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID], Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID]},
					ApertureDiameter -> 100. * Micrometer,
					NumberOfSuitabilityReadings -> {3, 1},
					NumberOfSuitabilityReplicates -> 2,
					NumberOfReadings -> {1, 4},
					NumberOfReplicates -> 3,
					FlushFlowRate -> 500 Microliter / Second,
					FlushTime -> 12 Second,
					RunTime -> 10 Second,
					Output -> Options
				],
				ElectrolyteSolutionVolume
			],
			500 * Microliter / Second * 12 * Second * (2 * 4 + 5 * 4 + 4 * 3 + 2 * 3 + 1) + 2 * Liter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentCoulterCount[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Vessel, "100 mL Glass Bottle"],
				PreparedModelAmount -> 100 Milliliter,
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
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
				{ObjectP[Model[Container, Vessel, "100 mL Glass Bottle"]]..},
				{EqualP[100 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Ensure that PreparedSamples is populated properly if doing model input:"},
			prot = ExperimentCoulterCount[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Vessel, "100 mL Glass Bottle"],
				PreparedModelAmount -> 100 Milliliter
			];
			Download[prot, PreparedSamples],
			{{_String, _Symbol, __}..},
			Variables :> {prot},
			TimeConstraint -> 600
		],
		Example[{Options, "PreparatoryUnitOperations", "Use PreparatoryUnitOperations to specify sample prep procedures before sample is subjected to ExperimentCoulterCount:"},
			ExperimentCoulterCount["test target container",
				PreparatoryUnitOperations -> {
					LabelSample[
						Sample -> Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID], Label -> "test sample"],
					LabelContainer[
						Container -> Model[Container, Vessel, "100 mL Glass Bottle"],
						Label -> "test target container"
					],
					Transfer[
						Source -> "test sample",
						Destination -> "test target container",
						Amount -> 75 Milliliter,
						SterileTechnique -> False
					]
				}
			],
			ObjectP[Object[Protocol, CoulterCount]]
		],
		Example[{Options, "QuantifyConcentration", "QuantifyConcentration is automatically set to True if the sample contains countable cell-like analytes:"},
			Lookup[ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
				Output -> Options
			], QuantifyConcentration],
			True
		],
		Example[{Options, "QuantifyConcentration", "QuantifyConcentration is automatically set to False if the sample contains more than 1 component of countable analytes:"},
			Lookup[ExperimentCoulterCount[Object[Sample, "Test sample 13 for ExperimentCoulterCount unit test "<>$SessionUUID],
				Output -> Options
			], QuantifyConcentration],
			False
		],
		Example[{Messages, "DiscardedSamples", "If the provided sample is discarded, an error will be thrown:"},
			ExperimentCoulterCount[Object[Sample, "Test discarded sample for ExperimentCoulterCount unit test "<>$SessionUUID], Output -> {Result, Options}],
			{$Failed, {__Rule}},
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "GasSamples", "If the provided sample is gas, an error will be thrown:"},
			ExperimentCoulterCount[Object[Sample, "Test gas sample for ExperimentCoulterCount unit test "<>$SessionUUID], Output -> {Result, Options}],
			{$Failed, {__Rule}},
			Messages :> {
				Error::NonLiquidSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "ApertureTubeDiameterMismatch", "Throw an error if ApertureDiameter does not match the ApertureDiameter field value of ApertureTube:"},
			ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
				ApertureDiameter -> 100. * Micrometer,
				ApertureTube -> Object[Part, ApertureTube, "Test ApertureTube object 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::ApertureTubeDiameterMismatch, Error::InvalidOption}
		],
		Example[{Messages, "ParticleSizeOutOfRange", "Throw an error if any input samples contain particles with sizes that are out of the range of 2-80% of the ApertureDiameter:"},
			ExperimentCoulterCount[{Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID], Object[Sample, "Test sample 7 for ExperimentCoulterCount unit test "<>$SessionUUID]},
				ApertureDiameter -> 100. * Micrometer,
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::ParticleSizeOutOfRange, Error::InvalidInput, Error::InvalidOption}
		],
		Example[{Messages, "ConflictingSuitabilityCheckOptions", "Throw an error if suitability options are conflicting with SystemSuitabilityCheck master switch:"},
			ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
				SystemSuitabilityCheck -> True,
				SystemSuitabilityTolerance -> Null,
				SuitabilitySizeStandard -> {Automatic, Null, Automatic},
				SuitabilityParticleSize -> {10.2 * Micrometer, Automatic, Automatic},
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::ConflictingSuitabilityCheckOptions, Error::InvalidOption}
		],
		Example[{Messages, "SystemSuitabilityToleranceTooHigh", "Throw a warning if SystemSuitabilityTolerance is set greater than 10 Percent:"},
			ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
				SystemSuitabilityCheck -> True,
				SystemSuitabilityTolerance -> 12 Percent,
				Upload -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, CoulterCount]], {__Rule}},
			Messages :> {Warning::SystemSuitabilityToleranceTooHigh}
		],
		Example[{Messages, "ParticleSizeOutOfRange", "Throw an error if any SuitabilitySizeStandard samples contain particles with sizes that are out of the range of 2-80% of the ApertureDiameter:"},
			ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
				SuitabilitySizeStandard -> Object[Sample, "Test sample 7 for ExperimentCoulterCount unit test "<>$SessionUUID],
				ApertureDiameter -> 100. * Micrometer,
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::ParticleSizeOutOfRange, Error::InvalidOption}
		],
		Example[{Messages, "SuitabilitySizeStandardMismatch", "Throw an error if any SuitabilitySizeStandard samples' particle size does not match SuitabilityParticleSize:"},
			ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
				SuitabilitySizeStandard -> Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
				ApertureDiameter -> 100. * Micrometer,
				SuitabilityParticleSize -> 10. * Micrometer,
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::SuitabilitySizeStandardMismatch, Error::InvalidOption}
		],
		Example[{Messages, "TargetConcentrationNotUseful", "Throw a warning if any input sample has no concentration information but TargetMeasurementConcentration is specified:"},
			ExperimentCoulterCount[
				{
					Object[Sample, "Test sample 12 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID]
				},
				TargetMeasurementConcentration -> {1.5 Micromolar, Automatic},
				SuitabilitySizeStandard -> Object[Sample, "Test sample 12 for ExperimentCoulterCount unit test "<>$SessionUUID],
				SuitabilityTargetConcentration -> 1.5 Micromolar,
				Upload -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, CoulterCount]], {__Rule}},
			Messages :> {Warning::TargetConcentrationNotUseful}
		],
		Example[{Messages, "ConflictingSampleLoadingOptions", "Throw an error if any input sample have conflicting Sample Loading options:"},
			ExperimentCoulterCount[
				{
					Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID]
				},
				Dilute -> {False, False, True},
				CumulativeDilutionFactor -> {Automatic, Automatic, 3},
				TargetMeasurementConcentration -> {Automatic, 10000000 / AvogadroConstant / Milliliter, 10000000 / AvogadroConstant / Milliliter},
				SampleAmount -> 50. * Milliliter,
				ElectrolyteSampleDilutionVolume -> 25 * Milliliter,
				ElectrolytePercentage -> {20 Percent, Automatic, Automatic},
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::ConflictingSampleLoadingOptions, Error::InvalidOption}
		],
		Example[{Messages, "ConflictingSampleLoadingOptions", "Throw an error if any SuitabilitySizeStandard sample have conflicting Sample Loading options:"},
			ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
				ApertureDiameter -> 100. * Micrometer,
				SystemSuitabilityCheck -> True,
				SuitabilitySizeStandard -> Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
				SuitabilitySampleAmount -> 50. * Milliliter,
				SuitabilityElectrolyteSampleDilutionVolume -> 25 * Milliliter,
				SuitabilityTargetConcentration -> 10000000 / AvogadroConstant / Milliliter,
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::ConflictingSampleLoadingOptions, Error::InvalidOption}
		],
		Example[{Messages, "MeasurementContainerTooSmall", "Throw an error if MeasurementContainer or SuitabilityMeasurementContainer is too small to hold measurement samples:"},
			ExperimentCoulterCount[
				{
					Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Object[Sample, "Test sample 6 for ExperimentCoulterCount unit test "<>$SessionUUID]
				},
				SampleAmount -> {1 * Milliliter, 1 * Milliliter, 20 * Milliliter},
				ElectrolyteSampleDilutionVolume -> {50 * Milliliter, 150 * Milliliter, 300 * Milliliter},
				MeasurementContainer -> {
					Model[Container, Vessel, "id:L8kPEjkb7vPW"], (* Model[Container,Vessel,Beckman Coulter Accuvette ST Sampling Vials with Caps, 25 mL] *)
					Model[Container, Vessel, "id:qdkmxzkKnbma"], (* Model[Container,Vessel,Beckman Coulter Multisizer 4e Smart Technology (ST) Footed Beaker 100 mL] *)
					Model[Container, Vessel, "id:AEqRl9q8P7Rl"](* Model[Container,Vessel,Beckman Coulter Multisizer 4e Smart Technology (ST) Footed Beaker 400 mL] *)
				},
				SuitabilitySizeStandard -> Model[Sample, "id:AEqRl9q8GNr1"],
				SuitabilitySampleAmount -> 1 * Milliliter,
				SuitabilityElectrolyteSampleDilutionVolume -> 50 * Milliliter,
				SuitabilityMeasurementContainer -> Model[Container, Vessel, "id:L8kPEjkb7vPW"], (* Model[Container,Vessel,Beckman Coulter Accuvette ST Sampling Vials with Caps, 25 mL] *)
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::MeasurementContainerTooSmall, Error::InvalidOption}
		],
		Example[{Messages, "NotEnoughMeasurementSample", "Throw an error if total volume adding sample amount and electrolyte sample dilution volume of any samples in input or system suitability check is not enough for measurement:"},
			ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
				ApertureDiameter -> 100. * Micrometer,
				FlowRate -> 500 * Microliter / Second,
				RunTime -> 1 Minute,
				SuitabilitySizeStandard -> Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
				SuitabilityFlowRate -> 500 * Microliter / Second,
				SuitabilityRunTime -> 1 Minute,
				SuitabilitySampleAmount -> 0.1 Milliliter,
				SuitabilityElectrolyteSampleDilutionVolume -> 50 Milliliter,
				SampleAmount -> 0.1 Milliliter,
				ElectrolytePercentage -> 99.8 Percent,
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::NotEnoughMeasurementSample, Error::InvalidOption}
		],
		Example[{Messages, "ConflictingMixOptions", "Throw an error if MixDirection and MixTime conflict with MixRate option:"},
			ExperimentCoulterCount[
				{
					Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID]
				},
				MixRate -> {2 * RPM, 0 * RPM, Null},
				MixTime -> {Null, 1 * Minute, 1 * Minute},
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::ConflictingMixOptions, Error::InvalidOption}
		],
		Example[{Messages, "MinParticleSizeTooLarge", "Throw an error if MinParticleSize or SuitabilityMinParticleSize is greater than 80% of the ApertureDiameter:"},
			ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
				ApertureDiameter -> 100. * Micrometer,
				MinParticleSize -> 90 * Micrometer,
				MinSuitabilityParticleSize -> 90 * Micrometer,
				SuitabilityRunTime -> 10 Second,
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::MinParticleSizeTooLarge, Error::InvalidOption}
		],
		Example[{Messages, "ConflictingStopConditionOptions", "Throw an error if any options in {RunTime/SuitabilityRunTime,RunVolume/SuitabilityRunVolume,ModalCount/SuitabilityModalCount,TotalCount/SuitabilityTotalCount} conflict with StopCondition/SuitabilityStopCondition:"},
			ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
				StopCondition -> ModalCount,
				RunTime -> 60 * Second,
				RunVolume -> 1 Milliliter,
				SuitabilityRunTime -> 10 Second,
				SuitabilityStopCondition -> ModalCount,
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::ConflictingStopConditionOptions, Error::InvalidOption}
		],
		Example[{Messages, "NotEnoughElectrolyteSolution", "Throw an error if ElectrolyteSolutionVolume is not enough to fulfill all the flushes during measurements:"},
			ExperimentCoulterCount[{Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID], Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID]},
				SuitabilitySizeStandard -> {Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID], Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID]},
				ApertureDiameter -> 100. * Micrometer,
				NumberOfSuitabilityReadings -> {3, 1},
				NumberOfSuitabilityReplicates -> 2,
				NumberOfReadings -> {1, 4},
				NumberOfReplicates -> 3,
				FlushFlowRate -> 500 Microliter / Second,
				FlushTime -> 12 Second,
				RunTime -> 10 Second,
				ElectrolyteSolutionVolume -> 235 Milliliter,
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::NotEnoughElectrolyteSolution, Error::InvalidOption}
		],
		Example[{Messages, "InvalidNumberOfDynamicDilutions", "Throw an error if length of any SuitabilityCumulativeDynamicDilutionFactor or CumulativeDynamicDilutionFactor does not equal to SuitabilityMaxNumberOfDynamicDilutions or MaxNumberOfDynamicDilutions:"},
			ExperimentCoulterCount[{Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID]},
				SystemSuitabilityCheck -> True,
				CumulativeDynamicDilutionFactor -> {2, 4, 10},
				MaxNumberOfDynamicDilutions -> 2,
				SuitabilityCumulativeDynamicDilutionFactor -> {2, 4, 10},
				SuitabilityMaxNumberOfDynamicDilutions -> 2,
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::InvalidNumberOfDynamicDilutions, Error::InvalidOption}
		],
		Example[{Messages, "ConflictingDynamicDilutionOptions", "Throw an error if any input or size standard samples have conflicting dynamic dilution options:"},
			ExperimentCoulterCount[{Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID]},
				SystemSuitabilityCheck -> True,
				DynamicDilute -> False,
				MaxNumberOfDynamicDilutions -> 2,
				SuitabilityDynamicDilute -> True,
				CumulativeDynamicDilutionFactor -> {Null},
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::ConflictingDynamicDilutionOptions, Error::InvalidOption}
		],
		Example[{Messages, "ConstantCumulativeDilutionFactorMismatch", "Throw an error if ConstantDynamicDilutionFactor or SuitabilityConstantDynamicDilutionFactor conflicts with CumulativeDynamicDilutionFactor or SuitabilityCumulativeDynamicDilutionFactor:"},
			ExperimentCoulterCount[{Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID]},
				SystemSuitabilityCheck -> True,
				ConstantDynamicDilutionFactor -> 3,
				CumulativeDynamicDilutionFactor -> {2, 4, 9},
				SuitabilityConstantDynamicDilutionFactor -> Null,
				SuitabilityCumulativeDynamicDilutionFactor -> {2, 4, 8},
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::ConstantCumulativeDilutionFactorMismatch, Error::InvalidOption}
		],
		Example[{Messages, "ConflictingDilutionOptions", "Throw an error if length of any sample have dilutions conflicting with Dilute master switches:"},
			ExperimentCoulterCount[{Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID], Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID]},
				Dilute -> {True, False},
				DilutionStrategy -> {Automatic, Null},
				NumberOfDilutions -> {Automatic, 3},
				TransferVolume -> {{Null}, {Automatic}},
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::ConflictingDilutionOptions, Error::InvalidOption}
		],
		Example[{Messages, "DynamicDiluteDilutionStrategyIncompatible", "Throw an error if DynamicDilute is set to True and DilutionStrategy is set to Series:"},
			ExperimentCoulterCount[{Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID], Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID]},
				Dilute -> {True, True},
				NumberOfDilutions -> 3,
				DilutionStrategy -> {Series, Automatic},
				DynamicDilute -> {True, Automatic},
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::DynamicDiluteDilutionStrategyIncompatible, Error::InvalidOption}
		],
		(*
		Example[{Messages, "SolutionNotFiltered", "Throw a warning if we are using an electrolyte solution, diluent, concentrated buffer, concentrated buffer diluent that has not been filtered within 2 weeks for ApertureDiameter <= 30 Micrometer:"},
			ExperimentCoulterCount[{Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID], Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID]},
				ApertureDiameter -> 10.Micrometer,
				ElectrolyteSolution -> Object[Sample, "Test diluent sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
				Diluent -> {Object[Sample, "Test diluent sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID], Automatic},
				ConcentratedBuffer -> {Automatic, Object[Sample, "Test diluent sample 3 for ExperimentCoulterCount unit test "<>$SessionUUID]},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, CoulterCount]], {__Rule}},
			Messages :> {Warning::SolutionNotFiltered}
		],
		*)
		Example[{Messages, "NonEmptyMeasurementContainers", "Throw an error if user specifies a non empty container object for MeasurementContainer or SuitabilityMeasurementContainer:"},
			ExperimentCoulterCount[
				Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
				SystemSuitabilityCheck -> True,
				SampleAmount -> 8 * Milliliter,
				ElectrolyteSampleDilutionVolume -> 72 * Milliliter,
				SuitabilitySampleAmount -> 8 Milliliter,
				SuitabilityElectrolyteSampleDilutionVolume -> 72 * Milliliter,
				MeasurementContainer -> Object[Container, Vessel, "Test Container 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
				SuitabilityMeasurementContainer -> Object[Container, Vessel, "Test Container 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::NonEmptyMeasurementContainers, Error::InvalidOption}
		],
		Example[{Messages, "VolumeModeRecommended", "Throw an warning if user specifies StopCondition other than Volume mode for ApertureDiameter <= 280 Micrometer:"},
			ExperimentCoulterCount[
				{Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID], Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID]},
				ApertureDiameter -> 100. * Micrometer,
				SystemSuitabilityCheck -> True,
				StopCondition -> {Time, Volume},
				SuitabilityStopCondition -> ModalCount,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, CoulterCount]], {__Rule}},
			Messages :> {Warning::VolumeModeRecommended},
			SetUp :> {
				$CreatedObjects = {};
				ClearMemoization[];
				On[Warning::VolumeModeRecommended];
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects];
				Off[Warning::VolumeModeRecommended];
			}
		],
		Example[{Messages, "MoreThanOneComposition", "Throw an error if QuantifyConcentration is set to True, and sample has more than one analytes:"},
			ExperimentCoulterCount[Object[Sample, "Test sample 13 for ExperimentCoulterCount unit test "<>$SessionUUID],
				QuantifyConcentration -> True,
				Output -> {Result, Options}
			],
			{$Failed, {__Rule}},
			Messages :> {Error::MoreThanOneComposition, Error::InvalidOption, Error::InvalidInput}
		],
		Example[{Messages, "CannotMixMeasurementContainer", "Throw a warning if MixTime is set but measurement container is set to accuvette because integrated stirrer cannot be used for accuvette:"},
			ExperimentCoulterCount[
				{
					Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID]
				},
				SystemSuitabilityCheck -> True,
				SuitabilitySampleAmount -> 1 Milliliter,
				SuitabilityElectrolyteSampleDilutionVolume -> 24 Milliliter,
				SuitabilityMixRate -> 2 * RPM,
				SampleAmount -> {Automatic, 1 Milliliter},
				ElectrolyteSampleDilutionVolume -> {Automatic, 24 Milliliter},
				MixRate -> {Automatic, 2 * RPM},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, CoulterCount]], {__Rule}},
			Messages :> {Warning::CannotMixMeasurementContainer}
		],
		Example[{Additional, "Required Resources", "Generate all required resources for SystemSuitabilityCheck->True:"},
			Module[{protocol, resources, resourceFields},
				protocol = ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> True
				];
				resources = Download[protocol, RequiredResources];
				resourceFields = DeleteDuplicates[resources[[All, 2]]] /. Null -> Nothing;
				(*Check all resources*)
				ContainsExactly[resourceFields,
					{
						SamplesIn, ContainersIn, Instrument, ElectrolyteSolution, ApertureTube, MeasurementContainers,
						SuitabilitySizeStandards, SuitabilityMeasurementContainers, Checkpoints, RinseContainer
					}
				]
			],
			True
		],
		Example[{Additional, "Required Resources", "Generate all required resources for SystemSuitabilityCheck->False:"},
			Module[{protocol, resources, resourceFields},
				protocol = ExperimentCoulterCount[Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
					SystemSuitabilityCheck -> False
				];
				resources = Download[protocol, RequiredResources];
				resourceFields = DeleteDuplicates[resources[[All, 2]]] /. Null -> Nothing;
				(*Check all resources*)
				ContainsExactly[resourceFields,
					{
						SamplesIn, ContainersIn, Instrument, ElectrolyteSolution, ApertureTube, MeasurementContainers, Checkpoints, RinseContainer
					}
				]
			],
			True
		],
		Example[{Additional, "Required Resources", "Make unique resource per unique measurement container model/object:"},
			Module[{protocol, resources, resourceFields},
				protocol = ExperimentCoulterCount[{Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID], Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID]},
					SampleAmount -> 100 * Microliter,
					ElectrolyteSampleDilutionVolume -> 24 * Milliliter,
					SystemSuitabilityCheck -> True,
					SuitabilitySampleAmount -> 100 * Microliter,
					SuitabilityElectrolyteSampleDilutionVolume -> 24 * Milliliter
				];
				resources = Download[protocol, RequiredResources];
				SameObjectQ @@ Cases[resources, {res_Link, MeasurementContainers | SuitabilityMeasurementContainers, _, _} :> res]
			],
			True
		],
		Example[{Additional, "Required Resources", "Generate all required resources with proper lengths for SystemSuitabilityCheck->True with NumberOfReplicates and NumberOfSuitabilityReplicates specified:"},
			Module[{protocol, suitabilityMeasurementContainerResouces, suitabilitySizeStandards, numberOfSuitabilityReplicates, measurementContainerResouces, samplesIn, numberOfReplicates},
				protocol = ExperimentCoulterCount[{Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID], Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID]},
					SystemSuitabilityCheck -> True,
					SuitabilitySizeStandard -> {Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID], Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID]},
					ApertureDiameter -> 100. Micrometer,
					NumberOfReplicates -> 3,
					NumberOfReadings -> {1, 4},
					NumberOfSuitabilityReplicates -> 2,
					NumberOfSuitabilityReadings -> {3, 1}
				];
				{
					suitabilityMeasurementContainerResouces,
					suitabilitySizeStandards,
					numberOfSuitabilityReplicates,
					measurementContainerResouces,
					samplesIn,
					numberOfReplicates
				} = Download[
					protocol,
					{
						SuitabilityMeasurementContainers,
						SuitabilitySizeStandards,
						NumberOfSuitabilityReplicates,
						MeasurementContainers,
						SamplesIn,
						NumberOfReplicates
					}
				];
				(* Check if the lengths match NumberOfReplicates/NumberOfSuitabilityReplicates expansion *)
				And[
					Equal[
						Length[ToList[suitabilityMeasurementContainerResouces]],
						Length[ToList[suitabilitySizeStandards]],
						2 * numberOfSuitabilityReplicates
					],
					Equal[
						Length[ToList[measurementContainerResouces]],
						Length[ToList[samplesIn]] * numberOfReplicates
					]
				]
			],
			True
		],
		Example[{Additional, "Simulation", "Sample amount is decreased by the desired amount:"},
			Module[{coulterCountSimulation, newVolumes, oldVolumes},
				coulterCountSimulation = ExperimentCoulterCount[
					{
						Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID]
					},
					SuitabilitySizeStandard -> {
						Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID]
					},
					ApertureDiameter -> 100. Micrometer,
					Dilute -> {True, False},
					TransferVolume -> {10 Milliliter, Null},
					SampleAmount -> {5 Milliliter, 1 Milliliter},
					NumberOfSuitabilityReplicates -> 2,
					SuitabilitySampleAmount -> {1 Milliliter, 30 Milliliter},
					Output -> Simulation
				];
				newVolumes = Download[
					{
						Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID]
					},
					Volume,
					Simulation -> coulterCountSimulation
				];
				oldVolumes = Download[
					{
						Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
						Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID]
					},
					Volume
				];
				oldVolumes - newVolumes
			],
			{10 Milliliter, 1 Milliliter, 2 Milliliter, 60 Milliliter},
			EquivalenceFunction -> Equal
		],
		Example[{Additional, "Unit Operation", "Generate a MSP protocol when specified in between other sample prep unit operations:"},
			Module[{mspProtocol, mspSimulation, testTargetContainer, finalVolumeAfterMSP},
				{mspProtocol, mspSimulation} = ExperimentManualSamplePreparation[
					{
						LabelSample[
							Sample -> Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
							Label -> "test sample"
						],
						LabelContainer[
							Container -> Model[Container, Vessel, "100 mL Glass Bottle"],
							Label -> "test target container"
						],
						Transfer[
							Source -> "test sample",
							Destination -> "test target container",
							Amount -> 75 Milliliter,
							SterileTechnique -> False
						],
						CoulterCount[
							Sample -> "test target container",
							SampleAmount -> 1 Milliliter
						],
						Transfer[
							Destination -> Model[Container, Vessel, "50mL Tube"],
							Amount -> 10 Milliliter,
							SterileTechnique -> False
						]
					},
					Debug -> True,
					Output -> {Result, Simulation}
				];
				(* Look for sample after coulter experiment and transfer *)
				testTargetContainer = Lookup[mspSimulation[[1]][Labels], "test target container"];
				finalVolumeAfterMSP = Download[testTargetContainer, Contents[[All, 2]][Volume], Simulation -> mspSimulation][[1]];
				And[
					MatchQ[mspProtocol, ObjectP[Object[Protocol, ManualSamplePreparation]]],
					Equal[finalVolumeAfterMSP, 75 Milliliter - 1 Milliliter - 10 Milliliter]
				]
			],
			True
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentCoulterCount[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentCoulterCount[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentCoulterCount[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentCoulterCount[Object[Container, Vessel, "id:12345678"]],
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

				ExperimentCoulterCount[sampleID, Simulation -> simulationToPassIn, Output -> Options]
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

				ExperimentCoulterCount[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		]
	},
	(* Every time a test is run reset $CreatedObjects and erase objects created during that test at the end. *)
	(* Noted that SetUp/TearDown here will be overwritten if you also put them after individual test. *)
	SetUp :> (
		$CreatedObjects = {};
		ClearMemoization[];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
	),
	(* SymbolSetUp/SymbolTearDown only runs once in the beginning and in the end of unit tests. *)
	SymbolSetUp :> (
		(* Double check again to make sure all the named test objects are removed before setting up new objects. *)
		experimentCoulterCountTestCleanup[];
		(* Turning off this message since it is so prevailing and easy to hit, we will turn it on when we get to the corresponding message test *)
		Off[Warning::VolumeModeRecommended];
		Off[Warning::SolubleSamples];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::DeprecatedProduct];
		Off[Warning::SampleMustBeMoved];

		(* Setup Phase *)
		Block[{$DeveloperUpload = True},
			Module[
				{
					standardCurve, fit, testBench, mamCell1, mamCell2, mamCell3, yeastCell1, apertureTubeModel1, apertureTube1,
					tube1, tube2, tube3, tube4, tube5, tube6, tube7, tube8, tube9, tube10, tube11, tube12, tube13, tube14, tube15, tube16, tube17, tube18,
					sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13,
					discardedSample, gasSample, diluentSample1, diluentSample2, diluentSample3
				},

				(* Have to raw upload test bench and operator cart for now *)
				(* Also raw upload any models/standard curves that we should need *)
				{standardCurve, fit} = Upload[
					{
						Association[
							Type -> Object[Analysis, StandardCurve],
							Name -> "Test StandardCurve 1 (cfu/mL to cell/mL) for ExperimentCoulerCount unit test " <> $SessionUUID,
							Replace[StandardDataUnits] -> {CFU / Milliliter, EmeraldCell / Milliliter},
							BestFitFunction -> QuantityFunction[#1^2 &, CFU / Milliliter, EmeraldCell / Milliliter]
						],
						Association[
							Type -> Object[Analysis, Fit],
							Name -> "Test Fit for ExperimentCoulterCount unit test "<>$SessionUUID,
							BestFitFunction -> QuantityFunction[(10 + 5#1)&, {1 Torr}, 1 Microliter / Second]
						]
					}
				];
				{
					testBench,
					apertureTubeModel1,
					mamCell1,
					mamCell2,
					mamCell3,
					yeastCell1
				} = Upload[
					{
						Association[
							Type -> Object[Container, Bench],
							Name -> "Test bench for ExperimentCoulterCount unit test "<>$SessionUUID,
							Model -> Link[Model[Container, Bench, "id:bq9LA0JlA7Ad"], Objects],
							Site -> Link[$Site]
						],
						Association[
							Type -> Model[Part, ApertureTube],
							Name -> "Test aperture tube model for ExperimentCoulterCount unit test"<>$SessionUUID,
							DefaultStorageCondition -> Link[Model[StorageCondition, "id:bq9LA0JdKXW6"]], (* Model[StorageCondition, "Ambient Storage, Desiccated"] *)
							ApertureDiameter -> 10 Micrometer,
							PressureToFlowRateStandardCurve -> Link[fit]
						],
						(* 8 Micrometer Cell*)
						Association[
							Type -> Model[Cell, Mammalian],
							Name -> "Test mammalian cell 1 for ExperimentCoulterCount unit test "<>$SessionUUID,
							CellType -> Mammalian,
							Diameter -> 8 Micrometer
						],
						(* 1700 Micrometer Cell*)
						Association[
							Type -> Model[Cell, Mammalian],
							Name -> "Test mammalian cell 2 for ExperimentCoulterCount unit test "<>$SessionUUID,
							CellType -> Mammalian,
							Diameter -> 1700 Micrometer
						],
						(* Mammalian Cell *)
						Association[
							Type -> Model[Cell, Mammalian],
							Name -> "Test mammalian cell 3 for ExperimentCoulterCount unit test "<>$SessionUUID,
							CellType -> Mammalian,
							Replace[StandardCurves] -> Link[standardCurve]
						],
						(* Microbial Cell *)
						Association[
							Type -> Model[Cell, Yeast],
							Name -> "Test yeast cell 1 for ExperimentCoulterCount unit test "<>$SessionUUID,
							CellType -> Yeast
						]
					}
				];

				(* Prepare all containers put them on the bench *)
				(*
					1. Model[Container, Vessel, "Beckman Coulter Multisizer 4e Smart Technology (ST) Footed Beaker 100 mL"],
					2. Model[Container, Vessel, "100 mL Glass Bottle"],
					3. Model[Container, Vessel, "100 mL Glass Bottle"],
					4. Model[Container, Vessel, "100 mL Glass Bottle"],
					5. Model[Container, Vessel, "100 mL Glass Bottle"],
					6. Model[Container, Vessel, "100 mL Glass Bottle"],
					7. Model[Container, Vessel, "100 mL Glass Bottle"],
					8. Model[Container, Vessel, "100 mL Glass Bottle"],
					9. Model[Container, Vessel, "100 mL Glass Bottle"],
					10. Model[Container, Vessel, "50mL Tube"],
					11. Model[Container, Vessel, "100 mL Glass Bottle"],
					12. Model[Container, Vessel, "100 mL Glass Bottle"],
					13. Model[Container, Vessel, "100 mL Glass Bottle"],
					14. Model[Container, Vessel, "100 mL Glass Bottle"],
					15. Model[Container, GasCylinder, "CD50 Standard CO2 Tank"],
					16. Model[Container, Vessel, "Amber Glass Bottle 4 L"],
					17. Model[Container, Vessel, "Amber Glass Bottle 4 L"],
					18. Model[Container, Vessel, "Amber Glass Bottle 4 L"]
				*)
				{
					tube1, tube2, tube3, tube4, tube5, tube6, tube7, tube8, tube9, tube10, tube11, tube12, tube13, tube14, tube15, tube16, tube17, tube18
				} = UploadSample[
					{
						Model[Container, Vessel, "id:qdkmxzkKnbma"],
						Model[Container, Vessel, "id:jLq9jXvA8ewR"],
						Model[Container, Vessel, "id:jLq9jXvA8ewR"],
						Model[Container, Vessel, "id:jLq9jXvA8ewR"],
						Model[Container, Vessel, "id:jLq9jXvA8ewR"],
						Model[Container, Vessel, "id:jLq9jXvA8ewR"],
						Model[Container, Vessel, "id:jLq9jXvA8ewR"],
						Model[Container, Vessel, "id:jLq9jXvA8ewR"],
						Model[Container, Vessel, "id:jLq9jXvA8ewR"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:jLq9jXvA8ewR"],
						Model[Container, Vessel, "id:jLq9jXvA8ewR"],
						Model[Container, Vessel, "id:jLq9jXvA8ewR"],
						Model[Container, Vessel, "id:jLq9jXvA8ewR"],
						Model[Container, GasCylinder, "id:bq9LA0dBGG3a"],
						Model[Container, Vessel, "id:Vrbp1jG800Zm"],
						Model[Container, Vessel, "id:Vrbp1jG800Zm"],
						Model[Container, Vessel, "id:Vrbp1jG800Zm"]
					},
					ConstantArray[{"Work Surface", testBench}, 18],
					Name -> (("Test Container "<>ToString[#]<>" for ExperimentCoulterCount unit test "<>$SessionUUID)& /@ Range[18])
				];

				(* Now upload all the samples, aperture tubes we need, make sure they are in the tube *)
				(* sample1 with defined ParticleSize, aqueous *)
				(* sample2 with defined NominalParticleSize in its Model, aqueous *)
				(* sample3 with defined Diameter in its Composition molecule, organic *)
				(* sample4 with Mammalian CellType in its Composition, aqueous *)
				(* sample5 with Yeast CellType in its Composition, organic *)
				(* sample6 with no available particle type or diameter information, aqueous *)
				(* sample7 with Cell of 1700 Micron Diameter that is out of the instrument's capability in its composition, aqueous *)
				(* sample8 with very concentrated polymer particles, aqueous *)
				(* sample9 with diluted polymer particles, aqueous *)
				(* sample10, a solid state sample but somehow has particle concentration in its composition, unknown *)
				(* sample 11, a sample with CFU unit in its composition for testing ConvertCellConcentration[...], aqueous *)
				(* sample12 with solvent that is the same as electrolyte solution, aqueous *)
				(* sample13 with multiple cell compositions *)
				(* Discarded sample *)
				(* Gas sample *)
				(* solution that has been filtered recently with 0.1 um PoreSize within 2 weeks *)
				(* solution that has been filtered recently with 0.1 um PoreSize but not within 2 weeks *)
				(* solution that has been filtered recently with 0.45 um PoreSize within 2 weeks *)
				{
					apertureTube1,
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
					sample11,
					sample12,
					sample13,
					discardedSample,
					gasSample,
					diluentSample1,
					diluentSample2,
					diluentSample3
				} = UploadSample[
					{
						apertureTubeModel1,
						{
							{10^4 EmeraldCell / Milliliter, mamCell3},
							{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"] (*Model[Molecule, "Water"]*)}
						},
						Model[Sample, "id:3em6Zvm8j4dL"], (*Model[Sample, "Thermo Scientific 3K/4K Series Particle Counter Standard Count Control 5 µm"],*)
						{
							{10^5 EmeraldCell / Milliliter, mamCell1},
							{100 VolumePercent, Model[Molecule, "id:N80DNj16x6YA"]} (* organic phase*)
						},
						{
							{10^7 EmeraldCell / Milliliter, mamCell3},
							{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}
						},
						{
							{10^4 EmeraldCell / Milliliter, yeastCell1},
							{100 VolumePercent, Model[Molecule, "id:N80DNj16x6YA"]} (* organic phase *)
						},
						Model[Sample, "id:8qZ1VWNmdLBD"], (*Model[Sample, "Milli-Q water"],*)
						{
							{1000 EmeraldCell / Milliliter, mamCell2},
							{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}
						},
						{
							{10^7 / AvogadroConstant / Milliliter, Model[Molecule, Polymer, "id:o1k9jAGP8jJN"]},
							{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}
						},
						{
							{10^4 / AvogadroConstant / Milliliter, Model[Molecule, Polymer, "id:o1k9jAGP8jJN"]},
							{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}
						},
						{
							{3 / (37638379750000000000000000 * Pi) Mole / Micrometer^3, Link[Model[Molecule, Polymer, "id:o1k9jAGP8jJN"]]}
						},
						{
							{5 CFU / Milliliter, mamCell3},
							{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}
						},
						{
							{Null, Model[Molecule, Polymer, "id:o1k9jAGP8jJN"]},
							{Null, Model[Molecule, "id:BYDOjvG676mq"]}, (*Model[Molecule, "Sodium Chloride"]*)
							{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}
						},
						{
							{10^4 EmeraldCell / Milliliter, mamCell1},
							{10^4 EmeraldCell / Milliliter, mamCell3},
							{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}
						},
						Model[Sample, "id:D8KAEvKwzlkK"], (*Model[Sample, "Thermo Scientific 3K/4K Series Particle Counter Standard Count Control 50 µm"],*)
						Model[Sample, "id:o1k9jAKOwwlE"], (*Model[Sample, "Carbon dioxide"],*)
						Model[Sample, "id:n0k9mGkbr8j6"], (* Model[Sample,"Beckman Coulter ISOTON II Electrolyte Diluent"] *)
						Model[Sample, "id:n0k9mGkbr8j6"], (* Model[Sample,"Beckman Coulter ISOTON II Electrolyte Diluent"] *)
						Model[Sample, "id:n0k9mGkbr8j6"] (* Model[Sample,"Beckman Coulter ISOTON II Electrolyte Diluent"] *)
					},
					{
						{"Work Surface", testBench},
						{"A1", tube1},
						{"A1", tube2},
						{"A1", tube3},
						{"A1", tube4},
						{"A1", tube5},
						{"A1", tube6},
						{"A1", tube7},
						{"A1", tube8},
						{"A1", tube9},
						{"A1", tube10},
						{"A1", tube11},
						{"A1", tube12},
						{"A1", tube13},
						{"A1", tube14},
						{"A1", tube15},
						{"A1", tube16},
						{"A1", tube17},
						{"A1", tube18}
					},
					Name -> {
						"Test ApertureTube object 1 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test sample 3 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test sample 5 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test sample 6 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test sample 7 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test sample 10 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test sample 11 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test sample 12 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test sample 13 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test discarded sample for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test gas sample for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test diluent sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test diluent sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID,
						"Test diluent sample 3 for ExperimentCoulterCount unit test "<>$SessionUUID
					},
					InitialAmount -> {
						Null,
						50 Milliliter,
						75 Milliliter,
						75 Milliliter,
						75 Milliliter,
						75 Milliliter,
						75 Milliliter,
						75 Milliliter,
						75 Milliliter,
						75 Milliliter,
						20 Gram,
						75 Milliliter,
						75 Milliliter,
						75 Milliliter,
						75 Milliliter,
						1 Liter,
						2 Liter,
						2 Liter,
						2 Liter
					},
					State -> {
						Automatic,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Solid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Gas,
						Liquid,
						Liquid,
						Liquid
					},
					Living -> {
						Null,
						True,
						Null,
						True,
						True,
						True,
						Null,
						True,
						Null,
						Null,
						Null,
						True,
						True,
						True,
						Null,
						Null,
						Null,
						Null,
						Null
					}
				];

				(* Further update the samples with additional information *)
				Upload[
					{
						Association[
							Object -> sample1,
							ParticleSize -> NormalDistribution[8 Micrometer, 0.2 Micrometer],
							Solvent -> Link[Model[Sample, "id:8qZ1VWNmdLBD"]]
						],
						Association[
							Object -> sample3,
							Solvent -> Link[Model[Sample, "id:eGakld01zzXo"]] (*Model[Sample, "Chloroform"]*)
						],
						Association[
							Object -> sample4,
							Solvent -> Link[Model[Sample, "id:8qZ1VWNmdLBD"]]
						],
						Association[
							Object -> sample5,
							Solvent -> Link[Model[Sample, "id:eGakld01zzXo"]]
						],
						Association[
							Object -> sample6,
							Solvent -> Link[Model[Sample, "id:8qZ1VWNmdLBD"]]
						],
						Association[
							Object -> sample7,
							Solvent -> Link[Model[Sample, "id:8qZ1VWNmdLBD"]],
							ParticleSize -> NormalDistribution[1700 * Micrometer, 10 * Micrometer]
						],
						Association[
							Object -> sample8,
							ParticleSize -> NormalDistribution[50 Micrometer, 1.5 Micrometer],
							Solvent -> Link[Model[Sample, "id:8qZ1VWNmdLBD"]]
						],
						Association[
							Object -> sample9,
							ParticleSize -> NormalDistribution[50 Micrometer, 1.5 Micrometer],
							Solvent -> Link[Model[Sample, "id:8qZ1VWNmdLBD"]]
						],
						Association[
							Object -> sample12,
							Solvent -> Link[Model[Sample, "id:n0k9mGkbr8j6"]] (* Model[Sample,"Beckman Coulter ISOTON II Electrolyte Diluent"] *),
							Replace[Analytes] -> Link[Model[Molecule, Polymer, "id:o1k9jAGP8jJN"]], (*Model[Molecule, Polymer, "Polystyrene"]*)
							ParticleSize -> NormalDistribution[8 Micrometer, 0.2 Micrometer]
						],
						Association[
							Object -> diluentSample1,
							Replace[SampleHistory] -> Filtered[Date -> (Now - 1 * Hour), PoreSize -> 0.1 * Micron]
						],
						Association[
							Object -> diluentSample2,
							Replace[SampleHistory] -> Filtered[Date -> (Now - 1 * Year), PoreSize -> 0.1 * Micron]
						],
						Association[
							Object -> diluentSample3,
							Replace[SampleHistory] -> Filtered[Date -> (Now - 1 * Hour), PoreSize -> 0.45 * Micron]
						]
					}
				];
				UploadSampleProperties[
					sample10,
					Density -> 4 Gram / Milliliter
				];
				UploadSampleStatus[
					discardedSample,
					Discarded
				]
			]];
	),
	SymbolTearDown :> (
		On[Warning::VolumeModeRecommended];
		On[Warning::SolubleSamples];
		On[Warning::SamplesOutOfStock];
		On[Warning::DeprecatedProduct];
		On[Warning::SampleMustBeMoved];
		experimentCoulterCountTestCleanup[];
	),
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "id:n0k9mG8AXZP6"], (*Object[User, "Test user for notebook-less test protocols"],*)
		$DeveloperUpload = True
	}
];


experimentCoulterCountTestCleanup[] := Module[{objects, objectsExistQ},
	(* List all test objects to erase. Can use SetUpTestObjects[]+ObjectToString[] to get the comprehensive list. *)
	objects = {
		Object[Container, Bench, "Test bench for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, OperatorCart, "Test operator cart for ExperimentCoulterCount unit test "<>$SessionUUID],
		(* Containers *)
		Object[Container, Vessel, "Test Container 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 3 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 4 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 5 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 6 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 7 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 9 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 10 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 11 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 12 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 13 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 14 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, GasCylinder, "Test Container 15 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 16 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 17 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "Test Container 18 for ExperimentCoulterCount unit test "<>$SessionUUID],
		(* Samples *)
		Object[Sample, "Test sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test sample 3 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test sample 4 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test sample 5 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test sample 6 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test sample 7 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test sample 8 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test sample 9 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test sample 10 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test sample 11 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test sample 12 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test sample 13 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test discarded sample for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test gas sample for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test diluent sample 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test diluent sample 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Sample, "Test diluent sample 3 for ExperimentCoulterCount unit test "<>$SessionUUID],
		(* Model cells *)
		Model[Cell, Mammalian, "Test mammalian cell 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Model[Cell, Mammalian, "Test mammalian cell 2 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Model[Cell, Mammalian, "Test mammalian cell 3 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Model[Cell, Yeast, "Test yeast cell 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Analysis, StandardCurve, "Test StandardCurve 1 (cfu/mL to cell/mL) for ExperimentCoulerCount unit test "<>$SessionUUID],
		(* ApertureTube objects *)
		Object[Part, ApertureTube, "Test ApertureTube object 1 for ExperimentCoulterCount unit test "<>$SessionUUID],
		Object[Analysis, Fit, "Test Fit for ExperimentCoulterCount unit test "<>$SessionUUID],
		Model[Part, ApertureTube, "Test aperture tube model for ExperimentCoulterCount unit test"<>$SessionUUID]
	};

	(* Check whether the names we want to give below already exist in the database *)
	objectsExistQ = DatabaseMemberQ[objects];

	(* Erase any objects that we failed to erase in the last unit test. *)
	Quiet[EraseObject[PickList[objects, objectsExistQ], Force -> True, Verbose -> False]]
];


(* ::Subsection:: *)
(*CoulterCount*)

DefineTests[
	CoulterCount,
	{
		Example[{Basic, "Counting and sizing particles in sample:"},
			Experiment[
				{
					CoulterCount[
						Sample -> {
							Object[Sample, "test sample 1 for CoulterCount unit test "<>$SessionUUID],
							Object[Sample, "test sample 2 for CoulterCount unit test "<>$SessionUUID]
						}
					]
				}
			],
			ObjectP[Object[Protocol, ManualCellPreparation]]
		],
		Example[{Basic, "Enqueue a series of primitives:"},
			ExperimentManualSamplePreparation[
				{
					LabelSample[
						Sample -> Object[Sample, "test sample 1 for CoulterCount unit test "<>$SessionUUID],
						Label -> "test sample"
					],
					LabelContainer[
						Container -> Model[Container, Vessel, "100 mL Glass Bottle"],
						Label -> "test target container"
					],
					Transfer[
						Source -> "test sample",
						Destination -> "test target container",
						Amount -> 75 Milliliter,
						SterileTechnique -> False
					],
					CoulterCount[
						Sample -> "test target container",
						SampleAmount -> 1 Milliliter
					],
					Transfer[
						Destination -> Model[Container, Vessel, "50mL Tube"],
						Amount -> 10 Milliliter,
						SterileTechnique -> False
					]
				},
				Debug -> True
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Cannot run as Robotic Primitives:"},
			ExperimentRoboticSamplePreparation[
				{
					LabelSample[
						Sample -> Object[Sample, "test sample 1 for CoulterCount unit test "<>$SessionUUID],
						Label -> "test sample"
					],
					LabelContainer[
						Container -> Model[Container, Vessel, "100 mL Glass Bottle"],
						Label -> "test target container"
					],
					Transfer[
						Source -> "test sample",
						Destination -> "test target container",
						Amount -> 75 Milliliter,
						SterileTechnique -> False
					],
					CoulterCount[
						Sample -> "test target container",
						SampleAmount -> 1 Milliliter
					],
					Transfer[
						Destination -> Model[Container, Vessel, "50mL Tube"],
						Amount -> 10 Milliliter,
						SterileTechnique -> False
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
			ExperimentManualSamplePreparation[{CoulterCount[
				Sample -> Object[Sample, "test sample 3 for CoulterCount unit test "<>$SessionUUID]
			]}],
			$Failed,
			Messages :> {Error::ParticleSizeOutOfRange, Error::InvalidInput}
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> {
		$CreatedObjects = {};
		ClearMemoization[];
	},
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::DeprecatedProduct];
		Off[Warning::SampleMustBeMoved];
		coulterCountTestsTearDown[];
		$CreatedObjects = {};
		Module[{testBench, tube1, tube2, tube3, sample1, sample2, sample3},
			Block[{$DeveloperUpload = True},
				(* Reserve id for a list of objects to create *)
				{
					testBench,
					tube1,
					tube2,
					tube3,
					sample1,
					sample2,
					sample3
				} = CreateID[{
					Object[Container, Bench],
					Object[Container, Vessel],
					Object[Container, Vessel],
					Object[Container, Vessel],
					Object[Sample],
					Object[Sample],
					Object[Sample]
				}];

				(* raw upload to create the bench *)
				Upload[{
					<|
						Object -> testBench,
						Model -> Link[Model[Container, Bench, "id:bq9LA0JlA7Ad"], Objects], (*Model[Container, Bench, "The Bench of Testing"]*)
						Name -> "test bench for CoulterCount unit test "<>$SessionUUID,
						Site -> Link[$Site]
					|>
				}];

				(* Make containers *)
				{
					tube1,
					tube2,
					tube3
				} = UploadSample[
					{
						Model[Container, Vessel, "id:jLq9jXvA8ewR"], (*Model[Container, Vessel, "100 mL Glass Bottle"]*)
						Model[Container, Vessel, "id:jLq9jXvA8ewR"],
						Model[Container, Vessel, "id:jLq9jXvA8ewR"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"test tube 1 for CoulterCount unit test "<>$SessionUUID,
						"test tube 2 for CoulterCount unit test "<>$SessionUUID,
						"test tube 3 for CoulterCount unit test "<>$SessionUUID
					}
				];

				(* sample 1 and sample 2 are good samples, sample 3 will throw an error *)
				{
					sample1,
					sample2,
					sample3
				} = UploadSample[
					{
						{{10^4 / AvogadroConstant / Milliliter, Model[Molecule, Polymer, "id:o1k9jAGP8jJN"]}, {99 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}},
						{{10^4 EmeraldCell / Milliliter, Model[Cell, Bacteria, "id:54n6evLm7m0L"]}, {99 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}},
						{{10^4 / AvogadroConstant / Milliliter, Model[Molecule, Polymer, "id:o1k9jAGP8jJN"]}, {99 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}
					},
					{
						{"A1", tube1},
						{"A1", tube2},
						{"A1", tube3}
					},
					InitialAmount -> {
						75 Milliliter,
						75 Milliliter,
						75 Milliliter
					},
					Name -> {
						"test sample 1 for CoulterCount unit test "<>$SessionUUID,
						"test sample 2 for CoulterCount unit test "<>$SessionUUID,
						"test sample 3 for CoulterCount unit test "<>$SessionUUID
					},
					ID -> Download[{
						sample1,
						sample2,
						sample3
					}, ID],
					State -> {
						Liquid,
						Liquid,
						Liquid
					},
					Living -> {
						Null,
						True,
						Null
					}
				];

				(* secondary upload to make sample 3 oversize *)
				Upload[{
					<|
						Object -> sample3,
						ParticleSize -> EmpiricalDistribution[{99, 1} -> {1700 * Micrometer, 100 Micrometer}]
					|>
				}]
			]
		];
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::DeprecatedProduct];
		On[Warning::SampleMustBeMoved];
		coulterCountTestsTearDown[];
	)
];

coulterCountTestsTearDown[] := Module[{objects, objectsExistQ},
	(* List all test objects to erase. Can use SetUpTestObjects[]+ObjectToString[] to get the comprehensive list. *)
	objects = Flatten[{
		Object[Container, Bench, "test bench for CoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "test tube 1 for CoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "test tube 2 for CoulterCount unit test "<>$SessionUUID],
		Object[Container, Vessel, "test tube 3 for CoulterCount unit test "<>$SessionUUID],
		Object[Sample, "test sample 1 for CoulterCount unit test "<>$SessionUUID],
		Object[Sample, "test sample 2 for CoulterCount unit test "<>$SessionUUID],
		Object[Sample, "test sample 3 for CoulterCount unit test "<>$SessionUUID],
		If[MatchQ[$CreatedObjects, _List], $CreatedObjects, Nothing]
	}];

	(* Check whether the names we want to give below already exist in the database *)
	objectsExistQ = DatabaseMemberQ[objects];

	(* Erase any objects that we failed to erase in the last unit test. *)
	Quiet[EraseObject[PickList[objects, objectsExistQ], Force -> True, Verbose -> False]]
];


