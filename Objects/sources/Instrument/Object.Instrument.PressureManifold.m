(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, PressureManifold], {
	Description-> "A instrument that uses positive air pressure to perform filtration and solid-phase extraction.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedPressureManifold],
			Description -> "The liquid handler that is connected to this pressure filter such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		Deck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck],
			Description -> "The main deck of the pressure manifold instrument.",
			Category -> "Container Specifications"
		}
	}
}];
