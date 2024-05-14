(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, Vessel, CrossFlowWashContainer],{
	Description->"A vessel container used to hold the buffer for rinse, flush and prime steps in cross flow filtration experiments.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		CapConnectionTypes->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], CapConnectionTypes]],
			Pattern:>{ConnectorGenderP|None,CrossFlowConnectorP},
			Description->"The types of the plumbing attachments available on the cap.",
			Category->"Physical Properties",
			Abstract->True
		},

		CapConnectionSizes->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], CapConnectionSizes]],
			Pattern:>GreaterP[1 Inch],
			Description->"The sizes of the plumbing attachments available on the cap.",
			Category->"Physical Properties",
			Abstract->True
		}
	}
}];
