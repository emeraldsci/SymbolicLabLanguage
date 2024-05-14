

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program, FPLC], {
	Description->"The program describing a single FPLC run.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		AnalyteIndex -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Units -> None,
			Description -> "The chronological position of the analyte in the protocol's injection queue.",
			Category -> "General"
		},
		AnalyteType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ChromatographySampleTypeP,
			Description -> "A type describing the purpose of the injected analyte (sample, control, blank or ladder).",
			Category -> "General"
		},
		AnalyteSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The object injected in this FPLC run.",
			Category -> "General"
		},
		SampleIn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The original sample from which AnalyteSample may have been aliquotted. SampleIn is the same as AnalyteSample when no aliquotting occurs.",
			Category -> "General",
			Abstract -> True
		},
		AnalyteWell -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WellP,
			Description -> "The well position of the analyte in its container.",
			Category -> "General"
		},
		SampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of analyte injected.",
			Category -> "General"
		},
		GradientMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method, Gradient],
			Description -> "The gradient used to purify the analyte.",
			Category -> "General"
		},
		FractionCollectionMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method, FractionCollection],
			Description -> "The parameters used in fraction collection of the analyte's FPLC run.",
			Category -> "General"
		},
		DetectionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength of light irradiated in the detector's flow cell.",
			Category -> "General"
		}
	}
}];
