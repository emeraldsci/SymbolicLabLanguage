(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance,Clean,pHDetector],{
	Description->"A protocol that cleans the pH electrode, pH flow cell, and Conductivity flow cell of an HPLC pH Detector to remove any deposit of eluent or sample compounds.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* ---solvents--- *)
		pHElectrodeWashSolvent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The wash solvent used to remove eluent or sample deposit on the pH electrode.",
			Category -> "General"
		},
		pHElectrodeRinseSolvent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The solvent used to rinse the pH electrode after cleaning with the wash solvent.",
			Category -> "General"
		},
		pHElectrodeFillSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The solution used to fill the pH electrode and its offline storage container.",
			Category -> "General"
		}
	}
}];