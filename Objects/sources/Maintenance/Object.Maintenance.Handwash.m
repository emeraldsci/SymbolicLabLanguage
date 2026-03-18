(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Handwash], {
	Description->"A protocol that hand cleans labware too large or unsuitable for dishwashing.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		DirtyLabware -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Part],
				Object[Sample],
				Object[Item],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "The dirty labware being washed during this maintenance.",
			Category -> "Cleaning Setup"
		},
		CleanLabware -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container][DishwashLog, 2],
				Object[Part][DishwashLog, 2],
				Object[Part],
				Object[Sample],
				Object[Item],
				Object[Item][DishwashLog, 2],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "The newly clean labware produced by this maintenance.",
			Category -> "Cleaning",
			Abstract -> True
		},
		WaterPurifier -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "Source of purified water used to clean the labware.",
			Category -> "Cleaning Setup"
		},
		BlowGun -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The instrument used to blow dry the interior of the washed containers by spraying them with a stream of nitrogen gas.",
			Category -> "Cleaning Setup"
		},
		BottleRoller -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "Source of agitation used to wash the inside of a carboy.",
			Category -> "Cleaning"
		},
		FumeHood -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "Fume hood used during cleaning of labware.",
			Category -> "Cleaning"
		},
		ThermoplasticWrap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample], (* TODO: Remove Object[Sample] here after item migration *)
				Model[Sample],
				Object[Item],
				Model[Item]
			],
			Description -> "A malleable thermoplastic wrap that is used to temporarily seal containers while cleaning.",
			Category -> "Cleaning"
		},
		PrimaryWashContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The container into which hand pumps are immersed in PrimaryCleaningSolvent during cleaning.",
			Category -> "Cleaning"
		},
		SecondaryWashContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The container into which hand pumps are immersed in SecondaryCleaningSolvent during cleaning.",
			Category -> "Cleaning"
		},
		PrimaryCleaningContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The container holding the primary solvent with which to wash the dirty labware.",
			Category -> "Cleaning"
		},
		PrimaryCleaningSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The primary solvent with which to wash the dirty labware.",
			Category -> "Cleaning"
		},
		SecondaryCleaningSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The secondary solvent with which to wash the dirty labware.",
			Category -> "Cleaning"
		},
		SecondaryCleaningSolventVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The amount of the secondary cleaning solvent to dispense.",
			Category -> "General",
			Abstract -> True
		},
		PrimaryCleaningSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The syringe used to flush the primary cleaning solvent through the dirty needles.",
			Category -> "Cleaning"
		},
		SecondaryCleaningSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The syringe used to flush the secondary cleaning solvent through the dirty needles.",
			Category -> "Cleaning"
		},
		DryingSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The syringe used to push air through the dirty needles for drying after solvent cleaning.",
			Category -> "Cleaning"
		},
		CuvetteWasher -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument] | Object[Instrument],
			Description -> "The cuvette washer instrument used to wash cuvettes.",
			Category -> "Cleaning"
		}
	}
}];
