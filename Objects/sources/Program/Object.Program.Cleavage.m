

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program, Cleavage], {
	Description->"The program used to store a batches of strands to be cleaved together in a protocol[Cleavage].",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		CleavedStrands -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Lists of strands to be cleaved together by this program.",
			Category -> "General"
		},
		FilterPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Sample] | Model[Sample]| Object[Container] | Model[Container], Null},
			Description -> "A list of placements used to place the cleavage solution into a plate following cleavage.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Column","Placement"}
		},
		CleavagePlacements -> {
			Format -> Multiple,
			Class -> {Link,Link,Expression},
			Pattern :> {_Link,_Link,LocationPositionP},
			Relation -> {(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),Null},
			Description -> "A list of placements used to place the resins into containers during cleavage.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Resin","Destination Container","Destination Position"}
		},
		CleavageMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method, Cleavage],
			Description ->"The Cleavage Method containing information about CleavageSolution, CleavageSolutionVolume, CleavageTemperature, and CleavageTime used in this Cleavage Program.",
			Category -> "Cleavage"
		},
		CleavageSolutionPrimitives->{
			Format->Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "The set of instructions specifying the transfers of cleavage solution to the cleavage plate.",
			Category -> "Cleavage"
		},
		FilterTransferPrimitives->{
			Format->Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "The set of instructions specifying the transfers of cleaved oligomers from the resin to the filter plate.",
			Category -> "Cleavage"
		},
		ResinWashPrimitives->{
			Format->Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "The set of instructions specifying the transfers of cleavage wash solution to the resin.",
			Category -> "Cleavage"
		},
		FilterWashPrimitives->{
			Format->Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "The set of instructions specifying the transfers of cleavage wash solution from the resin to the filter plate.",
			Category -> "Cleavage"
		}
	}
}];
