(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

With[
	{fields=modelGraduatedCylinderTransferFields},

	DefineObjectType[
		Model[Qualification,Training,GraduatedCylinderTransfer],
		{
			Description->"Definition of a set of parameters for a qualification protocol that verifies an operator's ability to use a graduated cylinder.",
			CreatePrivileges->None,
			Cache->Session,
			Fields -> fields
		}
	]
]