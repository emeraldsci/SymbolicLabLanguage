(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,Microscope],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a microscope.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		QualificationMicroscopeSlide->{
			Format->Single,
			Class->Link,
			Relation->Model[Container,MicroscopeSlide],
			Pattern:>_Link,
			Description->"The model of a prepared microscope slide containing reference samples that will be imaged by the microscope.",
			Category -> "General"
		},
		SampleTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MicroscopeQualSampleTypeP,
			Description->"For each member of QualificationSamples, specifies if the sample is directly imaged (Sample) or used to adjust the ExposureTime and FocalHeight of all other samples (Adjustment) in the imaging session.",
			Category -> "General",
			IndexMatching->QualificationSamples
		},
		QualificationSamples->{
			Format->Multiple,
			Class->Link,
			Relation->Model[Sample],
			Pattern:>_Link,
			Description->"Specifies the sample models mounted on the QualificationMicroscopeSlide to be imaged by the microscope.",
			Category -> "General"
		},
		AcquireImagePrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>AcquireImagePrimitiveP,
			Description->"A list of acquisition parameters used to acquire images of the input sample.",
			Category -> "General"
		},
		SamplingPattern->{
			Format->Single,
			Class->Expression,
			Pattern:>MicroscopeSamplingMethodP,
			Description->"The pattern of images that will be acquired from the samples.",
			Category -> "General"
		},
		ObjectiveMagnification->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"The magnification of the objective lens that should be used to image the sample.",
			Category -> "General"
		}
	}
}];