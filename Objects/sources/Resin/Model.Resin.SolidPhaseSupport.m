(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Resin,SolidPhaseSupport], {
	Description->"Model information for a solid phase synthesis resin that has an oligomer displayed on it, typically from synthesis.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Strand -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule,Oligomer],
			Description -> "The model of oligomer displayed on the resin.",
			Category -> "Model Information"
		},
		SourceResin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Resin],
			Description -> "The model of the resin prior to synthesis or downloading.",
			Category -> "Model Information"
		},
		PreDownloaded -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether the resin was purchased as a downloaded resin, as opposed to downloaded manually.",
			Category -> "Model Information"
		}
	}
}];
