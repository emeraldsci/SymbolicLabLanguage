(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, StirBarRetriever], {
	Description->"Model information for a magnet and handle used to remove stir bars from samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		RetrieverLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milli Meter],
			Units-> Milli Meter,
			Description -> "The overall length of the stir bar retriever.",
			Category -> "Dimensions & Positions"
		},
		RetrieverDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :>GreaterP[0 Milli Meter],
			Units-> Milli Meter,
			Description -> "The outside diameter of the retriever stem.",
			Category -> "Dimensions & Positions"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which this retriever can handle.",
			Category -> "Compatibility"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature at which this retriever can handle.",
			Category -> "Compatibility"
		}
	}
}];
