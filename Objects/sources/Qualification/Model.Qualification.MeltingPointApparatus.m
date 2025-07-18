(* ::Package:: *)

DefineObjectType[Model[Qualification, MeltingPointApparatus], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a melting point apparatus.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		(* Method Information *)
		MeltingPointStandards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Model(s) of melting point standards with known melting point(s) that will be assayed during qualifications.",
			Category -> "General",
			Abstract -> True
		},
		MeltingPointTolerance -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0 Kelvin], GreaterEqualP[0 Kelvin]},
			Description -> "The acceptable deviation of the measured melting point from the literature value of an standard. It is indicated by pair(s) of numbers. The first number in the pair represents the initial temperature of the range with an acceptable tolerance, and the second number represents the actual tolerance.",
			Units -> {Celsius, Celsius},
			Headers -> {"Initial temperature", "Tolerance"},
			Category -> "General"
		},
		MeltingPointTargets -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The literature values of the standard's melting point.",
			Category -> "General"
		},
		Desiccate -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the sample is dried by removing water molecules from the sample via a desiccator before packing it into a melting point capillary and measuring its melting point.",
			Category -> "Desiccation"
		},
		DesiccationMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DesiccationMethodP,
			Description -> "Method of drying the sample (removing water or solvent molecules from the solid sample). Options include StandardDesiccant, Vacuum, and DesiccantUnderVacuum. StandardDesiccant involves utilizing a sealed bell jar desiccator that exposes the sample to a chemical desiccant that absorbs water molecules from the exposed sample. DesiccantUnderVacuum is similar to StandardDesiccant but includes creating a vacuum inside the bell jar via pumping out the air by a vacuum pump. Vacuum just includes creating a vacuum by a vacuum pump and desiccant is NOT used inside the desiccator.",
			Category -> "Desiccation"
		},
		Grind -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the sample is ground via a grinder before packing it into a melting point capillary and measuring its melting point.",
			Category -> "Grinding"
		}
	}
}];
