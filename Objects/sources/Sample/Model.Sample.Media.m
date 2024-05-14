(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab,Inc.*)

With[
	{insertMe=Sequence@@$ModelSampleStockSolutionSharedFields},
	DefineObjectType[Model[Sample,Media],{
		Description->"Model information for a mixed formulation designed to support the growth of microorganisms or cells.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			OrganismType->{
				Format->Single,
				Class->Expression,
				Pattern:>OrganismTypeP,
				Description->"The general category of organism which this medium is designed to support.",
				Category->"Organizational Information",
				Abstract->True
			},
			CellTypes->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Cell][PreferredLiquidMedia],
					Model[Cell][PreferredSolidMedia],
					Model[Cell][PreferredFreezingMedia]
				],
				Description->"The cell types for which this medium is their preferred medium for growth.",
				Category->"Organizational Information",
				Abstract->True
			},
			BaseMedia->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Sample,Media][SupplementedMedia],
					Model[Sample,Media][DropOutMedia]
				],
				Description->"The medium of which this formulation is a variant, either by addition or removal of components.",
				Category->"Reagents",
				Abstract->True
			},
			MediaPhase->{
				Format->Single,
				Class->Expression,
				Pattern:>MediaPhaseP,
				Description->"The physical state of the prepared media at ambient temperature and pressure.",
				Category->"General",
				Abstract->True
			},
			GellingAgents->{
				Format->Multiple,
				Class->{VariableUnit,Link},
				Pattern:>{GreaterP[0 Milliliter] | GreaterP[0 Gram] | GreaterP[0 Gram/Liter] | GreaterP[0],_Link},
				Relation->{Null, Alternatives[Model[Sample],Object[Sample],Model[Molecule]]},
				Description->"The final amounts of each substance added to solidify this media.",
				Headers->{"Amount","Gelling Agent"},
				Category->"Reagents",
				Abstract->True
			},
			SupplementedMedia->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Sample,Media][BaseMedia]
				],
				Description->"Media that are prepared by introduction of substances in addition to the formula for this media.",
				Category->"Reagents",
				Abstract->True
			},
			DropOutMedia->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Sample,Media][BaseMedia]
				],
				Description->"Media that are prepared by removal of substances from the formula for this media.",
				Category->"Reagents"
			},
			LiquidMedia->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Sample,Media][SolidMedia]
				],
				Description->"The corresponding liquid form of this media lacking the gelling agent.",
				Category->"General"
			},
			SolidMedia->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Sample,Media][LiquidMedia]
				],
				Description->"The corresponding solid form of this media containing gelling agents in addition to the formula.",
				Category->"General"
			},
			AlternativePreparations->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample, Media][AlternativePreparations],
				Description->"Stock solution models that have the same formula components and component ratios as this stock solution. These alternative stock solutions may have different preparatory methods.",
				Category->"Formula"
			},
			(*****)

			PlateMedia->{
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates that this model of media should be transferred to incubation plates once all components have been combined and sterilized.",
				Category->"Media Addition and Plating"
			},

			insertMe
		}
	}];
];
