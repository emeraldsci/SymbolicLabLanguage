(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance,Clean,PeptideSynthesizer], {
	Description->"A protocol that flushes and cleans the Peptide Synthesizer instrument to ensure there is no carry over of reagents between syntheses.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		PrimaryWashSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The wash solvent used to flush and clean all the liquid handling lines in the instrument.",
			Category -> "General"
		},
		SecondaryWashSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "A secondary follow up wash solvent used to flush all the liquid handling lines after the primary solvent has been flushed through.",
			Category -> "General"
		},
		CleavageLineSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The wash solvent used to flush the lines that are used during Cleavage.",
			Category -> "General"
		},
		SolventsFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The name of the file that contains information for all solvent samples used during the synthesis and their positions on the instrument deck.",
			Category -> "General",
			Developer -> True
		},
		Frits -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Consumable],
				Model[Item,Consumable]
			],
			Description -> "The frits that are used in the bottle filters of the peptide synthesizer instrument.",
			Category -> "General"
		},
		SolventBottlePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to place all of the wash solvents in the solvent cabinet.",
			Headers->{"Movement Container","Nested Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		PlaceholderSolventBottlePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to put back the placeholder solvent bottles in the solvent cabinet after the cleaning is done}.",
			Headers->{"Movement Container","Nested Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		MonomerBottlePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of deck placements used for placing of monomer vessel placeholders onto the synthesizer deck.",
			Headers->{"Movement Container","Nested Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		CollectionVesselPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of deck placements used for placing of collection vessel placeholders onto the synthesizer deck.",
			Headers->{"Movement Container","Nested Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		PlaceholderCollectionVesselPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container]|Model[Container], Null},
			Description -> "A list of deck placements used for placing of new collection vessel placeholders onto the synthesizer deck after cleaning.",
			Headers->{"Movement Container","Nested Destination Position"},
			Category -> "Placements",
			Developer -> True
		},

		ReagentContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Object[Container]
			],
			Description->"Containers that need to be uncapped and loaded on the instrument.",
			Category->"Instrument Setup",
			Developer->True
		},
		ReagentContainerCaps->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Item],
				Object[Item]
			],
			Description->"Caps on containers that need to be loaded on the instrument.",
			Category->"Instrument Setup",
			Developer->True
		},
		PlaceholderContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Object[Container]
			],
			Description->"Containers that need to be removed from the instrument and capped with the same caps in ReagentContainerCaps.",
			Category->"Instrument Setup",
			Developer->True
		}

	}
}];
