

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, XRayDiffraction], {
	Description->"X-ray diffraction data as measured by a diffractometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		StructureAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The resolved crystal structure analysis using this diffraction pattern as source data.",
			Category -> "Analysis & Reports"
		},
		DiffractionPattern -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{AngularDegree,ArbitraryUnit}],
			Units -> {AngularDegree,ArbitraryUnit},
			Description -> "The diffraction pattern of a powder X-ray diffraction experiment.",
			Category -> "Experimental Results"
		},
		BlankedDiffractionPattern -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{AngularDegree,ArbitraryUnit}],
			Units -> {AngularDegree,ArbitraryUnit},
			Description -> "The diffraction pattern of a powder X-ray diffraction experiment with background removed.",
			Category -> "Experimental Results"
		},
		DiffractionPeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak picking analysis conducted on the powder X-ray diffraction pattern.",
			Category -> "Analysis & Reports"
		},
		SmoothingAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Smoothing analysis performed on this data.",
			Category -> "Analysis & Reports"
		},
		ExperimentType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> XRDExperimentTypeP,
			Description -> "Indicates the type of X-ray diffraction experiment that was performed.",
			Category -> "Instrument Specifications"
		},
		BeamPower -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Watt],
			Units -> Watt,
			Description -> "The beam power used in generating the X-rays that created this diffraction dataset.",
			Category -> "Instrument Specifications"
		},
		Voltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "The voltage used in generating the X-rays that created this diffraction dataset.",
			Category -> "Instrument Specifications"
		},
		Current -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Ampere],
			Units -> Ampere,
			Description -> "The current used in generating the X-rays that created this diffraction dataset.",
			Category -> "Instrument Specifications"
		},
		ExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time the detector was exposed for each frame of the diffraction.",
			Category -> "Instrument Specifications"
		},
		Reflections -> {
			Format -> Multiple,
			Class -> {
				hIndex -> Integer,
				kIndex -> Integer,
				lIndex -> Integer,
				Intensity -> Real,
				IntensityError -> Real,
				Run -> Integer
			},
			Pattern :> {
				hIndex -> _Integer,
				kIndex -> _Integer,
				lIndex -> _Integer,
				Intensity -> GreaterEqualP[0],
				IntensityError -> GreaterEqualP[0],
				Run -> GreaterP[0, 1]
			},
			Units -> {
				hIndex -> None,
				kIndex -> None,
				lIndex -> None,
				Intensity -> None,
				IntensityError -> None,
				Run -> None
			},
			Description -> "A list of all measured X-ray reflections observed and their corresponding indices (in accordance with Bragg's Law).",
			Category -> "Data Processing"
		},
		DiffractionImages -> {
			Format -> Multiple,
			Class -> BigCompressed,
			Pattern :> Graphics_,
			Description -> "All images of the diffraction patterns of the sample.",
			Category -> "Experimental Results"
		},
		SampleImages -> {
			Format -> Multiple,
			Class -> BigCompressed,
			Pattern :> Graphics_,
			Description -> "All images of the sample itself during the experiment.",
			Category -> "Experimental Results"
		},
		RawDataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing all raw data pertaining to the X-ray experiment zipped into one directory.",
			Category -> "Data Processing"
		}

	}
}];
