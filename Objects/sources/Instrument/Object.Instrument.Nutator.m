(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Nutator], {
	Description->"Device for gentle agitation of liquids via cyclical change in inclination around a vertical axis.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Mode -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Mode]],
			Pattern :> ShakerModeP,
			Description -> "Type of shaking motion the instrument provides.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		TemperatureControl -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TemperatureControl]],
			Pattern :> Water | Air | None,
			Description -> "Type of temperature controller weither by forecd air or using a contact solution.",
			Category -> "Instrument Specifications"
		},
		MinRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinRotationRate]],
			Pattern :> GreaterP[0*RPM],
			Description -> "Minimum speed the instrument can shake at.",
			Category -> "Operating Limits"
		},
		MaxRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxRotationRate]],
			Pattern :> GreaterP[0*RPM],
			Description -> "Maximum speed the instrument can shake at.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature at which the shaker can incubate.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature at which the shaker can incubate.",
			Category -> "Operating Limits"
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Description -> "The size of space inside the shaker in the X (left-to-right), Y (back-to-front), Z (bottom-to-top)} directions.",
			Category -> "Dimensions & Positions"
		}
	}
}];
