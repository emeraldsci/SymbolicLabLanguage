(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

With[{
	insertMe=Sequence@@$ObjectUnitOperationPlateReaderBaseFields,
	insertMe2=Sequence@@$ObjectUnitOperationFluorescenceBaseFields,
	insertMe3=Sequence@@$ObjectUnitOperationFluorescenceSingleBaseFields
},
	DefineObjectType[Object[UnitOperation,LuminescenceSpectroscopy], {
		Description->"A detailed set of parameters that specifies a single luminescence reading step in a larger protocol.",
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
			EmissionWavelengthRange -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> _Span,
				Description->"Defines the wavelengths at which luminescence emitted from the sample should be measured.",
				Category -> "Optics"
			},
			AdjustmentEmissionWavelength -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Nano*Meter],
				Units -> Meter Nano,
				Description->"The wavelength at which luminescence should be read in order to perform automatic adjustments of gain and focal height values.",
				Category -> "Optics"
			},
			Gain -> {
				Format -> Single,
				Class -> VariableUnit,
				Pattern :> GreaterP[0*Microvolt] | RangeP[0*Percent, 100*Percent],
				Description->"The gain which should be applied to the signal reaching the primary detector.",
				Category -> "Optics"
			},

			insertMe,
			insertMe2,
			insertMe3
		}
	}]
];
