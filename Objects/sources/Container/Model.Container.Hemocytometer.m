(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container,Hemocytometer],{
	Description->"A model for a hemocytometer, a counting-chamber device used for counting cells with a microscope.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		RecommendedFillVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"The largest recommended fill volume in each chamber of this hemocytometer.",
			Category->"Operating Limits",
			Abstract->True
		},
		PlateFootprintAdapters->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container,Rack],
			Description->"Rack models with Plate footprint that can be used to hold this type of hemocytometer.",
			Developer->True,
			Category->"Compatibility"
		},
		MetaXpressPrefix->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The unique labware ID string prefix used to reference this model of hemocytometer in the MetaXpress software.",
			Category -> "General",
			Developer->True
		},
		ChamberDimensions->{
			Format->Single,
			Class->{Real,Real},
			Pattern:>{GreaterP[0 Millimeter],GreaterP[0 Millimeter]},
			Units->{Millimeter,Millimeter},
			Headers->{"Width","Depth"},
			Description->"Internal size of each chamber in this model of hemocytometer.",
			Category->"Container Specifications"
		},
		ChamberDepth->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimeter],
			Units->Millimeter,
			Description->"Maximum z-axis depth of each chamber opening.",
			Category->"Container Specifications"
		},
		NumberOfChambers->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Units->None,
			Description->"Number of individual chambers the hemocytometer has.",
			Category->"Dimensions & Positions"
		},

		(* big grid parameters *)
		GridDimensions->{
			Format->Single,
			Class->{Real,Real},
			Pattern:>{GreaterP[0 Millimeter],GreaterP[0 Millimeter]},
			Units->{Millimeter,Millimeter},
			Headers->{"Width","Depth"},
			Description->"The size of each counting grid in this model of hemocytometer.",
			Category->"Container Specifications"
		},
		GridHorizontalMargin->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimeter],
			Units->Millimeter,
			Description->"Distance from the left edge of the hemocytometer to the edge of the first grid.",
			Category->"Container Specifications"
		},
		GridVerticalMargin->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimeter],
			Units->Millimeter,
			Description->"Distance from the top edge of the hemocytometer to the edge of the first grid.",
			Category->"Container Specifications"
		},
		GridHorizontalPitch->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimeter],
			Units->Millimeter,
			Description->"Center-to-center distance from one well to the next in a given row.",
			Category->"Container Specifications"
		},
		GridVerticalPitch->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimeter],
			Units->Millimeter,
			Description->"Center-to-center distance from one well to the next in a given column.",
			Category->"Container Specifications"
		},
		GridPattern->{
			Format->Single,
			Class->Expression,
			Pattern:>HemocytometerGridPatternP,
			Description->"Indicates the type of grid pattern that this hemocytometer has.",
			Category->"Container Specifications"
		},
		GridRows->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Units->None,
			Description->"The number of counting grid rows the hemocytometer has.",
			Category->"Dimensions & Positions"
		},
		GridColumns->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Units->None,
			Description->"The number of counting grid columns the hemocytometer has.",
			Category->"Dimensions & Positions"
		},
		NumberOfGrids->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Units->None,
			Description->"Number of individual counting grid the hemocytometer has.",
			Category->"Dimensions & Positions"
		},
		GridAspectRatio->{
			Format->Single,
			Class->Expression,
			Pattern:>GreaterP[0],
			Description->"Ratio of the number of columns of grids vs the number of rows of grids on the plate.",
			Category->"Dimensions & Positions"
		},
		GridPositions->{
			Format->Multiple,
			Class->{
				Name->String,
				Footprint->Expression,
				MaxWidth->Real,
				MaxDepth->Real,
				MaxHeight->Real
			},
			Pattern:>{
				Name->LocationPositionP,
				Footprint->(FootprintP|Open),
				MaxWidth->GreaterP[0 Millimeter],
				MaxDepth->GreaterP[0 Millimeter],
				MaxHeight->GreaterP[0 Millimeter]
			},
			Units->{
				Name->None,
				Footprint->None,
				MaxWidth->Millimeter,
				MaxDepth->Millimeter,
				MaxHeight->Millimeter
			},
			Description->"Spatial definitions of the counting grid positions that exist in this model of hemocytometer.",
			Headers->{
				Name->"Name of Position",
				Footprint->"Footprint",
				MaxWidth->"Max Width",
				MaxDepth->"Max Depth",
				MaxHeight->"Max Height"
			},
			Category->"Dimensions & Positions"
		},
		GridPositionPlotting->{
			Format->Multiple,
			Class->{Name->String,XOffset->Real,YOffset->Real,ZOffset->Real,CrossSectionalShape->Expression,Rotation->Real},
			Pattern:>{Name->LocationPositionP,XOffset->GreaterEqualP[0 Meter],YOffset->GreaterEqualP[0 Meter],ZOffset->GreaterEqualP[0 Meter],CrossSectionalShape->CrossSectionalShapeP,Rotation->GreaterEqualP[-180]},
			Units->{Name->None,XOffset->Meter,YOffset->Meter,ZOffset->Meter,CrossSectionalShape->None,Rotation->None},
			Description->"For each member of GridPositions, the parameters required to plot the position, where the offsets refer to the location of the center of the position relative to the close, bottom, left hand corner of the container model's dimensions.",
			IndexMatching->GridPositions,
			Headers->{Name->"Name of Position",XOffset->"XOffset",YOffset->"YOffset",ZOffset->"ZOffset",CrossSectionalShape->"Cross Sectional Shape",Rotation->"Rotation"},
			Category->"Dimensions & Positions",
			Developer->True
		},
		GridSchematics->{
			Format->Multiple,
			Class->{Link,String},
			Pattern:>{_Link,_String},
			Units->{None,None},
			Relation->{Object[EmeraldCloudFile],Null},
			Description->"Detailed drawings of the counting grid of this hemocytometer.",
			Category->"Container Specifications",
			Headers->{"Schematic","Caption"}
		},

		(* subregion fields *)
		SubregionRows->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Units->None,
			Description->"The number of subregion rows each counting grid has.",
			Category->"Dimensions & Positions"
		},
		SubregionColumns->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Units->None,
			Description->"The number of subregion columns each counting grid has.",
			Category->"Dimensions & Positions"
		},
		NumberOfSubregions->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Units->None,
			Description->"Number of individual subregions each counting grid has.",
			Category->"Dimensions & Positions"
		},
		SubregionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"Indicates total fluid volume that each grid subregion can contain.",
			Category->"Container Specifications"
		},
		SubregionPositions->{
			Format->Multiple,
			Class->{
				Name->String,
				Footprint->Expression,
				MaxWidth->Real,
				MaxDepth->Real,
				MaxHeight->Real,
				SubdivisionRows->Integer,
				SubdivisionColumns->Integer,
				SubdivisionWidth->Real,
				SubdivisionDepth->Real
			},
			Pattern:>{
				Name->LocationPositionP,
				Footprint->(FootprintP|Open),
				MaxWidth->GreaterP[0 Millimeter],
				MaxDepth->GreaterP[0 Millimeter],
				MaxHeight->GreaterP[0 Millimeter],
				SubdivisionRows->GreaterP[0,1],
				SubdivisionColumns->GreaterP[0,1],
				SubdivisionWidth->GreaterP[0 Millimeter],
				SubdivisionDepth->GreaterP[0 Millimeter]
			},
			Units->{
				Name->None,
				Footprint->None,
				MaxWidth->Millimeter,
				MaxDepth->Millimeter,
				MaxHeight->Millimeter,
				SubdivisionRows->None,
				SubdivisionColumns->None,
				SubdivisionWidth->Millimeter,
				SubdivisionDepth->Millimeter
			},
			Description->"Spatial definitions of the counting grid subregion positions that exist in this model of hemocytometer.",
			Headers->{
				Name->"Name of Position",
				Footprint->"Footprint",
				MaxWidth->"Max Width",
				MaxDepth->"Max Depth",
				MaxHeight->"Max Height",
				SubdivisionRows->"Subdivision Rows",
				SubdivisionColumns->"Subdivision Columns",
				SubdivisionWidth->"Subdivision Width",
				SubdivisionDepth->"Subdivision Depth"
			},
			Category->"Dimensions & Positions"
		},
		SubregionPositionPlotting->{
			Format->Multiple,
			Class->{Name->String,XOffset->Real,YOffset->Real,ZOffset->Real,CrossSectionalShape->Expression,Rotation->Real},
			Pattern:>{Name->LocationPositionP,XOffset->GreaterEqualP[0 Meter],YOffset->GreaterEqualP[0 Meter],ZOffset->GreaterEqualP[0 Meter],CrossSectionalShape->CrossSectionalShapeP,Rotation->GreaterEqualP[-180]},
			Units->{Name->None,XOffset->Meter,YOffset->Meter,ZOffset->Meter,CrossSectionalShape->None,Rotation->None},
			Description->"For each member of SubregionPositions, the parameters required to plot the position, where the offsets refer to the location of the center of the position relative to the close, bottom, left hand corner of the container model's dimensions.",
			IndexMatching->SubregionPositions,
			Headers->{Name->"Name of Position",XOffset->"XOffset",YOffset->"YOffset",ZOffset->"ZOffset",CrossSectionalShape->"Cross Sectional Shape",Rotation->"Rotation"},
			Category->"Dimensions & Positions",
			Developer->True
		},

		PreferredMicroscope->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Instrument,Microscope],
			Description->"Indicates the recommended microscope type for acquiring an image from this type hemocytometer.",
			Developer->True,
			Category->"Container Specifications"
		},
		PreferredObjectiveMagnification->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"Indicates the recommended objective magnification for acquiring an image from this type hemocytometer.",
			Category->"Container Specifications"
		}
	}
}];