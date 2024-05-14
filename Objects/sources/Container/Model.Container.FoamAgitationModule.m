(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container,FoamAgitationModule],{
	Description->"Model information for a foam agitation module used to hold the foam column with the stir blade/sparge filter, for inserting into the dynamic foam analyzer instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		MinColumnDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Millimeter],
			Units->Millimeter,
			Description->"The minimum inner column diameter of the foam column that can be fitted on this foam agitation module.",
			Category->"Operating Limits"
		},
		MaxColumnDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Millimeter],
			Units->Millimeter,
			Description->"The maximum inner column diameter of the foam column that can be fitted on this foam agitation module.",
			Category->"Operating Limits"
		},
		MinFilterDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Millimeter],
			Units->Millimeter,
			Description->"The minimum diameter of the filter that can be fitted on this foam agitation module.",
			Category->"Operating Limits"
		},
		MaxFilterDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Millimeter],
			Units->Millimeter,
			Description->"The maximum diameter of the filter that can be fitted on this foam agitation module.",
			Category->"Operating Limits"
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
			Description->"The chemicals that are preferred for use in washing this foam agitation module.",
			Category->"Washing"
		},
		PreferredNumberOfWashes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Units->None,
			Description->"For each member of PreferredWashSolvent, he preferred number of times that the foam agitation module will be hand washed using the preferred wash solvent(s) after an experiment is run.",
			Category->"Washing",
			IndexMatching->PreferredWashSolvent
		},
		PreferredWipes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item,Consumable],
			Description->"The preferred cleaning wipes that will be used to dry the foam agitation module after the experiment is run.",
			Category->"Washing"
		}
	}
}];
