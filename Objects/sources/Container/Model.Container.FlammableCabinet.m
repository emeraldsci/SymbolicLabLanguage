

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, FlammableCabinet], {
	Description->"A model of a flammable cabinet capable of storing flammable lab reagents and/or waste.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		AutomaticDoorClose -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the cabinet's doors are spring-loaded to close automatically when released.",
			Category -> "Container Specifications"
		},
		VolumeCapacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gallon],
			Units -> Gallon,
			Description -> "The maximum volume of flammable liquid that this model of cabinet is rated to hold.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		FireRating -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "The length of time that this model of cabinet is rated to protect its contents in case of fire.",
			Category -> "Health & Safety"
		},
		FlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "The recommended flow rate for the flammable cabinet's ventilation system.",
			Category -> "Health & Safety"
		},
		Certifications -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FlammableCabinetCertificationP,
			Description -> "Certification standards that this flammable cabinet meets or exceeds.",
			Category -> "Health & Safety"
		}
	}
}];
