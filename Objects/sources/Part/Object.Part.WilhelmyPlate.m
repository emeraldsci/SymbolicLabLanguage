(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part,WilhelmyPlate],{
	Description->"A Wilhelmy plate used to measure the surface tension of a liquid, the interfacial tension between two liquids, or the contact angle between a liquid and a solid on a force tensiometer..",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		WilhelmyPlateHeight->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],WilhelmyPlateHeight]],
			Pattern:>GreaterEqualP[0*Millimeter],
			Description->"The height of the rectangular section of this Wilhelmy plate.",
			Category->"Part Specifications",
			Abstract->True
		},
		WettedLength->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],WettedLength]],
			Pattern:>GreaterEqualP[0*Millimeter],
			Description->"The length of the three-phase boundary line for contact between a solid and a liquid in a bulk third phase. For rectangular plate, it equals to the sum of width and thickness times two.",
			Category->"Part Specifications",
			Abstract->True
		},
		UsageLog->{
			Format->Multiple,
			Class->{Expression,Link,Link},
			Pattern:>{_?DateObjectQ,_Link,_Link},
			Relation->{Null,Object[Protocol]|Object[Qualification]|Object[Maintenance],Object[Sample]},
			Headers->{"Date","Use","Sample"},
			Description->"The dates the probe has previously been used to take measurements of samples.",
			Category->"General"
		}
	}
}];
