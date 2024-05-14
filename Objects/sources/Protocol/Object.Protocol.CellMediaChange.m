

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, CellMediaChange], {
	Description->"A protocol for removing and replacing the growth media on adherent tissue culture cells.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Media -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The sample or model objects describing the media that are used during this cell media change.",
			Category -> "Reagents",
			Abstract -> True
		},
		TotalVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The total volume to remove from a well in order to entirely empty that well, and the volume of new media that will be used to refill that well.",
			Category -> "General"
		},
		CellMediaChangeProgram -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "The program object containing detailed instructions for a robotic liquid handler.",
			Category -> "General"
		}
	}
}];
