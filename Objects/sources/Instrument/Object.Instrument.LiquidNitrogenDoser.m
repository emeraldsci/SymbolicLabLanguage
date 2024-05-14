

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, LiquidNitrogenDoser], {
	Description->"A delivery system used dispense a precisely measured dose of liquid nitrogen.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		LiquidNitrogenValve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing,Valve][ConnectedInstrument],
			Description -> "The valve that is used by this instrument to directly control the opening the liquid nitrogen doser valve to allow for the release of liquid nitrogen out of the instrument.",
			Category -> "Plumbing Information",
			Developer->True
		}
	}
}];
