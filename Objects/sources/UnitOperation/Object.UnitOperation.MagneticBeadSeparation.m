(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation,MagneticBeadSeparation],
	{
		Description->"A detailed set of parameters that specifies the information on how to isolate sample via magnetic bead separation.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			(*---input fields---*)
			Sample->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{(ObjectP[{Object[Sample],Object[Container],Model[Sample],Model[Container]}]|_String)..},
				Description->"The sample to be isolated via magnetic bead separation.",
				Category->"General",
				Migration->NMultiple
			},
			SampleResources->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Object[Sample],
					Object[Container],
					Model[Sample],
					Model[Container]
				],
				Description->"Samples to be isolated via magnetic bead separation. This is the flattened version of Samples that is used to store sample resources.",
				Category->"General",
				Developer->True
			},
			SampleLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{(_String|Null)..},
				Description->"For each member of Sample, the label of the sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SampleContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{(_String|Null)..},
				Description->"For each member of Sample, the label of the sample's container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},

			(* ---non-index matching--- *)
			SelectionStrategy->{
				Format->Single,
				Class->Expression,
				Pattern:>MagneticBeadSeparationSelectionStrategyP,
				Description->"Specified if the target analyte (Positive) or contaminants (Negative) binds to the magnetic beads in order to isolate the target analyte. When the target analyte is bound to the magnetic beads (Positive), they are collected as SamplesOut during the elution step. When contaminants are bound to the magnetic beads (Negative), the target analyte remains in the supernatant and is collected as SamplesOut during the loading step.",
				Category->"General"
			},
			SeparationMode->{
				Format->Single,
				Class->Expression,
				Pattern:>MagneticBeadSeparationModeP,
				Description->"The mechanism used to selectively isolate or remove targeted components from the samples by magnetic beads. Options include NormalPhase, ReversePhase, IonExchange, Affinity. In NormalPhase mode, magnetic beads are coated with polar molecules (mainly pure silica) and the mobile phase less polar causing the adsorption of polar targeted components. In ReversePhase mode, magnetic beads are coated with hydrophobic groups on the surface to bind targeted components. In IonExchange mode, magnetic beads coated with ion-exchange groups ionically bind charged targeted components. In Affinity mode, magnetic beads are coated with functional groups that can covalently conjugate ligands on targeted components.",
				Category->"General"
			},
			ProcessingOrder->{
				Format->Single,
				Class->Expression,
				Pattern:>MagneticBeadSeparationProcessingOrderP,
				Description->"The order for processing samples in the experiment. Parallel indicates all samples are processed at the same time in all steps of the experiment, can only be used if the samples are provided in a flat list. Serial indicates samples are processed sequentially such that all steps of the experiment are completed for a given sample before processing the next, can only be used if the samples are provided in a flat list. Batch indicates the input is a nested list and each sample group is fully processed (in parallel) before moving to the next, can only be used if the samples are provided in a nested list.",
				Category->"General"
			},

			(* ---nested index matching---*)
			(* Volume option is NestedIndexMatching->True *)
			Volume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{(GreaterEqualP[1 Microliter]|Null|All)..},
				Description->"For each member of Sample, the amount of sample that is added to the magnetic beads in order to allow binding of target analyte or contaminant to the magnetic beads after the magnetic beads are optionally prewashed and equilibrated.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			Target->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[Model[Molecule]],Null]],
				Description->"For each member of Sample, the molecule or analyte that we aim to purify from the SamplesIn.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SampleOutLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{(_String|Null)..}|Null],
				Description->"For each member of Sample, the labels of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			ContainerOutLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[_String,Null]..}|Null],
				Description->"For each member of Sample, the label of the container of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			LoadingCollectionSample->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Sample],
				Description->"For each member of Sample, the sample collected by aspiration while the magnetic beads are magnetized and gathered to the side during loading. When SelectionStrategy->Negative, contaminants are bound to the magnetic beads, the target analyte remains in the supernatant and is collected as LoadingCollectionSample.",
				Category->"General",
				IndexMatching->Sample
			},
			ElutionCollectionSample->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[Object[Sample]],Null]],
				Description->"For each member of Sample, the samples collected by aspiration while the magnetic beads are magnetized and gathered to the side during elution. When SelectionStrategy->Positive, the target analyte is bound to the magnetic beads and is collected as ElutionCollectionSample.",
				Category->"General",
				IndexMatching->Sample
			},
			AnalyteAffinityLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[Model[Molecule]],Null]],
				Description->"For each member of Sample, the target molecule in the sample that binds the immobilized ligand on the magnetic beads for affinity separation, applicable if SeparationMode is set to Affinity. AnalyteAffinityLabel is used to help set automatic options such as MagneticBeadAffinityLabel.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			MagneticBeadAffinityLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[Model[Molecule]],Null]],
				Description->"For each member of Sample, the molecule immobilized on the magnetic beads that specifically binds the target analyte for affinity separation, applicable if SeparationMode is set to Affinity. MagneticBeadAffinityLabel is used to help set automatic options such as MagneticBeads.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			MagneticBeadsLink->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[{Model[Sample],Object[Sample]}],Null]],
				Description->"For each member of Sample, the superparamagnetic particles with surface coatings to bind target analyte or contaminants. They exhibit magnetic behavior only in the presence of an external magnetic field. The magnetic beads are pulled to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the supernatant.",
				Category->"General",
				IndexMatching->Sample,
				Migration->SplitField
			},
			MagneticBeadsString->{
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Description->"For each member of Sample, the superparamagnetic particles with surface coatings to bind target analyte or contaminants. They exhibit magnetic behavior only in the presence of an external magnetic field. The magnetic beads are pulled to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the supernatant.",
				Category->"General",
				IndexMatching->Sample,
				Migration->SplitField
			},
			MagneticBeadVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[1 Microliter],Null]],
				Description->"For each member of Sample, the volumetric amount of MagneticBeads that is added to the assay container prior to optional prewash and equilibration.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			MagneticBeadCollectionStorageConditionExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[SampleStorageTypeP,Disposal,Null]],
				Description->"For each member of Sample, the non-default condition under which the used magnetic beads should be stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration -> SplitField
			},
			MagneticBeadCollectionStorageConditionLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[StorageCondition]],
				Description->"For each member of Sample, the non-default condition under which the used magnetic beads should be stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration -> SplitField
			},
			MagnetizationRack->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[
					ObjectP[{
						Model[Container,Rack],
						Object[Container,Rack],
						Model[Item,MagnetizationRack],
						Object[Item,MagnetizationRack]
					}],
					Null
				]],
				Description->"For each member of Sample, the magnetic rack used during magnetization that provides the magnetic force to attract the magnetic beads.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},

			(*===PreWash===*)
			PreWash->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[Null,BooleanP]],
				Description->"For each member of Sample, indicates if the magnetic beads are rinsed prior to equilibration in order to remove the storage buffer.",
				Category->"PreWash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			PreWashBufferLink->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[{Model[Sample],Object[Sample]}],Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads prior to equilibration.",
				Category->"PreWash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			PreWashBufferString->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads prior to equilibration.",
				Category->"PreWash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			PreWashBufferVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[1 Microliter],Null]],
				Description->"For each member of Sample, the amount of PreWashBuffer that is added to the magnetic beads for each prewash prior to equilibration.",
				Category->"PreWash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			PreWashMix->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the solution is mixed following the combination of PreWashBuffer and the magnetic beads during the each prewash.",
				Category->"PreWash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			PreWashMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MixTypeP,Null]],
				Description->"For each member of Sample, the style of motion used to mix the suspension following the addition of the PreWashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
				Category->"PreWash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			PreWashMixTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the duration of time during which the combined PreWashBuffer and the magnetic beads are mixed.",
				Category->"PreWash",
				Migration->NMultiple
			},
			PreWashMixRate->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 RPM],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the frequency of rotation used to mix the combined PreWashBuffer and the magnetic beads.",
				Category->"PreWash",
				Migration->NMultiple
			},
			NumberOfPreWashMixes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the combined PreWashBuffer and magnetic beads are mixed if PreWashMixType is Pipette or Invert.",
				IndexMatching->Sample,
				Category->"PreWash",
				Migration->NMultiple
			},
			PreWashMixVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 Microliter],Null]],
				Description->"For each member of Sample, the volume of the combined PreWashBuffer and magnetic beads that is pipetted up and down in order to mix, if PreWashMixType->Pipette.",
				IndexMatching->Sample,
				Category->"PreWash",
				Migration->NMultiple
			},
			PreWashMixTemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Units->Celsius,
				Pattern :> GreaterEqualP[0 Kelvin],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined PreWashBuffer and magnetic beads.",
				Category->"PreWash",
				Migration -> SplitField
			},
			PreWashMixTemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[Ambient,Null,GreaterEqualP[0 Kelvin]]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined PreWashBuffer and magnetic beads.",
				Category->"PreWash",
				Migration -> SplitField
			},
			PreWashMixTipType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[TipTypeP,Null]],
				Description->"For each member of Sample, the type of pipette tips used to mix the combined PreWashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if PreWashMixType->Pipette.",
				Category->"PreWash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			PreWashMixTipMaterial->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MaterialP,Null]],
				Description->"For each member of Sample, For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the PreWashMix. This option can only be set if PreWashMixType->Pipette.",
				Category->"PreWash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			PreWashMagnetizationTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration of magnetizing the magnetic beads after PreWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used PreWashBuffer.",
				Category->"PreWash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			PreWashAspirationVolumeReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1 Microliter],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each wash prior to equilibration.",
				Category->"PreWash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			PreWashAspirationVolumeExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[ListableP[Alternatives[All,Null]],{GreaterEqualP[1 Microliter]..}],
				Description->"For each member of Sample, the volume to aspirate during the wash prior to equilibration.",
				Category->"PreWash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			PreWashAspirationPosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> ListableP[Alternatives[MagneticBeadSeparationPipettingPositionP,Null]],
				Description -> "For each member of Sample, the location from which the solution is aspirated after PreWashMagnetizationTime. Top will aspirate PreWashAspirationPositionOffset below the Top of the container, Bottom will aspirate PreWashAspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate PreWashAspirationPositionOffset below the liquid level of the sample in the container.",
				IndexMatching->Sample,
				Category -> "PreWash"
			},
			PreWashAspirationPositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[GreaterEqualP[0 Millimeter],Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],Null]],
				Description -> "For each member of Sample, the distance from the center of the well that the solution is aspirated after PreWashMagnetizationTime. The Z Offset is based on the PreWashAspirationPosition option -- measured as the height below the top of the well (Top), the height above the bottom of the well (Bottom), or the height below the detected liquid level (LiquidLevel). Please refer to the AspirationPosition diagram in the help file of ExperimentTransfer for more information. If an X and Y offset is not specified, the liquid will be aspirated in the center of the well, otherwise, -X/+X values will shift the position left and right, respectively, and -Y/+Y values will shift the position down and up, respectively.",
				IndexMatching->Sample,
				Category -> "PreWash"
			},
			PreWashCollectionContainer->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[
					ObjectP[Model[Container]],
					ObjectP[Object[Container]],
					{_Integer,ObjectP[Model[Container]]},
					{_String,ObjectP[Model[Container]]},
					{_String,{_Integer,ObjectP[Model[Container]]}},
					_String,Null],3],
				Description->"For each member of Sample, the container(s) for collecting the aspirated sample(s) during the wash(es) prior to equilibration. By default, the same container is selected for the repeated washes (i.e. aspirated samples in the repeated washes will be combined) unless different container objects are specified for the washes.",
				Category->"PreWash",
				IndexMatching->Sample
			},
			PreWashDestinationWell->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null],3],
				Developer->True,
				Description->"For each member of Sample, the destination well in the PreWashCollectionContainer that the collected used PreWashBuffer goes to.",
				Category->"PreWash",
				IndexMatching->Sample
			},
			PreWashCollectionContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[_String,Null]..}|Null],
				Description->"For each member of Sample, the label of the container used for collecting the aspirated sample(s) during the wash(es) prior to equilibration.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			PreWashCollectionStorageConditionExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[SampleStorageTypeP,Disposal,Null]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the wash prior to equilibration should be stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			PreWashCollectionStorageConditionLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Pattern:>Alternatives[Model[StorageCondition]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the wash prior to equilibration should be stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			NumberOfPreWashes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the magnetic beads are washed by adding PreWashBuffer, mixing, magnetization, and aspirating solution prior to equilibration.",
				Category->"PreWash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			PreWashAirDry->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the magnetic beads are exposed to open air to evaporate the remaining PreWashBuffer following the final prewash prior to equilibration.",
				Category->"PreWash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			PreWashAirDryTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration that the magnetic beads are exposed to open air to evaporate the remaining PreWashBuffer following the final prewash prior to equilibration.",
				Category->"PreWash",
				IndexMatching->Sample,
				Migration->NMultiple
			},

			(*===Equilibration===*)
			Equilibration->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[Null,BooleanP]],
				Description->"For each member of Sample, indicates if  the magnetic beads are equilibrated to a condition for optimal bead-target binding prior to adding samples to the magnetic beads.",
				Category->"Equilibration",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			EquilibrationBufferLink->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[{Model[Sample],Object[Sample]}],Null]],
				Description->"For each member of Sample, the solution used for equilibrating the magnetic beads to a condition for optimal bead-target binding prior to adding samples to the magnetic beads.",
				Category->"Equilibration",
				IndexMatching->Sample,
				Migration->SplitField
			},
			EquilibrationBufferString->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null]],
				Description->"For each member of Sample, the solution used for equilibrating the magnetic beads to a condition for optimal bead-target binding prior to adding samples to the magnetic beads.",
				Category->"Equilibration",
				IndexMatching->Sample,
				Migration->SplitField
			},
			EquilibrationBufferVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[1 Microliter],Null]],
				Description->"For each member of Sample, the amount of EquilibrationBuffer to add to the magnetic beads for equilibration.",
				Category->"Equilibration",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			EquilibrationMix->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the solution is mixed following the combination of EquilibrationBuffer and the magnetic beads during the each equilibration.",
				Category->"Equilibration",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			EquilibrationMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MixTypeP,Null]],
				Description->"For each member of Sample, the style of motion used to mix the suspension following the addition of the EquilibrationBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
				Category->"Equilibration",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			EquilibrationMixTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the duration of time during which the combined EquilibrationBuffer and the magnetic beads are mixed.",
				Category->"Equilibration",
				Migration->NMultiple
			},
			EquilibrationMixRate->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 RPM],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the frequency of rotation used to mix the combined EquilibrationBuffer and the magnetic beads.",
				Category->"Equilibration",
				Migration->NMultiple
			},
			NumberOfEquilibrationMixes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the combined EquilibrationBuffer and magnetic beads are mixed if EquilibrationMixType is Pipette or Invert.",
				IndexMatching->Sample,
				Category->"Equilibration",
				Migration->NMultiple
			},
			EquilibrationMixVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 Microliter],Null]],
				Description->"For each member of Sample, the volume of the combined EquilibrationBuffer and magnetic beads that is pipetted up and down in order to mix, if EquilibrationMixType->Pipette.",
				IndexMatching->Sample,
				Category->"Equilibration",
				Migration->NMultiple
			},
			EquilibrationMixTemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Units->Celsius,
				Pattern :> GreaterEqualP[0 Kelvin],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined EquilibrationBuffer and magnetic beads.",
				Category->"Equilibration",
				Migration -> SplitField
			},
			EquilibrationMixTemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[Ambient,Null,GreaterEqualP[0 Kelvin]]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined EquilibrationBuffer and magnetic beads.",
				Category->"Equilibration",
				Migration -> SplitField
			},
			EquilibrationMixTipType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[TipTypeP,Null]],
				Description->"For each member of Sample, the type of pipette tips used to mix the combined EquilibrationBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if EquilibrationMixType->Pipette.",
				Category->"Equilibration",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			EquilibrationMixTipMaterial->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MaterialP,Null]],
				Description->"For each member of Sample, For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the EquilibrationMix. This option can only be set if EquilibrationMixType->Pipette.",
				Category->"Equilibration",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			EquilibrationMagnetizationTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration of magnetizing the magnetic beads after EquilibrationMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used EquilibrationBuffer.",
				Category->"Equilibration",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			EquilibrationAspirationVolumeReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1 Microliter],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each wash prior to adding samples to the magnetic beads.",
				Category->"Equilibration",
				IndexMatching->Sample,
				Migration->SplitField
			},
			EquilibrationAspirationVolumeExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[ListableP[Alternatives[All,Null]],{GreaterEqualP[1 Microliter]..}],
				Description->"For each member of Sample, the volume to aspirate during the wash prior to adding samples to the magnetic beads.",
				Category->"Equilibration",
				IndexMatching->Sample,
				Migration->SplitField
			},
			EquilibrationAspirationPosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> ListableP[Alternatives[MagneticBeadSeparationPipettingPositionP,Null]],
				Description -> "For each member of Sample, the location from which the solution is aspirated after EquilibrationMagnetizationTime. Top will aspirate EquilibrationAspirationPositionOffset below the Top of the container, Bottom will aspirate EquilibrationAspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate EquilibrationAspirationPositionOffset below the liquid level of the sample in the container.",
				IndexMatching->Sample,
				Category -> "Equilibration"
			},
			EquilibrationAspirationPositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[GreaterEqualP[0 Millimeter],Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],Null]],
				Description -> "For each member of Sample, the distance from the center of the well that the solution is aspirated after EquilibrationMagnetizationTime. The Z Offset is based on the EquilibrationAspirationPosition option -- measured as the height below the top of the well (Top), the height above the bottom of the well (Bottom), or the height below the detected liquid level (LiquidLevel). Please refer to the AspirationPosition diagram in the help file of ExperimentTransfer for more information. If an X and Y offset is not specified, the liquid will be aspirated in the center of the well, otherwise, -X/+X values will shift the position left and right, respectively, and -Y/+Y values will shift the position down and up, respectively.",
				IndexMatching->Sample,
				Category -> "Equilibration"
			},
			EquilibrationCollectionContainer->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[
					ObjectP[Model[Container]],
					ObjectP[Object[Container]],
					{_Integer,ObjectP[Model[Container]]},
					{_String,ObjectP[Model[Container]]},
					{_String,{_Integer,ObjectP[Model[Container]]}},
					_String,Null],3],
				Description->"For each member of Sample, the container(s) for collecting the aspirated sample(s) during the wash(es) prior to sample loading. By default, the same container is selected for the repeated washes (i.e. aspirated samples in the repeated washes will be combined) unless different container objects are specified for the washes.",
				Category->"Equilibration",
				IndexMatching->Sample
			},
			EquilibrationDestinationWell->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null],3],
				Developer->True,
				Description->"For each member of Sample, the destination well in the EquilibrationCollectionContainer that the collected used EquilibrationBuffer goes to.",
				Category->"Equilibration",
				IndexMatching->Sample
			},
			EquilibrationCollectionContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[_String,Null]..}|Null],
				Description->"For each member of Sample, the label of the container used for collecting the aspirated sample(s) during the wash(es) prior to adding samples to the magnetic beads.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			EquilibrationCollectionStorageConditionExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[SampleStorageTypeP,Disposal,Null]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the wash prior to adding samples to the magnetic beads should be stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			EquilibrationCollectionStorageConditionLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Pattern:>Alternatives[Model[StorageCondition]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the wash prior to adding samples to the magnetic beads should be stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			EquilibrationAirDry->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the magnetic beads are exposed to open air to evaporate the remaining EquilibrationBuffer following the final equilibration prior to adding samples to the magnetic beads.",
				Category->"Equilibration",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			EquilibrationAirDryTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration that the magnetic beads are exposed to open air to evaporate the remaining EquilibrationBuffer following the final equilibration prior to adding samples to the magnetic beads.",
				Category->"Equilibration",
				IndexMatching->Sample,
				Migration->NMultiple
			},

			(*===Loading===*)
			LoadingMix->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the solution is mixed following the combination of the input sample and the magnetic beads during the each loading.",
				Category->"Loading",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			LoadingMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MixTypeP,Null]],
				Description->"For each member of Sample, the style of motion used to mix the suspension following the addition of the The input sample to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
				Category->"Loading",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			LoadingMixTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the duration of time during which the combined the input sample and the magnetic beads are mixed.",
				Category->"Loading",
				Migration->NMultiple
			},
			LoadingMixRate->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 RPM],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the frequency of rotation used to mix the combined the input sample and the magnetic beads.",
				Category->"Loading",
				Migration->NMultiple
			},
			NumberOfLoadingMixes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the combined the input sample and magnetic beads are mixed if LoadingMixType is Pipette or Invert.",
				IndexMatching->Sample,
				Category->"Loading",
				Migration->NMultiple
			},
			LoadingMixVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 Microliter],Null]],
				Description->"For each member of Sample, the volume of the combined the input sample and magnetic beads that is pipetted up and down in order to mix, if LoadingMixType->Pipette.",
				IndexMatching->Sample,
				Category->"Loading",
				Migration->NMultiple
			},
			LoadingMixTemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Units->Celsius,
				Pattern :> GreaterEqualP[0 Kelvin],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined the input sample and magnetic beads.",
				Category->"Loading",
				Migration -> SplitField
			},
			LoadingMixTemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[Ambient,Null,GreaterEqualP[0 Kelvin]]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined the input sample and magnetic beads.",
				Category->"Loading",
				Migration -> SplitField
			},
			LoadingMixTipType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[TipTypeP,Null]],
				Description->"For each member of Sample, the type of pipette tips used to mix the combined The input sample and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if LoadingMixType->Pipette.",
				Category->"Loading",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			LoadingMixTipMaterial->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MaterialP,Null]],
				Description->"For each member of Sample, For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the LoadingMix. This option can only be set if LoadingMixType->Pipette.",
				Category->"Loading",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			LoadingMagnetizationTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration of magnetizing the magnetic beads after LoadingMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used the input sample.",
				Category->"Loading",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			LoadingAspirationVolumeReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1 Microliter],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each wash prior to adding samples to the magnetic beads.",
				Category->"Loading",
				IndexMatching->Sample,
				Migration->SplitField
			},
			LoadingAspirationVolumeExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[ListableP[Alternatives[All,Null]],{GreaterEqualP[1 Microliter]..}],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each wash prior to adding samples to the magnetic beads.",
				Category->"Loading",
				IndexMatching->Sample,
				Migration->SplitField
			},
			LoadingAspirationPosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> ListableP[Alternatives[MagneticBeadSeparationPipettingPositionP,Null]],
				Description -> "For each member of Sample, the location from which the solution is aspirated after LoadingMagnetizationTime. Top will aspirate LoadingAspirationPositionOffset below the Top of the container, Bottom will aspirate LoadingAspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate LoadingAspirationPositionOffset below the liquid level of the sample in the container.",
				IndexMatching->Sample,
				Category -> "Loading"
			},
			LoadingAspirationPositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[GreaterEqualP[0 Millimeter],Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],Null]],
				Description -> "For each member of Sample, the distance from the center of the well that the solution is aspirated after LoadingMagnetizationTime. The Z Offset is based on the LoadingAspirationPosition option -- measured as the height below the top of the well (Top), the height above the bottom of the well (Bottom), or the height below the detected liquid level (LiquidLevel). Please refer to the AspirationPosition diagram in the help file of ExperimentTransfer for more information. If an X and Y offset is not specified, the liquid will be aspirated in the center of the well, otherwise, -X/+X values will shift the position left and right, respectively, and -Y/+Y values will shift the position down and up, respectively.",
				IndexMatching->Sample,
				Category -> "Loading"
			},
			LoadingCollectionContainer->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[
					ObjectP[Model[Container]],
					ObjectP[Object[Container]],
					{_Integer,ObjectP[Model[Container]]},
					{_String,ObjectP[Model[Container]]},
					{_String,{_Integer,ObjectP[Model[Container]]}},
					_String,Null],3],
				Description->"For each member of Sample, the container(s) for collecting the aspirated sample(s) during loading. By default, the same container is selected for the repeated washes (i.e. aspirated samples in the repeated washes will be combined) unless different container objects are specified for the washes.",
				Category->"Loading",
				IndexMatching->Sample
			},
			LoadingDestinationWell->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[_String,Null]..}|Null],
				Developer->True,
				Description->"For each member of Sample, the destination well in the LoadingCollectionContainer that the collected sample(s) goes to.",
				Category->"Loading",
				IndexMatching->Sample
			},
			LoadingCollectionContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[_String,Null]..}|Null],
				Description->"For each member of Sample, the label of the container used for collecting the aspirated sample(s) during the wash(es) prior to adding samples to the magnetic beads.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			LoadingCollectionStorageConditionExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[SampleStorageTypeP,Disposal,Null]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the wash prior to adding samples to the magnetic beads should be stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			LoadingCollectionStorageConditionLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Pattern:>Alternatives[Model[StorageCondition]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the wash prior to adding samples to the magnetic beads should be stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			LoadingAirDry->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the magnetic beads are exposed to open air to evaporate the remaining The input sample following the final loading prior to adding samples to the magnetic beads.",
				Category->"Loading",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			LoadingAirDryTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration that the magnetic beads are exposed to open air to evaporate the remaining The input sample following the final loading prior to adding samples to the magnetic beads.",
				Category->"Loading",
				IndexMatching->Sample,
				Migration->NMultiple
			},

			(*===Wash===*)
			Wash->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[Null,BooleanP]],
				Description->"For each member of Sample, indicate if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SecondaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			WashBufferLink->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[{Model[Sample],Object[Sample]}],Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads during Wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SecondaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			WashBufferString->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads during Wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SecondaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			WashBufferVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[1 Microliter],Null]],
				Description->"For each member of Sample, the amount of WashBuffer that is added to the magnetic beads for each wash prior to elution or optional SecondaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			WashMix->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the solution is mixed following combination of WashBuffer and the magnetic beads during each wash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			WashMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MixTypeP,Null]],
				Description->"For each member of Sample, the style of motion used to mix the suspension following the addition of the WashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			WashMixTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the duration during which the combined WashBuffer and magnetic beads are mixed.",
				Category->"Wash",
				Migration->NMultiple
			},
			WashMixRate->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 RPM],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the frequency of rotation used to mix the combined WashBuffer and magnetic beads.",
				Category->"Wash",
				Migration->NMultiple
			},
			NumberOfWashMixes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the combined WashBuffer and magnetic beads are mixed if WashMixType is Pipette or Invert.",
				IndexMatching->Sample,
				Category->"Wash",
				Migration->NMultiple
			},
			WashMixVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 Microliter],Null]],
				Description->"For each member of Sample, the volume of the the combined WashBuffer and magnetic beads that is pipetted up and down in order to mix, if WashMixType->Pipette.",
				IndexMatching->Sample,
				Category->"Wash",
				Migration->NMultiple
			},
			WashMixTemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Units->Celsius,
				Pattern :> GreaterEqualP[0 Kelvin],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined WashBuffer and magnetic beads.",
				Category->"Wash",
				Migration -> SplitField
			},
			WashMixTemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[Ambient,Null,GreaterEqualP[0 Kelvin]]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined WashBuffer and magnetic beads.",
				Category->"Wash",
				Migration -> SplitField
			},
			WashMixTipType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[TipTypeP,Null]],
				Description->"For each member of Sample, the type of pipette tips used to mix the combined WashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if WashMixType->Pipette.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			WashMixTipMaterial->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MaterialP,Null]],
				Description->"For each member of Sample, For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the WashMix. This option can only be set if WashMixType->Pipette.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			WashMagnetizationTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration of magnetizing the magnetic beads after WashTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used WashBuffer containing residual sample components that are not bound to the magnetic beads.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			WashAspirationVolumeReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1 Microliter],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each wash prior to elution or optional SecondaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			WashAspirationVolumeExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[ListableP[Alternatives[All,Null]],{GreaterEqualP[1 Microliter]..}],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each wash prior to elution or optional SecondaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			WashAspirationPosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> ListableP[Alternatives[MagneticBeadSeparationPipettingPositionP,Null]],
				Description -> "For each member of Sample, the location from which the solution is aspirated after WashMagnetizationTime. Top will aspirate WashAspirationPositionOffset below the Top of the container, Bottom will aspirate WashAspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate WashAspirationPositionOffset below the liquid level of the sample in the container.",
				IndexMatching->Sample,
				Category -> "Wash"
			},
			WashAspirationPositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[GreaterEqualP[0 Millimeter],Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],Null]],
				Description -> "For each member of Sample, the distance from the center of the well that the solution is aspirated after WashMagnetizationTime. The Z Offset is based on the WashAspirationPosition option -- measured as the height below the top of the well (Top), the height above the bottom of the well (Bottom), or the height below the detected liquid level (LiquidLevel). Please refer to the AspirationPosition diagram in the help file of ExperimentTransfer for more information. If an X and Y offset is not specified, the liquid will be aspirated in the center of the well, otherwise, -X/+X values will shift the position left and right, respectively, and -Y/+Y values will shift the position down and up, respectively.",
				IndexMatching->Sample,
				Category -> "Wash"
			},
			WashCollectionContainer->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[
					ObjectP[Model[Container]],
					ObjectP[Object[Container]],
					{_Integer,ObjectP[Model[Container]]},
					{_String,ObjectP[Model[Container]]},
					{_String,{_Integer,ObjectP[Model[Container]]}},
					_String,Null],3],
				Description->"For each member of Sample, the container(s) for collecting the aspirated sample(s) during the wash(es). By default, the same container is selected for the repeated washes (i.e. aspirated samples in the repeated washes will be combined) unless different container objects are specified for the washes.",
				Category->"Wash",
				IndexMatching->Sample
			},
			WashDestinationWell->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null],3],
				Developer->True,
				Description->"For each member of Sample, the destination well in the WashCollectionContainer that the collected used WashBuffer goes to.",
				Category->"Wash",
				IndexMatching->Sample
			},
			WashCollectionContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[_String,Null]..}|Null],
				Description->"For each member of Sample, the label of the container used for collecting the aspirated sample(s) during the wash(es) prior to elution or optional SecondaryWash.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			WashCollectionStorageConditionExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[SampleStorageTypeP,Disposal,Null]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the wash prior to prior to elution or optional SecondaryWash are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			WashCollectionStorageConditionLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Pattern:>Alternatives[Model[StorageCondition]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the wash prior to elution or optional SecondaryWash are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			NumberOfWashes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the magnetic beads are washed by adding WashBuffer, mixing, magnetization, and aspirating solution prior to elution or optional SecondaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			WashAirDry->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the magnetic beads are exposed to open air to evaporate the remaining WashBuffer following the final wash prior to elution or optional SecondaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			WashAirDryTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration that the magnetic beads are exposed to open air to evaporate the remaining WashBuffer following the final wash prior to elution or optional SecondaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},


			(*===SecondaryWash===*)
			SecondaryWash->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[Null,BooleanP]],
				Description->"For each member of Sample, indicate if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional TertiaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SecondaryWashBufferLink->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[{Model[Sample],Object[Sample]}],Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads during SecondaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional TertiaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SecondaryWashBufferString->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads during SecondaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional TertiaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SecondaryWashBufferVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[1 Microliter],Null]],
				Description->"For each member of Sample, the amount of SecondaryWashBuffer that is added to the magnetic beads for each SecondaryWash prior to elution or optional TertiaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SecondaryWashMix->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the solution is mixed following combination of SecondaryWashBuffer and the magnetic beads during each SecondaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SecondaryWashMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MixTypeP,Null]],
				Description->"For each member of Sample, the style of motion used to mix the suspension following the addition of the SecondaryWashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SecondaryWashMixTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the duration during which the combined SecondaryWashBuffer and magnetic beads are mixed.",
				Category->"Wash",
				Migration->NMultiple
			},
			SecondaryWashMixRate->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 RPM],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the frequency of rotation used to mix the combined SecondaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration->NMultiple
			},
			NumberOfSecondaryWashMixes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the combined SecondaryWashBuffer and magnetic beads are mixed if SecondaryWashMixType is Pipette or Invert.",
				IndexMatching->Sample,
				Category->"Wash",
				Migration->NMultiple
			},
			SecondaryWashMixVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 Microliter],Null]],
				Description->"For each member of Sample, the volume of the the combined SecondaryWashBuffer and magnetic beads that is pipetted up and down in order to mix, if SecondaryWashMixType->Pipette.",
				IndexMatching->Sample,
				Category->"Wash",
				Migration->NMultiple
			},
			SecondaryWashMixTemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Units->Celsius,
				Pattern :> GreaterEqualP[0 Kelvin],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined SecondaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration -> SplitField
			},
			SecondaryWashMixTemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[Ambient,Null,GreaterEqualP[0 Kelvin]]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined SecondaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration -> SplitField
			},
			SecondaryWashMixTipType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[TipTypeP,Null]],
				Description->"For each member of Sample, the type of pipette tips used to mix the combined SecondaryWashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if SecondaryWashMixType->Pipette.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SecondaryWashMixTipMaterial->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MaterialP,Null]],
				Description->"For each member of Sample, For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the SecondaryWashMix. This option can only be set if SecondaryWashMixType->Pipette.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SecondaryWashMagnetizationTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration of magnetizing the magnetic beads after SecondaryWashTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used SecondaryWashBuffer containing residual sample components that are not bound to the magnetic beads.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SecondaryWashAspirationVolumeReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1 Microliter],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each SecondaryWash prior to elution or optional TertiaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SecondaryWashAspirationVolumeExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[ListableP[Alternatives[All,Null]],{GreaterEqualP[1 Microliter]..}],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each SecondaryWash prior to elution or optional TertiaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SecondaryWashAspirationPosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> ListableP[Alternatives[MagneticBeadSeparationPipettingPositionP,Null]],
				Description -> "For each member of Sample, the location from which the solution is aspirated after SecondaryWashMagnetizationTime. Top will aspirate SecondaryWashAspirationPositionOffset below the Top of the container, Bottom will aspirate SecondaryWashAspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate SecondaryWashAspirationPositionOffset below the liquid level of the sample in the container.",
				IndexMatching->Sample,
				Category->"Wash"
			},
			SecondaryWashAspirationPositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[GreaterEqualP[0 Millimeter],Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],Null]],
				Description -> "For each member of Sample, the distance from the center of the well that the solution is aspirated after SecondaryWashMagnetizationTime. The Z Offset is based on the SecondaryWashAspirationPosition option -- measured as the height below the top of the well (Top), the height above the bottom of the well (Bottom), or the height below the detected liquid level (LiquidLevel). Please refer to the AspirationPosition diagram in the help file of ExperimentTransfer for more information. If an X and Y offset is not specified, the liquid will be aspirated in the center of the well, otherwise, -X/+X values will shift the position left and right, respectively, and -Y/+Y values will shift the position down and up, respectively.",
				IndexMatching->Sample,
				Category->"Wash"
			},
			SecondaryWashCollectionContainer->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[
					ObjectP[Model[Container]],
					ObjectP[Object[Container]],
					{_Integer,ObjectP[Model[Container]]},
					{_String,ObjectP[Model[Container]]},
					{_String,{_Integer,ObjectP[Model[Container]]}},
					_String,Null],3],
				Description->"For each member of Sample, the container(s) for collecting the aspirated sample(s) during the SecondaryWash. By default, the same container is selected for the repeated secondaryWashes (i.e. aspirated samples in the repeated secondary washes will be combined) unless different container objects are specified for the secondary washes.",
				Category->"Wash",
				IndexMatching->Sample
			},
			SecondaryWashDestinationWell->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null],3],
				Developer->True,
				Description->"For each member of Sample, the destination well in the SecondaryWashCollectionContainer that the collected used SecondaryWashBuffer goes to.",
				Category->"Wash",
				IndexMatching->Sample
			},
			SecondaryWashCollectionContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[_String,Null]..}|Null],
				Description->"For each member of Sample, the label of the container used for collecting the aspirated sample(s) during the SecondaryWash(es) prior to elution or optional TertiaryWash.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SecondaryWashCollectionStorageConditionExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[SampleStorageTypeP,Disposal,Null]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the SecondaryWash prior to prior to elution or optional TertiaryWash are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SecondaryWashCollectionStorageConditionLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Pattern:>Alternatives[Model[StorageCondition]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the SecondaryWash prior to elution or optional TertiaryWash are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			NumberOfSecondaryWashes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the magnetic beads are SecondaryWashed by adding SecondaryWashBuffer, mixing, magnetization, and aspirating solution prior to elution or optional TertiaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SecondaryWashAirDry->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the magnetic beads are exposed to open air to evaporate the remaining SecondaryWashBuffer following the final SecondaryWash prior to elution or optional TertiaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SecondaryWashAirDryTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration that the magnetic beads are exposed to open air to evaporate the remaining SecondaryWashBuffer following the final SecondaryWash prior to elution or optional TertiaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},


			(*===TertiaryWash===*)
			TertiaryWash->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[Null,BooleanP]],
				Description->"For each member of Sample, indicate if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional QuaternaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			TertiaryWashBufferLink->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[{Model[Sample],Object[Sample]}],Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads during TertiaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional QuaternaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			TertiaryWashBufferString->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads during TertiaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional QuaternaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			TertiaryWashBufferVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[1 Microliter],Null]],
				Description->"For each member of Sample, the amount of TertiaryWashBuffer that is added to the magnetic beads for each TertiaryWash prior to elution or optional QuaternaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			TertiaryWashMix->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the solution is mixed following combination of TertiaryWashBuffer and the magnetic beads during each TertiaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			TertiaryWashMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MixTypeP,Null]],
				Description->"For each member of Sample, the style of motion used to mix the suspension following the addition of the TertiaryWashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			TertiaryWashMixTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the duration during which the combined TertiaryWashBuffer and magnetic beads are mixed.",
				Category->"Wash",
				Migration->NMultiple
			},
			TertiaryWashMixRate->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 RPM],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the frequency of rotation used to mix the combined TertiaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration->NMultiple
			},
			NumberOfTertiaryWashMixes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the combined TertiaryWashBuffer and magnetic beads are mixed if TertiaryWashMixType is Pipette or Invert.",
				IndexMatching->Sample,
				Category->"Wash",
				Migration->NMultiple
			},
			TertiaryWashMixVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 Microliter],Null]],
				Description->"For each member of Sample, the volume of the the combined TertiaryWashBuffer and magnetic beads that is pipetted up and down in order to mix, if TertiaryWashMixType->Pipette.",
				IndexMatching->Sample,
				Category->"Wash",
				Migration->NMultiple
			},
			TertiaryWashMixTemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Units->Celsius,
				Pattern :> GreaterEqualP[0 Kelvin],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined TertiaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration -> SplitField
			},
			TertiaryWashMixTemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[Ambient,Null,GreaterEqualP[0 Kelvin]]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined TertiaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration -> SplitField
			},
			TertiaryWashMixTipType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[TipTypeP,Null]],
				Description->"For each member of Sample, the type of pipette tips used to mix the combined TertiaryWashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if TertiaryWashMixType->Pipette.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			TertiaryWashMixTipMaterial->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MaterialP,Null]],
				Description->"For each member of Sample, For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the TertiaryWashMix. This option can only be set if TertiaryWashMixType->Pipette.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			TertiaryWashMagnetizationTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration of magnetizing the magnetic beads after TertiaryWashTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used TertiaryWashBuffer containing residual sample components that are not bound to the magnetic beads.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			TertiaryWashAspirationVolumeReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1 Microliter],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each TertiaryWash prior to elution or optional QuaternaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			TertiaryWashAspirationVolumeExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[ListableP[Alternatives[All,Null]],{GreaterEqualP[1 Microliter]..}],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each TertiaryWash prior to elution or optional QuaternaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			TertiaryWashAspirationPosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> ListableP[Alternatives[MagneticBeadSeparationPipettingPositionP,Null]],
				Description -> "For each member of Sample, the location from which the solution is aspirated after TertiaryWashMagnetizationTime. Top will aspirate TertiaryWashAspirationPositionOffset below the Top of the container, Bottom will aspirate TertiaryWashAspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate TertiaryWashAspirationPositionOffset below the liquid level of the sample in the container.",
				IndexMatching->Sample,
				Category->"Wash"
			},
			TertiaryWashAspirationPositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[GreaterEqualP[0 Millimeter],Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],Null]],
				Description -> "For each member of Sample, the distance from the center of the well that the solution is aspirated after TertiaryWashMagnetizationTime. The Z Offset is based on the TertiaryWashAspirationPosition option -- measured as the height below the top of the well (Top), the height above the bottom of the well (Bottom), or the height below the detected liquid level (LiquidLevel). Please refer to the AspirationPosition diagram in the help file of ExperimentTransfer for more information. If an X and Y offset is not specified, the liquid will be aspirated in the center of the well, otherwise, -X/+X values will shift the position left and right, respectively, and -Y/+Y values will shift the position down and up, respectively.",
				IndexMatching->Sample,
				Category->"Wash"
			},
			TertiaryWashCollectionContainer->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[
					ObjectP[Model[Container]],
					ObjectP[Object[Container]],
					{_Integer,ObjectP[Model[Container]]},
					{_String,ObjectP[Model[Container]]},
					{_String,{_Integer,ObjectP[Model[Container]]}},
					_String,Null],3],
				Description->"For each member of Sample, the container(s) for collecting the aspirated sample(s) during the TertiaryWash. By default, the same container is selected for the repeated tertiaryWashes (i.e. aspirated samples in the repeated tertiary washes will be combined) unless different container objects are specified for the tertiary washes.",
				Category->"Wash",
				IndexMatching->Sample
			},
			TertiaryWashDestinationWell->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null],3],
				Developer->True,
				Description->"For each member of Sample, the destination well in the TertiaryWashCollectionContainer that the collected used TertiaryWashBuffer goes to.",
				Category->"Wash",
				IndexMatching->Sample
			},
			TertiaryWashCollectionContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[_String,Null]..}|Null],
				Description->"For each member of Sample, the label of the container used for collecting the aspirated sample(s) during the TertiaryWash(es) prior to elution or optional QuaternaryWash.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			TertiaryWashCollectionStorageConditionExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[SampleStorageTypeP,Disposal,Null]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the TertiaryWash prior to prior to elution or optional QuaternaryWash are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			TertiaryWashCollectionStorageConditionLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Pattern:>Alternatives[Model[StorageCondition]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the TertiaryWash prior to elution or optional QuaternaryWash are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			NumberOfTertiaryWashes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the magnetic beads are TertiaryWashed by adding TertiaryWashBuffer, mixing, magnetization, and aspirating solution prior to elution or optional QuaternaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			TertiaryWashAirDry->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the magnetic beads are exposed to open air to evaporate the remaining TertiaryWashBuffer following the final TertiaryWash prior to elution or optional QuaternaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			TertiaryWashAirDryTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration that the magnetic beads are exposed to open air to evaporate the remaining TertiaryWashBuffer following the final TertiaryWash prior to elution or optional QuaternaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},


			(*===QuaternaryWash===*)
			QuaternaryWash->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[Null,BooleanP]],
				Description->"For each member of Sample, indicate if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional QuinaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuaternaryWashBufferLink->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[{Model[Sample],Object[Sample]}],Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads during QuaternaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional QuinaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			QuaternaryWashBufferString->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads during QuaternaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional QuinaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			QuaternaryWashBufferVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[1 Microliter],Null]],
				Description->"For each member of Sample, the amount of QuaternaryWashBuffer that is added to the magnetic beads for each QuaternaryWash prior to elution or optional QuinaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuaternaryWashMix->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the solution is mixed following combination of QuaternaryWashBuffer and the magnetic beads during each QuaternaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuaternaryWashMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MixTypeP,Null]],
				Description->"For each member of Sample, the style of motion used to mix the suspension following the addition of the QuaternaryWashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuaternaryWashMixTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the duration during which the combined QuaternaryWashBuffer and magnetic beads are mixed.",
				Category->"Wash",
				Migration->NMultiple
			},
			QuaternaryWashMixRate->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 RPM],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the frequency of rotation used to mix the combined QuaternaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration->NMultiple
			},
			NumberOfQuaternaryWashMixes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the combined QuaternaryWashBuffer and magnetic beads are mixed if QuaternaryWashMixType is Pipette or Invert.",
				IndexMatching->Sample,
				Category->"Wash",
				Migration->NMultiple
			},
			QuaternaryWashMixVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 Microliter],Null]],
				Description->"For each member of Sample, the volume of the the combined QuaternaryWashBuffer and magnetic beads that is pipetted up and down in order to mix, if QuaternaryWashMixType->Pipette.",
				IndexMatching->Sample,
				Category->"Wash",
				Migration->NMultiple
			},
			QuaternaryWashMixTemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Units->Celsius,
				Pattern :> GreaterEqualP[0 Kelvin],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined QuaternaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration -> SplitField
			},
			QuaternaryWashMixTemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[Ambient,Null,GreaterEqualP[0 Kelvin]]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined QuaternaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration -> SplitField
			},
			QuaternaryWashMixTipType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[TipTypeP,Null]],
				Description->"For each member of Sample, the type of pipette tips used to mix the combined QuaternaryWashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if QuaternaryWashMixType->Pipette.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuaternaryWashMixTipMaterial->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MaterialP,Null]],
				Description->"For each member of Sample, For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the QuaternaryWashMix. This option can only be set if QuaternaryWashMixType->Pipette.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuaternaryWashMagnetizationTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration of magnetizing the magnetic beads after QuaternaryWashTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used QuaternaryWashBuffer containing residual sample components that are not bound to the magnetic beads.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuaternaryWashAspirationVolumeReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1 Microliter],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each QuaternaryWash prior to elution or optional QuinaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			QuaternaryWashAspirationVolumeExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[ListableP[Alternatives[All,Null]],{GreaterEqualP[1 Microliter]..}],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each QuaternaryWash prior to elution or optional QuinaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			QuaternaryWashAspirationPosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> ListableP[Alternatives[MagneticBeadSeparationPipettingPositionP,Null]],
				Description -> "For each member of Sample, the location from which the solution is aspirated after QuaternaryWashMagnetizationTime. Top will aspirate QuaternaryWashAspirationPositionOffset below the Top of the container, Bottom will aspirate QuaternaryWashAspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate QuaternaryWashAspirationPositionOffset below the liquid level of the sample in the container.",
				IndexMatching->Sample,
				Category->"Wash"
			},
			QuaternaryWashAspirationPositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[GreaterEqualP[0 Millimeter],Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],Null]],
				Description -> "For each member of Sample, the distance from the center of the well that the solution is aspirated after QuaternaryWashMagnetizationTime. The Z Offset is based on the QuaternaryWashAspirationPosition option -- measured as the height below the top of the well (Top), the height above the bottom of the well (Bottom), or the height below the detected liquid level (LiquidLevel). Please refer to the AspirationPosition diagram in the help file of ExperimentTransfer for more information. If an X and Y offset is not specified, the liquid will be aspirated in the center of the well, otherwise, -X/+X values will shift the position left and right, respectively, and -Y/+Y values will shift the position down and up, respectively.",
				IndexMatching->Sample,
				Category->"Wash"
			},
			QuaternaryWashCollectionContainer->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[
					ObjectP[Model[Container]],
					ObjectP[Object[Container]],
					{_Integer,ObjectP[Model[Container]]},
					{_String,ObjectP[Model[Container]]},
					{_String,{_Integer,ObjectP[Model[Container]]}},
					_String,Null],3],
				Description->"For each member of Sample, the container(s) for collecting the aspirated sample(s) during the QuaternaryWash. By default, the same container is selected for the repeated quaternaryWashes (i.e. aspirated samples in the repeated quaternary washes will be combined) unless different container objects are specified for the quaternary washes.",
				Category->"Wash",
				IndexMatching->Sample
			},
			QuaternaryWashDestinationWell->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null],3],
				Developer->True,
				Description->"For each member of Sample, the destination well in the QuaternaryWashCollectionContainer that the collected used QuaternaryWashBuffer goes to.",
				Category->"Wash",
				IndexMatching->Sample
			},
			QuaternaryWashCollectionContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[_String,Null]..}|Null],
				Description->"For each member of Sample, the label of the container used for collecting the aspirated sample(s) during the QuaternaryWash(es) prior to elution or optional QuinaryWash.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuaternaryWashCollectionStorageConditionExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[SampleStorageTypeP,Disposal,Null]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the QuaternaryWash prior to prior to elution or optional QuinaryWash are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			QuaternaryWashCollectionStorageConditionLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Pattern:>Alternatives[Model[StorageCondition]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the QuaternaryWash prior to elution or optional QuinaryWash are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			NumberOfQuaternaryWashes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the magnetic beads are QuaternaryWashed by adding QuaternaryWashBuffer, mixing, magnetization, and aspirating solution prior to elution or optional QuinaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuaternaryWashAirDry->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the magnetic beads are exposed to open air to evaporate the remaining QuaternaryWashBuffer following the final QuaternaryWash prior to elution or optional QuinaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuaternaryWashAirDryTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration that the magnetic beads are exposed to open air to evaporate the remaining QuaternaryWashBuffer following the final QuaternaryWash prior to elution or optional QuinaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},


			(*===QuinaryWash===*)
			QuinaryWash->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[Null,BooleanP]],
				Description->"For each member of Sample, indicate if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuinaryWashBufferLink->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[{Model[Sample],Object[Sample]}],Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads during QuinaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			QuinaryWashBufferString->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads during QuinaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			QuinaryWashBufferVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[1 Microliter],Null]],
				Description->"For each member of Sample, the amount of QuinaryWashBuffer that is added to the magnetic beads for each QuinaryWash prior to elution or optional SenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuinaryWashMix->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the solution is mixed following combination of QuinaryWashBuffer and the magnetic beads during each QuinaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuinaryWashMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MixTypeP,Null]],
				Description->"For each member of Sample, the style of motion used to mix the suspension following the addition of the QuinaryWashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuinaryWashMixTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the duration during which the combined QuinaryWashBuffer and magnetic beads are mixed.",
				Category->"Wash",
				Migration->NMultiple
			},
			QuinaryWashMixRate->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 RPM],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the frequency of rotation used to mix the combined QuinaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration->NMultiple
			},
			NumberOfQuinaryWashMixes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the combined QuinaryWashBuffer and magnetic beads are mixed if QuinaryWashMixType is Pipette or Invert.",
				IndexMatching->Sample,
				Category->"Wash",
				Migration->NMultiple
			},
			QuinaryWashMixVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 Microliter],Null]],
				Description->"For each member of Sample, the volume of the the combined QuinaryWashBuffer and magnetic beads that is pipetted up and down in order to mix, if QuinaryWashMixType->Pipette.",
				IndexMatching->Sample,
				Category->"Wash",
				Migration->NMultiple
			},
			QuinaryWashMixTemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Units->Celsius,
				Pattern :> GreaterEqualP[0 Kelvin],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined QuinaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration -> SplitField
			},
			QuinaryWashMixTemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[Ambient,Null,GreaterEqualP[0 Kelvin]]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined QuinaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration -> SplitField
			},
			QuinaryWashMixTipType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[TipTypeP,Null]],
				Description->"For each member of Sample, the type of pipette tips used to mix the combined QuinaryWashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if QuinaryWashMixType->Pipette.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuinaryWashMixTipMaterial->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MaterialP,Null]],
				Description->"For each member of Sample, For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the QuinaryWashMix. This option can only be set if QuinaryWashMixType->Pipette.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuinaryWashMagnetizationTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration of magnetizing the magnetic beads after QuinaryWashTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used QuinaryWashBuffer containing residual sample components that are not bound to the magnetic beads.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuinaryWashAspirationVolumeReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1 Microliter],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each QuinaryWash prior to elution or optional SenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			QuinaryWashAspirationVolumeExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[ListableP[Alternatives[All,Null]],{GreaterEqualP[1 Microliter]..}],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each QuinaryWash prior to elution or optional SenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			QuinaryWashAspirationPosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> ListableP[Alternatives[MagneticBeadSeparationPipettingPositionP,Null]],
				Description -> "For each member of Sample, the location from which the solution is aspirated after QuinaryWashMagnetizationTime. Top will aspirate QuinaryWashAspirationPositionOffset below the Top of the container, Bottom will aspirate QuinaryWashAspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate QuinaryWashAspirationPositionOffset below the liquid level of the sample in the container.",
				IndexMatching->Sample,
				Category->"Wash"
			},
			QuinaryWashAspirationPositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[GreaterEqualP[0 Millimeter],Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],Null]],
				Description -> "For each member of Sample, the distance from the center of the well that the solution is aspirated after QuinaryWashMagnetizationTime. The Z Offset is based on the QuinaryWashAspirationPosition option -- measured as the height below the top of the well (Top), the height above the bottom of the well (Bottom), or the height below the detected liquid level (LiquidLevel). Please refer to the AspirationPosition diagram in the help file of ExperimentTransfer for more information. If an X and Y offset is not specified, the liquid will be aspirated in the center of the well, otherwise, -X/+X values will shift the position left and right, respectively, and -Y/+Y values will shift the position down and up, respectively.",
				IndexMatching->Sample,
				Category->"Wash"
			},
			QuinaryWashCollectionContainer->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[
					ObjectP[Model[Container]],
					ObjectP[Object[Container]],
					{_Integer,ObjectP[Model[Container]]},
					{_String,ObjectP[Model[Container]]},
					{_String,{_Integer,ObjectP[Model[Container]]}},
					_String,Null],3],
				Description->"For each member of Sample, the container(s) for collecting the aspirated sample(s) during the QuinaryWash. By default, the same container is selected for the repeated quinaryWashes (i.e. aspirated samples in the repeated quinary washes will be combined) unless different container objects are specified for the quinary washes.",
				Category->"Wash",
				IndexMatching->Sample
			},
			QuinaryWashDestinationWell->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null],3],
				Developer->True,
				Description->"For each member of Sample, the destination well in the QuinaryWashCollectionContainer that the collected used QuinaryWashBuffer goes to.",
				Category->"Wash",
				IndexMatching->Sample
			},
			QuinaryWashCollectionContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[_String,Null]..}|Null],
				Description->"For each member of Sample, the label of the container used for collecting the aspirated sample(s) during the QuinaryWash(es) prior to elution or optional SenaryWash.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuinaryWashCollectionStorageConditionExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[SampleStorageTypeP,Disposal,Null]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the QuinaryWash prior to prior to elution or optional SenaryWash are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			QuinaryWashCollectionStorageConditionLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Pattern:>Alternatives[Model[StorageCondition]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the QuinaryWash prior to elution or optional SenaryWash are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			NumberOfQuinaryWashes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the magnetic beads are QuinaryWashed by adding QuinaryWashBuffer, mixing, magnetization, and aspirating solution prior to elution or optional SenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuinaryWashAirDry->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the magnetic beads are exposed to open air to evaporate the remaining QuinaryWashBuffer following the final QuinaryWash prior to elution or optional SenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			QuinaryWashAirDryTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration that the magnetic beads are exposed to open air to evaporate the remaining QuinaryWashBuffer following the final QuinaryWash prior to elution or optional SenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},


			(*===SenaryWash===*)
			SenaryWash->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[Null,BooleanP]],
				Description->"For each member of Sample, indicate if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SeptenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SenaryWashBufferLink->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[{Model[Sample],Object[Sample]}],Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads during SenaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SeptenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SenaryWashBufferString->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads during SenaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SeptenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SenaryWashBufferVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[1 Microliter],Null]],
				Description->"For each member of Sample, the amount of SenaryWashBuffer that is added to the magnetic beads for each SenaryWash prior to elution or optional SeptenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SenaryWashMix->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the solution is mixed following combination of SenaryWashBuffer and the magnetic beads during each SenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SenaryWashMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MixTypeP,Null]],
				Description->"For each member of Sample, the style of motion used to mix the suspension following the addition of the SenaryWashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SenaryWashMixTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the duration during which the combined SenaryWashBuffer and magnetic beads are mixed.",
				Category->"Wash",
				Migration->NMultiple
			},
			SenaryWashMixRate->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 RPM],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the frequency of rotation used to mix the combined SenaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration->NMultiple
			},
			NumberOfSenaryWashMixes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the combined SenaryWashBuffer and magnetic beads are mixed if SenaryWashMixType is Pipette or Invert.",
				IndexMatching->Sample,
				Category->"Wash",
				Migration->NMultiple
			},
			SenaryWashMixVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 Microliter],Null]],
				Description->"For each member of Sample, the volume of the the combined SenaryWashBuffer and magnetic beads that is pipetted up and down in order to mix, if SenaryWashMixType->Pipette.",
				IndexMatching->Sample,
				Category->"Wash",
				Migration->NMultiple
			},
			SenaryWashMixTemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Units->Celsius,
				Pattern :> GreaterEqualP[0 Kelvin],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined SenaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration -> SplitField
			},
			SenaryWashMixTemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[Ambient,Null,GreaterEqualP[0 Kelvin]]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined SenaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration -> SplitField
			},
			SenaryWashMixTipType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[TipTypeP,Null]],
				Description->"For each member of Sample, the type of pipette tips used to mix the combined SenaryWashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if SenaryWashMixType->Pipette.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SenaryWashMixTipMaterial->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MaterialP,Null]],
				Description->"For each member of Sample, For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the SenaryWashMix. This option can only be set if SenaryWashMixType->Pipette.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SenaryWashMagnetizationTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration of magnetizing the magnetic beads after SenaryWashTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used SenaryWashBuffer containing residual sample components that are not bound to the magnetic beads.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SenaryWashAspirationVolumeReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1 Microliter],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each SenaryWash prior to elution or optional SeptenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SenaryWashAspirationVolumeExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[ListableP[Alternatives[All,Null]],{GreaterEqualP[1 Microliter]..}],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each SenaryWash prior to elution or optional SeptenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SenaryWashAspirationPosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> ListableP[Alternatives[MagneticBeadSeparationPipettingPositionP,Null]],
				Description -> "For each member of Sample, the location from which the solution is aspirated after SenaryWashMagnetizationTime. Top will aspirate SenaryWashAspirationPositionOffset below the Top of the container, Bottom will aspirate SenaryWashAspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate SenaryWashAspirationPositionOffset below the liquid level of the sample in the container.",
				IndexMatching->Sample,
				Category->"Wash"
			},
			SenaryWashAspirationPositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[GreaterEqualP[0 Millimeter],Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],Null]],
				Description -> "For each member of Sample, the distance from the center of the well that the solution is aspirated after SenaryWashMagnetizationTime. The Z Offset is based on the SenaryWashAspirationPosition option -- measured as the height below the top of the well (Top), the height above the bottom of the well (Bottom), or the height below the detected liquid level (LiquidLevel). Please refer to the AspirationPosition diagram in the help file of ExperimentTransfer for more information. If an X and Y offset is not specified, the liquid will be aspirated in the center of the well, otherwise, -X/+X values will shift the position left and right, respectively, and -Y/+Y values will shift the position down and up, respectively.",
				IndexMatching->Sample,
				Category->"Wash"
			},
			SenaryWashCollectionContainer->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[
					ObjectP[Model[Container]],
					ObjectP[Object[Container]],
					{_Integer,ObjectP[Model[Container]]},
					{_String,ObjectP[Model[Container]]},
					{_String,{_Integer,ObjectP[Model[Container]]}},
					_String,Null],3],
				Description->"For each member of Sample, the container(s) for collecting the aspirated sample(s) during the SenaryWash. By default, the same container is selected for the repeated senaryWashes (i.e. aspirated samples in the repeated senary washes will be combined) unless different container objects are specified for the senary washes.",
				Category->"Wash",
				IndexMatching->Sample
			},
			SenaryWashDestinationWell->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null],3],
				Developer->True,
				Description->"For each member of Sample, the destination well in the SenaryWashCollectionContainer that the collected used SenaryWashBuffer goes to.",
				Category->"Wash",
				IndexMatching->Sample
			},
			SenaryWashCollectionContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[_String,Null]..}|Null],
				Description->"For each member of Sample, the label of the container used for collecting the aspirated sample(s) during the SenaryWash(es) prior to elution or optional SeptenaryWash.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SenaryWashCollectionStorageConditionExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[SampleStorageTypeP,Disposal,Null]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the SenaryWash prior to prior to elution or optional SeptenaryWash are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SenaryWashCollectionStorageConditionLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Pattern:>Alternatives[Model[StorageCondition]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the SenaryWash prior to elution or optional SeptenaryWash are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			NumberOfSenaryWashes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the magnetic beads are SenaryWashed by adding SenaryWashBuffer, mixing, magnetization, and aspirating solution prior to elution or optional SeptenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SenaryWashAirDry->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the magnetic beads are exposed to open air to evaporate the remaining SenaryWashBuffer following the final SenaryWash prior to elution or optional SeptenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SenaryWashAirDryTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration that the magnetic beads are exposed to open air to evaporate the remaining SenaryWashBuffer following the final SenaryWash prior to elution or optional SeptenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},


			(*===SeptenaryWash===*)
			SeptenaryWash->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[Null,BooleanP]],
				Description->"For each member of Sample, indicate if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SeptenaryWashBufferLink->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[{Model[Sample],Object[Sample]}],Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads during SeptenaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SeptenaryWashBufferString->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads during SeptenaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SeptenaryWashBufferVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[1 Microliter],Null]],
				Description->"For each member of Sample, the amount of SeptenaryWashBuffer that is added to the magnetic beads for each SeptenaryWash prior to elution.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SeptenaryWashMix->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the solution is mixed following combination of SeptenaryWashBuffer and the magnetic beads during each SeptenaryWash.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SeptenaryWashMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MixTypeP,Null]],
				Description->"For each member of Sample, the style of motion used to mix the suspension following the addition of the SeptenaryWashBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SeptenaryWashMixTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the duration during which the combined SeptenaryWashBuffer and magnetic beads are mixed.",
				Category->"Wash",
				Migration->NMultiple
			},
			SeptenaryWashMixRate->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 RPM],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the frequency of rotation used to mix the combined SeptenaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration->NMultiple
			},
			NumberOfSeptenaryWashMixes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the combined SeptenaryWashBuffer and magnetic beads are mixed if SeptenaryWashMixType is Pipette or Invert.",
				IndexMatching->Sample,
				Category->"Wash",
				Migration->NMultiple
			},
			SeptenaryWashMixVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 Microliter],Null]],
				Description->"For each member of Sample, the volume of the the combined SeptenaryWashBuffer and magnetic beads that is pipetted up and down in order to mix, if SeptenaryWashMixType->Pipette.",
				IndexMatching->Sample,
				Category->"Wash",
				Migration->NMultiple
			},
			SeptenaryWashMixTemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Units->Celsius,
				Pattern :> GreaterEqualP[0 Kelvin],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined SeptenaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration -> SplitField
			},
			SeptenaryWashMixTemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[Ambient,Null,GreaterEqualP[0 Kelvin]]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined SeptenaryWashBuffer and magnetic beads.",
				Category->"Wash",
				Migration -> SplitField
			},
			SeptenaryWashMixTipType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[TipTypeP,Null]],
				Description->"For each member of Sample, the type of pipette tips used to mix the combined SeptenaryWashBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if SeptenaryWashMixType->Pipette.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SeptenaryWashMixTipMaterial->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MaterialP,Null]],
				Description->"For each member of Sample, For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the SeptenaryWashMix. This option can only be set if SeptenaryWashMixType->Pipette.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SeptenaryWashMagnetizationTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration of magnetizing the magnetic beads after SeptenaryWashTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used SeptenaryWashBuffer containing residual sample components that are not bound to the magnetic beads.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SeptenaryWashAspirationVolumeReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1 Microliter],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each SeptenaryWash prior to elution.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SeptenaryWashAspirationVolumeExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[ListableP[Alternatives[All,Null]],{GreaterEqualP[1 Microliter]..}],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each SeptenaryWash prior to elution.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SeptenaryWashAspirationPosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> ListableP[Alternatives[MagneticBeadSeparationPipettingPositionP,Null]],
				Description -> "For each member of Sample, the location from which the solution is aspirated after SeptenaryWashMagnetizationTime. Top will aspirate SeptenaryWashAspirationPositionOffset below the Top of the container, Bottom will aspirate SeptenaryWashAspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate SeptenaryWashAspirationPositionOffset below the liquid level of the sample in the container.",
				IndexMatching->Sample,
				Category->"Wash"
			},
			SeptenaryWashAspirationPositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[GreaterEqualP[0 Millimeter],Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],Null]],
				Description -> "For each member of Sample, the distance from the center of the well that the solution is aspirated after SeptenaryWashMagnetizationTime. The Z Offset is based on the SeptenaryWashAspirationPosition option -- measured as the height below the top of the well (Top), the height above the bottom of the well (Bottom), or the height below the detected liquid level (LiquidLevel). Please refer to the AspirationPosition diagram in the help file of ExperimentTransfer for more information. If an X and Y offset is not specified, the liquid will be aspirated in the center of the well, otherwise, -X/+X values will shift the position left and right, respectively, and -Y/+Y values will shift the position down and up, respectively.",
				IndexMatching->Sample,
				Category->"Wash"
			},
			SeptenaryWashCollectionContainer->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[
					ObjectP[Model[Container]],
					ObjectP[Object[Container]],
					{_Integer,ObjectP[Model[Container]]},
					{_String,ObjectP[Model[Container]]},
					{_String,{_Integer,ObjectP[Model[Container]]}},
					_String,Null],3],
				Description->"For each member of Sample, the container(s) for collecting the aspirated sample(s) during the SeptenaryWash. By default, the same container is selected for the repeated septenaryWashes (i.e. aspirated samples in the repeated septenary washes will be combined) unless different container objects are specified for the septenary washes.",
				Category->"Wash",
				IndexMatching->Sample
			},
			SeptenaryWashDestinationWell->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null],3],
				Developer->True,
				Description->"For each member of Sample, the destination well in the SeptenaryWashCollectionContainer that the collected used SeptenaryWashBuffer goes to.",
				Category->"Wash",
				IndexMatching->Sample
			},
			SeptenaryWashCollectionContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[_String,Null]..}|Null],
				Description->"For each member of Sample, the label of the container used for collecting the aspirated sample(s) during the SeptenaryWash(es) prior to elution.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SeptenaryWashCollectionStorageConditionExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[SampleStorageTypeP,Disposal,Null]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the SeptenaryWash prior to prior to elution are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			SeptenaryWashCollectionStorageConditionLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Pattern:>Alternatives[Model[StorageCondition]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the SeptenaryWash prior to elution are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			NumberOfSeptenaryWashes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the magnetic beads are SeptenaryWashed by adding SeptenaryWashBuffer, mixing, magnetization, and aspirating solution prior to elution.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SeptenaryWashAirDry->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the magnetic beads are exposed to open air to evaporate the remaining SeptenaryWashBuffer following the final SeptenaryWash prior to elution.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SeptenaryWashAirDryTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration that the magnetic beads are exposed to open air to evaporate the remaining SeptenaryWashBuffer following the final SeptenaryWash prior to elution.",
				Category->"Wash",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			(*===Elution===*)
			Elution->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[Null,BooleanP]],
				Description->"For each member of Sample, indicates if the magnetic beads are rinsed in a different buffer condition in order to release the components bound to the magnetic beads.",
				Category->"Elution",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			ElutionBufferLink->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[ObjectP[{Model[Sample],Object[Sample]}],Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads, providing a buffer condition in order to release the components bound to the magnetic beads.",
				Category->"Elution",
				IndexMatching->Sample,
				Migration->SplitField
			},
			ElutionBufferString->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null]],
				Description->"For each member of Sample, the solution used to rinse the magnetic beads, providing a buffer condition in order to release the components bound to the magnetic beads.",
				Category->"Elution",
				IndexMatching->Sample,
				Migration->SplitField
			},
			ElutionBufferVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[1 Microliter],Null]],
				Description->"For each member of Sample, the amount of ElutionBuffer that is added to the magnetic beads for each elution.",
				Category->"Elution",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			ElutionMix->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[BooleanP,Null]],
				Description->"For each member of Sample, indicates if the solution is mixed following combination of ElutionBuffer and the magnetic beads during each elution.",
				Category->"Elution",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			ElutionMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MixTypeP,Null]],
				Description->"For each member of Sample, the style of motion used to mix the suspension following the addition of the ElutionBuffer to the magnetic beads. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
				Category->"Elution",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			ElutionMixTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the duration of time during which the combined ElutionBuffer and the magnetic beads are mixed.",
				Category->"Elution",
				Migration->NMultiple
			},
			ElutionMixRate->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 RPM],Null]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the frequency of rotation used to mix the combined ElutionBuffer and the magnetic beads.",
				Category->"Elution",
				Migration->NMultiple
			},
			NumberOfElutionMixes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times that the combined ElutionBuffer and magnetic beads are mixed if ElutionMixType is Pipette or Invert.",
				IndexMatching->Sample,
				Category->"Elution",
				Migration->NMultiple
			},
			ElutionMixVolume->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterEqualP[0 Microliter],Null]],
				Description->"For each member of Sample, the volume of the combined ElutionBuffer and magnetic beads that is pipetted up and down in order to mix, if ElutionMixType->Pipette.",
				IndexMatching->Sample,
				Category->"Elution",
				Migration->NMultiple
			},
			ElutionMixTemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Units->Celsius,
				Pattern :> GreaterEqualP[0 Kelvin],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined ElutionBuffer and magnetic beads.",
				Category->"Elution",
				Migration -> SplitField
			},
			ElutionMixTemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[Ambient,Null,GreaterEqualP[0 Kelvin]]],
				IndexMatching->Sample,
				Description->"For each member of Sample, the temperature of the device that is used to mix/incubate the combined ElutionBuffer and magnetic beads.",
				Category->"Elution",
				Migration -> SplitField
			},
			ElutionMixTipType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[TipTypeP,Null]],
				Description->"For each member of Sample, the type of pipette tips used to mix the combined ElutionBuffer and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator. This option can only be set if ElutionMixType->Pipette.",
				Category->"Elution",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			ElutionMixTipMaterial->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[MaterialP,Null]],
				Description->"For each member of Sample, For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the requested volume during the ElutionMix. This option can only be set if ElutionMixType->Pipette.",
				Category->"Elution",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			ElutionMagnetizationTime->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0 Minute],Null]],
				Description->"For each member of Sample, the duration of magnetizing the magnetic beads after ElutionMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used ElutionBuffer.",
				Category->"Elution",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			ElutionAspirationVolumeReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1 Microliter],
				Description->"For each member of Sample, the volume of solution to aspirate out while the magnetic beads are magnetized and gathered to the side during each elution.",
				Category->"Elution",
				IndexMatching->Sample,
				Migration->SplitField
			},
			ElutionAspirationVolumeExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[ListableP[Alternatives[All,Null]],{GreaterEqualP[1 Microliter]..}],
				Description->"For each member of Sample, the volume to aspirate during each elution.",
				Category->"Elution",
				IndexMatching->Sample,
				Migration->SplitField
			},
			ElutionAspirationPosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> ListableP[Alternatives[MagneticBeadSeparationPipettingPositionP,Null]],
				Description -> "For each member of Sample, the location from which the solution is aspirated after ElutionMagnetizationTime. Top will aspirate ElutionAspirationPositionOffset below the Top of the container, Bottom will aspirate ElutionAspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate ElutionAspirationPositionOffset below the liquid level of the sample in the container.",
				IndexMatching->Sample,
				Category -> "Elution"
			},
			ElutionAspirationPositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ListableP[Alternatives[GreaterEqualP[0 Millimeter],Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],Null]],
				Description -> "For each member of Sample, the distance from the center of the well that the solution is aspirated after ElutionMagnetizationTime. The Z Offset is based on the ElutionAspirationPosition option -- measured as the height below the top of the well (Top), the height above the bottom of the well (Bottom), or the height below the detected liquid level (LiquidLevel). Please refer to the AspirationPosition diagram in the help file of ExperimentTransfer for more information. If an X and Y offset is not specified, the liquid will be aspirated in the center of the well, otherwise, -X/+X values will shift the position left and right, respectively, and -Y/+Y values will shift the position down and up, respectively.",
				IndexMatching->Sample,
				Category -> "Elution"
			},
			ElutionCollectionContainer->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[
					ObjectP[Model[Container]],
					ObjectP[Object[Container]],
					{_Integer,ObjectP[Model[Container]]},
					{_String,ObjectP[Model[Container]]},
					{_String,{_Integer,ObjectP[Model[Container]]}},
					_String,Null],3],
				Description->"For each member of Sample, the container(s) for collecting the aspirated sample(s) during the wash(es) prior to equilibration. By default, the same container is selected for the repeated washes (i.e. aspirated samples in the repeated washes will be combined) unless different container objects are specified for the washes.",
				Category->"Elution",
				IndexMatching->Sample
			},
			ElutionDestinationWell->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[_String,Null],3],
				Developer->True,
				Description->"For each member of Sample, the destination well in the ElutionCollectionContainer that the collected used ElutionBuffer goes to.",
				Category->"Elution",
				IndexMatching->Sample
			},
			ElutionCollectionContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[_String,Null]..}|Null],
				Description->"For each member of Sample, the label of the container used for collecting the aspirated sample(s) during the elutions.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			ElutionCollectionStorageConditionExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[SampleStorageTypeP,Disposal,Null]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the wash prior to equilibration are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			ElutionCollectionStorageConditionLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Pattern:>Alternatives[Model[StorageCondition]],
				Description->"For each member of Sample, the non-default condition under which the aspirated samples during the wash prior to equilibration are stored after the protocol is completed.",
				Category->"Sample Post-Processing",
				IndexMatching->Sample,
				Migration->SplitField
			},
			
			NumberOfElutions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[Alternatives[GreaterP[0],Null]],
				Description->"For each member of Sample, the number of times to elute the sample off the magnetic beads.",
				Category->"Elution",
				IndexMatching->Sample,
				Migration->NMultiple
			},

			AssayContainer->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[ObjectP[{Model[Container],Object[Container]}],_String,Null]..}|Null],
				Description->"For each member of Sample, the container(s) used during magnetization step of the experiment.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple,
				Developer->True
			},
			AssayContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[{Alternatives[_String,Null]..}|Null],
				Description->"For each member of Sample, the label of the container used during magnetization step of the experiment.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple,
				Developer->True
			}
		}
	}
];