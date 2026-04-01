(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, BarrelMediaDispenser], {
	Description -> "The model of an instrument that dispenses liquid media from barrels through a pumping mechanism.",
	CreatePrivileges -> None,
	Cache -> Session
	(* missing comma above if fields need to be added back *)
	(*	Fields -> {*)
	(*		NumberOfCapillaries -> {*)
	(*			Format -> Single,*)
	(*			Class -> Integer,*)
	(*			Pattern :> GreaterEqualP[0,1],*)
	(*			Description -> "Number of capillary slots that the device has for simultaneous packing of melting point capillaries.",*)
	(*			Category -> "Instrument Specifications"*)
	(*		}*)
	(*	}*)
}];