(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, KarlFischerTitrator], {
	Description->"An instrument used for measuring the water content of a sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ReactionVessel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container in which the actual Karl Fischer Titration takes place on this instrument.",
			Category -> "Dimensions & Positions"
		},
		AutosamplerDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform from which samples are heated and gas is bubbled into the Karl Fischer reagent.",
			Category -> "Dimensions & Positions"
		},
		TitrationTechnique -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], TitrationTechnique]],
			Pattern :> KarlFischerTechniqueP,
			Description -> "Indicates how models of this instrument introduce Karl Fischer reagent to the sample.  If Volumetric, the Karl Fischer reagent mixture is introduced via buret in small increments. If set to Coulometric, molecular iodine is generated in situ by applying a pulse of electric current on a sample of iodide ions.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		SamplingMethods -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], SamplingMethods]],
			Pattern :> KarlFischerSamplingMethodP,
			Description -> "The processes by which sample may be introduced to the Karl Fischer reagent using this instrument. Liquid indicates that the Karl Fischer reagent can be introduced to the liquid sample directly.  Headspace indicates that the sample can be heated and the released gas bubbled into the Karl Fischer reagent chamber.",
			Category -> "Instrument Specifications"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinTemperature]],
			Pattern :> GreaterP[0 Kelvin],
			Description -> "Indicates the lowest temperature that this instrument can heat the sample when using the Headspace sampling method.",
			Category -> "Instrument Specifications"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxTemperature]],
			Pattern :> GreaterP[0 Kelvin],
			Description -> "Indicates the highest temperature that this instrument can heat the sample when using the Headspace sampling method.",
			Category -> "Instrument Specifications"
		},
		KarlFischerReagentContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "Indicates the attached container holding the Karl Fischer reagent used to titrate the sample.",
			Category -> "Instrument Specifications"
		},
		KarlFischerReagentCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "Indicates the cap attached to the KarlFischerReagentContainer that transfers reagent from the bottle into the reaction vessel.",
			Category -> "Instrument Specifications"
		},
		KarlFischerReagentStorageCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "Indicates the cap for the karl fischer reagent container once it is disconnected from the instrument and stored.  This cap is stored in local cache while the KarlFischerReagentContainer is attached to the instrument via KarlFischerReagentCap.",
			Category -> "Instrument Specifications"
		},
		MediumContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "Indicates the attached container holding Karl Fischer reaction medium.  This medium can be transferred into the reaction vessel in which the titration occurs.",
			Category -> "Instrument Specifications"
		},
		MediumCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "Indicates the cap attached to the MediumContainer that transfers medium from the bottle into the reaction vessel.",
			Category -> "Instrument Specifications"
		},
		MediumStorageCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "Indicates the cap for the medium container once it is disconnected from the instrument and stored.  This cap is stored in local cache while the MediumContainer is attached to the instrument via MediumCap.",
			Category -> "Instrument Specifications"
		},
		WasteContainerCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "Indicates the cap attached to the WasteContainer that transfers sample from the reaction vessel into the WasteContainer.",
			Category -> "Instrument Specifications"
		},
		WasteContainerStorageCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "Indicates the cap for the waste container once it is disconnected from the instrument and carried across the lab to be emptied.  This cap is stored in local cache while the WasteContainer is attached to the instrument via WasteContainerCap.",
			Category -> "Instrument Specifications"
		},
		KarlFischerReagentWeightSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The balance used to measure how much KarlFischerReagent is consumed during the course of the experiment.",
			Category -> "Sensor Information"
		},
		MediumWeightSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The balance used to measure how much Medium is consumed during the course of the experiment.",
			Category -> "Sensor Information"
		},
		StirBarRetriever -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, StirBarRetriever],
			Description -> "The stir bar retriever for this instrument that is used to remove the stir bar prior to the reaction vessel being emptied and rinsed.",
			Category -> "Instrument Specifications"
		},
		ContainerDisconnectionSlot -> {
			Format -> Single,
			Class -> {Link, String},
			Pattern :> {_Link, _String},
			Relation -> {Model[Container] | Object[Container], Null},
			Description -> "The destination information for the disconnected molecular sieve containers.  This should be a position in the container of the instrument.",
			Headers -> {"Container", "Position"},
			Category -> "Instrument Specifications",
			Developer -> True
		},
		MolecularSievesCap1 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "Indicates the cap connected to the instrument that covers the molecular sieves bottle in Molecular Sieves Bottle Slot 1.",
			Category -> "Instrument Specifications"
		},
		MolecularSievesCap2 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "Indicates the cap connected to the instrument that covers the molecular sieves bottle in Molecular Sieves Bottle Slot 2.",
			Category -> "Instrument Specifications"
		}
	}
}];