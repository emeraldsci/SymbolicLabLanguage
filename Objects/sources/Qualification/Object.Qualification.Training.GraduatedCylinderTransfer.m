(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

With[
	{fields=graduatedCylinderTransferFields},

	DefineObjectType[Object[Qualification,Training,GraduatedCylinderTransfer], {
		Description->"A protocol that verifies an operator's ability to use a graduated cylinder.",
		CreatePrivileges->None,
		Cache->Session,
		Fields ->
			graduatedCylinderTransferFields
	}]
]