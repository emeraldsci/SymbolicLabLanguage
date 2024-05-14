(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance,CalibrateMicroscope],{
	Description->"A protocol that generates a calibration for a light path on a microscope.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		CondenserHeight->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0 Centimeter,100 Centimeter],
			Units->Centimeter,
			Description->"The distance between the bottom of the condenser head and the top of the microscope stage used to adjust the Koehler illumination for BrightField and PhaseContrast imaging. Koehler Illumination is a process that provides optimum contrast and resolution by focusing and centering the light path and spreading it evenly over the field of view.",
			Category->"Calibration"
		},
		CondenserXPosition->{
			Format->Single,
			Class->Integer,
			Pattern:>RangeP[0,10],
			Description->"The setting of the knob controlling the X-position alignment of the condenser to adjust the Koehler illumination during BrightField and PhaseContrast imaging.",
			Category->"Calibration"
		},
		CondenserYPosition->{
			Format->Single,
			Class->Integer,
			Pattern:>RangeP[0,10],
			Description->"The setting of the knob controlling the Y-position alignment of the condenser to adjust the Koehler illumination during BrightField and PhaseContrast imaging.",
			Category->"Calibration"
		},
		PhaseRingXPosition->{
			Format->Single,
			Class->Integer,
			Pattern:>RangeP[0,10],
			Description->"The setting of the knob controlling the X-position alignment of the phase ring. 0 refers to when the knob is as far counterclockwise as possible.",
			Category->"Calibration"
		},
		PhaseRingYPosition->{
			Format->Single,
			Class->Integer,
			Pattern:>RangeP[0,10],
			Description->"The setting of the knob controlling the Y-position alignment of the phase ring. 0 refers to when the knob is as far counterclockwise as possible.",
			Category->"Calibration"
		},
		ApertureDiaphragm->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0 Percent,100 Percent],
			Units->Percent,
			Description->"The setting of the slider controlling the aperture diaphragm opening that allows control over brightness and contrast of the image during BrightField and PhaseContrast imaging. The aperture diaphragm controls the angle of the light rays emerging from the condenser and reaching the specimen.",
			Category->"Calibration"
		},
		FieldDiaphragm->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0 Percent,100 Percent],
			Units->Percent,
			Description->"The setting of the slider controlling the field-of-view size during BrightField and PhaseContrast imaging. The field diaphragm determines which portion and size of the sample is illuminated.",
			Category->"Calibration"
		},
		PhaseRingImageFile->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description->"The raw image file of the phase ring acquired by a microscope after adjustment of PhaseRingXPosition and PhaseRingYPosition.",
			Category->"Calibration"
		},
		FieldDiaphragmImageFile->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description->"The raw image file of the field diaphragm acquired by a microscope after condenser height focus adjustment.",
			Category->"Calibration"
		},
		PhaseRingImage->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[PhaseRingImageFile]},ImportCloudFile[Field[PhaseRingImageFile]]],
			Pattern:>_Image,
			Description->"The image of the phase ring acquired by a microscope after adjustment of PhaseRingXPosition and PhaseRingYPosition.",
			Category->"Calibration",
			Abstract->True
		},
		FieldDiaphragmImage->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[FieldDiaphragmImageFile]},ImportCloudFile[Field[FieldDiaphragmImageFile]]],
			Pattern:>_Image,
			Description->"The image of the field diaphragm acquired by a microscope after condenser height focus adjustment.",
			Category->"Calibration",
			Abstract->True
		}
	}
}];