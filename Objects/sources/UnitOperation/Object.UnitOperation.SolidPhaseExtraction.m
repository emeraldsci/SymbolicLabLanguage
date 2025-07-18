(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: Nont.Kosaisawe *)
(* :Date: 2021-11-01 *)

DefineObjectType[Object[UnitOperation, SolidPhaseExtraction], {
	Description -> "A detailed set of parameters that specifies the information of how to SolidPhaseExtraction when a sample and ExtractionCartrige is given.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* input *)
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "The SampleIn that is going through sorbent to be purified.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The SampleIn that is going through sorbent to be purified.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ObjectP[{Object[Container], Object[Sample], Model[Sample]}]..} | {_String..},
			Relation -> Null,
			Description -> "The SampleIn that is going through sorbent to be purified.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleResource -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "The SampleIn that is going through sorbent to be purified.",
			Category -> "General"
		},
		(* This is either Sample or the corresponding WorkingSamples after aliquoting etc. *)
		WorkingSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of SampleExpression, the samples to be filtered after any aliquoting, if applicable.",
			Category -> "General",
			Developer -> True
		},
		WorkingContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "For each member of SampleExpression, the containers holding the samples to be filtered after any aliquoting, if applicable.",
			Category -> "General",
			Developer -> True
		},
		(* label for simulation *)
		SampleLabel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (_String | Null) | {(_String | Null)..},
			Relation -> Null,
			Description -> "For each member of SampleExpression, the label of the source sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		SourceContainerLabel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (_String | Null) | {(_String | Null)..},
			Relation -> Null,
			Description -> "For each member of SampleExpression, the label of the samples' container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		PreFlushingSolutionLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleExpression, the label of the PreFlushingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		ConditioningSolutionLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleExpression, the label of the ConditioningSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		WashingSolutionLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleExpression, the label of the WashingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		SecondaryWashingSolutionLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleExpression, the label of the SecondaryWashingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		TertiaryWashingSolutionLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleExpression, the label of the TertiaryWashingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		ElutingSolutionLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleExpression, the label of the ElutingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		(* output object *)
		SamplesOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "All Samples that are produced or transferred at the end of ExperimentSolidPhaseExtraction.",
			Category -> "General"
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
		PreFlushingSampleOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SampleExpression, all of samples that are produced or transferred during PreFlushing step of ExperimentSolidPhaseExtraction.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		ConditioningSampleOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SampleExpression, all of samples that are produced or transferred during Conditioning step of ExperimentSolidPhaseExtraction.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		LoadingSampleFlowthroughSampleOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SampleExpression, all of samples that are produced or transferred during LoadingSample step of ExperimentSolidPhaseExtraction.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		WashingSampleOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SampleExpression, all of samples that are produced or transferred during Washing step of ExperimentSolidPhaseExtraction.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		SecondaryWashingSampleOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SampleExpression, all of samples that are produced or transferred during SecondaryWashing step of ExperimentSolidPhaseExtraction.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		TertiaryWashingSampleOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SampleExpression, all of samples that are produced or transferred during TertiaryWashing step of ExperimentSolidPhaseExtraction.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		ElutingSampleOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SampleExpression, all of samples that are produced or transferred during Eluting step of ExperimentSolidPhaseExtraction.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		(* output label *)
		SampleOutLabel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (_String | Null) | {(_String | Null)..},
			Relation -> Null,
			Description -> "The label of the SamplesOut that are in the Destination, which is used for identification elsewhere in sample preparation.",
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
		ContainerOutLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			(*TODO*)
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
		ContainerOutWellAssignment -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _String | WellPositionP | _?NumericQ | WellP,
			Description -> "For each member of SampleExpression, Indicate the location of wells that SampleOut will go into.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		(* general extraction description *)
		ExtractionStrategy -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Positive, Negative],
			Description -> "For each member of SampleExpression, the strategy that will use to extract analytes from impurities.",
			Category -> "Separation",
			IndexMatching -> SampleExpression
		},
		ExtractionMode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SeparationModeP,
			Description -> "For each member of SampleExpression, chemical mechanism that is used to separate impurities from analytes.",
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
			Description -> "For each member of SampleExpression, sorbent-packed container that forms the stationary phase of the extraction.",
			Category -> "Separation",
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
			Description -> "For each member of SampleExpression, the cap consumables which cover the ExtractionCartridge.",
			Category -> "Separation",
			IndexMatching -> SampleExpression
		},
		ExtractionCartridgeLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			(*TODO*)
			Description -> "For each member of SampleExpression, the label of ExtractionCartridge that pooled samples will be purified on.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		Instrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Pipette], Object[Instrument, Pipette],
				(* For Gilson GX271 and Hamilton LiquidHandler*)
				Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler],
				(* For Hamilton MPE2 and Biotage 48+ *)
				Model[Instrument, PressureManifold], Object[Instrument, PressureManifold],
				(* For Centrifuge *)
				Model[Instrument, Centrifuge], Object[Instrument, Centrifuge],
				(* For Vacuum manifold (cartridge) *)
				Model[Instrument, VacuumManifold], Object[Instrument, VacuumManifold],
				(* For Plate vacuum manifold *)
				Model[Instrument, FilterBlock], Object[Instrument, FilterBlock],
				(* For Syringe pump *)
				Model[Instrument, SyringePump], Object[Instrument, SyringePump]
			],
			Description -> "For each member of SampleExpression, the instrument that generate force to drive the fluid through the sorbent.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		ExtractionMethod -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SolidPhaseExtractionMethodP,
			Description -> "For each member of SampleExpression, The type of force that is generated to flush sample through the sorbent.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		ExtractionTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[-5 * Celsius, 40 * Celsius],
			Units -> Celsius,
			Description -> "For each member of SampleExpression, the environmental temperature in real value at which the extraction instrument is setup for solid phase extraction.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		ExtractionTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "For each member of SampleExpression, the environmental temperature (if it's ambient) the extraction instrument is setup for solid phase extraction.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		ExtractionCartridgeStorageConditionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP | Disposal,
			Description -> "For each member of SampleExpression, The conditions under which ExtractionCartridges used by this experiment is stored after the protocol is completed.",
			Category -> "General",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ExtractionCartridgeStorageConditionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "For each member of SampleExpression, The conditions under which ExtractionCartridges used by this experiment is stored after the protocol is completed.",
			Category -> "General",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		(* PreFlushing *)
		PreFlushing -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if sorbent should be washed with PreFlushingSolution prior to Conditioning.",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression
		},
		PreFlushingSolutionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectReferenceP[],
			Description -> "For each member of SampleExpression, the solution that is used to wash the sorbent clean of any residues from manufacturing or storage processes, prior to Conditioning.",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		PreFlushingSolutionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, the solution that is used to wash the sorbent clean of any residues from manufacturing or storage processes, prior to Conditioning.",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		PreFlushingSolutionString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleExpression, the solution that is used to wash the sorbent clean of any residues from manufacturing or storage processes, prior to Conditioning.",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		PreFlushingSolutionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milliliter] | Null,
			Units -> Milliliter,
			Description -> "For each member of SampleExpression, the amount of PreFlushingSolution is flushed through the sorbent to remove any residues prior to Conditioning.",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression
		},
		PreFlushingSolutionTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin] | Null,
			Units -> Celsius,
			Description -> "For each member of SampleExpression, The set temperature that PreFlushingSolution is incubated for PreFlushingTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of PreFlushingSolution is assumed to equilibrate with the set PreFlushingSolutionTemperature.",
			Category -> "PreFlush",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		PreFlushingSolutionTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient, {(Ambient | GreaterEqualP[0 Kelvin] | Null)..}],
			Description -> "For each member of SampleExpression, The set temperature that PreFlushingSolution is incubated for PreFlushingTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of PreFlushingSolution is assumed to equilibrate with the set PreFlushingSolutionTemperature.",
			Category -> "PreFlush",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		PreFlushingSolutionTemperatureEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time that PreFlushingSolution is incubated to achieve the set PreFlushingTemperature. The final temperature of PreFlushingSolution is assumed to equilibrate with the set PreFlushingTemperature.",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression
		},
		PreFlushingEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time that PreFlushingSolution sits with the sorbent, to ensure that the sorbent's is cleaned of contaminants.",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression
		},
		CollectPreFlushingSolution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression,Indicates if the PreFlushingSolution is collected after flushed through the sorbent.",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression
		},
		PreFlushingSolutionCollectionContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectReferenceP[] | Null | _String)..} | ObjectReferenceP[] | _String,
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in PreFlushing step. The collected volume might be less than PreFlushingSolutionVolume because some of PreFlushingSolution left in cartridge (the solution is not purd through the sorbent).",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		PreFlushingSolutionCollectionContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in PreFlushing step. The collected volume might be less than PreFlushingSolutionVolume because some of PreFlushingSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		PreFlushingSolutionCollectionContainerResource -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in PreFlushing step. The collected volume might be less than PreFlushingSolutionVolume because some of PreFlushingSolution left in cartridge (the solution is not purged through the sorbent).",
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
			Pattern :> GreaterEqualP[0 Milliliter / Minute],
			Units -> Milliliter / Minute,
			Description -> "For each member of SampleExpression, The rate at which the PreFlushingSolution is applied to the sorbent by Instrument during Preflushing step.",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression
		},
		PreFlushingSolutionDrainTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute] | Null,
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time for PreFlushingSolution to be flushed through the sorbent. If PreFlushingSolutionUntilDrained is set to True, then PreFlushingSolution is continually flushed through the ExtractionCartridge in cycle of PreFlushingSolutionDrainTime until it is drained entirely. If PreFlushingSolutionUntilDrained is set to False, then PreFlushingSolution is flushed through ExtractionCartridge for PreFlushingSolutionDrainTime once.",
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
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, Indicates the maximum amount of time to flush PreFlushingSolution through sorbent. PreFlushingSolution is flushed in cycles of PreFlushingDrainTime until either PreFlushingSolution is entirely drained or MaxPreFlushingDrainTime has been reached.",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression
		},
		PreFlushingSolutionCentrifugeIntensity -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 * RPM] | GreaterEqualP[0 * GravitationalAcceleration],
			Description -> "For each member of SampleExpression,The rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush PreFlushingSolution through the sorbent.",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression
		},
		PreFlushingSolutionPressureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * PSI],
			Units -> PSI,
			Description -> "For each member of SampleExpression, The target pressure applied to the ExtractionCartridge to flush PreFlushingSolution through the sorbent. If Instrument is MPE2, the PreFlushingSolutionPressure is set to be LoadingSamplePressure (Pressure of MPE2 cannot be changed while the Experiment is running).",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		PreFlushingSolutionPressureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, The target pressure applied to the ExtractionCartridge to flush PreFlushingSolution through the sorbent. If Instrument is MPE2, the PreFlushingSolutionPressure is set to be LoadingSamplePressure (Pressure of MPE2 cannot be changed while the Experiment is running).",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		PreFlushingSolutionMixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Milliliter,
			Description -> "For each member of SampleExpression, The amount of PreFlushingSolution that is pipetted up and down to mix with sorbent for PreFlushingSolutionNumberOfMixes times.",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression
		},
		PreFlushingSolutionNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression, The number of times that PreFlushingSolution is pipetted up and down at the volume of PreFlushingSolutionPipetteMixVolume to mix with sorbent.",
			Category -> "PreFlush",
			IndexMatching -> SampleExpression
		},
		(* Conditioning *)
		Conditioning -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if sorbent is equilibrate with ConditioningSolution in order to chemically prepare the sorbent to bind either to analytes if ExtractionStrategy is Positive, or to impurities if ExtractionStrategy is Negative.",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression
		},
		ConditioningSolutionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectReferenceP[],
			Description -> "For each member of SampleExpression, The solution that is flushed through the sorbent in order to chemically prepare the sorbent to bind either to analytes if ExtractionStrategy is Positive, or to impurities if ExtractionStrategy is Negative.",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ConditioningSolutionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The solution that is flushed through the sorbent in order to chemically prepare the sorbent to bind either to analytes if ExtractionStrategy is Positive, or to impurities if ExtractionStrategy is Negative.",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ConditioningSolutionString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleExpression, The solution that is flushed through the sorbent in order to chemically prepare the sorbent to bind either to analytes if ExtractionStrategy is Positive, or to impurities if ExtractionStrategy is Negative.",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ConditioningSolutionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milliliter] | Null,
			Units -> Milliliter,
			Description -> "For each member of SampleExpression, The amount of ConditioningSolution that is flushed through the sorbent to chemically prepare it to bind either analytes if ExtractionStrategy is Positive, or impurities if ExtractionStrategy is Negative.",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression
		},
		ConditioningSolutionTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin] | Null,
			Units -> Celsius,
			Description -> "For each member of SampleExpression,The set temperature that ConditioningSolution is incubated for ConditioningSolutionTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of ConditioningSolution is assumed to equilibrate with the set ConditioningSolutionTemperature.",
			Category -> "Equilibration",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		ConditioningSolutionTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient, {(Ambient | GreaterEqualP[0 Kelvin] | Null)..}],
			Description -> "For each member of SampleExpression, The set temperature that ConditioningSolution is incubated for ConditioningSolutionTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of ConditioningSolution is assumed to equilibrate with the set ConditioningSolutionTemperature.",
			Category -> "Equilibration",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		ConditioningSolutionTemperatureEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time that ConditioningSolution is incubated to achieve the set ConditioningSolutionTemperature. The final temperature of ConditioningSolution is assumed to equilibrate with the set ConditioningSolutionTemperature.",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression
		},
		ConditioningEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time that ConditioningSolution sits with the sorbent, to ensure that the sorbent's binding capacity is maximized.",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression
		},
		CollectConditioningSolution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if the ConditioningSolution is collected and saved after flushing through the sorbent.",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression
		},
		ConditioningSolutionCollectionContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectReferenceP[] | Null | _String)..} | ObjectReferenceP[] | _String,
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in Conditioning step. The collected volume might be less than ConditioningSolutionVolume because some of ConditioningSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ConditioningSolutionCollectionContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in Conditioning step. The collected volume might be less than ConditioningSolutionVolume because some of ConditioningSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ConditioningSolutionCollectionContainerResource -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in Conditioning step. The collected volume might be less than ConditioningSolutionVolume because some of ConditioningSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		MixCollectedConditioningSolution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression,Indicates if ConditioningSolution that drawn through sorbent should be swirled 5 times after collected or not.",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression
		},
		ConditioningSolutionDispenseRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter / Minute],
			Units -> (Milliliter / Minute),
			Description -> "For each member of SampleExpression, The rate at which the ConditioningSolution is applied to the sorbent by Instrument during Conditioning step.",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression
		},
		ConditioningSolutionDrainTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute] | Null,
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time for ConditioningSolution to be flushed through the sorbent. If ConditioningSolutionUntilDrained is set to True, then ConditioningSolution is continually flushed through the ExtractionCartridge in cycle of ConditioningSolutionDrainTime until it is drained entirely. If ConditioningSolutionUntilDrained is set to False, then ConditioningSolution is flushed through ExtractionCartridge for ConditioningSolutionDrainTime once.",
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
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, Indicates the maximum amount of time to flush ConditioningSolution through sorbent. ConditioningSolution is flushed in cycles of ConditioningDrainTime until either ConditioningSolution is entirely drained or MaxConditioningDrainTime has been reached.",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression
		},
		ConditioningSolutionCentrifugeIntensity -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 * RPM] | GreaterEqualP[0 * GravitationalAcceleration],
			Description -> "For each member of SampleExpression,The rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush ConditioningSolution through the sorbent.",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression
		},
		ConditioningSolutionPressureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * PSI],
			Units -> PSI,
			Description -> "For each member of SampleExpression,The target pressure applied to the ExtractionCartridge to flush ConditioningSolution through the sorbent. If Instrument is MPE2, the ConditioningSolutionPressure is set to be LoadingSamplePressure (Pressure of MPE2 cannot be changed while the Experiment is running).",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ConditioningSolutionPressureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression,The target pressure applied to the ExtractionCartridge to flush ConditioningSolution through the sorbent. If Instrument is MPE2, the ConditioningSolutionPressure is set to be LoadingSamplePressure (Pressure of MPE2 cannot be changed while the Experiment is running).",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ConditioningSolutionMixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Milliliter,
			Description -> "For each member of SampleExpression,The amount of ConditioningSolution that is pipetted up and down to mix with sorbent for ConditioningSolutionNumberOfMixes times.",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression
		},
		ConditioningSolutionNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression,The number of times that ConditioningSolution is pipetted up and down at the volume of ConditioningSolutionPipetteMixVolume to mix with sorbent.",
			Category -> "Equilibration",
			IndexMatching -> SampleExpression
		},
		(*LoadingSample*)
		(*		LoadingSampleVolumeReal -> {*)
		(*			Format -> Multiple,*)
		(*			Class -> Real,*)
		(*			Pattern :> GreaterEqualP[0 Milliliter],*)
		(*			Units -> Milliliter,*)
		(*			Description -> "For each member of SampleExpression,The amount of each individual input sample that is applied into the sorbent. LoadingSampleVolume is set to All, then all of pooled sample will be loaded in to ExtractionCartridge. If multiple samples are included in the same pool, individual samples are loaded sequentially.",*)
		(*			Category -> "Loading",*)
		(*			IndexMatching -> SampleExpression,*)
		(*			Migration -> SplitField*)
		(*		},*)
		LoadingSampleVolume -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[All, {(GreaterEqualP[0 Milliliter] | All)..}, GreaterEqualP[0 Milliliter]],
			Description -> "For each member of SampleExpression, The amount of each individual input sample that is applied into the sorbent. LoadingSampleVolume is set to All, then all of pooled sample will be loaded in to ExtractionCartridge. If multiple samples are included in the same pool, individual samples are loaded sequentially.",
			Category -> "Loading",
			IndexMatching -> SampleExpression
		},
		QuantitativeLoadingSample -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP | {BooleanP..},
			Description -> "For each member of SampleExpression, Indicates if each individual sample source containers are rinsed with ConditioningSolution, and then that rinsed solution is applied into the sorbent to help ensure that all SampleIn is transferred to the sorbent. Only applies when LoadingSampleVolume is set to All.",
			Category -> "Loading",
			IndexMatching -> SampleExpression
		},
		QuantitativeLoadingSampleVolume -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GreaterEqualP[0 Milliliter] | {(GreaterEqualP[0 Milliliter] | Null)..},
			Description -> "For each member of SampleExpression, The amount of ConditioningSolution to added and rinsed source container of each individual sample to ensure that all SampleIn is transferred to the sorbent.",
			Category -> "Loading",
			IndexMatching -> SampleExpression
		},
		QuantitativeLoadingSampleSolutionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectReferenceP[] | Null | _String)..} | ObjectReferenceP[] | _String,
			Description -> "For each member of SampleExpression, the solution that is used to rinse each individual sample source containers to ensure that all SampleIn is transferred to the sorbent.",
			Category -> "Loading",
			Migration -> SplitField
		},
		QuantitativeLoadingSampleSolutionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "The solution that is used to rinse each individual sample source containers to ensure that all SampleIn is transferred to the sorbent.",
			Category -> "Loading",
			Migration -> SplitField
		},
		LoadingSampleTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleExpression, The set temperature that individual SampleIn is incubated for LoadingSampleTemperatureEquilibrationTime before being loaded into the sorbent.",
			Category -> "Loading",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		LoadingSampleTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Ambient | {(Ambient | GreaterEqualP[0 Kelvin] | Null)..},
			Description -> "For each member of SampleExpression, The set temperature that individual SampleIn is incubated for LoadingSampleTemperatureEquilibrationTime before being loaded into the sorbent.",
			Category -> "Loading",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		LoadingSampleTemperatureEquilibrationTime -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (GreaterEqualP[0 Minute] | Null) | {(GreaterEqualP[0 Minute] | Null)..},
			Description -> "For each member of SampleExpression, The amount of time that individual samples are incubated at LoadingSampleTemperature.",
			Category -> "Loading",
			IndexMatching -> SampleExpression
		},
		LoadingSampleEquilibrationTime -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (GreaterEqualP[0 Minute] | Null) | {(GreaterEqualP[0 Minute] | Null)..},
			Description -> "For each member of SampleExpression, The minimum amount of time that loaded pooled sample sits with the sorbent before it is drained to ensure maximal binding between sorbent and analytes in Positive ExtractionStrategy or between sorbent and impurities in Negative ExtractionStrategy.",
			Category -> "Loading",
			IndexMatching -> SampleExpression
		},
		CollectLoadingSampleFlowthrough -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if the any material that exit the sorbent is collected while sample is being loaded into the sorbent.",
			Category -> "Loading",
			IndexMatching -> SampleExpression
		},
		LoadingSampleFlowthroughContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectReferenceP[] | Null | _String)..} | ObjectReferenceP[] | _String,
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in LoadingSample step. The collected volume might be less than LoadingSampleVolume because some of Sample left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Loading",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		LoadingSampleFlowthroughContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in LoadingSample step. The collected volume might be less than LoadingSampleVolume because some of Sample left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Loading",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		MixLoadingSampleFlowthrough -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP | {BooleanP..},
			Description -> "For each member of SampleExpression, Indicates if sample flowthrough that drawn through sorbent is swirled 5 times after collected or not.",
			Category -> "Loading",
			IndexMatching -> SampleExpression
		},
		LoadingSampleDispenseRate -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (GreaterEqualP[0 Milliliter / Minute] | Null) | {(GreaterEqualP[0 Milliliter / Minute] | Null) ..},
			Description -> "For each member of SampleExpression, The rate at which individual samples are dispensed into the sorbent during sample loading.",
			Category -> "Loading",
			IndexMatching -> SampleExpression
		},
		LoadingSampleDrainTime -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (GreaterEqualP[0 Minute] | Null) | {(GreaterEqualP[0 Minute] | Null)..},
			Description -> "For each member of SampleExpression, The amount of time that the sample is flushed through the sorbent after sample loading.",
			Category -> "Loading",
			IndexMatching -> SampleExpression
		},
		LoadingSampleUntilDrained -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if the sample is continually flushed through the cartridge in cycle of LoadingSampleDrainTime until it is drained entirely, or until MaxSampleDrainTime has been reached.",
			Category -> "Loading",
			IndexMatching -> SampleExpression
		},
		MaxLoadingSampleDrainTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression,Indicates the maximum amount of time to flush the sample through sorbent. Sample is flushed in cycles of LoadingSampleDrainTime until either LoadingSampleVolume is entirely drained or MaxLoadingSampleDrainTime has been reached.",
			Category -> "Loading",
			IndexMatching -> SampleExpression
		},
		LoadingSampleCentrifugeIntensity -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 * RPM] | GreaterEqualP[0 * GravitationalAcceleration],
			Description -> "For each member of SampleExpression, The rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush LoadingSample through the sorbent.",
			Category -> "Loading",
			IndexMatching -> SampleExpression
		},
		LoadingSamplePressureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * PSI],
			Units -> PSI,
			Description -> "For each member of SampleExpression,The target pressure applied to the ExtractionCartridge to flush pooled SampleIn through the sorbent. If Instrument is MPE2, the LoadingSamplePressure applies to PreFlushingSolutionPressure, ConditioningSolutionPressure, WashingSolutionPressure and ElutingSolutionPressure as well (Pressure of MPE2 cannot be changed while the Experiment is running).",
			Category -> "Loading",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		LoadingSamplePressureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression,The target pressure applied to the ExtractionCartridge to flush pooled SampleIn through the sorbent. If Instrument is MPE2, the LoadingSamplePressure applies to PreFlushingSolutionPressure, ConditioningSolutionPressure, WashingSolutionPressure and ElutingSolutionPressure as well (Pressure of MPE2 cannot be changed while the Experiment is running).",
			Category -> "Loading",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		LoadingSampleMixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Milliliter,
			Description -> "For each member of SampleExpression, The amount of pooled SampleIn that is pipetted up and down to mix with sorbent for SampleNumberOfMixes times.",
			Category -> "Loading",
			IndexMatching -> SampleExpression
		},
		LoadingSampleNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression, The number of times that the LoadingSamplePipetteVolume pipetted up and down to mix sample with sorbent.",
			Category -> "Loading",
			IndexMatching -> SampleExpression
		},
		(*Washing*)
		Washing -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if analyte-bound-sorbent is flushed with WashingSolution to get rid non-specific binding and and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		WashingSolutionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectReferenceP[],
			Description -> "For each member of SampleExpression, The solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		WashingSolutionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Model[Container], Object[Container]],
			Description -> "For each member of SampleExpression, The solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		WashingSolutionString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleExpression, The solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		WashingSolutionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SampleExpression, The amount of WashingSolution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		WashingSolutionTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleExpression, The set temperature that WashingSolution is incubated for WashingSolutionTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of WashingSolution is assumed to equilibrate with the set WashingSolutionTemperature.",
			Category -> "Washing",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		WashingSolutionTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient, {(Ambient | GreaterEqualP[0 Kelvin] | Null)..}],
			Description -> "For each member of SampleExpression, The set temperature that WashingSolution is incubated for WashingSolutionTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of WashingSolution is assumed to equilibrate with the set WashingSolutionTemperature.",
			Category -> "Washing",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		WashingSolutionTemperatureEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time that WashingSolution is incubated to achieve the set WashingSolutionTemperature. The final temperature of WashingSolution is assumed to equilibrate with the set WashingSolutionTemperature.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		WashingEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time that WashingSolution sits with the analyte-bound-sorbent, to ensure non-specific binding is removed from sorbent.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		CollectWashingSolution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if the WashingSolution is collected and saved after flushing through the sorbent.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		WashingSolutionCollectionContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectReferenceP[] | Null | _String)..} | ObjectReferenceP[] | _String,
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in Washing step. The collected volume might be less than WashingSolutionVolume because some of WashingSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		WashingSolutionCollectionContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in Washing step. The collected volume might be less than WashingSolutionVolume because some of WashingSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		WashingSolutionCollectionContainerResource -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in Washing step. The collected volume might be less than WashingSolutionVolume because some of WashingSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		MixCollectedWashingSolution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if WashingSolution that flushed through sorbent is swirled 5 times after collected or not.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		WashingSolutionDispenseRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter / Minute],
			Units -> (Milliliter / Minute),
			Description -> "For each member of SampleExpression, The rate at which the WashingSolution is applied to the sorbent by Instrument during Conditioning step.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		WashingSolutionDrainTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time for WashingSolution to be flushed through the sorbent. If WashingSolutionUntilDrained is set to True, then WashingSolution is continually flushed through the ExtractionCartridge in cycle of WashingSolutionDrainTime until it is drained entirely. If WashingSolutionUntilDrained is set to False, then WashingSolution is flushed through ExtractionCartridge for WashingSolutionDrainTime once.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		WashingSolutionUntilDrained -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if WashingSolution is continually flushed through the cartridge in cycle of every ConditioningDrainTime until it is drained entirely, or until MaxConditioningDrainTime has been reached.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		MaxWashingSolutionDrainTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, Indicates the maximum amount of time to flush WashingSolution through sorbent. WashingSolution is flushed in cycles of ConditioningDrainTime until either WashingSolution is entirely drained or MaxConditioningDrainTime has been reached.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		WashingSolutionCentrifugeIntensity -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 * RPM] | GreaterEqualP[0 * GravitationalAcceleration],
			Description -> "For each member of SampleExpression, The rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush WashingSolution through the sorbent.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		WashingSolutionPressureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * PSI],
			Units -> PSI,
			Description -> "For each member of SampleExpression, The target pressure applied to the ExtractionCartridge to flush WashingSolution through the sorbent. If Instrument is MPE2, the WashingSolutionPressure is set to be LoadingSamplePressure (Pressure of MPE2 cannot be changed while the Experiment is running).",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		WashingSolutionPressureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, The target pressure applied to the ExtractionCartridge to flush WashingSolution through the sorbent. If Instrument is MPE2, the WashingSolutionPressure is set to be LoadingSamplePressure (Pressure of MPE2 cannot be changed while the Experiment is running).",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		WashingSolutionMixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Milliliter,
			Description -> "For each member of SampleExpression, The amount of WashingSolution that is pipetted up and down to mix with sorbent for WashingSolutionNumberOfMixes times.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		WashingSolutionNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression, The number of times that WashingSolution is pipetted up and down at the volume of WashingSolutionPipetteMixVolume to mix with sorbent.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		(*SecondaryWashing*)
		SecondaryWashing -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if analyte-bound-sorbent is flushed with SecondaryWashingSolution to get rid non-specific binding and and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		SecondaryWashingSolutionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectReferenceP[],
			Description -> "For each member of SampleExpression, The solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		SecondaryWashingSolutionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Model[Container], Object[Container]],
			Description -> "For each member of SampleExpression, The solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		SecondaryWashingSolutionString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleExpression, The solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		SecondaryWashingSolutionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SampleExpression, The amount of SecondaryWashingSolution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		SecondaryWashingSolutionTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleExpression, The set temperature that SecondaryWashingSolution is incubated for SecondaryWashingSolutionTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of SecondaryWashingSolution is assumed to equilibrate with the set SecondaryWashingSolutionTemperature.",
			Category -> "Washing",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		SecondaryWashingSolutionTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient, {(Ambient | GreaterEqualP[0 Kelvin] | Null)..}],
			Description -> "For each member of SampleExpression, The set temperature that SecondaryWashingSolution is incubated for SecondaryWashingSolutionTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of SecondaryWashingSolution is assumed to equilibrate with the set SecondaryWashingSolutionTemperature.",
			Category -> "Washing",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		SecondaryWashingSolutionTemperatureEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time that SecondaryWashingSolution is incubated to achieve the set SecondaryWashingSolutionTemperature. The final temperature of SecondaryWashingSolution is assumed to equilibrate with the set SecondaryWashingSolutionTemperature.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		SecondaryWashingEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time that SecondaryWashingSolution sits with the analyte-bound-sorbent, to ensure non-specific binding is removed from sorbent.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		CollectSecondaryWashingSolution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if the SecondaryWashingSolution is collected and saved after flushing through the sorbent.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		SecondaryWashingSolutionCollectionContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectReferenceP[] | Null | _String)..} | ObjectReferenceP[] | _String,
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in SecondaryWashing step. The collected volume might be less than SecondaryWashingSolutionVolume because some of SecondaryWashingSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		SecondaryWashingSolutionCollectionContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in SecondaryWashing step. The collected volume might be less than SecondaryWashingSolutionVolume because some of SecondaryWashingSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		SecondaryWashingSolutionCollectionContainerResource -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in SecondaryWashing step. The collected volume might be less than SecondaryWashingSolutionVolume because some of SecondaryWashingSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		MixCollectedSecondaryWashingSolution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if SecondaryWashingSolution that flushed through sorbent is swirled 5 times after collected or not.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		SecondaryWashingSolutionDispenseRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter / Minute],
			Units -> (Milliliter / Minute),
			Description -> "For each member of SampleExpression, The rate at which the SecondaryWashingSolution is applied to the sorbent by Instrument during Conditioning step.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		SecondaryWashingSolutionDrainTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time for SecondaryWashingSolution to be flushed through the sorbent. If SecondaryWashingSolutionUntilDrained is set to True, then SecondaryWashingSolution is continually flushed through the ExtractionCartridge in cycle of SecondaryWashingSolutionDrainTime until it is drained entirely. If SecondaryWashingSolutionUntilDrained is set to False, then SecondaryWashingSolution is flushed through ExtractionCartridge for SecondaryWashingSolutionDrainTime once.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		SecondaryWashingSolutionUntilDrained -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if SecondaryWashingSolution is continually flushed through the cartridge in cycle of every ConditioningDrainTime until it is drained entirely, or until MaxConditioningDrainTime has been reached.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		MaxSecondaryWashingSolutionDrainTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, Indicates the maximum amount of time to flush SecondaryWashingSolution through sorbent. SecondaryWashingSolution is flushed in cycles of ConditioningDrainTime until either SecondaryWashingSolution is entirely drained or MaxConditioningDrainTime has been reached.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		SecondaryWashingSolutionCentrifugeIntensity -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 * RPM] | GreaterEqualP[0 * GravitationalAcceleration],
			Description -> "For each member of SampleExpression, The rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush SecondaryWashingSolution through the sorbent.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		SecondaryWashingSolutionPressureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * PSI],
			Units -> PSI,
			Description -> "For each member of SampleExpression, The target pressure applied to the ExtractionCartridge to flush SecondaryWashingSolution through the sorbent. If Instrument is MPE2, the SecondaryWashingSolutionPressure is set to be LoadingSamplePressure (Pressure of MPE2 cannot be changed while the Experiment is running).",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		SecondaryWashingSolutionPressureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, The target pressure applied to the ExtractionCartridge to flush SecondaryWashingSolution through the sorbent. If Instrument is MPE2, the SecondaryWashingSolutionPressure is set to be LoadingSamplePressure (Pressure of MPE2 cannot be changed while the Experiment is running).",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		SecondaryWashingSolutionMixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Milliliter,
			Description -> "For each member of SampleExpression, The amount of SecondaryWashingSolution that is pipetted up and down to mix with sorbent for SecondaryWashingSolutionNumberOfMixes times.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		SecondaryWashingSolutionNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression, The number of times that SecondaryWashingSolution is pipetted up and down at the volume of SecondaryWashingSolutionPipetteMixVolume to mix with sorbent.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		(*TertiaryWashing*)
		TertiaryWashing -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if analyte-bound-sorbent is flushed with TertiaryWashingSolution to get rid non-specific binding and and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		TertiaryWashingSolutionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectReferenceP[],
			Description -> "For each member of SampleExpression, The solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		TertiaryWashingSolutionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Model[Container], Object[Container]],
			Description -> "For each member of SampleExpression, The solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		TertiaryWashingSolutionString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleExpression, The solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		TertiaryWashingSolutionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SampleExpression, The amount of TertiaryWashingSolution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		TertiaryWashingSolutionTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleExpression, The set temperature that TertiaryWashingSolution is incubated for TertiaryWashingSolutionTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of TertiaryWashingSolution is assumed to equilibrate with the set TertiaryWashingSolutionTemperature.",
			Category -> "Washing",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		TertiaryWashingSolutionTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient, {(Ambient | GreaterEqualP[0 Kelvin] | Null)..}],
			Description -> "For each member of SampleExpression, The set temperature that TertiaryWashingSolution is incubated for TertiaryWashingSolutionTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of TertiaryWashingSolution is assumed to equilibrate with the set TertiaryWashingSolutionTemperature.",
			Category -> "Washing",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		TertiaryWashingSolutionTemperatureEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time that TertiaryWashingSolution is incubated to achieve the set TertiaryWashingSolutionTemperature. The final temperature of TertiaryWashingSolution is assumed to equilibrate with the set TertiaryWashingSolutionTemperature.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		TertiaryWashingEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time that TertiaryWashingSolution sits with the analyte-bound-sorbent, to ensure non-specific binding is removed from sorbent.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		CollectTertiaryWashingSolution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if the TertiaryWashingSolution is collected and saved after flushing through the sorbent.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		TertiaryWashingSolutionCollectionContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectReferenceP[] | Null | _String)..} | ObjectReferenceP[] | _String,
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in TertiaryWashing step. The collected volume might be less than TertiaryWashingSolutionVolume because some of TertiaryWashingSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		TertiaryWashingSolutionCollectionContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in TertiaryWashing step. The collected volume might be less than TertiaryWashingSolutionVolume because some of TertiaryWashingSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		TertiaryWashingSolutionCollectionContainerResource -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in TertiaryWashing step. The collected volume might be less than TertiaryWashingSolutionVolume because some of TertiaryWashingSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		MixCollectedTertiaryWashingSolution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if TertiaryWashingSolution that flushed through sorbent is swirled 5 times after collected or not.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		TertiaryWashingSolutionDispenseRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter / Minute],
			Units -> (Milliliter / Minute),
			Description -> "For each member of SampleExpression, The rate at which the TertiaryWashingSolution is applied to the sorbent by Instrument during Conditioning step.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		TertiaryWashingSolutionDrainTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time for TertiaryWashingSolution to be flushed through the sorbent. If TertiaryWashingSolutionUntilDrained is set to True, then TertiaryWashingSolution is continually flushed through the ExtractionCartridge in cycle of TertiaryWashingSolutionDrainTime until it is drained entirely. If TertiaryWashingSolutionUntilDrained is set to False, then TertiaryWashingSolution is flushed through ExtractionCartridge for TertiaryWashingSolutionDrainTime once.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		TertiaryWashingSolutionUntilDrained -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if TertiaryWashingSolution is continually flushed through the cartridge in cycle of every ConditioningDrainTime until it is drained entirely, or until MaxConditioningDrainTime has been reached.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		MaxTertiaryWashingSolutionDrainTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, Indicates the maximum amount of time to flush TertiaryWashingSolution through sorbent. TertiaryWashingSolution is flushed in cycles of ConditioningDrainTime until either TertiaryWashingSolution is entirely drained or MaxConditioningDrainTime has been reached.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		TertiaryWashingSolutionCentrifugeIntensity -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 * RPM] | GreaterEqualP[0 * GravitationalAcceleration],
			Description -> "For each member of SampleExpression, The rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush TertiaryWashingSolution through the sorbent.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		TertiaryWashingSolutionPressureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * PSI],
			Units -> PSI,
			Description -> "For each member of SampleExpression, The target pressure applied to the ExtractionCartridge to flush TertiaryWashingSolution through the sorbent. If Instrument is MPE2, the TertiaryWashingSolutionPressure is set to be LoadingSamplePressure (Pressure of MPE2 cannot be changed while the Experiment is running).",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		TertiaryWashingSolutionPressureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, The target pressure applied to the ExtractionCartridge to flush TertiaryWashingSolution through the sorbent. If Instrument is MPE2, the TertiaryWashingSolutionPressure is set to be LoadingSamplePressure (Pressure of MPE2 cannot be changed while the Experiment is running).",
			Category -> "Washing",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		TertiaryWashingSolutionMixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Milliliter,
			Description -> "For each member of SampleExpression, The amount of TertiaryWashingSolution that is pipetted up and down to mix with sorbent for TertiaryWashingSolutionNumberOfMixes times.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		TertiaryWashingSolutionNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression, The number of times that TertiaryWashingSolution is pipetted up and down at the volume of TertiaryWashingSolutionPipetteMixVolume to mix with sorbent.",
			Category -> "Washing",
			IndexMatching -> SampleExpression
		},
		(*Eluting*)
		Eluting -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if sorbent is flushed with ElutingSolution to release bound analyte from the sorbent.",
			Category -> "Elution",
			IndexMatching -> SampleExpression
		},
		ElutingSolutionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectReferenceP[],
			Description -> "For each member of SampleExpression, The solution that is used to flush and release bound analyte from the sorbent.",
			Category -> "Elution",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ElutingSolutionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The solution that is used to flush and release bound analyte from the sorbent.",
			Category -> "Elution",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ElutingSolutionString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleExpression, The solution that is used to flush and release bound analyte from the sorbent.",
			Category -> "Elution",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ElutingSolutionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SampleExpression, The amount of ElutingSolution that is flushed through the sorbent to release analyte from the sorbent.",
			Category -> "Elution",
			IndexMatching -> SampleExpression
		},
		ElutingSolutionTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleExpression, The set temperature that ElutingSolution is incubated for ElutingSolutionTemperatureEquilibrationTime before being loaded into the sorbent.",
			Category -> "Elution",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		ElutingSolutionTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient, {(Ambient | GreaterEqualP[0 Kelvin] | Null)..}],
			Description -> "For each member of SampleExpression, The set temperature that ElutingSolution is incubated for ElutingSolutionTemperatureEquilibrationTime before being loaded into the sorbent.",
			Category -> "Elution",
			Migration -> SplitField,
			IndexMatching -> SampleExpression
		},
		ElutingSolutionTemperatureEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time that ElutingSolution is incubated at ElutingSolutionTemperature.",
			Category -> "Elution",
			IndexMatching -> SampleExpression
		},
		ElutingEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The minimum amount of time that ElutingSolution sits with the sorbent before it is drained to ensure maximal release of analytes from the sorbent.",
			Category -> "Elution",
			IndexMatching -> SampleExpression
		},
		CollectElutingSolution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if the ElutingSolution is collected and saved after flushing through the sorbent.",
			Category -> "Elution",
			IndexMatching -> SampleExpression
		},
		ElutingSolutionCollectionContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectReferenceP[] | Null | _String)..} | ObjectReferenceP[] | _String,
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in Eluting step. The collected volume might be less than ElutingSolutionVolume because some of ElutingSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Elution",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ElutingSolutionCollectionContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in Eluting step. The collected volume might be less than ElutingSolutionVolume because some of ElutingSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Elution",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ElutingSolutionCollectionContainerResource -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "For each member of SampleExpression, The container that is used to accumulates any flow through solution in Eluting step. The collected volume might be less than ElutingSolutionVolume because some of ElutingSolution left in cartridge (the solution is not purged through the sorbent).",
			Category -> "Elution",
			IndexMatching -> SampleExpression
		},
		MixCollectedElutingSolution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if ElutingSolution that flushed through sorbent is swirled 5 times after collected or not.",
			Category -> "Elution",
			IndexMatching -> SampleExpression
		},
		ElutingSolutionDispenseRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter / Minute],
			Units -> (Milliliter / Minute),
			Description -> "For each member of SampleExpression, The rate at which the ElutingSolution is applied to the sorbent by Instrument during Eluting step.",
			Category -> "Elution",
			IndexMatching -> SampleExpression
		},
		ElutingSolutionDrainTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, The amount of time for ElutingSolution to be flushed through the sorbent. If ElutingSolutionUntilDrained is set to True, then ElutingSolution is continually flushed through the ExtractionCartridge in cycle of ElutingSolutionDrainTime until it is drained entirely. If ElutingSolutionUntilDrained is set to False, then ElutingSolution is flushed through ExtractionCartridge for ElutingSolutionDrainTime once.",
			Category -> "Elution",
			IndexMatching -> SampleExpression
		},
		ElutingSolutionUntilDrained -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, Indicates if ElutingSolution is continually flushed through the cartridge in cycle of every ConditioningDrainTime until it is drained entirely, or until MaxConditioningDrainTime has been reached.",
			Category -> "Elution",
			IndexMatching -> SampleExpression
		},
		MaxElutingSolutionDrainTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleExpression, Indicates the maximum amount of time to flush ElutingSolution through sorbent. ElutingSolution is flushed in cycles of ConditioningDrainTime until either ElutingSolution is entirely drained or MaxConditioningDrainTime has been reached.",
			Category -> "Elution",
			IndexMatching -> SampleExpression
		},
		ElutingSolutionCentrifugeIntensity -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 * RPM] | GreaterEqualP[0 * GravitationalAcceleration],
			Description -> "For each member of SampleExpression, The rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush ElutingSolution through the sorbent.",
			Category -> "Elution",
			IndexMatching -> SampleExpression
		},
		ElutingSolutionPressureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * PSI],
			Units -> PSI,
			Description -> "For each member of SampleExpression, The target pressure applied to the ExtractionCartridge to flush ElutingSolution through the sorbent. If Instrument is MPE2, the ElutingSolutionPressure is set to be LoadingSamplePressure (Pressure of MPE2 cannot be changed while the Experiment is running).",
			Category -> "Elution",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ElutingSolutionPressureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleExpression, The target pressure applied to the ExtractionCartridge to flush ElutingSolution through the sorbent. If Instrument is MPE2, the ElutingSolutionPressure is set to be LoadingSamplePressure (Pressure of MPE2 cannot be changed while the Experiment is running).",
			Category -> "Elution",
			IndexMatching -> SampleExpression,
			Migration -> SplitField
		},
		ElutingSolutionMixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Milliliter,
			Description -> "For each member of SampleExpression, The amount of ElutingSolution that is pipetted up and down to mix with sorbent for ElutingSolutionNumberOfMixes times.",
			Category -> "Elution",
			IndexMatching -> SampleExpression
		},
		ElutingSolutionNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression, The number of times that ElutingSolution is pipetted up and down at the volume of ElutingSolutionPipetteMixVolume to mix with sorbent.",
			Category -> "Elution",
			IndexMatching -> SampleExpression
		},
		(* batching *)
		SPEBatchID -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			(*TODO*)
			Description -> "For each member of SampleExpression, For each member of SampleExpression, the batch identification that the sample will be run together.",
			Category -> "General",
			IndexMatching -> SampleExpression
		},
		(* aliquoting options *)
		AliquotTargetsWell -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> ListableP[WellPositionP],
			Description -> "For each member of SampleExpression, Indicate target aliquot wells of the container to be used before running SPE.",
			Category -> "Aliquoting",
			IndexMatching -> SampleExpression
		},
		AliquotTargetsVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Milliliter,
			Description -> "For each member of SampleExpression, Indicate target aliquot volume to each wells of the container to be used before running SPE.",
			Category -> "Aliquoting",
			IndexMatching -> SampleExpression
		},
		AliquotTargetsContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleExpression, Indicate label of target aliquot the container to be used before running SPE.",
			Category -> "Aliquoting",
			IndexMatching -> SampleExpression
		},
		AliquotTargetsContainer -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectReferenceP[],
			Description -> "For each member of SampleExpression, Indicate label of target aliquot the container to be used before running SPE.",
			Category -> "Aliquoting",
			IndexMatching -> SampleExpression
		},
		AliquotLength -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> {GreaterEqualP[0]..} | {Null..} | GreaterEqualP[0],
			Description -> "For each member of WorkingSamples, Parameters describing the length of aliquot for each samples.",
			Category -> "Aliquoting",
			IndexMatching -> WorkingSamples
		},
		PoolLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression, Parameters describing the length of each pool of samples.",
			Category -> "Pooling",
			IndexMatching -> SampleExpression
		},
		(* GX271 specific fields *)
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
			Developer -> True
		},
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
		SolutionContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
			Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
			Description -> "A list of deck placements used for placing the solution bottles on the GX-271 liquid handler deck.",
			Headers -> {"Solution", "Placement"},
			Category -> "Placements",
			Developer -> True
		},
		CollectionContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
			Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
			Description -> "A list of deck placements used for placing the collection plates on the GX-271 liquid handler deck.",
			Headers -> {"Solution Plate", "Placement"},
			Category -> "Placements",
			Developer -> True
		},
		PreFlushingSolutionContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
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
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
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
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
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
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
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
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
			Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
			Description -> "For each member of SampleExpression, A list of deck placements used for placing the TertiaryWashing solution bottle on the GX-271 liquid handler deck.",
			Headers -> {"TertiaryWashing Solution", "Placement"},
			Category -> "Placements",
			Developer -> True,
			IndexMatching -> SampleExpression
		},
		ElutingSolutionContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
			Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
			Description -> "For each member of SampleExpression, A list of deck placements used for placing the Eluting solution bottle on the GX-271 liquid handler deck.",
			Headers -> {"Eluting Solution", "Placement"},
			Category -> "Placements",
			Developer -> True,
			IndexMatching -> SampleExpression
		},
		PrimingSolutionContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
			Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
			Description -> "For each member of SampleExpression, A list of deck placements used for placing the pump priming solution bottle on the GX-271 liquid handler deck.",
			Headers -> {"Priming Solution", "Placement"},
			Category -> "Placements",
			Developer -> True,
			IndexMatching -> SampleExpression
		},
		QuantitativeLoadingSolutionContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
			Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
			Description -> "For each member of SampleExpression, A list of deck placements used for placing the QuantitativeLoading solution bottle on the GX-271 liquid handler deck.",
			Headers -> {"QuantitativeLoading Solution", "Placement"},
			Category -> "Placements",
			Developer -> True,
			IndexMatching -> SampleExpression
		},
		ExtractionCartridgePositions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ,
			Description -> "For each member of SampleExpression, A list of deck placements used for placing the cartridges on the liquid handler deck.",
			Category -> "Placements",
			Developer -> True,
			IndexMatching -> SampleExpression
		},
		ExtractionCartridgePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ | {_?NumberQ}},
			Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
			Description -> "For each member of SampleExpression, A list of deck placements used for placing the cartridges on the liquid handler deck.",
			Headers -> {"ExtractionCartridge", "Placement"},
			Category -> "Placements",
			IndexMatching -> SampleExpression
		},
		PreFlushingContainerOutPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
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
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
			Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
			Description -> "For each member of SampleExpression, A list of deck placements used for placing the Conditioning solution collection container on the liquid handler deck.",
			Headers -> {"Conditioning ContainerOut", "Placement"},
			Category -> "Placements",
			Developer -> True,
			IndexMatching -> SampleExpression
		},
		LoadingSampleFlowthroughContainerOutPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
			Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
			Description -> "For each member of SampleExpression, A list of deck placements used for placing the LoadingSampleFlowthrough collection container on the liquid handler deck.",
			Headers -> {"LoadingSampleFlowthrough ContainerOut", "Placement"},
			Category -> "Placements",
			Developer -> True,
			IndexMatching -> SampleExpression
		},
		WashingContainerOutPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
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
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
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
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
			Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
			Description -> "For each member of SampleExpression, A list of deck placements used for placing the TertiaryWashing solution collection container on the liquid handler deck.",
			Headers -> {"TertiaryWashing ContainerOut", "Placement"},
			Category -> "Placements",
			Developer -> True,
			IndexMatching -> SampleExpression
		},
		ElutingContainerOutPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
			Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
			Description -> "For each member of SampleExpression, A list of deck placements used for placing the Eluting solution collection container on the liquid handler deck.",
			Headers -> {"Eluting ContainerOut", "Placement"},
			Category -> "Placements",
			Developer -> True,
			IndexMatching -> SampleExpression
		},
		SamplePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, LocationPositionP | {LocationPositionP..} | _String | {_String..} | _?NumberQ },
			Relation -> {Object[Sample] | Model[Sample] | Model[Container] | Object[Container], Null},
			Headers -> {"Sample", "Placement"},
			Description -> "For each member of SampleExpression, A list of deck placements used for placing the sample plate on the liquid handler deck.",
			Category -> "Placements",
			IndexMatching -> SampleExpression
		},
		PurgePressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * PSI],
			Units -> PSI,
			Description -> "The target pressure of the nitrogen gas used for pressure pushing the samples.",
			Category -> "Instrument Setup"
		},
		PurgePressureLog -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "For each member of SampleExpression, the pressure log for the nitrogen gas connected to the solid phase extraction.",
			Category -> "Sensor Information",
			Developer -> True,
			IndexMatching -> SampleExpression
		},
		InitialPurgePressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The pressure data of the nitrogen gas connected to the solid phase extraction before starting the run.",
			Category -> "Sensor Information",
			Developer -> True
		},
		InitialNitrogenPressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The pressure data of the nitrogen gas connected to the solid phase extraction before starting the run.",
			Category -> "Sensor Information",
			Developer -> True
		},
		WasteWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "For each member of SampleExpression, the weight data of the waste carboy installed on the instrument taken before starting the run.",
			Category -> "Sensor Information",
			Developer -> True,
			IndexMatching -> SampleExpression
		},
		ExtractionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Hour],
			Units -> Hour,
			Description -> "The estimated time each batch of SolidPhaseExtraction will run.",
			Category -> "General",
			Developer -> True
		},
		FilterUnitOperation -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP | {SamplePreparationP..} | {Null..},
			Description -> "A set of instructions specifying the filtering of solid phase extraction.",
			Category -> "Sample Preparation"
		},
		FilterManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "A SamplePreparation protocol that is used perform filter-based solid phase extraction.",
			Category -> "Sample Preparation"
		},
		WasteContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container] | Model[Container],
			Description -> "A SamplePreparation protocol that is used perform filter-based solid phase extraction.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		WasteContainerRack -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container] | Model[Container],
			Description -> "A Rack holding waste tub for Biotage Pressure 48.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		CartridgeContainerRack -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container] | Model[Container],
			Description -> "A Rack holding extraction cartridge for Biotage Pressure 48.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		ContainerOutRack -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container] | Model[Container],
			Description -> "A Rack holding container out for Biotage Pressure 48.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		PreFlushingTransferToCartridgeProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "A Transfer protocol that is used to transfer PreFlushing solution to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		ConditioningTransferToCartridgeProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "A Transfer protocol that is used to transfer Conditioning solution to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		WashingTransferToCartridgeProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "A Transfer protocol that is used to transfer Washing solution to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		SecondaryWashingTransferToCartridgeProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "A Transfer protocol that is used to transfer SecondaryWashing solution to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		TertiaryWashingTransferToCartridgeProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "A Transfer protocol that is used to transfer TertiaryWashing solution to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		ElutingTransferToCartridgeProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "A Transfer protocol that is used to transfer Eluting solution to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		WorkingSampleTransferToCartridgeProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "A Transfer protocol that is used to transfer WorkingSamples to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		(* TODO wtf is SCFH; apparently it is Standard Cubic Feet per Hour (an air flow measurement) *)
		PreFlushingSolutionSCFH -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression, the flow rate in SCFH unit for rotometer.",
			Category -> "Sample Preparation",
			IndexMatching -> SampleExpression,
			Developer -> True
		},
		ConditioningSolutionSCFH -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression, the flow rate in SCFH unit for rotometer.",
			Category -> "Sample Preparation",
			IndexMatching -> SampleExpression,
			Developer -> True
		},
		WorkingSamplesSCFH -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression, the flow rate in SCFH unit for rotometer.",
			Category -> "Sample Preparation",
			IndexMatching -> SampleExpression,
			Developer -> True
		},
		WashingSolutionSCFH -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression, the flow rate in SCFH unit for rotometer.",
			Category -> "Sample Preparation",
			IndexMatching -> SampleExpression,
			Developer -> True
		},
		SecondaryWashingSolutionSCFH -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression, the flow rate in SCFH unit for rotometer.",
			Category -> "Sample Preparation",
			IndexMatching -> SampleExpression,
			Developer -> True
		},
		TertiaryWashingSolutionSCFH -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression, the flow rate in SCFH unit for rotometer.",
			Category -> "Sample Preparation",
			IndexMatching -> SampleExpression,
			Developer -> True
		},
		ElutingSolutionSCFH -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of SampleExpression, the flow rate in SCFH unit for rotometer.",
			Category -> "Sample Preparation",
			IndexMatching -> SampleExpression,
			Developer -> True
		},
		CartridgeContainerOverWasteContainer -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ObjectReferenceP[Object[Container]],
				ObjectReferenceP[Object[Container]], LocationPositionP},
			Description -> "The position of cartridge rack to go on the top of the waste container rack.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		CartridgeContainerOverContainerOut -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ObjectReferenceP[Object[Container]],
				ObjectReferenceP[Object[Container]], LocationPositionP},
			Description -> "The position of cartridge rack to go on the top of the container out rack.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		PreFlushingTransferToCartridgeUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SamplePreparationP | {SamplePreparationP..} | {Null..},
			Description -> "A Transfer UnitOperation that is used to transfer PreFlushing solution to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		ConditioningTransferToCartridgeUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SamplePreparationP | {SamplePreparationP..} | {Null..},
			Description -> "A Transfer UnitOperation that is used to transfer Conditioning solution to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		WashingTransferToCartridgeUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SamplePreparationP | {SamplePreparationP..} | {Null..},
			Description -> "A Transfer UnitOperation that is used to transfer Washing solution to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		SecondaryWashingTransferToCartridgeUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SamplePreparationP | {SamplePreparationP..} | {Null..},
			Description -> "A Transfer UnitOperation that is used to transfer SecondaryWashing solution to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		TertiaryWashingTransferToCartridgeUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SamplePreparationP | {SamplePreparationP..} | {Null..},
			Description -> "A Transfer UnitOperation that is used to transfer TertiaryWashing solution to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		ElutingTransferToCartridgeUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SamplePreparationP | {SamplePreparationP..} | {Null..},
			Description -> "A Transfer UnitOperation that is used to transfer Eluting solution to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		WorkingSampleTransferToCartridgeUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SamplePreparationP | {SamplePreparationP..} | {Null..},
			Description -> "A Transfer UnitOperation that is used to transfer WorkingSamples to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		QuantitativeLoadingToSourceToCartridgeTransferUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SamplePreparationP | {SamplePreparationP..} | {Null..},
			Description -> "A Transfer UnitOperation that is used to transfer and rinse working container and then transfer rinse solution to ExtractionCartridge.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		(* TODO kill this shit *)
		PreFlushingSolutionDrainTimeSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Minute,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting time options to single to use in time of the procedure."
		},
		ConditioningSolutionDrainTimeSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Minute,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting time options to single to use in time of the procedure."
		},
		WashingSolutionDrainTimeSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Minute,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting time options to single to use in time of the procedure."
		},
		SecondaryWashingSolutionDrainTimeSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Minute,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting time options to single to use in time of the procedure."
		},
		TertiaryWashingSolutionDrainTimeSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Minute,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting time options to single to use in time of the procedure."
		},
		ElutingSolutionDrainTimeSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Minute,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting time options to single to use in time of the procedure."
		},
		LoadingSampleDrainTimeSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Minute,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting time options to single to use in time of the procedure."
		},
		MaxPreFlushingSolutionDrainTimeSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Minute,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting time options to single to use in time of the procedure."
		},
		MaxConditioningSolutionDrainTimeSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Minute,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting time options to single to use in time of the procedure."
		},
		MaxWashingSolutionDrainTimeSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Minute,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting time options to single to use in time of the procedure."
		},
		MaxSecondaryWashingSolutionDrainTimeSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Minute,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting time options to single to use in time of the procedure."
		},
		MaxTertiaryWashingSolutionDrainTimeSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Minute,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting time options to single to use in time of the procedure."
		},
		MaxElutingSolutionDrainTimeSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Minute,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting time options to single to use in time of the procedure."
		},
		MaxLoadingSampleDrainTimeSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Minute,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting time options to single to use in time of the procedure."
		},
		PreFlushingSolutionPressureSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> PSI,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting pressure options to single to use in pressure of the procedure."
		},
		ConditioningSolutionPressureSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> PSI,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting pressure options to single to use in pressure of the procedure."
		},
		WashingSolutionPressureSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> PSI,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting pressure options to single to use in pressure of the procedure."
		},
		SecondaryWashingSolutionPressureSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> PSI,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting pressure options to single to use in pressure of the procedure."
		},
		TertiaryWashingSolutionPressureSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> PSI,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting pressure options to single to use in pressure of the procedure."
		},
		ElutingSolutionPressureSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> PSI,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting pressure options to single to use in pressure of the procedure."
		},
		LoadingSamplePressureSingle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> PSI,
			Developer -> True,
			Category -> "Sample Preparation",
			Description -> "Converting pressure options to single to use in pressure of the procedure."
		}
	}
}]







