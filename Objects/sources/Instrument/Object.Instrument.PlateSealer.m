

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, PlateSealer],{
	Description->"Device that uses heat and pressure to apply a membrane over assay plates to securely close the wells and prevent sample evaporation.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{

		TemperatureActivated->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"High temperature is used to heat an adhesive membrane placed over an assay plate.",
			Category->"Instrument Specifications"
		},
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedPlateSealer],
			Description -> "The liquid handler that connects to this plate sealer.",
			Category -> "Integrations"
		},
		(* Sealer properties*)
		MinTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern:>GreaterP[0*Kelvin],
			Description->"Minimum temperature used to heat an adhesive membrane placed over an assay plate.",
			Category->"Operating Limits"
		},

		MaxTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern:>GreaterP[0*Kelvin],
			Description->"Maximum temperature used to heat an adhesive membrane placed over an assay plate.",
			Category->"Operating Limits"
		},

		MinDuration->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinDuration]],
			Pattern:>GreaterP[0.5*Second],
			Description->"Minimum length of time that can be used to seal a plate.",
			Category->"Operating Limits"
		},

		MaxDuration->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxDuration]],
			Pattern:>GreaterP[10*Second],
			Description->"Maximum length of time that can be used to seal a plate.",
			Category->"Operating Limits"
		}
	}
}];