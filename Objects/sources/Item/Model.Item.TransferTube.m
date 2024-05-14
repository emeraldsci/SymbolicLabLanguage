(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, TransferTube], {
	Description->"Model information for a disposable plastic tube that is used for transferring compressible, paste-like fluids.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Material -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material that the transfer tube is made out of.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		MaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Liter],
			Units -> Liter Milli,
			Description -> "The maximum volume of liquid that the transfer tube can hold.",
			Category -> "Operating Limits"
		}
	}
}];
