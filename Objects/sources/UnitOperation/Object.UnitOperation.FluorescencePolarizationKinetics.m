(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

With[{
	insertMe=Sequence@@$ObjectUnitOperationPlateReaderBaseFields,
	insertMe2=Sequence@@$ObjectUnitOperationFluorescenceBaseFields,
	insertMe3=Sequence@@$ObjectUnitOperationPlateReaderKineticInjectionFields,
	insertMe4=Sequence@@$ObjectUnitOperationFluorescenceMultipleBaseFields

},
	DefineObjectType[Object[UnitOperation,FluorescencePolarizationKinetics], {
		Description->"A detailed set of parameters that specifies a single fluorescence polarization kinetics reading step in a larger protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{

			ExcitationWavelength -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Nano*Meter],
				Units -> Meter Nano,
				Description -> "The wavelengths of light used to excite the samples.",
				Category -> "Fluorescence Measurement"
			},
			EmissionWavelength -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Nano*Meter],
				Units -> Meter Nano,
				Description -> "For each member of ExcitationWavelength, the wavelengths at which fluorescence emitted from the samples is measured.",
				IndexMatching -> ExcitationWavelength,
				Category -> "Fluorescence Measurement"
			},
			DualEmissionWavelength -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Nano*Meter],
				Units -> Meter Nano,
				Description->"For each member of ExcitationWavelength, the wavelength at which fluorescence emitted from the sample should be measured with the secondary detector (simultaneous to the measurement at the emission wavelength done by the primary detector).",
				IndexMatching -> ExcitationWavelength,
				Category -> "Fluorescence Measurement"
			},
			Gain -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0*Microvolt] | RangeP[0*Percent, 100*Percent],
				Description->"For each member of ExcitationWavelength, the gain which should be applied to the signal reaching the primary detector during the excitation scan. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample fluoresces at that percentage of the instrument's dynamic range).",
				IndexMatching -> ExcitationWavelength,
				Category -> "Optics"
			},
			DualEmissionGain -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0*Microvolt] | RangeP[0*Percent, 100*Percent],
				Description->"For each member of ExcitationWavelength, the gain which should be applied to the signal reaching the primary detector during the excitation scan. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample fluoresces at that percentage of the instrument's dynamic range).",
				IndexMatching -> ExcitationWavelength,
				Category -> "Optics"
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
			TargetPolarization -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*PolarizationUnit],
				Units -> PolarizationUnit Milli,
				Description->"The target polarization value which should be used to perform automatic adjustments of gain and/or focal height values at run time on the chosen adjustment sample.",
				Category -> "Fluorescence Measurement"
			},

			insertMe,
			insertMe2,
			insertMe3,
			insertMe4
		}
	}]
];
