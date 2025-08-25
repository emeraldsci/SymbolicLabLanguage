(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol,CapillaryGelElectrophoresisSDS],
	{
		Description->"A protocol for performing a Capillary gel Electrophoresis-Sodium Dodecyl Sulfate (CESDS) experiment on samples to separate denatured proteins according to their molecular weight by electrophoresis through a sieving matrix.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			Instrument->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Instrument,ProteinCapillaryElectrophoresis]|Model[Instrument,ProteinCapillaryElectrophoresis],
				Description->"The device on which the protocol is run. The instrument is loaded with a cartridge that holds the capillary in which Capillary gel Electrophoresis-Sodium Dodecyl Sulfate (CESDS) is performed as well as the anode running buffer required for this experiment. Samples are first denatured by heating in the presence of SDS, imparting all proteins in the sample a negative charge and a similar charge to mass ratio. For every sample, separation matrix is loaded onto the capillary and the sample is electroinjected into the matrix. Subsequently, a voltage is applied on the capillary and proteins migrate through the sieving matrix where smaller proteins migrate faster than larger ones. Proteins are detected as they migrate past a UV absorbance detector and relative migration times are calculated relative to an internal standard.",
				Category->"General"
			},
			AssayPlate->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Container,Plate]|Model[Container,Plate],
				Description->"The 96-well plate holding all reagents and samples for a Capillary gel Electrophoresis-SDS experiment loaded onto the instrument.",
				Category->"General"
			},
			SamplePreparationPlate->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Container,Plate]|Model[Container,Plate],
				Description->"The 96-well plate in which sample preparation for a Capillary gel Electrophoresis-SDS experiment takes place.",
				Category->"General"
			},
			RunTime->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0Second],
				Units->Minute,
				Description->"The total time capillary gel electrophoresis sds is expected to run.",
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
					Type->Alternatives[Sample,Ladder,Standard,Blank],
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
				Description->"The sequence of injections for a given experiment run for SamplesIn, Ladders, Standards, and Blanks.",
				Category->"General"
			},
			(* File Paths *)
			MethodFilePath->{
				Format->Single,
				Class->String,
				Pattern:>FilePathP,
				Description->"The path to the folder holding the methods file containing the run parameters for all samples in protocol.",
				Category->"General",
				Developer->True
			},
			MethodFileName->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The methods filename containing the run parameters for all samples in protocol.",
				Category->"General",
				Developer->True
			},
			MethodFile->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[EmeraldCloudFile],
				Description->"The methods file containing the run parameters for all samples in protocol.",
				Category->"General"
			},
			UpdatedMethodFileName->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The updated method's filename containing the run parameters for all samples in protocol, as saved before running the instrument.",
				Category->"General",
				Developer->True
			},
			InjectionListFilePath->{
				Format->Single,
				Class->String,
				Pattern:>FilePathP,
				Description->"The path to the folder holding the instrument file specifying the order of sample injection and associated method names for all samples in the protocol.",
				Category->"General",
				Developer->True
			},
			InjectionListFileName->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The filename of the file specifying the order of sample injection and associated method names for all samples in the protocol.",
				Category->"General",
				Developer->True
			},
			InjectionListFile->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[EmeraldCloudFile],
				Description->"The file specifying the order of sample injection and associated method names for all samples in the protocol.",
				Category->"General"
			},
			DataFilePath->{
				Format->Single,
				Class->String,
				Pattern:>FilePathP,
				Description->"The path to the folder holding the output data file generated at the conclusion of the experiment.",
				Category->"Experimental Results",
				Developer->True
			},
			DataFileName->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The output data filename generated at the conclusion of the experiment.",
				Category->"Experimental Results",
				Developer->True
			},
			DataFile->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[EmeraldCloudFile],
				Description->"The output data file generated at the conclusion of the experiment by the instrument.",
				Category->"Experimental Results"
			},
			(* Cartridge related fields *)
			Cartridge->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Container,ProteinCapillaryElectrophoresisCartridge]|Object[Container,ProteinCapillaryElectrophoresisCartridge],
				Description->"The capillary electrophoresis cartridge loaded on the instrument for Capillary gel Electrophoresis-SDS experiments. The cartridge holds a single capillary and the anode running buffer.",
				Category->"Instrument Setup"
			},
			CartridgeInsert->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Container,ProteinCapillaryElectrophoresisCartridgeInsert]|Object[Container,ProteinCapillaryElectrophoresisCartridgeInsert],
				Description->"The insert loaded on the Capillary gel Electrophoresis-SDS cartridge. The insert holds the top running buffer or the cleaning cartridge.",
				Category->"Instrument Setup"
			},
			CartridgeInsertReplacement->{
				Format->Single,
				Class->Link,
				Pattern:>Alternatives[_Link,Null],
				Relation->Model[Container,ProteinCapillaryElectrophoresisCartridgeInsert]|Object[Container,ProteinCapillaryElectrophoresisCartridgeInsert],
				Description->"The new insert to be picked and installed if the cartridge insert in the picked Cartridge has exceeded its maximum usage at the end of the protocol. The indicator light on the insert will turn red when it has surpassed its maximum use, signaling that it must be replaced before the next experiment can proceed.",
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
			TopRunningBuffer->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Item,Consumable]|Object[Item,Consumable],
				Description->"Indicates the buffer loaded onto the cartridge for separation. This buffer must be compatible with the cathode running buffer loaded on the instrument (see: OnBoardRunningBuffer).",
				Category->"Instrument Setup"
			},
			TopRunningBufferBackup->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Item,Consumable]|Object[Item,Consumable],
				Description->"Indicates the buffer loaded onto the cartridge for separation. This is a backup that will be picked only if a cartridge purge is required.",
				Category->"Instrument Setup"
			},
			PurgeCartridge->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[IfRequired,True,False],
				Description->"Indicates whether cartridge should be purged even if not prompted by instrument.",
				Category->"Instrument Setup"
			},
			CartridgeTipCleanup->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"A beaker with water used to clean the capillary tip if needed after a run ends.",
				Category->"Instrument Setup"
			},
			CleanupCartridge->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Item,Consumable]|Object[Item,Consumable],
				Description->"Indicates the item that is used to clean up the experiment cartridge after every run.",
				Category->"Cartridge Cleanup"
			},
			CleanupCartridgeWashSolution->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"Indicates the solution that is used to clean up the experiment cartridge after every run and its appropriate cap.",
				Category->"Cartridge Cleanup"
			},
			SampleTemperature->{
				Format->Single,
				Class->Integer,
				Pattern:>GreaterP[0*Kelvin],
				Units->Celsius,
				Description->"The sample tray temperature at which samples are maintained while awaiting injection.",
				Category->"Instrument Setup"
			},
			Caps->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Item,Cap]|Object[Item,Cap],
				Description->"The caps used to seal reagent vials during a gel electrophoresis SDS experiment.",
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
				Description->"The pressure caps used to seal reagent vials during a gel electrophoresis SDS experiment.",
				Category->"Instrument Setup",
				Developer->True
			},
			DipCaps->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Item,Cap]|Object[Item,Cap],
				Description->"The sipping caps used to seal reagent vials during a gel electrophoresis SDS experiment.",
				Category->"Instrument Setup",
				Developer->True
			},
			CleanupCartridgeCap->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Item,Cap]|Object[Item,Cap],
				Description->"The caps used to seal reagent vials during a gel electrophoresis SDS experiment.",
				Category->"Instrument Setup"
			},
			ConditioningAcid->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"The Conditioning Acid solution used to wash the capillary (every 12 injections).",
				Category->"Instrument Setup"
			},
			ConditioningBase->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"The Conditioning Base solution used to wash the capillary (every 12 injections).",
				Category->"Instrument Setup"
			},
			ConditioningWashSolution->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"The solution used to wash the capillary after acid and base wash (every 12 injections).",
				Category->"Instrument Setup"
			},
			SeparationMatrix->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"The sieving matrix loaded onto the capillary before each sample for separation. The mash-like matrix slows the migration of proteins based on their size so that larger proteins migrate slower than smaller ones.",
				Category->"Instrument Setup"
			},
			SystemWashSolution->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"The solution used to wash the capillary after conditioning and, separately, rinse the tip twice before every injection.",
				Category->"Instrument Setup"
			},
			PlaceholderContainer->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Container,Vessel]|Object[Container,Vessel],
				Description->"The PlaceholderContainer is an empty vial used to dry the capillary after each wash.",
				Category->"Instrument Setup"
			},
			BottomRunningBuffer->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"Indicates the buffer in which the capillary docks for separation. This buffer must be compatible with the anode running buffer loaded on the Capillary gel electrophoresis SDS cartridge (see: OnBoardRunningBuffer).",
				Category->"Instrument Setup"
			},
			Denature->{
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if heat denaturation should be applied to all samples.",
				Category->"Sample Preparation"
			},
			DenaturingTemperature->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0*Kelvin],
				Units->Celsius,
				Description->"Indicates the temperature to which samples will be heated in order to linearize proteins in the sample.",
				Category->"Sample Preparation"
			},
			DenaturingTime->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0*Second],
				Units->Minute,
				Description->"Indicates the duration samples will be incubated at the DenaturingTemperature.",
				Category->"Sample Preparation"
			},
			CoolingTemperature->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0*Kelvin],
				Units->Celsius,
				Description->"Indicates the temperature at which samples will be cooled after denaturation.",
				Category->"Sample Preparation"
			},
			CoolingTime->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0*Second],
				Units->Minute,
				Description->"Indicates the duration samples will be incubated at the CoolingTemperatures.",
				Category->"Sample Preparation"
			},
			PelletSedimentation->{
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if centrifugation should be applied to the sample to remove precipitates after denaturation.",
				Category->"Sample Preparation"
			},
			SedimentationCentrifugationSpeed->{
				Format->Single,
				Class->Integer,
				Pattern:>GreaterP[0*RPM],
				Units->RPM,
				Description->"Indicates the speed of centrifugation applied to remove precipitates.",
				Category->"Sample Preparation"
			},
			SedimentationCentrifugationForce->{
				Format->Single,
				Class->Integer,
				Pattern:>GreaterP[0*GravitationalAcceleration],
				Units->GravitationalAcceleration,
				Description->"Indicates the force of centrifugation applied to remove precipitates.",
				Category->"Sample Preparation"
			},
			SedimentationCentrifugationTime->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0*Second],
				Units->Minute,
				Description->"Indicates the duration samples will be centrifuged to remove precipitates.",
				Category->"Sample Preparation"
			},
			SedimentationCentrifugationTemperature->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0*Kelvin],
				Units->Celsius,
				Description->"Indicates the temperature at which samples will be held while centrifugating to remove precipitates.",
				Category->"Sample Preparation"
			},
			AssayContainers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Container,Plate],Model[Container,Plate],Object[Container,Vessel],Model[Container,Vessel]],
				Description->"The containers the samples are assayed in.",
				Category->"Sample Preparation"
			},
			ConditioningAcidStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"The non-default storage condition for the ConditioningAcid once the experiment is set up.",
				Category->"Instrument Setup"
			},
			ConditioningBaseStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"The non-default storage condition for the ConditioningBase once the experiment is set up.",
				Category->"Instrument Setup"
			},
			SeparationMatrixStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"The non-default storage condition for the SeparationMatrix once the experiment is set up.",
				Category->"Instrument Setup"
			},
			SystemWashSolutionStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"The non-default storage condition for the SystemWashSolution once the experiment is set up.",
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
			(* Sample Prep fields *)
			TotalVolumes->{
				Format->Multiple,
				Class->Real,
				Units->Microliter,
				Pattern:>GreaterEqualP[0*Microliter],
				Description->"For each member of SamplesIn, indicates the final volume in the assay tube prior to loading onto AssayContainer. Each tube contains Sample,  InternalReference,  SDSBuffer, and ReducingAgent and/or AlkylatingAgent.",
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
				Description->"For each member of SamplesIn, indicates the premade master mix used for CESDS experiment, containing an SDS buffer, an internal standard, and reducing and / or alkylating agents (if applicable).",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			PremadeMasterMixDiluents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn,indicates the solution used to dilute the premade master mix used to its working concentration.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			PremadeMasterMixReagentDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[1],
				Description->"For each member of SamplesIn, indicates the factor by which the premade mastermix should be diluted by in the final assay tube.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			PremadeMasterMixVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of SamplesIn, indicates the volume of the premade mastermix required to reach its final concentration.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			InternalReferences->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates the internal standard stock solution added in sample preparation. The internal standard stock solution contains the analyte that serves as the reference by which Relative Migration Time is normalized. By default a 10 KDa marker is used.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			InternalReferenceDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[1],
				Description->"For each member of SamplesIn, indicates the factor by which the InternalReference needs to be diluted to reach working concentration.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			InternalReferenceVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of SamplesIn, indicates the volume of InternalReference to be diluted by a factor equal to InternalReferenceDilutionFactor to reach working concentration in the final assay volume containing all other components (i.e., sample, SDS buffer, and reducing/alkylating agents).",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			ConcentratedSDSBuffers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates the SDS Buffer concentrate used to dilute and denature the sample.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			ConcentratedSDSBufferDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1],
				Description->"For each member of SamplesIn, indicates the factor by which the ConcentratedSDSBuffer needs to be diluted to reach working concentration.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			ConcentratedSDSBufferVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of SamplesIn, indicates the volume of ConcentratedSDSBuffer to reach its working concentration in the final assay volume containing all other components (i.e., sample, internal standard, and reducing/alkylating agents).",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			Diluents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates the solution used to bring the assay tube to TotalVolume so that all components are at working concentration in the final assay volume containing all other components (i.e., sample, internal standard, SDS buffer, and reducing/alkylating agents).",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			SDSBuffers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates the SDS Buffer used to dilute and denature the sample.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			SDSBufferVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of SamplesIn, indicates the volume of SDSBuffer to add to sample to reach working concentration in the final assay volume containing all other components (i.e., sample, internal standard, and reducing/alkylating agents).",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			ReducingAgents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates the reducing agent, e.g., \[Beta]-mercaptoethanol or Dithiothreitol, added to the sample to reduce disulfide bridges in proteins.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			ReducingAgentTargetConcentrations->{
				Format->Multiple,
				Class->VariableUnit,
				Pattern:>GreaterEqualP[0*Molar]|RangeP[0*VolumePercent,100*VolumePercent],
				Units->None,
				Description->"For each member of SamplesIn, indicates the final concentration of the ReducingAgent in the sample.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			ReducingAgentVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of SamplesIn, indicates the volume of the ReducingAgent added to the sample to reach working concentration in the final assay volume containing all other components (i.e., sample, internal standard, SDSBuffer and alkylating agents).",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			AlkylatingAgents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of SamplesIn, indicates the alkylating agent, e.g., Iodoacetamide, added to the sample to prevent protein fragmentation.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			AlkylatingAgentTargetConcentrations->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Molar],
				Units->Millimolar,
				Description->"For each member of SamplesIn, indicates the final concentration of the AlkylatingAgent in the sample.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			AlkylatingAgentVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of SamplesIn, indicates the volume of the AlkylatingAgent added the sample.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			SedimentationSupernatantVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of SamplesIn, indicates the volume of supernatant that should be aliquoted to assay AssayContainer after denaturation and centrifugation.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			InternalReferenceStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of SamplesIn, indicates the non-default storage condition for the InternalReference after samples are transferred to assay tubes.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			ConcentratedSDSBufferStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of SamplesIn, indicates the non-default storage condition for the ConcentratedSDSBuffer after samples are transferred to assay tubes.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			DiluentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of SamplesIn, indicates the non-default storage condition for the Diluent after samples are transferred to assay tubes.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			SDSBufferStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of SamplesIn, indicates the non-default storage condition for the SDSBuffer after samples are transferred to assay tubes.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			ReducingAgentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of SamplesIn, indicates the non-default storage condition for the ReducingAgent after samples are transferred to assay tubes.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			AlkylatingAgentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of SamplesIn, indicates the non-default storage condition for the AlkylatingAgent after samples are transferred to assay tubes.",
				IndexMatching->SamplesIn,
				Category->"Sample Preparation"
			},
			InjectionVoltageDurationProfiles->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{GreaterEqualP[0*Volt],GreaterP[0*Second]}..},
				Description->"For each member of SamplesIn, indicates the series of voltages and durations to apply onto the capillary while docked in the sample to electroinject proteins in the sample into the matrix in the capillary.",
				IndexMatching->SamplesIn,
				Category->"Separation"
			},
			SeparationVoltageDurationProfiles->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{GreaterEqualP[0*Volt],GreaterP[0*Minute]}..},
				Description->"For each member of SamplesIn, indicates the series of voltages and durations to apply onto the capillary while docked in running buffer to separate proteins by molecular weight as they migrate through the separation matrix in the capillary.",
				IndexMatching->SamplesIn,
				Category->"Separation"
			},
			(* Ladders *)
			Ladders->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Sample]|Model[Sample],
				Description->"A mixtures of known analytes that serve as reference for interpolation of the molecular weight of unknown samples in the experiment.",
				Category->"Ladders"
			},
			LadderStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Ladders, indicates the non-default storage condition.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderAnalytes->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{ObjectP[Model[Molecule]]..},
				Description->"For each member of Ladders, Indicates the Molecules in the ladder mixture.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderAnalyteMolecularWeights->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{GreaterP[0*Kilodalton]..},
				Description->"For each member of Ladders, indicates the molecular weights of analytes included in ladder.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderAnalyteLabels->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{_String..},
				Description->"For each member of Ladders, indicates the label of each analyte included in ladder.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderTotalVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Ladders, indicates the final volume in the assay tube prior to loading onto AssayContainer. Each tube contains a ladder, an InternalReference, and an SDSBuffer.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[1],
				Description->"For each member of Ladders, indicates the factor by which the ladder should be diluted by to reach working concentration.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Ladders, indicates the  volume of ladder required to reach its working concentration in LadderTotalVolume.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderPremadeMasterMixReagents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Ladders, indicates the premade master mix used for CESDS experiment, containing an SDS buffer, an internal standard, and reducing and / or alkylating agents (if applicable).",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderPremadeMasterMixDiluents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Ladders,indicates the solution used to dilute the premade master mix used to its working concentration.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderPremadeMasterMixReagentDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1],
				Description->"For each member of Ladders, indicates the factor by which the premade mastermix should be diluted by in the final assay tube.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderPremadeMasterMixVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Ladders, indicates the volume of the premade mastermix required to reach its final concentration.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderInternalReferences->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Ladders, indicates the internal standard stock solution added in sample preparation. The internal standard stock solution contains the analyte that serves as the reference by which Relative Migration Time is normalized. By default a 10 KDa marker is used.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderInternalReferenceDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1],
				Description->"For each member of Ladders, indicates the factor by which the InternalReference needs to be diluted to reach working concentration.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderInternalReferenceVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Ladders, indicates the volume of InternalReference to be diluted by a factor equal to InternalReferenceDilutionFactor to reach working concentration in the final assay volume containing all other components (i.e., Ladder SDS buffer, and reducing/alkylating agents).",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderConcentratedSDSBuffers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Ladders, indicates the SDS Buffer concentrate used to dilute and denature the sample.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderConcentratedSDSBufferDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1],
				Description->"For each member of Ladders, indicates the factor by which the ConcentratedSDSBuffer needs to be diluted to reach working concentration.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderConcentratedSDSBufferVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Ladders, indicates the volume of ConcentratedSDSBuffer to reach its working concentration in the final assay volume containing all other components (i.e., Ladder internal standard, and reducing/alkylating agents).",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderDiluents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Ladders, indicates the solution used to bring the assay tube to TotalVolume so that all components are at working concentration in the final assay volume containing all other components (i.e., Ladder internal standard, SDS buffer, and reducing/alkylating agents).",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderSDSBuffers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Ladders, indicates the SDS Buffer used to dilute and denature the sample.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderSDSBufferVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Ladders, indicates the volume of SDSBuffer to add to Ladder to reach working concentration in the final assay volume containing all other components (i.e., Ladder internal standard, and reducing/alkylating agents).",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderReducingAgents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Ladders, indicates the reducing agent, e.g., \[Beta]-mercaptoethanol or Dithiothreitol, added to the Ladder to reduce disulfide bridges in proteins.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderReducingAgentTargetConcentrations->{
				Format->Multiple,
				Class->VariableUnit,
				Pattern:>GreaterEqualP[0*Molar]|RangeP[0*VolumePercent,100*VolumePercent],
				Units->None,
				Description->"For each member of Ladders, indicates the final concentration of the ReducingAgent in the sample.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderReducingAgentVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Ladders, indicates the volume of the ReducingAgent added to the Ladder to reach working concentration in the final assay volume containing all other components (i.e., Ladder internal standard, SDSBuffer and alkylating agents).",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderAlkylatingAgents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Ladders, indicates the alkylating agent, e.g., Iodoacetamide, added to the Ladder to prevent protein fragmentation.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderAlkylatingAgentTargetConcentrations->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Molar],
				Units->Millimolar,
				Description->"For each member of Ladders, indicates the final concentration of the AlkylatingAgent in the sample.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderAlkylatingAgentVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Ladders, indicates the volume of the AlkylatingAgent added the sample.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderSedimentationSupernatantVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Ladders, indicates the volume of supernatant that should be aliquoted to assay AssayContainer after denaturation and centrifugation.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderInternalReferenceStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Ladders, indicates the non-default storage condition for the InternalReference after samples are transferred to assay tubes.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderConcentratedSDSBufferStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Ladders, indicates the non-default storage condition for the ConcentratedSDSBuffer after samples are transferred to assay tubes.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderDiluentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Ladders, indicates the non-default storage condition for the Diluent after samples are transferred to assay tubes.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderSDSBufferStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Ladders, indicates the non-default storage condition for the SDSBuffer after samples are transferred to assay tubes.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderReducingAgentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Ladders, indicates the non-default storage condition for the ReducingAgent after samples are transferred to assay tubes.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderAlkylatingAgentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Ladders, indicates the non-default storage condition for the AlkylatingAgent after samples are transferred to assay tubes.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderInjectionVoltageDurationProfiles->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{GreaterEqualP[0*Volt],GreaterP[0*Second]}..},
				Description->"For each member of Ladders, indicates the series of voltages and durations to apply onto the capillary while sampling Ladders for separation.",
				IndexMatching->Ladders,
				Category->"Ladders"
			},
			LadderSeparationVoltageDurationProfiles->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{GreaterEqualP[0*Volt],GreaterP[0*Minute]}..},
				Description->"For each member of Ladders, indicates the series of voltages and durations to apply onto the capillary while docked in running buffer to separate proteins by molecular weight as they migrate through the separation matrix in the capillary.",
				IndexMatching->Ladders,
				Category->"Ladders"
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
			StandardStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Standards, indicates the non-default storage condition.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardTotalVolumes->{
				Format->Multiple,
				Class->Real,
				Units->Microliter,
				Pattern:>GreaterEqualP[0*Microliter],
				Description->"For each member of Standards, indicates the final volume in the assay tube prior to loading onto AssayContainer. Each tube contains Standard  InternalReference,  SDSBuffer, and ReducingAgent and/or AlkylatingAgent.",
				IndexMatching->Standards,
				Category->"Standards"
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
				Description->"For each member of Standards, indicates the premade master mix used for CESDS experiment, containing an SDS buffer, an internal standard, and reducing and / or alkylating agents (if applicable).",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardPremadeMasterMixDiluents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards,indicates the solution used to dilute the premade master mix used to its working concentration.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardPremadeMasterMixReagentDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1],
				Description->"For each member of Standards, indicates the factor by which the premade mastermix should be diluted by in the final assay tube.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardPremadeMasterMixVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Standards, indicates the volume of the premade mastermix required to reach its final concentration.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardInternalReferences->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates the internal standard stock solution added in sample preparation. The internal standard stock solution contains the analyte that serves as the reference by which Relative Migration Time is normalized. By default a 10 KDa marker is used.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardInternalReferenceDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1],
				Description->"For each member of Standards, indicates the factor by which the InternalReference needs to be diluted to reach working concentration.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardInternalReferenceVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Standards, indicates the volume of InternalReference to be diluted by a factor equal to InternalReferenceDilutionFactor to reach working concentration in the final assay volume containing all other components (i.e., Standard SDS buffer, and reducing/alkylating agents).",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardConcentratedSDSBuffers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates the SDS Buffer concentrate used to dilute and denature the sample.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardConcentratedSDSBufferDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1],
				Description->"For each member of Standards, indicates the factor by which the ConcentratedSDSBuffer needs to be diluted to reach working concentration.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardConcentratedSDSBufferVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Standards, indicates the volume of ConcentratedSDSBuffer to reach its working concentration in the final assay volume containing all other components (i.e., Standard internal standard, and reducing/alkylating agents).",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardDiluents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates the solution used to bring the assay tube to TotalVolume so that all components are at working concentration in the final assay volume containing all other components (i.e., Standard internal standard, SDS buffer, and reducing/alkylating agents).",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardSDSBuffers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates the SDS Buffer used to dilute and denature the sample.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardSDSBufferVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Standards, indicates the volume of SDSBuffer to add to Standard to reach working concentration in the final assay volume containing all other components (i.e., Standard internal standard, and reducing/alkylating agents).",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardReducingAgents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates the reducing agent, e.g., \[Beta]-mercaptoethanol or Dithiothreitol, added to the Standard to reduce disulfide bridges in proteins.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardReducingAgentTargetConcentrations->{
				Format->Multiple,
				Class->VariableUnit,
				Pattern:>GreaterEqualP[0*Molar]|RangeP[0*VolumePercent,100*VolumePercent],
				Units->None,
				Description->"For each member of Standards, indicates the final concentration of the ReducingAgent in the sample.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardReducingAgentVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Standards, indicates the volume of the ReducingAgent added to the Standard to reach working concentration in the final assay volume containing all other components (i.e., Standard internal standard, SDSBuffer and alkylating agents).",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardAlkylatingAgents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Standards, indicates the alkylating agent, e.g., Iodoacetamide, added to the Standard to prevent protein fragmentation.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardAlkylatingAgentTargetConcentrations->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Molar],
				Units->Millimolar,
				Description->"For each member of Standards, indicates the final concentration of the AlkylatingAgent in the sample.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardAlkylatingAgentVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Standards, indicates the volume of the AlkylatingAgent added the sample.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardSedimentationSupernatantVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Standards, indicates the volume of supernatant that should be aliquoted to assay AssayContainer after denaturation and centrifugation.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardInternalReferenceStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Standards, indicates the non-default storage condition for the InternalReference after samples are transferred to assay tubes.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardConcentratedSDSBufferStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Standards, indicates the non-default storage condition for the ConcentratedSDSBuffer after samples are transferred to assay tubes.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardDiluentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Standards, indicates the non-default storage condition for the Diluent after samples are transferred to assay tubes.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardSDSBufferStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Standards, indicates the non-default storage condition for the SDSBuffer after samples are transferred to assay tubes.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardReducingAgentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Standards, indicates the non-default storage condition for the ReducingAgent after samples are transferred to assay tubes.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardAlkylatingAgentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Standards, indicates the non-default storage condition for the AlkylatingAgent after samples are transferred to assay tubes.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardInjectionVoltageDurationProfiles->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{GreaterEqualP[0*Volt],GreaterP[0*Second]}..},
				Description->"For each member of Standards, indicates the series of voltages and durations to apply onto the capillary while sampling Standards for separation.",
				IndexMatching->Standards,
				Category->"Standards"
			},
			StandardSeparationVoltageDurationProfiles->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{GreaterEqualP[0*Volt],GreaterP[0*Minute]}..},
				Description->"For each member of Standards, indicates the series of voltages and durations to apply onto the capillary while docked in running buffer to separate proteins by molecular weight as they migrate through the separation matrix in the capillary.",
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
				Category->"Blanks"
			},
			BlankTotalVolumes->{
				Format->Multiple,
				Class->Real,
				Units->Microliter,
				Pattern:>GreaterEqualP[0*Microliter],
				Description->"For each member of Blanks, indicates the final volume in the assay tube prior to loading onto AssayContainer. Each tube contains Blank, InternalReference,  SDSBuffer, and ReducingAgent and/or AlkylatingAgent.",
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
				Description->"For each member of Blanks, indicates the premade master mix used for CESDS experiment, containing an SDS buffer, an internal Blank, and reducing and / or alkylating agents (if applicable).",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankPremadeMasterMixDiluents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks,indicates the solution used to dilute the premade master mix used to its working concentration.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankPremadeMasterMixReagentDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1],
				Description->"For each member of Blanks, indicates the factor by which the premade mastermix should be diluted by in the final assay tube.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankPremadeMasterMixVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Blanks, indicates the volume of the premade mastermix required to reach its final concentration.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankInternalReferences->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates the internal Blank stock solution added in sample preparation. The internal Blank stock solution contains the analyte that serves as the reference by which Relative Migration Time is normalized. By default a 10 KDa marker is used.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankInternalReferenceDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1],
				Description->"For each member of Blanks, indicates the factor by which the InternalReference needs to be diluted to reach working concentration.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankInternalReferenceVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Blanks, indicates the volume of InternalReference to be diluted by a factor equal to InternalReferenceDilutionFactor to reach working concentration in the final assay volume containing all other components (i.e., Blank SDS buffer, and reducing/alkylating agents).",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankConcentratedSDSBuffers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates the SDS Buffer concentrate used to dilute and denature the sample.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankConcentratedSDSBufferDilutionFactors->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[1],
				Description->"For each member of Blanks, indicates the factor by which the ConcentratedSDSBuffer needs to be diluted to reach working concentration.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankConcentratedSDSBufferVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Blanks, indicates the volume of ConcentratedSDSBuffer to reach its working concentration in the final assay volume containing all other components (i.e., Blank internal Blank, and reducing/alkylating agents).",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankDiluents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates the solution used to bring the assay tube to TotalVolume so that all components are at working concentration in the final assay volume containing all other components (i.e., Blank internal Blank, SDS buffer, and reducing/alkylating agents).",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankSDSBuffers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates the SDS Buffer used to dilute and denature the sample.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankSDSBufferVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Blanks, indicates the volume of SDSBuffer to add to Blank to reach working concentration in the final assay volume containing all other components (i.e., Blank internal Blank, and reducing/alkylating agents).",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankReducingAgents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates the reducing agent, e.g., \[Beta]-mercaptoethanol or Dithiothreitol, added to the Blank to reduce disulfide bridges in proteins.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankReducingAgentTargetConcentrations->{
				Format->Multiple,
				Class->VariableUnit,
				Pattern:>GreaterEqualP[0*Molar]|RangeP[0*VolumePercent,100*VolumePercent],
				Units->None,
				Description->"For each member of Blanks, indicates the final concentration of the ReducingAgent in the sample.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankReducingAgentVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Blanks, indicates the volume of the ReducingAgent added to the Blank to reach working concentration in the final assay volume containing all other components (i.e., Blank internal Blank, SDSBuffer and alkylating agents).",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankAlkylatingAgents->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Sample]|Object[Sample],
				Description->"For each member of Blanks, indicates the alkylating agent, e.g., Iodoacetamide, added to the Blank to prevent protein fragmentation.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankAlkylatingAgentTargetConcentrations->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Molar],
				Units->Millimolar,
				Description->"For each member of Blanks, indicates the final concentration of the AlkylatingAgent in the sample.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankAlkylatingAgentVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Blanks, indicates the volume of the AlkylatingAgent added the sample.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankSedimentationSupernatantVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of Blanks, indicates the volume of supernatant that should be aliquoted to assay AssayContainer after denaturation and centrifugation.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankInternalReferenceStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Blanks, indicates the non-default storage condition for the InternalReference after samples are transferred to assay tubes.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankConcentratedSDSBufferStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Blanks, indicates the non-default storage condition for the ConcentratedSDSBuffer after samples are transferred to assay tubes.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankDiluentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Blanks, indicates the non-default storage condition for the Diluent after samples are transferred to assay tubes.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankSDSBufferStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Blanks, indicates the non-default storage condition for the SDSBuffer after samples are transferred to assay tubes.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankReducingAgentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Blanks, indicates the non-default storage condition for the ReducingAgent after samples are transferred to assay tubes.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankAlkylatingAgentStorageConditions->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of Blanks, indicates the non-default storage condition for the AlkylatingAgent after samples are transferred to assay tubes.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankInjectionVoltageDurationProfiles->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{GreaterEqualP[0*Volt],GreaterP[0*Second]}..},
				Description->"For each member of Blanks, indicates the series of voltages and durations to apply onto the capillary while sampling Blanks for separation.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			BlankSeparationVoltageDurationProfiles->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{GreaterEqualP[0*Volt],GreaterP[0*Minute]}..},
				Description->"For each member of Blanks, indicates the series of voltages and durations to apply onto the capillary while docked in running buffer to separate proteins by molecular weight as they migrate through the separation matrix in the capillary.",
				IndexMatching->Blanks,
				Category->"Blanks"
			},
			CartridgeStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[SampleStorageTypeP,Disposal],
				Description->"The non-default storage condition for the Cartridge after the protocol is completed.",
				Category->"Storage Information"
			},
			(* Primitives, Protocols, and Placements*)
			SamplePreparationPrimitives->{
				Format->Multiple,
				Class->Expression,
				Pattern:>SampleManipulationP|SamplePreparationP,
				Description->"A set of instructions specifying the preparation of samples, ladders, standards, and blanks for capillary gel Electrophoresis SDS experiments, including dilution in SDS buffer, spiking internal standards, and addition of any reducing and / or alkylating agents.",
				Category->"Sample Preparation"
			},
			SamplePreparationProtocol->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Protocol,SampleManipulation]|Object[Protocol,RoboticSamplePreparation],
				Description->"The sample manipulation protocol used to prepare samples for capillary gel Electrophoresis SDS experiments.",
				Category->"Sample Preparation"
			},
			PostIncubationTransferSMPrimitives->{
				Format->Multiple,
				Class->Expression,
				Pattern:>SampleManipulationP|SamplePreparationP,
				Description->"A set of instructions specifying the transfer of samples, ladders, standards, and blanks from sample preparation plate to assay plate after incubation and centrifugation for capillary gel Electrophoresis SDS experiments.",
				Category->"Sample Preparation"
			},
			PostIncubationTransferSMProtocol->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Protocol,SampleManipulation]|Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation]|Object[Notebook,Script],
				Description->"The sample manipulation protocol used to transfer of samples, ladders, standards, and blanks from sample preparation plate to assay plate after incubation and centrifugation for capillary gel Electrophoresis SDS experiments.",
				Category->"Sample Preparation"
			},
			IncubationProtocol->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Protocol,PCR],
				Description->"The PCR protocol used to heat denature samples, ladders, Standards, and Blanks for capillary ELISA experiments.",
				Category->"Sample Preparation"
			},
			CentrifugationProtocol->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Protocol,Centrifuge],Object[Protocol,ManualSamplePreparation]],
				Description->"The centrifugation protocol used to remove any precipitates after denaturation in preparation for capillary gel Electrophoresis SDS experiments.",
				Category->"Sample Preparation"
			},
			InstrumentPlacements->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Model[Container]|Object[Container],Null},
				Description->"A list of placements used to move reagents into position in the instrument.",
				Headers->{"Object to Place","Placement Tree"},
				Category->"Sample Preparation",
				Developer->True
			},
			InstrumentPressureCapPlacements->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Model[Container]|Object[Container],Null},
				Description->"A list of placements used to move reagents that require a pressure cap into position in the instrument.",
				Headers->{"Object to Place","Placement Tree"},
				Category->"Sample Preparation",
				Developer->True
			},
			CartridgePlacement->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Model[Container,ProteinCapillaryElectrophoresisCartridge]|Object[Container,ProteinCapillaryElectrophoresisCartridge],Null},
				Description->"A placement used to move the Cartridge into its position in the instrument.",
				Headers->{"Object to Place","Placement Tree"},
				Category->"Sample Preparation",
				Developer->True
			},
			AssayPlatePlacement->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Model[Container]|Object[Container],Null},
				Description->"A placement used to move the AssayPlate into position in the instrument.",
				Headers->{"Object to Place","Placement Tree"},
				Category->"Sample Preparation",
				Developer->True
			},
			CleanupCartridgePlacement->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Model[Container]|Object[Container],Null},
				Description->"A placement used to move the CartridgeCleanup solution into position in the instrument.",
				Headers->{"Object to Place","Placement Tree"},
				Category->"Sample Preparation",
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
			}
		}
	}
];
