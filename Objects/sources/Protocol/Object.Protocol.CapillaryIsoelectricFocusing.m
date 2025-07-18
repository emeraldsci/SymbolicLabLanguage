(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol,CapillaryIsoelectricFocusing],
	{
		Description->"A protocol for performing a capillary IsoElectric Focusing (cIEF) experiment on samples for electrophoretic separation over a linear pH gradient.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			Instrument->{
				Format->Single,
				Class->Link,
				Pattern:>ObjectP[{Model[Instrument,ProteinCapillaryElectrophoresis],Object[Instrument,ProteinCapillaryElectrophoresis]}],
				Relation->Object[Instrument,ProteinCapillaryElectrophoresis]|Model[Instrument,ProteinCapillaryElectrophoresis],
				Description->"The device on which the protocol is run. The instrument is loaded with a cartridge that holds the capillary in which cIEF is performed as well as electrolyte solutions required for this experiment, as well as additional buffers. Protein samples mixed with ampholytes and other components are loaded, one by one, on to the capillary by vacuum and a voltage is applied. As a result, analytes migrate in the in the formed pH gradient to their isoelectric point and are detected by UV absorption and native fluorescence.",
				Category->"General"
			},
			Cartridge->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Container,ProteinCapillaryElectrophoresisCartridge]|Object[Container,ProteinCapillaryElectrophoresisCartridge],
				Description->"The capillary electrophoresis cartridge loaded on the instrument for Capillary IsoElectric Focusing (cIEF) experiments. The cartridge holds a single capillary and electrolyte buffers (sources of hydronium and hydroxyl ions).",
				Category->"Instrument Setup"
			},
			InitialCartridgeAppearances -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "The front-view and side-view images of the Cartridge captured before the experiment starts.",
				Category->"Instrument Setup"
			},
			FinalCartridgeAppearances -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "The front-view and side-view images of the Cartridge captured after the experiment finishes.",
				Category->"Instrument Setup"
			},
			CartridgeContainer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container],
				Description -> "A container used for storing and transporting the Cartridge.",
				Category -> "Instrument Setup",
				Developer -> True
			},
			RunTime->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0Second],
				Units->Minute,
				Description->"The total time capillary isoelectric focusing is expected to run.",
				Category->"General"
			},
			InjectionTable->{
				Format->Multiple,
				Class->{
					Type->Expression,
					Sample->Link,
					Volume->Real,
					Data->Link,
					SampleIndex->Integer
				},
				Pattern:>{
					Type->Alternatives[Sample,Standard,Blank],
					Sample->_Link,
					Volume->GreaterEqualP[0Microliter],
					Data->_Link,
					SampleIndex->GreaterEqualP[1,1]
				},
				Units->{
					Type->Null,
					Sample->None,
					Volume->Microliter,
					Data->None,
					SampleIndex->None
				},
				Relation->{
					Type->Null,
					Sample->Alternatives[Object[Sample],Model[Sample]],
					Volume->Null,
					Data->Object[Data]|Object[Data][Protocol],
					SampleIndex->Null
				},
				Description->"The sequence of injections for a given experiment run for SamplesIn, Standards, and Blanks.",
				Category -> "General"
			},
			SampleTemperature->{
				Format->Single,
				Class->Integer,
				Pattern:>GreaterP[0*Kelvin],
				Units->Celsius,
				Description->"The sample tray temperature at which samples are maintained while awaiting injection.",
				Category->"Instrument Setup"
			},
			(* files and file paths *)
			MethodFilePath->{
				Format->Single,
				Class->String,
				Pattern:>FilePathP,
				Description->"The path to the folder holding the methods file containing the run parameters for all samples in protocol.",
				Category -> "General",
				Developer->True
			},
			MethodFileName->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The methods filename containing the run parameters for all samples in protocol.",
				Category -> "General",
				Developer->True
			},
			MethodFile->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[EmeraldCloudFile],
				Description->"The methods file containing the run parameters for all samples in protocol.",
				Category -> "General"
			},
			InjectionListFilePath->{
				Format->Single,
				Class->String,
				Pattern:>FilePathP,
				Description->"The path to the folder holding the InjectionList file containing the sample order and associated method name for all samples in the protocol.",
				Category -> "General",
				Developer->True
			},
			InjectionListFileName->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The InjectionList filename containing the sample order and associated method name for all samples in the protocol.",
				Category -> "General",
				Developer->True
			},
			InjectionListFile->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[EmeraldCloudFile],
				Description->"The InjectionList file containing the sample order and associated method name for all samples in the protocol.",
				Category -> "General"
			},
			DataFilePath->{
				Format->Single,
				Class->String,
				Pattern:>FilePathP,
				Description->"The path to the folder holding the output data file generated at the conclusion of the experiment.",
				Category -> "General",
				Developer->True
			},
			DataFileName->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The output data filename generated at the conclusion of the experiment.",
				Category -> "General",
				Developer->True
			},
			DataFile->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[EmeraldCloudFile],
				Description->"The output data file generated at the conclusion of the experiment.",
				Category->"Experimental Results"
			},
			Caps->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Item,Cap]|Object[Item,Cap],
				Description->"The caps used to seal reagent vials during an isoelectric focusing experiment.",
				Category->"Instrument Setup"
			},
			ContainersWithPressureCaps->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Container],
				Description->"Containers that are currently capped with pressure caps.",
				Category->"Instrument Setup"
			},
			ContainersWithClearCaps->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Container],
				Description->"Containers that are currently capped with clear caps.",
				Category->"Instrument Setup"
			},
			PressureCaps->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Item,Cap]|Object[Item,Cap],
				Description->"The pressure caps used to seal reagent vials during an isoelectric focusing experiment.",
				Category->"Instrument Setup",
				Developer->True
			},
			DipCaps->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Item,Cap]|Object[Item,Cap],
				Description->"The sipping caps used to seal reagent vials during an isoelectric focusing experiment.",
				Category->"Instrument Setup",
				Developer->True
			},
			TransferPipette->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Item,Consumable]|Object[Item,Consumable],
				Description->"The disposable transfer pipette used to clean the cartridge ports before storage.",
				Category->"Instrument Setup"
			},
			Anolyte->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"The electrolyte solution loaded on the cartridge that is the source of hydronium ions for the capillary in cIEF experiments.",
				Category->"Instrument Setup"
			},
			Catholyte->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"The electrolyte solution loaded on the cartridge that is the source of hydroxyl ions for the capillary in cIEF experiments.",
				Category->"Instrument Setup"
			},
			ElectroosmoticConditioningBuffer->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"The ElectroosmoticConditioningBuffer solution is used to wash the capillary between injections.",
				Category->"Instrument Setup"
			},
			FluorescenceCalibrationStandard->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"The FluorescenceCalibrationStandard solution is used to adjust the baseline and normalize the signal for detection.",
				Category->"Instrument Setup"
			},
			WashSolution->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"The solution used to rinse the capillary after use.",
				Category->"Instrument Setup"
			},
			PlaceholderContainer->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Container,Vessel]|Object[Container,Vessel],
				Description->"An empty vial used to dry the capillary after wash.",
				Category->"Instrument Setup"
			},
			PlateSeal->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Item]|Object[Item],
				Description->"The adhesive film used to seal the assay plate once it is prepared for injection. The seal should be pierceable, if not, it should be removed before loading the plate to the instrument.",
				Category->"Instrument Setup"
			},
			AssayContainer->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Container,Plate],Model[Container,Plate],Object[Container,Vessel],Model[Container,Vessel]],
				Description->"The containers the samples are assayed in.",
				Category->"Sample Preparation"
			},
			AnolyteStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"The non-default storage condition for the anolyte solution once the experiment is set up.",
				Category->"Storage Information"
			},
			CatholyteStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"The non-default storage condition for the catholyte solution once the experiment is set up.",
				Category->"Storage Information"
			},
			ElectroosmoticConditioningBufferStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"The non-default storage condition for the ElectroosmoticConditioningBuffer once the experiment is set up.",
				Category->"Storage Information"
			},
			FluorescenceCalibrationStandardStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"The non-default storage condition for the FluorescenceCalibrationStandard once the experiment is set up.",
				Category->"Storage Information"
			},
			WashSolutionStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"The non-default storage condition for the WashSolution once the experiment is set up.",
				Category->"Storage Information"
			},
			CartridgeCleanupWasteContainer->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Container,Vessel]|Object[Container,Vessel],
				Description->"Indicates the container used for waste in cleanup.",
				Category->"Sample Preparation"
			},
			OnBoardMixing->{
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if samples should be mixed onboard or on a liquid handler. When using OnBoardMixing, Sample tubes should contain samples in 25 microliters. Before injecting each sample, the instrument will add and mix 100 microliters of MasterMix.",
				Category->"Sample Preparation"
			},
			OnBoardMixingContainers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Container,Vessel]|Object[Container,Vessel],
				Description->"Indicates the containers (6 ml glass vials) used for holding the master mix for onboard mixing.",
				Category->"Sample Preparation"
			},
			OnBoardMixingPrepContainer->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Container,Vessel]|Object[Container,Vessel],
				Description->"Indicates the container (50 ml tube, for liquid handler compatibility) used for preparing the master mix for onboard mixing.",
				Category->"Sample Preparation"
			},
			OnBoardMixingWash->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"Indicates the water containers (6 ml glass vials) used for washing the capillary in onboard mixing.",
				Category->"Sample Preparation"
			},
			TotalVolumes->{
				Format->Multiple,
				Class->Real,
				Units->Microliter,
				Pattern:>GreaterEqualP[0*Microliter],
				Description->"For each member of SamplesIn, TotalVolumes indicates the final volume in the assay tube prior to loading onto the capillary. Each tube contains a Sample, DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			SampleVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of SamplesIn, indicates the  volume of sample required.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			PremadeMasterMixReagents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates the premade master mix used. The master mix contains the reagents required for cIEF experiments, i.e., DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			PremadeMasterMixDiluents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates the premade master mix diluent used. The diluent solution dilutes the premade master mix used to its working concentration.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			PremadeMasterMixReagentDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1],
				Description->"For each member of SamplesIn, indicates the factor by which the premade master mix needs to be diluted by.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			PremadeMasterMixVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of SamplesIn, indicates the volume of the premade master mix required to reach its final concentration.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			Diluents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates the diluent buffer, e.g., Milli-Q water, added to the master mix to dilute all components to working concentration.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			DenaturationReagents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates the denaturing agent, e.g., Urea or SimpleSol, added to the master mix to prevent protein precipitation.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			DenaturationReagentTargetConcentrations->{
				Format->Multiple,
				Class->VariableUnit,
				Pattern:>GreaterEqualP[0*Molar]|RangeP[0*VolumePercent,100*VolumePercent],
				Description->"For each member of SamplesIn, indicates the final concentration of the denaturing agent in the mastermix.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			DenaturationReagentVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of SamplesIn, indicates the volumes of the denaturing agent required to reach its final concentration in the mastermix.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			(* Todo: N-Multiples *)
			Ampholytes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[ObjectP[{Model[Sample], Object[Sample]}]|Null],
				Description->"For each member of SamplesIn, indicates the makeup of amphoteric molecules in the master mix that form the pH gradient.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			ListedAmpholytes->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates a flattened version of the makeup of amphoteric molecules in the master mix that form the pH gradient.",
				IndexMatching->SamplesIn,
				Developer->True,
				Category->"Sample Preparation"
			},
			(* Todo: N-Multiples *)
			AmpholyteTargetConcentrations->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{RangeP[0*VolumePercent,100*VolumePercent]..},
				Description->"For each member of SamplesIn, indicates the concentrations (Vol/Vol) of amphoteric molecules in the mastermix.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			(* Todo: N-Multiples *)
			AmpholyteVolumes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{GreaterEqualP[0*Microliter]..},
				Description->"For each member of SamplesIn, indicates the volumes of amphoteric molecule stocks to add to the mastermix.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			(* Todo: N-Multiples *)
			IsoelectricPointMarkers->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[ObjectP[{Model[Sample], Object[Sample]}]|Null],
				Description->"For each member of SamplesIn, indicates Reference analytes included in the mastermix. pI markers facilitate the interpolation of sample pI. The pH is then interpolated by the straight line between the pI markers.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			ListedIsoelectricPointMarkers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates a flattened version of the Reference analytes included in the master mix that form the pH gradient.",
				IndexMatching->SamplesIn,
				Developer->True,
				Category->"Sample Preparation"
			},
			(* Todo: N-Multiples *)
			IsoelectricPointMarkersTargetConcentrations->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{RangeP[0*VolumePercent,100*VolumePercent]..},
				Description->"For each member of SamplesIn, indicates the final concentrations (Vol/Vol) of pI markers in the mastermix.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			(* Todo: N-Multiples *)
			IsoelectricPointMarkersVolumes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{GreaterEqualP[0*Microliter]..},
				Description->"For each member of SamplesIn, indicates the volume of pI marker stocks added to the mastermix.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			AnodicSpacers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates the Acidic ampholyte included in the mastermix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of ampholytes, Spacers (ampholytes with very low or very high pIs) can be added to buffer the loss of analytes of interest.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			AnodicSpacerTargetConcentrations->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Molar],
				Units:>Molar,
				Description->"For each member of SamplesIn, indicates the final concentrations of AnodicSpacer in the mastermix.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			AnodicSpacerVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of SamplesIn, indicates the volume of AnodicSpacer stock added to the mastermix.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			CathodicSpacers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates the basic ampholyte included in the mastermix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of ampholytes, Spacers (ampholytes with very low or very high pIs) can be added to buffer the loss of analytes of interest.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			CathodicSpacerTargetConcentrations->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Molar],
				Units:>Molar,
				Description->"For each member of SamplesIn, indicates the final concentrations of CathodicSpacer in the mastermix.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			CathodicSpacerVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of SamplesIn, indicates the volume of CathodicSpacer stock added to the mastermix.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			ElectroosmoticFlowBlockers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates the solution added to samples to minimize electroOsmotic flow in the capillary.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			ElectroosmoticFlowBlockerTargetConcentrations->{
				Format->Multiple,
				Class->Real,
				Pattern:>RangeP[0*MassPercent,100*MassPercent],
				Units:>MassPercent,
				Description->"For each member of SamplesIn, indicates the final concentrations of ElectroosmoticFlowBlockers in the mastermix.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			ElectroosmoticFlowBlockerVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of SamplesIn, indicates the volumes of ElectroosmoticFlowBlockers stock to add to the master mix for each sample.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			(* Todo: N-Multiples *)
			AmpholytesStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{Alternatives[SampleStorageTypeP,Disposal,Null]..},
				Description->"For each member of SamplesIn, indicates the non-default storage condition for the Ampholyte solutions after sample is prepared.",
				IndexMatching->SamplesIn,
				Category->"Storage Information"
			},
			(* Todo: N-Multiples *)
			IsoelectricPointMarkersStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{Alternatives[SampleStorageTypeP,Disposal,Null]..},
				Description->"For each member of SamplesIn, indicates the non-default storage condition for the IsoelectricPointMarkers after the protocol is completed.",
				IndexMatching->SamplesIn,
				Category->"Storage Information"
			},
			DenaturationReagentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of SamplesIn, indicates the non-default storage condition for the Denaturation Reagent after the protocol is completed.",
				IndexMatching->SamplesIn,
				Category->"Storage Information"
			},
			AnodicSpacerStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of SamplesIn, indicates the non-default storage condition for the Anodic Spacer after the protocol is completed.",
				IndexMatching->SamplesIn,
				Category->"Storage Information"
			},
			CathodicSpacerStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of SamplesIn, indicates the non-default storage condition for the cathodic Spacer after the protocol is completed.",
				IndexMatching->SamplesIn,
				Category->"Storage Information"
			},
			ElectroosmoticFlowBlockerStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of SamplesIn, indicates the non-default storage condition for the ElectroosmoticFlowBlocker after the protocol is completed.",
				IndexMatching->SamplesIn,
				Category->"Storage Information"
			},
			DiluentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of SamplesIn, indicates the non-default storage condition for the Diluent after the protocol is completed.",
				IndexMatching->SamplesIn,
				Category->"Storage Information"
			},
			LoadTimes->{
				Format->Multiple,
				Class->Real,
				Units->Second,
				Pattern:>GreaterP[0*Second],
				Description->"For each member of SamplesIn, indicates the time to load samples mixed with master mix into the capillary by vacuum.",
				IndexMatching->SamplesIn,
				Category->"Separation"
			},
			VoltageDurationProfiles->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{GreaterEqualP[0*Volt],GreaterP[0*Second]}..},
				Description->"For each member of SamplesIn, indicates the series of voltages and durations to apply onto the capillary for separation.",
				IndexMatching->SamplesIn,
				Category->"Separation"
			},
			ImagingMethods->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[Absorbance,AbsorbanceAndFluorescence],
				Description->"For each member of SamplesIn, indicates the whole capillary imaging methods for each sample.",
				IndexMatching->SamplesIn,
				Category->"Imaging"
			},
			NativeFluorescenceExposureTimes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{GreaterP[0*Second]..},
				Description->"For each member of SamplesIn, indicates exposure durations for NativeFluorescence detection.",
				IndexMatching->SamplesIn,
				Category->"Imaging"
			},
			(* Standards *)
			Standards->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Sample]|Model[Sample],
				Description->"Known analytes that serve as standards for the experiment.",
				Category->"Standards"
			},

			StandardTotalVolumes->{
				Format->Multiple,
				Class->Real,
				Units->Microliter,
				Pattern:>GreaterEqualP[0*Microliter],
				Description->"For each member of Standards, TotalVolumes indicates the final volume in the assay tube prior to loading onto the capillary. Each tube contains a Sample, DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Standards, indicates the non-default storage condition.",
				IndexMatching->Standards,
				Category->"Storage Information"
			},
			StandardVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Standards, indicates the volume of blank required.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardPremadeMasterMixReagents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates the premade master mix used. The master mix contains the reagents required for cIEF experiments, i.e., DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardPremadeMasterMixDiluents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates the premade master mix diluent used. The diluent solution dilutes the premade master mix used to its working concentration.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardPremadeMasterMixReagentDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1],
				Description->"For each member of Standards, indicates the factor by which the premade master mix needs to be diluted by.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardPremadeMasterMixVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Standards, indicates the volume of the premade master mix required to reach its final concentration.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardDiluents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates the diluent buffer, e.g., Milli-Q water, added to the master mix to dilute all components to working concentration.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardDenaturationReagents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates the denaturing agent, e.g., Urea or SimpleSol, added to the master mix to prevent protein precipitation.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardDenaturationReagentTargetConcentrations->{
				Format->Multiple,
				Class->VariableUnit,
				Pattern:>GreaterEqualP[0*Molar]|RangeP[0*VolumePercent,100*VolumePercent],
				Description->"For each member of Standards, indicates the final concentration of the denaturing agent in the mastermix.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardDenaturationReagentVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Standards, indicates the volumes of the denaturing agent required to reach its final concentration in the mastermix.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			(* Todo: N-Multiples *)
			StandardAmpholytes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[ObjectP[{Model[Sample], Object[Sample]}]|Null],
				Description->"For each member of Standards, indicates the makeup of amphoteric molecules in the master mix that form the pH gradient.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			ListedStandardAmpholytes->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates a flattened version of the makeup of amphoteric molecules in the master mix that form the pH gradient.",
				IndexMatching->Standards,
				Developer->True,
				Category->"Standards"
			},
			(* Todo: N-Multiples *)
			StandardAmpholyteTargetConcentrations->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{RangeP[0*VolumePercent,100*VolumePercent]..},
				Description->"For each member of Standards, indicates the concentrations (Vol/Vol) of amphoteric molecules in the mastermix.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			(* Todo: N-Multiples *)
			StandardAmpholyteVolumes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{GreaterEqualP[0*Microliter]..},
				Description->"For each member of Standards, indicates the volumes of amphoteric molecule stocks to add to the mastermix.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			(* Todo: N-Multiples *)
			StandardIsoelectricPointMarkers->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[ObjectP[{Model[Sample], Object[Sample]}]|Null],
				Description->"For each member of Standards, indicates the Reference analytes included in the mastermix. pI markers facilitate the interpolation of sample pI. The pH is then interpolated by the straight line between the pI markers.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			ListedStandardIsoelectricPointMarkers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates a flattened version of the Reference analytes included in the mastermix. pI markers facilitate the interpolation of sample pI. The pH is then interpolated by the straight line between the pI markers.",
				IndexMatching->Standards,
				Developer->True,
				Category->"Standards"
			},
			(* Todo: N-Multiples *)
			StandardIsoelectricPointMarkersTargetConcentrations->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{RangeP[0*VolumePercent,100*VolumePercent]..},
				Description->"For each member of Standards, indicates the final concentrations (Vol/Vol) of pI markers in the mastermix.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			(* Todo: N-Multiples *)
			StandardIsoelectricPointMarkersVolumes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{GreaterEqualP[0*Microliter]..},
				Description->"For each member of Standards, indicates the volume of pI marker stocks added to the mastermix.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardAnodicSpacers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates the Acidic ampholyte included in the mastermix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of ampholytes, Spacers (ampholytes with very low or very high pIs) can be added to buffer the loss of analytes of interest.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardAnodicSpacerTargetConcentrations->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Molar],
				Units:>Molar,
				Description->"For each member of Standards, indicates the final concentrations of AnodicSpacer in the mastermix.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardAnodicSpacerVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Standards, indicates the volume of AnodicSpacer stock added to the mastermix.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardCathodicSpacers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates the basic ampholyte included in the mastermix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of ampholytes, Spacers (ampholytes with very low or very high pIs) can be added to buffer the loss of analytes of interest.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardCathodicSpacerTargetConcentrations->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Molar],
				Units:>Molar,
				Description->"For each member of Standards, indicates the final concentrations of CathodicSpacer in the mastermix.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardCathodicSpacerVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Standards, indicates the volume of CathodicSpacer stock to add to the mastermix.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardElectroosmoticFlowBlockers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates the solution added to samples to minimize electroOsmotic flow in the capillary.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardElectroosmoticFlowBlockerTargetConcentrations->{
				Format->Multiple,
				Class->Real,
				Pattern:>RangeP[0*MassPercent,100*MassPercent],
				Units:>MassPercent,
				Description->"For each member of Standards, indicates the final concentrations of ElectroosmoticFlowBlockers in the mastermix.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardElectroosmoticFlowBlockerVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Standards, indicates the volumes of ElectroosmoticFlowBlockers stock to add to the master mix for each sample.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			(* Todo: N-Multiples *)
			StandardAmpholytesStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{Alternatives[SampleStorageTypeP,Disposal,Null]..},
				Description->"For each member of Standards, indicates the non-default storage condition for the Ampholyte solutions after sample is prepared.",
				IndexMatching->Standards,
				Category->"Storage Information"
			},
			(* Todo: N-Multiples *)
			StandardIsoelectricPointMarkersStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{Alternatives[SampleStorageTypeP,Disposal,Null]..},
				Description->"For each member of Standards, indicates the non-default storage condition for the IsoelectricPointMarkers after the protocol is completed.",
				IndexMatching->Standards,
				Category->"Storage Information"
			},
			StandardDenaturationReagentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of Standards, indicates the non-default storage condition for the Denaturation Reagent after the protocol is completed.",
				IndexMatching->Standards,
				Category->"Storage Information"
			},
			StandardAnodicSpacerStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of Standards, indicates the non-default storage condition for the Anodic Spacer after the protocol is completed.",
				IndexMatching->Standards,
				Category->"Storage Information"
			},
			StandardCathodicSpacerStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of Standards, indicates the non-default storage condition for the cathodic Spacer after the protocol is completed.",
				IndexMatching->Standards,
				Category->"Storage Information"
			},
			StandardElectroosmoticFlowBlockerStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of Standards, indicates the non-default storage condition for the ElectroosmoticFlowBlocker after the protocol is completed.",
				IndexMatching->Standards,
				Category->"Storage Information"
			},
			StandardDiluentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of Standards, indicates the non-default storage condition for the StandardDiluent after the protocol is completed.",
				IndexMatching->Standards,
				Category->"Storage Information"
			},
			StandardLoadTimes->{
				Format->Multiple,
				Class->Real,
				Units->Second,
				Pattern:>GreaterP[0*Second],
				Description->"For each member of Standards, indicates the time to load samples mixed with master mix into the capillary by vacuum.",
				IndexMatching->Standards,
				Category->"Separation"
			},
			StandardVoltageDurationProfiles->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{GreaterEqualP[0*Volt],GreaterP[0*Second]}..},
				Description->"For each member of Standards, indicates the series of voltages and durations to apply onto the capillary for separation.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardImagingMethods->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[Absorbance,AbsorbanceAndFluorescence],
				Description->"For each member of Standards, indicates whole capillary imaging methods applied.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardNativeFluorescenceExposureTimes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{GreaterP[0*Second]..},
				Description->"For each member of Standards, indicates the exposure durations for NativeFluorescence detection.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			(* Blanks *)
			Blanks->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Sample]|Model[Sample],
				Description->"Known analytes that serve as Blanks for the experiment.",
				Category->"Blanks"
			},
			BlankStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Blanks, indicates the non-default storage condition.",
				IndexMatching->Blanks,
				Category->"Storage Information"
			},
			BlankTotalVolumes->{
				Format->Multiple,
				Class->Real,
				Units->Microliter,
				Pattern:>GreaterEqualP[0*Microliter],
				Description->"For each member of Blanks, TotalVolumes indicates the final volume in the assay tube prior to loading onto the capillary. Each tube contains a Sample, DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Blanks, indicates the volume of blank required.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankPremadeMasterMixReagents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates the premade master mix used. The master mix contains the reagents required for cIEF experiments, i.e., DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankPremadeMasterMixDiluents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates the premade master mix diluent used. The diluent solution dilutes the premade master mix used to its working concentration.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankPremadeMasterMixReagentDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1],
				Description->"For each member of Blanks, indicates the factor by which the premade master mix needs to be diluted by.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankPremadeMasterMixVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Blanks, indicates the volume of the premade master mix required to reach its final concentration.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankDiluents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates the diluent buffer, e.g., Milli-Q water, added to the master mix to dilute all components to working concentration.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankDenaturationReagents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates the denaturing agent, e.g., Urea or SimpleSol, added to the master mix to prevent protein precipitation.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankDenaturationReagentTargetConcentrations->{
				Format->Multiple,
				Class->VariableUnit,
				Pattern:>GreaterEqualP[0*Molar]|RangeP[0*VolumePercent,100*VolumePercent],
				Description->"For each member of Blanks, indicates the final concentration of the denaturing agent in the mastermix.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankDenaturationReagentVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Blanks, indicates the volumes of the denaturing agent required to reach its final concentration in the mastermix.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			(* Todo: N-Multiples *)
			BlankAmpholytes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[ObjectP[{Model[Sample], Object[Sample]}]|Null],
				Description->"For each member of Blanks, indicates the makeup of amphoteric molecules in the master mix that form the pH gradient.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			ListedBlankAmpholytes->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates a flattened version of the makeup of amphoteric molecules in the master mix that form the pH gradient.",
				IndexMatching->Blanks,
				Developer->True,
				Category->"Blanks"
			},
			(* Todo: N-Multiples *)
			BlankAmpholyteTargetConcentrations->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{RangeP[0*VolumePercent,100*VolumePercent]..},
				Description->"For each member of Blanks, indicates the concentrations (Vol/Vol) of amphoteric molecules in the mastermix.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			(* Todo: N-Multiples *)
			BlankAmpholyteVolumes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{GreaterEqualP[0*Microliter]..},
				Description->"For each member of Blanks, indicates the volumes of amphoteric molecule stocks to add to the mastermix.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			(* Todo: N-Multiples *)
			BlankIsoelectricPointMarkers->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ListableP[ObjectP[{Model[Sample], Object[Sample]}]|Null],
				Description->"For each member of Blanks, indicates the Reference analytes included in the mastermix. pI markers facilitate the interpolation of sample pI. The pH is then interpolated by the straight line between the pI markers.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			ListedBlankIsoelectricPointMarkers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates a flattened version of the Reference analytes included in the mastermix. pI markers facilitate the interpolation of sample pI. The pH is then interpolated by the straight line between the pI markers.",
				IndexMatching->Blanks,
				Developer->True,
				Category->"Blanks"
			},
			(* Todo: N-Multiples *)
			BlankIsoelectricPointMarkersTargetConcentrations->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{RangeP[0*VolumePercent,100*VolumePercent]..},
				Description->"For each member of Blanks, indicates the final concentrations (Vol/Vol) of pI markers in the mastermix.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			(* Todo: N-Multiples *)
			BlankIsoelectricPointMarkersVolumes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{GreaterEqualP[0*Microliter]..},
				Description->"For each member of Blanks, indicates the volume of pI marker stocks added to the mastermix.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankAnodicSpacers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates the Acidic ampholyte included in the mastermix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of ampholytes, Spacers (ampholytes with very low or very high pIs) can be added to buffer the loss of analytes of interest.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankAnodicSpacerTargetConcentrations->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Molar],
				Units:>Molar,
				Description->"For each member of Blanks, indicates the final concentrations of AnodicSpacer in the mastermix.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankAnodicSpacerVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Blanks, indicates the volume of AnodicSpacer stock added to the mastermix.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankCathodicSpacers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates the basic ampholyte included in the mastermix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of ampholytes, Spacers (ampholytes with very low or very high pIs) can be added to buffer the loss of analytes of interest.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankCathodicSpacerTargetConcentrations->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Molar],
				Units:>Molar,
				Description->"For each member of Blanks, indicates the final concentrations of CathodicSpacer in the mastermix.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankCathodicSpacerVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Blanks, indicates the volume of CathodicSpacer stock to add to the mastermix.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankElectroosmoticFlowBlockers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates the solution added to samples to minimize electroOsmotic flow in the capillary.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankElectroosmoticFlowBlockerTargetConcentrations->{
				Format->Multiple,
				Class->Real,
				Pattern:>RangeP[0*MassPercent,100*MassPercent],
				Units:>MassPercent,
				Description->"For each member of Blanks, indicates the final concentrations of ElectroosmoticFlowBlockers in the mastermix.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankElectroosmoticFlowBlockerVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Blanks, indicates the volumes of ElectroosmoticFlowBlockers stock to add to the mastermix.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			(* Todo: N-Multiples *)
			BlankAmpholytesStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{Alternatives[SampleStorageTypeP,Disposal,Null]..},
				Description->"For each member of Blanks, indicates the non-default storage condition for the Ampholyte solutions after sample is prepared.",
				IndexMatching->Blanks,
				Category->"Storage Information"
			},
			(* Todo: N-Multiples *)
			BlankIsoelectricPointMarkersStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{Alternatives[SampleStorageTypeP,Disposal,Null]..},
				Description->"For each member of Blanks, indicates the non-default storage condition for the IsoelectricPointMarkers after the protocol is completed.",
				IndexMatching->Blanks,
				Category->"Storage Information"
			},
			BlankDenaturationReagentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of Blanks, indicates the non-default storage condition for the Denaturation Reagent after the protocol is completed.",
				IndexMatching->Blanks,
				Category->"Storage Information"
			},
			BlankAnodicSpacerStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of Blanks, indicates the non-default storage condition for the Anodic Spacer after the protocol is completed.",
				IndexMatching->Blanks,
				Category->"Storage Information"
			},
			BlankCathodicSpacerStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of Blanks, indicates the non-default storage condition for the cathodic Spacer after the protocol is completed.",
				IndexMatching->Blanks,
				Category->"Storage Information"
			},
			BlankElectroosmoticFlowBlockerStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of Blanks, indicates the non-default storage condition for the ElectroosmoticFlowBlocker after the protocol is completed.",
				IndexMatching->Blanks,
				Category->"Storage Information"
			},
			BlankDiluentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"For each member of Blanks, indicates the non-default storage condition for the BlankDiluent after the protocol is completed.",
				IndexMatching->Blanks,
				Category->"Storage Information"
			},
			BlankLoadTimes->{
				Format->Multiple,
				Class->Real,
				Units->Second,
				Pattern:>GreaterP[0*Second],
				Description->"For each member of Blanks, indicates the time to load samples mixed with master mix into the capillary by vacuum.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankVoltageDurationProfiles->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{GreaterEqualP[0*Volt],GreaterP[0*Second]}..},
				Description->"For each member of Blanks, indicates the series of voltages and durations to apply onto the capillary for separation for each sample.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankImagingMethods->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[Absorbance,AbsorbanceAndFluorescence],
				Description->"For each member of Blanks, indicates the whole capillary imaging methods applied.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankNativeFluorescenceExposureTimes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{GreaterP[0*Second]..},
				Description->"For each member of Blanks, indicates the exposure duration for NativeFluorescence detection.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			CartridgeStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal,Null],
				Description->"The non-default storage condition for the Cartridge after the protocol is completed.",
				Category->"Storage Information"
			},
			(* Primitives, Protocols, and Placements*)
			SamplePreparationPrimitives->{
				Format->Multiple,
				Class->Expression,
				Pattern:>SampleManipulationP|SamplePreparationP,
				Description->"A set of instructions specifying the preparation of samples, standards, and blanks for capillary Isoelectric Focusing experiments, including addition of ampholytes, ElectroosmoticFlowBlocker, Denaturant, and pI marker.",
				Category -> "General"
			},
			SamplePreparationProtocol->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Protocol,SampleManipulation]|Object[Protocol,RoboticSamplePreparation],
				Description->"The protocol used to prepare samples for capillary Isoelectric Focusing experiments.",
				Category->"Sample Preparation"
			},
			OnBoardMixingContainersPrimitives->{
				Format->Multiple,
				Class->Expression,
				Pattern:>SampleManipulationP|SamplePreparationP,
				Description->"A set of instructions specifying the transfer of master mix from preparation tube to on board mixing vials.",
				Category -> "General"
			},
			CartridgeCleanupPrimitives->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ManualSamplePreparationP,
				Description->"A set of instructions specifying the transfer of buffers out of the experiment cartridge.",
				Category -> "General"
			},
			InstrumentPlacements->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Model[Container]|Object[Container],Null},
				Description->"A list of placements used to move reagents into position in the instrument.",
				Headers->{"Object to Place","Placement Tree"},
				Category -> "General",
				Developer->True
			},
			InstrumentPressureCapPlacements->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Model[Container]|Object[Container],Null},
				Description->"A list of placements used to move reagents that require a pressure cap into position in the instrument.",
				Headers->{"Object to Place","Placement Tree"},
				Category -> "General",
				Developer->True
			},
			CartridgePreparationPrimitives->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ManualSamplePreparationP,
				Description->"A set of instructions specifying the transfer of the anolyte and catholyte to the CIEF cartridge.",
				Category -> "General"
			},
			CartridgePlacement->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Model[Container,ProteinCapillaryElectrophoresisCartridge]|Object[Container,ProteinCapillaryElectrophoresisCartridge],Null},
				Description->"A placement used to move the Cartridge into its position in the instrument.",
				Headers->{"Object to Place","Placement Tree"},
				Category -> "General",
				Developer->True
			},
			AssayPlatePlacement->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Model[Container]|Object[Container],Null},
				Description->"A placement used to move the AssayPlate into position in the instrument.",
				Headers->{"Object to Place","Placement Tree"},
				Category -> "General",
				Developer->True
			},
			OnBoardMixingContainersPlacement->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Model[Container]|Object[Container],Null},
				Description->"A placement used to move the On?BoardMixingContainers into position in the instrument.",
				Headers->{"Object to Place","Placement Tree"},
				Category -> "General",
				Developer->True
			},
			InstrumentPlacementAppearance->{
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "The image of the instrument deck after all reagents and the AssayPlate have been loaded.",
				Category -> "General",
				Developer->True
			},
			ExposureTimes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{GreaterP[0*Second]..},
				Description->"The exposure durations used in this protocol for NativeFluorescence detection.",
				Category->"Imaging",
				Developer->True
			},
			UpdatedMethodFileName->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The updated method's filename containing the run parameters for all samples in protocol, as saved before running the instrument.",
				Category -> "General",
				Developer->True
			}
		}
	}
];