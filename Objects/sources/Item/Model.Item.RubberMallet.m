(* ::Package:: *)

DefineObjectType[Model[Item, RubberMallet], {
	Description->"Model information for a device used to apply a softer force to a surface.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MalletHeadDiameter-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Centimeter,
			Description -> "The diameter of the mallets head/striking face.",
			Category -> "Dimensions & Positions"
		},
		MalletLength-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Centimeter,
			Description -> "The overall length of the rubber mallet.",
			Category -> "Dimensions & Positions"
		},
		MalletHeadColor-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MalletHeadColorP,
			Description -> "The color of the mallet head.",
			Category -> "Physical Properties"
		},
		HandleMaterial-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MalletHandleMaterialP,
			Description -> "The type of material used for the mallet handle.",
			Category -> "Physical Properties"
		},
		Weight-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Gram,
			Description -> "The weight of the mallet.",
			Category -> "Physical Properties"
		}
	}
}];
