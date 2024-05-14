

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, BlowGun], {
	Description->"Model information for a instrument used to control the flow of compressed gas using a hand trigger.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TriggerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BlowGunTypeP,
			Description -> "The type of trigger mechanism used to activate the flow of air.",
			Category -> "Instrument Specifications"	
		},
		Gas-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BlowGunGasTypeP,
			Description -> "The type of gas delivered by the blow gun.",
			Category -> "Instrument Specifications"
		}
	}
}];
