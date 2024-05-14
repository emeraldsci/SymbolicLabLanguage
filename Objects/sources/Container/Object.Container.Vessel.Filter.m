

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, Vessel, Filter], {
	Description->"A container used to filter particles above a certain size from a sample.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		FilterType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], FilterType]],
			Pattern :> FilterFormatP,
			Description -> "The housing format of the given filter.",
			Category -> "Physical Properties",
			Abstract -> True
		},
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
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MembraneMaterial]],
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material of the prefilter through which the sample travels to remove any large particles prior to passing through the filter membrane.",
			Category -> "Physical Properties"
		},

		DestinationContainerModel -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], DestinationContainerModel]],
			Pattern :> ObjectReferenceP[Model[Container, Vessel]],
			Description -> "The model of container connected to this filter used to collect the liquid during filtration.",
			Category -> "Physical Properties"
		}
	}
}];
