

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program, Transfection], {
	Description->"A set of parameters used by a robotic liquid handler to convey material through the plasma membrane into target cells using a specialized reagent.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		SamplesIn -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Protocol]}, Download[Field[Protocol], SamplesIn]],
			Pattern :> _Link,
			Description -> "Input samples for this analytical or preparative experiment.",
			Category -> "Organizational Information"
		},
		PlateFormat -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> WellNumberP,
			Units -> None,
			Description -> "The number of wells in the cell plates to be transfected.",
			Category -> "General"
		},
		PlateLidLocations -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string containing the positions of the cell plate lids on the liquid handler deck.",
			Category -> "Robotic Liquid Handling"
		},
		TransfectionMixtureIngredientLocations -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string containing the positions of the transfection mix ingredients on the liquid handler deck.",
			Category -> "Robotic Liquid Handling"
		},
		TransfectionMixtureLocations -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string containing the positions of the wells into which transfection mix ingredients are pipetted.",
			Category -> "Robotic Liquid Handling"
		},
		TransfectionMixtureIngredientVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The list of ingredient volumes for making the transfection mixtures.",
			Category -> "Robotic Liquid Handling"
		},
		TransfectionAliquots -> {
			Format -> Multiple,
			Class -> {String, String, Real},
			Pattern :> {Patterns`Private`robotSequenceP, Patterns`Private`robotSequenceP, GreaterEqualP[0*Liter]},
			Units -> {None, None, Liter Micro},
			Description -> "The transfection mixtures to be aliquoted to the destination wells of cells.",
			Category -> "Robotic Liquid Handling",
			Headers->{"Source", "Destination", "Volume"}
		},
		TransfectionSamples -> {
			Format -> Multiple,
			Class -> {Expression, Link, Real, Integer},
			Pattern :> {WellP, _Link, GreaterEqualP[0*Micro*Liter], RangeP[1, 4, 1]},
			Relation -> {Null, Object[Sample], Null, Null},
			Units -> {None, None, Liter Micro, None},
			Description -> "For each member of SamplesIn, the transfection cargo sample used for this transfection.",
			Category -> "Reagents",
			Headers->{"Destination Well","Cargo","Volume","Destination Plate Index"},
			IndexMatching->SamplesIn
		},
		TransfectionReagentSamples -> {
			Format -> Multiple,
			Class -> {Expression, Link, Real, Integer},
			Pattern :> {WellP, _Link, GreaterEqualP[0*Micro*Liter], RangeP[1, 4, 1]},
			Relation -> {Null, Object[Sample] | Model[Sample], Null, Null},
			Units -> {None, None, Liter Micro, None},
			Description -> "For each member of SamplesIn, the transfection reagent sample used for this transfection.",
			Category -> "Reagents",
			Headers->{"Destination Well","Cargo","Volume","Destination Plate Index"},
			IndexMatching->SamplesIn
		},
		BufferSamples -> {
			Format -> Multiple,
			Class -> {Expression, Link, Real, Integer},
			Pattern :> {WellP, _Link, GreaterEqualP[0*Micro*Liter], RangeP[1, 4, 1]},
			Relation -> {Null, Object[Sample] | Model[Sample], Null, Null},
			Units -> {None, None, Liter Micro, None},
			Description -> "For each member of SamplesIn, the buffer sample used for this transfection.",
			Category -> "Reagents",
			Headers->{"Destination Well","Cargo","Volume","Destination Plate Index"},
			IndexMatching->SamplesIn
		},
		TransfectionBoosterSamples -> {
			Format -> Multiple,
			Class -> {Expression, Link, Real, Integer},
			Pattern :> {WellP, _Link, GreaterEqualP[0*Micro*Liter], RangeP[1, 4, 1]},
			Relation -> {Null, Object[Sample] | Model[Sample], Null, Null},
			Units -> {None, None, Liter Micro, None},
			Description -> "For each member of SamplesIn, the transfection booster reagent sample used for this transfection.",
			Category -> "Reagents",
			Headers->{"Destination Well","Cargo","Volume","Destination Plate Index"},
			IndexMatching->SamplesIn
		}
	}
}];
