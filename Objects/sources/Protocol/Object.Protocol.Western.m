

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, Western], {
	Description->"A protocol for performing a capillary western assay to assess specific protein identities and concentrations.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		MolecularWeightRange -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WesternMolecularWeightRangeP,
			Description -> "The molecular weight range that is inspected in this assay (LowMolecularWeight = 2-40 kDa; MidMolecularWeight = 12-230 kDa; HighMolecularWeight = 66-440kDa).",
			Category -> "General",
			Abstract -> True
		},
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument,Western]|Model[Instrument,Western],
			Description->"The instrument used to perform the capillary electrophoresis-based western assay.",
			Category -> "General"
		},
		DetectionMode->{
			Format->Single,
			Class->Expression,
			Pattern:>WesternDetectionP,
			Description->"The physical phenomenon observed as the source of the signal in this experiment.",
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
			Description -> "The name of the protocol file containing the run parameters.",
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
			Description -> "The file path of the data file generated at the conclusion of the experiment.",
			Category -> "General",
			Developer -> True
		},
		Denaturing->{
			Format->Single,
			Class->Expression,
			Pattern :> BooleanP,
			Description->"Indicates if the mixtures of input samples and loading buffer are heated prior to being run on the western assay.",
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
			Description->"The biotinylated ladder which is used as a standard reference ladder in the Experiment. After electrophoretic separation, the ladder is labeled with the LadderPeroxidaseReagent so that each protein band is visible during the signal detection step.",
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
			Description->"The plate that is loaded with input samples, antibodies, buffers, and detection reagents, then inserted into the Instrument.",
			Category->"Matrix & Sample Loading"
		},
		AssayPlatePrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description -> "A set of instructions specifying the loading of the AssayPlate with denatured input samples, antibodies, buffers, and detection reagents.",
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
		AssayPlateUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> RoboticSamplePreparationP,
			Description -> "A set of instructions specifying the loading of the AssayPlate with denatured input samples, antibodies, buffers, and detection reagents.",
			Category -> "Matrix & Sample Loading"
		},
		AssayPlatePrep -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, RoboticSamplePreparation],
			Description -> "A sample manipulation protocol used to load the AssayPlate.",
			Category -> "Matrix & Sample Loading"
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
		CapillaryCartridge->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Item,Consumable],
				Model[Item,Consumable]
			],
			Description->"The specialized set of capillaries in which the separation, immobilization, labeling, and imaging of input proteins occurs.",
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
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of WashBuffer that is loaded into each of the 15 appropriate wells of the AssayPlate.",
			Category->"Separation & Immobilization"
		},
		BlockingBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the buffer that is incubated with the capillary after the UVExposureTime. Incubation in this buffer reduces non-specific antibody binding to residual matrix present in the capillary.",
			Category->"Blocking"
		},
		BlockingBufferVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of BlockingBuffer that is aliquotted into the appropriate wells of the AssayPlate.",
			Category->"Blocking"
		},
		LadderBlockingBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The buffer that is incubated with the capillary containing the Ladder during both the BlockingTime and the PrimaryIncubationTime.",
			Category->"Blocking"
		},
		LadderBlockingBufferVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of LadderBlockingBuffer that is aliquotted into the appropriate wells of the AssayPlate.",
			Category->"Blocking"
		},
		PlaceholderBlockingBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The buffer which is used in place of the BlockingBuffer, PrimaryAntibody, and SecondaryAntibody for each of the 25 capillaries without input samples or Ladder.",
			Category->"Matrix & Sample Loading",
			Developer->True
		},
		BlockingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration of the BlockingBuffer incubation after the UVExposureTime.",
			Category->"Blocking"
		},
		PrimaryAntibodies->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the antibody that selectively binds to a specific protein in the input sample.",
			Category->"Antibody Labeling"
		},
		PrimaryAntibodyVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the amount of the concentrated stock solution of input PrimaryAntibody that is mixed wth the PrimaryAntibodyDiluent and StandardPrimaryAntibody before a portion of the mixture, the PrimaryAntibodyLoadingVolume, is loaded into the AssayPlate.",
			Category->"Antibody Labeling"
		},
		PrimaryAntibodyStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{(SampleStorageTypeP|Disposal)..},
			Description->"For each member of SamplesIn, the storage conditions under which PrimaryAntibody should be stored after its usage in the experiment.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		PrimaryAntibodyDiluents->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the buffer that is mixed with the PrimaryAntibody to reduce the concentration of the antibody solution that is loaded into the AssayPlate.",
			Category->"Antibody Labeling"
		},
		PrimaryAntibodyDilutionFactors->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0,1],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, a measure of the ratio of PrimaryAntibodyVolume to the diluted PrimaryAntibody (PrimaryAntibody plus PrimaryAntibodyDiluent plus StandardPrimaryAntibody). A PrimaryAntibodyDilutionFactor of 0.02 indicates that the diluted PrimaryAntibody solution is comprised of 1 part concentrated PrimaryAntibody and 49 parts of either PrimaryAntibodyDiluent or a mixture of PrimaryAntibodyDiluent and StandardPrimaryAntibody.",
			Category->"Antibody Labeling"
		},
		PrimaryAntibodyDiluentVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the amount of the PrimaryAntibodyDiluent that is mixed with the PrimaryAntibody and the StandardPrimaryAntibody before a portion of the mixture, the PrimaryAntibodyLoadingVolume, is loaded into the AssayPlate.",
			Category->"Antibody Labeling"
		},
		SystemStandards->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, indicates if a StandardPrimaryAntibody and secondary antibody-HRP conjugate will be used to detect a standard protein present in the ConcentratedLoadingBuffer. This system standard labeling can be used to troubleshoot the cause of aberrant data by comparing signal intensities between capillaries and between protocols.",
			Category->"Antibody Labeling"
		},
		StandardPrimaryAntibodies->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample]|Object[Sample]|Model[Sample],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the solution containing a control antibody which detects the system control protein in the LoadingBuffer, that is mixed with the PrimaryAntibody and the PrimaryAntibodyDiluent.",
			Category->"Antibody Labeling"
		},
		StandardPrimaryAntibodyVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the amount of the mixture of PrimaryAntibody, PrimaryAntibodyDiluent, and StandardPrimaryAntibody that is loaded into the appropriate well of the AssayPlate.",
			Category->"Antibody Labeling"
		},
		StandardPrimaryAntibodyStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{(SampleStorageTypeP|Disposal)..},
			Description->"For each member of SamplesIn, the storage conditions under which StandardPrimaryAntibody should be stored after its usage in the experiment.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		PrimaryAntibodyLoadingVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of each mixture of PrimaryAntibody, PrimaryAntibodyDiluent, and StandardPrimaryAntibody that is loaded into the appropriate wells of the AssayPlate.",
			Category->"Antibody Labeling"
		},
		AntibodyPlate->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation -> Object[Container, Plate] | Model[Container, Plate],
			Description->"The plate in which the PrimaryAntibodies are mixed with the PrimaryAntibodyDiluents and StandardPrimaryAntibodies.",
			Category->"Antibody Labeling"
		},
		AntibodyPlatePrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description -> "A set of instructions specifying the loading of the AntibodyPlate used to mix the PrimaryAntibodies, PrimaryAntibodyDiluents, and StandardPrimaryAntibodies.",
			Category -> "Antibody Labeling"
		},
		AntibodyPlateManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation],
			Description->"A sample manipulation protocol used to load and mix the AntibodyPlate.",
			Category->"Antibody Labeling"
		},
		PrimaryIncubationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the capillary is incubated with the PrimaryAntibody.",
			Category->"Antibody Labeling"
		},
		PrimaryWashTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the capillary is incubated with the WashBuffer after the PrimaryAntibody.",
			Category->"Antibody Labeling"
		},
		NumberOfPrimaryWashes->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Description->"The number of times the capillary is incubated with the WashBuffer for the PrimaryWashTime after the PrimaryIncubationTime.",
			Category->"Antibody Labeling"
		},
		SecondaryAntibodies->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the antibody-HRP conjugate solution is be used to detect the PrimaryAntibody.",
			Category->"Antibody Labeling"
		},
		SecondaryAntibodyVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the amount of SecondaryAntibody solution that is aliquotted into the appropriate wells of the western assay plate.",
			Category->"Antibody Labeling"
		},
		SecondaryAntibodyStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{(SampleStorageTypeP|Disposal)..},
			Description->"For each member of SamplesIn, the storage conditions under which SecondaryAntibody should be stored after its usage in the experiment.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		StandardSecondaryAntibodies->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the concentrated solution containing a control antibody-HRP conjugate which detects the StandardPrimaryAntibody. The StandardSecondaryAntibody is mixed with the SecondaryAntibody in cases where the PrimaryAntibody and StandardPrimaryAntibody are not derived from the same mammal - when the PrimaryAntibody is human or goat-derived.",
			Category->"Antibody Labeling"
		},
		StandardSecondaryAntibodyVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the amount of the concentrated solution of the StandardSecondaryAntibody that is mixed with the SecondaryAntibody in cases where the PrimaryAntibody and StandardPrimaryAntibody are not derived from the same mammal - when the PrimaryAntibody is human or goat-derived.",
			Category->"Antibody Labeling"
		},
		StandardSecondaryAntibodyStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{(SampleStorageTypeP|Disposal)..},
			Description->"For each member of SamplesIn, the storage conditions under which StandardSecondaryAntibody should be stored after its usage in the experiment.",
			Category->"Sample Storage",
			IndexMatching->SamplesIn
		},
		SecondaryIncubationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the capillary is incubated with the SecondaryAntibody or the LadderPeroxidaseReagent (for the capillary containing the Ladder).",
			Category->"Antibody Labeling"
		},
		SecondaryWashTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the capillary is incubated with the WashBuffer after the SecondaryAntibody.",
			Category->"Antibody Labeling"
		},
		NumberOfSecondaryWashes->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Description->"The number of times the capillary is incubated with the WashBuffer for the SecondaryWashTime after the SecondaryIncubationTime.",
			Category->"Antibody Labeling"
		},
		LadderPeroxidaseReagent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The sample or model of streptavidin-containing HRP solution which binds to the biotinylated ladder provided by the instrument supplier.",
			Category->"Antibody Labeling"
		},
		LadderPeroxidaseReagentStorageCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"The storage condition under which the LadderPeroxidaseReagent should be stored after its usage in the experiment.",
			Category->"Sample Storage"
		},
		LadderPeroxidaseReagentVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of streptavidin-HRP conjugate solution that is added to the appropriate well of the AssayPlate.",
			Category->"Antibody Labeling"
		},
		LuminescenceReagent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The solution, which defaults to a mixture of luminol and peroxide, that reacts with the horseradish peroxidase (HRP) attached to the SecondaryAntibody to give off chemiluminesence which is observed during the SignalDetectionTimes.",
			Category->"Imaging"
		},
		LuminescenceReagentVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of the LuminescenceReagent mixture that is aliquotted into the appropriate wells of the AssayPlate. The HRPReagent reacts with the horseradish peroxidase (HRP) attached to the SecondaryAntibody to give off chemiluminesence which is observed during the SignalDetectionTimes.",
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
