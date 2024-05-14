(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container,Plate,Irregular,Crystallization],{
	Description->"A model for plate featuring specialized micro-channels and micro-ledges that allow vapor diffuses between drop wells and reservoir well that share headspace after cover is applied. The crystallization plate is used to grow, transport, and screen of crystals for X-Ray Diffraction (XRD).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* Container Specifications *)
		WellContents->{
			Format->Multiple,
			Class->Expression,
			Pattern:>CrystallizationWellContentsP,
			Description->"For each member of Positions, indication of whether the position is intended to be reservoir or drop well.",
			IndexMatching->Positions,
			Category->"Container Specifications"
		},
		(* Dimensions & Positions *)
		LabeledRows->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0, 1],
			Units->None,
			Description->"The number of rows labeled as letters in the plate. It represents how many groups of HeadspaceSharingWells or individual wells that do not share headspace with nearby wells are in a column of this model plate. The value should be the same as the number that the alphabetic letter of the bottom left corner letter of the plate converts to (A converts to 1, Z converts to 26).",
			Category->"Dimensions & Positions"
		},
		LabeledColumns->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0, 1],
			Units->None,
			Description->"The number of columns labeled as numbers in the plate. It represents how many groups of HeadspaceSharingWells or individual wells that do not share headspace with nearby wells are in a row of this model plate.The value should be the same as the right top corner number of the plate.",
			Category->"Dimensions & Positions"
		},
		(* Compatibility *)
		CompatibleCrystallizationTechniques->{
			Format->Multiple,
			Class->Expression,
			Pattern:>CrystallizationTechniqueP,
			Description->"The crystallization technique that can use this model of container plate.",
			Category->"Compatibility"
		},
		(* Qualifications & Maintenance *)
		VerifiedFormulatrixContainerModel->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this container model is fine tuned for imaging for each drop locations through Formulatrix's Rock Imager Plate Type Editor.",
			Category->"Qualifications & Maintenance",
			Developer->True
		}
	}
}];