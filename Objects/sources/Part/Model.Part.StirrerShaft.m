(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, StirrerShaft], {
	Description->"Model information for a shaft/impeller assembly used to mix solutions using an overhead stirrer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {		
		StirrerLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milli Meter],
			Units-> Milli Meter,
			Description -> "The overall length of the stirrer.",
			Category -> "Dimensions & Positions"
		},
		ShaftDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :>GreaterP[0 Milli Meter],
			Units-> Milli Meter,
			Description -> "The outside diameter of the stirrer stem.",
			Category -> "Dimensions & Positions"
		},
		ImpellerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milli Meter],
			Units->  Milli Meter,
			Description -> "Diameter swept by the impeller blades when mixing.",
			Category -> "Dimensions & Positions"
		},
		MaxDiameter->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milli Meter],
			Units->  Milli Meter,
			Description -> "The maximum diameter of the stirrer shaft when the impeller is fully collapsed, if it is collapsable.",
			Category -> "Dimensions & Positions"
		},
		CompatibleMixers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, OverheadStirrer][CompatibleImpellers],
			Description -> "Overhead stirrers that can use this stirrer shaft.",
			Category -> "Model Information"
		}
	}
}];
