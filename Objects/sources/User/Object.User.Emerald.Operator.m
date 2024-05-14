(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[User,Emerald, Operator],{
	Description -> "A user who is a current or former member of the Emerald Cloud Lab's operations team responsible for overseeing the conduct of experiments in the ECL's facilities.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		ShiftTime -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ShiftTimeP,
			Description -> "The hours that the operator is scheduled to work on a regular basis - options include Morning, Night, Swing. Occasionally operators may be asked to work off of their regular shift schedule when taking overtime or rebalancing shift headcounts.",
			Category -> "Organizational Information"
		},
		ShiftName -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ShiftNameP,
			Description -> "The team name given to a collection of operators who are scheduled together to work on a given set of days. Options include Alpha and Bravo.",
			Category -> "Organizational Information"
		},
		Respirator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,Respirator][Operator],
			Description -> "The respirator that belongs to this operator and used for safe handling.",
			Category -> "General"
		}
	}
}];
