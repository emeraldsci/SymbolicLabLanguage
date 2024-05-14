(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Training,SampleStates], {
	Description->"A protocol that verifies an operator's ability to identify the state of matter that best describes a sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SampleStatesObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The objects that the user will be asked to determine the sample state of.",
			Category -> "General"
		},
		SampleStatesAnswers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleHandlingP,
			Description -> "The user input answers of a given object's sample state in the procedure, either Liquid, Slurry, Brittle, Powder, Itemized, Viscous, Fabric, Paste, or Fixed.",
			Category -> "General"
		},
		SampleHandling -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleHandlingP,
			Description -> "The SampleHandling types that are tested, either Liquid, Slurry, Brittle, Powder, Itemized, Viscous, Fabric, Paste, or Fixed.",
			Category -> "General"
		}
		}
}
]
