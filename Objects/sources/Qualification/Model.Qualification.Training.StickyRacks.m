(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Training,StickyRacks], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies an operator's ability to move containers via the sticky rack system.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		NumberOfRackedTubes->{
				Units -> None,
				Relation -> Null,
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Description -> "The number of containers that the user will be asked to move with the sticky rack system.",
				Category -> "General"
		},
		RackedTubeModel->{
			Units -> None,
			Relation -> Model[Container],
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Description -> "The type of containers that will be moved with using a sticky rack.",
			Category -> "General"
		}
	}
}
]