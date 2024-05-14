(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, AuditGasCylinders], {
	Description -> "A protocol that audits the gas cylinders within the target room.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Positions -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "The positions in the target room whose contents were verified or objectified.",
			Category -> "General"
		},
		PositionDecks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _LinkP,
			Relation -> Object[Container, Deck],
			Description -> "For each member of Positions, the deck located in that position of the target room whose contents were verified or objectified.",
			Category -> "General",
			IndexMatching -> Positions
		},
		PositionTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Full, Installed, Empty],
			Description -> "For each member of Positions, the intended use for a tank or cylinder currently location in that position.",
			Category -> "General",
			IndexMatching -> Positions
		},
		PositionCylinderTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Tank, Cylinder],
			Description -> "For each member of Positions, indicates if that position is intended to contain a gas tank or gas cylinder.",
			Category -> "General",
			IndexMatching -> Positions
		},
		GasCylinderModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, GasCylinder],
			Description -> "For each member of positions, the type of gas cylinder/tank identified in that position by the operator. Will be Null if the cylinder is already objectified.",
			Category -> "General"
		},
		RawPositionContents -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of Positions, the raw ID of the gas cylinder/tank that was physically found there by the operator.",
			Category -> "General",
			Developer -> True
		},
		EmptyCylinderQ -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Positions, indicates if the tank is labelled with an \"Empty\" sticker, indicating an exhausted cylinder/tank.",
			Category -> "General"
		},
		EmptyTankPosition -> {
			Format -> Single,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "The multi-tank position in the target room that contains any empty gas tanks.",
			Category -> "General"
		},
		EmptyTankPositionDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _LinkP,
			Relation -> Object[Container, Deck],
			Description -> "The deck located in the multi-tank position of the target room that contains any empty gas tanks.",
			Category -> "General"
		},
		RawEmptyTankPositionContents -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The raw IDs of the gas tanks that were physically found in the empty tank position of the gas room by the operator.",
			Category -> "General",
			Developer -> True
		},
		TankOverflowPosition -> {
			Format -> Single,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "The multi-tank position in the target room that contains any recently delivered gas tanks that could not be chained in full gas tank slots.",
			Category -> "General"
		},
		TankOverflowPositionDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _LinkP,
			Relation -> Object[Container, Deck],
			Description -> "The deck located in the multi-tank position of the target room that contains recently delivered gas tanks.",
			Category -> "General"
		},
		OverflowPositionTankCount -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of recently delivered un-objectified tanks in the tank delivery position slot.",
			Category -> "General",
			Developer -> True
		},
		OverflowPositionExistingTanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, GasCylinder],
			Description -> "The IDs of the existing gas tanks that were physically found in the full tank delivery position of the gas room by the operator. This may include discarded tanks that have returned with the sticker still in place.",
			Category -> "General"
		},
		RawOverflowPositionExistingTanks -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The raw string IDs of the existing gas tanks that were physically found in the full tank delivery position of the gas room by the operator. This may include discarded tanks that have returned with the sticker still in place.",
			Category -> "General",
			Developer -> True
		},
		OverflowPositionDiscardedTanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, GasCylinder],
			Description -> "The IDs of any gas tanks that were physically found in the full tank delivery position of the gas room by the operator with an old SLL sticker on.",
			Category -> "General",
			Developer -> True
		},
		OverflowPositionTanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, GasCylinder],
			Description -> "The newly generated IDs for the un-objectified gas tanks that were physically found in the full tank delivery position of the gas room by the operator.",
			Category -> "General",
			Developer -> True
		},
		OverflowGasCylinderModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, GasCylinder],
			Description -> "For each member of OverflowPositionTanks, the type of gas tank identified by the operator.",
			Category -> "General"
		},
		NewCylinders -> {
			Format -> Multiple,
			Class -> {Position -> Link, Container -> Link, ContainerModel -> Link, Sample -> Link, SampleModel -> Link},
			Pattern :> {Position -> _Link, Container -> _Link, ContainerModel -> _Link, Sample -> _Link, SampleModel -> _Link},
			Relation -> {Position -> Object[Container, Deck], Container -> Object[Container], ContainerModel -> Model[Container], Sample -> Object[Sample], SampleModel -> Model[Sample]},
			Description -> "Specifications of any new cylinder/tank objects and contents that were created by this maintenance.",
			Headers -> {Position -> "Room position", Container -> "Container", ContainerModel -> "Container Model", Sample -> "Sample", SampleModel -> "Sample Model"},
			Category -> "General"
		},
		NewCylinderStickerPlacements -> {
			Format -> Multiple,
			Class -> {Position -> Link, Container -> Link},
			Pattern :> {Position -> _Link, Container -> _Link},
			Relation -> {Position -> Object[Container, Deck], Container -> Object[Container]},
			Description -> "The position of the cylinder/tank and the object reference to use for stickering.",
			Headers -> {Position -> "Room position deck", Container -> "Container"},
			Category -> "General",
			Developer -> True
		},
		DiscardedCylinders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Cylinders/tanks that were not located during this audit, indicating that they have been returned to the gas company, and have been set to Discarded.",
			Category -> "General"
		},
		VerifiedCylinders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Already objectified cylinders/tanks that were located during this audit in their expected locations.",
			Category -> "General"
		},
		CylinderPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container, GasCylinder], Object[Container, Deck], Null},
			Headers -> {"Gas Cylinder", "Gas Room Deck", "Tank Position"},
			Description -> "A list of placements to correct the positions of any gas cylinders/tanks found in the wrong location in this maintenance.",
			Category -> "General",
			Developer -> True
		},
		BuildPressure -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the pressures of compatible new tanks are built to the pressures required for usage.",
			Category -> "General"
		},
		TargetPressures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "For each member of NewCylinders, the pressure to attempt to reach when building the pressure of compatible tanks.",
			Category -> "General"
		},
		TargetPressureReached -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of NewCylinders, indicates if pressure building successfully reached the target pressure for the tank.",
			Category -> "General"
		}
	}
}];