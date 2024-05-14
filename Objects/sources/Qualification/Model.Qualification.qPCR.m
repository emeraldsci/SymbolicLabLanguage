(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification, qPCR], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a thermocycler for qPCR.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	
		(* Method information *)
		TestSamples-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The sample model that will be used to test a qPCR thermocycler and associated preparation.",
			Category -> "General"
		},
		ForwardPrimers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Link..},
			Description -> "For each member of TestSamples, the forward primers that this experiment uses to amplify a target sequence from the sample.",
			Category -> "General",
			IndexMatching -> TestSamples
		},
		ReversePrimers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Link..},
			Description -> "For each member of TestSamples, the reverse primers that this experiment uses to amplify a target sequence from the sample.",
			Category -> "General",
			IndexMatching -> TestSamples
		},
		ReversePrimerVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "The reverse primer's volumes that this experiment uses to amplify a target sequence from the sample.",
			Category -> "General"
		},
		Standards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The reference sample model that will be used with TestSamples to calculate the ExpectedRatio.",
			Category -> "General"
		},
		StandardForwardPrimers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of Standards, the forward primer that this experiment uses to amplify the standard target sequence from the sample.",
			Category -> "Standard Curve",
			IndexMatching -> Standards
		},
		StandardReversePrimers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of Standards, the reverse primer that this experiment uses to amplify the standard target sequence from the sample.",
			Category -> "Standard Curve",
			IndexMatching -> Standards
		},
		SerialDilutionFactor -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[1],
			Description -> "For each Samples, the factor of concentration decrease for each consecutive preparation. The quantity of preparations is determined by the sister option NumberOfDilutions.",
			Category -> "General"
		},
		NumberOfDilutions -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The count of sample dilutions to make.",
			Category -> "General"
		},
		NumberOfStandardReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The count of repeated preparations and measurements of the Standards.",
			Category -> "General"
		},
		ReverseTranscription -> {
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates whether a one-step reverse transcription is performed in order to convert RNA input samples to cDNA.",
			Category -> "General"
		},
		Activation -> {
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates whether hot start activation of the reaction is performed in order to remove thermolabile inhibiting conjugates from the polymerases.",
			Category -> "General"
		},
		ActivationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature initial activation step used to denature the strands in the reaction and to activate the polymerase.",
			Category -> "General"
		},
		ActivationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time of the initial activation step used to denature the strands in the reaction and to activate the polymerase.",
			Category -> "General"
		},
		DenaturationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature used to denature all strands in the reaction in the first stage of the PCR cycle.",
			Category -> "General"
		},
		DenaturationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time used to denature all strands in the reaction in the first stage of the PCR cycle.",
			Category -> "General"
		},
		PrimerAnnealing -> {
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates whether primer annealing is performed as a separate step from strand extension.",
			Category -> "General"
		},
		ExtensionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the polymerase extends the newly amplified strand from the annealed primers in the third stage of the PCR cycle.",
			Category -> "General"
		},
		ExtensionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time for which the polymerase is allowed to extend the newly amplified strand from the annealed primers in the third stage of the PCR cycle.",
			Category -> "General"
		},
		MeltingCurve->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates whether a melting curved should be created at the end of the experiment by recording the fluorescene of each sample while slowly dissasociating the strands.",
			Category -> "General"
		},

		(*Test information*)
		ExpectedRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "The anticipated takeoff time for the TestSamples versus the Standards.",
			Category -> "General"
		},
		MaxRatioError -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "The allowable difference between the measured ratio and the ExpectedRatio in order to confirm qualification.",
			Category -> "General"
		}
	}
}];
