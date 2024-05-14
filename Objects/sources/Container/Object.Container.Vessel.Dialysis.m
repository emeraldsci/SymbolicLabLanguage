

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, Vessel, Dialysis], {
	Description->"A container used to remove particles below a certain size from a sample by dialysis.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		MolecularWeightCutoff -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MolecularWeightCutoff]],
			Pattern :> GreaterP[0*Dalton],
			Description -> "The largest molecular weight of particles which will dialyzed out by this dialysis container model.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		MembraneMaterial -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MembraneMaterial]],
			Pattern :> DialysisMembraneMaterialP,
			Description -> "The material of the membrane which the particles diffuse across.",
			Category -> "Physical Properties"
		}
	}
}];
