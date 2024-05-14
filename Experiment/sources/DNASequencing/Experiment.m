(* ::Package:: *)

(* ::Section:: *)
(* Source Code *)


(* ::Subsection:: *)
(* ExperimentDNASequencing *)




(* ::Subsubsection::Closed:: *)
(* ExperimentDNASequencing Options and Messages *)


DefineOptions[ExperimentDNASequencing,
	Options:>{
		(*===General===*)
		{
			OptionName->Instrument,
			Default->Model[Instrument,GeneticAnalyzer,"SeqStudio"],
			Description->"The cartridge-based capillary electrophoresis instrument for running the DNA sequencing experiment using fluorescence detection to determine nucleotide sequence.",
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Instrument,GeneticAnalyzer],Object[Instrument,GeneticAnalyzer]}]]
		},
		{
			OptionName->SequencingCartridge,
			Default->Model[Item,Cartridge,DNASequencing,"SeqStudio Sequencing Cartridge v2"],
			Description->"The cartridge containing the polymer, capillary array, and anode buffer that fits into the instrument for running the DNA sequencing experiment.",
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Item,Cartridge,DNASequencing],Model[Item,Cartridge,DNASequencing]}]]
		},
		{
			OptionName->InjectionGroups,
			Default->Automatic,
			Description->"The groups into which SamplesIn will be broken up into as defined by the sequencing cartridge capillary array that must co-inject four samples at a time. The groups will be automatically determined based on the electrophoresis settings. Any groups that do not reach a total of four will use the SequencingBuffer to complete the group.",
			ResolutionDescription->"Resolves based on the options set in the Separation category. Injection groups must have identical DyeSet, PrimeTime, PrimeVoltage, InjectionTime, InjectionVoltage, RampTime, RunVoltage, and RunTime settings.",
			AllowNull->False,
			Widget->Adder[
				Adder[
					Widget[Type->Object,Pattern:>ObjectP[Object[Sample]]]
				]
			],
			Category->"Hidden"
		},
		{
			OptionName->BufferCartridge,
			Default->Model[Container,Vessel,BufferCartridge,"SeqStudio Buffer Cartridge"],
			Description->"The cartridge containing the cathode buffer and waste container that fits into the instrument for running the DNA sequencing experiment.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Container,Vessel,BufferCartridge],Model[Container,Vessel,BufferCartridge]}],
				PreparedSample->False
			]
		},
		{
			OptionName->Temperature,
			Default->60 Celsius,
			Description->"The target temperature of the capillary array throughout the experiment.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[40 Celsius,60 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}]
		},
		{
			OptionName->PreparedPlate,
			Default->Automatic,
			Description->"Indicates if the plate containing the samples for the DNA sequencing experiment has been previously prepared with primers and Master Mix and does not need to run sample preparation steps.",
			ResolutionDescription->"Automatically resolves to False if 'primers' are specified as an input, and True if 'primers' are not an input.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName->NumberOfInjections,
			Default->1,
			Description->"The number of times each amplified sample is injected for a capillary electrophoresis run using identical experimental parameters. All samples are injected for each NumberOfInjections, and a separate Data object is created for each sample for every injection.",
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[1,1]]
		},

		(*===Sample Preparation===*)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->ReadLength,
				Default->Automatic,
				Description->"The estimated number of base pairs in the template samples to be sequenced. Template sample length informs default capillary electrophoresis experiment parameters as described in Figure 3.1.",
				ResolutionDescription->"Automatically resolves based on SequenceLength[Object[Sample][Composition]], or to 500 base pairs if Composition is not known, unless otherwise specified.",
				AllowNull->False,
				Widget->Widget[Type->Number,Pattern:>RangeP[1,2000,1]],
				Category->"Sample Preparation"
			},
			{
				OptionName->SampleVolume,
				Default->2 Microliter,
				Description->"The volume of each template sample to add to the polymerase reaction.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}],
				Category->"Sample Preparation"
			},
			{
				OptionName->ReactionVolume,
				Default->20 Microliter,
				Description->"The total volume of the polymerase reaction including the template, primer, master mix, and diluent.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[10 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}],
				Category->"Sample Preparation"
			},
			{
				OptionName->PrimerConcentration,
				Default->Automatic,
				Description->"The desired final concentration of the primer in the polymerase reaction.",
				ResolutionDescription->"Automatically resolves to 0.1 Micromolar, or Null if PreparedPlate is set to True.",
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[0.1 Picomolar,10 Micromolar],Units->{Molar,{Picomolar,Nanomolar,Micromolar,Millimolar,Molar}}],
				Category->"Sample Preparation"
			},
			{
				OptionName->PrimerVolume,
				Default->Automatic,
				Description->"The volume of the primer to add to each polymerase reaction.",
				ResolutionDescription->"Automatically set according to the equation PrimerVolume=(PrimerConcentration)*(ReactionVolume)/(inital primer concentration), or 1 Microliter if the calculated volume is too small to be pipetted accurately, or Null otherwise.",
				AllowNull->True,
				Widget-> Widget[Type->Quantity,Pattern:>RangeP[1 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}],
				Category->"Sample Preparation"
			},
			{
				OptionName->PrimerStorageCondition,
				Default->Null,
				Description->"For each sample, the non-default conditions under which the primers of this experiment should be stored after the protocol is completed. If left unset, the primers will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},
			{
				OptionName->MasterMix,
				Default->Model[Sample,"BigDye Terminator v3.1 Ready Reaction Mix"],
				Description->"The stock solution composed of the polymerase, nucleotides, fluorescent dideoxynucleotides, and buffer for the polymerase reaction.",
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}]],
				Category->"Sample Preparation"
			},
			{
				OptionName->MasterMixStorageCondition,
				Default->Null,
				Description->"For each sample, the non-default condition under which MasterMix of this experiment should be stored after the protocol is completed. If left unset, MasterMix will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},
			{
				OptionName->MasterMixVolume,
				Default->Automatic,
				Description->"The volume of master mix to add to the reaction.",
				ResolutionDescription->"Automatically set to 0.5*ReactionVolume if MasterMix is not set to Null, or Null otherwise.",
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}],
				Category->"Sample Preparation"
			},
			{
				OptionName->AdenosineTriphosphateTerminator,
				Default->Automatic,
				Description->"The dye molecule (dideoxynucelotide triphosphate) used to terminate DNA chains at locations where the complementary base on the template strand is thymine.",
				ResolutionDescription->"Automatically resolves by finding the corresponding dideoxynucleotide dye in the MasterMix Object[Sample][Composition].",
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Molecule],Model[ProprietaryFormulation]}]],
				Category->"Sample Preparation"
			},
			{
				OptionName->ThymidineTriphosphateTerminator,
				Default->Automatic,
				Description->"The dye molecule (dideoxynucelotide triphosphate) used to terminate DNA chains at locations where the complementary base on the template strand is adenine.",
				ResolutionDescription->"Automatically resolves by finding the corresponding dideoxynucleotide dye in the MasterMix Object[Sample][Composition].",
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Molecule],Model[ProprietaryFormulation]}]],
				Category->"Sample Preparation"
			},
			{
				OptionName->GuanosineTriphosphateTerminator,
				Default->Automatic,
				Description->"The dye molecule (dideoxynucelotide triphosphate) used to terminate DNA chains at locations where the complementary base on the template strand is cytosine.",
				ResolutionDescription->"Automatically resolves by finding the corresponding dideoxynucleotide dye in the MasterMix Object[Sample][Composition].",
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Molecule],Model[ProprietaryFormulation]}]],
				Category->"Sample Preparation"
			},
			{
				OptionName->CytosineTriphosphateTerminator,
				Default->Automatic,
				Description->"The dye molecule (dideoxynucelotide triphosphate) used to terminate DNA chains at locations where the complementary base on the template strand is guanine.",
				ResolutionDescription->"Automatically resolves by finding the corresponding dideoxynucleotide dye in the MasterMix Object[Sample][Composition].",
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Molecule],Model[ProprietaryFormulation]}]],
				Category->"Sample Preparation"
			},
			{
				OptionName->Diluent,
				Default->Automatic,
				Description->"The solution for bringing each reaction to ReactionVolume once all the reaction components (template, primers, and master mix) are added.",
				ResolutionDescription-> "Automatically resolves to Model[Sample,\"Nuclease-free Water\"], or Null if PreparedPlate is set to True.",
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}]],
				Category->"Sample Preparation"
			},
			{
				OptionName->DiluentVolume,
				Default->Automatic,
				Description->"The volume of buffer to add to bring each reaction to ReactionVolume.",
				ResolutionDescription->"Automatically set according to the equation DiluentVolume=ReactionVolume-(SampleVolume+MasterMixVolume+PrimerVolume) if Diluent is not set to Null, or Null otherwise.",
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}],
				Category->"Sample Preparation"
			}],

		(*===Polymerase Activation===*)
		{
			OptionName->Activation,
			Default->Automatic,
			Description->"Indicates if hot start activation should be performed in the polymerase reaction. In order to reduce non-specific amplification, enzymes can be made room temperature stable by inhibiting their activity via thermolabile conjugates. Once an experiment is ready to be run, this inhibition is disabled by heating the reaction to ActivationTemperature.",
			ResolutionDescription->"Automatically set to True if other Activation options are set, or False otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Polymerase Activation"
		},
		{
			OptionName->ActivationTime,
			Default->Automatic,
			Description->"The length of time for which the sample is held at ActivationTemperature to remove the thermolabile conjugates inhibiting polymerase activity in the polymerase reaction.",
			ResolutionDescription->"Automatically set to 60 seconds if Activation is set to True, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second,1 Hour],Units->{Second,{Second,Minute,Hour}}],
			Category->"Polymerase Activation"
		},
		{
			OptionName->ActivationTemperature,
			Default->Automatic,
			Description->"The temperature to which the sample is heated to remove the thermolabile conjugates inhibiting polymerase activity in the polymerase reaction.",
			ResolutionDescription->"Automatically set to 95 degrees Celsius if Activation is set to True, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[4 Celsius,105 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}],
			Category->"Polymerase Activation"
		},
		{
			OptionName->ActivationRampRate,
			Default->Automatic,
			Description->"The rate at which the sample is heated to reach ActivationTemperature in the polymerase reaction.",
			AllowNull->True,
			ResolutionDescription->"Automatically set to 3.5 degrees Celsius per second if Activation is set to True, or Null otherwise.",
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0.1 (Celsius/Second),3.5 (Celsius/Second)],Units->CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Polymerase Activation"
		},


		(*===Denaturation===*)
		{
			OptionName->DenaturationTime,
			Default->10 Second,
			Description->"The length of time for which the sample is held at DenaturationTemperature to allow the dissociation of the double stranded template into single strands in the polymerase reaction.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second,1 Hour],Units->{Second,{Second,Minute,Hour}}],
			Category->"Denaturation"
		},
		{
			OptionName->DenaturationTemperature,
			Default->96 Celsius,
			Description->"The temperature to which the sample is heated to allow the dissociation of the double stranded template into single strands in the polymerase reaction.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[4 Celsius,105 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}],
			Category->"Denaturation"
		},
		{
			OptionName->DenaturationRampRate,
			Default->1 (Celsius/Second),
			Description->"The rate at which the sample is heated to reach DenaturationTemperature in the polymerase reaction.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0.1 (Celsius/Second),3.5 (Celsius/Second)],Units->CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Denaturation"
		},


		(*===Primer Annealing===*)
		{
			OptionName->PrimerAnnealing,
			Default->Automatic,
			Description->"Indicates if annealing should be performed as a separate step instead of as part of extension in the polymerase reaction. Lowering the temperature during annealing allows primers to bind to the template and serve as anchor points for the polymerase in the subsequent extension.",
			ResolutionDescription->"Automatically set to True if other PrimerAnnealing options are set, or False otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Primer Annealing"
		},
		{
			OptionName->PrimerAnnealingTime,
			Default->Automatic,
			Description->"The length of time for which the sample is held at PrimerAnnealingTemperature to allow primers to bind to the template in the polymerase reaction.",
			ResolutionDescription->"Automatically set to 5 seconds if PrimerAnnealing is set to True, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second,1 Hour],Units->{Second,{Second,Minute,Hour}}],
			Category->"Primer Annealing"
		},
		{
			OptionName->PrimerAnnealingTemperature,
			Default->Automatic,
			Description->"The temperature to which the sample is cooled to allow primers to bind to the template in the polymerase reaction.",
			ResolutionDescription->"Automatically set to 50 degrees Celsius if PrimerAnnealing is set to True, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[4 Celsius,105 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}],
			Category->"Primer Annealing"
		},
		{
			OptionName->PrimerAnnealingRampRate,
			Default->Automatic,
			Description->"The rate at which the sample is cooled to reach PrimerAnnealingTemperature in the polymerase reaction.",
			ResolutionDescription->"Automatically set to 1 degrees Celsius per second if PrimerAnnealing is set to True, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0.1 (Celsius/Second),3.5 (Celsius/Second)],Units->CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Primer Annealing"
		},


		(*===Strand Extension===*)
		{
			OptionName->ExtensionTime,
			Default->240 Second,
			Description->"The length of time for which sample is held at ExtensionTemperature to allow the polymerase to synthesize a new strand using the template and primers in the polymerase reaction.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second,1 Hour],Units->{Second,{Second,Minute,Hour}}],
			Category->"Strand Extension"
		},
		{
			OptionName->ExtensionTemperature,
			Default->60 Celsius,
			Description->"The temperature to which the sample is heated/cooled to allow the polymerase to synthesize a new strand using the template and primers in the polymerase reaction.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[4 Celsius,105 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}],
			Category->"Strand Extension"
		},
		{
			OptionName->ExtensionRampRate,
			Default->1 (Celsius/Second),
			Description->"The rate at which the sample is heated/cooled to reach ExtensionTemperature in the polymerase reaction.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0.1 (Celsius/Second),3.5 (Celsius/Second)],Units->CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Strand Extension"
		},


		(*===Thermocycling===*)
		{
			OptionName->NumberOfCycles,
			Default->25,
			Description->"The number of times the polymerase reaction will undergo repeated cycles of denaturation, primer annealing (optional), and strand extension.",
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>RangeP[1,60,1]],
			Category->"Thermocycling"
		},

		{
			OptionName->HoldTemperature,
			Default->4 Celsius,
			Description->"The temperature to which the sample is cooled and held after the polymerase reaction thermocycling procedure.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[4 Celsius,105 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}],
			Category->"Thermocycling"
		},


		(*===Post-PCR Sample Preparation===*)
		{
			OptionName->PurificationType,
			Default->Automatic,
			Description->"The method of purification of the DNA template samples after undergoing chain termination PCR. Ethanol precipitation selectively precipitates DNA out of solution by adding solutions of ethanol and EDTA to the sample, mixing, and centrifuging. Then the supernatant containing reaction reagents is discarded and the pure DNA pellet is resuspended. BigDye XTerminator purification removes unincorporated BigDye terminators and salts by adding BigDye XTerminator solution to the reactions, then mixing and centrifuging.",
			ResolutionDescription->"Automatically set to Null if PreparedPlate->True, or BigDye XTerminator if a BigDye master mix is used, or Ethanol precipitation otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives["Ethanol precipitation","BigDye XTerminator"]],
			Category->"Post-PCR Sample Preparation"
		},
		{
			OptionName->QuenchingReagents,
			Default->Automatic,
			Description->"The reagents used to quench the polymerase chain reaction and remove unreacted materials.",
			ResolutionDescription->"Automatically set to Model[Sample,\"Absolute Ethanol, Anhydrous\"] and Model[Sample, StockSolution, \"125 mM EDTA\"] if PurificationType->Ethanol precipitation, or Model[Sample,\"SAM Solution\"] and Model[Sample,\"BigDye XTerminator Solution\"] if PurificationType->BigDye XTerminator, or Null otherwise.",
			AllowNull->True,
			Widget->Adder[Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}]]],
			Category->"Post-PCR Sample Preparation"
		},
		{
			OptionName->QuenchingReagentVolumes,
			Default->Automatic,
			Description->"The volumes of the reagents added to quench the polymerase reaction.",
			ResolutionDescription->"Automatically set to {30 Microliter, 1 Microliter} if PurificationType->Ethanol precipitation, or {4.5*ReactionVolume, ReactionVolume}  of the ReactionVolume of the first sample if PurificationType->BigDye XTerminator, or Null otherwise.",
			AllowNull->True,
			Widget->Adder[Widget[Type->Quantity,Pattern:>RangeP[1 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}]],
			Category->"Post-PCR Sample Preparation"
		},
		{
			OptionName->SequencingBuffer,
			Default->Automatic,
			Description->"The buffer to be used to resuspend DNA samples prior to loading in the genetic analyzer instrument. This buffer will also be used to fill empty wells that are needed to complete injection groups as a blank.",
			ResolutionDescription->"Automatically set to Model[Sample,\"Tris EDTA 0.1 buffer solution\"] if PurificationType->Ethanol precipitation, or Null if PurificationType->BigDye XTerminator and otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}]],
			Category->"Post-PCR Sample Preparation"
		},
		{
			OptionName->SequencingBufferVolume,
			Default->Automatic,
			Description->"The volume of the buffer to be used to resuspend DNA samples prior to loading in the genetic analyzer instrument.",
			ResolutionDescription->"Automatically set to 40 microliters if PurificationType->Ethanol precipitation, or Null if PurificationType->BigDye XTerminator and otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}],
			Category->"Post-PCR Sample Preparation"
		},

		(*===Separation===*)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> DyeSet,
				Default -> Automatic,
				Description -> "The set of dye terminator molecules used to terminate DNA chains, with different emission spectra corresponding to the different nucleotides. For optimal performance use the dye set that most closely matches the Master Mix and dyes used in the polymerase reaction.",
				ResolutionDescription -> "Automatically resolves based on the name of the Master Mix used.",
				AllowNull -> False,
				Widget -> Widget[Type->Enumeration, Pattern:>Alternatives["E_BigDye Terminator v1.1","Z_BigDye Terminator v3.1","Z_BigDye Direct"]],
				Category -> "Separation"
			},
			{
				OptionName->PrimeTime,
				Default->180 Second,
				Description->"The length of time for which cathode buffer is drawn into the capillary array in order to prime the capillaries prior to the samples being injected.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Second,1000 Second],Units->{Second,{Second,Minute,Hour}}],
				Category->"Separation"
			},
			{
				OptionName->PrimeVoltage,
				Default->13000 Volt,
				Description->"The voltage applied to the capillary array in order to prime the capillaries prior to the samples being injected.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Volt,13000 Volt],Units->{Volt,{Volt,Kilovolt}}],
				Category->"Separation"
			},
			{
				OptionName->InjectionTime,
				Default->10 Second,
				Description->"The length of time for which sample is drawn into the capillary array. A longer injection time will lead to an increase in the signal, as more DNA molecules will be electrokinetically drawn into the capillary.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second,600 Second],Units->{Second,{Second,Minute,Hour}}],
				Category->"Separation"
			},
			{
				OptionName->InjectionVoltage,
				Default->Automatic,
				Description->"The voltage applied to the capillary array while the samples are being drawn into the capillaries.",
				ResolutionDescription->"Automatically set according to the ReadLength option specifying the length of the sequence to be read.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Volt,13000 Volt],Units->{Volt,{Volt,Kilovolt}}],
				Category->"Separation"
			},
			{
				OptionName->RampTime,
				Default->300 Second,
				Description->"The length of time for which the voltage will ramp from the injection voltage to the run voltage.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second,1800 Second],Units->{Second,{Second,Minute,Hour}}],
				Category->"Separation"
			},
			{
				OptionName->RunVoltage,
				Default->Automatic,
				Description->"The voltage applied to the capillary array while the template samples move through the capillary and the fragments separate.",
				ResolutionDescription->"Automatically set according to the ReadLength option specifying the length of the sequence to be read.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Volt,13000 Volt],Units->{Volt,{Volt,Kilovolt}}],
				Category->"Separation"
			},
			{
				OptionName->RunTime,
				Default->Automatic,
				Description->"The length of time for which the separation of the template fragments in the capillaries will occur.",
				ResolutionDescription->"Automatically set according to the ReadLength option specifying the length of the sequence to be read.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[300 Second,14000 Second],Units->{Second,{Second,Minute,Hour}}],
				Category->"Separation"
			}],


		(*===Storage===*)
		{
			OptionName->SequencingCartridgeStorageCondition,
			Default->Model[StorageCondition,"Refrigerator"],
			Description->"The storage condition for the SequencingCartridge once the experiment has concluded.",
			AllowNull->False,
			Widget->Alternatives[
				"Storage Type" -> Widget[Type -> Enumeration,Pattern :> SampleStorageTypeP|Disposal],
				"Storage Object" -> Widget[Type -> Object,Pattern :> ObjectP[Model[StorageCondition]],PreparedSample -> False,PreparedContainer -> False]],
			Category->"Storage"
		},

		FuntopiaSharedOptions,
		SamplesInStorageOptions
	}
];


(* ERROR and WARNINGS *)

Error::DNASequencingTooManySamples = "The number of input samples cannot fit onto the instrument in a single protocol. Please select fewer than 96 samples to run this protocol.";
Error::DNASequencingPreparedPlateContainerInvalid = "When using a prepared plate, the samples must all be in the same plate with the model, Model[Container, Plate, \"id:Z1lqpMz1EnVL\"]. Please transfer the samples.";
Error::DNASequencingPreparedPlateInputInvalid = "When PreparedPlate is set to True, primers cannot be specified. When PreparedPlate is set to False, primers must be specified. Please change the value of PreparedPlate or the inputs.";
Error::DNASequencingCathodeBufferInvalid = "The specified BufferCartridge contains a CathodeSequencingBuffer that is not compatible with the instrument. Please specify a cartridge containing a CathodeSequencingBuffer with the model Model[Sample,\"DNA Sequencing Cathode Buffer\"].";
Error::DNASequencingAnodeBufferInvalid = "The specified SequencingCartridge contains an AnodeBuffer that is not compatible with the instrument. Please specify a cartridge containing an AnodeBuffer with the model Model[Sample,\"DNA Sequencing Anode Buffer\"]";
Error::DNASequencingPolymerInvalid = "The specified SequencingCartridge contains an Polymer that is not compatible with the instrument. Please specify a cartridge containing a Polymer with the model Model[Sample,\"Performance Optimized Polymer 1\"]";
Error::DNASequencingCartridgeTypeInvalid = "The CartridgeType of the specified SequencingCartridge `1` is not DNASequencing, and the genetic analyzer instrument cannot accommodate any sequencing cartridge that is not of the type DNASequencing. Please choose a different cartridge with the CartridgeType DNASequencing, or leave SequencingCartridge as Automatic.";
Warning::MultipleSampleOligomersSpecified = "The composition of the sample(s) `1` contains multiple oligomers of different lengths; consequently, the ReadLength option is automatically resolved to 500 base pairs. Please specify a ReadLength or use a sample containing a single oligomer if this value is not correct.";
Error::DNASequencingTooManyInjectionGroups = "The samples in must be grouped into injection groups to accommodate the instrument, which injects 4 samples at a time into the 4 capillaries, but the number of injection groups formed cannot fit on the plate in a single protocol. Please select fewer samples or change the DyeSet, PrimeTime, PrimeVoltage, InjectionTime, InjectionVoltage, RampTime, RunVoltage, and RunTime options to match for more samples to run this protocol.";
Error::DNASequencingPrimerCompositionNull = "The PrimerVolume is not specified and the concentration of a Model[Molecule,Oligomer] in the Composition field of the primer sample(s) `1` is Null or unable to be determined, so PrimerVolume cannot be resolved. Please specify a PrimerVolume or inform the concentration of a Model[Molecule,Oligomer] in the Composition field for the primer sample so the PrimerVolume can be set automatically.";
Error::MultiplePrimerSampleOligomersSpecified = "The Composition field of the primer sample(s) `1` contain more than one Model[Molecule,Oligomer], so the PrimerVolume option cannot be automatically resolved. Please specify a PrimerVolume or use a primer sample containing a single oligomer.";
Error::DNASequencingPrimerStorageConditionMismatch="If primer inputs are Null, PrimerStorageCondition cannot be specified. Please specify primer inputs or change the value of the PrimerStorageCondition option.";
Error::DNASequencingMasterMixNotSpecified = "If MasterMix is Null, MasterMixVolume cannot be specified; if MasterMix is specified, MasterMixVolume cannot be Null. Please change the value of either or both option(s), or leave MasterMixVolume unspecified to be set automatically.";
Error::DNASequencingMasterMixStorageConditionMismatch="If MasterMix is Null, MasterMixStorageCondition cannot be specified. Please change the value of either or both option(s).";
Error::DNASequencingDiluentNotSpecified = "If Diluent is Null, DiluentVolume cannot be specified. If Diluent is specified, DiluentVolume cannot be Null. Please change the value of either or both option(s), or leave DiluentVolume unspecified to be set automatically.";
Error::DNASequencingTotalVolumeOverReactionVolume = "The total volume consisting of SampleVolume, PrimerVolume, MasterMixVolume, and DiluentVolume exceeds the total ReactionVolume for sample(s) `1`. Please change the value of some or all of these options, or leave MasterMixVolume, PrimerVolume, and/or DiluentVolume unspecified to be set automatically.";
Error::DNASequencingPreparedPlateMismatch = "If PreparedPlate is True, PrimerConcentration, PrimerVolume, MasterMix, MasterMixVolume, Diluent, and DiluentVolume cannot be specified; if PreparedPlate is False, PrimerConcentration, PrimerVolume, MasterMix, and MasterMixVolume cannot be Null. Please change the values of these options, or leave them unspecified to be set automatically.";
Warning::DNASequencingReadLengthNotSpecified = "The ReadLength has been automatically resolved to 500 base pairs because it could not be automatically determined from the Composition field of the samples `1`. If this value is not correct, please specify a ReadLength value or inform the Composition field in the corresponding sample with a single Model[Molecule,Oligomer] with the PolymerType DNA so ReadLength can be set automatically.";
Error::DNASequencingPurificationTypeMismatch = "If the PurificationType is \"Ethanol precipitation\", the QuenchingReagents and SequencingBuffer cannot be set to Null. If the PurificationType is \"BigDye XTerminator\", the QuenchingReagents cannot be set to Null. Please change the values of SequencingBuffer, QuenchingReagents, or PurificationType accordingly.";
Error::DNASequencingQuenchingReagentVolumeMismatch = "If QuenchingReagent is Null, QuenchingReagentVolume cannot be specified. If QuenchingReagent is specified, QuenchingReagentVolume cannot be Null. Please change the value of either or both option(s), or leave QuenchingReagentVolume unspecified to be set automatically.";
Error::DNASequencingBufferVolumeMismatch = "If SequencingBuffer is Null, SequencingBufferVolume cannot be specified. If SequencingBuffer is specified, SequencingBufferVolume cannot be Null. Please change the value of either or both option(s), or leave SequencingBufferVolume unspecified to be set automatically.";
Error::DyeSetUnknown = "The DyeSet option is not specified, and the DyeSet cannot be automatically set from the name of the Master Mix. Please specify a value for the DyeSet.";
Warning::DNASequencingInjectionGroupsSettingsMismatch = "The specified InjectionGroups have values for options DyeSet, ReadLength, PrimeTime, PrimeVoltage, InjectionTime, InjectionVoltage, RampTime, RunVoltage, and/or RunTime that do not match, which cannot be accommodated by the instrument. The samples have been automatically grouped into InjectionGroups with matching options.";
Warning::DNASequencingInjectionGroupsSamplesLengthsMismatch = "The specified InjectionGroups have more or less samples than are input to the function, or all samples are not specified in a injection group. All of the sample inputs have been automatically grouped into InjectionGroups.";
Warning::DNASequencingInjectionGroupsOptionsAmbiguous = "There are replicate samples as input and the samples in are in a different order than the specified InjectionGroups and replicate samples have different options specified, so the matching options to InjectionGroups is ambiguous. All of the sample inputs have been automatically grouped into InjectionGroups with matching options.";
Warning::DNASequencingPCROptionsForPreparedPlate = "When PreparedPlate->True, PCR is not performed on the samples, so any specified PCR options will be ignored. Please set PreparedPlate to False if PCR is desired.";
Warning::DNASequencingInjectionGroupsLengths = "The specified InjectionGroups have groups of samples that are longer than the NumberOfCapillaries in the SequencingCartridge, which cannot be accommodated by the instrument. The samples have been automatically grouped into InjectionGroups with lengths matching NumberOfCapillaries in the SequencingCartridge.";
Warning::DNASequencingCartridgeStorageCondition = "The manufacturer recommends storage of the sequencing cartridge in the refrigerator from 2-8 Celsius, but SequencingCartridgeStorageCondition is not set to Refrigerator or Model[StorageCondition, Refrigerator]. Storing the cartridge outside of these temperatures can degrade the materials in the cartridge and impact performance. It is recommended that the SequencingCartridgeStorageCondition is changed to Refrigerator or Model[StorageCondition, Refrigerator].";


(* ::Subsubsection:: *)
(* ExperimentDNASequencing Core Function *)

(*---Main function accepting sample objects as sample inputs and sample objects or Nulls as primer inputs---*)

ExperimentDNASequencing[
	mySamples:ListableP[ObjectP[Object[Sample]]],
	myPrimerSamples:ListableP[ObjectP[Object[Sample]]|Null],
	myOptions:OptionsPattern[ExperimentDNASequencing]
]:=Module[
	{
		listedOptions,listedSamples, listedPrimerSamples, outputSpecification,output,gatherTests,messages,

		validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		mySamplesWithPreparedSamplesNamed,myPrimerSamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCacheNamed,safeOpsNamed,
		samplePreparationCache,myPrimerSamplesWithPreparedSamples,initialOptionsWithPreparedSamples,initialSamplePreparationCache,

		safeOps,safeOpsTests,validLengths,validLengthTests,

		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,expandedSamples,nonNullExpandedPrimerSamples,expandedPrimerSamples,
		upload,confirm,fastTrack,parentProtocol,cache,dnaSequencingOptionsAssociation,
		instrument,sampleContainer,sequencingCartridge,bufferCartridge,masterMix,
		samplePreparationPackets,sampleModelPreparationPackets,containerPreparationPackets,
		allSamplePackets, allPrimerSamplePackets, sequencingCartridgePacket, bufferCartridgePacket, masterMixPackets,
		samplePackets,sampleModelPackets,sampleContainerPackets,primerSamplePackets,primerSampleModelPackets,primerSampleContainerPackets,
		cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,
		protocolObject,DNASequencingResourcePackets,resourcePackets,resourcePacketTests
	},
	
	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];
	
	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Make sure we're working with a list of options and call helper function to remove temporal links *)
	{{listedSamples,listedPrimerSamples},listedOptions}=removeLinks[{ToList[mySamples], ToList[myPrimerSamples]},ToList[myOptions]];

	(* if we are not gathering tests, they will be messages *)
	messages=!gatherTests;

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation *)
		{mySamplesWithPreparedSamplesNamed,initialOptionsWithPreparedSamples,initialSamplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentDNASequencing,
			listedSamples,
			listedOptions
		];
		If[!NullQ[listedPrimerSamples],
			{myPrimerSamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCacheNamed}=simulateSamplePreparationPackets[
				ExperimentDNASequencing,
				listedPrimerSamples,
				ReplaceRule[initialOptionsWithPreparedSamples,
					Cache->FlattenCachePackets[{
						Lookup[initialOptionsWithPreparedSamples,Cache,{}],
						initialSamplePreparationCache
					}]
				]
			],
			{
				myPrimerSamplesWithPreparedSamplesNamed,
				myOptionsWithPreparedSamplesNamed,
				samplePreparationCacheNamed
			} = {
				listedPrimerSamples,
				initialOptionsWithPreparedSamples,
				initialSamplePreparationCache
			}
		],
		$Failed,
		{Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];
	
	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentDNASequencing,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentDNASequencing,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	{{mySamplesWithPreparedSamples,myPrimerSamplesWithPreparedSamples},{safeOps,myOptionsWithPreparedSamples,samplePreparationCache}}=sanitizeInputs[{mySamplesWithPreparedSamplesNamed,myPrimerSamplesWithPreparedSamplesNamed},{safeOpsNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCacheNamed}];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		If[NullQ[myPrimerSamplesWithPreparedSamples],
			ValidInputLengthsQ[ExperimentDNASequencing,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,1,Output->{Result,Tests}],
			ValidInputLengthsQ[ExperimentDNASequencing,{mySamplesWithPreparedSamples,myPrimerSamplesWithPreparedSamples},myOptionsWithPreparedSamples,2,Output->{Result,Tests}]
		],
		If[NullQ[myPrimerSamplesWithPreparedSamples],
			{ValidInputLengthsQ[ExperimentDNASequencing,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,1],Null},
			{ValidInputLengthsQ[ExperimentDNASequencing,{mySamplesWithPreparedSamples,myPrimerSamplesWithPreparedSamples},myOptionsWithPreparedSamples,2],Null}
		]
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
	
	(*If option lengths are invalid, return $Failed (or the tests up to this point)*)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentDNASequencing,{mySamplesWithPreparedSamples,myPrimerSamplesWithPreparedSamples},ToList[myOptionsWithPreparedSamples],2,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentDNASequencing,{mySamplesWithPreparedSamples,myPrimerSamplesWithPreparedSamples},ToList[myOptionsWithPreparedSamples],2],Null}
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

	(* Expand index-matching options *)
	{{expandedSamples,nonNullExpandedPrimerSamples},expandedSafeOps}=ExpandIndexMatchedInputs[ExperimentDNASequencing,{mySamplesWithPreparedSamples,myPrimerSamplesWithPreparedSamples},inheritedOptions,2];
	
	(*Expand index-matching secondary input (primers) if it's Null*)
	expandedPrimerSamples=If[MatchQ[nonNullExpandedPrimerSamples,{{Null}}],
		ConstantArray[{Null},Length[expandedSamples]],
		nonNullExpandedPrimerSamples
	];

	(*get assorted hidden options*)
	{upload,confirm,fastTrack,parentProtocol,cache}=Lookup[inheritedOptions,{Upload,Confirm,FastTrack,ParentProtocol,Cache}];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(*Convert list of rules to Association so we can Lookup, Append, Join as usual*)
	dnaSequencingOptionsAssociation=Association[expandedSafeOps];
	
	(*Pull out the options that have objects whose information we need to download*)
	{instrument,sequencingCartridge,bufferCartridge,masterMix}=Lookup[
		dnaSequencingOptionsAssociation,
		{Instrument,SequencingCartridge,BufferCartridge,MasterMix}
	];

	(* decide what to download *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	samplePreparationPackets = Packet[SamplePreparationCacheFields[Object[Sample], Format->Sequence], Volume, IncompatibleMaterials, LiquidHandlerIncompatible, Well, Composition];
	sampleModelPreparationPackets = Packet[Model[Flatten[{Deprecated, Products, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials, SamplePreparationCacheFields[Model[Sample]]}]]];
	containerPreparationPackets = Packet[Container[Flatten[{SamplePreparationCacheFields[Object[Container]], Model}]]];


	(* Extract the packets that we need from our downloaded cache. *)
	{
		allSamplePackets,
		allPrimerSamplePackets,
		sequencingCartridgePacket,
		bufferCartridgePacket,
		masterMixPackets
	}=Quiet[
		Download[
			{
				listedSamples,
				listedPrimerSamples,
				{sequencingCartridge},
				{bufferCartridge},
				ToList[masterMix]
			},
			{
				{
					samplePreparationPackets,
					sampleModelPreparationPackets,
					containerPreparationPackets
				},
				{
					samplePreparationPackets,
					sampleModelPreparationPackets,
					containerPreparationPackets
				},
				{Packet[NumberOfCapillaries, Polymer, AnodeBuffer,CartridgeType]},
				{Packet[CathodeSequencingBuffer]},
				{Packet[Composition, Name, Container]}
			},
			Cache->FlattenCachePackets[{samplePreparationCache, cache}],
			Date->Now
		],
		Download::FieldDoesntExist
	];


	(*Extract the sample-related packets*)
	samplePackets=allSamplePackets[[All,1]];
	sampleModelPackets=allSamplePackets[[All,2]];
	sampleContainerPackets=allSamplePackets[[All,3]];

	(*Extract the primer-related packets*)
	If[!NullQ[allPrimerSamplePackets],
		primerSamplePackets=allPrimerSamplePackets[[All,1]];
		primerSampleModelPackets=allPrimerSamplePackets[[All,2]];
		primerSampleContainerPackets=allPrimerSamplePackets[[All,3]];,
		{primerSamplePackets,primerSampleModelPackets,primerSampleContainerPackets}=ConstantArray[Null,3]
	];

	(* Combine our downloaded and simulated cache. *)
	cacheBall=FlattenCachePackets[{samplePreparationCache,cache,allSamplePackets,allPrimerSamplePackets,sequencingCartridgePacket,bufferCartridgePacket,masterMixPackets}];


	
	(*--Build the resolved options--*)
	resolvedOptionsResult=If[gatherTests,
		(*We are gathering tests. This silences any messages being thrown*)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentDNASequencingOptions[expandedSamples,expandedPrimerSamples,expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];
		
		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],
		
		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentDNASequencingOptions[expandedSamples,expandedPrimerSamples,expandedSafeOps,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentDNASequencing,
		resolvedOptions,
		Ignore->listedOptions,
		Messages->False
	];
	
	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentDNASequencing,collapsedResolvedOptions],
			Preview->Null
		}]
	];
	
	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		experimentDNASequencingResourcePackets[expandedSamples,expandedPrimerSamples,expandedSafeOps,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{experimentDNASequencingResourcePackets[expandedSamples,expandedPrimerSamples,expandedSafeOps,resolvedOptions,Cache->cacheBall],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentDNASequencing,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,DNASequencing],
			Cache->samplePreparationCache
		],
		$Failed
	];
	
	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentDNASequencing,collapsedResolvedOptions],
		Preview -> Null
	}
];


(* ::Subsubsection:: *)
(* ExperimentDNASequencing Sample/Container Input and Sample/Container or Null Primer Inputs *)

(*---Function overload accepting sample/container objects as sample inputs and sample/container objects or Nulls as primer inputs---*)
ExperimentDNASequencing[
	mySampleContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],
	myPrimerContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|Null|{LocationPositionP,_String|ObjectP[Object[Container]]}],
	myOptions:OptionsPattern[ExperimentDNASequencing]
]:=Module[
	{listedOptions,listedSampleContainers,listedPrimerSamples,initialListedPrimerSamples,
		outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,initialOptionsWithPreparedSamples,initialSamplePreparationCache,
		myOptionsWithPreparedSamples,samplePreparationCache,sampleCache,
		containerToSampleResult,containerToSampleOutput,containerToSampleTests,
		primerContainerToSampleResult,primerContainerToSampleOutput,primerContainerToSampleTests,myPrimerSamplesWithPreparedSamples,
		combinedContainerToSampleTests,updatedCache,samples,sampleOptions},

	(*Determine the requested return value from the function*)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];
	
	(* call helper function to remove temporal links *)
	{{listedSampleContainers,listedPrimerSamples}, listedOptions}=removeLinks[{ToList[mySampleContainers], ToList[myPrimerContainers]}, ToList[myOptions]];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation *)
		{mySamplesWithPreparedSamples,initialOptionsWithPreparedSamples,initialSamplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentDNASequencing,
			listedSampleContainers,
			listedOptions
		];
		If[!NullQ[listedPrimerSamples],
			{myPrimerSamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
				ExperimentDNASequencing,
				listedPrimerSamples,
				ReplaceRule[initialOptionsWithPreparedSamples,
					Cache->FlattenCachePackets[{
						Lookup[initialOptionsWithPreparedSamples,Cache,{}],
						initialSamplePreparationCache
					}]
				]
			],
			{myPrimerSamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}={listedPrimerSamples,initialOptionsWithPreparedSamples,initialSamplePreparationCache}
		],
		$Failed,
		{Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(*If we are given an invalid define name, return early*)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(*Return early*)
		(*Note: We've already thrown a message above in simulateSamplePreparationPackets*)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(*--Convert the given containers into samples and sample index-matched options--*)

	(*-Samples-*)
	containerToSampleResult=If[gatherTests,
		(*We are gathering tests. This silences any messages being thrown*)
		{containerToSampleOutput,containerToSampleTests}=containerToSampleOptions[
			ExperimentDNASequencing,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests},
			Cache->samplePreparationCache
		];

		(*Therefore, we have to run the tests to see if we encountered a failure*)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(*We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption*)
		Check[
			containerToSampleOutput=containerToSampleOptions[
				ExperimentDNASequencing,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->Result,
				Cache->samplePreparationCache
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(*-Primers-*)
	(* Convert our given primer containers into primers and primer index-matched options. *)
	primerContainerToSampleResult=If[!NullQ[listedPrimerSamples],
		If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{primerContainerToSampleOutput,primerContainerToSampleTests}=containerToSampleOptions[
			ExperimentDNASequencing,
			myPrimerSamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests},
			Cache->samplePreparationCache
		];

		(*Therefore, we have to run the tests to see if we encountered a failure*)
		If[RunUnitTest[<|"Tests"->primerContainerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],


		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			primerContainerToSampleOutput=containerToSampleOptions[
				ExperimentDNASequencing,
				myPrimerSamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->Result,
				Cache->samplePreparationCache
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
			]
		]
	];

	combinedContainerToSampleTests=If[!NullQ[listedPrimerSamples],
		Join[containerToSampleTests,primerContainerToSampleTests],
		containerToSampleTests
	];

	(* Update our cache with our new simulated values. *)
	updatedCache=Flatten[{
		samplePreparationCache,
		Lookup[listedOptions,Cache,{}]
	}];

	(* If we were given an empty container, return early. *)
	If[Or[MatchQ[containerToSampleResult,$Failed],MatchQ[primerContainerToSampleResult,$Failed]],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> combinedContainerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions, sampleCache}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentDNASequencing[
			samples,
			If[!NullQ[myPrimerContainers],First[primerContainerToSampleResult],ConstantArray[Null, Length[samples]]],
			ReplaceRule[sampleOptions,Cache->Flatten[{updatedCache,sampleCache}]]
		]
	]
];


(* ::Subsubsection:: *)
(* ExperimentDNASequencing No Primer and Sample/Container Input *)

(*---Function definition accepting sample/container objects as sample inputs and no primer inputs---*)
ExperimentDNASequencing[
	mySamples:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
	myOptions:OptionsPattern[ExperimentDNASequencing]
]:=ExperimentDNASequencing[
	mySamples,
	ConstantArray[Null, Length[ToList[mySamples]]],
	myOptions
];




(* -------------------------- *)
(* -- OPTION RESOLVER -- *)

DefineOptions[
	resolveExperimentDNASequencingOptions,
	Options:>{HelperOutputOption,CacheOption}
];

resolveExperimentDNASequencingOptions[
	mySamples:ListableP[ObjectP[Object[Sample]]],
	myPrimerSamples:ListableP[ObjectP[Object[Sample]]|Null],
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentDNASequencingOptions]
]:=Module[
	{outputSpecification,output,gatherTests,messages,confirm,template,inheritedCache,operator,upload,outputOption,samplesInStorage,samplePreparation,email,samplePrepOptions,DNASequencingOptions,simulatedSamples,resolvedSamplePrepOptions,simulatedCache,samplePrepTests,
		DNASequencingOptionsAssociation,cacheBall,instrument,sequencingCartridge,bufferCartridge,sequencingCartridgeStorageCondition,numberOfReplicates, numberOfInjections,
		masterMix,diluent, quenchingReagent, sequencingBuffer,fastTrack,name,parentProtocol,

		(*download*)
		samplePreparationPackets,
		sampleModelPreparationPackets,
		containerPreparationPackets,compositionPackets,sampleCompositionPackets,primerSampleCompositionPackets,modelCompositionPackets,sampleModelCompositionPackets,primerSampleModelCompositionPackets,
		allSamplePackets,allPrimerSamplePackets,sequencingCartridgePacket,bufferCartridgePacket,masterMixPackets,
		samplePackets,sampleModelPackets,sampleContainerPackets,
		primerSamplePackets,primerSampleModelPackets,primerSampleContainerPackets,notInEngine,


		(* invalid inputs *)
		discardedSamplePackets,discardedPrimerSamplePackets,allDiscardedSamplePackets,discardedInvalidInputs,discardedTest,
		sampleModelPacketsToCheck,deprecatedSampleModelPackets,primerSampleModelPacketsToCheck,deprecatedPrimerSampleModelPackets,allDeprecatedSampleModelPackets,deprecatedInvalidInputs,deprecatedTest,
		tooManySamplesQ,tooManySamplesInvalidInputs,tooManySamplesTest,validPreparedPlateInputQ,validPreparedPlateTest,
		sampleContainerModel,sampleContainerObject,validPreparedPlateContainerQ,preparedPlateInvalidInputs,preparedPlateInvalidContainerInputs,validPreparedPlateContainerTest,
		solidSamplePackets,solidSampleTest,solidStateInvalidInputs,solidPrimerSamplePackets,solidPrimerSampleTest,solidStatePrimerInvalidInputs,precisionTests,
		validNameQ,nameInvalidOptions,validNameTest,
		cathodeBuffer,validCathodeBufferQ,invalidCathodeBufferOptions,invalidCathodeBufferTest,
		anodeBuffer,validAnodeBufferQ,invalidAnodeBufferOptions,invalidAnodeBufferTest,
		sequencingPolymer,validPolymerQ,invalidPolymerOptions,invalidPolymerTest,
		cartridgeType,validCartridgeTypeQ,invalidCartridgeTypeOptions,invalidCartridgeTypeTest,
		resolvedPreparedPlate, sampleOrModelCompositionPackets, quenchingReagentNames,
		sampleCompositionErrors,multipleOligomerSamples,sampleCompositionBools,mapThreadFriendlyOptions,resolvedReadLengthsRule,updatedMapThreadFriendlyOptions,resolvedReadLengths,
		dyeSet,tooManyInjectionGroups,resolvedInjectionGroups,tooManyInjectionGroupsQ,tooManyInjectionGroupsInvalidInputs,tooManyInjectionGroupsTest,
		injectionGroupsSettingsMismatchWarning,injectionGroupsMismatchInvalidInputs,injectionGroupsMismatchTest,
		injectionGroupsSamplesWarning,injectionGroupsOptionsAmbiguousWarning,injectionGroupsAmbiguousOptionsTest,injectionGroupsSamplesTest,
		expandedPrimerSamples,allResolvedMapThreadOptionsAssociation,allErrorTrackersAssociation,
		purificationType,masterMixName,resolvedPurificationType,resolvedQuenchingReagents,resolvedQuenchingReagentVolumes,resolvedSequencingBuffer,resolvedSequencingBufferVolume,quenchingReagentNotSpecifiedError,sequencingBufferNotSpecifiedError,
		invalidPurificationTypeOptions,validPurificationTypeTest, purificationTypeMismatchError,
		invalidQuenchingReagentVolumeOptions,validQuenchingReagentVolumeTest,
		invalidSequencingBufferVolumeOptions,validSequencingBufferVolumeTest,

		(* rounded options *)
		temperature,sampleVolume,reactionVolume,primerConcentration,primerVolume,masterMixVolume,diluentVolume,quenchingReagentVolume,sequencingBufferVolume,primeTime,primeVoltage,injectionTime,injectionVoltage,rampTime,runVoltage,runTime,
		roundedDNASequencingOptions, updatedRoundedDNASequencingOptions,

		(*downloaded values *)
		samplesMoleculeComposition,multipleSampleOligomersInputs,multipleSampleOligomersTest,

		(*read length error tracker*)
		readLengthsWarningBooleans,

		(* map thread outputs *)
		resolvedOptionsPackets, resolvedMapThreadErrorTrackerPackets, injectionGroupsLengthWarnings,injectionGroupsLengthInvalidOptions,
		injectionGroupsLengthTest,mapThreadPrimerConcentration, mapThreadPrimerVolume, mapThreadMasterMixVolume, mapThreadDiluentVolume,
		validPreparedPlateQ,preparedPlateMismatchOptions,preparedPlateMismatchTest,

		(* resolve PCR options *)
		resolvedPCROptions,pcrTests, pcrResolveFailure,
		activation, activationTime, activationTemperature, activationRampRate,
		denaturationTime, denaturationTemperature, denaturationRampRate,
		primerAnnealing, primerAnnealingTime, primerAnnealingTemperature, primerAnnealingRampRate,
		extensionTime, extensionTemperature, extensionRampRate, numberOfCycles, holdTemperature,
		specifiedPCROptions,pcrOptionsSpecifiedPreparedPlateTest,

		(* unresolvable options checks *)
		primerCompositionNullOptions,primerCompositionTest,
		multiplePrimerSampleOligomersOptions,multiplePrimerSampleOligomersTest,
		invalidPrimerStorageConditionOptions,validPrimerStorageConditionTest,
		masterMixInvalidOptions,masterMixTest,
		invalidMasterMixStorageConditionOptions,validMasterMixStorageConditionTest,
		diluentInvalidOptions,diluentTest,
		totalVolumeOverReactionVolumeOptions,totalVolumeTest,
		readLengthNotSpecifiedOptions,readLengthTest,
		dyeSetInvalidOptions,dyeSetTest,

		(* storage condition checks*)
		validSequencingCartridgeStorageConditionQ, sequencingCartridgeStorageConditionOptions, sequencingCartridgeStorageConditionTest,
		samplesInStorageConditions,primerStorageConditions,masterMixStorageConditions,
		discardedSampleInvalidInputs,discardedPrimerSampleInvalidInputs,nonDiscardedSamples,nonDiscardedSampleStorageConditions,
		validSamplesInStorageConditionBool, validSamplesInStorageConditionTests,samplesInStorageConditionInvalidOptions,
		nonDiscardedPrimerSamples,nonDiscardedPrimerSampleStorageConditions,validPrimerStorageConditionBool, validPrimerSampleStorageConditionTests,primerStorageConditionInvalidOptions,
		masterMixNoModels,masterMixStorageNoModels,validMasterMixStorageConditionBool, validMasterMixStorageConditionTests,masterMixStorageConditionInvalidOptions,


		(* compatible materials check *)
		compatibleMaterialsBool,compatibleMaterialsTests,compatibleMaterialsInvalidOption,
		requiredAliquotAmounts,

		invalidInputs,invalidOptions,
		targetContainers,resolvedAliquotOptions,aliquotTests,
		resolvedPostProcessingOptions,allTests,
		resolvedOptions,testsRule,resultRule
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* Separate out our DNASequencing options from our Sample Prep options. *)
	{samplePrepOptions,DNASequencingOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,simulatedCache},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptions[ExperimentDNASequencing,mySamples,samplePrepOptions,Cache->inheritedCache,Output->{Result,Tests}],
		{resolveSamplePrepOptions[ExperimentDNASequencing,mySamples,samplePrepOptions,Cache->inheritedCache,Output->Result],{}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	DNASequencingOptionsAssociation = Association[DNASequencingOptions];

	(*Pull out the options that are defaulted or specified that don't have precision*)
	{sequencingCartridge,
		bufferCartridge,
		(*numberOfReplicates,*)
		numberOfInjections,
		masterMix,
		diluent,
		purificationType,
		quenchingReagent,
		sequencingBuffer,
		dyeSet,
		sequencingCartridgeStorageCondition,
		fastTrack,
		name,
		parentProtocol}=Lookup[
		DNASequencingOptionsAssociation,
		{SequencingCartridge,
			BufferCartridge,
			(*NumberOfReplicates,*)
			NumberOfInjections,
			MasterMix,
			Diluent,
			PurificationType,
			QuenchingReagents,
			SequencingBuffer,
			DyeSet,
			SequencingCartridgeStorageCondition,
			FastTrack,
			Name,
			ParentProtocol}
		];


	(* ---------------------- *)
	(* -- DOWNLOAD SECTION -- *)
	(* ---------------------- *)


	(* decide what to download *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	samplePreparationPackets = Packet[SamplePreparationCacheFields[Object[Sample], Format->Sequence], Volume, IncompatibleMaterials, LiquidHandlerIncompatible, Well, Composition];
	sampleModelPreparationPackets = Packet[Model[Flatten[{Deprecated, Products, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials, SamplePreparationCacheFields[Model[Sample]]}]]];
	containerPreparationPackets = Packet[Container[Flatten[{SamplePreparationCacheFields[Object[Container]], Model}]]];
	compositionPackets = Packet[Field[Composition[[All,2]][Molecule]]];
	modelCompositionPackets = Packet[Model[Field[Composition[[All,2]][Molecule]]]];


	(* Extract the packets that we need from our downloaded cache. *)
	(* Remember to download from simulatedSamples, using our simulatedCache *)
	{
		allSamplePackets,
		allPrimerSamplePackets,
		sequencingCartridgePacket,
		bufferCartridgePacket,
		masterMixPackets
	}=Quiet[
		Download[
			{
				ToList[mySamples],
				ToList[myPrimerSamples],
				{sequencingCartridge},
				{bufferCartridge},
				ToList[masterMix]
			},
			{
				{
					samplePreparationPackets,
					sampleModelPreparationPackets,
					containerPreparationPackets,
					compositionPackets,
					modelCompositionPackets
				},
				{
					samplePreparationPackets,
					sampleModelPreparationPackets,
					containerPreparationPackets,
					compositionPackets,
					modelCompositionPackets
				},
				{Packet[NumberOfCapillaries, Polymer, AnodeBuffer,CartridgeType]},
				{Packet[CathodeSequencingBuffer]},
				{Packet[Composition, Name, Container]}
			},
			Cache -> simulatedCache,
			Date->Now
		],
		Download::FieldDoesntExist
	];

	(*Extract the sample-related packets*)
	samplePackets=allSamplePackets[[All,1]];
	sampleModelPackets=allSamplePackets[[All,2]];
	sampleContainerPackets=allSamplePackets[[All,3]];
	sampleCompositionPackets=allSamplePackets[[All,4]];
	sampleModelCompositionPackets=allSamplePackets[[All,5]];

	(*Extract the primer-related packets*)
	If[!NullQ[allPrimerSamplePackets],
		primerSamplePackets=allPrimerSamplePackets[[All,1]];
		primerSampleModelPackets=allPrimerSamplePackets[[All,2]];
		primerSampleContainerPackets=allPrimerSamplePackets[[All,3]];
		primerSampleCompositionPackets=allPrimerSamplePackets[[All,4]],
		primerSampleModelCompositionPackets=allSamplePackets[[All,5]];
		{
			primerSamplePackets,
			primerSampleModelPackets,
			primerSampleContainerPackets,
			primerSampleCompositionPackets,
			primerSampleModelCompositionPackets
		}=ConstantArray[ConstantArray[Null,Length[ToList[mySamples]]],5]
	];

	cacheBall = Flatten[
		{
			allSamplePackets,
			allPrimerSamplePackets,
			sequencingCartridgePacket,
			bufferCartridgePacket,
			masterMixPackets
		}
	];

	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)
	(*Determine if we are in Engine or not, in Engine we silence warnings*)
	notInEngine=!MatchQ[$ECLApplication,Engine];

	(*-- INPUT VALIDATION CHECKS --*)

	(* --- Discarded samples are not ok --- *)

	(* Get the samples from samplePackets that are discarded. *)
	discardedSamplePackets = Cases[samplePackets, KeyValuePattern[Status -> Discarded]];

	(*Get the sample packets from primerSamplePackets that are discarded*)
	discardedPrimerSamplePackets=If[!NullQ[allPrimerSamplePackets],
		Cases[primerSamplePackets,KeyValuePattern[Status->Discarded]],
		{}
	];

	(*Join these two lists of discarded sample packets*)
	allDiscardedSamplePackets=Join[discardedSamplePackets,discardedPrimerSamplePackets];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs = If[MatchQ[allDiscardedSamplePackets, {}],
		{},
		Lookup[allDiscardedSamplePackets, Object]
	];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> simulatedCache]]
	];

		(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> simulatedCache] <> " are not discarded:", True, False]
			];
			passingTest = If[Length[discardedInvalidInputs] == Length[flatSampleList],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[flatSampleList, discardedInvalidInputs], Cache -> simulatedCache] <> " are not discarded:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* --- Check if the input samples have Deprecated inputs --- *)

	(* get all the model packets together that are going to be checked for whether they are deprecated *)
	(* need to only get the packets themselves (and not any Nulls that might have slipped through) *)
	sampleModelPacketsToCheck = Cases[sampleModelPackets, PacketP[Model[Sample]]];

	(* get the samples that are deprecated; if on the FastTrack, don't bother checking *)
	deprecatedSampleModelPackets = If[Not[fastTrack],
		Select[sampleModelPacketsToCheck, TrueQ[Lookup[#, Deprecated]]&],
		{}
	];

	If[!NullQ[allPrimerSamplePackets],

		(*Get the model packets from myPrimerSamples that will be checked for whether they are deprecated*)
		primerSampleModelPacketsToCheck=Cases[Flatten[primerSampleModelPackets],PacketP[Model[Sample]]];

		(*Get the model packets from myPrimerSamples that are deprecated; if on the FastTrack, skip this check*)
		deprecatedPrimerSampleModelPackets=If[!fastTrack,
			Select[primerSampleModelPacketsToCheck,TrueQ[Lookup[#,Deprecated]]&],
			{}
		],

		primerSampleModelPacketsToCheck={};
		deprecatedPrimerSampleModelPackets={}
	];

	(*Join these two lists of deprecated model packets*)
	allDeprecatedSampleModelPackets=Join[deprecatedSampleModelPackets,deprecatedPrimerSampleModelPackets];

	(*Set deprecatedInvalidInputs to the input objects whose models are Deprecated*)
	deprecatedInvalidInputs=If[MatchQ[allDeprecatedSampleModelPackets,{}],
		{},
		Lookup[allDeprecatedSampleModelPackets,Object]
	];

	(*If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs*)
	If[Length[deprecatedInvalidInputs]>0&&messages,
		Message[Error::DeprecatedModels,ObjectToString[deprecatedInvalidInputs,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedInvalidInputs] == 0,
				Nothing,
				Test["Provided samples have models " <> ObjectToString[deprecatedInvalidInputs, Cache -> simulatedCache] <> " that are not deprecated:", True, False]
			];

			passingTest = If[Length[deprecatedInvalidInputs] == Length[Join[sampleModelPacketsToCheck,primerSampleModelPacketsToCheck]],
				Nothing,
				Test["Provided samples have models " <> ObjectToString[Download[Complement[Join[sampleModelPacketsToCheck,primerSampleModelPacketsToCheck],deprecatedInvalidInputs], Object], Cache -> simulatedCache] <> " that are not deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(*--Too many samples check--*)

	(*Check if there are too many samples for the 96-well plate*)
	tooManySamplesQ=Length[simulatedSamples]>96;

	(*Set tooManySamplesInvalidInputs to all sample objects*)
	tooManySamplesInvalidInputs=If[tooManySamplesQ,
		Lookup[Flatten[samplePackets],Object],
		{}
	];

	(*If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs*)
	If[Length[tooManySamplesInvalidInputs]>0&&messages,
		Message[Error::DNASequencingTooManySamples]
	];

	(*If we are gathering tests, create a test for too many samples*)
	tooManySamplesTest=If[gatherTests,
		Test["There are 96 or fewer input samples:",
			tooManySamplesQ,
			False
		],
		Nothing
	];

	(*--PreparedPlate Invalid Input--*)
	(* check if no primer samples were provided. In this situation, PreparedPlate should be left as Automatic or set to True *)
	validPreparedPlateInputQ=If[
		Or[
			(MatchQ[myPrimerSamples,ListableP[Null]]&&MatchQ[Lookup[DNASequencingOptionsAssociation,PreparedPlate],Automatic|True]),
			(!MatchQ[myPrimerSamples,ListableP[Null]]&&MatchQ[Lookup[DNASequencingOptionsAssociation,PreparedPlate],Automatic|False])
		],
		True,
		False
	];

	(* If prepared plate test fails, treat all of the input samples as invalid *)
	preparedPlateInvalidInputs=If[!validPreparedPlateInputQ,
		Lookup[Flatten[{samplePackets}],Object],
		{}
	];

	(* throw error if the prepared plate check is false *)
	If[!validPreparedPlateInputQ&&messages,
		Message[Error::DNASequencingPreparedPlateInputInvalid]
	];

	(*If we are gathering tests, create a test for a prepared plate error*)
	validPreparedPlateTest=If[gatherTests,
		Test["When PreparedPlate -> True, no primer input is specified. When PreparedPlate -> False, primer inputs are specified:",
			validPreparedPlateInputQ,
			True
		],
		Nothing
	];


	(*--PreparedPlate Container check--*)

	(* look up sample container model and object *)
	sampleContainerModel = If[NullQ[sampleContainerPackets],Null,Lookup[sampleContainerPackets,Model]];
	sampleContainerObject = If[NullQ[sampleContainerPackets],Null,Lookup[sampleContainerPackets,Object]];

	(* check if a prepared plate was provided. In this situation, there is no primer input *)
	(* in this case, check that the samples are all in the same DNA sequencing compatible plate *)
	validPreparedPlateContainerQ=If[
		MatchQ[myPrimerSamples,ListableP[Null]],
		And[
			MatchQ[sampleContainerModel,{LinkP[Model[Container, Plate, "id:Z1lqpMz1EnVL"]]..}],     
			SameQ@@sampleContainerObject
		],
		True
	];

	(* If prepared plate test fails, treat all of the input samples as invalid *)
	preparedPlateInvalidContainerInputs=If[!validPreparedPlateContainerQ,
		Lookup[Flatten[samplePackets],Object],
		{}
	];

	(* throw error if the prepared plate check is false *)
	If[!validPreparedPlateContainerQ&&messages,
		Message[Error::DNASequencingPreparedPlateContainerInvalid]
	];

	(*If we are gathering tests, create a test for a prepared plate error*)
	validPreparedPlateContainerTest=If[gatherTests,
		Test["When PreparedPlate -> True (no primer input is specified), the input samples are all in one plate with model, Model[Container, Plate, \"id:Z1lqpMz1EnVL\"]:",
			validPreparedPlateContainerQ,
			True
		],
		Nothing
	];

	(* -- Check if the input is a solid -- *)

	(* identify sample packets with solid objects *)
	solidSamplePackets = Cases[samplePackets, KeyValuePattern[State->Solid]];

	(*test for solid inputs*)
	solidSampleTest = Test["All input samples are liquids:",
		MatchQ[solidSamplePackets,{}],
		True
	];

	(* gather the objects that are solids *)
	solidStateInvalidInputs = If[MatchQ[solidSamplePackets, {}],
		{},
		Lookup[solidSamplePackets, Object]
	];

	(*throw the error*)
	If[MatchQ[solidSamplePackets, Except[{}]]&&!gatherTests,
		Message[Error::InvalidSolidInput,Lookup[solidSamplePackets, Object]]
	];

	(* ---Primers--- *)
	(* identify primer sample packets with solid objects *)
	solidPrimerSamplePackets = Cases[primerSamplePackets, KeyValuePattern[State->Solid]];

	(*test for solid inputs*)
	solidPrimerSampleTest = Test["All input samples are liquids:",
		MatchQ[solidPrimerSamplePackets,{}],
		True
	];

	(* gather the objects that are solids *)
	solidStatePrimerInvalidInputs = If[MatchQ[solidSamplePackets, {}],
		{},
		Lookup[solidPrimerSamplePackets, Object]
	];

	(*throw the error*)
	If[MatchQ[solidPrimerSamplePackets, Except[{}]]&&!gatherTests,
		Message[Error::InvalidSolidInput,Lookup[solidPrimerSamplePackets, Object]]
	];

	(*-- OPTION PRECISION CHECKS --*)
	(* ensure that all the numerical options have the proper precision *)
	{roundedDNASequencingOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[
			Association[myOptions],
			{Temperature, SampleVolume, ReactionVolume, PrimerConcentration, PrimerVolume, MasterMixVolume, DiluentVolume, QuenchingReagentVolumes, SequencingBufferVolume, PrimeTime, PrimeVoltage, InjectionTime, InjectionVoltage, RampTime, RunVoltage, RunTime},
			{1 Celsius,10^-1 Microliter, 10^-1 Microliter, 10^-1 Picomolar, 10^-1 Microliter, 10^-1 Microliter, 10^-1 Microliter, 10^-1 Microliter, 10^-1 Microliter, 1 Second, 1 Volt, 1 Second, 1 Volt, 1 Second, 1 Volt, 1 Second},
			Output -> {Result, Tests}
		],
		{
			RoundOptionPrecision[
				Association[myOptions],
				{Temperature, SampleVolume, ReactionVolume, PrimerConcentration, PrimerVolume, MasterMixVolume, DiluentVolume, QuenchingReagentVolumes, SequencingBufferVolume, PrimeTime, PrimeVoltage, InjectionTime, InjectionVoltage, RampTime, RunVoltage, RunTime},
				{1 Celsius,10^-1 Microliter, 10^-1 Microliter, 10^-1 Picomolar, 10^-1 Microliter, 10^-1 Microliter, 10^-1 Microliter, 10^-1 Microliter, 10^-1 Microliter, 1 Second, 1 Volt, 1 Second, 1 Volt, 1 Second, 1 Volt, 1 Second}
			],
			{}
		}
	];
	
	(*Pull out the rounded options*)
	{temperature,sampleVolume,reactionVolume,primerConcentration,primerVolume,masterMixVolume,diluentVolume,quenchingReagentVolume,sequencingBufferVolume,primeTime,primeVoltage,injectionTime,injectionVoltage,rampTime,runVoltage,runTime}=Lookup[
		roundedDNASequencingOptions,
		{Temperature,SampleVolume,ReactionVolume,PrimerConcentration,PrimerVolume,MasterMixVolume,DiluentVolume,QuenchingReagentVolumes,SequencingBufferVolume,PrimeTime,PrimeVoltage,InjectionTime,InjectionVoltage,RampTime,RunVoltage,RunTime}
	];


	(*-- CONFLICTING OPTIONS CHECKS --*)

	(* --- Make sure the Name isn't currently in use --- *)

	(* If the specified Name is not in the database, it is valid *)
	validNameQ = If[MatchQ[name, _String],
		Not[DatabaseMemberQ[Object[Protocol, DNASequencing, name]]],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions = If[Not[validNameQ] && messages,
		(
			Message[Error::DuplicateName, "DNASequencing protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest = If[gatherTests && MatchQ[name,_String],
		Test["If specified, Name is not already a DNASequencing object name:",
			validNameQ,
			True
		],
		Null
	];


	(*--CathodeBuffer invalid check--*)

	(* Lookup cathode buffer information from BufferCartridge packet *)
	cathodeBuffer = Lookup[Flatten[bufferCartridgePacket], CathodeSequencingBuffer];

	(* check if correct cathode buffer is specified *)
	validCathodeBufferQ=If[!NullQ[cathodeBuffer],
		MatchQ[cathodeBuffer, {ObjectP[{Object[Sample, "DNA Sequencing Cathode Buffer"], Model[Sample, "DNA Sequencing Cathode Buffer"]}]}],
		True
		];

	(*If CathodeBuffer is specified and we are throwing messages, throw an error message *)
	invalidCathodeBufferOptions=If[!validCathodeBufferQ&&messages,
		Message[Error::DNASequencingCathodeBufferInvalid];
		{BufferCartridge},
		{}
	];

	(*If we are gathering tests, create a test for CathodeBuffer invalid check*)
	invalidCathodeBufferTest=If[gatherTests,
		Test["If CathodeBuffer is not empty, CathodeBuffer must be the allowed DNA Sequencing Cathode Buffer",
			validCathodeBufferQ,
			True
		],
		Nothing
	];

	(*--AnodeBuffer invalid check--*)

	(* Lookup anode buffer information from SequencingCartridge packet *)
	anodeBuffer = Lookup[Flatten[sequencingCartridgePacket],AnodeBuffer];

	(* check if correct anode buffer is specified *)
	validAnodeBufferQ=If[!NullQ[anodeBuffer],
		MatchQ[anodeBuffer, {ObjectP[{Object[Sample, "DNA Sequencing Anode Buffer"], Model[Sample, "DNA Sequencing Anode Buffer"]}]}],
		True
	];

	(*If AnodeBuffer is specified and we are throwing messages, throw an error message *)
	invalidAnodeBufferOptions=If[!validAnodeBufferQ&&messages,
		Message[Error::DNASequencingAnodeBufferInvalid];
		{SequencingCartridge},
		{}
	];

	(*If we are gathering tests, create a test for AnodeBuffer invalid check*)
	invalidAnodeBufferTest=If[gatherTests,
		Test["If AnodeBuffer is not empty, AnodeBuffer must be the allowed DNA Sequencing Anode Buffer",
			validAnodeBufferQ,
			True
		],
		Nothing
	];

	(*--Polymer invalid check--*)

	(* Lookup polymer information from SequencingCartridge packet *)
	sequencingPolymer = Lookup[Flatten[sequencingCartridgePacket],Polymer];

	(* check if correct polymer is specified *)
	validPolymerQ=If[!NullQ[sequencingPolymer],
		MatchQ[sequencingPolymer, {ObjectP[{Object[Sample, "Performance Optimized Polymer 1"], Model[Sample, "Performance Optimized Polymer 1"]}]}],
		True
	];

	(*If Polymer is specified and we are throwing messages, throw an error message and keep track of the invalid inputs*)
	invalidPolymerOptions=If[!validPolymerQ&&messages,
		Message[Error::DNASequencingPolymerInvalid];
		{SequencingCartridge},
		{}
	];

	(*If we are gathering tests, create a test for Polymer invalid check*)
	invalidPolymerTest=If[gatherTests,
		Test["If Polymer is not empty, Polymer must be the allowed POP-1 polymer",
			validPolymerQ,
			True
		],
		Nothing
	];

	(*--CartridgeType invalid check--*)

	(* Lookup polymer information from SequencingCartridge packet *)
	cartridgeType = Lookup[Flatten[sequencingCartridgePacket],CartridgeType];

	(* check if correct cartridge type is specified *)
	validCartridgeTypeQ=If[!NullQ[cartridgeType],
		MatchQ[cartridgeType,{DNASequencing}|DNASequencing],
		True
	];

	(*If CartridgeType is specified and we are throwing messages, throw an error message and keep track of the invalid inputs*)
	invalidCartridgeTypeOptions=If[!validCartridgeTypeQ&&messages,
		(
			Message[Error::DNASequencingCartridgeTypeInvalid,ObjectToString[sequencingCartridge,Cache->simulatedCache]];{SequencingCartridge}
		),
		{}
	];

	(*If we are gathering tests, create a test for Polymer invalid check*)
	invalidCartridgeTypeTest=If[gatherTests,
		Test["If CartridgeType is not empty, CartridgeType must be DNASequencing",
			validCartridgeTypeQ,
			True
		],
		Nothing
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* resolve PreparedPlate *)
	resolvedPreparedPlate=Module[{preparedPlate},
		preparedPlate=Lookup[DNASequencingOptionsAssociation,PreparedPlate];
		Which[
		BooleanQ[preparedPlate],preparedPlate,
		MatchQ[preparedPlate,Automatic]&&!NullQ[myPrimerSamples],False,
		True,True
		]
	];


	(* Resolve PurificationType *)
	(* look up the name of the master mix *)
	masterMixName = If[NullQ[masterMixPackets],
		"Null",
		If[
			MatchQ[Lookup[Flatten[masterMixPackets][[1]],Name],{}|Null],
			"Null",
			Lookup[Flatten[masterMixPackets][[1]],Name]
		]
	];

	(* look up the name of the master mix *)
	quenchingReagentNames = If[MatchQ[quenchingReagent,Null|Automatic],
		"Null",
		quenchingReagent[Name]
	];
	
	resolvedPurificationType = Which[
		(* if the PurificationType is specified, accept it *)
		MatchQ[purificationType,Except[Automatic]],purificationType,
		(* if the PurificationType is left as Automatic and the quenching reagent and sequencing buffer are both null or Automatic and the plate is prepared, set to Null *)
		MatchQ[purificationType,Automatic]&&MatchQ[quenchingReagent,Automatic|ListableP[Null]|Null]&&MatchQ[sequencingBuffer,Automatic|ListableP[Null]]&&resolvedPreparedPlate,Null,
		(* if the PurificationType is Automatic, and QuenchingReagent and SequencingBuffer are Null, set to Null *)
		MatchQ[purificationType,Automatic]&&NullQ[quenchingReagent]&&NullQ[sequencingBuffer],Null,
		(* if the PurificationType is Automatic and the quenching reagent is Null or Automatic and a sequencing buffer is specified, set to Null *)
		MatchQ[purificationType,Automatic]&&MatchQ[quenchingReagent,Automatic|ListableP[Null]|Null]&&MatchQ[sequencingBuffer,ObjectP[{Model[Sample],Object[Sample]}]],Null,
		(* if the PurificationType is Automatic and the quenching reagent is Null or Automatic but a quenching reagent volume is specified, set to "Ethanol precipitation" *)
		MatchQ[purificationType,Automatic]&&MatchQ[quenchingReagent,Automatic|ListableP[Null]|Null]&&AllTrue[Flatten[{VolumeQ[quenchingReagentVolume]}],TrueQ],"Ethanol precipitation",
		(* if the PurificationType is left as Automatic and the quenching reagents specified are ethanol based, resolve to Ethanol precipitation *)
		MatchQ[purificationType,Automatic]&&AllTrue[Flatten[{StringContainsQ[quenchingReagentNames, "Ethanol", IgnoreCase -> True]}],TrueQ], "Ethanol precipitation",
		(* if the PurificationType is left as Automatic and the master mix name is BigDye, resolve to BigDye XTerminator *)
		MatchQ[purificationType,Automatic]&&AllTrue[Flatten[{StringContainsQ[masterMixName, "BigDye", IgnoreCase -> True]}],TrueQ], "BigDye XTerminator",
		(* if the PurificationType is left as Automatic and the master mix name is not BigDye, resolve to Ethanol precipitation *)
		MatchQ[purificationType,Automatic]&&!AllTrue[Flatten[{StringContainsQ[masterMixName, "BigDye", IgnoreCase -> True]}],TrueQ],"Ethanol precipitation"
	];

	(* initialize error trackers to False *)
	quenchingReagentNotSpecifiedError=False;
	sequencingBufferNotSpecifiedError=False;
	purificationTypeMismatchError=False;
	
	(* Resolve Quenching Reagent *)
	resolvedQuenchingReagents = Which[
		(* if the QuenchingReagent is specified as Null and the PurificationType is Null, accept it *)
		NullQ[quenchingReagent]&&NullQ[resolvedPurificationType],quenchingReagent,
		(* if the QuenchingReagent is specified and the PurificationType is specified, accept it *)
		MatchQ[quenchingReagent,{ObjectP[{Model[Sample],Object[Sample]}]..}]&&MatchQ[resolvedPurificationType,("BigDye XTerminator"|"Ethanol precipitation")],quenchingReagent,
		(* if the QuenchingReagent is Null but the PurificationType is not Null, throw an error *)
		NullQ[quenchingReagent]&&MatchQ[resolvedPurificationType,"Ethanol precipitation"|"BigDye XTerminator"],purificationTypeMismatchError=True;quenchingReagent,
		(* if the QuenchingReagent is left as Automatic and the PurificationType is BigDye XTerminator, Model[Sample,"SAM Solution"] and Model[Sample,"BigDye XTerminator"] *)
		MatchQ[quenchingReagent,Automatic]&&MatchQ[resolvedPurificationType,"BigDye XTerminator"], {Model[Sample,"SAM Solution"], Model[Sample,"BigDye XTerminator Solution"]},
		(* if the QuenchingReagent is left as Automatic and the PurificationType is Ethanol precipitation, resolve to Model[Sample,"Absolute Ethanol, Anhydrous"] and Model[Sample, StockSolution, "125 mM EDTA"] *)
		MatchQ[quenchingReagent,Automatic]&&MatchQ[resolvedPurificationType,"Ethanol precipitation"], {Model[Sample, "Absolute Ethanol, Anhydrous"], Model[Sample, StockSolution, "125 mM EDTA"]},
		(* if the QuenchingReagent is left as Automatic and the PurificationType is Null, but a QuenchingReagentVolume is specified, resolve to Model[Sample,"Absolute Ethanol, Anhydrous"] and Model[Sample, StockSolution, "125 mM EDTA"] to match the length of the list of volumes  *)
		MatchQ[quenchingReagent,Automatic]&&AllTrue[Flatten[{VolumeQ[quenchingReagentVolume]}],TrueQ]&&NullQ[resolvedPurificationType],PadRight[{Model[Sample,"Absolute Ethanol, Anhydrous"]},Length[Flatten[quenchingReagentVolume]],Model[Sample,StockSolution,"125 mM EDTA"]],
		True,Null
	];

	(*--Resolve QuenchingReagentVolume--*)
	resolvedQuenchingReagentVolumes=Which[
		(*If the QuenchingReagentVolume is not Null and not Automatic when QuenchingReagent is Null, flip the error switch*)
		MatchQ[quenchingReagentVolume,Except[(Automatic|Null)]]&&NullQ[resolvedQuenchingReagents],quenchingReagentNotSpecifiedError=True;quenchingReagentVolume,
		(* If the QuenchingReagent is a specified sample, and quenchingReagentVolume is Null, flip the error switch *)
		MatchQ[resolvedQuenchingReagents, {ObjectP[{Model[Sample], Object[Sample]}]..}]&&NullQ[quenchingReagentVolume],quenchingReagentNotSpecifiedError=True;quenchingReagentVolume,
		(*If the QuenchingReagentVolume is Null and QuenchingReagent is Null, accept it *)
		NullQ[quenchingReagentVolume]&&NullQ[resolvedQuenchingReagents],quenchingReagentVolume,
		(* If the length of the QuenchingReagent and QuenchingReagentVolume don't match, expanded the given volumes to match the length of the quenching reagent *)
		MatchQ[resolvedQuenchingReagents,{ObjectP[{Model[Sample], Object[Sample]}]..}]&&AllTrue[Flatten[{VolumeQ[quenchingReagentVolume]}],TrueQ]&&!MatchQ[Length[Flatten[resolvedQuenchingReagents]],Length[Flatten[quenchingReagentVolume]]],Join[Flatten[quenchingReagentVolume],ConstantArray[Last[Flatten[quenchingReagentVolume]],Abs[Length[Flatten[resolvedQuenchingReagents]]-Length[Flatten[quenchingReagentVolume]]]]],
		(*If the volume is specified, accept the value*)
		MatchQ[quenchingReagentVolume,Except[Automatic]],quenchingReagentVolume,
		(*If the volume is left as Automatic and QuenchingReagent is Null, resolve to Null *)
		MatchQ[quenchingReagentVolume,Automatic]&&NullQ[resolvedQuenchingReagents],Null,
		(*If the volume is left as Automatic and QuenchingReagent is not Null, resolve to {30 microliters, 1 microliter} *)
		MatchQ[quenchingReagentVolume,Automatic]&&MatchQ[resolvedQuenchingReagents,{Model[Sample, "Absolute Ethanol, Anhydrous"], Model[Sample, StockSolution, "125 mM EDTA"]}], {30 Microliter, 1 Microliter},
		(*If the volume is left as Automatic and QuenchingReagent is not Null, resolve to {4.5*ReactionVolume, ReactionVolume} *)
		MatchQ[quenchingReagentVolume,Automatic]&&MatchQ[resolvedQuenchingReagents,{Model[Sample,"SAM Solution"], Model[Sample,"BigDye XTerminator Solution"]}], {4.5*First[Flatten[{reactionVolume}]],First[Flatten[{reactionVolume}]]},
		(*If the volume is left as Automatic and QuenchingReagent is not Null, resolve to 40 Microliters *)
		MatchQ[quenchingReagentVolume,Automatic]&&!NullQ[resolvedQuenchingReagents],ConstantArray[40 Microliter,Length[resolvedQuenchingReagents]],
		True,Null
	];
	 
	(* Resolve Sequencing Buffer *)
	resolvedSequencingBuffer = Which[
		(* if the SequencingBuffer is specified as Null and the PurificationType is Null, accept it *)
		NullQ[sequencingBuffer]&&NullQ[resolvedPurificationType],sequencingBuffer,
		(* if the SequencingBuffer is specified and the PurificationType is Null, accept it *)
		MatchQ[sequencingBuffer,ObjectP[{Model[Sample],Object[Sample]}]]&&NullQ[resolvedPurificationType],sequencingBuffer,
		(* if the SequencingBuffer is specified and the PurificationType is specified as "Ethanol precipitation", accept it *)
		MatchQ[sequencingBuffer,ObjectP[{Model[Sample],Object[Sample]}]]&&MatchQ[resolvedPurificationType,"Ethanol precipitation"],sequencingBuffer,
		(* if the SequencingBuffer is Null but the PurificationType is "Ethanol precipitation", throw an error *)
		NullQ[sequencingBuffer]&&MatchQ[resolvedPurificationType,"Ethanol precipitation"],purificationTypeMismatchError=True;sequencingBuffer,
		(* if the SequencingBuffer is left as Automatic and the PurificationType is BigDye XTerminator, resolve to Null *)
		MatchQ[sequencingBuffer,Automatic]&&MatchQ[resolvedPurificationType,"BigDye XTerminator"], Null,
		(* if the SequencingBuffer is left as Automatic and the PurificationType is Ethanol precipitation, resolve to Model[Sample,"Tris EDTA 0.1 buffer solution"] *)
		MatchQ[sequencingBuffer,Automatic]&&MatchQ[resolvedPurificationType,"Ethanol precipitation"], Model[Sample,"Tris EDTA 0.1 buffer solution"],
		(* if the SequencingBuffer is left as Automatic and the PurificationType is Null, but a SequencingBufferVolume is specified, resolve to Model[Sample,"Hi-Di formamide"] *)
		MatchQ[sequencingBuffer,Automatic]&&VolumeQ[sequencingBufferVolume]&&NullQ[resolvedPurificationType], Model[Sample,"Hi-Di formamide"],
		True,Null
	];

	(*--Resolve SequencingBufferVolume--*)
	resolvedSequencingBufferVolume=Which[
		(*If the SequencingBufferVolume is not Null or Automatic when SequencingBuffer is Null, flip the error switch*)
		!MatchQ[sequencingBufferVolume,Automatic|Null]&&NullQ[resolvedSequencingBuffer],sequencingBufferNotSpecifiedError=True;sequencingBufferVolume,
		(* If the SequencingBuffer is a specified sample, and specifiedSequencingBufferVolume is Null, flip the error switch *)
		MatchQ[resolvedSequencingBuffer,ObjectP[{Model[Sample],Object[Sample]}]]&&NullQ[sequencingBufferVolume],sequencingBufferNotSpecifiedError=True;sequencingBufferVolume,
		(*If the volume is specified, accept the value*)
		MatchQ[sequencingBufferVolume,Except[Automatic]],sequencingBufferVolume,
		(*If the volume is left as Automatic and SequencingBuffer is Null, resolve to Null *)
		MatchQ[sequencingBufferVolume,Automatic]&&NullQ[resolvedSequencingBuffer],Null,
		(*If the volume is left as Automatic, resolve to 40 microliters *)
		MatchQ[sequencingBufferVolume,Automatic]&&!NullQ[resolvedSequencingBuffer],40 Microliter,
		True,Null
	];

	(*--PurificationType mismatch--*)

	(*If purificationTypeMismatchError=True and we are throwing messages, then throw an error message*)
	invalidPurificationTypeOptions=If[purificationTypeMismatchError&&messages,
		(
			Message[Error::DNASequencingPurificationTypeMismatch];
			{PurificationType,SequencingBuffer,QuenchingReagents}
		),
		{}
	];

	(*If we are gathering tests, create a test for PurificationType mismatch*)
	validPurificationTypeTest=If[gatherTests,
		Test["If PurificationType is not Null, the SequencingBuffer and QuenchingReagents are not Null accordingly:",
			!purificationTypeMismatchError,
			True
		],
		Nothing
	];


	(*--QuenchingReagent mismatch--*)

	(*If quenchingReagentNotSpecifiedError=True and we are throwing messages, then throw an error message*)
	invalidQuenchingReagentVolumeOptions=If[quenchingReagentNotSpecifiedError&&messages,
		(
			Message[Error::DNASequencingQuenchingReagentVolumeMismatch];
			{QuenchingReagents,QuenchingReagentVolumes}
		),
		{}
	];

	(*If we are gathering tests, create a test for QuenchingReagentVolume mismatch*)
	validQuenchingReagentVolumeTest=If[gatherTests,
		Test["If either of QuenchingReagents and QuenchingReagentVolumes are Null, the other is also Null:",
			!quenchingReagentNotSpecifiedError,
			True
		],
		Nothing
	];


	(*--SequencingBuffer mismatch--*)

	(*If sequencingBufferNotSpecifiedError=True and we are throwing messages, then throw an error message*)
	invalidSequencingBufferVolumeOptions=If[sequencingBufferNotSpecifiedError&&messages,
		(
			Message[Error::DNASequencingBufferVolumeMismatch];
			{SequencingBuffer,SequencingBufferVolume}
		),
		{}
	];

	(*If we are gathering tests, create a test for SequencingBufferVolume mismatch*)
	validSequencingBufferVolumeTest=If[gatherTests,
		Test["If either of SequencingBuffer and SequencingBufferVolume is Null, the other is also Null:",
			!sequencingBufferNotSpecifiedError,
			True
		],
		Nothing
	];

	(*update roundedDNASequencingOptions*)
	updatedRoundedDNASequencingOptions=Append[Association[ReplaceRule[Normal[roundedDNASequencingOptions], {QuenchingReagentVolumes -> resolvedQuenchingReagentVolumes, SequencingBufferVolume-> resolvedSequencingBufferVolume}]],{QuenchingReagents->resolvedQuenchingReagents,SequencingBuffer->resolvedSequencingBuffer}];



	(*---Resolve MapThread options---*)
	
	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentDNASequencing, Normal[updatedRoundedDNASequencingOptions]];

	(* if the sample composition is Null, get it from the model *)
	sampleOrModelCompositionPackets = If[MatchQ[sampleCompositionPackets,ListableP[Null]],
		sampleModelCompositionPackets,
		sampleCompositionPackets
	];
	
	(* download the sample compositions from our cache *)
	{sampleCompositionErrors,samplesMoleculeComposition} = Transpose[MapThread[
		Function[{packet,optionSet},
			Module[{typesMoleculesList,multipleSampleOligomersError,oligomerList,sequenceComposition,specifiedReadLength},

				(* find the types and molecules from the sample composition *)
				typesMoleculesList = If[!NullQ[#], Lookup[#, {Type, Molecule}], {Null}] & /@ Flatten[{packet}];

				(* initialize the error tracker to False *)
				multipleSampleOligomersError = False;

				(* select the components of the composition that are DNA molecules *)
				oligomerList = Select[typesMoleculesList,(First@#==Model[Molecule,Oligomer])&];

				(* determine if the ReadLength was specified by the user *)
				specifiedReadLength=Lookup[optionSet,ReadLength];

				(* if there are multiple oligomers in the sample composition, which sequence to use to
					resolve read length is ambigious and an error should be thrown and the composition is set to Null.
				 	if there is only one oligomer, get the molecule alone from the oligomer list *)
				sequenceComposition = Which[
					(* if the sample has multiple oligomers, but the user specified the ReadLength, don't need to throw the error *)
					Greater[Length[oligomerList],1]&&!MatchQ[specifiedReadLength,_Integer],multipleSampleOligomersError = True;Null,
					Greater[Length[oligomerList],1]&&MatchQ[specifiedReadLength,_Integer],multipleSampleOligomersError = False;Null,
					Length[oligomerList]==0,Null,
					True,Last[First[oligomerList]]
				];

				(* return the errors and and the sequence *)
				{MultipleSampleOligomersErrors -> multipleSampleOligomersError, sequenceComposition}
				]],
		{sampleOrModelCompositionPackets, mapThreadFriendlyOptions}
		]];

	sampleCompositionBools = Lookup[Merge[sampleCompositionErrors,Identity],MultipleSampleOligomersErrors];

	(* Get the samples from samplePackets that have multiple samples. *)
	multipleOligomerSamples = PickList[Lookup[samplePackets,Object], sampleCompositionBools];

	(* Set multipleSampleOligomersInputs to the input objects who contain multiple oligomers in the composition *)
	multipleSampleOligomersInputs = If[MatchQ[multipleOligomerSamples, {}],
		{},
		multipleOligomerSamples
	];

	(*If there are MultipleSampleOligomersSpecified errors and we are throwing messages, then throw an error message*)
	If[MemberQ[sampleCompositionBools,True]&&messages,
		(
			Message[Warning::MultipleSampleOligomersSpecified,ObjectToString[PickList[simulatedSamples,sampleCompositionBools],Cache->simulatedCache]]
		),
		{}
	];

	(*If we are gathering tests, create a test for Multiple Sample Oligomers Specified*)
	multipleSampleOligomersTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,sampleCompositionBools];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,sampleCompositionBools,False];

			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", the sample composition contains only one oligomer that the ReadLength can be resolved from:",False,True],
				Nothing
			];

			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Cache->simulatedCache]<>", the sample composition contains only one oligomer that the ReadLength can be resolved from:",True,True],
				Nothing
			];

			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(* resolve the read length *)
	{readLengthsWarningBooleans, resolvedReadLengthsRule, updatedMapThreadFriendlyOptions} = Transpose[MapThread[
		Function[{composition, optionSet},
		Module[{specifiedReadLength, readLength, readLengthNotSpecifiedWarning, sequenceLength, updatedOptions},

				(* look up the read length *)
				specifiedReadLength=Lookup[optionSet,ReadLength];

				(* initialize the error tracker to False *)
				readLengthNotSpecifiedWarning = False;

				(* attempt to determine the sequence length *)
				sequenceLength = Normal@@SequenceLength[ToSequence[composition]];

				(* resolve the read length *)
				readLength=Which[

					(*If the length is specified correctly, accept the value*)
					MatchQ[specifiedReadLength,Except[Automatic]],
					specifiedReadLength,

					(*If the length is left as Automatic and Composition field of the samples is Null, flip the warning switch and set the ReadLength to 500 base pairs *)
					MatchQ[specifiedReadLength,Automatic]&&MatchQ[composition, (Null|{})],
					readLengthNotSpecifiedWarning=True;
					500,

					(*If the length is left as Automatic and Composition field of the samples is not Null, resolve to SequenceLength[composition], unless SequenceLength fails, then return 500 *)
					MatchQ[specifiedReadLength,Automatic]&&MatchQ[composition, Except[(Null|{})]]&&MatchQ[sequenceLength,_Integer],
					sequenceLength,
					MatchQ[specifiedReadLength,Automatic]&&MatchQ[composition, Except[(Null|{})]]&&!MatchQ[sequenceLength,_Integer],
					readLengthNotSpecifiedWarning=True;500,

					(* if something is horribly wrong *)
					True,
					Null
				];

				(* update the options and make sure they are an association*)
				updatedOptions = Association@@ReplaceRule[Normal[optionSet], ReadLength->readLength];

				{ReadLengthNotSpecifiedWarnings -> readLengthNotSpecifiedWarning, ReadLength->readLength, updatedOptions}
				]
			],
			{samplesMoleculeComposition, mapThreadFriendlyOptions}
		]
	];
	
	(* look up the read lengths for resolved options *)
	resolvedReadLengths = Flatten[Lookup[updatedMapThreadFriendlyOptions, ReadLength]];



	(* MapThread *)
	{
		resolvedOptionsPackets,
		resolvedMapThreadErrorTrackerPackets
	}=Transpose[MapThread[
		Function[{primerPackets,updatedMapThreadFriendlyOptions,masterMixPacketVariable},
			Module[
				{
					(* prepared plate sample preparation resolved options *)
					mapThreadSampleVolume, mapThreadReactionVolume, mapThreadMasterMix,
					specifiedPrimerConcentration,resolvedPrimerConcentration,primerCompositionNullError,
					multiplePrimerSampleOligomersError,primerComposition,oligomerBools,oligomerList,primerCompositionTypes,initialPrimerConcentration,
					specifiedPrimerVolume,minResolvedPrimerVolume,resolvedPrimerVolume,
					primerStorageConditionError,specifiedPrimerStorageCondition,resolvedPrimerStorageCondition,
					specifiedMasterMixVolume,resolvedMasterMixVolume,masterMixNotSpecifiedError,
					masterMixStorageConditionError,specifiedMasterMixStorageCondition,resolvedMasterMixStorageCondition,
					specifiedDiluentVolume,mapThreadDiluent,resolvedDiluentVolume,diluentNotSpecifiedError,resolvedDiluent,
					totalVolumeTooLargeError,

					(* terminator resolution *)
					masterMixCompositions,specifiedAdenosineTriphosphateTerminator,resolvedAdenosineTriphosphateTerminator,resolvedThymidineTriphosphateTerminator,resolvedGuanosineTriphosphateTerminator,resolvedCytosineTriphosphateTerminator,specifiedThymidineTriphosphateTerminator, specifiedGuanosineTriphosphateTerminator, specifiedCytosineTriphosphateTerminator,
					masterMixName,dyeSetName,specifiedDyeSet,resolvedDyeSet,dyeSetUnknownError,

					(* capillary electrophoresis separation *)
					resolvedReadLength,specifiedInjectionVoltage,resolvedInjectionVoltage,resolvedRunVoltage,specifiedRunVoltage,resolvedRunTime,specifiedRunTime,

					(* output packets *)
					resolvedOptionsPacket, mapThreadErrorTrackerPacket
				},

				(*Initialize the error-tracking variables*)
				primerCompositionNullError=False;
				multiplePrimerSampleOligomersError=False;
				primerStorageConditionError=False;
				masterMixNotSpecifiedError=False;
				masterMixStorageConditionError=False;
				diluentNotSpecifiedError=False;
				totalVolumeTooLargeError=False;
				dyeSetUnknownError=False;


				(*Pull out what is specified *)
				{
					specifiedPrimerConcentration,
					specifiedPrimerVolume,
					specifiedPrimerStorageCondition,
					mapThreadSampleVolume,
					mapThreadReactionVolume,
					mapThreadMasterMix,
					specifiedMasterMixVolume,
					specifiedMasterMixStorageCondition,
					mapThreadDiluent,
					specifiedDiluentVolume,
					specifiedAdenosineTriphosphateTerminator,
					specifiedThymidineTriphosphateTerminator,
					specifiedGuanosineTriphosphateTerminator,
					specifiedCytosineTriphosphateTerminator,
					resolvedReadLength,
					specifiedDyeSet,
					specifiedInjectionVoltage,
					specifiedRunVoltage,
					specifiedRunTime
				}=Lookup[
					updatedMapThreadFriendlyOptions,
					{
						PrimerConcentration,
						PrimerVolume,
						PrimerStorageCondition,
						SampleVolume,
						ReactionVolume,
						MasterMix,
						MasterMixVolume,
						MasterMixStorageCondition,
						Diluent,
						DiluentVolume,
						AdenosineTriphosphateTerminator,
						ThymidineTriphosphateTerminator,
						GuanosineTriphosphateTerminator,
						CytosineTriphosphateTerminator,
						ReadLength,
						DyeSet,
						InjectionVoltage,
						RunVoltage,
						RunTime
					}
				];

				(*--Resolve PCR Sample Preparation options--*)

				(*Resolve PrimerConcentration*)
				resolvedPrimerConcentration=Which[
					(*If the PrimerConcentration is Null, accept it (will throw the error PreparedPlateMismatch)*)
					NullQ[specifiedPrimerConcentration],specifiedPrimerConcentration,
					(*If the concentration is specified, accept the value*)
					MatchQ[specifiedPrimerConcentration,Except[Automatic]],specifiedPrimerConcentration,
					(*If the concentration is left as Automatic and resolvedPreparedPlate is True, resolve to Null*)
					MatchQ[specifiedPrimerConcentration,Automatic]&&TrueQ[resolvedPreparedPlate],Null,
					(*If the concentration is left as Automatic and resolvedPreparedPlate is False, resolve to 0.1 micromolar*)
					MatchQ[specifiedPrimerConcentration,Automatic]&&!TrueQ[resolvedPreparedPlate],0.1 Micromolar,
					True,Null
				];

				(*Resolve PrimerVolume*)
				(* look up the composition of the primer *)
				primerComposition = If[NullQ[primerPackets],Null,Lookup[primerPackets, Composition]];

				(* look up the types in the composition of the primer *)
				primerCompositionTypes = If[NullQ[primerPackets],
					Null,
					If[
						NullQ[Flatten[primerComposition]],
						Null,
						If[MatchQ[#,ObjectP[]],Download[#,Type,Cache->simulatedCache],Model[Molecule]]&/@Map[Last,primerComposition]
					]
				];

				(* Create a selector list for items on the composition list that are oligomers *)
				oligomerBools = If[NullQ[primerPackets]||NullQ[Flatten[primerComposition]],
					Null,
					If[MatchQ[#, Model[Molecule, Oligomer]], True, False] & /@ primerCompositionTypes
				];

				(* select the components of the composition that are DNA molecules *)
				oligomerList = PickList[primerComposition,oligomerBools];

				initialPrimerConcentration = Which[
					(* if the primer samples or compositions are Null, the concentration is Null *)
					NullQ[primerPackets]||NullQ[Flatten[primerComposition]], Null,
					(* if the length of the oligomer list is greater than 1, there are multiple oligomers in
					the primer sample composition, and which concentration to use to resolve primer volume is
					ambigious so throw the error and set the composition to Null.*)
					Greater[Length[oligomerList],1], multiplePrimerSampleOligomersError = True;Null,
					(* if there is only one oligomer (Length=1), get the concentration alone from the oligomer list *)
					MatchQ[Length[oligomerList],1],First[First[oligomerList]],
					True,Null
				];

				minResolvedPrimerVolume=Which[
					(*If the PrimerVolume is Null, accept it (will throw the error PreparedPlateMismatch)*)
					NullQ[specifiedPrimerVolume],specifiedPrimerVolume,
					(*If the volume is specified, accept the value. If the PrimerVolume was specified, no longer need to throw multiplePrimerSampleOligomersError *)
					MatchQ[specifiedPrimerVolume,Except[Automatic]],multiplePrimerSampleOligomersError = False;specifiedPrimerVolume,
					(*If the volume is left as Automatic and resolvedPreparedPlate is True, resolve to Null*)
					MatchQ[specifiedPrimerVolume,Automatic]&&TrueQ[resolvedPreparedPlate],Null,
					(*If the volume is left as Automatic, resolvedPreparedPlate is False, and Composition field of the primer samples is Null, flip the error switch*)
					MatchQ[specifiedPrimerVolume,Automatic]&&!TrueQ[resolvedPreparedPlate]&&(NullQ[primerComposition]||NullQ[initialPrimerConcentration]),primerCompositionNullError=True;specifiedPrimerVolume,
					(*If the volume is left as Automatic, resolvedPreparedPlate is False, and Composition field of the primer samples is not Null, resolve to PrimerConcentration*ReactionVolume/initialPrimerConcentration *)
					MatchQ[specifiedPrimerVolume,Automatic]&&!TrueQ[resolvedPreparedPlate]&&!NullQ[primerComposition],SafeRound[Convert[(resolvedPrimerConcentration*mapThreadReactionVolume/initialPrimerConcentration),Microliter],0.1 Microliter],
					True,Null
				];

				(* ensure that the primer volume is resolved to a value greater than 1 microliter so that it can be pipetted accurately *)
				resolvedPrimerVolume = Which[
					VolumeQ[minResolvedPrimerVolume]&&GreaterEqual[minResolvedPrimerVolume,1Microliter],minResolvedPrimerVolume,
					VolumeQ[minResolvedPrimerVolume]&&Less[minResolvedPrimerVolume,1Microliter],1Microliter,
					True,minResolvedPrimerVolume
				];

				(*Resolve PrimerStorageCondition*)
				resolvedPrimerStorageCondition=Which[
					(*If the storage condition is Null, accept it*)
					NullQ[specifiedPrimerStorageCondition],specifiedPrimerStorageCondition,
					(*If the storage condition is specified and primer input is Null, flip the error switch*)
					!NullQ[specifiedPrimerStorageCondition]&&NullQ[myPrimerSamples],primerStorageConditionError=True;specifiedPrimerStorageCondition,
					(*If the storage condition is specified and primer input is not Null, accept it *)
					!NullQ[specifiedPrimerStorageCondition]&&!NullQ[myPrimerSamples],specifiedPrimerStorageCondition,
					True,Null
				];

				(*Resolve MasterMixVolume*)
				resolvedMasterMixVolume=Which[
					(*If the MasterMixVolume is not Null or Automatic when MasterMix is Null, flip the error switch*)
					(!NullQ[specifiedMasterMixVolume]&&MatchQ[specifiedMasterMixVolume,Except[Automatic]])&&NullQ[mapThreadMasterMix],masterMixNotSpecifiedError=True;specifiedMasterMixVolume,
					(* If the MasterMix is a specified sample, and MasterMixVolume is specified as Null, flip the error switch *)
					MatchQ[mapThreadMasterMix,ObjectP[{Model[Sample],Object[Sample]}]]&&NullQ[specifiedMasterMixVolume],masterMixNotSpecifiedError=True;specifiedMasterMixVolume,
					(* If MasterMixVolume is Null when MasterMix is also Null, accept it *)
					NullQ[specifiedMasterMixVolume]&&NullQ[mapThreadMasterMix],specifiedMasterMixVolume,
					(*If the volume is specified, accept the value*)
					MatchQ[specifiedMasterMixVolume,Except[Automatic]],specifiedMasterMixVolume,
					(*If the volume is left as Automatic and resolvedPreparedPlate is True, resolve to Null*)
					MatchQ[specifiedMasterMixVolume,Automatic]&&TrueQ[resolvedPreparedPlate],Null,
					(* If MasterMix is set to Null, set the MasterMixVolume to Null *)
					MatchQ[specifiedMasterMixVolume,Automatic]&&NullQ[mapThreadMasterMix],Null,
					(*If the volume is left as Automatic and resolvedPreparedPlate is False, resolve to 0.5*mapThreadReactionVolume *)
					MatchQ[specifiedMasterMixVolume,Automatic]&&!TrueQ[resolvedPreparedPlate],SafeRound[Convert[0.5*mapThreadReactionVolume,Microliter],0.1 Microliter],
					True,Null
				];

				(*Resolve MasterMixStorageCondition*)
				resolvedMasterMixStorageCondition=Which[
					(*If the storage condition is Null, accept it*)
					NullQ[specifiedMasterMixStorageCondition],specifiedMasterMixStorageCondition,
					(*If the storage condition is specified and MasterMix is Null, flip the error switch*)
					!NullQ[specifiedMasterMixStorageCondition]&&NullQ[masterMix],masterMixStorageConditionError=True;specifiedMasterMixStorageCondition,
					(*If the storage condition is specified and MasterMix is not Null, accept it *)
					!NullQ[specifiedMasterMixStorageCondition]&&!NullQ[masterMix],specifiedMasterMixStorageCondition,
					True,Null
				];
				
				(*Resolve DiluentVolume*)
				resolvedDiluentVolume=Which[
					(*If the DiluentVolume is not Null or Automatic when Diluent is Null, flip the Error switch*)
					!NullQ[specifiedDiluentVolume]&&MatchQ[specifiedDiluentVolume,Except[Automatic]]&&NullQ[diluent],diluentNotSpecifiedError=True;specifiedDiluentVolume,
					(* If the Diluent is a specified sample, and DiluentVolume is specified as Null, flip the error switch *)
					MatchQ[diluent,ObjectP[{Model[Sample],Object[Sample]}]]&&!NullQ[diluentVolume],diluentNotSpecifiedError=True;specifiedDiluentVolume,
					(*If the DiluentVolume is Null and Diluent is Null, accept it *)
					NullQ[specifiedDiluentVolume]&&NullQ[diluent],specifiedDiluentVolume,
					(*If the volume is specified, accept the value*)
					MatchQ[specifiedDiluentVolume,Except[Automatic]],specifiedDiluentVolume,
					(*If the volume is left as Automatic and resolvedPreparedPlate is True, resolve to Null*)
					MatchQ[specifiedDiluentVolume,Automatic]&&TrueQ[resolvedPreparedPlate],Null,
					(*If the volume is left as Automatic and resolvedPreparedPlate is False, resolve to ReactionVolume - (SampleVolume + MasterMixVolume + PrimerVolume) *)
					MatchQ[specifiedDiluentVolume,Automatic]&&!TrueQ[resolvedPreparedPlate]&&Total[Flatten[{resolvedMasterMixVolume,mapThreadSampleVolume,resolvedPrimerVolume}/.Null->0 Microliter]]<mapThreadReactionVolume,SafeRound[Convert[mapThreadReactionVolume-Total[Flatten[{resolvedMasterMixVolume,mapThreadSampleVolume,resolvedPrimerVolume}/.Null->0 Microliter]],Microliter],0.1 Microliter],
					True,Null
				];


				(* Resolve Diluent *)
				resolvedDiluent=Which[
					(* If the Diluent is specified, accept the value *)
					MatchQ[mapThreadDiluent,Except[Automatic]],mapThreadDiluent,
					(* If resolvedDiluentVolume is a volume, and the diluent is left as Automatic, resolve to Model[Sample,"Nuclease-free Water"] *)
					MatchQ[mapThreadDiluent,Automatic]&&VolumeQ[resolvedDiluentVolume],Model[Sample,"Nuclease-free Water"],
					(* If diluent is left as Automatic and resolvedDiluentVolume is Null, set the diluent to Null *)
					MatchQ[mapThreadDiluent,Automatic]&&NullQ[resolvedDiluentVolume],Null,
					True,Null
				];
				 
				(*If the total volume exceeds ReactionVolume, flip the error switch*)
				totalVolumeTooLargeError=If[Total[Flatten[{resolvedMasterMixVolume,mapThreadSampleVolume,resolvedPrimerVolume,resolvedDiluentVolume}/.Null->0 Microliter]]>mapThreadReactionVolume,True,False];

				(* look up master mix name *)
				masterMixName = If[NullQ[masterMixPacketVariable],
					"Null",
					If[
						MatchQ[Lookup[Flatten[masterMixPacketVariable][[1]],Name],{}|Null],
						"Null",
						Lookup[Flatten[masterMixPacketVariable][[1]],Name]
					]
				];

				(* resolve dye set name based on master mix name *)
				dyeSetName = Which[
					(*If the dye set is specified, accept the value*)
					MatchQ[specifiedDyeSet,Except[Automatic]],specifiedDyeSet,
					(* if the master mix is null, the dye set cannot be determined, throw the error *)
					NullQ[masterMix]&&MatchQ[specifiedDyeSet,Automatic],dyeSetUnknownError=True;specifiedDyeSet,
					(* if the master mix name contains BigDye and E or v1.1, resolve to "E_BigDye Terminator v1.1"*)
					Normal@@StringContainsQ[masterMixName,"BigDye",IgnoreCase->True]&&Normal@@StringContainsQ[masterMixName,Alternatives["v1.1","E"]], "E_BigDye Terminator v1.1",
					(* if the master mix name contains BigDye and v3.1, resolve to "Z_BigDye Terminator v3.1"*)
					Normal@@StringContainsQ[masterMixName,"BigDye",IgnoreCase->True]&&Normal@@StringContainsQ[masterMixName,"v3.1"], "Z_BigDye Terminator v3.1",
					(* if the master mix name contains BigDye and Direct, resolve to "Z_BigDye Direct"*)
					Normal@@StringContainsQ[masterMixName,"BigDye",IgnoreCase->True]&&Normal@@StringContainsQ[masterMixName,"Direct",IgnoreCase->True], "Z_BigDye Direct",
					(* if none of these are true, the dye set is unknown, so set it to Null *)
					True,dyeSetUnknownError=True;Null
				];

				(*Resolve DyeSet *)
				resolvedDyeSet=Which[
					(*If the dye set is specified, accept the value*)
					MatchQ[specifiedDyeSet,Except[Automatic]],specifiedDyeSet,
					(*If dye set is left as Automatic and the MasterMix composition is Null, flip the error switch*)
					MatchQ[specifiedDyeSet,Automatic]&&MatchQ[masterMixCompositions,(Null|{})],dyeSetUnknownError=True;specifiedDyeSet,
					(*If the dye terminator is left as Automatic, resolve based on Master Mix name *)
					MatchQ[specifiedDyeSet,Automatic]&&MatchQ[masterMixCompositions,Except[Null|{}]],dyeSetName,
					True,Null
				];

				(*--Resolve Dye terminators--*)

				(*Resolve AdenosineTriphosphateTerminator *)
				resolvedAdenosineTriphosphateTerminator=Which[
					(*If the dye terminator is specified, accept the value*)
					MatchQ[specifiedAdenosineTriphosphateTerminator,Except[Automatic]],specifiedAdenosineTriphosphateTerminator,
					(*If dye terminator is left as Automatic and the dye set is unknown, set to Null *)
					MatchQ[specifiedAdenosineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet,Except["E_BigDye Terminator v1.1"| "Z_BigDye Terminator v3.1"| "Z_BigDye Direct"]],Null,
					(*If the dye terminator is left as Automatic, resolve based on DyeSet *)
					MatchQ[specifiedAdenosineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet, "E_BigDye Terminator v1.1"],Model[Molecule,"ddA 5-dR6G Terminator Dye"],
					MatchQ[specifiedThymidineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet,"Z_BigDye Direct"],Model[ProprietaryFormulation, "BigDye Direct adenosine triphosphate terminator"],
					MatchQ[specifiedThymidineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet,"Z_BigDye Terminator v3.1"],Model[ProprietaryFormulation, "BigDye Terminator v3.1 adenosine triphosphate terminator"],
					True,Null
				];

				(*Resolve ThymidineTriphosphateTerminator *)
				resolvedThymidineTriphosphateTerminator=Which[
					(*If the dye terminator is specified, accept the value*)
					MatchQ[specifiedThymidineTriphosphateTerminator,Except[Automatic]],specifiedThymidineTriphosphateTerminator,
					(*If dye terminator is left as Automatic and the dye set is unknown, set to Null *)
					MatchQ[specifiedThymidineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet,Except["E_BigDye Terminator v1.1"| "Z_BigDye Terminator v3.1"| "Z_BigDye Direct"]],Null,
					(*If the dye terminator is left as Automatic, resolve based on DyeSet *)
					MatchQ[specifiedThymidineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet, "E_BigDye Terminator v1.1"],Model[Molecule,"ddT 6dROX Terminator Dye"],
					MatchQ[specifiedThymidineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet,"Z_BigDye Direct"],Model[ProprietaryFormulation, "BigDye Direct thymidine triphosphate terminator"],
					MatchQ[specifiedThymidineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet,"Z_BigDye Terminator v3.1"],Model[ProprietaryFormulation, "BigDye Terminator v3.1 thymidine triphosphate terminator"],
					True,Null
				];

				(*Resolve GuanosineTriphosphateTerminator *)
				resolvedGuanosineTriphosphateTerminator=Which[
					(*If the dye terminator is specified, accept the value*)
					MatchQ[specifiedGuanosineTriphosphateTerminator,Except[Automatic]],specifiedGuanosineTriphosphateTerminator,
					(*If dye terminator is left as Automatic and the dye set is unknown, set to Null *)
					MatchQ[specifiedGuanosineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet,Except["E_BigDye Terminator v1.1"| "Z_BigDye Terminator v3.1"|"Z_BigDye Direct"]],Null,
					(*If the dye terminator is left as Automatic, resolve based on DyeSet *)
					MatchQ[specifiedGuanosineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet, "E_BigDye Terminator v1.1"],Model[Molecule,"ddG dR110 Terminator Dye"],
					MatchQ[specifiedThymidineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet,"Z_BigDye Direct"],Model[ProprietaryFormulation, "BigDye Direct guanosine triphosphate terminator"],
					MatchQ[specifiedThymidineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet,"Z_BigDye Terminator v3.1"],Model[ProprietaryFormulation, "BigDye Terminator v3.1 guanosine triphosphate terminator"],
					True,Null
				];

				(*Resolve CytosineTriphosphateTerminator *)
				resolvedCytosineTriphosphateTerminator=Which[
					(*If the dye terminator is specified, accept the value*)
					MatchQ[specifiedCytosineTriphosphateTerminator,Except[Automatic]],specifiedCytosineTriphosphateTerminator,
					(*If dye terminator is left as Automatic and the dye set is unknown, set to Null *)
					MatchQ[specifiedThymidineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet,Except["E_BigDye Terminator v1.1"| "Z_BigDye Terminator v3.1"| "Z_BigDye Direct"]],Null,
					(*If the dye terminator is left as Automatic, resolve based on DyeSet *)
					MatchQ[specifiedThymidineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet, "E_BigDye Terminator v1.1"],Model[Molecule,"ddC 5-dTMR Terminator Dye"],
					MatchQ[specifiedThymidineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet,"Z_BigDye Direct"],Model[ProprietaryFormulation, "BigDye Direct cytosine triphosphate terminator"],
					MatchQ[specifiedThymidineTriphosphateTerminator,Automatic]&&MatchQ[resolvedDyeSet,"Z_BigDye Terminator v3.1"],Model[ProprietaryFormulation, "BigDye Terminator v3.1 cytosine triphosphate terminator"],
					True,Null
				];


				(*--Resolve capillary electrophoresis options--*)

				(*Resolve InjectionVoltage*)
				resolvedInjectionVoltage=Which[
					(*If the InjectionVoltage is specified, accept the value*)
					MatchQ[specifiedInjectionVoltage,Except[Automatic]],specifiedInjectionVoltage,
					(*If the voltage is left as Automatic and ReadLength is greater than 600, resolve to 1400 volts *)
					MatchQ[specifiedInjectionVoltage,Automatic]&&Greater[resolvedReadLength,600],1400 Volt,
					(*If the voltage is left as Automatic and ReadLength is less than 600, resolve to 1200 volts *)
					MatchQ[specifiedInjectionVoltage,Automatic]&&LessEqual[resolvedReadLength,600],1200 Volt,
					True,Null
				];

				(*Resolve RunVoltage*)
				resolvedRunVoltage=Which[
					(*If the RunVoltage is specified, accept the value*)
					MatchQ[specifiedRunVoltage,Except[Automatic]],specifiedRunVoltage,
					(*If the voltage is left as Automatic and ReadLength is less than 300, resolve to 12000 volts *)
					MatchQ[specifiedRunVoltage,Automatic]&&LessEqual[resolvedReadLength,300],12000 Volt,
					(*If the voltage is left as Automatic and ReadLength is greater than 600, resolve to 4000 volts *)
					MatchQ[specifiedRunVoltage,Automatic]&&Greater[resolvedReadLength,600],4000 Volt,
					(*If the voltage is left as Automatic and ReadLength is greater than 300 and less than 600, resolve to 9000 volts *)
					MatchQ[specifiedRunVoltage,Automatic]&&Greater[resolvedReadLength,300]&&LessEqual[resolvedReadLength,600],9000 Volt,
					True,Null
				];

				(*Resolve RunTime*)
				resolvedRunTime=Which[
					(*If the RunTime is specified, accept the value*)
					MatchQ[specifiedRunTime,Except[Automatic]],specifiedRunTime,
					(*If the time is left as Automatic and ReadLength is less than 300, resolve to 760 seconds *)
					MatchQ[specifiedRunTime,Automatic]&&LessEqual[resolvedReadLength,300],760 Second,
					(*If the time is left as Automatic and ReadLength is greater than 600, resolve to 5140 seconds *)
					MatchQ[specifiedRunTime,Automatic]&&Greater[resolvedReadLength,600],5140 Second,
					(*If the time is left as Automatic and ReadLength is greater than 300 and less than 600, resolve to 1380 seconds *)
					MatchQ[specifiedRunTime,Automatic]&&Greater[resolvedReadLength,300]&&LessEqual[resolvedReadLength,600],1380 Second,
					True,Null
				];


				(* Return resolved options and error trackers packet *)
				resolvedOptionsPacket = <|
					SampleVolume -> mapThreadSampleVolume,
					ReactionVolume -> mapThreadReactionVolume,
					PrimerConcentration -> resolvedPrimerConcentration,
					PrimerVolume -> resolvedPrimerVolume,
					PrimerStorageCondition -> resolvedPrimerStorageCondition,
					MasterMixVolume -> resolvedMasterMixVolume,
					MasterMixStorageCondition -> resolvedMasterMixStorageCondition,
					DiluentVolume -> resolvedDiluentVolume,
					Diluent -> resolvedDiluent,
					AdenosineTriphosphateTerminator -> resolvedAdenosineTriphosphateTerminator,
					ThymidineTriphosphateTerminator -> resolvedThymidineTriphosphateTerminator,
					GuanosineTriphosphateTerminator -> resolvedGuanosineTriphosphateTerminator,
					CytosineTriphosphateTerminator -> resolvedCytosineTriphosphateTerminator,
					DyeSet -> resolvedDyeSet,
					InjectionVoltage -> resolvedInjectionVoltage,
					RunVoltage -> resolvedRunVoltage,
					RunTime -> resolvedRunTime

				|>;

				mapThreadErrorTrackerPacket = <|
					PrimerCompositionNullErrors -> primerCompositionNullError,
					MultiplePrimerSampleOligomersErrors -> multiplePrimerSampleOligomersError,
					PrimerStorageConditionErrors -> primerStorageConditionError,
					MasterMixNotSpecifiedErrors -> masterMixNotSpecifiedError,
					MasterMixStorageConditionErrors -> masterMixStorageConditionError,
					DiluentNotSpecifiedErrors -> diluentNotSpecifiedError,
					TotalVolumeTooLargeErrors -> totalVolumeTooLargeError,
					DyeSetUnknownErrors -> dyeSetUnknownError
				|>;

				{resolvedOptionsPacket, mapThreadErrorTrackerPacket}
			]
		],
		{primerSamplePackets,updatedMapThreadFriendlyOptions,masterMixPackets}
	]
	];

	(* merge the resolved options and error trackers *)
	allResolvedMapThreadOptionsAssociation = MapThread[Append[#1, #2] &, {updatedMapThreadFriendlyOptions, resolvedOptionsPackets}];
	allErrorTrackersAssociation = Append[Merge[resolvedMapThreadErrorTrackerPackets,Identity],Merge[readLengthsWarningBooleans,Identity]];

	(*--------------------------------*)
	(* Independent options resolution *)
	(*--------------------------------*)
	 
	(*--InjectionGroups resolution--*)
	(* resolve the injection groups based on the user specified options and ReadLength *)
	{
		resolvedInjectionGroups,
		tooManyInjectionGroups,
		injectionGroupsSettingsMismatchWarning,
		injectionGroupsLengthWarnings,
		injectionGroupsSamplesWarning,
		injectionGroupsOptionsAmbiguousWarning
	} = Module[
		{
			separationOptions,resolvedReadLengths,sequencingBuffer,numberOfWells, specifiedInjectionGroups, injectionGroupsSamplesWarning,
			injectionGroupsSamplesLengthQ, allSamplesInInjectionGroupsQ,
			injectionGroupsLengths,injectionGroupsSettingsMismatchWarning,injectionGroupsLengthWarning,injectionGroupsMatchedRules,
			emptyWellBuffer,numberOfCapillaries,sampleToParametersRules,emptyWellBufferToParametersRules, samples,
			groupedSampleToParameterRules,tooManyInjectionGroupsError,flattenedPartitionedSampleToParameterRules,partitionedSampleToParametersRules,
			paddedSampleToParametersRules,regroupedSampleToParametersRules,anyInjectionWarningsQ,injectionGroupsOptionsAmbiguousWarning
		},

		(* look up the separation options *)
		separationOptions = Lookup[allResolvedMapThreadOptionsAssociation, {DyeSet,PrimeTime,PrimeVoltage,InjectionTime,InjectionVoltage,RampTime,RunVoltage,RunTime}];

		(* look up the read lengths *)
		resolvedReadLengths = Lookup[allResolvedMapThreadOptionsAssociation, ReadLength];

		(* initialize warnings *)
		{injectionGroupsSettingsMismatchWarning,
			injectionGroupsLengthWarning,
			injectionGroupsSamplesWarning,
			injectionGroupsOptionsAmbiguousWarning} = {False,False,False,False};

		(* look up the Sequencing Buffer *)
		sequencingBuffer = First[Lookup[allResolvedMapThreadOptionsAssociation, SequencingBuffer]];

		(* look up the NumberOfWells from the sample container packets *)
		numberOfWells = 96;

		(* look up specified injection groups *)
		specifiedInjectionGroups = Lookup[updatedRoundedDNASequencingOptions, InjectionGroups]/.Automatic->{Automatic};

		(* get the sample objects *)
		samples = Download[mySamples,Object];

		(* check that all samples are in injection groups and the lengths match *)
		injectionGroupsSamplesLengthQ = If[
			MatchQ[specifiedInjectionGroups,Except[{Automatic}|Automatic]],
			MatchQ[Length[samples],Length[Flatten[specifiedInjectionGroups]]],
			True
		];

		(* make sure all samples are in injection groups *)
		allSamplesInInjectionGroupsQ = If[
			MatchQ[specifiedInjectionGroups,Except[{Automatic}|Automatic]],
			ContainsAll[Flatten[specifiedInjectionGroups],samples],
			True
		];

		(* if either check is True, throw warning *)
		injectionGroupsSamplesWarning = Or[
			!injectionGroupsSamplesLengthQ,
			!allSamplesInInjectionGroupsQ
		];

		(* check the lengths of the injection groups *)
		injectionGroupsLengths = Map[Length, specifiedInjectionGroups];

		(* look up the Number of capillaries *)
		numberOfCapillaries = Normal@@Lookup[Flatten[sequencingCartridgePacket],NumberOfCapillaries];

		(* if the length is more than 4, set the warning to True *)
		injectionGroupsLengthWarning = If[#>numberOfCapillaries,True,False]&/@injectionGroupsLengths;

		(* sequencing buffer will be used to fill empty wells in injection groups because injecting air into the capillaries will damage them. If sequencing buffer is Null, Model[Sample,"Hi-Di Formamide"] will be used *)
		emptyWellBuffer = If[MatchQ[sequencingBuffer, ObjectP[{Model[Sample], Object[Sample]}]],sequencingBuffer,Model[Sample,"Hi-Di formamide"]];

		(* turn the list of samples into a list of samples and their separation option parameters *)
		sampleToParametersRules = MapThread[(#1->#2)&, {samples, separationOptions}];
		
		(* turn the emptyWellBuffer into a list of samples and their separation option parameters *)
		emptyWellBufferToParametersRules = emptyWellBuffer -> First[separationOptions];

		(* check the options of the specified injection groups to make sure they are the same *)
		{injectionGroupsMatchedRules,injectionGroupsSettingsMismatchWarning,injectionGroupsOptionsAmbiguousWarning} = If[
			MatchQ[specifiedInjectionGroups,Except[{Automatic}|Automatic]],
			Check[
				Module[{matchingInjectionOptionsQ,specifiedInjectionGroupsParameters,uniqueSpecifiedInjectionGroupsParameters,
					uniqueSpecifiedInjectionGroupsParametersLengths,injectionGroupsWarning,optionsAmbiguousWarning},

					(* initialize warning *)
					optionsAmbiguousWarning = False;

					(* check if duplicate samples have the same options or different options *)
					matchingInjectionOptionsQ = If[
						MatchQ[Length[DeleteDuplicates[samples]],Length[DeleteDuplicates[sampleToParametersRules]]],
						True,
						False
					];

					(* replace the injection groups with the rules to check if the options all match *)
					specifiedInjectionGroupsParameters = Which[
						(* if all of the samples are different, rules can be looked up from the sample parameter rules *)
						DuplicateFreeQ[samples], specifiedInjectionGroups/. (x:ObjectP[]) :> x -> Lookup[sampleToParametersRules,x],
						(* if any samples are duplicated and they are in the sample order as the samples, then partition the rules list in the same way as the injection groups *)
						!DuplicateFreeQ[samples]&&MatchQ[samples,Flatten[specifiedInjectionGroups]],FoldPairList[TakeDrop,sampleToParametersRules,injectionGroupsLengths],
						(* If any of the samples are the same and the samples in are in a different order than the injection groups, but the same samples have same options,
						they can be looked up from the sample parameter rules list *)
						!DuplicateFreeQ[samples]&&!MatchQ[samples,Flatten[specifiedInjectionGroups]]&&matchingInjectionOptionsQ,specifiedInjectionGroups/. (x:ObjectP[]) :> x -> Lookup[sampleToParametersRules,x],
						(* If any of the samples are the same and the samples in are in a different order than the injection groups, and the same samples have different options,
						throw a warning because it is unclear which options correspond to which identical sample *)
						!DuplicateFreeQ[samples]&&!MatchQ[samples,Flatten[specifiedInjectionGroups]]&&!matchingInjectionOptionsQ,optionsAmbiguousWarning=True;{},
						True,optionsAmbiguousWarning=True;{}
					];

					(* delete any duplicates of specified injection groups matched with parameters to ensure all parameters match *)
					uniqueSpecifiedInjectionGroupsParameters = DeleteDuplicates[#]&/@specifiedInjectionGroupsParameters;

					(* check if the length of the lists is longer than one. If so, the injection group parameters don't match *)
					uniqueSpecifiedInjectionGroupsParametersLengths = Map[Length,uniqueSpecifiedInjectionGroupsParameters];
					injectionGroupsWarning = If[#>1,True,False]&/@uniqueSpecifiedInjectionGroupsParametersLengths;

					{specifiedInjectionGroupsParameters,injectionGroupsWarning,optionsAmbiguousWarning}
				],
				(* if there are any errors thrown, set the warning to true and created injection groups from scratch *)
				{{},True,False}
			],
			{{},False,False}
		];

		(* Gather the samples into groups of matching separation options *)
		groupedSampleToParameterRules = GatherBy[sampleToParametersRules, Last[#]&];

		(* if the length of groupedSampleToParameterRules is longer than the number of groups that can fit on the plate (numberOfWells/numberOfCapillaries), throw an error *)
		tooManyInjectionGroupsError = If[Length[groupedSampleToParameterRules]>Normal@@(numberOfWells/numberOfCapillaries),True,False];

		(* Partition the list into groups of matching parameters up to the number of capillaries in the sequencing cartridge *)
		partitionedSampleToParametersRules = Map[Partition[#,UpTo[numberOfCapillaries]]&,groupedSampleToParameterRules];

		(* remove some of nested lists *)
		flattenedPartitionedSampleToParameterRules = If[
			Length[Flatten[partitionedSampleToParametersRules,{2}]]==1,
			First[Flatten[partitionedSampleToParametersRules,{2}]],
			First/@Flatten[partitionedSampleToParametersRules,{2}]
		];

	 	(* check if any warnings have been thrown *)
		anyInjectionWarningsQ = Or[
			MemberQ[injectionGroupsSettingsMismatchWarning,True],
			MemberQ[injectionGroupsLengthWarning,True],
			injectionGroupsOptionsAmbiguousWarning,
			injectionGroupsSamplesWarning
		];

		(* pad injection groups with emptyWellBufferToParametersRules based on the number of capillaries. If the specified injection groups *)
		paddedSampleToParametersRules = Map[
			PadRight[#,numberOfCapillaries,emptyWellBufferToParametersRules]&,
			If[
				(anyInjectionWarningsQ||MatchQ[specifiedInjectionGroups,{Automatic}|Automatic]),
				flattenedPartitionedSampleToParameterRules,
				injectionGroupsMatchedRules
			]
		];

		(* flatten to get rid of nested lists, and re-group by number of capillaries to get injection groups *)
		regroupedSampleToParametersRules = Partition[Flatten[paddedSampleToParametersRules],numberOfCapillaries];
		 
		(* grab the keys, which are the grouped samples and return errors and warnings *)
		{Keys/@regroupedSampleToParametersRules,
			tooManyInjectionGroupsError,
			Flatten[{injectionGroupsSettingsMismatchWarning}],
			injectionGroupsLengthWarning,
			injectionGroupsSamplesWarning,
			injectionGroupsOptionsAmbiguousWarning}
	];


	
	(* ----Injection Groups Errors and Warnings---- *)
	(*--Too many injection groups check--*)

	(*Check if there are too many injection groups for the 96-well plate*)
	tooManyInjectionGroupsQ=tooManyInjectionGroups;

	(*Set tooManyInjectionGroupsInvalidInputs to all sample objects*)
	tooManyInjectionGroupsInvalidInputs=If[tooManyInjectionGroupsQ,
		Lookup[Flatten[samplePackets],Object],
		{}
	];

	(*If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs*)
	If[Length[tooManyInjectionGroupsInvalidInputs]>0&&messages,
		Message[Error::DNASequencingTooManyInjectionGroups]
	];

	(*If we are gathering tests, create a test for too many samples*)
	tooManyInjectionGroupsTest=If[gatherTests,
		Test["The injection groups will fit on the plate:",
			tooManyInjectionGroupsQ,
			False
		],
		Nothing
	];

	(*--Injection groups length warning--*)

	(*Set tooManyInjectionGroupsInvalidInputs to all sample objects*)
	injectionGroupsLengthInvalidOptions=If[MemberQ[injectionGroupsLengthWarnings,True],
		{InjectionGroups},
		{}
	];

	(*If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs*)
	If[Length[injectionGroupsLengthInvalidOptions]>0&&messages,
		Message[Warning::DNASequencingInjectionGroupsLengths]
	];

	(*If we are gathering tests, create a test for too many samples*)
	injectionGroupsLengthTest=If[gatherTests,
		Test["The injection groups lengths are not longer than the number of capillaries in the instrument:",
			MemberQ[injectionGroupsLengthWarnings,True],
			False
		],
		Nothing
	];

	(*--Injection groups mismatch warning--*)

	(*Set tooManyInjectionGroupsInvalidInputs to all sample objects*)
	injectionGroupsMismatchInvalidInputs=If[MemberQ[injectionGroupsSettingsMismatchWarning,True],
		{InjectionGroups},
		{}
	];

	(*If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs*)
	If[Length[injectionGroupsMismatchInvalidInputs]>0&&messages,
		Message[Warning::DNASequencingInjectionGroupsSettingsMismatch]
	];

	(*If we are gathering tests, create a test for too many samples*)
	injectionGroupsMismatchTest=If[gatherTests,
		Test["The injection groups settings match:",
			MemberQ[injectionGroupsSettingsMismatchWarning,True],
			False
		],
		Nothing
	];


	(*--Injection groups and samples warning--*)

	(*If there is a warning and we are throwing messages, throw the warning message *)
	If[injectionGroupsSamplesWarning&&messages,
		Message[Warning::DNASequencingInjectionGroupsSamplesLengthsMismatch]
	];

	(*If we are gathering tests, create a test for injection group sample mismatch *)
	injectionGroupsSamplesTest=If[gatherTests,
		Test["All samples are contained in the injection groups and there are not more samples in the injection groups than are input:",
			injectionGroupsSamplesWarning,
			False
		],
		Nothing
	];

	(*--Injection groups and options warning--*)

	(*If there is a warning and we are throwing messages, throw the warning message *)
	If[injectionGroupsOptionsAmbiguousWarning&&messages,
		Message[Warning::DNASequencingInjectionGroupsOptionsAmbiguous]
	];

	(*If we are gathering tests, create a test for injection group sample mismatch *)
	injectionGroupsAmbiguousOptionsTest=If[gatherTests,
		Test["If there are any replicate samples and the samples in are in a different order than the specified injection groups, the same samples have the same options:",
			injectionGroupsOptionsAmbiguousWarning,
			False
		],
		Nothing
	];

	

	(* Resolve PCR options *)
	(* lookup the PCR options *)
	{
		activation,
		activationTime,
		activationTemperature,
		activationRampRate,
		denaturationTime,
		denaturationTemperature,
		denaturationRampRate,
		primerAnnealing,
		primerAnnealingTime,
		primerAnnealingTemperature,
		primerAnnealingRampRate,
		extensionTime,
		extensionTemperature,
		extensionRampRate,
		numberOfCycles,
		holdTemperature
	} = First[Lookup[allResolvedMapThreadOptionsAssociation,{
		Activation,ActivationTime,ActivationTemperature,ActivationRampRate,
		DenaturationTime,DenaturationTemperature,DenaturationRampRate,
		PrimerAnnealing,PrimerAnnealingTime,PrimerAnnealingTemperature,PrimerAnnealingRampRate,
		ExtensionTime,ExtensionTemperature,ExtensionRampRate,NumberOfCycles,HoldTemperature
	}]];

	(* determine if any PCR options were specified *)
	specifiedPCROptions = MatchQ[{
		activation, activationTime, activationTemperature, activationRampRate,
		denaturationTime, denaturationTemperature, denaturationRampRate,
		primerAnnealing, primerAnnealingTime, primerAnnealingTemperature, primerAnnealingRampRate,
		extensionTime, extensionTemperature, extensionRampRate,
		numberOfCycles, holdTemperature
	},{
		Automatic,Automatic,Automatic,Automatic,
		10Second,96Celsius,1Celsius/Second,
		Automatic,Automatic,Automatic,Automatic,
		240Second,60Celsius,1Celsius/Second,
		25,4Celsius
	}];

	(*If there are PCR options specified when PreparedPlate->True and we are throwing messages, then throw a warning message*)
	If[resolvedPreparedPlate&&!specifiedPCROptions&&messages,
		(
			Message[Warning::DNASequencingPCROptionsForPreparedPlate]
		),
		{}
	];

	(*If we are gathering tests, create a test for PCR options specified when PreparedPlate->True *)
	pcrOptionsSpecifiedPreparedPlateTest=If[gatherTests,
		Test["If PreparedPlate is True, PCR options cannot be specified",
			specifiedPCROptions,
			True
		],
		Nothing
	];


	(* resolve PCR options using the ExperimentPCR resolver *)
	pcrResolveFailure = Check[
		(* if PreparedPlate is True, PCR will not be run, so we don't need to resolve PCR options *)
		{resolvedPCROptions,pcrTests} = If[!resolvedPreparedPlate,
				If[gatherTests,
					Quiet[
							ExperimentPCR[mySamples,Activation->activation,ActivationTime->activationTime,ActivationTemperature->activationTemperature,ActivationRampRate->activationRampRate,
							DenaturationTime->denaturationTime,DenaturationTemperature->denaturationTemperature,DenaturationRampRate->denaturationRampRate,
							PrimerAnnealing->primerAnnealing,PrimerAnnealingTime->primerAnnealingTime,PrimerAnnealingTemperature->primerAnnealingTemperature,PrimerAnnealingRampRate->primerAnnealingRampRate,
							ExtensionTime->extensionTime,ExtensionTemperature->extensionTemperature,ExtensionRampRate->extensionRampRate,NumberOfCycles->numberOfCycles,HoldTemperature->holdTemperature,
							SampleVolume->0Microliter,MasterMix->Null,Buffer->Null,Cache->simulatedCache,Output->{Options,Tests}],
						{Download::MissingCacheField,Download::MissingField,Error::InvalidPreparedPlate,Error::InvalidInput}],   (* quiet PCR InvalidPreparedPlate and InvalidInput errors because we already check for that *)
					{Quiet[
							ExperimentPCR[mySamples,Activation->activation,ActivationTime->activationTime,ActivationTemperature->activationTemperature,ActivationRampRate->activationRampRate,
							DenaturationTime->denaturationTime,DenaturationTemperature->denaturationTemperature,DenaturationRampRate->denaturationRampRate,
							PrimerAnnealing->primerAnnealing,PrimerAnnealingTime->primerAnnealingTime,PrimerAnnealingTemperature->primerAnnealingTemperature,PrimerAnnealingRampRate->primerAnnealingRampRate,
							ExtensionTime->extensionTime,ExtensionTemperature->extensionTemperature,ExtensionRampRate->extensionRampRate,NumberOfCycles->numberOfCycles,HoldTemperature->holdTemperature,
							SampleVolume->0Microliter,MasterMix->Null,Buffer->Null,Cache->simulatedCache,Output->Options],
						{Download::MissingCacheField,Download::MissingField,Error::InvalidPreparedPlate,Error::InvalidInput}],{}}
				],
			{{},{}}],
		$Failed,
		{Error::InvalidOption}
	];
	
	(*--------------------------*)
	(* MapThread Error checking *)
	(*--------------------------*)

	(* MultiplePrimerSampleOligomersSpecified *)
	(*If there are MultiplePrimerSampleOligomersSpecified errors and we are throwing messages, then throw an error message*)
	multiplePrimerSampleOligomersOptions=If[MemberQ[Lookup[allErrorTrackersAssociation,MultiplePrimerSampleOligomersErrors],True]&&messages,
		(
			Message[Error::MultiplePrimerSampleOligomersSpecified,ObjectToString[PickList[primerSamplePackets,Lookup[allErrorTrackersAssociation,MultiplePrimerSampleOligomersErrors]],Cache->simulatedCache]];{PrimerVolume}
		),
		{}
	];

	(*If we are gathering tests, create a test for Multiple Sample Oligomers Specified*)
	multiplePrimerSampleOligomersTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,MultiplePrimerSampleOligomersErrors]];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,MultiplePrimerSampleOligomersErrors],False];

			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", the primer sample composition contains only one oligomer that the PrimerVolume can be resolved from:",False,True],
				Nothing
			];

			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Cache->simulatedCache]<>", the primer sample composition contains only one oligomer that the PrimerVolume can be resolved from:",True,True],
				Nothing
			];

			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(*--PreparedPlate Check--*)

	{mapThreadPrimerConcentration, mapThreadPrimerVolume, mapThreadMasterMixVolume, mapThreadDiluentVolume} = Transpose[Lookup[allResolvedMapThreadOptionsAssociation, {PrimerConcentration, PrimerVolume, MasterMixVolume, DiluentVolume}]];

	(*Check that when resolvedPreparedPlate is False, all the sample preparation options are specified, or when resolvedPreparedPlate is True, all the sample preparation options are Null*)
	validPreparedPlateQ=Or[
		MatchQ[resolvedPreparedPlate,False]&&AllTrue[Join[Flatten[{ConcentrationQ[mapThreadPrimerConcentration], VolumeQ[mapThreadPrimerVolume], VolumeQ[mapThreadMasterMixVolume](*, VolumeQ[mapThreadDiluentVolume]*)}]],TrueQ],
		MatchQ[resolvedPreparedPlate,True]&&(NullQ[mapThreadPrimerConcentration]&&NullQ[mapThreadPrimerVolume]&&NullQ[mapThreadMasterMixVolume]&&NullQ[mapThreadDiluentVolume])
	];

	(*If validPreparedPlateQ is False and we are throwing messages, then throw an error message*)
	preparedPlateMismatchOptions=If[!validPreparedPlateQ&&MatchQ[multiplePrimerSampleOligomersOptions,{}]&&messages,
		(
			Message[Error::DNASequencingPreparedPlateMismatch];
			{PrimerConcentration, PrimerVolume, MasterMixVolume, DiluentVolume}
		),
		{}
	];

	(*If we are gathering tests, create a test for PreparedPlate mismatch*)
	preparedPlateMismatchTest=If[gatherTests,
		Test["If PreparedPlate is True, PrimerConcentration, PrimerVolume, MasterMixVolume, and DiluentVolume are Null; if PreparedPlate is False, PrimerConcentration, PrimerVolume, and MasterMixVolume are specified:",
			validPreparedPlateQ,
			True
		],
		Nothing
	];



	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(*--PrimerCompositionNull--*)

	(*If there are primerCompositionNullErrors and we are throwing messages, then throw an error message*)
	primerCompositionNullOptions=If[MemberQ[Lookup[allErrorTrackersAssociation,PrimerCompositionNullErrors],True]&&messages,
		(
			Message[Error::DNASequencingPrimerCompositionNull,ObjectToString[PickList[primerSamplePackets,Lookup[allErrorTrackersAssociation,PrimerCompositionNullErrors]],Cache->simulatedCache]];
			{PrimerVolume}
		),
		{}
	];

	(*If we are gathering tests, create a test for Primer Composition Null*)
	primerCompositionTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,PrimerCompositionNullErrors]];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,PrimerCompositionNullErrors],False];

			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", the PrimerVolume does not have conflicts with the input primers:",False,True],
				Nothing
			];

			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Cache->simulatedCache]<>", the PrimerVolume does not have conflicts with the input primers:",True,True],
				Nothing
			];

			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(*--PrimerStorageCondition--*)

	(*If there are primerStorageConditionErrors and we are throwing messages, then throw an error message*)
	invalidPrimerStorageConditionOptions=If[MemberQ[Lookup[allErrorTrackersAssociation,PrimerStorageConditionErrors],True]&&messages,
		(
			Message[Error::DNASequencingPrimerStorageConditionMismatch];
			{PrimerStorageCondition}
		),
		{}
	];

	(*If we are gathering tests, create a test for PrimerStorageCondition mismatch*)
	validPrimerStorageConditionTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,PrimerStorageConditionErrors]];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,PrimerStorageConditionErrors],False];

			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", the PrimerStorageCondition does not have conflicts with the input primers:",False,True],
				Nothing
			];

			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Cache->simulatedCache]<>", the PrimerStorageCondition does not have conflicts with the input primers:",True,True],
				Nothing
			];

			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(*--MasterMix mismatch--*)

	(*If there are masterMixNotSpecifiedErrors and we are throwing messages, then throw an error message*)
	masterMixInvalidOptions=If[MemberQ[Lookup[allErrorTrackersAssociation,MasterMixNotSpecifiedErrors],True]&&messages,
		(
			Message[Error::DNASequencingMasterMixNotSpecified,ObjectToString[PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,MasterMixNotSpecifiedErrors]],Cache->simulatedCache]];
			{MasterMix,MasterMixVolume}
		),
		{}
	];

	(*If we are gathering tests, create a test for Master Mix not specified*)
	masterMixTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,MasterMixNotSpecifiedErrors]];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,MasterMixNotSpecifiedErrors],False];

			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", the MasterMixVolume does not have conflicts with the input samples:",False,True],
				Nothing
			];

			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Cache->simulatedCache]<>", the MasterMixVolume does not have conflicts with the input samples:",True,True],
				Nothing
			];

			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(*--MasterMixStorageCondition--*)

	(*If there are masterMixStorageConditionErrors and we are throwing messages, then throw an error message*)
	invalidMasterMixStorageConditionOptions=If[MemberQ[Lookup[allErrorTrackersAssociation,MasterMixStorageConditionErrors],True]&&messages,
		(
			Message[Error::DNASequencingMasterMixStorageConditionMismatch];
			{MasterMixStorageCondition}
		),
		{}
	];

	(*If we are gathering tests, create a test for PrimerStorageCondition mismatch*)
	validMasterMixStorageConditionTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,MasterMixStorageConditionErrors]];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,MasterMixStorageConditionErrors],False];

			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", the MasterMixStorageCondition does not have conflicts with the MasterMix option:",False,True],
				Nothing
			];

			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Cache->simulatedCache]<>", the MasterMixStorageCondition does not have conflicts with the MasterMix option:",True,True],
				Nothing
			];

			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(*--Diluent Error--*)
	(*If there are DiluentNotSpecifiedErrors and we are throwing messages, then throw an Error message*)
	diluentInvalidOptions=If[MemberQ[Lookup[allErrorTrackersAssociation,DiluentNotSpecifiedErrors],True]&&messages,
		(
			Message[Error::DNASequencingDiluentNotSpecified,ObjectToString[PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,DiluentNotSpecifiedErrors]],Cache->simulatedCache]];
			{Diluent,DiluentVolume}
		),
		{}
	];

	(*If we are gathering tests, create a test for Master Mix not specified*)
	diluentTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,DiluentNotSpecifiedErrors]];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,DiluentNotSpecifiedErrors],False];

			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", the Diluent is specified if a DiluentVolume is specified:",False,True],
				Nothing
			];

			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Cache->simulatedCache]<>", the Diluent is specified if a DiluentVolume is specified:",True,True],
				Nothing
			];

			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(*--Total volume--*)

	(*If there are totalVolumeTooLargeErrors and we are throwing messages, then throw an error message*)
	totalVolumeOverReactionVolumeOptions=If[MemberQ[Lookup[allErrorTrackersAssociation,TotalVolumeTooLargeErrors],True]&&messages,
		(
			Message[Error::DNASequencingTotalVolumeOverReactionVolume,ObjectToString[PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,TotalVolumeTooLargeErrors]],Cache->simulatedCache]];
			{SampleVolume,MasterMixVolume,PrimerVolume,DiluentVolume,ReactionVolume}
		),
		{}
	];

	(*If we are gathering tests, create a test for total volume*)
	totalVolumeTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,TotalVolumeTooLargeErrors]];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,TotalVolumeTooLargeErrors],False];

			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", the total volume consisting of SampleVolume, MasterMixVolume, PrimerVolume, and DiluentVolume does not exceed ReactionVolume:",False,True],
				Nothing
			];

			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Cache->simulatedCache]<>", the total volume consisting of SampleVolume, MasterMixVolume, PrimerVolume, and DiluentVolume does not exceed ReactionVolume:",True,True],
				Nothing
			];

			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];


	(*--ReadLength Warning--*)
	(*If there are ReadLengthNotSpecifiedWarnings and we are throwing messages, then throw an warning message*)
	readLengthNotSpecifiedOptions=If[MemberQ[Lookup[allErrorTrackersAssociation,ReadLengthNotSpecifiedWarnings],True]&&messages,
		(
			Message[Warning::DNASequencingReadLengthNotSpecified,ObjectToString[PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,ReadLengthNotSpecifiedWarnings]],Cache->simulatedCache]];
			{ReadLength}
		),
		{}
	];

	(*If we are gathering tests, create a test for ReadLength not specified*)
	readLengthTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,ReadLengthNotSpecifiedWarnings]];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,ReadLengthNotSpecifiedWarnings],False];

			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", the ReadLength is specified or can be determined from the primer composition field:",False,True],
				Nothing
			];

			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Cache->simulatedCache]<>", the ReadLength is specified or can be determined from the primer composition field:",True,True],
				Nothing
			];

			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(*--DyeSet Unknown Error--*)
	(*If there are DyeSetUnknownErrors and we are throwing messages, then throw an Error message*)
	dyeSetInvalidOptions=If[MemberQ[Lookup[allErrorTrackersAssociation,DyeSetUnknownErrors],True]&&messages,
		(
			Message[Error::DyeSetUnknown,ObjectToString[PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,DyeSetUnknownErrors]],Cache->simulatedCache]];
			{DyeSet}
		),
		{}
	];

	(*If we are gathering tests, create a test for Master Mix not specified*)
	dyeSetTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(*Get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,DyeSetUnknownErrors]];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,DyeSetUnknownErrors],False];

			(*Create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", the DyeSet is specified:",False,True],
				Nothing
			];

			(*Create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Cache->simulatedCache]<>", the DyeSet is specified:",True,True],
				Nothing
			];

			(*Return the created tests*)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];


	(*---Storage Condition Checks---*)


	(*--SequencingCartridgeStorageCondition Warning--*)
	(* check if the storage condition is set to Refrigerator *)
	validSequencingCartridgeStorageConditionQ = MatchQ[sequencingCartridgeStorageCondition,Refrigerator|Model[StorageCondition,"Refrigerator"]|Model[StorageCondition, "id:N80DNj1r04jW"]|Null];

	(*If the SequencingCartridgeStorageCondition is not set to Refrigerator and we are throwing messages, then throw an warning message*)
	sequencingCartridgeStorageConditionOptions = If[!validSequencingCartridgeStorageConditionQ&&messages,
		(
			Message[Warning::DNASequencingCartridgeStorageCondition];{SequencingCartridgeStorageCondition}
		),
		{}
	];

	(*If we are gathering tests, create a test for too many samples*)
	sequencingCartridgeStorageConditionTest = If[gatherTests,
		Test["The specified SequencingCartridgeStorageCondition is Refrigerator or Model[StorageCondition,\"Refrigerator\"]:",
			validSequencingCartridgeStorageConditionQ,
			True
		],
		Nothing
	];

	(* Gather SamplesInStorage, PrimerStorageCondition, and MasterMixStorageCondition *)
	{samplesInStorageConditions,primerStorageConditions,masterMixStorageConditions} = Transpose[Lookup[allResolvedMapThreadOptionsAssociation,{SamplesInStorageCondition,PrimerStorageCondition,MasterMixStorageCondition}]];

	discardedSampleInvalidInputs = Lookup[discardedSamplePackets,Object];

	discardedPrimerSampleInvalidInputs = Lookup[discardedPrimerSamplePackets,Object];

	(* SamplesInStorageCondition *)
	(* Collect those non-discarded samples*)
	nonDiscardedSamples=DeleteCases[mySamples,ObjectP[discardedSampleInvalidInputs]];

	(* Collect the storage conditions of those non-discarded samples *)
	nonDiscardedSampleStorageConditions = PickList[samplesInStorageConditions,mySamples,Except[ObjectP[discardedSampleInvalidInputs]]];

	(*Generate Tests for SamplesInStorageCondition*)
	{validSamplesInStorageConditionBool, validSamplesInStorageConditionTests} =
		Which[
			(*Check if all samples were discarded*)
			MatchQ[nonDiscardedSamples,{}],{{},{}},

			(* If not, check their SamplesInStorageConditions *)
			gatherTests, ValidContainerStorageConditionQ[nonDiscardedSamples,nonDiscardedSampleStorageConditions, Output -> {Result, Tests},Cache->simulatedCache],
			True,{ValidContainerStorageConditionQ[nonDiscardedSamples,nonDiscardedSampleStorageConditions, Output -> Result,Cache->simulatedCache], {}}
		];

	(*Collect Invalid options SamplesInStorageCondition*)
	samplesInStorageConditionInvalidOptions = If[MemberQ[validSamplesInStorageConditionBool, False],SamplesInStorageCondition,Nothing];

	(* PrimerStorageCondition *)
	(* Collect those non-discarded primer samples*)
	nonDiscardedPrimerSamples=DeleteCases[myPrimerSamples,ObjectP[discardedPrimerSampleInvalidInputs]];

	(* Collect the storage conditions of those non-discarded primer samples *)
	nonDiscardedPrimerSampleStorageConditions = PickList[primerStorageConditions,myPrimerSamples,Except[ObjectP[discardedPrimerSampleInvalidInputs]]];

	(*Generate Tests for SamplesInStorageCondition*)
	{validPrimerStorageConditionBool, validPrimerSampleStorageConditionTests} =
		Which[
			(*Check if all primer samples were discarded*)
			MatchQ[nonDiscardedPrimerSamples,{}],{{},{}},

			(* Check if there are primer samples, if not, don't need to check storage conditions *)
			NullQ[myPrimerSamples],{{},{}},

			(* If not, check their PrimerStorageConditions *)
			gatherTests, ValidContainerStorageConditionQ[nonDiscardedPrimerSamples,nonDiscardedPrimerSampleStorageConditions, Output -> {Result, Tests},Cache->simulatedCache],
			True,{ValidContainerStorageConditionQ[nonDiscardedPrimerSamples,nonDiscardedPrimerSampleStorageConditions, Output -> Result,Cache->simulatedCache], {}}
		];

	(*Collect Invalid options PrimerStorageCondition*)
	primerStorageConditionInvalidOptions = If[MemberQ[validPrimerStorageConditionBool, False],PrimerStorageCondition,Nothing];

	(* MasterMixStorageCondition *)
	(*Collect master mixes with Objects only, don't check their storage condition for Models. *)
	masterMixNoModels=Cases[masterMix,ObjectP[Object[Sample]]];
	masterMixStorageNoModels=PickList[masterMixStorageConditions,masterMix,ObjectP[Object[Sample]]];

	(* Generate Tests for MasterMixStorageCondition *)
	{validMasterMixStorageConditionBool, validMasterMixStorageConditionTests} =
		Which[
			MatchQ[masterMixNoModels,{}],{{},{}},
			gatherTests, ValidContainerStorageConditionQ[masterMixNoModels,masterMixStorageNoModels, Output -> {Result, Tests},Cache->simulatedCache],
			True, {ValidContainerStorageConditionQ[masterMixNoModels,masterMixStorageNoModels, Output -> Result,Cache->simulatedCache], {}}
		];
	
	(*Collect Invalid options MasterMixStorageCondition*)
	masterMixStorageConditionInvalidOptions = If[MemberQ[validMasterMixStorageConditionBool, False],MasterMixStorageCondition,Nothing];



	(* look up the instrument for options and CM check *)
	instrument = Lookup[myOptions, Instrument];

	(*---Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument---*)
	{compatibleMaterialsBool,compatibleMaterialsTests}=If[gatherTests,
		CompatibleMaterialsQ[instrument,If[!NullQ[myPrimerSamples],Join[simulatedSamples,myPrimerSamples],simulatedSamples],Output->{Result,Tests},Cache->simulatedCache],
		{CompatibleMaterialsQ[instrument,If[!NullQ[myPrimerSamples],Join[simulatedSamples,myPrimerSamples],simulatedSamples],Messages->messages,Cache->simulatedCache],{}}
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
		tooManySamplesInvalidInputs,
		preparedPlateInvalidInputs,
		preparedPlateInvalidContainerInputs,
		solidStatePrimerInvalidInputs,
		solidStateInvalidInputs,
		tooManyInjectionGroupsInvalidInputs
	}]];
	invalidOptions=DeleteDuplicates[Flatten[{
		nameInvalidOptions,
		invalidCathodeBufferOptions,
		invalidAnodeBufferOptions,
		invalidPolymerOptions,
		invalidCartridgeTypeOptions,
		(*dyeSetMismatchOptions,
		primeTimeMismatchOptions,
		primeVoltageMismatchOptions,
		injectionTimeMismatchOptions,
		injectionVoltageMismatchOptions,
		rampTimeMismatchOptions,
		runVoltageMismatchOptions,
		runTimeMismatchOptions,*)
		preparedPlateMismatchOptions,
		primerCompositionNullOptions,
		multiplePrimerSampleOligomersOptions,
		invalidPrimerStorageConditionOptions,
		masterMixInvalidOptions,
		invalidMasterMixStorageConditionOptions,
		diluentInvalidOptions,
		totalVolumeOverReactionVolumeOptions,
		dyeSetInvalidOptions,
		invalidPurificationTypeOptions,
		invalidQuenchingReagentVolumeOptions,
		invalidSequencingBufferVolumeOptions,
		samplesInStorageConditionInvalidOptions,
		primerStorageConditionInvalidOptions,
		masterMixStorageConditionInvalidOptions,
		compatibleMaterialsInvalidOption

	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->simulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(*---Resolve aliquot options---*)

	(*Resolve RequiredAliquotContainers as Null, since samples must be transferred into the '96-well Optical Semi-Skirted PCR Plate' accepted by the instrument*)
	targetContainers=Null;

	(*Resolve aliquot options and make tests*)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentDNASequencing,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			Cache->simulatedCache,
			RequiredAliquotAmounts->Null,
			RequiredAliquotContainers->targetContainers,
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentDNASequencing,
				mySamples,
				simulatedSamples,
				ReplaceRule[myOptions,resolvedSamplePrepOptions],
				Cache->simulatedCache,
				RequiredAliquotAmounts->Null,
				RequiredAliquotContainers->targetContainers,
				Output->Result],
			{}
		}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* gather all the tests together *)
	allTests = Cases[Flatten[{
		samplePrepTests,
		discardedTest,
		deprecatedTest,
		validPreparedPlateTest,
		tooManySamplesTest,
		validPreparedPlateContainerTest,
		solidSampleTest,
		solidPrimerSampleTest,
		precisionTests,
		validNameTest,
		invalidCathodeBufferTest,
		invalidAnodeBufferTest,
		invalidPolymerTest,
		invalidCartridgeTypeTest,
		(*multipleSampleOligomersTest,*)
		tooManyInjectionGroupsTest,
		(*dyeSetMismatchTest,
		primeTimeMismatchTest,
		primeVoltageMismatchTest,
		injectionTimeMismatchTest,
		injectionVoltageMismatchTest,
		rampTimeMismatchTest,
		runVoltageMismatchTest,
		runTimeMismatchTest,*)
		pcrTests,
		pcrOptionsSpecifiedPreparedPlateTest,
		preparedPlateMismatchTest,
		primerCompositionTest,
		multiplePrimerSampleOligomersTest,
		validPrimerStorageConditionTest,
		masterMixTest,
		validMasterMixStorageConditionTest,
		diluentTest,
		totalVolumeTest,
		(*readLengthTest,*)
		dyeSetTest,
		(*sequencingCartridgeStorageConditionTest,*)
		validSamplesInStorageConditionTests,
		validPrimerSampleStorageConditionTests,
		validMasterMixStorageConditionTests,
		validQuenchingReagentVolumeTest,
		validPurificationTypeTest,
		validSequencingBufferVolumeTest,
		compatibleMaterialsTests,
		aliquotTests
	}], _EmeraldTest];

	(* Return our resolved options and/or tests. *)
	(* --- Do the final preparations --- *)

	(* --- pull out all the shared options from the input options --- *)

	(* get the rest directly *)
	{confirm, template, operator, upload, outputOption, samplesInStorage, samplePreparation} = Lookup[myOptions, {Confirm, Template, Operator, Upload, Output, SamplesInStorageCondition, PreparatoryUnitOperations}];

	(* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
	email = Which[
		MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[parentProtocol], True,
		MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[parentProtocol, ObjectP[ProtocolTypes[]]], False,
		True, Lookup[myOptions, Email]
	];

	(* get the final resolved options (pre-collapsed; that is happening outside the function) *)
	resolvedOptions = ReplaceRule[Normal[updatedRoundedDNASequencingOptions],
		Flatten[{
		Instrument -> instrument,
		SequencingCartridge ->sequencingCartridge,
		InjectionGroups -> resolvedInjectionGroups,
		BufferCartridge -> bufferCartridge,
		Temperature -> temperature,
		PreparedPlate -> resolvedPreparedPlate,
		(*NumberOfReplicates -> numberOfReplicates,*)
		NumberOfInjections->numberOfInjections,
		ReadLength -> resolvedReadLengths,
		SampleVolume -> sampleVolume,
		ReactionVolume -> reactionVolume,
		MasterMix -> masterMix,
		PurificationType -> resolvedPurificationType,
		QuenchingReagents -> resolvedQuenchingReagents,
		QuenchingReagentVolumes -> resolvedQuenchingReagentVolumes,
		SequencingBuffer -> resolvedSequencingBuffer,
		SequencingBufferVolume -> resolvedSequencingBufferVolume,
		PrimeTime -> primeTime,
		PrimeVoltage -> primeVoltage,
		InjectionTime -> injectionTime,
		RampTime -> rampTime,
		Normal[Merge[resolvedOptionsPackets,Identity]],
		SequencingCartridgeStorageCondition->sequencingCartridgeStorageCondition,
		resolvedAliquotOptions,
		resolvedPostProcessingOptions,
		If[MatchQ[resolvedPCROptions,{_Rule..}],Normal[KeyTake[resolvedPCROptions,{
				Activation,ActivationTime,ActivationTemperature,ActivationRampRate,
				DenaturationTime,DenaturationTemperature,DenaturationRampRate,
				PrimerAnnealing,PrimerAnnealingTime,PrimerAnnealingTemperature,PrimerAnnealingRampRate,
				ExtensionTime,ExtensionTemperature,ExtensionRampRate,NumberOfCycles,HoldTemperature
			}]],{}],
		Confirm -> confirm,
		Name -> name,
		Template -> template,
		Cache -> cacheBall,
		Email -> email,
		FastTrack -> fastTrack,
		Operator -> operator,
		Output -> outputOption,
		ParentProtocol -> parentProtocol,
		Upload -> upload(*,
		SamplesInStorageCondition -> samplesInStorage*)
		}]
	];
	 
	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just Null *)
	resultRule = Result -> If[MemberQ[output, Result],
		resolvedOptions,
		Null
	];

	(* return the output as we desire it *)
	outputSpecification /. {resultRule, testsRule}
	
];



(* ::Subsubsection::Closed:: *)
(*experimentDNASequencingResourcePackets*)


DefineOptions[experimentDNASequencingResourcePackets,
	Options:>{
		CacheOption,
		HelperOutputOption
	}
];

experimentDNASequencingResourcePackets[
	mySamples:{ObjectP[Object[Sample]]..},
	myPrimerSamples:ListableP[ObjectP[Object[Sample]]|Null],
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	ops:OptionsPattern[experimentDNASequencingResourcePackets]
]:= Module[
	{
		expandedInputs, expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,
		allPlateModels,allPlateContainers,allPlateContainersAssociation,potentialAssayPlateModels, potentialNonSkirtedPlateModels,
		liquidHandlerContainers,liquidHandlerContainersAssociation,samplesInResourceContainers,samplesInResources,containersInObjects,
		pairedPrimersAndVolumes,primerSamplesResources,primerVolumeRules,primerSamplesResourceContainers,primerContainersInObjects,uniquePrimerResources,uniquePrimerObjects,uniquePrimerResourceReplaceRules,
		primeTime,injectionTime,rampTime,runTime,masterMixVolume,masterMix,instrument,sequencingCartridge,bufferCartridge,bufferCartridgeSeptaResource,replaceBufferCartridge,
		diluentVolume, diluent, quenchingReagentVolume, quenchingReagent, sequencingBufferVolume, sequencingBuffer, injectionGroups, preparedPlate,
		geneticAnalyzerRunTime,numberOfInjections,instrumentResource, sequencingCartridgeResource, bufferCartridgeResource, containersInModels,assayPlate,assayPlateResource,
		pairedMasterMixAndVolumes,masterMixVolumeRules,masterMixResourceContainers,uniqueMasterMixResources,uniqueMasterMixObjects,uniqueMasterMixResourceReplaceRules,masterMixResources,
		pairedDiluentAndVolumes,diluentVolumeRules,diluentResourceContainers,uniqueDiluentResources,uniqueDiluentObjects,uniqueDiluentResourceReplaceRules,diluentResource,
		numberOfEmptyWellsToFill,emptyWellBufferTotalVolume,sequencingBufferResourceContainers,sequencingBufferResource, totalSequencingBufferVolume, emptyWellBuffer,
		quenchingReagentResourceContainers,listedQuenchingReagents,pairedQuenchingReagentsAndVolumes,quenchingReagentVolumeRules,vortexAdapterRackResource,
		uniqueQuenchingReagentResources,uniqueQuenchingReagentObjects,uniqueQuenchingReagentResourceReplaceRules,quenchingReagentResource,flattenedQuenchingReagentVolumes,
		purificationType,plateSeptaResource,capillaryProtectorResource, samplePreparationTime,resourcePickingTime,assayPlatePreparationTime,postPCRSampleProcessingTime,bigDyeXTerminator,
		protocolPacket,sharedFieldPacket,finalizedPacket, allResourceBlobs,fulfillable,frqTests,testsRule,resultRule,previewRule,optionsRule
	},

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentDNASequencing, {mySamples,myPrimerSamples}, myResolvedOptions,2];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentDNASequencing,
		RemoveHiddenOptions[ExperimentDNASequencing,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Get the inherited cache *)
	inheritedCache = Lookup[ToList[ops],Cache];

	(* --- Make our one big Download call --- *)

	(*--Get the Model[Container,Plate]s--*)
	allPlateModels = Search[Model[Container,Plate],SubTypes->False];

	(*--Get the liquid handler-compatible containers and download their volume capacities--*)
	(*--Get the Model[Container,Plate]s and download their relevant properties--*)

	(*In case we need to prepare the resource, use one from the prepended list of liquid handler-compatible containers (Engine uses the first requested container if it has to make a transfer or stock solution)*)
	{liquidHandlerContainers,allPlateContainers}=Quiet[
		Download[
			{
				hamiltonAliquotContainers["Memoization"],
				allPlateModels

			},
			{
				{Packet[MaxVolume]},
				{Packet[NumberOfWells, WellDimensions, MaxVolume, PlateColor, WellBottom, Skirted]}
			},
			Cache->inheritedCache
		],
		Download::FieldDoesntExist
	];

	(* flatten and extract the relevant values from the packets *)
	liquidHandlerContainersAssociation = Flatten[liquidHandlerContainers];
	allPlateContainersAssociation = Flatten[allPlateContainers];

	(* --- Make all the resources needed in the experiment --- *)

	(* -- Generate resources for the SamplesIn -- *)

	(*Get the liquid handler-compatible containers with the appropriate volume capacity that the samples in should be transferred into*)
	samplesInResourceContainers=Map[
		Function[volume,
			Lookup[Select[liquidHandlerContainersAssociation,Lookup[#,MaxVolume]>=volume&],Object]
		],
		(Lookup[expandedResolvedOptions, SampleVolume] * 1.3)
	];

	(*Make the samples in resources*)
	samplesInResources=MapThread[
		Resource[Sample->#1,Name->ToString[Unique[]],Amount->#2,Container->#3]&,
		{mySamples,(Lookup[expandedResolvedOptions,SampleVolume]*1.3),samplesInResourceContainers}
	];

	(*--Extract the container objects and models from the downloaded cache. Resources should not be created for the containers in--*)
	containersInObjects=DeleteDuplicates[Download[mySamples,Container[Object],Cache->inheritedCache]];

	containersInModels=Download[containersInObjects,Model[Object],Cache->inheritedCache];

	(*--Generate the primers resources--*)
	(*Consolidate all resources if we can, that will make liquid handling more accurate*)
	(* Pair the primers and their volumes *)
	pairedPrimersAndVolumes=If[NullQ[myPrimerSamples],
		{},
		MapThread[
			(#1->#2)&,
			{myPrimerSamples,Flatten[(Lookup[expandedResolvedOptions,PrimerVolume]*1.3)]}
		]
	];

	(* Merge the primers volumes together to get the total volume of each primer's resource *)
	(* Get a list of volume rules, getting rid of any rules with the pattern Null->__ or __->0Microliter *)
	primerVolumeRules=DeleteCases[
		KeyDrop[
			Merge[pairedPrimersAndVolumes,Total],
			Null
		],
		0*Microliter
	];

	(*Get the liquid handler-compatible containers with the appropriate volume capacity that the unique primer samples in should be transferred into*)
	(*set the minimum volume for any one primer resource to 5 uL*)
	primerSamplesResourceContainers=If[NullQ[myPrimerSamples],
		Null,
		Map[
			Function[volume,
				Lookup[Select[liquidHandlerContainersAssociation,Lookup[#,MaxVolume]>=volume&],Object]
			],
			Values[primerVolumeRules]/.(x:LessP[5 Microliter]:>5 Microliter)
		]
	];

	(* Use the volume rules association to make resources for each unique Object or Model *)
	(*set the minimum volume for any one primer resource to 5 uL*)
	uniquePrimerResources=If[NullQ[myPrimerSamples],
		{},
		MapThread[
			Link[Resource[Sample->#1,Name->ToString[Unique[]],Amount->#2,Container->#3]]&,
			{Keys[primerVolumeRules],Values[primerVolumeRules]/.(x:LessP[5 Microliter]:>5 Microliter),primerSamplesResourceContainers}
		]
	];

	(* Construct a list of replace rules to point from the primer object to its resource *)
	uniquePrimerObjects=Keys[primerVolumeRules];
	uniquePrimerResourceReplaceRules=MapThread[
		(#1->#2)&,
		{uniquePrimerObjects,uniquePrimerResources}
	];

	primerSamplesResources=If[NullQ[myPrimerSamples],
		Null,
		Replace[myPrimerSamples,uniquePrimerResourceReplaceRules,{1}]
	];

	(*--Extract the container objects from the downloaded cache. Resources should not be created for the containers in--*)
	primerContainersInObjects=DeleteDuplicates[Download[myPrimerSamples,Container[Object],Cache->inheritedCache]];

	(* -- Generate instrument resources -- *)

	(* look up options from resolved options that are necessary for resources *)
	{
		primeTime,
		injectionTime,
		rampTime,
		runTime,
		instrument,
		sequencingCartridge,
		bufferCartridge,
		masterMixVolume,
		masterMix,
		diluentVolume,
		diluent,
		quenchingReagentVolume,
		quenchingReagent,
		sequencingBufferVolume,
		sequencingBuffer,
		injectionGroups,
		preparedPlate
	}=Lookup[expandedResolvedOptions,
		{
			PrimeTime,
			InjectionTime,
			RampTime,
			RunTime,
			Instrument,
			SequencingCartridge,
			BufferCartridge,
			MasterMixVolume,
			MasterMix,
			DiluentVolume,
			Diluent,
			QuenchingReagentVolumes,
			QuenchingReagents,
			SequencingBufferVolume,
			SequencingBuffer,
			InjectionGroups,
			PreparedPlate
		}
	];

	numberOfInjections = Lookup[myResolvedOptions,NumberOfInjections];

	geneticAnalyzerRunTime = SafeRound[Convert[(Total[Flatten[{primeTime, injectionTime, rampTime, runTime}]]/4)*numberOfInjections,Minute],1Minute];

	instrumentResource = Resource[Instrument -> instrument, Time -> geneticAnalyzerRunTime, Name -> ToString[Unique[]]];

	
	(*--Generate the sequencing cartridge resource--*)
	sequencingCartridgeResource=Resource[Sample->sequencingCartridge,Name->ToString[Unique[]]];

	(*--Generate the buffer cartridge resource--*)
	bufferCartridgeResource=Resource[Sample->bufferCartridge,Name->ToString[Unique[]]];

	(*--Generate the buffer cartridge septa resource--*)
	bufferCartridgeSeptaResource=Resource[Sample->Model[Item,"Genetic Analyzer Buffer Cartridge Septa"],Name->ToString[Unique[]]];

	(* if the buffer cartridge was specified by the user, it will be replaced in the procedure *)
	replaceBufferCartridge = If[
		MatchQ[Lookup[myResolvedOptions,BufferCartridge],Model[Container,Vessel,BufferCartridge,"SeqStudio Buffer Cartridge"]],
		False,
		True
	];
	
	(*--Generate the assay plate resource--*)
	(* select the plates that match the desired parameters *)
	potentialAssayPlateModels = Select[
		allPlateContainersAssociation,

		(* match to the correct values for plate characteristics to fit in the instrument *)
			Lookup[
				#,
				{NumberOfWells, WellDimensions, MaxVolume, PlateColor, WellBottom}
			]
				== {96, {5.5 Millimeter,5.5 Millimeter}, 0.2 Milliliter, Clear, VBottom} &
	];

	(* make sure plate is non-skirted. must lookup separately since not all containers are plates *)
	potentialNonSkirtedPlateModels = SelectFirst[
		potentialAssayPlateModels,
		Lookup[#, {Skirted}] == {False} &
	];

	(* get the model of the plate that fits the parameters *)
	assayPlate = Lookup[potentialNonSkirtedPlateModels,Object];

	(* make the resource *)
	(* If we're using PreparatoryUnitOperations then plate might not exist so we can't populate this when it's coming from ContainersIn *)
	assayPlateResource=If[MatchQ[containersInModels,{ObjectP[Model[Container, Plate, "id:Z1lqpMz1EnVL"]]}]&&preparedPlate,
		Null,
		Resource[Sample->assayPlate,Name->ToString[Unique[]]]
	];

	(*--Generate the master mix resource--*)
	(*Consolidate all resources if we can, that will make liquid handling more accurate*)
	(* Pair the master mix and their volumes *)
	pairedMasterMixAndVolumes=If[NullQ[masterMix]||NullQ[masterMixVolume],
		{},
		MapThread[
			(#1->#2)&,
			{masterMix,(masterMixVolume*1.3)}
		]
	];

	(* Merge the master mix volumes together to get the total volume of each master mix's resource *)
	(* Get a list of volume rules, getting rid of any rules with the pattern Null->__ or __->0Microliter *)
	masterMixVolumeRules=DeleteCases[
		KeyDrop[
			Merge[pairedMasterMixAndVolumes,Total],
			Null
		],
		0Microliter
	];


	(*Get the liquid handler-compatible containers with the appropriate volume capacity that the samples in should be transferred into*)
	masterMixResourceContainers=If[NullQ[masterMixVolume],
		Null,
		Map[
			Function[volume,
				Lookup[Select[liquidHandlerContainersAssociation,Lookup[#,MaxVolume]>=volume&],Object]
			],
			Values[masterMixVolumeRules]
		]
	];

	(* Use the volume rules association to make resources for each unique Object or Model *)
	uniqueMasterMixResources=If[NullQ[masterMix]||NullQ[masterMixVolume],
		{},
		MapThread[
			Link[Resource[Sample->#1,Name->ToString[Unique[]],Amount->#2,Container->#3]]&,
			{Keys[masterMixVolumeRules],Values[masterMixVolumeRules],masterMixResourceContainers}
		]
	];

	(* Construct a list of replace rules to point from the master mix object to its resource *)
	uniqueMasterMixObjects=Keys[masterMixVolumeRules];
	uniqueMasterMixResourceReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueMasterMixObjects,uniqueMasterMixResources}
	];

	(*Make the master mix resources*)
	masterMixResources=If[NullQ[masterMix]||NullQ[masterMixVolume],
		Null,
		Replace[masterMix,uniqueMasterMixResourceReplaceRules,{1}]
	];
	

	(*--Generate the diluent resource--*)
	(*Consolidate all resources if we can, that will make liquid handling more accurate*)
	(* Pair the diluent and their volumes *)
	pairedDiluentAndVolumes=If[NullQ[diluent]||NullQ[diluentVolume],
		{},
		MapThread[
			(#1->#2)&,
			{diluent,(diluentVolume*1.3)}
		]
	];

	(* Merge the diluent volumes together to get the total volume of each diluent's resource *)
	(* Get a list of volume rules, getting rid of any rules with the pattern Null->__ or __->0Microliter *)
	diluentVolumeRules=DeleteCases[
		KeyDrop[
			Merge[pairedDiluentAndVolumes,Total],
			Null
		],
		0Microliter
	];


	(*Get the liquid handler-compatible containers with the appropriate volume capacity that the samples in should be transferred into*)
	diluentResourceContainers=If[NullQ[diluentVolume],
		Null,
		Map[
			Function[volume,
				Lookup[Select[liquidHandlerContainersAssociation,Lookup[#,MaxVolume]>=volume&],Object]
			],
			Values[diluentVolumeRules]
		]
	];

	(* Use the volume rules association to make resources for each unique Object or Model *)
	uniqueDiluentResources=If[NullQ[diluent]||NullQ[diluentVolume],
		{},
		MapThread[
			Link[Resource[Sample->#1,Name->ToString[Unique[]],Amount->#2,Container->#3]]&,
			{Keys[diluentVolumeRules],Values[diluentVolumeRules],diluentResourceContainers}
		]
	];

	(* Construct a list of replace rules to point from the diluent object to its resource *)
	uniqueDiluentObjects=Keys[diluentVolumeRules];
	uniqueDiluentResourceReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueDiluentObjects,uniqueDiluentResources}
	];

	(*Make the diluent resources*)
	diluentResource=If[NullQ[diluent]||NullQ[diluentVolume],
		Null,
		Replace[diluent,uniqueDiluentResourceReplaceRules,{1}]
	];


	
	(*--Generate the quenching reagent resource--*)
	flattenedQuenchingReagentVolumes = Flatten[{quenchingReagentVolume}];
	listedQuenchingReagents = If[MatchQ[quenchingReagent,_List],Flatten[quenchingReagent],{quenchingReagent}];

	(* Consolidate all resources if we can, that will make liquid handling more accurate *)
	(* Pair the quenching reagents and their volumes *)
	pairedQuenchingReagentsAndVolumes=If[NullQ[listedQuenchingReagents]||NullQ[flattenedQuenchingReagentVolumes],
		{},
		MapThread[
			(#1->#2)&,
			{listedQuenchingReagents,(flattenedQuenchingReagentVolumes*1.3)}
		]
	];

	(* Merge the quenching reagent volumes together to get the total volume of each quenching reagent's resource *)
	(* Get a list of volume rules, getting rid of any rules with the pattern Null->__ or __->0Microliter *)
	quenchingReagentVolumeRules=DeleteCases[
		KeyDrop[
			Merge[pairedQuenchingReagentsAndVolumes,Total],
			Null
		],
		0Microliter
	];

	(* Get the liquid handler-compatible containers with the appropriate volume capacity that the samples in should be transferred into *)
	(* make sure the containers have enough room for the total volume of the quenching reagents together, since BigDye XTerminator solutions will be mixed together before adding to plate *)
	quenchingReagentResourceContainers=If[NullQ[flattenedQuenchingReagentVolumes],
		Null,
		Map[
			Function[volume,
				Lookup[Select[liquidHandlerContainersAssociation,Lookup[#,MaxVolume]>=volume&],Object]
			],
			ConstantArray[Total[Values[quenchingReagentVolumeRules]]*Length[mySamples],Length[Values[quenchingReagentVolumeRules]]]
		]
	];

	(* Use the volume rules association to make resources for each unique Object or Model *)
	uniqueQuenchingReagentResources=If[NullQ[listedQuenchingReagents]||NullQ[flattenedQuenchingReagentVolumes],
		{},
		MapThread[
			Link[Resource[Sample->#1,Name->ToString[Unique[]],Amount->#2,Container->#3]]&,
			{Keys[quenchingReagentVolumeRules],Values[quenchingReagentVolumeRules],quenchingReagentResourceContainers}
		]
	];

	(* Construct a list of replace rules to point from the diluent object to its resource *)
	uniqueQuenchingReagentObjects=Keys[quenchingReagentVolumeRules];
	uniqueQuenchingReagentResourceReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueQuenchingReagentObjects,uniqueQuenchingReagentResources}
	];

	(*Make the quenching reagent resources*)
	quenchingReagentResource=If[NullQ[listedQuenchingReagents]||NullQ[flattenedQuenchingReagentVolumes],
		Null,
		Replace[listedQuenchingReagents,uniqueQuenchingReagentResourceReplaceRules,{1}]
	];


	(*--Generate the sequencing buffer resource--*)
	(* If the SequencingBuffer/SequencingBufferVolume are Null, a resource must still be created to fill empty wells in injection groups *)
	(* Look up how many wells are filled with Model[Sample,"Hi-Di formamide"] *)
	emptyWellBuffer = If[!NullQ[sequencingBuffer],sequencingBuffer,Model[Sample,"Hi-Di formamide"]];

	numberOfEmptyWellsToFill = Length[Select[Flatten[injectionGroups],#==emptyWellBuffer&]];

	(* Multiply by the 15 microliters needed to fill each well to get the total volume *)
	emptyWellBufferTotalVolume = numberOfEmptyWellsToFill * 15 Microliter;
	 
	(* if the sequencing buffer is not null, add in additional volume needed to fill empty wells *)
	totalSequencingBufferVolume = Total[{(sequencingBufferVolume/. Null -> 0 Microliter*1.3),emptyWellBufferTotalVolume}];

	(*Get the liquid handler-compatible containers with the appropriate volume capacity that the Sequencing Buffer should be transferred into*)
	sequencingBufferResourceContainers=Which[
		VolumeQ[sequencingBufferVolume]&&MatchQ[sequencingBuffer,ObjectP[{Model[Sample],Object[Sample]}]],
		Lookup[Select[liquidHandlerContainersAssociation,Lookup[#,MaxVolume]>=totalSequencingBufferVolume&],Object],

		NullQ[sequencingBuffer]&&NullQ[sequencingBufferVolume],
		Lookup[Select[liquidHandlerContainersAssociation,Lookup[#,MaxVolume]>=emptyWellBufferTotalVolume&],Object],

		True,Null
	];

	(*Make the Sequencing Buffer resource*)
	sequencingBufferResource=Which[
		totalSequencingBufferVolume==0*Microliter,Null,

		VolumeQ[sequencingBufferVolume]&&MatchQ[sequencingBuffer,ObjectP[{Model[Sample],Object[Sample]}]],
		Resource[Sample->sequencingBuffer,Name->ToString[Unique[]],Amount->totalSequencingBufferVolume,Container->sequencingBufferResourceContainers],

		NullQ[sequencingBuffer]&&NullQ[sequencingBufferVolume],
		Resource[Sample->Model[Sample,"Hi-Di formamide"],Name->ToString[Unique[]],Amount->emptyWellBufferTotalVolume,Container->sequencingBufferResourceContainers]

	];
	
	purificationType = Lookup[myResolvedOptions,PurificationType];

	plateSeptaResource=Resource[Sample->Model[Item, PlateSeal, "Plate Seal, 96-Well Round Septa"],Name->ToString[Unique[]]];

	capillaryProtectorResource=Resource[Sample->Model[Item,"Genetic Analyzer Sequencing Cartridge Capillary Protector"],Name->ToString[Unique[]]];

	(* make a rack resource for vortexing *)
	vortexAdapterRackResource = Resource[Sample -> Model[Container,Rack,"Semi-Skirted PCR Plate Vortex Adapter"], Rent -> True];

	(*--Determine checkpoint timing based on experimental options--*)

	(* If a prepared plate is specified (primer input samples are Null), then sample preparation times are 0 minutes *)
	samplePreparationTime = If[NullQ[myPrimerSamples],20 Minute,45 Minute];
	resourcePickingTime = If[NullQ[myPrimerSamples],20 Minute,45 Minute];
	assayPlatePreparationTime = If[NullQ[myPrimerSamples],30 Minute,2 Hour];

	(* If QuenchingReagent and SequencingBuffer are Null, post-PCR sample processing time is 0 minutes *)
	postPCRSampleProcessingTime = If[NullQ[quenchingReagent]&&NullQ[sequencingBuffer],0 Minute,45 Minute];

	bigDyeXTerminator = If[NullQ[sequencingBuffer],False,If[StringContainsQ[sequencingBuffer[Name],"BigDye XTerminator"],True,False]];

	(* --- Generate the protocol packet --- *)
	protocolPacket=<|
		(*===Organizational Information===*)
		Object->CreateID[Object[Protocol,DNASequencing]],
		Type -> Object[Protocol,DNASequencing],
		Replace[SamplesIn]->Map[Link[#,Protocols]&,samplesInResources],
		Replace[ContainersIn]->Map[Link[Resource[Sample->#],Protocols]&,containersInObjects],


		(*===Options Handling===*)
		UnresolvedOptions->myUnresolvedOptions,
		ResolvedOptions->resolvedOptionsNoHidden,


		(*===General===*)
		Instrument->Link[instrumentResource],
		DataCollectionTime->geneticAnalyzerRunTime,
		SequencingCartridge->Link[sequencingCartridgeResource],
		BufferCartridge->Link[bufferCartridgeResource],
		BufferCartridgeSepta->Link[bufferCartridgeSeptaResource],
		ReplaceBufferCartridge->replaceBufferCartridge,
		Replace[InjectionGroups]->Lookup[myResolvedOptions,InjectionGroups],
		PreparedPlate->Lookup[myResolvedOptions,PreparedPlate],
		NumberOfInjections->Lookup[myResolvedOptions,NumberOfInjections],

		Replace[Checkpoints] -> {
			{"Preparing Samples",samplePreparationTime,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->samplePreparationTime]]},
			{"Picking Resources",resourcePickingTime,"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->resourcePickingTime]]},
			{"Preparing Assay Plate",assayPlatePreparationTime,"The ReadPlate is loaded with samples and reagents.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->assayPlatePreparationTime]]},
			{"Sample Processing",postPCRSampleProcessingTime,"Sample processing directly before the sequencing run, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->postPCRSampleProcessingTime]]},
			{"Capillary Electrophoresis",geneticAnalyzerRunTime,"The capillary electrophoresis procedure is performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->geneticAnalyzerRunTime]]},
			{"Returning Materials",1 Hour,"Samples are returned to storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->1 Hour]]}
		},

		(*===Sample Preparation===*)
		Replace[ReadLength]->Lookup[myResolvedOptions,ReadLength],
		Replace[SampleVolumes]->Lookup[myResolvedOptions,SampleVolume],
		Replace[ReactionVolumes]->Lookup[myResolvedOptions,ReactionVolume],
		Replace[Primers]->Map[Link[#]&,myPrimerSamples],
		Replace[PrimerVolumes]->Lookup[expandedResolvedOptions,PrimerVolume],
		Replace[PrimerConcentrations]->Lookup[expandedResolvedOptions,PrimerConcentration],
		Replace[PrimerResources]->Map[Link[#]&,primerSamplesResources],
		Replace[PrimerStorageConditions]->Lookup[expandedResolvedOptions,PrimerStorageCondition],
		Replace[MasterMix]->Map[Link[#]&,masterMixResources],
		Replace[MasterMixVolumes]->Lookup[expandedResolvedOptions,MasterMixVolume],
		Replace[MasterMixStorageConditions]->Lookup[expandedResolvedOptions,MasterMixStorageCondition],
		Replace[AdenosineTriphosphateTerminator]->Map[Link[#]&,Lookup[expandedResolvedOptions,AdenosineTriphosphateTerminator]],
		Replace[ThymidineTriphosphateTerminator]->Map[Link[#]&,Lookup[expandedResolvedOptions,ThymidineTriphosphateTerminator]],
		Replace[GuanosineTriphosphateTerminator]->Map[Link[#]&,Lookup[expandedResolvedOptions,GuanosineTriphosphateTerminator]],
		Replace[CytosineTriphosphateTerminator]->Map[Link[#]&,Lookup[expandedResolvedOptions,CytosineTriphosphateTerminator]],
		Replace[Diluents]->Map[Link[#]&,diluentResource],
		Replace[DiluentVolumes]->Lookup[expandedResolvedOptions,DiluentVolume],

		(*===Sample Loading===*)
		ReadPlate->Link[assayPlateResource],


		(*=================*)
		(*===PCR Options===*)
		(*=================*)

		(*===Activation===*)
		Activation->If[preparedPlate,Null,Lookup[myResolvedOptions,Activation]],
		ActivationTime->If[preparedPlate,Null,Lookup[myResolvedOptions,ActivationTime]],
		ActivationTemperature->If[preparedPlate,Null,Lookup[myResolvedOptions,ActivationTemperature]],
		ActivationRampRate->If[preparedPlate,Null,Lookup[myResolvedOptions,ActivationRampRate]],

		(*===Denaturation===*)
		DenaturationTime->If[preparedPlate,Null,Lookup[myResolvedOptions,DenaturationTime]],
		DenaturationTemperature->If[preparedPlate,Null,Lookup[myResolvedOptions,DenaturationTemperature]],
		DenaturationRampRate->If[preparedPlate,Null,Lookup[myResolvedOptions,DenaturationRampRate]],

		(*===Primer Annealing===*)
		PrimerAnnealing->If[preparedPlate,Null,Lookup[myResolvedOptions,PrimerAnnealing]],
		PrimerAnnealingTime->If[preparedPlate,Null,Lookup[myResolvedOptions,PrimerAnnealingTime]],
		PrimerAnnealingTemperature->If[preparedPlate,Null,Lookup[myResolvedOptions,PrimerAnnealingTemperature]],
		PrimerAnnealingRampRate->If[preparedPlate,Null,Lookup[myResolvedOptions,PrimerAnnealingRampRate]],

		(*===Strand Extension===*)
		ExtensionTime->If[preparedPlate,Null,Lookup[myResolvedOptions,ExtensionTime]],
		ExtensionTemperature->If[preparedPlate,Null,Lookup[myResolvedOptions,ExtensionTemperature]],
		ExtensionRampRate->If[preparedPlate,Null,Lookup[myResolvedOptions,ExtensionRampRate]],

		(*===Cycling===*)
		NumberOfCycles->If[preparedPlate,Null,Lookup[myResolvedOptions,NumberOfCycles]],

		(*===Infinite Hold===*)
		HoldTemperature->If[preparedPlate,Null,Lookup[myResolvedOptions,HoldTemperature]],


		(*===Post-PCR Sample Preparation===*)
		PurificationType->Lookup[myResolvedOptions,PurificationType],
		Replace[QuenchingReagents]->Map[Link[#]&,quenchingReagentResource],
		Replace[QuenchingReagentVolumes]->Lookup[myResolvedOptions,QuenchingReagentVolumes],
		VortexAdapter->Link[vortexAdapterRackResource],
		SequencingBuffer->Link[sequencingBufferResource],
		SequencingBufferVolume->Lookup[myResolvedOptions,SequencingBufferVolume],

		(*===Capillary Electrophoresis Separation===*)
		PlateSepta->Link[plateSeptaResource],
		Temperature->Lookup[myResolvedOptions,Temperature],
		Replace[DyeSets]->Flatten[Lookup[expandedResolvedOptions,DyeSet]],
		Replace[PrimeTimes]->Lookup[myResolvedOptions,PrimeTime],
		Replace[PrimeVoltages]->Lookup[myResolvedOptions,PrimeVoltage],
		Replace[InjectionTimes]->Lookup[myResolvedOptions,InjectionTime],
		Replace[InjectionVoltages]->Lookup[expandedResolvedOptions,InjectionVoltage],
		Replace[RampTimes]->Lookup[myResolvedOptions,RampTime],
		Replace[RunVoltages]->Lookup[expandedResolvedOptions,RunVoltage],
		Replace[RunTimes]->Lookup[expandedResolvedOptions,RunTime],
		CapillaryProtector -> Link[capillaryProtectorResource],
		SequencingCartridgeStorageCondition->Lookup[myUnresolvedOptions,SequencingCartridgeStorageCondition],
		PlateSeptaStorageCondition->Disposal

		|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples,myResolvedOptions,Cache->inheritedCache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];
	 
	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache->inheritedCache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache->inheritedCache], Null}
	];

	(*Generate the preview output rule; Preview is always Null*)
	previewRule=Preview->Null;

	(*Generate the options output rule*)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule,optionsRule,resultRule, testsRule}
];


(* ::Subsection::Closed:: *)
(*ExperimentDNASequencingOptions*)


DefineOptions[ExperimentDNASequencingOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentDNASequencing}
];


(*---Main function accepting sample/container objects as sample inputs and sample objects or Nulls as primer inputs---*)
ExperimentDNASequencingOptions[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],
	myPrimerSamples:ListableP[ObjectP[Object[Sample]]|Null|_String],
	myOptions:OptionsPattern[ExperimentDNASequencingOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Send in the correct Output option and remove the OutputFormat option*)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentDNASequencing[mySamples,myPrimerSamples,preparedOptions];

	(*Return the option as a list or table*)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentDNASequencing],
		resolvedOptions
	]
];


(*---Function definition accepting sample/container objects as sample inputs and no primer inputs---*)
ExperimentDNASequencingOptions[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],
	myOptions:OptionsPattern[ExperimentDNASequencingOptions]
]:=ExperimentDNASequencingOptions[
	mySamples,
	ConstantArray[Null,Length[ToList[mySamples]]],
	myOptions
];


(* ::Subsection::Closed:: *)
(*ExperimentDNASequencingPreview*)


DefineOptions[ExperimentDNASequencingPreview,
	SharedOptions:>{ExperimentDNASequencing}
];


(*---Main function accepting sample/container objects as sample inputs and sample objects or Nulls as primer pair inputs---*)
ExperimentDNASequencingPreview[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],
	myPrimerSamples:ListableP[ObjectP[Object[Sample]]|Null|_String],
	myOptions:OptionsPattern[ExperimentDNASequencingPreview]
]:=Module[{listedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	ExperimentDNASequencing[mySamples,myPrimerSamples,ReplaceRule[listedOptions,Output->Preview]]
];


(*---Function definition accepting sample/container objects as sample inputs and no primer pair inputs---*)
ExperimentDNASequencingPreview[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],
	myOptions:OptionsPattern[ExperimentDNASequencingPreview]
]:=ExperimentDNASequencingPreview[
	mySamples,
	ConstantArray[Null,Length[ToList[mySamples]]],
	myOptions
];


(* ::Subsection::Closed:: *)
(*ValidExperimentDNASequencingQ*)


DefineOptions[ValidExperimentDNASequencingQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions:>{ExperimentDNASequencing}
];


(*---Main function accepting sample/container objects as sample inputs and sample objects or Nulls as primer inputs---*)
ValidExperimentDNASequencingQ[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],
	myPrimerSamples:ListableP[ObjectP[Object[Sample]]|Null|_String],
	myOptions:OptionsPattern[ValidExperimentDNASequencingQ]
]:=Module[
	{listedOptions,preparedOptions,experimentDNASequencingTests,initialTestDescription,allTests,verbose,outputFormat},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Remove the output option before passing to the core function because it doesn't make sense here*)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(*Call the ExperimentDNASequencing function to get a list of tests*)
	experimentDNASequencingTests=ExperimentDNASequencing[mySamples,myPrimerSamples,Append[preparedOptions,Output->Tests]];

	(*Define the general test description*)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(*Make a list of all the tests, including the blanket test*)
	allTests=If[MatchQ[experimentDNASequencingTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings},

			(*Generate the initial test, which should pass if we got this far*)
			initialTest=Test[initialTestDescription,True,True];

			(*Create warnings for invalid objects*)
			validObjectBooleans=ValidObjectQ[Cases[Flatten[{mySamples,myPrimerSamples}],ObjectP[]],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Cases[Flatten[{mySamples,myPrimerSamples}],ObjectP[]],validObjectBooleans}
			];

			(*Get all the tests/warnings*)
			Cases[Flatten[{initialTest,experimentDNASequencingTests,voqWarnings}],_EmeraldTest]
		]
	];

	(*Look up the test-running options*)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(*Run the tests as requested*)
	Lookup[RunUnitTest[<|"ValidExperimentDNASequencingQ"->allTests|>,Verbose->verbose,OutputFormat->outputFormat],"ValidExperimentDNASequencingQ"]
];


(*---Function definition accepting sample/container objects as sample inputs and no primer inputs---*)
ValidExperimentDNASequencingQ[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],
	myOptions:OptionsPattern[ValidExperimentDNASequencingQ]
]:=ValidExperimentDNASequencingQ[
	mySamples,
	ConstantArray[Null,Length[ToList[mySamples]]],
	myOptions
];
