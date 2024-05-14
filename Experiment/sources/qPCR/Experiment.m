(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section::Closed:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ExperimentqPCR*)


(* Set a variable private to Experiment` to define the per-well dead volume for qPCR assay plate preparation *)
Experiment`Private`qPCRPrepDeadVolume = 10 Microliter;


(* ::Subsubsection::Closed:: *)
(*ExperimentqPCR Options and Messages*)


DefineOptions[ExperimentqPCR,
	Options :> {
		{
			OptionName->Instrument,
			Default -> Automatic,
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]],
			Description->"The instrument for running the quantitative polymerase chain reaction (qPCR) experiment."
		},
		{
			OptionName->AssayPlateStorageCondition,
			Default->Automatic,
			Description->"The conditions under which the thermocycled 384-well assay plate from this experiment should be stored after the protocol is completed. The assay plate is discarded by default.",
			ResolutionDescription->"Automatically set to Disposal if using a 384-well plate, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
			Category->"Post Experiment"
		},
		{
			OptionName->ArrayCardStorageCondition,
			Default->Automatic,
			Description->"The conditions under which the thermocycled array card from this experiment should be stored after the protocol is completed. The array card is discarded by default.",
			ResolutionDescription->"Automatically set to Disposal if using an array card, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
			Category->"Post Experiment"
		},
		{
			OptionName -> ReactionVolume,
			Default -> Automatic,
			Description -> "The total volume of the reaction including the sample, primers, probes, dyes and master mix. If using an array card, the final reaction volume in the microfluidic well following centrifugation.",
			ResolutionDescription->"Automatically set to 2 Microliter if using an array card, or 20 Microliter otherwise.",
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[2 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]
		},
		{
			OptionName->MasterMix,
			Default->Automatic,
			Description -> "The stock solution composed of enzymes (DNA polymerase and optionally reverse transcriptase), buffer, dyes and nucleotides used to amplify cDNA or gDNA.",
			ResolutionDescription->"Automatically set based on DuplexStainingDye and ReverseTranscription.",
			AllowNull -> False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample], Model[Sample]}]]
		},
		{
			OptionName->MasterMixVolume,
			Default->Automatic,
			Description -> "The volume of the master mix to add to the reaction. If using an array card, the initial volume of the master mix to be mixed with the sample then loaded into the array card reservoir.",
			ResolutionDescription->"Automatically set based on ReactionVolume and MasterMix.",
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]
		},
		{
			OptionName->MasterMixStorageCondition,
			Default->Null,
			Description->"The non-default condition under which the master mix used in this experiment should be stored after the protocol is completed. If left unset, the master mix will be stored according to its current StorageCondition.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
			Category->"Post Experiment"
		},
		{
			OptionName->StandardVolume,
			Default->Automatic,
			Description -> "The volume of the standard to add to the reaction.",
			ResolutionDescription->"Resolved automatically to 2 Microliter if a Standard is included in the experiment.",
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]
		},
		{
			OptionName->Buffer,
			Default->Automatic,
			Description -> "The chemical or stock solution used to bring each reaction to ReactionVolume once all other components have been added.",
			ResolutionDescription->"Automatically set to Model[Sample,\"Milli-Q water\"] if after the addition of all reaction components the volume has not reached ReactionVolume, or Null otherwise.",
			AllowNull -> False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample], Model[Sample]}]]
		},


		{
			OptionName->ReverseTranscription,
			Default->Automatic,
			Description->"Indicates if one-step reverse transcription is performed in order to convert RNA input samples to cDNA.",
			ResolutionDescription->"Automatically set to True if any reverse transcription related options are set, and False if none are set.",
			AllowNull->False,
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Reverse Transcription"
		},
		{
			OptionName->ReverseTranscriptionTime,
			Default->Automatic,
			Description->"The length of time for which the reaction volume will held at ReverseTranscriptionTemperature in order to convert RNA to cDNA.",
			ResolutionDescription->"Automatically set to 15 minutes if ReverseTranscription is set to True, and Null if it is set to False.",
			AllowNull->True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0 Second, 2 Hour],Units -> {1,{Second,{Second,Minute,Hour}}}],
			Category->"Reverse Transcription"
		},
		{
			OptionName->ReverseTranscriptionTemperature,
			Default->Automatic,
			Description->"The initial temperature at which the sample should be heated to in order to activate the reverse transcription enzymes in the master mix to convert RNA to cDNA.",
			ResolutionDescription->"Automatically set to 48 degrees Celsius if ReverseTranscription is set to True, and Null if it is set to False.",
			AllowNull->True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
			Category->"Reverse Transcription"
		},
		{
			OptionName->ReverseTranscriptionRampRate,
			Default->Automatic,
			Description->"The rate at which the reaction volume is heated to bring the sample to the reverse transcription temperature.",
			ResolutionDescription->"Automatically set to 1.6 Celsius/Second if ReverseTranscription is set to True, and Null if it is set to False.",
			AllowNull->True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[.015 (Celsius/Second), 3.4 (Celsius/Second)],Units -> CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Reverse Transcription"
		},


		{
			OptionName->Activation,
			Default->True,
			Description->"Indicates if polymerase hot start activation is performed. In order to reduce non-specific amplification, modern enzymes can be made room temperature stable by inhibiting their activity via thermolabile conjugates. Once an experiment is ready to be ran, this inhibition is removed by heating the reaction to ActivationTemperature.",
			AllowNull->False,
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Polymerase Activation"
		},
		{
			OptionName->ActivationTime,
			Default->Automatic,
			Description->"The length of time for which the reaction volume is held at ActivationTemperature in order to a remove the thermolabile conjugates inhibiting enzyme activity.",
			ResolutionDescription->"Automatically set to 1 minute if Activation is set to True.",
			AllowNull->True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0 Second, 2 Hour],Units -> {1,{Second,{Second,Minute,Hour}}}],
			Category->"Polymerase Activation"
		},
		{
			OptionName->ActivationTemperature,
			Default->Automatic,
			Description->"The temperature at which at which the thermolabile conjugates inhibiting enzyme activity are removed.",
			ResolutionDescription->"Automatically set to 95 degrees Celsius if Activation is set to True.",
			AllowNull->True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
			Category->"Polymerase Activation"
		},
		{
			OptionName->ActivationRampRate,
			Default->Automatic,
			Description->"The rate at which the reaction is heated to bring the sample to the ActivationTemperature.",
			AllowNull->True,
			ResolutionDescription->"Automatically set to 1.6 degrees Celsius per second if Activation is set to True.",
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[.015 (Celsius/Second), 3.4 (Celsius/Second)],Units -> CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Polymerase Activation"
		},


		{
			OptionName->DenaturationTime,
			Default->30 Second,
			Description->"The length of time for which the reaction is held at DenaturationTemperature in order to separate any double stranded template DNA into single strands.",
			AllowNull->False,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0 Second, 2 Hour],Units -> {1,{Second,{Second,Minute,Hour}}}],
			Category->"Denaturation"
		},
		{
			OptionName->DenaturationTemperature,
			Default->Quantity[95, "DegreesCelsius"],
			Description->"The temperature to which the sample is heated in order to disassociate double stranded template DNA into single strands.",
			AllowNull->False,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
			Category->"Denaturation"
		},
		{
			OptionName->DenaturationRampRate,
			Default->(1.6 (Celsius/Second)),
			Description->"The rate at which the reaction is heated to bring the sample to DenaturationTemperature.",
			AllowNull->False,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[.015 (Celsius/Second), 3.4 (Celsius/Second)],Units -> CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Denaturation"
		},


		{
			OptionName->PrimerAnnealing,
			Default->Automatic,
			Description->"Indicates if annealing should be performed as a separate step instead of as part of extension. Lowering the temperature during annealing allows primers to bind to template DNA to serve as anchor points for DNA polymerization in the subsequent extension stage.",
			ResolutionDescription->"Automatically set to True if any primer annealing related options are set, and False if none are set.",
			AllowNull->False,
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Primer Annealing"
		},
		{
			OptionName->PrimerAnnealingTime,
			Default->Automatic,
			Description->"The length of time for which the reaction is held at PrimerAnnealingTemperature in order to allow binding of primers to the template DNA.",
			ResolutionDescription->"Automatically set to 30 second if PrimerAnnealing is set to True, and Null if it is set to False.",
			AllowNull->True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0 Second, 2 Hour],Units -> {1,{Second,{Second,Minute,Hour}}}],
			Category->"Primer Annealing"
		},
		{
			OptionName->PrimerAnnealingTemperature,
			Default->Automatic,
			Description->"The temperature to which the sample is heated in order to allow primers to bind to the template strands.",
			ResolutionDescription->"Automatically set to 60 Celsius if PrimerAnnealing is set to True, and Null if it is set to False.",
			AllowNull->True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
			Category->"Primer Annealing"
		},
		{
			OptionName->PrimerAnnealingRampRate,
			Default->Automatic,
			Description->"The rate at which the reaction is heated to bring the sample to PrimerAnnealingTemperature.",
			ResolutionDescription->"Automatically set to 1.6 Celsius/Second if PrimerAnnealing is set to True, and Null if it is set to False.",
			AllowNull->True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[.015 (Celsius/Second), 3.4 (Celsius/Second)],Units -> CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Primer Annealing"
		},


		{
			OptionName->ExtensionTime,
			Default->60 Second,
			Description->"The length of time for which the polymerase synthesizes a new DNA strand using the provided primer pairs and template DNA.",
			AllowNull->False,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0 Second, 2 Hour],Units -> {1,{Second,{Second,Minute,Hour}}}],
			Category->"Strand Extension"
		},
		{
			OptionName->ExtensionTemperature,
			Default->Quantity[72, "DegreesCelsius"],
			Description->"The temperature at which the sample is held to allow the polymerase to synthesis new DNA strand from the template DNA.",
			AllowNull->False,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
			Category->"Strand Extension"
		},
		{
			OptionName->ExtensionRampRate,
			Default->(1.6 (Celsius/Second)),
			Description->"The rate at which the reaction is heated to bring the sample to ExtensionTemperature.",
			AllowNull->False,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[.015 (Celsius/Second), 3.4 (Celsius/Second)],Units -> CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Strand Extension"
		},
		{
			OptionName->NumberOfCycles,
			Default->40,
			Description->"The number of times the samples will undergo repeated cycles of melting, annealing and extension.",
			AllowNull->False,
			Widget -> Widget[Type->Number,Pattern :> RangeP[1,60]],
			Category->"Strand Extension"
		},
		{
			OptionName->MeltingCurve,
			Default->Automatic,
			Description->"Indicates if melt curve should be performed at the end of the experiment. The fluorescence of the DuplexStainingDye is monitored while the sample is slowly heated, allowing detection of products with different melting temperatures.",
			ResolutionDescription->"Automatically set to True for dye based assays and False to probe based assays.",
			AllowNull->False,
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Melting Curve"
		},
		{
			OptionName->MeltingCurveStartTemperature,
			Default->Automatic,
			Description->"The temperature at which to start the melting curve.",
			ResolutionDescription->"Automatically set to 60 Celsius if MeltingCurve is set to True, and Null if it is set to False.",
			AllowNull->True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
			Category->"Melting Curve"
		},
		{
			OptionName->MeltingCurveEndTemperature,
			Default->Automatic,
			Description->"The temperature at which to end the melting curve.",
			ResolutionDescription->"Automatically set to 95 Celsius if MeltingCurve is set to True, and Null if it is set to False.",
			AllowNull->True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
			Category->"Melting Curve"
		},
		{
			OptionName->PreMeltingCurveRampRate,
			Default->Automatic,
			Description->"The rate at which the temperature is decreased in order to bring the samples to MeltingCurveStartTemperature.",
			ResolutionDescription->"Automatically set to 1.6 Celsius/Second if MeltingCurve is set to True, and Null if it is set to False.",
			AllowNull->True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[.002 (Celsius/Second), 3.4 (Celsius/Second)],Units -> CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Melting Curve"
		},
		{
			OptionName->MeltingCurveRampRate,
			Default->Automatic,
			Description->"The rate at which the temperature is increased during in order to bring the samples from MeltingCurveStartTemperature to MeltingCurveEndTemperature.",
			ResolutionDescription->"Automatically set to .015 Celsius/Second if MeltingCurve is set to True, and Null if it is set to False.",
			AllowNull->True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[.015 (Celsius/Second), 3.4 (Celsius/Second)],Units -> CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Melting Curve"
		},
		{
			OptionName->MeltingCurveTime,
			Default->Automatic,
			Description->"The length of time it takes to change the temperature of the sample from MeltingCurveStartTemperature to MeltingCurveEndTemperature.",
			ResolutionDescription->"Automatically set to a value based on MeltingCurveRampRate.",
			AllowNull->True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0.01 Second, 24 Hour], Units -> {1,{Second,{Second,Minute,Hour}}}],
			Category->"Melting Curve"
		},

		{
			OptionName->DuplexStainingDye,
			Default->Automatic,
			Description -> "The fluorescent dye present in the reaction which intercalates between the base pairs of a double stranded DNA.",
			ResolutionDescription->"Automatically set to the duplex stain dye part of the MasterMix for dye based assay or Null if one isn't present.",
			AllowNull -> True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample], Model[Sample], Model[Molecule]}],ObjectTypes->{Object[Sample], Model[Sample], Model[Molecule]}],
			Category->"Dye Staining"
		},
		(* This is feature flagged in code; addition of Duplex-Staining Dye separate from master mix is currently not supported  *)
		{
			OptionName->DuplexStainingDyeVolume,
			Default->Automatic,
			Description -> "The volume of the fluorescent dye to add to the reaction.",
			ResolutionDescription->"Automatically set to Null if the dye is already part of the master mix or 1 Microliter if it is being added separately.",
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 200 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
			Category->"Dye Staining"
		},
		{
			OptionName->DuplexStainingDyeExcitationWavelength,
			Default->Automatic,
			Description -> "The wavelength of light used to excite the fluorescent reporter dye.",
			ResolutionDescription->"Automatically set to the wavelength excitation wavelength of the DuplexStainingDye",
			AllowNull -> True,
			Widget->Widget[Type -> Enumeration,Pattern :> qPCRExcitationWavelengthP],
			Category->"Detection"
		},
		{
			OptionName->DuplexStainingDyeEmissionWavelength,
			Default->Automatic,
			Description -> "The wavelength of light emitted by the fluorescent reporter dye once it has been excited and read by the instrument.",
			ResolutionDescription->"Automatically set to the emission wavelength of the DuplexStainingDye",
			AllowNull -> True,
			Widget->Widget[Type -> Enumeration,Pattern :> qPCREmissionWavelengthP],
			Category->"Detection"
		},


		{
			OptionName->ReferenceDye,
			Default->Automatic,
			Description -> "The fluorescent dye present in the reaction which does not takes part of the reaction and is used for signal normalization.",
			ResolutionDescription->"Automatically set to the passive dye present in the master mix.",
			AllowNull -> True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample], Model[Sample], Model[Molecule]}],ObjectTypes->{Object[Sample], Model[Sample], Model[Molecule]}],
			Category->"Dye Staining"
		},
		(* This is feature flagged in code; addition of Reference Dye separate from master mix is currently not supported  *)
		{
			OptionName->ReferenceDyeVolume,
			Default->Automatic,
			Description -> "The volume of the fluorescent reference dye to add to the reaction.",
			ResolutionDescription->"Automatically set to Null when using a pre-made master mix.",
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
			Category->"Dye Staining"
		},
		{
			OptionName->ReferenceDyeExcitationWavelength,
			Default->Automatic,
			Description -> "The wavelength of light used to excite the fluorescent reference dye.",
			ResolutionDescription->"Automatically set to the wavelength excitation wavelength of the ReferenceDye",
			AllowNull -> True,
			Widget->Widget[Type -> Enumeration,Pattern :> qPCRExcitationWavelengthP],
			Category->"Detection"
		},
		{
			OptionName->ReferenceDyeEmissionWavelength,
			Default->Automatic,
			Description -> "The wavelength of light emitted by the fluorescent reference dye once it has been excited and read by the instrument.",
			ResolutionDescription->"Automatically set to the emission wavelength of the ReferenceDye",
			AllowNull -> True,
			Widget->Widget[Type -> Enumeration,Pattern :> qPCREmissionWavelengthP],
			Category->"Detection"
		},


		(* standard - this might need to be in a different section, since the number of standard curves might not necessary have to be tied to the number of samplesin *)
		IndexMatching[
			IndexMatchingParent->Standard,
			{
				OptionName->Standard,
				Default->Null,
				Description -> "The sample that is serially diluted in order to construct a standard curve.",
				AllowNull -> True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}],
				Category->"Standard Curve"
			},
			{
				OptionName->StandardStorageCondition,
				Default->Null,
				Description->"The non-default conditions under which the standards of this experiment should be stored after the protocol is completed. If left unset, the standards will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},
			{
				OptionName->StandardPrimerPair,
				Default->Null,
				Description -> "The primer pair used to amplify a target sequence in Standard.",
				AllowNull -> True,
				Widget->Alternatives[
					{
						"Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}],
						"Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}]
					},
					Widget[Type->Enumeration, Pattern:>Alternatives[{Null,Null}]]
				],
				Category->"Standard Curve"
			},

			{
				OptionName->SerialDilutionFactor,
				Default->Automatic,
				Description -> "The factor by which the standard should be serially diluted with Buffer.",
				ResolutionDescription->"Resolved automatically to 2, meaning that each standard serial dilution will be twofold.",
				AllowNull -> True,
				Widget -> Widget[Type->Number,Pattern :> RangeP[1,100]],
				Category->"Standard Curve"
			},
			{
				OptionName->NumberOfDilutions,
				Default->Automatic,
				Description -> "The number of times the standard should serially diluted, including the original (undiluted) standard sample.",
				ResolutionDescription->"Resolved automatically to 8, meaning the standard curve will consist of the undiluted standard sample followed by 7 serial dilutions by SerialDilutionFactor.",
				AllowNull -> True,
				Widget -> Widget[Type->Number,Pattern :> RangeP[1,12]],
				Category->"Standard Curve"
			},
			{
				OptionName->NumberOfStandardReplicates,
				Default->Automatic,
				Description -> "The number of times the standard should be replicated per each unique set of primer target pairs.",
				ResolutionDescription->"Resolved automatically to 1.",
				AllowNull -> True,
				Widget -> Widget[Type->Number,Pattern :> RangeP[1,10]],
				Category->"Standard Curve"
			},
			(* Each standard can have only one primer pair *)
			{
				OptionName->StandardForwardPrimerVolume,
				Default->Automatic,
				Description -> "The total volume of each forward primer to add to the standard reaction.",
				ResolutionDescription->"Automatically resolves to match StandardReversePrimerVolume; otherwise, defaults to 1 Microliter.",
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
				Category->"Standard Curve"
			},
			{
				OptionName->StandardForwardPrimerStorageCondition,
				Default->Null,
				Description->"The non-default conditions under which the forward primers for the standards of this experiment should be stored after the protocol is completed. If left unset, the forward primers for standards will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},
			{
				OptionName->StandardReversePrimerVolume,
				Default->Automatic,
				Description -> "The total volume of each reverse primer to add to the standard reaction.",
				ResolutionDescription->"Automatically resolves to match StandardForwardPrimerVolume; otherwise, defaults to 1 Microliter.",
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
				Category->"Standard Curve"
			},
			{
				OptionName->StandardReversePrimerStorageCondition,
				Default->Null,
				Description->"The non-default conditions under which the reverse primers for the standards of this experiment should be stored after the protocol is completed. If left unset, the reverse primers for standards will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},

			{
				OptionName->StandardProbe,
				Default->Null,
				Description -> "The short oligomer strand containing a reporter and quencher, which when separated during the synthesis reaction will result in fluorescence.",
				AllowNull -> True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}],
				Category->"Standard Curve"
			},
			{
				OptionName->StandardProbeVolume,
				Default->Automatic, (* automatic because might be dye qPCR *)
				Description -> "The volume of the standard probe to add to the reaction.",
				ResolutionDescription->"Automatically set to 1 Microliter if a Standard Probe is being used.",
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
				Category->"Standard Curve"
			},
			{
				OptionName->StandardProbeStorageCondition,
				Default->Null,
				Description->"The non-default conditions under which the probes for the standards of this experiment should be stored after the protocol is completed. If left unset, the probes for standards will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},
			{
				OptionName->StandardProbeFluorophore,
				Default->Automatic,
				Description -> "The fluorescent molecule conjugated to the standard probe that allows for detection of amplification.",
				AllowNull -> True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[Model[Molecule]],ObjectTypes->{Model[Molecule]}],
				Category->"Detection"
			},
			{
				OptionName->StandardProbeExcitationWavelength,
				Default->Automatic,
				Description -> "The wavelength of light used to excite the reporter component of the standard probe.",
				ResolutionDescription->"Automatically set to a wavelength appropriate to the fluorophore attached to the standard probe.",
				AllowNull -> True,
				Widget->Widget[Type -> Enumeration,Pattern :> qPCRExcitationWavelengthP],
				Category->"Detection"
			},
			{
				OptionName->StandardProbeEmissionWavelength,
				Default->Automatic,
				Description -> "The wavelength of light emitted by the reporter once it has been excited and read by the instrument.",
				ResolutionDescription->"Automatically set to a wavelength appropriate to the fluorophore attached to the standard probe.",
				AllowNull -> True,
				Widget->Widget[Type -> Enumeration,Pattern :> qPCREmissionWavelengthP],
				Category->"Detection"
			}

		],
		

		IndexMatching[
			IndexMatchingInput->"experiment samples",

			{
				OptionName -> SampleVolume,
				Default -> Automatic,
				Description -> "The volume of the sample from which the target will be amplified to add to the reaction. If using an array card, the initial volume of the sample to be mixed with the master mix then loaded into the array card reservoir.",
				ResolutionDescription-> "Automatically set to 48 Microliter if using an array card, or 2 Microliter otherwise.",
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]
			},
			(* BufferVolume doesn't need to be primer pair index matched, just sample index matched. Only need to fill to volume with buffer on a per-well basis *)
			{
				OptionName -> BufferVolume,
				Default -> Automatic,
				Description -> "The volume, if any, of buffer added to bring the total volume up to ReactionVolume (if using an array card, ReactionVolume*48).",
				ResolutionDescription-> "Automatically set to a value based on the volume of all other reaction components.",
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]
			},
			{
				OptionName->ForwardPrimerVolume,
				Default->Automatic,
				Description -> "The total volume of each forward primer to add to the reaction.",
				ResolutionDescription->"Automatically set to Null if ArrayCard is True, otherwise it is set to ReversePrimerVolume (if specified) or 1 Microliter.",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
					Adder[Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]]
				]
			},
			{
				OptionName->ForwardPrimerStorageCondition,
				Default->Null,
				Description->"The non-default conditions under which the forward primers of this experiment should be stored after the protocol is completed. If left unset, the forward primers will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
					Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
				],
				Category->"Post Experiment"
			},
			{
				OptionName->ReversePrimerVolume,
				Default->Automatic,
				Description -> "The total volume of each reverse primer to add to the reaction.",
				ResolutionDescription->"Automatically set to Null if ArrayCard is True, otherwise it is set to ForwardPrimerVolume (if specified) or 1 Microliter.",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
					Adder[Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]]
				]
			},
			{
				OptionName->ReversePrimerStorageCondition,
				Default->Null,
				Description->"The non-default conditions under which the reverse primers of this experiment should be stored after the protocol is completed. If left unset, the reverse primers will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
					Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
				],
				Category->"Post Experiment"
			},

			{
				OptionName->Probe,
				Default->Automatic,
				Description -> "The short oligomer strand containing a reporter and quencher, which when separated during the synthesis reaction will result in fluorescence.",
				ResolutionDescription->"Automatically set to the sample from the array card if ArrayCard is True, or Null otherwise.",
				AllowNull -> True,
				Widget->Alternatives[
					Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}],
					Adder[Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}]]
				]
			},
			{
				OptionName->ProbeVolume,
				Default->Automatic, (* automatic because might be dye qPCR or we're resolving from concentration*)
				Description -> "The volume of the probe to add to the reaction.",
				ResolutionDescription->"Automatically set to Null if ArrayCard is True or Probe is Null, or 1 Microliter otherwise.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
					Adder[Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]]
				]
			},
			{
				OptionName->ProbeStorageCondition,
				Default->Null,
				Description->"The non-default conditions under which the probes of this experiment should be stored after the protocol is completed. If left unset, the probes will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
					Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
				],
				Category->"Post Experiment"
			},
			{
				OptionName->ProbeFluorophore,
				Default->Automatic,
				Description -> "The fluorescent molecule conjugated to the probe that allows for detection of amplification.",
				ResolutionDescription->"Automatically set from the array card model if ArrayCard is True, or Null otherwise.",
				AllowNull -> True,
				Widget -> Alternatives[
					(* Include the singleton case ONLY to allow for unlisted specification of fluorophore in cases with only one probe *)
					Widget[Type->Object,Pattern:>ObjectP[Model[Molecule]],ObjectTypes->{Model[Molecule]}],
					Adder[Widget[Type->Object,Pattern:>ObjectP[Model[Molecule]],ObjectTypes->{Model[Molecule]}]]
				],
				Category->"Detection"
			},
			{
				OptionName->ProbeExcitationWavelength,
				Default->Automatic,
				Description -> "The wavelength of light used to excite the reporter component of the probe.",
				ResolutionDescription->"Automatically set to a wavelength appropriate to the fluorophore attached to the probe.",
				AllowNull -> True,
				Widget->Alternatives[
					Widget[Type -> Enumeration,Pattern :> qPCRExcitationWavelengthP],
					Adder[Widget[Type -> Enumeration,Pattern :> qPCRExcitationWavelengthP]]
				],
				Category->"Detection"
			},
			{
				OptionName->ProbeEmissionWavelength,
				Default->Automatic,
				Description -> "The wavelength of light emitted by the reporter once it has been excited and read by the instrument.",
				ResolutionDescription->"Automatically set to a wavelength appropriate to the fluorophore attached to the probe.",
				AllowNull -> True,
				Widget->Alternatives[
					Widget[Type -> Enumeration,Pattern :> qPCREmissionWavelengthP],
					Adder[Widget[Type -> Enumeration,Pattern :> qPCREmissionWavelengthP]]
				],
				Category->"Detection"
			},
			{
				OptionName->EndogenousPrimerPair,
				Default->Null,
				Description ->"The pair of short oligomer strands designed to amplify an endogenous control gene (such as a housekeeping gene) whose expression should not different between samples.",
				AllowNull -> True,
				Widget->{
					"Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}],
					"Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}]
				}
			},
			{
				OptionName->EndogenousForwardPrimerVolume,
				Default->Automatic,
				Description -> "The total volume of each endogenous control forward primer to add to the reaction.",
				ResolutionDescription->"Automatically resolves to match EndogenousReversePrimerVolume; otherwise, defaults to 1 Microliter.",
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]
			},
			{
				OptionName->EndogenousForwardPrimerStorageCondition,
				Default->Null,
				Description->"The non-default conditions under which the endogenous forward primers of this experiment should be stored after the protocol is completed. If left unset, the endogenous forward primer will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},
			{
				OptionName->EndogenousReversePrimerVolume,
				Default->Automatic,
				Description -> "The total volume of each endogenous control reverse primer to add to the reaction.",
				ResolutionDescription->"Automatically resolves to match EndogenousForwardPrimerVolume; otherwise, defaults to 1 Microliter.",
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]
			},
			{
				OptionName->EndogenousReversePrimerStorageCondition,
				Default->Null,
				Description->"The non-default conditions under which the endogenous reverse primers of this experiment should be stored after the protocol is completed. If left unset, the endogenous reverse primer will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},

			{
				OptionName->EndogenousProbe,
				Default->Null,
				Description -> "The short oligomer strand containing a reporter and quencher, which when separated during the synthesis reaction will result in fluorescence.",
				AllowNull -> True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}]
			},
			{
				OptionName->EndogenousProbeVolume,
				Default->Automatic, (* automatic because might be dye qPCR *)
				Description -> "The volume of the probe to add to the reaction.",
				ResolutionDescription->"Automatically set to 1 Microliter if an endogenous probe is being used.",
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 50 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}]
			},
			{
				OptionName->EndogenousProbeStorageCondition,
				Default->Null,
				Description->"The non-default conditions under which the endogenous probes of this experiment should be stored after the protocol is completed. If left unset, the endogenous probe will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			},
			{
				OptionName->EndogenousProbeFluorophore,
				Default->Automatic,
				Description -> "The fluorescent molecule conjugated to the endogenous probe that allows for detection of amplification.",
				AllowNull -> True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[Model[Molecule]],ObjectTypes->{Model[Molecule]}],
				Category->"Detection"
			},
			{
				OptionName->EndogenousProbeExcitationWavelength,
				Default->Automatic,
				Description -> "The wavelength of light used to excite the reporter component of the endogenous probe.",
				ResolutionDescription->"Automatically set to a wavelength appropriate to the fluorophore attached to the endogenous probe.",
				AllowNull -> True,
				Widget->Widget[Type -> Enumeration,Pattern :> qPCRExcitationWavelengthP],
				Category->"Detection"
			},
			{
				OptionName->EndogenousProbeEmissionWavelength,
				Default->Automatic,
				Description -> "The wavelength of light emitted by the reporter once it has been excited and read by the instrument.",
				ResolutionDescription->"Automatically set to a wavelength appropriate to the fluorophore attached to the endogenous probe.",
				AllowNull -> True,
				Widget->Widget[Type -> Enumeration,Pattern :> qPCREmissionWavelengthP],
				Category->"Detection"
			}

		],


		FuntopiaSharedOptions,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions,
		MoatOptions,
		AnalyticalNumberOfReplicatesOption
	}
];


(* Define the error messages *)
Error::DuplexStainingDyeSpecifiedWithMultiplex="If DuplexStainingDye is specified, no sample should contain more than one primer pair. Please change either the primer pair input or DuplexStainingDye option, or leave DuplexStainingDye unspecified to be set automatically.";
Error::ProbeDuplexStainingDyeConflict="If Probe is specified for any sample, DuplexStainingDye cannot be specified. Please change either or both option(s), or leave DuplexStainingDye unspecified to be set automatically.";
Error::IncompleteDuplexStainingDyeExcitationEmissionPair="If either DuplexStainingDyeExcitationWavelength or DuplexStainingDyeEmissionWavelength is specified, the other should also be specified. Please change either or both option(s), or leave both unspecified to be set automatically.";
Error::IncompleteReferenceDyeExcitationEmissionPair="If either ReferenceDyeExcitationWavelength or ReferenceDyeEmissionWavelength is specified, the other should also be specified. Please change either or both option(s), or leave both unspecified to be set automatically.";
Error::IncompleteProbeExcitationEmissionPair="For each sample, if either ProbeExcitationWavelength or ProbeEmissionWavelength is specified, the other should also be specified. Please change either or both option(s), or leave both unspecified to be set automatically.";
Error::IncompleteStandardProbeExcitationEmissionPair="For each sample, if either StandardProbeExcitationWavelength or StandardProbeEmissionWavelength is specified, the other should also be specified. Please change either or both option(s), or leave both unspecified to be set automatically.";
Error::IncompleteEndogenousProbeExcitationEmissionPair="For each sample, if either EndogenousProbeExcitationWavelength or EndogenousProbeEmissionWavelength is specified, the other should also be specified. Please change either or both option(s), or leave both unspecified to be set automatically.";
Error::CalculatedRampRateOutOfRange="The calculated melting curve ramp rate, `1`, is outside the allowable range of 0.002 C/sec to 3.4 C/sec based on the specified start temperature (`2`), end temperature (`3`), and time (`4`). Please modify the specified melting curve time to move ramp rate into the allowable range.";
Error::StandardPrimersRequired="If Standard is specified, StandardPrimerPair must also be specified. Please either remove the specified Standard option or specify the StandardPrimerPair with which the standard samples should be amplified.";
Error::ProbeLengthError="The length of the Probe option (`1`) mismatches the length of the primer input (`2`) for the following samples: `3`. If Probe is specified, its length must match the number of primer pairs specified for each sample in ExperimentqPCR function input. Please confirm that one probe is specified for each primer pair.";
Error::ProbeVolumeLengthError="The length of the ProbeVolume option (`1`) does not match the length of the Probe option (`2`) for the following samples: `3`. If different volumes are desired for each probe, please ensure that the number of volumes specified matches the number of probes specified.";
Error::MultiplexingWithoutProbe="Multiple primer pairs (`1`) have been specified for the following samples (`2`) when using duplex staining dye to monitor amplification. Multiplexing is not possible in a duplex staining dye qPCR assay. Please supply only one primer pair per input sample or use the Probe option to specify the use of hydrolysis probes if multiplexing is desired.";
Error::ExcessiveVolume="The total volume of all components (sample, primers, probes, master mix, buffer) exceeds the reaction volume of `1` for the following samples: `2`. Please increase the total reaction volume or decrease component volume(s).";
Error::qPCRBufferVolumeMismatch="The volume remaining to be filled with buffer after addition of all other components (sample, primers, probes, master mix) does not match the specified BufferVolume (`1`) for the following samples: `2`. Please correct the specified buffer volume(s) or allow BufferVolume to resolve automatically.";
Error::DependentSampleOptionMissing="The `1` option has been specified without the `2` option on which it depends for the following samples: `3`. Please be sure to only specify `1` when `2` is also specified.";
Error::DependentOptionMissing="The `1` option has been specified without the `2` option on which it depends. Please be sure to only specify `1` when `2` is also specified.";
Error::PrimerVolumeLengthError="The length of the `4` option (`1`) does not match the length of the Primer input (`2`) for the following samples: `3`. If different volumes are desired for each primer, please ensure that the number of volumes specified matches the number of primer pairs specified.";
Error::SeparateDyesNotSupported="Addition of duplex staining and passive reference dyes separate from the specified master mix is not currently supported. Please attempt to select a master mix containing the desired combination of dyes.";
Error::ProbeFluorophoreLengthError="The length of the ProbeFluorophore option (`1`) does not match the length of the Probe option (`2`) for the following samples: `3`. Please ensure that the number of fluorophores specified matches the number of probes specified.";
Error::InvalidMeltEndpoints="The specified MeltingCurveStartTemperature, `1`, is greater than or equal to the specified MeltingCurveEndTemperature, `2`. MeltingCurveStartTemperature must be less than MeltingCurveEndTemperature. Please check your input and try again, or allow these options to resolve automatically.";
Error::InvalidThermocycler="The specified Thermocycler, `1`, is not a qPCR-capable thermocycler instrument or model. Please be sure to specify a thermocycler instrument that is capable of gathering real-time fluorescence data.";
Error::DisabledFeatureOptionSpecified="The master switch option `1` is off (False), but the following subordinate options have been specified: `2`. Please either turn `1` to True or avoid specifying its subordinate options.";
Error::EndogenousPrimersWithoutProbe="Endogenous control primers have been specified without a corresponding EndogenousProbe for the following samples: `1`. Endogenous controls are run in the same well as sample amplification for each member of SamplesIn, so probes must be used for detection. Please be sure to specify EndogenousPrimerPair and EndogenousProbe together.";
(* Non-index-matched Null Volume error to allow reporting of null volumes for non-sample-associated Null volumes *)
Error::NullVolume="If all or part of the option `1` is non-Null, the corresponding part of its associated volume option `2` must also be non-Null. Please ensure that non-Null volumes are specified as appropriate.";
(* SamplesIn-index-matched Null Volume error to allow reporting of specific failing samples *)
Error::NullSampleVolume="If all or part of the option `1` is non-Null, the corresponding part of its associated volume option `2` must also be non-Null. This condition is not satisifed for the following samples: `3`. Please ensure that non-Null volumes are specified as appropriate.";
Error::DuplicateProbeWavelength="One or more probe Excitation/Emission pairs are duplicated for the following samples: `1`. Please check sample and endogenous probe Excitation/Emission pairs for these samples and ensure that they are free of duplicates.";

(* Storage condition errors *)
Error::ForwardPrimerStorageConditionnMismatch="At indices, `1`, the length of primerPairs is not the same as the length but ForwardPrimerStorageCondition is not set to Null. ForwardPrimerStorageCondition can only be set to the same length of the primer pairs or a single storage condition for all pairs. Please change these options to specify a valid experiment.";
Error::ReversePrimerStorageConditionnMismatch="At indices, `1`, the length of primerPairs is not the same as the length but ReversePrimerStorageCondition is not set to Null. ReversePrimerStorageCondition can only be set to the same length of the primer pairs or a single storage condition for all pairs. Please change these options to specify a valid experiment.";
Error::ProbeStorageConditionMismatch="At indices, `1`, ProbeStorageCondition does not match the specified Probe. ProbeStorageCondition can only be set when a Probe is given and can only be set to the same length of the probes or a single storage condition for all probes. Please change these options to specify a valid experiment.";
Error::StandardStorageConditionMismatch="Standard is set to Null but StandardStorageCondition is not set to Null. StandardStorageCondition can only be set if a Standard is given. Please change these options to specify a valid experiment.";
Error::StandardForwardPrimerStorageConditionMismatch="At indices, `1`, Standard is set to Null but StandardForwardPrimerStorageCondition is not set to Null. StandardForwardPrimerStorageCondition can only be set if a StandardPrimerPair is given. Please change these options to specify a valid experiment.";
Error::StandardReversePrimerStorageConditionMismatch="At indices, `1`, StandardPrimerPair is set to Null but StandardReversePrimerStorageCondition is not set to Null. StandardReversePrimerStorageCondition can only be set if a StandardPrimerPair is given. Please change these options to specify a valid experiment.";
Error::StandardProbeStorageConditionMismatch="At indices, `1`, StandardProbe is set to Null but StandardProbeStorageCondition is not set to Null. StandardProbeStorageCondition can only be set if a StandardProbe is given. Please change these options to specify a valid experiment.";
Error::EndogenousForwardPrimerStorageConditionMismatch="At indices, `1`, EndogenousPrimerPair is set to Null but EndogenousForwardPrimerStorageCondition is not set to Null. EndogenousForwardPrimerStorageCondition can only be set if a EndogenousPrimerPair is given. Please change these options to specify a valid experiment.";
Error::EndogenousReversePrimerStorageConditionMismatch="At indices, `1`, EndogenousPrimerPair is set to Null but EndogenousReversePrimerStorageCondition is not set to Null. EndogenousReversePrimerStorageCondition can only be set if a EndogenousPrimerPair is given. Please change these options to specify a valid experiment.";
Error::EndogenousProbeStorageConditionMismatch="At indices, `1`, EndogenousProbe is set to Null but EndogenousProbeStorageCondition is not set to Null. EndogenousProbeStorageCondition can only be set if a EndogenousProbe is given. Please change these options to specify a valid experiment.";
Error::QPCRConflictingStorageConditions="The samples `1` are given different storage conditions in `2` options. Please make sure they match and only one storage condition is specified per identical sample.";

(* Array card errors *)
Error::DiscardedArrayCard="The input array card `1` is discarded and thereby cannot be used for the experiment.";
Error::ArrayCardTooManySamples="The number of input samples cannot fit onto the array card. Please select 8 or fewer samples to run this protocol.";
Error::ArrayCardContentsMismatch="The number of samples on the input array card does not match the number of ForwardPrimers, ReversePrimers, and Probes from the array card model. Please check the Contents of the array card.";
Error::InvalidArrayCardReagentOptions="If using an array card, the ForwardPrimer, ReversePrimer, and Probe options `1` cannot be specified. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::InvalidArrayCardEndogenousOptions="If using an array card, the Endogenous options `1` cannot be specified. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::InvalidArrayCardStandardOptions="If using an array card, the Standard options `1` cannot be specified. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::InvalidArrayCardDuplexStainingDyeOptions="If using an array card, the DuplexStainingDye options `1` cannot be specified. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::InvalidArrayCardMeltingCurveOptions="If using an array card, the MeltingCurve options `1` cannot be specified. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::InvalidArrayCardMoatOptions="If using an array card, the Moat options `1` cannot be specified. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::InvalidArrayCardReplicateOption="If using an array card, the NumberOfReplicates option cannot be specified. Please change the values of this option, or leave it unspecified to be set automatically.";
Error::ArrayCardExcessiveVolume="If using an array card, the total volume of all components (sample, master mix, buffer) cannot exceed the reaction volume of `1`*48 for the following samples: `2`. Please decrease the component volume(s).";

(* Define the warning messages *)
Warning::StandardPrimerPairNotAmongInputs="The specified standard primer pair(s) `1` do not appear in the set of input primer pairs and thus may not be useful for the quantification of experimental results.";
Warning::UnknownMasterMix="The specified master mix model, `1`, has not been evaluated for use in ExperimentqPCR and has unknown concentration, dye content, and reverse transcriptase content. Unless specified otherwise, the master mix will be used at 2x concentration and will be assumed to contain `2`. Please refer to the ExperimentqPCR documentation for a list of known master mixes.";


(* ::Subsubsection::Closed:: *)
(*ExperimentqPCR*)


(*---384-well plate overload accepting sample objects as template inputs and sample models/objects as primer pair inputs---*)
ExperimentqPCR[
	myExperimentSampleInputs:ListableP[ObjectP[Object[Sample]]],
	myExperimentPrimerInputs:ListableP[{{ObjectP[{Model[Sample],Object[Sample]}],ObjectP[{Model[Sample],Object[Sample]}]}..}],
	myOptions:OptionsPattern[]
]:=Module[
	{
		listedOptions,listedSamples,listedPrimerPairSamples,flatPrimerPairSamples,primerPairLengths,outputSpecification,output,gatherTests,validSamplePreparationResult,
		myExperimentSampleInputsWithPreparedSamplesNamed,myFlatPrimerPairSamplesWithPreparedSamplesNamed,myPrimerPairSamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCacheNamed,safeOpsNamed,
		myExperimentSampleInputsWithPreparedSamples,initialOptionsWithPreparedSamples,initialSamplePreparationCache,myPrimerPairSamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache,
		safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,templateTests,
		inheritedOptions,upload,confirm,fastTrack,parentProtocol,cache,myPrimerPairSamplesWithPreparedSamplesForExpansion,expandedSamples,expandedPrimerPairSamples,expandedSafeOps,
		assayPlateModel,downloadedPackets,
		cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions, sampleFields, objectContainerFields, modelContainerFields, combinedCacheWithSamplePreparation,
		qPCRCompatibleFluorophores, potentialFluorophoreContainingObjects, possiblyNamedOptions, instrumentOption, liquidHandlerContainers,
		resourcePackets, resourcePacketTests, protocolObject
	},

	(* Make sure we're working with a list of options, and get rid of all links *)
	listedOptions=ReplaceRule[
		ReplaceAll[ToList[myOptions],Link[x_, y___] :> x],
		{Cache->Lookup[ToList[myOptions],Cache,{}]}
	];

	listedSamples=ToList[myExperimentSampleInputs];
	listedPrimerPairSamples=Switch[
		myExperimentPrimerInputs,
		{{ObjectP[],ObjectP[]}..},{myExperimentPrimerInputs},
		{{{ObjectP[],ObjectP[]}..}..},myExperimentPrimerInputs
	];
 
	(*Flatten listedPrimerPairSamples to a list of primer pairs*)
	flatPrimerPairSamples=Flatten[listedPrimerPairSamples,1];
	primerPairLengths=Length/@listedPrimerPairSamples;

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	
	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		{myExperimentSampleInputsWithPreparedSamplesNamed,initialOptionsWithPreparedSamples,initialSamplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentqPCR,
			listedSamples,
			listedOptions
		];
		{myFlatPrimerPairSamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCacheNamed}=simulateSamplePreparationPackets[
			ExperimentqPCR,
			flatPrimerPairSamples,
			ReplaceRule[initialOptionsWithPreparedSamples,
				Cache->FlattenCachePackets[{
					Lookup[initialOptionsWithPreparedSamples,Cache,{}],
					initialSamplePreparationCache
				}]
			]
		],
		$Failed,
	 	{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Bring back the nested form of primer pairs. *)
	myPrimerPairSamplesWithPreparedSamplesNamed=TakeList[myFlatPrimerPairSamplesWithPreparedSamplesNamed,primerPairLengths];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentqPCR,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentqPCR,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	{{myExperimentSampleInputsWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples},{safeOps,myOptionsWithPreparedSamples,samplePreparationCache}}=sanitizeInputs[{myExperimentSampleInputsWithPreparedSamplesNamed,myPrimerPairSamplesWithPreparedSamplesNamed},{safeOpsNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCacheNamed}];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentqPCR,{myExperimentSampleInputsWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentqPCR,{myExperimentSampleInputsWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
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
		ApplyTemplateOptions[ExperimentqPCR,{myExperimentSampleInputsWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentqPCR,{myExperimentSampleInputsWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* get assorted hidden options *)
	{upload,confirm,fastTrack,parentProtocol,cache} = Lookup[inheritedOptions,{Upload,Confirm,FastTrack,ParentProtocol,Cache}];

	(* Prepare myPrimerPairSamplesWithPreparedSamples for expansion: if it consists of primer pairs for only one sample, then remove the outer list so it can be expanded *)
	myPrimerPairSamplesWithPreparedSamplesForExpansion=Switch[
		myPrimerPairSamplesWithPreparedSamples,
		{{{ObjectP[],ObjectP[]}..}},Flatten[myPrimerPairSamplesWithPreparedSamples,1],
		{{{ObjectP[],ObjectP[]}..}..},myPrimerPairSamplesWithPreparedSamples
	];

	(* Expand index-matching inputs and options *)
	{{expandedSamples,expandedPrimerPairSamples},expandedSafeOps}=ExpandIndexMatchedInputs[ExperimentqPCR,{myExperimentSampleInputsWithPreparedSamples,myPrimerPairSamplesWithPreparedSamplesForExpansion},inheritedOptions];

	sampleFields = SamplePreparationCacheFields[Object[Sample], Format -> Packet];
	objectContainerFields = SamplePreparationCacheFields[Object[Container]];
	modelContainerFields = SamplePreparationCacheFields[Model[Container]];

	(* Combine incoming cache with sample preparation cache *)
	combinedCacheWithSamplePreparation = FlattenCachePackets[{cache, samplePreparationCache}];

	(* Download all fluorophores known to be compatible with ECL qPCR instrumentation *)
	qPCRCompatibleFluorophores = {
		Model[Molecule, "id:9RdZXv1oADYx"], (* FAM *)
		Model[Molecule, "id:R8e1PjpZ7ZEd"], (* VIC *)
		Model[Molecule, "id:lYq9jRxPaPGV"], (* ROX *)
		Model[Molecule, "id:lYq9jRxPaDEl"], (* SYBR *)
		Model[Molecule, "id:jLq9jXvm3mK6"], (* TAMRA *)
		Model[Molecule, "id:o1k9jAGP8Ppx"] (* NED *)
	};

	(* Gather up all the components that might contain fluorophores so we can download their component molecules
		For now, this will only be master mix and probes. If we allow scorpion primers down the road, they could be included. *)
	potentialFluorophoreContainingObjects = Cases[
		Flatten[Lookup[expandedSafeOps, {MasterMix, Probe, EndogenousProbe, StandardProbe}]],
		ObjectP[]
	];

	(* Assemble a list of all the options that can take objects that might be getting referenced by name,
	 	excluding those options listed above from which we will also download Name *)
	possiblyNamedOptions = Cases[Flatten[Lookup[expandedSafeOps, {Instrument, Buffer, DuplexStainingDye, ReferenceDye, EndogenousPrimerPair, StandardPrimerPair}]], ObjectP[]];

	(* Get the instrument option to download its model, if relevant. This is necessary to ensure that we're using a compatible thermocycler. *)
	instrumentOption = Lookup[expandedSafeOps, Instrument];

	(*Get all the liquid handler-compatible containers, with the low-volume containers prepended*)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	assayPlateModel = Model[Container, Plate, "384-well qPCR Optical Reaction Plate"];


	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	downloadedPackets=Check[
		Quiet[
			Download[
				{
					myExperimentSampleInputsWithPreparedSamples,
					myExperimentSampleInputsWithPreparedSamples,
					myExperimentSampleInputsWithPreparedSamples,
					qPCRCompatibleFluorophores,
					potentialFluorophoreContainingObjects,
					potentialFluorophoreContainingObjects,
					possiblyNamedOptions,
					Cases[{instrumentOption}, ObjectP[]],
					liquidHandlerContainers,
					{assayPlateModel}
				},
				{
					{sampleFields},
					{Packet[Container[objectContainerFields]]},
					{Packet[Container[Model][modelContainerFields]]},
					{Packet[Name, Fluorescent, FluorescenceExcitationMaximums, FluorescenceEmissionMaximums, FluorescenceLabelingTarget]},
					{Packet[Name, Model, Composition]},
					{Packet[Composition[[All,2]][{Name, Fluorescent, FluorescenceExcitationMaximums, FluorescenceEmissionMaximums, FluorescenceLabelingTarget}]]},
					{Packet[Name]},
					{Packet[Name, WettedMaterials, Positions, EnvironmentalControls, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, InternalDimensions, Model, MaxTemperatureRamp,MinTemperatureRamp]},
					{Evaluate[Packet@@modelContainerFields]},
					{Packet[Name, MinVolume, MaxVolume, NumberOfWells, AspectRatio]}
				},
				Cache -> combinedCacheWithSamplePreparation
			],
			{Download::FieldDoesntExist, Download::NotLinkField}
		],
		$Failed,
		{Download::ObjectDoesNotExist}
	];

	(* Return early if objects do not exist *)
	If[MatchQ[downloadedPackets,$Failed],
		Return[$Failed]
	];

	(* Add downloaded information to cache ball *)
	cacheBall = FlattenCachePackets[{combinedCacheWithSamplePreparation, downloadedPackets}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(
			(* We are gathering tests. This silences any messages being thrown. *)
			{resolvedOptions,resolvedOptionsTests}=resolveExperimentqPCROptions[expandedSamples,expandedPrimerPairSamples,expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];

			(* Therefore, we have to run the tests to see if we encountered a failure. *)
			If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
				{resolvedOptions,resolvedOptionsTests},
				$Failed
			]
		),

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentqPCROptions[expandedSamples,expandedPrimerPairSamples,expandedSafeOps,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	(* TODO: May need to manually collapse Forward/ReversePrimerVolume options since they index match more deeply *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentqPCR,
		resolvedOptions,
		Ignore->ReplaceRule[listedOptions, ContainerOut -> Lookup[resolvedOptions, ContainerOut]],
		Messages->False
	];

	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentqPCR,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests}=If[gatherTests,
		qPCRResourcePackets[
			expandedSamples,
			expandedPrimerPairSamples,
			templatedOptions,
			resolvedOptions,
			collapsedResolvedOptions,
			Cache->cacheBall,
			Output->{Result,Tests}
		],
		{
			qPCRResourcePackets[
				expandedSamples,
				expandedPrimerPairSamples,
				templatedOptions,
				resolvedOptions,
				collapsedResolvedOptions,
				Cache->cacheBall,
				Output->Result
			],
			{}
		}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentqPCR,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* Upload our protocol object, if asked to do so by the user. *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed],
		ECL`InternalUpload`UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->{Object[Protocol,qPCR]},
			Cache->samplePreparationCache
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentqPCR,collapsedResolvedOptions],
		Preview -> Null
	}

];


(*---384-well plate overload accepting (defined) sample/container objects as template inputs and (defined) sample/container objects as primer pair inputs---*)
ExperimentqPCR[
	myExperimentSampleInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
	myExperimentPrimerInputs:ListableP[{{ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String,ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String}..}],
	myOptions:OptionsPattern[]
]:=Module[
	{listedOptions,listedSamples,listedPrimerPairSamples,outputSpecification,output,gatherTests,containerToSampleResult,containerToSampleTests,containerToSampleOutput,
		samples,sampleOptions,validSamplePreparationResult,myOptionsWithPreparedSamples,samplePreparationCache,
		updatedCache, myExperimentSampleInputsWithPreparedSamples,initialOptionsWithPreparedSamples,initialSamplePreparationCache, myFlatPrimerPairSamplesWithPreparedSamples,
		flatPrimerPairSamples, primerPairLengths, myPrimerPairSamplesWithPreparedSamples, primerContainerToSampleResult, primerContainerToSampleOutput, primerContainerToSampleTests,
		combinedContainerToSampleTests, samplefiedPrimers, samplefiedPrimerOptions,primerPairs,primerPairOptions,primerPairCache,sampleCache},

	(* Make sure we're working with a list of options *)
	(* replace any links that are not in the cache *)
	listedOptions=ReplaceRule[
		ReplaceAll[ToList[myOptions],Link[x_, y___] :> x],
		{Cache->Lookup[ToList[myOptions],Cache,{}]}
	];
	listedSamples=ToList[myExperimentSampleInputs];
	listedPrimerPairSamples=Switch[
		myExperimentPrimerInputs,
		{{ObjectP[]|_String,ObjectP[]|_String}..},{myExperimentPrimerInputs},
		{{{ObjectP[]|_String,ObjectP[]|_String}..}..},myExperimentPrimerInputs
	];

	(*Flatten listedPrimerPairSamples to a list of primer pairs*)
	flatPrimerPairSamples=Flatten[listedPrimerPairSamples,1];
	primerPairLengths=Length/@listedPrimerPairSamples;

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* First, simulate our sample preparation. *)
	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		{myExperimentSampleInputsWithPreparedSamples,initialOptionsWithPreparedSamples,initialSamplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentqPCR,
			listedSamples,
			listedOptions
		];
		{myFlatPrimerPairSamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentqPCR,
			flatPrimerPairSamples,
			ReplaceRule[initialOptionsWithPreparedSamples,
				Cache->FlattenCachePackets[{
					Lookup[initialOptionsWithPreparedSamples,Cache,{}],
					initialSamplePreparationCache
				}]
			]
		],
		$Failed,
	 	{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests}=containerToSampleOptions[
			ExperimentqPCR,
			myExperimentSampleInputsWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests},
			Cache->samplePreparationCache
		];

		(* Therefore,we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			containerToSampleOutput=containerToSampleOptions[
				ExperimentqPCR,
				myExperimentSampleInputsWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->Result,
				Cache->samplePreparationCache
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* Convert our given containers into samples and sample index-matched options
		Must further flatten myFlatPrimerPairSamplesWithPreparedSamples so we're dealing with a flat list of bare samples *)
	primerContainerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{primerContainerToSampleOutput,primerContainerToSampleTests} = containerToSampleOptions[
			ExperimentqPCR,
			Flatten[myFlatPrimerPairSamplesWithPreparedSamples,1],
			myOptionsWithPreparedSamples,
			Output->{Result,Tests},
			Cache->samplePreparationCache
		];

		(* Therefore,we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->primerContainerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			primerContainerToSampleOutput = containerToSampleOptions[
				ExperimentqPCR,
				Flatten[myFlatPrimerPairSamplesWithPreparedSamples,1],
				myOptionsWithPreparedSamples,
				Output->Result,
				Cache->samplePreparationCache
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* Bring back the nested form of primer pairs after converting containers to samples
		First partition into lists of length 2 to regenerate primer pairs, then partition primer pairs as they originally were *)
	myPrimerPairSamplesWithPreparedSamples=TakeList[
		Partition[First[primerContainerToSampleOutput], 2],
		primerPairLengths
	];

	(* Combine sample and primer input contianer to sample tests *)
	combinedContainerToSampleTests = Join[containerToSampleTests, primerContainerToSampleTests];

	(* Update our cache with our new simulated values. *)
	updatedCache=FlattenCachePackets[{
		samplePreparationCache,
		Lookup[listedOptions,Cache,{}]
	}];

	(* If we were given an empty container,return early. *)
	If[Or[MatchQ[containerToSampleResult,$Failed], MatchQ[primerContainerToSampleResult, $Failed]],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result->$Failed,
			Tests->combinedContainerToSampleTests,
			Options->$Failed,
			Preview->Null
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions,sampleCache}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentqPCR[
			samples,
			myPrimerPairSamplesWithPreparedSamples,
			ReplaceRule[sampleOptions,Cache->updatedCache]
		]
	]
];


(*---Array card overload accepting sample objects and an array card object---*)
ExperimentqPCR[
	myExperimentSampleInputs:ListableP[ObjectP[Object[Sample]]],
	myExperimentArrayCardInput:ObjectP[Object[Container,Plate,Irregular,ArrayCard]],
	myOptions:OptionsPattern[ExperimentqPCR]
]:=Module[
	{outputSpecification,output,gatherTests,listedSamples,listedOptions,
		validSamplePreparationResult,myExperimentSampleInputsWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCacheNamed,
		safeOpsNamed,safeOpsTests,myExperimentSampleInputsWithPreparedSamples,safeOps,myOptionsWithPreparedSamples,samplePreparationCache,
		validLengths,validLengthTests,templatedOptions,templateTests,inheritedOptions,upload,confirm,fastTrack,parentProtocol,cache,
		expandedSafeOps,combinedCacheWithSamplePreparation,qPCRCompatibleFluorophores,potentialFluorophoreContainingObjects,instrumentOption,liquidHandlerContainers,
		sampleFields,objectContainerFields,modelContainerFields,downloadedPackets,
		cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,
		resourcePackets,resourcePacketTests,protocolObject},

	(*Determine the requested return value from the function*)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];

	(*--Remove temporal links--*)
	{listedSamples,listedOptions}=removeLinks[ToList[myExperimentSampleInputs],ToList[myOptions]];

	(*--Simulate sample preparation--*)
	validSamplePreparationResult=Check[
		{myExperimentSampleInputsWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCacheNamed}=simulateSamplePreparationPackets[
			ExperimentqPCR,
			listedSamples,
			listedOptions
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

	(*--Call SafeOptions and ValidInputLengthsQ--*)
	(*Call SafeOptions to make sure all options match patterns*)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentqPCR,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentqPCR,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	{myExperimentSampleInputsWithPreparedSamples,{safeOps,myOptionsWithPreparedSamples,samplePreparationCache}}=sanitizeInputs[myExperimentSampleInputsWithPreparedSamplesNamed,{safeOpsNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCacheNamed}];

	(*Call ValidInputLengthsQ to make sure all inputs and options have matching lengths*)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentqPCR,{myExperimentSampleInputsWithPreparedSamples,myExperimentArrayCardInput},myOptionsWithPreparedSamples,2,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentqPCR,{myExperimentSampleInputsWithPreparedSamples,myExperimentArrayCardInput},myOptionsWithPreparedSamples,2],Null}
	];

	(*If the specified options don't match their patterns, return $Failed*)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
	];

	(*If input and option lengths are invalid, return $Failed (or the tests up to this point)*)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(*--Use any template options to get values for options not specified in myOptions--*)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentqPCR,{myExperimentSampleInputsWithPreparedSamples,myExperimentArrayCardInput},myOptionsWithPreparedSamples,2,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentqPCR,{myExperimentSampleInputsWithPreparedSamples,myExperimentArrayCardInput},myOptionsWithPreparedSamples,2],Null}
	];

	(*Return early if the template cannot be used - will only occur if the template object does not exist*)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(*Replace our safe options with the inherited options from the template*)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(*get assorted hidden options*)
	{upload,confirm,fastTrack,parentProtocol,cache}=Lookup[inheritedOptions,{Upload,Confirm,FastTrack,ParentProtocol,Cache}];

	(*--Expand index-matching inputs and options--*)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentqPCR,{myExperimentSampleInputsWithPreparedSamples,myExperimentArrayCardInput},inheritedOptions,2]];

	(*--Download the information we need for the option resolver and resource packet function--*)

	(*Combine incoming cache with sample preparation cache*)
	combinedCacheWithSamplePreparation=FlattenCachePackets[{cache,samplePreparationCache}];

	(*Download all fluorophores known to be compatible with ECL qPCR instrumentation*)
	qPCRCompatibleFluorophores={
		Model[Molecule,"id:9RdZXv1oADYx"],(*FAM*)
		Model[Molecule,"id:R8e1PjpZ7ZEd"],(*VIC*)
		Model[Molecule,"id:lYq9jRxPaPGV"],(*ROX*)
		Model[Molecule,"id:lYq9jRxPaDEl"],(*SYBR*)
		Model[Molecule,"id:jLq9jXvm3mK6"],(*TAMRA*)
		Model[Molecule,"id:o1k9jAGP8Ppx"](*NED*)
	};

	(*Gather up all the components that might contain fluorophores so we can download their component molecules. For now, this will only be master mix and probes. If we allow scorpion primers down the road, they could be included.*)
	potentialFluorophoreContainingObjects=Cases[
		Flatten[Lookup[expandedSafeOps,{MasterMix,Probe}]],
		ObjectP[]
	];

	(*Get the instrument option to download its model, if relevant. This is necessary to ensure that we're using a compatible thermocycler*)
	instrumentOption=Lookup[expandedSafeOps,Instrument];

	(*Get all the liquid handler-compatible containers, with the low-volume containers prepended*)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(*Determine which fields we need to download*)
	sampleFields=SamplePreparationCacheFields[Object[Sample],Format->Packet];
	objectContainerFields=SamplePreparationCacheFields[Object[Container]];
	modelContainerFields=SamplePreparationCacheFields[Model[Container]];

	(*Make the upfront Download call*)
	downloadedPackets=Check[
		Quiet[
			Download[
				{
					myExperimentSampleInputsWithPreparedSamples,
					myExperimentSampleInputsWithPreparedSamples,
					myExperimentSampleInputsWithPreparedSamples,
					{myExperimentArrayCardInput},
					{myExperimentArrayCardInput},
					{myExperimentArrayCardInput},
					{myExperimentArrayCardInput},
					qPCRCompatibleFluorophores,
					potentialFluorophoreContainingObjects,
					potentialFluorophoreContainingObjects,
					Cases[{instrumentOption}, ObjectP[]],
					liquidHandlerContainers
				},
				{
					{sampleFields},
					{Packet[Container[objectContainerFields]]},
					{Packet[Container[Model][modelContainerFields]]},
					{Packet[Model,Contents,Status]},
					{Packet[Model[ForwardPrimers[{Name}]]]},
					{Packet[Model[ReversePrimers[{Name}]]]},
					{Packet[Model[Probes[{Name,DetectionLabels,Fluorescent,FluorescenceExcitationMaximums,FluorescenceEmissionMaximums}]]]},
					{Packet[Name,DetectionLabels,Fluorescent,FluorescenceExcitationMaximums,FluorescenceEmissionMaximums]},
					{Packet[Name,Model,Composition]},
					{Packet[Composition[[All,2]][{Name,DetectionLabels,Fluorescent,FluorescenceExcitationMaximums,FluorescenceEmissionMaximums}]]},
					{Packet[Name, WettedMaterials, Positions, EnvironmentalControls, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, InternalDimensions, Model, MaxTemperatureRamp,MinTemperatureRamp]},
					{Evaluate[Packet@@modelContainerFields]}
				},
				Cache->combinedCacheWithSamplePreparation
			],
			{Download::FieldDoesntExist,Download::NotLinkField}
		],
		$Failed,
		{Download::ObjectDoesNotExist}
	];

	(*Return early if objects do not exist*)
	If[MatchQ[downloadedPackets,$Failed],
		Return[$Failed]
	];

	(*Add downloaded information to cache ball*)
	cacheBall=FlattenCachePackets[{combinedCacheWithSamplePreparation,downloadedPackets}];

	(*--Build the resolved options--*)
	resolvedOptionsResult=If[gatherTests,
		(*We are gathering tests. This silences any messages being thrown*)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentqPCROptions[myExperimentSampleInputsWithPreparedSamples,myExperimentArrayCardInput,expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];

		(*Therefore, we have to run the tests to see if we encountered a failure*)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(*We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption*)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentqPCROptions[myExperimentSampleInputsWithPreparedSamples,myExperimentArrayCardInput,expandedSafeOps,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(*Collapse the resolved options*)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentqPCR,
		resolvedOptions,
		Ignore->myOptionsWithPreparedSamples,
		Messages->False
	];

	(*If option resolution failed, return early*)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentqPCR,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(*--Build packets with resources--*)
	{resourcePackets,resourcePacketTests}=If[gatherTests,
		qPCRResourcePackets[myExperimentSampleInputsWithPreparedSamples,myExperimentArrayCardInput,expandedSafeOps,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{qPCRResourcePackets[myExperimentSampleInputsWithPreparedSamples,myExperimentArrayCardInput,expandedSafeOps,resolvedOptions,Cache->cacheBall,Output->Result],{}}
	];

	(*If we don't have to return the Result, don't bother calling UploadProtocol*)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options->RemoveHiddenOptions[ExperimentqPCR,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(*We have to return the result. Call UploadProtocol to prepare our protocol packet (and upload it if requested)*)
	protocolObject=If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->upload,
			Confirm->confirm,
			ParentProtocol->parentProtocol,
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->{Object[Protocol,qPCR]},
			Cache->samplePreparationCache
		],
		$Failed
	];

	(*Return the requested output*)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options->RemoveHiddenOptions[ExperimentqPCR,collapsedResolvedOptions],
		Preview->Null
	}
];


(*---Array card overload accepting (defined) sample/container objects and an array card object---*)
ExperimentqPCR[
	myExperimentSampleInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],
	myExperimentArrayCardInput:ObjectP[Object[Container,Plate,Irregular,ArrayCard]],
	myOptions:OptionsPattern[ExperimentqPCR]
]:=Module[
	{outputSpecification,output,gatherTests,listedSamples,listedOptions,sampleCache,
		validSamplePreparationResult,myExperimentSampleInputsWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache,
		containerToSampleResult,containerToSampleOutput,containerToSampleTests,
		updatedCache,samples,sampleOptions},

	(*Determine the requested return value from the function*)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];

	(*--Remove temporal links--*)
	{listedSamples,listedOptions}=removeLinks[ToList[myExperimentSampleInputs],ToList[myOptions]];

	(*--Simulate sample preparation--*)
	validSamplePreparationResult=Check[
		{myExperimentSampleInputsWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentqPCR,
			listedSamples,
			listedOptions
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
	containerToSampleResult=If[gatherTests,
		(*We are gathering tests. This silences any messages being thrown*)
		{containerToSampleOutput,containerToSampleTests}=containerToSampleOptions[
			ExperimentqPCR,
			myExperimentSampleInputsWithPreparedSamples,
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
				ExperimentqPCR,
				myExperimentSampleInputsWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->Result,
				Cache->samplePreparationCache
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(*Update our cache with the new simulated values*)
	(*It is important that the sample preparation cache appears first in the cache ball*)
	updatedCache=FlattenCachePackets[{
		samplePreparationCache,
		Lookup[listedOptions,Cache,{}]
	}];

	(*If we were given an empty container, return early*)
	If[MatchQ[containerToSampleResult,$Failed],
		(*containerToSampleOptions failed - return $Failed*)
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null
		},

		(*Split up our containerToSample result into the samples and sampleOptions*)
		{samples,sampleOptions, sampleCache}=containerToSampleOutput;

		(*Call our main function with our samples and converted options.*)
		ExperimentqPCR[
			samples,
			myExperimentArrayCardInput,
			ReplaceRule[sampleOptions,Cache->Flatten[{updatedCache,sampleCache}]]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentqPCROptions*)


DefineOptions[resolveExperimentqPCROptions,
	Options:>{HelperOutputOption,CacheOption}
];


(*---384-well plate overload---*)
resolveExperimentqPCROptions[
	myResolverSampleInputs:{ObjectP[Object[Sample]]...},
	myResolverPrimerInputs:ListableP[{{ObjectP[{Model[Sample], Object[Sample]}],ObjectP[{Model[Sample], Object[Sample]}]}..}|Null],
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentqPCROptions]
]:=Module[
	{
		outputSpecification,output,gatherTests,messagesQ,cache,samplePrepOptions,qPCROptions,simulatedSamples,resolvedSamplePrepOptions,
		simulatedCache,samplePrepTests,
		qPCROptionsAssociation,invalidInputs,invalidOptions,targetContainers,aliquotTests,
		samplePackets,sampleContainers,sampleModels,sampleContainerModels,
		discardedSamplePackets,discardedInvalidInputs,discardedTest,
		precisionOptions,precisionUnits,roundedqPCROptions,precisionTests,
		nameOption, validNameQ, nameInvalidOptions, validNameTest,
		specifiedDuplexStainingDye,numberOfPrimerPairsPerSample,duplexStainingDyeSingleplexQ,invalidDuplexStainingDyeSingleplexOptions,duplexStainingDyeSingleplexTest,
		specifiedProbes,probeSpecifiedDuplexStainingDyeNullQ,invalidProbeSpecifiedDuplexStainingDyeNullOptions,probeSpecifiedDuplexStainingDyeNullTest,
		specifiedDuplexStainingDyeExcitationWavelength,specifiedDuplexStainingDyeEmissionWavelength,duplexStainingDyeExcitationEmissionPairQ,invalidDuplexStainingDyeExcitationEmissionPairOptions,duplexStainingDyeExcitationEmissionPairTest,
		specifiedReferenceDyeExcitationWavelength,specifiedReferenceDyeEmissionWavelength,referenceDyeExcitationEmissionPairQ,invalidReferenceDyeExcitationEmissionPairOptions,referenceDyeExcitationEmissionPairTest,
		specifiedProbeExcitationWavelengths,specifiedProbeEmissionWavelengths,probeExcitationEmissionPairQ,invalidProbeExcitationEmissionPairOptions,probeExcitationEmissionPairTest,
		specifiedStandardProbeExcitationWavelengths,specifiedStandardProbeEmissionWavelengths,standardProbeExcitationEmissionPairQ,invalidStandardProbeExcitationEmissionPairOptions,standardProbeExcitationEmissionPairTest,
		specifiedEndogenousProbeExcitationWavelengths,specifiedEndogenousProbeEmissionWavelengths,endogenousProbeExcitationEmissionPairQ,invalidEndogenousProbeExcitationEmissionPairOptions,endogenousProbeExcitationEmissionPairTest,
		expandedStandardPrimerPair,standardPrimerPairAmongInputsQList,standardPrimerPairAmongInputsTest,

		viia7ExEm,
		masterMixSYBRMinusRT, masterMixSYBRPlusRT, masterMixProbeMinusRT, masterMixProbePlusRT,
		sybrMolecule, roxMolecule, masterMixFoldConcentrationLookup, masterMixDuplexDyeLookup, masterMixReferenceDyeLookup,

		resolveAutomatic, resolvedBuffer,resolvedInstrument,resolvedReactionVolume,
		resolvedReverseTranscription,resolvedTranscriptionTime,resolvedTranscriptionTemperature,resolvedTranscriptionRampRate,
		resolvedActivation,resolvedActivationTime,resolvedActivationTemperature,resolvedActivationRampRate,
		resolvedDenaturationTime,resolvedDenaturationTemperature,resolvedDenaturationRampRate,
		resolvedAnnealing,resolvedAnnealingTime,resolvedAnnealingTemperature,resolvedAnnealingRampRate,
		resolvedExtensionTime,resolvedExtensionTemperature,resolvedExtensionRampRate,resolvedNumberOfCycles,

		meltingCurve,meltingCurveStartTemperature,meltingCurveEndTemperature,preMeltingCurveRampRate,meltingCurveRampRate,
		unresolvedMeltingCurveRampRate,unresolvedMeltingCurveTime,defaultCurveRampRate,meltingCurveTime,
		omitDuplexDyeQ, masterMixStainingDye,hasStainingDye,resolvedDuplexStainingDye,resolvedDuplexStainingDyeVolume,lookedUpDuplexDyeEx, lookedUpDuplexDyeEm,meltingCurveTempDifference,resolvedDuplexStainingDyeExcitationWavelength,
		resolvedDuplexStainingDyeEmissionWavelength, resolvedMasterMix, resolvedMasterMixModel, unknownMasterMixQ, unknownMasterMixTest, resolvedReferenceStainingDyeExcitationWavelength, resolvedReferenceStainingDyeEmissionWavelength,
		masterMixReferenceDye,hasReferenceDye,resolvedReferenceDye,resolvedReferenceDyeVolume, lookedUpReferenceDyeEx, lookedUpReferenceDyeEm,

		resolvedStandards,resolvedStandardPrimerPairs,resolvedStandardVolumes,resolvedSerialDilutionFactors,resolvedNumberOfDilutions,resolvedNumberOfStandardReplicates,uniquePrimerPairs,enoughPrimerPairs,

		resolvedEndogenousProbes,resolvedEndogenousProbeVolumes,resolvedEndogenousProbeEmissionWavelengths,resolvedEndogenousProbeExcitationWavelengths,
		resolvedEndogenousProbeFluorophores,

		resolvedStandardForwardPrimerVolumes, resolvedStandardReversePrimerVolumes,
		resolvedStandardProbes,resolvedStandardProbeVolumes,
		resolvedStandardProbeEmissionWavelengths,resolvedStandardProbeExcitationWavelengths,resolvedStandardProbeFluorophores,

		mapThreadFriendlyOptions,

		resolvedSampleVolumes,resolvedMasterMixVolume,resolvedBufferVolumes,resolvedEndogenousPrimerPairs,resolvedEndogenousForwardPrimerVolumes,
		resolvedEndogenousReversePrimerVolumes,resolvedForwardPrimerVolumes,resolvedReversePrimerVolumes,resolvedProbes,resolvedProbeVolumes,
		resolvedProbeEmissionWavelengths,resolvedProbeExcitationWavelengths,resolvedProbeFluorophores,

		hasStandard,resolvedStandardVolume,

		standardPrimersSpecifiedIfNeededQ, standardPrimerInvalidOptions, standardPrimersSpecifiedIfStandardSpecifiedTest,
		invalidMeltingRampRateQ, meltingRampRateInvalidOptions, invalidMeltingRampRateTest,
		rtWithoutProbesQ, rtWithoutProbesOptions, rtWithoutProbesTest,

		resolvedAliquotOptions,resolvedPostProcessingOptions,resolvedOptions,

		(* Error variables *)
		probeLengthErrors, probeVolumeLengthErrors, multiplexingDuplexDyeErrors, invalidProbeOption, probeLengthTests,
		invalidProbeVolumeOptions, probeVolumeLengthTests, invalidMultiplexingWithoutProbeOptions, multiplexingWithoutProbeTests,
		excessiveVolumeErrors, excessiveVolumeOptions, excessiveVolumeTests,
		bufferVolumeMismatchErrors, bufferVolumeMismatchOptions, bufferVolumeMismatchTests,
		probeVolumeNoProbeErrors, probeVolumeNoProbeOptions, probeVolumeNoProbeTests,
		probeExcitationNoProbeErrors, probeExcitationNoProbeOptions, probeExcitationNoProbeTests,
		probeEmissionNoProbeErrors, probeEmissionNoProbeOptions, probeEmissionNoProbeTests,
		forwardPrimerVolumeLengthErrors, forwardPrimerVolumeLengthOptions, forwardPrimerVolumeLengthTests,
		reversePrimerVolumeLengthErrors, reversePrimerVolumeLengthOptions, reversePrimerVolumeLengthTests,
		invalidDyeOptions, invalidDyeTests,
		probeNoFluorophoreErrors, probeNoFluorophoreOptions, probeNoFluorophoreTests,
		probeFluorophoreNoProbeErrors, probeFluorophoreNoProbeOptions, probeFluorophoreNoProbeTests,
		probeFluorophoreLengthErrors, probeFluorophoreLengthOptions, probeFluorophoreLengthTests,
		endogenousProbeFluorophoreNoProbeErrors, endogenousProbeFluorophoreNoProbeOptions, endogenousProbeFluorophoreNoProbeTests,
		endogenousProbeNoFluorophoreErrors, endogenousProbeNoFluorophoreOptions, endogenousProbeNoFluorophoreTests,
		invalidMeltEndpointsQ, invalidMeltEndpointsOptions, invalidMeltEndpointsTests,
		invalidThermocyclerQ, invalidThermocyclerOptions, invalidThermocyclerTests,
		rtInvalidOptions, rtOptionTests,
		activationInvalidOptions, activationOptionTests,
		annealingInvalidOptions, annealingOptionTests,
		meltingCurveInvalidOptions, meltingCurveOptionTests,
		endogenousPrimersNoProbeErrors, endogenousPrimersNoProbeOptions, endogenousPrimersNoProbeTests,
		invalidNullStandardForwardPrimerVolumeQ, invalidNullStandardForwardPrimerOptions, invalidNullStandardForwardPrimerTests,
		invalidNullStandardReversePrimerVolumeQ, invalidNullStandardReversePrimerOptions, invalidNullStandardReversePrimerTests,
		invalidNullStandardProbeVolumeQ, invalidNullStandardProbeVolumeOptions, invalidNullStandardProbeVolumeTests,
		invalidNullProbeVolumeErrors, invalidNullProbeVolumeOptions, invalidNullProbeVolumeTests,
		invalidNullEndogenousForwardPrimerVolumeErrors, invalidNullEndogenousForwardPrimerVolumeOptions, invalidNullEndogenousForwardPrimerVolumeTests,
		invalidNullEndogenousReversePrimerVolumeErrors, invalidNullEndogenousReversePrimerVolumeOptions, invalidNullEndogenousReversePrimerVolumeTests,
		invalidNullEndogenousProbeVolumeErrors, invalidNullEndogenousProbeVolumeOptions, invalidNullEndogenousProbeVolumeTests,
		duplicateProbeWavelengthErrors, duplicateProbeWavelengthOptions, duplicateProbeWavelengthTests,

		dependentOptionCheck, masterSwitchCheck, generateSampleTests,
		standardRelatedOptionInvalidOptions, standardRelatedOptionTests, standardProbeRelatedOptionInvalidOptions, standardProbeRelatedOptionTests,

		possiblyNamedOptions, possiblyNamedObjectPackets, updatedCache,

		invalidForwardPrimerStorageConditionResult, forwardPrimerStorageConditionTest,expandedForwardPrimerStorageConditions,expandedReversePrimerStorageConditions, invalidReversePrimerStorageConditionResult, reversePrimerStorageConditionTest, invalidProbeStorageConditionResult, probeStorageConditionTest, expandedProbeStorageConditions,
		invalidStandardStorageConditionResult, standardStorageConditionTest, invalidStandardForwardPrimerStorageConditionResult, standardForwardPrimerStorageConditionTest, invalidStandardReversePrimerStorageConditionResult, standardReversePrimerStorageConditionTest, invalidStandardProbeStorageConditionResult,standardProbeStorageConditionTest,
		invalidEndogenousForwardPrimerStorageConditionResult,EndogenousForwardPrimerStorageConditionTest, invalidEndogenousReversePrimerStorageConditionResult,EndogenousReversePrimerStorageConditionTest,
		invalidEndogenousProbeStorageConditionResult,EndogenousProbeStorageConditionTest,
		allPrimerProbesWithStorageConditions, uniqueSamplesWithStorageConditions, conflictSamplesWithStorageConditions, conflictSampleStorageOptions,conflictSampleStorageConditionTest,
		samplesForContainerStorageCheck, storageConditionsForContainerStorageCheck, validSamplesInStorageConditionBools, validSamplesInStorageConditionTests, storageContainerInvalidSamples, invalidContainerSampleStorageOptions,
		numberOfAssayWells, suppliedMoatSize, suppliedMoatBuffer, suppliedMoatVolume, impliedMoat, defaultMoatBuffer, defaultMoatVolume,
		defaultMoatSize, resolvedMoatBuffer, resolvedMoatVolume, resolvedMoatSize, invalidMoatOptions, moatTests,
		assayPlateModel, assayPlateModelPacket
	},

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];

	(* Determine whether messages should be thrown *)
	messagesQ = !gatherTests;

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* separate out our qPCR options from our Sample Prep options. *)
	{samplePrepOptions,qPCROptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,simulatedCache},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptions[ExperimentqPCR,myResolverSampleInputs,samplePrepOptions,Cache->cache,Output->{Result,Tests}],
		{resolveSamplePrepOptions[ExperimentqPCR,myResolverSampleInputs,samplePrepOptions,Cache->cache,Output->Result],{}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	qPCROptionsAssociation = Association[qPCROptions];

	assayPlateModel = Model[Container, Plate, "384-well qPCR Optical Reaction Plate"];

	(* Extract the packets that we need from our downloaded cache. *)
	{{samplePackets, sampleContainers, sampleContainerModels, {assayPlateModelPacket}}}=Flatten[
		Download[
			{simulatedSamples,simulatedSamples,simulatedSamples,{assayPlateModel}},
			{
				{Packet[Volume,Status,Container]},
				{Packet[Container[{Object,Model}]]},
				{Packet[Container[Model[{MaxVolume}]]]},
				{Packet[MinVolume, MaxVolume, NumberOfWells, AspectRatio]}
			},
			Cache->simulatedCache
		],
		{3}
	];

	(* Assemble an updated cache from which packets can be fetched when needed *)
	(* updatedCache = FlattenCachePackets[{simulatedCache, samplePackets, sampleContainers, sampleContainerModels, possiblyNamedObjectPackets}]; *)

	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(*-- INPUT VALIDATION CHECKS --*)

	(* NOTE: MAKE SURE NONE OF THE SAMPLES ARE DISCARDED - *)
	(* Get the samples from samplePackets that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],{},Lookup[discardedSamplePackets,Object]];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&messagesQ,Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->simulatedCache]]];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->simulatedCache]<>" are not discarded:",True,False]
			];
			passingTest=If[Length[discardedInvalidInputs]==Length[myResolverSampleInputs],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[myResolverSampleInputs,discardedInvalidInputs],Cache->simulatedCache]<>" are not discarded:",True,True]
			];
			{failingTest,passingTest}
		],Nothing
	];


	(*-- OPTION PRECISION CHECKS --*)
	(* all the options requring a precession check *)
	(* TODO: Shouldn't volumes to be transferred using liquid handler be rounded here as well? *)
	{precisionOptions,precisionUnits}=Transpose[
		{
			{ActivationTime, 1 Second},
			{ActivationTemperature, .1 Celsius},
			{ActivationRampRate, .001 Celsius/Second},

			{PrimerAnnealingTime, 1 Second},
			{PrimerAnnealingTemperature, .1 Celsius},
			{PrimerAnnealingRampRate, .001 Celsius/Second},

			{DenaturationTime, 1 Second},
			{DenaturationTemperature, .1 Celsius},
			{DenaturationRampRate, .001 Celsius/Second},

			{ExtensionTime, 1 Second},
			{ExtensionTemperature, .1 Celsius},
			{ExtensionRampRate, .001 Celsius/Second},

			{ReverseTranscriptionTime, 1 Second},
			{ReverseTranscriptionTemperature, .1 Celsius},
			{ReverseTranscriptionRampRate, .001 Celsius/Second},

			{MeltingCurveStartTemperature, .1 Celsius},
			{MeltingCurveEndTemperature, .1 Celsius},
			{PreMeltingCurveRampRate, .001 Celsius/Second},
			{MeltingCurveRampRate, .001 Celsius/Second},
			{MeltingCurveTime, 1 Second},

			(* Protocol-wide volume options *)
			{ReactionVolume, 0.1 Microliter},
			{MasterMixVolume, 0.1 Microliter},
			{StandardVolume, 0.1 Microliter},
			{DuplexStainingDyeVolume, 0.1 Microliter},
			{ReferenceDyeVolume, 0.1 Microliter},

			(* SamplesIn index matched volume options *)
			{SampleVolume, 0.1 Microliter},
			{BufferVolume, 0.1 Microliter},
			{ForwardPrimerVolume, 0.1 Microliter},
			{ReversePrimerVolume, 0.1 Microliter},
			{ProbeVolume, 0.1 Microliter},
			{EndogenousForwardPrimerVolume, 0.1 Microliter},
			{EndogenousReversePrimerVolume, 0.1 Microliter},
			{EndogenousProbeVolume, 0.1 Microliter},

			(* Standards index matched volume options *)
			{StandardForwardPrimerVolume, 0.1 Microliter},
			{StandardReversePrimerVolume, 0.1 Microliter},
			{StandardProbeVolume, 0.1 Microliter}
		}
	];

	{roundedqPCROptions,precisionTests}=If[gatherTests,
		RoundOptionPrecision[qPCROptionsAssociation,precisionOptions,precisionUnits,Output->{Result,Tests}],
		{RoundOptionPrecision[qPCROptionsAssociation,precisionOptions,precisionUnits],Null}
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)
	(*
		General
			Total volume for each well doesn't exceed ReactionVolume (or, probably, half of reaction volume to allow for master mix...)
			If user specified StainingDye and MasterMix, they have to be copacetic (we don't yet have the ability to check this since staining dye is not a thing that's stored with master mix model/sample)
			Probe has to be a reporter+quencher (Can't test this right now either, same reasoning as master mix above)
			If any probes are being used for anything, they must be used for everything
			If probes are being used, no duplex-staining dye should be specified
			Make sure there is no clash between any of the wavelength to be used
		RT and RT options
			If RT is True, other options cannot be Null (and vice versa)
		Melting curve options:
			If ramp rate and ramp time/temperature are all specified, they must agree
		Standards options:
			(Warning) Number of standards should equal number of sample primer pairs (i.e., all input primer pairs should be represented in StandardPrimerPair)
			(Warning) StandardPrimerPair should exist in the PrimerPair pool, warning if it doesn't but let them on through
			If Standard is specified, StandardPrimerPair must be specified (index matching auto-enforced by framework)
			If any Standard options are specified, Standard must be specified or they will be ignored
			They either need to be explicit about which primers to use for the standard, or there has to be as many of them as there are unique primer pairs
	*)


	(* Define a local helper to check for a parent option of dependent option(s)
		Input: unresolved options list, parent option required for all dependent options, list of dependent options
		Output: list of invalid dependent option symbols, list of invalid dependent option tests
		NOTE: Depends on local values of messagesQ, gatherTests
	*)
	dependentOptionCheck[optionsList_, parentOption_Symbol, dependentOptions_List] := Module[
		{parentOptionUnspecifiedQ, dependentOptionSpecifiedQList, specifiedDependentOptions},

		(* Is the parent option missing? *)
		parentOptionUnspecifiedQ = MatchQ[Lookup[optionsList, parentOption], NullP];

		(* Generate a boolean list of whether each dependent option has been specified
			Must match ListableP because ExpandIndexMatchedInputs will expand all members of an index matching option set
			if any are listed, but will leave them alone if none are listed. *)
		dependentOptionSpecifiedQList = MatchQ[#, Except[ListableP[NullP|Automatic]]]& /@ Lookup[optionsList, dependentOptions];

		(* If the parent option is missing, throw messages for all dependent options that are specified *)
		specifiedDependentOptions = PickList[dependentOptions, dependentOptionSpecifiedQList];

		(* Throw messages and/or generate tests as appropriate *)
		{
			(* Throw a message if desired and include option in error option list if needed *)
			If[parentOptionUnspecifiedQ && Length[specifiedDependentOptions] > 0 && messagesQ,
				(
					Message[Error::DependentOptionMissing, #, parentOption]& /@ specifiedDependentOptions;
					specifiedDependentOptions
				),
				{}
			],

			(* Generate Test for Standard / StandardPrimerPair specified together check *)
			If[gatherTests,
				MapThread[
					Function[{dependentOption, dependentOptionSpecifiedQ},
						Test[
							StringJoin["If ",ToString[dependentOption], " is specified, ", ToString[parentOption], " is also specified:"],
							If[parentOptionUnspecifiedQ, !dependentOptionSpecifiedQ, True],
							True
						]
					],
					{dependentOptions, dependentOptionSpecifiedQList}
				],
				{}
			]
		}
	];

	(* Define a local helper to check for cases where a master switch is explicitly False but subordinate options are specified
		Input: unresolved options list, master switch option name, list of subordinate option names
		Output: list of invalid dependent option symbols, list of invalid dependent option tests
		NOTE: Depends on local values of messagesQ, gatherTests
	*)
	masterSwitchCheck[optionsList_, parentOption_Symbol, subordinateOptions_List] := Module[
		{masterSwitchOffQ, subordinateOptionSpecifiedQList, specifiedSubordinateOptions},

		(* Is the parent option missing? *)
		masterSwitchOffQ = MatchQ[Lookup[optionsList, parentOption], False];

		(* Generate a boolean list of whether each dependent option has been specified
			Must match ListableP because ExpandIndexMatchedInputs will expand all members of an index matching option set
			if any are listed, but will leave them alone if none are listed. *)
		subordinateOptionSpecifiedQList = MatchQ[#, Except[ListableP[NullP|Automatic]]]& /@ Lookup[optionsList, subordinateOptions];

		(* If the parent option is False, throw messages for all dependent options that are specified *)
		specifiedSubordinateOptions = PickList[subordinateOptions, subordinateOptionSpecifiedQList];

		(* Throw messages and/or generate tests as appropriate *)
		{
			(* Throw a message if desired and include option in error option list if needed *)
			If[masterSwitchOffQ && Length[specifiedSubordinateOptions] > 0 && messagesQ,
				(
					Message[Error::DisabledFeatureOptionSpecified, parentOption, specifiedSubordinateOptions];
					specifiedSubordinateOptions
				),
				{}
			],

			(* Generate Test for each subordinate option *)
			If[gatherTests,
				MapThread[
					Function[{dependentOption, dependentOptionSpecifiedQ},
						Test[
							StringJoin["If the master switch option ",ToString[parentOption], " is False, ", ToString[dependentOption], " is Null or Automatic:"],
							If[masterSwitchOffQ, !dependentOptionSpecifiedQ, True],
							True
						]
					],
					{subordinateOptions, subordinateOptionSpecifiedQList}
				],
				{}
			]
		}
	];


	(* --- Check to see if a reasonable Name option has been specified --- *)
	nameOption = Lookup[roundedqPCROptions, Name];

	validNameQ=If[MatchQ[nameOption,_String],
		Not[DatabaseMemberQ[Object[Protocol,qPCR,nameOption]]],
		True
	];

	(* If validNameQ is False AND we are throwing messages, then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions=If[Not[validNameQ]&&messagesQ,
		(
			Message[Error::DuplicateName,"qPCR protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[nameOption,_String],
		Test["If specified, Name is not already a qPCR protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(* --- Feature Flag: Check that user is not trying to specify addition of external duplex dye or reference dye (this is not currently supported) --- *)
	(* Check whether samples have been specified or volume has been specified for either dye *)
	invalidDyeOptions = Map[
		Function[{dyeOptionName},
			Module[{optionSpecifiedQ},
				(* Determine whether the option has been specified (Model[Molecule] is fine for dye options) *)
				optionSpecifiedQ = MatchQ[Lookup[roundedqPCROptions, dyeOptionName], VolumeP | ObjectP[{Model[Sample], Object[Sample]}]];

				If[optionSpecifiedQ && messagesQ,
					(
						Message[Error::SeparateDyesNotSupported];
						dyeOptionName
					),
					Nothing
				]
			]
		],
		{DuplexStainingDye, DuplexStainingDyeVolume, ReferenceDye, ReferenceDyeVolume}
	];

	(* If we are gathering tests, create a test *)
	invalidDyeTests = If[gatherTests,
		Test["Addition of separate duplex staining dye or reference dye has not been specified (this feature is not currently supported):",
			Length[invalidDyeOptions] == 0,
			True
		],
		Nothing
	];


	(* --- Check that if DuplexStainingDye is specified, there's no multiplexing in any sample --- *)
	(* Look up the value of DuplexStainingDye *)
	specifiedDuplexStainingDye=Lookup[roundedqPCROptions,DuplexStainingDye];

	(* Get the number of primer pairs for each sample *)
	numberOfPrimerPairsPerSample=Length/@myResolverPrimerInputs;

	(* Check if DuplexStainingDye is specified, there's only one primer pair in all samples *)
	duplexStainingDyeSingleplexQ=If[
		MatchQ[specifiedDuplexStainingDye,ObjectP[]],
		AllTrue[numberOfPrimerPairsPerSample,#<=1&],
		True
	];

	(* If duplexStainingDyeSingleplexQ is False AND we are throwing messages, then throw the message *)
	invalidDuplexStainingDyeSingleplexOptions=If[!duplexStainingDyeSingleplexQ&&messagesQ,
		(
			Message[Error::DuplexStainingDyeSpecifiedWithMultiplex];
			{DuplexStainingDye}
		),
		{}
	];

	(* If we are gathering tests, create a test *)
	duplexStainingDyeSingleplexTest=If[gatherTests,
		Test["If DuplexStainingDye is specified, there's no multiplexing in any sample:",
			duplexStainingDyeSingleplexQ,
			True
		],
		Nothing
	];


	(* --- Check that if Probe is specified, DuplexStainingDye is not specified --- *)
	(* Look up the value of Probe *)
	specifiedProbes=Lookup[roundedqPCROptions,Probe];

	(* Check if Probe is specified, DuplexStainingDye is Null (or Automatic, which will resolve to Null) *)
	probeSpecifiedDuplexStainingDyeNullQ=If[
		MemberQ[specifiedProbes, ObjectP[Object[Sample]]],
		MatchQ[specifiedDuplexStainingDye, Null|Automatic],
		True
	];

	(* If probeSpecifiedDuplexStainingDyeNullQ is False AND we are throwing messages, then throw the message *)
	invalidProbeSpecifiedDuplexStainingDyeNullOptions=If[!probeSpecifiedDuplexStainingDyeNullQ&&messagesQ,
		(
			Message[Error::ProbeDuplexStainingDyeConflict];
			{Probe,DuplexStainingDye}
		),
		{}
	];

	(* If we are gathering tests, create a test *)
	probeSpecifiedDuplexStainingDyeNullTest=If[gatherTests,
		Test["If Probe is specified for any sample, DuplexStainingDye is not specified:",
			probeSpecifiedDuplexStainingDyeNullQ,
			True
		],
		Nothing
	];


	(* --- Wavelength pair checks --- *)

	(* -- Check that if either DuplexStainingDyeExcitationWavelength or DuplexStainingDyeEmissionWavelength is specified, the other is also specified -- *)
	(* Look up the values of DuplexStainingDyeExcitationWavelength and DuplexStainingDyeEmissionWavelength *)
	specifiedDuplexStainingDyeExcitationWavelength=Lookup[roundedqPCROptions,DuplexStainingDyeExcitationWavelength];
	specifiedDuplexStainingDyeEmissionWavelength=Lookup[roundedqPCROptions,DuplexStainingDyeEmissionWavelength];

	(* Check if either option is specified, the other is also specified *)
	duplexStainingDyeExcitationEmissionPairQ=And[
		If[
			MatchQ[specifiedDuplexStainingDyeExcitationWavelength,qPCRExcitationWavelengthP],
			MatchQ[specifiedDuplexStainingDyeEmissionWavelength,qPCREmissionWavelengthP],
			True
		],
		If[
			MatchQ[specifiedDuplexStainingDyeEmissionWavelength,qPCREmissionWavelengthP],
			MatchQ[specifiedDuplexStainingDyeExcitationWavelength,qPCRExcitationWavelengthP],
			True
		]
	];

	(* If duplexStainingDyeExcitationEmissionPairQ is False AND we are throwing messages, then throw the message *)
	invalidDuplexStainingDyeExcitationEmissionPairOptions=If[!duplexStainingDyeExcitationEmissionPairQ&&messagesQ,
		(
			Message[Error::IncompleteDuplexStainingDyeExcitationEmissionPair];
			{DuplexStainingDyeExcitationWavelength,DuplexStainingDyeEmissionWavelength}
		),
		{}
	];

	(* If we are gathering tests, create a test *)
	duplexStainingDyeExcitationEmissionPairTest=If[gatherTests,
		Test["If either DuplexStainingDyeExcitationWavelength or DuplexStainingDyeEmissionWavelength is specified, the other is also specified:",
			duplexStainingDyeExcitationEmissionPairQ,
			True
		],
		Nothing
	];


	(* -- Check that if either ReferenceDyeExcitationWavelength or ReferenceDyeEmissionWavelength is specified, the other is also specified -- *)
	(* Look up the values of ReferenceDyeExcitationWavelength and ReferenceDyeEmissionWavelength *)
	specifiedReferenceDyeExcitationWavelength=Lookup[roundedqPCROptions,ReferenceDyeExcitationWavelength];
	specifiedReferenceDyeEmissionWavelength=Lookup[roundedqPCROptions,ReferenceDyeEmissionWavelength];

	(* Check if either option is specified, the other is also specified *)
	referenceDyeExcitationEmissionPairQ=And[
		If[
			MatchQ[specifiedReferenceDyeExcitationWavelength,qPCRExcitationWavelengthP],
			MatchQ[specifiedReferenceDyeEmissionWavelength,qPCREmissionWavelengthP],
			True
		],
		If[
			MatchQ[specifiedReferenceDyeEmissionWavelength,qPCREmissionWavelengthP],
			MatchQ[specifiedReferenceDyeExcitationWavelength,qPCRExcitationWavelengthP],
			True
		]
	];

	(* If referenceDyeExcitationEmissionPairQ is False AND we are throwing messages, then throw the message *)
	invalidReferenceDyeExcitationEmissionPairOptions=If[!referenceDyeExcitationEmissionPairQ&&messagesQ,
		(
			Message[Error::IncompleteReferenceDyeExcitationEmissionPair];
			{ReferenceDyeExcitationWavelength,ReferenceDyeEmissionWavelength}
		),
		{}
	];

	(* If we are gathering tests, create a test *)
	referenceDyeExcitationEmissionPairTest=If[gatherTests,
		Test["If either ReferenceDyeExcitationWavelength or ReferenceDyeEmissionWavelength is specified, the other is also specified:",
			referenceDyeExcitationEmissionPairQ,
			True
		],
		Nothing
	];


	(* -- Check that for each sample, if either ProbeExcitationWavelength or ProbeEmissionWavelength is specified, the other is also specified -- *)
	(* Look up the values of ProbeExcitationWavelength and ProbeEmissionWavelength *)
	specifiedProbeExcitationWavelengths=ToList[Lookup[roundedqPCROptions,ProbeExcitationWavelength]];
	specifiedProbeEmissionWavelengths=ToList[Lookup[roundedqPCROptions,ProbeEmissionWavelength]];

	(* Check if either option is specified, the other is also specified *)
	probeExcitationEmissionPairQ=AllTrue[Join[
		MapThread[
			If[MatchQ[#1,ListableP[qPCRExcitationWavelengthP]],
				MatchQ[#2,ListableP[qPCREmissionWavelengthP]],
				True
			]&,
			{specifiedProbeExcitationWavelengths,specifiedProbeEmissionWavelengths}
		],
		MapThread[
			If[MatchQ[#2,ListableP[qPCREmissionWavelengthP]],
				MatchQ[#1,ListableP[qPCRExcitationWavelengthP]],
				True
			]&,
			{specifiedProbeExcitationWavelengths,specifiedProbeEmissionWavelengths}
		]
	],TrueQ];

	(* If probeExcitationEmissionPairQ is False AND we are throwing messages, then throw the message *)
	invalidProbeExcitationEmissionPairOptions=If[!probeExcitationEmissionPairQ&&messagesQ,
		(
			Message[Error::IncompleteProbeExcitationEmissionPair];
			{ProbeExcitationWavelength,ProbeEmissionWavelength}
		),
		{}
	];

	(* If we are gathering tests, create a test *)
	probeExcitationEmissionPairTest=If[gatherTests,
		Test["For each sample, if either ProbeExcitationWavelength or ProbeEmissionWavelength is specified, the other is also specified:",
			probeExcitationEmissionPairQ,
			True
		],
		Nothing
	];


	(* -- Check that for each sample, if either StandardProbeExcitationWavelength or StandardProbeEmissionWavelength is specified, the other is also specified -- *)
	(* Look up the values of StandardProbeExcitationWavelength and StandardProbeEmissionWavelength *)
	specifiedStandardProbeExcitationWavelengths=ToList[Lookup[roundedqPCROptions,StandardProbeExcitationWavelength]];
	specifiedStandardProbeEmissionWavelengths=ToList[Lookup[roundedqPCROptions,StandardProbeEmissionWavelength]];

	(* Check if either option is specified, the other is also specified *)
	standardProbeExcitationEmissionPairQ=AllTrue[Join[
		MapThread[
			If[MatchQ[#1,qPCRExcitationWavelengthP],
				MatchQ[#2,qPCREmissionWavelengthP],
				True
			]&,
			{specifiedStandardProbeExcitationWavelengths,specifiedStandardProbeEmissionWavelengths}
		],
		MapThread[
			If[MatchQ[#2,qPCREmissionWavelengthP],
				MatchQ[#1,qPCRExcitationWavelengthP],
				True
			]&,
			{specifiedStandardProbeExcitationWavelengths,specifiedStandardProbeEmissionWavelengths}
		]
	],TrueQ];

	(* If standardProbeExcitationEmissionPairQ is False AND we are throwing messages, then throw the message *)
	invalidStandardProbeExcitationEmissionPairOptions=If[!standardProbeExcitationEmissionPairQ&&messagesQ,
		(
			Message[Error::IncompleteStandardProbeExcitationEmissionPair];
			{StandardProbeExcitationWavelength,StandardProbeEmissionWavelength}
		),
		{}
	];

	(* If we are gathering tests, create a test *)
	standardProbeExcitationEmissionPairTest=If[gatherTests,
		Test["For each sample, if either StandardProbeExcitationWavelength or StandardProbeEmissionWavelength is specified, the other is also specified:",
			standardProbeExcitationEmissionPairQ,
			True
		],
		Nothing
	];


	(* -- Check that for each sample, if either EndogenousProbeExcitationWavelength or EndogenousProbeEmissionWavelength is specified, the other is also specified -- *)
	(* Look up the values of EndogenousProbeExcitationWavelength and EndogenousProbeEmissionWavelength *)
	specifiedEndogenousProbeExcitationWavelengths=ToList[Lookup[roundedqPCROptions,EndogenousProbeExcitationWavelength]];
	specifiedEndogenousProbeEmissionWavelengths=ToList[Lookup[roundedqPCROptions,EndogenousProbeEmissionWavelength]];

	(* Check if either option is specified, the other is also specified *)
	endogenousProbeExcitationEmissionPairQ=AllTrue[Join[
		MapThread[
			If[MatchQ[#1,qPCRExcitationWavelengthP],
				MatchQ[#2,qPCREmissionWavelengthP],
				True
			]&,
			{specifiedEndogenousProbeExcitationWavelengths,specifiedEndogenousProbeEmissionWavelengths}
		],
		MapThread[
			If[MatchQ[#2,qPCREmissionWavelengthP],
				MatchQ[#1,qPCRExcitationWavelengthP],
				True
			]&,
			{specifiedEndogenousProbeExcitationWavelengths,specifiedEndogenousProbeEmissionWavelengths}
		]
	],TrueQ];

	(* If endogenousProbeExcitationEmissionPairQ is False AND we are throwing messages, then throw the message *)
	invalidEndogenousProbeExcitationEmissionPairOptions=If[!endogenousProbeExcitationEmissionPairQ&&messagesQ,
		(
			Message[Error::IncompleteEndogenousProbeExcitationEmissionPair];
			{EndogenousProbeExcitationWavelength,EndogenousProbeEmissionWavelength}
		),
		{}
	];

	(* If we are gathering tests, create a test *)
	endogenousProbeExcitationEmissionPairTest=If[gatherTests,
		Test["For each sample, if either EndogenousProbeExcitationWavelength or EndogenousProbeEmissionWavelength is specified, the other is also specified:",
			endogenousProbeExcitationEmissionPairQ,
			True
		],
		Nothing
	];


	(* --- Check that StandardPrimerPair is among the primer pair inputs --- *)
	(* Look up the value of StandardPrimerPair *)
	expandedStandardPrimerPair = With[{standardPairOptionValue = Lookup[roundedqPCROptions,StandardPrimerPair]},
		Which[
			MatchQ[standardPairOptionValue,{ObjectP[],ObjectP[]}], {standardPairOptionValue},
			MatchQ[standardPairOptionValue,{{ObjectP[],ObjectP[]}..}], standardPairOptionValue,
			True, {}
		]
	];

	(* Check if StandardPrimerPair is specified, it is among the primer pair inputs *)
	standardPrimerPairAmongInputsQList = MemberQ[myResolverPrimerInputs, #, {2}]& /@ expandedStandardPrimerPair;


	(* If the StandardPrimerPair is not one of the input primer pairs and we are throwing messages, throw a Warning *)
	If[MemberQ[standardPrimerPairAmongInputsQList, False] && messagesQ && !MatchQ[$ECLApplication,Engine],
		Message[
			Warning::StandardPrimerPairNotAmongInputs,
			ObjectToString[PickList[expandedStandardPrimerPair,standardPrimerPairAmongInputsQList, False],	Cache->simulatedCache]
		]
	];

	(* If we are gathering tests, create a test *)
	standardPrimerPairAmongInputsTest=If[Length[expandedStandardPrimerPair]>0 && gatherTests,
		Test["The specified StandardPrimerPair is among the primer pair inputs:",
			And@@standardPrimerPairAmongInputsQList,
			True
		],
		Nothing
	];


	(* --- Check that if Standard is specified, StandardPrimerPair is specified --- *)
	(* Decide whether we have a Standard/StandardPrimerPair conflict *)
	standardPrimersSpecifiedIfNeededQ = Switch[Lookup[roundedqPCROptions, {Standard, StandardPrimerPair}],
		(* If no standard has been specified, standard primers are not required *)
		{Null, _}, True,
		(* If standard has been specified but standard primers have not, throw an error *)
		{Except[Null], Null}, False,
		(* If standard and standard primers have both been specified, we good *)
		{Except[Null], Except[Null]}, True
	];

	(* If standardPrimersSpecifiedIfNeededQ is False AND we are throwing messages, then throw the message and add StandardPrimerPair to invalid options list *)
	standardPrimerInvalidOptions = If[Not[standardPrimersSpecifiedIfNeededQ] && messagesQ,
		(
			Message[Error::StandardPrimersRequired];
			{StandardPrimerPair}
		),
		{}
	];

	(* Generate Test for Standard / StandardPrimerPair specified together check *)
	standardPrimersSpecifiedIfStandardSpecifiedTest = If[gatherTests,
		Test["If standard samples are specified, standard primers are also specified:",
			standardPrimersSpecifiedIfNeededQ,
			True
		],
		Nothing
	];


	(* --- Check that MeltingCurveStartTemperature is less than MeltingCurveEndTemperature --- *)

	(* Set a variable tracking whether Start >= End if both melt start and endpoint were specified
		If not both options have been specified, GreaterEqual will remain unevaluated and TrueQ will return False *)
	invalidMeltEndpointsQ = TrueQ[GreaterEqual@@Lookup[roundedqPCROptions, {MeltingCurveStartTemperature, MeltingCurveEndTemperature}]];

	(* If probeSpecifiedDuplexStainingDyeNullQ is False AND we are throwing messages, then throw the message *)
	invalidMeltEndpointsOptions = If[invalidMeltEndpointsQ && messagesQ,
		(
			Message[Error::InvalidMeltEndpoints, Lookup[roundedqPCROptions, MeltingCurveStartTemperature], Lookup[roundedqPCROptions, MeltingCurveEndTemperature]];
			{MeltingCurveStartTemperature, MeltingCurveEndTemperature}
		),
		{}
	];

	(* If we are gathering tests, create a test *)
	invalidMeltEndpointsTests=If[gatherTests,
		Test["If a melting curve is being performed, MeltingCurveStartTemperature is less than MeltingCurveEndTemperature:",
			invalidMeltEndpointsQ,
			False
		],
		Nothing
	];


	(* --- Check that a qPCR instrument has been selected (realistically, a ViiA7) --- *)

	(* resolve the instrument *)
	(* note that once we have a more robust framework for figuring out Site before resource packets we can do that, but for now, we're just going to do $Site *)
	(* if we're at Austin we're going to use the Viia 7, and if we're at CMU we're going with the QuantStudio 7 Flex *)
	resolvedInstrument = Which[
		MatchQ[Lookup[roundedqPCROptions, Instrument], ObjectP[]], Lookup[roundedqPCROptions, Instrument],
		MatchQ[$Site, Object[Container, Site, "id:kEJ9mqJxOl63"]], Model[Instrument, Thermocycler, "id:D8KAEvdqzXYk"], (* Model[Instrument, Thermocycler, "ViiA 7"] *)
		True, Model[Instrument, Thermocycler, "id:R8e1PjeaXle4"] (* Model[Instrument, Thermocycler, "QuantStudio 7 Flex"] *)
	];

	(* Figure out whether a valid thermocycler has been selected *)
	invalidThermocyclerQ = Module[{inst, instModel},

		(* Look up instrument option *)
		inst = Download[resolvedInstrument, Object];

		(* If instrument option is an Object, look up model from its packet *)
		instModel = If[MatchQ[inst, ObjectP[Object[Instrument]]],
			Download[Lookup[fetchPacketFromCache[inst, simulatedCache], Model], Object],
			inst
		];

		(* Make sure the instrumet has (or is) the ViiA 7 model (or the QuantStudio 7 Flex model, for CMU) *)
		!MatchQ[
			instModel,
			Alternatives[
				Model[Instrument, Thermocycler, "id:D8KAEvdqzXYk"], (* Model[Instrument, Thermocycler, "ViiA 7"] *)
				Model[Instrument, Thermocycler, "id:R8e1PjeaXle4"]  (* Model[Instrument, Thermocycler, "QuantStudio 7 Flex"] *)
			]
		]
	];

	(* If probeSpecifiedDuplexStainingDyeNullQ is False AND we are throwing messages, then throw the message *)
	invalidThermocyclerOptions = If[invalidThermocyclerQ && messagesQ,
		(
			Message[Error::InvalidThermocycler, Lookup[roundedqPCROptions, Instrument]];
			{Instrument}
		),
		{}
	];

	(* If we are gathering tests, create a test *)
	invalidThermocyclerTests = If[gatherTests,
		Test["Specified Instrument is a qPCR-capable thermocycler instrument or model:",
			invalidThermocyclerQ,
			False
		],
		Nothing
	];


	(* --- Check if StandardPrimerPair is specified, StandardForwardPrimerVolume is non-Null --- *)

	(* Determine whether invalid Null volumes exist for standard forward primers *)
	invalidNullStandardForwardPrimerVolumeQ = If[!NullQ[Lookup[roundedqPCROptions, StandardPrimerPair]],
		MatchQ[Lookup[roundedqPCROptions, StandardForwardPrimerVolume], Null | _?(MemberQ[#, Null]&)],
		False
	];

	(* If probeSpecifiedDuplexStainingDyeNullQ is False AND we are throwing messages, then throw the message *)
	invalidNullStandardForwardPrimerOptions = If[invalidNullStandardForwardPrimerVolumeQ && messagesQ,
		(
			Message[Error::NullVolume, StandardPrimerPair, StandardForwardPrimerVolume];
			{StandardForwardPrimerVolume}
		),
		{}
	];

	(* If we are gathering tests, create a test *)
	invalidNullStandardForwardPrimerTests = If[gatherTests,
		Test["If StandardPrimerPair is specified, StandardForwardPrimerVolume must be non-Null:",
			invalidNullStandardForwardPrimerVolumeQ,
			False
		],
		Nothing
	];


	(* --- Check if StandardPrimerPair is specified, StandardReversePrimerVolume is non-Null --- *)

	(* Determine whether invalid Null volumes exist for standard reverse primers *)
	invalidNullStandardReversePrimerVolumeQ = If[!NullQ[Lookup[roundedqPCROptions, StandardPrimerPair]],
		MatchQ[Lookup[roundedqPCROptions, StandardReversePrimerVolume], Null | _?(MemberQ[#, Null]&)],
		False
	];

	(* If probeSpecifiedDuplexStainingDyeNullQ is False AND we are throwing messages, then throw the message *)
	invalidNullStandardReversePrimerOptions = If[invalidNullStandardReversePrimerVolumeQ && messagesQ,
		(
			Message[Error::NullVolume, StandardPrimerPair, StandardReversePrimerVolume];
			{StandardReversePrimerVolume}
		),
		{}
	];

	(* If we are gathering tests, create a test *)
	invalidNullStandardReversePrimerTests = If[gatherTests,
	Test["If StandardPrimerPair is specified, StandardForwardPrimerVolume must be non-Null:",
			invalidNullStandardReversePrimerVolumeQ,
			False
		],
		Nothing
	];

	(* --- Check if StandardProbe is specified, StandardProbeVolume is non-Null --- *)

	(* Determine whether invalid Null volumes exist for standard probes *)
	invalidNullStandardProbeVolumeQ = If[!NullQ[Lookup[roundedqPCROptions, StandardProbe]],
		MatchQ[Lookup[roundedqPCROptions, StandardProbeVolume], Null | _?(MemberQ[#, Null]&)],
		False
	];

	(* If probeSpecifiedDuplexStainingDyeNullQ is False AND we are throwing messages, then throw the message *)
	invalidNullStandardProbeVolumeOptions = If[invalidNullStandardProbeVolumeQ && messagesQ,
		(
			Message[Error::NullVolume, StandardProbe, StandardProbeVolume];
			{StandardProbeVolume}
		),
		{}
	];

	(* If we are gathering tests, create a test *)
	invalidNullStandardProbeVolumeTests = If[gatherTests,
	Test["If StandardProbe is specified, StandardProbeVolume must be non-Null:",
			invalidNullStandardProbeVolumeQ,
			False
		],
		Nothing
	];


	(* --- Check that if any Standard-specific options are specified, Standard is specified --- *)
	{standardRelatedOptionInvalidOptions, standardRelatedOptionTests} = dependentOptionCheck[
		roundedqPCROptions,
		Standard,
		{StandardPrimerPair, StandardForwardPrimerVolume, StandardReversePrimerVolume, StandardProbe, NumberOfStandardReplicates,
		NumberOfDilutions,SerialDilutionFactor, StandardProbeVolume, StandardProbeExcitationWavelength, StandardProbeEmissionWavelength}
	];

	(* --- Check that if any StandardProbe-specific options are specified, StandardProbe is specified --- *)
	{standardProbeRelatedOptionInvalidOptions, standardProbeRelatedOptionTests} = dependentOptionCheck[
		roundedqPCROptions,
		StandardProbe,
		{StandardProbeVolume, StandardProbeFluorophore, StandardProbeExcitationWavelength, StandardProbeEmissionWavelength}
	];

	(* --- Check that if any RT-specific options are specified, ReverseTranscription is not False --- *)
	{rtInvalidOptions, rtOptionTests} = masterSwitchCheck[
		roundedqPCROptions,
		ReverseTranscription,
		{ReverseTranscriptionTime, ReverseTranscriptionTemperature, ReverseTranscriptionRampRate}
	];

	(* --- Check that if any Activation-specific options are specified, Activation is not False --- *)
	{activationInvalidOptions, activationOptionTests} = masterSwitchCheck[
		roundedqPCROptions,
		Activation,
		{ActivationTime, ActivationTemperature, ActivationRampRate}
	];

	(* --- Check that if any PrimerAnnealing-specific options are specified, PrimerAnnealing is not False --- *)
	{annealingInvalidOptions, annealingOptionTests} = masterSwitchCheck[
		roundedqPCROptions,
		PrimerAnnealing,
		{PrimerAnnealingTime, PrimerAnnealingTemperature, PrimerAnnealingRampRate}
	];

	(* --- Check that if any MeltingCurve-specific options are specified, meltingCurveRampRate is not False --- *)
	{meltingCurveInvalidOptions, meltingCurveOptionTests} = masterSwitchCheck[
		roundedqPCROptions,
		MeltingCurve,
		{MeltingCurveTime, MeltingCurveStartTemperature, MeltingCurveEndTemperature, MeltingCurveRampRate}
	];


	(*-- RESOLVE EXPERIMENT OPTIONS, SINGLE --*)

	(*-- Helper functions and lookups for options resolution --*)

	(* Helper function to pull Ex/Em from looked up fluorophore packet and find nearest ViiA7 filter pair
	 	General algorithm is to find the Ex/Em pair with the smallest overall difference between maximum and
		filter wavelength for both excitation and emission. We also need to remove the duplicate Ex/Em pair of
		520nm/520nm that unfortunately exists and makes things complicated. *)

	(* If passed a fulfillment model or actual sample, we'll already be throwing an error because
	 	use of separate duplex staining and reference dyes is feature flagged at present.
		Just return a default wavelength pair to allow resolution to finish. *)
	viia7ExEm[fluorophore:ObjectP[{Object[Sample], Model[Sample]}]] := {470 Nanometer, 520 Nanometer};

	(* If passed a Model[Molecule], pick the Ex/Em pair with shortest excitation and find the nearest ViiA7 pair to it *)
	viia7ExEm[fluorophore:ObjectP[Model[Molecule]]] := Module[
		{fluorPacket, rawExWav, rawEmWav, nonNullExEmPairs},

		(* Look up fluorophore packet from cache *)
		fluorPacket = Experiment`Private`fetchPacketFromCache[fluorophore, simulatedCache];

		(* Pull Ex and Em wavelengths out, defaulting to Null *)
		rawExWav = Lookup[fluorPacket, FluorescenceExcitationMaximums, {}];
		rawEmWav = Lookup[fluorPacket, FluorescenceEmissionMaximums, {}];

		(* Pass to wavelength overload if there is a complete non-Null Ex/Em pair *)
		nonNullExEmPairs =  Cases[Transpose[{rawExWav, rawEmWav}], {Except[Null], Except[Null]}];

		If[Length[nonNullExEmPairs] == 0,
			(* If no non-Null pairs, use a default wavelength pair (TODO: Throw an error elsewhere?) *)
			{470 Nanometer, 520 Nanometer},
			(* If there is at least one non-Null pair, move forward with the one with the shortest excitation
				under the assumption that that will be the fluorophore in a fluorophore-quencher pair *)
			viia7ExEm[First[MinimalBy[nonNullExEmPairs, First]]]
		]
	];

	(* Core overload - find closest available and feasible Ex/Em filter combination *)
	viia7ExEm[actualExEmPair:{DistanceP, DistanceP}] := Module[
		{allExEmTuples},

		(* Get all possible Ex/Em pairs, eliminating pairs that have the same wavelength for both *)
		allExEmTuples = DeleteCases[
			Tuples[{List@@qPCRExcitationWavelengthP, List@@qPCREmissionWavelengthP}],
			Except[_?DuplicateFreeQ]
		];

		(* Find the pair with the smallest overall difference between Ex/Em maxima and filters *)
		First[MinimalBy[allExEmTuples, Total[Abs[actualExEmPair-#]]&]]
	];

	(* Hard code explicitly supported master mix models for now *)
	(* NOTE: When adding an entry to any of the lists below, be sure to add entries in the lookup tables below for their
	 	various important properties *)
	masterMixSYBRMinusRT = {Model[Sample, "id:Vrbp1jKdo8Ez"]}; (* Power SYBR Green PCR Master Mix *)
	masterMixSYBRPlusRT = {}; (* We don't currently have any master mix to fill this niche *)
	masterMixProbeMinusRT = {Model[Sample, "id:BYDOjvG606eX"]}; (* iTaq Universal Probes Supermix *)
	masterMixProbePlusRT = {Model[Sample, "id:aXRlGn6YABEp"]}; (* TaqMan Fast Virus 1-Step Master Mix *)

	(* Define common dye molecules *)
	sybrMolecule = Model[Molecule, "id:lYq9jRxPaDEl"];
	roxMolecule = Model[Molecule, "id:lYq9jRxPaPGV"];


	(* --- Define some lookup tables for important properties of master mixes --- *)
	(* These can be replaced by computation based on Composition[[All,2]] down the road *)

	(* Define a lookup table for fold concentration of various master mixes *)
	masterMixFoldConcentrationLookup = {
		Model[Sample, "id:Vrbp1jKdo8Ez"] -> 2, (* Power SYBR Green PCR Master Mix *)
		Model[Sample, "id:BYDOjvG606eX"] -> 2, (* iTaq Universal Probes Supermix *)
		Model[Sample,"id:M8n3rx0RWw75"]->2,(*TaqMan Universal PCR Master Mix, no AmpErase UNG*)
		Model[Sample, "id:aXRlGn6YABEp"] -> 4, (* TaqMan Fast Virus 1-Step Master Mix *)
		_ -> 2 (* Default for anything not listed above *)
	};

	(* Define a lookup table for duplex dye of various master mixes *)
	masterMixDuplexDyeLookup = {
		Model[Sample, "id:Vrbp1jKdo8Ez"] -> sybrMolecule, (* Power SYBR Green PCR Master Mix *)
		Model[Sample, "id:BYDOjvG606eX"] -> Null, (* iTaq Universal Probes Supermix *)
		Model[Sample,"id:M8n3rx0RWw75"]->Null,(*TaqMan Universal PCR Master Mix, no AmpErase UNG*)
		Model[Sample, "id:aXRlGn6YABEp"] -> Null, (* TaqMan Fast Virus 1-Step Master Mix *)
		_ -> sybrMolecule (* Default for anything not listed above *)
	};

	(* Define a lookup table for reference dye of various master mixes *)
	(* All our stocked master mixes use ROX; we don't currently stock any master mixes WITHOUT a passive reference dye *)
	masterMixReferenceDyeLookup = {
		Model[Sample, "id:Vrbp1jKdo8Ez"] -> roxMolecule, (* Power SYBR Green PCR Master Mix *)
		Model[Sample, "id:BYDOjvG606eX"] -> roxMolecule, (* iTaq Universal Probes Supermix *)
		Model[Sample,"id:M8n3rx0RWw75"]->roxMolecule,(*TaqMan Universal PCR Master Mix, no AmpErase UNG*)
		Model[Sample, "id:aXRlGn6YABEp"] -> roxMolecule, (* TaqMan Fast Virus 1-Step Master Mix *)
		_ -> roxMolecule (* Default for anything not listed above *)
	};

	(* helper that either takes the user value or resolve the automatic to the automatic value*)
	resolveAutomatic[assoc_,option_,automaticValue_]:=With[{value=Lookup[assoc,option]},
		If[MatchQ[value,Automatic],automaticValue,value]
	];

	(* a helper that helps resolve automatic options that are gated upon another (T/F) option or takes in user provided value *)
	resolveAutomatic[assoc_,option_,gateBool_,trueValue_,falseValue_]:=With[
		{value=Lookup[assoc,option]},
		(* if value is automatic, further resolve based on gateBool, else take the provied value*)
		If[MatchQ[value,Automatic],
			If[gateBool,trueValue,falseValue],
			value
		]
	];


	(* easy enough, resolve to the default value or whatever the user wants*)
	resolvedReactionVolume=resolveAutomatic[roundedqPCROptions,ReactionVolume,20 Microliter];


	(* === Resolve RT and related options up front, because MasterMix automatic resolution depends on it === *)

	(* TODO: Error check for RT master mix but RT specifically set to False *)
	(* TODO: Error check for non-RT master mix but some RT options specified *)

	resolvedReverseTranscription = With[{rtOption = Lookup[roundedqPCROptions, ReverseTranscription]},
		If[!MatchQ[rtOption, Automatic],
			(* If the RT option was specified, use it *)
			rtOption,
			(* ELSE if the RT option is automatic, do some resolving *)
			If[
				And[
					MatchQ[Lookup[roundedqPCROptions, {ReverseTranscriptionTime, ReverseTranscriptionTemperature, ReverseTranscriptionRampRate}], {Automatic..}],
					!MemberQ[Join[masterMixSYBRPlusRT, masterMixProbePlusRT], Lookup[roundedqPCROptions,MasterMix]]
				],
				(* If all RT-related options are Automatic and the specified master mix is not an RT master mix, resolve to False *)
				False,
				(* ELSE one or more options indicate that RT should be True, so resolve to True *)
				True
			]
		]
	];
	resolvedTranscriptionTime=resolveAutomatic[roundedqPCROptions,ReverseTranscriptionTime,resolvedReverseTranscription,10 Minute, Null];
	resolvedTranscriptionTemperature=resolveAutomatic[roundedqPCROptions,ReverseTranscriptionTemperature,resolvedReverseTranscription,50 Celsius, Null];
	resolvedTranscriptionRampRate=resolveAutomatic[roundedqPCROptions,ReverseTranscriptionRampRate,resolvedReverseTranscription,1.6 (Celsius/Second), Null];


	(* === Resolve master mix and dye related options === *)

	(* Resolve to a dye-free master mix if probes are being used *)
	(* TODO: Allow resolution of master mix based on duplex dye value? *)
	omitDuplexDyeQ = MatchQ[Flatten[Lookup[roundedqPCROptions,Probe]],ListableP[ObjectP[]]];

	(* This option was previously not even automatic, but automatic "resolution" was happening...? Made Automatic. *)
	(* TODO: Down the road if we allow for multiplexing without separate probes (e.g., Scorpion primers),
		we'll want to check something more complex than omitDuplexDyeQ here. Detect fluorophores in primers' Composition[[All,2]]. *)
	resolvedMasterMix = With[{masterMixOption = Lookup[roundedqPCROptions,MasterMix]},
		If[!MatchQ[masterMixOption, Automatic],
			masterMixOption,
			Switch[{omitDuplexDyeQ, resolvedReverseTranscription},
				{False, False}, First[masterMixSYBRMinusRT, Null],
				{False, True}, First[masterMixSYBRPlusRT, Null],
				{True, False}, First[masterMixProbeMinusRT, Null],
				{True, True}, First[masterMixProbePlusRT, Null]
			]
		]
	];

	(* Download the ID in case MasterMix was specified by Name (should be in download cache),
	 	converting to a model if we were given an object.
		May want to add a warning in the future if passed a sample with model link severed, because
		this will prevent us from resolving any useful information about the master mix. *)
	resolvedMasterMixModel = If[MatchQ[resolvedMasterMix, ObjectP[Object[Sample]]],
		(* If resolved MasterMix option is an object, fetch its packet and pull its Model field *)
		Download[Lookup[fetchPacketFromCache[resolvedMasterMix, simulatedCache], Model, Null], Object],
		(* If resolved MasterMix option is a model, download Object in case it's referenced by name *)
		Download[resolvedMasterMix, Object]
	];


	(* --- If a master mix has been specified that does not have a model specifically handled by ExperimentqPCR, throw a warning --- *)

	(* Figure out whether master mix option is a known model *)
	unknownMasterMixQ = !MemberQ[Keys[masterMixFoldConcentrationLookup], resolvedMasterMixModel];

	(* If the master mix has not been specifically onboarded into ExperimentqPCR and we are throwing messages, throw a Warning *)
	If[unknownMasterMixQ && messagesQ && !MatchQ[$ECLApplication,Engine],
		Message[
			Warning::UnknownMasterMix,
			ObjectToString[resolvedMasterMixModel,	Cache->simulatedCache],
			"SYBR Green duplex staining dye, ROX passive reference dye, and no reverse transcriptase"
		]
	];

	(* If we are gathering tests, create a test *)
	unknownMasterMixTest = If[unknownMasterMixQ && gatherTests,
		Test["The specified MasterMix model, " <> ObjectToString[resolvedMasterMixModel,Cache->simulatedCache] <> ", has been pre-evaluated for use in ExperimentqPCR and has known working concentration (e.g., 2x) dye content (e.g. duplex and/or reference dyes), and reverse transcriptase content:",
			False,
			True
		],
		Nothing
	];



	(* If MasterMixVolume is Automatic, resolve based on fold concentration *)
	resolvedMasterMixVolume = With[
		{
			masterMixVolumeOption = Lookup[roundedqPCROptions, MasterMixVolume],
			calculatedMasterMixVolume = resolvedReactionVolume / (resolvedMasterMixModel /. masterMixFoldConcentrationLookup)
		},
		If[!MatchQ[masterMixVolumeOption, Automatic],
			(* If user specified an option, use it *)
			(* TODO: Add a warning if user is using master mix at something other than recommended concentration *)
			masterMixVolumeOption,
			(* ELSE, calculate master mix volume to use based on hard-coded fold concentrations stored above *)
			calculatedMasterMixVolume
		]
	];

	(* Figure out the identity of the duplex dye included in the master mix, if any *)
	(* TODO: Pull this out of the master mix Composition field *)
	(* TODO: Handle master mix SAMPLES as well; currently punt if MasterMix doesn't match one of known models *)
	masterMixStainingDye = With[
		{
			masterMixDyeOption = Lookup[roundedqPCROptions, DuplexStainingDye],
			expectedMasterMixDye = resolvedMasterMixModel /. masterMixDuplexDyeLookup
		},
		If[!MatchQ[masterMixDyeOption, Automatic],
			(* If user specified an option, use it *)
			(* TODO: Add a warning if user specifies a dye other than the one the master mix contains *)
			masterMixDyeOption,
			(* ELSE, calculate master mix volume to use based on hard-coded fold concentrations stored above *)
			expectedMasterMixDye
		]
	];

	(* Does master mix include a duplex staining dye? *)
	hasStainingDye = ObjectQ[masterMixStainingDye];

	(* By definition, this should be changed to always be the dye in the master mix.
	 	We do not currently allow for addition of separate staining dye. *)
	resolvedDuplexStainingDye = resolveAutomatic[roundedqPCROptions,DuplexStainingDye,hasStainingDye,masterMixStainingDye, Null];

	(* Per the comment on the line above, this will be removed. *)
	resolvedDuplexStainingDyeVolume = resolveAutomatic[roundedqPCROptions,DuplexStainingDyeVolume,
		(* if the master mix has no dye but user supplied one*)
		And[Not[hasStainingDye],ObjectQ[resolvedDuplexStainingDye]],
		1 Microliter,
		Null
	];

	(* Look up Ex/Em from Model[Molecule], finding the closest matches in the QuantStudio Ex/Em sets *)
	{lookedUpDuplexDyeEx, lookedUpDuplexDyeEm} = If[hasStainingDye,
		viia7ExEm[resolvedDuplexStainingDye],
		{Null, Null}
	];

	(* If reference dye is being used and wavelengths haven't been specified, use the looked-up values from above *)
	resolvedDuplexStainingDyeExcitationWavelength = resolveAutomatic[roundedqPCROptions, DuplexStainingDyeExcitationWavelength, hasStainingDye, lookedUpDuplexDyeEx, Null];
	resolvedDuplexStainingDyeEmissionWavelength = resolveAutomatic[roundedqPCROptions, DuplexStainingDyeEmissionWavelength, hasStainingDye, lookedUpDuplexDyeEm, Null];


	(* === Resolve all the reference dye options === *)

	(* Look up what reference dye is included in the master mix, if any *)
	masterMixReferenceDye = With[
		{
			masterMixReferenceDyeOption = Lookup[roundedqPCROptions, ReferenceDye],
			expectedMasterMixReferenceDye = resolvedMasterMixModel /. masterMixReferenceDyeLookup
		},
		If[!MatchQ[masterMixReferenceDyeOption, Automatic],
			(* If user specified an option, use it *)
			(* TODO: Add a warning if user specifies a dye other than the one the master mix contains *)
			masterMixReferenceDyeOption,
			(* ELSE, calculate master mix volume to use based on hard-coded fold concentrations stored above *)
			expectedMasterMixReferenceDye
		]
	];

	(* Does master mix include a passive reference dye? *)
	hasReferenceDye=ObjectQ[masterMixReferenceDye];

	(* By definition, this should be changed to always be the dye in the master mix.
	 	We do not currently allow for addition of separate reference dye. *)
	resolvedReferenceDye=resolveAutomatic[roundedqPCROptions,ReferenceDye,hasReferenceDye,masterMixReferenceDye, Null];

	(* Per the comment on the line above, this will be removed. *)
	resolvedReferenceDyeVolume=resolveAutomatic[roundedqPCROptions,ReferenceDyeVolume,
		(* if the master mix has no dye and user supplied one*)
		And[Not[hasReferenceDye],ObjectQ[resolvedReferenceDye]],
		1 Microliter,Null
	];

	(* Look up Ex/Em from Model[Molecule], finding the closest matches in the QuantStudio Ex/Em sets *)
	{lookedUpReferenceDyeEx, lookedUpReferenceDyeEm} = If[hasReferenceDye,
		viia7ExEm[resolvedReferenceDye],
		{Null, Null}
	];

	(* If reference dye is being used and wavelengths haven't been specified, use the looked-up values from above *)
	resolvedReferenceStainingDyeExcitationWavelength = resolveAutomatic[roundedqPCROptions, ReferenceDyeExcitationWavelength, hasReferenceDye, lookedUpReferenceDyeEx, Null];
	resolvedReferenceStainingDyeEmissionWavelength = resolveAutomatic[roundedqPCROptions, ReferenceDyeEmissionWavelength, hasReferenceDye, lookedUpReferenceDyeEm, Null];


	(* resolve all the activation (hot start) options *)
	resolvedActivation=Lookup[roundedqPCROptions,Activation];
	resolvedActivationTime=resolveAutomatic[roundedqPCROptions,ActivationTime,resolvedActivation,1 Minute, Null];
	resolvedActivationTemperature=resolveAutomatic[roundedqPCROptions,ActivationTemperature,resolvedActivation,95 Celsius, Null];
	resolvedActivationRampRate=resolveAutomatic[roundedqPCROptions,ActivationRampRate,resolvedActivation,1.6 (Celsius/Second), Null];

	(* resolve all of the denaturation options*)
	resolvedDenaturationTime=Lookup[roundedqPCROptions,DenaturationTime];
	resolvedDenaturationTemperature=Lookup[roundedqPCROptions,DenaturationTemperature];
	resolvedDenaturationRampRate=Lookup[roundedqPCROptions,DenaturationRampRate];

	(* resolve all the annealing options (this is optional because annealing can be done as part of extension) *)
	resolvedAnnealing = resolveAutomatic[
		roundedqPCROptions,
		PrimerAnnealing,
		MatchQ[Lookup[roundedqPCROptions, {PrimerAnnealingTime, PrimerAnnealingTemperature, PrimerAnnealingRampRate}], {Automatic..}],
		False,
		True
	];
	resolvedAnnealingTime = resolveAutomatic[roundedqPCROptions,PrimerAnnealingTime,resolvedAnnealing,30 Second, Null];
	resolvedAnnealingTemperature = resolveAutomatic[roundedqPCROptions,PrimerAnnealingTemperature,resolvedAnnealing,60 Celsius, Null];
	resolvedAnnealingRampRate = resolveAutomatic[roundedqPCROptions,PrimerAnnealingRampRate,resolvedAnnealing,1.6 (Celsius/Second), Null];

	(* resolve all of the extension options*)
	resolvedExtensionTime=Lookup[roundedqPCROptions,ExtensionTime];
	resolvedExtensionTemperature=Lookup[roundedqPCROptions,ExtensionTemperature];
	resolvedExtensionRampRate=Lookup[roundedqPCROptions,ExtensionRampRate];

	resolvedNumberOfCycles=Lookup[roundedqPCROptions,NumberOfCycles];

	(* resolve all the melting curve options *)
	(* TODO: this is resolved based on the type of qPCR this is
		Ben note: What? You mean whether or not duplex staining dye is being used? *)
	meltingCurve=resolveAutomatic[roundedqPCROptions,MeltingCurve,hasStainingDye,True,False];
	meltingCurveStartTemperature=resolveAutomatic[roundedqPCROptions,MeltingCurveStartTemperature,meltingCurve,60 Celsius, Null];
	meltingCurveEndTemperature=resolveAutomatic[roundedqPCROptions,MeltingCurveEndTemperature,meltingCurve,95 Celsius, Null];
	preMeltingCurveRampRate=resolveAutomatic[roundedqPCROptions,PreMeltingCurveRampRate,meltingCurve,1.6 (Celsius/Second), Null];

	meltingCurveTempDifference=meltingCurveEndTemperature-meltingCurveStartTemperature;
	unresolvedMeltingCurveRampRate=Lookup[roundedqPCROptions,MeltingCurveRampRate];
	unresolvedMeltingCurveTime=Lookup[roundedqPCROptions,MeltingCurveTime];
	defaultCurveRampRate=(.015 (Celsius/Second));

	{meltingCurveRampRate,meltingCurveTime}=Switch[
		{meltingCurve,unresolvedMeltingCurveRampRate,unresolvedMeltingCurveTime},
		{True,Automatic,Automatic},{defaultCurveRampRate,RoundOptionPrecision[meltingCurveTempDifference/defaultCurveRampRate, 1 Second]},
		{True,Automatic,Except[Automatic]},{RoundOptionPrecision[meltingCurveTempDifference/unresolvedMeltingCurveTime, .001 Celsius/Second],unresolvedMeltingCurveTime},
		{True,Except[Automatic],Automatic},{unresolvedMeltingCurveRampRate,RoundOptionPrecision[meltingCurveTempDifference/unresolvedMeltingCurveRampRate, 1 Second]},
		(* preserving user option here, but this should result in an error if the math doesn't work out here*)
		{True,Except[Automatic],Except[Automatic]},{unresolvedMeltingCurveRampRate,unresolvedMeltingCurveTime},

		{False,Automatic,Automatic},{Null,Null},
		{False,Automatic,Except[Automatic]},{Null,unresolvedMeltingCurveTime},
		{False,Except[Automatic],Automatic},{unresolvedMeltingCurveRampRate,Null},
		{False,Except[Automatic],Except[Automatic]},{unresolvedMeltingCurveRampRate,unresolvedMeltingCurveTime}
	];


	(* -- RESOLVE THE STANDARD OPTIONS -- *)
	(* they can give as many standards as they want, but if there are fewer than there are unique primers pairs then we need to
	 warn them that that is not going to work, and Take[] as many as needed to make the resolution work *)
	(* What? I get why this is prudent experimentally, but why must the number of unique primer pairs match the number of standard samples for error-free resolution? *)

	uniquePrimerPairs=DeleteDuplicates[Flatten[myResolverPrimerInputs,1]];
	enoughPrimerPairs=Table[
		uniquePrimerPairs[[1]],
		Length[ToList[Lookup[roundedqPCROptions,Standard]]]
	];

	(* Resolve the standard volume if we have a standard of any kind *)
	hasStandard=MemberQ[ToList[Lookup[roundedqPCROptions,Standard]],ObjectP[]];
	resolvedStandardVolume=resolveAutomatic[roundedqPCROptions,StandardVolume,hasStandard,2 Microliter, Null];

	(* MapThread to resolve Standard index-matched options *)
	{
		resolvedStandards,
		resolvedStandardPrimerPairs,
		resolvedSerialDilutionFactors,
		resolvedNumberOfDilutions,
		resolvedNumberOfStandardReplicates,
		resolvedStandardForwardPrimerVolumes,
		resolvedStandardReversePrimerVolumes,
		resolvedStandardProbes,
		resolvedStandardProbeVolumes,
		resolvedStandardProbeEmissionWavelengths,
		resolvedStandardProbeExcitationWavelengths,
		resolvedStandardProbeFluorophores
	} = If[!hasStandard,
		(* If no standards have been specified (i.e., Standard->Null), set all standard options to {}
			Will have done error checking above to surface warnings if other standard options have been specified
				while Standard->Null *)
		ConstantArray[Null, 12],
		(* If standard(s) have been specified, resolve as usual *)
		Transpose[MapThread[
			Function[
				{unresolvedStandard,unresolvedPrimerPair,unresolvedSerialDilutionFactor,unresolvedNumberOfDilutions,unresolvedNumberOfStandardReplicates,unresolvedStandardForwardPrimerVolume,
				unresolvedStandardReversePrimerVolume, unresolvedStandardProbe,unresolvedStandardProbeVolume,unresolvedStandardProbeExcitationWavelength,unresolvedStandardProbeEmissionWavelength,
				unresolvedStandardProbeFluorophore, defaultPrimers},
				Module[
					{resolvedStandard,resolvedStandardProbe,resolvedPrimers,resolvedSerialDilutionFactor,resolvedSingleNumberOfDilutions,resolvedSingleNumberOfStandardReplicates,resolvedStandardForwardPrimerVolume,
					resolvedStandardReversePrimerVolume,resolvedStandardProbeVolume,portionOfReaction,resolvedStandardProbeExcitationWavelength,resolvedStandardProbeEmissionWavelength, resolvedStandardProbeFluorophore},

					(* standard, primers, and probe must be provide by the user*)
					resolvedStandard = unresolvedStandard;
					resolvedStandardProbe = unresolvedStandardProbe;
					resolvedPrimers = unresolvedPrimerPair;

					(* take the user primer, or use one of the input primer pairs as a default to allow resolution to continue *)
					(* resolvedPrimers=Switch[{resolvedStandard,unresolvedPrimerPair},
						{Null,Automatic},{Null,Null},
						{Null,Except[Automatic]},unresolvedPrimerPair,
						{Except[Null],Automatic},defaultPrimers,
						{Except[Null],Except[Automatic]},unresolvedPrimerPair
					]; *)

					(* default 1 one curve per primer pair, or take the user option *)
					resolvedSingleNumberOfStandardReplicates=Switch[{resolvedStandard,unresolvedNumberOfStandardReplicates},
						{_,Except[Automatic]},unresolvedNumberOfStandardReplicates,
						{Except[Null],Automatic},1,
						{Null,Automatic},Null
					];

					(* figure how the dilution factor *)
					resolvedSerialDilutionFactor=Switch[{resolvedStandard,unresolvedSerialDilutionFactor},
						{_,Except[Automatic]},unresolvedSerialDilutionFactor,
						{Except[Null],Automatic},2,
						{Null,Automatic},Null
					];

					(* figure out number of dilutions *)
					resolvedSingleNumberOfDilutions=Switch[{resolvedStandard,unresolvedNumberOfDilutions},
						{_,Except[Automatic]},unresolvedNumberOfDilutions,
						{Except[Null],Automatic},8,
						{Null,Automatic},Null
					];

					(* adding the standard to reaction volume dilutes it, there is no way of getting around for this so have to account for that in the maths*)
					portionOfReaction=resolvedReactionVolume/resolvedStandardVolume;

					(* (REMOVED UNTIL AFTER SAMPLEFEST) next up resolve the concentrations, this can go 2 different ways *)
					(* straight up list of concentrations (only doable if the standard HAS a concentration) *)
					(* serial dilution, which can be done without a concentration *)

					(* Resolve forward and reverse primer volumes together:
						- Forward or reverse can resolve based on one another if only one is specified
						- If neither has been specified, default both to 1 uL *)
					{resolvedStandardForwardPrimerVolume, resolvedStandardReversePrimerVolume} = Switch[{unresolvedStandardForwardPrimerVolume, unresolvedStandardReversePrimerVolume},
						(* If forward is specified and reverse is not, expand the forward primer to match the number of pairs (if necessary) and use for both *)
						{Except[Automatic], Automatic}, ConstantArray[unresolvedStandardForwardPrimerVolume, 2],
						(* If reverse is specified and forward is not, expand the reverse primer to match the number of pairs (if necessary) and use for both *)
						{Automatic, Except[Automatic]}, ConstantArray[unresolvedStandardReversePrimerVolume, 2],
						(* If both are Automatic, generate a list of default values the same length as the list of primer pairs and use for both *)
						{Automatic, Automatic},  {1 Microliter, 1 Microliter},
						(* If both have been explicitly specified, use them *)
						{Except[Automatic], Except[Automatic]}, {unresolvedStandardForwardPrimerVolume, unresolvedStandardReversePrimerVolume}
					];

					resolvedStandardProbeVolume=Switch[{resolvedStandardProbe,unresolvedStandardProbeVolume},
						{_,Except[Automatic]},unresolvedStandardProbeVolume,
						{Except[Null],Automatic},1 Microliter,
						{Null,Automatic},Null
					];

					resolvedStandardProbeExcitationWavelength=Switch[{resolvedStandardProbe,unresolvedStandardProbeExcitationWavelength},
						{_,Except[Automatic]},unresolvedStandardProbeExcitationWavelength,
						{Except[Null],Automatic},Quantity[470, "Nanometers"],
						{Null,Automatic},Null
					];

					resolvedStandardProbeEmissionWavelength=Switch[{resolvedStandardProbe,unresolvedStandardProbeEmissionWavelength},
						{_,Except[Automatic]},unresolvedStandardProbeEmissionWavelength,
						{Except[Null],Automatic},Quantity[558, "Nanometers"],
						{Null,Automatic},Null
					];

					(* StandardProbe->Null, StandardProbeFluorophore->Except[Null] covered by dependentOptionCheck error check above
						StandardProbe->Except[Null], StandardProbeFluorophore->Null covered by dependentOptionCheck error check above *)
					resolvedStandardProbeFluorophore = Switch[{resolvedStandardProbe, unresolvedStandardProbeFluorophore},
						(* If StandardProbeFluorophore was specified, use it *)
						{_, Except[Automatic]}, unresolvedStandardProbeFluorophore,
						(* If StandardProbe was specified but fluorophore was not, throw an error and resolve to Null *)
						{Except[Null], Automatic}, Null,
						(* If neither StandardProbe nor StandardProbeFluorophore were specified, resolve to Null *)
						{Null, Automatic}, Null
					];

					{
						resolvedStandard,
						resolvedPrimers,
						resolvedSerialDilutionFactor,
						resolvedSingleNumberOfDilutions,
						resolvedSingleNumberOfStandardReplicates,
						resolvedStandardForwardPrimerVolume,
						resolvedStandardReversePrimerVolume,
						resolvedStandardProbe,
						resolvedStandardProbeVolume,
						resolvedStandardProbeEmissionWavelength,
						resolvedStandardProbeExcitationWavelength,
						resolvedStandardProbeFluorophore
					}

				]
			],
			(* Since we can't use mapThreadOptions for things that aren't index matched to SamplesIn,
				manually ensure that all of these options are listed appropriately *)
			{
				ToList[Lookup[roundedqPCROptions,Standard]],
				(* Need to ensure that StandardPrimerPair is specified as a list of lists to avoid errors above *)
				With[{stdPrimPair = Lookup[roundedqPCROptions,StandardPrimerPair]},
					If[MatchQ[stdPrimPair, {{ObjectP[], ObjectP[]}..}],
						(* If already a properly formatted list of pairs, leave it alone *)
						stdPrimPair,
						(* In any other case, wrap it in an extra list *)
						{stdPrimPair}
					]
				],

				ToList[Lookup[roundedqPCROptions,SerialDilutionFactor]],
				ToList[Lookup[roundedqPCROptions,NumberOfDilutions]],
				ToList[Lookup[roundedqPCROptions,NumberOfStandardReplicates]],

				ToList[Lookup[roundedqPCROptions,StandardForwardPrimerVolume]],
				ToList[Lookup[roundedqPCROptions,StandardReversePrimerVolume]],

				ToList[Lookup[roundedqPCROptions,StandardProbe]],
				ToList[Lookup[roundedqPCROptions,StandardProbeVolume]],

				ToList[Lookup[roundedqPCROptions,StandardProbeExcitationWavelength]],
				ToList[Lookup[roundedqPCROptions,StandardProbeEmissionWavelength]],
				ToList[Lookup[roundedqPCROptions,StandardProbeFluorophore]],


				enoughPrimerPairs
			}
		]]
	];


	(*-- RESOLVE EXPERIMENT OPTIONS, MULTIPLE --*)
	(* Convert our options into a MapThread friendly version. *)
	(* NOTE: MAPPING*)
	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentqPCR,roundedqPCROptions];

	{
		resolvedSampleVolumes,
		resolvedBufferVolumes,
		resolvedEndogenousPrimerPairs,
		resolvedEndogenousForwardPrimerVolumes,
		resolvedEndogenousReversePrimerVolumes,
		resolvedEndogenousProbes,
		resolvedEndogenousProbeVolumes,
		resolvedEndogenousProbeEmissionWavelengths,
		resolvedEndogenousProbeExcitationWavelengths,
		resolvedEndogenousProbeFluorophores,
		resolvedForwardPrimerVolumes,
		resolvedReversePrimerVolumes,
		resolvedProbes,
		resolvedProbeVolumes,
		resolvedProbeEmissionWavelengths,
		resolvedProbeExcitationWavelengths,
		resolvedProbeFluorophores,

		probeLengthErrors,
		probeVolumeLengthErrors,
		multiplexingDuplexDyeErrors,
		excessiveVolumeErrors,
		bufferVolumeMismatchErrors,
		probeVolumeNoProbeErrors,
		probeExcitationNoProbeErrors,
		probeEmissionNoProbeErrors,
		forwardPrimerVolumeLengthErrors,
		reversePrimerVolumeLengthErrors,
		probeNoFluorophoreErrors,
		probeFluorophoreNoProbeErrors,
		probeFluorophoreLengthErrors,
		endogenousProbeFluorophoreNoProbeErrors,
		endogenousProbeNoFluorophoreErrors,
		endogenousPrimersNoProbeErrors,
		invalidNullProbeVolumeErrors,
		invalidNullEndogenousForwardPrimerVolumeErrors,
		invalidNullEndogenousReversePrimerVolumeErrors,
		invalidNullEndogenousProbeVolumeErrors,
		duplicateProbeWavelengthErrors
	}=Transpose[
		MapThread[
			Function[{samplePacket,primerPairs,options},
				Module[
					{
						(* Error variables *)
						errorVariables, probeLengthError, probeVolumeLengthError, bufferVolumeError, probeExcitationLengthError, probeEmissionLengthError,
						multiplexingDuplexDyeError, excessiveVolumeError, bufferVolumeMismatchError, probeVolumeNoProbeError, probeExcitationNoProbeError, probeEmissionNoProbeError,
						forwardPrimerVolumeLengthError, reversePrimerVolumeLengthError, probeNoFluorophoreError, probeFluorophoreNoProbeError, probeFluorophoreLengthError,
						endogenousProbeFluorophoreNoProbeError, endogenousProbeNoFluorophoreError, endogenousPrimersNoProbeError, invalidNullProbeVolumeError,
						invalidNullEndogenousForwardPrimerVolumeError, invalidNullEndogenousReversePrimerVolumeError, invalidNullEndogenousProbeVolumeError,
						duplicateProbeWavelengthError,

						(* Resolved option variables *)
						resolvedSampleVolume,resolvedEndogenousPrimerPair,resolvedEndogenousForwardPrimerVolume,resolvedEndogenousReversePrimerVolume,resolvedEndogenousProbe,
						hasEndogenousControl,hasPrimers,hasProbes,hasEndogenousProbe,resolvedPrimerPairVolume,resolvedProbe,resolvedProbeVolume,resolvedBufferVolume,volumeSoFar,
						resolvedEndogenousProbeVolume,resolvedEndogenousProbeFluorophore,resolvedProbeEmissionWavelength,resolvedProbeExcitationWavelength,resolvedEndogenousProbeEmissionWavelength,
						resolvedEndogenousProbeExcitationWavelength,resolvedForwardPrimerVolume,resolvedReversePrimerVolume,expandPrimerVolumeToIndexMatch, calculatedBufferVolume,
						correctedCalculatedBufferVolume,

						(* Fluorophore resolution related variables *)
						probeFluorophorePackets, probeAmplificationFluorophorePackets, expectedProbeFluorophores,	expectedProbeExcitations,	expectedProbeEmissions,
						instrumentAdjustedExpectedProbeExcitation, instrumentAdjustedExpectedProbeEmission, resolvedProbeFluorophore
					},

					(* Initialize error tracking variables to False *)
					errorVariables = {probeLengthError, probeVolumeLengthError, bufferVolumeError, probeExcitationLengthError, probeEmissionLengthError, multiplexingDuplexDyeError,
						excessiveVolumeError, bufferVolumeMismatchError, probeVolumeNoProbeError, probeExcitationNoProbeError, probeEmissionNoProbeError, forwardPrimerVolumeLengthError,
						reversePrimerVolumeLengthError, probeNoFluorophoreError, probeFluorophoreNoProbeError, probeFluorophoreLengthError,	endogenousProbeFluorophoreNoProbeError,
						endogenousProbeNoFluorophoreError, endogenousPrimersNoProbeError, invalidNullProbeVolumeError, invalidNullEndogenousForwardPrimerVolumeError,
						invalidNullEndogenousReversePrimerVolumeError, invalidNullEndogenousProbeVolumeError, duplicateProbeWavelengthError};
					Evaluate[errorVariables] = ConstantArray[False, Length[errorVariables]];

					(* These options do not need to be expanded *)
					resolvedSampleVolume=resolveAutomatic[options,SampleVolume,2 Microliter];
					resolvedEndogenousPrimerPair=Lookup[options,EndogenousPrimerPair];
					resolvedEndogenousProbe=Lookup[options,EndogenousProbe];

					(* Retain this 'has primers' boolean for now for the 'prepared plate' overload, but may handle this differently moving forward *)
					hasPrimers=MatchQ[primerPairs,Except[NullP]];
					hasEndogenousControl=MatchQ[resolvedEndogenousPrimerPair, Except[NullP]];
					hasEndogenousProbe=MatchQ[resolvedEndogenousProbe, Except[NullP]];

					(* VERY local helper to expand primer volume values for index matching if necessary
					 If the option has been half-expanded incorrectly (e.g. from a singleton to a single list), re-expand correctly
					 Clunky tacked-on third input allows for setting of correct error variable in case of index matching length issue *)
					expandPrimerVolumeToIndexMatch[optionValue_, inputToIndexMatch_List, direction:(Forward|Reverse)] := Switch[
						{SameLengthQ[optionValue, inputToIndexMatch], Length[DeleteDuplicates[optionValue]] == 1},
						(* If primer volume option doesn't match number of primer pairs but primer volume option is a constant array, just make it the right length *)
						{False, True},
							ConstantArray[First[optionValue], Length[inputToIndexMatch]],
						(* If primer volume option doesn't match number of primer pairs and primer volume option is not a constant array, leave and set correct error variable *)
						{False, False},
							(
								If[MatchQ[direction, Forward],
									forwardPrimerVolumeLengthError = True,
									reversePrimerVolumeLengthError = True
								];
								optionValue
							),
						(* In any other case, just keep the specified value *)
						_,
							optionValue
					];

					(* Resolve forward and reverse primer volumes, which are index matched to primer pairs, together:
						- Automatic depends on there being an amplification primer (resolves to Null if no primers specified for this sample)
						- Forward or reverse can resolve based on one another if only one is specified
						- User input can be specified as singletons (e.g. 2uL), singletons index-matched to input (e.g. {2uL, 2uL}, or fully listed values down to level 2 (e.g. {{2uL, 2uL}}, where
							the above examples are for a single sample with two primer pairs. ExpandIndexMatchedInputs will expand the first option to {2uL, 2uL} such that we must  *)
					{resolvedForwardPrimerVolume, resolvedReversePrimerVolume} = With[
						{specifiedFwd = Lookup[options, ForwardPrimerVolume], specifiedRev = Lookup[options, ReversePrimerVolume]},
						Switch[{specifiedFwd, specifiedRev},
							(* If forward is specified and reverse is not, expand the forward primer to match the number of pairs (if necessary) and use for both *)
							{Except[Automatic], Automatic}, ConstantArray[expandPrimerVolumeToIndexMatch[specifiedFwd, primerPairs, Forward], 2],
							(* If reverse is specified and forward is not, expand the reverse primer to match the number of pairs (if necessary) and use for both *)
							{Automatic, Except[Automatic]}, ConstantArray[expandPrimerVolumeToIndexMatch[specifiedRev, primerPairs, Reverse], 2],
							(* If both are Automatic, generate a list of default values the same length as the list of primer pairs and use for both *)
							{Automatic, Automatic},  If[hasPrimers,
									ConstantArray[ConstantArray[1 Microliter, Length[primerPairs]], 2],
									{Null,Null}
								],
							(* If both have been explicitly specified, expand them individually and use them *)
							{Except[Automatic], Except[Automatic]}, {
									expandPrimerVolumeToIndexMatch[specifiedFwd, primerPairs, Forward],
									expandPrimerVolumeToIndexMatch[specifiedRev, primerPairs, Reverse]
								}
						]
					];

					(* Error check probes and add listing if necessary. Probes are also index-matched to primer pairs as opposed to samples *)
					resolvedProbe = With[
						{specifiedProbe = Lookup[options, Probe]},
						Switch[{specifiedProbe, primerPairs},
							(* If Null, leave as-is
								Have to use ListableP[Null] in this case because mapThreadOptions will incorrectly distribute listed {Null..} to all inputs. *)
							{ListableP[Automatic], _}, Null,
							{ListableP[Null], _}, Null,
							(* If length of probes matches length of primers, use as-is *)
							_?(SameLengthQ@@#&), specifiedProbe,
							(* If both probes and primers are specified but they are not the same length, we have some work to do. *)
							Except[_?(SameLengthQ@@#&)],
								If[Length[DeleteDuplicates[specifiedProbe]] == 1,
									(* Again we have to atone for ExpandIndexMatchedInputs expanding primer-pair-index-matched options halfway.
										If Probe has been expanded to a list of identical elements that doesn't index match the number of primer pairs,
										just re-expand it into a list of that element of the appropriate length *)
									ConstantArray[First[specifiedProbe], Length[primerPairs]],
									(* If Probe is a length-mismatched list of non-identical elements, the user has actually provided invalid input.
										Surface an error, and adjust the length of the Probe option to index match *)
									(
										probeLengthError = True;
										PadRight[specifiedProbe, Length[primerPairs], First[specifiedProbe]]
									)
								]
						]
					];

					(* Set a boolean for further reference below indicating whether analyte probes will be used *)
					hasProbes=MatchQ[resolvedProbe,Except[NullP]];

					(* Error check to ensure that duplex-staining dye is not being used with multiple primer pairs *)
					If[And[MatchQ[primerPairs, {{ObjectP[], ObjectP[]}, {ObjectP[], ObjectP[]}..}], MatchQ[resolvedDuplexStainingDye, ObjectP[]]], multiplexingDuplexDyeError=True];

					(* Error check probe volumes and add listing if necessary. Probe volumes are also index-matched to primer pairs as opposed to samples *)
					resolvedProbeVolume = With[
						{specifiedProbeVolume = Lookup[options, ProbeVolume]},
						Switch[{resolvedProbe, specifiedProbeVolume},
							(* If no probes specified and probe volume is Automatic, set to Null
								Correct lists of Null from mapThreadOptions' stupidity into bare Null *)
							{Null, Automatic | ListableP[Null]}, Null,
							(* If no probes specified but probe volume is specified leave option as-is and set an error variable
								Either Automatic or ListableP[Null] counts as 'not specified'; the latter may be provided by the user or
								(much more likely) may come from ResolvedOptions when using the Template option, then get inappropriately
								expanded by mapThreadOptions because it doesn't know how to deal with primer index matched options '*)
							{Null, Except[Automatic | ListableP[Null]]},
								(
									probeVolumeNoProbeError = True;
									specifiedProbeVolume
								),
							(* If probes specified but volume specifically set to Null, leave it and set error variable *)
							{Except[Null], ListableP[Null]},
								(
									invalidNullProbeVolumeError = True;
									specifiedProbeVolume
								),
							(* If probes specified but no volume, resolve volume to 1 uL and expand to index match *)
							{Except[Null], Automatic}, ConstantArray[1 Microliter, Length[resolvedProbe]],
							(* If probes and volume both specified and volume is a singleton, expand to index match *)
							{Except[Null], VolumeP}, ConstantArray[specifiedProbeVolume, Length[resolvedProbe]],
							(* If probes and volume both specified and volume is a list, check that it index matches resolved probes *)
							{Except[Null], {VolumeP..}},
								If[!SameLengthQ[resolvedProbe, specifiedProbeVolume],
									If[Length[DeleteDuplicates[specifiedProbeVolume]] == 1,
										(* Account for ExpandIndexMatchedInputs expanding primer-pair-index-matched options halfway.
										If ProbeVolume has been expanded to a list of identical elements that doesn't index match the number of primer pairs,
										just re-expand it into a list of that element of the appropriate length *)
										ConstantArray[First[specifiedProbeVolume], Length[resolvedProbe]],
										(* If ProbeVolume is a length-mismatched list of non-identical elements, the user has actually provided invalid input.
											Surface an error, and adjust the length of the ProbeVolume option to index match *)
										(
											probeVolumeLengthError = True;
											PadRight[specifiedProbeVolume, Length[resolvedProbe], First[specifiedProbeVolume]]
										)
									],
									specifiedProbeVolume
								]
						]
					];

					(* Resolve fluorophores *)
					(* Long term plan once all required fluorophore information is being stored in Model[Molecule]:
						- If probes specified but no fluorophores, look up expected fluorophores
						- If probes and fluorophores both specified and fluorophore is a singleton, expand to index match but throw error
							if more than one probe is specified. Running multiple probes with the same labeling in the same well won't work. *)
					resolvedProbeFluorophore = With[
						{specifiedProbeFluorophore = Lookup[options, ProbeFluorophore]},
						Switch[{resolvedProbe, specifiedProbeFluorophore},
							(* If no probes specified and probe fluorophore is Automatic, set to Null
								ListableP to correct lists of Null from mapThreadOptions' mishandling into bare Null *)
							{Null, Automatic | ListableP[Null]}, Null,
							(* If no probes specified but probe fluorophore is specified leave option as-is and set an error variable
								Either Automatic or ListableP[Null] counts as 'not specified'; the latter may be provided by the user or
								(much more likely) may come from ResolvedOptions when using the Template option, then get inappropriately
								expanded by mapThreadOptions because it doesn't know how to deal with primer index matched options *)
							{Null, Except[Automatic | ListableP[Null]]},
								(
									probeFluorophoreNoProbeError = True;
									specifiedProbeFluorophore
								),
							(* If probes specified but no fluorophores, set to Null and throw an error *)
							{Except[Null], Automatic},
								(
									probeNoFluorophoreError = True;
									ConstantArray[Null, Length[resolvedProbe]]
								),
							(* If probes and fluorophores both specified and fluorophore is a singleton, expand to index match.
								All specified/resolved fluorophores will be inspected at the end of the MapThread and an error thrown if there are
								duplicate fluorophores, which this expansion will produce. *)
							{Except[Null], ObjectP[Model[Molecule]]}, ConstantArray[specifiedProbeFluorophore, Length[resolvedProbe]],
							(* If probes and fluorophore both specified and fluorophore is a list, check that it index matches resolved probes.
							 	Duplicate fluorophores will be detected at the end of the MapThread. *)
							{Except[Null], {ObjectP[Model[Molecule]]..}},
								If[!SameLengthQ[resolvedProbe, specifiedProbeFluorophore],
									(
										probeFluorophoreLengthError = True;
										PadRight[specifiedProbeFluorophore, Length[resolvedProbe], First[specifiedProbeFluorophore]]
									),
									specifiedProbeFluorophore
								]
						]
					];

					(* TODO: Would like to look up probe Ex/Em, but this requires modification of identity models to store this information *)
					(* For now, hard code values corresponding to SYBR Green and similar dyes *)
					resolvedProbeExcitationWavelength = With[
						{specifiedProbeExcitation = Lookup[options, ProbeExcitationWavelength]},
						Switch[{resolvedProbe, specifiedProbeExcitation},
							(* If no probes specified and probe excitation is Automatic, set to Null
								ListableP to correct lists of Null from mapThreadOptions' mishandling into bare Null *)
							{Null, Automatic | ListableP[Null]}, Null,
							(* If no probes specified but probe excitation is specified leave option as-is and set an error variable
								Either Automatic or ListableP[Null] counts as 'not specified'; the latter may be provided by the user or
								(much more likely) may come from ResolvedOptions when using the Template option, then get inappropriately
								expanded by mapThreadOptions because it doesn't know how to deal with primer index matched options '*)
							{Null, Except[Automatic | ListableP[Null]]},
								(
									probeExcitationNoProbeError = True;
									specifiedProbeExcitation
								),
							(* If probes specified but excitation specifically set to Null, leave it
							 	General Ex/Em pair error checking above will flag this *)
							{Except[Null], ListableP[Null]}, specifiedProbeExcitation,
							(* If probes specified but no excitation, default to 470nm and expand to index match.
							 	General duplicate Ex/Em check at end of MapThread will catch expansion of this to length >1 *)
							{Except[Null], Automatic}, ConstantArray[Quantity[470, "Nanometers"], Length[resolvedProbe]],
							(* If probes and excitation both specified and excitation is a singleton, expand to index match.
								All specified/resolved Ex/Em pairs will be inspected at the end of the MapThread and an error thrown if there are
								duplicates, which this expansion will produce. *)
							{Except[Null], DistanceP}, ConstantArray[specifiedProbeExcitation, Length[resolvedProbe]],
							(* If probes and excitation both specified and excitation is a list, check that it index matches resolved probes *)
							{Except[Null], {DistanceP..}},
								If[!SameLengthQ[resolvedProbe, specifiedProbeExcitation],
									If[Length[DeleteDuplicates[specifiedProbeExcitation]] == 1,
										(* Account for ExpandIndexMatchedInputs expanding primer-pair-index-matched options halfway.
										If ProbeExcitationWavelength has been expanded to a list of identical elements that doesn't index match the number of primer pairs,
										just re-expand it into a list of that element of the appropriate length *)
										ConstantArray[First[specifiedProbeExcitation], Length[resolvedProbe]],
										(* If ProbeExcitationWavelength is a length-mismatched list of non-identical elements, the user has actually provided invalid input.
											Surface an error, and adjust the length of the ProbeExcitationWavelength option to index match *)
										(
											probeExcitationLengthError = True;
											PadRight[specifiedProbeExcitation, Length[resolvedProbe], First[specifiedProbeExcitation]]
										)
									],
									specifiedProbeExcitation
								]
						]
					];

					resolvedProbeEmissionWavelength = With[
						{specifiedProbeEmission = Lookup[options, ProbeEmissionWavelength]},
						Switch[{resolvedProbe, specifiedProbeEmission},
							(* If no probes specified and probe emission is Automatic, set to Null
								ListableP to correct lists of Null from mapThreadOptions' mishandling into bare Null *)
							{Null, Automatic | ListableP[Null]}, Null,
							(* If no probes specified but probe emission is specified leave option as-is and set an error variable
								Either Automatic or ListableP[Null] counts as 'not specified'; the latter may be provided by the user or
								(much more likely) may come from ResolvedOptions when using the Template option, then get inappropriately
								expanded by mapThreadOptions because it doesn't know how to deal with primer index matched options '*)
							{Null, Except[Automatic]},
								(
									probeEmissionNoProbeError = True;
									specifiedProbeEmission
								),
							(* If probes specified but emission specifically set to Null, leave it
							 	General Ex/Em pair error checking above will flag this *)
							{Except[Null], ListableP[Null]}, specifiedProbeEmission,
							(* If probes specified but no emission, default to 520nm and expand to index match.
							 	General duplicate Ex/Em check at end of MapThread will catch expansion of this to length >1 *)
							{Except[Null], Automatic}, ConstantArray[Quantity[520, "Nanometers"], Length[resolvedProbe]],
							(* If probes and emission both specified and emission is a singleton, expand to index match.
								All specified/resolved Ex/Em pairs will be inspected at the end of the MapThread and an error thrown if there are
								duplicates, which this expansion will produce. *)
							{Except[Null], DistanceP}, ConstantArray[specifiedProbeEmission, Length[resolvedProbe]],
							(* If probes and emission both specified and emission is a list, check that it index matches resolved probes *)
							{Except[Null], {DistanceP..}},
								If[!SameLengthQ[resolvedProbe, specifiedProbeEmission],
									If[Length[DeleteDuplicates[specifiedProbeEmission]] == 1,
										(* Account for ExpandIndexMatchedInputs expanding primer-pair-index-matched options halfway.
										If ProbeEmissionWavelength has been expanded to a list of identical elements that doesn't index match the number of primer pairs,
										just re-expand it into a list of that element of the appropriate length *)
										ConstantArray[First[specifiedProbeEmission], Length[resolvedProbe]],
										(* If ProbeEmissionWavelength is a length-mismatched list of non-identical elements, the user has actually provided invalid input.
											Surface an error, and adjust the length of the ProbeExcitationWavelength option to index match *)
										(
											probeEmissionLengthError = True;
											PadRight[specifiedProbeEmission, Length[resolvedProbe], First[specifiedProbeEmission]]
										)
									],
									specifiedProbeEmission
								]
						]
					];


					(* straight forward resolution, automatic depends on there being an endogenous primer, and no matter what take the user input*)
					resolvedEndogenousForwardPrimerVolume=resolveAutomatic[options,EndogenousForwardPrimerVolume,hasEndogenousControl,1 Microliter, Null];
					resolvedEndogenousReversePrimerVolume=resolveAutomatic[options,EndogenousReversePrimerVolume,hasEndogenousControl,1 Microliter, Null];

					(* straight forward resolution, automatic depends on there being a probe, and no matter what take the user input*)
					resolvedEndogenousProbeVolume=resolveAutomatic[options,EndogenousProbeVolume,hasEndogenousProbe,1 Microliter, Null];

					(* resolve endogenous probe fluorophore *)
					resolvedEndogenousProbeFluorophore = With[
						{specifiedEndogenousProbeFluorophore = Lookup[options, EndogenousProbeFluorophore]},
						Switch[{resolvedEndogenousProbe, specifiedEndogenousProbeFluorophore},
							(* If no endogenous probe specified and probe fluorophore is Automatic, set to Null *)
							{Null, Automatic | ListableP[Null]}, Null,
							(* If no endogenous probe specified but probe fluorophore is specified leave option as-is and set an error variable *)
							{Null, Except[Automatic]},
								(
									endogenousProbeFluorophoreNoProbeError = True;
									specifiedEndogenousProbeFluorophore
								),
							(* If endogenous probe specified but no fluorophore, set to Null and throw an error *)
							{Except[Null], Automatic},
								(
									endogenousProbeNoFluorophoreError = True;
									Null
								),
							(* If endogenous probe and fluorophore both specified, use specified value *)
							{Except[Null], ObjectP[Model[Molecule]]}, specifiedEndogenousProbeFluorophore
						]
					];

					(* Resolve these simply, using a default value if not specified for now *)
					resolvedEndogenousProbeExcitationWavelength=resolveAutomatic[options,EndogenousProbeExcitationWavelength,hasEndogenousProbe,Quantity[470, "Nanometers"], Null];
					resolvedEndogenousProbeEmissionWavelength=resolveAutomatic[options,EndogenousProbeEmissionWavelength,hasEndogenousProbe,Quantity[520, "Nanometers"], Null];

					(* Make sure if EndogenousPrimerPair is specified, EndogneousProbe is specified.
						Since we're only allowing Endogeous Control samples to be run in multiplexed mode, they must necessarily use probes. *)
					If[And[!NullQ[resolvedEndogenousPrimerPair], NullQ[resolvedEndogenousProbe]], endogenousPrimersNoProbeError = True];

					(* add up all the volumes being added to the reaction volume so far*)
					volumeSoFar = Total[
						(* Must flatten to account for resolvedForward/ReversePrimerVolume being lists of lists *)
						Flatten[{
							resolvedSampleVolume, resolvedForwardPrimerVolume, resolvedReversePrimerVolume, resolvedEndogenousForwardPrimerVolume, resolvedEndogenousReversePrimerVolume,
							resolvedEndogenousProbeVolume, resolvedProbeVolume, resolvedMasterMixVolume, resolvedDuplexStainingDyeVolume, resolvedReferenceDyeVolume
						}]/.{Null->0 Microliter} (* Volume of any components that are not being added will obviously be 0 Microliter *)
					];

					(* make up the difference between volumeSoFar and reactionVolume so that we get the same volume in each well *)
					(* If buffer volume is less than zero (i.e., there's too much of all the other ingredients to fit in the reaction volume), set an appropriate error variable *)
					calculatedBufferVolume = resolvedReactionVolume - volumeSoFar;

					(* If calculated buffer volume is less than 0 uL, set an error variable and correct to 0 uL to avoid future errors *)
					correctedCalculatedBufferVolume = If[calculatedBufferVolume < 0 Microliter,
						(
							excessiveVolumeError = True;
							0 Microliter
						),
						calculatedBufferVolume
					];

					(* Resolve buffer volume and set error variable if BufferVolume option has been specified
						but does not match calculated buffer volume *)
					resolvedBufferVolume = With[{unresolvedBufferVolume = Lookup[options, BufferVolume]},
						Which[
							(* If BufferVolume->Automatic, use the calculated volume *)
							MatchQ[unresolvedBufferVolume, Automatic],
								correctedCalculatedBufferVolume,
							(* If BufferVolume was specified but does NOT match the calculated value, set an error variable
								NOTE: We'll compare to the uncorrected calculated buffer volume here because if someone specifies
								BufferVolume->0 Microliter and other options use excessive volume, we'll still want to throw this error*)
							And[
								MatchQ[unresolvedBufferVolume, Except[Automatic]],
								Round[unresolvedBufferVolume,1 Microliter] != Round[calculatedBufferVolume,1 Microliter]
							],
								(
									bufferVolumeMismatchError = True;
									unresolvedBufferVolume
								),
							(* Default case: BufferVolume was specified, so use the specified value *)
							True,
								unresolvedBufferVolume
						]
					];

					(* --- Error checks to make sure we haven't resolved anything illegal for this sample --- *)

					(* Flag if any volumes have been manually set to Null when their associated options are populated.
					 	This is done for ProbeVolume in the resolution logic above. *)
					invalidNullEndogenousForwardPrimerVolumeError = And[!NullQ[resolvedEndogenousPrimerPair], NullQ[resolvedEndogenousForwardPrimerVolume]];
					invalidNullEndogenousReversePrimerVolumeError = And[!NullQ[resolvedEndogenousPrimerPair], NullQ[resolvedEndogenousReversePrimerVolume]];
					invalidNullEndogenousProbeVolumeError = And[!NullQ[resolvedEndogenousProbe], NullQ[resolvedEndogenousProbeVolume]];

					(* Flag if we've resolved to the same Ex/Em pair for combined sample and endogenous probe sets *)
					duplicateProbeWavelengthError = !DuplicateFreeQ[Join[
						If[Nor[NullQ[resolvedProbeExcitationWavelength], NullQ[resolvedProbeEmissionWavelength]],
							Transpose[{resolvedProbeExcitationWavelength, resolvedProbeEmissionWavelength}],
							{}
						],
						{
							If[Nor[NullQ[resolvedEndogenousProbeExcitationWavelength], NullQ[resolvedEndogenousProbeEmissionWavelength]],
								{resolvedEndogenousProbeExcitationWavelength, resolvedEndogenousProbeEmissionWavelength},
								Nothing
							]
						}
					]];

					(* TODO: Throw errors for duplicate probes, fluorophores, ex/em pairs *)

					{
						resolvedSampleVolume,
						resolvedBufferVolume,
						resolvedEndogenousPrimerPair,
						resolvedEndogenousForwardPrimerVolume,
						resolvedEndogenousReversePrimerVolume,
						resolvedEndogenousProbe,
						resolvedEndogenousProbeVolume,
						resolvedEndogenousProbeEmissionWavelength,
						resolvedEndogenousProbeExcitationWavelength,
						resolvedEndogenousProbeFluorophore,
						resolvedForwardPrimerVolume,
						resolvedReversePrimerVolume,
						resolvedProbe,
						resolvedProbeVolume,
						resolvedProbeEmissionWavelength,
						resolvedProbeExcitationWavelength,
						resolvedProbeFluorophore,

						probeLengthError,
						probeVolumeLengthError,
						multiplexingDuplexDyeError,
						excessiveVolumeError,
						bufferVolumeMismatchError,
						probeVolumeNoProbeError,
						probeExcitationNoProbeError,
						probeEmissionNoProbeError,
						forwardPrimerVolumeLengthError,
						reversePrimerVolumeLengthError,
						probeNoFluorophoreError,
						probeFluorophoreNoProbeError,
						probeFluorophoreLengthError,
						endogenousProbeFluorophoreNoProbeError,
						endogenousProbeNoFluorophoreError,
						endogenousPrimersNoProbeError,
						invalidNullProbeVolumeError,
						invalidNullEndogenousForwardPrimerVolumeError,
						invalidNullEndogenousReversePrimerVolumeError,
						invalidNullEndogenousProbeVolumeError,
						duplicateProbeWavelengthError
					}
				]
			],{samplePackets,myResolverPrimerInputs,mapThreadFriendlyOptions}
		]
	];

	(* --- Resolve Buffer after sample indexed options because we now know whether we need it --- *)
	(* We won't need buffer ONLY if there's no buffer needed for SamplesIn AND we're not running standards *)
	resolvedBuffer=Switch[
		{Total[resolvedBufferVolumes], resolvedStandards, Lookup[roundedqPCROptions,Buffer]},
		(* Resolve to Null if buffer unspecified and neither samples nor standards need it *)
		{0 Microliter, Null, Automatic}, Null,
		(* Resolve to water if buffer unspecified but we need it for either samples or standards *)
		{GreaterP[0 Microliter], _, Automatic} | {_, Except[Null], Automatic}, Model[Sample, "Milli-Q water"],
		(* If user has specified buffer, use it *)
		{_, _, Except[Automatic]}, Lookup[roundedqPCROptions,Buffer]
	];


	(* --- Check that supplied moat options are valid --- *)
	(* This check cannot be performed until after resolution of Standards options because we
		need to know the total number of wells needed in the assay plate *)

	(* Calculate how many wells will be required in the assay plate for samples + standards *)
	numberOfAssayWells = Total[Flatten[{
		(* Replicates-expanded SamplesIn *)
		Replace[Lookup[roundedqPCROptions, NumberOfReplicates], Null->1] * Length[myResolverSampleInputs],
		(* Replicates- and dilutions-expanded standards *)
		If[!NullQ[resolvedNumberOfStandardReplicates],
			MapThread[
				(#1*#2)&,
				{resolvedNumberOfStandardReplicates, resolvedNumberOfDilutions}
			],
			(* If there are no standards, no wells are required *)
			0
		]
	}]];

	(* Do all the checks to make sure our moat options are valid *)
	(* The 'validMoat' helper attempts to account for moat conflicts based on the
		aliquot system, but that isn't relevant here since the assay plate isn't
		prepared by that system. Supply the assay plate model as the aliquot container
		model packet, and artificially replace *)
	{invalidMoatOptions,moatTests}=If[gatherTests,
		validMoat[numberOfAssayWells,assayPlateModelPacket,Join[roundedqPCROptions,Association[resolvedSamplePrepOptions]],Output->{Options,Tests},AliquotGeneratedAssayPlate->False],
		{validMoat[numberOfAssayWells,assayPlateModelPacket,Join[roundedqPCROptions,Association[resolvedSamplePrepOptions]],Output->Options,AliquotGeneratedAssayPlate->False],{}}
	];

	(* --- Resolve Moat Options after Buffer is resolved so we can reuse it if practical --- *)
	{suppliedMoatSize,suppliedMoatBuffer,suppliedMoatVolume} = Lookup[roundedqPCROptions,{MoatSize,MoatBuffer,MoatVolume}];

	impliedMoat = MatchQ[invalidMoatOptions,{}]&&MemberQ[{suppliedMoatSize,suppliedMoatBuffer,suppliedMoatVolume},Except[Null|Automatic]];

	(* Reuse buffer to save deck space and resource prep if practical *)
	defaultMoatBuffer=If[!NullQ[resolvedBuffer],
		resolvedBuffer,
		Model[Sample,"Milli-Q water"]
	];
	defaultMoatVolume=Lookup[assayPlateModelPacket,MinVolume];
	defaultMoatSize=1;

	{resolvedMoatBuffer,resolvedMoatVolume,resolvedMoatSize}=If[impliedMoat,
		{
			Replace[suppliedMoatBuffer,Automatic->defaultMoatBuffer],
			Replace[suppliedMoatVolume,Automatic->defaultMoatVolume],
			Replace[suppliedMoatSize,Automatic->defaultMoatSize]
		},
		{
			Replace[suppliedMoatBuffer,Automatic->Null],
			Replace[suppliedMoatVolume,Automatic->Null],
			Replace[suppliedMoatSize,Automatic->Null]
		}
	];


	(* === UNRESOLVABLE OPTION CHECKS === *)

	(* Local helper to do the repetitive work of generating passing/failing Tests for sample-indexed option checks *)
	(* Default to making Tests unless Warning is explicitly specified *)
	generateSampleTests[errorVariableList:{BooleanP..}, testMessage_String] := generateSampleTests[errorVariableList, testMessage, Test];
	generateSampleTests[errorVariableList:{BooleanP..}, testMessage_String, testHead:(Test|Warning)] := If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, errorVariableList];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, errorVariableList, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				testHead["For the provided samples " <> ObjectToString[failingSamples, Cache -> simulatedCache] <> ", " <> testMessage <> ":",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				testHead["For the provided samples " <> ObjectToString[passingSamples, Cache -> simulatedCache] <> ", " <> testMessage <> ":",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];


	(* --- Length of Probe option matches number of primer pairs for each input --- *)
	invalidProbeOption = If[MemberQ[probeLengthErrors, True] && messagesQ,
		(
			Message[Error::ProbeLengthError,
				ObjectToString[PickList[resolvedProbes, probeLengthErrors], Cache -> simulatedCache],
				ObjectToString[PickList[myResolverPrimerInputs, probeLengthErrors], Cache -> simulatedCache],
				ObjectToString[PickList[simulatedSamples, probeLengthErrors], Cache -> simulatedCache]
			];
			{Probe}
		),
		{}
	];

	(* Generate ProbeLength tests if probes are being used *)
	probeLengthTests = generateSampleTests[probeLengthErrors, "the number of primer sets matches the number of probes (if probes are being used)"];


	(* --- Length of ProbeVolume option matches length of probe option for each input --- *)
	invalidProbeVolumeOptions = If[MemberQ[probeVolumeLengthErrors, True] && messagesQ,
		(
			Message[
				Error::ProbeVolumeLengthError,
				ObjectToString[PickList[resolvedProbeVolumes, probeVolumeLengthErrors], Cache -> simulatedCache],
				ObjectToString[PickList[resolvedProbes, probeVolumeLengthErrors], Cache -> simulatedCache],
				ObjectToString[PickList[simulatedSamples, probeVolumeLengthErrors], Cache -> simulatedCache]
			];
			{ProbeVolume, Probe}
		),
		{}
	];

	(* Generate ProbeVolumeLength tests if probes are being used *)
	probeVolumeLengthTests = generateSampleTests[probeVolumeLengthErrors, "the number of probe volumes specified matches the number of probes (if probes are being used)"];


	(* --- Multiplexing is not requested if Probe is not specified (either explicitly or implicitly by default master mix and the absence of probes) --- *)
	(* Note: this test overlaps with one in the conflicting option checks section, but catches cases where DuplexStainingDye was not explicitly specified but
		was rather resolved to a non-Null value based on the absence of probes on a per-sample basis. *)
	invalidMultiplexingWithoutProbeOptions = If[MemberQ[multiplexingDuplexDyeErrors, True] && messagesQ,
		(
			Message[
				Error::MultiplexingWithoutProbe,
				ObjectToString[PickList[myResolverPrimerInputs, multiplexingDuplexDyeErrors], Cache -> simulatedCache],
				ObjectToString[PickList[simulatedSamples, multiplexingDuplexDyeErrors], Cache -> simulatedCache]
			];
			{Probe}
		),
		{}
	];

	(* Generate MultiplexingWithoutProbe tests if probes are being used *)
	multiplexingWithoutProbeTests = generateSampleTests[multiplexingDuplexDyeErrors, "only one primer pair is specified unless the Probe option has been provided to allow for multiplexing"];


	(* --- MeltingCurveRampRate is valid (may have resolved to an unreasonable number if MeltingCurveTime was specified) --- *)
	(* Figure out whether melting ramp rate is out of range; this should only happen if it's calculated based on start/end/time *)
	invalidMeltingRampRateQ = And[
		!NullQ[meltingCurveRampRate],
	 	Not[.002 (Celsius/Second) <= meltingCurveRampRate <= 3.4 (Celsius/Second)]
	];

	(* If MeltingCurveRampRate is out of feasible range and we are throwing messages, throw an Error *)
	meltingRampRateInvalidOptions = If[invalidMeltingRampRateQ && messagesQ,
		(
			Message[Error::CalculatedRampRateOutOfRange, meltingCurveRampRate, meltingCurveTime, meltingCurveStartTemperature, meltingCurveEndTemperature];
			{MeltingCurveRampRate, MeltingCurveTime, MeltingCurveStartTemperature, MeltingCurveEndTemperature}
		),
		{}
	];

	(* If we are gathering tests and MeltingCurveRampRate is not Null, create a passing and/or failing test with the appropriate result *)
	invalidMeltingRampRateTest = If[gatherTests && !NullQ[meltingCurveRampRate],
		Test[StringJoin["The specified or calculated melting ramp rate (", ToString[meltingCurveRampRate], ") is within the allowable range of 0.002 C/sec to 3.4 C/sec:"], invalidMeltingRampRateQ, False],
		Nothing
	];


	(* --- Total volume of all components is <= reaction volume for each input --- *)
	excessiveVolumeOptions = If[MemberQ[excessiveVolumeErrors, True] && messagesQ,
		(
			Message[Error::ExcessiveVolume,
				resolvedReactionVolume,
				ObjectToString[PickList[simulatedSamples, excessiveVolumeErrors], Cache -> simulatedCache]
			];
			{ReactionVolume}
		),
		{}
	];

	(* Generate ProbeLength tests if probes are being used *)
	excessiveVolumeTests = generateSampleTests[excessiveVolumeErrors, "the total volume of all components is less than the reaction volume"];


	(* --- Specified buffer volume matches calculated buffer volume for all inputs --- *)
	bufferVolumeMismatchOptions = If[MemberQ[bufferVolumeMismatchErrors, True] && messagesQ,
		(
			Message[Error::qPCRBufferVolumeMismatch,
				ToString[PickList[Lookup[roundedqPCROptions, BufferVolume], bufferVolumeMismatchErrors]],
				ObjectToString[PickList[simulatedSamples, bufferVolumeMismatchErrors], Cache -> simulatedCache]
			];
			{BufferVolume}
		),
		{}
	];

	(* Generate ProbeLength tests if probes are being used *)
	bufferVolumeMismatchTests = generateSampleTests[bufferVolumeMismatchErrors, "the specified BufferVolume matches the calculated buffer volume needed to fill to the specified ReactionVolume"];


	(* --- Probe volume isn't specified if probe isn't specified --- *)
	probeVolumeNoProbeOptions = If[MemberQ[probeVolumeNoProbeErrors, True] && messagesQ,
		(
			Message[Error::DependentSampleOptionMissing, ProbeVolume, Probe, ObjectToString[PickList[simulatedSamples, probeVolumeNoProbeErrors], Cache -> simulatedCache]];
			{ProbeVolume}
		),
		{}
	];

	(* Generate ProbeVolume / Probe specified together tests *)
	probeVolumeNoProbeTests = generateSampleTests[probeVolumeNoProbeErrors, "ProbeVolume is not specified unless Probe is specified"];


	(* --- Probe excitation isn't specified if probe isn't specified --- *)
	probeExcitationNoProbeOptions = If[MemberQ[probeExcitationNoProbeErrors, True] && messagesQ,
		(
			Message[Error::DependentSampleOptionMissing, ProbeExcitationWavelength, Probe, ObjectToString[PickList[simulatedSamples, probeExcitationNoProbeErrors], Cache -> simulatedCache]];
			{ProbeVolume}
		),
		{}
	];

	(* Generate ProbeExcitationWavelength / Probe specified together tests *)
	probeExcitationNoProbeTests = generateSampleTests[probeExcitationNoProbeErrors, "ProbeExcitationWavelength is not specified unless Probe is specified"];


	(* --- Probe emission isn't specified if probe isn't specified --- *)
	probeEmissionNoProbeOptions = If[MemberQ[probeEmissionNoProbeErrors, True] && messagesQ,
		(
			Message[Error::DependentSampleOptionMissing, ProbeEmissionWavelength, Probe, ObjectToString[PickList[simulatedSamples, probeEmissionNoProbeErrors], Cache -> simulatedCache]];
			{ProbeVolume}
		),
		{}
	];

	(* Generate ProbeEmissionWavelength / Probe specified together tests *)
	probeEmissionNoProbeTests = generateSampleTests[probeEmissionNoProbeErrors, "ProbeEmissionWavelength is not specified unless Probe is specified"];


	(* --- Length of ForwardPrimerVolume option matches length of primer pair input for each input --- *)
	forwardPrimerVolumeLengthOptions = If[MemberQ[forwardPrimerVolumeLengthErrors, True] && messagesQ,
		(
			Message[
				Error::PrimerVolumeLengthError,
				ObjectToString[PickList[resolvedForwardPrimerVolumes, forwardPrimerVolumeLengthErrors], Cache -> simulatedCache],
				ObjectToString[PickList[myResolverPrimerInputs, forwardPrimerVolumeLengthErrors], Cache -> simulatedCache],
				ObjectToString[PickList[simulatedSamples, forwardPrimerVolumeLengthErrors], Cache -> simulatedCache],
				ForwardPrimerVolume
			];
			{ForwardPrimerVolume}
		),
		{}
	];

	(* Generate ProbeVolumeLength tests if probes are being used *)
	forwardPrimerVolumeLengthTests = generateSampleTests[forwardPrimerVolumeLengthErrors, "the number of forward primer volumes specified matches the number of primer pairs"];


	(* --- Length of ReversePrimerVolume option matches length of primer pair input for each input --- *)
	reversePrimerVolumeLengthOptions = If[MemberQ[reversePrimerVolumeLengthErrors, True] && messagesQ,
		(
			Message[
				Error::PrimerVolumeLengthError,
				ObjectToString[PickList[resolvedReversePrimerVolumes, reversePrimerVolumeLengthErrors], Cache -> simulatedCache],
				ObjectToString[PickList[myResolverPrimerInputs, reversePrimerVolumeLengthErrors], Cache -> simulatedCache],
				ObjectToString[PickList[simulatedSamples, reversePrimerVolumeLengthErrors], Cache -> simulatedCache],
				ReversePrimerVolume
			];
			{ReversePrimerVolume}
		),
		{}
	];

	(* Generate ProbeVolumeLength tests if probes are being used *)
	reversePrimerVolumeLengthTests = generateSampleTests[reversePrimerVolumeLengthErrors, "the number of reverse primer volumes specified matches the number of primer pairs"];


	(* --- Probe fluorophore isn't specified if probe isn't specified --- *)
	probeFluorophoreNoProbeOptions = If[MemberQ[probeFluorophoreNoProbeErrors, True] && messagesQ,
		(
			Message[Error::DependentSampleOptionMissing, ProbeFluorophore, Probe, ObjectToString[PickList[simulatedSamples, probeFluorophoreNoProbeErrors], Cache -> simulatedCache]];
			{ProbeFluorophore}
		),
		{}
	];

	(* Generate ProbeFluorophore / Probe specified together tests *)
	probeFluorophoreNoProbeTests = generateSampleTests[probeFluorophoreNoProbeErrors, "ProbeFluorophore is not specified unless Probe is specified"];


	(* --- EndogenousProbeFluorophore isn't specified if EndogenousProbe isn't specified --- *)
	endogenousProbeFluorophoreNoProbeOptions = If[MemberQ[endogenousProbeFluorophoreNoProbeErrors, True] && messagesQ,
		(
			Message[Error::DependentSampleOptionMissing, EndogenousProbeFluorophore, EndogenousProbe, ObjectToString[PickList[simulatedSamples, endogenousProbeFluorophoreNoProbeErrors], Cache -> simulatedCache]];
			{EndogenousProbeFluorophore}
		),
		{}
	];

	(* Generate EndogenousProbeFluorophore / EndogenousProbe specified together tests *)
	endogenousProbeFluorophoreNoProbeTests = generateSampleTests[endogenousProbeFluorophoreNoProbeErrors, "EndogenousProbeFluorophore is not specified unless EndogenousProbe is specified"];


	(* --- Probe isn't specified if ProbeFluorophore isn't specified --- *)
	probeNoFluorophoreOptions = If[MemberQ[probeNoFluorophoreErrors, True] && messagesQ,
		(
			Message[Error::DependentSampleOptionMissing, Probe, ProbeFluorophore, ObjectToString[PickList[simulatedSamples, probeNoFluorophoreErrors], Cache -> simulatedCache]];
			{Probe}
		),
		{}
	];

	(* Generate ProbeFluorophore / Probe specified together tests *)
	probeNoFluorophoreTests = generateSampleTests[probeNoFluorophoreErrors, "ProbeFluorophore is specified if Probe is specified"];


	(* --- EndogenousProbe isn't specified if EndogenousProbeFluorophore isn't specified --- *)
	endogenousProbeNoFluorophoreOptions = If[MemberQ[endogenousProbeNoFluorophoreErrors, True] && messagesQ,
		(
			Message[Error::DependentSampleOptionMissing, EndogenousProbe, EndogenousProbeFluorophore, ObjectToString[PickList[simulatedSamples, endogenousProbeNoFluorophoreErrors], Cache -> simulatedCache]];
			{EndogenousProbeFluorophore}
		),
		{}
	];

	(* Generate EndogenousProbeFluorophore / EndogenousProbe specified together tests *)
	endogenousProbeNoFluorophoreTests = generateSampleTests[endogenousProbeNoFluorophoreErrors, "EndogenousProbeFluorophore is specified if EndogenousProbe is specified"];


	(* --- Length of ProbeVolume option matches length of probe option for each input --- *)
	probeFluorophoreLengthOptions = If[MemberQ[probeFluorophoreLengthErrors, True] && messagesQ,
		(
			Message[
				Error::ProbeFluorophoreLengthError,
				ObjectToString[PickList[resolvedProbeFluorophores, probeFluorophoreLengthErrors], Cache -> simulatedCache],
				ObjectToString[PickList[resolvedProbes, probeFluorophoreLengthErrors], Cache -> simulatedCache],
				ObjectToString[PickList[simulatedSamples, probeFluorophoreLengthErrors], Cache -> simulatedCache]
			];
			{ProbeFluorophore, Probe}
		),
		{}
	];

	(* Generate ProbeVolumeLength tests if probes are being used *)
	probeFluorophoreLengthTests = generateSampleTests[probeFluorophoreLengthErrors, "the number of probe fluorophores specified matches the number of probes (if probes are being used)"];


	(* --- EndogenousPrimerPair isn't specified without EndogenousProbe --- *)
	endogenousPrimersNoProbeOptions = If[MemberQ[endogenousPrimersNoProbeErrors, True] && messagesQ,
		(
			Message[Error::EndogenousPrimersWithoutProbe, ObjectToString[PickList[simulatedSamples, endogenousPrimersNoProbeErrors], Cache -> simulatedCache]];
			{EndogenousPrimerPair, EndogenousProbe}
		),
		{}
	];

	(* Generate EndogenousControl only specified with EndogenousProbe tests *)
	endogenousPrimersNoProbeTests = generateSampleTests[endogenousPrimersNoProbeErrors, "EndogenousPrimerPair is not specified unless EndogenousProbe is also specified"];


	(* --- ProbeVolume is not Null if Probe is specified --- *)
	invalidNullProbeVolumeOptions = If[MemberQ[invalidNullProbeVolumeErrors, True] && messagesQ,
		(
			Message[Error::NullSampleVolume, Probe, ProbeVolume, ObjectToString[PickList[simulatedSamples, invalidNullProbeVolumeErrors], Cache -> simulatedCache]];
			{ProbeVolume}
		),
		{}
	];

	(* Generate ProbeVolume is not Null if Probe is specified tests *)
	invalidNullProbeVolumeTests = generateSampleTests[invalidNullProbeVolumeErrors, "ProbeVolume is not Null if Probe is specified"];


	(* --- EndogenousForwardPrimerVolume is not Null if EndogenousPrimerPair is specified --- *)
	invalidNullEndogenousForwardPrimerVolumeOptions = If[MemberQ[invalidNullEndogenousForwardPrimerVolumeErrors, True] && messagesQ,
		(
			Message[Error::NullSampleVolume, EndogenousPrimerPair, EndogenousForwardPrimerVolume, ObjectToString[PickList[simulatedSamples, invalidNullEndogenousForwardPrimerVolumeErrors], Cache -> simulatedCache]];
			{EndogenousForwardPrimerVolume}
		),
		{}
	];

	(* Generate EndogenousForwardPrimerVolume is not Null if EndogenousPrimerPair is specified tests *)
	invalidNullEndogenousForwardPrimerVolumeTests = generateSampleTests[invalidNullEndogenousForwardPrimerVolumeErrors, "EndogenousForwardPrimerVolume is not Null if EndogenousPrimerPair is specified"];


	(* --- EndogenousReversePrimerVolume is not Null if EndogenousPrimerPair is specified --- *)
	invalidNullEndogenousReversePrimerVolumeOptions = If[MemberQ[invalidNullEndogenousReversePrimerVolumeErrors, True] && messagesQ,
		(
			Message[Error::NullSampleVolume, EndogenousPrimerPair, EndogenousReversePrimerVolume, ObjectToString[PickList[simulatedSamples, invalidNullEndogenousReversePrimerVolumeErrors], Cache -> simulatedCache]];
			{EndogenousReversePrimerVolume}
		),
		{}
	];

	(* Generate EndogenousControl only specified with EndogenousProbe tests *)
	invalidNullEndogenousReversePrimerVolumeTests = generateSampleTests[invalidNullEndogenousReversePrimerVolumeErrors, "EndogenousReversePrimerVolume is not Null if EndogenousPrimerPair is specified"];


	(* --- EndogenousProbeVolume is not Null if EndogenousProbe is specified --- *)
	invalidNullEndogenousProbeVolumeOptions = If[MemberQ[invalidNullEndogenousProbeVolumeErrors, True] && messagesQ,
		(
			Message[Error::NullSampleVolume, EndogenousProbe, EndogenousProbeVolume, ObjectToString[PickList[simulatedSamples, invalidNullEndogenousProbeVolumeErrors], Cache -> simulatedCache]];
			{EndogenousProbeVolume}
		),
		{}
	];

	(* Generate EndogenousControl only specified with EndogenousProbe tests *)
	invalidNullEndogenousProbeVolumeTests = generateSampleTests[invalidNullEndogenousProbeVolumeErrors, "EndogenousProbeVolume is not Null if EndogenousProbe is specified"];


	(* --- No Ex/Em pairs are duplicated within a given well --- *)
	duplicateProbeWavelengthOptions = If[MemberQ[duplicateProbeWavelengthErrors, True] && messagesQ,
		(
			Message[Error::DuplicateProbeWavelength, ObjectToString[PickList[simulatedSamples, duplicateProbeWavelengthErrors], Cache -> simulatedCache]];
			{ProbeExcitationWavelength, ProbeEmissionWavelength, EndogenousProbeExcitationWavelength, EndogenousProbeEmissionWavelength}
		),
		{}
	];

	(* Generate No Ex/Em pairs are duplicated within a given well tests *)
	duplicateProbeWavelengthTests = generateSampleTests[duplicateProbeWavelengthErrors, "no Excitation/Emission pairs are duplicated:"];

	(* --- Make sure that the ForwardPrimerStorageCondition is the same length as the primer set -- *)
	(* Note that myResoverPrimerInputs are required inputs and cannot be Null at this moment. Keep the Null primer input check here incase we allow sample input only in the future. *)
	invalidForwardPrimerStorageConditionResult=MapThread[
		Function[{option, storageCondition, index},
			Which[
				MatchQ[option, Null] && !MatchQ[storageCondition, Null],
				index,
				(* Singleton storage condition is always valid as we can expand it *)
				MatchQ[storageCondition,SampleStorageTypeP|Disposal|Null],
				Nothing,
				(* If the length of primers does not match the length of storage conditions, there is an error *)
				Length[option] != Length[storageCondition],
				index,
				True,
				Nothing
			]
		],
		{myResolverPrimerInputs, Lookup[myOptions, ForwardPrimerStorageCondition], Range[Length[myResolverPrimerInputs]]}
	];

	If[Length[invalidForwardPrimerStorageConditionResult]>0 && messagesQ,
		Message[
			Error::ForwardPrimerStorageConditionnMismatch,
			invalidForwardPrimerStorageConditionResult
		]
	];

	forwardPrimerStorageConditionTest=If[Length[invalidForwardPrimerStorageConditionResult]>0,
		Test["If the ForwardPrimerStorageCondition option is given, it matches the number of provided primer pairs:",True,False],
		Test["If the ForwardPrimerStorageCondition option is given, it matches the number of provided primer pairs:",True,True]
	];

	(* Make an expanded list of storage conditions to match the length of primers. To avoid error in length, replace with all Null when a wrong length is given *)
	expandedForwardPrimerStorageConditions=MapThread[
		Which[
			MatchQ[#2,SampleStorageTypeP|Disposal|Null],
			ConstantArray[#2,Length[#1]],
			Length[#1]!=Length[#2],
			ConstantArray[Null,Length[#1]],
			True,
			#2
		]&,
		{myResolverPrimerInputs, Lookup[myOptions, ForwardPrimerStorageCondition]}
	];

	(* --- Make sure that the ReversePrimerStorageCondition is the same length as the primer set -- *)
	(* Note that myResoverPrimerInputs are required inputs and cannot be Null at this moment. Keep the Null primer input check here incase we allow sample input only in the future. *)
	invalidReversePrimerStorageConditionResult=MapThread[
		Function[{option, storageCondition, index},
			Which[
				MatchQ[option, Null] && !MatchQ[storageCondition, Null],
				index,
				(* Singleton storage condition is always valid as we can expand it *)
				MatchQ[storageCondition,SampleStorageTypeP|Disposal|Null],
				Nothing,
				(* If the length of primers does not match the length of storage conditions, there is an error *)
				Length[option] != Length[storageCondition],
				index,
				True,
				Nothing
			]
		],
		{myResolverPrimerInputs, Lookup[myOptions, ReversePrimerStorageCondition], Range[Length[myResolverPrimerInputs]]}
	];

	If[Length[invalidReversePrimerStorageConditionResult]>0 && messagesQ,
		Message[
			Error::ReversePrimerStorageConditionnMismatch,
			invalidReversePrimerStorageConditionResult
		]
	];

	reversePrimerStorageConditionTest=If[Length[invalidReversePrimerStorageConditionResult]>0,
		Test["If the ReversePrimerStorageConditions option is given, ReversePrimer is not Null:",True,False],
		Test["If the ReversePrimerStorageConditions option is given, ReversePrimer is not Null:",True,True]
	];

	(* Make an expanded list of storage conditions to match the length of primers *)
	expandedReversePrimerStorageConditions=MapThread[
		Which[
			MatchQ[#2,SampleStorageTypeP|Disposal|Null],
			ConstantArray[#2,Length[#1]],
			Length[#1]!=Length[#2],
			ConstantArray[Null,Length[#1]],
			True,
			#2
		]&,
		{myResolverPrimerInputs, Lookup[myOptions, ReversePrimerStorageCondition]}
	];

	(* --- Make sure that no ProbeStorageConditions options are given if Probe is Null. -- *)
	invalidProbeStorageConditionResult=MapThread[
		Function[{option, storageCondition, index},
			Which[
				(* When we don't have a probe, we should not have storage condition *)
				MatchQ[option, Null] && !MatchQ[storageCondition, Null],
				index,
				(* Singleton storage condition is always valid as we can expand it *)
				MatchQ[storageCondition,SampleStorageTypeP|Disposal|Null],
				Nothing,
				(* If the length of primers does not match the length of storage conditions, there is an error *)
				Length[option] != Length[storageCondition],
				index,
				True,
				Nothing
			]
		],
		{resolvedProbes, Lookup[myOptions, ProbeStorageCondition], Range[Length[myResolverPrimerInputs]]}
	];

	If[Length[invalidProbeStorageConditionResult]>0 && messagesQ,
		Message[
			Error::ProbeStorageConditionMismatch,
			invalidProbeStorageConditionResult
		]
	];

	probeStorageConditionTest=If[Length[invalidProbeStorageConditionResult]>0,
		Test["If the ProbeStorageConditions option is given, Probe is not Null:",True,False],
		Test["If the ProbeStorageConditions option is given, Probe is not Null:",True,True]
	];

	(* Make an expanded list of storage conditions to match the length of primers *)
	expandedProbeStorageConditions=MapThread[
		Which[
			MatchQ[#2,SampleStorageTypeP|Disposal|Null]&&Length[#1]==0,
			#2,
			MatchQ[#2,SampleStorageTypeP|Disposal|Null],
			ConstantArray[#2,Length[#1]],
			Length[#2]!=Length[#1],
			ConstantArray[Null,Length[#1]],
			True,
			#2
		]&,
		{resolvedProbes, Lookup[myOptions, ProbeStorageCondition]}
	];

	(* --- Make sure that no StandardStorageConditions options are given if Standard is Null. -- *)
	invalidStandardStorageConditionResult=If[NullQ[resolvedStandards],
		If[NullQ[Lookup[myOptions, StandardStorageCondition]],
			{},
			{1}
		],
		(* Standard should not have Null member anyway but keep this test here just in case *)
		MapThread[
			Function[{option, storageCondition, index},
				If[MatchQ[option, Null] && !MatchQ[storageCondition, Null],
					index,
					Nothing
				]
			],
			{resolvedStandards, ToList[Lookup[myOptions, StandardStorageCondition]], Range[Length[resolvedStandards]]}
		]
	];

	If[Length[invalidStandardStorageConditionResult]>0 && messagesQ,
		Message[Error::StandardStorageConditionMismatch]
	];

	standardStorageConditionTest=If[Length[invalidStandardStorageConditionResult]>0,
		Test["If the StandardStorageCondition option is given, Standard is not Null:",True,False],
		Test["If the StandardStorageCondition option is given, Standard is not Null:",True,True]
	];

	(* --- Make sure that no StandardForwardPrimerStorageCondition  options are given if StandardPrimerPair is Null. -- *)
	invalidStandardForwardPrimerStorageConditionResult=If[NullQ[resolvedStandards],
		If[NullQ[Lookup[myOptions, StandardForwardPrimerStorageCondition]],
			{},
			{1}
		],
		(* StandardPrimerPairs should not be Null for a Standard but keep this test here just in case *)
		MapThread[
			Function[{option, storageCondition, index},
				If[MatchQ[option, Null] && !MatchQ[storageCondition, Null],
					index,
					Nothing
				]
			],
			{resolvedStandardPrimerPairs, ToList[Lookup[myOptions, StandardForwardPrimerStorageCondition]], Range[Length[resolvedStandardPrimerPairs]]}
		]
	];

	If[Length[invalidStandardForwardPrimerStorageConditionResult]>0 && messagesQ,
		Message[
			Error::StandardForwardPrimerStorageConditionMismatch,
			invalidStandardForwardPrimerStorageConditionResult
		]
	];

	standardForwardPrimerStorageConditionTest=If[Length[invalidStandardForwardPrimerStorageConditionResult]>0,
		Test["If the StandardForwardPrimerStorageCondition option is given, StandardPrimerPair is not Null:",True,False],
		Test["If the StandardForwardPrimerStorageCondition option is given, StandardPrimerPair is not Null:",True,True]
	];

	(* --- Make sure that no StandardReversePrimerStorageCondition  options are given if StandardPrimerPair is Null. -- *)
	invalidStandardReversePrimerStorageConditionResult=If[NullQ[resolvedStandards],
		If[NullQ[Lookup[myOptions, StandardReversePrimerStorageCondition]],
			{},
			{1}
		],
		(* StandardPrimerPairs should not be Null for a Standard but keep this test here just in case *)
		MapThread[
			Function[{option, storageCondition, index},
				If[MatchQ[option, Null] && !MatchQ[storageCondition, Null],
					index,
					Nothing
				]
			],
			{resolvedStandardPrimerPairs, ToList[Lookup[myOptions, StandardReversePrimerStorageCondition]], Range[Length[resolvedStandardPrimerPairs]]}
		]
	];

	If[Length[invalidStandardReversePrimerStorageConditionResult]>0 && messagesQ,
		Message[
			Error::StandardReversePrimerStorageConditionMismatch,
			invalidStandardReversePrimerStorageConditionResult
		]
	];

	standardReversePrimerStorageConditionTest=If[Length[invalidStandardReversePrimerStorageConditionResult]>0,
		Test["If the StandardReversePrimerStorageCondition option is given, StandardPrimerPair is not Null:",True,False],
		Test["If the StandardReversePrimerStorageCondition option is given, StandardPrimerPair is not Null:",True,True]
	];

	(* --- Make sure that no StandardProbeStorageCondition  options are given if StandardProbe is Null. -- *)
	invalidStandardProbeStorageConditionResult=If[NullQ[resolvedStandards],
		If[NullQ[Lookup[myOptions, StandardProbeStorageCondition]],
			{},
			{1}
		],
		MapThread[
			Function[{option, storageCondition, index},
				If[MatchQ[option, Null] && !MatchQ[storageCondition, Null],
					index,
					Nothing
				]
			],
			{resolvedStandardProbes, ToList[Lookup[myOptions, StandardProbeStorageCondition]], Range[Length[resolvedStandardProbes]]}
		]
	];

	If[Length[invalidStandardProbeStorageConditionResult]>0 && messagesQ,
		Message[
			Error::StandardProbeStorageConditionMismatch,
			invalidStandardProbeStorageConditionResult
		]
	];

	standardProbeStorageConditionTest=If[Length[invalidStandardProbeStorageConditionResult]>0,
		Test["If the StandardProbeStorageCondition option is given, StandardProbe is not Null:",True,False],
		Test["If the StandardProbeStorageCondition option is given, StandardProbe is not Null:",True,True]
	];


	(* --- Make sure that no EndogenousForwardPrimerStorageCondition  options are given if EndogenousPrimerPair is Null. -- *)
	invalidEndogenousForwardPrimerStorageConditionResult=MapThread[
		Function[{option, storageCondition, index},
			If[MatchQ[option, Null] && !MatchQ[storageCondition, Null],
				index,
				Nothing
			]
		],
		{resolvedEndogenousPrimerPairs, Lookup[myOptions, EndogenousForwardPrimerStorageCondition], Range[Length[resolvedEndogenousPrimerPairs]]}
	];

	If[Length[invalidEndogenousForwardPrimerStorageConditionResult]>0 && messagesQ,
		Message[
			Error::EndogenousForwardPrimerStorageConditionMismatch,
			invalidEndogenousForwardPrimerStorageConditionResult
		]
	];

	EndogenousForwardPrimerStorageConditionTest=If[Length[invalidEndogenousForwardPrimerStorageConditionResult]>0,
		Test["If the EndogenousForwardPrimerStorageCondition option is given, EndogenousPrimerPair is not Null:",True,False],
		Test["If the EndogenousForwardPrimerStorageCondition option is given, EndogenousPrimerPair is not Null:",True,True]
	];

	(* --- Make sure that no EndogenousReversePrimerStorageCondition  options are given if EndogenousPrimerPair is Null. -- *)
	invalidEndogenousReversePrimerStorageConditionResult=MapThread[
		Function[{option, storageCondition, index},
			If[MatchQ[option, Null] && !MatchQ[storageCondition, Null],
				index,
				Nothing
			]
		],
		{resolvedEndogenousPrimerPairs, Lookup[myOptions, EndogenousReversePrimerStorageCondition], Range[Length[resolvedEndogenousPrimerPairs]]}
	];

	If[Length[invalidEndogenousReversePrimerStorageConditionResult]>0 && messagesQ,
		Message[
			Error::EndogenousReversePrimerStorageConditionMismatch,
			invalidEndogenousReversePrimerStorageConditionResult
		]
	];

	EndogenousReversePrimerStorageConditionTest=If[Length[invalidEndogenousReversePrimerStorageConditionResult]>0,
		Test["If the EndogenousReversePrimerStorageCondition option is given, EndogenousPrimerPair is not Null:",True,False],
		Test["If the EndogenousReversePrimerStorageCondition option is given, EndogenousPrimerPair is not Null:",True,True]
	];

	(* --- Make sure that no EndogenousProbeStorageCondition  options are given if EndogenousProbe is Null. -- *)
	invalidEndogenousProbeStorageConditionResult=MapThread[
		Function[{option, storageCondition, index},
			If[MatchQ[option, Null] && !MatchQ[storageCondition, Null],
				index,
				Nothing
			]
		],
		{resolvedEndogenousProbes, Lookup[myOptions, EndogenousProbeStorageCondition], Range[Length[resolvedEndogenousProbes]]}
	];

	If[Length[invalidEndogenousProbeStorageConditionResult]>0 && messagesQ,
		Message[
			Error::EndogenousProbeStorageConditionMismatch,
			invalidEndogenousProbeStorageConditionResult
		]
	];

	EndogenousProbeStorageConditionTest=If[Length[invalidEndogenousProbeStorageConditionResult]>0,
		Test["If the EndogenousProbeStorageCondition option is given, EndogenousProbe is not Null:",True,False],
		Test["If the EndogenousProbeStorageCondition option is given, EndogenousProbe is not Null:",True,True]
	];

	(* Check that our Samples, Primers and Probes don't have conflicting storage conditions when used in multiple places  *)

	allPrimerProbesWithStorageConditions=MapThread[
		{#1,#2}&,
		{
			Flatten[
				{
					simulatedSamples,
					Flatten[myResolverPrimerInputs[[All, All, 1]]],
					Flatten[myResolverPrimerInputs[[All, All, 2]]],
					Flatten[resolvedProbes],
					ToList[resolvedStandards],
					(* Primers may not be expanded *)
					If[MatchQ[resolvedStandardPrimerPairs,Null|{Null}],
						{Null},
						resolvedStandardPrimerPairs[[All,1]]
					],
					If[MatchQ[resolvedStandardPrimerPairs,Null|{Null}],
						{Null},
						resolvedStandardPrimerPairs[[All,2]]
					],
					ToList[resolvedStandardProbes],
					Which[
						MatchQ[resolvedEndogenousPrimerPairs,{Null,Null}],
						{Null,Null},
						MatchQ[resolvedEndogenousPrimerPairs,{Null..}],
						resolvedEndogenousPrimerPairs,
						True,
						resolvedEndogenousPrimerPairs[[All,1]]
					],
					Which[
						MatchQ[resolvedEndogenousPrimerPairs,{Null,Null}],
						{Null,Null},
						MatchQ[resolvedEndogenousPrimerPairs,{Null..}],
						resolvedEndogenousPrimerPairs,
						True,
						resolvedEndogenousPrimerPairs[[All,2]]
					],
					resolvedEndogenousProbes
				}
			],
			Flatten[
				{
					Lookup[myOptions, SamplesInStorageCondition],
					Flatten[expandedForwardPrimerStorageConditions],
					Flatten[expandedReversePrimerStorageConditions],
					Flatten[expandedProbeStorageConditions],
					ToList[Lookup[myOptions, StandardStorageCondition]],
					ToList[Lookup[myOptions, StandardForwardPrimerStorageCondition]],
					ToList[Lookup[myOptions, StandardReversePrimerStorageCondition]],
					ToList[Lookup[myOptions, StandardProbeStorageCondition]],
					Lookup[myOptions, EndogenousForwardPrimerStorageCondition],
					Lookup[myOptions, EndogenousReversePrimerStorageCondition],
					Lookup[myOptions, EndogenousProbeStorageCondition]
				}
			]
		}
	];

	(* Check that no conlict storage conditions have been given to the same objects *)
	(* Delete Null samples, this is possible for cases without standard or endogeneous primers and probes *)
	(* Also delete Null storage conditions as we can use the specified conditions *)
	uniqueSamplesWithStorageConditions=Map[
		DeleteDuplicates[DeleteCases[#,{Null,_}|{_,Null}]]&,
		GatherBy[allPrimerProbesWithStorageConditions,First]
	];

	conflictSamplesWithStorageConditions=Map[
		If[Length[#]>1,
			#[[1,1]],
			Nothing
		]&,
		uniqueSamplesWithStorageConditions
	];

	(* Throw an error message when we find the storage condition conflict and add the related options *)

	conflictSampleStorageOptions=MapThread[
		If[MatchQ[Intersection[Flatten[ToList[#1]],conflictSamplesWithStorageConditions],{}],
			Nothing,
			#2
		]&,
		{
			{
				simulatedSamples,
				Flatten[myResolverPrimerInputs[[All, All, 1]]],
				Flatten[myResolverPrimerInputs[[All, All, 2]]],
				Flatten[resolvedProbes],
				ToList[resolvedStandards],
				(* Primers may not be expanded *)
				If[MatchQ[resolvedStandardPrimerPairs,Null|{Null}],
					{Null},
					resolvedStandardPrimerPairs[[All,1]]
				],
				If[MatchQ[resolvedStandardPrimerPairs,Null|{Null}],
					{Null},
					resolvedStandardPrimerPairs[[All,2]]
				],
				ToList[resolvedStandardProbes],
				Which[
					MatchQ[resolvedEndogenousPrimerPairs,{Null,Null}],
					{Null,Null},
					MatchQ[resolvedEndogenousPrimerPairs,{Null..}],
					resolvedEndogenousPrimerPairs,
					True,
					resolvedEndogenousPrimerPairs[[All,1]]
				],
				Which[
					MatchQ[resolvedEndogenousPrimerPairs,{Null,Null}],
					{Null,Null},
					MatchQ[resolvedEndogenousPrimerPairs,{Null..}],
					resolvedEndogenousPrimerPairs,
					True,
					resolvedEndogenousPrimerPairs[[All,2]]
				],
				resolvedEndogenousProbes
			},
			{
				SamplesInStorageCondition,
				ForwardPrimerStorageCondition,
				ReversePrimerStorageCondition,
				ProbeStorageCondition,
				StandardStorageCondition,
				StandardForwardPrimerStorageCondition,
				StandardReversePrimerStorageCondition,
				StandardProbeStorageCondition,
				EndogenousForwardPrimerStorageCondition,
				EndogenousReversePrimerStorageCondition,
				EndogenousProbeStorageCondition
			}
		}
	];

	If[Length[conflictSamplesWithStorageConditions]>0,
		Message[Error::QPCRConflictingStorageConditions,ObjectToString[conflictSamplesWithStorageConditions,Cache->simulatedCache],ToString[conflictSampleStorageOptions]]
	];

	conflictSampleStorageConditionTest=Test["The same sample object should not be given different storage conditions in SamplesInStorageCondition, StandardStorageCondition and SpikeSampleStorageCondition if it is used more than once.",MatchQ[conflictSampleStorageOptions,{}],True];

	(* -- SAMPLES IN STORAGE CONDITION -- *)

	(* determine if incompatible storage conditions have been specified for samples in the same container *)

	(* this will throw errors if needed *)
	samplesForContainerStorageCheck=DeleteCases[Cases[allPrimerProbesWithStorageConditions,{ObjectP[Object],_}],{ObjectP[discardedInvalidInputs],_}][[All,1]];
	storageConditionsForContainerStorageCheck=DeleteCases[Cases[allPrimerProbesWithStorageConditions,{ObjectP[Object],_}],{ObjectP[discardedInvalidInputs],_}][[All,2]];
	{validSamplesInStorageConditionBools, validSamplesInStorageConditionTests} = Quiet[
		If[gatherTests,
			ValidContainerStorageConditionQ[samplesForContainerStorageCheck, storageConditionsForContainerStorageCheck, Output -> {Result, Tests}, Cache ->simulatedCache],
			{ValidContainerStorageConditionQ[samplesForContainerStorageCheck, storageConditionsForContainerStorageCheck, Output -> Result, Cache ->simulatedCache], {}}
		],
		Download::MissingCacheField
	];

	(* convert to a single boolean *)
	storageContainerInvalidSamples = PickList[samplesForContainerStorageCheck,ToList[validSamplesInStorageConditionBools],False];

	(* collect the bad option to add to invalid options later *)
	invalidContainerSampleStorageOptions=MapThread[
		If[MatchQ[Intersection[Flatten[ToList[#1]],storageContainerInvalidSamples],{}],
			Nothing,
			#2
		]&,
		{
			{
				simulatedSamples,
				Flatten[myResolverPrimerInputs[[All, All, 1]]],
				Flatten[myResolverPrimerInputs[[All, All, 2]]],
				Flatten[resolvedProbes],
				ToList[resolvedStandards],
				(* Primers may not be expanded *)
				If[MatchQ[resolvedStandardPrimerPairs,Null|{Null}],
					{Null},
					resolvedStandardPrimerPairs[[All,1]]
				],
				If[MatchQ[resolvedStandardPrimerPairs,Null|{Null}],
					{Null},
					resolvedStandardPrimerPairs[[All,2]]
				],
				ToList[resolvedStandardProbes],
				(* Primers may not be expanded *)
				Which[
					MatchQ[resolvedEndogenousPrimerPairs,{Null,Null}],
					{Null,Null},
					MatchQ[resolvedEndogenousPrimerPairs,{Null..}],
					resolvedEndogenousPrimerPairs,
					True,
					resolvedEndogenousPrimerPairs[[All,1]]
				],
				Which[
					MatchQ[resolvedEndogenousPrimerPairs,{Null,Null}],
					{Null,Null},
					MatchQ[resolvedEndogenousPrimerPairs,{Null..}],
					resolvedEndogenousPrimerPairs,
					True,
					resolvedEndogenousPrimerPairs[[All,2]]
				],
				resolvedEndogenousProbes
			},
			{
				SamplesInStorageCondition,
				ForwardPrimerStorageCondition,
				ReversePrimerStorageCondition,
				ProbeStorageCondition,
				StandardStorageCondition,
				StandardForwardPrimerStorageCondition,
				StandardReversePrimerStorageCondition,
				StandardProbeStorageCondition,
				EndogenousForwardPrimerStorageCondition,
				EndogenousReversePrimerStorageCondition,
				EndogenousProbeStorageCondition
			}
		}
	];


	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{
		nameInvalidOptions,
		invalidDuplexStainingDyeSingleplexOptions,
		invalidProbeSpecifiedDuplexStainingDyeNullOptions,
		invalidDuplexStainingDyeExcitationEmissionPairOptions,
		invalidReferenceDyeExcitationEmissionPairOptions,
		invalidProbeExcitationEmissionPairOptions,
		invalidStandardProbeExcitationEmissionPairOptions,
		invalidEndogenousProbeExcitationEmissionPairOptions,
		meltingRampRateInvalidOptions,
		standardPrimerInvalidOptions,
		invalidProbeOption,
		invalidProbeVolumeOptions,
		invalidMultiplexingWithoutProbeOptions,
		excessiveVolumeOptions,
		bufferVolumeMismatchOptions,
		probeVolumeNoProbeOptions,
		probeExcitationNoProbeOptions,
		probeEmissionNoProbeOptions,
		standardRelatedOptionInvalidOptions,
		standardProbeRelatedOptionInvalidOptions,
		forwardPrimerVolumeLengthOptions,
		reversePrimerVolumeLengthOptions,
		invalidDyeOptions,
		probeNoFluorophoreOptions,
		probeFluorophoreNoProbeOptions,
		probeFluorophoreLengthOptions,
		endogenousProbeFluorophoreNoProbeOptions,
		endogenousProbeNoFluorophoreOptions,
		invalidMeltEndpointsOptions,
		invalidThermocyclerOptions,
		rtInvalidOptions,
		activationInvalidOptions,
		annealingInvalidOptions,
		meltingCurveInvalidOptions,
		endogenousPrimersNoProbeOptions,
		invalidNullStandardForwardPrimerOptions,
		invalidNullStandardReversePrimerOptions,
		invalidNullStandardProbeVolumeOptions,
		invalidNullProbeVolumeOptions,
		invalidNullEndogenousForwardPrimerVolumeOptions,
		invalidNullEndogenousReversePrimerVolumeOptions,
		invalidNullEndogenousProbeVolumeOptions,
		duplicateProbeWavelengthOptions,
		If[Length[invalidForwardPrimerStorageConditionResult]>0,
			{ForwardPrimerStorageCondition},
			{}
		],
		If[Length[invalidReversePrimerStorageConditionResult]>0,
			{ReversePrimerStorageCondition},
			{}
		],
		If[Length[invalidProbeStorageConditionResult]>0,
			{ProbeStorageCondition},
			{}
		],
		If[Length[invalidStandardStorageConditionResult]>0,
			{StandardStorageCondition},
			{}
		],
		If[Length[invalidStandardForwardPrimerStorageConditionResult]>0,
			{StandardForwardPrimerStorageCondition},
			{}
		],
		If[Length[invalidStandardReversePrimerStorageConditionResult]>0,
			{StandardReversePrimerStorageCondition},
			{}
		],
		If[Length[invalidStandardProbeStorageConditionResult]>0,
			{StandardProbeStorageCondition},
			{}
		],
		If[Length[invalidEndogenousForwardPrimerStorageConditionResult]>0,
			{EndogenousForwardPrimerStorageCondition},
			{}
		],
		If[Length[invalidEndogenousReversePrimerStorageConditionResult]>0,
			{EndogenousReversePrimerStorageCondition},
			{}
		],
		If[Length[invalidEndogenousProbeStorageConditionResult]>0,
			{EndogenousProbeStorageCondition},
			{}
		],
		conflictSampleStorageOptions,
		invalidContainerSampleStorageOptions,
		invalidMoatOptions

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
	(* Resolve RequiredAliquotContainers *)
	targetContainers=Null;
	(* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
	(* When you do not want an aliquot to happen for the corresopnding simulated sample, make the corresponding index of targetContainers Null. *)
	(* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		(* Note: Also include AllowSolids\[Rule]True as an option to this function if your experiment function can take solid samples as input. Otherwise, resolveAliquotOptions will throw an error if solid samples will be given as input to your function. *)
		resolveAliquotOptions[
			ExperimentqPCR,
			myResolverSampleInputs,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			Cache -> simulatedCache,
			RequiredAliquotAmounts->Null,
			RequiredAliquotContainers->targetContainers,
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentqPCR,
				myResolverSampleInputs,
				simulatedSamples,
				ReplaceRule[myOptions,resolvedSamplePrepOptions],
				Cache -> simulatedCache,
				RequiredAliquotAmounts->Null,
				RequiredAliquotContainers->targetContainers,
				Output->Result],
			{}
		}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* Rebuild options, replacing with resolved values *)
	resolvedOptions = ReplaceRule[
		Normal[roundedqPCROptions],
		Flatten[{
			{
				(* Name->Lookup[roundedqPCROptions, Name], *)
				Instrument->resolvedInstrument,

				ArrayCardStorageCondition->resolveAutomatic[roundedqPCROptions,ArrayCardStorageCondition,Null],
				AssayPlateStorageCondition->resolveAutomatic[roundedqPCROptions,AssayPlateStorageCondition,Disposal],

				SampleVolume->resolvedSampleVolumes,
				ReactionVolume->resolvedReactionVolume,

				MasterMix->resolvedMasterMix,
				MasterMixVolume->resolvedMasterMixVolume,

				Buffer->resolvedBuffer,
				BufferVolume->resolvedBufferVolumes,

				MoatSize->resolvedMoatSize,
				MoatBuffer->resolvedMoatBuffer,
				MoatVolume->resolvedMoatVolume,

				ReverseTranscription->resolvedReverseTranscription,
				ReverseTranscriptionTime->resolvedTranscriptionTime,
				ReverseTranscriptionTemperature->resolvedTranscriptionTemperature,
				ReverseTranscriptionRampRate->resolvedTranscriptionRampRate,

				Activation->resolvedActivation,
				ActivationTime->resolvedActivationTime,
				ActivationTemperature->resolvedActivationTemperature,
				ActivationRampRate->resolvedActivationRampRate,

				DenaturationTime->resolvedDenaturationTime,
				DenaturationTemperature->resolvedDenaturationTemperature,
				DenaturationRampRate->resolvedDenaturationRampRate,

				PrimerAnnealing->resolvedAnnealing,
				PrimerAnnealingTime->resolvedAnnealingTime,
				PrimerAnnealingTemperature->resolvedAnnealingTemperature,
				PrimerAnnealingRampRate->resolvedAnnealingRampRate,

				ExtensionTime->resolvedExtensionTime,
				ExtensionTemperature->resolvedExtensionTemperature,
				ExtensionRampRate->resolvedExtensionRampRate,
				NumberOfCycles->resolvedNumberOfCycles,

				MeltingCurve->meltingCurve,
				MeltingCurveStartTemperature->meltingCurveStartTemperature,
				MeltingCurveEndTemperature->meltingCurveEndTemperature,
				PreMeltingCurveRampRate->preMeltingCurveRampRate,
				MeltingCurveRampRate->meltingCurveRampRate,
				MeltingCurveTime->meltingCurveTime,

				ForwardPrimerVolume->resolvedForwardPrimerVolumes,
				ForwardPrimerStorageCondition->Lookup[myOptions, ForwardPrimerStorageCondition],
				ReversePrimerVolume->resolvedReversePrimerVolumes,
				ReversePrimerStorageCondition->Lookup[myOptions, ReversePrimerStorageCondition],

				Probe->resolvedProbes,
				ProbeVolume->resolvedProbeVolumes,
				ProbeStorageCondition->Lookup[myOptions, ProbeStorageCondition],

				ProbeEmissionWavelength->resolvedProbeEmissionWavelengths,
				ProbeExcitationWavelength->resolvedProbeExcitationWavelengths,
				ProbeFluorophore->resolvedProbeFluorophores,

				DuplexStainingDye->resolvedDuplexStainingDye,
				DuplexStainingDyeVolume->resolvedDuplexStainingDyeVolume,
				DuplexStainingDyeExcitationWavelength->resolvedDuplexStainingDyeExcitationWavelength,
				DuplexStainingDyeEmissionWavelength->resolvedDuplexStainingDyeEmissionWavelength,

				ReferenceDye->resolvedReferenceDye,
				ReferenceDyeVolume->resolvedReferenceDyeVolume,
				ReferenceDyeExcitationWavelength->resolvedReferenceStainingDyeExcitationWavelength,
				ReferenceDyeEmissionWavelength->resolvedReferenceStainingDyeEmissionWavelength,

				Standard->resolvedStandards,
				StandardVolume->resolvedStandardVolume,
				StandardStorageCondition->Lookup[myOptions, StandardStorageCondition],

				StandardPrimerPair->resolvedStandardPrimerPairs,
				StandardForwardPrimerStorageCondition->Lookup[myOptions, StandardForwardPrimerStorageCondition],
				StandardReversePrimerStorageCondition->Lookup[myOptions, StandardReversePrimerStorageCondition],
				StandardForwardPrimerVolume->resolvedStandardForwardPrimerVolumes,
				StandardReversePrimerVolume->resolvedStandardReversePrimerVolumes,

				SerialDilutionFactor->resolvedSerialDilutionFactors,
				NumberOfDilutions->resolvedNumberOfDilutions,
				NumberOfStandardReplicates->resolvedNumberOfStandardReplicates,

				StandardProbe->resolvedStandardProbes,
				StandardProbeStorageCondition->Lookup[myOptions, StandardProbeStorageCondition],
				StandardProbeVolume->resolvedStandardProbeVolumes,

				StandardProbeEmissionWavelength->resolvedStandardProbeEmissionWavelengths,
				StandardProbeExcitationWavelength->resolvedStandardProbeExcitationWavelengths,
				StandardProbeFluorophore->resolvedStandardProbeFluorophores,

				EndogenousPrimerPair->resolvedEndogenousPrimerPairs,
				EndogenousForwardPrimerStorageCondition->Lookup[myOptions, EndogenousForwardPrimerStorageCondition],
				EndogenousReversePrimerStorageCondition->Lookup[myOptions, EndogenousReversePrimerStorageCondition],
				EndogenousForwardPrimerVolume->resolvedEndogenousForwardPrimerVolumes,
				EndogenousReversePrimerVolume->resolvedEndogenousReversePrimerVolumes,

				EndogenousProbe->resolvedEndogenousProbes,
				EndogenousProbeStorageCondition->Lookup[myOptions, EndogenousProbeStorageCondition],
				EndogenousProbeVolume->resolvedEndogenousProbeVolumes,

				EndogenousProbeEmissionWavelength->resolvedEndogenousProbeEmissionWavelengths,
				EndogenousProbeExcitationWavelength->resolvedEndogenousProbeExcitationWavelengths,
				EndogenousProbeFluorophore->resolvedEndogenousProbeFluorophores
			},
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions
		}]
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> Flatten[{
			discardedTest,
			precisionTests,
			validNameTest,
			duplexStainingDyeSingleplexTest,
			probeSpecifiedDuplexStainingDyeNullTest,
			duplexStainingDyeExcitationEmissionPairTest,
			referenceDyeExcitationEmissionPairTest,
			probeExcitationEmissionPairTest,
			standardProbeExcitationEmissionPairTest,
			endogenousProbeExcitationEmissionPairTest,
			standardPrimerPairAmongInputsTest,
			invalidMeltingRampRateTest,
			standardPrimersSpecifiedIfStandardSpecifiedTest,
			probeLengthTests,
			probeVolumeLengthTests,
			multiplexingWithoutProbeTests,
			excessiveVolumeTests,
			bufferVolumeMismatchTests,
			probeVolumeNoProbeTests,
			probeExcitationNoProbeTests,
			probeEmissionNoProbeTests,
			standardRelatedOptionTests,
			standardProbeRelatedOptionTests,
			forwardPrimerVolumeLengthTests,
			reversePrimerVolumeLengthTests,
			invalidDyeTests,
			probeNoFluorophoreTests,
			probeFluorophoreNoProbeTests,
			probeFluorophoreLengthTests,
			endogenousProbeFluorophoreNoProbeTests,
			endogenousProbeNoFluorophoreTests,
			invalidMeltEndpointsTests,
			invalidThermocyclerTests,
			rtOptionTests,
			activationOptionTests,
			annealingOptionTests,
			meltingCurveOptionTests,
			endogenousPrimersNoProbeTests,
			endogenousPrimersNoProbeTests,
			invalidNullStandardForwardPrimerTests,
			invalidNullStandardReversePrimerTests,
			invalidNullStandardProbeVolumeTests,
			invalidNullProbeVolumeTests,
			invalidNullEndogenousForwardPrimerVolumeTests,
			invalidNullEndogenousReversePrimerVolumeTests,
			invalidNullEndogenousProbeVolumeTests,
			duplicateProbeWavelengthTests,
			forwardPrimerStorageConditionTest,
			reversePrimerStorageConditionTest,
			probeStorageConditionTest,
			standardStorageConditionTest,
			standardForwardPrimerStorageConditionTest,
			standardReversePrimerStorageConditionTest,
			standardProbeStorageConditionTest,
			EndogenousForwardPrimerStorageConditionTest,
			EndogenousReversePrimerStorageConditionTest,
			EndogenousProbeStorageConditionTest,
			conflictSampleStorageConditionTest,
			validSamplesInStorageConditionTests,
			unknownMasterMixTest,
			moatTests
		}]
	}
];


(*---Array card overload---*)
resolveExperimentqPCROptions[
	myResolverSampleInputs:{ObjectP[Object[Sample]]...},
	myResolverArrayCardInput:ObjectP[Object[Container,Plate,Irregular,ArrayCard]],
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentqPCROptions]
]:=Module[
	{outputSpecification,output,gatherTests,messagesQ,cache,samplePrepOptions,qPCROptions,
		simulatedSamples,resolvedSamplePrepOptions,simulatedCache,samplePrepTests,
		qPCROptionsAssociation,samplePackets,arrayCardPacket,arrayCardModelForwardPrimersPackets,arrayCardModelReversePrimersPackets,arrayCardModelProbesPackets,
		discardedSamplePackets,discardedInvalidInputs,discardedTest,discardedArrayCardInvalidInputs,discardedArrayCardTest,
		tooManySamplesQ,tooManySamplesInvalidInputs,tooManySamplesTest,
		arrayCardContentsMismatchQ,arrayCardContentsMismatchInvalidInputs,arrayCardContentsMismatchTest,
		precisionOptions,precisionUnits,roundedqPCROptions,precisionTests,
		masterSwitchCheck,nameOption,validNameQ,nameInvalidOptions,validNameTest,
		invalidArrayCardReagentOptions,invalidArrayCardReagentOptionsTest,
		invalidArrayCardEndogenousOptions,invalidArrayCardEndogenousOptionsTest,
		invalidArrayCardStandardOptions,invalidArrayCardStandardOptionsTest,
		invalidArrayCardDuplexStainingDyeOptions,invalidArrayCardDuplexStainingDyeOptionsTest,
		invalidArrayCardMeltingCurveOptions,invalidArrayCardMeltingCurveOptionsTest,
		invalidArrayCardMoatOptions,invalidArrayCardMoatOptionsTest,
		invalidArrayCardReplicateOptions,invalidArrayCardReplicateOptionTest,
		invalidDyeOptions,invalidDyeTests,
		specifiedReferenceDyeExcitationWavelength,specifiedReferenceDyeEmissionWavelength,referenceDyeExcitationEmissionPairQ,invalidReferenceDyeExcitationEmissionPairOptions,referenceDyeExcitationEmissionPairTest,
		specifiedProbeExcitationWavelengths,specifiedProbeEmissionWavelengths,probeExcitationEmissionPairQ,invalidProbeExcitationEmissionPairOptions,probeExcitationEmissionPairTest,
		invalidThermocyclerQ,invalidThermocyclerOptions,invalidThermocyclerTest,
		rtInvalidOptions,rtOptionTest,activationInvalidOptions,activationOptionTest,annealingInvalidOptions,annealingOptionTest,
		viia7ExEm,sybrMolecule,roxMolecule,masterMixSYBRPlusRT,masterMixProbeMinusRT,masterMixProbePlusRT,masterMixFoldConcentrationLookup,masterMixReferenceDyeLookup,resolveAutomatic,
		resolvedInstrument,resolvedArrayCardStorageCondition,resolvedReactionVolume,resolvedSampleVolumes,resolvedProbes,resolvedProbeFluorophores,resolvedProbeExcitationWavelengths,resolvedProbeEmissionWavelengths,
		resolvedReverseTranscription,resolvedTranscriptionTime,resolvedTranscriptionTemperature,resolvedTranscriptionRampRate,
		resolvedMasterMix,resolvedMasterMixModel,unknownMasterMixQ,unknownMasterMixTest,resolvedMasterMixVolume,
		masterMixReferenceDye,hasReferenceDye,resolvedReferenceDye,resolvedReferenceDyeVolume,lookedUpReferenceDyeEx,lookedUpReferenceDyeEm,resolvedReferenceStainingDyeExcitationWavelength,resolvedReferenceStainingDyeEmissionWavelength,
		resolvedActivation,resolvedActivationTime,resolvedActivationTemperature,resolvedActivationRampRate,
		resolvedDenaturationTime,resolvedDenaturationTemperature,resolvedDenaturationRampRate,
		resolvedAnnealing,resolvedAnnealingTime,resolvedAnnealingTemperature,resolvedAnnealingRampRate,
		resolvedExtensionTime,resolvedExtensionTemperature,resolvedExtensionRampRate,resolvedNumberOfCycles,
		updatedRoundedqPCROptions,mapThreadFriendlyOptions,totalVolumeTooLargeErrors,resolvedBufferVolumes,resolvedBuffer,
		generateSampleTests,excessiveVolumeOptions,excessiveVolumeTest,
		targetContainers,resolvedAliquotOptions,aliquotTests,
		resolvedPostProcessingOptions,invalidInputs,invalidOptions,
		resolvedEmail,resolvedOptions,allTests},


	(*---Set up the user-specified options and cache---*)

	(*Determine the requested return value from the function*)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];
	messagesQ=!gatherTests;

	(*Fetch our options cache from the parent function*)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];

	(*Split up myOptions into samplePrepOptions and qPCROptions*)
	{samplePrepOptions,qPCROptions}=splitPrepOptions[myOptions];

	(*Resolve sample prep options*)
	{{simulatedSamples,resolvedSamplePrepOptions,simulatedCache},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptions[ExperimentqPCR,myResolverSampleInputs,samplePrepOptions,Cache->cache,Output->{Result,Tests}],
		{resolveSamplePrepOptions[ExperimentqPCR,myResolverSampleInputs,samplePrepOptions,Cache->cache,Output->Result],{}}
	];

	(*Convert list of rules to Association so we can Lookup, Append, Join as usual*)
	qPCROptionsAssociation=Association[qPCROptions];

	(*Extract the packets that we need from our downloaded cache*)
	{{
		samplePackets,
		{arrayCardPacket},
		{arrayCardModelForwardPrimersPackets},
		{arrayCardModelReversePrimersPackets},
		{arrayCardModelProbesPackets}
	}}=Flatten[
		Download[
			{
				simulatedSamples,
				{myResolverArrayCardInput},
				{myResolverArrayCardInput},
				{myResolverArrayCardInput},
				{myResolverArrayCardInput}
			},
			{
				{Packet[Volume,Status,Container]},
				{Packet[Model,Contents,Status]},
				{Packet[Model[ForwardPrimers[{Name}]]]},
				{Packet[Model[ReversePrimers[{Name}]]]},
				{Packet[Model[Probes[{Name,DetectionLabels,Fluorescent,FluorescenceExcitationMaximums,FluorescenceEmissionMaximums}]]]}
			},
			Cache->simulatedCache
		],
		{3}
	];


	(*---Input validation checks---*)

	(*--Discarded samples check--*)

	(*Get the samples from samplePackets that are discarded*)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(*Set discardedInvalidInputs to the input objects whose statuses are Discarded*)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],{},Lookup[discardedSamplePackets,Object]];

	(*If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs*)
	If[Length[discardedInvalidInputs]>0&&messagesQ,Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->simulatedCache]]];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result*)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->simulatedCache]<>" are not discarded:",True,False]
			];
			passingTest=If[Length[discardedInvalidInputs]==Length[myResolverSampleInputs],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[myResolverSampleInputs,discardedInvalidInputs],Cache->simulatedCache]<>" are not discarded:",True,True]
			];
			{failingTest,passingTest}
		],Nothing
	];

	(*--Discarded array card check--*)

	(*Set discardedArrayCardInvalidInputs to the array card if its status is Discarded*)
	discardedArrayCardInvalidInputs=If[MatchQ[Lookup[arrayCardPacket,Status],Discarded],
		Lookup[arrayCardPacket,Object],
		{}
	];

	(*If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs*)
	If[MatchQ[discardedArrayCardInvalidInputs,ObjectP[]]&&messagesQ,
		Message[Error::DiscardedArrayCard,ObjectToString[discardedArrayCardInvalidInputs,Cache->simulatedCache]]
	];

	(*If we are gathering tests, create a test for discarded array card*)
	discardedArrayCardTest=If[gatherTests,
		Test["Our input array card "<>ObjectToString[discardedArrayCardInvalidInputs,Cache->simulatedCache]<>" is not discarded:",
			MatchQ[discardedArrayCardInvalidInputs,{}],
			True
		],
		Nothing
	];

	(*--Too many samples check--*)

	(*Check if there are too many samples for the array card*)
	tooManySamplesQ=Length[simulatedSamples]>8;

	(*Set tooManySamplesInvalidInputs to all sample objects*)
	tooManySamplesInvalidInputs=If[tooManySamplesQ,
		Lookup[Flatten[samplePackets],Object],
		{}
	];

	(*If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs*)
	If[Length[tooManySamplesInvalidInputs]>0&&messagesQ,
		Message[Error::ArrayCardTooManySamples]
	];

	(*If we are gathering tests, create a test for too many samples*)
	tooManySamplesTest=If[gatherTests,
		Test["There are 8 or fewer input samples:",
			tooManySamplesQ,
			False
		],
		Nothing
	];

	(*--Array card contents length check--*)

	(*Check if the array card's contents and reagents match in length*)
	arrayCardContentsMismatchQ=!(Length[Lookup[arrayCardPacket,Contents]]==Length[arrayCardModelForwardPrimersPackets]==Length[arrayCardModelReversePrimersPackets]==Length[arrayCardModelProbesPackets]);

	(*Set arrayCardContentsMismatchInvalidInputs to the array card*)
	arrayCardContentsMismatchInvalidInputs=If[arrayCardContentsMismatchQ,
		Lookup[arrayCardPacket,Object],
		{}
	];

	(*If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs*)
	If[MatchQ[arrayCardContentsMismatchInvalidInputs,ObjectP[]]&&messagesQ,
		Message[Error::ArrayCardContentsMismatch]
	];

	(*If we are gathering tests, create a test for array card contents mismatch*)
	arrayCardContentsMismatchTest=If[gatherTests,
		Test["The number of samples on the input array card must match the number of ForwardPrimers, ReversePrimers, and Probes from the array card model:",
			arrayCardContentsMismatchQ,
			False
		],
		Nothing
	];


	(*---Option precision checks---*)

	(*Round the options that have precision*)
	{precisionOptions,precisionUnits}=Transpose[
		{
			{ReverseTranscriptionTime,1 Second},
			{ReverseTranscriptionTemperature,.1 Celsius},
			{ReverseTranscriptionRampRate,.001 Celsius/Second},

			{ActivationTime,1 Second},
			{ActivationTemperature,.1 Celsius},
			{ActivationRampRate,.001 Celsius/Second},

			{DenaturationTime,1 Second},
			{DenaturationTemperature,.1 Celsius},
			{DenaturationRampRate,.001 Celsius/Second},

			{PrimerAnnealingTime,1 Second},
			{PrimerAnnealingTemperature,.1 Celsius},
			{PrimerAnnealingRampRate,.001 Celsius/Second},

			{ExtensionTime,1 Second},
			{ExtensionTemperature,.1 Celsius},
			{ExtensionRampRate,.001 Celsius/Second},

			(*Protocol-wide volume options*)
			{ReactionVolume,0.1 Microliter},
			{MasterMixVolume,0.1 Microliter},
			{ReferenceDyeVolume,0.1 Microliter},

			(*SamplesIn index matched volume options*)
			{SampleVolume,0.1 Microliter},
			{BufferVolume,0.1 Microliter}
		}
	];

	{roundedqPCROptions,precisionTests}=If[gatherTests,
		RoundOptionPrecision[qPCROptionsAssociation,precisionOptions,precisionUnits,Output->{Result,Tests}],
		{RoundOptionPrecision[qPCROptionsAssociation,precisionOptions,precisionUnits],Null}
	];


	(*---Conflicting options checks---*)

	(*Define a local helper to check for cases where a master switch is explicitly False but subordinate options are specified
		Input: unresolved options list, master switch option name, list of subordinate option names
		Output: list of invalid dependent option symbols, list of invalid dependent option tests
		NOTE: Depends on local values of messagesQ, gatherTests
	*)
	masterSwitchCheck[optionsList_, parentOption_Symbol, subordinateOptions_List]:=Module[
		{masterSwitchOffQ, subordinateOptionSpecifiedQList, specifiedSubordinateOptions},

		(*Is the parent option missing?*)
		masterSwitchOffQ=MatchQ[Lookup[optionsList, parentOption], False];

		(*Generate a boolean list of whether each dependent option has been specified
			Must match ListableP because ExpandIndexMatchedInputs will expand all members of an index matching option set
			if any are listed, but will leave them alone if none are listed.*)
		subordinateOptionSpecifiedQList=MatchQ[#, Except[ListableP[NullP|Automatic]]]& /@ Lookup[optionsList, subordinateOptions];

		(*If the parent option is False, throw messages for all dependent options that are specified*)
		specifiedSubordinateOptions=PickList[subordinateOptions, subordinateOptionSpecifiedQList];

		(*Throw messages and/or generate tests as appropriate*)
		{
			(*Throw a message if desired and include option in error option list if needed*)
			If[masterSwitchOffQ && Length[specifiedSubordinateOptions]>0 && messagesQ,
				(
					Message[Error::DisabledFeatureOptionSpecified, parentOption, specifiedSubordinateOptions];
					specifiedSubordinateOptions
				),
				{}
			],

			(*Generate Test for each subordinate option*)
			If[gatherTests,
				MapThread[
					Function[{dependentOption, dependentOptionSpecifiedQ},
						Test[
							StringJoin["If the master switch option ",ToString[parentOption], " is False, ", ToString[dependentOption], " is Null or Automatic:"],
							If[masterSwitchOffQ, !dependentOptionSpecifiedQ, True],
							True
						]
					],
					{subordinateOptions, subordinateOptionSpecifiedQList}
				],
				{}
			]
		}
	];

	(*--Check that Name is properly specified--*)
	nameOption=Lookup[roundedqPCROptions,Name];

	validNameQ=If[MatchQ[nameOption,_String],
		Not[DatabaseMemberQ[Object[Protocol,qPCR,nameOption]]],
		True
	];

	(*If validNameQ is False and we are throwing messages, then throw an error message*)
	nameInvalidOptions=If[!validNameQ&&messagesQ,
		(
			Message[Error::DuplicateName,"qPCR protocol"];
			{Name}
		),
		{}
	];

	(*If we are gathering tests, create a test for Name*)
	validNameTest=If[gatherTests&&MatchQ[nameOption,_String],
		Test["If specified, Name is not already a qPCR protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(*--Check that the reagent options aren't specified--*)
	invalidArrayCardReagentOptions=PickList[
		{ForwardPrimerVolume,ForwardPrimerStorageCondition,ReversePrimerVolume,ReversePrimerStorageCondition,Probe,ProbeVolume,ProbeStorageCondition,ProbeFluorophore,ProbeExcitationWavelength,ProbeEmissionWavelength},
		Lookup[roundedqPCROptions,{ForwardPrimerVolume,ForwardPrimerStorageCondition,ReversePrimerVolume,ReversePrimerStorageCondition,Probe,ProbeVolume,ProbeStorageCondition,ProbeFluorophore,ProbeExcitationWavelength,ProbeEmissionWavelength}],
		Except[ListableP[Automatic|Null]]
	];

	(*If there are invalid reagent options and we are throwing messages, then throw an error message*)
	If[!MatchQ[invalidArrayCardReagentOptions,{}]&&messagesQ,
		Message[Error::InvalidArrayCardReagentOptions,invalidArrayCardReagentOptions]
	];

	(*If we are gathering tests, create a test for ArrayCard reagent options*)
	invalidArrayCardReagentOptionsTest=If[gatherTests,
		Test["If using an array card, the ForwardPrimer, ReversePrimer, and Probe options are not specified:",
			!MatchQ[invalidArrayCardReagentOptions,{}],
			False
		],
		Nothing
	];

	(*--Check that the Endogenous options aren't specified--*)
	invalidArrayCardEndogenousOptions=PickList[
		{EndogenousPrimerPair,EndogenousForwardPrimerVolume,EndogenousForwardPrimerStorageCondition,EndogenousReversePrimerVolume,EndogenousReversePrimerStorageCondition,EndogenousProbe,EndogenousProbeVolume,EndogenousProbeStorageCondition,EndogenousProbeFluorophore,EndogenousProbeExcitationWavelength,EndogenousProbeEmissionWavelength},
		Lookup[roundedqPCROptions,{EndogenousPrimerPair,EndogenousForwardPrimerVolume,EndogenousForwardPrimerStorageCondition,EndogenousReversePrimerVolume,EndogenousReversePrimerStorageCondition,EndogenousProbe,EndogenousProbeVolume,EndogenousProbeStorageCondition,EndogenousProbeFluorophore,EndogenousProbeExcitationWavelength,EndogenousProbeEmissionWavelength}],
		Except[ListableP[Automatic|Null]]
	];

	(*If there are invalid Endogenous options and we are throwing messages, then throw an error message*)
	If[!MatchQ[invalidArrayCardEndogenousOptions,{}]&&messagesQ,
		Message[Error::InvalidArrayCardEndogenousOptions,invalidArrayCardEndogenousOptions]
	];

	(*If we are gathering tests, create a test for ArrayCard Endogenous options*)
	invalidArrayCardEndogenousOptionsTest=If[gatherTests,
		Test["If using an array card, the Endogenous options are not specified:",
			!MatchQ[invalidArrayCardEndogenousOptions,{}],
			False
		],
		Nothing
	];

	(*--Check that the Standard options aren't specified--*)
	invalidArrayCardStandardOptions=PickList[
		{Standard,StandardVolume,StandardStorageCondition,StandardPrimerPair,StandardForwardPrimerVolume,StandardForwardPrimerStorageCondition,StandardReversePrimerVolume,StandardReversePrimerStorageCondition,StandardProbe,StandardProbeVolume,StandardProbeStorageCondition,StandardProbeFluorophore,StandardProbeExcitationWavelength,StandardProbeEmissionWavelength,SerialDilutionFactor,NumberOfDilutions,NumberOfStandardReplicates},
		Lookup[roundedqPCROptions,{Standard,StandardVolume,StandardStorageCondition,StandardPrimerPair,StandardForwardPrimerVolume,StandardForwardPrimerStorageCondition,StandardReversePrimerVolume,StandardReversePrimerStorageCondition,StandardProbe,StandardProbeVolume,StandardProbeStorageCondition,StandardProbeFluorophore,StandardProbeExcitationWavelength,StandardProbeEmissionWavelength,SerialDilutionFactor,NumberOfDilutions,NumberOfStandardReplicates}],
		Except[ListableP[Automatic|Null]]
	];

	(*If there are invalid Standard options and we are throwing messages, then throw an error message*)
	If[!MatchQ[invalidArrayCardStandardOptions,{}]&&messagesQ,
		Message[Error::InvalidArrayCardStandardOptions,invalidArrayCardStandardOptions]
	];

	(*If we are gathering tests, create a test for ArrayCard Standard options*)
	invalidArrayCardStandardOptionsTest=If[gatherTests,
		Test["If using an array card, the Standard options are not specified:",
			!MatchQ[invalidArrayCardStandardOptions,{}],
			False
		],
		Nothing
	];

	(*--Check that the DuplexStainingDye options aren't specified--*)
	invalidArrayCardDuplexStainingDyeOptions=PickList[
		{DuplexStainingDye,DuplexStainingDyeVolume,DuplexStainingDyeExcitationWavelength,DuplexStainingDyeEmissionWavelength},
		Lookup[roundedqPCROptions,{DuplexStainingDye,DuplexStainingDyeVolume,DuplexStainingDyeExcitationWavelength,DuplexStainingDyeEmissionWavelength}],
		Except[ListableP[Automatic|Null]]
	];

	(*If there are invalid DuplexStainingDye options and we are throwing messages, then throw an error message*)
	If[!MatchQ[invalidArrayCardDuplexStainingDyeOptions,{}]&&messagesQ,
		Message[Error::InvalidArrayCardDuplexStainingDyeOptions,invalidArrayCardDuplexStainingDyeOptions]
	];

	(*If we are gathering tests, create a test for ArrayCard DuplexStainingDye options*)
	invalidArrayCardDuplexStainingDyeOptionsTest=If[gatherTests,
		Test["If using an array card, the DuplexStainingDye options are not specified:",
			!MatchQ[invalidArrayCardDuplexStainingDyeOptions,{}],
			False
		],
		Nothing
	];

	(*--Check that the MeltingCurve options aren't specified--*)
	invalidArrayCardMeltingCurveOptions=PickList[
		{MeltingCurve,PreMeltingCurveRampRate,MeltingCurveStartTemperature,MeltingCurveEndTemperature,MeltingCurveRampRate,MeltingCurveTime},
		Lookup[roundedqPCROptions,{MeltingCurve,PreMeltingCurveRampRate,MeltingCurveStartTemperature,MeltingCurveEndTemperature,MeltingCurveRampRate,MeltingCurveTime}],
		Except[ListableP[Automatic|Null]]
	];

	(*If there are invalid MeltingCurve options and we are throwing messages, then throw an error message*)
	If[!MatchQ[invalidArrayCardMeltingCurveOptions,{}]&&messagesQ,
		Message[Error::InvalidArrayCardMeltingCurveOptions,invalidArrayCardMeltingCurveOptions]
	];

	(*If we are gathering tests, create a test for ArrayCard MeltingCurve options*)
	invalidArrayCardMeltingCurveOptionsTest=If[gatherTests,
		Test["If using an array card, the MeltingCurve options are not specified:",
			!MatchQ[invalidArrayCardMeltingCurveOptions,{}],
			False
		],
		Nothing
	];

	(*--Check that the Moat options aren't specified--*)
	invalidArrayCardMoatOptions=PickList[
		{MoatSize,MoatVolume,MoatBuffer},
		Lookup[roundedqPCROptions,{MoatSize,MoatVolume,MoatBuffer}],
		Except[ListableP[Automatic|Null]]
	];

	(*If there are invalid MeltingCurve options and we are throwing messages, then throw an error message*)
	If[!MatchQ[invalidArrayCardMoatOptions,{}]&&messagesQ,
		Message[Error::InvalidArrayCardMoatOptions,invalidArrayCardMoatOptions]
	];

	(*If we are gathering tests, create a test for ArrayCard MeltingCurve options*)
	invalidArrayCardMoatOptionsTest=If[gatherTests,
		Test["If using an array card, the Moat options are not specified:",
			!MatchQ[invalidArrayCardMoatOptions,{}],
			False
		],
		Nothing
	];

	(*--Check that the NumberOfReplicates option isn't specified--*)
	invalidArrayCardReplicateOptions=If[MatchQ[Lookup[roundedqPCROptions,NumberOfReplicates],Except[Null]],
		{NumberOfReplicates},
		{}
	];

	(*If there are invalid NumberOfReplicates options and we are throwing messages, then throw an error message*)
	If[!MatchQ[invalidArrayCardReplicateOptions,{}]&&messagesQ,
		Message[Error::InvalidArrayCardReplicateOption]
	];

	(*If we are gathering tests, create a test for ArrayCard NumberOfReplicates option*)
	invalidArrayCardReplicateOptionTest=If[gatherTests,
		Test["If using an array card, the NumberOfReplicates option is not specified:",
			!MatchQ[invalidArrayCardReplicateOptions,{}],
			False
		],
		Nothing
	];


	(*--Feature Flag: Check that user is not trying to specify addition of external reference dye (this is not currently supported)--*)

	(*Check whether samples have been specified or volume has been specified for reference dye*)
	invalidDyeOptions=Map[
		Function[{dyeOptionName},
			Module[{optionSpecifiedQ},
				(*Determine whether the option has been specified (Model[Molecule] is fine for dye options)*)
				optionSpecifiedQ=MatchQ[Lookup[roundedqPCROptions,dyeOptionName],VolumeP|ObjectP[{Model[Sample],Object[Sample]}]];

				If[optionSpecifiedQ&&messagesQ,
					(
						Message[Error::SeparateDyesNotSupported];
						dyeOptionName
					),
					Nothing
				]
			]
		],
		{ReferenceDye,ReferenceDyeVolume}
	];

	(*If we are gathering tests, create a test*)
	invalidDyeTests=If[gatherTests,
		Test["Addition of separate reference dye has not been specified (this feature is not currently supported):",
			Length[invalidDyeOptions]==0,
			True
		],
		Nothing
	];

	(*--Wavelength pair checks--*)

	(*-Check that if either ReferenceDyeExcitationWavelength or ReferenceDyeEmissionWavelength is specified, the other is also specified-*)

	(*Look up the values of ReferenceDyeExcitationWavelength and ReferenceDyeEmissionWavelength*)
	specifiedReferenceDyeExcitationWavelength=Lookup[roundedqPCROptions,ReferenceDyeExcitationWavelength];
	specifiedReferenceDyeEmissionWavelength=Lookup[roundedqPCROptions,ReferenceDyeEmissionWavelength];

	(*Check if either option is specified, the other is also specified*)
	referenceDyeExcitationEmissionPairQ=And[
		If[
			MatchQ[specifiedReferenceDyeExcitationWavelength,qPCRExcitationWavelengthP],
			MatchQ[specifiedReferenceDyeEmissionWavelength,qPCREmissionWavelengthP],
			True
		],
		If[
			MatchQ[specifiedReferenceDyeEmissionWavelength,qPCREmissionWavelengthP],
			MatchQ[specifiedReferenceDyeExcitationWavelength,qPCRExcitationWavelengthP],
			True
		]
	];

	(*If referenceDyeExcitationEmissionPairQ is False AND we are throwing messages, then throw the message*)
	invalidReferenceDyeExcitationEmissionPairOptions=If[!referenceDyeExcitationEmissionPairQ&&messagesQ,
		(
			Message[Error::IncompleteReferenceDyeExcitationEmissionPair];
			{ReferenceDyeExcitationWavelength,ReferenceDyeEmissionWavelength}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	referenceDyeExcitationEmissionPairTest=If[gatherTests,
		Test["If either ReferenceDyeExcitationWavelength or ReferenceDyeEmissionWavelength is specified, the other is also specified:",
			referenceDyeExcitationEmissionPairQ,
			True
		],
		Nothing
	];

	(*-Check that for each sample, if either ProbeExcitationWavelength or ProbeEmissionWavelength is specified, the other is also specified-*)

	(*Look up the values of ProbeExcitationWavelength and ProbeEmissionWavelength*)
	specifiedProbeExcitationWavelengths=ToList[Lookup[roundedqPCROptions,ProbeExcitationWavelength]];
	specifiedProbeEmissionWavelengths=ToList[Lookup[roundedqPCROptions,ProbeEmissionWavelength]];

	(*Check if either option is specified, the other is also specified*)
	probeExcitationEmissionPairQ=AllTrue[Join[
		MapThread[
			If[MatchQ[#1,ListableP[qPCRExcitationWavelengthP]],
				MatchQ[#2,ListableP[qPCREmissionWavelengthP]],
				True
			]&,
			{specifiedProbeExcitationWavelengths,specifiedProbeEmissionWavelengths}
		],
		MapThread[
			If[MatchQ[#2,ListableP[qPCREmissionWavelengthP]],
				MatchQ[#1,ListableP[qPCRExcitationWavelengthP]],
				True
			]&,
			{specifiedProbeExcitationWavelengths,specifiedProbeEmissionWavelengths}
		]
	],TrueQ];

	(*If probeExcitationEmissionPairQ is False AND we are throwing messages, then throw the message*)
	invalidProbeExcitationEmissionPairOptions=If[!probeExcitationEmissionPairQ&&messagesQ,
		(
			Message[Error::IncompleteProbeExcitationEmissionPair];
			{ProbeExcitationWavelength,ProbeEmissionWavelength}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	probeExcitationEmissionPairTest=If[gatherTests,
		Test["For each sample, if either ProbeExcitationWavelength or ProbeEmissionWavelength is specified, the other is also specified:",
			probeExcitationEmissionPairQ,
			True
		],
		Nothing
	];

	(*--Check that a qPCR instrument has been selected (realistically, a ViiA7)--*)

	(* resolve the instrument *)
	(* note that once we have a more robust framework for figuring out Site before resource packets we can do that, but for now, we're just going to do $Site *)
	(* if we're at Austin we're going to use the Viia 7, and if we're at CMU we're going with the QuantStudio 7 Flex *)
	resolvedInstrument = Which[
		MatchQ[Lookup[roundedqPCROptions, Instrument], ObjectP[]], Lookup[roundedqPCROptions, Instrument],
		MatchQ[$Site, Object[Container, Site, "id:kEJ9mqJxOl63"]], Model[Instrument, Thermocycler, "id:D8KAEvdqzXYk"], (* Object[Container, Site, "ECL-2"] and Model[Instrument, Thermocycler, "ViiA 7"] *)
		True, Model[Instrument, Thermocycler, "id:R8e1PjeaXle4"] (* Model[Instrument, Thermocycler, "QuantStudio 7 Flex"] *)
	];

	(*Figure out whether a valid thermocycler has been selected*)
	invalidThermocyclerQ=Module[{inst,instModel},

		(*Look up instrument option*)
		inst=Download[resolvedInstrument,Object];

		(*If instrument option is an Object, look up model from its packet*)
		instModel=If[MatchQ[inst,ObjectP[Object[Instrument]]],
			Download[Lookup[fetchPacketFromCache[inst,simulatedCache],Model],Object],
			inst
		];

		(* Make sure the instrumet has (or is) the ViiA 7 model (or the QuantStudio 7 Flex model, for CMU) *)
		!MatchQ[
			instModel,
			Alternatives[
				Model[Instrument, Thermocycler, "id:D8KAEvdqzXYk"], (* Model[Instrument, Thermocycler, "ViiA 7"] *)
				Model[Instrument, Thermocycler, "id:R8e1PjeaXle4"]  (* Model[Instrument, Thermocycler, "QuantStudio 7 Flex"] *)
			]
		]
	];

	(*If probeSpecifiedDuplexStainingDyeNullQ is False AND we are throwing messages, then throw the message*)
	invalidThermocyclerOptions=If[invalidThermocyclerQ&&messagesQ,
		(
			Message[Error::InvalidThermocycler,resolvedInstrument];
			{Instrument}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	invalidThermocyclerTest=If[gatherTests,
		Test["Specified Instrument is a qPCR-capable thermocycler instrument or model:",
			invalidThermocyclerQ,
			False
		],
		Nothing
	];

	(*--Check that if any ReverseTranscription-specific options are specified, ReverseTranscription is not False--*)
	{rtInvalidOptions,rtOptionTest}=masterSwitchCheck[
		roundedqPCROptions,
		ReverseTranscription,
		{ReverseTranscriptionTime,ReverseTranscriptionTemperature,ReverseTranscriptionRampRate}
	];

	(*--Check that if any Activation-specific options are specified, Activation is not False--*)
	{activationInvalidOptions,activationOptionTest}=masterSwitchCheck[
		roundedqPCROptions,
		Activation,
		{ActivationTime,ActivationTemperature,ActivationRampRate}
	];

	(*--Check that if any PrimerAnnealing-specific options are specified, PrimerAnnealing is not False--*)
	{annealingInvalidOptions,annealingOptionTest}=masterSwitchCheck[
		roundedqPCROptions,
		PrimerAnnealing,
		{PrimerAnnealingTime,PrimerAnnealingTemperature,PrimerAnnealingRampRate}
	];


	(*---RESOLVE EXPERIMENT OPTIONS, SINGLE---*)

	(*===Helper functions and lookups for options resolution===*)

	(*--viia7ExEm: a helper function to pull Ex/Em from looked up fluorophore packet and find nearest ViiA7 filter pair. General algorithm is to find the Ex/Em pair with the smallest overall difference between maximum and filter wavelength for both excitation and emission. We also need to remove the duplicate Ex/Em pair of 520nm/520nm that unfortunately exists and makes things complicated--*)

	(*If passed a fulfillment model or actual sample, we'll already be throwing an error because use of separate duplex staining and reference dyes is feature flagged at present. Just return a default wavelength pair to allow resolution to finish*)
	viia7ExEm[fluorophore:ObjectP[{Object[Sample],Model[Sample]}]]:={470 Nanometer,520 Nanometer};

	(*If passed a Model[Molecule], pick the Ex/Em pair with shortest excitation and find the nearest ViiA7 pair to it*)
	viia7ExEm[fluorophore:ObjectP[Model[Molecule]]]:=Module[
		{fluorPacket,rawExWav,rawEmWav,nonNullExEmPairs},

		(*Look up fluorophore packet from cache*)
		fluorPacket=fetchPacketFromCache[fluorophore,simulatedCache];

		(*Pull Ex and Em wavelengths out, defaulting to Null*)
		rawExWav=Lookup[fluorPacket,FluorescenceExcitationMaximums,{}];
		rawEmWav=Lookup[fluorPacket,FluorescenceEmissionMaximums,{}];

		(*Pass to wavelength overload if there is a complete non-Null Ex/Em pair*)
		nonNullExEmPairs=Cases[Transpose[{rawExWav,rawEmWav}],{Except[Null],Except[Null]}];

		If[Length[nonNullExEmPairs]==0,
			(*If no non-Null pairs, use a default wavelength pair*)
			{470 Nanometer,520 Nanometer},
			(*If there is at least one non-Null pair, move forward with the one with the shortest excitation
				under the assumption that that will be the fluorophore in a fluorophore-quencher pair*)
			viia7ExEm[First[MinimalBy[nonNullExEmPairs,First]]]
		]
	];

	(*Core overload - find closest available and feasible Ex/Em filter combination*)
	viia7ExEm[actualExEmPair:{DistanceP,DistanceP}]:=Module[
		{allExEmTuples},

		(*Get all possible Ex/Em pairs, eliminating pairs that have the same wavelength for both*)
		allExEmTuples=DeleteCases[
			Tuples[{List@@qPCRExcitationWavelengthP,List@@qPCREmissionWavelengthP}],
			Except[_?DuplicateFreeQ]
		];

		(*Find the pair with the smallest overall difference between Ex/Em maxima and filters*)
		First[MinimalBy[allExEmTuples,Total[Abs[actualExEmPair-#]]&]]
	];

	(*--Hard code explicitly supported master mix models for now--*)

	(*Define common dye molecules*)
	sybrMolecule=Model[Molecule,"id:lYq9jRxPaDEl"];
	roxMolecule=Model[Molecule,"id:lYq9jRxPaPGV"];

	(*NOTE: When adding an entry to any of the lists below, be sure to add entries in the lookup tables below for their various important properties*)
	masterMixProbeMinusRT={Model[Sample,"id:M8n3rx0RWw75"]};(*TaqMan Universal PCR Master Mix, no AmpErase UNG*)
	masterMixProbePlusRT={Model[Sample,"id:aXRlGn6YABEp"]};(*TaqMan Fast Virus 1-Step Master Mix*)

	(*--Define some lookup tables for important properties of master mixes--*)

	(*Define a lookup table for fold concentration of various master mixes*)
	masterMixFoldConcentrationLookup={
		Model[Sample,"id:M8n3rx0RWw75"]->2,(*TaqMan Universal PCR Master Mix, no AmpErase UNG*)
		Model[Sample,"id:aXRlGn6YABEp"]->4,(*TaqMan Fast Virus 1-Step Master Mix*)
		_->2(*Default for anything not listed above*)
	};

	(*Define a lookup table for reference dye of various master mixes*)
	(*All our stocked master mixes use ROX; we don't currently stock any master mixes WITHOUT a passive reference dye*)
	masterMixReferenceDyeLookup={
		_->roxMolecule(*Default for anything not listed above*)
	};

	(*--resolveAutomatic: a helper function that either takes the user value or resolves Automatic to a default value--*)
	resolveAutomatic[assoc_,option_,automaticValue_]:=With[
		{value=Lookup[assoc,option]},
		(*if value is Automatic, resolve to automaticValue, else take the user value*)
		If[MatchQ[value,ListableP[Automatic]],
			automaticValue,
			value
		]
	];

	(*overload that either takes the user value or resolves Automatic based on another (T/F) option*)
	resolveAutomatic[assoc_,option_,gateBool_,trueValue_,falseValue_]:=With[
		{value=Lookup[assoc,option]},
		(*if value is Automatic, further resolve based on gateBool, else take the user value*)
		If[MatchQ[value,ListableP[Automatic]],
			If[gateBool,trueValue,falseValue],
			value
		]
	];

	(*===Resolve independent options===*)
	resolvedArrayCardStorageCondition=resolveAutomatic[roundedqPCROptions,ArrayCardStorageCondition,Disposal];
	resolvedReactionVolume=resolveAutomatic[roundedqPCROptions,ReactionVolume,2 Microliter];
	resolvedSampleVolumes=resolveAutomatic[roundedqPCROptions,SampleVolume,Table[48 Microliter,Length[myResolverSampleInputs]]];
	resolvedProbes=Partition[
		Take[
			Download[Lookup[arrayCardPacket,Contents][[All,2]],Object],
			Min[Length[myResolverSampleInputs]*48,Length[Lookup[arrayCardPacket,Contents]]]
		],
		48
	];
	resolvedProbeFluorophores=Partition[
		Take[
			First/@Download[Lookup[arrayCardModelProbesPackets,DetectionLabels],Object],
			Min[Length[myResolverSampleInputs]*48,Length[Lookup[arrayCardModelProbesPackets,DetectionLabels]]]
		],
		48
	];
	resolvedProbeExcitationWavelengths=Partition[
		First[viia7ExEm[#]]&/@Flatten[resolvedProbeFluorophores],
		48
	];
	resolvedProbeEmissionWavelengths=Partition[
		Last[viia7ExEm[#]]&/@Flatten[resolvedProbeFluorophores],
		48
	];

	(*===Resolve ReverseTranscription and related options up front, because MasterMix resolution depends on it===*)
	resolvedReverseTranscription=With[
		{rtOption=Lookup[roundedqPCROptions,ReverseTranscription]},

		If[!MatchQ[rtOption,Automatic],
			(*If the RT option was specified, use it*)
			rtOption,
			(*ELSE if the RT option is automatic, do some resolving*)
			If[
				And[
					MatchQ[Lookup[roundedqPCROptions,{ReverseTranscriptionTime,ReverseTranscriptionTemperature,ReverseTranscriptionRampRate}],{Automatic..}],
					!MemberQ[Join[masterMixSYBRPlusRT,masterMixProbePlusRT],Lookup[roundedqPCROptions,MasterMix]]
				],
				(*If all RT-related options are Automatic and the specified master mix is not an RT master mix, resolve to False*)
				False,
				(*ELSE one or more options indicate that RT should be True, so resolve to True*)
				True
			]
		]
	];
	resolvedTranscriptionTime=resolveAutomatic[roundedqPCROptions,ReverseTranscriptionTime,resolvedReverseTranscription,10 Minute,Null];
	resolvedTranscriptionTemperature=resolveAutomatic[roundedqPCROptions,ReverseTranscriptionTemperature,resolvedReverseTranscription,50 Celsius,Null];
	resolvedTranscriptionRampRate=resolveAutomatic[roundedqPCROptions,ReverseTranscriptionRampRate,resolvedReverseTranscription,1.6 (Celsius/Second),Null];

	(*===Resolve all the MasterMix options===*)

	(*Resolve MasterMix based on resolvedReverseTranscription*)
	resolvedMasterMix=resolveAutomatic[roundedqPCROptions,MasterMix,resolvedReverseTranscription,First[masterMixProbePlusRT,Null],First[masterMixProbeMinusRT,Null]];

	(*Get the MasterMix model*)
	resolvedMasterMixModel=If[MatchQ[resolvedMasterMix,ObjectP[Object[Sample]]],
		(*If resolved MasterMix option is an object, fetch its packet and pull its Model field*)
		Download[Lookup[fetchPacketFromCache[resolvedMasterMix, simulatedCache],Model,Null],Object],
		resolvedMasterMix
	];

	(*--If a master mix has been specified that does not have a model specifically handled by ExperimentqPCR, throw a warning--*)

	(*Figure out whether master mix option is a known model*)
	unknownMasterMixQ=!MemberQ[Keys[masterMixFoldConcentrationLookup],resolvedMasterMixModel];

	(*If the master mix has not been specifically onboarded into ExperimentqPCR and we are throwing messages, throw a warning*)
	If[unknownMasterMixQ&&messagesQ&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::UnknownMasterMix,
			ObjectToString[resolvedMasterMixModel,Cache->simulatedCache],
			"ROX passive reference dye and no reverse transcriptase"
		]
	];

	(*If we are gathering tests, create a test for unknown MasterMix*)
	unknownMasterMixTest=If[unknownMasterMixQ&&gatherTests,
		Test["The specified MasterMix model, "<>ObjectToString[resolvedMasterMixModel,Cache->simulatedCache]<>", has been pre-evaluated for use in ExperimentqPCR and has known working concentration (e.g., 2x) dye content (e.g. duplex and/or reference dyes), and reverse transcriptase content:",
			False,
			True
		],
		Nothing
	];

	(*If MasterMixVolume is Automatic, resolve based on resolvedReactionVolume and fold concentration*)
	resolvedMasterMixVolume=With[
		{
			masterMixVolumeOption=Lookup[roundedqPCROptions,MasterMixVolume],
			calculatedMasterMixVolume=resolvedReactionVolume*48/(resolvedMasterMixModel/.masterMixFoldConcentrationLookup)
		},
		If[!MatchQ[masterMixVolumeOption,Automatic],
			(*If user specified an option, use it*)
			masterMixVolumeOption,
			(*ELSE, calculate master mix volume to use based on hard-coded fold concentrations stored above*)
			calculatedMasterMixVolume
		]
	];

	(*===Resolve all the ReferenceDye options===*)

	(*Look up what reference dye is included in the master mix, if any*)
	masterMixReferenceDye=With[
		{
			masterMixReferenceDyeOption=Lookup[roundedqPCROptions,ReferenceDye],
			expectedMasterMixReferenceDye=resolvedMasterMixModel/.masterMixReferenceDyeLookup
		},
		If[!MatchQ[masterMixReferenceDyeOption,Automatic],
			(*If user specified an option, use it*)
			masterMixReferenceDyeOption,
			(*ELSE, use the reference dye from the hard-coded list stored above*)
			expectedMasterMixReferenceDye
		]
	];

	(*Does master mix include a passive reference dye?*)
	hasReferenceDye=ObjectQ[masterMixReferenceDye];

	(*By definition, this should be changed to always be the dye in the master mix. We do not currently allow for addition of separate reference dye*)
	resolvedReferenceDye=resolveAutomatic[roundedqPCROptions,ReferenceDye,hasReferenceDye,masterMixReferenceDye,Null];

	(*Per the comment on the line above, this will be removed*)
	resolvedReferenceDyeVolume=resolveAutomatic[roundedqPCROptions,ReferenceDyeVolume,
		(*if the master mix has no dye and user supplied one*)
		And[!hasReferenceDye,ObjectQ[resolvedReferenceDye]],
		1 Microliter,
		Null
	];

	(*Look up Ex/Em from Model[Molecule], finding the closest matches in the QuantStudio Ex/Em sets*)
	{lookedUpReferenceDyeEx,lookedUpReferenceDyeEm}=If[hasReferenceDye,
		viia7ExEm[resolvedReferenceDye],
		{Null,Null}
	];

	(*If reference dye is being used and wavelengths haven't been specified, use the looked-up values from above*)
	resolvedReferenceStainingDyeExcitationWavelength=resolveAutomatic[roundedqPCROptions,ReferenceDyeExcitationWavelength,hasReferenceDye,lookedUpReferenceDyeEx,Null];
	resolvedReferenceStainingDyeEmissionWavelength=resolveAutomatic[roundedqPCROptions,ReferenceDyeEmissionWavelength,hasReferenceDye,lookedUpReferenceDyeEm,Null];

	(*===Resolve all the thermocycling options===*)

	(*resolve all of the Activation options*)
	resolvedActivation=Lookup[roundedqPCROptions,Activation];
	resolvedActivationTime=resolveAutomatic[roundedqPCROptions,ActivationTime,resolvedActivation,1 Minute,Null];
	resolvedActivationTemperature=resolveAutomatic[roundedqPCROptions,ActivationTemperature,resolvedActivation,95 Celsius,Null];
	resolvedActivationRampRate=resolveAutomatic[roundedqPCROptions,ActivationRampRate,resolvedActivation,1.6 (Celsius/Second),Null];

	(*resolve all of the Denaturation options*)
	resolvedDenaturationTime=Lookup[roundedqPCROptions,DenaturationTime];
	resolvedDenaturationTemperature=Lookup[roundedqPCROptions,DenaturationTemperature];
	resolvedDenaturationRampRate=Lookup[roundedqPCROptions,DenaturationRampRate];

	(*resolve all the PrimerAnnealing options (this is optional because annealing can be done as part of extension)*)
	resolvedAnnealing=resolveAutomatic[
		roundedqPCROptions,
		PrimerAnnealing,
		MatchQ[Lookup[roundedqPCROptions,{PrimerAnnealingTime,PrimerAnnealingTemperature,PrimerAnnealingRampRate}],{Automatic..}],
		False,
		True
	];
	resolvedAnnealingTime=resolveAutomatic[roundedqPCROptions,PrimerAnnealingTime,resolvedAnnealing,30 Second,Null];
	resolvedAnnealingTemperature=resolveAutomatic[roundedqPCROptions,PrimerAnnealingTemperature,resolvedAnnealing,60 Celsius,Null];
	resolvedAnnealingRampRate=resolveAutomatic[roundedqPCROptions,PrimerAnnealingRampRate,resolvedAnnealing,1.6 (Celsius/Second),Null];

	(*resolve all the Extension options*)
	resolvedExtensionTime=Lookup[roundedqPCROptions,ExtensionTime];
	resolvedExtensionTemperature=Lookup[roundedqPCROptions,ExtensionTemperature];
	resolvedExtensionRampRate=Lookup[roundedqPCROptions,ExtensionRampRate];

	(*resolve the NumberOfCycles option*)
	resolvedNumberOfCycles=Lookup[roundedqPCROptions,NumberOfCycles];


	(*---RESOLVE EXPERIMENT OPTIONS, MULTIPLE---*)

	(*Update and convert our options into a MapThread friendly version*)
	updatedRoundedqPCROptions=Association[ReplaceRule[
		Normal[roundedqPCROptions],
		{ReactionVolume->resolvedReactionVolume,MasterMixVolume->resolvedMasterMixVolume}
	]];
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentqPCR,updatedRoundedqPCROptions];

	(*MapThread over each of our samples*)
	{totalVolumeTooLargeErrors,resolvedBufferVolumes}=Transpose[MapThread[
		Function[{myMapThreadOptions,mySampleVolume},
			Module[
				{totalVolumeTooLargeError,reactionVolume,masterMixVolume,buffer,bufferVolume,resolvedBufferVolume},

				(*Initialize the error-tracking variable*)
				totalVolumeTooLargeError=False;

				(*Pull out specified or resolved option values for calculating BufferVolume*)
				{reactionVolume,masterMixVolume,buffer,bufferVolume}=Lookup[myMapThreadOptions,{ReactionVolume,MasterMixVolume,Buffer,BufferVolume}];

				(*Resolve BufferVolume*)
				resolvedBufferVolume=Which[
					(*If specified, accept it*)
					MatchQ[bufferVolume,Except[Automatic]],bufferVolume,
					(*If Automatic, resolve to ReactionVolume*48-(SampleVolume+MasterMixVolume) if Buffer is not set to Null*)
					MatchQ[bufferVolume,Automatic]&&!NullQ[buffer]&&Total[{mySampleVolume,masterMixVolume}/.Null->0 Microliter]<reactionVolume*48,reactionVolume*48-Total[{mySampleVolume,masterMixVolume}/.Null->0 Microliter],
					True,0 Microliter
				];

				(*If the total volume exceeds ReactionVolume*48, flip the error switch*)
				totalVolumeTooLargeError=If[Total[{mySampleVolume,masterMixVolume,resolvedBufferVolume}/.Null->0 Microliter]>reactionVolume*48,True,False];

				(*Return the error-tracking variables and resolved values*)
				{totalVolumeTooLargeError,resolvedBufferVolume}
			]
		],
		{mapThreadFriendlyOptions,resolvedSampleVolumes}
	]];
	(*--Resolve Buffer after sample-indexed options because we now know whether we need it--*)
	resolvedBuffer=Switch[
		{Total[resolvedBufferVolumes],Lookup[roundedqPCROptions,Buffer]},
		{0 Microliter,Automatic},Null,
		{_,Automatic},Model[Sample,"Milli-Q water"],
		{_,Except[Automatic]},Lookup[roundedqPCROptions,Buffer]
	];


	(*---UNRESOLVABLE OPTION CHECKS---*)

	(*--Local helper to do the repetitive work of generating passing/failing Tests for sample-indexed option checks--*)

	(*Default to making Tests unless Warning is explicitly specified*)
	generateSampleTests[errorVariableList:{BooleanP..},testMessage_String]:=generateSampleTests[errorVariableList,testMessage,Test];
	generateSampleTests[errorVariableList:{BooleanP..},testMessage_String,testHead:(Test|Warning)]:=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(*get the inputs that fail this test*)
			failingSamples=PickList[simulatedSamples,errorVariableList];

			(*get the inputs that pass this test*)
			passingSamples=PickList[simulatedSamples,errorVariableList,False];

			(*create a test for the non-passing inputs*)
			failingSampleTests=If[Length[failingSamples]>0,
				testHead["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", "<>testMessage<>":",
					False,
					True
				],
				Nothing
			];

			(*create a test for the passing inputs*)
			passingSampleTests=If[Length[passingSamples]>0,
				testHead["For the provided samples "<>ObjectToString[passingSamples,Cache->simulatedCache]<>", "<>testMessage<> ":",
					True,
					True
				],
				Nothing
			];

			(*return the created tests*)
			{passingSampleTests,failingSampleTests}
		]
	];

	(*--Total volume--*)

	(*If there are totalVolumeTooLargeErrors and we are throwing messages, then throw an error message*)
	excessiveVolumeOptions=If[MemberQ[totalVolumeTooLargeErrors,True]&&messagesQ,
		(
			Message[Error::ArrayCardExcessiveVolume,resolvedReactionVolume,ObjectToString[PickList[simulatedSamples,totalVolumeTooLargeErrors],Cache->simulatedCache]];
			{ReactionVolume,SampleVolume,MasterMixVolume,BufferVolume}
		),
		{}
	];

	(*If we are gathering tests, create a test for excessive volume*)
	excessiveVolumeTest=generateSampleTests[totalVolumeTooLargeErrors,"the total volume of all components is less than the reaction volume"];


	(*---Resolve aliquot options---*)

	(*Resolve RequiredAliquotContainers as Null, since samples must be transferred into the array card accepted by the instrument*)
	targetContainers=Null;

	(*Resolve aliquot options and make tests*)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentqPCR,
			myResolverSampleInputs,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			Cache->simulatedCache,
			RequiredAliquotAmounts->Null,
			RequiredAliquotContainers->targetContainers,
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentqPCR,
				myResolverSampleInputs,
				simulatedSamples,
				ReplaceRule[myOptions,resolvedSamplePrepOptions],
				Cache->simulatedCache,
				RequiredAliquotAmounts->Null,
				RequiredAliquotContainers->targetContainers,
				Output->Result],
			{}
		}
	];


	(*---Resolve Post Processing Options---*)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];


	(*---Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary---*)
	invalidInputs=DeleteDuplicates[Flatten[{
		discardedInvalidInputs,
		discardedArrayCardInvalidInputs,
		discardedArrayCardInvalidInputs,
		tooManySamplesInvalidInputs,
		arrayCardContentsMismatchInvalidInputs
	}]];
	invalidOptions=DeleteDuplicates[Flatten[{
		nameInvalidOptions,
		invalidArrayCardReagentOptions,
		invalidArrayCardEndogenousOptions,
		invalidArrayCardStandardOptions,
		invalidArrayCardDuplexStainingDyeOptions,
		invalidArrayCardMeltingCurveOptions,
		invalidArrayCardMoatOptions,
		invalidArrayCardReplicateOptions,
		invalidDyeOptions,
		invalidReferenceDyeExcitationEmissionPairOptions,
		invalidProbeExcitationEmissionPairOptions,
		invalidThermocyclerOptions,
		rtInvalidOptions,
		activationInvalidOptions,
		annealingInvalidOptions,
		excessiveVolumeOptions
	}]];

	(*Throw Error::InvalidInput if there are invalid inputs*)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->simulatedCache]]
	];

	(*Throw Error::InvalidOption if there are invalid options.*)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];


	(*---Return our resolved options and tests---*)

	(*resolve the Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a subprotocol*)
	resolvedEmail=Which[
		MatchQ[Lookup[myOptions,Email],Automatic]&&NullQ[Lookup[qPCROptionsAssociation,ParentProtocol]],True,
		MatchQ[Lookup[myOptions,Email],Automatic]&&MatchQ[Lookup[qPCROptionsAssociation,ParentProtocol],ObjectP[ProtocolTypes[]]],False,
		True,Lookup[myOptions,Email]
	];

	(*Gather the resolved options (pre-collapsed; that is happening outside the function)*)
	resolvedOptions=ReplaceRule[Normal[updatedRoundedqPCROptions],
		Flatten[{
			Instrument->resolvedInstrument,
			ArrayCardStorageCondition->resolvedArrayCardStorageCondition,

			(*Samples*)
			ReactionVolume->resolvedReactionVolume,
			SampleVolume->resolvedSampleVolumes,
			Probe->resolvedProbes,
			ProbeFluorophore->resolvedProbeFluorophores,
			ProbeEmissionWavelength->resolvedProbeEmissionWavelengths,
			ProbeExcitationWavelength->resolvedProbeExcitationWavelengths,
			MasterMix->resolvedMasterMix,
			MasterMixVolume->resolvedMasterMixVolume,
			ReferenceDye->resolvedReferenceDye,
			ReferenceDyeVolume->resolvedReferenceDyeVolume,
			ReferenceDyeExcitationWavelength->resolvedReferenceStainingDyeExcitationWavelength,
			ReferenceDyeEmissionWavelength->resolvedReferenceStainingDyeEmissionWavelength,
			Buffer->resolvedBuffer,
			BufferVolume->resolvedBufferVolumes,

			(*Thermocycling*)
			ReverseTranscription->resolvedReverseTranscription,
			ReverseTranscriptionTime->resolvedTranscriptionTime,
			ReverseTranscriptionTemperature->resolvedTranscriptionTemperature,
			ReverseTranscriptionRampRate->resolvedTranscriptionRampRate,
			Activation->resolvedActivation,
			ActivationTime->resolvedActivationTime,
			ActivationTemperature->resolvedActivationTemperature,
			ActivationRampRate->resolvedActivationRampRate,
			DenaturationTime->resolvedDenaturationTime,
			DenaturationTemperature->resolvedDenaturationTemperature,
			DenaturationRampRate->resolvedDenaturationRampRate,
			PrimerAnnealing->resolvedAnnealing,
			PrimerAnnealingTime->resolvedAnnealingTime,
			PrimerAnnealingTemperature->resolvedAnnealingTemperature,
			PrimerAnnealingRampRate->resolvedAnnealingRampRate,
			ExtensionTime->resolvedExtensionTime,
			ExtensionTemperature->resolvedExtensionTemperature,
			ExtensionRampRate->resolvedExtensionRampRate,
			NumberOfCycles->resolvedNumberOfCycles,

			(*Options not relevant to array card*)
			AssayPlateStorageCondition->Null,
			ForwardPrimerVolume->Null,
			ForwardPrimerStorageCondition->Null,
			ReversePrimerVolume->Null,
			ReversePrimerStorageCondition->Null,
			ProbeVolume->Null,
			ProbeStorageCondition->Null,
			EndogenousPrimerPair->Null,
			EndogenousForwardPrimerStorageCondition->Null,
			EndogenousReversePrimerStorageCondition->Null,
			EndogenousForwardPrimerVolume->Null,
			EndogenousReversePrimerVolume->Null,
			EndogenousProbe->Null,
			EndogenousProbeStorageCondition->Null,
			EndogenousProbeVolume->Null,
			EndogenousProbeEmissionWavelength->Null,
			EndogenousProbeExcitationWavelength->Null,
			EndogenousProbeFluorophore->Null,
			Standard->Null,
			StandardVolume->Null,
			StandardStorageCondition->Null,
			StandardPrimerPair->Null,
			StandardForwardPrimerStorageCondition->Null,
			StandardReversePrimerStorageCondition->Null,
			StandardForwardPrimerVolume->Null,
			StandardReversePrimerVolume->Null,
			SerialDilutionFactor->Null,
			NumberOfDilutions->Null,
			NumberOfStandardReplicates->Null,
			StandardProbe->Null,
			StandardProbeStorageCondition->Null,
			StandardProbeVolume->Null,
			StandardProbeEmissionWavelength->Null,
			StandardProbeExcitationWavelength->Null,
			StandardProbeFluorophore->Null,
			DuplexStainingDye->Null,
			DuplexStainingDyeVolume->Null,
			DuplexStainingDyeExcitationWavelength->Null,
			DuplexStainingDyeEmissionWavelength->Null,
			MeltingCurve->False,
			MeltingCurveStartTemperature->Null,
			MeltingCurveEndTemperature->Null,
			PreMeltingCurveRampRate->Null,
			MeltingCurveRampRate->Null,
			MeltingCurveTime->Null,
			(*Shared options*)
			MoatSize->Null,
			MoatBuffer->Null,
			MoatVolume->Null,
			Email->resolvedEmail,
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions
		}]
	];

	(*Gather the tests*)
	allTests=Cases[Flatten[{
		discardedTest,
		discardedArrayCardTest,
		tooManySamplesTest,
		arrayCardContentsMismatchTest,
		precisionTests,
		validNameTest,
		invalidArrayCardReagentOptionsTest,
		invalidArrayCardEndogenousOptionsTest,
		invalidArrayCardStandardOptionsTest,
		invalidArrayCardDuplexStainingDyeOptionsTest,
		invalidArrayCardMeltingCurveOptionsTest,
		invalidArrayCardMoatOptionsTest,
		invalidArrayCardReplicateOptionTest,
		invalidDyeTests,
		referenceDyeExcitationEmissionPairTest,
		probeExcitationEmissionPairTest,
		invalidThermocyclerTest,
		rtOptionTest,
		activationOptionTest,
		annealingOptionTest,
		unknownMasterMixTest,
		excessiveVolumeTest
	}],_EmeraldTest];

	(*Return the output as we desire it*)
	outputSpecification/.{Result->resolvedOptions,Tests->allTests}
];


(* ::Subsubsection::Closed:: *)
(*fluorophoreComponentPackets*)


DefineOptions[
	fluorophoreComponentPackets,
	Options :> {CacheOption}
];

(* If passed fulfillment models, first download to the bottom of each of their composition trees and fetch a packet containing fluorescence information *)
fluorophoreComponentPackets[myModel:ObjectP[{Object[Sample], Model[Sample], Model[Molecule]}], myOps:OptionsPattern[]] := First[lookupFluorophoreComponents[{myModel}, myOps]];
fluorophoreComponentPackets[myMixedModels:{ObjectP[{Object[Sample], Model[Sample], Model[Molecule]}]..}, myOps:OptionsPattern[]] := Module[
	{listedInput, allFieldSpecs, allPackets, flattenedPacketsByInput, fluorophoresByInput},

	listedInput = ToList[myMixedModels];

	allFieldSpecs = Map[
		If[MatchQ[#, ObjectP[Model[Molecule]]],
			{Packet[Fluorescent, FluorescenceLabelingTarget, FluorescenceExcitationMaximums, FluorescenceEmissionMaximums]},
			{Packet[Field[Composition[[All,2]]][{Name, Fluorescent, FluorescenceLabelingTarget, FluorescenceExcitationMaximums, FluorescenceEmissionMaximums}]]}
		]&,
		listedInput
	];

	(* Get packets for all the identity models underlying the composition of each fulfillment model *)
	allPackets = Quiet[
		Download[listedInput, allFieldSpecs, Cache->OptionValue[Cache]],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* Sanitize and flatten lists of packets for each input *)
	flattenedPacketsByInput = DeleteCases[Flatten[#], $Failed|Null]& /@ allPackets;

	(* For each input, pick out the components that are fluorophores *)
	fluorophoresByInput = Cases[#, AssociationMatchP[<|Fluorescent->True|>, RequireAllKeys->False, AllowForeignKeys->True]]& /@ flattenedPacketsByInput

];


(* ::Subsubsection::Closed:: *)
(*lookupPrimaryFluorophore*)


DefineOptions[
	primaryFluorophoreObject,
	Options :> {CacheOption}
];

primaryFluorophoreObject[myModel:ObjectP[{Object[Sample], Model[Sample], Model[Molecule]}], myOps:OptionsPattern[]] := First[primaryFluorophorePacket[{myModel}, myOps]];
primaryFluorophoreObject[myMixedModels:{ObjectP[{Object[Sample], Model[Sample], Model[Molecule]}]..}, myOps:OptionsPattern[]] := Module[
	{fluorophorePackets, primaryFluorophorePackets},

	(* Get packets for all components of each model with Fluorophore->True *)
	fluorophorePackets = fluorophoreComponentPackets[myMixedModels, myOps];

	(* For each input model, decide which fluorophore should be considered the "primary" one *)

	(* In each case, select "primary" fluorophore packet based on the following logic:
		- If there's no fluorophore in the Composition, just pass on an empty association
		- If there's just one fluorophore in the Composition, use it
		- If there are multiple fluorophores in the Composition, take the one with the shortest wavelength *)
	primaryFluorophorePackets = Map[
		Switch[Length[#],
			0, <||>,
			1, First[#],
			GreaterP[1], First[Sort[#, FluorescenceExcitationMaximums]]
		]&,
		fluorophorePackets
	];

	(* From each fluorophore packet picked out above, look up the fluorophore object *)
	Lookup[primaryFluorophorePackets, Object, Null]

	(* Wavelength lookup stuff *)
	(*
	expectedProbeExcitations = Lookup[probeAmplificationFluorophorePackets, FluorescenceExcitationMaximums, Null];
	expectedProbeEmissions = Lookup[probeAmplificationFluorophorePackets, FluorescenceEmissionMaximums, Null];

	(* Figure out the closest instrument-compatible Ex/Ems for the fluorophores above *)
	instrumentAdjustedExpectedProbeExcitation = Map[
		If[!MatchQ[#, Null],
			First[Nearest[List@@qPCRExcitationWavelengthP, #]],
			Null
		]&,
		expectedProbeExcitations
	];
	instrumentAdjustedExpectedProbeEmission = Map[
		If[!MatchQ[#, Null],
			First[Nearest[List@@qPCREmissionWavelengthP, #]],
			Null
		]&,
		expectedProbeEmissions
	];
	*)

];


(* ::Subsubsection::Closed:: *)
(*qPCRResourcePackets*)


DefineOptions[qPCRResourcePackets,
	Options:>{CacheOption,HelperOutputOption}
];


(*---384-well plate overload---*)
qPCRResourcePackets[
	myPackagerSampleInputs:{ObjectP[Object[Sample]]..},
	myPackagerPrimerInputs:ListableP[{{ObjectP[{Model[Sample], Object[Sample]}],ObjectP[{Model[Sample], Object[Sample]}]}..}|Null],
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	myCollapsedResolvedOptions:{___Rule},
	myOptions:OptionsPattern[]
]:=Module[{
	outputSpecification,output,gatherTests,messages,packet,allResources,cache,allSamples,basicSamplePackets,updatedCache,
	samplesInResources,containersIn,containersInResources,assayPlateResource,plateSealResource, estimatedRunTime,instrumentResource,previewRule,optionsRule,testsRule,resultRule,
	fulfillable,frqTests,
	reverseTranscriptionQ, reverseTranscriptionTemp, reverseTranscriptionTime, reverseTranscriptionRampRate, activationQ, activationTemp, activationTime, activationRampRate,
	numberOfCycles,	denaturationTemp, denaturationTime, denaturationRampRate,	annealingQ, annealingTemp, annealingTime, annealingRampRate, extensionTemp, extensionTime,
	extensionRampRate, meltingQ, meltingStartTemp, meltingEndTemp, preMeltRampRate, meltingRampRate, forwardPrimers, reversePrimers, standardForwardPrimers, standardReversePrimers,
	endogenousForwardPrimers, endogenousReversePrimers, takeIndexLeavingNull, takeAllIndexLeavingNull, linkIfNonNull, dataAcquisitionEstimate,

	samplesInVolumeRules, standardsVolumeRules, combinedSamplesAndStandardsRules, uniqueSampleObjectsAndVolumesAssoc,
	analytePrimerVolumeRules, analyteProbeVolumeRules, endogenousPrimerVolumeRules, endogenousProbeVolumeRules,
	expandedStandards, expandedStandardForwardPrimers, expandedStandardReversePrimers, expandedStandardForwardPrimerVolumes, expandedStandardReversePrimerVolumes,
	expandedStandardProbes, expandedStandardProbeVolumes, expandedStandardDilutions, expandedStandardProbeExcitations, expandedStandardProbeEmissions, expandedStandardProbeFluorophores,
	standardPrimerVolumeRules, standardProbeVolumeRules, allPrimerProbeVolumeRules,
	groupedPrimersProbesAndVolumes, primersProbesTotalVolumes, primerProbeResourceLookup, bufferResource, totalNumberOfAssayWells, masterMixNumberOfSourceWells,
	masterMixVolumeRequired, masterMixResource,

	liquidHandlerContainers, listedSampleContainers, liquidHandlerContainerDownload, sampleContainersIn, liquidHandlerContainerMaxVolumes, intNumberOfReplicates,
	primersWithReplicates, samplesWithReplicates, optionsWithReplicates, expandedSampleOrAliquotVolumes, uniqueSampleResources, uniqueSampleResourceLookup,
	uniquePrimerProbeVolumeAssoc, probes, standardProbes, endogenousProbes, rawSamplesWithReplicates, standardSamples, masterMixContainer,masterMixSourceVesselDeadVolume,
	expandedForwardPrimerStorageConditions, expandedReversePrimerStorageConditions, expandedProbeStorageConditions, resolvedBuffer,
	resolvedBufferVolume, resolvedMoatBuffer, resolvedMoatSize, moatBufferResource
},

	(* Local helpers for taking [[All,All,1]] or [[All,1]] of primer options, allowing for top-level Nulls *)
	takeAllIndexLeavingNull[input_, index_Integer] := If[MatchQ[input, Null], Null, input[[All,index]]];
	takeIndexLeavingNull[input_, index_Integer] := If[MatchQ[input, Null], Null, input[[index]]];


	(* pull out the Output option and make it a list *)
	outputSpecification=Lookup[ToList[myOptions],Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; If True, then silence the messages *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Get the cache *)
	cache=Lookup[ToList[myOptions],Cache];


	(* === Get information to help decide which container should be used for each resource === *)

	(*In case we need to prepare the resource, use one from the prepended list of liquid handler-compatible containers (Engine uses the first requested container if it has to make a transfer or stock solution)*)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(* Build a list of all samples for which resources will be generated, and download basic packets to allow for Name->Object interconversion *)
	allSamples = DeleteCases[
		Flatten[{
			myPackagerSampleInputs,
			myPackagerPrimerInputs,
			Lookup[myResolvedOptions, {
				Probe,
				EndogenousPrimerPair, EndogenousProbe,
				StandardPrimerPair, StandardProbe,
				MasterMix, Buffer, DuplexStainingDye, ReferenceDye
			}]
		}],
		Null
	];

	(* Make a Download call to get the containers of the input samples *)
	{listedSampleContainers, liquidHandlerContainerDownload, basicSamplePackets}=Quiet[
		Download[
			{
				myPackagerSampleInputs,
				liquidHandlerContainers,
				allSamples
			},
			{
				{Container[Object]},
				{MaxVolume},
				{Packet[Object, Name]}
			},
			Cache->cache
		],
		{Download::FieldDoesntExist}
	];

	(* Update the cache with the barebones sample packets we downloaded above *)
	updatedCache = FlattenCachePackets[{cache, basicSamplePackets}];

	(* Find the list of input sample containers *)
	sampleContainersIn=DeleteDuplicates[Flatten[listedSampleContainers]];

	(* Find the MaxVolume of all of the liquid handler compatible containers *)
	liquidHandlerContainerMaxVolumes=Flatten[liquidHandlerContainerDownload,1];


	(* === Expand inputs and index-matched options to take into account the NumberOfReplicates option === *)

	(* intNumberOfReplicates replaces Null with 1 for calculation purposes in number of replicates *)
	intNumberOfReplicates = Lookup[myResolvedOptions, NumberOfReplicates]/.{Null->1};

	(* Expand the input primers, making sure they're all in ObjectReference form *)
	primersWithReplicates = Flatten[Table[#,intNumberOfReplicates]&/@myPackagerPrimerInputs, 1];

	(* Expand the index-matched inputs for the NumberOfReplicates *)
	{rawSamplesWithReplicates,optionsWithReplicates} =expandNumberOfReplicates[ExperimentqPCR, myPackagerSampleInputs, myResolvedOptions];

	(* Make sure all samples are in ObjectReference form *)
	samplesWithReplicates = Download[rawSamplesWithReplicates, Object];


	(* === Look up object fields required for resource generation === *)
	(* - Split up primer pairs into forward and reverse
		 - Convert all objects to ObjectReference form to ensure that resource consolidation and lookup can be done faithfully *)

	(* Analyte primers and probes *)
	forwardPrimers = Download[primersWithReplicates[[All, All, 1]], Object];
	reversePrimers = Download[primersWithReplicates[[All, All, 2]], Object];
	probes = Download[Lookup[optionsWithReplicates, Probe], Object];

	(* Standard samples, primers, and probes
		Be tolerant of option values that have resolved to Null when teasing apart forward and reverse primers *)
	standardSamples = Download[Lookup[optionsWithReplicates, Standard], Object];
	standardForwardPrimers = Download[Replace[Lookup[optionsWithReplicates, StandardPrimerPair], Null->{}][[All, 1]], Object];
	standardReversePrimers = Download[Replace[Lookup[optionsWithReplicates, StandardPrimerPair], Null->{}][[All, 2]], Object];
	standardProbes = Download[Lookup[optionsWithReplicates, StandardProbe], Object];

	(* Endogenous primers and probes *)
	(* Have to do something fancier than [[All,1]] / [[All,2]] here since indexes that have no endogenous primer pairs are just Null *)
	endogenousForwardPrimers = Download[takeIndexLeavingNull[#, 1]& /@ Lookup[optionsWithReplicates, EndogenousPrimerPair], Object];
	endogenousReversePrimers = Download[takeIndexLeavingNull[#, 2]& /@ Lookup[optionsWithReplicates, EndogenousPrimerPair], Object];
	endogenousProbes = Download[Lookup[optionsWithReplicates, EndogenousProbe], Object];


	(* === Generate SamplesIn, Standards, and ContainersIn resources === *)

	(* First, expand all standard fields to reflect dilution series and standard replicates using shared helper
		Flatten because we don't need replicates to be grouped, which the function does by default
		If standardSamples is Null, this will "expand" into a list of {} *)
	{expandedStandards, expandedStandardForwardPrimers, expandedStandardReversePrimers, expandedStandardForwardPrimerVolumes, expandedStandardReversePrimerVolumes,
	expandedStandardProbes, expandedStandardProbeVolumes, expandedStandardDilutions, expandedStandardProbeExcitations, expandedStandardProbeEmissions, expandedStandardProbeFluorophores} = Flatten /@ expandqPCRStandards[
		standardSamples, standardForwardPrimers, standardReversePrimers, Lookup[myResolvedOptions, StandardForwardPrimerVolume], Lookup[myResolvedOptions, StandardReversePrimerVolume],
		standardProbes, Lookup[myResolvedOptions, StandardProbeVolume], Lookup[myResolvedOptions, NumberOfStandardReplicates], Lookup[myResolvedOptions, NumberOfDilutions],
		Lookup[myResolvedOptions, SerialDilutionFactor], Lookup[myResolvedOptions, StandardProbeExcitationWavelength], Lookup[myResolvedOptions, StandardProbeEmissionWavelength],
		Lookup[myResolvedOptions, StandardProbeFluorophore]
	];

	(* Make a list of volumes that are index matched to the samples in, with the SampleVolume if no Aliquotting is ocurring, or the AliquotAmount if Aliquotting is happening *)
	expandedSampleOrAliquotVolumes=MapThread[
		If[MatchQ[#2,Null],
			#1,
			#2
		]&,
		Lookup[optionsWithReplicates, {SampleVolume, AliquotAmount}]
	];

	(* Generate sample volume rules based on expanded lists above *)
	samplesInVolumeRules = MapThread[Rule, {samplesWithReplicates, expandedSampleOrAliquotVolumes}];

	(* To be safe, reserve 100 uL of each standard sample. This accounts for dead volume and the possibility of large standard volumes and a few replicates.
		DON'T use expanded standards here, because we only need one aliquot of standard sample for the first well in each dilution series
		Replace Null (the desired ResolvedOptions value) with {} (the eventual field value) to avoid MapThread errors *)
	(* TODO: Change to reserve enough of each standard sample for:
			- 5 uL dead volume in standard source container
			- 5 uL dead volume in standard aliquot container (first well of dilution curve)
			- All undiluted standard aliquots into assay plate (StandardVolume * NumberOfStandardReplicates for each standard)
			- The amount that will be transferred from the undiluted standard sample into the first standard dilution *)
	standardsVolumeRules = MapThread[Rule, {Replace[standardSamples, Null->{}], ConstantArray[100 Microliter, Length[standardSamples]]}];

	(* Combine SamplesIn and Standards so they can be treated together in case there's overlap *)
	combinedSamplesAndStandardsRules = Join[samplesInVolumeRules, standardsVolumeRules];

	(* Merge any entries with duplicate keys, totaling the values *)
	uniqueSampleObjectsAndVolumesAssoc = Merge[combinedSamplesAndStandardsRules, Total];

	(* Generate a resource for each unique item, returning a lookup table of item -> resource
		In each case, set a floor of 50 microliters since this is the per-prep-plate-well dead volume we've set in the compiler *)
	uniqueSampleResourceLookup = KeyValueMap[
		Function[{object, amount},
			Module[{containers},

				(* Figure out which liquid handler compatible containers can be used for this resource *)
				containers = PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[amount]];

				(* Assemble resource rule *)
				object -> Resource[
					Sample->object,
					Amount->amount,
					Name->ToString[Unique[]],
					Container->containers
				]
			]
		],
		uniqueSampleObjectsAndVolumesAssoc
	];

	(* pull out the container each sample is in and make a resource for each unique container *)
	containersInResources=(Resource[Sample->Download[#,Object]]&) /@ sampleContainersIn;


	(* === Generate resources for all primers and probes, even though they don't formally get used until the assay plate prep SM === *)

	(* --- Gather up analyte primer and probe volume requirements --- *)
	analytePrimerVolumeRules = Join[
		MapThread[Rule, {Flatten[forwardPrimers], Flatten[Lookup[optionsWithReplicates, ForwardPrimerVolume]]}],
		MapThread[Rule, {Flatten[reversePrimers], Flatten[Lookup[optionsWithReplicates, ReversePrimerVolume]]}]
	];
	(* Replace Null with {} to allow for transposition even if some or all indexes have Null placeholders for probes and their corresponding volumes *)
	analyteProbeVolumeRules = MapThread[Rule, Flatten /@ {probes/.Null->{}, Lookup[optionsWithReplicates, ProbeVolume]/.Null->{}}];

	(* --- Gather up endogenous primer and probe volume requirements --- *)
	endogenousPrimerVolumeRules = Join[
		MapThread[Rule, {endogenousForwardPrimers, Lookup[optionsWithReplicates, EndogenousForwardPrimerVolume]}],
		MapThread[Rule, {endogenousReversePrimers, Lookup[optionsWithReplicates, EndogenousReversePrimerVolume]}]
	];
	endogenousProbeVolumeRules = MapThread[Rule, {endogenousProbes/.Null->{}, Lookup[optionsWithReplicates, EndogenousProbeVolume]/.Null->{}}];

	(* --- Gather up standard primer and probe volumes --- *)
	standardPrimerVolumeRules = Join[
		MapThread[Rule, {expandedStandardForwardPrimers, expandedStandardForwardPrimerVolumes}],
		MapThread[Rule, {expandedStandardReversePrimers, expandedStandardReversePrimerVolumes}]
	];
	standardProbeVolumeRules = MapThread[Rule, {expandedStandardProbes, expandedStandardProbeVolumes}];

	(* --- Put it all together --- *)
	(* Combine all primers and probes to get total volume of each that will be required *)
	allPrimerProbeVolumeRules = DeleteCases[
		Join[analytePrimerVolumeRules, analyteProbeVolumeRules, endogenousPrimerVolumeRules, endogenousProbeVolumeRules, standardPrimerVolumeRules, standardProbeVolumeRules],
		HoldPattern[Null->_] | HoldPattern[{}->_]
	];

	(* Merge any entries with duplicate keys, totaling the values *)
	uniquePrimerProbeVolumeAssoc = Merge[allPrimerProbeVolumeRules, Total];

	(* Generate a resource for each unique item, returning a lookup table of item -> resource
		In each case, add 5 microliters since this is the per-prep-plate-well dead volume we've set in the compiler
		Include the Link head here because it makes it much easier to handle lists that may contain Null placeholders when replacing below *)
	primerProbeResourceLookup = KeyValueMap[
		Function[{object, amount},
			Module[{adjustedAmount, containers},

				(* Add extra to account for container dead volume *)
				adjustedAmount = amount + Experiment`Private`qPCRPrepDeadVolume;

				(* Figure out which liquid handler compatible containers can be used for this resource *)
				containers = PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[adjustedAmount]];

				(* Assemble resource rule *)
				object -> Link[Resource[
					Sample->object,
					Amount->adjustedAmount,
					Name->ToString[Unique[]],
					Container->containers
				]]
			]
		],
		uniquePrimerProbeVolumeAssoc
	];


	(* === Generate resources for Master Mix, Buffer, and MoatBuffer === *)

	resolvedBuffer = Lookup[optionsWithReplicates, Buffer];
	resolvedBufferVolume = Lookup[optionsWithReplicates, BufferVolume];

	resolvedMoatBuffer = Lookup[optionsWithReplicates, MoatBuffer];
	resolvedMoatVolume = Lookup[optionsWithReplicates, MoatVolume];
	resolvedMoatSize = Lookup[optionsWithReplicates, MoatSize];

	(* --- Make Buffer and MoatBuffer resource(s) at the same time, combining if they're the same buffer --- *)
	(* Only make a resource here if each buffer is needed (options will have resolved to Null if no buffer is needed) *)
	{bufferResource, moatBufferResource} = Switch[{resolvedBuffer, resolvedMoatBuffer},
		(* Both are non-Null and they are the same, combine volumes and make a single resource *)
		{Repeated[obj:ObjectP[], {2}]},
		  Module[{sharedResource},
				(* Total buffer needed will be buffer dead volume plus buffer needed plus moat buffer needed.
					Just specify an excess since this is going in a reagent trough anyway. *)
				sharedResource = Link[Resource[
					Sample->resolvedBuffer,
					Amount->50 Milliliter,
					Container->Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"],
					Name->ToString[Unique[]]
				]];
				{sharedResource, sharedResource}
			],
		{ObjectP[], ObjectP[]},
			{
				Link[Resource[
					Sample->resolvedBuffer,
					Amount->50 Milliliter,
					Container->Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"],
					Name->ToString[Unique[]]
				]],
				Link[Resource[
					Sample->resolvedMoatBuffer,
					Amount->50 Milliliter,
					Container->Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"],
					Name->ToString[Unique[]]
				]]
			},
		{ObjectP[], Null},
			{
				Link[Resource[
					Sample->resolvedBuffer,
					Amount->50 Milliliter,
					Container->Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"],
					Name->ToString[Unique[]]
				]],
				Null
			},
		{Null, ObjectP[]},
			{
				Null,
				Link[Resource[
					Sample->resolvedMoatBuffer,
					Amount->50 Milliliter,
					Container->Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"],
					Name->ToString[Unique[]]
				]]
			},
		{Null, Null},
			{Null, Null}
	];


	(* --- Master mix resource - request enough to account for usage of up to 8 source wells, dead volume of 50 uL --- *)
	(* Figure out how many destination wells we'll have *)
	totalNumberOfAssayWells = (Length[samplesWithReplicates] + Length[Flatten[expandedStandards]]);

	(* Figure out how many source wells we'll use, with a max of 8
		Can reach into every other well in a given column simultaneously and want to maximize pipetting parallelism *)
	masterMixNumberOfSourceWells = Min[Ceiling[totalNumberOfAssayWells / 2], 8];

	(* Figure out how much volume that equates to, taking the following into account:
	 	- Per-prep-plate-well dead volume (included in prep plate aliquots)
		- Per-prep-plate-well 10% overage (included in prep plate aliquots)
	 *)
	masterMixVolumeRequired = masterMixNumberOfSourceWells * (Experiment`Private`qPCRPrepDeadVolume + Ceiling[totalNumberOfAssayWells / masterMixNumberOfSourceWells] * Lookup[optionsWithReplicates, MasterMixVolume] * 1.1);

	(* Figure out what liquid handler compatible container may be used for the master mix *)
	masterMixContainer=PreferredContainer[masterMixVolumeRequired,LiquidHandlerCompatible->True];
	
	(* Calculate master mix source vessel dead volume: 2% container volume is added to ensure complete transfer to all prep wells is possible *)
	masterMixSourceVesselDeadVolume=0.02*(masterMixContainer/.Thread[liquidHandlerContainers->liquidHandlerContainerMaxVolumes]);
	
	(* Make the resource *)
	masterMixResource = Link[Resource[
		Sample->Lookup[optionsWithReplicates, MasterMix],
		Amount->masterMixVolumeRequired+masterMixSourceVesselDeadVolume,
		Container->masterMixContainer
	]];

	(* === Generate resources for consumables that need to be referenced in procedure === *)

	(* Generate a resource for the assay plate *)
	assayPlateResource = Link[Resource[Sample->Model[Container, Plate, "384-well qPCR Optical Reaction Plate"]]];

	(* Generate a resource for the plate seal *)
	plateSealResource = Link[Resource[Sample -> Model[Item, PlateSeal, "qPCR Plate Seal, Clear"]]];

	(* Expand the storage condition fields to match the length of primers if needed *)
	expandedForwardPrimerStorageConditions=MapThread[
		If[MatchQ[#2,SampleStorageTypeP|Disposal],
			ConstantArray[#2,Length[#1]],
			#2
		]&,
		{primersWithReplicates,Lookup[optionsWithReplicates, ForwardPrimerStorageCondition]}
	];
	expandedReversePrimerStorageConditions=MapThread[
		If[MatchQ[#2,SampleStorageTypeP|Disposal],
			ConstantArray[#2,Length[#1]],
			#2
		]&,
		{primersWithReplicates,Lookup[optionsWithReplicates, ReversePrimerStorageCondition]}
	];
	expandedProbeStorageConditions=MapThread[
		If[MatchQ[#2,SampleStorageTypeP|Disposal],
			ConstantArray[#2,Length[#1]],
			#2
		]&,
		{probes,Lookup[optionsWithReplicates, ProbeStorageCondition]}
	];


	(* === Calculate an estimate of how long the run will take === *)

	(* First, store the relevant parameters in variables for use below *)
	{reverseTranscriptionQ, reverseTranscriptionTemp, reverseTranscriptionTime, reverseTranscriptionRampRate, activationQ, activationTemp, activationTime, activationRampRate,
	numberOfCycles,	denaturationTemp, denaturationTime, denaturationRampRate,	annealingQ, annealingTemp, annealingTime, annealingRampRate, extensionTemp, extensionTime,
	extensionRampRate, meltingQ, meltingStartTemp, meltingEndTemp, preMeltRampRate, meltingRampRate} = Lookup[
		optionsWithReplicates,
		{ReverseTranscription, ReverseTranscriptionTemperature, ReverseTranscriptionTime, ReverseTranscriptionRampRate, Activation, ActivationTemperature, ActivationTime, ActivationRampRate,
		NumberOfCycles, DenaturationTemperature, DenaturationTime, DenaturationRampRate, PrimerAnnealing, PrimerAnnealingTemperature, PrimerAnnealingTime, PrimerAnnealingRampRate,
		ExtensionTemperature, ExtensionTime, ExtensionRampRate, MeltingCurve, MeltingCurveStartTemperature, MeltingCurveEndTemperature, PreMeltingCurveRampRate, MeltingCurveRampRate}
	];

	(* Add up all the times for all stages that are being done *)
	estimatedRunTime = Total[{
		(* If doing one-step RT:
			- Time to ramp to RT temp based on ramp rate and temp, assuming starting at 25C
			- RT time *)
		If[reverseTranscriptionQ,
			((reverseTranscriptionTemp - 25 Celsius) / reverseTranscriptionRampRate) + reverseTranscriptionTime,
			0 Second
		],

		(* If Activation->True:
			- Time to ramp to activation temp
			- Activation time *)
		If[activationQ,
			(Abs[activationTemp - If[reverseTranscriptionQ, reverseTranscriptionTemp, 25 Celsius]] / activationRampRate) + activationTime,
			0 Second
		],

		(* Prep for cycling:
			- Time to ramp to cycle start temp (denaturation temp) *)
		Abs[
			If[activationQ,
				activationTemp,
				If[reverseTranscriptionQ, reverseTranscriptionTemp, 25 Celsius]
			] - denaturationTemp
		] / denaturationRampRate,

		(* For each cycle:
			- Denaturation time
			- If annealing separately from extension, annealing ramp time and annealing time
			- Extension ramp time and extension time *)
		Plus[
			denaturationTime,
			If[annealingQ,
				(Abs[denaturationTemp - annealingTemp] / annealingRampRate) + annealingTime,
				0 Second
			],
			Abs[If[annealingQ, annealingTemp, denaturationTemp] - extensionTemp] / extensionRampRate,
			extensionTime,
			30 Second (* Semi-empirically determined fudge factor for read time after each extension *)
		] * numberOfCycles,

		(* If MeltingCurve\[Rule]True,
			- Time to ramp to pre-melt denaturation (hard-coded)
			- Pre-melt denaturation time (hard-coded)
			- Time to ramp to melting start point
			- Melting curve time
			- Melting curve end hold time *)
		If[meltingQ,
			Plus[
				Abs[extensionTemp - 95 Celsius] / (1.6 Celsius/Second),
				1 Minute,
				Abs[95 Celsius - meltingStartTemp] / preMeltRampRate,
				(meltingEndTemp - meltingStartTemp) / meltingRampRate
			],
			0 Second
		]
	}];

	(* Estimate that data acquisition will take run time plus ~30 minutes of set up / tear down time *)
	dataAcquisitionEstimate = Ceiling[estimatedRunTime + 30 Minute, 5 Minute];

	(* if the instrument specified is the QuantStudio 7 Flex OR the ViiA 7, make the resource for both of them *)
	instrumentResource=With[{instrument = Lookup[optionsWithReplicates, Instrument]},
		(* Model[Instrument, Thermocycler, "ViiA 7"] and Model[Instrument, Thermocycler, "QuantStudio 7 Flex"] *)
		If[MatchQ[instrument, ObjectP[{Model[Instrument, Thermocycler, "id:D8KAEvdqzXYk"], Model[Instrument, Thermocycler, "id:R8e1PjeaXle4"]}]],
			Resource[Instrument -> {Model[Instrument, Thermocycler, "id:D8KAEvdqzXYk"], Model[Instrument, Thermocycler, "id:R8e1PjeaXle4"]}, Time -> dataAcquisitionEstimate],
			Resource[Instrument -> instrument, Time -> dataAcquisitionEstimate]
		]
	];

	(* Local helper to add links if option value is non-Null; leave as-is if NullP (either Null or listed Null to maintain correct index matching) *)
	linkIfNonNull[resolvedOps_List, optionName_Symbol] := With[{optionVal = Lookup[resolvedOps, optionName]},
		If[!NullQ[optionVal], ReplaceAll[optionVal, obj:ObjectP[]->Link[obj]], optionVal]
	];

	(* TODO(?): Null out all master-switch-dependent variables if their corresponding master switches are off *)

	packet=Join[
		Association[
			Type->Object[Protocol,qPCR],
			Object->CreateID[Object[Protocol,qPCR]],
			Replace[SamplesIn]->Map[Link[#,Protocols]&, Replace[samplesWithReplicates, uniqueSampleResourceLookup, {1}]],
			Replace[ContainersIn]->Map[Link[#,Protocols]&, DeleteDuplicates[containersInResources]],
			Replace[SamplesInStorage]->Lookup[optionsWithReplicates,SamplesInStorageCondition],
			Instrument->Link[instrumentResource],
			RunTime->estimatedRunTime,
			AssayPlate->assayPlateResource,
			PlateSeal->plateSealResource,

			ReactionVolume->Lookup[optionsWithReplicates,ReactionVolume],
			MasterMix->masterMixResource,
			MasterMixVolume->Lookup[optionsWithReplicates,MasterMixVolume],
			MasterMixStorageCondition->Lookup[optionsWithReplicates,MasterMixStorageCondition],
			StandardVolume->Lookup[optionsWithReplicates,StandardVolume],
			Buffer->bufferResource,

			AssayPlateThermalBlock->Link[Resource[Sample->Model[Part,ThermalBlock,"ViiA 7 384-well Plate Thermal Block"]]],
			AssayPlateTray->Link[Resource[Sample->Model[Container,Rack,"ViiA 7 384-well Plate Tray"]]],
			Replace[SampleVolumes]->Lookup[optionsWithReplicates,SampleVolume],
			Replace[BufferVolumes]->Lookup[optionsWithReplicates,BufferVolume],

			MoatSize->Lookup[optionsWithReplicates, MoatSize],
			MoatBuffer->moatBufferResource,
			MoatVolume->Lookup[optionsWithReplicates, MoatVolume],

			ReverseTranscription->Lookup[optionsWithReplicates,ReverseTranscription],
			ReverseTranscriptionTime->Lookup[optionsWithReplicates,ReverseTranscriptionTime],
			ReverseTranscriptionTemperature->Lookup[optionsWithReplicates,ReverseTranscriptionTemperature],
			ReverseTranscriptionRampRate->Lookup[optionsWithReplicates,ReverseTranscriptionRampRate],

			Activation->Lookup[optionsWithReplicates,Activation],
			ActivationTime->Lookup[optionsWithReplicates,ActivationTime],
			ActivationTemperature->Lookup[optionsWithReplicates,ActivationTemperature],
			ActivationRampRate->Lookup[optionsWithReplicates,ActivationRampRate],

			DenaturationTime->Lookup[optionsWithReplicates,DenaturationTime],
			DenaturationTemperature->Lookup[optionsWithReplicates,DenaturationTemperature],
			DenaturationRampRate->Lookup[optionsWithReplicates,DenaturationRampRate],

			PrimerAnnealing->Lookup[optionsWithReplicates,PrimerAnnealing],
			PrimerAnnealingTime->Lookup[optionsWithReplicates,PrimerAnnealingTime],
			PrimerAnnealingTemperature->Lookup[optionsWithReplicates,PrimerAnnealingTemperature],
			PrimerAnnealingRampRate->Lookup[optionsWithReplicates,PrimerAnnealingRampRate],

			ExtensionTime->Lookup[optionsWithReplicates,ExtensionTime],
			ExtensionTemperature->Lookup[optionsWithReplicates,ExtensionTemperature],
			ExtensionRampRate->Lookup[optionsWithReplicates,ExtensionRampRate],
			NumberOfCycles->Lookup[optionsWithReplicates,NumberOfCycles],

			MeltingCurve->Lookup[optionsWithReplicates,MeltingCurve],
			MeltingCurveStartTemperature->Lookup[optionsWithReplicates,MeltingCurveStartTemperature],
			MeltingCurveEndTemperature->Lookup[optionsWithReplicates,MeltingCurveEndTemperature],
			PreMeltingCurveRampRate->Lookup[optionsWithReplicates,PreMeltingCurveRampRate],
			MeltingCurveRampRate->Lookup[optionsWithReplicates,MeltingCurveRampRate],
			MeltingCurveTime->Lookup[optionsWithReplicates,MeltingCurveTime],

			(* Add fake links to these fields because it has been decreed that it should be this way *)
			Replace[ForwardPrimers] -> Replace[forwardPrimers, obj:ObjectP[]:>Link[obj], {2}],
			Replace[ReversePrimers] -> Replace[reversePrimers, obj:ObjectP[]:>Link[obj], {2}],
			(* Flatten out to allow Resources fields to contain links *)
			Replace[ForwardPrimerResources] -> Replace[Flatten[forwardPrimers], primerProbeResourceLookup, {1}],
			Replace[ReversePrimerResources] -> Replace[Flatten[reversePrimers], primerProbeResourceLookup, {1}],
			Replace[ForwardPrimerStorageConditions] -> expandedForwardPrimerStorageConditions,
			Replace[ReversePrimerStorageConditions] -> expandedReversePrimerStorageConditions,
			Replace[ForwardPrimerVolumes] -> Lookup[optionsWithReplicates, ForwardPrimerVolume],
			Replace[ReversePrimerVolumes] -> Lookup[optionsWithReplicates, ReversePrimerVolume],

			(* Add fake links to this field because it has been decreed that it should be this way *)
			Replace[Probes] -> Replace[probes, obj:ObjectP[]:>Link[obj], {2}],
			(* Flatten out to allow Resources field to contain links *)
			Replace[ProbeResources] -> Replace[Flatten[probes], primerProbeResourceLookup, {1}],
			Replace[ProbeStorageConditions] -> expandedProbeStorageConditions,
			Replace[ProbeVolumes] -> Lookup[optionsWithReplicates,ProbeVolume],

			Replace[ProbeExcitationWavelengths]->Lookup[optionsWithReplicates,ProbeExcitationWavelength],
			Replace[ProbeEmissionWavelengths]->Lookup[optionsWithReplicates,ProbeEmissionWavelength],
			Replace[ProbeFluorophores] -> Link /@ Lookup[optionsWithReplicates, ProbeFluorophore],

			(* No resources for duplex dye right now because we don't expect people to use them manually (may disallow explicitly) *)
			DuplexStainingDye->Link[Lookup[optionsWithReplicates,DuplexStainingDye]],
			DuplexStainingDyeVolume->Lookup[optionsWithReplicates,DuplexStainingDyeVolume],
			DuplexStainingDyeExcitationWavelength->Lookup[optionsWithReplicates,DuplexStainingDyeExcitationWavelength],
			DuplexStainingDyeEmissionWavelength->Lookup[optionsWithReplicates,DuplexStainingDyeEmissionWavelength],

			(* No resource for reference dye right now because we don't expect people to use them manually (may disallow explicitly) *)
			ReferenceDye->Link[Lookup[optionsWithReplicates,ReferenceDye]],
			ReferenceDyeVolume->Lookup[optionsWithReplicates,ReferenceDyeVolume],
			ReferenceDyeExcitationWavelength->Lookup[optionsWithReplicates, ReferenceDyeExcitationWavelength],
			ReferenceDyeEmissionWavelength->Lookup[optionsWithReplicates, ReferenceDyeEmissionWavelength],

			Replace[Standards]->Replace[standardSamples, uniqueSampleResourceLookup, {1}],
			Replace[StandardStorageConditions]->Lookup[optionsWithReplicates,StandardStorageCondition],

			Replace[StandardForwardPrimers] -> Replace[standardForwardPrimers, primerProbeResourceLookup, {1}],
			Replace[StandardReversePrimers] -> Replace[standardReversePrimers, primerProbeResourceLookup, {1}],
			Replace[StandardForwardPrimerStorageConditions] -> Lookup[optionsWithReplicates, StandardForwardPrimerStorageCondition],
			Replace[StandardReversePrimerStorageConditions] -> Lookup[optionsWithReplicates, StandardReversePrimerStorageCondition],
			Replace[StandardForwardPrimerVolumes] -> Lookup[optionsWithReplicates, StandardForwardPrimerVolume],
			Replace[StandardReversePrimerVolumes] -> Lookup[optionsWithReplicates, StandardReversePrimerVolume],

			Replace[SerialDilutionFactors]->Lookup[optionsWithReplicates,SerialDilutionFactor],
			Replace[NumberOfDilutions]->Lookup[optionsWithReplicates,NumberOfDilutions],
			Replace[NumberOfStandardReplicates]->Lookup[optionsWithReplicates,NumberOfStandardReplicates],

			Replace[StandardProbes] -> Replace[standardProbes, primerProbeResourceLookup, {1}],
			Replace[StandardProbeStorageConditions] -> Lookup[optionsWithReplicates, StandardProbeStorageCondition],
			Replace[StandardProbeVolumes] -> Lookup[optionsWithReplicates,StandardProbeVolume],

			Replace[StandardProbeExcitationWavelengths]->Lookup[optionsWithReplicates,StandardProbeExcitationWavelength],
			Replace[StandardProbeEmissionWavelengths]->Lookup[optionsWithReplicates,StandardProbeEmissionWavelength],
			Replace[StandardProbeFluorophores]->Link[Lookup[optionsWithReplicates, StandardProbeFluorophore]],

			Replace[EndogenousForwardPrimers] -> Replace[endogenousForwardPrimers, primerProbeResourceLookup, {1}],
			Replace[EndogenousReversePrimers] -> Replace[endogenousReversePrimers, primerProbeResourceLookup, {1}],
			Replace[EndogenousForwardPrimerStorageConditions] -> Lookup[optionsWithReplicates, EndogenousForwardPrimerStorageCondition],
			Replace[EndogenousReversePrimerStorageConditions] -> Lookup[optionsWithReplicates, EndogenousReversePrimerStorageCondition],
			Replace[EndogenousForwardPrimerVolumes] -> Lookup[optionsWithReplicates, EndogenousForwardPrimerVolume],
			Replace[EndogenousReversePrimerVolumes] -> Lookup[optionsWithReplicates, EndogenousReversePrimerVolume],

			Replace[EndogenousProbes] -> Replace[endogenousProbes, primerProbeResourceLookup, {1}],
			Replace[EndogenousProbeStorageConditions] -> Lookup[optionsWithReplicates, EndogenousProbeStorageCondition],
			Replace[EndogenousProbeVolumes]->Lookup[optionsWithReplicates,EndogenousProbeVolume],

			Replace[EndogenousProbeExcitationWavelengths]->Lookup[optionsWithReplicates,EndogenousProbeExcitationWavelength],
			Replace[EndogenousProbeEmissionWavelengths]->Lookup[optionsWithReplicates,EndogenousProbeEmissionWavelength],
			Replace[EndogenousProbeFluorophores] -> Link[Lookup[optionsWithReplicates, EndogenousProbeFluorophore]],

			AssayPlateStorageCondition -> Lookup[optionsWithReplicates, AssayPlateStorageCondition],

			UnresolvedOptions->RemoveHiddenOptions[ExperimentqPCR,myUnresolvedOptions],
			ResolvedOptions->RemoveHiddenOptions[ExperimentqPCR,myResolvedOptions],

			Replace[Checkpoints] -> {
				{"Preparing Samples", 0 Minute, "Preprocessing, such as thermal incubation/mixing, centrifugation, filtration, and aliquoting, is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 0 Minute]]},
				(* Including 15 minutes for tasks immediately before and after SM; SM and Centrifuge subs will add their own time estimates to this *)
				{"Preparing Assay Plate", 15 Minute,"Samples, primers, and master mix are combined in a plate suitable for qPCR analysis.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 15 Minute]]},
				{"Acquiring Data", dataAcquisitionEstimate, "Thermal cycling is performed and fluorescence readings are taken.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> dataAcquisitionEstimate]]},
				{"Returning Materials", 0 Minute, "Samples are post-processed and returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 0 Minute]]}
			}
		],

		(* Populate prep fields; pass un-replicate-expanded samples and options because this handles NumberOfReplicates internally *)
		populateSamplePrepFields[myPackagerSampleInputs, myResolvedOptions, Cache->cache]
	];

	(* get all of the resource out of the packet so they can be tested*)
	allResources = DeleteDuplicates[Cases[Flatten[Values[packet]],_Resource,Infinity]];

	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests,
		Resources`Private`fulfillableResourceQ[allResources,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache],
		True, {
			Resources`Private`fulfillableResourceQ[allResources,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->cache],
			Null
		}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule=Rule[Preview,Null];

	(* Generate the options output rule *)
	optionsRule=Rule[Options,If[MemberQ[output,Options],RemoveHiddenOptions[ExperimentqPCR,myResolvedOptions],Null]];

	(* Generate the tests rule *)
	testsRule=Tests->If[gatherTests,frqTests,{}];

	(* generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Rule[
		Result,
		If[MemberQ[output,Result]&&TrueQ[fulfillable],packet,$Failed]
	];

	(* Return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}

];


(*---Array card overload---*)
qPCRResourcePackets[
	myPackagerSampleInputs:{ObjectP[Object[Sample]]...},
	myPackagerArrayCardInput:ObjectP[Object[Container,Plate,Irregular,ArrayCard]],
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	myOptions:OptionsPattern[qPCRResourcePackets]
]:=Module[
	{unresolvedOptionsNoHidden,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,
		liquidHandlerContainers,nestedContainersIn,nestedLiquidHandlerContainerMaxVolumes,uniqueContainersIn,liquidHandlerContainerMaxVolumes,
		uniqueSampleResourceLookup,samplesInVolumeRules,uniqueSamplesInAndVolumesAssoc,
		masterMix,totalMasterMixVolume,masterMixAndVolumeAssoc,buffer,totalBufferVolume,bufferAndVolumeAssoc,
		reverseTranscription,reverseTranscriptionTime,reverseTranscriptionTemperature,reverseTranscriptionRampRate,
		activation,activationTime,activationTemperature,activationRampRate,
		denaturationTime,denaturationTemperature,denaturationRampRate,
		primerAnnealing,primerAnnealingTime,primerAnnealingTemperature,primerAnnealingRampRate,
		extensionTime,extensionTemperature,extensionRampRate,numberOfCycles,runTime,
		instrumentResource,protocolPacket,sharedFieldPacket,finalizedPacket,allResourceBlobs,fulfillable,frqTests,previewRule,optionsRule,resultRule,testsRule},

	(*Get the collapsed unresolved index-matching options that don't include hidden options*)
	unresolvedOptionsNoHidden=RemoveHiddenOptions[ExperimentqPCR,myUnresolvedOptions];

	(*Get the collapsed resolved index-matching options that don't include hidden options*)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentqPCR,
		RemoveHiddenOptions[ExperimentqPCR,myResolvedOptions],
		Ignore->myUnresolvedOptions
	];

	(*Determine the requested output format of this function*)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests to return to the user*)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(*Get the inherited cache*)
	inheritedCache=Lookup[ToList[myOptions],Cache,{}];


	(*---Generate all the resources for the experiment---*)

	(*--Download container information--*)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];
	{nestedContainersIn,nestedLiquidHandlerContainerMaxVolumes}=Quiet[
		Download[
			{
				myPackagerSampleInputs,
				liquidHandlerContainers
			},
			{
				{Container[Object]},
				{MaxVolume}
			},
			Cache->inheritedCache
		],
		{Download::FieldDoesntExist}
	];
	uniqueContainersIn=DeleteDuplicates[Flatten[nestedContainersIn]];
	liquidHandlerContainerMaxVolumes=Flatten[nestedLiquidHandlerContainerMaxVolumes];

	(*--Helper functions--*)

	(*Generate a resource for each unique sample, returning a lookup table of sample->resource*)
	uniqueSampleResourceLookup[uniqueSamplesAndVolumes_Association]:=KeyValueMap[
		Function[{object,amount},
			Module[{containers},

				If[ObjectQ[object]&&VolumeQ[amount],

					(*If we need to make a resource, figure out which liquid handler compatible containers can be used for this resource*)
					containers=PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[amount]];
					(*Return a resource rule*)
					object->Resource[Sample->object,Amount->amount,Name->ToString[Unique[]],Container->containers],

					(*If we don't need to make a resource, return a rule with the same object*)
					object->object
				]
			]
		],
		uniqueSamplesAndVolumes
	];

	(*--Generate SamplesIn resources--*)

	(*Generate sample volume rules*)
	samplesInVolumeRules=MapThread[Rule,{myPackagerSampleInputs,Lookup[myResolvedOptions,SampleVolume]}];

	(*Merge any entries with duplicate keys, totaling the values*)
	uniqueSamplesInAndVolumesAssoc=Merge[samplesInVolumeRules,Total];

	(*--Generate the master mix resource--*)

	(*Get the master mix*)
	masterMix=Lookup[myResolvedOptions,MasterMix];

	(*Calculate the total master mix volume needed, plus 40 uL extra*)
	totalMasterMixVolume=Lookup[myResolvedOptions,MasterMixVolume]*Length[myPackagerSampleInputs]+40 Microliter;

	(*Generate the master mix and master mix volume association*)
	masterMixAndVolumeAssoc=<|masterMix->totalMasterMixVolume|>;

	(*--Generate the buffer resource--*)

	(*Get the buffer*)
	buffer=Lookup[myResolvedOptions,Buffer];

	(*Calculate the total buffer volume needed, plus 100 uL extra*)
	totalBufferVolume=Total[Lookup[myResolvedOptions,BufferVolume]/.Null->0 Microliter]+100 Microliter;

	(*Generate the buffer and buffer volume association*)
	bufferAndVolumeAssoc=<|buffer->totalBufferVolume|>;

	(*--Estimate the run time--*)

	(*Look up the values of the thermocycling parameters*)
	{
		reverseTranscription,reverseTranscriptionTime,reverseTranscriptionTemperature,reverseTranscriptionRampRate,
		activation,activationTime,activationTemperature,activationRampRate,
		denaturationTime,denaturationTemperature,denaturationRampRate,
		primerAnnealing,primerAnnealingTime,primerAnnealingTemperature,primerAnnealingRampRate,
		extensionTime,extensionTemperature,extensionRampRate,
		numberOfCycles
	}=Lookup[myResolvedOptions,{
		ReverseTranscription,ReverseTranscriptionTime,ReverseTranscriptionTemperature,ReverseTranscriptionRampRate,
		Activation,ActivationTime,ActivationTemperature,ActivationRampRate,
		DenaturationTime,DenaturationTemperature,DenaturationRampRate,
		PrimerAnnealing,PrimerAnnealingTime,PrimerAnnealingTemperature,PrimerAnnealingRampRate,
		ExtensionTime,ExtensionTemperature,ExtensionRampRate,
		NumberOfCycles
	}];

	(*Calculate the estimated run time of the reaction*)
	runTime=Plus[
		(*ReverseTranscription*)
		If[TrueQ[reverseTranscription],Abs[reverseTranscriptionTemperature-$AmbientTemperature]/reverseTranscriptionRampRate+reverseTranscriptionTime,0 Second],

		(*Activation*)
		If[TrueQ[activation],Abs[activationTemperature-If[TrueQ[reverseTranscriptionTemperature],reverseTranscriptionTemperature,$AmbientTemperature]]/activationRampRate+activationTime,0 Second],

		(*Denaturation - 1st cycle*)
		Abs[denaturationTemperature-If[TrueQ[activation],activationTemperature,$AmbientTemperature]]/denaturationRampRate+denaturationTime,
		(*Denaturation - all subsequent cycles*)
		(Abs[denaturationTemperature-extensionTemperature]/denaturationRampRate+denaturationTime)*(numberOfCycles-1),

		(*PrimerAnnealing*)
		(If[TrueQ[primerAnnealing],Abs[primerAnnealingTemperature-denaturationTemperature]/primerAnnealingRampRate+primerAnnealingTime,0 Second])*numberOfCycles,

		(*Extension*)
		(Abs[extensionTemperature-If[TrueQ[primerAnnealing],primerAnnealingTemperature,denaturationTemperature]]/extensionRampRate+extensionTime)*numberOfCycles
	];

	(*--Generate the instrument resource--*)
	instrumentResource=Resource[Instrument->Lookup[myResolvedOptions,Instrument],Time->runTime+30 Minute];

	(*---Make all the packets for the experiment---*)

	(*--Make the protocol packet--*)
	protocolPacket=<|
		(*===Organizational Information===*)
		Object->CreateID[Object[Protocol,qPCR]],
		Type->Object[Protocol,qPCR],
		Replace[SamplesIn]->Map[Link[#,Protocols]&,Replace[myPackagerSampleInputs,uniqueSampleResourceLookup[uniqueSamplesInAndVolumesAssoc],{1}]],
		Replace[ContainersIn]->Map[Link[Resource[Sample->#],Protocols]&,uniqueContainersIn],


		(*===Resources===*)
		Replace[Checkpoints]->{
			{"Preparing Samples",0 Minute,"Preprocessing, such as thermal incubation/mixing, centrifugation, filtration, and aliquoting, is performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->0 Minute]]},
			{"Preparing Array Card",15 Minute,"Samples, master mix, and buffer are combined and loaded onto the array card.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->15 Minute]]},
			{"Acquiring Data",runTime,"Thermal cycling is performed and fluorescence readings are taken.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->runTime]]},
			{"Returning Materials",0 Minute,"Samples are post-processed and returned to storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->0 Minute]]}
		},


		(*===Method Information===*)
		Instrument->Link[instrumentResource],
		RunTime->runTime,
		ReactionVolume->Lookup[myResolvedOptions,ReactionVolume],
		MasterMix->Link[Replace[masterMix,uniqueSampleResourceLookup[masterMixAndVolumeAssoc]]],
		MasterMixVolume->Lookup[myResolvedOptions,MasterMixVolume],
		Buffer->Link[Replace[buffer,uniqueSampleResourceLookup[bufferAndVolumeAssoc]]],


		(*===Sample Storage===*)
		MasterMixStorageCondition->Lookup[myResolvedOptions,MasterMixStorageCondition],
		ArrayCardStorageCondition->Lookup[myResolvedOptions,ArrayCardStorageCondition],


		(*===Option Handling===*)
		UnresolvedOptions->unresolvedOptionsNoHidden,
		ResolvedOptions->resolvedOptionsNoHidden,


		(*===Sample Loading===*)
		ArrayCardPreparatoryPlate->Link[Resource[Sample->Model[Container,Plate,"96-well PCR Plate"]]],
		ArrayCard->Link[Resource[Sample->myPackagerArrayCardInput]],
		ArrayCardSealer->Link[Resource[Sample->Model[Part,"ViiA 7 Array Card Sealer"]]],
		ArrayCardThermalBlock->Link[Resource[Sample->Model[Part,ThermalBlock,"ViiA 7 Array Card Thermal Block"]]],
		ArrayCardTray->Link[Resource[Sample->Model[Container,Rack,"ViiA 7 Array Card Tray"]]],
		Replace[SampleVolumes]->Lookup[myResolvedOptions,SampleVolume],
		Replace[BufferVolumes]->Lookup[myResolvedOptions,BufferVolume],


		(*===Target Amplification===*)
		Replace[ForwardPrimers]->Link/@Lookup[myResolvedOptions,Probe],
		Replace[ReversePrimers]->Link/@Lookup[myResolvedOptions,Probe],


		(*===Probe Assay===*)
		Replace[Probes]->Link/@Lookup[myResolvedOptions,Probe],
		Replace[ProbeFluorophores]->Link/@Lookup[myResolvedOptions,ProbeFluorophore],
		Replace[ProbeExcitationWavelengths]->Lookup[myResolvedOptions,ProbeExcitationWavelength],
		Replace[ProbeEmissionWavelengths]->Lookup[myResolvedOptions,ProbeEmissionWavelength],


		(*===Passive Control===*)
		ReferenceDye->Link[Lookup[myResolvedOptions,ReferenceDye]],
		ReferenceDyeExcitationWavelength->Lookup[myResolvedOptions,ReferenceDyeExcitationWavelength],
		ReferenceDyeEmissionWavelength->Lookup[myResolvedOptions,ReferenceDyeEmissionWavelength],


		(*===Endogenous Control===*)
		Replace[EndogenousForwardPrimers]->Table[Lookup[myResolvedOptions,EndogenousPrimerPair],Length[myPackagerSampleInputs]],
		Replace[EndogenousReversePrimers]->Table[Lookup[myResolvedOptions,EndogenousPrimerPair],Length[myPackagerSampleInputs]],
		Replace[EndogenousForwardPrimerVolumes]->Table[Lookup[myResolvedOptions,EndogenousForwardPrimerVolume],Length[myPackagerSampleInputs]],
		Replace[EndogenousReversePrimerVolumes]->Table[Lookup[myResolvedOptions,EndogenousReversePrimerVolume],Length[myPackagerSampleInputs]],
		Replace[EndogenousProbes]->Table[Lookup[myResolvedOptions,EndogenousProbe],Length[myPackagerSampleInputs]],
		Replace[EndogenousProbeVolumes]->Table[Lookup[myResolvedOptions,EndogenousProbeVolume],Length[myPackagerSampleInputs]],
		Replace[EndogenousProbeFluorophores]->Table[Lookup[myResolvedOptions,EndogenousProbeFluorophore],Length[myPackagerSampleInputs]],
		Replace[EndogenousProbeExcitationWavelengths]->Table[Lookup[myResolvedOptions,EndogenousProbeExcitationWavelength],Length[myPackagerSampleInputs]],
		Replace[EndogenousProbeEmissionWavelengths]->Table[Lookup[myResolvedOptions,EndogenousProbeEmissionWavelength],Length[myPackagerSampleInputs]],


		(*===Reverse Transcription===*)
		ReverseTranscription->Lookup[myResolvedOptions,ReverseTranscription],
		ReverseTranscriptionTime->Lookup[myResolvedOptions,ReverseTranscriptionTime],
		ReverseTranscriptionTemperature->Lookup[myResolvedOptions,ReverseTranscriptionTemperature],
		ReverseTranscriptionRampRate->Lookup[myResolvedOptions,ReverseTranscriptionRampRate],


		(*===Polymerase Activation===*)
		Activation->Lookup[myResolvedOptions,Activation],
		ActivationTime->Lookup[myResolvedOptions,ActivationTime],
		ActivationTemperature->Lookup[myResolvedOptions,ActivationTemperature],
		ActivationRampRate->Lookup[myResolvedOptions,ActivationRampRate],


		(*===Denaturation===*)
		DenaturationTime->Lookup[myResolvedOptions,DenaturationTime],
		DenaturationTemperature->Lookup[myResolvedOptions,DenaturationTemperature],
		DenaturationRampRate->Lookup[myResolvedOptions,DenaturationRampRate],


		(*===Annealing===*)
		PrimerAnnealing->Lookup[myResolvedOptions,PrimerAnnealing],
		PrimerAnnealingTime->Lookup[myResolvedOptions,PrimerAnnealingTime],
		PrimerAnnealingTemperature->Lookup[myResolvedOptions,PrimerAnnealingTemperature],
		PrimerAnnealingRampRate->Lookup[myResolvedOptions,PrimerAnnealingRampRate],


		(*===Extension===*)
		ExtensionTime->Lookup[myResolvedOptions,ExtensionTime],
		ExtensionTemperature->Lookup[myResolvedOptions,ExtensionTemperature],
		ExtensionRampRate->Lookup[myResolvedOptions,ExtensionRampRate],
		NumberOfCycles->Lookup[myResolvedOptions,NumberOfCycles],


		(*===Melting Curve===*)
		MeltingCurve->Lookup[myResolvedOptions,MeltingCurve]
	|>;

	(*--Make a packet with the shared fields--*)
	sharedFieldPacket=populateSamplePrepFields[myPackagerSampleInputs,myResolvedOptions,Cache->inheritedCache];

	(*--Merge the specific fields with the shared fields--*)
	finalizedPacket=Join[sharedFieldPacket,protocolPacket];

	(*--Gather all the resource symbolic representations--*)

	(*Need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed*)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]],_Resource,Infinity]];


	(*---Call fulfillableResourceQ on all the resources we created---*)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],{True,{}},
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache],
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache],Null}
	];


	(*---Return our options, packets, and tests---*)

	(*Generate the preview output rule; Preview is always Null*)
	previewRule=Preview->Null;

	(*Generate the options output rule*)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
	];

	(*Generate the result output rule: if not returning result, or the resources are not fulfillable, result rule is just $Failed*)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(*Generate the tests output rule*)
	testsRule=Tests->If[gatherTests,
		frqTests,
		Null
	];

	(*Return the output as we desire it*)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];


(* ::Subsubsection::Closed:: *)
(*expandqPCRStandards*)


(* expandqPCRStandards: Unlike SamplesIn, Standards field doesn't get expanded within ExperimentqPCR to reflect NumberOfStandardReplicates and
	the specified standard curve dilution options.
	This function expands them accordingly, with the same ordering as SamplesIn NumberOfReplicates (i.e. 1,1,2,2 rather than 1,2,1,2).

	Input:
		- Standards field
		- StandardForwardPrimers field
		- StandardReversePrimers field
		- StandardForwardPrimerVolumes field
		- StandardReversePrimerVolumes field
		- StandardProbes field
		- StandardProbeVolumes field
		- NumberOfStandardReplicates field
		- NumberOfDilutions field
		- SerialDilutionFactors field
		- StandardProbesExcitationWavelengths field
		- StandardProbesEmissionWavelengths field
		- StandardProbeFluorophores field

	Output:
		- List in the form {expanded standards, expanded standard forward primers, expanded standard reverse primers, expanded standard probes, expanded standard dilutions, expanded standard probe excitation wavelengths, expanded standard probe emission wavelengths, expanded standard probe fluorophores}.
			Each of these outputs index-matches the Standards field, so each entry is the full expanded set of information for a single entry in Standards.
	*)

(* If there are no standards (Null or {}, depending on we're dealing with resolved options or field values), return empty lists for all expanded options *)
expandqPCRStandards[{} | Null, ___] := ConstantArray[{}, 11];

(* If there are standards, expand all options as necessary *)
expandqPCRStandards[
	standardSamples:{(ObjectP[] | Null)..},
	standardForwardPrimers:{(ObjectP[] | Null)..},
	standardReversePrimers:{(ObjectP[] | Null)..},
	standardForwardPrimerVolumes:{(VolumeP | Null)..},
	standardReversePrimerVolumes:{(VolumeP | Null)..},
	standardProbes:{(ObjectP[] | Null)..},
	standardProbeVolumes:{(VolumeP | Null)..},
	numberOfStandardReplicates:{(_Integer | Null)..},
	numberOfStandardDilutions:{(_Integer | Null)..},
	standardDilutionFactors:{(NumericP | Null)..},
	standardProbeExcitationWavelengths:{(DistanceP | Null)..},
	standardProbeEmissionWavelengths:{(DistanceP | Null)..},
	standardProbeFluorophores:{(ObjectP[Model[Molecule]]|Null)..}
] := Module[
	{standardsGroupedBySample, standardForwardPrimersGroupedBySample, standardReversePrimersGroupedBySample,standardForwardPrimerVolumesGroupedBySample, standardReversePrimerVolumesGroupedBySample,
	standardProbesGroupedBySample, standardProbeVolumesGroupedBySample, standardDilutionsGroupedBySample, expandStandardParameter, standardExcitationWavelengthsGroupedBySample,
	standardEmissionWavelengthsGroupedBySample, standardProbeFluorophoresGroupedBySample},

	(* Expand standards, primers, dilutions, and concentrations
	 	These initial lists are grouped by Standards field entry, and replicates are sub-grouped together within
		 	e.g. {{{stdSamp1Rep1a, stdSamp1Rep2}}}*)
		{standardsGroupedBySample, standardForwardPrimersGroupedBySample, standardReversePrimersGroupedBySample,standardForwardPrimerVolumesGroupedBySample, standardReversePrimerVolumesGroupedBySample,
		standardProbesGroupedBySample, standardProbeVolumesGroupedBySample, standardDilutionsGroupedBySample, standardExcitationWavelengthsGroupedBySample, standardEmissionWavelengthsGroupedBySample,
		standardProbeFluorophoresGroupedBySample} = Transpose[
		MapThread[
			Function[
				{singleStandardSample, singleStandardForwardPrimer, singleStandardReversePrimer, singleStandardForwardPrimerVolume, singleStandardReversePrimerVolume, singleStandardProbe, singleStandardProbeVolume,
				singleNumberOfReplicates, singleNumberOfDilutions, singleDilutionFactor, singleStandardProbeExcitationWavelength, singleStandardProbeEmissionWavelengths, singleStandardProbeFluorophore},
				Module[
					{dils, numberOfDilutions, expandedDils, expandedStdSamp, expandedStdForwardPrimer, expandedStdReversePrimerVolume, expandedStdForwardPrimerVolume,
					expandedStdReversePrimer, expandedStdProbe, expandedStdProbeVolume, expandedStdProbeExcitation, expandedStdProbeEmission, expandedStdProbeFluorophore},

					(* Figure out the list of dilutions for this standard; compute these based on NumberOfDilutions and SerialDilutionFactor. *)
					dils = FoldList[#1/#2 &, 1, ConstantArray[singleDilutionFactor, singleNumberOfDilutions-1]];

					(* How many dilutions are we dealing with? *)
					numberOfDilutions = Length[dils];

					(* Expand dilutions based on number of standard replicates, keeping replicates in lists together *)
					expandedDils = Transpose[ConstantArray[dils, singleNumberOfReplicates]];

					(* Tiny internal helper to expand by both number of dilutions and number of replicates *)
					expandStandardParameter[obj:ObjectP[], numDils_Integer, numReps_Integer] := Transpose[ConstantArray[ConstantArray[Download[obj, Object], numDils], numReps]];
					expandStandardParameter[nonObj:Except[ObjectP[]], numDils_Integer, numReps_Integer] := Transpose[ConstantArray[ConstantArray[nonObj, numDils], numReps]];

					(* Expand standard sample, primers, and probe to account for both number of dilutions and number of replicates for this standard
						Strip off links so that function output contains only clean ObjectReferences *)
					expandedStdSamp = expandStandardParameter[singleStandardSample, numberOfDilutions, singleNumberOfReplicates];
					expandedStdForwardPrimer = expandStandardParameter[singleStandardForwardPrimer, numberOfDilutions, singleNumberOfReplicates];
					expandedStdReversePrimer = expandStandardParameter[singleStandardReversePrimer, numberOfDilutions, singleNumberOfReplicates];
					expandedStdForwardPrimerVolume = expandStandardParameter[singleStandardForwardPrimerVolume, numberOfDilutions, singleNumberOfReplicates];
					expandedStdReversePrimerVolume = expandStandardParameter[singleStandardReversePrimerVolume, numberOfDilutions, singleNumberOfReplicates];
					expandedStdProbe = expandStandardParameter[singleStandardProbe, numberOfDilutions, singleNumberOfReplicates];
					expandedStdProbeVolume = expandStandardParameter[singleStandardProbeVolume, numberOfDilutions, singleNumberOfReplicates];
					expandedStdProbeExcitation = expandStandardParameter[singleStandardProbeExcitationWavelength, numberOfDilutions, singleNumberOfReplicates];
					expandedStdProbeEmission = expandStandardParameter[singleStandardProbeEmissionWavelengths, numberOfDilutions, singleNumberOfReplicates];
					expandedStdProbeFluorophore = expandStandardParameter[singleStandardProbeFluorophore, numberOfDilutions, singleNumberOfReplicates];

					(* Return samples, dilutions, and concentrations *)
					{expandedStdSamp, expandedStdForwardPrimer, expandedStdReversePrimer, expandedStdForwardPrimerVolume, expandedStdReversePrimerVolume, expandedStdProbe, expandedStdProbeVolume, expandedDils, expandedStdProbeExcitation, expandedStdProbeEmission, expandedStdProbeFluorophore}
				]
			],
			{standardSamples, standardForwardPrimers, standardReversePrimers, standardForwardPrimerVolumes, standardReversePrimerVolumes, standardProbes, standardProbeVolumes,
				numberOfStandardReplicates, numberOfStandardDilutions, standardDilutionFactors, standardProbeExcitationWavelengths, standardProbeEmissionWavelengths, standardProbeFluorophores}
		]
	];

	(* For each of the above expanded lists, Join all top-level sublists together before returning.
		This has the effect of merging together entries from all members of the Standards field, while leaving replicate groups intact. *)
	Join @@@ {standardsGroupedBySample, standardForwardPrimersGroupedBySample, standardReversePrimersGroupedBySample,standardForwardPrimerVolumesGroupedBySample, standardReversePrimerVolumesGroupedBySample,
	standardProbesGroupedBySample, standardProbeVolumesGroupedBySample, standardDilutionsGroupedBySample, standardExcitationWavelengthsGroupedBySample, standardEmissionWavelengthsGroupedBySample,
	standardProbeFluorophoresGroupedBySample}

];

(* Overload to pull relevant information out of a supplied protocol packet and replace values in place *)
(* expandqPCRStandards[protocolPacket:PacketP[Object[Protocol, qPCR]]] := Module[
	{expandedSamples, expandedForwardPrimers, expandedReversePrimers, expandedForwardPrimerVolumes, expandedReversePrimerVolumes, expandedProbes, expandedProbeVolumes, expandedDilutions},

	{expandedSamples, expandedForwardPrimers, expandedReversePrimers, expandedForwardPrimerVolumes, expandedReversePrimerVolumes, expandedProbes, expandedProbeVolumes, expandedDilutions} = Apply[
		expandqPCRStandards,
		Lookup[protocolPacket, {Standards, StandardForwardPrimers, StandardReversePrimers, StandardForwardPrimerVolumes, StandardReversePrimerVolumes, StandardProbes, StandardProbeVolumes,
			NumberOfStandardReplicates, NumberOfDilutions, SerialDilutionFactors}]
	];

	ReplaceRule[
		protocolPacket,
		Standards -> expandedSamples,
	]
] *)


(* ::Subsection::Closed:: *)
(*ExperimentqPCROptions*)


DefineOptions[ExperimentqPCROptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates if the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentqPCR}
];


(*---384-well plate overload---*)
ExperimentqPCROptions[
	myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
	myPrimerPairs:ListableP[{{ObjectP[{Object[Sample],Model[Sample]}],ObjectP[{Object[Sample],Model[Sample]}]}..}|_String],
	myOptions:OptionsPattern[ExperimentqPCROptions]
]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* Get only the options for ExperimentqPCR *)
	options=ExperimentqPCR[myInputs,myPrimerPairs,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentqPCR],
		options
	]
];


(*---Array card overload---*)
ExperimentqPCROptions[
	mySampleInputs:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],
	myArrayCardInput:ObjectP[Object[Container,Plate,Irregular,ArrayCard]],
	myOptions:OptionsPattern[ExperimentqPCROptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Send in the correct Output option and remove the OutputFormat option*)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentqPCR[mySampleInputs,myArrayCardInput,preparedOptions];

	(*Return the option as a list or table*)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentqPCR],
		resolvedOptions
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentqPCRPreview*)


DefineOptions[ExperimentqPCRPreview,
	SharedOptions:>{ExperimentqPCR}
];


(*---384-well plate overload---*)
ExperimentqPCRPreview[
	myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
	myPrimerPairs:ListableP[{{ObjectP[{Object[Sample],Model[Sample]}],ObjectP[{Object[Sample],Model[Sample]}]}..}|_String],
	myOptions:OptionsPattern[ExperimentqPCRPreview]
]:=Module[{listedOptions},

	listedOptions=ToList[myOptions];

	ExperimentqPCR[myInputs,myPrimerPairs,ReplaceRule[listedOptions,Output->Preview]]
];


(*---Array card overload---*)
ExperimentqPCRPreview[
	mySampleInputs:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],
	myArrayCardInput:ObjectP[Object[Container,Plate,Irregular,ArrayCard]],
	myOptions:OptionsPattern[ExperimentqPCRPreview]
]:=Module[{listedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	ExperimentqPCR[mySampleInputs,myArrayCardInput,ReplaceRule[listedOptions,Output->Preview]]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentqPCRQ*)


DefineOptions[ValidExperimentqPCRQ,
	Options:>
			{
				VerboseOption,
				OutputFormatOption
			},
	SharedOptions:>{ExperimentqPCR}
];


(*---384-well plate overload---*)
ValidExperimentqPCRQ[
	myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
	myPrimerPairs:ListableP[{{ObjectP[{Object[Sample],Model[Sample]}],ObjectP[{Object[Sample],Model[Sample]}]}..}|_String],
	myOptions:OptionsPattern[ValidExperimentqPCRQ]
]:=Module[
	{listedOptions,preparedOptions,experimentqPCRTests,initialTestDescription,allTests,verbose,outputFormat},

(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Return only the tests for ExperimentqPCR *)
	experimentqPCRTests=ExperimentqPCR[myInputs,myPrimerPairs,Append[preparedOptions,Output->Tests]];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(*Make a list of all of the tests, including the blanket test *)
	allTests=If[MatchQ[experimentqPCRTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(* Generate the initial test, which we know will pass if we got this far (hopefully) *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[ToList[myInputs],_String],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[myInputs],_String],validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Flatten[{initialTest,experimentqPCRTests,voqWarnings}]
		]
	];

	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentqPCRQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentqPCRQ"]
];


(*---Array card overload---*)
ValidExperimentqPCRQ[
	mySampleInputs:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],
	myArrayCardInput:ObjectP[Object[Container,Plate,Irregular,ArrayCard]],
	myOptions:OptionsPattern[ValidExperimentqPCRQ]
]:=Module[
	{listedOptions,preparedOptions,experimentqPCRTests,initialTestDescription,allTests,verbose,outputFormat},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Remove the output option before passing to the core function because it doesn't make sense here*)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(*Call the ExperimentqPCR function to get a list of tests*)
	experimentqPCRTests=ExperimentqPCR[mySampleInputs,myArrayCardInput,Append[preparedOptions,Output->Tests]];

	(*Define the general test description*)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(*Make a list of all of the tests, including the blanket test*)
	allTests=If[MatchQ[experimentqPCRTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(*Generate the initial test, which should pass if we got this far*)
			initialTest=Test[initialTestDescription,True,True];

			(*Create warnings for invalid objects*)
			validObjectBooleans=ValidObjectQ[Cases[Flatten[{mySampleInputs,myArrayCardInput}],ObjectP[]],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Cases[Flatten[{mySampleInputs,myArrayCardInput}],ObjectP[]],validObjectBooleans}
			];

			(*Get all the tests/warnings*)
			Cases[Flatten[{initialTest,experimentqPCRTests,voqWarnings}],_EmeraldTest]
		]
	];

	(*Look up the test-running options*)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(*Run the tests as requested*)
	Lookup[RunUnitTest[<|"ValidExperimentqPCRQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentqPCRQ"]
];
