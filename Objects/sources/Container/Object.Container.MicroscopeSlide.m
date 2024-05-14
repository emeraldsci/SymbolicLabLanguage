(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container,MicroscopeSlide],{
	Description->"A microscope slide that can contain samples to be imaged with a microscope.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		PlateFootprintAdapters->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],PlateFootprintAdapters]],
			Pattern:>{ObjectReferenceP[Model[Container,Rack]]..},
			Description->"Rack models with Plate footprint that can be used to hold this type of microscope slide.",
			Developer->True,
			Category->"Compatibility"
		},
		SlideTreatment->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],SlideTreatment]],
			Pattern:>SlideTreatmentP,
			Description->"The treatment, if any, on the surface of the microscope slide.",
			Category->"Container Specifications"
		},
		PreferredMicroscope->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],PreferredMicroscope]],
			Pattern:>ObjectReferenceP[Model[Instrument,Microscope]],
			Description->"Indicates the recommended microscope type for acquiring an image from this type microscope slide.",
			Developer->True,
			Category->"Container Specifications"
		},

		(* container specs *)
		HorizontalMargin->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],HorizontalMargin]],
			Pattern:>GreaterEqualP[0*Milli*Meter],
			Description->"Distance from the left edge of the plate to the edge of the first position.",
			Category->"Container Specifications"
		},
		VerticalMargin->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],VerticalMargin]],
			Pattern:>GreaterEqualP[0*Milli*Meter],
			Description->"Distance from the top edge of the plate to the edge of the first position.",
			Category->"Container Specifications"
		},
		HorizontalPitch->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],HorizontalPitch]],
			Pattern:>GreaterP[0*Milli*Meter],
			Description->"Center-to-center distance from one position to the next in a given row.",
			Category->"Container Specifications"
		},
		VerticalPitch->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],VerticalPitch]],
			Pattern:>GreaterP[0*Milli*Meter],
			Description->"Center-to-center distance from one position to the next in a given column.",
			Category->"Container Specifications"
		},
		HorizontalOffset->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],HorizontalOffset]],
			Pattern:>GreaterP[0*Milli*Meter],
			Description->"Distance between the center of position A1 and position B1 in the X direction.",
			Category->"Container Specifications"
		},
		VerticalOffset->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],VerticalOffset]],
			Pattern:>GreaterP[0*Milli*Meter],
			Description->"Distance between the center of position A1 and position A2 in the Y direction.",
			Category->"Container Specifications"
		},
		Rows->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Rows]],
			Pattern:>GreaterP[0,1],
			Description->"The number of rows of positions on the microscope slide.",
			Category->"Container Specifications"
		},
		Columns->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Columns]],
			Pattern:>GreaterP[0,1],
			Description->"The number of columns of positions on the microscope slide.",
			Category->"Container Specifications"
		},
		NumberOfPositions->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],NumberOfPositions]],
			Pattern:>GreaterP[0,1],
			Description->"Number of individual wells the plate has.",
			Category->"Container Specifications",
			Abstract->True
		},
		AspectRatio->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],AspectRatio]],
			Pattern:>GreaterP[0],
			Description->"Ratio of the number of columns of positions vs the number of rows of positions on the microscope slide.",
			Category->"Container Specifications"
		},
		Coverslipped->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Coverslipped]],
			Pattern:>BooleanP,
			Description->"Indicates if a coverslip is placed over the sample on this microscope slide.",
			Category->"Container Specifications"
		},
		CoverslipThickness->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],CoverslipThickness]],
			Pattern:>GreaterP[0 Millimeter],
			Description->"The physical thickness of the coverslip placed on over the sample on the microscope slide.",
			Category->"Container Specifications"
		},
		PreferredObjectiveMagnification->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],PreferredObjectiveMagnification]],
			Pattern:>GreaterP[0],
			Description->"Indicates the recommended objective magnification for acquiring an image from this microscope slide.",
			Category->"Container Specifications"
		}
	}
}];