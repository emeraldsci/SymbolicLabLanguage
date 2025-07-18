(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Decontaminate, LiquidHandler], {
	Description -> "A protocol that decontaminates a liquid handler to ensure a sterile environment is maintained.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		DeckRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "Left to Right order of racks present on the target.",
			Headers-> {"Rack","Container","Position"},
			Category -> "Placements",
			Developer -> True
		},
		ReverseDeckRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "Right to Left order of racks present on the target.",
			Headers-> {"Rack","Container","Position"},
			Category -> "Placements",
			Developer -> True
		},
		SanitizationWipes -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Item]|Object[Item]),
			Description ->"The sanitization wipes that will be used for the decontamination.",
			Category -> "Sanitization"
		},
		RequiredInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument] | Object[Instrument],
			Description -> "Instruments required for the protocol.",
			Category -> "General",
			Developer -> True
		}
	}
}];
