(* ::Package:: *)

DefineObjectType[Model[Qualification, CoulterCounter], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a coulter counter.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Standards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The chemicals with known particle sizes or particle concentrations that are used to test the sizing and counting capability of the coulter counter instrument.",
			Category -> "General"
		},
		SampleTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (Concentration | Size),
			Description -> "For each member of Standards, indicates whether the sample is used to test the sizing capability (Size) or the counting capability (Concentration) of the coulter counter instrument.",
			Category -> "General",
			IndexMatching -> Standards
		},
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
			IndexMatching -> Standards,
			Description -> "For each member of Standards, the amount of the electrolyte solution to be mixed with the prepared sample(s) to create a particle suspension which is used for calibrating the aperture tube.",
			Category -> "General"
		},
		SampleAmounts -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[
				GreaterEqualP[0 Milliliter],
				GreaterEqualP[0 Milligram]
			],
			IndexMatching -> Standards,
			Description -> "For each member of Standards, the amount of the prepared sample(s) to be mixed with the electrolyte solution to create a particle suspension which is used for calibrating the aperture tube.",
			Category -> "General"
		},
		FlowRates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (GreaterEqualP[0 Microliter / Second] | Automatic),
			IndexMatching -> Standards,
			Description -> "For each member of Standards, the target volume of the sample-electrolyte solution mixture pumped through the aperture of the ApertureTube per unit time during the sample run.",
			Category -> "Electrical Resistance Measurement"
		}
	}
}];
