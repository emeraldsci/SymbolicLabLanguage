(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Dishwasher], {
	Description->"Dishwasher for washing laboratory glassware and plasticware.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		HEPAFilteredDrying -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],HEPAFilteredDrying]],
			Pattern :> BooleanP,
			Description -> "Indicates if the washer is capable of HEPA filtered drying.",
			Category -> "Instrument Specifications"
		},
		WaterPurifier -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument,WaterPurifier],
			Description->"The water purifier that supplies water to this instrument.",
			Category -> "Instrument Specifications"
		},	
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The minimum water temperature that the washer can use to wash/rinse labware.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The maximum water temperature that the washer can use to wash/rinse labware.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Description -> "The size of space inside the dishwasher in the form of: {X Direction (Width),Y Direction (Depth),Z Direction (Height)}.",
			Category -> "Dimensions & Positions"
		}
	}
}];
