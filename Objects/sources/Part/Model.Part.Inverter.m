(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Inverter], {
	Description->"Model information for an electronic device that transforms direct current (DC) to alternating current (AC) for power supply.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		InputVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The voltage of the direct current (DC) that the Inverter accepts.",
			Category -> "Part Specifications"
		},
		OutputVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The voltage of the alternating current (AC) that the Inverter outputs.",
			Category -> "Part Specifications"
		},
		OutputWaveform -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WaveformP,
			Description -> "The shape of the alternating current (AC) that the Inverter outputs.",
			Category -> "Part Specifications"
		},
		OutputFrequency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hertz],
			Units -> Hertz,
			Description -> "The frequency of the alternating current (AC) that the Inverter outputs.",
			Category -> "Part Specifications"
		},		
		MaxPower -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Watt],
			Units -> Watt,
			Description -> "Maximum power the Inverter can reliably provide.",
			Category -> "Operating Limits"
		}				
	}
}];
