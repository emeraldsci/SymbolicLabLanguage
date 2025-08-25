(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section::Closed:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ExperimentPCR*)


(* ::Subsubsection::Closed:: *)
(*ExperimentPCR Options and Messages*)


DefineOptions[ExperimentPCR,
	Options:>{

		(*===Method Information===*)
		{
			OptionName->Instrument,
			Default->Model[Instrument,Thermocycler,"Automated Thermal Cycler"],
			Description->"The instrument for running the polymerase chain reaction (PCR) experiment.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Thermocyclers"
					}
				}
			]
		},
		{
			OptionName->LidTemperature,
			Default->99 Celsius, (* spec for the seal we are using says it is up to 100C, we should not go above the spec *)
			Description->"The temperature of the instrument's plate lid throughout the reaction. The lid is heated to prevent water from condensing on the plate seal.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[30 Celsius,105 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}]
		},


		(*===Sample Preparation===*)

		(*Index-matching options*)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples containing nucleic acid templates from which the target sequences will be amplified, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the container of the sample containing nucleic acid templates from which the target sequences will be amplified, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName->SampleVolume,
				Default->Automatic,
				Description->"For each sample, the volume to add to the reaction.",
				ResolutionDescription -> "Automatically set to 2 Microliter if PreparedPlate is not True, and automatically set to 0 Microliter if it is True.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}],
				Category->"Sample Preparation"
			},
			{
				OptionName->PrimerPairLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the sample containing pair(s) of oligomer strands designed to bind to the template and serve as anchors for the polymerase, for use in downstream unit operations.",
				AllowNull->False,
				Widget->Alternatives[
					Adder[{
						"Forward Primer"->Widget[Type->String,Pattern:>_String,Size->Line],
						"Reverse Primer"->Widget[Type->String,Pattern:>_String,Size->Line]
					}],
					Widget[Type->Enumeration,Pattern:>Alternatives[{{Null,Null}}]]
				],
				Category->"Sample Preparation",
				UnitOperation -> True
			},
			{
				OptionName->PrimerPairContainerLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the container of the sample containing pair(s) of oligomer strands designed to bind to the template and serve as anchors for the polymerase, for use in downstream unit operations.",
				AllowNull->False,
				Widget->Alternatives[
					Adder[{
						"Forward Primer Container"->Widget[Type->String,Pattern:>_String,Size->Line],
						"Reverse Primer Container"->Widget[Type->String,Pattern:>_String,Size->Line]
					}],
					Widget[Type->Enumeration,Pattern:>Alternatives[{{Null,Null}}]]
				],
				Category->"Sample Preparation",
				UnitOperation -> True
			},
			{
				OptionName->ForwardPrimerVolume,
				Default->Automatic,
				Description->"For each sample, the forward primer volume(s) to add to the reaction.",
				ResolutionDescription->"Automatically set to 1 microliter for each forward primer specified, or Null otherwise.",
				AllowNull->True,
				Widget->Alternatives[
					"Single forward primer"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}],
					"Multiple forward primers"->Adder[Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}]]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ForwardPrimerStorageCondition,
				Default->Null,
				Description->"For each sample, the non-default conditions under which the forward primers of this experiment should be stored after the protocol is completed. If left unset, the forward primers will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Alternatives[
					"Single forward primer"->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
					"Multiple forward primers"->Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
				],
				Category->"Post Experiment"
			},
			{
				OptionName->ReversePrimerVolume,
				Default->Automatic,
				Description->"For each sample, the reverse primer volume(s) to add to the reaction.",
				ResolutionDescription->"Automatically set to match ForwardPrimerVolume.",
				AllowNull->True,
				Widget->Alternatives[
					"Single forward primer"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}],
					"Multiple forward primers"->Adder[Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}]]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ReversePrimerStorageCondition,
				Default->Null,
				Description->"For each sample, the non-default conditions under which the reverse primers of this experiment should be stored after the protocol is completed. If left unset, the reverse primers will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Alternatives[
					"Single forward primer"->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
					"Multiple forward primers"->Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
				],
				Category->"Post Experiment"
			},
			{
				OptionName->BufferVolume,
				Default->Automatic,
				Description->"For each sample, the buffer volume to add to bring each reaction to ReactionVolume.",
				ResolutionDescription->"Automatically set according to the equation BufferVolume=ReactionVolume-(SampleVolume+MasterMixVolume+ForwardPrimerVolume+ReversePrimerVolume) if Buffer is not set to Null, or Null otherwise.",
				AllowNull->True,
				Widget->Alternatives[
					"Single forward primer"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}],
					"Multiple forward primers"->Adder[Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}]]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->SampleOutLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the output samples that contains amplified sequence(s), for use in downstream unit operations.",
				AllowNull->False,
				Widget->Alternatives[
					"Single forward primer"->Widget[Type->String,Pattern:>_String, Size->Line],
					"Multiple forward primers"->Adder[Widget[Type->String,Pattern:>_String,Size->Line]]
					],
				Category->"Sample Preparation",
				UnitOperation -> True
			}
		],

		(*Global options*)
		{
			OptionName->ReactionVolume,
			Default->20 Microliter,
			Description->"The total volume of the reaction including the template, primers, master mix, and buffer.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[10 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}],
			Category->"Sample Preparation"
		},
		{
			OptionName -> PreparedPlate,
			Default -> Automatic,
			Description -> "Indicates if the input sample or container has already been prepared and does not need to be diluted/mixed with master mix or buffer.  If set to True, MasterMix and Buffer will be set to Null and the input sample will be used as is.",
			ResolutionDescription -> "Automatically set to True if MasterMix and Buffer are set to Null and no primers were specified.  Otherwise set to False.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "Sample Preparation"
		},
		{
			OptionName->MasterMix,
			Default->Automatic,
			Description->"The stock solution composed of the polymerase, nucleotides, and buffer for amplifying the target sequences.",
			ResolutionDescription -> "Automatically set to $PCRDefaultMasterMix if PreparedPlate is not True.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Reagents",
						"Molecular Biology",
						"PCR"
					}
				}
			],
			Category->"Sample Preparation"
		},
		{
			OptionName->MasterMixLabel,
			Default->Automatic,
			Description->"The label of the stock solution that composed of the polymerase, nucleotides, and buffer for amplifying the target sequences.",
			AllowNull->False,
			Widget->Widget[
				Type->String,
				Pattern:>_String,
				Size->Line
			],
			Category->"Hidden"
		},
		{
			OptionName->MasterMixContainerLabel,
			Default->Automatic,
			Description->"The label of the container that contains the stock solution with the polymerase, nucleotides, and buffer for amplifying the target sequences.",
			AllowNull->False,
			Widget->Widget[
				Type->String,
				Pattern:>_String,
				Size->Line
			],
			Category->"Hidden"
		},
		{
			OptionName->MasterMixVolume,
			Default->Automatic,
			Description->"The volume of master mix to add to the reaction.",
			ResolutionDescription->"Automatically set to 0.5*ReactionVolume if MasterMix is not set to Null, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,100 Microliter],Units->{Microliter,{Microliter,Milliliter}}],
			Category->"Sample Preparation"
		},
		{
			OptionName->MasterMixStorageCondition,
			Default->Null,
			Description->"The non-default condition under which MasterMix of this experiment should be stored after the protocol is completed. If left unset, MasterMix will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
			Category->"Post Experiment"
		},
		{
			OptionName->Buffer,
			Default->Automatic,
			Description->"The solution for bringing each reaction to ReactionVolume once all the reaction components (template, primers, and master mix) are added.",
			ResolutionDescription -> "Automatically set to Model[Sample,\"Milli-Q water\"] if PreparedPlate is not True.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Reagents",
						"Water"
					}
				}

			],
			Category->"Sample Preparation"
		},
		{
			OptionName->BufferLabel,
			Default->Automatic,
			Description->"The label of the sample that brings each reaction to ReactionVolume once all the reaction components (template, primers, and master mix) are added.",
			AllowNull->False,
			Widget->Widget[
				Type->String,
				Pattern:>_String,
				Size->Line
			],
			Category->"Hidden"
		},
		{
			OptionName->BufferContainerLabel,
			Default->Automatic,
			Description->"The label of the container that contains the sample that brings each reaction to ReactionVolume once all the reaction components (template, primers, and master mix) are added.",
			AllowNull->False,
			Widget->Widget[
				Type->String,
				Pattern:>_String,
				Size->Line
			],
			Category->"Hidden"
		},
		{
			OptionName->AssayPlate,
			Default->Automatic,
			Description->"The container that contains samples with amplified sequences.",
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Container],Object[Container]}]],
			Category->"Hidden"
		},
		{
			OptionName->AssayPlateLabel,
			Default->Automatic,
			Description->"The label of the container that contains samples with amplified sequences.",
			AllowNull->False,
			Widget->Widget[
				Type->String,
				Pattern:>_String,
				Size->Line
			],
			Category->"Hidden"
		},


		(*===Polymerase Activation===*)
		{
			OptionName->Activation,
			Default->Automatic,
			Description->"Indicates if hot start activation should be performed. In order to reduce non-specific amplification, enzymes can be made room temperature stable by inhibiting their activity via thermolabile conjugates. Once an experiment is ready to be run, this inhibition is disabled by heating the reaction to ActivationTemperature.",
			ResolutionDescription->"Automatically set to True if other Activation options are set, or False otherwise.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Polymerase Activation"
		},
		{
			OptionName->ActivationTime,
			Default->Automatic,
			Description->"The length of time for which the sample is held at ActivationTemperature to remove the thermolabile conjugates inhibiting polymerase activity.",
			ResolutionDescription->"Automatically set to 60 seconds if Activation is set to True, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second,1 Hour],Units->{Second,{Second,Minute,Hour}}],
			Category->"Polymerase Activation"
		},
		{
			OptionName->ActivationTemperature,
			Default->Automatic,
			Description->"The temperature to which the sample is heated to remove the thermolabile conjugates inhibiting polymerase activity.",
			ResolutionDescription->"Automatically set to 95 degrees Celsius if Activation is set to True, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[4 Celsius,105 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}],
			Category->"Polymerase Activation"
		},
		{
			OptionName->ActivationRampRate,
			Default->Automatic,
			Description->"The rate at which the sample is heated to reach ActivationTemperature.",
			AllowNull->True,
			ResolutionDescription->"Automatically set to 3.5 degrees Celsius per second if Activation is set to True, or Null otherwise.",
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0.2 (Celsius/Second),3.5 (Celsius/Second)],Units->CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Polymerase Activation"
		},


		(*===Denaturation===*)
		{
			OptionName->DenaturationTime,
			Default->30 Second,
			Description->"The length of time for which the sample is held at DenaturationTemperature to allow the dissociation of the double stranded template into single strands.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second,1 Hour],Units->{Second,{Second,Minute,Hour}}],
			Category->"Denaturation"
		},
		{
			OptionName->DenaturationTemperature,
			Default->95 Celsius,
			Description->"The temperature to which the sample is heated to allow the dissociation of the double stranded template into single strands.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[4 Celsius,105 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}],
			Category->"Denaturation"
		},
		{
			OptionName->DenaturationRampRate,
			Default->3.5 (Celsius/Second),
			Description->"The rate at which the sample is heated to reach DenaturationTemperature.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0.2 (Celsius/Second),3.5 (Celsius/Second)],Units->CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Denaturation"
		},


		(*===Primer Annealing===*)
		{
			OptionName->PrimerAnnealing,
			Default->Automatic,
			Description->"Indicates if annealing should be performed as a separate step instead of as part of extension. Lowering the temperature during annealing allows primers to bind to the template and serve as anchor points for the polymerase in the subsequent extension.",
			ResolutionDescription->"Automatically set to True if other PrimerAnnealing options are set, or False otherwise.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Primer Annealing"
		},
		{
			OptionName->PrimerAnnealingTime,
			Default->Automatic,
			Description->"The length of time for which the sample is held at PrimerAnnealingTemperature to allow primers to bind to the template.",
			ResolutionDescription->"Automatically set to 30 seconds if PrimerAnnealing is set to True, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second,1 Hour],Units->{Second,{Second,Minute,Hour}}],
			Category->"Primer Annealing"
		},
		{
			OptionName->PrimerAnnealingTemperature,
			Default->Automatic,
			Description->"The temperature to which the sample is cooled to allow primers to bind to the template. ",
			ResolutionDescription->"Automatically set to 60 degrees Celsius if PrimerAnnealing is set to True, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[4 Celsius,105 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}],
			Category->"Primer Annealing"
		},
		{
			OptionName->PrimerAnnealingRampRate,
			Default->Automatic,
			Description->"The rate at which the sample is cooled to reach PrimerAnnealingTemperature.",
			ResolutionDescription->"Automatically set to 3.5 degrees Celsius per second if PrimerAnnealing is set to True, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0.2 (Celsius/Second),3.5 (Celsius/Second)],Units->CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Primer Annealing"
		},


		(*===Strand Extension===*)
		{
			OptionName->ExtensionTime,
			Default->60 Second,
			Description->"The length of time for which sample is held at ExtensionTemperature to allow the polymerase to synthesize a new strand using the template and primers.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second,1 Hour],Units->{Second,{Second,Minute,Hour}}],
			Category->"Strand Extension"
		},
		{
			OptionName->ExtensionTemperature,
			Default->72 Celsius,
			Description->"The temperature to which the sample is heated/cooled to allow the polymerase to synthesize a new strand using the template and primers.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[4 Celsius,105 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}],
			Category->"Strand Extension"
		},
		{
			OptionName->ExtensionRampRate,
			Default->3.5 (Celsius/Second),
			Description->"The rate at which the sample is heated/cooled to reach ExtensionTemperature.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0.2 (Celsius/Second),3.5 (Celsius/Second)],Units->CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Strand Extension"
		},


		(*===Cycling===*)
		{
			OptionName->NumberOfCycles,
			Default->40,
			Description->"The number of times the sample will undergo repeated cycles of denaturation, primer annealing (optional), and strand extension.",
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>RangeP[1,60,1]],
			Category->"Cycling"
		},


		(*===Final Extension===*)
		{
			OptionName->FinalExtension,
			Default->Automatic,
			Description->"Indicates if final extension should be performed to fill in any incomplete products and/or obtain a poly-adenosine overhang on the 3' end of the product.",
			ResolutionDescription->"Automatically set to True if other FinalExtension options are set, or False otherwise.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Final Extension"
		},
		{
			OptionName->FinalExtensionTime,
			Default->Automatic,
			Description->"The length of time for which the sample is held at FinalExtensionTemperature to fill in any incomplete products and/or obtain a poly-adenosine overhang on the 3' end of the product.",
			ResolutionDescription->"Automatically set to 10 minutes if FinalExtension is set to True, or Null otherwise",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second,1 Hour],Units->{Second,{Second,Minute,Hour}}],
			Category->"Final Extension"
		},
		{
			OptionName->FinalExtensionTemperature,
			Default->Automatic,
			Description->"The temperature to which the sample is heated/cooled to to fill in any incomplete products and/or obtain a poly-adenosine overhang on the 3' end of the product.",
			ResolutionDescription->"Automatically set to ExtensionTemperature if FinalExtension is set to True, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[4 Celsius,105 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}],
			Category->"Final Extension"
		},
		{
			OptionName->FinalExtensionRampRate,
			Default->Automatic,
			Description->"The rate at which the sample is heated/cooled to reach ActivationTemperature.",
			AllowNull->True,
			ResolutionDescription->"Automatically set to 3.5 degrees Celsius per second if FinalExtension is set to True, or Null otherwise.",
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0.2 (Celsius/Second),3.5 (Celsius/Second)],Units->CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Final Extension"
		},


		(*===Infinite Hold===*)
		{
			OptionName->HoldTemperature,
			Default->10 Celsius,
			Description->"The temperature to which the sample is cooled and held after the thermocycling procedure.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[4 Celsius,105 Celsius],Units->{Celsius,{Celsius,Kelvin,Fahrenheit}}],
			Category->"Infinite Hold"
		},


		(*===Shared Options===*)
		SamplesInStorageOptions,
		SamplesOutStorageOptions,
		SimulationOption,
		PreparationOption,
		WorkCellOption,
		ModelInputOptions,
		BiologyFuntopiaSharedOptions
	}
];


Error::PCRTooManySamples="The number of input samples cannot fit onto the instrument in a single protocol. Please select fewer than 96 samples to run this protocol.";
Error::InvalidPreparedPlate="When using a prepared plate by specifying PreparedPlate -> True (or 0 sample volumes, and no buffer, primers, or master mix), the samples must all be in the same plate with the model, Model[Container, Plate, \"96-well Optical Full/Semi-Skirted PCR Plate\"] or Model[Container, Plate, \"96-well PCR Plate\"]. Please transfer the samples and try again.";
Error::ForwardPrimerVolumeMismatch="The specified forward primer volumes have conflicts with the input forward primers. Please change the value of ForwardPrimerVolume or leave it unspecified to be set automatically.";
Error::ReversePrimerVolumeMismatch="The specified reverse primer volumes have conflicts with the input reverse primers. Please change the value of ReversePrimerVolume or leave it unspecified to be set automatically.";
Error::PCRBufferVolumeMismatch="If Buffer is Null, BufferVolume cannot be specified; if Buffer is specified, BufferVolume cannot be Null. Please change the value of either or both option(s), or leave BufferVolume unspecified to be set automatically.";
Error::MasterMixVolumeMismatch="If MasterMix is Null, MasterMixVolume cannot be specified; if MasterMix is specified, MasterMixVolume cannot be Null. Please change the value of either or both option(s), or leave MasterMixVolume unspecified to be set automatically.";
Error::MasterMixStorageConditionMismatch="If MasterMix is Null, MasterMixStorageCondition cannot be specified. Please change the value of either or both option(s).";
Error::ActivationMismatch="If Activation is False, ActivationTime, ActivationTemperature, and ActivationRampRate cannot be specified; if Activation is True, ActivationTime, ActivationTemperature, and ActivationRampRate cannot be Null. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::PrimerAnnealingMismatch="If PrimerAnnealing is False, PrimerAnnealingTime, PrimerAnnealingTemperature, and PrimerAnnealingRampRate cannot be specified; if PrimerAnnealing is True, PrimerAnnealingTime, PrimerAnnealingTemperature, and PrimerAnnealingRampRate cannot be Null. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::FinalExtensionMismatch="If FinalExtension is False, FinalExtensionTime, FinalExtensionTemperature, and FinalExtensionRampRate cannot be specified; if FinalExtension is True, FinalExtensionTime, FinalExtensionTemperature, and FinalExtensionRampRate cannot be Null. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::ForwardPrimerStorageConditionMismatch="The specified forward primer storage conditions have conflicts with the input forward primers. Please change the value of ForwardPrimerStorageCondition.";
Error::ReversePrimerStorageConditionMismatch="The specified reverse primer storage conditions have conflicts with the input reverse primers. Please change the value of ReversePrimerStorageCondition.";
Error::TotalVolumeOverReactionVolume="The total volume consisting of SampleVolume, MasterMixVolume, ForwardPrimerVolume, ReversePrimerVolume, and BufferVolume exceeds ReactionVolume for sample(s) `1`. Please change the value of some or all of these options, or leave MasterMixVolume, ForwardPrimerVolume, ReversePrimerVolume, and/or BufferVolume unspecified to be set automatically.";

(* constants so we're not hard coding the same thing in multiple places *)
$PCRDefaultMasterMix = Model[Sample, "id:GmzlKjP6pan9"] (* Model[Sample, "DreamTaq PCR Master Mix"] *)

(* ::Subsubsection::Closed:: *)
(* ExperimentPCR *)


(*---Main function accepting sample objects as sample inputs and sample objects or Nulls as primer pair inputs---*)
ExperimentPCR[
	mySamples:ListableP[ObjectP[Object[Sample]]],
	myPrimerPairSamples:ListableP[{{ObjectP[Object[Sample]],ObjectP[Object[Sample]]}..}|{{Null,Null}}],
	myOptions:OptionsPattern[ExperimentPCR]
]:=Module[
	{
		outputSpecification,output,gatherTests,resultQ,simulation,
		listedSamples,initialListedOptions,listedPrimerPairSamples,listedOptions,flatPrimerPairSamples,primerPairLengths,
		validSamplePreparationResult,mySamplesWithPreparedSamplesNamed,allPreparedSamples, myFlatPrimerPairSamplesWithPreparedSamplesNamed,myPrimerPairSamplesWithPreparedSamplesNamed,
		safeOpsNamed,safeOpsTests,mySamplesWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples,preExpandedNullPrimerPairSamples,safeOps,myOptionsWithPreparedSamples,myOptionsWithPreparedSamplesNamed,
		validLengths,validLengthTests,templatedOptions,templateTests,inheritedOptions,name,upload,confirm,canaryBranch,fastTrack,parentProtocol,priority,startDate,holdOrder,
		queuePosition,cache,currentSimulation,expandedSamples,nonNullExpandedPrimerPairSamples,expandedSafeOps,
		expandedPrimerPairSamples,pcrOptionsAssociation,masterMixes,buffers,liquidHandlerContainers,sampleObjectDownloadFields,allSamplePackets,allPrimerSamplePackets,masterMixPacket,
		bufferPacket,liquidHandlerContainerPackets,cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,performSimulationQ,updatedSimulation,
		resourceResult,roboticSimulation,runTime,resourcePacketTests,simulatedProtocol,simulatedProtocolSimulation,resolvedPreparation,protocolObject, optionsResolverOnly,
		returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ, modelContainerFields
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(*--Remove temporal links--*)
	{listedSamples,initialListedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];

	{listedPrimerPairSamples,listedOptions}=removeLinks[
		Switch[
			myPrimerPairSamples,
			{{ObjectP[]|_String,ObjectP[]|_String}..},{myPrimerPairSamples},
			{{{ObjectP[]|_String,ObjectP[]|_String}..}..}|{{{Null,Null}}..},myPrimerPairSamples
		],
		initialListedOptions
	];

	(* Flatten listedPrimerPairSamples to a list of primer pairs *)
	flatPrimerPairSamples=Flatten[listedPrimerPairSamples,1];

	(* Get the number of primer pairs per sample for bringing back the nested form of listedPrimerPairSamples *)
	primerPairLengths=Length/@listedPrimerPairSamples;
	(* Lookup the simulation - if one exists *)
	simulation=Lookup[listedOptions,Simulation];

	(*--Simulate sample preparation--*)
	(* initialSamplePreparationCache,samplePreparationCache *)
	validSamplePreparationResult=Check[
		{allPreparedSamples,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentPCR,
			Join[listedSamples, flatPrimerPairSamples],
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(*If we are given an invalid define name, return early*)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];
		Return[$Failed]
	];

	{mySamplesWithPreparedSamplesNamed, myFlatPrimerPairSamplesWithPreparedSamplesNamed}=TakeDrop[allPreparedSamples, Length[listedSamples]];

	currentSimulation = If[MatchQ[simulation,SimulationP],
		UpdateSimulation[simulation,updatedSimulation],
		updatedSimulation
	];

	(* Bring back the nested form of listedPrimerPairSamples *)
	myPrimerPairSamplesWithPreparedSamplesNamed=TakeList[myFlatPrimerPairSamplesWithPreparedSamplesNamed,primerPairLengths];

	(*--Call SafeOptions and ValidInputLengthsQ--*)
	(* Call SafeOptions to make sure all options match patterns *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentPCR,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentPCR,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Removed samplePreparationCache *)
	{
		{mySamplesWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples},
		{safeOps,myOptionsWithPreparedSamples}
	}=sanitizeInputs[
		{mySamplesWithPreparedSamplesNamed,myPrimerPairSamplesWithPreparedSamplesNamed},
		{safeOpsNamed,myOptionsWithPreparedSamplesNamed},
		Simulation -> currentSimulation
	];

	(* If the specified options don't match their patterns, return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all inputs and options have matching lengths *)
	{validLengths,validLengthTests}=If[gatherTests,
		If[NullQ[myPrimerPairSamplesWithPreparedSamples],
			ValidInputLengthsQ[ExperimentPCR,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,1,Output->{Result,Tests}],
			ValidInputLengthsQ[ExperimentPCR,{mySamplesWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples},myOptionsWithPreparedSamples,2,Output->{Result,Tests}]
		],
		If[NullQ[myPrimerPairSamplesWithPreparedSamples],
			{ValidInputLengthsQ[ExperimentPCR,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,1],Null},
			{ValidInputLengthsQ[ExperimentPCR,{mySamplesWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples},myOptionsWithPreparedSamples,2],Null}
		]
	];

	(* If input and option lengths are invalid, return $Failed (or the tests up to this point) *)
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
		ApplyTemplateOptions[ExperimentPCR,{mySamplesWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples},myOptionsWithPreparedSamples,2,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentPCR,{mySamplesWithPreparedSamples,myPrimerPairSamplesWithPreparedSamples},myOptionsWithPreparedSamples,2],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Replace our safe options with the inherited options from the template *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Get assorted hidden options *)
	{name,upload,confirm,canaryBranch,fastTrack,parentProtocol,priority,startDate,holdOrder,queuePosition,cache,currentSimulation}=Lookup[inheritedOptions,
		{Name,Upload,Confirm,CanaryBranch,FastTrack,ParentProtocol,Priority,StartDate,HoldOrder,QueuePosition,Cache,Simulation}
	];

	(*--Expand index-matching inputs and options--*)

	(* If there are no primer pairs (PrimerPairs == {{{Null,Null}}}) then it needs to be pre-expanded to match the Length of mySamplesWithPreparedSamples or it'll crash ExpandIndexMatchedInputs[] *)
	preExpandedNullPrimerPairSamples =
			If[MatchQ[myPrimerPairSamplesWithPreparedSamples, {{{Null, Null}}}],
				ConstantArray[{{Null, Null}}, Length[mySamplesWithPreparedSamples]],
				myPrimerPairSamplesWithPreparedSamples
			];

	(* Expand index-matching secondary input (primerPairs) and options *)
	{{expandedSamples,expandedPrimerPairSamples},expandedSafeOps}=ExpandIndexMatchedInputs[ExperimentPCR,{mySamplesWithPreparedSamples, preExpandedNullPrimerPairSamples},inheritedOptions,2];

	(*--Download the information we need for the option resolver and resource packet function--*)

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual *)
	pcrOptionsAssociation=Association[expandedSafeOps];

	(* Pull out the options that have objects whose information we need to download *)
	(* also include the resolution defaults to make sure we have the stuff for htem too *)
	masterMixes = Cases[Flatten[{$PCRDefaultMasterMix, Lookup[pcrOptionsAssociation, MasterMix]}], ObjectP[]];
	buffers = Cases[Flatten[{Model[Sample, "Milli-Q water"], Lookup[pcrOptionsAssociation, MasterMix]}], ObjectP[]];

	(* Get all the liquid handler-compatible containers, with the low-volume containers prepended *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];
	modelContainerFields = Packet[SamplePreparationCacheFields[Model[Container], Format -> Sequence]];

	(* Determine which fields in the sample Objects we need to download *)
	sampleObjectDownloadFields=Packet[DateUnsealed,UnsealedShelfLife,RequestedResources,IncompatibleMaterials,Notebook,Name,SamplePreparationCacheFields[Object[Sample],Format->Sequence]];

	(* Make the upfront Download call *)
	{allSamplePackets,allPrimerSamplePackets,masterMixPacket,bufferPacket,liquidHandlerContainerPackets}=Quiet[
		Download[
			{
				mySamplesWithPreparedSamples,
				Flatten[myPrimerPairSamplesWithPreparedSamples],
				masterMixes,
				buffers,
				liquidHandlerContainers
			},
				{
					{
						sampleObjectDownloadFields,
						Packet[Model[{Deprecated, Name}]],
						Packet[Container[{Name,Model,Status,Sterile,TareWeight,Contents,StorageCondition,Cover}]]
					},
					{
						sampleObjectDownloadFields,
						Packet[Model[{Deprecated, Name}]],
						Packet[Container[{Name,Model,Status,Sterile,TareWeight,Contents,StorageCondition}]]
					},
					{Packet[Notebook]},
					{Packet[Notebook]},
					{modelContainerFields}
				},
			Cache->FlattenCachePackets[{cache}],
			Simulation->updatedSimulation,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	(* Combine our downloaded and simulated cache *)
	cacheBall=FlattenCachePackets[{cache,allSamplePackets,allPrimerSamplePackets,masterMixPacket,bufferPacket,liquidHandlerContainerPackets}];

	(*--Build the resolved options--*)
	resolvedOptionsResult = Check[
		{resolvedOptions,resolvedOptionsTests} = If[gatherTests,
			resolveExperimentPCROptions[
				expandedSamples,
				expandedPrimerPairSamples,
				expandedSafeOps,
				Cache->cacheBall,
				Simulation->updatedSimulation,
				Output->{Result,Tests}
			],
			{
				resolveExperimentPCROptions[
					expandedSamples,
					expandedPrimerPairSamples,
					expandedSafeOps,
					Cache->cacheBall,
					Simulation->updatedSimulation
				],
				{}
			}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption, Error::ConflictingUnitOperationMethodRequirements}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentPCR,
		resolvedOptions,
		Ignore->myOptionsWithPreparedSamples,
		Messages->False
	];

	(* Lookup our resolved Preparation option. *)
	resolvedPreparation = Lookup[resolvedOptions, Preparation];

	(* Lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* If Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

	(* Run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* NOTE: We need to perform simulation if Result is asked for in PCR since it's part of the SamplePreparation experiments. *)
	(* This is because we pass down our simulation to ExperimentMSP or ExperimentRSP. *)
	(* If we are using robotic cell preparation, we need simulation *)
	performSimulationQ=Or[
		MemberQ[output, Simulation],
		And[
			MemberQ[output, Result],
			MatchQ[resolvedPreparation, Robotic]
		]
	];
	(* If we did get the result, we should try to quiet messages in simulation so that we will not duplicate them. We will just silently update our simulation *)
	resultQ = MemberQ[output, Result];

	(* If option resolution failed and we aren't asked for the simulation or output, return early *)
	If[(returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly)&&!performSimulationQ,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentPCR,collapsedResolvedOptions],
			Preview->Null,
			Simulation->Simulation[]
		}]
	];

	(*--Build packets with resources--*)
	{{resourceResult,roboticSimulation,runTime},resourcePacketTests}=Which[
		returnEarlyBecauseOptionsResolverOnly || returnEarlyBecauseFailuresQ,
			{{$Failed,$Failed,$Failed}, {}},
		gatherTests,
			experimentPCRResourcePackets[
				expandedSamples,
				expandedPrimerPairSamples,
				expandedSafeOps,
				resolvedOptions,
				Cache->cacheBall,
				Simulation->updatedSimulation,
				Output->{Result,Tests}
			],
		True,
			{
				experimentPCRResourcePackets[
					expandedSamples,
					expandedPrimerPairSamples,
					expandedSafeOps,
					resolvedOptions,
					Cache->cacheBall,
					Simulation->updatedSimulation
				],
				{}
			}
	];

	(* If we were asked for a simulation, also return a simulation *)
	{simulatedProtocol,simulatedProtocolSimulation}=Which[
		!performSimulationQ,
			{Null, updatedSimulation},
		MatchQ[resolvedPreparation, Robotic] && MatchQ[roboticSimulation, SimulationP],
			{Null, roboticSimulation},
		!resultQ,
			simulateExperimentPCR[
				If[MatchQ[resourceResult,$Failed],
					$Failed,
					First[resourceResult](*protocolPacket*)
				],
				If[MatchQ[resourceResult,$Failed],
					$Failed,
					Rest[resourceResult](*unitOperationPacket*)
				],
				expandedSamples,
				expandedPrimerPairSamples,
				resolvedOptions,
				Cache->cacheBall,
				Simulation->updatedSimulation,
				ParentProtocol->parentProtocol
			],
		True,
			simulateExperimentPCR[
				If[MatchQ[resourceResult,$Failed],
					$Failed,
					First[resourceResult](*protocolPacket*)
				],
				If[MatchQ[resourceResult,$Failed],
					$Failed,
					Rest[resourceResult](*unitOperationPacket*)
				],
				expandedSamples,
				expandedPrimerPairSamples,
				resolvedOptions,
				Cache->cacheBall,
				Simulation->updatedSimulation,
				ParentProtocol->parentProtocol
			]
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options->RemoveHiddenOptions[ExperimentPCR,collapsedResolvedOptions],
			Preview->Null,
			Simulation->simulatedProtocolSimulation,
			(* The time to process Thermocycler PCR reaction. *)
			RunTime -> runTime
		}]
	];

	(* We have to return the result. Call UploadProtocol to prepare our protocol packet (and upload it if requested) *)

	protocolObject=Which[
		(* If our resource packets failed, we can't upload anything *)
		MatchQ[resourceResult,$Failed]||MatchQ[resolvedOptionsResult,$Failed],
			$Failed,

		(* If we're in global script simulation mode and are Preparation->Manual, we want to upload our simulation to the global simulation *)
		MatchQ[$CurrentSimulation,SimulationP]&& MatchQ[resolvedPreparation, Manual],
			Module[{},
				UpdateSimulation[$CurrentSimulation,simulatedProtocolSimulation];

				If[MatchQ[upload,False],
					Lookup[simulatedProtocolSimulation[[1]],Packets],
					simulatedProtocol
				]
			],

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if Upload->False *)
		MatchQ[resolvedPreparation,Robotic]&&MatchQ[upload,False],
			Rest[resourceResult],(*unitOperationPacket*)

		(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticSamplePreparation with our primitive *)
		MatchQ[resolvedPreparation,Robotic],
			Module[{primitive,nonHiddenOptions},
				(* Create our PCR primitive to feed into RoboticSamplePreparation *)
				primitive=PCR@@Join[
					{
						Sample->expandedSamples,
						PrimerPair->expandedPrimerPairSamples
					},
					RemoveHiddenPrimitiveOptions[PCR,listedOptions]
				];

				(* Remove any hidden options before returning *)
				nonHiddenOptions=RemoveHiddenOptions[ExperimentPCR,collapsedResolvedOptions];

				(* Memoize the value of ExperimentPCR so the framework doesn't spend time resolving it again *)
				Internal`InheritedBlock[{ExperimentPCR, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentPCR]={};

					ExperimentPCR[___,options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for *)
						frameworkOutputSpecification=Lookup[ToList[options],Output];

						frameworkOutputSpecification/.{
							Result->Rest[resourceResult],
							Options->nonHiddenOptions,
							Preview->Null,
							Simulation->simulatedProtocolSimulation,
							RunTime -> runTime
						}
					];

					(* PCR can only be done on bioSTAR/microbioSTAR, so call RCP *)
					ExperimentRoboticCellPreparation[
						{primitive},
						Name->name,
						Upload->upload,
						Confirm->confirm,
						CanaryBranch->canaryBranch,
						ParentProtocol->parentProtocol,
						Priority->priority,
						StartDate->startDate,
						HoldOrder->holdOrder,
						QueuePosition->queuePosition,
						Cache->cacheBall
					]
				]
			],

		(* Actually upload our protocol object. *)
		True,
		(* NOTE: If Preparation->Manual, we don't have auxillary unit operation packets since there aren't batches. *)
		(* We only have unit operation packets when doing robotic. *)
			UploadProtocol[
				resourceResult[[1]],(*protocolPacket*)
				Upload->upload,
				Confirm->confirm,
				CanaryBranch->canaryBranch,
				ParentProtocol->parentProtocol,
				Priority->priority,
				StartDate->startDate,
				HoldOrder->holdOrder,
				QueuePosition->queuePosition,
				ConstellationMessage->Object[Protocol,PCR],
				Cache->cacheBall,
				Simulation->simulatedProtocolSimulation
			]
	];

	(* Return the requested output *)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options->RemoveHiddenOptions[ExperimentPCR,collapsedResolvedOptions],
		Preview->Null,
		Simulation->simulatedProtocolSimulation,
		RunTime -> runTime
	}
];


(*---Function overload accepting (defined) sample/container objects as sample inputs and (defined) sample/container objects or Nulls as primer pair inputs---*)
ExperimentPCR[
	myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],
	myPrimerPairContainers:ListableP[{{ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]},ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}}..}|{{Null,Null}}],
	myOptions:OptionsPattern[ExperimentPCR]
]:=Module[
	{
		outputSpecification,output,gatherTests,listedSamples,initialListedOptions,listedPrimerPairSamples,listedOptions,
		flatPrimerPairSamples,primerPairLengths,miniSafeOptions,specifiedPreparedModelContainer,specifiedPreparedModelAmount,
		allPreparedSamples,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamplesWithModifiedPreparedModelOps,
		myFlatPrimerPairSamplesWithPreparedSamples,myOptionsWithPreparedSamples,containerToSampleSimulation,
		containerToSampleResult,containerToSampleOutput,containerToSampleTests,updatedSimulation,primerContainerToSampleSimulation,
		primerContainerToSampleResult,primerContainerToSampleOutput,primerContainerToSampleTests,myPrimerPairSamplesWithPreparedSamples,
		combinedContainerToSampleTests,updatedCache,samples,sampleOptions
	},


	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(*--Remove temporal links--*)
	{listedSamples,initialListedOptions}=removeLinks[ToList[myContainers],ToList[myOptions]];

	{listedPrimerPairSamples,listedOptions}=removeLinks[
		Switch[
			myPrimerPairContainers,
			{{ObjectP[]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]},ObjectP[]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}}..},{myPrimerPairContainers},
			{{{ObjectP[]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]},ObjectP[]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}}..}..}|{{{Null,Null}}..},myPrimerPairContainers
		],
		initialListedOptions
	];

	(* Flatten listedPrimerPairSamples to a list of primer pairs *)
	flatPrimerPairSamples=Flatten[listedPrimerPairSamples,1];

	(* Get the number of primer pairs per sample for bringing back the nested primer pairs form *)
	primerPairLengths=Length/@listedPrimerPairSamples;

	(* Need to check the PreparedModelContainer and PreparedModelAmount options, since ModelInputOptions are technically index-matching to listedSamples *)
	(* but in simulateSamplePreparationPacketsNew we use them to do both listedSamples and flatPrimerPairSamples. *)
	(* To make LabelSample works for both listedSamples and flatPrimerPairSamples, we do a trick here to extract user-specified value as default *)
	(* What we should really do is to introduce PrimerPairPreparedModelAmount and PrimerPairPreparedModelContainer in the future which is a low priority *)
	miniSafeOptions = Quiet[SafeOptions[ExperimentPCR, listedOptions, AutoCorrect -> True]];
	{specifiedPreparedModelContainer, specifiedPreparedModelAmount} = Lookup[miniSafeOptions, {PreparedModelContainer, PreparedModelAmount}];

	(*--Simulate sample preparation--*)
	(* initialSamplePreparationCache,samplePreparationCache *)
	validSamplePreparationResult=Check[
		{allPreparedSamples,myOptionsWithPreparedSamplesWithModifiedPreparedModelOps,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentPCR,
			Join[listedSamples, flatPrimerPairSamples],
			(* in order for the index matching to work here, need to un-expand things *)
			ReplaceRule[listedOptions, {PreparedModelContainer -> Automatic, PreparedModelAmount -> Automatic}],
			DefaultPreparedModelContainer -> FirstCase[ToList@specifiedPreparedModelContainer, ObjectP[Model[Container]], Model[Container, Vessel, "2mL Tube"]],
			DefaultPreparedModelAmount -> FirstCase[ToList@specifiedPreparedModelAmount, UnitsP[]|All, 1 Milliliter]
		],
		$Failed,
	 	{Download::ObjectDoesNotExist, Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];
		Return[$Failed]
	];

	{mySamplesWithPreparedSamples, myFlatPrimerPairSamplesWithPreparedSamples}=TakeDrop[allPreparedSamples, Length[listedSamples]];

	(* put the "proper" specified preparatory models in here now *)
	(* need to switch back to the not-expanded version of this option again *)
	(* Our current index matching system does not support ModelInputOptions match to 3 input sample groups *)
	(* Have to Null the value but it is okay since LabelSample has been created in PreparatoryUnitOperations during simulateSamplePreparationPacketsNew so ModelInputOptions are useless now *)
	myOptionsWithPreparedSamples = ReplaceRule[myOptionsWithPreparedSamplesWithModifiedPreparedModelOps, {PreparedModelContainer -> Null, PreparedModelAmount -> Null}];

	(*--Convert the given containers into samples and sample index-matched options--*)

	(*-Samples-*)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentPCR,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation->updatedSimulation,
			Cache->Lookup[myOptionsWithPreparedSamples,Cache,{}]
		];

		(* Therefore, we have to run the tests to see if we encountered a failure *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption *)
		Check[
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentPCR,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result,Simulation},
				Simulation->updatedSimulation,
				Cache->Lookup[myOptionsWithPreparedSamples,Cache,{}]
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(*-Primers-*)
	primerContainerToSampleResult=If[!NullQ[myFlatPrimerPairSamplesWithPreparedSamples],
		If[gatherTests,
			(*We are gathering tests. This silences any messages being thrown*)
			{primerContainerToSampleOutput,primerContainerToSampleTests,primerContainerToSampleSimulation}=containerToSampleOptions[
				ExperimentPCR,
				Flatten[myFlatPrimerPairSamplesWithPreparedSamples,1],
				myOptionsWithPreparedSamples,
				Output->{Result,Tests,Simulation},
				Simulation->containerToSampleSimulation,
				Cache->Lookup[myOptionsWithPreparedSamples,Cache,{}]
			];

			(* Therefore, we have to run the tests to see if we encountered a failure *)
			If[RunUnitTest[<|"Tests"->primerContainerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
				Null,
				$Failed
			],

			(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption *)
			Check[
				{primerContainerToSampleOutput,primerContainerToSampleSimulation}=containerToSampleOptions[
					ExperimentPCR,
					Flatten[myFlatPrimerPairSamplesWithPreparedSamples,1],
					myOptionsWithPreparedSamples,
					Output-> {Result,Simulation},
					Simulation->containerToSampleSimulation,
					Cache->Lookup[myOptionsWithPreparedSamples,Cache,{}]
				],
				$Failed,
				{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
			]
		]
	];


	(* Bring back the nested form of primer pairs after converting containers to samples: first partition into lists of length 2 to regenerate primer pairs, then partition primer pairs as they originally were *)
	myPrimerPairSamplesWithPreparedSamples=If[!NullQ[myFlatPrimerPairSamplesWithPreparedSamples],
		TakeList[
			Partition[First[primerContainerToSampleOutput],2],
			primerPairLengths
		],
		TakeList[
			myFlatPrimerPairSamplesWithPreparedSamples,
			primerPairLengths
		]
	];

	(*-Combine sample and primer input container-to-sample tests-*)
	combinedContainerToSampleTests=If[!NullQ[myFlatPrimerPairSamplesWithPreparedSamples],
		Join[containerToSampleTests,primerContainerToSampleTests],
		containerToSampleTests
	];

	(* Update our cache with the new simulated values *)
	(* It is important that the sample preparation cache appears first in the cache ball *)
	updatedCache=FlattenCachePackets[{
		Lookup[listedOptions,Cache,{}]
	}];

	(* If we were given an empty container, return early *)
	If[Or[MatchQ[containerToSampleResult,$Failed],MatchQ[primerContainerToSampleResult,$Failed]],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result->$Failed,
			Tests->combinedContainerToSampleTests,
			Options->$Failed,
			Preview->Null
		},

		(* Split up our containerToSample result into samples and sampleOptions *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call the main function with our samples and converted options *)
		ExperimentPCR[
			samples,
			myPrimerPairSamplesWithPreparedSamples,
			ReplaceRule[sampleOptions,{Simulation->If[!NullQ[myFlatPrimerPairSamplesWithPreparedSamples],primerContainerToSampleSimulation,containerToSampleSimulation]}]
		]
	]
];


(*---Function definition accepting sample/container objects as sample inputs and no primer pair inputs---*)
ExperimentPCR[
	mySamples:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],
	myOptions:OptionsPattern[ExperimentPCR]
]:=ExperimentPCR[
	mySamples,
	Table[{{Null,Null}},Length[Cases[Flatten[ToList[mySamples]],Except[LocationPositionP]]]],
	myOptions
];

(*---Function definition accepting sample/container objects as sample inputs and no primer pair inputs---*)
ExperimentPCR[
	mySamples:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],
	myPrimerPairs:NullP,
	myOptions:OptionsPattern[ExperimentPCR]
]:=ExperimentPCR[
	mySamples,
	Table[{{Null,Null}},Length[Cases[Flatten[ToList[mySamples]],Except[LocationPositionP]]]],
	myOptions
];


(* ::Subsubsection::Closed:: *)
(* resolveExperimentPCROptions *)


DefineOptions[resolveExperimentPCROptions,
	Options:>{
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];


resolveExperimentPCROptions[
	myListedSamples:ListableP[ObjectP[Object[Sample]]],
	myListedPrimerPairSamples:ListableP[{{ObjectP[Object[Sample]],ObjectP[Object[Sample]]}..}|{{{Null,Null}}..}],
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentPCROptions]
]:=
    Module[
	{
		outputSpecification,output,gatherTests,messages,notInEngine,warnings,inheritedCache,simulation,samplePrepOptions,pcrOptions,
		simulatedSamples,resolvedSamplePrepOptions,samplePrepTests, expandedListedPrimerPairSamples,flatPrimerSamples,primerPairLengths,pcrOptionsAssociation,
		instrument,masterMix,masterMixLabel,masterMixContainerLabel,masterMixStorageCondition,buffer,bufferLabel,bufferContainerLabel,assayPlate,assayPlateLabel,activation,
		primerAnnealing,finalExtension,fastTrack,name,parentProtocol,sampleObjectDownloadFields,allSamplePackets,allPrimerSamplePackets,masterMixPacket,bufferPacket,
		samplePackets,sampleModelPackets,sampleContainerPackets,sampleContainers, primerSamplePackets,primerSampleModelPackets,primerSampleContainerPackets,
		primerSampleContainers,expandedListedPrimerPairSampleContainers, discardedSamplePackets,discardedPrimerPairSamplePackets,allDiscardedSamplePackets,
		discardedInvalidInputs,discardedTest,sampleModelPacketsToCheck,deprecatedSampleModelPackets,primerPairSampleModelPacketsToCheck,deprecatedPrimerPairSampleModelPackets,
		allDeprecatedSampleModelPackets,deprecatedInvalidInputs,deprecatedTest,tooManySamplesQ,tooManySamplesInvalidInputs,tooManySamplesTest,
		roundedPCROptions,precisionTests,sampleVolume,forwardPrimerVolume,reversePrimerVolume,bufferVolume,lidTemperature,reactionVolume,masterMixVolume,
		activationTime,activationTemperature,activationRampRate,denaturationTime,denaturationTemperature,denaturationRampRate,
		primerAnnealingTime,primerAnnealingTemperature,primerAnnealingRampRate,extensionTime,extensionTemperature,extensionRampRate,
		finalExtensionTime,finalExtensionTemperature,finalExtensionRampRate,holdTemperature,validPreparedPlateQ,preparedPlateInvalidInputs,validPreparedPlateTest,
		validNameQ,invalidNameOptions,validNameTest,forwardPrimerVolumeMismatchQ,forwardPrimerVolumeMismatchOptions,forwardPrimerVolumeMismatchTest,reversePrimerVolumeMismatchQ,
		reversePrimerVolumeMismatchOptions,reversePrimerVolumeMismatchTest,validBufferVolumeQ,invalidBufferVolumeOptions,validBufferVolumeTest,validMasterMixVolumeQ,
		invalidMasterMixVolumeOptions,validMasterMixVolumeTest,validMasterMixStorageConditionQ,invalidMasterMixStorageConditionOptions,validMasterMixStorageConditionTest,
		preparationResult,allowedPreparation,preparationTest,resolvedPreparation,allowedWorkCells,resolvedWorkCell,resolvedMasterMixLabel,resolvedMasterMixContainerLabel,resolvedMasterMixVolume,
		updatedRoundedPCROptions,resolvedBufferLabel,resolvedBufferContainerLabel,resolvedAssayPlate,resolvedAssayPlateLabel,resolvedActivation,resolvedActivationTime,
		resolvedActivationTemperature,resolvedActivationRampRate,validActivationQ,activationMismatchOptions,activationMismatchTest,
		resolvedPrimerAnnealing,resolvedPrimerAnnealingTime,resolvedPrimerAnnealingTemperature,resolvedPrimerAnnealingRampRate,validPrimerAnnealingQ,
		primerAnnealingMismatchOptions,primerAnnealingMismatchTest,resolvedFinalExtension,resolvedFinalExtensionTime,resolvedFinalExtensionTemperature,
		resolvedFinalExtensionRampRate,validFinalExtensionQ,finalExtensionMismatchOptions,finalExtensionMismatchTest,
		objectToNewResolvedLabelLookup,mapThreadFriendlyOptions,forwardPrimerStorageConditionErrors,reversePrimerStorageConditionErrors,totalVolumeTooLargeErrors,
		resolvedForwardPrimerVolume,resolvedForwardPrimerStorageCondition,resolvedReversePrimerVolume,resolvedReversePrimerStorageCondition,resolvedBufferVolume,
		resolvedSampleLabel,resolvedSampleContainerLabel,resolvedForwardPrimerLabel,resolvedForwardPrimerContainerLabel,resolvedReversePrimerLabel,
		resolvedReversePrimerContainerLabel,resolvedSampleOutLabel,invalidForwardPrimerStorageConditionOptions,validForwardPrimerStorageConditionTest,
		invalidReversePrimerStorageConditionOptions,validReversePrimerStorageConditionTest,totalVolumeOverReactionVolumeOptions,totalVolumeTest,updatedSimulation,
		targetContainers,resolvedAliquotOptions,aliquotTests,compatibleMaterialsBool,compatibleMaterialsTests,compatibleMaterialsInvalidOption,
		resolvedPostProcessingOptions,invalidInputs,invalidOptions,resolvedEmail,resolvedPrimerPairLabel,resolvedPrimerPairContainerLabel,resolvedOptions,
		allTests,resultRule,testsRule, preparedPlate, specifiedMasterMix, specifiedBuffer, specifiedPreparedPlate, specifiedSampleVolume,
		sampleVolumeNotRounded, sampleVolumeTests},


	(*---Set up the user-specified options and cache---*)

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Determine if we are in Engine or not, in Engine we silence warnings *)
	notInEngine=!MatchQ[$ECLApplication,Engine];
	warnings = !gatherTests && !MatchQ[$ECLApplication, Engine];

	(* Fetch our options cache from the parent function *)
	inheritedCache=Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation=Lookup[ToList[myResolutionOptions],Simulation,Null];

	(* Split up myOptions into samplePrepOptions and pcrOptions *)
	{samplePrepOptions,pcrOptions}=splitPrepOptions[myOptions];

	(* Resolve sample prep options *)

	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentPCR,myListedSamples,samplePrepOptions,Cache->inheritedCache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentPCR,myListedSamples,samplePrepOptions,Cache->inheritedCache,Simulation->simulation,Output->Result],{}}
	];

	expandedListedPrimerPairSamples=If[Length[myListedPrimerPairSamples]==Length[myListedSamples],
		myListedPrimerPairSamples,
		ConstantArray[Flatten[myListedPrimerPairSamples,1],Length[myListedSamples]]
	];

	(* Flatten expandedListedPrimerPairSamples to a list of primers *)
	flatPrimerSamples=Flatten[expandedListedPrimerPairSamples];

	(* Get the number of primer pairs per sample for bringing back the nested form of expandedListedPrimerPairSamples *)
	primerPairLengths=Length/@expandedListedPrimerPairSamples;

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual *)
	pcrOptionsAssociation=Association[pcrOptions];

	(* Pull out the options that are defaulted or specified that don't have precision *)
	{
		instrument,
		specifiedPreparedPlate,
		specifiedSampleVolume,
		specifiedMasterMix,
		masterMixLabel,
		masterMixContainerLabel,
		masterMixStorageCondition,
		specifiedBuffer,
		bufferLabel,
		bufferContainerLabel,
		assayPlate,
		assayPlateLabel,
		activation,
		primerAnnealing,
		finalExtension,
		fastTrack,
		name,
		parentProtocol
	} = Lookup[
		pcrOptionsAssociation,
		{
			Instrument,
			PreparedPlate,
			SampleVolume,
			MasterMix,
			MasterMixLabel,
			MasterMixContainerLabel,
			MasterMixStorageCondition,
			Buffer,
			BufferLabel,
			BufferContainerLabel,
			AssayPlate,
			AssayPlateLabel,
			Activation,
			PrimerAnnealing,
			FinalExtension,
			FastTrack,
			Name,
			ParentProtocol
		}
	];

	(* SUPER EARLY resolution of the PreparedPlate, MasterMix, SampleVolume, and Buffer options; this is because we need to do some Downloading and error checking early on *)
	preparedPlate = Which[
		(* if it's specified it's specified *)
		Not[MatchQ[specifiedPreparedPlate, Automatic]], specifiedPreparedPlate,
		(* if MasterMix and Buffer are explicitly set to Null and we don't have any primers, then PreparedPlate is True *)
		And[
			NullQ[specifiedMasterMix],
			NullQ[specifiedBuffer],
			MatchQ[flatPrimerSamples,ListableP[Null]]
		],
			True,
		(* otherwise, this is False *)
		True, False
	];
	buffer = Which[
		(* if it's specified it's specified *)
		Not[MatchQ[specifiedBuffer, Automatic]], specifiedBuffer,
		(* if PreparedPlate is set to True, then this is Null *)
		TrueQ[preparedPlate], Null,
		(* else, set to water *)
		True, Model[Sample, "id:8qZ1VWNmdLBD"] (* Model[Sample, "Milli-Q water"] *)
	];
	masterMix = Which[
		(* if it's specified it's specified *)
		Not[MatchQ[specifiedMasterMix, Automatic]], specifiedMasterMix,
		(* if PreparedPlate is set to True, then this is Null *)
		TrueQ[preparedPlate], Null,
		(* else, set to the default master mix *)
		True, $PCRDefaultMasterMix
	];

	(* SampleVolume similar to above, but the differences are that 1.) It's index matching, and 2.) It needs to be rounded since it's a number.  So do that *)
	sampleVolumeNotRounded = Map[
		Which[
			(* if it's specified it's specified *)
			Not[MatchQ[#, Automatic]], #,
			(* if PreparedPlate is set to True, then this is 0 Microliter *)
			TrueQ[preparedPlate], 0 Microliter,
			(* else, default to 2 Microliter *)
			True, 2 Microliter
		]&,
		specifiedSampleVolume
	];

	(* doing this weird rounding to ensure I still throw the message from RoundOptionPrecision (which seemingly only happens with the option overload and not the direct quantity one) *)
	{sampleVolume, sampleVolumeTests} = If[gatherTests,
		With[{optionsAndTests = RoundOptionPrecision[<|SampleVolume -> sampleVolumeNotRounded|>, {SampleVolume}, {10^-1 Microliter}, Output -> {Result, Tests}]},
			{
				Lookup[optionsAndTests[[1]], SampleVolume],
				optionsAndTests[[2]]
			}
		],
		{
			Lookup[
				RoundOptionPrecision[<|SampleVolume -> sampleVolumeNotRounded|>, {SampleVolume}, {10^-1 Microliter}],
				SampleVolume
			],
			{}
		}
	];

	(* Define the object fields from which to download information *)
	sampleObjectDownloadFields=Packet[DateUnsealed,UnsealedShelfLife,RequestedResources,IncompatibleMaterials,Notebook,SamplePreparationCacheFields[Object[Sample],Format->Sequence]];

	(* Extract the packets that we need from our downloaded cache *)
	{
		allSamplePackets,
		allPrimerSamplePackets,
		masterMixPacket,
		bufferPacket
	}=Quiet[
		Download[
			{simulatedSamples,flatPrimerSamples,{masterMix},{buffer}},
			{
				{
					sampleObjectDownloadFields,
					Packet[Model[Deprecated]],
					Packet[Container[{Name,Model,Status,Sterile,TareWeight,Contents,StorageCondition,Cover}]]
				},
				{
					sampleObjectDownloadFields,
					Packet[Model[Deprecated]],
					Packet[Container[{Name,Model,Status,Sterile,TareWeight,Contents,StorageCondition}]]
				},
				{Packet[Notebook]},
				{Packet[Notebook]}
			},
			Cache->inheritedCache,
			Simulation->updatedSimulation
		],
		{Download::FieldDoesntExist}
	];

	(* Extract the sample packets *)
	{samplePackets,sampleModelPackets,sampleContainerPackets,sampleContainers}={allSamplePackets[[All,1]],allSamplePackets[[All,2]],allSamplePackets[[All,3]],Lookup[allSamplePackets[[All,3]],Object]};

	(*E xtract the primer packets *)
	{primerSamplePackets,primerSampleModelPackets,primerSampleContainerPackets,primerSampleContainers}=If[!NullQ[allPrimerSamplePackets],
		{allPrimerSamplePackets[[All,1]],allPrimerSamplePackets[[All,2]],allPrimerSamplePackets[[All,3]],Lookup[allPrimerSamplePackets[[All,3]],Object]},
		Table[Null,4]
	];

	(* Nest primerSampleContainers to index-match to expandedListedPrimerPairSamples *)
	expandedListedPrimerPairSampleContainers=If[!NullQ[allPrimerSamplePackets],
		TakeList[Partition[primerSampleContainers,2],primerPairLengths],
		Table[{{Null,Null}},Length[samplePackets]]
	];


	(*---Input validation checks I---*)

	(*--Discarded input check--*)

	(* Get the sample packets from simulatedSamples that are discarded *)
	discardedSamplePackets=Cases[samplePackets,KeyValuePattern[Status->Discarded]];

	(* Get the sample packets from expandedListedPrimerPairSamples that are discarded *)
	discardedPrimerPairSamplePackets=If[!NullQ[allPrimerSamplePackets],
		Cases[primerSamplePackets,KeyValuePattern[Status->Discarded]],
		{}
	];

	(*J oin these two lists of discarded sample packets *)
	allDiscardedSamplePackets=Join[discardedSamplePackets,discardedPrimerPairSamplePackets];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[allDiscardedSamplePackets,{}],
		{},
		Lookup[allDiscardedSamplePackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages (not gathering tests), throw an error message and keep track of the invalid inputs *)
	If[Length[discardedInvalidInputs]>0&&messages,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->inheritedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->inheritedCache]<>" are not discarded:",True,False]
			];
			passingTest=If[Length[discardedInvalidInputs]==Length[Join[simulatedSamples,flatPrimerSamples]],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[
					If[NullQ[flatPrimerSamples],
						simulatedSamples,
						Join[simulatedSamples,flatPrimerSamples]
					],discardedInvalidInputs],Cache->inheritedCache]<>" are not discarded:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*--Deprecated input check--*)

	(* Get the model packets from simulatedSamples that will be checked for whether they are deprecated *)
	sampleModelPacketsToCheck=Cases[Flatten[sampleModelPackets],PacketP[Model[Sample]]];

	(* Get the model packets from simulatedSamples that are deprecated; if on the FastTrack, skip this check *)
	deprecatedSampleModelPackets=If[!fastTrack,
		Select[sampleModelPacketsToCheck,TrueQ[Lookup[#,Deprecated]]&],
		{}
	];

	If[!NullQ[allPrimerSamplePackets],

		(* Get the model packets from expandedListedPrimerPairSamples that will be checked for whether they are deprecated *)
		primerPairSampleModelPacketsToCheck=Cases[primerSampleModelPackets,PacketP[Model[Sample]]];

		(* Get the model packets from expandedListedPrimerPairSamples that are deprecated; if on the FastTrack, skip this check *)
		deprecatedPrimerPairSampleModelPackets=If[!fastTrack,
			Select[primerPairSampleModelPacketsToCheck,TrueQ[Lookup[#,Deprecated]]&],
			{}
		],

		primerPairSampleModelPacketsToCheck={};
		deprecatedPrimerPairSampleModelPackets={}
	];

	(* Join these two lists of deprecated model packets *)
	allDeprecatedSampleModelPackets=Join[deprecatedSampleModelPackets,deprecatedPrimerPairSampleModelPackets];

	(* Set deprecatedInvalidInputs to the input objects whose models are Deprecated *)
	deprecatedInvalidInputs=If[MatchQ[allDeprecatedSampleModelPackets,{}],
		{},
		Lookup[allDeprecatedSampleModelPackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	If[Length[deprecatedInvalidInputs]>0&&messages,
		Message[Error::DeprecatedModels,ObjectToString[deprecatedInvalidInputs,Cache->inheritedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result *)
	deprecatedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[deprecatedInvalidInputs]==0,
				Nothing,
				Test["Our input samples have models "<>ObjectToString[deprecatedInvalidInputs,Cache->inheritedCache]<>" that are not deprecated:",True,False]
			];
			passingTest=If[Length[deprecatedInvalidInputs]==Length[Join[sampleModelPacketsToCheck,primerPairSampleModelPacketsToCheck]],
				Nothing,
				Test["Our input samples have models "<>ObjectToString[Complement[Join[sampleModelPacketsToCheck,primerPairSampleModelPacketsToCheck],deprecatedInvalidInputs],Cache->inheritedCache]<>" that are not deprecated:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*--Too many samples check--*)

	(* Check if there are too many samples for the 96-well plate *)
	tooManySamplesQ=Length[simulatedSamples]>96;

	(* Set tooManySamplesInvalidInputs to all sample objects *)
	tooManySamplesInvalidInputs=If[tooManySamplesQ,
		Lookup[samplePackets,Object],
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	If[Length[tooManySamplesInvalidInputs]>0&&messages,
		Message[Error::PCRTooManySamples]
	];

	(* If we are gathering tests, create a test for too many samples *)
	tooManySamplesTest=If[gatherTests,
		Test["There are 96 or fewer input samples:",
			tooManySamplesQ,
			False
		],
		Nothing
	];


	(*---Option precision checks---*)

	(* Round the options that have precision *)
	{roundedPCROptions,precisionTests}=If[gatherTests,
		RoundOptionPrecision[
			pcrOptionsAssociation,
			{ForwardPrimerVolume,ReversePrimerVolume,BufferVolume,LidTemperature,ReactionVolume,MasterMixVolume,ActivationTime,ActivationTemperature,ActivationRampRate,DenaturationTime,DenaturationTemperature,DenaturationRampRate,PrimerAnnealingTime,PrimerAnnealingTemperature,PrimerAnnealingRampRate,ExtensionTime,ExtensionTemperature,ExtensionRampRate,FinalExtensionTime,FinalExtensionTemperature,FinalExtensionRampRate,HoldTemperature},
			{10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Celsius,10^-1 Microliter,10^-1 Microliter,1 Second,10^-1 Celsius,10^-1 Celsius/Second,1 Second,10^-1 Celsius,10^-1 Celsius/Second,1 Second,10^-1 Celsius,10^-1 Celsius/Second,1 Second,10^-1 Celsius,10^-1 Celsius/Second,1 Second,10^-1 Celsius,10^-1 Celsius/Second,10^-1 Celsius},
			Output->{Result,Tests}
		],
		{
			RoundOptionPrecision[
				pcrOptionsAssociation,
				{ForwardPrimerVolume,ReversePrimerVolume,BufferVolume,LidTemperature,ReactionVolume,MasterMixVolume,ActivationTime,ActivationTemperature,ActivationRampRate,DenaturationTime,DenaturationTemperature,DenaturationRampRate,PrimerAnnealingTime,PrimerAnnealingTemperature,PrimerAnnealingRampRate,ExtensionTime,ExtensionTemperature,ExtensionRampRate,FinalExtensionTime,FinalExtensionTemperature,FinalExtensionRampRate,HoldTemperature},
				{10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Celsius,10^-1 Microliter,10^-1 Microliter,1 Second,10^-1 Celsius,10^-1 Celsius/Second,1 Second,10^-1 Celsius,10^-1 Celsius/Second,1 Second,10^-1 Celsius,10^-1 Celsius/Second,1 Second,10^-1 Celsius,10^-1 Celsius/Second,1 Second,10^-1 Celsius,10^-1 Celsius/Second,10^-1 Celsius}
			],
			{}
		}
	];

	(* Pull out the rounded options *)
	{forwardPrimerVolume,reversePrimerVolume,bufferVolume,lidTemperature,reactionVolume,masterMixVolume,activationTime,activationTemperature,activationRampRate,denaturationTime,denaturationTemperature,denaturationRampRate,primerAnnealingTime,primerAnnealingTemperature,primerAnnealingRampRate,extensionTime,extensionTemperature,extensionRampRate,finalExtensionTime,finalExtensionTemperature,finalExtensionRampRate,holdTemperature}=Lookup[
		roundedPCROptions,
		{ForwardPrimerVolume,ReversePrimerVolume,BufferVolume,LidTemperature,ReactionVolume,MasterMixVolume,ActivationTime,ActivationTemperature,ActivationRampRate,DenaturationTime,DenaturationTemperature,DenaturationRampRate,PrimerAnnealingTime,PrimerAnnealingTemperature,PrimerAnnealingRampRate,ExtensionTime,ExtensionTemperature,ExtensionRampRate,FinalExtensionTime,FinalExtensionTemperature,FinalExtensionRampRate,HoldTemperature}
	];


	(*---Input validation checks II---*)

	(*--Prepared plate check--*)

	(* check if a prepared plate was provided. In this situation, there is no master mix, buffer or primers *)
	(* in this case, the samples should all be in the same compatible PCR plate *)
	(* We allow to 3 models of PCR plates. *)
	validPreparedPlateQ=If[preparedPlate,
		And[
			MatchQ[Lookup[sampleContainerPackets,Model],{LinkP[{Model[Container,Plate,"96-well Optical Full-Skirted PCR Plate"],Model[Container,Plate,"96-well PCR Plate"],Model[Container, Plate, "96-well Optical Semi-Skirted PCR Plate"]}]..}],
			SameQ@@Lookup[sampleContainerPackets,Object]
		],
		True
	];

	(* If prepared plate test fails, treat all of the input samples as invalid *)
	preparedPlateInvalidInputs=If[!validPreparedPlateQ,
		Lookup[samplePackets,Object],
		{}
	];

	(* Throw error if the prepared plate check is false *)
	If[!validPreparedPlateQ&&messages,
		Message[Error::InvalidPreparedPlate]
	];

	(* If we are gathering tests, create a test for a prepared plate error *)
	validPreparedPlateTest=If[gatherTests,
		Test["When using a prepared plate by specifying PreparedPlate -> True (or not specifying primers, master mix, buffer, and zero for sample volumes), the input samples are all in one PCR plate with model Model[Container, Plate, \"96-well Optical Full-Skirted PCR Plate\"], Model[Container,Plate,\"96-well PCR Plate\"], or Model[Container, Plate, \"96-well Optical Semi-Skirted PCR Plate\"]:",
			validPreparedPlateQ,
			True
		],
		Nothing
	];


	(*---Conflicting options checks---*)

	(*--Check that Name is properly specified--*)

	(* If the specified Name is a string, check if this name exists in the Database already *)
	validNameQ=If[MatchQ[name,_String],
		Not[DatabaseMemberQ[Object[Protocol,PCR,name]]],
		True
	];

	(* If validNameQ is False and we are throwing messages, then throw an error message *)
	invalidNameOptions=If[!validNameQ&&messages,
		(
			Message[Error::DuplicateName,"PCR protocol"];
			{Name}
		),
		{}
	];

	(* If we are gathering tests, create a test for Name *)
	validNameTest=If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already a PCR protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(*--Check that ForwardPrimer options aren't in conflict--*)

	(* Check if ForwardPrimerVolume conflicts with forward primer inputs *)
	forwardPrimerVolumeMismatchQ=Or[
		NullQ[allPrimerSamplePackets]&&MatchQ[forwardPrimerVolume,Except[ListableP[Automatic|Null]]],
		!NullQ[allPrimerSamplePackets]&&NullQ[forwardPrimerVolume]
	];

	(* If forwardPrimerVolumeMismatchQ is True and we are throwing messages, then throw an error message *)
	forwardPrimerVolumeMismatchOptions=If[forwardPrimerVolumeMismatchQ&&messages,
		(
			Message[Error::ForwardPrimerVolumeMismatch];
			{ForwardPrimerVolume}
		),
		{}
	];

	(* If we are gathering tests, create a test for ForwardPrimerVolume mismatch *)
	forwardPrimerVolumeMismatchTest=If[gatherTests,
		Test["The specified forward primer volumes don't have conflicts with the input forward primers:",
			forwardPrimerVolumeMismatchQ,
			False
		],
		Nothing
	];

	(*--Check that ReversePrimer options aren't in conflict--*)

	(* Check if ReversePrimerVolume conflicts with reverse primer inputs *)
	reversePrimerVolumeMismatchQ=Or[
		NullQ[allPrimerSamplePackets]&&MatchQ[reversePrimerVolume,Except[ListableP[Automatic|Null]]],
		!NullQ[allPrimerSamplePackets]&&NullQ[reversePrimerVolume]
	];

	(* If reversePrimerVolumeMismatchQ is True and we are throwing messages, then throw an error message *)
	reversePrimerVolumeMismatchOptions=If[reversePrimerVolumeMismatchQ&&messages,
		(
			Message[Error::ReversePrimerVolumeMismatch];
			{ReversePrimerVolume}
		),
		{}
	];

	(* If we are gathering tests, create a test for ReversePrimerVolume mismatch *)
	reversePrimerVolumeMismatchTest=If[gatherTests,
		Test["The specified reverse primer volumes don't have conflicts with the input reverse primers:",
			reversePrimerVolumeMismatchQ,
			False
		],
		Nothing
	];

	(*--Check that Buffer options aren't in conflict--*)

	(* Check if either of Buffer and BufferVolume is Null, the other is also Null *)
	validBufferVolumeQ=Or[
		NullQ[buffer]&&MatchQ[bufferVolume,{(Null|Automatic)..}],
		MatchQ[buffer,ObjectP[{Model[Sample],Object[Sample]}]]&&!NullQ[bufferVolume]
	];

	(* If validBufferVolumeQ is False and we are throwing messages, then throw an error message *)
	invalidBufferVolumeOptions=If[!validBufferVolumeQ&&messages,
		(
			Message[Error::PCRBufferVolumeMismatch];
			{Buffer,BufferVolume}
		),
		{}
	];

	(* If we are gathering tests, create a test for BufferVolume mismatch *)
	validBufferVolumeTest=If[gatherTests,
		Test["If either of Buffer and BufferVolume is Null, the other is also Null:",
			validBufferVolumeQ,
			True
		],
		Nothing
	];

	(*--Check that MasterMix options aren't in conflict--*)

	(*-MasterMixVolume-*)

	(* Check if either of MasterMix and MasterMixVolume is Null, the other is also Null *)
	validMasterMixVolumeQ=Or[
		NullQ[masterMix]&&MatchQ[masterMixVolume,Null|Automatic],
		MatchQ[masterMix,ObjectP[{Model[Sample],Object[Sample]}]]&&!NullQ[masterMixVolume]
	];

	(* If validMasterMixVolumeQ is False and we are throwing messages, then throw an error message *)
	invalidMasterMixVolumeOptions=If[!validMasterMixVolumeQ&&messages,
		(
			Message[Error::MasterMixVolumeMismatch];
			{MasterMix,MasterMixVolume}
		),
		{}
	];

	(* If we are gathering tests, create a test for MasterMixVolume mismatch *)
	validMasterMixVolumeTest=If[gatherTests,
		Test["If either of MasterMix and MasterMixVolume is Null, the other is also Null:",
			validMasterMixVolumeQ,
			True
		],
		Nothing
	];

	(*-MasterMixStorageCondition-*)

	(* Check if MasterMix is Null, MasterMixStorageCondition is also Null *)
	validMasterMixStorageConditionQ=If[NullQ[masterMix],
		NullQ[masterMixStorageCondition],
		True
	];

	(* If validMasterMixStorageConditionQ is False and we are throwing messages, then throw an error message *)
	invalidMasterMixStorageConditionOptions=If[!validMasterMixStorageConditionQ&&messages,
		(
			Message[Error::MasterMixStorageConditionMismatch];
			{MasterMix,MasterMixStorageCondition}
		),
		{}
	];

	(* If we are gathering tests, create a test for MasterMixStorageCondition mismatch *)
	validMasterMixStorageConditionTest=If[gatherTests,
		Test["If MasterMix is Null, MasterMixStorageCondition is also Null:",
			validMasterMixStorageConditionQ,
			True
		],
		Nothing
	];


	(*---Resolve independent options---*)

	(* Resolve Preparation *)
	preparationResult=Check[
		{allowedPreparation,preparationTest}=If[gatherTests,
			resolveExperimentPCRMethod[myListedSamples,myListedPrimerPairSamples,ReplaceRule[pcrOptions,{Cache->inheritedCache,Simulation->updatedSimulation,Output->{Result,Tests}}]],
			{resolveExperimentPCRMethod[myListedSamples,myListedPrimerPairSamples,ReplaceRule[pcrOptions,{Cache->inheritedCache,Simulation->updatedSimulation,Output->Result}]],{}}
		],
		$Failed
	];

	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple options so that OptimizeUnitOperations can perform primitive grouping *)
	resolvedPreparation=If[MatchQ[allowedPreparation,_List],
		First[allowedPreparation],
		allowedPreparation
	];

	(* Resolve the work cell that we're going to operator on. *)
	allowedWorkCells=resolveExperimentPCRWorkCell[myListedSamples,myListedPrimerPairSamples,ReplaceRule[pcrOptions,{Cache->inheritedCache,Simulation->updatedSimulation,Output->{Result,Tests}}]];

	resolvedWorkCell=Which[
		MatchQ[Lookup[myOptions, WorkCell], Except[Null|Automatic]],
			Lookup[myOptions, WorkCell],
		MatchQ[resolvedPreparation, Manual],
			Null,
		Length[allowedWorkCells]>0,
			First[allowedWorkCells],
		True,
			bioSTAR
	];

	(*--MasterMix options--*)

	(* Resolve MasterMixLabel *)
	resolvedMasterMixLabel=If[MatchQ[masterMixLabel,Except[Automatic]],
		masterMixLabel,
		CreateUniqueLabel["PCR master mix sample"]
	];

	(* Resolve MasterMixContainerLabel *)
	resolvedMasterMixContainerLabel=If[MatchQ[masterMixContainerLabel,Except[Automatic]],
		masterMixContainerLabel,
		CreateUniqueLabel["PCR master mix container"]
	];

	(* Resolve MasterMixVolume *)
	resolvedMasterMixVolume=Switch[{masterMixVolume,masterMix},

		(* In the case where MasterMixVolume is specified, we accept the value (we already did the master mix mismatch check above) *)
		{Except[Automatic],_},
			masterMixVolume,

		(* In the case where MasterMixVolume is left as automatic, we resolve MasterMixVolume based on whether MasterMix is specified or Null *)
		{Automatic,ObjectP[{Model[Sample],Object[Sample]}]},
			reactionVolume/2,
		{Automatic,Null},
			Null
	];

	(* Update roundedPCROptions *)
	updatedRoundedPCROptions=Association[ReplaceRule[Normal[roundedPCROptions],MasterMixVolume->resolvedMasterMixVolume]];

	(*--Buffer options--*)

	(* Resolve BufferLabel *)
	resolvedBufferLabel=If[MatchQ[bufferLabel,Except[Automatic]],
		bufferLabel,
		CreateUniqueLabel["PCR buffer sample"]
	];

	(* Resolve BufferContainerLabel *)
	resolvedBufferContainerLabel=If[MatchQ[bufferContainerLabel,Except[Automatic]],
		bufferContainerLabel,
		CreateUniqueLabel["PCR buffer container"]
	];

	(*--AssayPlate options--*)

	(* Resolve AssayPlate *)
	(* Note Full-Skirted PCR and Semi-Skirted PCR plate require different adaptor for ATC *)
	(* Currently, the set-up adaptor is for Full-Skirted PCR plate *)
	(* However, the semi-skirted PCR plate can fit in to the full-skirted PCR plate adaptor if placed carefully *)
	(* So we allow to use the semi-skirted PCR plate manually. *)
	(* 96-well Optical Full-Skirted PCR Plate does not work robotic plate sealer but we allow to use it manually. *)
	resolvedAssayPlate=Which[
		MatchQ[assayPlate,ObjectP[]],
			assayPlate,
		And[
			preparedPlate,
			(*"96-well Optical Full-Skirted PCR Plate", "96-well Optical Semi-Skirted PCR Plate", "96-well PCR Plate"*)
			MatchQ[Lookup[sampleContainerPackets,Model],
				{LinkP[{Model[Container,Plate,"id:9RdZXv1laYVK"],Model[Container,Plate,"id:Z1lqpMz1EnVL"],Model[Container,Plate,"id:01G6nvkKrrYm"]}]..}],
			SameQ@@Lookup[sampleContainerPackets,Object],
			MatchQ[resolvedPreparation,Manual](* Optional Full/Semi skirted PCR plate does not work with robotic version of plate sealer *)
		],
		(* Directly use the sample container. Note that if the sample container is simulated, we should go with its model instead *)
				If[DatabaseMemberQ[First[Lookup[sampleContainerPackets,Object]]],
					First[Lookup[sampleContainerPackets,Object]],
					Download[First[Lookup[sampleContainerPackets,Model]],Object]
				],
		MatchQ[resolvedPreparation,Manual],
			Model[Container, Plate, "id:9RdZXv1laYVK"],(*96-well Optical Full-Skirted PCR Plate"*)
		True,
			Model[Container, Plate, "id:01G6nvkKrrYm"](*"96-well PCR Plate"*)
	];

	(* AssayPlateLabel *)
	resolvedAssayPlateLabel=If[MatchQ[assayPlateLabel,Except[Automatic]],
		assayPlateLabel,
		CreateUniqueLabel["PCR assay plate"]
	];


	(*---Resolve master switches---*)

	(*--Activation master switch options--*)

	(* Activation resolves to True if any of the Activation options are specified, or False otherwise *)
	resolvedActivation=Which[
		BooleanQ[activation],
			activation,
		MatchQ[activation,Automatic]&&(TimeQ[activationTime]||TemperatureQ[activationTemperature]||TemperatureRampRateQ[activationRampRate]),
			True,
		True,
			False
	];

	(* ActivationTime resolves to 1 minute if resolvedActivation is True, or Null otherwise *)
	resolvedActivationTime=Which[
		MatchQ[activationTime,Except[Automatic]],
			activationTime,
		MatchQ[activationTime,Automatic]&&resolvedActivation,
			60 Second,
		True,
			Null
	];

	(* ActivationTemperature resolves to 95 degrees Celsius if resolvedActivation is True, or Null otherwise *)
	resolvedActivationTemperature=Which[
		MatchQ[activationTemperature,Except[Automatic]],
			activationTemperature,
		MatchQ[activationTemperature,Automatic]&&resolvedActivation,
			95 Celsius,
		True,
			Null
	];

	(* ActivationRampRate resolves to 3.5 degrees Celsius per second if resolvedActivation is True, or Null otherwise *)
	resolvedActivationRampRate=Which[
		MatchQ[activationRampRate,Except[Automatic]],
			activationRampRate,
		MatchQ[activationRampRate,Automatic]&&resolvedActivation,
			3.5 (Celsius/Second),
		True,
			Null
	];

	(* Check that when resolvedActivation is True, all the Activation options are specified, or when resolvedActivation is False, all the Activation options are Null *)
	validActivationQ=Or[
		resolvedActivation&&(TimeQ[resolvedActivationTime]&&TemperatureQ[resolvedActivationTemperature]&&TemperatureRampRateQ[resolvedActivationRampRate]),
		!resolvedActivation&&(NullQ[resolvedActivationTime]&&NullQ[resolvedActivationTemperature]&&NullQ[resolvedActivationRampRate])
	];

	(* If validActivationQ is False and we are throwing messages, then throw an error message *)
	activationMismatchOptions=If[!validActivationQ&&messages,
		(
			Message[Error::ActivationMismatch];
			{Activation,ActivationTime,ActivationTemperature,ActivationRampRate}
		),
		{}
	];

	(* If we are gathering tests, create a test for Activation mismatch *)
	activationMismatchTest=If[gatherTests,
		Test["If Activation is True, ActivationTime, ActivationTemperature, and ActivationRampRate are specified; if Activation is False, ActivationTime, ActivationTemperature, and ActivationRampRate are Null:",
			validActivationQ,
			True
		],
		Nothing
	];

	(*--PrimerAnnealing master switch options--*)

	(* PrimerAnnealing resolves to True if any of the PrimerAnnealing options are specified, or False otherwise *)
	resolvedPrimerAnnealing=Which[
		BooleanQ[primerAnnealing],primerAnnealing,
		MatchQ[primerAnnealing,Automatic]&&(TimeQ[primerAnnealingTime]||TemperatureQ[primerAnnealingTemperature]||TemperatureRampRateQ[primerAnnealingRampRate]),True,
		True,False
	];

	(* PrimerAnnealingTime resolves to 30 seconds if resolvedPrimerAnnealing is True, or Null otherwise *)
	resolvedPrimerAnnealingTime=Which[
		MatchQ[primerAnnealingTime,Except[Automatic]],primerAnnealingTime,
		MatchQ[primerAnnealingTime,Automatic]&&resolvedPrimerAnnealing,30 Second,
		True,Null
	];

	(* PrimerAnnealingTemperature resolves to 60 degrees Celsius if resolvedPrimerAnnealing is True, or Null otherwise *)
	resolvedPrimerAnnealingTemperature=Which[
		MatchQ[primerAnnealingTemperature,Except[Automatic]],primerAnnealingTemperature,
		MatchQ[primerAnnealingTemperature,Automatic]&&resolvedPrimerAnnealing,60 Celsius,
		True,Null
	];

	(* PrimerAnnealingRampRate resolves to 3.5 degrees Celsius per second if resolvedPrimerAnnealing is True, or Null otherwise *)
	resolvedPrimerAnnealingRampRate=Which[
		MatchQ[primerAnnealingRampRate,Except[Automatic]],primerAnnealingRampRate,
		MatchQ[primerAnnealingRampRate,Automatic]&&resolvedPrimerAnnealing,3.5 (Celsius/Second),
		True,Null
	];

	(* Check that when resolvedPrimerAnnealing is True, all the PrimerAnnealing options are specified, or when resolvedPrimerAnnealing is False, all the PrimerAnnealing options are Null *)
	validPrimerAnnealingQ=Or[
		resolvedPrimerAnnealing&&(TimeQ[resolvedPrimerAnnealingTime]&&TemperatureQ[resolvedPrimerAnnealingTemperature]&&TemperatureRampRateQ[resolvedPrimerAnnealingRampRate]),
		!resolvedPrimerAnnealing&&(NullQ[resolvedPrimerAnnealingTime]&&NullQ[resolvedPrimerAnnealingTemperature]&&NullQ[resolvedPrimerAnnealingRampRate])
	];

	(* If validPrimerAnnealingQ is False and we are throwing messages, then throw an error message *)
	primerAnnealingMismatchOptions=If[!validPrimerAnnealingQ&&messages,
		(
			Message[Error::PrimerAnnealingMismatch];
			{PrimerAnnealing,PrimerAnnealingTime,PrimerAnnealingTemperature,PrimerAnnealingRampRate}
		),
		{}
	];

	(* If we are gathering tests, create a test for PrimerAnnealing mismatch *)
	primerAnnealingMismatchTest=If[gatherTests,
		Test["If PrimerAnnealing is True, PrimerAnnealingTime, PrimerAnnealingTemperature, and PrimerAnnealingRampRate are specified; if PrimerAnnealing is False, PrimerAnnealingTime, PrimerAnnealingTemperature, and PrimerAnnealingRampRate are Null:",
			validPrimerAnnealingQ,
			True
		],
		Nothing
	];

	(*--FinalExtension master switch options--*)

	(* FinalExtension resolves to True if any of the PrimerAnnealing options are specified, or False otherwise *)
	resolvedFinalExtension=Which[
		BooleanQ[finalExtension],finalExtension,
		MatchQ[finalExtension,Automatic]&&(TimeQ[finalExtensionTime]||TemperatureQ[finalExtensionTemperature]||TemperatureRampRateQ[finalExtensionRampRate]),True,
		True,False
	];

	(* FinalExtensionTime resolves to 10 minutes if resolvedFinalExtension is True, or Null otherwise *)
	resolvedFinalExtensionTime=Which[
		MatchQ[finalExtensionTime,Except[Automatic]],finalExtensionTime,
		MatchQ[finalExtensionTime,Automatic]&&resolvedFinalExtension,10 Minute,
		True,Null
	];

	(* FinalExtensionTemperature resolves to extensionTemperature if resolvedFinalExtension is True, or Null otherwise *)
	resolvedFinalExtensionTemperature=Which[
		MatchQ[finalExtensionTemperature,Except[Automatic]],finalExtensionTemperature,
		MatchQ[finalExtensionTemperature,Automatic]&&resolvedFinalExtension,extensionTemperature,
		True,Null
	];

	(* FinalExtensionRampRate resolves to 3.5 degrees Celsius per second if resolvedFinalExtension is True, or Null otherwise *)
	resolvedFinalExtensionRampRate=Which[
		MatchQ[finalExtensionRampRate,Except[Automatic]],finalExtensionRampRate,
		MatchQ[finalExtensionRampRate,Automatic]&&resolvedFinalExtension,3.5 (Celsius/Second),
		True,Null
	];

	(* Check that when resolvedPrimerAnnealing is True, all the PrimerAnnealing options are specified, or when resolvedPrimerAnnealing is False, all the PrimerAnnealing options are Null *)
	validFinalExtensionQ=Or[
		resolvedFinalExtension&&(TimeQ[resolvedFinalExtensionTime]&&TemperatureQ[resolvedFinalExtensionTemperature]&&TemperatureRampRateQ[resolvedFinalExtensionRampRate]),
		!resolvedFinalExtension&&(NullQ[resolvedFinalExtensionTime]&&NullQ[resolvedFinalExtensionTemperature]&&NullQ[resolvedFinalExtensionRampRate])
	];

	(* If validPrimerAnnealingQ is False and we are throwing messages, then throw an error message *)
	finalExtensionMismatchOptions=If[!validFinalExtensionQ&&messages,
		(
			Message[Error::FinalExtensionMismatch];
			{FinalExtension,FinalExtensionTime,FinalExtensionTemperature,FinalExtensionRampRate}
		),
		{}
	];

	(* If we are gathering tests, create a test for PrimerAnnealing mismatch *)
	finalExtensionMismatchTest=If[gatherTests,
		Test["If FinalExtension is True, FinalExtensionTime, FinalExtensionTemperature, and FinalExtensionRampRate are specified; if FinalExtension is False, FinalExtensionTime, FinalExtensionTemperature, and FinalExtensionRampRate are Null:",
			validFinalExtensionQ,
			True
		],
		Nothing
	];


	(*---Resolve MapThread options---*)

	(* Make a lookup of any new labels that we create for samples/containers since we may re-use them *)
	objectToNewResolvedLabelLookup={};

	(* Convert our options into a MapThread friendly version *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentPCR,updatedRoundedPCROptions];

	(* MapThread over each of our samples *)
	{
		forwardPrimerStorageConditionErrors,
		reversePrimerStorageConditionErrors,
		totalVolumeTooLargeErrors,
		resolvedForwardPrimerVolume,
		resolvedForwardPrimerStorageCondition,
		resolvedReversePrimerVolume,
		resolvedReversePrimerStorageCondition,
		resolvedBufferVolume,
		resolvedSampleLabel,
		resolvedSampleContainerLabel,
		resolvedForwardPrimerLabel,
		resolvedForwardPrimerContainerLabel,
		resolvedReversePrimerLabel,
		resolvedReversePrimerContainerLabel,
		resolvedSampleOutLabel
	}=Transpose[MapThread[
		Function[{sample,sampleContainer,primerPairSample,primerPairSampleContainer,myMapThreadOptions, mapThreadSampleVolume},
			Module[
				{
					forwardPrimerStorageConditionError,reversePrimerStorageConditionError,totalVolumeTooLargeError,
					specifiedForwardPrimerVolume,specifiedForwardPrimerStorageCondition,specifiedReversePrimerVolume,specifiedReversePrimerStorageCondition,
					specifiedBufferVolume,mapThreadMasterMixVolume,mapThreadReactionVolume,
					specifiedSampleLabel,specifiedSampleContainerLabel,specifiedPrimerPairLabel,specifiedPrimerPairContainerLabel,specifiedSampleOutLabel,
					forwardPrimerSample,forwardPrimerSampleContainer,reversePrimerSample,reversePrimerSampleContainer,
					specifiedForwardPrimerLabel,specifiedForwardPrimerContainerLabel,specifiedReversePrimerLabel,specifiedReversePrimerContainerLabel,
					finalForwardPrimerVolume,finalForwardPrimerStorageCondition,finalReversePrimerVolume,finalReversePrimerStorageCondition,finalBufferVolume,
					sampleLabel,sampleContainerLabel,forwardPrimerLabel,forwardPrimerContainerLabel,reversePrimerLabel,reversePrimerContainerLabel,sampleOutLabel
				},

				(* Initialize the error-tracking variables *)
				{forwardPrimerStorageConditionError,reversePrimerStorageConditionError,totalVolumeTooLargeError}=Table[False,3];

				(* Pull out the specified options *)
				{
					specifiedForwardPrimerVolume,specifiedForwardPrimerStorageCondition,specifiedReversePrimerVolume,specifiedReversePrimerStorageCondition,
					specifiedBufferVolume,mapThreadMasterMixVolume,mapThreadReactionVolume, specifiedSampleLabel,specifiedSampleContainerLabel,
					specifiedPrimerPairLabel,specifiedPrimerPairContainerLabel,specifiedSampleOutLabel
				}=Lookup[
					myMapThreadOptions,
					{
						ForwardPrimerVolume,ForwardPrimerStorageCondition,ReversePrimerVolume,ReversePrimerStorageCondition,BufferVolume,MasterMixVolume,ReactionVolume,
						SampleLabel,SampleContainerLabel,PrimerPairLabel,PrimerPairContainerLabel,SampleOutLabel
					}
				];

				(* Split up the forward/reverse primers *)
				forwardPrimerSample=primerPairSample[[All,1]];
				forwardPrimerSampleContainer=primerPairSampleContainer[[All,1]];
				reversePrimerSample=primerPairSample[[All,2]];
				reversePrimerSampleContainer=primerPairSampleContainer[[All,2]];

				(* Split up the forward/reverse primer labels *)
				specifiedForwardPrimerLabel=If[MatchQ[specifiedPrimerPairLabel,Except[Automatic]],specifiedPrimerPairLabel[[All,1]],specifiedPrimerPairLabel];
				specifiedForwardPrimerContainerLabel=If[MatchQ[specifiedPrimerPairContainerLabel,Except[Automatic]],specifiedPrimerPairContainerLabel[[All,1]],specifiedPrimerPairContainerLabel];
				specifiedReversePrimerLabel=If[MatchQ[specifiedPrimerPairLabel,Except[Automatic]],specifiedPrimerPairLabel[[All,2]],specifiedPrimerPairLabel];
				specifiedReversePrimerContainerLabel=If[MatchQ[specifiedPrimerPairContainerLabel,Except[Automatic]],specifiedPrimerPairContainerLabel[[All,2]],specifiedPrimerPairContainerLabel];

				(* Resolve ForwardPrimerVolume *)
				finalForwardPrimerVolume=Which[
					(* If the volume is specified as Null, accept it (already threw the error ForwardPrimerVolumeMismatch) *)
					NullQ[specifiedForwardPrimerVolume],specifiedForwardPrimerVolume,
					(* If the volume is specified correctly in the index-matched form, accept the value *)
					MatchQ[specifiedForwardPrimerVolume,Except[Automatic]]&&SameLengthQ[specifiedForwardPrimerVolume,primerPairSample],specifiedForwardPrimerVolume,
					(* If the volume is specified as a singleton and got incorrectly expanded, expand the value correctly *)
					MatchQ[specifiedForwardPrimerVolume,Except[Automatic]]&&!SameLengthQ[specifiedForwardPrimerVolume,primerPairSample]&&Length[DeleteDuplicates[specifiedForwardPrimerVolume]]==1,Table[First[specifiedForwardPrimerVolume],Length[primerPairSample]],
					(* If the volume is left as Automatic, resolve to 1 microliter *)
					MatchQ[specifiedForwardPrimerVolume,Automatic]&&!NullQ[primerPairSample],ConstantArray[1 Microliter,Length[primerPairSample]],
					True,Null
				];

				(* Check ForwardPrimerStorageCondition *)
				finalForwardPrimerStorageCondition=Which[
					(* If the storage condition is Null, accept it *)
					NullQ[specifiedForwardPrimerStorageCondition],specifiedForwardPrimerStorageCondition,
					(* If the storage condition is specified and ForwardPrimer is Null, flip the error switch *)
					!NullQ[specifiedForwardPrimerStorageCondition]&&NullQ[primerPairSample],forwardPrimerStorageConditionError=True;specifiedForwardPrimerStorageCondition,
					(* If the storage condition is specified correctly in the index-matched form, accept the value *)
					!NullQ[specifiedForwardPrimerStorageCondition]&&SameLengthQ[specifiedForwardPrimerStorageCondition,primerPairSample],specifiedForwardPrimerStorageCondition,
					(* If the storage condition is specified as a singleton and got incorrectly expanded, expand the value correctly *)
					!NullQ[specifiedForwardPrimerStorageCondition]&&!SameLengthQ[specifiedForwardPrimerStorageCondition,primerPairSample]&&Length[DeleteDuplicates[specifiedForwardPrimerStorageCondition]]==1,Table[First[specifiedForwardPrimerStorageCondition],Length[primerPairSample]],
					True,Null
				];

				(* Resolve ReversePrimerVolume *)
				finalReversePrimerVolume=Which[
					(* If the volume is specified as Null, accept it (already threw the error ReversePrimerVolumeMismatch) *)
					NullQ[specifiedReversePrimerVolume],specifiedReversePrimerVolume,
					(* If the volume is specified correctly in the index-matched form, accept the value *)
					MatchQ[specifiedReversePrimerVolume,Except[Automatic]]&&SameLengthQ[specifiedReversePrimerVolume,primerPairSample],specifiedReversePrimerVolume,
					(* If the volume is specified as a singleton and got incorrectly expanded, expand the value correctly *)
					MatchQ[specifiedReversePrimerVolume,Except[Automatic]]&&!SameLengthQ[specifiedReversePrimerVolume,primerPairSample]&&Length[DeleteDuplicates[specifiedReversePrimerVolume]]==1,Table[First[specifiedReversePrimerVolume],Length[primerPairSample]],
					(* If the volume is left as Automatic, resolve to finalForwardPrimerVolume *)
					MatchQ[specifiedReversePrimerVolume,Automatic]&&!NullQ[finalForwardPrimerVolume],finalForwardPrimerVolume,
					True,Null
				];

				(* Check ReversePrimerStorageCondition *)
				finalReversePrimerStorageCondition=Which[
					(* If the storage condition is Null, accept it *)
					NullQ[specifiedReversePrimerStorageCondition],specifiedReversePrimerStorageCondition,
					(* If the storage condition is specified and ReversePrimer is Null, flip the error switch *)
					!NullQ[specifiedReversePrimerStorageCondition]&&NullQ[primerPairSample],reversePrimerStorageConditionError=True;specifiedReversePrimerStorageCondition,
					(* If the storage condition is specified correctly in the index-matched form, accept the value *)
					!NullQ[specifiedReversePrimerStorageCondition]&&SameLengthQ[specifiedReversePrimerStorageCondition,primerPairSample],specifiedReversePrimerStorageCondition,
					(* If the storage condition is specified as a singleton and got incorrectly expanded, expand the value correctly *)
					!NullQ[specifiedReversePrimerStorageCondition]&&!SameLengthQ[specifiedReversePrimerStorageCondition,primerPairSample]&&Length[DeleteDuplicates[specifiedReversePrimerStorageCondition]]==1,Table[First[specifiedReversePrimerStorageCondition],Length[primerPairSample]],
					True,Null
				];

				(* Resolve BufferVolume *)
				(* Note bufferVolume is index-matching to sample,but unlike finalForwardPrimerVolume,for each sample *)
				(* there is only one value for buffer volume,, we need to extend it later. *)
				(* now resolvedBufferVolume has the same format as resolvedForwardPrimerVolume *)
				finalBufferVolume=If[NullQ[specifiedBufferVolume],
					Null,
					Which[
					(* If the volume is specified correctly in the index-matched form, accept the value *)
					MatchQ[specifiedBufferVolume,Except[Automatic]]&&!NullQ[buffer]&&SameLengthQ[specifiedBufferVolume,primerPairSample],specifiedBufferVolume,
					(* If the volume is specified as a singleton and got incorrectly expanded, expand the value correctly *)
					MatchQ[specifiedBufferVolume,Except[Automatic]]&&!NullQ[buffer]&&!SameLengthQ[specifiedBufferVolume,primerPairSample]&&Length[DeleteDuplicates[specifiedBufferVolume]]==1,Table[First[specifiedBufferVolume],Length[primerPairSample]],
					(* If the volume is left as Automatic, resolve to ReactionVolume-(SampleVolume+MasterMixVolume+ForwardPrimerVolume+ReversePrimerVolume) if Buffer is not set to Null *)
					And[
						MatchQ[specifiedBufferVolume,Automatic],
						!NullQ[buffer],
						Total[Flatten[{mapThreadMasterMixVolume,mapThreadSampleVolume,Max[finalForwardPrimerVolume],Max[finalReversePrimerVolume]}/.Null->0 Microliter]]<mapThreadReactionVolume
						],
						MapThread[(mapThreadReactionVolume-Total[Flatten[{mapThreadMasterMixVolume,mapThreadSampleVolume,#1,#2}/.Null->0 Microliter]])&,
								{Flatten[{finalForwardPrimerVolume}],Flatten[{finalReversePrimerVolume}]}],
					True,
						Null
					]
				];

				(* If the total volume exceeds ReactionVolume, flip the error switch *)
				totalVolumeTooLargeError=If[Max[(finalForwardPrimerVolume+finalReversePrimerVolume+finalBufferVolume)/.Null->0 Microliter]>(mapThreadReactionVolume-mapThreadMasterMixVolume-mapThreadSampleVolume),True,False];

				(*--Resolve the sample and container labels--*)

				(* Resolve SampleLabel *)
				sampleLabel=Which[
					MatchQ[specifiedSampleLabel,Except[Automatic]],
						specifiedSampleLabel,
					MatchQ[simulation,SimulationP]&&MatchQ[LookupObjectLabel[simulation,sample],_String],
						LookupObjectLabel[simulation,sample],
					KeyExistsQ[objectToNewResolvedLabelLookup,sample],
						Lookup[objectToNewResolvedLabelLookup,sample],
					True,
						Module[{newLabel},
							newLabel=CreateUniqueLabel["PCR sample"];
							AppendTo[objectToNewResolvedLabelLookup,sample->newLabel];
							newLabel
					]
				];

				(* Resolve SampleContainerLabel *)
				sampleContainerLabel=Which[
					MatchQ[specifiedSampleContainerLabel,Except[Automatic]],
						specifiedSampleContainerLabel,
					MatchQ[simulation,SimulationP]&&MatchQ[LookupObjectLabel[simulation,sampleContainer],_String],
						LookupObjectLabel[simulation,sampleContainer],
					KeyExistsQ[objectToNewResolvedLabelLookup,sampleContainer],
						Lookup[objectToNewResolvedLabelLookup,sampleContainer],
					True,
						Module[{newLabel},
							newLabel=CreateUniqueLabel["PCR sample container"];
							AppendTo[objectToNewResolvedLabelLookup,sampleContainer->newLabel];
							newLabel
					]
				];

				(* Resolve ForwardPrimerLabel *)
				(* If previous sample has the same forwardPrimer and we have labeled it, skip labeling here *)
				forwardPrimerLabel=Which[
					MatchQ[specifiedForwardPrimerLabel,Except[Automatic]],
						specifiedForwardPrimerLabel,
					MatchQ[simulation,SimulationP]&&AllTrue[forwardPrimerSample,MatchQ[LookupObjectLabel[simulation,#],_String]&],
						LookupObjectLabel[simulation,#]&/@forwardPrimerSample,
					AllTrue[forwardPrimerSample,KeyExistsQ[objectToNewResolvedLabelLookup,#]&],
						Lookup[objectToNewResolvedLabelLookup,#]&/@forwardPrimerSample,
					True,
						Map[
							If[MemberQ[Keys@objectToNewResolvedLabelLookup,#],
								Lookup[objectToNewResolvedLabelLookup,#],
								Module[{newLabel},
									newLabel=CreateUniqueLabel["PCR forward primer sample"];
									AppendTo[objectToNewResolvedLabelLookup,#->newLabel];
									newLabel
								]
							]&,
							forwardPrimerSample
						]
				];

				(* Resolve ForwardPrimerContainerLabel *)
				forwardPrimerContainerLabel=Which[
					MatchQ[specifiedForwardPrimerContainerLabel,Except[Automatic]],
						specifiedForwardPrimerContainerLabel,
					MatchQ[simulation,SimulationP]&&AllTrue[forwardPrimerSampleContainer,MatchQ[LookupObjectLabel[simulation,#],_String]&],
						LookupObjectLabel[simulation,#]&/@forwardPrimerSampleContainer,
					AllTrue[forwardPrimerSampleContainer,KeyExistsQ[objectToNewResolvedLabelLookup,#]&],
						Lookup[objectToNewResolvedLabelLookup,#]&/@forwardPrimerSampleContainer,
					True,
						Map[
							If[MemberQ[Keys@objectToNewResolvedLabelLookup,#],
								Lookup[objectToNewResolvedLabelLookup,#],
								Module[{newLabel},
									newLabel=CreateUniqueLabel["PCR forward primer sample container"];
									AppendTo[objectToNewResolvedLabelLookup,#->newLabel];
									newLabel
								]
							]&,
							forwardPrimerSampleContainer
						]
				];

				(* Resolve ReversePrimerLabel *)
				(* If previous sample has the same reversePrimer and we have labeled it, skip labeling here *)
				reversePrimerLabel=Which[
					MatchQ[specifiedReversePrimerLabel,Except[Automatic]],
						specifiedReversePrimerLabel,
					MatchQ[simulation,SimulationP]&&AllTrue[reversePrimerSample,MatchQ[LookupObjectLabel[simulation,#],_String]&],
						LookupObjectLabel[simulation,#]&/@reversePrimerSample,
					AllTrue[reversePrimerSample,KeyExistsQ[objectToNewResolvedLabelLookup,#]&],
						Lookup[objectToNewResolvedLabelLookup,#]&/@reversePrimerSample,
					True,
						Map[
							If[MemberQ[Keys@objectToNewResolvedLabelLookup,#],
								Lookup[objectToNewResolvedLabelLookup,#],
								Module[{newLabel},
									newLabel=CreateUniqueLabel["PCR reverse primer sample"];
									AppendTo[objectToNewResolvedLabelLookup,#->newLabel];
									newLabel
								]
							]&,
							reversePrimerSample
						]
				];

				(* Resolve ReversePrimerContainerLabel *)
				reversePrimerContainerLabel=Which[
					MatchQ[specifiedReversePrimerContainerLabel,Except[Automatic]],
						specifiedReversePrimerContainerLabel,
					MatchQ[simulation,SimulationP]&&AllTrue[reversePrimerSampleContainer,MatchQ[LookupObjectLabel[simulation,#],_String]&],
						LookupObjectLabel[simulation,#]&/@reversePrimerSampleContainer,
					AllTrue[reversePrimerSampleContainer,KeyExistsQ[objectToNewResolvedLabelLookup,#]&],
						Lookup[objectToNewResolvedLabelLookup,#]&/@reversePrimerSampleContainer,
					True,
						Map[
							If[MemberQ[Keys@objectToNewResolvedLabelLookup,#],
								Lookup[objectToNewResolvedLabelLookup,#],
								Module[{newLabel},
									newLabel=CreateUniqueLabel["PCR reverse primer sample container"];
									AppendTo[objectToNewResolvedLabelLookup,#->newLabel];
									newLabel
								]
							]&,
							reversePrimerSampleContainer
						]
				];


				(* Resolve SampleOutLabel *)
				(* If the same sample in has different pairs of primers, expand the sampleout Label since after PCR, the contents are different *)
				sampleOutLabel=Which[
					MatchQ[specifiedSampleOutLabel,Except[Automatic]],
						specifiedSampleOutLabel,
					True,
						If[Length[primerPairSample]==1,
							CreateUniqueLabel["PCR sample out"],
							CreateUniqueLabel["PCR sample out"]&/@Range[Length[primerPairSample]]
						]
				];

				(* Return the error-tracking variables and resolved values *)
				{forwardPrimerStorageConditionError,reversePrimerStorageConditionError,totalVolumeTooLargeError,
					finalForwardPrimerVolume,finalForwardPrimerStorageCondition,finalReversePrimerVolume,finalReversePrimerStorageCondition,finalBufferVolume,
					sampleLabel,sampleContainerLabel,forwardPrimerLabel,forwardPrimerContainerLabel,reversePrimerLabel,reversePrimerContainerLabel,sampleOutLabel}
			]
		],
		{simulatedSamples,sampleContainers,expandedListedPrimerPairSamples,expandedListedPrimerPairSampleContainers,mapThreadFriendlyOptions, sampleVolume}
	]];


	(*---Unresolvable option checks---*)

	(*--ForwardPrimerStorageCondition--*)

	(* If there are forwardPrimerStorageConditionErrors and we are throwing messages, then throw an error message *)
	invalidForwardPrimerStorageConditionOptions=If[MemberQ[forwardPrimerStorageConditionErrors,True]&&messages,
		(
			Message[Error::ForwardPrimerStorageConditionMismatch];
			{ForwardPrimerStorageCondition}
		),
		{}
	];

	(* If we are gathering tests, create a test for ForwardPrimerStorageCondition mismatch *)
	validForwardPrimerStorageConditionTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(* Get the inputs that fail this test *)
			failingSamples=PickList[simulatedSamples,forwardPrimerStorageConditionErrors];

			(* Get the inputs that pass this test *)
			passingSamples=PickList[simulatedSamples,forwardPrimerStorageConditionErrors,False];

			(* Create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->inheritedCache]<>", the ForwardPrimerStorageCondition does not have conflicts with the input forward primers:",False,True],
				Nothing
			];

			(* Create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Cache->inheritedCache]<>", the ForwardPrimerStorageCondition does not have conflicts with the input forward primers:",True,True],
				Nothing
			];

			(* Return the created tests *)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];

	(*--ReversePrimerStorageCondition--*)

	(* If there are reversePrimerStorageConditionErrors and we are throwing messages, then throw an error message *)
	invalidReversePrimerStorageConditionOptions=If[MemberQ[reversePrimerStorageConditionErrors,True]&&messages,
		(
			Message[Error::ReversePrimerStorageConditionMismatch];
			{ReversePrimerStorageCondition}
		),
		{}
	];

	(* If we are gathering tests, create a test for ReversePrimerStorageCondition mismatch *)
	validReversePrimerStorageConditionTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(* Get the inputs that fail this test *)
			failingSamples=PickList[simulatedSamples,reversePrimerStorageConditionErrors];

			(* Get the inputs that pass this test *)
			passingSamples=PickList[simulatedSamples,reversePrimerStorageConditionErrors,False];

			(* Create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->inheritedCache]<>", the ReversePrimerStorageCondition does not have conflicts with the input reverse primers:",False,True],
				Nothing
			];

			(* Create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Cache->inheritedCache]<>", the ReversePrimerStorageCondition does not have conflicts with the input reverse primers:",True,True],
				Nothing
			];

			(* Return the created tests *)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];


	(*--Total volume--*)

	(* If there are totalVolumeTooLargeErrors and we are throwing messages, then throw an error message *)
	totalVolumeOverReactionVolumeOptions=If[MemberQ[totalVolumeTooLargeErrors,True]&&messages,
		(
			Message[Error::TotalVolumeOverReactionVolume,ObjectToString[PickList[simulatedSamples,totalVolumeTooLargeErrors],Cache->inheritedCache]];
			{SampleVolume,MasterMixVolume,ForwardPrimerVolume,ReversePrimerVolume,BufferVolume,ReactionVolume}
		),
		{}
	];

	(* If we are gathering tests, create a test for total volume *)
	totalVolumeTest=If[gatherTests,
		Module[
			{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(* Get the inputs that fail this test *)
			failingSamples=PickList[simulatedSamples,totalVolumeTooLargeErrors];

			(* Get the inputs that pass this test *)
			passingSamples=PickList[simulatedSamples,totalVolumeTooLargeErrors,False];

			(* Create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->inheritedCache]<>", the total volume consisting of SampleVolume, MasterMixVolume, ForwardPrimerVolume, ReversePrimerVolume, and BufferVolume does not exceed ReactionVolume:",False,True],
				Nothing
			];

			(* Create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Cache->inheritedCache]<>", the total volume consisting of SampleVolume, MasterMixVolume, ForwardPrimerVolume, ReversePrimerVolume, and BufferVolume does not exceed ReactionVolume:",True,True],
				Nothing
			];

			(* Return the created tests *)
			{failingSampleTests,passingSampleTests}
		],
		Nothing
	];


	(*---Resolve aliquot options---*)

	(* Resolve RequiredAliquotContainers as Null, since samples must be transferred into the '96-well Full-Skirted PCR Plate' accepted by the instrument *)
	targetContainers=Null;

	(* Resolve aliquot options and make tests *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentPCR,
			myListedSamples,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			Cache->inheritedCache,
			Simulation->updatedSimulation,
			RequiredAliquotAmounts->Null,
			RequiredAliquotContainers->targetContainers,
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentPCR,
				myListedSamples,
				simulatedSamples,
				ReplaceRule[myOptions,resolvedSamplePrepOptions],
				Cache->inheritedCache,
				Simulation->updatedSimulation,
				RequiredAliquotAmounts->Null,
				RequiredAliquotContainers->targetContainers,
				Output->Result],
			{}
		}
	];


	(*---Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument---*)
	{compatibleMaterialsBool,compatibleMaterialsTests}=If[gatherTests,
		CompatibleMaterialsQ[instrument,If[!NullQ[flatPrimerSamples],Join[simulatedSamples,flatPrimerSamples],simulatedSamples],Output->{Result,Tests}, Simulation->updatedSimulation,Cache->inheritedCache],
		{CompatibleMaterialsQ[instrument,If[!NullQ[flatPrimerSamples],Join[simulatedSamples,flatPrimerSamples],simulatedSamples],Messages->messages, Simulation->updatedSimulation,Cache->inheritedCache],{}}
	];

	(* if the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidOption=If[!compatibleMaterialsBool&&messages,
		{Instrument},
		{}
	];


	(*---Resolve Post Processing Options---*)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[ReplaceRule[myOptions, Preparation->resolvedPreparation],Sterile->True];


	(*---Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary---*)
	invalidInputs=DeleteDuplicates[Flatten[{
		discardedInvalidInputs,
		deprecatedInvalidInputs,
		tooManySamplesInvalidInputs,
		preparedPlateInvalidInputs
	}]];
	invalidOptions=DeleteDuplicates[Flatten[{
		invalidNameOptions,
		forwardPrimerVolumeMismatchOptions,
		reversePrimerVolumeMismatchOptions,
		invalidBufferVolumeOptions,
		invalidMasterMixVolumeOptions,
		invalidMasterMixStorageConditionOptions,
		activationMismatchOptions,
		primerAnnealingMismatchOptions,
		finalExtensionMismatchOptions,
		invalidForwardPrimerStorageConditionOptions,
		invalidReversePrimerStorageConditionOptions,
		totalVolumeOverReactionVolumeOptions,
		compatibleMaterialsInvalidOption,

		If[MatchQ[preparationResult, $Failed],
			{Preparation},
			Nothing
		]
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs *)
	If[Length[invalidInputs]>0&&messages,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->inheritedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options *)
	If[Length[invalidOptions]>0&&messages,
		Message[Error::InvalidOption,invalidOptions]
	];


	(*---Return our resolved options and tests---*)

	(* Resolve the Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a subprotocol *)
	resolvedEmail=Which[
		MatchQ[Lookup[myOptions,Email],Automatic]&&NullQ[parentProtocol],True,
		MatchQ[Lookup[myOptions,Email],Automatic]&&MatchQ[parentProtocol,ObjectP[ProtocolTypes[]]],False,
		True,Lookup[myOptions,Email]
	];

	(* Assemble PrimerPairLabel *)
	resolvedPrimerPairLabel=TakeList[Transpose[{Flatten@resolvedForwardPrimerLabel,Flatten@resolvedReversePrimerLabel}],primerPairLengths];

	(* Assemble PrimerPairContainerLabel *)
	resolvedPrimerPairContainerLabel=TakeList[Transpose[{Flatten@resolvedForwardPrimerContainerLabel,Flatten@resolvedReversePrimerContainerLabel}],primerPairLengths];

	(* Gather the resolved options (pre-collapsed; that is happening outside the function) *)
	resolvedOptions=ReplaceRule[Normal[updatedRoundedPCROptions],
		Flatten[{
			SampleLabel->resolvedSampleLabel,
			SampleContainerLabel->resolvedSampleContainerLabel,
			PreparedPlate->preparedPlate,
			SampleVolume->sampleVolume,
			PrimerPairLabel->resolvedPrimerPairLabel,
			PrimerPairContainerLabel->resolvedPrimerPairContainerLabel,
			ForwardPrimerVolume->resolvedForwardPrimerVolume,
			ForwardPrimerStorageCondition->resolvedForwardPrimerStorageCondition,
			ReversePrimerVolume->resolvedReversePrimerVolume,
			ReversePrimerStorageCondition->resolvedReversePrimerStorageCondition,
			Buffer->buffer,
			BufferVolume->resolvedBufferVolume,
			SampleOutLabel->resolvedSampleOutLabel,
			MasterMixLabel->resolvedMasterMixLabel,
			MasterMixContainerLabel->resolvedMasterMixContainerLabel,
			MasterMix->masterMix,
			MasterMixVolume->resolvedMasterMixVolume,
			MasterMixStorageCondition->masterMixStorageCondition,
			BufferLabel->resolvedBufferLabel,
			BufferContainerLabel->resolvedBufferContainerLabel,
			AssayPlate->resolvedAssayPlate,
			AssayPlateLabel->resolvedAssayPlateLabel,
			Activation->resolvedActivation,
			ActivationTime->resolvedActivationTime,
			ActivationTemperature->resolvedActivationTemperature,
			ActivationRampRate->resolvedActivationRampRate,
			PrimerAnnealing->resolvedPrimerAnnealing,
			PrimerAnnealingTime->resolvedPrimerAnnealingTime,
			PrimerAnnealingTemperature->resolvedPrimerAnnealingTemperature,
			PrimerAnnealingRampRate->resolvedPrimerAnnealingRampRate,
			FinalExtension->resolvedFinalExtension,
			FinalExtensionTime->resolvedFinalExtensionTime,
			FinalExtensionTemperature->resolvedFinalExtensionTemperature,
			FinalExtensionRampRate->resolvedFinalExtensionRampRate,
			(* Shared options *)
			Preparation->resolvedPreparation,
			WorkCell->resolvedWorkCell,
			Email->resolvedEmail,
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions
		}]
	];

	(* Gather the tests *)
	allTests=Cases[Flatten[{
		samplePrepTests,
		discardedTest,
		deprecatedTest,
		tooManySamplesTest,
		validPreparedPlateTest,
		precisionTests,
		sampleVolumeTests,
		validNameTest,
		forwardPrimerVolumeMismatchTest,
		reversePrimerVolumeMismatchTest,
		validBufferVolumeTest,
		validMasterMixVolumeTest,
		validMasterMixStorageConditionTest,
		activationMismatchTest,
		primerAnnealingMismatchTest,
		finalExtensionMismatchTest,
		validForwardPrimerStorageConditionTest,
		validReversePrimerStorageConditionTest,
		totalVolumeTest,
		aliquotTests,
		compatibleMaterialsTests
	}],_EmeraldTest];

	(* Generate the result output rule: if not returning result, result rule is just Null *)
	resultRule=Result->If[MemberQ[output,Result],
		resolvedOptions,
		Null
	];

	(* Generate the tests output rule *)
	testsRule=Tests->If[gatherTests,
		allTests,
		Null
	];

	(* Return the output as we desire it *)
	outputSpecification/.{resultRule,testsRule}
];


(* ::Subsubsection::Closed:: *)
(* experimentPCRResourcePackets *)


DefineOptions[experimentPCRResourcePackets,
	Options:>{
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];


experimentPCRResourcePackets[
	myListedSamples:ListableP[ObjectP[Object[Sample]]],
	myListedPrimerPairSamples:ListableP[{{ObjectP[Object[Sample]],ObjectP[Object[Sample]]}..}|{{{Null,Null}}..}],
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	myOptions:OptionsPattern[experimentPCRResourcePackets]
]:=Module[
	{
		unresolvedOptionsNoHidden,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,
		resolvedPreparation,parentProtocol,liquidHandlerContainers,nestedContainersIn,nestedContainerModels,nestedPrimerContainers,
		forwardPrimerContainers,reversePrimerContainers,nestedLiquidHandlerContainerMaxVolumes,uniqueContainersIn,
		uniqueContainerModels,liquidHandlerContainerMaxVolumes,nestedPreparedAssayPlate,uniqueAssayPlateInfo,uniqueSampleResourceLookup,
		takeAllIndexLeavingNull,inputSamplesResourceReplacementRules,samplesInVolumeRules,uniqueSamplesInAndVolumesAssoc,
		samplesInResources,containersInResources, primerPairLengths,forwardPrimers,reversePrimers,primersVolumeRules,
		uniquePrimersAndVolumesAssoc,forwardPrimerResources,reversePrimerResources,activation,activationTime,activationTemperature,
		activationRampRate,denaturationTime,denaturationTemperature,denaturationRampRate,primerAnnealing,primerAnnealingTime,
		primerAnnealingTemperature,primerAnnealingRampRate,extensionTime,extensionTemperature,extensionRampRate,numberOfCycles,finalExtension,
		finalExtensionTime,finalExtensionTemperature,finalExtensionRampRate,runTime,totalRunTime,masterMix,totalMasterMixVolume,masterMixContainer,
		masterMixSourceVesselDeadVolume,masterMixAndVolumeAssoc,masterMixResource,buffer, preparatoryUnitOperations,
		totalBufferVolume,bufferAndVolumeAssoc, bufferResource,forwardPrimerLabels,reversePrimerLabels,instrumentResource,simulation,assayPlate,
		protocolPacket,unitOperationPacket, sharedFieldPacket,rawResourceBlobs,resourcesWithoutName,resourceToNameReplaceRules,
		allResourceBlobs,fulfillable,frqTests,previewRule, optionsRule,resultRule,testsRule
	},

	(* Get the collapsed unresolved index-matching options that don't include hidden options *)
	unresolvedOptionsNoHidden=RemoveHiddenOptions[ExperimentPCR,myUnresolvedOptions];

	(* Get the collapsed resolved index-matching options that don't include hidden options *)
	(* Ignore to collapse those options that are set in expandedsafeoptions *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentPCR,
		RemoveHiddenOptions[ExperimentPCR,myResolvedOptions],
		Ignore->myUnresolvedOptions
	];

	(* Determine the requested output format of this function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Get the inherited cache *)
	inheritedCache=Lookup[ToList[myOptions],Cache,{}];
	simulation=Lookup[ToList[myOptions],Simulation,{}];

	(* Get the resolved preparation scale *)
	resolvedPreparation=Lookup[myResolvedOptions,Preparation];

	(* Look up the resolved option values we need *)
	parentProtocol=Lookup[myResolvedOptions,ParentProtocol];

	(*---Generate all the resources for the experiment---*)

	(*--Download container information--*)
	(* Download plate seal associated with the container if any *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];
	{nestedContainersIn,nestedContainerModels,nestedPrimerContainers,nestedPreparedAssayPlate,nestedLiquidHandlerContainerMaxVolumes}=Quiet[
		Download[
			{
				myListedSamples,
				myListedSamples,
				Flatten[myListedPrimerPairSamples],
				myListedSamples,
				liquidHandlerContainers
			},
			{
				{Container[Object]},
				{Container[Model][Object]},
				{Container[Object]},
				{Container[Contents][[All,2]],Container[Contents][[All,2]][Volume]},
				{MaxVolume}
			},
			Cache->inheritedCache,
			Simulation->simulation
		],
		{Download::FieldDoesntExist}
	];
	uniqueContainersIn=DeleteDuplicates[Flatten[nestedContainersIn]];
	uniqueContainerModels=DeleteDuplicates[Flatten[nestedContainerModels]];
	liquidHandlerContainerMaxVolumes=Flatten[nestedLiquidHandlerContainerMaxVolumes];
	uniqueAssayPlateInfo=Flatten[nestedPreparedAssayPlate];


	(* Generate a resource for each unique sample, returning a lookup table of sample->resource *)
	uniqueSampleResourceLookup[uniqueSamplesAndVolumes_Association]:=KeyValueMap[
		Function[{object,amount},
			Module[{containers},

				If[ObjectQ[object]&&VolumeQ[amount],

					(* If we need to make a resource, figure out which liquid handler compatible containers can be used for this resource *)
					containers=PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[amount]];

					(* Return a resource rule *)
					object->Resource[Sample->object,Amount->amount,Name->ToString[Unique[]],Container->containers],

					(* If we don't need to make a resource, return a rule with the same object *)
					object->object
				]
			]
		],
		uniqueSamplesAndVolumes
	];

	(* Isolate the forward/reverse primer(s) from primer pair(s), returning Null if no primer pair(s) and sample(s)  *)
	takeAllIndexLeavingNull[input_,index_Integer]:=If[NullQ[input],Null,input[[All,index]]];

	(*--Generate the samples in resources--*)

	(* Generate sample volume rules *)
	samplesInVolumeRules=MapThread[Rule,{myListedSamples,Lookup[myResolvedOptions,SampleVolume]}];

	(* Merge any entries with duplicate keys, totaling the values *)
	uniqueSamplesInAndVolumesAssoc=Merge[samplesInVolumeRules,Total];

	(* Make the resources *)
	samplesInResources=Replace[myListedSamples,uniqueSampleResourceLookup[uniqueSamplesInAndVolumesAssoc],{1}];

	(*--Generate the containers in resources--*)
	containersInResources=Resource[Sample->#]&/@uniqueContainersIn;

	(*--Generate the primers resources--*)

	(* Get the number of primer pairs per sample for bringing back the nested form of listedPrimerPairSamples *)
	primerPairLengths=Length/@myListedPrimerPairSamples;

	(* Isolate the forward/reverse primers *)
	forwardPrimers=takeAllIndexLeavingNull[#,1]&/@myListedPrimerPairSamples;
	reversePrimers=takeAllIndexLeavingNull[#,2]&/@myListedPrimerPairSamples;

	(* Isolate the forward/reverse labels *)
	forwardPrimerLabels=takeAllIndexLeavingNull[#,1]&/@Lookup[myResolvedOptions,PrimerPairLabel];
	reversePrimerLabels=takeAllIndexLeavingNull[#,2]&/@Lookup[myResolvedOptions,PrimerPairLabel];

	(* Isolate the forward/reverse containers *)
	forwardPrimerContainers=Take[Flatten[nestedPrimerContainers], {1, -1, 2}];
	reversePrimerContainers= Take[Flatten[nestedPrimerContainers], {2, -1, 2}];

	(* Generate primer volume rules *)
	primersVolumeRules=DeleteCases[Join[
		MapThread[Rule,{Flatten[forwardPrimers],Flatten[Lookup[myResolvedOptions,ForwardPrimerVolume]]}],
		MapThread[Rule,{Flatten[reversePrimers],Flatten[Lookup[myResolvedOptions,ReversePrimerVolume]]}]
	],HoldPattern[Null->_]];

	(* Merge any entries with duplicate keys, totaling the values *)
	(* Different DNA samples can use the same primer pairs, we merge the volume together *)
	uniquePrimersAndVolumesAssoc=Merge[primersVolumeRules,Total];

	(* Make the resources *)
	forwardPrimerResources=Replace[Flatten[forwardPrimers],uniqueSampleResourceLookup[uniquePrimersAndVolumesAssoc],{1}];
	reversePrimerResources=Replace[Flatten[reversePrimers],uniqueSampleResourceLookup[uniquePrimersAndVolumesAssoc],{1}];

	(*--Generate the master mix resource--*)

	(* Get the master mix *)
	masterMix=Lookup[myResolvedOptions,MasterMix];

	(* The extra resource logic here is to match qPCR *)
	(* Calculate the total master mix volume needed, plus 10% extra *)
	totalMasterMixVolume=If[NullQ[Lookup[myResolvedOptions,MasterMixVolume]],
		Null,
		Lookup[myResolvedOptions,MasterMixVolume]*Length[myListedSamples]*1.1+20 Microliter
	];

	(* Figure out what liquid handler compatible container may be used for the master mix *)
	masterMixContainer=PreferredContainer[totalMasterMixVolume,LiquidHandlerCompatible->True];

	(* Calculate master mix source vessel dead volume: 2% container volume is added to ensure complete transfer to all prep wells is possible *)
	masterMixSourceVesselDeadVolume=0.02*(masterMixContainer/.Thread[liquidHandlerContainers->liquidHandlerContainerMaxVolumes]);

	(* Generate the master mix and master mix volume association *)
	masterMixAndVolumeAssoc=<|masterMix->(totalMasterMixVolume+masterMixSourceVesselDeadVolume)|>;

	(* Make the resource *)
	masterMixResource=Replace[masterMix,uniqueSampleResourceLookup[masterMixAndVolumeAssoc]];

	(*--Generate the buffer resource--*)

	(* Get the buffer *)
	buffer=Lookup[myResolvedOptions,Buffer];

	(* Calculate the total buffer volume needed, plus 20 uL extra *)
	totalBufferVolume=If[MatchQ[Flatten[ToList@Lookup[myResolvedOptions,BufferVolume]], {Null..}],
		Null,
		First[ToList[Total[Flatten[Lookup[myResolvedOptions,BufferVolume]/.Null->0 Microliter]]]]+20 Microliter
	];

	(* Generate the buffer and buffer volume association *)
	bufferAndVolumeAssoc=<|buffer->totalBufferVolume|>;

	(* Make the resource *)
	bufferResource=Replace[buffer,uniqueSampleResourceLookup[bufferAndVolumeAssoc]];

	(*--Estimate the run time--*)

	(*Look up the values of the thermocycling parameters*)
	{
		activation,activationTime,activationTemperature,activationRampRate,
		denaturationTime,denaturationTemperature,denaturationRampRate,
		primerAnnealing,primerAnnealingTime,primerAnnealingTemperature,primerAnnealingRampRate,
		extensionTime,extensionTemperature,extensionRampRate,
		numberOfCycles,
		finalExtension,finalExtensionTime,finalExtensionTemperature,finalExtensionRampRate, preparatoryUnitOperations
	}=Lookup[myResolvedOptions,{
		Activation,ActivationTime,ActivationTemperature,ActivationRampRate,
		DenaturationTime,DenaturationTemperature,DenaturationRampRate,
		PrimerAnnealing,PrimerAnnealingTime,PrimerAnnealingTemperature,PrimerAnnealingRampRate,
		ExtensionTime,ExtensionTemperature,ExtensionRampRate,
		NumberOfCycles,
		FinalExtension,FinalExtensionTime,FinalExtensionTemperature,FinalExtensionRampRate, PreparatoryUnitOperations
	}];

	(* Calculate the estimated run time of the reaction *)
	runTime=Plus[
		(* Activation *)
		If[TrueQ[activation],(activationTemperature-25 Celsius)/activationRampRate+activationTime,0 Second],

		(* Denaturation - 1st cycle *)
		Abs[denaturationTemperature-If[TrueQ[activation],activationTemperature,25 Celsius]]/denaturationRampRate+denaturationTime,
		(* Denaturation - all subsequent cycles *)
		(Abs[denaturationTemperature-extensionTemperature]/denaturationRampRate+denaturationTime)*(numberOfCycles-1),

		(* PrimerAnnealing *)
		(If[TrueQ[primerAnnealing],(primerAnnealingTemperature-denaturationTemperature)/primerAnnealingRampRate+primerAnnealingTime,0 Second])*numberOfCycles,

		(* Extension *)
		(Abs[extensionTemperature-If[TrueQ[primerAnnealing],primerAnnealingTemperature,denaturationTemperature]]/extensionRampRate+extensionTime)*numberOfCycles,

		(* FianlExtension *)
		If[TrueQ[finalExtension],(finalExtensionTemperature-extensionTemperature)/finalExtensionRampRate+finalExtensionTime,0 Second],

		(* Add 5 minutes for warm-up *)
		5 Minute
	];

	(*--Generate the instrument resource--*)
	instrumentResource=Resource[Instrument->Lookup[myResolvedOptions,Instrument],Time->runTime+30 Minute];

	(*--Generate the assay plate resource--*)

	(*Get the assay plate*)
	assayPlate= If[
				(* If our resolved assay plate is a model, there are two possible cases: *)
				(* 1 is we have a prepared container that can be directly used for the experiment; *)
				(* 2 is that we will need to pick a model container for resource fulfillment. *)
				(* In cases where we have any sample preparation steps at the beginning of the experiment, we do not need to
				resource pick an assay plate after the sample preparation completes *)
				(* If resolved assay plate is a object, it is user defined in options *)
				(* we will also check if we still need to resource pick the object assay plate. *)
		And[
			NullQ[Flatten[myListedPrimerPairSamples]]||MatchQ[Flatten[myListedPrimerPairSamples],{}],
			NullQ[masterMix],
			NullQ[buffer],
			MatchQ[uniqueContainerModels,{ObjectP[{Model[Container, Plate, "id:9RdZXv1laYVK"],Model[Container, Plate, "id:01G6nvkKrrYm"],Model[Container, Plate,"id:Z1lqpMz1EnVL"]}]..}],
			(* 96-well Optical Full-Skirted PCR Plate & 96-well PCR Plate & Optical Semi-Skirted PCR Plate *)
			SameQ@@uniqueContainersIn,
			Or[
				DatabaseMemberQ[First[uniqueContainersIn]],
				Length[preparatoryUnitOperations]>0,
				MemberQ[
					Values[Lookup[simulation[[1]],Labels]],
					uniqueContainersIn[[1]]
				]
			]
		],
		(* Prepared plate case *)
		Null,
		(* we have to prepare this assay plate *)
		Lookup[myResolvedOptions,AssayPlate]
	];



	(*---Make all the packets for the experiment---*)

	(*--Make the protocol and unit operation packets--*)
	{protocolPacket,unitOperationPacket,simulation,totalRunTime}=If[MatchQ[resolvedPreparation,Manual],
		Module[{manualProtocolPacket,plateSealResource,assayPlateResource},

			(* Make the resource if we do not have a prepared plate so far *)
			assayPlateResource=If[!NullQ[assayPlate],
				Resource[Sample->assayPlate,Name->CreateUniqueLabel["Picked Assay Plate"]],
				Null
			];

			(* Generate the plate seal resource which can resiste high temperature. *)
			(* Currently,we can only take one plate at a time so the plate seal needed is up to 1. We can expand the input later. *)
			plateSealResource= Resource[Sample->Model[Item, PlateSeal, "id:9RdZXv17jeqZ"],Name->CreateUniqueLabel["Plate Seal Cover"]];(*"MicroAmp PCR Plate Seal, Clear"*)

			manualProtocolPacket=<|
				(*===Organizational Information===*)
				Object->CreateID[Object[Protocol,PCR]],
				Type->Object[Protocol,PCR],
				Replace[SamplesIn]->Map[Link[#,Protocols]&,samplesInResources],
				Replace[ContainersIn]->Map[Link[#,Protocols]&,containersInResources],
				Author-> If[MatchQ[parentProtocol,Null],
					Link[$PersonID,ProtocolsAuthored]
				],
				ParentProtocol-> If[MatchQ[parentProtocol,ObjectP[ProtocolTypes[]]],
					Link[parentProtocol,Subprotocols]
				],
				Name->Lookup[myResolvedOptions,Name],

				(*===Options Handling===*)
				UnresolvedOptions->unresolvedOptionsNoHidden,
				ResolvedOptions->resolvedOptionsNoHidden,


				(*===Method Information===*)
				Instrument->Link[instrumentResource],
				LidTemperature->Lookup[myResolvedOptions,LidTemperature],
				RunTime->runTime,


				(*===Resources===*)
				Replace[Checkpoints]->{
					{"Preparing Samples",45 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->$BaselineOperator,Time->45 Minute]]},
					{"Picking Resources",45 Minute,"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator->$BaselineOperator,Time->45 Minute]]},
					{"Preparing Assay Plate",2 Hour,"The AssayPlate is loaded with samples and reagents.",Link[Resource[Operator->$BaselineOperator,Time->2 Hour]]},
					{"Thermocycling",runTime,"The thermocycling procedure is performed on the reaction mixtures.",Link[Resource[Operator->$BaselineOperator,Time->runTime]]},
					{"Returning Materials",1 Hour,"Samples are returned to storage.",Link[Resource[Operator->$BaselineOperator,Time->1 Hour]]}
				},


				(*===Sample Preparation===*)
				PreparedPlate -> Lookup[myResolvedOptions, PreparedPlate],
				ReactionVolume->Lookup[myResolvedOptions,ReactionVolume],
				Replace[SampleVolumes]->Lookup[myResolvedOptions,SampleVolume],
				Replace[ForwardPrimers]->If[NullQ[forwardPrimers],Null,Link/@forwardPrimers],
				Replace[ForwardPrimerResources]->Link/@forwardPrimerResources,
				Replace[ForwardPrimerVolumes]->Lookup[myResolvedOptions,ForwardPrimerVolume],
				Replace[ForwardPrimerStorageConditions]->Lookup[myResolvedOptions,ForwardPrimerStorageCondition],
				Replace[ReversePrimers]->If[NullQ[reversePrimers],Null,Link/@reversePrimers],
				Replace[ReversePrimerResources]->Link/@reversePrimerResources,
				Replace[ReversePrimerVolumes]->Lookup[myResolvedOptions,ReversePrimerVolume],
				Replace[ReversePrimerStorageConditions]->Lookup[myResolvedOptions,ReversePrimerStorageCondition],
				MasterMix->Link[masterMixResource],
				MasterMixVolume->Lookup[myResolvedOptions,MasterMixVolume],
				MasterMixStorageCondition->Lookup[myResolvedOptions,MasterMixStorageCondition],
				Buffer->Link[bufferResource],
				Replace[BufferVolumes]->Lookup[myResolvedOptions,BufferVolume],


				(*===Sample Loading===*)
				AssayPlate->Link[assayPlateResource],
				PlateSeal->Link[plateSealResource],


				(*===Polymerase Activation===*)
				Activation->Lookup[myResolvedOptions,Activation],
				ActivationTime->Lookup[myResolvedOptions,ActivationTime],
				ActivationTemperature->Lookup[myResolvedOptions,ActivationTemperature],
				ActivationRampRate->Lookup[myResolvedOptions,ActivationRampRate],


				(*===Denaturation===*)
				DenaturationTime->Lookup[myResolvedOptions,DenaturationTime],
				DenaturationTemperature->Lookup[myResolvedOptions,DenaturationTemperature],
				DenaturationRampRate->Lookup[myResolvedOptions,DenaturationRampRate],


				(*===Primer Annealing===*)
				PrimerAnnealing->Lookup[myResolvedOptions,PrimerAnnealing],
				PrimerAnnealingTime->Lookup[myResolvedOptions,PrimerAnnealingTime],
				PrimerAnnealingTemperature->Lookup[myResolvedOptions,PrimerAnnealingTemperature],
				PrimerAnnealingRampRate->Lookup[myResolvedOptions,PrimerAnnealingRampRate],


				(*===Strand Extension===*)
				ExtensionTime->Lookup[myResolvedOptions,ExtensionTime],
				ExtensionTemperature->Lookup[myResolvedOptions,ExtensionTemperature],
				ExtensionRampRate->Lookup[myResolvedOptions,ExtensionRampRate],


				(*===Cycling===*)
				NumberOfCycles->Lookup[myResolvedOptions,NumberOfCycles],


				(*===Final Extension===*)
				FinalExtension->Lookup[myResolvedOptions,FinalExtension],
				FinalExtensionTime->Lookup[myResolvedOptions,FinalExtensionTime],
				FinalExtensionTemperature->Lookup[myResolvedOptions,FinalExtensionTemperature],
				FinalExtensionRampRate->Lookup[myResolvedOptions,FinalExtensionRampRate],


				(*===Infinite Hold===*)
				HoldTemperature->Lookup[myResolvedOptions,HoldTemperature]
			|>;
			(*--Make a packet with the shared fields--*)
			sharedFieldPacket=populateSamplePrepFields[myListedSamples,myResolvedOptions,Cache->inheritedCache,Simulation->simulation];

			(*--Merge the specific fields with the shared fields--*)
			(* Return our protocol packet and unit operation packet *)
			{Join[manualProtocolPacket,sharedFieldPacket],{},simulation,runTime}
		],
		Module[
			{
				specifiedSampleLabel,specifiedSampleContainerLabel,specifiedPrimerPairContainerLabel,specifiedMasterMixLabel,specifiedMasterMixContainerLabel,
				specifiedBufferVolume,specifiedBufferLabel,specifiedBufferContainerLabel,expandedSampleIndex,expandedSampleLabel,expandedSamplesInVolumeRules,specifiedAssayPlateLabel,
				specifiedSampleOutLabel,preparationPrimitives,assayPlateObject,assayPlateWells,transferDestinationLabels,expandedBufferVolume,primersContainerLabelRules,uniqueForwardPrimersContainerLabelList,
				uniqueReversePrimersContainerLabelList,uniqueForwardPrimersLabelRules,uniqueReversePrimersLabelRules,uniqueForwardPrimersContainerRules,uniqueReversePrimersContainerRules,
				roboticUnitOperationPacketsCorrectedResources,roboticSimulation,roboticUnitOperationPackets,prepRoboticRunTime,sampleOutLabelingPrimitive,pcrUnitOperationPacket
			},

			(* Gather the resolved labels for all solution/solution containers *)
			{specifiedSampleLabel,specifiedSampleContainerLabel,specifiedPrimerPairContainerLabel,specifiedMasterMixLabel,specifiedMasterMixContainerLabel,
				specifiedBufferVolume,specifiedBufferLabel,specifiedBufferContainerLabel,specifiedAssayPlateLabel,specifiedSampleOutLabel}=Lookup[myResolvedOptions,{SampleLabel,
				SampleContainerLabel,PrimerPairContainerLabel,MasterMixLabel,MasterMixContainerLabel,BufferVolume,BufferLabel,BufferContainerLabel,AssayPlateLabel,SampleOutLabel}];

			(* Expand sample relative inputs *)
			expandedSampleIndex=If[!NullQ[forwardPrimers],
				Length[#]&/@forwardPrimers,
				ConstantArray[1,Length[specifiedSampleLabel]]
			];
			(* For the same DNA sample, if more than one pair of primers are set, the samplelabel needs to be expanded to match the total number of different reaction *)
			expandedSampleLabel=Flatten[MapThread[PadRight[{#1},#2,#1]&,{specifiedSampleLabel,expandedSampleIndex}]];
			expandedSamplesInVolumeRules=Flatten[MapThread[PadRight[{#1},#2,#1]&,{samplesInVolumeRules,expandedSampleIndex}]];
			expandedBufferVolume=Flatten[specifiedBufferVolume];

			(* Generate primer label rules, delete duplicated labels *)
			(* Duplicate cases happen if different samples use the same primers *)
			uniqueForwardPrimersLabelRules=Association@MapThread[Rule,{Flatten[forwardPrimers],Flatten[forwardPrimerLabels]}];
			uniqueReversePrimersLabelRules=Association@MapThread[Rule,{Flatten[reversePrimers],Flatten[reversePrimerLabels]}];
			(* Generate the container rules for forward/reward primers *)
			uniqueForwardPrimersContainerRules=Association@MapThread[Rule,{Flatten[forwardPrimers],Flatten[forwardPrimerContainers]}];
			uniqueReversePrimersContainerRules=Association@MapThread[Rule,{Flatten[reversePrimers],Flatten[reversePrimerContainers]}];
			primersContainerLabelRules=Association@MapThread[Rule,{Flatten[nestedPrimerContainers],Flatten[specifiedPrimerPairContainerLabel]}];
			uniqueForwardPrimersContainerLabelList=Lookup[primersContainerLabelRules,Lookup[uniqueForwardPrimersContainerRules,Keys@uniqueForwardPrimersLabelRules]];
			uniqueReversePrimersContainerLabelList=Lookup[primersContainerLabelRules,Lookup[uniqueReversePrimersContainerRules,Keys@uniqueReversePrimersLabelRules]];

			(* Gather the destination information *)
			assayPlateObject=Lookup[myResolvedOptions,AssayPlate];
			assayPlateWells=ConvertWell[
				Range[1,Length[Flatten[specifiedSampleOutLabel]]],
				InputFormat->TransposedIndex
			];
			transferDestinationLabels=Flatten[specifiedSampleOutLabel];

			(* Prepare the assay plate for PCR *)
			(* Robotic branch will remove all covers first, we have to cover pcr plate even if it was sealed before. *)
			preparationPrimitives=If[NullQ[assayPlate],
				(* If the assay plate is prepared and ready for PCR *)
					Join[
						{LabelContainer[Label->specifiedAssayPlateLabel,Container->First@uniqueContainersIn]},
						{Cover[Sample->specifiedAssayPlateLabel, CoverType -> Seal, CoverLabel -> CreateUniqueLabel["Plate Seal"]]},
						MapThread[
							LabelSample[
								Sample -> {#1,specifiedAssayPlateLabel},
								Label ->#2
							]&,
							{assayPlateWells,Flatten[specifiedSampleOutLabel]}
						]
				],
				(* If not prepared, we will call transfer for sample, primers, master mix and buffer to the container *)
				(* then call cover to prepare the plate for pcr*)
				Module[
					{
					labelPrimitives,bufferPrimitives,masterMixAssayPlatePrimitives,workingSamplesPrimitives,forwardPrimersPrimitives,
					reversePrimersPrimitives,coverPrimitives
				},
					labelPrimitives=Module[
						{
							allUniqueLabelSampleLabels,allUniqueLabelSampleSamples,allUniqueLabelSampleContainerLabels,allUniqueLabelSampleAmounts
						},

						(* Gather LabelSampleInputs *)
						{allUniqueLabelSampleLabels,allUniqueLabelSampleSamples,allUniqueLabelSampleContainerLabels,allUniqueLabelSampleAmounts}=Module[
							{
								flattenedSamples,flattenedLabels,flattenedContainerLabels,flattenedAmounts,connectedTuples,uniqueValidTuples,
								labelTotalAmountLookup
							},
							(* Flatten all components *)
							flattenedSamples=Flatten@Join[{Keys@uniqueSamplesInAndVolumesAssoc,Keys@uniqueForwardPrimersLabelRules,Keys@uniqueReversePrimersLabelRules,Keys@masterMixAndVolumeAssoc,Keys@bufferAndVolumeAssoc}];
							flattenedLabels=Flatten@Join[{specifiedSampleLabel,Values@uniqueForwardPrimersLabelRules,Values@uniqueReversePrimersLabelRules,specifiedMasterMixLabel,specifiedBufferLabel}];
							flattenedContainerLabels=Flatten@Join[{specifiedSampleContainerLabel,uniqueForwardPrimersContainerLabelList,uniqueReversePrimersContainerLabelList,specifiedMasterMixContainerLabel,specifiedBufferContainerLabel}];
							flattenedAmounts=Flatten@Join[{Values@uniqueSamplesInAndVolumesAssoc,Lookup[uniquePrimersAndVolumesAssoc,Keys@uniqueForwardPrimersLabelRules],Lookup[uniquePrimersAndVolumesAssoc,Keys@uniqueForwardPrimersLabelRules],Values@masterMixAndVolumeAssoc,Values@bufferAndVolumeAssoc}];

							(* Link everything together *)
							connectedTuples=Transpose[{flattenedSamples,flattenedLabels,flattenedContainerLabels,flattenedAmounts}];

							(* Only keep unique and valid tuples *)
							uniqueValidTuples=DeleteDuplicates@Cases[connectedTuples,{ObjectP[{Object[Sample],Model[Sample]}],_String,_String,VolumeP}];

							(* Create a lookup of Label -> Total required volume *)
							labelTotalAmountLookup=GroupBy[uniqueValidTuples,First->Last,Total];


							{
								uniqueValidTuples[[All,2]],
								uniqueValidTuples[[All,1]],
								uniqueValidTuples[[All,3]],
								uniqueValidTuples[[All,1]] /.labelTotalAmountLookup
							}
						];

						(* Return single LabelSample and LabelContainer Primitive *)
						{
							{
								LabelSample[
									Label -> allUniqueLabelSampleLabels,
									Sample -> allUniqueLabelSampleSamples,
									ContainerLabel -> allUniqueLabelSampleContainerLabels,
									(* Amount key is only specified if we're dealing with Models *)
									Amount -> MapThread[
										If[MatchQ[#2, ObjectP[Model[Sample]]],
											#1,
											Automatic
										]&,
										{allUniqueLabelSampleAmounts, allUniqueLabelSampleSamples}
									],
									ExactAmount->False (* otherwise, mastermix container has to have exact vol as amount required *)
								]
							},
							{
								LabelContainer[
									Container->assayPlateObject,
									Label->specifiedAssayPlateLabel
								]
							}
						}
					];

					(*--Buffer primitives--*)
					bufferPrimitives= If[!NullQ[totalBufferVolume]||!NullQ[assayPlate],
						{
							Transfer[
								Source -> specifiedBufferLabel,
								Destination -> PickList[({#,specifiedAssayPlateLabel}& /@ assayPlateWells),expandedBufferVolume,GreaterP[0Microliter]],
								Amount -> Cases[expandedBufferVolume,GreaterP[0Microliter]],
								DestinationLabel -> PickList[transferDestinationLabels,expandedBufferVolume,GreaterP[0Microliter]],
								AspirationMix->True,
								AspirationMixType->Pipette
							]
						},
						{}
					];

					(*--Master mix primitives--*)
					masterMixAssayPlatePrimitives=If[!NullQ[assayPlate]&&!NullQ[totalMasterMixVolume],
						{
							Transfer[
								Source->specifiedMasterMixContainerLabel,
								Destination->({#,specifiedAssayPlateLabel}&/@assayPlateWells),
								DestinationLabel -> transferDestinationLabels,
								Amount-> Lookup[myResolvedOptions,MasterMixVolume],
								AspirationMix->True,
								AspirationMixType->Pipette
							]
						},
						{}
					];

					(*--Working samples primitives--*)

					(* Add the working samples to the assay plate *)
					workingSamplesPrimitives= If[Total[Values@uniqueSamplesInAndVolumesAssoc] > 0 Microliter,
						MapThread[
								Transfer[
									Source -> #1,
									Destination -> {#3,specifiedAssayPlateLabel},
									DestinationLabel -> #4,
									Amount -> #2,
									AspirationMix->True,
									AspirationMixType->Pipette
								]&,
								{expandedSampleLabel, Values@expandedSamplesInVolumeRules, assayPlateWells, transferDestinationLabels}
						],
						{}
					];

					(*--Primers primitives--*)

					(* Add the forward primers to the assay plate *)
					forwardPrimersPrimitives=If[!NullQ[assayPlate]&&!NullQ[forwardPrimers],
						MapThread[
							Transfer[
								Source->#1,
								Destination->{#3,specifiedAssayPlateLabel},
								DestinationLabel -> #4,
								Amount->#2,
								AspirationMix->True,
								AspirationMixType->Pipette
							]&,
							{Flatten[forwardPrimers],Flatten[Lookup[myResolvedOptions,ForwardPrimerVolume]],assayPlateWells,transferDestinationLabels}
						],
						{}
					];

					(* Add the reverse primers to the assay plate *)
					reversePrimersPrimitives=If[!NullQ[assayPlate]&&!NullQ[forwardPrimers],
						MapThread[
							Transfer[
								Source->#1,
								Destination->{#3,specifiedAssayPlateLabel},
								DestinationLabel -> #4,
								Amount->#2,
								AspirationMix->True,
								AspirationMixType->Pipette
							]&,
							{Flatten[reversePrimers],Flatten[Lookup[myResolvedOptions,ReversePrimerVolume]],assayPlateWells,transferDestinationLabels}
						],
						{}
					];

					(* Cover the assay plate after adding solutions *)
					coverPrimitives= {
						Cover[
							Sample -> specifiedAssayPlateLabel,
							CoverType -> Seal,
							CoverLabel -> CreateUniqueLabel["Plate Seal"]
						]
					};
					sampleOutLabelingPrimitive= MapThread[
						LabelSample[
							Sample -> {#1,specifiedAssayPlateLabel},
							Label ->#2
						]&,
						{assayPlateWells,Flatten[specifiedSampleOutLabel]}
					];

					Flatten[
						Join[
							labelPrimitives,
							bufferPrimitives,
							masterMixAssayPlatePrimitives,
							workingSamplesPrimitives,
							forwardPrimersPrimitives,
							reversePrimersPrimitives,
							coverPrimitives,
							sampleOutLabelingPrimitive
						]
					]
				]
			];

		(* Get our robotic unit operation packets. *)
			{{roboticUnitOperationPackets, prepRoboticRunTime}, roboticSimulation}=ExperimentRoboticCellPreparation[
				preparationPrimitives,
				UnitOperationPackets -> True,
				Output->{Result, Simulation},
				FastTrack -> Lookup[myResolvedOptions, FastTrack],
				ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol],
				Name -> Lookup[myResolvedOptions, Name],
				Simulation -> simulation,
				Upload -> False,
				(* We should not cover at the end of PCR, instead, we should cover at the end of the RSP/RCP group. If we have more UOs to run after PCR, the plate should be left uncovered. *)
				(* This option does not affect the automatic Cover added at the end of the RSP/RCP group handled in the primitive framework. *)
				CoverAtEnd -> False,
				ImageSample -> False,
				MeasureVolume -> False,
				MeasureWeight -> False,
				Priority -> Lookup[myResolvedOptions, Priority],
				StartDate -> Lookup[myResolvedOptions, StartDate],
				HoldOrder -> Lookup[myResolvedOptions, HoldOrder],
				QueuePosition -> Lookup[myResolvedOptions, QueuePosition]
			];

			(* Create Resource Replacement Rules *)
			inputSamplesResourceReplacementRules=(Resource[KeyValuePattern[Sample->#[[1]][Sample]]]->#)&/@samplesInResources;

			(* Replace the Resources in the roboticUnitOperationPackets that correspond to the input samples with the *)
			(* resource with a name created at the beginning of the resource packets function. This is to prevent duplicate *)
			(* resources being generated when the input Sample has to be Aliquoted to a new container *)
			roboticUnitOperationPacketsCorrectedResources=roboticUnitOperationPackets/.inputSamplesResourceReplacementRules;

			pcrUnitOperationPacket=UploadUnitOperation[
				Module[{nonHiddenOptions},
				(* Only include non-hidden options from Cover. *)
						nonHiddenOptions=Lookup[
							Cases[OptionDefinition[ExperimentPCR], KeyValuePattern["Category"->Except["Hidden"]]],
							"OptionSymbol"
						];
						(* Join the new field AssayPlateUnitOperations with resolved options *)
						PCR@@Join[
							{
								Sample->samplesInResources,
								AssayPlateUnitOperations->(Link/@Lookup[roboticUnitOperationPacketsCorrectedResources, Object])
							},
							ReplaceRule[
								Cases[Normal[myResolvedOptions], Verbatim[Rule][Alternatives@@nonHiddenOptions|AssayPlateLabel, _]],
								Instrument->instrumentResource
								]
						]
					],
					Preparation->Robotic,
					UnitOperationType->Output,
					FastTrack->True,
					Upload->False
			];


		roboticSimulation=UpdateSimulation[
			roboticSimulation,
			Module[{protocolPacket},
				protocolPacket=<|
					Object->SimulateCreateID[Object[Protocol,RoboticSamplePreparation]],
					Replace[OutputUnitOperations]->(Link[Lookup[pcrUnitOperationPacket,Object], Protocol]),
					ResolvedOptions->{}
				|>;

				SimulateResources[protocolPacket, {pcrUnitOperationPacket}, ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null], Simulation->simulation]
			]
		];

			{
				Null,
				Flatten[{pcrUnitOperationPacket,roboticUnitOperationPackets}],
				roboticSimulation,
				(prepRoboticRunTime+runTime+10Minute)
			}

		]
	];



	(*--Gather all the resource symbolic representations--*)

	(* Need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	rawResourceBlobs=DeleteDuplicates[Cases[Flatten[{Normal[protocolPacket],Normal[unitOperationPacket]}],_Resource,Infinity]];

	(* Get all resources without a name *)
	resourcesWithoutName=DeleteDuplicates[Cases[rawResourceBlobs,Resource[_?(MatchQ[KeyExistsQ[#,Name],False]&)]]];
	resourceToNameReplaceRules=MapThread[#1->#2&,{resourcesWithoutName,(Resource[Append[#[[1]],Name->CreateUUID[]]]&)/@resourcesWithoutName}];
	allResourceBlobs=rawResourceBlobs/.resourceToNameReplaceRules;


	(*---Call fulfillableResourceQ on all the resources we created---*)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],{True,{}},
		(* When Preparation->Robotic, the framework will call FRQ for us *)
		MatchQ[resolvedPreparation,Robotic],{True,{}},
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache,Simulation->simulation],
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache,Simulation->simulation],Null}
	];


	(*---Return our options, packets, and tests---*)

	(* Generate the preview output rule; Preview is always Null *)
	previewRule=Preview->Null;

	(* Generate the options output rule *)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* Generate the result output rule: if not returning result, or the resources are not fulfillable, result rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		{Flatten[{protocolPacket,unitOperationPacket}], simulation, totalRunTime}/.resourceToNameReplaceRules,
		$Failed
	];

	(* Generate the tests output rule *)
	testsRule=Tests->If[gatherTests,
		frqTests,
		{}
	];

	(* Return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];


(* ::Subsubsection::Closed:: *)
(* simulateExperimentPCR *)


DefineOptions[simulateExperimentPCR,
	Options:>{
		CacheOption,
		SimulationOption
	}
];


simulateExperimentPCR[
	myProtocolPacket:(PacketP[Object[Protocol,PCR],{Object,ResolvedOptions}]|Null|$Failed),
	myUnitOperationPacket:({PacketP[]...}|$Failed|Null),
	myListedSamples:ListableP[ObjectP[Object[Sample]]],
	myListedPrimerPairSamples:ListableP[{{ObjectP[Object[Sample]],ObjectP[Object[Sample]]}..}|{{{Null,Null}}..}],
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentPCR]
]:=Module[
	{protocolObject,cache,inheritedSimulation,parentProtocol,sampleVolumes,forwardPrimerVolumes,reversePrimerVolumes,masterMixVolume,bufferVolumes,currentSimulation,
		unitOperationField,simulatedSamplePackets,simulatedAssayPlatePackets,takeAllIndexLeavingNull,
		simulatedSourceAndDestinationCache,samplesIn,containersIn,sampleOut,assayPlate,
		samplesInTransferPackets,simulationWithLabels,masterMix,buffer, resolvedPreparation, simulatedAssayPlatePacketsCorrected, simulatedContainersInPackets},

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed *)
	protocolObject=Which[
		(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to simulate an ID here in the simulation function in order to call SimulateResources *)
		MatchQ[Lookup[myResolvedOptions,Preparation],Robotic],
			SimulateCreateID[Object[Protocol,RoboticSamplePreparation]],
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver *)
		MatchQ[myProtocolPacket,$Failed],
			SimulateCreateID[Object[Protocol,PCR]],
		True,
			Lookup[myProtocolPacket,Object]
	];

	(* Pull out the cache and simulation from the resolution options *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];
	inheritedSimulation=Lookup[ToList[myResolutionOptions],Simulation,Null];
	parentProtocol=Lookup[ToList[myResolutionOptions],ParentProtocol,Null];

	(* Look up our resolved options *)
	{sampleVolumes,forwardPrimerVolumes,reversePrimerVolumes,masterMixVolume,bufferVolumes,masterMix,buffer, resolvedPreparation}=Lookup[
		myResolvedOptions,
		{SampleVolume,ForwardPrimerVolume,ReversePrimerVolume,MasterMixVolume,BufferVolume,MasterMix,Buffer, Preparation}
	];

	(* Simulate the fulfillment of all resources by the procedure *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, just make a shell of a protocol object so that we can return something back *)
	currentSimulation=Which[
		(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a Object[Protocol,RoboticSamplePreparation] so that we can call SimulateResources *)
		MatchQ[myProtocolPacket,Null]&&MatchQ[myUnitOperationPacket,{PacketP[]...}],
			Module[{protocolPacket},
				protocolPacket=<|
					Object->protocolObject,
					Replace[OutputUnitOperations]->(Link[#,Protocol]&)/@Lookup[myUnitOperationPacket,Object, {}],
					Replace[RequiredObjects]->DeleteDuplicates[
						Cases[myUnitOperationPacket,Resource[KeyValuePattern[Type->Except[Object[Resource,Instrument]]]],Infinity]
					],
					Replace[RequiredInstruments]->DeleteDuplicates[
						Cases[myUnitOperationPacket,Resource[KeyValuePattern[Type->Object[Resource,Instrument]]],Infinity]
					],
					ResolvedOptions->myResolvedOptions
				|>;

				SimulateResources[protocolPacket,myUnitOperationPacket,ParentProtocol->parentProtocol,Simulation->inheritedSimulation]
			],

		(* Otherwise, if we have a $Failed for the protocol packet, that means that we had a problem in option resolving and skipped resource packet generation. Just make a shell protocol object so that we can call SimulateResources *)
		MatchQ[myProtocolPacket,$Failed],
			Module[
				{
					protocolPacket,simulatedPrimitiveIDs,simulatedSamplesIn,forwardPrimers,
					reversePrimers,simulatedForwardPrimers,simulatedReversePrimers
				},
				simulatedPrimitiveIDs = SimulateCreateID[ConstantArray[Object[UnitOperation, Filter], Length[myListedSamples]]];

				simulatedSamplesIn=MapThread[
					Function[{sample,volume},
						Link[
							Resource[
								Sample->sample,
								Amount->volume
							]
						]
					],
					{myListedSamples,sampleVolumes}
				];

				(* Isolate the forward/reverse primer(s) from primer pair(s), returning Null if no primer pair(s) and sample(s) otherwise *)
				takeAllIndexLeavingNull[input_,index_Integer]:=If[NullQ[input],Null,input[[All,index]]];

				forwardPrimers=If[NullQ[myListedPrimerPairSamples],Null,takeAllIndexLeavingNull[#,1]&/@myListedPrimerPairSamples];
				reversePrimers=If[NullQ[myListedPrimerPairSamples],Null,takeAllIndexLeavingNull[#,2]&/@myListedPrimerPairSamples];

				simulatedForwardPrimers=If[
					NullQ[forwardPrimerVolumes],
					Null,
					MapThread[
						Function[{sample,volume},
							Link[
								Resource[
									Sample->FirstOrDefault[sample,sample],
									Amount->FirstOrDefault[volume,volume]
								]
							]
						],
						{forwardPrimers,forwardPrimerVolumes}
					]
				];
				simulatedReversePrimers=If[
					NullQ[reversePrimerVolumes],
					Null,
					MapThread[
						Function[{sample,volume},
							Link[
								Resource[
									Sample->FirstOrDefault[sample,sample],
									Amount->FirstOrDefault[volume,volume]
								]
							]
						],
						{reversePrimers,reversePrimerVolumes}
					]
				];


				protocolPacket=<|
					Object->protocolObject,
					Replace[OutputUnitOperations]->(Link[#,Protocol]&)/@simulatedPrimitiveIDs,
					Replace[SamplesIn]->simulatedSamplesIn,
					Replace[ForwardPrimerResources]->Flatten[ToList[simulatedForwardPrimers]],
					Replace[ReversePrimerResources]->Flatten[ToList[simulatedReversePrimers]],
					Replace[Instrument]->Link[Resource[Instrument->Lookup[myResolvedOptions,Instrument]],Time->30Minute],
					Replace[RequiredObjects]->DeleteDuplicates[
						Cases[myUnitOperationPacket,Resource[KeyValuePattern[Type->Except[Object[Resource,Instrument]]]],Infinity]
					],
					Replace[RequiredInstruments]->DeleteDuplicates[
						Cases[myUnitOperationPacket,Resource[KeyValuePattern[Type->Object[Resource,Instrument]]],Infinity]
					],
					ResolvedOptions->myResolvedOptions
				|>;

				SimulateResources[protocolPacket,Null,Cache->cache,Simulation->inheritedSimulation]
			],

		(* Otherwise, our resource packets went fine and we have an Object[Protocol,PCR] *)
		True, SimulateResources[myProtocolPacket,myUnitOperationPacket,Cache->cache,Simulation->inheritedSimulation]
	];

	(* Download information from our simulated resources *)
	{
		simulatedSamplePackets,
		simulatedAssayPlatePackets,
		simulatedContainersInPackets
	}=If[MatchQ[resolvedPreparation, Robotic],
		Quiet[
			Download[
				protocolObject,
				{
					Packet[OutputUnitOperations[SampleLink][{Model,State,Container,Name,Contents}]],
					Packet[OutputUnitOperations[AssayPlateLink][{Model,State,Container,Name,Contents}]],
					Packet[OutputUnitOperations[SampleLink][[1]][Container][{Model,State,Container,Name,Contents}]]
				},
				Simulation->currentSimulation
			],
			{Download::NotLinkField,Download::FieldDoesntExist}
		],
		Quiet[
			Download[
				protocolObject,
				{
					Packet[SamplesIn[{Model,State,Container,Name,Contents}]],
					Packet[AssayPlate[{Model,State,Container,Name,Contents}]],
					Packet[ContainersIn[[1]][{Model,State,Container,Name,Contents}]]
				},
				Simulation->currentSimulation
			],
			{Download::NotLinkField,Download::FieldDoesntExist}
		]

	];

	simulatedAssayPlatePacketsCorrected = If[NullQ[simulatedAssayPlatePackets],
		simulatedContainersInPackets,
		simulatedAssayPlatePackets
	];

	simulatedSourceAndDestinationCache=FlattenCachePackets[{
		simulatedSamplePackets,
		simulatedAssayPlatePacketsCorrected
	}];

	(* Get SamplesIn and ContainersIn *)
	{samplesIn,containersIn}=If[
		Length[simulatedSamplePackets]>0,
		Flatten/@Transpose[{Lookup[#,Object,{}],Download[Lookup[#,Container,{}],Object]}&/@simulatedSamplePackets],
		{myListedSamples,ConstantArray[Null,Length[myListedSamples]]}
	];

	(* Get SampleOut and AssayPlate *)
	{sampleOut,assayPlate}=Module[{},

		(* If there are already samples in the assay plate, assume it's the input plate, otherwise upload new samples to the empty plate *)
		If[!MatchQ[Lookup[simulatedAssayPlatePacketsCorrected,Contents,{}],{}],
			{samplesIn,First[containersIn]},
			Module[{samplesInModels,assayPlateWells,destinations,newSampleOut, newSampleOutPackets},
				samplesInModels=Download[Lookup[Flatten[simulatedSamplePackets],Model],Object];
				assayPlateWells=ConvertWell[
					Range[1,Length[samplesInModels]],
					InputFormat->TransposedIndex
				];
				destinations={#,Lookup[simulatedAssayPlatePacketsCorrected,Object]}&/@assayPlateWells;
				(* make empty samples in the destinations, and also don't put volumes in them because UploadSampleTransfer will take care of it *)
				newSampleOutPackets = UploadSample[
					ConstantArray[{}, Length[samplesInModels]],
					destinations,
					Simulation -> currentSimulation,
					FastTrack->True,
					Upload -> False,
					SimulationMode -> True
				];
				currentSimulation = UpdateSimulation[currentSimulation, Simulation[newSampleOutPackets]];
				newSampleOut = Lookup[Take[newSampleOutPackets, Length[samplesInModels]], Object, {}];

				{newSampleOut,Lookup[simulatedAssayPlatePacketsCorrected,Object]}
			]
		]
	];

	(* Make SamplesIn transfer packets *)
	samplesInTransferPackets=If[!MatchQ[samplesIn,sampleOut],
		UploadSampleTransfer[
			samplesIn,
			sampleOut,
			sampleVolumes,
			Upload->False,
			FastTrack->True,
			Simulation->currentSimulation
		],
		{}
	];

	(* Update our simulation *)
	currentSimulation=UpdateSimulation[currentSimulation,Simulation[Packets->Flatten[samplesInTransferPackets]]];

	simulationWithLabels=Simulation[
		Labels->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions,SampleLabel],samplesIn}],
				{_String,ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions,SampleContainerLabel],containersIn}],
				{_String,ObjectP[]}
			],
			Rule@@@Cases[
				{{Lookup[myResolvedOptions,AssayPlateLabel],assayPlate}},
				{_String,ObjectP[]}
			]
		],
		LabelFields->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions,SampleLabel],(Field[SampleLink[[#]]]&)/@Range[Length[samplesIn]]}],
				{_String,_}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions,SampleContainerLabel],(Field[SampleLink[[#]][Container]]&)/@Range[Length[samplesIn]]}],
				{_String,_}
			],
			Rule@@@Cases[
				{Lookup[myResolvedOptions,AssayPlateLabel],(Field[AssayPlateLink])},
				{_String,_}
			]
		]
	];

	(* Merge our packets with our labels *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation,simulationWithLabels]
	}

];


(* ::Subsubsection::Closed:: *)
(* resolveExperimentPCRMethod *)


DefineOptions[resolveExperimentPCRMethod,
	SharedOptions:>{
		ExperimentPCR,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];


(* PCR can always be done manually or robotically (same thermocycler, and any sample inside a liquid handler incompatible container will be automatically aliquoted into a compatible one) *)
resolveExperimentPCRMethod[
	myListedSamples:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container]}]],
	myListedPrimerPairSamples:ListableP[{{ObjectP[{Object[Sample], Object[Container]}],ObjectP[{Object[Sample], Object[Container]}]}..}|{{{Null,Null}}..}|Null|Automatic],
	myOptions:OptionsPattern[resolveExperimentPCRMethod]
]:=Module[
	{safeOptions, outputSpecification, output, gatherTests, sourceContainerPackets, sourceSamplePackets,
		destinationContainerPackets, destinationSamplePackets, allPackets, allModelContainerPackets, allModelContainerPlatePackets, liquidHandlerIncompatibleContainers, allObjectSamplePackets,
		manualRequirementStrings, roboticRequirementStrings, result, tests},

	(* Get our safe options. *)
	safeOptions=SafeOptions[resolveExperimentPCRMethod, ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Download information that we need from our inputs and/or options. *)
	{
		sourceContainerPackets,
		sourceSamplePackets,
		destinationContainerPackets,
		destinationSamplePackets
	}=Quiet[
		Download[
			{
				Cases[Flatten[ToList[myListedSamples]], ObjectP[Object[Container]]],
				Cases[Flatten[ToList[myListedSamples]], ObjectP[Object[Sample]]],
				Cases[Flatten[ToList[myListedPrimerPairSamples]], ObjectP[Object[Container]]],
				Cases[Flatten[ToList[myListedPrimerPairSamples]], ObjectP[Object[Sample]]]
			},
			{
				{Packet[Model[{Name, Footprint, Dimensions, LiquidHandlerAdapter, LiquidHandlerPrefix}]], Packet[Name, Model, Contents], Packet[Contents[[All,2]][{Name, LiquidHandlerIncompatible, Container, Position}]]},
				{Packet[Name, LiquidHandlerIncompatible, Container, Position], Packet[Container[Model[{Name, Footprint, Dimensions, LiquidHandlerAdapter, LiquidHandlerPrefix}]]]},
				{Packet[Model[{Name, Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix}]], Packet[Name, Model, Contents], Packet[Contents[[All,2]][{Name, LiquidHandlerIncompatible, Container, Position}]]},
				{Packet[Name, LiquidHandlerIncompatible, Container, Position], Packet[Container[Model[{Name, Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix}]]]}
			},
			Cache->Lookup[ToList[myOptions], Cache, {}],
			Simulation->Lookup[ToList[myOptions], Simulation, Null]
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	(* Join all packets. *)
	allPackets=Flatten[{sourceContainerPackets, sourceSamplePackets, destinationContainerPackets, destinationSamplePackets}];

	(* Get all of our Model[Container]s and look at their footprints. *)
	allModelContainerPackets=Cases[
		allPackets,
		PacketP[Model[Container]]
	];
	allModelContainerPlatePackets=Cases[allModelContainerPackets,PacketP[Model[Container,Plate]]];

	(* Get the containers that are liquid handler incompatible (PCR requires the container to be a plate) *)
	liquidHandlerIncompatibleContainers=DeleteDuplicates[
		Join[
			Lookup[Cases[allModelContainerPackets,KeyValuePattern[Footprint->Except[Plate]]],Object,{}],
			Lookup[Cases[allModelContainerPlatePackets,KeyValuePattern[LiquidHandlerPrefix->Null]],Object,{}]
		]
	];

	(* Get all Object[Sample]s. *)
	allObjectSamplePackets=Cases[
		allPackets,
		PacketP[Object[Sample]]
	];

	(* Create a list of reasons why we need Preparation->Manual. *)
	manualRequirementStrings={
		If[!MatchQ[liquidHandlerIncompatibleContainers,{}],
			"the sample containers "<>ToString[ObjectToString/@liquidHandlerIncompatibleContainers]<>" are not liquid handler compatible plate",
			Nothing
		],
		Module[{manualOnlyOptions},
			manualOnlyOptions=Select[{ImageSample, MeasureVolume, MeasureWeight},(!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|Swirl|Automatic|False]]&)];

			If[Length[manualOnlyOptions]>0,
				"the following Manual-only options were specified "<>ToString[manualOnlyOptions],
				Nothing
			]
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[IncubatePrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Incubate Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[CentrifugePrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Centrifuge Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[FilterPrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Filter Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[AliquotOptions], "OptionSymbol"], Except[ListableP[False|Null|Automatic|{Automatic..}]]]],
			"the Aliquot Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[Lookup[allObjectSamplePackets, LiquidHandlerIncompatible], True],
			"the following samples are liquid handler incompatible "<>ObjectToString[Lookup[Cases[allObjectSamplePackets, KeyValuePattern[LiquidHandlerIncompatible->True]], Object], Cache->allPackets],
			Nothing
		],
		If[MatchQ[Lookup[safeOptions, Preparation], Manual],
			"the Preparation option is set to Manual by the user",
			Nothing
		]
	};

	(* Create a list of reasons why we need Preparation->Robotic. *)
	roboticRequirementStrings={
		If[MatchQ[Lookup[safeOptions, Preparation], Robotic],
			"the Preparation option is set to Robotic by the user",
			Nothing
		]
	};

	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0 && !gatherTests,
		(* NOTE: Blocking $MessagePrePrint stops our error message from being truncated with ... if it gets too long. *)
		Block[{$MessagePrePrint},
			Message[
				Error::ConflictingUnitOperationMethodRequirements,
				listToString[manualRequirementStrings],
				listToString[roboticRequirementStrings]
			]
		]
	];

	(* Return our result and tests. *)
	result=Which[
		!MatchQ[Lookup[safeOptions, Preparation], Automatic],
			Lookup[safeOptions, Preparation],
		Length[manualRequirementStrings]>0,
			Manual,
		Length[roboticRequirementStrings]>0,
			Robotic,
		True,
			{Manual, Robotic}
	];

	tests=If[MatchQ[gatherTests, False],
		{},
		{
			Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the Transfer primitive",
				Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0,
				False
			]
		}
	];

	outputSpecification/.{Result->result, Tests->tests}
];


(* ::Subsubsection::Closed:: *)
(* resolveExperimentPCRWorkCell *)


resolveExperimentPCRWorkCell[
	myListedSamples:ListableP[ObjectP[{Object[Sample], Object[Container]}]|{_String,ObjectP[Object[Container]]}],
	myListedPrimerPairSamples:ListableP[{{ObjectP[Object[Sample]],ObjectP[Object[Sample]]}..}|{{{Null,Null}}..}|Null|Automatic],
	myOptions:OptionsPattern[resolveExperimentPCRWorkCell]
]:={bioSTAR,microbioSTAR};


(* ::Subsection::Closed:: *)
(* ExperimentPCROptions *)


DefineOptions[ExperimentPCROptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentPCR}
];


(*---Main function accepting sample/container objects as sample inputs and sample objects or Nulls as primer pair inputs---*)
ExperimentPCROptions[
	mySamples:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],
	myPrimerPairSamples:ListableP[{{ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]},ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}}..}|{{Null,Null}}],
	myOptions:OptionsPattern[ExperimentPCROptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove the OutputFormat option *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentPCR[mySamples,myPrimerPairSamples,preparedOptions];

	(* Return the option as a list or table *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentPCR],
		resolvedOptions
	]
];


(*---Function definition accepting sample/container objects as sample inputs and no primer pair inputs---*)
ExperimentPCROptions[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container], Model[Sample]}]|_String],
	myOptions:OptionsPattern[ExperimentPCROptions]
]:=ExperimentPCROptions[
	mySamples,
	Table[{{Null,Null}},Length[ToList[mySamples]]],
	myOptions
];


(* ::Subsection::Closed:: *)
(* ExperimentPCRPreview *)


DefineOptions[ExperimentPCRPreview,
	SharedOptions:>{ExperimentPCR}
];


(*---Main function accepting sample/container objects as sample inputs and sample objects or Nulls as primer pair inputs---*)
ExperimentPCRPreview[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container], Model[Sample]}]|_String],
	myPrimerPairSamples:ListableP[{{ObjectP[Object[Sample]],ObjectP[Object[Sample]]}..}|{{Null,Null}}|_String],
	myOptions:OptionsPattern[ExperimentPCRPreview]
]:=Module[{listedOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	ExperimentPCR[mySamples,myPrimerPairSamples,ReplaceRule[listedOptions,Output->Preview]]
];


(*---Function definition accepting sample/container objects as sample inputs and no primer pair inputs---*)
ExperimentPCRPreview[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container], Model[Sample]}]|_String],
	myOptions:OptionsPattern[ExperimentPCRPreview]
]:=ExperimentPCRPreview[
	mySamples,
	Table[{{Null,Null}},Length[ToList[mySamples]]],
	myOptions
];


(* ::Subsection::Closed:: *)
(* ValidExperimentPCRQ *)


DefineOptions[ValidExperimentPCRQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions:>{ExperimentPCR}
];


(*---Main function accepting sample/container objects as sample inputs and sample objects or Nulls as primer pair inputs---*)
ValidExperimentPCRQ[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container], Model[Sample]}]|_String],
	myPrimerPairSamples:ListableP[{{ObjectP[Object[Sample]],ObjectP[Object[Sample]]}..}|{{Null,Null}}|_String],
	myOptions:OptionsPattern[ValidExperimentPCRQ]
]:=Module[
	{listedOptions,preparedOptions,experimentPCRTests,initialTestDescription,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Call the ExperimentPCR function to get a list of tests *)
	experimentPCRTests=ExperimentPCR[mySamples,myPrimerPairSamples,Append[preparedOptions,Output->Tests]];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* Make a list of all the tests, including the blanket test *)
	allTests=If[MatchQ[experimentPCRTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(* Generate the initial test, which should pass if we got this far *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[Cases[Flatten[{mySamples,myPrimerPairSamples}],ObjectP[]],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Cases[Flatten[{mySamples,myPrimerPairSamples}],ObjectP[]],validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Cases[Flatten[{initialTest,experimentPCRTests,voqWarnings}],_EmeraldTest]
		]
	];

	(* Look up the test-running options *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentPCRQ"->allTests|>,Verbose->verbose,OutputFormat->outputFormat],"ValidExperimentPCRQ"]
];


(*---Function definition accepting sample/container objects as sample inputs and no primer pair inputs---*)
ValidExperimentPCRQ[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Container], Model[Sample]}]|_String],
	myOptions:OptionsPattern[ValidExperimentPCRQ]
]:=ValidExperimentPCRQ[
	mySamples,
	Table[{{Null,Null}},Length[ToList[mySamples]]],
	myOptions
];
