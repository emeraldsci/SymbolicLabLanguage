(* ::Package:: *)

DefineObjectType[Model[Qualification,NMR], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of an NMR spectrometer.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
	
		(* Method Information *)
		NMRProbe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,NMRProbe],
			Description -> "The part of the NMR that will be used to excite nuclear spins and detect the signals.",
			Category -> "General"
		},
		QualificationSamples -> {
			Format -> Multiple,
			Class -> Link,
			Relation -> Model[Sample],
			Pattern :> _Link,
			Description -> "The reference chemicals that will be analyzed by the NMR.",
			Category -> "General"
		},
		Nuclei -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> NucleusP,
			Description -> "For each member of QualificationSamples, the nucleus that will be detected.",
			Category -> "General"
		},
		Tests -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> NMRTestP,
			Description -> "For each member of QualificationSamples, the test that will be run on the data.",
			Category -> "General"
		},
		Programs -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> NMRParametersP,
			IndexMatching -> QualificationSamples,
			Description -> "For each member of QualificationSamples, the name of the program to use to specify acquisition and processing parameters.",
			Category -> "General"
		},
		DeuteratedSolvents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			IndexMatching -> QualificationSamples,
			Description -> "For each member of QualificationSamples, the deuterated solvent used by the NMR to establish a lock signal.",
			Category -> "General"
		},
		SpinningFrequencies -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units->Hertz,
			IndexMatching -> QualificationSamples,
			Description -> "For each member of QualificationSamples, the rate at which the tube spinner will be rotated.",
			Category -> "General"
		},
		SpectralDomains -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {UnitsP[PPM], UnitsP[PPM]},
			Units -> {PPM, PPM},
			Headers -> {"Minimum Chemical Shift", "Maximum Chemical Shift"},
			Description -> "For each member of QualificationSamples, the region of interest in the resulting spectrum.",
			Category -> "General"
		},
		MinSignalToNoise ->  {
			Format -> Multiple,
			Class -> {Nucleus->String, SignalToNoise->Real},
			Pattern :> {Nucleus->NucleusP, SignalToNoise->GreaterP[0]},
			Description -> "For each nucleus being tested for detection sensitivity, the minimum acceptable signal to noise ratio.",
			Category -> "Sensitivity Test"
		},							
		MaxWidths -> {
			Format -> Multiple,
			Class -> {Nucleus->String, SpinningFrequency->Integer, PercentPeakHeight->Real, MaxWidth->Real},
			Pattern:> {Nucleus->NucleusP, SpinningFrequency->GreaterEqualP[0], PercentPeakHeight->RangeP[0,100,Inclusive->Right], MaxWidth->GreaterP[0]},
			Units -> {Nucleus->None, SpinningFrequency->Hertz, PercentPeakHeight->Percent, MaxWidth->Hertz},
			Description -> "For each detection nucleus and spinning frequency being tested for lineshape, the maximum acceptable width of the measured peak at various percentages of peak height.",
			Category -> "Lineshape Test"
		}			 																																																																								 																																																																						
	}
}];
