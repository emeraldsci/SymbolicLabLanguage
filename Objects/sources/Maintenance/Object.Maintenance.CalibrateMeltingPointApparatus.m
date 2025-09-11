(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, CalibrateMeltingPointApparatus], {
	Description -> "Definition of a set of parameters for a maintenance protocol that calibrates (adjusts) the measured temperatures in a melting point apparatus against a set of melting point standards.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		MeltingPointStandards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "Model(s) or object(s) of melting point standards with known melting point(s) that will be assayed during maintenances.",
			Category -> "General",
			Abstract -> True
		},
		AdjustmentMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Thermodynamic | Pharmacopeia | Automatic,
			Description -> "Determines the type of the standards (thermodynamic or pharmacopeia) to use for adjusting (calibrating) the measured temperatures by the instrument.",
			Category -> "General",
			Abstract -> True
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
		},
		NominalMeltingPoints -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The nominal melting temperatures of the melting point standards provided by the manufacturer.",
			Category -> "Physical Properties",
			Abstract -> False
		},
		MeasuredMeltingPoints -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The melting temperatures of the melting point standards measured by the target melting point apparatus.",
			Category -> "Physical Properties",
			Abstract -> False
		},
		Image -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image from the melting point apparatus screen after entering the nominal and measured values by the operator for verification purposes.",
			Category -> "General",
			Developer -> True
		}
	}
}];