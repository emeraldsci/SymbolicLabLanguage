(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Viscometer], {
	Description->"A model for viscometers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(*-- Operating Limits --*)
		MeasurementChipMinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature at which the viscometer can hold the samples during viscosity measurements in the measurement chip.",
			Category -> "Operating Limits"
		},
		MeasurementChipMaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature at which the viscometer can hold the samples during viscosity measurements in the measurement chip.",
			Category -> "Operating Limits"
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*(Micro*Liter))/Minute],
			Units -> (Micro*Liter)/Minute,
			Description -> "The minimum flow rate at which the instrument can inject sample into the measurement channel.",
			Category -> "Operating Limits"
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*(Micro*Liter))/Minute],
			Units -> Liter/Minute,
			Description -> "The maximum flow rate at which the instrument can inject sample into the measurement channel.",
			Category -> "Operating Limits"
		},
		AutosamplerSyringeMaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units-> Microliter,
			Description -> "Maximum volume of the autosampler syringe.",
			Category -> "Operating Limits"
		},
		ChipSyringeMaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units-> Microliter,
			Description -> "Maximum volume of the syringe used to inject sample into the measurement chip.",
			Category -> "Operating Limits"
		},
		InjectionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Liter*Micro],
			Units-> Liter Micro,
			Description -> "The possible volumes of sample that can be injected into the measurement chip.",
			Category -> "Instrument Specifications"
		},
		SampleTrayMinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units-> Celsius,
			Description -> "Minimum temperature of the autosampler tray where the samples in the autosampler deck are stored while awaiting measurement.",
			Category -> "Operating Limits"
		},
		SampleTrayMaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units-> Celsius,
			Description -> "Maximum temperature of the autosampler tray where the samples in the autosampler deck are stored while awaiting measurement.",
			Category -> "Operating Limits"
		},
		(*-- Instrument Specifications --*)
		MinSampleVolume -> {
			Format->Single,
			Class -> Real,
			Pattern :>GreaterP[0*Milli*Liter],
			Units->Milli*Liter,
			Description->"The minimum required sample volume needed for instrument measurement.",
			Category -> "Instrument Specifications"
		},
		MinViscosity -> {
			Format->Single,
			Class -> Real,
			Pattern :>GreaterP[0*(Pascal*Second)],
			Units->Pascal*Second,
			Description->"The minimum viscosity that can be measured with the instrument.",
			Category -> "Instrument Specifications"
		},
		MaxViscosity -> {
			Format->Single,
			Class -> Real,
			Pattern :>GreaterP[0*(Pascal*Second)],
			Units->Pascal*Second,
			Description->"The maximum viscosity that can be measured with the instrument.",
			Category -> "Instrument Specifications"
		},


		(*-- Dimensions and Positions --*)
		TubingOuterDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "Outer diameter of the tubing that connects to the instrument.",
			Category -> "Dimensions & Positions"
		}
	}
}];
