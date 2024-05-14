(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance,Clean,pHDetector],{
	Description->"Definition of a set of parameters for a maintenance protocol that cleans the pH electrode, pH flow cell, and Conductivity flow cell of an HPLC pH Detector to remove any deposit of eluent or sample compounds.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* ---solvents--- *)
		pHElectrodeWashSolvent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The wash solvent used to remove eluent or sample deposit on the pH electrode.",
			Category -> "General"
		},
		pHElectrodeRinseSolvent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The solvent used to rinse the pH electrode after cleaning with the wash solvent.",
			Category -> "General"
		},
		pHElectrodeFillSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The solution used to fill the pH electrode and its offline storage container.",
			Category -> "General"
		},

		(* ---containers--- *)
		ElectrodeWashSolventContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container],
			Description->"The type of container that is used for the pH electrode wash solvent.",
			Category -> "General"
		},
		ElectrodeRinseSolventContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container],
			Description->"The type of container that is used for the pH electrode rinse solvent.",
			Category -> "General"
		},
		FillSolutionContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container],
			Description->"The type of container that is used for the fill solution.",
			Category -> "General"
		},

		(* ---volumes--- *)
		pHElectrodeWashSolventVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Liter],
			Units->Milliliter,
			Description->"The required volume of the wash solvent used to clean the pH electrode.",
			Category -> "General"
		},
		pHElectrodeRinseSolventVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Liter],
			Units->Milliliter,
			Description->"The required volume of the solvent used to rinse the pH electrode after cleaning.",
			Category -> "General"
		},
		FillSolutionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Liter],
			Units->Milliliter,
			Description->"The required volume of the solution used to fill the pH electrode and its offline storage container.",
			Category -> "General"
		}
	}
}];