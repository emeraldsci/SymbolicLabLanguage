(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, LCMS], {
	Description->"Data object related to a Liquid Chromatography Mass Spectrometry acquisition (LCMS).  One data object is generated for each acquisition function conducted in a given injection.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MassAnalyzer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MassAnalyzerTypeP,
			Description -> "The type of the component of the mass spectrometer that performs ion separation based on mass-to-charge ratio.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Columns -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample][Data]|Object[Item][Data], (* TODO: Remove Sample after migration *)
			Description -> "The column(s) used during the experiment.",
			Category -> "General"
		},
		BufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Sample, StockSolution]
			],
			Description -> "The model of buffer A used in the experiment.",
			Category -> "General"
		},
		BufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Sample, StockSolution]
			],
			Description -> "The model of buffer B used in the experiment.",
			Category -> "General"
		},
		BufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Sample, StockSolution]
			],
			Description -> "The model of buffer C used in the experiment.",
			Category -> "General"
		},
		BufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Sample, StockSolution]
			],
			Description -> "The model of buffer D used in the experiment.",
			Category -> "General"
		},
		GradientA -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], RangeP[0*Percent, 100*Percent]},
			Units -> {Minute, Percent},
			Description -> "The percentage of buffer A at each time point where the slope changed.",
			Category -> "General",
			Abstract -> True,
			Headers -> {"% Buffer A","Time"}
		},
		GradientB -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], RangeP[0*Percent, 100*Percent]},
			Units -> {Minute, Percent},
			Description -> "The percentage of buffer B at each time point where the slope changed.",
			Category -> "General",
			Abstract -> True,
			Headers -> {"% Buffer B","Time"}
		},
		GradientC -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], RangeP[0*Percent, 100*Percent]},
			Units -> {Minute, Percent},
			Description -> "The percentage of buffer C at each time point where the slope changed.",
			Category -> "General",
			Abstract -> True,
			Headers -> {"% Buffer C","Time"}
		},
		GradientD -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], RangeP[0*Percent, 100*Percent]},
			Units -> {Minute, Percent},
			Description -> "The percentage of buffer D at each time point where the slope changed.",
			Category -> "General",
			Abstract -> True,
			Headers -> {"% Buffer D","Time"}
		},
		InjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of sample injected to the column.",
			Category -> "General"
		},
		FlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "Nominal flow rate of the pump used during the experiment.",
			Category -> "General"
		},
		MinWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "Minimum wavelenght setting for the diode array absorbance detector on the HPLC's flow cell.",
			Category -> "General"
		},
		MaxWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "Maximum wavelenght setting for the diode array absorbance detector on the HPLC's flow cell.",
			Category -> "General"
		},
		GradientStart -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "Percentage of buffer B employed at the start of a binary gradient.",
			Category -> "General"
		},
		GradientEnd -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The percentage of buffer B employed at the end of a binary gradient.",
			Category -> "General"
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Minute,
			Description -> "The time at which the binary gradient starts.",
			Category -> "General"
		},
		GradientTimeEnd -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Minute,
			Description -> "The time at which the binary gradient ends.",
			Category -> "General"
		},
		AcquisitionMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AcquisitionModeP,
			Description -> "Data acquisition functions used for this mass spectrometry analysis.",
			Category -> "General",
			Abstract -> True
		},
		IonSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonSourceP,
			Description -> "The type of ionization source used to generate gas phase ions.",
			Category -> "General",
			Abstract -> True
		},
		IonMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "Whether this mass spectrometry data was acquired in positive or negative ion mode.",
			Category -> "General",
			Abstract -> True
		},
		MinMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "Low value in the mass range for this LCMS data.",
			Category -> "General",
			Abstract -> True
		},
		MaxMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "High value in the mass range for this LCMS data.",
			Category -> "General",
			Abstract -> True
		},
		MassAnalysisStage -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Units -> None,
			Description -> "Product ion stage (MS^n) for this mass spectrometry data.  In the case of tandem mass spectrometry (n=2), the analysis is performed on ions that have been fragmented once.",
			Category -> "General"
		},
		MethodFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The method files used to conduct the LCMS experiment.",
			Category -> "General"
		},
		PrecursorIonSelectionWindow -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PPM],
			Units -> PPM,
			Description -> "Width of mass filter for parent ion selection in parts-per-million (selection window width/Nominal Mass).",
			Category -> "General"
		},
		Well -> {
			Format -> Single,
			Class -> String,
			Pattern :> WellP,
			Description -> "Well in the Autosampler where the sample was taken from.",
			Category -> "General"
		},
		ESICapillaryVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt, 1*Volt],
			Units -> Volt,
			Description -> "Voltage applied to the ESI inlet capillary.",
			Category -> "General"
		},
		SamplingConeVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt, 1*Volt],
			Units -> Volt,
			Description -> "The voltage applied as to the ion source's sampling cone.",
			Category -> "General"
		},
		SourceVoltageOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt, 1*Volt],
			Units -> Volt,
			Description -> "The voltage offset between the sampling cone and the first stage ion transfer device.",
			Category -> "General"
		},
		SourceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius, 1*Celsius],
			Units -> Celsius,
			Description -> "The temperature setting for the source block.",
			Category -> "General"
		},
		DesolvationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius, 1*Celsius],
			Units -> Celsius,
			Description -> "The temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent cluster evaporation.",
			Category -> "General"
		},
		ConeGasFlow -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Hour, (1*Liter)/Hour],
			Units -> Liter/Hour,
			Description -> "The nitrogen gas flow ejected around the sample inlet cone that is used for solvent cluster evaporation.",
			Category -> "General"
		},
		DesolvationGasFlow -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Hour, (1*Liter)/Hour],
			Units -> Liter/Hour,
			Description -> "The nitrogen gas flow ejected around the ESI capillary used for solvent evaporation.",
			Category -> "General"
		},
		CollisionVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "Voltage that can be applied to generate collision energy.",
			Category -> "General"
		},
		MassSpectra -> {
			Format -> Multiple,
			Class -> {Real, QuantityArray},
			Pattern :> {GreaterP[0*Second], QuantityArrayP[{{Gram/Mole, ArbitraryUnit}..}]},
			Units -> {Minute, {Gram/Mole, ArbitraryUnit}},
			Description -> "Mass spectra (continuum or profile data) vs. time during the course of the LCMS experiment.",
			Headers -> {"Time", "Mass Spectrum"},
			Category -> "Experimental Results"
		},
		Peaks -> {
			Format -> Multiple,
			Class -> {Real, QuantityArray},
			Pattern :> {GreaterP[0*Second], QuantityArrayP[{{Gram/Mole, ArbitraryUnit}..}]},
			Units -> {Minute, {Gram/Mole, ArbitraryUnit}},
			Description -> "Peaks (centroids) vs. time during the course of the LCMS experiment.",
			Headers -> {"Time", "Peaks (centroids)"},
			Category -> "Experimental Results"
		},
		Chromatogram -> {
			Format -> Multiple,
			Class -> {Real, QuantityArray},
			Pattern :> {GreaterP[0*Second], QuantityArrayP[{{Nano*Meter, ArbitraryUnit}..}]},
			Units -> {Minute, {Meter Nano, ArbitraryUnit}},
			Description -> "Absorbance spectra vs. time during the course of the LCMS experiment.",
			Headers -> {"Time", "Absorbance spectrum"},
			Category -> "Experimental Results"
		},
		TotalIonCurrent -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Minute, ArbitraryUnit}..}],
			Units -> {Minute, ArbitraryUnit},
			Description -> "Summed intensities of all masses across the entire mass spectrum as a function of retention time.",
			Category -> "Experimental Results"
		},
		BasePeakIntensity -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Minute, ArbitraryUnit}..}],
			Units -> {Minute, ArbitraryUnit},
			Description -> "Intensity of the most abundant ion as a function of retention time.",
			Category -> "Experimental Results"
		},
		BasePeakMass -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Minute, Gram/Mole}..}],
			Units -> {Minute, Gram/Mole},
			Description -> "Mass to charge ratio of the most abundant mass as a function of retention time.",
			Category -> "Experimental Results"
		},
		NominalPrecursorIonMass -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Minute, Gram/Mole}..}],
			Units -> {Minute, Gram/Mole},
			Description -> "The nominal mass of ion selected for fragmentation for each tandem mass spectrum as a function of retention time.",
			Category -> "Experimental Results"
		},
		MinPrecursorIonSelectionMass -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Minute, Gram/Mole}..}],
			Units -> {Minute, Gram/Mole},
			Description -> "Low value of mass selection window for ions to be fragmented in each tandem mass spectrum as a function of retention time.",
			Category -> "Experimental Results"
		},
		MaxPrecursorIonSelectionMass -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Minute, Gram/Mole}..}],
			Units -> {Minute, Gram/Mole},
			Description -> "High value of mass selection window for ions to be fragmented in each tandem mass spectrum as a function of retention time.",
			Category -> "Experimental Results"
		},
		PrecursorIonData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, LCMS][FragmentIonData],
			Description -> "In tandem LCMS, data object that contains the precursor ions data related to this experiment.",
			Category -> "Experimental Results"
		},
		FragmentIonData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, LCMS][PrecursorIonData],
			Description -> "In tandem LCMS, data object that contains the fragment ions data related to this experiment.",
			Category -> "Experimental Results"
		}
	}
}];
