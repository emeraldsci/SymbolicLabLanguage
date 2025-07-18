(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)

(*ExperimentExtractTotalProtein Options*)


DefineOptions[ExperimentExtractProtein,
  Options:> {
    IndexMatching[
      IndexMatchingInput->"experiment samples",

      (*--- GENERAL ---*)

      {
        OptionName -> TargetProtein,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Specific Protein"->Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[Molecule,Protein]]
          ],
          "Total Protein"->Widget[
            Type -> Enumeration,
            Pattern:>Alternatives[All]
            ]
          ],
        Description -> "The target protein that is isolated from SamplesIn during protein extraction. If isolating a specific target protein that is antigen, antibody, or his-tagged, subsequent isolation can happen via affinity column or affinity-based magnetic beads during purification. If isolating all proteins, purification can happen via liquid liquid extraction, solid phase extraction, magnetic bead separation, or precipitation.",
        ResolutionDescription -> "Automatically set to the TargetProtein specified by the selected Method. Otherwise, TargetProtein is automatically set to All.",
        Category -> "General"
      },

      ModifyOptions[CellExtractionSharedOptions,
        {(*TODO:: add a couple of default methods*)
          OptionName ->Method,
          Default -> Automatic,
          ResolutionDescription -> "Automatically set to the first method in the search result of Object[Method,Extraction,Protein] that matches the TargetProtein and Lyse (and CellType if Lyse is True). If no method is found, Method is automatically set to Custom."
        }
      ],
      ModifyOptions[CellExtractionSharedOptions,
        ContainerOut
      ],
      ModifyOptions[CellExtractionSharedOptions,
        ContainerOutWell
      ],
      ModifyOptions[CellExtractionSharedOptions,
        IndexedContainerOut
      ],

      {
        OptionName -> ExtractedProteinLabel,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description -> "A user defined word or phrase used to identify the protein extract sample resulting from the cell lysis and protein purification for downstream use or analysis.",
        ResolutionDescription -> "Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise set to \"extracted protein sample #\".",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> ExtractedProteinContainerLabel,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description -> "A user defined word or phrase used to identify the container of the protein extract sample resulting from the cell lysis and protein purification for downstream use or analysis.",
        ResolutionDescription->"Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"extracted protein sample container #\".",
        Category -> "General",
        UnitOperation -> True
      },

      (*--- LYSIS ---*)

      {
        OptionName -> Lyse,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        Description -> "Indicates if cell lysis is to be performed to chemically break the cell membranes (and cell wall depending on the CellType) and release the cell components including proteins. Lysis in ExtractProtein is intended to break all subcellular compartments. If subcellular fractionation is desired, please see ExtractSubcellularProtein.",
        ResolutionDescription -> "If the input sample has the CellType field specified and Living->True, then Lyse is automatically set to True. Otherwise, Lyse is automatically set to False.",
        Category -> "Lysis"
      },

      ModifyOptions[CellLysisOptions,
        CellType
      ],
      ModifyOptions[CellLysisOptions,
        CultureAdhesion
      ],
      ModifyOptions[CellLysisOptions,
        Dissociate
      ],
      ModifyOptions[CellLysisOptions,
        NumberOfLysisSteps
      ],
      ModifyOptions[CellLysisOptions,
        TargetCellCount
      ],
      ModifyOptions[CellLysisOptions,
        TargetCellConcentration
      ],
      ModifyOptions[CellLysisOptions,
        LysisAliquot
      ],
      ModifyOptions[CellLysisOptions,
        LysisAliquotAmount
      ],
      ModifyOptions[CellLysisOptions,
        LysisAliquotContainer
      ],
      ModifyOptions[CellLysisOptions,
        LysisAliquotContainerLabel
      ],
      ModifyOptions[CellLysisOptions,
        PreLysisPellet
      ],
      ModifyOptions[CellLysisOptions,
        PreLysisPelletingCentrifuge
      ],
      ModifyOptions[CellLysisOptions,
        PreLysisPelletingIntensity
      ],
      ModifyOptions[CellLysisOptions,
        PreLysisPelletingTime
      ],
      ModifyOptions[CellLysisOptions,
        PreLysisSupernatantVolume
      ],
      ModifyOptions[CellLysisOptions,
        PreLysisSupernatantStorageCondition
      ],
      ModifyOptions[CellLysisOptions,
        PreLysisSupernatantContainer
      ],
      ModifyOptions[CellLysisOptions,
        PreLysisSupernatantLabel
      ],
      ModifyOptions[CellLysisOptions,
        PreLysisSupernatantContainerLabel
      ],
      ModifyOptions[CellLysisOptions,
        PreLysisDilute
      ],
      ModifyOptions[CellLysisOptions,
        PreLysisDiluent
      ],
      ModifyOptions[CellLysisOptions,
        PreLysisDilutionVolume
      ],
      ModifyOptions[CellLysisOptions,
        LysisSolution,
        {
          Description -> "The solution, containing enzymes, detergents, and chaotropics etc., used for disruption of cell membranes (and cell wall depending on the CellType) to release the cell components, including proteins. The lysis step is performed to disrupt plasma, nuclear and organelle membrane and solublize membrane-bound proteins.",
          ResolutionDescription -> "Automatically set to the LysisSolution specified by the selected Method. If Method is set to Custom, automatically set to Model[Sample, \"B-PER Bacterial Protein Extraction Reagent\"] if CellType is set to Bacterial, Model[Sample, \"Y-PER Yeast Protein Extraction Reagent\"] if CellType is set to Yeast, or Model[Sample, \"Invitrogen Cell Lysis Buffer\"] if CellType is set to Mammalian."
        }
      ],
      ModifyOptions[CellLysisOptions,
        LysisSolutionVolume
      ],
      {
        OptionName -> LysisSolutionTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the LysisSolution is incubated during the LysisSolutionEquilibrationTime before addition to the cell sample.",
        ResolutionDescription -> "Automatically set to the LysisSolutionTemperature as specified by the selected Method. If Method->Custom, LysisSolutionTemperature is automatically set to 4 Celsius.",
        Category -> "Lysis"
      },
      {
        OptionName -> LysisSolutionEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> Alternatives[Second, Minute, Hour]],
        Description -> "The minimum duration during which the LysisSolution is incubated at LysisSolutionTemperature before addition to the cell sample.",
        ResolutionDescription -> "Automatically set to the LysisSolutionEquilibrationTime as specified by the selected Method. If Method->Custom, LysisSolutionEquilibrationTime is automatically set to 10 Minute.",
        Category -> "Lysis"
      },
      ModifyOptions[CellLysisOptions,
        LysisMixType
      ],
      ModifyOptions[CellLysisOptions,
        LysisMixRate
      ],
      ModifyOptions[CellLysisOptions,
        LysisMixTime
      ],
      ModifyOptions[CellLysisOptions,
        NumberOfLysisMixes
      ],
      ModifyOptions[CellLysisOptions,
        LysisMixVolume
      ],
      ModifyOptions[CellLysisOptions,
        LysisMixTemperature
      ],
      ModifyOptions[CellLysisOptions,
        LysisMixInstrument
      ],
      ModifyOptions[CellLysisOptions,
        LysisTime
      ],
      ModifyOptions[CellLysisOptions,
        LysisTemperature
      ],
      ModifyOptions[CellLysisOptions,
        LysisIncubationInstrument
      ],
      ModifyOptions[CellLysisOptions,
        SecondaryLysisSolution
      ],
      ModifyOptions[CellLysisOptions,
        SecondaryLysisSolutionVolume
      ],
      {
        OptionName -> SecondaryLysisSolutionTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the SecondaryLysisSolution is incubated during the SecondaryLysisSolutionEquilibrationTime before addition to the sample after the sample during the optional secondary lysis.",
        ResolutionDescription -> "Automatically set to the SecondaryLysisSolutionTemperature as specified by the selected Method. If Method->Custom, SecondaryLysisSolutionTemperature is automatically set to 4 Celsius if NumberOfLysisSteps is larger or equal to 2.",
        Category -> "Lysis"
      },
      {
        OptionName -> SecondaryLysisSolutionEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> Alternatives[Second, Minute, Hour]],
        Description -> "The minimum duration during which the SecondaryLysisSolution is incubated at SecondaryLysisSolutionTemperature before addition to the sample during the optional secondary lysis.",
        ResolutionDescription -> "Automatically set to the SecondaryLysisSolutionEquilibrationTime as specified by the selected Method. If Method->Custom, SecondaryLysisSolutionEquilibrationTime is automatically set to 10 Minute if NumberOfLysisSteps is larger or equal to 2.",
        Category -> "Lysis"
      },
      ModifyOptions[CellLysisOptions,
        SecondaryLysisMixType
      ],
      ModifyOptions[CellLysisOptions,
        SecondaryLysisMixRate
      ],
      ModifyOptions[CellLysisOptions,
        SecondaryLysisMixTime
      ],
      ModifyOptions[CellLysisOptions,
        SecondaryNumberOfLysisMixes
      ],
      ModifyOptions[CellLysisOptions,
        SecondaryLysisMixVolume
      ],
      ModifyOptions[CellLysisOptions,
        SecondaryLysisMixTemperature
      ],
      ModifyOptions[CellLysisOptions,
        SecondaryLysisMixInstrument
      ],
      ModifyOptions[CellLysisOptions,
        SecondaryLysisTime
      ],
      ModifyOptions[CellLysisOptions,
        SecondaryLysisTemperature
      ],
      ModifyOptions[CellLysisOptions,
        SecondaryLysisIncubationInstrument
      ],
      ModifyOptions[CellLysisOptions,
        TertiaryLysisSolution
      ],
      ModifyOptions[CellLysisOptions,
        TertiaryLysisSolutionVolume
      ],
      {
        OptionName -> TertiaryLysisSolutionTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the TertiaryLysisSolution is incubated during the TertiaryLysisSolutionEquilibrationTime before addition to the sample after the sample during the optional tertiary lysis.",
        ResolutionDescription -> "Automatically set to the TertiaryLysisSolutionTemperature as specified by the selected Method. If Method->Custom, TertiaryLysisSolutionTemperature is automatically set to 4 Celsius if NumberOfLysisSteps is 3.",
        Category -> "Lysis"
      },
      {
        OptionName -> TertiaryLysisSolutionEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> Alternatives[Second, Minute, Hour]],
        Description -> "The minimum duration during which the TertiaryLysisSolution is incubated at TertiaryLysisSolutionTemperature before addition to the sample during the optional tertiary lysis.",
        ResolutionDescription -> "Automatically set to the TertiaryLysisSolutionEquilibrationTime as specified by the selected Method. If Method->Custom, TertiaryLysisSolutionEquilibrationTime is automatically set to 10 Minute if NumberOfLysisSteps is 3.",
        Category -> "Lysis"
      },
      ModifyOptions[CellLysisOptions,
        TertiaryLysisMixType
      ],
      ModifyOptions[CellLysisOptions,
        TertiaryLysisMixRate
      ],
      ModifyOptions[CellLysisOptions,
        TertiaryLysisMixTime
      ],
      ModifyOptions[CellLysisOptions,
        TertiaryNumberOfLysisMixes
      ],
      ModifyOptions[CellLysisOptions,
        TertiaryLysisMixVolume
      ],
      ModifyOptions[CellLysisOptions,
        TertiaryLysisMixTemperature
      ],
      ModifyOptions[CellLysisOptions,
        TertiaryLysisMixInstrument
      ],
      ModifyOptions[CellLysisOptions,
        TertiaryLysisTime
      ],
      ModifyOptions[CellLysisOptions,
        TertiaryLysisTemperature
      ],
      ModifyOptions[CellLysisOptions,
        TertiaryLysisIncubationInstrument
      ],
      ModifyOptions[CellLysisOptions,
        ClarifyLysate
      ],
      ModifyOptions[CellLysisOptions,
        ClarifyLysateCentrifuge
      ],
      ModifyOptions[CellLysisOptions,
        ClarifyLysateIntensity
      ],
      ModifyOptions[CellLysisOptions,
        ClarifyLysateTime
      ],
      ModifyOptions[CellLysisOptions,
        ClarifiedLysateVolume
      ],
      ModifyOptions[CellLysisOptions,
        PostClarificationPelletLabel
      ],
      ModifyOptions[CellLysisOptions,
        PostClarificationPelletStorageCondition
      ],
      ModifyOptions[CellLysisOptions,
        ClarifiedLysateContainer
      ],
      ModifyOptions[CellLysisOptions,
        ClarifiedLysateContainerLabel
      ],

      (*--- PURIFICATION ---*)
      ModifyOptions[PurificationStepsSharedOptions,
        Purification,
        {
          OptionName->Purification,
          ResolutionDescription->"Automatically set to the Purification steps specified by the selected Method. If Method is set to Custom, Purification is set based on any already set options pertaining to a specific rudimentary purification type. For example, if AqueousSolvent is specified, a LiquidLiquidExtraction step is added to Purification. Purification steps added this way are only added once and they are added in the following order: LiquidLiquidExtraction, Precipitation, SolidPhaseExtraction, then MagneticBeadSeparation. Otherwise, if TargetProtein is All, Purification is set to a Precipitation; if TargetProtein is a Model[Molecule], Purification is set to a SolidPhaseExtraction."
        }
      ],
      
      ExtractionLiquidLiquidSharedOptions,

      (*-- Precipitation options with customization -- *)
      Sequence@@ModifyOptions[ExtractionPrecipitationSharedOptions,
        ToExpression[Keys[
          KeyDrop[
            Options[ExtractionPrecipitationSharedOptions],
            { Key["PrecipitationFilter"], Key["PrecipitationReagent"], Key["PrecipitationWashSolution"], Key["PrecipitationResuspensionBuffer"]}]
        ]]
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationFilter,
        {
          ResolutionDescription->"Automatically set to the PrecipitationFilter specified by the selected Method. If Method is set to Custom and PrecipitationSeparationTechnique is set to Filter then PrecipitationFilter is automatically set to Model[Container, Plate, Filter, \"Plate Filter, Omega 30K MWCO, 1000uL\"] given that PrecipitationMembraneMaterial and PrecipitationPoreSize are not set to contradict {PES, Null}. Otherwise, PrecipitationFilter is set to a filter that fits on the filtration instrument (either the centrifuge or pressure manifold) and matches PrecipitationMembraneMaterial and PrecipitationPoreSize if they are set. If the sample is already in a filter then PrecipitationFilter is automatically set to that filter and the sample will not be transferred to a new filter unless this option is explicitly changed to a new filter."
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationReagent,
        {
          ResolutionDescription->"Automatically set to the PrecipitationReagent specified by the selected Method. If Method is set to Custom and PrecipitationTargetPhase is set to Solid, then PrecipitationReagent is automatically set to Model[Sample, StockSolution, \"TCA (10%, w/v) in acetone with 2-mercaptoethanol (0.07%)\"]. Otherwise PrecipitationReagent is set to Model[Sample,StockSolution, \"5M Sodium Chloride\"]."
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationWashSolution,
        {
          ResolutionDescription->"Automatically set to the PrecipitationWashSolution specified by the selected Method. If Method is set to Custom and PrecipitationNumberOfWashes is greater than 0, then PrecipitationWashSolution is automatically set to Model[Sample, StockSolution, \"Acetone, Reagent Grade\"]."
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationResuspensionBuffer,
        {
          ResolutionDescription->"Automatically set to the PrecipitationResuspensionBuffer specified by the selected Method. If Method is set to Custom and PrecipitationTargetPhase is set to Solid, then PrecipitationResuspensionBuffer is automatically set to Model[Sample, StockSolution, \"RIPA Lysis Buffer with protease inhibitor cocktail\"]."
        }
      ],
      
      (*-- MBS options with customization -- *)
      Sequence@@ModifyOptions[ExtractionMagneticBeadSharedOptions,
        ToExpression[Keys[
          KeyDrop[
            Options[ExtractionMagneticBeadSharedOptions],
            {Key["MagneticBeads"], Key["MagneticBeadSeparationWashSolution"], Key["MagneticBeadSeparationSecondaryWashSolution"], Key["MagneticBeadSeparationTertiaryWashSolution"], Key["MagneticBeadSeparationQuaternaryWashSolution"], Key["MagneticBeadSeparationQuinaryWashSolution"], Key["MagneticBeadSeparationSenaryWashSolution"], Key["MagneticBeadSeparationSeptenaryWashSolution"], Key["MagneticBeadSeparationElutionSolution"]}]
        ]]
      ],

      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeads,
        {
          ResolutionDescription->"Automatically set to the MagneticBeads specified by the selected Method. If Method is set to Custom, MagneticBeads is automatically set to Model[Sample, \"MagSi-proteomics C4 sample\"] if MagneticBeadSeparationMode is set to ReversePhase, set to Model[Sample, \"MagSi-WCX sample\"] if MagneticBeadSeparationMode is set to IonExchange. If MagneticBeadSeparationMode is Affinity, MagneticBeads is automatically set to the first found magnetic beads model with the affinity label of MagneticBeadAffinityLabel. Otherwise, MagneticBeads is automatically set to Model[Sample, \"Mag-Bind Particles CNR (Mag-Bind Viral DNA/RNA Kit)\"] with a warning that we may not have a reccomended default."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationWashSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationWashSolution is automatically set to Model[Sample,\"Filtered PBS, Sterile\"] if MagneticBeadSeparationWash is set to True."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationSecondaryWashSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationSecondaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSecondaryWashSolution is automatically set to Model[Sample,\"Filtered PBS, Sterile\"] if MagneticBeadSeparationSecondaryWash is set to True."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationTertiaryWashSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationTertiaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationTertiaryWashSolution is automatically set to Model[Sample,\"Filtered PBS, Sterile\"] if MagneticBeadSeparationTertiaryWash is set to True."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationQuaternaryWashSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuaternaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationQuaternaryWashSolution is automatically set to Model[Sample,\"Filtered PBS, Sterile\"] if MagneticBeadSeparationQuaternaryWash is set to True."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationQuinaryWashSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuinaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationQuinaryWashSolution is automatically set to Model[Sample,\"Filtered PBS, Sterile\"] if MagneticBeadSeparationQuinaryWash is set to True."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationSenaryWashSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationSenaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSenaryWashSolution is automatically set to Model[Sample,\"Filtered PBS, Sterile\"] if MagneticBeadSeparationSenaryWash is set to True."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationSeptenaryWashSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationSeptenaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSeptenaryWashSolution is automatically set to Model[Sample,\"Filtered PBS, Sterile\"] if MagneticBeadSeparationSeptenaryWash is set to True."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationElutionSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationElutionSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationElutionSolution is automatically set to Model[Sample, \"50 mM Glycine pH 2.8, sterile filtered\"] if MagneticBeadSeparationElution is set to True."
        }
      ],

      (*--SPE Options with customization--*)
      Sequence@@ModifyOptions[ExtractionSolidPhaseSharedOptions,
        ToExpression[Keys[
          KeyDrop[
            Options[ExtractionSolidPhaseSharedOptions],
            {Key["SolidPhaseExtractionSeparationMode"], Key["SolidPhaseExtractionSorbent"], Key["SolidPhaseExtractionCartridge"], Key["SolidPhaseExtractionWashSolution"], Key["SecondarySolidPhaseExtractionWashSolution"], Key["TertiarySolidPhaseExtractionWashSolution"], Key["SolidPhaseExtractionElutionSolution"]}]
        ]]
      ],

      ModifyOptions[ExtractionSolidPhaseSharedOptions,
        SolidPhaseExtractionSeparationMode,
        {
          ResolutionDescription -> "Automatically set to match the SolidPhaseExtractionMode specified by the selected Method. If Method is set to Custom, automatically set to the SolidPhaseExtractionMode defined by the selected SolidPhaseExtractionSorbent (either directly by setting the SolidPhaseExtractionSorbent or indirectly by specifying a SolidPhaseExtractionCartridge). If no Method, SolidPhaseExtractionSorbent, nor SolidPhaseExtractionCartridge is selected, SolidPhaseExtractionMode is automatically set to SizeExclusion if TargetProtein is All, to Affinity if TargetProtein is a Model[Molecule]."
        }
      ],
      ModifyOptions[ExtractionSolidPhaseSharedOptions,
        SolidPhaseExtractionSorbent,
        {
          ResolutionDescription -> "Automatically set to the SolidPhaseExtractionSorbent specified by the selected Method. If Method is set to Custom and a SolidPhaseExtractionCartridge is specified, automatically set to match the SolidPhaseExtractionSorbent defined by the selected SolidPhaseExtractionCartridge. If Method is set to Custom and no SolidPhaseExtractionCartridge is specified, SolidPhaseExtractionSorbent is automatically set to Affinity if TargetProtein is a Model[Molecule] and CellType is microbial, to ProteinG if TargetProtein is a Model[Molecule] and CellType is mammalian, and to Null if TargetProtein is All, matching the default SolidPhaseExtractionCartridge."
        }
      ],

      ModifyOptions[ExtractionSolidPhaseSharedOptions,
        SolidPhaseExtractionCartridge,
        {
          ResolutionDescription -> "Automatically set to the SolidPhaseExtractionCartridge specified by the selected Method. If Method is set to Custom, then SolidPhaseExtractionCartridge is automatically set based on SolidPhaseExtractionSeparationMode and SolidPhaseExtractionSorbent. If the combination of separation mode and sorbent is Affinity and ProteinG, SolidPhaseExtractionCartridge is set to Model[Container, Plate, Filter, \"Pierce ProteinG Spin Plate for IgG Screening\"]. If the combination of separation mode and sorbent is Affinity and Affinity, SolidPhaseExtractionCartridge is set to Model[Container, Plate, Filter, \"HisPur Ni-NTA Spin Plates\"]. If the combination of separation mode and sorbent is SizeExclusion and Null or SizeExclusion, SolidPhaseExtractionCartridge is set to Model[Container, Plate, Filter, \"Zeba 7K 96-well Desalt Spin Plate\"]."
        }
      ],
      ModifyOptions[ExtractionSolidPhaseSharedOptions,
        SolidPhaseExtractionWashSolution,
        {
          ResolutionDescription -> "Automatically set to the wash solution specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionWashSolution is automatically set to Model[Sample, \"Filtered PBS, Sterile\"] if SolidPhaseExtractionSelectionStrategy is set to Positive."
        }
      ],
      ModifyOptions[ExtractionSolidPhaseSharedOptions,
        SecondarySolidPhaseExtractionWashSolution,
        {
          ResolutionDescription -> "Automatically set to the secondary wash solution specified by the selected Method. If Method is set to Custom, SecondarySolidPhaseExtractionWashSolution is automatically set to match SolidPhaseExtractionWashSolution."
        }
      ],
      ModifyOptions[ExtractionSolidPhaseSharedOptions,
        TertiarySolidPhaseExtractionWashSolution,
        {
          ResolutionDescription -> "Automatically set to the tertiary wash solution specified by the selected Method. If Method is set to Custom, TertiarySolidPhaseExtractionWashSolution is automatically set to match SecondarySolidPhaseExtractionWashSolution."
        }
      ],
      ModifyOptions[ExtractionSolidPhaseSharedOptions,
        SolidPhaseExtractionElutionSolution,
        {
          ResolutionDescription -> "Automatically set to the wash solution specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionElutionSolution is automatically set to Model[Sample, \"50 mM Glycine pH 2.8, sterile filtered\"] if SolidPhaseExtractionSelectionStrategy is set to Positive."
        }
      ]
    ],

    (* OTHER SHARED OPTIONS *)
    ModifyOptions[
      RoboticInstrumentOption,
      {
        ResolutionDescription -> "Automatically set to the robotic liquid handler compatible with the cells or solutions having their protein extracted. If all cell types, specified by CellType or informed by the CellType of the input samples, are microbial (Bacterial and Yeast), RoboticInstrument is automatically set to the microbioSTAR. If all cell types are non-microbial (Mammalian), RoboticInstrument is automatically set to the bioSTAR. Otherwise the cell types are mixed or unspecified, RoboticInstrument is automatically set to the microbioSTAR. "
      }
    ],
    ModifyOptions[NonIndexMatchedExtractionMagneticBeadSharedOptions,
      MagneticBeadSeparationSelectionStrategy],

    ModifyOptions[NonIndexMatchedExtractionMagneticBeadSharedOptions,
      MagneticBeadSeparationMode,
      {
        ResolutionDescription->"Automatically set to the MagneticBeadSeparationMode specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationMode is automatically set to Affinity if TargetProtein is a Model[Molecule], and is set to IonExchange if TargetProtein is All."
      }
    ],
    RoboticPreparationOption,
    ProtocolOptions,
    SimulationOption,
    BiologyPostProcessingOptions,
    SubprotocolDescriptionOption,
    SamplesInStorageOptions,
    SamplesOutStorageOptions,
    ModifyOptions[
      WorkCellOption,
      {
        Widget -> Widget[Type -> Enumeration,Pattern :> bioSTAR | microbioSTAR],
        ResolutionDescription -> "Automatically set to the primitive compatible with the cells or solutions having their protein extracted. If all cell types, specified by CellType or informed by the CellType of the input samples, are microbial (Bacterial or Yeast), RoboticInstrument is automatically set to the microbioSTAR. If all cell types are non-microbial (Mammalian), RoboticInstrument is automatically set to the bioSTAR. Otherwise the cell types are mixed or unspecified, RoboticInstrument is automatically set to the microbioSTAR."
      }
    ]

  }
];
(* ::Subsubsection::Closed:: *)
(* shared messages *)
(*DuplicateName,MethodOptionConflict,ConflictingLysisOutputOptions,RoboticInstrumentInvalidCellType,RoboticInstrumentCellTypeMismatch,LysispOptionMismatch,RepeatedLysis,UnlysedCellsInput,LiquidLiquidExtractionOptionMismatch,PrecipitationOptionMismatch,SolidPhaseExtractionOptionMismatch,MagneticBeadSeparationOptionMismatch*)

Error::NoExtractProteinStepsSet = "The sample(s), `1`, at indices, `2`, do not have any extraction steps set (Lysis or Purification) to extract protein from the samples. Please specify options for one or more extraction steps for these samples.";
Warning::MethodTargetProteinMismatch = "The sample(s), `1`, at indices `2`, have a target protein, `3`, which is not listed as a target by the specified method, `4`.";
Error::ConflictingLysisStepSolutionEquilibration = "The sample(s), `1`, at indices `2`, have lysis solution temperature and equilibration time options in conflict with lyse or number of lysis steps, including options of `3` that have values of `4`.";
Error::LysisSolutionEquilibrationTimeTemperatureMismatch = "The sample(s), `1`, at indices `2`, have mismatched lysis solution temperature and equilibration time options of `3` that have values of `4`. For a lysis step, if the lysis solution temperature is set to Null, the lysis solution equilibration time could not be any time greater than 0 Second, please set it to Null or Automatic; if the lysis solution temperature is set to any temperature other than Null or Ambient, the lysis solution equilibration time could not be Null or zero, please set it to a valid time duration.";
Warning::TargetPurificationMismatch = "The sample(s), `1`, at indices `2`, have the target protein `3`, which would not be achievable with the purification of `4`. If TargetProtein is a Model[Molecule], at lease one Purification step of SolidPhaseExtraction with SolidPhaseExtractionSeparationMode->Affinity or a MagneticBeadSeparation step with MagneticBeadSeparationMode->Affinity. If TargetProtein is All, it is not recommended to have a SolidPhaseExtraction with SolidPhaseExtractionSeparationMode->Affinity or to have a MagneticBeadSeparation step with MagneticBeadSeparationMode->Affinity.";
Warning::NullTargetProtein = "The sample(s), `1`, at indices `2`, have target protein of Null, while Purification is set to Automatic, which is automatically set to None. If this is incorrect, please specify the Purification option to indicate which step(s) of purification is to be performed on the sample(s).";

(* ::Subsubsection::Closed:: *)
(*$ExtractProteinMethodFields*)

$ExtractProteinMethodFields = {AqueousSolvent, AqueousSolventRatio, CellType, ClarifyLysate, ClarifyLysateIntensity, ClarifyLysateTime, Demulsifier, DemulsifierAdditions, ElutionMagnetizationTime, EquilibrationMagnetizationTime, LiquidLiquidExtractionCentrifuge, LiquidLiquidExtractionCentrifugeIntensity, LiquidLiquidExtractionCentrifugeTime, LiquidLiquidExtractionDevice, LiquidLiquidExtractionMixRate, LiquidLiquidExtractionMixTime, LiquidLiquidExtractionMixType, LiquidLiquidExtractionSelectionStrategy, LiquidLiquidExtractionSettlingTime, LiquidLiquidExtractionSolventAdditions, LiquidLiquidExtractionTargetLayer, LiquidLiquidExtractionTargetPhase, LiquidLiquidExtractionTechnique, LiquidLiquidExtractionTemperature, LoadingMagnetizationTime, Lyse, LysisMixRate, LysisMixTemperature, LysisMixTime, LysisMixType, LysisSolution, LysisSolutionEquilibrationTime, LysisSolutionTemperature, LysisTemperature, LysisTime, MagneticBeadAffinityLabel, MagneticBeads, MagneticBeadSeparationAnalyteAffinityLabel,  MagneticBeadSeparationElution, MagneticBeadSeparationElutionMix,  MagneticBeadSeparationElutionMixRate,  MagneticBeadSeparationElutionMixTemperature,  MagneticBeadSeparationElutionMixTime,  MagneticBeadSeparationElutionMixType,  MagneticBeadSeparationElutionSolution,  MagneticBeadSeparationEquilibration,  MagneticBeadSeparationEquilibrationAirDry,  MagneticBeadSeparationEquilibrationAirDryTime,  MagneticBeadSeparationEquilibrationMix,  MagneticBeadSeparationEquilibrationMixRate,  MagneticBeadSeparationEquilibrationMixTemperature,  MagneticBeadSeparationEquilibrationMixTime,  MagneticBeadSeparationEquilibrationMixType,  MagneticBeadSeparationEquilibrationSolution,  MagneticBeadSeparationLoadingAirDry,  MagneticBeadSeparationLoadingAirDryTime,  MagneticBeadSeparationLoadingMix,  MagneticBeadSeparationLoadingMixRate,  MagneticBeadSeparationLoadingMixTemperature,  MagneticBeadSeparationLoadingMixTime,  MagneticBeadSeparationLoadingMixType, MagneticBeadSeparationMode,  MagneticBeadSeparationPreWash, MagneticBeadSeparationPreWashAirDry,  MagneticBeadSeparationPreWashAirDryTime,  MagneticBeadSeparationPreWashMix,  MagneticBeadSeparationPreWashMixRate,  MagneticBeadSeparationPreWashMixTemperature,  MagneticBeadSeparationPreWashMixTime,  MagneticBeadSeparationPreWashMixType,  MagneticBeadSeparationPreWashSolution,  MagneticBeadSeparationQuaternaryWash,  MagneticBeadSeparationQuaternaryWashAirDry,  MagneticBeadSeparationQuaternaryWashAirDryTime,  MagneticBeadSeparationQuaternaryWashMix,  MagneticBeadSeparationQuaternaryWashMixRate,  MagneticBeadSeparationQuaternaryWashMixTemperature,  MagneticBeadSeparationQuaternaryWashMixTime,  MagneticBeadSeparationQuaternaryWashMixType,  MagneticBeadSeparationQuaternaryWashSolution,  MagneticBeadSeparationQuinaryWash,  MagneticBeadSeparationQuinaryWashAirDry,  MagneticBeadSeparationQuinaryWashAirDryTime,  MagneticBeadSeparationQuinaryWashMix,  MagneticBeadSeparationQuinaryWashMixRate,  MagneticBeadSeparationQuinaryWashMixTemperature,  MagneticBeadSeparationQuinaryWashMixTime,  MagneticBeadSeparationQuinaryWashMixType,  MagneticBeadSeparationQuinaryWashSolution,  MagneticBeadSeparationSecondaryWash,  MagneticBeadSeparationSecondaryWashAirDry,  MagneticBeadSeparationSecondaryWashAirDryTime,  MagneticBeadSeparationSecondaryWashMix,  MagneticBeadSeparationSecondaryWashMixRate,  MagneticBeadSeparationSecondaryWashMixTemperature,  MagneticBeadSeparationSecondaryWashMixTime,  MagneticBeadSeparationSecondaryWashMixType,  MagneticBeadSeparationSecondaryWashSolution,  MagneticBeadSeparationSelectionStrategy,  MagneticBeadSeparationSenaryWash,  MagneticBeadSeparationSenaryWashAirDry,  MagneticBeadSeparationSenaryWashAirDryTime,  MagneticBeadSeparationSenaryWashMix,  MagneticBeadSeparationSenaryWashMixRate,  MagneticBeadSeparationSenaryWashMixTemperature,  MagneticBeadSeparationSenaryWashMixTime,  MagneticBeadSeparationSenaryWashMixType,  MagneticBeadSeparationSenaryWashSolution,  MagneticBeadSeparationSeptenaryWash,  MagneticBeadSeparationSeptenaryWashAirDry,  MagneticBeadSeparationSeptenaryWashAirDryTime,  MagneticBeadSeparationSeptenaryWashMix,  MagneticBeadSeparationSeptenaryWashMixRate,  MagneticBeadSeparationSeptenaryWashMixTemperature,  MagneticBeadSeparationSeptenaryWashMixTime,  MagneticBeadSeparationSeptenaryWashMixType,  MagneticBeadSeparationSeptenaryWashSolution,  MagneticBeadSeparationTertiaryWash,  MagneticBeadSeparationTertiaryWashAirDry,  MagneticBeadSeparationTertiaryWashAirDryTime,  MagneticBeadSeparationTertiaryWashMix,  MagneticBeadSeparationTertiaryWashMixRate,  MagneticBeadSeparationTertiaryWashMixTemperature,  MagneticBeadSeparationTertiaryWashMixTime,  MagneticBeadSeparationTertiaryWashMixType,  MagneticBeadSeparationTertiaryWashSolution,  MagneticBeadSeparationWash, MagneticBeadSeparationWashAirDry,  MagneticBeadSeparationWashAirDryTime, MagneticBeadSeparationWashMix,  MagneticBeadSeparationWashMixRate,  MagneticBeadSeparationWashMixTemperature,  MagneticBeadSeparationWashMixTime, MagneticBeadSeparationWashMixType,  MagneticBeadSeparationWashSolution,  NumberOfLiquidLiquidExtractionMixes, NumberOfLiquidLiquidExtractions,  NumberOfLysisMixes, NumberOfLysisSteps,  NumberOfMagneticBeadSeparationElutionMixes,  NumberOfMagneticBeadSeparationElutions,  NumberOfMagneticBeadSeparationEquilibrationMixes,  NumberOfMagneticBeadSeparationLoadingMixes,  NumberOfMagneticBeadSeparationPreWashes,  NumberOfMagneticBeadSeparationPreWashMixes,  NumberOfMagneticBeadSeparationQuaternaryWashes,  NumberOfMagneticBeadSeparationQuaternaryWashMixes,  NumberOfMagneticBeadSeparationQuinaryWashes,  NumberOfMagneticBeadSeparationQuinaryWashMixes,  NumberOfMagneticBeadSeparationSecondaryWashes,  NumberOfMagneticBeadSeparationSecondaryWashMixes,  NumberOfMagneticBeadSeparationSenaryWashes,  NumberOfMagneticBeadSeparationSenaryWashMixes,  NumberOfMagneticBeadSeparationSeptenaryWashes,  NumberOfMagneticBeadSeparationSeptenaryWashMixes,  NumberOfMagneticBeadSeparationTertiaryWashes,  NumberOfMagneticBeadSeparationTertiaryWashMixes,  NumberOfMagneticBeadSeparationWashes,  NumberOfMagneticBeadSeparationWashMixes, NumberOfPrecipitationMixes,  OrganicSolvent, OrganicSolventRatio, PrecipitationDryingTemperature,  PrecipitationDryingTime, PrecipitationFilter,  PrecipitationFilterCentrifugeIntensity,  PrecipitationFiltrationPressure, PrecipitationFiltrationTechnique,  PrecipitationFiltrationTime, PrecipitationMembraneMaterial,  PrecipitationMixRate, PrecipitationMixTemperature,  PrecipitationMixTime, PrecipitationMixType,  PrecipitationNumberOfResuspensionMixes, PrecipitationNumberOfWashes,  PrecipitationNumberOfWashMixes,  PrecipitationPelletCentrifugeIntensity,  PrecipitationPelletCentrifugeTime, PrecipitationPoreSize,  PrecipitationPrefilterMembraneMaterial,  PrecipitationPrefilterPoreSize, PrecipitationReagent,  PrecipitationReagentEquilibrationTime,  PrecipitationReagentTemperature, PrecipitationResuspensionBuffer,  PrecipitationResuspensionBufferEquilibrationTime,  PrecipitationResuspensionBufferTemperature,  PrecipitationResuspensionMixRate,  PrecipitationResuspensionMixTemperature,  PrecipitationResuspensionMixTime, PrecipitationResuspensionMixType,  PrecipitationSeparationTechnique, PrecipitationTargetPhase,  PrecipitationTemperature, PrecipitationTime,  PrecipitationWashCentrifugeIntensity, PrecipitationWashMixRate,  PrecipitationWashMixTemperature, PrecipitationWashMixTime,  PrecipitationWashMixType, PrecipitationWashPrecipitationTemperature,  PrecipitationWashPrecipitationTime, PrecipitationWashPressure,  PrecipitationWashSeparationTime, PrecipitationWashSolution,  PrecipitationWashSolutionEquilibrationTime,  PrecipitationWashSolutionTemperature, PreLysisPellet,  PreLysisPelletingIntensity, PreLysisPelletingTime,  PreWashMagnetizationTime, Purification,  QuaternaryWashMagnetizationTime, QuinaryWashMagnetizationTime,  SecondaryLysisMixRate, SecondaryLysisMixTemperature,  SecondaryLysisMixTime, SecondaryLysisMixType, SecondaryLysisSolution,  SecondaryLysisSolutionEquilibrationTime,  SecondaryLysisSolutionTemperature, SecondaryLysisTemperature,  SecondaryLysisTime, SecondaryNumberOfLysisMixes,  SecondarySolidPhaseExtractionWashCentrifugeIntensity,  SecondarySolidPhaseExtractionWashPressure,  SecondarySolidPhaseExtractionWashSolution,  SecondarySolidPhaseExtractionWashTemperature,  SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime,  SecondarySolidPhaseExtractionWashTime,  SecondaryWashMagnetizationTime, SenaryWashMagnetizationTime,  SeptenaryWashMagnetizationTime, SolidPhaseExtractionCartridge,  (*SolidPhaseExtractionDigestionTemperature,  SolidPhaseExtractionDigestionTime,  *)SolidPhaseExtractionElutionCentrifugeIntensity,  SolidPhaseExtractionElutionPressure,  SolidPhaseExtractionElutionSolution,  SolidPhaseExtractionElutionSolutionTemperature,  SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime,  SolidPhaseExtractionElutionTime,  SolidPhaseExtractionLoadingCentrifugeIntensity,  SolidPhaseExtractionLoadingPressure,  SolidPhaseExtractionLoadingTemperature,  SolidPhaseExtractionLoadingTemperatureEquilibrationTime,  SolidPhaseExtractionLoadingTime, SolidPhaseExtractionSeparationMode,  SolidPhaseExtractionSorbent, SolidPhaseExtractionStrategy,  SolidPhaseExtractionTechnique,  SolidPhaseExtractionWashCentrifugeIntensity,  SolidPhaseExtractionWashPressure, SolidPhaseExtractionWashSolution,  SolidPhaseExtractionWashTemperature,  SolidPhaseExtractionWashTemperatureEquilibrationTime,  SolidPhaseExtractionWashTime, TargetProtein,  TertiaryLysisMixRate, TertiaryLysisMixTemperature,  TertiaryLysisMixTime, TertiaryLysisMixType, TertiaryLysisSolution,  TertiaryLysisSolutionEquilibrationTime,  TertiaryLysisSolutionTemperature, TertiaryLysisTemperature,  TertiaryLysisTime, TertiaryNumberOfLysisMixes,  TertiarySolidPhaseExtractionWashCentrifugeIntensity,  TertiarySolidPhaseExtractionWashPressure,  TertiarySolidPhaseExtractionWashSolution,  TertiarySolidPhaseExtractionWashTemperature,  TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime,  TertiarySolidPhaseExtractionWashTime, TertiaryWashMagnetizationTime,  WashMagnetizationTime};

(* ::Subsection::Closed:: *)
(*ExperimentExtractProtein*)

(* - Container to Sample Overload - *)

ExperimentExtractProtein[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
  {cache, listedOptions,listedContainers,outputSpecification,output,gatherTests,containerToSampleResult,
    containerToSampleOutput,samples,sampleOptions,containerToSampleTests,simulation,
    containerToSampleSimulation},

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Remove temporal links and named objects. *)
  {listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};

  (* Fetch the cache from listedOptions. *)
  cache=ToList[Lookup[listedOptions, Cache, {}]];
  simulation=Lookup[listedOptions, Simulation, Null];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
      ExperimentExtractProtein,
      listedContainers,
      listedOptions,
      Output->{Result,Tests,Simulation},
      Simulation->simulation
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
        ExperimentExtractProtein,
        listedContainers,
        listedOptions,
        Output-> {Result,Simulation},
        Simulation->simulation
      ],
      $Failed,
      {Download::ObjectDoesNotExist, Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
    ]
  ];


  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult,$Failed],
    (* containerToSampleOptions failed - return $Failed *)
    outputSpecification/.{
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null
    },
    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples,sampleOptions}=containerToSampleOutput;

    (* Call our main function with our samples and converted options. *)
    ExperimentExtractProtein[samples,ReplaceRule[sampleOptions,Simulation->simulation]]
  ]
];

(* - Main Overload - *)

ExperimentExtractProtein[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
  {
    cache, cacheBall, collapsedPreResolvedOptions,collapsedResolvedOptions, methodObjects, sampleFields,
    samplePacketFields, sampleModelFields, sampleModelPacketFields, methodPacketFields, containerObjectFields, containerObjectPacketFields, containerModelFields, containerModelPacketFields, containerModelObjects,
      containerObjects, expandedSafeOps, gatherTests, inheritedOptions, listedOptions,
    listedSamples, messages, output, outputSpecification, extractProteinCache, performSimulationQ, resultQ,resourcePacketResult,
    protocolObject, preResolvedOptions, resolvedOptionsResult, resolvedOptionsTests, resourceResult, resourcePacketTests,resourceReturnEarlyQ,
    returnEarlyQ, safeOps, safeOptions, safeOptionTests, templatedOptions, templateTests, resolvedPreparation, roboticSimulation, runTime,fullyResolvedOptions,
    inheritedSimulation, userSpecifiedObjects, objectsExistQs, objectsExistTests, validLengths, validLengthTests, simulation, listedSanitizedSamples,
    listedSanitizedOptions, expandedSafeOpsWithoutSolventAdditions
  },

  (* Determine the requested return value from the function (Result, Options, Tests, or multiple). *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests (Output contains Test). *)
  gatherTests=MemberQ[output,Tests];
  messages=!gatherTests;

  (* Remove links and temporal links (turn them into just objects). *)
  {listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Call SafeOptions to make sure all options match the option patterns. *)
  {safeOptions, safeOptionTests}=If[gatherTests,
    SafeOptions[ExperimentExtractProtein,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ExperimentExtractProtein,listedOptions,AutoCorrect->False],{}}
  ];
  inheritedSimulation=Lookup[safeOptions, Simulation, Null];
  (* Call sanitize-inputs to clean any named objects (all object Names to object IDs). *)
  {listedSanitizedSamples, safeOps, listedSanitizedOptions} = sanitizeInputs[listedSamples, safeOptions, listedOptions, Simulation -> inheritedSimulation];

  (* If the specified options don't match their patterns return $Failed *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOptionTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths,validLengthTests}=If[gatherTests,
    ValidInputLengthsQ[ExperimentExtractProtein,{listedSanitizedSamples},listedSanitizedOptions,Output->{Result,Tests}],
    {ValidInputLengthsQ[ExperimentExtractProtein,{listedSanitizedSamples},listedSanitizedOptions],Null}
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOptionTests,validLengthTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions,templateTests}=If[gatherTests,
    ApplyTemplateOptions[ExperimentExtractProtein,{listedSanitizedSamples},listedSanitizedOptions,Output->{Result,Tests}],
    {ApplyTemplateOptions[ExperimentExtractProtein,{listedSanitizedSamples},listedSanitizedOptions],Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOptionTests,validLengthTests,templateTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions=ReplaceRule[safeOps,templatedOptions];

  expandedSafeOpsWithoutSolventAdditions=Last[ExpandIndexMatchedInputs[ExperimentExtractProtein,{listedSanitizedSamples},
    (*In case of multiple samples in, but Purification->Single Purification with no list, to avoid it being incorrectly expanded and later recognized as two repeated purifications for each sample.*)
    (*If input is a non-nested list (e.g. {MBS,MBS}, we interpret it as for each sample regardless of sample length;
    If the input is a nested list (e.g. {{MBS},{MBS}}) then it has to index-matched to samples and will be caught if not *)
    If[MatchQ[Lookup[inheritedOptions,Purification],Except[None|Automatic]],
      ReplaceRule[inheritedOptions,
        Purification->ToList[Lookup[inheritedOptions,Purification]]],
      inheritedOptions
    ]
  ]];

  (* Correct expansion of SolventAdditions if not Automatic. *)
  (* NOTE:This is needed because SolventAdditions is not correctly expanded by ExpandIndexMatchedInputs. *)
  expandedSafeOps = expandSolventAdditionsOption[mySamples, inheritedOptions, expandedSafeOpsWithoutSolventAdditions, LiquidLiquidExtractionSolventAdditions, NumberOfLiquidLiquidExtractions];

  (* Fetch the cache from expandedSafeOps *)
  cache=Lookup[expandedSafeOps, Cache, {}];

  (* Disallow Upload->False and Confirm->True. *)
  (* Not making a test here because Upload is a hidden option and we don't currently make tests for hidden options. *)
  If[MatchQ[Lookup[safeOps,Upload],False]&&TrueQ[Lookup[safeOps,Confirm]],
    Message[Error::ConfirmUploadConflict];
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Flatten[{safeOptionTests,validLengthTests}],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

  (* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)
  (* Download fields from samples that are required.*)
  (* NOTE: All fields downloaded below should already be included in the cache passed down to us by the main function. *)
  sampleFields = DeleteDuplicates[Flatten[{Name, Status, Model, Composition, CellType, Living, CultureAdhesion, Volume, Analytes, Density, Container, Position, SamplePreparationCacheFields[Object[Sample]]}]];
  samplePacketFields = Packet@@sampleFields;
  sampleModelFields = DeleteDuplicates[Flatten[{Name, Composition, Density, Deprecated}]];
  sampleModelPacketFields = Packet@@sampleModelFields;
  methodPacketFields = Packet[All];
  containerObjectFields = {Contents, Model, Name};
  containerObjectPacketFields = Packet@@containerObjectFields;
  containerModelFields = {VolumeCalibrations, MaxCentrifugationForce, Footprint, MaxVolume, Positions, Name};
  containerModelPacketFields = Packet@@containerModelFields;

  containerModelObjects = DeleteDuplicates@Flatten[{
    Cases[
      Flatten[Lookup[safeOps, {LiquidLiquidExtractionContainer, ContainerOut}]],
      ObjectP[Model[Container]]
    ],
    PreferredContainer[All, LiquidHandlerCompatible -> True, Type -> All],
    (* Model[Container, Plate, PhaseSeparator, "Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits"] *)
    Model[Container, Plate, PhaseSeparator, "id:jLq9jXqrWW11"]
  }];

  containerObjects = DeleteDuplicates@Cases[
    Flatten[Lookup[safeOps, {LiquidLiquidExtractionContainer, ContainerOut}]],
    ObjectP[Object[Container]]
  ];

  methodObjects = Cases[Lookup[expandedSafeOps, Method],ObjectP[]];

  (* - Big Download to make cacheBall and get the inputs in order by ID - *)
  extractProteinCache=Download[
    {
      (*1*)listedSanitizedSamples,
      (*2*)listedSanitizedSamples,
      (*3*)methodObjects,
      (*4*)listedSanitizedSamples,
      (*5*)listedSanitizedSamples,
      (*6*)containerModelObjects,
      (*7*)containerObjects
    },
    Evaluate[{
      (*1*){samplePacketFields},
      (*2*){Packet[Model[sampleModelFields]]},
      (*3*){methodPacketFields},
      (*4*){Packet[Container[containerObjectFields]]},
      (*5*){Packet[Container[Model][containerModelFields]]},
      (*6*){containerModelPacketFields, Packet[VolumeCalibrations[{CalibrationFunction}]]},
      (*7*){containerObjectPacketFields, Packet[Model[containerModelFields]], Packet[Model[VolumeCalibrations][{CalibrationFunction}]]}
    }],
    Cache->cache,
    Simulation ->inheritedSimulation
  ];

  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  cacheBall=FlattenCachePackets[{cache,extractProteinCache}];


  (* Build the resolved options *)
  resolvedOptionsResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {preResolvedOptions,resolvedOptionsTests}=resolveExperimentExtractProteinOptions[
      ToList[Download[mySamples,Object]],
      expandedSafeOps,
      Cache->cacheBall,
      Simulation->inheritedSimulation,
      Output->{Result,Tests}
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {preResolvedOptions,resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {preResolvedOptions,resolvedOptionsTests}={
        resolveExperimentExtractProteinOptions[
          ToList[Download[mySamples,Object]],
          expandedSafeOps,
          Cache->cacheBall,
          Simulation->inheritedSimulation
        ],
        {}
      },
      $Failed,
      {Error::InvalidInput,Error::InvalidOption}
    ]
  ];

  (* Collapse the resolved options *)
  collapsedPreResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentExtractProtein,
    preResolvedOptions,
    Ignore -> ToList[myOptions],
    Messages -> False
  ];

  (* Run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  returnEarlyQ = Which[
    MatchQ[resolvedOptionsResult, $Failed],
      True,
    gatherTests,
      Not[RunUnitTest[<|"Tests"->resolvedOptionsTests|>, Verbose->False, OutputFormat->SingleBoolean]],
    True,
      False
  ];

  (* This is because we pass down our simulation to ExperimentMSP or ExperimentRSP. *)
  performSimulationQ = MemberQ[output, Result|Simulation];
  (* If we did get the result, we should try to quiet messages in simulation so that we will not duplicate them. We will just silently update our simulation *)
  resultQ = MemberQ[output, Result];

  (* If option resolution failed, return early. *)
  If[returnEarlyQ && !performSimulationQ,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentExtractProtein,collapsedResolvedOptions],
      Preview->Null,
      Simulation -> Simulation[]
    }]
  ];

  (* Build packets with resources *)
  (* NOTE: If our resource packets function, if Preparation->Robotic, we call RSP in order to get the robotic unit operation *)
  (* packets. We also get a robotic simulation at the same time. *)
  (* Build packets with resources *)
  resourcePacketResult = Which[
    MatchQ[resolvedOptionsResult, $Failed],
    {{resourceResult, roboticSimulation, runTime, fullyResolvedOptions}, resourcePacketTests} = {{$Failed, $Failed, $Failed, $Failed}, {}},
    gatherTests,
    (* If we are gathering tests. This silences any messages being thrown. *)
    {{resourceResult, roboticSimulation, runTime, fullyResolvedOptions}, resourcePacketTests} = extractProteinResourcePackets[
      ToList[Download[mySamples, Object]],
      templatedOptions,
      preResolvedOptions,
      Cache -> cacheBall,
      Simulation -> inheritedSimulation,
      Output -> {Result, Tests}
    ];
    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests" -> resourcePacketTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      {{resourceResult, roboticSimulation, runTime, fullyResolvedOptions}, resourcePacketTests},
      $Failed
    ],
    True,
    Check[
      {{resourceResult, roboticSimulation, runTime, fullyResolvedOptions}, resourcePacketTests} = {
        extractProteinResourcePackets[
          ToList[Download[mySamples, Object]],
          templatedOptions,
          preResolvedOptions,
          Cache -> cacheBall,
          Simulation -> inheritedSimulation
        ],
        {}
      },
      $Failed,
      {Error::InvalidOption}
    ]
  ];

  (* run all the tests from the resolution in the resource packet function; if any of them were False, then we should return early here *)
  (* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  resourceReturnEarlyQ = Which[
    MatchQ[resourcePacketResult, $Failed],
      True,
    gatherTests,
      Not[RunUnitTest[<|"Tests" -> resourcePacketTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
    True,
      False
  ];

  (* Collapse the resolved options *)
  {collapsedResolvedOptions, resolvedPreparation} = If[MatchQ[resolvedOptionsResult, $Failed],
    {
      $Failed,
      Lookup[preResolvedOptions, Preparation]
    },
    {
      CollapseIndexMatchedOptions[
        ExperimentExtractProtein,
        fullyResolvedOptions,
        Ignore -> ToList[myOptions],
        Messages -> False
      ],
      Lookup[fullyResolvedOptions, Preparation]
    }
  ];


  (* If we were asked for a simulation, also return a simulation. *)
  simulation = Which[
    !performSimulationQ,
      Null,
    MatchQ[resolvedPreparation, Robotic] && MatchQ[roboticSimulation, SimulationP],
      roboticSimulation,
    True,
      Null
  ];

  (* If option resolution failed in the resource packet function, return early. *)
  If[resourceReturnEarlyQ,
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOptionTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests],
      Options -> RemoveHiddenOptions[ExperimentExtractProtein, preResolvedOptions],
      Preview -> Null,
      Simulation -> simulation
    }]
  ];

  (* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
  If[!MemberQ[output,Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentExtractProtein,collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> simulation,
      RunTime -> runTime
    }]
  ];

  (* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
  protocolObject = Which[
    (* If our resource packets failed, we can't upload anything. *)
    MatchQ[resourceResult,$Failed],
    $Failed,

    (* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
    (* Upload->False. *)
    MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[safeOps,Upload], False],
    Rest[resourceResult], (* unitOperationPackets *)

    (* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticSamplePreparation with our primitive. *)
    True,
    Module[{primitive, nonHiddenOptions, experimentFunction},
      (* Create our primitive to feed into RoboticSamplePreparation. *)
      primitive=ExtractProtein@@Join[
        {
          Sample->Download[ToList[mySamples], Object]
        },
        RemoveHiddenPrimitiveOptions[ExtractProtein,ToList[myOptions]]
      ];

      (* Remove any hidden options before returning. *)
      nonHiddenOptions=RemoveHiddenOptions[ExperimentExtractProtein,collapsedResolvedOptions];

      (* Memoize the value of ExperimentExtractProtein so the framework doesn't spend time resolving it again. *)
      Internal`InheritedBlock[{ExperimentExtractProtein, $PrimitiveFrameworkResolverOutputCache},
        $PrimitiveFrameworkResolverOutputCache=<||>;

        DownValues[ExperimentExtractProtein]={};

        ExperimentExtractProtein[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
          (* Lookup the output specification the framework is asking for. *)
          frameworkOutputSpecification=Lookup[ToList[options], Output];

          frameworkOutputSpecification/.{
            Result -> Rest[resourceResult],
            Options -> nonHiddenOptions,
            Preview -> Null,
            Simulation -> simulation,
            RunTime -> runTime
          }
        ];

        (* mapping between workcell name and experiment function *)
        experimentFunction = Lookup[$WorkCellToExperimentFunction, Lookup[fullyResolvedOptions, WorkCell]];

        experimentFunction[
          {primitive},
          Name->Lookup[safeOps,Name],
          Upload->Lookup[safeOps,Upload],
          Confirm->Lookup[safeOps,Confirm],
          CanaryBranch->Lookup[safeOps,CanaryBranch],
          ParentProtocol->Lookup[safeOps,ParentProtocol],
          Priority->Lookup[safeOps,Priority],
          StartDate->Lookup[safeOps,StartDate],
          HoldOrder->Lookup[safeOps,HoldOrder],
          QueuePosition->Lookup[safeOps,QueuePosition],
          Cache->cacheBall
        ]
      ]
    ]
  ];

  (* Return requested output *)
  outputSpecification/.{
    Result -> protocolObject,
    Tests -> Flatten[{safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentExtractProtein,collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> simulation,
    RunTime -> runTime
  }
];

(* ::Subsection:: *)
(* Helper function -- resolve extracted sample label *)
resolveExtractedProteinSampleLabel[
  samples:ListableP[ObjectP[Object[Sample]]],
  myMapThreadFriendlyOptions:{(_Association | {_Rule...})...},
  sampleLabelOptionName:ExtractedProteinLabel|ExtractedCytosolicProteinLabel|ExtractedMembraneProteinLabel|ExtractedNuclearProteinLabel,
  defaultLabel_String,
  userLabels:{(_String)...},
  simulation:SimulationP|Null
]:=MapThread[
  Function[{sample, options},
    Which[
      (* If specified by user, then use that value. *)
      MatchQ[Lookup[options, sampleLabelOptionName], Except[Automatic]],
      Lookup[options, sampleLabelOptionName],
      (* If the sample has a label from an upstream unit operation, then use that. *)
      MatchQ[LookupObjectLabel[simulation, Download[sample, Object]], _String],
      LookupObjectLabel[simulation, Download[sample, Object]],
      (* If the sample does not already have a label and one is not specified by the user, then set to the default. *)
      True,
      CreateUniqueLabel[defaultLabel, Simulation->simulation, UserSpecifiedLabels->userLabels]
    ]
  ],
  {samples, myMapThreadFriendlyOptions}
];

(* Helper function -- Pre-resolve container out option and remove wells *)
preResolveContainersOutAndRemoveWellsForProteinExperiments[
  roundedOptions:(_List | _Association),
  containerOutOptionName:ContainerOut|ExtractedCytosolicProteinContainer|ExtractedMembraneProteinContainer|ExtractedNuclearProteinContainer
]:=Map[
  Which[
    (* If the user specified ContainerOut using the "Container with Well" widget format, remove the well. *)
    MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container],Model[Container]}]}],
    Last[#],
    (* If the user specified ContainerOut using the "Container with Well and Index" widget format, remove the well. *)
    MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container],Model[Container]}]}}],
    Last[#],
    (* If the user specified ContainerOut any other way, we don't have to mess with it here. *)
    True,
    #
  ]&,
  Lookup[roundedOptions, containerOutOptionName]
];

(* Helper functions -- Resolve the container labels based on the information that we have prior to simulation. *)
preResolveProteinContainerLabel[
  resolverContainersOutNoWell:ListableP[Alternatives[Automatic,Null,ObjectP[{Object[Container],Model[Container]}],{GreaterEqualP[1, 1], ObjectP[{Object[Container],Model[Container]}]}]],
  roundedOptions:(_List | _Association),
  containerLabelOptionInput:ListableP[Null|Automatic|(_String)],
  containerLabelOptionName:ExtractedProteinContainerLabel|ExtractedCytosolicProteinContainerLabel|ExtractedMembraneProteinContainerLabel|ExtractedNuclearProteinContainerLabel,
  defaultLabel_String,
  userLabels:{(_String)...},
  simulation:SimulationP|Null
]:=Module[
  {sampleContainersToGroupedLabels, sampleContainersToUserSpecifiedLabels},

  (* Make association of containers to their label(s). *)
  (* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
  sampleContainersToGroupedLabels=GroupBy[
    Rule@@@Transpose[{resolverContainersOutNoWell, Lookup[roundedOptions, containerLabelOptionName]}],
    First->Last
  ];

  sampleContainersToUserSpecifiedLabels=(#[[1]]->FirstCase[#[[2]], _String, Null]&)/@Normal[sampleContainersToGroupedLabels];

  MapThread[
    Function[{container, userSpecifiedLabel},
      Which[
        (* User specified the option. *)
        MatchQ[userSpecifiedLabel, _String],
          userSpecifiedLabel,
        (* All Model[Container]s are unique and recieve unique labels. *)
        MatchQ[container, ObjectP[Model[Container]]],
          CreateUniqueLabel[defaultLabel, Simulation->simulation, UserSpecifiedLabels->userLabels],
        (* User specified the option for another index that this container shows up. *)
        MatchQ[Lookup[sampleContainersToUserSpecifiedLabels, Key[container]], _String],
          Lookup[sampleContainersToUserSpecifiedLabels, Key[container]],
        (* The user has labeled this container upstream in another unit operation. *)
        MatchQ[container, ObjectP[Object[Container]]] && MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[container, Object]], _String],
          LookupObjectLabel[simulation, Download[container, Object]],
        (* If a container is specified, make a new label for this container and add it to the container-to-label association. *)
        MatchQ[container, Except[Automatic]],
          Module[{},
            sampleContainersToUserSpecifiedLabels=ReplaceRule[
              sampleContainersToUserSpecifiedLabels,
              container->CreateUniqueLabel[defaultLabel, Simulation->simulation, UserSpecifiedLabels->userLabels]
            ];

            Lookup[sampleContainersToUserSpecifiedLabels, Key[container]]
          ],
        (* Otherwise, make a new label to be assigned to the container that is resolved in RCP. *)
        True,
         CreateUniqueLabel[defaultLabel, Simulation->simulation, UserSpecifiedLabels->userLabels]
      ]
    ],
    {resolverContainersOutNoWell, containerLabelOptionInput}
  ]
];

(* Helper functions -- Pre-resolve container outs with wells removed *)
(*Returns list of container out wells, and indexed container out*)
preResolveContainerOutWellAndIndexedContainer[
  resolverContainersOutNoWell:ListableP[Alternatives[Automatic,Null,ObjectP[{Object[Container],Model[Container]}],{GreaterEqualP[1, 1], ObjectP[{Object[Container],Model[Container]}]}]],
  roundedOptions:(_List | _Association),
  containerOutOptionName:ContainerOut|ExtractedCytosolicProteinContainer|ExtractedMembraneProteinContainer|ExtractedNuclearProteinContainer,
  fastCacheBall: _Association
]:=Module[
  {wellsFromContainersOut, uniqueContainers, containerToFilledWells, containerToWellOptions, containerToIndex},

  (* Get any wells from user-specified container out inputs according to their widget patterns. *)
  wellsFromContainersOut = Map[
    Which[
      (* If ContainerOut specified using the "Container with Well" widget format, extract the well. *)
      MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container],Model[Container]}]}],
      First[#],
      (* If ContainerOut specified using the "Container with Well and Index" widget format, extract the well. *)
      MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container],Model[Container]}]}}],
      First[#],
      (* Otherwise, there isn't a well specified and we set this to automatic. *)
      True,
      Automatic
    ]&,
    Lookup[roundedOptions, containerOutOptionName]
  ];

  (*Make an association of the containers with their already specified wells.*)
  uniqueContainers = DeleteDuplicates[Cases[resolverContainersOutNoWell, Alternatives[ObjectP[Object[Container]],ObjectP[Model[Container]],{_Integer, ObjectP[Model[Container]]}]]];

  containerToFilledWells = Map[
    Module[
      {uniqueContainerWells},

      (*Check if the container is a non-indexed model or non-indexed object. If so, then don't need to "reserve" wells*)
      (*because a new container will be used for each sample for non-indexed model and non-indexed object will be filled below.*)
      If[
        MatchQ[#[[1]], _Integer] || MatchQ[#, ObjectP[Object[Container]]],
        Module[{},

          (*MapThread through the wells and containers. Return the well if the container is the one being sorted.*)
          uniqueContainerWells = MapThread[
            Function[
              {well, container},
              If[
                MatchQ[container, #] && !MatchQ[well, Automatic],
                well,
                Nothing
              ]
            ],
            {wellsFromContainersOut, resolverContainersOutNoWell}
          ];

          (*Return rule in the form of indexed container model to Filled wells.*)
          If[
            MatchQ[#[[1]], _Integer],
            # -> uniqueContainerWells,
            {1,#} -> uniqueContainerWells
          ]

        ],
        Nothing
      ]

    ]&,
    uniqueContainers
  ];

  (*Determine all of the options that the well can be in this container and put into a rule list.*)
  containerToWellOptions = Map[
    Module[
      {containerModelPacket},

      (*Get the container model to look up the available wells.*)
      containerModelPacket =
          Which[
            (*If the container without a well is just a container model, then that can be used directly.*)
            MatchQ[#, ObjectP[Model[Container]]],
              fetchPacketFromFastAssoc[#, fastCacheBall],
            (*If the container is an object, then the model is downloaded from the cache.*)
            MatchQ[#, ObjectP[Object[Container]]],
              fastAssocPacketLookup[fastCacheBall, #, Model],
            (*If the container is an indexed container model, then the model is the second element.*)
            True,
              fetchPacketFromFastAssoc[#[[2]], fastCacheBall]
          ];

      (*The well options are downloaded from the cache from the container model.*)
      # -> Flatten[Transpose[AllWells[AspectRatio -> Lookup[containerModelPacket, AspectRatio], NumberOfWells -> Lookup[containerModelPacket, NumberOfWells]]]]

    ]&,
    uniqueContainers
  ];

  (*Create a rule list to keep track of the index of the model containers that are being filled.*)
  containerToIndex = Map[
    If[
      MatchQ[#, ObjectP[Model[Container]]],
      # -> 1,
      Nothing
    ]&,
    uniqueContainers
  ];

  (*MapThread through containers without wells and wells. If resolving needed, finds next available well, resolves it and adds to "taken" wells.*)
  (*Also adds indexing to container if not already indexed.*)
  Transpose[MapThread[
    Function[
      {well,container},
      If[MemberQ[{well, container}, Automatic],
        Module[
          {indexedContainer},

          (*Add index to container if not already indexed.*)
          indexedContainer = Which[
            (*If the container without a well is a non-indexed container model, then a new container is indexed.*)
            MatchQ[container, ObjectP[Model[Container]]],
            Module[
              {},

              (*Moves up the index until the container model index is not already assigned.*)
              While[
                KeyExistsQ[containerToFilledWells,{Lookup[containerToIndex,container],container}],
                containerToIndex = ReplaceRule[containerToIndex, container -> (Lookup[containerToIndex, container]+1)]
              ];

              {Lookup[containerToIndex,container],container}

            ],
            MatchQ[container, ObjectP[Object[Container]]],
            {1, container},
            True,
            container
          ];

          (*Check if the well is already set and doesn't need resolution.*)
          If[
            MatchQ[well, Automatic] && MatchQ[container, Except[Automatic]],
            Module[
              {filledWells,  wellOptions, availableWells, selectedWell},

              (*Pull out the already filled wells from containerToFilledWells so that we don't assign this sample *)
              (*to an already filled well.*)
              filledWells = Lookup[containerToFilledWells, Key[indexedContainer], {}];

              (*Pull out all of the options that the well can be in this container.*)
              wellOptions = Lookup[containerToWellOptions, Key[container]];

              (*Remove filled wells from the well options*)
              (*NOTE:Can't just use compliment because it messes with the order of wellOptions which*)
              (*has already been optimized for the liquid handlers.*)
              availableWells = UnsortedComplement[wellOptions, filledWells];

              (*Select the first well in availableWells to put the sample into.*)
              selectedWell = Which[
                (*If there is an available well, then fill it.*)
                MatchQ[availableWells, Except[{}]],
                First[availableWells],
                (*If there is not an available well and the container is not an object or indexed container, then clear the*)
                (*filled wells and start a new list.*)
                MatchQ[availableWells, {}] && !MatchQ[container, ObjectP[Object[Container]]|{_Integer, ObjectP[Model[Container]]}],
                Module[
                  {},

                  containerToFilledWells = ReplaceRule[containerToFilledWells, {indexedContainer -> {}}];

                  "A1"

                ],
                (*If there is not an available well and the container is an object or indexed container, then just set to A1.*)
                (*NOTE:At this point, the object container or indexed container model is full, so just set to A1 and will be caught by error checking.*)
                True,
                "A1"
              ];



              (*Now that this well is filled, added to list of filled wells.*)
              containerToFilledWells = If[
                KeyExistsQ[containerToFilledWells, indexedContainer],
                ReplaceRule[containerToFilledWells, {indexedContainer -> Append[filledWells,selectedWell]}],
                Append[containerToFilledWells, indexedContainer -> Append[filledWells,selectedWell]]
              ];

              (*Return the selected well and the indexed container.*)
              {selectedWell, indexedContainer}

            ],
            Module[
              {},

              (* If the container has a new index (non-indexed container model to start), then *)
              (* added to the containerToFilledWells list. *)
              If[
                MatchQ[container, ObjectP[Model[Container]]],
                containerToFilledWells = Append[containerToFilledWells, indexedContainer -> {well}]
              ];

              (*Return the user-specified well and the indexed container.*)
              {well, indexedContainer}

            ]
          ]
        ],
        {well, container}
      ]
    ],
    {wellsFromContainersOut, resolverContainersOutNoWell}
  ]]
];

(* Helper functions -- Pre-resolve lysis options *)
preResolveLysisOptionsForExtractProtein[
  resolvedLysisMasterswitch:BooleanP,
  userInputMapThreadOptions_Association,
  userMethodQ:BooleanP,
  userMethod:PacketP[Object[Method]]|Null,
  assignedMethodQ:BooleanP,
  assignedMethod:<||>|PacketP[Object[Method]]|Null,
  resolvedPurificationMasterswitch:ListableP[Alternatives[LiquidLiquidExtraction,Precipitation,SolidPhaseExtraction,MagneticBeadSeparation,None]]
]:=Module[
  {
    preResolvedLysisTime,lysisTime,userMethodLysisTime,assignedMethodLysisTime,
    preResolvedLysisTemperature,lysisTemperature, userMethodLysisTemperature, assignedMethodLysisTemperature,
    preResolvedLysisAliquot,lysisAliquot,lysisAliquotAmount,targetCellCount,targetCellConcentration,
    preResolvedClarifyLysate,clarifyLysate,userMethodClarifyLysate,assignedMethodClarifyLysate,
    clarifyLysateCentrifuge, clarifyLysateIntensity, clarifyLysateTime, clarifiedLysateVolume, postClarificationPelletStorageCondition,
    preResolvedLysisAliquotContainer,lysisAliquotContainer,preResolvedLysisAliquotContainerLabel,lysisAliquotContainerLabel,
    preResolvedClarifiedLysateContainer,clarifiedLysateContainer,preResolvedClarifiedLysateContainerLabel,clarifiedLysateContainerLabel,
    containerOut,extractProteinContainerLabel,
    resolvedNumberOfLysisSteps,numberOfLysisSteps, userMethodNumberOfLysisSteps,assignedMethodNumberOfLysisSteps,
    resolvedLysisSolutionTemperature,lysisSolutionTemperature, userMethodLysisSolutionTemperature, assignedMethodLysisSolutionTemperature,
    resolvedLysisSolutionEquilibrationTime, lysisSolutionEquilibrationTime, userMethodLysisSolutionEquilibrationTime, assignedMethodLysisSolutionEquilibrationTime,
    resolvedSecondaryLysisSolutionTemperature, secondaryLysisSolutionTemperature, userMethodSecondaryLysisSolutionTemperature, assignedMethodSecondaryLysisSolutionTemperature,
    resolvedSecondaryLysisSolutionEquilibrationTime,secondaryLysisSolutionEquilibrationTime, userMethodSecondaryLysisSolutionEquilibrationTime, assignedMethodSecondaryLysisSolutionEquilibrationTime,
    resolvedTertiaryLysisSolutionTemperature,tertiaryLysisSolutionTemperature, userMethodTertiaryLysisSolutionTemperature, assignedMethodTertiaryLysisSolutionTemperature,
    resolvedTertiaryLysisSolutionEquilibrationTime,tertiaryLysisSolutionEquilibrationTime, userMethodTertiaryLysisSolutionEquilibrationTime, assignedMethodTertiaryLysisSolutionEquilibrationTime
  },

  (*Look up the option values*)
  {(*General*)
    containerOut,extractProteinContainerLabel,
    (*Lysis general*)
    lysisTime,lysisTemperature,numberOfLysisSteps,lysisSolutionTemperature,lysisSolutionEquilibrationTime,
    secondaryLysisSolutionTemperature,secondaryLysisSolutionEquilibrationTime,
    tertiaryLysisSolutionTemperature,tertiaryLysisSolutionEquilibrationTime,

    (*Lysis aliquot*)
    lysisAliquot,lysisAliquotAmount,targetCellCount,targetCellConcentration,lysisAliquotContainer,lysisAliquotContainerLabel,
    (*Lysis clarification*)
    clarifyLysate,clarifyLysateCentrifuge,clarifyLysateIntensity, clarifyLysateTime, clarifiedLysateVolume,postClarificationPelletStorageCondition,clarifiedLysateContainer,clarifiedLysateContainerLabel
  }=Lookup[userInputMapThreadOptions,
    {(*General*)
      ContainerOut,ExtractedProteinContainerLabel,
      (*Lysis*)
      LysisTime,LysisTemperature,NumberOfLysisSteps,LysisSolutionTemperature,LysisSolutionEquilibrationTime,
      SecondaryLysisSolutionTemperature,SecondaryLysisSolutionEquilibrationTime,
      TertiaryLysisSolutionTemperature,TertiaryLysisSolutionEquilibrationTime,
      (*Lysis aliquot*)
      LysisAliquot,LysisAliquotAmount,TargetCellCount,TargetCellConcentration,LysisAliquotContainer,LysisAliquotContainerLabel,
      (*Lysis clarification*)
      ClarifyLysate,ClarifyLysateCentrifuge,ClarifyLysateIntensity, ClarifyLysateTime,ClarifiedLysateVolume,PostClarificationPelletStorageCondition,ClarifiedLysateContainer,ClarifiedLysateContainerLabel
    }
  ];

  (*Look up the user-specified method option values*)
  {userMethodLysisTime,userMethodLysisTemperature,userMethodNumberOfLysisSteps, userMethodClarifyLysate,userMethodLysisSolutionTemperature, userMethodLysisSolutionEquilibrationTime, userMethodSecondaryLysisSolutionTemperature, userMethodSecondaryLysisSolutionEquilibrationTime, userMethodTertiaryLysisSolutionTemperature, userMethodTertiaryLysisSolutionEquilibrationTime
  }=If[MatchQ[userMethod,PacketP[]],
    Lookup[userMethod,#,Null]&/@ {
     LysisTime,LysisTemperature,NumberOfLysisSteps,ClarifyLysate,LysisSolutionTemperature, LysisSolutionEquilibrationTime,
      SecondaryLysisSolutionTemperature, SecondaryLysisSolutionEquilibrationTime,
      TertiaryLysisSolutionTemperature, TertiaryLysisSolutionEquilibrationTime
    },
    ConstantArray[Null,10]
  ];

  (*Lookup the values in the assigned method packet if it's not empty*)
  {assignedMethodLysisTime, assignedMethodLysisTemperature,assignedMethodNumberOfLysisSteps, assignedMethodClarifyLysate,assignedMethodLysisSolutionTemperature, assignedMethodLysisSolutionEquilibrationTime,
    assignedMethodSecondaryLysisSolutionTemperature, assignedMethodSecondaryLysisSolutionEquilibrationTime,
    assignedMethodTertiaryLysisSolutionTemperature, assignedMethodTertiaryLysisSolutionEquilibrationTime}=If[!MatchQ[assignedMethod,Null|<||>],
    Lookup[assignedMethod,#,Null]&/@{
      LysisTime,LysisTemperature,NumberOfLysisSteps,
      ClarifyLysate,LysisSolutionTemperature, LysisSolutionEquilibrationTime,
      SecondaryLysisSolutionTemperature, SecondaryLysisSolutionEquilibrationTime,
      TertiaryLysisSolutionTemperature, TertiaryLysisSolutionEquilibrationTime
    }, 
    (*If the assigned method packet is empty, set to nulls*)
    ConstantArray[Null,10]
  ];
  
  (*resolving LysisTime before calling the LyseCells resolver, bc LyseCells resolver has a default instead of Automatic, so we resolve here first and send it into resolveSharedOptions with the pre-resolved value*)
  preResolvedLysisTime = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[lysisTime,Except[Automatic]],
    lysisTime,
    (*If a method is specified and LysisTime is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodLysisTime, Except[Null]],
    userMethodLysisTime,
    (*If a method is resolved based on TargetProtein and Lyse/CellType and LysisTime is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodLysisTime, Except[Null]],
    assignedMethodLysisTime,
    (*If the sample will not be lysed, then LysisTime is set to Null.*)
    MatchQ[resolvedLysisMasterswitch, False],
    Null,
    (*If the sample will be lysed and LysisTime is Automatic, then is set to the default.*)
    True,
    15 Minute
  ];

  (*resolving LysisTemperature before calling the LyseCells resolver, bc LyseCells resolver has a default instead of Automatic, so we resolve here first and send it into resolveSharedOptions with the pre-resolved value*)
  preResolvedLysisTemperature = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[lysisTemperature,Except[Automatic]],
    lysisTemperature,
    (*If a method is specified and LysisTemperature is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodLysisTemperature,Except[Null]],
    userMethodLysisTemperature,
    (*If a method isresolved based on TargetProtein and Lyse/CellType and LysisTemperature is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodLysisTemperature, Except[Null]],
    assignedMethodLysisTemperature,
    (*If the sample will not be lysed, then LysisTemperature is set to Null.*)
    MatchQ[resolvedLysisMasterswitch, False],
    Null,
    (*If the sample will be lysed and LysisTemperature is Automatic, then is set to the default.*)
    True,
    Ambient
  ];

  (*Resolve LysisAliquot switch, because it is needed to check if LysisAliquotContainter will be the ContainerOut*)
  preResolvedLysisAliquot=Which[
    (* Use the user-specified values, if any *)
    MatchQ[lysisAliquot,Except[Automatic]],
    lysisAliquot,
    (*If the sample will not be lysed, then LysisTemperature is set to Null.*)
    MatchQ[resolvedLysisMasterswitch, False],
    Null,
    (* Set LysisAliquot to True if any of LysisAliquotAmount, LysisAliquotContainer, TargetCellCount or TargetCellConcentration are specified by user*)
    MemberQ[{lysisAliquotAmount,lysisAliquotContainer, lysisAliquotContainerLabel,targetCellCount, targetCellConcentration}, Except[Null|Automatic]],
    True,
    (* Otherwise, set to False *)
    True,
    False
  ];

  (*Resolve ClarifyLysate switch, because it is needed to check if ClarifiedLysateContainter will be the ContainerOut*)
  preResolvedClarifyLysate=Which[
    (* Use the user-specified values, if any *)
    MatchQ[clarifyLysate, Except[Automatic]],
    clarifyLysate,
    (* Use the Method-specified values, if any *)
    (*If a method is specified and LysisTemperature is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodClarifyLysate,Except[Null]],
    userMethodClarifyLysate,
    (*If a method isresolved based on TargetProtein and Lyse/CellType and LysisTemperature is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodClarifyLysate, Except[Null]],
    assignedMethodClarifyLysate,
    (*If the sample will not be lysed, then LysisTemperature is set to Null.*)
    MatchQ[resolvedLysisMasterswitch, False],
    Null,
    (* Set to True if any of the dependent options are set *)
    MemberQ[{clarifyLysateCentrifuge, clarifyLysateIntensity, clarifyLysateTime, clarifiedLysateVolume, clarifiedLysateContainer, postClarificationPelletStorageCondition},Except[Null|Automatic]],
    True,
    (* Otherwise, this is False *)
    True,
    False
  ];

  preResolvedLysisAliquotContainer = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[lysisAliquotContainer, Except[Automatic]],
    lysisAliquotContainer,
    (*not a field in Method so no need to check Method*)
    (*If the sample will be lysed and nothing else (no purification steps) and the sample will be aliquotted but not clarified during LyseCells, then set to the ContainerOut specified in the options*)
    MatchQ[resolvedLysisMasterswitch, True] && MatchQ[resolvedPurificationMasterswitch, None|Null] && MatchQ[{preResolvedLysisAliquot,preResolvedClarifyLysate},{True, False}],
    containerOut,
    (*Otherwise, should be resolved by ExperimentLyseCells.*)
    True,
    Automatic
  ];

  preResolvedLysisAliquotContainerLabel = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[lysisAliquotContainerLabel, Except[Automatic]],
    lysisAliquotContainerLabel,
    (*not a field in Method so no need to check Method*)
    (*If the sample will be lysed and nothing else (no purification steps) and the sample will be aliquotted but not clarified during LyseCells, then set to the extractedProteinContainerLabel specified in the options*)
    MatchQ[resolvedLysisMasterswitch, True] && MatchQ[resolvedPurificationMasterswitch, None|Null] && MatchQ[{preResolvedLysisAliquot,preResolvedClarifyLysate},{True, False}],
    extractProteinContainerLabel,
    (*Otherwise, should be resolved by ExperimentLyseCells.*)
    True,
    Automatic
  ];

  preResolvedClarifiedLysateContainer = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[clarifiedLysateContainer, Except[Automatic]],
    clarifiedLysateContainer,
    (*not a field in Method so no need to check Method*)
    (*If the sample will be lysed and nothing else (no purification steps) and the sample will clarified during LyseCells, then set to the ContainerOut specified in the options*)
    MatchQ[resolvedLysisMasterswitch, True] && MatchQ[resolvedPurificationMasterswitch, None|Null] && MatchQ[preResolvedClarifyLysate,True],
    containerOut,
    (*Otherwise, should be resolved by ExperimentLyseCells.*)
    True,
    Automatic
  ];

  preResolvedClarifiedLysateContainerLabel = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[clarifiedLysateContainerLabel,Except[Automatic]],
    clarifiedLysateContainerLabel,
    (*not a field in Method so no need to check Method*)
    (*If the sample will be lysed and nothing else (no homogenization, dehydration, or purification steps) and the sample will clarified during LyseCells, then set to the ContainerOutLabel specified in the options*)
    (*If the sample will be lysed and nothing else (no purification steps) and the sample will clarified during LyseCells, then set to the extractedProteinContainerLabel specified in the options*)
    MatchQ[resolvedLysisMasterswitch, True] && MatchQ[resolvedPurificationMasterswitch, None|Null] && MatchQ[preResolvedClarifyLysate,True],
    extractProteinContainerLabel,
    (*Otherwise, should be resolved by ExperimentLyseCells.*)
    True,
    Automatic
  ];

  (*Pre-resolve NumberOfLysisSteps because there are additional options for each step specific for protein experiment, including LysisSolutionTemperature and LysisSolutionEquilibrationTime*)
  resolvedNumberOfLysisSteps=Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[numberOfLysisSteps,Except[Automatic]],
    numberOfLysisSteps,
    (* Use the Method-specified values, if any *)
    (*If a method is specified and it is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodNumberOfLysisSteps,Except[Null]],
    userMethodNumberOfLysisSteps,
    (*If a method is resolved based on TargetProtein and Lyse/CellType and it is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodNumberOfLysisSteps, Except[Null]],
    assignedMethodNumberOfLysisSteps,
    (*If any of the tertiary lysis options is specified by the user or the method, set to 3 *)
    Or[
      MatchQ[resolvedLysisMasterswitch, True]&&MemberQ[Flatten@Join[Lookup[userInputMapThreadOptions,$TertiaryLysisOptionsWithLysisPrefix],{tertiaryLysisSolutionTemperature,tertiaryLysisSolutionEquilibrationTime}],Except[Null|Automatic]],
      userMethodQ && MemberQ[KeyExistsQ[userMethod, #] & /@ $TertiaryLysisOptionsWithLysisPrefix, True] && MemberQ[Cases[Lookup[userMethod, $TertiaryLysisOptionsWithLysisPrefix], Except[Missing[_,_]]], Except[Null]],
      assignedMethodQ &&MemberQ[KeyExistsQ[assignedMethod, #] & /@ $TertiaryLysisOptionsWithLysisPrefix, True] && MemberQ[Cases[Lookup[assignedMethod, $TertiaryLysisOptionsWithLysisPrefix], Except[Missing[_,_]]], Except[Null]]
    ],
    3,
    Or[
      MatchQ[resolvedLysisMasterswitch, True]&&MemberQ[Flatten@Join[Lookup[userInputMapThreadOptions,$SecondaryLysisOptionsWithLysisPrefix],{secondaryLysisSolutionTemperature,secondaryLysisSolutionEquilibrationTime}],Except[Null|Automatic]],
      userMethodQ && MemberQ[KeyExistsQ[userMethod, #] & /@ $SecondaryLysisOptionsWithLysisPrefix, True] && MemberQ[Cases[Lookup[userMethod, $SecondaryLysisOptionsWithLysisPrefix], Except[Missing[_,_]]], Except[Null]],
      assignedMethodQ &&MemberQ[KeyExistsQ[assignedMethod, #] & /@ $SecondaryLysisOptionsWithLysisPrefix, True] && MemberQ[Cases[Lookup[assignedMethod, $SecondaryLysisOptionsWithLysisPrefix], Except[Missing[_,_]]], Except[Null]]
    ],
    2,
    MatchQ[resolvedLysisMasterswitch, True],
    1,
    (*If reaches here, resolvedLysisMasterswitch is False, resolve to Null *)
    True,
    Null
  ];

  (*Resolve LysisSolutionTemperature*)
  resolvedLysisSolutionTemperature=Which[
    MatchQ[lysisSolutionTemperature,Except[Automatic]],
    lysisSolutionTemperature,
    userMethodQ && MatchQ[userMethodLysisSolutionTemperature,Except[Null]],
    userMethodLysisSolutionTemperature,
    assignedMethodQ && MatchQ[assignedMethodLysisSolutionTemperature,Except[Null]],
    assignedMethodLysisSolutionTemperature,
    MatchQ[resolvedLysisMasterswitch,True]&&MatchQ[lysisSolutionEquilibrationTime,Except[Null]],
    4 Celsius,
    True,
    Null
  ];

  (*Resolve LysisSolutionEquilibrationTime*)
  resolvedLysisSolutionEquilibrationTime=Which[
    MatchQ[lysisSolutionEquilibrationTime,Except[Automatic]],
    lysisSolutionEquilibrationTime,
    userMethodQ && MatchQ[userMethodLysisSolutionEquilibrationTime,Except[Null]],
    userMethodLysisSolutionEquilibrationTime,
    assignedMethodQ && MatchQ[assignedMethodLysisSolutionEquilibrationTime,Except[Null]],
    assignedMethodLysisSolutionEquilibrationTime,
    MatchQ[resolvedLysisSolutionTemperature,Null],
    Null,
    True,
    10 Minute
  ];

  (*Resolve SecondaryLysisSolutionTemperature*)
  resolvedSecondaryLysisSolutionTemperature=Which[
    MatchQ[secondaryLysisSolutionTemperature,Except[Automatic]],
    secondaryLysisSolutionTemperature,
    userMethodQ && MatchQ[userMethodSecondaryLysisSolutionTemperature,Except[Null]],
    userMethodSecondaryLysisSolutionTemperature,
    assignedMethodQ && MatchQ[assignedMethodSecondaryLysisSolutionTemperature,Except[Null]],
    assignedMethodSecondaryLysisSolutionTemperature,
    GreaterEqualQ[resolvedNumberOfLysisSteps,2]&&MatchQ[secondaryLysisSolutionEquilibrationTime,Except[Null]],
    4 Celsius,
    True,
    Null
  ];

  (*Resolve SecondaryLysisSolutionEquilibrationTime*)
  resolvedSecondaryLysisSolutionEquilibrationTime=Which[
    MatchQ[secondaryLysisSolutionEquilibrationTime,Except[Automatic]],
    secondaryLysisSolutionEquilibrationTime,
    userMethodQ && MatchQ[userMethodSecondaryLysisSolutionEquilibrationTime,Except[Null]],
    userMethodSecondaryLysisSolutionEquilibrationTime,
    assignedMethodQ && MatchQ[assignedMethodSecondaryLysisSolutionEquilibrationTime,Except[Null]],
    assignedMethodSecondaryLysisSolutionEquilibrationTime,
    MatchQ[resolvedSecondaryLysisSolutionTemperature,Null],
    Null,
    True,
    10 Minute
  ];
  (*Resolve TertiaryLysisSolutionTemperature*)
  resolvedTertiaryLysisSolutionTemperature=Which[
    MatchQ[tertiaryLysisSolutionTemperature,Except[Automatic]],
    tertiaryLysisSolutionTemperature,
    userMethodQ && MatchQ[userMethodTertiaryLysisSolutionTemperature,Except[Null]],
    userMethodTertiaryLysisSolutionTemperature,
    assignedMethodQ && MatchQ[assignedMethodTertiaryLysisSolutionTemperature,Except[Null]],
    assignedMethodTertiaryLysisSolutionTemperature,
    GreaterEqualQ[resolvedNumberOfLysisSteps,3]&&MatchQ[tertiaryLysisSolutionEquilibrationTime,Except[Null]],
    4 Celsius,
    True,
    Null
  ];

  (*Resolve TertiaryLysisSolutionEquilibrationTime*)
  resolvedTertiaryLysisSolutionEquilibrationTime=Which[
    MatchQ[tertiaryLysisSolutionEquilibrationTime,Except[Automatic]],
    tertiaryLysisSolutionEquilibrationTime,
    userMethodQ && MatchQ[userMethodTertiaryLysisSolutionEquilibrationTime,Except[Null]],
    userMethodTertiaryLysisSolutionEquilibrationTime,
    assignedMethodQ && MatchQ[assignedMethodTertiaryLysisSolutionEquilibrationTime,Except[Null]],
    assignedMethodTertiaryLysisSolutionEquilibrationTime,
    MatchQ[resolvedTertiaryLysisSolutionTemperature,Null],
    Null,
    True,
    10 Minute
  ];

  (*Output rules of preResolved lysis options*)
  {
    (*1*)LysisTime -> preResolvedLysisTime,
    (*2*)LysisTemperature -> preResolvedLysisTemperature,
    (*3*)LysisAliquot -> preResolvedLysisAliquot,
    (*4*)ClarifyLysate -> preResolvedClarifyLysate,
    (*5*)LysisAliquotContainer -> preResolvedLysisAliquotContainer,
    (*6*)ClarifiedLysateContainer -> preResolvedClarifiedLysateContainer,
    (*7*)LysisAliquotContainerLabel -> preResolvedLysisAliquotContainerLabel,
    (*8*)ClarifiedLysateContainerLabel -> preResolvedClarifiedLysateContainerLabel,
    (*9*)NumberOfLysisSteps -> resolvedNumberOfLysisSteps,
    (*10*)LysisSolutionTemperature -> resolvedLysisSolutionTemperature,
    (*11*)LysisSolutionEquilibrationTime -> resolvedLysisSolutionEquilibrationTime,
    (*12*)SecondaryLysisSolutionTemperature -> resolvedSecondaryLysisSolutionTemperature,
    (*13*)SecondaryLysisSolutionEquilibrationTime -> resolvedSecondaryLysisSolutionEquilibrationTime,
    (*14*)TertiaryLysisSolutionTemperature -> resolvedTertiaryLysisSolutionTemperature,
    (*15*)TertiaryLysisSolutionEquilibrationTime -> resolvedTertiaryLysisSolutionEquilibrationTime
  }
];

(* Helper functions -- Pre-Pre-Resolve Precipitation options *)
prePreResolvePrecipitationOptionsForExtractProtein[
  resolvedPurificationMasterswitch:ListableP[Alternatives[LiquidLiquidExtraction,Precipitation,SolidPhaseExtraction,MagneticBeadSeparation,None]],
  userInputMapThreadOptions_Association,
  userMethodQ:BooleanP,
  userMethod:<||>|PacketP[Object[Method]]|Null,
  assignedMethodQ:BooleanP,
  assignedMethod:<||>|PacketP[Object[Method]]|Null
]:=Module[
  {preResolvedPrecipitationSeparationTechnique,precipitationSeparationTechnique,userMethodPrecipitationSeparationTechnique,assignedMethodPrecipitationSeparationTechnique,
    preResolvedPrecipitationTargetPhase,precipitationTargetPhase,userMethodPrecipitationTargetPhase,
      assignedMethodPrecipitationTargetPhase,
    preResolvedPrecipitationReagent,precipitationReagent,userMethodPrecipitationReagent,assignedMethodPrecipitationReagent,
   preResolvedPrecipitationMembraneMaterial,precipitationMembraneMaterial,userMethodPrecipitationMembraneMaterial,assignedMethodPrecipitationMembraneMaterial,
    preResolvedPrecipitationPoreSize,precipitationPoreSize,userMethodPrecipitationPoreSize,assignedMethodPrecipitationPoreSize,
    preResolvedPrecipitationFilter,precipitationFilter,userMethodPrecipitationFilter,assignedMethodPrecipitationFilter,
    preResolvedPrecipitationNumberOfWashes,precipitationNumberOfWashes,userMethodPrecipitationNumberOfWashes,assignedMethodPrecipitationNumberOfWashes,
    preResolvedPrecipitationWashSolution,precipitationWashSolution,userMethodPrecipitationWashSolution,assignedMethodPrecipitationWashSolution,
    preResolvedPrecipitationResuspensionBuffer,precipitationResuspensionBuffer,userMethodPrecipitationResuspensionBuffer,assignedMethodPrecipitationResuspensionBuffer},

  (*Look up the option values*)
  {precipitationSeparationTechnique,precipitationTargetPhase,precipitationReagent,precipitationFilter,precipitationMembraneMaterial,precipitationPoreSize,precipitationNumberOfWashes, precipitationWashSolution,precipitationResuspensionBuffer} = Lookup[userInputMapThreadOptions,
    {
      PrecipitationSeparationTechnique,PrecipitationTargetPhase,PrecipitationReagent,PrecipitationFilter, PrecipitationMembraneMaterial,PrecipitationPoreSize,PrecipitationNumberOfWashes,PrecipitationWashSolution, PrecipitationResuspensionBuffer
    }];

  (*Look up the user-specified method option values.*)
  {userMethodPrecipitationSeparationTechnique,userMethodPrecipitationTargetPhase,userMethodPrecipitationReagent,userMethodPrecipitationFilter, userMethodPrecipitationMembraneMaterial,userMethodPrecipitationPoreSize,userMethodPrecipitationNumberOfWashes,userMethodPrecipitationWashSolution, userMethodPrecipitationResuspensionBuffer}=If[MatchQ[userMethod,PacketP[]],
    Lookup[userMethod,#,Null]&/@ {PrecipitationSeparationTechnique,PrecipitationTargetPhase,PrecipitationReagent,PrecipitationFilter,PrecipitationMembraneMaterial,PrecipitationPoreSize,PrecipitationNumberOfWashes, PrecipitationWashSolution, PrecipitationResuspensionBuffer},
    ConstantArray[Null,9]
  ];

  (*Lookup the values in the assigned method packet if it's not empty*)
  {assignedMethodPrecipitationSeparationTechnique,assignedMethodPrecipitationTargetPhase,assignedMethodPrecipitationReagent,assignedMethodPrecipitationFilter,assignedMethodPrecipitationMembraneMaterial,assignedMethodPrecipitationPoreSize,assignedMethodPrecipitationNumberOfWashes, assignedMethodPrecipitationWashSolution,assignedMethodPrecipitationResuspensionBuffer}=If[!MatchQ[assignedMethod,<||>|Null],
    Lookup[assignedMethod,#,Null]&/@ {PrecipitationSeparationTechnique,PrecipitationTargetPhase,PrecipitationReagent,PrecipitationFilter,PrecipitationMembraneMaterial,PrecipitationPoreSize,PrecipitationNumberOfWashes, PrecipitationWashSolution, PrecipitationResuspensionBuffer},
    (*If the assigned method packet is empty, set to nulls*)
    ConstantArray[Null,9]
  ];

  (*pre-preresolve the precipitation reagent*)
  preResolvedPrecipitationSeparationTechnique = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[precipitationSeparationTechnique, Except[Automatic]],
      precipitationSeparationTechnique,
    (*If a method is specified and it is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodPrecipitationSeparationTechnique, Except[Null]],
      userMethodPrecipitationSeparationTechnique,
    (*If a method is set by the TargetProtein and it is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodPrecipitationSeparationTechnique, Except[Null]],
      assignedMethodPrecipitationSeparationTechnique,
    MemberQ[Lookup[userInputMapThreadOptions,{PrecipitationFiltrationInstrument, PrecipitationFiltrationTechnique,
      PrecipitationFilter, PrecipitationPrefilterPoreSize, PrecipitationPrefilterMembraneMaterial,PrecipitationPoreSize, PrecipitationMembraneMaterial, PrecipitationFilterPosition, PrecipitationFilterCentrifugeIntensity, PrecipitationFiltrationPressure, PrecipitationFiltrationTime, PrecipitationFiltrateVolume}],Except[Automatic|Null]],
      Filter,
    (*If not specified and precipitation is used,*)
    MemberQ[resolvedPurificationMasterswitch,Precipitation],
      Pellet,
    True,
    (*Otherwise, set to Automatic*)
      Automatic
  ];

  (*pre-preresolve the precipitation target phase*)
  preResolvedPrecipitationTargetPhase = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[precipitationTargetPhase, Except[Automatic]],
      precipitationTargetPhase,
    (*If a method is specified and it is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodPrecipitationTargetPhase, Except[Null]],
      userMethodPrecipitationTargetPhase,
    (*If a method is set by the TargetProtein and it is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodPrecipitationTargetPhase, Except[Null]],
      assignedMethodPrecipitationTargetPhase,
    (*If not specified and precipitation is used,*)
    MemberQ[resolvedPurificationMasterswitch,Precipitation],
      Solid,
    True,
      (*Otherwise, set to Automatic*)
      Automatic
  ];
  (*pre-preresolve the precipitation reagent*)
  preResolvedPrecipitationReagent = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[precipitationReagent, Except[Automatic]],
      precipitationReagent,
    (*If a method is specified and it is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodPrecipitationReagent, Except[Null]],
      userMethodPrecipitationReagent,
    (*If a method is set by the TargetProtein and it is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodPrecipitationReagent, Except[Null]],
      assignedMethodPrecipitationReagent,
    (*If not specified and precipitation is used and targeting solid phase, use TCA*)
    MemberQ[resolvedPurificationMasterswitch,Precipitation]&&MatchQ[preResolvedPrecipitationTargetPhase,Solid],
      Model[Sample, StockSolution, "id:zGj91a7v1Lob"],(*"TCA (10%, w/v) in acetone with 2-mercaptoethanol (0.07%)"*)
    True,
    (*Otherwise, set to Automatic*)
      Automatic
  ];
  (*pre-preresolve the precipitation filter membrane material*)
  preResolvedPrecipitationMembraneMaterial =  Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[precipitationMembraneMaterial, Except[Automatic]],
      precipitationMembraneMaterial,
    (*If a method is specified and it is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodPrecipitationMembraneMaterial, Except[Null]],
      userMethodPrecipitationMembraneMaterial,
    (*If a method is set by the TargetProtein and it is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodPrecipitationMembraneMaterial, Except[Null]],
      assignedMethodPrecipitationMembraneMaterial,
    (*If filter is specified anywhere, leave it automatic*)
    MemberQ[{precipitationFilter,userMethodPrecipitationFilter,assignedMethodPrecipitationFilter},ObjectP[]],
     Automatic,
    (*If not specified and precipitation is used, resolve to default if other settings do not contradict*)
    MemberQ[resolvedPurificationMasterswitch,Precipitation]&&MatchQ[preResolvedPrecipitationSeparationTechnique,Filter],
      PTFE,(*as the metaterial of "Pierce Protein Precipitation Plate"*)
    True,
      (*We dont have a default reccomeneded or most likely we will use pellet if we are using precipitation at all. Leave it automatic just to be safe*)
     Automatic
  ];
  (*pre-preresolve the precipitation filter pore size*)
  preResolvedPrecipitationPoreSize =  Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[precipitationPoreSize, Except[Automatic]],
      precipitationPoreSize,
    (*If a method is specified and it is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodPrecipitationPoreSize, Except[Null]],
      userMethodPrecipitationPoreSize,
    (*If a method is set by the TargetProtein and it is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodPrecipitationPoreSize, Except[Null]],
      assignedMethodPrecipitationPoreSize,
    (*If filter is specified anywhere, leave it automatic*)
    MemberQ[{precipitationFilter,userMethodPrecipitationFilter,assignedMethodPrecipitationFilter},ObjectP[]],
      Automatic,
    (*If not specified and precipitation is used, resolve to default if other settings do not contradict*)
    MemberQ[resolvedPurificationMasterswitch,Precipitation]&&MatchQ[preResolvedPrecipitationSeparationTechnique,Filter]&&MatchQ[preResolvedPrecipitationMembraneMaterial,PTFE],
      0.2*Micron,(*as the pore size of "Pierce Protein Precipitation Plate"*)
    True,
    (*We dont have a default reccomeneded or most likely we will use pellet if we are using precipitation at all. Leave it automatic just to be safe*)
      Automatic
  ];
  
  (*pre-preresolve the precipitation filter*)
  preResolvedPrecipitationFilter = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[precipitationFilter, Except[Automatic]],
      precipitationFilter,
    (*If a method is specified and it is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodPrecipitationFilter, Except[Null]],
     userMethodPrecipitationFilter,
    (*If a method is set by the TargetProtein and it is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodPrecipitationFilter, Except[Null]],
      assignedMethodPrecipitationFilter,
    (*If not specified and precipitation is used, resolve to default if other settings do not contradict*)
    MemberQ[resolvedPurificationMasterswitch,Precipitation]&&MatchQ[{preResolvedPrecipitationSeparationTechnique,preResolvedPrecipitationMembraneMaterial,preResolvedPrecipitationPoreSize}, {Filter,PTFE,EqualP[0.2*Micron]}],
      Model[Container, Plate, Filter, "Pierce Protein Precipitation Plate"],(*id:Z1lqpMlMrPw9*)
    True,
    (*We dont have a default reccomeneded or most likely we will use pellet if we are using precipitation at all. Leave it automatic just to be safe*)
      Automatic
  ];

  preResolvedPrecipitationNumberOfWashes = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[precipitationNumberOfWashes, Except[Automatic]],
      precipitationNumberOfWashes,
    (*If a method is specified and it is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodPrecipitationNumberOfWashes, Except[Null]],
     userMethodPrecipitationNumberOfWashes,
    (*If a method is set by the TargetProtein and it is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodPrecipitationNumberOfWashes, Except[Null]],
      assignedMethodPrecipitationNumberOfWashes,
    (*If not specified and precipitation is used,mimick precipitation resolver*)
    MemberQ[resolvedPurificationMasterswitch,Precipitation]&&MatchQ[preResolvedPrecipitationTargetPhase,Solid],
      3,
    MemberQ[resolvedPurificationMasterswitch,Precipitation]&&MatchQ[preResolvedPrecipitationTargetPhase,Liquid],
      0,
    True,
    (*Otherwise, set to Automatic*)
      Automatic
  ];

  (*pre-preresolve wash solution*)
  preResolvedPrecipitationWashSolution = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[precipitationWashSolution, Except[Automatic]],
      precipitationWashSolution,
    (*If a method is specified and it is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodPrecipitationWashSolution, Except[Null]],
      userMethodPrecipitationWashSolution,
    (*If a method is set by the TargetProtein and it is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodPrecipitationWashSolution, Except[Null]],
      assignedMethodPrecipitationWashSolution,
    (*If not specified, precipitation is used, and we are washing *)
    MemberQ[resolvedPurificationMasterswitch,Precipitation]&&GreaterQ[preResolvedPrecipitationNumberOfWashes,0],
      Model[Sample, "id:Vrbp1jG80zno"],(*"Acetone, Reagent Grade"*)
    True,
    (*Otherwise, set to Automatic*)
      Automatic
  ];

  (*pre-preresolve the precipitation resuspension buffer*)
  preResolvedPrecipitationResuspensionBuffer = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[precipitationResuspensionBuffer, Except[Automatic]],
      precipitationResuspensionBuffer,
    (*If a method is specified and it is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodPrecipitationResuspensionBuffer, Except[Null]],
      userMethodPrecipitationResuspensionBuffer,
    (*If a method is set by the TargetProtein and it is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodPrecipitationResuspensionBuffer, Except[Null]],
      assignedMethodPrecipitationResuspensionBuffer,
    (*If not specified and precipitation is used,mimick precipitation resolver*)
    (*Because precipitated proteins are generally hard to resuspend, so we need something with detergent*)
    MemberQ[resolvedPurificationMasterswitch,Precipitation]&&MatchQ[preResolvedPrecipitationTargetPhase,Solid],
      Model[Sample, StockSolution, "id:kEJ9mqJxqNLV"],(*"RIPA Lysis Buffer with protease inhibitor cocktail"*)
    True,
    (*Otherwise, set to Automatic*)
      Automatic
  ];

  (*Return the rules of prePreResolved Precipitation options*)
  {
    PrecipitationSeparationTechnique -> preResolvedPrecipitationSeparationTechnique,
    PrecipitationTargetPhase -> preResolvedPrecipitationTargetPhase,
    PrecipitationReagent -> preResolvedPrecipitationReagent,
    PrecipitationMembraneMaterial -> preResolvedPrecipitationMembraneMaterial,
    PrecipitationPoreSize -> preResolvedPrecipitationPoreSize,
    PrecipitationFilter -> preResolvedPrecipitationFilter,
    PrecipitationNumberOfWashes -> preResolvedPrecipitationNumberOfWashes,
    PrecipitationWashSolution -> preResolvedPrecipitationWashSolution,
    PrecipitationResuspensionBuffer -> preResolvedPrecipitationResuspensionBuffer
  }
];

(* Helper functions -- Pre-Pre-Resolve SPE options *)
prePreResolveSPEOptionsForExtractProtein[
  resolvedPurificationMasterswitch:ListableP[Alternatives[LiquidLiquidExtraction,Precipitation,SolidPhaseExtraction,MagneticBeadSeparation,None]],
  userInputMapThreadOptions_Association,
  userMethodQ:BooleanP,
  userMethod:<||>|PacketP[Object[Method]]|Null,
  assignedMethodQ:BooleanP,
  assignedMethod:<||>|PacketP[Object[Method]]|Null,
  targetProtein:ObjectP[]|All|Null,
  cellType:CellTypeP|Unspecified|Automatic|Null
]:=Module[
  {
    preResolvedSolidPhaseExtractionSeparationMode,solidPhaseExtractionSeparationMode, userMethodSolidPhaseExtractionSeparationMode, assignedMethodSolidPhaseExtractionSeparationMode,
    preResolvedSolidPhaseExtractionSorbent,solidPhaseExtractionSorbent, userMethodSolidPhaseExtractionSorbent, assignedMethodSolidPhaseExtractionSorbent,
    preResolvedSolidPhaseExtractionCartridge,solidPhaseExtractionCartridge, userMethodSolidPhaseExtractionCartridge, assignedMethodSolidPhaseExtractionCartridge,
    preResolvedSolidPhaseExtractionStrategy,solidPhaseExtractionStrategy,userMethodSolidPhaseExtractionStrategy,
    assignedMethodSolidPhaseExtractionStrategy,
    preResolvedSolidPhaseExtractionWashSolution,solidPhaseExtractionWashSolution,userMethodSolidPhaseExtractionWashSolution,assignedMethodSolidPhaseExtractionWashSolution,
    preResolvedSecondarySolidPhaseExtractionWashSolution,secondarySolidPhaseExtractionWashSolution,userMethodSecondarySolidPhaseExtractionWashSolution,assignedMethodSecondarySolidPhaseExtractionWashSolution,
    preResolvedTertiarySolidPhaseExtractionWashSolution,tertiarySolidPhaseExtractionWashSolution,userMethodTertiarySolidPhaseExtractionWashSolution,assignedMethodTertiarySolidPhaseExtractionWashSolution,
    preResolvedSolidPhaseExtractionElutionSolution,solidPhaseExtractionElutionSolution,userMethodSolidPhaseExtractionElutionSolution,assignedMethodSolidPhaseExtractionElutionSolution
  },

  (*Look up the option values*)
  {solidPhaseExtractionSeparationMode, solidPhaseExtractionSorbent, solidPhaseExtractionCartridge,solidPhaseExtractionStrategy,solidPhaseExtractionWashSolution,secondarySolidPhaseExtractionWashSolution, tertiarySolidPhaseExtractionWashSolution,solidPhaseExtractionElutionSolution
  }=Lookup[userInputMapThreadOptions,
    {
      SolidPhaseExtractionSeparationMode, SolidPhaseExtractionSorbent, SolidPhaseExtractionCartridge,SolidPhaseExtractionStrategy,SolidPhaseExtractionWashSolution,SecondarySolidPhaseExtractionWashSolution,TertiarySolidPhaseExtractionWashSolution,SolidPhaseExtractionElutionSolution
    }
  ];
  (*Look up the user-specified method option values.*)
  {userMethodSolidPhaseExtractionSeparationMode, userMethodSolidPhaseExtractionSorbent, userMethodSolidPhaseExtractionCartridge, userMethodSolidPhaseExtractionStrategy,
    userMethodSolidPhaseExtractionWashSolution,userMethodSecondarySolidPhaseExtractionWashSolution,userMethodTertiarySolidPhaseExtractionWashSolution,userMethodSolidPhaseExtractionElutionSolution
  }=If[MatchQ[userMethod,PacketP[]],
    Lookup[userMethod,#,Null]&/@ {SolidPhaseExtractionSeparationMode, SolidPhaseExtractionSorbent, SolidPhaseExtractionCartridge,SolidPhaseExtractionStrategy,SolidPhaseExtractionWashSolution,SecondarySolidPhaseExtractionWashSolution,TertiarySolidPhaseExtractionWashSolution,SolidPhaseExtractionElutionSolution},
    ConstantArray[Null,8]
  ];

  (*Lookup the values in the assigned method packet if it's not empty*)
  {assignedMethodSolidPhaseExtractionSeparationMode, assignedMethodSolidPhaseExtractionSorbent,assignedMethodSolidPhaseExtractionCartridge,assignedMethodSolidPhaseExtractionStrategy,
    assignedMethodSolidPhaseExtractionWashSolution,assignedMethodSecondarySolidPhaseExtractionWashSolution,assignedMethodTertiarySolidPhaseExtractionWashSolution,assignedMethodSolidPhaseExtractionElutionSolution}=If[!MatchQ[assignedMethod,<||>|Null],
    Lookup[assignedMethod,#,Null]&/@ {SolidPhaseExtractionSeparationMode, SolidPhaseExtractionSorbent, SolidPhaseExtractionCartridge,SolidPhaseExtractionStrategy,SolidPhaseExtractionWashSolution,SecondarySolidPhaseExtractionWashSolution,TertiarySolidPhaseExtractionWashSolution,SolidPhaseExtractionElutionSolution},
    (*If the assigned method packet is empty, set to nulls*)
    ConstantArray[Null,8]
  ];

  preResolvedSolidPhaseExtractionSeparationMode=Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[solidPhaseExtractionSeparationMode, Except[Automatic]],
    solidPhaseExtractionSeparationMode,
    (*If the cartridge is specified by the user, set to Automatic*)
    MatchQ[solidPhaseExtractionCartridge, ObjectP[{Model[Container, Plate, Filter], Object[Container, Plate, Filter]}]],
    Automatic,
    (*If solidPhaseExtractionSorbent is set, set to the separation mode of the solidPhaseExtractionSorbent*)
    MatchQ[solidPhaseExtractionSorbent, SolidPhaseExtractionFunctionalGroupP],
    Switch[
      solidPhaseExtractionSorbent,
      SizeExclusion,SizeExclusion,
      ProteinG, Affinity,
      (*If solidPhaseExtractionSorbent is set but does not match any of the above sorbencts, solidPhaseExtractionSeparationMode is set to Automatic and resolved by the SPE resolver. *)
      _, Automatic
    ],
    (*If a method is specified and SolidPhaseExtractionSeparationMode is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodSolidPhaseExtractionSeparationMode, Except[Null]],
    userMethodSolidPhaseExtractionSeparationMode,
    (*If a method is set by the TargetProtein and SolidPhaseExtractionSeparationMode is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodSolidPhaseExtractionSeparationMode, Except[Null]],
    assignedMethodSolidPhaseExtractionSeparationMode,
    (*Here, this option is not specified by user or method. If SPE is to be performed (SPE is in resolvedPurificationMasterswitch), resolve the separation mode based on TargetProtein. If TargetProtein is All, use IonExchange, if it is a model molecule, use Affinity. *)
    MemberQ[resolvedPurificationMasterswitch,SolidPhaseExtraction]&&MatchQ[targetProtein,All],
    SizeExclusion,
    MemberQ[resolvedPurificationMasterswitch,SolidPhaseExtraction]&&MatchQ[targetProtein,IdentityModelP],
    Affinity,
    True,
    Automatic
  ];

  preResolvedSolidPhaseExtractionSorbent=Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[solidPhaseExtractionSorbent, Except[Automatic]],
    solidPhaseExtractionSorbent,
    (*If a method is specified and SolidPhaseExtractionSorbent is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodSolidPhaseExtractionSorbent, Except[Null]],
    userMethodSolidPhaseExtractionSorbent,
    (*If a method is set by the TargetProtein and SolidPhaseExtractionSorbent is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodSolidPhaseExtractionSorbent, Except[Null]],
    assignedMethodSolidPhaseExtractionSorbent,
    (*If SolidPhaseExtractionCartridge is specified, set to the sorbent in the SolidPhaseExtractionCartridge*)
    MatchQ[solidPhaseExtractionCartridge, ObjectP[{Model[Container], Object[Container]}]],
    Switch[
      solidPhaseExtractionCartridge,
      ObjectP[Model[Container, Plate, Filter, "id:xRO9n3BGnqDz"]], Silica,(*"QiaQuick 96well"*)
      ObjectP[Model[Container, Plate, Filter, "id:M8n3rx0ZkwB5"]],Null,(*"Zeba 7K 96-well Desalt Spin Plate". It does not have information.*)
      ObjectP[Model[Container, Plate, Filter, "id:eGakldaE6bY1"]],ProteinG,(*"Pierce ProteinG Spin Plate for IgG Screening"*)
      ObjectP[Model[Container, Plate, Filter, "id:8qZ1VWZeAw8p"]],Affinity,(*"HisPur Ni-NTA Spin Plates"*)
      (*If SolidPhaseExtractionCartridge is specified but does not match any of the above objects, solidPhaseExtractionSorbent is set to Automatic and resolved by the SPE resolver. *)
      _, Automatic
    ],
    (*If SPE is to be performed and an Object[Method] is to be used, but somehow the sorbent is not specified, then we can leave it Automatic to have SPE pull it from the cartridge that is to be prepreresolved*)
    Or[userMethodQ,assignedMethodQ]&& MemberQ[resolvedPurificationMasterswitch,SolidPhaseExtraction],
    Automatic,
    (*Here, this option is not specified by user or method. If SPE is to be performed (SPE is in resolvedPurificationMasterswitch or there is SPE options specified), resolve the separation mode based on cell type for the case when Target protein is a model molecule. If CellType is anything Microbial, use Affinity. Is CellType is Mamallian, use ProteinG*)
    MemberQ[resolvedPurificationMasterswitch,SolidPhaseExtraction]&&MatchQ[targetProtein,IdentityModelP]&&MatchQ[cellType,MicrobialCellTypeP],
    Affinity,
    MemberQ[resolvedPurificationMasterswitch,SolidPhaseExtraction]&&MatchQ[targetProtein,IdentityModelP]&&MatchQ[cellType,Mammalian],
    ProteinG,
    True,
      Automatic
  ];

  preResolvedSolidPhaseExtractionCartridge=Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[solidPhaseExtractionCartridge, Except[Automatic]],
    solidPhaseExtractionCartridge,
    (*If a method is specified and SolidPhaseExtractionCartridge is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodSolidPhaseExtractionCartridge, Except[Null]],
    userMethodSolidPhaseExtractionCartridge,
    (*If a method is set by the TargetProtein and SolidPhaseExtractionCartridge is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodSolidPhaseExtractionCartridge, Except[Null]],
    assignedMethodSolidPhaseExtractionCartridge,

    (*If separation mode and sorbent are preresolved, set the cartridge based on their values*)
    MatchQ[{preResolvedSolidPhaseExtractionSeparationMode,preResolvedSolidPhaseExtractionSorbent},{SeparationModeP,SolidPhaseExtractionFunctionalGroupP|Automatic|Null}],
    Switch[
      {preResolvedSolidPhaseExtractionSeparationMode,preResolvedSolidPhaseExtractionSorbent},
      (*Need to make sure all pre-resolved plates are compatible with both Pressure manifold and centrifuge. If in future we have plate measured or new default plates incompatible with teh manifold, we will need to add in pre-resolved SPE technique or instrument.*)
      {Affinity, ProteinG|Automatic},
      Model[Container, Plate, Filter, "id:eGakldaE6bY1"],(*Model[Container, Plate, Filter, "Pierce ProteinG Spin Plate for IgG Screening"]*)
      {Affinity, Affinity|Automatic},
      Model[Container, Plate, Filter, "id:8qZ1VWZeAw8p"],(*Model[Container, Plate, Filter, "HisPur Ni-NTA Spin Plates"]*)
      {SizeExclusion, Automatic|Null|SizeExclusion},
      Model[Container, Plate, Filter, "id:M8n3rx0ZkwB5"],(*"Zeba 7K 96-well Desalt Spin Plate".*)
      (*If solidPhaseExtractionSorbent is set but does not match any of the above sorbents, solidPhaseExtractionCartridge is set to Automatic and resolved by the SPE resolver. *)
      _,
      Automatic
    ],
    True,
    Automatic
  ];

  preResolvedSolidPhaseExtractionStrategy = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[solidPhaseExtractionStrategy, Except[Automatic]],
     solidPhaseExtractionStrategy,
    (*If a method is specified and SolidPhaseExtractionStrategy is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodSolidPhaseExtractionStrategy, Except[Null]],
      userMethodSolidPhaseExtractionStrategy,
    (*If a method is set by the TargetProtein and SolidPhaseExtractionStrategy is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodSolidPhaseExtractionStrategy, Except[Null]],
      assignedMethodSolidPhaseExtractionStrategy,
    (*If we are using SPE but the user directly specify the elution solution as Null, we have negative*)
    MemberQ[resolvedPurificationMasterswitch,SolidPhaseExtraction]&&MatchQ[solidPhaseExtractionElutionSolution,Null],
      Negative,
    (*If not specified and we are using SPE, positive it is*)
    MemberQ[resolvedPurificationMasterswitch,SolidPhaseExtraction],
      Positive,
    (*Otherwise, leave it automatic just to be safe*)
    True,
      Automatic
  ];
  
  (*Prepreresolve the wash buffer*)
  preResolvedSolidPhaseExtractionWashSolution = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[solidPhaseExtractionWashSolution, Except[Automatic]],
      solidPhaseExtractionWashSolution,
    (*If a method is specified and SolidPhaseExtractionWashSolution is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodSolidPhaseExtractionWashSolution, Except[Null]],
      userMethodSolidPhaseExtractionWashSolution,
    (*If a method is set by the TargetProtein and SolidPhaseExtractionWashSolution is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodSolidPhaseExtractionWashSolution, Except[Null]],
      assignedMethodSolidPhaseExtractionWashSolution,
    (*otherwise, if it is automatic and not speicifed by method, we resolve from wash switch mimicking the SPE resolver. If strategy is Positive, Wash switch will resove to True, and use default buffer*)
    MatchQ[preResolvedSolidPhaseExtractionStrategy,Positive],
      Model[Sample, StockSolution, "id:4pO6dMWvnA0X"],(*Filtered PBS, Sterile*)
    (*If strategy is negative, Wash switch will resove to false, no buffer*)
    True,
      Null
  ];

  preResolvedSecondarySolidPhaseExtractionWashSolution=Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[secondarySolidPhaseExtractionWashSolution, Except[Automatic]],
      secondarySolidPhaseExtractionWashSolution,
    (*If a method is specified and SecondarySolidPhaseExtractionWashSolution is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodSecondarySolidPhaseExtractionWashSolution, Except[Null]],
     userMethodSecondarySolidPhaseExtractionWashSolution,
    (*If a method is set by the TargetProtein and SecondarySolidPhaseExtractionWashSolution is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodSecondarySolidPhaseExtractionWashSolution, Except[Null]],
     assignedMethodSecondarySolidPhaseExtractionWashSolution,
    (*if it is not specified and if we were doing a first wash, do a second wash using the same solution*)
    MatchQ[preResolvedSolidPhaseExtractionWashSolution,Except[Null]],
      preResolvedSolidPhaseExtractionWashSolution,
    (*otherwise there's no first wash so no second wash*)
    True,
      Null];

  preResolvedTertiarySolidPhaseExtractionWashSolution=Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[tertiarySolidPhaseExtractionWashSolution, Except[Automatic]],
      tertiarySolidPhaseExtractionWashSolution,
    (*If a method is specified and TertiarySolidPhaseExtractionWashSolution is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodTertiarySolidPhaseExtractionWashSolution, Except[Null]],
      userMethodTertiarySolidPhaseExtractionWashSolution,
    (*If a method is set by the TargetProtein and TertiarySolidPhaseExtractionWashSolution is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodTertiarySolidPhaseExtractionWashSolution, Except[Null]],
     assignedMethodTertiarySolidPhaseExtractionWashSolution,
    (*if it is not specified and if we were doing a second wash, do a third wash using the same solution*)
    MatchQ[preResolvedSecondarySolidPhaseExtractionWashSolution,Except[Null]],
      preResolvedSecondarySolidPhaseExtractionWashSolution,
    (*otherwise there's no first wash so no second wash*)
    True,
     Null];
  
  preResolvedSolidPhaseExtractionElutionSolution = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[solidPhaseExtractionElutionSolution, Except[Automatic]],
      solidPhaseExtractionElutionSolution,
    (*If a method is specified and SolidPhaseExtractionElutionSolution is specified by the method, set to method-specified value*)
    userMethodQ && MatchQ[userMethodSolidPhaseExtractionElutionSolution, Except[Null]],
      userMethodSolidPhaseExtractionElutionSolution,
    (*If a method is set by the TargetProtein and SolidPhaseExtractionElutionSolution is specified by the method, set to method-specified value*)
    assignedMethodQ && MatchQ[assignedMethodSolidPhaseExtractionElutionSolution, Except[Null]],
      assignedMethodSolidPhaseExtractionElutionSolution,
    (*otherwise, if it is automatic and not speicifed by method, we resolve from elution switch mimicking the SPE resolver. If strategy is Positive, Elution switch will resove to True, and use default buffer*)
    MatchQ[preResolvedSolidPhaseExtractionStrategy,Positive],
      Model[Sample, StockSolution, "50 mM Glycine pH 2.8, sterile filtered"],(*"id:eGakldadjlEe" "50 mM Glycine pH 2.8, sterile filtered"*)
    (*If strategy is negative or SPE is not used, Elution switch will resove to false, no buffer*)
    True,
      Null
  ];

  (*Return the rules of prePreResolved SPE options*)
  {
    SolidPhaseExtractionSeparationMode -> preResolvedSolidPhaseExtractionSeparationMode,
    SolidPhaseExtractionSorbent -> preResolvedSolidPhaseExtractionSorbent,
    SolidPhaseExtractionCartridge -> preResolvedSolidPhaseExtractionCartridge,
    SolidPhaseExtractionStrategy -> preResolvedSolidPhaseExtractionStrategy,
    SolidPhaseExtractionWashSolution -> preResolvedSolidPhaseExtractionWashSolution,
    SecondarySolidPhaseExtractionWashSolution -> preResolvedSecondarySolidPhaseExtractionWashSolution,
    TertiarySolidPhaseExtractionWashSolution -> preResolvedTertiarySolidPhaseExtractionWashSolution,
    SolidPhaseExtractionElutionSolution -> preResolvedSolidPhaseExtractionElutionSolution
  }
];

(* ::Subsection::Closed::*)

(* ::Subsection:: *)
(* resolveExtractProteinWorkCell *)

DefineOptions[resolveExtractProteinWorkCell,
  SharedOptions:>{
    ExperimentExtractProtein,
    CacheOption,
    SimulationOption,
    OutputOption
  }
];

resolveExtractProteinWorkCell[
  myContainersAndSamples:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container]}]],
  myOptions:OptionsPattern[]
]:=Module[{cache, simulation, mySamples, myContainers, samplePackets},

  (* Lookup our supplied cache and simulation. *)
  cache = Lookup[ToList@myOptions,Cache,{}];
  simulation=Lookup[ToList@myOptions,Simulation,Null];

  mySamples = Cases[myContainersAndSamples, ObjectP[Object[Sample]], Infinity];
  myContainers = Cases[myContainersAndSamples, ObjectP[Object[Container]], Infinity];

  samplePackets = Download[mySamples, Packet[CellType], Cache -> cache, Simulation -> simulation];

  (* NOTE: due to the mechanism by which the primitive framework resolves WorkCell, we can't just resolve it on our own and then tell the framework what to use. So, we resolve using the CellType option if specified, or the CellType field in the input sample(s). *)
  Which[
    (* If the user specifies the microbioSTAR for RoboticInstrument, resolve the WorkCell to match *)
    KeyExistsQ[myOptions, RoboticInstrument] && MatchQ[Lookup[myOptions, RoboticInstrument], Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]],
    {microbioSTAR},
    (* If the user specifies the microbioSTAR for RoboticInstrument, resolve the WorkCell to match *)
    KeyExistsQ[myOptions, RoboticInstrument] && MatchQ[Lookup[myOptions, RoboticInstrument], Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]],
    {bioSTAR},
    (* If the user specifies any microbial (Bacterial, Yeast, or Fungal) cell types using the CellType option, resolve to microbioSTAR *)
    KeyExistsQ[myOptions, CellType] && MemberQ[Lookup[myOptions, CellType], MicrobialCellTypeP],
    {microbioSTAR},
    (* If the user specifies only nonmicrobial (Mammalian, Insect, or Plant) cell types using the CellType option, resolve to bioSTAR *)
    KeyExistsQ[myOptions, CellType] && MatchQ[Lookup[myOptions, CellType], {NonMicrobialCellTypeP..}],
    {bioSTAR},
    (*If CellType field for any input Sample objects is microbial (Bacterial, Yeast, or Fungal), then the microbioSTAR is used. *)
    MemberQ[Lookup[samplePackets, CellType], MicrobialCellTypeP],
    {microbioSTAR},
    (*If CellType field for all input Sample objects is not microbial (Mammalian, Plant, or Insect), then the bioSTAR is used. *)
    MatchQ[Lookup[samplePackets, CellType], {NonMicrobialCellTypeP..}],
    {bioSTAR},
    (*Otherwise, use the microbioSTAR.*)
    True,
    {microbioSTAR}
  ]
];

(* ::Subsection::Closed:: *)
(*resolveExperimentExtractProteinOptions*)

DefineOptions[
  resolveExperimentExtractProteinOptions,
  Options:>{HelperOutputOption, CacheOption, SimulationOption}
];


resolveExperimentExtractProteinOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentExtractProteinOptions]]:=Module[
  {
    (*Option Setup and Cache Setup*)
    outputSpecification, output, gatherTests, messages, cache, listedOptions, currentSimulation, optionPrecisions, roundedExperimentOptions,

    (*Precision Tests*)
    optionPrecisionTests, mapThreadFriendlyOptions,

    (*Downloads*)
    sampleFields, samplePacketFields, samplePackets, sampleModelFields, sampleModelPacketFields, sampleModelPackets, methodPacketFields, methodPackets, allMethods,allMethodPackets,containerObjectFields, sampleContainerPackets, containerObjectPacketFields, sampleContainerModelPackets, containerModelFields, containerModelPackets, containerModelPacketFields, containerModelFromObjectPackets, cacheBall, fastCacheBall,

    (*Input Validation*)
    discardedInvalidInputs, discardedTest, deprecatedSamplePackets, deprecatedInvalidInputs, deprecatedTest, solidMediaInvalidInputs, solidMediaTest, invalidInputs,

    (*General*)
    resolvedRoboticInstrument,allowedWorkCells,resolvedWorkCell,resolvedMethods,targetProteins,resolvedTargetProteins,resolvedExtractedProteinLabel,preResolvedRoundedExperimentOptions,preResolvedPreCorrectionMapThreadFriendlyOptions,preResolvedMapThreadFriendlyOptions,

    (*Lysing*)
    (*Options that were pre-resolved*)
    resolvedLyses,preResolvedCellTypes, preResolvedLysisTimes, preResolvedLysisTemperatures, preResolvedLysisAliquots, preResolvedClarifyLysates, resolvedNumberOfLysisStepss,preResolvedLysisAliquotContainers, preResolvedLysisAliquotContainerLabels,preResolvedClarifiedLysateContainers, preResolvedClarifiedLysateContainerLabels,
    resolvedLysisSolutionTemperatures, resolvedLysisSolutionEquilibrationTimes,
    resolvedSecondaryLysisSolutionTemperatures, resolvedSecondaryLysisSolutionEquilibrationTimes,
    resolvedTertiaryLysisSolutionTemperatures, resolvedTertiaryLysisSolutionEquilibrationTimes,
    preResolvedLysisOptions,
    

    (*Purification Options*)
    resolvedPurifications,
    preResolvedSolidPhaseExtractionSeparationModes,preResolvedSolidPhaseExtractionSorbents,preResolvedSolidPhaseExtractionCartridges,preResolvedSolidPhaseExtractionStrategies, preResolvedSolidPhaseExtractionWashSolutions, preResolvedSecondarySolidPhaseExtractionWashSolutions, preResolvedTertiarySolidPhaseExtractionWashSolutions,preResolvedSolidPhaseExtractionElutionSolutions,
    preResolvedPrecipitationSeparationTechniques, preResolvedPrecipitationTargetPhases, preResolvedPrecipitationReagents, preResolvedPrecipitationFilters,preResolvedPrecipitationMembraneMaterials, preResolvedPrecipitationPoreSizes,preResolvedPrecipitationNumberOfWashess, preResolvedPrecipitationWashSolutions, preResolvedPrecipitationResuspensionBuffers,
     workingSamples, containerOutBeforePurification,
    optionsWithResolvedPurification,preCorrectionMapThreadFriendlyOptionsWithResolvedPurification,mapThreadFriendlyOptionsWithResolvedPurification,preResolvedPurificationOptions,

    (*Container Out*)
    userSpecifiedLabels,preResolvedContainersOutWithWellsRemoved,preResolvedExtractedProteinContainerLabel,preResolvedContainerOutWell, preResolvedIndexedContainerOut,

    (*Post-resolution*)
    resolvedPostProcessingOptions,  resolvedOptions, methodValidityTest, invalidExtractionMethodOptions, solidPhaseExtractionConflictingOptionsTests, solidPhaseExtractionConflictingOptions,mbsMethodsConflictingOptionsTest,mbsMethodsConflictingOptions,

    (*Conflicting Options Tests*)
    mapThreadFriendlyResolvedOptions,
    methodTargetProteinMismatchedOptions,methodTargetConflictingOptionsTest,
    noExtractProteinStepSamples,noExtractProteinStepTest,
    invalidOptions,

    (*Lysis*)
    repeatedLysisOptions, repeatedLysisOptionsTest,
    unlysedCellsOptions,unlysedCellsOptionsTest,
    conflictingLysisStepSolutionEquilibrationOptions,conflictingLysisStepSolutionEquilibrationOptionsTest,
    lysisSolutionEquilibrationTimeTemperatureMismatchOptions,lysisSolutionEquilibrationTimeTemperatureMismatchOptionsTest,

    (*Purification Option*)
    nullTargetProteinSamples,nullTargetProteinTest,purificationTests, purificationInvalidOptions

  },


  (* - SETUP USER SPECIFIED OPTIONS AND CACHE - *)

  (* Determine the requested output format of this function. *)
  outputSpecification = OptionValue[Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];
  messages=!gatherTests;

  (* Fetch our cache from the parent function. *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];

  (* ToList our options. *)
  listedOptions = ToList[myOptions];

  (* Lookup our simulation. *)
  currentSimulation = Lookup[ToList[myResolutionOptions],Simulation];

  (* - RESOLVE PREPARATION OPTION - *)
  (* Usually, we resolve our Preparation option here, but since we can only do Preparation -> Robotic, there is no need to. *)

  (* - DOWNLOAD - *)
  (* Search for all ExtractProtein methods *)
  allMethods = Search[Object[Method,Extraction,Protein]];
  (* Download fields from samples that are required.*)
  (* NOTE: All fields downloaded below should already be included in the cache passed down to us by the main function. *)
  sampleFields = DeleteDuplicates[Flatten[{Name, Status, Model, Composition, CellType, Living, CultureAdhesion, Volume, Analytes, Density, Container, Position, SamplePreparationCacheFields[Object[Sample]]}]];
  samplePacketFields = Packet@@sampleFields;
  sampleModelFields = DeleteDuplicates[Flatten[{Name, Composition, Density, Deprecated}]];
  sampleModelPacketFields = Packet@@sampleModelFields;
  methodPacketFields = Packet[All];
  containerObjectFields = {Contents, Model, Name};
  containerObjectPacketFields = Packet@@containerObjectFields;
  containerModelFields = {VolumeCalibrations, MaxCentrifugationForce, Footprint, MaxVolume, Positions, Name};
  containerModelPacketFields = Packet@@containerModelFields;

  {
    (*1*)samplePackets,
    (*2*)sampleModelPackets,
    (*3*)methodPackets,
    (*4*)allMethodPackets,
    (*5*)sampleContainerPackets,
    (*6*)sampleContainerModelPackets,
    (*7*)containerModelPackets,
    (*8*)containerModelFromObjectPackets
  } = Download[
    {
      (*1*)mySamples,
      (*2*)mySamples,
      (*3*)Replace[Lookup[myOptions,Method], {Custom|Automatic -> Null}, 2],
      (*4*)Cases[allMethods,ObjectP[Object[Method,Extraction,Protein]]],
      (*5*)mySamples,
      (*6*)mySamples,
      (*7*)DeleteDuplicates@Flatten[{Cases[Lookup[myOptions,ContainerOut], ObjectP[Model[Container]]]}],
      (*8*)DeleteDuplicates@Flatten[{Cases[Lookup[myOptions,ContainerOut], ObjectP[Object[Container]]]}]
    },
    {
      (*1*){samplePacketFields},
      (*2*){Packet[Model[sampleModelFields]]},
      (*3*){methodPacketFields},
      (*4*){methodPacketFields},
      (*5*){Packet[Container[containerObjectFields]]},
      (*6*){Packet[Container[Model][containerModelFields]]},
      (*7*){containerModelPacketFields},
      (*8*){containerObjectPacketFields, Packet[Model[containerModelFields]]}
    },
    Cache -> cache,
    Simulation -> currentSimulation
  ];

  {
    samplePackets,
    sampleModelPackets,
    methodPackets,
    allMethodPackets,
    sampleContainerPackets,
    sampleContainerModelPackets,
    containerModelPackets,
    containerModelFromObjectPackets
  }=Flatten/@{
    samplePackets,
    sampleModelPackets,
    methodPackets,
    allMethodPackets,
    sampleContainerPackets,
    sampleContainerModelPackets,
    containerModelPackets,
    containerModelFromObjectPackets
  };

  cacheBall = FlattenCachePackets[{
    samplePackets,
    sampleModelPackets,
    methodPackets,
    allMethodPackets,
    sampleContainerPackets,
    sampleContainerModelPackets,
    containerModelPackets,
    containerModelFromObjectPackets
  }];

  (* Make fast association to look up things from cache quickly.*)
  (* inherit everything from the simulation too *)
  fastCacheBall = makeFastAssocFromCache[FlattenCachePackets[{cacheBall, Lookup[FirstOrDefault[currentSimulation, <||>], Packets, {}]}]];
  (* - INPUT VALIDATION CHECKS - *)

  (*-- DISCARDED SAMPLE CHECK --*)

  {discardedInvalidInputs, discardedTest} = checkDiscardedSamples[samplePackets,messages, Cache -> cache];


  (* -- DEPRECATED MODEL CHECK -- *)

  (* Get the samples from samplePackets that are discarded. *)
  deprecatedSamplePackets = Select[Flatten[sampleModelPackets], If[MatchQ[#,Except[Null]],MatchQ[Lookup[#, Deprecated], True]]&];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  deprecatedInvalidInputs = Lookup[deprecatedSamplePackets, Object, {}];

  (* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
  If[Length[deprecatedInvalidInputs] > 0 && messages,
    Message[Error::DeprecatedModels, ObjectToString[deprecatedInvalidInputs, Cache -> cache]]
  ];

  (* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
  deprecatedTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[deprecatedInvalidInputs] == 0,
        Nothing,
        Test["The input samples " <> ObjectToString[deprecatedInvalidInputs, Cache -> cache] <> " do not have deprecated models:", True, False]
      ];
      passingTest = If[Length[deprecatedInvalidInputs] == Length[mySamples],
        Nothing,
        Test["The input samples " <> ObjectToString[Complement[mySamples, deprecatedInvalidInputs], Cache -> cache] <> " do not have deprecated models:", True, True]
      ];
      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* -- SOLID MEDIA CHECK -- *)

  {solidMediaInvalidInputs, solidMediaTest} = checkSolidMedia[samplePackets, messages, Cache -> cacheBall];


  (* - OPTION PRECISION CHECKS - *)

  (* Define the option precisions that need to be checked. *)
  (* NOTE: Don't check CentrifugeIntensity precision here because each centrifuge has a different precision. ExperimentCentrifuge will check this for us. *)

  optionPrecisions = Sequence@@@{$CellLysisOptionsPrecisions,
    $ExtractionLiquidLiquidSharedOptionsPrecisions,
    $PrecipitationSharedOptionsPrecisions,
    $ExtractionSolidPhaseSharedOptionsPrecisions,
    $ExtractionMagneticBeadSharedOptionsPrecisions,
    (*ExtractProtein option precisions*)
    {
      {LysisSolutionTemperature,  10^-1 Celsius},
      {LysisSolutionEquilibrationTime, 1 Second},
      {SecondaryLysisSolutionTemperature,  10^-1 Celsius},
      {SecondaryLysisSolutionEquilibrationTime, 1 Second},
      {TertiaryLysisSolutionTemperature,  10^-1 Celsius},
      {TertiaryLysisSolutionEquilibrationTime, 1 Second}
    }
  };

  (* There are still a few options that we need to check the precisions of though. *)
  {roundedExperimentOptions,optionPrecisionTests} = If[gatherTests,
    (*If we are gathering tests *)
    RoundOptionPrecision[Association@@listedOptions,optionPrecisions[[All,1]],optionPrecisions[[All,2]],Output->{Result,Tests}],
    (* Otherwise *)
    {RoundOptionPrecision[Association@@listedOptions,optionPrecisions[[All,1]],optionPrecisions[[All,2]]],{}}
  ];


  (* - RESOLVE EXPERIMENT OPTIONS - *)

  (* Convert our options into a MapThread friendly version. *)
  preResolvedPreCorrectionMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractProtein,roundedExperimentOptions];

  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  mapThreadFriendlyOptions = Experiment`Private`mapThreadFriendlySolventAdditions[roundedExperimentOptions, preResolvedPreCorrectionMapThreadFriendlyOptions, LiquidLiquidExtractionSolventAdditions];

  (* -- RESOLVE NON-MAPTHREAD, NON-CONTAINER OPTIONS -- *)
  allowedWorkCells = resolveExtractProteinWorkCell[mySamples, listedOptions];

  resolvedWorkCell = Which[
    (*choose user selected workcell if the user selected one *)
    MatchQ[Lookup[myOptions, WorkCell], Except[Automatic]],
      Lookup[myOptions, WorkCell],
    (*If user-set RoboticInstrument, then use set value.*)
    MatchQ[Lookup[myOptions, RoboticInstrument], Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]],(* Model[Instrument, LiquidHandler, "bioSTAR"] *)
      bioSTAR,
    MatchQ[Lookup[myOptions, RoboticInstrument], Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]],(* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
      microbioSTAR,
    (*choose the first workcell that is presented *)
    MatchQ[allowedWorkCells, ListableP[WorkCellP]],
      First[allowedWorkCells],
    (* failsafe, choose microbioSTAR otherwise *)
    True,
     microbioSTAR
  ];

  (* Resolve RoboticInstrument *)
  resolvedRoboticInstrument = Which[
    (*If user-set, then use set value.*)
    MatchQ[Lookup[myOptions, RoboticInstrument], Except[Automatic]],
    Lookup[myOptions, RoboticInstrument],
    (*If resolvedWorkCell is set to bioSTAR, use bioSTAR*)
    MatchQ[resolvedWorkCell, bioSTAR],
    Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"],(* Model[Instrument, LiquidHandler, "bioSTAR"] *)
    (*If resolvedWorkCell is set to microbioSTAR, use microbioSTAR*)
    MatchQ[resolvedWorkCell, microbioSTAR],
    Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"],(* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
    (*If CellType option for all Samples is not microbial (Mammalian, Plant, or Insect) (set or from the field in their sample object), then the bioSTAR is used.*)
    Or[MatchQ[Lookup[myOptions, CellType], {NonMicrobialCellTypeP..}], MatchQ[Lookup[samplePackets, CellType], {NonMicrobialCellTypeP..}]],
    Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"],(* Model[Instrument, LiquidHandler, "bioSTAR"] *)
    (*Otherwise, use the microbioSTAR.*)
    True,
    Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"](* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
  ];

  (* -- LABELS -- *)

  (* Get all of the user specified labels. *)
  userSpecifiedLabels=DeleteDuplicates@Cases[
    Flatten@Lookup[
      listedOptions,
      {
        ExtractedProteinLabel, ExtractedProteinContainerLabel,
        LysisAliquotContainerLabel,PreLysisSupernatantLabel, PreLysisSupernatantContainerLabel,PostClarificationPelletLabel,ClarifiedLysateContainerLabel,
        ImpurityLayerLabel,ImpurityLayerContainerLabel,PrecipitatedSampleLabel,PrecipitatedSampleLabel,UnprecipitatedSampleLabel, UnprecipitatedSampleContainerLabel,
        MagneticBeadSeparationAnalyteAffinityLabel,MagneticBeadAffinityLabel,MagneticBeadSeparationPreWashCollectionContainerLabel, MagneticBeadSeparationEquilibrationCollectionContainerLabel,
      MagneticBeadSeparationLoadingCollectionContainerLabel, MagneticBeadSeparationWashCollectionContainerLabel, MagneticBeadSeparationSecondaryWashCollectionContainerLabel, MagneticBeadSeparationTertiaryWashCollectionContainerLabel, MagneticBeadSeparationQuaternaryWashCollectionContainerLabel, MagneticBeadSeparationQuinaryWashCollectionContainerLabel, MagneticBeadSeparationSenaryWashCollectionContainerLabel, MagneticBeadSeparationSeptenaryWashCollectionContainerLabel, MagneticBeadSeparationElutionCollectionContainerLabel
      }
    ],
    _String
  ];

  (* Resolve the output label and container output label. *)
  resolvedExtractedProteinLabel=resolveExtractedProteinSampleLabel[mySamples, mapThreadFriendlyOptions, ExtractedProteinLabel, "extracted protein sample",userSpecifiedLabels,currentSimulation];

  (* Remove any wells from user-specified container out inputs according to their widget patterns. *)
  preResolvedContainersOutWithWellsRemoved = preResolveContainersOutAndRemoveWellsForProteinExperiments[roundedExperimentOptions,ContainerOut];

  (* Resolve the container labels based on the information that we have prior to simulation. *)
  preResolvedExtractedProteinContainerLabel=preResolveProteinContainerLabel[preResolvedContainersOutWithWellsRemoved,roundedExperimentOptions,Lookup[listedOptions, ExtractedProteinContainerLabel],ExtractedProteinContainerLabel,"extracted protein sample container",userSpecifiedLabels,currentSimulation];

  (* Pre-resolve the ContainerOutWell and the indexed version of the container out (without a well). *)
  (* Needed for threading user-specified ContainerOut into unit operations for simulation/protocol.  *)
  {preResolvedContainerOutWell, preResolvedIndexedContainerOut} = preResolveContainerOutWellAndIndexedContainer[preResolvedContainersOutWithWellsRemoved,roundedExperimentOptions,ContainerOut, fastCacheBall];

  (* Add in pre-resolved labels into options and make mapThreadFriendly for further resolutions. *)
  preResolvedRoundedExperimentOptions = Merge[
    {
      roundedExperimentOptions,
      <|
        ExtractedProteinLabel -> resolvedExtractedProteinLabel,
        ExtractedProteinContainerLabel -> preResolvedExtractedProteinContainerLabel
      |>
    },
    Last
  ];

  (* Convert our options into a MapThread friendly version. *)
  preResolvedPreCorrectionMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractProtein,preResolvedRoundedExperimentOptions];

  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  preResolvedMapThreadFriendlyOptions = Experiment`Private`mapThreadFriendlySolventAdditions[preResolvedRoundedExperimentOptions, preResolvedPreCorrectionMapThreadFriendlyOptions, LiquidLiquidExtractionSolventAdditions];

  (* -- RESOLVE MAPTHREAD OPTIONS -- *)

  {
    (*1*)resolvedTargetProteins,
    (*2*)resolvedLyses,
    (*3*)preResolvedCellTypes,
    (*4*)resolvedMethods,
    (*5*)resolvedPurifications,
    (*6*)preResolvedLysisTimes,
    (*7*)preResolvedLysisTemperatures,
    (*8*)preResolvedLysisAliquots,
    (*9*)preResolvedClarifyLysates,
    (*10*)preResolvedLysisAliquotContainers,
    (*11*)preResolvedLysisAliquotContainerLabels,
    (*12*)preResolvedClarifiedLysateContainers,
    (*13*)preResolvedClarifiedLysateContainerLabels,
    (*14*)resolvedNumberOfLysisStepss,
    (*15*)resolvedLysisSolutionTemperatures,
    (*16*)resolvedLysisSolutionEquilibrationTimes,
    (*17*)resolvedSecondaryLysisSolutionTemperatures,
    (*18*)resolvedSecondaryLysisSolutionEquilibrationTimes,
    (*19*)resolvedTertiaryLysisSolutionTemperatures,
    (*20*)resolvedTertiaryLysisSolutionEquilibrationTimes,
    (*21*)preResolvedSolidPhaseExtractionSeparationModes,
    (*22*)preResolvedSolidPhaseExtractionSorbents,
    (*23*)preResolvedSolidPhaseExtractionCartridges,
    (*24*)preResolvedSolidPhaseExtractionStrategies,
    (*25*)preResolvedSolidPhaseExtractionWashSolutions,
    (*26*)preResolvedSecondarySolidPhaseExtractionWashSolutions,
    (*27*)preResolvedTertiarySolidPhaseExtractionWashSolutions,
    (*28*)preResolvedSolidPhaseExtractionElutionSolutions,
    (*29*)preResolvedPrecipitationSeparationTechniques,
    (*30*)preResolvedPrecipitationTargetPhases,
    (*31*)preResolvedPrecipitationReagents,
    (*32*)preResolvedPrecipitationFilters,
    (*33*)preResolvedPrecipitationMembraneMaterials,
    (*34*)preResolvedPrecipitationPoreSizes,
    (*35*)preResolvedPrecipitationNumberOfWashess,
    (*36*)preResolvedPrecipitationWashSolutions,
    (*37*)preResolvedPrecipitationResuspensionBuffers
  } = Transpose@MapThread[
    Function[{samplePacket, methodPacket, myMapThreadOptions},
      Module[
        {
          (*General*)
          targetProtein,userMethodTargetProtein,resolvedTargetProtein,
          method,resolvedMethod,
          containerOut,extractProteinContainerLabel,
          methodSpecifiedQ, assignedMethodPacket, useMapThreadMethodQ, useAssignedMethodQ,
          (*Lyse*)
          lyse,userMethodLyse,resolvedLyse,
          cellType,userMethodCellType,preResolvedCellType,

          (*Multiple lysis steps solution temperature options*)
          lysisSolutionTemperature,lysisSolutionEquilibrationTime,
          secondaryLysisSolutionTemperature,secondaryLysisSolutionEquilibrationTime,
          tertiaryLysisSolutionTemperature,tertiaryLysisSolutionEquilibrationTime,

          preResolvedLysisOptionRules,

          (*Purification*)
          purification,userMethodPurification,assignedMethodPurification,preresolvedPurification,resolvedPurification,prePreResolvedSPEOptionRules,prePreResolvedPrecipitationOptionRules
        },

        (*Look up the option values*)
        {
          (*General*)
          targetProtein,method,containerOut,extractProteinContainerLabel,
          (*Lysis general*)
          lyse,cellType,lysisSolutionTemperature,lysisSolutionEquilibrationTime,
          secondaryLysisSolutionTemperature,secondaryLysisSolutionEquilibrationTime,
          tertiaryLysisSolutionTemperature,tertiaryLysisSolutionEquilibrationTime,
          (*Purification*)
          purification
        }=Lookup[myMapThreadOptions,
          {
            (*General*)
            TargetProtein, Method,ContainerOut,ExtractedProteinContainerLabel,
            (*Lysis*)
            Lyse, CellType,LysisSolutionTemperature,LysisSolutionEquilibrationTime,
            SecondaryLysisSolutionTemperature,SecondaryLysisSolutionEquilibrationTime,
            TertiaryLysisSolutionTemperature,TertiaryLysisSolutionEquilibrationTime,
            (*Purification*)
            Purification
          }
        ];
        (*Look up the user-specified method option values, these are used prior to resolving Method.*)
        {userMethodTargetProtein,userMethodLyse,userMethodCellType, userMethodPurification}=If[MatchQ[methodPacket,PacketP[]],
          Lookup[methodPacket,#,Null]&/@ {TargetProtein,Lyse,CellType,Purification},
          ConstantArray[Null,4]
        ];

        (* Setup a boolean to determine if there is a method set or not. *)
        methodSpecifiedQ = MatchQ[method, ObjectP[Object[Method, Extraction, Protein]]];
        useMapThreadMethodQ = MatchQ[Lookup[myMapThreadOptions, Method], Except[Automatic|Custom]];

        (* --- METHOD OPTION RESOLUTION --- *)
        (*Resolve TargetProtein first, becuase we will use it to pick Method if Method is to be resolved*)
        resolvedTargetProtein=Which[
          (*If TargetProtein is specified by the user, accept it*)
          MatchQ[targetProtein,Except[Automatic]],
            targetProtein,
          (*If Method is specified by the user, and the TargetProtein field is populated *)
          methodSpecifiedQ&&!MatchQ[userMethodTargetProtein,Null],
            userMethodTargetProtein,
          (*Otherwise, TargetProtein is not specified by the or the user picked Method, resolve to All*)
          True,
            All
        ];
        (*Resolve lyse before Method, because we will use it to pick Method if Lyse if required*)
        resolvedLyse=Which[
          (*If Lyse is specified by the user, accept it*)
          MatchQ[lyse,Except[Automatic]],
            lyse,
          (*If Method is specified by the user, and the TargetProtein field is populated *)
          methodSpecifiedQ&&!MatchQ[userMethodLyse,Null],
            userMethodLyse,
          (*If any Lysis options are specified by the user, set Lyse to True. Dropping TargetCellularComponent and NumberOfLysisReplicates from the list since they arent options in ExtractProtein.*)
          (*Also drop CellType since it can be used to inform previously extracted sample type*)
          MemberQ[Join[Lookup[myMapThreadOptions, ToExpression[Keys[KeyDrop[Options[CellLysisOptions], {Key["TargetCellularComponent"], Key["NumberOfLysisReplicates"],Key["CellType"]}]]]],{tertiaryLysisSolutionTemperature,tertiaryLysisSolutionEquilibrationTime,secondaryLysisSolutionTemperature,secondaryLysisSolutionEquilibrationTime,lysisSolutionTemperature,lysisSolutionEquilibrationTime}], Except[Automatic | Null]],
            True,
          (*If the Living field in the sample is True, set Lyse to True*)
          MatchQ[Lookup[samplePacket, Living],True],
            True,
          (*Otherwise set Lyse to False*)
          True,
            False
        ];
        (*Resolve cell type before Method because we will use it to pick Method if lyse is needed.*)
        preResolvedCellType=Which[
          (* Use the user-specified values, if any *)
          MatchQ[cellType, Except[Automatic]],
            cellType,
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ&&MatchQ[userMethodCellType,Except[Null]],
            userMethodCellType,
          (* Use the value of the CellType field in Object[Sample], if any *)
          MatchQ[Lookup[samplePacket, CellType], CellTypeP],
            Lookup[samplePacket, CellType],
          (* If neither of the above apply, leave it as Automatic to send down to ExperimentLyseCell resolver. (warning will be thrown for unknown cell type from sample) *)
          True,
            Automatic
        ];

        (*PrePre-resolve purification it is needed to search for method*)
        preresolvedPurification = Which[
          (*If specified by the user, set to user-specified value*)
          MatchQ[purification, Except[Automatic]],
            purification,
          (*If a method is specified and Purification is specified by the method, set to method-specified value*)
          useMapThreadMethodQ && MatchQ[userMethodPurification, Except[Null]],
            userMethodPurification,
          (* Are any LLE, Precipitation, SPE, or MBS options set? If not, set it to Automatic for now to have method resolver pick.*)
          !Or@@(
            MemberQ[ToList[Lookup[myMapThreadOptions,#,Null]],Except[ListableP[Automatic|Null|False]]]
                &)/@Keys[Join[$LLEPurificationOptionMap, $PrecipitationSharedOptionMap, $SPEPurificationOptionMap, $MBSPurificationOptionMap]],
            Automatic,
          (*If there is some options specified, Add them in the order. *)
          True,
          {
            (* Are any of the LLE options set? *)
            Module[{lleSpecifiedQ},
              lleSpecifiedQ=Or@@Map[
                MemberQ[ToList[Lookup[myMapThreadOptions,#,Null]],Except[ListableP[Automatic|Null|False]]]&,
                Keys[$LLEPurificationOptionMap]
              ];
              If[lleSpecifiedQ,
                LiquidLiquidExtraction,
                Nothing
              ]
            ],
            (* Are any of the Precipitation options set? *)
            Module[{precipitationSpecifiedQ},
              precipitationSpecifiedQ=Or@@Map[
                MemberQ[ToList[Lookup[myMapThreadOptions,#,Null]],Except[ListableP[Automatic|Null|False]]]&,
                Keys[$PrecipitationSharedOptionMap]
              ];

              If[precipitationSpecifiedQ,
                Precipitation,
                Nothing
              ]
            ],
            (* Are any of the SPE options set? *)
            Module[{speSpecifiedQ},
              speSpecifiedQ=Or@@Map[
                MemberQ[ToList[Lookup[myMapThreadOptions,#,Null]],Except[ListableP[Automatic|Null|False]]]&,
                Keys[$SPEPurificationOptionMap]
              ];
              If[speSpecifiedQ,
                SolidPhaseExtraction,
                Nothing
              ]
            ],
            (* Are any of the MBS options set? *)
            Module[{mbsSpecifiedQ},
              mbsSpecifiedQ=Or@@Map[
                MemberQ[ToList[Lookup[myMapThreadOptions,#,Null]],Except[ListableP[Automatic|Null|False]]]&,
                Keys[$MBSPurificationOptionMap]
              ];

              If[mbsSpecifiedQ,
                MagneticBeadSeparation,
                Nothing
              ]
            ]
          }
        ];

        (* Resolve Method based on the resolved TargetProtein, Lyse, and CellType*)
        resolvedMethod=If[
          (*If specified by the user, set to user-specified value*)
          MatchQ[method, Except[Automatic]],
          method,
          (*Otherwise Method is Automatic, resolve it*)
          Module[{methodFilterRules,availableMethodPackets},
            (*If there is any method-field option that has user specified values, add that to the rules for screening methods*)
            methodFilterRules = If[MatchQ[Lookup[myMapThreadOptions,#],Except[Automatic]],
              # -> Lookup[myMapThreadOptions,#],
              Nothing
            ]&/@$ExtractProteinMethodFields;
            (* Replace resolved masterswicthes.*)
            methodFilterRules = ReplaceRule[
              methodFilterRules,
              Flatten[{
                {
                  (*Non-Null fields*)
                  Lyse -> resolvedLyse
                },
                Switch[resolvedTargetProtein,
                  ObjectP[],{TargetProtein -> ObjectP[resolvedTargetProtein]},
                  All, {TargetProtein -> All},
                  _, {}
                ],
                If[MatchQ[preResolvedCellType, CellTypeP],
                  {CellType -> preResolvedCellType},
                  {}
                ],

                Which[
                  (*If Purification is user specified, it has to match the specified*)
                  MatchQ[purification, Except[Automatic]],
                    {Purification -> Alternatives[ListableP]},
                  (*If Purification is preresolved based on options given. The method purification need to at least include the purifications with options specified*)
                  MatchQ[preresolvedPurification, Except[Automatic|Null]],
                    {Purification -> {___, OrderlessPatternSequence[Sequence@@preresolvedPurification], ___}},
                  True,
                    {}
                ]
              }],
              Append->True
            ];

            availableMethodPackets=Cases[allMethodPackets,KeyValuePattern[methodFilterRules]];

            (*If availableMethods is not empty, use the first found, otherwise set method to Custom*)
            If[!MatchQ[availableMethodPackets,{}],
              FirstCase[availableMethodPackets[Object],ObjectP[Object[Method,Extraction,Protein]],Custom],
              Custom
            ]
          ]
        ];

        (*if the method was assigned based on user-specified TargetProtein, then fetch the packet from the downloaded default methods in the fastAssoc*)
        {assignedMethodPacket, useAssignedMethodQ} = If[
          And[
            MatchQ[Lookup[myMapThreadOptions, Method], Automatic],
            MatchQ[resolvedMethod, ObjectP[Object[Method, Extraction, Protein]]]
          ],
          {
            fetchPacketFromFastAssoc[resolvedMethod, fastCacheBall],
            True
          },
          {
            <||>,
            False
          }
        ];

        (*Lookup the values in the assigned method packet if it's not empty*)
        assignedMethodPurification = If[!MatchQ[assignedMethodPacket,<||>],
          Lookup[assignedMethodPacket,Purification,Null],
          (*If the assigned method packet is empty, set to nulls*)
          Null
        ];

        (*Pre-resolve purification it is needed to determine where to integrate ContainerOut*)
        resolvedPurification = Which[
          (*If specified by the user, set to user-specified value*)
          MatchQ[purification, Except[Automatic]],
           purification,
          (*If a method is specified and Purification is specified by the method, set to method-specified value*)
          useMapThreadMethodQ && MatchQ[userMethodPurification, Except[Null]],
           userMethodPurification,
          (*If a method is set by the TargetProtein and Purification is specified by the method, set to method-specified value*)
          useAssignedMethodQ && MatchQ[assignedMethodPurification, Except[Null]],
           assignedMethodPurification,
          (* Are any LLE, Precipitation, SPE, or MBS options set? If not, then defaults a SolidPhaseExtraction if resolvedTargetProtein is a Model[Molecule], otherwise resolvedTargetProtein is All, purification defaults to a Precipitation.*)
          !Or@@(
            MemberQ[ToList[Lookup[myMapThreadOptions,#,Null]],Except[ListableP[Automatic|Null|False]]]
                &)/@Keys[Join[$LLEPurificationOptionMap, $PrecipitationSharedOptionMap, $SPEPurificationOptionMap, $MBSPurificationOptionMap]],
            Which[
              MatchQ[resolvedTargetProtein,IdentityModelP],
               {SolidPhaseExtraction},
              MatchQ[resolvedTargetProtein,All],
                {Precipitation},
              True,
                None
            ],
          (*If there is some options specified, use the result from purification prepreresolver*)
          True,
          preresolvedPurification
        ];

        (*Call helper function to preResolve lysis options*)
        preResolvedLysisOptionRules = preResolveLysisOptionsForExtractProtein[resolvedLyse,myMapThreadOptions,useMapThreadMethodQ,methodPacket,useAssignedMethodQ,assignedMethodPacket,resolvedPurification];

        prePreResolvedSPEOptionRules = prePreResolveSPEOptionsForExtractProtein[resolvedPurification,myMapThreadOptions,useMapThreadMethodQ,methodPacket,useAssignedMethodQ,assignedMethodPacket,resolvedTargetProtein,preResolvedCellType];

        prePreResolvedPrecipitationOptionRules = prePreResolvePrecipitationOptionsForExtractProtein[resolvedPurification,myMapThreadOptions,useMapThreadMethodQ,methodPacket,useAssignedMethodQ,assignedMethodPacket];

        (*MBS options are preresolved with customizations in shared presolver*)
        (*LLE is less likely to be used and I don't have better defaults*)

        (*Return the resolved and preResolved options*)
        {
          (*1*)resolvedTargetProtein,
          (*2*)resolvedLyse,
          (*3*)preResolvedCellType,
          (*4*)resolvedMethod,
          (*5*)resolvedPurification,
          (*6*)Lookup[preResolvedLysisOptionRules,LysisTime],
          (*7*)Lookup[preResolvedLysisOptionRules,LysisTemperature],
          (*8*)Lookup[preResolvedLysisOptionRules,LysisAliquot],
          (*9*)Lookup[preResolvedLysisOptionRules,ClarifyLysate],
          (*10*)Lookup[preResolvedLysisOptionRules,LysisAliquotContainer],
          (*11*)Lookup[preResolvedLysisOptionRules,LysisAliquotContainerLabel],
          (*12*)Lookup[preResolvedLysisOptionRules,ClarifiedLysateContainer],
          (*13*)Lookup[preResolvedLysisOptionRules,ClarifiedLysateContainerLabel],
          (*14*)Lookup[preResolvedLysisOptionRules,NumberOfLysisSteps],
          (*15*)Lookup[preResolvedLysisOptionRules,LysisSolutionTemperature],
          (*16*)Lookup[preResolvedLysisOptionRules,LysisSolutionEquilibrationTime],
          (*17*)Lookup[preResolvedLysisOptionRules,SecondaryLysisSolutionTemperature],
          (*18*)Lookup[preResolvedLysisOptionRules,SecondaryLysisSolutionEquilibrationTime],
          (*19*)Lookup[preResolvedLysisOptionRules,TertiaryLysisSolutionTemperature],
          (*20*)Lookup[preResolvedLysisOptionRules,TertiaryLysisSolutionEquilibrationTime],
          (*21*)Lookup[prePreResolvedSPEOptionRules,SolidPhaseExtractionSeparationMode],
          (*22*)Lookup[prePreResolvedSPEOptionRules,SolidPhaseExtractionSorbent],
          (*23*)Lookup[prePreResolvedSPEOptionRules,SolidPhaseExtractionCartridge],
          (*24*)Lookup[prePreResolvedSPEOptionRules,SolidPhaseExtractionStrategy],
          (*25*)Lookup[prePreResolvedSPEOptionRules,SolidPhaseExtractionWashSolution],
          (*26*)Lookup[prePreResolvedSPEOptionRules,SecondarySolidPhaseExtractionWashSolution],
          (*27*)Lookup[prePreResolvedSPEOptionRules,TertiarySolidPhaseExtractionWashSolution],
          (*28*)Lookup[prePreResolvedSPEOptionRules,SolidPhaseExtractionElutionSolution],
          (*29*)Lookup[prePreResolvedPrecipitationOptionRules,PrecipitationSeparationTechnique],
          (*30*)Lookup[prePreResolvedPrecipitationOptionRules,PrecipitationTargetPhase],
          (*31*)Lookup[prePreResolvedPrecipitationOptionRules,PrecipitationReagent],
          (*32*)Lookup[prePreResolvedPrecipitationOptionRules,PrecipitationFilter],
          (*33*)Lookup[prePreResolvedPrecipitationOptionRules,PrecipitationMembraneMaterial],
          (*34*)Lookup[prePreResolvedPrecipitationOptionRules,PrecipitationPoreSize],
          (*35*)Lookup[prePreResolvedPrecipitationOptionRules,PrecipitationNumberOfWashes],
          (*36*)Lookup[prePreResolvedPrecipitationOptionRules,PrecipitationWashSolution],
          (*37*)Lookup[prePreResolvedPrecipitationOptionRules,PrecipitationResuspensionBuffer]
        }
      ]
    ],
    {samplePackets, methodPackets, preResolvedMapThreadFriendlyOptions}
  ];

  (* -- RESOLVE LYSIS OPTIONS -- *)

  (*Prep options for use in ExperimentLyseCells by incorporating lysis container out values and*)
  (*the resolved robotic instrument.*)
  preResolvedLysisOptions = {
    CellType -> preResolvedCellTypes,
    LysisTime -> preResolvedLysisTimes,
    LysisTemperature -> preResolvedLysisTemperatures,
    LysisAliquot -> preResolvedLysisAliquots,
    ClarifyLysate -> preResolvedClarifyLysates,
    LysisAliquotContainer -> preResolvedLysisAliquotContainers,
    ClarifiedLysateContainer -> preResolvedClarifiedLysateContainers,
    LysisAliquotContainerLabel -> preResolvedLysisAliquotContainerLabels,
    ClarifiedLysateContainerLabel -> preResolvedClarifiedLysateContainerLabels,
    NumberOfLysisSteps -> resolvedNumberOfLysisStepss,
    LysisSolutionTemperature -> resolvedLysisSolutionTemperatures,
    LysisSolutionEquilibrationTime -> resolvedLysisSolutionEquilibrationTimes,
    SecondaryLysisSolutionTemperature -> resolvedSecondaryLysisSolutionTemperatures,
    SecondaryLysisSolutionEquilibrationTime -> resolvedSecondaryLysisSolutionEquilibrationTimes,
    TertiaryLysisSolutionTemperature -> resolvedTertiaryLysisSolutionTemperatures,
    TertiaryLysisSolutionEquilibrationTime -> resolvedTertiaryLysisSolutionEquilibrationTimes
  };

  (* Add resolved purification option to existing option sets. *)
  optionsWithResolvedPurification = ReplaceRule[
    Normal[roundedExperimentOptions, Association],
    {
      Purification -> ToList[resolvedPurifications],
      Method -> resolvedMethods,
      SolidPhaseExtractionSeparationMode -> preResolvedSolidPhaseExtractionSeparationModes,
      SolidPhaseExtractionSorbent -> preResolvedSolidPhaseExtractionSorbents,
      SolidPhaseExtractionCartridge -> preResolvedSolidPhaseExtractionCartridges,
      SolidPhaseExtractionStrategy -> preResolvedSolidPhaseExtractionStrategies,
      SolidPhaseExtractionWashSolution ->preResolvedSolidPhaseExtractionWashSolutions,
      SecondarySolidPhaseExtractionWashSolution ->preResolvedSecondarySolidPhaseExtractionWashSolutions,
      TertiarySolidPhaseExtractionWashSolution ->preResolvedTertiarySolidPhaseExtractionWashSolutions,
      SolidPhaseExtractionElutionSolution -> preResolvedSolidPhaseExtractionElutionSolutions,
      PrecipitationSeparationTechnique -> preResolvedPrecipitationSeparationTechniques,
      PrecipitationTargetPhase -> preResolvedPrecipitationTargetPhases,
      PrecipitationReagent -> preResolvedPrecipitationReagents,
      PrecipitationMembraneMaterial -> preResolvedPrecipitationMembraneMaterials,
      PrecipitationPoreSize -> preResolvedPrecipitationPoreSizes,
      PrecipitationFilter -> preResolvedPrecipitationFilters,
      PrecipitationNumberOfWashes -> preResolvedPrecipitationNumberOfWashess,
      PrecipitationWashSolution -> preResolvedPrecipitationWashSolutions,
      PrecipitationResuspensionBuffer -> preResolvedPrecipitationResuspensionBuffers
    }
  ];

  preCorrectionMapThreadFriendlyOptionsWithResolvedPurification = OptionsHandling`Private`mapThreadOptions[ExperimentExtractProtein, Association[optionsWithResolvedPurification]];

  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  mapThreadFriendlyOptionsWithResolvedPurification = Experiment`Private`mapThreadFriendlySolventAdditions[optionsWithResolvedPurification, preCorrectionMapThreadFriendlyOptionsWithResolvedPurification, LiquidLiquidExtractionSolventAdditions];

  (* Pre-resolve purification options. *)
  preResolvedPurificationOptions = preResolvePurificationSharedOptions[mySamples, optionsWithResolvedPurification, mapThreadFriendlyOptionsWithResolvedPurification, TargetCellularComponent -> resolvedTargetProteins/.Alternatives[All,Null]->TotalProtein,Cache->cacheBall,Simulation->currentSimulation];

  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions,Sterile->True];

  (* Overwrite our rounded options with our resolved options.*)
  resolvedOptions=ReplaceRule[
    Normal[preResolvedRoundedExperimentOptions, Association],
    Flatten[{
      (*General Options*)
      RoboticInstrument -> resolvedRoboticInstrument,
      WorkCell -> resolvedWorkCell,
      (*Method, Lysis, and Purification Options*)
      Method -> resolvedMethods,
      Lyse -> resolvedLyses,
      TargetProtein->resolvedTargetProteins,
      Purification -> ToList[resolvedPurifications],
      preResolvedLysisOptions,
      resolvedPostProcessingOptions,
      preResolvedPurificationOptions
    }]
  ];

  (* -- CONFLICTING OPTIONS CHECK -- *)

  (*Get map thread friendly resolved options for use in options checks*)
  mapThreadFriendlyResolvedOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractProtein, resolvedOptions];
  
  (* --- General Conflicting Options --- *)
  (*check if the specified method can extract the TargetProtein*)
  methodTargetProteinMismatchedOptions = MapThread[
    Function[{sample, method, targetProtein, index},
      Module[{methodTargetProtein},

        methodTargetProtein = If[
          MatchQ[method, ObjectP[Object[Method, Extraction, Protein]]],
          Lookup[fetchPacketFromFastAssoc[method, fastCacheBall], TargetProtein],
          Unspecified
        ];

        Which[
          MatchQ[{targetProtein, method}, {_, Custom}],
          Nothing,
          MatchQ[{targetProtein, method}, {_, Except[Custom | ObjectP[Object[Method, Extraction, Protein]]]}],
          {sample, method, targetProtein, index},
          (*Target field could be All or Model[Molecule]. If resolved TargetProtein does not match the one specified in Method, output error*)
          !MatchQ[targetProtein, Alternatives[methodTargetProtein,ObjectP[methodTargetProtein]]],
          {sample, method, targetProtein, index},
          True,
          Nothing
        ]
      ]
    ],
    {mySamples, resolvedMethods, resolvedTargetProteins, Range[Length[mySamples]]}
  ];

  If[Length[methodTargetProteinMismatchedOptions] > 0 && messages,
    Message[
      Warning::MethodTargetProteinMismatch,
      ObjectToString[methodTargetProteinMismatchedOptions[[All, 1]], Cache -> cache],
      methodTargetProteinMismatchedOptions[[All, 4]],
      methodTargetProteinMismatchedOptions[[All, 3]],
      methodTargetProteinMismatchedOptions[[All, 2]]
    ];
  ];

  methodTargetConflictingOptionsTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = methodTargetProteinMismatchedOptions[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Warning["The sample(s) "<>ObjectToString[affectedSamples, Cache -> cache]<>"have a method that is suitable for extraction of the specified target protein:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Warning["The sample(s) "<>ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache]<>"have a method that is suitable for extraction of the specified target protein:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* There should be at least one step in the extraction process (lysis or any of the four purification techniques) specified (error) *)
  noExtractProteinStepSamples = MapThread[
    Function[{sample, lyse, purification, index},
      If[
        And[
          MatchQ[lyse, False],
          MatchQ[purification, (None | Null)]
        ],
        {sample, index},
        Nothing
      ]
    ],
    {mySamples, resolvedLyses, resolvedPurifications, Range[Length[mySamples]]}
  ];

  If[Length[noExtractProteinStepSamples]>0 && messages,
    Message[
      Error::NoExtractProteinStepsSet,
      ObjectToString[noExtractProteinStepSamples[[All,1]], Cache -> cache],
      noExtractProteinStepSamples[[All,2]]
    ];
  ];

  noExtractProteinStepTest=If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = noExtractProteinStepSamples[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " have at least one step (Lysis, Purification) set in order to extract protein from the sample:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " have at least one step (Lysis,  Purification) set in order to extract protein from the sample:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (*check if Lyse is not set to False when the Living field in Object[Sample] is set to False (Warning)*)
  repeatedLysisOptions = MapThread[
    Function[{sample, lyse, index},
      If[
        !MatchQ[lyse, False] && MatchQ[Lookup[fetchPacketFromFastAssoc[sample, fastCacheBall], Living],False],
        {sample,index},
        Nothing
      ]
    ],
    {mySamples, resolvedLyses, Range[Length[mySamples]]}
  ];

  If[Length[repeatedLysisOptions] > 0 && messages,
    Message[
      Warning::RepeatedLysis,
      ObjectToString[repeatedLysisOptions[[All, 1]], Cache -> cache],
      repeatedLysisOptions[[All, 2]]
    ];
  ];

  repeatedLysisOptionsTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = repeatedLysisOptions[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Warning["The sample(s) "<>ObjectToString[affectedSamples, Cache -> cache]<>"have Lyse set to False if the Living field is set to False:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Warning["The sample(s) "<>ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache]<>"have Lyse set to False if the Living field is set to False:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (*check if Lyse is not set to true when the Living field in Object[Sample] is set to True (Warning)*)
  unlysedCellsOptions = MapThread[
    Function[{sample, lyse, index},
      If[
        !MatchQ[lyse, True] && MatchQ[Lookup[fetchPacketFromFastAssoc[sample, fastCacheBall], Living],True],
        {sample,index},
        Nothing
      ]
    ],
    {mySamples, resolvedLyses, Range[Length[mySamples]]}
  ];

  If[Length[unlysedCellsOptions] > 0 && messages,
    Message[
      Warning::UnlysedCellsInput,
      ObjectToString[unlysedCellsOptions[[All, 1]], Cache -> cache],
      unlysedCellsOptions[[All, 2]]
    ];
  ];

  unlysedCellsOptionsTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = unlysedCellsOptions[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Warning["The sample(s) "<>ObjectToString[affectedSamples, Cache -> cache]<>"have Lyse set to True if the Living field is set to True:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Warning["The sample(s) "<>ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache]<>"have Lyse set to True if the Living field is set to True:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (*Check if lysis solution equilibration time and temperature options are in conflict with Lyse and NumberOfLysisSteps settings. These are for protein experiment only, so they are not check by the shared error checking*)
  conflictingLysisStepSolutionEquilibrationOptions=MapThread[
    Function[{sample,index,lyse,numberOfSteps,primaryTemperature,primaryEquilibrationTime,secondaryTemperature,secondaryEquilibrationTime,tertiaryTemperature,tertiaryEquilibrationTime},
      Module[{primaryLysisConflictingOptions,secondaryLysisConflictingOptions,tertiaryLysisConflictingOptions,totalConflictingOptions},
        primaryLysisConflictingOptions=If[
          (*If temperature is Ambient or Null or equilibration time is Null but lyse is False*)
          And[
            Or[
              MatchQ[primaryTemperature,Except[Ambient|Null]],
              MatchQ[primaryEquilibrationTime,Except[Null]]
            ],
            MatchQ[lyse,False]
          ],
          (*Add options to conflicting options*)
          {Lyse->lyse,LysisSolutionTemperature->primaryTemperature,LysisSolutionEquilibrationTime->primaryEquilibrationTime},
          (*Otherwise no conflicting options*)
          Nothing
        ];
        secondaryLysisConflictingOptions=If[
          (*If temperature is Ambient or Null or equilibration time is Null but NumberOfLysisSteps is less than 2*)
          And[
            Or[
              MatchQ[secondaryTemperature,Except[Ambient|Null]],
              MatchQ[secondaryEquilibrationTime,Except[Null]]
            ],
            LessQ[numberOfSteps,2]
          ],
          (*Add options to conflicting options*)
          {NumberOfLysisSteps->numberOfSteps,SecondaryLysisSolutionTemperature->secondaryTemperature,SecondaryLysisSolutionEquilibrationTime->secondaryEquilibrationTime},
          (*Otherwise no conflicting options*)
          Nothing
        ];
        tertiaryLysisConflictingOptions=If[
          (*If temperature is Ambient or Null or equilibration time is Null but NumberOfLysisSteps is less than 2*)
          And[
            Or[
              MatchQ[tertiaryTemperature,Except[Ambient|Null]],
              MatchQ[tertiaryEquilibrationTime,Except[Null]]
            ],
            LessQ[numberOfSteps,3]
          ],
          (*Add options to conflicting options*)
          {NumberOfLysisSteps->numberOfSteps,TertiaryLysisSolutionTemperature->tertiaryTemperature,TertiaryLysisSolutionEquilibrationTime->tertiaryEquilibrationTime},
          (*Otherwise no conflicting options*)
          Nothing
        ];
        (*Join them together*)
        totalConflictingOptions=Flatten[{primaryLysisConflictingOptions,secondaryLysisConflictingOptions,tertiaryLysisConflictingOptions}];
        (*If totalConflictingOptions is not empty, output the sample, index, and conflicting options, otherwise output nothing*)
        If[Length[totalConflictingOptions]>0,
          {sample,index,Keys@totalConflictingOptions,Values@totalConflictingOptions},
          Nothing]
      ]
    ],
    {
      mySamples,
      Range[Length[mySamples]],
      resolvedLyses,
      resolvedNumberOfLysisStepss,
      resolvedLysisSolutionTemperatures,
      resolvedLysisSolutionEquilibrationTimes,
      resolvedSecondaryLysisSolutionTemperatures,
      resolvedSecondaryLysisSolutionEquilibrationTimes,
      resolvedTertiaryLysisSolutionTemperatures,
      resolvedTertiaryLysisSolutionEquilibrationTimes
    }
  ];
  If[Length[conflictingLysisStepSolutionEquilibrationOptions]>0 && messages,
    Message[
      Error::ConflictingLysisStepSolutionEquilibration,
      ObjectToString[conflictingLysisStepSolutionEquilibrationOptions[[All,1]], Cache -> cache],
      conflictingLysisStepSolutionEquilibrationOptions[[All,2]],
      conflictingLysisStepSolutionEquilibrationOptions[[All,3]],
      conflictingLysisStepSolutionEquilibrationOptions[[All,4]]
    ];
  ];
  conflictingLysisStepSolutionEquilibrationOptionsTest=If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = conflictingLysisStepSolutionEquilibrationOptions[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " do not have lysis solution (including secondary and tertiary) temperature and equilibration time options in conflict with lyse and the number of lysis steps:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " do not have lysis solution (including secondary and tertiary) temperature and equilibration time options in conflict with lyse and the number of lysis steps:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (*Check if lysis solution equilibration time and temperature options are are mismatched.*)
  lysisSolutionEquilibrationTimeTemperatureMismatchOptions=MapThread[
    Function[{sample,index,primaryTemperature,primaryEquilibrationTime,secondaryTemperature,secondaryEquilibrationTime,tertiaryTemperature,tertiaryEquilibrationTime},
      Module[{primaryLysisConflictingOptions,secondaryLysisConflictingOptions,tertiaryLysisConflictingOptions,totalConflictingOptions},
        primaryLysisConflictingOptions=If[
          (*If temperature is Null but equilibration time is a time larger than 0, Or the other way, temperature is not Ambient or Null, but equilibration time is null or zero*)
         Or[
           MatchQ[primaryTemperature,Null]&&GreaterQ[primaryEquilibrationTime,0 Second],
           MatchQ[primaryTemperature,Except[Ambient|Null]]&&(MatchQ[primaryEquilibrationTime,Null]||EqualQ[primaryEquilibrationTime,0 Second])
         ],
          (*Add options to conflicting options*)
          {LysisSolutionTemperature->primaryTemperature,LysisSolutionEquilibrationTime->primaryEquilibrationTime},
          (*Otherwise no conflicting options*)
          Nothing
        ];
        secondaryLysisConflictingOptions=If[
          (*If temperature is Null but equilibration time is a time larger than 0, Or the other way, temperature is not Ambient or Null, but equilibration time is null or zero*)
          Or[
            MatchQ[secondaryTemperature,Null]&&GreaterQ[secondaryEquilibrationTime,0 Second],
            MatchQ[secondaryTemperature,Except[Ambient|Null]]&&(MatchQ[secondaryEquilibrationTime,Null]||EqualQ[secondaryEquilibrationTime,0 Second])
          ],
          (*Add options to conflicting options*)
          {LysisSolutionTemperature->secondaryTemperature,LysisSolutionEquilibrationTime->secondaryEquilibrationTime},
          (*Otherwise no conflicting options*)
          Nothing
        ];
        tertiaryLysisConflictingOptions=If[
          (*If temperature is Null but equilibration time is a time larger than 0, Or the other way, temperature is not Ambient or Null, but equilibration time is null or zero*)
          Or[
            MatchQ[tertiaryTemperature,Null]&&GreaterQ[tertiaryEquilibrationTime,0 Second],
            MatchQ[tertiaryTemperature,Except[Ambient|Null]]&&(MatchQ[tertiaryEquilibrationTime,Null]||EqualQ[tertiaryEquilibrationTime,0 Second])
          ],
          (*Add options to conflicting options*)
          {LysisSolutionTemperature->tertiaryTemperature,LysisSolutionEquilibrationTime->tertiaryEquilibrationTime},
          (*Otherwise no conflicting options*)
          Nothing
        ];
        (*Join them together*)
        totalConflictingOptions=DeleteCases[Flatten[{primaryLysisConflictingOptions,secondaryLysisConflictingOptions,tertiaryLysisConflictingOptions}],Null];
        (*If totalConflictingOptions is not empty, output the sample, index, and conflicting options, otherwise output nothing*)
        If[Length[totalConflictingOptions]>0,
          {sample,index,Keys@totalConflictingOptions,Values@totalConflictingOptions},
          Nothing]
      ]
    ],
    {
      mySamples,
      Range[Length[mySamples]],
      resolvedLysisSolutionTemperatures,
      resolvedLysisSolutionEquilibrationTimes,
      resolvedSecondaryLysisSolutionTemperatures,
      resolvedSecondaryLysisSolutionEquilibrationTimes,
      resolvedTertiaryLysisSolutionTemperatures,
      resolvedTertiaryLysisSolutionEquilibrationTimes
    }
  ];
  If[Length[lysisSolutionEquilibrationTimeTemperatureMismatchOptions]>0 && messages,
    Message[
      Error::LysisSolutionEquilibrationTimeTemperatureMismatch,
      ObjectToString[lysisSolutionEquilibrationTimeTemperatureMismatchOptions[[All,1]], Cache -> cache],
      lysisSolutionEquilibrationTimeTemperatureMismatchOptions[[All,2]],
      lysisSolutionEquilibrationTimeTemperatureMismatchOptions[[All,3]],
      lysisSolutionEquilibrationTimeTemperatureMismatchOptions[[All,4]]
    ];
  ];
  lysisSolutionEquilibrationTimeTemperatureMismatchOptionsTest=If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = lysisSolutionEquilibrationTimeTemperatureMismatchOptions[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " do not have mismatched lysis solution temperature and equilibration time options for any lysis step:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " do not have mismatched lysis solution temperature and equilibration time options for any lysis step:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (*Check if the TargetProtein is specified as Null while the Purification is left Automatic. No purfication will be recommended due to the lack of target protein information.*)
  nullTargetProteinSamples=MapThread[
    Function[{sample, inputOptions, resolvedTargetProtein, index},
      If[(* If TargetProtein is Null while Purification is Automatic, no purification steps will be recommended))*)
        And[
          MatchQ[resolvedTargetProtein,Null],
          MatchQ[Lookup[inputOptions, Purification], Automatic]
        ],
        (*Output the sample, index,*)
        {sample, index},
        Nothing
      ]
    ],
    {mySamples,mapThreadFriendlyOptions,resolvedTargetProteins, Range[Length[mySamples]]}
  ];

  If[Length[nullTargetProteinSamples]>0 && messages,
    Message[
      Warning::NullTargetProtein,
      ObjectToString[nullTargetProteinSamples[[All,1]], Cache -> cache],
      nullTargetProteinSamples[[All,2]]
    ];
  ];

  nullTargetProteinTest=If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = nullTargetProteinSamples[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " do not have TargetProtein specified as Null (by method or by user) and Purification set to Automatic:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " do not have TargetProtein specified as Null (by method or by user) and Purification set to Automatic:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (*Check that LLE, Precipitation, SPE, and MBS have all options set to Null if not called in Purification.*)
  {methodValidityTest, invalidExtractionMethodOptions} = extractionMethodValidityTest[
    mySamples,
    resolvedOptions,
    gatherTests,
    Cache -> cacheBall
  ];
  (*Check that all of the SPE options work*)
  {solidPhaseExtractionConflictingOptionsTests, solidPhaseExtractionConflictingOptions} = solidPhaseExtractionConflictingOptionsChecks[
    mySamples,
    resolvedOptions,
    gatherTests,
    Cache -> cacheBall
  ];
  (*Check that the non-index matching shared MBS options SelectionStrategy and SeparationMode are not different by methods or user-method conflict*)
  {mbsMethodsConflictingOptionsTest, mbsMethodsConflictingOptions} = mbsMethodsConflictingOptionsTests[
    mySamples,
    resolvedOptions,
    gatherTests,
    Cache -> cacheBall
  ];

  (* Check that there are no more than 3 of each purification technique specified *)
  {purificationTests, purificationInvalidOptions} = purificationSharedOptionsTests[
    mySamples,
    samplePackets,
    resolvedOptions,
    gatherTests,
    Cache -> cache
  ];
  (*Do we want any tests here if they are only checking pre-resolved options?*)

  (* - FINAL ERRORS AND ASSIGNMENTS - *)

  (* -- INVALID INPUT CHECK -- *)

  (*Gather a list of all invalid inputs from all invalid input tests.*)
  invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs,deprecatedInvalidInputs,solidMediaInvalidInputs}]];

  (*Throw Error::InvalidInput if there are any invalid inputs.*)
  If[!gatherTests && Length[invalidInputs] > 0,
    Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cache]]
  ];

  (* -- INVALID OPTION CHECK -- *)

  (* Check our invalid option variables and throw Error::InvalidOption if necessary. *)
  invalidOptions=DeleteDuplicates[Flatten[{
    If[Length[noExtractProteinStepSamples]>0,
        {Lyse, Purification},
        {}
      ],
    If[Length[conflictingLysisStepSolutionEquilibrationOptions]>0,
      conflictingLysisStepSolutionEquilibrationOptions[[All,3]],
      {}
    ],
    If[Length[lysisSolutionEquilibrationTimeTemperatureMismatchOptions]>0,
      lysisSolutionEquilibrationTimeTemperatureMismatchOptions[[All,3]],
      {}
    ],
    Sequence @@ {invalidExtractionMethodOptions, purificationInvalidOptions,solidPhaseExtractionConflictingOptions,mbsMethodsConflictingOptions}
  }]];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions]>0&&!gatherTests,
    Message[Error::InvalidOption,invalidOptions]
  ];

  (* -- RESOLVED RETURN -- *)

  (* Return our resolved options and/or tests. *)
  outputSpecification/.{
    Result -> resolvedOptions,
    Tests -> Flatten[{
      optionPrecisionTests,
      methodTargetConflictingOptionsTest,
      noExtractProteinStepTest,
      repeatedLysisOptionsTest,
      unlysedCellsOptionsTest,
      conflictingLysisStepSolutionEquilibrationOptionsTest,
      lysisSolutionEquilibrationTimeTemperatureMismatchOptionsTest,
      nullTargetProteinTest,
      methodValidityTest,
      solidPhaseExtractionConflictingOptionsTests,
      mbsMethodsConflictingOptionsTest,
      purificationTests
    }]
  }
];


(* ::Subsection::Closed:: *)
(* extractProteinResourcePackets *)


(* --- extractProteinResourcePackets --- *)

DefineOptions[
  extractProteinResourcePackets,
  Options:>{
    HelperOutputOption,
    CacheOption,
    SimulationOption
  }
];

extractProteinResourcePackets[mySamples:ListableP[ObjectP[Object[Sample]]],myTemplatedOptions:{(_Rule|_RuleDelayed)...},myResolvedOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[
  {
    expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages,
    inheritedCache, samplePackets, uniqueSamplesInResources, resolvedPreparation, mapThreadFriendlyOptions, samplesInResources,
    sampleContainersIn, uniqueSampleContainersInResources, containersInResources, protocolPacket,allResourceBlobs,
    resourcesOk,resourceTests,previewRule, optionsRule,testsRule,resultRule, allUnitOperationPackets, currentSimulation,
    userSpecifiedLabels, runTime, unitOperationResolvedOptions, resolvedContainerOut, resolvedContainersOutWithWellsRemoved,resolvedContainerOutWell, resolvedIndexedContainerOut,
    fullyResolvedOptions, containerOutMapThreadFriendlyOptions, mapThreadFriendlyResolvedOptionsWithoutSolventAdditions,mapThreadFriendlyResolvedOptions,
    
    targetProteinPurificationMismatchOptions, targetProteinPurificationMismatchOptionsTest,
    conflictingLysisOutputOptions, conflictingLysisOutputOptionsTest,
    purificationConflictingOptions, purificationConflictingOptionsTests,
    purificationTests, purificationInvalidOptions,
    liquidLiquidExtractionTests, liquidLiquidExtractionInvalidOptions,
    invalidOptions,

    fastCacheBall
  },


  (* get the inherited cache *)
  inheritedCache = Lookup[ToList[ops],Cache,{}];

  (* Get the simulation *)
  currentSimulation=Lookup[ToList[ops],Simulation,Null];

  (* put the simulation packets AND the inherited cache into the fast assoc *)
  combinedSuperCache = FlattenCachePackets[{inheritedCache, Lookup[FirstOrDefault[currentSimulation, <||>], Packets, {}]}];
  fastCacheBall = makeFastAssocFromCache[combinedSuperCache];



  (* Lookup the resolved Preparation option. *)
  resolvedPreparation=Lookup[myResolvedOptions, Preparation];

  (* expand the resolved options if they weren't expanded already *)
  {expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentExtractProtein, {mySamples}, myResolvedOptions];

  (* Correct expansion of SolventAdditions. *)
  (* NOTE:This is needed because SolventAdditions is not correctly expanded by ExpandIndexMatchedInputs. *)
  expandedResolvedOptions = Experiment`Private`expandSolventAdditionsOption[mySamples, myResolvedOptions, expandedResolvedOptions, LiquidLiquidExtractionSolventAdditions, NumberOfLiquidLiquidExtractions];

  (* Get the resolved collapsed index matching options that don't include hidden options *)
  resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
    ExperimentExtractProtein,
    RemoveHiddenOptions[ExperimentExtractProtein,myResolvedOptions],
    Ignore->myTemplatedOptions,
    Messages->False
  ];

  (* Determine the requested return value from the function *)
  outputSpecification=OptionDefault[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests; if True, then silence the messages *)
  gatherTests=MemberQ[output,Tests];
  messages=!gatherTests;

  (* Download *)
  samplePackets=fetchPacketFromFastAssoc[#, fastCacheBall]& /@ mySamples;

  (* Create resources for our samples in. *)
  uniqueSamplesInResources=(#->Resource[Sample->#, Name->CreateUUID[]]&)/@DeleteDuplicates[Download[mySamples, Object]];
  samplesInResources=(Download[mySamples, Object])/.uniqueSamplesInResources;

  (* Create resources for our containers in. *)
  sampleContainersIn=Lookup[samplePackets, Container];
  uniqueSampleContainersInResources=(#->Resource[Sample->#, Name->CreateUUID[]]&)/@DeleteDuplicates[sampleContainersIn];
  containersInResources=(Download[sampleContainersIn, Object])/.uniqueSampleContainersInResources;

  (* Get our map thread friendly options. *)
  mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
    ExperimentExtractProtein,
    myResolvedOptions
  ];

  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  mapThreadFriendlyOptions = Experiment`Private`mapThreadFriendlySolventAdditions[myResolvedOptions, mapThreadFriendlyOptions, LiquidLiquidExtractionSolventAdditions];
  
  (* Get our user specified labels. *)
  userSpecifiedLabels=DeleteDuplicates@Cases[
    Flatten@Lookup[
      myResolvedOptions,
      {

        (* General *)
        ExtractedProteinLabel, ExtractedProteinContainerLabel,

        (* Lysis *)
        PreLysisSupernatantLabel, PreLysisSupernatantContainerLabel, PostClarificationPelletLabel, PostClarificationPelletContainerLabel,

        (* LLE *)
        ImpurityLayerLabel, ImpurityLayerContainerLabel,

        (* Precipitation *)
        PrecipitatedSampleLabel, PrecipitatedSampleContainerLabel, UnprecipitatedSampleLabel, UnprecipitatedSampleContainerLabel,


        (* MBS *)
        MagneticBeadSeparationPreWashCollectionContainerLabel, MagneticBeadSeparationEquilibrationCollectionContainerLabel, MagneticBeadSeparationLoadingCollectionContainerLabel, MagneticBeadSeparationWashCollectionContainerLabel, MagneticBeadSeparationSecondaryWashCollectionContainerLabel, MagneticBeadSeparationTertiaryWashCollectionContainerLabel, MagneticBeadSeparationQuaternaryWashCollectionContainerLabel, MagneticBeadSeparationQuinaryWashCollectionContainerLabel, MagneticBeadSeparationSenaryWashCollectionContainerLabel, MagneticBeadSeparationSeptenaryWashCollectionContainerLabel

      }
    ],
    _String
  ];

  (* --- Create the protocol packet --- *)
  (* Make unit operation packets for the Unit Operations we just made here *)
  {protocolPacket, allUnitOperationPackets, currentSimulation, runTime} = Module[
    {
      sampleInLabels, extactedProteinContainers, extractedProteinContainerWell,
      extractedProteinIndexedContainers,extractedProteinLabels, extractedProteinContainerLabels, labelSamplesInUnitOperations, workingSamples, lysisUnitOperations, purificationUnitOperations, labelSampleOutUnitOperation, primitives, roboticUnitOperationPackets, roboticRunTime, roboticSimulation, outputUnitOperationPacket
    },

    (* Initial Labeling *)
    (* Create a list of sample-in labels to be used internally *)
    sampleInLabels = Table[
      CreateUniqueLabel["ExtractProtein SampleIn", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
      {x, 1, Length[mySamples]}
    ];

    (*Get resolved ExtractedProteinLabels and ExtractedProteinContainerLabels*)
    extractedProteinLabels = Lookup[myResolvedOptions, ExtractedProteinLabel];
    extractedProteinContainerLabels = Lookup[myResolvedOptions, ExtractedProteinContainerLabel];
    extactedProteinContainers = Lookup[myResolvedOptions, ContainerOut];(*this could be in any of the acceptable input patterns for the container*)
    extractedProteinContainerWell = Lookup[myResolvedOptions, ContainerOutWell];
    extractedProteinIndexedContainers = Lookup[myResolvedOptions, IndexedContainerOut];(*use this when we need to know that the container is in {_Integer,ObjectP} pattern}*)

    (* LabelContainer and LabelSample *)
    labelSamplesInUnitOperations = {
      (* label samples *)
      LabelSample[
        Label -> sampleInLabels,
        Sample -> mySamples
      ]
    };

    (* Set up workingSamples to be updated as we move through esach unit operations. *)
    workingSamples = sampleInLabels;

    (* Lysis Unit Operation *)

    (* If Lyse is set to true call the LyseCells primitive using the sample. *)
    {workingSamples, lysisUnitOperations} = Module[{lyseBools},

      lyseBools = Lookup[myResolvedOptions, Lyse];

      If[MemberQ[lyseBools, True],
        Module[{lysedSamples, preFilteredLyseOptions, lysisOptions},

          lysedSamples = MapThread[
            Function[{sample, lyseQ},
              If[
                MatchQ[lyseQ, True],
                CreateUniqueLabel["lysed sample", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
                sample
              ]
            ],
            {
              workingSamples,
              lyseBools
            }
          ];

          (* gather the options we're passing into the Lyse UO; any Automatics that Lyse doesn't like as Automatic are changed to the default *)
          preFilteredLyseOptions = <|
            Sample -> PickList[workingSamples, lyseBools],
            Sequence @@ KeyValueMap[
              Function[{key, value},
                value -> PickList[Lookup[expandedResolvedOptions, key], lyseBools](*Lookup[options, key]*)
              ],
              Association @ KeyDrop[$LyseCellsSharedOptionsMap, {RoboticInstrument, TargetCellularComponent}]
            ],
            RoboticInstrument -> Lookup[myResolvedOptions, RoboticInstrument],
            NumberOfReplicates -> Null,
            TargetCellularComponent -> TotalProtein,
            SampleOutLabel -> PickList[lysedSamples, lyseBools]
          |>;
          lysisOptions = removeConflictingNonAutomaticOptions[LyseCells, Normal[preFilteredLyseOptions, Association]];
          
          {
            lysedSamples,
            LyseCells[lysisOptions]
          }
        ],
        {workingSamples, {}}
      ]
    ];

    (* Purification Unit Operations *)

    (* Purification unit operations work in the following way: *)
    (* Figure out what container we are in before purification rounds begin. *)
    (* In the first round, the samples will either be in the initial sample in container, *)
    (* or in the ContainerOut from LyseCells, or the collection container from HomogenizeLysate. *)
    (* Get purificationRound and purificationTechnique lists to Map through each Technique during each Round, *)
    (* for any samples that have that Technique set for that Round. *)
    (* Map through the maximum number of purification rounds that any sample has set. *)
    (* In each purificationRound, Map through the purificationTechniques. *)
    (* Update the sample and container information to the ContainerOut from the purification technique. *)
    (* Each purification technique child function may create additional containers out for impurity layers, etc. *)

    {workingSamples, purificationUnitOperations} = If[
      MatchQ[Lookup[myResolvedOptions, Purification], ListableP[Null|None]],
      {workingSamples,{}},
      buildPurificationUnitOperations[
        workingSamples,
        myResolvedOptions,
        mapThreadFriendlyOptions,
        ExtractedProteinContainerLabel,
        ExtractedProteinLabel,
        Cache -> inheritedCache,
        Simulation -> currentSimulation
      ]
    ];
    (* Combine the unit operations together *)
    primitives=Flatten[{
      labelSamplesInUnitOperations,
      lysisUnitOperations,
      purificationUnitOperations
    }];

    (* Set this internal variable to unit test the unit operations that are created by this function. *)
    $ExtractProteinOperations=primitives;

    (* Get our robotic unit operation packets. *)
    (* quieting the warning about sterile transferring because LLE will likely not contaminate things when extracting RNA, but will cause the warning to get thrown *)
    (* there is no way around this because the phase separators are not sterile and we can't get a sterile one in hand.  For this case, we're deciding that that is ok *)
    {{roboticUnitOperationPackets, roboticRunTime}, roboticSimulation} = Quiet[
      ExperimentRoboticCellPreparation[
        primitives,
        UnitOperationPackets -> True,
        Output -> {Result, Simulation},
        FastTrack -> Lookup[expandedResolvedOptions, FastTrack],
        ParentProtocol -> Lookup[expandedResolvedOptions, ParentProtocol],
        Name -> Lookup[expandedResolvedOptions, Name],
        Simulation -> currentSimulation,
        Upload -> False,
        ImageSample -> Lookup[expandedResolvedOptions, ImageSample],
        MeasureVolume -> Lookup[expandedResolvedOptions, MeasureVolume],
        MeasureWeight -> Lookup[expandedResolvedOptions, MeasureWeight],
        Priority -> Lookup[expandedResolvedOptions, Priority],
        StartDate -> Lookup[expandedResolvedOptions, StartDate],
        HoldOrder -> Lookup[expandedResolvedOptions, HoldOrder],
        QueuePosition -> Lookup[expandedResolvedOptions, QueuePosition],
        CoverAtEnd -> False
      ],
      Warning::ConflictingSourceAndDestinationAsepticHandling
    ];

    (* Create our own output unit operation packet, linking up the "sub" robotic unit operation objects. *)
    outputUnitOperationPacket=UploadUnitOperation[
      Module[{nonHiddenOptions},
        (* Only include non-hidden options from ExtractProtein. *)
        nonHiddenOptions=allowedKeysForUnitOperationType[Object[UnitOperation, ExtractProtein]];

        (* Override any options with resource. *)
        ExtractProtein@Join[
          Cases[myResolvedOptions, Verbatim[Rule][Alternatives@@nonHiddenOptions, _]],
          {
            Sample->samplesInResources,
            RoboticUnitOperations->If[Length[roboticUnitOperationPackets]==0,
              {},
              (Link/@Lookup[roboticUnitOperationPackets, Object])
            ]
          }
        ]
      ],
      UnitOperationType->Output,
      Upload->False
    ];

    (* Simulate the resources for our main UO since it's now the only thing that doesn't have resources. *)
    (* NOTE: Should probably use SimulateResources[...] here but this is quicker. *)
    roboticSimulation=UpdateSimulation[
      roboticSimulation,
      Simulation[<|Object->Lookup[outputUnitOperationPacket, Object], Sample->(Link/@mySamples)|>]
    ];

    (* since we are putting this UO inside RSP, we should re-do the LabelFields so they link via RoboticUnitOperations *)
    roboticSimulation=If[Length[roboticUnitOperationPackets]==0,
      roboticSimulation,
      updateLabelFieldReferences[roboticSimulation,RoboticUnitOperations]
    ];

    (* Return back our packets and simulation. *)
    {
      Null,
      Flatten[{outputUnitOperationPacket, roboticUnitOperationPackets}],
      roboticSimulation,
      (roboticRunTime+10Minute)
    }
  ];

  (* Pull out options from unit operation packets. *)
  unitOperationResolvedOptions = Module[{lyseSamples, LLESamples, SPESamples, precipitationSamples, MBSSamples, allSharedOptions, unNestedResolvedOptions},

    (* get the samples that are used in each step *)
    (* first get the lysed samples *)
    lyseSamples = PickList[mySamples, Lookup[expandedResolvedOptions, Lyse]];

    (* now get the samples for each purification step *)
    {
      LLESamples,
      SPESamples,
      precipitationSamples,
      MBSSamples
    } = Map[
      Function[{purification},
        Module[{sampleBools},

          sampleBools = Map[
            MemberQ[#, purification]&,
            Lookup[expandedResolvedOptions, Purification]
          ];

          PickList[mySamples, sampleBools]
        ]
      ],
      {
        LiquidLiquidExtraction,
        SolidPhaseExtraction,
        Precipitation,
        MagneticBeadSeparation
      }
    ];

    (* call shared function to pull out resolved options from unit operations and change Automatics to Nulls for any steps that are not used *)
    allSharedOptions = optionsFromUnitOperation[
      allUnitOperationPackets,
      {
        Object[UnitOperation, LyseCells],
        Object[UnitOperation, LiquidLiquidExtraction],
        Object[UnitOperation, SolidPhaseExtraction],
        Object[UnitOperation, Precipitate],
        Object[UnitOperation, MagneticBeadSeparation]
      },
      mySamples,
      {
        lyseSamples,
        LLESamples,
        SPESamples,
        precipitationSamples,
        MBSSamples
      },
      myResolvedOptions,
      mapThreadFriendlyOptions,
      {
        Normal[KeyDrop[$LyseCellsSharedOptionsMap, {Method, RoboticInstrument, SampleOutLabel}], Association],
        $LLEPurificationOptionMap,
        $SPEPurificationOptionMap,
        $PrecipitationSharedOptionMap,
        $MBSPurificationOptionMap
      },
      {
        MemberQ[Lookup[myResolvedOptions, Lyse], True],
        MemberQ[Flatten[Lookup[myResolvedOptions, Purification]], LiquidLiquidExtraction],
        MemberQ[Flatten[Lookup[myResolvedOptions, Purification]], SolidPhaseExtraction],
        MemberQ[Flatten[Lookup[myResolvedOptions, Purification]], Precipitation],
        MemberQ[Flatten[Lookup[myResolvedOptions, Purification]], MagneticBeadSeparation]
      }
    ];

    unNestedResolvedOptions = unNestResolvedPurificationOptions[Flatten[allSharedOptions]]

  ];

  (* Combine already resolved options and make them mapThreadFriendly. *)
  containerOutMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
    ExperimentExtractProtein,
    ReplaceRule[
      myResolvedOptions,
      unitOperationResolvedOptions
    ]
  ];

  (* Pull out ContainerOut option from purification resolved options for label resolution. *)
  resolvedContainerOut = MapThread[
    Function[{sample, options},
      Module[{},

        (* See if ContainerOut is already set or not. If it's Automatic, then resolve it.*)
        If[
          MatchQ[Lookup[options, ContainerOut], Automatic],
          Module[{lyseQ, purificationOption},

            (* Pull out master switch resolutions (for each step of the extraction). *)
            {lyseQ, purificationOption} = Lookup[options, {Lyse, Purification}];

            (* Go into that step's options (from the pulled out options or unit operation) and pull out the final container. *)
            Which[
              (* If Lysis is the last step and the lysate is neither aliquotted nor clarified, then it stays in it's original container. *)
              And[
                MatchQ[{lyseQ, purificationOption}, {True, None}],
                MatchQ[Lookup[options, {LysisAliquot, ClarifyLysate}],{False, False}]
              ],
                {Download[sample, Well, Cache -> inheritedCache], Download[Download[sample, Container, Cache -> inheritedCache], Object]},
              (* If Lysis is the last step and the lysate is aliquotted but not clarified, then the sample is last in the LysisAliquotContainer. *)
              And[
                MatchQ[{lyseQ, purificationOption}, {True, None}],
                MatchQ[Lookup[options, {LysisAliquot, ClarifyLysate}],{True, False}]
              ],
                Lookup[options, LysisAliquotContainer],
              (* If Lysis is the last step and the lysate is clarified, then the sample is last in the ClarifiedLysateContainer. *)
              And[
                MatchQ[{lyseQ, purificationOption}, {True, None}],
                MatchQ[Lookup[options, ClarifyLysate], True]
              ],
                Lookup[options, ClarifiedLysateContainer],

              (* If LLE is the last step, then container can be pulled out of unit operation options. *)
              MatchQ[Last[ToList[purificationOption]], LiquidLiquidExtraction],
                Module[{allUnitOperations, lleSamples, unitOperationPosition, unitOperationOptions},

                  (* Pull out unit operation types. *)
                  allUnitOperations = Lookup[#, Type] & /@ allUnitOperationPackets;

                  (* Pull out all samples that use LLE. *)
                  lleSamples = PickList[mySamples, Map[MemberQ[#, LiquidLiquidExtraction]&, Lookup[expandedResolvedOptions, Purification]]];

                  (* Find the position of the UO of interest. *)
                  unitOperationPosition = {Last[Flatten[Position[allUnitOperations, Object[UnitOperation, LiquidLiquidExtraction]]]]};

                  (* Find the resolved options of the UO. *)
                  unitOperationOptions = Lookup[Extract[allUnitOperationPackets, unitOperationPosition], ResolvedUnitOperationOptions];

                  (* Pull out the final container of the LLE step for this sample. *)
                  {
                    Extract[
                      Lookup[unitOperationOptions, TargetContainerOutWell],
                      Position[lleSamples, sample]
                    ][[1]],
                    Extract[
                      Lookup[unitOperationOptions, TargetContainerOut],
                      Position[lleSamples, sample]
                    ][[1]]
                  }
                ],
              (* If Precipitation is the last step and the target is liquid, then ContainerOut is the UnprecipitatedSampleContainerOut. *)
              And[
                MatchQ[Last[ToList[purificationOption]], Precipitation],
                MatchQ[Lookup[options, PrecipitationTargetPhase], Liquid]
              ],
                Lookup[options, UnprecipitatedSampleContainerOut],
              (* If Precipitation is the last step and the target is solid, then ContainerOut is the PrecipitatedSampleContainerOut. *)
              And[
                MatchQ[Last[ToList[purificationOption]], Precipitation],
                MatchQ[Lookup[options, PrecipitationTargetPhase], Solid]
              ],
                Lookup[options, PrecipitatedSampleContainerOut],
              (* If SPE is the last step and ExtractionStrategy is Positive, then ContainerOut is taken from the unit operation options. *)
              And[
                MatchQ[Last[ToList[purificationOption]], SolidPhaseExtraction],
                MatchQ[Lookup[options, SolidPhaseExtractionStrategy], Positive]
              ],
                Module[{allUnitOperations, speSamples, unitOperationPosition, unitOperationOptions},

                  (* Pull out unit operation types. *)
                  allUnitOperations = Lookup[#, Type] & /@ allUnitOperationPackets;

                  (* Pull out all samples that use LLE. *)
                  speSamples = PickList[mySamples, Map[MemberQ[#, SolidPhaseExtraction]&,Lookup[expandedResolvedOptions, Purification]]];

                  (* Find the position of the UO of interest. *)
                  unitOperationPosition = {Last[Flatten[Position[allUnitOperations, Object[UnitOperation, SolidPhaseExtraction]]]]};

                  (* Find the resolved options of the UO. *)
                  unitOperationOptions = Lookup[Extract[allUnitOperationPackets, unitOperationPosition], ResolvedUnitOperationOptions];

                  (* Pull out the final container of the SPE step for this sample. *)
                  Extract[
                    Lookup[unitOperationOptions, ElutingSolutionCollectionContainer],
                    Position[speSamples, sample]
                  ][[1]]

                ],
              (* If SPE is the last step and ExtractionStrategy is Negative, then ContainerOut is the SolidPhaseExtractionLoadingFlowthroughContainerOut. *)
              And[
                MatchQ[Last[ToList[purificationOption]], SolidPhaseExtraction],
                MatchQ[Lookup[options, SolidPhaseExtractionStrategy], Negative]
              ],
                Lookup[options, SolidPhaseExtractionLoadingFlowthroughContainerOut],
              (* If MBS is the last step and SelectionStrategy is Positive, then ContainerOut is the ElutionCollectionContainer. *)
              And[
                MatchQ[Last[ToList[purificationOption]], MagneticBeadSeparation],
                MatchQ[Lookup[options, MagneticBeadSeparationSelectionStrategy], Positive]
              ],
                Lookup[options, MagneticBeadSeparationElutionCollectionContainer],
              (* If MBS is the last step and SelectionStrategy is Negative, then ContainerOut is the LoadingCollectionContainer. *)
              And[
                MatchQ[Last[ToList[purificationOption]], MagneticBeadSeparation],
                MatchQ[Lookup[options, MagneticBeadSeparationSelectionStrategy], Negative]
              ],
                Lookup[options, MagneticBeadSeparationLoadingCollectionContainer],
              (* Otherwise, just set to whatever ContainerOut is as a backup. *)
              True,
                Lookup[options, ContainerOut]
            ]
          ],
          Lookup[options, ContainerOut]
        ]
      ]
    ],
    {mySamples, containerOutMapThreadFriendlyOptions}
  ];

  (* Remove any wells from user-specified container out inputs according to their widget patterns. *)
  resolvedContainersOutWithWellsRemoved = Map[
    Which[
      (* If the user specified ContainerOut using the "Container with Well" widget format, remove the well. *)
      MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container],Model[Container]}]}],
      Last[#],
      (* If the user specified ContainerOut using the "Container with Well and Index" widget format, remove the well. *)
      MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container],Model[Container]}]}}],
      Last[#],
      (* If the user specified ContainerOut any other way, we don't have to mess with it here. *)
      True,
      #
    ]&,
    resolvedContainerOut
  ];

  (*Resolve the ContainerOutWell and the indexed version of the container out (without a well).*)
  {resolvedContainerOutWell, resolvedIndexedContainerOut} = Module[
    {wellsFromContainersOut, uniqueContainers, containerToFilledWells, containerToWellOptions, containerToIndex},

    (* Get any wells from user-specified container out inputs according to their widget patterns. *)
    wellsFromContainersOut = Map[
      Which[
        (* If ContainerOut specified using the "Container with Well" widget format, extract the well. *)
        MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container],Model[Container]}]}],
        First[#],
        (* If ContainerOut specified using the "Container with Well and Index" widget format, extract the well. *)
        MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container],Model[Container]}]}}],
        First[#],
        (* Otherwise, there isn't a well specified and we set this to automatic. *)
        True,
        Automatic
      ]&,
      resolvedContainerOut
    ];

    (*Make an association of the containers with their already specified wells.*)
    uniqueContainers = DeleteDuplicates[Cases[resolvedContainersOutWithWellsRemoved, Alternatives[ObjectP[Object[Container]],ObjectP[Model[Container]],{_Integer, ObjectP[Model[Container]]}]]];

    containerToFilledWells = Map[
      Module[
        {uniqueContainerWells},

        (*Check if the container is a non-indexed model or non-indexed object. If so, then don't need to "reserve" wells*)
        (*because a new container will be used for each sample for non-indexed model and non-indexed object will be filled below.*)
        If[
          MatchQ[#[[1]], _Integer] || MatchQ[#, ObjectP[Object[Container]]],
          Module[{},

            (*MapThread through the wells and containers. Return the well if the container is the one being sorted.*)
            uniqueContainerWells = MapThread[
              Function[
                {well, container},
                If[
                  MatchQ[container, #] && !MatchQ[well, Automatic],
                  well,
                  Nothing
                ]
              ],
              {wellsFromContainersOut, resolvedContainersOutWithWellsRemoved}
            ];

            (*Return rule in the form of indexed container model to Filled wells.*)
            If[
              MatchQ[#[[1]], _Integer],
              # -> uniqueContainerWells,
              {1,#} -> uniqueContainerWells
            ]

          ],
          Nothing
        ]

      ]&,
      uniqueContainers
    ];


    (*Determine all of the options that the well can be in this container and put into a rule list.*)
    containerToWellOptions = Map[
      Module[
        {containerModelPacket},

        (*Get the container model to look up the available wells.*)
        containerModelPacket =
            Which[
              (*If the container without a well is just a container model, then that can be used directly.*)
              MatchQ[#, ObjectP[Model[Container]]],
                fetchPacketFromFastAssoc[#, fastCacheBall],
              (*If the container is an object, then the model is downloaded from the cache.*)
              MatchQ[#, ObjectP[Object[Container]]],
                fastAssocPacketLookup[fastCacheBall, #, Model],
              (*If the container is an indexed container model, then the model is the second element.*)
              True,
                fetchPacketFromFastAssoc[#[[2]], fastCacheBall]
            ];

        (*The well options are downloaded from the cache from the container model.*)
        # -> Flatten[Transpose[AllWells[AspectRatio -> Lookup[containerModelPacket, AspectRatio], NumberOfWells -> Lookup[containerModelPacket, NumberOfWells]]]]

      ]&,
      uniqueContainers
    ];

    (*Create a rule list to keep track of the index of the model containers that are being filled.*)
    containerToIndex = Map[
      If[
        MatchQ[#, ObjectP[Model[Container]]],
        # -> 1,
        Nothing
      ]&,
      uniqueContainers
    ];

    (*MapThread through containers without wells and wells. If resolving needed, finds next available well, resolves it and adds to "taken" wells.*)
    (*Also adds indexing to container if not already indexed.*)
    Transpose[MapThread[
      Function[
        {well,container},
        Module[
          {indexedContainer},

          (*Add index to container if not already indexed.*)
          indexedContainer = Which[
            (*If the container without a well is a non-indexed container model, then a new container is indexed.*)
            MatchQ[container, ObjectP[Model[Container]]],
            Module[
              {},

              (*Moves up the index until the container model index is not already assigned.*)
              While[
                KeyExistsQ[containerToFilledWells,{Lookup[containerToIndex,container],container}],
                containerToIndex = ReplaceRule[containerToIndex, container -> (Lookup[containerToIndex, container]+1)]
              ];

              {Lookup[containerToIndex,container],container}

            ],
            MatchQ[container, ObjectP[Object[Container]]],
            {1, container},
            True,
            container
          ];

          (*Check if the well is already set and doesn't need resolution.*)
          If[
            MatchQ[well, Automatic] && MatchQ[container, Except[Automatic]],
            Module[
              {filledWells,  wellOptions, availableWells, selectedWell},

              (*Pull out the already filled wells from containerToFilledWells so that we don't assign this sample *)
              (*to an already filled well.*)
              filledWells = Lookup[containerToFilledWells, Key[indexedContainer], {}];

              (*Pull out all of the options that the well can be in this container.*)
              wellOptions = Lookup[containerToWellOptions, Key[container]];

              (*Remove filled wells from the well options*)
              (*NOTE:Can't just use compliment because it messes with the order of wellOptions which has already been optimized for the liquid handlers.*)
              availableWells = UnsortedComplement[wellOptions, filledWells];

              (*Select the first well in availableWells to put the sample into.*)
              selectedWell = Which[
                (*If there is an available well, then fill it.*)
                MatchQ[availableWells, Except[{}]],
                First[availableWells],
                (*If there is not an available well and the container is not an object or indexed container, then clear the filled wells and start a new list.*)
                MatchQ[availableWells, {}] && !MatchQ[container, ObjectP[Object[Container]]|{_Integer, ObjectP[Model[Container]]}],
                Module[
                  {},

                  containerToFilledWells = ReplaceRule[containerToFilledWells, {indexedContainer -> {}}];

                  "A1"

                ],
                (*If there is not an available well and the container is an object or indexed container, then just set to A1.*)
                (*NOTE:At this point, the object container or indexed container model is full, so just set to A1 and will be caught by error checking.*)
                True,
                "A1"
              ];



              (*Now that this well is filled, added to list of filled wells.*)
              containerToFilledWells = If[
                KeyExistsQ[containerToFilledWells, indexedContainer],
                ReplaceRule[containerToFilledWells, {indexedContainer -> Append[filledWells,selectedWell]}],
                Append[containerToFilledWells, indexedContainer -> Append[filledWells,selectedWell]]
              ];

              (*Return the selected well and the indexed container.*)
              {selectedWell, indexedContainer}

            ],
            Module[
              {},

              (*If the container has a new index (non-indexed container model to start), then*)
              (*added to the containerToFilledWells list.*)
              If[
                MatchQ[container, ObjectP[Model[Container]]],
                containerToFilledWells = Append[containerToFilledWells, indexedContainer -> {well}]
              ];

              (*Return the user-specified well and the indexed container.*)
              {well, indexedContainer}

            ]
          ]
        ]

      ],
      {wellsFromContainersOut, resolvedContainersOutWithWellsRemoved}
    ]]

  ];

  (* replaced the pre-resolved options with the resolved options that were pulled out of the unit operations *)
  fullyResolvedOptions = ReplaceRule[
    myResolvedOptions,
    Flatten[{
      unitOperationResolvedOptions,
      ContainerOut -> resolvedContainerOut,
      ContainerOutWell -> resolvedContainerOutWell,
      IndexedContainerOut -> resolvedIndexedContainerOut
    }]
  ];

  (*-- CONFLICTING OPTIONS CHECKS --*)

  (*Get map thread friendly resolved options for use in options checks*)
  mapThreadFriendlyResolvedOptionsWithoutSolventAdditions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractProtein, fullyResolvedOptions];

  (* Correctly make SolventAdditions mapThreadFriendly. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  mapThreadFriendlyResolvedOptions = Experiment`Private`mapThreadFriendlySolventAdditions[fullyResolvedOptions, mapThreadFriendlyResolvedOptionsWithoutSolventAdditions, LiquidLiquidExtractionSolventAdditions];

  (* - conflictingLysisOutputOptionsTest - *)

  (* Find any samples for which Lyse is False but lysis options are set *)
  conflictingLysisOutputOptions = MapThread[
    Function[{sample, samplePacket, options, index},
      Module[{lyseLastStepQ, startingContainer},

        lyseLastStepQ = MatchQ[Lookup[options, {Lyse, Purification}], {True, None}];

        startingContainer = {Lookup[samplePacket, Position],Download[Lookup[samplePacket, Container], Object]};

        Which[
          lyseLastStepQ && MatchQ[Lookup[options, {LysisAliquot, ClarifyLysate}], {False, False}] && !MatchQ[startingContainer, Lookup[options, ContainerOut]],
          {
            sample,
            index,
            Lookup[options, LysisAliquot],
            Lookup[options, ClarifyLysate],
            "SampleIn Container",
            startingContainer,
            {ContainerOut},
            Lookup[options, ContainerOut]
          },
          lyseLastStepQ && MatchQ[Lookup[options, {LysisAliquot, ClarifyLysate}], {True, False}] && !MatchQ[Lookup[options, LysisAliquotContainer], Lookup[options, ContainerOut]],
          {
            sample,
            index,
            Lookup[options, LysisAliquot],
            Lookup[options, ClarifyLysate],
            {LysisAliquotContainer},
            Lookup[options, LysisAliquotContainer],
            {ContainerOut},
            Lookup[options, ContainerOut]
          },
          lyseLastStepQ && MatchQ[Lookup[options, ClarifyLysate], True] && !MatchQ[Lookup[options, {ClarifiedLysateContainer, ClarifiedLysateContainerLabel}], Lookup[options, {ContainerOut, ExtractedProteinContainerLabel}]],
          {
            sample,
            index,
            Lookup[options, LysisAliquot],
            Lookup[options, ClarifyLysate],
            {ClarifiedLysateContainer, ClarifiedLysateContainerLabel},
            Lookup[options, {ClarifiedLysateContainer, ClarifiedLysateContainerLabel}],
            {ContainerOut, ExtractedProteinContainerLabel},
            Lookup[options, {ContainerOut, ExtractedProteinContainerLabel}]
          },
          True,
          Nothing
        ]

      ]
    ],
    {mySamples, samplePackets, mapThreadFriendlyResolvedOptions, Range[Length[mySamples]]}
  ];

  (* If there are samples with conflicting lysis options and we are throwing messages, throw an error message *)
  If[Length[conflictingLysisOutputOptions] > 0 && messages,
    Message[Error::ConflictingLysisOutputOptions,
      ObjectToString[conflictingLysisOutputOptions[[All,1]], Cache -> inheritedCache],
      conflictingLysisOutputOptions[[All,2]],
      conflictingLysisOutputOptions[[All,3]],
      conflictingLysisOutputOptions[[All,4]],
      conflictingLysisOutputOptions[[All,5]],
      conflictingLysisOutputOptions[[All,6]],
      conflictingLysisOutputOptions[[All,7]],
      conflictingLysisOutputOptions[[All,8]]
    ]
  ];

  conflictingLysisOutputOptionsTest=If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = conflictingLysisOutputOptions[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> inheritedCache] <> " do not have any conflicts between SampleOut options and lysis options if lysis is the last step of the extraction:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> inheritedCache] <> " do not have any conflicts between SampleOut options and lysis options if lysis is the last step of the extraction:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

 (*Purification*)

 (*Check if the specified TargetProtein can be achieved with the specified Purification steps*)
 targetProteinPurificationMismatchOptions=MapThread[
   Function[{sample, resolvedOptions, index},

     If[(*If any of the following senario occurs, the purification would not be able to yield specified TargetProtein in SamplesOut*)
       Or[
       (*If TargetProtein is a Model[Molecule], but Purification does not include SPE or MBS*)
         And[
           MatchQ[Lookup[resolvedOptions, TargetProtein],ObjectP[Model[Molecule]]],
           MatchQ[Lookup[resolvedOptions, Purification], None|ListableP[Precipitation|LiquidLiquidExtraction]]
         ],
         (*If TargetProtein is All, but Purification but at least one of separation modes for SPE/MBS is set to be Affinity*)
         And[
           MatchQ[Lookup[resolvedOptions, TargetProtein],All],
           Or[MatchQ[Lookup[resolvedOptions, SolidPhaseExtractionSeparationMode], Affinity],
             MatchQ[Lookup[resolvedOptions, MagneticBeadSeparationMode], Affinity]
             ]
         ],
         (*If TargetProtein is a Model[Molecule], but Purification does not include SPE or MBS, but none of the separation mode for SPE/MBS is set to be Affinity*)
         And[
           MatchQ[Lookup[resolvedOptions, TargetProtein],ObjectP[Model[Molecule]]],
           And[MatchQ[Lookup[resolvedOptions, SolidPhaseExtractionSeparationMode], Except[Automatic|Affinity]],
             MatchQ[Lookup[resolvedOptions, MagneticBeadSeparationMode], Except[Automatic|Affinity]]
           ]
         ]
       ],
       (*If any of the above scenario happens, output the sample, index, input TargetProtein and input Purification*)
       {sample,
         index,
         Lookup[resolvedOptions, TargetProtein],
         Lookup[resolvedOptions, Purification]
       },
       Nothing
     ]
   ],
   {mySamples, mapThreadFriendlyResolvedOptions, Range[Length[mySamples]]}
 ];

 If[Length[targetProteinPurificationMismatchOptions]>0 && messages,
   Message[
     Warning::TargetPurificationMismatch,
     ObjectToString[targetProteinPurificationMismatchOptions[[All,1]], Cache -> inheritedCache],
     targetProteinPurificationMismatchOptions[[All,2]],
     targetProteinPurificationMismatchOptions[[All,3]],
     targetProteinPurificationMismatchOptions[[All,4]]
   ];
 ];

 targetProteinPurificationMismatchOptionsTest=If[gatherTests,
   Module[{affectedSamples, failingTest, passingTest},
     affectedSamples = targetProteinPurificationMismatchOptions[[All,1]];

     failingTest = If[Length[affectedSamples] == 0,
       Nothing,
       Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> inheritedCache] <> " do not have mismatched TargetProtein and Purification options specified:", True, False]
     ];

     passingTest = If[Length[affectedSamples] == Length[mySamples],
       Nothing,
       Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " do not have mismatched TargetProtein and Purification options specified:", True, True]
     ];

     {failingTest, passingTest}
   ],
   Null
 ];

  (* Purification conflicting options check - checks that all options for a purification technique should be Null if that purification technique is not called *)
  {purificationConflictingOptions, purificationConflictingOptionsTests} = checkPurificationConflictingOptions[
    mySamples,
    mapThreadFriendlyResolvedOptions,
    messages,
    Cache -> inheritedCache
  ];

  invalidOptions = DeleteDuplicates[Flatten[{
    Sequence@@{conflictingLysisOutputOptions, purificationConflictingOptions}
  }]];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions]>0&&!gatherTests,
    Message[Error::InvalidOption,invalidOptions]
  ];

  (* Make list of all the resources we need to check in FRQ *)
  allResourceBlobs = If[MatchQ[resolvedPreparation, Manual],
    DeleteDuplicates[Cases[Flatten[Values[protocolPacket]], _Resource, Infinity]],
    {}
  ];

  (* Verify we can satisfy all our resources *)
  {resourcesOk, resourceTests} = Which[
    (* NOTE: If we're robotic, the framework will call FRQ for us. *)
    MatchQ[$ECLApplication,Engine] || MatchQ[resolvedPreparation, Robotic],
    {True,{}},
    gatherTests,
    Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Cache->inheritedCache,Simulation->currentSimulation],
    True,
    {Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Messages->messages,Cache->inheritedCache,Simulation->currentSimulation],Null}
  ];

  (* --- Output --- *)
  (* Generate the Preview output rule *)
  previewRule = Preview -> Null;

  (* Generate the options output rule *)
  optionsRule = Options -> If[MemberQ[output, Options],
    resolvedOptionsNoHidden,
    Null
  ];

  (* Generate the tests rule *)
  testsRule = Tests -> If[
    gatherTests,
    Flatten[{
      resourceTests,
      conflictingLysisOutputOptionsTest,
      purificationConflictingOptionsTests
    }],
    {}
  ];

  (* Generate the Result output rule *)
  (* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
  resultRule = Result -> If[MemberQ[output,Result] && TrueQ[resourcesOk],
    {Flatten[{protocolPacket, allUnitOperationPackets}], currentSimulation, runTime, fullyResolvedOptions},
    $Failed
  ];

  (* Return the output as we desire it *)
  outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}
  
];
