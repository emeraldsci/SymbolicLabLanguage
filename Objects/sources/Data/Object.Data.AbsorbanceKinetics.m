(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, AbsorbanceKinetics], {
	Description->"Absorbance measurements taken over a period of time in order to monitor kinetic reactions.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	(* -- Method Information -- *)
		MinWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength at which absorbance data was acquired.",
			Category -> "General"
		},
		MaxWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The maximum wavelength at which absorbance data was acquired.",
			Category -> "General"
		},
		Wavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nano*Meter],
			Units->Meter Nano,
			Description->"The wavelengths at which absorbance data was acquired.",
			Category -> "General",
			Abstract->True
		},
		NominalTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The desired temperature of the sample chamber during the experimental run.",
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
		DetectionInterval -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time interval at which readings were taken during the assay.",
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

	(* -- Experimental Results -- *)
		AbsorbanceTrajectories -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Second,AbsorbanceUnit}],
			Units -> {Second, AbsorbanceUnit},
			Description -> "For each member of Wavelengths, the measured absorbance trajectory with the blank trajectory subtracted (if available).",
			IndexMatching -> Wavelengths,
			Category -> "Experimental Results"
		},
		AbsorbanceTrajectory3D-> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :>  BigQuantityArrayP[{Second, Meter Nano, AbsorbanceUnit}],
			Units -> {Second, Meter Nano, AbsorbanceUnit},
			Description -> "The measured absorbance trajectory for each wavelength in the specified range with the corresponding blank trajectory subtracted (if available).",
			Category -> "Experimental Results",
			Abstract -> True
		},
		Temperature -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Second,Celsius}],
			Units -> {Second, Celsius},
			Description -> "Temperature readings taken in the sample chamber over the course of the absorbance measurements.",
			Category -> "Experimental Results"
		},

	(* -- Data Processing -- *)
		UnblankedAbsorbanceTrajectories -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Second,AbsorbanceUnit}],
			Units -> {Second, AbsorbanceUnit},
			Description -> "For each member of Wavelengths, the raw, unblanked absorbance trajectory.",
			IndexMatching -> Wavelengths,
			Category -> "Data Processing"
		},
		UnblankedAbsorbanceTrajectory3D-> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :>  BigQuantityArrayP[{Second, Meter Nano, AbsorbanceUnit}],
			Units -> {Second, Meter Nano, AbsorbanceUnit},
			Description -> "The raw unblanked absorbance trajectory for each wavelength in the specified range.",
			Category -> "Data Processing",
			Abstract -> True
		},
		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AbsorbanceSpectroscopyDataTypeP,
			Description -> "Indicates if this data represents a blank or an analyte absorbance reading.",
			Category -> "Data Processing"
		},
		BlankTrajectory -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, AbsorbanceKinetics],
			Description -> "The data for the blank sample used to subtract the background signal from this data.",
			Category -> "Data Processing"
		}
	}
}];
