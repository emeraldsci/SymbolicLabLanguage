(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Autoclave], {
	Description->"A pressure chamber for sterilizing waste, reagents and equipment.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Modes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Modes]],
			Pattern :> {AutoclaveModeP..},
			Description -> "Type of cleaning cycles available to the autoclave.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		PostAutoclaveCoolingArea->{
			Format->Single,
			Class->Expression,
			Pattern:>{LocationPositionP, ObjectP[{Object[Container, Shelf],Object[Container, ShelvingUnit]}]},
			Description->"The location where the autoclaved samples, containers, items etc. (in their secondary container or without it) are placed after completing the autoclave cycle, in order to cool them down.",
			Category->"Instrument Specifications"
		},
		MinPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinPressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "Minimum amount of pressure the Autoclave can provide.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxPressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "Maximum amount of pressure the Autoclave can provide.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature the autoclave can reach.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature the autoclave can reach.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinCycleTime -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinCycleTime]],
			Pattern :> GreaterP[0*Minute],
			Description -> "Minimum time the autoclave can run for.",
			Category -> "Operating Limits"
		},
		MaxCycleTime -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxCycleTime]],
			Pattern :> GreaterP[0*Minute],
			Description -> "Maximum time the autoclave can run for.",
			Category -> "Operating Limits"
		},
		AirCompressorRequired -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if an air-compressor is required to add extra pressure to operate the autoclave.",
			Category -> "Operating Limits"
		},
		InternalDimensions->{
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Milli*Meter], GreaterP[0*Milli*Meter], GreaterP[0*Milli*Meter]},
			Description -> "The measurements of the internal chamber of the autoclave in the  {X (left-to-right), Y (back-to-front), Z (bottom-to-top)} directions.",
			Category -> "Dimensions & Positions"
		}
	}
}];
