(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, DialysisMembrane], {
	Description->"A semipermeable material used to separate particles above a certain size from a sample.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		MolecularWeightCutoff -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MolecularWeightCutoff]],
			Pattern :> GreaterP[0 * Dalton],
			Description -> "The largest molecular weight of particles which will diffuse across this membrane model.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		MembraneMaterial -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MembraneMaterial]],
			Pattern :> DialysisMembraneMaterialP,
			Description -> "The material of the membrane which the particles diffuse across.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Preservative -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Preservative]],
			Pattern :> DialysisMembranePreservativeP,
			Description -> "The substance the membrane was packaged in added as a humectant to prevent cracking during drying and to help maintain desired pore structure.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		StorageBuffer -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], StorageBuffer]],
			Pattern :> BooleanP,
			Description -> "Indicates that the membrane was packaged by the manufacturer with a storage buffer.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		FlatWidth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], FlatWidth]],
			Pattern :> GreaterP[0 Millimeter],
			Description -> "The width of the dialysis membrane tube when it is lying flat. This equivalent to half the circumference of the tube.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Diameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Diameter]],
			Pattern :> GreaterP[0 Millimeter],
			Description -> "The diameter of the filled dialysis membrane tube.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		VolumePerLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], VolumePerLength]],
			Pattern :> GreaterP[0 Liter / Meter],
			Description -> "The volume of sample that can occupy the dialysis membrane tube per unit length.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinTemperature]],
			Pattern :> GreaterP[0 * Kelvin],
			Description -> "The minimum temperature at which this membrane can handle.",
			Category -> "Compatibility"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxTemperature]],
			Pattern :> GreaterP[0 * Kelvin],
			Description -> "The maximum temperature at which this membrane can handle.",
			Category -> "Compatibility"
		},
		MinpH -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinpH]],
			Pattern :> RangeP[0, 14],
			Description -> "The minimum pH the membrane can handle.",
			Category -> "Compatibility"
		},
		MaxpH -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxpH]],
			Pattern :> RangeP[0, 14],
			Description -> "The maximum pH the membrane can handle.",
			Category -> "Compatibility"
		},
		IncompatibleMaterials -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP | None,
			Description -> "A list of materials that would be damaged if wetted by this Model.",
			Category -> "Compatibility"
		}
	}
}];
