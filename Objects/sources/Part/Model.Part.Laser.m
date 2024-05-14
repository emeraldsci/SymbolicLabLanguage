(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part,Laser],{
	Description->"Model information for a laser used to illuminate or excite a sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		LaserType->{
			Format->Single,
			Class->Expression,
			Pattern:>LaserTypeP,
			Description->"The type of medium that the laser uses to generate light at a specified wavelength.",
			Category->"Optical Information"
		},
		Tunable->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the laser is capable of being set to a specified wavelength.",
			Category->"Optical Information"
		},
		MinTunableWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer,1 Nanometer],
			Units->Nanometer,
			Description->"The minimum wavelength that a tunable laser can be set to.",
			Category->"Optical Information"
		},
		MaxTunableWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer,1 Nanometer],
			Units->Nanometer,
			Description->"The maximum wavelength that a tunable laser can be set to.",
			Category->"Optical Information"
		},
		MinTunablePowerOutput->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Watt],
			Units->Milliwatt,
			Description->"The minimum power that a tunable laser can output.",
			Category->"Optical Information"
		},
		MaxTunablePowerOutput->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Milliwatt],
			Units->Milliwatt,
			Description->"The maximum power that a tunable laser can output.",
			Category->"Optical Information"
		},
		LaserArray->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the part contains more than one laser source.",
			Category->"Optical Information"
		},
		LaserClass->{
			Format->Single,
			Class->Expression,
			Pattern:>LaserSafetyClassP,
			Description->"The safety class of the laser.",
			Category->"Health & Safety"
		},
		Wavelengths->{
			Format->Multiple,
			Class->{Real,Real},
			Pattern:>{GreaterP[0 Nanometer,1 Nanometer],GreaterP[0 Milliwatt]},
			Units->{Nanometer,Milliwatt},
			Description->"The wavelength(s) of light that a non-tunable laser or laser array is capable of generating.",
			Headers->{"Wavelength","Power Output"},
			Category->"Optical Information"
		}
	}
}];
