(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*Object[Protocol, QuantifyCells]*)



DefineObjectType[Object[Protocol, QuantifyCells], {
	Description -> "A protocol object that measures the cell concentration in the input cell samples with various methods. The methods that are currently supported include measuring the absorbance at 600 nm (OD600) of the 'Samples' with AbsorbanceIntensity measurement and measuring the turbidity of the 'Samples' with Nephelometry measurement.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Methods -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CellQuantificationMethodP,
			Description -> "The experimental instrumentation used to measure the cell concentration in the input cell samples. Instrumentation options include: 1) Absorbance, where the absorbance (at the provided Wavelength) of the cell sample is measured using a spectrophotometer or plate reader and then converts to QuantificationUnit using the AbsorbanceStandardCurve or AbsorbanceStandardCoefficient; 2) Nephelometry, where the scattered light attenuation of the cell sample at 653 nm is measured using a nephelometer and then converts to QuantificationUnit using the NephelometryStandardCurve or NephelometryStandardCoefficient. Note that the order of methods dictates the order of operations when the protocol is executed in the lab.",
			Category -> "General",
			Abstract -> True
		},
		Instruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				(* AbsorbanceIntensity *)
				Model[Instrument, PlateReader], Object[Instrument, PlateReader],
				Model[Instrument, Spectrophotometer], Object[Instrument, Spectrophotometer],
				(* Nephelometry *)
				Model[Instrument, Nephelometer], Object[Instrument, Nephelometer]
			],
			Description -> "For each member of Methods, the instrument used to measure the absorbance (at the provided Wavelength) or nephelometry (scattered light attenuation) for the input cell samples.",
			Category -> "General",
			IndexMatching -> Methods
		},
		RecoupSamples -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the aliquots from the corresponding input cell samples used for quantification measurement are returned to input cell samples after the protocol is completed.",
			Category -> "General"
		},
		MultiMethodAliquots -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MultiMethodAliquotsP,
			Description -> "Indicates if a single aliquot is taken from the input cell samples and reused in all quantification measurements (Shared) or if each measurement takes a new aliquot from the input cell samples (Individual).",
			Category -> "General"
		},
		QuantificationUnits -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> UnitsP[EmeraldCell / Milliliter] | UnitsP[OD600],
			Units -> None,
			Description -> "For each member of SamplesIn, the preferred unit of cell concentration to update the composition of the input sample after the quantification measurement. If the specified unit cannot be directly measured with the specified quantification Methods, StandardCurve or StandardCoefficient will be used to convert the raw experimental result. If the StandardCurve or StandardCoefficient information is neither provided nor available from the input samples' cell compositions, the unit that is directly measured with the specified quantification Methods will be used to update the composition. The final concentration used to update the composition is the mean value of any raw experimental results and any converted values from the raw experimental result in the unit of QuantificationUnit. If the QuantificationUnit is neither available from direct measurements nor convertible from any quantification measurements, the composition is updated with the directly measurable units from the quantification measurements specified in Methods. The directly measurable units for {Absorbance, Nephelometry} are {OD600, RelativeNephelometricUnit} respectively.",
			Category -> "Analysis & Reports",
			IndexMatching -> SamplesIn
		},
		AbsorbanceStandardCurves -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, StandardCurve],
			Description -> "For each member of SamplesIn, the standard curve used to convert between the raw experimental result in the unit of {OD600, AbsorbanceUnit} to the specified QuantificationUnit.",
			Category -> "Analysis & Reports",
			IndexMatching -> SamplesIn
		},
		AbsorbanceStandardCoefficients -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "For each member of SamplesIn, the factor used to multiply the raw experimental result in the unit of {OD600, AbsorbanceUnit} to the specified QuantificationUnit assuming linear relationship.",
			Category -> "Analysis & Reports",
			IndexMatching -> SamplesIn
		},
		NephelometryStandardCurves -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, StandardCurve],
			Description -> "For each member of SamplesIn, the standard curve used to convert between the raw experimental result in the unit of {RelativeNephelometricUnit} to the specified QuantificationUnit.",
			Category -> "Analysis & Reports",
			IndexMatching -> SamplesIn
		},
		NephelometryStandardCoefficients -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "For each member of SamplesIn, the factor used to multiply the raw experimental result in the unit of {RelativeNephelometricUnit} to the specified QuantificationUnit assuming linear relationship.",
			Category -> "Analysis & Reports",
			IndexMatching -> SamplesIn
		},
		AbsorbanceAssayBuffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Model[Sample],
			Description -> "For each member of SamplesIn, the solution that is added to the aliquots taken from the input cell samples or the aliquots from the previous quantification measurements (if any), where the volume of this solution added is the difference between the AbsorbanceAliquotAmount and the AbsorbanceAssayVolume.",
			Category -> "Aliquoting",
			IndexMatching -> SamplesIn
		},
		AbsorbanceAliquotAmounts -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 * Milliliter] | GreaterP[0 * Milligram] | GreaterP[0 * Unit, 1 * Unit],
			Units -> None,
			Description -> "For each member of SamplesIn, the amount of the sample that is transferred from the input cell samples or the aliquots from the previous quantification measurements (if any) into aliquots.",
			Category -> "Aliquoting",
			IndexMatching -> SamplesIn
		},
		AbsorbanceAssayVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Milliliter],
			Units -> Microliter,
			Description -> "For each member of SamplesIn, the desired total volume of the aliquoted sample plus AbsorbanceAssayBuffer.",
			Category -> "Aliquoting",
			IndexMatching -> SamplesIn
		},
		AbsorbanceAliquotContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container] | Model[Container],
			Description -> "The desired type of container that is used to house the aliquot samples prior to the subsequent Absorbance measurements, with indices indicating grouping of samples in the same plates, if desired.",
			Category -> "Aliquoting"
		},
		AbsorbanceDestinationWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellPositionP | LocationPositionP,
			Description -> "The desired position in the corresponding AbsorbanceAliquotContainer in which the aliquot samples will be placed.",
			Category -> "Aliquoting"
		},
		AbsorbanceAliquotSampleStorageConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP | Disposal,
			Description -> "For each member of SamplesIn, the non-default conditions under which any unused aliquot samples generated for Absorbance measurement should be stored after the protocol is completed.",
			Category -> "Aliquoting",
			IndexMatching -> SamplesIn
		},
		NephelometryAssayBuffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Model[Sample],
			Description -> "For each member of SamplesIn, the solution that is added to the aliquots taken from the input cell samples or the aliquots from the previous quantification measurements (if any), where the volume of this solution added is the difference between the NephelometryAliquotAmount and the NephelometryAssayVolume.",
			Category -> "Aliquoting",
			IndexMatching -> SamplesIn
		},
		NephelometryAliquotAmounts -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 * Milliliter] | GreaterP[0 * Milligram] | GreaterP[0 * Unit, 1 * Unit],
			Units -> None,
			Description -> "For each member of SamplesIn, the amount of the sample that is transferred from the input cell samples or the aliquots from the previous quantification measurements (if any) into aliquots.",
			Category -> "Aliquoting",
			IndexMatching -> SamplesIn
		},
		NephelometryAssayVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Milliliter],
			Units -> Microliter,
			Description -> "For each member of SamplesIn, the desired total volume of the aliquoted sample plus NephelometryAssayBuffer.",
			Category -> "Aliquoting",
			IndexMatching -> SamplesIn
		},
		NephelometryAliquotContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container] | Model[Container],
			Description -> "The desired type of container that is used to house the aliquot samples prior to the subsequent Nephelometry measurements, with indices indicating grouping of samples in the same plates, if desired.",
			Category -> "Aliquoting"
		},
		NephelometryDestinationWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellPositionP | LocationPositionP,
			Description -> "The desired position in the corresponding NephelometryAliquotContainer in which the aliquot samples will be placed.",
			Category -> "Aliquoting"
		},
		NephelometryAliquotSampleStorageConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP | Disposal,
			Description -> "For each member of SamplesIn, the non-default conditions under which any unused aliquot samples generated for Nephelometry measurement should be stored after the protocol is completed.",
			Category -> "Aliquoting",
			IndexMatching -> SamplesIn
		},
		AbsorbanceBlanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Model[Sample],
			Description -> "For each member of SamplesIn, the source used to generate a blank sample used to account for the background signal prior to the Absorbance measurement of the cell samples of interest.",
			Category -> "Data Processing",
			IndexMatching -> SamplesIn
		},
		AbsorbanceBlankVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Microliter],
			Units -> Microliter,
			Description -> "For each member of SamplesIn, the volume of the blank that is transferred out and used for blank measurements prior to the Absorbance measurement. If AbsorbanceBlank is specified, AbsorbanceBlankVolume of Null indicates that the blanks are read inside their current containers. If AbsorbanceBlank is specified, AbsorbanceBlankVolume of a specific volume indicates the blanks are transferred to a container with the same model as the measurement container that holds the input cell samples or their aliquots for the Absorbance measurement.",
			Category -> "Data Processing",
			IndexMatching -> SamplesIn
		},
		NephelometryBlanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Model[Sample],
			Description -> "For each member of SamplesIn, the source used to generate a blank sample used to account for the background signal prior to the Nephelometry measurement of the cell samples of interest.",
			Category -> "Data Processing",
			IndexMatching -> SamplesIn
		},
		NephelometryBlankVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Microliter],
			Units -> Microliter,
			Description -> "For each member of SamplesIn, the volume of the blank that is transferred out and used for blank measurements prior to the Nephelometry measurement. If NephelometryBlank is specified, NephelometryBlankVolume of Null indicates that the blanks are read inside their current containers. If NephelometryBlank is specified, NephelometryBlankVolume of a specific volume indicates the blanks are transferred to a container with the same model as the measurement container that holds the input cell samples or their aliquots for the Nephelometry measurement.",
			Category -> "Data Processing",
			IndexMatching -> SamplesIn
		},
		AbsorbanceAcquisitionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "Indicates the temperature the cell samples is held at during data acquisition within the absorbance instrument.",
			Category -> "Sample Handling"
		},
		AbsorbanceEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The length of time for which the cell samples is held at the requested temperature within the absorbance instrument before data acquisition.",
			Category -> "Sample Handling"
		},
		AbsorbanceTargetCarbonDioxideLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The target amount of carbon dioxide in the atmosphere in the plate reader chamber.",
			Category -> "Sample Handling"
		},
		AbsorbanceTargetOxygenLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The target amount of oxygen in the atmosphere in the plate reader chamber. If specified, nitrogen gas is pumped into the chamber to force oxygen in ambient air out of the chamber until the desired level is reached.",
			Category -> "Sample Handling"
		},
		AbsorbanceAtmosphereEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The length of time for which the samples equilibrate at the requested oxygen and carbon dioxide level before absorbance measurement.",
			Category -> "Sample Handling"
		},
		NephelometryAcquisitionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "Indicates the temperature the cell samples is held at during data acquisition within the nephelometer instrument.",
			Category -> "Sample Handling"
		},
		NephelometryEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The length of time for which the cell samples is held at the requested temperature within the nephelometer instrument before data acquisition.",
			Category -> "Sample Handling"
		},
		NephelometryTargetCarbonDioxideLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The target amount of carbon dioxide in the atmosphere in the plate reader chamber.",
			Category -> "Sample Handling"
		},
		NephelometryTargetOxygenLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The target amount of oxygen in the atmosphere in the plate reader chamber. If specified, nitrogen gas is pumped into the chamber to force oxygen in ambient air out of the chamber until the desired level is reached.",
			Category -> "Sample Handling"
		},
		NephelometryAtmosphereEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The length of time for which the samples equilibrate at the requested oxygen and carbon dioxide level before nephelometry measurement.",
			Category -> "Sample Handling"
		},
		NumberOfReadings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times to acquire data from each input cell sample or its aliquot that is loaded into the instrument during the Absorbance measurement. Each data acquisition is performed on the same cell sample without reloading the instrument.",
			Category -> "Absorbance Measurement"
		},
		AbsorbanceMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AbsorbanceMethodP,
			Description -> "Indicates the type of vessel to be used to measure the absorbance of the input cell samples or its aliquot. PlateReaders utilize an open well container that transverses light from top to bottom. Cuvette uses a square container with transparent sides to transverse light from the front to back at a fixed path length. Microfluidic uses small channels to load samples which are then gravity-driven towards chambers where light transverse from top to bottom and measured at a fixed path length.",
			Category -> "Absorbance Measurement"
		},
		SpectralBandwidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "When using the Cuvette Method, indicates the physical size of the slit from which light passes out from the monochromator. The narrower the bandwidth, the greater the resolution in measurements.",
			Category -> "Absorbance Measurement"
		},
		Wavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the specific wavelength(s) which should be used to measure absorbance of the input cell samples or its aliquot.",
			Category -> "Absorbance Measurement",
			IndexMatching -> SamplesIn
		},
		BeamAperture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Millimeter],
			Units -> Millimeter,
			Description -> "The diameter of the opening allowing the source laser light to pass through to the cell sample. A larger BeamAperture allows more light to pass through to the sample, leading to a higher signal. A setting of 1.5 millimeters is recommended for all 384 and 96 well plates, and 2.5-3.5 millimeters for 48 or less well plates. For non-homogenous solutions, a higher BeamAperture is recommended, and for samples with a large meniscus effect, a smaller BeamAperture is recommended.",
			Category -> "Nephelometry Measurement"
		},
		BeamIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The percentage of the total amount of the laser source light passed through to reach the cell sample. For Solubility experiments, 80% is recommended, and for experiments with highly concentrated or highly turbid samples, such as those involving cells, a BeamIntensity of 10% is recommended.",
			Category -> "Nephelometry Measurement"
		},
		IntegrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The amount of time that scattered light is measured. Increasing the IntegrationTime leads to higher signal and noise intensity.",
			Category -> "Nephelometry Measurement"
		},
		QuantificationPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CellPreparationP,
			Description -> "A set of instructions specifying the measurement of cell concentration of the input samples.",
			Category -> "General",
			Developer -> True
		},
		QuantificationProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol],
				Object[Notebook, Script]
			],
			Description -> "The cell preparation protocol used to measure the cell concentration of the input samples via different methods.",
			Category -> "General",
			Developer -> True
		},
		SubprotocolsPendingEnvironmentalData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "The subprotocols that executed the different quantification methods and are pending EnvironmentalData update.",
			Category -> "General",
			Developer -> True
		}
	}
}];


