(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section::Closed:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ExperimentDigitalPCR*)


(* ::Subsubsection::Closed:: *)
(*ExperimentDigitalPCR Options and Messages*)


DefineOptions[ExperimentDigitalPCR,
	Options:>{

		(* Instrument *)
		{
			OptionName->Instrument,
			Default->Model[Instrument,Thermocycler,DigitalPCR,"Bio-Rad QX One"],
			Description->"The device that takes a reaction mixture with target DNA or RNA, primers, probes and master mix, partitions them into nanoliter droplets, amplifies the nucleic acid templates, detects fluorescence signals from the droplets and quantifies the copy number of DNA or RNA targets.",
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Instrument,Thermocycler,DigitalPCR],Object[Instrument,Thermocycler,DigitalPCR]}]]
		},

		(* Prepared plate *)
		{
			OptionName->PreparedPlate,
			Default->Automatic,
			Description->"Indicates if the input with samples, primers, probes and master mix is already loaded on a DropletCartridge and ready to perform digital PCR without further reagent addition.",
			ResolutionDescription->"Automatically resolves to True if the input samples are in a container matching \"Model[Container,Plate,DropletCartridge,\"Bio-Rad GCR96 Digital PCR Cartridge\"]\", and no PrimerPair and Probe inputs are specified, otherwise resolves to False.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},

		(* Container plate option *)
		{
			OptionName->DropletCartridge,
			Default->Model[Container,Plate,DropletCartridge,"Bio-Rad GCR96 Digital PCR Cartridge"],
			Description->"The plate with integrated microfluidics used to partition samples into droplets. Each microfluidic unit contains a sample well, channels for the sample, oil and vacuum lines to facilitate the formation of nanoliter size droplets, and a well to collect the generated droplets.",
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ObjectP[Model[Container,Plate,DropletCartridge]]],
				Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Container,Plate,DropletCartridge]]]]
			]
		},

		(* Droplet oils *)
		{
			OptionName->DropletGeneratorOil,
			Default->Model[Sample,"QX One Droplet Generation Oil"],
			Description->"The immiscible liquid that will be used to generate nanoliter-sized aqueous droplets in microfluidic channels of DropletCartridge.",
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}]]
		},
		{
			OptionName->DropletReaderOil,
			Default->Model[Sample,"QX One Droplet Reader Oil"],
			Description->"The immiscible liquid that will be used to separate PCR amplified droplets and facilitate fluorescence signal detection from individual droplets.",
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}]]
		},

		IndexMatching[
			IndexMatchingInput->"experiment samples",

			(* Amplitude Multiplexing *)
			{
				OptionName->AmplitudeMultiplexing,
				Default->Automatic,
				Description->"Number of genetic targets to be detected in each fluorescence channel. Multiple genetic targets can be detected in a single channel using gradations of different primer and probe concentrations to control amplification of the gene and fluorescence signal amplitude of droplets.",
				ResolutionDescription->"Automatically tallies the number of amplification targets in each fluorescence channel using the fluorophore emission wavelength of target probe(s) and reference probe(s). If any channel has more than one target and/or reference, resolves to a list of number of targets per channel; otherwise resolves to Null.",
				AllowNull->True,
				Widget->Adder[{
					"Wavelength"->Widget[Type->Enumeration,Pattern:>dPCREmissionWavelengthP],
					"Multiplexed Targets"->Widget[Type->Number,Pattern:>GreaterEqualP[0,1]]
				}]
			}
		],

		(* Sample Preparation *)
		IndexMatching[
			IndexMatchingInput->"experiment samples",

			(* Sample *)
			{
				OptionName->SampleVolume,
				Default->Automatic,
				Description->"For each sample, the portion of the reaction volume that is made up of the sample from which the target is amplified.",
				ResolutionDescription->"Automatically resolves to 0\[Mu]L when PreparedPlate is True, otherwise resolves to 4\[Mu]L.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[0*Microliter,100*Microliter],Units->{1,{Microliter,{Microliter,Milliliter}}}],
				Category->"Sample Preparation"
			},

			(* Sample dilution options *)
			{
				OptionName->SampleDilution,
				Default->False,
				Description->"For each sample, indicates if Diluent should be used to generate a series of decreasing target concentrations to ensure that an unknown sample falls within the DigitalPCR detection range of 0.25 to 5,000 targets/\[Mu]L.",
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Category->"Sample Dilution"
			},
			{
				OptionName->SerialDilutionCurve,
				Default->Automatic,
				(* FIX THE DESCRIPTION!! *)
				Description->"For each sample, the collection of dilutions that are performed before the SampleVolume is transferred to a mixture of primers, probes, MasterMix and Diluent. For Serial Dilution Factors, the sample will be diluted with the Diluent by the dilution factor at each transfer step. For example, a SerialDilutionCurve of {36*Microliter,{1,0.8,0.5,0.5}} for a 100 mg/mL sample will result in 4 dilutions with concentrations of 100 mg/mL, 80 mg/mL, 40 mg/mL, and 20 mg/mL. For Serial Dilution Volumes, the Transfer Volume is taken out of the sample and added to a second well with the Diluent Volume of the Diluent. It is mixed, then the Transfer Volume is taken out of that well to be added to a third well. This is repeated to make Number Of Dilutions diluted samples. For example, if a 100 mg/mL sample with a Transfer Volume of 30 Microliters, a Diluent Volume of 10 Microliters and a Number of Dilutions of 2 is used, it will create a DilutionCurve of 75 mg/mL, 56.3 mg/mL, and 42.2 mg/mL.",
				ResolutionDescription->"Automatically resolves to {50*Microliter,{0.1,4}}, where 50\[Mu]L is the sample volume, 0.1 is the constant dilution factor and 4 is the number of dilutions, when SampleDilution is True, otherwise resolves to Null.",
				AllowNull->True,
				Category->"Sample Dilution",
				Widget->Alternatives[
					"Serial Dilution Volumes"->{
						"Transfer Volume"->Widget[Type->Quantity,Pattern:>GreaterP[0 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
						"Diluent Volume"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
						"Number Of Dilutions"->Widget[Type->Number,Pattern:>GreaterP[1,1]]
					},
					"Serial Dilution Factor"->{
						"Sample Volume"->Widget[Type->Quantity,Pattern:>GreaterEqualP[10 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
						"Dilution Factors"->Alternatives[
							"Constant"->{
								"Constant Dilution Factor"->Widget[Type->Number,Pattern:>RangeP[0,1]],
								"Number Of Dilutions"->Widget[Type->Number,Pattern:>GreaterP[1,1]]
							},
							"Variable"->Adder[Widget[Type->Number,Pattern:>RangeP[0,1]]]
						]
					}
				]
			},
			{
				OptionName->DilutionMixVolume,
				Default->Automatic,
				Description->"For each sample, the volume that is pipetted in and out to mix the sample and the Diluent.",
				ResolutionDescription->"Automatically resolves to 10 \[Mu]L if SampleDilution is True, otherwise resolves to Null.",
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
				Category -> "Sample Dilution"
			},
			{
				OptionName->DilutionNumberOfMixes,
				Default->Automatic,
				Description->"For each sample, the number of cycles of pipetting in and out that is used to mix the sample and the Diluent.",
				ResolutionDescription->"Automatically resolves to 10 if SampleDilution is True, otherwise resolves to Null.",
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern:>RangeP[0,20,1]],
				Category -> "Sample Dilution"
			},
			{
				OptionName->DilutionMixRate,
				Default->Automatic,
				Description->"For each sample, the speed at which the DilutionMixVolume is pipetted in and out to mix the sample and the Diluent.",
				ResolutionDescription->"Automatically resolves to 30\[Mu]L/s if SampleDilution is True, otherwise resolves to Null.",
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[0.4 Microliter/Second,250 Microliter/Second],Units->{1,{Microliter/Second,{Microliter/Second}}}],
				Category->"Sample Dilution"
			},

			(* Pre-mixed assay with primer set and probe *)
			{
				OptionName->PremixedPrimerProbe,
				Default->Automatic,
				Description->"For each sample, indicates if primerPair and probe input has an assay that contains a set of primers and a probe or if a primerPair input contains a primer set or if all three index-matched inputs are separate objects. The primerPair and probe inputs should have the same object of type Object[Sample] or Model[Sample]. Volume of the pre-mixed assay is calculated from the concentration of the probe oligomer in the mixture.",
				ResolutionDescription->"Automatically resolves to TargetAssay if the primerPair and probe inputs have the same object, resolves to PrimerSet if only primerPair inputs have the same object, resolves to None if primerPair and probe have unique objects and resolves to Null if primerPairs and probes inputs are Null.",
				AllowNull->True,
				Widget->Adder[Widget[Type->Enumeration,Pattern:>Alternatives[TargetAssay,PrimerSet,None]]],
				Category->"Sample Preparation"
			},

			(* Target primers and probes *)
			{
				OptionName->ForwardPrimerConcentration,
				Default->Automatic,
				Description->"For each sample, the molarity of the short oligomer designed to bind the antisense strand of a template sequence. A primer functions as an anchor for polymerases and transcriptases during polymerase chain reaction.",
				ResolutionDescription->"Automatically resolves to match ReversePrimerConcentration; otherwise calculated using the formula: ForwardPrimerConcentration=(max concentration)*Table[(N-t)/N,{t,0,T-1}], where (max concentration)=1350 Nanomolar, N=(number of targets + number of references) in a channel resolved in AmplitudeMultiplexing, and T=(number of targets); or resolves to 900 nM for forward primer in channels with a single amplification product.",
				AllowNull->True,
				Widget->Adder[
					Widget[Type -> Quantity,Pattern :> RangeP[0 Nanomolar, 1500 Nanomolar],Units -> {1,{Nanomolar,{Nanomolar,Micromolar}}}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ForwardPrimerVolume,
				Default->Automatic,
				Description->"For each sample, the volume of forward primer(s) to be added to the reaction.",
				ResolutionDescription->"Automatically calculated using the formula: ForwardPrimerVolume=(ForwardPrimerConcentration*ReactionVolume)/(stock concentration), where stock concentration is downloaded from the compositional information of the corresponding oligomer object.",
				AllowNull->True,
				Widget->Adder[
					Widget[Type -> Quantity,Pattern :> RangeP[0 Microliter, 100 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]
				],
				Category->"Sample Preparation"
			},

			{
				OptionName->ReversePrimerConcentration,
				Default->Automatic,
				Description->"For each sample, the molarity of the short oligomer designed to bind the sense (coding) strand of a template sequence. A primer functions as an anchor for polymerases and transcriptases during polymerase chain reaction.",
				ResolutionDescription->"Automatically resolves to match ForwardPrimerConcentration; otherwise calculated using the formula: ReversePrimerConcentration=(max concentration)*Table[(N-t)/N,{t,0,T-1}], where (max concentration)=1350 Nanomolar, N=(number of targets + number of references) in a channel resolved in AmplitudeMultiplexing, and T=(number of targets); or resolves to 900 nM for reverse primer in channels with a single amplification product.",
				AllowNull->True,
				Widget->Adder[
					Widget[Type -> Quantity,Pattern :> RangeP[0 Nano*Molar, 1500 Nano*Molar],Units -> {1,{Nano*Molar,{Nano*Molar,Micro*Molar}}}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ReversePrimerVolume,
				Default->Automatic,
				Description->"For each sample, the volume of reverse primer(s) to be added to the reaction.",
				ResolutionDescription->"Automatically calculated using the formula: ReversePrimerConcentration=(ReversePrimerConcentration*ReactionVolume)/(stock concentration), where stock concentration is downloaded from the compositional information of the corresponding oligomer object.",
				AllowNull->True,
				Widget->Adder[
					Widget[Type -> Quantity,Pattern :> RangeP[0 Microliter, 100 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]
				],
				Category->"Sample Preparation"
			},

			{
				OptionName->ProbeConcentration,
				Default->Automatic,
				Description->"For each sample, the molarity of the short oligomer strand containing a reporter and quencher, and designed to be complementary to a template sequence being amplified. Fluorescence signal is observed when the probe is hydrolyzed by a polymerase and the fluorophore is released.",
				ResolutionDescription->"Automatically calculated using the formula: ProbeConcentration=(max concentration)*Table[(N-t)/N,{t,0,T-1}], where (max concentration)=375 Nanomolar, N=(number of targets + number of references) in a channel resolved in AmplitudeMultiplexing, and T=(number of targets); otherwise resolves to 250 nM for reverse primer in channels with a single amplification product.",
				AllowNull->True,
				Widget->Adder[Widget[Type -> Quantity,Pattern :> RangeP[0 Nano*Molar, 500 Nano*Molar],Units -> {1,{Nano*Molar,{Nano*Molar,Micro*Molar}}}]],
				Category->"Sample Preparation"
			},
			{
				OptionName->ProbeVolume,
				Default->Automatic,
				Description->"For each sample, the volume of probe(s) to be added to the reaction.",
				ResolutionDescription->"Automatically resolved using the formula: ProbeVolume=(ProbeConcentration*ReactionVolume)/(stock concentration), where stock concentration is downloaded from the compositional information of the corresponding oligomer object.",
				AllowNull->True,
				Widget->Adder[Widget[Type -> Quantity,Pattern :> RangeP[0 Microliter, 100 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]],
				Category->"Sample Preparation"
			},

			(* Reference primers and probes *)
			{
				OptionName->ReferencePrimerPairs,
				Default->Null,
				Description->"For each sample, the pair of short oligomer strands designed to amplify a reference gene (such as a housekeeping gene), whose expression should not be different between samples. Primers can be specified as individual objects for forward and reverse primers. Primer-sets and pre-mixed assays with primers and probes can also be used.",
				AllowNull->True,
				Widget->Alternatives[
					Adder[{
						"Reference Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}],
						"Reference Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}]
					}],
					{
						"Reference Forward Primer"->Widget[Type->Enumeration,Pattern:>Alternatives[Null]],
						"Reference Reverse Primer"->Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					}
				],
				Category->"Sample Preparation"
			},

			(* Pre-mixed assay with primer set and probe *)
			{
				OptionName->ReferencePremixedPrimerProbe,
				Default->Automatic,
				Description->"For each sample, indicates if ReferencePrimerPairs and ReferenceProbes have assays that contains a set of primers and a probe or if a ReferencePrimerPairs input contains a primer set or if all three index-matched reference objects are separate. The ReferencePrimerPairs and ReferenceProbes should have the same object of type Object[Sample] or Model[Sample]. Volume of the pre-mixed assay is calculated from the concentration of the probe oligomer in the mixture.",
				ResolutionDescription->"Automatically resolves to TargetAssay if the reference primer pair and  reference probe inputs have the same object, resolves to PrimerSet if only reference primer pair inputs have the same object, resolves to None if reference primer pair and reference probe have unique objects and resolves to Null if reference primer pairs and probes are Null.",
				AllowNull->True,
				Widget->Adder[Widget[Type->Enumeration,Pattern:>Alternatives[TargetAssay,PrimerSet,None]]],
				Category->"Sample Preparation"
			},

			{
				OptionName->ReferenceForwardPrimerConcentration,
				Default->Automatic,
				Description->"For each sample, the molarity of reference gene(s) specific oligomer that binds to the antisense strand of the template.",
				ResolutionDescription->"Automatically resolves to match ReferenceReversePrimerConcentration; otherwise calculated using the formula: ReferenceForwardPrimerConcentration=(max concentration)*Table[(N-t)/N,{t,T,N-1}], where (max concentration)=1350 Nanomolar, N=(number of targets + number of references) in a channel resolved in AmplitudeMultiplexing, and T=(number of targets); or resolves to 900 nM for forward primer in channels with a single amplification product or Null if ReferencePrimerPairs is Null.",
				AllowNull->True,
				Widget->Adder[
					Widget[Type -> Quantity,Pattern :> RangeP[0 Nano*Molar, 1500 Nano*Molar],Units -> {1,{Nano*Molar,{Nano*Molar,Micro*Molar}}}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ReferenceForwardPrimerVolume,
				Default->Automatic,
				Description->"For each sample, the volume of forward primer(s) for reference gene(s) that will be added to the reaction.",
				ResolutionDescription->"Automatically calculated using the formula: ReferenceForwardPrimerConcentration=(ReferenceForwardPrimerConcentration*ReactionVolume)/(stock concentration), where stock concentration is downloaded from the compositional information of the corresponding oligomer object; Resolves to Null if ReferencePrimerPairs is Null.",
				AllowNull->True,
				Widget->Adder[
					Widget[Type -> Quantity,Pattern :> RangeP[0 Microliter, 100 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ReferenceReversePrimerConcentration,
				Default->Automatic,
				Description->"For each sample, the molarity of reference gene(s) specific oligomer that binds to the sense (coding) strand of the template.",
				ResolutionDescription->"Automatically resolves to match ReferenceForwardPrimerConcentration; otherwise calculated using the formula: ReferenceReversePrimerConcentration=(max concentration)*Table[(N-t)/N,{t,T,N-1}], where (max concentration)=1350 Nanomolar, N=(number of targets + number of references) in a channel resolved in AmplitudeMultiplexing, and T=(number of targets); or resolves to 900 nM for reverse primer in channels with a single amplification product or Null if ReferencePrimerPairs is Null.",
				AllowNull->True,
				Widget->Adder[
					Widget[Type -> Quantity,Pattern :> RangeP[0 Nano*Molar, 1500 Nano*Molar],Units -> {1,{Nano*Molar,{Nano*Molar,Micro*Molar}}}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ReferenceReversePrimerVolume,
				Default->Automatic,
				Description->"For each sample, the volume of reverse primer(s) for reference gene(s) that will be added to the reaction.",
				ResolutionDescription->"Automatically calculated using the formula: ReferenceReversePrimerConcentration=(ReferenceReversePrimerConcentration*ReactionVolume)/(stock concentration), where stock concentration is downloaded from the compositional information of the corresponding oligomer object; Resolves to Null if ReferencePrimerPairs is Null.",
				AllowNull->True,
				Widget->Adder[
					Widget[Type -> Quantity,Pattern :> RangeP[0 Microliter, 100 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]
				],
				Category->"Sample Preparation"
			},

			{
				OptionName->ReferenceProbes,
				Default->Null,
				Description->"For each sample, the short oligomer strand containing a fluorescence reporter and quencher, which enhances its fluorescence upon separation from the quencher.",
				AllowNull->True,
				Widget->Adder[Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}]],
				Category->"Sample Preparation"
			},
			{
				OptionName->ReferenceProbeConcentration,
				Default->Automatic,
				Description->"For each sample, the molarity of probe(s) for reference gene(s) in the reaction.",
				ResolutionDescription->"Automatically calculated using the formula: ReferenceProbeConcentration=(max concentration)*Table[(N-t)/N,{t,T,N-1}], where (max concentration)=375 Nanomolar, N=(number of targets + number of references) in a channel resolved in AmplitudeMultiplexing, and T=(number of targets); otherwise resolves to 250 nM for probes in channels with a single amplification product or Null if ReferencePrimerPairs is Null.",
				AllowNull->True,
				Widget->Adder[Widget[Type -> Quantity,Pattern :> RangeP[0 Nano*Molar, 500 Nano*Molar],Units -> {1,{Nano*Molar,{Nano*Molar,Micro*Molar}}}]],
				Category->"Sample Preparation"
			},
			{
				OptionName->ReferenceProbeVolume,
				Default->Automatic,
				Description->"For each sample, the volume of the probe(s) for reference gene(s) that will be added to the reaction.",
				ResolutionDescription->"Automatically resolved using the formula: ProbeVolume=(ProbeConcentration*ReactionVolume)/(stock concentration), where stock concentration is downloaded from the compositional information of the corresponding oligomer object; resolves to Null if ReferencePrimerPairs is Null.",
				AllowNull->True,
				Widget->Adder[Widget[Type->Quantity,Pattern :> RangeP[0 Microliter, 100 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]],
				Category->"Sample Preparation"
			},

			(* MasterMix *)
			{
				OptionName->MasterMix,
				Default->Automatic,
				Description->"For each sample, the stock solution composed of enzymes (DNA polymerase and optionally reverse transcriptase), buffer and nucleotides used to amplify DNA or RNA targets in the sample. It is recommended to select the MasterMix even if it is in the sample as the type of master mix can affect the size of droplets generated and selection of droplets for signal detection.",
				ResolutionDescription->"Automatically resolves to Model[Sample,\"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer\"] if input samples contain RNA templates or if any reverse transcription options are informed. The RT buffer requires addition of reverse transcriptase and DTT, so the master mix will be automatically replaced with Model[Sample,StockSolution,\"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, 2x Master Mix\"] in the MasterMixes field of Object[Protocol,DigitalPCR]. Resolves to Model[Sample,\"Bio-Rad ddPCR Multiplex Supermix\"] if multiple probes are used, otherwise resolves to Model[Sample,\"Bio-Rad ddPCR Supermix for Probes (No dUTP)\"].",
				AllowNull->False,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
				Category->"Sample Preparation"
			},
			{
				OptionName->MasterMixConcentrationFactor,
				Default->Automatic,
				Description->"For each sample, the amount by which the MasterMix stock solution must be diluted with Diluent in order to achieve 1X buffer concentration in the reaction.",
				ResolutionDescription->"Automatically resolves to Null if PreparedPlate is True, otherwise set to ConcentratedBufferDilutionFactor from Model[Sample] of MasterMix.",
				AllowNull->True,
				Widget->Widget[Type -> Number,Pattern :> GreaterP[0.,1]],
				Category->"Sample Preparation"
			},
			{
				OptionName->MasterMixVolume,
				Default->Automatic,
				Description->"For each sample, the volume of the stock solution (composed of enzymes (DNA polymerase and optionally reverse transcriptase), buffer and nucleotides) that will be added to the sample.",
				ResolutionDescription->"Automatically resolves to Null if PreparedPlate is True, otherwise set to MasterMixVolume=ReactionVolume/MasterMixConcentrationFactor.",
				AllowNull->True,
				Widget->Widget[Type -> Quantity,Pattern :> RangeP[0 Microliter, 100 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
				Category->"Sample Preparation"
			},

			(* Diluent *)
			{
				OptionName->Diluent,
				Default->Model[Sample,"Nuclease-free Water"],
				Description -> "For each sample, stock solution used to reach ReactionVolume, once all other components have been added.",
				AllowNull->False,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
				Category->"Sample Preparation"
			},
			{
				OptionName->DiluentVolume,
				Default->Automatic,
				Description->"For each sample, the volume of stock solution to be added to the reaction.",
				ResolutionDescription->"Automatically set according to the equation DiluentVolume=ReactionVolume-(SampleVolume+ForwardPrimerVolume+ReversePrimerVolume+ProbeVolume+ReferenceForwardPrimerVolume+ReferenceReversePrimerVolume+ReferenceProbeVolume+MasterMixVolume) if Diluent is not set to Null, or Null otherwise.",
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,100 Microliter],Units->{1,{Microliter,{Microliter,Milliliter}}}],
				Category->"Sample Preparation"
			},

			(* Reaction prepared in PCR plate prior to transfer into DropletCartridge *)
			{
				OptionName->ReactionVolume,
				Default->40 Microliter,
				Description->"For each sample, the volume of reaction including sample, primers, probes, master mix and buffer. A LoadingVolume of 21 Microliter will be transferred to DropletCartridge well after reaction components are mixed.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[30*Microliter,100*Microliter],Units->{1,{Microliter,{Microliter,Milliliter}}}],
				Category->"Sample Preparation"
			}
		],

		(* ActiveWell *)
		{
			OptionName->ActiveWell,
			Default->Automatic,
			Description->"The well in which the reaction will be conducted. The position can be designated with a well index when a single DropletCartridge is in use. An alternate input with plate index and well index can be used to configure multiple DropletCartridge plates in a single experiment. Samples can be distributed in up to 5 individual 96-well DropletCartridges.",
			ResolutionDescription->"Automatically resolves the well indices. For variable thermocycling conditions, samples are grouped with compatible conditions. Samples containing RNA are prioritized for droplet generation and thermocycling.",
			AllowNull->False,
			Widget->Alternatives[
				Adder[Widget[Type->String,Pattern:>WellP,Size->Word]],
				Adder[{
					"Plate Index"->Widget[Type->Enumeration,Pattern:>Alternatives[1,2,3,4,5]],
					"Well Index"->Widget[Type->String,Pattern:>WellP,Size->Word]
				}]
			],
			Category->"Sample Preparation"
		},

		(* Passive wells *)
		{
			OptionName->PassiveWells,
			Default->Automatic,
			Description->"Droplet generation is conducted in parallel on a section of 16 sample units in a DropletCartridge. Each section is composed of an adjacent pair of an odd and an even numbered column such as {1,2}. Unused wells in a section are filled with viscosity matched control buffer to enable parallel processing and no data is generated from these wells.",
			ResolutionDescription->"Automatically resolves the well indices for empty wells within a 16 unit section that has 1 or more samples. Resolves to None if each 16 unit section in use is filled with samples. Sections without any samples are skipped during the assay.",
			AllowNull->False,
			Widget->Alternatives[
				Adder[Widget[Type->String,Pattern:>WellP,Size->Word]],
				Adder[{
					"Plate Index"->Widget[Type->Enumeration,Pattern:>Alternatives[1,2,3,4,5]],
					"Well Index"->Widget[Type->String,Pattern:>WellP,Size->Word]
				}],
				Widget[Type->Enumeration,Pattern:>Alternatives[None]]
			],
			Category->"Sample Preparation"
		},
		{
			OptionName->PassiveWellBuffer,
			Default->Model[Sample,"Bio-Rad ddPCR Buffer Control for Probes"],
			Description->"Control solution with viscosity matched to master mix. 20 Microliter of buffer is added to PassiveWells.",
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
			Category->"Sample Preparation"
		},

		(* Plate sealing *)
		{
			OptionName->PlateSealInstrument,
			Default->Model[Instrument,PlateSealer,"Bio-Rad PX1 Plate Sealer"],
			Description->"The instrument used to apply heat-seal digital PCR plates with foil prior to assay run.",
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Instrument,PlateSealer],Object[Instrument,PlateSealer]}]],
			Category->"Plate Seal"
		},
		(* Foil *)
		{
			OptionName->PlateSealFoil,
			Default->Model[Item, PlateSeal, "GCR96 PCR Plate Seal, Pierceable Heat-Sealed Aluminum"],
			Description->"The pierceable membrane used to seal digital PCR plate.",
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Item],Object[Item]}]],
			Category->"Plate Seal"
		},
		(* Plate sealer settings *)
		{
			OptionName->PlateSealTemperature,
			Default->180 Celsius,
			Description->"The temperature that will be used to heat the foil for sealing a plate.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[100 Celsius,190 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}],
			Category->"Plate Seal"
		},
		{
			OptionName->PlateSealTime,
			Default->0.5 Second,
			Description->"The duration of time used for applying PlateSealTemperature to seal the digital PCR plate.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0.5 Second,10 Second],Units->{Second,{Milli*Second,Second,Minute}}],
			Category->"Plate Seal"
		},

		(* Thermocycling *)
		IndexMatching[
			IndexMatchingInput->"experiment samples",

			(* Reverse transcription protocol *)
			{
				OptionName->ReverseTranscription,
				Default->Automatic,
				Description->"For each sample, indicates if one-step reverse transcription is performed in order to convert RNA input samples to cDNA. Thermocycling is performed after samples are partitioned into droplets and collected in the droplet well of their corresponding microfluidic unit. All sample emulsions on a DropletCartridge are thermocycled simultaneously.",
				ResolutionDescription->"Automatically set to True if any reverse transcription related options are set, and False if none are set.",
				AllowNull->False,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Category->"Reverse Transcription"
			},
			{
				OptionName->ReverseTranscriptionTime,
				Default->Automatic,
				Description->"For each sample, the length of time for which the reaction volume will held at ReverseTranscriptionTemperature in order to convert RNA to cDNA.",
				ResolutionDescription->"Automatically set to 15 minutes if ReverseTranscription is set to True, and Null if it is set to False.",
				AllowNull->True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0 Second, 2 Hour],Units -> {1,{Second,{Second,Minute,Hour}}}],
				Category->"Reverse Transcription"
			},
			{
				OptionName->ReverseTranscriptionTemperature,
				Default->Automatic,
				Description->"For each sample, the initial temperature at which the sample should be heated to in order to activate the reverse transcription enzymes in the master mix to convert RNA to cDNA.",
				ResolutionDescription->"Automatically set to 50\[Degree]Celsius if ReverseTranscription is set to True, and Null if it is set to False.",
				AllowNull->True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
				Category->"Reverse Transcription"
			},
			{
				OptionName->ReverseTranscriptionRampRate,
				Default->Automatic,
				Description->"For each sample, the rate at which the reaction volume is heated to bring the sample to the reverse transcription temperature.",
				ResolutionDescription->"Automatically set to 1.6\[Degree]Celsius/Second if ReverseTranscription is set to True, and Null if it is set to False.",
				AllowNull->True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[1.0 (Celsius/Second), 2.5 (Celsius/Second)],Units -> CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
				Category->"Reverse Transcription"
			},

			(* Activation *)
			{
				OptionName->Activation,
				Default->True,
				Description->"For each sample, indicates if polymerase hot start activation is performed. In order to reduce non-specific amplification, modern enzymes can be made room temperature stable by inhibiting their activity via thermolabile conjugates. Once an experiment is ready to be run, this inhibition is removed by heating the reaction to ActivationTemperature. The activation step is recommended as ActivationTemperature promotes stabilization of droplet boundary through a reaction between MasterMix and DropletGeneratorOil prior to thermocycling.",
				AllowNull->False,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Category->"Polymerase Activation"
			},
			{
				OptionName->ActivationTime,
				Default->Automatic,
				Description->"For each sample, the length of time for which the reaction volume is held at ActivationTemperature in order to remove the thermolabile conjugates inhibiting enzyme activity.",
				ResolutionDescription->"Automatically set to 10 minutes if Activation is set to True.",
				AllowNull->True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0 Second, 2 Hour],Units -> {1,{Second,{Second,Minute,Hour}}}],
				Category->"Polymerase Activation"
			},
			{
				OptionName->ActivationTemperature,
				Default->Automatic,
				Description->"For each sample, the temperature at which at which the thermolabile conjugates inhibiting enzyme activity are removed.",
				ResolutionDescription->"Automatically set to 95\[Degree]Celsius if Activation is set to True.",
				AllowNull->True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
				Category->"Polymerase Activation"
			},
			{
				OptionName->ActivationRampRate,
				Default->Automatic,
				Description->"For each sample, the rate at which the reaction is heated to bring the sample to the ActivationTemperature.",
				ResolutionDescription->"Automatically set to 1.6\[Degree]Celsius/Second if Activation is set to True.",
				AllowNull->True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[1.0 (Celsius/Second), 2.5 (Celsius/Second)],Units -> CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
				Category->"Polymerase Activation"
			},

			(* Denaturation *)
			{
				OptionName->DenaturationTime,
				Default->30 Second,
				Description->"For each sample, the length of time for which the reaction is held at DenaturationTemperature in order to separate any double stranded template DNA into single strands.",
				AllowNull->False,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0 Second, 2 Hour],Units -> {1,{Second,{Second,Minute,Hour}}}],
				Category->"Denaturation"
			},
			{
				OptionName->DenaturationTemperature,
				Default->95 Celsius,
				Description->"For each sample, the temperature to which the sample is heated in order to disassociate double stranded template DNA into single strands.",
				AllowNull->False,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
				Category->"Denaturation"
			},
			{
				OptionName->DenaturationRampRate,
				Default->(1.8 (Celsius/Second)),
				Description->"For each sample, the rate at which the reaction is heated to bring the sample to DenaturationTemperature.",
				AllowNull->False,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[1.0 (Celsius/Second), 2.5 (Celsius/Second)],Units -> CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
				Category->"Denaturation"
			},

			(* Annealing *)
			{
				OptionName->PrimerAnnealing,
				Default->True,
				Description->"For each sample, indicates if annealing should be performed. Lowering the temperature during annealing allows primers to bind to template DNA to serve as anchor points for DNA polymerization. It is highly recommended to use PrimerAnnealing as a single step to perform annealing and extension if the working temperature of the polymerase in MasterMix is 60\[Degree]Celsius.",
				AllowNull->False,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Category->"Primer Annealing"
			},
			{
				OptionName->PrimerAnnealingTime,
				Default->Automatic,
				Description->"For each sample, the length of time for which the reaction is held at PrimerAnnealingTemperature in order to allow binding of primers to the template DNA.",
				ResolutionDescription->"Automatically set to 60 seconds if PrimerAnnealing or PrimerGradientAnnealing is set to True, and Null if it is set to False.",
				AllowNull->True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0 Second, 2 Hour],Units -> {1,{Second,{Second,Minute,Hour}}}],
				Category->"Primer Annealing"
			},
			{
				OptionName->PrimerAnnealingTemperature,
				Default->Automatic,
				Description->"For each sample, the temperature to which the sample is heated in order to allow primers to bind to the template strands.",
				ResolutionDescription->"Automatically set to 60\[Degree]Celsius if PrimerAnnealing is set to True, and Null if it is set to False.",
				AllowNull->True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
				Category->"Primer Annealing"
			},
			{
				OptionName->PrimerAnnealingRampRate,
				Default->Automatic,
				Description->"For each sample, the rate at which the reaction is heated to bring the sample to PrimerAnnealingTemperature.",
				ResolutionDescription->"Automatically set to 2.0\[Degree]Celsius/Second if PrimerAnnealing is set to True, and Null if it is set to False.",
				AllowNull->True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[1.0 (Celsius/Second), 2.5 (Celsius/Second)],Units -> CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
				Category->"Primer Annealing"
			},

			(* Gradient Annealing *)
			{
				OptionName->PrimerGradientAnnealing,
				Default->False,
				Description->"For each sample, indicates if a gradation of temperature should be used for annealing across columns such that each row has the same annealing temperature. A linearly decreasing series of temperatures for 8 rows is calculated as follows: Range[Tmin,Tmax,(Tmax-Tmin)/7], where Tmin is the minimum temperature set to Row 'A' and Tmax is the maximum temperature set to Row 'H'. A temperature gradient can be used to optimize annealing by setting Tmin and Tmax to be (expected annealing temperature) +/- 5 Celsius. An aliquot of reaction mixture with the same target, primer pair and probe is added to at least one well per row of a DropletCartridge and the amplification efficiency is determined by the fluorescence signal amplitude of the droplets after PCR.",
				AllowNull->False,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Category->"Primer Gradient Annealing"
			},
			{
				OptionName->PrimerGradientAnnealingMinTemperature,
				Default->Automatic,
				Description->"For each sample, the lower value of the temperature range that will be used to calculate annealing temperature of each row.",
				ResolutionDescription->"Automatically set to 55\[Degree]Celsius if PrimerGradientAnnealing is set to True, and Null if it is set to False.",
				AllowNull->True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[30 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
				Category->"Primer Gradient Annealing"
			},
			{
				OptionName->PrimerGradientAnnealingMaxTemperature,
				Default->Automatic,
				Description->"For each sample, the upper value of the temperature range that will be used to calculate annealing temperature of each row.",
				ResolutionDescription->"Automatically set to 65\[Degree]Celsius if PrimerGradientAnnealing is set to True, and Null if it is set to False.",
				AllowNull->True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[30 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
				Category->"Primer Gradient Annealing"
			},
			{
				OptionName->PrimerGradientAnnealingRow,
				Default->Automatic,
				Description->"For each sample, the tier in which the sample will be located in the DropletCartridge. \"Row A\" is the minimum temperature and \"Row H\" is the maximum temperature, while the rows in between have a gradation of temperature.",
				ResolutionDescription->"Automatically resolves the row & temperature assignment for sample with PrimerGradientAnnealing set to True, where the first sample is assigned to \"Row A\", second sample to \"Row B\" and so on; otherwise resolves to Null if PrimerGradientAnnealing is False.",
				AllowNull->True,
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> Alternatives["Row A","Row B","Row C","Row D","Row E","Row F","Row G","Row H"]],
					{
						"Row" -> Widget[Type -> Enumeration, Pattern :> Alternatives["Row A","Row B","Row C","Row D","Row E","Row F","Row G","Row H"]],
						"Temperature" -> Widget[Type -> Quantity, Pattern:> RangeP[30 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}]
					}
				],
				Category->"Primer Gradient Annealing"
			},

			(* Extension *)
			{
				OptionName->Extension,
				Default->False,
				Description->"For each sample, indicates if an extension step should be performed as a separate step.",
				AllowNull->False,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Category->"Strand Extension"
			},
			{
				OptionName->ExtensionTime,
				Default->Automatic,
				Description->"For each sample, the length of time for which the polymerase synthesizes a new DNA strand using the provided primer pairs and template DNA.",
				ResolutionDescription->"Automatically set to 60 Second if Extension is set to True, and Null if it is set to False.",
				AllowNull->True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0 Second, 2 Hour],Units -> {1,{Second,{Second,Minute,Hour}}}],
				Category->"Strand Extension"
			},
			{
				OptionName->ExtensionTemperature,
				Default->Automatic,
				Description->"For each sample, the temperature at which the sample is held to allow the polymerase to synthesis new DNA strand from the template DNA.",
				ResolutionDescription->"Automatically set to 60\[Degree]Celsius if Extension is set to True, and Null if it is set to False.",
				AllowNull->True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
				Category->"Strand Extension"
			},
			{
				OptionName->ExtensionRampRate,
				Default->Automatic,
				Description->"For each sample, the rate at which the reaction is heated to bring the sample to ExtensionTemperature.",
				ResolutionDescription->"Automatically set to 2.0\[Degree]Celsius/Second if Extension is set to True, and Null if it is set to False",
				AllowNull->True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[1.0 (Celsius/Second), 2.5 (Celsius/Second)],Units -> CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
				Category->"Strand Extension"
			},

			(* Cycles *)
			{
				OptionName->NumberOfCycles,
				Default->39,
				Description->"For each sample, the remaining number of times the samples will undergo repeated rounds of denaturation, annealing and extension to amplify targets.",
				AllowNull->False,
				Widget -> Widget[Type->Number,Pattern :> RangeP[1,60]],
				Category->"Strand Extension"
			},

			(* PolymeraseDegradation *)
			{
				OptionName->PolymeraseDegradation,
				Default->True,
				Description->"For each sample, indicates if the polymerase should be degraded at PolymeraseDegradationTemperature. After thermocycling is complete, the DropletCartridge is will remain at 25 Celsius (i.e. ambient temperature). Polymerase degradation is recommended to prevent any alterations to the droplet contents prior to signal detection.",
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Category->"Polymerase Degradation"
			},
			{
				OptionName->PolymeraseDegradationTime,
				Default->Automatic,
				Description->"For each sample, the length of time for which the sample is held at PolymeraseDegradationTemperature.",
				ResolutionDescription->"Automatically set to 10 minutes if PolymeraseDegradation is set to True, or Null otherwise",
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second,1 Hour],Units->{1,{Second,{Second,Minute,Hour}}}],
				Category->"Polymerase Degradation"
			},
			{
				OptionName->PolymeraseDegradationTemperature,
				Default->Automatic,
				Description->"For each sample, the temperature to which the sample is heated to degrade the polymerase.",
				ResolutionDescription->"Automatically set to 98 Celsius if PolymeraseDegradation is set to True, or Null otherwise.",
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[4 Celsius,105 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}],
				Category->"Polymerase Degradation"
			},
			{
				OptionName->PolymeraseDegradationRampRate,
				Default->Automatic,
				Description->"For each sample, the rate at which the sample is heated to reach PolymeraseDegradationTemperature.",
				ResolutionDescription->"Automatically set to 2.5 degrees Celsius per second if PolymeraseDegradation is set to True, or Null otherwise.",
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[1.0 (Celsius/Second),2.5 (Celsius/Second)],Units->CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
				Category->"Polymerase Degradation"
			}
		],

		(* Detection *)
		IndexMatching[
			IndexMatchingInput->"experiment samples",

			(* Probe Fluorophores *)
			(* Existing models: Model[Molecule,"6-Fam"], Model[Molecule,"VIC Dye"]; Do not exist: Model[Molecule,Hex], Model[Molecule,Cy5], Model[Molecule,Cy5.5]? *)
			{
				OptionName->ProbeFluorophore,
				Default->Automatic,
				Description->"For each sample, the fluorescent molecule conjugated to the probe that allows for detection of amplification.",
				ResolutionDescription->"Automatically set to the model of fluorophore attached to probe oligomer.",
				AllowNull->False,
				Widget->Adder[Widget[Type->Object,Pattern:>ObjectP[Model[Molecule]]]],
				Category->"Detection"
			},
			{
				OptionName->ProbeExcitationWavelength,
				Default->Automatic,
				Description->"For each sample, the wavelength of light used to excite the reporter component of the probe.",
				ResolutionDescription->"Automatically set to FluorescenceExcitationMaximums of the fluorophore attached to the probe.",
				AllowNull->False,
				Widget->Adder[Widget[Type -> Enumeration,Pattern:>dPCRExcitationWavelengthP]],
				Category->"Detection"
			},
			{
				OptionName->ProbeEmissionWavelength,
				Default->Automatic,
				Description->"For each sample, the wavelength of light emitted by the reporter once it has been excited.",
				ResolutionDescription->"Automatically set to FluorescenceEmissionMaximums of the fluorophore attached to the probe.",
				AllowNull->False,
				Widget->Adder[Widget[Type -> Enumeration,Pattern:>dPCREmissionWavelengthP]],
				Category->"Detection"
			},

			(* Reference Probe Fluorophores *)
			{
				OptionName->ReferenceProbeFluorophore,
				Default->Automatic,
				Description->"The fluorescent molecule conjugated to the reference probe that allows for detection of amplification.",
				ResolutionDescription->"Automatically set to the model of fluorophore attached to the reference probe oligomer; resolves to Null if ReferencePrimerPairs is Null.",
				AllowNull->True,
				Widget->Adder[Widget[Type->Object,Pattern:>ObjectP[Model[Molecule]]]],
				Category->"Detection"
			},
			{
				OptionName->ReferenceProbeExcitationWavelength,
				Default->Automatic,
				Description -> "The wavelength of light used to excite the reporter component of the reference probe.",
				ResolutionDescription->"Automatically set to FluorescenceExcitationMaximums of the fluorophore attached to the reference probe; resolves to Null if ReferencePrimerPairs is Null.",
				AllowNull -> True,
				Widget->Adder[Widget[Type -> Enumeration,Pattern:>dPCRExcitationWavelengthP]],
				Category->"Detection"
			},
			{
				OptionName->ReferenceProbeEmissionWavelength,
				Default->Automatic,
				Description -> "The wavelength of light emitted by the reporter once it has been excited and read by the instrument.",
				ResolutionDescription->"Automatically set to FluorescenceEmissionMaximums of the fluorophore attached to the reference probe; resolves to Null if ReferencePrimerPairs is Null.",
				AllowNull -> True,
				Widget->Adder[Widget[Type -> Enumeration,Pattern:>dPCREmissionWavelengthP]],
				Category->"Detection"
			}
		],

		(* Resource storage options *)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->ForwardPrimerStorageCondition,
				Default->Null,
				Description->"For each sample, the non-default conditions under which the forward primers of this experiment should be stored after the protocol is completed. If left unset, the forward primers will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},
			{
				OptionName->ReversePrimerStorageCondition,
				Default->Null,
				Description->"For each sample, the non-default conditions under which the reverse primers of this experiment should be stored after the protocol is completed. If left unset, the reverse primers will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},
			{
				OptionName->ProbeStorageCondition,
				Default->Null,
				Description->"For each sample, the non-default conditions under which the probes of this experiment should be stored after the protocol is completed. If left unset, the probes will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},
			{
				OptionName->ReferenceForwardPrimerStorageCondition,
				Default->Null,
				Description->"For each sample, the non-default conditions under which the forward primers for the reference of this experiment should be stored after the protocol is completed. If left unset, the forward primers for the reference will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},
			{
				OptionName->ReferenceReversePrimerStorageCondition,
				Default->Null,
				Description->"For each sample, the non-default conditions under which the reverse primers for the reference of this experiment should be stored after the protocol is completed. If left unset, the reverse primers for the reference will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},
			{
				OptionName->ReferenceProbeStorageCondition,
				Default->Null,
				Description->"For each sample, the non-default conditions under which the probes for the reference of this experiment should be stored after the protocol is completed. If left unset, the probes for the reference will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},
			{
				OptionName->MasterMixStorageCondition,
				Default->Null,
				Description->"For each sample, the non-default condition under which MasterMix of this experiment should be stored after the protocol is completed. If left unset, MasterMix will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			}
		],

		(* Droplet collection from plate *)
		(*
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SampleProcessSteps,
				Default->Null,
				Description->"For each sample, the phases that should be conducted. A typical experiment involves three sequential phases of DropletGeneration, Thermocycling and DropletReading. Samples can be extracted from DropletCartridge after DropletGeneration or Thermocycling. It is critical to note that sample extraction destroys the DropletCartridge and the extracted samples cannot be used for ExperimentDigitalPCR.",
				AllowNull->True,
				Widget->Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[DropletGeneration|Thermocycling|DropletReading]],
				Category->"Sample Storage"
			}
		],
		{
			OptionName->ContainerOut,
			Default->Automatic,
			Description->"The desired container generated samples should be extracted into after DropletGeneration or Thermocycling phases.",
			ResolutionDescription -> "Automatically set as the PreferredContainer for the Volume of the sample. Resolves to Null if no samples are extracted.",
			AllowNull->True,
			Widget->Widget[Type -> Object,Pattern :> ObjectP[{Model[Container],Object[Container]}],ObjectTypes->{Model[Container],Object[Container]}],
			Category->"Sample Storage"
		},
		*)

		(* SharedOptions *)
		ModelInputOptions,
		AnalyticalNumberOfReplicatesOption,
		NonBiologyFuntopiaSharedOptions,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions,
		SimulationOption
		(*SamplesOutStorageOptions*)
	}
];

(* ::Subsubsection::Closed:: *)
(* ExperimentDigitalPCR errors *)
Error::DigitalPCRNonLiquidSamples="Solid samples are not allowed for ExperimentDigitalPCR. Please verify that sample(s), `1`, are in liquid state or use ExperimentResuspend or ExperimentAliquot to dissolve samples in solvent before proceeding.";
Error::DigitalPCRNullComposition="For sample(s), `1`, the composition field is not informed. Please verify that all samples have a valid Composition.";
Error::InvalidPrimerProbeInputs="For each sample, the lengths of primerPair and probe inputs do not match. Please verify the inputs and try again.";
Error::DigitalPCRInvalidPreparedPlate="Primer and probe inputs, and sample volume or dilution options cannot be specified when using prepared plate. Fully prepared samples must be in Model[Container,Plate,DropletCartridge,\"Bio-Rad GCR96 Digital PCR Cartridge\"] and PassiveWells must be filled to enable parallel processing of 16-well blocks. Please change the option values and ensure that samples are in an instrument-compatible droplet cartridge with PassiveWells filled to use PreparedPlate.";
Error::DigitalPCRSampleDilutionMismatch="When not using PreparedPlate and SampleDilution is True, SerialDilutionCurve, DilutionMixVolume, DilutionMixRate, and DilutionNumberOfMixes must be informed. When SampleDilution is False, the options must be Null. Please check the option values for conflicts and try again.";
Error::DigitalPCRDilutionSampleVolume="Volume of sample dilutions cannot be less than SampleVolume. Please increase volumes specified in SerialDilutionCurve option to ensure that the quantity of dilute sample will be sufficient for the assay and try again.";
Error::InvalidInputSampleContainer="When prepared plate is not used and sample preparation will be done, samples cannot be in Model[Container,Plate,DropletCartridge,\"Bio-Rad GCR96 Digital PCR Cartridge\". Please use a different plate for sample preparation.";
Error::ActiveWellOverConstrained="When prepared plate is used and the specified ActiveWell matches the Well field specified in the sample object. Please keep ActiveWell unspecified.";
Error::InvalidActiveWells="ActiveWell indices have repeats or do not match 96-well format. Please change the values of ActiveWells, or leave them unspecified to be set automatically. If PrimerGradientAnnealingRow is specified, ensure that the number of samples in each row is less than 12, or leave the field unspecified.";
Error::TooManyPlates="The number of plates cannot be accommodated in a single experiment. Please use a smaller sample size and/or reduce the variations in thermocycling conditions.";
Error::ThermocyclingOptionsMismatchInPlate="When ActiveWell is specified with plate index, all samples in the same plate should have identical set of thermocycling options. Please check the thermocycling options or leave ActiveWell unspecified.";
Error::PassiveWellsAssignment="16-wells are processed for droplet generation in parallel. When a 16-well block in a plate has one or more samples, all empty wells must be assigned to PassiveWells for droplet generation. Please check the list of well indices in all input plates for PassiveWells or leave PassiveWells unspecified.";
Error::DigitalPCRSingleFluorophorePerProbe="For sample(s), `1`, probe input object must have 1 related fluorescent molecule. Please check the probe sample composition to ensure that it contains 1 identity oligomer molecule with a single fluorophore.";
Error::DigitalPCRSingleReferenceFluorophorePerProbe="For sample(s), `1`, reference probe input object must have 1 related fluorescent molecule. Please check the probe sample composition to ensure that it contains 1 identity oligomer molecule with a single fluorophore.";
Error::DigitalPCRProbeWavelengthsNull="For sample(s), `1`, ProbeExcitationWavelength and ProbeEmissionWavelength are not informed. Please check that the probe input or the sample input composition has identity oligomer molecule with fluorescence fields informed or specify both options.";
Error::DigitalPCRProbeWavelengthsIncompatible="For sample(s), `1`, ProbeExcitationWavelength and ProbeEmissionWavelength are incompatible with instrument specifications. Please check that the specified ProbeExcitationWavelength and ProbeEmissionWavelength or the excitation and emission wavelengths of input probes match instrument specifications.";
Error::DigitalPCRProbeWavelengthsLengthMismatch="For sample(s), `1`, the lengths of ProbeExcitationWavelength and ProbeEmissionWavelength do not match the length of input probes. Please specify wavelengths for all input probes or leave the options unspecified.";
Error::DigitalPCRReferenceProbeWavelengthsNull="For sample(s), `1`, ReferenceProbeExcitationWavelength and ReferenceProbeEmissionWavelength are not informed. Please check that the probe input or the sample input composition has identity oligomer molecule with fluorescence fields informed or specify both options.";
Error::DigitalPCRReferenceProbeWavelengthsIncompatible="For sample(s), `1`, ReferenceProbeExcitationWavelength and ReferenceProbeEmissionWavelength are incompatible with instrument specifications. Please check that the specified ReferenceProbeExcitationWavelength and ReferenceProbeEmissionWavelength or the excitation and emission wavelengths of reference probes match instrument specifications.";
Error::DigitalPCRReferenceProbeWavelengthsLengthMismatch="For sample(s), `1`, the lengths of ReferenceProbeExcitationWavelength and ReferenceProbeEmissionWavelength do not match the length of reference probe input. Please specify wavelengths for all reference probe objects or leave the options unspecified.";
Error::DigitalPCRAmplitudeMultiplexing="For sample(s), `1`, AmplitudeMultiplexing should not be Null when no channel has more than 1 target. Please specify the correct number of targets in each channel or leave the option unspecified.";
Error::DigitalPCRPremixedPrimerProbe="For sample(s), `1`, PremixedPrimerProbe must be TargetAssay when an assay is used as primer pair and probe inputs, PrimerSet when an object with set of primers is used as primer inputs, or None when primer pair and probe inputs are unique. Please ensure the option is index-matched to primer and probe inputs or leave it unspecified.";
Error::DigitalPCRReferencePremixedPrimerProbe="For sample(s), `1`, ReferencePremixedPrimerProbe must be TargetAssay when an assay is used as ReferencePrimerPairs and ReferenceProbes inputs, PrimerSet when an object with set of primers is used as ReferencePrimerPairs inputs, or None when ReferencePrimerPairs and ReferenceProbe inputs are unique. Please ensure the option is index-matched to ReferencePrimerPairs and ReferenceProbes inputs or leave it unspecified.";
Error::DigitalPCRProbeStockConcentration="For sample(s), `1`, concentration of probe oligomer in the probe sample object Composition is not provided as molar or mass concentration. Please ensure that sample composition is informed with molar or mass concentration of oligomers.";
Error::DigitalPCRReferenceProbeStockConcentration="For sample(s), `1`, concentration of probe oligomer in the ReferenceProbe sample object Composition is not provided as molar or mass concentration. Please ensure that sample composition is informed with molar or mass concentration of oligomers.";
Error::DigitalPCRProbeConcentrationVolumeMismatch="For sample(s), `1`, specified volumes and concentrations of input probe samples do not match their stock concentration, or if volume and concentration are specified when probes are Null. Please check the volume and concentration specifications or leave them unspecified to set automatically.";
Error::DigitalPCRProbeStockConcentrationTooLow="For sample(s), `1`, concentration of oligomer in probe sample Composition is lower than 4 x ProbeConcentration, which will lead to a total volume higher than ReactionVolume. Please use a probe input with higher stock concentration.";
Error::DigitalPCRReferenceProbeConcentrationVolumeMismatch="For sample(s), `1`, specified volumes and concentrations of ReferenceProbes do not match their stock concentration, or if volume and concentration are specified when ReferenceProbes are Null. Please check the volume and concentration specifications or leave them unspecified to set automatically.";
Error::DigitalPCRReferenceProbeStockConcentrationTooLow="For sample(s), `1`, concentration of oligomer in ReferenceProbes sample Composition is lower than 4 x ReferenceProbeConcentration, which will lead to a total volume higher than ReactionVolume. Please use a reference probe input with higher stock concentration.";
Error::DigitalPCRForwardPrimerStockConcentration="For sample(s), `1`, concentration of the oligomer in the forward primer sample object Composition is not provided as molar or mass concentration. Please ensure that sample composition is informed with molar or mass concentration of oligomers.";
Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch="For sample(s), `1`, specified volumes and concentrations of input forward primer samples do not match their stock concentration, or if volume and concentration are specified when primers are Null. Please check the volume and concentration specifications or leave them unspecified to set automatically.";
Error::DigitalPCRForwardPrimerStockConcentrationTooLow="For sample(s), `1`, concentration of oligomer in primer sample Composition is lower than 4 x ForwardPrimerConcentration, which will lead to a total volume higher than ReactionVolume. Please use a primer input with higher stock concentration.";
Error::DigitalPCRReversePrimerStockConcentration="For sample(s), `1`, concentration of the oligomer in the reverse primer sample object Composition is not provided as molar or mass concentration. Please ensure that sample composition is informed with molar or mass concentration of oligomers.";
Error::DigitalPCRReversePrimerConcentrationVolumeMismatch="For sample(s), `1`, specified volumes and concentrations of input reverse primer samples do not match their stock concentration, or if volume and concentration are specified when primers are Null. Please check the volume and concentration specifications or leave them unspecified to set automatically.";
Error::DigitalPCRReversePrimerStockConcentrationTooLow="For sample(s), `1`, concentration of oligomer in primer sample Composition is lower than 4 x ReversePrimerConcentration, which will lead to a total volume higher than ReactionVolume. Please use a primer input with higher stock concentration.";
Error::DigitalPCRReferenceForwardPrimerStockConcentration="For sample(s), `1`, concentration of the oligomer in the reference forward primer sample object Composition is not provided as molar or mass concentration. Please ensure that sample composition is informed with molar or mass concentration of oligomers.";
Error::DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch="For sample(s), `1`, specified volumes and concentrations of reference forward primer samples do not match their stock concentration, or if volume and concentration are specified when ReferencePrimerPairs are Null. Please check the volume and concentration specifications or leave them unspecified to set automatically.";
Error::DigitalPCRReferenceForwardPrimerStockConcentrationTooLow="For sample(s), `1`, concentration of oligomer in reference primer sample Composition is lower than 4 x ReferenceForwardPrimerConcentration, which will lead to a total volume higher than ReactionVolume. Please use a primer input with higher stock concentration.";
Error::DigitalPCRReferenceReversePrimerStockConcentration="For sample(s), `1`, concentration of the oligomer in the reference reverse primer sample object Composition is not provided as molar or mass concentration. Please ensure that sample composition is informed with molar or mass concentration of oligomers.";
Error::DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch="For sample(s), `1`, specified volumes and concentrations of reference reverse primer samples do not match their stock concentration, or if volume and concentration are specified when ReferencePrimerPairs are Null. Please check the volume and concentration specifications or leave them unspecified to set automatically.";
Error::DigitalPCRReferenceReversePrimerStockConcentrationTooLow="For sample(s), `1`, concentration of oligomer in reference primer sample Composition is lower than 4 x ReferenceReversePrimerConcentration, which will lead to a total volume higher than ReactionVolume. Please use a primer input with higher stock concentration.";
Error::DigitalPCRMasterMixMismatch="For sample(s), `1`, MasterMixConcentration and MasterMixVolume are not Null when PreparedPlate is True or MasterMixConcentrationFactor and MasterMixVolume are Null when PreparedPlate is False. Please check the specified value or leave them unspecified to set automatically.";
Error::DigitalPCRDiluentVolume="For sample(s), `1`, DiluentVolume is not Null when PreparedPlate is True or DiluentVolume is Null when PreparedPlate is False. Please check the specified value or leave it unspecified to set automatically.";
Error::DigitalPCRTotalVolume="The volume consisting of SampleVolume, MasterMixVolume, ForwardPrimerVolume, ReversePrimerVolume, ProbeVolume, ReferenceForwardPrimerVolume, ReferenceReversePrimerVolume, ReferenceProbeVolume and DiluentVolume exceeds ReactionVolume for sample(s) `1`. Please change the value of some or all of these options, or leave them unspecified to be set automatically.";
Error::DigitalPCRReverseTranscriptionMismatch="For sample(s), `1`, if ReverseTranscription is False, ReverseTranscriptionTime, ReverseTranscriptionTemperature, and ReverseTranscriptionRampRate cannot be specified; if ReverseTranscription is True, ReverseTranscriptionTime, ReverseTranscriptionTemperature, and ReverseTranscriptionRampRate cannot be Null. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::DigitalPCRActivationMismatch="For sample(s), `1`, if Activation is False, ActivationTime, ActivationTemperature, and ActivationRampRate cannot be specified; if Activation is True, ActivationTime, ActivationTemperature, and ActivationRampRate cannot be Null. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::DigitalPCRPrimerAnnealingMismatch="For sample(s), `1`, if PrimerAnnealing is True, PrimerAnnealingTime, PrimerAnnealingTemperature, and PrimerAnnealingRampRate cannot be Null; if PrimerAnnealing is False, PrimerAnnealingTemperature, and PrimerAnnealingRampRate cannot be specified and if PrimerGradientAnnealing is also False, PrimerAnnealingnTime cannot be specified. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::DigitalPCRPrimerGradientAnnealingMismatch="For sample(s), `1`, if PrimerGradientAnnealing is True, PrimerGradientAnnealingTime, PrimerGradientAnnealingMinTemperature, PrimerGradientAnnealingMaxTemperature, and PrimerGradientAnnealingRow cannot be null and if PrimerGradientAnnealing is False, PrimerGradientAnnealingMinTemperature, PrimerGradientAnnealingMaxTemperature, and PrimerGradientAnnealingRow cannot be specified.  Please change the values of these options, or leave them unspecified to be set automatically.";
Error::DigitalPCRPrimerGradientAnnealingRowTemperatureMismatch="For sample(s), `1`, the specified temperature in PrimerGradientAnnealingRow option does not match the value calculated from Range[PrimerGradientAnnealingMinTemperature,PrimerGradientAnnealingMaxTemperature,7] and rounded to 0.1 Celsius. Please change the value of this option, or provide only the row input to set the temperature automatically.";
Error::DigitalPCROverConstrainedRowOptions="For sample(s), `1`, there is a mismatch between ActiveWell index and PrimerGradientAnnealingRow. Please make sure they match or leave ActiveWell unspecified to set it automatically.";
Error::DigitalPCRExtensionMismatch="For sample(s), `1`, if Extension is False, ExtensionTime, ExtensionTemperature, and ExtensionRampRate cannot be specified; if Extension is True, ExtensionTime, ExtensionTemperature, and ExtensionRampRate cannot be Null. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::DigitalPCRPolymeraseDegradationMismatch="For sample(s), `1`, if PolymeraseDegradation is False, PolymeraseDegradationTime, PolymeraseDegradationTemperature, and PolymeraseDegradationRampRate cannot be specified; if PolymeraseDegradation is True, PolymeraseDegradationTime, PolymeraseDegradationTemperature, and PolymeraseDegradationRampRate cannot be Null. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::ActiveWellOptionLengthMismatch="The specified value for ActiveWell is incompatible with the length of samples to be assayed. Please ensure each of the possible samples (including dilutions and replicates) has a designated ActiveWell or use the default value to resolve the option automatically.";

Error::DigitalPCRForwardPrimerStorageConditionMismatch="The specified forward primer storage conditions have conflicts with the input forward primers. Please change the value of ForwardPrimerStorageCondition.";
Error::DigitalPCRReversePrimerStorageConditionMismatch="The specified reverse primer storage conditions have conflicts with the input reverse primers. Please change the value of ReversePrimerStorageCondition.";
Error::DigitalPCRProbeStorageConditionMismatch="The specified probe storage conditions have conflicts with the input probes. Please change the value of ProbeStorageCondition.";
Error::DigitalPCRReferenceForwardPrimerStorageConditionMismatch="The specified reference forward primer storage conditions have conflicts with the forward primers in ReferencePrimerPairs. Please change the value of ReferenceForwardPrimerStorageCondition.";
Error::DigitalPCRReferenceReversePrimerStorageConditionMismatch="The specified reference reverse primer storage conditions have conflicts with the reverse primers in ReferencePrimerPairs. Please change the value of ReferenceReversePrimerStorageCondition.";
Error::DigitalPCRReferenceProbeStorageConditionMismatch="The specified reference probe storage conditions have conflicts with the probes in ReferenceProbes. Please change the value of ReferenceProbeStorageCondition.";
Error::DigitalPCRMasterMixStorageConditionMismatch="The MasterMixStorageCondition cannot be specified when using PreparedPlate. Please change the value of MasterMixStorageCondition.";

Error::DigitalPCRPrimerProbeMismatchedOptionLengths="For sample(s), `1`, the lengths of specified options related to premixed assay, concentrations, volumes, and/or fluorescence property for input primers and probes do not match their corresponding inputs. Please check any specified options are index-matched to primer and probe inputs correctly or leave them unspecified to be set automatically.";
Error::DigitalPCRReferencePrimerProbeMismatchedOptionLengths="For sample(s), `1`, the lengths of specified options related to premixed assay, concentrations, volumes, and/or fluorescence property for ReferencePrimerPairs and ReferenceProbes do not match their corresponding inputs. Please check any specified options are index-matched to ReferencePrimerPairs and ReferenceProbes correctly or leave them unspecified to be set automatically.";
Error::DigitalPCRDropletCartridgeLengthMismatch="The specified list of plate objects does not match the number of plates required for this experiment. Please modify the DropletCartridge option or leave it as the default model container.";
Error::DigitalPCRDropletCartridgeRepeatedObjects="The specified list of plate objects has repeated objects. Please modify the DropletCartridge option or leave it as the default model container.";
Error::DigitalPCRDropletCartridgeObjectMismatch="When using prepared plate(s) and DropletCartridge is specified as a list of container objects, they must match the containers of input samples. Please modify the DropletCartridge option or leave it as the default model container.";
Error::DigitalPCRMultiplexingNotAvailable="When multiplexing features are flagged with $ddPCRNoMultiplex=True, a sample may not have more than 1 fluorescent oligomer in composition or probe input. Please use a single probe input per sample.";

(* ExperimentDigitalPCR warnings *)
Warning::DigitalPCRMultiplexedTargetQuantity="For sample(s), `1`, multiplexing more than 2 targets may result in poor separation of droplet populations and the resulting data may not be useful for target quantification.";
Warning::DigitalPCRProbeStockConcentrationAccuracy="For sample(s), `1`, the concentration of probe identity oligomer is provided as mass concentration. Inaccuracies in oligomer MolecularWeight will propagate to calculated molar concentration and related quantities.";
Warning::DigitalPCRReferenceProbeStockConcentrationAccuracy="For sample(s), `1`, the concentration of reference probe identity oligomer is provided as mass concentration. Inaccuracies in oligomer MolecularWeight will propagate to calculated molar concentration and related quantities.";
Warning::DigitalPCRForwardPrimerStockConcentrationAccuracy="For sample(s), `1`, the concentration of forward primer identity oligomer is provided as mass concentration. Inaccuracies in oligomer MolecularWeight will propagate to calculated molar concentration and related quantities.";
Warning::DigitalPCRReversePrimerStockConcentrationAccuracy="For sample(s), `1`, the concentration of reverse primer identity oligomer is provided as mass concentration. Inaccuracies in oligomer MolecularWeight will propagate to calculated molar concentration and related quantities.";
Warning::DigitalPCRReferenceForwardPrimerStockConcentrationAccuracy="For sample(s), `1`, the concentration of reference forward primer identity oligomer is provided as mass concentration. Inaccuracies in oligomer MolecularWeight will propagate to calculated molar concentration and related quantities.";
Warning::DigitalPCRReferenceReversePrimerStockConcentrationAccuracy="For sample(s), `1`, the concentration of reference reverse primer identity oligomer is provided as mass concentration. Inaccuracies in oligomer MolecularWeight will propagate to calculated molar concentration and related quantities.";
Warning::DigitalPCRMasterMixConcentrationFactorNotInformed="For sample(s), `1`, the concentration of MasterMix may be inaccurate as it is calculated using the MasterMixVolume and ReactionVolume. Please inform the concentration factor and leave volume unspecified if possible.";
Warning::DigitalPCRMasterMixQuantityMismatch="For sample(s), `1`, the specified MasterMixVolume does not match ReactionVolume/MasterMixConcentrationFactor. Please check that the specified volume is accurate or poor droplet generation and thermocycling will lead to poor quality of results.";

(* ::Subsubsection::Closed:: *)
(* ExperimentDigitalPCR Source Code *)

(*---Main function accepting sample objects as sample inputs, sample objects or Nulls as primer pair inputs, and sample objects or Nulls as probe inputs---*)

ExperimentDigitalPCR[
	mySamples:ListableP[ObjectP[Object[Sample]]],
	myPrimerPairSamples:ListableP[
		Alternatives[
			{{ObjectP[{Object[Sample]}],ObjectP[{Object[Sample]}]}..},
			{Null,Null}
		]
	],
	myProbeSamples:ListableP[
		Alternatives[
			{ObjectP[{Object[Sample]}]..},
			Null
		]
	],
	myOptions:OptionsPattern[ExperimentDigitalPCR]
]:=Module[
	{listedOptions,listedSamples,initialListedPrimerPairSamples,listedPrimerPairSamples,
		initialListedProbeSamples,listedProbeSamples,
		nestedIndexMatchingInputsCheck,nestedIndexMatchingInputsResult,
		flatPrimerPairSamples,primerPairLengths,flatProbeSamples,probeLengths,
		outputSpecification,output,gatherTests,messages,
		myFlatPrimerPairSamplesWithPreparedSamples,myFlatProbeSamplesWithPreparedSamples,flatConcatenatedOligoInputsNoNulls,
		preliminaryOptionsWithPreparedSamples,preliminarySamplePreparationCache,
		secondaryOptionsWithPreparedSamples,secondarySamplePreparationCache,
		concatenatedOligoInputs,flatConcatenatedOligoInputs,concatenatedOligoInputsLengths,
		myFlatConcatenatedOligoInputsNoNullsWithPreparedSamplesNamed,myFlatConcatenatedOligoInputsWithPreparedSamples,concatenatedOligoInputsWithPreparedSamples,
		myPrimerPairSamplesWithPreparedSamples,myProbeSamplesWithPreparedSamples,
		myPrimerPairSamplesWithPreparedSamplesNestedNulls,myProbeSamplesWithPreparedSamplesNestedNulls,
		expandedSamples,nonNullExpandedPrimerPairSamples,nonNullExpandedProbeSamples,expandedPrimerPairSamples,expandedProbeSamples,recommendedRTStockSolution,
		validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		updatedSimulation,safeOps,safeOpsTests,validLengths,validLengthTests,cache,downloadedPackets,
		templatedOptions,templateTests,inheritedOptions,digitalPCROptionsAssociation,expandedSafeOps,referencePrimerPairObjects,referenceProbeObjects,allPrimerObjects,allProbeObjects,recommendedMasterMixes,
		oligomerObjects,oligomerModels,oligomerObjectDownloadFields,oligomerModelDownloadFields,
		digitalPCRCompatibleFluorophores,nonAutomaticOptionsWithObjects,automaticOptionsWithPotentialObjects,instrumentOptions,
		liquidHandlerContainers,objectContainerFields,modelContainerFields,cacheBall,resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,
		myFlatConcatenatedOligoInputsWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,
		safeOpsNamed,allOligoInputWithPreparedSamples
	},

	(* Make sure we're working with a list of options and inputs *)
	{listedSamples,listedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];

	initialListedPrimerPairSamples=Switch[
		myPrimerPairSamples,
		Alternatives[{{ObjectP[],ObjectP[]}..},{Null,Null}],{myPrimerPairSamples},
		{Alternatives[{{ObjectP[],ObjectP[]}..},{Null,Null}]..},myPrimerPairSamples
	];

	listedPrimerPairSamples=Map[
		Function[{primerPairSampleListPerInput},
			If[MatchQ[primerPairSampleListPerInput,{Null,Null}],
				List[{Null,Null}],
				primerPairSampleListPerInput
			]
		],
		initialListedPrimerPairSamples
	];

	initialListedProbeSamples=Switch[
		myProbeSamples,
		Alternatives[{ObjectP[]..},Null],{myProbeSamples},
		{Alternatives[{ObjectP[]..},Null]..},myProbeSamples
	];

	listedProbeSamples=Map[
		Function[{probeSampleListPerInput},
			If[MatchQ[probeSampleListPerInput,Null],
				List[Null],
				probeSampleListPerInput
			]
		],
		initialListedProbeSamples
	];

	(* primer and probe inputs should be expanded to match samples here otherwise VILQ will fail*)
	(* Check that primer and probe inputs are properly index matched *)
	nestedIndexMatchingInputsCheck=If[SameLengthQ[listedSamples,listedPrimerPairSamples,listedProbeSamples],
		MapThread[
			Function[{primerPairListPerSample,probeListPerSample},
				!SameLengthQ[primerPairListPerSample,probeListPerSample]
			],
			{listedPrimerPairSamples,listedProbeSamples}
		],
		False
	];

	(* If index-matching of primerPairs and probes for each sample is not right, throw InvalidInputs error *)
	nestedIndexMatchingInputsResult=Check[
		If[AnyTrue[nestedIndexMatchingInputsCheck,TrueQ],Message[Error::InvalidPrimerProbeInputs]],
		$Failed,
		{Error::InvalidPrimerProbeInputs}
	];

	(* If nested index-matching has problems, return early  *)
	If[MatchQ[nestedIndexMatchingInputsResult,$Failed],
		Return[$Failed]
	];

	(* Flatten listedPrimerPairSamples to a list of primer pairs *)
	flatPrimerPairSamples=Flatten[listedPrimerPairSamples,1];

	(* Get the number of primer pairs per sample for bringing back the nested form of listedPrimerPairSamples *)
	primerPairLengths=Length/@listedPrimerPairSamples;

	(* Flatten listedPrimerPairSamples to a list of probes *)
	flatProbeSamples=Flatten[listedProbeSamples,1];

	(* Get the number of probes per sample for bringing back the nested form of listedProbeSamples *)
	probeLengths=Length/@listedProbeSamples;

	(* Create a mega-list of all input objects for simulateSamplePreparationPacketsNew *)
	concatenatedOligoInputs=Join[listedSamples,flatPrimerPairSamples,flatProbeSamples];

	(* Flatten to a list of singletons *)
	flatConcatenatedOligoInputs=Flatten[concatenatedOligoInputs];

	(* Remove Nulls for simulateSamplePreparationPacketsNew function *)
	flatConcatenatedOligoInputsNoNulls=DeleteCases[flatConcatenatedOligoInputs,Null];

	(* Get lengths of each list to break them back out to individual lists *)
	concatenatedOligoInputsLengths=Length/@{listedSamples,flatPrimerPairSamples,flatProbeSamples};

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Simulate our sample preparation. *) (*ADDING PRIMER AND PROBE PREPS*)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{myFlatConcatenatedOligoInputsNoNullsWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentDigitalPCR,
			flatConcatenatedOligoInputsNoNulls,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentDigitalPCR,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentDigitalPCR,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Reinsert Nulls at the original places *)
	myFlatConcatenatedOligoInputsWithPreparedSamplesNamed=Fold[
		Insert[#1,Null,#2]&,
		myFlatConcatenatedOligoInputsNoNullsWithPreparedSamplesNamed,
		Position[flatConcatenatedOligoInputs,Null]
	];

	(* Convert named objects in inputs and options to object references with IDs and remove links *)
	{allOligoInputWithPreparedSamples,safeOps,myOptionsWithPreparedSamples}=sanitizeInputs[myFlatConcatenatedOligoInputsWithPreparedSamplesNamed,safeOpsNamed,myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* Bring back concatenatedOligoInputs list structure *)
	concatenatedOligoInputsWithPreparedSamples=Unflatten[allOligoInputWithPreparedSamples,concatenatedOligoInputs];

	(* Separate mega-list to three lists: samples, primerpairs and probes *)
	{mySamplesWithPreparedSamples,myFlatPrimerPairSamplesWithPreparedSamples,myFlatProbeSamplesWithPreparedSamples}=TakeList[concatenatedOligoInputsWithPreparedSamples,concatenatedOligoInputsLengths];

	(* Bring back the nested form of listedPrimerPairSamples *)
	myPrimerPairSamplesWithPreparedSamplesNestedNulls=TakeList[myFlatPrimerPairSamplesWithPreparedSamples,primerPairLengths];

	(* Bring back the nested from of listedProbeSamples *)
	myProbeSamplesWithPreparedSamplesNestedNulls=TakeList[myFlatProbeSamplesWithPreparedSamples,probeLengths];


	(* Flatten {{Null,Null}} primer pair inputs and {Null} probe inputs by 1 to match their input patterns for the function for ValidInputLengthsQ *)
	myPrimerPairSamplesWithPreparedSamples=Map[
		Function[{primerPairSampleListPerInput},
			If[MatchQ[primerPairSampleListPerInput,{{Null,Null}}],
				{Null,Null},
				primerPairSampleListPerInput
			]
		],
		myPrimerPairSamplesWithPreparedSamplesNestedNulls
	];

	myProbeSamplesWithPreparedSamples=Map[
		Function[{probeSampleListPerInput},
			If[MatchQ[probeSampleListPerInput,{Null}],
				Null,
				probeSampleListPerInput
			]
		],
		myProbeSamplesWithPreparedSamplesNestedNulls
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentDigitalPCR,{mySamplesWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples,myProbeSamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentDigitalPCR,{mySamplesWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples,myProbeSamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentDigitalPCR,{mySamplesWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples,myProbeSamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentDigitalPCR,{mySamplesWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples,myProbeSamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Get cache from inheritedOptions *)
	cache=Lookup[inheritedOptions,Cache];


(*
	(* Prepare myPrimerPairSamplesWithPreparedSamples for expansion: if it consists of primer pairs for only one sample, then remove the outer list so it can be expanded *)
	myPrimerPairSamplesWithPreparedSamplesForExpansion=Switch[
		myPrimerPairSamplesWithPreparedSamples,
		{{{ObjectP[]|Null,ObjectP[]|Null}..}},Flatten[myPrimerPairSamplesWithPreparedSamples,1],
		{{{ObjectP[]|Null,ObjectP[]|Null}..}..},myPrimerPairSamplesWithPreparedSamples
	];

	(* Prepare myProbeSamplesWithPreparedSamples for expansion: if it consists of probes for only one sample, then remove the outer list so it can be expanded *)
	myProbeSamplesWithPreparedSamplesForExpansion=Switch[
		myProbeSamplesWithPreparedSamples,
		{{(ObjectP[]|Null)..}},Flatten[myProbeSamplesWithPreparedSamples,1],
		{{(ObjectP[]|Null)..}..},myProbeSamplesWithPreparedSamples
	];

	(* Expand index-matching inputs and options *)
	{{expandedSamples,nonNullExpandedPrimerPairSamples,nonNullExpandedProbeSamples},expandedSafeOps}=ExpandIndexMatchedInputs[ExperimentDigitalPCR,{mySamplesWithPreparedSamples,myPrimerPairSamplesWithPreparedSamplesForExpansion,myProbeSamplesWithPreparedSamplesForExpansion},inheritedOptions];*)

	{{expandedSamples,nonNullExpandedPrimerPairSamples,nonNullExpandedProbeSamples},expandedSafeOps}=ExpandIndexMatchedInputs[ExperimentDigitalPCR,{mySamplesWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples,myProbeSamplesWithPreparedSamples},inheritedOptions];

	(* Expand index-matching secondary input (primerPairs) if it's Null *)
	expandedPrimerPairSamples=If[MatchQ[nonNullExpandedPrimerPairSamples,{{{Null,Null}}}],
		ConstantArray[{{Null,Null}},Length[expandedSamples]],
		nonNullExpandedPrimerPairSamples
	];

	(* Expand index-matching tertiary input (probes) if it's Null *)
	expandedProbeSamples=If[MatchQ[nonNullExpandedProbeSamples,{{{Null,Null}}}],
		ConstantArray[{{Null,Null}},Length[expandedSamples]],
		nonNullExpandedProbeSamples
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual *)
	digitalPCROptionsAssociation=Association[expandedSafeOps];

	(* Collect reference primers to download composition information. *)
	referencePrimerPairObjects = Cases[
		Flatten[Lookup[digitalPCROptionsAssociation, ReferencePrimerPairs]],
		ObjectP[]
	];

	(* Collect reference probes to download fluorophore information. *)
	referenceProbeObjects = Cases[
		Flatten[Lookup[digitalPCROptionsAssociation, ReferenceProbes]],
		ObjectP[]
	];

	(* Separate oligomer objects into Object and Model types; Resolver will check Object types for Status and Model types for Deprecated *)
	oligomerObjects=Cases[
		Flatten[{mySamplesWithPreparedSamples,expandedPrimerPairSamples,expandedProbeSamples,referencePrimerPairObjects,referenceProbeObjects}],
		ObjectP[Object[Sample]]
	];
	oligomerModels=Cases[
		Flatten[{mySamplesWithPreparedSamples,expandedPrimerPairSamples,expandedProbeSamples,referencePrimerPairObjects,referenceProbeObjects}],
		ObjectP[Model[Sample]]
	];

	(* Determine which fields in the sample Objects we need to download *)
	oligomerObjectDownloadFields=Packet[Well,DateUnsealed,UnsealedShelfLife,RequestedResources,IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample],Format->Sequence]];
	objectContainerFields = SamplePreparationCacheFields[Object[Container]];
	modelContainerFields = SamplePreparationCacheFields[Model[Container]];
	oligomerModelDownloadFields=Packet[IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample],Format->Sequence]];

	(* Collect all primer objects including target and reference primer pairs *)
	allPrimerObjects=Cases[
		Flatten[{expandedPrimerPairSamples,referencePrimerPairObjects}],
		ObjectP[]
	];

	(* Collect all probe objects including target and reference probes *)
	allProbeObjects=Cases[
		Flatten[{expandedProbeSamples,referenceProbeObjects}],
		ObjectP[]
	];

	(* Download all fluorophores known to be compatible with ECL ddPCR instrumentation *)
	digitalPCRCompatibleFluorophores ={
		Model[Molecule,"id:9RdZXv1oADYx"], (* FAM *)
		Model[Molecule,"id:R8e1PjpZ7ZEd"], (* VIC *)
		Model[Molecule,"HEX"],
		Model[Molecule,"Cy5"],
		Model[Molecule,"Cy5.5"]
	};

	(*Download concentration factor from all standard ddpcr supermixes*)
	recommendedMasterMixes={
		Model[Sample,"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer"],
		Model[Sample,"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, RT enzyme"],
		Model[Sample,"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, DTT"],
		Model[Sample,StockSolution,"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, 2x Master Mix"],
		Model[Sample,"Bio-Rad ddPCR Multiplex Supermix"],
		Model[Sample,"Bio-Rad ddPCR Supermix for Probes"],
		Model[Sample,"Bio-Rad ddPCR Supermix for Probes (No dUTP)"],
		Model[Sample,"Bio-Rad ddPCR Supermix for Residual DNA Quantification"]
	};

	(* Download reverse transcription master mix stock solution VolumeIncrements *)
	recommendedRTStockSolution={
		Model[Sample,StockSolution,"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, 2x Master Mix"]
	};

	(* Pull out the options that have objects whose information we need to download *) (*do we need to differentiate between objects and models?*)
	nonAutomaticOptionsWithObjects=Flatten[
		{
			Lookup[digitalPCROptionsAssociation,
				{
					Diluent,
					DropletCartridge,
					DropletGeneratorOil,
					DropletReaderOil,
					PlateSealFoil
				}
			],
			Model[Container,Rack,"PX1 sealer adapter for GCR96 droplet cartridge"]
		}
	];

	(* Pull out the options that may have objects when they are not defaulted as 'Automatic' *)
	automaticOptionsWithPotentialObjects=Cases[
		Flatten[Lookup[digitalPCROptionsAssociation,{MasterMix,PassiveWellBuffer,DropletCartridge}]],
		ObjectP[]
	];

	(* Get the instrument option to download its model, if relevant. This is necessary for compatibility checks. *)
	instrumentOptions = Lookup[expandedSafeOps, {Instrument,PlateSealInstrument}];

	(* Get all the liquid handler-compatible containers, with the low-volume containers prepended *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	downloadedPackets = Quiet[
		Download[
			{
				listedSamples,
				oligomerObjects,
				oligomerModels,
				allPrimerObjects,
				allProbeObjects,
				digitalPCRCompatibleFluorophores,
				nonAutomaticOptionsWithObjects,
				automaticOptionsWithPotentialObjects,
				instrumentOptions,
				liquidHandlerContainers,
				recommendedMasterMixes,
				recommendedRTStockSolution
			},
			{
				{Packet[Composition,IncompatibleMaterials],Packet[Composition[[All,2]][{Name,Fluorescent,FluorescenceExcitationMaximums,FluorescenceEmissionMaximums,FluorescenceLabelingTarget,DetectionLabels}]]},
				{oligomerObjectDownloadFields,Packet[Container[objectContainerFields]],Packet[Container[Model][modelContainerFields]]},
				{oligomerModelDownloadFields},
				{Packet[Composition],Packet[Composition[[All,2]][{MolecularWeight}]]},(*already included in oligomerObjectDownloadFields - verify before deleting*)
				{Packet[Composition],Packet[Composition[[All,2]][{Name,Fluorescent,FluorescenceExcitationMaximums,FluorescenceEmissionMaximums,FluorescenceLabelingTarget,DetectionLabels,MolecularWeight}]]},(*Need to download fields form detectionlabels if they are fluorescent*)
				{Packet[Name,Fluorescent,FluorescenceExcitationMaximums, FluorescenceEmissionMaximums,FluorescenceLabelingTarget]},
				{Packet[Name,Deprecated,Positions,AvailableLayouts,TareWeight]},(*Need anything else?*)
				{Packet[Model,Name,UsedAsSolvent,ConcentratedBufferDiluent,ConcentratedBufferDilutionFactor,BaselineStock,IncompatibleMaterials],Packet[Model[{Name,UsedAsSolvent,ConcentratedBufferDiluent,ConcentratedBufferDilutionFactor,BaselineStock,MasterMixConcentrationFactor,IncompatibleMaterials}]]},
				{Packet[Name, Model, WettedMaterials]},
				{Evaluate[Packet@@modelContainerFields]},
				{Packet[Name,UsedAsSolvent,ConcentratedBufferDiluent,ConcentratedBufferDilutionFactor,BaselineStock,IncompatibleMaterials]},
				{Packet[Name,VolumeIncrements]}
			},
			Cache->cache,
			Simulation -> updatedSimulation,
			Date->Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* Add downloaded information to cache ball *)
	cacheBall=FlattenCachePackets[{cache,downloadedPackets}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentDigitalPCROptions[expandedSamples,expandedPrimerPairSamples,expandedProbeSamples,expandedSafeOps,Cache->cacheBall,Simulation -> updatedSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentDigitalPCROptions[expandedSamples,expandedPrimerPairSamples,expandedProbeSamples,expandedSafeOps,Cache->cacheBall, Simulation -> updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	(* TODO: May need to manually collapse Forward/ReversePrimerVolume options since they index match more deeply *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentDigitalPCR,
		resolvedOptions,
		Ignore->ReplaceRule[listedOptions, ContainerOut -> Lookup[resolvedOptions, ContainerOut]],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentDigitalPCR,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		experimentDigitalPCRResourcePackets[expandedSamples,expandedPrimerPairSamples,expandedProbeSamples,expandedSafeOps,resolvedOptions,Cache->cacheBall,Simulation -> updatedSimulation,Output->{Result,Tests}],
		{experimentDigitalPCRResourcePackets[expandedSamples,expandedPrimerPairSamples,expandedProbeSamples,expandedSafeOps,resolvedOptions,Cache->cacheBall,Simulation -> updatedSimulation],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentDigitalPCR,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[inheritedOptions,Upload],
			Confirm->Lookup[inheritedOptions,Confirm],
			CanaryBranch->Lookup[inheritedOptions,CanaryBranch],
			ParentProtocol->Lookup[inheritedOptions,ParentProtocol],
			Priority->Lookup[inheritedOptions,Priority],
			StartDate->Lookup[inheritedOptions,StartDate],
			HoldOrder->Lookup[inheritedOptions,HoldOrder],
			QueuePosition->Lookup[inheritedOptions,QueuePosition],
			ConstellationMessage->Object[Protocol,DigitalPCR],
			Cache->cacheBall,
			Simulation -> updatedSimulation
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentDigitalPCR,collapsedResolvedOptions],
		Preview -> Null
	}

];



(*---Function overload accepting sample/container objects as sample inputs and sample/container/model objects or Nulls as primer pair inputs and probe inputs---*)

ExperimentDigitalPCR[
	mySampleContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],
	myPrimerPairSamples:ListableP[
		Alternatives[
			{{(ObjectP[{Object[Container],Model[Sample],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}),(ObjectP[{Object[Container],Model[Sample],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]})}..},
			{Null,Null}
		]
	],
	myProbeSamples:ListableP[
		Alternatives[
			{(ObjectP[{Object[Container],Model[Sample],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]})..},
			Null
		]
	],
	myOptions:OptionsPattern[ExperimentDigitalPCR]
]:=Module[
	{
		listedOptions,listedSampleContainers,listedPrimerPairSamples,listedProbeSamples,flatPrimerPairSamples,primerPairLengths,flatProbeSamples,probeLengths,
		initialListedPrimerPairSamples,initialListedProbeSamples,nestedIndexMatchingInputsCheck,nestedIndexMatchingInputsResult,
		concatenatedOligoInputs,flatConcatenatedOligoInputs,concatenatedOligoInputsLengths,myFlatConcatenatedOligoInputsWithPreparedSamples,
		concatenatedOligoInputsWithPreparedSamples,sampleCache,
		preliminaryOptionsWithPreparedSamples,preliminarySamplePreparationCache,
		myFlatPrimerPairSamplesWithPreparedSamples,secondaryOptionsWithPreparedSamples,secondarySamplePreparationCache,myFlatProbeSamplesWithPreparedSamples,
		flattenedPrimerSamplesWithPreparedSamples,nullPrimerSamplePositions,nonNullPrimerSamples,
		nonNullPrimerContainerToSampleResult,primerContainerToSampleOutput,primerContainerToSampleTests,
		primerContainerToSampleResult,myPrimerPairSamplesWithPreparedSamplesNestedNulls,
		outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,primerPairSamples,
		nullProbeSamplePositions,nonNullProbeSamples,nonNullProbeContainerToSampleResult,
		probeContainerToSampleOutput,probeContainerToSampleTests,probeContainerToSampleResult,
		myProbeSamplesWithPreparedSamples,probeSamples,combinedContainerToSampleTests,
		finalPrimerPairSamples,finalProbeSamples,myOptionsWithPreparedSamplesWithModifiedPreparedModelOps,
		updatedSimulation,containerToSampleResult,containerToSampleOutput,updatedCache,samples,sampleOptions,finalSamples,
		containerToSampleTests, containerToSampleSimulation, primerContainerToSampleSimulation, probeContainerToSampleSimulation
	},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];
	listedSampleContainers=ToList[mySampleContainers];

	initialListedPrimerPairSamples=Switch[
		myPrimerPairSamples,
		Alternatives[{{ObjectP[]|_String,ObjectP[]|_String}..},{Null,Null}],{myPrimerPairSamples},
		{Alternatives[{{ObjectP[]|_String,ObjectP[]|_String}..},{Null,Null}]..},myPrimerPairSamples
	];

	listedPrimerPairSamples=Map[
		Function[{primerPairSampleListPerInput},
			If[MatchQ[primerPairSampleListPerInput,{Null,Null}],
				List[{Null,Null}],
				primerPairSampleListPerInput
			]
		],
		initialListedPrimerPairSamples
	];

	initialListedProbeSamples=Switch[
		myProbeSamples,
		Alternatives[{(ObjectP[]|_String)..},Null],{myProbeSamples},
		{Alternatives[{(ObjectP[]|_String)..},Null]..},myProbeSamples
	];

	listedProbeSamples=Map[
		Function[{probeSampleListPerInput},
			If[MatchQ[probeSampleListPerInput,Null],
				List[Null],
				probeSampleListPerInput
			]
		],
		initialListedProbeSamples
	];

	(* primer and probe inputs should be expanded to match samples here otherwise VILQ will fail*)
	(* Check that primer and probe inputs are properly index matched *)
	nestedIndexMatchingInputsCheck=If[SameLengthQ[listedSampleContainers,listedPrimerPairSamples,listedProbeSamples],
		MapThread[
			Function[{primerPairListPerSample,probeListPerSample},
				!SameLengthQ[primerPairListPerSample,probeListPerSample]
			],
			{listedPrimerPairSamples,listedProbeSamples}
		],
		False
	];

	(* If index-matching of primerPairs and probes for each sample is not right, throw InvalidInputs error *)
	nestedIndexMatchingInputsResult=Check[
		If[AnyTrue[nestedIndexMatchingInputsCheck,TrueQ],Message[Error::InvalidPrimerProbeInputs]],
		$Failed,
		{Error::InvalidPrimerProbeInputs}
	];

	(* If nested index-matching has problems, return early  *)
	If[MatchQ[nestedIndexMatchingInputsResult,$Failed],
		Return[$Failed]
	];

	(* Flatten listedPrimerPairSamples to a list of primer pairs *)
	flatPrimerPairSamples=Flatten[listedPrimerPairSamples,1];

	(* Get the number of primer pairs per sample for bringing back the nested form of listedPrimerPairSamples *)
	primerPairLengths=Length/@listedPrimerPairSamples;

	(* Flatten listedPrimerPairSamples to a list of probes *)
	flatProbeSamples=Flatten[listedProbeSamples,1];

	(* Get the number of probes per sample for bringing back the nested form of listedProbeSamples *)
	probeLengths=Length/@listedProbeSamples;

	(* Create a mega-list of all input objects for simulateSamplePreparationPacketsNew *)
	concatenatedOligoInputs=Join[listedSampleContainers,flatPrimerPairSamples,flatProbeSamples];

	(* Flatten to a list of singletons *)
	flatConcatenatedOligoInputs=Flatten[concatenatedOligoInputs];

	(* Get lengths of each list to break them back out to individual lists *)
	concatenatedOligoInputsLengths=Length/@{listedSampleContainers,flatPrimerPairSamples,flatProbeSamples};

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)

		{myFlatConcatenatedOligoInputsWithPreparedSamples,myOptionsWithPreparedSamplesWithModifiedPreparedModelOps,updatedSimulation}=simulateSamplePreparationPacketsNew[
				ExperimentDigitalPCR,
				flatConcatenatedOligoInputs,
				listedOptions
			],
			$Failed,
			{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
		];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		Return[$Failed]
	];

	(* Bring back concatenatedOligoInputs list structure *)
	concatenatedOligoInputsWithPreparedSamples=Unflatten[myFlatConcatenatedOligoInputsWithPreparedSamples,concatenatedOligoInputs];

	(* Separate mega-list to three lists: samples, primerpairs and probes *)
	{mySamplesWithPreparedSamples,myFlatPrimerPairSamplesWithPreparedSamples,myFlatProbeSamplesWithPreparedSamples}=TakeList[concatenatedOligoInputsWithPreparedSamples,concatenatedOligoInputsLengths];

	(* put the "proper" specified preparatory models in here now *)
	(* need to switch back to the not-expanded version of this option again *)
	(* Our current index matching system does not support ModelInputOptions match to 3 input sample groups *)
	(* Have to Null the value but it is okay since LabelSample has been created in PreparatoryUnitOperations during simulateSamplePreparationPacketsNew so ModelInputOptions are useless now *)
	myOptionsWithPreparedSamples = ReplaceRule[myOptionsWithPreparedSamplesWithModifiedPreparedModelOps, {PreparedModelContainer -> Null, PreparedModelAmount -> Null}];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests, containerToSampleSimulation}=containerToSampleOptions[
			ExperimentDigitalPCR,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation}=containerToSampleOptions[
				ExperimentDigitalPCR,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->{Result, Simulation},
				Simulation -> updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(*- Primers -*)
	(* Flatten primer list *)
	flattenedPrimerSamplesWithPreparedSamples=Flatten[myFlatPrimerPairSamplesWithPreparedSamples];

	(* If the whole list is not null, get positions of Null in the list *)
	nullPrimerSamplePositions=If[NullQ[flattenedPrimerSamplesWithPreparedSamples],
		{},
		Position[flattenedPrimerSamplesWithPreparedSamples,Null]
	];

	(* Get only samples that are not null *)
	nonNullPrimerSamples=Cases[flattenedPrimerSamplesWithPreparedSamples,Except[Null]];

	(* Convert our given containers into samples and sample index-matched options. *)
	nonNullPrimerContainerToSampleResult=If[Length[nonNullPrimerSamples]>0,
		If[gatherTests,
			(* We are gathering tests. This silences any messages being thrown. *)
			{primerContainerToSampleOutput,primerContainerToSampleTests, primerContainerToSampleSimulation}=containerToSampleOptions[
				ExperimentDigitalPCR,
				Flatten[nonNullPrimerSamples,1],
				myOptionsWithPreparedSamples,
				Output->{Result,Tests, Simulation},
				Simulation -> containerToSampleSimulation
			];

			(* Therefore, we have to run the tests to see if we encountered a failure. *)
			If[RunUnitTest[<|"Tests"->primerContainerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
				Null,
				$Failed
			],

			(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
			Check[
				{primerContainerToSampleOutput, primerContainerToSampleSimulation}=containerToSampleOptions[
					ExperimentDigitalPCR,
					Flatten[nonNullPrimerSamples,1],
					myOptionsWithPreparedSamples,
					Output->{Result, Simulation},
					Simulation -> containerToSampleSimulation
				],
				$Failed,
				{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
			]
		],
		primerContainerToSampleSimulation = containerToSampleSimulation;
		{flattenedPrimerSamplesWithPreparedSamples}
	];

	(* Insert Null at the original places *)
	primerContainerToSampleResult=If[Length[nonNullPrimerSamples]>0,
		Fold[Insert[#1,Null,#2]&,First[nonNullPrimerContainerToSampleResult],nullPrimerSamplePositions],
		flattenedPrimerSamplesWithPreparedSamples
	];

	(* Re-create the list structure similar to input, but with nested Null pairs *)
	myPrimerPairSamplesWithPreparedSamplesNestedNulls=If[Length[nonNullPrimerSamples] > 0,
		TakeList[
			Partition[Flatten[Most[primerContainerToSampleResult]],2],
			primerPairLengths
		],
		TakeList[
			Partition[Flatten[primerContainerToSampleResult],2],
			primerPairLengths
		]
	];

	(* Flatten nesting of Null pairs to match input pattern *)
	primerPairSamples=Map[
		Function[{primerPairSampleListPerInput},
			If[MatchQ[primerPairSampleListPerInput,{{Null,Null}}],
				{Null,Null},
				primerPairSampleListPerInput
			]
		],
		myPrimerPairSamplesWithPreparedSamplesNestedNulls
	];

	(*- Probes -*)
	(* If the whole list is not null, get positions of Null in the list *)
	nullProbeSamplePositions=If[NullQ[myFlatProbeSamplesWithPreparedSamples],
		{},
		Position[myFlatProbeSamplesWithPreparedSamples,Null]
	];

	(* Get only samples that are not null *)
	nonNullProbeSamples=Cases[myFlatProbeSamplesWithPreparedSamples,Except[Null]];

	(* Convert our given containers into samples and sample index-matched options. *)
	nonNullProbeContainerToSampleResult=If[Length[nonNullProbeSamples]>0,
		If[gatherTests,
			(* We are gathering tests. This silences any messages being thrown. *)
			{probeContainerToSampleOutput,probeContainerToSampleTests, probeContainerToSampleSimulation}=containerToSampleOptions[
				ExperimentDigitalPCR,
				nonNullProbeSamples,
				myOptionsWithPreparedSamples,
				Output->{Result,Tests, Simulation},
				Simulation -> primerContainerToSampleSimulation
			];

			(* Therefore, we have to run the tests to see if we encountered a failure. *)
			If[RunUnitTest[<|"Tests"->probeContainerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
				Null,
				$Failed
			],

			(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
			Check[
				{probeContainerToSampleOutput, probeContainerToSampleSimulation}=containerToSampleOptions[
					ExperimentDigitalPCR,
					nonNullProbeSamples,
					myOptionsWithPreparedSamples,
					Output->{Result, Simulation},
					Simulation -> primerContainerToSampleSimulation
				],
				$Failed,
				{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
			]
		],
		probeContainerToSampleSimulation = primerContainerToSampleSimulation;
		{myFlatProbeSamplesWithPreparedSamples}
	];

	(* Insert Null at the original places *)
	probeContainerToSampleResult=If[Length[nonNullProbeSamples]>0,
		Fold[Insert[#1,Null,#2]&,First[nonNullProbeContainerToSampleResult],nullProbeSamplePositions],
		myFlatProbeSamplesWithPreparedSamples
	];

	(* Re-create the list structure similar to input, but with nested Null pairs *)
	myProbeSamplesWithPreparedSamples=If[Length[nonNullProbeSamples] > 0,
		TakeList[Flatten[Most[probeContainerToSampleResult]],probeLengths],
		TakeList[Flatten[probeContainerToSampleResult],probeLengths]
	];

	(* Flatten nesting of Null probes to match input pattern *)
	probeSamples=Map[
		Function[{probeSampleListPerInput},
			If[MatchQ[probeSampleListPerInput,{Null}],
				Null,
				probeSampleListPerInput
			]
		],
		myProbeSamplesWithPreparedSamples
	];

	(* Combine sample, primer and probe input container-to-sample tests *)
	combinedContainerToSampleTests=If[gatherTests,
		Which[
			And[Length[nonNullPrimerSamples],Length[nonNullProbeSamples]>0],Join[containerToSampleTests,primerContainerToSampleTests,probeContainerToSampleTests],
			Length[nonNullPrimerSamples]>0,Join[containerToSampleTests,primerContainerToSampleTests],
			Length[nonNullProbeSamples]>0,Join[containerToSampleTests,probeContainerToSampleTests],
			True,containerToSampleTests
		]
	];

	updatedCache=Lookup[listedOptions,Cache,{}];

	(* If we were given an empty container, return early. *)
	If[Or[MatchQ[containerToSampleResult,$Failed],MatchQ[nonNullPrimerContainerToSampleResult,$Failed],MatchQ[nonNullProbeContainerToSampleResult,$Failed]],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> combinedContainerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* When primers/probes are Null, we'll assume that it is a prepared plate and sample must contain oligomer models. Samples without oligomers are assumed to be passive buffer samples used for droplet generation only and removed from sample input list. *)
		finalSamples=If[NullQ[primerPairSamples]&&NullQ[probeSamples],
			Module[{sampleCompositionPackets,samplesWithOligomers},
				(* Need to download sample composition to check if a sample has oligomers *)
				sampleCompositionPackets=Download[samples,Packet[Composition],Cache->updatedCache, Simulation -> probeContainerToSampleSimulation];
				(* Remove any samples that do not have a single identity oligomer in the composition *)
				samplesWithOligomers=Cases[
					sampleCompositionPackets,
					(* This function identifies if the composition has an oligomer *)
					_?(Function[samplePacket,
						Module[{compositionModelsList},
							(* Lookup composition table from the downloaded packet *)
							compositionModelsList=Lookup[samplePacket,Composition,{{Null,Null}}];
							(* If any of the identity models are of type Model[Molecule,Oligomer], output True *)
							AnyTrue[compositionModelsList[[All,2]],MatchQ[#,ObjectP[Model[Molecule,Oligomer]]]&]
						]
					])
				];
				(* Output a list of Objects from the filtered sample packets; Output Null if so sample has identity oligomer models in composition *)
				Lookup[samplesWithOligomers,Object,Null]
			],
			samples
		];

		(* If primerPairSamples is Null and does not match sample length, expand it to match sample *)
		finalPrimerPairSamples=If[NullQ[primerPairSamples]&&MatchQ[Length[primerPairSamples],1],
			ConstantArray[{Null,Null},Length[finalSamples]],
			primerPairSamples
		];

		(* If primerPairSamples is Null and does not match sample length, expand it to match sample *)
		finalProbeSamples=If[NullQ[probeSamples]&&MatchQ[Length[probeSamples],1],
			ConstantArray[Null,Length[finalSamples]],
			probeSamples
		];

		(* Call our main function with our samples and converted options. *)
		ExperimentDigitalPCR[
			finalSamples,
			finalPrimerPairSamples,
			finalProbeSamples,
			ReplaceRule[sampleOptions,Simulation -> probeContainerToSampleSimulation]
		]
	]
];

(*---Function definition accepting sample/container objects as sample inputs and no primer pair or probe inputs---*)
ExperimentDigitalPCR[
	mySamples:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],
	myOptions:OptionsPattern[ExperimentDigitalPCR]
]:=ExperimentDigitalPCR[
	mySamples,
	Table[{Null,Null},Length[ToList[mySamples]]],
	Table[Null,Length[ToList[mySamples]]],
	myOptions
];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentDigitalPCROptions*)


DefineOptions[
	resolveExperimentDigitalPCROptions,
	Options:>{HelperOutputOption,CacheOption, SimulationOption}
];

resolveExperimentDigitalPCROptions[
	myListedSamples:ListableP[ObjectP[Object[Sample]]],
	myListedPrimerPairSamples:ListableP[
		Alternatives[
			{{ObjectP[{Object[Sample],Model[Sample]}],ObjectP[{Object[Sample],Model[Sample]}]}..},
			{Null,Null}
		]
	],
	myListedProbeSamples:ListableP[
		Alternatives[
			{ObjectP[{Object[Sample],Model[Sample]}]..},
			Null
		]
	],
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentDigitalPCROptions]
]:=Module[
	{outputSpecification,output,gatherTests,messages,notInEngine,inheritedCache,samplePrepOptions,
		allSampleObjects,allSampleObjectPackets,
		digitalPCROptions,instrument,dropletCartridge,dropletGeneratorOil,dropletReaderOil,diluent,
		passiveWellBuffer,plateSealInstrument,plateSealFoil,
		sampleProcessSteps,fastTrack,name,parentProtocol,samplePackets,sampleContainerPackets,
		sampleContainerModels,simulatedSamples,resolvedSamplePrepOptions,simulation, updatedSimulation,samplePrepTests,
		expandedListedPrimerPairSamples,expandedListedProbeSamples,initialExpandedListedPrimerPairSamples,initialExpandedListedProbeSamples,
		oligomerSampleObjects,oligomerModelSamples,allModelPackets,
		oligomerSamplePackets,oligomerModelSamplePackets,oligomerSampleObjectModelPackets,oligomerSampleObjectFields,oligomerModelSampleFields,
		oligomerSampleObjectPackets,discardedSamplePackets,discardedInvalidInputs,discardedTest,
		deprecatedSampleModelPackets,deprecatedInvalidInputs,deprecatedTest,
		digitalPCROptionsAssociation,containerModelForPreparedPlate,preparedPlateValidityCheck,
		unpreparedSampleContainers,unpreparedSampleContainerCheck,
		precisionOptions,precisionOptionUnits,initialRoundedOptions,initialOptionPrecisionTests,nestedPrecisionOptions,nestedPrecisionOptionUnits,roundedOptions,nestedOptionPrecisionTests,precisionTests,
		validName,invalidNameOptions,validNameTest,reverseTranscriptionMasterMixModel,recommendedMasterMixModels,compatibleDropletCartridge,
		compatibleExcitationWavelengths,compatibleEmissionWavelengths,excitationToEmission,emissionToExcitation,compatibleFluorophoreModelMolecules,excitationEmissionToFluorophore,
		cartridgeWellIndices,potentialActiveWells,potentialPassiveWells,
		probePackets,primerPairPackets,flatPrimerPairPackets,flatProbePackets,initialSamplePackets,
		initialAllSampleObjectPackets,primerGradientAnnealingRowWithChecks,
		(* Local Helpers: *)masterMixModelFinder,identityOligomerFinder,sampleOligomerFluorescencePropertyFinder,fluorescencePerIdentityObject,molarConcentrationFinder,
		mapThreadFriendlyOptions,
		(* Resolved Options: *)
		resolvedPreparedPlate,
		resolvedSampleVolume,
		resolvedSerialDilutionCurve,
		resolvedDilutionMixVolume,
		resolvedDilutionNumberOfMixes,
		resolvedDilutionMixRate,

		resolvedProbeFluorophore,
		resolvedProbeExcitationWavelength,
		resolvedProbeEmissionWavelength,
		resolvedReferenceProbeFluorophore,
		resolvedReferenceProbeExcitationWavelength,
		resolvedReferenceProbeEmissionWavelength,

		resolvedAmplitudeMultiplexing,

		resolvedPremixedPrimerProbe,
		resolvedReferencePremixedPrimerProbe,
		resolvedProbeConcentration,
		resolvedProbeVolume,
		resolvedReferenceProbeConcentration,
		resolvedReferenceProbeVolume,
		resolvedForwardPrimerConcentration,
		resolvedForwardPrimerVolume,
		resolvedReversePrimerConcentration,
		resolvedReversePrimerVolume,
		resolvedReferenceForwardPrimerConcentration,
		resolvedReferenceForwardPrimerVolume,
		resolvedReferenceReversePrimerConcentration,
		resolvedReferenceReversePrimerVolume,

		resolvedReverseTranscription,
		resolvedReverseTranscriptionTime,
		resolvedReverseTranscriptionTemperature,
		resolvedReverseTranscriptionRampRate,

		resolvedMasterMix,
		resolvedMasterMixConcentrationFactor,
		resolvedMasterMixVolume,
		resolvedDiluentVolume,

		resolvedActivation,
		resolvedActivationTime,
		resolvedActivationTemperature,
		resolvedActivationRampRate,

		resolvedPrimerAnnealing,
		resolvedPrimerAnnealingTime,
		resolvedPrimerAnnealingTemperature,
		resolvedPrimerAnnealingRampRate,

		resolvedPrimerGradientAnnealing,
		resolvedPrimerGradientAnnealingMinTemperature,
		resolvedPrimerGradientAnnealingMaxTemperature,

		resolvedExtension,
		resolvedExtensionTime,
		resolvedExtensionTemperature,
		resolvedExtensionRampRate,

		resolvedPolymeraseDegradation,
		resolvedPolymeraseDegradationTime,
		resolvedPolymeraseDegradationTemperature,
		resolvedPolymeraseDegradationRampRate,

		resolvedForwardPrimerStorageCondition,
		resolvedReversePrimerStorageCondition,
		resolvedProbeStorageCondition,
		resolvedReferenceForwardPrimerStorageCondition,
		resolvedReferenceReversePrimerStorageCondition,
		resolvedReferenceProbeStorageCondition,
		resolvedMasterMixStorageCondition,

		resolvedActiveWell,
		resolvedPassiveWells,
		resolvedPrimerGradientAnnealingRow,

		(* Warnings, Errors, Tests: *)
		noMultiplexAvailableErrors,noMultiplexAvailableInvalidInputs,noMultiplexAvailableTest,
		cartridgeLengthError,cartridgeLengthInvalidOptions,cartridgeLengthTest,
		repeatedCartridgeError,repeatedCartridgeInvalidOptions,repeatedCartridgeTest,
		preparedPlateCartridgeMismatchError,preparedPlateCartridgeMismatchInvalidOptions,preparedPlateCartridgeMismatchTest,
		liquidStateCheck,liquidStateInvalidInputs,liquidStateTest,
		invalidMasterMixStorageConditionOptions,masterMixStorageConditionErrors,validMasterMixStorageConditionTest,
		compatibleMaterialsInvalidOption,compatibleMaterialsBool,compatibleMaterialsTests,
		totalVolumeInvalidOptions,totalVolumeTest,
		activeWellPreparedPlateCheck,activeWellPreparedPlateInvalidOptions,activeWellPreparedPlateTest,
		overConstrainedRowOptionsErrors,overConstrainedRowOptionsInvalidOptions,overConstrainedRowOptionsTest,
		primerGradientAnnealingRowTemperatureMismatchInvalidOptions,primerGradientAnnealingRowTemperatureMismatchTest,primerGradientAnnealingRowTemperatureMismatchErrors,
		primerAnnealingMismatchInvalidOptions,primerAnnealingMismatchTest,
		primerGradientAnnealingMismatchInvalidOptions,primerGradientAnnealingMismatchTest,
		invalidForwardPrimerStorageConditionOptions,validForwardPrimerStorageConditionTest,
		invalidReversePrimerStorageConditionOptions,validReversePrimerStorageConditionTest,
		invalidProbeStorageConditionOptions,validProbeStorageConditionTest,
		invalidReferenceForwardPrimerStorageConditionOptions,validReferenceForwardPrimerStorageConditionTest,
		invalidReferenceReversePrimerStorageConditionOptions,validReferenceReversePrimerStorageConditionTest,
		invalidReferenceProbeStorageConditionOptions,validReferenceProbeStorageConditionTest,
		sampleDilutionMismatchErrors,sampleDilutionMismatchInvalidOptions,sampleDilutionMismatchTest,
		sampleVolumeMismatchErrors,sampleVolumeMismatchInvalidOptions,sampleVolumeMismatchTest,
		singleFluorophorePerProbeInvalidInputs,singleFluorophorePerProbeTest,
		singleFluorophorePerReferenceProbeInvalidOptions,singleFluorophorePerReferenceProbeTest,
		amplitudeMultiplexingInvalidOptions,amplitudeMultiplexingTest,
		premixedPrimerProbeInvalidOptions,premixedPrimerProbeTest,
		referencePremixedPrimerProbeInvalidOptions,referencePremixedPrimerProbeTest,
		probeStockConcentrationInvalidOptions,probeStockConcentrationTest,
		referenceProbeStockConcentrationInvalidOptions,referenceProbeStockConcentrationTest,
		probeConcentrationVolumeMismatchInvalidOptions,probeConcentrationVolumeMismatchOptionTest,
		probeStockConcentrationTooLowInvalidOptions,probeStockConcentrationTooLowTest,
		referenceProbeConcentrationVolumeMismatchInvalidOptions,referenceProbeConcentrationVolumeMismatchOptionTest,
		referenceProbeStockConcentrationTooLowInvalidOptions,referenceProbeStockConcentrationTooLowTest,
		forwardPrimerStockConcentrationInvalidOptions,forwardPrimerStockConcentrationTest,
		forwardPrimerConcentrationVolumeMismatchInvalidOptions,forwardPrimerConcentrationVolumeMismatchOptionTest,
		forwardPrimerStockConcentrationTooLowInvalidOptions,forwardPrimerStockConcentrationTooLowTest,
		reversePrimerStockConcentrationInvalidOptions,reversePrimerStockConcentrationTest,
		probeStockConcentrationAccuracyTest,referenceProbeStockConcentrationAccuracyTest,
		forwardPrimerStockConcentrationAccuracyTest,reversePrimerStockConcentrationAccuracyTest,
		referenceForwardPrimerStockConcentrationAccuracyTest,referenceReversePrimerStockConcentrationAccuracyTest,
		reversePrimerConcentrationVolumeMismatchInvalidOptions,reversePrimerConcentrationVolumeMismatchOptionTest,
		reversePrimerStockConcentrationTooLowInvalidOptions,reversePrimerStockConcentrationTooLowTest,
		referenceForwardPrimerStockConcentrationInvalidOptions,referenceForwardPrimerStockConcentrationTest,
		referenceForwardPrimerConcentrationVolumeMismatchInvalidOptions,referenceForwardPrimerConcentrationVolumeMismatchOptionTest,
		referenceForwardPrimerStockConcentrationTooLowInvalidOptions,referenceForwardPrimerStockConcentrationTooLowTest,
		referenceReversePrimerStockConcentrationInvalidOptions,referenceReversePrimerStockConcentrationTest,
		referenceReversePrimerConcentrationVolumeMismatchInvalidOptions,referenceReversePrimerConcentrationVolumeMismatchOptionTest,
		referenceReversePrimerStockConcentrationTooLowInvalidOptions,referenceReversePrimerStockConcentrationTooLowTest,
		diluentVolumeInvalidOptions,diluentVolumeTest,extensionMismatchInvalidOptions,extensionMismatchTest,
		polymeraseDegradationMismatchInvalidOptions,polymeraseDegradationMismatchTest,
		primerProbeOptionsLengthInvalidOptions,primerProbeOptionsLengthTest,
		referencePrimerProbeOptionsLengthInvalidOptions,referencePrimerProbeOptionsLengthTest,
		passiveWellsAssignmentCheck,passiveWellsAssignmentInvalidOptions,passiveWellsAssignmentCheckTest,
		activeWellInputFormatCheck,activeWellUniqueCheck,activeWellInvalidOptions,activeWellTest,
		tooManyPlatesCheck,tooManyPlatesInvalidOptions,tooManyPlatesTest,
		thermocyclingOptionsMismatchCheck,thermocyclingOptionsMismatchInvalidOptions,thermocyclingOptionsMismatchTest,
		compositionInformedCheck,nullCompositionInvalidInputs,nullCompositionTest,
		preparedPlateInvalidInputs,preparedPlateInvalidOptions,preparedPlateTest,
		inputSampleContainerInvalidInputs,inputSampleContainerTest,
		tooManyTargetsMultiplexedWarnings,tooManyTargetsMultiplexedTest,
		probeFluorophoreNullInvalidOptions,probeFluorophoreNullOptionsErrors,probeFluorophoreNullOptionsTest,
		probeFluorophoreIncompatibleInvalidOptions,probeFluorophoreIncompatibleOptionsErrors,probeFluorophoreIncompatibleTest,
		probeFluorophoreLengthMismatchInvalidOptions,probeFluorophoreLengthMismatchErrors,probeFluorophoreLengthMismatchTest,
		referenceProbeFluorophoreNullInvalidOptions,referenceProbeFluorophoreNullOptionsErrors,referenceProbeFluorophoreNullOptionsTest,
		referenceProbeFluorophoreIncompatibleInvalidOptions,referenceProbeFluorophoreIncompatibleOptionsErrors,referenceProbeFluorophoreIncompatibleTest,
		referenceProbeFluorophoreLengthMismatchInvalidOptions,referenceProbeFluorophoreLengthMismatchErrors,referenceProbeFluorophoreLengthMismatchTest,
		reverseTranscriptionMismatchInvalidOptions,reverseTranscriptionMismatchOptionsErrors,reverseTranscriptionMismatchTest,
		masterMixConcentrationFactorNotInformedWarnings,masterMixConcentrationFactorNotInformedTest,
		masterMixQuantityMismatchWarnings,masterMixQuantityMismatchTest,
		masterMixMismatchInvalidOptions,masterMixMismatchOptionsErrors,masterMixMismatchTest,
		activationMismatchInvalidOptions,activationMismatchOptionsErrors,activationMismatchTest,
		singleFluorophorePerProbeErrors,
		singleFluorophorePerReferenceProbeErrors,
		amplitudeMultiplexingErrors,
		primerProbeOptionsLengthErrors,
		referencePrimerProbeOptionsLengthErrors,
		premixedPrimerProbeErrors,
		referencePremixedPrimerProbeErrors,
		probeStockConcentrationErrors,
		referenceProbeStockConcentrationErrors,
		probeConcentrationVolumeMismatchOptionErrors,
		probeStockConcentrationTooLowErrors,
		referenceProbeConcentrationVolumeMismatchOptionErrors,
		referenceProbeStockConcentrationTooLowErrors,
		forwardPrimerStockConcentrationErrors,
		forwardPrimerConcentrationVolumeMismatchOptionErrors,
		forwardPrimerStockConcentrationTooLowErrors,
		reversePrimerStockConcentrationErrors,
		reversePrimerConcentrationVolumeMismatchOptionErrors,
		reversePrimerStockConcentrationTooLowErrors,
		referenceForwardPrimerStockConcentrationErrors,
		referenceForwardPrimerConcentrationVolumeMismatchOptionErrors,
		referenceForwardPrimerStockConcentrationTooLowErrors,
		referenceReversePrimerStockConcentrationErrors,
		referenceReversePrimerConcentrationVolumeMismatchOptionErrors,
		referenceReversePrimerStockConcentrationTooLowErrors,
		diluentVolumeOptionErrors,
		totalVolumeErrors,
		primerAnnealingMismatchOptionsErrors,
		initialPrimerGradientAnnealingMismatchOptionsErrors,
		primerGradientAnnealingMismatchOptionsErrors,
		extensionMismatchOptionsErrors,
		polymeraseDegradationMismatchOptionsErrors,
		forwardPrimerStorageConditionErrors,
		reversePrimerStorageConditionErrors,
		probeStorageConditionErrors,
		referenceForwardPrimerStorageConditionErrors,
		referenceReversePrimerStorageConditionErrors,
		referenceProbeStorageConditionErrors,
		probeStockConcentrationAccuracyWarnings,
		referenceProbeStockConcentrationAccuracyWarnings,
		forwardPrimerStockConcentrationAccuracyWarnings,
		reversePrimerStockConcentrationAccuracyWarnings,
		referenceForwardPrimerStockConcentrationAccuracyWarnings,
		referenceReversePrimerStockConcentrationAccuracyWarnings,specifiedActiveWell,activeWellOptionLengthCheck,
		activeWellInvalidLengthOptions,activeWellInvalidLengthTest,aliquotAmounts,preResolvedAliquotBool,
		resolvedPostProcessingOptions,resolvedOptions,allTests,resultRule,testsRule,
		invalidInputs,invalidOptions,targetContainers,resolvedAliquotOptions,aliquotTests, simulatedCache},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];

	(* Determine whether messages should be thrown *)
	messages=!gatherTests;

	(*Determine if we are in Engine or not, in Engine we silence warnings*)
	notInEngine=!MatchQ[$ECLApplication,Engine];

	(*Fetch our options cache from the parent function*)
	inheritedCache=Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation = Lookup[ToList[myResolutionOptions],Simulation,{}];

	(* Separate out our digitalPCROptions from our Sample Prep options. *)
	{samplePrepOptions,digitalPCROptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentDigitalPCR,myListedSamples,samplePrepOptions,Cache->inheritedCache,Simulation -> simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentDigitalPCR,myListedSamples,samplePrepOptions,Cache->inheritedCache,Simulation -> simulation,Output->Result],{}}
	];

	(* Expand input primer pair list to match samples if only one primer pair is given for all samples *)
	initialExpandedListedPrimerPairSamples=If[Length[myListedPrimerPairSamples]==Length[myListedSamples],
		myListedPrimerPairSamples,
		ConstantArray[Flatten[myListedPrimerPairSamples,1],Length[myListedSamples]]
	];

	(* Wrap {Null,Null} elements with 1 more list to match structure of specified primerPair inputs *)
	expandedListedPrimerPairSamples=Map[
		Function[{sampleListPerInput},
			If[MatchQ[sampleListPerInput,{Null,Null}],
				List[{Null,Null}],
				sampleListPerInput
			]
		],
		initialExpandedListedPrimerPairSamples
	];

	(* Expand input probe list to match samples if only one probe is given for all samples *)
	initialExpandedListedProbeSamples=If[Length[myListedProbeSamples]==Length[myListedSamples],
		myListedProbeSamples,
		ConstantArray[Flatten[myListedProbeSamples],Length[myListedSamples]]
	];

	(* Wrap Null elements with 1 more list to match structure of specified probe inputs *)
	expandedListedProbeSamples=Map[
		Function[{sampleListPerInput},
			If[MatchQ[sampleListPerInput,{Null,Null}],
				List[{Null,Null}],
				sampleListPerInput
			]
		],
		initialExpandedListedProbeSamples
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	digitalPCROptionsAssociation=Association[digitalPCROptions];

	(*Pull out the options that are defaulted or specified that don't have precision*)
	{instrument,dropletCartridge,dropletGeneratorOil,dropletReaderOil,diluent,passiveWellBuffer,plateSealInstrument,plateSealFoil,sampleProcessSteps,fastTrack,name,parentProtocol}=Lookup[
		digitalPCROptionsAssociation,
		{Instrument,DropletCartridge,DropletGeneratorOil,DropletReaderOil,Diluent,PassiveWellBuffer,PlateSealInstrument,PlateSealFoil,SampleProcessSteps,FastTrack,Name,ParentProtocol}
	];

	(*-- DOWNLOAD PREPARATION --*)
	(* download - targetSamples, primersamples, probesamples, containerObject/Model packets *)

	(* Create lists of all inputs of type Object[Sample] and of type Model[Sample] for discarded or deprecated objects tests*)
	oligomerSampleObjects=Cases[
		Flatten[{simulatedSamples,expandedListedPrimerPairSamples,expandedListedProbeSamples}],
		ObjectP[Object[Sample]]
	];
	oligomerModelSamples=Cases[
		Flatten[{expandedListedPrimerPairSamples,expandedListedProbeSamples}],
		ObjectP[Model[Sample]]
	];

	(* Create a comprehensive list of all sample objects - samples, primers, probes, reference primers and reference probes *)
	allSampleObjects=Cases[Flatten[{simulatedSamples,myListedPrimerPairSamples,myListedProbeSamples,Lookup[digitalPCROptionsAssociation,{ReferencePrimerPairs,ReferenceProbes}]}],Except[Null]];

	(* Determine the fields that need to be downloaded *)
	oligomerSampleObjectFields=SamplePreparationCacheFields[Object[Sample],Format->Packet];
	oligomerModelSampleFields=SamplePreparationCacheFields[Model[Sample],Format->Packet];

	(* Extract the packets that we need from our downloaded cache. *)
	{
		oligomerSamplePackets,
		oligomerModelSamplePackets,
		initialSamplePackets,
		sampleContainerPackets,
		sampleContainerModels,
		initialAllSampleObjectPackets,
		flatPrimerPairPackets,
		flatProbePackets
	}=Quiet[
		Download[
			{
				oligomerSampleObjects,
				oligomerModelSamples,
				simulatedSamples,
				simulatedSamples,
				simulatedSamples,
				allSampleObjects,
				Flatten[expandedListedPrimerPairSamples],
				Flatten[expandedListedProbeSamples]
			},
			{
				{oligomerSampleObjectFields,Packet[Model[Deprecated]]},
				{oligomerModelSampleFields},
				{Packet[Composition,Model,Well]},
				{Packet[Container[{Object,Model,Contents}]]},
				{Packet[Container[Model[{MaxVolume}]]]},
				{Packet[Composition,State]},
				{Packet[Composition,Model,Well]},
				{Packet[Composition,Model,Well]}
			},
			Cache->inheritedCache,
			Simulation -> updatedSimulation
		],
		{Download::FieldDoesntExist}
	];

	simulatedCache =  FlattenCachePackets[{inheritedCache, oligomerSamplePackets, oligomerModelSamplePackets, initialSamplePackets, sampleContainerPackets, sampleContainerModels, initialAllSampleObjectPackets, flatPrimerPairPackets, flatProbePackets}];

	(* Pull out sample packets of the type Object[Sample] *)
	oligomerSampleObjectPackets=Cases[
		Flatten[oligomerSamplePackets],
		PacketP[Object[Sample]]
	];
	oligomerSampleObjectModelPackets=Cases[
		Flatten[oligomerSamplePackets],
		PacketP[Model[Sample]]
	];

	(* Combine all model packets into a single list *)
	allModelPackets=Join[oligomerSampleObjectModelPackets,oligomerModelSamplePackets];

	(*ORGANISE ALL PRIMER AND PROBE PACKETS WHAT ABOUT REFERENCES? - we can lookup using fetchPacketFromCache
	If primer and probe is null, get sample composition and check for fluorescent oligomers
	*)
	samplePackets=Flatten[initialSamplePackets,1];
	primerPairPackets=Unflatten[Flatten[flatPrimerPairPackets,1],expandedListedPrimerPairSamples];
	probePackets=Unflatten[Flatten[flatProbePackets,1],expandedListedProbeSamples];
	allSampleObjectPackets=Flatten[initialAllSampleObjectPackets,1];

	(*- HELPER FUNCTIONS -*)
	(* Helper function to find Model[Sample] object for master mix *)
	masterMixModelFinder[myInputObject:(ObjectP[{Object[Sample],Model[Sample]}]|Automatic|Null)]:=Which[
		MatchQ[myInputObject,(Automatic|Null)],myInputObject,
		(* If MasterMix is an Object[Sample], Download the Model *)
		MatchQ[myInputObject,ObjectP[Object[Sample]]],Download[Lookup[fetchPacketFromCache[myInputObject,simulatedCache],Model,Null],Object],
		(* If MasterMix is a Model[Sample], Download the object anyway to get ID in case it is referenced by Name *)
		MatchQ[myInputObject,ObjectP[Model[Sample]]],Download[myInputObject,Object],
		(* Catch-all *)
		True,Null
	];

	(* Helper function to find Identity Models for sample objects or packets *)
	identityOligomerFinder[
		myInputObjects:ListableP[ObjectP[{Object[Sample],Model[Sample]}]|Null]
	]:=Module[
		{
			listedMyInputObjects,listedMyInputObjectsWithID,inputObjectPackets,compositionFromPackets,oligomerModelLinks,oligomerModelObjectsList
		},
		(* Convert singleton input to a list *)
		listedMyInputObjects=If[MatchQ[myInputObjects,_List],myInputObjects,{myInputObjects}];
		(* If inputs are objects referenced by names or if they are packets, get the object with IDs *)
		listedMyInputObjectsWithID=Download[listedMyInputObjects,Object];
		(* Get packets for all input objects from simulatedCache *)
		inputObjectPackets=fetchPacketFromCache[#,simulatedCache]&/@listedMyInputObjectsWithID;
		(* Extract the composition field from packets; If packet is Null, convert it to an empty association and force {{Null,Null}} output to match the listed-ness of composition field *)
		compositionFromPackets=Lookup[inputObjectPackets/.{Null->Association[]},Composition,{{Null,Null}}];
		(* From the second column of compositions, get the model links that match oligomer identity model types *)
		oligomerModelLinks=Cases[#,ObjectP[Model[Molecule,Oligomer]]]&/@compositionFromPackets[[All,All,2]];
		(* Convert list of model links to object references *)
		oligomerModelObjectsList=Download[oligomerModelLinks,Object];
		(* Output found identity objects; For singleton inputs, output a list of identity objects and for a list of inputs, output a nested list of identity objects *)
		If[MatchQ[myInputObjects,_List],oligomerModelObjectsList,First[oligomerModelObjectsList]]
	];

	(* Helper function to check how many fluorophores are in each probe object; Takes a flat list of identity objects from identityOligomerFinder *)
	fluorescencePerIdentityObject[
		myInputObjects:{(ObjectP[]|Null)..}
	]:=Module[
		{myInputPackets,fluorescenceProperties,countsOfFluorescenceProperties},
		(* Get the packet for each oligomer object *)
		myInputPackets=fetchPacketFromCache[#,simulatedCache]&/@myInputObjects;
		(* From each packet, extract the Ex/Em and DetectionLabel values; Output Null for each for Null inputs*)
		fluorescenceProperties=Lookup[
			myInputPackets/.{Null-><||>},
			{FluorescenceExcitationMaximums,FluorescenceEmissionMaximums,DetectionLabels},
			{{{Null},{Null},{Null}}}];
		(* Count the number of entries in each field *)
		countsOfFluorescenceProperties={Count[#[[1]],_?QuantityQ],Count[#[[2]],_?QuantityQ],Count[#[[3]],ObjectP[]]}&/@fluorescenceProperties;
		(* Maximum number of entries is assumed as the number of fluorophores in the object *)
		Max@@#&/@countsOfFluorescenceProperties
	];

	(* Helper function to find the concentration of oligomer from sample object composition *)
	molarConcentrationFinder[
		myInputObject:ObjectP[{Object[Sample],Model[Sample]}],
		myInputCategory:Alternatives[TargetAssay,PrimerSet,None]
	]:=Module[
		{inputObjectPacket,objectComposition,targetComponentPosition,targetComponentConcentration},
		(* If the input is an object, get the related packet *)
		inputObjectPacket=If[MatchQ[myInputObject,PacketP[]],myInputObject,fetchPacketFromCache[myInputObject,simulatedCache]];
		(* Find the composition field and get concentrations in one column and models in another *)
		objectComposition=Transpose[Lookup[inputObjectPacket,Composition]];
		(* For Target assay, determine the position of the first fluorescent oligomer; For other sample categories, determine the position of the first oligomer *)
		targetComponentPosition=If[MatchQ[myInputCategory,TargetAssay],
			Module[
				{oligomerIdentityModelLinks,oligomerIdentityModelFluorescent,fluorescentOligomerPosition},
				oligomerIdentityModelLinks=Cases[objectComposition[[2]],LinkP[Model[Molecule,Oligomer]]];
				oligomerIdentityModelFluorescent=Lookup[fetchPacketFromCache[#,simulatedCache],Fluorescent]&/@oligomerIdentityModelLinks;
				fluorescentOligomerPosition=FirstPosition[oligomerIdentityModelFluorescent,True,{}];
				Flatten[Position[objectComposition[[2]],Extract[oligomerIdentityModelLinks,fluorescentOligomerPosition]],1]
			],
			FirstPosition[objectComposition[[2]],LinkP[Model[Molecule,Oligomer]],{}]
		];
		(* Get the concentration quantity from the first column of the composition variable using the position found *)
		targetComponentConcentration=Extract[objectComposition[[1]],targetComponentPosition]/.{}->Null;
		(* Output format: {Quantity,Boolean} *)
		Which[
			(* If concentration is in Molar units, great *)
			ConcentrationQ[targetComponentConcentration],{targetComponentConcentration,ConcentrationQ[targetComponentConcentration]},
			(* If concentration is in mass units and molecular weight is informed, calculate the molar concentration *)
			MassConcentrationQ[targetComponentConcentration]&&!NullQ[Lookup[fetchPacketFromCache[Extract[objectComposition[[2]],targetComponentPosition],simulatedCache],MolecularWeight]],{targetComponentConcentration/Lookup[fetchPacketFromCache[Extract[objectComposition[[2]],targetComponentPosition],simulatedCache],MolecularWeight],ConcentrationQ[targetComponentConcentration]},
			(* For all other cases, output Null *)
			True,{Null,Null}
		]
	];

	(* Helper function to find excitation and emission wavelengths, and detection labels from a list of lists of Model[Molecule,Oligomer] *)
	sampleOligomerFluorescencePropertyFinder[
		myInputObjects:ListableP[ObjectP[{Object[Sample],Model[Sample]}]|Null],
		myOutputIndex:Alternatives[1,2,3,All]
	]:=Module[
		{
			listedMyInputObjects,modelOligomersFromInputObjects,listedModelOligomersFromInputObjects,sampleOligomerFluorescenceProperties
		},
		(* Convert singleton input to a list for identityOligomerFinder function *)
		listedMyInputObjects=If[MatchQ[myInputObjects,_List],myInputObjects,{myInputObjects}];
		(* Use identityOligomerFinder to get all the identity oligomer objects from inputs *)
		modelOligomersFromInputObjects=identityOligomerFinder[listedMyInputObjects];
		(* Increase nestedness of previous output to the same level in case a single list of identity oligomers is provided *)
		listedModelOligomersFromInputObjects=If[MatchQ[modelOligomersFromInputObjects,{_List..}],modelOligomersFromInputObjects,{modelOligomersFromInputObjects}];
		(* Outermost list contains lists with oligomers found in the composition of an Object[Sample] or Model[Sample] using identityOligomerFinder helper function. Map over each oligomer and find the relevant fluorescence properties *)
		sampleOligomerFluorescenceProperties=Map[
			Function[{modelObjectInCompositionList},
				(* If the input list has objects, find the fluorescence fields; If its an empty list, output Null *)
				If[!MatchQ[Flatten[modelObjectInCompositionList],{}],
					Module[
						{
							fluorescentValue,excitationWavelengthValue,emissionWavelengthValue,detectionLabels,allExcitationWavelengths,allEmissionWavelengths,allDetectionLabels
						},
						(* Find packets for input objects and extract fluorophore fields from them *)
						{fluorescentValue,excitationWavelengthValue,emissionWavelengthValue,detectionLabels}=Transpose[
							Lookup[fetchPacketFromCache[#,simulatedCache],{Fluorescent,FluorescenceExcitationMaximums,FluorescenceEmissionMaximums,DetectionLabels}]&/@modelObjectInCompositionList
						];
						(* Isolate results only if Fluorescent->True at the index; since all oligomers are in a single sample or probe object, output as a flattened list *)
						allExcitationWavelengths=Flatten[PickList[excitationWavelengthValue,fluorescentValue]];
						allEmissionWavelengths=Flatten[PickList[emissionWavelengthValue,fluorescentValue]];
						allDetectionLabels=Flatten[PickList[detectionLabels,fluorescentValue]];
						(* If none of the oligomers have fluorescence properties, output list of Nulls instead of empty lists *)
						If[!MatchQ[{allExcitationWavelengths,allEmissionWavelengths,allDetectionLabels},{{},{},{}}],
							{allExcitationWavelengths,allEmissionWavelengths,allDetectionLabels},
							{{Null},{Null},{Null}}
						]
					],
					{{Null},{Null},{Null}}
				]
			],
			listedModelOligomersFromInputObjects
		];
		(*
			Output format: {{<excitation wavelengths>},{<emission wavelengths>},{<detection lablels>}} or {Null,Null,Null} if All outputs are needed otherwise it can be specified with index
			Index 1 = excitation; Index 2 = emission; Index 3 = detectionlabels
			-Input samples may not have fluorophore info in composition or may have 1 or more if multiplexed
			-Ideally, probe inputs should only have 1 fluorophore molecule. Throw an error if there is more than 1!
		 *)
		If[MatchQ[myOutputIndex,All],
			sampleOligomerFluorescenceProperties,
			sampleOligomerFluorescenceProperties[[All,myOutputIndex]]
		]
	];

	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(*-- INPUT VALIDATION CHECKS --*)

	(* NOTE: MAKE SURE NONE OF THE SAMPLES ARE DISCARDED - *)
	(* Get the packets of type Object[Sample] that may discarded. *)
	discardedSamplePackets=Cases[
		Flatten[oligomerSampleObjectPackets],
		KeyValuePattern[Status->Discarded]
	];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&messages,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Simulation -> updatedSimulation]<>" are not discarded:",True,False]
			];
			passingTest=If[Length[discardedInvalidInputs]==Length[oligomerSampleObjects],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[oligomerSampleObjects,discardedInvalidInputs],Simulation -> updatedSimulation]<>" are not discarded:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* NOTE: CHECK IF SAMPLE MODELS ARE DEPRECATED - *)
	(* Get the packets of type Model[Sample] that may be deprecated; if on the FastTrack, skip this check. *)
	deprecatedSampleModelPackets=If[!fastTrack,
		Select[allModelPackets,TrueQ[Lookup[#,Deprecated]]&],
		{}
	];

	(* Set deprecatedInvalidInputs to the input objects whose models are Deprecated *)
	deprecatedInvalidInputs=If[MatchQ[deprecatedSampleModelPackets,{}],
		{},
		Lookup[deprecatedSampleModelPackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[deprecatedInvalidInputs]>0&&messages,
		Message[Error::DeprecatedModels,ObjectToString[deprecatedInvalidInputs,Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	deprecatedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[deprecatedInvalidInputs]==0,
				Nothing,
				Test["Our input samples have models "<>ObjectToString[deprecatedInvalidInputs,Simulation->updatedSimulation]<>" that are not deprecated:",True,False]
			];
			passingTest=If[Length[deprecatedInvalidInputs]==Length[allModelPackets],
				Nothing,
				Test["Our input samples have models "<>ObjectToString[Complement[Lookup[allModelPackets,Object],deprecatedInvalidInputs],Simulation->updatedSimulation]<>" that are not deprecated:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* NOTE: CHECK IF ALL SAMPLE INPUTS HAVE COMPOSITION FIELD INFORMED - *) (* CRITICAL ERROR - make sure its flat *)
	(* Find all samples that have Null in Composition *)
	compositionInformedCheck=NullQ/@Lookup[allSampleObjectPackets,Composition];

	(* Any sample with Null composition should be invalid *)
	nullCompositionInvalidInputs=If[MemberQ[compositionInformedCheck,True],
		PickList[allSampleObjects,compositionInformedCheck],
		{}
	];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[nullCompositionInvalidInputs]>0&&messages,
		Message[Error::DigitalPCRNullComposition,ObjectToString[nullCompositionInvalidInputs,Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	nullCompositionTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[nullCompositionInvalidInputs]==0,
				Nothing,
				Test["Composition is not informed in input objects "<>ObjectToString[nullCompositionInvalidInputs,Simulation->updatedSimulation]<>" ::",True,False]
			];
			passingTest=If[Length[nullCompositionInvalidInputs]==Length[allSampleObjectPackets],
				Nothing,
				Test["Composition is informed in input objects "<>ObjectToString[Complement[Lookup[allSampleObjectPackets,Object],nullCompositionInvalidInputs],Simulation->updatedSimulation]<>" ::",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* NOTE: CHECK IF ALL SAMPLE INPUTS HAVE STATE AS LIQUID; SOLID SAMPLE INPUTS ARE REJECTED - *)
	(* Find all samples that have a state of anything other than Liquid; non-Liquid state = True *)
	liquidStateCheck=MatchQ[#,Except[Liquid|Null]]&/@Lookup[allSampleObjectPackets,State];

	(* Any sample without Liquid state should be invalid *)
	liquidStateInvalidInputs=If[MemberQ[liquidStateCheck,True],
		PickList[allSampleObjects,liquidStateCheck],
		{}
	];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[liquidStateInvalidInputs]>0&&messages,
		Message[Error::DigitalPCRNonLiquidSamples,ObjectToString[liquidStateInvalidInputs,Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	liquidStateTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[liquidStateInvalidInputs]==0,
				Nothing,
				Test["Our input samples, "<>ObjectToString[liquidStateInvalidInputs,Simulation->updatedSimulation]<>", are in liquid state::",True,False]
			];
			passingTest=If[Length[liquidStateInvalidInputs]==Length[allSampleObjectPackets],
				Nothing,
				Test["Our input samples, "<>ObjectToString[Complement[Lookup[allSampleObjectPackets,Object],liquidStateInvalidInputs],Simulation->updatedSimulation]<>", are in liquid state ::",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* RESOLVE SAMPLE & DILUTION OPTIONS *)

	(* RESOLVE PREPARED PLATE *)
	(* Known instrument-compatible DropletCartridge model *)
	compatibleDropletCartridge=Download[
		{
			Model[Container,Plate,DropletCartridge,"Bio-Rad GCR96 Digital PCR Cartridge"]
		},
		Object
	];

	(* Get all the unique container models in which the sample inputs reside *)
	containerModelForPreparedPlate=DeleteDuplicates[
		Lookup[Flatten[sampleContainerModels],Object]
	];

	preparedPlateValidityCheck=And[
		(* Check that all primer/probe object inputs are Null *)
		NullQ[Flatten[{myListedPrimerPairSamples,myListedProbeSamples,Lookup[digitalPCROptionsAssociation,{ReferencePrimerPairs,ReferenceProbes}]}]],
		(* Check that SampleVolume is 0 Microliter or Automatic *)
		MatchQ[Lookup[digitalPCROptionsAssociation,SampleVolume],{Alternatives[EqualP[0*Microliter],Automatic]..}],
		(* Check the status of SampleDilution switch - all should be False for PreparedPlate to be True *)
		AllTrue[Lookup[digitalPCROptionsAssociation,SampleDilution],(!TrueQ[#])&],
		(* Check that the samples are in a droplet cartridge container type *)
		AllTrue[containerModelForPreparedPlate,MemberQ[compatibleDropletCartridge,#]&],
		(* Check that all parallel processing blocks are filled in prepared plate *)
		Module[{uniquePlateObjects,contentsPerPlate,wellsPerPlate,dropletProcessingBlocks,wellBlockChecks},
			(* Get a list of unique plate objects *)
			uniquePlateObjects=DeleteDuplicates[Flatten[sampleContainerPackets],Object];
			(* For each plate, lookup Contents *)
			contentsPerPlate=Lookup[fetchPacketFromCache[#,simulatedCache],Contents]&/@uniquePlateObjects;
			(* Extract well information from contents of each plate *)
			wellsPerPlate=#[[All,1]]&/@contentsPerPlate;
			(* Create a list of processing blocks *)
			dropletProcessingBlocks=Partition[Flatten[Transpose[AllWells[]]],16];
			(* For each plate, Map over all blocks and check if ContainsAll or ContainsNone is True *)
			wellBlockChecks=Map[
				Function[{wellsInSinglePlate},
					Or[ContainsAll[wellsInSinglePlate,#],ContainsNone[wellsInSinglePlate,#]]&/@dropletProcessingBlocks
				],
				wellsPerPlate
			];
			AllTrue[Flatten[wellBlockChecks],TrueQ]
		]
	];

	(* Resolve to True if primerPair and probes inputs are Null, reference primerPairs and reference probes are Null, and the sample is in the compatible droplet cartridge *)
	resolvedPreparedPlate=Which[
		MatchQ[Lookup[digitalPCROptionsAssociation,PreparedPlate],Except[Automatic]],Lookup[digitalPCROptionsAssociation,PreparedPlate],
		MatchQ[Lookup[digitalPCROptionsAssociation,PreparedPlate],Automatic]&&preparedPlateValidityCheck,True,
		True,False
	];

	(* If there are any errors related to invalid inputs/options, collect the invalid inputs and options *)
	preparedPlateInvalidInputs=If[resolvedPreparedPlate&&!preparedPlateValidityCheck,
		PickList[Flatten[{myListedPrimerPairSamples,myListedProbeSamples}],!NullQ[#]&/@Flatten[{myListedPrimerPairSamples,myListedProbeSamples}]],
		{}
	];
	preparedPlateInvalidOptions=Which[
		resolvedPreparedPlate&&!preparedPlateValidityCheck&&AllTrue[Lookup[digitalPCROptionsAssociation,{ReferencePrimerPairs,ReferenceProbes}],!NullQ[#]&],{PreparedPlate,ReferencePrimerPairs,ReferenceProbes},
		resolvedPreparedPlate&&!preparedPlateValidityCheck,{PreparedPlate},
		True,{}
	];

	(* If PreparedPlate resolution is invalid and we are throwing messages,throw an error message and keep track of the invalid options.*)
	If[resolvedPreparedPlate&&!preparedPlateValidityCheck&&messages,
		Message[Error::DigitalPCRInvalidPreparedPlate]
	];

	(* If we are gathering tests, create a test for prepared plate error. *)
	preparedPlateTest=If[gatherTests,
		Test["When using a prepared plate, primers and probes are not specified, sample volume and sample dilution options are not informed, input samples are all in a plate of type Model[Container,Plate,DropletCartridge], and all PassiveWells in any parallel processing blocks are filled.]::",
			MatchQ[resolvedPreparedPlate,preparedPlateValidityCheck],
			True
		],
		Nothing
	];

	(* NOTE: VALID INPUT SAMPLE CONTAINER CHECK *)
	(* When resolvedPreparedPlate is False, samples should not be in DropletCartridge *)
	(* Find the container model of each sample *)
	unpreparedSampleContainers=Lookup[Flatten[sampleContainerModels],Object];
	(* Check if it is in a DropletCartridge *)
	unpreparedSampleContainerCheck=MemberQ[compatibleDropletCartridge,#]&/@unpreparedSampleContainers;

	(* If there are any errors related to invalid inputs, collect the invalid inputs and options *)
	inputSampleContainerInvalidInputs=If[!resolvedPreparedPlate&&MemberQ[unpreparedSampleContainerCheck,True],
		PickList[simulatedSamples,unpreparedSampleContainerCheck],
		{}
	];

	(* If resolvedPreparedPlate is False and samples are in DropletCartridge, we are throwing messages, throw an error message.*)
	If[!resolvedPreparedPlate&&MemberQ[unpreparedSampleContainerCheck,True]&&messages,
		Message[Error::InvalidInputSampleContainer,ObjectToString[inputSampleContainerInvalidInputs,Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a test for prepared plate error. *)
	inputSampleContainerTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[!resolvedPreparedPlate&&MemberQ[unpreparedSampleContainerCheck,True],
				Test["For samples "<>ObjectToString[inputSampleContainerInvalidInputs,Simulation->updatedSimulation]<>", if not using prepared plate, input samples should not be in Model[Container,Plate,DropletCartridge,\"Bio-Rad GCR96 Digital PCR Cartridge\"]::",True,False],
				Nothing
			];
			passingTest=If[!resolvedPreparedPlate&&MemberQ[unpreparedSampleContainerCheck,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,unpreparedSampleContainerCheck,False],Simulation->updatedSimulation]<>", if not using prepared plate, input samples should not be in Model[Container,Plate,DropletCartridge,\"Bio-Rad GCR96 Digital PCR Cartridge\"]::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)
	(* Options without nesting *)
	{precisionOptions,precisionOptionUnits}=Transpose[
		{
			(* SamplesIn index matched volume options *)
			{SampleVolume, 10^-1 Microliter},
			{MasterMixVolume, 10^-1 Microliter},
			{DiluentVolume, 10^-1 Microliter},
			{ReactionVolume, 10^-1 Microliter},
			{DilutionMixRate, 10^-1 (Microliter/Second)},
			{DilutionMixVolume, 10^-1 Microliter},

			(*Plate sealing options *)
			{PlateSealTemperature,1 Celsius},
			{PlateSealTime, 0.1 Second},(*CHECK THE INSTRUMENT*)

			(* SamplesIn index matched thermocycling options *)
			{ReverseTranscriptionTime, 1 Second},
			{ReverseTranscriptionTemperature, 10^-1 Celsius},
			{ReverseTranscriptionRampRate, 10^-3 Celsius/Second},(*CHECK THE INSTRUMENT*)

			{ActivationTime, 1 Second},
			{ActivationTemperature, 10^-1 Celsius},
			{ActivationRampRate, 10^-3 Celsius/Second},

			{DenaturationTime, 1 Second},
			{DenaturationTemperature, 10^-1 Celsius},
			{DenaturationRampRate, 10^-3 Celsius/Second},

			{PrimerAnnealingTime, 1 Second},
			{PrimerAnnealingTemperature, 10^-1 Celsius},
			{PrimerAnnealingRampRate, 10^-3 Celsius/Second},

			{PrimerGradientAnnealingMinTemperature, 10^-1 Celsius},
			{PrimerGradientAnnealingMaxTemperature, 10^-1 Celsius},

			{ExtensionTime, 1 Second},
			{ExtensionTemperature, 10^-1 Celsius},
			{ExtensionRampRate, 10^-3 Celsius/Second},

			{PolymeraseDegradationTime, 1 Second},
			{PolymeraseDegradationTemperature, 10^-1 Celsius},
			{PolymeraseDegradationRampRate, 10^-3 Celsius/Second}

		}
	];

	{initialRoundedOptions,initialOptionPrecisionTests}=If[gatherTests,
		RoundOptionPrecision[digitalPCROptionsAssociation,precisionOptions,precisionOptionUnits,Output->{Result,Tests}],
		{RoundOptionPrecision[digitalPCROptionsAssociation,precisionOptions,precisionOptionUnits],Null}
	];

	(* Options with values containing nested lists *)
	{nestedPrecisionOptions,nestedPrecisionOptionUnits}=Transpose[
		{
			(* SamplesIn index matched concentration & volume options *)
			{ForwardPrimerConcentration,1 Nanomolar},
			{ForwardPrimerVolume,10^-1 Microliter},
			{ReversePrimerConcentration,1 Nanomolar},
			{ReversePrimerVolume,10^-1 Microliter},
			{ProbeConcentration,1 Nanomolar},
			{ProbeVolume,10^-1 Microliter},

			{ReferenceForwardPrimerConcentration,1 Nanomolar},
			{ReferenceForwardPrimerVolume,10^-1 Microliter},
			{ReferenceReversePrimerConcentration,1 Nanomolar},
			{ReferenceReversePrimerVolume,10^-1 Microliter},
			{ReferenceProbeConcentration,1 Nanomolar},
			{ReferenceProbeVolume,10^-1 Microliter},

			(* SamplesIn index matched probe fluorophore options *)
			{ProbeExcitationWavelength, 1 Nanometer},
			{ProbeEmissionWavelength, 1 Nanometer},

			{ReferenceProbeExcitationWavelength, 1 Nanometer},
			{ReferenceProbeEmissionWavelength, 1 Nanometer}
		}
	];

	{roundedOptions,nestedOptionPrecisionTests}=If[gatherTests,
		roundNestedOptions[initialRoundedOptions,nestedPrecisionOptions,nestedPrecisionOptionUnits,Output->{Result,Tests}],
		roundNestedOptions[initialRoundedOptions,nestedPrecisionOptions,nestedPrecisionOptionUnits]
	];

	(* Combine all precision tests into a single list *)
	precisionTests=Join[
		initialOptionPrecisionTests,
		nestedOptionPrecisionTests
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(* Check that Name is properly specified *)

	(* If the specified Name is a string, check if this name exists in the Database already *)
	validName=If[MatchQ[name,_String],
		Not[DatabaseMemberQ[Object[Protocol,DigitalPCR,name]]],
		True
	];

	(*If validName is False and we are throwing messages, then throw an error message*)
	invalidNameOptions=If[!validName&&messages,
		(
			Message[Error::DuplicateName,"DigitalPCR protocol"];
			{Name}
		),
		{}
	];

	(*If we are gathering tests, create a test for Name*)
	validNameTest=If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already a DigitalPCR protocol object name:",
			validName,
			True
		],
		Nothing
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* Download the object reference with ID of the recommended RT-ddPCR MasterMix model *)
	reverseTranscriptionMasterMixModel=Download[
		{
			Model[Sample,"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer"]
		},
		Object
	];

	(* Hardcoding of allowed master mixes? Consider moving that before Download call *)
	recommendedMasterMixModels=Download[
		{
			Model[Sample,"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer"],
			Model[Sample,"Bio-Rad ddPCR Multiplex Supermix"],
			Model[Sample,"Bio-Rad ddPCR Supermix for Probes"],
			Model[Sample,"Bio-Rad ddPCR Supermix for Probes (No dUTP)"],
			Model[Sample,"Bio-Rad ddPCR Supermix for Residual DNA Quantification"]
		},
		Object
	];


	(* Create a list of excitation wavelengths compatible with the instrument; should get it from the instrument model in the future? *)
	compatibleExcitationWavelengths={495.0*Nanometer,535.0*Nanometer,538.0*Nanometer,647.0*Nanometer,675.0*Nanometer};
	(* Create a list of emission wavelengths compatible with the instrument; should get it from the instrument model in the future? *)
	compatibleEmissionWavelengths={517.0*Nanometer,556.0*Nanometer,554.0*Nanometer,665.0*Nanometer,694.0*Nanometer};
	(* Create an association list to convert compatible excitation wavelengths to emission wavelengths *)
	excitationToEmission=MapThread[EqualP[#1] -> #2 &,{compatibleExcitationWavelengths,compatibleEmissionWavelengths}];
	emissionToExcitation=MapThread[EqualP[#1] -> #2 &,{compatibleEmissionWavelengths,compatibleExcitationWavelengths}];

	(* Create a list of fluorophore models that are explicitly compatible with the instrument *)
	compatibleFluorophoreModelMolecules=Download[
		{
			Model[Molecule,"6-FAM"],
			Model[Molecule,"HEX"],
			Model[Molecule,"VIC Dye"],
			Model[Molecule,"Cy5"],
			Model[Molecule,"Cy5.5"]
		},
		Object
	];
	(* Create an association list to convert compatible Ex/Em wavelength pairs to potential fluorophore molecules *)
	excitationEmissionToFluorophore=AssociationThread[Transpose[{compatibleExcitationWavelengths,compatibleEmissionWavelengths}],compatibleFluorophoreModelMolecules];

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentDigitalPCR,roundedOptions];

	{
		(* Resolved option outputs *)
		resolvedSampleVolume,
		resolvedSerialDilutionCurve,
		resolvedDilutionMixVolume,
		resolvedDilutionNumberOfMixes,
		resolvedDilutionMixRate,

		resolvedProbeFluorophore,
		resolvedProbeExcitationWavelength,
		resolvedProbeEmissionWavelength,
		resolvedReferenceProbeFluorophore,
		resolvedReferenceProbeExcitationWavelength,
		resolvedReferenceProbeEmissionWavelength,

		resolvedAmplitudeMultiplexing,

		resolvedPremixedPrimerProbe,
		resolvedReferencePremixedPrimerProbe,
		resolvedProbeConcentration,
		resolvedProbeVolume,
		resolvedReferenceProbeConcentration,
		resolvedReferenceProbeVolume,
		resolvedForwardPrimerConcentration,
		resolvedForwardPrimerVolume,
		resolvedReversePrimerConcentration,
		resolvedReversePrimerVolume,
		resolvedReferenceForwardPrimerConcentration,
		resolvedReferenceForwardPrimerVolume,
		resolvedReferenceReversePrimerConcentration,
		resolvedReferenceReversePrimerVolume,

		resolvedReverseTranscription,
		resolvedReverseTranscriptionTime,
		resolvedReverseTranscriptionTemperature,
		resolvedReverseTranscriptionRampRate,

		resolvedMasterMix,
		resolvedMasterMixConcentrationFactor,
		resolvedMasterMixVolume,
		resolvedDiluentVolume,

		resolvedActivation,
		resolvedActivationTime,
		resolvedActivationTemperature,
		resolvedActivationRampRate,

		resolvedPrimerAnnealing,
		resolvedPrimerAnnealingTime,
		resolvedPrimerAnnealingTemperature,
		resolvedPrimerAnnealingRampRate,

		resolvedPrimerGradientAnnealing,
		resolvedPrimerGradientAnnealingMinTemperature,
		resolvedPrimerGradientAnnealingMaxTemperature,

		resolvedExtension,
		resolvedExtensionTime,
		resolvedExtensionTemperature,
		resolvedExtensionRampRate,

		resolvedPolymeraseDegradation,
		resolvedPolymeraseDegradationTime,
		resolvedPolymeraseDegradationTemperature,
		resolvedPolymeraseDegradationRampRate,

		resolvedForwardPrimerStorageCondition,
		resolvedReversePrimerStorageCondition,
		resolvedProbeStorageCondition,
		resolvedReferenceForwardPrimerStorageCondition,
		resolvedReferenceReversePrimerStorageCondition,
		resolvedReferenceProbeStorageCondition,
		resolvedMasterMixStorageCondition,
		
		(* Error tracking variable output *)
		sampleDilutionMismatchErrors,
		sampleVolumeMismatchErrors,
		singleFluorophorePerProbeErrors,
		singleFluorophorePerReferenceProbeErrors,
		probeFluorophoreNullOptionsErrors,
		probeFluorophoreIncompatibleOptionsErrors,
		probeFluorophoreLengthMismatchErrors,
		referenceProbeFluorophoreNullOptionsErrors,
		referenceProbeFluorophoreIncompatibleOptionsErrors,
		referenceProbeFluorophoreLengthMismatchErrors,
		amplitudeMultiplexingErrors,
		primerProbeOptionsLengthErrors,
		referencePrimerProbeOptionsLengthErrors,
		premixedPrimerProbeErrors,
		referencePremixedPrimerProbeErrors,
		probeStockConcentrationErrors,
		referenceProbeStockConcentrationErrors,
		probeConcentrationVolumeMismatchOptionErrors,
		probeStockConcentrationTooLowErrors,
		referenceProbeConcentrationVolumeMismatchOptionErrors,
		referenceProbeStockConcentrationTooLowErrors,
		forwardPrimerStockConcentrationErrors,
		forwardPrimerConcentrationVolumeMismatchOptionErrors,
		forwardPrimerStockConcentrationTooLowErrors,
		reversePrimerStockConcentrationErrors,
		reversePrimerConcentrationVolumeMismatchOptionErrors,
		reversePrimerStockConcentrationTooLowErrors,
		referenceForwardPrimerStockConcentrationErrors,
		referenceForwardPrimerConcentrationVolumeMismatchOptionErrors,
		referenceForwardPrimerStockConcentrationTooLowErrors,
		referenceReversePrimerStockConcentrationErrors,
		referenceReversePrimerConcentrationVolumeMismatchOptionErrors,
		referenceReversePrimerStockConcentrationTooLowErrors,
		reverseTranscriptionMismatchOptionsErrors,
		masterMixMismatchOptionsErrors,
		diluentVolumeOptionErrors,
		totalVolumeErrors,
		activationMismatchOptionsErrors,
		primerAnnealingMismatchOptionsErrors,
		initialPrimerGradientAnnealingMismatchOptionsErrors,
		extensionMismatchOptionsErrors,
		polymeraseDegradationMismatchOptionsErrors,
		forwardPrimerStorageConditionErrors,
		reversePrimerStorageConditionErrors,
		probeStorageConditionErrors,
		referenceForwardPrimerStorageConditionErrors,
		referenceReversePrimerStorageConditionErrors,
		referenceProbeStorageConditionErrors,
		masterMixStorageConditionErrors,
		noMultiplexAvailableErrors,

		(* Warning tracking variable output *)
		tooManyTargetsMultiplexedWarnings,
		probeStockConcentrationAccuracyWarnings,
		referenceProbeStockConcentrationAccuracyWarnings,
		forwardPrimerStockConcentrationAccuracyWarnings,
		reversePrimerStockConcentrationAccuracyWarnings,
		referenceForwardPrimerStockConcentrationAccuracyWarnings,
		referenceReversePrimerStockConcentrationAccuracyWarnings,
		masterMixConcentrationFactorNotInformedWarnings,
		masterMixQuantityMismatchWarnings
	}=Transpose[
		MapThread[
			Function[{samplePacket,primerPairPacket,probePacket,options},
				Module[
					{
						(* Resolved option variables *)
						sampleVolume,
						serialDilutionCurve,
						dilutionMixVolume,
						dilutionNumberOfMixes,
						dilutionMixRate,

						probeFluorophore,
						probeExcitationWavelength,
						probeEmissionWavelength,
						referenceProbeFluorophore,
						referenceProbeExcitationWavelength,
						referenceProbeEmissionWavelength,

						amplitudeMultiplexing,

						premixedPrimerProbe,
						referencePremixedPrimerProbe,
						probeConcentration,
						probeVolume,
						referenceProbeConcentration,
						referenceProbeVolume,
						forwardPrimerConcentration,
						forwardPrimerVolume,
						reversePrimerConcentration,
						reversePrimerVolume,
						referenceForwardPrimerConcentration,
						referenceForwardPrimerVolume,
						referenceReversePrimerConcentration,
						referenceReversePrimerVolume,

						reverseTranscriptionSwitch,
						reverseTranscriptionTime,
						reverseTranscriptionTemperature,
						reverseTranscriptionRampRate,

						masterMix,
						masterMixConcentrationFactor,
						masterMixVolume,
						diluentVolume,

						activationSwitch,
						activationTime,
						activationTemperature,
						activationRampRate,

						primerAnnealingSwitch,
						primerAnnealingTime,
						primerAnnealingTemperature,
						primerAnnealingRampRate,

						primerGradientAnnealingSwitch,
						primerGradientAnnealingMinTemperature,
						primerGradientAnnealingMaxTemperature,

						extensionSwitch,
						extensionTime,
						extensionTemperature,
						extensionRampRate,

						polymeraseDegradationSwitch,
						polymeraseDegradationTime,
						polymeraseDegradationTemperature,
						polymeraseDegradationRampRate,

						forwardPrimerStorageCondition,
						reversePrimerStorageCondition,
						probeStorageCondition,
						referenceForwardPrimerStorageCondition,
						referenceReversePrimerStorageCondition,
						referenceProbeStorageCondition,
						masterMixStorageCondition,
						
						(* Error variables *)
						sampleDilutionMismatchError,
						sampleVolumeMismatchError,
						singleFluorophorePerProbeError,
						singleFluorophorePerReferenceProbeError,
						probeFluorophoreNullOptionsError,
						probeFluorophoreIncompatibleOptionsError,
						probeFluorophoreLengthMismatchError,
						referenceProbeFluorophoreNullOptionsError,
						referenceProbeFluorophoreIncompatibleOptionsError,
						referenceProbeFluorophoreLengthMismatchError,
						amplitudeMultiplexingError,
						primerProbeOptionsLengthError,
						referencePrimerProbeOptionsLengthError,
						premixedPrimerProbeError,
						referencePremixedPrimerProbeError,
						probeStockConcentrationError,
						referenceProbeStockConcentrationError,
						probeConcentrationVolumeMismatchOptionError,
						probeStockConcentrationTooLowError,
						referenceProbeConcentrationVolumeMismatchOptionError,
						referenceProbeStockConcentrationTooLowError,
						forwardPrimerStockConcentrationError,
						forwardPrimerConcentrationVolumeMismatchOptionError,
						forwardPrimerStockConcentrationTooLowError,
						reversePrimerStockConcentrationError,
						reversePrimerConcentrationVolumeMismatchOptionError,
						reversePrimerStockConcentrationTooLowError,
						referenceForwardPrimerStockConcentrationError,
						referenceForwardPrimerConcentrationVolumeMismatchOptionError,
						referenceForwardPrimerStockConcentrationTooLowError,
						referenceReversePrimerStockConcentrationError,
						referenceReversePrimerConcentrationVolumeMismatchOptionError,
						referenceReversePrimerStockConcentrationTooLowError,
						reverseTranscriptionMismatchOptionsError,
						masterMixMismatchOptionsError,
						diluentVolumeOptionError,
						totalVolumeError,
						activationMismatchOptionsError,
						primerAnnealingMismatchOptionsError,
						primerGradientAnnealingMismatchOptionsError,
						extensionMismatchOptionsError,
						polymeraseDegradationMismatchOptionsError,
						forwardPrimerStorageConditionError,
						reversePrimerStorageConditionError,
						probeStorageConditionError,
						referenceForwardPrimerStorageConditionError,
						referenceReversePrimerStorageConditionError,
						referenceProbeStorageConditionError,
						masterMixStorageConditionError,
						noMultiplexAvailableError,

						(* Warning variables *)
						tooManyTargetsMultiplexedWarning,
						probeStockConcentrationAccuracyWarning,
						referenceProbeStockConcentrationAccuracyWarning,
						forwardPrimerStockConcentrationAccuracyWarning,
						reversePrimerStockConcentrationAccuracyWarning,
						referenceForwardPrimerStockConcentrationAccuracyWarning,
						referenceReversePrimerStockConcentrationAccuracyWarning,
						masterMixConcentrationFactorNotInformedWarning,
						masterMixQuantityMismatchWarning,

						(* Other variables *)
						specifiedSampleVolume,
						sampleDilutionSwitch,
						specifiedSerialDilutionCurve,
						specifiedDilutionMixVolume,
						specifiedDilutionNumberOfMixes,
						specifiedDilutionMixRate,
						seriesDilutionVolumes,
						numberOfSampleReplicates,
						minDilutionSampleVolume,
						specifiedReferencePrimerPairs,
						specifiedReferenceProbes,
						specifiedProbeFluorophore,
						specifiedProbeFluorophoreObjects,
						specifiedProbeExcitationWavelength,
						specifiedProbeEmissionWavelength,
						specifiedReferenceProbeFluorophore,
						specifiedReferenceProbeFluorophoreObjects,
						specifiedReferenceProbeExcitationWavelength,
						specifiedReferenceProbeEmissionWavelength,
						singleFluorophorePerProbeCheck,
						singleFluorophorePerReferenceProbeCheck,
						specifiedAmplitudeMultiplexing,
						allProbeEmissionWavelengths,
						targetCountsByEmissionWavelengths,
						countsPerChannel,
						multiplexingChannels,
						specifiedPremixedPrimerProbe,
						specifiedForwardPrimerConcentration,
						specifiedForwardPrimerVolume,
						specifiedReversePrimerConcentration,
						specifiedReversePrimerVolume,
						specifiedProbeConcentration,
						specifiedProbeVolume,
						specifiedReferencePremixedPrimerProbe,
						specifiedReferenceForwardPrimerConcentration,
						specifiedReferenceForwardPrimerVolume,
						specifiedReferenceReversePrimerConcentration,
						specifiedReferenceReversePrimerVolume,
						specifiedReferenceProbeConcentration,
						specifiedReferenceProbeVolume,
						specifiedReactionVolume,
						primerProbeOptionsWithValues,
						referencePrimerProbeOptionsWithValues,
						premixedPrimerProbeCheck,
						referencePremixedPrimerProbeCheck,
						probeStockConcentrations,
						probeStockConcentrationBoolean,
						referenceProbeStockConcentrations,
						referenceProbeStockConcentrationBoolean,
						maxProbeConcentrationMultiplexing,
						maxProbeConcentrationConstant,
						calculatedAllProbeConcentrations,
						calculatedProbeConcentrations,
						calculatedReferenceProbeConcentrations,
						primerProbeConcentrationRatio,
						forwardPrimerPacket,
						forwardPrimerStockConcentrations,
						forwardPrimerStockConcentrationBoolean,
						reversePrimerPacket,
						reversePrimerStockConcentrations,
						reversePrimerStockConcentrationBoolean,
						referenceForwardPrimers,
						referenceForwardPrimerStockConcentrations,
						referenceForwardPrimerStockConcentrationBoolean,
						referenceReversePrimers,
						referenceReversePrimerStockConcentrations,
						referenceReversePrimerStockConcentrationBoolean,
						sampleIdentityModelPolymerTypes,
						specifiedMasterMixModel,
						masterMixModelObject,
						modelMasterMixConcentrationFactor,
						volumeWithoutDiluent,
						probeStockConcentrationCalculation,
						referenceProbeStockConcentrationCalculation,
						forwardPrimerStockConcentrationCalculation,
						referenceForwardPrimerStockConcentrationCalculation,
						reversePrimerStockConcentrationCalculation,
						referenceReversePrimerStockConcentrationCalculation,
						specifiedForwardPrimerStorageCondition,
						specifiedReversePrimerStorageCondition,
						specifiedProbeStorageCondition,
						specifiedReferenceForwardPrimerStorageCondition,
						specifiedReferenceReversePrimerStorageCondition,
						specifiedReferenceProbeStorageCondition,
						specifiedMasterMixStorageCondition
					},

					(* Setup our error tracking variables *)
					{
						(* Error variables *)
						sampleDilutionMismatchError,
						sampleVolumeMismatchError,
						singleFluorophorePerProbeError,
						singleFluorophorePerReferenceProbeError,
						probeFluorophoreNullOptionsError,
						probeFluorophoreIncompatibleOptionsError,
						probeFluorophoreLengthMismatchError,
						referenceProbeFluorophoreNullOptionsError,
						referenceProbeFluorophoreIncompatibleOptionsError,
						referenceProbeFluorophoreLengthMismatchError,
						amplitudeMultiplexingError,
						primerProbeOptionsLengthError,
						referencePrimerProbeOptionsLengthError,
						premixedPrimerProbeError,
						referencePremixedPrimerProbeError,
						probeStockConcentrationError,
						referenceProbeStockConcentrationError,
						probeConcentrationVolumeMismatchOptionError,
						probeStockConcentrationTooLowError,
						referenceProbeConcentrationVolumeMismatchOptionError,
						referenceProbeStockConcentrationTooLowError,
						forwardPrimerStockConcentrationError,
						forwardPrimerConcentrationVolumeMismatchOptionError,
						forwardPrimerStockConcentrationTooLowError,
						reversePrimerStockConcentrationError,
						reversePrimerConcentrationVolumeMismatchOptionError,
						reversePrimerStockConcentrationTooLowError,
						referenceForwardPrimerStockConcentrationError,
						referenceForwardPrimerConcentrationVolumeMismatchOptionError,
						referenceForwardPrimerStockConcentrationTooLowError,
						referenceReversePrimerStockConcentrationError,
						referenceReversePrimerConcentrationVolumeMismatchOptionError,
						referenceReversePrimerStockConcentrationTooLowError,
						reverseTranscriptionMismatchOptionsError,
						masterMixMismatchOptionsError,
						diluentVolumeOptionError,
						activationMismatchOptionsError,
						primerAnnealingMismatchOptionsError,
						primerGradientAnnealingMismatchOptionsError,
						extensionMismatchOptionsError,
						polymeraseDegradationMismatchOptionsError,
						forwardPrimerStorageConditionError,
						reversePrimerStorageConditionError,
						probeStorageConditionError,
						referenceForwardPrimerStorageConditionError,
						referenceReversePrimerStorageConditionError,
						referenceProbeStorageConditionError,
						masterMixStorageConditionError,
						noMultiplexAvailableError,

						(* Warning variables *)
						tooManyTargetsMultiplexedWarning,
						probeStockConcentrationAccuracyWarning,
						referenceProbeStockConcentrationAccuracyWarning,
						forwardPrimerStockConcentrationAccuracyWarning,
						reversePrimerStockConcentrationAccuracyWarning,
						referenceForwardPrimerStockConcentrationAccuracyWarning,
						referenceReversePrimerStockConcentrationAccuracyWarning,
						masterMixConcentrationFactorNotInformedWarning,
						masterMixQuantityMismatchWarning
					}=ConstantArray[False,58];

					(* RESOLVING SAMPLE DILUTION SERIES OPTIONS *)
					(* Extract the relevant user-specified options *)
					{
						specifiedSampleVolume,
						sampleDilutionSwitch,
						specifiedSerialDilutionCurve,
						specifiedDilutionMixVolume,
						specifiedDilutionNumberOfMixes,
						specifiedDilutionMixRate
					}=Lookup[
						options,
						{
							SampleVolume,
							SampleDilution,
							SerialDilutionCurve,
							DilutionMixVolume,
							DilutionNumberOfMixes,
							DilutionMixRate
						}
					];

					(* SampleVolume *)
					sampleVolume=Which[
						(* accept any user specification and error check *)
						MatchQ[specifiedSampleVolume,Except[Automatic]],specifiedSampleVolume,
						(* when automatic and prepared plate is True, no sample will be added, so set to 0uL *)
						TrueQ[resolvedPreparedPlate],0.*Microliter,
						(* default to 4uL *)
						True,4.*Microliter
					];

					(* SerialDilutionCurve *)
					serialDilutionCurve=Which[
						(* accept any user specification and error check *)
						MatchQ[specifiedSerialDilutionCurve,Except[Automatic]],specifiedSerialDilutionCurve,
						(* when automatic and dilution is to be performed, set to the default value *)
						TrueQ[sampleDilutionSwitch],{50*Microliter,{0.1,4}},
						(* default to Null *)
						True,Null
					];

					(* DilutionMixVolume *)
					dilutionMixVolume=Which[
						(* accept any user specification and error check *)
						MatchQ[specifiedDilutionMixVolume,Except[Automatic]],specifiedDilutionMixVolume,
						(* when automatic and dilution is to be performed, set to the default value *)
						TrueQ[sampleDilutionSwitch],10.*Microliter,(* should this be resolved based on serialDilutionCurve? *)
						(* default to Null *)
						True,Null
					];

					(* DilutionNumberOfMixes *)
					dilutionNumberOfMixes=Which[
						(* accept any user specification and error check *)
						MatchQ[specifiedDilutionNumberOfMixes,Except[Automatic]],specifiedDilutionNumberOfMixes,
						(* when automatic and dilution is to be performed, set to the default value *)
						TrueQ[sampleDilutionSwitch],10,
						(* default to Null *)
						True,Null
					];

					(* DilutionMixRate *)
					dilutionMixRate=Which[
						(* accept any user specification and error check *)
						MatchQ[specifiedDilutionMixRate,Except[Automatic]],specifiedDilutionMixRate,
						(* when automatic and dilution is to be performed, set to the default value *)
						TrueQ[sampleDilutionSwitch],30.*(Microliter/Second),
						(* default to Null *)
						True,Null
					];

					(* Error checking sample dilution option-set *)
					(* When SampleDilution switch is True, all options should be informed (unless PreparedPlate is True), otherwise they should be Null *)
					sampleDilutionMismatchError=If[TrueQ[sampleDilutionSwitch],
						AnyTrue[{serialDilutionCurve,dilutionMixVolume,dilutionNumberOfMixes,dilutionMixRate},NullQ]||resolvedPreparedPlate,
						!NullQ[{serialDilutionCurve,dilutionMixVolume,dilutionNumberOfMixes,dilutionMixRate}]
					];

					(* Error checking sample volume and diluted sample volume *)
					(* Calculate the transfer and diluent volumes from a resolved serial dilution curve *)
					seriesDilutionVolumes=dilutionTransferVolumes[serialDilutionCurve]/.{Null->0*Microliter};

					(* Get the minimum dilution sample volume that is created by the resolved serial dilution curve option *)
					minDilutionSampleVolume=Module[{totalVolumeOfDilution,remainingVolumeOfDilution},
						(* Total volume for each dilution before transfer volume is taking out *)
						totalVolumeOfDilution=Plus@@seriesDilutionVolumes;
						(* Volume of dilution sample remaining after the transfer volume is taken out *)
						remainingVolumeOfDilution=Append[
							Most[totalVolumeOfDilution]-Rest[First[seriesDilutionVolumes]],
							Last[totalVolumeOfDilution]
						];
						(* output only the minmum remaining volume in the list of samples *)
						Min[remainingVolumeOfDilution]
					];

					(* get the number of replicates option to make sure the minDilutionSampleVolume also accounts for that *)
					numberOfSampleReplicates=Lookup[roundedOptions,NumberOfReplicates]/.{Null->1};

					(* Volume of created dilutions must be more than sample volume*NumberOfReplicates + 10% extra to account for dead volume *)
					sampleVolumeMismatchError=If[And[sampleDilutionSwitch,!sampleDilutionMismatchError],
						!LessEqualQ[sampleVolume*numberOfSampleReplicates*1.1,minDilutionSampleVolume],
						False
					];

					(* NOTE: aliquot volume is not checked. Aliquot volume must be larger than resolved SampleVolume or sample volume needed to created a resolved SerialDilutionCurve *)

					(* RESOLVING FLUORESCENCE PROBE OPTIONS *)
					(* Extract the relevant user-specified options *)
					{
						specifiedProbeFluorophore,
						specifiedProbeExcitationWavelength,
						specifiedProbeEmissionWavelength,
						specifiedReferencePrimerPairs,
						specifiedReferenceProbes,
						specifiedReferenceProbeFluorophore,
						specifiedReferenceProbeExcitationWavelength,
						specifiedReferenceProbeEmissionWavelength
					}=Lookup[
						options,
						{
							ProbeFluorophore,
							ProbeExcitationWavelength,
							ProbeEmissionWavelength,
							ReferencePrimerPairs,
							ReferenceProbes,
							ReferenceProbeFluorophore,
							ReferenceProbeExcitationWavelength,
							ReferenceProbeEmissionWavelength
						}
					];

					(* All probes should have only 1 oligo with fluorophore *)
					singleFluorophorePerProbeCheck=If[!NullQ[probePacket],
						Module[{oligosInComposition,flatFluorophoresPerOligo,fluorophoresPerOligo,fluorophoresPerProbe},
							(* Find all oligomer identity models in each probe *)
							oligosInComposition=identityOligomerFinder[probePacket]/.{{} -> {Null}};
							(* For each oligomer, count the number of fluorescence wavelengths or detection labels in the object fields and count the field with the highest number *)
							flatFluorophoresPerOligo=fluorescencePerIdentityObject[Flatten[oligosInComposition]];
							(* Recreate the structured list that index-matches the structued list of identity oligomers *)
							fluorophoresPerOligo=Unflatten[flatFluorophoresPerOligo,oligosInComposition];
							(* Add the number of fluorophore-containing oligomers in each probe sample *)
							fluorophoresPerProbe=Total[fluorophoresPerOligo,{2}];
							(* Output a boolean list; If a probe has 1 fluorophore, output True, otherwise False *)
							SameQ[#,1]&/@fluorophoresPerProbe
						],
						Null
					];

					(* Test for errors in probe input *)
					singleFluorophorePerProbeError=If[!resolvedPreparedPlate&&!NullQ[probePacket],
						(* Throw an error if any of the probes has 0 or >1 fluorophores *)
						!And@@singleFluorophorePerProbeCheck,
						(* No error if probe input is Null *)
						False
					];

					(* All reference probes should have only 1 oligo with fluorophore *)
					singleFluorophorePerReferenceProbeCheck=If[!NullQ[specifiedReferenceProbes],
						Module[{oligosInComposition,flatFluorophoresPerOligo,fluorophoresPerOligo,fluorophoresPerProbe},
							(* Find all oligomer identity models in each probe *)
							oligosInComposition=identityOligomerFinder[specifiedReferenceProbes]/.{{} -> {Null}};
							(* For each oligomer, count the number of fluorescence wavelengths or detection labels in the object fields and count the field with the highest number *)
							flatFluorophoresPerOligo=fluorescencePerIdentityObject[Flatten[oligosInComposition]];
							(* Recreate the structured list that index-matches the structued list of identity oligomers *)
							fluorophoresPerOligo=Unflatten[flatFluorophoresPerOligo,oligosInComposition];
							(* Add the number of fluorophore-containing oligomers in each probe sample *)
							fluorophoresPerProbe=Total[fluorophoresPerOligo,{2}];
							(* Output a boolean list; If a probe has 1 fluorophore, output True, otherwise False *)
							SameQ[#,1]&/@fluorophoresPerProbe
						],
						Null
					];

					(* Test for errors in reference probe option *)
					singleFluorophorePerReferenceProbeError=If[!resolvedPreparedPlate&&!NullQ[specifiedReferenceProbes],
						(* Throw an error if any of the reference probes has 0 or >1 fluorophores *)
						!And@@singleFluorophorePerReferenceProbeCheck,
						(* No error if reference probe input is Null *)
						False
					];

					(* Get object reference with ID in case the fluorophore objects are specified by name unless it is Automatic *)
					specifiedProbeFluorophoreObjects=If[MatchQ[specifiedProbeFluorophore,Except[Automatic]],
						Download[specifiedProbeFluorophore,Object],
						specifiedProbeFluorophore
					];

					(* Resolve excitation wavelength *)
					probeExcitationWavelength=Which[
						(* Use user-specified wavelength if provided *)
						MatchQ[specifiedProbeExcitationWavelength,Except[Automatic]],specifiedProbeExcitationWavelength,
						(* If user provides emission wavelength and it matches wavelengths compatible with instrument, use lookup table to find the paired excitation wavelength *)
						MatchQ[specifiedProbeEmissionWavelength,Except[Automatic]]&&AllTrue[specifiedProbeEmissionWavelength,MemberQ[compatibleEmissionWavelengths,#]&],specifiedProbeEmissionWavelength/.emissionToExcitation,
						(* If instead the user provides fluorophore as DetectionLabels, extract the excitation wavelength from that *)
						MatchQ[specifiedProbeFluorophoreObjects,Except[Automatic]],Flatten[Lookup[fetchPacketFromCache[#,simulatedCache],FluorescenceExcitationMaximums]&/@specifiedProbeFluorophoreObjects],
						(* If none of the other options are specified and this is a prepared plate (or not a prepared plate and no probes are provided and the sample may have probes), lookup wavelengths from oligomer identity models in the sample composition; Throw an error if Null? *)
						MatchQ[specifiedProbeExcitationWavelength,Automatic]&&(resolvedPreparedPlate||(!resolvedPreparedPlate&&NullQ[probePacket])),Flatten[sampleOligomerFluorescencePropertyFinder[samplePacket,1],1],
						(* If none of the other options are specified and this is not a prepared plate and probes are provided, lookup wavelengths from oligomer identity models in the probes *)
						MatchQ[specifiedProbeExcitationWavelength,Automatic]&&!resolvedPreparedPlate&&!NullQ[probePacket],Flatten[sampleOligomerFluorescencePropertyFinder[probePacket,1],1],
						True,Null
					];

					(* Resolve emission wavelength *)
					probeEmissionWavelength=Which[
						(* Use user-specified wavelength if provided *)
						MatchQ[specifiedProbeEmissionWavelength,Except[Automatic]],specifiedProbeEmissionWavelength,
						(* If user provides excitation wavelength and it matches wavelengths compatible with instrument, use lookup table to find the paired emission wavelength *)
						MatchQ[probeExcitationWavelength,Except[Null]]&&AllTrue[probeExcitationWavelength,MemberQ[compatibleExcitationWavelengths,#]&],probeExcitationWavelength/.excitationToEmission,
						(* If instead the user provides fluorophore as DetectionLabels, extract the emission wavelength from that *)
						MatchQ[specifiedProbeFluorophoreObjects,Except[Automatic]],Flatten[Lookup[fetchPacketFromCache[#,simulatedCache],FluorescenceEmissionMaximums]&/@specifiedProbeFluorophoreObjects],
						(* If none of the other options are specified and this is a prepared plate (or not a prepared plate and no probes are provided and the sample may have probes), lookup wavelengths from oligomer identity models in the sample composition; Throw an error if Null? *)
						MatchQ[specifiedProbeEmissionWavelength,Automatic]&&(resolvedPreparedPlate||(!resolvedPreparedPlate&&NullQ[probePacket])),Flatten[sampleOligomerFluorescencePropertyFinder[samplePacket,2],1],
						(* If none of the other options are specified and this is not a prepared plate and probes are provided, lookup wavelengths from oligomer identity models in the probes *)
						MatchQ[specifiedProbeEmissionWavelength,Automatic]&&!resolvedPreparedPlate&&!NullQ[probePacket],Flatten[sampleOligomerFluorescencePropertyFinder[probePacket,2],1],
						True,Null
					];

					(* Resolve fluorophores *)
					probeFluorophore=Which[
						(* Use user-specified fluorophore models if specified *)
						MatchQ[specifiedProbeFluorophoreObjects,Except[Automatic]],specifiedProbeFluorophoreObjects,
						(* If this is a prepared plate (or not a prepared plate and no probes are provided and the sample may have probes), lookup DetectionLabels from oligomer identity models in the sample composition; Throw an error if Null? *)
						MatchQ[specifiedProbeFluorophoreObjects,Automatic]&&(resolvedPreparedPlate||(!resolvedPreparedPlate&&NullQ[probePacket])),Flatten[sampleOligomerFluorescencePropertyFinder[samplePacket,3],1],
						(* If this is not a prepared plate and probes are provided, lookup wavelengths from oligomer identity models in the probes *)
						MatchQ[specifiedProbeFluorophoreObjects,Automatic]&&!resolvedPreparedPlate&&!NullQ[probePacket],Flatten[sampleOligomerFluorescencePropertyFinder[probePacket,3],1],
						(* If excitation and emission wavelengths are resolved and match the instrument compatible wavelengths, resolve the potential fluorophore model *)
						AllTrue[{probeExcitationWavelength,probeEmissionWavelength},(!NullQ[#])&]&&AllTrue[probeExcitationWavelength,MemberQ[compatibleExcitationWavelengths,#]&]&&AllTrue[probeEmissionWavelength,MemberQ[compatibleEmissionWavelengths,#]&],Transpose[{probeExcitationWavelength,probeEmissionWavelength}]/.excitationEmissionToFluorophore,
						True,Null
					];

					(* Error tracking for probe fluorophores *)
					(* If any of the wavelength options are Null, collect an error *)
					probeFluorophoreNullOptionsError=AnyTrue[Flatten[{probeExcitationWavelength,probeEmissionWavelength}],NullQ];

					(* If wavelengths do not match the instrument-compatible values or if they are not paired correctly, collect an error; can soften this if we have a range of values that are OK *)
					probeFluorophoreIncompatibleOptionsError=If[AllTrue[{probeExcitationWavelength,probeEmissionWavelength},(!NullQ[#])&],
						!And[
							AllTrue[probeExcitationWavelength,MemberQ[compatibleExcitationWavelengths,EqualP[#]]&],
							AllTrue[probeEmissionWavelength,MemberQ[compatibleEmissionWavelengths,EqualP[#]]&],
							AllTrue[MapThread[
								MatchQ[(#1 /. excitationToEmission), EqualP[#2]] &,
								{ToList[probeExcitationWavelength], ToList[probeEmissionWavelength]}],
								TrueQ]
						],
						False
					];


					(* If the length of probePacket is not the same as wavelength options, collect an error; In case a probe object has more than one probe oligomers in it or if user enters the wrong number of wavelengths *)
					probeFluorophoreLengthMismatchError=If[AllTrue[{probePacket,probeExcitationWavelength,probeEmissionWavelength},(!NullQ[#])&],
						!SameLengthQ[probePacket,probeExcitationWavelength,probeEmissionWavelength],
						False
					];

					(* Get object reference with ID in case the reference fluorophore objects are specified by name, unless it is Automatic *)
					specifiedReferenceProbeFluorophoreObjects=If[MatchQ[specifiedReferenceProbeFluorophore,Except[Automatic]],
						Download[specifiedReferenceProbeFluorophore,Object],
						specifiedReferenceProbeFluorophore
					];

					(* Resolve excitation wavelengths for reference probes *)
					referenceProbeExcitationWavelength=Which[
						(* Use user-specified wavelength if provided *)
						MatchQ[specifiedReferenceProbeExcitationWavelength,Except[Automatic]],specifiedReferenceProbeExcitationWavelength,
						(* When preparedPlate is True or when referenceProbes are Null, set this to Null *)
						resolvedPreparedPlate||NullQ[specifiedReferenceProbes],Null,
						(* If user provides emission wavelength and it matches wavelengths compatible with instrument, use lookup table to find the paired excitation wavelength *)
						MatchQ[specifiedReferenceProbeEmissionWavelength,Except[Automatic|Null]]&&AllTrue[specifiedReferenceProbeEmissionWavelength,MemberQ[compatibleEmissionWavelengths,#]&],specifiedReferenceProbeEmissionWavelength/.emissionToExcitation,
						(* If instead the user provides fluorophore as DetectionLabels, extract the excitation wavelength from that *)
						MatchQ[specifiedReferenceProbeFluorophoreObjects,Except[Automatic|Null]],Flatten[Lookup[fetchPacketFromCache[#,simulatedCache],FluorescenceExcitationMaximums]&/@specifiedReferenceProbeFluorophoreObjects],
						(* If none of the other options are specified and this is not a prepared plate and probes are provided, lookup wavelengths from oligomer identity models in the probes *)
						MatchQ[specifiedReferenceProbeExcitationWavelength,Automatic]&&!NullQ[specifiedReferenceProbes],Flatten[sampleOligomerFluorescencePropertyFinder[specifiedReferenceProbes,1],1],
						True,Null
					];

					(* Resolve emission wavelength for reference probes *)
					referenceProbeEmissionWavelength=Which[
						(* Use user-specified wavelength if provided *)
						MatchQ[specifiedReferenceProbeEmissionWavelength,Except[Automatic]],specifiedReferenceProbeEmissionWavelength,
						(* When preparedPlate is True or when referenceProbes are Null, set this to Null *)
						resolvedPreparedPlate||NullQ[specifiedReferenceProbes],Null,
						(* If user provides emission wavelength and it matches wavelengths compatible with instrument, use lookup table to find the paired excitation wavelength *)
						MatchQ[referenceProbeExcitationWavelength,Except[Automatic|Null]]&&AllTrue[referenceProbeExcitationWavelength,MemberQ[compatibleExcitationWavelengths,#]&],referenceProbeExcitationWavelength/.excitationToEmission,
						(* If instead the user provides fluorophore as DetectionLabels, extract the excitation wavelength from that *)
						MatchQ[specifiedReferenceProbeFluorophoreObjects,Except[Automatic|Null]],Flatten[Lookup[fetchPacketFromCache[#,simulatedCache],FluorescenceEmissionMaximums]&/@specifiedReferenceProbeFluorophoreObjects],
						(* If none of the other options are specified and this is not a prepared plate and probes are provided, lookup wavelengths from oligomer identity models in the probes *)
						MatchQ[specifiedReferenceProbeEmissionWavelength,Automatic]&&!NullQ[specifiedReferenceProbes],Flatten[sampleOligomerFluorescencePropertyFinder[specifiedReferenceProbes,2],1],
						True,Null
					];

					(* Resolve fluorophores *)
					referenceProbeFluorophore=Which[
						(* Use user-specified fluorophore models if specified *)
						MatchQ[specifiedReferenceProbeFluorophoreObjects,Except[Automatic]],specifiedReferenceProbeFluorophoreObjects,
						(* When preparedPlate is True or when referenceProbes are Null, set this to Null *)
						resolvedPreparedPlate||NullQ[specifiedReferenceProbes],Null,
						(* If this is not a prepared plate and reference probes are provided, lookup wavelengths from oligomer identity models in the reference probes *)
						MatchQ[specifiedReferenceProbeFluorophoreObjects,Automatic]&&!resolvedPreparedPlate&&!NullQ[specifiedReferenceProbes],Flatten[sampleOligomerFluorescencePropertyFinder[specifiedReferenceProbes,3],1],
						(* If excitation and emission wavelengths are resolved and match the instrument compatible wavelengths, resolve the potential fluorophore model *)
						AllTrue[{referenceProbeExcitationWavelength,referenceProbeEmissionWavelength},(!NullQ[#])&]&&AllTrue[referenceProbeExcitationWavelength,MemberQ[compatibleExcitationWavelengths,#]&]&&AllTrue[referenceProbeEmissionWavelength,MemberQ[compatibleEmissionWavelengths,#]&],Transpose[{referenceProbeExcitationWavelength,referenceProbeEmissionWavelength}]/.excitationEmissionToFluorophore,
						True,Null
					];

					(* Error tracking for reference probe fluorophores *)
					(* If ReferenceProbes are informed and wavelength options are Null, collect an error *)
					referenceProbeFluorophoreNullOptionsError=If[!resolvedPreparedPlate&&!NullQ[specifiedReferenceProbes],
						AnyTrue[Flatten[{referenceProbeExcitationWavelength,referenceProbeEmissionWavelength}],NullQ],
						False
					];

					(* If wavelengths do not match the instrument-compatible values, collect an error; can soften this if we have a range of values that are OK *)
					referenceProbeFluorophoreIncompatibleOptionsError=If[AllTrue[{referenceProbeExcitationWavelength,referenceProbeEmissionWavelength},(!NullQ[#])&],
						!And[
							AllTrue[referenceProbeExcitationWavelength,MemberQ[compatibleExcitationWavelengths,EqualP[#]]&],
							AllTrue[referenceProbeEmissionWavelength,MemberQ[compatibleEmissionWavelengths,EqualP[#]]&],
							AllTrue[MapThread[
								MatchQ[(#1 /. excitationToEmission), EqualP[#2]] &,
								{ToList[referenceProbeExcitationWavelength], ToList[referenceProbeEmissionWavelength]}],
								TrueQ]
						],
						False
					];

					(* If the length of reference probes option is not the same as wavelength options, collect an error; In case a probe object has more than one probe oligomers in it *)
					referenceProbeFluorophoreLengthMismatchError=If[AllTrue[{specifiedReferenceProbes,referenceProbeExcitationWavelength,referenceProbeEmissionWavelength},(!NullQ[#])&],
						!SameLengthQ[specifiedReferenceProbes,referenceProbeExcitationWavelength,referenceProbeEmissionWavelength],
						False
					];

					(* RESOLVE AMPLITUDEMULTIPLEXING *)
					specifiedAmplitudeMultiplexing=Lookup[options,AmplitudeMultiplexing];

					(* Make a combined list of all probe and reference probe emission wavelengths unless either is Null *)
					allProbeEmissionWavelengths=Which[
						!NullQ[probeEmissionWavelength]&&!NullQ[referenceProbeEmissionWavelength],Join[probeEmissionWavelength,referenceProbeEmissionWavelength],
						!NullQ[probeEmissionWavelength]&&NullQ[referenceProbeEmissionWavelength],probeEmissionWavelength,
						(* This can happen if samples already have probes that are not resolved and reference probe is added *)
						NullQ[probeEmissionWavelength]&&!NullQ[referenceProbeEmissionWavelength],referenceProbeEmissionWavelength,
						True,{}
					];

					(* Count only compatible wavelengths *)
					targetCountsByEmissionWavelengths=Map[
						Count[allProbeEmissionWavelengths,#]&,
						compatibleEmissionWavelengths
					];

					(* Merge counts for of HEX & VIC as they are the same for AmplitudeMultiplexing *)
					countsPerChannel={targetCountsByEmissionWavelengths[[1]],Total[targetCountsByEmissionWavelengths[[2;;3]]],targetCountsByEmissionWavelengths[[4]],targetCountsByEmissionWavelengths[[5]]};
					(* Keys corresponding to channels in the instrument *)
					multiplexingChannels={517.0*Nanometer,556.0*Nanometer,665.0*Nanometer,694.0*Nanometer};

					(* Amplitude multiplexing resolution - {{<channel>,<counts>}..} *)
					amplitudeMultiplexing=Which[
						MatchQ[specifiedAmplitudeMultiplexing,Except[Automatic|Null]],
						Module[{associationSpecifiedMultiplexing,mergedSpecifiedMultiplexing,specifiedInitialCounts,specifiedCountsPerChannel},
							(* Create an assocation from a list of Wavelength and counts*)
							associationSpecifiedMultiplexing=AssociationThread@@Transpose[Lookup[options,AmplitudeMultiplexing]];
							(* Merge any repeated keys and add their values up*)
							mergedSpecifiedMultiplexing=Merge[ToList[associationSpecifiedMultiplexing],Total];
							(* Use replace to create a list of counts in the same format as resolver *)
							specifiedInitialCounts=multiplexingChannels/.mergedSpecifiedMultiplexing;
							(* Switch any channels without counts with 0 *)
							specifiedCountsPerChannel=If[MatchQ[#,_Quantity],0,#]&/@specifiedInitialCounts;
							(* Format the specified counts with respective channel *)
							Transpose[{multiplexingChannels,specifiedCountsPerChannel}]
						],
						(* Only output a list of values if any of the channels have more than 1 target *)
						MatchQ[specifiedAmplitudeMultiplexing,Automatic|Null]&&AnyTrue[countsPerChannel,GreaterQ[#,1]&],Transpose[{multiplexingChannels,countsPerChannel}],
						(* Output null if 0 or 1 target in all channels *)
						True,Null
					];

					(* If more than 2 (targets+references) are multiplexed, warn the user *)
					tooManyTargetsMultiplexedWarning=If[!NullQ[amplitudeMultiplexing],
						AnyTrue[countsPerChannel,GreaterQ[#,2]&],
						False
					];

					(* If the user-specified amplitude multiplexing input channel is incompatible with instrument or no channel has more than 1 target, collect an error *)
					amplitudeMultiplexingError=Or[
						!NullQ[amplitudeMultiplexing]&&AllTrue[amplitudeMultiplexing[[All,1]],MemberQ[compatibleEmissionWavelengths,#]&]&&!AnyTrue[amplitudeMultiplexing[[All,2]],GreaterQ[#,1]&],
						!resolvedPreparedPlate&&!NullQ[amplitudeMultiplexing]&&!AllTrue[amplitudeMultiplexing,If[MemberQ[multiplexingChannels,#[[1]]],MatchQ[#[[2]],Extract[countsPerChannel,Flatten[Position[multiplexingChannels,#[[1]]]]]],True]&],
						!resolvedPreparedPlate&&!NullQ[amplitudeMultiplexing]&&!NullQ[probePacket]&&!NullQ[referenceProbeEmissionWavelength]&&!ContainsExactly[amplitudeMultiplexing,Transpose[{multiplexingChannels,countsPerChannel}]]
					];

					(* RESOLVING INPUT & REFERENCE PRIMER/PROBE OPTIONS *)

					{
						specifiedPremixedPrimerProbe,
						specifiedForwardPrimerConcentration,
						specifiedForwardPrimerVolume,
						specifiedReversePrimerConcentration,
						specifiedReversePrimerVolume,
						specifiedProbeConcentration,
						specifiedProbeVolume,
						specifiedReferencePremixedPrimerProbe,
						specifiedReferenceForwardPrimerConcentration,
						specifiedReferenceForwardPrimerVolume,
						specifiedReferenceReversePrimerConcentration,
						specifiedReferenceReversePrimerVolume,
						specifiedReferenceProbeConcentration,
						specifiedReferenceProbeVolume,
						specifiedReactionVolume
					}=Lookup[
						options,
						{
							PremixedPrimerProbe,
							ForwardPrimerConcentration,
							ForwardPrimerVolume,
							ReversePrimerConcentration,
							ReversePrimerVolume,
							ProbeConcentration,
							ProbeVolume,
							ReferencePremixedPrimerProbe,
							ReferenceForwardPrimerConcentration,
							ReferenceForwardPrimerVolume,
							ReferenceReversePrimerConcentration,
							ReferenceReversePrimerVolume,
							ReferenceProbeConcentration,
							ReferenceProbeVolume,
							ReactionVolume
						}
					];

					(* Collect the primer/probe options that have a value *)
					primerProbeOptionsWithValues=Cases[
						{
							specifiedPremixedPrimerProbe,
							specifiedForwardPrimerConcentration,
							specifiedForwardPrimerVolume,
							specifiedReversePrimerConcentration,
							specifiedReversePrimerVolume,
							specifiedProbeConcentration,
							specifiedProbeVolume
						},
						Except[Automatic|Null]
					];

					(* If lengths of user-specified options does not match input primers/probes, collect an error *)
					primerProbeOptionsLengthError=If[Length[primerProbeOptionsWithValues]>0,
						Or@@(!SameLengthQ[primerPairPacket,probePacket,#]&/@primerProbeOptionsWithValues),
						False
					];

					(* Collect the reference primer/probe options that have a value *)
					referencePrimerProbeOptionsWithValues=Cases[
						{
							specifiedReferencePremixedPrimerProbe,
							specifiedReferenceForwardPrimerConcentration,
							specifiedReferenceForwardPrimerVolume,
							specifiedReferenceReversePrimerConcentration,
							specifiedReferenceReversePrimerVolume,
							specifiedReferenceProbeConcentration,
							specifiedReferenceProbeVolume
						},
						Except[Automatic|Null]
					];

					(* If lengths of user-specified options does not match input primers/probes, collect an error *)
					referencePrimerProbeOptionsLengthError=If[AllTrue[{specifiedReferencePrimerPairs,specifiedReferenceProbes},(!NullQ[#])&]&&Length[referencePrimerProbeOptionsWithValues]>0,
						Or@@(!SameLengthQ[specifiedReferencePrimerPairs,specifiedReferenceProbes,#]&/@referencePrimerProbeOptionsWithValues),
						False
					];

					(* RESOLVE PREMIXED ASSAY OPTION *)
					(* If primer and probe packets are not Null, check if they have the same objects at each index to determine if an assay or primer set is used *)
					premixedPrimerProbeCheck=If[!resolvedPreparedPlate&&AllTrue[{primerPairPacket,probePacket},(!NullQ[#])&],
						MapThread[
							Function[{singlePrimerPairPacket,singleProbePacket},
								Module[{primerProbeObjectList},
									(* Extract the model object from each of the three packets *)
									primerProbeObjectList=Map[
										Which[
											(* If the packet is of type Model[Sample], keep it the same *)
											MatchQ[#,ObjectP[Model[Sample]]],#,
											(* If the packet is of type Object[Sample] and Model[Sample] is informed, use Model[Sample] *)
											MatchQ[#,ObjectP[Object[Sample]]]&&MatchQ[Lookup[#,Model],ObjectP[Model[Sample]]],Lookup[#,Model],
											(* In all other cases, use the input packet *)
											True,#
										]&,
										Flatten[{singlePrimerPairPacket,singleProbePacket}]
									];
									(* Check which objects are same; If they are all Null, assign None *)
									Which[
										(* If all three are the same, output TargetAssay *)
										SameQ@@primerProbeObjectList,TargetAssay,
										(* If the primers are the same, output PrimerSet *)
										SameQ@@primerProbeObjectList[[1;;2]],PrimerSet,
										(* If all the samples are unique, output None *)
										True,None
									]
								]
							],
							{primerPairPacket,probePacket}
						],
						Null
					];

					(* Resolve premixedPrimerProbe to True if primerPair and probe inputs have the same object; Can it be lenient and use Model[Sample] if the packet has it? *)
					premixedPrimerProbe=Which[
						MatchQ[specifiedPremixedPrimerProbe,Except[Automatic]],specifiedPremixedPrimerProbe,
						(resolvedPreparedPlate||NullQ[{primerPairPacket,probePacket}]),Null,
						AllTrue[{primerPairPacket,probePacket},(!NullQ[#])&],premixedPrimerProbeCheck,
						True,Null
					];

					(* Check user-specified input and collect an error if primerProbeAssay is True but objects at that index are different *)
					premixedPrimerProbeError=Or[
						(resolvedPreparedPlate||NullQ[{primerPairPacket,probePacket}])&&!NullQ[premixedPrimerProbe],
						!(resolvedPreparedPlate||NullQ[{primerPairPacket,probePacket}])&&NullQ[premixedPrimerProbe],
						AllTrue[{primerPairPacket,probePacket},(!NullQ[#])&]&&!MatchQ[premixedPrimerProbe,premixedPrimerProbeCheck]
					];

					(* RESOLVE REFERENCE PREMIXED ASSAY OPTION *)
					(* If primer and probe packets are not Null, check if they have the same objects at each index to determine if an assay or primer set is used *)
					referencePremixedPrimerProbeCheck=If[!resolvedPreparedPlate&&AllTrue[{specifiedReferencePrimerPairs,specifiedReferenceProbes},(!NullQ[#])&],
						MapThread[
							Function[{singleReferencePrimerPair,singleReferenceProbe},
								Module[{primerProbeObjectList},
									(* Extract the model object from each of the three packets *)
									primerProbeObjectList=Map[
										Which[
											(* If the object is of type Model[Sample], keep it the same *)
											MatchQ[#,ObjectP[Model[Sample]]],#,
											(* If the object is of type Object[Sample] and Model[Sample] is informed, use Model[Sample] *)
											MatchQ[#,ObjectP[Object[Sample]]]&&MatchQ[Lookup[fetchPacketFromCache[#,simulatedCache],Model],ObjectP[Model[Sample]]],Lookup[fetchPacketFromCache[#,simulatedCache],Model],
											(* In all other cases, use the input object *)
											True,#
										]&,
										Flatten[{singleReferencePrimerPair,singleReferenceProbe}]
									];
									(* Check which objects are the same *)
									Which[
										(* If all three are the same, output TargetAssay *)
										SameQ@@primerProbeObjectList,TargetAssay,
										(* If the primers are the same, output PrimerSet *)
										SameQ@@primerProbeObjectList[[1;;2]],PrimerSet,
										(* If all the samples are unique, output None *)
										True,None
									]
								]
							],
							{specifiedReferencePrimerPairs,specifiedReferenceProbes}
						],
						Null
					];

					(* Resolve premixedPrimerProbe to True if primerPair and probe inputs have the same object; This is lenient as it checks the Model[Sample] for comparison when available instead of Object[Sample] *)
					referencePremixedPrimerProbe=Which[
						MatchQ[specifiedReferencePremixedPrimerProbe,Except[Automatic]],specifiedReferencePremixedPrimerProbe,
						(resolvedPreparedPlate||NullQ[{specifiedReferencePrimerPairs,specifiedReferenceProbes}]),Null,
						AllTrue[{specifiedReferencePrimerPairs,specifiedReferenceProbes},(!NullQ[#])&],referencePremixedPrimerProbeCheck,
						True,Null
					];

					(* Check user-specified input and collect an error if primerProbeAssay is True but objects at that index are different *)
					referencePremixedPrimerProbeError=Or[
						(resolvedPreparedPlate||NullQ[referencePremixedPrimerProbeCheck])&&!NullQ[referencePremixedPrimerProbe],
						!(resolvedPreparedPlate||NullQ[referencePremixedPrimerProbeCheck])&&NullQ[referencePremixedPrimerProbe],
						!NullQ[referencePremixedPrimerProbeCheck]&&!MatchQ[referencePremixedPrimerProbe,referencePremixedPrimerProbeCheck]
					];

					(* RESOLVE TARGET AND REFERENCE PROBE CONCENTRATION OPTIONS *)
					(* Find stock concentrations if probes are informed; Second output is from ConcentrationQ[] *)
					probeStockConcentrationCalculation=If[!resolvedPreparedPlate&&!NullQ[probePacket]&&!premixedPrimerProbeError,
						MapThread[
							molarConcentrationFinder[#1,#2]&,
							{probePacket,premixedPrimerProbe}
						],
						{{Null,Null}}
					];

					probeStockConcentrations=probeStockConcentrationCalculation[[All,1]];
					probeStockConcentrationBoolean=probeStockConcentrationCalculation[[All,2]];

					(* If stock concentration resolves to a list and specifiedProbeConcentration/specifiedProbeVolume is Automatic, and any of the index-matched stock concentration is not found, collect an error *)
					probeStockConcentrationError=If[!resolvedPreparedPlate&&!NullQ[probePacket]&&(MatchQ[specifiedProbeConcentration,Automatic]||MatchQ[specifiedProbeVolume,Automatic]),
						MemberQ[Flatten[{probeStockConcentrationBoolean}],Null],
						False
					];

					(* If  stock concentration resolves to a value and specifiedProbeConcentration/specifiedProbeVolume is Automatic, and concentration is calculated using mass concentration and MW, collect a warning that the calculation may be inaccurate *)
					probeStockConcentrationAccuracyWarning=If[!probeStockConcentrationError&&(MatchQ[specifiedProbeConcentration,Automatic]||MatchQ[specifiedProbeVolume,Automatic]),
						MemberQ[Flatten[{probeStockConcentrationBoolean}],False],
						False
					];

					(* Find stock concentrations if reference probes are informed; Second output is from ConcentrationQ[] *)
					referenceProbeStockConcentrationCalculation=If[!resolvedPreparedPlate&&!NullQ[specifiedReferenceProbes]&&!referencePremixedPrimerProbeError,
						MapThread[
							molarConcentrationFinder[#1,#2]&,
							{specifiedReferenceProbes,referencePremixedPrimerProbe}
						],
						{{Null,Null}}
					];

					referenceProbeStockConcentrations=referenceProbeStockConcentrationCalculation[[All,1]];
					referenceProbeStockConcentrationBoolean=referenceProbeStockConcentrationCalculation[[All,2]];

					(* If stock concentration resolves to a value and specifiedReferenceProbeConcentration/specifiedReferenceProbeVolume is Automatic, and stock concentration is not found, collect an error *)
					referenceProbeStockConcentrationError=If[!resolvedPreparedPlate&&!NullQ[specifiedReferenceProbes]&&(MatchQ[specifiedReferenceProbeConcentration,Automatic]||MatchQ[specifiedReferenceProbeVolume,Automatic]),
						MemberQ[Flatten[{referenceProbeStockConcentrationBoolean}],Null],
						False
					];

					(* If stock concentration resolves to a value and specifiedReferenceProbeConcentration/specifiedReferenceProbeVolume is Automatic, and concentration is calculated using mass concentration and MW, collect a warning that the calculation may be inaccurate *)
					referenceProbeStockConcentrationAccuracyWarning=If[!referenceProbeStockConcentrationError&&(MatchQ[specifiedReferenceProbeConcentration,Automatic]||MatchQ[specifiedReferenceProbeVolume,Automatic]),
						MemberQ[Flatten[{referenceProbeStockConcentrationBoolean}],False],
						False
					];

					(* Set max concentration for probes *)
					maxProbeConcentrationMultiplexing=375.0*Nanomolar;
					maxProbeConcentrationConstant=250.0*Nanomolar;

					(* If amplitudeMultiplex is resolved and no errors are thrown, calculate concentration series *)
					calculatedAllProbeConcentrations=If[!NullQ[amplitudeMultiplexing]&&!amplitudeMultiplexingError&&!singleFluorophorePerProbeError&&!singleFluorophorePerReferenceProbeError&&!probeFluorophoreLengthMismatchError&&!referenceProbeFluorophoreLengthMismatchError&&!probeFluorophoreNullOptionsError&&!referenceProbeFluorophoreNullOptionsError&&Length[allProbeEmissionWavelengths]>0,
						Module[
							{multiplexedProbeConcentrations,flatMultiplexedProbeConcentrations,roundFlatMultiplexedProbeConcentrations,allProbeEmissionChannels,allProbeEmissionPositions,sortedAllProbeConcentrationsWithIndices},
							multiplexedProbeConcentrations=If[#[[2]]>1,Table[1/t,{t,#[[2]]}]*maxProbeConcentrationMultiplexing,#[[2]]*maxProbeConcentrationConstant]&/@amplitudeMultiplexing;
							(* Remove empty channels that are calculated to 0 Nanomolar and flatten the calculated concentration series *)
							flatMultiplexedProbeConcentrations=Flatten[multiplexedProbeConcentrations/.{0.*Nanomolar->{}}];
							(* Round the calculated values to 0.1 Nanomolar precision *)
							roundFlatMultiplexedProbeConcentrations=SafeRound[#,10^-1 Nanomolar]&/@flatMultiplexedProbeConcentrations;
							(* Replace VIC/HEX wavelengths with HEX channel designation in allProbeEmissionwavelengths *)
							allProbeEmissionChannels=allProbeEmissionWavelengths/.{554.0*Nanometer->556.0*Nanometer};
							(* Get indices of each channel type in the channels list *)
							allProbeEmissionPositions=Flatten[Position[allProbeEmissionChannels,#]&/@{517.0*Nanometer,556.0*Nanometer,665.0*Nanometer,694.0*Nanometer}];
							(* Sort probe concentrations using the indices of probes by their channel *)
							sortedAllProbeConcentrationsWithIndices=SortBy[Transpose[{allProbeEmissionPositions,roundFlatMultiplexedProbeConcentrations}],First];
							(* Extract the concentrations sorted in order *)
							sortedAllProbeConcentrationsWithIndices[[All,2]]
						],
						Null
					];

					(* Separate concentrations for target probes vs. reference probes *)
					{calculatedProbeConcentrations,calculatedReferenceProbeConcentrations}=Which[
						AllTrue[{probeEmissionWavelength,referenceProbeEmissionWavelength,calculatedAllProbeConcentrations},(!NullQ[#])&],TakeList[calculatedAllProbeConcentrations,{Length[probeEmissionWavelength],Length[referenceProbeEmissionWavelength]}],
						!NullQ[calculatedAllProbeConcentrations]&&!NullQ[probeEmissionWavelength]&&NullQ[referenceProbeEmissionWavelength],TakeList[calculatedAllProbeConcentrations,{Length[probeEmissionWavelength],0}],
						(* This can happen if samples already have probes that are not resolved and reference probe is added *)
						!NullQ[calculatedAllProbeConcentrations]&&NullQ[probeEmissionWavelength]&&!NullQ[referenceProbeEmissionWavelength],TakeList[calculatedAllProbeConcentrations,{0,Length[referenceProbeEmissionWavelength]}],
						True,{Null,Null}
					];

					(* RESOLVE PROBE CONCENTRATION *)
					probeConcentration=Which[
						(* Accept user-specified concentration *)
						MatchQ[specifiedProbeConcentration,Except[Automatic]],specifiedProbeConcentration,
						(* If concentration is Automatic and this is a prepared plate or no probe input is given, resolve to Null *)
						resolvedPreparedPlate||NullQ[probePacket],Null,
						(* If probe volume is specified and properly index-matched to input, and probe stock concentration is found, calculate probe concentrations *)
						MatchQ[specifiedProbeVolume,Except[Automatic|Null]]&&!primerProbeOptionsLengthError&&!MemberQ[Flatten[{probeStockConcentrations}],Null]&&!probeStockConcentrationError,MapThread[SafeRound[UnitConvert[(#1*#2)/specifiedReactionVolume,Nanomolar],10^-1 Nanomolar]&,{probeStockConcentrations,specifiedProbeVolume}],
						(* If amplitude multiplexing is Null, each probe gets a constant concentration *)
						NullQ[amplitudeMultiplexing]&&!amplitudeMultiplexingError,ConstantArray[maxProbeConcentrationConstant,Length[probePacket]],
						(* If amplitude multiplexing is resolved, use the calculated concentration series *)
						!NullQ[amplitudeMultiplexing]&&!amplitudeMultiplexingError,calculatedProbeConcentrations,
						(* Catch-all *)
						True,Null
					];

					(* ADD THIS IF THERE IS TIME: Check for errors if amplitude multiplexing is resolved to a value and probe concentrations in a channel are the same *)

					(* RESOLVE PROBE VOLUME *)
					probeVolume=Which[
						(* Accept user-specified volume *)
						MatchQ[specifiedProbeVolume,Except[Automatic]],specifiedProbeVolume,
						(* if probe concentration is resolved and probe stock concentrations are found, calculate the volumes *)
						!NullQ[probeConcentration]&&!primerProbeOptionsLengthError&&!NullQ[probeStockConcentrations]&&!probeStockConcentrationError,MapThread[SafeRound[UnitConvert[(#1*specifiedReactionVolume)/#2,Microliter],10^-1 Microliter]&,{probeConcentration,probeStockConcentrations}],
						(* Catch-all *)
						True,Null
					];

					(* Check for errors if mismatch between probeConcentration and probeVolume *)
					probeConcentrationVolumeMismatchOptionError=Or[
						(* If probePacket is Null, but concentration and volume are informed, collect error; and vice versa *)
						If[resolvedPreparedPlate||primerProbeOptionsLengthError,
							False,
							If[NullQ[probePacket],AnyTrue[{probeConcentration,probeVolume},(!NullQ[#])&],AnyTrue[{probeConcentration,probeVolume},NullQ]]
						],
						(* if probeStockConcentration is informed and concentration/volume are resolved, they should match within +/-5% of each other *)
						If[!MemberQ[Flatten[{probeStockConcentrations}],Null]&&!probeStockConcentrationError&&AllTrue[{probeConcentration,probeVolume},(!NullQ[#])&]&&!primerProbeOptionsLengthError,
							!AllTrue[
								MapThread[
									(* Only check this if the probe volume is greater than 1 Microliter otherwise rounding will cause errors *)
									If[#2>1*Microliter,MatchQ[#1,RangeP[((#2*#3)/specifiedReactionVolume)*0.95,((#2*#3)/specifiedReactionVolume)*1.05]],True]&,
									{probeConcentration,probeVolume,probeStockConcentrations}
								],
								TrueQ
							],
							False
						]
					];

					(* Check for errors if probeStockConcentration<(4*probeConcentration) *)
					probeStockConcentrationTooLowError=If[!probeConcentrationVolumeMismatchOptionError&&!probeStockConcentrationError&&!primerProbeOptionsLengthError&&!MemberQ[Flatten[{probeStockConcentrations}],Null]&&!NullQ[probeConcentration],
						!AllTrue[
							MapThread[
								MatchQ[#2,GreaterEqualP[#1*4]]&,
								{probeConcentration,probeStockConcentrations}
							],
							TrueQ
						],
						False
					];

					(* RESOLVE REFERENCE PROBE CONCENTRATION *)
					referenceProbeConcentration=Which[
						(* Accept user-specified concentration *)
						MatchQ[specifiedReferenceProbeConcentration,Except[Automatic]],specifiedReferenceProbeConcentration,
						(* If concentration is Automatic and this is a prepared plate or no reference probe input is given, resolve to Null *)
						resolvedPreparedPlate||NullQ[specifiedReferenceProbes],Null,
						(* If reference probe volume is specified and reference probe stock concentration is found, calculate reference probe concentrations *)
						MatchQ[specifiedReferenceProbeVolume,Except[Automatic|Null]]&&!MemberQ[Flatten[{referenceProbeStockConcentrations}],Null]&&!referenceProbeStockConcentrationError&&!referencePrimerProbeOptionsLengthError,MapThread[SafeRound[UnitConvert[(#1*#2)/specifiedReactionVolume,Nanomolar],10^-1 Nanomolar]&,{referenceProbeStockConcentrations,specifiedReferenceProbeVolume}],
						(* If amplitude multiplexing is Null, each probe gets a constant concentration *)
						NullQ[amplitudeMultiplexing]&&!amplitudeMultiplexingError,ConstantArray[maxProbeConcentrationConstant,Length[specifiedReferenceProbes]],
						(* If amplitude multiplexing is resolved, use the calculated concentration series *)
						!NullQ[amplitudeMultiplexing]&&!amplitudeMultiplexingError,calculatedReferenceProbeConcentrations,
						(* Catch-all *)
						True,Null
					];

					(* ADD THIS IF THERE IS TIME: Check for errors if amplitude multiplexing is resolved to a value and probe concentrations in a channel are the same *)

					(* RESOLVE REFERENCE PROBE VOLUME *)
					referenceProbeVolume=Which[
						(* Accept user-specified volume *)
						MatchQ[specifiedReferenceProbeVolume,Except[Automatic]],specifiedReferenceProbeVolume,
						(* if probe concentration is resolved and probe stock concentrations are found, calculate the volumes *)
						!NullQ[referenceProbeConcentration]&&!referencePrimerProbeOptionsLengthError&&!NullQ[referenceProbeStockConcentrations]&&!referenceProbeStockConcentrationError,MapThread[SafeRound[UnitConvert[(#1*specifiedReactionVolume)/#2,Microliter],10^-1 Microliter]&,{referenceProbeConcentration,referenceProbeStockConcentrations}],
						(* Catch-all *)
						True,Null
					];

					(* Check for errors if mismatch between probeConcentration and probeVolume *)
					referenceProbeConcentrationVolumeMismatchOptionError=Or[
						(* If specifiedReferenceProbes is Null, but concentration and volume are informed, collect error; and vice versa *)
						If[resolvedPreparedPlate||referencePrimerProbeOptionsLengthError,
							False,
							If[NullQ[specifiedReferenceProbes],AnyTrue[{referenceProbeConcentration,referenceProbeVolume},(!NullQ[#])&],AnyTrue[{referenceProbeConcentration,referenceProbeVolume},NullQ]]
						],
						(* if referenceProbeStockConcentration is informed and concentration/volume are resolved, they should match within +/-5% of each other *)
						If[!MemberQ[Flatten[{referenceProbeStockConcentrations}],Null]&&!referenceProbeStockConcentrationError&&AllTrue[{referenceProbeConcentration,referenceProbeVolume},(!NullQ[#])&]&&!referencePrimerProbeOptionsLengthError,
							!AllTrue[
								MapThread[
									If[#2>1*Microliter,MatchQ[#1,RangeP[((#2*#3)/specifiedReactionVolume)*0.95,((#2*#3)/specifiedReactionVolume)*1.05]],True]&,
									{referenceProbeConcentration,referenceProbeVolume,referenceProbeStockConcentrations}
								],
								TrueQ
							],
							False
						]
					];

					(* Check for errors if probeStockConcentration<(4*probeConcentration) *)
					referenceProbeStockConcentrationTooLowError=If[!referenceProbeConcentrationVolumeMismatchOptionError&&!referenceProbeStockConcentrationError&&!referencePrimerProbeOptionsLengthError&&!MemberQ[Flatten[{referenceProbeStockConcentrations}],Null]&&!NullQ[referenceProbeConcentration],
						!AllTrue[
							MapThread[
								MatchQ[#2,GreaterEqualP[#1*4]]&,
								{referenceProbeConcentration,referenceProbeStockConcentrations}
							],
							TrueQ
						],
						False
					];

					(* RESOLVE TARGET AND REFERENCE PRIMER CONCENTRATION OPTIONS *)
					(* Ratio used to convert between primer and probe concentrations *)
					primerProbeConcentrationRatio=18/5;

					(* Isolate the forward primer packets from primerPairPacket *)
					forwardPrimerPacket=primerPairPacket[[All,1]];

					(* Find stock concentrations if forward primers are informed; Second output is from ConcentrationQ[] *)
					forwardPrimerStockConcentrationCalculation=If[!resolvedPreparedPlate&&!NullQ[forwardPrimerPacket]&&!premixedPrimerProbeError,
						MapThread[
							molarConcentrationFinder[#1,#2]&,
							{forwardPrimerPacket,premixedPrimerProbe}
						],
						{{Null,Null}}
					];

					forwardPrimerStockConcentrations=forwardPrimerStockConcentrationCalculation[[All,1]];
					forwardPrimerStockConcentrationBoolean=forwardPrimerStockConcentrationCalculation[[All,2]];

					(* If stock concentration resolves to a list and specifiedForwardPrimerConcentration/specifiedForwardPrimerVolume is Automatic, and any of the index-matched stock concentration is not found, collect an error *)
					forwardPrimerStockConcentrationError=If[!resolvedPreparedPlate&&!NullQ[forwardPrimerPacket]&&(MatchQ[specifiedForwardPrimerConcentration,Automatic]||MatchQ[specifiedForwardPrimerVolume,Automatic]),
						MemberQ[Flatten[{forwardPrimerStockConcentrationBoolean}],Null],
						False
					];

					(* If  stock concentration resolves to a value and specifiedForwardPrimerConcentration/specifiedForwardPrimerVolume is Automatic, and concentration is calculated using mass concentration and MW, collect a warning that the calculation may be inaccurate *)
					forwardPrimerStockConcentrationAccuracyWarning=If[!forwardPrimerStockConcentrationError&&(MatchQ[specifiedForwardPrimerConcentration,Automatic]||MatchQ[specifiedForwardPrimerVolume,Automatic]),
						MemberQ[Flatten[{forwardPrimerStockConcentrationBoolean}],False],
						False
					];

					(* RESOLVE FORWARD PRIMER CONCENTRATION *)
					forwardPrimerConcentration=Which[
						(* Accept user-specified concentration *)
						MatchQ[specifiedForwardPrimerConcentration,Except[Automatic]],specifiedForwardPrimerConcentration,
						(* If concentration is Automatic and this is a prepared plate or no forward primer input is given, resolve to Null *)
						resolvedPreparedPlate||NullQ[forwardPrimerPacket],Null,
						(* If concentration is Automatic, forward primer volume is specified and forward primer stock concentration is resolved without errors, calculate the concentration *)
						MatchQ[specifiedForwardPrimerVolume,Except[Automatic|NullP]]&&!MemberQ[Flatten[{forwardPrimerStockConcentrations}],Null]&&!forwardPrimerStockConcentrationError&&!primerProbeOptionsLengthError&&!primerProbeOptionsLengthError,MapThread[SafeRound[UnitConvert[(#1*#2)/specifiedReactionVolume,Nanomolar],10^-1 Nanomolar]&,{forwardPrimerStockConcentrations,specifiedForwardPrimerVolume}],
						(* If concentration is Automatic, probeConcentration is resolved without errors, premixedPrimerProbe is resolved without errors *)
						AllTrue[{probeConcentration,premixedPrimerProbe},(!NullQ[#])&]&&!probeConcentrationVolumeMismatchOptionError&&!premixedPrimerProbeError&&!primerProbeOptionsLengthError,MapThread[If[MatchQ[#2,Except[TargetAssay]],SafeRound[#1*primerProbeConcentrationRatio,10^-1 Nanomolar],0. Nanomolar]&,{probeConcentration,premixedPrimerProbe}],
						True,Null
					];

					(* ADD THIS IF THERE IS TIME: Check for errors if amplitude multiplexing is resolved to a value and probe concentrations in a channel are the same *)

					(* RESOLVE FORWARD PRIMER VOLUME *)
					forwardPrimerVolume=Which[
						(* Accept user-specified volume *)
						MatchQ[specifiedForwardPrimerVolume,Except[Automatic]],specifiedForwardPrimerVolume,
						(* if forward primer concentration is resolved and forward primer stock concentrations are found, calculate the volumes *)
						!NullQ[forwardPrimerConcentration]&&!AnyTrue[forwardPrimerStockConcentrations,NullQ]&&!forwardPrimerStockConcentrationError&&!primerProbeOptionsLengthError,MapThread[SafeRound[UnitConvert[(#1*specifiedReactionVolume)/#2,Microliter],10^-1 Microliter]&,{forwardPrimerConcentration,forwardPrimerStockConcentrations}],
						(* Catch-all *)
						True,Null
					];

					(* Check for errors if mismatch between probeConcentration and probeVolume *)
					forwardPrimerConcentrationVolumeMismatchOptionError=Or[
						(* If forwardPrimerPacket is Null, concentration and volume should be Null *)
						If[resolvedPreparedPlate||primerProbeOptionsLengthError,
							False,
							Which[
								(* If no forward primers are provided, Conc/Volume should be Null *)
								NullQ[forwardPrimerPacket]&&!NullQ[forwardPrimerConcentration]&&!NullQ[forwardPrimerVolume],True,
								(* If primers are provided, Conc/Volume should not be Null *)
								!NullQ[forwardPrimerPacket]&&!premixedPrimerProbeError&&(NullQ[forwardPrimerConcentration]||NullQ[forwardPrimerVolume]),True,
								True,False
							]
						],
						(* If forwardPrimerStockConcentration is informed and concentration/volume are resolved, they should match within +/-5% of each other *)
						If[!MemberQ[Flatten[{forwardPrimerStockConcentrations}],Null]&&!forwardPrimerStockConcentrationError&&AllTrue[{forwardPrimerConcentration,forwardPrimerVolume},(!NullQ[#])&]&&!primerProbeOptionsLengthError,
							!AllTrue[
								MapThread[
									If[TrueQ[#2>1*Microliter],MatchQ[#1,RangeP[((#2*#3)/specifiedReactionVolume)*0.95,((#2*#3)/specifiedReactionVolume)*1.05]],True]&,
									{forwardPrimerConcentration,forwardPrimerVolume,forwardPrimerStockConcentrations}
								],
								TrueQ
							],
							False
						],
						(* For a mixture of TargetAssay, PrimerSet and None in premixedPrimerProbe, the concentration and volume should be 0 Nanomolar at the same indices as TargetAssay *)
						If[AllTrue[{forwardPrimerConcentration,forwardPrimerVolume},(!NullQ[#])&]&&!primerProbeOptionsLengthError,
							!AllTrue[
								MapThread[
									If[MatchQ[#3,TargetAssay],
										EqualQ[#1,0*Nanomolar]&&EqualQ[#2,0*Microliter],
										True
									]&,
									{forwardPrimerConcentration,forwardPrimerVolume,premixedPrimerProbe}
								],
								TrueQ
							],
							False
						]
					];

					(* Check for errors if forwardPrimerStockConcentration<(4*forwardPrimerConcentration) *)
					forwardPrimerStockConcentrationTooLowError=If[!forwardPrimerConcentrationVolumeMismatchOptionError&&!forwardPrimerStockConcentrationError&&!MemberQ[Flatten[{forwardPrimerStockConcentrations}],Null]&&!NullQ[forwardPrimerConcentration]&&!primerProbeOptionsLengthError&&!premixedPrimerProbeError,
						!AllTrue[
							MapThread[
								If[MatchQ[#3,None],
									MatchQ[#2,GreaterEqualP[#1*4]],
									True
								]&,
								{forwardPrimerConcentration,forwardPrimerStockConcentrations,premixedPrimerProbe}
							],
							TrueQ
						],
						False
					];

					(* Isolate the reverse primer packets from primerPairPacket *)
					reversePrimerPacket=primerPairPacket[[All,2]];

					(* Find stock concentrations if reverse primers are informed; Second output is from ConcentrationQ[] *)
					reversePrimerStockConcentrationCalculation=If[!resolvedPreparedPlate&&!NullQ[reversePrimerPacket]&&!premixedPrimerProbeError,
						MapThread[
							molarConcentrationFinder[#1,#2]&,
							{reversePrimerPacket,premixedPrimerProbe}
						],
						{{Null,Null}}
					];

					reversePrimerStockConcentrations=reversePrimerStockConcentrationCalculation[[All,1]];
					reversePrimerStockConcentrationBoolean=reversePrimerStockConcentrationCalculation[[All,2]];

					(* If stock concentration resolves to a list and specifiedReversePrimerConcentration/specifiedReversePrimerVolume is Automatic, and any of the index-matched stock concentration is not found, collect an error *)
					reversePrimerStockConcentrationError=If[!resolvedPreparedPlate&&!NullQ[reversePrimerPacket]&&(MatchQ[specifiedReversePrimerConcentration,Automatic]||MatchQ[specifiedReversePrimerVolume,Automatic]),
						MemberQ[Flatten[{reversePrimerStockConcentrationBoolean}],Null],
						False
					];

					(* If  stock concentration resolves to a value and specifiedReversePrimerConcentration/specifiedReversePrimerVolume is Automatic, and concentration is calculated using mass concentration and MW, collect a warning that the calculation may be inaccurate *)
					reversePrimerStockConcentrationAccuracyWarning=If[!NullQ[reversePrimerStockConcentrations]&&(MatchQ[specifiedReversePrimerConcentration,Automatic]||MatchQ[specifiedReversePrimerVolume,Automatic]),
						MemberQ[Flatten[{reversePrimerStockConcentrationBoolean}],False],
						False
					];

					(* RESOLVE REVERSE PRIMER CONCENTRATION *)
					reversePrimerConcentration=Which[
						(* Accept user-specified concentration *)
						MatchQ[specifiedReversePrimerConcentration,Except[Automatic]],specifiedReversePrimerConcentration,
						(* If concentration is Automatic and this is a prepared plate or no reverse primer input is given, resolve to Null *)
						resolvedPreparedPlate||NullQ[reversePrimerPacket],Null,
						(* If concentration is Automatic, reverse primer volume is specified and reverse primer stock concentration is resolved without errors, calculate the concentration *)
						MatchQ[specifiedReversePrimerVolume,Except[Automatic|NullP]]&&!MemberQ[Flatten[{reversePrimerStockConcentrations}],Null]&&!reversePrimerStockConcentrationError&&!primerProbeOptionsLengthError,MapThread[SafeRound[UnitConvert[(#1*#2)/specifiedReactionVolume,Nanomolar],10^-1 Nanomolar]&,{reversePrimerStockConcentrations,specifiedReversePrimerVolume}],
						(* If concentration is Automatic and forward primer concentration is resolved, only copy the concentrations where premixedPrimerProbe is None and have Null for all other cases *)
						!NullQ[forwardPrimerConcentration]&&!NullQ[premixedPrimerProbe]&&!premixedPrimerProbeError,MapThread[If[MatchQ[#2,None],#1,0. Nanomolar]&,{forwardPrimerConcentration,premixedPrimerProbe}],
						(* If concentration is Automatic, probeConcentration is resolved without errors, premixedPrimerProbe is resolved without errors *)
						AllTrue[{probeConcentration,premixedPrimerProbe},(!NullQ[#])&]&&!probeConcentrationVolumeMismatchOptionError&&!premixedPrimerProbeError&&!primerProbeOptionsLengthError,MapThread[If[MatchQ[#2,None],SafeRound[#1*primerProbeConcentrationRatio,10^-1 Nanomolar],0. Nanomolar]&,{probeConcentration,premixedPrimerProbe}],
						True,Null
					];

					(* RESOLVE REVERSE PRIMER VOLUME *)
					reversePrimerVolume=Which[
						(* Accept user-specified volume *)
						MatchQ[specifiedReversePrimerVolume,Except[Automatic]],specifiedReversePrimerVolume,
						(* if reverse primer concentration is resolved and reverse primer stock concentrations are found, calculate the volumes *)
						!NullQ[reversePrimerConcentration]&&!NullQ[reversePrimerStockConcentrations]&&!reversePrimerStockConcentrationError&&!primerProbeOptionsLengthError,MapThread[SafeRound[UnitConvert[(#1*specifiedReactionVolume)/#2,Microliter],10^-1 Microliter]&,{reversePrimerConcentration,reversePrimerStockConcentrations}],
						(* Catch-all *)
						True,Null
					];

					(* Check for errors if mismatch between probeConcentration and probeVolume *)
					reversePrimerConcentrationVolumeMismatchOptionError=Or[
						(* If reversePrimerPacket is Null, concentration and volume should be Null *)
						If[resolvedPreparedPlate||primerProbeOptionsLengthError,
							False,
							Which[
								(* If no reverse primers are provided, Conc/Volume should be Null *)
								NullQ[reversePrimerPacket]&&!NullQ[reversePrimerConcentration]&&!NullQ[reversePrimerVolume],True,
								(* If primers are provided, no TargetAssay/PrimerSet is used, Conc/Volume should not be Null *)
								!NullQ[reversePrimerPacket]&&!premixedPrimerProbeError&&(NullQ[reversePrimerConcentration]||NullQ[reversePrimerVolume]),True,
								True,False
							]
						],
						(* If reversePrimerStockConcentration is informed and concentration/volume are resolved, they should match within +/-5% of each other *)
						If[!MemberQ[Flatten[{reversePrimerStockConcentrations}],Null]&&!reversePrimerStockConcentrationError&&AllTrue[{reversePrimerConcentration,reversePrimerVolume},(!NullQ[#])&]&&!primerProbeOptionsLengthError,
							!AllTrue[
								MapThread[
									If[TrueQ[#2>1*Microliter],MatchQ[#1,RangeP[((#2*#3)/specifiedReactionVolume)*0.95,((#2*#3)/specifiedReactionVolume)*1.05]],True]&,
									{reversePrimerConcentration,reversePrimerVolume,reversePrimerStockConcentrations}
								],
								TrueQ
							],
							False
						],
						(* For a mixture of TargetAssay, PrimerSet and None in premixedPrimerPair, the concentration and volume should be 0 Nanomolar at the same indices as TargetAssay or PrimerSet *)
						If[AllTrue[{reversePrimerConcentration,reversePrimerVolume},(!NullQ[#])&]&&!primerProbeOptionsLengthError,
							!AllTrue[
								MapThread[
									If[MatchQ[#3,TargetAssay|PrimerSet],
										EqualQ[#1,0*Nanomolar]&&EqualQ[#2,0*Microliter],
										True
									]&,
									{reversePrimerConcentration,reversePrimerVolume,premixedPrimerProbe}
								],
								TrueQ
							],
							False
						]
					];

					(* Check for errors if reversePrimerStockConcentration<(4*reversePrimerConcentration) *)
					reversePrimerStockConcentrationTooLowError=If[!reversePrimerConcentrationVolumeMismatchOptionError&&!reversePrimerStockConcentrationError&&!MemberQ[Flatten[{reversePrimerStockConcentrations}],Null]&&!NullQ[reversePrimerConcentration]&&!primerProbeOptionsLengthError&&!premixedPrimerProbeError,
						!AllTrue[
							MapThread[
								If[MatchQ[#3,None],
									MatchQ[#2,GreaterEqualP[#1*4]],
									True
								]&,
								{reversePrimerConcentration,reversePrimerStockConcentrations,premixedPrimerProbe}
							],
							TrueQ
						],
						False
					];

					(* RESOLVING REFERENCE PRIMER OPTIONS *)
					(* Isolate the reference forward primer packets from ReferencePrimerPairs *)
					referenceForwardPrimers=If[!NullQ[specifiedReferencePrimerPairs],specifiedReferencePrimerPairs[[All,1]],Null];

					(* Find stock concentrations if reference forward primers are informed; Second output is from ConcentrationQ[] *)
					referenceForwardPrimerStockConcentrationCalculation=If[!resolvedPreparedPlate&&!NullQ[referenceForwardPrimers]&&!referencePremixedPrimerProbeError,
						MapThread[
							molarConcentrationFinder[#1,#2]&,
							{referenceForwardPrimers,referencePremixedPrimerProbe}
						],
						{{Null,Null}}
					];

					referenceForwardPrimerStockConcentrations=referenceForwardPrimerStockConcentrationCalculation[[All,1]];
					referenceForwardPrimerStockConcentrationBoolean=referenceForwardPrimerStockConcentrationCalculation[[All,2]];

					(* If stock concentration resolves to a list and specifiedReferenceForwardPrimerConcentration/specifiedReferenceForwardPrimerVolume is Automatic, and any of the index-matched stock concentration is not found, collect an error *)
					referenceForwardPrimerStockConcentrationError=If[!resolvedPreparedPlate&&!NullQ[referenceForwardPrimers]&&(MatchQ[specifiedReferenceForwardPrimerConcentration,Automatic]||MatchQ[specifiedReferenceForwardPrimerVolume,Automatic]),
						MemberQ[Flatten[{referenceForwardPrimerStockConcentrationBoolean}],Null],
						False
					];

					(* If  stock concentration resolves to a value and specifiedReferenceForwardPrimerConcentration/specifiedReferenceForwardPrimerVolume is Automatic, and concentration is calculated using mass concentration and MW, collect a warning that the calculation may be inaccurate *)
					referenceForwardPrimerStockConcentrationAccuracyWarning=If[!referenceForwardPrimerStockConcentrationError&&(MatchQ[specifiedReferenceForwardPrimerConcentration,Automatic]||MatchQ[specifiedReferenceForwardPrimerVolume,Automatic]),
						MemberQ[Flatten[{referenceForwardPrimerStockConcentrationBoolean}],False],
						False
					];

					(* RESOLVE REFERENCE FORWARD PRIMER CONCENTRATION *)
					referenceForwardPrimerConcentration=Which[
						(* Accept user-specified concentration *)
						MatchQ[specifiedReferenceForwardPrimerConcentration,Except[Automatic]],specifiedReferenceForwardPrimerConcentration,
						(* If concentration is Automatic and this is a prepared plate or no reference forward primer input is given, resolve to Null *)
						resolvedPreparedPlate||NullQ[referenceForwardPrimers],Null,
						(* If concentration is Automatic, reference forward primer volume is specified and reference forward primer stock concentration is resolved without errors, calculate the concentration *)
						MatchQ[specifiedReferenceForwardPrimerVolume,Except[Automatic|NullP]]&&!MemberQ[Flatten[{referenceForwardPrimerStockConcentrations}],Null]&&!referenceForwardPrimerStockConcentrationError&&!referencePrimerProbeOptionsLengthError&&!referencePrimerProbeOptionsLengthError,MapThread[SafeRound[UnitConvert[(#1*#2)/specifiedReactionVolume,Nanomolar],10^-1 Nanomolar]&,{referenceForwardPrimerStockConcentrations,specifiedReferenceForwardPrimerVolume}],
						(* If concentration is Automatic, referenceProbeConcentration is resolved without errors, referencePremixedPrimerProbe is resolved without errors *)
						AllTrue[{referenceProbeConcentration,referencePremixedPrimerProbe},(!NullQ[#])&]&&!referenceProbeConcentrationVolumeMismatchOptionError&&!referencePremixedPrimerProbeError&&!referencePrimerProbeOptionsLengthError,MapThread[If[MatchQ[#2,Except[TargetAssay]],SafeRound[#1*primerProbeConcentrationRatio,10^-1 Nanomolar],0. Nanomolar]&,{referenceProbeConcentration,referencePremixedPrimerProbe}],
						True,Null
					];

					(* RESOLVE REFERENCE FORWARD PRIMER VOLUME *)
					referenceForwardPrimerVolume=Which[
						(* Accept user-specified volume *)
						MatchQ[specifiedReferenceForwardPrimerVolume,Except[Automatic]],specifiedReferenceForwardPrimerVolume,
						(* if reference forward primer concentration is resolved and reference forward primer stock concentrations are found, calculate the volumes *)
						!NullQ[referenceForwardPrimerConcentration]&&!AnyTrue[referenceForwardPrimerStockConcentrations,NullQ]&&!referenceForwardPrimerStockConcentrationError&&!referencePrimerProbeOptionsLengthError,MapThread[SafeRound[UnitConvert[(#1*specifiedReactionVolume)/#2,Microliter],10^-1 Microliter]&,{referenceForwardPrimerConcentration,referenceForwardPrimerStockConcentrations}],
						(* Catch-all *)
						True,Null
					];

					(* Check for errors if mismatch between probeConcentration and probeVolume *)
					referenceForwardPrimerConcentrationVolumeMismatchOptionError=Or[
						(* If referenceForwardPrimers is Null, concentration and volume should be Null *)
						If[resolvedPreparedPlate||referencePrimerProbeOptionsLengthError,
							False,
							Which[
								(* If no reference forward primers are provided, Conc/Volume should be Null *)
								NullQ[referenceForwardPrimers]&&!NullQ[referenceForwardPrimerConcentration]&&!NullQ[referenceForwardPrimerVolume],True,
								(* If primers are provided, Conc/Volume should not be Null *)
								!NullQ[referenceForwardPrimers]&&!referencePremixedPrimerProbeError&&(NullQ[referenceForwardPrimerConcentration]||NullQ[referenceForwardPrimerVolume]),True,
								True,False
							]
						],
						(* If referenceForwardPrimerStockConcentration is informed and concentration/volume are resolved, they should match within +/-5% of each other *)
						If[!MemberQ[Flatten[{referenceForwardPrimerStockConcentrations}],Null]&&!referenceForwardPrimerStockConcentrationError&&AllTrue[{referenceForwardPrimerConcentration,referenceForwardPrimerVolume},(!NullQ[#])&]&&!referencePrimerProbeOptionsLengthError,
							!AllTrue[
								MapThread[
									If[TrueQ[#2>1*Microliter],MatchQ[#1,RangeP[((#2*#3)/specifiedReactionVolume)*0.95,((#2*#3)/specifiedReactionVolume)*1.05]],True]&,
									{referenceForwardPrimerConcentration,referenceForwardPrimerVolume,referenceForwardPrimerStockConcentrations}
								],
								TrueQ
							],
							False
						],
						(* For a mixture of TargetAssay, PrimerSet and None in referencPremixedPrimerPair, the concentration and volume should be Null at the same indices as TargetAssay *)
						If[AllTrue[{referenceForwardPrimerConcentration,referenceForwardPrimerVolume},(!NullQ[#])&]&&!referencePrimerProbeOptionsLengthError,
							!AllTrue[
								MapThread[
									If[MatchQ[#3,TargetAssay],
										EqualQ[#1,0*Nanomolar]&&EqualQ[#2,0*Microliter],
										True
									]&,
									{referenceForwardPrimerConcentration,referenceForwardPrimerVolume,referencePremixedPrimerProbe}
								],
								TrueQ
							],
							False
						]
					];

					(* Check for errors if referenceForwardPrimerStockConcentration<(4*referenceForwardPrimerConcentration) *)
					referenceForwardPrimerStockConcentrationTooLowError=If[!referenceForwardPrimerConcentrationVolumeMismatchOptionError&&!referenceForwardPrimerStockConcentrationError&&!MemberQ[Flatten[{referenceForwardPrimerStockConcentrations}],Null]&&!NullQ[referenceForwardPrimerConcentration]&&!referencePrimerProbeOptionsLengthError&&!referencePremixedPrimerProbeError,
						!AllTrue[
							MapThread[
								If[MatchQ[#3,None],
									MatchQ[#2,GreaterEqualP[#1*4]],
									True
								]&,
								{referenceForwardPrimerConcentration,referenceForwardPrimerStockConcentrations,referencePremixedPrimerProbe}
							],
							TrueQ
						],
						False
					];

					(* Isolate the reference reverse primer packets from ReferencePrimerPairs *)
					referenceReversePrimers=If[!NullQ[specifiedReferencePrimerPairs],specifiedReferencePrimerPairs[[All,2]],Null];

					(* Find stock concentrations if reference reverse primers are informed; Second output is from ConcentrationQ[] *)
					referenceReversePrimerStockConcentrationCalculation=If[!resolvedPreparedPlate&&!NullQ[referenceReversePrimers]&&!referencePremixedPrimerProbeError,
						MapThread[
							molarConcentrationFinder[#1,#2]&,
							{referenceReversePrimers,referencePremixedPrimerProbe}
						],
						{{Null,Null}}
					];

					referenceReversePrimerStockConcentrations=referenceReversePrimerStockConcentrationCalculation[[All,1]];
					referenceReversePrimerStockConcentrationBoolean=referenceReversePrimerStockConcentrationCalculation[[All,2]];

					(* If stock concentration resolves to a list and specifiedReferenceReversePrimerConcentration/specifiedReferenceReversePrimerVolume is Automatic, and any of the index-matched stock concentration is not found, collect an error *)
					referenceReversePrimerStockConcentrationError=If[!resolvedPreparedPlate&&!NullQ[referenceReversePrimers]&&(MatchQ[specifiedReferenceReversePrimerConcentration,Automatic]||MatchQ[specifiedReferenceReversePrimerVolume,Automatic]),
						MemberQ[Flatten[{referenceReversePrimerStockConcentrationBoolean}],Null],
						False
					];

					(* If  stock concentration resolves to a value and specifiedReferenceReversePrimerConcentration/specifiedReferenceReversePrimerVolume is Automatic, and concentration is calculated using mass concentration and MW, collect a warning that the calculation may be inaccurate *)
					referenceReversePrimerStockConcentrationAccuracyWarning=If[!referenceReversePrimerStockConcentrationError&&(MatchQ[specifiedReferenceReversePrimerConcentration,Automatic]||MatchQ[specifiedReferenceReversePrimerVolume,Automatic]),
						MemberQ[Flatten[{referenceReversePrimerStockConcentrationBoolean}],False],
						False
					];

					(* RESOLVE REFERENCE REVERSE PRIMER CONCENTRATION *)
					referenceReversePrimerConcentration=Which[
						(* Accept user-specified concentration *)
						MatchQ[specifiedReferenceReversePrimerConcentration,Except[Automatic]],specifiedReferenceReversePrimerConcentration,
						(* If concentration is Automatic and this is a prepared plate or no reverse primer input is given, resolve to Null *)
						resolvedPreparedPlate||NullQ[referenceReversePrimers],Null,
						(* If concentration is Automatic, reference reverse primer volume is specified and reference reverse primer stock concentration is resolved without errors, calculate the concentration *)
						MatchQ[specifiedReferenceReversePrimerVolume,Except[Automatic|NullP]]&&!MemberQ[Flatten[{referenceReversePrimerStockConcentrations}],Null]&&!referenceReversePrimerStockConcentrationError&&!referencePrimerProbeOptionsLengthError&&!referencePrimerProbeOptionsLengthError,MapThread[SafeRound[UnitConvert[(#1*#2)/specifiedReactionVolume,Nanomolar],10^-1 Nanomolar]&,{referenceReversePrimerStockConcentrations,specifiedReferenceReversePrimerVolume}],
						(* If concentration is Automatic and reference forward primer concentration is resolved, only copy the concentrations where referencePremixedPrimerProbe is None and have Null for all other cases *)
						!NullQ[referenceForwardPrimerConcentration]&&!NullQ[referencePremixedPrimerProbe]&&!referencePremixedPrimerProbeError,MapThread[If[MatchQ[#2,None],#1,0. Nanomolar]&,{referenceForwardPrimerConcentration,referencePremixedPrimerProbe}],
						(* If concentration is Automatic, referenceProbeConcentration is resolved without errors, referencePremixedPrimerProbe is resolved without errors *)
						AllTrue[{referenceProbeConcentration,referencePremixedPrimerProbe},(!NullQ[#])&]&&!referenceProbeConcentrationVolumeMismatchOptionError&&!referencePremixedPrimerProbeError&&!referencePrimerProbeOptionsLengthError,MapThread[If[MatchQ[#2,None],SafeRound[#1*primerProbeConcentrationRatio,10^-1 Nanomolar],0. Nanomolar]&,{referenceProbeConcentration,referencePremixedPrimerProbe}],
						True,Null
					];

					(* RESOLVE REFERENCE REVERSE PRIMER VOLUME *)
					referenceReversePrimerVolume=Which[
						(* Accept user-specified volume *)
						MatchQ[specifiedReferenceReversePrimerVolume,Except[Automatic]],specifiedReferenceReversePrimerVolume,
						(* if reference reverse primer concentration is resolved and reference reverse primer stock concentrations are found, calculate the volumes *)
						!NullQ[referenceReversePrimerConcentration]&&!NullQ[referenceReversePrimerStockConcentrations]&&!referenceReversePrimerStockConcentrationError&&!referencePrimerProbeOptionsLengthError,MapThread[SafeRound[UnitConvert[(#1*specifiedReactionVolume)/#2,Microliter],10^-1 Microliter]&,{referenceReversePrimerConcentration,referenceReversePrimerStockConcentrations}],
						(* Catch-all *)
						True,Null
					];

					(* Check for errors if mismatch between probeConcentration and probeVolume *)
					referenceReversePrimerConcentrationVolumeMismatchOptionError=Or[
						(* If referenceReversePrimers is Null, concentration and volume should be Null *)
						If[resolvedPreparedPlate||referencePrimerProbeOptionsLengthError,
							False,
							Which[
								(* If no reference reverse primers are provided, Conc/Volume should be Null *)
								NullQ[referenceReversePrimers]&&!NullQ[referenceReversePrimerConcentration]&&!NullQ[referenceReversePrimerVolume],True,
								(* If primers are provided, Conc/Volume should not be Null *)
								!NullQ[referenceReversePrimers]&&!referencePremixedPrimerProbeError&&(NullQ[referenceReversePrimerConcentration]||NullQ[referenceReversePrimerVolume]),True,
								True,False
							]
						],
						(* If referenceReversePrimerStockConcentration is informed and concentration/volume are resolved, they should match within +/-5% of each other *)
						If[!MemberQ[Flatten[{referenceReversePrimerStockConcentrations}],Null]&&!referenceReversePrimerStockConcentrationError&&AllTrue[{referenceReversePrimerConcentration,referenceReversePrimerVolume},(!NullQ[#])&]&&!referencePrimerProbeOptionsLengthError,
							!AllTrue[
								MapThread[
									If[TrueQ[#2>1*Microliter],MatchQ[#1,RangeP[((#2*#3)/specifiedReactionVolume)*0.95,((#2*#3)/specifiedReactionVolume)*1.05]],True]&,
									{referenceReversePrimerConcentration,referenceReversePrimerVolume,referenceReversePrimerStockConcentrations}
								],
								TrueQ
							],
							False
						],
						(* For a mixture of TargetAssay, PrimerSet and None in referencePremixedPrimerPair, the concentration and volume should be Null at the same indices as TargetAssay or PrimerSet *)
						If[AllTrue[{referenceReversePrimerConcentration,referenceReversePrimerVolume},(!NullQ[#])&]&&!referencePrimerProbeOptionsLengthError,
							!AllTrue[
								MapThread[
									If[MatchQ[#3,TargetAssay|PrimerSet],
										EqualQ[#1,0*Nanomolar]&&EqualQ[#2,0*Microliter],
										True
									]&,
									{referenceReversePrimerConcentration,referenceReversePrimerVolume,referencePremixedPrimerProbe}
								],
								TrueQ
							],
							False
						]
					];

					(* Check for errors if referenceReversePrimerStockConcentration<(4*referenceReversePrimerConcentration) *)
					referenceReversePrimerStockConcentrationTooLowError=If[!referenceReversePrimerConcentrationVolumeMismatchOptionError&&!referenceReversePrimerStockConcentrationError&&!referencePrimerProbeOptionsLengthError&&!MemberQ[Flatten[{referenceReversePrimerStockConcentrations}],Null]&&!NullQ[referenceReversePrimerConcentration]&&!referencePremixedPrimerProbeError,
						!AllTrue[
							MapThread[
								If[MatchQ[#3,None],
									MatchQ[#2,GreaterEqualP[#1*4]],
									True
								]&,
								{referenceReversePrimerConcentration,referenceReversePrimerStockConcentrations,referencePremixedPrimerProbe}
							],
							TrueQ
						],
						False
					];

					(*- RESOLVING REVERSE TRANSCRIPTION -*)
					(*
						Resolution of reverseTranscriptionSwitch depends on:
							1. samplePacket contains Model[Molecule,Oligomer] with PolymerType->RNA
							2. User provides RT specific master mix
							3. Any of the other RT thermocycling options are informed
					 *)

					(* Step 1. Determine if RNA is a polymer type for any of the Model[Molecule,Oligomer] in composition of samplePacket *)
					sampleIdentityModelPolymerTypes=Module[
						{
							flatSampleCompositionList, compositionModelLinksList,compositionModelOligomerPackets
						},
						(* Extract contents of Composition field from sample packet and create a flat list *)
						flatSampleCompositionList=Flatten[Lookup[samplePacket,Composition,Null]];
						(* Find all objects of type Model[Molecule,Oligomer] *)
						compositionModelLinksList=Cases[flatSampleCompositionList,ObjectP[Model[Molecule,Oligomer]]];
						(* Get packets related to identity oligomer models *)
						compositionModelOligomerPackets=Map[
							fetchPacketFromCache[#,simulatedCache]&,
							compositionModelLinksList
						];
						(* Extract polymer type from each identity oligomer model packet and output a list *)
						Lookup[compositionModelOligomerPackets,PolymerType,Null]
					];

					(* Step 2. Determine the model of user specified MasterMix *)
					specifiedMasterMixModel=masterMixModelFinder[Lookup[options,MasterMix]];

					(*
						Idea: Check if a recommended master mix is in sample composition
						Can't because composition only allows identity models, but mastermix can only be Model[Sample]!
					*)

					(* Resolve reverse transcription master switch *)
					reverseTranscriptionSwitch=Which[
						BooleanQ[Lookup[options,ReverseTranscription]],Lookup[options,ReverseTranscription],
						MatchQ[Lookup[options,ReverseTranscription],Automatic]&&(TimeQ[Lookup[options,ReverseTranscriptionTime]]||TemperatureQ[Lookup[options,ReverseTranscriptionTemperature]]||TemperatureRampRateQ[Lookup[options,ReverseTranscriptionRampRate]]||MemberQ[reverseTranscriptionMasterMixModel,specifiedMasterMixModel]||MemberQ[sampleIdentityModelPolymerTypes,RNA]),True,
						True,False
					];

					(* ReverseTranscriptionTime resolves to 15 minute if reverseTranscriptionSwitch is True, or Null otherwise *)
					reverseTranscriptionTime=Which[
						MatchQ[Lookup[options,ReverseTranscriptionTime],Except[Automatic]],Lookup[options,ReverseTranscriptionTime],
						MatchQ[Lookup[options,ReverseTranscriptionTime],Automatic]&&reverseTranscriptionSwitch,15 Minute,
						True,Null
					];

					(* ReverseTranscriptionTemperature resolves to 50 degrees Celsius if reverseTranscriptionSwitch is True, or Null otherwise*)
					reverseTranscriptionTemperature=Which[
						MatchQ[Lookup[options,ReverseTranscriptionTemperature],Except[Automatic]],Lookup[options,ReverseTranscriptionTemperature],
						MatchQ[Lookup[options,ReverseTranscriptionTemperature],Automatic]&&reverseTranscriptionSwitch,50 Celsius,
						True,Null
					];

					(* ReverseTranscriptionRampRate resolves to 1.6 degrees Celsius per second if reverseTranscriptionSwitch is True, or Null otherwise*)
					reverseTranscriptionRampRate=Which[
						MatchQ[Lookup[options,ReverseTranscriptionRampRate],Except[Automatic]],Lookup[options,ReverseTranscriptionRampRate],
						MatchQ[Lookup[options,ReverseTranscriptionRampRate],Automatic]&&reverseTranscriptionSwitch,1.6 (Celsius/Second),
						True,Null
					];

					(* Check that when reverseTranscriptionSwitch is True, all the ReverseTranscription options are specified, or when reverseTranscriptionSwitch is False, all the ReverseTranscription options are Null *)
					reverseTranscriptionMismatchOptionsError=!Or[
						reverseTranscriptionSwitch&&TimeQ[reverseTranscriptionTime]&&TemperatureQ[reverseTranscriptionTemperature]&&TemperatureRampRateQ[reverseTranscriptionRampRate],
						!reverseTranscriptionSwitch&&NullQ[{reverseTranscriptionTime,reverseTranscriptionTemperature,reverseTranscriptionRampRate}]
					];

					(*- RESOLVING MASTER MIX -*)
					(* How to resolve automatic for MasterMix
						1. If reverseTranscriptionSwitch is True, use RT-specific master mix
						2. If amplitude multiplexing resolves to values, use multiplexing-specific master mix with higher concentration
						3. Default supermix for probes
					 *)

					masterMix=Which[
						MatchQ[Lookup[options,MasterMix],Except[Automatic]],Lookup[options,MasterMix],
						TrueQ[reverseTranscriptionSwitch],Model[Sample,"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer"],
						Total[countsPerChannel]>1,Model[Sample,"Bio-Rad ddPCR Multiplex Supermix"],
						True,Model[Sample,"Bio-Rad ddPCR Supermix for Probes (No dUTP)"]
					];

					(* Find the object reference with ID for the resolved MasterMix option *)
					masterMixModelObject=masterMixModelFinder[masterMix];
					modelMasterMixConcentrationFactor=Lookup[fetchPacketFromCache[masterMixModelObject,simulatedCache],ConcentratedBufferDilutionFactor];

					(* masterMixConcentrationFactor resolves to ConcentratedBufferDilutionFactor field in Model[Sample] for the resolved master mix unless preparedPlate is True *)
					masterMixConcentrationFactor=Which[
						MatchQ[Lookup[options,MasterMixConcentrationFactor],Except[Automatic]],Lookup[options,MasterMixConcentrationFactor],
						!resolvedPreparedPlate&&!NullQ[modelMasterMixConcentrationFactor],modelMasterMixConcentrationFactor,
						(* When calculating concentration factor from volume, make sure the volume is not 0 *)
						!resolvedPreparedPlate&&MatchQ[Lookup[options,MasterMixVolume],Except[Automatic|Null]],If[!EqualQ[Lookup[options,MasterMixVolume],0*Microliter],SafeRound[specifiedReactionVolume/Lookup[options,MasterMixVolume],1],Null],
						True,Null
					];

					(* Warn if masterMixConcentrationFactor was calculated using user-specified MasterMixVolume instead of MasterMixConcentrationFactor from master mix model *)
					masterMixConcentrationFactorNotInformedWarning=And[
						MatchQ[Lookup[options,MasterMixConcentrationFactor],Automatic],
						!resolvedPreparedPlate,
						MatchQ[masterMixConcentrationFactor,Except[Null]],
						NullQ[modelMasterMixConcentrationFactor]
					];

					(* masterMixVolume resolves to reactionVolume/masterMixConcentrationFactor *)
					masterMixVolume=Which[
						MatchQ[Lookup[options,MasterMixVolume],Except[Automatic]],Lookup[options,MasterMixVolume],
						MatchQ[Lookup[options,MasterMixVolume],Automatic]&&!resolvedPreparedPlate&&!NullQ[masterMixConcentrationFactor],SafeRound[specifiedReactionVolume/masterMixConcentrationFactor,10^-1 Microliter],
						True,Null
					];

					(* Warn if masterMixConcentrationFactor and masterMixVolume are informed, but have a mismatch in calculation *)
					masterMixQuantityMismatchWarning=And[
						AllTrue[{masterMixConcentrationFactor,masterMixVolume},(!NullQ[#])&],
						!MatchQ[masterMixVolume,RangeP[(specifiedReactionVolume/masterMixConcentrationFactor)*0.95,(specifiedReactionVolume/masterMixConcentrationFactor)*1.05]]
					];

					(* If PreparedPlate is True, the master mix quantity options are specified, or if PreparedPlate is False, the master mix quantity options are Null, collect an error *)
					masterMixMismatchOptionsError=!Or[
						!resolvedPreparedPlate&&AllTrue[{masterMixConcentrationFactor,masterMixVolume},(!NullQ[#])&],
						resolvedPreparedPlate&&NullQ[{masterMixConcentrationFactor,masterMixVolume}]
					];

					(*- RESOLVING DILUENT VOLUME -*)
					(* Sum up all the component volumes and replace any Null with 0 *)
					volumeWithoutDiluent=Total[
						Flatten[{
							sampleVolume,
							forwardPrimerVolume,
							reversePrimerVolume,
							probeVolume,
							referenceForwardPrimerVolume,
							referenceReversePrimerVolume,
							referenceProbeVolume,
							(* When RT buffer is used, 2x stock solution will be prepared with the addition of RT enzyme and DTT *)
							If[MatchQ[Download[masterMix,Object],ObjectP[reverseTranscriptionMasterMixModel]],
								(* Although RT buffer is 4x concentrated, the combined master mix (with enzyme and DTT) will have 2x concentration *)
								SafeRound[specifiedReactionVolume/2,10^-1 Microliter],
								(* For all other cases, use the resolved masterMixVolume *)
								masterMixVolume
							]
						}/.{Null->0}]
					];

					(* Resolve diluent volume *)
					diluentVolume=Which[
						(* Allow user-specified volume *)
						MatchQ[Lookup[options,DiluentVolume],Except[Automatic]],Lookup[options,DiluentVolume],
						(* If option is Automatic and PreparedPlate is False, calculate diluentVolume *)
						!resolvedPreparedPlate&&LessQ[volumeWithoutDiluent,specifiedReactionVolume],SafeRound[specifiedReactionVolume-volumeWithoutDiluent,10^-1 Microliter],
						(* Catch-all *)
						True,Null
					];

					(* Check that when PreparedPlate is True, DiluentVolume is Null or when DiluentVolume is not Null and it is not negative *)
					diluentVolumeOptionError=Or[
						MatchQ[diluentVolume,Except[Null]]&&LessQ[diluentVolume,0*Microliter],
						resolvedPreparedPlate&&!NullQ[diluentVolume]
					];

					(* totalVolume should be within 0.5 Microliter range of ReactionVolume *)
					(* be sensitive about errors about stock concentration *)
					totalVolumeError=If[!resolvedPreparedPlate,
						!MatchQ[(volumeWithoutDiluent+diluentVolume)/.{Null->0},RangeP[specifiedReactionVolume-(0.5*Microliter),specifiedReactionVolume+(0.5*Microliter)]],
						False
					];

					(*- RESOLVING ACTIVATION -*)
					(* Activation master switch is True by default *)
					activationSwitch=Lookup[options,Activation];

					(* ActivationTime resolves to 10 minute if activationSwitch is True, or Null otherwise *)
					activationTime=Which[
						MatchQ[Lookup[options,ActivationTime],Except[Automatic]],Lookup[options,ActivationTime],
						MatchQ[Lookup[options,ActivationTime],Automatic]&&activationSwitch,10 Minute,
						True,Null
					];

					(* ActivationTemperature resolves to 95 degrees Celsius if activationSwitch is True, or Null otherwise *)
					activationTemperature=Which[
						MatchQ[Lookup[options,ActivationTemperature],Except[Automatic]],Lookup[options,ActivationTemperature],
						MatchQ[Lookup[options,ActivationTemperature],Automatic]&&activationSwitch,95 Celsius,
						True,Null
					];

					(* ActivationRampRate resolves to 1.6 degrees Celsius per second if activationSwitch is True, or Null otherwise *)
					activationRampRate=Which[
						MatchQ[Lookup[options,ActivationRampRate],Except[Automatic]],Lookup[options,ActivationRampRate],
						MatchQ[Lookup[options,ActivationRampRate],Automatic]&&activationSwitch,1.6 (Celsius/Second),
						True,Null
					];

					(* Check that when activationSwitch is True, all the Activation options are specified, or when activationSwitch is False, all the Activation options are Null *)
					activationMismatchOptionsError=!Or[
						activationSwitch&&TimeQ[activationTime]&&TemperatureQ[activationTemperature]&&TemperatureRampRateQ[activationRampRate],
						!activationSwitch&&NullQ[{activationTime,activationTemperature,activationRampRate}]
					];

					(*- RESOLVING PRIMER ANNEALING & GRADIENT ANNEALING -*)
					(* PrimerAnnealing master switch is True by default *)
					primerAnnealingSwitch=Lookup[options,PrimerAnnealing];

					(* PrimerGradientAnnealing master switch is set to False by default *)
					primerGradientAnnealingSwitch=Lookup[options,PrimerGradientAnnealing];

					(* PrimerAnnealingTime resolves to 60 Second if primerAnnealingSwitch or primerGradientAnnealingSwitch is True, or Null otherwise *)
					primerAnnealingTime=Which[
						MatchQ[Lookup[options,PrimerAnnealingTime],Except[Automatic]],Lookup[options,PrimerAnnealingTime],
						MatchQ[Lookup[options,PrimerAnnealingTime],Automatic]&&(primerAnnealingSwitch||primerGradientAnnealingSwitch),60 Second,
						True,Null
					];

					(* PrimerAnnealingTemperature resolves to 60 degrees Celsius if primerAnnealingSwitch is True, or Null otherwise*)
					primerAnnealingTemperature=Which[
						MatchQ[Lookup[options,PrimerAnnealingTemperature],Except[Automatic]],Lookup[options,PrimerAnnealingTemperature],
						MatchQ[Lookup[options,PrimerAnnealingTemperature],Automatic]&&primerAnnealingSwitch,60 Celsius,
						True,Null
					];

					(* PrimerAnnealingRampRate resolves to 2.0 degrees Celsius per second if resolvedActivation is True, or Null otherwise*)
					primerAnnealingRampRate=Which[
						MatchQ[Lookup[options,PrimerAnnealingRampRate],Except[Automatic]],Lookup[options,PrimerAnnealingRampRate],
						MatchQ[Lookup[options,PrimerAnnealingRampRate],Automatic]&&primerAnnealingSwitch,2.0 (Celsius/Second),
						True,Null
					];

					(* PrimerGradientAnnealingMinTemperature resolves to 55 degrees Celsius if primerAnnealingSwitch is True, or Null otherwise*)
					primerGradientAnnealingMinTemperature=Which[
						MatchQ[Lookup[options,PrimerGradientAnnealingMinTemperature],Except[Automatic]],Lookup[options,PrimerGradientAnnealingMinTemperature],
						MatchQ[Lookup[options,PrimerGradientAnnealingMinTemperature],Automatic]&&primerGradientAnnealingSwitch,55 Celsius,
						True,Null
					];

					(* PrimerGradientAnnealingMaxTemperature resolves to 65 degrees Celsius if primerAnnealingSwitch is True, or Null otherwise*)
					primerGradientAnnealingMaxTemperature=Which[
						MatchQ[Lookup[options,PrimerGradientAnnealingMaxTemperature],Except[Automatic]],Lookup[options,PrimerGradientAnnealingMaxTemperature],
						MatchQ[Lookup[options,PrimerGradientAnnealingMaxTemperature],Automatic]&&primerGradientAnnealingSwitch,65 Celsius,
						True,Null
					];

					(* Check that when primerAnnealingSwitch is True, all the PrimerAnnealing options are specified, primerGradientAnnealingSwitch is False and PrimerGradientAnnealing options are Null, or when primerAnnealingSwitch is False, all the PrimerAnnealing options are Null *)

					primerAnnealingMismatchOptionsError=!Or[
						primerAnnealingSwitch&&TimeQ[primerAnnealingTime]&&TemperatureQ[primerAnnealingTemperature]&&TemperatureRampRateQ[primerAnnealingRampRate],
						!primerAnnealingSwitch&&primerGradientAnnealingSwitch&&TimeQ[primerAnnealingTime]&&NullQ[{primerAnnealingTemperature,primerAnnealingRampRate}],
						!primerAnnealingSwitch&&!primerGradientAnnealingSwitch&&NullQ[{primerAnnealingTemperature,primerAnnealingRampRate,primerAnnealingTime}]
					];

					(* Check that when primerGradientAnnealingSwitch is True, all the PrimerGradientAnnealing related options are specified or Automatic, primerAnnealingSwitch is False and PrimerAnnealing options are Null, or when primerGradientAnnealingSwitch is False, all the PrimerGradientAnnealing options are Null *)
					primerGradientAnnealingMismatchOptionsError=!Or[
						primerGradientAnnealingSwitch&&!primerAnnealingSwitch&&TimeQ[primerAnnealingTime]&&TemperatureQ[primerGradientAnnealingMinTemperature]&&TemperatureQ[primerGradientAnnealingMaxTemperature]&&MatchQ[Lookup[options,PrimerGradientAnnealingRow],Except[Null]],
						!primerGradientAnnealingSwitch&&NullQ[{primerGradientAnnealingMinTemperature,primerGradientAnnealingMaxTemperature}]&&MatchQ[Lookup[options,PrimerGradientAnnealingRow],Automatic|Null]
					];

					(*- RESOLVING EXTENSION -*)
					(* Extension master switch is False by default *)
					extensionSwitch=Lookup[options,Extension];

					(* ExtensionTime resolves to 60 Second if extensionSwitch is True, or Null otherwise *)
					extensionTime=Which[
						MatchQ[Lookup[options,ExtensionTime],Except[Automatic]],Lookup[options,ExtensionTime],
						MatchQ[Lookup[options,ExtensionTime],Automatic]&&extensionSwitch,60 Second,
						True,Null
					];

					(* ExtensionTemperature resolves to 60 degrees Celsius if extensionSwitch is True, or Null otherwise *)
					extensionTemperature=Which[
						MatchQ[Lookup[options,ExtensionTemperature],Except[Automatic]],Lookup[options,ExtensionTemperature],
						MatchQ[Lookup[options,ExtensionTemperature],Automatic]&&extensionSwitch,60 Celsius,
						True,Null
					];

					(* ExtensionRampRate resolves to 2.0 degrees Celsius per second if extensionSwitch is True, or Null otherwise *)
					extensionRampRate=Which[
						MatchQ[Lookup[options,ExtensionRampRate],Except[Automatic]],Lookup[options,ExtensionRampRate],
						MatchQ[Lookup[options,ExtensionRampRate],Automatic]&&extensionSwitch,2.0 (Celsius/Second),
						True,Null
					];

					(* Check that when extensionSwitch is True, all the Extension options are specified, or when extensionSwitch is False, all the Extension options are Null *)
					extensionMismatchOptionsError=!Or[
						extensionSwitch&&TimeQ[extensionTime]&&TemperatureQ[extensionTemperature]&&TemperatureRampRateQ[extensionRampRate],
						!extensionSwitch&&NullQ[{extensionTime,extensionTemperature,extensionRampRate}]
					];

					(*- RESOLVING POLYMERASE DEGRADATION -*)
					(* Polymerase degradation master switch is True by default *)
					polymeraseDegradationSwitch=Lookup[options,PolymeraseDegradation];

					(* PolymeraseDegradationTime resolves to 10 Minute if polymeraseDegradationSwitch is True, or Null otherwise *)
					polymeraseDegradationTime=Which[
						MatchQ[Lookup[options,PolymeraseDegradationTime],Except[Automatic]],Lookup[options,PolymeraseDegradationTime],
						MatchQ[Lookup[options,PolymeraseDegradationTime],Automatic]&&polymeraseDegradationSwitch,10 Minute,
						True,Null
					];

					(* PolymeraseDegradationTemperature resolves to 98 degrees Celsius if polymeraseDegradationSwitch is True, or Null otherwise *)
					polymeraseDegradationTemperature=Which[
						MatchQ[Lookup[options,PolymeraseDegradationTemperature],Except[Automatic]],Lookup[options,PolymeraseDegradationTemperature],
						MatchQ[Lookup[options,PolymeraseDegradationTemperature],Automatic]&&polymeraseDegradationSwitch,98 Celsius,
						True,Null
					];

					(* PolymeraseDegradationRampRate resolves to 2.5 degrees Celsius per second if polymeraseDegradationSwitch is True, or Null otherwise *)
					polymeraseDegradationRampRate=Which[
						MatchQ[Lookup[options,PolymeraseDegradationRampRate],Except[Automatic]],Lookup[options,PolymeraseDegradationRampRate],
						MatchQ[Lookup[options,PolymeraseDegradationRampRate],Automatic]&&polymeraseDegradationSwitch,2.5 (Celsius/Second),
						True,Null
					];

					(* Check that when polymeraseDegradationSwitch is True, all the PolymeraseDegradation options are specified, or when polymeraseDegradationSwitch is False, all the PolymeraseDegradation options are Null *)
					polymeraseDegradationMismatchOptionsError=!Or[
						polymeraseDegradationSwitch&&TimeQ[polymeraseDegradationTime]&&TemperatureQ[polymeraseDegradationTemperature]&&TemperatureRampRateQ[polymeraseDegradationRampRate],
						!polymeraseDegradationSwitch&&NullQ[{polymeraseDegradationTime,polymeraseDegradationTemperature,polymeraseDegradationRampRate}]
					];

					(* RESOLVE STORAGE CONDITIONS *)

					{
						specifiedForwardPrimerStorageCondition,
						specifiedReversePrimerStorageCondition,
						specifiedProbeStorageCondition,
						specifiedReferenceForwardPrimerStorageCondition,
						specifiedReferenceReversePrimerStorageCondition,
						specifiedReferenceProbeStorageCondition,
						specifiedMasterMixStorageCondition
					}=Lookup[
						options,
						{
							ForwardPrimerStorageCondition,
							ReversePrimerStorageCondition,
							ProbeStorageCondition,
							ReferenceForwardPrimerStorageCondition,
							ReferenceReversePrimerStorageCondition,
							ReferenceProbeStorageCondition,
							MasterMixStorageCondition
						}
					];

					(* Resolving probe storage condition - same condition for all probes going in a sample *)
					probeStorageCondition=Which[
						(* If the storage condition is Null, accept it *)
						NullQ[specifiedProbeStorageCondition],specifiedProbeStorageCondition,
						(*If the storage condition is specified and Probe is Null, flip the error switch*)
						!NullQ[specifiedProbeStorageCondition]&&NullQ[probePacket],probeStorageConditionError=True;specifiedProbeStorageCondition,
						(*If the storage condition is specified correctly, accept the value*)
						!NullQ[specifiedProbeStorageCondition]&&!NullQ[probePacket],specifiedProbeStorageCondition,
						True,Null
					];

					(* Resolving forward primer storage condition - same condition for all primers going in a sample *)
					forwardPrimerStorageCondition=Which[
						(* If the storage condition is Null, accept it *)
						NullQ[specifiedForwardPrimerStorageCondition],specifiedForwardPrimerStorageCondition,
						(*If the storage condition is specified and Forward Primer is Null collect an error*)
						!NullQ[specifiedForwardPrimerStorageCondition]&&NullQ[forwardPrimerPacket],forwardPrimerStorageConditionError=True;specifiedForwardPrimerStorageCondition,
						(*If TargetAssay is used (same primer/probe object) and probeStorageCondition is different from specified condition for forward primer, collect an error*)
						!NullQ[specifiedForwardPrimerStorageCondition]&&!premixedPrimerProbeError&&!NullQ[premixedPrimerProbe]&&MemberQ[premixedPrimerProbe,TargetAssay]&&!MatchQ[probeStorageCondition,specifiedForwardPrimerStorageCondition],forwardPrimerStorageConditionError=True;specifiedForwardPrimerStorageCondition,
						(*If the storage condition is specified correctly and this is not a TargetAssay, accept the value*)
						!NullQ[specifiedForwardPrimerStorageCondition],specifiedForwardPrimerStorageCondition,
						True,Null
					];

					(* Resolving reverse primer storage condition - same condition for all primers going in a sample *)
					reversePrimerStorageCondition=Which[
						(* If the storage condition is Null, accept it *)
						NullQ[specifiedReversePrimerStorageCondition],specifiedReversePrimerStorageCondition,
						(*If the storage condition is specified and Reverse Primer is Null collect an error*)
						!NullQ[specifiedReversePrimerStorageCondition]&&NullQ[reversePrimerPacket],reversePrimerStorageConditionError=True;specifiedReversePrimerStorageCondition,
						(*If TargetAssay is used (same primer/probe object) and probeStorageCondition is different from specified condition for reverse primer, collect an error*)
						!NullQ[specifiedReversePrimerStorageCondition]&&!premixedPrimerProbeError&&!NullQ[premixedPrimerProbe]&&MemberQ[premixedPrimerProbe,TargetAssay]&&!MatchQ[probeStorageCondition,specifiedReversePrimerStorageCondition],reversePrimerStorageConditionError=True;specifiedReversePrimerStorageCondition,
						(*If PrimerSet are used (same primer objects) and forwardPrimerStorageCondition is different from specified condition for reverse primer, collect an error*)
						!NullQ[specifiedReversePrimerStorageCondition]&&!premixedPrimerProbeError&&MemberQ[premixedPrimerProbe,PrimerSet]&&!MatchQ[forwardPrimerStorageCondition,specifiedReversePrimerStorageCondition],reversePrimerStorageConditionError=True;specifiedReversePrimerStorageCondition,
						(*If the storage condition is specified correctly in the index-matched form, accept the value*)
						!NullQ[specifiedReversePrimerStorageCondition],specifiedReversePrimerStorageCondition,
						True,Null
					];

					(* Resolving reference probe storage condition - same condition for all probes going in a sample *)
					referenceProbeStorageCondition=Which[
						(* If the storage condition is Null, accept it *)
						NullQ[specifiedReferenceProbeStorageCondition],specifiedReferenceProbeStorageCondition,
						(*If the storage condition is specified and ReferenceProbes is Null, flip the error switch*)
						!NullQ[specifiedReferenceProbeStorageCondition]&&NullQ[specifiedReferenceProbes],referenceProbeStorageConditionError=True;specifiedReferenceProbeStorageCondition,
						(*If the storage condition is specified correctly, accept the value*)
						!NullQ[specifiedReferenceProbeStorageCondition]&&!NullQ[specifiedReferenceProbes],specifiedReferenceProbeStorageCondition,
						True,Null
					];

					referenceForwardPrimerStorageCondition=Which[
						(* If the storage condition is Null, accept it *)
						NullQ[specifiedReferenceForwardPrimerStorageCondition],specifiedReferenceForwardPrimerStorageCondition,
						(*If the storage condition is specified and reference forward primer is Null collect an error*)
						!NullQ[specifiedReferenceForwardPrimerStorageCondition]&&NullQ[referenceForwardPrimers],referenceForwardPrimerStorageConditionError=True;specifiedReferenceForwardPrimerStorageCondition,
						(*If TargetAssay is used (same primer/probe object) and probeStorageCondition is different from specified condition for forward primer, collect an error*)
						!NullQ[specifiedReferenceForwardPrimerStorageCondition]&&!referencePremixedPrimerProbeError&&!NullQ[referencePremixedPrimerProbe]&&MemberQ[referencePremixedPrimerProbe,TargetAssay]&&!MatchQ[referenceProbeStorageCondition,specifiedReferenceForwardPrimerStorageCondition],referenceForwardPrimerStorageConditionError=True;specifiedReferenceForwardPrimerStorageCondition,
						(*If the storage condition is specified correctly and this is not a TargetAssay, accept the value*)
						!NullQ[specifiedReferenceForwardPrimerStorageCondition],specifiedReferenceForwardPrimerStorageCondition,
						True,Null
					];

					referenceReversePrimerStorageCondition=Which[
						(* If the storage condition is Null, accept it *)
						NullQ[specifiedReferenceReversePrimerStorageCondition],specifiedReferenceReversePrimerStorageCondition,
						(*If the storage condition is specified and ReferenceReverse Primer is Null collect an error*)
						!NullQ[specifiedReferenceReversePrimerStorageCondition]&&NullQ[referenceReversePrimers],referenceReversePrimerStorageConditionError=True;specifiedReferenceReversePrimerStorageCondition,
						(*If TargetAssay is used (same primer/probe object) and probeStorageCondition is different from specified condition for referenceReverse primer, collect an error*)
						!NullQ[specifiedReferenceReversePrimerStorageCondition]&&!referencePremixedPrimerProbeError&&!NullQ[referencePremixedPrimerProbe]&&MemberQ[referencePremixedPrimerProbe,TargetAssay]&&!MatchQ[referenceProbeStorageCondition,specifiedReferenceReversePrimerStorageCondition],referenceReversePrimerStorageConditionError=True;specifiedReferenceReversePrimerStorageCondition,
						(*If PrimerSet are used (same primer objects) and forwardPrimerStorageCondition is different from specified condition for referenceReverse primer, collect an error*)
						!NullQ[specifiedReferenceReversePrimerStorageCondition]&&!referencePremixedPrimerProbeError&&MemberQ[referencePremixedPrimerProbe,PrimerSet]&&!MatchQ[referenceForwardPrimerStorageCondition,specifiedReferenceReversePrimerStorageCondition],referenceReversePrimerStorageConditionError=True;specifiedReferenceReversePrimerStorageCondition,
						(*If the storage condition is specified correctly in the index-matched form, accept the value*)
						!NullQ[specifiedReferenceReversePrimerStorageCondition],specifiedReferenceReversePrimerStorageCondition,
						True,Null
					];

					masterMixStorageCondition=Which[
						(* If the storage condition is Null, accept it *)
						NullQ[specifiedMasterMixStorageCondition],specifiedMasterMixStorageCondition,
						(* If the storage condition is specified and PreparedPlate is True, collect an error *)
						!NullQ[specifiedMasterMixStorageCondition]&&resolvedPreparedPlate,masterMixStorageConditionError=True;specifiedMasterMixStorageCondition,
						(* If the storage condition is specified and PreparedPlate is False, accept the condition *)
						!NullQ[specifiedMasterMixStorageCondition]&&!resolvedPreparedPlate,specifiedMasterMixStorageCondition,
						True,Null
					];

					(*-- No multiplex feature-flag error checking --*)
					(* TEMPORARY UNTIL RAW DATA EXPORT IS AVAILABLE *)
					(*
					When feature flag is true, check how many probes are in the sample. If # probes>1, collect an error.
					 *)
					(* check the value of $ddPCRNoMultiplex (True/False) *)
					noMultiplexAvailableError=If[$ddPCRNoMultiplex,
						(* when multiplexing is not available, collect an error if the sample has more than 1 probe *)
						Total[countsPerChannel]>1,
						(* when multiplexing is available, no error to collect *)
						False
					];

					(* Gather MapThread results *)
					{
						(* Resolved option variables *)
						sampleVolume,
						serialDilutionCurve,
						dilutionMixVolume,
						dilutionNumberOfMixes,
						dilutionMixRate,

						probeFluorophore,
						probeExcitationWavelength,
						probeEmissionWavelength,
						referenceProbeFluorophore,
						referenceProbeExcitationWavelength,
						referenceProbeEmissionWavelength,

						amplitudeMultiplexing,

						premixedPrimerProbe,
						referencePremixedPrimerProbe,
						probeConcentration,
						probeVolume,
						referenceProbeConcentration,
						referenceProbeVolume,
						forwardPrimerConcentration,
						forwardPrimerVolume,
						reversePrimerConcentration,
						reversePrimerVolume,
						referenceForwardPrimerConcentration,
						referenceForwardPrimerVolume,
						referenceReversePrimerConcentration,
						referenceReversePrimerVolume,

						reverseTranscriptionSwitch,
						reverseTranscriptionTime,
						reverseTranscriptionTemperature,
						reverseTranscriptionRampRate,

						masterMix,
						masterMixConcentrationFactor,
						masterMixVolume,
						diluentVolume,

						activationSwitch,
						activationTime,
						activationTemperature,
						activationRampRate,

						primerAnnealingSwitch,
						primerAnnealingTime,
						primerAnnealingTemperature,
						primerAnnealingRampRate,

						primerGradientAnnealingSwitch,
						primerGradientAnnealingMinTemperature,
						primerGradientAnnealingMaxTemperature,

						extensionSwitch,
						extensionTime,
						extensionTemperature,
						extensionRampRate,

						polymeraseDegradationSwitch,
						polymeraseDegradationTime,
						polymeraseDegradationTemperature,
						polymeraseDegradationRampRate,

						forwardPrimerStorageCondition,
						reversePrimerStorageCondition,
						probeStorageCondition,
						referenceForwardPrimerStorageCondition,
						referenceReversePrimerStorageCondition,
						referenceProbeStorageCondition,
						masterMixStorageCondition,

						(* Error variables *)
						sampleDilutionMismatchError,
						sampleVolumeMismatchError,
						singleFluorophorePerProbeError,
						singleFluorophorePerReferenceProbeError,
						probeFluorophoreNullOptionsError,
						probeFluorophoreIncompatibleOptionsError,
						probeFluorophoreLengthMismatchError,
						referenceProbeFluorophoreNullOptionsError,
						referenceProbeFluorophoreIncompatibleOptionsError,
						referenceProbeFluorophoreLengthMismatchError,
						amplitudeMultiplexingError,
						primerProbeOptionsLengthError,
						referencePrimerProbeOptionsLengthError,
						premixedPrimerProbeError,
						referencePremixedPrimerProbeError,
						probeStockConcentrationError,
						referenceProbeStockConcentrationError,
						probeConcentrationVolumeMismatchOptionError,
						probeStockConcentrationTooLowError,
						referenceProbeConcentrationVolumeMismatchOptionError,
						referenceProbeStockConcentrationTooLowError,
						forwardPrimerStockConcentrationError,
						forwardPrimerConcentrationVolumeMismatchOptionError,
						forwardPrimerStockConcentrationTooLowError,
						reversePrimerStockConcentrationError,
						reversePrimerConcentrationVolumeMismatchOptionError,
						reversePrimerStockConcentrationTooLowError,
						referenceForwardPrimerStockConcentrationError,
						referenceForwardPrimerConcentrationVolumeMismatchOptionError,
						referenceForwardPrimerStockConcentrationTooLowError,
						referenceReversePrimerStockConcentrationError,
						referenceReversePrimerConcentrationVolumeMismatchOptionError,
						referenceReversePrimerStockConcentrationTooLowError,
						reverseTranscriptionMismatchOptionsError,
						masterMixMismatchOptionsError,
						diluentVolumeOptionError,
						totalVolumeError,
						activationMismatchOptionsError,
						primerAnnealingMismatchOptionsError,
						primerGradientAnnealingMismatchOptionsError,
						extensionMismatchOptionsError,
						polymeraseDegradationMismatchOptionsError,
						forwardPrimerStorageConditionError,
						reversePrimerStorageConditionError,
						probeStorageConditionError,
						referenceForwardPrimerStorageConditionError,
						referenceReversePrimerStorageConditionError,
						referenceProbeStorageConditionError,
						masterMixStorageConditionError,
						noMultiplexAvailableError,

						(* Warning variables *)
						tooManyTargetsMultiplexedWarning,
						probeStockConcentrationAccuracyWarning,
						referenceProbeStockConcentrationAccuracyWarning,
						forwardPrimerStockConcentrationAccuracyWarning,
						reversePrimerStockConcentrationAccuracyWarning,
						referenceForwardPrimerStockConcentrationAccuracyWarning,
						referenceReversePrimerStockConcentrationAccuracyWarning,
						masterMixConcentrationFactorNotInformedWarning,
						masterMixQuantityMismatchWarning
					}
					]
				],
			{samplePackets,primerPairPackets,probePackets,mapThreadFriendlyOptions}
			]
		];

	(* RESOLVING ACTIVE WELL *)
	(* Get the value of ActiveWell *)
	specifiedActiveWell=Lookup[roundedOptions,ActiveWell];

	(* Check the value of specified ActiveWell option to determine what will be used downstream while checking for other errors *)
	activeWellOptionLengthCheck=Which[
		(* When active well is Automatic, there will be no problem with auto-resolution *)
		MatchQ[specifiedActiveWell,Automatic],True,
		(* When prepared plate is true, length of non-automatic activewell must be same as input samples *)
		resolvedPreparedPlate,EqualQ[Length[specifiedActiveWell],Length[samplePackets]],
		(* When not a prepared plate, use replicates and dilutions options to make sure the length is correct *)
		True,Module[{numberOfDilutions,specifiedNumberOfReplicates,totalSamplesLength},
			(* Get the relevant option values *)
			specifiedNumberOfReplicates=Lookup[roundedOptions,NumberOfReplicates]/.{Null->1};

			(* Calculate the number of dilutions per sample *)
			numberOfDilutions=Map[
				Switch[#,
					{VolumeP,VolumeP,NumericP},Last[#]+1,
					{VolumeP,{NumericP,GreaterP[1,1]}},#[[2,2]]+1,
					{VolumeP,{NumericP..}},Length[Last[#]]+1,
					Null,1
				]&,
				resolvedSerialDilutionCurve
			];

			(* Calculate the total number of expansions *)
			totalSamplesLength=Total[numberOfDilutions*specifiedNumberOfReplicates];

			(* Check the lengths of ActiveWell vs sum of number of expansions list *)
			EqualQ[Length[specifiedActiveWell],totalSamplesLength]
		]
	];

	(* Check if we have an error with option length *)
	(* If there are any errors related to invalid inputs/options, collect the invalid inputs and options *)
	activeWellInvalidLengthOptions=If[!activeWellOptionLengthCheck,
		{ActiveWell},
		{}
	];

	(* If ActiveWell resolution is invalid and we are throwing messages,throw an error message.*)
	If[!activeWellOptionLengthCheck&&messages,
		Message[Error::ActiveWellOptionLengthMismatch]
	];

	(* If we are gathering tests, create a test for ActiveWell error. *)
	activeWellInvalidLengthTest=If[gatherTests,
		Test["When specifying ActiveWell option, the option length matches the length of all samples including dilutions and replicates]::",
			activeWellOptionLengthCheck,
			True
		],
		Nothing
	];

	(* Create well index list for sorting and checking things after this *)
	cartridgeWellIndices=Flatten[Table[row<>ToString[column],{column,12},{row,{"A","B","C","D","E","F","G","H"}}]];

	(* For PreparedPlate, determine how many plates and Well for each sample *)
	potentialActiveWells=If[resolvedPreparedPlate,
		Module[{plateObjectsList,sampleWellIndex,sampleInputIndex,samplesByContainer,reorganizedListToSortBySamplesIn,plateWellIndicesSortedBySamplesIn},
			(* Get a list of container objects from samples *)
			plateObjectsList=Lookup[Flatten[sampleContainerPackets],Object];
			(* Get a list of well assignments for each sample *)
			sampleWellIndex=Lookup[samplePackets,Well];
			(* Create an index list to keep track of sample input order *)
			sampleInputIndex=Table[n,{n,Length[samplePackets]}];
			(* Gather samples by container object *)
			samplesByContainer=GatherBy[Transpose[{plateObjectsList,sampleWellIndex,sampleInputIndex}],First];
			(* Reorganize the list to {sample input index, plate index, Well} *)
			reorganizedListToSortBySamplesIn=MapIndexed[
				Function[{singleContainer,containerIndex},
					{Last[#],First[containerIndex],Part[#,2]}&/@singleContainer
				],
				samplesByContainer
			];
			(* Lists sorted by sample input index *)
			plateWellIndicesSortedBySamplesIn=SortBy[#,First]&/@reorganizedListToSortBySamplesIn;
			(* If only 1 container, format it for single list of WellIndex; >1 conatiner, format it for {PlateIndex, WellIndex} *)
			If[MatchQ[Length[plateWellIndicesSortedBySamplesIn],1],
				plateWellIndicesSortedBySamplesIn[[1,All,3]],
				Flatten[plateWellIndicesSortedBySamplesIn[[All,All,2;;3]],1]
			]
		],
		(* when not a prepared plate *)
		Module[{numberOfDilutions,numberOfReplicates,allExpansionsCount,sampleInputIndex,resolvedThermocyclingConditions,expandedThermocyclingConditions,sampleThermoForSorting,samplesGroupedByThermocycling,groupsSortedForRT,groupsSizedForPlate,groupsSizedForPlateSortedBySampleIn,plateWellIndexAssignments,sortedPlateWellIndexAssignments,specifiedPrimerGradientAnnealingRow,specifiedPrimerGradientAnnealingRowsOnly},

			(* When sample is undergoing serial dilutions, options need to be expanded; ActiveWell must match the length of the expanded samples to account for the destination of each dilution *)
			numberOfDilutions=Map[
				Switch[#,
					{VolumeP,VolumeP,NumericP},Last[#]+1,
					{VolumeP,{NumericP,GreaterP[1,1]}},#[[2,2]]+1,
					{VolumeP,{NumericP..}},Length[Last[#]]+1,
					Null,1
				]&,
				resolvedSerialDilutionCurve
			];

			(* Get the number of replicates if specified *)
			numberOfReplicates=Lookup[roundedOptions,NumberOfReplicates]/.{Null->1};

			(* Total number of expansions per input sample *)
			allExpansionsCount=numberOfDilutions*numberOfReplicates;

			(* Create an index list to keep track of sample input order and take into account any sample dilutions requested *)
			sampleInputIndex=Table[n,{n,Total[allExpansionsCount]}];

			(* Create a mega list to combine all the thermocycling conditions *)
			resolvedThermocyclingConditions=Transpose[{
				resolvedReverseTranscription,
				resolvedReverseTranscriptionTime,
				resolvedReverseTranscriptionTemperature,
				resolvedReverseTranscriptionRampRate,
				resolvedActivation,
				resolvedActivationTime,
				resolvedActivationTemperature,
				resolvedActivationRampRate,
				Lookup[roundedOptions,DenaturationTime],
				Lookup[roundedOptions,DenaturationTemperature],
				Lookup[roundedOptions,DenaturationRampRate],
				resolvedPrimerAnnealing,
				resolvedPrimerAnnealingTime,
				resolvedPrimerAnnealingTemperature,
				resolvedPrimerAnnealingRampRate,
				resolvedPrimerGradientAnnealing,
				resolvedPrimerGradientAnnealingMinTemperature,
				resolvedPrimerGradientAnnealingMaxTemperature,
				resolvedExtension,
				resolvedExtensionTime,
				resolvedExtensionTemperature,
				resolvedExtensionRampRate,
				Lookup[roundedOptions,NumberOfCycles],
				resolvedPolymeraseDegradation,
				resolvedPolymeraseDegradationTime,
				resolvedPolymeraseDegradationTemperature,
				resolvedPolymeraseDegradationRampRate
			}];

			(* Since the same set of thermocycling conditions will be applied to all serially diluted samples, expand each set according to the number of dilutions *)
			expandedThermocyclingConditions=Join[
				MapThread[
					Function[{dilutionsForSample,thermocyclingForSample},
						ConstantArray[thermocyclingForSample,dilutionsForSample]
					],
					{
						allExpansionsCount,
						resolvedThermocyclingConditions
					}
				]
			];

			(* Append sample index so that it can be used to maintain order while gathering and sorting is done *)
			sampleThermoForSorting=Append[
				Transpose[
					(* The additional layer of listing from the use of ConstantArray needs to be flattened before other operations *)
					Flatten[expandedThermocyclingConditions,1]
				],
				sampleInputIndex
			];

			(* GatherBy same resolved thermocycling options *)
			samplesGroupedByThermocycling=GatherBy[
				Transpose[sampleThermoForSorting],
				Most
			];
			(* If ReverseTranscription master switch is True for any group, ReverseSortBy #[[1,1]] to get that group first *)
			groupsSortedForRT=If[AnyTrue[samplesGroupedByThermocycling,#[[1,1]]&],
				ReverseSortBy[samplesGroupedByThermocycling,#[[1,1]]&],
				samplesGroupedByThermocycling
			];
			(* If any group has >96 samples, they must be separated into more plates *)
			groupsSizedForPlate=Flatten[
				Partition[#,UpTo[96]]&/@groupsSortedForRT,
				1
			];
			(* For each plate, sort samples by their input index in case they are scrambled *)
			groupsSizedForPlateSortedBySampleIn=SortBy[#,Last]&/@groupsSizedForPlate;
			(* Get the specified primer gradient annealing rows if any *)
			specifiedPrimerGradientAnnealingRow=Lookup[roundedOptions,PrimerGradientAnnealingRow];
			(* If Row and Temperature are provided, collect only the Row information into a list *)
			specifiedPrimerGradientAnnealingRowsOnly=Map[
				Which[
					MatchQ[#,{_String,_Quantity}],#[[1]],
					MatchQ[#,_String],#,
					True,Null
				]&,
				specifiedPrimerGradientAnnealingRow
			];
			(* For each plate, create a new list with {sample index, PlateIndex, WellIndex} *)
			plateWellIndexAssignments=Flatten[MapThread[
				Function[{singleGroup,plateIndex},
					If[TrueQ[singleGroup[[1,16]]]&&AllTrue[Extract[specifiedPrimerGradientAnnealingRowsOnly,List/@singleGroup[[All,-1]]],MatchQ[#,Except[Automatic|Null]]&],
						Flatten[
							Module[{samplesWithAssignedRows,samplesGroupedByRow,samplesWithWellIndex},
								samplesWithAssignedRows=Map[
									{Last[#1],plateIndex,Extract[specifiedPrimerGradientAnnealingRowsOnly,Last[#1]]}&,
									singleGroup
								];
								samplesGroupedByRow=GatherBy[samplesWithAssignedRows,Last];
								samplesWithWellIndex=Map[
									Function[{singleRow},
										Module[{rowIndex},
											rowIndex=StringTake[singleRow[[1,3]],-1];
											MapIndexed[ReplacePart[#1,3->rowIndex<>ToString[First[#2]]]&,singleRow]
										]
									],
									samplesGroupedByRow
								]
							],
							1
						],
						(* Assign well index by order of sample in the group *)
						MapIndexed[{Last[#1],plateIndex,Extract[cartridgeWellIndices,#2]}&,singleGroup]
					]
				],
				{groupsSizedForPlateSortedBySampleIn,Range[Length[groupsSizedForPlateSortedBySampleIn]]}
			],1];
			(* Sort sample well assignment by sample input order in case the order was disrupted in the last step *)
			sortedPlateWellIndexAssignments=SortBy[plateWellIndexAssignments,First];

			(* If 1 group, format it as single list; >1 group, format it for {plate index, well index} *)
			If[MatchQ[Max[sortedPlateWellIndexAssignments[[All,2]]],1],
				sortedPlateWellIndexAssignments[[All,3]],
				sortedPlateWellIndexAssignments[[All,2;;3]]
			]
		]
	];

	resolvedActiveWell=Which[
		(* If user specifies ActiveWell for any sample, it will be assumed that all wells are designated; error check to verify *)
		MatchQ[specifiedActiveWell,Except[Automatic]]&&activeWellOptionLengthCheck,specifiedActiveWell,
		(* default to potentialActiveWells  *)
		True,potentialActiveWells
	];

	(* PreparedPlate ActiveWell assignment check - must make sure the well index matches potentialActiveWells and plate index is the same for samples in one plate *)
	activeWellPreparedPlateCheck=If[resolvedPreparedPlate,
		Module[{plateObjectsList,sampleWellIndex,sampleInputIndex,samplesByContainer,assignedActiveWells,assignedActiveWellsByPlate},
			(* Get a list of container objects from samples *)
			plateObjectsList=Lookup[Flatten[sampleContainerPackets],Object];
			(* Get a list of well assignments for each sample *)
			sampleWellIndex=Lookup[samplePackets,Well];
			(* Create an index list to keep track of sample input order *)
			sampleInputIndex=Range[Length[samplePackets]];
			(* Gather samples by container object *)
			samplesByContainer=GatherBy[Transpose[{plateObjectsList,sampleWellIndex,sampleInputIndex}],First];
			(* If resolvedActiveWell is a single list of well indices, add a plate index of 1 to match the {plate index, well index} format *)
			assignedActiveWells=If[MatchQ[resolvedActiveWell,{WellP..}],
				MapThread[{1,#1,#2}&,{resolvedActiveWell,sampleInputIndex}],
				MapThread[Append[#1,#2]&,{resolvedActiveWell,sampleInputIndex}]
			];
			(* Gather resolvedActiveWell by plate if there are more than one plates *)
			assignedActiveWellsByPlate=GatherBy[assignedActiveWells,First];
			(* Check that for each group, all assigned WellIndices match the well input WellIndices *)
			!ContainsOnly[samplesByContainer[[All,All,2;;3]],assignedActiveWellsByPlate[[All,All,2;;3]]]
		],
		False
	];

	(* If there are any errors related to invalid inputs/options, collect the invalid inputs and options *)
	activeWellPreparedPlateInvalidOptions=If[activeWellPreparedPlateCheck,
		{ActiveWell},
		{}
	];

	(* If ActiveWell resolution is invalid and we are throwing messages,throw an error message.*)
	If[activeWellPreparedPlateCheck&&messages,
		Message[Error::ActiveWellOverConstrained]
	];

	(* If we are gathering tests, create a test for ActiveWell error. *)
	activeWellPreparedPlateTest=If[gatherTests,
		Test["If PreparedPlate is used, ActiveWell matches Well field in input sample object::",
			!activeWellPreparedPlateCheck,
			True
		],
		Nothing
	];

	(* Throw an invalid option error if
		- any ActiveWell assignment is Automatic or if the format is a mixture of {WellP..} and {{PlateIndex,WellP}..}
		- the same ActiveWell index is assigned to more than 1 sample
	*)

	(* Check that all active well indices have the format {WellP..} or {{PlateIndex,WellP}..}; WellP has to match '<letter><number>' format *)
	activeWellInputFormatCheck=!Or[
		If[MatchQ[resolvedActiveWell,{WellP..}],AllTrue[resolvedActiveWell,MemberQ[Flatten[AllWells[]],#]&],False],
		If[MatchQ[resolvedActiveWell,{{GreaterP[0,1],WellP}..}],AllTrue[resolvedActiveWell[[All,2]],MemberQ[Flatten[AllWells[]],#]&],False]
	];

	(* Check if any of the active wells have identical indices *)
	activeWellUniqueCheck=GreaterQ[Max[Counts[resolvedActiveWell]],1];

	(* Check if any active well index exceeds 1-12 column or A-H row  *)

	(* If there are any errors related to invalid inputs/options, collect the invalid inputs and options *)
	activeWellInvalidOptions=If[activeWellInputFormatCheck||activeWellUniqueCheck,
		{ActiveWell},
		{}
	];

	(* If ActiveWell resolution is invalid and we are throwing messages,throw an error message.*)
	If[(activeWellInputFormatCheck||activeWellUniqueCheck)&&messages,
		Message[Error::InvalidActiveWells]
	];

	(* If we are gathering tests, create a test for ActiveWell error. *)
	activeWellTest=If[gatherTests,
		Test["ActiveWell is specified as {well index..} or {{plate index, well index}..} for all sample inputs, all indices are unique and fit 96-well format::",
			!activeWellInputFormatCheck&&!activeWellUniqueCheck,
			True
		],
		Nothing
	];

	(* Error-check droplet cartridge option *)
	(*
		When list of objects is given,
			it must have correct length
			it must not have repeated objects
			When PreparedPlate is True, list should match the plate objects
	*)

	(* Check if any of the active wells are resolved, check if there are 5 or less plates *)
	{
		cartridgeLengthError,
		repeatedCartridgeError,
		preparedPlateCartridgeMismatchError
	}=If[AllTrue[resolvedActiveWell,MatchQ[#,Except[Automatic]]&],
		Module[
			{
				specifiedDropletCartridge,
				numberOfPlatesRequired
			},

			(* Get the user-specified option *)
			specifiedDropletCartridge=Download[Lookup[roundedOptions,DropletCartridge],Object];

			(* Determine the number of plates needed *)
			numberOfPlatesRequired=If[!MatchQ[resolvedActiveWell,{WellP..}],
				Max[resolvedActiveWell[[All,1]]],
				1
			];

			If[MatchQ[specifiedDropletCartridge,{ObjectP[Object[Container,Plate,DropletCartridge]]..}],
				{
					(* Collect an error if length of objects doesn't match required number of plates *)
					!MatchQ[Length[specifiedDropletCartridge],numberOfPlatesRequired],
					(* Collect an error if there are duplicate objects are specified *)
					!MatchQ[Length[DeleteDuplicates[specifiedDropletCartridge]],Length[specifiedDropletCartridge]],
					(* When prepared plate is true, specified cartridge objects must match sample containers, otherwise collect an error *)
					If[resolvedPreparedPlate,!ContainsExactly[specifiedDropletCartridge,DeleteDuplicates[Flatten[sampleContainerPackets],Object]],False]
				},
				{False,False,False}
			]
		],
		{False,False,False}
	];

	(* DropletCartridge option length error *)
	(* If there are any errors related to invalid inputs, collect the invalid inputs and options *)
	cartridgeLengthInvalidOptions=If[cartridgeLengthError,
		{DropletCartridge},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[cartridgeLengthError&&messages,
		Message[Error::DigitalPCRDropletCartridgeLengthMismatch]
	];

	(* If we are gathering tests, create a test for prepared plate error. *)
	cartridgeLengthTest=If[gatherTests,
		Test["When DropletCartridge is specified as a list of objects, its length matches the required number of plates::",
			cartridgeLengthError,
			False
		],
		Nothing
	];

	(* DropletCartridge option repeated object error *)
	(* If there are any errors related to invalid inputs, collect the invalid inputs and options *)
	repeatedCartridgeInvalidOptions=If[repeatedCartridgeError,
		{DropletCartridge},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[repeatedCartridgeError&&messages,
		Message[Error::DigitalPCRDropletCartridgeRepeatedObjects]
	];

	(* If we are gathering tests, create a test for prepared plate error. *)
	repeatedCartridgeTest=If[gatherTests,
		Test["When DropletCartridge is specified as a list of objects, all objects are unique::",
			repeatedCartridgeError,
			False
		],
		Nothing
	];

	(* DropletCartridge option matches sample containers when PreparedPlate->True error *)
	(* If there are any errors related to invalid inputs, collect the invalid inputs and options *)
	preparedPlateCartridgeMismatchInvalidOptions=If[preparedPlateCartridgeMismatchError,
		{DropletCartridge},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[preparedPlateCartridgeMismatchError&&messages,
		Message[Error::DigitalPCRDropletCartridgeObjectMismatch]
	];

	(* If we are gathering tests, create a test for prepared plate error. *)
	preparedPlateCartridgeMismatchTest=If[gatherTests,
		Test["When PreparedPlate is True and DropletCartridge is specified as a list of objects, all objects must match SamplesIn containers::",
			preparedPlateCartridgeMismatchError,
			False
		],
		Nothing
	];

	(* If plate index exists, throw an error if the plate index exceeds 5 invalid option *)
	(* Check if any of the active wells are resolved, check if there are 5 or less plates *)
	tooManyPlatesCheck=If[AllTrue[resolvedActiveWell,MatchQ[#,Except[Automatic]]&]&&!MatchQ[resolvedActiveWell,{WellP..}],
		Max[resolvedActiveWell[[All,1]]]>5,
		False
	];

	(* If there are any errors related to invalid inputs/options, collect the invalid inputs and options *)
	tooManyPlatesInvalidOptions=If[tooManyPlatesCheck,
		{
			ReverseTranscription,
			ReverseTranscriptionTime,
			ReverseTranscriptionTemperature,
			ReverseTranscriptionRampRate,
			Activation,
			ActivationTime,
			ActivationTemperature,
			ActivationRampRate,
			DenaturationTime,
			DenaturationTemperature,
			DenaturationRampRate,
			PrimerAnnealing,
			PrimerAnnealingTime,
			PrimerAnnealingTemperature,
			PrimerAnnealingRampRate,
			PrimerGradientAnnealing,
			PrimerGradientAnnealingMinTemperature,
			PrimerGradientAnnealingMaxTemperature,
			Extension,
			ExtensionTime,
			ExtensionTemperature,
			ExtensionRampRate,
			NumberOfCycles,
			PolymeraseDegradation,
			PolymeraseDegradationTime,
			PolymeraseDegradationTemperature,
			PolymeraseDegradationRampRate
		},
		{}
	];

	(* If number of plates>5 and we are throwing messages, throw an error message.*)
	If[tooManyPlatesCheck&&messages,
		Message[Error::TooManyPlates]
	];

	(* If we are gathering tests, create a test for too many plates error. *)
	tooManyPlatesTest=If[gatherTests,
		Test["Number of plates resolves to 5 or less::",
			!tooManyPlatesCheck,
			True
		],
		Nothing
	];

	(* Same thermocycling options in each plate *)
	(* Check that all samples in a single plate have the same thermocycling options; Throw invalid options error if not *)
	thermocyclingOptionsMismatchCheck=If[AllTrue[resolvedActiveWell,MatchQ[#,Except[Automatic]]&],
		If[MatchQ[resolvedActiveWell,{WellP..}],
			(* For single plate, check that all resolved options are lists of constant values *)
			!AllTrue[
				{
					resolvedReverseTranscription,
					resolvedReverseTranscriptionTime,
					resolvedReverseTranscriptionTemperature,
					resolvedReverseTranscriptionRampRate,
					resolvedActivation,
					resolvedActivationTime,
					resolvedActivationTemperature,
					resolvedActivationRampRate,
					Lookup[roundedOptions,DenaturationTime],
					Lookup[roundedOptions,DenaturationTemperature],
					Lookup[roundedOptions,DenaturationRampRate],
					resolvedPrimerAnnealing,
					resolvedPrimerAnnealingTime,
					resolvedPrimerAnnealingTemperature,
					resolvedPrimerAnnealingRampRate,
					resolvedPrimerGradientAnnealing,
					resolvedPrimerGradientAnnealingMinTemperature,
					resolvedPrimerGradientAnnealingMaxTemperature,
					resolvedExtension,
					resolvedExtensionTime,
					resolvedExtensionTemperature,
					resolvedExtensionRampRate,
					Lookup[roundedOptions,NumberOfCycles],
					resolvedPolymeraseDegradation,
					resolvedPolymeraseDegradationTime,
					resolvedPolymeraseDegradationTemperature,
					resolvedPolymeraseDegradationRampRate
				},
				(SameQ@@#)&
			],
			(* For multiple plates, gather all samples on a single plate and then check if thermocycling values are the same *)
			Module[{thermocyclingOptionWithPlateIndex,thermocyclingOptionGroupByPlate,thermocyclingOptionGroupByOption},
				thermocyclingOptionWithPlateIndex=Transpose[{
					resolvedReverseTranscription,
					resolvedReverseTranscriptionTime,
					resolvedReverseTranscriptionTemperature,
					resolvedReverseTranscriptionRampRate,
					resolvedActivation,
					resolvedActivationTime,
					resolvedActivationTemperature,
					resolvedActivationRampRate,
					Lookup[roundedOptions,DenaturationTime],
					Lookup[roundedOptions,DenaturationTemperature],
					Lookup[roundedOptions,DenaturationRampRate],
					resolvedPrimerAnnealing,
					resolvedPrimerAnnealingTime,
					resolvedPrimerAnnealingTemperature,
					resolvedPrimerAnnealingRampRate,
					resolvedPrimerGradientAnnealing,
					resolvedPrimerGradientAnnealingMinTemperature,
					resolvedPrimerGradientAnnealingMaxTemperature,
					resolvedExtension,
					resolvedExtensionTime,
					resolvedExtensionTemperature,
					resolvedExtensionRampRate,
					Lookup[roundedOptions,NumberOfCycles],
					resolvedPolymeraseDegradation,
					resolvedPolymeraseDegradationTime,
					resolvedPolymeraseDegradationTemperature,
					resolvedPolymeraseDegradationRampRate,
					resolvedActiveWell[[All,1]]
				}];
				thermocyclingOptionGroupByPlate=GatherBy[thermocyclingOptionWithPlateIndex,Last];
				thermocyclingOptionGroupByOption=Transpose[#]&/@thermocyclingOptionGroupByPlate;
				!AllTrue[
					Map[
						Function[{singleGroup},AllTrue[Most[singleGroup],(SameQ@@#)&]],
						thermocyclingOptionGroupByOption
					],
					TrueQ
				]
			]
		],
		False
	];

	(* If there are any errors related to invalid options, collect the invalid inputs and options *)
	thermocyclingOptionsMismatchInvalidOptions=If[thermocyclingOptionsMismatchCheck,
		{
			ActiveWell,
			ReverseTranscription,
			ReverseTranscriptionTime,
			ReverseTranscriptionTemperature,
			ReverseTranscriptionRampRate,
			Activation,
			ActivationTime,
			ActivationTemperature,
			ActivationRampRate,
			DenaturationTime,
			DenaturationTemperature,
			DenaturationRampRate,
			PrimerAnnealing,
			PrimerAnnealingTime,
			PrimerAnnealingTemperature,
			PrimerAnnealingRampRate,
			PrimerGradientAnnealing,
			PrimerGradientAnnealingMinTemperature,
			PrimerGradientAnnealingMaxTemperature,
			Extension,
			ExtensionTime,
			ExtensionTemperature,
			ExtensionRampRate,
			NumberOfCycles,
			PolymeraseDegradation,
			PolymeraseDegradationTime,
			PolymeraseDegradationTemperature,
			PolymeraseDegradationRampRate
		},
		{}
	];

	(* If all thermocycling options are not matching in a plate and we are throwing messages, throw an error message.*)
	If[thermocyclingOptionsMismatchCheck&&messages,
		Message[Error::ThermocyclingOptionsMismatchInPlate]
	];

	(* If we are gathering tests, create a test for too many plates error. *)
	thermocyclingOptionsMismatchTest=If[gatherTests,
		Test["Each plate has matching thermocycling options::",
			!thermocyclingOptionsMismatchCheck,
			True
		],
		Nothing
	];

	(* RESOLVING GRADIENT ANNEALING ROW *)
	primerGradientAnnealingRowWithChecks=MapThread[
		Function[{primerGradientAnnealingSwitch,primerGradientAnnealingMinTemperature,primerGradientAnnealingMaxTemperature,specifiedPrimerGradientAnnealingRow,sampleIndex},
			Which[
				(* If user specifies Null, accept it *)
				MatchQ[specifiedPrimerGradientAnnealingRow,Null],specifiedPrimerGradientAnnealingRow,
				(* If user specifies Row only, determine the Temperature; If user specifies {Row,Temperature}, check Temperature is correct or throw error *)
				MatchQ[specifiedPrimerGradientAnnealingRow,Alternatives[_String,{_String,_Quantity}]],
				Module[{temperatureGradient,rowIndexFromUser,activeWellIndex,rowTemperature,specifiedTemperatureCheck,overConstrainedRowCheck,initialGradientAnnealingRowResolution},
					(* Find the user specified row of the current element *)
					rowIndexFromUser=If[MatchQ[specifiedPrimerGradientAnnealingRow,_String],
						specifiedPrimerGradientAnnealingRow,
						specifiedPrimerGradientAnnealingRow[[1]]
					];
					(* Get the resolvedActiveWell to error check if the user over-constrained the row options *)
					activeWellIndex=If[MatchQ[Extract[resolvedActiveWell,{sampleIndex}],WellP],
						Extract[resolvedActiveWell,{sampleIndex}],
						Last[Extract[resolvedActiveWell,{sampleIndex}]]
					];
					(* If user specified ActiveWell and GradientAnnealingRow, check if the rows match; collect an error if output False *)
					overConstrainedRowCheck=MatchQ[StringPart[rowIndexFromUser,-1],StringPart[activeWellIndex,1]];
					(* Calculate temperature for each row using the Min/Max values resolved *)
					temperatureGradient=SafeRound[Range[primerGradientAnnealingMinTemperature,primerGradientAnnealingMaxTemperature,(primerGradientAnnealingMaxTemperature-primerGradientAnnealingMinTemperature)/7],0.1*Celsius];
					(* Find the temperature of at the row identified in the previous step *)
					rowTemperature=Extract[temperatureGradient,Position[{"Row A","Row B","Row C","Row D","Row E","Row F","Row G","Row H"},rowIndexFromUser]];
					(* Incorrect user specified temperature check; collect an error if output False *)
					specifiedTemperatureCheck=If[MatchQ[specifiedPrimerGradientAnnealingRow,{_String,_Quantity}],
						MatchQ[specifiedPrimerGradientAnnealingRow[[2]],rowTemperature],
						True
					];
					(* Create an output using any user-supplied values *)
					initialGradientAnnealingRowResolution=If[MatchQ[specifiedPrimerGradientAnnealingRow,_String],
						Flatten[{rowIndexFromUser,rowTemperature}],
						specifiedPrimerGradientAnnealingRow
					];
					(*
						-If both temperature and row are informed and have errors, output them with "both" appended
						-If only row is over constrained (mismatch in specified ActiveWell and gradient annealing row options), output with "row" appended
						-If temperature is a part of the input and has an error, output with "temperature" appended
						-For no errors, return the output as usual
					*)
					Which[
						(MatchQ[specifiedPrimerGradientAnnealingRow,{_String,_Quantity}]||MatchQ[specifiedPrimerGradientAnnealingRow,_String])&&!specifiedTemperatureCheck&&!overConstrainedRowCheck,Append[initialGradientAnnealingRowResolution,"both"],
						(MatchQ[specifiedPrimerGradientAnnealingRow,{_String,_Quantity}]||MatchQ[specifiedPrimerGradientAnnealingRow,_String])&&!overConstrainedRowCheck,Append[initialGradientAnnealingRowResolution,"row"],
						(MatchQ[specifiedPrimerGradientAnnealingRow,{_String,_Quantity}]||MatchQ[specifiedPrimerGradientAnnealingRow,_String])&&!specifiedTemperatureCheck,Append[initialGradientAnnealingRowResolution,"temperature"],
						True,initialGradientAnnealingRowResolution
					]
				],
				(* If gradient annealing is not specified, but is conducted, derive the sample row (and respective temperature) from assigned active well indices *)
				MatchQ[specifiedPrimerGradientAnnealingRow,Automatic]&&primerGradientAnnealingSwitch&&!(activeWellInputFormatCheck||activeWellUniqueCheck),
				Module[{activeWellIndex,rowIndex,temperatureGradient,rowTemperature},
					activeWellIndex=If[MatchQ[Extract[resolvedActiveWell,{sampleIndex}],WellP],Extract[resolvedActiveWell,{sampleIndex}],Last[Extract[resolvedActiveWell,{sampleIndex}]]];
					rowIndex=StringReplace[activeWellIndex,{("A"~~__)->"Row A",("B"~~__)->"Row B",("C"~~__)->"Row C",("D"~~__)->"Row D",("E"~~__)->"Row E",("F"~~__)->"Row F",("G"~~__)->"Row G",("H"~~__)->"Row H"}];
					temperatureGradient=SafeRound[Range[primerGradientAnnealingMinTemperature,primerGradientAnnealingMaxTemperature,(primerGradientAnnealingMaxTemperature-primerGradientAnnealingMinTemperature)/7],0.1*Celsius];
					rowTemperature=Extract[temperatureGradient,Position[{"Row A","Row B","Row C","Row D","Row E","Row F","Row G","Row H"},rowIndex]];
					Flatten[{rowIndex,rowTemperature}]
				],
				True,Null
			]
		],
		{resolvedPrimerGradientAnnealing,resolvedPrimerGradientAnnealingMinTemperature,resolvedPrimerGradientAnnealingMaxTemperature,Lookup[roundedOptions,PrimerGradientAnnealingRow],Range[Length[samplePackets]]}
	];

	(* Check if there were any row/temperature mismatch errors from user-specified {row,temperature inputs} *)
	primerGradientAnnealingRowTemperatureMismatchErrors=Map[
		If[NullQ[#],
			False,
			If[MatchQ[Length[#],3],MatchQ[#[[3]],Alternatives["temperature","both"]],False]
		]&,
		primerGradientAnnealingRowWithChecks
	];

	(* Check if there were any row is over-contrainted by the user supplying ActiveWell with a different row than for gradient annealing *)
	overConstrainedRowOptionsErrors=Map[
		If[NullQ[#],
			False,
			If[MatchQ[Length[#],3],MatchQ[#[[3]],Alternatives["row","both"]],False]
		]&,
		primerGradientAnnealingRowWithChecks
	];

	resolvedPrimerGradientAnnealingRow=Map[
		If[NullQ[#],
			#,
			If[MatchQ[Length[#],3],#[[1;;2]],#]
		]&,
		primerGradientAnnealingRowWithChecks
	];

	(* Error check PrimerGradientAnnealingRow, update primerGradientAnnealingMismatchOptionsErrors and use the mismatch option error message downstream *)
	(* Check if any of the active wells resolved to Automatic *)
	primerGradientAnnealingMismatchOptionsErrors=MapThread[
		Function[{primerGradientAnnealing,primerGradientAnnealingRow,primerGradientAnnealingError},
			If[!primerGradientAnnealingError,
				(* If no errors exist, check that when master switch is ON, row is not Null and vice versa *)
				Or[
					primerGradientAnnealing&&NullQ[primerGradientAnnealingRow],
					!primerGradientAnnealing&&!NullQ[primerGradientAnnealingRow]
				],
				(* If a mismatch error already exists, return it *)
				primerGradientAnnealingError
			]
		],
		{resolvedPrimerGradientAnnealing,resolvedPrimerGradientAnnealingRow,initialPrimerGradientAnnealingMismatchOptionsErrors}
	];

	(* RESOLVING PASSIVE WELLS *)
	potentialPassiveWells=If[(!activeWellInputFormatCheck)&&(!activeWellUniqueCheck),
		Module[
			{activeWellsWithPlateIndex,activeWellsWithPlateIndexPerPlate,activeWellsPerPlate,passiveWellsPerPlate},
			(* Convert single list of resolvedActiveWell to a structured list with plate index as 1 so the format matches multi-plate resolution *)
			activeWellsWithPlateIndex=If[MatchQ[resolvedActiveWell,{WellP..}],
				{1,#}&/@resolvedActiveWell,
				resolvedActiveWell
			];
			(* Gather wells by plate index *)
			activeWellsWithPlateIndexPerPlate=GatherBy[activeWellsWithPlateIndex,First];
			(* Remove plate index *)
			activeWellsPerPlate=#[[All,2]]&/@activeWellsWithPlateIndexPerPlate;
			(* Find passive well indices for each plate *)
			passiveWellsPerPlate=Map[
				Function[{activeWellsInSinglePlate},
					Module[
						{passiveOrEmptyWells},
						(*
							Partition all possible wells into 16 unit groups and delete all wells that are ActiveWells;
							In the future, figure out processing blocks automatically from instrument field?
						*)
						passiveOrEmptyWells=DeleteCases[Partition[cartridgeWellIndices,16],Alternatives@@activeWellsInSinglePlate,{2}];
						(* Among the empty wells, delete any 16-unit group that is fully empty; we only need buffer if an ActiveWell is in a block and there are empty wells *)
						Flatten[DeleteCases[passiveOrEmptyWells,_?(MatchQ[Length[#],16]&)]]
					]
				],
				activeWellsPerPlate
			];
			(* Format the output as a single list with only WellIndex if 1 plate is used or {PlateIndex,WellIndex} if multiple plates are used *)
			If[MatchQ[resolvedActiveWell,{WellP..}],
				Flatten[passiveWellsPerPlate],
				Flatten[
					MapIndexed[
						Function[{passiveWellsInSinglePlate,plateIndex},{First[plateIndex], #}&/@passiveWellsInSinglePlate],
						passiveWellsPerPlate
					],
					1
				]
			]/.{{}->None}
		],
		None
	];

	resolvedPassiveWells=Which[
		(* If user specifies PassiveWells use it and error check to verify *)
		MatchQ[Lookup[roundedOptions,PassiveWells],Except[Automatic]],Lookup[roundedOptions,PassiveWells],
		(* If PassiveWells is Automatic, use plate/well assignments from potentialPassiveWells  *)
		MatchQ[Lookup[roundedOptions,PassiveWells],Automatic],potentialPassiveWells,
		(* Catch-all *)
		True,None
	];

	(* If resolvedPassiveWells does not match potentialPassiveWells, throw an error; be sensitive if user only has 1 plate but still adds an index *)
	(* Check that resolvedPassiveWells match potentialPassiveWells *)
	passiveWellsAssignmentCheck=If[((!activeWellInputFormatCheck)&&(!activeWellUniqueCheck)),
		Module[{passiveWellsWithPlateIndex,potentialPassiveWellsWithPlateIndex},
			(* Reformat both lists to {plate index, well index}; If either list is None when no passive wells are needed, convert None to {} for comparison with ContainsExactly *)
			passiveWellsWithPlateIndex=If[MatchQ[resolvedPassiveWells,{WellP..}],{1,#}&/@resolvedPassiveWells,resolvedPassiveWells]/.{None->{}};
			potentialPassiveWellsWithPlateIndex=If[MatchQ[potentialPassiveWells,{WellP..}],{1,#}&/@potentialPassiveWells,potentialPassiveWells]/.{None->{}};
			(* If the contents of both lists are not the same, this resolves to True and an error is thrown *)
			!ContainsExactly[potentialPassiveWellsWithPlateIndex,passiveWellsWithPlateIndex]
		],
		False
	];

	(* If there are any errors related to invalid options, collect the invalid inputs and options *)
	passiveWellsAssignmentInvalidOptions=If[passiveWellsAssignmentCheck,
		{PassiveWells},
		{}
	];

	(* If all thermocycling options are not matching in a plate and we are throwing messages, throw an error message.*)
	If[passiveWellsAssignmentCheck&&messages,
		Message[Error::PassiveWellsAssignment]
	];

	(* If we are gathering tests, create a test for too many plates error. *)
	passiveWellsAssignmentCheckTest=If[gatherTests,
		Test["PassiveWells are assigned correctly::",
			!passiveWellsAssignmentCheck,
			True
		],
		Nothing
	];

	(*-- INVALID INPUTS --*)

	(*- PROBE INVALID COMPOSITION -*)
	(* If there are any errors related to specific inputs, collect the invalid input *)
	singleFluorophorePerProbeInvalidInputs=If[MemberQ[singleFluorophorePerProbeErrors,True],
		PickList[simulatedSamples,singleFluorophorePerProbeErrors],
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[singleFluorophorePerProbeErrors,True]&&messages,
		Message[Error::DigitalPCRSingleFluorophorePerProbe,ObjectToString[singleFluorophorePerProbeInvalidInputs,Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	singleFluorophorePerProbeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[singleFluorophorePerProbeErrors,True],
				Test["For samples "<>ObjectToString[singleFluorophorePerProbeInvalidInputs,Simulation->updatedSimulation]<>", each probe input object has 1 fluorescent oligomer in Composition::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[amplitudeMultiplexingErrors,False],
				Test["For samples "<>ObjectToString[Complement[simulatedSamples,singleFluorophorePerProbeInvalidInputs],Simulation->updatedSimulation]<>", each probe input object has 1 fluorescent oligomer in Composition::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(*- NO MULTIPLEXING AVAILABLE ERROR -*)
	(* If there are any errors related to specific inputs, collect the invalid input *)
	noMultiplexAvailableInvalidInputs=If[MemberQ[noMultiplexAvailableErrors,True],
		PickList[simulatedSamples,noMultiplexAvailableErrors],
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[noMultiplexAvailableErrors,True]&&messages,
		Message[Error::DigitalPCRMultiplexingNotAvailable,ObjectToString[noMultiplexAvailableInvalidInputs,Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	noMultiplexAvailableTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[noMultiplexAvailableErrors,True],
				Test["For samples "<>ObjectToString[noMultiplexAvailableInvalidInputs,Simulation->updatedSimulation]<>", multiple probes are not be used when multiplexing capabilities are not available::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[noMultiplexAvailableErrors,False],
				Test["For samples "<>ObjectToString[Complement[simulatedSamples,noMultiplexAvailableInvalidInputs],Simulation->updatedSimulation]<>", multiple probes are not be used when multiplexing capabilities are not available::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(*-- WARNINGS --*)
	(* If we have any warnings, we are throwing messages and we are not in Engine, throw an warning message listing the affected objects.*)
	If[MemberQ[tooManyTargetsMultiplexedWarnings,True]&&messages&&notInEngine,
		Message[Warning::DigitalPCRMultiplexedTargetQuantity,ObjectToString[PickList[simulatedSamples,tooManyTargetsMultiplexedWarnings],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooManyTargetsMultiplexedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[tooManyTargetsMultiplexedWarnings,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,tooManyTargetsMultiplexedWarnings],Simulation->updatedSimulation]<>", multiplexing more than 2 targets in a channel may yield poor separation of droplet populations::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[tooManyTargetsMultiplexedWarnings,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,tooManyTargetsMultiplexedWarnings,False],Simulation->updatedSimulation]<>", multiplexing more than 2 targets in a channel may yield poor separation of droplet populations::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* If we have any warnings, we are throwing messages and we are not in Engine, throw an warning message listing the affected objects.*)
	If[MemberQ[probeStockConcentrationAccuracyWarnings,True]&&messages&&notInEngine,
		Message[Warning::DigitalPCRProbeStockConcentrationAccuracy,ObjectToString[PickList[simulatedSamples,probeStockConcentrationAccuracyWarnings],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	probeStockConcentrationAccuracyTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[probeStockConcentrationAccuracyWarnings,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeStockConcentrationAccuracyWarnings],Simulation->updatedSimulation]<>", if ProbeConcentration or ProbeVolume is Automatic and concentration of oligomer is provided as mass concentration, calculation of molar concentration depends on the accuracy of MolecularWeight of the oligomer::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[probeStockConcentrationAccuracyWarnings,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeStockConcentrationAccuracyWarnings,False],Simulation->updatedSimulation]<>", if ProbeConcentration or ProbeVolume is Automatic and concentration of oligomer is provided as mass concentration, calculation of molar concentration depends on the accuracy of MolecularWeight of the oligomer::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* If we have any warnings, we are throwing messages and we are not in Engine, throw an warning message listing the affected objects.*)
	If[MemberQ[referenceProbeStockConcentrationAccuracyWarnings,True]&&messages&&notInEngine,
		Message[Warning::DigitalPCRReferenceProbeStockConcentrationAccuracy,ObjectToString[PickList[simulatedSamples,referenceProbeStockConcentrationAccuracyWarnings],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	referenceProbeStockConcentrationAccuracyTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceProbeStockConcentrationAccuracyWarnings,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceProbeStockConcentrationAccuracyWarnings],Simulation->updatedSimulation]<>", if ProbeConcentration or ProbeVolume is Automatic and concentration of oligomer is provided as mass concentration, calculation of molar concentration depends on the accuracy of MolecularWeight of the oligomer::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referenceProbeStockConcentrationAccuracyWarnings,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceProbeStockConcentrationAccuracyWarnings,False],Simulation->updatedSimulation]<>", if ProbeConcentration or ProbeVolume is Automatic and concentration of oligomer is provided as mass concentration, calculation of molar concentration depends on the accuracy of MolecularWeight of the oligomer::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* If we have any warnings, we are throwing messages and we are not in Engine, throw an warning message listing the affected objects.*)
	If[MemberQ[forwardPrimerStockConcentrationAccuracyWarnings,True]&&messages&&notInEngine,
		Message[Warning::DigitalPCRForwardPrimerStockConcentrationAccuracy,ObjectToString[PickList[simulatedSamples,forwardPrimerStockConcentrationAccuracyWarnings],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	forwardPrimerStockConcentrationAccuracyTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[forwardPrimerStockConcentrationAccuracyWarnings,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,forwardPrimerStockConcentrationAccuracyWarnings],Simulation->updatedSimulation]<>", if ForwardPrimerConcentration or ForwardPrimerVolume is Automatic and concentration of oligomer is provided as mass concentration, calculation of molar concentration depends on the accuracy of MolecularWeight of the oligomer::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[forwardPrimerStockConcentrationAccuracyWarnings,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,forwardPrimerStockConcentrationAccuracyWarnings,False],Simulation->updatedSimulation]<>", if ForwardPrimerConcentration or ForwardPrimerVolume is Automatic and concentration of oligomer is provided as mass concentration, calculation of molar concentration depends on the accuracy of MolecularWeight of the oligomer::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* If we have any warnings, we are throwing messages and we are not in Engine, throw an warning message listing the affected objects.*)
	If[MemberQ[reversePrimerStockConcentrationAccuracyWarnings,True]&&messages&&notInEngine,
		Message[Warning::DigitalPCRReversePrimerStockConcentrationAccuracy,ObjectToString[PickList[simulatedSamples,reversePrimerStockConcentrationAccuracyWarnings],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	reversePrimerStockConcentrationAccuracyTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[reversePrimerStockConcentrationAccuracyWarnings,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,reversePrimerStockConcentrationAccuracyWarnings],Simulation->updatedSimulation]<>", if ReversePrimerConcentration or ReversePrimerVolume is Automatic and concentration of oligomer is provided as mass concentration, calculation of molar concentration depends on the accuracy of MolecularWeight of the oligomer::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[reversePrimerStockConcentrationAccuracyWarnings,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,reversePrimerStockConcentrationAccuracyWarnings,False],Simulation->updatedSimulation]<>", if ReversePrimerConcentration or ReversePrimerVolume is Automatic and concentration of oligomer is provided as mass concentration, calculation of molar concentration depends on the accuracy of MolecularWeight of the oligomer::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* If we have any warnings, we are throwing messages and we are not in Engine, throw an warning message listing the affected objects.*)
	If[MemberQ[referenceForwardPrimerStockConcentrationAccuracyWarnings,True]&&messages&&notInEngine,
		Message[Warning::DigitalPCRReferenceForwardPrimerStockConcentrationAccuracy,ObjectToString[PickList[simulatedSamples,referenceForwardPrimerStockConcentrationAccuracyWarnings],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	referenceForwardPrimerStockConcentrationAccuracyTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceForwardPrimerStockConcentrationAccuracyWarnings,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceForwardPrimerStockConcentrationAccuracyWarnings],Simulation->updatedSimulation]<>", if ReferenceForwardPrimerConcentration or ReferenceForwardPrimerVolume is Automatic and concentration of oligomer is provided as mass concentration, calculation of molar concentration depends on the accuracy of MolecularWeight of the oligomer::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referenceForwardPrimerStockConcentrationAccuracyWarnings,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceForwardPrimerStockConcentrationAccuracyWarnings,False],Simulation->updatedSimulation]<>", if ReferenceForwardPrimerConcentration or ReferenceForwardPrimerVolume is Automatic and concentration of oligomer is provided as mass concentration, calculation of molar concentration depends on the accuracy of MolecularWeight of the oligomer::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* If we have any warnings, we are throwing messages and we are not in Engine, throw an warning message listing the affected objects.*)
	If[MemberQ[referenceReversePrimerStockConcentrationAccuracyWarnings,True]&&messages&&notInEngine,
		Message[Warning::DigitalPCRReferenceReversePrimerStockConcentrationAccuracy,ObjectToString[PickList[simulatedSamples,referenceReversePrimerStockConcentrationAccuracyWarnings],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	referenceReversePrimerStockConcentrationAccuracyTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceReversePrimerStockConcentrationAccuracyWarnings,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceReversePrimerStockConcentrationAccuracyWarnings],Simulation->updatedSimulation]<>", if ReferenceReversePrimerConcentration or ReferenceReversePrimerVolume is Automatic and concentration of oligomer is provided as mass concentration, calculation of molar concentration depends on the accuracy of MolecularWeight of the oligomer::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referenceReversePrimerStockConcentrationAccuracyWarnings,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceReversePrimerStockConcentrationAccuracyWarnings,False],Simulation->updatedSimulation]<>", if ReferenceReversePrimerConcentration or ReferenceReversePrimerVolume is Automatic and concentration of oligomer is provided as mass concentration, calculation of molar concentration depends on the accuracy of MolecularWeight of the oligomer::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* If we have any warnings, we are throwing messages and we are not in Engine, throw an warning message listing the affected objects.*)
	If[MemberQ[masterMixConcentrationFactorNotInformedWarnings,True]&&messages&&notInEngine,
		Message[Warning::DigitalPCRMasterMixConcentrationFactorNotInformed,ObjectToString[PickList[simulatedSamples,masterMixConcentrationFactorNotInformedWarnings],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	masterMixConcentrationFactorNotInformedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[masterMixConcentrationFactorNotInformedWarnings,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,masterMixConcentrationFactorNotInformedWarnings],Simulation->updatedSimulation]<>", ConcentratedBufferDilutionFactor is not informed in MasterMix model and MasterMixConcentrationFactor is calculated from specified MasterMixVolume::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[masterMixConcentrationFactorNotInformedWarnings,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,masterMixConcentrationFactorNotInformedWarnings,False],Simulation->updatedSimulation]<>", ConcentratedBufferDilutionFactor is not informed in MasterMix model and MasterMixConcentrationFactor is calculated from specified MasterMixVolume::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* If we have any warnings, we are throwing messages and we are not in Engine, throw an warning message listing the affected objects.*)
	If[MemberQ[masterMixQuantityMismatchWarnings,True]&&messages&&notInEngine,
		Message[Warning::DigitalPCRMasterMixQuantityMismatch,ObjectToString[PickList[simulatedSamples,masterMixQuantityMismatchWarnings],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	masterMixQuantityMismatchTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[masterMixQuantityMismatchWarnings,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,masterMixQuantityMismatchWarnings],Simulation->updatedSimulation]<>", MasterMixVolume does not match (ReactionVolume/MasterMixConcentrationFactor)::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[masterMixQuantityMismatchWarnings,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,masterMixQuantityMismatchWarnings,False],Simulation->updatedSimulation]<>", MasterMixVolume does not match (ReactionVolume/MasterMixConcentrationFactor)::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(*- DILUTION MISMATCH UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	sampleDilutionMismatchInvalidOptions=If[MemberQ[sampleDilutionMismatchErrors,True],
		{SampleDilution,SerialDilutionCurve,DilutionMixVolume,DilutionNumberOfMixes,DilutionMixRate},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[sampleDilutionMismatchErrors,True]&&messages,
		Message[Error::DigitalPCRSampleDilutionMismatch,ObjectToString[PickList[simulatedSamples,sampleDilutionMismatchErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	sampleDilutionMismatchTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[sampleDilutionMismatchErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,sampleDilutionMismatchErrors],Simulation->updatedSimulation]<>", SerialDilutionCurve, DilutionMixVolume, DilutionNumberOfMixes and DilutionMixRate are informed when SampleDilution is True and PreparedPlate is False, or all options are Null when SampleDilution is False::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[sampleDilutionMismatchErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,sampleDilutionMismatchErrors,False],Simulation->updatedSimulation]<>", SerialDilutionCurve, DilutionMixVolume, DilutionNumberOfMixes and DilutionMixRate are informed when SampleDilution is True and PreparedPlate is False, or all options are Null when SampleDilution is False::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- DILUTION MISMATCH UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	sampleVolumeMismatchInvalidOptions=If[MemberQ[sampleVolumeMismatchErrors,True],
		{SampleVolume,SerialDilutionCurve},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[sampleVolumeMismatchErrors,True]&&messages,
		Message[Error::DigitalPCRDilutionSampleVolume,ObjectToString[PickList[simulatedSamples,sampleVolumeMismatchErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	sampleVolumeMismatchTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[sampleVolumeMismatchErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,sampleVolumeMismatchErrors],Simulation->updatedSimulation]<>", volume of diluted samples is greater than 1.1*SampleVolume::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[sampleVolumeMismatchErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,sampleVolumeMismatchErrors,False],Simulation->updatedSimulation]<>", volume of diluted samples is greater than 1.1*SampleVolume::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];
	
	(*- REFERENCE PROBE UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	singleFluorophorePerReferenceProbeInvalidOptions=If[MemberQ[singleFluorophorePerReferenceProbeErrors,True],
		{ReferenceProbes},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[singleFluorophorePerReferenceProbeErrors,True]&&messages,
		Message[Error::DigitalPCRSingleReferenceFluorophorePerProbe,ObjectToString[PickList[simulatedSamples,singleFluorophorePerReferenceProbeErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	singleFluorophorePerReferenceProbeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[singleFluorophorePerReferenceProbeErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,singleFluorophorePerReferenceProbeErrors],Simulation->updatedSimulation]<>", each ReferenceProbes object has 1 fluorescent oligomer in Composition::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[singleFluorophorePerReferenceProbeErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,singleFluorophorePerReferenceProbeErrors,False],Simulation->updatedSimulation]<>", each ReferenceProbes object has 1 fluorescent oligomer in Composition::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- PROBE FLUOROPHORE UNRESOLVABLE OPTIONS -*)
	(* Null probe wavelength options *)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	probeFluorophoreNullInvalidOptions=If[MemberQ[probeFluorophoreNullOptionsErrors,True],
		{ProbeExcitationWavelength,ProbeEmissionWavelength},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[probeFluorophoreNullOptionsErrors,True]&&messages,
		Message[Error::DigitalPCRProbeWavelengthsNull,ObjectToString[PickList[simulatedSamples,probeFluorophoreNullOptionsErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	probeFluorophoreNullOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[probeFluorophoreNullOptionsErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeFluorophoreNullOptionsErrors],Simulation->updatedSimulation]<>", ProbeExcitationWavelength and ProbeEmissionWavelength are not Null::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[probeFluorophoreNullOptionsErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeFluorophoreNullOptionsErrors,False],Simulation->updatedSimulation]<>", ProbeExcitationWavelength and ProbeEmissionWavelength are not Null::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* Probe wavelength options incompatible with instrument *)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	probeFluorophoreIncompatibleInvalidOptions=If[MemberQ[probeFluorophoreIncompatibleOptionsErrors,True],
		{ProbeExcitationWavelength,ProbeEmissionWavelength},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[probeFluorophoreIncompatibleOptionsErrors,True]&&messages,
		Message[Error::DigitalPCRProbeWavelengthsIncompatible,ObjectToString[PickList[simulatedSamples,probeFluorophoreIncompatibleOptionsErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	probeFluorophoreIncompatibleTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[probeFluorophoreIncompatibleOptionsErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeFluorophoreIncompatibleOptionsErrors],Simulation->updatedSimulation]<>", if ProbeExcitationWavelength and ProbeEmissionWavelength are informed, they are compatible with the specifiedreferencePInstrument::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[probeFluorophoreIncompatibleOptionsErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeFluorophoreIncompatibleOptionsErrors,False],Simulation->updatedSimulation]<>", if ProbeExcitationWavelength and ProbeEmissionWavelength are informed, they are compatible with the specified Instrument::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* Length of probe wavelength options matches length of input probes *)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	probeFluorophoreLengthMismatchInvalidOptions=If[MemberQ[probeFluorophoreLengthMismatchErrors,True],
		{ProbeExcitationWavelength,ProbeEmissionWavelength},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[probeFluorophoreLengthMismatchErrors,True]&&messages,
		Message[Error::DigitalPCRProbeWavelengthsLengthMismatch,ObjectToString[PickList[simulatedSamples,probeFluorophoreLengthMismatchErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	probeFluorophoreLengthMismatchTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[probeFluorophoreLengthMismatchErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeFluorophoreLengthMismatchErrors],Simulation->updatedSimulation]<>", if ProbeExcitationWavelength and ProbeEmissionWavelength are informed for input probes, all three lists have the same length::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[probeFluorophoreLengthMismatchErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeFluorophoreLengthMismatchErrors,False],Simulation->updatedSimulation]<>", if ProbeExcitationWavelength and ProbeEmissionWavelength are informed for input probes, all three lists have the same length::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REFERENCE PROBE FLUOROPHORE UNRESOLVABLE OPTIONS -*)

	(* Null reference probe wavelength options *)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	referenceProbeFluorophoreNullInvalidOptions=If[MemberQ[referenceProbeFluorophoreNullOptionsErrors,True],
		{ReferenceProbeExcitationWavelength,ReferenceProbeEmissionWavelength},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[referenceProbeFluorophoreNullOptionsErrors,True]&&messages,
		Message[Error::DigitalPCRReferenceProbeWavelengthsNull,ObjectToString[PickList[simulatedSamples,referenceProbeFluorophoreNullOptionsErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	referenceProbeFluorophoreNullOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceProbeFluorophoreNullOptionsErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceProbeFluorophoreNullOptionsErrors],Simulation->updatedSimulation]<>", if ReferenceProbes are specified, ReferenceProbeExcitationWavelength and ReferenceProbeEmissionWavelength are not Null::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[probeFluorophoreNullOptionsErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeFluorophoreNullOptionsErrors,False],Simulation->updatedSimulation]<>", if ReferenceProbes are specified, ReferenceProbeExcitationWavelength and ReferenceProbeEmissionWavelength are not Null::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* Reference probe wavelength options incompatible with instrument *)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	referenceProbeFluorophoreIncompatibleInvalidOptions=If[MemberQ[referenceProbeFluorophoreIncompatibleOptionsErrors,True],
		{ReferenceProbeExcitationWavelength,ReferenceProbeEmissionWavelength},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[referenceProbeFluorophoreIncompatibleOptionsErrors,True]&&messages,
		Message[Error::DigitalPCRReferenceProbeWavelengthsIncompatible,ObjectToString[PickList[simulatedSamples,referenceProbeFluorophoreIncompatibleOptionsErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	referenceProbeFluorophoreIncompatibleTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceProbeFluorophoreIncompatibleOptionsErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceProbeFluorophoreIncompatibleOptionsErrors],Simulation->updatedSimulation]<>", if ReferenceProbeExcitationWavelength and ReferenceProbeEmissionWavelength are informed, they are compatible with the specified Instrument::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referenceProbeFluorophoreIncompatibleOptionsErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceProbeFluorophoreIncompatibleOptionsErrors,False],Simulation->updatedSimulation]<>", if ReferenceProbeExcitationWavelength and ReferenceProbeEmissionWavelength are informed, they are compatible with the specified Instrument::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* Length of probe wavelength options matches length of input probes *)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	referenceProbeFluorophoreLengthMismatchInvalidOptions=If[MemberQ[referenceProbeFluorophoreLengthMismatchErrors,True],
		{ReferenceProbeExcitationWavelength,ReferenceProbeEmissionWavelength},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[referenceProbeFluorophoreLengthMismatchErrors,True]&&messages,
		Message[Error::DigitalPCRReferenceProbeWavelengthsLengthMismatch,ObjectToString[PickList[simulatedSamples,referenceProbeFluorophoreLengthMismatchErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	referenceProbeFluorophoreLengthMismatchTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceProbeFluorophoreLengthMismatchErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceProbeFluorophoreLengthMismatchErrors],Simulation->updatedSimulation]<>", if ReferenceProbes, ReferenceProbeExcitationWavelength and ReferenceProbeEmissionWavelength are informed, all three lists have the same length::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referenceProbeFluorophoreLengthMismatchErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceProbeFluorophoreLengthMismatchErrors,False],Simulation->updatedSimulation]<>", if ReferenceProbes, ReferenceProbeExcitationWavelength and ReferenceProbeEmissionWavelength are informed, all three lists have the same length::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- AMPLITUDE MULTIPLEXING UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	amplitudeMultiplexingInvalidOptions=If[MemberQ[amplitudeMultiplexingIncompatibleChannelErrors,True],
		{AmplitudeMultiplexing},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[amplitudeMultiplexingErrors,True]&&messages,
		Message[Error::DigitalPCRAmplitudeMultiplexing,ObjectToString[PickList[simulatedSamples,amplitudeMultiplexingErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	amplitudeMultiplexingTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[amplitudeMultiplexingErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,amplitudeMultiplexingErrors],Simulation->updatedSimulation]<>", if AmplitudeMultiplexing is specified, the emission wavelength channels are compatible with the Instrument and at least one channel has more than 1 target::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[amplitudeMultiplexingErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,amplitudeMultiplexingErrors,False],Simulation->updatedSimulation]<>", if AmplitudeMultiplexing is specified, the emission wavelength channels are compatible with the Instrument and at least one channel has more than 1 target::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- PRIMER/PROBE ASSAY UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	premixedPrimerProbeInvalidOptions=If[MemberQ[premixedPrimerProbeErrors,True],
		{PremixedPrimerProbe},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[premixedPrimerProbeErrors,True]&&messages,
		Message[Error::DigitalPCRPremixedPrimerProbe,ObjectToString[PickList[simulatedSamples,premixedPrimerProbeErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	premixedPrimerProbeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[premixedPrimerProbeErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,premixedPrimerProbeErrors],Simulation->updatedSimulation]<>", if primerPairs and probes are not Null, PremixedPrimerPair is specified as TargetAssay when primerPairs and probes inputs are the same, PrimerSet when only the primerPairs inputs are the same or None if all three are unique objects, and if primerPairs and probes are Null, PremixedPrimerPair is Null::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[premixedPrimerProbeErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,premixedPrimerProbeErrors,False],Simulation->updatedSimulation]<>", if primerPairs and probes are not Null, PremixedPrimerPair is specified as TargetAssay when primerPairs and probes inputs are the same, PrimerSet when only the primerPairs inputs are the same or None if all three are unique objects, and if primerPairs and probes are Null, PremixedPrimerPair is Null::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REFERENCE PRIMER/PROBE ASSAY UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	referencePremixedPrimerProbeInvalidOptions=If[MemberQ[referencePremixedPrimerProbeErrors,True],
		{ReferencePremixedPrimerProbe},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[referencePremixedPrimerProbeErrors,True]&&messages,
		Message[Error::DigitalPCRReferencePremixedPrimerProbe,ObjectToString[PickList[simulatedSamples,referencePremixedPrimerProbeErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	referencePremixedPrimerProbeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referencePremixedPrimerProbeErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referencePremixedPrimerProbeErrors],Simulation->updatedSimulation]<>", if ReferencePrimerPairs and ReferenceProbes are not Null, ReferencePremixedPrimerPair is specified as TargetAssay when ReferencePrimerPairs and ReferenceProbes inputs are the same, PrimerSet when only the ReferencePrimerPairs inputs are the same or None if all three are unique objects, and if ReferencePrimerPairs and ReferenceProbes are Null, ReferencePremixedPrimerPair is Null::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referencePremixedPrimerProbeErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referencePremixedPrimerProbeErrors,False],Simulation->updatedSimulation]<>", if ReferencePrimerPairs and ReferenceProbes are not Null, ReferencePremixedPrimerPair is specified as TargetAssay when ReferencePrimerPairs and ReferenceProbes inputs are the same, PrimerSet when only the ReferencePrimerPairs inputs are the same or None if all three are unique objects, and if ReferencePrimerPairs and ReferenceProbes are Null, ReferencePremixedPrimerPair is Null::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- PROBE STOCK CONCENTRATION UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	probeStockConcentrationInvalidOptions=If[MemberQ[probeStockConcentrationErrors,True],
		{ProbeConcentration,ProbeVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[probeStockConcentrationErrors,True]&&messages,
		Message[Error::DigitalPCRProbeStockConcentration,ObjectToString[PickList[simulatedSamples,probeStockConcentrationErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	probeStockConcentrationTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[probeStockConcentrationErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeStockConcentrationErrors],Simulation->updatedSimulation]<>", if probes are not Null and ProbeConcentration or ProbeVolume are Automatic, stock concentration is provided as molar concentration in sample composition or mass concentration in sample Composition with MolecularWeight in the identity oligomer::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[probeStockConcentrationErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeStockConcentrationErrors,False],Simulation->updatedSimulation]<>", if probes are not Null and ProbeConcentration or ProbeVolume are Automatic, stock concentration is provided as molar concentration in sample composition or mass concentration in sample Composition with MolecularWeight in the identity oligomer::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REFERENCE PROBE STOCK CONCENTRATION UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	referenceProbeStockConcentrationInvalidOptions=If[MemberQ[referenceProbeStockConcentrationErrors,True],
		{ReferenceProbeConcentration,ReferenceProbeVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[referenceProbeStockConcentrationErrors,True]&&messages,
		Message[Error::DigitalPCRReferenceProbeStockConcentration,ObjectToString[PickList[simulatedSamples,referenceProbeStockConcentrationErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	referenceProbeStockConcentrationTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceProbeStockConcentrationErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceProbeStockConcentrationErrors],Simulation->updatedSimulation]<>", if ReferenceProbes are not Null and ReferenceProbeConcentration or ReferenceProbeVolume are Automatic, stock concentration is provided as molar concentration in sample composition or mass concentration in sample Composition with MolecularWeight in the identity oligomer::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referenceProbeStockConcentrationErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceProbeStockConcentrationErrors,False],Simulation->updatedSimulation]<>", if ReferenceProbes are not Null and ReferenceProbeConcentration or ReferenceProbeVolume are Automatic, stock concentration is provided as molar concentration in sample composition or mass concentration in sample Composition with MolecularWeight in the identity oligomer::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- PROBE CONCENTRATION/VOLUME MISMATCH UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	probeConcentrationVolumeMismatchInvalidOptions=If[MemberQ[probeConcentrationVolumeMismatchOptionErrors,True],
		{ProbeConcentration,ProbeVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[probeConcentrationVolumeMismatchOptionErrors,True]&&messages,
		Message[Error::DigitalPCRProbeConcentrationVolumeMismatch,ObjectToString[PickList[simulatedSamples,probeConcentrationVolumeMismatchOptionErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	probeConcentrationVolumeMismatchOptionTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[probeConcentrationVolumeMismatchOptionErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeConcentrationVolumeMismatchOptionErrors],Simulation->updatedSimulation]<>", if probes are not Null, and ProbeConcentration and ProbeVolume are specified, they are within +/-5% range as calculated using probe stock concentration, and if probes are Null, both options are Null::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[probeConcentrationVolumeMismatchOptionErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeConcentrationVolumeMismatchOptionErrors,False],Simulation->updatedSimulation]<>", if probes are not Null, and ProbeConcentration and ProbeVolume are specified, they are within +/-5% range as calculated using probe stock concentration, and if probes are Null, both options are Null::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- PROBE STOCK CONCENTRATION TOO LOW UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	probeStockConcentrationTooLowInvalidOptions=If[MemberQ[probeStockConcentrationTooLowErrors,True],
		{ProbeConcentration,ProbeVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[probeStockConcentrationTooLowErrors,True]&&messages,
		Message[Error::DigitalPCRProbeStockConcentrationTooLow,ObjectToString[PickList[simulatedSamples,probeStockConcentrationTooLowErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	probeStockConcentrationTooLowTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[probeStockConcentrationTooLowErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeStockConcentrationTooLowErrors],Simulation->updatedSimulation]<>", if probes are not Null, and ProbeConcentration, ProbeVolume and probe stock concentration are informed, probe stock concentration is 4x ProbeConcentration::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[probeStockConcentrationTooLowErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,probeStockConcentrationTooLowErrors,False],Simulation->updatedSimulation]<>", if probes are not Null, and ProbeConcentration, ProbeVolume and probe stock concentration are informed, probe stock concentration is 4x ProbeConcentration::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REFERENCE PROBE CONCENTRATION/VOLUME MISMATCH UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	referenceProbeConcentrationVolumeMismatchInvalidOptions=If[MemberQ[referenceProbeConcentrationVolumeMismatchOptionErrors,True],
		{ReferenceProbeConcentration,ReferenceProbeVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[referenceProbeConcentrationVolumeMismatchOptionErrors,True]&&messages,
		Message[Error::DigitalPCRReferenceProbeConcentrationVolumeMismatch,ObjectToString[PickList[simulatedSamples,referenceProbeConcentrationVolumeMismatchOptionErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	referenceProbeConcentrationVolumeMismatchOptionTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceProbeConcentrationVolumeMismatchOptionErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceProbeConcentrationVolumeMismatchOptionErrors],Simulation->updatedSimulation]<>", if ReferenceProbes are not Null, and ReferenceProbeConcentration and ReferenceProbeVolume are specified, they are within +/-5% range as calculated using reference probe stock concentration, and if ReferenceProbes are Null, both options are Null::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referenceProbeConcentrationVolumeMismatchOptionErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceProbeConcentrationVolumeMismatchOptionErrors,False],Simulation->updatedSimulation]<>", if ReferenceProbes are not Null, and ReferenceProbeConcentration and ReferenceProbeVolume are specified, they are within +/-5% range as calculated using reference probe stock concentration, and if ReferenceProbes are Null, both options are Null::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REFERENCE PROBE STOCK CONCENTRATION TOO LOW UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	referenceProbeStockConcentrationTooLowInvalidOptions=If[MemberQ[referenceProbeStockConcentrationTooLowErrors,True],
		{ReferenceProbeConcentration,ReferenceProbeVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[referenceProbeStockConcentrationTooLowErrors,True]&&messages,
		Message[Error::DigitalPCRReferenceProbeStockConcentrationTooLow,ObjectToString[PickList[simulatedSamples,referenceProbeStockConcentrationTooLowErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	referenceProbeStockConcentrationTooLowTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceProbeStockConcentrationTooLowErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceProbeStockConcentrationTooLowErrors],Simulation->updatedSimulation]<>", if ReferenceProbes are not Null, and ReferenceProbeConcentration, ReferenceProbeVolume and reference probe stock concentration are informed, reference probe stock concentration is 4x ReferenceProbeConcentration::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referenceProbeStockConcentrationTooLowErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceProbeStockConcentrationTooLowErrors,False],Simulation->updatedSimulation]<>", if ReferenceProbes are not Null, and ReferenceProbeConcentration, ReferenceProbeVolume and reference probe stock concentration are informed, reference probe stock concentration is 4x ReferenceProbeConcentration::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- FORWARD PRIMER STOCK CONCENTRATION UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	forwardPrimerStockConcentrationInvalidOptions=If[MemberQ[forwardPrimerStockConcentrationErrors,True],
		{ForwardPrimerConcentration,ForwardPrimerVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[forwardPrimerStockConcentrationErrors,True]&&messages,
		Message[Error::DigitalPCRForwardPrimerStockConcentration,ObjectToString[PickList[simulatedSamples,forwardPrimerStockConcentrationErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	forwardPrimerStockConcentrationTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[forwardPrimerStockConcentrationErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,forwardPrimerStockConcentrationErrors],Simulation->updatedSimulation]<>", if forward primers are not Null and ForwardPrimerConcentration or ForwardPrimerVolume are Automatic, stock concentration is provided as molar concentration in sample composition or mass concentration in sample Composition with MolecularWeight in the identity oligomer::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[forwardPrimerStockConcentrationErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,forwardPrimerStockConcentrationErrors,False],Simulation->updatedSimulation]<>", if forward primers are not Null and ForwardPrimerConcentration or ForwardPrimerVolume are Automatic, stock concentration is provided as molar concentration in sample composition or mass concentration in sample Composition with MolecularWeight in the identity oligomer::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- FORWARD PRIMER CONCENTRATION/VOLUME MISMATCH UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	forwardPrimerConcentrationVolumeMismatchInvalidOptions=If[MemberQ[forwardPrimerConcentrationVolumeMismatchOptionErrors,True],
		{ForwardPrimerConcentration,ForwardPrimerVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[forwardPrimerConcentrationVolumeMismatchOptionErrors,True]&&messages,
		Message[Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,ObjectToString[PickList[simulatedSamples,forwardPrimerConcentrationVolumeMismatchOptionErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	forwardPrimerConcentrationVolumeMismatchOptionTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[forwardPrimerConcentrationVolumeMismatchOptionErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,forwardPrimerConcentrationVolumeMismatchOptionErrors],Simulation->updatedSimulation]<>", if forward primers are Null, both options are Null, if forward primers are not Null, ForwardPrimerConcentration and ForwardPrimerVolume are specified only when PremixedPrimerProbe is specified as PrimerSet or None, and the respective concentration and volume are within +/-5% range as calculated using forward primer stock concentration::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[forwardPrimerConcentrationVolumeMismatchOptionErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,forwardPrimerConcentrationVolumeMismatchOptionErrors,False],Simulation->updatedSimulation]<>", if forward primers are Null, both options are Null, if forward primers are not Null, ForwardPrimerConcentration and ForwardPrimerVolume are specified only when PremixedPrimerProbe is specified as PrimerSet or None, and the respective concentration and volume are within +/-5% range as calculated using forward primer stock concentration::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- FORWARD PRIMER STOCK CONCENTRATION TOO LOW UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	forwardPrimerStockConcentrationTooLowInvalidOptions=If[MemberQ[forwardPrimerStockConcentrationTooLowErrors,True],
		{ForwardPrimerConcentration,ForwardPrimerVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[forwardPrimerStockConcentrationTooLowErrors,True]&&messages,
		Message[Error::DigitalPCRForwardPrimerStockConcentrationTooLow,ObjectToString[PickList[simulatedSamples,forwardPrimerStockConcentrationTooLowErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	forwardPrimerStockConcentrationTooLowTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[forwardPrimerStockConcentrationTooLowErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,forwardPrimerStockConcentrationTooLowErrors],Simulation->updatedSimulation]<>", if forward primers are not Null, and ForwardPrimerConcentration, ForwardPrimerVolume and forward primer stock concentration are informed, forward primer stock concentration is 4x ProbeConcentration::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[forwardPrimerStockConcentrationTooLowErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,forwardPrimerStockConcentrationTooLowErrors,False],Simulation->updatedSimulation]<>", if forward primers are not Null, and ForwardPrimerConcentration, ForwardPrimerVolume and forward primer stock concentration are informed, forward primer stock concentration is 4x ProbeConcentration::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REVERSE PRIMER STOCK CONCENTRATION UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	reversePrimerStockConcentrationInvalidOptions=If[MemberQ[reversePrimerStockConcentrationErrors,True],
		{ReversePrimerConcentration,ReversePrimerVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[reversePrimerStockConcentrationErrors,True]&&messages,
		Message[Error::DigitalPCRReversePrimerStockConcentration,ObjectToString[PickList[simulatedSamples,reversePrimerStockConcentrationErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	reversePrimerStockConcentrationTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[reversePrimerStockConcentrationErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,reversePrimerStockConcentrationErrors],Simulation->updatedSimulation]<>", if reverse primers are not Null and ReversePrimerConcentration or ReversePrimerVolume are Automatic, stock concentration is provided as molar concentration in sample composition or mass concentration in sample Composition with MolecularWeight in the identity oligomer::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[reversePrimerStockConcentrationErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,reversePrimerStockConcentrationErrors,False],Simulation->updatedSimulation]<>", if reverse primers are not Null and ReversePrimerConcentration or ReversePrimerVolume are Automatic, stock concentration is provided as molar concentration in sample composition or mass concentration in sample Composition with MolecularWeight in the identity oligomer::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REVERSE PRIMER CONCENTRATION/VOLUME MISMATCH UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	reversePrimerConcentrationVolumeMismatchInvalidOptions=If[MemberQ[reversePrimerConcentrationVolumeMismatchOptionErrors,True],
		{ReversePrimerConcentration,ReversePrimerVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[reversePrimerConcentrationVolumeMismatchOptionErrors,True]&&messages,
		Message[Error::DigitalPCRReversePrimerConcentrationVolumeMismatch,ObjectToString[PickList[simulatedSamples,reversePrimerConcentrationVolumeMismatchOptionErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	reversePrimerConcentrationVolumeMismatchOptionTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[reversePrimerConcentrationVolumeMismatchOptionErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,reversePrimerConcentrationVolumeMismatchOptionErrors],Simulation->updatedSimulation]<>", if reverse primers are Null, both options are Null, if reverse primers are not Null, ReversePrimerConcentration and ReversePrimerVolume are specified only when PremixedPrimerProbe is specified as None, and the respective concentration and volume are within +/-5% range as calculated using reverse primer stock concentration::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[reversePrimerConcentrationVolumeMismatchOptionErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,reversePrimerConcentrationVolumeMismatchOptionErrors,False],Simulation->updatedSimulation]<>", if reverse primers are Null, both options are Null, if reverse primers are not Null, ReversePrimerConcentration and ReversePrimerVolume are specified only when PremixedPrimerProbe is specified as None, and the respective concentration and volume are within +/-5% range as calculated using reverse primer stock concentration::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REVERSE PRIMER STOCK CONCENTRATION TOO LOW UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	reversePrimerStockConcentrationTooLowInvalidOptions=If[MemberQ[reversePrimerStockConcentrationTooLowErrors,True],
		{ReversePrimerConcentration,ReversePrimerVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[reversePrimerStockConcentrationTooLowErrors,True]&&messages,
		Message[Error::DigitalPCRReversePrimerStockConcentrationTooLow,ObjectToString[PickList[simulatedSamples,reversePrimerStockConcentrationTooLowErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	reversePrimerStockConcentrationTooLowTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[reversePrimerStockConcentrationTooLowErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,reversePrimerStockConcentrationTooLowErrors],Simulation->updatedSimulation]<>", if reverse primers are not Null, and ReversePrimerConcentration, ReversePrimerVolume and reverse primer stock concentration are informed, reverse primer stock concentration is 4x ProbeConcentration::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[reversePrimerStockConcentrationTooLowErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,reversePrimerStockConcentrationTooLowErrors,False],Simulation->updatedSimulation]<>", if reverse primers are not Null, and ReversePrimerConcentration, ReversePrimerVolume and reverse primer stock concentration are informed, reverse primer stock concentration is 4x ProbeConcentration::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REFERENCE FORWARD PRIMER STOCK CONCENTRATION UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	referenceForwardPrimerStockConcentrationInvalidOptions=If[MemberQ[referenceForwardPrimerStockConcentrationErrors,True],
		{ReferenceForwardPrimerConcentration,ReferenceForwardPrimerVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[referenceForwardPrimerStockConcentrationErrors,True]&&messages,
		Message[Error::DigitalPCRReferenceForwardPrimerStockConcentration,ObjectToString[PickList[simulatedSamples,referenceForwardPrimerStockConcentrationErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	referenceForwardPrimerStockConcentrationTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceForwardPrimerStockConcentrationErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceForwardPrimerStockConcentrationErrors],Simulation->updatedSimulation]<>", if reference forward primers are not Null and ReferenceForwardPrimerConcentration or ReferenceForwardPrimerVolume are Automatic, stock concentration is provided as molar concentration in sample composition or mass concentration in sample Composition with MolecularWeight in the identity oligomer::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referenceForwardPrimerStockConcentrationErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceForwardPrimerStockConcentrationErrors,False],Simulation->updatedSimulation]<>", if reference forward primers are not Null and ReferenceForwardPrimerConcentration or ReferenceForwardPrimerVolume are Automatic, stock concentration is provided as molar concentration in sample composition or mass concentration in sample Composition with MolecularWeight in the identity oligomer::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REFERENCE FORWARD PRIMER CONCENTRATION/VOLUME MISMATCH UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	referenceForwardPrimerConcentrationVolumeMismatchInvalidOptions=If[MemberQ[referenceForwardPrimerConcentrationVolumeMismatchOptionErrors,True],
		{ReferenceForwardPrimerConcentration,ReferenceForwardPrimerVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[referenceForwardPrimerConcentrationVolumeMismatchOptionErrors,True]&&messages,
		Message[Error::DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch,ObjectToString[PickList[simulatedSamples,referenceForwardPrimerConcentrationVolumeMismatchOptionErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	referenceForwardPrimerConcentrationVolumeMismatchOptionTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceForwardPrimerConcentrationVolumeMismatchOptionErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceForwardPrimerConcentrationVolumeMismatchOptionErrors],Simulation->updatedSimulation]<>", if reference forward primers are Null, both options are Null, if reference forward primers are not Null, ReferenceForwardPrimerConcentration and ReferenceForwardPrimerVolume are specified only when ReferencePremixedPrimerProbe is specified as PrimerSet or None, and the respective concentration and volume are within +/-5% range as calculated using reference forward primer stock concentration::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referenceForwardPrimerConcentrationVolumeMismatchOptionErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceForwardPrimerConcentrationVolumeMismatchOptionErrors,False],Simulation->updatedSimulation]<>", if reference forward primers are Null, both options are Null, if reference forward primers are not Null, ReferenceForwardPrimerConcentration and ReferenceForwardPrimerVolume are specified only when ReferencePremixedPrimerProbe is specified as PrimerSet or None, and the respective concentration and volume are within +/-5% range as calculated using reference forward primer stock concentration::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REFERENCE FORWARD PRIMER STOCK CONCENTRATION TOO LOW UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	referenceForwardPrimerStockConcentrationTooLowInvalidOptions=If[MemberQ[referenceForwardPrimerStockConcentrationTooLowErrors,True],
		{ReferenceForwardPrimerConcentration,ReferenceForwardPrimerVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[referenceForwardPrimerStockConcentrationTooLowErrors,True]&&messages,
		Message[Error::DigitalPCRReferenceForwardPrimerStockConcentrationTooLow,ObjectToString[PickList[simulatedSamples,referenceForwardPrimerStockConcentrationTooLowErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	referenceForwardPrimerStockConcentrationTooLowTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceForwardPrimerStockConcentrationTooLowErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceForwardPrimerStockConcentrationTooLowErrors],Simulation->updatedSimulation]<>", if reference forward primers are not Null, and ReferenceForwardPrimerConcentration, ReferenceForwardPrimerVolume and reference forward primer stock concentration are informed, reference forward primer stock concentration is 4x ReferenceProbeConcentration::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referenceForwardPrimerStockConcentrationTooLowErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceForwardPrimerStockConcentrationTooLowErrors,False],Simulation->updatedSimulation]<>", if reference forward primers are not Null, and ReferenceForwardPrimerConcentration, ReferenceForwardPrimerVolume and reference forward primer stock concentration are informed, reference forward primer stock concentration is 4x ReferenceProbeConcentration::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REFERENCE REVERSE PRIMER STOCK CONCENTRATION UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	referenceReversePrimerStockConcentrationInvalidOptions=If[MemberQ[referenceReversePrimerStockConcentrationErrors,True],
		{ReferenceReversePrimerConcentration,ReferenceReversePrimerVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[referenceReversePrimerStockConcentrationErrors,True]&&messages,
		Message[Error::DigitalPCRReferenceReversePrimerStockConcentration,ObjectToString[PickList[simulatedSamples,referenceReversePrimerStockConcentrationErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	referenceReversePrimerStockConcentrationTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceReversePrimerStockConcentrationErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceReversePrimerStockConcentrationErrors],Simulation->updatedSimulation]<>", if reference reverse primers are not Null and ReferenceReversePrimerConcentration or ReferenceReversePrimerVolume are Automatic, stock concentration is provided as molar concentration in sample composition or mass concentration in sample Composition with MolecularWeight in the identity oligomer::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referenceReversePrimerStockConcentrationErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceReversePrimerStockConcentrationErrors,False],Simulation->updatedSimulation]<>", if reference reverse primers are not Null and ReferenceReversePrimerConcentration or ReferenceReversePrimerVolume are Automatic, stock concentration is provided as molar concentration in sample composition or mass concentration in sample Composition with MolecularWeight in the identity oligomer::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REFERENCE REVERSE PRIMER CONCENTRATION/VOLUME MISMATCH UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	referenceReversePrimerConcentrationVolumeMismatchInvalidOptions=If[MemberQ[referenceReversePrimerConcentrationVolumeMismatchOptionErrors,True],
		{ReferenceReversePrimerConcentration,ReferenceReversePrimerVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[referenceReversePrimerConcentrationVolumeMismatchOptionErrors,True]&&messages,
		Message[Error::DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch,ObjectToString[PickList[simulatedSamples,referenceReversePrimerConcentrationVolumeMismatchOptionErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	referenceReversePrimerConcentrationVolumeMismatchOptionTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceReversePrimerConcentrationVolumeMismatchOptionErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceReversePrimerConcentrationVolumeMismatchOptionErrors],Simulation->updatedSimulation]<>", if reference reverse primers are Null, both options are Null, if reference reverse primers are not Null, ReferenceReversePrimerConcentration and ReferenceReversePrimerVolume are specified only when ReferencePremixedPrimerProbe is specified as None, and the respective concentration and volume are within +/-5% range as calculated using reference reverse primer stock concentration::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referenceReversePrimerConcentrationVolumeMismatchOptionErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceReversePrimerConcentrationVolumeMismatchOptionErrors,False],Simulation->updatedSimulation]<>", if reference reverse primers are Null, both options are Null, if reference reverse primers are not Null, ReferenceReversePrimerConcentration and ReferenceReversePrimerVolume are specified only when ReferencePremixedPrimerProbe is specified as None, and the respective concentration and volume are within +/-5% range as calculated using reference reverse primer stock concentration::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REFERENCE REVERSE PRIMER STOCK CONCENTRATION TOO LOW UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	referenceReversePrimerStockConcentrationTooLowInvalidOptions=If[MemberQ[referenceReversePrimerStockConcentrationTooLowErrors,True],
		{ReferenceReversePrimerConcentration,ReferenceReversePrimerVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[referenceReversePrimerStockConcentrationTooLowErrors,True]&&messages,
		Message[Error::DigitalPCRReferenceReversePrimerStockConcentrationTooLow,ObjectToString[PickList[simulatedSamples,referenceReversePrimerStockConcentrationTooLowErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	referenceReversePrimerStockConcentrationTooLowTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referenceReversePrimerStockConcentrationTooLowErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceReversePrimerStockConcentrationTooLowErrors],Simulation->updatedSimulation]<>", if reference reverse primers are not Null, and ReferenceReversePrimerConcentration, ReferenceReversePrimerVolume and reference reverse primer stock concentration are informed, reference reverse primer stock concentration is 4x ProbeConcentration::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referenceReversePrimerStockConcentrationTooLowErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referenceReversePrimerStockConcentrationTooLowErrors,False],Simulation->updatedSimulation]<>", if reference reverse primers are not Null, and ReferenceReversePrimerConcentration, ReferenceReversePrimerVolume and reference reverse primer stock concentration are informed, reference reverse primer stock concentration is 4x ProbeConcentration::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- REVERSE TRANSCRIPTION UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	reverseTranscriptionMismatchInvalidOptions=If[MemberQ[reverseTranscriptionMismatchOptionsErrors,True],
		{ReverseTranscription,ReverseTranscriptionTime,ReverseTranscriptionTemperature,ReverseTranscriptionRampRate},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[reverseTranscriptionMismatchOptionsErrors,True]&&messages,
		Message[Error::DigitalPCRReverseTranscriptionMismatch,ObjectToString[PickList[simulatedSamples,reverseTranscriptionMismatchOptionsErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	reverseTranscriptionMismatchTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[reverseTranscriptionMismatchOptionsErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,reverseTranscriptionMismatchOptionsErrors],Simulation->updatedSimulation]<>", if ReverseTranscription is True, ReverseTranscriptionTime, ReverseTranscriptionTemperature, and ReverseTranscriptionRampRate are specified; if ReverseTranscription is False, ReverseTranscriptionTime, ReverseTranscriptionTemperature, and ReverseTranscriptionRampRate are Null::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[reverseTranscriptionMismatchOptionsErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,reverseTranscriptionMismatchOptionsErrors,False],Simulation->updatedSimulation]<>", if ReverseTranscription is True, ReverseTranscriptionTime, ReverseTranscriptionTemperature, and ReverseTranscriptionRampRate are specified; if ReverseTranscription is False, ReverseTranscriptionTime, ReverseTranscriptionTemperature, and ReverseTranscriptionRampRate are Null::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- MASTER MIX UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	masterMixMismatchInvalidOptions=If[MemberQ[masterMixMismatchOptionsErrors,True],
		{PreparedPlate,MasterMixConcentrationFactor,MasterMixVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[masterMixMismatchOptionsErrors,True]&&messages,
		Message[Error::DigitalPCRMasterMixMismatch,ObjectToString[PickList[simulatedSamples,masterMixMismatchOptionsErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	masterMixMismatchTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[masterMixMismatchOptionsErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,masterMixMismatchOptionsErrors],Simulation->updatedSimulation]<>", if PreparedPlate is False, MasterMixConcentrationFactor and MasterMixVolume are specified; if PreparedPlate is True,MasterMixConcentrationFactor and MasterMixVolume are Null::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[masterMixMismatchOptionsErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,masterMixMismatchOptionsErrors,False],Simulation->updatedSimulation]<>", if PreparedPlate is False, MasterMixConcentrationFactor and MasterMixVolume are specified; if PreparedPlate is True,MasterMixConcentrationFactor and MasterMixVolume are Null::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- DILUENT UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	diluentVolumeInvalidOptions=If[MemberQ[diluentVolumeOptionErrors,True],
		{PreparedPlate,DiluentVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[diluentVolumeOptionErrors,True]&&messages,
		Message[Error::DigitalPCRDiluentVolume,ObjectToString[PickList[simulatedSamples,diluentVolumeOptionErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	diluentVolumeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[diluentVolumeOptionErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,diluentVolumeOptionErrors],Simulation->updatedSimulation]<>", if PreparedPlate is False, DiluentVolume has a non-negative value; if PreparedPlate is True, DiluentVolume is Null::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[diluentVolumeOptionErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,diluentVolumeOptionErrors,False],Simulation->updatedSimulation]<>", if PreparedPlate is False, DiluentVolume has a non-negative value; if PreparedPlate is True, DiluentVolume is Null::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- TOTAL VOLUME UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	totalVolumeInvalidOptions=If[MemberQ[totalVolumeErrors,True],
		{SampleVolume,ForwardPrimerVolume,ReversePrimerVolume,ProbeVolume,ReferenceForwardPrimerVolume,ReferenceReversePrimerVolume,ReferenceProbeVolume,MasterMixVolume,DiluentVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[totalVolumeErrors,True]&&messages,
		Message[Error::DigitalPCRTotalVolume,ObjectToString[PickList[simulatedSamples,totalVolumeErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	totalVolumeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[totalVolumeErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,totalVolumeErrors],Simulation->updatedSimulation]<>", volume of all inputs and stock solutions going in the sample are within +/- 0.5 microliter of ReactionVolume::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[totalVolumeErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,totalVolumeErrors,False],Simulation->updatedSimulation]<>", volume of all inputs and stock solutions going in the sample are within +/- 0.5 microliter of ReactionVolume::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- ACTIVATION UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	activationMismatchInvalidOptions=If[MemberQ[activationMismatchOptionsErrors,True],
		{Activation,ActivationTime,ActivationTemperature,ActivationRampRate},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[activationMismatchOptionsErrors,True]&&messages,
		Message[Error::DigitalPCRActivationMismatch,ObjectToString[PickList[simulatedSamples,activationMismatchOptionsErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	activationMismatchTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[activationMismatchOptionsErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,activationMismatchOptionsErrors],Simulation->updatedSimulation]<>", if Activation is True, ActivationTime, ActivationTemperature, and ActivationRampRate are specified; if Activation is False, ActivationTime, ActivationTemperature, and ActivationRampRate are Null::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[activationMismatchOptionsErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,activationMismatchOptionsErrors,False],Simulation->updatedSimulation]<>", if Activation is True, ActivationTime, ActivationTemperature, and ActivationRampRate are specified; if Activation is False, ActivationTime, ActivationTemperature, and ActivationRampRate are Null::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- PRIMER ANNEALING & PRIMER GRADIENT ANNEALING UNRESOLVABLE OPTIONS -*)
	(*- PRIMER ANNEALING UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	primerAnnealingMismatchInvalidOptions=If[MemberQ[primerAnnealingMismatchOptionsErrors,True],
		{PrimerAnnealing,PrimerAnnealingTime,PrimerAnnealingTemperature,PrimerAnnealingRampRate},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[primerAnnealingMismatchOptionsErrors,True]&&messages,
		Message[Error::DigitalPCRPrimerAnnealingMismatch,ObjectToString[PickList[simulatedSamples,primerAnnealingMismatchOptionsErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	primerAnnealingMismatchTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[primerAnnealingMismatchOptionsErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,primerAnnealingMismatchOptionsErrors],Simulation->updatedSimulation]<>", if PrimerAnnealing is True, PrimerAnnealingTime, PrimerAnnealingTemperature, and PrimerAnnealingRampRate are specified; if PrimerAnnealing is False, PrimerAnnealingTemperature, and PrimerAnnealingRampRate are Null; if PrimerGradientAnnealing is also False, PrimerAnnealingTime is also Null::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[primerAnnealingMismatchOptionsErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,primerAnnealingMismatchOptionsErrors,False],Simulation->updatedSimulation]<>", if PrimerAnnealing is True, PrimerAnnealingTime, PrimerAnnealingTemperature, and PrimerAnnealingRampRate are specified; if PrimerAnnealing is False, PrimerAnnealingTemperature, and PrimerAnnealingRampRate are Null; if PrimerGradientAnnealing is also False, PrimerAnnealingTime is also Null::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- PRIMER GRADIENT ANNEALING UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	primerGradientAnnealingMismatchInvalidOptions=If[MemberQ[primerGradientAnnealingMismatchOptionsErrors,True],
		{PrimerGradientAnnealing,PrimerAnnealingTime,PrimerGradientAnnealingMinTemperature,PrimerGradientAnnealingMaxTemperature,PrimerGradientAnnealingRow},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[primerGradientAnnealingMismatchOptionsErrors,True]&&messages,
		Message[Error::DigitalPCRPrimerGradientAnnealingMismatch,ObjectToString[PickList[simulatedSamples,primerGradientAnnealingMismatchOptionsErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	primerGradientAnnealingMismatchTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[primerGradientAnnealingMismatchOptionsErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,primerGradientAnnealingMismatchOptionsErrors],Simulation->updatedSimulation]<>", if PrimerGradientAnnealing is True, PrimerGradientAnnealingTime, PrimerGradientAnnealingMinTemperature, PrimerGradientAnnealingMaxTemperature, and PrimerGradientAnnealingRow are specified; if PrimerGradientAnnealing is False, PrimerGradientAnnealingMinTemperature, PrimerGradientAnnealingMaxTemperature, and PrimerGradientAnnealingRow are Null::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[primerGradientAnnealingMismatchOptionsErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,primerGradientAnnealingMismatchOptionsErrors,False],Simulation->updatedSimulation]<>", if PrimerGradientAnnealing is True, PrimerGradientAnnealingTime, PrimerGradientAnnealingMinTemperature, PrimerGradientAnnealingMaxTemperature, and PrimerGradientAnnealingRow are specified; if PrimerGradientAnnealing is False, PrimerGradientAnnealingMinTemperature, PrimerGradientAnnealingMaxTemperature, and PrimerGradientAnnealingRow are Null::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- PRIMER GRADIENT ANNEALING ROW/TEMPERATURE UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	primerGradientAnnealingRowTemperatureMismatchInvalidOptions=If[MemberQ[primerGradientAnnealingRowTemperatureMismatchErrors,True],
		{PrimerGradientAnnealingRow},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[primerGradientAnnealingRowTemperatureMismatchErrors,True]&&messages,
		Message[Error::DigitalPCRPrimerGradientAnnealingRowTemperatureMismatch,ObjectToString[PickList[simulatedSamples,primerGradientAnnealingRowTemperatureMismatchErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	primerGradientAnnealingRowTemperatureMismatchTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[primerGradientAnnealingRowTemperatureMismatchErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,primerGradientAnnealingRowTemperatureMismatchErrors],Simulation->updatedSimulation]<>", if PrimerGradientAnnealingRow is specified with {Row,Temperature}, the temperature matches the appropriate value as calculated from Range[PrimerGradientAnnealingMinTemperature,PrimerGradientAnnealingMaxTemperature,7] and rounded to 0.1 Celsius::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[primerGradientAnnealingRowTemperatureMismatchErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,primerGradientAnnealingRowTemperatureMismatchErrors,False],Simulation->updatedSimulation]<>", if PrimerGradientAnnealingRow is specified with {Row,Temperature}, the temperature matches the appropriate value as calculated from Range[PrimerGradientAnnealingMinTemperature,PrimerGradientAnnealingMaxTemperature,7] and rounded to 0.1 Celsius::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- OVER-CONSTRAINED ROW OPTIONS UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	overConstrainedRowOptionsInvalidOptions=If[MemberQ[overConstrainedRowOptionsErrors,True],
		{ActiveWell,PrimerGradientAnnealingRow},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[overConstrainedRowOptionsErrors,True]&&messages,
		Message[Error::DigitalPCROverConstrainedRowOptions,ObjectToString[PickList[simulatedSamples,overConstrainedRowOptionsErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	overConstrainedRowOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[overConstrainedRowOptionsErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,overConstrainedRowOptionsErrors],Simulation->updatedSimulation]<>", if ActiveWell and PrimerGradientAnnealingRow are specified, the rows match::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[overConstrainedRowOptionsErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,overConstrainedRowOptionsErrors,False],Simulation->updatedSimulation]<>", if ActiveWell and PrimerGradientAnnealingRow are specified, the rows match::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- EXTENSION UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	extensionMismatchInvalidOptions=If[MemberQ[extensionMismatchOptionsErrors,True],
		{Extension,ExtensionTime,ExtensionTemperature,ExtensionRampRate},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[extensionMismatchOptionsErrors,True]&&messages,
		Message[Error::DigitalPCRExtensionMismatch,ObjectToString[PickList[simulatedSamples,extensionMismatchOptionsErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	extensionMismatchTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[extensionMismatchOptionsErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,extensionMismatchOptionsErrors],Simulation->updatedSimulation]<>", if Extension is True, ExtensionTime, ExtensionTemperature, and ExtensionRampRate are specified; if Extension is False, ExtensionTime, ExtensionTemperature, and ExtensionRampRate are Null::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[extensionMismatchOptionsErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,extensionMismatchOptionsErrors,False],Simulation->updatedSimulation]<>", if Extension is True, ExtensionTime, ExtensionTemperature, and ExtensionRampRate are specified; if Extension is False, ExtensionTime, ExtensionTemperature, and ExtensionRampRate are Null::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*- POLYMERASE DEGRADATION UNRESOLVABLE OPTIONS -*)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	polymeraseDegradationMismatchInvalidOptions=If[MemberQ[polymeraseDegradationMismatchOptionsErrors,True],
		{PolymeraseDegradation,PolymeraseDegradationTime,PolymeraseDegradationTemperature,PolymeraseDegradationRampRate},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[polymeraseDegradationMismatchOptionsErrors,True]&&messages,
		Message[Error::DigitalPCRPolymeraseDegradationMismatch,ObjectToString[PickList[simulatedSamples,polymeraseDegradationMismatchOptionsErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	polymeraseDegradationMismatchTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[polymeraseDegradationMismatchOptionsErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,polymeraseDegradationMismatchOptionsErrors],Simulation->updatedSimulation]<>", if PolymeraseDegradation is True, PolymeraseDegradationTime, PolymeraseDegradationTemperature, and PolymeraseDegradationRampRate are specified; if PolymeraseDegradation is False, PolymeraseDegradationTime, PolymeraseDegradationTemperature, and PolymeraseDegradationRampRate are Null::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[polymeraseDegradationMismatchOptionsErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,polymeraseDegradationMismatchOptionsErrors,False],Simulation->updatedSimulation]<>", if PolymeraseDegradation is True, PolymeraseDegradationTime, PolymeraseDegradationTemperature, and PolymeraseDegradationRampRate are specified; if PolymeraseDegradation is False, PolymeraseDegradationTime, PolymeraseDegradationTemperature, and PolymeraseDegradationRampRate are Null::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- FORWARD PRIMER STORAGE CONDITION UNRESOLVABLE OPTION --*)
	(*If there are forwardPrimerStorageConditionErrors and we are throwing messages, then throw an error message*)
	invalidForwardPrimerStorageConditionOptions=If[MemberQ[forwardPrimerStorageConditionErrors,True]&&messages,
		(
			Message[Error::DigitalPCRForwardPrimerStorageConditionMismatch];
			{ForwardPrimerStorageCondition}
		),
		{}
	];

	(*If we are gathering tests, create a test for ForwardPrimerStorageCondition mismatch*)
	validForwardPrimerStorageConditionTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},
			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,forwardPrimerStorageConditionErrors];
			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,forwardPrimerStorageConditionErrors,False];
			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For samples "<>ObjectToString[failingSamples,Simulation->updatedSimulation]<>", the ForwardPrimerStorageCondition does not have conflicts with the input forward primers:",False,True],
				Nothing
			];
			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For samples "<>ObjectToString[passingSamples,Simulation->updatedSimulation]<>", the ForwardPrimerStorageCondition does not have conflicts with the input forward primers:",True,True],
				Nothing
			];
			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(*-- REVERSE PRIMER STORAGE CONDITION UNRESOLVABLE OPTION --*)
	(*If there are reversePrimerStorageConditionErrors and we are throwing messages, then throw an error message*)
	invalidReversePrimerStorageConditionOptions=If[MemberQ[reversePrimerStorageConditionErrors,True]&&messages,
		(
			Message[Error::DigitalPCRReversePrimerStorageConditionMismatch];
			{ReversePrimerStorageCondition}
		),
		{}
	];

	(*If we are gathering tests, create a test for ReversePrimerStorageCondition mismatch*)
	validReversePrimerStorageConditionTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},
			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,reversePrimerStorageConditionErrors];
			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,reversePrimerStorageConditionErrors,False];
			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For samples "<>ObjectToString[failingSamples,Simulation->updatedSimulation]<>", the ReversePrimerStorageCondition does not have conflicts with the input reverse primers:",False,True],
				Nothing
			];
			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For samples "<>ObjectToString[passingSamples,Simulation->updatedSimulation]<>", the ReversePrimerStorageCondition does not have conflicts with the input reverse primers:",True,True],
				Nothing
			];
			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(*-- PROBE STORAGE CONDITION UNRESOLVABLE OPTION --*)
	(*If there are probeStorageConditionErrors and we are throwing messages, then throw an error message*)
	invalidProbeStorageConditionOptions=If[MemberQ[probeStorageConditionErrors,True]&&messages,
		(
			Message[Error::DigitalPCRProbeStorageConditionMismatch];
			{ProbeStorageCondition}
		),
		{}
	];

	(*If we are gathering tests, create a test for ProbeStorageCondition mismatch*)
	validProbeStorageConditionTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},
			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,probeStorageConditionErrors];
			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,probeStorageConditionErrors,False];
			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For samples "<>ObjectToString[failingSamples,Simulation->updatedSimulation]<>", the ProbeStorageCondition does not have conflicts with the input probes:",False,True],
				Nothing
			];
			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For samples "<>ObjectToString[passingSamples,Simulation->updatedSimulation]<>", the ProbeStorageCondition does not have conflicts with the input probes:",True,True],
				Nothing
			];
			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(*-- REFERENCE FORWARD PRIMER STORAGE CONDITION UNRESOLVABLE OPTION --*)
	(*If there are referenceForwardPrimerStorageConditionErrors and we are throwing messages, then throw an error message*)
	invalidReferenceForwardPrimerStorageConditionOptions=If[MemberQ[referenceForwardPrimerStorageConditionErrors,True]&&messages,
		(
			Message[Error::DigitalPCRReferenceForwardPrimerStorageConditionMismatch];
			{ReferenceForwardPrimerStorageCondition}
		),
		{}
	];

	(*If we are gathering tests, create a test for ReferenceForwardPrimerStorageCondition mismatch*)
	validReferenceForwardPrimerStorageConditionTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},
			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,referenceForwardPrimerStorageConditionErrors];
			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,referenceForwardPrimerStorageConditionErrors,False];
			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For samples "<>ObjectToString[failingSamples,Simulation->updatedSimulation]<>", the ReferenceForwardPrimerStorageCondition does not have conflicts with the reference forward primers:",False,True],
				Nothing
			];
			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For samples "<>ObjectToString[passingSamples,Simulation->updatedSimulation]<>", the ReferenceForwardPrimerStorageCondition does not have conflicts with the input reference forward primers:",True,True],
				Nothing
			];
			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(*-- REFERENCE REVERSE PRIMER STORAGE CONDITION UNRESOLVABLE OPTION --*)
	(*If there are referenceReversePrimerStorageConditionErrors and we are throwing messages, then throw an error message*)
	invalidReferenceReversePrimerStorageConditionOptions=If[MemberQ[referenceReversePrimerStorageConditionErrors,True]&&messages,
		(
			Message[Error::DigitalPCRReferenceReversePrimerStorageConditionMismatch];
			{ReferenceReversePrimerStorageCondition}
		),
		{}
	];

	(*If we are gathering tests, create a test for ReferenceReversePrimerStorageCondition mismatch*)
	validReferenceReversePrimerStorageConditionTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},
			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,referenceReversePrimerStorageConditionErrors];
			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,referenceReversePrimerStorageConditionErrors,False];
			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For samples "<>ObjectToString[failingSamples,Simulation->updatedSimulation]<>", the ReferenceReversePrimerStorageCondition does not have conflicts with the reference reverse primers:",False,True],
				Nothing
			];
			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For samples "<>ObjectToString[passingSamples,Simulation->updatedSimulation]<>", the ReferenceReversePrimerStorageCondition does not have conflicts with the reference reverse primers:",True,True],
				Nothing
			];
			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(*-- REFERENCE PROBE STORAGE CONDITION UNRESOLVABLE OPTION --*)
	(*If there are referenceProbeStorageConditionErrors and we are throwing messages, then throw an error message*)
	invalidReferenceProbeStorageConditionOptions=If[MemberQ[referenceProbeStorageConditionErrors,True]&&messages,
		(
			Message[Error::DigitalPCRReferenceProbeStorageConditionMismatch];
			{ReferenceProbeStorageCondition}
		),
		{}
	];

	(*If we are gathering tests, create a test for ReferenceProbeStorageCondition mismatch*)
	validReferenceProbeStorageConditionTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},
			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,referenceProbeStorageConditionErrors];
			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,referenceProbeStorageConditionErrors,False];
			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For samples "<>ObjectToString[failingSamples,Simulation->updatedSimulation]<>", the ReferenceProbeStorageCondition does not have conflicts with the reference probes:",False,True],
				Nothing
			];
			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For samples "<>ObjectToString[passingSamples,Simulation->updatedSimulation]<>", the ReferenceProbeStorageCondition does not have conflicts with the reference probes:",True,True],
				Nothing
			];
			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(*-- MASTER MIX STORAGE CONDITION UNRESOLVABLE OPTION --*)
	(*If there are masterMixStorageConditionErrors and we are throwing messages, then throw an error message*)
	invalidMasterMixStorageConditionOptions=If[MemberQ[masterMixStorageConditionErrors,True]&&messages,
		(
			Message[Error::DigitalPCRMasterMixStorageConditionMismatch];
			{MasterMixStorageCondition}
		),
		{}
	];

	(*If we are gathering tests, create a test for ReferenceProbeStorageCondition mismatch*)
	validMasterMixStorageConditionTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},
			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,masterMixStorageConditionErrors];
			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,masterMixStorageConditionErrors,False];
			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For samples "<>ObjectToString[failingSamples,Simulation->updatedSimulation]<>", MasterMixStorageCondition is only specified when PreparedPlate is False:",False,True],
				Nothing
			];
			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For samples "<>ObjectToString[passingSamples,Simulation->updatedSimulation]<>", MasterMixStorageCondition is only specified when PreparedPlate is False:",True,True],
				Nothing
			];
			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(* INVALID OPTION LENGTHS FOR PRIMER/PROBE RELATED OPTIONS *)
	(* If there are any errors related to mismatched options, collect the invalid option names *)
	primerProbeOptionsLengthInvalidOptions=If[MemberQ[primerProbeOptionsLengthErrors,True],
		{PremixedPrimerProbe,ForwardPrimerConcentration,ForwardPrimerVolume,ReversePrimerConcentration,ReversePrimerVolume,ProbeConcentration,ProbeVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[primerProbeOptionsLengthErrors,True]&&messages,
		Message[Error::DigitalPCRPrimerProbeMismatchedOptionLengths,ObjectToString[PickList[simulatedSamples,primerProbeOptionsLengthErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	primerProbeOptionsLengthTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[primerProbeOptionsLengthErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,primerProbeOptionsLengthErrors],Simulation->updatedSimulation]<>", if primerPairs, probes, and related concentration and volume options are informed, they are the same length::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[primerProbeOptionsLengthErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,primerProbeOptionsLengthErrors,False],Simulation->updatedSimulation]<>", if primerPairs, probes, and related concentration and volume options are informed, they are the same length::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* If there are any errors related to mismatched options, collect the invalid option names *)
	referencePrimerProbeOptionsLengthInvalidOptions=If[MemberQ[referencePrimerProbeOptionsLengthErrors,True],
		{ReferencePremixedPrimerProbe,ReferenceForwardPrimerConcentration,ReferenceForwardPrimerVolume,ReferenceReversePrimerConcentration,ReferenceReversePrimerVolume,ReferenceProbeConcentration,ReferenceProbeVolume},
		{}
	];

	(* If we have any invalid option sets and we are throwing messages, throw an error message listing the affected objects.*)
	If[MemberQ[referencePrimerProbeOptionsLengthErrors,True]&&messages,
		Message[Error::DigitalPCRReferencePrimerProbeMismatchedOptionLengths,ObjectToString[PickList[simulatedSamples,referencePrimerProbeOptionsLengthErrors],Simulation->updatedSimulation]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	referencePrimerProbeOptionsLengthTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[referencePrimerProbeOptionsLengthErrors,True],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referencePrimerProbeOptionsLengthErrors],Simulation->updatedSimulation]<>", if ReferencePrimerPairs, ReferenceProbes, and related concentration and volume options are informed, they are the same length::",True,False],
				Nothing
			];
			passingTest=If[MemberQ[referencePrimerProbeOptionsLengthErrors,False],
				Test["For samples "<>ObjectToString[PickList[simulatedSamples,referencePrimerProbeOptionsLengthErrors,False],Simulation->updatedSimulation]<>", if  ReferencePrimerPairs, ReferenceProbes, and related concentration and volume options are informed, they are the same length::",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument *)
	{compatibleMaterialsBool,compatibleMaterialsTests}=If[gatherTests,
		CompatibleMaterialsQ[instrument,DeleteDuplicates[Flatten[Join[simulatedSamples,resolvedMasterMix]]],Output->{Result,Tests},Cache->inheritedCache, Simulation->updatedSimulation],
		{CompatibleMaterialsQ[instrument,DeleteDuplicates[Flatten[Join[simulatedSamples,resolvedMasterMix]]],Messages->messages,Cache->inheritedCache, Simulation->updatedSimulation],{}}
	];

	(*if the materials are incompatible, then the Instrument is invalid*)
	compatibleMaterialsInvalidOption=If[!compatibleMaterialsBool&&messages,
		{Instrument},
		{}
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{
		discardedInvalidInputs,
		deprecatedInvalidInputs,
		nullCompositionInvalidInputs,
		liquidStateInvalidInputs,
		singleFluorophorePerProbeInvalidInputs,
		preparedPlateInvalidInputs,
		inputSampleContainerInvalidInputs,
		noMultiplexAvailableInvalidInputs
	}]];
	invalidOptions=DeleteDuplicates[Flatten[{
		invalidNameOptions,
		singleFluorophorePerReferenceProbeInvalidOptions,
		amplitudeMultiplexingInvalidOptions,
		primerAnnealingMismatchInvalidOptions,
		primerGradientAnnealingMismatchInvalidOptions,
		primerGradientAnnealingRowTemperatureMismatchInvalidOptions,
		overConstrainedRowOptionsInvalidOptions,
		premixedPrimerProbeInvalidOptions,
		referencePremixedPrimerProbeInvalidOptions,
		probeStockConcentrationInvalidOptions,
		referenceProbeStockConcentrationInvalidOptions,
		probeConcentrationVolumeMismatchInvalidOptions,
		probeStockConcentrationTooLowInvalidOptions,
		referenceProbeConcentrationVolumeMismatchInvalidOptions,
		referenceProbeStockConcentrationTooLowInvalidOptions,
		forwardPrimerStockConcentrationInvalidOptions,
		forwardPrimerConcentrationVolumeMismatchInvalidOptions,
		forwardPrimerStockConcentrationTooLowInvalidOptions,
		reversePrimerStockConcentrationInvalidOptions,
		reversePrimerConcentrationVolumeMismatchInvalidOptions,
		reversePrimerStockConcentrationTooLowInvalidOptions,
		referenceForwardPrimerStockConcentrationInvalidOptions,
		referenceForwardPrimerConcentrationVolumeMismatchInvalidOptions,
		referenceForwardPrimerStockConcentrationTooLowInvalidOptions,
		referenceReversePrimerStockConcentrationInvalidOptions,
		referenceReversePrimerConcentrationVolumeMismatchInvalidOptions,
		referenceReversePrimerStockConcentrationTooLowInvalidOptions,
		diluentVolumeInvalidOptions, extensionMismatchInvalidOptions,
		polymeraseDegradationMismatchInvalidOptions,
		primerProbeOptionsLengthInvalidOptions,
		referencePrimerProbeOptionsLengthInvalidOptions,
		passiveWellsAssignmentInvalidOptions,
		activeWellInvalidOptions,
		tooManyPlatesInvalidOptions,
		thermocyclingOptionsMismatchInvalidOptions,
		preparedPlateInvalidOptions, probeFluorophoreNullInvalidOptions,
		probeFluorophoreIncompatibleInvalidOptions,
		probeFluorophoreLengthMismatchInvalidOptions,
		referenceProbeFluorophoreNullInvalidOptions,
		referenceProbeFluorophoreIncompatibleInvalidOptions,
		referenceProbeFluorophoreLengthMismatchInvalidOptions,
		reverseTranscriptionMismatchInvalidOptions,
		masterMixMismatchInvalidOptions,
		activationMismatchInvalidOptions,
		activeWellPreparedPlateInvalidOptions,
		totalVolumeInvalidOptions,
		diluentVolumeInvalidOptions,
		invalidProbeStorageConditionOptions,
		invalidForwardPrimerStorageConditionOptions,
		invalidReversePrimerStorageConditionOptions,
		invalidReferenceProbeStorageConditionOptions,
		invalidReferenceForwardPrimerStorageConditionOptions,
		invalidReferenceReversePrimerStorageConditionOptions,
		invalidMasterMixStorageConditionOptions,
		compatibleMaterialsInvalidOption,
		cartridgeLengthInvalidOptions,
		repeatedCartridgeInvalidOptions,
		preparedPlateCartridgeMismatchInvalidOptions,
		sampleDilutionMismatchInvalidOptions,
		sampleVolumeMismatchInvalidOptions,
		activeWellInvalidLengthOptions
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Simulation->updatedSimulation]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)

	(* Resolve RequiredAliquotContainers *)
	(* pre-resolve the Aliquot option in case we need to resolve a target container *)
	(* basically, is True if it is set to True or any of the aliquot options were set *)
	preResolvedAliquotBool = MapThread[
		Function[{aliquot, aliquotAmount, targetConc, assayVolume, aliquotContainer, destWell, concBuffer, bufferDilutionFactor, bufferDiluent, assayBuffer, aliquotStorage},
			Which[
				TrueQ[aliquot], True,
				MatchQ[aliquot, False], False,
				Or[
					MatchQ[aliquotAmount, MassP|VolumeP|NumericP],
					MatchQ[targetConc, ConcentrationP|MassConcentrationP],
					VolumeQ[assayVolume],
					Not[MatchQ[aliquotContainer, Automatic|{Automatic, Automatic}|Null|{Null, Null}]],
					MatchQ[destWell, WellP],
					MatchQ[concBuffer, ObjectP[]],
					MatchQ[bufferDilutionFactor, NumericP],
					MatchQ[bufferDiluent, ObjectP[]],
					MatchQ[assayBuffer, ObjectP[]],
					Not[MatchQ[aliquotStorage,Automatic | Null]]
				], True,
				True, False
			]
		],
		Lookup[myOptions, {Aliquot, AliquotAmount, TargetConcentration, AssayVolume, AliquotContainer, DestinationWell, ConcentratedBuffer, BufferDilutionFactor, BufferDiluent, AssayBuffer, AliquotSampleStorageCondition}]
	];

	(* we want to be aliquoting into a 0.5mL skirted tube if necessary *)
	targetContainers = MapThread[
		Function[{aliquotBool, aliquotContainer},
			Which[
				MatchQ[aliquotContainer, ObjectP[]], aliquotContainer,
				MatchQ[aliquotContainer, {_, ObjectP[]}], aliquotContainer[[2]],
				aliquotBool, Model[Container, Vessel, "0.5mL Tube with 2mL Tube Skirt"],
				True, Null
			]
		],
		{preResolvedAliquotBool, Lookup[myOptions, AliquotContainer]}
	];

	(* when we are aliquoting, get 10% more sample *)
	aliquotAmounts=MapThread[
		Function[{aliquotBool,singleSampleVolume},
			If[aliquotBool,
				singleSampleVolume*1.1,
				Null
			]
		],
		{preResolvedAliquotBool,resolvedSampleVolume}
	];

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentDigitalPCR,
			myListedSamples,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			Cache->inheritedCache,
			Simulation -> updatedSimulation,
			RequiredAliquotAmounts->aliquotAmounts,
			RequiredAliquotContainers->targetContainers,
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentDigitalPCR,
				myListedSamples,
				simulatedSamples,
				ReplaceRule[myOptions,resolvedSamplePrepOptions],
				Cache->inheritedCache,
				Simulation -> updatedSimulation,
				RequiredAliquotAmounts->aliquotAmounts,
				RequiredAliquotContainers->targetContainers,
				Output->Result],
			{}
		}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions,Sterile->True];

	(*Gather the resolved options (pre-collapsed; that is happening outside the function)*)
	resolvedOptions=ReplaceRule[Normal[roundedOptions],
		Flatten[{
			PreparedPlate->resolvedPreparedPlate,
			SampleVolume->resolvedSampleVolume,
			SerialDilutionCurve->resolvedSerialDilutionCurve,
			DilutionMixVolume->resolvedDilutionMixVolume,
			DilutionNumberOfMixes->resolvedDilutionNumberOfMixes,
			DilutionMixRate->resolvedDilutionMixRate,
			ProbeFluorophore->resolvedProbeFluorophore,
			ProbeExcitationWavelength->resolvedProbeExcitationWavelength,
			ProbeEmissionWavelength->resolvedProbeEmissionWavelength,
			ReferenceProbeFluorophore->resolvedReferenceProbeFluorophore,
			ReferenceProbeExcitationWavelength->resolvedReferenceProbeExcitationWavelength,
			ReferenceProbeEmissionWavelength->resolvedReferenceProbeEmissionWavelength,
			AmplitudeMultiplexing->resolvedAmplitudeMultiplexing,
			PremixedPrimerProbe->resolvedPremixedPrimerProbe,
			ReferencePremixedPrimerProbe->resolvedReferencePremixedPrimerProbe,
			ProbeConcentration->resolvedProbeConcentration,
			ProbeVolume->resolvedProbeVolume,
			ReferenceProbeConcentration->resolvedReferenceProbeConcentration,
			ReferenceProbeVolume->resolvedReferenceProbeVolume,
			ForwardPrimerConcentration->resolvedForwardPrimerConcentration,
			ForwardPrimerVolume->resolvedForwardPrimerVolume,
			ReversePrimerConcentration->resolvedReversePrimerConcentration,
			ReversePrimerVolume->resolvedReversePrimerVolume,
			ReferenceForwardPrimerConcentration->resolvedReferenceForwardPrimerConcentration,
			ReferenceForwardPrimerVolume->resolvedReferenceForwardPrimerVolume,
			ReferenceReversePrimerConcentration->resolvedReferenceReversePrimerConcentration,
			ReferenceReversePrimerVolume->resolvedReferenceReversePrimerVolume,
			ReverseTranscription->resolvedReverseTranscription,
			ReverseTranscriptionTime->resolvedReverseTranscriptionTime,
			ReverseTranscriptionTemperature->resolvedReverseTranscriptionTemperature,
			ReverseTranscriptionRampRate->resolvedReverseTranscriptionRampRate,
			MasterMix->resolvedMasterMix,
			MasterMixConcentrationFactor->resolvedMasterMixConcentrationFactor,
			MasterMixVolume->resolvedMasterMixVolume,
			DiluentVolume->resolvedDiluentVolume,
			Activation->resolvedActivation,
			ActivationTime->resolvedActivationTime,
			ActivationTemperature->resolvedActivationTemperature,
			ActivationRampRate->resolvedActivationRampRate,
			PrimerAnnealing->resolvedPrimerAnnealing,
			PrimerAnnealingTime->resolvedPrimerAnnealingTime,
			PrimerAnnealingTemperature->resolvedPrimerAnnealingTemperature,
			PrimerAnnealingRampRate->resolvedPrimerAnnealingRampRate,
			PrimerGradientAnnealing->resolvedPrimerGradientAnnealing,
			PrimerGradientAnnealingMinTemperature->resolvedPrimerGradientAnnealingMinTemperature,
			PrimerGradientAnnealingMaxTemperature->resolvedPrimerGradientAnnealingMaxTemperature,
			Extension->resolvedExtension,
			ExtensionTime->resolvedExtensionTime,
			ExtensionTemperature->resolvedExtensionTemperature,
			ExtensionRampRate->resolvedExtensionRampRate,
			PolymeraseDegradation->resolvedPolymeraseDegradation,
			PolymeraseDegradationTime->resolvedPolymeraseDegradationTime,
			PolymeraseDegradationTemperature->resolvedPolymeraseDegradationTemperature,
			PolymeraseDegradationRampRate->resolvedPolymeraseDegradationRampRate,
			ForwardPrimerStorageCondition->resolvedForwardPrimerStorageCondition,
			ReversePrimerStorageCondition->resolvedReversePrimerStorageCondition,
			ProbeStorageCondition->resolvedProbeStorageCondition,
			ReferenceForwardPrimerStorageCondition->resolvedReferenceForwardPrimerStorageCondition,
			ReferenceReversePrimerStorageCondition->resolvedReferenceReversePrimerStorageCondition,
			ReferenceProbeStorageCondition->resolvedReferenceProbeStorageCondition,
			MasterMixStorageCondition->resolvedMasterMixStorageCondition,
			(* When active well option length is correct, use the resolve value, otherwise throw back the specified value *)
			ActiveWell->If[activeWellOptionLengthCheck,resolvedActiveWell,specifiedActiveWell],
			PassiveWells->resolvedPassiveWells,
			PrimerGradientAnnealingRow->resolvedPrimerGradientAnnealingRow,
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions
		}]
	];

	(*Gather the tests*)
	allTests=Cases[Flatten[{
		samplePrepTests,
		discardedTest,
		deprecatedTest,
		initialOptionPrecisionTests,
		nestedOptionPrecisionTests,
		precisionTests,
		validNameTest,
		overConstrainedRowOptionsTest,
		primerGradientAnnealingRowTemperatureMismatchTest,
		primerAnnealingMismatchTest,
		primerGradientAnnealingMismatchTest,
		validForwardPrimerStorageConditionTest,
		validReversePrimerStorageConditionTest,
		validProbeStorageConditionTest,
		validReferenceForwardPrimerStorageConditionTest,
		validReferenceReversePrimerStorageConditionTest,
		validReferenceProbeStorageConditionTest,
		validMasterMixStorageConditionTest,
		singleFluorophorePerProbeTest,
		singleFluorophorePerReferenceProbeTest,
		amplitudeMultiplexingTest,
		premixedPrimerProbeTest,
		referencePremixedPrimerProbeTest,
		probeStockConcentrationTest,
		referenceProbeStockConcentrationTest,
		probeConcentrationVolumeMismatchOptionTest,
		probeStockConcentrationTooLowTest,
		referenceProbeConcentrationVolumeMismatchOptionTest,
		referenceProbeStockConcentrationTooLowTest,
		forwardPrimerStockConcentrationTest,
		forwardPrimerConcentrationVolumeMismatchOptionTest,
		forwardPrimerStockConcentrationTooLowTest,
		reversePrimerStockConcentrationTest,
		probeStockConcentrationAccuracyTest,
		referenceProbeStockConcentrationAccuracyTest,
		forwardPrimerStockConcentrationAccuracyTest,
		reversePrimerStockConcentrationAccuracyTest,
		referenceForwardPrimerStockConcentrationAccuracyTest,
		referenceReversePrimerStockConcentrationAccuracyTest,
		reversePrimerConcentrationVolumeMismatchOptionTest,
		reversePrimerStockConcentrationTooLowTest,
		referenceForwardPrimerStockConcentrationTest,
		referenceForwardPrimerConcentrationVolumeMismatchOptionTest,
		referenceForwardPrimerStockConcentrationTooLowTest,
		referenceReversePrimerStockConcentrationTest,
		referenceReversePrimerConcentrationVolumeMismatchOptionTest,
		referenceReversePrimerStockConcentrationTooLowTest,
		diluentVolumeTest,
		extensionMismatchTest,
		polymeraseDegradationMismatchTest,
		primerProbeOptionsLengthTest,
		referencePrimerProbeOptionsLengthTest,
		passiveWellsAssignmentCheckTest,
		activeWellPreparedPlateTest,
		activeWellTest,
		tooManyPlatesTest,
		thermocyclingOptionsMismatchTest,
		nullCompositionTest,
		preparedPlateTest,
		inputSampleContainerTest,
		tooManyTargetsMultiplexedTest,
		probeFluorophoreNullOptionsTest,
		probeFluorophoreIncompatibleTest,
		probeFluorophoreLengthMismatchTest,
		referenceProbeFluorophoreNullOptionsTest,
		referenceProbeFluorophoreIncompatibleTest,
		referenceProbeFluorophoreLengthMismatchTest,
		reverseTranscriptionMismatchTest,
		masterMixConcentrationFactorNotInformedTest,
		masterMixQuantityMismatchTest,
		masterMixMismatchTest,
		activationMismatchTest,
		aliquotTests,
		compatibleMaterialsTests,
		cartridgeLengthTest,
		repeatedCartridgeTest,
		preparedPlateCartridgeMismatchTest,
		noMultiplexAvailableTest,
		sampleDilutionMismatchTest,
		sampleVolumeMismatchTest,
		activeWellInvalidLengthTest
	}],_EmeraldTest];

	(*Generate the result output rule: if not returning result, result rule is just Null*)
	resultRule=Result->If[MemberQ[output,Result],
		resolvedOptions,
		Null
	];

	(*Generate the tests output rule*)
	testsRule=Tests->If[gatherTests,
		allTests,
		Null
	];

	(*Return the output as required*)
	outputSpecification/.{resultRule,testsRule}
];

(* ::Subsubsection::Closed:: *)
(* Private Helper Functions for resolveExperimentDigitalPCROptions *)


(* ::Subsubsubsection::Closed:: *)

(* Helper function for rounding nested options *)
DefineOptions[
	roundNestedOptions,
	Options :> {HelperOutputOption}
];

(* This function can be used for any options that are in the form of a list (e.g. index matched with samplesIn) or nested list. The input option with nested lists are flattened, processed with RoundOptionPrecision and the rounded values are unflattened to the original state before the output is returned *)

roundNestedOptions[myPrecisionAssociationInput_Association,myPrecisionInputKeys:{_Symbol..}, myPrecisions:{_Quantity..},
	myPrecisionOptions:OptionsPattern[roundNestedOptions]] :=
	Module[{precisionSafeOps,outputOps,inputValues,flatInputValues,flatInputAssociation,roundedInput,outputTests,roundedInputValues,nestedRoundedInputValues,roundedInputRules,inputRulesList,roundedInputRulesList,outputRulesList,outputAssociation},

		(* Get Output option if added as an input *)
		precisionSafeOps=SafeOptions[roundNestedOptions, ToList[myPrecisionOptions]];

		(* Get a list of values from input association *)
		inputValues=Lookup[myPrecisionAssociationInput,myPrecisionInputKeys];

		(* Take each association value and change it to a flat list to make it compatible with RoundOptionPrecision function *)
		flatInputValues=Map[
			Flatten[#] &,
			inputValues
		];

		(* Create a new association using keys from input and flattened values *)
		flatInputAssociation=AssociationThread[myPrecisionInputKeys, flatInputValues];

		(* Check output option if we are gathering tests *)
		outputOps=Lookup[precisionSafeOps,Output];

		(* Round all values using the framework function and collect tests if gathering tests *)
		{roundedInput,outputTests}=If[MemberQ[outputOps,Tests],
			RoundOptionPrecision[flatInputAssociation,myPrecisionInputKeys, myPrecisions,Output->outputOps],
			{RoundOptionPrecision[flatInputAssociation,myPrecisionInputKeys,myPrecisions],Null}
		];

		(* Get a list of values from the rounded association output *)
		roundedInputValues=Values[roundedInput];

		(* Regenerate the nesting for each association value to match the nesting of input values *)
		nestedRoundedInputValues=MapThread[
			Unflatten[#1, #2] &,
			{roundedInputValues, inputValues}
		];

		(* Rebuild association using the input keys and rounded values. *)
		roundedInputRules=AssociationThread[myPrecisionInputKeys, nestedRoundedInputValues];

		(* Convert associations to lists for use in ReplaceRule *)
		inputRulesList=Normal[myPrecisionAssociationInput];
		roundedInputRulesList=Normal[roundedInputRules];

		(* Replace values in input association with rounded nested values *)
		outputRulesList=Fold[
			ReplaceRule,
			inputRulesList,
			roundedInputRulesList
		];

		(* Convert list of rules to associations *)
		outputAssociation=Association@@outputRulesList;

		(* Output the new rounded association and any tests gathered *)
		{outputAssociation,outputTests}
	];


(* ::Subsubsection::Closed:: *)
(*experimentDigitalPCRResourcePackets*)


DefineOptions[experimentDigitalPCRResourcePackets,
	Options:>{
		CacheOption,
		HelperOutputOption,
		SimulationOption
	}
];


experimentDigitalPCRResourcePackets[
	mySamples:ListableP[ObjectP[Object[Sample]]],
	myPrimerPairSamples:ListableP[
		Alternatives[
			{{ObjectP[{Model[Sample],Object[Sample]}],ObjectP[{Model[Sample],Object[Sample]}]}..},
			{Null,Null}
		]
	],
	myProbeSamples:ListableP[
		Alternatives[
			{ObjectP[{Model[Sample],Object[Sample]}]..},
			Null
		]
	],
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	ops:OptionsPattern[experimentDigitalPCRResourcePackets]
]:=Module[
	{
		unresolvedOptionsNoHidden,resolvedOptionsNoHidden,sampleInputsWithDilutions,samplesInWithReplicates,expandedResolvedOptions,expandedMySamples,expandedMyPrimerSamples,expandedMyProbeSamples,
		outputSpecification,output,gatherTests,messages,inheritedCache,simulation,timeToHMSString,expandDilutionSeries,dropletCartridgeObjects,
		takeAllIndexLeavingNull,optionsSingletonMultiplex,singletonFieldsMasterSwitch,bufferResourceBuilder,uniqueOligomerResourceBuilder,
		initialLiquidHandlerContainers,rtMasterMixStockSolution,rtMasterMixPacket,reverseTranscriptionMasterMixModel,
		seriesSampleVolumes,seriesDiluentVolumes,serialDilutions,serialDilutionsWithReplicates,dilutionFactors,numberOfDilutionPlates,sampleDilutionPlateResource,dilutionCountNoStock,
		allDilutionVolumes,requiredSampleVolumes,dilutionSeriesDiluentVolumes,requiredDiluentVolumes,uniqueSampleResourceRules,
		forwardPrimersStructuredList,multiplexedForwardPrimers,
		forwardPrimerConcentrations,multiplexedForwardPrimerConcentrations,
		forwardPrimerVolumes,multiplexedForwardPrimerVolumes,
		forwardPrimerResources,flatMultiplexedForwardPrimerResources,
		reversePrimersStructuredList,multiplexedReversePrimers,
		reversePrimerConcentrations,multiplexedReversePrimerConcentrations,
		reversePrimerVolumes,multiplexedReversePrimerVolumes,
		reversePrimerResources,flatMultiplexedReversePrimerResources,
		probesStructuredList,multiplexedProbes,
		probeConcentrations,multiplexedProbeConcentrations,
		probeVolumes,multiplexedProbeVolumes,
		probeResources,flatMultiplexedProbeResources,
		probeFluorophores,multiplexedProbeFluorophores,
		probeExcitationWavelengths,multiplexedProbeExcitationWavelengths,
		probeEmissionWavelengths,multiplexedProbeEmissionWavelengths,
		premixedPrimerProbes,multiplexedPremixedPrimerProbes,
		referenceForwardPrimersStructuredList,multiplexedReferenceForwardPrimers,
		referenceForwardPrimerConcentrations,multiplexedReferenceForwardPrimerConcentrations,
		referenceForwardPrimerVolumes,multiplexedReferenceForwardPrimerVolumes,
		referenceForwardPrimerResources,
		flatMultiplexedReferenceForwardPrimerResources,
		referenceReversePrimersStructuredList,multiplexedReferenceReversePrimers,
		referenceReversePrimerConcentrations,multiplexedReferenceReversePrimerConcentrations,
		referenceReversePrimerVolumes,multiplexedReferenceReversePrimerVolumes,
		referenceReversePrimerResources,
		flatMultiplexedReferenceReversePrimerResources,
		referenceProbesStructuredList,multiplexedReferenceProbes,
		referenceProbeConcentrations,multiplexedReferenceProbeConcentrations,
		referenceProbeVolumes,multiplexedReferenceProbeVolumes,
		referenceProbeResources,flatMultiplexedReferenceProbeResources,
		referenceProbeFluorophores,multiplexedReferenceProbeFluorophores,
		referenceProbeExcitationWavelengths,multiplexedReferenceProbeExcitationWavelengths,
		referenceProbeEmissionWavelengths,multiplexedReferenceProbeEmissionWavelengths,
		referencePremixedPrimerProbes,multiplexedReferencePremixedPrimerProbes,
		masterMixResources,masterMixVolumes,diluentResources,totalPassiveBufferVolume,passiveWellBufferResource,passiveWellDiluentResource,
		assignedActiveWells,numberOfCartridges,dropletCartridgeResource,plateSealResource,sealingFoilResource,sampleMixingPlateResource,
		specifiedPlateSealer,plateSealerModel,plateSealerResource,plateSealAdapterResource,processingGroups,dropletGenerationTime,thermocyclingTime,readingWellsInLastPlate,dropletReadingTime,
		singletonPrimerProbeReplaceResourceRules,multiplexedPrimerProbeReplaceResourceRules,
		allContainersInObjects,samplesInResources,instrumentTime,instrumentResource,
		amplitudeMultiplex517nm,amplitudeMultiplex556nm,amplitudeMultiplex665nm,amplitudeMultiplex694nm,
		plateIndexList,thermocyclingOptionsPerPlate,reverseTranscriptionByPlate,reverseTranscriptionTimeByPlate,reverseTranscriptionTemperatureByPlate,reverseTranscriptionRampRateByPlate,
		activationByPlate,activationTimeByPlate,activationTemperatureByPlate,activationRampRateByPlate,
		denaturationTimeByPlate,denaturationTemperatureByPlate,denaturationRampRateByPlate,
		primerAnnealingByPlate,primerAnnealingTimeByPlate,primerAnnealingTemperatureByPlate,primerAnnealingRampRateByPlate,
		primerGradientAnnealingByPlate,primerGradientAnnealingMinTemperatureByPlate,primerGradientAnnealingMaxTemperatureByPlate,
		extensionByPlate,extensionTimeByPlate,extensionTemperatureByPlate,extensionRampRateByPlate,
		polymeraseDegradationByPlate,polymeraseDegradationTimeByPlate,polymeraseDegradationTemperatureByPlate,polymeraseDegradationRampRateByPlate,
		numberOfCyclesByPlate,sortedThermocyclingPerPlate,protocolPacket,sharedFieldPacket,finalizedPacket,
		allResourceBlobs,fulfillable,frqTests,previewRule,optionsRule,testsRule,resultRule,
		liquidHandlerContainers,containersInObjects
	},

	(*Get the collapsed unresolved index-matching options that don't include hidden options*)
	unresolvedOptionsNoHidden=RemoveHiddenOptions[ExperimentDigitalPCR,myUnresolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentDigitalPCR,
		RemoveHiddenOptions[ExperimentDigitalPCR,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Get the inherited cache *)
	inheritedCache=Lookup[ToList[ops],Cache];
	simulation =Lookup[ToList[ops],Simulation];

	(* -- Local Helpers --  *)
	(* Take [[All,All,<index>]] and output a list of objects *)
	takeAllIndexLeavingNull[input_,index_Integer]:=If[NullQ[input],
		Null,
		Download[input[[All,index]],Object]
	];

	(* Process concentration/volume options for singleton or multiplexed primers and probes *)
	optionsSingletonMultiplex[mySwitch:BooleanP,myOptionName_]:=If[mySwitch,
		{Flatten[Lookup[expandedResolvedOptions,myOptionName]],Null},
		{Null,Lookup[expandedResolvedOptions,myOptionName]}
	];

	(* get the reverse transcription master mix buffer model *)
	(* Download the object reference with ID of the recommended RT-ddPCR MasterMix model for use in helper functions *)
	reverseTranscriptionMasterMixModel=Download[Model[Sample,"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer"],Object];

	(* Helper function overload for Null inputs *)
	uniqueOligomerResourceBuilder[myOligomers:ListableP[Null],myVolumes:ListableP[Null]]:={};

	(* Helper function to create resources for a list of oligomers and volumes *)
	(*
	This function creates a resource for each unique primer/probe input object by adding up all the volumes of the repeated object in the input list.
	This ensures that a single resource with a combined volume will be picked when an object is requested multiple times and resource picking and sample prep time.
	 *)
	(* Inputs: flat list of objects, flat list of volumes *)
	(* Output: Rules list in the format object->resource *)
	uniqueOligomerResourceBuilder[myOligomersWithReplicates_List,myVolumes_List]:=Module[
		{oligomerVolumeRules,uniqueOligomerVolumeRules},
		(* Create rules matching object to its volume *)
		oligomerVolumeRules=MapThread[
			If[NullQ[#1],
				Nothing,
				#1->#2]&,
			{myOligomersWithReplicates,myVolumes}
		];

		(* Merge to get a list of only unique sample objects and their total volumes *)
		uniqueOligomerVolumeRules=Merge[oligomerVolumeRules,Total];

		(* Create resources for the unique sample objects in the form of rules, so objects in original list can be replace with their respective resource *)
		KeyValueMap[
			Function[{sample,volume},
				If[EqualQ[volume,0*Microliter],
					Nothing,
					sample->Resource[
						Sample->sample,
						Name->ToString[Unique[]],
						(* Get 10*Microliter extra volume to account for dead volume *)
						Container->Lookup[Select[liquidHandlerContainers,Lookup[#,MaxVolume]>=Plus[volume,10*Microliter]&],Object],
						(* Get 10*Microliter extra volume to account for dead volume *)
						Amount->Plus[volume,10*Microliter]
					]
				]
			],
			uniqueOligomerVolumeRules
		]
	];

	(* Helper function to generate resources for mastermix and diluent *)
	(*
	This function creates a resource for each unique object by adding up all the volumes of the repeated object in an input list.
	It then replaces repeated objects in the original list with the related resource.
	This way, a single resource with a combined volume will be picked when an object is requested multiple times and resource picking and sample prep time.
	 *)
	(* function overload that takes Inputs: Option symbol for objects, Option symbol for volumes *)
	(* Inputs: Option symbol for objects, Option symbol for volumes *)
	bufferResourceBuilder[bufferOptionName_Symbol,volumeOptionName_Symbol]:=bufferResourceBuilder[
		bufferOptionName,
		Lookup[expandedResolvedOptions,volumeOptionName]
	];

	(* main function that takes Inputs: Option symbol for objects, list of volumes *)
	(* Output: List of resources *)
	bufferResourceBuilder[bufferOptionName_Symbol,volumeList_List]:=Module[
		{optionSamplesWithReplicates,optionSampleVolumeRules,uniqueSampleVolumeRules,uniqueSampleResourceReplaceRules,uniqueSampleResourceReplaceRulesWithNullRule},
		(* Get a list of samples with potentially repeated objects *)
		optionSamplesWithReplicates=Download[Lookup[expandedResolvedOptions,bufferOptionName],Object];

		(* Create rules matching object to its volume *)
		optionSampleVolumeRules=MapThread[
			If[NullQ[#2],
				#1->0*Microliter,
				#1->#2]&,
			{optionSamplesWithReplicates,volumeList}
		];

		(* Merge to get a list of only unique sample objects and their total volumes *)
		uniqueSampleVolumeRules=Merge[optionSampleVolumeRules,Total];

		(* Create resources for the unique sample objects in the form of rules, so objects in original list can be replace with their respective resource *)
		uniqueSampleResourceReplaceRules=KeyValueMap[
			Function[{sample,volume},
				Module[{bufferSample,bufferVolume},

					(*
						When the reverse transcription buffer is provided as MasterMix input:
							1. replace it with Model[Sample,StockSolution,"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, 2x Master Mix"]
							2. pick an increment above the required volume
					*)

					(* model/object of buffer to be resource picked *)
					bufferSample=If[MatchQ[Download[sample,Object],reverseTranscriptionMasterMixModel],
						Lookup[rtMasterMixPacket,Object],
						sample
					];

					(* volume of buffer to be resource picked *)
					bufferVolume=If[MatchQ[Download[sample,Object],reverseTranscriptionMasterMixModel],
						(* For master mix that has to be a certain volume, select the smallest increment that is larger than the request + dead volume *)
						SelectFirst[
							Lookup[rtMasterMixPacket,VolumeIncrements],
							PositiveQuantityQ[(#-(volume+5Microliter)*1.2)]&
						],
						(* Add 20 Microliter extra to all other buffers to account for dead volume or add 20% extra for larger volume requests. Note each sample automatically has 5 uL added to it, for Robotic transfer OverAspirationVolume and other pipetting settings *)
						Max[{volume+20*Microliter,(volume+5Microliter)*1.2}]
					];

					(* build resource *)
					If[EqualQ[volume,0*Microliter],
						Nothing,
						sample->Resource[
							Sample->bufferSample,
							Name->ToString[Unique[]],
							Container->Lookup[Select[liquidHandlerContainers,Lookup[#,MaxVolume]>=bufferVolume&],Object],
							Amount->bufferVolume
						]
					]
				]
			],
			uniqueSampleVolumeRules
		];

		(* Add a rule to convert any models that do not need to be resource picked to Null *)
		uniqueSampleResourceReplaceRulesWithNullRule=Append[uniqueSampleResourceReplaceRules,ObjectP[Model[Sample]]->Null];

		(* Use replace to convert sample models/objects list to sample resource list *)
		Replace[optionSamplesWithReplicates,uniqueSampleResourceReplaceRulesWithNullRule,{1}]
	];

	(* Helper function to convert time from a single unit to a string with HH:MM:SS format *)
	timeToHMSString[myTimeList_List]:=Module[
		{
			mixedUnitTimes,
			hourList,
			minuteList,
			secondList,
			hourStringList,
			minuteStringList,
			secondStringList
		},

		(* Convert units of time into MixedUnit; Treat Null as 0*Second *)
		mixedUnitTimes=UnitConvert[myTimeList/.{Null->0*Second},MixedUnit[{"Hour","Minute","Second"}]];

		(* Extract hours, minutes and seconds *)
		hourList=(Extract[1]@@#)&/@Unitless[mixedUnitTimes];
		minuteList=(Extract[2]@@#)&/@Unitless[mixedUnitTimes];
		secondList=(Extract[3]@@#)&/@Unitless[mixedUnitTimes];

		(* Convert values to strings and add 0 in front if the value is a single digit *)
		hourStringList=If[#<10,"0"<>ToString[#],ToString[#]]&/@hourList;
		minuteStringList=If[#<10,"0"<>ToString[#],ToString[#]]&/@minuteList;
		secondStringList=If[#<10,"0"<>ToString[#],ToString[#]]&/@secondList;

		(* Generate a list of time strings *)
		MapThread[
			Function[{singleHour,singleMinute,singleSecond},
				If[MatchQ[singleHour,"00"],
					singleMinute<>":"<>singleSecond,
					singleHour<>":"<>singleMinute<>":"<>singleSecond
				]
			],
			{hourStringList,minuteStringList,secondStringList}
		]
	];

	(* Helper function: expands inputs and index matched options according to resolved dilution series options. *)
	(* Assumes the myOptions is already expanded and that the only index-matching of inputs is to the samples. *)
	expandDilutionSeries[myFunction_Symbol,myInputSamples_List,myInputOptions_List]:=Module[
		{transposeSwitch,transposedSamples,serialDilutionCurveValues,numberOfDilutions,numberOfReplicates,allExpansionsCount,optionDefinitions,expandedOptions,optionDefinition,inputMatchedBoolean,expandedTransposedSamples,expandedSamples},

		(* When mySamples is a list of multiple inputs, transpose it so it can be handled in the same way as single input list *)
		{transposedSamples,transposeSwitch}=If[MatchQ[myInputSamples,{_List..}],
			(* transpose input to go from {{input1..},{input2..},...} to {{input1, input2,...}..} & set transposeSwitch to True *)
			{Transpose[myInputSamples],True},
			(* for single inputs, return the same input & set transposeSwitch to False *)
			{myInputSamples,False}
		];

		(* Get the dilution series option from all samples. *)
		serialDilutionCurveValues=Lookup[myInputOptions,SerialDilutionCurve,1];

		(* Figure out the number of dilutions based on serial dilution curve values. *)
		numberOfDilutions=Map[
			Switch[#,
				{VolumeP,VolumeP,NumericP},Last[#]+1,
				{VolumeP,{NumericP,GreaterP[1,1]}},#[[2,2]]+1,
				{VolumeP,{NumericP..}},Length[Last[#]]+1,
				Null,1
			]&,
			serialDilutionCurveValues
		];

		(* Get the number of replicates specified *)
		numberOfReplicates=Lookup[myInputOptions,NumberOfReplicates]/.{Null->1};

		(* Total number of expansions per input sample *)
		allExpansionsCount=numberOfDilutions*numberOfReplicates;

		(* Get option definitions for myFunction *)
		optionDefinitions=OptionDefinition[myFunction];

		(* Expand options *)
		expandedOptions=Map[
			Function[{option},
				(*Figure out if this option is index-matching to the input.*)
				optionDefinition=SelectFirst[optionDefinitions,MatchQ[#["OptionSymbol"],option[[1]]]&];
				inputMatchedBoolean=MatchQ[Lookup[optionDefinition,"IndexMatchingInput"],_String];
				(*If our option is index matched to the input (assume it's the samples),then expand them.*)
				(* AliquotSampleLabel,AliquotContainer,DestinationWell are already expanded by resolveAliquotOptions *)
				If[inputMatchedBoolean && Not[MemberQ[{AliquotSampleLabel,AliquotContainer,DestinationWell},option[[1]]]],
					option[[1]]->MapThread[
						(* change the way it resolve because when aliquot options are resolved sometimes it is not a single variable,
						but list, and that breaks mapthread. So I wrap a list and then unwrap it by flatten for just 1 layer *)
						Sequence@@ConstantArray[#1,#2]&,
						(*(Sequence @@ Flatten[ConstantArray[#1,#2],1]&),*)
						{option[[2]],allExpansionsCount}
						(*{{option[[2]]},allExpansionsCount}*)
					],
					option
				]
			],
			myInputOptions
		];


		(* Expand samples *)
		expandedTransposedSamples=MapThread[
			(Sequence@@ConstantArray[#1,#2]&),
			{transposedSamples,allExpansionsCount}
		];

		(* Re-transpose samples in cases of multiple sample inputs before returning output *)
		expandedSamples=If[transposeSwitch,
			Transpose[expandedTransposedSamples],
			expandedTransposedSamples
		];

		(* Return our expanded samples and options. *)
		{expandedSamples,expandedOptions}
	];


	(* --- Make our one big Download call --- *)
	{
		initialLiquidHandlerContainers,
		rtMasterMixStockSolution
	}=Quiet[
		Download[
			{
				hamiltonAliquotContainers["Memoization"],
				{Model[Sample,StockSolution,"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, 2x Master Mix"]}
			},
			{
				{Packet[MaxVolume,NumberOfWells]},
				{Packet[VolumeIncrements]}
			},
			Cache->inheritedCache,
			Simulation -> simulation
		],
		{Download::FieldDoesntExist}
	];

	liquidHandlerContainers=Flatten[initialLiquidHandlerContainers];
	rtMasterMixPacket=First[First[rtMasterMixStockSolution]];

	(* --- Expand sample inputs and options according to dilution series specifications --- *)
	{sampleInputsWithDilutions,expandedResolvedOptions}=expandDilutionSeries[
		ExperimentDigitalPCR,
		{mySamples,myPrimerPairSamples,myProbeSamples},
		myResolvedOptions
	];

	(* -- Break up expanded inputs into samples, primers and probes -- *)
	{expandedMySamples,expandedMyPrimerSamples,expandedMyProbeSamples}=sampleInputsWithDilutions;

	(* --- Make all the resources needed in the experiment --- *)

	(* -- Generate lists for sample dilution fields in protocol -- *)
	(* Calculate the transfer/diluent volumes for sample dilution *)
	allDilutionVolumes=dilutionTransferVolumes[#]&/@Lookup[myResolvedOptions,SerialDilutionCurve];

	seriesSampleVolumes=allDilutionVolumes[[All,1]];
	seriesDiluentVolumes=allDilutionVolumes[[All,2]];

	(* Volumes of sample transfers and diluent transfer *)
	serialDilutions=Transpose[{
		Flatten[seriesSampleVolumes],
		Flatten[seriesDiluentVolumes]
	}];

	(* Expand serialDilutions to include replicates *)
	serialDilutionsWithReplicates=Module[{numberOfReplicates},
		(* Get the number of replicates from resolved options *)
		numberOfReplicates=Lookup[myResolvedOptions,NumberOfReplicates]/.{Null->1};

		(* Expand serialDilutions to match the future length of AssaySamples *)
		Map[
			(Sequence@@ConstantArray[#,numberOfReplicates]&),
			serialDilutions
		]
	];

	(* Dilution factor calculations *)
	dilutionFactors=If[NullQ[#],
		1.0,
		SafeRound[First[#]/Total[#],0.01]
	]&/@serialDilutionsWithReplicates;

	(* Number of dilutions to generate for each sample - excluding stock sample *)
	dilutionCountNoStock=Map[
		Switch[#,
			{VolumeP,VolumeP,NumericP},Last[#],
			{VolumeP,{NumericP,GreaterP[1,1]}},#[[2,2]],
			{VolumeP,{NumericP..}},Length[Last[#]],
			Null,0
		]&,
		Lookup[myResolvedOptions,SerialDilutionCurve]
	];

	(* -- Generate resources for the SamplesIn -- *)
	(* Create a list of required sample resource volume to account for dilution series and number of replicates *)
	(* NOTE: This is different from SampleVolume, because in case of a dilution series,
	more sample will be required so that the dilution series can be performed for the samples are used.
	SampleVolume is amount that will be used after dilution series is generated, while the AliquotAmount
	will be taken before serial dilution, so the AliquotAmount must be enough to perform dilution and checked in resolver *)
	requiredSampleVolumes=MapThread[
		Function[{mySampleVolume,myAliquotAmount,mySerialSampleVolume},
			Which[
				(* when aliquot amount is given, use it as required resource volume *)
				MatchQ[myAliquotAmount,Except[Null]],myAliquotAmount*(Lookup[myResolvedOptions,NumberOfReplicates]/.{Null->1}),
				(* when serial dilution volume not Null, use the first value in the series as it is the require stock sample volume *)
				MatchQ[mySerialSampleVolume,Except[NullP]],First[mySerialSampleVolume],
				(* Default to resource pick sample volume when nothing else is true *)
				True,mySampleVolume*(Lookup[myResolvedOptions,NumberOfReplicates]/.{Null->1})
			]
		],
		Join[Lookup[myResolvedOptions,{SampleVolume,AliquotAmount}],{seriesSampleVolumes}]
	];

	(* Build resources for unique sample resources and create a rules list *)
	uniqueSampleResourceRules=uniqueOligomerResourceBuilder[
		If[MatchQ[mySerialSampleVolume,Except[NullP]],
			(* Use unexpanded samples to create resources when doing dilution *)
			Download[mySamples,Object],
			(* Use expanded samples to create resources when not doing dilution *)
			Download[expandedMySamples,Object]
		],
		requiredSampleVolumes
	];

	(* SamplesIn will only be expanded by the number of replicates *)
	samplesInWithReplicates=Flatten[
		Map[
		ConstantArray[#,(Lookup[myResolvedOptions,NumberOfReplicates]/.{Null->1})]&,
			mySamples
		]
	];

	(* replace SamplesIn with generated resource blobs *)
	samplesInResources=Replace[
		Download[
			samplesInWithReplicates,
			Object
		],
		uniqueSampleResourceRules,
		{1}
	];

	(* -- Singleton primer and probe master switch -- *)
	(* Use master switch to determine if singleton vs multiplexing fields will be used for primers/probes *)
	(* Check that all probe inputs and reference probe option inputs are single objects per sample *)
	(* Also check that all fluorophore, excitation and emission wavelength options are single items per sample *)
	(* When master switch is True, use singleton protocol fields; when false, use multiplexed protocol fields *)
	singletonFieldsMasterSwitch=Apply[And,
		If[NullQ[Lookup[expandedResolvedOptions,ReferenceProbes]],
			(* When ReferenceProbes are not supplied, check if all probe inputs have single items *)
			MatchQ[If[NullQ[#],1,Length[#]],1]&/@Join[expandedMyProbeSamples,Flatten[Lookup[expandedResolvedOptions,{ProbeFluorophore,ProbeExcitationWavelength,ProbeEmissionWavelength}],1]],
			(* When probes and ReferenceProbes are specified, check that all probe/reference inputs have single items *)
			MatchQ[If[NullQ[#],1,Length[#]],1]&/@Join[expandedMyProbeSamples,Flatten[Lookup[expandedResolvedOptions,{ProbeFluorophore,ProbeExcitationWavelength,ProbeEmissionWavelength,ReferenceProbes}],1]]
		]
	];

	(* -- Forward Primer Objects and Properties -- *)
	(* Take the forward primers from the primer pair input *)
	{forwardPrimersStructuredList,multiplexedForwardPrimers}=If[singletonFieldsMasterSwitch,
		(* When using singleton fields, multiplex fields are Null *)
		{takeAllIndexLeavingNull[#,1]&/@expandedMyPrimerSamples,Null},
		(* When not using singleton fields, singleton fields are Null *)
		{Null,takeAllIndexLeavingNull[#,1]&/@expandedMyPrimerSamples}
	];

	(* Singleton vs multiplexing concentrations *)
	{
		forwardPrimerConcentrations,
		multiplexedForwardPrimerConcentrations
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ForwardPrimerConcentration];

	(* Singleton vs multiplexing volumes *)
	{
		forwardPrimerVolumes,
		multiplexedForwardPrimerVolumes
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ForwardPrimerVolume];

	(* -- Reverse Primer Objects and Properties -- *)
	(* Take the reverse primers from the primer pair input *)
	{reversePrimersStructuredList,multiplexedReversePrimers}=If[singletonFieldsMasterSwitch,
		(* When using singleton fields, multiplex fields are Null *)
		{takeAllIndexLeavingNull[#,2]&/@expandedMyPrimerSamples,Null},
		(* When not using singleton fields, singleton fields are Null *)
		{Null,takeAllIndexLeavingNull[#,2]&/@expandedMyPrimerSamples}
	];

	(* Singleton vs multiplexing concentrations *)
	{
		reversePrimerConcentrations,
		multiplexedReversePrimerConcentrations
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ReversePrimerConcentration];

	(* Singleton vs multiplexing volumes *)
	{
		reversePrimerVolumes,
		multiplexedReversePrimerVolumes
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ReversePrimerVolume];

	(* -- Probe Objects and Properties -- *)
	(* Assign probes list to singleton vs multiplexing variable *)
	{probesStructuredList,multiplexedProbes}=If[singletonFieldsMasterSwitch,
		(* When using singleton fields, multiplex fields are Null *)
		{If[NullQ[#],Null,Download[#,Object]]&/@expandedMyProbeSamples,Null},
		(* When not using singleton fields, singleton fields are Null *)
		{Null,If[NullQ[#],Null,Download[#,Object]]&/@expandedMyProbeSamples}
	];

	(* Singleton vs multiplexing concentrations *)
	{
		probeConcentrations,
		multiplexedProbeConcentrations
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ProbeConcentration];

	(* Singleton vs multiplexing volumes *)
	{
		probeVolumes,
		multiplexedProbeVolumes
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ProbeVolume];

	(* Singleton vs multiplexing probe molecules *)
	{
		probeFluorophores,
		multiplexedProbeFluorophores
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ProbeFluorophore];

	(* Singleton vs multiplexing probe excitation wavelengths *)
	{
		probeExcitationWavelengths,
		multiplexedProbeExcitationWavelengths
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ProbeExcitationWavelength];

	(* Singleton vs multiplexing probe emission wavelengths *)
	{
		probeEmissionWavelengths,
		multiplexedProbeEmissionWavelengths
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ProbeEmissionWavelength];

	(* Singleton vs multiplexing assay type *)
	{
		premixedPrimerProbes,
		multiplexedPremixedPrimerProbes
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,PremixedPrimerProbe];

	(* -- Reference Forward Primer Objects and Properties -- *)
	(* Take the forward primers from the reference primer pair input *)
	{
		referenceForwardPrimersStructuredList,
		multiplexedReferenceForwardPrimers
	}=If[singletonFieldsMasterSwitch,
		(* When using singleton fields, multiplex fields are Null *)
		{If[NullQ[#],Null,takeAllIndexLeavingNull[#,1]]&/@Lookup[expandedResolvedOptions,ReferencePrimerPairs],Null},
		(* When not using singleton fields, singleton fields are Null *)
		{Null,If[NullQ[#],Null,takeAllIndexLeavingNull[#,1]]&/@Lookup[expandedResolvedOptions,ReferencePrimerPairs]}
	];

	(* Singleton vs multiplexing concentrations *)
	{
		referenceForwardPrimerConcentrations,
		multiplexedReferenceForwardPrimerConcentrations
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ReferenceForwardPrimerConcentration];

	(* Singleton vs multiplexing volumes *)
	{
		referenceForwardPrimerVolumes,
		multiplexedReferenceForwardPrimerVolumes
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ReferenceForwardPrimerVolume];

	(* -- Reference Reverse Primer Objects and Properties -- *)
	(* Take the reverse primers from the reference primer pair input *)
	{
		referenceReversePrimersStructuredList,
		multiplexedReferenceReversePrimers
	}=If[singletonFieldsMasterSwitch,
		(* When using singleton fields, multiplex fields are Null *)
		{If[NullQ[#],Null,takeAllIndexLeavingNull[#,2]]&/@Lookup[expandedResolvedOptions,ReferencePrimerPairs],Null},
		(* When not using singleton fields, singleton fields are Null *)
		{Null,If[NullQ[#],Null,takeAllIndexLeavingNull[#,2]]&/@Lookup[expandedResolvedOptions,ReferencePrimerPairs]}
	];

	(* Singleton vs multiplexing concentrations *)
	{
		referenceReversePrimerConcentrations,
		multiplexedReferenceReversePrimerConcentrations
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ReferenceReversePrimerConcentration];

	(* Singleton vs multiplexing volumes *)
	{
		referenceReversePrimerVolumes,
		multiplexedReferenceReversePrimerVolumes
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ReferenceReversePrimerVolume];

	(* -- Reference Probe Objects and Properties -- *)
	(* Assign reference probes list to singleton vs multiplexing variable *)
	{referenceProbesStructuredList,multiplexedReferenceProbes}=If[singletonFieldsMasterSwitch,
		(* When using singleton fields, multiplex fields are Null *)
		{If[NullQ[#],Null,Download[#,Object]]&/@Lookup[expandedResolvedOptions,ReferenceProbes],Null},
		(* When not using singleton fields, singleton fields are Null *)
		{Null,If[NullQ[#],Null,Download[#,Object]]&/@Lookup[expandedResolvedOptions,ReferenceProbes]}
	];

	(* Singleton vs multiplexing concentrations *)
	{
		referenceProbeConcentrations,
		multiplexedReferenceProbeConcentrations
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ReferenceProbeConcentration];

	(* Singleton vs multiplexing volumes *)
	{
		referenceProbeVolumes,
		multiplexedReferenceProbeVolumes
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ReferenceProbeVolume];

	(* Singleton vs multiplexing reference probe molecules *)
	{
		referenceProbeFluorophores,
		multiplexedReferenceProbeFluorophores
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ReferenceProbeFluorophore];

	(* Singleton vs multiplexing reference probe excitation wavelengths *)
	{
		referenceProbeExcitationWavelengths,
		multiplexedReferenceProbeExcitationWavelengths
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ReferenceProbeExcitationWavelength];

	(* Singleton vs multiplexing reference probe emission wavelengths *)
	{
		referenceProbeEmissionWavelengths,
		multiplexedReferenceProbeEmissionWavelengths
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ReferenceProbeEmissionWavelength];

	(* Singleton vs multiplexing reference assay type *)
	{
		referencePremixedPrimerProbes,
		multiplexedReferencePremixedPrimerProbes
	}=optionsSingletonMultiplex[singletonFieldsMasterSwitch,ReferencePremixedPrimerProbe];

	(* Build resources for unique objects among all primers and probes - Singleton Case *)
	singletonPrimerProbeReplaceResourceRules=uniqueOligomerResourceBuilder[
		Flatten[{
			forwardPrimersStructuredList,
			reversePrimersStructuredList,
			probesStructuredList,
			referenceForwardPrimersStructuredList,
			referenceReversePrimersStructuredList,
			referenceProbesStructuredList
		}],
		Flatten[{
			forwardPrimerVolumes,
			reversePrimerVolumes,
			probeVolumes,
			referenceForwardPrimerVolumes,
			referenceReversePrimerVolumes,
			referenceProbeVolumes
		}]
	];

	(* Generate forward primer resources by replacing objects with their resource; duplicate objects will have the same resource *)
	forwardPrimerResources=Replace[Flatten[{forwardPrimersStructuredList}],singletonPrimerProbeReplaceResourceRules,{1}];

	(* Generate reverse primer resources by replacing objects with their resource; duplicate objects will have the same resource *)
	reversePrimerResources=Replace[Flatten[{reversePrimersStructuredList}],singletonPrimerProbeReplaceResourceRules,{1}];

	(* Generate probe resources by replacing objects with their resource; duplicate objects will have the same resource *)
	probeResources=Replace[Flatten[{probesStructuredList}],singletonPrimerProbeReplaceResourceRules,{1}];

	(* Generate reference forward primer resources by replacing objects with their resource; duplicate objects will have the same resource *)
	referenceForwardPrimerResources=Replace[Flatten[{referenceForwardPrimersStructuredList}],singletonPrimerProbeReplaceResourceRules,{1}];

	(* Generate reference reverse primer resources by replacing objects with their resource; duplicate objects will have the same resource *)
	referenceReversePrimerResources=Replace[Flatten[{referenceReversePrimersStructuredList}],singletonPrimerProbeReplaceResourceRules,{1}];

	(* Generate reference probe resources by replacing objects with their resource; duplicate objects will have the same resource *)
	referenceProbeResources=Replace[Flatten[{referenceProbesStructuredList}],singletonPrimerProbeReplaceResourceRules,{1}];


	(* Build resources for unique objects among all primers and probes - Multiplexed Case *)
	multiplexedPrimerProbeReplaceResourceRules=uniqueOligomerResourceBuilder[
		Flatten[{
			multiplexedForwardPrimers,
			multiplexedReversePrimers,
			multiplexedProbes,
			multiplexedReferenceForwardPrimers,
			multiplexedReferenceReversePrimers,
			multiplexedReferenceProbes
		}],
		Flatten[{
			multiplexedForwardPrimerVolumes,
			multiplexedReversePrimerVolumes,
			multiplexedProbeVolumes,
			multiplexedReferenceForwardPrimerVolumes,
			multiplexedReferenceReversePrimerVolumes,
			multiplexedReferenceProbeVolumes
		}]
	];

	(* Generate forward primer resources by replacing objects with their resource; duplicate objects will have the same resource *)
	flatMultiplexedForwardPrimerResources=Replace[Flatten[{multiplexedForwardPrimers}],multiplexedPrimerProbeReplaceResourceRules,{1}];

	(* Generate reverse primer resources by replacing objects with their resource; duplicate objects will have the same resource *)
	flatMultiplexedReversePrimerResources=Replace[Flatten[{multiplexedReversePrimers}],multiplexedPrimerProbeReplaceResourceRules,{1}];

	(* Generate probe resources by replacing objects with their resource; duplicate objects will have the same resource *)
	flatMultiplexedProbeResources=Replace[Flatten[{multiplexedProbes}],multiplexedPrimerProbeReplaceResourceRules,{1}];

	(* Generate reference forward primer resources by replacing objects with their resource; duplicate objects will have the same resource *)
	flatMultiplexedReferenceForwardPrimerResources=Replace[Flatten[{multiplexedReferenceForwardPrimers}],multiplexedPrimerProbeReplaceResourceRules,{1}];

	(* Generate reference reverse primer resources by replacing objects with their resource; duplicate objects will have the same resource *)
	flatMultiplexedReferenceReversePrimerResources=Replace[Flatten[{multiplexedReferenceReversePrimers}],multiplexedPrimerProbeReplaceResourceRules,{1}];

	(* Generate reference probe resources by replacing objects with their resource; duplicate objects will have the same resource *)
	flatMultiplexedReferenceProbeResources=Replace[Flatten[{multiplexedReferenceProbes}],multiplexedPrimerProbeReplaceResourceRules,{1}];


	(* -- Generate master mix resources -- *)
	masterMixResources=bufferResourceBuilder[MasterMix,MasterMixVolume];

	(* - When reverse transcription buffer is used as master mix and resource picked as stock solution with enzyme and dtt, its volume must be doubled - *)
	masterMixVolumes=Module[{masterMixList,masterMixVolumeList},

		(* get the list of resolved master mixes *)
		masterMixList=Lookup[expandedResolvedOptions,MasterMix];

		(* get the list of resolved volumes *)
		masterMixVolumeList=Lookup[expandedResolvedOptions,MasterMixVolume];

		MapThread[
			Function[{singleMasterMix,singleMasterMixVolume},
				If[MatchQ[Download[singleMasterMix,Object],reverseTranscriptionMasterMixModel],
					singleMasterMixVolume*2,
					singleMasterMixVolume
				]
			],
			{masterMixList,masterMixVolumeList}
		]
	];

	(* -- Generate diluent resources -- *)
	(* When sample serial dilution is performed, more diluent will be needed for each sample and it must be added accordingly *)
	dilutionSeriesDiluentVolumes=serialDilutionsWithReplicates[[All,2]]/.{Null->0*Microliter};

	(* requiredDiluentVolume = DiluentVolume + diluent volume added to sample *)
	requiredDiluentVolumes=(Lookup[expandedResolvedOptions,DiluentVolume]/.{Null->0*Microliter})+dilutionSeriesDiluentVolumes;

	(* build resources *)
	diluentResources=bufferResourceBuilder[Diluent,requiredDiluentVolumes];

	(* -- Generate passive well buffer resources -- *)
	totalPassiveBufferVolume=If[MatchQ[Lookup[expandedResolvedOptions,PassiveWells],None],
		0 Microliter,
		(* Adding 20 microliter to account for dead volume; 2x buffer will be diluted with additional diluent *)
		SafeRound[Plus[Length[Lookup[expandedResolvedOptions,PassiveWells]]*30*Microliter,20*Microliter]/2,10^-1 Microliter]
	];

	passiveWellBufferResource=If[(!Lookup[myResolvedOptions,PreparedPlate])&&totalPassiveBufferVolume>0*Microliter,
		Resource[
			Sample->Download[Lookup[expandedResolvedOptions,PassiveWellBuffer],Object],
			Name->ToString[Unique[]],
			Container->Lookup[Select[liquidHandlerContainers,Lookup[#,MaxVolume]>=totalPassiveBufferVolume&],Object],
			Amount->totalPassiveBufferVolume
		]
	];

	(* -- Generate diluent resource for passive well buffer dilution -- *)
	passiveWellDiluentResource=If[(!Lookup[myResolvedOptions,PreparedPlate])&&totalPassiveBufferVolume>0*Microliter,
		Resource[
			Sample->Model[Sample,"Milli-Q water"],
			Name->ToString[Unique[]],
			Container->Lookup[Select[liquidHandlerContainers,Lookup[#,MaxVolume]>=totalPassiveBufferVolume&],Object],
			Amount->totalPassiveBufferVolume
		]
	];

	(* -- Generate droplet cartridge resources -- *)
	assignedActiveWells=Lookup[expandedResolvedOptions,ActiveWell];

	numberOfCartridges=If[MatchQ[assignedActiveWells,{WellP..}],
		1,
		Max[assignedActiveWells[[All,1]]]
	];

	(* When plate is already prepared, no resource needs to be created and the containers of input sample will be used for dropletCartridgeResource *)
	(* - Extract the container objects from the downloaded cache. Resources should not be created for the containers in - *)
	allContainersInObjects=Download[mySamples,Container[Object],Cache->inheritedCache,Simulation->simulation];

	containersInObjects=If[Lookup[myResolvedOptions,PreparedPlate],
		Module[{containersInObjectsWithIndex,containersInObjectsSorted},
			(* Delete duplicates and then sort the plates by plate index input in active wells if multiple plates are in use *)
			containersInObjectsWithIndex=If[MatchQ[assignedActiveWells,{WellP..}],
				List[Join[{1},DeleteDuplicates[allContainersInObjects]]],
				DeleteDuplicatesBy[Transpose[{assignedActiveWells[[All,1]],allContainersInObjects}],Last]
			];
			containersInObjectsSorted=SortBy[containersInObjectsWithIndex,First];
			containersInObjectsSorted[[All,2]]
		],
		DeleteDuplicates[allContainersInObjects]
	];

	(* Create droplet cartridge resource *)
	(* Get the option value; May be a list of specific cartridge objects or a singleton Model, both of which need to be handled differently when creating resource blobs *)
	dropletCartridgeObjects=Lookup[myResolvedOptions,DropletCartridge];

	dropletCartridgeResource=If[Lookup[myResolvedOptions,PreparedPlate],
		(* When plate is already prepared, use containersInObjects *)
		containersInObjects,
		(* Create resources for droplet cartridges when prepared plate is not used *)
		If[MatchQ[dropletCartridgeObjects,ObjectP[Model[Container,Plate,DropletCartridge]]],
			(* For a singleton model input, create resources with Model *)
			Table[Resource[Sample->dropletCartridgeObjects,Name->ToString[Unique[]]],numberOfCartridges],
			(* For a list of specific objects, map over the list *)
			(Resource[Sample->#,Name->ToString[Unique[]]])&/@dropletCartridgeObjects
		]
	];

	(* -- Generate sealing foil resources for droplet cartridges -- *)
	sealingFoilResource=Table[Resource[Sample->Lookup[myResolvedOptions,PlateSealFoil],Name->ToString[Unique[]]],numberOfCartridges];

	(* -- Sample mixing plate resources -- *)
	sampleMixingPlateResource=If[Lookup[myResolvedOptions,PreparedPlate],
		(* No sample mixing to be done if plate is already prepared *)
		Null,
		(* Create resources for liquid handler compatible mixing plates when plate is not prepared *)
		Table[Resource[Sample->Model[Container, Plate,"96-well PCR Plate"],Name->ToString[Unique[]]],numberOfCartridges]
	];

	(* -- Generate resources for sample dilution plate(s) -- *)
	(* If dilution is to be done, determine how many plates are needed *)
	numberOfDilutionPlates=If[Or[Lookup[myResolvedOptions,PreparedPlate],!MemberQ[Lookup[myResolvedOptions,SampleDilution],True]],
		0,
		Module[{dilutionSampleTally},
			(* calculate the number of dilution samples *)
			dilutionSampleTally=Length[
				Flatten[
					PickList[seriesSampleVolumes,Lookup[myResolvedOptions,SampleDilution]]
				]
			];

			(* output the number of 96-well plates required *)
			Divide[
				(* round up to the next nearest 96 well increment *)
				Ceiling[dilutionSampleTally,96],
				96
			]
		]
	];

	(* build resources *)
	sampleDilutionPlateResource=If[EqualQ[numberOfDilutionPlates,0],
		(* No sample dilution to be done *)
		Null,
		(* Create resources for liquid handler compatible mixing plates when plate is not prepared *)
		Table[Resource[Sample->Model[Container,Plate,"96-well PCR Plate"],Name->ToString[Unique[]]],numberOfDilutionPlates]
	];

	(* -- Generate plate sealer instrument resource -- *)
	specifiedPlateSealer=Download[Lookup[myResolvedOptions,PlateSealInstrument],Object];

	plateSealerResource=Resource[
		Instrument->specifiedPlateSealer,
		Name->ToString[Unique[]],
		Time->Times[Lookup[myResolvedOptions,PlateSealTime],numberOfCartridges]
	];

	(* - Generate plate sealer adapter resource - *)
	(* get the model for plate sealer option value *)
	plateSealerModel=If[MatchQ[specifiedPlateSealer,ObjectReferenceP[Model[Instrument,PlateSealer]]],
		specifiedPlateSealer,
		Download[specifiedPlateSealer,Model,Cache->inheritedCache,Simulation->simulation]
	];

	(* build adapter resource if the model matches Bio-Rad PX1*)
	plateSealAdapterResource=If[MatchQ[plateSealerModel,ObjectP[Model[Instrument,PlateSealer,"id:AEqRl9KEXbkd"]]],
		(* If the plate sealer matches the model for Bio-Rad PX1, generate this adapter resource *)
		Resource[Sample->Model[Container,Rack,"PX1 sealer adapter for GCR96 droplet cartridge"],Name->ToString[Unique[]]]
	];

	(* -- Generate instrument resources -- *)
	(* Time to generate droplets - only needed for the first plate as remaining plates run in parallel *)
	processingGroups=If[MatchQ[assignedActiveWells,{WellP..}],
		Length[
			Partition[
				assignedActiveWells,
				UpTo[16]
			]
		],
		Length[
			Partition[
				Select[
					assignedActiveWells,
					EqualQ[First[#],1]&
				],
				UpTo[16]
			]
		]
	];

	(* Get thermocycling values for each droplet cartridge - protocol fields used by procedure *)
	(* Generate a list of plate indices from assignedActiveWells *)
	plateIndexList=If[MatchQ[assignedActiveWells,{WellP..}],
		Table[1,Length[assignedActiveWells]],
		assignedActiveWells[[All,1]]
	];

	(* Get all the thermocycling option values for the place indices and collect thermocycling data for only the unique plates *)
	thermocyclingOptionsPerPlate=DeleteDuplicatesBy[
		Transpose[
			Prepend[
				Lookup[
					expandedResolvedOptions,
					{
						ReverseTranscription,
						ReverseTranscriptionTime,
						ReverseTranscriptionTemperature,
						ReverseTranscriptionRampRate,

						Activation,
						ActivationTime,
						ActivationTemperature,
						ActivationRampRate,

						DenaturationTime,
						DenaturationTemperature,
						DenaturationRampRate,

						PrimerAnnealing,
						PrimerAnnealingTime,
						PrimerAnnealingTemperature,
						PrimerAnnealingRampRate,

						PrimerGradientAnnealing,
						PrimerGradientAnnealingMinTemperature,
						PrimerGradientAnnealingMaxTemperature,

						Extension,
						ExtensionTime,
						ExtensionTemperature,
						ExtensionRampRate,

						PolymeraseDegradation,
						PolymeraseDegradationTime,
						PolymeraseDegradationTemperature,
						PolymeraseDegradationRampRate,

						NumberOfCycles
					}
				],
				plateIndexList
			]
		],
		First
	];

	sortedThermocyclingPerPlate=SortBy[thermocyclingOptionsPerPlate,First];

	(* Break values out into individual variables *)
	{
		reverseTranscriptionByPlate,
		reverseTranscriptionTimeByPlate,
		reverseTranscriptionTemperatureByPlate,
		reverseTranscriptionRampRateByPlate,

		activationByPlate,
		activationTimeByPlate,
		activationTemperatureByPlate,
		activationRampRateByPlate,

		denaturationTimeByPlate,
		denaturationTemperatureByPlate,
		denaturationRampRateByPlate,

		primerAnnealingByPlate,
		primerAnnealingTimeByPlate,
		primerAnnealingTemperatureByPlate,
		primerAnnealingRampRateByPlate,

		primerGradientAnnealingByPlate,
		primerGradientAnnealingMinTemperatureByPlate,
		primerGradientAnnealingMaxTemperatureByPlate,

		extensionByPlate,
		extensionTimeByPlate,
		extensionTemperatureByPlate,
		extensionRampRateByPlate,

		polymeraseDegradationByPlate,
		polymeraseDegradationTimeByPlate,
		polymeraseDegradationTemperatureByPlate,
		polymeraseDegradationRampRateByPlate,

		numberOfCyclesByPlate
	}=Transpose[Rest/@sortedThermocyclingPerPlate];

	(* Each processing group requires 3.5 minutes to process *)
	dropletGenerationTime=processingGroups*20*Minute;

	(* Time to run thermocycling protocol *)
	thermocyclingTime=120*Minute;(*Module[
		{
			plateIndexList,
			thermocyclingOptionsPerPlate,
			reverseTranscriptionTime,
			activationTime,
			denaturationTime,
			primerAnnealingTime,
			primerAnnealingRampTime,
			extensionTime,
			polymeraseDegradationTime,
			timePerPlate
		},

		(* Generate a list of plate indices from assignedActiveWells *)
		plateIndexList=If[MatchQ[assignedActiveWells,{WellP..}],
			Table[1,Length[assignedActiveWells]],
			assignedActiveWells[[All,1]]
		];

		(* Get all the thermocycling option values for the place indices and collect thermocycling data for only the unique plates *)
		thermocyclingOptionsPerPlate=DeleteDuplicatesBy[
			Transpose[
				Append[
					Lookup[
						myResolvedOptions,
						{
							ReverseTranscription,
							ReverseTranscriptionTime,
							ReverseTranscriptionTemperature,
							ReverseTranscriptionRampRate,

							Activation,
							ActivationTime,
							ActivationTemperature,
							ActivationRampRate,

							DenaturationTime,
							DenaturationTemperature,
							DenaturationRampRate,

							PrimerAnnealing,
							PrimerGradientAnnealing,
							PrimerAnnealingTime,
							PrimerAnnealingTemperature,
							PrimerAnnealingRampRate,

							Extension,
							ExtensionTime,
							ExtensionTemperature,
							ExtensionRampRate,

							PolymeraseDegradation,
							PolymeraseDegradationTime,
							PolymeraseDegradationTemperature,
							PolymeraseDegradationRampRate,

							NumberOfCycles
						}
					],
					plateIndexList
				]
			],
			Last
		];

		(* Need to do something about Null values *)
		reverseTranscriptionTime=Map[
			Function[{singlePlateThermocycling},
				If[singlePlateThermocycling[[1]],
					((singlePlateThermocycling[[3]]-25*Celsius)*singlePlateThermocycling[[4]])+singlePlateThermocycling[[2]],
					0 Second
				]
			],
			thermocyclingOptionsPerPlate
		];

		activationTime=Map[
			Function[{singlePlateThermocycling},
				Module[{lastTemperature},
					lastTemperature=If[singlePlateThermocycling[[1]],singlePlateThermocycling[[3]],25*Celsius];
					If[singlePlateThermocycling[[5]],
						(Abs[singlePlateThermocycling[[7]]-lastTemperature]*singlePlateThermocycling[[8]])+singlePlateThermocycling[[6]],
						0 Second
					]
				]
			],
			thermocyclingOptionsPerPlate
		];
		denaturationTime=((Abs[#[[8]]-#[[5]]]/#[[9]])+#[[7]])&/@thermocyclingOptionsPerPlate;
		primerAnnealingTime=#[[10]]/@thermocyclingOptionsPerPlate;
		primerAnnealingRampTime=(Abs[#[[11]]-#[[8]]]/#[[12]])&/@thermocyclingOptionsPerPlate;
		extensionTime=((Abs[#[[14]]-#[[11]]]/#[[15]])+#[[13]])&/@thermocyclingOptionsPerPlate;
		polymeraseDegradationTime=((Abs[#[[17]]-#[[14]]]/#[[18]])+#[[16]])&/@thermocyclingOptionsPerPlate;
		timePerPlate=Plus[
			reverseTranscriptionTime,
			activationTime,
			Times[denaturationTime,thermocyclingOptionsPerPlate[[All,19]]],
			Times[primerAnnealingTime,thermocyclingOptionsPerPlate[[All,19]]],
			Times[primerAnnealingRampTime,thermocyclingOptionsPerPlate[[All,19]]],
			Times[extensionTime,thermocyclingOptionsPerPlate[[All,19]]],
			polymeraseDegradationTime
		];
		Total[timePerPlate];
	];*)

	(* Time to read droplets - only needed for the last plate as other plates are read in parallel with thermocycling *)
	readingWellsInLastPlate=If[MatchQ[assignedActiveWells,{WellP..}],
		Length[assignedActiveWells],
		Length[
			Select[
				assignedActiveWells,
				EqualQ[First[#],Max[assignedActiveWells[[All,1]]]]&
			]
		]
	];

	(* Each well requires 2.5 minutes to process *)
	dropletReadingTime=readingWellsInLastPlate*2.5*Minute;

	(* Total instrument run time is the sum of droplet generation, thermocycling and droplet reading *)
	instrumentTime=Total[{dropletGenerationTime,thermocyclingTime,dropletReadingTime,30*Minute}];

	(* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
		this will probably look like set-up time + time/sample + tear-down time *)
	instrumentResource=Resource[Instrument->Lookup[myResolvedOptions,Instrument],Time->instrumentTime,Name->ToString[Unique[]]];

	(* -- Amplitude multiplexing -- *)
	amplitudeMultiplex517nm=Map[
		If[NullQ[#],Null,#[[1,2]]]&,
		Lookup[expandedResolvedOptions,AmplitudeMultiplexing]
	];

	amplitudeMultiplex556nm=Map[
		If[NullQ[#],Null,#[[2,2]]]&,
		Lookup[expandedResolvedOptions,AmplitudeMultiplexing]
	];

	amplitudeMultiplex665nm=Map[
		If[NullQ[#],Null,#[[3,2]]]&,
		Lookup[expandedResolvedOptions,AmplitudeMultiplexing]
	];

	amplitudeMultiplex694nm=Map[
		If[NullQ[#],Null,#[[4,2]]]&,
		Lookup[expandedResolvedOptions,AmplitudeMultiplexing]
	];

	(* --- Generate the protocol packet --- *)
	protocolPacket=<|
		Object->CreateID[Object[Protocol,DigitalPCR]],
		Type->Object[Protocol,DigitalPCR],
		Replace[SamplesIn]->Map[Link[#,Protocols]&,samplesInResources],
		Replace[ContainersIn]->Map[Link[Resource[Sample->#],Protocols]&,containersInObjects],
		UnresolvedOptions->unresolvedOptionsNoHidden,
		ResolvedOptions->resolvedOptionsNoHidden,
		RunTime->instrumentTime,
		Instrument->Link[instrumentResource],
		DropletGeneratorOil->Link[Lookup[myResolvedOptions,DropletGeneratorOil]],
		DropletReaderOil->Link[Lookup[myResolvedOptions,DropletReaderOil]],
		PreparedPlate->Lookup[myResolvedOptions,PreparedPlate],
		Replace[SampleDilutionPlates]->Link/@sampleDilutionPlateResource,
		Replace[SampleMixingPlates]->Link/@sampleMixingPlateResource,

		(* Amplitude Multiplexing *)
		Replace[AmplitudeMultiplex517nm]->amplitudeMultiplex517nm,
		Replace[AmplitudeMultiplex556nm]->amplitudeMultiplex556nm,
		Replace[AmplitudeMultiplex665nm]->amplitudeMultiplex665nm,
		Replace[AmplitudeMultiplex694nm]->amplitudeMultiplex694nm,

		(* Sample Dilution *)
		Replace[NumberOfDilutions]->Flatten[ConstantArray[#,(Lookup[myResolvedOptions,NumberOfReplicates]/.{Null->1})]&/@dilutionCountNoStock],
		Replace[AssaySamples]->ConstantArray[Null,Length[Lookup[expandedResolvedOptions,SampleVolume]]],
		Replace[SerialDilutions]->serialDilutionsWithReplicates,
		Replace[DilutionFactors]->dilutionFactors,
		Replace[DilutionMixRates]->Lookup[expandedResolvedOptions,DilutionMixRate],
		Replace[DilutionMixVolumes]->Lookup[expandedResolvedOptions,DilutionMixVolume],
		Replace[DilutionNumberOfMixes]->Lookup[expandedResolvedOptions,DilutionNumberOfMixes],

		(* Sample Preparation *)
		Replace[SampleVolumes]->Lookup[expandedResolvedOptions,SampleVolume],

		Replace[PremixedPrimerProbes]->premixedPrimerProbes,
		Replace[ForwardPrimers]->If[MatchQ[forwardPrimerResources,{Null}],Null,Link/@forwardPrimerResources],
		Replace[ForwardPrimerConcentrations]->forwardPrimerConcentrations,
		Replace[ForwardPrimerVolumes]->forwardPrimerVolumes,
		Replace[ReversePrimers]->If[MatchQ[reversePrimerResources,{Null}],Null,Link/@reversePrimerResources],
		Replace[ReversePrimerConcentrations]->reversePrimerConcentrations,
		Replace[ReversePrimerVolumes]->reversePrimerVolumes,
		Replace[Probes]->If[MatchQ[probeResources,{Null}],Null,Link/@probeResources],
		Replace[ProbeConcentrations]->probeConcentrations,
		Replace[ProbeVolumes]->probeVolumes,

		Replace[ReferencePremixedPrimerProbes]->referencePremixedPrimerProbes,
		Replace[ReferenceForwardPrimers]->If[MatchQ[referenceForwardPrimerResources,{Null}],Null,Link/@referenceForwardPrimerResources],
		Replace[ReferenceForwardPrimerConcentrations]->referenceForwardPrimerConcentrations,
		Replace[ReferenceForwardPrimerVolumes]->referenceForwardPrimerVolumes,
		Replace[ReferenceReversePrimers]->If[MatchQ[referenceReversePrimerResources,{Null}],Null,Link/@referenceReversePrimerResources],
		Replace[ReferenceReversePrimerConcentrations]->referenceReversePrimerConcentrations,
		Replace[ReferenceReversePrimerVolumes]->referenceReversePrimerVolumes,
		Replace[ReferenceProbes]->If[MatchQ[referenceProbeResources,{Null}],Null,Link/@referenceProbeResources],
		Replace[ReferenceProbeConcentrations]->referenceProbeConcentrations,
		Replace[ReferenceProbeVolumes]->referenceProbeVolumes,

		Replace[MultiplexedPremixedPrimerProbes]->multiplexedPremixedPrimerProbes,
		Replace[MultiplexedForwardPrimers]->Link/@multiplexedForwardPrimers,
		Replace[MultiplexedForwardPrimerResources]->Link/@flatMultiplexedForwardPrimerResources,
		Replace[MultiplexedForwardPrimerConcentrations]->multiplexedForwardPrimerConcentrations,
		Replace[MultiplexedForwardPrimerVolumes]->multiplexedForwardPrimerVolumes,
		Replace[MultiplexedReversePrimers]->Link/@multiplexedReversePrimers,
		Replace[MultiplexedReversePrimerResources]->Link/@flatMultiplexedReversePrimerResources,
		Replace[MultiplexedReversePrimerConcentrations]->multiplexedReversePrimerConcentrations,
		Replace[MultiplexedReversePrimerVolumes]->multiplexedReversePrimerVolumes,
		Replace[MultiplexedProbes]->Link/@multiplexedProbes,
		Replace[MultiplexedProbeResources]->Link/@flatMultiplexedProbeResources,
		Replace[MultiplexedProbeConcentrations]->multiplexedProbeConcentrations,
		Replace[MultiplexedProbeVolumes]->multiplexedProbeVolumes,

		Replace[MultiplexedReferencePremixedPrimerProbes]->multiplexedReferencePremixedPrimerProbes,
		Replace[MultiplexedReferenceForwardPrimers]->Link/@multiplexedReferenceForwardPrimers,
		Replace[MultiplexedReferenceForwardPrimerResources]->Link/@flatMultiplexedReferenceForwardPrimerResources,
		Replace[MultiplexedReferenceForwardPrimerConcentrations]->multiplexedReferenceForwardPrimerConcentrations,
		Replace[MultiplexedReferenceForwardPrimerVolumes]->multiplexedReferenceForwardPrimerVolumes,
		Replace[MultiplexedReferenceReversePrimers]->Link/@multiplexedReferenceReversePrimers,
		Replace[MultiplexedReferenceReversePrimerResources]->Link/@flatMultiplexedReferenceReversePrimerResources,
		Replace[MultiplexedReferenceReversePrimerConcentrations]->multiplexedReferenceReversePrimerConcentrations,
		Replace[MultiplexedReferenceReversePrimerVolumes]->multiplexedReferenceReversePrimerVolumes,
		Replace[MultiplexedReferenceProbes]->Link/@multiplexedReferenceProbes,
		Replace[MultiplexedReferenceProbeResources]->Link/@flatMultiplexedReferenceProbeResources,
		Replace[MultiplexedReferenceProbeConcentrations]->multiplexedReferenceProbeConcentrations,
		Replace[MultiplexedReferenceProbeVolumes]->multiplexedReferenceProbeVolumes,

		Replace[MasterMixes]->Link/@masterMixResources,
		Replace[MasterMixConcentrationFactors]->Lookup[expandedResolvedOptions,MasterMixConcentrationFactor],
		Replace[MasterMixVolumes]->masterMixVolumes,

		Replace[Diluents]->Link/@diluentResources,
		Replace[DiluentVolumes]->Lookup[expandedResolvedOptions,DiluentVolume],
		Replace[ReactionVolumes]->Lookup[expandedResolvedOptions,ReactionVolume],

		Replace[DropletCartridges]->Link/@dropletCartridgeResource,
		LoadingVolume->21*Microliter,

		Replace[ActiveWells]->Lookup[expandedResolvedOptions,ActiveWell],

		Replace[PassiveWells]->Lookup[expandedResolvedOptions,PassiveWells],
		PassiveWellBuffer->Link[passiveWellBufferResource],
		PassiveWellBufferDiluent->Link[passiveWellDiluentResource],

		(* Storage conditions *)
		Replace[ForwardPrimerStorageConditions]->Lookup[expandedResolvedOptions,ForwardPrimerStorageCondition],
		Replace[ReversePrimerStorageConditions]->Lookup[expandedResolvedOptions,ReversePrimerStorageCondition],
		Replace[ProbeStorageConditions]->Lookup[expandedResolvedOptions,ProbeStorageCondition],
		Replace[ReferenceForwardPrimerStorageConditions]->Lookup[expandedResolvedOptions,ReferenceForwardPrimerStorageCondition],
		Replace[ReferenceReversePrimerStorageConditions]->Lookup[expandedResolvedOptions,ReferenceReversePrimerStorageCondition],
		Replace[ReferenceProbeStorageConditions]->Lookup[expandedResolvedOptions,ReferenceProbeStorageCondition],
		Replace[MasterMixStorageConditions]->Lookup[expandedResolvedOptions,MasterMixStorageCondition],

		(* Plate Sealing *)
		PlateSealInstrument->Link[plateSealerResource],
		PlateSealAdapter->Link[plateSealAdapterResource],
		Replace[PlateSealFoils]->Link/@sealingFoilResource,
		PlateSealTemperature->Lookup[expandedResolvedOptions,PlateSealTemperature],
		PlateSealTime->Lookup[expandedResolvedOptions,PlateSealTime],

		(* Thermocycling fields matched to SamplesIn *)
		Replace[ReverseTranscriptionTimes]->Lookup[expandedResolvedOptions,ReverseTranscriptionTime],
		Replace[ReverseTranscriptionTemperatures]->Lookup[expandedResolvedOptions,ReverseTranscriptionTemperature],
		Replace[ReverseTranscriptionRampRates]->Lookup[expandedResolvedOptions,ReverseTranscriptionRampRate],

		Replace[ActivationTimes]->Lookup[expandedResolvedOptions,ActivationTime],
		Replace[ActivationTemperatures]->Lookup[expandedResolvedOptions,ActivationTemperature],
		Replace[ActivationRampRates]->Lookup[expandedResolvedOptions,ActivationRampRate],

		Replace[DenaturationTimes]->Lookup[expandedResolvedOptions,DenaturationTime],
		Replace[DenaturationTemperatures]->Lookup[expandedResolvedOptions,DenaturationTemperature],
		Replace[DenaturationRampRates]->Lookup[expandedResolvedOptions,DenaturationRampRate],

		Replace[PrimerAnnealingTimes]->Lookup[expandedResolvedOptions,PrimerAnnealingTime],
		Replace[PrimerAnnealingTemperatures]->Lookup[expandedResolvedOptions,PrimerAnnealingTemperature],
		Replace[PrimerAnnealingRampRates]->Lookup[expandedResolvedOptions,PrimerAnnealingRampRate],

		Replace[PrimerGradientAnnealingMinTemperatures]->Lookup[expandedResolvedOptions,PrimerGradientAnnealingMinTemperature],
		Replace[PrimerGradientAnnealingMaxTemperatures]->Lookup[expandedResolvedOptions,PrimerGradientAnnealingMaxTemperature],
		Replace[PrimerGradientAnnealingRows]->(If[NullQ[#],{Null,Null},#]&)/@Lookup[expandedResolvedOptions,PrimerGradientAnnealingRow],

		Replace[ExtensionTimes]->Lookup[expandedResolvedOptions,ExtensionTime],
		Replace[ExtensionTemperatures]->Lookup[expandedResolvedOptions,ExtensionTemperature],
		Replace[ExtensionRampRates]->Lookup[expandedResolvedOptions,ExtensionRampRate],

		Replace[PolymeraseDegradationTimes]->Lookup[expandedResolvedOptions,PolymeraseDegradationTime],
		Replace[PolymeraseDegradationTemperatures]->Lookup[expandedResolvedOptions,PolymeraseDegradationTemperature],
		Replace[PolymeraseDegradationRampRates]->Lookup[expandedResolvedOptions,PolymeraseDegradationRampRate],

		Replace[NumberOfCycles]->Lookup[expandedResolvedOptions,NumberOfCycles],

		(* Thermocycling fields matched to droplet cartridges for procedure *)
		Replace[CartridgeReverseTranscriptionTimes]->reverseTranscriptionTimeByPlate,
		Replace[CartridgeReverseTranscriptionTimeStrings]->timeToHMSString[reverseTranscriptionTimeByPlate],
		Replace[CartridgeReverseTranscriptionTemperatures]->reverseTranscriptionTemperatureByPlate,
		Replace[CartridgeReverseTranscriptionRampRates]->reverseTranscriptionRampRateByPlate,

		Replace[CartridgeActivationTimes]->activationTimeByPlate,
		Replace[CartridgeActivationTimeStrings]->timeToHMSString[activationTimeByPlate],
		Replace[CartridgeActivationTemperatures]->activationTemperatureByPlate,
		Replace[CartridgeActivationRampRates]->activationRampRateByPlate,

		Replace[CartridgeDenaturationTimes]->denaturationTimeByPlate,
		Replace[CartridgeDenaturationTimeStrings]->timeToHMSString[denaturationTimeByPlate],
		Replace[CartridgeDenaturationTemperatures]->denaturationTemperatureByPlate,
		Replace[CartridgeDenaturationRampRates]->denaturationRampRateByPlate,

		Replace[CartridgePrimerAnnealingTimes]->primerAnnealingTimeByPlate,
		Replace[CartridgePrimerAnnealingTimeStrings]->timeToHMSString[primerAnnealingTimeByPlate],
		Replace[CartridgePrimerAnnealingTemperatures]->primerAnnealingTemperatureByPlate,
		Replace[CartridgePrimerAnnealingRampRates]->primerAnnealingRampRateByPlate,

		Replace[CartridgePrimerGradientAnnealingMinTemperatures]->primerGradientAnnealingMinTemperatureByPlate,
		Replace[CartridgePrimerGradientAnnealingRanges]->(primerGradientAnnealingMaxTemperatureByPlate-primerGradientAnnealingMinTemperatureByPlate)/.{0->Null},

		Replace[CartridgeExtensionTimes]->extensionTimeByPlate,
		Replace[CartridgeExtensionTimeStrings]->timeToHMSString[extensionTimeByPlate],
		Replace[CartridgeExtensionTemperatures]->extensionTemperatureByPlate,
		Replace[CartridgeExtensionRampRates]->extensionRampRateByPlate,

		Replace[CartridgePolymeraseDegradationTimes]->polymeraseDegradationTimeByPlate,
		Replace[CartridgePolymeraseDegradationTimeStrings]->timeToHMSString[polymeraseDegradationTimeByPlate],
		Replace[CartridgePolymeraseDegradationTemperatures]->polymeraseDegradationTemperatureByPlate,
		Replace[CartridgePolymeraseDegradationRampRates]->polymeraseDegradationRampRateByPlate,

		Replace[CartridgeNumberOfCycles]->numberOfCyclesByPlate,

		(* Probe Fluorescence Properties *)
		Replace[ProbeFluorophores]->Link[probeFluorophores],
		Replace[ProbeExcitationWavelengths]->probeExcitationWavelengths,
		Replace[ProbeEmissionWavelengths]->probeEmissionWavelengths,
		Replace[ReferenceProbeFluorophores]->Link[referenceProbeFluorophores],
		Replace[ReferenceProbeExcitationWavelengths]->referenceProbeExcitationWavelengths,
		Replace[ReferenceProbeEmissionWavelengths]->referenceProbeEmissionWavelengths,

		Replace[MultiplexedProbeFluorophores]->Link/@multiplexedProbeFluorophores,
		Replace[MultiplexedProbeExcitationWavelengths]->multiplexedProbeExcitationWavelengths,
		Replace[MultiplexedProbeEmissionWavelengths]->multiplexedProbeEmissionWavelengths,
		Replace[MultiplexedReferenceProbeFluorophores]->Link/@multiplexedReferenceProbeFluorophores,
		Replace[MultiplexedReferenceProbeExcitationWavelengths]->multiplexedReferenceProbeExcitationWavelengths,
		Replace[MultiplexedReferenceProbeEmissionWavelengths]->multiplexedReferenceProbeEmissionWavelengths,

		(* Resources *)
		Replace[Checkpoints]->{
			{"Preparing Samples",45 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator -> $BaselineOperator, Time -> 45 Minute]]},
			{"Picking Resources",45 Minute,"Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 45 Minute]]},
			{"Preparing Assay Plate",2 Hour,"The samples and reagents are combined and loaded on DropletCartridges.", Link[Resource[Operator->$BaselineOperator, Time -> 2 Hour]]},
			{"Digital PCR",instrumentTime,"Digital PCR procedure is performed on the reaction mixtures.", Link[Resource[Operator -> $BaselineOperator, Time -> instrumentTime]]},
			{"Returning Materials",1 Hour,"Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 1*Hour]]}
		}
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket=populateSamplePrepFields[mySamples,myResolvedOptions,Simulation -> simulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[sharedFieldPacket,protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]],_Resource,Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],{True,{}},
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[expandedResolvedOptions,FastTrack],Site->Lookup[expandedResolvedOptions,Site],Simulation -> simulation],
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[expandedResolvedOptions,FastTrack],Site->Lookup[expandedResolvedOptions,Site],Messages->messages,Simulation -> simulation],Null}
	];

	(*---Return our options, packets, and tests---*)

	(*Generate the preview output rule; Preview is always Null*)
	previewRule=Preview->Null;

	(*Generate the options output rule*)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];

(* ::Subsubsection::Closed:: *)
(* dilutionTransferVolumes *)
(* Find the series of transfer volumes and diluent volumes needed to create the serial dilution curves from a pure sample *)
(* overload for non constant dilution factors *)
dilutionTransferVolumes[myCurve : {VolumeP, {RangeP[0, 1] ..}}] :=
	Module[{transferVolumes, diluentVolumes, sampleVolume,
		dilutionFactorCurve, lastTransferVolume, recTransferVolumeFunction},
		(*Get the volume each sample fave after the transfers*)
		sampleVolume = First[myCurve];
		(*Get the list of dilution factors*)
		dilutionFactorCurve = Last[myCurve];
		(*Calculate the last transfer volume performed DilutionFactors=transferIn/Totalvolume*)
		lastTransferVolume = SafeRound[Last[dilutionFactorCurve]*sampleVolume,10^-1 Microliter];
		(*Calculate the rest of the transfers with recursion TotalVolume=TransferIn+Diluent-transferOut, Dilutionfactor=transferin/(tranferIn+diluent)*)
		recTransferVolumeFunction[{_Real | _Integer}] :=
			{lastTransferVolume};
		recTransferVolumeFunction[factorList_List] := Join[
			{SafeRound[First[factorList]*(sampleVolume + First[recTransferVolumeFunction[Rest[factorList]]]),10^-1 Microliter]},
			recTransferVolumeFunction[Rest[factorList]]
		];
		transferVolumes = recTransferVolumeFunction[dilutionFactorCurve];
		(*calculate the corresponding diluent volumes, DilutionFactors=transferIn/(transferIn + diluent*)
		diluentVolumes =
			SafeRound[
				MapThread[
					If[MatchQ[#1, 0],
						sampleVolume,
						#2*(1 - #1)/#1] &,
					{dilutionFactorCurve, transferVolumes}
				],
				10^-1 Microliter];
		(*return the transfer volumes and diluentvolumes*)
		{
			Join[{sampleVolume+First[transferVolumes]},transferVolumes],
			Join[{0 Microliter},diluentVolumes]
		}
	];

(* overload for constant dilution factors, this could be an overload to the function above, but it is computationally faster to use this function*)
dilutionTransferVolumes[myCurve : {VolumeP, {RangeP[0, 1], GreaterP[1, 1]}}] :=
	Module[{sampleVolume, dilutionFactor, dilutionNumber, transferVolumes, diluentVolumes},
		(*Get the final volume after transfers*)
		sampleVolume = First[myCurve];
		(*Get the dilution volume*)
		dilutionFactor = First[Last[myCurve]];
		(*Get the number of dilutions*)
		dilutionNumber = Last[Last[myCurve]];
		(*Get the transfer volume, DilutionFactor=transferin/(transferin+
		diluent), sampleVolume=transferin+dilunent-transfer out=diluent*)
		transferVolumes = If[MatchQ[dilutionFactor, 1],
			Reverse[Table[sampleVolume + i*sampleVolume, {i, dilutionNumber}]],
			ConstantArray[
				SafeRound[
					dilutionFactor*sampleVolume/(1 - dilutionFactor),
					10^-1 Microliter]
				, dilutionNumber]
		];
		diluentVolumes = If[MatchQ[dilutionFactor, 1],
			ConstantArray[0 Microliter, dilutionNumber],
			ConstantArray[sampleVolume, dilutionNumber]
		];
		(*return the transfer volumes and diluentvolumes*)
		{
			Join[{sampleVolume+First[transferVolumes]},transferVolumes],
			Join[{0 Microliter},diluentVolumes]
		}
	];

(* overload for constant dilution volumes*)
dilutionTransferVolumes[myCurve : {VolumeP, VolumeP, GreaterP[1, 1]}] :=
	Module[{transferVolumes, diluentVolumes},
		(*make arrays of all the volumes*)
		transferVolumes = ConstantArray[First[myCurve], Last[myCurve]];
		diluentVolumes = ConstantArray[Middle[myCurve], Last[myCurve]];
		(*return the transfer volumes and diluentvolumes*)
		{
			Join[{Middle[myCurve]+First[transferVolumes]},transferVolumes],
			Join[{0 Microliter},diluentVolumes]
		}
	];

(* overload for Null input *)
dilutionTransferVolumes[Null]:={{Null},{Null}};


(* ::Subsection::Closed:: *)
(*ExperimentDigitalPCROptions*)


DefineOptions[ExperimentDigitalPCROptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentDigitalPCR}
];


(*---Main function accepting sample/container objects as sample inputs and sample objects or Nulls as primer pair inputs and probe inputs---*)
ExperimentDigitalPCROptions[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container],Model[Sample]}]|_String],
	myPrimerPairSamples:ListableP[
		Alternatives[
			{{(ObjectP[{Object[Container],Model[Sample],Object[Sample]}]|_String),(ObjectP[{Object[Container],Model[Sample],Object[Sample]}]|_String)}..},
			{Null,Null}
		]
	],
	myProbeSamples:ListableP[
		Alternatives[
			{(ObjectP[{Object[Container],Model[Sample],Object[Sample]}]|_String)..},
			Null
		]
	],
	myOptions:OptionsPattern[ExperimentDigitalPCROptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Send in the correct Output option and remove the OutputFormat option*)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentDigitalPCR[mySamples,myPrimerPairSamples,myProbeSamples,preparedOptions];

	(*Return the option as a list or table*)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentDigitalPCR],
		resolvedOptions
	]
];


(*---Function definition accepting sample/container objects as sample inputs and no primer pair or probe inputs---*)
ExperimentDigitalPCROptions[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container],Model[Sample]}]|_String],
	myOptions:OptionsPattern[ExperimentDigitalPCROptions]
]:=ExperimentDigitalPCROptions[
	mySamples,
	Table[{Null,Null},Length[ToList[mySamples]]],
	Table[Null,Length[ToList[mySamples]]],
	myOptions
];


(* ::Subsection::Closed:: *)
(*ExperimentDigitalPCRPreview*)


DefineOptions[ExperimentDigitalPCRPreview,
	SharedOptions:>{ExperimentDigitalPCR}
];


(*---Main function accepting sample/container objects as sample inputs and sample objects or Nulls as primer pair inputs---*)
ExperimentDigitalPCRPreview[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container],Model[Sample]}]|_String],
	myPrimerPairSamples:ListableP[
		Alternatives[
			{{(ObjectP[{Object[Container],Model[Sample],Object[Sample]}]|_String),(ObjectP[{Object[Container],Model[Sample],Object[Sample]}]|_String)}..},
			{Null,Null}
		]
	],
	myProbeSamples:ListableP[
		Alternatives[
			{(ObjectP[{Object[Container],Model[Sample],Object[Sample]}]|_String)..},
			Null
		]
	],
	myOptions:OptionsPattern[ExperimentDigitalPCRPreview]
]:=Module[{listedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	ExperimentDigitalPCR[mySamples,myPrimerPairSamples,myProbeSamples,ReplaceRule[listedOptions,Output->Preview]]
];


(*---Function definition accepting sample/container objects as sample inputs and no primer pair inputs---*)
ExperimentDigitalPCRPreview[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container],Model[Sample]}]|_String],
	myOptions:OptionsPattern[ExperimentDigitalPCRPreview]
]:=ExperimentDigitalPCRPreview[
	mySamples,
	Table[{Null,Null},Length[ToList[mySamples]]],
	Table[Null,Length[ToList[mySamples]]],
	myOptions
];


(* ::Subsection::Closed:: *)
(*ValidExperimentDigitalPCRQ*)


DefineOptions[ValidExperimentDigitalPCRQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions:>{ExperimentDigitalPCR}
];


(*---Main function accepting sample/container objects as sample inputs and sample objects or Nulls as primer pair inputs---*)
ValidExperimentDigitalPCRQ[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container],Model[Sample]}]|_String],
	myPrimerPairSamples:ListableP[
		Alternatives[
			{{(ObjectP[{Object[Container],Model[Sample],Object[Sample]}]|_String),(ObjectP[{Object[Container],Model[Sample],Object[Sample]}]|_String)}..},
			{Null,Null}
		]
	],
	myProbeSamples:ListableP[
		Alternatives[
			{(ObjectP[{Object[Container],Model[Sample],Object[Sample]}]|_String)..},
			Null
		]
	],
	myOptions:OptionsPattern[ValidExperimentDigitalPCRQ]
]:=Module[
	{listedOptions,preparedOptions,experimentDigitalPCRTests,initialTestDescription,allTests,verbose,outputFormat},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Remove the output option before passing to the core function because it doesn't make sense here*)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(*Call the ExperimentDigitalPCR function to get a list of tests*)
	experimentDigitalPCRTests=ExperimentDigitalPCR[mySamples,myPrimerPairSamples,myProbeSamples,Append[preparedOptions,Output->Tests]];

	(*Define the general test description*)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(*Make a list of all the tests, including the blanket test*)
	allTests=If[MatchQ[experimentDigitalPCRTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings},

			(*Generate the initial test, which should pass if we got this far*)
			initialTest=Test[initialTestDescription,True,True];

			(*Create warnings for invalid objects*)
			validObjectBooleans=ValidObjectQ[Cases[Flatten[{mySamples,myPrimerPairSamples,myProbeSamples}],ObjectP[]],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Cases[Flatten[{mySamples,myPrimerPairSamples,myProbeSamples}],ObjectP[]],validObjectBooleans}
			];

			(*Get all the tests/warnings*)
			Cases[Flatten[{initialTest,experimentDigitalPCRTests,voqWarnings}],_EmeraldTest]
		]
	];

	(*Look up the test-running options*)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(*Run the tests as requested*)
	Lookup[RunUnitTest[<|"ValidExperimentDigitalPCRQ"->allTests|>,Verbose->verbose,OutputFormat->outputFormat],"ValidExperimentDigitalPCRQ"]
];


(*---Function definition accepting sample/container objects as sample inputs and no primer pair inputs---*)
ValidExperimentDigitalPCRQ[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container],Model[Sample]}]|_String],
	myOptions:OptionsPattern[ValidExperimentDigitalPCRQ]
]:=ValidExperimentDigitalPCRQ[
	mySamples,
	Table[{Null,Null},Length[ToList[mySamples]]],
	Table[Null,Length[ToList[mySamples]]],
	myOptions
];
