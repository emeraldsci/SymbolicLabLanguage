(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, qPCR], {
	Description->"Quantitative Polymerase Chain Reaction (sometimes called Real-Time Polymerase Chain Reaction) measurements of fluorescence vs number of thermal cycles.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		(* --- Method Information --- *)
		Primers -> {
			Format -> Multiple,
			Class -> {Link, Link},
			Pattern :> {_Link, _Link},
			Relation -> {Object[Sample], Object[Sample]},
			Description -> "For each member of EmissionWavelengths, the primer pairs used to amplify target DNA sequences.",
			Headers -> {"Forward Primer", "Reverse Primer"},
			Category -> "General",
			IndexMatching -> EmissionWavelengths
		},
		Probes->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "For each member of EmissionWavelengths, the reporter probe (composed of a short, sequence-specific oligomer conjugated with a reporter and a quencher) used to quantify amplification of a specific DNA sequence.",
			Category -> "General",
			IndexMatching -> EmissionWavelengths,
			Abstract -> True
		},
		DuplexStainingDye->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Molecule]
			],
			Description -> "The dye that intercalates between base pairs of double-stranded DNA and can be used to quantify DNA amplification in a sequence-nonspecific manner.",
			Category -> "General",
			Abstract -> True
		},
		ReferenceDye -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Molecule]
			],
			Description -> "The amplification-insensitive dye used to normalize fluorescence background fluctuations during DNA quantification.",
			Category -> "General"
		},
		Well -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WellP,
			Description -> "The well in the plate from which the data were collected.",
			Category -> "General"
		},
		TemplateOligomerType -> {
			Format -> Single, 
			Class -> Expression,
			Pattern :> qPCRTemplateOligomerP,
			Description -> "The type of oligomer used as source material for this qPCR experiment. Use of RNA template implies that an RT step was done prior to amplification.",
			Category -> "General"
		},
		(* Removed PassiveReference and EndogenousControl below because they are either included or not included within any given well but will never be the SOLE focus of a well *)
		(* qPCRDataTypeP = StandardCurve | Analyte | Blank *)
		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> qPCRDataTypeP,
			Description -> "The category of data. Examples include StandardCurve, Analyte, and Blank.",
			Category -> "General",
			Abstract -> True
		},
		Dilution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1, Inclusive->Right],
			Description -> "For standard curve data, the multiple by which the standard sample (SamplesIn) has been diluted to generate these data.",
			Category -> "General",
			Abstract -> True
		},
	
		(* One data object contains the entire readout from a single well in a plate (basically, what you would see if you clicked on that well in the analysis software). *)
		(* Index matching these fields to EmissionWavelength as that is the most relevant parameter to analysis of a given fluorescence "channel" *)
		
		(* qPCR data objects have an overall DataType (Analyte, Standard, Blank) and a type for each curve (primary target, end. control, passive reference). 
		A given sample well can include one or both of EndogenousControl and PassiveReference in addition to having a primary thing being amplified. 
		Use 'PrimaryAmplicon' to refer to the target(s) of a given well because it would be confusing to reuse 'Analyte' *)
		AmplificationCurveTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> qPCRCurveTypeP,
			Description -> "For each member of EmissionWavelengths, the category of amplification curve data. Examples include PrimaryAmplicon, EndogenousControl, PassiveReference, and Unused.",
			Category -> "Data Processing",
			IndexMatching -> EmissionWavelengths
		},
		ExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "For each member of EmissionWavelengths, the wavelengths of the excitation filters used to illuminate the well.",
			Category -> "General",
			IndexMatching -> EmissionWavelengths
		},
		EmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The wavelengths of the emission filters used to collect amplification curve data.",
			Category -> "General"
		},
		
		(* --- Experimental Results --- *)		
		AmplificationCurves -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{None,RFU}],
			Units -> {None, RFU},
			Description -> "For each member of EmissionWavelengths, the curve of fluorescence vs cycle as measured at each cycle of PCR amplification, normalized to the passive reference amplification curve if available.",
			Category -> "Experimental Results",
			IndexMatching -> EmissionWavelengths
		},
		AmplificationReadTemperature -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{None,Celsius}],
			Units -> {None, Celsius},
			Description -> "The PCR block temperature at the time of fluorescence data collection during each cycle of PCR amplification.",
			Category -> "Experimental Results"
		},
		MeltingCurves -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Celsius,RFU}],
			Units -> {Celsius, RFU},
			Description -> "For each member of EmissionWavelengths, the curve of fluorescence vs temperature as measured during a temperature sweep peformed after PCR amplification is complete, normalized to the passive reference melting curve if available. When using only one primer pair, this curve can be used to assess whether the primers produced a single, specific amplicon.",
			Category -> "Experimental Results",
			IndexMatching -> EmissionWavelengths
		},
		
		(* --- Data Processing --- *)
		RawAmplificationCurves -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{None,RFU}],
			Units -> {None, RFU},
			Description -> "For each member of EmissionWavelengths, the raw (non normalized) curve of fluorescence vs cycle as measured at each cycle of PCR amplification (only populated if amplification curves are normalized to a passive reference dye).",
			Category -> "Data Processing",
			IndexMatching -> EmissionWavelengths
		},
		RawMeltingCurves -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Celsius,RFU}],
			Units -> {Celsius, RFU},
			Description -> "For each member of EmissionWavelengths, the raw (non normalized) curve of fluorescence vs temperature as measured during a temperature sweep peformed after PCR amplification is complete (only populated if melting curves are normalized to a passive reference dye).",
			Category -> "Data Processing",
			IndexMatching -> EmissionWavelengths
		},
		(* --- Analysis & Reports --- *)
		QuantificationCycleAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The analysis object(s) containing the quantification cycle calculation results.",
			Category -> "Analysis & Reports"
		},
		MeltingPointAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The analysis object(s) containing the calculations of the melting point of the samples.",
			Category -> "Analysis & Reports"
		},
		CopyNumberAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis,CopyNumber][Data],
			Description -> "The analysis object(s) containing the copy number calculation results. Each copy number is determined from a standard curve of quantification cycle vs Log10 copy number.",
			Category -> "Analysis & Reports"
		}




		(* ========== Deprecated fields - Pre-funtopia ========== *)
		
		(*ReportingMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> qPCRReportingMethodP,patter
			Description -> "The method by which fluorescence was produced during the PCR reaction, allowing for quantification of copy number.",
			Category -> "General"
		},
		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength of the excitation filter used to illuminate the samples.",
			Category -> "General",
			Abstract -> True
		},
		EmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength of the emission filter used to collect amplification curve data.",
			Category -> "General",
			Abstract -> True
		},
		Reporter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Reporter dye employed in the experiment and used to readout fluorescence levels.",
			Category -> "General",
			Abstract -> True
		},
		Quencher -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Quencher dye used to extinguish the fluorescent signal in this data.",
			Category -> "General",
			Abstract -> True
		},
		PlateModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Plate],
			Description -> "The model of the plate containing the samples used in the experiment.",
			Category -> "General"
		},
		BufferModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample, StockSolution],
				Model[Sample]
			],
			Description -> "The model of buffer used in the experiment.",
			Category -> "General"
		},
		AmplificationCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Cycle,RFU}],
			Units -> {Cycle, RFU},
			Description -> "The curve of cycle vs RFU detected at each cycle during the qPCR run, normalized to the passive reference amplification curve.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		RawAmplificationCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Cycle,RFU}],
			Units -> {Cycle, RFU},
			Description -> "The curve of cycle vs RFU detected at each cycle during the qPCR run.",
			Category -> "Data Processing",
			Abstract -> True
		},
		PassiveReference -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, qPCR][AnalyteData],
			Description -> "The passive reference fluoresence data used to normalize for non-PCR fluoresence.",
			Category -> "Data Processing"
		},
		AnalyteData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, qPCR][PassiveReference],
			Description -> "A relation to the experimental data generated in conjunction with this passive reference data.",
			Category -> "Data Processing"
		},
		QuantificationCycle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Cycle,1 Cycle],
			Units -> Cycle,
			Description -> "The cycle at which amplification fluorescence can be detected above background fluorescence, defined according to the Cq calculation method.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		QuantificationCycleStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Cycle,1 Cycle],
			Units -> Cycle,
			Description -> "The error associated with calculating the Cq value from the amplification curve.",
			Category -> "Analysis & Reports"
		},
		QuantificationCycleDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Cycle],
			Description -> "The statistical distribution of the calculated Cq value.",
			Category -> "Analysis & Reports"
		},
		AmplificationCurveFitSource -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The fit to the amplification curve used to calculate the Cq.",
			Category -> "Quantification Cycle"
		},
		QuantificationCycleFit -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[QuantificationCycleFitSource]}, BestFitFunction /. Download[LastOrDefault[Field[QuantificationCycleFitSource]]]],
			Pattern :> _Function,
			Description -> "The best fit function describing the relationship between actual copy number and Cq value.",
			Category -> "Analysis & Reports"
		},
		QuantificationCycleFitSource -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The fit to the standard curve function of Actual Copy Number vs Cq.",
			Category -> "Analysis & Reports"
		},
		CopyNumber -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "The calculated number of copies in the starting qPCR reaction calculated using the best fit line to the standard curve and the Cq value.",
			Category -> "Copy Number"
		},
		CopyNumberStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "The error associated with calculating the CopyNumber.",
			Category -> "Copy Number"
		},
		CopyNumberDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?DistributionParameterQ,
			Description -> "The distribution of the calculated copy number value.",
			Category -> "Copy Number"
		},
		CopyNumberFit -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[CopyNumberFitSource]}, BestFitFunction /. Download[LastOrDefault[Field[CopyNumberFitSource]]]],
			Pattern :> _Function,
			Description -> "The best fit function describing the curve found by plotting actual copy number versus calculated copy number.",
			Category -> "Copy Number"
		},
		CopyNumberFitSource -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The fit to the standard curve function of Actual Copy Number vs Calculated Copy Number.",
			Category -> "Copy Number"
		},
		StandardCurveAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Analyses that used this data to generate a standard curve relating known template copy number to fluorescence.",
			Category -> "Standard Curve"
		}*)
	}
}];
