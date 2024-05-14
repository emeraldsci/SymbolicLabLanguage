

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part, InformationTechnology], {
	Description->"Any item related to the computer, network, tablet,phone infrastructure at Emerald that is tracked by the inventory system.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		IP -> {
			Format -> Single,
			Class -> String,
			Pattern :> IpP,
			Description -> "The numerical identifier of a device connected to the network.",
			Category -> "Part Specifications"
		},

		Hostname -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The unique label assigned to a device connected to the network.",
			Category -> "Part Specifications"
		},

		ComputerComponents -> {
			Format -> Multiple,
			Class -> {Expression, Link},
			Pattern :> {ComputerComponentP, _Link},
			Relation -> {Null, Object[Part, InformationTechnology][Computer]},
			Description -> "The list of parts used to build the computer.",
			Category -> "Part Specifications",
			Headers -> {"Computer Component","Object"}
		},

		Cost -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*USD],
			Units -> USD,
			Description -> "The cost of the part or the sum of all the components used to in the part.",
			Category -> "Part Specifications"
		},

		Computer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,InformationTechnology][ComputerComponents,2],
			Description -> "The computer in which this part is a component of.",
			Category -> "Part Specifications"
		},

		ComputerBackup -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,Computer][BackupHardDrive, 2],
			Description -> "The computer that this hard drive is backing up.",
			Category -> "Part Specifications"
		}

	}
}];
