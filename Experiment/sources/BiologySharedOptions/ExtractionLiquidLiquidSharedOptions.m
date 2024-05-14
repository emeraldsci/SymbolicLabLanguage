(* ::Package:: *)

(* ::Text:: *)
(* \[Copyright] 2011-2023 Emerald Cloud Lab, Inc. *)

(* ::Subsection:: *)
(* ExtractionLiquidLiquidSharedOptions *)

DefineOptionSet[
  ExtractionLiquidLiquidSharedOptions:> {

    (*---Liquid-liquid General---*)

    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ExtractionTechnique,
      {
        OptionName -> LiquidLiquidExtractionTechnique,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The physical separation technique that is used to separate the aqueous and organic phase of a sample. The collection of the target phase occurs after the extraction solvent(s) and demulsifier (if specified) are added, the sample is mixed (optionally), allowed to settle for the LiquidLiquidExtractionSettlingTime (for the organic and aqueous phases to separate), and centrifuged (optionally). Pipette uses a pipette to aspirate off either the aqueous or organic layer, optionally taking the boundary layer with it according to the IncludeLiquidBoundary and LiquidBoundaryVolume options. PhaseSeparator uses a column with a hydrophobic frit, which allows the organic phase to pass freely through the frit, but physically blocks the aqueous phase from passing through. Note that when using a phase separator, the organic phase must be heavier than the aqueous phase in order for it to pass through the hydrophobic frit, otherwise, the separator will not occur.",
        ResolutionDescription -> "Automatically set to the LiquidLiquidExtractionTechnique specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionTechnique is set to PhaseSeparator if the option LiquidLiquidExtractionDevice is set (this option only applies to the use of a phase separator). If the options IncludeLiquidBoundary or LiquidBoundaryVolume are set, LiquidLiquidExtractionTechnique is set to Pipette (these options only apply to the use of a pipette for separation). Otherwise, set to PhaseSeparator by default.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ExtractionDevice,
      {
        OptionName -> LiquidLiquidExtractionDevice,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The device which is used to physically separate the aqueous and organic phases.",
        ResolutionDescription -> "If LiquidLiquidExtractionTechnique is set to PhaseSeparator, LiquidLiquidExtractionDevice will be automatically set to the LiquidLiquidExtractionDevice specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionDevice is set to  Model[Container, Plate, PhaseSeparator, \"Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits\"].",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      SelectionStrategy,
      {
        OptionName -> LiquidLiquidExtractionSelectionStrategy,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "Indicates if additional rounds of extraction are performed on the impurity phase (Positive) or the target phase (Negative). Positive selection is used when the goal is to extract the maximum amount of the target analyte from the impurity phase (maximizing yield). Negative selection is used when the goal is to remove impurities that may still exist in the target phase (maximizing purity).",
        ResolutionDescription->"Automatically set to the LiquidLiquidExtractionSelectionStrategy specified by the selected Method. If Method is set to Custom, then LiquidLiquidExtractionSelectionStrategy is set to Null if the NumberOfLiquidLiquidExtractions is set to 1 (this option only applies if there are multiple rounds of extraction). If LiquidLiquidExtractionSolventAdditions or AqueousSolvent/OrganicSolvent is specified, then the solvent(s) specified are used to infer the LiquidLiquidExtractionSelectionStrategy (if the phase of the solvent being added matches LiquidLiquidExtractionTargetPhase, then LiquidLiquidExtractionSelectionStrategy is set to Positive (extraction is done on the impurity layer), otherwise LiquidLiquidExtractionSelectionStrategy is set to Negative). Otherwise, LiquidLiquidExtractionSelectionStrategy is automatically set to Positive selection.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      IncludeBoundary,
      {
        OptionName -> IncludeLiquidBoundary,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "Indicates if the boundary layer (the liquid at the boundary of the organic phase and the aqueous phase) is aspirated along with the LiquidLiquidExtractionTargetPhase (therefore potentially collecting a small amount of the impurity phase) or if the boundary layer is not aspirated along with the LiquidLiquidExtractionTargetPhase (and therefore reducing the likelihood of collecting any of the impurity phase). This option is only applicable when LiquidLiquidExtractionTechnique is set to Pipette.",
        ResolutionDescription->"Automatically set to the value of InludeLiquidBoundary specified by the selected Method. If Method is set to Custom, IncludeLiquidBoundary is automatically set to False for each extraction round if LiquidLiquidExtractionTechnique is set to Pipette.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      TargetPhase,
      {
        OptionName -> LiquidLiquidExtractionTargetPhase,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "Indicates the phase (Organic or Aqueous) that is collected during the extraction and carried forward to further purification steps or other experiments, which is the liquid layer that contains more of the dissolved target analyte after the LiquidLiquidExtractionSettlingTime has elapsed and the phases are separated.",
        ResolutionDescription -> "Automatically set to the LiquidLiquidExtractionTargetPhase specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionTargetPhase is automatically set to Aqueous (since it is the most likely phase to contain target cellular components).",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      TargetLayer,
      {
        OptionName -> LiquidLiquidExtractionTargetLayer,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "Indicates if the target phase (containing more of the target analyte) is the top layer or the bottom layer of the separated solution. Note that when performing multiple rounds of extraction (NumberOfLiquidLiquidExtractions), the composition of the Aqueous and Organic layers during the first round of extraction can differ from the rest of the extraction rounds. For example, if the input sample is Biphasic, LiquidLiquidExtractionTargetPhase is set to Organic, and LiquidLiquidSelectionStrategy is set to Positive, the original organic layer from the input sample will be extracted and in subsequent rounds of extraction, OrganicSolvent added to the Aqueous impurity layer to extract more of the target analyte (the specified OrganicSolvent option can differ from the density of the original sample's organic layer). This can result in LiquidLiquidExtractionTargetLayer being different during the first round of extraction compared to the rest of the extraction rounds.",
        ResolutionDescription -> "Automatically set to the LiquidLiquidExtractionTargetLayer specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionTargetLayer is automatically calculated from the density of the input sample's aqueous and organic layers (if present in the input sample), the density of the AqueousSolvent and OrganicSolvent options (if specified), and the LiquidLiquidExtractionTargetPhase option. If density information is missing for any of these previously mentioned samples/layers, a warning will be thrown and it will be assumed that the Aqueous layer is on Top (less dense) than the Organic layer. During the calculation of this option, it is assumed that the additional molecules from the input sample will not significantly affect the densities of the aqueous and organic layers. It is also assumed that the Aqueous and Organic layers are fully separated after each round of extraction.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ExtractionContainer,
      {
        OptionName -> LiquidLiquidExtractionContainer,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The container that the sample that is aliquotted into, before the liquid liquid extraction is performed.",
        ResolutionDescription -> "Automatically set to the LiquidLiquidExtractionContainer specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] if the input sample is not in a centrifuge-compatible container and centrifugation is specified or if a non-Ambient Temperature is specified (the robotic heater/cooler units are only compatible with Plate format containers). Otherwise, PreferredContainer[...] is used to get a robotic compatible container that can hold the sample.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ExtractionContainerWell,
      {
        OptionName -> LiquidLiquidExtractionContainerWell,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The well of the container that the sample is aliquotted into before the liquid liquid extraction is performed.",
        ResolutionDescription -> "Automatically set to the first empty position in the LiquidLiquidExtractionContainer, if specified.",
        Category -> "Liquid-liquid Extraction"
      }
    ],



    (*---Phase Mixing---*)

    ModifyOptions[ExperimentLiquidLiquidExtraction,
      AqueousSolvent,
      {
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The aqueous solvent that is added to the input sample (or the target phase or impurity phase from the previous extraction round if NumberOfLiquidLiquidExtractions > 1) in order to create an organic and aqueous phase.",
        ResolutionDescription -> "Automatically set to the AqueousSolvent specified by the selected Method. If Method is set to Custom, Model[Sample, \"Milli-Q water\"] is used as the AqueousSolvent if aqueous solvent is required for the extraction.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      AqueousSolventVolume,
      {
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription -> "Automatically set to the AqueousSolventVolume specified by the selected Method. If Method is set to Custom, AqueousSolventVolume is calculated by multiplying 1/AqueousSolventRatio with the sample volume if AqueousSolventRatio is set. Otherwise, if AqueousSolvent is set, AqueousSolventVolume is set to 20% of the volume of the sample being extracted.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      AqueousSolventRatio,
      {
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription -> "Automatically set to the AqueousSolventRatio specified by the selected Method. If Method is set to Custom, AqueousSolventRatio is calculated by dividing the sample volume by AqueousSolventVolume if AqueousSolventVolume is set. Otherwise, if AqueousSolvent is set, AqueousSolventRatio is set to 5.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      OrganicSolvent,
      {
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The organic solvent that is added to the input sample (or the target layer or the impurity layer from the previous extraction round if NumberOfLiquidLiquidExtractions > 1) in order to create an organic and aqueous phase.",
        ResolutionDescription -> "Automatically set to the OrganicSolvent specified by the selected Method. If Method is set to Custom, Model[Sample, \" Phenol:Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture \"] is used as the OrganicSolvent if any specified options imply the use of organic solvent (OrganicSolventVolume or OrganicSolventRatio are specified, LiquidLiquidExtractionTargetPhase is Organic and LiquidLiquidExtractionSelectionStrategy is Negative, or LiquidLiquidExtractionTargetPhase is Aqueous and LiquidLiquidExtractionSelectionStrategy is Positive). If organic solvent is otherwise required for the extraction and LiquidLiquidExtractionTechnique is set to Pipette, Model[Sample, \"Ethyl acetate, HPLC Grade\"] is used as the OrganicSolvent. If organic solvent is required for the extraction and LiquidLiquidExtractionTechnique is PhaseSeparator, Model[Sample, \"Ethyl acetate, HPLC Grade\"] is used as the OrganicSolvent if it denser than the sample's aqueous phase and the AqueousSolvent (if specified) since the phase separator will only be able to let the organic phase pass through the hydrophobic frit if it is on the bottom layer. If Ethyl Acetate is not dense enough, Model[Sample, \"Chloroform\"] will be used.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      OrganicSolventVolume,
      {
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription -> "Automatically set to the OrganicSolventVolume specified by the selected Method. If Method is set to Custom, OrganicSolventVolume is calculated by multiplying 1/OrganicSolventRatio with the sample volume if OrganicSolventRatio is set. Otherwise, if OrganicSolvent is set, OrganicSolventVolume is set to 20% of the volume of the sample being extracted.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      OrganicSolventRatio,
      {
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription -> "Automatically set to the OrganicSolventRatio specified by the selected Method. If Method is set to Custom, OrganicSolventRatio is calculated by dividing the sample volume by OrganicSolventVolume if OrganicSolventVolume is set. Otherwise, if OrganicSolvent is set, OrganicSolventRatio is set to 5.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      SolventAdditions,
      {
        OptionName -> LiquidLiquidExtractionSolventAdditions,
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription -> "Automatically set to the LiquidLiquidExtractionSolventAdditions specified by the selected Method. If Method is set to Custom, aqueous solvent is automatically added if the starting sample of each extraction round is of Organic or Unknown phase. Organic solvent is automatically added if the starting sample of each extraction round is of Aqueous or Unknown phase. If the sample is already Biphasic, then no solvent is added. Note that the phase of the starting sample in extraction rounds 2 and above is dependent on the LiquidLiquidExtractionTargetPhase and LiquidLiquidExtractionSelectionStrategy options.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      Demulsifier,
      {
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription ->"Automatically set to the Demulsifier specified by the selected Method. If Method is set to Custom, Demulsifier is automatically set to the demulsifier specified in DemulsifierAdditions (if DemulsifierAdditions is specified). If DemulsifierAdditions is not specified, Demulsifier is automatically set to Model[Sample, StockSolution, \"5M Sodium Chloride\"] if DemulsifierAmount is specified.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      DemulsifierAmount,
      {
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription ->"Automatically set to the DemulsifierAmount specified by the selected Method. If Method is set to Custom, DemulsifierAmount is automatically set to 10% of the sample volume if Demulsifier or DemulsifierAdditions is specified.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      DemulsifierAdditions,
      {
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription ->"Automatically set to the DemulsifierAdditions specified by the selected Method. If Method is set to Custom, DemulsifierAdditions is set to None if Demulsifier is not specified. If NumberOfLiquidLiquidExtractions is set to 1, Demulsifier will only be added during the first extraction round. If NumberOfLiquidLiquidExtractions is greater than 1 and the sample's organic phase will be used in subsequent extraction rounds (LiquidLiquidExtractionTargetPhase set to Aqueous and LiquidLiquidExtractionTechnique set to Positive OR LiquidLiquidExtractionTargetPhase set to Organic and LiquidLiquidExtractionTechnique set to Negative), Demulsifier will be added during all extraction rounds since the Demulsifier (usually a salt solution which is soluble in the aqueous phase) will be removed along with the aqueous phase during the extraction and thus will need to be added before each extraction round. Otherwise, Demulsifier is added to only the first extraction round since the sample's aqueous phase will be used in subsequent extraction rounds.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      Temperature,
      {
        OptionName -> LiquidLiquidExtractionTemperature,
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription -> "Automatically set to the LiquidLiquidExtractionTemperature specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionTemperature is set to Ambient.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      NumberOfExtractions,
      {
        OptionName -> NumberOfLiquidLiquidExtractions,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The number of times that the liquid-liquid extraction is performed using the specified extraction parameters first on the input sample, and then using the previous extraction round's target layer or impurity layer (based on the LiquidLiquidSelectionStrategy and LiquidLiquidExtractionTargetPhase).",
        ResolutionDescription -> "Automatically set to the NumberofLiquidLiquidExtractions specified by the selected Method. If Method is set to Custom, NumberOfLiquidLiquidExtractions is set to 3.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ExtractionMixType,
      {
        OptionName -> LiquidLiquidExtractionMixType,
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription -> "Automatically set to the LiquidLiquidExtractionMixType specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionMixType is automatically set to Shake if LiquidLiquidExtractionMixTime or LiquidLiquidExtractionRate are specified. Otherwise, LiquidLiquidExtractionMixType set to Pipette.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ExtractionMixTime,
      {
        OptionName -> LiquidLiquidExtractionMixTime,
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription->"Automatically set to the LiquidLiquidExtractionMixTime specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionMixTime is automatically set to 30 Second if LiquidLiquidExtractionMixType is set to Shake.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ExtractionMixRate,
      {
        OptionName -> LiquidLiquidExtractionMixRate,
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription -> "Automatically set to the LiquidLiquidExtractionMixRate specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionMixRate is automatically set to 300 RPM if LiquidLiquidExtractionMixType is set to Shake.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      NumberOfExtractionMixes,
      {
        OptionName -> NumberOfLiquidLiquidExtractionMixes,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The number of times the sample, AqueousSolvent/OrganicSolvent, and demulsifier (if specified) are mixed when LiquidLiquidExtractionMixType is set to Pipette.",
        ResolutionDescription -> "Automatically set to the LiquidLiquidExtractionNumberOfMixes specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionNumberOfMixes is automatically set to 10 when LiquidLiquidExtractionMixType is set to Pipette.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ExtractionMixVolume,
      {
        OptionName -> LiquidLiquidExtractionMixVolume,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The volume of sample, AqueousSolvent/OrganicSolvent, and demulsifier (if specified) that is mixed when LiquidLiquidExtractionMixType is set to Pipette.",
        ResolutionDescription -> "Automatically set to the LiquidLiquidExtractionMixVolume specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionMixVolume is automatically set to the lesser of 1/2 of the volume of the sample plus any additional components (AqueousSolventVolume (if specified), OrganicSolventVolume (if specified), and DemulsifierAmount (if specified)) and 970 Microliter (the maximum amount of volume that can be transferred in a single pipetting step on the liquid handling robot) if LiquidLiquidExtractionMixType is set to Pipette.",
        Category -> "Liquid-liquid Extraction"
      }
    ],


    (*---Settling---*)

    ModifyOptions[ExperimentLiquidLiquidExtraction,
      SettlingTime,
      {
        OptionName -> LiquidLiquidExtractionSettlingTime,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The duration for which the sample is allowed to settle and thus allow the organic and aqueous phases to separate. This is performed after the AqueousSolvent/OrganicSolvent and Demulsifier (if specified) are added and optionally mixed. If LiquidLiquidExtractionTechnique is set to PhaseSeparator, the settling time starts once the sample is loaded into the phase separator (the amount of time for the organic phase to drain through the phase separator's hydrophobic frit).",
        ResolutionDescription-> "Automatically set to the LiquidLiquidExtractionSettlingTime specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionSettlingTime is set to 1 Minute.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      Centrifuge,
      {
        OptionName -> LiquidLiquidExtractionCentrifuge,
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription -> "Automatically set to the same LiquidLiquidExtractionCentrifuge value that is specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionCentrifuge is automatically set to True if any of the other centrifuge options are specified (LiquidLiquidExtractionCentrifugeIntensity, LiquidLiquidExtractionCentrifugeTime). LiquidLiquidExtractionCentrifuge is also automatically set to True if LiquidLiquidExtractionTechnique is set to Pipette and the samples are in a centrifuge-compatible container (the Footprint of the container is set to Plate). Otherwise, LiquidLiquidExtractionCentrifuge is set to False.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      CentrifugeInstrument,
      {
        OptionName -> LiquidLiquidExtractionCentrifugeInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Description->"The centrifuge that is used to spin the samples to help separate the aqueous and organic layers, after the addition of solvent/demulsifier, mixing, and setting time has elapsed.",
        ResolutionDescription->"Automatically set to the integrated centrifuge model that is available in the WorkCell, if the Centrifuge option is set to True.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      CentrifugeIntensity,
      {
        OptionName -> LiquidLiquidExtractionCentrifugeIntensity,
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription -> "Automatically set to the LiquidLiquidExtractionCentrifugeIntensity specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionCentrifugeIntensity is automatically set to the lesser of the MaxIntensity of the centrifuge model and the MaxCentrifugationForce of the plate model, if centrifugation is specified.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      CentrifugeTime,
      {
        OptionName -> LiquidLiquidExtractionCentrifugeTime,
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription -> "Automatically set to the LiquidLiquidExtractionCentrifugeTime specified by the selected Method. If Method is set to Custom, LiquidLiquidExtractionCentrifugeTime is automatically set to 2 Minute, if centrifugation is specified.",
        Category -> "Liquid-liquid Extraction"
      }
    ],


    (*---Collection---*)

    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ExtractionBoundaryVolume,
      {
        OptionName -> LiquidBoundaryVolume,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "For each extraction round, the volume of the target phase that is either overaspirated via Pipette when IncludeLiquidBoundary is set to True (by aspirating the boundary layer along with the LiquidLiquidExtractionTargetPhase and therefore potentially collecting a small amount of the impurity phase) or underaspirated via Pipette when IncludeLiquidBoundary is set to False (by not collecting all of the target phase and therefore reducing the likelihood of collecting any of the impurity phase).",
        ResolutionDescription->"Automatically set to the LiquidBoundaryVolume specified by the selected Method. If Method is set to Custom, LiquidBoundaryVolume automatically set the volume that corresponds with a 5 Millimeter tall cross-section of the sample container at the position of the boundary between aqueous and organic layers if LiquidLiquidExtractionTransferLayer is set to Top or at the bottom of the container if LiquidLiquidExtractionTransferLayer is set to Bottom.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ExtractionTransferLayer,
      {
        OptionName -> LiquidLiquidExtractionTransferLayer,
        Default -> Automatic,
        AllowNull -> True,
        Description->"Indicates whether the top or bottom layer is transferred from the source sample after the organic and aqueous phases are separated. If the LiquidLiquidExtractionTargetLayer matches the LiquidLiquidExtractionTransferLayer, the sample that is transferred out is the target phase. Otherwise, if LiquidLiquidExtractionTargetLayer doesn't match LiquidLiquidExtractionTransferLayer, the sample that remains in the container after the transfer is the target phase.",
        ResolutionDescription->"Automatically set to Top if LiquidLiquidExtractionTechnique is set to Pipette.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ImpurityStorageCondition,
      {
        OptionName -> ImpurityLayerStorageCondition,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The conditions under which the impurity layer will be stored after the protocol is completed.",
        ResolutionDescription-> "Automatically set to Disposal for each extraction round if not otherwise specified.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ImpurityContainerOut,
      {
        OptionName -> ImpurityLayerContainerOut,
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription -> "Automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] if LiquidLiquidExtractionTargetPhase is set to Aqueous and LiquidLiquidExtractionTechnique is set to PhaseSeparator (since the organic impurity layer will flow through the phase separator's hydrophobic frit, ImpurityLayerContainerOut will be used as the collection container for the phase separator). Otherwise, ImpurityLayerContainerOut is automatically set to a robotic compatible container that can hold the volume of the target layer via PreferredContainer[...].",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ImpurityContainerOutWell,
      {
        OptionName -> ImpurityLayerContainerOutWell,
        Default -> Automatic,
        AllowNull -> True,
        ResolutionDescription->"Automatically set the first empty well in ImpurityLayerContainerOut.",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ImpurityLabel,
      {
        OptionName -> ImpurityLayerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Description->"A user defined word or phrase used to identify the container that contains the impurity layer, for use in downstream unit operations.",
        ResolutionDescription->"Automatically set to \"liquid liquid extraction impurity layer #\".",
        Category -> "Liquid-liquid Extraction"
      }
    ],
    ModifyOptions[ExperimentLiquidLiquidExtraction,
      ImpurityContainerLabel,
      {
        OptionName -> ImpurityLayerContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Description->"A user defined word or phrase used to identify the container that contains the impurity layer, for use in downstream unit operations.",
        ResolutionDescription->"Automatically set to set to \"liquid liquid extraction impurity layer container #\".",
        Category -> "Liquid-liquid Extraction"
      }
    ]
  }
];


(* ::Subsection:: *)
(* LLEPurificationOptionMap *)

$LLEPurificationOptionMap={
  LiquidLiquidExtractionTechnique -> ExtractionTechnique,
  LiquidLiquidExtractionDevice -> ExtractionDevice,
  LiquidLiquidExtractionSelectionStrategy -> SelectionStrategy,
  IncludeLiquidBoundary -> IncludeBoundary,
  LiquidLiquidExtractionTargetPhase -> TargetPhase,
  LiquidLiquidExtractionTargetLayer -> TargetLayer,
  LiquidLiquidExtractionContainer -> ExtractionContainer,
  LiquidLiquidExtractionContainerWell -> ExtractionContainerWell,
  AqueousSolvent -> AqueousSolvent,
  AqueousSolventVolume -> AqueousSolventVolume,
  AqueousSolventRatio -> AqueousSolventRatio,
  OrganicSolvent -> OrganicSolvent,
  OrganicSolventVolume -> OrganicSolventVolume,
  OrganicSolventRatio -> OrganicSolventRatio,
  LiquidLiquidExtractionSolventAdditions -> SolventAdditions,
  Demulsifier -> Demulsifier,
  DemulsifierAmount -> DemulsifierAmount,
  DemulsifierAdditions -> DemulsifierAdditions,
  LiquidLiquidExtractionTemperature -> Temperature,
  NumberOfLiquidLiquidExtractions -> NumberOfExtractions,
  LiquidLiquidExtractionMixType -> ExtractionMixType,
  LiquidLiquidExtractionMixTime -> ExtractionMixTime,
  LiquidLiquidExtractionMixRate -> ExtractionMixRate,
  NumberOfLiquidLiquidExtractionMixes -> NumberOfExtractionMixes,
  LiquidLiquidExtractionMixVolume -> ExtractionMixVolume,
  LiquidLiquidExtractionSettlingTime -> SettlingTime,
  LiquidLiquidExtractionCentrifuge -> Centrifuge,
  LiquidLiquidExtractionCentrifugeInstrument -> CentrifugeInstrument,
  LiquidLiquidExtractionCentrifugeIntensity -> CentrifugeIntensity,
  LiquidLiquidExtractionCentrifugeTime -> CentrifugeTime,
  LiquidBoundaryVolume -> ExtractionBoundaryVolume,
  LiquidLiquidExtractionTransferLayer -> ExtractionTransferLayer,
  ImpurityLayerStorageCondition -> ImpurityStorageCondition,
  ImpurityLayerContainerOut -> ImpurityContainerOut,
  ImpurityLayerContainerOutWell -> ImpurityContainerOutWell,
  ImpurityLayerLabel -> ImpurityLabel,
  ImpurityLayerContainerLabel -> ImpurityContainerLabel
};

(* ::Subsection:: *)
(* SharedLLEMethodFields *)

$SharedLLEMethodFields = {Purification,LiquidLiquidExtractionTechnique,LiquidLiquidExtractionDevice,LiquidLiquidExtractionSelectionStrategy,LiquidLiquidExtractionTargetPhase,LiquidLiquidExtractionTargetLayer,AqueousSolvent,AqueousSolventRatio,OrganicSolvent,OrganicSolventRatio,LiquidLiquidExtractionSolventAdditions,Demulsifier,DemulsifierAdditions,LiquidLiquidExtractionTemperature,NumberOfLiquidLiquidExtractions,LiquidLiquidExtractionMixType,LiquidLiquidExtractionMixTime,LiquidLiquidExtractionMixRate,NumberOfLiquidLiquidExtractionMixes,LiquidLiquidExtractionSettlingTime,LiquidLiquidExtractionCentrifuge,LiquidLiquidExtractionCentrifugeIntensity,LiquidLiquidExtractionCentrifugeTime}


(* ::Subsection:: *)
(* preResolveLiquidLiquidExtractionSharedOptions *)

DefineOptions[
  preResolveLiquidLiquidExtractionSharedOptions,
  Options:>{
    CacheOption,
    SimulationOption
  }
];

preResolveLiquidLiquidExtractionSharedOptions[mySamples:{ObjectP[Object[Sample]]...}, myMethods:{(ObjectP[Object[Method]]|Custom)..}, myOptionMap_List, myOptions_List, myMapThreadOptions:{_Association..}, myResolutionOptions:OptionsPattern[preResolveLiquidLiquidExtractionSharedOptions]] := Module[
  {safeOps, cache, simulation, sampleFields, samplePacketFields, samplePackets, methodFields, methodPacketFields, methodPackets, simplePreResolveOption, simplePreResolveOptionNoMethod, preResolvedLiquidLiquidExtractionTechnique, preResolvedLiquidLiquidExtractionDevice, preResolvedLiquidLiquidExtractionSelectionStrategy, preResolvedLiquidLiquidExtractionTargetPhase, preResolvedLiquidLiquidExtractionTargetLayer, preResolvedAqueousSolvent, preResolvedAqueousSolventRatio, preResolvedOrganicSolvent, preResolvedOrganicSolventRatio, preResolvedLiquidLiquidExtractionSolventAdditions, preResolvedDemulsifier, preResolvedDemulsifierAdditions, preResolvedLiquidLiquidExtractionTemperature, preResolvedNumberOfLiquidLiquidExtractions, preResolvedLiquidLiquidExtractionMixType, preResolvedLiquidLiquidExtractionMixTime, preResolvedLiquidLiquidExtractionMixRate, preResolvedNumberOfLiquidLiquidExtractionMixes, preResolvedLiquidLiquidExtractionSettlingTime, preResolvedLiquidLiquidExtractionCentrifuge, preResolvedLiquidLiquidExtractionCentrifugeIntensity, preResolvedLiquidLiquidExtractionCentrifugeTime, preResolvedImpurityLayerStorageCondition, preResolvedLLESharedOptions, preResolvedOptions, modifiedOptionMap, preResolvedMapThreadOptions, mapThreadReadyPreResolvedLLEOptions, preResolvedMapThreadLLEOptions, outputSpecification, output, gatherTestsQ},

  (*Pull out the safe options.*)
  safeOps = SafeOptions[preResolveLiquidLiquidExtractionSharedOptions, ToList[myResolutionOptions]];

  (* Lookup our cache and simulation. *)
  cache = Lookup[ToList[safeOps], Cache, {}];
  simulation = Lookup[ToList[safeOps], Simulation, Null];

  (* Determine the requested return value from the function (Result, Options, Tests, or multiple). *)
  outputSpecification=Lookup[myOptions, Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests (Output contains Test). *)
  gatherTestsQ=MemberQ[output,Tests];

  (* Download fields from samples that are required.*)
  (* NOTE: All fields downloaded below should already be included in the cache passed down to us by the main function. *)
  sampleFields = DeleteDuplicates[Flatten[{Name, Status, Model, Composition, CellType, Living, CultureAdhesion, Volume, Analytes, Density, Container, Position}]];
  samplePacketFields = Packet@@sampleFields;
  methodFields = DeleteDuplicates[Flatten[$SharedLLEMethodFields]];
  methodPacketFields = Packet@@methodFields;

  {
    samplePackets,
    methodPackets
  } = Download[
    {
      mySamples,
      Replace[myMethods, {Custom -> Null}, 2]
    },
    {
      {samplePacketFields},
      {methodPacketFields}
    },
    Cache -> cache,
    Simulation -> simulation
  ];

  {
    samplePackets,
    methodPackets
  }=Flatten/@{
    samplePackets,
    methodPackets
  };

  (* helper function that does simple pre-resolution logic:*)
  simplePreResolveOption[myOptionName_Symbol, mapThreadedOptions_Association, myMethodPacket_, myMethodSpecifiedQ:BooleanP, myLLEUsedQ:BooleanP]:=Which[
    (* If specified by the user, set to user-specified value *)
    MatchQ[Lookup[mapThreadedOptions, myOptionName], Except[Automatic]],
      Lookup[mapThreadedOptions, myOptionName],
    (* If specified by the method, set to the method-specified value*)
    (* NOTE: Empty single fields are Null, but empty multiple fields are {}, so we check for both. *)
    myMethodSpecifiedQ && MatchQ[Lookup[myMethodPacket, myOptionName, Null], Except[Null|{}]],
     Lookup[myMethodPacket, myOptionName],
    (* If LLE is not used and the option is not specified, it is set to Null. *)
    !myLLEUsedQ,
      Null,
    True,
      Automatic
  ];

  (*Pre-resolve liquid-liquid extraction shared options (since ExperimentLLE doesn't use methods & organic solvent needs new resolution).*)
  {
    preResolvedLiquidLiquidExtractionTechnique,
    preResolvedLiquidLiquidExtractionDevice,
    preResolvedLiquidLiquidExtractionSelectionStrategy,
    preResolvedLiquidLiquidExtractionTargetPhase,
    preResolvedLiquidLiquidExtractionTargetLayer,
    preResolvedAqueousSolvent,
    preResolvedAqueousSolventRatio,
    preResolvedOrganicSolvent,
    preResolvedOrganicSolventRatio,
    preResolvedLiquidLiquidExtractionSolventAdditions,
    preResolvedDemulsifier,
    preResolvedDemulsifierAdditions,
    preResolvedLiquidLiquidExtractionTemperature,
    preResolvedNumberOfLiquidLiquidExtractions,
    preResolvedLiquidLiquidExtractionMixType,
    preResolvedLiquidLiquidExtractionMixTime,
    preResolvedLiquidLiquidExtractionMixRate,
    preResolvedNumberOfLiquidLiquidExtractionMixes,
    preResolvedLiquidLiquidExtractionSettlingTime,
    preResolvedLiquidLiquidExtractionCentrifuge,
    preResolvedLiquidLiquidExtractionCentrifugeIntensity,
    preResolvedLiquidLiquidExtractionCentrifugeTime,
    preResolvedImpurityLayerStorageCondition
  } = Transpose@MapThread[
    Function[{options, methodPacket},
      Module[
        {
          lleUsedQ, methodSpecifiedQ, liquidLiquidExtractionTechnique, liquidLiquidExtractionDevice, liquidLiquidExtractionSelectionStrategy, liquidLiquidExtractionTargetPhase, liquidLiquidExtractionTargetLayer, aqueousSolvent, aqueousSolventRatio, organicSolvent, organicSolventRatio, liquidLiquidExtractionSolventAdditions, demulsifier, demulsifierAdditions, liquidLiquidExtractionTemperature, liquidLiquidExtractionMixOptions, numberOfLiquidLiquidExtractions, liquidLiquidExtractionMixType, liquidLiquidExtractionMixTime, liquidLiquidExtractionMixRate, numberOfLiquidLiquidExtractionMixes, liquidLiquidExtractionSettlingTime, liquidLiquidExtractionCentrifuge, liquidLiquidExtractionCentrifugeIntensity, liquidLiquidExtractionCentrifugeTime, impurityLayerStorageCondition
        },

        (* Determine if LLE is used for this sample. *)
        lleUsedQ = MemberQ[ToList[Lookup[options, Purification]], LiquidLiquidExtraction];

        (* Setup a boolean to determine if there is a method set or not. *)
        methodSpecifiedQ = MatchQ[Lookup[options,Method], ObjectP[Object[Method]]];

        (* Pre-resolve options that do rely on the Methods *)
        {
          (*1*)liquidLiquidExtractionTechnique,
          (*2*)liquidLiquidExtractionDevice,
          (*3*)liquidLiquidExtractionSelectionStrategy,
          (*4*)aqueousSolvent,
          (*5*)aqueousSolventRatio,
          (*6*)organicSolventRatio,
          (*7*)liquidLiquidExtractionTargetLayer,
          (*8*)liquidLiquidExtractionSolventAdditions,
          (*9*)demulsifier,
          (*10*)demulsifierAdditions,
          (*11*)liquidLiquidExtractionCentrifuge,
          (*12*)liquidLiquidExtractionCentrifugeIntensity,
          (*13*)liquidLiquidExtractionCentrifugeTime
        } = Map[
          simplePreResolveOption[#, options, methodPacket, methodSpecifiedQ, lleUsedQ]&,
          {
            (*1*)LiquidLiquidExtractionTechnique,
            (*2*)LiquidLiquidExtractionDevice,
            (*3*)LiquidLiquidExtractionSelectionStrategy,
            (*4*)AqueousSolvent,
            (*5*)AqueousSolventRatio,
            (*6*)OrganicSolventRatio,
            (*7*)LiquidLiquidExtractionTargetLayer,
            (*8*)LiquidLiquidExtractionSolventAdditions,
            (*9*)Demulsifier,
            (*10*)DemulsifierAdditions,
            (*11*)LiquidLiquidExtractionCentrifuge,
            (*12*)LiquidLiquidExtractionCentrifugeIntensity,
            (*13*)LiquidLiquidExtractionCentrifugeTime
          }
        ];

        (* Resolve the LiquidLiquidExtractionTargetPhase.*)
        liquidLiquidExtractionTargetPhase = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, LiquidLiquidExtractionTargetPhase], Except[Automatic]],
            Lookup[options, LiquidLiquidExtractionTargetPhase],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, LiquidLiquidExtractionTargetPhase], Except[Null]],
            Lookup[methodPacket, LiquidLiquidExtractionTargetPhase],
          (*If LLE is not used and the option is not specified, it is set to Null.*)
          !lleUsedQ,
            Null,
          (*Otherwise, set to Automatic to be resolved in the LLE resolver.*)
          True,
            Aqueous
        ];

        (* Resolve the NumberOfLiquidLiquidExtractions.*)
        numberOfLiquidLiquidExtractions = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NumberOfLiquidLiquidExtractions], Except[Automatic]],
           Lookup[options, NumberOfLiquidLiquidExtractions],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NumberOfLiquidLiquidExtractions], Except[Null]],
            Lookup[methodPacket, NumberOfLiquidLiquidExtractions],
          (*If LLE is not used and the option is not specified, it is set to Null.*)
          !lleUsedQ,
           Null,
          (*Otherwise, set to the default of 3.*)
          True,
            3
        ];

        (* Resolve the OrganicSolvent.*)
        organicSolvent = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, OrganicSolvent], Except[Automatic]],
            Lookup[options, OrganicSolvent],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, OrganicSolvent], Except[Null]],
            Lookup[methodPacket, OrganicSolvent],
          (*If LLE is not used and the option is not specified, it is set to Null.*)
          !lleUsedQ,
           Null,
          (*If options are set that imply use of organic solvent, then phenol:chloroform mixture is used.*)
          Or[
            MatchQ[Lookup[options,OrganicSolventVolume],Except[Automatic|Null]],
            MatchQ[Lookup[options,OrganicSolventRatio],Except[Automatic|Null]],
            MatchQ[numberOfLiquidLiquidExtractions, GreaterP[1]] && MatchQ[liquidLiquidExtractionSelectionStrategy, Positive] && MatchQ[liquidLiquidExtractionTargetPhase, Organic],
            MatchQ[numberOfLiquidLiquidExtractions, GreaterP[1]] && MatchQ[liquidLiquidExtractionSelectionStrategy, Negative] && MatchQ[liquidLiquidExtractionTargetPhase, Aqueous]
          ],
            Model[Sample, "id:vXl9j5lWlb7e"], (*Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]*)
          (*Otherwise, set to Automatic and will be resolved by LLE option resolver later.*)
          True,
            Automatic
        ];

        (* Resolve the LiquidLiquidExtractionTemperature.*)
        liquidLiquidExtractionTemperature = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, LiquidLiquidExtractionTemperature], Except[Automatic]],
            Lookup[options, LiquidLiquidExtractionTemperature],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, LiquidLiquidExtractionTemperature], Except[Null]],
            Lookup[methodPacket, LiquidLiquidExtractionTemperature],
          (*If LLE is not used and the option is not specified, it is set to Null.*)
          !lleUsedQ,
            Null,
          (*Otherwise, set to the default of Ambient.*)
          True,
            Ambient
        ];

        (* Resolve the liquid-liquid extraction mix options.*)
        liquidLiquidExtractionMixOptions = preResolveExtractMixOptions[
          options,
          methodPacket,
          lleUsedQ,
          {
            MixType -> LiquidLiquidExtractionMixType,
            MixRate -> LiquidLiquidExtractionMixRate,
            MixTime -> LiquidLiquidExtractionMixTime,
            NumberOfMixes -> NumberOfLiquidLiquidExtractionMixes
          }
        ];

        (*Assign the resolved liquid-liquid extraction mix options to their local variables.*)
        {
          liquidLiquidExtractionMixType,
          liquidLiquidExtractionMixRate,
          liquidLiquidExtractionMixTime,
          numberOfLiquidLiquidExtractionMixes
        } = Map[
          Lookup[liquidLiquidExtractionMixOptions,#]&,
          {
            LiquidLiquidExtractionMixType,
            LiquidLiquidExtractionMixRate,
            LiquidLiquidExtractionMixTime,
            NumberOfLiquidLiquidExtractionMixes
          }
        ];

        (* Resolve the LiquidLiquidExtractionSettlingTime.*)
        liquidLiquidExtractionSettlingTime = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, LiquidLiquidExtractionSettlingTime], Except[Automatic]],
            Lookup[options, LiquidLiquidExtractionSettlingTime],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, LiquidLiquidExtractionSettlingTime], Except[Null]],
            Lookup[methodPacket, LiquidLiquidExtractionSettlingTime],
          (*If LLE is not used and the option is not specified, it is set to Null.*)
          !lleUsedQ,
            Null,
          (*Otherwise, set to the default of 1 Minute.*)
          True,
            1*Minute
        ];

        (* Resolve the ImpurityLayerStorageCondition.*)
        (* NOTE:Needs to be resolved in MapThread because default is technically Null while for plasmid it's Disposal.*)
        impurityLayerStorageCondition = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, ImpurityLayerStorageCondition], Except[Automatic]],
            Lookup[options, ImpurityLayerStorageCondition],
          (*If LLE is not used and the option is not specified, it is set to Null.*)
          !lleUsedQ,
            Null,
          (*Otherwise, set to the default of Disposal.*)
          True,
            Disposal
        ];

        {
          liquidLiquidExtractionTechnique,
          liquidLiquidExtractionDevice,
          liquidLiquidExtractionSelectionStrategy,
          liquidLiquidExtractionTargetPhase,
          liquidLiquidExtractionTargetLayer,
          aqueousSolvent,
          aqueousSolventRatio,
          organicSolvent,
          organicSolventRatio,
          liquidLiquidExtractionSolventAdditions,
          demulsifier,
          demulsifierAdditions,
          liquidLiquidExtractionTemperature,
          numberOfLiquidLiquidExtractions,
          liquidLiquidExtractionMixType,
          liquidLiquidExtractionMixTime,
          liquidLiquidExtractionMixRate,
          numberOfLiquidLiquidExtractionMixes,
          liquidLiquidExtractionSettlingTime,
          liquidLiquidExtractionCentrifuge,
          liquidLiquidExtractionCentrifugeIntensity,
          liquidLiquidExtractionCentrifugeTime,
          impurityLayerStorageCondition
        }
      ]
    ],
    {myMapThreadOptions, methodPackets}
  ];

  (* Return the pre-resolved LLE options. *)
  {
    LiquidLiquidExtractionTechnique -> preResolvedLiquidLiquidExtractionTechnique,
    LiquidLiquidExtractionDevice -> preResolvedLiquidLiquidExtractionDevice,
    LiquidLiquidExtractionSelectionStrategy -> preResolvedLiquidLiquidExtractionSelectionStrategy,
    IncludeLiquidBoundary -> Lookup[myOptions, IncludeLiquidBoundary],
    LiquidLiquidExtractionTargetPhase -> preResolvedLiquidLiquidExtractionTargetPhase,
    LiquidLiquidExtractionTargetLayer -> preResolvedLiquidLiquidExtractionTargetLayer,
    LiquidLiquidExtractionContainer -> Lookup[myOptions, LiquidLiquidExtractionContainer],
    LiquidLiquidExtractionContainerWell -> Lookup[myOptions, LiquidLiquidExtractionContainerWell],
    AqueousSolvent -> preResolvedAqueousSolvent,
    AqueousSolventRatio -> preResolvedAqueousSolventRatio,
    AqueousSolventVolume -> Lookup[myOptions, AqueousSolventVolume],
    OrganicSolvent -> preResolvedOrganicSolvent,
    OrganicSolventRatio -> preResolvedOrganicSolventRatio,
    OrganicSolventVolume -> Lookup[myOptions, OrganicSolventVolume],
    LiquidLiquidExtractionSolventAdditions -> preResolvedLiquidLiquidExtractionSolventAdditions,
    Demulsifier -> preResolvedDemulsifier,
    DemulsifierAmount -> Lookup[myOptions, DemulsifierAmount],
    DemulsifierAdditions -> preResolvedDemulsifierAdditions,
    LiquidLiquidExtractionTemperature -> preResolvedLiquidLiquidExtractionTemperature,
    NumberOfLiquidLiquidExtractions -> preResolvedNumberOfLiquidLiquidExtractions,
    LiquidLiquidExtractionMixType -> preResolvedLiquidLiquidExtractionMixType,
    LiquidLiquidExtractionMixTime -> preResolvedLiquidLiquidExtractionMixTime,
    LiquidLiquidExtractionMixRate -> preResolvedLiquidLiquidExtractionMixRate,
    NumberOfLiquidLiquidExtractionMixes -> preResolvedNumberOfLiquidLiquidExtractionMixes,
    LiquidLiquidExtractionMixVolume -> Lookup[myOptions, LiquidLiquidExtractionMixVolume],
    LiquidLiquidExtractionSettlingTime -> preResolvedLiquidLiquidExtractionSettlingTime,
    LiquidLiquidExtractionCentrifuge -> preResolvedLiquidLiquidExtractionCentrifuge,
    LiquidLiquidExtractionCentrifugeInstrument -> Lookup[myOptions, LiquidLiquidExtractionCentrifugeInstrument],
    LiquidLiquidExtractionCentrifugeIntensity -> preResolvedLiquidLiquidExtractionCentrifugeIntensity,
    LiquidLiquidExtractionCentrifugeTime -> preResolvedLiquidLiquidExtractionCentrifugeTime,
    LiquidBoundaryVolume -> Lookup[myOptions, LiquidBoundaryVolume],
    LiquidLiquidExtractionTransferLayer -> Lookup[myOptions, LiquidLiquidExtractionTransferLayer],
    ImpurityLayerStorageCondition -> preResolvedImpurityLayerStorageCondition,
    ImpurityLayerContainerOut -> Lookup[myOptions, ImpurityLayerContainerOut],
    ImpurityLayerContainerOutWell -> Lookup[myOptions, ImpurityLayerContainerOutWell],
    ImpurityLayerLabel -> Lookup[myOptions, ImpurityLayerLabel],
    ImpurityLayerContainerLabel -> Lookup[myOptions, ImpurityLayerContainerLabel]
  }

];


(* ::Subsection:: *)
(* liquidLiquidExtractionSharedOptionsTests *)

Warning::LiquidLiquidExtractionSelectionStrategyNotNeeded = "The sample(s), `1`, at indices, `3`, have a selection strategy specified, `2`, even though there is only one round of liquid-liquid extraction. The specified strategy (LiquidLiquidExtractionSelectionStrategy) is not needed if there is only one round of liquid-liquid extraction. Increase the number of liquid-liquid extraction rounds (NumberOfLiquidLiquidExtractions) to 2 or more to implement the specified selection strategy.";
Error::AqueousSolventOptionsMismatched = "The sample(s), `1`, at indices, `3`, have a mix of specified and unspecified aqueous solvent options, `2`. Aqueous solvent options (AqueousSolvent, AqueousSolventVolume, AqueousSolventRatio) must either all be specified (set to values) or all be unspecified (Null or None) to submit a valid experiment.";
Error::OrganicSolventOptionsMismatched = "The sample(s), `1`, at indices, `3`, have a mix of specified and unspecified organic solvent options, `2`. Organic solvent options (OrganicSolvent, OrganicSolventVolume, OrganicSolventRatio) must either all be specified (set to values) or all be unspecified (Null or None) to submit a valid experiment.";
Error::DemulsifierOptionsMismatched = "The sample(s), `1`, at indices, `3`, have a mix of specified and unspecified organic solvent options, `2`. Demulsifier options (Demulsifier, DemulsifierAmount, DemulsifierAdditions) must either all be specified (set to values) or all be unspecified (Null) to submit a valid experiment.";

DefineOptions[
  liquidLiquidExtractionSharedOptionsTests,
  Options:>{CacheOption}
];

liquidLiquidExtractionSharedOptionsTests[mySamples:{ObjectP[Object[Sample]]...}, mySamplePackets:{PacketP[Object[Sample]]...}, myResolvedOptions:{_Rule...}, gatherTestsQ:BooleanP, myResolutionOptions:OptionsPattern[liquidLiquidExtractionSharedOptionsTests]] := Module[
  {safeOps, cache, messages, resolvedPurification, resolvedLiquidLiquidExtractionTechnique, resolvedLiquidLiquidExtractionDevice, resolvedLiquidLiquidExtractionSelectionStrategy, resolvedIncludeLiquidBoundary, resolvedLiquidLiquidExtractionTargetPhase, resolvedLiquidLiquidExtractionTargetLayer, resolvedLiquidLiquidExtractionContainer, resolvedLiquidLiquidExtractionContainerWell, resolvedAqueousSolvent, resolvedAqueousSolventVolume, resolvedAqueousSolventRatio, resolvedOrganicSolvent, resolvedOrganicSolventVolume, resolvedOrganicSolventRatio, resolvedLiquidLiquidExtractionSolventAdditions, resolvedDemulsifier, resolvedDemulsifierAmount, resolvedDemulsifierAdditions, resolvedLiquidLiquidExtractionTemperature, resolvedNumberOfLiquidLiquidExtractions, resolvedLiquidLiquidExtractionMixType, resolvedLiquidLiquidExtractionMixTime, resolvedLiquidLiquidExtractionMixRate, resolvedNumberOfLiquidLiquidExtractionMixes, resolvedLiquidLiquidExtractionMixVolume, resolvedLiquidLiquidExtractionSettlingTime, resolvedLiquidLiquidExtractionCentrifuge, resolvedLiquidLiquidExtractionCentrifugeInstrument, resolvedLiquidLiquidExtractionCentrifugeIntensity, resolvedLiquidLiquidExtractionCentrifugeTime, resolvedLiquidBoundaryVolume, resolvedLiquidLiquidExtractionTransferLayer, resolvedImpurityLayerStorageCondition, resolvedImpurityLayerContainerOut, resolvedImpurityLayerContainerOutWell, resolvedImpurityLayerLabel, resolvedImpurityLayerContainerLabel, liquidLiquidExtractionSelectionStrategyMismatchedOptions, liquidLiquidExtractionSelectionStrategyTest, aqueousSolventMismatchedOptions, aqueousSolventOptionsTest, aqueousSolventAmountTest, organicSolventMismatchedOptions, organicSolventOptionsTest, organicSolventAmountTest, demulsifierMismatchedOptions, demulsifierOptionsTest, lleInvalidOptions},

  (*Pull out the safe options.*)
  safeOps = SafeOptions[liquidLiquidExtractionSharedOptionsTests, ToList[myResolutionOptions]];

  (* Lookup our cache and simulation. *)
  cache = Lookup[ToList[safeOps], Cache, {}];

  (* Determine if we should keep a running list of tests (Output contains Test). *)
  messages = !gatherTestsQ;

  (*Pull out resolved LLE Options.*)
  {
    resolvedPurification,
    resolvedLiquidLiquidExtractionTechnique,
    resolvedLiquidLiquidExtractionDevice,
    resolvedLiquidLiquidExtractionSelectionStrategy,
    resolvedIncludeLiquidBoundary,
    resolvedLiquidLiquidExtractionTargetPhase,
    resolvedLiquidLiquidExtractionTargetLayer,
    resolvedLiquidLiquidExtractionContainer,
    resolvedLiquidLiquidExtractionContainerWell,
    resolvedAqueousSolvent,
    resolvedAqueousSolventVolume,
    resolvedAqueousSolventRatio,
    resolvedOrganicSolvent,
    resolvedOrganicSolventVolume,
    resolvedOrganicSolventRatio,
    resolvedLiquidLiquidExtractionSolventAdditions,
    resolvedDemulsifier,
    resolvedDemulsifierAmount,
    resolvedDemulsifierAdditions,
    resolvedLiquidLiquidExtractionTemperature,
    resolvedNumberOfLiquidLiquidExtractions,
    resolvedLiquidLiquidExtractionMixType,
    resolvedLiquidLiquidExtractionMixTime,
    resolvedLiquidLiquidExtractionMixRate,
    resolvedNumberOfLiquidLiquidExtractionMixes,
    resolvedLiquidLiquidExtractionMixVolume,
    resolvedLiquidLiquidExtractionSettlingTime,
    resolvedLiquidLiquidExtractionCentrifuge,
    resolvedLiquidLiquidExtractionCentrifugeInstrument,
    resolvedLiquidLiquidExtractionCentrifugeIntensity,
    resolvedLiquidLiquidExtractionCentrifugeTime,
    resolvedLiquidBoundaryVolume,
    resolvedLiquidLiquidExtractionTransferLayer,
    resolvedImpurityLayerStorageCondition,
    resolvedImpurityLayerContainerOut,
    resolvedImpurityLayerContainerOutWell,
    resolvedImpurityLayerLabel,
    resolvedImpurityLayerContainerLabel
  } = Map[
    Lookup[myResolvedOptions, #]&,
    {
      Purification,
      LiquidLiquidExtractionTechnique,
      LiquidLiquidExtractionDevice,
      LiquidLiquidExtractionSelectionStrategy,
      IncludeLiquidBoundary,
      LiquidLiquidExtractionTargetPhase,
      LiquidLiquidExtractionTargetLayer,
      LiquidLiquidExtractionContainer,
      LiquidLiquidExtractionContainerWell,
      AqueousSolvent,
      AqueousSolventVolume,
      AqueousSolventRatio,
      OrganicSolvent,
      OrganicSolventVolume,
      OrganicSolventRatio,
      LiquidLiquidExtractionSolventAdditions,
      Demulsifier,
      DemulsifierAmount,
      DemulsifierAdditions,
      LiquidLiquidExtractionTemperature,
      NumberOfLiquidLiquidExtractions,
      LiquidLiquidExtractionMixType,
      LiquidLiquidExtractionMixTime,
      LiquidLiquidExtractionMixRate,
      NumberOfLiquidLiquidExtractionMixes,
      LiquidLiquidExtractionMixVolume,
      LiquidLiquidExtractionSettlingTime,
      LiquidLiquidExtractionCentrifuge,
      LiquidLiquidExtractionCentrifugeInstrument,
      LiquidLiquidExtractionCentrifugeIntensity,
      LiquidLiquidExtractionCentrifugeTime,
      LiquidBoundaryVolume,
      LiquidLiquidExtractionTransferLayer,
      ImpurityLayerStorageCondition,
      ImpurityLayerContainerOut,
      ImpurityLayerContainerOutWell,
      ImpurityLayerLabel,
      ImpurityLayerContainerLabel
    }
  ];

  (* --- Liquid-liquid Extraction Conflicting Options --- *)

  (* ---- liquidLiquidExtractionSelectionStrategyTest --- *)

  (*Checks if a selection strategy is only used if there is more than 1 round of LLE.*)
  liquidLiquidExtractionSelectionStrategyMismatchedOptions = MapThread[
    Function[{sample, liquidLiquidExtractionSelectionStrategy, numberOfLiquidLiquidExtractions, index},
      If[
        (numberOfLiquidLiquidExtractions==1) && MatchQ[liquidLiquidExtractionSelectionStrategy, Except[Null]],
        {
          sample,
          liquidLiquidExtractionSelectionStrategy,
          index
        },
        Nothing
      ]
    ],
    {mySamples, resolvedLiquidLiquidExtractionSelectionStrategy, resolvedNumberOfLiquidLiquidExtractions, Range[Length[mySamples]]}
  ];

  If[Length[liquidLiquidExtractionSelectionStrategyMismatchedOptions]>0 && messages,
    Message[
      Warning::LiquidLiquidExtractionSelectionStrategyNotNeeded,
      ObjectToString[liquidLiquidExtractionSelectionStrategyMismatchedOptions[[All,1]], Cache -> cache],
      liquidLiquidExtractionSelectionStrategyMismatchedOptions[[All,2]],
      liquidLiquidExtractionSelectionStrategyMismatchedOptions[[All,3]]
    ];
  ];

  liquidLiquidExtractionSelectionStrategyTest=If[gatherTestsQ,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = liquidLiquidExtractionSelectionStrategyMismatchedOptions[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " do not have a specified selection strategy because they are only undergoing one round of liquid-liquid extraction:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " do not have a specified selection strategy because they are only undergoing one round of liquid-liquid extraction:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* ---- aqueousSolventOptionsTest --- *)

  (*Checks if some aqueous solvent options are set while others are not set. They either need to all be set, or none of them set. i.e. A user can't specify to use an aqueous solvent and how much to use, but also have a Null aqueous solvent ratio. A user is either using aqueous solvent, or not using it.*)
  aqueousSolventMismatchedOptions = MapThread[
    Function[{sample, aqueousSolvent, aqueousSolventVolume, aqueousSolventRatio, index},
      If[
        !(MatchQ[{aqueousSolvent, aqueousSolventVolume, aqueousSolventRatio},{(None|Null),Null,Null}] || MatchQ[{aqueousSolvent, aqueousSolventVolume, aqueousSolventRatio},{Except[None|Null]..}]),
        {
          sample,
          {aqueousSolvent, aqueousSolventVolume, aqueousSolventRatio},
          index
        },
        Nothing
      ]
    ],
    {mySamples, resolvedAqueousSolvent, resolvedAqueousSolventVolume, resolvedAqueousSolventRatio, Range[Length[mySamples]]}
  ];

  If[Length[aqueousSolventMismatchedOptions]>0 && messages,
    Message[
      Error::AqueousSolventOptionsMismatched,
      ObjectToString[aqueousSolventMismatchedOptions[[All,1]], Cache -> cache],
      aqueousSolventMismatchedOptions[[All,2]],
      aqueousSolventMismatchedOptions[[All,3]]
    ];
  ];

  aqueousSolventOptionsTest=If[gatherTestsQ,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = aqueousSolventMismatchedOptions[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " have either all aqueous solvent options specified or all aqueous solvent options unspecified:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " have either all aqueous solvent options specified or all aqueous solvent options unspecified:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* ---- organicSolventOptionsTest --- *)

  (*Checks if some organic solvent options are set while others are not set. They either need to all be set, or none of them set. i.e. A user can't specify to use an organic solvent and how much to use, but also have a Null organic solvent ratio. A user is either using organic solvent, or not using it.*)
  organicSolventMismatchedOptions = MapThread[
    Function[{sample, organicSolvent, organicSolventVolume, organicSolventRatio, index},
      If[
        !(MatchQ[{organicSolvent, organicSolventVolume, organicSolventRatio},{(None|Null),Null,Null}] || MatchQ[{organicSolvent, organicSolventVolume, organicSolventRatio},{Except[None|Null]..}]),
        {
          sample,
          {organicSolvent, organicSolventVolume, organicSolventRatio},
          index
        },
        Nothing
      ]
    ],
    {mySamples, resolvedOrganicSolvent, resolvedOrganicSolventVolume, resolvedOrganicSolventRatio, Range[Length[mySamples]]}
  ];

  If[Length[organicSolventMismatchedOptions]>0 && messages,
    Message[
      Error::OrganicSolventOptionsMismatched,
      ObjectToString[organicSolventMismatchedOptions[[All,1]], Cache -> cache],
      organicSolventMismatchedOptions[[All,2]],
      organicSolventMismatchedOptions[[All,3]]
    ];
  ];

  organicSolventOptionsTest=If[gatherTestsQ,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = organicSolventMismatchedOptions[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " have either all organic solvent options specified or all organic solvent options unspecified:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " have either all organic solvent options specified or all organic solvent options unspecified:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* ---- demulsifierOptionsTest --- *)

  (*Checks that an amount is set if demulsifier or demulsifier additions is set and vice versa.*)
  demulsifierMismatchedOptions = MapThread[
    Function[{sample, demulsifier, demulsifierAmount, demulsifierAdditions, index},
      If[
        MemberQ[{demulsifier, demulsifierAmount, demulsifierAdditions}, (None|Null|{None..})] && !MatchQ[{demulsifier, demulsifierAmount, demulsifierAdditions}, {(None|Null),(Null),(Null|{None..})}],
        {
          sample,
          {demulsifier, demulsifierAmount, demulsifierAdditions},
          index
        },
        Nothing
      ]
    ],
    {mySamples, resolvedDemulsifier, resolvedDemulsifierAmount, resolvedDemulsifierAdditions, Range[Length[mySamples]]}
  ];

  If[Length[demulsifierMismatchedOptions]>0 && messages,
    Message[
      Error::DemulsifierOptionsMismatched,
      ObjectToString[demulsifierMismatchedOptions[[All,1]], Cache -> cache],
      demulsifierMismatchedOptions[[All,2]],
      demulsifierMismatchedOptions[[All,3]]
    ];
  ];

  demulsifierOptionsTest=If[gatherTestsQ,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = demulsifierMismatchedOptions[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " have an organic solvent volume that matches the organic solvent ratio mathematically (OrganicSolventRatio = SampleVolume / OrganicSolventVolume):", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " have an organic solvent volume that matches the organic solvent ratio mathematically (OrganicSolventRatio = SampleVolume / OrganicSolventVolume):", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  lleInvalidOptions = {
    If[Length[aqueousSolventMismatchedOptions]>0,
      {AqueousSolvent, AqueousSolventVolume, AqueousSolventRatio},
      {}
    ],
    If[Length[organicSolventMismatchedOptions]>0,
      {OrganicSolvent, OrganicSolventVolume, OrganicSolventRatio},
      {}
    ],
    If[Length[demulsifierMismatchedOptions]>0,
      {Demulsifier, DemulsifierAmount, DemulsifierAdditions},
      {}
    ]
  };

  {
    {
      liquidLiquidExtractionSelectionStrategyTest,
      aqueousSolventOptionsTest,
      aqueousSolventAmountTest,
      organicSolventOptionsTest,
      organicSolventAmountTest,
      demulsifierOptionsTest
    },
    {
      lleInvalidOptions
    }
  }

];


(* ::Subsection::Closed:: *)
(*liquidLiquidExtractionSharedOptionsUnitTests*)

(* NOTE: Tests written with the assumption of 0.2 mL samples. *)
liquidLiquidExtractionSharedOptionsUnitTests[myFunction_Symbol, previouslyExtractedSampleInPlate: ObjectP[Object[Sample]], previouslyExtractedSampleInTube: ObjectP[Object[Sample]], previouslyExtractedBiphasicSample: ObjectP[Object[Sample]]] :=
    {

      (* Basic Example *)
      Example[{Basic, "Crude samples can be purified with liquid-liquid extraction:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> LiquidLiquidExtraction,
          Output->Result
        ],
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        TimeConstraint -> 1800
      ],

      (* - Liquid-liquid Extraction Options - *)

      (* -- LiquidLiquidExtractionTechnique Tests -- *)
      Example[{Options,LiquidLiquidExtractionTechnique, "If pipetting-specific options (IncludeLiquidBoundary or LiquidBoundaryVolume) are set for removing one layer from another, then pipetting is used for the liquid-liquid extraction technique:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidBoundaryVolume -> {5 Microliter, 5 Microliter, 5 Microliter},
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTechnique -> Pipette
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionTechnique, "If pipetting-specific options (IncludeLiquidBoundary or LiquidBoundaryVolume) are not set for removing one layer from another, then a phase separator is used for the liquid-liquid extraction technique:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> LiquidLiquidExtraction,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTechnique -> PhaseSeparator
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionDevice Tests --*)
      Example[{Options,LiquidLiquidExtractionDevice, "If pipetting is used as the technique for physically separating the different phases during the liquid-liquid extraction, then a phase separator is not specified (since a phase separator is not being used):"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTechnique -> Pipette,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionDevice -> Null
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionDevice, "If a phase separator is used as the technique for physically separating the different phases during the liquid-liquid extraction, then a standard phase separator (Model[Container,Plate,PhaseSeparator,\"Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits\"]) is selected for use:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTechnique -> PhaseSeparator,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionDevice -> ObjectP[Model[Container,Plate,PhaseSeparator,"Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits"]]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionSelectionStrategy -- *)
      Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If there is only one round of liquid-liquid extraction, then a selection strategy is not specified (since a selection strategy is only required for multiple extraction rounds):"},
        myFunction[
          previouslyExtractedSampleInPlate,
          NumberOfLiquidLiquidExtractions -> 1,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSelectionStrategy -> Null
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If the phase of the solvent being added for each liquid-liquid extraction round matches the target phase, then the selection strategy is positive:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTargetPhase -> Aqueous,
          AqueousSolvent -> Model[Sample, "Milli-Q water"],
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSelectionStrategy -> Positive
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If the phase of the solvent being added for each liquid-liquid extraction round does not match the target phase, then the selection strategy is negative:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTargetPhase -> Aqueous,
          AqueousSolvent -> None,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSelectionStrategy -> Negative
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If nothing else is specified, then the selection strategy is set to positive:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSelectionStrategy -> Positive
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- IncludeLiquidBoundary -- *)
      Example[{Options,IncludeLiquidBoundary, "If pipetting is used for physical separating the two phases after extraction, then the liquid boundary between the phases is not removed during each liquid-liquid extraction round:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTechnique -> Pipette,
          Output->Options
        ],
        KeyValuePattern[
          {
            IncludeLiquidBoundary -> {False, False, False}
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionTargetPhase -- *)
      Example[{Options,LiquidLiquidExtractionTargetPhase, "The target phase is selected based on the phase that the plasmid DNA is more likely to be found in based on the PredictDestinationPhase[...] function:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> LiquidLiquidExtraction,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTargetPhase -> Aqueous
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionTargetLayer -- *)
      Example[{Options,LiquidLiquidExtractionTargetLayer, "The target layer for each extraction round is calculated from the density of the sample's aqueous and organic layers (if present in the sample), the density of the AqueousSolvent and OrganicSolvent options (if specified), and the target phase:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTargetLayer -> {Top, Top, Top}
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is aqueous and the aqueous phase is less dense than the organic phase, then the target layer will be the top layer:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTargetPhase -> Aqueous,
          NumberOfLiquidLiquidExtractions -> 1,
          AqueousSolvent -> Model[Sample,"Milli-Q water"],
          OrganicSolvent -> Model[Sample,"Dichloromethane, Reagent Grade"],
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTargetLayer -> {Top}
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is aqueous and the aqueous phase is denser than the organic phase, then the target layer will be the bottom layer:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTechnique -> Pipette,
          LiquidLiquidExtractionTargetPhase -> Aqueous,
          NumberOfLiquidLiquidExtractions -> 1,
          AqueousSolvent -> Model[Sample,"Milli-Q water"],
          OrganicSolvent -> Model[Sample,"Ethyl acetate, HPLC Grade"],
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTargetLayer -> {Bottom}
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is organic and the aqueous phase is less dense than the organic phase, then the target layer will be the bottom layer:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTargetPhase -> Organic,
          NumberOfLiquidLiquidExtractions -> 1,
          AqueousSolvent -> Model[Sample,"Milli-Q water"],
          OrganicSolvent -> Model[Sample,"Dichloromethane, Reagent Grade"],
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTargetLayer -> {Bottom}
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is organic and the aqueous phase is denser than the organic phase, then the target layer will be the top layer:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTechnique -> Pipette,
          LiquidLiquidExtractionTargetPhase -> Organic,
          NumberOfLiquidLiquidExtractions -> 1,
          AqueousSolvent -> Model[Sample,"Milli-Q water"],
          OrganicSolvent -> Model[Sample,"Ethyl acetate, HPLC Grade"],
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTargetLayer -> {Top}
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionContainer -- *)
      Example[{Options,LiquidLiquidExtractionContainer, "If the sample is in a non-centrifuge-compatible container and centrifuging is specified, then the extraction container will be set to a centrifuge-compatible, 96-well 2mL deep well plate:"},
        myFunction[
          previouslyExtractedSampleInTube,
          LiquidLiquidExtractionCentrifuge -> True,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionContainer -> {1,ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
          }
        ],
        TimeConstraint -> 1800
      ],
      (* TODO::Resolutions below don't actually happen in ExperimentLLE currently. Will add back in when there is a fix. *)
      (*Example[{Options,LiquidLiquidExtractionContainer, "If heating or cooling is specified, then the extraction container will be set to a 96-well 2mL deep well plate (since the robotic heater/cooler units are only compatible with Plate format containers):"},
        myFunction[
          previouslyExtractedSampleInTube,
          LiquidLiquidExtractionTemperature -> 90.0*Celsius,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionContainer -> {1,ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionContainer, "If the sample will not be centrifuged and the extraction will take place at ambient temperature, then the extraction container will be selected using the PreferredContainer function (to find a robotic-compatible container that will hold the sample):"},
        myFunction[
          previouslyExtractedSampleInTube,
          LiquidLiquidExtractionCentrifuge -> False,
          LiquidLiquidExtractionTemperature -> Ambient,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionContainer -> ObjectP[Model[Container]]
          }
        ],
        TimeConstraint -> 1800
      ],*)

      (* -- LiquidLiquidExtractionContainerWell -- *)
      Example[{Options,LiquidLiquidExtractionContainerWell, "If a liquid-liquid extraction container is specified, then the first available well in the container will be used by default:"},
        myFunction[
          previouslyExtractedSampleInTube,
          LiquidLiquidExtractionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionContainerWell -> "A1"
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- AqueousSolvent -- *)
      Example[{Options,AqueousSolvent, "If aqueous solvent is required for a separation, then water (Milli-Q water) will be used as the aqueous solvent:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          NumberOfLiquidLiquidExtractions -> 3,
          LiquidLiquidExtractionTargetPhase -> Aqueous,
          LiquidLiquidExtractionSelectionStrategy -> Positive,
          Output->Options
        ],
        KeyValuePattern[
          {
            AqueousSolvent -> ObjectP[Model[Sample, "Milli-Q water"]]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- AqueousSolventVolume -- *)
      Example[{Options,AqueousSolventVolume, "If an aqueous solvent ratio is set, then the aqueous solvent volume is calculated from the ratio and the sample volume (SampleVolume/AqueousSolventRatio):"},
        myFunction[
          previouslyExtractedSampleInPlate,
          AqueousSolventRatio -> 5,
          Output->Options
        ],
        KeyValuePattern[
          {
            AqueousSolventVolume -> EqualP[0.04*Milliliter]
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,AqueousSolventVolume, "If an aqueous solvent is set, then the aqueous solvent volume will be 20% of the sample volume:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          AqueousSolvent -> Model[Sample, "Milli-Q water"],
          Output->Options
        ],
        KeyValuePattern[
          {
            AqueousSolventVolume -> EqualP[0.04*Milliliter]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- AqueousSolventRatio -- *)
      Example[{Options,AqueousSolventRatio, "If an aqueous solvent volume is set, then the aqueous solvent ratio is calculated from the set aqueous solvent volume and the sample volume (SampleVolume/AqueousSolventVolume):"},
        myFunction[
          previouslyExtractedSampleInPlate,
          AqueousSolventVolume -> 0.04*Milliliter,
          Output->Options
        ],
        KeyValuePattern[
          {
            AqueousSolventRatio -> EqualP[5.0]
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,AqueousSolventRatio, "If an aqueous solvent is set, then the aqueous solvent ratio is set to 5:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          AqueousSolvent -> Model[Sample, "Milli-Q water"],
          Output->Options
        ],
        KeyValuePattern[
          {
            AqueousSolventRatio -> EqualP[5.0]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- OrganicSolvent -- *)
      Example[{Options,OrganicSolvent, "If an organic solvent volume or organic solvent ratio are specified, then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          OrganicSolventRatio -> 5,
          Output->Options
        ],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]
          }
        ],
        TimeConstraint -> 1800
      ],
      Test[{"If an organic solvent volume or organic solvent ratio are specified, then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          OrganicSolventVolume -> 0.2*Milliliter,
          Output->Options
        ],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,OrganicSolvent, "If the target phase is set to Organic and the selection strategy is set to Positive (implying addition of organic solvent during later extraction rounds), then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTargetPhase -> Organic,
          LiquidLiquidExtractionSelectionStrategy -> Positive,
          Output->Options
        ],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,OrganicSolvent, "If the target phase is set to Aqueous and the selection strategy is set to Positive (implying addition of organic solvent during later extraction rounds), then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTargetPhase -> Aqueous,
          LiquidLiquidExtractionSelectionStrategy -> Negative,
          Output->Options
        ],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,OrganicSolvent, "If organic solvent is otherwise required for an extraction and a pipette will be used to physically separate the phases/layers (LiquidLiquidExtractionTechnique -> Pipette), then ethyl acetate (Model[Sample, \"Ethyl acetate, HPLC Grade\"]) will be used as the organic solvent:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTechnique -> Pipette,
          Output->Options
        ],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "Ethyl acetate, HPLC Grade"]]
          }
        ],
        TimeConstraint -> 1800
      ],
      (*FIXME::Refuses to use ethyl acetate as organic solvent for some reason even though absolute ethanol is less dense. Tracked it down to possible issue with PredictSolventPhase because it's saying sample in Ethanol is Unknown phase with no solvent nor density. Add back in when fix is determined.*)
      (*Example[{Options,OrganicSolvent, "If organic solvent is otherwise required for an extraction and a phase separator will be used to physically separate the phases/layers (LiquidLiquidExtractionTechnique -> PhaseSeparator), then ethyl acetate (Model[Sample, \"Ethyl acetate, HPLC Grade\"]) will be used as the organic solvent if it is denser than the aqueous phase, since the organic layer needs to be below the aqueous layer to pass through the hydrophobic frit:"},
        myFunction[
          Object[Sample, "Previously Extracted Plasmid DNA Sample in Ethanol (Test for ExperimentExtractPlasmidDNA) "<>$SessionUUID],
          LiquidLiquidExtractionTechnique -> PhaseSeparator,
          Output->Options
        ],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "Ethyl acetate, HPLC Grade"]]
          }
        ],
        TimeConstraint -> 1800
      ],*)
      Example[{Options,OrganicSolvent, "If organic solvent is otherwise required for an extraction and a phase separator will be used to physically separate the phases/layers (LiquidLiquidExtractionTechnique -> PhaseSeparator), Model[Sample, \"Chloroform\"] will be used if Model[Sample, \"Ethyl acetate, HPLC Grade\"] is not dense enough to be denser than the aqueous layer, since the organic layer needs to be below the aqueous layer to pass through the hydrophobic frit:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTechnique -> PhaseSeparator,
          Output->Options
        ],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "Chloroform"]]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- OrganicSolventVolume -- *)
      Example[{Options,OrganicSolventVolume, "If an organic solvent ratio is set, then the organic solvent volume is calculated from the ratio and the sample volume (SampleVolume/OrganicSolventRatio):"},
        myFunction[
          previouslyExtractedSampleInPlate,
          OrganicSolventRatio -> 5,
          Output->Options
        ],
        KeyValuePattern[
          {
            OrganicSolventVolume -> EqualP[0.04*Milliliter]
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,OrganicSolventVolume, "If an organic solvent is set, then the organic solvent volume will be 20% of the sample volume:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          OrganicSolvent -> Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"],
          Output->Options
        ],
        KeyValuePattern[
          {
            OrganicSolventVolume -> EqualP[0.04*Milliliter]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- OrganicSolventRatio -- *)
      Example[{Options,OrganicSolventRatio, "If an organic solvent volume is set, then the organic solvent ratio is calculated from the set organic solvent volume and the sample volume (SampleVolume/OrganicSolventVolume):"},
        myFunction[
          previouslyExtractedSampleInPlate,
          OrganicSolventVolume -> 0.04*Milliliter,
          Output->Options
        ],
        KeyValuePattern[
          {
            OrganicSolventRatio -> EqualP[5.0]
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,OrganicSolventRatio, "If an organic solvent is set, then the organic solvent ratio is set to 5:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          OrganicSolvent -> Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"],
          Output->Options
        ],
        KeyValuePattern[
          {
            OrganicSolventRatio -> EqualP[5.0]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionSolventAdditions -- *)
      Example[{Options,LiquidLiquidExtractionSolventAdditions, "If the starting sample of any extraction round is in an organic or unknown phase, then an aqueous solvent is added to that sample:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          NumberOfLiquidLiquidExtractions -> 3,
          LiquidLiquidExtractionTargetPhase -> Organic,
          LiquidLiquidExtractionSelectionStrategy -> Negative,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSolventAdditions -> {{ObjectP[], ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Milli-Q water"]]}}
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionSolventAdditions, "If the starting sample of any extraction round is in an aqueous phase, then organic solvent is added to that sample:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          NumberOfLiquidLiquidExtractions -> 3,
          LiquidLiquidExtractionTargetPhase -> Aqueous,
          LiquidLiquidExtractionSelectionStrategy -> Negative,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSolventAdditions -> {{ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]..}}
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionSolventAdditions, "If the starting sample of an extraction is biphasic, then no solvent is added for the first extraction:"},
        myFunction[
          previouslyExtractedBiphasicSample,
          LiquidLiquidExtractionTechnique -> Pipette,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSolventAdditions -> {None, ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Milli-Q water"]]}
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- Demulsifier -- *)
      Example[{Options,Demulsifier, "If the demulsifier additions are specified, then the specified demulsifier will be used:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          DemulsifierAdditions -> {Model[Sample, StockSolution, "5M Sodium Chloride"], None, None},
          Output->Options
        ],
        KeyValuePattern[
          {
            Demulsifier -> ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,Demulsifier, "If a demulsifier amount is specified, then a 5M sodium chloride solution will be used as the demulsifier:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          DemulsifierAmount -> 0.1*Milliliter,
          Output->Options
        ],
        KeyValuePattern[
          {
            Demulsifier -> ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,Demulsifier, "If no demulsifier options are specified, then a demulsifier is not used:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Output->Options
        ],
        KeyValuePattern[
          {
            Demulsifier -> None
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- DemulsifierAmount -- *)
      Example[{Options,DemulsifierAmount, "If demulsifier and/or demulsifier additions are specified, then the demulsifier amount is set to 10% of the sample volume:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
          Output->Options
        ],
        KeyValuePattern[
          {
            DemulsifierAmount -> EqualP[0.02*Milliliter]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- DemulsifierAdditions -- *)
      Example[{Options,DemulsifierAdditions, "If a demulsifier is not specified, then the demulsifier additions are set to None for each round:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> LiquidLiquidExtraction,
          Output->Options
        ],
        KeyValuePattern[
          {
            DemulsifierAdditions -> {None, None, None}
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,DemulsifierAdditions, "If there will only be one round of liquid-liquid extraction and a demulsifier is specified, then the demulsifier will be added for that one extraction round:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          NumberOfLiquidLiquidExtractions -> 1,
          Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
          Output->Options
        ],
        KeyValuePattern[
          {
            DemulsifierAdditions -> {ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]}
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,DemulsifierAdditions, "If there will be multiple rounds of liquid-liquid extraction, a demulsifier is specified, and the organic phase will be used in subsequent extraction rounds, then the demulsifier will be added for each extraction round (since the demulsifier will likely be removed with the aqueous phase each round):"},
        myFunction[
          previouslyExtractedSampleInPlate,
          NumberOfLiquidLiquidExtractions -> 3,
          Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
          LiquidLiquidExtractionTargetPhase -> Organic,
          LiquidLiquidExtractionSelectionStrategy -> Negative,
          Output->Options
        ],
        KeyValuePattern[
          {
            DemulsifierAdditions -> {ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]..}
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,DemulsifierAdditions, "If there will be multiple rounds of liquid-liquid extraction, a demulsifier is specified, and the aqueous phase will be used in subsequent extraction rounds, then the demulsifier will only be added for the first extraction round (since the demulsifier is usually a salt solution which stays in the aqueous phase):"},
        myFunction[
          previouslyExtractedSampleInPlate,
          NumberOfLiquidLiquidExtractions -> 3,
          Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
          LiquidLiquidExtractionTargetPhase -> Aqueous,
          LiquidLiquidExtractionSelectionStrategy -> Negative,
          Output->Options
        ],
        KeyValuePattern[
          {
            DemulsifierAdditions -> {ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]], None, None}
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionTemperature -- *)
      Example[{Options,LiquidLiquidExtractionTemperature, "If not specified by the user nor the method, the liquid-liquid extraction is carried out at ambient temperature by default:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> LiquidLiquidExtraction,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTemperature -> Ambient
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- NumberOfLiquidLiquidExtractions -- *)
      Example[{Options,NumberOfLiquidLiquidExtractions, "If not specified by the user nor the method, the number of liquid-liquid extraction is 3 by default:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> LiquidLiquidExtraction,
          Output->Options
        ],
        KeyValuePattern[
          {
            NumberOfLiquidLiquidExtractions -> 3
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionMixType -- *)
      Example[{Options,LiquidLiquidExtractionMixType, "If a mixing time or mixing rate for the liquid-liquid extraction is specified, then the sample will be shaken (since a mixing time or rate does not pertain to pipette mixing):"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionMixTime -> 1*Minute,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixType -> Shake
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionMixType, "If mixing options are not specified, then the sample will be mixed via pipetting:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> LiquidLiquidExtraction,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixType -> Pipette
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionMixTime -- *)
      Example[{Options,LiquidLiquidExtractionMixTime, "If the liquid-liquid extraction mixture will be mixed by shaking, then the mixing time is set to 30 seconds by default:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionMixType -> Shake,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixTime -> EqualP[30*Second]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionMixRate -- *)
      Example[{Options,LiquidLiquidExtractionMixRate, "If the liquid-liquid extraction mixture will be mixed by shaking, then the mixing rate is set to 300 RPM (revolutions per minute) by default:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionMixType -> Shake,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixRate -> EqualP[300 Revolution/Minute]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- NumberOfLiquidLiquidExtractionMixes -- *)
      Example[{Options,NumberOfLiquidLiquidExtractionMixes, "If the liquid-liquid extraction mixture will be mixed by pipette, then the number of mixes (number of times the liquid-liquid extraction mixture is pipetted up and down) is set to 10 by default:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionMixType -> Pipette,
          Output->Options
        ],
        KeyValuePattern[
          {
            NumberOfLiquidLiquidExtractionMixes -> 10
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionMixVolume -- *)
      Example[{Options,LiquidLiquidExtractionMixVolume, "If half of the liquid-liquid extraction mixture (the sample volume plus the entire volume of the added aqueous solvent, organic solvent, and demulsifier if specified) for each extraction is less than 970 microliters, then that volume will be used as the mixing volume for the pipette mixing:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionMixType -> Pipette,
          OrganicSolventVolume -> 0.2*Milliliter,
          NumberOfLiquidLiquidExtractions -> 1,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixVolume -> EqualP[0.2*Milliliter]
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionMixVolume, "If half of the liquid-liquid extraction mixture (the sample volume plus the entire volume of the added aqueous solvent, organic solvent, and demulsifier if specified) for each extraction is greater than 970 microliters, then 970 microliters (the maximum amount that can be mixed via pipette on the liquid handling robot) will be used as the mixing volume for the pipette mixing:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionMixType -> Pipette,
          LiquidLiquidExtractionSelectionStrategy -> Negative,
          OrganicSolventVolume -> 0.5*Milliliter,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixVolume -> EqualP[0.970*Milliliter]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionSettlingTime -- *)
      Example[{Options,LiquidLiquidExtractionSettlingTime, "If not specified by the user nor the method, the liquid-liquid extraction solution is allowed to settle for 1 minute by default:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> LiquidLiquidExtraction,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSettlingTime -> EqualP[1*Minute]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionCentrifuge -- *)
      Example[{Options,LiquidLiquidExtractionCentrifuge, "If any other centrifuging options are specified, then the liquid-liquid extraction solution will be centrifuged in order to separate the solvent phases:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionCentrifugeTime -> 1*Minute,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifuge -> True
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionCentrifuge, "If the separated solvent phases will be pysically separated with a pipette and the sample is in a centrifuge-compatible container, then the liquid-liquid extraction solution will be centrifuged in order to separate the solvent phases:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTechnique -> Pipette,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifuge -> True
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidLiquidExtractionCentrifuge, "If not specified by the user nor the method, the liquid-liquid extraction solution will not be centrifuged:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> LiquidLiquidExtraction,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifuge -> False
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionCentrifugeInstrument -- *)
      Example[{Options,LiquidLiquidExtractionCentrifugeInstrument, "If the liquid-liquid extraction solution will be centrifuged, then the integrated centrifuge model on the chosen robotic instrument will be automatically used:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          RoboticInstrument -> Object[Instrument, LiquidHandler, "id:WNa4ZjRr56bE"],
          LiquidLiquidExtractionCentrifuge -> True,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifugeInstrument -> ObjectP[Model[Instrument,Centrifuge,"HiG4"]]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionCentrifugeIntensity -- *)
      Example[{Options,LiquidLiquidExtractionCentrifugeIntensity, "If the liquid-liquid extraction solution will be centrifuged and the MaxIntensity of the centrifuge model is less than the MaxCentrifugationForce of the plate model (or the MaxCentrifugationForce of the plate model does not exist), the liquid-liquid extraction solution will be centrifuged at the MaxIntensity of the centrifuge model:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionCentrifugeInstrument -> Model[Instrument,Centrifuge,"HiG4"],
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifugeIntensity -> EqualP[3600 GravitationalAcceleration]
          }
        ],
        TimeConstraint -> 1800
      ],
      (*TODO:: Only 4 containers currently have a MaxCentrifugationForce and are not compatible with the HiG4, so the below is not currently a realistic case currently. Also, LLE resolves this based on the container it enters LLE and not the LLE container which needs to be fixed. *)
      (*Example[{Options,LiquidLiquidExtractionCentrifugeIntensity, "If the liquid-liquid extraction solution will be centrifuged and the MaxIntensity of the centrifuge model is greater than the MaxCentrifugationForce of the plate model, the liquid-liquid extraction solution will be centrifuged at the MaxCentrifugationForce of the plate model:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionContainer -> Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"],
          LiquidLiquidExtractionCentrifugeInstrument -> Model[Instrument,Centrifuge,"HiG4"],
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifugeIntensity -> EqualP[2851.5 RPM]
          }
        ],
        TimeConstraint -> 1800
      ],*)

      (* -- LiquidLiquidExtractionCentrifugeTime -- *)
      Example[{Options,LiquidLiquidExtractionCentrifugeTime, "If the liquid-liquid extraction solution will be centrifuged, the liquid-liquid extraction solution will be centrifuged for 2 minutes by default:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionCentrifuge -> True,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifugeTime -> EqualP[2*Minute]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidBoundaryVolume -- *)
      Example[{Options,LiquidBoundaryVolume, "If the two layers of the liquid-liquid extraction solution will be physically separated using a pipette and the top layer will be transferred, the volume of the boundary between the layers will be set to a 5 millimeter tall cross-section of the sample container at the location of the layer boundary for each extraction round:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTechnique -> Pipette,
          NumberOfLiquidLiquidExtractions -> 1,
          LiquidLiquidExtractionTransferLayer -> {Top},
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidBoundaryVolume -> {EqualP[0.02*Milliliter]}
          }
        ],
        TimeConstraint -> 1800
      ],
      Example[{Options,LiquidBoundaryVolume, "If the two layers of the liquid-liquid extraction solution will be physically separated using a pipette and the bottom layer will be transferred, the volume of the boundary between the layers will be set to a 5 millimeter tall cross-section of the bottom of the sample container for each extraction round:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTechnique -> Pipette,
          NumberOfLiquidLiquidExtractions -> 1,
          LiquidLiquidExtractionTransferLayer -> {Bottom},
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidBoundaryVolume -> {EqualP[0.02*Milliliter]}
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- LiquidLiquidExtractionTransferLayer -- *)
      Example[{Options,LiquidLiquidExtractionTransferLayer, "If the two layers of the liquid-liquid extraction solution will be physically separated using a pipette, the top layer will be removed from the bottom layer during each extraction round by default:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTechnique -> Pipette,
          Output->Options
        ],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTransferLayer -> {Top, Top, Top}
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- ImpurityLayerStorageCondition -- *)
      Example[{Options,ImpurityLayerStorageCondition, "ImpurityLayerStorageCondition is set to Disposal for each extraction round if not otherwise specified:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> LiquidLiquidExtraction,
          Output->Options
        ],
        KeyValuePattern[
          {
            ImpurityLayerStorageCondition -> Disposal
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- ImpurityLayerContainerOut -- *)
      (* TODO::Below resolution actually doesn't work. Will add back in when fixed. *)
      (*Example[{Options,ImpurityLayerContainerOut, "If LiquidLiquidExtractionTargetPhase is set to Aqueous and LiquidLiquidExtractionTechnique is set to PhaseSeparator, ImpurityLayerContainerOut is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionTargetPhase -> Aqueous,
          LiquidLiquidExtractionTechnique -> PhaseSeparator,
          Output->Options
        ],
        KeyValuePattern[
          {
            ImpurityLayerContainerOut -> ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]
          }
        ],
        TimeConstraint -> 1800
      ],*)
      Example[{Options,ImpurityLayerContainerOut, "If LiquidLiquidExtractionTargetPhase is not set to Aqueous or LiquidLiquidExtractionTechnique is not set to PhaseSeparator, ImpurityLayerContainerOut is automatically determined by the PreferredContainer function:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> LiquidLiquidExtraction,
          Output->Options
        ],
        KeyValuePattern[
          {
            ImpurityLayerContainerOut -> ObjectP[Model[Container]]
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- ImpurityLayerContainerOutWell -- *)
      Example[{Options,ImpurityLayerContainerOutWell, "ImpurityLayerContainerOutWell is automatically set tot he first empty well of the ImpurityLayerContainerOut:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> LiquidLiquidExtraction,
          ImpurityLayerContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
          Output->Options
        ],
        KeyValuePattern[
          {
            ImpurityLayerContainerOutWell -> "A1"
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- ImpurityLayerLabel -- *)
      Example[{Options,ImpurityLayerLabel, "ImpurityLayerLabel is automatically generated for the impurity layer sample:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> LiquidLiquidExtraction,
          Output->Options
        ],
        KeyValuePattern[
          {
            ImpurityLayerLabel -> (_String)
          }
        ],
        TimeConstraint -> 1800
      ],

      (* -- ImpurityLayerContainerLabel -- *)
      Example[{Options,ImpurityLayerContainerLabel, "ImpurityLayerContainerLabel is automatically generated for the impurity layer sample:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> LiquidLiquidExtraction,
          Output->Options
        ],
        KeyValuePattern[
          {
            ImpurityLayerContainerLabel -> (_String)
          }
        ],
        TimeConstraint -> 1800
      ],

      (* - Liquid-Liquid Extraction Errors - *)

      Example[{Messages, "LiquidLiquidExtractionOptionMismatch", "An error is returned if any liquid-liquid extraction options are set, but LiquidLiquidExtraction is not specified in Purification:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Purification -> {Precipitation},
          LiquidLiquidExtractionSettlingTime -> 1*Minute,
          Output->Result
        ],
        $Failed,
        Messages:>{
          Error::LiquidLiquidExtractionConflictingOptions,
          Error::InvalidOption
        },
        TimeConstraint -> 1800
      ],
      Example[{Messages, "LiquidLiquidExtractionSelectionStrategyOptionsMismatched", "A warning is returned if a selection strategy (LiquidLiquidExtractionSelectionStrategy) is specified, but there is only one liquid-liquid extraction round specified (NumberOfLiquidLiquidExtractions) since a selection strategy is only required for multiple rounds of liquid-liquid extraction:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          LiquidLiquidExtractionSelectionStrategy -> Positive,
          NumberOfLiquidLiquidExtractions -> 1,
          Output->Result
        ],
        $Failed,
        Messages:>{
          Warning::LiquidLiquidExtractionSelectionStrategyNotNeeded
        },
        TimeConstraint -> 1800
      ],
      Example[{Messages, "AqueousSolventOptionsMismatched", "An error is returned if there is a mix of specified and unspecified aqueous solvent options (AqueousSolvent, AqueousSolventVolume, AqueousSolventRatio) for a sample:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          AqueousSolventVolume -> 0.2*Milliliter,
          AqueousSolventRatio -> Null,
          Output->Result
        ],
        $Failed,
        Messages:>{
          Error::AqueousSolventOptionsMismatched,
          Error::InvalidOption
        },
        TimeConstraint -> 1800
      ],
      Example[{Messages, "OrganicSolventOptionsMismatched", "An error is returned if there is a mix of specified and unspecified organic solvent options (OrganicSolvent, OrganicSolventVolume, OrganicSolventRatio) for a sample:"},
        myFunction[
          previouslyExtractedSampleInPlate,
          OrganicSolventVolume -> 0.2*Milliliter,
          OrganicSolventRatio -> Null,
          Output->Result
        ],
        $Failed,
        Messages:>{
          Error::OrganicSolventOptionsMismatched,
          Error::InvalidOption
        },
        TimeConstraint -> 1800
      ],
      Example[{Messages, "DemulsifierOptionsMismatched", "An error is returned if there is a mix of specified and unspecified demulsifier options (Demulsifier, DemulsifierAmount, DemulsifierAdditions):"},
        myFunction[
          previouslyExtractedSampleInPlate,
          Demulsifier -> None,
          DemulsifierAmount -> 0.1*Milliliter,
          Output->Result
        ],
        $Failed,
        Messages:>{
          Error::DemulsifierOptionsMismatched,
          Error::InvalidOption
        },
        TimeConstraint -> 1800
      ]

    };


(* SOLVENT ADDITIONS CORRECTIONS *)

expandSolventAdditionsOption[mySamples_, options:{_Rule..}, expandedOptions:{_Rule..}, solventAdditionsExpression_, numberOfExtractionsExpression_] := Module[{},
  (* Correct expansion of SolventAdditions if not Automatic. *)
  (* NOTE:This is needed because SolventAdditions is not correctly expanded by ExpandIndexMatchedInputs. *)
  If[
    MatchQ[Lookup[options, solventAdditionsExpression],Except[ListableP[Automatic]]],
    Which[
      (* Correct input from LLE primitive (resolved, but put into extra list). *)
      And[
        MatchQ[Length[Lookup[options, solventAdditionsExpression]], 1],
        MatchQ[Length[Lookup[options, solventAdditionsExpression][[1]]], Length[ToList[mySamples]]],
        MatchQ[Map[Length, Lookup[options, solventAdditionsExpression][[1]]], Lookup[options, numberOfExtractionsExpression]]
      ],
      ReplaceRule[
        expandedOptions,
        solventAdditionsExpression -> Lookup[options, solventAdditionsExpression][[1]]
      ],
      (* If the length of SolventAdditions matches the number of samples, then it is correctly index matched and is used as-is. *)
      MatchQ[Length[Lookup[options, solventAdditionsExpression]], Length[ToList[mySamples]]] && MatchQ[Lookup[options, solventAdditionsExpression], {Except[ObjectP[]]..}],
      ReplaceRule[
        expandedOptions,
        solventAdditionsExpression -> Lookup[options, solventAdditionsExpression]
      ],
      (* If the length of SolventAdditions matches the NumberOfExtractions, then it is expanded to match the number of samples. *)
      MatchQ[Length[Lookup[options, solventAdditionsExpression]], Lookup[options, numberOfExtractionsExpression]],
      ReplaceRule[
        expandedOptions,
        solventAdditionsExpression -> ConstantArray[Lookup[options, solventAdditionsExpression], Length[ToList[mySamples]]]
      ],
      (* Otherwise, the option is used as-is. *)
      True,
      expandedOptions
    ],
    expandedOptions
  ]
];


mapThreadFriendlySolventAdditions[options:(_Association|{_Rule..}), mapThreadFriendlyOptions:{_Association..}, solventAdditionsExpression_] := Module[{},
  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  If[
    MatchQ[Lookup[options, solventAdditionsExpression], Except[ListableP[Automatic]]],
    Module[{solventAdditionsInput},

      solventAdditionsInput = Lookup[options, solventAdditionsExpression];

      MapThread[
        Function[{optionSet, index},
          Module[{},
            Merge[
              {
                optionSet,
                <|
                  solventAdditionsExpression -> solventAdditionsInput[[index]]
                |>
              },
              Last
            ]
          ]
        ],
        {mapThreadFriendlyOptions, ToList[Range[1, Length[mapThreadFriendlyOptions]]]}
      ]

    ],
    mapThreadFriendlyOptions
  ]
];