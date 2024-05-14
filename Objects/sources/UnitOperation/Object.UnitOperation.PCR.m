(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation,PCR],
	{
		Description->"A detailed set of parameters that specifies a single PCR step in a larger protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			(*===Method Information===*)
			Instrument->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]],
				Description->"The instrument for running the polymerase chain reaction (PCR) experiment.",
				Category -> "General"
			},
			LidTemperature->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"The temperature of the instrument's plate lid throughout the reaction. The lid is heated to prevent water from condensing on the plate seal.",
				Category -> "General"
			},


			(*===Sample Preparation===*)

			(*Index-matching options*)
			SampleLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Object[Sample],
					Model[Sample],
					Model[Container],
					Object[Container]
				],
				Description->"The samples containing nucleic acid templates and primer pairs for the amplification of the target sequences.",
				Category->"Sample Preparation",
				Migration->SplitField
			},
			SampleString->{
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Description->"The samples containing nucleic acid templates and primer pairs for the amplification of the target sequences.",
				Category->"Sample Preparation",
				Migration->SplitField
			},
			SampleExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
				Relation -> Null,
				Description -> "The samples containing nucleic acid templates and primer pairs for the amplification of the target sequences.",
				Category->"Sample Preparation",
				Migration->SplitField
			},
			SampleLabel->{
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Description->"For each member of SampleLink, the label of the sample that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"Sample Preparation",
				IndexMatching->SampleLink
			},
			SampleContainerLabel->{
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Description->"For each member of SampleLink, the label of the container that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"Sample Preparation",
				IndexMatching->SampleLink
			},
			SampleVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Microliter,
				Description->"For each member of SampleLink, the volume to add to the reaction.",
				Category->"Sample Preparation",
				IndexMatching->SampleLink
			},
			(* Todo: N-Multiples *)
			PrimerPairExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{_List..},
				Description->"The samples containing pairs of oligomer strands designed to bind to the templates and serve as anchors for the polymerase.",
				Category->"Sample Preparation",
				Migration->SplitField
			},
			(* Todo: N-Multiples *)
			PrimerPairString->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{_String|Null,_String|Null}..},
				Description->"The samples containing pairs of oligomer strands designed to bind to the templates and serve as anchors for the polymerase.",
				Category->"Sample Preparation",
				Migration->SplitField
			},
			(* Todo: N-Multiples *)
			PrimerPairLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{_String|Null,_String|Null}..},
				Description->"For each member of SampleLink, the label of the sample that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"Sample Preparation",
				IndexMatching->SampleLink
			},
			(* Todo: N-Multiples *)
			PrimerPairContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{_String|Null,_String|Null}..},
				Description->"For each member of SampleLink, the label of the container that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"Sample Preparation",
				IndexMatching->SampleLink
			},
			(* Todo: N-Multiples *)
			ForwardPrimerVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{GreaterEqualP[0 Microliter]..},
				Description->"For each member of SampleLink, the forward primer volumes to add to the reaction.",
				Category->"Sample Preparation",
				IndexMatching->SampleLink
			},
			ForwardPrimer->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{_Link..|Null},
				Description->"For each member of SampleLink, the list of primers that bind the target sequences on the antisense strand of the template.",
				Category->"Sample Preparation",
				IndexMatching->SampleLink
			},
			ForwardPrimerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>({_String..}|ListableP[_String]|Null),
				Description->"The flattened list of labels for FowardPrimers.",
				Category->"Sample Preparation",
				Developer->True
			},
			ForwardPrimerResource->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Sample],Object[Sample]],
				Description->"The flattened list of primers that bind the target sequences on the antisense strand of the templates.",
				Category->"Sample Preparation",
				Developer->True
			},
			(* Todo: N-Multiples *)
			ForwardPrimerStorageCondition->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{(SampleStorageTypeP|Disposal)..},
				Description->"For each member of SampleLink, the non-default conditions under which the forward primers of this experiment should be stored after the protocol is completed. If left unset, the forward primers will be stored according to their current StorageCondition.",
				Category->"Sample Storage",
				IndexMatching->SampleLink
			},
			(* Todo: N-Multiples *)
			ReversePrimerVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{GreaterEqualP[0 Microliter]..},
				Description->"For each member of SampleLink, the reverse primer volumes to add to the reaction.",
				Category->"Sample Preparation",
				IndexMatching->SampleLink
			},
			(* Todo: N-Multiples *)
			ReversePrimerStorageCondition->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{(SampleStorageTypeP|Disposal)..},
				Description->"For each member of SampleLink, the non-default conditions under which the reverse primers of this experiment should be stored after the protocol is completed. If left unset, the reverse primers will be stored according to their current StorageCondition.",
				Category->"Sample Storage",
				IndexMatching->SampleLink
			},
			ReversePrimer->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{_Link..|Null},
				Description->"For each member of SampleLink, the list of primers that bind the target sequences on the sense strand of the template.",
				Category->"Sample Preparation",
				IndexMatching->SampleLink
			},
			ReversePrimerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{(_String|ListableP[_String]|Null)..},
				Description->"The flattened list of labels for ReversePrimers.",
				Category->"Sample Preparation",
				Developer->True
			},
			ReversePrimerResource->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Sample],Object[Sample]],
				Description->"The flattened list of primers that bind the target sequences on the sense strand of the templates.",
				Category->"Sample Preparation",
				Developer->True
			},
			BufferVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>GreaterEqualP[0 Microliter]|{GreaterEqualP[0 Microliter]..},
				Description->"For each member of SampleLink, the buffer volume to add to bring each reaction to ReactionVolume.",
				Category->"Sample Preparation",
				IndexMatching->SampleLink
			},
			SamplesOut -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Sample],
				Description -> "For each member of SampleLink, the SamplesOut  after all the assayplate preparation and pcr steps.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			SampleOutLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>_String|{_String..},
				Description->"For each member of SampleLink, the label of the output sample that contains amplified sequence(s), which is used for identification elsewhere in sample preparation.",
				Category->"Sample Preparation",
				IndexMatching->SampleLink
			},

			(*Global options*)
			ReactionVolume->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Microliter,
				Description->"The total volume of the reaction including the template, primers, master mix, and buffer.",
				Category->"Sample Preparation"
			},
			MasterMixLink->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Object[Sample],
					Model[Sample],
					Model[Container],
					Object[Container]
				],
				Description->"The stock solution composed of the polymerase, nucleotides, and buffer for amplifying the target sequences.",
				Category->"Sample Preparation",
				Migration->SplitField
			},
			MasterMixString->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The stock solution composed of the polymerase, nucleotides, and buffer for amplifying the target sequences.",
				Category->"Sample Preparation",
				Migration->SplitField
			},
			MasterMixLabel->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The label of the master mix sample that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"Sample Preparation"
			},
			MasterMixContainerLabel->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The label of the master mix container that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"Sample Preparation"
			},
			MasterMixVolume->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Microliter,
				Description->"The volume of master mix to add to the reaction.",
				Category->"Sample Preparation"
			},
			MasterMixStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>SampleStorageTypeP|Disposal,
				Description->"The non-default condition under which MasterMix of this experiment should be stored after the protocol is completed. If left unset, MasterMix will be stored according to their current StorageCondition.",
				Category->"Sample Storage"
			},
			BufferLink->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Sample],Object[Sample]],
				Description->"The solution for bringing each reaction to ReactionVolume once all the reaction components (template, primers, and master mix) are added.",
				Category->"Sample Preparation",
				Migration->SplitField
			},
			BufferString->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The solution for bringing each reaction to ReactionVolume once all the reaction components (template, primers, and master mix) are added.",
				Category->"Sample Preparation",
				Migration->SplitField
			},
			BufferLabel->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The label of the buffer sample that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"Sample Preparation"
			},
			BufferContainerLabel->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The label of the buffer container that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"Sample Preparation"
			},
			AssayPlateLink->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Container],Object[Container]],
				Description->"The output container that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"Sample Preparation",
				Migration->SplitField
			},
			AssayPlateString->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The output container that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"Sample Preparation",
				Migration->SplitField
			},
			AssayPlateLabel->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The label of the output container that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"Sample Preparation"
			},
			AssayPlateUnitOperations->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[UnitOperation],
				Description->"A set of instructions specifying the loading of the AssayContainers with the input samples,primers,then cover the AssayContainer.",
				Category->"Sample Preparation"
			},


			(*===Polymerase Activation===*)
			Activation->{
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if hot start activation is performed to remove the thermolabile conjugates inhibiting polymerase activity.",
				Category->"Polymerase Activation"
			},
			ActivationTime->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Second,
				Description->"The length of time for which the sample is held at ActivationTemperature to remove the thermolabile conjugates inhibiting polymerase activity.",
				Category->"Polymerase Activation"
			},
			ActivationTemperature->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"The temperature to which the sample is heated to remove the thermolabile conjugates inhibiting polymerase activity.",
				Category->"Polymerase Activation"
			},
			ActivationRampRate->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[(0 Celsius)/Second],
				Units->Celsius/Second,
				Description->"The rate at which the sample is heated to reach ActivationTemperature.",
				Category->"Polymerase Activation"
			},


			(*===Denaturation===*)
			DenaturationTime->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Second,
				Description->"The length of time for which the sample is held at DenaturationTemperature to allow the dissociation of the double stranded template into single strands.",
				Category->"Denaturation"
			},
			DenaturationTemperature->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"The temperature to which the sample is heated to allow the dissociation of the double stranded template into single strands.",
				Category->"Denaturation"
			},
			DenaturationRampRate->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[(0 Celsius)/Second],
				Units->Celsius/Second,
				Description->"The rate at which the sample is heated to reach DenaturationTemperature.",
				Category->"Denaturation"
			},


			(*===Primer Annealing===*)
			PrimerAnnealing->{
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if annealing is performed as a separate step instead of as part of extension to allow primers to bind to the template.",
				Category->"Primer Annealing"
			},
			PrimerAnnealingTime->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Second,
				Description->"The length of time for which the sample is held at PrimerAnnealingTemperature to allow primers to bind to the template.",
				Category->"Primer Annealing"
			},
			PrimerAnnealingTemperature->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"The temperature to which the sample is cooled to allow primers to bind to the template.",
				Category->"Primer Annealing"
			},
			PrimerAnnealingRampRate->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[(0 Celsius)/Second],
				Units->Celsius/Second,
				Description->"The rate at which the sample is cooled to reach PrimerAnnealingTemperature.",
				Category->"Primer Annealing"
			},


			(*===Strand Extension===*)
			ExtensionTime->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Second,
				Description->"The length of time for which sample is held at ExtensionTemperature to allow the polymerase to synthesize a new strand using the template and primers.",
				Category->"Strand Extension"
			},
			ExtensionTemperature->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"The temperature to which the sample is heated/cooled to allow the polymerase to synthesize a new strand using the template and primers.",
				Category->"Strand Extension"
			},
			ExtensionRampRate->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[(0 Celsius)/Second],
				Units->Celsius/Second,
				Description->"The rate at which the sample is heated/cooled to reach ExtensionTemperature.",
				Category->"Strand Extension"
			},


			(*===Cycling===*)
			NumberOfCycles->{
				Format->Single,
				Class->Integer,
				Pattern:>GreaterEqualP[0,1],
				Units->None,
				Description->"The number of times the sample undergoes repeated cycles of denaturation, primer annealing (optional), and strand extension.",
				Category->"Cycling"
			},


			(*===Final Extension===*)
			FinalExtension->{
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if final extension should be performed to fill in any incomplete products and/or obtain a poly-adenosine overhang on the 3' end of the product.",
				Category->"Final Extension"
			},
			FinalExtensionTime->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Second,
				Description->"The length of time for which the sample is held at FinalExtensionTemperature to fill in any incomplete products and/or obtain a poly-adenosine overhang on the 3' end of the product.",
				Category->"Final Extension"
			},
			FinalExtensionTemperature->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"The temperature to which the sample is heated/cooled to to fill in any incomplete products and/or obtain a poly-adenosine overhang on the 3' end of the product.",
				Category->"Final Extension"
			},
			FinalExtensionRampRate->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[(0 Celsius)/Second],
				Units->Celsius/Second,
				Description->"The rate at which the sample is heated/cooled to reach ActivationTemperature.",
				Category->"Final Extension"
			},


			(*===Infinite Hold===*)
			HoldTemperature->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"The temperature to which the sample is cooled and held after the thermocycling procedure.",
				Category->"Infinite Hold"
			},

			RunTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Second],
				Units -> Minute,
				Description -> "The length of time for which the instrument is expected to run given the specified parameters.",
				Category -> "General",
				Developer ->True
			}
		}
	}
];
