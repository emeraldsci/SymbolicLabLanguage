(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item,InoculationPaper],{
	Description->"A piece of paper designed to be inoculated with a fluid sample.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		Shape->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Shape]],
			Pattern:>Disk,
			Description->"The geometric shape of the 2D plane of the paper.",
			Category->"Dimensions & Positions"
		},
		Diameter->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Diameter]],
			Pattern:>GreaterP[0 Millimeter],
			Description->"The diameter of the paper, if the 2D plane of the paper is Circle.",
			Category->"Dimensions & Positions"
		},
		PaperThickness->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],PaperThickness]],
			Pattern:>GreaterP[0 Micrometer],
			Description->"The height of the dimension perpendicular to the plane of the paper.",
			Category->"Dimensions & Positions"
		},
		PaperWeight->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],PaperWeight]],
			Pattern:>GreaterP[0 Gram/(Meter^2)],
			Description->"The weight per area of paper.",
			Category->"Dimensions & Positions"
		}
	}
}]
