(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Plumbing,GasDispersionTube], {
	Description->"Model information for a tube with a porous end for finely bubbling gasses through liquid samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		FritLength->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Meter],
			Units -> Milli Meter,
			Description -> "The length of the porous fritted tip at the end of the dispersion tube.",
			Category -> "Physical Properties"
		},
		MinFritPoreSize->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Meter],
			Units -> Meter Micro,
			Description -> "The minimum size of the pores in the fritted tip at the end of the dispersion tube.",
			Category -> "Physical Properties"
		},
		MaxFritPoreSize->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Meter],
			Units -> Meter Micro,
			Description -> "The maximum size of the pores in the fritted tip at the end of the dispersion tube.",
			Category -> "Physical Properties"
		},
		BendAngle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[Quantity[0, "Degrees"], Quantity[90, "Degrees"]],
			Units -> Quantity[1, "AngularDegrees"],
			Description -> "The angle the tube is bent to avoid stirring paddles while still reaching close to bottom of container.",
			Category -> "Physical Properties"
		},
		BendOffset->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Meter],
			Units -> Milli Meter,
			Description -> "The distance from the inlet to the bend of the tube.",
			Category -> "Physical Properties"
		}
	}
}];
