(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification, CrossFlowFiltration], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a cross flow filtration instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		ConductivityAccuracySamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample]],
			Description->"The sample models used to assess conductivity accuracy of detector.",
			Category -> "General"
		},
		
		CalibrationWeights->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item,CalibrationWeight]],
			Description->"The calibration weights used to qualify the balance.",
			Category -> "General"
		}
	}
}];
