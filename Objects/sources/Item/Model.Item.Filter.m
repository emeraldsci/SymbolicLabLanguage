(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Filter], {
	Description->"Model information for a device or membrane used to remove particles above a certain size from a sample.",
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
			Units -> Micrometer,
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
			Description -> "The material of the filter through which the sample travels to remove particles.",
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
		Diameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The diameter of the filter membrane.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		InletConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectorP,
			Description -> "The type of fitting needed to plumb the flow system into the filter.",
			Category -> "Physical Properties"
		},
		OutletConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectorP,
			Description -> "The type of fitting needed to plumb the filter back into the flow system.",
			Category -> "Physical Properties"
		},
		MinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Liter],
			Units -> Liter Milli,
			Description -> "The minimum volume of liquid that can be filtered at once using this model of filter.",
			Category -> "Operating Limits"
		},
		MaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Liter],
			Units -> Liter Milli,
			Description -> "The maximum volume of liquid that can be filtered at once using this model of filter.",
			Category -> "Operating Limits"
		},
		MaxLifetime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The length of time that the filter is assured to operate for and meet the specs of the manufacturer.",
			Category -> "Operating Limits"
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure that can be applied to this filter before it is prone to burst during the experiment.",
			Category -> "Operating Limits"
		}
	}
}];
