(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, IceScraper], {
	Description->"Model information for a device used to remove ice/frost buildup from freezers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		BladeMaterial-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The type of material used for the ice scraper blade.",
			Category -> "Physical Properties"
		},
		HandleMaterial-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The type of material used for the ice scraper handle.",
			Category -> "Physical Properties"
		},
		IceScraperLength-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Centimeter,
			Description -> "The overall length of the ice scraper.",
			Category -> "Dimensions & Positions"
		},
		BladeWidth-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Centimeter,
			Description -> "The blade width of the ice scraper.",
			Category -> "Dimensions & Positions"
		}
	}
}];
