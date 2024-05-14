(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container,FoamColumn],{
	Description->"Model information for a column used for dynamic foam analysis.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		Detection->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FoamDetectionMethodP,
			Description->"The type of foam detection methods for which this column is suitable to be used with.",
			Category->"Item Specifications",
			Abstract->True
		},
		Jacketed->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates whether this column has a double-walled glass column suitable for use in controlling the temperature of the sample.",
			Category->"Item Specifications",
			Abstract->True
		},
		Prism->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates whether this column has an attached prism, required for use with the Foam Imaging Module.",
			Category->"Item Specifications",
			Abstract->True
		},
		MinSampleVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milliliter],
			Units->Milliliter,
			Description->"The minimum sample volume that is required in order to run a dynamic foam analysis experiment using this column.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxSampleVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milliliter],
			Units->Milliliter,
			Description->"The maximum sample volume that can be run on a dynamic foam analysis experiment using this column.",
			Category->"Operating Limits",
			Abstract->True
		},

		(* --- Dimensions & Positions --- *)
		Diameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Millimeter],
			Units->Millimeter,
			Description->"The outside diameter of the column.",
			Category->"Dimensions & Positions"
		},
		InternalDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Millimeter],
			Units->Millimeter,
			Description->"The internal diameter of the column.",
			Category->"Dimensions & Positions"
		},
		ColumnHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Millimeter],
			Units->Millimeter,
			Description->"The height of the column.",
			Category->"Dimensions & Positions"
		},

		(* --- Washing ---*)
		PreferredWashSolvent->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample,StockSolution],
				Model[Sample]
			],
			Description->"The chemicals that are preferred for use in washing this column.",
			Category->"Washing"
		},
		PreferredNumberOfWashes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Units->None,
			Description->"For each member of PreferredWashSolvent, the preferred number of times that the column will be hand washed using the preferred wash solvent(s) after an experiment is run.",
			Category->"Washing",
			IndexMatching->PreferredWashSolvent
		},
		PreferredWipes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item,Consumable],
			Description->"The preferred cleaning wipes that will be used to dry the column after the experiment is run.",
			Category->"Washing"
		}
	}
}];
