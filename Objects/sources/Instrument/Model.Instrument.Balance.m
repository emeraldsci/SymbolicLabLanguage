(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Balance], {
	Description->"The model of a device for high precision measurement of weight.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Mode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BalanceModeP,
			Description -> "Type of measurement's the balance is capable of performing.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The smallest change in mass that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
			Category -> "Instrument Specifications"
		},
		ManufacturerRepeatability -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The variation in measurements taken under the same conditions as reported by the manufacturer.",
			Category -> "Instrument Specifications"
		},
		AllowedMaxVariation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "Maximum allowed difference between each measurement and the running average for all replicate measurements. If exceeded, the measurement should be retaken.",
			Category -> "Instrument Specifications",
			Developer -> True		
		},
		MeasureWeightPreferred -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this balance is in the preferred group of balances that the MeasureWeight protocol chooses from, when it has to decide which balance to use.",
			Category -> "Instrument Specifications",
			Developer -> True
		},			
		MinWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "Minimum mass the instrument can weigh.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "Maximum mass the instrument can weigh.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the balance.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		}
	}
}];
