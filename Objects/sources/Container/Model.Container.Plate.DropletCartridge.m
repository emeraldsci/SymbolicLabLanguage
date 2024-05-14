

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Plate, DropletCartridge], {
	Description->"A model for a container with microfluidic channels integrated in wells, used to generate sample emulsions for digital assays.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		DropletsFromSampleVolume->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0*(1/Microliter)],
			Units->1/Microliter,
			Description->"The number of discrete partitions that are generated per unit volume of sample.",
			Category->"Instrument Specifications"
		},

		AverageDropletVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Nanoliter],
			Units->Nanoliter,
			Description->"The volumetric size of discrete partitions generated from sample.",
			Category->"Instrument Specifications"
		}
	}
}]