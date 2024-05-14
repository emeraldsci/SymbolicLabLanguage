(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, InformationTechnology], {
	Description->"Any item related to the computer, network, tablet,phone infrastructure at Emerald that is tracked by the inventory system.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		ComponentType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[ComputerComponentP,Computer],
			Description -> "The type of part this information technology part is.",
			Category -> "Part Specifications"
		}

	}
}];
