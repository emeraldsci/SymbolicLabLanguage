(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part,ReferenceElectrode], {
	Description->"Model information for an electrode installed on the electrochemical detector and acts as a fixed potential reference or a pH monitor.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* Reference Electrode Information *)
		ReferenceElectrodeType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ReferenceElectrodeTypeP|pH,
			Description -> "The class information of this reference electrode model, which is usually defined by the reference solution stored in the glass tube of this reference electrode model.",
			Category -> "General",
			Abstract -> True
		},
		DefaultStorageSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The recommended solution filled in the glass tube of the reference electrode when the reference electrode is stored in. For Ag/AgCl, this is 3M KCl. For Ag/Ag+, this is 0.1 M AgNO3 0.1 M NBu4PF6 in acetonitrile. For Pseudo-Ag (no redox couple pairing ion), this is default to 0.1 M NBu4PF6 in acetonitrile.",
			Category -> "General"
		},
		IonChromatographySystem -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,IonChromatography],
			Description -> "The Ion Chromatography instrument this reference eletrode is installed on.",
			Category -> "General"
		}

	}
}];
