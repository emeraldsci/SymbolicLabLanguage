(* ::Package:: *)
 
(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Options and Messages*)


(* ::Subsubsection::Closed:: *)
(*Options*)

DefineOptions[ExperimentLiquidLiquidExtraction,
  Options:> {
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> ExtractionTechnique,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> ExtractionTechniqueP (* Pipette | PhaseSeparator *)
        ],
        Description -> "The method that is used to separate the aqueous and organic phase of a sample. The collection of the target phase occurs after the extraction solvent(s) and demulsifier (if specified) are added, the sample is mixed (optionally), allowed to settle for SettlingTime (for the organic and aqueous phases to separate), and centrifuged (optionally). Pipette uses a pipette to aspirate off either the aqueous or organic layer, optionally taking the boundary layer with it according to the IncludeBoundary and ExtractionBoundaryVolume options. PhaseSeparator uses a column with a hydrophobic frit, which allows the organic phase to pass freely through the frit, but physically blocks the aqueous phase from passing through. Note that when using a phase separator, the organic phase must be heavier than the aqueous phase in order for it to pass through the hydrophobic frit, otherwise, the separator will not occur.",
        ResolutionDescription -> "If the option ExtractionDevice is set, ExtractionTechnique is set to PhaseSeparator (this option only applies to the use of a phase separator). If the options IncludeBoundary or ExtractionBoundaryVolume are set, ExtractionTechnique is set to Pipette (these options only apply to the use of a pipette for separation). Otherwise, set to PhaseSeparator by default.",
        Category -> "General"
      },
      {
        OptionName -> ExtractionDevice,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{
            Model[Container, Plate, PhaseSeparator],
            Object[Container, Plate, PhaseSeparator]
          }]
        ],
        Description -> "The device which is used to physically separate the aqueous and organic phases.",
        ResolutionDescription -> "If ExtractionTechnique is set to PhaseSeparator, ExtractionDevice will be set to Model[Container, Plate, PhaseSeparator, \"Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits\"].",
        Category -> "General"
      },
      {
        OptionName -> SelectionStrategy,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> SelectionStrategyP
        ],
        Description -> "Indicates if additional rounds of extraction are performed on the impurity phase (Positive) or the TargetPhase (Negative). Positive selection is used when the goal is to extract the maximum amount of TargetAnalyte from the impurity phase (maximizing yield). Negative selection is used when the goal is to remove impurities that may still exist in the TargetPhase (maximizing purity).",
        ResolutionDescription -> "If NumberOfExtractions is set to 1, then set to Null (this option only applies if there are multiple rounds of extraction). If SolventAdditions or AqueousSolvent/OrganicSolvent is specified, then the solvent(s) specified are used to infer the SelectionStrategy (if the phase of the solvent being added matches TargetPhase, then SelectionStrategy is set to Positive (extraction is done on the impurity layer), otherwise SelectionStrategy is set to Negative). Otherwise, automatically set to Positive selection.",
        Category -> "General"
      },
      {
        OptionName -> IncludeBoundary,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Adder[
          Widget[
            Type -> Enumeration,
            Pattern :> BooleanP
          ]
        ],
        Description -> "Indicates if the boundary layer is aspirated along with the ExtractionTransferLayer. This option is only applicable when ExtractionTechnique is set to Pipette.",
        ResolutionDescription -> "Automatically set to False if ExtractionTechnique is set to Pipette. Otherwise, set to Null since IncludeBoundary does not apply when ExtractionTechnique is PhaseSeparator since the hydrophobic frit of the phase separator automatically will only allow the organic phase to pass through.",
        Category -> "General"
      },
      {
        OptionName -> TargetAnalyte,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[IdentityModelTypes],
          ObjectTypes -> IdentityModelTypes
        ],
        Description -> "The desired molecular entity that the extraction is designed to isolate.",
        ResolutionDescription -> "Automatically set to the value of Analytes field in the input sample, if the Analytes field is populated. Otherwise, set to the first element of the Composition field that's listed in terms of concentration (molarity) or mass concentration (grams/L). Otherwise, set to Null.",
        Category -> "General"
      },
      {
        OptionName -> SamplePhase,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> SamplePhaseP
        ],
        Description -> "Indicates the phase of the input sample before extraction has taken place. Aqueous means that the input sample is liquid and composed only of aqueous solvents. Organic means that the input sample is liquid and composed only of organic solvents. Biphasic means that the input sample is liquid and composed of both aqueous and organic solvents that are separated into two defined layers. Unknown means that the sample phase is unknown, which will result in both Aqueous and Organic solvents being added to the input sample.",
        ResolutionDescription -> "Automatically set according to the PredictSamplePhase[...] function which looks at the composition of the sample's Solvent field to predict the sample's phase. If there is not enough information about the input sample for PredictSamplePhase[...] to predict the input sample's phase, a warning will be thrown. For more information, please refer to the PredictSamplePhase help file.",
        Category -> "General"
      },
      {
        OptionName -> TargetPhase,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> TargetPhaseP
        ],
        Description -> "Indicates the phase that is collected during the extraction (and carried forward to further experiments as defined by the SamplesOut field), which is the liquid layer that contains more of the dissolved TargetAnalyte after the SettlingTime has elapsed and the phases are separated.",
        ResolutionDescription -> "Automatically set to the phase (Organic or Aqueous) that the TargetAnalyte is more likely to be present in after extraction according to the PredictDestinationPhase[...] function. If there is not enough information for PredictDestinationPhase[...] to predict the destination phase of the target molecule, a warning will be thrown and TargetPhase will default to Aqueous. For more information, please refer to the PredictDestinationPhase help file.",
        Category -> "General"
      },
      {
        OptionName -> TargetLayer,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Adder[
          Widget[
            Type -> Enumeration,
            Pattern :> TargetLayerP
          ]
        ],
        Description -> "Indicates if the target phase is the top layer or the bottom layer of the separated solution. Note that when performing multiple rounds of extraction (NumberOfExtractions), the composition of the Aqueous and Organic layers during the first round of extraction can differ from the rest of the extraction rounds. For example, if SamplePhase->Biphasic, TargetPhase->Organic, and SelectionStrategy->Positive, the original organic layer from the input sample will be extracted and in subsequent rounds of extraction, OrganicSolvent added to the Aqueous impurity layer to extract more TargetAnalyte (the specified OrganicSolvent option can differ from the density of the original sample's organic layer). This can result in TargetLayer being different during the first round of extraction compared to the rest of the extraction rounds.",
        ResolutionDescription -> "Automatically calculated from the density of the input sample's aqueous and organic layers (if present in the input sample), the density of the AqueousSolvent and OrganicSolvent options (if specified), and the TargetPhase option. If density information is missing for any of these previously mentioned samples/layers, a warning will be thrown and it will be assumed that the Aqueous layer is on Top (less dense) than the Organic layer. During the calculation of this option, it is assumed that the additional molecules from the input sample will not significantly affect the densities of the aqueous and organic layers. It is also assumed that the Aqueous and Organic layers are fully separated after each round of extraction.",
        Category -> "General"
      },

      {
        OptionName -> SampleVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Volume" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
            Units -> {Microliter, {Microliter, Milliliter}}
          ],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ]
        ],
        Description -> "The volume of the input sample that is aliquotted into the ExtractionContainer and the liquid liquid extraction is performed on.",
        ResolutionDescription -> "Automatically set to either half the volume of the ExtractionContainer or the Volume of the input sample, which ever is smaller, if ExtractionContainer is specified. Otherwise, is set to Null.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> ExtractionContainer,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Existing Container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Object[Container]]
          ],
          "New Container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[Container]]
          ],
          "New Container with Index" -> {
            "Index" -> Widget[
              Type -> Number,
              Pattern :> GreaterEqualP[1, 1]
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Model[Container]}]
            ]
          }
        ],
        Description -> "The container that the input sample that is aliquotted into, before the liquid liquid extraction is performed.",
        ResolutionDescription -> "Automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] if SampleVolume is set and the input sample is not in a centrifuge compatible container and Centrifugation is specified or if a non-Ambient Temperature is specified (the robotic heater/cooler units are only compatible with Plate format containers). Otherwise, if SampleVolume is set, PreferredContainer[...] is used to get a robotic compatible container that can hold the sample volume specified. Otherwise, set to Null.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> ExtractionContainerWell,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 96]],
          PatternTooltip -> "Enumeration must be any well from A1 to H12."
        ],
        Description -> "The well of the container that the input sample that is aliquotted into, before the liquid liquid extraction is performed.",
        ResolutionDescription -> "Automatically set to the first empty position in the ExtractionContainer, if specified. Otherwise, set to Null.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> AddAqueousSolvent,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> Alternatives[First, All, Rest, False]
        ],
        Description -> "Indicates if the Aqueous solvent is added during the First extraction, All extractions, or the Rest (all except the first) extractions. Aqueous solvent only needs to be added to the starting sample for each extraction round if that starting sample is in Organic or Unknown solvent.",
        ResolutionDescription ->"Automatically set to First if NumberOfExtractions = 1 and the input sample is in Organic or Unknown solvent. Set to False if the input sample is Aqueous or Biphasic and NumberOfExtractions = 1. If the input sample and the starting sample to each round of extraction are in Organic or Unknown solvent, AddAqueousSolvent is set to All. If the input sample is in Aqueous solvent or is Biphasic but the rest of the starting samples to the second round of extraction and higher are in Organic solvent, AddAqueousSolvent is set to Rest. This can occur when the input sample is in Aqueous solvent but TargetPhase is Aqueous (so after the input sample, the next extraction phases will have samples that all start in Organic solvent).",
        Category -> "Hidden"
      },
      {
        OptionName -> AqueousSolvent,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Alternatives[
          Widget[
            Type -> Object,
            Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
            OpenPaths -> {
              {
                Object[Catalog, "Root"],
                "Materials",
                "Reagents",
                "Solvents"
              }
            }
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[None]
          ]
        ],
        Description -> "The aqueous solvent that is added to the input sample (or the impurity layer from the previous extraction round if NumberOfExtractions > 1) in order to create an organic and aqueous phase.",
        ResolutionDescription -> "If Aqueous solvent is required for the extraction, Model[Sample, \"Milli-Q water\"] is used as the AqueousSolvent. Otherwise, set to None.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> AqueousSolventVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
          Units -> {Microliter, {Microliter, Milliliter}}
        ],
        Description -> "The volume of aqueous solvent that is added and mixed with the sample during each extraction.",
        ResolutionDescription -> "If AqueousSolventRatio is set, AqueousSolventVolume is calculated by multiplying 1/AqueousSolventRatio with the sample volume. Otherwise, if AqueousSolvent is set, set to 20% of the volume of the sample being extracted.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> AqueousSolventRatio,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Number,
          Pattern :> GreaterP[0]
        ],
        Description -> "The ratio of the sample volume to the volume of aqueous solvent that is added to the sample.",
        ResolutionDescription -> "If AqueousSolventVolume is set, AqueousSolventRatio is calculated by dividing the sample volume by AqueousSolventVolume. Otherwise, if AqueousSolvent is set, set to 5.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> AddOrganicSolvent,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> Alternatives[First, All, Rest, False]
        ],
        Description -> "Indicates if the Organic solvent is added during the First extraction, All extractions, or the Rest (all except the first) extractions. Organic solvent only needs to be added to the starting sample for each extraction round if that starting sample is in Aqueous or Unknown solvent.",
        ResolutionDescription ->"Automatically set to First if NumberOfExtractions = 1 and the input sample is in Aqueous or Unknown solvent. Set to False if the input sample is Organic or Biphasic and NumberOfExtractions = 1. If the input sample and the starting sample to each round of extraction are in Aqueous or Unknown solvent, AddOrganicSolvent is set to All. If the input sample is in Organic solvent or is Biphasic but the rest of the starting samples to the second round of extraction and higher are in Aqueous solvent, AddOrganicSolvent is set to Rest. This can occur when the input sample is in Organic solvent but TargetPhase is Organic (so after the input sample, the next extraction phases will have samples that all start in Aqueous solvent).",
        Category -> "Hidden"
      },
      {
        OptionName -> OrganicSolvent,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Alternatives[
          Widget[
            Type -> Object,
            Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
            OpenPaths -> {
              {
                Object[Catalog, "Root"],
                "Materials",
                "Reagents",
                "Solvents"
              }
            }
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[None]
          ]
        ],
        Description -> "The organic solvent that is added to the input sample (or the impurity layer from the previous extraction round if NumberOfExtractions > 1) in order to create an organic and aqueous phase.",
        ResolutionDescription -> "If Organic solvent is required for the extraction and ExtractionTechnique is Pipette, Model[Sample, \"Ethyl acetate, HPLC Grade\"] is used as the OrganicSolvent. If Organic solvent is required for the extraction and ExtractionTechnique is PhaseSeparator, Model[Sample, \"Ethyl acetate, HPLC Grade\"] is used as the OrganicSolvent if it denser than the sample's Aqueous phase and the AqueousSolvent (if specified) since the phase separator will only be able to let the Organic layer pass through the hydrophobic frit if it is on the bottom. If Ethyl Acetate is not dense enough, Model[Sample, \"Chloroform\"] will be used. Otherwise, set to None.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> OrganicSolventVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
          Units -> {Microliter, {Microliter, Milliliter}}
        ],
        Description -> "The volume of organic solvent that is added and mixed with the sample during each extraction.",
        ResolutionDescription -> "If OrganicSolventRatio is set, OrganicSolventVolume is calculated by multiplying 1/OrganicSolventRatio with the sample volume. Otherwise, if OrganicSolvent is set, set to 20% of the volume of the sample being extracted.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> OrganicSolventRatio,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Number,
          Pattern :> GreaterP[0]
        ],
        Description -> "The ratio of the sample volume to the volume of orgnanic solvent that is added to the sample.",
        ResolutionDescription -> "If OrganicSolventVolume is set, OrganicSolventRatio is calculated by dividing the sample volume by OrganicSolventVolume. Otherwise, if OrganicSolvent is set, set to 5.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> SolventAdditions,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Adder[
          Alternatives[
            "Single Solvent" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
              OpenPaths -> {
                {
                  Object[Catalog, "Root"],
                  "Materials",
                  "Reagents",
                  "Solvents"
                }
              }
            ],
            "Multiple Solvents" -> Adder[
              Widget[
                Type -> Object,
                Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
                OpenPaths -> {
                  {
                    Object[Catalog, "Root"],
                    "Materials",
                    "Reagents",
                    "Solvents"
                  }
                }
              ]
            ],
            "No Solvent" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives[None]
            ]
          ]
        ],
        Description -> "For each extraction round, the solvent(s) that are added to the sample in order to create a biphasic solution.",
        ResolutionDescription -> "Aqueous solvent is automatically added if the starting sample of each extraction round is of Organic or Unknown phase. Organic solvent is automatically added if the starting sample of each extraction round is of Aqueous or Unknown phase. If the sample is already Biphasic, the no solvent is added. Note that the phase of the starting sample in extraction rounds 2 and above is dependent on the TargetPhase and SelectionStrategy options.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> Demulsifier,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Alternatives[
          Widget[
            Type -> Object,
            Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
            OpenPaths -> {
              {
                Object[Catalog, "Root"],
                "Materials",
                "Reagents"
              }
            }
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[None]
          ]
        ],
        Description -> "The solution that is added to the sample mixture in order to help promote complete phase separation and avoid emulsions.",
        ResolutionDescription -> "If DemulsifierAdditions is specified, automatically set to the demulsifier specified in DemulsifierAdditions. Otherwise, automatically set to Model[Sample, StockSolution, \"5M Sodium Chloride\"] if DemulsifierAmount is specified. Otherwise, set to Null.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> DemulsifierAmount,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Milliliter, $MaxRoboticTransferVolume],
            Units -> {Microliter, {Microliter, Milliliter}}
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[None]
          ]
        ],
        Description -> "The solution that is added to the sample mixture in order to help promote complete phase separation and avoid emulsions.",
        ResolutionDescription -> "Automatically set to 10% of the sample volume if Demulsifier or DemulsifierAdditions is specified. Otherwise, set to Null.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> DemulsifierAdditions,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Adder[
          Alternatives[
            "Demulsifier" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
              OpenPaths -> {
                {
                  Object[Catalog, "Root"],
                  "Materials",
                  "Reagents",
                  "Solvents"
                }
              }
            ],
            "None" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives[None]
            ]
          ]
        ],
        Description -> "For each extraction round, the Demulsifier that is added to the sample mixture to help promote complete phase separation and avoid emulsions.",
        ResolutionDescription -> "If Demulsifier is not specified, DemulsifierAdditions is set to None. If NumberOfExtractions is set to 1, Demulsifier will only be added during the first extraction round. If NumberOfExtractions is greater than 1 and the sample's Organic phase will be used subsequent extraction rounds (TargetPhase->Aqueous and ExtractionTechnique->Positive OR TargetPhase->Organic and ExtractionTechnique->Negative), Demulsifier will be added during all extraction rounds since the Demulsifier (usually a salt solution which is soluble in the Aqueous layer) will be removed along with the Aqueous layer during the extraction and thus will need to be added before each extraction round. Otherwise, Demulsifier is added to only the first extraction round since the sample's Aqueous phase will be used in subsequent extraction rounds.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> Temperature,
        Default -> Ambient,
        AllowNull -> False,
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
            Units :> Celsius
          ],
          Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The set temperature of the incubation device that holds the extraction container during solvent/demulsifier addition, mixing, and settling.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> NumberOfExtractions,
        Default -> 3,
        AllowNull -> False,
        Widget ->  Widget[Type -> Number, Pattern :> RangeP[1, 10, 1]],
        Description -> "The number of times that the extraction is performed using the specified extraction parameters using the previous extraction round's impurity layer (after the TargetPhase has been extracted) as the input to subsequent rounds of extraction.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> ExtractionMixType,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> RoboticMixTypeP
        ],
        Description -> "The style of motion used to mix the sample mixture following the addition of the AqueousSolvent/OrganicSolvent and Demulsifier (if specified).",
        ResolutionDescription -> "Automatically set to Shake if ExtractionMixTime is specified. Otherwise, set to Pipette.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> ExtractionMixTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Second, $MaxExperimentTime],
          Units -> {Second, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the sample, AqueousSolvent/OrganicSolvent, and Demulsifier (if specified) are mixed.",
        ResolutionDescription -> "Automatically set to 30 Second if ExtractionMixType is set to Shake. Otherwise, set to Null.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> ExtractionMixRate,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[$MinRoboticMixRate, $MaxRoboticMixRate],
          Units -> RPM
        ],
        Description -> "The frequency of rotation the mixing instrument uses to mechanically incorporate the sample, AqueousSolvent/OrganicSolvent, and demulsifier (if specified).",
        ResolutionDescription -> "Automatically set to 300 RPM if ExtractionMixType is set to Shake. Otherwise, set to Null.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> NumberOfExtractionMixes,
        Default -> Automatic,
        AllowNull -> True,
        Widget ->
            Widget[
              Type -> Number,
              Pattern :> RangeP[1, $MaxNumberOfMixes, 1]
            ],
        Description -> "The number of times the sample, AqueousSolvent/OrganicSolvent, and demulsifier (if specified) are mixed when ExtractionMixType is set to Pipette.",
        ResolutionDescription -> "Automatically set to 10 when ExtractionMixType is set to Pipette. Otherwise, set to Null.",
        Category -> "Phase Mixing"
      },
      {
        OptionName -> ExtractionMixVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Milliliter, $MaxRoboticSingleTransferVolume],
          Units -> {Microliter, {Microliter, Milliliter}}
        ],
        Description -> "The volume of sample, AqueousSolvent/OrganicSolvent, and demulsifier (if specified) that is mixed when ExtractionMixType is set to Pipette.",
        ResolutionDescription -> "Automatically set to the lesser of 1/2 of the volume of the sample plus any additional components (SampleVolume, AqueousSolventVolume (if specified), OrganicSolventVolume (if specified), and DemulsifierAmount (if specified)) and 970 Microliter (the maximum amount of volume that can be transferred in a single pipetting step on the liquid handling robot) if ExtractionMixType is set to Pipette. Otherwise, set to Null.",
        Category -> "Phase Mixing"
      },

      {
        OptionName -> SettlingTime,
        Default -> 1 Minute,
        AllowNull ->True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Second, $MaxExperimentTime],
          Units -> {Second, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the sample is allowed to settle and the organic/aqueous phases separate. This is performed after the AqueousSolvent/OrganicSolvent and Demulsifier (if specified) are added and optionally mixed. If ExtractionTechnique is set to PhaseSeparator, the settling time starts once the sample is loaded into the phase separator (the amount of time that we wait for the organic layer to drain through the phase separator's hydrophobic frit).",
        Category -> "Settling"
      },

      {
        OptionName -> Centrifuge,
        Default -> Automatic,
        AllowNull -> False,
        Description -> "Indicates if the sample is centrifuged to help separate the aqueous and organic layers, after the addition of solvent/demulsifier, mixing, and setting time has elapsed.",
        ResolutionDescription -> "Automatically set to True any of the other centrifuge options are specified (CentrifugeInstrument, CentrifugeIntensity, CentrifugeTime). Also automatically set to True if ExtractionTechnique -> Pipette and the samples are in a centrifuge compatible container (the Footprint of the container is set to Plate). Otherwise, set to False.",
        Category -> "Settling",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
      },
      {
        OptionName -> CentrifugeInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}]
        ],
        Category -> "Settling",
        Description -> "The centrifuge that is used to spin the samples to help separate the aqueous and organic layers, after the addition of solvent/demulsifier, mixing, and setting time has elapsed.",
        ResolutionDescription -> "Automatically set to the integrated centrifuge model that is available in the WorkCell, if the Centrifuge option is set to True."
      },
      {
        OptionName -> CentrifugeIntensity,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units -> Alternatives[RPM]],
          Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units -> Alternatives[GravitationalAcceleration]]
        ],
        Category -> "Settling",
        Description -> "The rotational speed or the force that is applied to the samples via centrifugation to help separate the aqueous and organic layers, after the addition of solvent/demulsifier, mixing, and setting time has elapsed.",
        ResolutionDescription -> "Automatically set to the lesser of the MaxIntensity of the centrifuge model and the MaxCentrifugationForce of the plate model, if centrifugation is specified."
      },
      {
        OptionName -> CentrifugeTime,
        Default -> Automatic,
        Description -> "The amount of time that the samples are centrifuged to help separate the aqueous and organic layers, after the addition of solvent/demulsifier, mixing, and setting time has elapsed.",
        AllowNull -> True,
        Category -> "Settling",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Second, $MaxExperimentTime],
          Units -> {Second, {Second, Minute, Hour}}
        ],
        ResolutionDescription -> "Automatically set to 2 Minute, if centrifugation is specified."
      },

      {
        OptionName -> ExtractionBoundaryVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Adder[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Milliliter, $MaxRoboticTransferVolume],
            Units -> {Microliter, {Microliter, Milliliter}}
          ]
        ],
        Description -> "For each extraction round, the volume of the target phase that is either overaspirated via Pipette when IncludeBoundary is set to True (by aspirating the boundary layer along with the TargetPhase and therefore potentially collecting a small amount of the unwanted phase) or underaspirated via Pipette when IncludeBoundary is set to False (by not collecting all of the target phase and therefore reducing the likelihood of collecting any of the unwanted phase). This option only applies if ExtractionTechnique -> Pipette.",
        ResolutionDescription -> "Automatically set the smaller of 10% of the predicted volume of the ExtractionTransferLayer or the volume that corresponds with a 5 Millimeter tall cross-section of the ExtractionContainer at the position of the boundary between aqueous and organic layers if ExtractionTransferLayer -> Top or at the bottom of the container if ExtractionTransferLayer -> Bottom. If ExtractionTechnique -> PhaseSeparator, set to Null.",
        Category -> "Collection"
      },
      {
        OptionName -> ExtractionTransferLayer,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Adder[
          Widget[
            Type -> Enumeration,
            Pattern :> Top|Bottom
          ]
        ],
        Description -> "Indicates whether the top or bottom layer is transferred from the source sample after the organic and aqueous phases are separated. If the TargetLayer matches ExtractionTransferLayer, the sample that is transferred out is the target phase. Otherwise, if TargetLayer doesn't match ExtractionTransferLayer, the sample that remains in the container after the transfer is the target phase.",
        ResolutionDescription -> "Automatically set to Top if ExtractionTechnique->Pipette. Otherwise, set to Null.",
        Category -> "Collection"
      },
      {
        OptionName -> TargetContainerOut,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Alternatives[
          "Existing Container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Object[Container]]
          ],
          "New Container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[Container]]
          ],
          "New Container with Index" -> {
            "Index" -> Widget[
              Type -> Number,
              Pattern :> GreaterEqualP[1, 1]
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          }
        ],
        Description -> "The container that the separated target layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
        ResolutionDescription -> "Automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] if TargetPhase -> Organic and ExtractionTechnique -> PhaseSeparator (since the organic layer will flow through the phase separator's hydrophobic frit, TargetContainerOut will be used as the collection container for the phase separator). Otherwise, automatically set to a robotic compatible container that can hold the volume of the target layer via PreferredContainer[...].",
        Category -> "Collection"
      },
      {
        OptionName -> TargetContainerOutWell,
        Default->Automatic,
        AllowNull->False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 96]],
          PatternTooltip -> "Enumeration must be any well from A1 to H12."
        ],
        Description -> "The well of the container that the separated target layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
        ResolutionDescription -> "Automatically set the first empty well in TargetContainerOut.",
        Category -> "Collection"
      },
      {
        OptionName -> ImpurityContainerOut,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Alternatives[
          "Existing Container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Object[Container]]
          ],
          "New Container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[Container]]
          ],
          "New Container with Index" -> {
            "Index" -> Widget[
              Type -> Number,
              Pattern :> GreaterEqualP[1, 1]
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          }
        ],
        Description -> "The container that the separated impurity layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
        ResolutionDescription -> "Automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] if TargetPhase -> Aqueous and ExtractionTechnique -> PhaseSeparator (since the organic impurity layer will flow through the phase separator's hydrophobic frit, ImpurityContainerOut will be used as the collection container for the phase separator). Otherwise, automatically set to a robotic compatible container that can hold the volume of the target layer via PreferredContainer[...].",
        Category -> "Collection"
      },
      {
        OptionName -> ImpurityContainerOutWell,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 96]],
          PatternTooltip -> "Enumeration must be any well from A1 to H12."
        ],
        Description -> "The well of the container that the separated impurity layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
        ResolutionDescription -> "Automatically set the first empty well in ImpurityContainerOut.",
        Category -> "Collection"
      },
      {
        OptionName -> TargetStorageCondition,
        Default -> Null,
        AllowNull -> True,
        Widget -> Alternatives[
          "Storage Type" -> Widget[
            Type -> Enumeration,
            Pattern :> SampleStorageTypeP | Disposal
          ],
          "Storage Object" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]]
          ]
        ],
        Description -> "The condition under which the target sample is stored after the protocol is completed. If left unset, the target sample will be stored under the same condition as the source sample that it originates from.",
        Category -> "Collection"
      },
      {
        OptionName -> ImpurityStorageCondition,
        Default -> Null,
        AllowNull -> True,
        Widget -> Alternatives[
          "Storage Type" -> Widget[
            Type -> Enumeration,
            Pattern :> SampleStorageTypeP | Disposal
          ],
          "Storage Object" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]]
          ]
        ],
        Description -> "The conditions under which the waste layer samples will be stored after the protocol is completed. If left unset, the waste sample will be stored under the same condition as the source sample that it originates from.",
        Category -> "Collection"
      },

      {
        OptionName -> SampleLabel,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Description -> "A user defined word or phrase used to identify the input sample, for use in downstream unit operations.",
        ResolutionDescription -> "Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"liquid liquid extraction sample #\".",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> SampleContainerLabel,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Description -> "A user defined word or phrase used to identify the input sample's container, for use in downstream unit operations.",
        ResolutionDescription -> "Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"liquid liquid extraction sample container #\".",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> TargetLabel,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Description -> "A user defined word or phrase used to identify the sample that contains the extracted target layer sample, for use in downstream unit operations.",
        ResolutionDescription -> "Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"liquid liquid target sample #\".",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> TargetContainerLabel,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Description -> "A user defined word or phrase used to identify the container that contains the extracted target layer sample, for use in downstream unit operations.",
        ResolutionDescription -> "Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"liquid liquid target sample container #\".",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> ImpurityLabel,
        Default-> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Description -> "A user defined word or phrase used to identify the sample that contains the waste layer, for use in downstream unit operations.",
        ResolutionDescription -> "Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"liquid liquid impurity sample #\".",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> ImpurityContainerLabel,
        Default-> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Description -> "A user defined word or phrase used to identify the container that contains the waste layer sample, for use in downstream unit operations.",
        ResolutionDescription -> "Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"liquid liquid impurity sample container #\".",
        Category -> "General",
        UnitOperation -> True
      },

      (* HIDDEN OPTIONS *)
      {
        OptionName -> AqueousLayerVolumes,
        Default-> Automatic,
        AllowNull -> True,
        Widget -> Adder[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Milliliter, $MaxRoboticTransferVolume],
            Units -> {Microliter, {Microliter, Milliliter}}
          ]
        ],
        Description -> "The estimated volumes of the aqueous phase for each extraction round.",
        Category -> "Hidden"
      },
      {
        OptionName -> OrganicLayerVolumes,
        Default-> Automatic,
        AllowNull -> True,
        Widget -> Adder[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Milliliter, $MaxRoboticTransferVolume],
            Units -> {Microliter, {Microliter, Milliliter}}
          ]
        ],
        Description -> "The estimated volumes of the organic phase for each extraction round.",
        Category -> "Hidden"
      }
    ],

    (*===Shared Options===*)
    RoboticPreparationOption,
    ProtocolOptions,
    SimulationOption,
    PostProcessingOptions,
    SubprotocolDescriptionOption,
    SamplesInStorageOptions,
    WorkCellOption
  }
];



(* ::Subsubsection::Closed:: *)
(*Messages*)

(* This is the threshold above/below which we say that the target molecule has a strong affinitiy for either the *)
(* Aqueous or Organic layer. When LogP is between these values, the target molecule has a very weak affinity for the *)
(* Aqueous or Organic layer. *)
$AqueousLogPThreshold = -0.5;
$OrganicLogPThreshold = 0.5;

Warning::WeakTargetAnalytePhaseAffinity="The target analyte(s), `1`, have a weak affinity to the TargetPhase(s), `2`, according to the predicted Log Partition Coefficient(s), `3` via the function SimulateLogPartitionCoefficient. Molecules with a LogP greater than 0 are more hydrophobic (and are predicted to have a higher concentration in the Organic phase) and molecules with a LogP less than 0 are more hydrophilic (and are predicted to have a higher concentration in the Aqueous phase). When LogP is between "<>ToString[$AqueousLogPThreshold]<>" and "<>ToString[$OrganicLogPThreshold]<>", the TargetAnalyte does not have a very strong affinity for a single layer (Aqueous or Organic). Multiple rounds of purification (NumberOfExtractions) or a different extraction method (that does not rely on hydrophobicity/hydrophilicity) might be required.";
Warning::NoAvailableLogPDefaultingToAqueous="The target analyte(s), `1`, have no known experimentally measured LogP or simulated LogP (via the XLogP3 algorithm) on PubChem for the sample(s), `2`. Defaulting the predicted TargetPhase to Aqueous.";
Warning::NoTargetAnalyteDefaultingToAqueous="The sample(s), `1`, do not have the Analytes field populated and there are no molecules in the Composition field that look like potential Analytes. Defaulting the TargetPhase to Aqueous.";
Error::ConflictingMixParametersForLLE="The sample(s), `1`, at indices, `7`, have conflicting mix options. ExtractionMixType is set to `2`, but ExtractionMixTime->`3`, ExtractionMixRate->`4`, NumberOfExtractionMixes->`5`, and ExtractionMixVolume->`6`. If ExtractionMixType is set to Pipette, NumberOfExtractionMixes/ExtractionMixVolume must be set and ExtractionMixTime/ExtractionMixRate cannot be set. If ExtractionMixType is set to Shake, ExtractionMixTime/ExtractionMixRate must be set an NumberOfExtractionMixes/ExtractionMixVolume cannot be set. Please fix these conflicting options to specify a valid experiment.";
Error::OrganicSolventDensityPhaseSeparator="The sample(s), `1`, at the indices, `2`, are specified to be separated via ExtractionTechnique->PhaseSeparator but have the Organic layer on Top of the Aqueous layer (according to the TargetPhase / TargetLayer options). When using a phase separator, the Organic layer must be on the Bottom in order to freely pass through the hydrophobic frit and be separated from the Aqueous layer (on Top). Please choose a denser Organic solvent or set ExtractionTechnique->Pipette.";
Error::ConflictingCentrifugeContainerParametersForLLE="The following container(s), `1`, have conflicting centrifugation parameters -- Centrifuge is set to `2`, CentrifugeInstrument is set to `3`, CentrifugeIntensity is set to `4`, and CentrifugeTime is set to `5`. If different centrifugation parameters are desired for your samples, please transfer them into different containers using the SampleVolume and ExtractionContainer options.";
Error::ConflictingTemperaturesForLLE="The container(s), `1`, have conflicting Temperatures specified, `2`. Each container can only be kept at a single temperature during the course of the liquid liquid extraction. If you would like the samples to be kept at different temperatures, please transfer the sample into a different container using the SampleVolume/ExtractionContainer options.";
Error::ExtractionOptionMismatch="The sample(s), `1`, at indices, `7` have ExtractionTechnique specified as `2`. However, these samples also have ExtractionDevice -> `3`, IncludeBoundary -> `4`, ExtractionBoundaryVolume -> `5`, and ExtractionTransferLayer -> `6`. ExtractionDevice can only be set when ExtractionTechnique is PhaseSeparator and IncludeBoundary/ExtractionBoundaryVolume/ExtractionTransferLayer can only be set when ExtractionTechnique is Pipette. Please fix these conflicting options to submit a valid experiment.";
Error::DemulsifierSpecifiedConflict="The sample(s), `1`, at indices, `4`, have DemulsifierAdditions set to `2` but Demulsifier set to `3`. The demulsifier specified in DemulsifierAdditions must be the same as the Demulsifier option. Please fix this option conflict to specify a valid experiment.";
Error::InvalidSolventAdditions="The sample(s), `1`, at indices, `4`, are missing solvent additions during its extraction rounds in order to create a biphasic solution with both an Aqueous and Organic phase. The SolventAdditions option is currently set to `2` but it should be set to `3`. Please change the SolventAdditions option such that there will be a biphasic solution for each extraction round. Note that if SelectionStrategy->Positive, the impurity layer (opposite from TargetPhase) from the first extraction round will serve as the input to the next extraction rounds and if SelectionStrategy->Negative, the TargetPhase from the first extraction round will serve as the input to the next extraction rounds.";
Error::SolventAdditionsMismatch="The sample(s), `1`, at indices `5`, have solvents specified in the SolventAdditions option (`2`) that do not show up in the AqueousSolvent option (`3`) or the OrganicSolvent option (`4`). Please remove these extraneous solvents from the SolventAdditions option.";
Error::InvalidExtractionRoundLengths="The sample(s), `1`, at indices, `5`, have option(s), `2`, which are of incorrect lengths `3` whereas the NumberOfExtractions option is set to `4`. Please fix the length of these options in order to submit a valid experiment.";
Error::ConflictingCentrifugeParametersForLLE="The sample(s), `1`, at indices, `6`, have conflicting centrifugation options. Centrifuge is set to `2`, but CentrifugeInstrument->`3`, CentrifugeIntensity->`4`, and CentrifugeTime->`5`. If Centrifuge is set to True, CentrifugeInstrument, CentrifugeIntensity, and CentrifugeTime must be specified. If Centrifuge is set to False, CentrifugeInstrument, CentrifugeIntensity, and CentrifugeTime cannot be specified. Please fix these conflicting options to specify a valid experiment.";

(* ::Subsection::Closed:: *)
(* ExperimentLiquidLiquidExtraction*)


(* - Container to Sample Overload - *)

ExperimentLiquidLiquidExtraction[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
  {cache, listedOptions,listedContainers,outputSpecification,output,gatherTests,containerToSampleResult,
    containerToSampleOutput,samples,sampleOptions,containerToSampleTests,simulation,
    containerToSampleSimulation},

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Remove temporal links and named objects. *)
  {listedContainers, listedOptions} = removeLinks[ToList[myContainers], ToList[myOptions]];

  (* Fetch the cache from listedOptions. *)
  cache=Lookup[listedOptions, Cache, {}];
  simulation=Lookup[listedOptions, Simulation];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
      ExperimentLiquidLiquidExtraction,
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
        ExperimentLiquidLiquidExtraction,
        listedContainers,
        listedOptions,
        Output-> {Result,Simulation},
        Simulation->simulation
      ],
      $Failed,
      {Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
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
    ExperimentLiquidLiquidExtraction[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
  ]
];

(* -- Main Overload --*)
ExperimentLiquidLiquidExtraction[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
  {
    cache, cacheBall, collapsedResolvedOptions, downloadFields, expandedSafeOpsExceptSolventAdditions, expandedSafeOps, gatherTests, inheritedOptions, listedOptions,
    listedSamples, messages, output, outputSpecification, liquidLiquidExtractionCache, performSimulationQ, resultQ,
    protocolObject, resolvedOptions, resolvedOptionsResult, resolvedOptionsTests, resourceResult, resourcePacketTests,
    returnEarlyQ, safeOps, safeOptions, safeOptionTests, templatedOptions, templateTests, resolvedPreparation, roboticSimulation, runTime,
    inheritedSimulation, validLengths, validLengthTests, simulation, listedSanitizedSamples,
    listedSanitizedOptions, userSpecifiedObjects, objectsExistQs, objectsExistTests
  },

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];
  messages=!gatherTests;

  (* Remove temporal links *)
  {listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOptions, safeOptionTests}=If[gatherTests,
    SafeOptions[ExperimentLiquidLiquidExtraction,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ExperimentLiquidLiquidExtraction,listedOptions,AutoCorrect->False],{}}
  ];

  (* Call sanitize-inputs to clean any named objects *)
  {listedSanitizedSamples, safeOps, listedSanitizedOptions} = sanitizeInputs[listedSamples, safeOptions, listedOptions];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths,validLengthTests}=If[gatherTests,
    ValidInputLengthsQ[ExperimentLiquidLiquidExtraction,{listedSanitizedSamples},listedSanitizedOptions,Output->{Result,Tests}],
    {ValidInputLengthsQ[ExperimentLiquidLiquidExtraction,{listedSanitizedSamples},listedSanitizedOptions],Null}
  ];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOptionTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
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
    ApplyTemplateOptions[ExperimentLiquidLiquidExtraction,{listedSanitizedSamples},listedSanitizedOptions,Output->{Result,Tests}],
    {ApplyTemplateOptions[ExperimentLiquidLiquidExtraction,{listedSanitizedSamples},listedSanitizedOptions],Null}
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

  (* Expand index-matching options *)
  expandedSafeOpsExceptSolventAdditions=Last[ExpandIndexMatchedInputs[ExperimentLiquidLiquidExtraction,{listedSanitizedSamples},inheritedOptions]];

  (* Correct expansion of SolventAdditions if not Automatic. *)
  (* NOTE:This is needed because SolventAdditions is not correctly expanded by ExpandIndexMatchedInputs. *)
  expandedSafeOps = If[
    MatchQ[Lookup[inheritedOptions, SolventAdditions],Except[ListableP[Automatic]]],
    Which[
      (* Correct input from LLE primitive (resolved, but put into extra list). *)
      And[
        MatchQ[Length[Lookup[inheritedOptions, SolventAdditions]], 1],
        MatchQ[Length[Lookup[inheritedOptions, SolventAdditions][[1]]], Length[ToList[mySamples]]],
        MatchQ[Map[Length, Lookup[inheritedOptions, SolventAdditions][[1]]], Lookup[inheritedOptions, NumberOfExtractions]]
      ],
        ReplaceRule[
          expandedSafeOpsExceptSolventAdditions,
          SolventAdditions -> Lookup[inheritedOptions, SolventAdditions][[1]]
        ],
      (* If the length of SolventAdditions matches the number of samples, then it is correctly index matched and is used as-is. *)
      MatchQ[Length[Lookup[inheritedOptions, SolventAdditions]], Length[ToList[mySamples]]] && MatchQ[Lookup[inheritedOptions, SolventAdditions], {Except[ObjectP[]]..}],
        ReplaceRule[
          expandedSafeOpsExceptSolventAdditions,
          SolventAdditions -> Lookup[inheritedOptions, SolventAdditions]
        ],
      (* If the length of SolventAdditions matches the NumberOfExtractions, then it is expanded to match the number of samples. *)
      MatchQ[Length[Lookup[inheritedOptions, SolventAdditions]], Lookup[inheritedOptions, NumberOfExtractions]],
        ReplaceRule[
          expandedSafeOpsExceptSolventAdditions,
          SolventAdditions -> ConstantArray[Lookup[inheritedOptions, SolventAdditions], Length[ToList[mySamples]]]
        ],
      (* Otherwise, the option is used as-is. *)
      True,
        expandedSafeOpsExceptSolventAdditions
    ],
    expandedSafeOpsExceptSolventAdditions
  ];

  (* Correct expansion of SolventAdditions if not Automatic. *)
  (* NOTE:This is needed because SolventAdditions is not correctly expanded by ExpandIndexMatchedInputs. *)
  expandedSafeOps = If[
    MatchQ[Lookup[inheritedOptions, SolventAdditions],Except[ListableP[Automatic]]],
    Which[
      (* Correct input from LLE primitive (resolved, but put into extra list). *)
      And[
        MatchQ[Length[Lookup[inheritedOptions, SolventAdditions]], 1],
        MatchQ[Length[Lookup[inheritedOptions, SolventAdditions][[1]]], Length[ToList[mySamples]]],
        MatchQ[Map[Length, Lookup[inheritedOptions, SolventAdditions][[1]]], Lookup[inheritedOptions, NumberOfExtractions]]
      ],
        ReplaceRule[
          expandedSafeOps,
          SolventAdditions -> Lookup[inheritedOptions, SolventAdditions][[1]]
        ],
      (* If the length of SolventAdditions matches the number of samples, then it is correctly index matched and is used as-is. *)
      MatchQ[Length[Lookup[inheritedOptions, SolventAdditions]], Length[ToList[mySamples]]] && MatchQ[Lookup[inheritedOptions, SolventAdditions], {Except[ObjectP[]]..}],
        ReplaceRule[
          expandedSafeOps,
          SolventAdditions -> Lookup[inheritedOptions, SolventAdditions]
        ],
      (* If the length of SolventAdditions matches the NumberOfExtractions, then it is expanded to match the number of samples. *)
      MatchQ[Length[Lookup[inheritedOptions, SolventAdditions]], Lookup[inheritedOptions, NumberOfExtractions]],
        ReplaceRule[
          expandedSafeOps,
          SolventAdditions -> ConstantArray[Lookup[inheritedOptions, SolventAdditions], Length[ToList[mySamples]]]
        ],
      (* Otherwise, the option is used as-is. *)
      True,
        expandedSafeOps
    ],
    expandedSafeOps
  ];

  (* Fetch the Cache and Simulation options. *)
  cache=Lookup[expandedSafeOps, Cache, {}];
  inheritedSimulation=Lookup[expandedSafeOps, Simulation, Null];

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
  downloadFields={
    SamplePreparationCacheFields[Object[Sample], Format->Packet],
    Packet[Model[SamplePreparationCacheFields[Model[Sample]]]],
    Packet[Container[SamplePreparationCacheFields[Object[Container]]]],
    Packet[Container[Model][SamplePreparationCacheFields[Model[Container]]]]
  };

  (* - Big Download to make cacheBall and get the inputs in order by ID - *)
  liquidLiquidExtractionCache=Quiet[
    Download[
      listedSanitizedSamples,
      Evaluate@downloadFields,
      Cache->cache,
      Simulation ->inheritedSimulation
    ],
    {Download::FieldDoesntExist,Download::NotLinkField}
  ];

  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  cacheBall=FlattenCachePackets[{cache,liquidLiquidExtractionCache}];

  (* Build the resolved options *)
  resolvedOptionsResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions,resolvedOptionsTests}=resolveExperimentLiquidLiquidExtractionOptions[
      ToList[Download[mySamples,Object]],
      expandedSafeOps,
      Cache->cacheBall,
      Simulation->inheritedSimulation,
      Output->{Result,Tests}
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {resolvedOptions,resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {resolvedOptions,resolvedOptionsTests}={
        resolveExperimentLiquidLiquidExtractionOptions[
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
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentLiquidLiquidExtraction,
    resolvedOptions,
    Ignore->ToList[myOptions],
    Messages->False
  ];

  (* Lookup our resolved Preparation option. *)
  resolvedPreparation = Lookup[resolvedOptions, Preparation];

  (* run all the tests from the resolution; if any of them were False, then we should return early here *)
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

  (* NOTE: We need to perform simulation if Result is asked for in LLE since it's part of the SamplePreparation experiments. *)
  (* This is because we pass down our simulation to ExperimentMSP or ExperimentRSP. *)
  performSimulationQ = MemberQ[output, Result|Simulation];
  (* If we did get the result, we should try to quiet messages in simulation so that we will not duplicate them. We will just silently update our simulation *)
  resultQ = MemberQ[output, Result];

  (* If option resolution failed, return early. *)
  If[returnEarlyQ && !performSimulationQ,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentLiquidLiquidExtraction,collapsedResolvedOptions],
      Preview->Null,
      Simulation -> Simulation[]
    }]
  ];

  (* Build packets with resources *)
  (* NOTE: If our resource packets function, if Preparation->Robotic, we call RSP in order to get the robotic unit operation *)
  (* packets. We also get a robotic simulation at the same time. *)
  {{resourceResult, roboticSimulation, runTime}, resourcePacketTests} = Which[
    MatchQ[resolvedOptionsResult, $Failed],
      {{$Failed, $Failed, $Failed}, {}},
    gatherTests,
      liquidLiquidExtractionResourcePackets[
        ToList[Download[mySamples,Object]],
        templatedOptions,
        resolvedOptions,
        Cache->cacheBall,
        Simulation -> inheritedSimulation,
        Output->{Result,Tests}
      ],
    True,
      {
        liquidLiquidExtractionResourcePackets[
          ToList[Download[mySamples,Object]],
          templatedOptions,
          resolvedOptions,
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

  (* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
  If[!MemberQ[output,Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentLiquidLiquidExtraction,collapsedResolvedOptions],
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
        primitive=LiquidLiquidExtraction@@Join[
          {
            Sample->Download[ToList[mySamples], Object]
          },
          RemoveHiddenPrimitiveOptions[LiquidLiquidExtraction,ToList[myOptions]]
        ];

        (* Remove any hidden options before returning. *)
        nonHiddenOptions=RemoveHiddenOptions[ExperimentLiquidLiquidExtraction,collapsedResolvedOptions];

        (* Memoize the value of ExperimentLiquidLiquidExtraction so the framework doesn't spend time resolving it again. *)
        Internal`InheritedBlock[{ExperimentLiquidLiquidExtraction, $PrimitiveFrameworkResolverOutputCache},
          $PrimitiveFrameworkResolverOutputCache=<||>;

          DownValues[ExperimentLiquidLiquidExtraction]={};

          ExperimentLiquidLiquidExtraction[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
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
          experimentFunction = Lookup[$WorkCellToExperimentFunction, Lookup[resolvedOptions, WorkCell]];

          experimentFunction[
            {primitive},
            Name->Lookup[safeOps,Name],
            Upload->Lookup[safeOps,Upload],
            Confirm->Lookup[safeOps,Confirm],
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
    Options -> RemoveHiddenOptions[ExperimentLiquidLiquidExtraction,collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> simulation,
    RunTime -> runTime
  }
];


(* ::Subsection:: *)
(* resolveLiquidLiquidExtractionWorkCell *)

DefineOptions[resolveLiquidLiquidExtractionWorkCell,
  SharedOptions:>{
    ExperimentLiquidLiquidExtraction,
    CacheOption,
    SimulationOption,
    OutputOption
  }
];

resolveLiquidLiquidExtractionWorkCell[
  myContainersAndSamples:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container]}]],
  myOptions:OptionsPattern[]
]:=Which[
  (* The STAR can achieve mix rates higher and lower than the bioSTAR ($MinRoboticMixRate / $MaxRoboticMixRate). *)
  MemberQ[ToList[Lookup[myOptions, ExtractionMixRate]], GreaterP[$MaxBioSTARMixRate]],
    {STAR},
  MemberQ[ToList[Lookup[myOptions, ExtractionMixRate]], LessP[$MinBioSTARMixRate]],
    {STAR},

  (* NOTE: The bioSTAR/microbioSTAR can achieve the full 0 C - 110 C temperature range. The STARs/STARlets can only do 0 C - 105 C. *)
  MemberQ[ToList[Lookup[myOptions, Temperature]], GreaterP[$MaxSTARIncubationTemperature]],
    {bioSTAR, microbioSTAR},

  True,
    {STAR, bioSTAR, microbioSTAR}
];


(* ::Subsection::Closed:: *)
(* resolveExperimentLiquidLiquidExtractionOptions *)

DefineOptions[
  resolveExperimentLiquidLiquidExtractionOptions,
  Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentLiquidLiquidExtractionOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentLiquidLiquidExtractionOptions]]:=Module[
  {outputSpecification,output,gatherTests,messages,cache,listedOptions,currentSimulation,optionPrecisions,roundedExperimentOptions,
    optionPrecisionTests,invalidInputs,invalidOptions, mapThreadFriendlyOptionsExceptSolventAdditions, mapThreadFriendlyOptions,samplePacketFields,sampleFields,
    sampleModelFields,sampleModelPacketFields,moleculeFields,
    containerObjectFields,containerObjectPacketFields,containerModelFields,containerModelPacketFields,
    samplePackets, sampleContainerPackets, sampleContainerModelPackets, sampleSolventPackets, sampleCompositionMoleculePackets,
    sampleSolventCompositionMoleculePackets, sampleAnalytesMoleculePackets, containerModelPackets, containerModelFromObjectPackets,
    additiveSampleModelPackets, additiveSamplePackets, cacheBall, fastCacheBall, allowedWorkCells, resolvedWorkCell, resolvedTargetAnalytes, ambiguousAnalyteWarnings,
    ambiguousAnalyteTest, allPredictedSamplePhases, allPredictedSamplePhaseVolumes, solventMolecules,
    allPredictedSamplePhaseMolecules, predictedAnalyteLogPs, solventMoleculeLogPs, allPredictedLogPs, resolvedSamplePhases,
    resolvedTargetPhases, targetPhaseWeakAffinityWarnings, specifiedSolventToTypeLookup,
    noLogPAvailableWarnings, targetPhaseWeakAffinityTest, noAvailableLogPTest, missingTargetAnalyteBools, noTargetAnalyteTest,
    resolvedExtractionTechniques, resolvedExtractionDevices, resolvedSelectionStrategies, resolvedIncludeBoundaries, resolvedSampleVolumes,
    resolvedWorkingSampleVolumes, resolvedAqueousSolvents, resolvedAqueousSolventVolumes, resolvedAqueousSolventRatios,
    resolvedOrganicSolvents, resolvedOrganicSolventVolumes, resolvedOrganicSolventRatios, resolvedSolventAdditions,
    resolvedTargetLayers, unknownTargetLayerWarnings, resolvedDemulsifierAdditions, resolvedDemulsifiers,
    resolvedDemulsifierAmounts, resolvedCentrifugeBools, resolvedCentrifugeInstruments, resolvedCentrifugeIntensitys,
    resolvedCentrifugeTimes, resolvedExtractionTransferLayers, resolvedExtractionMixTypes, resolvedExtractionMixTimes,
    resolvedExtractionMixRates, resolvedNumberOfExtractionMixes, resolvedExtractionMixVolumes, resolvedMaxExtractionContainerVolumes,
    resolvedAqueousLayerVolumes, resolvedOrganicLayerVolumes, resolvedAddOrganicSolvents, resolvedAddAqueousSolvents, resolvedSampleAqueousPhaseDensities,
    resolvedSampleOrganicPhaseDensities, resolvedAqueousSolventDensities, resolvedOrganicSolventDensities, userSpecifiedLabels, resolvedSampleLabels, resolvedSampleContainerLabels,
    resolvedExtractionContainers, resolvedExtractionContainerWells, resolvedTargetContainerOuts, resolvedTargetContainerOutWells,
    resolvedTargetLabels, resolvedTargetContainerLabels, resolvedImpurityContainerOuts, resolvedImpurityContainerOutWells,
    resolvedImpurityLabels, resolvedImpurityContainerLabels, resolvedExtractionBoundaryVolumes, resolvedPostProcessingOptions,
    conflictingMixOptionsResult, conflictingMixOptionsTest, demulsifierSpecifiedResult, demulsifierSpecifiedTest,
    organicLayerDensityErrors, organicLayerDensityTest, conflictingCentrifugeContainerOptionsResult, conflictingCentrifugeContainerOptionsTest,
    conflictingCentrifugeOptionsResult, conflictingCentrifugeOptionsTest,
    conflictingTemperaturesResult, conflictingTemperaturesTest, extractionOptionMismatchResult, extractionOptionMismatchTest,
    solventAdditionsMismatch, solventAdditionsMismatchTest, invalidSolventAdditions, invalidSolventAdditionsTest,
    extractionRoundMismatches, extractionRoundMismatchesTest, email, resolvedOptions},

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

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

  (*-- RESOLVE PREPARATION OPTION --*)
  (* Usually, we resolve our Preparation option here, but since we can only do Preparation -> Robotic, there is no need to. *)

  (* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

  (*-- INPUT VALIDATION CHECKS --*)

  (*-- OPTION PRECISION CHECKS --*)

  (* Define the option precisions that need to be checked. *)
  (* NOTE: Don't check CentrifugeIntensity precision here because each centrifuge has a different precision. ExperimentCentrifuge *)
  (* will check this for us. *)
  optionPrecisions = {
    {SampleVolume,1*Microliter},
    {AqueousSolventVolume,1*Microliter},
    {OrganicSolventVolume,1*Microliter},
    {DemulsifierAmount,1*Microliter},
    {Temperature,1*Celsius},
    {ExtractionMixTime,1 Second},
    {ExtractionMixRate,1 RPM},
    {ExtractionMixVolume,1*Microliter},
    {SettlingTime,1 Second},
    {CentrifugeTime,1 Second},
    {ExtractionBoundaryVolume,1 Microliter}
  };

  (* There are still a few options that we need to check the precisions of though. *)
  {roundedExperimentOptions,optionPrecisionTests} = If[gatherTests,
    (*If we are gathering tests *)
    RoundOptionPrecision[Association@@listedOptions,optionPrecisions[[All,1]],optionPrecisions[[All,2]],Output->{Result,Tests}],
    (* Otherwise *)
    {RoundOptionPrecision[Association@@listedOptions,optionPrecisions[[All,1]],optionPrecisions[[All,2]]],{}}
  ];

  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptionsExceptSolventAdditions = OptionsHandling`Private`mapThreadOptions[ExperimentLiquidLiquidExtraction,roundedExperimentOptions];

  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  mapThreadFriendlyOptions = If[
    MatchQ[Lookup[roundedExperimentOptions, SolventAdditions], Except[Automatic]],
    Module[{solventAdditionsInput},

      solventAdditionsInput = Lookup[roundedExperimentOptions, SolventAdditions];

      MapThread[
        Function[{options, index},
          Merge[
            {
              options,
              <|
                SolventAdditions -> solventAdditionsInput[[index]]
              |>
            },
            Last
          ]
        ],
        {mapThreadFriendlyOptionsExceptSolventAdditions, Range[1, Length[mapThreadFriendlyOptionsExceptSolventAdditions]]}
      ]

    ],
    mapThreadFriendlyOptionsExceptSolventAdditions
  ];

  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  If[
    MatchQ[Lookup[roundedExperimentOptions, SolventAdditions], Except[Automatic]],
    Module[{solventAdditionsInput},

      solventAdditionsInput = Lookup[roundedExperimentOptions, SolventAdditions];

      mapThreadFriendlyOptions = MapThread[
        Function[{options, index},
          Merge[
            {
              options,
              <|
                SolventAdditions -> solventAdditionsInput[[index]]
              |>
            },
            Last
          ]
        ],
        {mapThreadFriendlyOptions, Range[1, Length[mapThreadFriendlyOptions]]}
      ]

    ]
  ];

  (* -- DOWNLOAD -- *)

  (* NOTE: All fields downloaded below should already be included in the cache passed down to us by the main function. *)
  sampleFields = DeleteDuplicates[Flatten[{Analytes, Name, Density, Container, Composition, Position, Volume, $PredictSamplePhaseSampleFields}]];
  samplePacketFields = Packet@@sampleFields;
  sampleModelFields = DeleteDuplicates[Flatten[{Name, Composition, Density}]];
  sampleModelPacketFields = Packet@@sampleModelFields;
  moleculeFields = DeleteDuplicates@Flatten[{Density, $PredictSamplePhaseMoleculeFields}];
  containerObjectFields = {Contents, Model, Name};
  containerObjectPacketFields = Packet@@containerObjectFields;
  containerModelFields = {VolumeCalibrations, MaxCentrifugationForce, Footprint, MaxVolume, Positions, Name, WellDimensions, WellDiameter, InternalDiameter, InternalDimensions};
  containerModelPacketFields = Packet@@containerModelFields;

  {
    samplePackets,
    sampleContainerPackets,
    sampleContainerModelPackets,
    sampleSolventPackets,
    sampleCompositionMoleculePackets,
    sampleSolventCompositionMoleculePackets,
    sampleAnalytesMoleculePackets,
    containerModelPackets,
    containerModelFromObjectPackets,
    additiveSampleModelPackets,
    additiveSamplePackets
  } = Quiet[
    Download[
      {
        mySamples,
        mySamples,
        mySamples,
        mySamples,
        mySamples,
        mySamples,
        mySamples,
        DeleteDuplicates@Flatten[{
          Cases[
            Flatten[Lookup[myOptions, {ExtractionContainer, TargetContainerOut, ImpurityContainerOut, ExtractionDevice}]],
            ObjectP[Model[Container]]
          ],
          PreferredContainer[All, LiquidHandlerCompatible -> True, Type -> All],
          (* Model[Container, Plate, PhaseSeparator, "Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits"] *)
          Model[Container, Plate, PhaseSeparator, "id:jLq9jXqrWW11"]
        }],
        DeleteDuplicates@Cases[
          Flatten[Lookup[myOptions, {ExtractionContainer, TargetContainerOut, ImpurityContainerOut, ExtractionDevice}]],
          ObjectP[Object[Container]]
        ],
        DeleteDuplicates@Cases[
          (* NOTE: Include the default solvents that we can use since we want their packets as well. *)
          (* Model[Sample, "Milli-Q water"] *) (* Model[Sample, "Ethyl acetate, HPLC Grade"] *) (* Model[Sample, "Chloroform"] *)
          Flatten[{Lookup[myOptions, {SolventAdditions, DemulsifierAdditions, AqueousSolvent, OrganicSolvent, Demulsifier}],Model[Sample, "id:8qZ1VWNmdLBD"], Model[Sample, "id:9RdZXvKBeeGK"], Model[Sample, "id:eGakld01zzXo"]}],
          ObjectP[Model[Sample]]
        ],
        DeleteDuplicates@Cases[
          Flatten[Lookup[myOptions, {SolventAdditions, DemulsifierAdditions, AqueousSolvent, OrganicSolvent, Demulsifier}]],
          ObjectP[Object[Sample]]
        ]
      },
      {
        {samplePacketFields},
        {Packet[Container[containerObjectFields]]},
        {Packet[Container[Model][containerModelFields]]},
        {Packet[Solvent[sampleModelFields]]},
        {Packet[Composition[[All,2]][moleculeFields]]},
        {Packet[Solvent[Composition][[All,2]][moleculeFields]]},
        {Packet[Analytes[moleculeFields]]},
        {containerModelPacketFields, Packet[VolumeCalibrations[{CalibrationFunction, Anomalous, Deprecated, DeveloperObject, Name, LiquidLevelDetectorModel}]]},
        {containerObjectPacketFields, Packet[Model[containerModelFields]], Packet[Model[VolumeCalibrations][{CalibrationFunction, Anomalous, Deprecated, DeveloperObject, Name, LiquidLevelDetectorModel}]]},
        {sampleModelPacketFields},
        {sampleFields, Packet[Model[sampleModelPacketFields]]}
      },
      Cache -> cache,
      Simulation -> currentSimulation
    ],
    {Download::FieldDoesntExist}
  ];

  {
    samplePackets,
    sampleContainerPackets,
    sampleContainerModelPackets,
    sampleSolventPackets,
    sampleCompositionMoleculePackets,
    sampleSolventCompositionMoleculePackets,
    sampleAnalytesMoleculePackets,
    containerModelPackets,
    containerModelFromObjectPackets,
    additiveSampleModelPackets,
    additiveSamplePackets
  }=Flatten/@{
    samplePackets,
    sampleContainerPackets,
    sampleContainerModelPackets,
    sampleSolventPackets,
    sampleCompositionMoleculePackets,
    sampleSolventCompositionMoleculePackets,
    sampleAnalytesMoleculePackets,
    containerModelPackets,
    containerModelFromObjectPackets,
    additiveSampleModelPackets,
    additiveSamplePackets
  };

  cacheBall=FlattenCachePackets[{
    samplePackets,
    sampleContainerPackets,
    sampleContainerModelPackets,
    sampleSolventPackets,
    sampleCompositionMoleculePackets,
    sampleSolventCompositionMoleculePackets,
    sampleAnalytesMoleculePackets,
    containerModelPackets,
    containerModelFromObjectPackets,
    additiveSampleModelPackets,
    additiveSamplePackets
  }];
  fastCacheBall = makeFastAssocFromCache[cacheBall];

  (*-- CONFLICTING OPTIONS CHECKS --*)

  (*-- RESOLVE EXPERIMENT OPTIONS --*)

  (* Resolve WorkCell. *)
  (* Resolve the work cell that we're going to operator on. *)
  allowedWorkCells=resolveLiquidLiquidExtractionWorkCell[mySamples, listedOptions];

  resolvedWorkCell=Which[
    MatchQ[Lookup[myOptions, WorkCell], Except[Automatic]],
      Lookup[myOptions, WorkCell],
    Length[allowedWorkCells]>0,
      First[allowedWorkCells],
    True,
      STAR
  ];

  (* Resolve TargetAnalyte. *)
  {resolvedTargetAnalytes, ambiguousAnalyteWarnings} = Transpose@MapThread[
    Function[{samplePacket, options},
      Which[
        (* Use the user specified option. *)
        MatchQ[Lookup[options, TargetAnalyte], Except[Automatic]],
          {Lookup[options, TargetAnalyte], False},
        (* Use the first member of the Analytes field, if filled out. *)
        Length[Lookup[samplePacket, Analytes]] > 0,
          {FirstOrDefault[Download[Lookup[samplePacket, Analytes], Object]], Length[Lookup[samplePacket, Analytes]] > 1},
        (* Use the first member of composition that's in concentration or mass concentration (solvent molecules like water should stay in volume percent). *)
        MemberQ[Lookup[samplePacket, Composition], {GreaterP[0 Molar], ObjectP[]}],
          Module[{potentialMolecules},
            potentialMolecules = Cases[Lookup[samplePacket, Composition], {ConcentrationP | MassConcentrationP, molecule:ObjectP[]}:>molecule];

            {
              FirstOrDefault[Download[potentialMolecules, Object]],
              Length[potentialMolecules] > 1
            }
          ],
        True,
          {
            Null,
            False
          }
      ]
    ],
    {samplePackets, mapThreadFriendlyOptions}
  ];

  (* Throw Warning::AmbiguousAnalyte if the analyte is ambiguous. *)
  If[MemberQ[ambiguousAnalyteWarnings, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
    Message[
      Warning::AmbiguousAnalyte,
      ObjectToString[PickList[mySamples, ambiguousAnalyteWarnings], Cache -> cacheBall],
      ObjectToString[PickList[resolvedTargetAnalytes, ambiguousAnalyteWarnings], Cache -> cacheBall]
    ];
  ];

  ambiguousAnalyteTest = If[gatherTests,
    Module[{ambiguousAnalyteSamples, failingTest, passingTest},
      ambiguousAnalyteSamples = PickList[mySamples, ambiguousAnalyteWarnings];

      failingTest = If[Length[ambiguousAnalyteSamples] == 0,
        Nothing,
        Warning["Our input samples " <> ObjectToString[ambiguousAnalyteSamples, Cache -> cacheBall] <> " do not have ambiguous analytes to choose between when determining the TargetAnalyte for the liquid liquid extraction:", True, False]
      ];

      passingTest = If[Length[ambiguousAnalyteSamples] == Length[mySamples],
        Nothing,
        Warning["Our input samples " <> ObjectToString[Complement[mySamples, ambiguousAnalyteSamples], Cache -> cacheBall] <> " do not have ambiguous analytes to choose between when determining the TargetAnalyte for the liquid liquid extraction:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* Predict the sample phases for all of the samples up front. Calling the function once listably is faster than multiple times. *)
  {allPredictedSamplePhases, allPredictedSamplePhaseVolumes, allPredictedSamplePhaseMolecules} = PredictSamplePhase[
    mySamples,
    Cache -> cacheBall,
    Simulation -> currentSimulation,
    Output -> {Phase, Volume, Molecule}
  ];

  (* Get all of the molecules in any solvents that are specified by the user. *)
  solventMolecules = DeleteDuplicates@Download[
    Cases[Lookup[Flatten[{additiveSamplePackets, additiveSampleModelPackets}], Composition], ObjectP[Model[Molecule]], Infinity],
    Object
  ];

  (* Predict all destination phases for all target molecules up front. Calling the function once listably is faster than multiple times. *)
  (* If the LogP > 0, it will end up in the organic layer, if the LogP < 0, it will end up in the aqueous layer. *)
  (* NOTE: We call SimulateLogPartitionCoefficient instead of PredictDestinationPhase to get more information about the strength of the *)
  (* target analyte concentration. *)
  (* NOTE: We will throw our own warning when no LogP data is available. *)
  (* TODO: Also simulate LogP when given solvents?? *)
  allPredictedLogPs = Quiet[
    SimulateLogPartitionCoefficient[Join[resolvedTargetAnalytes, solventMolecules], Cache -> cacheBall, Simulation -> currentSimulation],
    {Error::NoAvailableLogP, Error::InvalidInput}
  ];

  {predictedAnalyteLogPs, solventMoleculeLogPs} = TakeDrop[allPredictedLogPs, Length[resolvedTargetAnalytes]];

  (* Create a lookup between any specified solvents and their classification (Aqueous/Organic). *)
  specifiedSolventToTypeLookup=Map[
    Function[{solvent},
      Module[{modelPacket, molecule, predictedLogP},
        (* Get the model packet. *)
        modelPacket=If[MatchQ[solvent, ObjectP[Model[Sample]]],
          fetchPacketFromFastAssoc[solvent, fastCacheBall],
          fetchModelPacketFromFastAssoc[solvent, fastCacheBall]
        ];

        (* Get the first molecule that shows up in the Composition field. *)
        molecule=Download[FirstOrDefault[Lookup[modelPacket, Composition][[All,2]], ObjectP[Model[Molecule]]], Object];

        predictedLogP=Lookup[Rule@@@Transpose[{solventMolecules, solventMoleculeLogPs}], molecule];

        Rule[
          solvent,
          predictedLogP /. {GreaterEqualP[0] -> Organic, LessP[0] -> Aqueous, _ -> Unknown}
        ]
      ]
    ],
    DeleteDuplicates@Cases[
      Flatten[Lookup[myOptions, {SolventAdditions, AqueousSolvent, OrganicSolvent}]],
      ObjectP[{Model[Sample], Object[Sample]}]
    ]
  ];

  (* Resolve SamplePhase and TargetPhase. *)
  {
    resolvedSamplePhases,
    resolvedTargetPhases,
    targetPhaseWeakAffinityWarnings,
    noLogPAvailableWarnings
  } = Transpose@MapThread[
    Function[{predictedSamplePhase, predictedLogP, targetAnalyte, options},
      Module[{samplePhase, targetPhase, targetPhaseWeakAffinityWarning, noLogPAvailableWarning},
        (* Resolve SamplePhase. *)
        samplePhase = If[MatchQ[Lookup[options, SamplePhase], SamplePhaseP],
          Lookup[options, SamplePhase],
          predictedSamplePhase
        ];

        (* Resolve TargetPhase. *)
        (* If the predicted LogP value is within $AqueousLogPThreshold/$OrganicLogPThreshold, warn the user that *)
        (* the target analyte has a weak affinity and that more extraction rounds will be necessary for a good separation. *)
        {targetPhase, targetPhaseWeakAffinityWarning} = Which[
          MatchQ[Lookup[options, TargetPhase], TargetPhaseP],
            {Lookup[options, TargetPhase], False},
          MatchQ[predictedLogP, GreaterEqualP[0]] && MatchQ[predictedLogP, LessP[$OrganicLogPThreshold]],
            {Organic, True},
          MatchQ[predictedLogP, GreaterEqualP[0]],
            {Organic, False},
          MatchQ[predictedLogP, LessP[0]] && MatchQ[predictedLogP, GreaterP[$AqueousLogPThreshold]],
            {Aqueous, True},
          MatchQ[predictedLogP, LessP[0]],
            {Aqueous, False},
          True,
            {Aqueous, False}
        ];

        noLogPAvailableWarning = And[
          (* No LogP available *)
          !MatchQ[predictedLogP, _?NumericQ],
          (* The user didn't set the TargetPhase *)
          !MatchQ[Lookup[options, TargetPhase], TargetPhaseP],
          (* TargetAnalyte is set (if it's Null, there's another message complaining about that). *)
          !MatchQ[targetAnalyte, Null]
        ];

        {
          samplePhase,
          targetPhase,
          targetPhaseWeakAffinityWarning,
          noLogPAvailableWarning
        }
      ]
    ],
    {allPredictedSamplePhases, predictedAnalyteLogPs, resolvedTargetAnalytes, mapThreadFriendlyOptions}
  ];

  (* Throw Warning::WeakTargetAnalytePhaseAffinity. *)
  If[MemberQ[targetPhaseWeakAffinityWarnings, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
    Message[
      Warning::WeakTargetAnalytePhaseAffinity,
      ObjectToString[PickList[resolvedTargetAnalytes, targetPhaseWeakAffinityWarnings], Cache -> cacheBall],
      ObjectToString[PickList[resolvedTargetPhases, targetPhaseWeakAffinityWarnings], Cache -> cacheBall],
      ObjectToString[PickList[predictedAnalyteLogPs, targetPhaseWeakAffinityWarnings], Cache -> cacheBall]
    ];
  ];

  targetPhaseWeakAffinityTest=If[gatherTests,
    Module[{affectedMolecules, failingTest, passingTest},
      affectedMolecules = PickList[resolvedTargetAnalytes, targetPhaseWeakAffinityWarnings];

      failingTest = If[Length[affectedMolecules] == 0,
        Nothing,
        Warning["The TargetAnalytes " <> ObjectToString[affectedMolecules, Cache -> cacheBall] <> " do not have a weak affinity to the TargetPhases, according to the predicted Log Partition Coefficients:", True, False]
      ];

      passingTest = If[Length[affectedMolecules] == Length[mySamples],
        Nothing,
        Warning["Our input samples " <> ObjectToString[Complement[resolvedTargetAnalytes, affectedMolecules], Cache -> cacheBall] <> " do not have a weak affinity to the TargetPhases, according to the predicted Log Partition Coefficients:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* Throw Warning::NoAvailableLogPDefaultingToAqueous. *)
  If[MemberQ[noLogPAvailableWarnings, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
    Message[
      Warning::NoAvailableLogPDefaultingToAqueous,
      ObjectToString[PickList[resolvedTargetAnalytes, noLogPAvailableWarnings], Cache -> cacheBall],
      ObjectToString[PickList[mySamples, noLogPAvailableWarnings], Cache -> cacheBall]
    ];
  ];

  noAvailableLogPTest=If[gatherTests,
    Module[{affectedMolecules, failingTest, passingTest},
      affectedMolecules = PickList[resolvedTargetAnalytes, noLogPAvailableWarnings];

      failingTest = If[Length[affectedMolecules] == 0,
        Nothing,
        Warning["The TargetAnalytes " <> ObjectToString[affectedMolecules, Cache -> cacheBall] <> " have LogP data available to predict the TargetPhase they will end up in (Aqueous or Organic) or the user has manually specified the TargetPhase option for the molecule:", True, False]
      ];

      passingTest = If[Length[affectedMolecules] == Length[mySamples],
        Nothing,
        Warning["Our input samples " <> ObjectToString[Complement[resolvedTargetAnalytes, affectedMolecules], Cache -> cacheBall] <> " have LogP data available to predict the TargetPhase they will end up in (Aqueous or Organic) or the user has manually specified the TargetPhase option for the molecule:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* Figure out the TargetAnalyte options that we had to resolve to Null. *)
  missingTargetAnalyteBools = MapThread[
    Function[{targetAnalyte, options},
      And[
        (* resolvedTargetAnalyte value is resolved to Null *)
        MatchQ[targetAnalyte, Null],
        (* TargetAnalyte is set by the user to something besides Null or Automatic. *)
        MatchQ[Lookup[options, TargetAnalyte], Except[Null]],
        (* TargetPhase is not set *)
        MatchQ[Lookup[options, TargetPhase], Except[TargetPhaseP]]
      ]
    ],
    {resolvedTargetAnalytes, mapThreadFriendlyOptions}
  ];

  (* Throw Warning::NoTargetAnalyteDefaultingToAqueous. *)
  If[MemberQ[missingTargetAnalyteBools, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
    Message[
      Warning::NoTargetAnalyteDefaultingToAqueous,
      ObjectToString[PickList[mySamples, missingTargetAnalyteBools], Cache -> cacheBall]
    ];
  ];

  noTargetAnalyteTest=If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = PickList[mySamples, missingTargetAnalyteBools];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Warning["The input samples " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " have a TargetAnalyte chosen (either specified by the user or automatically calculated from the Analytes/Composition field) for the liquid liquid extraction:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Warning["Our input samples " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " have a TargetAnalyte chosen (either specified by the user or automatically calculated from the Analytes/Composition field) for the liquid liquid extraction:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  {
    resolvedExtractionTechniques,
    resolvedExtractionDevices,
    resolvedSelectionStrategies,
    resolvedIncludeBoundaries,
    resolvedSampleVolumes,
    resolvedWorkingSampleVolumes,
    resolvedAddAqueousSolvents,
    resolvedAqueousSolvents,
    resolvedAqueousSolventVolumes,
    resolvedAqueousSolventRatios,
    resolvedAddOrganicSolvents,
    resolvedOrganicSolvents,
    resolvedOrganicSolventVolumes,
    resolvedOrganicSolventRatios,
    resolvedSolventAdditions,
    resolvedTargetLayers,
    unknownTargetLayerWarnings,
    resolvedDemulsifierAdditions,
    resolvedDemulsifiers,
    resolvedDemulsifierAmounts,
    resolvedCentrifugeBools,
    resolvedCentrifugeInstruments,
    resolvedCentrifugeIntensitys,
    resolvedCentrifugeTimes,
    resolvedExtractionTransferLayers,
    resolvedExtractionMixTypes,
    resolvedExtractionMixTimes,
    resolvedExtractionMixRates,
    resolvedNumberOfExtractionMixes,
    resolvedExtractionMixVolumes,
    resolvedMaxExtractionContainerVolumes,
    resolvedAqueousLayerVolumes,
    resolvedOrganicLayerVolumes,
    resolvedSampleAqueousPhaseDensities,
    resolvedSampleOrganicPhaseDensities,
    resolvedAqueousSolventDensities,
    resolvedOrganicSolventDensities
  }=Transpose@MapThread[
    Function[{samplePacket, sampleContainerModelPacket, sampleSolventPacket, samplePhase, targetPhase, predictedSamplePhaseMolecules, predictedSamplePhaseVolumes, options},
      Module[
        {extractionTechnique, sampleVolume, workingSampleVolume, aqueousSolvent, aqueousSolventVolume, aqueousSolventRatio, includeBoundary,
          addAqueousSolvent, addOrganicSolvent, sampleAqueousPhaseDensity, sampleOrganicPhaseDensity, aqueousSolventDensity, organicSolvent,
          organicSolventDensity, organicSolventVolume, organicSolventRatio, targetLayer, unknownTargetLayerWarning,
          demulsifier, demulsifierAmount, centrifugeBool, centrifugeInstrument, centrifugeIntensity, centrifugeTime,
          extractionTransferLayer, extractionMixType, extractionMixTime, extractionMixRate, numberOfExtractionMixes, extractionMixVolume,
          maxExtractionContainerVolume, aqueousLayerVolumes, organicLayerVolumes, extractionContainerVolumes, extractionDevice,
          selectionStrategy, solventAdditions, demulsifierAdditions},

        (* Get the density for the sample's aqueous and organic phase. *)
        {sampleAqueousPhaseDensity, sampleOrganicPhaseDensity}=Module[
          {aqueousPhaseMolecules, organicPhaseMolecules, aqueousPhaseMoleculeDensities, organicPhaseMoleculeDensities},

          (* Get the molecules that are in each phase. *)
          aqueousPhaseMolecules=Lookup[predictedSamplePhaseMolecules, Aqueous];
          organicPhaseMolecules=Lookup[predictedSamplePhaseMolecules, Organic];

          (* Get the densities for these molecules. *)
          aqueousPhaseMoleculeDensities=Map[
            (Lookup[fetchPacketFromFastAssoc[#, fastCacheBall], Density]&),
            aqueousPhaseMolecules
          ];
          organicPhaseMoleculeDensities=Map[
            (Lookup[fetchPacketFromFastAssoc[#, fastCacheBall], Density]&),
            organicPhaseMolecules
          ];

          (* If there's more than one molecule, then we don't know what the density is. *)
          {
            If[Length[Cases[aqueousPhaseMoleculeDensities, DensityP]]==1,
              FirstOrDefault@Cases[aqueousPhaseMoleculeDensities, DensityP],
              Null
            ],
            If[Length[Cases[organicPhaseMoleculeDensities, DensityP]]==1,
              FirstOrDefault@Cases[organicPhaseMoleculeDensities, DensityP],
              Null
            ]
          }
        ];

        (* By default, try to use a phase separation, unless the user is forcing us to use a Pipette. *)
        extractionTechnique=Which[
          MatchQ[Lookup[options, ExtractionTechnique], ExtractionTechniqueP],
            Lookup[options, ExtractionTechnique],
          (* These options tell us to use a Pipette. *)
          MatchQ[Lookup[options, IncludeBoundary], Except[Automatic|Null]] || MatchQ[Lookup[options, ExtractionBoundaryVolume], Except[Automatic|Null]],
            Pipette,
          (* This option can only be set to a phase separator plate. *)
          MatchQ[Lookup[options, ExtractionDevice], Except[Automatic|Null]],
            PhaseSeparator,
          (* If the sample is biphasic and the organic phase isn't on the bottom, then we can't use a phase separator. *)
          MatchQ[samplePhase, Biphasic] && MatchQ[sampleAqueousPhaseDensity, GreaterP[sampleOrganicPhaseDensity]],
            Pipette,
          (* If the user has specified the OrganicSolvent option for this sample, the organic layer needs to be more dense *)
          (* in order for us to use a phase separator. *)
          And[
            MatchQ[Lookup[options, OrganicSolvent], ObjectP[{Model[Sample], Object[Sample]}]],
            MatchQ[Lookup[fetchPacketFromFastAssoc[Lookup[options, OrganicSolvent], fastCacheBall], Density], DensityP],
            MatchQ[sampleAqueousPhaseDensity, GreaterP[Lookup[fetchPacketFromFastAssoc[Lookup[options, OrganicSolvent], fastCacheBall], Density]]]
          ],
            Pipette,
          (* If the user has specified the Aqueous option for this sample, the organic layer needs to be more dense *)
          (* in order for us to use a phase separator. *)
          And[
            MatchQ[Lookup[options, AqueousSolvent], ObjectP[{Model[Sample], Object[Sample]}]],
            MatchQ[Lookup[fetchPacketFromFastAssoc[Lookup[options, AqueousSolvent], fastCacheBall], Density], DensityP],
            MatchQ[sampleOrganicPhaseDensity, LessP[Lookup[fetchPacketFromFastAssoc[Lookup[options, AqueousSolvent], fastCacheBall], Density]]]
          ],
            Pipette,
          (* If the sample is organic, make sure that the organic phase has a density greater than water (the default aqueous solvent) *)
          (* otherwise, we can't use the phase separator. *)
          And[
            MatchQ[samplePhase, Organic],
            MatchQ[sampleOrganicPhaseDensity, LessP[0.997 Gram/Milliliter]]
          ],
            Pipette,
          (* Otherwise, we could go either way -- default to using a phase separator. *)
          True,
            PhaseSeparator
        ];

        (* Use the default phase separator if we're extraction via phase separator. *)
        extractionDevice=Which[
          MatchQ[Lookup[options, ExtractionDevice], Except[Automatic]],
            Lookup[options, ExtractionDevice],
          MatchQ[extractionTechnique, PhaseSeparator],
            (* Model[Container, Plate, PhaseSeparator, "Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits"] *)
            Model[Container, Plate, PhaseSeparator, "id:jLq9jXqrWW11"],
          True,
            Null
        ];

        selectionStrategy=Which[
          MatchQ[Lookup[options, SelectionStrategy], Except[Automatic]],
            Lookup[options, SelectionStrategy],
          (* If NumberOfExtractions is set to 1, then set to Null (this option only applies if there are multiple rounds of extraction). *)
          MatchQ[Lookup[options, NumberOfExtractions], 1],
            Null,

          (* If SolventAdditions or AqueousSolvent/OrganicSolvent is specified, then the solvent(s) specified are used *)
          (* to infer the SelectionStrategy (if the phase of the solvent being added matches TargetPhase, then SelectionStrategy *)
          (* is set to Positive (extraction is done on the impurity layer), otherwise SelectionStrategy is set to Negative). *)
          MatchQ[Lookup[options, AqueousSolvent], None] && MatchQ[targetPhase, Aqueous],
            Negative,
          (* Implies that we're only adding Aqueous solvent and therefore we must be extracting on the target phase. *)
          MatchQ[Lookup[options, OrganicSolvent], None] && MatchQ[targetPhase, Organic],
            Negative,
          (* Implies that we're only adding Organic solvent and therefore we must be extracting on the impurity phase. *)
          MatchQ[Lookup[options, AqueousSolvent], None] && MatchQ[targetPhase, Organic],
            Positive,
          (* Implies that we're only adding Aqueous solvent and therefore we must be extracting on the impurity phase. *)
          MatchQ[Lookup[options, OrganicSolvent], None] && MatchQ[targetPhase, Aqueous],
            Positive,

          (* If the user has set SolventAdditions, figure out if only one of Aqueous or Organic solvent is specified for the *)
          (* rest of the extraction rounds. *)
          MatchQ[Lookup[options, SolventAdditions], _List?(Length[#]>1&)],
            Module[{restSolvents, solventTypes},
              (* See if there is an aqueous solvent in the rest of our extraction rounds. *)
              restSolvents=RestOrDefault[Lookup[options, SolventAdditions], {}];

              solventTypes=(Lookup[specifiedSolventToTypeLookup, #]&)/@restSolvents;

              Which[
                (* Solvent type opposite of the target phase -- implies that we must be extracting on the target phase. *)
                MatchQ[solventTypes, {Organic..}] && MatchQ[targetPhase, Aqueous],
                  Negative,
                MatchQ[solventTypes, {Aqueous..}] && MatchQ[targetPhase, Organic],
                  Negative,

                (* Solvent type matches of the target phase -- implies that we must be extracting on the impurity phase. *)
                MatchQ[solventTypes, {Organic..}] && MatchQ[targetPhase, Organic],
                  Positive,
                MatchQ[solventTypes, {Aqueous..}] && MatchQ[targetPhase, Aqueous],
                  Positive,

                (* User gave us nonsense, just default to Positive. *)
                True,
                  Positive
              ]
            ],

          (* Default to Positive selection. *)
          True,
            Positive
        ];

        (* Resolve IncludeBoundary *)
        includeBoundary=Which[
          MatchQ[Lookup[options, IncludeBoundary], Except[Automatic]],
            Lookup[options, IncludeBoundary],

          (* Automatically set to False if ExtractionTechnique is set to Pipette. *)
          MatchQ[extractionTechnique, Pipette],
            ConstantArray[False, Lookup[options, NumberOfExtractions]],

          (* Otherwise, set to Null since IncludeBoundary does not apply when ExtractionTechnique is PhaseSeparator since *)
          (* the hydrophobic frit of the phase separator automatically will only allow the organic phase to pass through. *)
          True,
            Null
        ];

        (* Resolve Centrifuge. *)
        centrifugeBool=Which[
          MatchQ[Lookup[options, Centrifuge], Except[Automatic]],
            Lookup[options, Centrifuge],
          (* Automatically set to True any of the other centrifuge options are specified (CentrifugeInstrument, CentrifugeIntensity, CentrifugeTime). *)
          Or[
            MatchQ[Lookup[options, CentrifugeInstrument], Except[Automatic|Null]],
            MatchQ[Lookup[options, CentrifugeIntensity], Except[Automatic|Null]],
            MatchQ[Lookup[options, CentrifugeTime], Except[Automatic|Null]]
          ],
            True,
          (* Also automatically set to True if ExtractionTechnique -> Pipette and the samples are in a centrifuge compatible container (the Footprint of the container is set to Plate). *)
          MatchQ[extractionTechnique, Pipette] && MatchQ[Lookup[fetchModelPacketFromFastAssoc[Lookup[samplePacket, Container], fastCacheBall], Footprint], Plate],
            True,
          (* Otherwise, no need to centrifuge. *)
          True,
            False
        ];

        (* Resolve CentrifugeInstrument. *)
        centrifugeInstrument=Which[
          MatchQ[Lookup[options, CentrifugeInstrument], Except[Automatic]],
            Lookup[options, CentrifugeInstrument],
          MatchQ[centrifugeBool, True] && MatchQ[resolvedWorkCell, bioSTAR|microbioSTAR],
            Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (* Model[Instrument, Centrifuge, "HiG4"] *)
          MatchQ[centrifugeBool, True] && MatchQ[resolvedWorkCell, STAR],
            Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"], (* Model[Instrument, Centrifuge, "VSpin"] *)
          True,
            Null
        ];

        (* Resolve Centrifuge Intensity. *)
        centrifugeIntensity=Which[
          MatchQ[Lookup[options, CentrifugeIntensity], Except[Automatic]],
            Lookup[options, CentrifugeIntensity],
          MatchQ[centrifugeInstrument, ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]], (* Model[Instrument, Centrifuge, "HiG4"] *)
            If[!MatchQ[Lookup[sampleContainerModelPacket, MaxCentrifugationForce], Null],
              Lookup[sampleContainerModelPacket, MaxCentrifugationForce],
              3600 GravitationalAcceleration
            ],
          MatchQ[centrifugeInstrument, ObjectP[Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"]]], (* Model[Instrument, Centrifuge, "VSpin"] *)
            If[!MatchQ[Lookup[sampleContainerModelPacket, MaxCentrifugationForce], Null],
              Lookup[sampleContainerModelPacket, MaxCentrifugationForce],
              3000 RPM
            ],
          True,
            Null
        ];

        (* Resolve Centrifuge Time. *)
        centrifugeTime=Which[
          MatchQ[Lookup[options, CentrifugeTime], Except[Automatic]],
            Lookup[options, CentrifugeTime],
          MatchQ[centrifugeBool, True],
            2 Minute,
          True,
            Null
        ];

        (* Resolve SampleVolume. *)
        sampleVolume = Which[
          MatchQ[Lookup[options, SampleVolume], Except[Automatic]],
            Lookup[options, SampleVolume],
          (* Automatically set to either half the volume of the ExtractionContainer or the Volume of the input sample, *)
          (* which ever is smaller, if ExtractionContainer is specified. *)
          MatchQ[Lookup[options, ExtractionContainer], Except[Automatic|Null]],
            Module[{containerModelPacket, convertedContainerModelPacket},
              containerModelPacket = Which[
                MatchQ[Lookup[options, ExtractionContainer], ObjectP[Model[Container]]],
                  Lookup[fetchPacketFromFastAssoc[Lookup[options, ExtractionContainer], fastCacheBall], MaxVolume],
                MatchQ[Lookup[options, ExtractionContainer], ObjectP[Object[Container]]],
                  Lookup[fetchModelPacketFromFastAssoc[Lookup[options, ExtractionContainer], fastCacheBall], MaxVolume],
                MatchQ[Lookup[options, ExtractionContainer], {_Integer, ObjectP[Model[Container]]}],
                  Lookup[fetchPacketFromFastAssoc[Lookup[options, ExtractionContainer][[2]], fastCacheBall], MaxVolume],
                True,
                  $Failed
              ];
              convertedContainerModelPacket = If[MatchQ[containerModelPacket, VolumeP],
                UnitConvert[containerModelPacket, Microliter],
                $Failed
              ];
              Which[
                MatchQ[Lookup[samplePacket, Volume], VolumeP] && MatchQ[convertedContainerModelPacket, VolumeP],
                  Min[{UnitConvert[SafeRound[Lookup[samplePacket, Volume], 1 Microliter], Microliter], convertedContainerModelPacket * 0.5}],
                MatchQ[convertedContainerModelPacket, VolumeP],
                  convertedContainerModelPacket * 0.5,
                MatchQ[Lookup[samplePacket, Volume], VolumeP],
                  UnitConvert[SafeRound[Lookup[samplePacket, Volume], 1 Microliter], Microliter],
                True,
                  Null
              ]
            ],
          (* If centrifugation is turned on but the sample isn't in a plate or if the sample fills up the well by more than *)
          (* half and the input phase isn't biphasic, aliquot 1mL by default (unless the sample volume is less). *)
          And[
            MatchQ[centrifugeBool, True],
            Or[
              !MatchQ[Lookup[sampleContainerModelPacket, Footprint], Plate],
              And[
                MatchQ[Lookup[samplePacket, Volume], GreaterP[Lookup[sampleContainerModelPacket, MaxVolume] / 2]],
                !MatchQ[samplePhase, Biphasic]
              ]
            ]
          ],
            If[MatchQ[Lookup[samplePacket, Volume], VolumeP],
              Min[{UnitConvert[SafeRound[Lookup[samplePacket, Volume], 1 Microliter], Microliter], 1 Milliliter}],
              1 Milliliter
            ],
          True,
            Null
        ];

        (* Get the working sample volume. *)
        workingSampleVolume = Which[
          MatchQ[sampleVolume, VolumeP],
            sampleVolume,
          MatchQ[Lookup[samplePacket, Volume], VolumeP],
            UnitConvert[SafeRound[Lookup[samplePacket, Volume], 1 Microliter], Microliter],
          (* If we have no clue, just default to 1 mL. *)
          True,
            1 Milliliter
        ];

        (* NOTE: This is an internal variable that we use to help us do option resolving. *)
        (* This represents when aqueous solvents SHOULD be added during the extraction. *)
        addAqueousSolvent=Module[{addDuringFirstRoundQ, addDuringRestRoundsQ},
          addDuringFirstRoundQ=Which[
            (* The input sample is in Organic or Unknown solvent so we need Aqueous Solvent during the first round. *)
            MatchQ[samplePhase, Organic|Unknown],
              True,
            (* Tnput sample is Aqueous or Biphasic so we don't need Aqueous Solvent during the first round. *)
            MatchQ[samplePhase, Aqueous|Biphasic],
              False,
            (* Catch All. *)
            True,
              False
          ];

          addDuringRestRoundsQ=Which[
            (* If we don't have more than 1 extraction round, there is nothing to add to. *)
            MatchQ[Lookup[options, NumberOfExtractions], 1],
              False,
            (* Positive means that we extract on the impurity layer, so we need more Aqueous solvent. *)
            MatchQ[targetPhase, Aqueous] && MatchQ[selectionStrategy, Positive],
              True,
            (* Negative means that we extract on the target layer, so we need more Aqueous solvent. *)
            MatchQ[targetPhase, Organic] && MatchQ[selectionStrategy, Negative],
              True,
            (* Catch all *)
            True,
              False
          ];

          Which[
            addDuringFirstRoundQ && addDuringRestRoundsQ,
              All,
            addDuringFirstRoundQ,
              First,
            addDuringRestRoundsQ,
              Rest,
            True,
              False
          ]
        ];

        (* Resolve AqueousSolvent. *)
        aqueousSolvent=Which[
          MatchQ[Lookup[options, AqueousSolvent], Except[Automatic]],
            Lookup[options, AqueousSolvent],
          (* Did the user specify the SolventAdditions option? If so, was there an aqueous solvent specified? *)
          And[
            MatchQ[Lookup[options, SolventAdditions], Except[Automatic]],
            MemberQ[(Lookup[specifiedSolventToTypeLookup, #]&)/@ToList[Lookup[options, SolventAdditions]], Aqueous]
          ],
            Module[{solvents, solventPhases},
              solvents=ToList[Lookup[options, SolventAdditions]];

              solventPhases=(Lookup[specifiedSolventToTypeLookup, #]&)/@solvents;

              FirstCase[Transpose[{solvents, solventPhases}], {solvent_, Aqueous}:>solvent, Null]
            ],
          (* If AddAqueousSolvent is set to First, All, or Rest, Model[Sample, \"Milli-Q water\"] is used as the AqueousSolvent. *)
          MatchQ[addAqueousSolvent, First | All | Rest],
            Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
          (* Otherwise, set to None. *)
          True,
            None
        ];

        (* Resolve AqueousSolventVolume. *)
        aqueousSolventVolume=Which[
          MatchQ[Lookup[options, AqueousSolventVolume], Except[Automatic]],
            Lookup[options, AqueousSolventVolume],
          (* If AqueousSolventRatio is set, AqueousSolventVolume is calculated by multiplying 1/AqueousSolventRatio with the sample volume. *)
          MatchQ[Lookup[options, AqueousSolventRatio], _?NumericQ],
            SafeRound[1/Lookup[options, AqueousSolventRatio] * workingSampleVolume, 1 Microliter, AvoidZero -> True],
          (* Otherwise, if AddAqueousSolvent or AqueousSolvent is set, set to 20% of the volume of the sample being extracted. *)
          MatchQ[addAqueousSolvent, Except[False]] || MatchQ[aqueousSolvent, Except[None]],
            SafeRound[.2 * workingSampleVolume, 1 Microliter, AvoidZero -> True],
          True,
            Null
        ];

        (* Resolve AqueousSolventRatio. *)
        aqueousSolventRatio=Which[
          MatchQ[Lookup[options, AqueousSolventRatio], Except[Automatic]],
            Lookup[options, AqueousSolventRatio],
          (* If AqueousSolventVolume or AqueousSolvent are set, AqueousSolventRatio is calculated by dividing the sample volume by AqueousSolventVolume. *)
          MatchQ[aqueousSolventVolume, VolumeP] || MatchQ[aqueousSolvent, Except[None]],
            SafeRound[workingSampleVolume/aqueousSolventVolume, 10^-1, AvoidZero -> True],
          True,
            Null
        ];

        (* Resolve AddOrganicSolvent. *)
        addOrganicSolvent=Module[{addDuringFirstRoundQ, addDuringRestRoundsQ},
          addDuringFirstRoundQ=Which[
            (* The input sample is in Aqueous or Unknown solvent so we need Organic Solvent during the first round. *)
            MatchQ[samplePhase, Aqueous|Unknown],
              True,
            (* Tnput sample is Organic or Biphasic so we don't need Organic Solvent during the first round. *)
            MatchQ[samplePhase, Organic|Biphasic],
              False,
            (* Catch All. *)
            True,
              False
          ];

          addDuringRestRoundsQ=Which[
            (* If we don't have more than 1 extraction round, there is nothing to add to. *)
            MatchQ[Lookup[options, NumberOfExtractions], 1],
              False,
            (* Positive means that we extract on the impurity layer, so we need more Organic solvent. *)
            MatchQ[targetPhase, Organic] && MatchQ[selectionStrategy, Positive],
              True,
            (* Negative means that we extract on the target layer, so we need more Organic solvent. *)
            MatchQ[targetPhase, Aqueous] && MatchQ[selectionStrategy, Negative],
              True,
            (* Catch all *)
            True,
              False
          ];

          Which[
            addDuringFirstRoundQ && addDuringRestRoundsQ,
              All,
            addDuringFirstRoundQ,
              First,
            addDuringRestRoundsQ,
              Rest,
            True,
              False
          ]
        ];

        (* Get the density of the aqueous and organic solvent options, if specified. *)
        aqueousSolventDensity=If[MatchQ[aqueousSolvent, ObjectP[{Model[Sample], Object[Sample]}]] && MatchQ[Lookup[fetchPacketFromFastAssoc[aqueousSolvent, fastCacheBall], Density], DensityP],
          Lookup[fetchPacketFromFastAssoc[aqueousSolvent, fastCacheBall], Density],
          Null
        ];

        (* Resolve OrganicSolvent. *)
        organicSolvent=Which[
          MatchQ[Lookup[options, OrganicSolvent], Except[Automatic]],
            Lookup[options, OrganicSolvent],
          (* Did the user specify the SolventAdditions option? If so, was there an organic solvent specified? *)
          And[
            MatchQ[Lookup[options, SolventAdditions], Except[Automatic]],
            MemberQ[(Lookup[specifiedSolventToTypeLookup, #]&)/@ToList[Lookup[options, SolventAdditions]], Organic]
          ],
            Module[{solvents, solventPhases},
              solvents=ToList[Lookup[options, SolventAdditions]];

              solventPhases=(Lookup[specifiedSolventToTypeLookup, #]&)/@solvents;

              FirstCase[Transpose[{solvents, solventPhases}], {solvent_, Organic}:>solvent, Null]
            ],
          (* If AddOrganicSolvent is set to First, All, or Rest, Model[Sample, \"Ethyl acetate, HPLC Grade\"] is used as the OrganicSolvent *)
          (* if we're not using the phase separator. *)
          And[
            MatchQ[addOrganicSolvent, First | All | Rest],
            !MatchQ[extractionTechnique, PhaseSeparator]
          ],
            Model[Sample, "id:9RdZXvKBeeGK"], (* Model[Sample, "Ethyl acetate, HPLC Grade"] *)
          (* If we're using the phase separator and adding organic solvent, make sure that the organic solvent is heavier *)
          (* that the sample's original aqueous phase / the aqueous solvent we're adding. *)
          And[
            MatchQ[addOrganicSolvent, First | All | Rest],
            MatchQ[extractionTechnique, PhaseSeparator],
            (* Make sure that Ethyl Acetate is heavier than the aqueous phase (multiply by 10% just as a safety buffer to really make sure). *)
            Which[
              MatchQ[addOrganicSolvent, First],
                MatchQ[Quantity[0.897, ("Grams")/("Milliliters")], GreaterP[sampleAqueousPhaseDensity * 1.1]],
              MatchQ[addOrganicSolvent, All],
                And[
                  MatchQ[Quantity[0.897, ("Grams")/("Milliliters")], GreaterP[sampleAqueousPhaseDensity * 1.1]],
                  MatchQ[Quantity[0.897, ("Grams")/("Milliliters")], GreaterP[aqueousSolventDensity * 1.1]]
                ],
              MatchQ[addOrganicSolvent, Rest],
                MatchQ[Quantity[0.897, ("Grams")/("Milliliters")], GreaterP[aqueousSolventDensity * 1.1]],
              True,
                False
            ]
          ],
            Model[Sample, "id:9RdZXvKBeeGK"], (* Model[Sample, "Ethyl acetate, HPLC Grade"] *)
          (* If we're adding organic solvent and didn't pass our last check, we need a heavier organic solvent -- use chloroform. *)
          And[
            MatchQ[addOrganicSolvent, First | All | Rest],
            MatchQ[extractionTechnique, PhaseSeparator]
          ],
            Model[Sample, "id:eGakld01zzXo"], (* Model[Sample, "Chloroform"] *)
          (* Otherwise, set to None. *)
          True,
            None
        ];

        organicSolventDensity=If[MatchQ[organicSolvent, ObjectP[{Model[Sample], Object[Sample]}]] && MatchQ[Lookup[fetchPacketFromFastAssoc[organicSolvent, fastCacheBall], Density], DensityP],
          Lookup[fetchPacketFromFastAssoc[organicSolvent, fastCacheBall], Density],
          Null
        ];

        (* Resolve OrganicSolventVolume. *)
        organicSolventVolume=Which[
          MatchQ[Lookup[options, OrganicSolventVolume], Except[Automatic]],
            Lookup[options, OrganicSolventVolume],
          (* If OrganicSolventRatio is set, OrganicSolventVolume is calculated by multiplying 1/OrganicSolventRatio with the sample volume. *)
          MatchQ[Lookup[options, OrganicSolventRatio], _?NumericQ],
            SafeRound[1/Lookup[options, OrganicSolventRatio] * workingSampleVolume, 1 Microliter, AvoidZero -> True],
          (* Otherwise, if AddOrganicSolvent is set, set to 20% of the volume of the sample being extracted. *)
          MatchQ[addOrganicSolvent, Except[False]],
            SafeRound[.2 * workingSampleVolume, 1 Microliter, AvoidZero -> True],
          True,
            Null
        ];

        (* Resolve OrganicSolventRatio. *)
        organicSolventRatio=Which[
          MatchQ[Lookup[options, OrganicSolventRatio], Except[Automatic]],
            Lookup[options, OrganicSolventRatio],
          (* If OrganicSolventVolume is set, OrganicSolventRatio is calculated by dividing the sample volume by OrganicSolventVolume. *)
          MatchQ[organicSolventVolume, VolumeP],
            SafeRound[workingSampleVolume/organicSolventVolume, 10^-1, AvoidZero -> True],
          True,
            Null
        ];

        (* Resolve SolventAdditions. *)
        solventAdditions=Which[
          MatchQ[Lookup[options, SolventAdditions], Except[Automatic]],
            Lookup[options, SolventAdditions],
          True,
            Module[{correctSolventAdditions, cleanedAqueousSolvent, cleanedOrganicSolvent},
              (* Construct what the SolventAdditions field should look like. *)
              correctSolventAdditions=ConstantArray[{}, Lookup[options, NumberOfExtractions]];

              (* If AqueousSolvent is None, replace it with the AqueousSolvent symbol. *)
              cleanedAqueousSolvent=If[MatchQ[aqueousSolvent, None],
                Nothing,
                aqueousSolvent
              ];

              (* If OrganicSolvent is None, replace it with the OrganicSolvent symbol. *)
              cleanedOrganicSolvent=If[MatchQ[organicSolvent, None],
                Nothing,
                organicSolvent
              ];

              (* Add our Aqueous Solvents to the list. *)
              correctSolventAdditions=Which[
                MatchQ[addAqueousSolvent, All],
                  (Append[#, cleanedAqueousSolvent]&)/@correctSolventAdditions,
                MatchQ[addAqueousSolvent, Rest],
                  Prepend[(Append[#, cleanedAqueousSolvent]&)/@Rest[correctSolventAdditions], First[correctSolventAdditions]],
                MatchQ[addAqueousSolvent, First],
                  {Append[First[correctSolventAdditions], cleanedAqueousSolvent], Sequence@@Rest[correctSolventAdditions]},
                True,
                  correctSolventAdditions
              ];

              (* Add our Organic Solvents to the list. *)
              correctSolventAdditions=Which[
                MatchQ[addOrganicSolvent, All],
                  (Append[#, cleanedOrganicSolvent]&)/@correctSolventAdditions,
                MatchQ[addOrganicSolvent, Rest],
                  Prepend[(Append[#, cleanedOrganicSolvent]&)/@Rest[correctSolventAdditions], First[correctSolventAdditions]],
                MatchQ[addOrganicSolvent, First],
                  {Append[First[correctSolventAdditions], cleanedOrganicSolvent], Sequence@@Rest[correctSolventAdditions]},
                True,
                  correctSolventAdditions
              ];

              (* Delist each of our elements accordingly. *)
              (Which[Length[#]==0, None, Length[#]==1, First[#], True, #]&)/@correctSolventAdditions
            ]
        ];

        (* Resolve TargetLayer. *)
        {targetLayer, unknownTargetLayerWarning}=If[MatchQ[Lookup[options, TargetLayer], Except[Automatic]],
          {Lookup[options, TargetLayer], False},
          (* Automatically calculated from the densities of the aqueous and organic layers (to determine which layer will *)
          (* be on the bottom/top) and the TargetPhase option. This calculation assumes that the additional molecules from *)
          (* the input sample will not significantly affect the densities of the aqueous and organic layers. If the density *)
          (* of the solvent molecules that make up the aqueous and organic layers is not available, a warning will be thrown *)
          (* it is assumed that the Aqueous layer is on top of the Organic layer. *)
          Module[
            {sampleSolventDensity, sampleDensity, firstExtractionAqueousPhaseDensity, firstExtractionOrganicPhaseDensity,
              firstExtractionTargetPhase, restExtractionAqueousPhaseDensity, restExtractionOrganicPhaseDensity,
              restExtractionTargetPhase},

            (* Get the density of the sample's Solvent, if the field is filled out. *)
            sampleSolventDensity=If[MatchQ[sampleSolventPacket, PacketP[]],
              Lookup[sampleSolventPacket, Density, Null],
              Null
            ];

            (* Get the density of the sample, if the field is filled out. *)
            sampleDensity=Lookup[samplePacket, Density];

            (* Get the densities of the aqueous and organic phases during the first round of extraction. *)
            {firstExtractionAqueousPhaseDensity, firstExtractionOrganicPhaseDensity}=Which[
              MatchQ[samplePhase, Aqueous],
                {sampleAqueousPhaseDensity, organicSolventDensity},
              MatchQ[samplePhase, Organic],
                {aqueousSolventDensity, sampleOrganicPhaseDensity},
              MatchQ[samplePhase, Biphasic],
                {sampleAqueousPhaseDensity, sampleOrganicPhaseDensity},
              True,
                {aqueousSolventDensity, organicSolventDensity}
            ];

            (* Figure out where our target phase will be during the first extraction. *)
            firstExtractionTargetPhase=Which[
              (* If we don't have enough information, we assume that the Aqueous phase is on top of the Organic phase. *)
              MatchQ[firstExtractionAqueousPhaseDensity, Except[DensityP]] || MatchQ[firstExtractionOrganicPhaseDensity, Except[DensityP]],
                If[MatchQ[targetPhase, Aqueous],
                  Top,
                  Bottom
                ],
              (* Aqueous phase is more dense than the organic phase and will be on the bottom. *)
              MatchQ[firstExtractionAqueousPhaseDensity, GreaterP[firstExtractionOrganicPhaseDensity]],
                If[MatchQ[targetPhase, Aqueous],
                  Bottom,
                  Top
                ],
              (* Aqueous phase is less dense than the organic phase and will be on the bottom. *)
              True,
                If[MatchQ[targetPhase, Aqueous],
                  Top,
                  Bottom
                ]
            ];

            (* Get the densities of the aqueous and organic phases during the rest of the extraction rounds. *)
            {restExtractionAqueousPhaseDensity, restExtractionOrganicPhaseDensity}=Which[
              (* Not doing multiple extraction rounds. *)
              MatchQ[Lookup[options, NumberOfExtractions], 1] || MatchQ[selectionStrategy, Null],
                {firstExtractionAqueousPhaseDensity, firstExtractionOrganicPhaseDensity},

              (* When doing Positive selection, the impurity layer is extracted in future rounds. *)
              MatchQ[targetPhase, Aqueous] && MatchQ[selectionStrategy, Positive],
                {aqueousSolventDensity, firstExtractionOrganicPhaseDensity},
              MatchQ[targetPhase, Organic] && MatchQ[selectionStrategy, Positive],
                {firstExtractionAqueousPhaseDensity, organicSolventDensity},

              (* When doing Negative selection, the target layer is extracted in future rounds. *)
              MatchQ[targetPhase, Aqueous] && MatchQ[selectionStrategy, Negative],
                {firstExtractionAqueousPhaseDensity, organicSolventDensity},
              MatchQ[targetPhase, Organic] && MatchQ[selectionStrategy, Negative],
                {aqueousSolventDensity, firstExtractionOrganicPhaseDensity},

              (* Fail safe. *)
              True,
                {firstExtractionAqueousPhaseDensity, organicSolventDensity}
            ];

            restExtractionTargetPhase=Which[
              (* Not doing multiple extraction rounds. *)
              MatchQ[Lookup[options, NumberOfExtractions], 1] || MatchQ[selectionStrategy, Null],
                firstExtractionTargetPhase,

              (* If we don't have enough information, we assume that the Aqueous phase is on top of the Organic phase. *)
              MatchQ[restExtractionAqueousPhaseDensity, Except[DensityP]] || MatchQ[restExtractionOrganicPhaseDensity, Except[DensityP]],
                If[MatchQ[targetPhase, Aqueous],
                  Top,
                  Bottom
                ],
              (* Aqueous phase is more dense than the organic phase and will be on the bottom. *)
              MatchQ[restExtractionAqueousPhaseDensity, GreaterP[restExtractionOrganicPhaseDensity]],
                If[MatchQ[targetPhase, Aqueous],
                  Bottom,
                  Top
                ],
              (* Aqueous phase is less dense than the organic phase and will be on the bottom. *)
              True,
                If[MatchQ[targetPhase, Aqueous],
                  Top,
                  Bottom
                ]
            ];

            (* Return our resolved option and warn if we didn't had to assume that Aqueous is on top of Organic. *)
            {
              (* TargetLayer option *)
              {
                firstExtractionTargetPhase,
                Sequence@@ConstantArray[restExtractionTargetPhase, Lookup[options, NumberOfExtractions]-1]
              },
              (* If we were lacking density information at all, throw a warning saying that we had to assuming Aqueous was on top of Organic. *)
              Or[
                MatchQ[firstExtractionAqueousPhaseDensity, Except[DensityP]],
                MatchQ[firstExtractionOrganicPhaseDensity, Except[DensityP]],
                MatchQ[restExtractionAqueousPhaseDensity, Except[DensityP]],
                MatchQ[restExtractionOrganicPhaseDensity, Except[DensityP]]
              ]
            }
          ]
        ];

        (* Resolve Demulsifier. *)
        demulsifier=Which[
          MatchQ[Lookup[options, Demulsifier], Except[Automatic]],
            Lookup[options, Demulsifier],

          (* If the user included a demulsifier in the DemulsifierAdditions option, use that. *)
          MemberQ[Lookup[options, DemulsifierAdditions], ObjectP[]],
            FirstCase[Lookup[options, DemulsifierAdditions], ObjectP[]],

          (* Automatically set to Model[Sample, StockSolution, \"5M Sodium Chloride\"] if DemulsifierAmount is specified. *)
          MatchQ[Lookup[options, DemulsifierAmount], Except[Automatic]],
            Model[Sample, StockSolution, "id:AEqRl954GJb6"], (* Model[Sample, StockSolution, "5M Sodium Chloride"] *)

          (* Otherwise, set to Null. *)
          True,
            None
        ];

        (* Resolve DemulsifierAmount. *)
        demulsifierAmount=Which[
          MatchQ[Lookup[options, DemulsifierAmount], Except[Automatic]],
            Lookup[options, DemulsifierAmount],
          (* Automatically set to 10% of the sample volume if Demulsifier is specified. *)
          MatchQ[demulsifier, ObjectP[]],
            SafeRound[.1 * workingSampleVolume, 1 Microliter, AvoidZero -> True],
          True,
            Null
        ];

        (* Resolve DemulsifierAdditions. *)
        demulsifierAdditions=Which[
          MatchQ[Lookup[options, DemulsifierAdditions], Except[Automatic]],
            Lookup[options, DemulsifierAdditions],

          (* If Demulsifier is not specified, DemulsifierAdditions is set to None. *)
          !MatchQ[demulsifier, ObjectP[]],
            ConstantArray[None, Lookup[options, NumberOfExtractions]],

          (* Automatically set to First if NumberOfExtractions is set to 1. *)
          MatchQ[Lookup[options, NumberOfExtractions], 1],
            {demulsifier},

          (* If NumberOfExtractions is set to 1, Demulsifier will only be added during the first extraction round. If *)
          (* NumberOfExtractions is greater than 1 and the sample's Organic phase will be used subsequent extraction rounds *)
          (* (TargetPhase->Aqueous and ExtractionTechnique->Positive OR TargetPhase->Organic and ExtractionTechnique->Negative), *)
          (* Demulsifier will be added during all extraction rounds since the Demulsifier (usually a salt solution which is *)
          (* soluble in the Aqueous layer) will be removed along with the Aqueous layer during the extraction and thus will *)
          (* need to be added before each extraction round. *)
          Or[
            MatchQ[Lookup[options, NumberOfExtractions], GreaterP[1]] && MatchQ[targetPhase, Aqueous] && MatchQ[selectionStrategy, Positive],
            MatchQ[Lookup[options, NumberOfExtractions], GreaterP[1]] && MatchQ[targetPhase, Organic] && MatchQ[selectionStrategy, Negative]
          ],
            ConstantArray[demulsifier, Lookup[options, NumberOfExtractions]],

          (* Otherwise, Demulsifier is added to only the first extraction round since the sample's Aqueous phase will be used in subsequent extraction rounds. *)
          True,
          {demulsifier, Sequence@@ConstantArray[None, Lookup[options, NumberOfExtractions]-1]}
        ];

        (* Resolve ExtractionTransferLayer. *)
        extractionTransferLayer=Which[
          MatchQ[Lookup[options, ExtractionTransferLayer], Except[Automatic]],
            Lookup[options, ExtractionTransferLayer],
          (* Automatically set to Top if ExtractionTechnique->Pipette. *)
          MatchQ[extractionTechnique, Pipette],
            ConstantArray[Top, Lookup[options, NumberOfExtractions]],
          (* Otherwise, set to Null. *)
          True,
            Null
        ];

        (* Resolve ExtractionMixType. *)
        extractionMixType=Which[
          MatchQ[Lookup[options, ExtractionMixType], Except[Automatic]],
            Lookup[options, ExtractionMixType],
          (* Automatically set to Shake if ExtractionMixTime is specified. *)
          MatchQ[Lookup[options, ExtractionMixTime], Except[Automatic|Null]],
            Shake,
          (* Otherwise, set to Pipette. *)
          True,
            Pipette
        ];

        (* Resolve ExtractionMixTime. *)
        extractionMixTime=Which[
          MatchQ[Lookup[options, ExtractionMixTime], Except[Automatic]],
            Lookup[options, ExtractionMixTime],
          (* Automatically set to 30 Second if ExtractionMixType is set to Shake. *)
          MatchQ[extractionMixType, Shake],
            30 Second,
          (* Otherwise, set to Null. *)
          True,
            Null
        ];

        (* Resolve ExtractionMixRate. *)
        extractionMixRate=Which[
          MatchQ[Lookup[options, ExtractionMixRate], Except[Automatic]],
            Lookup[options, ExtractionMixRate],
          (* Automatically set to 300 RPM if ExtractionMixType is set to Shake. *)
          MatchQ[extractionMixType, Shake],
            300 RPM,
          (* Otherwise, set to Null. *)
          True,
            Null
        ];

        (* Resolve NumberOfExtractionMixes. *)
        numberOfExtractionMixes=Which[
          MatchQ[Lookup[options, NumberOfExtractionMixes], Except[Automatic]],
            Lookup[options, NumberOfExtractionMixes],
          (* Automatically set to 10 when ExtractionMixType is set to Pipette. *)
          MatchQ[extractionMixType, Pipette],
            10,
          (* Otherwise, set to Null. *)
          True,
            Null
        ];

        (* Get the working sample volume once we've added in all of the components. *)
        (* Note that if the volume of the working sample plus additives is different in the first round vs the *)
        (* rest of the extraction rounds, the larger of the two is used. *)
        (* NOTE: extractionContainerVolumes is in the format {sample1ExtractionContainerVolumes:{round1Volume:VolumeP, round2Volume:VolumeP, ..}..} *)
        {maxExtractionContainerVolume, extractionContainerVolumes, aqueousLayerVolumes, organicLayerVolumes} = Module[
          {
            firstAqueousLayerVolume, restAqueousLayerVolumes, firstOrganicLayerVolume, restOrganicLayerVolumes,
            firstExtractionWorkingSampleVolumePlusAdditives, nextExtractionWorkingSampleVolumesPlusAdditives
          },

          firstAqueousLayerVolume = Total[{
            (* If the user told us that the sample was Aqueous, believe them. *)
            If[MatchQ[samplePhase, Aqueous],
              Lookup[samplePacket, Volume],
              Lookup[predictedSamplePhaseVolumes, Aqueous]
            ],
            If[MatchQ[addAqueousSolvent, First|All] && MatchQ[aqueousSolventVolume, VolumeP],
              aqueousSolventVolume,
              0 Microliter
            ],
            If[MatchQ[demulsifierAdditions, {ObjectP[], ___}] && MatchQ[demulsifierAmount, VolumeP],
              demulsifierAmount,
              0 Microliter
            ]
          }];

          restAqueousLayerVolumes = Map[
            Function[{extractionRound},
              Total[{
                (* The phase that will be inputted into the next extraction round will be Aqueous. Assume perfect phase separation. *)
                If[Or[
                    MatchQ[targetPhase, Organic] && MatchQ[selectionStrategy, Positive],
                    MatchQ[targetPhase, Aqueous] && MatchQ[selectionStrategy, Negative]
                  ],
                  firstAqueousLayerVolume,
                  0 Microliter
                ],
                If[MatchQ[addAqueousSolvent, Rest|All] && MatchQ[aqueousSolventVolume, VolumeP],
                  aqueousSolventVolume,
                  0 Microliter
                ],
                (* We assume that the demulsifier will end up in the Aqueous layer and will be transferred out along with *)
                (* the Aqueous layer. *)
                If[And[
                    MatchQ[demulsifierAmount, VolumeP],
                    Or[
                      MatchQ[targetPhase, Organic] && MatchQ[selectionStrategy, Positive],
                      MatchQ[targetPhase, Aqueous] && MatchQ[selectionStrategy, Negative]
                    ]
                  ],
                  demulsifierAmount * Length[Cases[demulsifierAdditions[[1;;extractionRound]], ObjectP[]]],
                  0 Microliter
                ]
              }]
            ],
            Rest[Range[Lookup[options, NumberOfExtractions]]]
          ];

          firstOrganicLayerVolume = Total[{
            (* If the user told us that the sample was Organic, believe them. *)
            If[MatchQ[samplePhase, Organic],
              Lookup[samplePacket, Volume],
              Lookup[predictedSamplePhaseVolumes, Organic]
            ],
            If[MatchQ[addOrganicSolvent, First|All] && MatchQ[organicSolventVolume, VolumeP],
              organicSolventVolume,
              0 Microliter
            ]
          }];

          restOrganicLayerVolumes = Map[
            Function[{extractionRound},
              Total[{
                (* The phase that will be inputted into the next extraction round will be Organic. Assume perfect phase separation. *)
                If[Or[
                    MatchQ[targetPhase, Aqueous] && MatchQ[selectionStrategy, Positive],
                    MatchQ[targetPhase, Organic] && MatchQ[selectionStrategy, Negative]
                  ],
                  firstOrganicLayerVolume,
                  0 Microliter
                ],
                If[MatchQ[addOrganicSolvent, Rest|All] && MatchQ[organicSolventVolume, VolumeP],
                  organicSolventVolume,
                  0 Microliter
                ]
              }]
            ],
            Rest[Range[Lookup[options, NumberOfExtractions]]]
          ];

          (* This is the working volume of the sample + all additives before the extraction occurs, during the first *)
          (* round of extraction. *)
          firstExtractionWorkingSampleVolumePlusAdditives = firstAqueousLayerVolume + firstOrganicLayerVolume;

          (* This is the predicted working volume of the working sample at the last round of extraction. *)
          nextExtractionWorkingSampleVolumesPlusAdditives = MapThread[Plus, {restAqueousLayerVolumes, restOrganicLayerVolumes}];

          {
            Total[{
              Total[Flatten[{firstAqueousLayerVolume, restAqueousLayerVolumes}]],
              Total[Flatten[{firstOrganicLayerVolume, restOrganicLayerVolumes}]],
              Total[Flatten[{firstExtractionWorkingSampleVolumePlusAdditives, nextExtractionWorkingSampleVolumesPlusAdditives}]]
            }],
            Flatten[{firstExtractionWorkingSampleVolumePlusAdditives, nextExtractionWorkingSampleVolumesPlusAdditives}],
            Flatten[{firstAqueousLayerVolume, restAqueousLayerVolumes}],
            Flatten[{firstOrganicLayerVolume, restOrganicLayerVolumes}]
          }
        ];

        (* Resolve ExtractionMixVolume. *)
        extractionMixVolume = Which[
          MatchQ[Lookup[options, ExtractionMixVolume], Except[Automatic]],
            Lookup[options, ExtractionMixVolume],
          (* Automatically set to the lesser of 1/2 of the smallest sample volume (use the smallest sample volume so *)
          (* we don't end up with a mix volume that is larger than a sample volume) and 970 Microliter (the maximum amount of volume *)
          (* that can be transferred in a single pipetting step on the liquid handling robot) if ExtractionMixType is set *)
          (* to Pipette. *)
          MatchQ[extractionMixType, Pipette],
            Min[{
              SafeRound[Min[extractionContainerVolumes] * 0.5, 1 Microliter],
              970 Microliter
            }],
          (* Otherwise, set to Null. *)
          True,
            Null
        ];

        {
          extractionTechnique,
          extractionDevice,
          selectionStrategy,
          includeBoundary,
          sampleVolume,
          workingSampleVolume,
          addAqueousSolvent,
          aqueousSolvent,
          aqueousSolventVolume,
          aqueousSolventRatio,
          addOrganicSolvent,
          organicSolvent,
          organicSolventVolume,
          organicSolventRatio,
          solventAdditions,
          targetLayer,
          unknownTargetLayerWarning,
          demulsifierAdditions,
          demulsifier,
          demulsifierAmount,
          centrifugeBool,
          centrifugeInstrument,
          centrifugeIntensity,
          centrifugeTime,
          extractionTransferLayer,
          extractionMixType,
          extractionMixTime,
          extractionMixRate,
          numberOfExtractionMixes,
          extractionMixVolume,
          maxExtractionContainerVolume,
          aqueousLayerVolumes,
          organicLayerVolumes,
          sampleAqueousPhaseDensity,
          sampleOrganicPhaseDensity,
          aqueousSolventDensity,
          organicSolventDensity
        }
      ]
    ],
    {samplePackets, sampleContainerModelPackets, sampleSolventPackets, resolvedSamplePhases, resolvedTargetPhases, allPredictedSamplePhaseMolecules, allPredictedSamplePhaseVolumes, mapThreadFriendlyOptions}
  ];

  (* Get all of the user specified labels. *)
  userSpecifiedLabels=DeleteDuplicates@Cases[
    Flatten@Lookup[
      listedOptions,
      {SampleLabel, SampleContainerLabel, TargetLabel, TargetContainerLabel, ImpurityLabel, ImpurityContainerLabel}
    ],
    _String
  ];

  (* Resolve our sample and sample container labels. *)
  resolvedSampleLabels=Module[{samplesToGroupedLabels, samplesToUserSpecifiedLabels},
    (* This should already be the case but sometimes the user is stupid and sets the label to be Null manually. *)
    (* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
    samplesToGroupedLabels=GroupBy[
      Rule@@@Transpose[{Download[mySamples, Object], Lookup[listedOptions, SampleLabel]}],
      First->Last
    ];

    samplesToUserSpecifiedLabels=(#[[1]]->FirstCase[#[[2]], _String, Null]&)/@Normal[samplesToGroupedLabels];

    MapThread[
      Function[{object, userSpecifiedLabel},
        Which[
          (* User specified the option. *)
          MatchQ[userSpecifiedLabel, _String],
            userSpecifiedLabel,
          (* User specified the option for another index that this object shows up. *)
          MatchQ[Lookup[samplesToUserSpecifiedLabels, object], _String],
            Lookup[samplesToUserSpecifiedLabels, object],
          (* The user has labeled this object upstream in another unit operation. *)
          MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[object, Object]], _String],
            LookupObjectLabel[currentSimulation, Download[object, Object]],
          (* Make a new label for this object. *)
          True,
            Module[{},
              samplesToUserSpecifiedLabels=ReplaceRule[samplesToUserSpecifiedLabels, object->CreateUniqueLabel["liquid liquid extraction sample", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels]];

              Lookup[samplesToUserSpecifiedLabels, object]
            ]
        ]
      ],
      {Download[mySamples, Object], Lookup[listedOptions, SampleLabel]}
    ]
  ];

  resolvedSampleContainerLabels=Module[{sampleContainersToGroupedLabels, sampleContainersToUserSpecifiedLabels},
    (* This should already be the case but sometimes the user is stupid and sets the label to be Null manually. *)
    (* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
    sampleContainersToGroupedLabels=GroupBy[
      Rule@@@Transpose[{Download[Lookup[samplePackets, Container], Object], Lookup[listedOptions, SampleContainerLabel]}],
      First->Last
    ];

    sampleContainersToUserSpecifiedLabels=(#[[1]]->FirstCase[#[[2]], _String, Null]&)/@Normal[sampleContainersToGroupedLabels];

    MapThread[
      Function[{object, userSpecifiedLabel},
        Which[
          (* User specified the option. *)
          MatchQ[userSpecifiedLabel, _String],
            userSpecifiedLabel,
          (* User specified the option for another index that this object shows up. *)
          MatchQ[Lookup[sampleContainersToUserSpecifiedLabels, object], _String],
            Lookup[sampleContainersToUserSpecifiedLabels, object],
          (* The user has labeled this object upstream in another unit operation. *)
          MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[object, Object]], _String],
            LookupObjectLabel[currentSimulation, Download[object, Object]],
          (* Make a new label for this object. *)
          True,
            Module[{},
              sampleContainersToUserSpecifiedLabels=ReplaceRule[sampleContainersToUserSpecifiedLabels, object->CreateUniqueLabel["liquid liquid extraction sample container", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels]];

              Lookup[sampleContainersToUserSpecifiedLabels, object]
            ]
        ]
      ],
      {Lookup[sampleContainerPackets, Object], Lookup[listedOptions, SampleContainerLabel]}
    ]
  ];

  (* Resolved ExtractionContainer and ExtractionContainerWell. *)
  (* This resolution has to be outside of the MapThread because when we need to put the samples into a centrifuge compatible *)
  (* container, we want to pack them into the same plate to save space. *)
  {resolvedExtractionContainers, resolvedExtractionContainerWells} = Module[
    {centrifugationOrTemperatureSampleIndices, highestContainerOutIndex, centrifugationContainers, centrifugationContainerWells,
    semiResolvedExtractionContainers, semiResolvedExtractionContainerWells, extractionContainerToAvailableWellsLookup},

    (* Get all of the sample indices that have Centrifuge->True, are going to be aliquotted, and don't have extraction container specified. *)
    (* These should be in 2mL deep well plates if the ExtractionContainer is not already specified. *)
    centrifugationOrTemperatureSampleIndices = Position[
      Transpose[
        {
          Lookup[listedOptions, ExtractionContainer],
          resolvedSampleVolumes,
          resolvedCentrifugeBools,
          Lookup[listedOptions, Temperature]
        }
      ],
      Alternatives[
        {
          Automatic,
          (VolumeP|All),
          True,
          _
        },
        {
          Automatic,
          (VolumeP|All),
          _,
          Except[Ambient | RangeP[24.9 Celsius, 25.1 Celsius]]
        }
      ]
    ];

    (* Get the highest integer specified by the user for the container out indices. *)
    highestContainerOutIndex = Max[{
      0,
      Cases[Flatten[{Lookup[listedOptions, TargetContainerOut], Lookup[listedOptions, ImpurityContainerOut], Lookup[listedOptions, ExtractionContainer]}], _Integer]
    }];

    (* Make sure that all of the samples that have to be centrifuged will be packed into DWPs efficiently, column wise. *)
    {centrifugationContainers, centrifugationContainerWells}=If[Length[centrifugationOrTemperatureSampleIndices]>0,
      Transpose@MapThread[
        Function[{partitionedIndices, index},
          Sequence@@(
            (
              {
                {highestContainerOutIndex+index, Model[Container, Plate, "id:L8kPEjkmLbvW"]}, (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
                Flatten[Transpose[AllWells[]]][[#]]
              }
            &)/@Range[Length[partitionedIndices]]
          )
        ],
        {
          Partition[centrifugationOrTemperatureSampleIndices, UpTo[96]],
          Range[Length[Partition[centrifugationOrTemperatureSampleIndices, UpTo[96]]]]
        }
      ],
      {{}, {}}
    ];

    semiResolvedExtractionContainers=ReplacePart[
      Lookup[listedOptions, ExtractionContainer],
      Rule@@@Transpose[{
        centrifugationOrTemperatureSampleIndices,
        centrifugationContainers
      }]
    ];

    semiResolvedExtractionContainerWells=ReplacePart[
      Lookup[listedOptions, ExtractionContainerWell],
      Rule@@@Transpose[{
        centrifugationOrTemperatureSampleIndices,
        centrifugationContainerWells
      }]
    ];

    (* Keep track of any wells that we use when packing the container in case the user gave us the container option *)
    (* but no wells. *)
    extractionContainerToAvailableWellsLookup=<||>;

    (* Resolve any other cases. *)
    Transpose@MapThread[
      Function[{extractionContainer, extractionContainerWell, sampleVolume, maxExtractionVolume, centrifugeBool, mixTypes},
        Which[
          (* If these options are both specified, use that. *)
          !MatchQ[extractionContainer, Automatic] && !MatchQ[extractionContainerWell, Automatic],
            {extractionContainer, extractionContainerWell},
          (* If we're not aliquotting, these options should be set to Null. *)
          !MatchQ[sampleVolume, VolumeP|All],
            {extractionContainer, extractionContainerWell} /. {Automatic -> Null},
          (* The user only gave us a new container, just default to A1. *)
          MatchQ[extractionContainer, ObjectP[Model[Container]]],
            {extractionContainer, "A1"},
          (* The user gave us a specific container but not a well. *)
          MatchQ[extractionContainer, Except[Automatic]] && MatchQ[extractionContainerWell, Automatic],
            Module[{availableWells},
              (* Initialize our lookup. *)
              If[!KeyExistsQ[extractionContainerToAvailableWellsLookup, extractionContainer],
                Which[
                  MatchQ[extractionContainer, ObjectP[Object[Container]]],
                    Module[{allWells, occupiedWells},
                      allWells=Lookup[Lookup[fetchModelPacketFromFastAssoc[extractionContainer, fastCacheBall], Positions], Name];

                      occupiedWells=Lookup[fetchPacketFromFastAssoc[extractionContainer, fastCacheBall], Contents][[All,1]];

                      extractionContainerToAvailableWellsLookup[extractionContainer]=Complement[allWells, occupiedWells];
                    ],
                  MatchQ[extractionContainer, ObjectP[Model[Container]]],
                    Module[{allWells, transposedWells},
                      allWells=Lookup[Lookup[fetchPacketFromFastAssoc[extractionContainer, fastCacheBall], Positions], Name];

                      transposedWells=If[MatchQ[allWells, Flatten[AllWells[]]],
                        Flatten[Transpose[AllWells[]]],
                        allWells
                      ];

                      extractionContainerToAvailableWellsLookup[extractionContainer]=transposedWells;
                    ],
                  True,
                    Module[{allWells, transposedWells},
                      allWells=Lookup[Lookup[fetchPacketFromFastAssoc[extractionContainer[[2]], fastCacheBall], Positions], Name];

                      transposedWells=If[MatchQ[allWells, Flatten[AllWells[]]],
                        Flatten[Transpose[AllWells[]]],
                        allWells
                      ];

                      extractionContainerToAvailableWellsLookup[extractionContainer]=transposedWells;
                    ]
                ]
              ];

              (* Get the available wells. *)
              availableWells=Lookup[extractionContainerToAvailableWellsLookup, Key[extractionContainer]];

              (* Update the lookup, if there are no longer any wells left, use the standard well list. *)
              extractionContainerToAvailableWellsLookup[extractionContainer]=RestOrDefault[availableWells, Flatten[Transpose[AllWells[]]]];

              {extractionContainer, FirstOrDefault[availableWells, "A1"]}
            ],
          (* The user only gave us a well but not a container -- if we're centrifuging, use a DWP. *)
          MatchQ[extractionContainerWell, Except[Automatic]] && MatchQ[extractionContainer, Automatic] && MatchQ[centrifugeBool],
            {Model[Container, Plate, "id:L8kPEjkmLbvW"], extractionContainerWell}, (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
          (* If mix type is shake, then needs to be in a plate for the extraction. *)
          MatchQ[mixTypes, Shake],
            {
              PreferredContainer[maxExtractionVolume, LiquidHandlerCompatible -> True, Type -> Plate],
              "A1"
            },
          (* Just use a liquid handler compatible vessel. *)
          (* NOTE: maxExtractionVolume is the very worst case if there is no separation at all. *)
          True,
            {
              PreferredContainer[maxExtractionVolume, LiquidHandlerCompatible -> True],
              "A1"
            }
        ]
      ],
      {
        semiResolvedExtractionContainers,
        semiResolvedExtractionContainerWells,
        resolvedSampleVolumes,
        resolvedMaxExtractionContainerVolumes,
        resolvedCentrifugeBools,
        resolvedExtractionMixTypes
      }
    ]
  ];

  (* Resolve TargetContainerOut and TargetContainerOutWell. *)
  {resolvedTargetContainerOuts, resolvedTargetContainerOutWells}=Transpose@MapThread[
    Function[{samplePacket, maxExtractionContainerVolume, extractionTechnique, targetLayer, extractionTransferLayer, extractionContainer, extractionContainerWell, selectionStrategy, centrifugeBool, mixType, options},
      Which[
        MatchQ[Lookup[options, TargetContainerOut], Except[Automatic]] && MatchQ[Lookup[options, TargetContainerOutWell], Except[Automatic]],
          {Lookup[options, TargetContainerOut], Lookup[options, TargetContainerOutWell]},

        (* If the user has set TargetContainerLabel, use that container if it is already labeled. *)
        And[
          MatchQ[Lookup[options, TargetContainerOut], Automatic],
          MatchQ[Lookup[options, TargetContainerLabel], Except[Automatic]],
          MatchQ[LookupLabeledObject[currentSimulation, Lookup[options, TargetContainerLabel]], _String]
        ],
          {
            MatchQ[LookupLabeledObject[currentSimulation, Lookup[options, TargetContainerLabel]], _String],
            Lookup[options, TargetContainerOutWell] /. {Automatic -> "A1"}
          },

        (* If the user has set TargetContainerLabel, use that container if it is already labeled. *)
        And[
          MatchQ[Lookup[options, TargetContainerOut], Automatic],
          MatchQ[Lookup[options, TargetContainerLabel], Except[Automatic]],
          MatchQ[
            FirstCase[
              Transpose[{Lookup[listedOptions, TargetContainerOut], Lookup[listedOptions, TargetContainerLabel]}],
              {obj:ObjectP[], Lookup[options, TargetContainerLabel]}:>obj
            ],
            ObjectP[]
          ]
        ],
          {
            FirstCase[
              Transpose[{Lookup[listedOptions, TargetContainerOut], Lookup[listedOptions, TargetContainerLabel]}],
              {obj:ObjectP[], Lookup[options, TargetContainerLabel]}:>obj
            ],
            Lookup[options, TargetContainerOutWell] /. {Automatic -> "A1"}
          },

        (* When we're doing pipette extraction, TargetLayer doesn't matches ExtractionTransferLayer, and SelectionStrategy -> Negative, *)
        (* then the target layer should stay in the ExtractionContainer because we want to extract on the target layer *)
        (* again. *)
        (* OR if we're using a phase separator and doing SelectionStrategy -> Negative since the target layer should be transferred *)
        (* into the ExtractionContainer since we want to repeat on the target layer again. *)
        (* OR we're only doing one round of extraction *)
        Or[
          And[
            MatchQ[extractionTechnique, Pipette],
            !MatchQ[targetLayer, extractionTransferLayer],
            MatchQ[selectionStrategy, Negative]
          ],
          And[
            MatchQ[extractionTechnique, PhaseSeparator],
            MatchQ[selectionStrategy, Negative]
          ]
        ],
          Module[{workingContainer, workingContainerWell},
            workingContainer=If[MatchQ[extractionContainer, Except[Null]],
              extractionContainer,
              Download[Lookup[samplePacket, Container], Object]
            ];
            workingContainerWell=If[MatchQ[extractionContainerWell, Except[Null]],
              extractionContainerWell,
              Lookup[samplePacket, Position]
            ];

            {
              Lookup[options, TargetContainerOut] /. {Automatic -> workingContainer},
              Lookup[options, TargetContainerOutWell] /. {Automatic -> workingContainerWell}
            }
          ],
        (* If centrifuging, mixing via shaking, or using a phase separator, then needs to be a plate while Robotic prep only. *)
        Or[
          centrifugeBool,
          MatchQ[mixType, Shake],
          MatchQ[extractionTechnique, PhaseSeparator]
        ],
          {
            Lookup[options, TargetContainerOut] /. {Automatic -> PreferredContainer[maxExtractionContainerVolume, LiquidHandlerCompatible->True,Type->Plate]},
            Lookup[options, TargetContainerOutWell] /. {Automatic -> "A1"}
          },
        (*Otherwise, does not need to be in a plate. *)
        True,
          {
            Lookup[options, TargetContainerOut] /. {Automatic -> PreferredContainer[maxExtractionContainerVolume, LiquidHandlerCompatible->True]},
            Lookup[options, TargetContainerOutWell] /. {Automatic -> "A1"}
          }
      ]
    ],
    {
      samplePackets,
      resolvedMaxExtractionContainerVolumes,
      resolvedExtractionTechniques,
      resolvedTargetLayers,
      resolvedExtractionTransferLayers,
      resolvedExtractionContainers,
      resolvedExtractionContainerWells,
      resolvedSelectionStrategies,
      resolvedCentrifugeBools,
      resolvedExtractionMixTypes,
      mapThreadFriendlyOptions
    }
  ];

  (* Resolve our target sample and target sample container labels. *)
  resolvedTargetLabels=Module[{samplesToGroupedLabels, samplesToUserSpecifiedLabels},
    (* This should already be the case but sometimes the user is stupid and sets the label to be Null manually. *)
    (* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
    samplesToGroupedLabels=GroupBy[
      Rule@@@Transpose[{Transpose[{resolvedTargetContainerOutWells, resolvedTargetContainerOuts}], Lookup[listedOptions, TargetLabel]}],
      First->Last
    ];

    (* Model[Container]s are unique containers and therefore don't need shared labels. *)
    samplesToUserSpecifiedLabels=(#[[1]]->FirstCase[#[[2]], _String, Null]&)/@Normal[samplesToGroupedLabels];

    MapThread[
      Function[{targetContainerOut, targetContainerOutWell, userSpecifiedLabel},
        Module[{targetSample},
          (* If the user gave us an Object[Container], the sample inside of it may already have a label. *)
          targetSample=If[MatchQ[targetContainerOut, ObjectP[Object[Container]]],
            Lookup[Rule@@@Lookup[fetchPacketFromFastAssoc[targetContainerOut, fastCacheBall], Contents], targetContainerOutWell],
            Null
          ];

          Which[
            (* User specified the option. *)
            MatchQ[userSpecifiedLabel, _String],
              userSpecifiedLabel,
            (* All Model[Container]s are unique. *)
            MatchQ[targetContainerOut, ObjectP[Model[Container]]],
              CreateUniqueLabel["liquid liquid extraction target sample", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels],
            (* User specified the option for another index that this object shows up. *)
            MatchQ[Lookup[samplesToUserSpecifiedLabels, Key[{targetContainerOutWell, targetContainerOut}]], _String],
              Lookup[samplesToUserSpecifiedLabels, Key[{targetContainerOutWell, targetContainerOut}]],
            (* The user has labeled this object upstream in another unit operation. *)
            MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[targetSample, Object]], _String],
              LookupObjectLabel[currentSimulation, Download[object, Object]],
            (* Make a new label for this object. *)
            True,
              Module[{},
                samplesToUserSpecifiedLabels=ReplaceRule[
                  samplesToUserSpecifiedLabels,
                  {targetContainerOutWell, targetContainerOut}->CreateUniqueLabel["liquid liquid extraction target sample", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels]
                ];

                Lookup[samplesToUserSpecifiedLabels, Key[{targetContainerOutWell, targetContainerOut}]]
              ]
          ]
        ]
      ],
      {resolvedTargetContainerOuts, resolvedTargetContainerOutWells, Lookup[listedOptions, TargetLabel]}
    ]
  ];

  resolvedTargetContainerLabels=Module[{sampleContainersToGroupedLabels, sampleContainersToUserSpecifiedLabels},
    (* This should already be the case but sometimes the user is stupid and sets the label to be Null manually. *)
    (* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
    sampleContainersToGroupedLabels=GroupBy[
      Rule@@@Transpose[{resolvedTargetContainerOuts, Lookup[listedOptions, TargetContainerLabel]}],
      First->Last
    ];

    sampleContainersToUserSpecifiedLabels=(#[[1]]->FirstCase[#[[2]], _String, Null]&)/@Normal[sampleContainersToGroupedLabels];

    MapThread[
      Function[{object, userSpecifiedLabel},
        Which[
          (* User specified the option. *)
          MatchQ[userSpecifiedLabel, _String],
            userSpecifiedLabel,
          (* All Model[Container]s are unique. *)
          MatchQ[object, ObjectP[Model[Container]]],
            CreateUniqueLabel["liquid liquid extraction target container", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels],
          (* User specified the option for another index that this object shows up. *)
          MatchQ[Lookup[sampleContainersToUserSpecifiedLabels, object], _String],
            Lookup[sampleContainersToUserSpecifiedLabels, object],
          (* The user has labeled this object upstream in another unit operation. *)
          MatchQ[object, ObjectP[Object[Container]]] && MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[object, Object]], _String],
            LookupObjectLabel[currentSimulation, Download[object, Object]],
          (* Make a new label for this object. *)
          True,
            Module[{},
              sampleContainersToUserSpecifiedLabels=ReplaceRule[
                sampleContainersToUserSpecifiedLabels,
                object->CreateUniqueLabel["liquid liquid extraction target container", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels]
              ];

              Lookup[sampleContainersToUserSpecifiedLabels, object]
            ]
        ]
      ],
      {resolvedTargetContainerOuts, Lookup[listedOptions, TargetContainerLabel]}
    ]
  ];

  {resolvedImpurityContainerOuts, resolvedImpurityContainerOutWells}=Transpose@MapThread[
    Function[{samplePacket, maxExtractionContainerVolume, extractionTechnique, targetLayer, extractionTransferLayer, extractionContainer, extractionContainerWell, selectionStrategy, centrifugeBool, mixType, options},
      Which[
        MatchQ[Lookup[options, ImpurityContainerOut], Except[Automatic]] && MatchQ[Lookup[options, ImpurityContainerOutWell], Except[Automatic]],
          {Lookup[options, ImpurityContainerOut], Lookup[options, ImpurityContainerOutWell]},

        (* When we're doing pipette extraction, TargetLayer matches ExtractionTransferLayer, and SelectionStrategy -> Positive, *)
        (* then the impurity layer should stay in the ExtractionContainer because we want to extract on the impurity layer *)
        (* again. *)
        (* OR if we're using a phase separator and doing SelectionStrategy -> Negative since the target layer should be transferred *)
        (* into the ExtractionContainer since we want to repeat on the target layer again. *)
        Or[
          And[
            MatchQ[extractionTechnique, Pipette],
            MatchQ[targetLayer, extractionTransferLayer],
            MatchQ[selectionStrategy, Positive]
          ],
          And[
            MatchQ[extractionTechnique, PhaseSeparator],
            MatchQ[selectionStrategy, Negative]
          ]
        ],
          Module[{workingContainer, workingContainerWell},
            workingContainer=If[MatchQ[extractionContainer, Except[Null]],
              extractionContainer,
              Download[Lookup[samplePacket, Container], Object]
            ];
            workingContainerWell=If[MatchQ[extractionContainerWell, Except[Null]],
              extractionContainerWell,
              Lookup[samplePacket, Position]
            ];

            {
              Lookup[options, ImpurityContainerOut] /. {Automatic -> workingContainer},
              Lookup[options, ImpurityContainerOutWell] /. {Automatic -> workingContainerWell}
            }
          ],
        (* Otherwise, we need a new impurity container. *)
        (* If centrifuging, mixing via shaking, or using a phase separator, then needs to be a plate while Robotic prep only. *)
        Or[
          centrifugeBool,
          MatchQ[mixType, Shake],
          MatchQ[extractionTechnique, PhaseSeparator]
        ],
          {
            Lookup[options, ImpurityContainerOut] /. {Automatic -> PreferredContainer[maxExtractionContainerVolume, LiquidHandlerCompatible->True,Type->Plate]},
            Lookup[options, ImpurityContainerOutWell] /. {Automatic -> "A1"}
          },
        (*Otherwise, does not need to be in a plate. *)
        True,
          {
            Lookup[options, ImpurityContainerOut] /. {Automatic -> PreferredContainer[maxExtractionContainerVolume, LiquidHandlerCompatible->True]},
            Lookup[options, ImpurityContainerOutWell] /. {Automatic -> "A1"}
          }
      ]
    ],
    {
      samplePackets,
      resolvedMaxExtractionContainerVolumes,
      resolvedExtractionTechniques,
      resolvedTargetLayers,
      resolvedExtractionTransferLayers,
      resolvedExtractionContainers,
      resolvedExtractionContainerWells,
      resolvedSelectionStrategies,
      resolvedCentrifugeBools,
      resolvedExtractionMixTypes,
      mapThreadFriendlyOptions
    }
  ];

  (* Resolve our impurity sample and impurity sample container labels. *)
  resolvedImpurityLabels=Module[{samplesToGroupedLabels, samplesToUserSpecifiedLabels},
    (* This should already be the case but sometimes the user is stupid and sets the label to be Null manually. *)
    (* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
    samplesToGroupedLabels=GroupBy[
      Rule@@@Transpose[{Transpose[{resolvedImpurityContainerOutWells, resolvedImpurityContainerOuts}], Lookup[listedOptions, ImpurityLabel]}],
      First->Last
    ];

    (* Model[Container]s are unique containers and therefore don't need shared labels. *)
    samplesToUserSpecifiedLabels=(#[[1]]->FirstCase[#[[2]], _String, Null]&)/@Normal[samplesToGroupedLabels];

    MapThread[
      Function[{impurityContainerOut, impurityContainerOutWell, userSpecifiedLabel},
        Module[{impuritySample},
          impuritySample=If[MatchQ[impurityContainerOut, ObjectP[Object[Container]]],
            Lookup[Rule@@@Lookup[fetchPacketFromFastAssoc[impurityContainerOut, fastCacheBall], Contents], impurityContainerOutWell],
            Null
          ];

          Which[
            (* User specified the option. *)
            MatchQ[userSpecifiedLabel, _String],
              userSpecifiedLabel,
            (* All Model[Container]s are unique. *)
            MatchQ[impurityContainerOut, ObjectP[Model[Container]]],
              CreateUniqueLabel["liquid liquid extraction impurity sample", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels],
            (* User specified the option for another index that this object shows up. *)
            MatchQ[Lookup[samplesToUserSpecifiedLabels, Key[{impurityContainerOutWell, impurityContainerOut}]], _String],
              Lookup[samplesToUserSpecifiedLabels, Key[{impurityContainerOutWell, impurityContainerOut}]],
            (* The user has labeled this object upstream in another unit operation. *)
            MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[impuritySample, Object]], _String],
              LookupObjectLabel[currentSimulation, Download[impuritySample, Object]],
            (* Make a new label for this object. *)
            True,
              Module[{},
                samplesToUserSpecifiedLabels=ReplaceRule[
                  samplesToUserSpecifiedLabels,
                  {impurityContainerOutWell, impurityContainerOut}->CreateUniqueLabel["liquid liquid extraction impurity sample", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels]
                ];

                Lookup[samplesToUserSpecifiedLabels, Key[{impurityContainerOutWell, impurityContainerOut}]]
              ]
          ]
        ]
      ],
      {resolvedImpurityContainerOuts, resolvedImpurityContainerOutWells, Lookup[listedOptions, ImpurityLabel]}
    ]
  ];

  resolvedImpurityContainerLabels=Module[{sampleContainersToGroupedLabels, sampleContainersToUserSpecifiedLabels},
    (* This should already be the case but sometimes the user is stupid and sets the label to be Null manually. *)
    (* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
    sampleContainersToGroupedLabels=GroupBy[
      Rule@@@Transpose[{resolvedImpurityContainerOuts, Lookup[listedOptions, ImpurityContainerLabel]}],
      First->Last
    ];

    (* Model[Container]s are unique containers and therefore don't need shared labels. *)
    sampleContainersToUserSpecifiedLabels=(#[[1]]->FirstCase[#[[2]], _String, Null]&)/@Normal[sampleContainersToGroupedLabels];

    MapThread[
      Function[{object, userSpecifiedLabel},
        Which[
          (* User specified the option. *)
          MatchQ[userSpecifiedLabel, _String],
            userSpecifiedLabel,
          (* All Model[Container]s are unique. *)
          MatchQ[object, ObjectP[Model[Container]]],
            CreateUniqueLabel["liquid liquid extraction impurity container", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels],
          (* User specified the option for another index that this object shows up. *)
          MatchQ[Lookup[sampleContainersToUserSpecifiedLabels, object], _String],
            Lookup[sampleContainersToUserSpecifiedLabels, object],
          (* The user has labeled this object upstream in another unit operation. *)
          MatchQ[object, ObjectP[Object[Container]]] && MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[object, Object]], _String],
            LookupObjectLabel[currentSimulation, Download[object, Object]],
          (* Make a new label for this object. *)
          True,
            Module[{},
              sampleContainersToUserSpecifiedLabels=ReplaceRule[
                sampleContainersToUserSpecifiedLabels,
                object->CreateUniqueLabel["liquid liquid extraction impurity container", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels]
              ];

              Lookup[sampleContainersToUserSpecifiedLabels, Key[object]]
            ]
        ]
      ],
      {resolvedImpurityContainerOuts, Lookup[listedOptions, ImpurityContainerLabel]}
    ]
  ];

  (* Resolve ExtractionBoundaryVolume. *)
  resolvedExtractionBoundaryVolumes=MapThread[
    Function[{extractionContainer, extractionTechnique, sampleContainerModelPacket, aqueousLayerVolumes, organicLayerVolumes, targetPhase, targetLayer, extractionTransferLayer, numberOfExtractions, options},
      (* If the user already gave us the option, use that. *)
      Which[
        MatchQ[Lookup[options, ExtractionBoundaryVolume], Except[Automatic]],
          Lookup[options, ExtractionBoundaryVolume],
        MatchQ[extractionTechnique, Except[Pipette]],
          Null,
        True,
          Map[
            Function[{extractionRound},
              If[Length[targetLayer]<extractionRound,
                0 Milliliter,
                Module[{containerModelPacket, bottomLayer, fiveMMBoundaryVolume, extractedLayer, tenPercentOfExtractedLayer},
                  containerModelPacket = Which[
                    MatchQ[extractionContainer, ObjectP[Model[Container]]],
                      fetchPacketFromFastAssoc[extractionContainer, fastCacheBall],
                    MatchQ[extractionContainer, ObjectP[Object[Container]]],
                      fetchModelPacketFromFastAssoc[extractionContainer, fastCacheBall],
                    MatchQ[extractionContainer, {_Integer, ObjectP[Model[Container]]}],
                      fetchPacketFromFastAssoc[extractionContainer[[2]], fastCacheBall],
                    True, (* ExtractionContainer isn't set. *)
                      sampleContainerModelPacket
                  ];

                  (* What layer will be on the bottom? *)
                  bottomLayer=Which[
                    MatchQ[targetLayer[[extractionRound]], Bottom],
                      targetPhase,
                    MatchQ[targetPhase, Aqueous],
                      Organic,
                    True,
                      Aqueous
                  ];

                  fiveMMBoundaryVolume=resolveBoundaryVolume[
                    5 Millimeter, (* myBoundaryLayerHeight *)
                    If[MatchQ[bottomLayer, Aqueous], (* myBottomLayerVolume *)
                      aqueousLayerVolumes[[extractionRound]],
                      organicLayerVolumes[[extractionRound]]
                    ],
                    containerModelPacket, (* myContainerModelPacket *)
                    (* latestVolumeCalibrationPacket; need to make sure we don't pick Anomalous packets or ones with DeveloperObject -> True or ones generated by MaintenanceCalibrateVolume *)
                    With[{allVolumeCalPackets = fetchPacketFromFastAssoc[#, fastCacheBall]& /@ Lookup[containerModelPacket, VolumeCalibrations]},
                      SelectFirst[
                        Reverse[allVolumeCalPackets],
                        And[
                          Not[TrueQ[Lookup[#, Anomalous]]],
                          Not[TrueQ[Lookup[#, Deprecated]]],
                          Not[TrueQ[Lookup[#, DeveloperObject]]],
                          Not[NullQ[Lookup[#, LiquidLevelDetectorModel]]],
                          Not[StringContainsQ[Lookup[#, Name, ""] /. Null -> "", "Placeholder calibration for " ~~ __ ~~ uuid_ /; MatchQ[uuid, UUIDP]]]
                        ]&
                      ]
                    ]
                  ];

                  (* What layer will be extracted? *)
                  extractedLayer=Which[
                    MatchQ[targetLayer[[extractionRound]], extractionTransferLayer[[extractionRound]]],
                      targetPhase,
                    MatchQ[targetPhase, Aqueous],
                      Organic,
                    True,
                      Aqueous
                  ];

                  tenPercentOfExtractedLayer=.1 * If[MatchQ[targetPhase, Aqueous],
                    aqueousLayerVolumes[[extractionRound]],
                    organicLayerVolumes[[extractionRound]]
                  ];

                  Min[{tenPercentOfExtractedLayer, fiveMMBoundaryVolume}]
                ]
              ]
            ],
            Range[numberOfExtractions]
          ]
      ]
    ],
    {resolvedExtractionContainers, resolvedExtractionTechniques, sampleContainerModelPackets, resolvedAqueousLayerVolumes, resolvedOrganicLayerVolumes, resolvedTargetPhases, resolvedTargetLayers, resolvedExtractionTransferLayers, Lookup[listedOptions, NumberOfExtractions], mapThreadFriendlyOptions}
  ];

  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

  (* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
  email = Which[
    MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[Lookup[myOptions,ParentProtocol]], True,
    MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[Lookup[myOptions,ParentProtocol], ObjectP[ProtocolTypes[]]], False,
    True, Lookup[myOptions, Email]
  ];

  (* Overwrite our rounded options with our resolved options. Everything else has a default. *)
  resolvedOptions=Normal@Join[
    Association@roundedExperimentOptions,
    Association@{
      ExtractionTechnique -> resolvedExtractionTechniques,
      ExtractionDevice -> resolvedExtractionDevices,
      SelectionStrategy -> resolvedSelectionStrategies,
      IncludeBoundary -> resolvedIncludeBoundaries,
      TargetAnalyte -> resolvedTargetAnalytes,
      SamplePhase -> resolvedSamplePhases,
      TargetPhase -> resolvedTargetPhases,
      TargetLayer -> resolvedTargetLayers,
      SampleVolume -> resolvedSampleVolumes,
      ExtractionContainer -> resolvedExtractionContainers,
      ExtractionContainerWell -> resolvedExtractionContainerWells,
      AddAqueousSolvent -> resolvedAddAqueousSolvents,
      AqueousSolvent -> resolvedAqueousSolvents,
      AqueousSolventVolume -> resolvedAqueousSolventVolumes,
      AqueousSolventRatio -> resolvedAqueousSolventRatios,
      AddOrganicSolvent -> resolvedAddOrganicSolvents,
      OrganicSolvent -> resolvedOrganicSolvents,
      OrganicSolventVolume -> resolvedOrganicSolventVolumes,
      OrganicSolventRatio -> resolvedOrganicSolventRatios,
      SolventAdditions -> resolvedSolventAdditions,
      Demulsifier -> resolvedDemulsifiers,
      DemulsifierAdditions -> resolvedDemulsifierAdditions,
      DemulsifierAmount -> resolvedDemulsifierAmounts,
      ExtractionMixType -> resolvedExtractionMixTypes,
      ExtractionMixTime -> resolvedExtractionMixTimes,
      ExtractionMixRate -> resolvedExtractionMixRates,
      NumberOfExtractionMixes -> resolvedNumberOfExtractionMixes,
      ExtractionMixVolume -> resolvedExtractionMixVolumes,
      Centrifuge -> resolvedCentrifugeBools,
      CentrifugeInstrument -> resolvedCentrifugeInstruments,
      CentrifugeIntensity -> resolvedCentrifugeIntensitys,
      CentrifugeTime -> resolvedCentrifugeTimes,
      ExtractionBoundaryVolume -> resolvedExtractionBoundaryVolumes,
      ExtractionTransferLayer -> resolvedExtractionTransferLayers,
      TargetContainerOut -> resolvedTargetContainerOuts,
      TargetContainerOutWell -> resolvedTargetContainerOutWells,
      ImpurityContainerOut -> resolvedImpurityContainerOuts,
      ImpurityContainerOutWell -> resolvedImpurityContainerOutWells,
      SampleLabel -> resolvedSampleLabels,
      SampleContainerLabel -> resolvedSampleContainerLabels,
      TargetLabel -> resolvedTargetLabels,
      TargetContainerLabel -> resolvedTargetContainerLabels,
      ImpurityLabel -> resolvedImpurityLabels,
      ImpurityContainerLabel -> resolvedImpurityContainerLabels,

      resolvedPostProcessingOptions,

      Email -> email,
      WorkCell -> resolvedWorkCell,

      (* HIDDEN OPTIONS *)
      AqueousLayerVolumes -> resolvedAqueousLayerVolumes,
      OrganicLayerVolumes -> resolvedOrganicLayerVolumes
    }
  ];

  (* THROW CONFLICTING OPTION ERRORS *)

  (* SolventAdditions must match the solvents provided by the AqueousSolvent and OrganicSolvent options. *)
  solventAdditionsMismatch=MapThread[
    Function[{sample, solventAdditions, aqueousSolvent, organicSolvent, index},
      If[Length[Complement[Download[Cases[Flatten[solventAdditions], ObjectP[]], Object], {aqueousSolvent, organicSolvent}]]>0,
        {
          sample,
          Complement[Download[Cases[Flatten[solventAdditions], ObjectP[]], Object], {aqueousSolvent, organicSolvent}],
          aqueousSolvent,
          organicSolvent,
          index
        },
        Nothing
      ]
    ],
    {mySamples, resolvedSolventAdditions, resolvedAqueousSolvents, resolvedOrganicSolvents, Range[Length[mySamples]]}
  ];

  If[Length[solventAdditionsMismatch]>0 && messages,
    Message[
      Error::SolventAdditionsMismatch,
      ObjectToString[solventAdditionsMismatch[[All,1]], Cache -> cacheBall],
      ObjectToString[solventAdditionsMismatch[[All,2]], Cache -> cacheBall],
      ObjectToString[solventAdditionsMismatch[[All,3]], Cache -> cacheBall],
      ObjectToString[solventAdditionsMismatch[[All,4]], Cache -> cacheBall],
      solventAdditionsMismatch[[All,5]]
    ];
  ];

  solventAdditionsMismatchTest=If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = solventAdditionsMismatch[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have conflicting SolventAdditions, AqueousSolvent, and/or OrganicSolvent options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have conflicting SolventAdditions, AqueousSolvent, and/or OrganicSolvent options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* SolventAdditions/IncludeBoundary/DemulsifierAdditions/TargetLayer must match the NumberOfExtractions if specified in a list. *)
  extractionRoundMismatches=MapThread[
    Function[{sample, solventAdditions, includeBoundary, demulsifierAdditions, targetLayer, numberOfExtractions, index},
      Sequence@@{
        If[MatchQ[solventAdditions, _List] && !MatchQ[Length[solventAdditions], numberOfExtractions],
          {
            sample,
            SolventAdditions,
            Length[solventAdditions],
            numberOfExtractions,
            index
          },
          Nothing
        ],
        If[MatchQ[includeBoundary, _List] && !MatchQ[Length[includeBoundary], numberOfExtractions],
          {
            sample,
            IncludeBoundary,
            Length[includeBoundary],
            numberOfExtractions,
            index
          },
          Nothing
        ],
        If[MatchQ[demulsifierAdditions, _List] && !MatchQ[Length[demulsifierAdditions], numberOfExtractions],
          {
            sample,
            DemulsifierAdditions,
            Length[demulsifierAdditions],
            numberOfExtractions,
            index
          },
          Nothing
        ],
        If[MatchQ[targetLayer, _List] && !MatchQ[Length[targetLayer], numberOfExtractions],
          {
            sample,
            TargetLayer,
            Length[targetLayer],
            numberOfExtractions,
            index
          },
          Nothing
        ]
      }
    ],
    {mySamples, resolvedSolventAdditions, resolvedIncludeBoundaries, resolvedDemulsifierAdditions, resolvedTargetLayers, Lookup[listedOptions, NumberOfExtractions], Range[Length[mySamples]]}
  ];

  If[Length[extractionRoundMismatches]>0 && messages,
    Message[
      Error::InvalidExtractionRoundLengths,
      ObjectToString[extractionRoundMismatches[[All,1]], Cache -> cacheBall],
      ObjectToString[extractionRoundMismatches[[All,2]], Cache -> cacheBall],
      ObjectToString[extractionRoundMismatches[[All,3]], Cache -> cacheBall],
      ObjectToString[extractionRoundMismatches[[All,4]], Cache -> cacheBall],
      extractionRoundMismatches[[All,5]]
    ];
  ];

  extractionRoundMismatchesTest=If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = extractionRoundMismatches[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have incorrect lengths for the options SolventAdditions/IncludeBoundary/DemulsifierAdditions based on the NumberOfExtractions option:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have incorrect lengths for the options SolventAdditions/IncludeBoundary/DemulsifierAdditions based on the NumberOfExtractions option:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* SolventAdditions must match our internal AddAqueousSolvent / AddOrganicSolvent variables (otherwise there will be a *)
  (* missing phase during an extraction round). *)
  invalidSolventAdditions=MapThread[
    Function[{sample, solventAdditions, aqueousSolvent, organicSolvent, addAqueousSolvent, addOrganicSolvent, numberOfExtractions, index},
      (* If our SolventAdditions are of an incorrect length, then don't bother doing error checking. We should have *)
      (* checked this above in Error::InvalidExtractionRoundLengths. *)
      If[!MatchQ[Length[solventAdditions], numberOfExtractions],
        Nothing,
        Module[{correctSolventAdditions, cleanedAqueousSolvent, cleanedOrganicSolvent, cleanedSolventAdditions},
          (* Construct what the SolventAdditions field should look like. *)
          correctSolventAdditions=ConstantArray[{}, numberOfExtractions];

          (* If AqueousSolvent is None, replace it with the AqueousSolvent symbol. *)
          cleanedAqueousSolvent=If[MatchQ[aqueousSolvent, None],
            AqueousSolvent,
            aqueousSolvent
          ];

          (* If OrganicSolvent is None, replace it with the OrganicSolvent symbol. *)
          cleanedOrganicSolvent=If[MatchQ[organicSolvent, None],
            OrganicSolvent,
            organicSolvent
          ];

          (* Add our Aqueous Solvents to the list. *)
          correctSolventAdditions=Which[
            MatchQ[addAqueousSolvent, All],
              (Append[#, cleanedAqueousSolvent]&)/@correctSolventAdditions,
            MatchQ[addAqueousSolvent, Rest],
              Prepend[(Append[#, cleanedAqueousSolvent]&)/@Rest[correctSolventAdditions], First[correctSolventAdditions]],
            MatchQ[addAqueousSolvent, First],
              {Append[First[correctSolventAdditions], cleanedAqueousSolvent], Sequence@@Rest[correctSolventAdditions]},
            True,
              correctSolventAdditions
          ];

          (* Add our Organic Solvents to the list. *)
          correctSolventAdditions=Which[
            MatchQ[addOrganicSolvent, All],
              (Append[#, cleanedOrganicSolvent]&)/@correctSolventAdditions,
            MatchQ[addOrganicSolvent, Rest],
              Prepend[(Append[#, cleanedOrganicSolvent]&)/@Rest[correctSolventAdditions], First[correctSolventAdditions]],
            MatchQ[addOrganicSolvent, First],
              {Append[First[correctSolventAdditions], cleanedOrganicSolvent], Sequence@@Rest[correctSolventAdditions]},
            True,
              correctSolventAdditions
          ];

          (* Delist each of our elements accordingly. *)
          correctSolventAdditions=(Which[Length[#]==0, None, Length[#]==1, First[#], True, #]&)/@correctSolventAdditions;
          cleanedSolventAdditions=(Which[Length[#]==0, None, Length[#]==1, First[#], True, #]&)/@solventAdditions;

          If[!MatchQ[cleanedSolventAdditions, correctSolventAdditions],
            {
              sample,
              solventAdditions,
              correctSolventAdditions,
              index
            },
            Nothing
          ]
        ]
      ]
    ],
    {mySamples, resolvedSolventAdditions, resolvedAqueousSolvents, resolvedOrganicSolvents, resolvedAddAqueousSolvents, resolvedAddOrganicSolvents, Lookup[myOptions, NumberOfExtractions], Range[Length[mySamples]]}
  ];

  If[Length[invalidSolventAdditions]>0 && messages,
    Message[
      Error::InvalidSolventAdditions,
      ObjectToString[invalidSolventAdditions[[All,1]], Cache -> cacheBall],
      ObjectToString[invalidSolventAdditions[[All,2]], Cache -> cacheBall],
      ObjectToString[invalidSolventAdditions[[All,3]], Cache -> cacheBall],
      invalidSolventAdditions[[All,4]]
    ];
  ];

  invalidSolventAdditionsTest=If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = invalidSolventAdditions[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " have correct solvent additions (via the SolventAdditions option) such that there will be both an Aqueous and Organic phase at the start of each extraction round (after adding the specified solvent(s)):", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " have correct solvent additions (via the SolventAdditions option) such that there will be both an Aqueous and Organic phase at the start of each extraction round (after adding the specified solvent(s)):", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* ExtractionTechnique / ExtractionDevice / IncludeBoundary / ExtractionBoundaryVolume / ExtractionTransferLayer conflicting options. *)
  extractionOptionMismatchResult=MapThread[
    Function[{sample, extractionTechnique, extractionDevice, includeBoundary, extractionBoundaryVolume, extractionTransferLayer, index},
      If[Or[
          And[
            MatchQ[extractionTechnique, Pipette],
            Or[
              MatchQ[extractionDevice, ObjectP[]],
              MatchQ[includeBoundary, Null],
              MatchQ[extractionBoundaryVolume, Null],
              MatchQ[extractionTransferLayer, Null]
            ]
          ],
          And[
            MatchQ[extractionTechnique, PhaseSeparator],
            Or[
              !MatchQ[extractionDevice, ObjectP[]],
              !MatchQ[includeBoundary, Null],
              !MatchQ[extractionBoundaryVolume, Null],
              !MatchQ[extractionTransferLayer, Null]
            ]
          ]
        ],
        {sample, extractionTechnique, extractionDevice, includeBoundary, extractionBoundaryVolume, extractionTransferLayer, index},
        Nothing
      ]
    ],
    {mySamples, resolvedExtractionTechniques, resolvedExtractionDevices, resolvedIncludeBoundaries, resolvedExtractionBoundaryVolumes, resolvedExtractionTransferLayers, Range[Length[mySamples]]}
  ];

  If[Length[extractionOptionMismatchResult]>0 && messages,
    Message[
      Error::ExtractionOptionMismatch,
      ObjectToString[extractionOptionMismatchResult[[All,1]], Cache -> cacheBall],
      extractionOptionMismatchResult[[All,2]],
      ObjectToString[extractionOptionMismatchResult[[All,3]], Cache -> cacheBall],
      extractionOptionMismatchResult[[All,4]],
      ObjectToString[extractionOptionMismatchResult[[All,5]], Cache -> cacheBall],
      extractionOptionMismatchResult[[All,6]],
      extractionOptionMismatchResult[[All,7]]
    ];
  ];

  extractionOptionMismatchTest=If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = extractionOptionMismatchResult[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have conflicting ExtractionTechnique/ExtractionDevice/IncludeBoundary/ExtractionBoundaryVolume/ExtractionTransferLayer options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have conflicting ExtractionTechnique/ExtractionDevice/IncludeBoundary/ExtractionBoundaryVolume/ExtractionTransferLayer options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* DemulsifierAdditions / Demulsifier conflict. *)
  demulsifierSpecifiedResult=MapThread[
    Function[{sample, demulsifierAdditions, demulsifier, index},
      If[!MatchQ[demulsifierAdditions, {(ObjectP[demulsifier]|None)..}],
        {sample, demulsifierAdditions, demulsifier, index},
        Nothing
      ]
    ],
    {mySamples, resolvedDemulsifierAdditions, resolvedDemulsifiers, Range[Length[mySamples]]}
  ];

  If[Length[demulsifierSpecifiedResult]>0 && messages,
    Message[
      Error::DemulsifierSpecifiedConflict,
      ObjectToString[demulsifierSpecifiedResult[[All,1]], Cache -> cacheBall],
      ObjectToString[demulsifierSpecifiedResult[[All,2]], Cache -> cacheBall],
      ObjectToString[demulsifierSpecifiedResult[[All,3]], Cache -> cacheBall],
      demulsifierSpecifiedResult[[All,4]]
    ];
  ];

  demulsifierSpecifiedTest=If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = demulsifierSpecifiedResult[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have samples specified in the DemulsifierAdditions option that are not in the Demulsifier option:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have samples specified in the DemulsifierAdditions option that are not in the Demulsifier option:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* Conflicting Mix options *)
  conflictingMixOptionsResult = MapThread[
    Function[{sample, mixType, mixTimes, mixRates, numberOfMixes, mixVolume, index},
      If[Or[
          And[
            MatchQ[mixType, Pipette],
            Or[
              MatchQ[mixTimes, TimeP],
              MatchQ[mixRates, RPMP],
              MatchQ[numberOfMixes, Except[_Integer]],
              MatchQ[mixVolume, Except[VolumeP]]
            ]
          ],
          And[
            MatchQ[mixType, Shake],
            Or[
              MatchQ[mixTimes, Except[TimeP]],
              MatchQ[mixRates, Except[RPMP]],
              MatchQ[numberOfMixes, _Integer],
              MatchQ[mixVolume, VolumeP]
            ]
          ]
        ],
        {sample, mixType, mixTimes, mixRates, numberOfMixes, mixVolume, index},
        Nothing
      ]
    ],
    {mySamples, resolvedExtractionMixTypes, resolvedExtractionMixTimes, resolvedExtractionMixRates, resolvedNumberOfExtractionMixes, resolvedExtractionMixVolumes, Range[Length[mySamples]]}
  ];

  If[Length[conflictingMixOptionsResult]>0 && messages,
    Message[
      Error::ConflictingMixParametersForLLE,
      ObjectToString[conflictingMixOptionsResult[[All,1]], Cache -> cacheBall],
      conflictingMixOptionsResult[[All,2]],
      ObjectToString[conflictingMixOptionsResult[[All,3]], Cache -> cacheBall],
      conflictingMixOptionsResult[[All,4]],
      ObjectToString[conflictingMixOptionsResult[[All,5]], Cache -> cacheBall],
      ObjectToString[conflictingMixOptionsResult[[All,6]], Cache -> cacheBall],
      conflictingMixOptionsResult[[All,7]]
    ];
  ];

  conflictingMixOptionsTest=If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = conflictingMixOptionsResult[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have conflicting mix options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have conflicting mix options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* Throw Error::OrganicSolventDensityPhaseSeparator. *)
  (* Make sure that the organic solvent specified is denser than both the aqueous solvent (if applicable) and the *)
  (* or sample's aqueous layer (if applicable) if we're using a phase separator. *)
  organicLayerDensityErrors=MapThread[
    Function[{extractionTechnique, targetPhase, targetLayer},
      And[
        MatchQ[extractionTechnique, PhaseSeparator],
        Or[
          And[
            MatchQ[targetPhase, Aqueous],
            MemberQ[ToList[targetLayer], Bottom]
          ],
          And[
            MatchQ[targetPhase, Organic],
            MemberQ[ToList[targetLayer], Top]
          ]
        ]
      ]
    ],
    {resolvedExtractionTechniques, resolvedTargetPhases, resolvedTargetLayers}
  ];

  If[MemberQ[organicLayerDensityErrors, True] && messages,
    Message[
      Error::OrganicSolventDensityPhaseSeparator,
      ObjectToString[PickList[mySamples, organicLayerDensityErrors], Cache -> cacheBall],
      PickList[Range[Length[mySamples]], organicLayerDensityErrors]
    ];
  ];

  organicLayerDensityTest=If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = PickList[mySamples, organicLayerDensityErrors];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " have a denser Organic phase compared to the Aqueous phase when using a Phase Separator:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " have a denser Organic phase compared to the Aqueous phase when using a Phase Separator:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* Check for conflicting centrifuge parameters for the same working container. *)
  conflictingCentrifugeContainerOptionsResult = Module[{uniqueCentrifugeContainersAndParameters},
    uniqueCentrifugeContainersAndParameters=DeleteDuplicates@Transpose[{
      MapThread[
        Function[{sampleContainer, extractionContainer},
          (* If ExtractionContainer is set to Model[Container], we will get a new container so there can't be a conflict. *)
          Which[
            MatchQ[extractionContainer, ObjectP[Model[Container]]],
              CreateUUID[],
            MatchQ[extractionContainer, {_Integer, ObjectP[Model[Container]]}],
              extractionContainer,
            MatchQ[extractionContainer, ObjectP[Object[Container]]],
              extractionContainer,
            True,
              sampleContainer
          ]
        ],
        {Download[Lookup[samplePackets, Container], Object], resolvedExtractionContainers}
      ],
      resolvedCentrifugeBools,
      resolvedCentrifugeInstruments,
      resolvedCentrifugeIntensitys,
      resolvedCentrifugeTimes
    }];

    Normal[
      (Sequence@@#&)/@Select[GroupBy[uniqueCentrifugeContainersAndParameters, (#[[1]]&)], (MatchQ[#, _List] && Length[#]>1&)],
      Association
    ][[All,2]]
  ];

  If[Length[conflictingCentrifugeContainerOptionsResult]>0 && messages,
    Message[
      Error::ConflictingCentrifugeContainerParametersForLLE,
      ObjectToString[conflictingCentrifugeContainerOptionsResult[[All,1]], Cache -> cacheBall],
      conflictingCentrifugeContainerOptionsResult[[All,2]],
      ObjectToString[conflictingCentrifugeContainerOptionsResult[[All,3]], Cache -> cacheBall],
      ObjectToString[conflictingCentrifugeContainerOptionsResult[[All,4]], Cache -> cacheBall],
      ObjectToString[conflictingCentrifugeContainerOptionsResult[[All,5]], Cache -> cacheBall]
    ];
  ];

  conflictingCentrifugeContainerOptionsTest=If[gatherTests,
    Module[{affectedContainers, failingTest, passingTest},
      affectedContainers = conflictingCentrifugeContainerOptionsResult[[All,1]];

      failingTest = If[Length[affectedContainers] == 0,
        Nothing,
        Test["The container(s) " <> ObjectToString[affectedContainers, Cache -> cacheBall] <> " do not have conflicting centrifugation options specified:", True, False]
      ];

      passingTest = If[Length[affectedContainers] == Length[DeleteDuplicates[Download[Lookup[samplePackets, Container], Object]]] && Length[affectedContainers] > 0,
        Nothing,
        Test["The container(s) " <> ObjectToString[Complement[DeleteDuplicates[Download[Lookup[samplePackets, Container], Object]], affectedContainers], Cache -> cacheBall] <> " do not have conflicting centrifugation options specified:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];


  (* Conflicting Centrifuge options (not taking into account containers). *)
  conflictingCentrifugeOptionsResult = MapThread[
    Function[{sample, centrifuge, centrifugeInstrument, centrifugeIntensity, centrifugeTimes, index},
      If[Or[
          And[
            MatchQ[centrifuge, True],
            Or[
              MatchQ[centrifugeInstrument, Null],
              MatchQ[centrifugeIntensity, Null],
              MatchQ[centrifugeTimes, Null]
            ]
          ],
          And[
            MatchQ[centrifuge, Except[True]],
            Or[
              MatchQ[centrifugeInstrument, Except[Null]],
              MatchQ[centrifugeIntensity, Except[Null]],
              MatchQ[centrifugeTimes, Except[Null]]
            ]
          ]
        ],
        {sample, centrifuge, centrifugeInstrument, centrifugeIntensity, centrifugeTimes, index},
        Nothing
      ]
    ],
    {mySamples, resolvedCentrifugeBools, resolvedCentrifugeInstruments, resolvedCentrifugeIntensitys, resolvedCentrifugeTimes, Range[Length[mySamples]]}
  ];

  If[Length[conflictingCentrifugeOptionsResult]>0 && messages,
    Message[
      Error::ConflictingCentrifugeParametersForLLE,
      ObjectToString[conflictingCentrifugeOptionsResult[[All,1]], Cache -> cacheBall],
      conflictingCentrifugeOptionsResult[[All,2]],
      ObjectToString[conflictingCentrifugeOptionsResult[[All,3]], Cache -> cacheBall],
      ObjectToString[conflictingCentrifugeOptionsResult[[All,4]], Cache -> cacheBall],
      ObjectToString[conflictingCentrifugeOptionsResult[[All,5]], Cache -> cacheBall],
      conflictingCentrifugeOptionsResult[[All,6]]
    ];
  ];

  conflictingCentrifugeOptionsTest=If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = conflictingCentrifugeOptionsResult[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have conflicting centrifuge options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have conflicting centrifuge options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];


  (* Check for conflicting temperatures for the same working container. *)
  conflictingTemperaturesResult = Module[{uniqueContainersAndTemperatures},
    uniqueContainersAndTemperatures=DeleteDuplicates@Transpose[{
      MapThread[
        Function[{sampleContainer, extractionContainer},
          (* If ExtractionContainer is set to Model[Container], we will get a new container so there can't be a conflict. *)
          Which[
            MatchQ[extractionContainer, ObjectP[Model[Container]]],
              CreateUUID[],
            MatchQ[extractionContainer, {_Integer, ObjectP[Model[Container]]}],
              extractionContainer,
            MatchQ[extractionContainer, ObjectP[Object[Container]]],
              extractionContainer,
            True,
              sampleContainer
          ]
        ],
        {Download[Lookup[samplePackets, Container], Object], resolvedExtractionContainers}
      ],
      Lookup[listedOptions, Temperature]
    }];

    Normal[
      (Sequence@@#&)/@Select[GroupBy[uniqueContainersAndTemperatures, (#[[1]]&)], (MatchQ[#, _List] && Length[#]>1&)],
      Association
    ][[All,2]]
  ];

  If[Length[conflictingTemperaturesResult]>0 && messages,
    Message[
      Error::ConflictingTemperaturesForLLE,
      ObjectToString[conflictingTemperaturesResult[[All,1]], Cache -> cacheBall],
      ObjectToString[conflictingTemperaturesResult[[All,2]], Cache -> cacheBall]
    ];
  ];

  conflictingTemperaturesTest=If[gatherTests,
    Module[{affectedContainers, failingTest, passingTest},
      affectedContainers = conflictingTemperaturesResult[[All,1]];

      failingTest = If[Length[affectedContainers] == 0,
        Nothing,
        Test["The container(s) " <> ObjectToString[affectedContainers, Cache -> cacheBall] <> " do not have conflicting temperature options specified:", True, False]
      ];

      passingTest = If[Length[affectedContainers] == Length[DeleteDuplicates[Download[Lookup[samplePackets, Container], Object]]] && Length[affectedContainers] > 0,
        Nothing,
        Test["The container(s) " <> ObjectToString[Complement[DeleteDuplicates[Download[Lookup[samplePackets, Container], Object]], affectedContainers], Cache -> cacheBall] <> " do not have conflicting temperature options specified:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  invalidInputs=DeleteDuplicates[Flatten[{}]];

  invalidOptions=DeleteDuplicates[Flatten[{
    If[Length[extractionOptionMismatchResult]>0,
      {ExtractionTechnique, ExtractionDevice, IncludeBoundary, ExtractionBoundaryVolume, ExtractionTransferLayer},
      {}
    ],
    If[Length[solventAdditionsMismatch]>0,
      {SolventAdditions, AqueousSolvent, OrganicSolvent},
      {}
    ],
    If[Length[invalidSolventAdditions]>0,
      {SolventAdditions},
      {}
    ],
    If[Length[extractionRoundMismatches]>0,
      DeleteDuplicates[extractionRoundMismatches[[All,2]]],
      {}
    ],
    If[Length[demulsifierSpecifiedResult]>0,
      {Demulsifier},
      {}
    ],
    If[Length[conflictingMixOptionsResult]>0,
      {ExtractionMixType, ExtractionMixTime, ExtractionMixRate, NumberOfExtractionMixes, ExtractionMixVolume},
      {}
    ],
    If[MemberQ[organicLayerDensityErrors, True],
      {ExtractionTechnique, OrganicSolvent, TargetPhase, TargetLayer},
      {}
    ],
    If[Length[conflictingCentrifugeContainerOptionsResult]>0,
      {Centrifuge, CentrifugeInstrument, CentrifugeIntensity, CentrifugeTime},
      {}
    ],
    If[Length[conflictingCentrifugeOptionsResult]>0,
      {Centrifuge, CentrifugeInstrument, CentrifugeIntensity, CentrifugeTime},
      {}
    ],
    If[Length[conflictingTemperaturesResult]>0,
      {Temperature},
      {}
    ]
  }]];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[Length[invalidInputs]>0&&!gatherTests,
    Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cache]]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions]>0&&!gatherTests,
    Message[Error::InvalidOption,invalidOptions]
  ];

  (* Return our resolved options and/or tests. *)
  outputSpecification/.{
    Result -> resolvedOptions,
    Tests -> Flatten[{
      optionPrecisionTests,
      ambiguousAnalyteTest,
      targetPhaseWeakAffinityTest,
      noAvailableLogPTest,
      noTargetAnalyteTest,
      solventAdditionsMismatchTest,
      invalidSolventAdditionsTest,
      extractionRoundMismatches,
      conflictingMixOptionsTest,
      demulsifierSpecifiedTest,
      extractionOptionMismatchTest,
      organicLayerDensityTest,
      conflictingCentrifugeContainerOptionsTest,
      conflictingCentrifugeOptionsTest,
      conflictingTemperaturesTest
    }]
  }
];

(* Helper function that given a volume calibration function for a container, the volume of the bottom layer, and *)
(* the distance of the boundary layer, will calculate the volume of the boundary layer. *)
resolveBoundaryVolume[
  myBoundaryLayerHeight:DistanceP,
  myBottomLayerVolume:VolumeP,
  myContainerModelPacket:PacketP[Model[Container]],
  latestVolumeCalibrationPacket:(_Association|Null|{})
]:=If[!MatchQ[latestVolumeCalibrationPacket, PacketP[Object[Calibration, Volume]]],
  (* If we didn't get a volume calibration (the container isn't parameterized), assume that the container is a perfect cylinder. *)
  Module[{diameter},
    (* Get the diameter of the container. *)
    diameter=Which[
      MatchQ[Lookup[myContainerModelPacket, InternalDiameter], DistanceP],
        Lookup[myContainerModelPacket, InternalDiameter],
      MatchQ[Lookup[myContainerModelPacket, InternalDimensions], {DistanceP, DistanceP}],
        Lookup[myContainerModelPacket, InternalDimensions][[1]],
      MatchQ[Lookup[myContainerModelPacket, WellDiameter], DistanceP],
        Lookup[myContainerModelPacket, WellDiameter],
      MatchQ[Lookup[myContainerModelPacket, WellDimensions], {DistanceP..}],
        Lookup[myContainerModelPacket, WellDimensions][[1]],
      True,
        Null
    ];

    (* Assume that the container is a perfect cylinder. Since cylinders are the same diameter throughout the container, *)
    (* we can just use the formula for a cylinder for the height of the boundary layer. *)
    (Pi * (diameter / 2)^2 * myBoundaryLayerHeight)
  ],
  Module[
    {containerHeight, calibrationQuantityFunction,rawCalibrationFunction,inverseFunction,inputUnit,outputUnit,
      distanceDerivedFromCalibration, boundaryLayerAndBottomLayerVolume},

    (* What is the maximum height of the container? Look for InternalDepth first; if not available, use Z-dimension which is external height as estimate. *)
    containerHeight=Which[
      MatchQ[Lookup[myContainerModelPacket, InternalDepth], DistanceP], Lookup[myContainerModelPacket, InternalDepth],
      MatchQ[Lookup[myContainerModelPacket, Dimensions], _List], Lookup[myContainerModelPacket, Dimensions][[3]],
      True, 0 Meter
    ];

    (* Get the volume calibration function. *)
    calibrationQuantityFunction=Lookup[latestVolumeCalibrationPacket, CalibrationFunction];

    (* Our calibration function is a QuantityFunction[rawFunction, ListableP[inputUnits], outputUnit]. *)
    (* Pull out the raw function and invert it since we want to go from volume to distance. *)
    rawCalibrationFunction=calibrationQuantityFunction[[1]];

    (* Now get the input units. It's listable so pull out the first distance. *)
    (* NOTE: The input and output unit will get swapped since we're inverting the function. *)
    inputUnit=FirstCase[calibrationQuantityFunction[[2]], DistanceP];
    outputUnit=calibrationQuantityFunction[[3]];

    (* Attempt to invert the function. If we didn't get another function out, then InverseFunction didn't work. *)
    inverseFunction=Quiet[InverseFunction[rawCalibrationFunction]];

    (* Convert to the input unit, strip off the unit, then tack on the output unit. *)
    (* NOTE: Include a little buffer in the amount that we're aspirating to be safe. *)
    (* NOTE: The calibration function used to give us the distance from the volume sensor, which is at the top of the container. *)
    (* However, this is no longer true. Calibrations now return the height from the inside of the container bottom so the below has been updated. *)
    (* NOTE: InverseFunction does not work on piecewise functions so we need to solve analytically if we have a piecewise. *)
    distanceDerivedFromCalibration=If[MatchQ[inverseFunction, Verbatim[InverseFunction][___]],
      (* Solve analytically. *)
      Module[{uniqueVariable},
        uniqueVariable=Unique[t];

        Lookup[
          FirstCase[
            Quiet@Solve[
              (* volume = calibrationFunction (with #1 subbed with t so we can solve for t). *)
              Unitless[UnitConvert[Max[{1 Microliter, myBottomLayerVolume}], outputUnit]]==(rawCalibrationFunction[[1]]/.{#->uniqueVariable}),
              uniqueVariable,
              Reals
            ],
            (* get the first solution that returns a non-negative value *)
            {uniqueVariable->GreaterEqualP[0]},
            (* If there is no analytical solution, assume the bottle is empty (so it's all the way at the bottom). Set the uniqueVariable as either containerHeight or 0 depending on the characteristic of volume calibration function. *)
            {uniqueVariable->If[rawCalibrationFunction[2]<rawCalibrationFunction[1],Unitless[containerHeight],0]},
            (* don't remove the levelspec or this function will error out *)
            {1}
          ],
          uniqueVariable
        ] * inputUnit
      ],
      (* Use our symbolic function. *)
      inverseFunction[
        Unitless[UnitConvert[Max[{1 Microliter, myBottomLayerVolume}], outputUnit]]
      ] * inputUnit
    ];

    (* Add calibrationQuantityFunction[myBoundaryLayerHeight + distanceDerivedFromCalibration] gives us the volume of the *)
    (* boundary layer and bottom layer. *)
    boundaryLayerAndBottomLayerVolume = calibrationQuantityFunction[myBoundaryLayerHeight + distanceDerivedFromCalibration];

    (* This is the volume of the boundary layer on top of the bottom layer, assuming the boundary layer is myBoundaryLayerHeight in height. *)
    boundaryLayerAndBottomLayerVolume - myBottomLayerVolume
  ]
];

(* ::Subsection::Closed:: *)
(* liquidLiquidExtractionResourcePackets *)


(* --- liquidLiquidExtractionResourcePackets --- *)

DefineOptions[
  liquidLiquidExtractionResourcePackets,
  Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

liquidLiquidExtractionResourcePackets[mySamples:ListableP[ObjectP[Object[Sample]]],myTemplatedOptions:{(_Rule|_RuleDelayed)...},myResolvedOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[
  {
    expandedInputs, expandedResolvedOptionsExceptSolventAdditions, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests,
    messages, inheritedCache, samplePackets, uniqueSamplesInResources, resolvedPreparation, mapThreadFriendlyOptionsExceptSolventAdditions, mapThreadFriendlyOptions,
    samplesInResources, sampleContainersIn, uniqueSampleContainersInResources, containersInResources,
    protocolPacket,allResourceBlobs,resourcesOk,resourceTests,previewRule, optionsRule,testsRule,resultRule,
    allUnitOperationPackets, currentSimulation, userSpecifiedLabels, runTime
  },

  (* get the inherited cache *)
  inheritedCache = Lookup[ToList[ops],Cache,{}];

  (* Get the simulation *)
  currentSimulation=Lookup[ToList[ops],Simulation,{}];

  (* Lookup the resolved Preparation option. *)
  resolvedPreparation=Lookup[myResolvedOptions, Preparation];

  (* expand the resolved options if they weren't expanded already *)
  {expandedInputs, expandedResolvedOptionsExceptSolventAdditions} = ExpandIndexMatchedInputs[ExperimentLiquidLiquidExtraction, {mySamples}, myResolvedOptions];

  (* Correct expansion of SolventAdditions. *)
  (* NOTE:This is needed because SolventAdditions is not correctly expanded by ExpandIndexMatchedInputs. *)
  expandedResolvedOptions = Which[
    (* If the length of SolventAdditions matches the number of samples, then it is correctly index matched and is used as-is. *)
    MatchQ[Length[Lookup[myResolvedOptions, SolventAdditions]], Length[ToList[mySamples]]] && MatchQ[Lookup[myResolvedOptions, SolventAdditions], {Except[ObjectP[]]..}],
      ReplaceRule[
        expandedResolvedOptionsExceptSolventAdditions,
        SolventAdditions -> Lookup[myResolvedOptions, SolventAdditions]
      ],
    (* If the length of SolventAdditions matches the NumberOfExtractions, then it is expanded to match the number of samples. *)
    MatchQ[Length[Lookup[myResolvedOptions, SolventAdditions]], Lookup[myResolvedOptions, NumberOfExtractions]],
      ReplaceRule[
        expandedResolvedOptionsExceptSolventAdditions,
        SolventAdditions -> ConstantArray[Lookup[myResolvedOptions, SolventAdditions], Length[ToList[mySamples]]]
      ],
    (* Otherwise, there is a mismatch and the option is used as-is. *)
    True,
      expandedResolvedOptionsExceptSolventAdditions
  ];

  (* Correct expansion of SolventAdditions. *)
  (* NOTE:This is needed because SolventAdditions is not correctly expanded by ExpandIndexMatchedInputs. *)
  expandedResolvedOptions = Which[
    (* If the length of SolventAdditions matches the number of samples, then it is correctly index matched and is used as-is. *)
    MatchQ[Length[Lookup[myResolvedOptions, SolventAdditions]], Length[ToList[mySamples]]] && MatchQ[Lookup[myResolvedOptions, SolventAdditions], {Except[ObjectP[]]..}],
      ReplaceRule[
        expandedResolvedOptions,
        SolventAdditions -> Lookup[myResolvedOptions, SolventAdditions]
      ],
    (* If the length of SolventAdditions matches the NumberOfExtractions, then it is expanded to match the number of samples. *)
    MatchQ[Length[Lookup[myResolvedOptions, SolventAdditions]], Lookup[myResolvedOptions, NumberOfExtractions]],
      ReplaceRule[
        expandedResolvedOptions,
        SolventAdditions -> ConstantArray[Lookup[myResolvedOptions, SolventAdditions], Length[ToList[mySamples]]]
      ],
    (* Otherwise, there is a mismatch and the option is used as-is. *)
    True,
      expandedResolvedOptions
  ];

  (* Get the resolved collapsed index matching options that don't include hidden options *)
  resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
    ExperimentLiquidLiquidExtraction,
    RemoveHiddenOptions[ExperimentLiquidLiquidExtraction,myResolvedOptions],
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
  samplePackets=Download[
    mySamples,
    Packet[Container, Position],
    Cache->inheritedCache,
    Simulation->currentSimulation
  ];

  (* Create resources for our samples in. *)
  uniqueSamplesInResources=(#->Resource[Sample->#, Name->CreateUUID[]]&)/@DeleteDuplicates[Download[mySamples, Object]];
  samplesInResources=(Download[mySamples, Object])/.uniqueSamplesInResources;

  (* Create resources for our containers in. *)
  sampleContainersIn=Lookup[samplePackets, Container];
  uniqueSampleContainersInResources=(#->Resource[Sample->#, Name->CreateUUID[]]&)/@DeleteDuplicates[sampleContainersIn];
  containersInResources=(Download[sampleContainersIn, Object])/.uniqueSampleContainersInResources;

  (* Get our map thread friendly options. *)
  mapThreadFriendlyOptionsExceptSolventAdditions=OptionsHandling`Private`mapThreadOptions[
    ExperimentLiquidLiquidExtraction,
    myResolvedOptions
  ];

  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  mapThreadFriendlyOptions = Module[{solventAdditionsInput},

    solventAdditionsInput = Lookup[expandedResolvedOptions, SolventAdditions];

    MapThread[
      Function[{options, index},
        Merge[
          {
            options,
            <|
              SolventAdditions -> solventAdditionsInput[[index]]
            |>
          },
          Last
        ]
      ],
      {mapThreadFriendlyOptionsExceptSolventAdditions, Range[1, Length[mapThreadFriendlyOptionsExceptSolventAdditions]]}
    ]

  ];

  (* Get our user specified labels. *)
  userSpecifiedLabels=DeleteDuplicates@Cases[
    Flatten@Lookup[
      myResolvedOptions,
      {SampleLabel, SampleContainerLabel, TargetLabel, TargetContainerLabel, ImpurityLabel, ImpurityContainerLabel}
    ],
    _String
  ];

  (* --- Create the protocol packet --- *)
  (* make unit operation packets for the UOs we just made here *)
  {protocolPacket, allUnitOperationPackets, currentSimulation, runTime} = Module[
    {extractionContainerLabels, extractionContainers, targetContainerLabels, impurityContainerLabels,
      mapThreadFriendlyOptionsWithUpdatedLabels, labelSampleAndContainerUnitOperations, sampleContainerLabels,
      workingSampleContainerLabels, workingSampleContainerWells, aliquotUnitOperations, residualIncubationUnitOperations,
      phaseSeparatorUnitOperations, allPhaseSeparatorLabels, allCollectionContainerLabels, phaseSeparatorAndCollectionContainerLabelUnitOperations,
      pipetteUnitOperations, labelSampleUnitOperation, primitives, roboticUnitOperationPackets, roboticRunTime, roboticSimulation,
      experimentFunction, outputUnitOperationPacket},

    (* Create an index matched (to samples) list of extraction container labels. *)
    (* We don't have a ExtractionContainerLabel option, so we just make labels ourselves. *)
    {extractionContainers, extractionContainerLabels}=Module[
      {uniqueExtractionContainersWithIntegers, uniqueExtractionContainersWithIntegerLabels, uniqueExtractionContainersWithIntegersToLabelsLookup},

      (* Get all of the integer labeled extraction containers. These should have the same label. *)
      uniqueExtractionContainersWithIntegers=DeleteDuplicates@Cases[
        Lookup[myResolvedOptions, ExtractionContainer],
        {_Integer, ObjectP[Model[Container]]}
      ];
      uniqueExtractionContainersWithIntegerLabels=Table[
        CreateUniqueLabel["liquid liquid extraction container", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels],
        {x, 1, Length[uniqueExtractionContainersWithIntegers]}
      ];

      uniqueExtractionContainersWithIntegersToLabelsLookup=Association[Rule@@@Transpose[{uniqueExtractionContainersWithIntegers, uniqueExtractionContainersWithIntegerLabels}]];

      Transpose@Map[
        Function[{extractionContainer},
          Which[
            MatchQ[extractionContainer, Null],
            {Null, Null},
            KeyExistsQ[uniqueExtractionContainersWithIntegersToLabelsLookup, extractionContainer],
            {
              extractionContainer[[2]],
              Lookup[uniqueExtractionContainersWithIntegersToLabelsLookup, Key[extractionContainer]]
            },
            True,
            {
              extractionContainer,
              CreateUniqueLabel["liquid liquid extraction container", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels]
            }
          ]
        ],
        Lookup[myResolvedOptions, ExtractionContainer]
      ]
    ];

    (* Make sure that the user didn't set any of the TargetContainerLabels to Null since we rely on them being *)
    (* filled out in order to label containers for use in our unit operations. *)
    targetContainerLabels=Module[{sanitizedTargetContainerOuts, combinedContainersToLabels, containersToLabels},
      (* Model[Container] means that a new container should be used. To make sure that this is the case, replace them with UUIDs. *)
      sanitizedTargetContainerOuts=Replace[Lookup[myResolvedOptions, TargetContainerOut], ObjectP[Model[Container]] :> CreateUUID[], {1}];

      (* Make sure that all TargetContainerOuts have a label. *)
      (* This should already be the case but sometimes the user is stupid and sets the label to be Null manually. *)
      (* This is in the format <|container1 -> {label1, label1}, container2 -> {label2, label2, Null}|> *)
      combinedContainersToLabels=GroupBy[
        Rule@@@Transpose[{sanitizedTargetContainerOuts, Lookup[myResolvedOptions, TargetContainerLabel]}],
        First->Last
      ];

      (* Take the first label set for the container, if there are no labels, make a unique one to use internally in our UOs. *)
      containersToLabels=Normal[
        Map[
          (FirstCase[#, _String, CreateUniqueLabel["liquid liquid extraction target sample container out", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels]]&),
          combinedContainersToLabels
        ],
        Association
      ];

      (Lookup[containersToLabels, Key[#]]&)/@sanitizedTargetContainerOuts
    ];

    (* Same thing for ImpurityContainerLabel. *)
    impurityContainerLabels=Module[{sanitizedImpurityContainerOuts, combinedContainersToLabels, containersToLabels},
      (* Model[Container] means that a new container should be used. To make sure that this is the case, replace them with UUIDs. *)
      sanitizedImpurityContainerOuts=Replace[Lookup[myResolvedOptions, ImpurityContainerOut], ObjectP[Model[Container]] :> CreateUUID[], {1}];

      (* Make sure that all ImpurityContainerOuts have a label. *)
      (* This should already be the case but sometimes the user is stupid and sets the label to be Null manually. *)
      (* This is in the format <|container1 -> {label1, label1}, container2 -> {label2, label2, Null}|> *)
      combinedContainersToLabels=GroupBy[
        Rule@@@Transpose[{sanitizedImpurityContainerOuts, Lookup[myResolvedOptions, ImpurityContainerLabel]}],
        First->Last
      ];

      (* Take the first label set for the container, if there are no labels, make a unique one to use internally in our UOs. *)
      containersToLabels=Normal[
        Map[
          (FirstCase[#, _String, CreateUniqueLabel["liquid liquid extraction impurity sample container out", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels]]&),
          combinedContainersToLabels
        ],
        Association
      ];

      (Lookup[containersToLabels, Key[#]]&)/@sanitizedImpurityContainerOuts
    ];

    mapThreadFriendlyOptionsWithUpdatedLabels=OptionsHandling`Private`mapThreadOptions[
      ExperimentLiquidLiquidExtraction,
      ReplaceRule[
        myResolvedOptions,
        {
          TargetContainerLabel -> targetContainerLabels,
          ImpurityContainerLabel -> impurityContainerLabels
        }
      ]
    ];

    (* Make sure that all of our sample containers are labeled in case the user set Null for some reason. *)
    sampleContainerLabels=Module[{combinedContainersToLabels, containersToLabels},
      (* Make sure that all sample containers have a label. *)
      (* This should already be the case but sometimes the user is stupid and sets the label to be Null manually. *)
      (* This is in the format <|container1 -> {label1, label1}, container2 -> {label2, label2, Null}|> *)
      combinedContainersToLabels=GroupBy[
        Rule@@@Transpose[{Download[Lookup[samplePackets, Container], Object], Lookup[myResolvedOptions, SampleContainerLabel]}],
        First->Last
      ];

      (* Take the first label set for the container, if there are no labels, make a unique one to use internally in our UOs. *)
      containersToLabels=Normal[
        Map[
          (FirstCase[#, _String, CreateUniqueLabel["liquid liquid extraction sample container", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels]]&),
          combinedContainersToLabels
        ],
        Association
      ];

      (Lookup[containersToLabels, Key[#]]&)/@Download[Lookup[samplePackets, Container], Object]
    ];

    (* Get our working containers. If ExtractionContainer is Null, we will be transferring from the original sample's *)
    (* container. *)
    workingSampleContainerLabels = MapThread[
      Function[{extractionContainerLabel, sampleContainerLabel},
        If[MatchQ[extractionContainerLabel, Null],
          sampleContainerLabel,
          extractionContainerLabel
        ]
      ],
      {extractionContainerLabels, sampleContainerLabels}
    ];
    workingSampleContainerWells = MapThread[
      Function[{extractionContainerWell, sampleWell},
        If[MatchQ[extractionContainerWell, Null],
          sampleWell,
          extractionContainerWell
        ]
      ],
      {Lookup[myResolvedOptions, ExtractionContainerWell], Lookup[samplePackets, Position]}
    ];

    (* LabelContainer/LabelSample *)
    (* NOTE: Also label phase separators after figuring out which samples are going to be transferred to which *)
    (* phase separator wells during which extraction rounds. Also label collection plates for phase separators. *)
    labelSampleAndContainerUnitOperations={
      (* Sample Labels *)
      LabelSample[
        Label -> Lookup[myResolvedOptions, SampleLabel],
        Sample -> mySamples
      ],

      (* Sample Container Labels *)
      LabelContainer[
        Label -> DeleteDuplicates[Transpose[{Lookup[samplePackets, Container], sampleContainerLabels}]][[All,2]],
        Container -> DeleteDuplicates[Transpose[{Lookup[samplePackets, Container], sampleContainerLabels}]][[All,1]]
      ],

      (* Extraction Container Labels. *)
      Module[{uniqueExtractionContainersAndLabels},
        uniqueExtractionContainersAndLabels=Cases[
          DeleteDuplicates[Transpose[{extractionContainers, extractionContainerLabels}]],
          Except[{Null, Null}]
        ];

        If[Length[uniqueExtractionContainersAndLabels]>0,
          LabelContainer[
            Label -> uniqueExtractionContainersAndLabels[[All,2]],
            Container -> uniqueExtractionContainersAndLabels[[All,1]]
          ],
          Nothing
        ]
      ],

      (* TargetContainerOut Labels. *)
      Module[{uniqueTargetContainersAndLabels},
        uniqueTargetContainersAndLabels=DeleteDuplicates@Transpose[{
          Lookup[myResolvedOptions, TargetContainerOut],
          targetContainerLabels
        }];

        LabelContainer[
          Label->uniqueTargetContainersAndLabels[[All,2]],
          Container->(If[MatchQ[#, {_Integer, ObjectP[]}], #[[2]], #]&)/@uniqueTargetContainersAndLabels[[All,1]]
        ]
      ],

      (* ImpurityContainerOut Labels. *)
      Module[{uniqueImpurityContainersAndLabels},
        uniqueImpurityContainersAndLabels=DeleteDuplicates@Transpose[{
          Lookup[myResolvedOptions, ImpurityContainerOut],
          impurityContainerLabels
        }];

        LabelContainer[
          Label->uniqueImpurityContainersAndLabels[[All,2]],
          Container->(If[MatchQ[#, {_Integer, ObjectP[]}], #[[2]], #]&)/@uniqueImpurityContainersAndLabels[[All,1]]
        ]
      ]
    };

    (* Aliquots SampleVolume of our samples into ExtractionContainer, if specified. This applies to both the phase *)
    (* separator and pipette extraction types. *)
    aliquotUnitOperations=If[Length[PickList[mySamples, Lookup[myResolvedOptions, SampleVolume], VolumeP|All]]>0,
      {
        Transfer[
          Source -> PickList[mySamples, Lookup[myResolvedOptions, SampleVolume], VolumeP|All],
          Destination -> PickList[Transpose[{Lookup[myResolvedOptions, ExtractionContainerWell], extractionContainerLabels}], Lookup[myResolvedOptions, SampleVolume], VolumeP|All],
          Amount -> Cases[Lookup[myResolvedOptions, SampleVolume], VolumeP|All]
        ]
      },
      {}
    ];

    (* Set any temperatures for any containers. *)
    residualIncubationUnitOperations=Module[{uniqueContainersAndTemperaturesNoAmbient},
      uniqueContainersAndTemperaturesNoAmbient=Cases[
        DeleteDuplicates@Transpose[{workingSampleContainerLabels, Lookup[myResolvedOptions, Temperature]}],
        {_, Except[Ambient|RangeP[24.9 Celsius, 25.1 Celsius]]}
      ];

      If[Length[uniqueContainersAndTemperaturesNoAmbient]>0,
        List@Incubate[
          Sample->uniqueContainersAndTemperaturesNoAmbient[[All,1]],
          Temperature->uniqueContainersAndTemperaturesNoAmbient[[All,2]],
          ResidualIncubation->True
        ],
        {}
      ]
    ];

    (* At a high level, the phase separator unit operations work in the following way: *)
    (* Add solvent / demulsifier to Working Container (the extraction container or input sample's container in the first round, the impurity container in later rounds). *)
    (* Mix *)
    (* Load from Working Container to Phase Separator -- potentially multiple wells -- specify the CollectionContainer and CollectionTime options to Transfer. *)
    (* Collect to Target Phase to Target Container -- potentially multiple wells *)
    (* Collect Impurity Phase to Impurity Container -- potentially multiple wells *)
    (* Repeat for the maximum NumberOfExtractions, only for the samples that have that number of extractions specified. *)
    {phaseSeparatorUnitOperations, allPhaseSeparatorLabels, allCollectionContainerLabels}=If[MemberQ[Lookup[myResolvedOptions, ExtractionTechnique], PhaseSeparator],
      Module[
        {currentPhaseSeparatorLabel, currentCollectionPlateLabel, currentPhaseSeparatorWells, allPhaseSeparatorLabels,
          allCollectionContainerLabels, maxExtractionRound, phaseSeparatorUnitOperations},

        (* We keep incrementing the phase separator plate that we're using when we finish packing the samples into a full *)
        (* plate. *)
        currentPhaseSeparatorLabel=CreateUniqueLabel["phase separator plate"];
        currentCollectionPlateLabel=CreateUniqueLabel["phase separator collection plate "];
        currentPhaseSeparatorWells=Flatten[Transpose[AllWells[]]];

        allPhaseSeparatorLabels={currentPhaseSeparatorLabel};
        allCollectionContainerLabels={currentCollectionPlateLabel};

        (* Get the maximum number of extraction rounds for any sample using a phase separator. *)
        maxExtractionRound = Max[PickList[Lookup[myResolvedOptions, NumberOfExtractions], Lookup[myResolvedOptions, ExtractionTechnique], PhaseSeparator]];

        phaseSeparatorUnitOperations=Map[
          Function[{extractionRound},
            Module[
              {phaseSeparatorWorkingSampleContainerLabels, phaseSeparatorWorkingSampleWells, phaseSeparatorMapThreadFriendlyOptions,
                loadSolventAndDemulsifier, mixing, loadingFromWorkingContainerToPhaseSeparator, settling, collectTargetPhaseToTargetContainer,
                collectImpurityPhaseToImpurityContainer},

              (* Get the working sample containers, working sample wells, and the map thread friendly options that correspond *)
              (* to the samples that we'll be operating on during this extraction round *)
              phaseSeparatorMapThreadFriendlyOptions=PickList[mapThreadFriendlyOptionsWithUpdatedLabels, Transpose[Lookup[myResolvedOptions, {ExtractionTechnique, NumberOfExtractions}]], {PhaseSeparator, GreaterEqualP[extractionRound]}];

              (* During the first round, the working sample is either in the extraction container or the sample in container. *)
              (* After the first round, the sample we want to operate on will be determined by the selection type. *)
              {
                phaseSeparatorWorkingSampleContainerLabels,
                phaseSeparatorWorkingSampleWells
              }=If[MatchQ[extractionRound, 1],
                {
                  PickList[workingSampleContainerLabels, Transpose[Lookup[myResolvedOptions, {ExtractionTechnique, NumberOfExtractions}]], {PhaseSeparator, GreaterEqualP[extractionRound]}],
                  PickList[workingSampleContainerWells, Transpose[Lookup[myResolvedOptions, {ExtractionTechnique, NumberOfExtractions}]], {PhaseSeparator, GreaterEqualP[extractionRound]}]
                },
                {
                  Map[
                    Function[{element},
                      Which[
                        MatchQ[element, {Positive, _, _, PhaseSeparator, GreaterEqualP[extractionRound]}],
                          element[[2]],
                        MatchQ[element, {Negative, _, _, PhaseSeparator, GreaterEqualP[extractionRound]}],
                          element[[3]],
                        True,
                          Nothing
                      ]
                    ],
                    Transpose[Lookup[myResolvedOptions, {SelectionStrategy, ImpurityContainerLabel, TargetContainerLabel, ExtractionTechnique, NumberOfExtractions}]]
                  ],
                  Map[
                    Function[{element},
                      Which[
                        MatchQ[element, {Positive, _, _, PhaseSeparator, GreaterEqualP[extractionRound]}],
                          element[[2]],
                        MatchQ[element, {Negative, _, _, PhaseSeparator, GreaterEqualP[extractionRound]}],
                          element[[3]],
                        True,
                          Nothing
                      ]
                    ],
                    Transpose[Lookup[myResolvedOptions, {SelectionStrategy, ImpurityContainerOutWell, TargetContainerOutWell, ExtractionTechnique, NumberOfExtractions}]]
                  ]
                }
              ];

              (* Load more solvent and demulsifier into the impurity container. *)
              loadSolventAndDemulsifier = Flatten@MapThread[
                Function[{workingSampleContainerLabel, workingSampleContainerWell, options},
                  {
                    If[Or[
                      And[
                        MatchQ[Lookup[options, AddAqueousSolvent], First],
                        MatchQ[extractionRound, 1]
                      ],
                      And[
                        MatchQ[Lookup[options, AddAqueousSolvent], Rest],
                        MatchQ[extractionRound, GreaterP[1]]
                      ],
                      MatchQ[Lookup[options, AddAqueousSolvent], All]
                    ],
                      Transfer[
                        Source->Lookup[options, AqueousSolvent],
                        Destination->{workingSampleContainerWell, workingSampleContainerLabel},
                        Amount->Lookup[options, AqueousSolventVolume]
                      ],
                      Nothing
                    ],
                    If[Or[
                      And[
                        MatchQ[Lookup[options, AddOrganicSolvent], First],
                        MatchQ[extractionRound, 1]
                      ],
                      And[
                        MatchQ[Lookup[options, AddOrganicSolvent], Rest],
                        MatchQ[extractionRound, GreaterP[1]]
                      ],
                      MatchQ[Lookup[options, AddOrganicSolvent], All]
                    ],
                      Transfer[
                        Source->Lookup[options, OrganicSolvent],
                        Destination->{workingSampleContainerWell, workingSampleContainerLabel},
                        Amount->Lookup[options, OrganicSolventVolume]
                      ],
                      Nothing
                    ],
                    If[MatchQ[Length[Lookup[options, demulsifierAdditions]], GreaterEqualP[extractionRound]] && MatchQ[Lookup[options, demulsifierAdditions][[extractionRound]], ObjectP[]],
                      Transfer[
                        Source->Lookup[options, Demulsifier],
                        Destination->{workingSampleContainerWell, workingSampleContainerLabel},
                        Amount->Lookup[options, DemulsifierAmount]
                      ],
                      Nothing
                    ]
                  }
                ],
                {
                  phaseSeparatorWorkingSampleContainerLabels,
                  phaseSeparatorWorkingSampleWells,
                  phaseSeparatorMapThreadFriendlyOptions
                }
              ];

              (* Mix the sample/solvent/demulsifier. *)
              mixing = MapThread[
                Function[{workingSampleContainerLabel, workingSampleContainerWell, options},
                  If[MatchQ[Lookup[options, ExtractionMixType], RoboticMixTypeP],
                    Mix[
                      Sample->{workingSampleContainerWell, workingSampleContainerLabel},
                      MixType->Lookup[options, ExtractionMixType],
                      Time->Lookup[options, ExtractionMixTime],
                      MixRate->Lookup[options, ExtractionMixRate],
                      NumberOfMixes->Lookup[options, NumberOfExtractionMixes],
                      MixVolume->Lookup[options, ExtractionMixVolume]
                    ],
                    Nothing
                  ]
                ],
                {
                  phaseSeparatorWorkingSampleContainerLabels,
                  phaseSeparatorWorkingSampleWells,
                  phaseSeparatorMapThreadFriendlyOptions
                }
              ];

              (* First round transfers from the working container (extraction container or container in) to the phase separator. *)
              (* NOTE: This is in the format {{_Transfer..}..} where each inner group are Transfers from the same working sample *)
              (* if that working sample's volume is over 2mL (the capacity of one of our phase separator wells. *)
              loadingFromWorkingContainerToPhaseSeparator = MapThread[
                Function[{workingSampleContainerLabel, workingSampleContainerWell, options},
                  Module[{workingSampleVolume, splitLoadingVolumes},
                    workingSampleVolume=Plus[
                      Lookup[options, AqueousLayerVolumes][[1]],
                      Lookup[options, OrganicLayerVolumes][[1]]
                    ];

                    (* Our phase separator plates can only hold 2mL. *)
                    splitLoadingVolumes=If[MatchQ[workingSampleVolume, GreaterP[2 Milliliter]],
                      Append[
                        ConstantArray[2 Milliliter, IntegerPart[workingSampleVolume / (2 Milliliter)]],
                        If[MatchQ[Mod[workingSampleVolume, 2 Milliliter], GreaterP[0.1 Microliter]],
                          Mod[workingSampleVolume, 2 Milliliter],
                          Nothing
                        ]
                      ],
                      {workingSampleVolume}
                    ];

                    Map[
                      Function[{loadingVolume},
                        Module[{wellToLoad},
                          (* If we ran out of wells, we need another plate. *)
                          If[Length[currentPhaseSeparatorWells]==0,
                            currentPhaseSeparatorLabel=CreateUniqueLabel["phase separator plate"];
                            currentCollectionPlateLabel=CreateUniqueLabel["phase separator collection plate "];
                            currentPhaseSeparatorWells=Flatten[Transpose[AllWells[]]];

                            allPhaseSeparatorLabels=Append[allPhaseSeparatorLabels, currentPhaseSeparatorLabel];
                            allCollectionContainerLabels=Append[allCollectionContainerLabels, currentCollectionPlateLabel];
                          ];

                          (* Load the first empty well and remove it from the empty well list. *)
                          wellToLoad=First[currentPhaseSeparatorWells];
                          currentPhaseSeparatorWells=Rest[currentPhaseSeparatorWells];

                          Transfer[
                            Source->{workingSampleContainerWell, workingSampleContainerLabel},
                            Destination->{wellToLoad, currentPhaseSeparatorLabel},
                            Amount->loadingVolume,
                            CollectionContainer->currentCollectionPlateLabel,
                            CollectionTime->Lookup[options, SettlingTime]
                          ]
                        ]
                      ],
                      splitLoadingVolumes
                    ]
                  ]
                ],
                {phaseSeparatorWorkingSampleContainerLabels, phaseSeparatorWorkingSampleWells, phaseSeparatorMapThreadFriendlyOptions}
              ];

              (* Wait for the liquid to flow through the phase separator. *)
              settling = Module[{maxSettlingTime},
                maxSettlingTime=Max[Flatten[{0 Second, Cases[Lookup[phaseSeparatorMapThreadFriendlyOptions, SettlingTime], TimeP]}]];

                If[MatchQ[maxSettlingTime, GreaterP[0 Second]],
                  Wait[
                    Duration->maxSettlingTime
                  ],
                  Nothing
                ]
              ];

              (* Transfer from the phase separator / collection plate into the target container. *)
              collectTargetPhaseToTargetContainer = MapThread[
                Function[{phaseSeparatorWellAndContainers, collectionContainers, phaseSeparatorVolumes, options},
                  (* NOTE: We transfer phaseSeparatorVolume here because we're not actually sure how much aqueous/organic phase *)
                  (* flowed through, especially when we're splitting up the sample into multiple wells which might not have *)
                  (* gotten a homogeneous solution. *)
                  (* NOTE: We might have multiple phase separator wells/volumes if our loading volume was over 2mL (the max *)
                  (* volume of the phase separator well). *)
                  MapThread[
                    Function[{phaseSeparatorWellAndContainer, collectionContainer, phaseSeparatorVolume},
                      Transfer[
                        Source->If[MatchQ[Lookup[options, TargetPhase], Aqueous],
                          phaseSeparatorWellAndContainer,
                          {phaseSeparatorWellAndContainer[[1]], collectionContainer}
                        ],
                        Destination->{Lookup[options, TargetContainerOutWell], Lookup[options, TargetContainerLabel]},
                        Amount->phaseSeparatorVolume
                      ]
                    ],
                    {phaseSeparatorWellAndContainers, collectionContainers, phaseSeparatorVolumes}
                  ]
                ],
                {
                  Map[(#[Destination]&), loadingFromWorkingContainerToPhaseSeparator, {2}],
                  Map[(#[CollectionContainer]&), loadingFromWorkingContainerToPhaseSeparator, {2}],
                  Map[(#[Amount]&), loadingFromWorkingContainerToPhaseSeparator, {2}],
                  phaseSeparatorMapThreadFriendlyOptions
                }
              ];

              (* Transfer from the phase separator / collection plate into the impurity container. *)
              collectImpurityPhaseToImpurityContainer = MapThread[
                Function[{phaseSeparatorWellAndContainers, collectionContainers, phaseSeparatorVolumes, options},
                  (* NOTE: We transfer phaseSeparatorVolume here because we're not actually sure how much aqueous/organic phase *)
                  (* flowed through, especially when we're splitting up the sample into multiple wells which might not have *)
                  (* gotten a homogeneous solution. *)
                  (* NOTE: We might have multiple phase separator wells/volumes if our loading volume was over 2mL (the max *)
                  (* volume of the phase separator well). *)
                  MapThread[
                    Function[{phaseSeparatorWellAndContainer, collectionContainer, phaseSeparatorVolume},
                      Transfer[
                        Source->If[MatchQ[Lookup[options, TargetPhase], Organic],
                          phaseSeparatorWellAndContainer,
                          {phaseSeparatorWellAndContainer[[1]], collectionContainer}
                        ],
                        Destination->{Lookup[options, ImpurityContainerOutWell], Lookup[options, ImpurityContainerLabel]},
                        Amount->phaseSeparatorVolume
                      ]
                    ],
                    {phaseSeparatorWellAndContainers, collectionContainers, phaseSeparatorVolumes}
                  ]
                ],
                {
                  Map[(#[Destination]&), loadingFromWorkingContainerToPhaseSeparator, {2}],
                  Map[(#[CollectionContainer]&), loadingFromWorkingContainerToPhaseSeparator, {2}],
                  Map[(#[Amount]&), loadingFromWorkingContainerToPhaseSeparator, {2}],
                  phaseSeparatorMapThreadFriendlyOptions
                }
              ];

              {
                loadSolventAndDemulsifier,
                mixing,
                loadingFromWorkingContainerToPhaseSeparator,
                settling,
                collectTargetPhaseToTargetContainer,
                collectImpurityPhaseToImpurityContainer
              }
            ]
          ],
          Range[maxExtractionRound]
        ];

        {
          Flatten[phaseSeparatorUnitOperations],
          allPhaseSeparatorLabels,
          allCollectionContainerLabels
        }
      ],
      {{}, {}, {}}
    ];

    phaseSeparatorAndCollectionContainerLabelUnitOperations=If[MemberQ[Lookup[myResolvedOptions, ExtractionTechnique], PhaseSeparator],
      {
        LabelContainer[
          Label->allPhaseSeparatorLabels,
          (* Model[Container, Plate, PhaseSeparator, "Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits"] *)
          Container->Model[Container, Plate, PhaseSeparator, "id:jLq9jXqrWW11"]
        ],
        LabelContainer[
          Label->allCollectionContainerLabels,
          Container->Model[Container, Plate, "96-well 2mL Deep Well Plate"] (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
        ]
      },
      {}
    ];

    (* At a high level, the pipette unit operations work in the following way: *)
    (* Add solvent / demulsifier to Working Container (always the extraction container or input sample's container). *)
    (* Mix. *)
    (* Wait for SettlingTime. *)
    (* Centrifuge (optionally). *)
    (* Collect ExtractionTransferLayer either into ImpurityContainerOut or TargetContainerOut (depending on TargetLayer). *)
    (* If ExtractionTransferLayer != TargetLayer, move the rest of the sample in the Working Container into TargetContainerOut. *)
    (* If ExtractionTransferLayer != TargetLayer, move the sample in ImpurityContainerOut back into Working Container. *)
    (* Repeat for the maximum NumberOfExtractions, only for the samples that have that number of extractions specified. *)
    pipetteUnitOperations=If[MemberQ[Lookup[myResolvedOptions, ExtractionTechnique], Pipette],
      Module[
        {maxExtractionRound},

        (* Get the maximum number of extraction rounds for any sample using a pipette. *)
        maxExtractionRound = Max[PickList[Lookup[myResolvedOptions, NumberOfExtractions], Lookup[myResolvedOptions, ExtractionTechnique], Pipette]];

        Map[
          Function[{extractionRound},
            Module[
              {pipetteMapThreadFriendlyOptions, pipetteWorkingSampleContainerLabels, pipetteWorkingSampleWells, loadSolventAndDemulsifier,
                mixing, settling, centrifuge, extractionDestinations, extractedVolumes, remainingExtractionContainerVolumes, extractionTransfer,
                switcherooTransfers},

              (* Get the working sample containers, working sample wells, and the map thread friendly options that correspond *)
              (* to the samples that we'll be operating on during this extraction round *)
              pipetteMapThreadFriendlyOptions=PickList[mapThreadFriendlyOptionsWithUpdatedLabels, Transpose[Lookup[myResolvedOptions, {ExtractionTechnique, NumberOfExtractions}]], {Pipette, GreaterEqualP[extractionRound]}];

              (* During the first round, the working sample is either in the extraction container or the sample in container. *)
              (* After the first round, the sample we want to operate on will be in the impurity container. *)
              {
                pipetteWorkingSampleContainerLabels,
                pipetteWorkingSampleWells
              }= {
                PickList[workingSampleContainerLabels, Transpose[Lookup[myResolvedOptions, {ExtractionTechnique, NumberOfExtractions}]], {Pipette, GreaterEqualP[extractionRound]}],
                PickList[workingSampleContainerWells, Transpose[Lookup[myResolvedOptions, {ExtractionTechnique, NumberOfExtractions}]], {Pipette, GreaterEqualP[extractionRound]}]
              };

              (* Load more solvent and demulsifier into the working container. *)
              loadSolventAndDemulsifier = Flatten@MapThread[
                Function[{workingSampleContainerLabel, workingSampleContainerWell, options},
                  {
                    If[Or[
                      And[
                        MatchQ[Lookup[options, AddAqueousSolvent], First],
                        MatchQ[extractionRound, 1]
                      ],
                      And[
                        MatchQ[Lookup[options, AddAqueousSolvent], Rest],
                        MatchQ[extractionRound, GreaterP[1]]
                      ],
                      MatchQ[Lookup[options, AddAqueousSolvent], All]
                    ],
                      Transfer[
                        Source->Lookup[options, AqueousSolvent],
                        Destination->{workingSampleContainerWell, workingSampleContainerLabel},
                        Amount->Lookup[options, AqueousSolventVolume]
                      ],
                      Nothing
                    ],
                    If[Or[
                      And[
                        MatchQ[Lookup[options, AddOrganicSolvent], First],
                        MatchQ[extractionRound, 1]
                      ],
                      And[
                        MatchQ[Lookup[options, AddOrganicSolvent], Rest],
                        MatchQ[extractionRound, GreaterP[1]]
                      ],
                      MatchQ[Lookup[options, AddOrganicSolvent], All]
                    ],
                      Transfer[
                        Source->Lookup[options, OrganicSolvent],
                        Destination->{workingSampleContainerWell, workingSampleContainerLabel},
                        Amount->Lookup[options, OrganicSolventVolume]
                      ],
                      Nothing
                    ],
                    If[Or[
                      And[
                        MatchQ[Lookup[options, AddDemulsifier], First],
                        MatchQ[extractionRound, 1]
                      ],
                      And[
                        MatchQ[Lookup[options, AddDemulsifier], Rest],
                        MatchQ[extractionRound, GreaterP[1]]
                      ],
                      MatchQ[Lookup[options, AddDemulsifier], All]
                    ],
                      Transfer[
                        Source->Lookup[options, Demulsifier],
                        Destination->{workingSampleContainerWell, workingSampleContainerLabel},
                        Amount->Lookup[options, DemulsifierAmount]
                      ],
                      Nothing
                    ]
                  }
                ],
                {
                  pipetteWorkingSampleContainerLabels,
                  pipetteWorkingSampleWells,
                  pipetteMapThreadFriendlyOptions
                }
              ];

              (* Mix the sample/solvent/demulsifier. *)
              mixing = MapThread[
                Function[{workingSampleContainerLabel, workingSampleContainerWell, options},
                  If[MatchQ[Lookup[options, ExtractionMixType], RoboticMixTypeP],
                    Mix[
                      Sample->{workingSampleContainerWell, workingSampleContainerLabel},
                      MixType->Lookup[options, ExtractionMixType],
                      Time->Lookup[options, ExtractionMixTime],
                      MixRate->Lookup[options, ExtractionMixRate],
                      NumberOfMixes->Lookup[options, NumberOfExtractionMixes],
                      MixVolume->Lookup[options, ExtractionMixVolume]
                    ],
                    Nothing
                  ]
                ],
                {
                  pipetteWorkingSampleContainerLabels,
                  pipetteWorkingSampleWells,
                  pipetteMapThreadFriendlyOptions
                }
              ];

              (* Wait for SettlingTime. *)
              (* Since we're doing each of the rounds in parallel, we wait for the maximum settling time in this round. *)
              settling = Module[{maxSettlingTime},
                maxSettlingTime=Max[Flatten[{0 Second, Cases[Lookup[pipetteMapThreadFriendlyOptions, SettlingTime], TimeP]}]];

                If[MatchQ[maxSettlingTime, GreaterP[0 Second]],
                  Wait[
                    Duration->maxSettlingTime
                  ],
                  Nothing
                ]
              ];

              (* Centrifuge (optionally). *)
              centrifuge = Module[{centrifugeWorkingContainersAndOptions},
                centrifugeWorkingContainersAndOptions=DeleteDuplicates@Cases[
                  Transpose[{pipetteWorkingSampleContainerLabels, pipetteMapThreadFriendlyOptions}],
                  {_, KeyValuePattern[{Centrifuge -> True}]}
                ];

                If[Length[centrifugeWorkingContainersAndOptions]>0,
                  Centrifuge[
                    Sample->centrifugeWorkingContainersAndOptions[[All,1]],
                    Instrument->Lookup[centrifugeWorkingContainersAndOptions[[All,2]], CentrifugeInstrument],
                    Intensity->Lookup[centrifugeWorkingContainersAndOptions[[All,2]], CentrifugeIntensity],
                    Time->Lookup[centrifugeWorkingContainersAndOptions[[All,2]], CentrifugeTime]
                  ],
                  Nothing
                ]
              ];

              (* Collect ExtractionTransferLayer either into ImpurityContainerOut or TargetContainerOut (depending on TargetLayer). *)
              {extractionDestinations, extractedVolumes, remainingExtractionContainerVolumes, extractionTransfer} = Module[{extractionInformation},
                extractionInformation=MapThread[
                  Function[{workingSampleContainerLabel, workingSampleContainerWell, options},
                    Module[{destination, transferPhase, phaseVolume, remainderVolume, includeBoundary, boundaryVolumeDelta},
                      (* What should be the destination container of the extraction? *)
                      (* If ExtractionTransferLayer matches TargetLayer (taking into account that TargetLayer can *)
                      (* be a list if the TargetLayer is different in the first round vs the rest of the rounds), then *)
                      (* we want to go into the target container, otherwise we should go into the impurity container. *)
                      destination = If[MatchQ[Lookup[options, ExtractionTransferLayer][[extractionRound]], Lookup[options, TargetLayer][[extractionRound]]],
                        {Lookup[options, TargetContainerOutWell], Lookup[options, TargetContainerLabel]},
                        {Lookup[options, ImpurityContainerOutWell], Lookup[options, ImpurityContainerLabel]}
                      ];

                      transferPhase=Which[
                        (* If TargetLayer matches ExtractionTransferLayer, then we are transferring the TargetPhase. *)
                        MatchQ[Lookup[options, TargetLayer][[extractionRound]], Lookup[options, ExtractionTransferLayer][[extractionRound]]],
                          Lookup[options, TargetPhase],
                        (* Otherwise, the transfer phase is the opposite of the TargetPhase. *)
                        MatchQ[Lookup[options, TargetPhase], Aqueous],
                          Organic,
                        True,
                          Aqueous
                      ];

                      phaseVolume = If[MatchQ[transferPhase, Aqueous],
                        Lookup[options, AqueousLayerVolumes][[extractionRound]],
                        Lookup[options, OrganicLayerVolumes][[extractionRound]]
                      ];

                      remainderVolume = If[MatchQ[transferPhase, Aqueous],
                        Lookup[options, OrganicLayerVolumes][[extractionRound]],
                        Lookup[options, AqueousLayerVolumes][[extractionRound]]
                      ];

                      includeBoundary = If[MatchQ[Lookup[options, IncludeBoundary], _List],
                        Lookup[options, IncludeBoundary][[extractionRound]],
                        Lookup[options, IncludeBoundary]
                      ];

                      boundaryVolumeDelta = If[MatchQ[includeBoundary, True],
                        Lookup[options, ExtractionBoundaryVolume][[extractionRound]],
                        -1 * Lookup[options, ExtractionBoundaryVolume][[extractionRound]]
                      ];

                      {
                        destination,
                        phaseVolume + boundaryVolumeDelta,
                        remainderVolume - boundaryVolumeDelta,
                        If[MatchQ[Lookup[options, ExtractionTransferLayer][[extractionRound]], Top],
                          (* We're aspirating from the top *)
                          Transfer[
                            Source -> {workingSampleContainerWell, workingSampleContainerLabel},
                            Destination->destination,
                            Amount -> phaseVolume + boundaryVolumeDelta,
                            AspirationPosition -> LiquidLevel
                          ],
                          (* We're aspirating from the bottom *)
                          Transfer[
                            Source -> {workingSampleContainerWell, workingSampleContainerLabel},
                            Destination->destination,
                            Amount -> phaseVolume + boundaryVolumeDelta,
                            AspirationPosition -> TouchOff,
                            AspirationPositionOffset -> 2 Millimeter
                          ]
                        ]
                      }
                    ]
                  ],
                  {pipetteWorkingSampleContainerLabels, pipetteWorkingSampleWells, pipetteMapThreadFriendlyOptions}
                ];

                If[Length[extractionInformation]>0,
                  Transpose[extractionInformation],
                  {{}, {}, {}, {}}
                ]
              ];

              switcherooTransfers = Flatten@MapThread[
                Function[{workingSampleContainerLabel, workingSampleContainerWell, extractedDestination, extractedVolume, remainingExtractionContainerVolume, options},
                  Which[
                    (* When doing SelectionStrategy -> Positive, if ExtractionTransferLayer != TargetLayer, move the rest of *)
                    (* the sample in the Working Container into TargetContainerOut and then move the sample from ImpurityContainerOut *)
                    (* back into WorkingContainer. *)
                    And[
                      MatchQ[Lookup[options, SelectionStrategy], Positive],
                      !MatchQ[Lookup[options, ExtractionTransferLayer][[extractionRound]], Lookup[options, TargetLayer][[extractionRound]]]
                    ],
                      {
                        Transfer[
                          Source->{workingSampleContainerWell, workingSampleContainerLabel},
                          Destination->{Lookup[options, TargetContainerOutWell], Lookup[options, TargetContainerLabel]},
                          Amount->remainingExtractionContainerVolume,
                          AspirationPosition->LiquidLevel
                        ],
                        (* If we're on our last extraction round, DO NOT transfer the next round's layer into the working container *)
                        (* because there is no next round. *)
                        If[MatchQ[extractionRound, maxExtractionRound],
                          Nothing,
                          Transfer[
                            Source->{Lookup[options, ImpurityContainerOutWell], Lookup[options, ImpurityContainerLabel]},
                            Destination->{workingSampleContainerWell, workingSampleContainerLabel},
                            Amount->extractedVolume,
                            AspirationPosition->LiquidLevel
                          ]
                        ]
                      },

                    (* When doing SelectionStrategy -> Negative, if ExtractionTransferLayer == TargetLayer, move the rest of *)
                    (* the sample in the Working Container into ImpurityContainerOut and then move the sample from TargetContainerOut *)
                    (* back into WorkingContainer. *)
                    And[
                      MatchQ[Lookup[options, SelectionStrategy], Negative],
                      MatchQ[Lookup[options, ExtractionTransferLayer][[extractionRound]], Lookup[options, TargetLayer][[extractionRound]]]
                    ],
                      {
                        Transfer[
                          Source->{workingSampleContainerWell, workingSampleContainerLabel},
                          Destination->{Lookup[options, ImpurityContainerOutWell], Lookup[options, ImpurityContainerLabel]},
                          Amount->remainingExtractionContainerVolume,
                          AspirationPosition->LiquidLevel
                        ],
                        (* If we're on our last extraction round, DO NOT transfer the next round's layer into the working container *)
                        (* because there is no next round. *)
                        If[MatchQ[extractionRound, maxExtractionRound],
                          Nothing,
                          Transfer[
                            Source->{Lookup[options, TargetContainerOutWell], Lookup[options, TargetContainerLabel]},
                            Destination->{workingSampleContainerWell, workingSampleContainerLabel},
                            Amount->extractedVolume,
                            AspirationPosition->LiquidLevel
                          ]
                        ]
                      },

                    (* If there is only one round of extraction, SelectionStrategy is automatically set to Null, but if the TargetLayer *)
                    (* is not the same as the TransferLayer, we need to transfer the remaining sample from the extraction container into *)
                    (* the TargetContainerOut. (ImpurityLayer will have already been transferred to Impurity container out with the above unit ops) *)
                    And[
                      MatchQ[Lookup[options, NumberOfExtractions], 1],
                      !MatchQ[Lookup[options, ExtractionTransferLayer][[extractionRound]], Lookup[options, TargetLayer][[extractionRound]]]
                    ],
                      {
                        Transfer[
                          Source->{workingSampleContainerWell, workingSampleContainerLabel},
                          Destination->{Lookup[options, TargetContainerOutWell], Lookup[options, TargetContainerLabel]},
                          Amount->remainingExtractionContainerVolume,
                          AspirationPosition->LiquidLevel
                        ]
                      },

                    (* If there is only one round of extraction, SelectionStrategy is automatically set to Null, but if the TargetLayer *)
                    (* is the same as the TransferLayer, we need to transfer the remaining sample from the extraction container into *)
                    (* the ImpurityContainerOut. (TargetLayer will have already been transferred to Target container out with the above unit ops) *)
                    And[
                      MatchQ[Lookup[options, NumberOfExtractions], 1],
                      MatchQ[Lookup[options, ExtractionTransferLayer][[extractionRound]], Lookup[options, TargetLayer][[extractionRound]]]
                    ],
                      {
                        Transfer[
                          Source->{workingSampleContainerWell, workingSampleContainerLabel},
                          Destination->{Lookup[options, ImpurityContainerOutWell], Lookup[options, ImpurityContainerLabel]},
                          Amount->remainingExtractionContainerVolume,
                          AspirationPosition->LiquidLevel
                        ]
                      },

                    True,
                      Nothing
                  ]
                ],
                {pipetteWorkingSampleContainerLabels, pipetteWorkingSampleWells, extractionDestinations, extractedVolumes, remainingExtractionContainerVolumes, pipetteMapThreadFriendlyOptions}
              ];

              {
                loadSolventAndDemulsifier,
                mixing,
                settling,
                centrifuge,
                extractionTransfer,
                switcherooTransfers
              }
            ]
          ],
          Range[maxExtractionRound]
        ]
      ],
      {}
    ];

    (* Label our Targets, Impurities, Samples, and their storage conditions. *)
    labelSampleUnitOperation={
      LabelSample[
        Label->Join[
          Lookup[myResolvedOptions, SampleLabel]/.{Null->CreateUniqueLabel["liquid liquid extraction sample"]},
          Lookup[myResolvedOptions, TargetLabel]/.{Null->CreateUniqueLabel["liquid liquid extraction target sample"]},
          Lookup[myResolvedOptions, ImpurityLabel]/.{Null->CreateUniqueLabel["liquid liquid extraction impurity sample"]}
        ],
        Sample->Join[
          mySamples,
          Transpose@Lookup[myResolvedOptions, {TargetContainerOutWell, TargetContainerLabel}],
          Transpose@Lookup[myResolvedOptions, {ImpurityContainerOutWell, ImpurityContainerLabel}]
        ],
        StorageCondition->Flatten@Lookup[myResolvedOptions, {SamplesInStorageCondition, TargetStorageCondition, ImpurityStorageCondition}]
      ]
    };

    (* Combine to together *)
    primitives=Flatten[{
      labelSampleAndContainerUnitOperations,
      phaseSeparatorAndCollectionContainerLabelUnitOperations,
      aliquotUnitOperations,
      residualIncubationUnitOperations,
      phaseSeparatorUnitOperations,
      pipetteUnitOperations,
      labelSampleUnitOperation
    }];

    (* Set this internal variable to unit test the unit operations that are created by this function. *)
    $LLEUnitOperations=primitives;

    (* mapping between workcell name and experiment function *)
    experimentFunction = Lookup[$WorkCellToExperimentFunction, Lookup[myResolvedOptions, WorkCell], ExperimentRoboticSamplePreparation];

    (* Get our robotic unit operation packets. *)
    {{roboticUnitOperationPackets,roboticRunTime}, roboticSimulation}=Quiet[
      experimentFunction[
        primitives,
        UnitOperationPackets -> True,
        Output->{Result, Simulation},
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
      (* NOTE: We quiet this because when transferring from the phase separator, we're actually not sure how much volume *)
      (* will be in the top/bottom so we just go with the max volume to make sure that we get both of the phases. *)
      {Warning::OveraspiratedTransfer}
    ];

    (* Create our own output unit operation packet, linking up the "sub" robotic unit operation objects. *)
    outputUnitOperationPacket=UploadUnitOperation[
      Module[{nonHiddenOptions},
        (* Only include non-hidden options from LiquidLiquidExtraction. *)
        nonHiddenOptions=allowedKeysForUnitOperationType[Object[UnitOperation, LiquidLiquidExtraction]];

        (* Override any options with resource. *)
        LiquidLiquidExtraction@Join[
          Cases[Normal[myResolvedOptions], Verbatim[Rule][Alternatives@@nonHiddenOptions, _]],
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

    (* Return back our packets and simulation. *)
    {
      Null,
      Flatten[{outputUnitOperationPacket, roboticUnitOperationPackets}],
      roboticSimulation,
      (roboticRunTime+10Minute)
    }
  ];

  (* make list of all the resources we need to check in FRQ *)
  allResourceBlobs=If[MatchQ[resolvedPreparation, Manual],
    DeleteDuplicates[Cases[Flatten[Values[protocolPacket]],_Resource,Infinity]],
    {}
  ];

  (* Verify we can satisfy all our resources *)
  {resourcesOk,resourceTests}=Which[
    (* NOTE: If we're robotic, the framework will call FRQ for us. *)
    MatchQ[$ECLApplication,Engine] || MatchQ[resolvedPreparation, Robotic],
    {True,{}},
    gatherTests,
    Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache,Simulation->currentSimulation],
    True,
    {Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache,Simulation->currentSimulation],Null}
  ];

  (* --- Output --- *)
  (* Generate the Preview output rule *)
  previewRule=Preview->Null;

  (* Generate the options output rule *)
  optionsRule=Options->If[MemberQ[output,Options],
    resolvedOptionsNoHidden,
    Null
  ];

  (* Generate the tests rule *)
  testsRule=Tests->If[gatherTests,
    resourceTests,
    {}
  ];

  (* generate the Result output rule *)
  (* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
  resultRule=Result->If[MemberQ[output,Result]&&TrueQ[resourcesOk],
    {Flatten[{protocolPacket, allUnitOperationPackets}], currentSimulation, runTime},
    $Failed
  ];

  (* Return the output as we desire it *)
  outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];
