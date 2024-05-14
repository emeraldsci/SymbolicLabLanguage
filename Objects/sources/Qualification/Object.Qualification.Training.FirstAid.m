(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: jihan.kim*)

DefineObjectType[Object[Qualification,Training,FirstAid], {
	Description->"The qualification training object to test an operator's ability to locate first aid kits in the lab.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		FirstAidKit->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item],Object[Part],Object[Container],Object[Instrument]],
			Description -> "The first aid kit objects that the operator will be asked to find in the specific order.",
			Category -> "General"
		},
		ObjectsFound->{
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The list of first aid kits that the user found during the training.",
			Category -> "General"
		}
	}
}];