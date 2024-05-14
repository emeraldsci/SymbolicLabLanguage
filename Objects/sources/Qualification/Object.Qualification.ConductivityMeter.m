(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,ConductivityMeter], {
	Description->"A protocol that verifies the functionality of the conductivity meter target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		ConductivityData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Conductivity],
			Description -> "For each member of QualificationSamples, the conductivity information collected using the target conductivity meter.",
			IndexMatching -> QualificationSamples,
			Category -> "Experimental Results"
		}
	}
}];
