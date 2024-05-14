(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container,ProteinCapillaryElectrophoresisCartridgeInsert],{
	Description->"A cartridge insert used to house cartridge running buffer.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		SoakSensorRed->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if an operator flagged that the insert needs to be replaced.",
			Category->"General"
		}
	}
}];
