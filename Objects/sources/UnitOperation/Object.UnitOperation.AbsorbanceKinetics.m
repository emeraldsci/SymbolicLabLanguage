(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

With[{
	insertMe=Sequence@@$ObjectUnitOperationAbsorbanceSpectroscopyFields,
	insertMe2=Sequence@@$ObjectUnitOperationPlateReaderBaseFields,
	insertMe3=Sequence@@$ObjectUnitOperationPlateReaderKineticInjectionFields
},
	DefineObjectType[Object[UnitOperation,AbsorbanceKinetics], {
		Description->"A detailed set of parameters that specifies a single absorbance kinetics reading step in a larger protocol.",
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
				Description -> "The length of time for which absorbance measurements are made.",
				Category -> "Absorbance Measurement"
			},
			ReadOrder -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> ReadOrderP,
				Description -> "Indicates if all measurements and injections are done for one well before advancing to the next (serial) or in cycles in which each well is read once per cycle (parallel).",
				Category -> "Absorbance Measurement"
			},
			WavelengthReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Nano*Meter],
				Units->Meter Nano,
				Description->"The wavelengths at which sample absorbance is measured.",
				Category->"Absorbance Measurement",
				Migration -> SplitField
			},
			WavelengthExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[All,_Span],
				Description->"The wavelengths at which sample absorbance is measured.",
				Category -> "Absorbance Measurement",
				Migration -> SplitField
			},
			WavelengthMultiple->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Nano*Meter],
				Units->Meter Nano,
				Description->"The wavelengths at which sample absorbance is measured.",
				Category->"Absorbance Measurement",
				Migration -> SplitField
			},

			insertMe,
			insertMe2,
			insertMe3
		}
	}]
];