(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,PCR],{
	Description->"A protocol for amplifying target nucleic acid sequences using polymerase chain reaction (PCR).",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*===Method Information===*)
		Instrument->{
		  Format->Single,
		  Class->Link,
		  Pattern:>_Link,
		  Relation->Alternatives[Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]],
		  Description->"The thermocycling instrument for performing polymerase chain reaction (PCR).",
		  Category -> "General"
		},
		MethodFilePath->{
		  Format->Single,
		  Class->String,
		  Pattern:>FilePathP,
		  Description->"The file path of the folder containing the protocol file with the run parameters.",
		  Category -> "General",
		  Developer->True
		},
		MethodFileName->{
		  Format->Single,
		  Class->String,
		  Pattern:>FilePathP,
		  Description->"The name of the protocol file with the run parameters.",
		  Category -> "General",
		  Developer->True
		},
		RunTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Minute,
			Description->"The length of time for which the thermocycler is expected to run, given the specified parameters.",
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
		ReactionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"The total volume of the reaction including the template, primers, master mix, and buffer.",
			Category->"Sample Preparation"
		},
		SampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the volume of the sample added to the reaction.",
			Category->"Sample Preparation",
			IndexMatching->SamplesIn
		},
		ForwardPrimers->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{_Link..|Null},
			Description->"For each member of SamplesIn, the list of primers that bind the target sequences on the antisense strand of the template.",
			Category->"Sample Preparation",
			IndexMatching->SamplesIn
		},
		ForwardPrimerResources->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The flattened list of primers that bind the target sequences on the antisense strand of the templates.",
			Category->"Sample Preparation",
			Developer->True
		},
		ForwardPrimerVolumes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{GreaterEqualP[0 Microliter]..},
			Description->"For each member of SamplesIn, the list of forward primer volumes added to the reaction that corresponds to the list of forward primers specified for the sample.",
			Category->"Sample Preparation",
			IndexMatching->SamplesIn
		},
		ForwardPrimerStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{(SampleStorageTypeP|Disposal)..},
			Description->"For each member of SamplesIn, the storage conditions under which ForwardPrimers should be stored after their usage in the experiment.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		ReversePrimers->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{_Link..|Null},
			Description->"For each member of SamplesIn, the list of primers that bind the target sequences on the sense strand of the template.",
			Category->"Sample Preparation",
			IndexMatching->SamplesIn
		},
		ReversePrimerResources->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The flattened list of primers that bind the target sequences on the sense strand of the templates.",
			Category->"Sample Preparation",
			Developer->True
		},
		ReversePrimerVolumes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{GreaterEqualP[0 Microliter]..},
			Description->"For each member of SamplesIn, the list of reverse primer volumes added to the reaction that corresponds to the list of reverse primers specified for the sample.",
			Category->"Sample Preparation",
			IndexMatching->SamplesIn
		},
		ReversePrimerStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{(SampleStorageTypeP|Disposal)..},
			Description->"For each member of SamplesIn, the storage conditions under which ReversePrimers should be stored after their usage in the experiment.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		PreparedPlate -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the input sample is already prepared and is used as is without adding buffer or master mix.",
			Category -> "Sample Preparation"
		},
		MasterMix->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The stock solution composed of the polymerase, nucleotides, and buffer for amplifying the target sequences.",
			Category->"Sample Preparation"
		},
		MasterMixVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"The volume of master mix added to the reaction.",
			Category->"Sample Preparation"
		},
		MasterMixStorageCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"The storage condition under which MasterMix should be stored after its usage in the experiment.",
			Category->"Sample Storage"
		},
		Buffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The solution for bringing each reaction to ReactionVolume once all the reaction components (template, primers, and master mix) are added.",
			Category->"Sample Preparation"
		},
		BufferVolumes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>GreaterEqualP[0 Microliter]|{GreaterEqualP[0 Microliter]..},
			Description->"For each member of SamplesIn, the volume of buffer added to bring the sample volume up to ReactionVolume.",
			Category->"Sample Preparation",
			IndexMatching->SamplesIn
		},


		(*===Sample Loading===*)
		AssayPlate->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The plate that is loaded with input samples, primers, master mix, and buffer, then inserted into the instrument.",
			Category->"Sample Loading"
		},
		AssayPlatePrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP|SamplePreparationP,
			Description->"The set of instructions specifying the loading of AssayPlate with input samples, primers, master mix, and buffer.",
			Category->"Sample Loading"
		},
		AssayPlateManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation]|Object[Protocol,RoboticSamplePreparation],
			Description->"The sample manipulation protocol generated as a result of the execution of AssayPlatePrimitives, which is used to load AssayPlate with input samples, primers, master mix, and buffer.",
			Category->"Sample Loading"
		},
		PlateSeal->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item],Object[Item]],
			Description->"The self-adhesive seal used to cover AssayPlate during the experiment.",
			Category->"Sample Loading"
		},


		(*===Polymerase Activation===*)
		Activation->{
			Format->Single,
			Class->Expression,
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
			Class->Expression,
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
			Class->Expression,
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
		}
	}
}];
