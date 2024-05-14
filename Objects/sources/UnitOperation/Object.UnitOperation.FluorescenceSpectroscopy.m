(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

With[{
	insertMe=Sequence@@$ObjectUnitOperationPlateReaderBaseFields,
	insertMe2=Sequence@@$ObjectUnitOperationFluorescenceBaseFields,
	insertMe3=Sequence@@$ObjectUnitOperationFluorescenceFields,
	insertMe4=Sequence@@$ObjectUnitOperationFluorescenceSingleBaseFields
},
	DefineObjectType[Object[UnitOperation,FluorescenceSpectroscopy], {
		Description->"A detailed set of parameters that specifies a single fluorescence reading step in a larger protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			insertMe,
			insertMe2,
			insertMe3,
			insertMe4
		}
	}]
];
