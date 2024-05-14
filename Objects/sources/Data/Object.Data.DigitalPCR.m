(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, DigitalPCR],{
	Description->"Digital Polymerase Chain Reaction randomly distributes targets by partitioning sample into nanoliter-sized droplets before amplifying them and counts the number of droplets that have fluorescence signal out of the total.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* -- Method Information -- *)
		AssaySample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample][Data],
			Description -> "The stock or diluted sample that was used in the reaction mixture to generate the data from an experimental run.",
			Category -> "General",
			Abstract -> True
		},

		DilutionFactor -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _Real,
			Description -> "The amount by which SamplesIn was diluted to generate AssaySample used to generate data.",
			Category -> "General"
		},

		(* - Sample properties - *)
		TemplateType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[DNA,RNA],
			Description -> "The type of oligomer used as source material for this digital PCR experiment. Use of RNA template implies that an RT step was done prior to amplification.",
			Category -> "General",
			Abstract -> True
		},

		(* - Target probes and primers - *)
		Probes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "For each member of EmissionWavelengths, the reporter probe (composed of a short, sequence-specific oligomer conjugated with a reporter and a quencher) used to quantify amplification of a specific DNA sequence.",
			Category -> "General",
			IndexMatching -> EmissionWavelengths,
			Abstract -> True
		},

		ExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Nanometer,
			Description -> "For each member of EmissionWavelengths, the wavelengths of the excitation filters used to illuminate the droplets.",
			Category -> "General",
			IndexMatching -> EmissionWavelengths
		},

		EmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Nanometer,
			Description -> "The wavelengths of the emission filters used to collect fluorescence signal data from droplets.",
			Category -> "General"
		},

		Primers -> {
			Format -> Multiple,
			Class -> {Link,Link},
			Pattern :> {_Link,_Link},
			Relation -> {Object[Sample],Object[Sample]},
			Description -> "For each member of EmissionWavelengths, the primer pairs used to amplify target sequences.",
			Headers -> {"Forward Primer", "Reverse Primer"},
			Category -> "General",
			IndexMatching -> EmissionWavelengths
		},

		(* - Reference probes and primers - *)
		ReferenceProbes->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "For each member of ReferenceEmissionWavelengths, the reporter probe (composed of a short, sequence-specific oligomer conjugated with a reporter and a quencher) used to quantify amplification of a specific DNA sequence used as a housekeeping gene.",
			Category -> "General",
			IndexMatching -> ReferenceEmissionWavelengths,
			Abstract -> True
		},

		ReferenceExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Nanometer,
			Description -> "For each member of ReferenceEmissionWavelengths, the wavelengths of the excitation filters used to illuminate the droplets.",
			Category -> "General",
			IndexMatching -> ReferenceEmissionWavelengths
		},

		ReferenceEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Nanometer,
			Description -> "The wavelengths of the emission filters used to collect fluorescence signal data from droplets.",
			Category -> "General"
		},

		ReferencePrimers->{
			Format -> Multiple,
			Class -> {Link,Link},
			Pattern :> {_Link,_Link},
			Relation -> {Object[Sample],Object[Sample]},
			Description -> "For each member of ReferenceEmissionWavelengths, the primer pairs used to amplify target sequences used as used as a housekeeping gens.",
			Headers -> {"Forward Primer", "Reverse Primer"},
			Category -> "General",
			IndexMatching -> ReferenceEmissionWavelengths
		},


		(* - Well & plate information - *)
		Well -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WellP,
			Description -> "The well in the plate from which the data were collected.",
			Category -> "General"
		},

		DropletCartridge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Plate,DropletCartridge],
			Description -> "The plate in which the sample is assayed.",
			Category -> "General"
		},

		(* -- Data file -- *)
		(* Summary data file is not needed after raw data file is available *)
		SummaryDataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "The file containing the summary data table generated by the instrument software during a DigitalPCR run.",
			Category -> "Data Processing"
		},

		(* -- Experimental Results -- *)
		(* Indexed field *)
		DropletExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Nanometer,
			Description -> "For each member of DropletEmissionWavelengths, the wavelengths of the excitation filters used to illuminate the droplets.",
			Category -> "Experimental Results",
			IndexMatching -> DropletEmissionWavelengths
		},
		DropletEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Nanometer,
			Description -> "The wavelengths of the emission filters used to collect fluorescence signals from the droplets in relation to indexed fields in DropletAmplitudes.",
			Category -> "Experimental Results"
		},
		DropletAmplitudes -> {
			Format -> Single,
			Class -> {
				QuantityArray,
				QuantityArray,
				QuantityArray,
				QuantityArray
			},
			Pattern :> {
				_?(QuantityVectorQ[#,RFU]&),
				_?(QuantityVectorQ[#,RFU]&),
				_?(QuantityVectorQ[#,RFU]&),
				_?(QuantityVectorQ[#,RFU]&)
			},
			Units -> {
				RFU,
				RFU,
				RFU,
				RFU
			},
			Headers -> {
				"517 nm",
				"556 nm",
				"665 nm",
				"694 nm"
			},
			Description -> "Raw data representing the magnitude of fluorescence signal measured in each detection channel from each droplet in the sample well.",
			Category -> "Experimental Results"
		},

		(* Individual Fields *)
		DropletAmplitudes517nm -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> _?(QuantityVectorQ[#,RFU]&),
			Units -> RFU,
			Description -> "Array of fluorescence signal magnitudes measured from each droplet in 517 nm emission channel.",
			Category -> "Experimental Results"
		},
		DropletAmplitudes556nm -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> _?(QuantityVectorQ[#,RFU]&),
			Units -> RFU,
			Description -> "Array of fluorescence signal magnitudes measured from each droplet in 556 nm emission channel.",
			Category -> "Experimental Results"
		},
		DropletAmplitudes665nm -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> _?(QuantityVectorQ[#,RFU]&),
			Units -> RFU,
			Description -> "Array of fluorescence signal magnitudes measured from each droplet in 665 nm emission channel.",
			Category -> "Experimental Results"
		},
		DropletAmplitudes694nm -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> _?(QuantityVectorQ[#,RFU]&),
			Units -> RFU,
			Description -> "Array of fluorescence signal magnitudes measured from each droplet in 694 nm emission channel.",
			Category -> "Experimental Results"
		},

		(* -- Analysis & Reports -- *)
		(*
			Currently, average amplitudes and droplet counts are coming from summary file, which is generated by the auto-analysis performed by instrument software.
			Once raw data is available, average droplet amplitude values and droplet counts can be derived from in-house analysis
		*)
		AverageDropletAmplitudes -> {
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterEqualP[0*RFU],GreaterEqualP[0*RFU]},
			Units -> {RFU,RFU},
			Description -> "For each member of EmissionWavelengths, the mean magnitude of fluorescence signal from a population of droplets.",
			Headers -> {"Signal Positive","Signal Negative"},
			Category -> "Analysis & Reports",
			IndexMatching -> EmissionWavelengths
		},

		DropletSignalThresholds -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RFU],
			Units -> RFU,
			Description -> "For each member of EmissionWavelengths, the amplitude cut-off value used to separate the population of droplets with positive signal from droplets with no signal for a target.",
			Category -> "Analysis & Reports",
			IndexMatching -> EmissionWavelengths
		},

		DropletCounts -> {
			Format -> Multiple,
			Class -> {Integer,Integer},
			Pattern :> {GreaterEqualP[0,1],GreaterEqualP[0,1]},
			Description -> "For each member of EmissionWavelengths, the number of droplets with positive and negative signals.",
			Headers -> {"Signal Positive","Signal Negative"},
			Category -> "Analysis & Reports",
			IndexMatching -> EmissionWavelengths
		},

		ReferenceAverageDropletAmplitudes -> {
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterEqualP[0*RFU],GreaterEqualP[0*RFU]},
			Units -> {RFU,RFU},
			Description -> "For each member of ReferenceEmissionWavelengths, the mean magnitude of fluorescence signal from a population of droplets.",
			Headers -> {"Signal Positive","Signal Negative"},
			Category -> "Analysis & Reports",
			IndexMatching -> ReferenceEmissionWavelengths
		},

		ReferenceDropletSignalThresholds -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RFU],
			Units -> RFU,
			Description -> "For each member of ReferenceEmissionWavelengths, the amplitude cut-off value used to separate the population of droplets with positive signal from droplets with no signal for a target.",
			Category -> "Analysis & Reports",
			IndexMatching -> ReferenceEmissionWavelengths
		},

		ReferenceDropletCounts -> {
			Format -> Multiple,
			Class -> {Integer,Integer},
			Pattern :> {GreaterEqualP[0,1],GreaterEqualP[0,1]},
			Description -> "For each member of ReferenceEmissionWavelengths, the number of droplets with positive and negative signals.",
			Headers -> {"Signal Positive","Signal Negative"},
			Category -> "Analysis & Reports",
			IndexMatching -> ReferenceEmissionWavelengths
		}

		(*CopyNumberAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis,CopyNumber][Data],
			Description -> "The analysis object(s) containing the copy number calculation results. Each copy number is determined using Poisson Statistics from the fraction of negative droplet out of the total.",
			Category -> "Analysis & Reports"
		}*)
	}
}];