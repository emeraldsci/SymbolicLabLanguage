

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Report, Certificate, InstrumentValidation],{
	(* This object holds fields for information uploaded from a third party certificate of validation or testing for an instrument to verify it is in working order.*)
	Description->"Information contained in a third-party generated instrument certification document verifying the instrument or instrument module is operating properly.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* Instrument Identification *)
		SerialNumber -> {
			Format -> Single,
			Class -> {String, String},
			Pattern :> {_String,_String},
			Description -> "Serial number of the certified instrument or instrument module.",
			Headers -> {"Component Name","Serial Number"},
			Category -> "Inventory"
		},
		ModelNumber ->{
			Format->Single,
			Class->{String,String},
			Pattern:>{_String,_String},
			Description->"Model number of the certified instrument or instrument module.",
			Headers->{"Component Name","Model Number"},
			Category->"Inventory"
		}

		(**Certified Data Fields**)
		(* BioSafety Cabinets and Fume Hoods*)
			(*TODO: Add fields relevant for fume hoods and BSC testing.*)
	}
}];