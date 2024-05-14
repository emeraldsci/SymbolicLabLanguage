(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, Rack], {
	Description->"A container with regular dimensions and positions for storing other containers (plates, tubes, other racks, etc).",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		NumberOfPositions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], NumberOfPositions]],
			Pattern :> GreaterP[0, 1],
			Description -> "Number of positions in the rack that are capable of holding containers or samples.",
			Category -> "Dimensions & Positions"
		},
		AspectRatio -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], AspectRatio]],
			Pattern :> GreaterP[0],
			Description -> "Ratio of the number of columns of positions vs the number of rows of positions in the rack.",
			Category -> "Dimensions & Positions"
		},
		Rows -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Rows]],
			Pattern :> GreaterP[0, 1],
			Description -> "The number of rows of positions in the rack.",
			Category -> "Dimensions & Positions"
		},
		Columns -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Columns]],
			Pattern :> GreaterP[0, 1],
			Description -> "The number of columns of positions in the rack.",
			Category -> "Dimensions & Positions"
		},
		InstrumentsSupplied -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument][SparePartsStorage],
			Description -> "The instrument model whose parts are stored in this container.",
			Category -> "Storage Information"
		}
	}
}];
