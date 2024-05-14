(* ::Package:: *)

DefineObjectType[Model[Qualification, MeltingPointApparatus], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a melting point apparatus.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		(* Method Information *)
		MeltingPointStandards -> {
			Format -> Multiple,
			Class -> {Expression, Link},
			Pattern :> {Thermodynamic | Pharmacopeia, _Link},
			Relation -> {Null, Model[Sample]},
			Description -> "Model(s) of melting point standards with known melting point(s) that will be assayed during qualifications.",
			Headers -> {"Standard Type", "Standard Model"},
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
		Desiccate -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the sample is dried by removing water molecules from the sample via a desiccator before packing it into a melting point capillary and measuring its melting point.",
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
