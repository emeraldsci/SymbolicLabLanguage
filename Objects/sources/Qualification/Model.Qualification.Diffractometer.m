(* ::Package:: *)

DefineObjectType[Model[Qualification, Diffractometer], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a diffractometer.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {

		(* Analytes *)
		TestSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Input samples for this qualification.",
			Category -> "Analytes"
		},
		LinePositionTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Input sample for this qualification's Line Position Test.",
			Category -> "Analytes"
		},
		BlankSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Input samples for control wells in this qualification.",
			Category -> "Analytes"
		},

		(*Sample Preparation*)
		TransferType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[MassTransfer, SlurryTransfer],
			Description -> "The transfer type required for preparing the samples in the crystallization plate.",
			Category -> "Sample Preparation"
		},
		
		(* Method Information *)
		LinePositionTestAngles -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*AngularDegree],
			Units -> AngularDegree,
			Description -> "The positions at which peaks are expected for this test.",
			Category -> "General"
		},
		Replicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of times each test sample will be read to determine measurement precision.",
			Category -> "General"
		},
		ImageSample -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description ->"Option to take images of the samples after the diffractometry experiment.",
			Category -> "General"
		},
		DetectorRotations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Fixed, Sweeping],
			Description -> "For each member of TestSamples, whether the diffractometer data is to be acquired with a fixed or sweeping detector.",
			IndexMatching -> TestSamples,
			Category -> "General"
		},
		DetectorDistances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[58 Millimeter, 209 Millimeter],
			Units -> Millimeter,
			Description -> "For each member of TestSamples, the distances between the sample and the detector.",
			IndexMatching -> TestSamples,
			Category -> "General"
		},
		ExposureTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0.025 Second, 1 Hour],
			Units -> Second,
			Description -> "For each member of TestSamples, thelength of time the sample is exposed to X-rays for each scan.",
			IndexMatching -> TestSamples,
			Category -> "General"
		},

		(* Test Criteria *)
		LinePositionAccuracyTestCriterion -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Percent],
			Units -> Percent,
			Description -> "The maximum acceptable percent deviation from the expected peak position.",
			Category -> "Analysis & Reports"
		},
		LinePositionPrecisionTestCriterion -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Percent],
			Units -> Percent,
			Description -> "The maximum acceptable percent relative standard deviation in peak position across multiple samples.",
			Category -> "Analysis & Reports"
		}
	}
}];
