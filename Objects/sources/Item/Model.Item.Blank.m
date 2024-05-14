(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Blank], {
	Description-> "Model information for the type of material (metal or plastic) that is initially loaded to the CNC machine.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CrossSectionalShape -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Circle | Rectangle,
			Description -> "The shape of this model of CNC blank in the X-Y plane.",
			Category -> "Dimensions & Positions"
		},
		BlankMaterial -> {
		    Format -> Single,
		    Class -> Expression,
		    Pattern :> MaterialP,
		    Category -> "Item Specifications",
		    Description -> "The materials of which this item is made."
		}
		
	}
}];
