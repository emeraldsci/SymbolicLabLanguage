

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program, HPLC], {
	Description->"The program describing a single HPLC run.",
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
		AnalyteIdentifier -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The alias with which the analyte is identified in the HPLC software.",
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
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The object injected in this hplc run.",
			Category -> "General"
		},
		AnalyteContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The container model from which the analyte is injected.",
			Category -> "General",
			Developer -> True
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
		AnalytePlatePosition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _String,
			Description -> "The position of the analyte's container on the autosampler.",
			Category -> "General",
			Developer -> True
		},
		AnalyteWell -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WellP,
			Description -> "The well position of the analyte on the autosampler.",
			Category -> "General",
			Developer -> True
		},
		InjectionVolume -> {
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
			Description -> "The parameters used in fraction collection of the analyte's hplc run.",
			Category -> "General"
		},
		DetectionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength of light irradiated in the detector's flow cell.",
			Category -> "General"
		},
		MinDetectionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength of light detected by the PDA detector during the experiment.",
			Category -> "General"
		},
		MaxDetectionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The maximum wavelength of light detected by the PDA detector during the experiment.",
			Category -> "General"
		}
	}
}];
