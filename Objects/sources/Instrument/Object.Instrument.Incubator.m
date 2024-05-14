(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Incubator], {
	Description->"A device for culturing cells under specific environmental conditions.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		NominalCellType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CellTypeP,
			Description -> "The type of cells allowed in the incubator.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Mode -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Mode]],
			Pattern :> AutomaticP,
			Description -> "Type of incubator access.  Options include Manual or Auto (indicating robotic access).",
			Category -> "Instrument Specifications"
		},
		DefaultTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],DefaultTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The default temperature the incubator is set to maintain.",
			Category -> "Instrument Specifications"
		},
		DefaultCarbonDioxide -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],DefaultCarbonDioxide]],
			Pattern :> RangeP[0*Percent, 100*Percent],
			Description -> "The default carbon dioxide percentage the incubator is set to maintain.",
			Category -> "Instrument Specifications"
		},
		DefaultRelativeHumidity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],DefaultRelativeHumidity]],
			Pattern :> RangeP[0*Percent, 100*Percent],
			Description -> "The default relative humidity the incubator is set to maintain.",
			Category -> "Instrument Specifications"
		},
		DefaultShakingRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],DefaultShakingRate]],
			Pattern :> GreaterEqualP[0*RPM],
			Description -> "The default shaking speed the incubator is set to maintain.",
			Category -> "Instrument Specifications"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature the incubator can maintain.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature the incubator can maintain.",
			Category -> "Operating Limits"
		},
		MinCarbonDioxide -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinCarbonDioxide]],
			Pattern :> RangeP[0*Percent, 100*Percent],
			Description -> "Minimum carbon dioxide percentage the incubator can maintain.",
			Category -> "Operating Limits"
		},
		MaxCarbonDioxide -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxCarbonDioxide]],
			Pattern :> RangeP[0*Percent, 100*Percent],
			Description -> "Maximum carbon dioxide percentage the incubator can maintain.",
			Category -> "Operating Limits"
		},
		MinRelativeHumidity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinRelativeHumidity]],
			Pattern :> RangeP[0*Percent, 100*Percent],
			Description -> "Minimum relative humidity the incubator can maintain.",
			Category -> "Operating Limits"
		},
		MaxRelativeHumidity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxRelativeHumidity]],
			Pattern :> RangeP[0*Percent, 100*Percent],
			Description -> "Maximum relative humidity the incubator can maintain.",
			Category -> "Operating Limits"
		},
		MinShakingRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinShakingRate]],
			Pattern :> GreaterP[0*RPM],
			Description -> "Minimum speed the instrument can shake at.",
			Category -> "Operating Limits"
		},
		MaxShakingRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxShakingRate]],
			Pattern :> GreaterP[0*RPM],
			Description -> "Maximum speed the instrument can shake at.",
			Category -> "Operating Limits"
		},
		ShakingRadius -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ShakingRadius]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The radius of the circle traced by each shaker unit during orbital shaking.",
			Category -> "Operating Limits"
		},
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedIncubator],
			Description -> "The liquid handler that is connected to this incubator such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Description -> "The size of space inside the incubator in the form of: {X Direction (Width),Y Direction (Depth),Z Direction (Height)}.",
			Category -> "Dimensions & Positions"
		},
		TubingInnerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingInnerDiameter]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Internal diameter of the tubing connecting the CarbonDioxide in millimeters.",
			Category -> "Dimensions & Positions"
		},
		ReservoirDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform which contains the water reservoir for keeping instrument humidity.",
			Category -> "Dimensions & Positions"
		},
		ReservoirCover -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "The cap to cover the incubator's reservoir and connect it to the incubator for the purposes of regulating humidity.",
			Category -> "Dimensions & Positions"
		}

	}
}];
