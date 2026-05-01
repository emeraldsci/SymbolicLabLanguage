(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, PrepareLiner], {
	Description -> "A maintenance procedure that prepares protective inserts by cutting them from larger source materials to specified dimensions.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* LinerModels are the input to this function *)
		LinerModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Liner],
			Description -> "The models of protective insert that are prepared by this maintenance.",
			Category -> "General"
		},
		Liners -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Liner],
			Description -> "For each member of LinerModels, the liner objects created by this maintenance.",
			Category -> "General",
			Abstract -> True
		},

		(* Liners for picking *)
		PickedLiners -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Liner],
				Object[Item, Liner]
			],
			Description -> "The protective inserts that are picked directly from storage during this maintenance.",
			Category -> "Resources"
		},
		PickedLinerIndexes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The index in LinerModels of each liner in PickedLiners.",
			Category -> "Resources",
			Developer -> True
		},

		(* Batch the inputs by cutter and source liner *)
		(* Cutter may be a large fixed guillotine and liner may be large heavy roll, so minimize movements *)
		BatchedSourceLiners -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Liner],
				Object[Item, Liner]
			],
			Description -> "For each member of BatchLengths, the larger liner from which the prepared liner is cut.",
			Category -> "Batching",
			IndexMatching -> BatchLengths
		},
		BatchedCuttingEnvironments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, CuttingStation],
				Object[Instrument, CuttingStation]
			],
			Description -> "For each member of BatchLengths, the work surface on which the liners are prepared.",
			Category -> "Batching",
			IndexMatching -> BatchLengths
		},
		BatchedCuttingParameters -> {
			Format -> Multiple,
			Class -> {
				Liner -> Link,
				SourceLiner -> Link,
				Cutter -> Link,
				CuttingEnvironment -> Link,
				(* Cut lengths correspond to the dimensions of the prepared liner, however a length will be Null if no cut is required *)
				CutLength1 -> Real,
				CutLength2 -> Real,
				(* The SourceLinerDimensionX fields exist to specify the dimensions *and orientation* of the source liner *)
				(* They are named 1 and 2 because they may not correspond with x and y in the Model[Item, Liner], depending on orientation *)
				SourceLinerDimension1 -> Real,
				SourceLinerDimension2 -> Real,
				BatchNumber -> Integer,
				SecondaryLiner -> Link
			},
			Pattern :> {
				Liner -> _Link,
				SourceLiner -> _Link,
				Cutter -> _Link,
				CuttingEnvironment -> _Link,
				CutLength1 -> GreaterP[0 Centimeter],
				CutLength2 -> GreaterP[0 Centimeter],
				SourceLinerDimension1 -> GreaterP[0 Centimeter],
				SourceLinerDimension2 -> GreaterP[0 Centimeter],
				BatchNumber -> GreaterP[0, 1],
				SecondaryLiner -> _Link
			},
			Relation -> {
				Liner -> Alternatives[
					Model[Item, Liner],
					Object[Item, Liner]
				],
				SourceLiner -> Alternatives[
					Model[Item, Liner],
					Object[Item, Liner]
				],
				Cutter -> Alternatives[
					Model[Item, Scissors],
					Object[Item, Scissors],
					Model[Part,Blade],
					Object[Part,Blade]
				],
				CuttingEnvironment -> Alternatives[
					Model[Instrument, CuttingStation],
					Object[Instrument, CuttingStation]
				],
				CutLength1 -> Null,
				CutLength2 -> Null,
				SourceLinerDimension1 -> Null,
				SourceLinerDimension2 -> Null,
				BatchNumber -> Null,
				SecondaryLiner -> Alternatives[
					Model[Item, Liner],
					Object[Item, Liner]
				]
			},
			Units -> {
				Liner -> None,
				SourceLiner -> None,
				Cutter -> None,
				CuttingEnvironment -> None,
				CutLength1 -> Centimeter,
				CutLength2 -> Centimeter,
				SourceLinerDimension1 -> Centimeter,
				SourceLinerDimension2 -> Centimeter,
				BatchNumber -> None,
				SecondaryLiner -> None
			},
			Headers -> {
				Liner -> "Liner",
				SourceLiner -> "Source Liner",
				Cutter -> "Cutter",
				CuttingEnvironment -> "Cutting Environment",
				CutLength1 -> "Cut Length 1",
				CutLength2 -> "Cut Length 2",
				SourceLinerDimension1 -> "Source Liner Dimension 1",
				SourceLinerDimension2 -> "Source Liner Dimension 2",
				BatchNumber -> "Batch Number",
				SecondaryLiner -> "Secondary Liner"
			},
			IndexMatching -> BatchedLinerIndexes,
			Description -> "For each member of BatchedLinerIndexes, the information required to prepare liners in that batch for use.",
			Category -> "Batching",
			Developer -> True
		},
		BatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The list of batch sizes corresponding to number of liners per batch.",
			Category -> "Batching",
			Developer -> True
		},
		BatchedLinerIndexes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The index in LinerModels of each liner in BatchedLinerModels.",
			Category -> "Batching",
			Developer -> True
		},

		InSitu -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the prepared liners remain at the operator location or are stored at the conclusion of this maintenance.",
			Category -> "General"
		}
	}
}];