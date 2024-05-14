(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Maintenance, CalibrateApertureTube], {
	Description -> "A protocol that calibrates a balance based on prescribed standards.",
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
			Description -> "For each member of SizeStandards, the amount of the electrolyte solution to be mixed with the prepared sample(s) to create a particle suspension which is used for calibrating the aperture tube.",
			Category -> "General",
			IndexMatching -> SizeStandards
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
			Description -> "For each member of SizeStandards, the amount of the prepared sample(s) to be mixed with the electrolyte solution to create a particle suspension which is used for calibrating the aperture tube.",
			Category -> "General",
			IndexMatching -> SizeStandards
		},
		MeasurementContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel] | Model[Container, Vessel],
			Description -> "For each member of SizeStandards, the container that holds the sample-electrolyte solution mixture and any new samples during mixing and electrical resistance measurement.",
			Category -> "General",
			IndexMatching -> SizeStandards
		}
	}
}];
