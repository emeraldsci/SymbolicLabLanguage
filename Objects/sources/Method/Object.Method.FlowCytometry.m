

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)
(* TODO: VOQ this method object *)

DefineObjectType[Object[Method, FlowCytometry], {
	Description->"A method containing optics settings to run a flow cytometer experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Detector->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FlowCytometryDetectorP,
			Description -> "The detectors which should be used to detect light scattered off the samples.",
			Category-> "General"
		},
		DetectionLabel->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Molecule]
			],
			IndexMatching -> Detector,
			Description -> "For each member of Detector, the tag, including fluorescent or non-fluorescent chemical compounds or proteins, attached to the sample that will be analyzed by the Detectors.",
			Category-> "General"
		},
		ExcitationWavelength->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FlowCytometryExcitationWavelengthP,
			Description -> "The wavelength(s) which should be used to excite fluorescence and scatter off the samples.",
			Category-> "General"
		},
		ExcitationPower->{
			Format -> Multiple,
			Class -> Real,
			Pattern :>RangeP[0*Milli*Watt,100*Milli*Watt],
			Units -> Milli*Watt,
			IndexMatching -> ExcitationWavelength,
			Description -> "For each member of ExcitationWavelength, the power which should be used to excite fluorescence and scatter off the samples.",
			Category-> "General"
		},
		Gain->{
			Format -> Multiple,
			Class -> Real,
			Pattern :>GreaterEqualP[0Volt],
			Units -> Volt,
			IndexMatching -> Detector,
			Description -> "For each member of Detector, the voltage the PMT should be set to to detect the scattered light off the sample.",
			Category-> "General"
		},
		NeutralDensityFilter->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Detector, if a neutral density filter with an optical density of 2.0 should be used lower the intensity of scattered light that hits the detector.",
			Category-> "General",
			IndexMatching -> Detector
		}
}
}];
