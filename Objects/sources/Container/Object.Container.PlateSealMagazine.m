(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, PlateSealMagazine], {
	Description->"A container with SBS dimensions for placing Plate Seals inside.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, LiquidHandler][IntegratedClearPlateSealMagazine],
				Object[Instrument, LiquidHandler][IntegratedFoilPlateSealMagazine]
			],
			Description -> "The liquid handler that connects to this magazine park position.",
			Category -> "Integrations"
		}
	}
}];
