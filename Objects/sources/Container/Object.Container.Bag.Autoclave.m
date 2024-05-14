(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container,Bag,Autoclave],{
	Description->"A sealable bag used to hold an item during and after sterilization in an autoclave.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		SterilizationMethod->{
			Format->Single,
			Class->Expression,
			Pattern:>SterilizationMethodP,(* Autoclave|EthyleneOxide|HydrogenPeroxide *)
			Description->"The physical or chemical method that was used to sterilize the contents of this bag.",
			Category->"Container Specifications"
		}
	}
}];
