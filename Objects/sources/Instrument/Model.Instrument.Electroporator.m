

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, Electroporator], {
	Description->"A model of a device which allows biological molecules, such as DNA or RNA, to enter a cell by use of electric fields.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MinVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?VoltageQ,
			Units -> Volt,
			Description -> "The minimum voltage that can be applied during sample separation.",
			Category -> "Operating Limits"
		},
		MaxVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?VoltageQ,
			Units -> Volt,
			Description -> "The maximum voltage that can be applied during sample separation.",
			Category -> "Operating Limits"
		}
	}
}];