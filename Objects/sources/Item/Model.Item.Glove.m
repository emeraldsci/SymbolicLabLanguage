(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Glove], {
	Description->"Model information for a part designed to provide thermal protection from hot/cold surfaces or liquids.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	
		GloveSize->{
			Format -> Single,
			Class -> Expression,
			Pattern :> GloveSizeP,
			Description -> "Indicates the size of the glove.",
			Category -> "Item Specifications",
			Abstract->True
		},
		
		GloveType->{
			Format -> Single,
			Class -> Expression,
			Pattern :> GloveTypeP,
			Description -> "Indicates the style of the glove used to handle hot or cold surfaces.",
			Category -> "Item Specifications",
			Abstract->True
		},
		
		Coverage->{
			Format -> Single,
			Class -> Expression,
			Pattern :> GloveCoverageP,
			Description -> "Indicates the amount of arm coverage of the glove.",
			Category -> "Item Specifications",
			Abstract->True
		},
		
		WaterResistant->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the gloves are water resistant.",
			Category -> "Item Specifications"
		},
		
		MaxTemperature ->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature where the gloves provide thermal protection to the user.",
			Category -> "Operating Limits"
		},
		
		MinTemperature ->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature where the gloves provide thermal protection to the user.",
			Category -> "Operating Limits"
		}
		
	}
}];
