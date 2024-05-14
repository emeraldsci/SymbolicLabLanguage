(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,COVID19Test],{
	Description->"A protocol for running coronavirus disease 2019 (COVID-19) tests on the specimens.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*===Reagent Preparation===*)
		Disinfectant->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The freshly prepared bleach solution for disinfecting the specimens.",
			Category->"Reagent Preparation"
		},


		(*===RNA Extraction===*)
		BiosafetyCabinet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Instrument],Object[Instrument]],
			Description->"The biosafety cabinet instrument in which viral RNA extraction is performed.",
			Category->"RNA Extraction"
		},
		AliquotVessels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"For each member of SamplesIn, the microcentrifuge tube to which a 300 uL aliquot of the specimen is transferred.",
			Category->"RNA Extraction",
			IndexMatching->SamplesIn
		},
		CellLysisBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The buffer solution for lysing the cells and inactivating the viruses and nucleases found in the specimens.",
			Category->"RNA Extraction"
		},
		ViralLysisBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The buffer solution for lysing the viral particles following cell lysis.",
			Category->"RNA Extraction"
		},
		RNAExtractionColumns->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"For each member of SamplesIn, the spin column for purifying viral RNA from the lysed samples.",
			Category->"RNA Extraction",
			IndexMatching->SamplesIn
		},
		PrimaryCollectionVessels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"For each member of SamplesIn, the container that holds the initial column flow-through.",
			Category->"RNA Extraction",
			IndexMatching->SamplesIn
		},
		SecondaryCollectionVessels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"For each member of SamplesIn, the container that holds the column flow-throughs during washes.",
			Category->"RNA Extraction",
			IndexMatching->SamplesIn
		},
		PrimaryWashSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The solution for removing sample impurities from the spin columns.",
			Category->"RNA Extraction"
		},
		SecondaryWashSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The solution for removing PrimaryWashSolution from the spin columns before elution.",
			Category->"RNA Extraction"
		},
		ElutionVessels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"For each member of SamplesIn, the container that holds the eluted viral RNA.",
			Category->"RNA Extraction",
			IndexMatching->SamplesIn
		},
		ElutionSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The solution for eluting the viral RNA from the spin columns.",
			Category->"RNA Extraction"
		},
		RNAExtractionPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description->"The set of instructions specifying the extraction of viral RNA from SamplesIn via spin columns.",
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
		TestContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"For each member of SamplesIn, the self-standing container that holds the purified viral RNA sample for testing via reverse transcription quantitative polymerase chain reaction (RT-qPCR).",
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
		AnalysisNotebook->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The notebook containing the quantitative polymerase chain reaction (qPCR) data plots and analysis results.",
			Category->"Analysis & Reports"
		}
	}
}];
