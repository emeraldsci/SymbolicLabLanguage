(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container,Hemocytometer],{
	Description->"A hemocytometer, a counting-chamber device used for counting cells with a microscope.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		RecommendedFillVolume->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],RecommendedFillVolume]],
			Pattern:>GreaterP[0 Microliter],
			Description->"The largest recommended fill volume in each chamber of this hemocytometer.",
			Category->"Operating Limits",
			Abstract->True
		},
		PlateFootprintAdapters->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],PlateFootprintAdapters]],
			Pattern:>{ObjectReferenceP[Model[Container,Rack]]..},
			Description->"Rack models with Plate footprint that can be used to hold this type of hemocytometer.",
			Developer->True,
			Category->"Compatibility"
		},
		ChamberDimensions->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ChamberDimensions]],
			Pattern:>{GreaterP[0 Millimeter],GreaterP[0 Millimeter]},
			Description->"Internal size of each chamber in this model of hemocytometer.",
			Category->"Container Specifications"
		},
		ChamberDepth->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ChamberDepth]],
			Pattern:>GreaterEqualP[0 Millimeter],
			Description->"Maximum z-axis depth of each chamber opening.",
			Category->"Container Specifications"
		},
		NumberOfChambers->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],NumberOfChambers]],
			Pattern:>GreaterP[0,1],
			Description->"Number of individual chambers the hemocytometer has.",
			Category->"Dimensions & Positions"
		},
		GridDimensions->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],GridDimensions]],
			Pattern:>{GreaterP[0 Millimeter],GreaterP[0 Millimeter]},
			Headers->{"Width","Depth"},
			Description->"The size of each counting grid in this model of hemocytometer.",
			Category->"Container Specifications"
		},
		GridHorizontalMargin->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],GridHorizontalMargin]],
			Pattern:>GreaterEqualP[0 Millimeter],
			Description->"Distance from the left edge of the hemocytometer to the edge of the first grid.",
			Category->"Container Specifications"
		},
		GridVerticalMargin->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],GridVerticalMargin]],
			Pattern:>GreaterEqualP[0 Millimeter],
			Description->"Distance from the top edge of the hemocytometer to the edge of the first grid.",
			Category->"Container Specifications"
		},
		GridHorizontalPitch->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],GridHorizontalPitch]],
			Pattern:>GreaterEqualP[0 Millimeter],
			Description->"Center-to-center distance from one well to the next in a given row.",
			Category->"Container Specifications"
		},
		GridVerticalPitch->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],GridVerticalPitch]],
			Pattern:>GreaterEqualP[0 Millimeter],
			Description->"Center-to-center distance from one well to the next in a given column.",
			Category->"Container Specifications"
		},
		GridPattern->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],GridPattern]],
			Pattern:>HemocytometerGridPatternP,
			Description->"Indicates the type of grid pattern that this hemocytometer has.",
			Category->"Container Specifications"
		},
		GridRows->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],GridRows]],
			Pattern:>GreaterP[0,1],
			Description->"The number of counting grid rows the hemocytometer has.",
			Category->"Dimensions & Positions"
		},
		GridColumns->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],GridColumns]],
			Pattern:>GreaterP[0,1],
			Description->"The number of counting grid columns the hemocytometer has.",
			Category->"Dimensions & Positions"
		},
		NumberOfGrids->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],NumberOfGrids]],
			Pattern:>GreaterP[0,1],
			Description->"Number of individual counting grid the hemocytometer has.",
			Category->"Dimensions & Positions"
		},
		SubregionRows->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],SubregionRows]],
			Pattern:>GreaterP[0,1],
			Description->"The number of subregion rows each counting grid has.",
			Category->"Dimensions & Positions"
		},
		SubregionColumns->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],SubregionColumns]],
			Pattern:>GreaterP[0,1],
			Description->"The number of subregion columns each counting grid has.",
			Category->"Dimensions & Positions"
		},
		NumberOfSubregions->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],NumberOfSubregions]],
			Pattern:>GreaterP[0,1],
			Description->"Number of individual subregions each counting grid has.",
			Category->"Dimensions & Positions"
		},
		SubregionVolume->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],SubregionVolume]],
			Pattern:>GreaterP[0 Microliter],
			Description->"Indicates total fluid volume that each grid subregion can contain.",
			Category->"Container Specifications"
		},
		PreferredMicroscope->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],PreferredMicroscope]],
			Pattern:>ObjectReferenceP[Model[Instrument,Microscope]],
			Description->"Indicates the recommended microscope type for acquiring an image from this type hemocytometer.",
			Developer->True,
			Category->"Container Specifications"
		},
		PreferredObjectiveMagnification->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],PreferredObjectiveMagnification]],
			Pattern:>GreaterP[0],
			Description->"Indicates the recommended objective magnification for acquiring an image from this type hemocytometer.",
			Category->"Container Specifications"
		}
	}
}];