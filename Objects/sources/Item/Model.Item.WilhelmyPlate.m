(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,WilhelmyPlate],{
	Description->"Model information for a Wilhelmy plate used to measure the surface tension of a liquid, the interfacial tension between two liquids, or the contact angle between a liquid and a solid on a force tensiometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		WilhelmyPlateHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"The height of the rectangular part of a Wilhelmy plate.",
			Category->"Part Specifications",
			Abstract->True
		},
		WilhelmyPlateWidth->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"The width of the rectangular part of a Wilhelmy plate.",
			Category->"Part Specifications",
			Abstract->True
		},
		WilhelmyPlateThickness->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"The thickness of the rectangular part of a Wilhelmy plate.",
			Category->"Part Specifications",
			Abstract->True
		},
		WettedLength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"The length of the three-phase boundary line for contact between a solid and a liquid in a bulk third phase. For rectangular plate, it equals to the sum of width and thickness times two.",
			Category->"Part Specifications",
			Abstract->True
		},
		SampleHolder->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the Wilhelmy plate requires a sample holder for measuring contact angle.",
			Category->"Part Specifications",
			Abstract->True
		}
	}
}];
