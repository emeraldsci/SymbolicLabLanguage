(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument,EnvironmentalChamber], {
	Description->"A testing chamber capable of controlling temperature, humidity, and/or UV-Vis light exposure",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		IntegratedCondensateRecirculator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, CondensateRecirculator][EnvironmentalChambers],
			Description -> "The CondensateRecirculator that is connected to this environmental chamber so that humidity can be regulated.",
			Category -> "Integrations"
		}
	}
}];
