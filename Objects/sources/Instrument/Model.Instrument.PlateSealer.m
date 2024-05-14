

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument,PlateSealer],{
	Description->"Model of a device that uses heat and pressure to apply a membrane over assay plates to securely close the wells and prevent sample evaporation.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		TemperatureActivated->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"High temperature is used to heat an adhesive membrane placed over an assay plate.",
			Category->"Instrument Specifications"
		},
		(* Sealer properties for temperature-activated plate sealer*)
		MinTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"Minimum temperature used to heat an adhesive membrane placed over an assay plate.",
			Category->"Operating Limits"
		},

		MaxTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"Maximum temperature used to heat an adhesive membrane placed over an assay plate.",
			Category->"Operating Limits"
		},

		MinDuration->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Second],
			Units->Second,
			Description->"Minimum length of time that can be used to seal a plate.",
			Category->"Operating Limits"
		},

		MaxDuration->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Second],
			Units->Second,
			Description->"Maximum length of time that can be used to seal a plate.",
			Category->"Operating Limits"
		}
	}
}
]