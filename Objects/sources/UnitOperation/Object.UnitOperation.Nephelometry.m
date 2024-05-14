(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


With[{
	insertMe=Sequence@@$ObjectUnitOperationPlateReaderBaseFields,
	insertMe2=Sequence@@$ObjectUnitOperationNephelometryFields
},
	DefineObjectType[Object[UnitOperation,Nephelometry], {
		Description->"A detailed set of parameters that specifies a single alpha screen reading step in a larger protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			SamplingDimension -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterP[0,1],
				Description -> "Specifies the size of the grid used for Matrix sampling. For example SamplingDimension->3 scans a 3 x 3 grid.",
				Category -> "Optics"
			},

			insertMe,
			insertMe2
		}
	}]
];

