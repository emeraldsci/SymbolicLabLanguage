

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program, SampleManipulation], {
	Description->"A set of method information for dispensing liquids using a macro-scale automated liquid handler.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		FilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The location of the exported file describing the manipulation operations.",
			Category -> "Robotic Liquid Handling"
		},
		WashFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The location of the exported file describing the manipulation operations.",
			Category -> "Robotic Liquid Handling"
		},
		SamplesIn -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The samples from which liquid is dispensed by this liquid handling program.",
			Category -> "General"
		},
		ContainersIn -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers from which liquid is dispensed by this liquid handling program.",
			Category -> "General",
			Abstract->True
		},
		PortNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of ContainersIn, the name of the source port to which the container should be attached.",
			IndexMatching -> ContainersIn,
			Category -> "General",
			Developer->True
		},
		SampleOut -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The sample into which liquid is dispensed by this liquid handling program.",
			Category -> "General"
		},
		ContainerOut -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The container into which liquid is dispensed by this liquid handling program.",
			Category -> "General",
			Abstract->True
		},
		DispensingHead -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,DispensingHead]|Model[Part,DispensingHead],
			Description -> "The head used to dispense fluids into the destination container.",
			Category -> "General",
			Developer -> True
		},
		TubeRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Rack]|Object[Container,Rack],
			Description -> "The rack used to hold the destination conical tube upright for receiving dispenses.",
			Category -> "General",
			Developer -> True
		},
		DispensingTime -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?TimeQ,
			Description -> "The estimated time for completion of the liquid dispenses described in this program.",
			Category -> "General",
			Developer -> True
		},
		CleaningSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The solvent for cleaning dip tubing used to draw liquid from source bottles for automated dispensing.",
			Category -> "Cleaning",
			Developer->True
		},
		CleaningWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Vessel],
				Object[Container,Vessel]
			],
			Description -> "The beaker used to collect cleaning solvent from dip tubing washing.",
			Category -> "Cleaning",
			Developer->True
		},
		CleaningSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,Syringe],
				Model[Container,Syringe]
			],
			Description -> "The syringe used to flush the cleaning solvent through the dip tubing.",
			Category -> "Cleaning",
			Developer->True
		},
		DryingSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,Syringe],
				Model[Container,Syringe]
			],
			Description -> "The syringe used to push air through the dip tubing for drying after solvent cleaning.",
			Category -> "Cleaning",
			Developer->True
		},
		DirtyDipTubeContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,GraduatedCylinder],
				Model[Container,GraduatedCylinder]
			],
			Description -> "The container used to transport dirty dip tubing after use.",
			Category -> "Cleaning",
			Developer->True
		},
		CleanDipTubeContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,GraduatedCylinder],
				Model[Container,GraduatedCylinder]
			],
			Description -> "The container used to transport cleaned and dried dip tubing after use.",
			Category -> "Cleaning",
			Developer->True
		},
		FumeHood -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument,FumeHood],
				Model[Instrument,FumeHood]
			],
			Description -> "The fume hood in which the dip tubing is cleaned.",
			Category -> "Cleaning",
			Developer->True
		},
		BlowGun-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument,BlowGun],Model[Instrument,BlowGun]],
			Description -> "The blow gun used to dry the interior of large dip tubing.",
			Category -> "Cleaning",
			Developer->True
		}
	}
}];
