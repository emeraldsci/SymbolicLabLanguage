(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Plumbing, Fitting], {
	Description->"Model information for a plumbing component used to connect tubing or pipes together.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Valved -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this fitting contains a choke valve that automatically obstructs fluid flow when the fitting is not connected to another plumbing component.",
			Category -> "Plumbing Information"
		},
		Angle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[Quantity[0, "Degrees"], Quantity[180, "Degrees"]],
			Units -> Quantity[1, "Degrees"],
			Description -> "The angle between the continued direction of inlet flow into the manifold and the outlet flow direction.",
			Category -> "Plumbing Information"
		}
	}
}];
