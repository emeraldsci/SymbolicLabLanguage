(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, PressureSensor], {
	Description->"A probe used for the in-line hydraulic pressure measurements in a solution.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		MinPressure->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinPressure]],
			Pattern:>GreaterP[-20 PSI],
			Description->"Minimum pressure this sensor can measure.",
			Category->"Operating Limits"
		},
		
		MaxPressure->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxPressure]],
			Pattern:>GreaterP[0 PSI],
			Description->"Maximum pressure this sensor can measure.",
			Category->"Operating Limits",
			Abstract->True
		}
	}
}];
