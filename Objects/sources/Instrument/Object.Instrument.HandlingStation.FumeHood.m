(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, HandlingStation, FumeHood], {
	Description->"A ventilation device for working with potentially harmful chemical fumes and vapors while recording useful metadata (e.g. videos and photographs) that contextualizes the events associated with transfers between samples.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Mode -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Mode]],
			Pattern :> FumeHoodTypeP,
			Description -> "Type of fume hood it is.  Options include Benchtop for a standard hood, WalkIn for a large walk-in style hood, or Recirculating for a small unvented hood.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		SchlenkLine -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, SchlenkLine],
			Description -> "The Schlenk line that is contained within this instrument for backfill and vacuum purposes.",
			Category -> "Instrument Specifications"
		}
	}
}];
