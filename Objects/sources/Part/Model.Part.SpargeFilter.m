(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part,SpargeFilter],{
	Description->"Model information for a filter used to sparge samples during a dynamic foam analysis experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		MinPoreSize->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Meter],
			Units->Micrometer,
			Description->"The minimum pore size of this model of filter, through which gas will be bubbled.",
			Category->"Physical Properties"
		},
		MaxPoreSize->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Meter],
			Units->Micrometer,
			Description->"The minimum pore size of this model of filter, through which gas will be bubbled.",
			Category->"Physical Properties"
		},
		CrossSectionalShape->{
			Format->Single,
			Class->Expression,
			Pattern:>CrossSectionalShapeP,
			Description->"The shape of this filter model in the X-Y plane.",
			Category->"Dimensions & Positions"
		},
		Diameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Millimeter],
			Units->Millimeter,
			Description->"The diameter of the sparge filter.",
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
			Description->"The chemicals that are preferred for use in washing this sparge filter.",
			Category->"Washing"
		},
		PreferredWipes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item,Consumable],
			Description->"The preferred cleaning wipes that will be used to dry the sparge filter after the experiment is run.",
			Category->"Washing"
		}
	}
}];
