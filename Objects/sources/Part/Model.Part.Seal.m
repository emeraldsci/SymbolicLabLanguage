(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Seal], {
	Description->"Model information for a gasket that is used to prevent the leakage in mechanical device by closing the spaces between the moving and stationary components of the device.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SupportRing -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if components of this model type include support ring.",
			Category -> "Part Specifications",
			Abstract -> True
		}
	}
}];