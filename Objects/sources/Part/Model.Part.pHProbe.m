(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, pHProbe], {
	Description->"Model information for a conductivity probe used for pH measurements of a solution.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(*--- Model Information---*)
		ProbeType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> pHProbeTypeP,
			Description -> "The type of pH measurement principle.",
			Category -> "Model Information"
		},
		(* --- Physical Properties --- *)
		ShaftDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The outer diameter of probing part.",
			Category -> "Physical Properties",
			Abstract -> True
		},	
		ShaftLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The distance from the ends of the probe.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		(* --- Operating Limits ---*)
		MinpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The minimum pH the column can handle.",
			Category -> "Operating Limits"
		},
		MaxpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The maximum pH the column can handle.",
			Category -> "Operating Limits"
		},
		MinSampleVolume->{
			Format->Single,
			Class -> Real,
			Pattern :>GreaterP[0*Milli*Liter],
			Units->Liter Milli,
			Description->"The minimum required sample volume needed for instrument measurement.",
			Category -> "Operating Limits"
		},
		MinDepth->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description->"The minimum required z distance that the probe needs to be submerged for the measurement.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature the probe can perform a measurement at.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature the probe can perform a measurement at.",
			Category -> "Operating Limits"
		}
	}
}];
