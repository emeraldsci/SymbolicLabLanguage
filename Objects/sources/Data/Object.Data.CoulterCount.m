(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, CoulterCount], {
	Description -> "Constant-current electrical resistance measurements of a sample that register a series of voltage pulses for determining the particle count and size distribution performed on a coulter counter instrument.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(*------------------------------General------------------------------*)
		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Blank | Standard | Analyte, (* Blank|Standard|Analyte *)
			Description -> "Indicates whether this data was performed on a blank sample with electrolyte solution only, a particle size standard, or analyte sample.",
			Category -> "General"
		}, (* Blank, control, or analyte reading *)
		DilutionSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample][Data],
			Description -> "Diluted samples that were directly assayed to generate this data.",
			Category -> "General"
		},
		SystemSuitabilityError -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if any RepeatedMeasuredSuitabilityParticleSizes do not match SuitabilityParticleSizes within SystemSuitabilityTolerance in the protocol object that generated this data.",
			Category -> "System Suitability Check"
		},
		Oversaturated -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the particle concentration of the sample that was assayed to generate this data is too high that would induce coincident particle passage effect (multiple particles passing through the aperture of the ApertureTube at approximately the same time to be registered as one larger particle) that impairs the counting and sizing accuracy.",
			Category -> "General"
		},
		ElectrolyteSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "The conductive solution used to suspend the particles to be counted and sized in the SamplesIn or DilutionSample that was directly assayed to generate this data. The electrolyte solution generally contains an aqueous or organic solvent and an electrolyte chemical to make the solution conductive.",
			Category -> "General"
		},
		ApertureDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Micrometer],
			Units -> Micrometer,
			Description -> "The diameter of the aperture used during the measurement that generated this data, which dictates the accessible size window for particle size measurement, which is generally 2%-80% of the ApertureDiameter.",
			Category -> "General"
		},
		ApertureCurrent -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Microampere],
			Units -> Microampere,
			Description -> "The value of the constant current that passes through the aperture of the ApertureTube during the measurement that generated this data in order to measure the momentary electrical resistance change per particle passage through the aperture of the ApertureTube.",
			Category -> "General"
		},
		Gain -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "The amplification factor applied to the recorded voltage pulse during the measurement that generated this data.",
			Category -> "General"
		},
		StopCondition -> {
			Format -> Single,
			Class -> {Expression, Expression},
			Pattern :> {
				CoulterCounterStopConditionP,
				Alternatives[
					GreaterP[0 Second],
					GreaterP[0 Microliter],
					GreaterP[0, 1]
				]
			},
			Headers -> {"Stop Condition", "Target Value"},
			Units -> {None, None},
			Relation -> {Null, Null},
			Description -> "Parameters describing if the measurement that generated this data was concluded based on the target Time, Volume, TotalCount, or ModalCount. In Time mode the measurement is performed until RunTime has elapsed. In Volume mode the measurement is performed until RunVolume has passed through the aperture of the ApertureTube. In TotalCount mode the measurement is performed until TotalCount of particles are counted in total. In ModalCount mode the measurement is performed until number of particles with sizes that appear most frequently exceeds ModalCount.",
			Category -> "General"
		},
		NumberOfReadings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The number of times to repeat identical measurements on each measurement-ready sample that is loaded into the instrument. Note the subtlety between this field and NumberOfReplicates. NumberOfReplicates field describes number of parallel measurement-ready samples to prepare from each member of SamplesIn, while NumberOfReadings field describes number of analysis measurements to run on each of the measurement-ready sample(s) after loading into the instrument.",
			Category -> "General"
		},
		(*------------------------------Experimental Results------------------------------*)
		RunTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "Duration of time that has elapsed when performing all measurements specified by NumberOfReadings that generated this data.",
			Category -> "Experimental Results"
		},
		RunVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of the measurement sample that has passed through the aperture of the ApertureTube by the end of all measurements specified by NumberOfReadings that generated this data.",
			Category -> "Experimental Results"
		},
		FlowRate -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Second, Microliter / Second}..}],
			Units -> {Second, Microliter / Second},
			Description -> "The volume of the sample pumped through the aperture tube per unit time monitored in the form of {Time, Flow Rate} during all measurements specified by NumberOfReadings that generated this data. Flow rate too high at certain time point may indicate air bubbles into the system. Flow rate too low at certain time point may indicate blockage of the aperture.",
			Category -> "Experimental Results"
		},
		CountRate -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Second, 1 / Second}..}],
			Description -> "The number of the particles that are pumped to pass through the aperture of the ApertureTube tube per unit time monitored in the form of {Time, Count Rate} during all measurements specified by NumberOfReadings that generated this data. Count rate too high at certain time point may indicate air bubbles into the system. Count rate too low at certain time point may indicate blockage of the aperture.",
			Category -> "Experimental Results"
		},
		ApertureResistance -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Second, Kiloohm}..}],
			Description -> "The resistance change of the aperture across the internal and external electrodes monitored in the form of {Time, Resistance} during all measurements specified by NumberOfReadings that generated this data.",
			Category -> "Experimental Results"
		},
		VoltagePulses -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Second, Volt, Millisecond}..}],
			Description -> "Parameters of the voltage pulses recorded by the electronics during all measurements specified by NumberOfReadings that generated this data, including the pulse height and width, in the form of {Time, Pulse Height, Pulse Width}.",
			Category -> "Experimental Results"
		}, (* Time vs Pulse Height vs Pulse Width *)
		RawTotalCount -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?NumericQ,
			Description -> "Total number of voltage pulses (particle count) registered by the electronics during all measurements specified by NumberOfReadings that generated this data with no correction for blank count and coincident effects.",
			Category -> "Experimental Results"
		},
		UnblankedTotalCount -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?NumericQ,
			Description -> "Total number of voltage pulses (particle count) registered by the electronics during all measurements specified by NumberOfReadings that generated this data with no correction for blank count.",
			Category -> "Experimental Results"
		},
		(*------------------------------Analysis & Reports------------------------------*)
		(* blank subtraction *)
		UnblankedVoltagePuleHeightDistribution -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[],
			Description -> "The distribution of the height of collected voltage pulses during all measurements specified by NumberOfReadings that generated this data in the form of {Pulse Height, Raw Count}. The pulse count in this distribution is corrected for coincident effects but not for blank count.",
			Category -> "Analysis & Reports"
		},
		UnblankedVoltagePuleWidthDistribution -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[],
			Description -> "The distribution of the width of collected voltage pulses during all measurements specified by NumberOfReadings that generated this data in the form of {Pulse Width, Raw Count}. The pulse count in this distribution is corrected for coincident effects but not for blank count.",
			Category -> "Analysis & Reports"
		},
		UnblankedVolumeDistribution -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[],
			Description -> "The distribution of the volume of particles that were counted during all measurements specified by NumberOfReadings that generated this data in the form of {Volume, Raw Count}. The particle count in this distribution is corrected for coincident effects but not for blank count.",
			Category -> "Analysis & Reports"
		},
		UnblankedDiameterDistribution -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Micrometer, None}],
			Units -> {Micrometer, None},
			Description -> "The distribution of the diameter of particles that were counted during all measurements specified by NumberOfReadings that generated this data in the form of {Diameter, Raw Count}. Particle diamter is calculated from the volume assuming that each particle is a perfect sphere. The particle count in this distribution is corrected for coincident effects but not for blank count.",
			Category -> "Analysis & Reports"
		},
		(* coincidence correction, blank subtracted *)
		VoltagePulseHeightDistribution -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[],
			Description -> "The distribution of the height of collected voltage pulses during all measurements specified by NumberOfReadings that generated this data in the form of {Pulse Height, Count} with the pulse count corrected for blank and coincident effects.",
			Category -> "Analysis & Reports"
		},
		VoltagePulseWidthDistribution -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[],
			Description -> "The distribution of the width of collected voltage pulses during all measurements specified by NumberOfReadings that generated this data in the form of {Pulse Width, Count} with the pulse count corrected for blank and coincident effects.",
			Category -> "Analysis & Reports"
		},
		VolumeDistribution -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[],
			Description -> "The distribution of the volume of particles that were counted during all measurements specified by NumberOfReadings that generated this data in the form of {Volume, Count} with the particle count corrected for blank and coincident effects.",
			Category -> "Analysis & Reports"
		},
		DiameterDistribution -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Micrometer, None}],
			Units -> {Micrometer, None},
			Description -> "The distribution of the diameter of particles that were counted during all measurements specified by NumberOfReadings that generated this data in the form of {Diameter, Count} with the particle count corrected for blank and coincident effects. Particle diamter is calculated from the volume assuming that each particle is a perfect sphere.",
			Category -> "Analysis & Reports"
		},
		DiameterPeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The analysis object to analyze peak distribution of the data stored in DiameterDistribution field.",
			Category -> "Analysis & Reports"
		},
		(* blank data *)
		BlankVoltagePulseHeightDistribution -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[],
			Description -> "The distribution of the height of collected voltage pulses from an electrolyte solution in the same MeasurementContainer with no sample added in the form of {Pulse Height, Blank Count}.",
			Category -> "Analysis & Reports"
		},
		BlankVoltagePulseWidthDistribution -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[],
			Description -> "The distribution of the width of collected voltage pulses from an electrolyte solution in the same MeasurementContainer with no sample added in the form of {Pulse Width, Blank Count}.",
			Category -> "Analysis & Reports"
		},
		BlankVolumeDistribution -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[],
			Description -> "The distribution of the volume of particles that were counted in an electrolyte solution in the same MeasurementContainer with no sample added in the form of {Volume, Blank Count}.",
			Category -> "Analysis & Reports"
		},
		BlankDiameterDistribution -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Micrometer, None}],
			Units -> {Micrometer, None},
			Description -> "The distribution of the diameter of particles that were counted in an electrolyte solution in the same MeasurementContainer with no sample added in the form of {Diameter, Blank Count}. Particle diamter is calculated from the volume assuming that each particle is a perfect sphere.",
			Category -> "Analysis & Reports"
		},
		BlankTotalCount -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?NumericQ,
			Description -> "Total number of voltage pulses (particle count) measured in an electrolyte solution in the same MeasurementContainer with no sample added.",
			Category -> "Analysis & Reports"
		},
		BlankData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, CoulterCount],
			Description -> "The data of the blank sample that was assayed to generate BlankVoltagePulseHeightDistribution, BlankVoltagePulseWidthDistribution, BlankVolumeDistribution, BlankDiameterDistribution, and BlankTotalCount.",
			Category -> "Analysis & Reports"
		},
		TotalCount -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?NumericQ,
			Description -> "Total number of voltage pulses (particle count) registered by the electronics during all measurements specified by NumberOfReadings that generated this data with corrections for blank count and coincident effects.",
			Category -> "Analysis & Reports"
		},
		AverageVolume -> {
			Format -> Single,
			Class -> Distribution,
			Pattern :> DistributionP[Millimeter^3],
			Units -> Millimeter^3,
			Description -> "The measured mean particle volume of the sample obtained from averaging over VolumeDistribution and NumberOfReadings.",
			Category -> "Analysis & Reports"
		},
		ModalDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micrometer],
			Units -> Micrometer,
			Description -> "The particle diameter that appear most frequently in the DiameterDistribution.",
			Category -> "Analysis & Reports"
		},
		AverageDiameter -> {
			Format -> Single,
			Class -> Distribution,
			Pattern :> DistributionP[Millimeter],
			Units -> Millimeter,
			Description -> "The measured mean particle diamter of the sample obtained from averaging over DiameterDistribution and NumberOfReadings.",
			Category -> "Analysis & Reports"
		},
		UnblankedConcentration -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> UnitsP[0 Particle / Milliliter] | UnitsP[0 EmeraldCell / Milliliter] | UnitsP[0 Molar] | UnitsP[0 / Milliliter],
			Units -> None,
			Description -> "The particle count per unit volume in the measurement samples that were directly loaded to the instrument to generate this data.",
			Category -> "Analysis & Reports"
		},
		Concentration -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> UnitsP[0 Particle / Milliliter] | UnitsP[0 EmeraldCell / Milliliter] | UnitsP[0 Molar] | UnitsP[0 / Milliliter],
			Units -> None,
			Description -> "The particle count per unit volume in the measurement samples that were directly loaded to the instrument to generate this data.",
			Category -> "Analysis & Reports"
		},
		DerivedConcentration -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> UnitsP[0 Particle / Milliliter] | UnitsP[0 EmeraldCell / Milliliter] | UnitsP[0 Molar] | UnitsP[0 / Milliliter],
			Units -> None,
			Description -> "The particle count per unit volume in SamplesIn calculated from TotalCount, RunVolume, SampleAmount, ElectrolyteSampleDilutionVolume, dilution factors.",
			Category -> "Analysis & Reports"
		},
		DataFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the raw unprocessed data generated by the instrument.",
			Category -> "General"
		}
	}
}];