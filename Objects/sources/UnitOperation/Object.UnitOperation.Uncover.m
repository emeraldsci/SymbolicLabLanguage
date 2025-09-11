(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, Uncover], {
	Description -> "A detailed set of parameters that specifies the information of how to remove caps, lids, or plate seals to the tops of containers in order to secure their contents.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
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
			Description -> "The samples whose containers will be covered.",
			Category -> "General",
			Migration->SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The samples whose containers will be covered.",
			Category -> "General",
			Migration->SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
			Relation -> Null,
			Description -> "The samples whose containers will be covered.",
			Category -> "General",
			Migration->SplitField
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that is used in the experiment, for use in downstream unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container of the sample that is used in the experiment, for use in downstream unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		DiscardCover -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if the cover is discarded after it's taken off of the container.",
			Category -> "General",
			IndexMatching -> SampleLink
		},

		(* NOTE: These three fields are populated in uploadUncoverExecute -- after the cover has been taken off. They are then used for *)
		(* to dispose or store the cover/septum/stopper. *)
		CoversToDiscard -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Lid],
				Object[Item, Cap],
				Object[Item, Consumable],
				Object[Item, PlateSeal]
			],
			Description -> "The cap, lid, or plate seal that is taken off the top of the given container.",
			Category -> "General"
		},
		SeptumsToDiscard -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Septum]
			],
			Description -> "The septum that is taken off the top of the given container.",
			Category -> "General"
		},
		StoppersToDiscard -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Stopper]
			],
			Description -> "The stopper that is taken off the top of the given container.",
			Category -> "General"
		},
		CapRacksToStore -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container, Rack]
			],
			Description -> "The stopper that is taken off the top of the given container.",
			Category -> "General"
		},
		CapRack -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack],
				Object[Container, Rack]
			],
			Description -> "The cap rack that should be used to hold and identify the cap, if it does not have a barcode because it is too small.",
			Category -> "General"
		},
		BarcodeCoverContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The containers whose caps should have a barcode on them. We will ask the operator if this is the case. If not, we will ask the operator to print a sticker.",
			Category -> "General"
		},
		Instrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Crimper],
				Object[Instrument, Crimper],
				Model[Part, CapPrier],
				Object[Part, CapPrier],
				Model[Part, Decrimper],
				Object[Part, Decrimper],
				Model[Part, AmpouleOpener],
				Object[Part, AmpouleOpener]
			],
			Description -> "For each member of SampleLink, the device used to remove the cover from the top of the container.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		DecrimpingHead -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, DecrimpingHead],
				Object[Part, DecrimpingHead]
			],
			Description -> "The part that attaches to the crimper instrument and is used to remove crimped caps from vials.",
			Category -> "General"
		},
		CrimpingPressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "The pressure of the gas that is connected to the pneumatic crimper and determines the strength used to crimp or decrimp the crimped cap.",
			Category -> "General"
		},
		MeasuredCrimpingPressureData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Pressure],
			Description -> "The measured pressure of the gas that is connected to the pneumatic crimper and determines the strength used to crimp or decrimp the crimped cap.",
			Category -> "Experimental Results"
		},
		SterileTechnique -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if a sterile environment should be used for the uncovering.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		Environment -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Model[Container, Bench],
				Model[Container, OperatorCart],


				Object[Instrument],
				Object[Container],
				Object[Item],
				Object[Part]
			],
			Description -> "For each member of SampleLink, the environment that should be used to perform the uncovering.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		InitialEnvironment -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Model[Container, Bench],
				Model[Container, OperatorCart],


				Object[Instrument],
				Object[Container],
				Object[Item],
				Object[Part]
			],
			Description -> "For each member of SampleLink, the environment where the containers were initially prior to uncovering.  This is often (but not always) the same as Environment.",
			Category -> "General",
			IndexMatching -> SampleLink
		}

	}
}];