(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, Inverter], {
	Description->"Information for an electronic device that transforms direct current (DC) to alternating current (AC) for power supply.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		InputVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],InputVoltage]],
			Pattern :> GreaterP[0*Volt],
			Description -> "The voltage of the direct current (DC) that the Inverter accepts.",
			Category -> "Part Specifications"
		},
		OutputVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],OutputVoltage]],
			Pattern :> GreaterP[0*Volt],
			Description -> "The voltage of the alternating current (AC) that the Inverter outputs.",
			Category -> "Part Specifications"
		},
		OutputWaveform -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],OutputWaveform]],
			Pattern :> WaveformP,
			Description -> "The shape of the alternating current (AC) that the Inverter outputs.",
			Category -> "Part Specifications"
		},
		OutputFrequency -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],OutputFrequency]],
			Pattern :> GreaterP[0*Hertz],
			Description -> "The frequency of the alternating current (AC) that the Inverter outputs.",
			Category -> "Part Specifications"
		},		
		MaxPower -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxPower]],
			Pattern :> GreaterP[0*Watt],
			Description -> "Maximum power the Inverter can reliably provide.",
			Category -> "Operating Limits"
		}				

	}
}];
