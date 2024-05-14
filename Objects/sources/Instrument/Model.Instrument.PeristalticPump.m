

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, PeristalticPump], {
	Description->"The model for Low pressure, low volume liquid pumping devices for continuous liquid transfers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		TubingType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TubingTypeP,
			Description -> "Material type the peristaltic pump is composed of.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		DeadVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Milli,
			Description -> "Dead volume needed to fill the instrument lines.",
			Category -> "Instrument Specifications"
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "Maximum flow rate the pump can deliver.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "Minimum flow rate the pump can deliver.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		TubingInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Milli],
			Units -> Meter Milli,
			Description -> "Internal diameter of the tubing in the pump.",
			Category -> "Dimensions & Positions"
		}
	}
}];
