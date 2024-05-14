(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, PressureManifold], {
	Description->"A model instrument that uses positive air pressure to perform filtration and solid-phase extraction.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MinPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "The minimum pressure that the instrument can generate to drive liquid through membrane.",
			Category -> "Operating Limits"
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "The maximum pressure that the instrument can generate to drive liquid through membrane.",
			Category -> "Operating Limits"
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The minimum flow rate of tips when dispensing liquid (Applicable to Biotage Pressure+).",
			Category -> "Operating Limits"
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The maximum flow rate of the tips when dispensing liquid (Applicable to Biotage Pressure+).",
			Category -> "Operating Limits"
		},
		MaxPressureWithFlowControl -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "The maximum at which it is still possible to regulate flow rate through rotometer (Applicable to Biotage Pressure+).",
			Category -> "Operating Limits"
		}
	}
}];
