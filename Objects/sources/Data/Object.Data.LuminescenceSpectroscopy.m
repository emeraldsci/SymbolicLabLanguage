

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, LuminescenceSpectroscopy], {
	Description->"Measurements of intensity of a fluorescent signal across a range of wavelengths.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* -- Method Information -- *)
		MinEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength at which the emission spectrum recording begins.",
			Category -> "General"
		},
		MaxEmissionWavelength-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength at which the emission spectrum recording ends.",
			Category -> "General"
		},
		Gain -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "The voltage set on the PMT (photomultiplier tube) detector to amplify the detected signal during the emission scan.",
			Category -> "General",
			Abstract -> True
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
			Pattern :> DistanceP,
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
		NominalOxygenLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "The target oxygen level in the atmosphere inside the instrument set by the protocol.",
			Category -> "General",
			Abstract -> True
		},
		NominalCarbonDioxideLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "The target carbon dioxide level in the atmosphere inside the instrument set by the protocol.",
			Category -> "General",
			Abstract -> True
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
		EmissionSpectrum -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Nanometer,RLU}],
			Units -> {Meter Nano, RLU},
			Description -> "Recording of luminescence intensity of the sample vs emission wavelength.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The average temperature inside the sample chamber during spectrum acquisition.",
			Category -> "Experimental Results"
		},
		OxygenLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The average oxygen level inside the sample chamber during spectrum acquisition.",
			Category -> "Experimental Results"
		},
		CarbonDioxideLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The average carbon dioxide level inside the sample chamber during spectrum acquisition.",
			Category -> "Experimental Results"
		},
		(* -- Analysis & Reports -- *)
		PeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak picking analysis conducted on the emission spectrum.",
			Category -> "Analysis & Reports"
		},
		SmoothingAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Smoothing analysis performed on this data.",
			Category -> "Analysis & Reports"
		}
	}
}];
