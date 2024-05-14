

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, FlammableCabinet], {
	Description->"A cabinet capable of storing flammable lab reagents and/or waste.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		VolumeCapacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], VolumeCapacity]],
			Pattern :> GreaterEqualP[0*Gallon],
			Description -> "The maximum volume of flammable liquid that this cabinet is rated to hold.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		AutomaticDoorClose -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], AutomaticDoorClose]],
			Pattern :> BooleanP,
			Description -> "Indicates if the cabinet's doors are spring-loaded to close automatically when released.",
			Category -> "Container Specifications"
		},
		FlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], FlowRate]],
			Pattern :> GreaterEqualP[(0*Liter)/Minute],
			Description -> "The recommended flow rate for the flammable cabinet's ventilation system.",
			Category -> "Health & Safety"
		},
		FireRating -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], FireRating]],
			Pattern :> GreaterEqualP[0*Hour],
			Description -> "The length of time that this cabinet is rated to protect its contents in case of fire.",
			Category -> "Health & Safety"
		},
		Certifications -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Certifications]],
			Pattern :> {FlammableCabinetCertificationP..},
			Description -> "Certification standards that this cabinet meets or exceeds.",
			Category -> "Health & Safety"
		}
	}
}];
