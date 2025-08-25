(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Handwash], {
	Description->"Definition of a set of parameters for a maintenance protocol that hand cleans labware too large or unsuitable for dishwashing.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		LabwareTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _?TypeQ,
			Description -> "Labware types that are supported for handwashing.",
			Category -> "General",
			Abstract -> True
		},
		MinThreshold -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "For each member of LabwareTypes, the minimum number of labware required before a handwash protocol can be queued.",
			Category -> "General",
			IndexMatching -> LabwareTypes
		},
		PartitionThreshold -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "For each member of LabwareTypes, the maximum number of labware of the type that can be handwashed in a single protocol. Above this number, the labware will be partitioned into multiple protocols.",
			Category -> "General",
			IndexMatching -> LabwareTypes
		},
		WaterPurifierModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "Source of purified water used to rinse the labware.",
			Category -> "General",
			Abstract -> True
		},
		BottleRollerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "Source of agitation used to wash the inside of a carboy.",
			Category -> "General"
		},
		FumeHoodModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "Fume hood(s) that are used during cleaning of labware.",
			Category -> "General"
		},
		BlowGunModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "Instrument used to blow dry the interior of the washed containers by spraying them with a stream of nitrogen gas.",
			Category -> "General"
		},
		CuvetteWasherModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "Instrument that are used during cleaning of used cuvettes.",
			Category -> "General"
		},
		ThermoplasticWrapModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Model[Item],
			Description -> "A malleable thermoplastic wrap that is used to temporarily seal containers while cleaning.",
			Category -> "General"
		},
		HandwashPrice -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*USD],
			Units -> USD,
			Description -> "The price the ECL charges for hand-washing a labware item owned by the user.",
			Category -> "Pricing Information"
		}
	}
}];
