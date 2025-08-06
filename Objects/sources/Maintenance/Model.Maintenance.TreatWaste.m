(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, TreatWaste], {
	Description->"Definition of a set of parameters for a maintenance protocol that treats and safely disposes of the waste.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CleaningType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CleaningTypeP,
			Description -> "Indicates the type of cleaning or sterilization that the contents of containers of this model will undergo.",
			Category -> "General"
		},
		BleachTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the source samples are incubated with bleach.",
			Category -> "General"
		}
	}
}];