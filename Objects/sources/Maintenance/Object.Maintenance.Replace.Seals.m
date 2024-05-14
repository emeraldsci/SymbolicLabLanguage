(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Replace, Seals], {
	Description->"A protocol that replaces the pump seals on an LC instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CleaningSolvent -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			IndexMatching->ReplacementParts,
			Description -> "For each member of ReplacementParts, the liquid used to clean the pump heads and new seals.",
			Category -> "Cleaning"
		},
		CleaningSolutionManipulations->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,Incubate]|Object[Protocol,ManualSamplePreparation],
			IndexMatching->ReplacementParts,
			Description->"For each member of ReplacementParts, a sonication protocol to clean the parts.",
			Category->"Cleaning"
		},
		Buffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			IndexMatching->ReplacementParts,
			Description -> "For each member of ReplacementParts, the liquid used to break in the pump heads and new seals.",
			Category -> "General",
			Developer->True
		},
		SampleCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap], Model[Item,Cap]],
			Description -> "The cap used to aspirate the sample container if needed.",
			Category -> "General"
		},
		BufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample] | Model[Sample], Null},
			Description -> "A list of deck placements used for placing buffers needed to run the protocol onto the instrument buffer deck.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		BufferLineConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Item,Cap], Null},
			Description -> "The instructions attaching the inlet lines to the buffer caps.",
			Headers -> {"Instrument Buffer Inlet Line", "Inlet Line Connection", "Buffer Cap", "Buffer Cap Connector"},
			Category -> "General",
			Developer -> True
		},
		MethodName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The method name for the protocol.",
			Category -> "General",
			Developer -> True
		},
		ActivationTime -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?TimeQ,
			Description -> "The estimated completion time for the breaking in the seals.",
			Category -> "General",
			Developer -> True
		},
		PlumbingDisconnectionSlot -> {
			Format -> Single,
			Class -> {Link, String},
			Pattern :> {_Link, _String},
			Relation -> {Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "The destination information for the disconnected caps.",
			Headers -> {"Container", "Position"},
			Category -> "Column Installation",
			Developer -> True
		}
	}
}];
