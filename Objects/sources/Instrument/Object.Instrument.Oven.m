(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Oven], {
	Description->"A large capacity oven used for complex controlled heating",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the instrument.",
			Category -> "Organizational Information",
			Abstract -> True
		}
		
	}
}];
