

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, FluorescenceSpectroscopy], {
	Description->"Measurements of intensity of a fluorescent signal across a range of wavelengths.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength of the light that is used to excite the sample.",
			Category -> "General"
		},
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
		MinExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength at which excitation of the sample begins.",
			Category -> "General"
		},
		MaxExcitationWavelength-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength at which excitation of the sample ends.",
			Category -> "General"
		},
		EmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength at which the emitted light from the sample is recorded.",
			Category -> "General"
		},
		ExcitationScanGain -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "Voltage set on the CCD (charge-coupled device) or PMT (photomultiplier tube) detector amplifying the detected signal during the excitation scan.",
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
		EmissionScanGain -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "Voltage set on the CCD (charge-coupled device) or PMT (photomultiplier tube) detector amplifying the detected signal during the emission scan.",
			Category -> "General",
			Abstract -> True
		},
		NumberOfReadings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The number of readings taken and averaged to form a single data point.",
			Category -> "General"
		},
		FocalHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "Focal height of the objective lens when the sample is measured.",
			Category -> "General"
		},
		ReadLocation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadLocationP,
			Description -> "The side of the microplate from which the readings were taken.",
			Category -> "Fluorescence Measurement"
		},
		PositioningDelay -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The amount of time the system waited before taking measurements in order to allow for the sample in the well to settle after any shaking.",
			Category -> "General"
		},
		NominalTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "Target temperature setting for the experiment.",
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
			Class -> String,
			Pattern :> WellP,
			Description -> "The plate well of the sample at the time of measurement.",
			Category -> "General"
		},
		EmissionSpectrum -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Nanometer,RFU}],
			Units -> {Meter Nano, RFU},
			Description -> "Recording of fluorescence intensity of the sample vs emission wavelength when excited at the fixed ExcitationWavelength.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		ExcitationSpectrum -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Nanometer,RFU}],
			Units -> {Meter Nano, RFU},
			Description -> "Recording of fluorescence intensity of the sample vs excitation wavelength when emission is recorded at the fixed EmissionWavelength.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The mean recorded temperature inside the sample chamber during the course of the experiment.",
			Category -> "Experimental Results"
		},
		OxygenLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The mean recorded oxygen level inside the sample chamber during the course of the experiment.",
			Category -> "Experimental Results"
		},
		CarbonDioxideLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The mean recorded carbon dioxide level inside the sample chamber during the course of the experiment.",
			Category -> "Experimental Results"
		},
		EmissionSpectrumPeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak picking analysis conducted on the emission spectrum.",
			Category -> "Analysis & Reports"
		},
		ExcitationSpectrumPeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak picking analysis conducted on the excitation spectrum.",
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
