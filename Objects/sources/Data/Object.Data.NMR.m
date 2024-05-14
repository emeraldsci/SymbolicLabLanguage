(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, NMR], {
	Description->"One dimensional measurements from nuclear magnetic resonance that provide a spectrum of chemical shift vs signal intensity of a sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		AcquisitionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description ->  "Length of time during which the NMR signal is sampled and digitized per scan.",
			Category -> "General"
		},
		RelaxationDelay -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description ->  "Length of time before the pulse and acquisition of a given scan.  In effect, this is also the length of time after the AcquisitionTime before the next scan begins.",
			Category -> "General"
		},
		Nucleus -> {
			Format -> Single,
			Class -> String,
			Pattern :> NucleusP,
			Description -> "The nucleus whose spins are being recorded in this NMR data.",
			Category -> "General",
			Abstract -> True
		},
		NumberOfScans -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Number of pulse and read cycles for this NMR data.",
			Category -> "General"
		},
		NumberOfDummyScans -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of scans performed before the receiver was turned on and data was collected.",
			Category -> "General"
		},
		Probe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, NMRProbe],
			Description -> "The part of the NMR that excited nuclear spins, detected the signal, and collected this data.",
			Category -> "General"
		},
		Frequency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hertz*Mega],
			Units -> Hertz Mega,
			Description -> "The resonance frequency at which the NMR is tuned to read.",
			Category -> "General",
			Abstract -> True
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The sample temperature at which the signal was acquired.",
			Category -> "General"
		},
		SweepWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hertz],
			Units -> Hertz,
			Description -> "Range of frequencies to be observed.",
			Category -> "General"
		},
		SpectralDomain -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {UnitsP[PPM], UnitsP[PPM]},
			Units -> {PPM, PPM},
			Headers -> {"Minimum Chemical Shift", "Maximum Chemical Shift"},
			Description -> "The range of the observed chemical shifts for this spectrum.",
			Category -> "General"
		},
		SolventModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The solvent that the material being analyzed was solubilized in.",
			Category -> "General",
			Abstract -> True
		},
		WaterSuppression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WaterSuppressionMethodP,
			Description -> "Indicates the method by which the water peak is eliminated from the spectrum.",
			Category -> "General"
		},
		ExternalStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The sample used as an external standard during the experiment. This sample stored in a sealed coaxial insert and was measrued together with SamplesIn.",
			Category -> "General"
		},
		FreeInductionDecay -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Second,ArbitraryUnit}],
			Units -> {Second, ArbitraryUnit},
			Description -> "Observable NMR signal precessing to equilibrium vs time.",
			Category -> "Experimental Results"
		},
		NMRSpectrum -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{PPM,ArbitraryUnit}],
			Units -> {PPM, ArbitraryUnit},
			Description -> "The nuclear magnetic resonance spectrum obtained by the instrument in terms of chemical shift vs signal intensity.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		NMRFrequencySpectrum -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Hertz,ArbitraryUnit}],
			Units -> {Hertz, ArbitraryUnit},
			Description -> "The nuclear magnetic resonance spectrum obtained by the instrument in terms of frequency vs signal intensity.",
			Category -> "Experimental Results"
		},
		TimedFreeInductionDecay -> {
			Format -> Multiple,
			Class -> {Real, QuantityArray},
			Pattern :> {TimeP, QuantityCoordinatesP[{Second,ArbitraryUnit}]},
			Units -> {Minute, {Second, ArbitraryUnit}},
			Headers -> {"Time from last transfer", "FID"},
			Description -> "The observable NMR signals precessing to equilibrium vs time obtained over time.",
			Category -> "Experimental Results"
		},
		TimedNMRSpectra -> {
			Format -> Multiple,
			Class -> {Real, QuantityArray},
			Pattern :> {TimeP, QuantityCoordinatesP[{PPM, ArbitraryUnit}]},
			Units -> {Minute, {PPM, ArbitraryUnit}},
			Headers -> {"Time from last transfer", "NMR Spectrum"},
			Description -> "The nuclear magnetic resonance spectra obtained over time by the instrument in terms of chemical shift vs signal intensity.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		TimedNMRFrequencySpectra -> {
			Format -> Multiple,
			Class -> {Real, QuantityArray},
			Pattern :> {TimeP, QuantityCoordinatesP[{Hertz, ArbitraryUnit}]},
			Units -> {Minute, {Hertz, ArbitraryUnit}},
			Headers -> {"Time from last transfer", "NMR Frequency Spectrum"},
			Description -> "The nuclear magnetic resonance spectra obtained over time by the instrument in terms of frequency vs signal intensity.",
			Category -> "Experimental Results"
		},
		NMRSpectrumPeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "A list of peak picking analyses conducted on this spectra.",
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
