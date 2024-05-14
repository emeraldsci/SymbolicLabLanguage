(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, SampleInspector], {
	Description->"A protocol that verifies the functionality of the sample inspector target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		VisualInspectionData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, VisualInspection],
			Description -> "For each member of QualificationSamples, the visual inspection information collected using the sample inspector.",
			IndexMatching -> QualificationSamples,
			Category -> "Experimental Results"
		}
	}
}];
