(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


With[{
	insertMe=Sequence@@$ObjectUnitOperationPlateReaderBaseFields,
	insertMe2=Sequence@@$ObjectUnitOperationFluorescenceBaseFields,
	insertMe3=Sequence@@$ObjectUnitOperationLuminescenceIntensityFields
},
	DefineObjectType[Object[UnitOperation,LuminescenceIntensity], {
		Description->"A detailed set of parameters that specifies a single luminescence intensity reading step in a larger protocol.",
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

			insertMe,
			insertMe2,
			insertMe3
		}
	}]
];
