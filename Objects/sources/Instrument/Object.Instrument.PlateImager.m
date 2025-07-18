

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, PlateImager], {
	Description->"An automated imager that takes brightfield images of samples in SBS plate format.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{

		RulerOffsets->{
			Format->Multiple,
			Class->{Integer,Real,Real,Real},
			Pattern:>{CameraFieldOfViewP,GreaterEqualP[0.],GreaterEqualP[0.],GreaterEqualP[0.]},
			Units->{Millimeter,None,None,None},
			Description->"The X,Y and Z offsets for instrument's cameras from its home point (0,0,0) to the center of the ruler.",
			Category->"Instrument Specifications",
			Headers->{"Field of View", "X Offset", "Y Offset", "Z Offset"}
		},
		StartPointOffsets->{
			Format->Multiple,
			Class->{Integer,Real,Real,Real},
			Pattern:>{CameraFieldOfViewP,GreaterEqualP[0.],GreaterEqualP[0.],GreaterEqualP[0.]},
			Units->{Millimeter,None,None,None},
			Description->"The X,Y and Z offsets for instrument's cameras from its home point (0,0,0) to the first imaging position.",
			Category->"Instrument Specifications",
			Headers->{"Field of View", "X Offset", "Y Offset", "Z Offset"}
		},

		(* the below fields are still being used on master*)
		PrimaryCameraXOffset->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Meter],
			Units->Meter Milli,
			Description->"The X (left-to-right) offset for the primary camera, which is the X distance from the instrument's home point (0,0,0) to the bottom left corner of the first imaging slot.",
			Category->"Instrument Specifications"
		},
		PrimaryCameraYOffset->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Meter],
			Units->Meter Milli,
			Description->"The Y (back-to-front) offset for the primary camera, which is the Y distance from the instrument's home point (0,0,0) to the bottom left corner of the first imaging slot.",
			Category->"Instrument Specifications"
		},
		PrimaryCameraZOffset->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Meter],
			Units->Meter Milli,
			Description->"The Z (bottom-to-top) offset for the primary camera, which is the Z distance from the instrument's home point (0,0,0) to the bottom left corner of the first imaging slot.",
			Category->"Instrument Specifications"
		},

		SecondaryCameraXOffset->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Meter],
			Units->Meter Milli,
			Description->"The X (left-to-right) offset for the secondary camera, which is the X distance from the instruments home point (0,0,0) to the bottom left corner of the first imaging slot.",
			Category->"Instrument Specifications"
		},
		SecondaryCameraYOffset->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Meter],
			Units->Meter Milli,
			Description->"The Y (left-to-right) offset for the secondary camera, which is the Y distance from the instruments home point (0,0,0) to the bottom left corner of the first imaging slot.",
			Category->"Instrument Specifications"
		},
		SecondaryCameraZOffset->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Meter],
			Units->Meter Milli,
			Description->"The Z (left-to-right) offset for the secondary camera, which is the Z distance from the instruments home point (0,0,0) to the bottom left corner of the first imaging slot.",
			Category->"Instrument Specifications"
		},

		PlateSlotsXOffset->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Meter],
			Units->Meter Milli,
			Description->"The X (left-to-right) distance between the bottom left corners of the first and second imaging slots.",
			Category->"Instrument Specifications"
		},
		CameraTravelSpeed -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], CameraTravelSpeed]],
			Pattern :> GreaterP[0 Millimeter/Minute],
			Description -> "The speed at which the camera arm travels when moving between wells.",
			Category -> "Instrument Specifications",
			Developer->True
		},
		ImagingInterval -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ImagingInterval]],
			Pattern :> GreaterP[0 Second],
			Description -> "The minimum amount of time between each imaging that allows for the both movement of the camera arm to the next positions and camera focusing.",
			Category -> "Instrument Specifications",
			Developer->True
		},
		COMPort -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The serial port number that the instrument is connected to on the Instrument PC.",
			Category -> "Instrument Specifications"
		}
	}
}];
