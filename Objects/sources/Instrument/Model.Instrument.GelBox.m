

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, GelBox], {
	Description->"The model for an bath appartus for running gel electrophoresis.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		BufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "Amount of buffer required to fill the gel box.",
			Category -> "Operating Limits"
		}
	}
}];
