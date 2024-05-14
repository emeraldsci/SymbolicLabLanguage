(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, MagazineParkPosition], {
	Description->"A container with SBS dimensions for placing Plate Seal Magazine on top.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, LiquidHandler][IntegratedClearMagazineParkPosition],
				Object[Instrument, LiquidHandler][IntegratedFoilMagazineParkPosition]
			],
			Description -> "The liquid handler that connects to this magazine park position.",
			Category -> "Integrations"
		}
	}
}];
