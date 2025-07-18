(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(*ExperimentExtractSubcellularProtein*)

(* ::Subsubsection::Closed:: *)
(*ExperimentExtractSubcellularProtein Options*)

DefineOptions[ExperimentExtractSubcellularProtein,
  Options:> {
    IndexMatching[
      IndexMatchingInput->"experiment samples",

      (*--- GENERAL ---*)

      {
        OptionName -> TargetSubcellularFraction,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> MultiSelect,
          Pattern :> DuplicateFreeListableP[Alternatives[Cytosolic, Membrane, Nuclear]](*Quickfix, revert to SubcellularProteinFractionP once fixed pattern*)
        ],
        Description -> "The subcellular protein fraction(s) of interest from SamplesIn. One or more subcellular fractions can be chosen from Cytosolic, Membrane, and Nuclear. Note that in order to access the membrane proteins and nuclear proteins, cytosolic proteins must be first extracted. Therefore, if TargetSubcellularFraction is set to Membrane or Nuclear, the FractionationOrder option is automatically set to extract the Cytosolic proteins first.",
        ResolutionDescription -> "Automatically set to the TargetSubcellularFraction specified by the selected Method. If Method->Custom and FractionationOrder is specified, TargetSubcellularFraction is automatically set to FractionationOrder. Otherwise, TargetSubcellularFraction is set based on CellType. Specifically, TargetSubcellularFraction is set to {Cytosolic,Membrane} if CellType is Bacterial; it is set to {Cytosolic,Membrane,Nuclear} if CellType is Mammalian or Yeast; for other or unknown cell type, it is set to {Cytosolic} with Membrane appended if any of the MembraneWash, MembraneSolubilization,MembraneFractionation options is set and with Nuclear appended if any of the NuclearWash, NuclearLysis,NuclearFractionation options is set.",
        Category -> "General"
      },
      {
        OptionName -> TargetProtein,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Specific Protein"->Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[Molecule,Protein]]
          ],
          "All Protein in Fraction"->Widget[
            Type -> Enumeration,
            Pattern:>Alternatives[All]
          ]
        ],
        Description -> "The protein molecule that is targeted to isolate from SamplesIn during protein extraction. If isolating a specific target protein that is antigen, antibody, or his-tagged, subsequent isolation can happen via affinity column or affinity-based magnetic beads during purification. If isolating all proteins, purification can happen via liquid liquid extraction, solid phase extraction, magnetic bead separation, or precipitation.",
        ResolutionDescription -> "Automatically set to the TargetProtein specified by the selected Method. Otherwise, TargetProtein is automatically set to All.",
        Category -> "General"
      },

      ModifyOptions[CellExtractionSharedOptions,
        {
          OptionName ->Method,
          Default -> Automatic,
          ResolutionDescription -> "Automatically set to the first method in the search result of Object[Method,Extraction,Protein] that matches the TargetProtein and Lyse (and CellType if Lyse is True). If no method is found, Method is automatically set to Custom."
        }
      ],
      ModifyOptions[CellExtractionSharedOptions,
        ContainerOut,
        {
          OptionName -> ExtractedCytosolicProteinContainer,
          Description -> "The container into which the output sample resulting from cytosolic fractionation and optional purification is transferred.",
          ResolutionDescription -> "Automatically set to the container in which the final unit operation of the extraction protocol on the cytosolic fraction sample is performed.",
          AllowNull -> True
        }
      ],
      ModifyOptions[CellExtractionSharedOptions,
        ContainerOutWell,
        {
          OptionName -> ExtractedCytosolicProteinContainerWell,
          AllowNull -> True
        }
      ],
      ModifyOptions[CellExtractionSharedOptions,
        IndexedContainerOut,
        {
          OptionName -> ExtractedCytosolicProteinIndexedContainer,
          AllowNull -> True
        }
      ],
      ModifyOptions[CellExtractionSharedOptions,
        ContainerOut,
        {
          OptionName -> ExtractedMembraneProteinContainer,
          Description -> "The container into which the output sample resulting from membrane fractionation and optional purification is transferred.",
          ResolutionDescription -> "Automatically set to the container in which the final unit operation of the extraction protocol on the membrane fraction sample is performed.",
          AllowNull -> True
        }
      ],
      ModifyOptions[CellExtractionSharedOptions,
        ContainerOutWell,
        {
          OptionName -> ExtractedMembraneProteinContainerWell,
          AllowNull -> True
        }
      ],
      ModifyOptions[CellExtractionSharedOptions,
        IndexedContainerOut,
        {
          OptionName -> ExtractedMembraneProteinIndexedContainer,
          AllowNull -> True
        }
      ],
      ModifyOptions[CellExtractionSharedOptions,
        ContainerOut,
        {
          OptionName -> ExtractedNuclearProteinContainer,
          Description -> "The container into which the output sample resulting from nuclear fractionation and optional purification is transferred.",
          ResolutionDescription -> "Automatically set to the container in which the final unit operation of the extraction protocol on the nuclear fraction sample is performed.",
          AllowNull -> True
        }
      ],
      ModifyOptions[CellExtractionSharedOptions,
        ContainerOutWell,
        {
          OptionName -> ExtractedNuclearProteinContainerWell,
          AllowNull -> True
        }
      ],
      ModifyOptions[CellExtractionSharedOptions,
        IndexedContainerOut,
        {
          OptionName -> ExtractedNuclearProteinIndexedContainer,
          AllowNull -> True
        }
      ],

      {
        OptionName -> ExtractedCytosolicProteinLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description -> "A user defined word or phrase used to identify the protein extract sample resulting from cytosolic fractionation and optional purification for downstream use or analysis.",
        ResolutionDescription -> "Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise set to \"extracted cytosolic protein sample #\".",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> ExtractedCytosolicProteinContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description -> "A user defined word or phrase used to identify the container of the protein extract sample resulting from cytosolic fractionation and optional purification for downstream use or analysis.",
        ResolutionDescription->"Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"extracted cytosolic protein sample container #\".",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> ExtractedMembraneProteinLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description -> "A user defined word or phrase used to identify the protein extract sample resulting from membrane fractionation and optional purification for downstream use or analysis.",
        ResolutionDescription -> "Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise set to \"extracted membrane protein sample #\".",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> ExtractedMembraneProteinContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description -> "A user defined word or phrase used to identify the container of the protein extract sample resulting from membrane fractionation and optional purification for downstream use or analysis.",
        ResolutionDescription->"Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"extracted membrane protein sample container #\".",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> ExtractedNuclearProteinLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description -> "A user defined word or phrase used to identify the protein extract sample resulting from nuclear fractionation and optional purification for downstream use or analysis.",
        ResolutionDescription -> "Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise set to \"extracted nuclear protein sample #\".",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> ExtractedNuclearProteinContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description -> "A user defined word or phrase used to identify the container of the protein extract sample resulting from nuclear fractionation and optional purification for downstream use or analysis.",
        ResolutionDescription->"Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"extracted nuclear protein sample container #\".",
        Category -> "General",
        UnitOperation -> True
      },

        (* LYSIS *)
      {
        OptionName -> Lyse,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        Description -> "Indicates if cell lysis is to be performed to chemically break the cell membranes (and cell wall depending on the CellType) and release the cell components. Lysis in ExtractSubcellularProtein is intended to break the cell to release the soluble cytosolic components, while the membrane-bound proteins remain insoluble and the nucleus remain intact. If total protein is desired, please see ExtractProtein.",
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
          Description -> "The solution, containing enzymes, detergents, and chaotropics etc., used for disruption of cell membranes (and cell wall depending on the CellType) to release the soluble cytosolic components, while leaving the nuclei intact and membrane-bound proteins insoluble.",
          ResolutionDescription -> "Automatically set to the LysisSolution specified by the selected Method. If Method is set to Custom, LysisSolution is automatically set to Model[Sample, StockSolution, \"1mg/mL lysozyme in PBS\"] when CellType is Bacterial, and is automatically set to Model[Sample, StockSolution, \"Cytosolic Lysis Buffer with Digitonin\"] when CellType is Yeast or Mammalian."(*TODO::create the stock solution*)
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
        Description -> "The duration for which the LysisSolution is incubated at LysisSolutionTemperature before addition to the cell sample.",
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
        ResolutionDescription -> "Automatically set to the SecondaryLysisSolutionTemperature as specified by the selected Method. If Method->Custom and NumberOfLysisSteps is greater than or equal to 2, SecondaryLysisSolutionTemperature is automatically set to 4 Celsius.",
        Category -> "Lysis"
      },
      {
        OptionName -> SecondaryLysisSolutionEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> Alternatives[Second, Minute, Hour]],
        Description -> "The duration for which the SecondaryLysisSolution is incubated at SecondaryLysisSolutionTemperature before addition to the sample during the optional secondary lysis.",
        ResolutionDescription -> "Automatically set to the SecondaryLysisSolutionEquilibrationTime as specified by the selected Method. If Method->Custom and NumberOfLysisSteps is greater than or equal to 2, SecondaryLysisSolutionEquilibrationTime is automatically set to 10 Minute.",
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
        ResolutionDescription -> "Automatically set to the TertiaryLysisSolutionTemperature as specified by the selected Method. If Method->Custom and NumberOfLysisSteps is 3, TertiaryLysisSolutionTemperature is automatically set to 4 Celsius.",
        Category -> "Lysis"
      },
      {
        OptionName -> TertiaryLysisSolutionEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> Alternatives[Second, Minute, Hour]],
        Description -> "The duration for which the TertiaryLysisSolution is incubated at TertiaryLysisSolutionTemperature before addition to the sample during the optional tertiary lysis.",
        ResolutionDescription -> "Automatically set to the TertiaryLysisSolutionEquilibrationTime as specified by the selected Method. If Method->Custom and NumberOfLysisSteps is 3, TertiaryLysisSolutionEquilibrationTime is automatically set to 10 Minute.",
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

        (*--- FRACTIONATION ---*)

      {
        OptionName -> FractionationOrder,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> MultiSelect,
          Pattern :> DuplicateFreeListableP[Alternatives[Cytosolic, Membrane, Nuclear]]
        ],
        Description -> "The sequence of subcellular fractions that are separated out from the lysate sample. Due to its highly soluble nature, the cytosolic fraction separates out first if any subcellular fraction is targeted even if Cytosolic is not in TargetSubcellularFraction. The subsequent order of Membrane and Nuclear is interchangeable since different solutions can be applied to solubilize membranes or lyse the nuclei. Note that the FractionationOrder option is a superset of the subcellular protein fractions of interest as specified in the TargetSubcellularFraction option.",
        ResolutionDescription -> "Automatically set to the FractionationOrder specified by the selected Method. If Method is set to Custom, FractionationOrder is automatically set according to the order of {Cytosolic,Membrane,Nuclear} based on TargetSubcellularFraction. For example, if TargetSubcellularFraction->{Membrane}, FractionationOrder is automatically set to {Cytosolic,Membrane}; if TargetSubcellularFraction->{Nuclear,Membrane,Cytosolic}, FractionationOrder is automatically set to {Cytosolic,Membrane,Nuclear}.",
        Category -> "Fractionation"
      },

      ModifyOptions[ExperimentSolidPhaseExtraction,
        ExtractionCartridge,
        {
          OptionName -> FractionationFilter,
          Default -> Automatic,
          AllowNull -> True,
          Description->"The consumable container with an embedded filter which is used to retain the insoluble components on the filter and to separate the soluble fraction as the filtrate by flushing the sample through the pores in the filter. The sample is introduced into the filter when the fractionation technique is Filter for the first time according to the FractionationOrder, and the separation techniques following this fractionation step have to be Filter because the targets of the subsequent steps are retained on the filter. For example, if the FractionationOrder is {Cytosolic,Membrane,Nuclear} with CytosolicFractionationTechnique->Pellet and Membrane FractionationTechnique->Filter, the sample is introduced onto the FractionationFilter after membrane solubilization, and NuclearWashSeparationTechnique and NuclearFractionationTechnique need to be Filter as well.",
          ResolutionDescription->"Automatically set to the FractionationFilter as specified by the selected Method. If Method->Custom and and any of the CytosolicFractionationTechnique, MembraneFractionationTechnique, and NuclearFractionationTechnique is Filter, FractionationFilter is automatically set to Model[Container, Plate, Filter, \"Plate Filter, Omega 30K MWCO, 1000uL\"].",
          Category->"Fractionation"
        }
      ],

      (*--- FRACTIONATION --CYTOSOLIC-- Cytosolic Fractionation --- *)

      {
        OptionName -> CytosolicFractionationTechnique,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> Pellet | Filter
        ],
        Description -> "The type of force used to separate soluble protein-containing cytosolic fractions apart from insoluble fractions and components including membrane proteins, organelles, intact nuclei, cell debris, etc. Options include Pellet and Filter. With Pellet, the soluble cytosolic fraction is separated out by centrifugation as the supernatant from the insoluble membrane-bound proteins and intact nuclei. With Filter, the cytosolic fraction is collected as filtrate by applying a positive pressure to force the sample through a solid phase separation column. When CytosolicFractionationTechnique is set to Null, no cytosolic fractionation step is performed, and the lysate sample is directly subject to purification.",
        ResolutionDescription -> "Automatically set to the CytosolicFractionationTechnique specified by the selected Method. If Method is set to Custom, CytosolicFractionationTechnique is automatically set to Pellet.",
        Category -> "Fractionation"
      },
      {
        OptionName -> CytosolicFractionationPelletInstrument,
        Default -> Automatic,
        Description-> "The centrifuge instrument that is used to pellet the insoluble components in the lysate and to separate the cytosolic fraction as the supernatant during CytosolicFractionation.",
        ResolutionDescription -> "Automatically set to the CytosolicFractionationPelletInstrument specified by the selected Method. If Method is set to Custom and CytosolicFractionationTechnique is Pellet, CytosolicFractionationPelletInstrument is automatically set to the robotic integrated centrifuge, Model[Instrument, Centrifuge, \"HiG4\"].",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Instrument], Model[Instrument]}],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Instruments", "Centrifugation", "Microcentrifuges"}
          }
        ],
        Category -> "Fractionation"
      },
      {
        OptionName -> CytosolicFractionationPelletIntensity,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The rotational speed or the force that is applied to the samples in order to pellet the insoluble components in the lysate and to separate the cytosolic fraction as the supernatant during CytosolicFractionation.",
        ResolutionDescription -> "Automatically set to the CytosolicFractionationPelletIntensity specified by the selected Method. If Method->Custom and CytosolicFractionationTechnique is Pellet, CytosolicFractionationPelletIntensity is automatically set to 3600 GravitationalAcceleration.",
        Widget -> Alternatives[
          "Revolutions per Minute" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 RPM, $MaxCentrifugeSpeed],
            Units -> Alternatives[RPM]
          ],
          "Relative Centrifugal Force" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 GravitationalAcceleration, $MaxRelativeCentrifugalForce],
            Units -> Alternatives[GravitationalAcceleration]
          ]
        ],
        Category -> "Fractionation"
      },
      {
        OptionName -> CytosolicFractionationPelletTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the sample is subject to the CytosolicFractionationPelletIntensity in order to pellet the insoluble components in the lysate and to separate the cytosolic fraction as the supernatant during CytosolicFractionation.",
        ResolutionDescription -> "Automatically set to the CytosolicFractionationPelletTime specified by the selected Method. If Method->Custom and CytosolicFractionationTechnique is Pellet, CytosolicFractionationPelletTime is automatically set based on CellType. For mammalian cells, CytosolicFractionationPelletTime is automatically set to 5 Minute; for bacterial cells and yeast, CytosolicFractionationPelletTime is automatically set to 30 Minute; for other cell types, CytosolicFractionationPelletTime is automatically set to 15 Minute.",
        Category -> "Fractionation"
      },
      {
        OptionName -> CytosolicFractionationSupernatantVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Volume" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
            Units -> Alternatives[Microliter, Milliliter, Liter]],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ]
        ],
        Description -> "The amount of supernatant that contains the cytosolic fraction to be transferred to CytosolicFractionationSupernatantContainer after pelleting during cytosolic fractionation.",
        ResolutionDescription -> "Automatically set to the CytosolicFractionationSupernatantVolume specified by the selected Method. If Method is set to Custom and CytosolicFractionationTechnique is Pellet, CytosolicFractionationSupernatantVolume is automatically set to 90% of current volume.",
        Category -> "Fractionation"
      },
      {
        OptionName -> CytosolicFractionationSupernatantStorageCondition,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Condition" -> Widget[
            Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal
          ],
          "Objects" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"],
                "Storage Conditions"}
            }
          ]
        ],
        Description -> "The set of parameters that define the temperature, safety, and other environmental conditions under which the supernatant from pelleting the lysate sample during CytosolicFractionation is stored upon completion of this protocol.",
        ResolutionDescription -> "Automatically set to the CytosolicFractionationSupernatantStorageCondition specified by the selected Method. If Method is set to Custom and CytosolicFractionationTechnique is Pellet, CytosolicFractionationSupernatantStorageCondition is automatically set to Freezer.",
        Category -> "Fractionation"
      },
      {
        OptionName -> CytosolicFractionationSupernatantContainer,
        Default -> Automatic,
        AllowNull -> True,
        Widget->Alternatives[
          "Container"->Widget[
            Type->Object,
            Pattern:> ObjectP[{Object[Container],Model[Container]}]
          ],
          "Container with Index" -> {
            "Index"->Widget[
              Type->Number,
              Pattern:>GreaterEqualP[1,1]
            ],
            "Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Model[Container]}],
              PreparedSample->False,
              PreparedContainer->False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container],Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type->Enumeration,
              Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
              PatternTooltip->"Enumeration must be any well from A1 to P24."
            ],
            "Index and Container"->{
              "Index"->Widget[
                Type->Number,
                Pattern:>GreaterEqualP[1,1]
              ],
              "Container"->Widget[
                Type->Object,
                Pattern:>ObjectP[{Model[Container]}],
                PreparedSample->False,
                PreparedContainer->False
              ]
            }
          }
        ],
        Description -> "The container into which the supernatant from pelleting during cytosolic fractionation is transferred.",
        ResolutionDescription -> "Automatically set to the same container model of the input samples if CytosolicFractionationTechnique is Pellet.",
        Category -> "Fractionation"
      },
      {
        OptionName -> CytosolicFractionationSupernatantLabel,
        Default -> Automatic,
        AllowNull -> True,
        Description->"A user defined word or phrase used to identify the sample which is the collected supernatant from pelleting during cytosolic fractionation.",
        ResolutionDescription -> "Automatically set to \"cytosolic fractionation supernatant #\" if CytosolicFractionationTechnique is Pellet.",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Word
        ],
        Category->"Fractionation",
        UnitOperation->True
      },
      {
        OptionName -> CytosolicFractionationSupernatantContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description->"A user defined word or phrase used to identify the container of the sample, which is the collected supernatant from pelleting during cytosolic fractionation.",
        ResolutionDescription -> "Automatically set to \"cytosolic fractionation supernatant container #\" if CytosolicFractionationTechnique is Pellet.",
        Category -> "Fractionation",
        UnitOperation -> True
      },
      {
        OptionName->CytosolicFractionationFilterTechnique,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>Centrifuge|AirPressure
        ],
        Description->"The type of force used to flush the cell lysate sample through the FractionationFilter in order to retain the insoluble components on the filter and to separate the cytosolic fraction as the filtrate during CytosolicFractionation.",
        ResolutionDescription->"Automatically set to the CytosolicFractionationFilterTechnique as specified by the selected Method. If Method->Custom and CytosolicFractionationTechnique is Filter, CytosolicFractionationTechnique is automatically set to AirPressure.",
        Category->"Fractionation"
      },
      {
        OptionName->CytosolicFractionationFilterInstrument,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            Model[Instrument,Centrifuge],Object[Instrument,Centrifuge],
            Model[Instrument,PressureManifold],Object[Instrument,PressureManifold]
          }],
          OpenPaths->{
            {Object[Catalog,"Root"],"Instruments","Centrifugation","Microcentrifuges"},
            {Object[Catalog,"Root"],"Instruments","Dead-End Filtering Devices"}
          }
        ],
        Description->"The Instrument that generates force to flush the cell lysate sample through the FractionationFilter during the CytosolicFractionationFilterTime.",
        ResolutionDescription->"Automatically set to the CytosolicFractionationFilterInstrument as specified by the selected Method. If Method->Custom and CytosolicFractionationTechnique is Filter, CytosolicFractionationFilterInstrument is automatically set to Model[Instrument,PressureManifold,\"MPE2\"].",
        Category->"Fractionation"
      },
      {
        OptionName->CytosolicFractionationFilterCentrifugeIntensity,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Speed"->Widget[
            Type->Quantity,
            Pattern:>RangeP[0*RPM,$MaxRoboticCentrifugeSpeed],(*automatically round it for them, then throw a warning telling them you did that, instead of giving a specific delta*)
            Units->Alternatives[RPM]
          ],
          "Force"->Widget[
            Type->Quantity,
            Pattern:>RangeP[0*GravitationalAcceleration,$MaxRoboticRelativeCentrifugalForce],
            Units->Alternatives[GravitationalAcceleration]
          ]
        ],
        Description->"The rotational speed or gravitational force at which the sample is centrifuged to flush the cell lysate sample through the FractionationFilter during the CytosolicFractionationFilterTime, in order to retain the insoluble components on the filter and to separate the cytosolic fraction as the filtrate during CytosolicFractionation.",
        ResolutionDescription->"Automatically set to the CytosolicFractionationFilterCentrifugeIntensity as specified by the selected Method. If Method->Custom and CytosolicFractionationTechnique is Filter, CytosolicFractionationFilterCentrifugeIntensity is automatically set to the lesser of the MaxIntensity of the centrifuge model and the MaxCentrifugationForce of the CytosolicFractionationFilter.",
        Category->"Fractionation"
      },
      {
        OptionName->CytosolicFractionationFilterPressure,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0*PSI,$MaxRoboticAirPressure],
          Units->{PSI,{Pascal,Kilopascal,PSI,Millibar,Bar}}
        ],
        Description->"The amount of pressure applied to flush the lysate sample through the through the FractionationFilter during the CytosolicFractionationFilterTime, in order to retain the insoluble components on the filter and to separate the cytosolic fraction as the filtrate during CytosolicFractionation.",
        ResolutionDescription->"Automatically set to the CytosolicFractionationFilterFilterPressure as specified by the selected Method. If Method->Custom and CytosolicFractionationTechnique is Filter, CytosolicFractionationFilterPressure is automatically set to the lesser of the MaxPressure of the positive pressure model and the MaxPressure of the CytosolicFractionationFilter.",
        Category->"Fractionation"
      },
      {
        OptionName->CytosolicFractionationFilterTime,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0*Minute,$MaxExperimentTime],
          Units->Alternatives[Second,Minute,Hour]
        ],
        Description->"The duration of time for which force is applied to flush the lysate sample through the through the FractionationFilter by the specified CytosolicFractionationFilterTechnique and CytosolicFractionationFilterInstrument,in order to retain the insoluble components on the filter and to separate the cytosolic fraction as the filtrate during CytosolicFractionation.",
        ResolutionDescription->"Automatically set to the CytosolicFractionationFilterTime as specified by the selected Method. If Method->Custom and CytosolicFractionationTechnique is Filter, CytosolicFractionationFilterTime is automatically set to 1 Minute.",
        Category->"Fractionation"
      },
      {
        OptionName -> CytosolicFractionationFiltrateStorageCondition,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Condition" -> Widget[
            Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal
          ],
          "Objects" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"],"Storage Conditions"}
            }
          ]
        ],
        Description -> "The set of parameters that define the temperature, safety, and other environmental conditions under which the filtrate from filtering the lysate sample during CytosolicFractionation is stored upon completion of this protocol.",
        ResolutionDescription -> "Automatically set to the CytosolicFractionationFiltrateStorageCondition specified by the selected Method. If Method is set to Custom and CytosolicFractionationTechnique is Filter, CytosolicFractionationFiltrateStorageCondition is automatically set to Freezer.",
        Category -> "Fractionation"
      },
      {
        OptionName -> CytosolicFractionationFiltrateContainer,
        Default -> Automatic,
        AllowNull -> True,
        Widget->Alternatives[
          "Container"->Widget[
            Type->Object,
            Pattern:> ObjectP[{Object[Container],Model[Container]}]
          ],
          "Container with Index" -> {
            "Index"->Widget[
              Type->Number,
              Pattern:>GreaterEqualP[1,1]
            ],
            "Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Model[Container]}],
              PreparedSample->False,
              PreparedContainer->False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container],Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type->Enumeration,
              Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
              PatternTooltip->"Enumeration must be any well from A1 to P24."
            ],
            "Index and Container"->{
              "Index"->Widget[
                Type->Number,
                Pattern:>GreaterEqualP[1,1]
              ],
              "Container"->Widget[
                Type->Object,
                Pattern:>ObjectP[{Model[Container]}],
                PreparedSample->False,
                PreparedContainer->False
              ]
            }
          }
        ],
        Description -> "The container into which the filtrate from filtering during cytosolic fractionation is transferred.",
        ResolutionDescription -> "Automatically set to the same container model of the input samples if CytosolicFractionationTechnique is Filter.",
        Category -> "Fractionation"
      },
      {
        OptionName -> CytosolicFractionationFiltrateLabel,
        Default -> Automatic,
        AllowNull -> True,
        Description->"A user defined word or phrase used to identify the sample which is the collected filtrate from filtering during cytosolic fractionation.",
        ResolutionDescription -> "Automatically set to \"cytosolic fractionation filtrate #\". if CytosolicFractionationTechnique is Filter",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Word
        ],
        Category->"Fractionation",
        UnitOperation->True
      },
      {
        OptionName -> CytosolicFractionationFiltrateContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description->"A user defined word or phrase used to identify the container of the sample, which is the collected filtrate from filtering during cytosolic fractionation.",
        ResolutionDescription -> "Automatically set to \"cytosolic fractionation filtrate container #\". if CytosolicFractionationTechnique is Filter",
        Category -> "Fractionation",
        UnitOperation -> True
      },
      {
        OptionName -> CytosolicFractionationCollectionContainerTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the sample collection container is maintained during the CytosolicFractionationCollectionContainerEquilibrationTime before the supernatant or filtrate sample from pelleting or filtering during cytosolic fractionation is transferred into it.",
        ResolutionDescription -> "Automatically set to the CytosolicFractionationCollectionContainerTemperatureTemperature as specified by the selected Method. If Method->Custom, CytosolicFractionationCollectionContainerTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },
      {
        OptionName -> CytosolicFractionationCollectionContainerEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> Alternatives[Second, Minute, Hour]],
        Description -> "The duration for which the the sample collection container is maintained at CytosolicFractionationCollectionContainerTemperature before the supernatant or filtrate sample from pelleting or filtering during cytosolic fractionation is transferred into it.",
        ResolutionDescription -> "Automatically set to the CytosolicFractionationCollectionContainerEquilibrationTime as specified by the selected Method. If Method->Custom and CytosolicFractionationCollectionContainerTemperature is not Null or Ambient, CytosolicFractionationCollectionContainerEquilibrationTime is automatically set to 10 Minute.",
        Category -> "Fractionation"
      },

      (*--- FRACTIONATION --MEMBRANE-- Membrane wash --- *)

      {
        OptionName->NumberOfMembraneWashes,
        Default->Automatic,
        Description->"The number of times the pellet or filter from cytosolic fractionation or membrane fractionation, depending on the FractionationOrder, is rinsed in order to remove non-membrane-bound protein contamination as much as possible. The pellet is rinsed by adding MembraneWashSolution, mixing, incubating (optional), pelleting, and aspirating. The filter is rinsed by adding MembraneWashSolution, incubating, and filtering.",
        ResolutionDescription->"Automatically set to the NumberOfMembraneWashes as specified by the selected Method. If FractionationOrder contains Membrane and Method->Custom, NumberOfMembraneWashes is automatically set to 1.",
        AllowNull->True,
        Widget->Widget[Type->Number,Pattern:>RangeP[1,20,1]],
        Category -> "Fractionation"
      },
      {
        OptionName-> MembraneWashSolution,
        AllowNull -> True,
        Default->Automatic,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          OpenPaths->{
            {Object[Catalog,"Root"],"Materials","Reagents"}
          }
        ],
        Description -> "The solution used to rinse the the pellet or filter from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder) in order to remove non-membrane-bound protein contamination as much as possible.",
        ResolutionDescription -> "Automatically set as specified by the selected Method. If the NumberOfMembraneWashes is not Null and Method is set to Custom, automatically set to Model[Sample, StockSolution, \"1x PBS (Phosphate Buffer Saline), Autoclaved\"].",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashSolutionVolume,
        AllowNull -> True,
        Widget->Alternatives[
          Widget[Type->Quantity, Pattern:>RangeP[0 Microliter,$MaxRoboticTransferVolume], Units->Alternatives[Microliter,Milliliter,Liter]],
          Widget[Type->Enumeration,Pattern:>Alternatives[All]]
        ],
        Default->Automatic,
        Description -> "The volume of MembraneWashSolution added to rinse the pellet or filter from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder), in order to remove non-membrane-bound protein contamination as much as possible.",
        ResolutionDescription -> "Automatically set as specified by the selected Method. If the NumberOfMembraneWashes is not Null and Method is set to Custom, automatically set to the lesser of the input sample volume, or half of the maximum volume which can be added to the pellet container or the filter.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashSolutionTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the MembraneWashSolution is maintained during the MembraneWashSolutionEquilibrationTime before addition to the pellet or filter in order to rinse during each membrane wash.",
        ResolutionDescription -> "Automatically set to the MembraneWashSolutionTemperature as specified by the selected Method. If the NumberOfMembraneWashes is not Null and Method->Custom, MembraneWashSolutionTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashSolutionEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> Alternatives[Second, Minute, Hour]],
        Description -> "The duration for which the MembraneWashSolution is maintained at MembraneWashSolutionTemperature before addition to the pellet or filter to rinse during each membrane wash.",
        ResolutionDescription -> "Automatically set to the MembraneWashSolutionTime as specified by the selected Method. If MembraneWashSolutionTemperature is not Null or Ambient and Method->Custom, MembraneWashSolutionTime is automatically set to 10 Minute.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashMixType,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake, Pipette, None]],
        Description -> "The manner in which the solution is mixed following the combination of MembraneWashSolution and the pellet from the previous fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder). None specifies that no mixing occurs each membrane wash. Only applicable when the previous fractionation technique is Pellet.",
        ResolutionDescription -> "Automatically set to the MembraneWashMixType specified by the selected Method. If the NumberOfMembraneWashes is not Null and Method is set to Custom and the previous fractionation technique is set to Pellet, MembraneWashMixType is automatically set to Shake. If Method is set to Custom, NumberOfMembraneWashes is not Null, and the previous fractionation technique is Filter, MembraneWashMixType is automatically set to None.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashMixRate,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 RPM,$MaxMixRate],Units->RPM],
        Description->"The rate at which the sample is mixed by the selected MembraneWashMixType during the MembraneWashMixTime.",
        ResolutionDescription->"Automatically set to the MembraneWashMixRate specified by the selected Method. If Method is set to Custom and MembraneWashMixType is set to Shake, MembraneWashMixRate is automatically set to 1000 RPM.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashMixTime,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute,$MaxExperimentTime],Units->Alternatives[Second,Minute,Hour]],
        Description->"The duration for which the sample is mixed by the selected MembraneWashMixType following the combination of MembraneWashSolution and the pellet from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder).",
        ResolutionDescription->"If MembraneWashMixType is set to Shake, automatically set to the MembraneWashMixTime specified by the selected Method. If MembraneWashMixType is set to Shake and Method is set to Custom, automatically set to 1 minute.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NumberOfMembraneWashMixes,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Number,Pattern:>RangeP[1,$MaxNumberOfMixes,1]],
        Description->"The number of times that the sample is mixed by pipetting the MembraneWashMixVolume up and down following the combination of MembraneWashSolution and the pellet from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder).",
        ResolutionDescription->"If MembraneWashMixType is set to Pipette, automatically set to the NumberOfMembraneWashMixes specified by the selected Method. If MembraneWashMixType is set to Pipetting and Method is set to Custom, automatically set to 10.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashMixVolume,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,$MaxMicropipetteVolume],Units->Alternatives[Microliter,Milliliter]],
        Description->"The volume of the combination of MembraneWashSolution and the pellet from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder) displaced during each mix-by-pipette mix cycle.",
        ResolutionDescription->"Automatically set to MembraneWashMixVolume specified by the selected Method. If Method is set to Custom and MembraneWashMixType is set to Pipette, MembraneWashMixVolume is automatically set to 50% of the MembraneWashSolutionVolume.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashMixTemperature,
        Default->Automatic,
        AllowNull->True,
        Widget -> Alternatives[
              "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
              "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
            ],
        Description -> "The temperature at which the instrument heating or cooling the combination of MembraneWashSolution and the pellet from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder) is maintained during the MembraneWashMixTime, which occurs immediately before the MembraneWashIncubationTime or MembraneWashPelletTime if MembraneWashIncubationTime is Null or 0 Minute.",
        ResolutionDescription->"Automatically set to MembraneWashMixTemperature specified by the selected Method. If Method is set to Custom and MembraneWashMixType is not None, MembraneWashMixTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },
      {
        OptionName->MembraneWashIncubationTime,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute,$MaxExperimentTime],Units->Alternatives[Second,Minute,Hour]],
        Description->"The minimum duration for which the Instrument heating or cooling the mixed pellet and the MembraneWashSolution is maintained at the MembraneWashIncubationTemperature to facilitate washing of the pellet in order to remove non-membrane-bound protein contamination as much as possible. The MembraneWashIncubationTime occurs immediately after MembraneWashMixTime.",
        ResolutionDescription->"Automatically set to the MembraneWashIncubationTime specified by the selected Method. If the Method is set to Custom, automatically set to Null.",
        Category -> "Fractionation"
      },
      {
        OptionName->MembraneWashIncubationTemperature,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Temperature"->Widget[Type->Quantity, Pattern:>RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units->Alternatives[Celsius,Fahrenheit]],
          "Ambient"->Widget[Type->Enumeration, Pattern:>Alternatives[Ambient]]
        ],
        Description->"The temperature at which the instrument heating or cooling the mixed pellet and the MembraneWashSolution is maintained during the MembraneWashIncubationTime.",
        ResolutionDescription->"Automatically set to the MembraneWashIncubationTemperature specified by the selected Method. If Method is set to Custom and MembraneWashIncubationTime > 0 Second, MembraneWashIncubationTemperature is automatically set to 4 Celsius. For 0 or Null MembraneWashIncubationTime, MembraneWashIncubationTemperature is automatically set to Null.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashSeparationTechnique,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> Pellet | Filter
        ],
        Description -> "The type of force used to separate the insoluble components and to separate the possibly remaining cytosolic fraction or nuclear fraction (depending on the FractionationOrder). Options include Pellet and Filter. With Pellet, the possibly remaining cytosolic fraction or nuclear fraction is separated out by centrifugation as the supernatant from the insoluble membrane-bound proteins. With Filter, the possibly remaining cytosolic fraction or nuclear fraction is collected as filtrate by applying a positive pressure to force the sample through a solid phase separation column. If last used technique is Pellet, MembraneWashTechnique can be Pellet or Filter. However, if last used technique is Filter, MembraneWashTechnique can only be Filter.",
        ResolutionDescription -> "Automatically set to the MembraneWashTechnique specified by the selected Method. If the NumberOfMembraneWashes is not Null and Method is set to Custom, MembraneWashTechnique is automatically set to the same as the last technique option, i.e. CytosolicFractionationTehchnique or NuclearFractionationTechnique, depending on the FractionationOrder.",
        Category -> "Fractionation"
      },
      {
        OptionName ->MembraneWashPelletInstrument,
        Default -> Automatic,
        Description-> "The centrifuge instrument that is used to pellet the insoluble components and to separate the possibly remaining cytosolic fraction or nuclear fraction (depending on the FractionationOrder) rinsed into the MembraneWashSolution as the supernatant during each membrane wash.",
        ResolutionDescription -> "Automatically set to the MembraneWashPelletInstrument specified by the selected Method. If Method is set to Custom and MembraneWashSeparationTechnique is Pellet, MembraneWashPelletInstrument is automatically set to the robotic integrated centrifuge, Model[Instrument, Centrifuge, \"HiG4\"].",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Instrument], Model[Instrument]}],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Instruments", "Centrifugation", "Microcentrifuges"}
          }
        ],
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashPelletIntensity,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The rotational speed or the force that is applied to the samples in order to pellet the insoluble components and to separate the possibly remaining cytosolic fraction or nuclear fraction (depending on the FractionationOrder) rinsed into the MembraneWashSolution as the supernatant during each membrane wash.",
        ResolutionDescription -> "Automatically set to the MembraneWashPelletIntensity specified by the selected Method. If Method->Custom and MembraneWashSeparationTechnique is Pellet, MembraneWashPelletIntensity is automatically set to 3600 GravitationalAcceleration.",
        Widget -> Alternatives[
          "Revolutions per Minute" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 RPM, $MaxRoboticCentrifugeSpeed],
            Units -> Alternatives[RPM]
          ],
          "Relative Centrifugal Force" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 GravitationalAcceleration, $MaxRoboticRelativeCentrifugalForce],
            Units -> Alternatives[GravitationalAcceleration]
          ]
        ],
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashPelletTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the sample is subject to the MembraneWashPelletIntensity in order to pellet the insoluble components and to separate the possibly remaining cytosolic fraction or nuclear fraction (depending on the FractionationOrder) rinsed into the MembraneWashSolution as the supernatant during each membrane wash.",
        ResolutionDescription -> "Automatically set to the MembraneWashPelletTime specified by the selected Method. If Method->Custom and MembraneWashSeparationTechnique is Pellet,, MembraneWashPelletTime is automatically set based on CellType. For mammalian cells, MembraneWashPelletTime is automatically set to 10 Minute; for bacterial cells and yeast, MembraneWashPelletTime is automatically set to 45 Minute.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashSupernatantVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Volume" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
            Units -> Alternatives[Microliter, Milliliter, Liter]],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ]
        ],
        Description -> "The amount of supernatant that contains the possibly remaining cytosolic fraction or nuclear fraction (depending on the FractionationOrder) to be transferred to MembraneWashSupernatantContainer after pelleting during each membrane wash.",
        ResolutionDescription -> "Automatically set to the MembraneWashSupernatantVolume specified by the selected Method. If Method is set to Custom and MembraneWashTechnique is Pellet, automatically set to All if NumberOfMembraneWashes is not Null.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashSupernatantContainer,
        Default -> Automatic,
        AllowNull -> True,
        Widget->Alternatives[
          "Container"->Widget[
            Type->Object,
            Pattern:> ObjectP[{Object[Container],Model[Container]}]
          ],
          "Container with Index" -> {
            "Index"->Widget[
              Type->Number,
              Pattern:>GreaterEqualP[1,1]
            ],
            "Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Model[Container]}],
              PreparedSample->False,
              PreparedContainer->False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container],Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type->Enumeration,
              Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
              PatternTooltip->"Enumeration must be any well from A1 to P24."
            ],
            "Index and Container"->{
              "Index"->Widget[
                Type->Number,
                Pattern:>GreaterEqualP[1,1]
              ],
              "Container"->Widget[
                Type->Object,
                Pattern:>ObjectP[{Model[Container]}],
                PreparedSample->False,
                PreparedContainer->False
              ]
            }
          }
        ],
        Description -> "The container into which the used MembraneWashSolution containing the possibly remaining cytosolic fraction or nuclear fraction (depending on the FractionationOrder), which is the supernatant from pelleting during each membrane wash, is transferred.",
        ResolutionDescription -> "Automatically set to the container found by PreferredContainer that is capable of holding the volume of NumberOfMembraneWashes*MembraneWashSupernatantTransferVolume, if MembraneWashTechnique is Pellet.",
        Category -> "Fractionation"
      },
      {
        OptionName->MembraneWashSupernatantLabel,
        Default->Automatic,
        AllowNull->True,
        Description->"A user defined word or phrase used to identify the sample which is the collected supernatant from pelleting during each membrane wash.",
        ResolutionDescription -> "Automatically set to \"membrane wash supernatant #\" if MembraneWashSupernatantVolume is not Null or 0.",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Word
        ],
        Category->"Fractionation",
        UnitOperation->True
      },
      {
        OptionName->MembraneWashSupernatantContainerLabel,
        Default->Automatic,
        AllowNull->True,
        Description->"A user defined word or phrase used to identify the container of the sample, which is the collected supernatant from pelleting during each membrane wash.",
        ResolutionDescription -> "Automatically set to \"membrane wash supernatant container #\" if MembraneWashSupernatantVolume is not Null or 0.",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Word
        ],
        Category->"Fractionation",
        UnitOperation->True
      },
      {
        OptionName -> MembraneWashSupernatantStorageCondition,
        Default -> Automatic,
        Description -> "The non-default condition under which the collected supernatant sample from pelleting during each membrane wash is stored after the protocol is completed.",
        ResolutionDescription -> "Automatically set to Disposal if NumberOfMembraneWashes>0.",
        AllowNull -> True,
        Widget -> Alternatives[
          "Condition" -> Widget[
            Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal
          ],
          "Objects" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"],"Storage Conditions"}
            }
          ]
        ],
        Category -> "Post Experiment"
      },
      {
        OptionName->MembraneWashFilterTechnique,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>Centrifuge|AirPressure
        ],
        Description->"The type of force used to flush the incubated (optional) MembraneWashSolution through the working filter from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder) in order to rinse away the non-membrane-bound protein contamination as much as possible.",
        ResolutionDescription->"Automatically set to the MembraneWashFilterTechnique as specified by the selected Method. If Method->Custom and MembraneWashTechnique is Filter, MembraneWashTechnique is automatically set to AirPressure.",
        Category->"Fractionation"
      },
      {
        OptionName->MembraneWashFilterInstrument,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            Model[Instrument,Centrifuge],Object[Instrument,Centrifuge],
            Model[Instrument,PressureManifold],Object[Instrument,PressureManifold]
          }],
          OpenPaths->{
            {Object[Catalog,"Root"],"Instruments","Centrifugation","Microcentrifuges"},
            {Object[Catalog,"Root"],"Instruments","Dead-End Filtering Devices"}
          }
        ],
        Description->"The Instrument that generates force to flush incubated (optional) MembraneWashSolution through the working filter during the MembraneWashFilterTime.",
        ResolutionDescription->"Automatically set to the MembraneWashFilterInstrument as specified by the selected Method. If Method->Custom and MembraneWashTechnique is Filter, MembraneWashFilterInstrument is automatically set to Model[Instrument,PressureManifold,\"MPE2\"].",
        Category->"Fractionation"
      },
      {
        OptionName->MembraneWashFilterCentrifugeIntensity,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Speed"->Widget[
            Type->Quantity,
            Pattern:>RangeP[0*RPM,$MaxRoboticCentrifugeSpeed],(*automatically round it for them, then throw a warning telling them you did that, instead of giving a specific delta*)
            Units->Alternatives[RPM]
          ],
          "Force"->Widget[
            Type->Quantity,
            Pattern:>RangeP[0*GravitationalAcceleration,$MaxRoboticRelativeCentrifugalForce],
            Units->Alternatives[GravitationalAcceleration]
          ]
        ],
        Description->"The rotational speed or gravitational force at which the sample is centrifuged to flush the incubated (optional) MembraneWashSolution through the working filter during the MembraneWashFilterTime, in order to rinse away the non-membrane-bound protein contamination as much as possible.",
        ResolutionDescription->"Automatically set to the MembraneWashFilterCentrifugeIntensity as specified by the selected Method. If Method->Custom and MembraneWashTechnique is Filter, MembraneWashFilterCentrifugeIntensity is automatically set to the lesser of the MaxIntensity of the centrifuge model and the MaxCentrifugationForce of the MembraneWashFilter.",
        Category->"Fractionation"
      },
      {
        OptionName->MembraneWashFilterPressure,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0*PSI,$MaxRoboticAirPressure],
          Units->{PSI,{Pascal,Kilopascal,PSI,Millibar,Bar}}
        ],
        Description->"The amount of pressure applied to flush the incubated (optional) MembraneWashSolution through the working filter during the MembraneWashFilterTime, in order to rinse away the non-membrane-bound protein contamination as much as possible during MembraneWash.",
        ResolutionDescription->"Automatically set to the MembraneWashFilterFilterPressure as specified by the selected Method. If Method->Custom and MembraneWashTechnique is Filter, MembraneWashFilterPressure is automatically set to the lesser of the MaxPressure of the positive pressure model and the MaxPressure of the MembraneWashFilter.",
        Category->"Fractionation"
      },
      {
        OptionName->MembraneWashFilterTime,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0*Minute,$MaxExperimentTime],
          Units->Alternatives[Second,Minute,Hour]
        ],
        Description->"The duration of time for which force is applied to flush the incubated (optional) MembraneWashSolution through the working filter by the specified MembraneWashFilterTechnique and MembraneWashFilterInstrument,in order to rinse away the non-membrane-bound protein contamination as much as possible during MembraneWash.",
        ResolutionDescription->"Automatically set to the MembraneWashFilterTime as specified by the selected Method. If Method->Custom and MembraneWashTechnique is Filter, MembraneWashFilterTime is automatically set to 1 Minute.",
        Category->"Fractionation"
      },
      {
        OptionName -> MembraneWashFiltrateStorageCondition,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Condition" -> Widget[
            Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal
          ],
          "Objects" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"],"Storage Conditions"}
            }
          ]
        ],
        Description -> "The set of parameters that define the temperature, safety, and other environmental conditions under which the filtrate from incubated (optional) MembraneWashSolution during MembraneWash is stored upon completion of this protocol.",
        ResolutionDescription -> "Automatically set to the MembraneWashFiltrateStorageCondition specified by the selected Method. If Method is set to Custom and MembraneWashTechnique is Filter, MembraneWashFiltrateStorageCondition is automatically set to Disposal.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashFiltrateContainer,
        Default -> Automatic,
        AllowNull -> True,
        Widget->Alternatives[
          "Container"->Widget[
            Type->Object,
            Pattern:> ObjectP[{Object[Container],Model[Container]}]
          ],
          "Container with Index" -> {
            "Index"->Widget[
              Type->Number,
              Pattern:>GreaterEqualP[1,1]
            ],
            "Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Model[Container]}],
              PreparedSample->False,
              PreparedContainer->False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container],Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type->Enumeration,
              Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
              PatternTooltip->"Enumeration must be any well from A1 to P24."
            ],
            "Index and Container"->{
              "Index"->Widget[
                Type->Number,
                Pattern:>GreaterEqualP[1,1]
              ],
              "Container"->Widget[
                Type->Object,
                Pattern:>ObjectP[{Model[Container]}],
                PreparedSample->False,
                PreparedContainer->False
              ]
            }
          }
        ],
        Description -> "The container into which the used MembraneWashSolution, which is the filtrate resulted from filtering during membrane wash, is transferred. The filtrate possibly contains the carry-over cytosolic or nuclear components from last fractionation step (cytosolic fractionation or nuclear fractionation depending on the FractionationOrder).",
        ResolutionDescription -> "Automatically set to the same container model of the input samples, if MembraneWashTechnique is Filter.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashFiltrateLabel,
        Default -> Automatic,
        AllowNull -> True,
        Description->"A user defined word or phrase used to identify the sample which is the collected filtrate from filtering during membrane wash.",
        ResolutionDescription -> "Automatically set to \"membrane wash filtrate #\", if MembraneWashTechnique is Filter.",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Word
        ],
        Category->"Fractionation",
        UnitOperation->True
      },
      {
        OptionName -> MembraneWashFiltrateContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description->"A user defined word or phrase used to identify the container of the sample, which is the collected filtrate from filtering during membrane wash.",
        ResolutionDescription -> "Automatically set to \"membrane wash filtrate container #\", if MembraneWashTechnique is Filter.",
        Category -> "Fractionation",
        UnitOperation -> True
      },
      {
        OptionName -> MembraneWashCollectionContainerTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the sample collection container is maintained during the MembraneWashCollectionContainerEquilibrationTime before the supernatant from pelleting or the filtrate from filtering during each membrane wash is transferred into it.",
        ResolutionDescription -> "Automatically set to the MembraneWashCollectionContainerTemperature as specified by the selected Method. If Method->Custom, MembraneWashCollectionContainerTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneWashCollectionContainerEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> Alternatives[Second,Minute,Hour]],
        Description -> "The duration for which the the sample collection container is maintained at MembraneWashCollectionContainerTemperature before the supernatant from pelleting or the filtrate from filtering during each membrane wash is transferred into it.",
        ResolutionDescription -> "Automatically set to the MembraneWashCollectionContainerEquilibrationTime as specified by the selected Method. If Method->Custom, MembraneWashCollectionContainerEquilibrationTime is automatically set to 10 Minute.",
        Category -> "Fractionation"
      },

      (*--- FRACTIONATION --MEMBRANE-- Membrane Solubilization --- *)
      
      {
        OptionName-> MembraneSolubilizationSolution,
        AllowNull -> True,
        Default->Automatic,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          OpenPaths->{
            (*{Object[Catalog,"Root"],"Materials","Reagents","Molecular Biology","Lysis Buffers"}*)
            {Object[Catalog,"Root"],"Materials","Reagents"}
          }
        ],
        Description -> "The solution, usually containing mild and selective detergents, added to the pellet or filter from the optional membrane wash or the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder), in order to solubilize the integral and attached membrane proteins. If CellType is eukaryotic and if nuclear fractionation is to be performed after membrane fractionation, the MembraneSolubilizationSolution needs to have limited digestive power towards nuclear membrane.",
        ResolutionDescription -> "Automatically set as specified by the selected Method. If FractionationOrder contains Membrane and Method is set to Custom, automatically set to Model[Sample, \"RIPA Lysis and Extraction Buffer\"].",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneSolubilizationSolutionVolume,
        AllowNull -> True,
        Widget->Alternatives[
          Widget[Type->Quantity, Pattern:>RangeP[0 Microliter,$MaxRoboticTransferVolume], Units->Alternatives[Microliter,Milliliter,Liter]],
          Widget[Type->Enumeration,Pattern:>Alternatives[All]]
        ],
        Default->Automatic,
        Description -> "The volume of MembraneSolubilizationSolution added to the pellet or filter from the optional membrane wash or the last fractionation step, in order to solubilize the integral and attached membrane proteins.",
        ResolutionDescription -> "Automatically set as specified by the selected Method. If MembraneSolubilizationSolution is not Null and Method is set to Custom, automatically set to 25% of the lesser of the input sample volume, or the maximum volume which can be added to the container without overfilling it.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneSolubilizationSolutionTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the MembraneSolubilizationSolution is maintained during the MembraneSolubilizationSolutionEquilibrationTime before addition to the pellet or filter.",
        ResolutionDescription -> "Automatically set to the MembraneSolubilizationSolutionTemperature as specified by the selected Method. If MembraneSolubilizationSolution is not Null and Method->Custom, MembraneSolubilizationSolutionTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneSolubilizationSolutionEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> Alternatives[Second, Minute, Hour]],
        Description -> "The duration for which the MembraneSolubilizationSolution is maintained at MembraneSolubilizationSolutionTemperature before addition to the pellet or filter.",
        ResolutionDescription -> "Automatically set to the MembraneSolubilizationSolutionTime as specified by the selected Method. If Method->Custom and MembraneSolubilizationSolutionTemperature is not Null or Ambient, MembraneSolubilizationSolutionTime is automatically set to 10 Minute.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneSolubilizationMixType,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake, Pipette, None]],
        Description -> "The manner in which the solution is mixed following the combination of MembraneSolubilizationSolution and the pellet from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder). None specifies that no mixing occurs each membrane solubilization mix. Only applicable when the technique for the previous step (either the optional membrane wash, or one of cytosolic frationation and nuclear fractionation depending on the fractionation order) is Pellet",
        ResolutionDescription -> "Automatically set to the MembraneSolubilizationMixType specified by the selected Method. If Method->Custom, technique of the last step is Pellet, and MembraneSolubilizationSolution is not Null, MembraneSolubilizationMixType is automatically set to Shake.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneSolubilizationMixRate,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 RPM,$MaxMixRate],Units->RPM],
        Description->"The rate at which the sample is mixed by the selected MembraneSolubilizationMixType during the MembraneSolubilizationMixTime.",
        ResolutionDescription->"Automatically set to the MembraneSolubilizationMixRate specified by the selected Method. If MembraneSolubilizationMixType is set to Shake, and Method is set to Custom, automatically set to 1000 RPM.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneSolubilizationMixTime,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute,$MaxExperimentTime],Units->Alternatives[Second,Minute,Hour]],
        Description->"The duration for which the sample is mixed by the selected MembraneSolubilizationMixType following the combination of MembraneSolubilizationSolution and the pellet from the previous step (either the optional membrane wash, or one of cytosolic frationation and nuclear fractionation depending on the fractionation order).",
        ResolutionDescription->"If MembraneSolubilizationMixType is set to Shake, automatically set to the MembraneSolubilizationMixTime specified by the selected Method. If MembraneSolubilizationMixType is set to Shake and Method is set to Custom, automatically set to 1 minute.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NumberOfMembraneSolubilizationMixes,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Number,Pattern:>RangeP[1,$MaxNumberOfMixes,1]],
        Description->"The number of times that the sample is mixed by pipetting the MembraneSolubilizationMixVolume up and down following the combination of MembraneSolubilizationSolution and the pellet from the previous step (either the optional membrane wash, or one of cytosolic frationation and nuclear fractionation depending on the fractionation order).",
        ResolutionDescription->"Automatically set to the NumberOfMembraneSolubilizationMixes specified by the selected Method. If MembraneSolubilizationMixType is set to Pipette and Method is set to Custom, automatically set to 10.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneSolubilizationMixVolume,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,$MaxMicropipetteVolume],Units->Alternatives[Microliter,Milliliter]],
        Description->"The volume of the combination of MembraneSolubilizationSolution and the pellet from the previous step (either the optional membrane wash, or one of cytosolic frationation and nuclear fractionation depending on the fractionation order) displaced during each mix-by-pipette mix cycle.",
        ResolutionDescription->"Automatically set to the MembraneSolubilizationMixVolume specified by the selected Method. If Method is set to Custom and MembraneSolubilizationMixType is set to Pipette, MembraneSolubilizationMixVolume is automatically set to 50% of the MembraneSolubilizationSolutionVolume.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneSolubilizationMixTemperature,
        Default->Automatic,
        AllowNull->True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the Instrument heating or cooling the combination of MembraneSolubilizationSolution and the pellet from the previous step (either the optional membrane wash, or one of cytosolic frationation and nuclear fractionation depending on the fractionation order) is maintained during the MembraneSolubilizationMixTime, which occurs immediately before the MembraneSolubilizationTime (or MembraneFractionationPelletTime if MembraneSolubilizationTime is Null or 0 Minute).",
        ResolutionDescription->"Automatically set to the MembraneSolubilizationMixTemperature specified by the selected Method. If Method is set to Custom and MembraneSolubilizationMixType is not None, MembraneSolubilizationMixTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },
      {
        OptionName->MembraneSolubilizationTime,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute,$MaxExperimentTime],Units->Alternatives[Second,Minute,Hour]],
        Description->"The duration for which the instrument heating or cooling the filter with added MembraneSolubilizationSolution or the mixed pellet and the MembraneSolubilizationSolution is maintained at the MembraneSolubilizationTemperature to facilitate solubilization of the integral or attached membrane proteins. The MembraneSolubilizationTime occurs immediately after MembraneSolubilizationMixTime.",
        ResolutionDescription->"Automatically set to the MembraneSolubilizationIncubationTime specified by the selected Method. If MembraneSolubilizationSolution is not Null and Method is set to Custom, automatically set to 10 Minute.",
        Category -> "Fractionation"
      },
      {
        OptionName->MembraneSolubilizationTemperature,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Temperature"->Widget[Type->Quantity, Pattern:>RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units->Alternatives[Celsius,Fahrenheit]],
          "Ambient"->Widget[Type->Enumeration, Pattern:>Alternatives[Ambient]]
        ],
        Description->"The temperature at which the Instrument heating or cooling the mixed pellet and the MembraneSolubilizationSolution is maintained during the MembraneSolubilizationTime.",
        ResolutionDescription->"Automatically set to the MembraneSolubilizationTemperature specified by the selected Method. If Method is set to Custom and MembraneSolubilizationTime is not Null or 0 Second, MembraneSolubilizationTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },

      (*--- FRACTIONATION --MEMBRANE-- Membrane Fractionation --- *)

      {
        OptionName -> MembraneFractionationTechnique,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> Pellet | Filter
        ],
        Description -> "The type of force used to separate membrane fraction containing solubilized membrane proteins apart from insoluble fractions and components including cell debris and possibly intact nuclei if Nuclear is not preceding Membrane in FractionationOrder. Options include Pellet and Filter. With Pellet, the soluble membrane fraction is separated out by centrifugation as the supernatant. With Filter, the membrane fraction is collected as filtrate by applying a positive pressure to force the sample through a solid phase separation column. When MembraneFractionationTechnique is set to Null, no membrane fractionation step is performed.",
        ResolutionDescription -> "Automatically set to the MembraneFractionationTechnique specified by the selected Method. If Method is set to Custom, MembraneFractionationTechnique is automatically set to the same as MembraneSolubilizationTechnique.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneFractionationPelletInstrument,
        Default -> Automatic,
        Description-> "The centrifuge instrument that is used to pellet the insoluble components, including cell debris and possibly intact nuclei if Nuclear is not preceding Membrane in FractionationOrder, and to separate the membrane fraction containing the solubilized membrane-bound proteins as the supernatant during MembraneFractionation.",
        ResolutionDescription -> "Automatically set to the MembraneFractionationPelletInstrument specified by the selected Method. If Method is set to Custom and MembraneFractionationTechnique is Pellet, MembraneFractionationPelletInstrument is automatically set to the robotic integrated centrifuge, Model[Instrument, Centrifuge, \"HiG4\"].",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Instrument], Model[Instrument]}],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Instruments", "Centrifugation", "Microcentrifuges"}
          }
        ],
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneFractionationPelletIntensity,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The rotational speed or the force that is applied to the samples in order to pellet the insoluble components, including cell debris and possibly intact nuclei if Nuclear is not preceding Membrane in FractionationOrder, and to separate the membrane fraction containing the solubilized membrane-bound proteins as the supernatant during MembraneFractionation.",
        ResolutionDescription -> "Automatically set to the MembraneFractionationPelletIntensity specified by the selected Method. If Method->Custom and MembraneFractionationTechnique is Pellet, MembraneFractionationPelletIntensity is automatically set to 3600 GravitationalAcceleration.",
        Widget -> Alternatives[
          "Revolutions per Minute" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 RPM, $MaxCentrifugeSpeed],
            Units -> Alternatives[RPM]
          ],
          "Relative Centrifugal Force" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 GravitationalAcceleration, $MaxRelativeCentrifugalForce],
            Units -> Alternatives[GravitationalAcceleration]
          ]
        ],
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneFractionationPelletTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the sample is subject to the MembraneFractionationPelletIntensity in order to pellet the insoluble components, including cell debris and possibly intact nuclei if Nuclear is not preceding Membrane in FractionationOrder, and to separate the membrane fraction containing the solubilized membrane-bound proteins as the supernatant during MembraneFractionation.",
        ResolutionDescription -> "Automatically set to the MembraneFractionationPelletTime specified by the selected Method. If Method->Custom and MembraneFractionationTechnique is Pellet, MembraneFractionationPelletTime is automatically set based on CellType. For mammalian cells, MembraneFractionationPelletTime is automatically set to 10 Minute; for bacterial cells and yeast, MembraneFractionationPelletTime is automatically set to 45 Minute; for other cell types, MembraneFractionationPelletTime is automatically set to 15 Minute.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneFractionationSupernatantVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Volume" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
            Units -> Alternatives[Microliter, Milliliter, Liter]],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ]
        ],
        Description -> "The amount of supernatant that contains the membrane fraction to be transferred to MembraneFractionationSupernatantContainer after pelleting during membrane fractionation.",
        ResolutionDescription -> "Automatically set to the MembraneFractionationSupernatantVolume specified by the selected Method. If Method is set to Custom and MembraneFractionationTechnique is Pellet, MembraneFractionationSupernatantVolume is automatically set to 90% of current volume.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneFractionationSupernatantStorageCondition,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Condition" -> Widget[
            Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal
          ],
          "Objects" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"],
                "Storage Conditions"}
            }
          ]
        ],
        Description -> "The set of parameters that define the temperature, safety, and other environmental conditions under which the supernatant from pelleting the sample during MembraneFractionation is stored upon completion of this protocol.",
        ResolutionDescription -> "Automatically set to the MembraneFractionationSupernatantStorageCondition specified by the selected Method. If Method is set to Custom and MembraneFractionationTechnique is Pellet, MembraneFractionationSupernatantStorageCondition is automatically set to Freezer.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneFractionationSupernatantContainer,
        Default -> Automatic,
        AllowNull -> True,
        Widget->Alternatives[
          "Container"->Widget[
            Type->Object,
            Pattern:> ObjectP[{Object[Container],Model[Container]}]
          ],
          "Container with Index" -> {
            "Index"->Widget[
              Type->Number,
              Pattern:>GreaterEqualP[1,1]
            ],
            "Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Model[Container]}],
              PreparedSample->False,
              PreparedContainer->False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container],Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type->Enumeration,
              Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
              PatternTooltip->"Enumeration must be any well from A1 to P24."
            ],
            "Index and Container"->{
              "Index"->Widget[
                Type->Number,
                Pattern:>GreaterEqualP[1,1]
              ],
              "Container"->Widget[
                Type->Object,
                Pattern:>ObjectP[{Model[Container]}],
                PreparedSample->False,
                PreparedContainer->False
              ]
            }
          }
        ],
        Description -> "The container into which the supernatant from pelleting during membrane fractionation is transferred.",
        ResolutionDescription -> "Automatically set to the same container model of the input samples if MembraneFractionationTechnique is Pellet.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneFractionationSupernatantLabel,
        Default -> Automatic,
        AllowNull -> True,
        Description->"A user defined word or phrase used to identify the sample which is the collected supernatant from pelleting during membrane fractionation.",
        ResolutionDescription -> "Automatically set to \"membrane fractionation supernatant #\" and MembraneFractionationTechnique is Pellet.",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Word
        ],
        Category->"Fractionation",
        UnitOperation->True
      },
      {
        OptionName -> MembraneFractionationSupernatantContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description->"A user defined word or phrase used to identify the container of the sample, which is the collected supernatant from pelleting during membrane fractionation.",
        ResolutionDescription -> "Automatically set to \"membrane fractionation supernatant container #\" and MembraneFractionationTechnique is Pellet.",
        Category -> "Fractionation",
        UnitOperation -> True
      },
      {
        OptionName->MembraneFractionationFilterTechnique,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>Centrifuge|AirPressure
        ],
        Description->"The type of force used to flush the sample from membrane solubilization through the FractionationFilter in order to retain the insoluble components on the filter and to separate the membrane fraction containing solubilized membrane-bound proteins as the filtrate during MembraneFractionation.",
        ResolutionDescription->"Automatically set to the MembraneFractionationFilterTechnique as specified by the selected Method. If Method->Custom and MembraneFractionationTechnique is Filter, MembraneFractionationTechnique is automatically set to AirPressure.",
        Category->"Fractionation"
      },
      {
        OptionName->MembraneFractionationFilterInstrument,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            Model[Instrument,Centrifuge],Object[Instrument,Centrifuge],
            Model[Instrument,PressureManifold],Object[Instrument,PressureManifold]
          }],
          OpenPaths->{
            {Object[Catalog,"Root"],"Instruments","Centrifugation","Microcentrifuges"},
            {Object[Catalog,"Root"],"Instruments","Dead-End Filtering Devices"}
          }
        ],
        Description->"The Instrument that generates force to flush the sample from membrane solubilization through the FractionationFilter during the MembraneFractionationFilterTime.",
        ResolutionDescription->"Automatically set to the MembraneFractionationFilterInstrument as specified by the selected Method. If Method->Custom and MembraneFractionationTechnique is Filter, MembraneFractionationFilterInstrument is automatically set to Model[Instrument,PressureManifold,\"MPE2\"].",
        Category->"Fractionation"
      },
      {
        OptionName->MembraneFractionationFilterCentrifugeIntensity,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Speed"->Widget[
            Type->Quantity,
            Pattern:>RangeP[0*RPM,$MaxRoboticCentrifugeSpeed],(*automatically round it for them, then throw a warning telling them you did that, instead of giving a specific delta*)
            Units->Alternatives[RPM]
          ],
          "Force"->Widget[
            Type->Quantity,
            Pattern:>RangeP[0*GravitationalAcceleration,$MaxRoboticRelativeCentrifugalForce],
            Units->Alternatives[GravitationalAcceleration]
          ]
        ],
        Description->"The rotational speed or gravitational force at which the sample is centrifuged to flush the sample from membrane solubilization through the FractionationFilter during the MembraneFractionationFilterTime, in order to retain the insoluble components on the filter and to separate the membrane fraction containing the solubilized membrane-bound proteins as the filtrate during MembraneFractionation.",
        ResolutionDescription->"Automatically set to the MembraneFractionationFilterCentrifugeIntensity as specified by the selected Method. If Method->Custom and MembraneFractionationTechnique is Filter, MembraneFractionationFilterCentrifugeIntensity is automatically set to the lesser of the MaxIntensity of the centrifuge model and the MaxCentrifugationForce of the MembraneFractionationFilter.",
        Category->"Fractionation"
      },
      {
        OptionName->MembraneFractionationFilterPressure,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0*PSI,$MaxRoboticAirPressure],
          Units->{PSI,{Pascal,Kilopascal,PSI,Millibar,Bar}}
        ],
        Description->"The amount of pressure applied to flush the sample from membrane solubilization through the through the FractionationFilter during the MembraneFractionationFilterTime, in order to retain the insoluble components on the filter and to separate the membrane fraction containing the solubilized membrane-bound proteins as the filtrate during MembraneFractionation.",
        ResolutionDescription->"Automatically set to the MembraneFractionationFilterFilterPressure as specified by the selected Method. If Method->Custom and MembraneFractionationTechnique is Filter, MembraneFractionationFilterPressure is automatically set to the lesser of the MaxPressure of the positive pressure model and the MaxPressure of the MembraneFractionationFilter.",
        Category->"Fractionation"
      },
      {
        OptionName->MembraneFractionationFilterTime,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0*Minute,$MaxExperimentTime],
          Units->Alternatives[Second,Minute,Hour]
        ],
        Description->"The duration of time for which force is applied to flush the sample from membrane solubilization through the through the FractionationFilter by the specified MembraneFractionationFilterTechnique and MembraneFractionationFilterInstrument,in order to retain the insoluble components on the filter and to separate the membrane fraction containing the solubilized membrane-bound proteins as the filtrate during MembraneFractionation.",
        ResolutionDescription->"Automatically set to the MembraneFractionationFilterTime as specified by the selected Method. If Method->Custom and MembraneFractionationTechnique is Filter, MembraneFractionationFilterTime is automatically set to 1 Minute.",
        Category->"Fractionation"
      },
      {
        OptionName -> MembraneFractionationFiltrateStorageCondition,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Condition" -> Widget[
            Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal
          ],
          "Objects" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"],"Storage Conditions"}
            }
          ]
        ],
        Description -> "The set of parameters that define the temperature, safety, and other environmental conditions under which the filtrate from filtering the the sample from membrane solubilization during MembraneFractionation is stored upon completion of this protocol.",
        ResolutionDescription -> "Automatically set to the MembraneFractionationFiltrateStorageCondition specified by the selected Method. If Method is set to Custom and MembraneFractionationTechnique is Filter, MembraneFractionationFiltrateStorageCondition is automatically set to Freezer.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneFractionationFiltrateContainer,
        Default -> Automatic,
        AllowNull -> True,
        Widget->Alternatives[
          "Container"->Widget[
            Type->Object,
            Pattern:> ObjectP[{Object[Container],Model[Container]}]
          ],
          "Container with Index" -> {
            "Index"->Widget[
              Type->Number,
              Pattern:>GreaterEqualP[1,1]
            ],
            "Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Model[Container]}],
              PreparedSample->False,
              PreparedContainer->False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container],Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type->Enumeration,
              Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
              PatternTooltip->"Enumeration must be any well from A1 to P24."
            ],
            "Index and Container"->{
              "Index"->Widget[
                Type->Number,
                Pattern:>GreaterEqualP[1,1]
              ],
              "Container"->Widget[
                Type->Object,
                Pattern:>ObjectP[{Model[Container]}],
                PreparedSample->False,
                PreparedContainer->False
              ]
            }
          }
        ],
        Description -> "The container into which the filtrate from filtering during membrane fractionation is transferred.",
        ResolutionDescription -> "Automatically set to the same container model of the input samples if MembraneFractionationTechnique is Filter.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneFractionationFiltrateLabel,
        Default -> Automatic,
        AllowNull -> True,
        Description->"A user defined word or phrase used to identify the sample which is the collected filtrate from filtering during membrane fractionation.",
        ResolutionDescription -> "Automatically set to \"membrane fractionation filtrate #\" if MembraneFractionationTechnique is Filter.",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Word
        ],
        Category->"Fractionation",
        UnitOperation->True
      },
      {
        OptionName -> MembraneFractionationFiltrateContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description->"A user defined word or phrase used to identify the container of the sample, which is the collected filtrate from filtering during membrane fractionation.",
        ResolutionDescription -> "Automatically set to \"membrane fractionation filtrate container #\" if MembraneFractionationTechnique is Filter.",
        Category -> "Fractionation",
        UnitOperation -> True
      },
      {
        OptionName -> MembraneFractionationCollectionContainerTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the sample collection container is maintained during the MembraneFractionationCollectionContainerEquilibrationTime before the supernatant or filtrate sample from pelleting or filtering during membrane fractionation is transferred into it.",
        ResolutionDescription -> "Automatically set to the MembraneFractionationCollectionContainerTemperatureTemperature as specified by the selected Method. If Method->Custom and Membrane is a member of FractionationOrder, MembraneFractionationCollectionContainerTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },
      {
        OptionName -> MembraneFractionationCollectionContainerEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> Alternatives[Second, Minute, Hour]],
        Description -> "The duration for which the the sample collection container is maintained at MembraneFractionationCollectionContainerTemperature before the supernatant or filtrate sample from pelleting or filtering during membrane fractionation is transferred into it.",
        ResolutionDescription -> "Automatically set to the MembraneFractionationCollectionContainerEquilibrationTime as specified by the selected Method. If Method->Custom and MembraneFractionationCollectionContainerTemperature is not Ambient or Null, MembraneFractionationCollectionContainerEquilibrationTime is automatically set to 10 Minute.",
        Category -> "Fractionation"
      },

      (*--- FRACTIONATION --NUCLEAR-- Nuclear wash --- *)

      {
        OptionName->NumberOfNuclearWashes,
        Default->Automatic,
        Description->"The number of times the pellet or filter from cytosolic fractionation or membrane fractionation, depending on the FractionationOrder, is rinsed in order to remove non-nuclear protein contamination as much as possible. The pellet is rinsed by adding NuclearWashSolution, mixing, incubating (optional), pelleting, and aspirating. The filter is rinsed by adding NuclearWashSolution, incubating, and filtering.",
        ResolutionDescription->"Automatically set to the NumberOfNuclearWashes as specified by the selected Method. If FractionationOrder contains Nuclear and Method->Custom, NumberOfNuclearWashes is automatically set to 1.",
        AllowNull->True,
        Widget->Widget[Type->Number,Pattern:>RangeP[1,20,1]],
        Category -> "Fractionation"
      },
      {
        OptionName-> NuclearWashSolution,
        AllowNull -> True,
        Default->Automatic,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          OpenPaths->{
            {Object[Catalog,"Root"],"Materials","Reagents","Buffers"}
          }
        ],
        Description -> "The solution used to rinse the the pellet or filter from the last fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder) in order to remove non-nuclear protein contamination as much as possible.",
        ResolutionDescription -> "Automatically set as specified by the selected Method. If the NumberOfNuclearWashes is not Null and Method is set to Custom, automatically set to Model[Sample, StockSolution, \"1x PBS (Phosphate Buffer Saline), Autoclaved\"].",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashSolutionVolume,
        AllowNull -> True,
        Widget->Alternatives[
          Widget[Type->Quantity, Pattern:>RangeP[0 Microliter,$MaxRoboticTransferVolume], Units->Alternatives[Microliter,Milliliter,Liter]],
          Widget[Type->Enumeration,Pattern:>Alternatives[All]]
        ],
        Default->Automatic,
        Description -> "The volume of NuclearWashSolution added to rinse the pellet or filter from the last fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder), in order to remove non-nuclear protein contamination as much as possible.",
        ResolutionDescription -> "Automatically set as specified by the selected Method. If the NumberOfNuclearWashes is not Null and Method is set to Custom, automatically set to the lesser of the input sample volume, or half of the maximum volume which can be added to the pellet container or the filter.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashSolutionTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the NuclearWashSolution is maintained during the NuclearWashSolutionEquilibrationTime before addition to the pellet or filter in order to rinse during each nuclear wash.",
        ResolutionDescription -> "Automatically set to the NuclearWashSolutionTemperature as specified by the selected Method. If the NumberOfNuclearWashes is not Null and Method->Custom, NuclearWashSolutionTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashSolutionEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> Alternatives[Second, Minute, Hour]],
        Description -> "The duration for which the NuclearWashSolution is maintained at NuclearWashSolutionTemperature before addition to the pellet or filter to rinse during each nuclear wash.",
        ResolutionDescription -> "Automatically set to the NuclearWashSolutionTime as specified by the selected Method. If NuclearWashSolutionTemperature is not Null or Ambient and Method->Custom, NuclearWashSolutionTime is automatically set to 10 Minute.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashMixType,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake, Pipette, None]],
        Description -> "The manner in which the solution is mixed following the combination of NuclearWashSolution and the pellet from the previous fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder). None specifies that no mixing occurs each nuclear wash. Only applicable when the previous fractionation technique is Pellet.",
        ResolutionDescription -> "Automatically set to the NuclearWashMixType specified by the selected Method. If the NumberOfNuclearWashes is not Null and Method is set to Custom and the previous fractionation technique is set to Pellet, NuclearWashMixType is automatically set to Shake. If Method is set to Custom, NumberOfNuclearWashes is not Null, and the previous fractionation technique is Filter, NuclearWashMixType is automatically set to None.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashMixRate,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 RPM,$MaxMixRate],Units->RPM],
        Description->"The rate at which the sample is mixed by the selected NuclearWashMixType during the NuclearWashMixTime.",
        ResolutionDescription->"Automatically set to the NuclearWashMixRate specified by the selected Method. If Method is set to Custom and NuclearWashMixType is set to Shake, NuclearWashMixRate is automatically set to 1000 RPM.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashMixTime,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute,$MaxExperimentTime],Units->Alternatives[Second,Minute,Hour]],
        Description->"The duration for which the sample is mixed by the selected NuclearWashMixType following the combination of NuclearWashSolution and the pellet from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder).",
        ResolutionDescription->"If NuclearWashMixType is set to Shake, automatically set to the NuclearWashMixTime specified by the selected Method. If NuclearWashMixType is set to Shake and Method is set to Custom, automatically set to 1 minute.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NumberOfNuclearWashMixes,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Number,Pattern:>RangeP[1,$MaxNumberOfMixes,1]],
        Description->"The number of times that the sample is mixed by pipetting the NuclearWashMixVolume up and down following the combination of NuclearWashSolution and the pellet from the last fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder).",
        ResolutionDescription->"If NuclearWashMixType is set to Pipette, automatically set to the NumberOfNuclearWashMixes specified by the selected Method. If NuclearWashMixType is set to Pipetting and Method is set to Custom, automatically set to 10.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashMixVolume,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,$MaxMicropipetteVolume],Units->Alternatives[Microliter,Milliliter]],
        Description->"The volume of the combination of NuclearWashSolution and the pellet from the last fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder) displaced during each mix-by-pipette mix cycle.",
        ResolutionDescription->"Automatically set to NuclearWashMixVolume specified by the selected Method. If Method is set to Custom and NuclearWashMixType is set to Pipette, NuclearWashMixVolume is automatically set to 50% of the NuclearWashSolutionVolume.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashMixTemperature,
        Default->Automatic,
        AllowNull->True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the instrument heating or cooling the combination of NuclearWashSolution and the pellet from the last fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder) is maintained during the NuclearWashMixTime, which occurs immediately before the NuclearWashIncubationTime or NuclearWashPelletTime if NuclearWashIncubationTime is Null or 0 Minute.",
        ResolutionDescription->"Automatically set to NuclearWashMixTemperature specified by the selected Method. If Method is set to Custom and NuclearWashMixType is not None, NuclearWashMixTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },
      {
        OptionName->NuclearWashIncubationTime,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute,$MaxExperimentTime],Units->Alternatives[Second,Minute,Hour]],
        Description->"The minimum duration for which the Instrument heating or cooling the mixed pellet and the NuclearWashSolution is maintained at the NuclearWashIncubationTemperature to facilitate washing of the pellet in order to remove non-nuclear protein contamination as much as possible. The NuclearWashIncubationTime occurs immediately after NuclearWashMixTime.",
        ResolutionDescription->"Automatically set to the NuclearWashIncubationTime specified by the selected Method. If the Method is set to Custom, automatically set to Null.",
        Category -> "Fractionation"
      },
      {
        OptionName->NuclearWashIncubationTemperature,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Temperature"->Widget[Type->Quantity, Pattern:>RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units->Alternatives[Celsius,Fahrenheit]],
          "Ambient"->Widget[Type->Enumeration, Pattern:>Alternatives[Ambient]]
        ],
        Description->"The temperature at which the instrument heating or cooling the mixed pellet and the NuclearWashSolution is maintained during the NuclearWashIncubationTime.",
        ResolutionDescription->"Automatically set to the NuclearWashIncubationTemperature specified by the selected Method. If Method is set to Custom and NuclearWashIncubationTime > 0 Second, NuclearWashIncubationTemperature is automatically set to 4 Celsius. For 0 or Null NuclearWashIncubationTime, NuclearWashIncubationTemperature is automatically set to Null.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashSeparationTechnique,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> Pellet | Filter
        ],
        Description -> "The type of force used to separate the insoluble components and to separate the possibly remaining cytosolic fraction or membrane fraction (depending on the FractionationOrder). Options include Pellet and Filter. With Pellet, the possibly remaining cytosolic fraction or membrane fraction is separated out by centrifugation as the supernatant from the intact nuclei. With Filter, the possibly remaining cytosolic fraction or membrane fraction is collected as filtrate by applying a positive pressure to force the sample through a solid phase separation column. If last used technique is Pellet, NuclearWashTechnique can be Pellet or Filter. However, if last used technique is Filter, NuclearWashTechnique can only be Filter.",
        ResolutionDescription -> "Automatically set to the NuclearWashTechnique specified by the selected Method. If the NumberOfNuclearWashes is not Null and Method is set to Custom, NuclearWashTechnique is automatically set to the same as the last technique option, i.e. CytosolicFractionationTehchnique or NuclearFractionationTechnique, depending on the FractionationOrder.",
        Category -> "Fractionation"
      },
      {
        OptionName ->NuclearWashPelletInstrument,
        Default -> Automatic,
        Description-> "The centrifuge instrument that is used to pellet the insoluble components and intact nuclei and to separate the possibly remaining cytosolic fraction or membrane fraction (depending on the FractionationOrder) rinsed into the NuclearWashSolution as the supernatant during each nuclear wash.",
        ResolutionDescription -> "Automatically set to the NuclearWashPelletInstrument specified by the selected Method. If Method is set to Custom and NuclearWashSeparationTechnique is Pellet, NuclearWashPelletInstrument is automatically set to the robotic integrated centrifuge, Model[Instrument, Centrifuge, \"HiG4\"].",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Instrument], Model[Instrument]}],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Instruments", "Centrifugation", "Microcentrifuges"}
          }
        ],
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashPelletIntensity,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The rotational speed or the force that is applied to the samples in order to pellet the insoluble components and intact nuclei and to separate the possibly remaining cytosolic fraction or membrane fraction (depending on the FractionationOrder) rinsed into the NuclearWashSolution as the supernatant during each nuclear wash.",
        ResolutionDescription -> "Automatically set to the NuclearWashPelletIntensity specified by the selected Method. If Method->Custom and NuclearWashSeparationTechnique is Pellet, NuclearWashPelletIntensity is automatically set to 3600 GravitationalAcceleration.",
        Widget -> Alternatives[
          "Revolutions per Minute" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 RPM, $MaxRoboticCentrifugeSpeed],
            Units -> Alternatives[RPM]
          ],
          "Relative Centrifugal Force" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 GravitationalAcceleration, $MaxRoboticRelativeCentrifugalForce],
            Units -> Alternatives[GravitationalAcceleration]
          ]
        ],
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashPelletTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the sample is subject to the NuclearWashPelletIntensity in order to pellet the insoluble components and intact nuclei and to separate the possibly remaining cytosolic fraction or membrane fraction (depending on the FractionationOrder) rinsed into the NuclearWashSolution as the supernatant during each nuclear wash.",
        ResolutionDescription -> "Automatically set to the NuclearWashPelletTime specified by the selected Method. If Method->Custom and NuclearWashSeparationTechnique is Pellet,, NuclearWashPelletTime is automatically set based on CellType. For mammalian cells, NuclearWashPelletTime is automatically set to 10 Minute; for bacterial cells and yeast, NuclearWashPelletTime is automatically set to 45 Minute.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashSupernatantVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Volume" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
            Units -> Alternatives[Microliter, Milliliter, Liter]],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ]
        ],
        Description -> "The amount of supernatant that contains the possibly remaining cytosolic fraction or membrane fraction (depending on the FractionationOrder) to be transferred to NuclearWashSupernatantContainer after pelleting during each nuclear wash.",
        ResolutionDescription -> "Automatically set to the NuclearWashSupernatantVolume specified by the selected Method. If Method is set to Custom and NuclearWashTechnique is Pellet, automatically set to All if NumberOfNuclearWashes is not Null.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashSupernatantContainer,
        Default -> Automatic,
        AllowNull -> True,
        Widget->Alternatives[
          "Container"->Widget[
            Type->Object,
            Pattern:> ObjectP[{Object[Container],Model[Container]}]
          ],
          "Container with Index" -> {
            "Index"->Widget[
              Type->Number,
              Pattern:>GreaterEqualP[1,1]
            ],
            "Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Model[Container]}],
              PreparedSample->False,
              PreparedContainer->False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container],Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type->Enumeration,
              Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
              PatternTooltip->"Enumeration must be any well from A1 to P24."
            ],
            "Index and Container"->{
              "Index"->Widget[
                Type->Number,
                Pattern:>GreaterEqualP[1,1]
              ],
              "Container"->Widget[
                Type->Object,
                Pattern:>ObjectP[{Model[Container]}],
                PreparedSample->False,
                PreparedContainer->False
              ]
            }
          }
        ],
        Description -> "The container into which the used NuclearWashSolution containing the possibly remaining cytosolic fraction or membrane fraction (depending on the FractionationOrder), which is the supernatant from pelleting during each nuclear wash, is transferred.",
        ResolutionDescription -> "Automatically set to the container found by PreferredContainer that is capable of holding the volume of NumberOfNuclearWashes*NuclearWashSupernatantTransferVolume, if NuclearWashTechnique is Pellet.",
        Category -> "Fractionation"
      },
      {
        OptionName->NuclearWashSupernatantLabel,
        Default->Automatic,
        AllowNull->True,
        Description->"A user defined word or phrase used to identify the sample which is the collected supernatant from pelleting during each nuclear wash.",
        ResolutionDescription -> "Automatically set to \"nuclear wash supernatant #\" if NuclearWashSupernatantVolume is not Null or 0.",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Word
        ],
        Category->"Fractionation",
        UnitOperation->True
      },
      {
        OptionName->NuclearWashSupernatantContainerLabel,
        Default->Automatic,
        AllowNull->True,
        Description->"A user defined word or phrase used to identify the container of the sample, which is the collected supernatant from pelleting during each nuclear wash.",
        ResolutionDescription -> "Automatically set to \"nuclear wash supernatant container #\" if NuclearWashSupernatantVolume is not Null or 0.",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Word
        ],
        Category->"Fractionation",
        UnitOperation->True
      },
      {
        OptionName -> NuclearWashSupernatantStorageCondition,
        Default -> Automatic,
        Description -> "The non-default condition under which the collected supernatant sample from pelleting during each nuclear wash is stored after the protocol is completed.",
        ResolutionDescription -> "Automatically set to Disposal if NumberOfNuclearWashes>0.",
        AllowNull -> True,
        Widget -> Alternatives[
          "Condition" -> Widget[
            Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal
          ],
          "Objects" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"],"Storage Conditions"}
            }
          ]
        ],
        Category -> "Post Experiment"
      },
      {
        OptionName->NuclearWashFilterTechnique,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>Centrifuge|AirPressure
        ],
        Description->"The type of force used to flush the incubated (optional) NuclearWashSolution through the working filter from the last fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder) in order to rinse away the non-nuclear protein contamination as much as possible.",
        ResolutionDescription->"Automatically set to the NuclearWashFilterTechnique as specified by the selected Method. If Method->Custom and NuclearWashTechnique is Filter, NuclearWashTechnique is automatically set to AirPressure.",
        Category->"Fractionation"
      },
      {
        OptionName->NuclearWashFilterInstrument,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            Model[Instrument,Centrifuge],Object[Instrument,Centrifuge],
            Model[Instrument,PressureManifold],Object[Instrument,PressureManifold]
          }],
          OpenPaths->{
            {Object[Catalog,"Root"],"Instruments","Centrifugation","Microcentrifuges"},
            {Object[Catalog,"Root"],"Instruments","Dead-End Filtering Devices"}
          }
        ],
        Description->"The Instrument that generates force to flush incubated (optional) NuclearWashSolution through the working filter during the NuclearWashFilterTime.",
        ResolutionDescription->"Automatically set to the NuclearWashFilterInstrument as specified by the selected Method. If Method->Custom and NuclearWashTechnique is Filter, NuclearWashFilterInstrument is automatically set to Model[Instrument,PressureManifold,\"MPE2\"].",
        Category->"Fractionation"
      },
      {
        OptionName->NuclearWashFilterCentrifugeIntensity,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Speed"->Widget[
            Type->Quantity,
            Pattern:>RangeP[0*RPM,$MaxRoboticCentrifugeSpeed],(*automatically round it for them, then throw a warning telling them you did that, instead of giving a specific delta*)
            Units->Alternatives[RPM]
          ],
          "Force"->Widget[
            Type->Quantity,
            Pattern:>RangeP[0*GravitationalAcceleration,$MaxRoboticRelativeCentrifugalForce],
            Units->Alternatives[GravitationalAcceleration]
          ]
        ],
        Description->"The rotational speed or gravitational force at which the sample is centrifuged to flush the incubated (optional) NuclearWashSolution through the working filter during the NuclearWashFilterTime, in order to rinse away the non-nuclear protein contamination as much as possible.",
        ResolutionDescription->"Automatically set to the NuclearWashFilterCentrifugeIntensity as specified by the selected Method. If Method->Custom and NuclearWashTechnique is Filter, NuclearWashFilterCentrifugeIntensity is automatically set to the lesser of the MaxIntensity of the centrifuge model and the MaxCentrifugationForce of the NuclearWashFilter.",
        Category->"Fractionation"
      },
      {
        OptionName->NuclearWashFilterPressure,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0*PSI,$MaxRoboticAirPressure],
          Units->{PSI,{Pascal,Kilopascal,PSI,Millibar,Bar}}
        ],
        Description->"The amount of pressure applied to flush the incubated (optional) NuclearWashSolution through the working filter during the NuclearWashFilterTime, in order to rinse away the non-nuclear protein contamination as much as possible during NuclearWash.",
        ResolutionDescription->"Automatically set to the NuclearWashFilterFilterPressure as specified by the selected Method. If Method->Custom and NuclearWashTechnique is Filter, NuclearWashFilterPressure is automatically set to the lesser of the MaxPressure of the positive pressure model and the MaxPressure of the NuclearWashFilter.",
        Category->"Fractionation"
      },
      {
        OptionName->NuclearWashFilterTime,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0*Minute,$MaxExperimentTime],
          Units->Alternatives[Second,Minute,Hour]
        ],
        Description->"The duration of time for which force is applied to flush the incubated (optional) NuclearWashSolution through the working filter by the specified NuclearWashFilterTechnique and NuclearWashFilterInstrument,in order to rinse away the non-nuclear protein contamination as much as possible during NuclearWash.",
        ResolutionDescription->"Automatically set to the NuclearWashFilterTime as specified by the selected Method. If Method->Custom and NuclearWashTechnique is Filter, NuclearWashFilterTime is automatically set to 1 Minute.",
        Category->"Fractionation"
      },
      {
        OptionName -> NuclearWashFiltrateStorageCondition,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Condition" -> Widget[
            Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal
          ],
          "Objects" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"],"Storage Conditions"}
            }
          ]
        ],
        Description -> "The set of parameters that define the temperature, safety, and other environmental conditions under which the filtrate from incubated (optional) NuclearWashSolution during NuclearWash is stored upon completion of this protocol.",
        ResolutionDescription -> "Automatically set to the NuclearWashFiltrateStorageCondition specified by the selected Method. If Method is set to Custom and NuclearWashTechnique is Filter, NuclearWashFiltrateStorageCondition is automatically set to Freezer.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashFiltrateContainer,
        Default -> Automatic,
        AllowNull -> True,
        Widget->Alternatives[
          "Container"->Widget[
            Type->Object,
            Pattern:> ObjectP[{Object[Container],Model[Container]}]
          ],
          "Container with Index" -> {
            "Index"->Widget[
              Type->Number,
              Pattern:>GreaterEqualP[1,1]
            ],
            "Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Model[Container]}],
              PreparedSample->False,
              PreparedContainer->False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container],Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type->Enumeration,
              Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
              PatternTooltip->"Enumeration must be any well from A1 to P24."
            ],
            "Index and Container"->{
              "Index"->Widget[
                Type->Number,
                Pattern:>GreaterEqualP[1,1]
              ],
              "Container"->Widget[
                Type->Object,
                Pattern:>ObjectP[{Model[Container]}],
                PreparedSample->False,
                PreparedContainer->False
              ]
            }
          }
        ],
        Description -> "The container into which the used NuclearWashSolution, which is the filtrate from filtering during nuclear wash, is transferred. The filtrate possibly contains the carry-over cytosolic or membrane components from last fractionation step (cytosolic fractionation or membrane fractionation depending on the FractionationOrder).",
        ResolutionDescription -> "Automatically set to the same container model of the input samples, if NuclearWashTechnique is Filter.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashFiltrateLabel,
        Default -> Automatic,
        AllowNull -> True,
        Description->"A user defined word or phrase used to identify the sample which is the collected filtrate from filtering during nuclear wash.",
        ResolutionDescription -> "Automatically set to \"nuclear wash filtrate #\", if NuclearWashTechnique is Filter.",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Word
        ],
        Category->"Fractionation",
        UnitOperation->True
      },
      {
        OptionName -> NuclearWashFiltrateContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description->"A user defined word or phrase used to identify the container of the sample, which is the collected filtrate from filtering during nuclear wash.",
        ResolutionDescription -> "Automatically set to \"nuclear wash filtrate container #\", if NuclearWashTechnique is Filter.",
        Category -> "Fractionation",
        UnitOperation -> True
      },
      {
        OptionName -> NuclearWashCollectionContainerTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the sample collection container is maintained during the NuclearWashCollectionContainerEquilibrationTime before the supernatant from pelleting or the filtrate from filtering during each nuclear wash is transferred into it.",
        ResolutionDescription -> "Automatically set to the NuclearWashCollectionContainerTemperature as specified by the selected Method. If Method->Custom, NuclearWashCollectionContainerTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearWashCollectionContainerEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> Alternatives[Second,Minute,Hour]],
        Description -> "The duration for which the the sample collection container is maintained at NuclearWashCollectionContainerTemperature before the supernatant from pelleting or the filtrate from filtering during each nuclear wash is transferred into it.",
        ResolutionDescription -> "Automatically set to the NuclearWashCollectionContainerEquilibrationTime as specified by the selected Method. If Method->Custom, NuclearWashCollectionContainerEquilibrationTime is automatically set to 10 Minute.",
        Category -> "Fractionation"
      },

      (*--- FRACTIONATION --NUCLEAR-- Nuclear lysis --- *)

      {
        OptionName-> NuclearLysisSolution,
        AllowNull -> True,
        Default->Automatic,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          OpenPaths->{
            (*{Object[Catalog,"Root"],"Materials","Reagents","Molecular Biology","Lysis Buffers"}*)
            {Object[Catalog,"Root"],"Materials","Reagents"}
          }
        ],
        Description -> "The solution, usually containing mild and selective detergents, added to the pellet or filter from the optional nuclear wash or the last fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder), in order to break the nuclear envelope and release the components inside including nuclear proteins. Nucleic acids are commonly digested during nuclear lysis. If CellType is eukaryotic and if membrane fractionation is to be performed after nuclear fractionation, the NuclearLysisSolution needs to have limited solubilization power towards membrane-bound proteins.",
        ResolutionDescription -> "Automatically set as specified by the selected Method. If FractionationOrder contains Nuclear and Method is set to Custom, automatically set to Model[Sample, \"RIPA Lysis and Extraction Buffer\"].",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearLysisSolutionVolume,
        AllowNull -> True,
        Widget->Alternatives[
          Widget[Type->Quantity, Pattern:>RangeP[0 Microliter,$MaxRoboticTransferVolume], Units->Alternatives[Microliter,Milliliter,Liter]],
          Widget[Type->Enumeration,Pattern:>Alternatives[All]]
        ],
        Default->Automatic,
        Description -> "The volume of NuclearLysisSolution added to the pellet or filter from the optional nuclear wash or the last fractionation step, in order to break the nuclear envelope and release nuclear components including the proteins.",
        ResolutionDescription -> "Automatically set as specified by the selected Method. If NuclearLysisSolution is not Null and Method is set to Custom, automatically set to 25% of the lesser of the input sample volume, or the maximum volume which can be added to the container without overfilling it.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearLysisSolutionTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the NuclearLysisSolution is maintained during the NuclearLysisSolutionEquilibrationTime before addition to the pellet or filter.",
        ResolutionDescription -> "Automatically set to the NuclearLysisSolutionTemperature as specified by the selected Method. If NuclearLysisSolution is not Null and Method->Custom, NuclearLysisSolutionTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearLysisSolutionEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> Alternatives[Second, Minute, Hour]],
        Description -> "The duration for which the NuclearLysisSolution is maintained at NuclearLysisSolutionTemperature before addition to the pellet or filter.",
        ResolutionDescription -> "Automatically set to the NuclearLysisSolutionTime as specified by the selected Method. If Method->Custom and NuclearLysisSolutionTemperature is not Null or Ambient, NuclearLysisSolutionTime is automatically set to 10 Minute.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearLysisMixType,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake, Pipette, None]],
        Description -> "The manner in which the solution is mixed following the combination of NuclearLysisSolution and the pellet from the last fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder). None specifies that no mixing occurs each nuclear lysis mix. Only applicable when the technique for the previous step (either the optional nuclear wash, or one of cytosolic frationation and membrane fractionation depending on the fractionation order) is Pellet",
        ResolutionDescription -> "Automatically set to the NuclearLysisMixType specified by the selected Method. If Method->Custom, technique of the last step is Pellet, and NuclearLysisSolution is not Null, NuclearLysisMixType is automatically set to Shake.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearLysisMixRate,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 RPM,$MaxMixRate],Units->RPM],
        Description->"The rate at which the sample is mixed by the selected NuclearLysisMixType during the NuclearLysisMixTime.",
        ResolutionDescription->"Automatically set to the NuclearLysisMixRate specified by the selected Method. If NuclearLysisMixType is set to Shake, and Method is set to Custom, automatically set to 1000 RPM.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearLysisMixTime,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute,$MaxExperimentTime],Units->Alternatives[Second,Minute,Hour]],
        Description->"The duration for which the sample is mixed by the selected NuclearLysisMixType following the combination of NuclearLysisSolution and the pellet from the previous step (either the optional nuclear wash, or one of cytosolic frationation and membrane fractionation depending on the fractionation order).",
        ResolutionDescription->"If NuclearLysisMixType is set to Shake, automatically set to the NuclearLysisMixTime specified by the selected Method. If NuclearLysisMixType is set to Shake and Method is set to Custom, automatically set to 1 minute.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NumberOfNuclearLysisMixes,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Number,Pattern:>RangeP[1,$MaxNumberOfMixes,1]],
        Description->"The number of times that the sample is mixed by pipetting the NuclearLysisMixVolume up and down following the combination of NuclearLysisSolution and the pellet from the previous step (either the optional nuclear wash, or one of cytosolic frationation and membrane fractionation depending on the fractionation order).",
        ResolutionDescription->"Automatically set to the NumberOfNuclearLysisMixes specified by the selected Method. If NuclearLysisMixType is set to Pipette and Method is set to Custom, automatically set to 10.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearLysisMixVolume,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,$MaxMicropipetteVolume],Units->Alternatives[Microliter,Milliliter]],
        Description->"The volume of the combination of NuclearLysisSolution and the pellet from the previous step (either the optional nuclear wash, or one of cytosolic frationation and membrane fractionation depending on the fractionation order) displaced during each mix-by-pipette mix cycle.",
        ResolutionDescription->"Automatically set to the NuclearLysisMixVolume specified by the selected Method. If Method is set to Custom and NuclearLysisMixType is set to Pipette, NuclearLysisMixVolume is automatically set to 50% of the NuclearLysisSolutionVolume.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearLysisMixTemperature,
        Default->Automatic,
        AllowNull->True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the Instrument heating or cooling the combination of NuclearLysisSolution and the pellet from the previous step (either the optional nuclear wash, or one of cytosolic frationation and membrane fractionation depending on the fractionation order) is maintained during the NuclearLysisMixTime, which occurs immediately before the NuclearLysisTime (or NuclearFractionationPelletTime if NuclearLysisTime is Null or 0 Minute).",
        ResolutionDescription->"Automatically set to the NuclearLysisMixTemperature specified by the selected Method. If Method is set to Custom and NuclearLysisMixType is not None, NuclearLysisMixTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },
      {
        OptionName->NuclearLysisTime,
        Default->Automatic,
        AllowNull->True,
        Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute,$MaxExperimentTime],Units->Alternatives[Second,Minute,Hour]],
        Description->"The duration for which the instrument heating or cooling the filter with added NuclearLysisSolution or the mixed pellet and the NuclearLysisSolution is maintained at the NuclearLysisTemperature to facilitate digestion of nuclear envelope. The NuclearLysisTime occurs immediately after NuclearLysisMixTime.",
        ResolutionDescription->"Automatically set to the NuclearLysisIncubationTime specified by the selected Method. If NuclearLysisSolution is not Null and Method is set to Custom, automatically set to 10 Minute.",
        Category -> "Fractionation"
      },
      {
        OptionName->NuclearLysisTemperature,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Temperature"->Widget[Type->Quantity, Pattern:>RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units->Alternatives[Celsius,Fahrenheit]],
          "Ambient"->Widget[Type->Enumeration, Pattern:>Alternatives[Ambient]]
        ],
        Description->"The temperature at which the Instrument heating or cooling the mixed pellet and the NuclearLysisSolution is maintained during the NuclearLysisTime.",
        ResolutionDescription->"Automatically set to the NuclearLysisTemperature specified by the selected Method. If Method is set to Custom and NuclearLysisTime is not Null or 0 Second, NuclearLysisTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },

      (*--- FRACTIONATION --NUCLEAR-- Nuclear Fractionation --- *)

      {
        OptionName -> NuclearFractionationTechnique,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> Pellet | Filter
        ],
        Description -> "The type of force used to separate nuclear fraction, containing nuclear components released by lysing the nuclei, apart from insoluble fractions and components including cell debris and possibly insoluble membrane proteins if Membrane is not preceding Nuclear in FractionationOrder. Options include Pellet and Filter. With Pellet, the released nuclear fraction is separated out by centrifugation as the supernatant. With Filter, the nuclear fraction is collected as filtrate by applying a positive pressure to force the sample through a solid phase separation column. When NuclearFractionationTechnique is set to Null, no nuclear fractionation step is performed.",
        ResolutionDescription -> "Automatically set to the NuclearFractionationTechnique specified by the selected Method. If Method is set to Custom, NuclearFractionationTechnique is automatically set to the same as NuclearLysisTechnique.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearFractionationPelletInstrument,
        Default -> Automatic,
        Description-> "The centrifuge instrument that is used to pellet the insoluble components, including cell debris and possibly insoluble membrane proteins if Membrane is not preceding Nuclear in FractionationOrder, and to separate the nuclear fraction containing the nuclear proteins as the supernatant during NuclearFractionation.",
        ResolutionDescription -> "Automatically set to the NuclearFractionationPelletInstrument specified by the selected Method. If Method is set to Custom and NuclearFractionationTechnique is Pellet, NuclearFractionationPelletInstrument is automatically set to the robotic integrated centrifuge, Model[Instrument, Centrifuge, \"HiG4\"].",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Instrument], Model[Instrument]}],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Instruments", "Centrifugation", "Microcentrifuges"}
          }
        ],
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearFractionationPelletIntensity,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The rotational speed or the force that is applied to the samples in order to pellet the insoluble components, including cell debris and possibly insoluble membrane proteins if Membrane is not preceding Nuclear in FractionationOrder, and to separate the nuclear fraction containing the nuclear proteins as the supernatant during NuclearFractionation.",
        ResolutionDescription -> "Automatically set to the NuclearFractionationPelletIntensity specified by the selected Method. If Method->Custom and NuclearFractionationTechnique is Pellet, NuclearFractionationPelletIntensity is automatically set to 3600 GravitationalAcceleration.",
        Widget -> Alternatives[
          "Revolutions per Minute" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 RPM, $MaxCentrifugeSpeed],
            Units -> Alternatives[RPM]
          ],
          "Relative Centrifugal Force" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 GravitationalAcceleration, $MaxRelativeCentrifugalForce],
            Units -> Alternatives[GravitationalAcceleration]
          ]
        ],
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearFractionationPelletTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the sample is subject to the NuclearFractionationPelletIntensity in order to pellet the insoluble components, including cell debris and possibly insoluble membrane proteins if Membrane is not preceding Nuclear in FractionationOrder, and to separate the nuclear fraction containing the nuclear proteins as the supernatant during NuclearFractionation.",
        ResolutionDescription -> "Automatically set to the NuclearFractionationPelletTime specified by the selected Method. If Method->Custom and NuclearFractionationTechnique is Pellet, NuclearFractionationPelletTime is automatically set based on CellType. For mammalian cells, NuclearFractionationPelletTime is automatically set to 10 Minute; for bacterial cells and yeast, NuclearFractionationPelletTime is automatically set to 45 Minute; for other cell types, NuclearFractionationPelletTime is automatically set to 15 Minute.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearFractionationSupernatantVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Volume" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
            Units -> Alternatives[Microliter, Milliliter, Liter]],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ]
        ],
        Description -> "The amount of supernatant that contains the nuclear fraction to be transferred to NuclearFractionationSupernatantContainer after pelleting during nuclear fractionation.",
        ResolutionDescription -> "Automatically set to the NuclearFractionationSupernatantVolume specified by the selected Method. If Method is set to Custom and NuclearFractionationTechnique is Pellet, NuclearFractionationSupernatantVolume is automatically set to 90% of current volume.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearFractionationSupernatantStorageCondition,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Condition" -> Widget[
            Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal
          ],
          "Objects" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"],
                "Storage Conditions"}
            }
          ]
        ],
        Description -> "The set of parameters that define the temperature, safety, and other environmental conditions under which the supernatant from pelleting the sample during NuclearFractionation is stored upon completion of this protocol.",
        ResolutionDescription -> "Automatically set to the NuclearFractionationSupernatantStorageCondition specified by the selected Method. If Method is set to Custom and NuclearFractionationTechnique is Pellet, NuclearFractionationSupernatantStorageCondition is automatically set to Freezer.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearFractionationSupernatantContainer,
        Default -> Automatic,
        AllowNull -> True,
        Widget->Alternatives[
          "Container"->Widget[
            Type->Object,
            Pattern:> ObjectP[{Object[Container],Model[Container]}]
          ],
          "Container with Index" -> {
            "Index"->Widget[
              Type->Number,
              Pattern:>GreaterEqualP[1,1]
            ],
            "Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Model[Container]}],
              PreparedSample->False,
              PreparedContainer->False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container],Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type->Enumeration,
              Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
              PatternTooltip->"Enumeration must be any well from A1 to P24."
            ],
            "Index and Container"->{
              "Index"->Widget[
                Type->Number,
                Pattern:>GreaterEqualP[1,1]
              ],
              "Container"->Widget[
                Type->Object,
                Pattern:>ObjectP[{Model[Container]}],
                PreparedSample->False,
                PreparedContainer->False
              ]
            }
          }
        ],
        Description -> "The container into which the supernatant from pelleting during nuclear fractionation is transferred.",
        ResolutionDescription -> "Automatically set to the same container model of the input samples if NuclearFractionationTechnique is Pellet.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearFractionationSupernatantLabel,
        Default -> Automatic,
        AllowNull -> True,
        Description->"A user defined word or phrase used to identify the sample which is the collected supernatant from pelleting during nuclear fractionation.",
        ResolutionDescription -> "Automatically set to \"nuclear fractionation supernatant #\" if NuclearFractionationTechnique is Pellet.",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Word
        ],
        Category->"Fractionation",
        UnitOperation->True
      },
      {
        OptionName -> NuclearFractionationSupernatantContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description->"A user defined word or phrase used to identify the container of the sample, which is the collected supernatant from pelleting during nuclear fractionation.",
        ResolutionDescription -> "Automatically set to \"nuclear fractionation supernatant container #\" if NuclearFractionationTechnique is Pellet.",
        Category -> "Fractionation",
        UnitOperation -> True
      },
      {
        OptionName->NuclearFractionationFilterTechnique,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>Centrifuge|AirPressure
        ],
        Description->"The type of force used to flush the sample from nuclear lysis through the FractionationFilter in order to retain the insoluble components on the filter and to separate the nuclear fraction containing nuclear proteins as the filtrate during NuclearFractionation.",
        ResolutionDescription->"Automatically set to the NuclearFractionationFilterTechnique as specified by the selected Method. If Method->Custom and NuclearFractionationTechnique is Filter, NuclearFractionationTechnique is automatically set to AirPressure.",
        Category->"Fractionation"
      },
      {
        OptionName->NuclearFractionationFilterInstrument,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            Model[Instrument,Centrifuge],Object[Instrument,Centrifuge],
            Model[Instrument,PressureManifold],Object[Instrument,PressureManifold]
          }],
          OpenPaths->{
            {Object[Catalog,"Root"],"Instruments","Centrifugation","Microcentrifuges"},
            {Object[Catalog,"Root"],"Instruments","Dead-End Filtering Devices"}
          }
        ],
        Description->"The Instrument that generates force to flush the sample from nuclear lysis through the FractionationFilter during the NuclearFractionationFilterTime.",
        ResolutionDescription->"Automatically set to the NuclearFractionationFilterInstrument as specified by the selected Method. If Method->Custom and NuclearFractionationTechnique is Filter, NuclearFractionationFilterInstrument is automatically set to Model[Instrument,PressureManifold,\"MPE2\"].",
        Category->"Fractionation"
      },
      {
        OptionName->NuclearFractionationFilterCentrifugeIntensity,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Speed"->Widget[
            Type->Quantity,
            Pattern:>RangeP[0*RPM,$MaxRoboticCentrifugeSpeed],(*automatically round it for them, then throw a warning telling them you did that, instead of giving a specific delta*)
            Units->Alternatives[RPM]
          ],
          "Force"->Widget[
            Type->Quantity,
            Pattern:>RangeP[0*GravitationalAcceleration,$MaxRoboticRelativeCentrifugalForce],
            Units->Alternatives[GravitationalAcceleration]
          ]
        ],
        Description->"The rotational speed or gravitational force at which the sample is centrifuged to flush the sample from nuclear lysis through the FractionationFilter during the NuclearFractionationFilterTime, in order to retain the insoluble components on the filter and to separate the nuclear fraction containing the nuclear proteins as the filtrate during NuclearFractionation.",
        ResolutionDescription->"Automatically set to the NuclearFractionationFilterCentrifugeIntensity as specified by the selected Method. If Method->Custom and NuclearFractionationTechnique is Filter, NuclearFractionationFilterCentrifugeIntensity is automatically set to the lesser of the MaxIntensity of the centrifuge model and the MaxCentrifugationForce of the NuclearFractionationFilter.",
        Category->"Fractionation"
      },
      {
        OptionName->NuclearFractionationFilterPressure,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0*PSI,$MaxRoboticAirPressure],
          Units->{PSI,{Pascal,Kilopascal,PSI,Millibar,Bar}}
        ],
        Description->"The amount of pressure applied to flush the sample from nuclear lysis through the through the FractionationFilter during the NuclearFractionationFilterTime, in order to retain the insoluble components on the filter and to separate the nuclear fraction containing the nuclear proteins as the filtrate during NuclearFractionation.",
        ResolutionDescription->"Automatically set to the NuclearFractionationFilterFilterPressure as specified by the selected Method. If Method->Custom and NuclearFractionationTechnique is Filter, NuclearFractionationFilterPressure is automatically set to the lesser of the MaxPressure of the positive pressure model and the MaxPressure of the NuclearFractionationFilter.",
        Category->"Fractionation"
      },
      {
        OptionName->NuclearFractionationFilterTime,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0*Minute,$MaxExperimentTime],
          Units->Alternatives[Second,Minute,Hour]
        ],
        Description->"The duration of time for which force is applied to flush the sample from nuclear lysis through the through the FractionationFilter by the specified NuclearFractionationFilterTechnique and NuclearFractionationFilterInstrument,in order to retain the insoluble components on the filter and to separate the nuclear fraction containing the nuclear proteins as the filtrate during NuclearFractionation.",
        ResolutionDescription->"Automatically set to the NuclearFractionationFilterTime as specified by the selected Method. If Method->Custom and NuclearFractionationTechnique is Filter, NuclearFractionationFilterTime is automatically set to 1 Minute.",
        Category->"Fractionation"
      },
      {
        OptionName -> NuclearFractionationFiltrateStorageCondition,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Condition" -> Widget[
            Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal
          ],
          "Objects" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"],"Storage Conditions"}
            }
          ]
        ],
        Description -> "The set of parameters that define the temperature, safety, and other environmental conditions under which the filtrate from filtering the the sample from nuclear lysis during NuclearFractionation is stored upon completion of this protocol.",
        ResolutionDescription -> "Automatically set to the NuclearFractionationFiltrateStorageCondition specified by the selected Method. If Method is set to Custom and NuclearFractionationTechnique is Filter, NuclearFractionationFiltrateStorageCondition is automatically set to Freezer.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearFractionationFiltrateContainer,
        Default -> Automatic,
        AllowNull -> True,
        Widget->Alternatives[
          "Container"->Widget[
            Type->Object,
            Pattern:> ObjectP[{Object[Container],Model[Container]}]
          ],
          "Container with Index" -> {
            "Index"->Widget[
              Type->Number,
              Pattern:>GreaterEqualP[1,1]
            ],
            "Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Model[Container]}],
              PreparedSample->False,
              PreparedContainer->False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container],Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type->Enumeration,
              Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
              PatternTooltip->"Enumeration must be any well from A1 to P24."
            ],
            "Index and Container"->{
              "Index"->Widget[
                Type->Number,
                Pattern:>GreaterEqualP[1,1]
              ],
              "Container"->Widget[
                Type->Object,
                Pattern:>ObjectP[{Model[Container]}],
                PreparedSample->False,
                PreparedContainer->False
              ]
            }
          }
        ],
        Description -> "The container into which the filtrate from filtering during nuclear fractionation is transferred.",
        ResolutionDescription -> "Automatically set to the same container model of the input samples if NuclearFractionationTechnique is Filter.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearFractionationFiltrateLabel,
        Default -> Automatic,
        AllowNull -> True,
        Description->"A user defined word or phrase used to identify the sample which is the collected filtrate from filtering during nuclear fractionation.",
        ResolutionDescription -> "Automatically set to \"nuclear fractionation filtrate #\" if NuclearFractionationTechnique is Filter.",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Word
        ],
        Category->"Fractionation",
        UnitOperation->True
      },
      {
        OptionName -> NuclearFractionationFiltrateContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Description->"A user defined word or phrase used to identify the container of the sample, which is the collected filtrate from filtering during nuclear fractionation.",
        ResolutionDescription -> "Automatically set to \"nuclear fractionation filtrate container #\" if NuclearFractionationTechnique is Filter.",
        Category -> "Fractionation",
        UnitOperation -> True
      },
      {
        OptionName -> NuclearFractionationCollectionContainerTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the sample collection container is maintained during the NuclearFractionationCollectionContainerEquilibrationTime before the supernatant or filtrate sample from pelleting or filtering during nuclear fractionation is transferred into it.",
        ResolutionDescription -> "Automatically set to the NuclearFractionationCollectionContainerTemperatureTemperature as specified by the selected Method. If Method->Custom and Nuclear is a member of FractionationOrder, NuclearFractionationCollectionContainerTemperature is automatically set to 4 Celsius.",
        Category -> "Fractionation"
      },
      {
        OptionName -> NuclearFractionationCollectionContainerEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> Alternatives[Second, Minute, Hour]],
        Description -> "The duration for which the the sample collection container is maintained at NuclearFractionationCollectionContainerTemperature before the supernatant or filtrate sample from pelleting or filtering during nuclear fractionation is transferred into it.",
        ResolutionDescription -> "Automatically set to the NuclearFractionationCollectionContainerEquilibrationTime as specified by the selected Method. If Method->Custom and NuclearFractionationCollectionContainerTemperature is not Ambient or Null, NuclearFractionationCollectionContainerEquilibrationTime is automatically set to 10 Minute.",
        Category -> "Fractionation"
      },

      {
        OptionName -> FractionationFinalPelletStorageCondition,
        Default -> Automatic,
        AllowNull->True,
        Description -> "The condition under which the pellet from pelleting of the last fractionation step according to the FractionationOrder is stored after the protocol is completed.",
        ResolutionDescription ->"Automatically set to the FractionationFinalPelletStorageCondition specified by Method. If Method is set to Custom and the technique for last fractionation step is Filter, FractionationFinalPelletStorageCondition is automatically set to Null. If Method is set to Custom and the technique for last fractionation step is Pellet, FractionationFinalPelletStorageCondition is automatically set to Refrigerator.",
        AllowNull -> True,
        Widget -> Alternatives[
          "Condition" -> Widget[
            Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal
          ],
          "Objects" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"],
                "Storage Conditions"}
            }
          ]
        ],
        Category -> "Fractionation"
      },
      {
        OptionName -> FractionationFinalFilterStorageCondition,
        Default -> Automatic,
        AllowNull->True,
        Description -> "The condition under which the filter from filtering of the last fractionation step according to the FractionationOrder is stored after the protocol is completed.",
        ResolutionDescription ->"Automatically set to the FractionationFinalFilterStorageCondition specified by Method. If Method is set to Custom and the technique for last fractionation step is Pellet, FractionationFinalFilterStorageCondition is automatically set to Null. If Method is set to Custom and the technique for last fractionation step is Filter, FractionationFinalFilterStorageCondition is automatically set to Disposal.",
        AllowNull -> True,
        Widget -> Alternatives[
          "Condition" -> Widget[
            Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal
          ],
          "Objects" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"], "Storage Conditions"}
            }
          ]
        ],
        Category -> "Fractionation"
      },

      (*--- PURIFICATION ---*)
      ModifyOptions[PurificationStepsSharedOptions,
        Purification,
        {
          OptionName->Purification,
          Description->"Indicates the number of rudimentary purification steps, which techniques each step will use, and in what order the techniques will be carried out to isolate the target proteins (specific or all) for the TargetSubcellularFraction, if there is one member in TargetSubcellularFraction. If there is more than one target fractions, please call specific experiments for crude purification of the collected samples. There are four rudimentary purification techniques: liquid-liquid extraction, precipitation, solid phase extraction (also known as using \"spin columns\"), and magnetic bead separation. Each technique can be run up to three times each and can be run in any order (as specified by the order of the list). Additional purification steps such as these or more advanced purification steps such as HPLC, FPLC, gels, etc. can be performed on the final product using scripts which call the corresponding functions (ExperimentLiquidLiquidExtraction, ExperimentPrecipitate, ExperimentSolidPhaseExtraction, ExperimentMagneticBeadSeparation, ExperimentHPLC, ExperimentFPLC, ExperimentAgaroseGelElectrophoresis, etc.).",
          ResolutionDescription->"Automatically set to Null if TargetSubcellularFraction has more than one member. Otherwise, Purification is automatically set to the Purification steps specified by the selected Method. If Method is set to Custom, Purification is set based on any already set options pertaining to a specific rudimentary purification type. For example, if AqueousSolvent is specified, a LiquidLiquidExtraction step is added to Purification. Purification steps added this way are only added once and they are added in the following order: LiquidLiquidExtraction, Precipitation, SolidPhaseExtraction, then MagneticBeadSeparation. Otherwise, if TargetProtein is All, Purification is set to a Precipitation; if TargetProtein is a Model[Molecule], Purification is set to a SolidPhaseExtraction."
        }
      ],
      ExtractionLiquidLiquidSharedOptions,
      ExtractionPrecipitationSharedOptions,
      ExtractionSolidPhaseSharedOptions,
      ExtractionMagneticBeadSharedOptions,

      {
        OptionName -> PurificationSampleVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
            Units -> Alternatives[Microliter, Milliliter, Liter]
        ],
        Description -> "The minimum amount of collected samples during fractionation for target subcellular fractions. This is used to preresolve sample loading volume for the first purification technique used.",
        ResolutionDescription -> "Automatically set to the minimum volume across collected sample volumes from fractionation of target subcellular fractions.",
        Category -> "Hidden"
      }
    ],

    (* OTHER SHARED OPTIONS *)
    ModifyOptions[
      RoboticInstrumentOption,
      {
        ResolutionDescription -> "Automatically set to the robotic liquid handler compatible with the cells or solutions having their protein extracted. If all cell types, specified by CellType or informed by the CellType of the input samples, are microbial (Bacterial or Yeast), RoboticInstrument is automatically set to the microbioSTAR. If all cell types are non-microbial (Mammalian), RoboticInstrument is automatically set to the bioSTAR. Otherwise the cell types are mixed or unspecified, RoboticInstrument is automatically set to the microbioSTAR. "
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

Warning::MethodTargetFractionMismatch = "The sample(s), `1`, at indices `5`, have a target protein `3` or a target subcellular fraction `4`that is not listed as a target by the specified method, `2`.";
Error::ConflictingLysisStepSolutionEquilibration = "The sample(s), `1`, at indices `2`, have lysis solution temperature and equilibration time options in conflict with lyse or number of lysis steps, including options of `3` that have values of `4`.";
Error::LysisSolutionEquilibrationTimeTemperatureMismatch = "The sample(s), `1`, at indices `2`, have mismatched lysis solution temperature and equilibration time options of `3` that have values of `4`. For a lysis step, if the lysis solution temperature is set to Null, the lysis solution equilibration time could not be any time greater than 0 Second, please set it to Null or Automatic; if the lysis solution temperature is set to any temperature other than Null or Ambient, the lysis solution equilibration time could not be Null or zero, please set it to a valid time duration.";
Warning::TargetPurificationMismatch = "The sample(s), `1`, at indices `2`, have the target protein `3`, which would not be achievable with the purification of `4`. If TargetProtein is a Model[Molecule], at lease one Purification step of SolidPhaseExtraction with SolidPhaseExtractionSeparationMode->Affinity or a MagneticBeadSeparation step with MagneticBeadSeparationMode->Affinity. If TargetProtein is All, it is not recommended to have a SolidPhaseExtraction with SolidPhaseExtractionSeparationMode->Affinity or to have a MagneticBeadSeparation step with MagneticBeadSeparationMode->Affinity.";
Warning::NullTargetProtein = "The sample(s), `1`, at indices `2`, have target protein of Null, while Purification is set to Automatic, which is automatically set to None. If this is incorrect, please specify the Purification option to indicate which step(s) of purification is to be performed on the sample(s).";
Warning::InvalidTargetSubcellularFraction = "The sample(s), `1`, at indices `2`, have Nuclear in TargetSubcellularFraction while CellType is set to or determined to be Bacterial, which does not have nucleii. Please check these options.";
Error::IncompleteFractionationOrder = "The sample(s), `1`, at indices `4`, have incomplete FractionationOrder `3`, that either does not start with Cytosolic or does not contain all members of TargetSubcellularFraction `2`.";
Error::InvalidFractionationationTechnique = "The sample(s), `1`, at indices `2`, have invalid order of separation techniques specified for fractionation. According to FractionationOrder of `3`, the operating order of CytosolicFractionationTechnique `4`, MembranerFractionationTechnique `6`, and NuclearFractionationTechnique `8` should not have Pellet after the first usage of Filter. Once Filter is used, future fractions will remain on the filter, so subsequent Pellet would be invalid. Similarly, the MembraneWashSeparationTechnique `5` and NuclearWashSeparationTechnique `7` need to be the same as the previous fractionation technique.";

(* ::Subsection::Closed:: *)
(*ExperimentExtractSubcellularProtein*)

(* - Container to Sample Overload - *)

ExperimentExtractSubcellularProtein[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
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
      ExperimentExtractSubcellularProtein,
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
        ExperimentExtractSubcellularProtein,
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
    ExperimentExtractSubcellularProtein[samples,ReplaceRule[sampleOptions,Simulation->simulation]]
  ]
];

(* - Main Overload - *)

ExperimentExtractSubcellularProtein[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
  {
    cache, cacheBall, collapsedPreResolvedOptions, methodObjects, sampleFields,samplePacketFields, sampleModelFields, sampleModelPacketFields, methodPacketFields, containerObjectFields, containerObjectPacketFields, containerModelFields, containerModelPacketFields, containerModelObjects,
    containerObjects, expandedSafeOpsWithoutSolventAdditions,expandedSafeOps, gatherTests, inheritedOptions, listedOptions,
    listedSamples, messages, output, outputSpecification, extractSubcellularProteinCache, performSimulationQ, resultQ,
    protocolObject, preResolvedOptions, preResolvedOptionsResult, preResolvedOptionsTests, resourceResult, resourcePacketTests,
    returnEarlyQ, safeOps, safeOptions, safeOptionTests, templatedOptions, templateTests, resolvedPreparation, roboticSimulation, runTime,
    inheritedSimulation, userSpecifiedObjects, objectsExistQs, objectsExistTests, validLengths, validLengthTests, simulation, listedSanitizedSamples,
    listedSanitizedOptions
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
    SafeOptions[ExperimentExtractSubcellularProtein,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ExperimentExtractSubcellularProtein,listedOptions,AutoCorrect->False],{}}
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
    ValidInputLengthsQ[ExperimentExtractSubcellularProtein,{listedSanitizedSamples},listedSanitizedOptions,Output->{Result,Tests}],
    {ValidInputLengthsQ[ExperimentExtractSubcellularProtein,{listedSanitizedSamples},listedSanitizedOptions],Null}
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
    ApplyTemplateOptions[ExperimentExtractSubcellularProtein,{listedSanitizedSamples},listedSanitizedOptions,Output->{Result,Tests}],
    {ApplyTemplateOptions[ExperimentExtractSubcellularProtein,{listedSanitizedSamples},listedSanitizedOptions],Null}
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

  expandedSafeOpsWithoutSolventAdditions=Last[ExpandIndexMatchedInputs[ExperimentExtractSubcellularProtein,{listedSanitizedSamples},
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

  (* Make sure that all of our objects exist. *)
  userSpecifiedObjects = DeleteDuplicates@Cases[
    Flatten[{ToList[mySamples],ToList[myOptions]}],
    ObjectReferenceP[]
  ];

  objectsExistQs = DatabaseMemberQ[userSpecifiedObjects, Simulation->inheritedSimulation];

  (* Build tests for object existence *)
  objectsExistTests = If[gatherTests,
    MapThread[
      Test[StringTemplate["Specified object `1` exists in the database:"][#1],#2,True]&,
      {userSpecifiedObjects,objectsExistQs}
    ],
    {}
  ];

  (* If objects do not exist, return failure *)
  If[!(And@@objectsExistQs),
    If[!gatherTests,
      Message[Error::ObjectDoesNotExist,PickList[userSpecifiedObjects,objectsExistQs,False]];
      Message[Error::InvalidInput,PickList[userSpecifiedObjects,objectsExistQs,False]]
    ];
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOptionTests,validLengthTests,templateTests,objectsExistTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

  (* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)

  methodObjects = Cases[Lookup[expandedSafeOps, Method],Except[Custom]];

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
    PreferredContainer[All, LiquidHandlerCompatible -> True, Sterile -> True, Type -> All],
    (* Model[Container, Plate, PhaseSeparator, "Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits"] *)
    Model[Container, Plate, PhaseSeparator, "id:jLq9jXqrWW11"]
  }];

  containerObjects = DeleteDuplicates@Cases[
    Flatten[Lookup[safeOps, {LiquidLiquidExtractionContainer, ContainerOut}]],
    ObjectP[Object[Container]]
  ];

  (* - Big Download to make cacheBall and get the inputs in order by ID - *)
  extractSubcellularProteinCache=Quiet[
    Download[
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
    ],
    {Download::ObjectDoesNotExist, Download::FieldDoesntExist,Download::NotLinkField}
  ];

  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  cacheBall=FlattenCachePackets[{cache,extractSubcellularProteinCache}];


  (* Build the resolved options *)
  preResolvedOptionsResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {preResolvedOptions,preResolvedOptionsTests}=resolveExperimentExtractSubcellularProteinOptions[
      ToList[Download[mySamples,Object]],
      expandedSafeOps,
      Cache->cacheBall,
      Simulation->inheritedSimulation,
      Output->{Result,Tests}
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->preResolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {preResolvedOptions,preResolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {preResolvedOptions,preResolvedOptionsTests}={
        resolveExperimentExtractSubcellularProteinOptions[
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
    ExperimentExtractSubcellularProtein,
    preResolvedOptions,
    Ignore->ToList[myOptions],
    Messages->False
  ];



  (* Lookup our resolved Preparation option. *)
  resolvedPreparation = Lookup[preResolvedOptions, Preparation];

  (* Run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  returnEarlyQ = Which[
    MatchQ[preResolvedOptionsResult, $Failed],
    True,
    gatherTests,
    Not[RunUnitTest[<|"Tests"->preResolvedOptionsTests|>, Verbose->False, OutputFormat->SingleBoolean]],
    True,
    False
  ];
  (*
  (* This is because we pass down our simulation to ExperimentMSP or ExperimentRSP. *)
  performSimulationQ = MemberQ[output, Result|Simulation];
  (* If we did get the result, we should try to quiet messages in simulation so that we will not duplicate them. We will just silently update our simulation *)
  resultQ = MemberQ[output, Result];
  *)

  performSimulationQ = False;

  (* If option resolution failed, return early. *)
  If[returnEarlyQ && !performSimulationQ,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOptionTests,validLengthTests,templateTests,preResolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentExtractSubcellularProtein,collapsedPreResolvedOptions],
      Preview->Null,
      Simulation -> Simulation[]
    }]
  ];
  (*
  (* Build packets with resources *)
  (* NOTE: If our resource packets function, if Preparation->Robotic, we call RSP in order to get the robotic unit operation *)
  (* packets. We also get a robotic simulation at the same time. *)
  {{resourceResult, roboticSimulation, runTime}, resourcePacketTests} = Which[
    MatchQ[preResolvedOptionsResult, $Failed],
    {{$Failed, $Failed, $Failed}, {}},
    gatherTests,
    extractSubcellularProteinResourcePackets[
      ToList[Download[mySamples,Object]],
      templatedOptions,
      preResolvedOptions,
      Cache->cacheBall,
      Simulation -> inheritedSimulation,
      Output->{Result,Tests}
    ],
    True,
    {
      extractSubcellularProteinResourcePackets[
        ToList[Download[mySamples,Object]],
        templatedOptions,
        preResolvedOptions,
        Cache->cacheBall,
        Simulation -> inheritedSimulation
      ],
      {}
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
*)
  (* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
  If[!MemberQ[output,Result],
    Return[outputSpecification/.{
      Result -> Null,
      (*
      Tests -> Flatten[{safeOptionTests,validLengthTests,templateTests,preResolvedOptionsTests,resourcePacketTests}],
      *)
      Options -> RemoveHiddenOptions[ExperimentExtractSubcellularProtein,collapsedPreResolvedOptions],
      Preview -> Null,
      Simulation -> simulation,
      RunTime -> runTime
    }]
  ];
  (*
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
      primitive=ExtractSubcellularProtein@@Join[
        {
          Sample->Download[ToList[mySamples], Object]
        },
        RemoveHiddenPrimitiveOptions[ExtractSubcellularProtein,ToList[myOptions]]
      ];

      (* Remove any hidden options before returning. *)
      nonHiddenOptions=RemoveHiddenOptions[ExperimentExtractSubcellularProtein,collapsedPreResolvedOptions];

      (* Memoize the value of ExperimentExtractSubcellularProtein so the framework doesn't spend time resolving it again. *)
      Internal`InheritedBlock[{ExperimentExtractSubcellularProtein, $PrimitiveFrameworkResolverOutputCache},
        $PrimitiveFrameworkResolverOutputCache=<||>;

        DownValues[ExperimentExtractSubcellularProtein]={};

        ExperimentExtractSubcellularProtein[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
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
        experimentFunction = Lookup[$WorkCellToExperimentFunction, Lookup[preResolvedOptions, WorkCell]];

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
*)

  (* Return requested output *)
  outputSpecification/.{
    Result -> Object[Protocol,RoboticCellPreparation,"fake for test"],(*protocolObject,*)
    Tests -> Flatten[{safeOptionTests,validLengthTests,templateTests,preResolvedOptionsTests,resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentExtractSubcellularProtein,collapsedPreResolvedOptions],
    Preview -> Null,
    Simulation -> simulation,
    RunTime -> runTime
  }
];
(* ::Subsection:: *)
(* Helper functions*)

calculatePostLysisSampleVolume[
  sampleVolume:VolumeP,
  mapThreadResolvedLysisOptions:_Association
]:=Module[
  {startingVolume, resolvedAliquotAmount,resolvedPreLysisSupernatantVolume,resolvedPreLysisDilutionVolume,resolvedLysisSolutionVolume,resolvedSecondaryLysisSolutionVolume,resolvedTertiaryLysisSolutionVolume,resolvedClarifiedLysateVolume},

  (*Lookup the resolved volume options all at once*)
  {resolvedAliquotAmount,resolvedPreLysisSupernatantVolume,resolvedPreLysisDilutionVolume,resolvedLysisSolutionVolume,resolvedSecondaryLysisSolutionVolume,resolvedTertiaryLysisSolutionVolume,resolvedClarifiedLysateVolume} = Lookup[mapThreadResolvedLysisOptions, {
    AliquotAmount,PreLysisSupernatantVolume,PreLysisDilutionVolume,LysisSolutionVolume,SecondaryLysisSolutionVolume,TertiaryLysisSolutionVolume,ClarifiedLysateVolume
  }];
  (*The starting volume for lysis is sample volume is aliquot is not performed or aliquot amount is All. Otherwise, lysis start with the volume of the aliquot amount. *)
  startingVolume = If[MatchQ[resolvedAliquotAmount,GreaterP[0 Microliter]],
    resolvedAliquotAmount,
    sampleVolume
  ];
  (*If the resolved ClarifiedLysateVolume is a valid volume, it serves as a new starting volume for the following experiment no matter what are other volumes. Otherwise, clarify lysate is not performed or All is extracted. Either way the volume to proceed equals the sum of all previous volumes*)
  If[MatchQ[resolvedClarifiedLysateVolume,VolumeP],
    resolvedClarifiedLysateVolume,
    Total@Cases[{startingVolume,-resolvedPreLysisSupernatantVolume,resolvedPreLysisDilutionVolume,resolvedLysisSolutionVolume,resolvedSecondaryLysisSolutionVolume,resolvedTertiaryLysisSolutionVolume}, VolumeP]
  ]
];



(* ::Subsection::Closed:: *)

(* ::Subsection:: *)
(* resolveExtractSubcellularProteinWorkCell *)

DefineOptions[resolveExtractSubcellularProteinWorkCell,
  SharedOptions:>{
    ExperimentExtractSubcellularProtein,
    CacheOption,
    SimulationOption,
    OutputOption
  }
];

resolveExtractSubcellularProteinWorkCell[
  myContainersAndSamples:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container]}]],
  myOptions:OptionsPattern[]
]:=Module[{mySamples, myContainers, samplePackets, simulation},

  mySamples = Cases[myContainersAndSamples, ObjectP[Object[Sample]], Infinity];
  myContainers = Cases[myContainersAndSamples, ObjectP[Object[Container]], Infinity];
  simulation = Lookup[ToList[myOptions], Simulation, Null];

  samplePackets = Download[mySamples, Packet[CellType], Simulation -> simulation];

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
(*resolveExperimentExtractSubcellularProteinOptions*)

DefineOptions[
  resolveExperimentExtractSubcellularProteinOptions,
  Options:>{HelperOutputOption, CacheOption, SimulationOption}
];

(* ::Subsection::Closed:: *)
(*Define options set used in the resolver*)
$ExtractSubcellularProteinNuclearWashOptions = {NumberOfNuclearWashes, NuclearWashSolution, NuclearWashSolutionVolume, NuclearWashSolutionTemperature, NuclearWashSolutionEquilibrationTime, NuclearWashMixType, NuclearWashMixRate, NuclearWashMixTime, NumberOfNuclearWashMixes, NuclearWashMixVolume, NuclearWashMixTemperature, NuclearWashIncubationTime, NuclearWashIncubationTemperature, NuclearWashSeparationTechnique, NuclearWashPelletInstrument, NuclearWashPelletIntensity, NuclearWashPelletTime, NuclearWashSupernatantVolume, NuclearWashSupernatantContainer, NuclearWashSupernatantLabel, NuclearWashSupernatantContainerLabel, NuclearWashSupernatantStorageCondition, NuclearWashFilterTechnique, NuclearWashFilterInstrument, NuclearWashFilterCentrifugeIntensity, NuclearWashFilterPressure, NuclearWashFilterTime, NuclearWashFiltrateStorageCondition, NuclearWashFiltrateContainer, NuclearWashFiltrateLabel, NuclearWashFiltrateContainerLabel, NuclearWashCollectionContainerTemperature, NuclearWashCollectionContainerEquilibrationTime};
$ExtractSubcellularProteinNuclearLysisOptions = {NuclearLysisSolution, NuclearLysisSolutionVolume, NuclearLysisSolutionTemperature, NuclearLysisSolutionEquilibrationTime, NuclearLysisMixType, NuclearLysisMixRate, NuclearLysisMixTime, NumberOfNuclearLysisMixes, NuclearLysisMixVolume, NuclearLysisMixTemperature, NuclearLysisTime, NuclearLysisTemperature};
$ExtractSubcellularProteinNuclearFractionationOptions = {ExtractedNuclearProteinContainer,ExtractedNuclearProteinLabel, ExtractedNuclearProteinContainerLabel, NuclearFractionationTechnique, NuclearFractionationPelletInstrument, NuclearFractionationPelletIntensity, NuclearFractionationPelletTime, NuclearFractionationSupernatantVolume, NuclearFractionationSupernatantStorageCondition, NuclearFractionationSupernatantContainer, NuclearFractionationSupernatantLabel, NuclearFractionationSupernatantContainerLabel, NuclearFractionationFilterTechnique, NuclearFractionationFilterInstrument, NuclearFractionationFilterCentrifugeIntensity, NuclearFractionationFilterPressure, NuclearFractionationFilterTime, NuclearFractionationFiltrateStorageCondition, NuclearFractionationFiltrateContainer, NuclearFractionationFiltrateLabel, NuclearFractionationFiltrateContainerLabel, NuclearFractionationCollectionContainerTemperature, NuclearFractionationCollectionContainerEquilibrationTime};
$ExtractSubcellularProteinMembraneWashOptions = {NumberOfMembraneWashes, MembraneWashSolution, MembraneWashSolutionVolume, MembraneWashSolutionTemperature, MembraneWashSolutionEquilibrationTime, MembraneWashMixType, MembraneWashMixRate, MembraneWashMixTime, NumberOfMembraneWashMixes, MembraneWashMixVolume, MembraneWashMixTemperature, MembraneWashIncubationTime, MembraneWashIncubationTemperature, MembraneWashSeparationTechnique, MembraneWashPelletInstrument, MembraneWashPelletIntensity, MembraneWashPelletTime, MembraneWashSupernatantVolume, MembraneWashSupernatantContainer, MembraneWashSupernatantLabel, MembraneWashSupernatantContainerLabel, MembraneWashSupernatantStorageCondition, MembraneWashFilterTechnique, MembraneWashFilterInstrument, MembraneWashFilterCentrifugeIntensity, MembraneWashFilterPressure, MembraneWashFilterTime, MembraneWashFiltrateStorageCondition, MembraneWashFiltrateContainer, MembraneWashFiltrateLabel, MembraneWashFiltrateContainerLabel, MembraneWashCollectionContainerTemperature, MembraneWashCollectionContainerEquilibrationTime};
$ExtractSubcellularProteinMembraneSolubilizationOptions ={MembraneSolubilizationSolution, MembraneSolubilizationSolutionVolume, MembraneSolubilizationSolutionTemperature, MembraneSolubilizationSolutionEquilibrationTime, MembraneSolubilizationMixType, MembraneSolubilizationMixRate, MembraneSolubilizationMixTime, NumberOfMembraneSolubilizationMixes, MembraneSolubilizationMixVolume, MembraneSolubilizationMixTemperature, MembraneSolubilizationTime, MembraneSolubilizationTemperature};
$ExtractSubcellularProteinMembraneFractionationOptions = {ExtractedMembraneProteinContainer,ExtractedMembraneProteinLabel, ExtractedMembraneProteinContainerLabel, MembraneFractionationTechnique, MembraneFractionationPelletInstrument, MembraneFractionationPelletIntensity, MembraneFractionationPelletTime, MembraneFractionationSupernatantVolume, MembraneFractionationSupernatantStorageCondition, MembraneFractionationSupernatantContainer, MembraneFractionationSupernatantLabel, MembraneFractionationSupernatantContainerLabel, MembraneFractionationFilterTechnique, MembraneFractionationFilterInstrument, MembraneFractionationFilterCentrifugeIntensity, MembraneFractionationFilterPressure, MembraneFractionationFilterTime, MembraneFractionationFiltrateStorageCondition, MembraneFractionationFiltrateContainer, MembraneFractionationFiltrateLabel, MembraneFractionationFiltrateContainerLabel, MembraneFractionationCollectionContainerTemperature, MembraneFractionationCollectionContainerEquilibrationTime};
$ExtractSubcellularProteinCytosolicOptions = {ExtractedCytosolicProteinContainer,ExtractedCytosolicProteinLabel, ExtractedCytosolicProteinContainerLabel,CytosolicFractionationTechnique, CytosolicFractionationPelletInstrument, CytosolicFractionationPelletIntensity, CytosolicFractionationPelletTime, CytosolicFractionationSupernatantVolume, CytosolicFractionationSupernatantStorageCondition, CytosolicFractionationSupernatantContainer, CytosolicFractionationSupernatantLabel, CytosolicFractionationSupernatantContainerLabel, CytosolicFractionationFilterTechnique, CytosolicFractionationFilterInstrument, CytosolicFractionationFilterCentrifugeIntensity, CytosolicFractionationFilterPressure, CytosolicFractionationFilterTime, CytosolicFractionationFiltrateStorageCondition, CytosolicFractionationFiltrateContainer, CytosolicFractionationFiltrateLabel, CytosolicFractionationFiltrateContainerLabel, CytosolicFractionationCollectionContainerTemperature, CytosolicFractionationCollectionContainerEquilibrationTime};
$ExtractSubcellularProteinAllFilterOptions = {CytosolicFractionationFilterTechnique, CytosolicFractionationFilterInstrument, CytosolicFractionationFilterCentrifugeIntensity, CytosolicFractionationFilterPressure, CytosolicFractionationFilterTime, CytosolicFractionationFiltrateStorageCondition, CytosolicFractionationFiltrateContainer, CytosolicFractionationFiltrateLabel, CytosolicFractionationFiltrateContainerLabel,MembraneWashFilterTechnique, MembraneWashFilterInstrument, MembraneWashFilterCentrifugeIntensity, MembraneWashFilterPressure, MembraneWashFilterTime, MembraneWashFiltrateStorageCondition, MembraneWashFiltrateContainer, MembraneWashFiltrateLabel, MembraneWashFiltrateContainerLabel,MembraneFractionationFilterTechnique, MembraneFractionationFilterInstrument, MembraneFractionationFilterCentrifugeIntensity, MembraneFractionationFilterPressure, MembraneFractionationFilterTime, MembraneFractionationFiltrateStorageCondition, MembraneFractionationFiltrateContainer, MembraneFractionationFiltrateLabel, MembraneFractionationFiltrateContainerLabel,NuclearWashFilterTechnique, NuclearWashFilterInstrument, NuclearWashFilterCentrifugeIntensity, NuclearWashFilterPressure, NuclearWashFilterTime, NuclearWashFiltrateStorageCondition, NuclearWashFiltrateContainer, NuclearWashFiltrateLabel, NuclearWashFiltrateContainerLabel,NuclearFractionationFilterTechnique, NuclearFractionationFilterInstrument, NuclearFractionationFilterCentrifugeIntensity, NuclearFractionationFilterPressure, NuclearFractionationFilterTime, NuclearFractionationFiltrateStorageCondition, NuclearFractionationFiltrateContainer, NuclearFractionationFiltrateLabel, NuclearFractionationFiltrateContainerLabel, FractionationFinalPelletStorageCondition,
  FractionationFinalFilterStorageCondition};

$ExtractSubcellularProteinSeparationTechniqueOptions = {NuclearWashSeparationTechnique, NuclearFractionationTechnique, MembraneWashSeparationTechnique, MembraneFractionationTechnique, CytosolicFractionationTechnique};

$CytosolicFractionationOptionsMap = {
  FractionationTechnique -> CytosolicFractionationTechnique,
  PelletInstrument -> CytosolicFractionationPelletInstrument,
  PelletIntensity -> CytosolicFractionationPelletIntensity,
  PelletTime -> CytosolicFractionationPelletTime,
  SupernatantVolume -> CytosolicFractionationSupernatantVolume,
  SupernatantStorageCondition -> CytosolicFractionationSupernatantStorageCondition,
  SupernatantContainer -> CytosolicFractionationSupernatantContainer,
  SupernatantLabel -> CytosolicFractionationSupernatantLabel,
  SupernatantContainerLabel -> CytosolicFractionationSupernatantContainerLabel,
  FilterTechnique -> CytosolicFractionationFilterTechnique,
  FilterInstrument -> CytosolicFractionationFilterInstrument,
  FilterCentrifugeIntensity -> CytosolicFractionationFilterCentrifugeIntensity,
  FilterPressure -> CytosolicFractionationFilterPressure,
  FilterTime -> CytosolicFractionationFilterTime,
  FiltrateStorageCondition -> CytosolicFractionationFiltrateStorageCondition,
  FiltrateContainer -> CytosolicFractionationFiltrateContainer,
  FiltrateLabel -> CytosolicFractionationFiltrateLabel,
  FiltrateContainerLabel -> CytosolicFractionationFiltrateContainerLabel,
  CollectionContainerTemperature -> CytosolicFractionationCollectionContainerTemperature,
  CollectionContainerEquilibrationTime -> CytosolicFractionationCollectionContainerEquilibrationTime,
  ContainerOut -> ExtractedCytosolicProteinContainer,
  ContainerOutLabel -> ExtractedCytosolicProteinContainerLabel,
  SampleOutLabel -> ExtractedCytosolicProteinLabel
};
$MembraneFractionationOptionsMap = {
  FractionationTechnique -> MembraneFractionationTechnique,
  PelletInstrument -> MembraneFractionationPelletInstrument,
  PelletIntensity -> MembraneFractionationPelletIntensity,
  PelletTime -> MembraneFractionationPelletTime,
  SupernatantVolume -> MembraneFractionationSupernatantVolume,
  SupernatantStorageCondition -> MembraneFractionationSupernatantStorageCondition,
  SupernatantContainer -> MembraneFractionationSupernatantContainer,
  SupernatantLabel -> MembraneFractionationSupernatantLabel,
  SupernatantContainerLabel -> MembraneFractionationSupernatantContainerLabel,
  FilterTechnique -> MembraneFractionationFilterTechnique,
  FilterInstrument -> MembraneFractionationFilterInstrument,
  FilterCentrifugeIntensity -> MembraneFractionationFilterCentrifugeIntensity,
  FilterPressure -> MembraneFractionationFilterPressure,
  FilterTime -> MembraneFractionationFilterTime,
  FiltrateStorageCondition -> MembraneFractionationFiltrateStorageCondition,
  FiltrateContainer -> MembraneFractionationFiltrateContainer,
  FiltrateLabel -> MembraneFractionationFiltrateLabel,
  FiltrateContainerLabel -> MembraneFractionationFiltrateContainerLabel,
  CollectionContainerTemperature -> MembraneFractionationCollectionContainerTemperature,
  CollectionContainerEquilibrationTime -> MembraneFractionationCollectionContainerEquilibrationTime,
  ContainerOut -> ExtractedMembraneProteinContainer,
  ContainerOutLabel -> ExtractedMembraneProteinContainerLabel,
  SampleOutLabel -> ExtractedMembraneProteinLabel
};
$NuclearFractionationOptionsMap = {
  FractionationTechnique -> NuclearFractionationTechnique,
  PelletInstrument -> NuclearFractionationPelletInstrument,
  PelletIntensity -> NuclearFractionationPelletIntensity,
  PelletTime -> NuclearFractionationPelletTime,
  SupernatantVolume -> NuclearFractionationSupernatantVolume,
  SupernatantStorageCondition -> NuclearFractionationSupernatantStorageCondition,
  SupernatantContainer -> NuclearFractionationSupernatantContainer,
  SupernatantLabel -> NuclearFractionationSupernatantLabel,
  SupernatantContainerLabel -> NuclearFractionationSupernatantContainerLabel,
  FilterTechnique -> NuclearFractionationFilterTechnique,
  FilterInstrument -> NuclearFractionationFilterInstrument,
  FilterCentrifugeIntensity -> NuclearFractionationFilterCentrifugeIntensity,
  FilterPressure -> NuclearFractionationFilterPressure,
  FilterTime -> NuclearFractionationFilterTime,
  FiltrateStorageCondition -> NuclearFractionationFiltrateStorageCondition,
  FiltrateContainer -> NuclearFractionationFiltrateContainer,
  FiltrateLabel -> NuclearFractionationFiltrateLabel,
  FiltrateContainerLabel -> NuclearFractionationFiltrateContainerLabel,
  CollectionContainerTemperature -> NuclearFractionationCollectionContainerTemperature,
  CollectionContainerEquilibrationTime -> NuclearFractionationCollectionContainerEquilibrationTime,
  ContainerOut -> ExtractedNuclearProteinContainer,
  ContainerOutLabel -> ExtractedNuclearProteinContainerLabel,
  SampleOutLabel -> ExtractedNuclearProteinLabel
};
$MembraneWashAndPrepOptionsMap ={
  NumberOfWashes -> NumberOfMembraneWashes,
  WashSolution -> MembraneWashSolution,
  WashSolutionVolume -> MembraneWashSolutionVolume,
  WashSolutionTemperature -> MembraneWashSolutionTemperature,
  WashSolutionEquilibrationTime -> MembraneWashSolutionEquilibrationTime, 
  WashMixType -> MembraneWashMixType,
  WashMixRate -> MembraneWashMixRate, 
  WashMixTime -> MembraneWashMixTime, 
  NumberOfWashMixes -> NumberOfMembraneWashMixes,
  WashMixVolume -> MembraneWashMixVolume, 
  WashMixTemperature -> MembraneWashMixTemperature,
  WashIncubationTime -> MembraneWashIncubationTime, 
  WashIncubationTemperature -> MembraneWashIncubationTemperature,
  WashSeparationTechnique -> MembraneWashSeparationTechnique, 
  WashPelletInstrument -> MembraneWashPelletInstrument,
  WashPelletIntensity -> MembraneWashPelletIntensity, 
  WashPelletTime -> MembraneWashPelletTime,
  WashSupernatantVolume -> MembraneWashSupernatantVolume, 
  WashSupernatantContainer -> MembraneWashSupernatantContainer,
  WashSupernatantLabel -> MembraneWashSupernatantLabel, 
  WashSupernatantContainerLabel -> MembraneWashSupernatantContainerLabel,
  WashSupernatantStorageCondition -> MembraneWashSupernatantStorageCondition, 
  WashFilterTechnique -> MembraneWashFilterTechnique,
  WashFilterInstrument -> MembraneWashFilterInstrument, 
  WashFilterCentrifugeIntensity -> MembraneWashFilterCentrifugeIntensity,
  WashFilterPressure -> MembraneWashFilterPressure, 
  WashFilterTime -> MembraneWashFilterTime,
  WashFiltrateStorageCondition -> MembraneWashFiltrateStorageCondition, 
  WashFiltrateContainer -> MembraneWashFiltrateContainer,
  WashFiltrateLabel -> MembraneWashFiltrateLabel, 
  WashFiltrateContainerLabel -> MembraneWashFiltrateContainerLabel,
  WashCollectionContainerTemperature -> MembraneWashCollectionContainerTemperature,
  WashCollectionContainerEquilibrationTime -> MembraneWashCollectionContainerEquilibrationTime,
  FractionIncubationSolution -> MembraneSolubilizationSolution,
  FractionIncubationSolutionVolume -> MembraneSolubilizationSolutionVolume,
  FractionIncubationSolutionTemperature -> MembraneSolubilizationSolutionTemperature,
  FractionIncubationSolutionEquilibrationTime -> MembraneSolubilizationSolutionEquilibrationTime,
  FractionIncubationMixType -> MembraneSolubilizationMixType,
  FractionIncubationMixRate -> MembraneSolubilizationMixRate,
  FractionIncubationMixTime -> MembraneSolubilizationMixTime,
  NumberOfFractionIncubationMixes -> NumberOfMembraneSolubilizationMixes,
  FractionIncubationMixVolume -> MembraneSolubilizationMixVolume,
  FractionIncubationMixTemperature -> MembraneSolubilizationMixTemperature,
  FractionIncubationTime -> MembraneSolubilizationTime,
  FractionIncubationTemperature -> MembraneSolubilizationTemperature
};
$NuclearWashAndPrepOptionsMap ={
  NumberOfWashes -> NumberOfNuclearWashes,
  WashSolution -> NuclearWashSolution,
  WashSolutionVolume -> NuclearWashSolutionVolume,
  WashSolutionTemperature -> NuclearWashSolutionTemperature,
  WashSolutionEquilibrationTime -> NuclearWashSolutionEquilibrationTime,
  WashMixType -> NuclearWashMixType,
  WashMixRate -> NuclearWashMixRate,
  WashMixTime -> NuclearWashMixTime,
  NumberOfWashMixes -> NumberOfNuclearWashMixes,
  WashMixVolume -> NuclearWashMixVolume,
  WashMixTemperature -> NuclearWashMixTemperature,
  WashIncubationTime -> NuclearWashIncubationTime,
  WashIncubationTemperature -> NuclearWashIncubationTemperature,
  WashSeparationTechnique -> NuclearWashSeparationTechnique,
  WashPelletInstrument -> NuclearWashPelletInstrument,
  WashPelletIntensity -> NuclearWashPelletIntensity,
  WashPelletTime -> NuclearWashPelletTime,
  WashSupernatantVolume -> NuclearWashSupernatantVolume,
  WashSupernatantContainer -> NuclearWashSupernatantContainer,
  WashSupernatantLabel -> NuclearWashSupernatantLabel,
  WashSupernatantContainerLabel -> NuclearWashSupernatantContainerLabel,
  WashSupernatantStorageCondition -> NuclearWashSupernatantStorageCondition,
  WashFilterTechnique -> NuclearWashFilterTechnique,
  WashFilterInstrument -> NuclearWashFilterInstrument,
  WashFilterCentrifugeIntensity -> NuclearWashFilterCentrifugeIntensity,
  WashFilterPressure -> NuclearWashFilterPressure,
  WashFilterTime -> NuclearWashFilterTime,
  WashFiltrateStorageCondition -> NuclearWashFiltrateStorageCondition,
  WashFiltrateContainer -> NuclearWashFiltrateContainer,
  WashFiltrateLabel -> NuclearWashFiltrateLabel,
  WashFiltrateContainerLabel -> NuclearWashFiltrateContainerLabel,
  WashCollectionContainerTemperature -> NuclearWashCollectionContainerTemperature,
  WashCollectionContainerEquilibrationTime -> NuclearWashCollectionContainerEquilibrationTime,
  FractionIncubationSolution -> NuclearLysisSolution,
  FractionIncubationSolutionVolume -> NuclearLysisSolutionVolume,
  FractionIncubationSolutionTemperature -> NuclearLysisSolutionTemperature,
  FractionIncubationSolutionEquilibrationTime -> NuclearLysisSolutionEquilibrationTime,
  FractionIncubationMixType -> NuclearLysisMixType,
  FractionIncubationMixRate -> NuclearLysisMixRate,
  FractionIncubationMixTime -> NuclearLysisMixTime,
  NumberOfFractionIncubationMixes -> NumberOfNuclearLysisMixes,
  FractionIncubationMixVolume -> NuclearLysisMixVolume,
  FractionIncubationMixTemperature -> NuclearLysisMixTemperature,
  FractionIncubationTime -> NuclearLysisTime,
  FractionIncubationTemperature -> NuclearLysisTemperature
};

(* Helper functions -- Pre-resolve lysis options *)
(*This is different from ExtractProtein because Lysis will never be the last step. So no need to get ExtractedBlahLabel and ExtractedBlahContainerLabel*)
preResolveLysisOptionsForExtractSubcellularProtein[
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
    resolvedNumberOfLysisSteps,numberOfLysisSteps, userMethodNumberOfLysisSteps,assignedMethodNumberOfLysisSteps,
    resolvedLysisSolutionTemperature,lysisSolutionTemperature, userMethodLysisSolutionTemperature, assignedMethodLysisSolutionTemperature,
    resolvedLysisSolutionEquilibrationTime, lysisSolutionEquilibrationTime, userMethodLysisSolutionEquilibrationTime, assignedMethodLysisSolutionEquilibrationTime,
    resolvedSecondaryLysisSolutionTemperature, secondaryLysisSolutionTemperature, userMethodSecondaryLysisSolutionTemperature, assignedMethodSecondaryLysisSolutionTemperature,
    resolvedSecondaryLysisSolutionEquilibrationTime,secondaryLysisSolutionEquilibrationTime, userMethodSecondaryLysisSolutionEquilibrationTime, assignedMethodSecondaryLysisSolutionEquilibrationTime,
    resolvedTertiaryLysisSolutionTemperature,tertiaryLysisSolutionTemperature, userMethodTertiaryLysisSolutionTemperature, assignedMethodTertiaryLysisSolutionTemperature,
    resolvedTertiaryLysisSolutionEquilibrationTime,tertiaryLysisSolutionEquilibrationTime, userMethodTertiaryLysisSolutionEquilibrationTime, assignedMethodTertiaryLysisSolutionEquilibrationTime
  },

  (*Look up the option values*)
  {
    (*Lysis general*)
    lysisTime,lysisTemperature,numberOfLysisSteps,lysisSolutionTemperature,lysisSolutionEquilibrationTime,
    secondaryLysisSolutionTemperature,secondaryLysisSolutionEquilibrationTime,
    tertiaryLysisSolutionTemperature,tertiaryLysisSolutionEquilibrationTime,

    (*Lysis aliquot*)
    lysisAliquot,lysisAliquotAmount,targetCellCount,targetCellConcentration,lysisAliquotContainer,lysisAliquotContainerLabel,
    (*Lysis clarification*)
    clarifyLysate,clarifyLysateCentrifuge,clarifyLysateIntensity, clarifyLysateTime, clarifiedLysateVolume,postClarificationPelletStorageCondition,clarifiedLysateContainer,clarifiedLysateContainerLabel
  }=Lookup[userInputMapThreadOptions,
    {
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
    assignedMethodTertiaryLysisSolutionTemperature, assignedMethodTertiaryLysisSolutionEquilibrationTime}=If[!MatchQ[assignedMethod,<||>],
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
    (*Otherwise, should be resolved by ExperimentLyseCells.*)
    True,
    Automatic
  ];

  preResolvedLysisAliquotContainerLabel = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[lysisAliquotContainerLabel, Except[Automatic]],
    lysisAliquotContainerLabel,
    (*not a field in Method so no need to check Method*)
    (*Otherwise, should be resolved by ExperimentLyseCells.*)
    True,
    Automatic
  ];

  preResolvedClarifiedLysateContainer = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[clarifiedLysateContainer, Except[Automatic]],
    clarifiedLysateContainer,
    (*not a field in Method so no need to check Method*)
    (*Otherwise, should be resolved by ExperimentLyseCells.*)
    True,
    Automatic
  ];

  preResolvedClarifiedLysateContainerLabel = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[clarifiedLysateContainerLabel,Except[Automatic]],
    clarifiedLysateContainerLabel,
    (*not a field in Method so no need to check Method*)
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
    (*6*)ClarifiedLysateContainer -> preResolvedLysisAliquotContainerLabel,
    (*7*)LysisAliquotContainerLabel -> preResolvedClarifiedLysateContainer,
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

(*Helper functions --- PreResolve one step of fractionation options*)
preResolveFractionationStepOptions[
  stepFraction:Cytosolic|Membrane|Nuclear,
  sampleAlreadyInFilter:BooleanP,
  userInputMapThreadOptions_Association,
  stepOptionNameMap:{_Rule..},
  useMethodQ:BooleanP,
  resolvedMethodPacket:<||>|PacketP[Object[Method]]|Null,
  fractionationOrder:ListableP[Cytosolic|Membrane|Nuclear],
  cellType:CellTypeP|Unspecified|Automatic|Null,
  purification:ListableP[Alternatives[LiquidLiquidExtraction,Precipitation,SolidPhaseExtraction,MagneticBeadSeparation,None]],
  startingVolume:VolumeP
]:=Module[
  {
    (*Option Names*)
    fractionationTechniqueOptionName,pelletInstrumentOptionName, pelletIntensityOptionName, pelletTimeOptionName, supernatantVolumeOptionName, supernatantStorageConditionOptionName, supernatantContainerOptionName, supernatantLabelOptionName, supernatantContainerLabelOptionName, filterOptionName, filterTechniqueOptionName, filterInstrumentOptionName, filterCentrifugeIntensityOptionName, filterPressureOptionName, filterTimeOptionName, filtrateStorageConditionOptionName, filtrateContainerOptionName, filtrateLabelOptionName, filtrateContainerLabelOptionName, collectionContainerTemperatureOptionName, collectionContainerEquilibrationTimeOptionName,containerOutOptionName,containerOutLabelOptionName,sampleOutLabelOptionName,
    (*User Specified Option Values*)
    essentialPelletOptions,filterOptions,
    fractionationTechnique,pelletInstrument, pelletIntensity, pelletTime, supernatantVolume, supernatantStorageCondition, supernatantContainer, supernatantLabel, supernatantContainerLabel, filterTechnique, filterInstrument, filterCentrifugeIntensity, filterPressure, filterTime, filtrateStorageCondition, filtrateContainer, filtrateLabel, filtrateContainerLabel, collectionContainerTemperature,collectionContainerEquilibrationTime,containerOut,containerOutLabel,sampleOutLabel,
    (*User-Specified Method Option Values*)
    methodFractionationTechnique,methodPelletInstrument, methodPelletIntensity,methodPelletTime, methodSupernatantVolume, methodSupernatantStorageCondition, methodSupernatantContainer, methodSupernatantLabel, methodSupernatantContainerLabel, methodFilterTechnique, methodFilterInstrument, methodFilterCentrifugeIntensity, methodFilterPressure, methodFilterTime, methodFiltrateStorageCondition, methodFiltrateContainer, methodFiltrateLabel, methodFiltrateContainerLabel,methodCollectionContainerTemperature, methodCollectionContainerEquilibrationTime,
    (*Resolved Options*)
    resolvedFractionationTechnique,resolvedPelletInstrument, resolvedPelletIntensity,resolvedPelletTime, resolvedSupernatantVolume, resolvedSupernatantStorageCondition, resolvedSupernatantContainer, resolvedSupernatantLabel, resolvedSupernatantContainerLabel, resolvedFilterTechnique, resolvedFilterInstrument, resolvedFilterCentrifugeIntensity, resolvedFilterPressure, resolvedFilterTime, resolvedFiltrateStorageCondition, resolvedFiltrateContainer, resolvedFiltrateLabel, resolvedFiltrateContainerLabel,resolvedCollectionContainerTemperature, resolvedCollectionContainerEquilibrationTime,resolvedContainerOut,resolvedContainerOutLabel,resolvedSampleOutLabel,
    (*Other variables*)
    workingVolume,collectedVolume,sampleInFilter,resolvedFractionationOptions
  },
  (*Find the names of each option from the stepOptionNameMap.*)
  {
    (*Pellet*)
    pelletInstrumentOptionName,
    pelletIntensityOptionName,
    pelletTimeOptionName,
    supernatantVolumeOptionName,
    supernatantStorageConditionOptionName,
    supernatantContainerOptionName,
    supernatantLabelOptionName,
    supernatantContainerLabelOptionName,
    (*Filter*)
    filterTechniqueOptionName,
    filterInstrumentOptionName,
    filterCentrifugeIntensityOptionName,
    filterPressureOptionName,
    filterTimeOptionName,
    filtrateStorageConditionOptionName,
    filtrateContainerOptionName,
    filtrateLabelOptionName,
    filtrateContainerLabelOptionName,
    (*Shared*)
    fractionationTechniqueOptionName,
    collectionContainerTemperatureOptionName,
    collectionContainerEquilibrationTimeOptionName,
    containerOutOptionName,
    containerOutLabelOptionName,
    sampleOutLabelOptionName
  } = Map[If[
    KeyExistsQ[stepOptionNameMap, #],
    Lookup[stepOptionNameMap, #],
    Null]&,
    {
      (*Pellet*)
      PelletInstrument, PelletIntensity, PelletTime, SupernatantVolume, SupernatantStorageCondition, SupernatantContainer, SupernatantLabel, SupernatantContainerLabel,
      (*Filter*)
      FilterTechnique, FilterInstrument, FilterCentrifugeIntensity, FilterPressure, FilterTime, FiltrateStorageCondition, FiltrateContainer, FiltrateLabel, FiltrateContainerLabel,
      (*Shared*)
      FractionationTechnique,CollectionContainerTemperature, CollectionContainerEquilibrationTime,ContainerOut,ContainerOutLabel,SampleOutLabel
    }
  ];

  (*Lookup the user specified option value*)
  {fractionationTechnique,pelletInstrument, pelletIntensity, pelletTime, supernatantVolume, supernatantStorageCondition, supernatantContainer, supernatantLabel, supernatantContainerLabel, filterTechnique, filterInstrument, filterCentrifugeIntensity, filterPressure, filterTime, filtrateStorageCondition, filtrateContainer, filtrateLabel, filtrateContainerLabel, collectionContainerTemperature,collectionContainerEquilibrationTime,containerOut,containerOutLabel,sampleOutLabel}=Lookup[userInputMapThreadOptions,
    {fractionationTechniqueOptionName,pelletInstrumentOptionName, pelletIntensityOptionName, pelletTimeOptionName, supernatantVolumeOptionName, supernatantStorageConditionOptionName, supernatantContainerOptionName, supernatantLabelOptionName, supernatantContainerLabelOptionName, filterTechniqueOptionName, filterInstrumentOptionName, filterCentrifugeIntensityOptionName, filterPressureOptionName, filterTimeOptionName, filtrateStorageConditionOptionName, filtrateContainerOptionName, filtrateLabelOptionName, filtrateContainerLabelOptionName, collectionContainerTemperatureOptionName,collectionContainerEquilibrationTimeOptionName,containerOutOptionName,containerOutLabelOptionName, sampleOutLabelOptionName}];

  (*Categorize lists of user input options *)
  essentialPelletOptions = {pelletInstrument, pelletIntensity, pelletTime, supernatantVolume, supernatantContainer};
  filterOptions = {filterTechnique, filterInstrument, filterCentrifugeIntensity, filterPressure, filterTime, filtrateStorageCondition, filtrateContainer, filtrateLabel, filtrateContainerLabel};

  (*Look up the user-specified method option values*)
  {methodFractionationTechnique,methodPelletInstrument, methodPelletIntensity,methodPelletTime, methodSupernatantVolume, methodSupernatantStorageCondition, methodSupernatantContainer, methodSupernatantLabel, methodSupernatantContainerLabel, methodFilterTechnique, methodFilterInstrument, methodFilterCentrifugeIntensity, methodFilterPressure, methodFilterTime, methodFiltrateStorageCondition, methodFiltrateContainer, methodFiltrateLabel, methodFiltrateContainerLabel, methodCollectionContainerTemperature, methodCollectionContainerEquilibrationTime}=If[MatchQ[resolvedMethodPacket,PacketP[]],
    Lookup[resolvedMethodPacket,#,Null]&/@ {fractionationTechniqueOptionName,pelletInstrumentOptionName, pelletIntensityOptionName, pelletTimeOptionName, supernatantVolumeOptionName, supernatantStorageConditionOptionName, supernatantContainerOptionName, supernatantLabelOptionName, supernatantContainerLabelOptionName, filterTechniqueOptionName, filterInstrumentOptionName, filterCentrifugeIntensityOptionName, filterPressureOptionName, filterTimeOptionName, filtrateStorageConditionOptionName, filtrateContainerOptionName, filtrateLabelOptionName, filtrateContainerLabelOptionName, collectionContainerTemperatureOptionName,collectionContainerEquilibrationTimeOptionName},
    ConstantArray[Null,20]
  ];

  (*Resolve fractionation technique*)
  resolvedFractionationTechnique = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[fractionationTechnique,Except[Automatic]],
      fractionationTechnique,
    (*If this fractionation step is performed, and if sample is already in filter due to previous steps , or any of the filter options is specified by user, or any of the essential pellet option is set to Null while this fraction is in fractionation order, set to Filter*)
    MemberQ[fractionationOrder,stepFraction]&&Or[
      sampleAlreadyInFilter,
      MemberQ[Flatten[filterOptions],Except[Alternatives[Automatic,Null]]],
      MemberQ[fractionationOrder,stepFraction]&&MemberQ[Flatten[essentialPelletOptions],Null]
    ],
      Filter,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodFractionationTechnique, Except[Null]],
      methodFractionationTechnique,
    (*If this step is in fractionation order, set to pellet*)
    MemberQ[fractionationOrder,stepFraction],
      Pellet,
    (*Otherwise this fractionation is not performed, set to Null*)
    True,
      Null
  ];

  (*Resolve Pellet Instrument*)
  resolvedPelletInstrument = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[pelletInstrument,Except[Automatic]],
      pelletInstrument,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodPelletInstrument, Except[Null]],
      methodPelletInstrument,
    (*If the stage fractionation technique is set to Filter or not performed, set to Null*)
    MatchQ[resolvedFractionationTechnique,Null|Filter],
      Null,
    (*Otherwise set to default value*)
    True,
      Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"] (*Model[Instrument, Centrifuge, "HiG4"]*)
  ];

  (*Resolve Pellet Intensity*)
  resolvedPelletIntensity = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[pelletIntensity,Except[Automatic]],
    pelletIntensity,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodPelletIntensity, Except[Null]],
    methodPelletIntensity,
    (*If the stage fractionation technique is set to Filter or not performed, set to Null*)
    MatchQ[resolvedFractionationTechnique,Null|Filter],
    Null,
    (*Otherwise set to default value*)
    True,
    3600 GravitationalAcceleration
  ];

  (*Resolve Pellet Time*)
  resolvedPelletTime = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[pelletTime,Except[Automatic]],
    pelletTime,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodPelletTime, Except[Null]],
    methodPelletTime,
    (*If the stage fractionation technique is set to Filter or not performed, set to Null*)
    MatchQ[resolvedFractionationTechnique,Null|Filter],
    Null,
    (*Otherwise set to default value based on fraction and cell type*)
    True,
    Switch[{stepFraction,cellType},
      {Cytosolic,MicrobialCellTypeP},30 Minute,
      {Cytosolic,Mammalian},5 Minute,
      {Membrane|Nuclear,MicrobialCellTypeP},45 Minute,
      {Membrane|Nuclear,Mammalian},10 Minute,
      (*Unknown or unspecified cell types*)
      {_,_},15 Minute
    ]
  ];

  resolvedSupernatantVolume = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[supernatantVolume,Except[Automatic]],
      supernatantVolume,
    MatchQ[resolvedFractionationTechnique,Null|Filter],
      Null,
    True,
      SafeRound[startingVolume*0.9,1 Microliter]
  ];

  (*Resolve supernatant storage condition*)
  resolvedSupernatantStorageCondition = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[supernatantStorageCondition,Except[Automatic]],
      supernatantStorageCondition,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodSupernatantStorageCondition, Except[Null]],
      methodSupernatantStorageCondition,
    MatchQ[resolvedFractionationTechnique,Null|Filter],
      Null,
    True,
      Freezer
  ];
  (*Resolve supernatant container *)
  resolvedSupernatantContainer = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[supernatantContainer,Except[Automatic]],
      supernatantContainer,
    MatchQ[resolvedFractionationTechnique,Null|Filter],
      Null,
    (*If there is no purification, then this is container out of the fraction*)
    MatchQ[purification,None],
      containerOut,
    (*Leave it to be resolved by ExperimentPrecipitate*)
    True,
      Automatic
  ];

  (*Resolve supernatant label*)
  resolvedSupernatantLabel = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[supernatantLabel,Except[Automatic]],
      supernatantLabel,
    MatchQ[resolvedFractionationTechnique,Null|Filter],
      Null,
    (*If there is no purification, then this gets the label of ExtractedXXProteinLabel*)
    MatchQ[purification,None],
      Switch[stepFraction,
        Cytosolic,Lookup[userInputMapThreadOptions,ExtractedCytosolicProteinLabel,Automatic],
        Membrane,Lookup[userInputMapThreadOptions,ExtractedMembraneProteinLabel,Automatic],
        Nuclear,Lookup[userInputMapThreadOptions,ExtractedNuclearProteinLabel,Automatic],
        _,Automatic
      ],
    True,
      Automatic
  ];

  (*Resolve supernatant container label*)
  resolvedSupernatantContainerLabel = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[supernatantContainerLabel,Except[Automatic]],
      supernatantContainerLabel,
    MatchQ[resolvedFractionationTechnique,Null|Filter],
      Null,
    (*If there is no purification, then this gets the label of ExtractedXXProteinLabel*)
    MatchQ[purification,None],
      Switch[stepFraction,
        Cytosolic,Lookup[userInputMapThreadOptions,ExtractedCytosolicProteinContainerLabel,Automatic],
        Membrane,Lookup[userInputMapThreadOptions,ExtractedMembraneProteinContainerLabel,Automatic],
        Nuclear,Lookup[userInputMapThreadOptions,ExtractedNuclearProteinContainerLabel,Automatic],
        _,Automatic
      ],
    True,
      Automatic
  ];

  (*Resolve filter technique*)
  resolvedFilterTechnique = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[filterTechnique,Except[Automatic]],
      filterTechnique,
    (*If the FilterCentrifuge option is specified by user while this fraction is in Fractionation Order, set to Centrifuge*)
    MemberQ[fractionationOrder,stepFraction]&&MatchQ[filterCentrifugeIntensity,Except[Automatic|Null]],
      Centrifuge,
    (*If the FilterCentrifuge option is specified by user to be Null while this fraction is in Fractionation Order, set to AirPressure*)
    MemberQ[fractionationOrder,stepFraction]&&MatchQ[filterCentrifugeIntensity,Except[Automatic|Null]],
      AirPressure,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodFilterTechnique, Except[Null]],
     methodFilterTechnique,
    (*If the stage fractionation technique is set to Filter or not performed, set to Null*)
    MatchQ[resolvedFractionationTechnique,Null|Pellet],
      Null,
    (*Otherwise set to default value*)
    True,
      AirPressure
  ];

  (*Resolve filter instrument*)
  resolvedFilterInstrument= Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[filterInstrument,Except[Automatic]],
    filterInstrument,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodFilterInstrument, Except[Null]],
    methodFilterInstrument,
    (*If the stage fractionation technique is set to Filter or not performed, set to Null*)
    MatchQ[resolvedFractionationTechnique,Null|Pellet],
    Null,
    (*Otherwise set to default value*)
    True,
    Switch[resolvedFilterTechnique,
      AirPressure,Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
      Centrifuge,Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
      _,Automatic
    ]
  ];

  (*Resolve filter centrifuge intensity*)
  resolvedFilterCentrifugeIntensity= Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[filterCentrifugeIntensity,Except[Automatic]],
      filterCentrifugeIntensity,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodFilterCentrifugeIntensity, Except[Null]],
      methodFilterCentrifugeIntensity,
    (*If the stage fractionation technique is set to Filter or not performed, or filter technique is air pressure, set to Null*)
    Or[
      MatchQ[resolvedFractionationTechnique,Null|Pellet],
      MatchQ[resolvedFilterTechnique,AirPressure]
    ],
      Null,
    (*Otherwise let Precipitate resolve*)
    True,
      Automatic

  ];

  (*Resolve filter pressure*)
  resolvedFilterPressure= Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[filterPressure,Except[Automatic]],
    filterPressure,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodFilterPressure, Except[Null]],
    methodFilterPressure,
    (*If the stage fractionation technique is set to Filter or not performed, or filter technique is air pressure, set to Null*)
    Or[
      MatchQ[resolvedFractionationTechnique,Null|Pellet],
      MatchQ[resolvedFilterTechnique,Centrifuge]
    ],
      Null,
    (*Otherwise let Precipitate resolve*)
    True,
      Automatic
  ];

  (*Resolve filter Time*)
  resolvedFilterTime= Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[filterTime,Except[Automatic]],
      filterTime,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodFilterTime, Except[Null]],
      methodFilterTime,
    (*If the stage fractionation technique is set to Filter or not performed, or filter technique is air Time, set to Null*)
    MatchQ[resolvedFractionationTechnique,Null|Pellet],
      Null,
    (*Otherwise set to 1 Minute*)
    True,
      1 Minute
  ];

  (*Resolve filtrate storage condition*)
  resolvedFiltrateStorageCondition = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[filtrateStorageCondition,Except[Automatic]],
      filtrateStorageCondition,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodFiltrateStorageCondition, Except[Null]],
      methodFiltrateStorageCondition,
    MatchQ[resolvedFractionationTechnique,Null|Pellet],
      Null,
    True,
      Freezer (*Or Null if followed by Purification of this fraction, Disposal if this fraction is not in Target?*)
  ];

  (*Resolve filtrate container *)
  resolvedFiltrateContainer = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[filtrateContainer,Except[Automatic]],
      filtrateContainer,
    MatchQ[resolvedFractionationTechnique,Null|Pellet],
      Null,
    (*If there is no purification, then this is container out of the fraction*)
    MatchQ[purification,None],
      containerOut,
    (*Leave it to be resolved by ExperimentPrecipitate*)
    True,
      Automatic
  ];

  (*Resolve filtrate label*)
  resolvedFiltrateLabel = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[filtrateLabel,Except[Automatic]],
      filtrateLabel,
    MatchQ[resolvedFractionationTechnique,Null|Pellet],
      Null,
    (*If there is no purification, then this gets the label of ExtractedXXProteinLabel*)
    MatchQ[purification,None],
      Switch[stepFraction,
        Cytosolic,Lookup[userInputMapThreadOptions,ExtractedCytosolicProteinLabel,Automatic],
        Membrane,Lookup[userInputMapThreadOptions,ExtractedMembraneProteinLabel,Automatic],
        Nuclear,Lookup[userInputMapThreadOptions,ExtractedNuclearProteinLabel,Automatic],
        _,Automatic
      ],
    True,
      Automatic
  ];

  (*Resolve filtrate container label*)
  resolvedFiltrateContainerLabel = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[filtrateContainerLabel,Except[Automatic]],
      filtrateContainerLabel,
    MatchQ[resolvedFractionationTechnique,Null|Pellet],
      Null,
    (*If there is no purification, then this gets the label of ExtractedXXProteinLabel*)
    MatchQ[purification,None],
      Switch[stepFraction,
        Cytosolic,Lookup[userInputMapThreadOptions,ExtractedCytosolicProteinContainerLabel,Automatic],
        Membrane,Lookup[userInputMapThreadOptions,ExtractedMembraneProteinContainerLabel,Automatic],
        Nuclear,Lookup[userInputMapThreadOptions,ExtractedNuclearProteinContainerLabel,Automatic],
        _,Automatic
      ],
    True,
      Automatic
  ];

  (*Resolve collection container temperature*)
  resolvedCollectionContainerTemperature = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[collectionContainerTemperature,Except[Automatic]],
      collectionContainerTemperature,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodCollectionContainerTemperature, Except[Null]],
      methodCollectionContainerTemperature,
    (*If this step is in fractionation order, set to 4 Celsius*)
    MemberQ[fractionationOrder,stepFraction]&&!MatchQ[collectionContainerEquilibrationTime,Null],
      4 Celsius,
    (*Otherwise this fractionation is not performed, set to Null*)
    True,
      Null
  ];

  (*Resolve collection container equilibration time*)
  resolvedCollectionContainerEquilibrationTime = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[collectionContainerEquilibrationTime,Except[Automatic]],
      collectionContainerEquilibrationTime,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodCollectionContainerEquilibrationTime, Except[Null]],
      methodCollectionContainerEquilibrationTime,
    (*If CollectionContainerTemperature is not Null or Ambient*)
    MatchQ[resolvedCollectionContainerTemperature,Except[Null|Ambient]],
      10 Minute,
    (*Otherwise no equilibration is needed, set to Null*)
    True,
      Null
  ];

  (*Resolve container out*)
  resolvedContainerOut = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[containerOut,Except[Automatic]],
      containerOut,
    (*If no purification is performed then this is the last step of the fraction sample, determine based on technique *)
    MatchQ[purification,None],
      Switch[resolvedFractionationTechnique,
        Pellet,resolvedSupernatantContainer,
        Filter,resolvedFiltrateContainer,
        _,Null
      ],
    (*Purification is to be performed, let it be dealt with later in shared resolver*)
    True,
      Automatic
  ];
  (*Resolve container out label*)
  resolvedContainerOutLabel = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[containerOutLabel,Except[Automatic]],
      containerOutLabel,
    (*If no purification is performed then this is the last step of the fraction sample, determine based on technique *)
    MatchQ[purification,None],
      Switch[resolvedFractionationTechnique,
        Pellet,resolvedSupernatantContainerLabel,
        Filter,resolvedFiltrateContainerLabel,
        _,Null
      ],
    (*Purification is to be performed, let it be dealt with later in shared resolver*)
    True,
      Automatic
  ];

  (*Resolve sample out label*)
  resolvedSampleOutLabel = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[sampleOutLabel,Except[Automatic]],
      sampleOutLabel,
    (*If no purification is performed then this is the last step of the fraction sample, determine based on technique *)
    MatchQ[purification,None],
      Switch[resolvedFractionationTechnique,
        Pellet,resolvedSupernatantLabel,
        Filter,resolvedFiltrateLabel,
        _,Null
      ],
    (*Purification is to be performed, let it be dealt with later in shared resolver*)
    True,
      Automatic
  ];

  (*Compile resolved options rules*)
  resolvedFractionationOptions = {
    (*Pellet*)
    pelletInstrumentOptionName -> resolvedPelletInstrument,
    pelletIntensityOptionName -> resolvedPelletIntensity,
    pelletTimeOptionName -> resolvedPelletTime,
    supernatantVolumeOptionName -> resolvedSupernatantVolume,
    supernatantStorageConditionOptionName -> resolvedSupernatantStorageCondition,
    supernatantContainerOptionName -> resolvedSupernatantContainer,
    supernatantLabelOptionName -> resolvedSupernatantLabel,
    supernatantContainerLabelOptionName -> resolvedSupernatantContainerLabel,
    (*Filter*)
    filterTechniqueOptionName -> resolvedFilterTechnique,
    filterInstrumentOptionName -> resolvedFilterInstrument,
    filterCentrifugeIntensityOptionName -> resolvedFilterCentrifugeIntensity,
    filterPressureOptionName -> resolvedFilterPressure,
    filterTimeOptionName -> resolvedFilterTime,
    filtrateStorageConditionOptionName -> resolvedFiltrateStorageCondition,
    filtrateContainerOptionName -> resolvedFiltrateContainer,
    filtrateLabelOptionName -> resolvedFiltrateLabel,
    filtrateContainerLabelOptionName -> resolvedFiltrateContainerLabel,
    (*Shared*)
    fractionationTechniqueOptionName -> resolvedFractionationTechnique,
    collectionContainerTemperatureOptionName -> resolvedCollectionContainerTemperature,
    collectionContainerEquilibrationTimeOptionName -> resolvedCollectionContainerEquilibrationTime,
    containerOutOptionName -> resolvedContainerOut,
    containerOutLabelOptionName -> resolvedContainerOutLabel,
    sampleOutLabelOptionName -> resolvedSampleOutLabel
  };

  (*Update current volume depend on technique. If technique is filter, assume all fluid goes through, leaving no volume on filter for next step*)
  workingVolume = Switch[resolvedFractionationTechnique,
    Pellet, startingVolume-resolvedSupernatantVolume,
    Filter, 0 Microliter,
    _, startingVolume
  ];

  (*Calculate the collected volume for purification or storage if no purification*)
  collectedVolume=Switch[resolvedFractionationTechnique,
    Filter,startingVolume,
    Pellet,resolvedSupernatantVolume,
    _,Null
  ];

  (*Update if working sample is in filter*)
  (*If the sample was already in a filter at the start of this fractionation step, it is not allowed to perform pellet*)
  sampleInFilter = If[sampleAlreadyInFilter||MatchQ[resolvedFractionationTechnique,Filter],
    True,
    False
  ];

  (*Return resolved options and volume-tracking variables*)
  {resolvedFractionationOptions,workingVolume,collectedVolume,sampleInFilter}
];

(*Helper functions --- preResolve MembraneWash+Solubilization or NuclearWash+Lysis options*)

preResolvePreFractionationWashAndPrepOptions[
  stepFraction:Membrane|Nuclear,
  sampleAlreadyInFilter:BooleanP,
  experimentInitialSampleVolume:VolumeP,
  maxVolumeCapacity:VolumeP,(*max volume of container or filter*)
  userInputMapThreadOptions_Association,
  stepOptionNameMap:{_Rule..},
  useMethodQ:BooleanP,
  resolvedMethodPacket:<||>|PacketP[Object[Method]]|Null,
  fractionationOrder:ListableP[Cytosolic|Membrane|Nuclear],
  cellType:CellTypeP|Unspecified|Automatic|Null,
  purification:ListableP[Alternatives[LiquidLiquidExtraction,Precipitation,SolidPhaseExtraction,MagneticBeadSeparation,None]],
  startingVolume:VolumeP
]:=Module[
  {
    (*Option Names*)
    numberOfWashesOptionName, washSolutionOptionName, washSolutionVolumeOptionName, washSolutionTemperatureOptionName, washSolutionEquilibrationTimeOptionName, washIncubationTimeOptionName, washIncubationTemperatureOptionName, washSeparationTechniqueOptionName, washPelletInstrumentOptionName, washPelletIntensityOptionName, washPelletTimeOptionName, washSupernatantVolumeOptionName, washSupernatantContainerOptionName, washSupernatantLabelOptionName, washSupernatantContainerLabelOptionName, washSupernatantStorageConditionOptionName, washFilterTechniqueOptionName, washFilterInstrumentOptionName, washFilterCentrifugeIntensityOptionName, washFilterPressureOptionName, washFilterTimeOptionName, washFiltrateStorageConditionOptionName, washFiltrateContainerOptionName, washFiltrateLabelOptionName, washFiltrateContainerLabelOptionName, washCollectionContainerTemperatureOptionName, washCollectionContainerEquilibrationTimeOptionName, washMixTypeOptionName, washMixRateOptionName, washMixTimeOptionName, numberOfWashMixesOptionName, washMixVolumeOptionName, washMixTemperatureOptionName, fractionIncubationSolutionOptionName, fractionIncubationSolutionVolumeOptionName, fractionIncubationSolutionTemperatureOptionName, fractionIncubationSolutionEquilibrationTimeOptionName,fractionIncubationTimeOptionName, fractionIncubationTemperatureOptionName, fractionIncubationMixTypeOptionName, fractionIncubationMixRateOptionName, fractionIncubationMixTimeOptionName, numberOfFractionIncubationMixesOptionName, fractionIncubationMixVolumeOptionName, fractionIncubationMixTemperatureOptionName,
    (*User Specified Option Values*)
    numberOfWashes, washSolution, washSolutionVolume, washSolutionTemperature, washSolutionEquilibrationTime, washIncubationTime, washIncubationTemperature, washSeparationTechnique, washPelletInstrument, washPelletIntensity, washPelletTime, washSupernatantVolume, washSupernatantContainer, washSupernatantLabel, washSupernatantContainerLabel, washSupernatantStorageCondition, washFilterTechnique, washFilterInstrument, washFilterCentrifugeIntensity, washFilterPressure, washFilterTime, washFiltrateStorageCondition, washFiltrateContainer, washFiltrateLabel, washFiltrateContainerLabel, washCollectionContainerTemperature, washCollectionContainerEquilibrationTime, washMixType, washMixRate, washMixTime, numberOfWashMixes, washMixVolume, washMixTemperature, fractionIncubationSolution, fractionIncubationSolutionVolume, fractionIncubationSolutionTemperature, fractionIncubationSolutionEquilibrationTime,fractionIncubationTime, fractionIncubationTemperature, fractionIncubationMixType, fractionIncubationMixRate, fractionIncubationMixTime, numberOfFractionIncubationMixes, fractionIncubationMixVolume, fractionIncubationMixTemperature,
    (*User-Specified Method Option Values*)
    methodNumberOfWashes, methodWashSolution, methodWashSolutionVolume, methodWashSolutionTemperature, methodWashSolutionEquilibrationTime, methodWashIncubationTime, methodWashIncubationTemperature, methodWashSeparationTechnique, methodWashPelletInstrument, methodWashPelletIntensity, methodWashPelletTime, methodWashSupernatantVolume, methodWashSupernatantContainer, methodWashSupernatantLabel, methodWashSupernatantContainerLabel, methodWashSupernatantStorageCondition, methodWashFilterTechnique, methodWashFilterInstrument, methodWashFilterCentrifugeIntensity, methodWashFilterPressure, methodWashFilterTime, methodWashFiltrateStorageCondition, methodWashFiltrateContainer, methodWashFiltrateLabel, methodWashFiltrateContainerLabel, methodWashCollectionContainerTemperature, methodWashCollectionContainerEquilibrationTime, methodWashMixType, methodWashMixRate, methodWashMixTime, methodNumberOfWashMixes, methodWashMixVolume, methodWashMixTemperature, methodFractionIncubationSolution, methodFractionIncubationSolutionVolume, methodFractionIncubationSolutionTemperature, methodFractionIncubationSolutionEquilibrationTime,methodFractionIncubationTime, methodFractionIncubationTemperature, methodFractionIncubationMixType, methodFractionIncubationMixRate, methodFractionIncubationMixTime, methodNumberOfFractionIncubationMixes, methodFractionIncubationMixVolume, methodFractionIncubationMixTemperature,
    (*Resolved Options*)
    resolvedNumberOfWashes, resolvedWashSolution, resolvedWashSolutionVolume, resolvedWashSolutionTemperature, resolvedWashSolutionEquilibrationTime, resolvedWashIncubationTime, resolvedWashIncubationTemperature, resolvedWashSeparationTechnique, resolvedWashPelletInstrument, resolvedWashPelletIntensity, resolvedWashPelletTime, resolvedWashSupernatantVolume, resolvedWashSupernatantContainer, resolvedWashSupernatantLabel, resolvedWashSupernatantContainerLabel, resolvedWashSupernatantStorageCondition, resolvedWashFilterTechnique, resolvedWashFilterInstrument, resolvedWashFilterCentrifugeIntensity, resolvedWashFilterPressure, resolvedWashFilterTime, resolvedWashFiltrateStorageCondition, resolvedWashFiltrateContainer, resolvedWashFiltrateLabel, resolvedWashFiltrateContainerLabel, resolvedWashCollectionContainerTemperature, resolvedWashCollectionContainerEquilibrationTime, resolvedFractionIncubationSolution, resolvedFractionIncubationSolutionVolume, resolvedFractionIncubationSolutionTemperature, resolvedFractionIncubationSolutionEquilibrationTime,resolvedFractionIncubationTime, resolvedFractionIncubationTemperature,
    (*Other variables*)
    workingVolume,resolvedWashMixOptions,resolvedWashOptions,resolvedFractionIncubationMixOptions,resolvedFractionIncubationOptions
  },

  (*Find the names of each option from the stepOptionNameMap.*)
  {
    (*Wash*)
    numberOfWashesOptionName, washSolutionOptionName, washSolutionVolumeOptionName, washSolutionTemperatureOptionName, washSolutionEquilibrationTimeOptionName, washIncubationTimeOptionName, washIncubationTemperatureOptionName, washSeparationTechniqueOptionName, washPelletInstrumentOptionName, washPelletIntensityOptionName, washPelletTimeOptionName, washSupernatantVolumeOptionName, washSupernatantContainerOptionName, washSupernatantLabelOptionName, washSupernatantContainerLabelOptionName, washSupernatantStorageConditionOptionName, washFilterTechniqueOptionName, washFilterInstrumentOptionName, washFilterCentrifugeIntensityOptionName, washFilterPressureOptionName, washFilterTimeOptionName, washFiltrateStorageConditionOptionName, washFiltrateContainerOptionName, washFiltrateLabelOptionName, washFiltrateContainerLabelOptionName, washCollectionContainerTemperatureOptionName, washCollectionContainerEquilibrationTimeOptionName,
    (*washMix*)
    washMixTypeOptionName, washMixRateOptionName, washMixTimeOptionName, numberOfWashMixesOptionName, washMixVolumeOptionName, washMixTemperatureOptionName,
    (*FractionIncubation: MembraneSolubilization/NuclearLysis*)
    fractionIncubationSolutionOptionName, fractionIncubationSolutionVolumeOptionName, fractionIncubationSolutionTemperatureOptionName, fractionIncubationSolutionEquilibrationTimeOptionName,fractionIncubationTimeOptionName, fractionIncubationTemperatureOptionName,
    (*FractionIncubationMix*)
    fractionIncubationMixTypeOptionName, fractionIncubationMixRateOptionName, fractionIncubationMixTimeOptionName, numberOfFractionIncubationMixesOptionName, fractionIncubationMixVolumeOptionName, fractionIncubationMixTemperatureOptionName
  }=Map[If[
    KeyExistsQ[stepOptionNameMap, #],
    Lookup[stepOptionNameMap, #],
    Null]&,
    {
      (*Wash*)
      NumberOfWashes, WashSolution, WashSolutionVolume, WashSolutionTemperature, WashSolutionEquilibrationTime, WashIncubationTime, WashIncubationTemperature, WashSeparationTechnique, WashPelletInstrument, WashPelletIntensity, WashPelletTime, WashSupernatantVolume, WashSupernatantContainer, WashSupernatantLabel, WashSupernatantContainerLabel, WashSupernatantStorageCondition, WashFilterTechnique, WashFilterInstrument, WashFilterCentrifugeIntensity, WashFilterPressure, WashFilterTime, WashFiltrateStorageCondition, WashFiltrateContainer, WashFiltrateLabel, WashFiltrateContainerLabel, WashCollectionContainerTemperature, WashCollectionContainerEquilibrationTime,
      (*WashMix*)
      WashMixType, WashMixRate, WashMixTime, NumberOfWashMixes, WashMixVolume, WashMixTemperature,
      (*FractionIncubation: MembraneSolubilization/NuclearLysis*)
      FractionIncubationSolution, FractionIncubationSolutionVolume, FractionIncubationSolutionTemperature, FractionIncubationSolutionEquilibrationTime,FractionIncubationTime, FractionIncubationTemperature,
      (*FractionIncubationMix*)
      FractionIncubationMixType, FractionIncubationMixRate, FractionIncubationMixTime, NumberOfFractionIncubationMixes, FractionIncubationMixVolume, FractionIncubationMixTemperature
    }
  ];

  (*Lookup the user specified option value*)
  {
    (*Wash*)
    numberOfWashes, washSolution, washSolutionVolume, washSolutionTemperature, washSolutionEquilibrationTime, washIncubationTime, washIncubationTemperature, washSeparationTechnique, washPelletInstrument, washPelletIntensity, washPelletTime, washSupernatantVolume, washSupernatantContainer, washSupernatantLabel, washSupernatantContainerLabel, washSupernatantStorageCondition, washFilterTechnique, washFilterInstrument, washFilterCentrifugeIntensity, washFilterPressure, washFilterTime, washFiltrateStorageCondition, washFiltrateContainer, washFiltrateLabel, washFiltrateContainerLabel, washCollectionContainerTemperature, washCollectionContainerEquilibrationTime,
    (*washMix*)
    washMixType, washMixRate, washMixTime, numberOfWashMixes, washMixVolume, washMixTemperature,
    (*FractionIncubation: MembraneSolubilization/NuclearLysis*)
    fractionIncubationSolution, fractionIncubationSolutionVolume, fractionIncubationSolutionTemperature, fractionIncubationSolutionEquilibrationTime,fractionIncubationTime, fractionIncubationTemperature,
    (*FractionIncubationMix*)
    fractionIncubationMixType, fractionIncubationMixRate, fractionIncubationMixTime, numberOfFractionIncubationMixes, fractionIncubationMixVolume, fractionIncubationMixTemperature
  }=Lookup[userInputMapThreadOptions,
    {
      (*Wash*)
      numberOfWashesOptionName, washSolutionOptionName, washSolutionVolumeOptionName, washSolutionTemperatureOptionName, washSolutionEquilibrationTimeOptionName, washIncubationTimeOptionName, washIncubationTemperatureOptionName, washSeparationTechniqueOptionName, washPelletInstrumentOptionName, washPelletIntensityOptionName, washPelletTimeOptionName, washSupernatantVolumeOptionName, washSupernatantContainerOptionName, washSupernatantLabelOptionName, washSupernatantContainerLabelOptionName, washSupernatantStorageConditionOptionName, washFilterTechniqueOptionName, washFilterInstrumentOptionName, washFilterCentrifugeIntensityOptionName, washFilterPressureOptionName, washFilterTimeOptionName, washFiltrateStorageConditionOptionName, washFiltrateContainerOptionName, washFiltrateLabelOptionName, washFiltrateContainerLabelOptionName, washCollectionContainerTemperatureOptionName, washCollectionContainerEquilibrationTimeOptionName,
      (*washMix*)
      washMixTypeOptionName, washMixRateOptionName, washMixTimeOptionName, numberOfWashMixesOptionName, washMixVolumeOptionName, washMixTemperatureOptionName,
      (*FractionIncubation: MembraneSolubilization/NuclearLysis*)
      fractionIncubationSolutionOptionName, fractionIncubationSolutionVolumeOptionName, fractionIncubationSolutionTemperatureOptionName, fractionIncubationSolutionEquilibrationTimeOptionName,fractionIncubationTimeOptionName, fractionIncubationTemperatureOptionName,
      (*FractionIncubationMix*)
      fractionIncubationMixTypeOptionName, fractionIncubationMixRateOptionName, fractionIncubationMixTimeOptionName, numberOfFractionIncubationMixesOptionName, fractionIncubationMixVolumeOptionName, fractionIncubationMixTemperatureOptionName
    }
  ];

  (*Categorize lists of user input options *)

  (*Look up the user-specified method option values*)
  {
    (*Wash*)
    methodNumberOfWashes, methodWashSolution, methodWashSolutionVolume, methodWashSolutionTemperature, methodWashSolutionEquilibrationTime, methodWashIncubationTime, methodWashIncubationTemperature, methodWashSeparationTechnique, methodWashPelletInstrument, methodWashPelletIntensity, methodWashPelletTime, methodWashSupernatantVolume, methodWashSupernatantContainer, methodWashSupernatantLabel, methodWashSupernatantContainerLabel, methodWashSupernatantStorageCondition, methodWashFilterTechnique, methodWashFilterInstrument, methodWashFilterCentrifugeIntensity, methodWashFilterPressure, methodWashFilterTime, methodWashFiltrateStorageCondition, methodWashFiltrateContainer, methodWashFiltrateLabel, methodWashFiltrateContainerLabel, methodWashCollectionContainerTemperature, methodWashCollectionContainerEquilibrationTime,
    (*methodWashMix*)
    methodWashMixType, methodWashMixRate, methodWashMixTime, methodNumberOfWashMixes, methodWashMixVolume, methodWashMixTemperature,
    (*methodFractionIncubation: MembraneSolubilization/NuclearLysis*)
    methodFractionIncubationSolution, methodFractionIncubationSolutionVolume, methodFractionIncubationSolutionTemperature, methodFractionIncubationSolutionEquilibrationTime,methodFractionIncubationTime, methodFractionIncubationTemperature,
    (*methodFractionIncubationMix*)
    methodFractionIncubationMixType, methodFractionIncubationMixRate, methodFractionIncubationMixTime, methodNumberOfFractionIncubationMixes, methodFractionIncubationMixVolume, methodFractionIncubationMixTemperature
  }=If[MatchQ[resolvedMethodPacket,PacketP[]],
    Lookup[resolvedMethodPacket,#,Null]&/@ {
      (*Wash*)
      numberOfWashesOptionName, washSolutionOptionName, washSolutionVolumeOptionName, washSolutionTemperatureOptionName, washSolutionEquilibrationTimeOptionName, washIncubationTimeOptionName, washIncubationTemperatureOptionName, washSeparationTechniqueOptionName, washPelletInstrumentOptionName, washPelletIntensityOptionName, washPelletTimeOptionName, washSupernatantVolumeOptionName, washSupernatantContainerOptionName, washSupernatantLabelOptionName, washSupernatantContainerLabelOptionName, washSupernatantStorageConditionOptionName, washFilterTechniqueOptionName, washFilterInstrumentOptionName, washFilterCentrifugeIntensityOptionName, washFilterPressureOptionName, washFilterTimeOptionName, washFiltrateStorageConditionOptionName, washFiltrateContainerOptionName, washFiltrateLabelOptionName, washFiltrateContainerLabelOptionName, washCollectionContainerTemperatureOptionName, washCollectionContainerEquilibrationTimeOptionName,
      (*washMix*)
      washMixTypeOptionName, washMixRateOptionName, washMixTimeOptionName, numberOfWashMixesOptionName, washMixVolumeOptionName, washMixTemperatureOptionName,
      (*FractionIncubation: MembraneSolubilization/NuclearLysis*)
      fractionIncubationSolutionOptionName, fractionIncubationSolutionVolumeOptionName, fractionIncubationSolutionTemperatureOptionName, fractionIncubationSolutionEquilibrationTimeOptionName,fractionIncubationTimeOptionName, fractionIncubationTemperatureOptionName,
      (*FractionIncubationMix*)
      fractionIncubationMixTypeOptionName, fractionIncubationMixRateOptionName, fractionIncubationMixTimeOptionName, numberOfFractionIncubationMixesOptionName, fractionIncubationMixVolumeOptionName, fractionIncubationMixTemperatureOptionName
    },
    ConstantArray[Null,45]
  ];

  (*Resolve number of washes, the masterswitch of the wash step*)
  resolvedNumberOfWashes = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[numberOfWashes,Except[Automatic]],
      numberOfWashes,
    (*If a method is specified and it is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodNumberOfWashes, Except[Null]],
      methodNumberOfWashes,
    (*If this step is in fractionation order, and the essential options are not specified to Null by user, set to 1*)
    MemberQ[fractionationOrder,stepFraction]&&!MemberQ[{washSolution, washSolutionVolume, washSeparationTechnique},Null],
      1,
    True,
      Null
  ];
  (*Resolve wash solution*)
  resolvedWashSolution = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washSolution,Except[Automatic]],
      washSolution,
    (*If a method is specified and it is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashSolution, Except[Null]],
      methodWashSolution,
    (*If wash is to be performed, set to sterile 1xPBS*)
    MatchQ[resolvedNumberOfWashes,GreaterEqualP[1]],
      Model[Sample, StockSolution,"id:P5ZnEjdwzZXE"],(*Model[Sample, StockSolution, "1x PBS (Phosphate Buffer Saline), Autoclaved"]*)
    True,
      Null
  ];
  (*Resolve wash solution volume*)
  resolvedWashSolutionVolume = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washSolutionVolume,Except[Automatic]],
      washSolutionVolume,
    (*If wash is to be performed, set to the lesser of 50% of experiment initial sample volume or 50% or max allowable volume*)
    MatchQ[resolvedNumberOfWashes,GreaterEqualP[1]],
      SafeRound[
        Min[experimentInitialSampleVolume, 0.5*(maxVolumeCapacity-startingVolume)],
        1 Microliter],
    (*Otherwise wash is not performed, set to Null*)
    True,
      Null
  ];
  (*Resolve wash solution temperature*)
  resolvedWashSolutionTemperature = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washSolutionTemperature,Except[Automatic]],
      washSolutionTemperature,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashSolutionTemperature, Except[Null]],
      methodWashSolutionTemperature,
    (*If wash is to be performed, set to 4 Celsius*)
    MatchQ[resolvedNumberOfWashes,GreaterEqualP[1]]&&!MatchQ[washSolutionEquilibrationTime,Null],
      4 Celsius,
    (*Otherwise wash is not performed, set to Null*)
    True,
      Null
  ];
  (*Resolve wash solution equilibration time*)
  resolvedWashSolutionEquilibrationTime = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washSolutionEquilibrationTime,Except[Automatic]],
      washSolutionEquilibrationTime,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashSolutionEquilibrationTime, Except[Null]],
      methodWashSolutionEquilibrationTime,
    (*If CollectionContainerTemperature is not Null or Ambient*)
    MatchQ[resolvedWashSolutionTemperature,Except[Null|Ambient]],
      10 Minute,
    (*Otherwise no equilibration is needed, set to Null*)
    True,
      Null
  ];
  (* Resolve the neutralization mix options.*)
  resolvedWashMixOptions = Experiment`Private`preResolveExtractMixOptions[
    userInputMapThreadOptions,
    If[useMethodQ,resolvedMethodPacket,Null],
    GreaterEqualQ[resolvedNumberOfWashes,1]&&!sampleAlreadyInFilter,(*masterswitch of the stage on and sample is not on filter*)
    {
      MixType -> washMixTypeOptionName,
      MixTemperature -> washMixTemperatureOptionName,
      MixRate -> washMixRateOptionName,
      MixTime -> washMixTimeOptionName,
      NumberOfMixes -> numberOfWashMixesOptionName,
      MixVolume -> washMixVolumeOptionName
    },
    DefaultMixType -> None,
    DefaultMixTemperature -> Ambient,
    DefaultMixRate -> 1000 RPM,
    DefaultMixTime -> 1*Minute,
    DefaultNumberOfMixes -> 10,
    DefaultMixVolume -> Min[Cases[{970 Microliter,SafeRound[0.5*resolvedWashSolutionVolume,1 Microliter]},VolumeP]]
  ];

  (*Resolve wash incubation time*)
  resolvedWashIncubationTime = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washIncubationTime,Except[Automatic]],
      washIncubationTime,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashIncubationTime, Except[Null]],
      methodWashIncubationTime,
    (*If not specified by any, but wash incubation temperature is specified by the user, set to 1 Minute*)
    MatchQ[washIncubationTemperature,Except[Null|Automatic]],
    1 Minute,
    (*Otherwise, default to Null, no wash incuation*)
    True,
      Null
  ];
  (*Resolve wash incubation temperature*)
  resolvedWashIncubationTemperature = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washIncubationTemperature,Except[Automatic]],
      washIncubationTemperature,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashIncubationTemperature, Except[Null]],
     methodWashIncubationTemperature,
    (*If incubation time is greater than 0, set to 4 celsius*)
    MatchQ[resolvedWashIncubationTime,GreaterP[0 Second]],
      4 Celsius,
    (*If not specified by any and time is null or zero, set to Null*)
    True,
      Null
  ];

  (*Resolve wash separation technique*)
  resolvedWashSeparationTechnique = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washSeparationTechnique,Except[Automatic]],
      washSeparationTechnique,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashSeparationTechnique, Except[Null]],
      methodWashSeparationTechnique,
    (*If wash is to be performed and sample is in filter, set to Filter*)
    MatchQ[resolvedNumberOfWashes,GreaterEqualP[1]]&&sampleAlreadyInFilter,
      Filter,
    MatchQ[resolvedNumberOfWashes,GreaterEqualP[1]],
      Pellet,
    True,
      Null
  ];

  (*Resolve Wash pellet instrument*)
  resolvedWashPelletInstrument = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washPelletInstrument,Except[Automatic]],
      washPelletInstrument,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashPelletInstrument, Except[Null]],
      methodWashPelletInstrument,
    (*If the wash is to be performed and wash separation technique is set to Pellet, set to the default centrifuge*)
    MatchQ[resolvedWashSeparationTechnique,Pellet],
      Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (*Model[Instrument, Centrifuge, "HiG4"]*)
    (*Otherwise set to Null*)
    True,
      Null
  ];

  (*Resolve Wash Pellet Intensity*)
  resolvedWashPelletIntensity = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washPelletIntensity,Except[Automatic]],
      washPelletIntensity,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashPelletIntensity, Except[Null]],
      methodWashPelletIntensity,
    (*If the wash is to be performed and wash separation technique is set to Pellet, set to the default intensity*)
    MatchQ[resolvedWashSeparationTechnique,Pellet],
      3600 GravitationalAcceleration,
    True,
      Null
  ];

  (*Resolve Wash Pellet Time*)
  resolvedWashPelletTime = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washPelletTime,Except[Automatic]],
      washPelletTime,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashPelletTime, Except[Null]],
      methodWashPelletTime,
    (*If the wash is to be performed and wash separation technique is set to Pellet, set to the default intensity*)
    MatchQ[resolvedWashSeparationTechnique,Pellet],
      Switch[cellType,
        MicrobialCellTypeP,45 Minute,
        Mammalian,10 Minute,
        (*Unknown or unspecified cell types*)
        _,15 Minute
      ],
    True,
      Null
  ];

  (*Resolve Wash Supernatant Volume*)
  resolvedWashSupernatantVolume = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washSupernatantVolume,Except[Automatic]],
      washSupernatantVolume,
    MatchQ[resolvedWashSeparationTechnique,Pellet],
      resolvedWashSolutionVolume,
    True,
      Null
  ];

  (*Resolve supernatant storage condition*)
  resolvedWashSupernatantStorageCondition = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washSupernatantStorageCondition,Except[Automatic]],
      washSupernatantStorageCondition,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashSupernatantStorageCondition, Except[Null]],
      methodWashSupernatantStorageCondition,
    (*If wash separation is not performed or is performed by filter, set to Null*)
    MatchQ[resolvedWashSeparationTechnique,Null|Filter],
      Null,
    True,
      Disposal
  ];

  (*Resolve wash supernatant container *)
  resolvedWashSupernatantContainer = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washSupernatantContainer,Except[Automatic]],
      washSupernatantContainer,
    (*If wash separation is not performed or is performed by filter, set to Null*)
    MatchQ[resolvedWashSeparationTechnique,Null|Filter],
      Null,
    (*This cannot be the last step*)
    (*Leave it to be resolved by ExperimentPrecipitate*)
    True,
      Automatic
  ];

  (*Resolve Wash supernatant label*)
  resolvedWashSupernatantLabel = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washSupernatantLabel,Except[Automatic]],
    washSupernatantLabel,
    (*If wash separation is not performed or is performed by filter, set to Null*)
    MatchQ[resolvedWashSeparationTechnique,Null|Filter],
    Null,
    True,
    Automatic
  ];

  (*Resolve Wash supernatant container label*)
  resolvedWashSupernatantContainerLabel = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washSupernatantContainerLabel,Except[Automatic]],
    washSupernatantContainerLabel,
    (*If wash separation is not performed or is performed by filter, set to Null*)
    MatchQ[resolvedWashSeparationTechnique,Null|Filter],
    Null,
    True,
    Automatic
  ];

  (*Resolve Wash filter technique*)
  resolvedWashFilterTechnique = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washFilterTechnique,Except[Automatic]],
    washFilterTechnique,
    (*If the FilterCentrifuge option is specified by user while wash is to be performed, set to Centrifuge*)
    MatchQ[resolvedNumberOfWashes,GreaterEqualP[1]]&&MatchQ[washFilterCentrifugeIntensity,Except[Automatic|Null]],
    Centrifuge,
    (*If the FilterCentrifuge option is specified by user to be Null while this fraction is in Fractionation Order, set to AirPressure*)
    MatchQ[resolvedNumberOfWashes,GreaterEqualP[1]]&&MatchQ[washFilterCentrifugeIntensity,Except[Automatic|Null]],
    AirPressure,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashFilterTechnique, Except[Null]],
    methodWashFilterTechnique,
    (*If the wash separation technique is Pellet or not performed, set to Null*)
    MatchQ[resolvedWashSeparationTechnique,Null|Pellet],
    Null,
    (*Otherwise set to default value*)
    True,
    AirPressure
  ];

  (*Resolve Wash filter instrument*)
  resolvedWashFilterInstrument= Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washFilterInstrument,Except[Automatic]],
    washFilterInstrument,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashFilterInstrument, Except[Null]],
    methodWashFilterInstrument,
    (*If the wash separation technique is Pellet or not performed, set to Null*)
    MatchQ[resolvedWashSeparationTechnique,Null|Pellet],
    Null,
    (*Otherwise set to default value*)
    True,
    Switch[resolvedWashFilterTechnique,
      AirPressure,Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
      Centrifuge,Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
      _,Automatic
    ]
  ];

  (*Resolve Wash filter centrifuge intensity*)
  resolvedWashFilterCentrifugeIntensity= Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washFilterCentrifugeIntensity,Except[Automatic]],
    washFilterCentrifugeIntensity,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashFilterCentrifugeIntensity, Except[Null]],
    methodWashFilterCentrifugeIntensity,
    (*If the wash separation technique is Pellet or not performed, or filter technique is air pressure, set to Null*)
    Or[
      MatchQ[resolvedWashSeparationTechnique,Null|Pellet],
      MatchQ[resolvedWashFilterTechnique,AirPressure]
    ],
    Null,
    (*Otherwise let Precipitate resolve*)
    True,
    Automatic

  ];

  (*Resolve wash filter pressure*)
  resolvedWashFilterPressure= Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washFilterPressure,Except[Automatic]],
    washFilterPressure,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashFilterPressure, Except[Null]],
    methodWashFilterPressure,
    (*If the wash separation technique is Pellet or not performed, or filter technique is air pressure, set to Null*)
    Or[
      MatchQ[resolvedWashSeparationTechnique,Null|Pellet],
      MatchQ[resolvedWashFilterTechnique,Centrifuge]
    ],
    Null,
    (*Otherwise let Precipitate resolve*)
    True,
    Automatic
  ];

  (*Resolve wash filter Time*)
  resolvedWashFilterTime= Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washFilterTime,Except[Automatic]],
    washFilterTime,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashFilterTime, Except[Null]],
    methodWashFilterTime,
    (*If the wash separation technique is Pellet or not performed,  set to Null*)
    MatchQ[resolvedWashSeparationTechnique,Null|Pellet],
    Null,
    (*Otherwise set to 1 Minute*)
    True,
    1 Minute
  ];

  (*Resolve wash filtrate storage condition*)
  resolvedWashFiltrateStorageCondition = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washFiltrateStorageCondition,Except[Automatic]],
      washFiltrateStorageCondition,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashFiltrateStorageCondition, Except[Null]],
      methodWashFiltrateStorageCondition,
    (*If the wash separation technique is Pellet or not performed,  set to Null*)
    MatchQ[resolvedWashSeparationTechnique,Null|Pellet],
      Null,
    True,
      Disposal
  ];

  (*Resolve wash filtrate container *)
  resolvedWashFiltrateContainer = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washFiltrateContainer,Except[Automatic]],
      washFiltrateContainer,
    (*If the wash separation technique is Pellet or not performed,  set to Null*)
    MatchQ[resolvedWashSeparationTechnique,Null|Pellet],
      Null,
    (*Leave it to be resolved by ExperimentPrecipitate*)
    True,
      Automatic
  ];

  (*Resolve wash filtrate label*)
  resolvedWashFiltrateLabel = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washFiltrateLabel,Except[Automatic]],
      washFiltrateLabel,
    (*If the wash separation technique is Pellet or not performed,  set to Null*)
    MatchQ[resolvedWashSeparationTechnique,Null|Pellet],
      Null,
    True,
      Automatic
  ];

  (*Resolve wash filtrate container label*)
  resolvedWashFiltrateContainerLabel = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washFiltrateContainerLabel,Except[Automatic]],
      washFiltrateContainerLabel,
    (*If the wash separation technique is Pellet or not performed,  set to Null*)
    MatchQ[resolvedWashSeparationTechnique,Null|Pellet],
      Null,
    True,
      Automatic
  ];

  (*Resolve wash collection container temperature*)
  resolvedWashCollectionContainerTemperature = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washCollectionContainerTemperature,Except[Automatic]],
      washCollectionContainerTemperature,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashCollectionContainerTemperature, Except[Null]],
      methodWashCollectionContainerTemperature,
    (*If the wash collected sample storage condition is , set to 4 Celsius*)
    Or[MemberQ[{resolvedWashFiltrateStorageCondition,resolvedWashSupernatantStorageCondition},Except[Null|Disposal]],
      !MatchQ[washCollectionContainerEquilibrationTime,Automatic|Null]],
      4 Celsius,
    (*Otherwise set to Null*)
    True,
      Null
  ];

  (*Resolve collection container equilibration time*)
  resolvedWashCollectionContainerEquilibrationTime = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[washCollectionContainerEquilibrationTime,Except[Automatic]],
      washCollectionContainerEquilibrationTime,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodWashCollectionContainerEquilibrationTime, Except[Null]],
      methodWashCollectionContainerEquilibrationTime,
    (*If CollectionContainerTemperature is not Null or Ambient*)
    MatchQ[resolvedWashCollectionContainerTemperature,Except[Null|Ambient]],
      10 Minute,
    (*Otherwise no equilibration is needed, set to Null*)
    True,
      Null
  ];

  (*Update the working sample volume after the optional wash step*)
  workingVolume = Which[
    (*If Wash Separation technique is Pellet *)
    MatchQ[resolvedWashSeparationTechnique,Pellet]&&MatchQ[{resolvedWashSolutionVolume,resolvedWashSupernatantVolume},ListableP[VolumeP]],
      startingVolume + resolvedNumberOfWashes*(resolvedWashSolutionVolume-resolvedWashSupernatantVolume),
    (*If Wash Separation technique is Filter, assume all fluids are flushed through *)
    MatchQ[resolvedWashSeparationTechnique,Filter],
      0 Microliter,
    True,
      startingVolume
  ];

  (*---FractionIncubation: MembraneSolubilization or NuclearLysis---*)

  (*Resolve fraction incubation solution, controlled by fractionation order the masterswitch*)
  resolvedFractionIncubationSolution = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[fractionIncubationSolution,Except[Automatic]],
      fractionIncubationSolution,
    (*If a method is specified and it is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodFractionIncubationSolution, Except[Null]],
      methodFractionIncubationSolution,
    (*If this step is in fractionation order, set to RIPA *)
    MemberQ[fractionationOrder,stepFraction],
      Model[Sample,"id:P5ZnEjdm8DYn"],(*Model[Sample, "RIPA Lysis and Extraction Buffer"]*)
    (*Otherwise this fraction is needed, set to Null*)
    True,
      Null
  ];
  (*Resolve Fraction Incubation solution volume*)
  resolvedFractionIncubationSolutionVolume = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[fractionIncubationSolutionVolume,Except[Automatic]],
      fractionIncubationSolutionVolume,
    (*If this step is in fractionation order, set to the lesser of 25% of experiment initial sample volume or max allowable volume*)
    MemberQ[fractionationOrder,stepFraction],
      SafeRound[
        0.25*Min[experimentInitialSampleVolume, (maxVolumeCapacity-workingVolume)],
        1 Microliter],
    (*Otherwise wash is not performed, set to Null*)
    True,
      Null
  ];
  (*Resolve Fraction Incubation solution temperature*)
  resolvedFractionIncubationSolutionTemperature = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[fractionIncubationSolutionTemperature,Except[Automatic]],
      fractionIncubationSolutionTemperature,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodFractionIncubationSolutionTemperature, Except[Null]],
      methodFractionIncubationSolutionTemperature,
    (*If this step is in fractionation order, set to 4 Celsius*)
    MemberQ[fractionationOrder,stepFraction]&&!MatchQ[fractionIncubationSolutionEquilibrationTime,Null],
      4 Celsius,
    (*Otherwise fraction incubation is not performed, set to Null*)
    True,
      Null
  ];
  (*Resolve Fraction Incubation equilibration time*)
  resolvedFractionIncubationSolutionEquilibrationTime = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[fractionIncubationSolutionEquilibrationTime,Except[Automatic]],
      fractionIncubationSolutionEquilibrationTime,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodFractionIncubationSolutionEquilibrationTime, Except[Null]],
      methodFractionIncubationSolutionEquilibrationTime,
    (*If CollectionContainerTemperature is not Null or Ambient*)
    MatchQ[resolvedFractionIncubationSolutionTemperature,Except[Null|Ambient]],
      10 Minute,
    (*Otherwise no equilibration is needed, set to Null*)
    True,
      Null
  ];

  (* Resolve the fraction incubation mix options.*)
  resolvedFractionIncubationMixOptions = Experiment`Private`preResolveExtractMixOptions[
    userInputMapThreadOptions,
    If[useMethodQ,resolvedMethodPacket,Null],
    MemberQ[fractionationOrder,stepFraction]&&!sampleAlreadyInFilter,(*masterswitch of the stage on and sample is not on filter*)
    {
      MixType -> fractionIncubationMixTypeOptionName,
      MixTemperature -> fractionIncubationMixTemperatureOptionName,
      MixRate -> fractionIncubationMixRateOptionName,
      MixTime -> fractionIncubationMixTimeOptionName,
      NumberOfMixes -> numberOfFractionIncubationMixesOptionName,
      MixVolume -> fractionIncubationMixVolumeOptionName
    },
    DefaultMixType -> Shake,
    DefaultMixTemperature -> Ambient,
    DefaultMixRate -> 1000 RPM,
    DefaultMixTime -> 1*Minute,
    DefaultNumberOfMixes -> 10,
    DefaultMixVolume -> Min[Cases[{970 Microliter,SafeRound[0.5*resolvedFractionIncubationSolutionVolume,1 Microliter]},VolumeP]]
  ];

  (*Resolve Fraction incubation time*)
  resolvedFractionIncubationTime = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[fractionIncubationTime,Except[Automatic]],
      fractionIncubationTime,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodFractionIncubationTime, Except[Null]],
      methodFractionIncubationTime,
    (*If this step is in fractionation order, set to 4 Celsius*)
    MemberQ[fractionationOrder,stepFraction],
      10 Minute,
    (*Otherwise fraction incubation is not performed, set to Null*)
    True,
      Null
  ];
  (*Resolve Fraction incubation temperature*)
  resolvedFractionIncubationTemperature = Which[
    (*If specified by the user, set to user-specified value*)
    MatchQ[fractionIncubationTemperature,Except[Automatic]],
      fractionIncubationTemperature,
    (*If a method is specified and It is specified by the method, set to method-specified value*)
    useMethodQ && MatchQ[methodFractionIncubationTemperature, Except[Null]],
      methodFractionIncubationTemperature,
    (*If incubation time is greater than 0, set to 4 celsius*)
    MatchQ[resolvedFractionIncubationTime,GreaterP[0 Second]],
      4 Celsius,
    (*If not specified by any and time is null or zero, set to Null*)
    True,
      Null
  ];

  (*Update the working sample volume after the fraction incubation step*)
  workingVolume = If[MatchQ[resolvedFractionIncubationSolutionVolume,VolumeP],
    (*If this step is in fractionation order, add the fractionIncubationSolutionVolume to the working volume*)
    workingVolume+resolvedFractionIncubationSolutionVolume,
    (*Otherwise no volume is changed*)
    workingVolume
  ];

  (*Compile resolved non-mix wash options rules*)
  resolvedWashOptions = {
    numberOfWashesOptionName -> resolvedNumberOfWashes,
    washSolutionOptionName -> resolvedWashSolution,
    washSolutionVolumeOptionName -> resolvedWashSolutionVolume,
    washSolutionTemperatureOptionName -> resolvedWashSolutionTemperature,
    washSolutionEquilibrationTimeOptionName -> resolvedWashSolutionEquilibrationTime,
    washIncubationTimeOptionName -> resolvedWashIncubationTime,
    washIncubationTemperatureOptionName -> resolvedWashIncubationTemperature,
    washSeparationTechniqueOptionName -> resolvedWashSeparationTechnique,
    washPelletInstrumentOptionName -> resolvedWashPelletInstrument,
    washPelletIntensityOptionName -> resolvedWashPelletIntensity,
    washPelletTimeOptionName -> resolvedWashPelletTime,
    washSupernatantVolumeOptionName -> resolvedWashSupernatantVolume,
    washSupernatantContainerOptionName -> resolvedWashSupernatantContainer,
    washSupernatantLabelOptionName -> resolvedWashSupernatantLabel,
    washSupernatantContainerLabelOptionName -> resolvedWashSupernatantContainerLabel,
    washSupernatantStorageConditionOptionName -> resolvedWashSupernatantStorageCondition,
    washFilterTechniqueOptionName -> resolvedWashFilterTechnique,
    washFilterInstrumentOptionName -> resolvedWashFilterInstrument,
    washFilterCentrifugeIntensityOptionName -> resolvedWashFilterCentrifugeIntensity,
    washFilterPressureOptionName -> resolvedWashFilterPressure,
    washFilterTimeOptionName -> resolvedWashFilterTime,
    washFiltrateStorageConditionOptionName -> resolvedWashFiltrateStorageCondition,
    washFiltrateContainerOptionName -> resolvedWashFiltrateContainer,
    washFiltrateLabelOptionName -> resolvedWashFiltrateLabel,
    washFiltrateContainerLabelOptionName -> resolvedWashFiltrateContainerLabel,
    washCollectionContainerTemperatureOptionName -> resolvedWashCollectionContainerTemperature,
    washCollectionContainerEquilibrationTimeOptionName -> resolvedWashCollectionContainerEquilibrationTime
  };

  (*Compile resolved non-mix fraction incubation options rules*)
  resolvedFractionIncubationOptions ={
    fractionIncubationSolutionOptionName -> resolvedFractionIncubationSolution,
    fractionIncubationSolutionVolumeOptionName -> resolvedFractionIncubationSolutionVolume,
    fractionIncubationSolutionTemperatureOptionName -> resolvedFractionIncubationSolutionTemperature,
    fractionIncubationSolutionEquilibrationTimeOptionName -> resolvedFractionIncubationSolutionEquilibrationTime,
    fractionIncubationTimeOptionName -> resolvedFractionIncubationTime,
    fractionIncubationTemperatureOptionName -> resolvedFractionIncubationTemperature
  };
  (*Return resolved options and volume-tracking variables*)
  {
    Join[resolvedWashOptions,resolvedFractionIncubationOptions,
      Map[
        (# -> Lookup[resolvedWashMixOptions,#])&,
        {
          washMixTypeOptionName,
          washMixTemperatureOptionName,
          washMixRateOptionName,
          washMixTimeOptionName,
          numberOfWashMixesOptionName,
          washMixVolumeOptionName
        }],
      Map[
        (# -> Lookup[resolvedFractionIncubationMixOptions,#])&,
        {
          fractionIncubationMixTypeOptionName,
          fractionIncubationMixTemperatureOptionName,
          fractionIncubationMixRateOptionName,
          fractionIncubationMixTimeOptionName,
          numberOfFractionIncubationMixesOptionName,
          fractionIncubationMixVolumeOptionName
        }]
      ],
      workingVolume
  }
];


(* ::Subsection::Closed:: *)
(*resolveExperimentExtractSubcellularProteinOptions*)
resolveExperimentExtractSubcellularProteinOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentExtractSubcellularProteinOptions]]:=Module[
  {
    (*Option Setup and Cache Setup*)
    outputSpecification, output, gatherTests, messages, cache, listedOptions, currentSimulation, optionPrecisions, roundedExperimentOptions,preResolvedRoundedExperimentOptions,preResolvedPreCorrectionMapThreadFriendlyOptions,preResolvedMapThreadFriendlyOptions,

    (*Precision Tests*)
    optionPrecisionTests, mapThreadFriendlyOptions,

    (*Downloads*)
    sampleFields, samplePacketFields, samplePackets, sampleModelFields, sampleModelPacketFields, sampleModelPackets, methodPacketFields, methodPackets, allMethods,allMethodPackets,containerObjectFields, sampleContainerPackets, containerObjectPacketFields, sampleContainerModelPackets, containerModelFields, containerModelPackets, containerModelPacketFields, containerModelFromObjectPackets, cacheBall, fastCacheBall,

    (*Input Validation*)
    discardedInvalidInputs, discardedTest, deprecatedSamplePackets, deprecatedInvalidInputs, deprecatedTest, solidMediaInvalidInputs, solidMediaTest, invalidInputs,

    (*General*)
    resolvedRoboticInstrument,allowedWorkCells,resolvedWorkCell,resolvedMethods,resolvedMethodPackets,resolvedTargetProteins, resolvedTargetSubcellularFractions, resolvedFractionationOrders,resolvedLysisAndGeneralOptions,

    (*Lysing*)
    (*Options that were pre-resolved*)
    resolvedLyses,preResolvedCellTypes, preResolvedLysisTimes, preResolvedLysisTemperatures, preResolvedLysisAliquots, preResolvedClarifyLysates, resolvedNumberOfLysisStepss,preResolvedLysisAliquotContainers, preResolvedLysisAliquotContainerLabels,preResolvedClarifiedLysateContainers, preResolvedClarifiedLysateContainerLabels,
    resolvedLysisSolutionTemperatures, resolvedLysisSolutionEquilibrationTimes,
    resolvedSecondaryLysisSolutionTemperatures, resolvedSecondaryLysisSolutionEquilibrationTimes,
    resolvedTertiaryLysisSolutionTemperatures, resolvedTertiaryLysisSolutionEquilibrationTimes,
    myOptionsWithPreResolvedLysis,mapThreadOptionsWithPreResolvedLysis,mapThreadFriendlyOptionsWithPreResolvedLysis,resolvedLysisOptions,myOptionsWithGeneralAndLysisResolved,mapThreadFriendlyOptionsWithGeneralAndLysisResolved,
    resolvedLysisSimulation, resolvedLysisTests,preResolvedLysisOptions,
    (*Fractionation Options*)
    preResolvedFractionationAndPurificationOptionRules,

    (*Purification Options*)
    resolvedPurifications, preResolvedSolidPhaseExtractionSeparationModes,preResolvedSolidPhaseExtractionSorbents,preResolvedSolidPhaseExtractionCartridges,preResolvedSolidPhaseExtractionStrategies, preResolvedSolidPhaseExtractionWashSolutions, preResolvedSecondarySolidPhaseExtractionWashSolutions, preResolvedTertiarySolidPhaseExtractionWashSolutions,preResolvedSolidPhaseExtractionElutionSolutions,
    preResolvedPrecipitationSeparationTechniques, preResolvedPrecipitationTargetPhases, preResolvedPrecipitationReagents, preResolvedPrecipitationFilters,preResolvedPrecipitationMembraneMaterials, preResolvedPrecipitationPoreSizes,preResolvedPrecipitationNumberOfWashess, preResolvedPrecipitationWashSolutions, preResolvedPrecipitationResuspensionBuffers,workingSamples, containerOutBeforePurification, optionsWithResolvedFractionationAndPurification,preCorrectionMapThreadFriendlyoptionsWithResolvedFractionationAndPurification,mapThreadFriendlyoptionsWithResolvedFractionationAndPurification,preResolvedPurificationOptions,

    (*Container Out*)
    userSpecifiedLabels,preResolvedCytosolicProteinContainersOutWithWellsRemoved,preResolvedMembraneProteinContainersOutWithWellsRemoved, preResolvedNuclearProteinContainersOutWithWellsRemoved,
    preResolvedExtractedCytosolicProteinContainerLabel,preResolvedExtractedMembraneProteinContainerLabel,preResolvedExtractedNuclearProteinContainerLabel,preResolvedCytosolicProteinContainerOutWell, preResolvedMembraneProteinContainerOutWell, preResolvedNuclearProteinContainerOutWell,preResolvedIndexedCytosolicProteinContainerOut,preResolvedIndexedMembraneProteinContainerOut,preResolvedIndexedNuclearProteinContainerOut,resolvedExtractedCytosolicProteinLabel,resolvedExtractedMembraneProteinLabel,resolvedExtractedNuclearProteinLabel,

    (*Post-resolution*)
    resolvedPostProcessingOptions,  resolvedOptions,

    (*---Conflicting Options Tests---*)
    mapThreadFriendlyResolvedOptions,
    methodTargetFractionMismatchedOptions,methodTargetConflictingOptionsTest,
    (*Lysis*)
    repeatedLysisOptions, repeatedLysisOptionsTest,
    unlysedCellsOptions,unlysedCellsOptionsTest,
    conflictingLysisStepSolutionEquilibrationOptions,conflictingLysisStepSolutionEquilibrationOptionsTest,
    lysisSolutionEquilibrationTimeTemperatureMismatchOptions,lysisSolutionEquilibrationTimeTemperatureMismatchOptionsTest,
    (*Fractionation*)
    invalidTargetSubcellularFractionSamples, validTargetSubcellularFractionTest,
    incompleteFractionationOrderOptions,completeFractionationOrderTest,
    invalidFractionationTechniqueOrderOptions,validFractionationTechniqueOrderTest,

    (*Purification*)
    nullTargetProteinSamples,nullTargetProteinTest

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
  (* Search for all ExtractSubcellularProtein methods *)
  allMethods = Search[Object[Method,Extraction,SubcellularProtein]];
  (* Download fields from samples that are required.*)
  (* NOTE: All fields downloaded below should already be included in the cache passed down to us by the main function. *)
  sampleFields = DeleteDuplicates[Flatten[{Name, Status, Model, Composition, CellType, Living, CultureAdhesion, Volume, Analytes, Density, Container, Position, SamplePreparationCacheFields[Object[Sample]]}]];
  samplePacketFields = Packet@@sampleFields;
  sampleModelFields = DeleteDuplicates[Flatten[{Name, Composition, Density, Deprecated}]];
  sampleModelPacketFields = Packet@@sampleModelFields;
  methodPacketFields = Packet[All];
  containerObjectFields = {Contents, Model, Name, MaxVolume};
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
      (*4*)Cases[allMethods,ObjectP[Object[Method,Extraction,SubcellularProtein]]],
      (*5*)mySamples,
      (*6*)mySamples,
      (*7*)DeleteDuplicates@Flatten[{Cases[Flatten[{Lookup[myOptions,
      (*All the lysis containers specified need to be downloaded here because we are calling the LyseCells resolver and may need the MaxVolume info for Fractionation options resolver*)
      {ExtractedCytosolicProteinContainer, ExtractedMembraneProteinContainer,ExtractedNuclearProteinContainer,
        LysisAliquotContainer,ClarifiedLysateContainer,
        FractionationFilter,CytosolicFractionationSupernatantContainer,CytosolicFractionationFiltrateContainer,MembraneFractionationSupernatantContainer,MembraneFractionationFiltrateContainer,NuclearFractionationSupernatantContainer,NuclearFractionationFiltrateContainer}],
      (*Add the preferred container models here in case samples running through LyseCells and are placed in new containers, then we need the max volume of that container*)
      PreferredContainer[All, LiquidHandlerCompatible -> True, Sterile -> True, Type -> All],
      (*Default filter*)
      Model[Container, Plate, Filter, "id:xRO9n3O0B9E5"]}], ObjectP[Model[Container]]]}],
      (*8*)DeleteDuplicates@Flatten[{Cases[Flatten[Lookup[myOptions, {
        (*All the lysis containers specified need to be downloaded here because we are calling the LyseCells resolver and may need the MaxVolume info for Fractionation options resolver*)
      ExtractedCytosolicProteinContainer, ExtractedMembraneProteinContainer,ExtractedNuclearProteinContainer,
      LysisAliquotContainer,ClarifiedLysateContainer,
      FractionationFilter,CytosolicFractionationSupernatantContainer,CytosolicFractionationFiltrateContainer,MembraneFractionationSupernatantContainer,MembraneFractionationFiltrateContainer,NuclearFractionationSupernatantContainer,NuclearFractionationFiltrateContainer}]], ObjectP[Object[Container]]]}]
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

  (* Make fast association to look up things from cache quickly; also include the simulation.*)
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
    (*ExtractSubcellularProtein option precisions*)
    {
      {LysisSolutionTemperature,  10^-1 Celsius},
      {LysisSolutionEquilibrationTime, 1 Second},
      {SecondaryLysisSolutionTemperature,  10^-1 Celsius},
      {SecondaryLysisSolutionEquilibrationTime, 1 Second},
      {TertiaryLysisSolutionTemperature,  10^-1 Celsius},
      {TertiaryLysisSolutionEquilibrationTime, 1 Second},
      {CytosolicFractionationPelletTime, 1 Second},
      {CytosolicFractionationSupernatantVolume, 10^-1 Microliter},
      {CytosolicFractionationFilterPressure, 1 PSI},
      {CytosolicFractionationFilterTime, 1 Second},
      {CytosolicFractionationCollectionContainerTemperature,  10^-1 Celsius},
      {CytosolicFractionationCollectionContainerEquilibrationTime, 1 Second},
      {MembraneWashSolutionVolume, 10^-1 Microliter},
      {MembraneWashSolutionTemperature,  10^-1 Celsius},
      {MembraneWashSolutionEquilibrationTime, 1 Second},
      {MembraneWashMixRate, 1 RPM},
      {MembraneWashMixTime, 1 Second},
      {MembraneWashMixVolume, 10^-1 Microliter},
      {MembraneWashMixTemperature,  10^-1 Celsius},
      {MembraneWashIncubationTime, 1 Second},
      {MembraneWashIncubationTemperature,  10^-1 Celsius},
      {MembraneWashPelletTime, 1 Second},
      {MembraneWashSupernatantVolume, 10^-1 Microliter},
      {MembraneWashFilterPressure, 1 PSI},
      {MembraneWashFilterTime, 1 Second},
      {MembraneWashCollectionContainerTemperature,  10^-1 Celsius},
      {MembraneWashCollectionContainerEquilibrationTime, 1 Second},
      {MembraneSolubilizationSolutionVolume, 10^-1 Microliter},
      {MembraneSolubilizationSolutionTemperature,  10^-1 Celsius},
      {MembraneSolubilizationSolutionEquilibrationTime, 1 Second},
      {MembraneSolubilizationMixRate, 1 RPM},
      {MembraneSolubilizationMixTime, 1 Second},
      {MembraneSolubilizationMixVolume, 10^-1 Microliter},
      {MembraneSolubilizationMixTemperature,  10^-1 Celsius},
      {MembraneSolubilizationTime, 1 Second},
      {MembraneSolubilizationTemperature,  10^-1 Celsius},
      {MembraneFractionationPelletTime, 1 Second},
      {MembraneFractionationSupernatantVolume, 10^-1 Microliter},
      {MembraneFractionationFilterPressure, 1 PSI},
      {MembraneFractionationFilterTime, 1 Second},
      {MembraneFractionationCollectionContainerTemperature,  10^-1 Celsius},
      {MembraneFractionationCollectionContainerEquilibrationTime, 1 Second},
      {NuclearWashSolutionVolume, 10^-1 Microliter},
      {NuclearWashSolutionTemperature,  10^-1 Celsius},
      {NuclearWashSolutionEquilibrationTime, 1 Second},
      {NuclearWashMixRate, 1 RPM},
      {NuclearWashMixTime, 1 Second},
      {NuclearWashMixVolume, 10^-1 Microliter},
      {NuclearWashMixTemperature,  10^-1 Celsius},
      {NuclearWashIncubationTime, 1 Second},
      {NuclearWashIncubationTemperature, 10^-1 Celsius},
      {NuclearWashPelletTime, 1 Second},
      {NuclearWashSupernatantVolume, 10^-1 Microliter},
      {NuclearWashFilterPressure, 1 PSI},
      {NuclearWashFilterTime, 1 Second},
      {NuclearWashCollectionContainerTemperature,  10^-1 Celsius},
      {NuclearWashCollectionContainerEquilibrationTime, 1 Second},
      {NuclearLysisSolutionVolume, 10^-1 Microliter},
      {NuclearLysisSolutionTemperature,  10^-1 Celsius},
      {NuclearLysisSolutionEquilibrationTime, 1 Second},
      {NuclearLysisMixRate, 1 RPM},
      {NuclearLysisMixTime, 1 Second},
      {NuclearLysisMixVolume, 10^-1 Microliter},
      {NuclearLysisMixTemperature,  10^-1 Celsius},
      {NuclearLysisTime, 1 Second},
      {NuclearLysisTemperature,  10^-1 Celsius},
      {NuclearFractionationPelletTime, 1 Second},
      {NuclearFractionationSupernatantVolume, 10^-1 Microliter},
      {NuclearFractionationFilterPressure, 1 PSI},
      {NuclearFractionationFilterTime, 1 Second},
      {NuclearFractionationCollectionContainerTemperature,  10^-1 Celsius},
      {NuclearFractionationCollectionContainerEquilibrationTime, 1 Second}
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
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractSubcellularProtein,roundedExperimentOptions];

  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  mapThreadFriendlyOptions = Experiment`Private`mapThreadFriendlySolventAdditions[roundedExperimentOptions, mapThreadFriendlyOptions, LiquidLiquidExtractionSolventAdditions];

  (* -- RESOLVE NON-MAPTHREAD, NON-CONTAINER OPTIONS -- *)
  allowedWorkCells = resolveExtractSubcellularProteinWorkCell[mySamples, listedOptions];

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
        ExtractedCytosolicProteinLabel, ExtractedCytosolicProteinContainerLabel,
        ExtractedMembraneProteinLabel, ExtractedMembraneProteinContainerLabel,
        ExtractedNuclearProteinLabel, ExtractedNuclearProteinContainerLabel,
        LysisAliquotContainerLabel,PreLysisSupernatantLabel, PreLysisSupernatantContainerLabel,PostClarificationPelletLabel,ClarifiedLysateContainerLabel,
        ImpurityLayerLabel,ImpurityLayerContainerLabel,PrecipitatedSampleLabel,PrecipitatedSampleLabel,UnprecipitatedSampleLabel, UnprecipitatedSampleContainerLabel,
        MagneticBeadSeparationAnalyteAffinityLabel,MagneticBeadAffinityLabel,MagneticBeadSeparationPreWashCollectionContainerLabel, MagneticBeadSeparationEquilibrationCollectionContainerLabel,
        MagneticBeadSeparationLoadingCollectionContainerLabel, MagneticBeadSeparationWashCollectionContainerLabel, MagneticBeadSeparationSecondaryWashCollectionContainerLabel, MagneticBeadSeparationTertiaryWashCollectionContainerLabel, MagneticBeadSeparationQuaternaryWashCollectionContainerLabel, MagneticBeadSeparationQuinaryWashCollectionContainerLabel, MagneticBeadSeparationSenaryWashCollectionContainerLabel, MagneticBeadSeparationSeptenaryWashCollectionContainerLabel, MagneticBeadSeparationElutionCollectionContainerLabel
      }
    ],
    _String
  ];

  (* Resolve the output label and container output label. *)
  resolvedExtractedCytosolicProteinLabel=resolveExtractedProteinSampleLabel[mySamples, mapThreadFriendlyOptions, ExtractedCytosolicProteinLabel, "extracted cytosolic protein sample",userSpecifiedLabels,currentSimulation];
  resolvedExtractedMembraneProteinLabel=resolveExtractedProteinSampleLabel[mySamples, mapThreadFriendlyOptions, ExtractedMembraneProteinLabel, "extracted membrane protein sample",userSpecifiedLabels,currentSimulation];
  resolvedExtractedNuclearProteinLabel=resolveExtractedProteinSampleLabel[mySamples, mapThreadFriendlyOptions, ExtractedNuclearProteinLabel, "extracted nuclear protein sample",userSpecifiedLabels,currentSimulation];

  (* Remove any wells from user-specified container out inputs according to their widget patterns. *)
  preResolvedCytosolicProteinContainersOutWithWellsRemoved = preResolveContainersOutAndRemoveWellsForProteinExperiments[roundedExperimentOptions,ExtractedCytosolicProteinContainer];
  preResolvedMembraneProteinContainersOutWithWellsRemoved = preResolveContainersOutAndRemoveWellsForProteinExperiments[roundedExperimentOptions,ExtractedMembraneProteinContainer];
  preResolvedNuclearProteinContainersOutWithWellsRemoved = preResolveContainersOutAndRemoveWellsForProteinExperiments[roundedExperimentOptions,ExtractedNuclearProteinContainer];

  (* Resolve the container labels based on the information that we have prior to simulation. *)
  preResolvedExtractedCytosolicProteinContainerLabel = preResolveProteinContainerLabel[preResolvedCytosolicProteinContainersOutWithWellsRemoved,roundedExperimentOptions,Lookup[listedOptions, ExtractedCytosolicProteinContainerLabel],ExtractedCytosolicProteinContainerLabel,"extracted cytosolic protein sample container",userSpecifiedLabels,currentSimulation];
  preResolvedExtractedMembraneProteinContainerLabel = preResolveProteinContainerLabel[preResolvedMembraneProteinContainersOutWithWellsRemoved,roundedExperimentOptions,Lookup[listedOptions, ExtractedMembraneProteinContainerLabel],ExtractedMembraneProteinContainerLabel,"extracted membrane protein sample container",userSpecifiedLabels,currentSimulation];
  preResolvedExtractedNuclearProteinContainerLabel = preResolveProteinContainerLabel[preResolvedNuclearProteinContainersOutWithWellsRemoved,roundedExperimentOptions,Lookup[listedOptions, ExtractedNuclearProteinContainerLabel],ExtractedNuclearProteinContainerLabel,"extracted nuclear protein sample container",userSpecifiedLabels,currentSimulation];

  (* Pre-resolve the ContainerOutWell and the indexed version of the container out (without a well). *)
  (* Needed for threading user-specified ContainerOut into unit operations for simulation/protocol.  *)
  {preResolvedCytosolicProteinContainerOutWell, preResolvedIndexedCytosolicProteinContainerOut} = preResolveContainerOutWellAndIndexedContainer[preResolvedCytosolicProteinContainersOutWithWellsRemoved,roundedExperimentOptions,ExtractedCytosolicProteinContainer, fastCacheBall];
  {preResolvedMembraneProteinContainerOutWell, preResolvedIndexedMembraneProteinContainerOut} = preResolveContainerOutWellAndIndexedContainer[preResolvedMembraneProteinContainersOutWithWellsRemoved,roundedExperimentOptions,ExtractedMembraneProteinContainer, fastCacheBall];
  {preResolvedNuclearProteinContainerOutWell, preResolvedIndexedNuclearProteinContainerOut} = preResolveContainerOutWellAndIndexedContainer[preResolvedNuclearProteinContainersOutWithWellsRemoved,roundedExperimentOptions,ExtractedNuclearProteinContainer, fastCacheBall];

  (* Add in pre-resolved labels into options and make mapThreadFriendly for further resolutions. *)
  preResolvedRoundedExperimentOptions = Merge[
    {
      roundedExperimentOptions,
      <|
        ExtractedCytosolicProteinLabel -> resolvedExtractedCytosolicProteinLabel,
        ExtractedCytosolicProteinContainerLabel -> preResolvedExtractedCytosolicProteinContainerLabel,
        ExtractedMembraneProteinLabel -> resolvedExtractedMembraneProteinLabel,
        ExtractedMembraneProteinContainerLabel -> preResolvedExtractedMembraneProteinContainerLabel,
        ExtractedNuclearProteinLabel -> resolvedExtractedNuclearProteinLabel,
        ExtractedNuclearProteinContainerLabel -> preResolvedExtractedNuclearProteinContainerLabel
      |>
    },
    Last
  ];

  (* Convert our options into a MapThread friendly version. *)
  preResolvedPreCorrectionMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractSubcellularProtein,preResolvedRoundedExperimentOptions];

  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  preResolvedMapThreadFriendlyOptions = Experiment`Private`mapThreadFriendlySolventAdditions[preResolvedRoundedExperimentOptions, preResolvedPreCorrectionMapThreadFriendlyOptions, LiquidLiquidExtractionSolventAdditions];

  (* -- RESOLVE MAPTHREAD OPTIONS 1: General options, masterswitches, PreResolved lysis options-- *)
  {
    (*1*)resolvedTargetProteins,
    (*2*)resolvedLyses,
    (*3*)preResolvedCellTypes,
    (*4*)resolvedTargetSubcellularFractions,
    (*5*)resolvedFractionationOrders,
    (*6*)resolvedMethods,
    (*7*)resolvedPurifications,

    (*8*)preResolvedLysisTimes,
    (*9*)preResolvedLysisTemperatures,
    (*10*)preResolvedLysisAliquots,
    (*11*)preResolvedClarifyLysates,
    (*12*)preResolvedLysisAliquotContainers,
    (*13*)preResolvedLysisAliquotContainerLabels,
    (*14*)preResolvedClarifiedLysateContainers,
    (*15*)preResolvedClarifiedLysateContainerLabels,
    (*16*)resolvedNumberOfLysisStepss,
    (*17*)resolvedLysisSolutionTemperatures,
    (*18*)resolvedLysisSolutionEquilibrationTimes,
    (*19*)resolvedSecondaryLysisSolutionTemperatures,
    (*20*)resolvedSecondaryLysisSolutionEquilibrationTimes,
    (*21*)resolvedTertiaryLysisSolutionTemperatures,
    (*22*)resolvedTertiaryLysisSolutionEquilibrationTimes
  } = Transpose@MapThread[
    Function[{samplePacket, methodPacket, myMapThreadOptions},
      Module[
        {
          (*General*)
          targetProtein,userMethodTargetProtein,resolvedTargetProtein,
          targetSubcellularFraction,userMethodTargetSubcellularFraction,resolvedTargetSubcellularFraction,
          method,resolvedMethod,
          methodSpecifiedQ, assignedMethodPacket, useMapThreadMethodQ, useAssignedMethodQ,
          (*Lyse*)
          lyse,userMethodLyse,resolvedLyse,preResolvedLysisOptionRules,
          cellType,userMethodCellType,preResolvedCellType,
          (*Multiple lysis steps solution temperature options*)
          lysisSolutionTemperature,lysisSolutionEquilibrationTime,
          secondaryLysisSolutionTemperature,secondaryLysisSolutionEquilibrationTime,
          tertiaryLysisSolutionTemperature,tertiaryLysisSolutionEquilibrationTime,
          (*Fractionation*)
          fractionationOrder,userMethodFractionationOrder,assignedMethodFractionationOrder, resolvedFractionationOrder,
          (*Purification*)
          purification,userMethodPurification,assignedMethodPurification,resolvedPurification,preresolvedPurification
        },

        (*Look up the option values*)
        {
          (*General*)
          targetProtein,targetSubcellularFraction,method,
          (*Lysis general*)
          lyse,cellType,lysisSolutionTemperature,lysisSolutionEquilibrationTime,
          secondaryLysisSolutionTemperature,secondaryLysisSolutionEquilibrationTime,
          tertiaryLysisSolutionTemperature,tertiaryLysisSolutionEquilibrationTime,
          (*Fractionation*)
          fractionationOrder,
          (*Purification*)
          purification
        }=Lookup[myMapThreadOptions,
          {
            (*General*)
            TargetProtein,TargetSubcellularFraction, Method,
            (*Lysis*)
            Lyse, CellType,LysisSolutionTemperature,LysisSolutionEquilibrationTime,
            SecondaryLysisSolutionTemperature,SecondaryLysisSolutionEquilibrationTime,
            TertiaryLysisSolutionTemperature,TertiaryLysisSolutionEquilibrationTime,
            (*Fractionation*)
            FractionationOrder,
            (*Purification*)
            Purification
          }
        ];

        (*Look up the user-specified method option values, these are used prior to resolving Method.*)
        {userMethodTargetProtein,userMethodTargetSubcellularFraction,userMethodLyse,userMethodCellType, userMethodFractionationOrder,userMethodPurification}=If[MatchQ[methodPacket,PacketP[]],
          Lookup[methodPacket,#,Null]&/@ {TargetProtein,TargetSubcellularFraction,Lyse,CellType,FractionationOrder,Purification},
          ConstantArray[Null,6]
        ];

        (* Setup a boolean to determine if there is a method set or not. *)
        methodSpecifiedQ = MatchQ[method, ObjectP[Object[Method, Extraction, SubcellularProtein]]];
        useMapThreadMethodQ = MatchQ[Lookup[myMapThreadOptions, Method], Except[Automatic|Custom]];


        (* --- METHOD OPTION RESOLUTION --- *)

        (*Resolve cell type first because we will use it to resolve TargetSubcellularFraction which is used to pick Method.*)
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

        (*Resolve TargetSubcellularFraction first *)
        resolvedTargetSubcellularFraction = Which[
          (*If TargetProtein is specified by the user, accept it*)
          MatchQ[targetSubcellularFraction,Except[Automatic]],
            targetSubcellularFraction,
          (*If Method is specified by the user, and the TargetProtein field is populated *)
          methodSpecifiedQ&&!MatchQ[userMethodTargetSubcellularFraction,Null],
            userMethodTargetSubcellularFraction,
          (*If Method->Custom and FractionationOrder is specified, TargetSubcellularFraction is automatically set to FractionationOrder*)
          !methodSpecifiedQ && MatchQ[fractionationOrder,Except[Automatic]],
            fractionationOrder,
          (*Here FractionationOrder is also not set, resolve it based on CellType*)
          MatchQ[preResolvedCellType,Bacterial],
            {Cytosolic,Membrane},
          MatchQ[preResolvedCellType,Mammalian | Yeast],(*Mammalian | Yeast | Plant | Insect | Fungal*)
            {Cytosolic,Membrane,Nuclear},
          (*If CellType is none of the above or unknown, resolve based on what options are set for each fraction*)
          True,
            Module[{targetFractionlist,userMembraneOptions,userNuclearOptions,appendFractions},
              targetFractionlist = {Cytosolic};
              (*Lookup user input for membrane options. *)
              userMembraneOptions = Flatten[Lookup[myMapThreadOptions,Flatten[{$ExtractSubcellularProteinMembraneWashOptions,$ExtractSubcellularProteinMembraneSolubilizationOptions,$ExtractSubcellularProteinMembraneFractionationOptions}],Null]];
              (*If any is specified, add Membrane to target fraction list*)
              AppendTo[targetFractionlist,
                If[MemberQ[userMembraneOptions,Except[ListableP[Automatic|Null|False]]],
                  Membrane,
                  Nothing
                ]
              ];
              (*Lookup user input for nuclear options*)
              userNuclearOptions = Flatten[Lookup[myMapThreadOptions,Flatten[{$ExtractSubcellularProteinNuclearWashOptions,$ExtractSubcellularProteinNuclearLysisOptions,$ExtractSubcellularProteinNuclearFractionationOptions}],Null]];
              (*If any is specified, add Nuclear to target fraction list. Return the list.*)
              AppendTo[targetFractionlist,
                If[MemberQ[userNuclearOptions,Except[ListableP[Automatic|Null|False]]],
                  Nuclear,
                  Nothing
                ]
              ]
            ]
        ];

        (*Resolve TargetProtein next, because we will use it to pick Method if Method is to be resolved*)
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
          (*If any Lysis options are specified by the user, set Lyse to True. Dropping TargetCellularComponent and NumberOfLysisReplicates from the list since they arent options in ExtractSubcellularProtein.*)
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

        (* Resolve Method based on the resolved TargetProtein, Lyse, and CellType*)
        (*TODO:: After defining Object[Method,Extraction,SubcellularProtein], rewrite method resolver to mimick the logic in ExtractProtein. *)
        resolvedMethod=If[
          (*If specified by the user, set to user-specified value*)
          MatchQ[method, Except[Automatic]],
          method,
          (*Otherwise Method is Automatic, resolve it*)
          Module[{availableMethodPackets},
            availableMethodPackets=Which[
              (*If resolvedLyse is False, just search using resolvedTargetProtein and resolvedTargetSubcellularFraction*)
              MatchQ[resolvedLyse,False],
              Cases[allMethodPackets,KeyValuePattern[{
                TargetProtein->Alternatives[resolvedTargetProtein,ObjectP[resolvedTargetProtein]],
                TargetSubcellularFraction -> _?(ContainsExactly[#,resolvedTargetSubcellularFraction]&),
                Lyse->resolvedLyse
              }]],
              (*Otherwise resolvedLyse is True, then if Cell Type is known, i.e. not Automatic,use it to search for a method*)
              MatchQ[preResolvedCellType,CellTypeP],
              Cases[allMethodPackets,KeyValuePattern[{
                TargetProtein->Alternatives[resolvedTargetProtein,ObjectP[resolvedTargetProtein]],
                TargetSubcellularFraction -> _?(ContainsExactly[#,resolvedTargetSubcellularFraction]&),
                Lyse->resolvedLyse,
                CellType->preResolvedCellType
              }]],
              (*Otherwise, resolvedLyse is True and CellType is unknown,search without cell type*)
              True,
              Cases[allMethodPackets,KeyValuePattern[{
                TargetProtein->Alternatives[resolvedTargetProtein,ObjectP[resolvedTargetProtein]],
                TargetSubcellularFraction -> _?(ContainsExactly[#,resolvedTargetSubcellularFraction]&),
                Lyse->resolvedLyse
              }]]
            ];
            (*If availableMethods is not empty, use the first found, otherwise set method to Custom*)
            If[!MatchQ[availableMethodPackets,{}],
              FirstCase[availableMethodPackets[Object],ObjectP[Object[Method,Extraction,SubcellularProtein]],Custom],
              Custom
            ]
          ]
        ];

        (*if the method was assigned based on user-specified TargetProtein, then fetch the packet from the downloaded default methods in the fastAssoc*)
        {assignedMethodPacket, useAssignedMethodQ} = If[
          And[
            MatchQ[Lookup[myMapThreadOptions, Method], Automatic],
            MatchQ[resolvedMethod, ObjectP[Object[Method, Extraction, SubcellularProtein]]]
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
        {assignedMethodFractionationOrder,assignedMethodPurification}=If[!MatchQ[assignedMethodPacket,<||>],
          Lookup[assignedMethodPacket,#,Null]&/@{
            FractionationOrder,Purification
          },
          (*If the assigned method packet is empty, set to nulls*)
          ConstantArray[Null,2]
        ];

        (*Resolve fractionation order*)
        resolvedFractionationOrder = Which[
          (*If specified by the user, set to user-specified value*)
          MatchQ[fractionationOrder, Except[Automatic]],
            fractionationOrder,
          (*If a method is specified and Purification is specified by the method, set to method-specified value*)
          useMapThreadMethodQ && MatchQ[userMethodFractionationOrder, Except[Null]],
            userMethodFractionationOrder,
          (*If a method is set by the TargetProtein and Purification is specified by the method, set to method-specified value*)
          useAssignedMethodQ && MatchQ[assignedMethodFractionationOrder, Except[Null]],
            assignedMethodFractionationOrder,
          (*It is not given by user or method, then it is resolved from TargetSubcellularFraction. If resolvedTargetSubcellularFraction does not contain Cytosolic, add it to the beginning.*)
          !MemberQ[resolvedTargetSubcellularFraction,Cytosolic],
            Flatten[{Cytosolic,resolvedTargetSubcellularFraction}],
          True,
            SortBy[ToList@resolvedTargetSubcellularFraction,{Cytosolic,Membrane,Nuclear}]
        ];

        (*Resolve purification*)
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
          (*If there is some options specified, leave it Automatic for the shared resolver*)
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

        (*Call helper function to preResolve lysis options*)
        preResolvedLysisOptionRules = Experiment`Private`preResolveLysisOptionsForExtractSubcellularProtein[resolvedLyse,myMapThreadOptions,useMapThreadMethodQ,methodPacket,useAssignedMethodQ,assignedMethodPacket,resolvedPurification];

        (*Return the resolved and preResolved Options*)
        {
          (*1*)resolvedTargetProtein,
          (*2*)resolvedLyse,
          (*3*)preResolvedCellType,
          (*4*)resolvedTargetSubcellularFraction,
          (*5*)resolvedFractionationOrder,
          (*6*)resolvedMethod,
          (*7*)resolvedPurification,

          (*8*)Lookup[preResolvedLysisOptionRules,LysisTime],
          (*9*)Lookup[preResolvedLysisOptionRules,LysisTemperature],
          (*10*)Lookup[preResolvedLysisOptionRules,LysisAliquot],
          (*11*)Lookup[preResolvedLysisOptionRules,ClarifyLysate],
          (*12*)Lookup[preResolvedLysisOptionRules,LysisAliquotContainer],
          (*13*)Lookup[preResolvedLysisOptionRules,LysisAliquotContainerLabel],
          (*14*)Lookup[preResolvedLysisOptionRules,ClarifiedLysateContainer],
          (*15*)Lookup[preResolvedLysisOptionRules,ClarifiedLysateContainerLabel],
          (*16*)Lookup[preResolvedLysisOptionRules,NumberOfLysisSteps],
          (*17*)Lookup[preResolvedLysisOptionRules,LysisSolutionTemperature],
          (*18*)Lookup[preResolvedLysisOptionRules,LysisSolutionEquilibrationTime],
          (*19*)Lookup[preResolvedLysisOptionRules,SecondaryLysisSolutionTemperature],
          (*20*)Lookup[preResolvedLysisOptionRules,SecondaryLysisSolutionEquilibrationTime],
          (*21*)Lookup[preResolvedLysisOptionRules,TertiaryLysisSolutionTemperature],
          (*22*)Lookup[preResolvedLysisOptionRules,TertiaryLysisSolutionEquilibrationTime]
        }
      ]
    ],
    {samplePackets, methodPackets, mapThreadFriendlyOptions}
  ];


  (* -- RESOLVE LYSIS OPTIONS -- *)

  (*Prep options for use in ExperimentLyseCells by incorporating lysis container out values and*)
  (*the resolved robotic instrument.*)
  (*Prep options for use in ExperimentLyseCells by incorporating lysis container out values and*)
  (*the resolved robotic instrument.*)
  myOptionsWithPreResolvedLysis = Join[
    ReplaceRule[
      myOptions,
      {
        Method -> resolvedMethods,
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
        RoboticInstrument -> resolvedRoboticInstrument,
        WorkCell -> resolvedWorkCell
      }
    ]
  ];
  
  (*Make options mapthreadfriendly based on ExperimentExtractSubcellularProtein.*)
  (*NOTE: Need to use ExperimentExtractSubcellularProtein to properly mapthread since some samples can have Lyse -> False*)
  (*and therefore have options that match ExperimentExtractSubcellularProtein, but not ExperimentLyseCells*)
  mapThreadOptionsWithPreResolvedLysis = OptionsHandling`Private`mapThreadOptions[ExperimentExtractSubcellularProtein, myOptionsWithPreResolvedLysis];

  (*Add SampleLabelOut to each mapthreadready option association for later use to pull out container outs after lysing.*)
  mapThreadFriendlyOptionsWithPreResolvedLysis = Map[
    Append[#, SampleOutLabel -> Automatic]&,
    mapThreadOptionsWithPreResolvedLysis
  ];

  (* Call ExperimentLyseCells to resolve options only*)
  {resolvedLysisOptions,resolvedLysisSimulation, resolvedLysisTests} =Quiet[
    resolveSharedOptions[
      ExperimentLyseCells,
      "The following message was thrown when calculating the lysis options for the following samples, ",
      samplePackets,
      resolvedLyses,
      (* NOTE:TargetCellularComponent is not used in ExperimentExtractSubcellularProtein (it will be resolved based on TargetProtein when resolving purification options), *)
      Join[
        Normal[KeyDrop[$LyseCellsSharedOptionsMap, {TargetCellularComponent, NumberOfLysisReplicates}]],
        {
          SampleOutLabel -> SampleOutLabel
        }
      ],
      (*Add SampleLabelOut option for later use to pull out container outs after lysing.*)
      Join[
        myOptionsWithPreResolvedLysis,
        {
          SampleOutLabel -> ConstantArray[Automatic, Length[mySamples]]
        }
      ],
      {
        NumberOfReplicates -> Null,
        TargetCellularComponent -> CytosolicProtein,
        OptionsResolverOnly -> True
      },
      mapThreadFriendlyOptionsWithPreResolvedLysis,
      gatherTests,
      Simulation -> currentSimulation
    ],
    {Error::InvalidSolidMediaSample, Error::InvalidInput}
  ];
  resolvedLysisAndGeneralOptions = Join[
    Normal[KeyDrop[resolvedLysisOptions,{SampleOutLabel,RoboticInstrument}],Association],
    {
      TargetProtein -> resolvedTargetProteins,
      TargetSubcellularFraction -> resolvedTargetSubcellularFractions,
      FractionationOrder -> resolvedFractionationOrders,
      Lyse -> resolvedLyses,
      LysisSolutionTemperature -> resolvedLysisSolutionTemperatures,
      LysisSolutionEquilibrationTime -> resolvedLysisSolutionEquilibrationTimes,
      SecondaryLysisSolutionTemperature -> resolvedSecondaryLysisSolutionTemperatures,
      SecondaryLysisSolutionEquilibrationTime -> resolvedSecondaryLysisSolutionEquilibrationTimes,
      TertiaryLysisSolutionTemperature -> resolvedTertiaryLysisSolutionTemperatures,
      TertiaryLysisSolutionEquilibrationTime -> resolvedTertiaryLysisSolutionEquilibrationTimes,
      Method -> resolvedMethods,
      Purification -> ToList[resolvedPurifications]
    }
  ];

  (* Update the options with resolved lysis options and general options *)
  myOptionsWithGeneralAndLysisResolved = ReplaceRule[
    Normal[roundedExperimentOptions,Association],
    resolvedLysisAndGeneralOptions
  ];

  resolvedMethodPackets = If[MatchQ[#,ObjectP[Object[Method,Extraction,SubcellularProtein]]],
    fetchPacketFromFastAssoc[#,fastCacheBall],
    <||>]&/@resolvedMethods;

  mapThreadFriendlyOptionsWithGeneralAndLysisResolved = OptionsHandling`Private`mapThreadOptions[ExperimentExtractSubcellularProtein, myOptionsWithGeneralAndLysisResolved];

  (* -- RESOLVE MAPTHREAD OPTIONS 2: Fractionation and purification options -- *)
  preResolvedFractionationAndPurificationOptionRules=Transpose@MapThread[
    Function[{samplePacket, methodPacket, myMapThreadOptions},
      Module[
        {
          (*Helper variables*)
          useMethodQ,initialSampleVolume,postLysisSampleVolume,
          postLysisSampleContainer,currentMaxVolumeCapacity,maxFilterVolume,maxSampleContainerVolume,
          preResolvedCytosolicFractionationOptions,postCytosolicFractionationVolume,cytosolicCollectedVolume,
          preResolvedMembraneWashAndPrepOptions,postMembraneWashAndPrepVolume,
          preResolvedMembraneFractionationOptions,postMembraneFractionationVolume,membraneCollectedVolume,
          preResolvedNuclearWashAndPrepOptions,postNuclearWashAndPrepVolume,preResolvedNuclearFractionationOptions,postNuclearFractionationVolume,nuclearCollectedVolume,
          sampleInFilterBool,lastFractionationTechnique,sampleVolumesForPurification,safeStartingVolumeForPurification,
          (*Resolved options to pull from input*)
          resolvedLyse,resolvedLysisAliquot, resolvedLysisAliquotContainer, resolvedClarifyLysate, resolvedClarifiedLysateContainer,resolvedCellType,resolvedTargetProtein,resolvedTargetSubcellularFraction,resolvedFractionationOrder,resolvedPurification,
          (*Options resolved in this mapthread*)
          resolvedFractionationFilter,fractionationFilter,methodFractionationFilter, resolvedFractionationFinalPelletStorageCondition, fractionationFinalPelletStorageCondition,methodFractionationFinalPelletStorageCondition,
          resolvedFractionationFinalFilterStorageCondition,fractionationFinalFilterStorageCondition,methodFractionationFinalFilterStorageCondition,
          preResolvedSolidPhaseExtractionLoadingSampleVolume, solidPhaseExtractionLoadingSampleVolume,methodSolidPhaseExtractionLoadingSampleVolume,
          preResolvedMagneticBeadSeparationSampleVolume,magneticBeadSeparationSampleVolume,methodMagneticBeadSeparationSampleVolume,
          prePreResolvedSPEOptionRules,prePreResolvedPrecipitationOptionRules,resolvedPurificationSampleVolume
        },

        (*Lookup the user specified and already resolved options*)
        {(*Already resolved*)
          resolvedLyse,resolvedLysisAliquot, resolvedLysisAliquotContainer, resolvedClarifyLysate, resolvedClarifiedLysateContainer,resolvedCellType,
          resolvedTargetProtein,resolvedTargetSubcellularFraction,resolvedFractionationOrder,resolvedPurification,
          (*User specified*)
          fractionationFilter,fractionationFinalPelletStorageCondition,fractionationFinalFilterStorageCondition,solidPhaseExtractionLoadingSampleVolume, magneticBeadSeparationSampleVolume
        }=Lookup[myMapThreadOptions,
          {
            (*Already resolved*)
            Lyse,LysisAliquot, LysisAliquotContainer, ClarifyLysate, ClarifiedLysateContainer,CellType,
            TargetProtein,TargetSubcellularFraction,FractionationOrder,Purification,
            (*User specified*)
            FractionationFilter,FractionationFinalPelletStorageCondition,FractionationFinalFilterStorageCondition,SolidPhaseExtractionLoadingSampleVolume,MagneticBeadSeparationSampleVolume
          }
        ];

        (*Determine if we are using a method*)
        useMethodQ=!MatchQ[methodPacket,<||>];
        (*Lookup the method specified values for the options to be resolved here*)
        {methodFractionationFilter,methodFractionationFinalPelletStorageCondition,methodFractionationFinalFilterStorageCondition,methodSolidPhaseExtractionLoadingSampleVolume,
          methodMagneticBeadSeparationSampleVolume}=If[MatchQ[methodPacket,PacketP[]],
          Lookup[methodPacket,#,Null]&/@ {FractionationFilter,FractionationFinalPelletStorageCondition,FractionationFinalFilterStorageCondition,SolidPhaseExtractionLoadingSampleVolume,MagneticBeadSeparationSampleVolume},
          ConstantArray[Null,5]
        ];

        (*Look up the sample volume at the start of the experiment*)
        initialSampleVolume = Lookup[samplePacket,Volume];
        (* Calculate the current sample volume after lysis. If no lysis is performed, no chnage to the volume. Otherwise, call the helper function to determine the volume *)
        postLysisSampleVolume = If[MatchQ[resolvedLyse,False],
          initialSampleVolume,
          calculatePostLysisSampleVolume[initialSampleVolume,myMapThreadOptions]
        ];

        (*Get the current container at the start of fractionation, i.e.post-lysis or starting sample container if Lyse->False.*)
        postLysisSampleContainer = Which[
          (*If the sample is aliquotted, but not clarified, then the aliquot container is the container it exits lysis in.*)
          MatchQ[resolvedLysisAliquot, True] && MatchQ[resolvedClarifyLysate, False],
            FirstCase[Flatten[ToList@resolvedLysisAliquotContainer],ObjectP[],Null],
          (*If the sample is clarified after lysis, then the clarified lysate container is the container it exits lysis in.*)
          MatchQ[resolvedClarifyLysate, True],
           FirstCase[Flatten[ToList@resolvedClarifiedLysateContainer],ObjectP[],Null],
          (*If the sample is not lysed or is lysed, but not aliquotted nor clarified, then the output container is the same as the input container.*)
          True,
            LinkedObject[Lookup[samplePacket,Container]]
        ];

        maxSampleContainerVolume = Lookup[fetchPacketFromFastAssoc[postLysisSampleContainer,fastCacheBall],MaxVolume];

        (*Resolve filter*)
        resolvedFractionationFilter = Which[
          (*If specified by the user, set to user-specified value*)
          MatchQ[fractionationFilter,Except[Automatic]],
            fractionationFilter,
          (*If a method is specified and It is specified by the method, set to method-specified value*)
          useMethodQ && MatchQ[methodFractionationFilter, Except[Null]],
            methodFractionationFilter,
          (*If any of the fractionation/separation technique is set to filter, or any of the filter options is specified by the user or method, set to the default filter*)
          Or[
            MemberQ[Flatten[{Lookup[methodPacket,#,Null]&/@($ExtractSubcellularProteinSeparationTechniqueOptions),
              Lookup[myMapThreadOptions,#,Null]&/@($ExtractSubcellularProteinSeparationTechniqueOptions)}],Filter],
            MemberQ[Flatten[Lookup[myMapThreadOptions,#,Null]&/@($ExtractSubcellularProteinAllFilterOptions)],Except[Automatic|Null]],
            useMethodQ&&MemberQ[Flatten[Lookup[methodPacket,#,Null]&/@($ExtractSubcellularProteinAllFilterOptions)],Except[Null]]
          ],
            Model[Container, Plate, Filter, "id:xRO9n3O0B9E5"], (*Model[Container, Plate, Filter, "Plate Filter, Omega 30K MWCO, 1000uL"]*)
          (*Otherwise set to Null*)
          True,
            Null
        ];

        maxFilterVolume = If[MatchQ[resolvedFractionationFilter,ObjectP[]],
          Lookup[fetchPacketFromFastAssoc[resolvedFractionationFilter,fastCacheBall],MaxVolume],
          Null];

        (*First step in Fractionation is always Cytosolic Fractionation. Call the helper function to preResolve the options*)
        {preResolvedCytosolicFractionationOptions,postCytosolicFractionationVolume,cytosolicCollectedVolume,sampleInFilterBool} = preResolveFractionationStepOptions[Cytosolic,False(*sample not yet in filter for sure*),myMapThreadOptions, $CytosolicFractionationOptionsMap, useMethodQ, methodPacket, resolvedFractionationOrder,resolvedCellType,resolvedPurification,postLysisSampleVolume];

        (*Check the current container or filter max volume capacity*)
        currentMaxVolumeCapacity = If[sampleInFilterBool,
          (*If the sample is in filter, max volume capacity is that of the filter plate*)
          maxFilterVolume,
          (*If the sample is not in filter, the sample is in postLysisSampleContainer*)
          maxSampleContainerVolume
        ];

        (* Depending on what's next in the Fractionation order, the wash/prep and fractionation resolver helper functions are called differently. (If both Nulcear and Membrane are not performed, the order to call doesn't matter) *)

        If[MatchQ[FirstCase[resolvedFractionationOrder,Except[Cytosolic],Null],Membrane],

          Module[{},
            (* If Membrane fractionation is to be performed next, i.e. the fractionation order could be C->M->N or C->M *)
            {preResolvedMembraneWashAndPrepOptions,postMembraneWashAndPrepVolume} = preResolvePreFractionationWashAndPrepOptions[Membrane,sampleInFilterBool,initialSampleVolume,currentMaxVolumeCapacity,myMapThreadOptions,$MembraneWashAndPrepOptionsMap,useMethodQ,methodPacket,resolvedFractionationOrder,resolvedCellType,resolvedPurification,postCytosolicFractionationVolume];

            {preResolvedMembraneFractionationOptions,postMembraneFractionationVolume,membraneCollectedVolume,sampleInFilterBool} = preResolveFractionationStepOptions[Membrane,sampleInFilterBool,myMapThreadOptions, $MembraneFractionationOptionsMap, useMethodQ, methodPacket, resolvedFractionationOrder,resolvedCellType,resolvedPurification,postMembraneWashAndPrepVolume];

            (*Check the current container or filter max volume capacity*)
            currentMaxVolumeCapacity = If[sampleInFilterBool,
              (*If the sample is in filter, max volume capacity is that of the filter plate*)
              maxFilterVolume,
              (*If the sample is not in filter, the sample is in postLysisSampleContainer*)
              maxSampleContainerVolume
            ];

            (* Nuclear fractionation is to be performed next*)
            {preResolvedNuclearWashAndPrepOptions,postNuclearWashAndPrepVolume} = preResolvePreFractionationWashAndPrepOptions[Nuclear,sampleInFilterBool,initialSampleVolume,currentMaxVolumeCapacity,myMapThreadOptions,$NuclearWashAndPrepOptionsMap,useMethodQ,methodPacket,resolvedFractionationOrder,resolvedCellType,resolvedPurification,postMembraneFractionationVolume];

            {preResolvedNuclearFractionationOptions,postNuclearFractionationVolume,nuclearCollectedVolume,sampleInFilterBool} = preResolveFractionationStepOptions[Nuclear,sampleInFilterBool,myMapThreadOptions, $NuclearFractionationOptionsMap, useMethodQ, methodPacket, resolvedFractionationOrder,resolvedCellType,resolvedPurification,postNuclearWashAndPrepVolume];

          ],

          Module[{},
            (*Otherwise, Nuclear fractionation is to be performed next (or no other fractionation at all), i.e. the fractionation order could be C->N->M or C->N or C*)
            (* Nuclear fractionation is to be performed next*)
            {preResolvedNuclearWashAndPrepOptions,postNuclearWashAndPrepVolume} = preResolvePreFractionationWashAndPrepOptions[Nuclear,sampleInFilterBool,initialSampleVolume,currentMaxVolumeCapacity,myMapThreadOptions,$NuclearWashAndPrepOptionsMap,useMethodQ,methodPacket,resolvedFractionationOrder,resolvedCellType,resolvedPurification,postCytosolicFractionationVolume];

            {preResolvedNuclearFractionationOptions,postNuclearFractionationVolume,nuclearCollectedVolume,sampleInFilterBool} = preResolveFractionationStepOptions[Nuclear,sampleInFilterBool,myMapThreadOptions, $NuclearFractionationOptionsMap, useMethodQ, methodPacket, resolvedFractionationOrder,resolvedCellType,resolvedPurification,postNuclearWashAndPrepVolume];

            (*Check the current container or filter max volume capacity*)
            currentMaxVolumeCapacity = If[sampleInFilterBool,
              (*If the sample is in filter, max volume capacity is that of the filter plate*)
              maxFilterVolume,
              (*If the sample is not in filter, the sample is in postLysisSampleContainer*)
              maxSampleContainerVolume
            ];

            {preResolvedMembraneWashAndPrepOptions,postMembraneWashAndPrepVolume} = preResolvePreFractionationWashAndPrepOptions[Membrane,sampleInFilterBool,initialSampleVolume,currentMaxVolumeCapacity,myMapThreadOptions,$MembraneWashAndPrepOptionsMap,useMethodQ,methodPacket,resolvedFractionationOrder,resolvedCellType,resolvedPurification,postNuclearFractionationVolume];

            {preResolvedMembraneFractionationOptions,postMembraneFractionationVolume,membraneCollectedVolume,sampleInFilterBool} = preResolveFractionationStepOptions[Membrane,sampleInFilterBool,myMapThreadOptions, $MembraneFractionationOptionsMap, useMethodQ, methodPacket, resolvedFractionationOrder,resolvedCellType,resolvedPurification,postMembraneWashAndPrepVolume];
          ]
        ];

        (*Get the informtaion of last fractionation technique in order to resolve final pellet or filter storage condition*)
        lastFractionationTechnique = Switch[Last[ToList[resolvedFractionationOrder]],
          Cytosolic,Lookup[preResolvedCytosolicFractionationOptions,CytosolicFractionationTechnique],
          Membrane,Lookup[preResolvedMembraneFractionationOptions,MembraneFractionationTechnique],
          _,Lookup[preResolvedNuclearFractionationOptions,NuclearFractionationTechnique]
        ];

        resolvedFractionationFinalPelletStorageCondition = Which[
          (*If specified by the user, set to user-specified value*)
          MatchQ[fractionationFinalPelletStorageCondition,Except[Automatic]],
            fractionationFinalPelletStorageCondition,
          (*If a method is specified and It is specified by the method, set to method-specified value*)
          useMethodQ && MatchQ[methodFractionationFinalPelletStorageCondition, Except[Null]],
            methodFractionationFinalPelletStorageCondition,
          (*If wash separation is not performed or is performed by filter, set to Null*)
          MatchQ[lastFractionationTechnique,Pellet],
            Disposal,
          True,
            Null
        ];

        resolvedFractionationFinalFilterStorageCondition = Which [
          (*If specified by the user, set to user-specified value*)
          MatchQ[fractionationFinalFilterStorageCondition,Except[Automatic]],
            fractionationFinalFilterStorageCondition,
          (*If a method is specified and It is specified by the method, set to method-specified value*)
          useMethodQ && MatchQ[methodFractionationFinalFilterStorageCondition, Except[Null]],
            methodFractionationFinalFilterStorageCondition,
          (*If wash separation is not performed or is performed by filter, set to Null*)
          MatchQ[lastFractionationTechnique,Filter],
            Disposal,
          True,
            Null
        ];

        (* Summarize the samples and their volumes subject to purification*)
        sampleVolumesForPurification = PickList[
          {cytosolicCollectedVolume,membraneCollectedVolume,nuclearCollectedVolume},
          {Cytosolic, Membrane, Nuclear},
          Alternatives[Sequence @@ resolvedTargetSubcellularFraction]
        ];

        (*Find the minimum volume across the fractions as a safe starting volume for purification*)
        safeStartingVolumeForPurification = Min[Cases[sampleVolumesForPurification,VolumeP]];

        (*PreResolve the sample loading volume for the first technique in purification (or not if it's LLE or precipitation. In this case, a transfer UO will be performed with volume informed by PurificationSampleVolume*)

        preResolvedSolidPhaseExtractionLoadingSampleVolume = Which[
          MatchQ[solidPhaseExtractionLoadingSampleVolume,Except[Automatic]],
            solidPhaseExtractionLoadingSampleVolume,
          useMethodQ && MatchQ[methodSolidPhaseExtractionLoadingSampleVolume, Except[Null]],
            methodSolidPhaseExtractionLoadingSampleVolume,
          MatchQ[First[ToList[resolvedPurification]],SolidPhaseExtraction],
            safeStartingVolumeForPurification,
          True,
            Automatic
        ];
        
        preResolvedMagneticBeadSeparationSampleVolume = Which[
          MatchQ[magneticBeadSeparationSampleVolume,Except[Automatic]],
            magneticBeadSeparationSampleVolume,
          useMethodQ && MatchQ[methodMagneticBeadSeparationSampleVolume, Except[Null]],
            methodMagneticBeadSeparationSampleVolume,
          MatchQ[First[ToList[resolvedPurification]],MagneticBeadSeparation],
            safeStartingVolumeForPurification,
          True,
            Automatic
        ];

        (*Populate the hidden option to use in resource packet*)
        resolvedPurificationSampleVolume = If[MatchQ[resolvedPurification,ListableP[None]], Null,safeStartingVolumeForPurification];

        (*Call helper function to prePreResolve some SPE options*)
        prePreResolvedSPEOptionRules = Experiment`Private`prePreResolveSPEOptionsForExtractProtein[resolvedPurification,myMapThreadOptions,useMethodQ,methodPacket,False,Null,resolvedTargetProtein,resolvedCellType];

        prePreResolvedPrecipitationOptionRules = prePreResolvePrecipitationOptionsForExtractProtein[resolvedPurification,myMapThreadOptions,useMethodQ,methodPacket,False,Null];

        (*Return all of the pre-resolved fractionation and purification options as rules*)
        Join[
          {
            FractionationFilter -> resolvedFractionationFilter,
            FractionationFinalPelletStorageCondition -> resolvedFractionationFinalPelletStorageCondition,
            FractionationFinalFilterStorageCondition -> resolvedFractionationFinalFilterStorageCondition,
            SolidPhaseExtractionLoadingSampleVolume -> preResolvedSolidPhaseExtractionLoadingSampleVolume,
            MagneticBeadSeparationSampleVolume -> preResolvedMagneticBeadSeparationSampleVolume,
            PurificationSampleVolume -> resolvedPurificationSampleVolume
          },
          preResolvedCytosolicFractionationOptions,
          preResolvedMembraneWashAndPrepOptions,
          preResolvedMembraneFractionationOptions,
          preResolvedNuclearWashAndPrepOptions,
          preResolvedNuclearFractionationOptions,
          prePreResolvedSPEOptionRules,
          prePreResolvedPrecipitationOptionRules
        ]

      ]
    ],
    {samplePackets, resolvedMethodPackets, mapThreadFriendlyOptionsWithGeneralAndLysisResolved}
  ];
  
  optionsWithResolvedFractionationAndPurification = ReplaceRule[
    Normal[myOptionsWithGeneralAndLysisResolved, Association], 
    Join[Sequence@@preResolvedFractionationAndPurificationOptionRules]];
  
  preCorrectionMapThreadFriendlyoptionsWithResolvedFractionationAndPurification = OptionsHandling`Private`mapThreadOptions[ExperimentExtractSubcellularProtein, Association[optionsWithResolvedFractionationAndPurification]];

  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  mapThreadFriendlyoptionsWithResolvedFractionationAndPurification = Experiment`Private`mapThreadFriendlySolventAdditions[optionsWithResolvedFractionationAndPurification, preCorrectionMapThreadFriendlyoptionsWithResolvedFractionationAndPurification, LiquidLiquidExtractionSolventAdditions];

  (* Pre-resolve purification options. *)
  preResolvedPurificationOptions = preResolvePurificationSharedOptions[mySamples, optionsWithResolvedFractionationAndPurification, mapThreadFriendlyoptionsWithResolvedFractionationAndPurification, TargetCellularComponent -> resolvedTargetProteins/.Alternatives[All,Null]->TotalProtein];

  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions,Sterile->True];

  (* Overwrite our rounded options with our resolved options.*)
  resolvedOptions=ReplaceRule[
    Normal[roundedExperimentOptions, Association],
    Flatten[{
      (*General Options*)
      RoboticInstrument -> resolvedRoboticInstrument,
      WorkCell -> resolvedWorkCell,

      (*General and Lysis Options*)
      resolvedLysisAndGeneralOptions,

      (*PreResolved Fractionation Options*)
      Normal[Merge[preResolvedFractionationAndPurificationOptionRules,Identity],Association],

      (*PostProcessing*)
      resolvedPostProcessingOptions
    }]
  ];

  (* -- CONFLICTING OPTIONS CHECK -- *)
  (*Get map thread friendly resolved options for use in options checks*)
  mapThreadFriendlyResolvedOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractSubcellularProtein, resolvedOptions];

  (* --- General Conflicting Options --- *)
  (*check if the specified method can extract the TargetProtein*)
  methodTargetFractionMismatchedOptions = MapThread[
    Function[{sample, method, targetProtein, targetSubcellularFraction, index},
      Module[{methodTargetProtein,methodTargetSubcellularFraction},

        methodTargetProtein = If[
          MatchQ[method, ObjectP[Object[Method, Extraction, SubcellularProtein]]],
          Lookup[fetchPacketFromFastAssoc[method, fastCacheBall], TargetProtein],
          Unspecified
        ];
        methodTargetSubcellularFraction = If[
          MatchQ[method, ObjectP[Object[Method, Extraction, SubcellularProtein]]],
          Lookup[fetchPacketFromFastAssoc[method, fastCacheBall], TargetSubcellularFraction],
          Null
        ];

        Which[
          MatchQ[{targetProtein,targetSubcellularFraction, method}, {_,_, Custom}],
            Nothing,
          MatchQ[{targetProtein, targetSubcellularFraction,method}, {_,_, Except[Custom | ObjectP[Object[Method, Extraction, SubcellularProtein]]]}],
            {sample, method, targetProtein, index},
          (*Target field could be All or Model[Molecule]. If resolved TargetProtein or target subcellular fraction does not match the one specified in Method, output error*)
          Or[
            !MatchQ[targetProtein, Alternatives[methodTargetProtein,ObjectP[methodTargetProtein]]],
            !ContainsExactly[targetSubcellularFraction,methodTargetSubcellularFraction]
          ],
            {sample, method, targetProtein,targetSubcellularFraction, index},
          True,
            Nothing
        ]
      ]
    ],
    {mySamples, resolvedMethods, resolvedTargetProteins, resolvedTargetSubcellularFractions,Range[Length[mySamples]]}
  ];

  If[Length[methodTargetFractionMismatchedOptions] > 0 && messages,
    Message[
      Warning::MethodTargetFractionMismatch,
      ObjectToString[methodTargetFractionMismatchedOptions[[All, 1]], Cache -> cache],
      methodTargetFractionMismatchedOptions[[All, 5]],
      methodTargetFractionMismatchedOptions[[All, 3]],
      methodTargetFractionMismatchedOptions[[All, 4]],
      methodTargetFractionMismatchedOptions[[All, 2]]
    ];
  ];

  methodTargetConflictingOptionsTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = methodTargetFractionMismatchedOptions[[All, 1]];

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

  (*Check if the TargetSubcellularFraction is valid with the cell type. i.e. bacterial cells do not have nuclear fraction*)
  invalidTargetSubcellularFractionSamples = MapThread[
    Function[{sample, resolvedCellType, resolvedTargetSubcellularFraction, index},
      If[(* If target subcellular fraction contains Nuclear but the cell type is bacteria*)
        MemberQ[ToList@resolvedTargetSubcellularFraction,Nuclear]&& MatchQ[resolvedCellType, Bacterial],
        (*Output the sample, index,*)
        {sample, index},
        Nothing
      ]
    ],
    {mySamples,preResolvedCellTypes,resolvedTargetSubcellularFractions, Range[Length[mySamples]]}
  ];

  If[Length[invalidTargetSubcellularFractionSamples]>0 && messages,
    Message[
      Warning::InvalidTargetSubcellularFraction,
      ObjectToString[invalidTargetSubcellularFractionSamples[[All,1]], Cache -> cache],
      invalidTargetSubcellularFractionSamples[[All,2]]
    ];
  ];

  validTargetSubcellularFractionTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = invalidTargetSubcellularFractionSamples[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " do not have TargetSubcellularFraction specified to container Nuclear (by method or by user) and when the CellType is Bacterial:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " do not have TargetSubcellularFraction specified to container Nuclear (by method or by user) and when the CellType is Bacterial:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (*Check if the Fractionation order contains all members of TargetSubcelllularFraction and starts with Cytosolic *)
  incompleteFractionationOrderOptions = MapThread[
    Function[{sample, resolvedTargetSubcellularFraction,resolvedFractionationOrder, index},
      If[MatchQ[First[ToList@resolvedFractionationOrder],Cytosolic] && ContainsAll[resolvedFractionationOrder,resolvedTargetSubcellularFraction],
        Nothing,
        (*Output the sample, index,*)
        {sample, resolvedTargetSubcellularFraction, resolvedFractionationOrder,index}
      ]
    ],
    {mySamples,resolvedTargetSubcellularFractions,resolvedFractionationOrders, Range[Length[mySamples]]}
  ];
  If[Length[incompleteFractionationOrderOptions]>0 && messages,
    Message[
      Error::IncompleteFractionationOrder,
      ObjectToString[incompleteFractionationOrderOptions[[All,1]], Cache -> cache],
      incompleteFractionationOrderOptions[[All,2]],
      incompleteFractionationOrderOptions[[All,3]],
      incompleteFractionationOrderOptions[[All,4]]
    ];
  ];
  completeFractionationOrderTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = incompleteFractionationOrderOptions[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " have complete FractionationOrder option specified that contains all members of TargetSubcellularFraction and starts with Cytosolic:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " have complete FractionationOrder option specified that contains all members of TargetSubcellularFraction and starts with Cytosolic:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (*Check if the order of the techniques during fractionation is valid. Once Filter is used, future fractions will remain on the filter, so subsequent Pellet would be invalid. The wash separation technique should be the same as the previous fractionation technique*)
  invalidFractionationTechniqueOrderOptions = MapThread[
    Function[{sample, index, fractionationOrder, cytoFrac,memWash,memFrac,nucWash,nucFrac},
      Module[{fracTechOrder,washTechOrder},
        (*Determine the order of fractionation technique based on fractionation order*)
        fracTechOrder = {};
        washTechOrder = {};
        Which[
          MatchQ[#,Cytosolic],
            AppendTo[fracTechOrder,cytoFrac],
          MatchQ[#,Membrane],
            (AppendTo[fracTechOrder, memFrac];AppendTo[washTechOrder, memWash]),
          True,
            (AppendTo[fracTechOrder, nucFrac];AppendTo[washTechOrder, nucWash])
        ]&/@ToList[fractionationOrder];

        If[
          Or[
            MatchQ[fracTechOrder,{___, Filter, Pellet, ___}],
            Length[washTechOrder]>0 && EqualQ[Length[fracTechOrder],Length[washTechOrder]+1] && Sequence@@(Or[!MatchQ[washTechOrder[[#]],Null|fracTechOrder[[#]]]&/@Range[Length[washTechOrder]]])
          ],
          (*If pellet is used after Filter during fractionation order, or there is wash separation technique not matching the previous fractionation technique, throw the error*)
          {sample, index, fractionationOrder, cytoFrac,memWash,memFrac,nucWash,nucFrac},
          Nothing
        ]
      ]
    ],
    {mySamples,Range[Length[mySamples]],
      resolvedFractionationOrders,
      Lookup[resolvedOptions,CytosolicFractionationTechnique],
      Lookup[resolvedOptions,MembraneWashSeparationTechnique],
      Lookup[resolvedOptions,MembraneFractionationTechnique],
      Lookup[resolvedOptions,NuclearWashSeparationTechnique],
      Lookup[resolvedOptions,NuclearFractionationTechnique]
    }
  ];
  If[Length[invalidFractionationTechniqueOrderOptions]>0 && messages,
    Message[
      Error::InvalidFractionationationTechnique,
      ObjectToString[invalidFractionationTechniqueOrderOptions[[All,1]], Cache -> cache],
      invalidFractionationTechniqueOrderOptions[[All,2]],
      invalidFractionationTechniqueOrderOptions[[All,3]],
      invalidFractionationTechniqueOrderOptions[[All,4]],
      invalidFractionationTechniqueOrderOptions[[All,5]],
      invalidFractionationTechniqueOrderOptions[[All,6]],
      invalidFractionationTechniqueOrderOptions[[All,7]],
      invalidFractionationTechniqueOrderOptions[[All,8]]
    ];
  ];
  validFractionationTechniqueOrderTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = invalidFractionationTechniqueOrderOptions[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " have valid fractionation and wash separation techniques according to the FractionationOrder:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " have valid fractionation and wash separation techniques according to the FractionationOrder:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* -- RESOLVED RETURN -- *)

  (* Return our resolved options and/or tests. *)
  outputSpecification/.{
    Result -> resolvedOptions,
    Tests -> Flatten[{
      optionPrecisionTests,
      methodTargetConflictingOptionsTest,
      repeatedLysisOptionsTest,
      unlysedCellsOptionsTest,
      conflictingLysisStepSolutionEquilibrationOptionsTest,
      lysisSolutionEquilibrationTimeTemperatureMismatchOptionsTest,
      nullTargetProteinTest,
      validTargetSubcellularFractionTest,
      completeFractionationOrderTest,
      validFractionationTechniqueOrderTest
    }]
  }
];



