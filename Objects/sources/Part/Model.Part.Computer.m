

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, Computer], {
	Description -> "Model information regarding the hardware and software details of instrument, workstation, and tablet computers.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		ComputerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ComputerTypeP,
			Description -> "Indicates if the computer model is driving an instrument, an office workstation, or an operator cart.",
			Category -> "Part Specifications"
		},

		OperatingSystem -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OperatingSystemP,
			Description -> "What operating system this computer model is running.",
			Category -> "Part Specifications"
		},

		PartsList -> {
			Format -> Multiple,
			Class -> {Expression, Link, Integer},
			Pattern :> {ComputerComponentP, _Link, _Integer},
			Relation -> {Null, Model[Part, InformationTechnology], Null},
			Description -> "The list of parts (by model) used to build this type of computer.",
			Category -> "Part Specifications",
			Headers -> {"Computer Component", "Model", "Quantity"}
		}
	}
}]