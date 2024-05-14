(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: martin.lopez *)
(* :Date: 2022-10-10 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part,Respirator],{
	Description->"Model information for a device designed to protect the wearer from inhaling hazardous atmospheres.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		EyeProtection -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the respirator includes a shield for protecting eyes from any splashes.",
			Category -> "Part Specifications"
		},
		FacepieceMaterial -> {
			Format -> Single,
			Class -> String,
			Pattern :> FacepieceMaterialP,
			Description -> "The type of material used to construct the facepiece. The facepiece is the part covering the user's nose and mouth.",
			Category -> "Part Specifications"
		},
		RespiratorSize -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> RespiratorSizeP,
			Description -> "The size of the mask and the degree to which it covers your face.",
			Category -> "Part Specifications"
		},
		RespiratorFilter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,RespiratorFilter],
			Description -> "The type of filter cartridges that is used for operating this respirator.",
			Category -> "Part Specifications"
		}
	}
}];