(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Item,Cartridge,Desiccant],{
	Description->"Model information for a cartridge containing a desiccating substance to remove moisture from the surrounding environment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		InitialIndicatorColor->{
			Format->Single,
			Class->Expression,
			Pattern:>ColorP,
			Description->"The hue of the contents of the cartridge before the cartridge is used.",
			Category->"Physical Properties"
		},
		ExhaustedIndicatorColor->{
			Format->Single,
			Class->Expression,
			Pattern:>ColorP,
			Description->"The hue of the contents of the cartridge after the cartridge is exhausted.",
			Category->"Physical Properties"
		},
		MinTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The minimum temperature at which the desiccant cartridge can operate effectively.",
			Category->"Operating Limits"
		},
		MaxTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The maximum temperature at which the desiccant cartridge can operate effectively.",
			Category->"Operating Limits"
		},
		MaxRelativeHumidity->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0 Percent,100 Percent],
			Units->Percent,
			Description->"The maximum amount of water vapor that can be in the air, relative to saturation, for the desiccant cartridge to operate effectively.",
			Category->"Operating Limits"
		},
		Rechargeable->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the desiccant cartridge can be recharged for reuse once exhausted.",
			Category->"Part Specifications"
		},
		Filtration->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the desiccant cartridge performs a filtration function in addition to desiccation.",
			Category->"Part Specifications"
		}
	}
}]