(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Vessel, Filter], {
	Description->"A model for a vessel container used to filter particles above a certain size from a sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		FilterType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FilterFormatP,
			Description -> "The housing format of the given filter.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		PoreSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Micro,
			Description -> "The average size of the pores of this model of filter, which will filter out any particles above this size.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		MolecularWeightCutoff -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Dalton],
			Units -> Kilo Dalton,
			Description -> "The lowest molecular weight of particles which will filtered out by this filter model.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		PrefilterPoreSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Micrometer,
			Description -> "The average size of the pores of this model of filter's prefilter, which will remove any large particles prior to passing through the filter membrane.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		MembraneMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material of the filter membrane through which the sample travels to remove particles.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		PrefilterMembraneMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material of the prefilter through which the sample travels to remove any large particles prior to passing through the filter membrane.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		DestinationContainerIncluded->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this type of filter includes a receiving container as part of a unit.",
			Category -> "Organizational Information",
			Category -> "Container Specifications"
		},
		DestinationContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Vessel],
			Description -> "The model of container connected to this type of filter used to collect the liquid during filtration.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		KitProductsContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][KitComponents, ProductModel],
			Description -> "Products ordering information for this filter vessel container with its supplied storage buffer solution as part of one or more kits.",
			Category -> "Inventory"
		},
		RetentateCollectionContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Vessel],
			Description -> "The model of container in which this type of filter can be inverted and centrifuged in order to collect the sample retained on the filter.",
			Category -> "Container Specifications"
		},
		FunctionalGroup -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SolidPhaseExtractionFunctionalGroupP,
			Description -> "The functional group displayed on the cartridge's stationary phase for SPE.",
			Category -> "Physical Properties"
		},
		SeparationMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SeparationModeP,
			Description -> "The type of SPE for which this cartridge is suitable.",
			Category -> "Physical Properties",
			Abstract -> True
		}
	}
}];
