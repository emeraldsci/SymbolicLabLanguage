(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,FragmentAnalyzer],{
	Description->"A protocol that verifies the functionality of the FragmentAnalyzer instrument target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		SamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description -> "The sample preparation protocol used to generate the plate that contains the samples to be used for the qualification. The plate generated is used as the input for a FragmentAnalysis protocol with PreparedPlate -> True, where the plate is directly placed in the sample drawer of the instrument, ready for injection, and does not involve any plate preparation steps within the protocol.",
			Category -> "Sample Preparation"
		},
		FragmentSizeAccuracyResult -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> QualificationResultP,
			Description -> "Indicates the outcome of the qualification of the size accuracy. Result is a Pass if % Mean Size Error for all target peaks detected is less than or equal to the % Mean Size Error (SizeErrorTolerance) specified by the manufacturer. The % Mean Size Error is calculated as the mean of all the calculated difference between the expected and actual size of a fragment divided by expected size.",
			Category -> "Experimental Results"
		},
		FragmentSizePrecisionResult -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> QualificationResultP,
			Description -> "Indicates the outcome of the qualification of size precision. Result is a Pass if the % CV for all the target peaks is less than the % CV (SizePrecisionTolerance) specified by the manufacturer . The % CV per target peak is calculated using standard deviation divided by mean of all comparable peaks detected.",
			Category -> "Experimental Results"
		},
		FragmentSizeAccuracyData ->{
			Format->Multiple,
			Class->{
				String,
				Expression,
				Real,
				Expression
			},
			Pattern:>{
				_String,
				Alternatives[{GreaterEqualP[0 BasePair]...},{GreaterEqualP[0 Nucleotide]...}],
				Alternatives[GreaterEqualP[0 Percent],Null],
				QualificationResultP
			},
			Headers->{"Well","Detected Peaks","Mean Percent Size Error","Result"},
			Description->"The data set collected for each capillary and is used to assess if it meets performance standards with respect to size accuracy. Each data set includes the well corresponding to the capillary, the fragment sizes detected in the run through the capillary, the % mean size error for all peaks, and whether the capillary passes qualification accuracy.",
			Category -> "Experimental Results"
		},
		FragmentSizePrecisionData ->{
			Format->Multiple,
			Class->{
				Real,
				Expression,
				Real,
				Expression
			},
			Pattern:>{
				Alternatives[GreaterEqualP[0 BasePair],GreaterEqualP[0 Nucleotide]],
				Alternatives[{GreaterEqualP[0 BasePair]...},{GreaterEqualP[0 Nucleotide]...}],
				Alternatives[GreaterEqualP[0 Percent],Null],
				QualificationResultP
			},
			Headers->{"Target Peak","Comparable Peaks Detected","Mean Percent CV","Result"},
			Description->"The data set collected for each target peak expected for all capillaries and is used to assess if the capillary array meets performance standards with respect to size precision. Each data set includes the target peak assessed, the list of comparable peaks detected in all the capillaries, the % CV for all comparable peaks detected, and whether the capillary array passes qualification precision for the target peak precision.",
			Category -> "Experimental Results"
		}
		
	}
}];
