(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

With[
	{insertMe=Sequence@@$ModelSampleStockSolutionSharedFields},
	DefineObjectType[Model[Sample, StockSolution], {
		Description->"Model information of a stock solution of chemicals prepared for general use in experiments.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			PrepareInResuspensionContainer->{
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if the stock solution is prepared in the original container of a fixed amounts component in the formula.",
				Category->"Sample Preparation"
			},
			IncompatibleColumns->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Item, Column],
				Description->"Chromatography column models with which this stock solution is incompatible as a solvent.",
				Category->"Compatibility"
			},
			IncompatibleCartridges->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Item, Cartridge, Column][IncompatibleSolvents],
					Model[Container, ExtractionCartridge][IncompatibleSolvents],
					Model[Item, ExtractionCartridge][IncompatibleSolvents]
				],
				Description->"List of SPE cartridge models with which this chemical is incompatible as a solvent.",
				Category->"Compatibility",
				Abstract->False
			},
			AlternativePreparations->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample, StockSolution][AlternativePreparations],
				Description->"Stock solution models that have the same formula components and component ratios as this stock solution. These alternative stock solutions may have different preparatory methods.",
				Category->"Formula"
			},

			insertMe
		}
	}];
];