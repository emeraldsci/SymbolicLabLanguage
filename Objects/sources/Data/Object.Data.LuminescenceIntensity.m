

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, LuminescenceIntensity], {
	Description->"Measurements of intensity of a luminescence emission at a fixed wavelength.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* -- Method Information -- *)
		EmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelengths at which luminescence emitted from the samples is measured.",
			Category -> "General",
			Abstract -> True
		},
		DualEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength at which luminescence emitted from the sample is measured with the secondary detector (simultaneous to the measurement at the emission wavelength done by the primary detector).",
			Category -> "General",
			Abstract -> True
		},
		Gains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "For each member of EmissionWavelengths, the voltage set on the PMT (photomultiplier tube) detector to amplify the detected signal during the emission scan.",
			IndexMatching -> EmissionWavelengths,
			Category -> "General"
		},
		DualEmissionGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "For each member of DualEmissionWavelengths, the voltage set on the PMT (photomultiplier tube) detector to amplify the detected signal during the emission scan.",
			IndexMatching -> DualEmissionWavelengths,
			Category -> "General"
		},
		IntegrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Second,
			Description -> "The amount of time over which luminescence measurements is integrated.",
			Category -> "General"
		},
		FocalHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter*Milli],
			Units -> Meter Milli,
			Description -> "The distance from the bottom of the plate carrier to the focal point.",
			Category -> "General"
		},
		ReadLocation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadLocationP,
			Description -> "The position of the optic used to measure luminescence (above the plate or one below the plate).",
			Category -> "General"
		},
		PositioningDelay -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The amount of time the system waits before taking measurements in order to allow for the sample to settle after it has moved into the measurement position.",
			Category -> "General"
		},
		NominalTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The desired temperature of the sample chamber during the experimental run.",
			Category -> "General"
		},
		Well -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WellP,
			Description -> "The plate well of the sample at the time of its measurement.",
			Category -> "General",
			Abstract -> True
		},
		InjectionSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample][Data],
			Description -> "The samples that were injected into the well.",
			Category -> "General"
		},
		InjectionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter*Micro],
			Units -> Liter Micro,
			Description -> "For each member of InjectionSamples, the volume of the samples injected into the well.",
			IndexMatching -> InjectionSamples,
			Category -> "General"
		},
		InjectionFlowRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*(Liter*Micro))/Second],
			Units -> (Liter Micro)/Second,
			Description ->"For each member of InjectionSamples, the flow rate at which the sample was added to the well.",
			IndexMatching -> InjectionSamples,
			Category -> "General"
		},
		(* -- Experimental Results -- *)
		Intensities -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[RLU],
			Units -> RLU,
			Description -> "For each member of EmissionWavelengths, the measured luminescence intensity value.",
			Category -> "Experimental Results",
			IndexMatching -> EmissionWavelengths,
			Abstract -> True
		},
		DualEmissionIntensities -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[RLU],
			Units -> RLU,
			Description -> "For each member of DualEmissionWavelengths, the measured luminescence intensity value.",
			Category -> "Experimental Results",
			IndexMatching -> DualEmissionWavelengths,
			Abstract -> True
		},
		DetectorRangeExceeded -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if any of the recorded intensities maxed out the instrument's detector.",
			Category -> "Experimental Results"
		},
		InvalidValuesExcluded -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if any of the recorded intensities are below 0 RFU and have been deleted from the final result.",
			Category -> "Experimental Results"
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature reading inside the sample chamber at the time of acquisition.",
			Category -> "Experimental Results"
		}
	}
}];
