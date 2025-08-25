(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, MeltingPointApparatus], {
	Description -> "A protocol that verifies the functionality of a melting point apparatus.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		AdjustmentMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Thermodynamic | Pharmacopeia,
			Description -> "Determines the type of the standards (thermodynamic or pharmacopeia) to use to qualify the instrument.",
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
		}
	}
}];
