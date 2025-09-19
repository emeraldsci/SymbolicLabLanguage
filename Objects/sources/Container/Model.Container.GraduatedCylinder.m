

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, GraduatedCylinder], {
	Description->"A graduated cylinder device for high precision measurement of large volumes.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Milli,
			Description -> "Resolution of the cylinder's volume-indicating markings, the volume between gradation subdivisions.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		Graduations->{
			Format->Multiple,
			Class->Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The markings on this cylinder model used to indicate the fluid's fill level.",
			Abstract->True,
			Category -> "Container Specifications"
		},
		GraduationTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GraduationTypeP,
			Description -> "For each member of Graduations, indicates if the graduation is labeled with a number, a long unlabeled line, or a short unlabeled line.",
			Category -> "Container Specifications",
			IndexMatching -> Graduations
		},
		GraduationLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of Graduations, if GraduationTypes is Labeled, exactly matches the labeling text. Otherwise, Null.",
			Category -> "Container Specifications",
			IndexMatching -> Graduations,
			Developer -> True
		}(*,
		GraduationCalibration -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Deliver, Contain, Both],
			Description -> "Indicates if the manufacture calibrated the graduations for dispensing an accurate volume to a destination (i.e. 'To Deliver') or for taking an accurate volume from a source (i.e. 'To Contain').",
			Category -> "Container Specifications",
			Abstract -> True
		}*)
	}
}];
