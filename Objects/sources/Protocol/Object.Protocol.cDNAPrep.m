

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, cDNAPrep], {
	Description->"A protocol directing preparation of cDNA from cells for quantification of transcript expression levels.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MediaVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of media to remove from each well of cells to empty the well in preparation for washing and cell lysis.",
			Category -> "Cell Washing"
		},
		WashBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The buffer (e.g. PBS) used to wash the cells before lysis.",
			Category -> "Cell Washing"
		},
		WashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of PBS with which to wash the wells of cells.",
			Category -> "Cell Washing"
		},
		NumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the cells will be washed with PBS.",
			Category -> "Cell Washing"
		},
		LysisSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The cell lysis solution used to prepare RNA lysates.",
			Category -> "Cell Lysis"
		},
		LysisSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of lysis solution with which to lyse a well of cells.",
			Category -> "Cell Lysis"
		},
		LysisTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time in seconds for which the cells will be incubated with lysis buffer.",
			Category -> "Cell Lysis"
		},
		NumberOfLysisMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the cells will be mixed up and down with lysis solution.",
			Category -> "Cell Lysis"
		},
		LysisMixVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of each mixing step when mixing the cells with lysis solution.",
			Category -> "Cell Lysis"
		},
		DNase -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The DNase solution used to prepare RNA lysates.",
			Category -> "Cell Lysis"
		},
		DNaseVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of DNase to add to each cell lysis reaction.",
			Category -> "Cell Lysis"
		},
		StopSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The stop solution used to quench the cell lysis reaction.",
			Category -> "Cell Lysis"
		},
		StopSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of stop solution to add to each cell lysis reaction.",
			Category -> "Cell Lysis"
		},
		StopTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time in seconds for which the cells will be incubated with lysis stop solution.",
			Category -> "Cell Lysis"
		},
		NumberOfStopMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the cells in lysis buffer will be mixed up and down with stop solution.",
			Category -> "Cell Lysis"
		},
		StopMixVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of each mixing step when mixing the cells in lysis solution with stop solution.",
			Category -> "Cell Lysis"
		},
		RNALysateVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of RNA lysate that is added to each cDNA prep reaction.",
			Category -> "Reverse Transcription"
		},
		ReactionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The total volume of each cDNA reaction.",
			Category -> "Reverse Transcription"
		},
		ReverseTranscriptase -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if reverse transcriptase enzyme is added to each cDNA prep reaction.",
			Category -> "Reverse Transcription"
		},
		ReverseTranscriptaseBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The reverse transcriptase buffer used to generate cDNA from RNA.",
			Category -> "Reverse Transcription"
		},
		RTBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of 2x RT buffer to put in each cDNA reaction.",
			Category -> "Reverse Transcription"
		},
		ReverseTranscriptaseEnzyme -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The reverse trancriptase enzyme used to generate cDNA from RNA.",
			Category -> "Reverse Transcription"
		},
		RTEnzymeVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of 20x RT enzyme to put in each cDNA reaction.",
			Category -> "Reverse Transcription"
		},
		PrimerAnnealingTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature in celsius of the step used to allow the primers to bind to the RNA strands.",
			Category -> "Reverse Transcription"
		},
		PrimerAnnealingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time in seconds of the step used to allow the primers to bind to the RNA strands.",
			Category -> "Reverse Transcription"
		},
		ExtensionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature in celsius of the step used to allow the enzyme to extend the new cDNA strand from the primers.",
			Category -> "Reverse Transcription"
		},
		ExtensionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time in seconds of the step used to allow the enzyme to extend the new cDNA strand from the primers.",
			Category -> "Reverse Transcription"
		},
		InactivationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature in celsius of the final inactivation step used to inactivate the enzyme.",
			Category -> "Reverse Transcription"
		},
		InactivationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time in seconds of the final inactivation step used to inactivate the enzyme.",
			Category -> "Reverse Transcription"
		},
		RampRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Celsius)/Second],
			Units -> Celsius/Second,
			Description -> "The rate at which the temperature changes in degrees celsius per second between each step in the cDNA reaction.",
			Category -> "Reverse Transcription"
		},
		MethodFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the thermocycler method file used to run this plate of cDNA synthesis reactions.",
			Category -> "General"
		},
		cDNAPrepProgram -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "The program object containing detailed instructions for a robotic liquid handler.",
			Category -> "General"
		}
	}
}];
