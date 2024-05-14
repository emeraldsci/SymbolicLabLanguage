(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, qPCR], {
	Description->"A protocol that verifies the functionality of the thermocycler target for qPCR.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(*QualificationSamples is a shared field*)

		(* --- SamplesIn-related fields --- *)
		(* This field is needed in order to pass primer input to the experiment function call with the required structure *)
		QualificationPrimerPairs-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{_Link,_Link}..},
			Description -> "For each member of QualificationSamples, the forward and reverse primers that this experiment uses to amplify the primary target from the sample.",
			Category -> "General",
			IndexMatching -> QualificationSamples
		},
		(* Index-matching, non-relation fields that carry grouping information to make it clear which forward primers go with which members of QuantificationSamples *)
		(* Although the first version of the (pre-)qual doesn't use multiple primer pairs per input, a future
			version that tests probe usage will certainly need to do so. Set up these fields to accommodate this
			future need so we don't have to reconfigure later. *)
		QualificationForwardPrimers-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Link..},
			Description -> "For each member of QualificationSamples, the forward primer(s) that this experiment uses to amplify a target sequence from the sample.",
			Category -> "General",
			IndexMatching -> QualificationSamples
		},
		QualificationReversePrimers-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Link..},
			Description -> "For each member of QualificationSamples, the reverse primer(s) that this experiment uses to amplify a target sequence from the sample.",
			Category -> "General",
			IndexMatching -> QualificationSamples
		},
		(* Flattened-out relation fields that hold the actual resources for the forward and reverse primers *)
		QualificationForwardPrimerResources-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "A flat list of the forward primers that this experiment uses to amplify target sequences from input samples.",
			Category -> "General"
		},
		QualificationReversePrimerResources-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "A flat list of the reverse primers that this experiment uses to amplify target sequences from input samples.",
			Category -> "General"
		},

		(* --- Standards-related fields --- *)
		QualificationStandards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Item],
				Object[Sample],
				Object[Item]
			],
			Description -> "The reference samples used to run QualificationSamples against.",
			Category -> "General"
		},
		QualificationStandardPrimerPairs-> {
			Format -> Multiple,
			Class -> {Link,Link},
			Pattern :> {_Link,_Link},
			Relation -> {Alternatives[Object[Sample],Model[Sample]],Alternatives[Object[Sample],Model[Sample]]},
			Description -> "For each member of QualificationStandards, the forward and reverse primers that this experiment uses to amplify the primary target from the standard sample.",
			Headers->{"Forward Primer", "Reverse Primer"},
			Category -> "General",
			IndexMatching -> QualificationStandards
		},
		(* Qual standard F/R primer fields can be flat lists because we only ever use one primer pair per standard curve *)
		(* These fields are kind of redundant, since QualificationStandardPrimerPairs can be populated with resource objects at experiment time
			and will resolve upon resource picking automatically (unlike QualificationPrimerPairs) *)
		QualificationStandardForwardPrimers-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of QualificationStandards, the forward primer that this experiment uses to amplify a target sequence from the sample.",
			Category -> "General",
			IndexMatching -> QualificationStandards
		},
		QualificationStandardReversePrimers-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of QualificationStandards, the reverse primer that this experiment uses to amplify a target sequence from the sample.",
			Category -> "General",
			IndexMatching -> QualificationStandards
		},

		(* --- Experimental Results --- *)
		AnalyteQuantificationCycleAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis]
			],
			Description -> "Analyses performed to fit the resulting QualificationStandards amplification curve.",
			Category -> "Experimental Results"
		},
		StandardQuantificationCycleAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis]
			],
			Description -> "Analyses performed to fit the resulting QualificationStandards amplification curve.",
			Category -> "Experimental Results"
		},
		StandardCurveQuantificationCycleFit -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis]
			],
			Description -> "Analysis performed to fit standard quantification cycle vs Log(dilution) in order to determine PCR efficiency.",
			Category -> "Experimental Results"
		}

	}
}];
