

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Analysis, Fractions], {
	Description->"Analysis allowing user selection of sample fractions collected from speration based techniques that will be carried onto further perperations or analysis.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		FractionatedSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The sample that was used to generate the data on which this analysis was performed.",
			Category -> "General"
		},
		FractionsCollected -> {
			Format -> Computable,
      (* This field is currently obsolete because FractionsCollected no longer exists in Object[Data, Chromatography] *)
      (* The field definition has been preserved since some plot function internals depend on its existence *)
			Expression :> SafeEvaluate[{Field[Reference]}, Computables`Private`fractionsCollected[Field[Reference]]],
			Pattern :> {{GreaterEqualP[0], GreaterP[0], None | FractionStorageP}..},
			Description -> "List of fractions collected by the chromatography instrument.",
			Category -> "General",
			Headers->{"Collection Start Time", "Collection End Time", "Fraction Plate/Well Index"},
      Developer -> True
		},
		TheoreticalFractionVolumes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[FractionsPicked], Field[Reference]}, Computables`Private`theoreticalFractionVolumes[Field[FractionsPicked], Field[Reference]]],
			Pattern :> GreaterP[0*Milli*Liter] | {GreaterP[0*Milli*Liter]..},
			Description -> "Theoretical volume of the fractions computed using chromatography flow rate and collection time.",
			Category -> "General",
      Developer -> True
		},
		FractionsPicked -> {
			Format -> Multiple,
			Class -> {Real, Real, String},
			Pattern :> {GreaterEqualP[-1000*Minute], GreaterP[0*Minute], FractionStorageP},
			Units -> {Minute, Minute, None},
			Description -> "List of fractions picked by this analysis.",
			Category -> "Analysis & Reports",
			Abstract -> True,
			Headers ->{"Collection Start Time", "Collection End Time", "Fraction Plate/Well Index"}
		},
		SamplesPicked -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "Samples corresponding to the fractions picked in this analysis.",
			Category -> "Analysis & Reports",
			Abstract -> True
		}
	}
}];
