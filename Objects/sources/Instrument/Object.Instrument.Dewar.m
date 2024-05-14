(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument,Dewar],{
	Description->"A protocol for a nitrogen immersion flash freezing instrument.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		LiquidNitrogenCapacity->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],LiquidNitrogenCapacity]],
			Pattern:>GreaterP[0*Liter],
			Description->"The maximum volume of liquid nitrogen that the dewar can be filled with.",
			Category->"Operating Limits"
		},
		InternalDimensions->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],InternalDimensions]],
			Pattern:>{GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter]},
			Description->"The dimensions of the space inside the liquid nitrogen dewar in the form of: {X Direction (Width),Y Direction (Depth),Z Direction (Height)}.",
			Category->"Dimensions & Positions"
		}
	}
}];