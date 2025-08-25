(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Plate, Filter], {
	Description->"A model for a plate container used to filter particles above a certain size from samples in individual wells.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

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
		NozzleHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The distance from the top of the filter plate to the bottom of the filter nozzles.",
			Category -> "Physical Properties",
			Developer -> True
		},
		NozzleOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Millimeter],
			Units -> Millimeter,
			Description -> "The distance the nozzles of this filter plate protrude into the wells of the collection plate when seated on top, as measure from the bottom of the nozzle to the top of the collection plate. Negative values indicate the nozzles extend into the collection plate, while positive values indicate the nozzles are above the plate.",
			Category -> "Physical Properties",
			Developer -> True
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure that can be applied to this filter plate before it is prone to burst during the experiment.",
			Category -> "Operating Limits"
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
		},
		BedWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The weight of the packing material in each well of the cartridge.",
			Category -> "Physical Properties"
		}
	}
}];
