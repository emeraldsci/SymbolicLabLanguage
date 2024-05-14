(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container,Plate,Irregular,ArrayCard],{
	Description->"A quantitative polymerase chain reaction (qPCR) microfluidic array card that contains 8 sample loading reservoirs and up to 384 sets of pre-dried primers and probes.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		ForwardPrimers->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ForwardPrimers]],
			Pattern:>ObjectP[Model[Molecule]],
			Description->"The identity models of the forward primer molecules pre-dried on the array card.",
			Category->"Container Specifications",
			Abstract->True
		},
		ReversePrimers->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ReversePrimers]],
			Pattern:>ObjectP[Model[Molecule]],
			Description->"The identity models of the reverse primer molecules pre-dried on the array card.",
			Category->"Container Specifications",
			Abstract->True
		},
		Probes->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Probes]],
			Pattern:>ObjectP[Model[Molecule]],
			Description->"The identity models of the probe molecules pre-dried on the array card.",
			Category->"Container Specifications",
			Abstract->True
		}
	}
}];