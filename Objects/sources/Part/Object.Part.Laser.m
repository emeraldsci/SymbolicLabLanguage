(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part,Laser],{
	Description->"A laser used to illuminate or excite a sample.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		LaserType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],LaserType]],
			Pattern:>LaserTypeP,
			Description->"The type of medium that the laser uses to generate light at a specified wavelength.",
			Category->"Optical Information"
		},
		Tunable->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Tubable]],
			Pattern:>BooleanP,
			Description->"Indicates if the laser is capable of being set to a specified wavelength.",
			Category->"Optical Information"
		},
		MinTunableWavelength->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinTunableWavelength]],
			Pattern:>GreaterP[0 Nanometer,1 Nanometer],
			Description->"The minimum wavelength that a tunable laser can be set to.",
			Category->"Optical Information"
		},
		MaxTunableWavelength->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTunableWavelength]],
			Pattern:>GreaterP[0 Nanometer,1 Nanometer],
			Description->"The maximum wavelength that a tunable laser can be set to.",
			Category->"Optical Information"
		},
		MinTunablePowerOutput->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinTunablePowerOutput]],
			Pattern:>GreaterP[0 Nanometer,1 Nanometer],
			Description->"The minimum power that a tunable laser can output.",
			Category->"Optical Information"
		},
		MaxTunablePowerOutput->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTunablePowerOutput]],
			Pattern:>GreaterP[0 Nanometer,1 Nanometer],
			Description->"The maximum power that a tunable laser can output.",
			Category->"Optical Information"
		},
		LaserArray->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],LaserArray]],
			Pattern:>BooleanP,
			Description->"Indicates if the part contains more than one laser source.",
			Category->"Optical Information"
		},
		LaserClass->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],LaserClass]],
			Pattern:>LaserSafetyClassP,
			Description->"The safety class of the laser.",
			Category->"Health & Safety"
		},
		Wavelengths->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Wavelengths]],
			Pattern:>{{GreaterP[0 Nanometer,1 Nanometer],GreaterP[0 Milliwatt]}..},
			Description->"The wavelength(s) of light that a non-tunable laser or laser array is capable of generating.",
			Headers->{"Wavelength","Power Output"},
			Category->"Optical Information"
		}
	}
}];
