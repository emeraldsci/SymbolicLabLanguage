(* ::Package:: *)
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)
DefineObjectType[Object[UnitOperation, GrowCrystal], {
	Description -> "The information that specifies the information of how to prepare crystallization plate containing sample solution, and to set up incubation and imaging schedule of the prepared crystallization plate to monitor the growth of the sample crystals for X-ray diffraction (XRD).", 
	CreatePrivileges -> None, 
	Cache -> Session, 
	Fields -> {
		(* Sample-related fields *)
		SampleLink -> {
			Format -> Multiple, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Alternatives[
				Object[Sample], 
				Model[Sample], 
				Object[Container], 
				Model[Container]
			], 
			Description -> "Sample, such as target protein, peptide, nucleic acid or water soluble small molecule, to be crystallized in this experiment.",
			Category -> "General", 
			Migration -> SplitField
		}, 
		SampleString -> {
			Format -> Multiple, 
			Class -> String, 
			Pattern :> _String, 
			Relation -> Null, 
			Description -> "Sample, such as target protein, peptide, nucleic acid or water soluble small molecule, to be crystallized in this experiment.",
			Category -> "General", 
			Migration -> SplitField
		}, 
		SampleExpression -> {
			Format -> Multiple, 
			Class -> Expression, 
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}] | _String}, 
			Relation -> Null, 
			Description -> "Sample, such as target protein, peptide, nucleic acid or water soluble small molecule, to be crystallized in this experiment.",
			Category -> "General", 
			Migration -> SplitField
		},
		(*===General Information===*)
		PreparedPlate -> {
			Format -> Single, 
			Class -> Boolean, 
			Pattern :> BooleanP, 
			Description -> "Indicates if the plate containing the samples for crystallization experiment has been previously transferred with samples and reagents and does not need to run sample preparation step to construct the crystallization plate.",
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
		CrystallizationPlateLink -> {
			Format -> Single, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Alternatives[Model[Container], Object[Container]], 
			Description -> "The container that the input sample and other reagents that are transferred into. After the container is constructed by pipetting, it is incubated and imaged to monitor the growth of crystals of the input sample.", 
			Category -> "General", 
			Migration -> SplitField
		}, 
		CrystallizationPlateString -> {
			Format -> Single, 
			Class -> String, 
			Pattern :> _String, 
			Description -> "The container that the input sample and other reagents that are transferred into. After the container is constructed by pipetting, it is incubated and imaged to monitor the growth of crystals of the input sample.", 
			Category -> "General", 
			Migration -> SplitField
		}, 
		CrystallizationPlateLabel -> {
			Format -> Single, 
			Class -> String, 
			Pattern :> _String, 
			Description -> "A user defined word or phrase used to identify the CrystallizationPlate that the input sample and other reagents that are transferred into and incubated and imaged to monitor the growth of crystals of the input sample, for use in downstream unit operations.", 
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
		DropDestination -> {
			Format -> Multiple, 
			Class -> Expression, 
			Pattern :>  {CrystallizationWellContentsP..},
			Description -> "For each member of SampleLink, the desired location of DropSamplesOut on the plate.", 
			Category -> "General", 
			IndexMatching -> SampleLink
		}, 
		CrystallizationScreeningMethodLink -> {
			Format -> Multiple, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Object[Method, CrystallizationScreening], 
			Description -> "For each member of SampleLink, the file containing a set of reagents is used to construct a crystallization plate for screening crystal conditions of the input sample.", 
			Category -> "General", 
			IndexMatching -> SampleLink, 
			Migration -> SplitField
		}, 
		CrystallizationScreeningMethodExpression -> {
			Format -> Multiple, 
			Class -> Expression, 
			Pattern :> Alternatives[None, Custom], 
			Description -> "For each member of SampleLink, the file containing a set of reagents is used to construct a crystallization plate for screening crystal conditions of the input sample.", 
			Category -> "General", 
			IndexMatching -> SampleLink, 
			Migration -> SplitField
		},
		(*===Sample Preparation Information===*)
		PreMixBuffer -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if various type of buffers (including DilutionBuffer, ReservoirBuffers, unevaporated CoCrystallizationReagents, Additives, SeedingSolution) should be premixed. The purpose of premixing is to reduce the total transfer time when these buffers are being transferred to CrystallizationPlate as part of the drop setting step of sample preparation. Once these buffers are premixed, they are added to the drop wells of CrystallizationPlate.",
			Category -> "Sample Preparation"
		},
		SampleVolumes -> {
			Format -> Multiple, 
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Nanoliter]..},
			Description -> "For each member of SampleLink, the amount of the input sample that is transferred into the drop well of CrystallizationPlate. When there are multiple SampleVolumes provided, the member of SampleLink at each SampleVolume is combined with other buffers such as DilutionBuffer, ReservoirBuffer, Additive, CoCrystallizationReagent, and SeedingSolution. These combinations are then transferred in a multiplexed manner to create a unique drop composition for each well.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
		}, 
		ReservoirBuffers -> {
			Format -> Multiple, 
			Class -> Expression, 
			Pattern :> {Alternatives[ObjectP[{Model[Sample], Object[Sample]}], _String]..}|None, 
			Description -> "For each member of SampleLink, the cocktail solution which contains high concentration of precipitants, salts and pH buffers. When there are multiple ReservoirBuffers provided for the member of SamplesIn, each ReservoirBuffer is combined with other buffers such as DilutionBuffer, Additive, CoCrystallizationReagent, and SeedingSolution. These combinations are then transferred in a multiplexed manner to create a unique drop composition for each well.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
		},
		ReservoirDropVolume -> {
			Format -> Multiple, 
			Class -> Real, 
			Pattern :> VolumeP, 
			Units -> Nanoliter, 
			Description -> "For each member of SampleLink, the amount of ReservoirBuffer that is transferred into the drop well of CrystallizationPlate during the drop setting step of sample preparation to mix with the input sample.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
		}, 
		ReservoirBufferVolume -> {
			Format -> Multiple, 
			Class -> Real, 
			Pattern :> VolumeP, 
			Units -> Nanoliter, 
			Description -> "For each member of SampleLink, the amount of ReservoirBuffer that is transferred into the reservoir well of CrystallizationPlate during the reservoir filling step of sample preparation to facilitate the crystallization in wells that sharing headspace with the reservoir well.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
		},
		DilutionBufferLink -> {
			Format -> Multiple, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Alternatives[Model[Sample], Object[Sample]], 
			Description -> "For each member of SampleLink, the solution to bring the concentration of the input sample down by transferring into the drop well of CrystallizationPlate during the drop setting step of sample preparation.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink, 
			Migration -> SplitField
		}, 
		DilutionBufferExpression -> {
			Format -> Multiple, 
			Class -> Expression, 
			Pattern :> None, 
			Description -> "For each member of SampleLink, the solution to bring the concentration of the input sample down by transferring into the drop well of CrystallizationPlate during the drop setting step of sample preparation.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink, 
			Migration -> SplitField
		}, 
		DilutionBufferVolume -> {
			Format -> Multiple, 
			Class -> Real, 
			Pattern :> VolumeP, 
			Units -> Nanoliter, 
			Description -> "For each member of SampleLink, the amount of Buffer that is transferred into the drop well of CrystallizationPlate to bring down the concentration of the input sample during the drop setting step of sample preparation.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
		}, 
		Additives -> {
			Format -> Multiple, 
			Class -> Expression, 
			Pattern :> {Alternatives[ObjectP[{Model[Sample], Object[Sample]}], _String]..}|None, 
			Description -> "For each member of SampleLink, the solution that is transferred into the drop well of CrystallizationPlate to change the solubility of the input sample during the drop setting step of sample preparation. When there are multiple Additives provided for the member of SampleLink, each Additive is combined with other buffers such as DilutionBuffer, ReservoirBuffer, CoCrystallizationReagent, and SeedingSolution. These combinations are then transferred in a multiplexed manner to create a unique drop composition for each well.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
		},
		AdditiveVolume -> {
			Format -> Multiple, 
			Class -> Real, 
			Pattern :> VolumeP, 
			Units -> Nanoliter, 
			Description -> "For each member of SampleLink, the amount of Additive that is transferred into the drop well of CrystallizationPlate during the drop setting step of sample preparation.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
		}, 
		CoCrystallizationReagents -> {
			Format -> Multiple, 
			Class -> Expression, 
			Pattern :> {Alternatives[ObjectP[{Model[Sample], Object[Sample]}], _String]..}|None, 
			Description -> "For each member of SampleLink, the solution that is transferred into the drop well of CrystallizationPlate containing compounds that solidify together with the input sample during the drop setting step of sample preparation if CoCrystallizationAirDry is False or before the reservoir filling step of sample preparation if CoCrystallizationAirDry is True. When there are multiple CoCrystallizationReagents provided for the member of SampleLink, each CoCrystallizationReagent is combined with other buffers such as DilutionBuffer, ReservoirBuffer, Additive, and SeedingSolution. These combinations are then transferred in a multiplexed manner to create a unique drop composition for each well.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
		},
		CoCrystallizationReagentVolume -> {
			Format -> Multiple, 
			Class -> Real, 
			Pattern :> VolumeP, 
			Units -> Nanoliter, 
			Description -> "For each member of SampleLink, the amount of CoCrystallizationReagent that is transferred into the drop well of CrystallizationPlate containing compounds in the attempt to solidify together with the input sample in a crystal form during the drop setting step of sample preparation if CoCrystallizationAirDry is False or before the reservoir filling step of sample preparation if CoCrystallizationAirDry is True.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
		}, 
		CoCrystallizationAirDry -> {
			Format -> Multiple, 
			Class -> Boolean, 
			Pattern :> BooleanP, 
			Description -> "For each member of SampleLink, the boolean indicates if the CoCrystallizationReagents are added to an empty crystallization plate and fully evaporated prior to filling the reservoir well and drop well of the crystallization plate.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
		}, 
		CoCrystallizationAirDryTime -> {
			Format -> Single,
			Class -> Real, 
			Pattern :> GreaterEqualP[0 Hour], 
			Units -> Hour, 
			Description -> "The length of time for which the CoCrystallizationReagents are held inside the fume hood to allow the solvent to be fully evaporated from the crystallization plate prior to filling the reservoir well and drop well of the crystallization plate.",
			Category -> "Sample Preparation"
		}, 
		CoCrystallizationAirDryTemperatureReal -> {
			Format -> Single,
			Class -> Real, 
			Units -> Celsius, 
			Pattern :> GreaterEqualP[0 Kelvin], 
			Description -> "The temperature for which the CoCrystallizationReagents are held inside the FumeHood or on HeatBlock of LiquidHandler to allow the solvent to be fully evaporated from the crystallization plate prior to filling the reservoir well and drop well of the crystallization plate.",
			Category -> "Sample Preparation",
			Migration -> SplitField
		}, 
		CoCrystallizationAirDryTemperatureExpression -> {
			Format -> Single, 
			Class -> Expression, 
			Pattern :> Alternatives[Ambient], 
			Description -> "The temperature for which the CoCrystallizationReagents are held inside the FumeHood or on HeatBlock of LiquidHandler to allow the solvent to be fully evaporated from the crystallization plate prior to filling the reservoir well and drop well of the crystallization plate.",
			Category -> "Sample Preparation",
			Migration -> SplitField
		},
		SeedingSolutionLink -> {
			Format -> Multiple, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Alternatives[Model[Sample], Object[Sample]], 
			Description -> "For each member of SampleLink, the solution that is transferred into the drop well of CrystallizationPlate containing micro crystals of the input sample that serves as nucleates to facilitate crystallization during the drop setting step of sample preparation.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink, 
			Migration -> SplitField
		}, 
		SeedingSolutionExpression -> {
			Format -> Multiple, 
			Class -> Expression, 
			Pattern :> None, 
			Description -> "For each member of SampleLink, the solution that is transferred into the drop well of CrystallizationPlate containing micro crystals of the input sample that serves as nucleates to facilitate crystallization during the drop setting step of sample preparation.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink, 
			Migration -> SplitField
		}, 
		SeedingSolutionVolume -> {
			Format -> Multiple, 
			Class -> Real, 
			Pattern :> VolumeP, 
			Units -> Nanoliter, 
			Description -> "For each member of SampleLink, the amount of SeedingSolution that is transferred into the drop well of CrystallizationPlate containing micro crystals of the input sample that serves as nucleates to facilitate crystallization during the drop setting step of sample preparation.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
		},
		Oil -> {
			Format -> Multiple, 
			Class -> Link, 
			Pattern :> _Link, 
			Relation -> Alternatives[Model[Sample], Object[Sample]], 
			Description -> "For each member of SampleLink, the fluid that is dispensed to cover the droplet containing sample and other reagents (DilutionBuffer, PrimaryAdditive, SecondaryAdditive, ReservoirBuffer, CoCrystallizationReagent) to control the evaporation of water after the drop setting step of sample preparation.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
		}, 
		OilVolume -> {
			Format -> Multiple, 
			Class -> Real, 
			Pattern :> VolumeP, 
			Units -> Microliter, 
			Description -> "For each member of SampleLink, the amount of Oil that is dispensed to cover the droplet containing sample and other reagents (DilutionBuffer, PrimaryAdditive, SecondaryAdditive, ReservoirBuffer, CoCrystallizationReagent)  that slows down evaporation after the drop setting step of sample preparation.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
		},
		DropSamplesOutLabel -> {
			Format -> Multiple, 
			Class -> Expression, 
			Pattern :> ({_String...}|Null), 
			Description -> "For each member of SampleLink, the label of the output sample in drop wells that contains the given sample as well as a specific combination of reagents such as DilutionBuffer, ReservoirBuffer, Additive, CoCrystallizationReagent, SeedingSolution and Oil, which is used for identification elsewhere in sample preparation.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
		}, 
		ReservoirSamplesOutLabel -> {
			Format -> Multiple, 
			Class -> Expression, 
			Pattern :> ({_String...}|Null), 
			Description -> "For each member of SampleLink, the label of the output sample in reservoir wells that contains high concentration of precipitants, salts and pH buffers for the purpose of driving supersaturation of DropSamplesOut in SittingDropVaporDiffusion plate configuration.", 
			Category -> "Sample Preparation", 
			IndexMatching -> SampleLink
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
		(*===Incubation Information===*)
		MaxCrystallizationTime -> {
			Format -> Single, 
			Class -> Real, 
			Pattern :> GreaterEqualP[0 Day], 
			Units -> Day, 
			Description -> "The max length of time for which the sample is held inside the crystal incubator to allow the growth of the crystals.", 
			Category -> "Incubation"
		}
	}
}];