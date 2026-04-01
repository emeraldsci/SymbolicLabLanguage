

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, Sink], {
	Description->"Model information for an instrument that supplies tap water for laboratory applications.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		WaterGenerated -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The type of water that this instrument dispenses.",
			Category -> "Instrument Specifications"
		}
	}
}];
