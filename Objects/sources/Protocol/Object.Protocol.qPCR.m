(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,qPCR],{
	Description->"A protocol for quantifying nucleic acids using a polymerase chain reaction in conjunction with fluorescence readouts.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Instrument],Object[Instrument]],
			Description->"The instrument used to rapidly cycle temperatures and record fluorescence emitted by dyes or probes.",
			Category -> "General"
		},
		RunTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Minute,
			Description->"The length of time for which the thermal cycler is expected to run given the specified parameters.",
			Category -> "General"
		},
		ReactionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Liter Milli,
			Description-> "The total volume of the reaction including the sample, primers, probes, dyes, master mix and buffer.",
			Category -> "General"
		},
		MasterMix->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The master mixes of polymerase, nucleobases, and buffer that this experiment uses to amplify target oligomers.",
			Category -> "General"
		},
		MasterMixVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Liter Milli,
			Description->"The portion of the ReactionVolume volume that is composed of MasterMix.",
			Category -> "General"
		},
		Buffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The sample used to bring each reaction to its ReactionVolume once all other components have been added and to perform all dilutions during the setup of this protocol.",
			Category -> "General"
		},
		MethodFileName->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The name of the protocol file containing the run parameters.",
			Category -> "General",
			Developer->True
		},
		MethodFilePath->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The full file path of the method file used to run this qPCR experiment.",
			Category -> "General",
			Developer->True
		},


		AssayPlate->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The 384-well qPCR plate that will be loaded with samples, primers, probes, dyes, master mix and buffer.",
			Category->"Sample Loading"
		},
		PlateSeal->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item],Object[Item]],
			Description->"The optically transparent self-adhesive seal used to cover the assay plate wells during thermal cycling.",
			Category->"Sample Loading"
		},
		AssayPlatePrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description->"The set of instructions specifying the loading of a qPCR plate with samples, primers, probes, dyes, master mix and buffer.",
			Category->"Sample Loading"
		},
		AssayPlateManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation],
			Description->"The sample manipulation protocol used to load the qPCR plate generated as a result of execution of AssayPlatePrimitives.",
			Category->"Sample Loading"
		},
		AssayPlateThermalBlock->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Part],Object[Part]],
			Description->"The thermal cycling block for the 384-well plate.",
			Category->"Sample Loading",
			Developer->True
		},
		AssayPlateTray->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The thermal cycling tray that holds the 384-well plate.",
			Category->"Sample Loading",
			Developer->True
		},


		ArrayCardPreparatoryPlate->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The 96-well PCR plate for the preparation of reaction mixtures consisting of samples, master mix, and buffer.",
			Category->"Sample Loading"
		},
		ArrayCardPreparatoryPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description->"The set of instructions specifying the preparation of reaction mixtures consisting of samples, master mix, and buffer.",
			Category->"Sample Loading"
		},
		ArrayCardPreparatoryManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation],
			Description->"The robotic sample manipulation protocol generated as a result of the execution of ArrayCardPreparatoryPrimitives.",
			Category->"Sample Loading"
		},
		ArrayCard->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The input array card containing pre-dried primers and probes that will be loaded with reaction mixtures.",
			Category->"Sample Loading"
		},
		ArrayCardLoadingPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SamplePreparationP,
			Description->"The set of instructions specifying the loading of the array card with reaction mixtures and the subsequent centrifugation.",
			Category->"Sample Loading"
		},
		ArrayCardLoadingManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,ManualSamplePreparation],
			Description->"The manual sample preparation protocol generated as a result of the execution of ArrayCardLoadingPrimitives.",
			Category->"Sample Loading"
		},
		ArrayCardSealer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Part],Object[Part]],
			Description->"The tool used to seal the microfluidic channels on the array card.",
			Category->"Sample Loading",
			Developer->True
		},
		ArrayCardThermalBlock->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Part],Object[Part]],
			Description->"The thermal cycling block for the array card.",
			Category->"Sample Loading",
			Developer->True
		},
		ArrayCardTray->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The thermal cycling tray that holds the array card.",
			Category->"Sample Loading",
			Developer->True
		},


		SampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Liter Milli,
			Description->"For each member of SamplesIn, the portion of the reaction that is made up of the sample.",
			Category->"Sample Loading",
			IndexMatching->SamplesIn
		},
		BufferVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Liter Milli,
			Description->"For each member of SamplesIn, the portion of the reaction that is made up of any additional buffer not already part of the master mix.",
			Category->"Sample Loading",
			IndexMatching->SamplesIn
		},	
		
		MoatVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The volume which each moat is filled with in order to slow evaporation of inner assay samples.",
			Category->"Sample Loading"
		},
		MoatBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The sample each moat well is filled with in order to slow evaporation of inner assay samples.",
			Category->"Sample Loading"
		},
		MoatSize->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Units->None,
			Description->"The depth the moat extends into the assay plate.",
			Category->"Sample Loading"
		},
		
		DuplexStainingDye->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample],Model[Molecule]],
			Description->"The fluorescence dye that intercalates into double stranded DNA and emits fluorescent light when excited with the appropriate wavelength of light.",
			Category->"Dye Assay"
		},
		DuplexStainingDyeVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Liter Milli,
			Description-> "The portion of the reaction volume that is made up of any additional duplex staining dye not already part of the master mix.",
			Category->"Dye Assay"
		},
		DuplexStainingDyeExcitationWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nano*Meter],
			Units->Meter Nano,
			Description-> "The wavelengths of light used to excite the duplex staining dye.",
			Category->"Dye Assay"
		},
		DuplexStainingDyeEmissionWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nano*Meter],
			Units->Meter Nano,
			Description-> "The wavelength of light collected from the excited duplex staining dye.",
			Category->"Dye Assay"
		},
		
		ForwardPrimers->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{_Link..},
			Description->"For each member of SamplesIn, the forward primers that this experiment uses to amplify a target sequence from the sample.",
			Category->"Target Amplification",
			IndexMatching->SamplesIn
		},
		ReversePrimers->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{_Link..},
			Description->"For each member of SamplesIn, the reverse primers that this experiment uses to amplify a target sequence from the sample.",
			Category->"Target Amplification",
			IndexMatching->SamplesIn
		},
		ForwardPrimerVolumes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{GreaterEqualP[0 Milliliter]..},
			Description->"For each member of SamplesIn, the volume of primer mix added to the reaction volume.",
			Category->"Target Amplification",
			IndexMatching->SamplesIn
		},
		ReversePrimerVolumes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{GreaterEqualP[0 Milliliter]..},
			Description->"For each member of SamplesIn, the volume of primer mix added to the reaction volume.",
			Category->"Target Amplification",
			IndexMatching->SamplesIn
		},
		ForwardPrimerResources->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample] | Model[Sample],
			Description->"The flattened list of the reverse primers that this experiment uses to amplify the primary target from the sample.",
			Category->"Target Amplification"
		},
		ReversePrimerResources->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample] | Model[Sample],
			Description->"The flattened list of the reverse primers that this experiment uses to amplify the primary target from the sample.",
			Category->"Target Amplification"
		},

		(* Probe-related fields *)
		Probes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{LinkP[{Object[Sample],Model[Sample]}]..},
			Description->"For each member of SamplesIn, the molecular probe(s) that this experiment uses to quantify the amount of target sequence.",
			Category->"Probe Assay",
			IndexMatching->SamplesIn
		},
		ProbeResources->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample] | Model[Sample],
			Description->"The flattened list of the probes that this experiment uses to quantify the amount of target sequence.",
			Category->"Probe Assay"
		},
		ProbeVolumes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{GreaterEqualP[0 Milliliter]..},
			Description->"For each member of SamplesIn, the volume of probe added to the reaction volume.",
			Category->"Probe Assay"
		},
		(* No ProbeFluorophoreResources field because we don't need to resource pick these *)
		ProbeFluorophores->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{LinkP[Model[Molecule]]..},
			Description->"For each member of SamplesIn, the fluorophore conjugated to each of the molecular probe(s) that this experiment uses to quantify the amount of target sequence.",
			Category->"Probe Assay",
			IndexMatching->SamplesIn
		},
		ProbeExcitationWavelengths->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{GreaterEqualP[0*Nanometer]..},
			Description->"For each member of SamplesIn, the wavelengths of light used to excite the probes.",
			Category->"Probe Assay",
			IndexMatching->SamplesIn
		},
		ProbeEmissionWavelengths->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{GreaterEqualP[0*Nanometer]..},
			Description->"For each member of SamplesIn, the wavelengths of light collected from the excited probes.",
			Category->"Probe Assay",
			IndexMatching->SamplesIn
		},

		ReferenceDye->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample],Model[Molecule]],
			Description->"The passive fluorescence reference dye this protocol uses to normalize fluorescence background fluctuations during quantification.",
			Category->"Passive Control"
		},
		ReferenceDyeVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Liter Milli,
			Description-> "The portion of the reaction volume that is made up of any additional duplex staining dye not already part of the master mix.",
			Category->"Passive Control"
		},
		ReferenceDyeExcitationWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nano*Meter],
			Units->Meter Nano,
			Description-> "The wavelengths of light used to excite the reference staining dye.",
			Category->"Passive Control"
		},
		ReferenceDyeEmissionWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nano*Meter],
			Units->Meter Nano,
			Description-> "The wavelength of light collected from the excited reference staining dye.",
			Category->"Passive Control"
		},

		(* Only one endogenous control primer set is allowed per sample well, so these can be normal, flat multiples *)
		EndogenousForwardPrimers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"For each member of SamplesIn, the forward primers that this experiment uses to amplify an endogenous control target from the sample.",
			Category->"Endogenous Control",
			IndexMatching->SamplesIn
		},
		EndogenousReversePrimers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"For each member of SamplesIn, the forward primers that this experiment uses to amplify an endogenous control target from the sample.",
			Category->"Endogenous Control",
			IndexMatching->SamplesIn
		},
		EndogenousForwardPrimerVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the volume of endogenous control forward primer added to the reaction volume.",
			Category->"Endogenous Control",
			IndexMatching->SamplesIn
		},
		EndogenousReversePrimerVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the volume of endogenous control forward primer added to the reaction volume.",
			Category->"Endogenous Control",
			IndexMatching->SamplesIn
		},
		EndogenousProbes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"For each member of SamplesIn, the molecular probe that this experiment uses to quantify the amount of endogenous target sequence.",
			Category->"Endogenous Control",
			IndexMatching->SamplesIn
		},
		EndogenousProbeVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the volume of endogenous probe mix added to the reaction volume.",
			Category->"Endogenous Control",
			IndexMatching->SamplesIn
		},
		EndogenousProbeFluorophores->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Molecule],
			Description->"For each member of SamplesIn, the fluorophore conjugated to the molecular probe that this experiment uses to quantify the amount of endogenous control target sequence.",
			Category->"Endogenous Control",
			IndexMatching->SamplesIn
		},
		EndogenousProbeExcitationWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nano*Meter],
			Units->Meter Nano,
			Description->"For each member of SamplesIn, the wavelength of light used to excite the endogenous probe (if any).",
			Category->"Endogenous Control",
			IndexMatching->SamplesIn
		},
		EndogenousProbeEmissionWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nano*Meter],
			Units->Meter Nano,
			Description->"For each member of SamplesIn, the wavelength of light collected from the excited endogenous probe (if any).",
			Category->"Endogenous Control",
			IndexMatching->SamplesIn
		},

		(* Storage condition related fields *)
		ForwardPrimerStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{SampleStorageTypeP|Disposal..},
			Description->"For each member of SamplesIn, the storage conditions under which the forward primers should be stored after their usage in this experiment.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		ReversePrimerStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{SampleStorageTypeP|Disposal..},
			Description->"For each member of SamplesIn, the storage conditions under which the reverse primers should be stored after their usage in this experiment.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		ProbeStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{SampleStorageTypeP|Disposal..},
			Description->"For each member of SamplesIn, the storage conditions under which the probes should be stored after their usage in this experiment.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		StandardStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"For each member of Standards, the storage conditions under which the standards should be stored after their usage in this experiment.",
			Category->"Sample Storage",
			IndexMatching->Standards
		},
		StandardForwardPrimerStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"For each member of Standards, the storage conditions under which the forward primers for the standards should be stored after their usage in this experiment.",
			Category->"Sample Storage",
			IndexMatching->Standards
		},
		StandardReversePrimerStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"For each member of Standards, the storage conditions under which the reverse primers for the standards should be stored after their usage in this experiment.",
			Category->"Sample Storage",
			IndexMatching->Standards
		},
		StandardProbeStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"For each member of Standards, the storage conditions under which the probes for the standards should be stored after their usage in this experiment.",
			Category->"Sample Storage",
			IndexMatching->Standards
		},
		EndogenousForwardPrimerStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"For each member of SamplesIn, the storage conditions under which the endogenous forward primers should be stored after their usage in this experiment.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		EndogenousReversePrimerStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"For each member of SamplesIn, the storage conditions under which the endogenous reverse primers should be stored after their usage in this experiment.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		EndogenousProbeStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"For each member of SamplesIn, the storage conditions under which the probes for the endogenous probes should be stored after their usage in this experiment.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		MasterMixStorageCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"The storage conditions under which the master mix should be stored after their usage in this experiment.",
			Category->"Sample Storage"
		},
		AssayPlateStorageCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"The storage conditions under which the thermocycled assay plate should be stored after its usage in this experiment.",
			Category->"Sample Storage"
		},
		ArrayCardStorageCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"The storage conditions under which the thermocycled array card should be stored after its usage in this experiment.",
			Category->"Sample Storage"
		},

		ReverseTranscription->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if a one-step reverse transcription is performed in order to convert RNA input samples to cDNA.",
			Category->"Reverse Transcription"
		},
		ReverseTranscriptionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature at which the reverse transcriptase converts source RNA material into cDNA.",
			Category->"Reverse Transcription"
		},
		ReverseTranscriptionTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The time for which the reverse transcriptase is allowed to synthesis cDNA strands from their template RNA strands.",
			Category->"Reverse Transcription"
		},
		ReverseTranscriptionRampRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[(0*Celsius)/Second],
			Units->Celsius/Second,
			Description->"The rate at which the temperature changes in degrees per second when bringing the samples up to reverse transcription temperature.",
			Category->"Reverse Transcription"
		},


		Activation->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if hot start activation of the reaction is performed in order to remove thermolabile inhibiting conjugates from the polymerases.",
			Category->"Polymerase Activation"
		},
		ActivationTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature of the initial activation step used to denature the strands in the reaction and to activate the polymerase.",
			Category->"Polymerase Activation"
		},
		ActivationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The time of the initial activation step used to denature the strands in the reaction and to activate the polymerase.",
			Category->"Polymerase Activation"
		},
		ActivationRampRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[(0*Celsius)/Second],
			Units->Celsius/Second,
			Description->"The rate at which the temperature changes in degrees per second between when bringing the samples down to activation temperature.",
			Category->"Polymerase Activation"
		},


		DenaturationTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature used to denature all strands in the reaction in the first stage of the PCR cycle.",
			Category->"Denaturation"
		},
		DenaturationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The time used to denature all strands in the reaction in the first stage of the PCR cycle.",
			Category->"Denaturation"
		},
		DenaturationRampRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[(0*Celsius)/Second],
			Units->Celsius/Second,
			Description->"The rate at which the temperature changes in degrees per second when bringing the samples up to denaturation temperature.",
			Category->"Denaturation"
		},

		PrimerAnnealing->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if primer annealing is performed as a separate step from strand extension.",
			Category->"Annealing"
		},
		PrimerAnnealingTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature at which primers and probe are bound to the target strands for amplification in the second stage of the PCR cycle.",
			Category->"Annealing"
		},
		PrimerAnnealingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The time for which the primers and probe are allowed to bind to the target strands for amplification in the second stage of the PCR cycle.",
			Category->"Annealing"
		},
		PrimerAnnealingRampRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[(0*Celsius)/Second],
			Units->Celsius/Second,
			Description->"The rate at which the temperature changes in degrees per second when bringing the samples up to annealing temperature.",
			Category->"Annealing"
		},

		ExtensionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature at which the polymerase extends the newly amplified strand from the annealed primers in the third stage of the PCR cycle.",
			Category->"Extension"
		},
		ExtensionTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The time for which the polymerase is allowed to extend the newly amplified strand from the annealed primers in the third stage of the PCR cycle.",
			Category->"Extension"
		},
		ExtensionRampRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[(0*Celsius)/Second],
			Units->Celsius/Second,
			Description->"The rate at which the temperature changes in degrees per second between when brining the samples up to extension temperature.",
			Category->"Extension"
		},

		NumberOfCycles->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Units->None,
			Description->"The number of cycles of denaturation, annealing, and extension to perform.",
			Category->"Extension"
		},

		MeltingCurve->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if a melting curved should be created at the end of the experiment by recording the fluorescene of each sample while slowly dissasociating the strands.",
			Category->"Melting Curve"
		},
		MeltingCurveTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Minute,
			Description->"The length of time it should take to change the temperature from the MeltingCurveStartTemperature to MeltingCurveEndTemperature.",
			Category->"Melting Curve"
		},
		MeltingCurveStartTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature at which the samples should be before starting the melting curve.",
			Category->"Melting Curve"
		},
		MeltingCurveEndTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature, which when reached, should end the melting curve.",
			Category->"Melting Curve"
		},
		PreMeltingCurveRampRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[(0*Celsius)/Second],
			Units->Celsius/Second,
			Description->"The rate at which the temperature changes in degrees per second between the end of amplification and start of the melting curve.",
			Category->"Melting Curve"
		},
		MeltingCurveRampRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[(0*Celsius)/Second],
			Units->Celsius/Second,
			Description->"The rate at which the temperature changes in degrees per second between the start and end of the melting curve.",
			Category->"Melting Curve"
		},


		StandardVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Liter Milli,
			Description->"The portion of each standard curve reaction volume that is made up of the standard sample.",
			Category->"Standard Curve"
		},
		Standards->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The samples used to constructed a fitted line to determine absolute or relative amounts of unknown sample.",
			Category->"Standard Curve"
		},
		StandardConcentrations->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{ConcentrationP..},
			Description->"For each member of Standards, the concentration of each step in the serial dilution if the concentration of the starting sample is known.",
			Category->"Standard Curve",
			IndexMatching->Standards
		},
		SerialDilutionFactors->{
			Format->Multiple,
			Class->Real,
			(* SerialDilutionFactors < 1 is nonsensical -- we can't serially concentrate the standard *)
			Pattern:>GreaterP[1],
			Units->None,
			Description->"For each member of Standards, the factor by which each subsequent sample in the serial dilution should be diluted.",
			Category->"Standard Curve",
			IndexMatching->Standards
		},
		NumberOfDilutions->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Units->None,
			Description->"For each member of Standards, the number of serial dilutions in the whole series, including the initial (undiluted) standard sample.",
			Category->"Standard Curve",
			IndexMatching->Standards
		},
		NumberOfStandardReplicates->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Units->None,
			Description->"For each member of Standards, the number of times the standard curve should be replicated.",
			Category->"Standard Curve",
			IndexMatching->Standards
		},

		(* No multiplexing for standards -- only one primer pair for each, detectable by either duplex dye or probe *)
		StandardForwardPrimers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"For each member of Standards, the forward primer that this experiment uses to amplify the standard target sequence from the sample.",
			Category->"Standard Curve",
			IndexMatching->Standards
		},
		StandardReversePrimers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"For each member of Standards, the reverse primer that this experiment uses to amplify the standard target sequence from the sample.",
			Category->"Standard Curve",
			IndexMatching->Standards
		},
		StandardForwardPrimerVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"For each member of Standards, the volume of forward primer added to the reaction volume.",
			Category->"Standard Curve",
			IndexMatching->Standards
		},
		StandardReversePrimerVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"For each member of Standards, the volume of reverse primer added to the reaction volume.",
			Category->"Standard Curve",
			IndexMatching->Standards
		},

		StandardProbes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"For each member of Standards, the molecular probe that this experiment uses to quantify the amount of standard target sequence.",
			Category->"Standard Curve",
			IndexMatching->Standards
		},
		StandardProbeVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"For each member of Standards, the volume of standard probe added to the reaction volume.",
			Category->"Standard Curve",
			IndexMatching->Standards
		},
		StandardProbeFluorophores->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Molecule],
			Description->"For each member of Standards, the fluorophore conjugated to the molecular probe that this experiment uses to quantify the amount of standard target sequence.",
			Category->"Standard Curve",
			IndexMatching->Standards
		},
		StandardProbeExcitationWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nano*Meter],
			Units->Meter Nano,
			Description->"For each member of Standards, the wavelengths of light used to excite the standard probes.",
			Category->"Standard Curve",
			IndexMatching->Standards
		},
		StandardProbeEmissionWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nano*Meter],
			Units->Meter Nano,
			Description->"For each member of Standards, the wavelength of light collected from the excited standard probes.",
			Category->"Standard Curve",
			IndexMatching->Standards
		},

		
		StandardData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The standard curve data generated as a part of this experiment.",
			Category->"Experimental Results"
		},
		BlankData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The no-template control data generated as a part of this experiment.",
			Category->"Experimental Results"
		},
		MethodFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The file containing parameters dictating how the instrument should perform the qPCR run.",
			Category->"Experimental Results"
		},
		DataFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The file containing data collected during the qPCR run.",
			Category->"Experimental Results"
		},
		QuantificationCycleAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis,QuantificationCycle][Protocol],
			Description->"The analysis object(s) containing the quantification cycle calculation results.",
			Category->"Analysis & Reports"
		},
		CopyNumberAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis,CopyNumber][Protocol],
			Description->"The analysis object(s) containing the copy number calculation results. Each copy number is determined from a standard curve of quantification cycle vs Log10 copy number.",
			Category->"Analysis & Reports"
		}

	}
}]
