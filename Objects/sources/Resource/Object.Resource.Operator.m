

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Resource, Operator], {
	Description->"A set of parameters describing the attributes of an operator required to complete the requesting protocol.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Operator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User, Emerald],
			Description -> "The operator who fulfilled this resource.",
			Category -> "Resources"
		},
		RequestedOperators -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User, Emerald]|Model[User, Emerald],
			Description -> "The operators who were requested and are specifically able to fulfill this resource.",
			Category -> "Resources"
		},
		RequiredTrainings -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> LabTechniqueTrainingP,
			Description -> "The required training that an operator fulfilling this resource must have to proceed.",
			Category -> "Resources"
		},
		TotalTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The total amount of operator time required to complete a protocol's procedure.",
			Category -> "Resources"
		},
		MinTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The minimum amount of time required for operators to run this protocol.",
			Category -> "Resources"
		},
		MaxTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The maximum amount of time required for operators to run this protocol.",
			Category -> "Resources"
		},
		EstimatedTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "The amount of time requested for this operator.",
			Category -> "Resources"
		},
		Time -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "The amount of time that this operator used the given protocol.",
			Category -> "Resources"
		},
		Checkpoint -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the checkpoint of the protocol that this operator fulfilled.",
			Category -> "Resources"
		},
		OperatorLog -> {
			Format -> Multiple,
			Class -> {Expression, Expression, Link},
			Pattern :> {_?DateObjectQ, Enter | Exit, _Link},
			Relation -> {Null, Null, Object[User, Emerald]},
			Description -> "Log of the members of the ECL operations team who oversaw the fulfillment of this resource and times where they entered or exited its protocol.",
			Category -> "Resources",
			Headers -> {"Date", "Action", "Operator"}
		}
	}
}];
