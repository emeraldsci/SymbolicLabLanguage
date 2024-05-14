

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part, Syringe], {
	Description->"A device/part designed to aspirate and dispense liquid through moving a plunger inside a sealed cylinder.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		BarrelMaterial -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],BarrelMaterial]],
			Pattern :> MaterialP,
			Description -> "The material that the body of the syringe that holds the liquid is made of.",
			Category -> "Physical Properties"
		},
		PlungerMaterial -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],PlungerMaterial]],
			Pattern :> MaterialP,
			Description -> "The material that the piston, i.e. plunger, that does the aspiration and ejection of the liquid is made of.",
			Category -> "Physical Properties"
		},
		MinVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinVolume]],
			Pattern :> GreaterP[0*Liter*Micro],
			Description -> "The minimum volume that the syringe can transfer accurately.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxVolume]],
			Pattern :> GreaterP[0*Liter*Micro],
			Description -> "The maximum volume that the syringe can transfer accurately.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
