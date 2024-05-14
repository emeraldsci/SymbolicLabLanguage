(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Clean, ESISource], {
	Description->"A protocol that cleans and ensure the proper function of mass spectrometry electrospray ionization (ESI) sources.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CleaningSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The liquid used to clean the pump heads and new seals.",
			Category -> "Cleaning"
		}
	}
		
}];
