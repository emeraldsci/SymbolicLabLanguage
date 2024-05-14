

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, OperatorCart], {
	Description->"A cart that operators use to carry samples and reagents around the lab.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Tablet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Computer],
			Description -> "The tablet which is currently connected to the cart.",
			Category -> "Organizational Information",
			Developer -> True
		},
		ActiveProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol],
				Object[Maintenance],
				Object[Qualification]
			],
			Description -> "The experiment, maintenance, or control that is currently running on this cart.",
			Category -> "Organizational Information",
			Abstract -> True
		}
	}
}];
