(* ::Package:: *)

DefineObjectType[Object[Qualification, Diffractometer],{
	Description -> "A protocol that verifies the functionality of the diffractometer target.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
	
		(* Method Information *)
		CrystallizationPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation ->Alternatives[ 
				Model[Container],
				Object[Container]
			],
			Description -> "The crystallization plate in which the samples will be during X-ray data collection.",
			Category -> "General"
		},
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The liquid handler instrument employed to transfer samples to the crystallization plate.",
			Category -> "General"
		},
		XRayDiffractionProtocol->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,PowderXRD],
			Description -> "The X-Ray Diffraction protocol used to collect qualification data.",
			Category -> "General"
		},
		SamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The primitives used by Sample Manipulation to generate the XRD Blanks and Standards.",
			Category -> "Sample Preparation"
		},
		TransferType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[MassTransfer, SlurryTransfer, Automatic],
			Description -> "The transfer type required for preparing the samples in the crystallization plate.",
			Category -> "Sample Preparation"
		},

		(* Analytes *)
		LinePositionTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Input samples for this qualification's Line Position Test.",
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

		(* Data and Results *)
		XRayDiffractionData -> {
			Format -> Multiple,
			Class  -> Link,
			Pattern :> _Link,
			Relation -> Object[Data,XRayDiffraction],
			Description -> "The data collected by the mass spectrometry protocol.",
			Category -> "Experimental Results"
		},
		SampleLinePositions -> {
			Format -> Multiple,
			Class ->{Link,Expression,Real,Real,Integer,Integer,Boolean},
			Pattern :> {_Link,Alternatives[Fixed,Sweeping],GreaterEqualP[0*Millimeter],GreaterEqualP[0*Second],GreaterEqualP[0],GreaterEqualP[0],BooleanP},
			Relation ->{Model[Sample],Null,Null,Null,Null,Null,Null},
			Units->{None,None,Millimeter,Second,None,None,None},
			Headers -> {"Sample","Detector Rotation","Detector Distance","Exposure Time","Peaks Found","Minimum Peaks Required","Passing"},
			Category -> "Analysis & Reports",
			Description -> "The number of accurate lines observed for each test sample during the experiment in the form: {Sample, Detector Rotation, Detector Distance, Exposure Time, Peaks Found, Minimum Peaks Required, Passing}."
		},
		SampleLinePositionDistributions -> {
			Format->Multiple,
			Class -> {Real,Expression,Real,Real,Boolean},
			Pattern :> {GreaterP[0*AngularDegree],DistributionP[],GreaterEqualP[0*Percent],GreaterEqualP[0*Percent],BooleanP},
			Units ->{AngularDegree,None,Percent,Percent,None},
			Headers -> {"Expected Line Position","Line Position Distribution","% Relative Standard Deviation","Allowed Deviation","Passing"},
			Description -> "For all wells spotted with the same sample model, the distributions of their line positions in the form: {Expected Line Position,Line Position Distribution,% Relative Standard Deviation, Allowed Deviation, Passing}.",
			Category -> "Analysis & Reports"
		},
		BlankLinePositions -> {
			Format -> Multiple,
			Class ->{Link,Expression,Real,Real,Integer,Integer,Boolean},
			Pattern :> {_Link,Alternatives[Fixed,Sweeping],GreaterEqualP[0*Millimeter],GreaterEqualP[0*Second],GreaterEqualP[0],GreaterEqualP[0],BooleanP},
			Relation ->{Model[Sample],Null,Null,Null,Null,Null,Null},
			Units->{None,None,Millimeter,Second,None,None,None},
			Headers -> {"Sample","Detector Rotation","Detector Distance","Exposure Time","Peaks Found","Maximum Peaks Allowed","Passing"},
			Category -> "Analysis & Reports",
			Description -> "The number of lines observed for each blank sample during the experiment in the form: {Sample, Detector Rotation, Detector Distance, Exposure Time, Peaks Found, Maximum Peaks Allowed, Passing}."
		},

		(* Pass/Fail test results *)
		SampleLinePositionAccuracyResult -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> QualificationResultP,
			Description -> "Indicates the outcome of the test sample line position accuracy test after evaluation.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		SampleLinePositionPrecisionResult -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> QualificationResultP,
			Description -> "Indicates the outcome of the test sample line position precision test after evaluation.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		BlankLinePositionPrecisionResult -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> QualificationResultP,
			Description -> "Indicates the outcome of the blank line position test after evaluation.",
			Category -> "Analysis & Reports",
			Abstract -> True
		}
	}
}];



