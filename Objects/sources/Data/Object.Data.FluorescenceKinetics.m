

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, FluorescenceKinetics], {
	Description->"Fluorescence measurements of a sample monitored over a period of time to study reaction trajectories.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "Wavelength of light used to excite the sample.",
			Category -> "General",
			Abstract -> True
		},
		EmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelengths at which fluorescence emitted from the samples is measured.",
			Category -> "General",
			Abstract -> True
		},
		DualEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelengths at which fluorescence emitted from the samples is measured.",
			Category -> "General",
			Abstract -> True
		},
		FocalHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter*Milli],
			Units -> Meter Milli,
			Description -> "The focal height of the objective lens when the sample fluorescence was measured.",
			Category -> "General"
		},
		ReadLocation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadLocationP,
			Description -> "The side of the plate from which the readings were taken.",
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
		InjectionSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample][Data],
			Description -> "The samples that were injected into the well.",
			Category -> "General"
		},
		InjectionTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "For each member of InjectionSamples, the time at which the sample was added to the well.",
			IndexMatching -> InjectionSamples,
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
		NominalTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The target temperature setting for the experiment.",
			Category -> "General"
		},
		NumberOfReadings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of readings taken and averaged to form a single data point.",
			Category -> "General"
		},
		DelayTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microsecond],
			Units -> Microsecond,
			Description -> "The amount of time allowed to pass after excitation before fluorescence measurement occurred.",
			Category -> "Fluorescence Measurement"
		},
		ReadTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microsecond],
			Units -> Microsecond,
			Description -> "The amount of time for which the fluorescence measurement reading occurred.",
			Category -> "Fluorescence Measurement"
		},
		Gains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "For each member of EmissionWavelengths, gain setting of the detector, for measurement at the emission wavelengths.",
			IndexMatching -> EmissionWavelengths,
			Category -> "General"
		},
		DualEmissionGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "For each member of DualEmissionWavelengths, the gain setting of the detector.",
			Category -> "General",
			IndexMatching -> DualEmissionWavelengths
		},
		ReadOrder -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadOrderP,
			Description -> "Indicates if this data was generated by running the reaction in isolation by recording each well one at a time in serial or was run along with the other wells in parallel.",
			Category -> "General"
		},
		Well -> {
			Format -> Single,
			Class -> String,
			Pattern :> WellP,
			Description -> "The plate well of the sample at the time of measurement.",
			Category -> "General",
			Abstract -> True
		},
		DetectionInterval -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time interval at which readings were taken during the assay.",
			Category -> "General"
		},
		RateFittingAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The data objects used to create a standard curve relating fluorescence to concentration for this object.",
			Category -> "Analysis & Reports"
		},
		EmissionTrajectories -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Second,RFU}],
			Units -> {Second, RFU},
			Description -> "Emission fluorescence readings taken as a function of time, for the configuration of excitation wavelength, emission wavelength and sensitivity.",
			Category -> "Experimental Results"
		},
		DualEmissionTrajectories -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Second,RFU}],
			Units -> {Second, RFU},
			Description -> "Emission fluorescence readings taken as a function of time, for the configuration of excitation wavelength, secondary emission wavelength and secondary sensitivity.",
			Category -> "Experimental Results"
		},
		Temperature -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Second,Celsius}],
			Units -> {Second, Celsius},
			Description -> "Temperature readings taken in the sample chamber, for the trajectories recorded.",
			Category -> "Experimental Results"
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
		}
	}
}];