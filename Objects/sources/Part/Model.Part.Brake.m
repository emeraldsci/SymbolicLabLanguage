(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, Brake], {
	Description->"A model of mechanical device installed on a mobile platform such as a cart that is used to keep it immobile.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		EngagementMethod->{
			Format->Single,
			Class->Expression,
			Pattern:>BrakeEngagementP,
			Description->"The mechanism through which the brake is engaged.",
			Category->"Part Specifications",
			Abstract->True
		},
		BrakeHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The distance needed between the surface on which it is installed and the floor for the brake to function.",
			Category ->"Part Specifications"
		}
	}
}];
