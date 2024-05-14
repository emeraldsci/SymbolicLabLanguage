(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container,Bag,Autoclave],{
	Description->"Model information for a sealable bag that holds an item while it is being sterilized and protects the item's sterility afterwards.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		SterilizationMethods->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SterilizationMethodP,(* Autoclave|EthyleneOxide|HydrogenPeroxide *)
			Description->"The physical or chemical means of sterilization with which the materials of this bag are compatible.",
			Category->"Compatibility"
		}
	}
}];
