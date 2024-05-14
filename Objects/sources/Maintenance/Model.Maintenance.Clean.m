(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Clean], {
	Description->"Definition of a set of parameters for a maintenance protocol that cleans the exterior of an instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		BlowGunModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "The type of blow gun used to clean or dry a surface.",
			Category -> "Cleaning",
			Developer -> True
		},
		WorkSurface -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The location where the Target is cleaned.",
			Category -> "General",
			Developer -> True
		},
		WaterPurifier -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "Source of purified water used to clean the target.",
			Category -> "Cleaning"
		},
		CleanType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CleanTypeP,
			Description -> "Specifies the type of consolidated clean being performed.",
			Category -> "Cleaning"
		}
	}
}];
