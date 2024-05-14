(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,Electrode,ReferenceElectrode], {
	Description->"Model information for an electrode used in cyclic voltammetry measurements and acts as a fixed potential reference.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* Reference Electrode Information *)
		ReferenceElectrodeType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReferenceElectrodeTypeP,
			Description -> "The class category of this reference electrode model, which is defined by the combination of the electrode's material and the reference solution filled in its glass tube.",
			Category -> "General",
			Abstract -> True
		},
		Blank -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Electrode, ReferenceElectrode],
			Description -> "If the current ReferenceElectrode is a prepared electrode (has a ReferenceSolution defined), indicates the unprepared reference electrode model from which this current ReferenceElectrode model is generated.",
			Category -> "Model Information"
		},
		RecommendedSolventType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Organic | Aqueous,
			Description -> "The type of solvent this reference electrode model is recommended to work in.",
			Category -> "Model Information"
		},
		ReferenceSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The recommended solution filled in the glass tube of this reference electrode model. The reference solution usually has a pairing ion species (ReferenceCouplingSample) to couple with the electrode metal material to form a defined redox couple.",
			Category -> "Model Information",
			Abstract -> True
		},
		ReferenceCouplingSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The chemical that forms a defined redox couple with the electrode's metal material. This redox couple indicates which ReferenceElectrodeType this reference electrode model belongs to.",
			Category -> "Model Information",
			Abstract -> True
		},
		SolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The required volume of reference solution filled in the glass tube of the reference electrode for the electrode to properly work.",
			Category -> "Model Information"
		},
		RecommendedRefreshPeriod -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Month],
			Units -> Month,
			Description -> "The recommended time duration to refresh the reference solution filled in the glass tube of the reference electrode model.",
			Category -> "Qualifications & Maintenance"
		},

		(* Pricing information *)
		Price -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 * USD],
			Description -> "The cost of an Object of this reference electrode model when ECL generates it and it is subsequently purchased.",
			Category -> "Pricing Information",
			Abstract -> True,
			Developer -> True
		}
	}
}];
