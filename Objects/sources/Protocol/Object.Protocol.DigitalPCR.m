

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol,DigitalPCR],{
	Description->"A protocol for quantifying target copy numbers by partitioning samples into nanoliter droplets, amplifying target templates using polymerase chain reaction, and reading fluorescence signals from individual droplets.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* Method Information *)
		Instrument->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Thermocycler,DigitalPCR],
				Object[Instrument,Thermocycler,DigitalPCR]
			],
			Description -> "The device used to generate droplets, amplify target and read fluorescence signals.",
			Category -> "General"
		},
		MethodFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The name(s) of the plate template file containing the layout of samples for the experiment.",
			Category -> "General",
			Developer -> True
		},
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The full file path of the plate template file(s) used to run this digital PCR experiment.",
			Category -> "General",
			Developer->True
		},
		MethodTransferFile->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path and name of the .bat file which transfers method file from the public drive to the local instrument folder before instrument setup.",
			Category -> "General",
			Developer -> True
		},
		RunTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Minute,
			Description -> "The length of time for which the instrument is expected to run given the specified parameters.",
			Category -> "General"
		},

		(* Retire the fields after QA update *)
		DropletGeneratorOil->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The immiscible liquid that is used to generate nanoliter-sized aqueous droplets in microfluidic channels of DropletCartridges.",
			Category->"General"
		},
		DropletReaderOil->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The immiscible liquid that will be used to separate droplets and facilitate fluorescence signal detection from the individual droplets.",
			Category->"General"
		},

		(* New multiple fields *)
		DropletGeneratorOils->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The immiscible liquid that is used to generate nanoliter-sized aqueous droplets in microfluidic channels of DropletCartridges.",
			Category->"General"
		},
		DropletReaderOils->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The immiscible liquid that will be used to separate droplets and facilitate fluorescence signal detection from the individual droplets.",
			Category->"General"
		},
		
		AmplitudeMultiplex517nm->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0.,1.],
			Description->"For each member of AssaySamples, the number of genetic targets to be detected at emission wavelength of 517 nm (FAM channel) for amplitude multiplexing.",
			Category->"General",
			IndexMatching->AssaySamples
		},
		AmplitudeMultiplex556nm->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0.,1.],
			Description->"For each member of AssaySamples, the number of genetic targets to be detected at emission wavelength of 556 nm (HEX channel) for amplitude multiplexing.",
			Category->"General",
			IndexMatching->AssaySamples
		},
		AmplitudeMultiplex665nm->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0.,1.],
			Description->"For each member of AssaySamples, the number of genetic targets to be detected at emission wavelength of 665 nm (Cy5 channel) for amplitude multiplexing.",
			Category->"General",
			IndexMatching->AssaySamples
		},
		AmplitudeMultiplex694nm->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0.,1.],
			Description->"For each member of AssaySamples, the number of genetic targets to be detected at emission wavelength of 694 nm (Cy5.5 channel) for amplitude multiplexing.",
			Category->"General",
			IndexMatching->AssaySamples
		},

		PreparedPlate->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the experimental inputs are in a prepared droplet cartridge with samples, primers, probes, master mixes, diluents and filled passive wells.",
			Category->"General"
		},

		NumberOfDilutions->{
			Format->Multiple,
			Class->Integer,
			Pattern:>_Integer,
			Description->"For each member of SamplesIn, the number of times a sample is sequentially transferred and mixed with Diluent to create a series of decreasing target concentrations for a DigitalPCR assay.",
			Category->"Sample Preparation",
			IndexMatching->SamplesIn
		},

		(* Sample preparation *)
		AssaySamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The samples (aliquot of SamplesIn or diluted input samples) that are used to prepare reaction mixtures to be loaded in ActiveWells of DropletCartridges.",
			Category -> "Sample Preparation"
		},

		SerialDilutions -> {
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterEqualP[0*Microliter],GreaterEqualP[0*Microliter]},
			Units -> {Microliter,Microliter},
			Description -> "For each member of AssaySamples, the volumes of the sample transferred and the Diluent to generate decreasing concentrations of target for DigitalPCR assay.",
			Category -> "Sample Preparation",
			Headers ->{"Transfer Volume","Diluent Volume"},
			IndexMatching -> AssaySamples
		},
		DilutionFactors -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "For each member of AssaySamples, the fraction of volume that is transferred for a subsequent dilution of samples to generate a serial dilution curve.",
			Category -> "Sample Preparation",
			IndexMatching -> AssaySamples
		},
		DilutionMixVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of AssaySamples, the quantity of mixture that is pipetted in and out of the sample for thorough mixing.",
			Category -> "Sample Preparation",
			IndexMatching -> AssaySamples
		},
		DilutionMixRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0.4 Microliter/Second,250 Microliter/Second],
			Units -> Microliter/Second,
			Description -> "For each member of AssaySamples, the speed at which the DilutionMixVolume is pipetted in and out of the sample for thorough mixing.",
			Category -> "Sample Preparation",
			IndexMatching -> AssaySamples
		},
		DilutionNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[0,20,1],
			Description -> "For each member of AssaySamples, the number of times DilutionMixVolume is pipetted in and out of the sample for thorough mixing.",
			Category -> "Sample Preparation",
			IndexMatching -> AssaySamples
		},

		SampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of AssaySamples, the portion of the reaction that is made up of the sample.",
			Category -> "Sample Preparation",
			IndexMatching -> AssaySamples
		},

		(* Fields for singleton oligomer per AssaySamples *)
		(* Assay type *)
		PremixedPrimerProbes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[TargetAssay,PrimerSet,None],
			Description -> "For each member of AssaySamples, the type of primer and probe input used. TargetAssay indicates a mixture of forward primer, reverse primer and probe, PrimerSet indicates a mixture of forward and reverse primer along with a separate probe, and None indicates individual samples for each oligomer.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},

		(* Primers *)
		ForwardPrimers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "For each member of AssaySamples, the oligomer that binds target sequence on the antisense strand of the template.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},

		ForwardPrimerConcentrations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Nanomolar],
			Units->Nanomolar,
			Description -> "For each member of AssaySamples, the molarity for the oligomer specified as the forward primer in the reaction.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},
		ForwardPrimerVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description -> "For each member of AssaySamples, the volume for the oligomer specified as the forward primer in the reaction.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},

		ReversePrimers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description -> "For each member of AssaySamples, the oligomer that binds target sequence on the sense strand of the template.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},

		ReversePrimerConcentrations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Nanomolar],
			Units->Nanomolar,
			Description -> "For each member of AssaySamples, molarity for the oligomer specified as the reverse primer in the reaction.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},
		ReversePrimerVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description -> "For each member of AssaySamples, volume for the oligomer specified as the reverse primer in the reaction.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},

		(* Probes *)
		Probes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "For each member of AssaySamples, the fluorescently labeled oligomer that is used to quantify the amount of target sequence.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},
		ProbeConcentrations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Nanomolar],
			Units -> Nanomolar,
			Description -> "For each member of AssaySamples, molarity for the oligomer specified as the probe in the reaction.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},
		ProbeVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description -> "For each member of AssaySamples, volume for the oligomer specified as the probe in the reaction.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},
		ProbeFluorophores -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule],
			Description -> "For each member of AssaySamples, the fluorophore conjugated to the molecular probe in the reaction.",
			Category -> "Target Amplification",
			IndexMatching->AssaySamples
		},
		ProbeExcitationWavelengths->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nanometer],
			Units->Nanometer,
			Description->"For each member of AssaySamples, the wavelength of light used to excite the probe.",
			Category -> "Target Amplification",
			IndexMatching->AssaySamples
		},
		ProbeEmissionWavelengths->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nanometer],
			Units->Nanometer,
			Description->"For each member of AssaySamples, the wavelength of light collected from the excited probe.",
			Category -> "Target Amplification",
			IndexMatching->AssaySamples
		},

		(* Reference assay type *)
		ReferencePremixedPrimerProbes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[TargetAssay,PrimerSet,None],
			Description -> "For each member of AssaySamples, the type of primer and probe input used. TargetAssay indicates a mixture of forward primer, reverse primer and probe, PrimerSet indicates a mixture of forward and reverse primer along with a separate probe, and None indicates individual samples for each oligomer.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},

		(* Reference Primers *)
		ReferenceForwardPrimers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "For each member of AssaySamples, the antisense strand-binding oligomer that this experiment uses to amplify a reference gene (such as a housekeeping gene whose concentration does not differ between samples) sequence from the sample.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},
		ReferenceForwardPrimerConcentrations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Nanomolar],
			Units -> Nanomolar,
			Description -> "For each member of AssaySamples, molarity for the oligomer specified as the reference forward primer in the reaction.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},
		ReferenceForwardPrimerVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of AssaySamples, volume for the oligomer specified as the reference forward primer in the reaction.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},
		ReferenceReversePrimers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "For each member of AssaySamples, the sense strand-binding oligomers that this experiment uses to amplify a reference gene (such as a housekeeping gene whose concentration does not differ between samples) sequence from the sample.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},
		ReferenceReversePrimerConcentrations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Nanomolar],
			Units -> Nanomolar,
			Description -> "For each member of AssaySamples, molarity for the oligomer specified as the reference reverse primer in the reaction.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},
		ReferenceReversePrimerVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of AssaySamples, volume for the oligomer specified as the reference reverse primer in the reaction.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},

		(* Reference Probes *)
		ReferenceProbes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "For each member of AssaySamples, the fluorescently labeled oligomer that this experiment uses to quantify the amount of reference gene sequences.",
			Category -> "Reference Amplification",
			IndexMatching->AssaySamples
		},
		ReferenceProbeConcentrations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Nanomolar],
			Units -> Nanomolar,
			Description -> "For each member of AssaySamples, the list of molarities for probes in the reaction that corresponds to the list of probes specified for the sample.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},
		ReferenceProbeVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of AssaySamples, the list of volumes for probes added to the reaction volume that corresponds to the list of reference probes specified for the sample.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},
		ReferenceProbeFluorophores -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Link,
			Relation -> Model[Molecule],
			Description -> "For each member of AssaySamples, the fluorophore conjugated to each of the molecular probes that this experiment uses to quantify the amount of reference sequence(s).",
			Category -> "Reference Amplification",
			IndexMatching->AssaySamples
		},
		ReferenceProbeExcitationWavelengths->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nanometer],
			Units -> Nanometer,
			Description->"For each member of AssaySamples, the wavelengths of light used to excite the probes.",
			Category -> "Reference Amplification",
			IndexMatching->AssaySamples
		},
		ReferenceProbeEmissionWavelengths->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nanometer],
			Units -> Nanometer,
			Description->"For each member of AssaySamples, the wavelengths of light collected from the excited probes.",
			Category -> "Reference Amplification",
			IndexMatching->AssaySamples
		},

		(* Fields for multiple oligomers per AssaySamples related to multiplexed assays *)
		(* Multiplexed assay type *)
		MultiplexedPremixedPrimerProbes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :>{Alternatives[TargetAssay,PrimerSet,None]..},
			Description -> "For each member of AssaySamples, the type of primer and probe input used. TargetAssay indicates a mixture of forward primer, reverse primer and probe, PrimerSet indicates a mixture of forward and reverse primer along with a separate probe, and None indicates individual samples for each oligomer.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},

		(* Multiplexed Primers *)
		MultiplexedForwardPrimers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Link..|Null},
			Description -> "For each member of AssaySamples, the list of oligomers that bind the target sequences on the antisense strand of the template.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},
		MultiplexedForwardPrimerResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Model[Sample],
			Description -> "The flattened list of the forward primers that this experiment uses to amplify target from the sample.",
			Category -> "Target Amplification",
			Developer -> True
		},
		MultiplexedForwardPrimerConcentrations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Nanomolar]..},
			Description -> "For each member of AssaySamples, the list of molarities for oligomers in the reaction that corresponds to the list of forward primers specified for the sample.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},
		MultiplexedForwardPrimerVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Microliter]..},
			Description -> "For each member of AssaySamples, the list of volumes for oligomers added to the reaction that corresponds to the list of forward primers specified for the sample.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},

		MultiplexedReversePrimers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Link..|Null},
			Description -> "For each member of AssaySamples, the list of oligomers that bind the target sequences on the sense strand of the template.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},
		MultiplexedReversePrimerResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Model[Sample],
			Description -> "The flattened list of the reverse primers that this experiment uses to amplify the primary target from the sample.",
			Category -> "Target Amplification",
			Developer -> True
		},
		MultiplexedReversePrimerConcentrations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Nanomolar]..},
			Description -> "For each member of AssaySamples, the list of molarities for oligomers in the reaction that corresponds to the list of reverse primers specified for the sample.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},
		MultiplexedReversePrimerVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Microliter]..},
			Description -> "For each member of AssaySamples, the list of volumes for oligomers added to the reaction that corresponds to the list of reverse primers specified for the sample.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},

		(* Multiplexed Probes *)
		MultiplexedProbes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Link..|Null},
			Description -> "For each member of AssaySamples, the hydrolyzable oligomers with fluorescent labels that this experiment uses to quantify the amount of target sequence.",
			Category -> "Target Amplification",
			IndexMatching->AssaySamples
		},
		MultiplexedProbeResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Model[Sample],
			Description -> "The flattened list of the molecular probes that this experiment uses to quantify the amount of target sequence.",
			Category -> "Target Amplification",
			Developer -> True
		},
		MultiplexedProbeConcentrations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Nanomolar]..},
			Description -> "For each member of AssaySamples, the list of molarities for probes in the reaction that corresponds to the list of probes specified for the sample.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},
		MultiplexedProbeVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Microliter]..},
			Description -> "For each member of AssaySamples, the list of volumes for probes added to the reaction volume that corresponds to the list of probes specified for the sample.",
			Category -> "Target Amplification",
			IndexMatching -> AssaySamples
		},
		MultiplexedProbeFluorophores -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LinkP[Model[Molecule]]..|Null},
			Description -> "For each member of AssaySamples, the fluorophore conjugated to each of the molecular probes that this experiment uses to quantify the amount of target sequence.",
			Category -> "Target Amplification",
			IndexMatching->AssaySamples
		},
		MultiplexedProbeExcitationWavelengths->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0*Nanometer]..},
			Description->"For each member of AssaySamples, the wavelengths of light used to excite the probes.",
			Category -> "Target Amplification",
			IndexMatching->AssaySamples
		},
		MultiplexedProbeEmissionWavelengths->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0*Nanometer]..},
			Description->"For each member of AssaySamples, the wavelengths of light collected from the excited probes.",
			Category -> "Target Amplification",
			IndexMatching->AssaySamples
		},

		(* Multiplexed reference assay type *)
		MultiplexedReferencePremixedPrimerProbes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :>{Alternatives[TargetAssay,PrimerSet,None]..},
			Description -> "For each member of AssaySamples, the type of primer and probe input used. TargetAssay indicates a mixture of forward primer, reverse primer and probe, PrimerSet indicates a mixture of forward and reverse primer along with a separate probe, and None indicates individual samples for each oligomer.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},

		(* Multiplexed Reference Primers *)
		MultiplexedReferenceForwardPrimers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Link..|Null},
			Description -> "For each member of AssaySamples, the antisense strand-binding oligomers that this experiment uses to amplify a reference gene (such as a housekeeping gene whose concentration does not differ between samples) sequence from the sample.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},
		MultiplexedReferenceForwardPrimerResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Model[Sample],
			Description -> "The flattened list of the reference forward primers that this experiment uses to amplify the reference from the sample.",
			Category -> "Reference Amplification",
			Developer -> True
		},
		MultiplexedReferenceForwardPrimerConcentrations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Nanomolar]..},
			Description -> "For each member of AssaySamples, the list of molarities for oligomers in the reaction that corresponds to the list of reference forward primers specified for the sample.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},
		MultiplexedReferenceForwardPrimerVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Microliter]..},
			Description -> "For each member of AssaySamples, the volume of oligomers added to the reaction volume that corresponds to the list of reference forward primers specified for the sample.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},
		MultiplexedReferenceReversePrimers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Link..|Null},
			Description -> "For each member of AssaySamples, the sense strand-binding oligomers that this experiment uses to amplify a reference gene (such as a housekeeping gene whose concentration does not differ between samples) sequence from the sample.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},
		MultiplexedReferenceReversePrimerResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Model[Sample],
			Description -> "The flattened list of the reference reverse primers that this experiment uses to amplify the reference from the sample.",
			Category -> "Reference Amplification",
			Developer -> True
		},
		MultiplexedReferenceReversePrimerConcentrations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Nanomolar]..},
			Description -> "For each member of AssaySamples, the list of molarities for oligomers in the reaction that corresponds to the list of reference reverse primers specified for the sample.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},
		MultiplexedReferenceReversePrimerVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Microliter]..},
			Description -> "For each member of AssaySamples, the volume of oligomers added to the reaction volume that corresponds to the list of reference reverse primers specified for the sample.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},

		(* Multiplexed Reference Probes *)
		MultiplexedReferenceProbes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Link..|Null},
			Description -> "For each member of AssaySamples, the hydrolyzable oligomers with fluorescent labels that this experiment uses to quantify the amount of reference gene sequences.",
			Category -> "Reference Amplification",
			IndexMatching->AssaySamples
		},
		MultiplexedReferenceProbeResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Model[Sample],
			Description -> "The flattened list of the molecular probes that this experiment uses to quantify the amount of reference gene sequences.",
			Category -> "Reference Amplification",
			Developer -> True
		},
		MultiplexedReferenceProbeConcentrations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Nanomolar]..},
			Description -> "For each member of AssaySamples, the list of molarities for probes in the reaction that corresponds to the list of probes specified for the sample.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},
		MultiplexedReferenceProbeVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Microliter]..},
			Description -> "For each member of AssaySamples, the list of volumes for probes added to the reaction volume that corresponds to the list of reference probes specified for the sample.",
			Category -> "Reference Amplification",
			IndexMatching -> AssaySamples
		},
		MultiplexedReferenceProbeFluorophores -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LinkP[Model[Molecule]]..|Null},
			Description -> "For each member of AssaySamples, the fluorophore conjugated to each of the molecular probes that this experiment uses to quantify the amount of reference sequence(s).",
			Category -> "Reference Amplification",
			IndexMatching->AssaySamples
		},
		MultiplexedReferenceProbeExcitationWavelengths->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0*Nanometer]..},
			Description->"For each member of AssaySamples, the wavelengths of light used to excite the probes.",
			Category -> "Reference Amplification",
			IndexMatching->AssaySamples
		},
		MultiplexedReferenceProbeEmissionWavelengths->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0*Nanometer]..},
			Description->"For each member of AssaySamples, the wavelengths of light collected from the excited probes.",
			Category -> "Reference Amplification",
			IndexMatching->AssaySamples
		},

		(* MasterMix and Buffer *)
		MasterMixes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"For each member of AssaySamples, the master mix of polymerase, nucleobases, and buffer that this experiment uses to amplify target templates.",
			Category->"Sample Preparation",
			IndexMatching->AssaySamples
		},
		MasterMixConcentrationFactors->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[1],
			Description->"For each member of AssaySamples, the amount by which the MasterMixes must be diluted with Diluents in order to acheive 1x buffer concentration in the reaction mixture.",
			Category->"Sample Preparation",
			IndexMatching->AssaySamples
		},
		MasterMixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"For each member of AssaySamples, the portion of the ReactionVolume volume that is composed of MasterMix.",
			Category->"Sample Preparation",
			IndexMatching->AssaySamples
		},
		Diluents->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"For each member of AssaySamples, the stock solution added to the reaction, once all other components have been added, to reach ReactionVolume and to perform all dilutions during the setup of this protocol.",
			Category->"Sample Preparation",
			IndexMatching->AssaySamples
		},
		DiluentVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"For each member of AssaySamples, the portion of the reaction that is made up of diluent to reach the corresponding ReactionVolumes.",
			Category->"Sample Preparation",
			IndexMatching->AssaySamples
		},

		ReactionVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"For each member of AssaySamples, the total volume of the reaction including the sample, primers, probes, master mix and buffer.",
			Category->"Sample Preparation",
			IndexMatching->AssaySamples
		},

		(* Sample Loading *)
		SampleDilutionPlates->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Plate],Object[Container,Plate]],
			Description->"The plate to be used to generate AssaySamples with series of decreasing concentrations from SamplesIn.",
			Category -> "Sample Loading"
		},
		SampleMixingPlates->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Plate],Object[Container,Plate]],
			Description->"The plate to be used to mix AssaySamples with primers, probes, master mix and diluent, prior to loading the DropletCartridges.",
			Category -> "Sample Loading"
		},
		SampleMixingPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description -> "The set of instructions specifying the combination of samples, primers, probes, master mix, and diluent for ActiveWells, and PassiveWellBuffer and PassiveWellBufferDiluent for PassiveWells.",
			Category -> "Sample Loading"
		},
		SampleMixingManipulation->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation]|Object[Protocol,RoboticSamplePreparation],
			Description -> "The sample manipulation protocol used to combine samples with additives as generated from the execution of SampleMixingPrimitives.",
			Category -> "Sample Loading"
		},

		ActiveWells->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[WellP,{_Integer,WellP}],
			Description->"For each member of AssaySamples, the sample location in a DropletCartridge. Each specified value includes a plate index followed by well index. Up to 5 DropletCartridges may be assessed for each protocol.",
			Category->"Sample Loading",
			IndexMatching->AssaySamples
		},
		PassiveWells->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[WellP,{_Integer,WellP},None],
			Description->"The location of unused wells in a 16 unit section of a DropletCartridge. 16 units are processed for droplet generation in parallel and wells without samples are filled with a buffer that matches the viscosity of 1x master mix. No data is collected from these wells. Each specified value includes a plate index followed by well index.",
			Category->"Sample Loading"
		},
		PassiveWellBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The concentrated stock solution that will be used to fill each passive well.",
			Category->"Sample Loading"
		},
		PassiveWellBufferDiluent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The stock solution that will be added to dilute PassiveWellBuffer to 1x concentration prior to filling PassiveWells.",
			Category->"Sample Loading"
		},

		DropletCartridges->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Plate,DropletCartridge],Object[Container,Plate,DropletCartridge]],
			Description->"The integrated microfluidic plate to be used to perform digital PCR. Each microfluidic unit contains a sample well, channels for the sample, oil and vacuum lines to facilitate the formation of nanoliter size droplets and a well to collect the generated droplets.",
			Category -> "Sample Loading"
		},
		DropletCartridgePrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>RoboticSamplePreparationP,
			Description -> "The set of instructions specifying the transfer of reaction mixture from SampleMixingPlates to DropletCartridges.",
			Category -> "Sample Loading"
		},
		DropletCartridgeManipulation->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Protocol],
				Object[Notebook, Script]
			],
			Description -> "The sample manipulation protocol used to load the digital PCR cartridge generated from the execution of DropletCartridgePrimitives.",
			Category -> "Sample Loading"
		},
		LoadingVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"The volume of reaction mixture to be transferred from preparation container to a well of DropletCartridge.",
			Category->"Sample Loading"
		},

		DropletCartridgePlacements-> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of rules used to indicate the positions on the instrument in which containers will be stowed for processing.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},

		(* Storage conditions *)
		ForwardPrimerStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[SampleStorageTypeP,Disposal],
			Description->"For each member of AssaySamples, the storage conditions under which ForwardPrimers should be stored after their usage in the experiment.",
			Category->"Sample Storage",
			IndexMatching->AssaySamples
		},
		ReversePrimerStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[SampleStorageTypeP,Disposal],
			Description->"For each member of AssaySamples, the storage conditions under which ReversePrimers should be stored after their usage in the experiment.",
			Category->"Sample Storage",
			IndexMatching->AssaySamples
		},
		ProbeStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[SampleStorageTypeP,Disposal],
			Description->"For each member of AssaySamples, the storage conditions under which Probes should be stored after their usage in the experiment.",
			Category->"Sample Storage",
			IndexMatching->AssaySamples
		},
		ReferenceForwardPrimerStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[SampleStorageTypeP,Disposal],
			Description->"For each member of AssaySamples, the storage conditions under which ReferenceForwardPrimers should be stored after their usage in the experiment.",
			Category->"Sample Storage",
			IndexMatching->AssaySamples
		},
		ReferenceReversePrimerStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[SampleStorageTypeP,Disposal],
			Description->"For each member of AssaySamples, the storage conditions under which ReferenceReversePrimers should be stored after their usage in the experiment.",
			Category->"Sample Storage",
			IndexMatching->AssaySamples
		},
		ReferenceProbeStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[SampleStorageTypeP,Disposal],
			Description->"For each member of AssaySamples, the storage conditions under which ReferenceProbes should be stored after their usage in the experiment.",
			Category->"Sample Storage",
			IndexMatching->AssaySamples
		},

		MasterMixStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[SampleStorageTypeP,Disposal],
			Description->"For each member of AssaySamples, the storage condition under which MasterMixes should be stored after its usage in the experiment.",
			Category->"Sample Storage",
			IndexMatching->AssaySamples
		},

		(* Plate sealing*)
		PlateSealInstrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Instrument,PlateSealer],Object[Instrument,PlateSealer]],
			Description->"The instrument used to apply heat-seal digital PCR plates with foil prior to assay run.",
			Category->"Plate Seal"
		},
		PlateSealAdapter->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
			Description->"The rack used to secure DropletCartridges on the deck of PlateSealInstrument.",
			Category->"Plate Seal",
			Developer->True
		},
		PlateSealFoils->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item], Object[Item]],
			Description->"The pierceable membrane(s) that are used to seal digital PCR cartridge(s).",
			Category->"Plate Seal"
		},
		PlateSealTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The temperature used to heat the foil for sealing a plate.",
			Category->"Plate Seal"
		},
		PlateSealTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"The duration of time used for applying PlateSealTemperature to seal the digital PCR plate.",
			Category->"Plate Seal"
		},

		(* - Thermocycling values by AssaySamples - *)
		(* Reverse transcription *)
		ReverseTranscriptionTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of AssaySamples, the temperature at which the reverse transcriptase converts source RNA material into cDNA.",
			Category -> "Reverse Transcription",
			IndexMatching->AssaySamples
		},
		ReverseTranscriptionTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "For each member of AssaySamples, the time for which the reverse transcriptase is allowed to synthesis cDNA strands from their template RNA strands.",
			Category -> "Reverse Transcription",
			IndexMatching->AssaySamples
		},
		ReverseTranscriptionRampRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Celsius)/Second],
			Units -> Celsius/Second,
			Description -> "For each member of AssaySamples, the rate at which the temperature changes in degrees per second to bring the samples up to reverse transcription temperature.",
			Category -> "Reverse Transcription",
			IndexMatching->AssaySamples
		},

		(* Polymerase Activation *)
		ActivationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"For each member of AssaySamples, the length of time for which the sample is held at ActivationTemperature to remove the thermolabile conjugates inhibiting polymerase activity.",
			Category->"Polymerase Activation",
			IndexMatching->AssaySamples
		},
		ActivationTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of AssaySamples, the temperature to which the sample is heated to remove the thermolabile conjugates inhibiting polymerase activity.",
			Category->"Polymerase Activation",
			IndexMatching->AssaySamples
		},
		ActivationRampRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0 Celsius)/Second],
			Units->Celsius/Second,
			Description->"For each member of AssaySamples, the rate at which the sample is heated to reach ActivationTemperature.",
			Category->"Polymerase Activation",
			IndexMatching->AssaySamples
		},

		(* Denaturation *)
		DenaturationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"For each member of AssaySamples, the length of time for which the sample is held at DenaturationTemperature to allow the dissociation of the double stranded template into single strands.",
			Category->"Denaturation",
			IndexMatching->AssaySamples
		},
		DenaturationTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of AssaySamples, the temperature to which the sample is heated to allow the dissociation of the double stranded template into single strands.",
			Category->"Denaturation",
			IndexMatching->AssaySamples
		},
		DenaturationRampRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0 Celsius)/Second],
			Units->Celsius/Second,
			Description->"For each member of AssaySamples, the rate at which the sample is heated to reach DenaturationTemperature.",
			Category->"Denaturation",
			IndexMatching->AssaySamples
		},

		(* Primer Annealing *)
		PrimerAnnealingTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"For each member of AssaySamples, the length of time for which the sample is held at PrimerAnnealingTemperature to allow primers to bind to the template.",
			Category->"Primer Annealing",
			IndexMatching->AssaySamples
		},
		PrimerAnnealingTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of AssaySamples, the temperature to which the sample is cooled to allow primers to bind to the template.",
			Category->"Primer Annealing",
			IndexMatching->AssaySamples
		},
		PrimerAnnealingRampRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0 Celsius)/Second],
			Units->Celsius/Second,
			Description->"For each member of AssaySamples, the rate at which the sample is cooled to reach PrimerAnnealingTemperature.",
			Category->"Primer Annealing",
			IndexMatching->AssaySamples
		},

		(* Primer Gradient Annealing *)
		PrimerGradientAnnealingMinTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of AssaySamples, the lower value of the temperature range that will be used to calculate annealing temperature of each row.",
			Category->"Primer Gradient Annealing",
			IndexMatching->AssaySamples
		},
		PrimerGradientAnnealingMaxTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of AssaySamples, the upper value of the temperature range that will be used to calculate annealing temperature of each row.",
			Category->"Primer Gradient Annealing",
			IndexMatching->AssaySamples
		},
		PrimerGradientAnnealingRows->{
			Format->Multiple,
			Class->{String,Real},
			Pattern:>{_String,GreaterEqualP[0 Celsius]},
			Units->{None,Celsius},
			Description->"For each member of AssaySamples, the row & temperature specification that is used to position the sample on DropletCartridge when annealing is performed with a temperature gradient.",
			Headers->{"Row","Temperature"},
			Category->"Primer Gradient Annealing",
			IndexMatching->AssaySamples
		},

		(* Strand Extension *)
		ExtensionTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"For each member of AssaySamples, the length of time for which sample is held at ExtensionTemperature to allow the polymerase to synthesize a new strand using the template and primers.",
			Category->"Strand Extension",
			IndexMatching->AssaySamples
		},
		ExtensionTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of AssaySamples, the temperature to which the sample is heated/cooled to allow the polymerase to synthesize a new strand using the template and primers.",
			Category->"Strand Extension",
			IndexMatching->AssaySamples
		},
		ExtensionRampRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0 Celsius)/Second],
			Units->Celsius/Second,
			Description->"For each member of AssaySamples, the rate at which the sample is heated/cooled to reach ExtensionTemperature.",
			Category->"Strand Extension",
			IndexMatching->AssaySamples
		},

		(* Cycling *)
		NumberOfCycles->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0.,1],
			Units->None,
			Description->"For each member of AssaySamples, the number of times the sample undergoes repeated cycles of denaturation, primer annealing (optional), and strand extension.",
			Category->"Cycling",
			IndexMatching->AssaySamples
		},

		(* Final Extension *)
		PolymeraseDegradationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"For each member of AssaySamples, the length of time for which the sample is held at PolymeraseDegradationTemperatures.",
			Category->"Polymerase Degradation",
			IndexMatching->AssaySamples
		},
		PolymeraseDegradationTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of AssaySamples, the temperature to which the sample is heated to degrade the polymerase.",
			Category->"Polymerase Degradation",
			IndexMatching->AssaySamples
		},
		PolymeraseDegradationRampRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0 Celsius)/Second],
			Units->Celsius/Second,
			Description->"For each member of AssaySamples, the rate at which the sample is heated PolymeraseDegradationTemperatures.",
			Category->"Polymerase Degradation",
			IndexMatching->AssaySamples
		},

		(* - Thermocycling fields index-matched to plate for use in procedure - *)
		(* Reverse transcription *)
		CartridgeReverseTranscriptionTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of DropletCartridges, the temperature at which the reverse transcriptase converts source RNA material into cDNA.",
			Category -> "Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgeReverseTranscriptionTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "For each member of DropletCartridges, the duration for which the reverse transcriptase is allowed to synthesis cDNA strands from their template RNA strands.",
			Category -> "Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgeReverseTranscriptionTimeStrings -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of DropletCartridges, duration for reverse transcription converted into text format as Hour:Minute:Second.",
			Category -> "Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgeReverseTranscriptionRampRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Celsius)/Second],
			Units -> Celsius/Second,
			Description -> "For each member of DropletCartridges, the rate at which the temperature changes in degrees per second to bring the samples up to reverse transcription temperature.",
			Category -> "Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},

		(* Polymerase Activation *)
		CartridgeActivationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"For each member of DropletCartridges, the duration for which the sample is held at ActivationTemperature to remove the thermolabile conjugates inhibiting polymerase activity.",
			Category -> "Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgeActivationTimeStrings->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of DropletCartridges, duration for activation converted into text format as Hour:Minute:Second.",
			Category -> "Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgeActivationTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of DropletCartridges, the temperature to which the sample is heated to remove the thermolabile conjugates inhibiting polymerase activity.",
			Category -> "Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgeActivationRampRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0 Celsius)/Second],
			Units->Celsius/Second,
			Description->"For each member of DropletCartridges, the rate at which the sample is heated to reach ActivationTemperature.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},

		(* Denaturation *)
		CartridgeDenaturationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"For each member of DropletCartridges, the duration for which the sample is held at DenaturationTemperature to allow the dissociation of the double stranded template into single strands.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgeDenaturationTimeStrings->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of DropletCartridges, duration for denaturation converted into text format as Hour:Minute:Second.",
			Category -> "Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgeDenaturationTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of DropletCartridges, the temperature to which the sample is heated to allow the dissociation of the double stranded template into single strands.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgeDenaturationRampRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0 Celsius)/Second],
			Units->Celsius/Second,
			Description->"For each member of DropletCartridges, the rate at which the sample is heated to reach DenaturationTemperature.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},

		(* Primer Annealing *)
		CartridgePrimerAnnealingTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"For each member of DropletCartridges, the duration for which the sample is held at PrimerAnnealingTemperature to allow primers to bind to the template.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgePrimerAnnealingTimeStrings->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of DropletCartridges, duration for annealing converted into text format as Hour:Minute:Second.",
			Category -> "Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgePrimerAnnealingTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of DropletCartridges, the temperature to which the sample is cooled to allow primers to bind to the template.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgePrimerAnnealingRampRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0 Celsius)/Second],
			Units->Celsius/Second,
			Description->"For each member of DropletCartridges, the rate at which the sample is cooled to reach PrimerAnnealingTemperature.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},

		(* Primer Gradient Annealing *)
		CartridgePrimerGradientAnnealingMinTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of DropletCartridges, the lower value of the temperature range that will be used to calculate annealing temperature of each row.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgePrimerGradientAnnealingRanges->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of DropletCartridges, the span of temperature calculated by taking the difference between the maximum and minimum values of temperature to be used for gradient annealing step.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},

		(* Strand Extension *)
		CartridgeExtensionTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"For each member of DropletCartridges, the duration for which sample is held at ExtensionTemperature to allow the polymerase to synthesize a new strand using the template and primers.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgeExtensionTimeStrings->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of DropletCartridges, duration for extension converted into text format as Hour:Minute:Second.",
			Category -> "Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgeExtensionTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of DropletCartridges, the temperature to which the sample is heated/cooled to allow the polymerase to synthesize a new strand using the template and primers.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgeExtensionRampRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0 Celsius)/Second],
			Units->Celsius/Second,
			Description->"For each member of DropletCartridges, the rate at which the sample is heated/cooled to reach ExtensionTemperature.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},

		(* Cycling *)
		CartridgeNumberOfCycles->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0.,1],
			Units->None,
			Description->"For each member of DropletCartridges, the number of times the sample undergoes repeated cycles of denaturation, primer annealing (optional), and strand extension.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},

		(* Final Extension *)
		CartridgePolymeraseDegradationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"For each member of DropletCartridges, the duration for which the sample is held at PolymeraseDegradationTemperatures.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgePolymeraseDegradationTimeStrings->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of DropletCartridges, duration for polymerase degradation converted into text format as Hour:Minute:Second.",
			Category -> "Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgePolymeraseDegradationTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of DropletCartridges, the temperature to which the sample is heated to degrade the polymerase.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},
		CartridgePolymeraseDegradationRampRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0 Celsius)/Second],
			Units->Celsius/Second,
			Description->"For each member of DropletCartridges, the rate at which the sample is heated PolymeraseDegradationTemperatures.",
			Category->"Cycle Parameters",
			IndexMatching -> DropletCartridges,
			Developer -> True
		},

		InstrumentDataFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path on the instrument computer in which the data generated by the experiment is stored locally.",
			Category -> "Data Processing",
			Developer -> True
		},
		DataTransferFile->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path and name of the .bat file which transfers data to the public drive at the conclusion of the experiment.",
			Category -> "Data Processing",
			Developer -> True
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The name of the directory where the data files are stored at the conclusion of the experiment.",
			Category -> "Data Processing",
			Developer -> True
		},
		DataFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The files containing the raw unprocessed data generated by the instrument during a DigitalPCR run.",
			Category -> "Experimental Results"
		},

		DilutionSeriesData -> {
			Format -> Multiple,
			Class -> {
				Link,
				Real,
				Link,
				Link
			},
			Pattern :> {
				_Link,
				_Real,
				_Link,
				_Link
			},
			Relation -> {
				Object[Sample],
				Null,
				Object[Sample],
				Object[Data]
			},
			Headers -> {
				"Input Sample",
				"Dilution Factor",
				"Dilute Sample",
				"Data"
			},
			Description -> "For input samples that are diluted, the factors by which sample concentration is decreased, the resulting diluted samples and corresponding DigitalPCR data.",
			Category -> "Experimental Results"
		},

		(* Temporary fields for workaround - data will be transferred to VM that has new software *)
		VMDataFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The local file path on the virtual computer in which the data file should be transferred for exporting.",
			Category -> "Data Processing",
			Developer -> True
		},
		TransferToVMFile->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path and name of the .bat file which transfers data from the public drive to virtual computer for data export.",
			Category -> "Data Processing",
			Developer -> True
		},
		TransferFromVMFile->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path and name of the .bat file which transfers data to the public drive from virtual computer after data export.",
			Category -> "Data Processing",
			Developer -> True
		}

		(*
		DataFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the data files transferred to the DataFilePath.",
			Category -> "Data Processing",
			Developer -> True
		}*)

		(*
		SampleProcessSteps->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[DropletGeneration,Thermocycling,DropletReading],
			Description->"For each member of AssaySamples, the phase that should be completed prior to sample extraction. A typical experiment involves three sequential phases of DropletGeneration, Thermocycling and DropletReading. Samples can be extracted from DropletCartridge after DropletGeneration or Thermocycling. It is critical to note that sample extraction destroys the DropletCartridge and the extracted samples cannot be used for ExperimentDigitalPCR.",
			Category->"Sample Storage",
			IndexMatching->AssaySamples
		},
		ContainerOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Plate],Object[Container,Plate]],
			Description->"The desired container generated samples should be extracted into after DropletGeneration or Thermocycling phases.",
			Category->"Sample Storage"
		}
		*)

	}
}];