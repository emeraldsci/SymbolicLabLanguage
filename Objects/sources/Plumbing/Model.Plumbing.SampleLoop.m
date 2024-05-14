

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Plumbing, SampleLoop], {
	Description->"A model for tubing that holds sample for introduction into a flow path.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter*Micro],
			Units -> Liter Micro,
			Description -> "The maximum capacity of liquid that the loop can house.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
