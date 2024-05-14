

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, Bench, Receiving], {
	Description->"A lab bench used specifically for receiving new items.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		ReceivingPosition -> {
			Format -> Single,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "The position on this container in which newly-received items are placed.",
			Category -> "Container Specifications"
		}
	}
}];
