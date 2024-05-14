

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, Syringe], {
	Description->"A model for a device/part designed to aspirate and dispense liquid through moving a plunger inside a sealed cylinder.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		BarrelMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material that the body of the syringe that holds the liquid is made of.",
			Category -> "Physical Properties"
		},
		PlungerMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material that the piston, i.e. plunger, that does the aspiration and ejection of the liquid is made of.",
			Category -> "Physical Properties"
		},
		MinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter*Micro],
			Units -> Liter Micro,
			Description -> "The minimum volume that the syringe can transfer accurately.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter*Micro],
			Units -> Liter Micro,
			Description -> "The maximum volume that the syringe can transfer accurately.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		GCInjectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (LiquidInjection|HeadspaceInjection|LiquidHandling),
			Description -> "The GC sampling method with which this syringe is compatible.",
			Category -> "Physical Properties"
		}
	}
}];
