(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument,CondensateRecirculator], {
	Description->"An instrument that supplies water to another instrument and recycles water condensation.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		EnvironmentalChambers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, EnvironmentalChamber][IntegratedCondensateRecirculator],
			Description -> "The environmental chambers that is connected to this condensate recirculator such that to control humidity level.",
			Category -> "Integrations"
		}
	}
}];
