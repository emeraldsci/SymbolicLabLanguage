(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Barrel], {
	Description -> "Model information for a barrel in which liquid media is stored.",
	CreatePrivileges -> None,
	Cache -> Session
	(*	Fields -> {*)
	(*		*)(* Dimensions & Positions *)
	(*		MeshSize -> {*)
	(*			Format -> Single,*)
	(*			Class -> Real,*)
	(*			Pattern :> GreaterP[0*Meter],*)
	(*			Units -> Millimeter,*)
	(*			Description -> "The size of the openings in the walls of this model of bag.",*)
	(*			Category -> "Dimensions & Positions"*)
	(*		}*)
	(*	}*)
}];