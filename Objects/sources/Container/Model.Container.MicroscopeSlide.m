(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container,MicroscopeSlide],{
	Description->"A model for a microscope slide that can contain samples to be imaged with a microscope.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		PlateFootprintAdapters->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container,Rack],
			Description->"Rack models with Plate footprint that can be used to hold this type of microscope slide.",
			Developer->True,
			Category->"Compatibility"
		},
		SlideTreatment->{
			Format->Single,
			Class->Expression,
			Pattern:>SlideTreatmentP,
			Description->"The treatment, if any, on the surface of the microscope slide.",
			Category->"Container Specifications"
		},
		PreferredMicroscope->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Instrument,Microscope],
			Description->"Indicates the recommended microscope type for acquiring an image from this type microscope slide.",
			Developer->True,
			Category->"Container Specifications"
		},

		(* container specs *)
		HorizontalMargin->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli*Meter],
			Units->Meter Milli,
			Description->"Distance from the left edge of the plate to the edge of the first position.",
			Category->"Container Specifications"
		},
		VerticalMargin->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli*Meter],
			Units->Meter Milli,
			Description->"Distance from the top edge of the plate to the edge of the first position.",
			Category->"Container Specifications"
		},
		HorizontalPitch->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milli*Meter],
			Units->Meter Milli,
			Description->"Center-to-center distance from one position to the next in a given row.",
			Category->"Container Specifications"
		},
		VerticalPitch->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milli*Meter],
			Units->Meter Milli,
			Description->"Center-to-center distance from one position to the next in a given column.",
			Category->"Container Specifications"
		},
		HorizontalOffset->{
			Format->Single,
			Class->Real,
			Pattern:>DistanceP,
			Units->Meter Milli,
			Description->"Distance between the center of position A1 and position B1 in the X direction.",
			Category->"Container Specifications"
		},
		VerticalOffset->{
			Format->Single,
			Class->Real,
			Pattern:>DistanceP,
			Units->Meter Milli,
			Description->"Distance between the center of position A1 and position A2 in the Y direction.",
			Category->"Container Specifications"
		},
		Rows->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Units->None,
			Description->"The number of rows of positions on the microscope slide.",
			Category->"Dimensions & Positions"
		},
		Columns->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Units->None,
			Description->"The number of columns of positions on the microscope slide.",
			Category->"Dimensions & Positions"
		},
		NumberOfPositions->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Units->None,
			Description->"Number of individual positions the microscope slide has.",
			Category->"Dimensions & Positions"
		},
		AspectRatio->{
			Format->Single,
			Class->Expression,
			Pattern:>GreaterP[0],
			Description->"Ratio of the number of columns of positions vs the number of rows of positions on the microscope slide.",
			Category->"Dimensions & Positions"
		},
		Coverslipped->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if a coverslip is placed over the sample on this microscope slide.",
			Category->"Container Specifications"
		},
		CoverslipThickness->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli*Meter],
			Units->Meter Milli,
			Description->"The physical thickness of the coverslip placed on over the sample on the microscope slide.",
			Category->"Container Specifications"
		},
		PreferredObjectiveMagnification->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"Indicates the recommended objective magnification for acquiring an image from this type of microscope slide.",
			Category->"Container Specifications"
		},
		MetaXpressPrefix->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The unique string prefix used to reference this container in the MetaXpress software.",
			Category -> "General",
			Developer->True
		},
		KitProductsContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][KitComponents, ProductModel],
			Description -> "Products ordering information for this microscope slide container with its supplied samples as part of one or more kits.",
			Category -> "Inventory"
		}
	}
}];