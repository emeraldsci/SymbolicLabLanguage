(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part,KVMSwitch], {
	Description-> "The objects for a device which switches PC control of the Keyboard, Video, and Mouse (KVM) between multiple connected computers.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		NumberOfOccupiedPorts -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The quantity of ports being used on the KVM switch.",
			Category -> "Part Specifications"
		},

		ControlPanelPlugType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectionMethodP,
			Description -> "The cable connection type which the KVM module uses.",
			Category -> "Part Specifications"
		},

		MonitorPlugType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectionMethodP,
			Description -> "The cable connection type which the KVM connected monitor uses.",
			Category -> "Part Specifications"
		},

		KeyboardPlugType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectionMethodP,
			Description -> "The cable connection type which the KVM connected keyboard uses.",
			Category -> "Part Specifications"
		},

		MousePlugType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectionMethodP,
			Description -> "The cable connection type which the KVM connected mouse uses.",
			Category -> "Part Specifications"
		},
		IPAddress -> {
			Format -> Single,
			Class -> String,
			Pattern :> IpP,
			Description -> "The IP Address of this KVM Switch, if the KVM Switch operates via KVM over IP.",
			Category -> "Part Specifications"
		},
		ConnectedComputers ->{
			Format->Multiple,
			Class ->Link,
			Pattern:> _Link,
			Relation->Object[Part,Computer][ConnectedKVMSwitch],
			Description -> "The computers that this KVMSwitch is capable of controlling.",
			Category -> "Part Specifications"
		}
	}
}];