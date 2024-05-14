(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Plate, Dialysis], {
	Description->"A model for a Equilibrium Dialysis Insert used to dialyze particles below a certain size from samples into a neighboring well.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MolecularWeightCutoff -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Dalton],
			Units -> Kilo Dalton,
			Description -> "The largest molecular weight of particles which will dialyzed out by this dialysis container model.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		MembraneMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DialysisMembraneMaterialP,
			Description -> "The material of the membrane which the particles diffuse across.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		MembraneArea -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Meter * Meter],
			Units->Millimeter*Millimeter,
			Description -> "The area of dialysis membranes separating the two wells.",
			Category -> "Physical Properties",
			Abstract -> True
		}
	}
}];
