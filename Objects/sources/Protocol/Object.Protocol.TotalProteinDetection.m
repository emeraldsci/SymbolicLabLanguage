

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol,TotalProteinDetection],{
	Description->"A protocol for performing a capillary electrophoresis-based total protein labeling and detection assay.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		MolecularWeightRange -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WesternMolecularWeightRangeP,
			Description -> "The molecular weight range that is inspected in this assay (LowMolecularWeight = 2-40 kDa; MidMolecularWeight = 12-230 kDa; HighMolecularWeight = 66-440kDa).",
			Category -> "General",
			Abstract -> True
		},
		DetectionMode->{
			Format->Single,
			Class->Expression,
			Pattern:>WesternDetectionP,
			Description->"The physical phenomenon observed as the source of the signal in this experiment.",
			Category -> "General"
		},
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument,Western]|Model[Instrument,Western],
			Description->"The instrument used to perform the capillary electrophoresis-based total protein labeling and detection assay.",
			Category -> "General"
		},
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the folder containing the protocol file which contains the run parameters.",
			Category -> "General",
			Developer -> True
		},
		MethodFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The name (including the file path) of the protocol file which contains the run parameters.",
			Category -> "General",
			Developer -> True
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the folder containing the data file generated at the conclusion of the experiment.",
			Category -> "General",
			Developer -> True
		},
		DataFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The name (including the file path) of the data file generated at the conclusion of the experiment.",
			Category -> "General",
			Developer -> True
		},
		Denaturing->{
			Format->Single,
			Class->Expression,
			Pattern :> BooleanP,
			Description->"Indicates if the mixtures of input samples and loading buffer are heated prior to being run on the labeling and detection assay.",
			Category->"Denaturation"
		},
		DenaturingTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"The temperature which the mixture of input samples and loading buffer is heated to before being transferred to the AssayPlate.",
			Category->"Denaturation"
		},
		DenaturingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Minute,
			Description->"The duration for which the mixture of input samples and loading buffer is heated to DenaturingTemperature before being transferred to the AssayPlate.",
			Category->"Denaturation"
		},
		SamplePlateDenaturation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Protocol,Incubate],Object[Protocol,ManualSamplePreparation]],
			Description->"An incubation protocol used to denature the mixture of input samples and loading buffer present in the SamplePlate after the SamplePlateManipulation.",
			Category->"Denaturation"
		},
		SeparatingMatrixLoadTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the separating matrix is loaded into the capillary.",
			Category->"Matrix & Sample Loading"
		},
		StackingMatrixLoadTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the stacking matrix is loaded into the capillary.",
			Category->"Matrix & Sample Loading"
		},
		SampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the amount that is mixed with the prepared LoadingBuffer before denaturation and being loaded into the AssayPlate.",
			Category->"Matrix & Sample Loading"
		},
		ConcentratedLoadingBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The fluorescent standard, system control protein, and sample buffer-containing solution that is mixed with either the Denaturant or deionized water to make the LoadingBuffer. The fluorescent standards present are used to normalize the data post-run to take into account small differences in how the samples separate between capillaries.",
			Category->"Matrix & Sample Loading"
		},
		ConcentratedLoadingBufferVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of the ConcentratedLoadingBuffer that is mixed with either the Denaturant or deionized water, depending on if Denaturing is True or False.",
			Category->"Matrix & Sample Loading"
		},
		Denaturant->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The buffer, containing the protein denaturing agent used to denature proteins present in the input samples, that is mixed with ConcentratedLoadingBuffer to make the LoadingBuffer.",
			Category->"Matrix & Sample Loading"
		},
		DenaturantVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of Denaturant that is mixed with ConcentratedLoadingBuffer to make the LoadingBuffer.",
			Category->"Matrix & Sample Loading"
		},
		LoadingBufferDiluent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The water which is mixed with the ConcentratedLoadingBuffer when Denaturing is set to False.",
			Category->"Matrix & Sample Loading",
			Developer->True
		},
		WaterVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of deionized water that is mixed with the ConcentratedLoadingBuffer in lieu of the Denaturant if Denaturing is set to False.",
			Category->"Matrix & Sample Loading"
		},
		LoadingBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The mixture of ConcentratedLoadingBuffer and either Denaturant or deionized water that is mixed with the input samples before denaturation.",
			Category->"Matrix & Sample Loading"
		},
		LoadingBufferVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the amount of prepared LoadingBuffer (with ConcentratedLoadingBuffer and either Denaturant or deionized water already added) that is mixed with the input sample before the mixture is denatured, and a portion of the mixture, the LoadingVolume, is loaded into the AssayPlate.",
			Category->"Matrix & Sample Loading"
		},
		PlaceholderBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The buffer which is mixed with the LoadingBuffer in place of an input sample for each of the 25 capillaries without input samples or Ladder.",
			Category->"Matrix & Sample Loading",
			Developer->True
		},
		LoadingVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of each mixture of input sample and LoadingBuffer that is loaded into the AssayPlate after sample denaturation.",
			Category->"Matrix & Sample Loading"
		},
		Ladder->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The biotinylated ladder which is used as a standard reference ladder in the Experiment. After electrophoretic separation, the ladder is labeled with the PeroxidaseReagent so that each protein band is visible during the signal detection step.",
			Category->"Matrix & Sample Loading"
		},
		LadderVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The volume of the Ladder that is aliquotted into its well in the AssayPlate.",
			Category->"Matrix & Sample Loading"
		},
		SamplePlate->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation -> Object[Container, Plate] | Model[Container, Plate],
			Description->"The plate in which the input samples and LoadingBuffer are mixed and denatured.",
			Category->"Matrix & Sample Loading"
		},
		SamplePlatePrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description -> "A set of instructions specifying the loading of the SamplePlate with input samples and LoadingBuffer.",
			Category -> "Matrix & Sample Loading"
		},
		SamplePlateManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation],
			Description->"A sample manipulation protocol used to load the SamplePlate.",
			Category->"Matrix & Sample Loading"
		},
		AssayPlate->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Plate,Irregular] | Model[Container,Plate,Irregular],
			Description->"The plate that is loaded with input samples, labeling reagents, detection agents, and buffers, then inserted into the Instrument.",
			Category->"Matrix & Sample Loading"
		},
		AssayPlatePrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description -> "A set of instructions specifying the loading of the AssayPlate with denatured input samples, detection agents, and buffers.",
			Category -> "Matrix & Sample Loading"
		},
		AssayPlateManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation],
			Description->"A sample manipulation protocol used to load the AssayPlate.",
			Category->"Matrix & Sample Loading"
		},
		LabelingReagentPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description -> "A set of instructions specifying the loading of the AssayPlate with the LabelingReagent.",
			Category -> "Matrix & Sample Loading"
		},
		LabelingReagentManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation],
			Description->"A sample manipulation protocol used to load the AssayPlate with LabelingReagent.",
			Category->"Matrix & Sample Loading"
		},
		AssayPlatePlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Container]|Model[Container],Null},
			Description->"A list of placements used to place the AssayPlate into the correct position of the Instrument.",
			Category->"Matrix & Sample Loading",
			Developer->True,
			Headers->{"Assay Plate Object","Destination Position"}
		},
		PipetteTips -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item]|Object[Item],
			Description -> "Pipette tips used to pop any bubbles present in the Separation Matrix wells of the AssayPlate prior to loading the AssayPlate into the Instrument.",
			Category -> "Matrix & Sample Loading",
			Developer->True
		},
		Pipette->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Instrument,Pipette],
				Object[Instrument,Pipette]
			],
			Description->"The pipette used to transfer the Labeling Reagent into the appropriate wells of the AssayPlate.",
			Developer->True,
			Category -> "Matrix & Sample Loading"
		},
		SecondaryPipetteTips -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "Pipette tips used to transfer the LabelingReagent into the appropriate wells of the AssayPlate.",
			Developer->True,
			Category -> "Matrix & Sample Loading"
		},
		CapillaryCartridge->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Item,Consumable],
				Model[Item,Consumable]
			],
			Description->"The specialized set of capillaries in which the separationn, immobilization, labeling, and imaging of input proteins occurs.",
			Category->"Matrix & Sample Loading"
		},
		CapillaryPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Item]|Model[Item],Null},
			Description->"A list of placements used to place the CapillaryCartridge into the correct position of the Instrument.",
			Category->"Matrix & Sample Loading",
			Developer->True,
			Headers->{"Capillary Object","Destination Position"}
		},
		SampleLoadTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the samples and ladder are loaded into their respective capillaries.",
			Category->"Matrix & Sample Loading"
		},
		Voltage->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"The voltage applied during the electrophoretic separation step, which separates proteins present in the input samples by their molecular weight.",
			Category->"Separation & Immobilization"
		},
		SeparationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the Voltage is applied across the capillaries to separate macromolecules.",
			Category->"Separation & Immobilization"
		},
		UVExposureTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the capillary is exposed to UV-light for protein cross-linking to the capillary.",
			Category->"Separation & Immobilization"
		},
		WashBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The buffer that is incubated with the capillary between blocking and labeling steps to remove excess reagents.",
			Category->"Separation & Immobilization"
		},
		WashBufferVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milliliter],
			Units->Milliliter,
			Description->"The amount of WashBuffer that is loaded into each appropriate well of the AssayPlate.",
			Category->"Separation & Immobilization"
		},
		LabelingReagent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The biotin-containing reagent used to label all proteins present in the input samples.",
			Category->"Total Protein Labeling"
		},
		LabelingReagentVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of LabelingReagent that is aliquotted into each appropriate well of the AssayPlate.",
			Category->"Total Protein Labeling"
		},
		LabelingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the capillary is incubated with the LabelingReagent.",
			Category->"Total Protein Labeling"
		},
		BlockingBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The buffer to be incubated with the capillary after LabelingTime.",
			Category->"Total Protein Labeling"
		},
		BlockingBufferVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of BlockingBuffer that is aliquotted into the appropriate wells of the AssayPlate.",
			Category->"Total Protein Labeling"
		},
		LadderBlockingBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The buffer that is incubated with the capillary containing the Ladder during both the BlockingTime and the LabelingTime.",
			Category->"Total Protein Labeling"
		},
		LadderBlockingBufferVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of LadderBlockingBuffer that is aliquotted into the appropriate wells of the AssayPlate.",
			Category->"Total Protein Labeling"
		},
		PlaceholderBlockingBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The buffer which is used in place of the LabelingReagent, BlockingBuffer, and PeroxidaseReagent for each of the 25 capillaries without input samples or Ladder.",
			Category->"Matrix & Sample Loading",
			Developer->True
		},
		BlockingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration of the BlockingBuffer incubation after the LabelingTime.",
			Category->"Total Protein Labeling"
		},
		BlockWashTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the capillary is incubated with the WashBuffer after the BlockingBuffer.",
			Category->"Total Protein Labeling"
		},
		NumberOfBlockWashes->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Description->"The number of times the capillary is incubated with the WashBuffer for the BlockWashTime after the BlockingTime.",
			Category->"Total Protein Labeling"
		},
		PeroxidaseReagent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The sample or model of streptavidin-containing HRP solution which binds to proteins that have been labeled with biotin and the biotinylated ladder.",
			Category->"Total Protein Labeling"
		},
		PeroxidaseReagentStorageCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"The storage condition under which the PeroxidaseReagent should be stored after its usage in the experiment.",
			Category->"Sample Storage"
		},
		PeroxidaseReagentVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of PeroxidaseReagent that is added to the appropriate well of the AssayPlate.",
			Category->"Total Protein Labeling"
		},
		PeroxidaseIncubationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the capillary is incubated with the PeroxidaseReagent.",
			Category->"Total Protein Labeling"
		},
		PeroxidaseWashTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the capillary is incubated with the WashBuffer after the PeroxidaseReagent.",
			Category->"Total Protein Labeling"
		},
		NumberOfPeroxidaseWashes->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Description->"The number of times the capillary is incubated with the WashBuffer for the PeroxidaseWashTime after the PeroxidaseIncubationTime.",
			Category->"Total Protein Labeling"
		},
		LuminescenceReagent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The solution, which defaults to a mixture of luminol and peroxide, that reacts with the PeroxidaseReagent to give off chemiluminesence which is observed during the SignalDetectionTimes.",
			Category->"Imaging"
		},
		LuminescenceReagentVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of the LuminescenceReagent mixture that is aliquotted into the appropriate wells of the AssayPlate. The HRPReagent reacts with the PeroxidaseReagent to give off chemiluminesence which is observed during the SignalDetectionTimes.",
			Category->"Imaging"
		},
		SignalDetectionTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The exposure times for signal detection.",
			Category->"Imaging"
		},
		MethodFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "The CompassForSW file containing the run information and generated data.",
			Category -> "Experimental Results"
		},
		DataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "The CSV file containing the unprocessed data generated by the instrument.",
			Category -> "Experimental Results"
		}
	}
}];
