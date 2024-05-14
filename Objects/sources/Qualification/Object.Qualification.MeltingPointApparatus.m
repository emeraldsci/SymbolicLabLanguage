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
		Grind -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the sample is ground via a grinder before packing it into a melting point capillary and measuring its melting point.",
			Category -> "Grinding"
		}
	}
}];
