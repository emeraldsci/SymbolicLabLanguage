(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,WeighBoat], {
	Description->"A model of a light, disk-like container that is used to hold solid samples during weighing.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Material-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material of which the spatula is composed.",
			Category -> "Physical Properties"
		},
		MaxVolume->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The maximum volume that this weigh boat can hold.",
			Category -> "Physical Properties"
		},
		TareWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The mean weight of empty containers of this model.",
			Category -> "Container Specifications"
		}
	}
}];
