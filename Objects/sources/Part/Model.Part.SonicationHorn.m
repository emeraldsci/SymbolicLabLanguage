(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, SonicationHorn], {
	Description->"Model information for a shaft/impeller assembly used to mix solutions using an overhead stirrer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		HornLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milli Meter],
			Units-> Milli Meter,
			Description -> "The length of the sonication horn, only including the length of the horn that is submersible in the sample.",
			Category -> "Dimensions & Positions"
		},
		HornDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :>GreaterP[0 Milli Meter],
			Units-> Milli Meter,
			Description -> "The maximum diameter of the sonication horn, only including the length of the horn that is submersible in the sample.",
			Category -> "Dimensions & Positions"
		},
		MaxDiameter->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milli Meter],
			Units->  Milli Meter,
			Description -> "The maximum diameter of the entire sonication horn.",
			Category -> "Dimensions & Positions"
		},
		CompatibleMixers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, Homogenizer][CompatibleSonicationHorns],
			Description -> "Homogenizers that can use this sonication horn.",
			Category -> "Model Information"
		}
	}
}];
