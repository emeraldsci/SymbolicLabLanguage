(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container,Plate,Irregular,Crystallization], {
	Description->"A physical container that accepts samples in drop wells and precipitants in reservoir wells to grow the crystals of samples. The crystallization plate contains micro-ledges between reservoir well and drop well that allowing vapor diffusion.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		FormulatrixBarcode -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The 4-digit barcode assigned by Formulatrix RockMaker when this plate is stored inside of the crystal incubator.",
			Category -> "Incubation",
			Developer -> True
		},
		FormulatrixPlateID -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The 3-digit barcode assigned by Formulatrix RockMaker when this plate is stored inside of the crystal incubator.",
			Category -> "Incubation",
			Developer -> True
		},
		ImagingModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ImagingModeP,(*VisibleLightImaging,CrossPolarizedImaging,UVImaging*)
			Description -> "The types of images scheduled to be collected daily when this plate is stored inside of a crystal incubator.",
			Category -> "Incubation",
			Developer -> True
		}
	}
}];