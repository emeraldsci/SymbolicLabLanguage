(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, CryogenicFreezer], {
	Description->"The model for a cryogenic liquid nitrogen freezer for long term storage of frozen cell lines.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		StoragePhase -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> NitrogenStoragePhaseP,
			Description -> "Indicates whether samples are stored in direct contact (Liquid) or indirect contact (Gas) with liquid nitrogen.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LiquidNitrogenCapacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "The maximum volume of liquid nitrogen that the freezer can be filled with.",
			Category -> "Operating Limits"
		},
		StaticEvaporationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Day],
			Units -> Liter/Day,
			Description -> "The rate of liquid nitrogen evaporation from from the freezer when closed.",
			Category -> "Operating Limits"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the cryogenic freezer.",
			Headers -> {"Width","Depth","Height"},
			Category -> "Dimensions & Positions"
		}
	}
}];
