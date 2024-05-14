(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, CapillaryELISA],
    {
        Description -> "A protocol for performing a capillary Enzyme-Linked Immunosorbent Assay (ELISA) experiment on the provided samples for the detection and quantification of certain analytes.",
        CreatePrivileges -> None,
        Cache -> Session,
        Fields -> {

            Instrument -> {
                Format -> Single,
                Class -> Link,
                Pattern :> ObjectP[{Object[Instrument, CapillaryELISA], Model[Instrument, CapillaryELISA]}],
                Relation -> Object[Instrument, CapillaryELISA] | Model[Instrument, CapillaryELISA],
                Description -> "The detection and quantification capillary ELISA device on which the protocol is run. The instrument accepts the cartridge loaded with samples and buffers, loads the samples into the capillaries, performs the ELISA experiment and detects the signals to quantify certain analytes.",
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
                Pattern :> _String,
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
                Pattern :> _String,
                Description -> "The file path of the data file generated at the conclusion of the experiment.",
                Category -> "General",
                Developer -> True
            },

			CartridgeType -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> ELISACartridgeTypeP,
				Description -> "The format of the capillary ELISA cartridge plate (SinglePlex72X1, MultiAnalyte32X4, MultiAnalyte16X4, MultiPlex32X8 or Customizable) used in this capillary ELISA protocol. The pre-loaded CartridgeType (SinglePlex72X1, MultiAnalyte16X4, MultiAnalyte32X4 and MultiPlex32X8) is pre-loaded with validated ELISA assay.",
				Category -> "General"
			},
            Cartridge -> {
                Format -> Single,
                Class -> Link,
                Pattern :> ObjectP[{Model[Container, Plate, Irregular, CapillaryELISA],Object[Container, Plate, Irregular, CapillaryELISA]}],
                Relation -> Model[Container, Plate, Irregular, CapillaryELISA] | Object[Container, Plate, Irregular, CapillaryELISA],
                Description -> "The capillary ELISA cartridge plate that is used in the instrument to perform ELISA experiments and quantify the analytes (such as peptides, proteins, antibodies and hormones) in the samples by ELISA.",
                Category -> "General"
            },
            Species -> {
                Format -> Single,
                Class -> Expression,
                Pattern :> ELISASpeciesP,
                Description -> "The organism (human, mouse or rat) that the samples (containing analytes of interest) are derived from.",
                Category -> "General"
            },
			Multiplex -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the protocol is a capillaryELISA protocol to detect and quantify multiple analytes in the same sample.",
				Category -> "General"
			},
			AnalyteMolecules -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[Model[Molecule]],
				Relation -> Model[Molecule],
				Description -> "For each member of SamplesIn, the identity model of the molecule (e.g., peptides, proteins, antibodies, hormones) detected and quantified in the samples through this capillary ELISA experiment.",
				Category -> "General",
				IndexMatching -> SamplesIn
			},
			AnalyteNames -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> CapillaryELISAAnalyteP,
				Description -> "For each member of SamplesIn, the manufacturer's listed name(s) of the ELISA analyte(s) (e.g., peptides, proteins, antibodies, hormones) detected in the pre-loaded capillary ELISA cartridge assay.",
				Category -> "General",
				IndexMatching -> SamplesIn
			},
			MultiplexAnalyteMolecules -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[Model[Molecule]],
				Relation -> Model[Molecule],
				Description -> "The multiplex analytes that are detected and quantified simultaneously in all the samples through this capillary ELISA experiment.",
				Category -> "General"
			},
			MultiplexAnalyteNames -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> CapillaryELISAAnalyteP,
				Description -> "For each member of MultiplexAnalyteMolecules, the manufacturer's listed name of the analyte that us detected and quantified simultaneously in all the samples in a pre-loaded capillary ELISA cartridge through this capillary ELISA experiment.",
				Category -> "General",
				IndexMatching -> MultiplexAnalyteMolecules
			},
			ManufacturingSpecifications -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[Object[ManufacturingSpecification]],
				Relation -> Object[ManufacturingSpecification],
				Description -> "The manufacturing specifications with the detailed information (including the PDF specification sheets) about the pre-loaded analytes in the pre-loaded capillary ELISA cartridge, provided by the manufacturer of the capillary ELISA cartridge.",
				Category -> "General"
			},
			UpperQuantitationLimits->{
				Format -> Multiple,
				Class->{String,Real},
				Pattern:>{_String,GreaterEqualP[0*Picogram/Milliliter]},
				Units->{None,Picogram/Milliliter},
				Description->"The average Upper Limit of Quantitation (ULOQ) concentrations of the analytes of the pre-loaded capillary ELISA cartridge. The values are determined by the assay developer through analysis of repeated ELISA experiments using multiple capillary ELISA cartridges. The concentrations of the analytes in the sample loaded into the capillary ELISA cartridge are expected to fall below ULOQ for the best quantifiaction result.",
				Headers -> {"Analyte","Upper Limit of Quantitation"},
				Category -> "General"
			},
			LowerQuantitationLimits->{
				Format -> Multiple,
				Class->{String,Real},
				Pattern:>{_String,GreaterEqualP[0*Picogram/Milliliter]},
				Units->{None,Picogram/Milliliter},
				Description->"The average Lower Limit of Quantitation (LLOQ) concentrations of the analytes of the pre-loaded capillary ELISA cartridge. The values are determined by the assay developer through analysis of repeated ELISA experiments using multiple capillary ELISA cartridges. The concentrations of the analytes in the sample loaded into the capillary ELISA cartridge are expected to fall above LLOQ for the best quantifiaction result.",
				Headers -> {"Analyte","Upper Limit of Quantitation"},
				Category -> "General"
			},
			
			SampleVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the amount of the input sample that is aliquoted from its original container.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},
			SpikeSamples -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of SamplesIn, the sample with known concentration(s) of analyte(s) mixed with the input sample to increase the concentration of the analyte(s) before any further dilution is performed.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},
			SpikeVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of the SpikeSample mixed with the input sample before further dilution is performed.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},
			SpikeContainer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container], Object[Container]}],
				Relation -> Model[Container] | Object[Container],
				Description -> "The container in which each sample is mixed with the corresponding SpikeSample.",
				Category -> "Sample Preparation",
				Developer -> True
			},

			SerialDilution -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SamplesIn, indicates whether the dilution used for the sample is the stepwise dilution or not. To perform a serial dilution, a small amount of a well-mixed solution is transferred into a new container and additional diluent is added to dilute the original solution. The diluted sample is then used as the base solution to make an additional dilution.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},
			
			DilutionAssayVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the total preparation volume of each diluted sample in the non-serial dilution series.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},
			StartingDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0,1],
				Description -> "For each member of SamplesIn, the dilution factor of the first diluted sample compared to the original input sample in the non-serial dilution series.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},
			DilutionFactorIncrements -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0,1],
				Description -> "For each member of SamplesIn, the constant dilution factor increase of the diluted samples in the non-serial dilution series.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},
			NumberOfDilutions -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterEqualP[0,1],
				Description -> "For each member of SamplesIn, the number of diluted samples prepared in the non-serial dilution series. The dilution factor difference between the two adjacent samples is presented by DilutionFactorIncrements.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},
			(* This is the case that a list of list must be used when the dilutions cannot be represented by linear series *)
			DilutionCurves -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0Microliter], GreaterEqualP[0Microliter]}..},
				Description -> "For each member of SamplesIn, the collection of dilutions performed on the sample (after spiking) before loaded into capillary ELISA cartridge. This is the volume of the sample and the volume of the corresponding Diluents that is mixed together for each concentration in the dilution curve.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},

			SerialDilutionAssayVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the total preparation volume of each diluted sample in the serial dilution series.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},
			SerialDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0,1],
				Description -> "For each member of SamplesIn, the constant stepwise dilution factor of the diluted samples in the serial dilution series.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},
			NumberOfSerialDilutions -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterEqualP[0,1],
				Description -> "For each member of SamplesIn, the number of diluted samples prepared in the serial dilution series.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},
			(* This is the case that a list of list must be used when the dilution factors are not constant in the serial dilution series *)
			SerialDilutionCurves -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0 Microliter], GreaterEqualP[0 Microliter]}..},
				Description -> "For each member of SamplesIn, the collection of serial dilutions performed on the sample (after spiking) before loaded into capillary ELISA cartridge. This is the volume taken out of the sample and transferred serially and the volume of the corresponding Diluents that is mixed with at each step.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},

			Diluents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				Relation -> Object[Sample] | Model[Sample],
				Description -> "For each member of SamplesIn, the buffer that is used to dilute the input sample (after spiking, if applicable).",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},
			DilutionContainer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container], Object[Container]}],
				Relation -> Model[Container] | Object[Container],
				Description -> "The container in which each sample is diluted with the corresponding Diluents to make the dilution series. This also includes the dilution of the standard samples with StandardDiluents.",
				Category -> "Sample Preparation",
				Developer -> True
			},
			DilutionMixVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume that is pipetted up and down to mix the sample with the corresponding Diluents to make the dilution series.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},
			DilutionNumberOfMixes -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> RangeP[0, 20, 1],
				Description -> "For each member of SamplesIn, the number of pipette up and down cycles that is used to mix the sample with the corresponding Diluents to make the dilution series.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},
			DilutionMixRates -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0.4 Microliter / Second, 250 Microliter / Second],
				Units -> Microliter / Second,
				Description -> "For each member of SamplesIn, the speed at which the DilutionMixVolumes is pipetted up and down to mix the sample with the corresponding Diluents to make the dilution series.",
				IndexMatching -> SamplesIn,
				Category -> "Sample Preparation"
			},

            CustomCaptureAntibodies -> {
                Format -> Multiple,
                Class -> Link,
                Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
                Relation -> Model[Sample] | Object[Sample],
                Description -> "For each member of SamplesIn, the capture antibody samples used in this protocol to bind with analytes in the input samples through specific antigen-antibody interaction and capture the analytes into capillaries for detection. The capture antibody samples are resuspended (if in solid state), bioconjugated with digoxigenin and diluted before loaded into the customizable capillary ELISA cartridge.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
            },
			
			CaptureAntibodyResuspensions -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SamplesIn, indicates if resuspension is required to be performed on the solid state CustomCaptureAntibodies sample to turn the sample into solution.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			CaptureAntibodyResuspensionConcentrations -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0Molar]|GreaterP[0Gram/Liter],
				Description -> "For each member of SamplesIn, the target concentration of the CustomCaptureAntibodies sample in the solution after resuspension.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			CaptureAntibodyResuspensionDiluents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of SamplesIn, the resuspension buffer mixed with the solid state CustomCaptureAntibodies sample to dissolve the sample into solution.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
            CaptureAntibodyResuspensionDiluentVolumes -> {
                Format -> Multiple,
                Class -> Real,
                Pattern :> GreaterEqualP[0Microliter],
                Units -> Microliter,
                Description -> "For each member of SamplesIn, the volume of diluent buffer required for resuspension of solid state CustomCaptureAntibodies sample into solution of desired concentration.",
                IndexMatching -> SamplesIn,
                Developer -> True,
				Category -> "Capture Antibody Preparation"
            },
			CaptureAntibodyStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[SampleStorageTypeP,Disposal],
				Description -> "For each member of SamplesIn, the condition under which the unused portion of resuspended CustomCaptureAntibodies sample inside its original container is stored after the protocol is completed.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			
			CaptureAntibodyConjugations -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SamplesIn, indicates if bioconjugation reaction between digoxigenin NHS-ester and primary amines of the capture antibody is required to be performed to prepare digoxigenin-labeled capture antibody sample for capillary ELISA experiment.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			CaptureAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of the unconjugated capture antibody sample used to react with DigoxigeninReagents to prepare digoxigenin-labeled capture antibody sample through bioconjugation synthesis.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			DigoxigeninReagents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of SamplesIn, the digoxigenin NHS-ester reagent used to react with the primary amines of the unconjugated CustomCaptureAntibodies sample to prepare digoxigenin-labeled capture antibody sample through bioconjugation synthesis.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			DigoxigeninReagentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of DigoxigeninReagents used to react with CaptureAntibodyVolumes of the unconjugated CustomCaptureAntibodies sample to prepare digoxigenin-labeled capture antibody sample through bioconjugation synthesis.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			CaptureAntibodyConjugationBuffers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of SamplesIn, the buffer solution in which the reaction between the unconjugated CustomCaptureAntibodies sample and DigoxigeninReagent happens to prepare digoxigenin-labeled capture antibody sample through bioconjugation synthesis.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			CaptureAntibodyConjugationBufferVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of CaptureAntibodyConjugationBuffers used to mix with the unconjugated CustomCaptureAntibodies and DigoxigeninReagents to provide a buffered environment for the bioconjugation reaction.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			CaptureAntibodyConjugationContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container], Object[Container]}],
				Relation -> Model[Container] | Object[Container],
				Description -> "For each member of SamplesIn, the container in which the unconjugated CustomCaptureAntibodies sample, DigoxigeninReagents and CaptureAntibodyConjugationBuffers react to allow bioconjugation synthesis.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			CaptureAntibodyConjugationTimes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Minute],
				Units -> Minute,
				Description -> "For each member of SamplesIn, the amount of reaction time that the CustomCaptureAntibodies and DigoxigeninReagents are allowed to react before purification happens.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			CaptureAntibodyConjugationTemperatures -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Kelvin],
				Units -> Celsius,
				Description -> "For each member of SamplesIn, the temperature at which the reaction between the unconjugated CustomCaptureAntibodies and DigoxigeninReagents is conducted.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			CaptureAntibodyPurificationColumns -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel,Filter], Object[Container,Vessel,Filter]}],
				Relation -> Model[Container,Vessel,Filter] | Object[Container,Vessel,Filter],
				Description -> "For each member of SamplesIn, the desalting spin column used to adsorb the molecules that are smaller than its molecular weight cut-off (MWCO) on its resin bed to remove the free digoxigenin NHS-ester molecules in order to purify the synthesis product of the capture antibody bioconjugation reaction.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			CaptureAntibodyColumnWashBuffers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of SamplesIn, the buffer solution loaded into the CaptureAntibodyPurificationColumns after its storage buffer is removed and before the sample is loaded.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			CaptureAntibodyColumnWashContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of SamplesIn, the collection container used with CaptureAntibodyPurificationColumns to collect the storage buffer or wash buffer before the conjugation reaction product is loaded for purification.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation",
				Developer -> True
			},
			CaptureAntibodyColumnWasteContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of SamplesIn, the collection container to collect the storage buffer or wash buffer during the purification process for disposal.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation",
				Developer -> True
			},
			CaptureAntibodyConjugationCollectionVials -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of SamplesIn, the collection container used with CaptureAntibodyPurificationColumns to collect the final purified antibody sample for storage.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation",
				Developer -> True
			},
			CaptureAntibodyConjugationStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[SampleStorageTypeP, Disposal],
				Description -> "For each member of SamplesIn, indicates the condition under which the unused portion of the synthesized and purified digoxigenin-labeled capture antibody sample is stored after the protocol is completed.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},

			CaptureAntibodyDilutions -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SamplesIn, indicates if dilution is required to be performed on the digoxigenin-labeled capture antibody sample with the specified CaptureAntibodyDiluents to make a sample with desired concentration to be loaded into the customizable cartridge for ELISA experiment of the input sample.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			CaptureAntibodyAbsorbanceBlanks -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of SamplesIn, the blank sample whose absorbance is subtracted as background from the absorbance readings of the initial antibody sample to determine its accurate concentration for dilution.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation",
				Developer -> True
			},
			CaptureAntibodyAbsorbanceIntensities -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> UnitsP[AbsorbanceUnit],
				Units -> AbsorbanceUnit,
				Description -> "The absorbance intensity of the initial capture antibody sample measured at 280 nm, with the blank absorbance subtracted, used to determine the initial concentration of the capture antibody sample before dilution.",
				Category -> "Capture Antibody Preparation",
				Developer -> True
			},
			CaptureAntibodyInitialConcentrations -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0Molar]|GreaterP[0Gram/Liter],
				Description -> "For each member of SamplesIn, the initial concentration of the digoxigenin-labeled capture antibody before dilution.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation",
				Developer -> True
			},
			CaptureAntibodyTargetConcentrations -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0Molar]|GreaterP[0Gram/Liter],
				Description -> "For each member of SamplesIn, the desired concentration of the digoxigenin-labeled capture antibody after dilution.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			CaptureAntibodyDiluents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of SamplesIn, the buffer solution used to mix with the concentrated digoxigenin-labeled capture antibody sample to achieve the desired CaptureAntibodyTargetConcentrations for cartridge loading.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation"
			},
			CaptureAntibodyDilutionContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of SamplesIn, the container used to dilute the capture antibody samples for cartridge loading.",
				IndexMatching -> SamplesIn,
				Category -> "Capture Antibody Preparation",
				Developer -> True
			},

			CustomDetectionAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of SamplesIn, the detection antibody sample used in the sandwich ELISA experiment to incubate with analytes through specific antigen-antibody interaction after their binding with capture antibody to provide detection attachment sites for streptavidin-conjugated fluorescent dye. The detection antibody samples are resuspended (if in solid state), bioconjugated with biotin and diluted before loaded into the customizable capillary ELISA cartridge.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},

			DetectionAntibodyResuspensions -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SamplesIn, indicates if resuspension is required to be performed on the solid state CustomDetectionAntibodies sample to turn the sample into solution.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyResuspensionConcentrations -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0Molar]|GreaterP[0Gram/Liter],
				Description -> "For each member of SamplesIn, the target concentration of the CustomDetectionAntibodies sample in the solution after resuspension.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyResuspensionDiluents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of SamplesIn, the resuspension buffer mixed with the solid state CustomDetectionAntibodies sample to dissolve the sample into solution.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyResuspensionDiluentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of diluent buffer required for resuspension of solid state CustomDetectionAntibodies sample into solution of desired concentration.",
				IndexMatching -> SamplesIn,
				Developer -> True,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[SampleStorageTypeP,Disposal],
				Description -> "For each member of SamplesIn, the condition under which the unused portion of resuspended CustomDetectionAntibodies sample inside its original container is stored after the protocol is completed.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},

			DetectionAntibodyConjugations -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SamplesIn, indicates if bioconjugation reaction between Biotin-XX-SE (6-((6-((Biotinoyl)Amino)Hexanoyl)Amino)Hexanoic Acid, Succinimidyl Ester) and primary amines of the CustomDetectionAntibody is required to be performed to prepare biotinylated detection antibody sample for capillary ELISA experiment.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of the unconjugated detection antibody sample used to react with BiotinReagents to prepare biotinylated detection antibody sample through bioconjugation synthesis.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			BiotinReagents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of SamplesIn, the digoxigenin NHS-ester reagent used to react with the primary amines of the unconjugated CustomDetectionAntibodies sample to prepare biotinylated detection antibody sample through bioconjugation synthesis.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			BiotinReagentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of BiotinReagents used to react with DetectionAntibodyVolumes of the unconjugated CustomDetectionAntibodies sample to prepare biotinylated detection antibody sample through bioconjugation synthesis.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyConjugationBuffers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of SamplesIn, the buffer solution in which the reaction between the unconjugated CustomDetectionAntibodies sample and BiotinReagents happens to prepare biotinylated detection antibody sample through bioconjugation synthesis.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyConjugationBufferVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of DetectionAntibodyConjugationBuffers used to mix with the unconjugated CustomDetectionAntibodies and BiotinReagents to provide a buffered environment for the bioconjugation reaction.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyConjugationContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container], Object[Container]}],
				Relation -> Model[Container] | Object[Container],
				Description -> "For each member of SamplesIn, the container in which the unconjugated CustomDetectionAntibodies sample, BiotinReagents and DetectionAntibodyConjugationBuffers react to allow bioconjugation synthesis.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyConjugationTimes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Minute],
				Units -> Minute,
				Description -> "For each member of SamplesIn, the amount of reaction time that the CustomDetectionAntibodies and BiotinReagents are allowed to react before purification happens.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyConjugationTemperatures -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Kelvin],
				Units -> Celsius,
				Description -> "For each member of SamplesIn, the temperature at which the reaction between the unconjugated CustomDetectionAntibodies and BiotinReagents is conducted.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyPurificationColumns -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel,Filter], Object[Container,Vessel,Filter]}],
				Relation -> Model[Container,Vessel,Filter] | Object[Container,Vessel,Filter],
				Description -> "For each member of SamplesIn, the desalting spin column used to adsorb the molecules that are smaller than its molecular weight cut-off (MWCO) on its resin bed to remove the free biotinylation reagent molecules in order to purify the synthesis product of the detection antibody bioconjugation reaction.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyColumnWashBuffers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of SamplesIn, the buffer solution loaded into the DetectionAntibodyPurificationColumns after its storage buffer is removed and before the sample is loaded.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyColumnWashContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of SamplesIn, the collection container used with DetectionAntibodyPurificationColumns to collect the storage buffer or wash buffer before the conjugation reaction product is loaded for purification.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation",
				Developer -> True
			},
			DetectionAntibodyColumnWasteContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of SamplesIn, the collection container to collect the storage buffer or wash buffer during the purification process for disposal.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation",
				Developer -> True
			},
			DetectionAntibodyConjugationCollectionVials -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of SamplesIn, the collection container used with DetectionAntibodyPurificationColumns to collect the final purified antibody sample for storage.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation",
				Developer -> True
			},
			DetectionAntibodyConjugationStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[SampleStorageTypeP, Disposal],
				Description -> "For each member of SamplesIn, indicates the condition under which the unused portion of the synthesized and purified biotinylated detection antibody sample is stored after the protocol is completed.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},

			DetectionAntibodyDilutions -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SamplesIn, indicates if dilution is required to be performed on the biotinylated detection antibody sample with the specified DetectionAntibodyDiluents to make a sample with desired concentration to be loaded into the customizable cartridge for ELISA experiment of the input sample.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyAbsorbanceBlanks -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of SamplesIn, the blank sample whose absorbance is subtracted as background from the absorbance readings of the initial antibody sample to determine its accurate concentration for dilution.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation",
				Developer -> True
			},
			DetectionAntibodyAbsorbanceIntensities -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> UnitsP[AbsorbanceUnit],
				Units -> AbsorbanceUnit,
				Description -> "The absorbance intensity of the initial detection antibody sample measured at 280 nm, with the blank absorbance subtracted, used to determine the initial concentration of the detection antibody sample before dilution.",
				Category -> "Detection Antibody Preparation",
				Developer -> True
			},
			DetectionAntibodyInitialConcentrations -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0Molar]|GreaterP[0Gram/Liter],
				Description -> "For each member of SamplesIn, the initial concentration of the digoxigenin-labeled detection antibody before dilution.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation",
				Developer -> True
			},
			DetectionAntibodyTargetConcentrations -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0Molar]|GreaterP[0Gram/Liter],
				Description -> "For each member of SamplesIn, the desired concentration of the biotinylated detection antibody after dilution.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyDiluents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of SamplesIn, the buffer solution used to mix with the concentrated biotinylated detection antibody sample to achieve the desired DetectionAntibodyTargetConcentrations for cartridge loading.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation"
			},
			DetectionAntibodyDilutionContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of SamplesIn, the container used to dilute the detection antibody samples for cartridge loading.",
				IndexMatching -> SamplesIn,
				Category -> "Detection Antibody Preparation",
				Developer -> True
			},

            Standards -> {
                Format -> Multiple,
                Class -> Link,
                Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
                Relation -> Model[Sample] | Object[Sample],
                Description -> "The standard samples with known concentration(s) of analyte(s) run with the input unknown samples in the same capillary ELISA experiment. The standard samples are resuspended (if in solid state) and diluted before loaded into the capillary ELISA cartridge.",
                Category -> "Standard Preparation"
            },
			StandardResuspensions -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of Standards, indicates if resuspension is required to be performed on the solid state Standards sample to turn the sample into solution.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
			},
			StandardResuspensionConcentrations -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0Molar]|GreaterP[0Gram/Liter],
				Description -> "For each member of Standards, the target concentration of the Standards sample in the solution after resuspension.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
			},
			StandardResuspensionDiluents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the resuspension buffer mixed with the solid state Standards sample to dissolve the sample into solution.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
			},
			StandardStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[SampleStorageTypeP,Disposal],
				Description -> "For each member of Standards, the condition under which the unused portion of the resuspended Standards inside its original container is stored after the protocol is completed.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
			},
            StandardResuspensionDiluentVolumes -> {
                Format -> Multiple,
                Class -> Real,
                Pattern :> GreaterEqualP[0Microliter],
                Units -> Microliter,
                Description -> "For each member of Standards, the volume of diluent buffer required for resuspension of solid state standard sample into solution of desired concentration.",
                IndexMatching -> Standards,
                Developer -> True,
				Category -> "Standard Preparation"
            },

			StandardSerialDilution -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of Standards, indicates whether the dilution used for the standard sample is the stepwise dilution or not. To perform a serial dilution, a small amount of a well-mixed solution is transferred into a new container and additional diluent is added to dilute the original solution. The diluted sample is then used as the base solution to make an additional dilution.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
			},

			StandardDilutionAssayVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the total preparation volume of each diluted sample in the non-serial dilution series.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
			},
			StandardStartingDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0,1],
				Description -> "For each member of Standards, the dilution factor of the first diluted sample compared to the original standard sample in the non-serial dilution series.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
			},
			StandardDilutionFactorIncrements -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0,1],
				Description -> "For each member of Standards, the constant dilution factor increase of the diluted samples in the non-serial dilution series.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
			},
			StandardNumberOfDilutions -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterEqualP[0,1],
				Description -> "For each member of Standards, the number of diluted samples prepared in the non-serial dilution series. The dilution factor difference between the two adjacent samples is presented by StandardDilutionFactorIncrements.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
			},
			(* This is the case that a list of list must be used when the dilutions cannot be represented by linear series *)
			StandardDilutionCurves -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0Microliter], GreaterEqualP[0Microliter]}..},
				Description -> "For each member of Standards, the collection of dilutions performed on the standard sample before loaded into capillary ELISA cartridge. This is the volume of the sample and the volume of the corresponding Diluents that is mixed together for each concentration in the dilution curve.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
			},

			StandardSerialDilutionAssayVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the total preparation volume of each diluted sample in the serial dilution series.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
			},
			StandardSerialDilutionFactors -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0,1],
				Description -> "For each member of Standards, the constant stepwise dilution factor of the diluted samples in the serial dilution series.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
			},
			StandardNumberOfSerialDilutions -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterEqualP[0,1],
				Description -> "For each member of Standards, the number of diluted samples prepared in the serial dilution series.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
			},
			(* This is the case that a list of list must be used when the dilution factors are not constant in the serial dilution series *)
			StandardSerialDilutionCurves -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0 Microliter], GreaterEqualP[0 Microliter]}..},
				Description -> "For each member of Standards, the collection of serial dilutions performed on the standard sample before loaded into capillary ELISA cartridge. This is the volume taken out of the sample and transferred serially and the volume of the corresponding Diluents that is mixed with at each step.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
			},

            StandardDiluents -> {
                Format -> Multiple,
                Class -> Link,
                Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
                Relation -> Object[Sample] | Model[Sample],
                Description -> "For each member of Standards, the diluent buffer that is used to mix with the standard sample to make the concentration series.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
            },
            StandardDilutionMixVolumes -> {
                Format -> Multiple,
                Class -> Real,
                Pattern :> GreaterEqualP[0Microliter],
                Units -> Microliter,
                Description -> "For each member of Standards, the volume that is pipetted up and down to mix the standard sample with the corresponding StandardDiluents to make the concentration series.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
            },
            StandardDilutionNumberOfMixes -> {
                Format -> Multiple,
                Class -> Integer,
                Pattern :> RangeP[0, 20, 1],
                Description -> "For each member of Standards, the number of pipette up and down cycles that is used to mix the standard sample with the corresponding StandardDiluents to make the concentration series.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
            },
            StandardDilutionMixRates -> {
                Format -> Multiple,
                Class -> Real,
                Pattern :> RangeP[0.4 Microliter / Second, 250 Microliter / Second],
                Units -> Microliter / Second,
                Description -> "For each member of Standards, the speed at which the DilutionMixVolume is pipetted up and down to mix the standard sample with the corresponding StandardDiluents to make the concentration series.",
				IndexMatching -> Standards,
				Category -> "Standard Preparation"
            },

			StandardCaptureAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the standard capture antibody samples used in this protocol to bind with analytes in the input samples through specific antigen-antibody interaction and capture the analytes into capillaries for detection. The standard capture antibody samples are resuspended (if in solid state), bioconjugated with digoxigenin and diluted before loaded into the Standardizable capillary ELISA cartridge.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},

			StandardCaptureAntibodyResuspensions -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of Standards, indicates if resuspension is required to be performed on the solid state StandardCaptureAntibodies sample to turn the sample into solution.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyResuspensionConcentrations -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0Molar]|GreaterP[0Gram/Liter],
				Description -> "For each member of Standards, the target concentration of the StandardCaptureAntibodies sample in the solution after resuspension.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyResuspensionDiluents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the resuspension buffer mixed with the solid state StandardCaptureAntibodies sample to dissolve the sample into solution.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[SampleStorageTypeP,Disposal],
				Description -> "For each member of Standards, the condition under which the unused portion of resuspended StandardCaptureAntibodies sample inside its original container is stored after the protocol is completed.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyResuspensionDiluentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of diluent buffer required for resuspension of solid state StandardCaptureAntibodies sample into solution of desired concentration.",
				IndexMatching -> Standards,
				Developer -> True,
				Category -> "Standard Capture Antibody Preparation"
			},

			StandardCaptureAntibodyConjugations -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of Standards, indicates if bioconjugation reaction between digoxigenin NHS-ester and primary amines of the standard capture antibody is required to be performed to prepare digoxigenin-labeled standard capture antibody sample for capillary ELISA experiment.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of the unconjugated standard capture antibody sample used to react with DigoxigeninReagents to prepare digoxigenin-labeled standard capture antibody sample through bioconjugation synthesis.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardDigoxigeninReagents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the digoxigenin NHS-ester reagent used to react with the primary amines of the unconjugated StandardCaptureAntibodies sample to prepare digoxigenin-labeled standard capture antibody sample through bioconjugation synthesis.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardDigoxigeninReagentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of DigoxigeninReagents used to react with StandardCaptureAntibodyVolumes of the unconjugated StandardCaptureAntibodies sample to prepare digoxigenin-labeled standard capture antibody sample through bioconjugation synthesis.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyConjugationBuffers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the buffer solution in which the reaction between the unconjugated StandardCaptureAntibodies sample and DigoxigeninReagent happens to prepare digoxigenin-labeled standard capture antibody sample through bioconjugation synthesis.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyConjugationBufferVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of StandardCaptureAntibodyConjugationBuffers used to mix with the unconjugated StandardCaptureAntibodies and DigoxigeninReagents to provide a buffered environment for the bioconjugation reaction.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyConjugationContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container], Object[Container]}],
				Relation -> Model[Container] | Object[Container],
				Description -> "For each member of Standards, the container in which the unconjugated StandardCaptureAntibodies sample, DigoxigeninReagents and StandardCaptureAntibodyConjugationBuffers react to allow bioconjugation synthesis.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyConjugationTimes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Minute],
				Units -> Minute,
				Description -> "For each member of Standards, the amount of reaction time that the StandardCaptureAntibodies and DigoxigeninReagents are allowed to react before purification happens.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyConjugationTemperatures -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Kelvin],
				Units -> Celsius,
				Description -> "For each member of Standards, the temperature at which the reaction between the unconjugated StandardCaptureAntibodies and DigoxigeninReagents is conducted.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyPurificationColumns -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel,Filter], Object[Container,Vessel,Filter]}],
				Relation -> Model[Container,Vessel,Filter] | Object[Container,Vessel,Filter],
				Description -> "For each member of Standards, the desalting spin column used to adsorb the molecules that are smaller than its molecular weight cut-off (MWCO) on its resin bed to remove the free digoxigenin NHS-ester molecules in order to purify the synthesis product of the standard capture antibody bioconjugation reaction.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyColumnWashBuffers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the buffer solution loaded into the StandardCaptureAntibodyPurificationColumns after its storage buffer is removed and before the sample is loaded.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyColumnWashContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of Standards, the collection container used with StandardCaptureAntibodyPurificationColumns to collect the storage buffer or wash buffer before the conjugation reaction product is loaded for purification.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation",
				Developer -> True
			},
			StandardCaptureAntibodyColumnWasteContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of Standards, the collection container to collect the storage buffer or wash buffer during the purification process for disposal.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation",
				Developer -> True
			},
			StandardCaptureAntibodyConjugationCollectionVials -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of Standards, the collection container used with StandardCaptureAntibodyPurificationColumns to collect the final purified antibody sample for storage.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation",
				Developer -> True
			},
			StandardCaptureAntibodyConjugationStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[SampleStorageTypeP, Disposal],
				Description -> "For each member of Standards, indicates the condition under which the unused portion of the synthesized and purified digoxigenin-labeled standard capture antibody sample is stored after the protocol is completed.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},

			StandardCaptureAntibodyDilutions -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of Standards, indicates if dilution is required to be performed on the digoxigenin-labeled standard capture antibody sample with the specified StandardCaptureAntibodyDiluents to make a sample with desired concentration to be loaded into the Standardizable cartridge for ELISA experiment of the input sample.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyAbsorbanceBlanks -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the blank sample whose absorbance is subtracted as background from the absorbance readings of the initial antibody sample to determine its accurate concentration for dilution.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation",
				Developer -> True
			},
			StandardCaptureAntibodyAbsorbanceIntensities -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> UnitsP[AbsorbanceUnit],
				Units -> AbsorbanceUnit,
				Description -> "The absorbance intensity of the initial standard capture antibody sample measured at 280 nm, with the blank absorbance subtracted, used to determine the initial concentration of the standard capture antibody sample before dilution.",
				Category -> "Standard Capture Antibody Preparation",
				Developer -> True
			},
			StandardCaptureAntibodyInitialConcentrations -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0Molar]|GreaterP[0Gram/Liter],
				Description -> "For each member of Standards, the initial concentration of the digoxigenin-labeled standard capture antibody before dilution.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation",
				Developer -> True
			},
			StandardCaptureAntibodyTargetConcentrations -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0Molar]|GreaterP[0Gram/Liter],
				Description -> "For each member of Standards, the desired concentration of the digoxigenin-labeled standard capture antibody after dilution.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyDiluents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the buffer solution used to mix with the concentrated digoxigenin-labeled standard capture antibody sample to achieve the desired StandardCaptureAntibodyTargetConcentrations for cartridge loading.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation"
			},
			StandardCaptureAntibodyDilutionContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of Standards, the container used to dilute the standard capture antibody samples for cartridge loading.",
				IndexMatching -> Standards,
				Category -> "Standard Capture Antibody Preparation",
				Developer -> True
			},

			StandardDetectionAntibodies -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the standard detection antibody sample used in the sandwich ELISA experiment to incubate with analytes through specific antigen-antibody interaction after their binding with standard capture antibody to provide detection attachment sites for streptavidin-conjugated fluorescent dye. The standard detection antibody samples are resuspended (if in solid state), bioconjugated with biotin and diluted before loaded into the Standardizable capillary ELISA cartridge.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},

			StandardDetectionAntibodyResuspensions -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of Standards, indicates if resuspension is required to be performed on the solid state StandardDetectionAntibodies sample to turn the sample into solution.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyResuspensionConcentrations -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0Molar]|GreaterP[0Gram/Liter],
				Description -> "For each member of Standards, the target concentration of the StandardDetectionAntibodies sample in the solution after resuspension.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyResuspensionDiluents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the resuspension buffer mixed with the solid state StandardDetectionAntibodies sample to dissolve the sample into solution.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyResuspensionDiluentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of diluent buffer required for resuspension of solid state StandardDetectionAntibodies sample into solution of desired concentration.",
				IndexMatching -> Standards,
				Developer -> True,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[SampleStorageTypeP,Disposal],
				Description -> "For each member of Standards, the condition under which the unused portion of resuspended StandardDetectionAntibodies sample inside its original container is stored after the protocol is completed.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},

			StandardDetectionAntibodyConjugations -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of Standards, indicates if bioconjugation reaction between Biotin-XX-SE (6-((6-((Biotinoyl)Amino)Hexanoyl)Amino)Hexanoic Acid, Succinimidyl Ester) and primary amines of the StandardDetectionAntibody is required to be performed to prepare biotinylated standard detection antibody sample for capillary ELISA experiment.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of the unconjugated standard detection antibody sample used to react with BiotinReagents to prepare biotinylated standard detection antibody sample through bioconjugation synthesis.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardBiotinReagents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the digoxigenin NHS-ester reagent used to react with the primary amines of the unconjugated StandardDetectionAntibodies sample to prepare biotinylated standard detection antibody sample through bioconjugation synthesis.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardBiotinReagentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of BiotinReagents used to react with StandardDetectionAntibodyVolumes of the unconjugated StandardDetectionAntibodies sample to prepare biotinylated standard detection antibody sample through bioconjugation synthesis.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyConjugationBuffers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the buffer solution in which the reaction between the unconjugated StandardDetectionAntibodies sample and BiotinReagents happens to prepare biotinylated standard detection antibody sample through bioconjugation synthesis.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyConjugationBufferVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of StandardDetectionAntibodyConjugationBuffers used to mix with the unconjugated StandardDetectionAntibodies and BiotinReagents to provide a buffered environment for the bioconjugation reaction.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyConjugationContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container], Object[Container]}],
				Relation -> Model[Container] | Object[Container],
				Description -> "For each member of Standards, the container in which the unconjugated StandardDetectionAntibodies sample, BiotinReagents and StandardDetectionAntibodyConjugationBuffers react to allow bioconjugation synthesis.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyConjugationTimes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Minute],
				Units -> Minute,
				Description -> "For each member of Standards, the amount of reaction time that the StandardDetectionAntibodies and BiotinReagents are allowed to react before purification happens.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyConjugationTemperatures -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Kelvin],
				Units -> Celsius,
				Description -> "For each member of Standards, the temperature at which the reaction between the unconjugated StandardDetectionAntibodies and BiotinReagents is conducted.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyPurificationColumns -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel,Filter], Object[Container,Vessel,Filter]}],
				Relation -> Model[Container,Vessel,Filter] | Object[Container,Vessel,Filter],
				Description -> "For each member of Standards, the desalting spin column used to adsorb the molecules that are smaller than its molecular weight cut-off (MWCO) on its resin bed to remove the free biotinylation reagent molecules in order to purify the synthesis product of the standard detection antibody bioconjugation reaction.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyColumnWashBuffers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the buffer solution loaded into the StandardDetectionAntibodyPurificationColumns after its storage buffer is removed and before the sample is loaded.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyColumnWashContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of Standards, the collection container used with StandardDetectionAntibodyPurificationColumns to collect the storage buffer or wash buffer before the conjugation reaction product is loaded for purification.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation",
				Developer -> True
			},
			StandardDetectionAntibodyColumnWasteContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of Standards, the collection container to collect the storage buffer or wash buffer during the purification process for disposal.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation",
				Developer -> True
			},
			StandardDetectionAntibodyConjugationCollectionVials -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of Standards, the collection container used with StandardDetectionAntibodyPurificationColumns to collect the final purified antibody sample for storage.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation",
				Developer -> True
			},
			StandardDetectionAntibodyConjugationStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[SampleStorageTypeP, Disposal],
				Description -> "For each member of Standards, indicates the condition under which the unused portion of the synthesized and purified biotinylated standard detection antibody sample is stored after the protocol is completed.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},

			StandardDetectionAntibodyDilutions -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of Standards, indicates if dilution is required to be performed on the biotinylated standard detection antibody sample with the specified StandardDetectionAntibodyDiluents to make a sample with desired concentration to be loaded into the Standardizable cartridge for ELISA experiment of the input sample.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyAbsorbanceBlanks -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the blank sample whose absorbance is subtracted as background from the absorbance readings of the initial antibody sample to determine its accurate concentration for dilution.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation",
				Developer -> True
			},
			StandardDetectionAntibodyAbsorbanceIntensities -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> UnitsP[AbsorbanceUnit],
				Units -> AbsorbanceUnit,
				Description -> "The absorbance intensity of the initial standard detection antibody sample measured at 280 nm, with the blank absorbance subtracted, used to determine the initial concentration of the standard detection antibody sample before dilution.",
				Category -> "Standard Detection Antibody Preparation",
				Developer -> True
			},
			StandardDetectionAntibodyInitialConcentrations -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0Molar]|GreaterP[0Gram/Liter],
				Description -> "For each member of Standards, the initial concentration of the digoxigenin-labeled standard detection antibody before dilution.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation",
				Developer -> True
			},
			StandardDetectionAntibodyTargetConcentrations -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0Molar]|GreaterP[0Gram/Liter],
				Description -> "For each member of Standards, the desired concentration of the biotinylated standard detection antibody after dilution.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyDiluents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "For each member of Standards, the buffer solution used to mix with the concentrated biotinylated standard detection antibody sample to achieve the desired StandardDetectionAntibodyTargetConcentrations for cartridge loading.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation"
			},
			StandardDetectionAntibodyDilutionContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container,Vessel], Object[Container,Vessel]}],
				Relation -> Model[Container,Vessel] | Object[Container,Vessel],
				Description -> "For each member of Standards, the container used to dilute the standard detection antibody samples for cartridge loading.",
				IndexMatching -> Standards,
				Category -> "Standard Detection Antibody Preparation",
				Developer -> True
			},

			WashBuffer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "The buffer that is loaded in the capillary ELISA cartridge to automatically flow through the capillaries to remove excess reagents between the antibody binding steps of analyte(s) with capture antibody and detection antibody.",
				Category -> "Washing"
			},

			PlaceHolderDiluent -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				Relation -> Model[Sample] | Object[Sample],
				Description -> "The buffer that is used in place of the samples, capture antibodies or detection antibodies to fill up all the empty wells in the capillary ELISA cartridge plate.",
				Category -> "Cartridge Loading",
				Developer -> True
			},
			LoadingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the amount of each diluted sample (with SpikeSample mixed) that is loaded into the capillary ELISA cartridge plate.",
				IndexMatching -> SamplesIn,
				Category -> "Cartridge Loading"
			},
			StandardLoadingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of each diluted standard sample loaded into the capillary ELISA cartridge for capillary ELISA experiment.",
				IndexMatching -> Standards,
				Category -> "Cartridge Loading"
			},
			CaptureAntibodyLoadingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of the capture antibody sample that is loaded with the dilutions of this input sample into the capillary ELISA cartridge for ELISA assay.",
				IndexMatching -> SamplesIn,
				Category -> "Cartridge Loading"
			},
			DetectionAntibodyLoadingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of the detection antibody sample that is loaded with the dilutions of this input sample into the capillary ELISA cartridge for ELISA assay.",
				IndexMatching -> SamplesIn,
				Category -> "Cartridge Loading"
			},
			StandardCaptureAntibodyLoadingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of the capture antibody sample that is loaded with the dilutions of this input sample into the capillary ELISA cartridge for ELISA assay.",
				IndexMatching -> Standards,
				Category -> "Cartridge Loading"
			},
			StandardDetectionAntibodyLoadingVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of Standards, the volume of the detection antibody sample that is loaded with the dilutions of this input sample into the capillary ELISA cartridge for ELISA assay.",
				IndexMatching -> Standards,
				Category -> "Cartridge Loading"
			},

			CaptureAntibodyAbsorbanceMeasurementContainer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container], Object[Container]}],
				Relation -> Model[Container] | Object[Container],
				Description -> "The container(s) in which the absorbance values of 280 nm of the capture antibody samples and standard capture antibody samples are measured to determine their initial concentrations for dilution.",
				Category -> "Antibody Preparation",
				Developer -> True
			},
			DetectionAntibodyAbsorbanceMeasurementContainer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container], Object[Container]}],
				Relation -> Model[Container] | Object[Container],
				Description -> "The container(s) in which the absorbance values of 280 nm of the detection antibody samples and detection capture antibody samples are measured to determine their initial concentrations for dilution.",
				Category -> "Antibody Preparation",
				Developer -> True
			},
			AntibodyAbsorbanceMeasurementProtocol -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[Object[Protocol, AbsorbanceIntensity]],
				Relation -> Object[Protocol, AbsorbanceIntensity],
				Description -> "The absorbance intensity measurement protocol used to determine the antibodies' initial concentrations for dilution.",
				Category -> "Antibody Preparation",
				Developer -> True
			},

			SamplePreparationPrimitives -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleManipulationP,
				Description -> "A set of instructions specifying the preparation of antibody samples and standard samples for capillary ELISA experiments, including the resuspension and conjugation of the antibody samples and the resuspension of the standard samples.",
				Category -> "Sample Preparation"
			},
			SamplePreparationProtocol -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[Object[Protocol, SampleManipulation]],
				Relation -> Object[Protocol, SampleManipulation],
				Description -> "The sample manipulation protocol used to prepare antibody samples and standard samples for capillary ELISA experiments.",
				Category -> "Sample Preparation"
			},

			SampleManipulationPrimitives -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleManipulationP,
				Description -> "A set of instructions specifying the spiking of input samples, dilution of the input samples and standard samples, dilution of antibody samples for customizable cartridge and loading of all reagents into the capillary ELISA cartridge for ELISA experiment.",
				Category -> "Sample Preparation"
			},
			SampleManipulationProtocol -> {
				Format -> Single,
				Class -> Link,
				Pattern :> ObjectP[Object[Protocol, SampleManipulation]],
				Relation -> Object[Protocol, SampleManipulation],
				Description -> "The sample manipulation protocol used to spike input samples, dilute samples and load samples into the capillary ELISA cartridge for ELISA experiment.",
				Category -> "Sample Preparation"
			},

			SpikeSampleStorageConditions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[SampleStorageTypeP,Disposal],
				Description->"For each member of SamplesIn, the storage conditions under which the unused portion of the SpikeSample should be stored after their usage in the experiment.",
				IndexMatching->SamplesIn,
				Category->"Sample Storage"
			},
			StandardCompositions -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0Picogram / Milliliter]|GreaterEqualP[0Molar],ObjectP[Model[Molecule]]}..},
				Relation -> {Null,Model[Molecule]},
				Description -> "For each member of Standards, the known concentration(s) of the analyte(s) in each standard sample before dilution.",
				IndexMatching -> Standards,
				Category -> "Data Processing"
			},
			SpikeConcentrations -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0Picogram / Milliliter]|GreaterEqualP[0Molar],ObjectP[Model[Molecule]]}..},
				Relation -> {Null,Model[Molecule]},
				Description -> "For each member of SamplesIn, the known concentration(s) of analyte(s) in the spike standard sample mixed with the input sample before any dilution.",
				IndexMatching -> SamplesIn,
				Category -> "Data Processing"
			},
            StandardData -> {
                Format -> Multiple,
                Class -> Link,
                Pattern :> ObjectP[Object[Data]],
                Relation -> Object[Data][Protocol],
                Description -> "For each member of Standards, the ELISA data generated by this capillary ELISA protocol.",
                IndexMatching -> Standards,
                Category -> "Experimental Results"
            },
            StandardCurveFunctions -> {
                Format -> Multiple,
                Class -> {String,Expression},
                Pattern :> {_String,_QuantityFunction},
                Description -> "The standard curve functions of the pre-loaded analytes in this ELISA experiment, provided by the assay developer. The function takes Concentration in Picogram/Milliliter as input and generates FluorescenceSignal in RFU as output. This standard curve is used to calculate the concentration(s) of this analyte in unknown sample(s) from the measured fluorescence signal(s).",
				Headers -> {"Analyte","Standard Curve Function"},
                Category -> "Experimental Results"
            },

            MethodFile -> {
                Format -> Single,
                Class -> Link,
                Pattern :> _Link,
                Relation -> Object[EmeraldCloudFile],
                Description -> "The CYDAT file containing the run information and the run results generated by the capillary ELISA instrument.",
                Category -> "Experimental Results"
            },
            DataFile -> {
                Format -> Single,
                Class -> Link,
                Pattern :> _Link,
                Relation -> Object[EmeraldCloudFile],
                Description -> "The CSV file containing the experiment data (concentration, %CV) generated by the capillary ELISA instrument.",
                Category -> "Experimental Results"
            }
        }
    }
];