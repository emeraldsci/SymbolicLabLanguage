(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part,ORing], {
	Description->"A model of an O-ring used to form a leak-tight seal between two components via compression.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		OuterDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "The outside diameter of the O-ring in its natural circular shape.",
			Units -> Milli*Meter,
			Category -> "Physical Properties"
		},
		InnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "The diameter of the opening in the O-ring in its natural circular shape.",
			Units -> Milli*Meter,
			Category -> "Physical Properties"
		},
		Width -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "The width of the sealing surface of the O-ring, normal to the opening in the O-ring.",
			Units -> Milli*Meter,
			Category -> "Physical Properties"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The minimum temperature that this O-ring can withstand before it loses its sealing properties.",
			Units->Celsius,
			Category -> "Physical Properties"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The maximum temperature that this O-ring can withstand before it begins to degrade.",
			Units->Celsius,
			Category -> "Physical Properties"
		},
		Hardness -> {
			Format -> Single,
			Class -> {Integer,Expression},
			Pattern :> {RangeP[0,100,10],(Shore00|ShoreA|ShoreD)},
			Headers -> {"Hardness Number","Shore Class"},
			Description -> "The malleability of the O-ring.",
			Category -> "Physical Properties"
		},
		Shape -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Circle,
			Description -> "The identifying geometrical feature of the O-ring.",
			Category -> "Physical Properties"
		},
		Reusable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether this O-ring can be re-used if the part is removed from its installed location.",
			Category -> "Physical Properties"
		},
		Material -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material that the weight is made out of.",
			Category -> "Physical Properties",
			Abstract -> True
		}
	}
}];
