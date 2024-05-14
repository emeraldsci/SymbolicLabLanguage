DefineObjectType[Object[Container, Plate, Filter], {
	Description->"A container used to filter particles above a certain size from samples in individual wells.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		PoreSize -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], PoreSize]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The average size of the pores of this filter, which will filter out any particles above this size.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		MolecularWeightCutoff -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MolecularWeightCutoff]],
			Pattern :> GreaterP[0*Dalton],
			Description -> "The lowest molecular weight of particles which will filtered out by this filter model.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		PrefilterPoreSize -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], PrefilterPoreSize]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The average size of the pores of this filter's prefilter, which will remove any large particles prior to passing through the filter membrane.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		MembraneMaterial -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MembraneMaterial]],
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material of the filter through which the sample travels to remove particles.",
			Category -> "Physical Properties"
		},
		PrefilterMembraneMaterial -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], PrefilterMembraneMaterial]],
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material of the prefilter through which the sample travels to remove any large particles prior to passing through the filter membrane.",
			Category -> "Physical Properties"
		},
		FunctionalGroup -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SolidPhaseExtractionFunctionalGroupP,
			Description -> "The functional group displayed on the cartridge's stationary phase.",
			Category -> "Physical Properties"
		}
	}
}];
