(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Vessel, Dialysis], {
	Description->"A model for a vessel container used to dialyze particles below a certain size from samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MolecularWeightCutoff -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Dalton],
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
		PreSoak -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if it is recommended by the manufacturer that the membrane is soaked before the sample is loaded.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		RecommendedSoakVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Milli,
			Description -> "The amount of solution the manufacturer recommends the membrane should be soaked in before the sample is loaded.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		RecommendedSoakTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The amount of time the manufacturer recommends the membrane should be soaked before the sample is loaded.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		RecommendedSoakSolution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DialysisSoakSolutionP,
			Description -> "The liquid the manufacturer recommends the membrane should be soaked before the sample is loaded.",
			Category -> "Physical Properties",
			Abstract -> True
		}
	}
}];
