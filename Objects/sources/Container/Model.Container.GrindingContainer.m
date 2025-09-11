

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, GrindingContainer], {
	Description -> "Model information of a container that holds the sample during grinding process in a grinder.",
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
		},
		Aperture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter Milli,
			Description -> "The minimum opening diameter encountered when aspirating from the container.",
			Category -> "Dimensions & Positions"
		}
	}
}];