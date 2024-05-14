

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Method, VacuumEvaporation], {
	Description->"A method containing parameters specifying conditions under which a sample is evacuated.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		CentrifugalForce -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*GravitationalAcceleration],
			Units -> GravitationalAcceleration,
			Description -> "The relative centrifugal force applied to the sample.",
			Category -> "General",
			Abstract -> True
		},
		PressureRampTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The period of time over which the pressure drops from atmospheric pressure to EquilibrationPressure.",
			Category -> "General"
		},
		(* This field is no longer used by ExperimentEvaporate. The times that were in this field have been added to the values of PressureRampTime *)
		(*EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The period of time that the sample is at EquilibrationPressure before reaching EvaporationPressure.",
			Category -> "General"
		},*)
		EvaporationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The period of time that the sample is at EvaporationPressure.",
			Category -> "General"
		},
		EquilibrationPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Bar],
			Units -> Milli*Bar,
			Description -> "The final pressure achieved at the end of PressureRampTime.",
			Category -> "General"
		},
		EvaporationPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Bar],
			Units -> Milli*Bar,
			Description -> "The pressure at which the system is held for EvaporationTime.",
			Category -> "General"
		},
		ControlledChamberEvacuation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the vacuum ramping is controlled during initial evacuation of the chamber to prevent bumping of the solvent.",
			Category -> "General"
		}
	}
}];
