(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: hanming.yang*)
(* :Date: 2023-6-23 *)

DefineObjectType[Object[Qualification,Training,Discarding], {
	Description->"The qualification test to verify the ability of operators to properly discard samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DiscardedConsumableIDs -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The ids of the consumable objects that the operator manually discarded to test their ability to properly stock consumables.",
			Category -> "General"
		}
	}
}
]