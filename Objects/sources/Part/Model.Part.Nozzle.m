(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Nozzle], {
	Description->"A model for a part that takes in fluids and modifies their flow direction or characteristics as they exit.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* Dimensions & Positions *)
		NozzleLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Meter],
			Units-> Millimeter,
			Description -> "The distance between where fluids enter the nozzle and where they exit.",
			Category -> "Dimensions & Positions"
		},
		MinDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Meter],
			Units->Millimeter,
			Description -> "The diameter of the nozzle at its narrowest point.",
			Category -> "Dimensions & Positions"
		},
		MaxDiameter -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0Meter],
			Units->Millimeter,
			Description->"The diameter of the nozzle at its widest point.",
			Category->"Dimensions & Positions"
		},	
		MinShaftLength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0Meter],
			Units->Millimeter,
			Description->"The smallest achievable distance between the exit of the nozzle and its base for nozzles with adjustable bases.",
			Category->"Dimensions & Positions"
		},
		MaxShaftLength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0Meter],
			Units->Millimeter,
			Description->"The largest achievable distance between the exit of the nozzle and its base for nozzles with adjustable bases.",
			Category->"Dimensions & Positions"
		},
		MinDistance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Meter],
			Units->Millimeter,
			Description->"The minimum allowable distance between the exit of the nozzle and its target.",
			Category->"Operating Limits"
		},
		MaxDistance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Meter],
			Units->Millimeter,
			Description->"The maximum allowable distance between the exit of the nozzle and its target.",
			Category->"Operating Limits"
		}
	}
}];
