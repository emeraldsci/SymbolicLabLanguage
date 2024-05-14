

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program, cDNAPrep], {
	Description->"A robotic liquid handler program for extracting RNA from cells and setting up cDNA reactions without the need to first purify the RNA.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MediaVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of media to remove from each well before beginning extraction.",
			Category -> "General"
		},
		WashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of buffer with which to wash the cells.",
			Category -> "General"
		},
		NumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the cells will be washed with wash buffer.",
			Category -> "General"
		},
		LysisSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of lysis solution with which to lyse a well of cells.",
			Category -> "General"
		},
		DNaseVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of DNase to add to each cell lysis reaction.",
			Category -> "General"
		},
		StopSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of stop solution used to quench each cell lysis reaction.",
			Category -> "General"
		},
		RTBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of reverse transcriptase buffer to put in each cDNA reaction well.",
			Category -> "General"
		},
		RTEnzymeVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of reverse transcriptase to put in each cDNA reaction well.",
			Category -> "General"
		},
		RNAVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of lysate to transfer to each cDNA reaction well.",
			Category -> "General",
			Abstract -> True
		},
		ReactionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The total volume of each cDNA synthesis reaction.",
			Category -> "General"
		},
		CellSamples -> {
			Format -> Multiple,
			Class -> {String, Link, Real, Expression},
			Pattern :> {SLLWellPositionP, _Link, GreaterEqualP[0*Liter], BooleanP},
			Relation -> {Null, Object[Sample], Null, Null},
			Units -> {None, None, Liter Micro, None},
			Description -> "RNA lysate information.",
			Category -> "General",
			Headers -> {"Destination Well","Cell Sample","RNA Lysate Volume","Reverse Transcriptase Addition"}
		},
		LidLocations -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The positions of the cell plate lids.",
			Category -> "Robotic Liquid Handling"
		},
		SampleWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The positions of the wells containing the cells from which RNA will be extracted.",
			Category -> "Robotic Liquid Handling"
		},
		LysisMixVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume which should be pipetted up and down in order to mix the cells with lysis solution.",
			Category -> "Robotic Liquid Handling"
		},
		NumberOfLysisMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the cells will be mixed up and down with lysis solution.",
			Category -> "Robotic Liquid Handling"
		},
		LysisTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time for which the cells will be incubated with lysis buffer.",
			Category -> "Robotic Liquid Handling",
			Abstract -> True
		},
		StopSolutionMixVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume which should be pipetted up and down in order to mix the lysed cells with stop solution.",
			Category -> "Robotic Liquid Handling"
		},
		NumberOfStopMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the cells in lysis buffer will be mixed up and down with stop solution.",
			Category -> "Robotic Liquid Handling"
		},
		StopTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the lysed cells will be incubated with stop solution.",
			Category -> "Robotic Liquid Handling"
		},
		ExtractionReagentLocations -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The positions of all reagents needed for making the RNA extraction master mix.",
			Category -> "Robotic Liquid Handling"
		},
		ExtractionReagentVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of each reagent to transfer when making the RNA extraction master mix.",
			Category -> "Robotic Liquid Handling"
		},
		RNAWells -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A list of the wells from which extracted RNA should be aspirated in order to transfer it to the final cDNA plate.",
			Category -> "Robotic Liquid Handling"
		},
		cDNAWells -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A list of the wells in the final cDNA plate which will recieve the aspirated RNA.",
			Category -> "Robotic Liquid Handling"
		},
		cDNAReagentVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volumes to transfer when making the cDNA master mixes.",
			Category -> "Robotic Liquid Handling"
		},
		cDNAReagentLocations -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The positions of all reagents needed for making the cDNA master mix.",
			Category -> "Robotic Liquid Handling"
		},
		cDNAReagentDestinations -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A list of wells which will recieve the aspirated cDNA master mix reagents.",
			Category -> "Robotic Liquid Handling"
		},
		cDNAMasterMixTransfers -> {
			Format -> Multiple,
			Class -> {String, String, Real},
			Pattern :> {Patterns`Private`robotSequenceP, Patterns`Private`robotSequenceP, VolumeP},
			Units -> {None, None, Liter Micro},
			Description -> "Describes the transfer of cDNA master mix into the final cDNA plate.",
			Category -> "Robotic Liquid Handling",
			Headers -> {"MasterMix Position","Receiving Well","Transfer Volume"}
		},
		RNAPlateStamps -> {
			Format -> Multiple,
			Class -> {String, String, String, String, String, Integer, Integer},
			Pattern :> {Patterns`Private`robotSequenceP, Patterns`Private`robotSequenceP, Patterns`Private`robotSequenceP, Patterns`Private`robotSequenceP, Patterns`Private`robotSequenceP, NumericBooleanP, NumericBooleanP},
			Units -> {None, None, None, None, None, None, None},
			Description -> "Information pertaining to stamping the sample plate during RNA extraction.",
			Category -> "Robotic Liquid Handling",
			Headers-> {"300 uL Tip Location","50 uL Tip Location","300 uL Tips to Pick","50 uL Tips to Pick","Cell Wells to Stamp","Tip Loading","Tip Dispensing"}
		}
	}
}];
