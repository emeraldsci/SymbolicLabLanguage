(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,MaterialLossAudit], {
	Description->"A protocol that evaluates material loss reporting at a given site.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Protocols->{
			Format->Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "The protocols associated with the unit operations evaluated for material loss.",
			Category -> "General",
			Abstract -> True
		},
		UnitOperations->{
			Format->Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation],
			Description -> "The individual unit operations evaluated for material loss.",
			Category -> "General",
			Abstract -> True
		},
		TransferOperators->{
			Format->Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User,Emerald],
			Description -> "The individuals responsible for performing the transfers evaluated for material loss.",
			Category -> "General",
			Abstract -> True
		},
		OperatorMaterialLossAssessment->{
			Format->Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Whether a loss of material was reported by the operator during protocol execution.",
			Category -> "General",
			Abstract -> True
		},
		MeasuredTransferWeightAppearances->{
			Format->Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data,Appearance],
			Description -> "The side-on image of the weighing surface of the balance and its contents, captured immediately following the weight measurement of MeasuredTransferWeightData by the integrated camera.",
			Category -> "General",
			Abstract -> True
		},
		MaterialLossWeightAppearances->{
			Format->Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data,Appearance],
			Description -> "The side-on image of the weighing surface of the balance, captured immediately following the weight measurement of MaterialLossWeightData by the integrated camera.",
			Category -> "General",
			Abstract -> True
		},
		UnreportedMaterialLossUnitOperations->{
			Format->Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation],
			Description -> "The unit operations identified as having material loss.",
			Category -> "General",
			Abstract -> True
		},
		UnreportedMaterialLossWeightAppearances->{
			Format->Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data,Appearance],
			Description -> "For any unit operations identified as having material loss, the side-on image of the weighing surface of the balance, captured immediately following the weight measurement of MaterialLossWeightData by the integrated camera.",
			Category -> "General",
			Abstract -> True
		},
		UnreportedMaterialLossRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0Percent],
			Units -> Percent,
			Description -> "The percent of unit operations that were identified as having an unreported material loss during this qualification.",
			Category -> "Acceptance Criteria"
		}
	}
}];
