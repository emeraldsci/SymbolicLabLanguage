(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Physics, Material], {
	Description->"Properties of Materials, including Temperature range.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* --- Organizational Information --- *)
		Material -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The Symbol of this Material.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature this type of material can be exposed to and maintain structural integrity.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature this type of material can be exposed to and maintain structural integrity.",
			Category -> "Operating Limits"
		},
		Fragile -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the material is vulnerable to physical impact.",
			Category -> "General"
		}
	}
}];