(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: martin.lopez *)
(* :Date: 2022-10-10 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part, Respirator], {
	Description->"A device designed to protect the wearer from inhaling hazardous atmospheres.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Operator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User,Emerald,Operator][Respirator],
			Description -> "The operator to which this respirator belongs.",
			Category -> "General"
		}
	}
}];