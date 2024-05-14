

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Stand], {
	Description->"A model of a container with base and a rod to which holders are attached.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		RodLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "The length of the stand rod from the base to its tip.",
			Category -> "Container Specifications"
		},
		RodDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "The diameter of the stand rod.",
			Category -> "Container Specifications"
		}
	}
}];


(*rodclamp footprint*)

(* model container clamp

 maxDiameter, minDiameter *)

(* rod <- clamp <- whatever (match foorprints + diameters) *)