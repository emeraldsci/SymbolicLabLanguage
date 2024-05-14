(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, PlateTilter], {
	Description->"An instrument used for tilting plates on a robotic liquid handler.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedPlateTilters],
			Description -> "The liquid handler that is connected to this plate tilter.",
			Category -> "Integrations"
		}
	}
}];
