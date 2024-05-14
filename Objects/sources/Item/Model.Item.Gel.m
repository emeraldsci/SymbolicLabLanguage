(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Gel], {
	Description->"A model of an electrophoresis gel cassette for separation of macromolecules based on size and charge.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		GelMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GelMaterialP,
			Description -> "The polymer material that the gel is composed of.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		GelPercentage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "The total polymer weight percentage of the gel.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		CrosslinkerRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The weight ratio of acrylamide monomer to bis-acrylamide crosslinker used to prepare the gel.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Denaturing -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the gel contains additives that disrupt the secondary structure of macromolecules.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		NumberOfLanes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of distinct samples that a single gel accommodates for separation.",
			Category -> "Physical Properties"
		},
		MaxWellVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The maximum volume of sample that can be loaded into each well of the gel.",
			Category -> "Physical Properties"
		},
		GelLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Centi*Meter],
			Units -> Centi Meter,
			Description -> "The physical distance on this gel available for samples to travel in the direction of electrophoresis.",
			Category -> "Physical Properties"
		},
		Rig -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ElectrophoresisRigP,
			Description -> "The compatibile gel electrophoresis rig used to run this gel type.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Denaturants -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[(0*(Milli*Gram))/(Milli*Liter)]},
			Relation -> {Alternatives[Model[Sample],Model[Molecule]], Null},
			Units -> {None, Gram/Liter},
			Description -> "The types and amounts of denaturants in the gel.",
			Category -> "Physical Properties",
			Headers->{"Model", "Mass Concentration"}
		},
		BufferComponents->{
			Format  ->Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Molecule]],
			Units -> None,
			Description -> "The types of molecules which make up the buffer that the gel is made from.",
			Category-> "Physical Properties"
		},
		PreloadedStains -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[(0*(Milli*Gram))/Liter]},
			Relation -> {Alternatives[Model[Sample],Model[Molecule]], Null},
			Units -> {None, Gram/Liter},
			Description -> "The types and amounts of stains incorporated within the gel.",
			Category -> "Physical Properties",
			Headers->{"Model", "Mass Concentration"}
		},
		PreferredBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample, StockSolution],
			Description -> "The recommended running buffer for electrophoresis using this gel.",
			Category -> "General"
		},
		StainingSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The amount of staining solution or rinse buffer that is needed to cover the gel during a PAGE protocol.",
			Category -> "Sample Preparation"
		},
		CartridgeName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of this gel model that is saved in the PAGE method files and used by the Ranger at run time.",
			Category -> "General",
			Developer -> True
		}
	}
}];
