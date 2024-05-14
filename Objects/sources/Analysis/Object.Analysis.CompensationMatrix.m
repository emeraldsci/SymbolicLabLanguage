(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis,CompensationMatrix],{
	Description->"A numerical matrix used to correct for the spillover of fluorophore intensity between detectors in a flow cytometry experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Detectors->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FlowCytometryDetectorP,
			Description->"The detectors used to detect light scattered off of samples in the input protocol.",
			Category -> "General"
		},
		DetectionLabels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Molecule],
			Description->"For each member of Detectors, the tag, including fluorescent or non-fluorescent chemical compounds or proteins, attached to the sample that will be analyzed by the Detectors.",
			Category -> "General",
			IndexMatching->Detectors
		},
		DetectionThresholds->{
			Format->Multiple,
			Class->Real,
			Units->(ArbitraryUnit*Second),
			Pattern:>GreaterP[0.0 ArbitraryUnit*Second],
			Description->"For each member of Detectors, the threshold in that detection channel used to separate the positive control population from the negative control.",
			Category -> "General",
			IndexMatching->Detectors
		},
		AdjustmentSampleData->{
			Format->Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "For each member of Detectors, the adjustment sample data used to compute this compensation matrix.",
			Category ->"Analysis & Reports",
			IndexMatching->Detectors
		},
		UnstainedSampleData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data],
			Description -> "The flow cytometry data used as a universal negative for this compensation matrix analysis.",
			Category->"Analysis & Reports"
		},
		CompensationMatrix->{
			Format->Single,
			Class->Expression,
			Pattern:>SquareNumericMatrixP,
			Description->"The numerical matrix used to correct for the spillover of fluorophore intensity into other detectors.",
			Category->"Analysis & Reports"
		}
	}
}];
