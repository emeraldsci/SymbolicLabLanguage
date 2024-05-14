(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,RoboticCOVID19Test],{
	Description->"A protocol for running robotic coronavirus disease 2019 (COVID-19) tests on the specimens.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*===RNA Extraction===*)
		BiosafetyCabinet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Instrument],Object[Instrument]],
			Description->"The biosafety cabinet instrument in which the specimens are lysed.",
			Category->"RNA Extraction"
		},
		Disinfectant->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The freshly prepared bleach solution for disinfecting the unused specimens.",
			Category->"RNA Extraction"
		},
		RNAExtractionPlate->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Plate],Object[Container,Plate]],
			Description->"The plate in which viral RNA from the lysed specimens is extracted.",
			Category->"RNA Extraction"
		},
		LysisMasterMix->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The freshly prepared solution for lysing the specimens.",
			Category->"RNA Extraction"
		},
		SalivaPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ManualSamplePreparationP,
			Description->"The set of instructions specifying transfer of the specimens into a plate for futher workup.",
			Category->"RNA Extraction"
		},
		SalivaManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Protocol],
				Object[Notebook, Script]
			],
			Description->"The sample preparation protocol generated as a result of the execution of TestSamplePrimitives.",
			Category->"RNA Extraction"
		},
		LysisPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>RoboticSamplePreparationP,
			Description->"The set of instructions specifying the manual lysis of the specimens.",
			Category->"RNA Extraction"
		},
		LysisManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Protocol],
				Object[Notebook, Script]
			],
			Description->"The sample preparation protocol generated as a result of the execution of LysisPrimitives.",
			Category->"RNA Extraction"
		},
		MagneticBeads(*request in a well in a uv star plate so it can be shaken on deck prior to aliquoting*)->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The magnetic beads for extracting the viral RNA from the lysed specimens.",
			Category->"RNA Extraction"
		},
		ProteaseSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The enzyme solution for digesting the proteins.",
			Category->"RNA Extraction"
		},
		PrimaryWashSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The first solution for removing the sample impurities.",
			Category->"RNA Extraction"
		},
		SecondaryWashSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The second solution for removing the sample impurities.",
			Category->"RNA Extraction"
		},
		WasteReservoir->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Plate],Object[Container,Plate]],
			Description->"The robotic reservoir for collecting RNA extraction waste.",
			Category->"RNA Extraction"
		},
		ElutionSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The solution for eluting the viral RNA off the magnetic beads.",
			Category->"RNA Extraction"
		},
		ElutionPlate->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Plate],Object[Container,Plate]],
			Description->"The plate that holds the extracted viral RNA samples for testing via reverse transcription quantitative polymerase chain reaction (RT-qPCR).",
			Category->"RNA Extraction"
		},
		RNAExtractionPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description->"The set of instructions specifying the robotic extraction of the viral RNA from the lysed samples.",
			Category->"RNA Extraction"
		},
		RNAExtractionManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation],
			Description->"The sample manipulation protocol generated as a result of the execution of RNAExtractionPrimitives.",
			Category->"RNA Extraction"
		},


		(*===RT-qPCR===*)
		PortableCooler->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Instrument],Object[Instrument]],
			Description->"The portable instrument for keeping samples chilled.",
			Category->"RNA Extraction"
		},
		ReactionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Milliliter,
			Description-> "The total volume of the reaction including the sample, primers, master mix, and buffer.",
			Category->"RT-qPCR"
		},
		NoTemplateControl->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The solvent sample that serves as the negative amplification control for reverse transcription quantitative polymerase chain reaction (RT-qPCR).",
			Category->"RT-qPCR"
		},
		ViralRNAControl->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2) RNA sample that serves as the positive amplification control for reverse transcription quantitative polymerase chain reaction (RT-qPCR).",
			Category->"RT-qPCR"
		},
		TestSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of SamplesIn, the purified viral RNA sample for testing via reverse transcription quantitative polymerase chain reaction (RT-qPCR).",
			Category->"RT-qPCR",
			IndexMatching->SamplesIn
		},
		qPCRTemplates->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The expanded NoTemplateControl, ViralRNAControl, and TestSamples for reverse transcription quantitative polymerase chain reaction (RT-qPCR).",
			Category->"RT-qPCR",
			Developer->True
		},
		SampleVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Milliliter,
			Description->"The volume of the RNA or control sample added to the reaction.",
			Category->"RT-qPCR"
		},

		(*Primers and Probes*)
		ForwardPrimers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The primers that bind the target sequences on the antisense strand of the complementary DNA (cDNA) template.",
			Category->"RT-qPCR"
		},
		ForwardPrimerVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Milliliter,
			Description->"The forward primer volume added to the reaction.",
			Category->"RT-qPCR"
		},
		ReversePrimers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The primers that bind the target sequences on the sense strand of the complementary DNA (cDNA) template.",
			Category->"RT-qPCR"
		},
		ReversePrimerVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Milliliter,
			Description->"The reverse primer volume added to the reaction.",
			Category->"RT-qPCR"
		},
		qPCRPrimerPairs->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{{_Link,_Link}},
			Description->"For each member of qPCRTemplates, the primer pair for reverse transcription quantitative polymerase chain reaction (RT-qPCR).",
			Category->"RT-qPCR",
			IndexMatching->qPCRTemplates,
			Developer->True
		},
		Probes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The molecular probes for quantifying the target sequences.",
			Category->"RT-qPCR"
		},
		ProbeVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Milliliter,
			Description->"The probe volume added to the reaction.",
			Category->"RT-qPCR"
		},
		ProbeExcitationWavelengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0 Nanometer],
			Units->Nanometer,
			IndexMatching->Probes,
			Description->"For each member of Probes, the wavelength of light used to excite the probe.",
			Category->"RT-qPCR"
		},
		ProbeEmissionWavelengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0 Nanometer],
			Units->Nanometer,
			IndexMatching->Probes,
			Description->"For each member of Probes, the wavelength of light collected from the excited probe.",
			Category->"RT-qPCR"
		},
		qPCRProbeExcitationWavelengths->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{GreaterEqualP[0*Nanometer]..},
			Description->"For each member of qPCRTemplates, the wavelengths of light used to excite the probes.",
			Category->"Probe Assay",
			IndexMatching->qPCRTemplates
		},
		qPCRProbeEmissionWavelengths->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{GreaterEqualP[0*Nanometer]..},
			Description->"For each member of qPCRTemplates, the wavelengths of light collected from the excited probes.",
			Category->"Probe Assay",
			IndexMatching->qPCRTemplates
		},
		qPCRProbes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{_Link..},
			Description->"For each member of qPCRTemplates, the probe for reverse transcription quantitative polymerase chain reaction (RT-qPCR).",
			Category->"RT-qPCR",
			IndexMatching->qPCRTemplates,
			Developer->True
		},
		qPCRProbeFluorophores->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{_Link..},
			Description->"For each member of qPCRTemplates, the fluorescent molecule attached to the probe for reverse transcription quantitative polymerase chain reaction (RT-qPCR).",
			Category->"RT-qPCR",
			IndexMatching->qPCRTemplates,
			Developer->True
		},

		(*Master Mix and Buffer*)
		MasterMix->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The solution composed of reverse transcriptase, polymerase, RNase inhibitor, nucleotides, and buffer for reverse transcription and target sequence amplification.",
			Category->"RT-qPCR"
		},
		MasterMixVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Milliliter,
			Description->"The master mix volume added to the reaction.",
			Category->"RT-qPCR"
		},
		ReactionBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The buffer solution for bringing the reaction to ReactionVolume once all the reaction components (sample, primers, and master mix) are added.",
			Category->"RT-qPCR"
		},
		ReactionBufferVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Milliliter,
			Description->"The buffer volume added to the reaction.",
			Category->"RT-qPCR"
		},
		ReferenceDye->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The passive fluorescence reference dye this protocol uses to normalize fluorescence background fluctuations during quantification.",
			Category->"RT-qPCR"
		},
		ReferenceDyeExcitationWavelength->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0 Nanometer],
			Units->Nanometer,
			Description->"The wavelength of light used to excite the reference dye.",
			Category->"RT-qPCR"
		},
		ReferenceDyeEmissionWavelength->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0 Nanometer],
			Units->Nanometer,
			Description->"The wavelength of light collected from the reference dye.",
			Category->"RT-qPCR"
		},

		(*Thermocycling*)
		Thermocycler->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Instrument],Object[Instrument]],
			Description->"The thermocycling instrument for performing reverse transcription quantitative polymerase chain reaction (RT-qPCR).",
			Category->"RT-qPCR"
		},
		ReverseTranscriptionRampRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Celsius/Second],
			Units->Celsius/Second,
			Description->"The rate at which the temperature changes in degrees per second when bringing the samples up to the reverse transcription temperature.",
			Category->"RT-qPCR"
		},
		ReverseTranscriptionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The temperature at which the reverse transcriptase converts the viral RNA into complementary DNA (cDNA).",
			Category->"RT-qPCR"
		},
		ReverseTranscriptionTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"The length of time for which the reverse transcriptase is allowed to convert the viral RNA into complementary DNA (cDNA).",
			Category->"RT-qPCR"
		},
		ActivationRampRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Celsius/Second],
			Units->Celsius/Second,
			Description->"The rate at which the temperature changes in degrees per second when bringing the samples up to the activation temperature.",
			Category->"RT-qPCR"
		},
		ActivationTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The temperature of the initial activation step used to denature the strands and activate the polymerase.",
			Category->"RT-qPCR"
		},
		ActivationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"The length of time of the initial activation step used to denature the strands and activate the polymerase.",
			Category->"RT-qPCR"
		},
		DenaturationRampRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Celsius/Second],
			Units->Celsius/Second,
			Description->"The rate at which the temperature changes in degrees per second when bringing the samples to the denaturation temperature.",
			Category->"RT-qPCR"
		},
		DenaturationTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The temperature of the initial stage of the amplification cycle to denature all the strands.",
			Category->"RT-qPCR"
		},
		DenaturationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"The length of time of the initial stage of the amplification cycle to denature all the strands.",
			Category->"RT-qPCR"
		},
		ExtensionRampRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Celsius/Second],
			Units->Celsius/Second,
			Description->"The rate at which the temperature changes in degrees per second when bringing the samples to the extension temperature.",
			Category->"RT-qPCR"
		},
		ExtensionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The temperature of the final stage of the amplification cycle at which the polymerase extends the newly amplified strands.",
			Category->"RT-qPCR"
		},
		ExtensionTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"The length of time of the final stage of the amplification cycle at which the polymerase is allowed to extend the newly amplified strands.",
			Category->"RT-qPCR"
		},
		NumberOfCycles->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Units->None,
			Description->"The number of amplification cycles consisting of denaturation and extension.",
			Category->"RT-qPCR"
		},
		qPCRProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,qPCR],
			Description->"The quantitative polymerase chain reaction (qPCR) protocol for detecting severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2).",
			Category->"RT-qPCR"
		},


		(*===Analysis & Reports===*)
		InternalSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The internal samples for testing.",
			Category->"Analysis & Reports"
		},
		DaySamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The internal testing samples collected from Lab Operators working day shifts.",
			Category->"Analysis & Reports"
		},
		NightSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The internal testing samples collected from Lab Operators working night shifts.",
			Category->"Analysis & Reports"
		},
		SwingSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The internal testing samples collected from Lab Operators working swing shifts.",
			Category->"Analysis & Reports"
		},
		OtherSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The internal testing samples collected from any other team (non Lab Operator samples).",
			Category->"Analysis & Reports"
		},
		EnvironmentalSample->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The environmental sample for testing.",
			Category->"Analysis & Reports"
		},
		ExternalSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The external samples for testing.",
			Category->"Analysis & Reports"
		},
		SamplePools->{
			Format->Single,
			Class->Expression,
			Pattern:>{{ObjectP[Object[Sample]]..}..},
			Description->"A list of all samples which were combined and analyzed as one to generate a single piece of data.",
			Category->"Analysis & Reports"
		},
		NumberOfRemainingSamples->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Units->None,
			Description->"The number of samples that can't be included in this protocol.",
			Category->"Analysis & Reports"
		},
		AnalysisNotebook->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The notebook containing the quantitative polymerase chain reaction (qPCR) data plots and analysis results.",
			Category->"Analysis & Reports"
		},
		ExpectedPositives->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Vessel],
			Description->"A running list of input samples that are expected to be positive based on secondary testing done by the individuals associated with the samples. If a sample falls into this category and is associated with a positive result no additional lab cleaning or shutdown steps will be necessary.",
			Category->"Analysis & Reports"
		},

		(* To Delete *)
		ProbeExcitationWavelength->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0 Nanometer],
			Units->Nanometer,
			Description->"The wavelength of light used to excite the probes.",
			Category->"RT-qPCR"
		},
		ProbeEmissionWavelength->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0 Nanometer],
			Units->Nanometer,
			Description->"The wavelength of light collected from the excited probes.",
			Category->"RT-qPCR"
		}
	}
}];