(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


With[{
	insertMe=Sequence@@$ObjectUnitOperationPlateReaderBaseFields,
	insertMe2=Sequence@@$ObjectUnitOperationNephelometryFields,
	insertMe3=Sequence@@$ObjectUnitOperationPlateReaderKineticInjectionFields
},
	DefineObjectType[Object[UnitOperation,NephelometryKinetics], {
		Description->"A detailed set of parameters that specifies a single nephelometry kinetics reading step in a larger protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			PlateReaderMixSchedule -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> MixingScheduleP,
				Description -> "Indicates the points during the experiment at which the assay plate is mixed.",
				Category -> "Sample Preparation"
			},
			RunTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Second],
				Units -> Second,
				Description -> "The length of time for which nephelometry measurements are made.",
				Category -> "Measurement"
			},
			ReadOrder -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> ReadOrderP,
				Description -> "Indicates if all measurements and injections are done for one well before advancing to the next (serial) or in cycles in which each well is read once per cycle (parallel).",
				Category -> "Measurement"
			},
			KineticWindowDurationsExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[All],
				Description -> "The length of time to study different areas of the kinetic curve. Separate NumberOfCycles and CycleTime can be set for each window, in order to increase the density of measurements for areas of particular interest.",
				Migration -> SplitField,
				Category -> "Cycling"
			},
			KineticWindowDurationsReal -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Second],
				Units -> Second,
				Description -> "The length of time to study different areas of the kinetic curve. Separate NumberOfCycles and CycleTime can be set for each window, in order to increase the density of measurements for areas of particular interest.",
				Migration -> SplitField,
				Category -> "Cycling"
			},
			NumberOfCycles -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterEqualP[1,1],
				Description -> "For each member of KineticWindowDurationsReal, the number of times all selected wells in the plate are read.",
				IndexMatching -> KineticWindowDurationsReal,
				Category -> "Cycling"
			},
			CycleTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Second],
				Units -> Second,
				Description -> "For each member of KineticWindowDurationsReal, the duration of time between each measurement.",
				IndexMatching -> KineticWindowDurationsReal,
				Category -> "Cycling"
			},

			insertMe,
			insertMe2,
			insertMe3
		}
	}]
];
