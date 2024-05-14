

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, VacuumCentrifuge], {
	Description->"The model for an instrument that removes solvent from samples at low pressure to prevent sample damage.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		VacuumPumpType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> VacuumPumpTypeP,
			Description -> "Type of vacuum pump used to create reduced pressure in the interior of instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature at which the vacuum centrifuge can incubate samples.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature at which the vacuum centrifuge can incubate samples.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		VacuumPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*PSI, 14.7*PSI],
			Units -> Torr,
			Description -> "The minimum absolute pressure that the vacuum centrifuge's vacuum pump is capable of achieving. Absolute pressure is zero-referenced against a perfect vacuum and is equal to gauge pressure plus atmospheric pressure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxSolventVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Liter],
			Units -> Liter Milli,
			Description -> "Maximum volume of solvent that may be evaporated in one run in the vacuum centrifuge.",
			Category -> "Operating Limits"
		},
		TrapCapacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter*Milli],
			Units -> Liter Milli,
			Description -> "Maximum volume of condensation the cold trap can hold.",
			Category -> "Operating Limits"
		},
		MaxSpinRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Revolution)/Minute],
			Units -> Revolution/Minute,
			Description -> "Maximum rotational speed of the centrifuge.",
			Category -> "Operating Limits"
		},
		MaxSwingLoad -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Gram],
			Units -> Gram,
			Description -> "Maximum mass of payload in each swing of the instrument's centrifuge, including sample holder, liquid, and samples.  The 'swing' is the carrier which holds the vessels or plates that the samples are contained in.",
			Category -> "Operating Limits"
		}
	}
}];
