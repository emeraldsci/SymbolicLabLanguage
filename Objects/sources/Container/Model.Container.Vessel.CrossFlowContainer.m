(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, Vessel, CrossFlowContainer],{
	Description->"A model for a vessel container used to hold the sample in cross flow filtration experiments.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		CapConnectionTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>CrossFlowConnectorP,
			Description->"The types of the plumbing attachments available on the cap.",
			Category->"Physical Properties",
			Abstract->True
		},

		CapConnectionSizes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Inch],
			Units->Inch,
			Description->"The sizes of the plumbing attachments available on the cap.",
			Category->"Physical Properties",
			Abstract->True
		}
	}
}];
