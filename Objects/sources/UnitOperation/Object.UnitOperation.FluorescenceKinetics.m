(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


With[{
	insertMe=Sequence@@$ObjectUnitOperationPlateReaderBaseFields,
	insertMe2=Sequence@@$ObjectUnitOperationFluorescenceBaseFields,
	insertMe4=Sequence@@$ObjectUnitOperationFluorescenceIntensityFields,
	insertMe5=Sequence@@$ObjectUnitOperationPlateReaderKineticInjectionFields,
	insertMe6=Sequence@@$ObjectUnitOperationFluorescenceMultipleBaseFields
},
	DefineObjectType[Object[UnitOperation,FluorescenceKinetics], {
		Description->"A detailed set of parameters that specifies a single fluorescence kinetics reading step in a larger protocol.",
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
			insertMe4,
			insertMe5,
			insertMe6
		}
	}]
];
