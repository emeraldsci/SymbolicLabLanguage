

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Maintenance, CalibrateMeltingPointApparatus], {
	Description->"Definition of a set of parameters for a maintenance protocol that calibrates (adjusts) the measured temperatures in a melting point apparatus against a set of melting point standards.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MeltingPointStandards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Model(s) of melting point standards with known melting point(s) that will be assayed during maintenances. The number of .",
			Category -> "General",
			Abstract -> True
		},
		AdjustmentMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Thermodynamic | Pharmacopeia,
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
		Grind -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the sample is ground via a grinder before packing it into a melting point capillary and measuring its melting point.",
			Category -> "Grinding"
		}
	}
}];