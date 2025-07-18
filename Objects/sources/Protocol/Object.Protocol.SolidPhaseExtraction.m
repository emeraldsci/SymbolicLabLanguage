(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, SolidPhaseExtraction],
	{
		Description -> "A protocol for isolating a desired compound (or compounds) out from impurities using Solid Phase Extraction (SPE).",
		CreatePrivileges -> None,
		Cache -> Download,
		Fields -> {
			SampleExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ObjectP[{Object[Sample]}] | {ObjectP[Object[Sample]]..},
				Relation -> Null,
				Description -> "Samples that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},
			SampleLabel -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> (_String | Null) | {(_String | Null)..},
				Relation -> Null,
				Description -> "For each member of SampleExpression,the label of the source sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			PreFlushingSolutionLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of PreFlushingSolution, the label of the PreFlushingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> PreFlushingSolution
			},
			ConditioningSolutionLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of ConditioningSolution, the label of the ConditioningSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> ConditioningSolution
			},
			WashingSolutionLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of WashingSolution, the label of the WashingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> WashingSolution
			},
			SecondaryWashingSolutionLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SecondaryWashingSolution, the label of the SecondaryWashingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SecondaryWashingSolution
			},
			TertiaryWashingSolutionLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of TertiaryWashingSolution, the label of the TertiaryWashingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> TertiaryWashingSolution
			},
			ElutingSolutionLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of ElutingSolution, the label of the ElutingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> ElutingSolution
			},
			ContainerOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of SampleExpression, the label of the Destination container that contains SamplesOut, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},
			PreFlushingCollectionContainerOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of SampleExpression, The label of the collected PreFlushingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			ConditioningCollectionContainerOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of SampleExpression, The label of the collection container for ConditioningSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			LoadingSampleFlowthroughCollectionContainerOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of SampleExpression, The label of the collection container for LoadingSample flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			WashingCollectionContainerOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of SampleExpression, The label of the collection container for WashingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingCollectionContainerOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of SampleExpression, The label of the collection container for SecondaryWashingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingCollectionContainerOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of SampleExpression, The label of the collection container for TertiaryWashingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			ElutingCollectionContainerOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of SampleExpression,The label of the collection container for ElutingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			ContainerOut -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "All SampleOut Containers that are produced or transferred at the end of ExperimentSolidPhaseExtraction.",
				Category -> "General"
			},
			ExtractionStrategy -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[Positive, Negative],
				Description -> "For each member of SampleExpression, Strategy for SolidPhaseExtraction, where Positive means analytes of interest are adsorbed on sorbent component. Negative means that impurities adsorb onto sorbent and analytes pass through unretained.",
				Category -> "Separation",
				IndexMatching -> SampleExpression
			},
			ExtractionMode -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SeparationModeP,
				Description -> "For each member of SampleExpression, the strategy used to select the mobile phase and solid support intended to maximally separate impurities from analytes.",
				Category -> "Separation",
				IndexMatching -> SampleExpression
			},
			ExtractionSorbent -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SolidPhaseExtractionFunctionalGroupP,
				Description -> "For each member of SampleExpression, the material that adsorb analytes or impurities of interest.",
				Category -> "Separation",
				IndexMatching -> SampleExpression
			},
			ExtractionMethod -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SolidPhaseExtractionMethodP,
				Description -> "For each member of SampleExpression, the type of force that is used to flush fluid or sample through the sorbent.",
				Category -> "Separation",
				IndexMatching -> SampleExpression
			},
			ExtractionCartridge -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					(* Cartridges *)
					Model[Container, ExtractionCartridge], Object[Container, ExtractionCartridge],
					(* Spin column *)
					Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
					(* Filter Plate *)
					Model[Container, Plate, Filter], Object[Container, Plate, Filter],
					(* Syringe Filter *)
					Model[Item, ExtractionCartridge], Object[Item, ExtractionCartridge]
				],
				Description -> "For each member of SampleExpression, the sorbent-packed container that forms the stationary phase of the extraction for each sample pool.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			ExtractionCartridgeCaps -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item],
					Object[Item]
				],
				Description -> "For each member of SampleExpression, the cap consumables which cover the ExtractionCartridge used in this protocol.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			ExtractionCartridgeStorageCondition -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> (SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
				Description -> "For each member of SampleExpression, the conditions under which ExtractionCartridges used by this experiment is stored after the protocol is completed.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			ExtractionTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 * Hour],
				Units -> Hour,
				Description -> "For each member of SampleExpression, the estimated time the whole ExperimentSolidPhaseExtraction will run.",
				Category -> "General",
				Developer -> True
			},
			(* PurgePressure and Instrument are field in old SPE and they are single, Steven and I decide to make it plural and change them to multiple fields*)
			Instruments -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Instrument],
					Model[Instrument]
				],
				Description -> "For each member of SampleExpression, the Instrument that generate force to drive the fluid through the sorbent during PreFlushing, Conditioning, LoadingSample, Washing and Eluting steps.",
				Category -> "Instrument Setup",
				IndexMatching -> SampleExpression
			},
			PurgePressures -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 * PSI],
				Units -> PSI,
				Description -> "For each member of SampleExpression, the target pressure of the nitrogen gas used for pressure pushing the samples.",
				Category -> "Instrument Setup",
				IndexMatching -> SampleExpression
			},
			ExtractionTemperature -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Kelvin],
				Description -> "For each member of SampleExpression, the environmental temperature where the Instrument is set up for ExperimentSolidPhaseExtraction to be performed. The solutions' temperture can be different from ExtractionTemperature.",
				Category -> "Instrument Setup",
				IndexMatching -> SampleExpression
			},
			PreFlushing -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if sorbent should be washed with PreFlushingSolution prior to Conditioning.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			PreFlushingSolution -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation  -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
				Description -> "For each member of SampleExpression, Indicates if sorbent should be washed with PreFlushingSolution prior to Conditioning.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			PreFlushingSolutionVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Milliliter, 20 Liter], Units -> Milliliter,
				Description -> "For each member of SampleExpression, the amount of PreFlushingSolution is flushed through the sorbent to remove any residues prior to Conditioning.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			PreFlushingEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, the amount of time that PreFlushingSolution sits with the sorbent, to ensure that the sorbent's binding capacity is maximized.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			PreFlushingSolutionTemperature -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Kelvin],
				Description -> "For each member of SampleExpression, the set temperature that PreFlushingSolution is incubated for PreFlushingTemperatureEquilibrationTime before being flushed through the sorbent.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			PreFlushingSolutionTemperatureEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Description -> "For each member of SampleExpression, the amount of time that PreFlushingSolution is incubated to achieve the set PreFlushingTemperature.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			CollectPreFlushingSolution -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if the PreFlushingSolution is collected after flushed through the sorbent.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			PreFlushingSolutionDestinationWell -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> WellP,
				Description -> "For each member of SampleExpression, the positions of the containers that is used to accumulates any flow through solution in PreFlushing step.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			PreFlushingSolutionCollectionContainer -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "For each member of SampleExpression, the container that is used to accumulates any flow through solution in PreFlushing step.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			MixCollectedPreFlushingSolution -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if PreFlushingSolution that drawn through sorbent should be swirled 5 times after collected or not.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			PreFlushingSolutionDispenseRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Milliliter / Minute], Units -> Milliliter/ Minute,
				Description -> "For each member of SampleExpression, the rate at which the PreFlushingSolution is applied to the sorbent by Instrument during Preflushing step.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			PreFlushingSolutionDrainTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, the amount of time for PreFlushingSolution to be flushed through the sorbent.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			PreFlushingSolutionUntilDrained -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if PreFlushingSolution is continually flushed through the cartridge in cycle of every PreFlushingDrainTime until it is drained entirely, or until MaxPreFlushingDrainTime has been reached.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			MaxPreFlushingSolutionDrainTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, Indicates the maximum amount of time to flush PreFlushingSolution through sorbent.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			PreFlushingSolutionCentrifugeIntensity -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterEqualP[0 * RPM] | GreaterEqualP[0 * GravitationalAcceleration],
				Description -> "For each member of SampleExpression, the rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush PreFlushingSolution through the sorbent.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			PreFlushingSolutionPressure -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP | {(BooleanP | GreaterEqualP[0 * PSI] | Null)..} | GreaterEqualP[0 * PSI],
				Description -> "For each member of SampleExpression, the target pressure applied to the ExtractionCartridge to flush PreFlushingSolution through the sorbent.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			PreFlushingSolutionMixVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Microliter, 20 Liter],
				Description -> "For each member of SampleExpression, the amount of PreFlushingSolution that is pipetted up and down to mix with sorbent for PreFlushingSolutionNumberOfMixes times.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			PreFlushingSolutionNumberOfMixes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0],
				Description -> "For each member of SampleExpression, the number of times that PreFlushingSolution is pipetted up and down at the volume of PreFlushingSolutionMixVolume to mix with sorbent.",
				Category -> "PreFlush",
				IndexMatching -> SampleExpression
			},
			Conditioning -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if sorbent should be washed with ConditioningSolution prior to Conditioning.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			ConditioningSolution -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation  -> Alternatives[Object[Sample], Model[Sample]],
				Description -> "For each member of SampleExpression, Indicates if sorbent should be washed with ConditioningSolution prior to Conditioning.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			ConditioningSolutionVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Milliliter, 20 Liter], Units -> Milliliter,
				Description -> "For each member of SampleExpression, the amount of ConditioningSolution is flushed through the sorbent to remove any residues prior to Conditioning.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			ConditioningEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, the amount of time that ConditioningSolution sits with the sorbent, to ensure that the sorbent's binding capacity is maximized.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			ConditioningSolutionTemperature -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Kelvin],
				Description -> "For each member of SampleExpression, the set temperature that ConditioningSolution is incubated for ConditioningTemperatureEquilibrationTime before being flushed through the sorbent.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			ConditioningSolutionTemperatureEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Description -> "For each member of SampleExpression, the amount of time that ConditioningSolution is incubated to achieve the set ConditioningTemperature.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			CollectConditioningSolution -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if the ConditioningSolution is collected after flushed through the sorbent.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			ConditioningSolutionDestinationWell -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> WellP,
				Description -> "For each member of SampleExpression, the positions of the containers that is used to accumulates any flow through solution in Conditioning step.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			ConditioningSolutionCollectionContainer -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "For each member of SampleExpression, the container that is used to accumulates any flow through solution in Conditioning step.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			MixCollectedConditioningSolution -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if ConditioningSolution that drawn through sorbent should be swirled 5 times after collected or not.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			ConditioningSolutionDispenseRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Milliliter / Minute], Units -> Milliliter/ Minute,
				Description -> "For each member of SampleExpression, the rate at which the ConditioningSolution is applied to the sorbent by Instrument during Conditioning step.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			ConditioningSolutionDrainTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, the amount of time for ConditioningSolution to be flushed through the sorbent.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			ConditioningSolutionUntilDrained -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if ConditioningSolution is continually flushed through the cartridge in cycle of every ConditioningDrainTime until it is drained entirely, or until MaxConditioningDrainTime has been reached.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			MaxConditioningSolutionDrainTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, Indicates the maximum amount of time to flush ConditioningSolution through sorbent.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			ConditioningSolutionCentrifugeIntensity -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterEqualP[0 * RPM] | GreaterEqualP[0 * GravitationalAcceleration],
				Description -> "For each member of SampleExpression, the rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush ConditioningSolution through the sorbent.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			ConditioningSolutionPressure -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP | {(BooleanP | GreaterEqualP[0 * PSI] | Null)..} | GreaterEqualP[0 * PSI],
				Description -> "For each member of SampleExpression, the target pressure applied to the ExtractionCartridge to flush ConditioningSolution through the sorbent.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			ConditioningSolutionMixVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Microliter, 20 Liter],
				Description -> "For each member of SampleExpression, the amount of ConditioningSolution that is pipetted up and down to mix with sorbent for ConditioningSolutionNumberOfMixes times.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			ConditioningSolutionNumberOfMixes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0],
				Description -> "For each member of SampleExpression, the number of times that ConditioningSolution is pipetted up and down at the volume of ConditioningSolutionMixVolume to mix with sorbent.",
				Category -> "Equilibration",
				IndexMatching -> SampleExpression
			},
			Washing -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if sorbent should be washed with WashingSolution prior to Washing.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			WashingSolution -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation  -> Alternatives[Object[Sample], Model[Sample]],
				Description -> "For each member of SampleExpression, Indicates if sorbent should be washed with WashingSolution prior to Washing.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			WashingSolutionVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Milliliter, 20 Liter], Units -> Milliliter,
				Description -> "For each member of SampleExpression, the amount of WashingSolution is flushed through the sorbent to remove any residues prior to Washing.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			WashingEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, the amount of time that WashingSolution sits with the sorbent, to ensure that the sorbent's binding capacity is maximized.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			WashingSolutionTemperature -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Kelvin],
				Description -> "For each member of SampleExpression, the set temperature that WashingSolution is incubated for WashingTemperatureEquilibrationTime before being flushed through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			WashingSolutionTemperatureEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Description -> "For each member of SampleExpression, the amount of time that WashingSolution is incubated to achieve the set WashingTemperature.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			CollectWashingSolution -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if the WashingSolution is collected after flushed through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			WashingSolutionCollectionContainer -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "For each member of SampleExpression, the container that is used to accumulates any flow through solution in Washing step.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			MixCollectedWashingSolution -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if WashingSolution that drawn through sorbent should be swirled 5 times after collected or not.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			WashingSolutionDispenseRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Milliliter / Minute], Units -> Milliliter/ Minute,
				Description -> "For each member of SampleExpression, the rate at which the WashingSolution is applied to the sorbent by Instrument during Washing step.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			WashingSolutionDrainTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, the amount of time for WashingSolution to be flushed through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			WashingSolutionUntilDrained -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if WashingSolution is continually flushed through the cartridge in cycle of every WashingDrainTime until it is drained entirely, or until MaxWashingDrainTime has been reached.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			MaxWashingSolutionDrainTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, Indicates the maximum amount of time to flush WashingSolution through sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			WashingSolutionCentrifugeIntensity -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterEqualP[0 * RPM] | GreaterEqualP[0 * GravitationalAcceleration],
				Description -> "For each member of SampleExpression, the rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush WashingSolution through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			WashingSolutionPressure -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP | {(BooleanP | GreaterEqualP[0 * PSI] | Null)..} | GreaterEqualP[0 * PSI],
				Description -> "For each member of SampleExpression, the target pressure applied to the ExtractionCartridge to flush WashingSolution through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			WashingSolutionMixVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Microliter, 20 Liter],
				Description -> "For each member of SampleExpression, the amount of WashingSolution that is pipetted up and down to mix with sorbent for WashingSolutionNumberOfMixes times.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			WashingSolutionNumberOfMixes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0],
				Description -> "For each member of SampleExpression, the number of times that WashingSolution is pipetted up and down at the volume of WashingSolutionMixVolume to mix with sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashing -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if sorbent should be washed with SecondaryWashingSolution prior to SecondaryWashing.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSolution -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation  -> Alternatives[Object[Sample], Model[Sample]],
				Description -> "For each member of SampleExpression, Indicates if sorbent should be washed with SecondaryWashingSolution prior to SecondaryWashing.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSolutionVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Milliliter, 20 Liter], Units -> Milliliter,
				Description -> "For each member of SampleExpression, the amount of SecondaryWashingSolution is flushed through the sorbent to remove any residues prior to SecondaryWashing.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, the amount of time that SecondaryWashingSolution sits with the sorbent, to ensure that the sorbent's binding capacity is maximized.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSolutionTemperature -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Kelvin],
				Description -> "For each member of SampleExpression, the set temperature that SecondaryWashingSolution is incubated for SecondaryWashingTemperatureEquilibrationTime before being flushed through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSolutionTemperatureEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Description -> "For each member of SampleExpression, the amount of time that SecondaryWashingSolution is incubated to achieve the set SecondaryWashingTemperature.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			CollectSecondaryWashingSolution -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if the SecondaryWashingSolution is collected after flushed through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSolutionDestinationWell -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> WellP,
				Description -> "For each member of SampleExpression, the positions of the containers that is used to accumulates any flow through solution in SecondaryWashing step.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSolutionCollectionContainer -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "For each member of SampleExpression, the container that is used to accumulates any flow through solution in SecondaryWashing step.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			MixCollectedSecondaryWashingSolution -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if SecondaryWashingSolution that drawn through sorbent should be swirled 5 times after collected or not.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSolutionDispenseRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Milliliter / Minute], Units -> Milliliter/ Minute,
				Description -> "For each member of SampleExpression, the rate at which the SecondaryWashingSolution is applied to the sorbent by Instrument during SecondaryWashing step.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSolutionDrainTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, the amount of time for SecondaryWashingSolution to be flushed through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSolutionUntilDrained -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if SecondaryWashingSolution is continually flushed through the cartridge in cycle of every SecondaryWashingDrainTime until it is drained entirely, or until MaxSecondaryWashingDrainTime has been reached.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			MaxSecondaryWashingSolutionDrainTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, Indicates the maximum amount of time to flush SecondaryWashingSolution through sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSolutionCentrifugeIntensity -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterEqualP[0 * RPM] | GreaterEqualP[0 * GravitationalAcceleration],
				Description -> "For each member of SampleExpression, the rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush SecondaryWashingSolution through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSolutionPressure -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP | {(BooleanP | GreaterEqualP[0 * PSI] | Null)..} | GreaterEqualP[0 * PSI],
				Description -> "For each member of SampleExpression, the target pressure applied to the ExtractionCartridge to flush SecondaryWashingSolution through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSolutionMixVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Microliter, 20 Liter],
				Description -> "For each member of SampleExpression, the amount of SecondaryWashingSolution that is pipetted up and down to mix with sorbent for SecondaryWashingSolutionNumberOfMixes times.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSolutionNumberOfMixes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0],
				Description -> "For each member of SampleExpression, the number of times that SecondaryWashingSolution is pipetted up and down at the volume of SecondaryWashingSolutionMixVolume to mix with sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashing -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if sorbent should be washed with TertiaryWashingSolution prior to TertiaryWashing.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSolution -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation  -> Alternatives[Object[Sample], Model[Sample]],
				Description -> "For each member of SampleExpression, Indicates if sorbent should be washed with TertiaryWashingSolution prior to TertiaryWashing.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSolutionVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Milliliter, 20 Liter], Units -> Milliliter,
				Description -> "For each member of SampleExpression, the amount of TertiaryWashingSolution is flushed through the sorbent to remove any residues prior to TertiaryWashing.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, the amount of time that TertiaryWashingSolution sits with the sorbent, to ensure that the sorbent's binding capacity is maximized.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSolutionTemperature -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Kelvin],
				Description -> "For each member of SampleExpression, the set temperature that TertiaryWashingSolution is incubated for TertiaryWashingTemperatureEquilibrationTime before being flushed through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSolutionTemperatureEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Description -> "For each member of SampleExpression, the amount of time that TertiaryWashingSolution is incubated to achieve the set TertiaryWashingTemperature.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			CollectTertiaryWashingSolution -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if the TertiaryWashingSolution is collected after flushed through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSolutionDestinationWell -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> WellP,
				Description -> "For each member of SampleExpression, the positions of the containers that is used to accumulates any flow through solution in TertiaryWashing step.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSolutionCollectionContainer -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "For each member of SampleExpression, the container that is used to accumulates any flow through solution in TertiaryWashing step.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			MixCollectedTertiaryWashingSolution -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if TertiaryWashingSolution that drawn through sorbent should be swirled 5 times after collected or not.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSolutionDispenseRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Milliliter / Minute], Units -> Milliliter/ Minute,
				Description -> "For each member of SampleExpression, the rate at which the TertiaryWashingSolution is applied to the sorbent by Instrument during TertiaryWashing step.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSolutionDrainTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, the amount of time for TertiaryWashingSolution to be flushed through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSolutionUntilDrained -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if TertiaryWashingSolution is continually flushed through the cartridge in cycle of every TertiaryWashingDrainTime until it is drained entirely, or until MaxTertiaryWashingDrainTime has been reached.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			MaxTertiaryWashingSolutionDrainTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, Indicates the maximum amount of time to flush TertiaryWashingSolution through sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSolutionCentrifugeIntensity -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterEqualP[0 * RPM] | GreaterEqualP[0 * GravitationalAcceleration],
				Description -> "For each member of SampleExpression, the rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush TertiaryWashingSolution through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSolutionPressure -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP | {(BooleanP | GreaterEqualP[0 * PSI] | Null)..} | GreaterEqualP[0 * PSI],
				Description -> "For each member of SampleExpression, the target pressure applied to the ExtractionCartridge to flush TertiaryWashingSolution through the sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSolutionMixVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Microliter, 20 Liter],
				Units -> Microliter,
				Description -> "For each member of SampleExpression, the amount of TertiaryWashingSolution that is pipetted up and down to mix with sorbent for TertiaryWashingSolutionNumberOfMixes times.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSolutionNumberOfMixes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0],
				Description -> "For each member of SampleExpression, the number of times that TertiaryWashingSolution is pipetted up and down at the volume of TertiaryWashingSolutionMixVolume to mix with sorbent.",
				Category -> "Washing",
				IndexMatching -> SampleExpression
			},
			Eluting -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if sorbent should be washed with ElutingSolution prior to Eluting.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			ElutingSolution -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation  -> Alternatives[Object[Sample], Model[Sample]],
				Description -> "For each member of SampleExpression, Indicates if sorbent should be washed with ElutingSolution prior to Eluting.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			ElutingSolutionVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Milliliter, 20 Liter], Units -> Milliliter,
				Description -> "For each member of SampleExpression, the amount of ElutingSolution is flushed through the sorbent to remove any residues prior to Eluting.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			ElutingEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, the amount of time that ElutingSolution sits with the sorbent, to ensure that the sorbent's binding capacity is maximized.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			ElutingSolutionTemperature -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Kelvin],
				Units -> Celsius,
				Description -> "For each member of SampleExpression, the set temperature that ElutingSolution is incubated for ElutingTemperatureEquilibrationTime before being flushed through the sorbent.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			ElutingSolutionTemperatureEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, the amount of time that ElutingSolution is incubated to achieve the set ElutingTemperature.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			CollectElutingSolution -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if the ElutingSolution is collected after flushed through the sorbent.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			ElutingSolutionDestinationWell -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> WellP,
				Description -> "For each member of SampleExpression, the positions of the containers that is used to accumulates any flow through solution in Eluting step.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			ElutingSolutionCollectionContainer -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "For each member of SampleExpression, the container that is used to accumulates any flow through solution in Eluting step.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			MixCollectedElutingSolution -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if ElutingSolution that drawn through sorbent should be swirled 5 times after collected or not.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			ElutingSolutionDispenseRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Milliliter / Minute], Units -> Milliliter/ Minute,
				Description -> "For each member of SampleExpression, the rate at which the ElutingSolution is applied to the sorbent by Instrument during Eluting step.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			ElutingSolutionDrainTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, the amount of time for ElutingSolution to be flushed through the sorbent.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			ElutingSolutionUntilDrained -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if ElutingSolution is continually flushed through the cartridge in cycle of every ElutingDrainTime until it is drained entirely, or until MaxElutingDrainTime has been reached.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			MaxElutingSolutionDrainTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, Indicates the maximum amount of time to flush ElutingSolution through sorbent.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			ElutingSolutionCentrifugeIntensity -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterEqualP[0 * RPM] | GreaterEqualP[0 * GravitationalAcceleration],
				Description -> "For each member of SampleExpression, the rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush ElutingSolution through the sorbent.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			ElutingSolutionPressure -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP | {(BooleanP | GreaterEqualP[0 * PSI] | Null)..} | GreaterEqualP[0 * PSI],
				Description -> "For each member of SampleExpression, the target pressure applied to the ExtractionCartridge to flush ElutingSolution through the sorbent.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			ElutingSolutionMixVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Microliter, 20 Liter],
				Units -> Microliter,
				Description -> "For each member of SampleExpression, the amount of ElutingSolution that is pipetted up and down to mix with sorbent for ElutingSolutionNumberOfMixes times.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			ElutingSolutionNumberOfMixes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0],
				Description -> "For each member of SampleExpression, the number of times that ElutingSolution is pipetted up and down at the volume of ElutingSolutionMixVolume to mix with sorbent.",
				Category -> "Elution",
				IndexMatching -> SampleExpression
			},
			LoadingSampleVolume -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> RangeP[0 * Milliliter, 20 Liter] | {RangeP[0 * Milliliter, 20 Liter]..},
				Description -> "For each member of SampleExpression, the amount of LoadingSample is flushed through the sorbent to remove any residues prior to LoadingSample.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			QuantitativeLoadingSample -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP | {BooleanP..},
				Description -> "For each member of SampleExpression, Indicates if each individual sample source containers are rinsed with QuantitativeLoadingSampleSolution, and then that rinsed solution is applied into the sorbent to help ensure that all SampleIn is transferred to the sorbent.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			QuantitativeLoadingSampleSolution -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Sample], Model[Sample]],
				Description -> "For each member of SampleExpression, Solution that is used to rinse each individual sample source containers to ensure that all SampleIn is transferred to the sorbent.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			QuantitativeLoadingSampleVolume -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0 Milliliter] | {GreaterEqualP[0 Milliliter]..} | {Null..},
				Description -> "For each member of SampleExpression, the amount of QuantitativeLoadingSampleSolution to added and rinsed source container of each individual sample to ensure that all SampleIn is transferred to the sorbent.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			LoadingSampleEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, the amount of time that LoadingSample sits with the sorbent, to ensure that the sorbent's binding capacity is maximized.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			LoadingSampleTemperature -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0 Kelvin] | {(GreaterEqualP[0 Kelvin] | Null)..},
				Description -> "For each member of SampleExpression, the set temperature that LoadingSample is incubated for LoadingSampleTemperatureEquilibrationTime before being flushed through the sorbent.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			LoadingSampleTemperatureEquilibrationTime -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0 Minute] | {(GreaterEqualP[0 Minute] | Null)..},
				Description -> "For each member of SampleExpression, the amount of time that LoadingSample is incubated to achieve the set LoadingSampleTemperature.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			CollectLoadingSampleFlowthrough -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if the LoadingSample is collected after flushed through the sorbent.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			LoadingSampleFlowthroughContainerDestinationWell -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> WellP,
				Description -> "For each member of SampleExpression, the positions of the containers that is used to accumulates any flow through solution in LoadingSample step.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			LoadingSampleFlowthroughContainer -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "For each member of SampleExpression, the container that is used to accumulates any flow through solution in LoadingSample step.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			MixLoadingSampleFlowthrough -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if LoadingSample that drawn through sorbent should be swirled 5 times after collected or not.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			LoadingSampleDispenseRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Milliliter / Minute], Units -> Milliliter/ Minute,
				Units -> Milliliter / Minute,
				Description -> "For each member of SampleExpression, the rate at which the LoadingSample is applied to the sorbent by Instrument during LoadingSample step.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			LoadingSampleDrainTime -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> (GreaterEqualP[0 Minute] | Null) | {(GreaterEqualP[0 Minute] | Null)..},
				Description -> "For each member of SampleExpression, the amount of time for LoadingSample to be flushed through the sorbent.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			LoadingSampleUntilDrained -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SampleExpression, Indicates if LoadingSample is continually flushed through the cartridge in cycle of every LoadingSampleDrainTime until it is drained entirely, or until MaxLoadingSampleDrainTime has been reached.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			MaxLoadingSampleDrainTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Minute,
				Description -> "For each member of SampleExpression, Indicates the maximum amount of time to flush LoadingSample through sorbent.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			LoadingSampleCentrifugeIntensity -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterEqualP[0 * RPM] | GreaterEqualP[0 * GravitationalAcceleration],
				Description -> "For each member of SampleExpression, the rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush LoadingSample through the sorbent.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			LoadingSamplePressure -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP | {(BooleanP | GreaterEqualP[0 * PSI] | Null)..} | GreaterEqualP[0 * PSI],
				Description -> "For each member of SampleExpression, the
				Units -> PSI, target pressure applied to the ExtractionCartridge to flush LoadingSample through the sorbent.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			LoadingSampleMixVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Microliter, 20 Liter],
				Units -> Microliter,
				Description -> "For each member of SampleExpression, the amount of LoadingSample that is pipetted up and down to mix with sorbent for LoadingSampleNumberOfMixes times.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			LoadingSampleNumberOfMixes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0],
				Description -> "For each member of SampleExpression, the number of times that LoadingSample is pipetted up and down at the volume of LoadingSampleMixVolume to mix with sorbent.",
				Category -> "Loading",
				IndexMatching -> SampleExpression
			},
			(* output *)
(*			SamplesOut -> {*)
(*				Format -> Multiple,*)
(*				Class -> Link,*)
(*				Pattern :> _Link,*)
(*				Relation -> Alternatives[Object[Sample], Model[Sample]],*)
(*				Description -> "All Samples that are produced or transferred at the end of ExperimentSolidPhaseExtraction.",*)
(*				Category -> "General"*)
(*			},*)
			SampleOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleExpression, the label of the SamplesOut that are in the Destination, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},
			PreFlushingSampleOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleExpression, the label of the PreFlushing SamplesOut that are in the Destination, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			ConditioningSampleOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleExpression, the label of the Conditioning SamplesOut that are in the Destination, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			LoadingSampleFlowthroughSampleOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleExpression, the label of the LoadingSampleFlowthrough SamplesOut that are in the Destination, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			WashingSampleOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleExpression, the label of the Washing SamplesOut that are in the Destination, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSampleOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleExpression, the label of the SecondaryWashing SamplesOut that are in the Destination, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSampleOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleExpression, the label of the TertiaryWashing SamplesOut that are in the Destination, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			ElutingSampleOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleExpression, the label of the Eluting SamplesOut that are in the Destination, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			PreFlushingContainerDestinationWell -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> _String | WellPositionP | _?NumericQ | WellP,
				Description -> "For each member of SampleExpression, Indicate the location of wells that PreFlushingSampleOut will go into.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			ConditioningContainerDestinationWell -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> _String | WellPositionP | _?NumericQ | WellP,
				Description -> "For each member of SampleExpression, Indicate the location of wells that ConditioningSampleOut will go into.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			WashingContainerDestinationWell -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> _String | WellPositionP | _?NumericQ | WellP,
				Description -> "For each member of SampleExpression, Indicate the location of wells that WashingSampleOut will go into.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingContainerDestinationWell -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> _String | WellPositionP | _?NumericQ | WellP,
				Description -> "For each member of SampleExpression, Indicate the location of wells that SecondaryWashingSampleOut will go into.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingContainerDestinationWell -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> _String | WellPositionP | _?NumericQ | WellP,
				Description -> "For each member of SampleExpression, Indicate the location of wells that TertiaryWashingSampleOut will go into.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			ElutingContainerDestinationWell -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> _String | WellPositionP | _?NumericQ | WellP,
				Description -> "For each member of SampleExpression, Indicate the location of wells that ElutingSampleOut will go into.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			PreFlushingSampleOut -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample][Protocols],
					Model[Sample]
				],
				Description -> "For each member of SampleExpression, all of samples that are produced or transferred during PreFlushing step of ExperimentSolidPhaseExtraction.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			ConditioningSampleOut -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample][Protocols],
					Model[Sample]
				],
				Description -> "For each member of SampleExpression, all of samples that are produced or transferred during Conditioning step of ExperimentSolidPhaseExtraction.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			LoadingSampleFlowthroughSampleOut -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample][Protocols],
					Model[Sample]
				],
				Description -> "For each member of SampleExpression, all of samples that are produced or transferred during LoadingSample step of ExperimentSolidPhaseExtraction.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			WashingSampleOut -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample][Protocols],
					Model[Sample]
				],
				Description -> "For each member of SampleExpression, all of samples that are produced or transferred during Washing step of ExperimentSolidPhaseExtraction.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSampleOut -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample][Protocols],
					Model[Sample]
				],
				Description -> "For each member of SampleExpression, all of samples that are produced or transferred during SecondaryWashing step of ExperimentSolidPhaseExtraction.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSampleOut -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample][Protocols],
					Model[Sample]
				],
				Description -> "For each member of SampleExpression, all of samples that are produced or transferred during TertiaryWashing step of ExperimentSolidPhaseExtraction.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},
			ElutingSampleOut -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample][Protocols],
					Model[Sample]
				],
				Description -> "For each member of SampleExpression, all of samples that are produced or transferred during Eluting step of ExperimentSolidPhaseExtraction.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},

			(* Batching *)
			SPEBatchID -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleExpression, the batch identification number in which SolidPhaseExtraction will be performed.",
				Category -> "General",
				IndexMatching -> SampleExpression
			},

			(* aliquot fields *)
			(* these aliquot options will all be flat and then pool later with qliquot length and poollengths *)
			AliquotContainer -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Container],Object[Container]],
				Description -> "A container that samples are aliquoted into prior to Solid Phase Extraction.",
				Category -> "Separation"
			},
			AliquotContainerLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "A label of container that samples are aliquoted into AliquotContainer prior to Solid Phase Extraction.",
				Category -> "Separation"
			},
			AliquotSampleLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "A label of samples are aliquoted into AliquotContainer prior to Solid Phase Extraction.",
				Category -> "Sample Preparation"
			},
			AliquotWellDestination -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> WellPositionP,
				Description -> "A well position in AliquotContainer that samples are aliquoted into AliquotContainer prior to Solid Phase Extraction.",
				Category -> "Sample Preparation"
			},
			AliquotVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 Milliliter, 20 Liter],
				Units -> Milliliter,
				Description -> "Volume of samples that are aliquoted into AliquotWellDestination in AliquotContainer prior to Solid Phase Extraction.",
				Category -> "Sample Preparation"
			},
			AliquotLength -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> {GreaterEqualP[0]..} | {Null..} | GreaterEqualP[0],
				Description -> "For each member of SamplesIn, Parameters describing the length of aliquot for each samples.",
				Category -> "Sample Preparation",
				IndexMatching -> SamplesIn
			},
			TransferSamplesInUnitOperation -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SamplePreparationP | {SamplePreparationP..} | {Null..},
				Description -> "A set of instructions specifying the preparation of SamplesIn to appropriate container.",
				Category -> "Sample Preparation"
			},
			TransferSamplesInManipulation -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Protocol],
					Object[Notebook, Script]
				],
				Description -> "A SamplePreparation protocol that is used to aliquot SamplesIn to appropriate container.",
				Category -> "Sample Preparation"
			},
			(*		FilterProtocol - {*)
			(*			Format -> Multiple,*)
			(*			Class -> Link,*)
			(*			Pattern :> _Link,*)
			(*			Relation -> Alternatives[Object[Protocol,Filter],Object[Protocol,ManualSamplePreparation]],*)
			(*			Description -> "For each member of SampleExpression, A protocol used to centrifuge the samples in preparation for Solid Phase Extraction.",*)
			(*			Category -> "Separation"*)
			(*		},*)
			(* GX271 specific fields *)
(*			LiquidHandlerFilePath -> {*)
(*				Format -> Single,*)
(*				Class -> String,*)
(*				Pattern :> FilePathP,*)
(*				Description -> "For each member of SampleExpression, the TSL filepath that corresponds to the file that runs this protocol.",*)
(*				Category -> "Instrument Setup",*)
(*				Developer -> True*)
(*			},*)
(*			LiquidHandlerFile -> {*)
(*				Format -> Single,*)
(*				Class -> Link,*)
(*				Pattern :> _Link,*)
(*				Relation -> Object[EmeraldCloudFile],*)
(*				Description -> "For each member of SampleExpression, the TSL file containing the instructions for the liquid handler that performs the SPE.",*)
(*				Category -> "Instrument Setup",*)
(*				Developer -> True*)
(*			},*)
			PrimingSolution -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
				Description -> "For each member of SampleExpression, the solution that is used to prime the pump of GX271 liquid handler.",
				Category -> "Instrument Setup",
				IndexMatching -> SampleExpression,
				Developer -> True
			},
			PreFlushingSolutionContainerPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the PreFlushing solution bottle on the GX-271 liquid handler deck.",
				Headers -> {"PreFLushing Solution", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			ConditioningSolutionContainerPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the Conditioning solution bottle on the GX-271 liquid handler deck.",
				Headers -> {"Conditioning Solution", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			WashingSolutionContainerPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the Washing solution bottle on the GX-271 liquid handler deck.",
				Headers -> {"Washing Solution", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			SecondaryWashingSolutionContainerPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the SecondaryWashing solution bottle on the GX-271 liquid handler deck.",
				Headers -> {"SecondaryWashing Solution", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			TertiaryWashingSolutionContainerPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the TertiaryWashing solution bottle on the GX-271 liquid handler deck.",
				Headers -> {"TertiaryWashing Solution", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			QuantitativeLoadingSolutionContainerPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..} | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the QuantitativeLoading solution bottle on the GX-271 liquid handler deck.",
				Headers -> {"QuantitativeLoading Solution", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			PrimingSolutionContainerPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the pump priming solution bottle on the GX-271 liquid handler deck.",
				Headers -> {"Priming Solution", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			ElutingSolutionContainerPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the Eluting solution bottle on the GX-271 liquid handler deck.",
				Headers -> {"Eluting Solution", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			ExtractionCartridgePlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..} | _?NumberQ},
				Relation -> {Object[Item] | Object[Container] | Model[Container] | Model[Item], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the cartridges on the liquid handler deck.",
				Headers -> {"Cartridge", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			PreFlushingContainerOutPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the PreFlushing solution collection container on the liquid handler deck.",
				Headers -> {"PreFlushing ContainerOut", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			ConditioningContainerOutPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the Conditioning solution collection container on the liquid handler deck.",
				Headers -> {"Conditioning ContainerOut", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			WashingContainerOutPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the Washing solution collection container on the liquid handler deck.",
				Headers -> {"Washing ContainerOut", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			SecondaryWashingContainerOutPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the SecondaryWashing solution collection container on the liquid handler deck.",
				Headers -> {"SecondaryWashing ContainerOut", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			TertiaryWashingContainerOutPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the TertiaryWashing solution collection container on the liquid handler deck.",
				Headers -> {"TertiaryWashing ContainerOut", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			LoadingSampleFlowthroughContainerOutPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the LoadingSampleFlowthrough collection container on the liquid handler deck.",
				Headers -> {"LoadingSampleFlowthrough ContainerOut", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			ElutingContainerOutPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "For each member of SampleExpression, A list of deck placements used for placing the Eluting solution collection container on the liquid handler deck.",
				Headers -> {"Eluting ContainerOut", "Placement"},
				Category -> "Placements",
				Developer -> True,
				IndexMatching -> SampleExpression
			},
			(* TODO - use this version when you are ready to merge*)
(*			SamplePlacements -> {*)
(*				Format -> Multiple,*)
(*				Class -> {Link, Expression},*)
(*				Pattern :> {_Link, {LocationPositionP..} | LocationPositionP | _String | {_String..}},*)
(*				Relation -> {Object[Sample] | Object[Container], Null},*)
(*				Description -> "For each member of SampleExpression, A list of deck placements used for placing the sample plate on the liquid handler deck.",*)
(*				Headers -> {"Sample", "Placement"},*)
(*				Category -> "Placements",*)
(*				Developer -> True,*)
(*				IndexMatching -> SampleExpression*)
(*			},*)
			WasteContainer -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container] | Model[Container],
				Description -> "The container used for simulation.",
				Category -> "Sample Preparation",
				Developer -> True
			},
			SampleOutLabelToObjectRules -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {_String, ObjectReferenceP[]}..,
				Description -> "The rule for sample out label, to the actual object.",
				Category -> "Sample Preparation",
				Developer -> True
			},

			(* Old SPE fields to make it backward compatible *)
			(* TODO - delete all this once we are ready to merge *)
			SPECartridges -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "The disposable Solid Phase Extraction (SPE) cartridge used for each sample to separate out the desired compound.",
				Category -> "Sample Preparation"
			},
			ExtractionType->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SeparationModeP,
				Description -> "The type of Extraction being performed.",
				Category -> "Model Information"
			},
			CartridgeCaps -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item],
					Object[Item]
				],
				Description -> "The cap consumables which cover the SPE cartridges used in this protocol.",
				Category -> "Sample Preparation"
			},
			MixProtocols -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Protocol,Incubate],Object[Protocol,ManualSamplePreparation]],
				Description -> "A protocol used to mix the samples in preparation for Solid Phase Extraction.",
				Category -> "Sample Preparation"
			},
			CentrifugeProtocols -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Protocol,Centrifuge],Object[Protocol,ManualSamplePreparation]],
				Description -> "A protocol used to centrifuge the samples in preparation for Solid Phase Extraction.",
				Category -> "Sample Preparation"
			},
			Instrument -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Instrument],
					Model[Instrument]
				],
				Description -> "The liquid handling instrument used to perform the extraction.",
				Category -> "Instrument Setup"
			},
			PurgePressure -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0*PSI],
				Units -> PSI,
				Description -> "The target pressure of the nitrogen gas used for pressure pushing the samples.",
				Category -> "Instrument Setup"
			},
			CollectionPlate -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Container],Model[Container]],
				Description -> "The plate into which the samples are eluted during the protocol.",
				Category -> "Experimental Results"
			},
			LiquidHandlerFilePath -> {
				Format -> Single,
				Class -> String,
				Pattern :> FilePathP,
				Description -> "The TSL filepath that corresponds to the file that runs this protocol.",
				Category -> "Instrument Setup",
				Developer -> True
			},
			LiquidHandlerFile -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "The TSL file containing the instructions for the liquid handler that performs the SPE.",
				Category -> "Instrument Setup",
				Developer->True
			},
			BufferPlacements ->{
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..}},
				Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
				Description -> "A list of deck placements used for placing the wash buffer bottle on the liquid handler deck.",
				Headers->{"Wash Buffer","Placement"},
				Category -> "Placements",
				Developer -> True
			},
			CartridgePlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..}},
				Relation -> {Object[Item] |  Object[Container], Null},
				Description -> "A list of deck placements used for placing the cartridges on the liquid handler deck.",
				Headers->{"Cartridge","Placement"},
				Category -> "Placements",
				Developer -> True
			},
			CollectionPlatePlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..}},
				Relation -> {Object[Sample] | Object[Container] | Model[Container], Null},
				Description -> "A list of deck placements used for placing the collection plate on the liquid handler deck.",
				Headers->{"Collection Plate","Placement"},
				Category -> "Placements",
				Developer -> True
			},
			PreFlushBuffer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description -> "The buffer used in this protocol to flush through the SPE cartridges to wash the sorbent and remove any residues prior to start of the protocol.",
				Category -> "PreFlush"
			},
			PreFlushVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Milli*Liter],
				Units -> Liter Milli,
				Description -> "For each member of SPECartridges, the rate at which the PreFlushBuffer are loaded onto that cartridges.",
				Category -> "PreFlush",
				IndexMatching->SPECartridges
			},
			PreFlushRates -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[(0*(Liter*Milli))/Minute],
				Units -> (Liter Milli)/Minute,
				Description -> "For each member of SPECartridges, the rate at which the PreFlushBuffer flows through the cartridge during the pre-flush step.",
				Category -> "PreFlush",
				IndexMatching->SPECartridges
			},
			EquilibrationBuffer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description -> "The buffer used in this protocol to equilibrate the SPE cartridges.",
				Category -> "Equilibration"
			},
			EquilibrationVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Milli*Liter],
				Units -> Liter Milli,
				Description -> "For each member of SPECartridges, the amounts of equilibration buffer with which the cartridges are equilibrated prior to sample loading.",
				Category -> "Equilibration",
				IndexMatching->SPECartridges
			},
			EquilibrationRates -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[(0*(Liter*Milli))/Minute],
				Units -> (Liter Milli)/Minute,
				Description -> "For each member of SPECartridges, the rates at which the equilibration buffer flows through the cartridges during the equilibration step.",
				Category -> "Equilibration",
				IndexMatching->SPECartridges
			},
			SampleVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Milli*Liter],
				Units -> Liter Milli,
				Description -> "For each member of SamplesIn, the volume of the sample injected into the cartridge for extraction.",
				Category -> "Loading",
				IndexMatching->SamplesIn
			},
			SampleLoadRates -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[(0*(Liter*Milli))/Minute],
				Units -> (Liter Milli)/Minute,
				Description -> "For each member of SamplesIn, the rate at which the sample is loaded onto the cartridges.",
				Category -> "Loading",
				IndexMatching->SamplesIn
			},
			RinseAndReloads -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SamplesIn, indicates whether the sample source well is rinsed with equilibration buffer and reloaded to the cartridge to improve recovery.",
				Category -> "Loading",
				IndexMatching->SamplesIn
			},
			RinseVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Milli*Liter],
				Units -> Liter Milli,
				Description -> "For each member of SamplesIn, the volume of equilibration buffer used to rinse the source well after sample loading.",
				Category -> "Loading",
				IndexMatching->SamplesIn
			},
			WashBuffer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description -> "The buffer used in this protocol to wash the cartridge after sample loading to elute any impurities from the samples prior to elution.",
				Category -> "Washing"
			},
			WashVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Milli*Liter],
				Units -> Liter Milli,
				Description -> "For each member of SPECartridges, the volume of wash buffer with which each cartridge is rinsed after loading the samples.",
				Category -> "Washing",
				IndexMatching->SPECartridges
			},
			WashRates -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[(0*(Liter*Milli))/Minute],
				Units -> (Liter Milli)/Minute,
				Description -> "For each member of SPECartridges, the rate at which the wash buffer flows through the cartridge during the wash step.",
				Category -> "Washing",
				IndexMatching->SPECartridges
			},
			ElutionBuffer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description -> "The buffer used in this protocol to elute the purified compound from the cartridges.",
				Category -> "Elution"
			},
			ElutionVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Milli*Liter],
				Units -> Liter Milli,
				Description -> "For each member of SPECartridges, the volume of elution buffer used to elute each sample during the collection step.",
				Category -> "Elution",
				Abstract -> True,
				IndexMatching->SPECartridges
			},
			NumberOfElutions -> {
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0],
				Description->"Number of times the ElutionBuffer should be added to the cartridge.",
				Category -> "Elution",
				Developer->True
			},
			ElutionRates -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[(0*(Liter*Milli))/Minute],
				Units -> (Liter Milli)/Minute,
				Description -> "For each member of SPECartridges, the rate at which the elution buffer flows through the cartridge during the elution step.",
				Category -> "Elution",
				IndexMatching->SPECartridges
			},
			PoolLengths -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterEqualP[0],
				Description -> "For each member of SampleExpression, Parameters describing the length of each pool of samples.",
				Category -> "Pooling",
				IndexMatching -> SampleExpression
			},
			PurgePressureLog -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Protocol],
				Description -> "The pressure log for the nitrogen gas connected to the solid phase extraction.",
				Category -> "Sensor Information",
				Developer -> True
			},
			InitialPurgePressure -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Protocol],
				Description -> "The pressure data of the nitrogen gas connected to the solid phase extraction before starting the run.",
				Category -> "Sensor Information",
				Developer -> True
			},
			WasteWeightData -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Protocol],
				Description -> "The weight data of the waste carboy installed on the instrument taken before starting the run.",
				Category -> "Sensor Information",
				Developer -> True
			},
			SamplePlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..}},
				Relation -> {Object[Sample] | Object[Container], Null},
				Description -> "A list of deck placements used for placing the sample plate on the liquid handler deck.",
				Headers->{"Sample","Placement"},
				Category -> "Placements",
				Developer -> True
			},
			ProcessRecording -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "A video recording taken during the entire robotic execution of this protocol.",
				Category -> "Instrument Specifications"
			},
			ProtocolKey ->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The ID of the protocol used to create a directory for output files.",
				Category->"General",
				Developer->True
			},
		    VideoFilePaths->{
			    Format->Multiple,
			    Class->String,
			    Pattern:>FilePathP,
			    Description->"For each protocol, the file paths of the video files generated from experiment run.",
			    Category->"General"
		    },
		    VideoFolderName->{
		        Format->Single,
		        Class->String,
		        Pattern:>FilePathP,
		        Description->"For each protocol, the folder name that will be generated for the videos to be saved in.",
		        Category->"General"
		    }
	}}];
