(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: martin.lopez *)
(* :Date: 2022-10-10 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part,RespiratorFilter],{
	Description->"Model information for a filter cartridge used in a device designed to protect the wearer from inhaling hazardous atmospheres.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		NIOSHFilterRating -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> NIOSHFilterRatingP,
			Description -> "Indicates the National Institute for Occupational Safety and Health (NIOSH) rating level of protection for this filter.",
			Category -> "Part Specifications"
		},
		ParticulateProtection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ParticulateTypeP,
			Description -> "Indicates the particulate types which this filter protects user from.",
			Category -> "Part Specifications"
		},
		ExpirationTime -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0*Month],
			Units -> Month,
			Description -> "The amount of time that can pass before the filter needs to be replaced.",
			Category -> "Part Specifications"
		},
		FilterShelfLife -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0*Year],
			Units -> Year,
			Description -> "The amount of time that a filter can remain stored and unopened in the original packaging.",
			Category -> "Part Specifications"
		}
	}
}];