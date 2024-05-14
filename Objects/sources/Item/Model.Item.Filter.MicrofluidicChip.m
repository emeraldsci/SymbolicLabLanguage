(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Filter, MicrofluidicChip], {
	Description->"Model information for filter chip with membrane used in cross flow filtration running on Formulatrix uPulse system.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MaxVolumeOfUses -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Liter],
			Units -> Liter Milli,
			Description -> "The total volume of liquid that can be filtered using this filter model.",
			Category -> "Operating Limits"
		},
		CleanerOnly->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this item model is for cleaning the instrument only.",
			Category -> "Organizational Information"
		}
	}
}];
