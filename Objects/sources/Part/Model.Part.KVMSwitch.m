(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part,KVMSwitch], {
	Description -> "The model for a device which switches PC control of the Keyboard, Video, and Mouse (KVM) between multiple connected computers.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		NumberOfPorts -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of computers able to connect using the KVM switch.",
			Category -> "Part Specifications"
		}
	}
}];