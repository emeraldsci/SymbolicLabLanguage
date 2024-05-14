(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, FaceShield], {
	Description->"Model information for part designed to worn by a user in order to protect the face from chemical splashes/airborne debris.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	
		HeadCoverage->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the face shield has built in top of the head coverage.",
			Category -> "Item Specifications"
		},
		
		ChinGuard->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the face shield is large enouch to cover the chin and kneck region.",
			Category -> "Item Specifications"
		},
		
		AdjustableSizing ->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the face shield can be tightened/loosened to accomodate different head sizes.",
			Category -> "Item Specifications"
		},
		
		AdjustableShieldPosition ->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the face shield can be easily rotated up or down.",
			Category -> "Item Specifications"
		},

		VisorMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The type of material used to construct the protective visor.",
			Category -> "Item Specifications"
		},
		
		VisorProperties -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> VisorPropertiesP,
			Description -> "Indicates any physical or visual properties of the visor.",
			Category -> "Item Specifications"
		}
	}
}];
