(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, PressureSensor], {
	Description->"Model information for a pressure sensor used for in-line measurements of the hydraulic pressure of a solution.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		(* ----- Operating Limits ----- *)
		
		MinPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[-20 PSI],
			Units->PSI,
			Description->"Minimum pressure this sensor can measure.",
			Category->"Operating Limits",
			Abstract->True
		},
		
		MaxPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 PSI],
			Units->PSI,
			Description->"Maximum pressure this sensor can measure.",
			Category->"Operating Limits",
			Abstract->True
		}
	}
}];
