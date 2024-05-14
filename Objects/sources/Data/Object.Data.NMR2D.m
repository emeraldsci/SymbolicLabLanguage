DefineObjectType[Object[Data, NMR2D], {
	Description->"Two dimensional measurements from nuclear magnetic resonance that provides a spectrum of chemical shift of two nuclei vs signal intensity of a sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ExperimentType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> NMR2DExperimentP,
			Description ->  "The spectroscopic method used to obtain this 2D NMR data.",
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
			Description -> "The resonance frequency at which the NMR is tuned to read the DirectNucleus.",
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
		SolventModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The solvent that the material being analyzed was solubilized in.",
			Category -> "General",
			Abstract -> True
		},
		NumberOfScans -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of pulse and read cycles that were averaged together that are applied for each directly measured free induction decay (FID).",
			Category -> "General"
		},
		NumberOfDummyScans -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of scans performed before the receiver was turned on and data was collected for each directly measured free induction decay (FID).",
			Category -> "General"
		},
		DirectNucleus -> {
			Format -> Single,
			Class -> String,
			Pattern :> NucleusP,
			Description -> "The nucleus whose spectrum is measured repeatedly and directly over the course of the collection of this data.  This is sometimes referred to as the f2 or T2 nucleus, and is displayed on the horizontal axis of the output plot.",
			Category -> "General",
			Abstract -> True
		},
		IndirectNucleus -> {
			Format -> Single,
			Class -> String,
			Pattern :> NucleusP,
			Description -> "The nucleus whose spectrum is measured through the modulation of the directly-measured 1H spectrum as a function of time rather than directly-measured. This is sometimes referred to as the f1 or T1 nucleus, and is displayed on the vertical axis of the output plot.",
			Category -> "General",
			Abstract -> True
		},
		DirectNumberOfPoints -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "The number of data points collected for each directly-measured Free Induction Decay (FID).",
			Category -> "General"
		},
		DirectAcquisitionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The length of time during which the NMR signal is sampled and digitized per scan.",
			Category -> "General"
		},
		DirectSpectralDomain -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {UnitsP[PPM], UnitsP[PPM]},
			Units -> {PPM, PPM},
			Headers -> {"Minimum Chemical Shift", "Maximum Chemical Shift"},
			Description -> "The range of the observed frequencies for the directly-observed nucleus.",
			Category -> "General"
		},

		IndirectNumberOfPoints -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "The number of directly-measured Free Induction Decays (FIDs) collected that together constitute the FIDs of the indirectly-measured nucleus.",
			Category -> "General"
		},
		IndirectSpectralDomain -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {UnitsP[PPM], UnitsP[PPM]},
			Units -> {PPM, PPM},
			Headers -> {"Minimum Chemical Shift", "Maximum Chemical Shift"},
			Description -> "The range of the observed frequencies for the indirectly-observed nucleus.",
			Category -> "General"
		},
		TOCSYMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Millisecond],
			Units -> Millisecond,
			Description -> "The duration of the spin-lock sequence prior to data collection if ExperimentType is TOCSY, HSQCTOCSY, or HMQCTOCSY.",
			Category -> "General"
		},
		SamplingMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> NMRSamplingMethodP,
			Description -> "The method of spacing the directly-measured 1H spectra.  TraditionalSampling spaces the directly-measured spectra uniformly, while NonUniformSampling varies the spacing to obtain a fuller spectrum with the same number of measurements.",
			Category -> "General"
		},
		WaterSuppression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WaterSuppressionMethodP,
			Description -> "Indicates the method by which the water peak is eliminated from the 1D spectrum collected prior to the 2D spectrum.",
			Category -> "General"
		},
		FreeInductionDecay2D -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :> BigQuantityArrayP[{Second, Second, ArbitraryUnit}],
			Units -> {Second, Second, ArbitraryUnit},
			Description -> "Observable NMR signal as a function of time in the direct and indirect options dimensions.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		NMR2DSpectrum -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :> BigQuantityArrayP[{PPM, PPM, ArbitraryUnit}],
			Units -> {PPM, PPM, ArbitraryUnit},
			Description -> "The nuclear magnetic resonance spectrum obtained by the instrument in terms of chemical shift in the direct and indirect dimensions vs signal intensity.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		FreeInductionDecay -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Second,ArbitraryUnit}],
			Units -> {Second, ArbitraryUnit},
			Description -> "Observable one-dimensional NMR signal precessing to equilibrium vs time specifically in the directly-measured dimension.",
			Category -> "Experimental Results"
		},
		NMRSpectrum -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{PPM,ArbitraryUnit}],
			Units -> {PPM, ArbitraryUnit},
			Description -> "The one-dimensional nuclear magnetic resonance spectrum obtained by the instrument in terms of chemical shift vs signal intensity specifically in the directly-measured dimension.",
			Category -> "Experimental Results"
		},
		NMRFrequencySpectrum -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Hertz,ArbitraryUnit}],
			Units -> {Hertz, ArbitraryUnit},
			Description -> "The one-dimensional nuclear magnetic resonance spectrum obtained by the instrument in terms of frequency vs signal intensity specifically in the directly-measured dimension.",
			Category -> "Experimental Results"
		},
		NMRSpectrumPeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "A list of peak picking analyses conducted on the directly-measured one-dimensional spectrum.",
			Category -> "Analysis & Reports"
		},
		Contours -> {
			Format -> Multiple,
			Class -> BigCompressed,
			Pattern :> _Tooltip,
			Description -> "The data points that comprise every intensity level for the contours of this 2D NMR spectrum.",
			Category -> "Data Processing",
			Developer -> True
		}
	}
}];
