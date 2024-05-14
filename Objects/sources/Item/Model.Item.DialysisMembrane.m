(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, DialysisMembrane], {
	Description->"Model information for a dialysis membrane used to separate particles above a certain molecular weight from a sample using passive diffusion.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		MolecularWeightCutoff -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Dalton],
			Units -> Kilo Dalton,
			Description -> "The smallest molecular weight of particles which will not diffuse across this membrane model.",
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
		Preservative -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DialysisMembranePreservativeP,
			Description -> "The substance the membrane was packaged in as a humectant to prevent cracking during drying and to help maintain desired pore structure.",
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
		},
		StorageBuffer -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that membranes of this model come packaged from the manufacturer with a storage buffer.",
			Category -> "Storage Information"
		},
		FlatWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The width of the dialysis membrane tube when it is lying flat. This equivalent to half the circumference of the tube.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Diameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Meter,
			Description -> "The diameter of the filled dialysis membrane tube.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		VolumePerLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Liter/Meter],
			Units -> Liter/Meter,
			Description -> "The volume of sample that can occupy the dialysis membrane tube per unit length.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		MembraneLength ->  {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Meter,
			Description -> "The length of the dialysis membrane.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which this membrane can handle.",
			Category -> "Compatibility"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature at which this membrane can handle.",
			Category -> "Compatibility"
		},
		MinpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The minimum pH the membrane can handle.",
			Category -> "Compatibility"
		},
		MaxpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The maximum pH the membrane can handle.",
			Category -> "Compatibility"
		}
	}
}];
