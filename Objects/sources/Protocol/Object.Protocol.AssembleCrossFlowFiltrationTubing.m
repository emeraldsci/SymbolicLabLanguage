(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,AssembleCrossFlowFiltrationTubing],{
	Description->"A protocol object to assemble tubing for a cross flow filtration experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		PrecutTubingModels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Plumbing,PrecutTubing],
			Description->"The tubing models that are prepared.",
			Category -> "General",
			Abstract->True
		},

		Fittings->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Plumbing,Fitting],
				Object[Plumbing,Fitting]
			],
			Description->"The fittings attached to tubing to form the precut tubing.",
			Category->"General"
		},

		BatchLengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>_Integer,
			Description->"The number of fittings used for each precut tubing object.",
			Category->"General"
		},

		Tubings->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Plumbing,Tubing],
				Object[Plumbing,Tubing]
			],
			Description->"For each member of PrecutTubingModels, the uncut tubing used to prepare the precut tubing.",
			Category->"General",
			IndexMatching->PrecutTubingModels
		},

		TubingLengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>_Real,
			Units->Meter,
			Description->"For each member of PrecutTubingModels, the length of tubing used to prepare the precut tubing.",
			Category->"General",
			IndexMatching->PrecutTubingModels
		},

		StickerTag->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Item,Consumable],
				Object[Item,Consumable]
			],
			Description->"The tags used to sticker prepared tubing objects.",
			Category->"General"
		},

		CreatedPrecutTubings->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Plumbing,PrecutTubing],
			Description->"For each member of PrecutTubingModels, the precut tubing object that was built.",
			Category->"General",
			IndexMatching->PrecutTubingModels
		},

		CurrentPrecutTubing->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Plumbing,PrecutTubing],
			Description->"The current precut tubing object that is being built.",
			Category->"General"
		},

		(* --- Resources --- *)
		PreparedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource, Sample][Preparation],
			IndexMatching -> PrecutTubingModels,
			Description -> "For each member of PrecutTubingModels, the resource in the parent protocol that is fulfilled by preparing a reference electrode of the target reference electrode model.",
			Category -> "Resources",
			Developer -> True
		}
	}
}];