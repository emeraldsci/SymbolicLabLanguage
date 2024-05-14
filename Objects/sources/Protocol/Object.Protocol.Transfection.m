

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, Transfection], {
	Description->"A protocol to convey material through the plasma membrane into target cells using a specialized reagent.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		TransfectionCargo -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0*Micro*Liter]},
			Relation -> {Object[Sample], Null},
			Units -> {None, Liter Micro},
			Description -> "For each member of SamplesIn, the material the transfection reaction conveys through the plasma memberane into the target cells.",
			Category -> "Transfection",
			IndexMatching->SamplesIn,
			Headers -> {"Cargo","Volume"}
		},
		TransfectionCargoVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of transfection cargo used in the transfection reaction.",
			Category -> "Transfection",
			IndexMatching->SamplesIn
		},
		TransfectionReagent -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0*Micro*Liter]},
			Relation -> {Object[Sample] | Model[Sample], Null},
			Units -> {None, Liter Micro},
			Description -> "For each member of SamplesIn, the transfection reagent, and its volume, used in the transfection reaction.",
			Category -> "Transfection",
			IndexMatching->SamplesIn,
			Headers -> {"Reagent","Volume"}
		},
		TransfectionReagentVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of transfection reagent used in the transfection reaction.",
			Category -> "Transfection",
			IndexMatching->SamplesIn
		},
		Buffer -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0*Micro*Liter]},
			Relation -> {Object[Sample] | Model[Sample], Null},
			Units -> {None, Liter Micro},
			Description -> "For each member of SamplesIn, the buffer, and its volume. used in the transfection reaction.",
			Category -> "Transfection",
			IndexMatching->SamplesIn,
			Headers -> {"Buffer","Volume"}
		},
		BufferVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of buffer used in the transfection reaction.",
			Category -> "Transfection",
			IndexMatching->SamplesIn
		},
		TransfectionBooster -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0*Micro*Liter]},
			Relation -> {Object[Sample] | Model[Sample], Null},
			Units -> {None, Liter Micro},
			Description -> "For each member of SamplesIn, the booster reagent, and its volume, used in the transfection reaction.",
			Category -> "Transfection",
			IndexMatching->SamplesIn,
			Headers -> {"Booster","Volume"}
		},
		TransfectionBoosterVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of booster reagent used in the transfection reaction.",
			Category -> "Transfection",
			IndexMatching->SamplesIn
		},
		TransfectionProgram -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "The robot-interpretable liquid handler program to perform the transfection.",
			Category -> "General",
			Abstract -> True
		}
	}
}];
