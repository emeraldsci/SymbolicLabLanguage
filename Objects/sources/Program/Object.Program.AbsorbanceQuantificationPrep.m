

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program, AbsorbanceQuantificationPrep], {
	Description->"A robot program for quantifying the concentration of oligomers using absorbance measurements.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		SampleAliquots -> {
			Format -> Multiple,
			Class -> {Expression, Link, Real, Integer},
			Pattern :> {SLLWellPositionP, _Link, GreaterEqualP[0*Micro*Liter], GreaterEqualP[0, 1]},
			Relation -> {Null, Object[Sample], Null, Null},
			Units -> {None, None, Liter Micro, None},
			Description -> "The amount of sample that is transferred from the source plate to the read plate for measurement.",
			Category -> "General",
			Headers -> {"Read Plate Well", "Sample", "Volume", "Read Plate Number"}
		},
		MixVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The volume the pipettor uses to successively aspirate and dispense the sample in the read plate, so as to thoroughly agitate and mix it.",
			Category -> "Robotic Liquid Handling"
		},
		MixSourceVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The volume the pipettor uses to successively aspirate and dispense the sample in the source plate, so as to thoroughly agitate and mix it.",
			Category -> "Robotic Liquid Handling"
		},
		NumberOfMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of cycles of mixing in each well. A cycle is defined by one aspirate and dispense motion.",
			Category -> "Robotic Liquid Handling"
		},
		DilutionSource -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The robotic positions of the buffer used to pre-Dilute the samples prior to quantification.",
			Category -> "Robotic Liquid Handling"
		},
		DilutionDestination -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The robotic destination positions of the buffer used to pre-dilute the samples prior to quantification.",
			Category -> "Robotic Liquid Handling"
		},
		DilutionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The volumes of the buffers used to pre-Dilute the samples prior to quantification (in microliters).",
			Category -> "Robotic Liquid Handling"
		},
		BufferAliquots -> {
			Format -> Multiple,
			Class -> {String, String, Real},
			Pattern :> {Patterns`Private`robotSequenceP, Patterns`Private`robotSequenceP, GreaterEqualP[0*Liter*Micro]},
			Units -> {None, None, Liter Micro},
			Description -> "The robotic-interpretable string describing the aliquoting.",
			Category -> "Robotic Liquid Handling",
			Headers -> {"Buffer Sources", "Buffer Destination Wells", "Volume"}
		},
		BufferDiluentSource -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The robotic position of the diluent that is mixed with the buffer to achieve a 1X concentration.",
			Category -> "Robotic Liquid Handling"
		},
		BufferDiluentDestination -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The robotic destination positions for the diluent that is mixed with the buffer to achieve a 1X concentration.",
			Category -> "Robotic Liquid Handling"
		},
		BufferDiluentVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro Liter],
			Units -> Micro Liter,
			Description -> "The volume of diluent (in microliters) to add to each buffer destination well to achieve the required 1X buffer concentration.",
			Category -> "Robotic Liquid Handling"
		},
		SampleSource -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The robotic sample locations in the source plates.",
			Category -> "Robotic Liquid Handling"
		},
		SampleDestination -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The robotic destination positions in the read plates.",
			Category -> "Robotic Liquid Handling"
		},
		SampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter*Micro],
			Units -> Liter Micro,
			Description -> "The sample volumes to be transferred into the read plate for quantification (in microliters).",
			Category -> "Robotic Liquid Handling"
		},
		SampleDilutionSource -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The robotic locations of samples to be diluted in the read plates, if iteration is required.",
			Category -> "Robotic Liquid Handling"
		},
		SampleDilutionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The volumes of sample to be removed from the read plate and discarded as waste (in microliters), if iteration is required.",
			Category -> "Robotic Liquid Handling"
		},
		NumberOfSourcePlates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of source plates that will be present on the robot deck.",
			Category -> "Robotic Liquid Handling",
			Abstract -> True
		},
		NumberOfDilutionPlates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of dilution plates that will be present on the robot deck for initial pre-dilution of the samples.",
			Category -> "Robotic Liquid Handling",
			Abstract -> True
		},
		NumberOfDestinationPlates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of destination read plates that will be present on the robot deck.",
			Category -> "Robotic Liquid Handling",
			Abstract -> True
		},
		DiluteSamples -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the samples will be pre-diluted prior to quantification.",
			Category -> "Robotic Liquid Handling",
			Abstract -> True
		},
		FilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The location of the exported file describing the absorbance quantification prep operations.",
			Category -> "Robotic Liquid Handling"
		}
	}
}];
