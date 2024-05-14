(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, CalibrateApertureTube], {
	Description -> "A protocol that calibrates an aperture tube based on prescribed standards.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		ApertureTube -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, ApertureTube] | Object[Part, ApertureTube],
			Abstract -> True,
			Description -> "A glass tube with a small aperture near the bottom through which particles are pumped to perturb the electrical resistance within the aperture for particle sizing and counting. The diameter of the aperture used for the electrical resistance measurement dictates the accessible window for particle size measurement, which is generally 2%-80% of the ApertureDiameter.",
			Category -> "General"
		},
		ElectrolyteSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "The conductive solution used to suspend the particles to be counted and sized. The electrolyte solution generally contains an aqueous or organic solvent and an electrolyte chemical to make the solution conductive.",
			Category -> "General"
		},
		ElectrolyteSampleDilutionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The amount of the electrolyte solution to be mixed with the prepared sample(s) to create a particle suspension which is used for calibrating the aperture tube.",
			Category -> "General"
		},
		SizeStandards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The particle size standard samples with known mean diameters or volumes used for calibrating the aperture tube. These standard samples are typically NIST traceable monodisperse polystyrene beads with sizes precharacterized by other standard techniques such as optical microscopy and transmission electron microscopy (TEM).",
			Category -> "General"
		},
		SampleAmounts -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[
				GreaterEqualP[0 Milliliter],
				GreaterEqualP[0 Milligram]
			],
			Description -> "The amount of the prepared sample(s) to be mixed with the electrolyte solution to create a particle suspension which is used for calibrating the aperture tube.",
			Category -> "General"
		},
		MeasurementContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel] | Model[Container, Vessel],
			Description -> "The container that holds the sample-electrolyte solution mixture and any new samples during mixing and electrical resistance measurement.",
			Category -> "General"
		},
		RinseContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel] | Model[Container, Vessel],
			Description -> "The container that is used to collect the liquid used to rinse the aperture tube after each run.",
			Category -> "General",
			Developer -> True
		},
		ParticleSizes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Description -> "The manufacture-labelled mean diameter number for each member of SizeStandards after converted to the unit of Micrometer.",
			Category -> "General",
			Developer -> True
		},
		DefaultCalibrationConstant -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Description -> "The default calibration constant that the target aperture tube model uses to convert the voltage signals measured during the sample run of ExperimentCoulterCount into the particle size signal. Please see Figure 1.4 in ExperimentCoulterCount documentation for more details.",
			Category -> "General",
			Developer -> True
		},
		(* Adding the following fields so we can use some subprocedures from Object[Protocol,CoulterCount] *)
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, CoulterCounter] | Object[Instrument, CoulterCounter],
			Description -> "The instrument that the apertube is installed in order to be calibrated.",
			Category -> "General",
			Developer -> True
		},
		(* --- Refilling --- *)
		ElectrolyteSolutionRefillVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter],
			Units -> Liter,
			Description -> "The amount of volume of electrolyte solution that is to be transferred to the ElectrolyteSolutionContainer of the coulter counter instrument.",
			Category -> "Refilling",
			Developer -> True
		},
		ElectrolyteSolutionRecurringRefillVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter],
			Units -> Liter,
			Description -> "The amount of volume of electrolyte solution that is used to refill the ElectrolyteSolutionContainer of the coulter counter instrument if it is empty.",
			Category -> "Refilling",
			Developer -> True
		},
		(* --- Placement --- *)
		ApertureTubePlacement -> {
			Format -> Single,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Part], Null},
			Description -> "Placement used to move the ApertureTube onto the specific slot of coulter counter instrument.",
			Headers -> {"ApertureTube", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		MeasurementContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to move the MeasurementContainers onto the specific slot of coulter counter instrument.",
			Headers -> {"MeasurementContainer", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		FirstMeasurementContainerPlacement -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "The placement used to move the first MeasurementContainer onto the specific slot of coulter counter instrument.",
			Headers -> {"MeasurementContainer", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		(* --- Method information --- *)
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the folder containing the protocol file with the run parameters.",
			Category -> "Method Information",
			Developer -> True
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the folder containing the data file generated at the conclusion of the experiment.",
			Category -> "Method Information",
			Developer -> True
		},
		MethodFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The names of the method files for the electrical resistance measurements of the SamplesIn in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		MethodFileFullPaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The full file paths of the method files for the electrical resistance measurements of the SamplesIn in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		DataFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The file containing the raw unprocessed data generated by the instrument.",
			Category->"General"
		},
		(* Cleaning *)
		CleaningPrepPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "The set of instructions to prepare the cleaning solution to flush the coulter counter instrument during instrument tear down.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		}
	}
}];
