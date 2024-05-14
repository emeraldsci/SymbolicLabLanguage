

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, SterilizationIndicatorReader], {
	Description->"An instrument for incubation and reading bacterial vials that test sterilization capability of an autoclave.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		IncubationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Temperature at which the Reader incubates samples.",
			Category -> "Instrument Specifications"
		}
	}
}];
