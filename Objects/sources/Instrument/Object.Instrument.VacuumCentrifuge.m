

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, VacuumCentrifuge], {
	Description->"An instrument that removes solvent from samples at low pressure to prevent sample damage.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		VacuumPumpType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],VacuumPumpType]],
			Pattern :> VacuumPumpTypeP,
			Description -> "Type of vacuum pump used to create reduced pressure in the interior of instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "Minimum temperature at which the vacuum centrifuge can incubate samples.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "Maximum temperature at which the vacuum centrifuge can incubate samples.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		VacuumPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],VacuumPressure]],
			Pattern :> RangeP[0*PSI, 14.7*PSI],
			Description -> "The minimum absolute pressure that the vacuum centrifuge's vacuum pump is capable of achieving. Absolute pressure is zero-referenced against a perfect vacuum and is equal to gauge pressure plus atmospheric pressure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxSolventVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxSolventVolume]],
			Pattern :> GreaterEqualP[0*Liter],
			Description -> "Maximum volume of solvent that may be evaporated in one run in the vacuum centrifuge.",
			Category -> "Operating Limits"
		},
		TrapCapacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TrapCapacity]],
			Pattern :> GreaterEqualP[0*Liter*Milli],
			Description -> "Maximum volume of condensation the cold trap can hold.",
			Category -> "Operating Limits"
		},
		MaxSpinRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxSpinRate]],
			Pattern :> GreaterEqualP[(0*Revolution)/Minute],
			Description -> "Maximum rotational speed of the centrifuge.",
			Category -> "Operating Limits"
		},
		MaxSwingLoad -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxSwingLoad]],
			Pattern :> GreaterEqualP[0*Gram],
			Description -> "Maximum mass of payload in each swing of the instrument's centrifuge, including sample holder, liquid, and samples.  The 'swing' is the carrier which holds the vessels or plates that the samples are contained in.",
			Category -> "Operating Limits"
		}
	}
}];
