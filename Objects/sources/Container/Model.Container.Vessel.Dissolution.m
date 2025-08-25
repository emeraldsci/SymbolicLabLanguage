(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Vessel, Dissolution], {
	Description->"Information for a vessel used in the dissolution experiments. These vessels have special shapes and are not generally used for other purposes.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		RecommendedFillVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The largest recommended fill volume of the vessel for the experiment.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];