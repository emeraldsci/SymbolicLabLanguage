

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, PlateSealMagazine], {
	Description->"A model of a container with SBS dimensions for placing Plate Seals inside.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SupportedInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument][AssociatedAccessories,1],
			Description -> "A list of instruments for which this model is an accompanying accessory.",
			Category -> "Qualifications & Maintenance"
		}
	}
}];
