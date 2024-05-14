(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Microscope],{
	Description->"A protocol that verifies the functionality of the microscope target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		QualificationMicroscopeSlide->{
			Format->Single,
			Class->Link,
			Relation->Model[Container,MicroscopeSlide]|Object[Container,MicroscopeSlide],
			Pattern:>_Link,
			Description->"The prepared microscope slide containing reference samples that will be imaged by the microscope.",
			Category -> "General"
		},
		AdjustmentSamples->{
			Format->Multiple,
			Class->Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Pattern:>_Link,
			Description->"Specifies the samples mounted on the QualificationMicroscopeSlide to be used to adjust the ExposureTime and FocalHeight in each imaging session.",
			Category -> "General"
		},
		SamplingNumberOfRows->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"The number of rows of images which will be acquired for each sample.",
			Category -> "General"
		},
		SamplingNumberOfColumns->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"The number of columns of images which will be acquired for each sample.",
			Category -> "General"
		},
		SamplingRowSpacing->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[-85 Millimeter,85 Millimeter],
			Units->Micrometer,
			Description->"The distance between each column of images to be acquired. Negative distances indicate overlapping regions between adjacent rows.",
			Category -> "General"
		},
		SamplingColumnSpacing->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[-127 Millimeter,127 Millimeter],
			Units->Micrometer,
			Description->"The distance between each column of images to be acquired. Negative values indicate overlapping regions between adjacent columns.",
			Category -> "General"
		},
		SamplingCoordinates->{
			Format->Multiple,
			Class->{Real,Real},
			Pattern:>{RangeP[-127 Millimeter,127 Millimeter],RangeP[-85 Millimeter,85 Millimeter]},
			Units->{Micrometer,Micrometer},
			Headers->{"X Coordinate","Y Coordinate"},
			Description->"Specifies the positions at which images are acquired. The coordinates in the form (X,Y) are referenced to the center of each position in the sample's container, which has coordinates of (0,0).",
			Category -> "General"
		}
	}
}];