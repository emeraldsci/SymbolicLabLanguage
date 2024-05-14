(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, ChippingHammer], {
	Description->"Model information for a hammer with a sharp end that is used to chip off parts of brittle solids.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Material -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material that the chipping hammer is made out of.",
			Category -> "Physical Properties",
			Abstract -> True
		}
	}
}];
