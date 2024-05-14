

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, GelBox], {
	Description->"Bath apparatus for running gel electrophoresis.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		BufferVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],BufferVolume]],
			Pattern :> GreaterP[0*Liter],
			Description -> "Amount of buffer required to fill the gel box.",
			Category -> "Operating Limits"
		}
	}
}];
