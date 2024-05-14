

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
		}
	}
}];
