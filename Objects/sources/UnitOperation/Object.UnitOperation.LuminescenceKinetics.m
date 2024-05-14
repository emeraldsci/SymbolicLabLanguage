(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


With[{
	insertMe=Sequence@@$ObjectUnitOperationPlateReaderBaseFields,
	insertMe2=Sequence@@$ObjectUnitOperationLuminescenceIntensityFields,
	insertMe3=Sequence@@$ObjectUnitOperationPlateReaderKineticInjectionFields,
	insertMe4=Sequence@@$ObjectUnitOperationFluorescenceBaseFields
},
	DefineObjectType[Object[UnitOperation,LuminescenceKinetics], {
		Description->"A detailed set of parameters that specifies a single luminescence kinetics reading step in a larger protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			IntegrationTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Minute],
				Units -> Second,
				Description -> "The amount of time over which luminescence measurements should be integrated.",
				Category -> "Luminescence Measurement"
			},
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
				Description -> "The length of time for which fluorescence measurements are made.",
				Category -> "Fluorescence Measurement"
			},
			ReadOrder -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> ReadOrderP,
				Description -> "Indicates if all measurements and injections are done for one well before advancing to the next (serial) or in cycles in which each well is read once per cycle (parallel).",
				Category -> "Fluorescence Measurement"
			},

			insertMe,
			insertMe2,
			insertMe3,
			insertMe4
		}
	}]
];
