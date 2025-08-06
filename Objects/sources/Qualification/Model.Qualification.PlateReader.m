(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


With[
	{insertMe=Sequence@@$ModelQualificationPlateReaderSharedFields},
	DefineObjectType[Model[Qualification, PlateReader], {
		Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a plate reader.",
		CreatePrivileges->None,
		Cache->Session,
		Fields -> {
			(* Shared Sample Prep fields *)
			insertMe
		}
	}];
];
