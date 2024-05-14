(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Plumbing,GasDispersionTube], {
	Description->"A tube with a porous end for finely bubbling gasses through liquid samples.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		FritLength->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],FritLength]],
			Pattern :> GreaterP[0*Milli Meter],
			Description -> "The length of the porous fritted tip at the end of the dispersion tube.",
			Category -> "Physical Properties"
		},
		MinFritPoreSize->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinFritPoreSize]],
			Pattern :> GreaterP[0*Micro*Meter],
			Description -> "The minimum size of the pores in the fritted tip at the end of the dispersion tube.",
			Category -> "Physical Properties"
		},
		MaxFritPoreSize->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxFritPoreSize]],
			Pattern :> GreaterP[0*Micro*Meter],
			Description -> "The maximum size of the pores in the fritted tip at the end of the dispersion tube.",
			Category -> "Physical Properties"
		},
		BendAngle -> {
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],BendAngle]],
			Pattern :>RangeP[Quantity[0, "Degrees"], Quantity[90, "Degrees"]],
			Description -> "The angle the tube is bent to avoid stirring paddles and yet reach close to bottom of container.",
			Category -> "Physical Properties"
		},
		BendOffset -> {
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],BendOffset]],
			Pattern :>GreaterP[0*Milli Meter],
			Description ->  "The distance from the inlet to the bend of the tube.",
			Category -> "Physical Properties"
		}
	}
}];
