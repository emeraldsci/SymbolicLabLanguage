

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, CellThaw], {
	Description->"A device that thaws cryogenically preserved cells in a controlled manner.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Capacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Capacity]],
			Pattern :> {{ObjectReferenceP[Model[Container]], GreaterP[0, 1]}..},
			Description -> "The thawing capacity of the instrument, in the format: {container model, number of containers}.",
			Category -> "Instrument Specifications"
		}
	}
}];
