(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[DeckLayout], {
	Description->"A unique arrangement of container models placed into the positions of a model of instrument or container.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of this layout.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this layout is historical and no longer used in the lab.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Author -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User,Emerald,Developer],
			Description -> "The person who created this layout.",
			Category -> "Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		InstrumentModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument][AvailableLayouts],
			Description -> "Instrument model that can be configured according to this layout.",
			Category -> "Organizational Information"
		},
		ContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container][AvailableLayouts],
			Description -> "Container model that can be configured according to this layout.",
			Category -> "Organizational Information"
		},
		ConfiguredInstruments -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument][DeckLayout],
			Description -> "Instruments currently configured according to this layout.",
			Category -> "Organizational Information"
		},
		ConfiguredContainers -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container][DeckLayout],
			Description -> "Containers currently configured according to this layout.",
			Category -> "Organizational Information"
		},

		Layout -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {LocationPositionP, _Link},
			Relation -> {Null, Model[Container]},
			Description -> "Positions in the instrument/container model that must be occupied and the container models that must occupy these positions.",
			Category -> "Dimensions & Positions",
			Headers ->{"Position Name", "Container Model"}
		},
		NestedLayout -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {LocationPositionP, _Link},
			Relation -> {Null, Model[DeckLayout]},
			Description -> "Nested layouts of the containers in the indicated positions.",
			Category -> "Dimensions & Positions",
			Headers ->{"Position Name", "Nested Layout"}
		}
	}
}];
