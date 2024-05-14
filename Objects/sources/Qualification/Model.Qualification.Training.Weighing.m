(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification, Training, Weighing], {
	Description->"The model for a qualification test to verify the user's ability to weigh samples properly.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Balances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, Balance],
			Description -> "The instrument that will be used to test the user's ability to tare and measure typical masses (0.1-200 gram) using an analytical balance.",
			Category -> "Weighing Skills"
		},
		BalancesSampleModels -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LinkP[{Model[Item, CalibrationWeight], Model[Sample], Model[Item, Counterweight]}].. | Null},
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the objects or samples used to qualify the user's ability to use a balance.",
			Category -> "General"
		},
		BalancesSampleWeights -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Gram].. | Null},
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the weights of the objects or samples used to qualify the user's ability to use a balance.",
			Category -> "General"
		}
	}
}
]