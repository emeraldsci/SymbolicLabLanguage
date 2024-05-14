(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Filter], {
	Description->"Model information for a porous material intalled on instruments to remove impurities or solid particles.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		FilterType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FilterFormatP|Cartridge|Pad,
			Description -> "The housing format of the given filter.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		SampleType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FluidCategoryP,
			Description -> "The type of samples that travels through this model of filter.",
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
		MembraneMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material of the filter through which the sample travels to remove particles.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		CrossSectionalShape -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CrossSectionalShapeP,
			Description -> "The shape of this filter model in the X-Y plane.",
			Category -> "Physical Properties"
		},
		Dimensions -> {
			Format -> Single,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
			Units ->{Meter,Meter,Meter},
			Description -> "The external dimensions of this model of filter.",
			Category -> "Physical Properties",
			Headers -> {"X Dimension (Width)","Y Dimension (Length)","Z Dimension (Height)"}
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
		MaxLifetime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The length of time that the filter is assured to operate for and meet the specs of the manufacturer.",
			Category -> "Operating Limits"
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The maximum flow rate at which the filter can function properly.",
			Category -> "Operating Limits"
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure at which the filter can function properly.",
			Category -> "Operating Limits"
		}
	}
}];
