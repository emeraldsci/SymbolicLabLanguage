(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,InoculationPaper],{
	Description->"A model of a piece of paper designed to be inoculated with a fluid sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Shape->{
			Format->Single,
			Class->Expression,
			Pattern:>Disk,
			Description->"The geometric shape of the 2D plane of the paper.",
			Category->"Dimensions & Positions"
		},
		Diameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"The diameter of the paper, if the 2D plane of the paper is Disk.",
			Category->"Dimensions & Positions"
		},
		PaperThickness->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer],
			Units->Micrometer,
			Description->"The height of the dimension perpendicular to the plane of the paper.",
			Category->"Dimensions & Positions"
		},
		PaperWeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Gram/(Meter^2)],
			Units->Gram/(Meter^2),
			Description->"The weight per area of paper.",
			Category->"Dimensions & Positions"
		}
	}
}]