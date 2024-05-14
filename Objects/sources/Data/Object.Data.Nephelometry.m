(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Nephelometry], {
	Description->"Measurements of the intensity of scattered light generated by a nephelometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Method -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> NephelometryMethodTypeP,
			Description->"The type of experiment nephelometric measurements are collected for. CellCount involves measuring the amount of scattered light from cells suspended in solution in order to quantify the number of cells in solution. CellCountParameterizaton involves measuring the amount of scattered light from a series of diluted samples from a cell culture, and quantifying the cells by another method, such as making titers, plating, incubating, and counting colonies, or by counting with a microscope. A standard curve is then created with the data to relate cell count to nephelometry readings for future cell count quantification. For the method Solubility, scattered light from suspended particles in solution will be measured, at a single time point or over a time period. Reagents can be injected into the samples to study their effects on solubility, and dilutions can be performed to determine the point of saturation.",
			Category -> "General",
			Abstract -> True
		},
		NominalTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The target temperature on the instrument set by the protocol.",
			Category -> "General",
			Abstract -> True
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
		Wavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength of the light source that the sample was illuminated at when data was acquired.",
			Category -> "General"
		},
		BeamAperture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The diameter of the opening that allows the source laser light to pass through to the sample when the reading was taken.",
			Category -> "General"
		},
		BeamIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The percentage of the total amount of the laser source light passed through to hit the sample during the measurement.",
			Category -> "General"
		},
		SettlingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The delay time after the instrument moved to a well position before it began taking readings.",
			Category -> "General"
		},
		PlateModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Plate],
			Description -> "The model of the plate containing the sample for which this data was recorded.",
			Category -> "General"
		},
		Wells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "For each member of Dilutions, the well number from which the measurement(s) were recorded.",
			Category -> "General",
			IndexMatching -> Dilutions,
			Abstract -> True
		},
		Diluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The sample that the material being analyzed was diluted in.",
			Category -> "General",
			Abstract -> True
		},
		Dilutions -> {
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]},
			Units -> {Microliter, Microliter},
			Description -> "The collection of dilutions performed on the sample before measuring scattered light. This is the volume of the sample and the volume of the diluent that were mixed together for each concentration in the dilution series.",
			Headers -> {"Sample Volume", "Diluent Volume"},
			Category -> "General"
		},
		AssayPositions->{
			Format->Multiple,
			Class->String,
			Pattern:>WellPositionP,
			Description->"For each member of the dilution curve, the well position of the sample in the measurement plate.",
			Category->"Sample Loading"
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



		Turbidities -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0*RelativeNephelometricUnit],
			Units -> RelativeNephelometricUnit,
			Description -> "For each member of Dilutions, the turbidity as measured by the nephelometer, with the blank or empty turbidity measurement subtracted (if available).",
			IndexMatching -> Dilutions,
			Category -> "Experimental Results"
		},
		Temperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of Dilutions, the temperature in the instrument's sample compartment when the turbidity measurement was recorded.",
			IndexMatching -> Dilutions,
			Category -> "Experimental Results"
		},
		InputDilutedConcentrations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> ConcentrationP,
			Units -> Micromolar,
			Description -> "For each member of Dilutions, the concentration of the analyte in the sample.",
			IndexMatching -> Dilutions,
			Category -> "Experimental Results"
		},
		DilutionFactors-> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "For each member of Dilutions, the dilution factors of the undiluted sample and diluted samples that were measured.",
			IndexMatching -> Dilutions,
			Category -> "Experimental Results"
		},

		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Empty|Blank|Analyte,
			Description -> "Whether this data represents an empty plate, blank, or analyte nephelometry readings. Empty is a measurement of the scattered light from the container with nothing in the well. Blank is a measurement of the scattered light from the container and the blank sample, usually the main solvent or media without analyte. Analyte is a measurement of the scattered light from a sample of interest, from which calculations and analysis about the sample can be made.",
			Category -> "Data Processing"
		},
		UnblankedTurbidities -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*RelativeNephelometricUnit],
			Units -> RelativeNephelometricUnit,
			Description -> "For each member of Dilutions, the raw, unblanked turbidity measurements without the blank or empty turbidity measurement subtracted.",
			IndexMatching -> Dilutions,
			Category -> "Data Processing",
			Abstract -> True
		},
		BlankTurbidity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RelativeNephelometricUnit],
			Units -> RelativeNephelometricUnit,
			Description -> "The turbidity measurement for a well containing a blank solution.",
			Category -> "Data Processing",
			Abstract -> True
		},
		Blank -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The blank solution used to make a blank measurement without sample in the well.",
			Category -> "Data Processing",
			Abstract -> True
		},
		BlankData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Nephelometry],
			Description -> "The data for the blank sample used to subtract the background signal from this data.",
			Category -> "Data Processing"
		},


		Analyte -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> IdentityModelTypeP,
			Description -> "The substance whose solubility or cell count is measured in this data.",
			Category -> "Analysis & Reports"
		},
		InputConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> ConcentrationP,
			Units -> Micromolar,
			Description -> "The concentration of the analyte in the original source sample recorded at the time the experiment was enqueued.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		InputMassConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Liter],
			Units -> Microgram/Milliliter,
			Description -> "The calculated mass of the analyte divided by the volume of the mixture in the original source sample recorded at the time the experiment was enqueued.",
			Category -> "Analysis & Reports"
		},
		InputDilutedMassConcentrations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Liter],
			Units -> Microgram/Milliliter,
			Description -> "For each member of Dilutions, the calculated mass of the analyte divided by the volume of the mixture recorded at the time the experiment was enqueued.",
			IndexMatching -> Dilutions,
			Category -> "Analysis & Reports"
		},
		CellCount -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Cell],
			Units -> Cell/Milliliter,
			Description -> "The number of cells in the original source sample.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		DilutedCellCounts -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Cell],
			Units -> Cell/Milliliter,
			Description -> "For each member of Dilutions, the number of cells in the diluted sample in the read plate.",
			IndexMatching -> Dilutions,
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		QuantificationAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis][Reference]
			],
			Description -> "Quantification of a sample that uses this nephelometry data as source data.",
			Category -> "Analysis & Reports"
		}
	}
}];