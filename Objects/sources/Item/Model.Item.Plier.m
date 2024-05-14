(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,Plier],{
	Description->"Model information for a scissor-shaped tool used to hold, bend, compress, and/or cut objects with a pair of first-class levers joint at a fulcrum. Shorter end on one side of the fulcrum is termed jaws, while the longer side is termed handles.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		PlierType->{
			Format->Single,
			Class->Expression,
			Pattern:>PlierTypeP,
			Description->"The shape of the jaws of the plier that dictates the primary usage of it to be holding or compressing/cutting objects.",
			Category->"Part Specifications",
			Abstract->True
		},
		JawLengths->{
			Format->Single,
			Class->{Real,Real},
			Pattern:>{GreaterP[0 Centimeter],GreaterP[0 Centimeter]},
			Units->{Centimeter,Centimeter},
			Description->"The lengths of the plier's short and long jaws. Jaw lengths can be equal for a symmetrical plier.",
			Category->"Part Specifications",
			Headers->{"Short jaw length","Long jaw length"}
		},
		HandleLengths->{
			Format->Single,
			Class->{Real,Real},
			Pattern:>{GreaterP[0 Centimeter],GreaterP[0 Centimeter]},
			Units->{Centimeter,Centimeter},
			Description->"The lengths of the plier's short and long grip handles. Handle lengths can be equal for a symmetrical plier.",
			Category->"Part Specifications",
			Headers->{"Short handle length","Long handle length"}
		},
		JawMaterial->{
			Format->Single,
			Class->Expression,
			Pattern:>MaterialP,
			Description->"The material that the jaws of the plier are made of.",
			Category->"Physical Properties",
			Abstract->True
		}
	}
}];
