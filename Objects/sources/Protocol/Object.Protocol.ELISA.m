(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, ELISA],
	{
		Description -> "A protocol for performing a Enzyme-Linked Immunosorbent Assay (ELISA) experiment on the provided samples for the detection and quantification of an analyte using antibodies.",
		CreatePrivileges -> None,
		Cache -> Session,
		Fields -> {
			(*===General Information===*)
			Method -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> ELISAMethodP,
				Description -> "The format used for ELISA analysis in this unit operation.",
				Category -> "General"
			},
			Instrument -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Object[Instrument, LiquidHandler], Model[Instrument, LiquidHandler]}],
				Relation -> Object[Instrument, LiquidHandler] | Model[Instrument, LiquidHandler],
				Description -> "The instrument integrates a shaker, plate washer, and plate reader, and is used to dispense reagents into ELISA plates and transfer them between modules.",
				Category -> "General"
			},
			DetectionMode -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> AbsorbanceIntensity|FluorescenceIntensity|LuminescenceIntensity,
				Description -> "The type of detection method used to measure the signal generated from the enzyme substrate reaction to quantify the target analyte during this assay.",
				Category -> "General"
			},
			SampleAssemblyPlates -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container, Plate], Object[Container, Plate]}],
				Relation -> Model[Container, Plate]|Object[Container, Plate],
				Description -> "The deep well plates used to dilute samples, standards, spiking samples, mixing samples and antibodies, and antibody-sample complex incubation before loading them onto ELISAPlate(s).",
				Category -> "General"
			},
			ELISAPlate -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container, Plate], Object[Container, Plate]}],
				Relation -> Model[Container, Plate]|Object[Container, Plate],
				Description -> "The plate that serves as the solid-phase support for the enzyme-linked immunosorbent assay, where samples, standards, and blanks are loaded.",
				Category -> "General"
			},
			SecondaryELISAPlate -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container, Plate], Object[Container, Plate]}],
				Relation -> Model[Container, Plate]|Object[Container, Plate],
				Description -> "The second plate that serves as the solid-phase support for the enzyme-linked immunosorbent assay, where samples, standards, and blanks are loaded.",
				Category -> "General"
			},
			TertiaryELISAPlate -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container, Plate], Object[Container, Plate]}],
				Relation -> Model[Container, Plate]|Object[Container, Plate],
				Description -> "The third plate that serves as the solid-phase support for the enzyme-linked immunosorbent assay, where samples, standards, and blanks are loaded.",
				Category -> "General"
			},
			NumberOfReadings -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Units -> None,
				Description -> "The number of redundant readings taken by the detector and averaged over per each well.",
				Category -> "Absorbance Measurement"
			},
			TargetAntigens -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[Model[Molecule]],
				Relation -> Model[Molecule],
				Description -> "For each member of SamplesIn, the analyte molecule (e.g., peptide, protein, and hormone) detected and quantified in this assay.",
				Category -> "General",
				IndexMatching -> SamplesIn
			},
			SampleAssemblyPrimitives -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleManipulationP|SamplePreparationP,
				Description -> "A set of SampleManipulation instructions specifying the dilution, spiking, and antibody mixing of Samples, Standards, and Blanks.",
				Category -> "General"
			},
			AntibodyAntigenDilutionPrimitives -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleManipulationP|SamplePreparationP,
				Description -> "A set of SampleManipulation instructions specifying the dilution of antibodies and reference antigen using their corresponding diluents.",
				Category -> "General"
			},
			CoatingPlateAssemblyPrimitives -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleManipulationP|SamplePreparationP,
				Description -> "A set of SampleManipulation instructions specifying the coating of ELISAPlate(s).",
				Category -> "General"
			},
			ELISAPrimitives -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ELISAPrimitivesP,
				Description -> "A set of SampleManipulation instructions specifying the blocking, immunosorbent steps, substrate incubation, and plate reading performed in the ELISA instrument.",
				Category -> "General"
			},
			SampleAssemblyProtocol -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Protocol, SampleManipulation]|Object[Protocol, RoboticSamplePreparation]|Object[Protocol, ManualSamplePreparation]|Object[Notebook, Script],
				Description -> "The sample manipulation protocol used for the dilution, spiking, and antibody mixing of Samples, Standards, and Blanks.",
				Category -> "General"
			},
			AntibodyAntigenDilutionProtocol -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Protocol, SampleManipulation]|Object[Protocol, RoboticSamplePreparation]|Object[Protocol, ManualSamplePreparation]|Object[Notebook, Script],
				Description -> "The sample manipulation protocol used for the dilution of antibodies and reference antigen using their corresponding diluents.",
				Category -> "General"
			},
			CoatingPlateAssemblyProtocol -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Protocol, SampleManipulation]|Object[Protocol, RoboticSamplePreparation],
				Description -> "The sample manipulation protocol used for transferring the solutions for the coating of ELISAPlate(s).",
				Category -> "General"
			},
			CoatingPlateIncubationProtocol -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[Object[Protocol]],
				Relation -> Object[Protocol],
				Description -> "The ExperimentIncubation protocol used for the coating of ELISAPlate(s).",
				Category -> "General"
			},
			(* ----------Files------------ *)
			ProtocolKey -> {
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The protocol key.",
				Category -> "Method Information",
				Developer -> True
			},
			MethodFilePath -> {
				Format -> Single,
				Class -> String,
				Pattern :> FilePathP,
				Description -> "The file path of the folder containing the protocol file which contains the run parameters.",
				Category -> "Method Information",
				Developer -> True
			},
			MethodFileName -> {
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The file name of the folder containing the protocol file which contains the run parameters.",
				Category -> "Method Information",
				Developer -> True
			},
			MethodFile -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "The json file containing the run information generated for the ELISA experiment.",
				Category -> "Method Information"
			},
			ELISALiquidHandlingLogPath -> {
				Format -> Single,
				Class -> String,
				Pattern :> FilePathP,
				Description -> "The file path of the instrumentation trace file that monitored and recorded the execution of this robotic liquid handling by the ELISA Instrument.",
				Category -> "Method Information",
				Developer -> True
			},
			LiquidHandlingPressureLogPath -> {
				Format -> Single,
				Class -> String,
				Pattern :> FilePathP,
				Description -> "The file path of the instrumentation trace file that monitored and recorded the pressure curves during aspiration and dispense of this ELISA liquid handling.",
				Category -> "Method Information",
				Developer -> True
			},
			DataFilePath -> {
				Format -> Single,
				Class -> String,
				Pattern :> FilePathP,
				Description -> "The file path of the folder containing the data file generated at the conclusion of the experiment.",
				Category -> "Method Information",
				Developer -> True
			},
			DataFileNames -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The file names of the data file generated at the conclusion of the experiment.",
				Category -> "Method Information",
				Developer -> True
			},
			PrereadDataFileNames -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The file names of the preread data file generated during the substrate incubation, before quenched by the Stopsolution.",
				Category -> "Method Information",
				Developer -> True
			},
			DataFiles -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "The txt files containing the experiment data generated by the ELISA instrument.",
				Category -> "Experimental Results"
			},
			PrereadDataFiles -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "For each member of PrereadTimepoints, the txt files containing the experiment data generated by the ELISA instrument.",
				Category -> "Experimental Results"
			},
			StandardData -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Protocol],
				Description -> "Data of Standards generated by this protocol.",
				Category -> "Experimental Results"
			},
			BlankData -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Protocol],
				Description -> "Data of Blanks generated by this protocol.",
				Category -> "Experimental Results"
			},
			PrereadData -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Protocol],
				Description -> "Preread data generated by this protocol.",
				Category -> "Experimental Results"
			},
			ELISALiquidHandlingLog -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "The instrumentation trace file that monitored and recorded the execution of this robotic liquid handling by the ELISA Instrument.",
				Category -> "Experimental Results"
			},
			LiquidHandlingPressureLog -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "The instrumentation trace file that monitored and recorded the pressure curves during aspiration and dispense of this ELISA liquid handling.",
				Category -> "Experimental Results"
			},
			ELISARunTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Hour],
				Units -> Hour,
				Description -> "The duration of the last continuous run in the NIMBUS machine.",
				Category -> "Experimental Results",
				Developer -> True
			},
			(*===Sample Assembly===*)
			Spikes -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of SamplesIn, the additional sample with a known concentration of analyte to be mixed with the input sample to perform a spike-and-recovery assessment.",
				Category -> "Sample Preparation",
				IndexMatching -> SamplesIn
			},
			SpikeDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of SamplesIn, the ratio of dilution by which the Spike is mixed with the input sample before further dilution is performed, calculated as the volume of the Spike divided by the total final volume consisting of both the Spike and the input Sample.",
				Category -> "Sample Preparation",
				IndexMatching -> SamplesIn
			},
			SampleDilutionCurves -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0 Microliter], GreaterEqualP[0 Microliter]}..},
				Description -> "For each member of SamplesIn, the multi-step dilutions of (spiked) sample, presented as {Sample transfer volume, Diluent transfer volume}.",
				Category -> "Sample Preparation",
				IndexMatching -> SamplesIn
			},
			SampleSerialDilutionCurves -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0 Microliter], GreaterEqualP[0 Microliter]}..},
				Description -> "For each member of SamplesIn, the multi-step serial dilutions of (spiked) sample, presented as {Transfer volume of previous dilution, Diluent transfer volume}.",
				Category -> "Sample Preparation",
				IndexMatching -> SamplesIn
			},
			SampleDiluent -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "The buffer used to dilute samples to appropriate concentrations for the assay.",
				Category -> "Sample Preparation"
			},
			SampleVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the amount of Sample that is dispensed into the SampleAssemblyPlate(s) in order to form Sample-Antibody complex when Method is FastELISA.",
				Category -> "Sample Preparation",
				IndexMatching -> SamplesIn
			},
			SampleCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the amount of Sample that is dispensed into the assay plate(s), in order for the Sample to be adsorbed to the surface of the well.",
				Category -> "Sample Preparation",
				IndexMatching -> SamplesIn
			},
			SampleImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of the Sample to be loaded on the assay plate(s) for the TargetAntigen to bind to the CaptureAntibody in DirectSandwichELISA and IndirectSandwichELISA.",
				Category -> "Sample Preparation",
				IndexMatching -> SamplesIn
			},
			(*===Coating Antibody===*)
			CoatingAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of SamplesIn, the antibody to be immobilized on the surface of the ELISA plate(s) to capture the TargetAntigen during the assay in FastELISA method.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			CoatingAntibodyDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of SamplesIn, the ratio of dilution of CoatingAntibody, calculated as the volume of the CoatingAntibody divided by the total final volume consisting of both the CoatingAntibody and CoatingAntibodyDiluent.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			CoatingAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of undiluted CoatingAntibody when CoatingAntibodyDilutionFactor is Null added into the corresponding well of the assay plate(s).",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			CoatingAntibodyCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the amount of CoatingAntibody (either diluted or undiluted) that is dispensed into the assay plate(s), in order for the CoatingAntibody to be adsorbed to the surface of the well.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			CoatingAntibodyDiluent -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "The buffer used to dilute coating antibodies to appropriate concentrations for the assay before plate coating.",
				Category -> "Antibody Antigen Preparation"
			},
			WorkingCoatingAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample], Model[Container], Object[Container]}],
				Relation -> Alternatives[Model[Sample], Object[Sample], Model[Container], Object[Container]],
				Description -> "The (diluted) coating antibody used directly for ELISA.",
				Category -> "Antibody Antigen Preparation",
				Developer -> True
			},
			CoatingAntibodyConcentrates -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "All of the coating antibody resources that need to be diluted.",
				Category -> "Antibody Antigen Preparation"
			},
			CoatingAntibodyDilutionVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volumes of the coating antibodies that need to be diluted.",
				Category -> "Antibody Antigen Preparation"
			},
			CoatingAntibodyDiluentDilutionVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume of the coating antibody diluent added into the dilution container.",
				Category -> "Antibody Antigen Preparation"
			},
			CoatingAntibodyDilutionContainers -> {
				Format -> Multiple,
				Description -> "The containers used to dilute coating antibodies.",
				Pattern :> ObjectP[{Model[Container], Object[Container]}],
				Class -> Link,
				Relation -> Alternatives[Model[Container], Object[Container]],
				Category -> "Antibody Antigen Preparation"
			},
			(*===Capture Antibody===*)
			CaptureAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of SamplesIn, the antibody that is used to pull down the antigen from sample solution to the surface of the assay plate(s) in DirectSandwichELISA, IndirectSandwichELISA, and FastELISA methods.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			CaptureAntibodyDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of SamplesIn, the ratio of dilution of CaptureAntibody, calculated as the volume of the CaptureAntibody divided by the total final volume consisting of both the CaptureAntibody and either CaptureAntibodyDiluent or Sample.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			CaptureAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of undiluted CaptureAntibody directly added into the corresponding well of the assay plate(s) when Method is DirectSandwichELISA or IndirectSandwichELISA, or the volume of diluted CaptureAntibody directly added into the corresponding well of the SampleAssemblyPlate(s) to form Sample-Antibody complex when Method is FastELISA.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			CaptureAntibodyCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the amount of CaptureAntibody that is dispensed into the assay plate(s), in order for the CaptureAntibody to be adsorbed to the surface of the well when Method is DirectSandwichELISA or IndirectSandwichELISA.",
				Category -> "Coating",
				IndexMatching -> SamplesIn
			},
			CaptureAntibodyDiluent -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "The buffer used to dilute CaptureAntibodies to appropriate concentrations for the assay before plate coating when Method is DirectSandwichELISA or IndirectSandwichELISA or binding to TargetAntigen in samples when Method is FastELISA.",
				Category -> "Antibody Antigen Preparation"
			},
			WorkingCaptureAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample], Model[Container], Object[Container]}],
				Relation -> Alternatives[Model[Sample], Object[Sample], Model[Container], Object[Container]],
				Description -> "The (diluted) capture antibody used directly for ELISA.",
				Category -> "Antibody Antigen Preparation",
				Developer -> True
			},
			CaptureAntibodyConcentrates -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "All of the capture antibody resources that need to be diluted.",
				Category -> "Antibody Antigen Preparation"
			},
			CaptureAntibodyDilutionVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volumes of the capture antibodies that need to be diluted.",
				Category -> "Antibody Antigen Preparation"
			},
			CaptureAntibodyDiluentDilutionVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume of capture antibody diluent added into the dilution container.",
				Category -> "Antibody Antigen Preparation"
			},
			CaptureAntibodyDilutionContainers -> {
				Format -> Multiple,
				Description -> "The containers used to dilute capture antibodies.",
				Pattern :> ObjectP[{Model[Container], Object[Container]}],
				Class -> Link,
				Relation -> Alternatives[Model[Container], Object[Container]],
				Category -> "Antibody Antigen Preparation"
			},
			(*===Reference Antigen===*)
			ReferenceAntigens -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of SamplesIn, the antigen that competes with sample for the binding of the PrimaryAntibody when Method is DirectCompetitiveELISA or IndirectCompetitiveELISA.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			ReferenceAntigenDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of SamplesIn, the ratio of dilution of ReferenceAntigen, calculated as the volume of the ReferenceAntigen divided by the total final volume consisting of both the ReferenceAntigen and ReferenceAntigenDiluent.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			ReferenceAntigenVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of undiluted ReferenceAntigen added into the corresponding well of the assay plate(s).",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			ReferenceAntigenCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the amount of diluted ReferenceAntigen that is dispensed into the assay plate(s), in order for the ReferenceAntigen to be adsorbed to the surface of the well.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			ReferenceAntigenDiluent -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "The buffer used to dilute the ReferenceAntigen to appropriate concentrations for the assay before plate coating.",
				Category -> "Antibody Antigen Preparation"
			},
			WorkingReferenceAntigens -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample], Model[Container], Object[Container]}],
				Relation -> Alternatives[Model[Sample], Object[Sample], Model[Container], Object[Container]],
				Description -> "The (diluted) reference antigen used directly for ELISA.",
				Category -> "Antibody Antigen Preparation",
				Developer -> True
			},
			ReferenceAntigenConcentrates -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "All of the reference antigen resources that need to be diluted.",
				Category -> "Antibody Antigen Preparation"
			},
			ReferenceAntigenDilutionVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volumes of the reference antigens that need to be diluted.",
				Category -> "Antibody Antigen Preparation"
			},
			ReferenceAntigenDiluentDilutionVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume of reference antigen diluent added into the dilution container.",
				Category -> "Antibody Antigen Preparation"
			},
			ReferenceAntigenDilutionContainers -> {
				Format -> Multiple,
				Description -> "The containers used to dilute reference antigens.",
				Pattern :> ObjectP[{Model[Container], Object[Container]}],
				Class -> Link,
				Relation -> Alternatives[Model[Container], Object[Container]],
				Category -> "Antibody Antigen Preparation"
			},
			(*===Primary Antibody===*)
			PrimaryAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of SamplesIn, the antibody that directly binds to the TargetAntigen.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			PrimaryAntibodyDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of SamplesIn, the ratio of dilution of PrimaryAntibody, calculated as the volume of the PrimaryAntibody divided by the total final volume consisting of both the PrimaryAntibody and either PrimaryAntibodyDiluent or Sample.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			PrimaryAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of undiluted PrimaryAntibody added into the corresponding well of the assay plate(s) when Method is DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA, or the volume of diluted PrimaryAntibody directly added into the corresponding well of the SampleAssemblyPlate(s) to form Sample-Antibody complex when Method is DirectCompetitiveELISA, IndirectCompetitiveELISA, and FastELISA.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			PrimaryAntibodyImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of the PrimaryAntibody to be loaded on the assay plate(s) for Immunosorbent step when Method is DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			PrimaryAntibodyDiluent -> {
				Format -> Single,
				Description -> "The buffer used to dilute PrimaryAntibodies to their working concentrations before they are added to the assay plate(s).",
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Class -> Link,
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Category -> "Antibody Antigen Preparation"
			},
			WorkingPrimaryAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample], Model[Container], Object[Container]}],
				Relation -> Alternatives[Model[Sample], Object[Sample], Model[Container], Object[Container]],
				Description -> "The PrimaryAntibodies that have been diluted or aliquoted that can be used directly for ELISA.",
				Category -> "Antibody Antigen Preparation",
				Developer -> True
			},
			PrimaryAntibodyConcentrates -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "All of the primary antibody resources that need to be diluted.",
				Category -> "Antibody Antigen Preparation"
			},
			PrimaryAntibodyDilutionVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volumes of each of the primary antibody that need to be diluted.",
				Category -> "Antibody Antigen Preparation"
			},
			PrimaryAntibodyDiluentDilutionVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The total volumes of the primary antibody diluent needed to dilute each primary antibody.",
				Category -> "Antibody Antigen Preparation"
			},
			PrimaryAntibodyDilutionContainers -> {
				Format -> Multiple,
				Description -> "The containers used to dilute primary antibodies.",
				Pattern :> ObjectP[{Model[Container],Object[Container]}],
				Class -> Link,
				Relation -> Alternatives[Model[Container], Object[Container]],
				Category -> "Antibody Antigen Preparation"
			},
			(*===Secondary Antibody===*)
			SecondaryAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of SamplesIn, the antibody that binds to the PrimaryAntibody.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			SecondaryAntibodyDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of SamplesIn, the ratio of dilution of SecondaryAntibody, calculated as the volume of the SecondaryAntibody divided by the total final volume consisting of both the SecondaryAntibody and SecondaryAntibodyDiluent.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			SecondaryAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of undiluted SecondaryAntibody added into the corresponding well of the assay plate(s).",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			SecondaryAntibodyImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of the Secondary Antibody to be loaded on the assay plate(s)for Immunosorbent assay.",
				Category -> "Antibody Antigen Preparation",
				IndexMatching -> SamplesIn
			},
			SecondaryAntibodyDilutionOnDeck -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates whether the SecondaryAntibody and SecondaryAntibodyDiluent are mixed prior to being added to the assay plate(s) on deck during the immunosorbent step instead of during sample assembly.",
				Category -> "Antibody Antigen Preparation"
			},
			SecondaryAntibodyDiluent -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "The buffer used to dilute SecondaryAntibodies to their working concentrations before they are added to the assay plate(s).",
				Category -> "Antibody Antigen Preparation"
			},
			WorkingSecondaryAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample], Model[Container], Object[Container]}],
				Relation -> Alternatives[Model[Sample], Object[Sample], Model[Container], Object[Container]],
				Description -> "The SecondaryAntibody that have been diluted or aliquoted and used directly for ELISA.",
				Category -> "Antibody Antigen Preparation",
				Developer -> True
			},
			SecondaryAntibodyConcentrates -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "All of the secondary antibody resources that need to be diluted.",
				Category -> "Antibody Antigen Preparation"
			},
			SecondaryAntibodyDilutionVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The total volumes of the secondary antibodies that need to be diluted.",
				Category -> "Antibody Antigen Preparation"
			},
			SecondaryAntibodyDiluentDilutionVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The total volumes of the secondary antibody diluents needed to dilute each secondary antibody.",
				Category -> "Antibody Antigen Preparation"
			},
			SecondaryAntibodyDilutionContainers -> {
				Format -> Multiple,
				Description -> "The containers used to dilute secondary antibodies.",
				Pattern :> ObjectP[{Model[Container],Object[Container]}],
				Class -> Link,
				Relation -> Alternatives[Model[Container], Object[Container]],
				Category -> "Antibody Antigen Preparation"
			},
			(*==========EXPERIMENTAL PROCEDURE===============*)
			WashingBuffer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "The solution used to rinse off unbound molecules from the assay plate(s).",
				Category -> "Washing"
			},
			WashPlateMethod -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[Object[Method, WashPlate]],
				Relation -> Alternatives[Object[Method, WashPlate]],
				Description -> "The file containing a set of parameters define how the plate washer aspirates, dispenses, and manages liquid flow during ELISA washing steps, including speeds, heights, delays, and positioning for optimal washing efficiency.",
				Category -> "Washing"
			},
			(*==========Antibody Complex Incubation==============*)
			SampleAntibodyComplexIncubation -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Specifies whether the pre-mixed samples and antibodies in the SampleAssemblyPlate(s) undergo an incubation step to facilitate the formation of the sample–antibody complex prior to transfer into the assay plate(s).",
				Category -> "Sample Antibody Complex Incubation"
			},
			SampleAntibodyComplexIncubationTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Hour],
				Units -> Hour,
				Description -> "The incubation duration of pre-mixed samples and antibodies during SampleAntibodyComplexIncubation.",
				Category -> "Sample Antibody Complex Incubation"
			},
			SampleAntibodyComplexIncubationTemperature -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Alternatives[Ambient, TemperatureP],
				Description -> "The temperature at which the pre-mixed samples and antibodies are incubated during SampleAntibodyComplexIncubation.",
				Category -> "Sample Antibody Complex Incubation"
			},
			SampleAntibodyComplexIncubationMixRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 RPM],
				Units -> RPM,
				Description -> "The speed at which the SampleAssemblyPlate(s) containing the pre-mixed samples and antibodies is shaken (orbitally, at a radius of 2 mm) during SampleAntibodyComplexIncubation.",
				Category -> "Sample Antibody Complex Incubation"
			},
			(*============Coating==============*)
			Coating -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if Coating is required. Coating is a procedure to immobilize analytes (usually antigens and antibodies) to the surface of the assay plate(s) non-specifically.",
				Category -> "General"
			},
			CoatingTemperature -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Alternatives[Ambient, TemperatureP],
				Description -> "The temperature at which the assay plate(s) are kept during coating, in order for the analytes to be adsorbed to the surface of the assay plate(s).",
				Category -> "Coating"
			},
			CoatingTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Hour],
				Units -> Hour,
				Description -> "The duration for coating step.",
				Category -> "Coating"
			},
			CoatingWashVolume -> {
				Format -> Single,
				Description -> "The volume of WashBuffer added per wash cycle to rinse off unbound coating analytes from the assay plate(s) per well.",
				Pattern :> GreaterEqualP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Coating"
			},
			CoatingNumberOfWashes -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Description -> "The number of washes performed to rinse off unbound coating analytes.",
				Category -> "Coating"
			},
			MoatVolume -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume which each moat is filled with in order to slow evaporation of inner assay samples during the coating step.",
				Category -> "Coating"
			},
			MoatBuffer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Sample], Model[Sample]],
				Description -> "The sample each moat well is filled with in order to slow evaporation of inner assay samples during the coating step.",
				Category -> "Coating"
			},
			MoatSize -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Units -> None,
				Description -> "The depth the moat extends into the assay plate. For example, if MoatSize is 1, the first available well for sample is B2.",
				Category -> "Coating"
			},
			(*============Blocking==============*)
			Blocking -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if a protein solution should be incubated with the assay plate to prevent non-specific binding of molecules to the assay plate.",
				Category -> "Blocking"
			},
			BlockingBuffer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "The solution used to prevent non-specific binding of antigen or antibody to the surface of the assay plate.",
				Category -> "Blocking"
			},
			BlockingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the amount of BlockingBuffer that is dispensed into the corresponding wells of the assay plate(s), in order to prevent non-specific binding.",
				Category -> "Blocking",
				IndexMatching -> SamplesIn
			},
			BlockingTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Hour],
				Units -> Hour,
				Description -> "The blocking duration when the BlockingBuffer is kept with the assay plate(s), in order to prevent non-specific binding of molecules to the assay plate.",
				Category -> "Blocking"
			},
			BlockingTemperature -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Alternatives[Ambient, TemperatureP],
				Description -> "The temperature at which the assay plate(s) are kept during blocking, in order for the blocking analytes to be adsorbed to the unoccupied sites of the assay plate(s).",
				Category -> "Blocking"
			},
			BlockingMixRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 RPM],
				Units -> RPM,
				Description -> "The speed at which the plate is shaken (orbitally, at a radius of 2 mm) during blocking.",
				Category -> "Blocking"
			},
			BlockingWashVolume -> {
				Format -> Single,
				Description -> "The volume of WashBuffer added per wash cycle to rinse off the unbound blocking reagents from the assay plate(s).",
				Pattern :> GreaterEqualP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Blocking"
			},
			BlockingNumberOfWashes -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Description -> "The number of washes performed to rinse off unbound blocking reagents.",
				Category -> "Blocking"
			},
			(*Immunosorbent*)
			SampleAntibodyComplexImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of the SampleAntibodyComplex to be loaded on the ELISAPlate. In DirectCompetitiveELISA and IndirectCompetitiveELISA, this step enables the free primary antibody to bind to the ReferenceAntigen coated on the plate. In FastELISA, this step enables the PrimaryAntibody-TargetAntigen-CaptureAntibody complex to bind to the CoatingAntibody on the plate.",
				Category -> "Immunosorbent Step",
				IndexMatching -> SamplesIn
			},
			SampleAntibodyComplexImmunosorbentTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Hour],
				Units -> Hour,
				Description -> "The duration for which the sample-antibody complex is allowed to adsorb onto the assay plate(s).",
				Category -> "Immunosorbent Step"
			},
			SampleAntibodyComplexImmunosorbentTemperature -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Alternatives[Ambient, TemperatureP],
				Description -> "The temperature at which the assay plate(s) are kept during SampleAntibodyComplexImmunosorbent step.",
				Category -> "Immunosorbent Step"
			},
			SampleAntibodyComplexImmunosorbentMixRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 RPM],
				Units -> RPM,
				Description -> "The speed at which the assay plate(s) are shaken (orbitally, at a radius of 2 mm) during SampleAntibodyComplexImmunosorbent step.",
				Category -> "Immunosorbent Step"
			},
			SampleAntibodyComplexImmunosorbentWashVolume -> {
				Format -> Single,
				Description -> "The volume of WashBuffer added per wash cycle to rinse off the unbound PrimaryAntibody after SampleAntibodyComplexImmunosorbent step.",
				Pattern :> GreaterEqualP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Immunosorbent Step"
			},
			SampleAntibodyComplexImmunosorbentNumberOfWashes -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Description -> "The number of rinses performed after SampleAntibodyComplexImmunosorbent step.",
				Category -> "Immunosorbent Step"
			},
			SampleImmunosorbentTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Hour],
				Units -> Hour,
				Description -> "The duration for which the samples are allowed to adsorb onto the assay plate(s) in DirectSandwichELISA and IndirectSandwichELISA.",
				Category -> "Immunosorbent Step"
			},
			SampleImmunosorbentTemperature -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Alternatives[Ambient, TemperatureP],
				Description -> "The temperature at which the assay plate(s) are kept during SampleImmunosorbent step.",
				Category -> "Immunosorbent Step"
			},
			SampleImmunosorbentMixRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 RPM],
				Units -> RPM,
				Description -> "The speed at which the assay plate(s) are shaken (orbitally, at a radius of 2 mm) during SampleImmunosorbent step.",
				Category -> "Immunosorbent Step"
			},
			SampleImmunosorbentWashVolume -> {
				Format -> Single,
				Description -> "The volume of WashBuffer added per wash cycle to rinse off the unbound Samples after SampleImmunosorbent step.",
				Pattern :> GreaterEqualP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Immunosorbent Step"
			},
			SampleImmunosorbentNumberOfWashes -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Description -> "The number of rinses performed to rinse off the unbound Samples after SampleImmunosorbent step.",
				Category -> "Immunosorbent Step"
			},
			PrimaryAntibodyImmunosorbentTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Hour],
				Units -> Hour,
				Description -> "The duration for which the PrimaryAntibodies are allowed to adsorb onto the assay plate(s) for DirectELISA, IndirectELISA, DirectSandwichELISA, or IndirectSandwichELISA.",
				Category -> "Immunosorbent Step"
			},
			PrimaryAntibodyImmunosorbentTemperature -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Alternatives[Ambient, TemperatureP],
				Description -> "The temperature at which the assay plate(s) are kept during PrimaryAntibodyImmunosorbent incubation.",
				Category -> "Immunosorbent Step"
			},
			PrimaryAntibodyImmunosorbentMixRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 RPM],
				Units -> RPM,
				Description -> "The speed at which the assay plate(s) are shaken (orbitally, at a radius of 2 mm) during PrimaryAntibodyImmunosorbent incubation.",
				Category -> "Immunosorbent Step"
			},
			PrimaryAntibodyImmunosorbentWashing -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if a final washing step is performed at the end of PrimaryAntibodyImmunosorbent incubation to wash off unbound PrimaryAntibody.",
				Category -> "Immunosorbent Step"
			},
			PrimaryAntibodyImmunosorbentWashVolume -> {
				Format -> Single,
				Description -> "The volume of WashBuffer added per wash cycle to rinse off the unbound PrimaryAntibody after PrimaryAntibody incubation.",
				Pattern :> GreaterP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Immunosorbent Step"
			},
			PrimaryAntibodyImmunosorbentNumberOfWashes -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Description -> "The number of rinses performed to rinse off the unbound PrimaryAntibody after PrimaryAntibody incubation.",
				Category -> "Immunosorbent Step"
			},
			SecondaryAntibodyImmunosorbentTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Hour],
				Units -> Hour,
				Description -> "The duration for which the SecondaryAntibodies are allowed to adsorb onto the assay plate(s) for IndirectELISA, IndirectSandwichELISA, and IndirectCompetitiveELISA.",
				Category -> "Immunosorbent Step"
			},
			SecondaryAntibodyImmunosorbentTemperature -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Alternatives[Ambient, TemperatureP],
				Description -> "The temperature at which the assay plate(s) are kept during SecondaryAntibodyImmunosorbent incubation.",
				Category -> "Immunosorbent Step"
			},
			SecondaryAntibodyImmunosorbentMixRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 RPM],
				Units -> RPM,
				Description -> "TThe speed at which the assay plate(s) are shaken (orbitally, at a radius of 2 mm) during SecondaryAntibodyImmunosorbent incubation.",
				Category -> "Immunosorbent Step"
			},
			SecondaryAntibodyImmunosorbentWashing-> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if a final washing step is performed at the end of SecondaryAntibodyImmunosorbent incubation to wash off unbound SecondaryAntibody.",
				Category -> "Immunosorbent Step"
			},
			SecondaryAntibodyImmunosorbentWashVolume -> {
				Format -> Single,
				Description -> "The volume of WashBuffer added per wash cycle to rinse off the unbound Secondary antibody after SecondaryAntibodyImmunosorbent incubation.",
				Pattern :> GreaterEqualP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Immunosorbent Step"
			},
			SecondaryAntibodyImmunosorbentNumberOfWashes -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Description -> "The number of rinses performed to rinse off the unbound SecondaryAntibody from assay plate(s) after SecondaryAntibodyImmunosorbent incubation.",
				Category -> "Immunosorbent Step"
			},
			(*Detection*)
			SubstrateSolution -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "The solution containing a chromogenic, fluorogenic, or chemiluminescent reagent that reacts with the enzyme conjugated to the detection antibody (or other enzyme label) to produce a measurable signal.",
				Category -> "Detection"
			},
			SecondarySubstrateSolution -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "The solution containing an enhancer or activator that optimizes or initiates the reaction of SubstrateSolution when the two are mixed together.",
				Category -> "Detection"
			},
			PreMixSubstrateSolution -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Whether the SubstrateSolution and SecondarySubstrateSolution are mixed prior to being added to the assay plate(s).",
				Category -> "Detection"
			},
			SubstrateSolutionMixRatio -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0],
				Description -> "The volume ratio of SubstrateSolution to SecondarySubstrateSolution.",
				Category -> "Detection"
			},
			SubstrateSolutions -> {(*todo:delete, no longer index-matching*)
				Format -> Multiple,
				Description -> "For each member of SamplesIn, defines the one-part substrate solution such as PNPP.",
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Class -> Link,
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Category -> "Detection",
				IndexMatching -> SamplesIn
			},
			StopSolutions -> {(*todo:delete, no longer index-matching*)
				Format -> Multiple,
				Description -> "For each member of SamplesIn, the reagent that is used to stop the reaction between the enzyme and its substrate.",
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Class -> Link,
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Category -> "Detection",
				IndexMatching -> SamplesIn
			},
			SubstrateSolutionVolumes -> {(*todo:delete, no longer index-matching*)
				Format -> Multiple,
				Description -> "For each member of SamplesIn, the volume of substrate to be added to the corresponding well.",
				Pattern :> GreaterP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Detection",
				IndexMatching -> SamplesIn
			},
			StopSolutionVolumes -> {(*todo:delete, no longer index-matching*)
				Format -> Multiple,
				Description -> "For each member of SamplesIn, the volume of StopSolution to be added to the corresponding well.",
				Pattern :> GreaterP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Detection",
				IndexMatching -> SamplesIn
			},
			SubstrateSolutionVolume -> {
				Format -> Single,
				Description -> "The volume of the working SubstrateSolution (pre-mixed according to the SubstrateSolutionMixRatio if a SecondarySubstrateSolution is specified) to be added to the assay plate(s).",
				Pattern :> GreaterP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Detection"
			},
			SubstrateIncubationTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Hour],
				Units -> Hour,
				Description -> "The time allowed for the enzyme substrate reaction to occur in the assay plate(s) before the reaction is stopped or measured.",
				Category -> "Detection"
			},
			SubstrateIncubationTemperature -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Alternatives[Ambient, TemperatureP],
				Description -> "The temperature at which the assay plate(s) are kept during SubstrateIncubation, in order for the detection reagent to react with antibody-conjugated enzyme.",
				Category -> "Detection"
			},
			SubstrateIncubationMixRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 RPM],
				Units -> RPM,
				Description -> "The speed at which the assay plate(s) are shaken (orbitally, at a radius of 2 mm) during SubstrateIncubation.",
				Category -> "Detection"
			},
			StopSolution -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "The reagent that is used to stop colorimetric reaction between the enzyme and its substrate.",
				Category -> "Detection"
			},
			StopSolutionVolume -> {
				Format -> Single,
				Description -> "The volume of StopSolution to be added to the assay plate(s).",
				Pattern :> GreaterP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Detection"
			},
			DetectionWashing -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if an initial washing step is added to detection step before adding SubstrateSolution.",
				Category -> "Detection"
			},
			DetectionWashingBuffer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "The solution used to wash assay plate(s) prior to adding SubstrateSolution.",
				Category -> "Detection"
			},
			DetectionWashVolume -> {
				Format -> Single,
				Description -> "The volume of DetectionWashingBuffer added per wash cycle per well to the assay plate(s).",
				Pattern :> GreaterEqualP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Detection"
			},
			DetectionNumberOfWashes -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Description -> "The number of washes performed for DetectionWashing.",
				Category -> "Detection"
			},
			RetainCover -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the lid(s) on the assay plate(s) should not be taken off during measurement to decrease evaporation.",
				Category -> "Detection"
			},
			PrereadTimepoints -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Minute],
				Units -> Minute,
				Description -> "The list of time points when the absorbance intensities were recorded at PrereadAbsorbanceWavelengths during the preread process.",
				Category -> "General"
			},
			PrereadAbsorbanceWavelengths -> {
				Format -> Multiple,
				Description -> "The wavelength used to detect the absorbance of light produced by colorimetric reaction before the sample is quenched by the StopSolution.",
				Pattern :> GreaterP[0 Nanometer],
				Class -> Real,
				Units -> Nanometer,
				Category -> "Detection"
			},
			AbsorbanceWavelengths -> {
				Format -> Multiple,
				Description -> "The wavelength used to detect the absorbance of light by the product of the detection reaction.",
				Pattern :> GreaterP[0 Nanometer],
				Class -> Real,
				Units -> Nanometer,
				Category -> "Detection"
			},
			SignalCorrection -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if an absorbance reading that is used to eliminate the interference of background absorbance (such as from ELISAPlate material and dust) is used.",
				Category -> "Detection"
			},
			SignalCorrectionWavelength -> {
				Format -> Single,
				Description -> "The wavelength for absorbance reading that is used to eliminate the interference of background absorbance.",
				Pattern :> GreaterP[0 Nanometer],
				Class -> Real,
				Units -> Nanometer,
				Category -> "Detection"
			},
			WavelengthSelection -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> WavelengthSelectionP,
				Description -> "The method used to obtain the emission and excitation wavelengths.",
				Category -> "Detection"
			},
			ReadLocation -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> ReadLocationP,
				Description -> "Indicates if the plate will be illuminated and read from top or bottom.",
				Category -> "Detection"
			},
			EmissionWavelengths -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Nanometer],
				Units -> Nanometer,
				Description -> "The wavelengths at which luminescence emitted from the assay plate(s) is measured.",
				Category -> "Detection"
			},
			ExcitationWavelengths -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Nanometer],
				Units -> Nanometer,
				Description -> "For each member of EmissionWavelengths, the wavelengths of light used to excite the samples.",
				Category -> "Detection",
				IndexMatching -> EmissionWavelengths,
				Abstract -> True
			},
			Gains -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Percent],
				Units -> Percent,
				Description -> "For each member of EmissionWavelengths, the voltage set on the PMT (photomultiplier tube) detector to amplify the detected signal during the luminescence measurement at this wavelength.",
				IndexMatching -> EmissionWavelengths,
				Category -> "Detection"
			},
			DualEmission -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if both emission detectors are used to record emissions at the primary and secondary wavelengths.",
				Category -> "Detection"
			},
			DualEmissionWavelengths -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Nanometer],
				Units -> Nanometer,
				Description -> "For each member of EmissionWavelengths, the corresponding wavelength at which luminescence emitted from the assay plate(s) is measured with the secondary detector (simultaneous to the measurement at the emission wavelength done by the primary detector).",
				IndexMatching -> EmissionWavelengths,
				Category -> "Detection"
			},
			DualEmissionGains -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Percent],
				Units -> Percent,
				Description -> "For each member of DualEmissionWavelengths, the voltage set on the PMT (photomultiplier tube) detector to amplify the detected signal during the luminescence measurement at this wavelength.",
				IndexMatching -> DualEmissionWavelengths,
				Category -> "Detection"
			},
			FocalHeights -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Millimeter],
				Units -> Millimeter,
				Description -> "For each member of EmissionWavelengths, indicate the distance from the bottom of the plate carrier to the focal point where light from the sample is directed onto the detector.",
				Category -> "Detection",
				IndexMatching -> EmissionWavelengths
			},
			AutoFocalHeights -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of EmissionWavelengths, indicates if the FocalHeight is determined by reading the AdjustmentSample at different heights and selecting the height which gives the highest luminescence reading.",
				Category -> "Detection",
				IndexMatching -> EmissionWavelengths
			},
			IntegrationTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> Second,
				Description -> "The amount of time over which luminescence measurements should be integrated.",
				Category -> "Detection"
			},
			(*==============STANDARD OPTIONS=================*)
			Standards -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "The samples containing known amount of TargetAntigen molecule. Standard is used for the quantification of Standard analyte.",
				Category -> "Standard"
			},
			StandardTargetAntigens -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[Model[Molecule]],
				Relation -> Model[Molecule],
				Description -> "For each member of Standards, the analyte molecule(e.g., peptide, protein, and hormone) detected and quantified in the Standard samples by antibodies in the ELISA experiment.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardDilutionCurves -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0 Microliter], GreaterEqualP[0 Microliter]}..},
				Description -> "For each member of Standards, the multi-step dilutions of standards, presented as {Standard transfer volume, Diluent transfer volume}.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardSerialDilutionCurves -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0 Microliter], GreaterEqualP[0 Microliter]}..},
				Description -> "For each member of Standards, the multi-step serial dilutions of standards, presented as {Transfer volume of previous dilution, Diluent transfer volume}.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardDiluent -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "The buffer used to perform multiple dilutions on Standards to appropriate concentrations.",
				Category -> "Standard"
			},
			StandardCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the amount of Standard that is dispensed into the ELISAPlate(s), in order for the Standard to be adsorbed to the surface of the well.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of the Standard to be loaded on the ELISAPlate for the target antigen to bind to the capture antibody in DirectSandwichELISA and IndirectSandwichELISA.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardCoatingAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of Standards, the antibody to be immobilized on the surface of the ELISA plate(s) to capture the StandardTargetAntigen during the assay for FastELISA method.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardCoatingAntibodyDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of Standards, the ratio of dilution of StandardCoatingAntibody, calculated as the volume of the StandardCoatingAntibody divided by the total final volume consisting of both the StandardCoatingAntibody and CoatingAntibodyDiluent.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardCoatingAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, th volume of undiluted StandardCoatingAntibody directly added into the corresponding well of the assay plate(s).",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardCoatingAntibodyCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the amount of StandardCoatingAntibody (either diluted or undiluted) that is dispensed into the assay plate(s), in order for the StandardCoatingAntibody to be adsorbed to the surface of the well.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardCaptureAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of Standards, the antibody that is used to pull down the StandardTargetAntigen from standard solution to the the surface of the assay plate(s) in DirectSandwichELISA, IndirectSandwichELISA, and FastELISA.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardCaptureAntibodyDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of Standards, the ratio of dilution of StandardCaptureAntibody.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardCaptureAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of undiluted StandardCaptureAntibody added into the corresponding well of the assay plate(s) when Method is DirectSandwichELISA or IndirectSandwichELISA, or the volume of diluted StandardCaptureAntibody directly added into the corresponding well of the SampleAssemblyPlate(s) to form Sample-Antibody complex when Method is FastELISA.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardCaptureAntibodyCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the amount of StandardCaptureAntibody (either diluted or undiluted) that is dispensed into the assay plate(s), in order for the StandardCaptureAntibody to be adsorbed to the surface of the well.",
				Category -> "Coating",
				IndexMatching -> Standards
			},
			StandardReferenceAntigens -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of Standards, the antigen that competes with StandardTargetAntigen in the standard for the binding of the StandardPrimaryAntibody.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardReferenceAntigenDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of Standards, the ratio of dilution of StandardReferenceAntigen.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardReferenceAntigenVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the StandardReferenceAntigen added into the corresponding well of the assay plate(s).",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardReferenceAntigenCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the amount of StandardReferenceAntigen (either diluted or undiluted) that is dispensed into the assay plate(s), in order for the StandardReferenceAntigen to be adsorbed to the surface of the well.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardPrimaryAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of Standards, the antibody that directly binds to the StandardTargetAntigen.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardPrimaryAntibodyDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of Standards, the ratio of dilution of StandardPrimaryAntibody.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardPrimaryAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of undiluted StandardPrimaryAntibody added into the corresponding well of the assay plate(s) when Method is DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA, or the volume of diluted StandardPrimaryAntibody directly added into the corresponding well of the SampleAssemblyPlate(s) to form Sample-Antibody complex when Method is DirectCompetitiveELISA, IndirectCompetitiveELISA, and FastELISA.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardPrimaryAntibodyImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of the StandardPrimaryAntibody (either diluted or undiluted) to be loaded on the assay plate(s) for the Immunosorbent step when Method is DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardSecondaryAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of Standards, the antibody that binds to the StandardPrimaryAntibody rather than directly to the StandardTargetAntigen.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardSecondaryAntibodyDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of Standards, the ratio of dilution of StandardSecondaryAntibody.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardSecondaryAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of StandardSecondaryAntibody (either diluted or undiluted) added into the corresponding well of the assay plate(s) for the immunosorbent step.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardSecondaryAntibodyImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of the StandardSecondaryAntibody (either diluted or undiluted) to be loaded on the assay plate(s) for the immunosorbent step.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardBlockingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the amount of BlockingBuffer that is dispensed into the corresponding wells of the assay plate(s), in order to prevent non-specific binding.",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardAntibodyComplexImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of the StandardAntibodyComplex to be loaded on the assay plate(s).",
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardSubstrateSolutions -> {(*todo delete*)
				Format -> Multiple,
				Description -> "For each member of Standards, defines the one-part substrate solution such as PNPP.",
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Class -> Link,
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardStopSolutions -> {(*todo delete*)
				Format -> Multiple,
				Description -> "For each member of Standards, the reagent that is used to stop the reacelisaMasterSwitchtion between the enzyme and its substrate.",
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Class -> Link,
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardSubstrateSolutionVolumes -> {(*todo delete*)
				Format -> Multiple,
				Description -> "For each member of Standards, the volume of substrate to be added to the corresponding well.",
				Pattern :> GreaterP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Standard",
				IndexMatching -> Standards
			},
			StandardStopSolutionVolumes -> {(*todo delete*)
				Format -> Multiple,
				Description -> "For each member of Standards, the volume of StopSolution to be added to the corresponding well.",
				Pattern :> GreaterP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Standard",
				IndexMatching -> Standards
			},
			(*================Blank==================*)
			Blanks -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "The solution containing no TargetAntigen, used as a baseline or negative control for the ELISA.",
				Category -> "Blank"
			},
			BlankTargetAntigens -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[Model[Molecule]],
				Relation -> Model[Molecule],
				Description -> "For each member of Blanks, the analyte molecule(e.g., peptide, protein, and hormone) used in the blanks as baseline or negative control.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Blanks, the amount of Blank that is dispensed into the ELISAPlate(s), in order for the Blank to be adsorbed to the surface of the well.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Blanks, the volume of the Blank to be loaded on the ELISAPlate(s) for the target antigen to bind to the capture antibody in DirectSandwichELISA and IndirectSandwichELISA.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankCoatingAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of Blanks, the antibody to be immobilized on the surface of the ELISA plate(s) to capture the BlankTargetAntigen during the assay.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankCoatingAntibodyDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of Blanks, the dilution ratio of BlankCoatingAntibody, calculated as the volume of the BlankCoatingAntibody divided by the total final volume consisting of both the BlankCoatingAntibody and CoatingAntibodyDiluent.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankCoatingAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Blanks, the volume of undiluted BlankCoatingAntibody directly added into the corresponding well of the assay plate(s).",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankCoatingAntibodyCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Blanks, the amount of BlankCoatingAntibody (either diluted or undiluted) that is dispensed into the assay plate(s), in order for the BlankCoatingAntibody to be adsorbed to the surface of the well.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankCaptureAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of Blanks, the antibody that is used to pull down the BlankTargetAntigen from blank solution to the surface of the assay plate(s) in DirectSandwichELISA, IndirectSandwichELISA, and FastELISA methods.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankCaptureAntibodyDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of Blanks, the dilution ratio of BlankCaptureAntibody. For DirectSandwichELISA and IndirectSandwichELISA, BlankCaptureAntibody is diluted with CaptureAntibodyDiluent.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankCaptureAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Blanks, the volume of undiluted BlankCaptureAntibody added into the corresponding well of the assay plate(s) when Method is DirectSandwichELISA or IndirectSandwichELISA, or the volume of diluted BlankCaptureAntibody directly added into the corresponding well of the SampleAssemblyPlate(s) to form Sample-Antibody complex when Method is FastELISA.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankCaptureAntibodyCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Blanks, the amount of BlankCaptureAntibody (either diluted or undiluted) that is dispensed into the assay plate(s), in order for the BlankCaptureAntibody to be adsorbed to the surface of the well.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankReferenceAntigens -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of Blanks, the antigen that competes with BlankTargetAntigen in the blank for the binding of the BlankPrimaryAntibody.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankReferenceAntigenDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of Blanks, the dilution ratio of BlankReferenceAntigen.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankReferenceAntigenVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Blanks, the volume of BlankReferenceAntigen added into the corresponding well of the assay plate(s).",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankReferenceAntigenCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Blanks, the amount of diluted BlankReferenceAntigen that is dispensed into the assay plate(s), in order for the BlankReferenceAntigen to be adsorbed to the surface of the well.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankPrimaryAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of Blanks, the antibody that directly binds with the BlankTargetAntigen.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankPrimaryAntibodyDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of Blanks, the ratio of dilution of BlankPrimaryAntibody.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankPrimaryAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Blanks, the volume of undiluted BlankPrimaryAntibody added into the corresponding well of the assay plate(s) when Method is DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA, or the volume of diluted BlankPrimaryAntibody directly added into the corresponding well of the SampleAssemblyPlate(s) to form Sample-Antibody complex when Method is DirectCompetitiveELISA, IndirectCompetitiveELISA, and FastELISA.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankPrimaryAntibodyImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Blanks, the volume of the BlankPrimaryAntibody (either diluted or undiluted) to be loaded on the assay plate(s) for the Immunosorbent step when Method is DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankSecondaryAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of Blanks, the antibody that binds to the BlankPrimaryAntibody rather than directly to the BlankTargetAntigen.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankSecondaryAntibodyDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of Blanks, the ratio of dilution of BlankSecondaryAntibody.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankSecondaryAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Blanks, the volume of BlankSecondaryAntibody added into the corresponding well of the assay plate(s) for the immunosorbent step.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankSecondaryAntibodyImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Blanks, the volume of the BlankSecondaryAntibody (either diluted or undiluted) to be loaded on the assay plate(s) for the immunosorbent step.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankBlockingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Blanks, the amount of BlockingBuffer that is dispensed into the corresponding wells of the assay plate(s), in order to prevent non-specific binding.",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankAntibodyComplexImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of Blanks, the volume of the BlankAntibodyComplex to be loaded on the assay plate(s).",
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankSubstrateSolutions -> {(*todo delete*)
				Format -> Multiple,
				Description -> "For each member of Blanks, defines the one-part substrate solution such as PNPP.",
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Class -> Link,
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankStopSolutions -> {(*todo delete*)
				Format -> Multiple,
				Description -> "For each member of Blanks, the reagent that is used to stop the reaction between the enzyme and its substrate.",
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Class -> Link,
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankSubstrateSolutionVolumes -> {(*todo delete*)
				Format -> Multiple,
				Description -> "For each member of Blanks, the volume of substrate to be added to the corresponding well.",
				Pattern :> GreaterP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			BlankStopSolutionVolumes -> {(*todo delete*)
				Format -> Multiple,
				Description -> "For each member of Blanks, the volume of StopSolution to be added to the corresponding well.",
				Pattern :> GreaterP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "Blank",
				IndexMatching -> Blanks
			},
			(*=========ELISA Plate And Assignment============*)
			ELISAPlateAssignment -> {
				Category -> "Assay Plate",
				Description -> "The arrangement of samples and their corresponding reagents in the ELISAPlate.",
				Format -> Multiple,
				Class -> {
					Type->Expression,
					Sample->Link,
					Spike->Link,
					SpikeDilutionFactor->Real,
					SampleDilutionFactors->Expression,
					CoatingAntibody->Link,
					CoatingAntibodyDilutionFactor->Real,
					CaptureAntibody->Link,
					CaptureAntibodyDilutionFactor->Real,
					ReferenceAntigen->Link,
					ReferenceAntigenDilutionFactor->Real,
					PrimaryAntibody->Link,
					PrimaryAntibodyDilutionFactor->Real,
					SecondaryAntibody->Link,
					SecondaryAntibodyDilutionFactor->Real,
					CoatingVolume->Real,
					BlockingVolume->Real,
					SampleAntibodyComplexImmunosorbentVolume->Real,
					SampleImmunosorbentVolume->Real,
					PrimaryAntibodyImmunosorbentVolume->Real,
					SecondaryAntibodyImmunosorbentVolume->Real,
					SubstrateSolution->Link,
					StopSolution->Link,
					SubstrateSolutionVolume->Real,
					StopSolutionVolume->Real,
					Data->Link
				},
				Pattern :> {
					Type->ELISASampleTypeP,
					Sample->ObjectP[{Model[Sample], Object[Sample]}],
					Spike->ObjectP[{Model[Sample], Object[Sample]}],
					SpikeDilutionFactor->RangeP[0,1],
					SampleDilutionFactors -> {RangeP[0,1]..},
					CoatingAntibody->ObjectP[{Model[Sample], Object[Sample]}],
					CoatingAntibodyDilutionFactor->RangeP[0,1],
					CaptureAntibody->ObjectP[{Model[Sample], Object[Sample]}],
					CaptureAntibodyDilutionFactor->RangeP[0,1],
					ReferenceAntigen->ObjectP[{Model[Sample], Object[Sample]}],
					ReferenceAntigenDilutionFactor->RangeP[0,1],
					PrimaryAntibody->ObjectP[{Model[Sample], Object[Sample]}],
					PrimaryAntibodyDilutionFactor->RangeP[0,1],
					SecondaryAntibody->ObjectP[{Model[Sample], Object[Sample]}],
					SecondaryAntibodyDilutionFactor->RangeP[0,1],
					CoatingVolume->RangeP[0Microliter,300Microliter],
					BlockingVolume->RangeP[0Microliter,300Microliter],
					SampleAntibodyComplexImmunosorbentVolume->RangeP[0Microliter,300Microliter],
					SampleImmunosorbentVolume->RangeP[0Microliter,300Microliter],
					PrimaryAntibodyImmunosorbentVolume->RangeP[0Microliter,300Microliter],
					SecondaryAntibodyImmunosorbentVolume->RangeP[0Microliter,300Microliter],
					SubstrateSolution->ObjectP[{Model[Sample], Object[Sample]}],
					StopSolution->ObjectP[{Model[Sample], Object[Sample]}],
					SubstrateSolutionVolume->RangeP[0Microliter,300Microliter],
					StopSolutionVolume->RangeP[0Microliter,300Microliter],
					Data->_Link

				},
				Units -> {
					Type->None,
					Sample ->None,
					Spike->None,
					SpikeDilutionFactor->None,
					SampleDilutionFactors->None,
					CoatingAntibody->None,
					CoatingAntibodyDilutionFactor->None,
					CaptureAntibody->None,
					CaptureAntibodyDilutionFactor->None,
					ReferenceAntigen->None,
					ReferenceAntigenDilutionFactor->None,
					PrimaryAntibody->None,
					PrimaryAntibodyDilutionFactor->None,
					SecondaryAntibody->None,
					SecondaryAntibodyDilutionFactor->None,
					CoatingVolume->Microliter,
					BlockingVolume->Microliter,
					SampleAntibodyComplexImmunosorbentVolume->Microliter,
					SampleImmunosorbentVolume->Microliter,
					PrimaryAntibodyImmunosorbentVolume->Microliter,
					SecondaryAntibodyImmunosorbentVolume->Microliter,
					SubstrateSolution->None,
					StopSolution->None,
					SubstrateSolutionVolume->Microliter,
					StopSolutionVolume->Microliter,
					Data->None
				},
				Relation->{
					Type->Null,
					Sample ->Object[Sample]|Model[Sample],
					Spike->Object[Sample]|Model[Sample],
					SpikeDilutionFactor->Null,
					SampleDilutionFactors->Null,
					CoatingAntibody->Object[Sample]|Model[Sample],
					CoatingAntibodyDilutionFactor->Null,
					CaptureAntibody->Object[Sample]|Model[Sample],
					CaptureAntibodyDilutionFactor->Null,
					ReferenceAntigen->Object[Sample]|Model[Sample],
					ReferenceAntigenDilutionFactor->Null,
					PrimaryAntibody->Object[Sample]|Model[Sample],
					PrimaryAntibodyDilutionFactor->Null,
					SecondaryAntibody->Object[Sample]|Model[Sample],
					SecondaryAntibodyDilutionFactor->Null,
					CoatingVolume->Null,
					BlockingVolume->Null,
					SampleAntibodyComplexImmunosorbentVolume->Null,
					SampleImmunosorbentVolume->Null,
					PrimaryAntibodyImmunosorbentVolume->Null,
					SecondaryAntibodyImmunosorbentVolume->Null,
					SubstrateSolution->Object[Sample]|Model[Sample],
					StopSolution->Object[Sample]|Model[Sample],
					SubstrateSolutionVolume->Null,
					StopSolutionVolume->Null,
					Data->Object[Data]
				}
			},
			SecondaryELISAPlateAssignment->{
				Category -> "Assay Plate",
				Description -> "The arrangement of samples and their corresponding reagents in the SecondaryELISAPlate.",
				Format -> Multiple,
				Class -> {
					Type->Expression,
					Sample->Link,
					Spike->Link,
					SpikeDilutionFactor->Real,
					SampleDilutionFactors->Expression,
					CoatingAntibody->Link,
					CoatingAntibodyDilutionFactor->Real,
					CaptureAntibody->Link,
					CaptureAntibodyDilutionFactor->Real,
					ReferenceAntigen->Link,
					ReferenceAntigenDilutionFactor->Real,
					PrimaryAntibody->Link,
					PrimaryAntibodyDilutionFactor->Real,
					SecondaryAntibody->Link,
					SecondaryAntibodyDilutionFactor->Real,
					CoatingVolume->Real,
					BlockingVolume->Real,
					SampleAntibodyComplexImmunosorbentVolume->Real,
					SampleImmunosorbentVolume->Real,
					PrimaryAntibodyImmunosorbentVolume->Real,
					SecondaryAntibodyImmunosorbentVolume->Real,
					SubstrateSolution->Link,
					StopSolution->Link,
					SubstrateSolutionVolume->Real,
					StopSolutionVolume->Real,
					Data->Link
				},
				Pattern :> {
					Type->ELISASampleTypeP,
					Sample->ObjectP[{Model[Sample], Object[Sample]}],
					Spike->ObjectP[{Model[Sample], Object[Sample]}],
					SpikeDilutionFactor->RangeP[0,1],
					SampleDilutionFactors -> {RangeP[0,1]..},
					CoatingAntibody->ObjectP[{Model[Sample], Object[Sample]}],
					CoatingAntibodyDilutionFactor->RangeP[0,1],
					CaptureAntibody->ObjectP[{Model[Sample], Object[Sample]}],
					CaptureAntibodyDilutionFactor->RangeP[0,1],
					ReferenceAntigen->ObjectP[{Model[Sample], Object[Sample]}],
					ReferenceAntigenDilutionFactor->RangeP[0,1],
					PrimaryAntibody->ObjectP[{Model[Sample], Object[Sample]}],
					PrimaryAntibodyDilutionFactor->RangeP[0,1],
					SecondaryAntibody->ObjectP[{Model[Sample], Object[Sample]}],
					SecondaryAntibodyDilutionFactor->RangeP[0,1],
					CoatingVolume->RangeP[0Microliter,300Microliter],
					BlockingVolume->RangeP[0Microliter,300Microliter],
					SampleAntibodyComplexImmunosorbentVolume->RangeP[0Microliter,300Microliter],
					SampleImmunosorbentVolume->RangeP[0Microliter,300Microliter],
					PrimaryAntibodyImmunosorbentVolume->RangeP[0Microliter,300Microliter],
					SecondaryAntibodyImmunosorbentVolume->RangeP[0Microliter,300Microliter],
					SubstrateSolution->ObjectP[{Model[Sample], Object[Sample]}],
					StopSolution->ObjectP[{Model[Sample], Object[Sample]}],
					SubstrateSolutionVolume->RangeP[0Microliter,300Microliter],
					StopSolutionVolume->RangeP[0Microliter,300Microliter],
					Data->_Link
				},
				Units -> {
					Type->None,
					Sample ->None,
					Spike->None,
					SpikeDilutionFactor->None,
					SampleDilutionFactors->None,
					CoatingAntibody->None,
					CoatingAntibodyDilutionFactor->None,
					CaptureAntibody->None,
					CaptureAntibodyDilutionFactor->None,
					ReferenceAntigen->None,
					ReferenceAntigenDilutionFactor->None,
					PrimaryAntibody->None,
					PrimaryAntibodyDilutionFactor->None,
					SecondaryAntibody->None,
					SecondaryAntibodyDilutionFactor->None,
					CoatingVolume->Microliter,
					BlockingVolume->Microliter,
					SampleAntibodyComplexImmunosorbentVolume->Microliter,
					SampleImmunosorbentVolume->Microliter,
					PrimaryAntibodyImmunosorbentVolume->Microliter,
					SecondaryAntibodyImmunosorbentVolume->Microliter,
					SubstrateSolution->None,
					StopSolution->None,
					SubstrateSolutionVolume->Microliter,
					StopSolutionVolume->Microliter,
					Data->None
				},
				Relation->{
					Type->Null,
					Sample ->Object[Sample]|Model[Sample],
					Spike->Object[Sample]|Model[Sample],
					SpikeDilutionFactor->Null,
					SampleDilutionFactors->Null,
					CoatingAntibody->Object[Sample]|Model[Sample],
					CoatingAntibodyDilutionFactor->Null,
					CaptureAntibody->Object[Sample]|Model[Sample],
					CaptureAntibodyDilutionFactor->Null,
					ReferenceAntigen->Object[Sample]|Model[Sample],
					ReferenceAntigenDilutionFactor->Null,
					PrimaryAntibody->Object[Sample]|Model[Sample],
					PrimaryAntibodyDilutionFactor->Null,
					SecondaryAntibody->Object[Sample]|Model[Sample],
					SecondaryAntibodyDilutionFactor->Null,
					CoatingVolume->Null,
					BlockingVolume->Null,
					SampleAntibodyComplexImmunosorbentVolume->Null,
					SampleImmunosorbentVolume->Null,
					PrimaryAntibodyImmunosorbentVolume->Null,
					SecondaryAntibodyImmunosorbentVolume->Null,
					SubstrateSolution->Object[Sample]|Model[Sample],
					StopSolution->Object[Sample]|Model[Sample],
					SubstrateSolutionVolume->Null,
					StopSolutionVolume->Null,
					Data->Object[Data]
				}
			},
			SampleAssemblyPlate -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container, Plate], Object[Container, Plate]}],
				Relation -> Model[Container, Plate]|Object[Container, Plate],
				Description -> "The deep well plate used to dilute samples, standards, spiking samples, mixing samples and antibodies, and antibody-sample complex incubation before loading them onto ELISAplate.",
				Category -> "Sample Preparation"
			},
			SecondarySampleAssemblyPlate -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container, Plate], Object[Container, Plate]}],
				Relation -> Model[Container, Plate]|Object[Container, Plate],
				Description -> "The deep well plated used to dilute samples, standards, spiking samples, mixing samples and antibodies, and antibody-sample complex incubation before loading them onto the SecondaryELISAPlate.",
				Category -> "Sample Preparation"
			},
			Tips -> {
				Format -> Multiple,
				Description -> "The tips needed for the liquid transfers in the ELISA instrument.",
				Pattern :> ObjectP[{Model[Item, Tips],Object[Item, Tips]}],
				Relation -> Model[Item, Tips]|Object[Item, Tips],
				Class -> Link,
				Developer -> True,
				Category -> "Resources"
			},
			(*----Developer Fields----*)
			SampleAssemblyWellIDs -> {
				Format -> Multiple,
				Description -> "The sample assembly plate and well number each sample/standard/blank and their dilutions correspond to.",
				Pattern:>{ObjectP[{Model[Container],Object[Container]}],WellP},
				Relation->{(Model[Container]|Object[Container]),Null},
				Class -> {Link,Expression},
				Category -> "General",
				Headers -> {"Sample Assembly Container","Well"},
				Developer -> True
			},
			AssayPlateAssemblyWellIDs -> {
				Format -> Multiple,
				Description -> "The ELISA plate and well number each sample/standard/blank and their dilutions correspond to.",
				Pattern:>{ObjectP[{Model[Container],Object[Container]}],WellP},
				Class -> {Link,Expression},
				Relation->{(Model[Container]|Object[Container]),Null},
				Category -> "General",
				Headers -> {"Assay Plate","Well"},
				Developer -> True
			},
			AntibodyAntigenDilutionQ -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicating if any antibodies need to be diluted with its diluent.",
				Category -> "General",
				Developer -> True
			},
			ExpandedWorkingSamples -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample], Model[Container], Object[Container]}],
				Relation -> Alternatives[Model[Sample], Object[Sample], Model[Container], Object[Container]],
				Description -> "Working samples joined with Standards and Blanks and expanded to match its corresponding well used for making SM primitives.",
				Category -> "General",
				Developer -> True
			},
			ExpandedDiluents -> {
				Format -> Multiple,
				Description -> "The Sample and Standard diluents expanded to match its corresponding well.",
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation->Alternatives[Model[Sample], Object[Sample]],
				Class -> Link,
				Category -> "General",
				Developer -> True
			},
			ExpandedSpikes -> {
				Format -> Multiple,
				Description -> "The Spikes expanded to match its corresponding well.",
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation->Alternatives[Model[Sample], Object[Sample]],
				Class -> Link,
				Category -> "General",
				Developer -> True
			},
			ExpandedConcentrateVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The concentrate volumes (Sample or previous dilution) expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedDiluentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The Sample and Antibody volumes expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedSpikeVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The Spike volumes expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedPrimaryAntibodySampleMixingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The PrimaryAntibody volumes used to mix with samples, expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedCaptureAntibodySampleMixingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The PrimaryAntibody volumes used to mix with samples, expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedSampleAssemblyTotalVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The Total volumes in each SampleAssembly well, used for pipetting mixing after sample assembly.",
				Category -> "General",
				Developer -> True
			},
			ExpandedSerialDilutionQ -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicating if the Concentrate of this dilution is drawn from the original sample or the previous dilution.",
				Category -> "General",
				Developer -> True
			},
			ExpandedWorkingPrimaryAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample], Model[Container], Object[Container]}],
				Relation -> Alternatives[Model[Sample], Object[Sample], Model[Container], Object[Container]],
				Description -> "The PrimaryAntibodies directly used for sample mixing or immunosorbent step, expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedWorkingSecondaryAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample], Model[Container], Object[Container]}],
				Relation -> Alternatives[Model[Sample], Object[Sample], Model[Container], Object[Container]],
				Description -> "The SecondaryAntibodies directly used for immunosorbent step,expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedWorkingCaptureAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample], Model[Container], Object[Container]}],
				Relation -> Alternatives[Model[Sample], Object[Sample], Model[Container], Object[Container]],
				Description -> "The CaptureAntibodies directly used for sample mixing or coating, expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedWorkingCoatingAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample], Model[Container], Object[Container]}],
				Relation -> Alternatives[Model[Sample], Object[Sample], Model[Container], Object[Container]],
				Description -> "The CoatingAntibodies directly used for coating, expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedWorkingReferenceAntigens -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample], Model[Container], Object[Container]}],
				Relation -> Alternatives[Model[Sample], Object[Sample], Model[Container], Object[Container]],
				Description -> "The ReferenceAntigens directly used for coating, expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedSampleCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The SampleCoatingVolumes expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedCaptureAntibodyCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The CaptureAntibodyCoatingVolumes expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedCoatingAntibodyCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The CoatingAntibodyCoatingVolumes expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedReferenceAntigenCoatingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The ReferenceAntigenCoatingVolumes expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedSampleImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The SampleImmunosorbentVolumes expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedSampleAntibodyComplexImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The SampleAntibodyComplexImmunosorbentVolumes expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedPrimaryAntibodyImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The PrimaryAntibodyImmunosorbentVolumes expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedSecondaryAntibodyImmunosorbentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The SecondaryAntibodyImmunosorbentVolumes expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			ExpandedSubstrateSolutions -> {
				Format -> Multiple,
				Description -> "The SubstrateSolutions, expanded to match its corresponding well.",
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Class -> Link,
				Relation->Alternatives[Model[Sample], Object[Sample]],
				Category -> "General",
				Developer -> True
			},
			ExpandedStopSolutions -> {
				Format -> Multiple,
				Description -> "The StopSolutions, expanded to match its corresponding well.",
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Class -> Link,
				Relation->Alternatives[Model[Sample], Object[Sample]],
				Category -> "General",
				Developer -> True
			},
			ExpandedSubstrateSolutionVolumes -> {
				Format -> Multiple,
				Description -> "The SubstrateSolutionVolumes expanded to match its corresponding well.",
				Pattern :> GreaterEqualP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "General",
				Developer -> True
			},
			ExpandedStopSolutionVolumes -> {
				Format -> Multiple,
				Description -> "The StopSolutionVolumes expanded to match its corresponding well.",
				Pattern :> GreaterEqualP[0 Microliter],
				Class -> Real,
				Units -> Microliter,
				Category -> "General",
				Developer -> True
			},
			ExpandedBlockingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The BlockingVolumes expanded to match its corresponding well.",
				Category -> "General",
				Developer -> True
			},
			WellExpandingParameters -> {
				Format -> Multiple,
				Description -> "A list of integers indicating how many wells a sample, standard, or blank will take up, based on NumberOfReplicates and DilutionCurves.",
				Pattern:>GreaterP[0],
				Class -> Real,
				Category -> "General",
				Developer -> True
			},
			DeckPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..}},
				Relation->{Object[Container] | Object[Sample] | Object[Item], Null},
				Description -> "A list of container placements to set up the ELISA instrument deck.",
				Category -> "Placements",
				Headers -> {"Container", "Placement Tree"},
				Developer -> True
			},
			VesselRackPlacements -> {
				Format -> Multiple,
				Class -> {Link,Link,Expression},
				Pattern :> {_Link,_Link,LocationPositionP},
				Relation -> {(Object[Container]|Model[Container]|Object[Sample]|Model[Sample]|Model[Item]|Object[Item]),(Object[Container]|Model[Container]),Null},
				Description -> "List of placements of vials into automation-friendly vial racks.",
				Category -> "Placements",
				Developer -> True,
				Headers -> {"Object to Place","Destination Object","Destination Position"}
			},
			ActiveTubeCarriers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container,Rack],
				Description -> "A list of tube racks on the liquid handler deck that are loaded with tubes and used in this protocol.",
				Category -> "Placements",
				Developer -> True
			},
			BufferContainerPlacements -> {
				Format -> Multiple,
				Class -> {Link, Expression},
				Pattern :> {_Link, {LocationPositionP..}},
				Relation -> {Object[Container] | Object[Sample] | Model[Sample], Null},
				Description -> "A list of deck placements used for placing buffers needed to run the protocol onto the instrument buffer deck.",
				Category -> "General",
				Developer -> True,
				Headers -> {"Object to Place", "Placement Tree"}
			},
			(*===Post Experiment Storage===*)
			SpikeStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleStorageTypeP|Disposal,
				Description -> "For each member of SamplesIn, the condition under which the unused portion of Spike stock sample should be stored after the protocol is completed.",
				Category -> "Sample Post-Processing",
				IndexMatching -> SamplesIn
			},
			CoatingAntibodyStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleStorageTypeP|Disposal,
				Description -> "For each member of SamplesIn, the condition under which the unused portion of CoatingAntibody stock should be stored after the protocol is completed.",
				Category -> "Sample Post-Processing",
				IndexMatching -> SamplesIn
			},
			CaptureAntibodyStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleStorageTypeP|Disposal,
				Description -> "For each member of SamplesIn, the condition under which the unused portion of Capture Antibody stock should be stored after the protocol is completed.",
				Category -> "Sample Post-Processing",
				IndexMatching -> SamplesIn
			},
			ReferenceAntigenStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleStorageTypeP|Disposal,
				Description -> "For each member of SamplesIn, the condition under which the unused portion of ReferenceAntigen stock should be stored after the protocol is completed.",
				Category -> "Sample Post-Processing",
				IndexMatching -> SamplesIn
			},
			PrimaryAntibodyStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleStorageTypeP|Disposal,
				Description -> "For each member of SamplesIn, the condition under which the unused portion of PrimaryAntibody stock should be stored after the protocol is completed.",
				Category -> "Sample Post-Processing",
				IndexMatching -> SamplesIn
			},
			SecondaryAntibodyStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleStorageTypeP|Disposal,
				Description -> "For each member of SamplesIn, the condition under which the unused portion of SecondaryAntibody stock should be stored after the protocol is completed.",
				Category -> "Sample Post-Processing",
				IndexMatching -> SamplesIn
			},
			CoatingAntibodyConcentrateStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleStorageTypeP|Disposal,
				Description -> "The condition under which the unused portion of CoatingAntibodyConcentrate samples should be stored after the protocol is completed.",
				Category -> "Sample Post-Processing"
			},
			CaptureAntibodyConcentrateStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleStorageTypeP|Disposal,
				Description -> "The condition under which the unused portion of CaptureAntibodyConcentrate samples should be stored after the protocol is completed.",
				Category -> "Sample Post-Processing"
			},
			ReferenceAntigenConcentrateStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleStorageTypeP|Disposal,
				Description -> "The condition under which the unused portion of ReferenceAntigenConcentrate samples should be stored after the protocol is completed.",
				Category -> "Sample Post-Processing"
			},
			PrimaryAntibodyConcentrateStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleStorageTypeP|Disposal,
				Description -> "The condition under which the unused portion of PrimaryAntibodyConcentrate samples should be stored after the protocol is completed.",
				Category -> "Sample Post-Processing"
			},
			SecondaryAntibodyConcentrateStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleStorageTypeP|Disposal,
				Description -> "The condition under which the unused portion of SecondaryAntibodyConcentrate samples should be stored after the protocol is completed.",
				Category -> "Sample Post-Processing"
			},
			StandardStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleStorageTypeP|Disposal,
				Description -> "For each member of Standards, the condition under which the unused portion of Standard stock should be stored after the protocol is completed.",
				Category -> "Sample Post-Processing",
				IndexMatching -> Standards
			},
			BlankStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleStorageTypeP|Disposal,
				Description -> "For each member of Blanks, the condition under which the unused portion of Blank stock should be stored after the protocol is completed.",
				Category -> "Sample Post-Processing",
				IndexMatching -> Blanks
			}
		}
	}
];

