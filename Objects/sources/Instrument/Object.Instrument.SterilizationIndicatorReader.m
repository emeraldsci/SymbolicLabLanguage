

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, SterilizationIndicatorReader], {
	Description->"An instrument for incubation and reading bacterial vials that test sterilization capability of an autoclave.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		IncubationTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],IncubationTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Temperature at which the Reader incubates samples.",
			Category -> "Instrument Specifications"
		}
	}
}];
