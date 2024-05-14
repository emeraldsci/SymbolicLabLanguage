

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, Plate, DropletCartridge], {
	Description->"A container with microfluidic channels integrated in wells, used to generate sample emulsions for digital assays.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		DropletsFromSampleVolume->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],DropletsFromSampleVolume]],
			Pattern:>GreaterP[0],
			Description->"The number of discrete partitions that are generated per unit volume of sample.",
			Category->"Instrument Specifications"
		},

		AverageDropletVolume->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],AverageDropletVolume]],
			Pattern:>GreaterP[0],
			Description->"The volumetric size of discrete partitions generated from sample.",
			Category->"Instrument Specifications"
		}
	}
}]