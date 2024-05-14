(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Nut], {
	Description->"Model information for a threaded piece attached to a connector which is used to form a fitting at the connector.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Gender -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectorGenderP,
			Description -> "Indicates whether the nut contains outward facing (male) or inward facing (female) threading.",
			Category -> "Plumbing Information",
			Abstract -> True
		},
		ConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectorP,
			Description -> "The mechanism by which this nut connects to its mating part.",
			Category -> "Plumbing Information",
			Abstract -> True
		},
		ThreadType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ThreadP,
			Description -> "The measurement of the helical grooves on this part that fit into the helical grooves of a mating part and draw the two parts together or apart when their relative rotation is changed.",
			Category -> "Plumbing Information",
			Abstract -> True
		},
		OuterDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Inch],
			Units -> Inch,
			Description -> "The maximum distance passing through the center of this part that is required for the part to rotate freely.",
			Category -> "Plumbing Information",
			Abstract -> True
		},
		InnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Inch],
			Units -> Inch,
			Description -> "The maximum width of a part that can fit through the opening in this part and rotate freely.",
			Category -> "Plumbing Information",
			Abstract -> True
		},
		Flanged -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether this model of nut is a flange nut, meaning it has a projecting collar that acts as an integrated washer.",
			Category -> "Part Specifications"
		}
	}
}];