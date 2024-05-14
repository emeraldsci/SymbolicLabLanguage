(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Maintenance,CalibrateMicroscope],{
	Description->"Definition of a set of parameters for a maintenance protocol that calibrates a microscope.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		CalibrateCondenserHeight->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the condenser height should be calibrated during the maintenance run.",
			Category->"Calibration"
		},
		CalibratePhaseRing->{
		    Format->Single,
		    Class->Boolean,
		    Pattern:>BooleanP,
			Description->"Indicates if the phase ring should be calibrated during the maintenance run.",
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
		}
	}
}];