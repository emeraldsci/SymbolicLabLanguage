(* ::Package:: *)
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)
DefineObjectType[Object[Protocol, GrowCrystal], {
	Description -> "A protocol to prepare crystallization plate containing sample solution, and to set up incubation and imaging schedule of the prepared crystallization plate to monitor the growth of the sample crystals for X-ray diffraction (XRD).", 
	CreatePrivileges -> None, 
	Cache -> Session, 
	Fields -> {
		(*===General Information===*)
		PreparedPlate -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the plate containing the samples for crystallization experiment has been previously transferred with samples and reagents and does not need to run sample preparation step to prepare the crystallization plate.",
			Category -> "General"
		},
		ReservoirDispensingInstrument -> {
			Format -> Single, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Alternatives[
				Model[Instrument, LiquidHandler], 
				Object[Instrument, LiquidHandler]
			], 
			Description -> "The instrument for transferring reservoir buffers to the reservoir wells of crystallization plate during the sample preparation step of the crystallization experiment if CrystallizationTechnique is SittingDropVaporDiffusion.", 
			Category -> "General"
		}, 
		DropSetterInstrument -> {
			Format -> Single, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Alternatives[
				Model[Instrument, LiquidHandler], 
				Object[Instrument, LiquidHandler], 
				Model[Instrument, LiquidHandler, AcousticLiquidHandler], 
				Object[Instrument, LiquidHandler, AcousticLiquidHandler]
			], 
			Description -> "The instrument which transfers the input sample and other reagents to the drop wells of crystallization plate during the sample preparation step of the crystallization experiment.", 
			Category -> "General"
		},
		ImagingInstrument -> {
			Format -> Single, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Alternatives[
				Model[Instrument, CrystalIncubator], 
				Object[Instrument, CrystalIncubator]
			], 
			Description -> "The instrument for monitoring the growth of crystals of an input sample, which is placed in a crystallization plate. This is achieved by capturing daily images of the drop that contains the sample, using visible light, ultraviolet light and cross polarized light.", 
			Category -> "General"
		}, 
		FumeHood -> {
			Format -> Single, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Alternatives[Object[Instrument, FumeHood], Model[Instrument, FumeHood]],
			Description -> "The environment in which CoCrystallizationReagents on CrystallizationPlate are evaporated. The CrystallizationPlate involved in the air dry will first be moved into the Environment (with cover on), uncovered inside of the Environment, then covered after the Transfer has finished -- before they're moved back onto the operator cart.",
			Category -> "General"
		}, 
		CrystallizationTechnique -> {
			Format -> Single, 
			Class -> Expression, 
			Pattern :> CrystallizationTechniqueP, (*SittingDropVaporDiffusion, MicrobatchUnderOil, MicrobatchWithOutOil*)
			Description -> "The method that is used to construct crystallization plate and promote the sample solution to nucleate and grow during the incubation.", 
			Category -> "General"
		}, 
		CrystallizationStrategy -> {
			Format -> Single, 
			Class -> Expression, 
			Pattern :> CrystallizationStrategyP, (*Screening, Optimization, Preparation*)
			Description -> "The end goal for setting up the crystallization plate, either Screening, Optimization, or Preparation.", 
			Category -> "General"
		},
		CrystallizationPlate -> {
			Format -> Single, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Alternatives[Model[Container], Object[Container]], 
			Description -> "The container that the input sample and other reagents that are transferred into. After the container is constructed by pipetting, it is incubated and imaged to monitor the growth of crystals of the input sample.", 
			Category -> "General"
		}, 
		CrystallizationCover -> {
			Format -> Single, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Alternatives[
				Model[Item, PlateSeal], 
				Object[Item, PlateSeal]
			], 
			Description -> "The thin film that is placed over the top of the CrystallizationPlate after the container is constructed by pipetting. Cover separates the contents inside of CrystallizationPlate from environment and each other to prevent contamination, evaporation and cross-contamination.", 
			Category -> "General"
		},
		PlateSealPaddle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, PlateSealRoller],
				Object[Item, PlateSealRoller]
			],
			Description -> "The film sealing paddle to secure the adhesive CrystallizationCover to the CrystallizationPlate.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		AssayPlates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Plate] | Object[Container, Plate],
			Description -> "The plates to premix or aliquot the buffers (and samples). AcousticLiquidHandler compatible plates are used as target container to aliquot samples and buffers before transferring those to CrystallizationPlate. DeepWallPlate is used as target container to premix buffers, or mix buffers with samples if total buffer volume is lower than $MinRoboticTransferVolume.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		DropSamplesOut -> {
			Format -> Multiple, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Object[Sample], 
			Description -> "All solutions generated by the protocol containing the given sample as well as a specific combination of reagents such as DilutionBuffer, ReservoirBuffer, Additive, CoCrystallizationReagent, SeedingSolution and Oil for the purpose of growing crystals of the given sample in drop wells.", 
			Category -> "Experimental Results"
		},
		ReservoirSamplesOut -> {
			Format -> Multiple, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Object[Sample], 
			Description -> "All solutions generated by the protocol containing high concentration of precipitants, salts and pH buffers in the reservoir wells for the purpose of driving supersaturation of DropSamplesOut in SittingDropVaporDiffusion plate configuration.", 
			Category -> "Experimental Results"
		},
		(*===Sample Preparation Information===*)
		PreMixBuffer -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if various type of buffers (including DilutionBuffer, ReservoirBuffers, unevaporated CoCrystallizationReagents, Additives, SeedingSolution) should be premixed. The purpose of premixing is to reduce the total transfer time when these buffers are being transferred to CrystallizationPlate as part of the drop setting step of sample preparation.",
			Category -> "Sample Preparation"
		},
		DropCompositionTable -> {
			Format -> Multiple,
			Class -> {
				DropSampleOutLabel -> String,
				DestinationWell -> String,
				Sample -> Link,
				SampleVolume -> Real,
				DilutionBuffer -> Link,
				DilutionBufferVolume -> Real,
				ReservoirBuffer -> Link,
				ReservoirDropVolume -> Real,
				CoCrystallizationReagent -> Link,
				CoCrystallizationReagentVolume -> Real,
				CoCrystallizationAirDry -> Boolean,
				Additive -> Link,
				AdditiveVolume -> Real,
				SeedingSolution -> Link,
				SeedingSolutionVolume -> Real,
				Oil -> Link,
				OilVolume -> Real
			},
			Pattern :> {
				DropSampleOutLabel -> _String,
				DestinationWell -> WellPositionP,
				Sample -> _Link,
				SampleVolume -> VolumeP,
				DilutionBuffer -> _Link,
				DilutionBufferVolume -> VolumeP,
				ReservoirBuffer -> _Link,
				ReservoirDropVolume -> VolumeP,
				CoCrystallizationReagent -> _Link,
				CoCrystallizationReagentVolume -> VolumeP,
				CoCrystallizationAirDry -> BooleanP,
				Additive -> _Link,
				AdditiveVolume -> VolumeP,
				SeedingSolution -> _Link,
				SeedingSolutionVolume -> VolumeP,
				Oil -> _Link,
				OilVolume -> VolumeP
			},
			Relation -> {
				DropSampleOutLabel -> Null,
				DestinationWell -> Null,
				Sample -> Model[Sample]|Object[Sample],
				SampleVolume -> Null,
				DilutionBuffer -> Model[Sample]|Object[Sample],
				DilutionBufferVolume -> Null,
				ReservoirBuffer -> Model[Sample]|Object[Sample],
				ReservoirDropVolume -> Null,
				CoCrystallizationReagent -> Model[Sample]|Object[Sample],
				CoCrystallizationReagentVolume -> Null,
				CoCrystallizationAirDry -> Null,
				Additive -> Model[Sample]|Object[Sample],
				AdditiveVolume -> Null,
				SeedingSolution -> Model[Sample]|Object[Sample],
				SeedingSolutionVolume -> Null,
				Oil -> Model[Sample]|Object[Sample],
				OilVolume -> Null
			},
			Units -> {
				DropSampleOutLabel -> None,
				DestinationWell -> None,
				Sample -> None,
				SampleVolume -> Nanoliter,
				DilutionBuffer -> None,
				DilutionBufferVolume -> Nanoliter,
				ReservoirBuffer -> None,
				ReservoirDropVolume -> Nanoliter,
				CoCrystallizationReagent -> None,
				CoCrystallizationReagentVolume -> Nanoliter,
				CoCrystallizationAirDry -> None,
				Additive -> None,
				AdditiveVolume -> Nanoliter,
				SeedingSolution -> None,
				SeedingSolutionVolume -> Nanoliter,
				Oil -> None,
				OilVolume -> Microliter
			},
			Description -> "All buffer buffers and their volumes as well as Sample and SampleVolume involved for DropSamplesOut. The buffer type includes DilutionBuffer, ReservoirBuffer, CoCrystallizationReagent, Additive, SeedingSolution and Oil.",
			Category -> "Sample Preparation"
		},
		BufferPreparationTable -> {
			Format -> Multiple, 
			Class -> {
				Step -> Expression,
				Source -> Link,
				PreMixSolutionLabel -> String,
				TransferVolume -> Real, 
				TargetContainer -> Link,
				DestinationWells -> Expression,
				TargetContainerLabel -> String,
				PreparedSolutionsLabel -> Expression
			}, 
			Pattern :> {
				Step -> CrystallizationStepP,
				Source -> _Link,
				PreMixSolutionLabel -> _String,
				TransferVolume -> VolumeP,
				TargetContainer -> _Link,
				DestinationWells -> {WellPositionP..},
				TargetContainerLabel -> _String,
				PreparedSolutionsLabel -> {_String..}
			}, 
			Relation -> {
				Step -> Null,
				Source -> Model[Sample]|Object[Sample],
				PreMixSolutionLabel -> Null,
				TransferVolume -> Null,
				TargetContainer -> Model[Container, Plate]|Object[Container, Plate],
				DestinationWells -> Null,
				TargetContainerLabel -> Null,
				PreparedSolutionsLabel -> Null
			}, 
			Units -> {
				Step -> None,
				Source -> None,
				PreMixSolutionLabel -> None,
				TransferVolume -> Microliter,
				TargetContainer -> None,
				DestinationWells -> None,
				TargetContainerLabel -> None,
				PreparedSolutionsLabel -> None
			}, 
			Description -> "The sequence of mixing reagents to increase the buffer volume above the Hamilton minimum transfer threshold or aliquoting reagents to Echo-compatible SourcePlate prior to being transferred to drop wells of CrystallizationPlate.",
			Category -> "Sample Preparation"
		}, 
		TransferTable -> {
			Format -> Multiple, 
			Class -> {
				Step -> Expression, 
				TransferType -> Expression, 
				Source -> Link,
				PreparedSolutionLabel -> String,
				TransferVolume -> Real,
				DestinationWells -> Expression,
				SamplesOutLabel -> Expression
			}, 
			Pattern :> {
				Step -> CrystallizationStepP, 
				TransferType -> Alternatives[AcousticLiquidHandling, LiquidHandling], 
				Source -> _Link,
				PreparedSolutionLabel -> _String,
				TransferVolume -> VolumeP,
				DestinationWells -> {WellPositionP..},
				SamplesOutLabel -> {_String..}
			}, 
			Relation -> {
				Step -> Null, 
				TransferType -> Null, 
				Source -> Model[Sample]|Object[Sample],
				PreparedSolutionLabel -> Null,
				TransferVolume -> Null,
				DestinationWells -> Null,
				SamplesOutLabel -> Null
			}, 
			Units -> {
				Step -> None, 
				TransferType -> None, 
				Source -> None,
				PreparedSolutionLabel -> None,
				TransferVolume -> Nanoliter,
				DestinationWells -> None,
				SamplesOutLabel -> None
			}, 
			Description -> "The sequence of loading sample, DilutionBuffer, ReservoirBuffers, Additives, CoCrystallizationReagents, and SeedingSolution or their mixtures into the the CrystallizationPlate during the Sample Preparation step.", 
			Category -> "Sample Preparation"
		},
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, LiquidHandler],
				Model[Instrument, LiquidHandler]
			],
			Description -> "The liquid handler work cell used to perform CrystallizationPlateLoadingRoboticUnitOperations, CoCrystallizationAirDryRoboticUnitOperations, CoCrystallizationAirDryIncubationUnitOperations and OilCoverUnitOperations. If either DropSetterInstrument or ReservoirDispensingInstrument is specified as a LiquidHandler, LiquidHandler is set to the same value.",
			Category -> "General",
			Developer -> True
		},
		CrystallizationPlateLoadingRoboticUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The set of instructions specifying the loading the Crystallization with input sample, DilutionBuffer, ReservoirBuffers, Additives, CoCrystallizationReagents, and SeedingSolution or their mixtures.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		CrystallizationPlateLoadingRoboticPreparation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, RoboticSamplePreparation],
			Description -> "The sample preparation protocol generated as a result of the execution of CrystallizationPlateLoadingRoboticUnitOperations.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		CoCrystallizationAirDryRoboticUnitOperations -> {
			Format -> Multiple, 
			Class -> Expression, 
			Pattern :> SamplePreparationP, 
			Description -> "The set of instructions specifying the loading the AssayPlate(s) with the CoCrystallizationReagents for air drying.",
			Category -> "Sample Preparation", 
			Developer -> True
		},
		CoCrystallizationAirDryRoboticPreparation -> {
			Format -> Single, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Object[Protocol, RoboticSamplePreparation],
			Description -> "The sample preparation protocol generated as a result of the execution of CoCrystallizationAirDryRoboticUnitOperations.",
			Category -> "Sample Preparation", 
			Developer -> True
		},
		CoCrystallizationAirDryAcousticTransferUnitOperations -> {
			Format -> Multiple, 
			Class -> Expression, 
			Pattern :> SampleManipulationP,
			Description -> "The set of instructions specifying the loading the CrystallizationPlate with CoCrystallizationReagents for air drying.",
			Category -> "Sample Preparation", 
			Developer -> True
		},
		CoCrystallizationAirDryAcousticTransferSources -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]},
			Description -> "The transfer sources for loading the CrystallizationPlate with CoCrystallizationReagents for air drying.",
			Category -> "Sample Preparation"
		},
		CoCrystallizationAirDryAcousticTransferDestinations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectP[{Object[Sample], Object[Container], Model[Container]}] | _String | {_Integer, ObjectP[Model[Container]]} | {LocationPositionP, _String | ObjectP[{Object[Container, Plate], Model[Container, Plate]}] | {_Integer, ObjectP[Model[Container]]}},
			Description -> "The transfer destinations for loading the CrystallizationPlate with CoCrystallizationReagents for air drying.",
			Category -> "Sample Preparation"
		},
		CoCrystallizationAirDryAcousticTransferAmounts -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Nanoliter],
			Description -> "The transfer amounts for loading the CrystallizationPlate with CoCrystallizationReagents for air drying.",
			Category -> "Sample Preparation",
			Units -> Nanoliter
		},
		CoCrystallizationAirDryAcousticTransferPreparation -> {
			Format -> Single, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Object[Protocol, AcousticLiquidHandling],
			Description -> "The sample preparation protocol generated as a result of the execution of CoCrystallizationAirDryAcousticTransferUnitOperations.",
			Category -> "Sample Preparation", 
			Developer -> True
		},
		CoCrystallizationAirDryIncubationUnitOperations -> {
			Format -> Multiple, 
			Class -> Expression, 
			Pattern :> SamplePreparationP, 
			Description -> "The set of instructions specifying the placing of CrystallizationPlate filled with CoCrystallizationReagents into FumeHood or Liquid Handler enclosure to air dry.",
			Category -> "Sample Preparation", 
			Developer -> True
		},
		CoCrystallizationAirDryIncubationPreparation -> {
			Format -> Single, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Object[Protocol, RoboticSamplePreparation],
			Description -> "The sample preparation protocol generated as a result of the execution of CoCrystallizationAirDryIncubationUnitOperations.",
			Category -> "Sample Preparation", 
			Developer -> True
		},
		DropSetAcousticTransferUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "The set of instructions specifying the loading the CrystallizationPlate with input samples, dilutionbuffers, reservoirbuffers, additives, unevaporated cocrystallizationreagents, seeding solutions.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		DropSetAcousticTransferSources -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]},
			Description -> "The transfer sources for loading the CrystallizationPlate with input samples, dilutionbuffers, reservoirbuffers, additives, unevaporated cocrystallizationreagents, seeding solutions.",
			Category -> "Qualifications & Maintenance"
		},
		DropSetAcousticTransferDestinations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectP[{Object[Sample], Object[Container], Model[Container]}] | _String | {_Integer, ObjectP[Model[Container]]} | {LocationPositionP, _String | ObjectP[{Object[Container, Plate], Model[Container, Plate]}] | {_Integer, ObjectP[Model[Container]]}},
			Description -> "The transfer destinations for loading the CrystallizationPlate with input samples, dilutionbuffers, reservoirbuffers, additives, unevaporated cocrystallizationreagents, seeding solutions.",
			Category -> "Qualifications & Maintenance"
		},
		DropSetAcousticTransferAmounts -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Nanoliter],
			Description -> "The transfer amounts for loading the CrystallizationPlate with input samples, dilutionbuffers, reservoirbuffers, additives, unevaporated cocrystallizationreagents, seeding solutions.",
			Category -> "Qualifications & Maintenance",
			Units -> Nanoliter
		},
		DropSetAcousticAcousticTransferPreparation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, AcousticLiquidHandling],
			Description -> "The sample preparation protocol generated as a result of the execution of DropSetAcousticTransferUnitOperations.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		OilCoverUnitOperations -> {
			Format -> Multiple, 
			Class -> Expression, 
			Pattern :> SamplePreparationP, 
			Description -> "The set of instructions specifying the loading the CrystallizationPlate with oil.",
			Category -> "Sample Preparation", 
			Developer -> True
		},
		OilCoverPreparation -> {
			Format -> Single, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Object[Protocol, RoboticSamplePreparation],
			Description -> "The sample preparation protocol generated as a result of the execution of OilCoverUnitOperations.",
			Category -> "Sample Preparation", 
			Developer -> True
		},
		CoverPreparation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, Cover],
			Description -> "The cover protocol to instruct how to apply CrystallizationCover to CrystallizationPlate.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		ReservoirBuffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "All the cocktail solutions which contain high concentration of precipitants, salts and pH buffers.",
			Category -> "Sample Preparation"
		},
		DilutionBuffers -> {
			Format -> Multiple, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Alternatives[Model[Sample], Object[Sample]], 
			Description -> "All the solutions to bring the concentration of the input sample down by transferring into the drop well of CrystallizationPlate during the drop setting step of sample preparation.",
			Category -> "Sample Preparation"
		},
		Additives -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "All the solutions that are transferred into the drop wells of CrystallizationPlate to change the solubility of the input sample during the drop setting step of sample preparation.",
			Category -> "Sample Preparation"
		},
		CoCrystallizationReagents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "All the solutions that are transferred into the drop wells of CrystallizationPlate containing compounds that solidify together with the input sample during the drop setting step of sample preparation if CoCrystallizationAirDry is False or before the reservoir filling step of sample preparation if CoCrystallizationAirDry is True.",
			Category -> "Sample Preparation"
		},
		CoCrystallizationAirDryTime -> {
			Format -> Single,
			Class -> Real, 
			Pattern :> GreaterEqualP[0 Hour], 
			Units -> Hour, 
			Description -> "The length of time for which the CoCrystallizationReagents are held inside the fume hood to allow the solvent to be fully evaporated from the crystallization plate prior to filling the reservoir well and drop well of the crystallization plate.",
			Category -> "Sample Preparation"
		}, 
		CoCrystallizationAirDryTemperature -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterP[0 Celsius]|Ambient,
			Description -> "The temperature for which the CoCrystallizationReagents are held inside the FumeHood or on HeatBlock of LiquidHandler to allow the solvent to be fully evaporated from the crystallization plate prior to filling the reservoir well and drop well of the crystallization plate.",
			Category -> "Sample Preparation"
		}, 
		SeedingSolutions -> {
			Format -> Multiple, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Alternatives[Model[Sample], Object[Sample]], 
			Description -> "All the solutions that are transferred into the drop wells of CrystallizationPlate containing micro crystals of the input sample that serves as nucleates to facilitate crystallization during the drop setting step of sample preparation.",
			Category -> "Sample Preparation"
		},
		Oils -> {
			Format -> Multiple, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Alternatives[Model[Sample], Object[Sample]], 
			Description -> "All the fluids that are dispensed to cover the droplets containing sample and other reagents (DilutionBuffer, Additive, ReservoirBuffer, CoCrystallizationReagent) to control the evaporation of water after the drop setting step of sample preparation.",
			Category -> "Sample Preparation"
		},
		(*===Imaging Information===*)
		UVImaging -> {
			Format -> Single, 
			Class -> Boolean, 
			Pattern :> BooleanP, 
			Description -> "Indicates if UV fluorescence images are scheduled to be captured. UV Imaging harnesses the intrinsic fluorescence of tryptophan excited by UV light at 280nm and emitted at 350nm to signify the presence of a protein, reducing false positive and false negative identification of protein crystals.", 
			Category -> "Imaging"
		}, 
		CrossPolarizedImaging -> {
			Format -> Single, 
			Class -> Boolean, 
			Pattern :> BooleanP, 
			Description -> "Indicates if images by cross polarized light of crystallization plate are scheduled to be captured. The polarizers aid in the identification of crystals by harnessing a crystal's natural birefringence properties, providing a kaleidoscope of colors on the crystal's planes to differentiate a crystal from the plate surface and mother liquor.", 
			Category -> "Imaging"
		},
		DropDestinations -> {
			Format -> Single,
			Class -> Expression,
			Pattern :>  {CrystallizationWellContentsP..},
			Description -> "The flattened desired locations of DropSamplesOut on the crystallization plate being monitored daily.",
			Category -> "Imaging",
			Developer -> True
		},
		(*===Incubation Information===*)
		MaxCrystallizationTime -> {
			Format -> Single, 
			Class -> Real, 
			Pattern :> GreaterEqualP[0 Day], 
			Units -> Day, 
			Description -> "The max length of time for which the sample is held inside the crystal incubator to allow the growth of the crystals.", 
			Category -> "Incubation"
		}, 
		SamplesOutStorageCondition -> {
			Format -> Single, 
			Class -> Expression, 
			Pattern :> SampleStorageTypeP|ObjectP[Model[StorageCondition]], (*CrystalIncubation or Model[StorageCondtion, "Crystal Incubation"]*)
			Description -> "The condition under which the constructed crystallization plate is incubated before the MaxCrystallizationTime is reached.",
			Category -> "Incubation", 
			Developer -> True
		}, 
		FormulatrixBarcode -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The 4-digit barcode assigned by Formulatrix RockMaker for imaging and storage inside of the crystal incubator.",
			Category -> "Incubation", 
			Developer -> True
		},
		FormulatrixPlateID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The 3-digit plate ID assigned by Formulatrix RockMaker when this plate is stored inside of the crystal incubator.",
			Category -> "Incubation",
			Developer -> True
		}
	}
}];