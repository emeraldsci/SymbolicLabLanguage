(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol,MagneticBeadSeparation],{
	Description->"A protocol for isolating targets from samples via magnetic bead separation, which uses a magnetic field to separate superparamagnetic particles from suspensions.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*===Method Information===*)
		SelectionStrategy->{
			Format->Single,
			Class->Expression,
			Pattern:>MagneticBeadSeparationSelectionStrategyP,
			Description->"Specified if the target analyte (Positive) or contaminants (Negative) binds to the magnetic beads in order to isolate the target analyte. When the target analyte is bound to the magnetic beads (Positive), they are collected as SamplesOut during the elution step. When contaminants are bound to the magnetic beads (Negative), the target analyte remains in the supernatant and is collected as SamplesOut during the loading step.",
			Category -> "General"
		},
		SeparationMode->{
			Format->Single,
			Class->Expression,
			Pattern:>MagneticBeadSeparationModeP,
			Description->"The mechanism used to selectively isolate or remove targeted components from the samples by magnetic beads. Options include NormalPhase, ReversePhase, IonExchange, Affinity. In NormalPhase mode, magnetic beads are coated with polar molecules (mainly pure silica) and the mobile phase less polar causing the adsorption of polar targeted components. In ReversePhase mode, magnetic beads are coated with hydrophobic groups on the surface to bind targeted components. In IonExchange mode, magnetic beads coated with ion-exchange groups ionically bind charged targeted components. In Affinity mode, magnetic beads are coated with functional groups that can covalently conjugate ligands on targeted components.",
			Category -> "General"
		},
		ProcessingOrder->{
			Format->Single,
			Class->Expression,
			Pattern:>MagneticBeadSeparationProcessingOrderP,
			Description->"The order for processing samples in the experiment. Parallel indicates all samples are processed at the same time in all steps of the experiment, can only be used if the samples are provided in a flat list. Serial indicates samples are processed sequentially such that all steps of the experiment are completed for a given sample before processing the next, can only be used if the samples are provided in a flat list. Batch indicates the input is a nested list and each sample group is fully processed (in parallel) before moving to the next, can only be used if the samples are provided in a nested list.",
			Category -> "General"
		},
		BatchLengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Units->None,
			Description->"The lengths used to unflatten nested index matched options.",
			Category->"General"
		},
		(* Index-Matching Fields (Match SamplesIn) *)
		Volumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the amount of sample that is added to the magnetic beads in order to allow binding of target analyte or contaminant to the magnetic beads after the magnetic beads are optionally prewashed and equilibrated.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		Targets->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Molecule],
			Description->"For each member of SamplesIn, the molecule or analyte that we aim to purify from the SamplesIn.",
			Category->"General",
			IndexMatching->SamplesIn
		},
		AnalyteAffinityLabels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Molecule],
			Description->"For each member of SamplesIn, the target molecule in the sample that binds the immobilized ligand on the magnetic beads for affinity separation, applicable if SeparationMode is set to Affinity. AnalyteAffinityLabel is used to help set automatic options such as MagneticBeadAffinityLabel.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		MagneticBeadAffinityLabels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Molecule],
			Description->"For each member of SamplesIn, the molecule immobilized on the magnetic beads that specifically binds the target analyte for affinity separation, applicable if SeparationMode is set to Affinity. MagneticBeadAffinityLabel is used to help set automatic options such as MagneticBeads.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		MagneticBeads->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of SamplesIn, the superparamagnetic particles with surface coatings to bind target analyte or contaminants. They exhibit magnetic behavior only in the presence of an external magnetic field. The magnetic beads are pulled to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the supernatant.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		MagneticBeadVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the volumetric amount of MagneticBeads that is added to the assay container prior to optional prewash and equilibration.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		MagnetizationRacks->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container,Rack],
				Object[Container,Rack],
				Model[Item,MagnetizationRack],
				Object[Item,MagnetizationRack]
			],
			Description->"For each member of SamplesIn, the magnetic rack used during magnetization that provides the magnetic force to attract the magnetic beads.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		AssayContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"For each member of SamplesIn, the container(s) that holds the samples during magnetization steps of the experiment.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		AssayWells->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of SamplesIn, the position(s) in the container to use for the experiment in which the transferred samples will be placed.",
			Category->"General",
			IndexMatching->SamplesIn
		},
		AssayUnitOperations->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP|SamplePreparationP,
			Description->"The set of instructions specifying the steps of the experiment.",
			Category -> "General"
		},
		AssayPreparation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation]|Object[Protocol,ManualSamplePreparation],
			Description->"The sample manipulation/preparation protocol generated as a result of the execution of AssayPrimitives.",
			Category -> "General"
		},

		(*===PreWash===*)
		PreWashes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the magnetic beads are rinsed prior to equilibration in order to remove the storage buffer.",
			Category->"PreWash",
			IndexMatching->SamplesIn
		},
		PreWashBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of SamplesIn, the solution used to rinse the magnetic beads in order to remove the storage buffer prior to equilibration.",
			Category->"PreWash",
			IndexMatching->SamplesIn
		},
		PreWashBufferVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, amount of PreWashBuffer that is added to the magnetic beads for each prewash prior to equilibration.",
			Category->"PreWash",
			IndexMatching->SamplesIn
		},
		PreWashMixes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, if the solution is mixed following combination of PreWashBuffer and the magnetic beads during each prewash.",
			Category->"PreWash",
			IndexMatching->SamplesIn
		},
		PreWashMixTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MixTypeP,
			Description->"For each member of SamplesIn, the style of motion used to mix the suspension following the addition of the PreWashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
			Category->"PreWash",
			IndexMatching->SamplesIn
		},
		PreWashMixTimes->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterP[0 Minute],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the duration during which the combined PreWashBuffer and magnetic beads are mixed.",
			Category->"PreWash"
		},
		PreWashMixRates->{
			Format->Multiple,
			Class->VariableUnit,
			Units->None,
			Pattern:>GreaterEqualP[0 RPM]|GreaterEqualP[0 GravitationalAcceleration],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the frequency of rotation used to mix the combined PreWashBuffer and magnetic beads.",
			Category->"PreWash"

		},
		NumberOfPreWashMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"For each member of SamplesIn, the number of times that the combined PreWashBuffer and magnetic beads are mixed if PreWashMixType is Pipette or Invert.",
			IndexMatching->SamplesIn,
			Category->"PreWash"

		},
		PreWashMixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the volume of the combined PreWashBuffer and magnetic beads that is pipetted up and down in order to mix, if PreWashMixType->Pipette.",
			IndexMatching->SamplesIn,
			Category->"PreWash"

		},
		PreWashMixTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Units->Celsius,
			Pattern :> GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature of the device that is used to mix/incubate the combined PreWashBuffer and magnetic beads.",
			Category->"PreWash"
		},
		PreWashMixTipTypes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TipTypeP,
			Description -> "For each member of SamplesIn, the type of pipette tips used to mix the combined PreWashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if PreWashMixType->Pipette.",
			Category->"PreWash",
			IndexMatching->SamplesIn
		},
		PreWashMixTipMaterials->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description->"For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the PreWashMix. This option can only be set if PreWashMixType->Pipette.",
			Category->"PreWash",
			IndexMatching->SamplesIn
		},
		PreWashMagnetizationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration of magnetizing the magnetic beads after PreWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used PreWashBuffer.",
			Category->"PreWash",
			IndexMatching->SamplesIn
		},
		PreWashAspirationVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each wash prior to equilibration.",
			Category->"PreWash",
			IndexMatching->SamplesIn
		},
		NumberOfPreWashes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Units->None,
			Description->"For each member of SamplesIn, the number of times that the magnetic beads are washed by adding PreWashBuffer, mixing, magnetization, and aspirating solution prior to equilibration.",
			Category->"PreWash",
			IndexMatching->SamplesIn
		},
		PreWashAirDries->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the magnetic beads are exposed to open air to evaporate the remaining PreWashBuffer following the final prewash prior to equilibration.",
			Category->"PreWash",
			IndexMatching->SamplesIn
		},
		PreWashAirDryTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration that the magnetic beads are exposed to open air to evaporate the remaining PreWashBuffer following the final prewash prior to equilibration.",
			Category->"PreWash",
			IndexMatching->SamplesIn
		},
		PreWashCollectionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The fully flattened container(s) for collecting the aspirated used PreWashBuffer during the prewash(es) prior to equilibration. By default, the same container is selected for the repeated washes (i.e. aspirated samples in the repeated washes will be combined) unless different container objects are specified for the prewashes prior to equilibration.",
			Category->"PreWash"
		},
		PreWashDestinationWells->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The fully flattened position(s) in the PreWash collection container in which the transferred samples will be placed.",
			Category->"PreWash"
		},

		(*===Equilibration===*)
		Equilibrations->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the magnetic beads are equilibrated to a condition for optimal bead-target binding prior to adding samples to the magnetic beads.",
			Category->"Equilibration",
			IndexMatching->SamplesIn
		},
		EquilibrationBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of SamplesIn, the solution used for equilibrating the magnetic beads to a condition for optimal bead-target binding prior to adding samples to the magnetic beads.",
			Category->"Equilibration",
			IndexMatching->SamplesIn
		},
		EquilibrationBufferVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the amount of EquilibrationBuffer to add to the magnetic beads for equilibration.",
			Category->"Equilibration",
			IndexMatching->SamplesIn
		},
		EquilibrationMixes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the solution is mixed following combination of EquilibrationBuffer and the magnetic beads.",
			Category->"Equilibration",
			IndexMatching->SamplesIn
		},
		EquilibrationMixTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MixTypeP,
			Description->"For each member of SamplesIn, the style of motion used to mix the suspension following the addition of the EquilibrationBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
			Category->"Equilibration",
			IndexMatching->SamplesIn
		},
		EquilibrationMixTimes->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterP[0 Minute],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the duration during which the combined EquilibrationBuffer and magnetic beads are mixed.",
			Category->"Equilibration"
		},
		EquilibrationMixRates->{
			Format->Multiple,
			Class->VariableUnit,
			Units->None,
			Pattern:>GreaterEqualP[0 RPM]|GreaterEqualP[0 GravitationalAcceleration],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the frequency of rotation used to mix the combined EquilibrationBuffer and magnetic beads.",
			Category->"Equilibration"
		},
		NumberOfEquilibrationMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"For each member of SamplesIn, the number of times that the combined EquilibrationBuffer and magnetic beads are mixed if EquilibrationMixType is Pipette or Invert.",
			IndexMatching->SamplesIn,
			Category->"Equilibration"
		},
		EquilibrationMixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the volume of the combined EquilibrationBuffer and magnetic beads that is pipetted up and down in order to mix, if EquilibrationMixType->Pipette.",
			IndexMatching->SamplesIn,
			Category->"Equilibration"
		},
		EquilibrationMixTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Units->Celsius,
			Pattern :>GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature of the device that is used to mix/incubate the combined EquilibrationBuffer and magnetic beads.",
			Category->"Equilibration"
		},
		EquilibrationMixTipTypes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TipTypeP,
			Description -> "For each member of SamplesIn, the type of pipette tips used to mix the combined EquilibrationBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if EquilibrationMixType->Pipette.",
			Category->"Equilibration",
			IndexMatching->SamplesIn
		},
		EquilibrationMixTipMaterials->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description->"For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the EquilibrationMix. This option can only be set if EquilibrationMixType->Pipette.",
			Category->"Equilibration",
			IndexMatching->SamplesIn
		},
		EquilibrationMagnetizationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration of magnetizing the magnetic beads after EquilibrationTime has elapsed in order to attract the magnetic beads to the side of the container by applying a magnetic force, thus enables removal or collection of the used EquilibrationBuffer.",
			Category->"Equilibration",
			IndexMatching->SamplesIn
		},
		EquilibrationAspirationVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during equilibration.",
			Category->"Equilibration",
			IndexMatching->SamplesIn
		},
		EquilibrationAirDries->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the magnetic beads are exposed to open air to evaporate the remaining EquilibrationBuffer before contact with the input sample.",
			Category->"Equilibration",
			IndexMatching->SamplesIn
		},
		EquilibrationAirDryTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration that the magnetic beads are exposed to open air to evaporate the remaining EquilibrationBuffer before contact with the input sample.",
			Category->"Equilibration",
			IndexMatching->SamplesIn
		},
		EquilibrationCollectionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The fully flattened container for collecting the aspirated used EquilibrationBuffer during the equilibration.",
			Category->"Equilibration"
		},
		EquilibrationDestinationWells->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The fully flattened position(s) in the Equilibration collection container in which the transferred samples will be placed.",
			Category->"Equilibration"
		},

		(*===Loading===*)

		LoadingMixes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the solution is mixed following the combination of the input sample and the magnetic beads.",
			Category->"Loading",
			IndexMatching->SamplesIn
		},
		LoadingMixTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MixTypeP,
			Description->"For each member of SamplesIn, the style of motion used to mix the suspension following the addition of the SamplesIn to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
			Category->"Loading",
			IndexMatching->SamplesIn
		},
		LoadingMixTimes->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterP[0 Minute],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the duration during which the combined SamplesIn and magnetic beads are mixed.",
			Category->"Loading"
		},
		LoadingMixRates->{
			Format->Multiple,
			Class->VariableUnit,
			Units->None,
			Pattern:>GreaterEqualP[0 RPM]|GreaterEqualP[0 GravitationalAcceleration],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the frequency of rotation used to mix the combined SamplesIn and magnetic beads.",
			Category->"Loading"
		},
		NumberOfLoadingMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"For each member of SamplesIn, the number of times that the combined SamplesIn and magnetic beads are mixed if LoadingMixType is Pipette or Invert.",
			IndexMatching->SamplesIn,
			Category->"Loading"
		},
		LoadingMixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the volume of the combined SamplesIn and magnetic beads that is pipetted up and down in order to mix, if LoadingMixType->Pipette.",
			IndexMatching->SamplesIn,
			Category->"Loading"
		},
		LoadingMixTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Units->Celsius,
			Pattern :> GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature of the device that is used to mix/incubate the combined SamplesIn and magnetic beads.",
			Category->"Loading"
		},
		LoadingMixTipTypes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TipTypeP,
			Description -> "For each member of SamplesIn, the type of pipette tips used to mix the combined sample and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if LoadingMixType->Pipette.",
			Category->"Loading",
			IndexMatching->SamplesIn
		},
		LoadingMixTipMaterials->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description->"For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the LoadingMix. This option can only be set if LoadingMixType->Pipette.",
			Category->"Loading",
			IndexMatching->SamplesIn
		},
		LoadingMagnetizationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration of magnetizing the magnetic beads after LoadingMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the sample solution containing components that are not bound to the magnetic beads.",
			Category->"Loading",
			IndexMatching->SamplesIn
		},
		LoadingAspirationVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the volume of sample solution to aspirate out while the magnetic beads are magnetized and gathered to the side.",
			Category->"Loading",
			IndexMatching->SamplesIn
		},
		LoadingCollectionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The fully flattened By default, the same container is selected for samples in the same pool (i.e. aspirated samples in the same pool will be combined) unless different container objects are specified for samples in the pool.",
			Category->"Loading"
		},
		LoadingDestinationWells->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The fully flattened position(s) in the Loading collection container in which the transferred samples will be placed.",
			Category->"Loading"
		},
		LoadingAirDries->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the magnetic beads are exposed to open air to evaporate the remaining solution of the sample after aspirating the supernatant.",
			Category->"Loading",
			IndexMatching->SamplesIn
		},
		LoadingAirDryTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration that the magnetic beads are exposed to open air to evaporate the remaining solution of the sample after aspirating the supernatant.",
			Category->"Loading",
			IndexMatching->SamplesIn
		},

		(*===Wash===*)

		(*--- PrimaryWash---*)

		Washes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicate if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SecondaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		WashBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of SamplesIn, the solution used to rinse the magnetic beads during Wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SecondaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		WashBufferVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the amount of WashBuffer that is added to the magnetic beads for each wash prior to elution or optional SecondaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		WashMixes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the solution is mixed following combination of WashBuffer and the magnetic beads during each wash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		WashMixTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MixTypeP,
			Description->"For each member of SamplesIn, the style of motion used to mix the suspension following the addition of the WashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		WashMixTimes->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterP[0 Minute],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the duration during which the combined WashBuffer and magnetic beads are mixed.",
			Category->"Wash"
		},
		WashMixRates->{
			Format->Multiple,
			Class->VariableUnit,
			Units->None,
			Pattern:>GreaterEqualP[0 RPM]|GreaterEqualP[0 GravitationalAcceleration],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the frequency of rotation used to mix the combined WashBuffer and magnetic beads.",
			Category->"Wash"
		},
		NumberOfWashMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"For each member of SamplesIn, the number of times that the combined WashBuffer and magnetic beads are mixed if WashMixType is Pipette or Invert.",
			IndexMatching->SamplesIn,
			Category->"Wash"
		},
		WashMixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the volume of the combined WashBuffer and magnetic beads that is pipetted up and down in order to mix, if WashMixType->Pipette.",
			IndexMatching->SamplesIn,
			Category->"Wash"
		},
		WashMixTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Units->Celsius,
			Pattern :> GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature of the device that is used to mix/incubate the combined WashBuffer and magnetic beads.",
			Category->"Wash"
		},
		WashMixTipTypes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TipTypeP,
			Description -> "For each member of SamplesIn, the type of pipette tips used to mix the combined WashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if WashMixType->Pipette.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		WashMixTipMaterials->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description->"For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the WashMix. This option can only be set if WashMixType->Pipette.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		WashMagnetizationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of NestedIndexMatchingSamplesIn, the duration of magnetizing the magnetic beads after WashTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used WashBuffer containing residual sample components that are not bound to the magnetic beads.",
			Category->"Wash",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		WashAspirationVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of NestedIndexMatchingSamplesIn, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each wash prior to elution or optional SecondaryWash.",
			Category->"Wash",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		WashCollectionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The fully flattened container(s) for collecting the aspirated sample(s) during the wash(es) prior to elution or optional SecondaryWash. By default, the same container is selected for the repeated washes (i.e. aspirated samples in the repeated washes will be combined) unless different container objects are specified for the washes.",
			Category->"Wash"
		},
		WashDestinationWells->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The fully flattened position(s) in the Wash collection container in which the transferred samples will be placed.",
			Category->"Wash"
		},
		NumberOfWashes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Units->None,
			Description->"For each member of SamplesIn, the number of times the magnetic beads are washed by adding WashBuffer, mixing, magnetization, and aspirating solution prior to elution or optional SecondaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		WashAirDries->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the magnetic beads are exposed to open air to evaporate the remaining WashBuffer following the final wash prior to elution or optional SecondaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		WashAirDryTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration that the magnetic beads are exposed to open air to evaporate the remaining WashBuffer following the final wash prior to elution or optional SecondaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		
		(*--- SecondaryWash---*)

		SecondaryWashes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicate if the magnetic beads with bound targets or contaminants are further rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional TertiaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SecondaryWashBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of SamplesIn, the solution used to rinse the magnetic beads during Wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional TertiaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SecondaryWashBufferVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the amount of SecondaryWashBuffer that is added to the magnetic beads for each wash prior to elution or optional TertiaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SecondaryWashMixes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the solution is mixed following combination of SecondaryWashBuffer and the magnetic beads during each secondary wash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SecondaryWashMixTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MixTypeP,
			Description->"For each member of SamplesIn, the style of motion used to mix the suspension following the addition of the SecondaryWashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SecondaryWashMixTimes->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterP[0 Minute],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the duration during which the combined SecondaryWashBuffer and magnetic beads are mixed.",
			Category->"Wash"
		},
		SecondaryWashMixRates->{
			Format->Multiple,
			Class->VariableUnit,
			Units->None,
			Pattern:>GreaterEqualP[0 RPM]|GreaterEqualP[0 GravitationalAcceleration],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the frequency of rotation used to mix the combined SecondaryWashBuffer and magnetic beads.",
			Category->"Wash"
		},
		NumberOfSecondaryWashMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"For each member of SamplesIn, the number of times that the combined SecondaryWashBuffer and magnetic beads are mixed if SecondaryWashMixType is Pipette or Invert.",
			IndexMatching->SamplesIn,
			Category->"Wash"
		},
		SecondaryWashMixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the volume of the combined SecondaryWashBuffer and magnetic beads that is pipetted up and down in order to mix, if SecondaryWashMixType->Pipette.",
			IndexMatching->SamplesIn,
			Category->"Wash"
		},
		SecondaryWashMixTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Units->Celsius,
			Pattern :> GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature of the device that is used to mix/incubate the combined SecondaryWashBuffer and magnetic beads.",
			Category->"Wash"
		},
		SecondaryWashMixTipTypes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TipTypeP,
			Description -> "For each member of SamplesIn, the type of pipette tips used to mix the combined SecondaryWashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if SecondaryWashMixType->Pipette.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SecondaryWashMixTipMaterials->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description->"For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the SecondaryWashMix. This option can only be set if SecondaryWashMixType->Pipette.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SecondaryWashMagnetizationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of NestedIndexMatchingSamplesIn, the duration of magnetizing the magnetic beads after SecondaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used SecondaryWashBuffer containing residual sample components that are not bound to the magnetic beads.",
			Category->"Wash",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		SecondaryWashAspirationVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of NestedIndexMatchingSamplesIn, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each secondary wash prior to elution or optional TertiaryWash.",
			Category->"Wash",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		SecondaryWashCollectionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The fully flattened container(s) for collecting the aspirated sample(s) during the secondary wash(es) prior to elution or optional TertiaryWash. By default, the same container is selected for the repeated secondary washes (i.e. aspirated samples in the repeated secondary washes will be combined) unless different container objects are specified for the secondary washes.",
			Category->"Wash"
		},
		SecondaryWashDestinationWells->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The fully flattened position(s) in the SecondaryWash collection container in which the transferred samples will be placed.",
			Category->"Wash"
		},
		NumberOfSecondaryWashes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Units->None,
			Description->"For each member of SamplesIn, the number of times the magnetic beads are washed by adding SecondaryWashBuffer, mixing, magnetization, and aspirating solution prior to elution or optional TertiaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SecondaryWashAirDries->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the magnetic beads are exposed to open air to evaporate the remaining SecondaryWashBuffer following the final secondary wash prior to elution or optional TertiaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SecondaryWashAirDryTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration that the magnetic beads are exposed to open air to evaporate the remaining SecondaryWashBuffer following the final secondary wash prior to elution or optional TertiaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},

		(*--- TertiaryWash---*)

		TertiaryWashes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicate if the magnetic beads with bound targets or contaminants are further rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional QuaternaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		TertiaryWashBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of SamplesIn, the solution used to rinse the magnetic beads during Wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional QuaternaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		TertiaryWashBufferVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the amount of TertiaryWashBuffer that is added to the magnetic beads for each wash prior to elution or optional QuaternaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		TertiaryWashMixes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the solution is mixed following combination of TertiaryWashBuffer and the magnetic beads during each tertiary wash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		TertiaryWashMixTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MixTypeP,
			Description->"For each member of SamplesIn, the style of motion used to mix the suspension following the addition of the TertiaryWashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		TertiaryWashMixTimes->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterP[0 Minute],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the duration during which the combined TertiaryWashBuffer and magnetic beads are mixed.",
			Category->"Wash"
		},
		TertiaryWashMixRates->{
			Format->Multiple,
			Class->VariableUnit,
			Units->None,
			Pattern:>GreaterEqualP[0 RPM]|GreaterEqualP[0 GravitationalAcceleration],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the frequency of rotation used to mix the combined TertiaryWashBuffer and magnetic beads.",
			Category->"Wash"
		},
		NumberOfTertiaryWashMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"For each member of SamplesIn, the number of times that the combined TertiaryWashBuffer and magnetic beads are mixed if TertiaryWashMixType is Pipette or Invert.",
			IndexMatching->SamplesIn,
			Category->"Wash"
		},
		TertiaryWashMixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the volume of the combined TertiaryWashBuffer and magnetic beads that is pipetted up and down in order to mix, if TertiaryWashMixType->Pipette.",
			IndexMatching->SamplesIn,
			Category->"Wash"
		},
		TertiaryWashMixTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Units->Celsius,
			Pattern :> GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature of the device that is used to mix/incubate the combined TertiaryWashBuffer and magnetic beads.",
			Category->"Wash"
		},
		TertiaryWashMixTipTypes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TipTypeP,
			Description -> "For each member of SamplesIn, the type of pipette tips used to mix the combined TertiaryWashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if TertiaryWashMixType->Pipette.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		TertiaryWashMixTipMaterials->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description->"For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the TertiaryWashMix. This option can only be set if TertiaryWashMixType->Pipette.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		TertiaryWashMagnetizationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of NestedIndexMatchingSamplesIn, the duration of magnetizing the magnetic beads after TertiaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used TertiaryWashBuffer containing residual sample components that are not bound to the magnetic beads.",
			Category->"Wash",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		TertiaryWashAspirationVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of NestedIndexMatchingSamplesIn, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each tertiary wash prior to elution or optional QuaternaryWash.",
			Category->"Wash",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		TertiaryWashCollectionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The fully flattened container(s) for collecting the aspirated sample(s) during the tertiary wash(es) prior to elution or optional QuaternaryWash. By default, the same container is selected for the repeated tertiary washes (i.e. aspirated samples in the repeated tertiary washes will be combined) unless different container objects are specified for the tertiary washes.",
			Category->"Wash"
		},
		TertiaryWashDestinationWells->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The fully flattened position(s) in the TertiaryWash collection container in which the transferred samples will be placed.",
			Category->"Wash"
		},
		NumberOfTertiaryWashes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Units->None,
			Description->"For each member of SamplesIn, the number of times the magnetic beads are washed by adding TertiaryWashBuffer, mixing, magnetization, and aspirating solution prior to elution or optional QuaternaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		TertiaryWashAirDries->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the magnetic beads are exposed to open air to evaporate the remaining TertiaryWashBuffer following the final tertiary wash prior to elution or optional QuaternaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		TertiaryWashAirDryTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration that the magnetic beads are exposed to open air to evaporate the remaining TertiaryWashBuffer following the final tertiary wash prior to elution or optional QuaternaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		
		(*--- QuaternaryWash---*)

		QuaternaryWashes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicate if the magnetic beads with bound targets or contaminants are further rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional QuinaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuaternaryWashBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of SamplesIn, the solution used to rinse the magnetic beads during Wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional QuinaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuaternaryWashBufferVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the amount of QuaternaryWashBuffer that is added to the magnetic beads for each wash prior to elution or optional QuinaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuaternaryWashMixes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the solution is mixed following combination of QuaternaryWashBuffer and the magnetic beads during each quaternary wash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuaternaryWashMixTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MixTypeP,
			Description->"For each member of SamplesIn, the style of motion used to mix the suspension following the addition of the QuaternaryWashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuaternaryWashMixTimes->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterP[0 Minute],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the duration during which the combined QuaternaryWashBuffer and magnetic beads are mixed.",
			Category->"Wash"
		},
		QuaternaryWashMixRates->{
			Format->Multiple,
			Class->VariableUnit,
			Units->None,
			Pattern:>GreaterEqualP[0 RPM]|GreaterEqualP[0 GravitationalAcceleration],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the frequency of rotation used to mix the combined QuaternaryWashBuffer and magnetic beads.",
			Category->"Wash"
		},
		NumberOfQuaternaryWashMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"For each member of SamplesIn, the number of times that the combined QuaternaryWashBuffer and magnetic beads are mixed if QuaternaryWashMixType is Pipette or Invert.",
			IndexMatching->SamplesIn,
			Category->"Wash"
		},
		QuaternaryWashMixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the volume of the combined QuaternaryWashBuffer and magnetic beads that is pipetted up and down in order to mix, if QuaternaryWashMixType->Pipette.",
			IndexMatching->SamplesIn,
			Category->"Wash"
		},
		QuaternaryWashMixTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Units->Celsius,
			Pattern :> GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature of the device that is used to mix/incubate the combined QuaternaryWashBuffer and magnetic beads.",
			Category->"Wash"
		},
		QuaternaryWashMixTipTypes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TipTypeP,
			Description -> "For each member of SamplesIn, the type of pipette tips used to mix the combined QuaternaryWashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if QuaternaryWashMixType->Pipette.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuaternaryWashMixTipMaterials->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description->"For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the QuaternaryWashMix. This option can only be set if QuaternaryWashMixType->Pipette.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuaternaryWashMagnetizationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of NestedIndexMatchingSamplesIn, the duration of magnetizing the magnetic beads after QuaternaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used QuaternaryWashBuffer containing residual sample components that are not bound to the magnetic beads.",
			Category->"Wash",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		QuaternaryWashAspirationVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of NestedIndexMatchingSamplesIn, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each quaternary wash prior to elution or optional QuinaryWash.",
			Category->"Wash",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		QuaternaryWashCollectionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The fully flattened container(s) for collecting the aspirated sample(s) during the quaternary wash(es) prior to elution or optional QuinaryWash. By default, the same container is selected for the repeated quaternary washes (i.e. aspirated samples in the repeated quaternary washes will be combined) unless different container objects are specified for the quaternary washes.",
			Category->"Wash"
		},
		QuaternaryWashDestinationWells->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The fully flattened position(s) in the QuaternaryWash collection container in which the transferred samples will be placed.",
			Category->"Wash"
		},
		NumberOfQuaternaryWashes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Units->None,
			Description->"For each member of SamplesIn, the number of times the magnetic beads are washed by adding QuaternaryWashBuffer, mixing, magnetization, and aspirating solution prior to elution or optional QuinaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuaternaryWashAirDries->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the magnetic beads are exposed to open air to evaporate the remaining QuaternaryWashBuffer following the final quaternary wash prior to elution or optional QuinaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuaternaryWashAirDryTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration that the magnetic beads are exposed to open air to evaporate the remaining QuaternaryWashBuffer following the final quaternary wash prior to elution or optional QuinaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},

		(*--- QuinaryWash---*)

		QuinaryWashes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicate if the magnetic beads with bound targets or contaminants are further rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SenaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuinaryWashBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of SamplesIn, the solution used to rinse the magnetic beads during Wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SenaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuinaryWashBufferVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the amount of QuinaryWashBuffer that is added to the magnetic beads for each wash prior to elution or optional SenaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuinaryWashMixes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the solution is mixed following combination of QuinaryWashBuffer and the magnetic beads during each quinary wash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuinaryWashMixTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MixTypeP,
			Description->"For each member of SamplesIn, the style of motion used to mix the suspension following the addition of the QuinaryWashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuinaryWashMixTimes->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterP[0 Minute],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the duration during which the combined QuinaryWashBuffer and magnetic beads are mixed.",
			Category->"Wash"
		},
		QuinaryWashMixRates->{
			Format->Multiple,
			Class->VariableUnit,
			Units->None,
			Pattern:>GreaterEqualP[0 RPM]|GreaterEqualP[0 GravitationalAcceleration],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the frequency of rotation used to mix the combined QuinaryWashBuffer and magnetic beads.",
			Category->"Wash"
		},
		NumberOfQuinaryWashMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"For each member of SamplesIn, the number of times that the combined QuinaryWashBuffer and magnetic beads are mixed if QuinaryWashMixType is Pipette or Invert.",
			IndexMatching->SamplesIn,
			Category->"Wash"
		},
		QuinaryWashMixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the volume of the combined QuinaryWashBuffer and magnetic beads that is pipetted up and down in order to mix, if QuinaryWashMixType->Pipette.",
			IndexMatching->SamplesIn,
			Category->"Wash"
		},
		QuinaryWashMixTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Units->Celsius,
			Pattern :> GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature of the device that is used to mix/incubate the combined QuinaryWashBuffer and magnetic beads.",
			Category->"Wash"
		},
		QuinaryWashMixTipTypes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TipTypeP,
			Description -> "For each member of SamplesIn, the type of pipette tips used to mix the combined QuinaryWashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if QuinaryWashMixType->Pipette.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuinaryWashMixTipMaterials->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description->"For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the QuinaryWashMix. This option can only be set if QuinaryWashMixType->Pipette.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuinaryWashMagnetizationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of NestedIndexMatchingSamplesIn, the duration of magnetizing the magnetic beads after QuinaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used QuinaryWashBuffer containing residual sample components that are not bound to the magnetic beads.",
			Category->"Wash",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		QuinaryWashAspirationVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of NestedIndexMatchingSamplesIn, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each quinary wash prior to elution or optional SenaryWash.",
			Category->"Wash",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		QuinaryWashCollectionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The fully flattened container(s) for collecting the aspirated sample(s) during the quinary wash(es) prior to elution or optional SenaryWash. By default, the same container is selected for the repeated quinary washes (i.e. aspirated samples in the repeated quinary washes will be combined) unless different container objects are specified for the quinary washes.",
			Category->"Wash"
		},
		QuinaryWashDestinationWells->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The fully flattened position(s) in the QuinaryWash collection container in which the transferred samples will be placed.",
			Category->"Wash"
		},
		NumberOfQuinaryWashes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Units->None,
			Description->"For each member of SamplesIn, the number of times the magnetic beads are washed by adding QuinaryWashBuffer, mixing, magnetization, and aspirating solution prior to elution or optional SenaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuinaryWashAirDries->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the magnetic beads are exposed to open air to evaporate the remaining QuinaryWashBuffer following the final quinary wash prior to elution or optional SenaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		QuinaryWashAirDryTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration that the magnetic beads are exposed to open air to evaporate the remaining QuinaryWashBuffer following the final quinary wash prior to elution or optional SenaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},

		(*--- SenaryWash---*)

		SenaryWashes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicate if the magnetic beads with bound targets or contaminants are further rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SeptenaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SenaryWashBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of SamplesIn, the solution used to rinse the magnetic beads during Wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SeptenaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SenaryWashBufferVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the amount of SenaryWashBuffer that is added to the magnetic beads for each wash prior to elution or optional SeptenaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SenaryWashMixes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the solution is mixed following combination of SenaryWashBuffer and the magnetic beads during each senary wash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SenaryWashMixTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MixTypeP,
			Description->"For each member of SamplesIn, the style of motion used to mix the suspension following the addition of the SenaryWashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SenaryWashMixTimes->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterP[0 Minute],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the duration during which the combined SenaryWashBuffer and magnetic beads are mixed.",
			Category->"Wash"
		},
		SenaryWashMixRates->{
			Format->Multiple,
			Class->VariableUnit,
			Units->None,
			Pattern:>GreaterEqualP[0 RPM]|GreaterEqualP[0 GravitationalAcceleration],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the frequency of rotation used to mix the combined SenaryWashBuffer and magnetic beads.",
			Category->"Wash"
		},
		NumberOfSenaryWashMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"For each member of SamplesIn, the number of times that the combined SenaryWashBuffer and magnetic beads are mixed if SenaryWashMixType is Pipette or Invert.",
			IndexMatching->SamplesIn,
			Category->"Wash"
		},
		SenaryWashMixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the volume of the combined SenaryWashBuffer and magnetic beads that is pipetted up and down in order to mix, if SenaryWashMixType->Pipette.",
			IndexMatching->SamplesIn,
			Category->"Wash"
		},
		SenaryWashMixTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Units->Celsius,
			Pattern :> GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature of the device that is used to mix/incubate the combined SenaryWashBuffer and magnetic beads.",
			Category->"Wash"
		},
		SenaryWashMixTipTypes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TipTypeP,
			Description -> "For each member of SamplesIn, the type of pipette tips used to mix the combined SenaryWashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if SenaryWashMixType->Pipette.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SenaryWashMixTipMaterials->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description->"For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the SenaryWashMix. This option can only be set if SenaryWashMixType->Pipette.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SenaryWashMagnetizationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of NestedIndexMatchingSamplesIn, the duration of magnetizing the magnetic beads after SenaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used SenaryWashBuffer containing residual sample components that are not bound to the magnetic beads.",
			Category->"Wash",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		SenaryWashAspirationVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of NestedIndexMatchingSamplesIn, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each senary wash prior to elution or optional SeptenaryWash.",
			Category->"Wash",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		SenaryWashCollectionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The fully flattened container(s) for collecting the aspirated sample(s) during the senary wash(es) prior to elution or optional SeptenaryWash. By default, the same container is selected for the repeated senary washes (i.e. aspirated samples in the repeated senary washes will be combined) unless different container objects are specified for the senary washes.",
			Category->"Wash"
		},
		SenaryWashDestinationWells->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The fully flattened position(s) in the SenaryWash collection container in which the transferred samples will be placed.",
			Category->"Wash"
		},
		NumberOfSenaryWashes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Units->None,
			Description->"For each member of SamplesIn, the number of times the magnetic beads are washed by adding SenaryWashBuffer, mixing, magnetization, and aspirating solution prior to elution or optional SeptenaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SenaryWashAirDries->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the magnetic beads are exposed to open air to evaporate the remaining SenaryWashBuffer following the final senary wash prior to elution or optional SeptenaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SenaryWashAirDryTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration that the magnetic beads are exposed to open air to evaporate the remaining SenaryWashBuffer following the final senary wash prior to elution or optional SeptenaryWash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},

		(*--- SeptenaryWash---*)

		SeptenaryWashes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicate if the magnetic beads with bound targets or contaminants are further rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SeptenaryWashBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of SamplesIn, the solution used to rinse the magnetic beads during Wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SeptenaryWashBufferVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the amount of SeptenaryWashBuffer that is added to the magnetic beads for each wash prior to elution.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SeptenaryWashMixes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the solution is mixed following combination of SeptenaryWashBuffer and the magnetic beads during each septenary wash.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SeptenaryWashMixTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MixTypeP,
			Description->"For each member of SamplesIn, the style of motion used to mix the suspension following the addition of the SeptenaryWashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SeptenaryWashMixTimes->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterP[0 Minute],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the duration during which the combined SeptenaryWashBuffer and magnetic beads are mixed.",
			Category->"Wash"
		},
		SeptenaryWashMixRates->{
			Format->Multiple,
			Class->VariableUnit,
			Units->None,
			Pattern:>GreaterEqualP[0 RPM]|GreaterEqualP[0 GravitationalAcceleration],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the frequency of rotation used to mix the combined SeptenaryWashBuffer and magnetic beads.",
			Category->"Wash"
		},
		NumberOfSeptenaryWashMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"For each member of SamplesIn, the number of times that the combined SeptenaryWashBuffer and magnetic beads are mixed if SeptenaryWashMixType is Pipette or Invert.",
			IndexMatching->SamplesIn,
			Category->"Wash"
		},
		SeptenaryWashMixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the volume of the combined SeptenaryWashBuffer and magnetic beads that is pipetted up and down in order to mix, if SeptenaryWashMixType->Pipette.",
			IndexMatching->SamplesIn,
			Category->"Wash"
		},
		SeptenaryWashMixTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Units->Celsius,
			Pattern :> GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature of the device that is used to mix/incubate the combined SeptenaryWashBuffer and magnetic beads.",
			Category->"Wash"
		},
		SeptenaryWashMixTipTypes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TipTypeP,
			Description -> "For each member of SamplesIn, the type of pipette tips used to mix the combined SeptenaryWashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if SeptenaryWashMixType->Pipette.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SeptenaryWashMixTipMaterials->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description->"For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the SeptenaryWashMix. This option can only be set if SeptenaryWashMixType->Pipette.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SeptenaryWashMagnetizationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of NestedIndexMatchingSamplesIn, the duration of magnetizing the magnetic beads after SeptenaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used SeptenaryWashBuffer containing residual sample components that are not bound to the magnetic beads.",
			Category->"Wash",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		SeptenaryWashAspirationVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of NestedIndexMatchingSamplesIn, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each septenary wash prior to elution.",
			Category->"Wash",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		SeptenaryWashCollectionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The fully flattened container(s) for collecting the aspirated sample(s) during the septenary wash(es) prior to elution. By default, the same container is selected for the repeated septenary washes (i.e. aspirated samples in the repeated septenary washes will be combined) unless different container objects are specified for the septenary washes.",
			Category->"Wash"
		},
		SeptenaryWashDestinationWells->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The fully flattened position(s) in the SeptenaryWash collection container in which the transferred samples will be placed.",
			Category->"Wash"
		},
		NumberOfSeptenaryWashes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Units->None,
			Description->"For each member of SamplesIn, the number of times the magnetic beads are washed by adding SeptenaryWashBuffer, mixing, magnetization, and aspirating solution prior to elution.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SeptenaryWashAirDries->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the magnetic beads are exposed to open air to evaporate the remaining SeptenaryWashBuffer following the final septenary wash prior to elution.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},
		SeptenaryWashAirDryTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration that the magnetic beads are exposed to open air to evaporate the remaining SeptenaryWashBuffer following the final septenary wash prior to elution.",
			Category->"Wash",
			IndexMatching->SamplesIn
		},

		(*===Elution===*)
		Elutions->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the magnetic beads are rinsed in a different buffer condition in order to release the components bound to the magnetic beads.",
			Category->"Elution",
			IndexMatching->SamplesIn
		},
		ElutionBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of SamplesIn, the solution used to rinse the magnetic beads, providing a buffer condition in order to release the components bound to the magnetic beads.",
			Category->"Elution",
			IndexMatching->SamplesIn
		},
		ElutionBufferVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the amount of ElutionBuffer that is added to the magnetic beads for each elution.",
			Category->"Elution",
			IndexMatching->SamplesIn
		},
		ElutionMixes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the solution is mixed following combination of ElutionBuffer and the magnetic beads during each elution.",
			Category->"Elution",
			IndexMatching->SamplesIn
		},
		ElutionMixTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MixTypeP,
			Description->"For each member of SamplesIn, the style of motion used to mix the suspension following the addition of the ElutionBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
			Category->"Elution",
			IndexMatching->SamplesIn
		},
		ElutionMixTimes->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterEqualP[0 Minute],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the duration during which the combined ElutionBuffer and magnetic beads are mixed.",
			Category->"Elution"
		},
		ElutionMixRates->{
			Format->Multiple,
			Class->VariableUnit,
			Units->None,
			Pattern:>GreaterEqualP[0 RPM]|GreaterEqualP[0 GravitationalAcceleration],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the frequency of rotation used to mix the combined ElutionBuffer and magnetic beads.",
			Category->"Elution"
		},
		NumberOfElutionMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"For each member of SamplesIn, the number of times that the combined ElutionBuffer and magnetic beads are mixed if ElutionMixType is Pipette or Invert.",
			IndexMatching->SamplesIn,
			Category->"Elution"
		},
		ElutionMixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the volume of the combined ElutionBuffer and magnetic beads that is pipetted up and down in order to mix, if ElutionMixType->Pipette.",
			IndexMatching->SamplesIn,
			Category->"Elution"
		},
		ElutionMixTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Units->Celsius,
			Pattern :>GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature of the device that is used to mix/incubate the combined ElutionBuffer and magnetic beads.",
			Category->"Elution"
		},
		ElutionMixTipTypes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TipTypeP,
			Description -> "For each member of SamplesIn, the type of pipette tips used to mix the combined ElutionBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if ElutionMixType->Pipette.",
			Category->"Elution",
			IndexMatching->SamplesIn
		},
		ElutionMixTipMaterials->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description->"For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the ElutionMix. This option can only be set if ElutionMixType->Pipette.",
			Category->"Elution",
			IndexMatching->SamplesIn
		},
		ElutionMagnetizationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration of magnetizing the magnetic beads after ElutionMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the ElutionBuffer containing sample components released from the magnetic beads.",
			Category->"Elution",
			IndexMatching->SamplesIn
		},
		ElutionAspirationVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the amount of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each elution.",
			Category->"Elution",
			IndexMatching->SamplesIn
		},
		ElutionCollectionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The fully flattened container(s) for collecting the aspirated sample(s) during elution(s). By default, the same container is selected for the repeated elutions (i.e. aspirated samples in the repeated elutions will be combined) unless different container objects are specified for the elutions.",
			Category->"Elution"
		},
		ElutionDestinationWells->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The fully flattened position(s) in the Elution collection container in which the transferred samples will be placed.",
			Category->"Elution"
		},
		NumberOfElutions->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Units->None,
			Description->"For each member of SamplesIn, the number of times the bound components on the magnetic beads are eluted by adding ElutionBuffer, mixing, magnetization, and aspirating solution.",
			Category->"Elution",
			IndexMatching->SamplesIn
		},

		(*===Sample Storage===*)
		MagneticBeadCollectionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
			Description->"For each member of SamplesIn, the non-default condition under which the used magnetic beads are stored after the protocol is completed.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		PreWashCollectionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
			Description->"For each member of SamplesIn, the non-default condition under which the aspirated samples during prewash prior to equilibration are stored after the protocol is completed.",
			Category->"Sample Post-Processing",
			IndexMatching->SamplesIn
		},
		EquilibrationCollectionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
			Description->"For each member of SamplesIn, the non-default condition under which the aspirated samples during the equilibration are stored after the protocol is completed.",
			Category->"Sample Post-Processing",
			IndexMatching->SamplesIn
		},
		LoadingCollectionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
			Description->"For each member of SamplesIn, the non-default condition under which the aspirated samples during loading are stored after the protocol is completed.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		WashCollectionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
			Description->"For each member of SamplesIn, the non-default condition under which the aspirated samples during the wash prior to elution or optional SecondaryWash are stored after the protocol is completed.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		SecondaryWashCollectionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
			Description->"For each member of SamplesIn, the non-default condition under which the aspirated samples during the wash prior to elution are stored after the protocol is completed.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		TertiaryWashCollectionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
			Description->"For each member of SamplesIn, the non-default condition under which the aspirated samples during the wash prior to elution or optional QuaternaryWash are stored after the protocol is completed.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		QuaternaryWashCollectionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
			Relation->Model[StorageCondition],
			Description->"For each member of SamplesIn, the non-default condition under which the aspirated samples during the wash prior to elution or optional QuinaryWash are stored after the protocol is completed.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		QuinaryWashCollectionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
			Description->"For each member of SamplesIn, the non-default condition under which the aspirated samples during the wash prior to elution or optional SenaryWash are stored after the protocol is completed.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		SenaryWashCollectionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
			Description->"For each member of SamplesIn, the non-default condition under which the aspirated samples during the wash prior to elution or optional SeptenaryWash are stored after the protocol is completed.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		SeptenaryWashCollectionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
			Description->"For each member of SamplesIn, the non-default condition under which the aspirated samples during the wash prior to elution after the protocol is completed.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		ElutionCollectionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
			Description->"For each member of SamplesIn, the non-default condition under which the aspirated samples during elution are stored after the protocol is completed.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		}
	}
}];