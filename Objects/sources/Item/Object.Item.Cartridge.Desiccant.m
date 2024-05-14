(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Item,Cartridge,Desiccant],{
	Description->"A cartridge containing a desiccating substance to remove moisture from the surrounding environment.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Instrument]],
			Description->"The instrument that the desiccant cartridge is installed in.",
			Category->"Instrument Specifications"
		},
		InitialIndicatorColor->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],InitialIndicatorColor]],
			Pattern:>ColorP,
			Description->"The hue of the contents of the cartridge before the cartridge is used.",
			Category->"Physical Properties"
		},
		ExhaustedIndicatorColor->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ExhaustedIndicatorColor]],
			Pattern:>ColorP,
			Description->"The hue of the contents of the cartridge after the cartridge is exhausted.",
			Category->"Physical Properties"
		},
		MinTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern:>GreaterEqualP[0 Kelvin],
			Description->"The minimum temperature at which the desiccant cartridge can operate effectively.",
			Category->"Operating Limits"
		},
		MaxTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern:>GreaterEqualP[0 Kelvin],
			Description->"The maximum temperature at which the desiccant cartridge can operate effectively.",
			Category->"Operating Limits"
		},
		MaxRelativeHumidity->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxRelativeHumidity]],
			Pattern:>RangeP[0 Percent,100 Percent],
			Description->"The maximum amount of water vapor that can be in the air, relative to saturation, for the desiccant cartridge to operate effectively.",
			Category->"Operating Limits"
		},
		Rechargeable->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Rechargeable]],
			Pattern:>BooleanP,
			Description->"Indicates if the desiccant cartridge can be recharged for reuse once exhausted.",
			Category->"Part Specifications"
		},
		Filtration->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Filtration]],
			Pattern:>BooleanP,
			Description->"Indicates if the desiccant cartridge performs a filtration function in addition to desiccation.",
			Category->"Part Specifications"
		}
	}
}]