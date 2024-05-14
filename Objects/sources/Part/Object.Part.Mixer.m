(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, Mixer], {
	Description->"A module designed to homogenize passing liquids.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		FPLC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, FPLC][Mixer]
			],
			Description -> "The FPLC instrument that is connected to this part.",
			Category -> "Instrument Specifications"
		}
	}
}];
