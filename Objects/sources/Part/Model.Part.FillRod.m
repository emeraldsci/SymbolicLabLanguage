(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part,FillRod],{
	Description->"Model of a part used to monitor the liquid nitrogen fill level in a CryoPod transporter.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		IndicatorColor->{
			Format->Single,
			Class->Expression,
			Pattern:>PartColorP,
			Description->"The color of the indicator bar on the rod, used for the purpose of identifying when the CryoPod is sufficiently full.",
			Category->"Physical Properties"
		}
	}
}];
