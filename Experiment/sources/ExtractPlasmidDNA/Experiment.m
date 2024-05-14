(* ::Package:: *)

(* ::Text:: *)
(* \[Copyright] 2011-2023 Emerald Cloud Lab, Inc. *)

(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(*ExperimentExtractPlasmidDNA Options*)


DefineOptions[ExperimentExtractPlasmidDNA,
  Options :> {
    IndexMatching[
      IndexMatchingInput -> "experiment samples",

      (*---General Lysis & Extraction Shared Options---*)

      ModifyOptions[CellExtractionSharedOptions,
        Method
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
        OptionName -> ExtractedPlasmidDNALabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Description -> "A user defined word or phrase used to identify the sample that contains the extracted plasmid DNA sample, for use in downstream unit operations.",
        ResolutionDescription -> "Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"extracted plasmid DNA sample #\".",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> ExtractedPlasmidDNAContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Description -> "A user defined word or phrase used to identify the container that contains the extracted plasmid DNA sample, for use in downstream unit operations.",
        ResolutionDescription -> "Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"extracted plasmid DNA sample container #\".",
        Category -> "General",
        UnitOperation -> True
      },


      (*---Lysis---*)

      {
        OptionName -> Lyse,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        Description -> "Indicates if the input sample is lysed, breaking the cells' plasma membranes chemically and releasing the cell components into the chosen solution, creating a lysate to extract the plasmid DNA from. An input of live cells must be lysed before neutralization and purification. An input of lysate will not be lysed again before neutralization and purification.",
        ResolutionDescription -> "Automatically set to the Lyse value specified by the selected Method. If Method is set to Custom, then Lyse will be automatically set to True if the input for this experiment is a cell sample or if any lysing options are set, . Otherwise, Lyse will be automatically be set to False.",
        Category -> "Lysis"
      },

      Sequence@@ModifyOptions[CellLysisOptions,
        ToExpression[Keys[
          KeyDrop[Options[CellLysisOptions], {Key["TargetCellularComponent"]}]
        ]]
      ],


      (*---Neutralization---*)

      {
        OptionName -> Neutralize,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        Description -> "Indicates if the cell lysate, a solution containing all of the extracted cell components, will be neutralized, altering the pH of the lysate to bring it closer to neutral (pH 7) in order to renature the plasmid DNA. This keeps the plasmid DNA soluble while other components are rendered (or remain) insoluble. Then the plasmid-rich supernatant is isolated by pelleting and aspiration for further purification.",
        ResolutionDescription -> "Automatically set to the Neutralize value specified by the selected Method. If Method is set to Custom, then Neutralize will be automatically set to True if the input for this experiment is a cell sample or lysate, or if any neutralization options are set. Otherwise, Neutralize will be automatically be set to False.",
        Category -> "Neutralization"
      },
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationSeparationTechnique,
        {
          OptionName -> NeutralizationSeparationTechnique,
          Default -> Automatic,
          AllowNull -> True,
          ResolutionDescription -> "Automatically set to the NeutralizationSeparationTechnique specified by the selected Method. If Method is set to Custom, then NeutralizationSeparationTechnique is set to Pellet.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationReagent,
        {
          OptionName -> NeutralizationReagent,
          Default -> Automatic,
          AllowNull -> True,
          Widget -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
            OpenPaths -> {
              {
                Object[Catalog, "Root"],
                "Materials",
                "Cell Culture",
                "Neutralization Buffers"
              },
              {
                Object[Catalog, "Root"],
                "Materials",
                "Reagents",
                "Buffers"}
            }
          ],
          Description -> "A reagent which, when added to the lysate, will alter the pH of the lysate to bring it closer to neutral (pH 7) in order to renature the plasmid DNA. This keeps the plasmid DNA soluble while other components are rendered (or remain) insoluble.",
          ResolutionDescription -> "Automatically set to the NeutralizationReagent specified by the selected Method. If Method is set to Custom, NeutralizationReagent is automatically set to Model[Sample, StockSolution, \"3M Sodium Acetate\"].",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationReagentVolume,
        {
          OptionName -> NeutralizationReagentVolume,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The volume of the NeutralizationReagent that will be added to the lysate to encourage the renaturing of plasmid DNA and the precipitation of other cellular components for removal.",
          ResolutionDescription -> "Automatically set to the NeutralizationReagentVolume specified by the selected Method. If Method is set to Custom, then NeutralizationReagentVolume is automatically set to the lesser of 50% of the lysate volume or the maximum volume of the container minus the volume of the lysate in order to not overflow the container.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationReagentTemperature,
        {
          OptionName -> NeutralizationReagentTemperature,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The temperature that the NeutralizationReagent will be incubated at for the NeutralizationReagentEquilibrationTime before being added to the lysate, which will help form the precipitate and encourage it to crash out of solution once it has been added to the sample.",
          ResolutionDescription -> "Automatically set to the NeutralizationReagentTemperature specified by the selected Method. If Method is set to Custom, NeutralizationReagentTemperature is automatically set to Ambient.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationReagentEquilibrationTime,
        {
          OptionName -> NeutralizationReagentEquilibrationTime,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The minimum duration during which the NeutralizationReagent will be kept at NeutralizationReagentTemperature before being added to the sample, which will help form the precipitate and encourage it to crash out of solution once it has been added to the sample.",
          ResolutionDescription -> "Automatically set to the NeutralizationReagentEquilibrationTime specified by the selected Method. If Method is set to Custom, NeutralizationReagentEquilibrationTime is automatically set to 5 Minute.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationMixType,
        {
          OptionName -> NeutralizationMixType,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The manner in which the sample is agitated following the addition of the NeutralizationReagent to the sample, in order to prepare a uniform mixture prior to incubation. Shake indicates that the sample will be placed on a shaker at the NeutralizationMixRate for NeutralizationMixTime, while Pipetting indicates that NeutralizationMixVolume of the sample will be pipetted up and down for the number of times specified by NumberOfNeutralizationMixes. None indicates that no mixing occurs before incubation.",
          ResolutionDescription -> "Automatically set to the NeutralizationMixType specified by the selected Method. If Method is set to Custom, NeutralizationMixType is automatically set to Shake if any corresponding Shaking options are set (NeutralizationMixRate, NeutralizationMixTime), or set to Pipetting if any corresponding Pipetting mixing options are set (NeutralizationMixVolume, NeutralizationNumberOfMixes). Otherwise, NeutralizationMixType is automatically set to None.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationMixTemperature,
        {
          OptionName -> NeutralizationMixTemperature,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The temperature at which the mixing device's heating/cooling block is maintained in order to prepare a uniform mixture prior to incubation.",
          ResolutionDescription -> "Automatically set to the NeutralizationMixTemperature specified by the selected Method. If Method is set to Custom, NeutralizationMixTemperature is set to Ambient.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationMixInstrument,
        {
          OptionName -> NeutralizationMixInstrument,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The instrument used agitate the sample following the addition of NeutralizationReagent, in order to prepare a uniform mixture prior to incubation.",
          ResolutionDescription -> "Automatically set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"] if PrecipitationMixType is set to Shake.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationMixRate,
        {
          OptionName -> NeutralizationMixRate,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The number of rotations per minute that the lysate and NeutralizationReagent will be shaken at in order to prepare a uniform mixture prior to the incubation time.",
          ResolutionDescription -> "Automatically set to the NeutralizationMixRate specified by the selected Method. If Method is set to Custom, NeutralizationMixRate is automatically set to 300 RPM if NeutralizationMixType is set to Shake.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationMixTime,
        {
          OptionName -> NeutralizationMixTime,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The duration of time that the lysate and NeutralizationReagent will be shaken for, at at the specified NeutralizationMixRate, to prepare a uniform mixture prior to the incubation time.",
          ResolutionDescription -> "Automatically set to the NeutralizationMixTime specified by the selected Method. If Method is set to Custom, NeutralizationMixTime is automatically set to 15 Minute if NeutralizationMixType is set to Shake.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        NumberOfPrecipitationMixes,
        {
          OptionName -> NumberOfNeutralizationMixes,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The number of times the lysate and NeutralizationReagent are mixed by pipetting up and down in order to prepare a uniform mixture prior to the incubation time.",
          ResolutionDescription -> "Automatically set to the NumberOfNeutralizationMixes specified by the selected Method. If Method is set to Custom, NumberOfNeutralizationMixes is automatically set to 10 if NeutralizationMixType is set to Pipette.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationMixVolume,
        {
          OptionName -> NeutralizationMixVolume,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The volume of the combined lysate and NeutralizationReagent displaced during each up and down pipetting cycle in order to prepare a uniform mixture prior to incubation.",
          ResolutionDescription -> "Automatically set to the lesser of 50% of the lysate volume plus NeutralizationReagentVolume or the maximum pipetting volume if NeutralizationMixType is set to Pipette.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationTime,
        {
          OptionName -> NeutralizationSettlingTime,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The duration for which the combined lysate and NeutralizationReagent are left to settle, at the specified NeutralizationSettlingTemperature, in order to encourage crashing of precipitant following any mixing.",
          ResolutionDescription -> "Automatically set to the NeutralizationSettlingTime specified by the selected Method. If Method is set to Custom, NeutralizationSettlingTime is automatically set to 15 Minute.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationInstrument,
        {
          OptionName -> NeutralizationSettlingInstrument,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The instrument used maintain the sample temperature at NeutralizationSettlingTemperature while the sample and NeutralizationReagent are left to settle, in order to encourage crashing of precipitant following any mixing.",
          ResolutionDescription -> "Automatically set to Model[Instrument, HeatBlock, \"Hamilton Heater Cooler\"] if NeutralizationSettlingTime is greater than 0 Minute.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationTemperature,
        {
          OptionName -> NeutralizationSettlingTemperature,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The temperature at which the incubation device's heating/cooling block is maintained during NeutralizationSettlingTime in order to encourage crashing of precipitant.",
          ResolutionDescription -> "Automatically set to the NeutralizationSettlingTemperature specified by the selected Method. If Method is set to Custom, NeutralizationSettlingTemperature is automatically set to Ambient if NeutralizationSettlingTime is greater than 0 Minute.",
          Category -> "Neutralization"
        }
      ],


      (*---Neutralization Filtration---*)

      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationFiltrationTechnique,
        {
          OptionName -> NeutralizationFiltrationTechnique,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The type of dead-end filtration used to apply force to the sample in order to facilitate its passage through the filter. This will be done by either applying centrifugal force to the filter in a centrifuge, or by applying increased air pressure using a pressure manifold.",
          ResolutionDescription -> "Automatically set to the NeutralizationFiltrationTechnique specified by the selected Method. If Method is set to Custom, NeutralizationFiltrationTechnique is automatically set to AirPressure if NeutralizationSeparationTechnique is set to Filter.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationFiltrationInstrument,
        {
          OptionName -> NeutralizationFiltrationInstrument,
          Default -> Automatic,
          AllowNull -> True,
          ResolutionDescription -> "Automatically set to Model[Instrument, Centrifuge, \"HiG4\"] if NeutralizationFiltrationTechnique is set to Centrifuge. Otherwise, NeutralizationFiltrationInstrument is set to Model[Instrument, PressureManifold, \"MPE2 Sterile\"].",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationFilter,
        {
          OptionName -> NeutralizationFilter,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The consumable container with an embedded filter which is used to separate the solid and liquid phases of the sample after adding incubation with the NeutralizationReagent.",
          ResolutionDescription -> "Automatically set to the NeutralizationFilter specified by the selected Method. If Method is set to Custom, NeutralizationFilter is automatically set to a filter that fits on the filtration instrument, either the centrifuge or pressure manifold, and matches MembraneMaterial and PoreSize if they are set if NeutralizationSeparationTechnique is set to Filter. If the lysate is already in a filter, then NeutralizationFilter is automatically set to that filter and lysate will not be transferred to a new filter unless this option is changed.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationPoreSize,
        {
          OptionName -> NeutralizationPoreSize,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The pore size of the filter which is designed such that molecules larger than the specified pore size should not pass through this filter.",
          ResolutionDescription -> "Automatically set to the NeutralizationPoreSize specified by the selected Method. If Method is set to Custom, then NeutralizationPoreSize is automatically set to PoreSize of NeutralizationFilter if it is specified. Otherwise, NeutralizationPoreSize is set to 0.22 Micron if NeutralizationSeparationTechnique is set to Filter.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationMembraneMaterial,
        {
          OptionName -> NeutralizationMembraneMaterial,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The material from which the filtration membrane is composed. Solvents used should be carefully selected to be compatible with membrane material",
          ResolutionDescription -> "Automatically set to the NeutralizationMembraneMaterial specified by the selected Method. If Method is set to Custom, then NeutralizationMembraneMaterial is automatically set to the MembraneMaterial of the NeutralizationFilter, if it is specified. Otherwise, NeutralizationMembraneMaterial is automatically set to the membrane material of the resolved filter.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationFilterPosition,
        {
          OptionName -> NeutralizationFilterPosition,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The desired position in the Filter in which the samples are placed for the filtering.",
          ResolutionDescription -> "If the input sample is already in a filter, and NeutralizationSeparationTechnique is set to Filter, then NeutralizationFilterPosition is automatically set to the current position.  Otherwise, NeutralizationFilterPosition is set to the first empty position in the filter based on the search order of A1, A2, A3 ... H10, H11, H12.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationFilterCentrifugeIntensity,
        {
          OptionName -> NeutralizationFilterCentrifugeIntensity,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The rotational speed or force that will be applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the NeutralizationPoreSize of NeutralizationFilter.",
          ResolutionDescription -> "Automatically set to the NeutralizationFiltrationCentrifugeIntensity specified by the selected Method. If Method is set to Custom, NeutralizationFiltrationCentrifugeIntensity is automatically set to 3600 g if NeutralizationFiltrationTechnique is set to Centrifuge.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationFiltrationPressure,
        {
          OptionName -> NeutralizationFiltrationPressure,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The pressure applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the NeutralizationPoreSize of NeutralizationFilter.",
          ResolutionDescription -> "Automatically set to the NeutralizationFiltrationPressure specified by the selected Method. If Method is set to Custom, then NeutralizationFiltrationPressure is automatically set to 40 PSI if NeutralizationFiltrationTechnique is set to AirPressure.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationFiltrationTime,
        {
          OptionName -> NeutralizationFiltrationTime,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The duration for which the samples will be exposed to either NeutralizationFiltrationPressure or NeutralizationFiltrationCentrifugeIntensity in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the NeutralizationPoreSize of NeutralizationFilter.",
          ResolutionDescription -> "Automatically set to the NeutralizationFiltrationTime specified by the selected Method. If Method is set to Custom, NeutralizationFiltrationTime is automatically set to 10 Minute if NeutralizationSeparationTechnique is set to Filter.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationFilterStorageCondition,
        {
          OptionName -> NeutralizationFilterStorageCondition,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The conditions under which NeutralizationFilter will be stored after the protocol is completed.",
          ResolutionDescription -> "Automatically set to Disposal if NeutralizationSeparationTechnique is set to Filter.",
          Category -> "Neutralization"
        }
      ],


      (*---Neutralization Pelleting---*)

      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationPelletVolume,
        {
          OptionName -> NeutralizationPelletVolume,
          AllowNull -> True,
          Description -> "The expected volume of the pellet after pelleting by centrifugation. This value is used to calculate the distance from the bottom of the container that the pipette tip will be held during aspiration of the supernatant. This calculated distance is such that the pipette tip should be held 2mm above the top of the pellet in order to prevent aspiration of the pellet. Overestimation of NeutralizationPelletVolume will result in less buffer being aspirated while underestimation of NeutralizationPelletVolume will risk aspiration of the pellet.",
          ResolutionDescription -> "Automatically set to 1 Microliter if NeutralizationSeparationTechnique is set to Pellet.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationPelletCentrifuge,
        {
          OptionName -> NeutralizationPelletInstrument,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The centrifuge that will be used to apply centrifugal force to the samples at NeutralizationPelletCentrifugeIntensity for NeutralizationPelletCentrifugeTime in order to facilitate separation by Pellet of insoluble molecules from the liquid phase into a solid phase at the bottom of the container.",
          ResolutionDescription -> "Automatically set to Centrifuge Model[Instrument, Centrifuge, \"HiG4\"] if NeutralizationSeparationTechnique is set to Pellet.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationPelletCentrifugeIntensity,
        {
          OptionName -> NeutralizationPelletCentrifugeIntensity,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The rotational speed or the force that will be applied to the neutralized lysate to facilitate precipitation of insoluble cellular components out of solution.",
          ResolutionDescription -> "Automatically set to the NeutralizationPelletCentrifugeIntensity specified by the selected Method. If Method is set to Custom, NeutralizationPelletCentrifugeIntensity is automatically set to 3600 g.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationPelletCentrifugeTime,
        {
          OptionName -> NeutralizationPelletCentrifugeTime,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The duration for which the neutralized lysate will be centrifuged to facilitate precipitation of insoluble cellular components out of solution.",
          ResolutionDescription -> "Automatically set to the NeutralizationPelletCentrifugeTime specified by the selected Method. If Method is set to Custom, NeutralizationPelletCentrifugeTime is automatically set to 10 Minute.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitationSupernatantVolume,
        {
          OptionName -> NeutralizedSupernatantTransferVolume,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The volume of the supernatant that will be transferred to a new container after the insoluble molecules have been pelleted at the bottom of the starting container.",
          ResolutionDescription -> "Automatically set to 90% of the NeutralizationReagentVolume plus the sample volume.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitatedSampleStorageCondition,
        {
          OptionName -> NeutralizedPelletStorageCondition,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "The set of parameters that define the temperature, safety, and other environmental conditions under which the pellet of cell material will be stored at the completion of this protocol.",
          ResolutionDescription -> "Automatically set to Disposal if NeutralizationSeparationTechnique is set to Pellet.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitatedSampleLabel,
        {
          OptionName -> NeutralizedPelletLabel,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "A user defined word or phrase used to identify the solid pellet isolated after after the supernatant formed during neutralization is removed. This label is for use in downstream unit operations.",
          ResolutionDescription -> "Automatically set to \"neutralized pellet #\" if NeutralizedPelletStorageCondition is not set to Disposal.",
          Category -> "Neutralization"
        }
      ],
      ModifyOptions[ExtractionPrecipitationSharedOptions,
        PrecipitatedSampleContainerLabel,
        {
          OptionName -> NeutralizedPelletContainerLabel,
          Default -> Automatic,
          AllowNull -> True,
          Description -> "A user defined word or phrase used to identify the container that will contain the solid isolated after the supernatant formed during neutralization is removed. This label is for use in downstream unit operations.",
          ResolutionDescription -> "Automatically set to \"neutralized pellet container #\" if NeutralizedPelletStorageCondition is not set to Disposal.",
          Category -> "Neutralization"
        }
      ],


      (*---Purification---*)

      Sequence@@ModifyOptions[PurificationStepsSharedOptions,
        ToExpression[Keys[
          KeyDrop[
            Options[PurificationStepsSharedOptions],
            {Key["SolidPhaseExtractionCartridge"], Key["SolidPhaseExtractionWashSolution"], Key["SecondarySolidPhaseExtractionWashSolution"], Key["TertiarySolidPhaseExtractionWashSolution"], Key["SolidPhaseExtractionElutionSolution"], Key["MagneticBeads"], Key["MagneticBeadSeparationWashSolution"], Key["MagneticBeadSeparationSecondaryWashSolution"], Key["MagneticBeadSeparationTertiaryWashSolution"], Key["MagneticBeadSeparationQuaternaryWashSolution"], Key["MagneticBeadSeparationQuinaryWashSolution"], Key["MagneticBeadSeparationSenaryWashSolution"], Key["MagneticBeadSeparationSeptenaryWashSolution"], Key["MagneticBeadSeparationElutionSolution"]}]
        ]]
      ],

      (*--Customized SPE Options--*)

      ModifyOptions[ExtractionSolidPhaseSharedOptions,
        SolidPhaseExtractionCartridge,
        {
          ResolutionDescription -> "Automatically set to the SolidPhaseExtractionCartridge specified by the selected Method. If Method is set to Custom, then SolidPhaseExtractionCartridge is automatically set to Model[Container, Plate, Filter, \"NucleoSpin Plasmid Binding Plate\"]."
        }
      ],
      ModifyOptions[ExtractionSolidPhaseSharedOptions,
        SolidPhaseExtractionWashSolution,
        {
          ResolutionDescription -> "Automatically set to the wash solution specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionWashSolution is automatically set to Model[Sample, \"Macherey-Nagel Wash Buffer A4\"] if SolidPhaseExtractionSelectionStrategy is set to Positive."
        }
      ],
      ModifyOptions[ExtractionSolidPhaseSharedOptions,
        SecondarySolidPhaseExtractionWashSolution,
        {
          ResolutionDescription -> "Automatically set to the wash solution specified by the selected Method. If Method is set to Custom, SecondarySolidPhaseExtractionWashSolution is automatically set to Model[Sample, \"Macherey-Nagel Wash Buffer A4\"] if SolidPhaseExtractionSelectionStrategy is set to Positive."
        }
      ],
      ModifyOptions[ExtractionSolidPhaseSharedOptions,
        TertiarySolidPhaseExtractionWashSolution,
        {
          ResolutionDescription -> "Automatically set to the wash solution specified by the selected Method. If Method is set to Custom, TertiarySolidPhaseExtractionWashSolution is automatically set to Model[Sample, \"Macherey-Nagel Wash Buffer A4\"] if SolidPhaseExtractionSelectionStrategy is set to Positive."
        }
      ],
      ModifyOptions[ExtractionSolidPhaseSharedOptions,
        SolidPhaseExtractionElutionSolution,
        {
          ResolutionDescription -> "Automatically set to the wash solution specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionElutionSolution is automatically set to Model[Sample, \"Macherey-Nagel Elution Buffer AE\"] if SolidPhaseExtractionSelectionStrategy is set to Positive."
        }
      ],

      (*--Customized MBS Options--*)

      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeads,
        {
          ResolutionDescription->"Automatically set to the MagneticBeads specified by the selected Method. If Method is set to Custom, MagneticBeads is automatically set to Model[Sample, \"MagBinding Beads\"] if MagneticBeadSeparationMode is set to NormalPhase. If MagneticBeadSeparationMode is Affinity, MagneticBeads is automatically set to the first found magnetic beads model with the affinity label of MagneticBeadAffinityLabel. Otherwise, MagneticBeads is automatically set to Model[Sample, \"Mag-Bind Particles CNR (Mag-Bind Viral DNA/RNA Kit)\"]"
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationWashSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationWashSolution is automatically set to Model[Sample,\"Zyppy Wash Buffer\"] if MagneticBeadSeparationWash is set to True."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationSecondaryWashSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationSecondaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSecondaryWashSolution is automatically set to Model[Sample,\"Zyppy Wash Buffer\"] if MagneticBeadSeparationSecondaryWash is set to True."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationTertiaryWashSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationTertiaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationTertiaryWashSolution is automatically set to Model[Sample,\"Zyppy Wash Buffer\"] if MagneticBeadSeparationTertiaryWash is set to True."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationQuaternaryWashSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuaternaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationQuaternaryWashSolution is automatically set to Model[Sample,\"Zyppy Wash Buffer\"] if MagneticBeadSeparationQuaternaryWash is set to True."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationQuinaryWashSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuinaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationQuinaryWashSolution is automatically set to Model[Sample,\"Zyppy Wash Buffer\"] if MagneticBeadSeparationQuinaryWash is set to True."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationSenaryWashSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationSenaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSenaryWashSolution is automatically set to Model[Sample,\"Zyppy Wash Buffer\"] if MagneticBeadSeparationSenaryWash is set to True."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationSeptenaryWashSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationSeptenaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSeptenaryWashSolution is automatically set to Model[Sample,\"Zyppy Wash Buffer\"] if MagneticBeadSeparationSeptenaryWash is set to True."
        }
      ],
      ModifyOptions[ExtractionMagneticBeadSharedOptions,
        MagneticBeadSeparationElutionSolution,
        {
          ResolutionDescription->"Automatically set to the MagneticBeadSeparationElutionSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationElutionSolution is automatically set to Model[Sample, \"Zyppy Elution Buffer\"] if MagneticBeadSeparationElution is set to True."
        }
      ]

    ],

    (*---Other Shared Options---*)
    NonIndexMatchedExtractionMagneticBeadSharedOptions,
    ModifyOptions[
      RoboticInstrumentOption,
      {
        ResolutionDescription -> "Automatically set to the robotic liquid handler compatible with the cells or solutions having their plasmid DNA extracted. If all cell types are microbial (Bacterial, Yeast, or Fungal) cell types, then set to the microbioSTAR. Otherwise, set to the bioSTAR."
      }
    ],
    RoboticPreparationOption,
    ProtocolOptions,
    SimulationOption,
    PostProcessingOptions,
    SubprotocolDescriptionOption,
    SamplesInStorageOptions,
    SamplesOutStorageOptions,
    ModifyOptions[
      WorkCellOption,
      {
        Widget -> Widget[Type -> Enumeration, Pattern :> bioSTAR | microbioSTAR],
        ResolutionDescription -> "Automatically set to the primitive compatible with the cells or solutions having their plasmid DNA extracted. If all cell types are microbial (Bacterial, Yeast, or Fungal) cell types, then set to the microbioSTAR. Otherwise, set to the bioSTAR."
      }
    ]

  }
];


(* ::Subsection::Closed:: *)
(*ExperimentExtractPlasmidDNA Messages*)

Error::NeutralizeOptionMismatch = "The sample(s), `1`, at indices, `4`, have neutralization options set even though Neutralize is set to False. Since Neutralization is set to False for these samples, `2`, the following options, `3`, should not be specified (set to Null) or Neutralize should be set to True to submit a valid experiment.";
Error::NoPlasmidDNAExtractionStepsSet = "The sample(s), `1`, at indices, `2`, do not have any extraction steps set (Lysis, Neutralization, nor Purification) to extract plasmid DNA from the samples. Please set one or more extraction steps to submit a valid experiment.";


(* ::Subsection::Closed:: *)
(*$PlasmidDNAMethodFields*)

$PlasmidDNAMethodFields =
    {
      Lyse, CellType, NumberOfLysisSteps, PreLysisPellet, PreLysisPelletingIntensity, PreLysisPelletingTime, LysisSolution, LysisMixType, LysisMixRate, LysisMixTime, NumberOfLysisMixes, LysisMixTemperature, LysisTime, LysisTemperature, SecondaryLysisSolution, SecondaryLysisMixType, SecondaryLysisMixRate, SecondaryLysisMixTime, SecondaryNumberOfLysisMixes, SecondaryLysisMixTemperature, SecondaryLysisTime, SecondaryLysisTemperature, TertiaryLysisSolution, TertiaryLysisMixType, TertiaryLysisMixRate, TertiaryLysisMixTime, TertiaryNumberOfLysisMixes, TertiaryLysisMixTemperature, TertiaryLysisTime, TertiaryLysisTemperature, ClarifyLysate, ClarifyLysateIntensity, ClarifyLysateTime, Neutralize, NeutralizationSeparationTechnique, NeutralizationReagent, NeutralizationReagentTemperature, NeutralizationReagentEquilibrationTime, NeutralizationMixType, NeutralizationMixTemperature, NeutralizationMixRate, NeutralizationMixTime, NumberOfNeutralizationMixes, NeutralizationSettlingTime, NeutralizationSettlingTemperature, NeutralizationFiltrationTechnique, NeutralizationFilter, NeutralizationPoreSize, NeutralizationMembraneMaterial, NeutralizationFilterCentrifugeIntensity, NeutralizationFiltrationPressure, NeutralizationFiltrationTime, NeutralizationPelletCentrifugeIntensity, NeutralizationPelletCentrifugeTime, Purification, LiquidLiquidExtractionTechnique, LiquidLiquidExtractionDevice, LiquidLiquidExtractionSelectionStrategy, LiquidLiquidExtractionTargetPhase, LiquidLiquidExtractionTargetLayer, AqueousSolvent, AqueousSolventRatio, OrganicSolvent, OrganicSolventRatio, LiquidLiquidExtractionSolventAdditions, Demulsifier, DemulsifierAdditions, LiquidLiquidExtractionTemperature, NumberOfLiquidLiquidExtractions, LiquidLiquidExtractionMixType, LiquidLiquidExtractionMixTime, LiquidLiquidExtractionMixRate, NumberOfLiquidLiquidExtractionMixes, LiquidLiquidExtractionSettlingTime, LiquidLiquidExtractionCentrifuge, LiquidLiquidExtractionCentrifugeIntensity, LiquidLiquidExtractionCentrifugeTime, PrecipitationTargetPhase, PrecipitationSeparationTechnique, PrecipitationReagent, PrecipitationReagentTemperature, PrecipitationReagentEquilibrationTime, PrecipitationMixType, PrecipitationMixRate, PrecipitationMixTemperature, PrecipitationMixTime, NumberOfPrecipitationMixes, PrecipitationTime, PrecipitationTemperature, PrecipitationFiltrationTechnique, PrecipitationFilter, PrecipitationPrefilterPoreSize, PrecipitationPrefilterMembraneMaterial, PrecipitationPoreSize, PrecipitationMembraneMaterial, PrecipitationFilterCentrifugeIntensity, PrecipitationFiltrationPressure, PrecipitationFiltrationTime, PrecipitationPelletCentrifugeIntensity, PrecipitationPelletCentrifugeTime, PrecipitationNumberOfWashes, PrecipitationWashSolution, PrecipitationWashSolutionTemperature, PrecipitationWashSolutionEquilibrationTime, PrecipitationWashMixType, PrecipitationWashMixRate, PrecipitationWashMixTemperature, PrecipitationWashMixTime, PrecipitationNumberOfWashMixes, PrecipitationWashPrecipitationTime, PrecipitationWashPrecipitationTemperature, PrecipitationWashCentrifugeIntensity, PrecipitationWashPressure, PrecipitationWashSeparationTime, PrecipitationDryingTemperature, PrecipitationDryingTime, PrecipitationResuspensionBuffer, PrecipitationResuspensionBufferTemperature, PrecipitationResuspensionBufferEquilibrationTime, PrecipitationResuspensionMixType, PrecipitationResuspensionMixRate, PrecipitationResuspensionMixTemperature, PrecipitationResuspensionMixTime, PrecipitationNumberOfResuspensionMixes, SolidPhaseExtractionStrategy, SolidPhaseExtractionSeparationMode, SolidPhaseExtractionSorbent, SolidPhaseExtractionCartridge, SolidPhaseExtractionTechnique, SolidPhaseExtractionLoadingTemperature, SolidPhaseExtractionLoadingTemperatureEquilibrationTime, SolidPhaseExtractionLoadingCentrifugeIntensity, SolidPhaseExtractionLoadingPressure, SolidPhaseExtractionLoadingTime, SolidPhaseExtractionWashSolution, SolidPhaseExtractionWashTemperature, SolidPhaseExtractionWashTemperatureEquilibrationTime, SolidPhaseExtractionWashCentrifugeIntensity, SolidPhaseExtractionWashPressure, SolidPhaseExtractionWashTime, SecondarySolidPhaseExtractionWashSolution, SecondarySolidPhaseExtractionWashTemperature, SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime, SecondarySolidPhaseExtractionWashCentrifugeIntensity, SecondarySolidPhaseExtractionWashPressure, SecondarySolidPhaseExtractionWashTime, TertiarySolidPhaseExtractionWashSolution, TertiarySolidPhaseExtractionWashTemperature, TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime, TertiarySolidPhaseExtractionWashCentrifugeIntensity, TertiarySolidPhaseExtractionWashPressure, TertiarySolidPhaseExtractionWashTime, SolidPhaseExtractionElutionSolution, SolidPhaseExtractionElutionSolutionTemperature, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime, SolidPhaseExtractionElutionCentrifugeIntensity, SolidPhaseExtractionElutionPressure, SolidPhaseExtractionElutionTime, MagneticBeadSeparationSelectionStrategy, MagneticBeadSeparationMode, MagneticBeadSeparationAnalyteAffinityLabel, MagneticBeadAffinityLabel, MagneticBeads, MagneticBeadSeparationPreWash, MagneticBeadSeparationPreWashSolution, MagneticBeadSeparationPreWashMix, MagneticBeadSeparationPreWashMixType, MagneticBeadSeparationPreWashMixTime, MagneticBeadSeparationPreWashMixRate, NumberOfMagneticBeadSeparationPreWashMixes, MagneticBeadSeparationPreWashMixTemperature, PreWashMagnetizationTime, NumberOfMagneticBeadSeparationPreWashes, MagneticBeadSeparationPreWashAirDry, MagneticBeadSeparationPreWashAirDryTime, MagneticBeadSeparationEquilibration, MagneticBeadSeparationEquilibrationSolution, MagneticBeadSeparationEquilibrationMix, MagneticBeadSeparationEquilibrationMixType, MagneticBeadSeparationEquilibrationMixTime, MagneticBeadSeparationEquilibrationMixRate, NumberOfMagneticBeadSeparationEquilibrationMixes, MagneticBeadSeparationEquilibrationMixTemperature, EquilibrationMagnetizationTime, MagneticBeadSeparationEquilibrationAirDry, MagneticBeadSeparationEquilibrationAirDryTime, MagneticBeadSeparationLoadingMix, MagneticBeadSeparationLoadingMixType, MagneticBeadSeparationLoadingMixTime, MagneticBeadSeparationLoadingMixRate, NumberOfMagneticBeadSeparationLoadingMixes, MagneticBeadSeparationLoadingMixTemperature, LoadingMagnetizationTime, MagneticBeadSeparationLoadingAirDry, MagneticBeadSeparationLoadingAirDryTime, MagneticBeadSeparationWash, MagneticBeadSeparationWashSolution, MagneticBeadSeparationWashMix, MagneticBeadSeparationWashMixType, MagneticBeadSeparationWashMixTime, MagneticBeadSeparationWashMixRate, NumberOfMagneticBeadSeparationWashMixes, MagneticBeadSeparationWashMixTemperature, WashMagnetizationTime, NumberOfMagneticBeadSeparationWashes, MagneticBeadSeparationWashAirDry, MagneticBeadSeparationWashAirDryTime, MagneticBeadSeparationSecondaryWash, MagneticBeadSeparationSecondaryWashSolution, MagneticBeadSeparationSecondaryWashMix, MagneticBeadSeparationSecondaryWashMixType, MagneticBeadSeparationSecondaryWashMixTime, MagneticBeadSeparationSecondaryWashMixRate, NumberOfMagneticBeadSeparationSecondaryWashMixes, MagneticBeadSeparationSecondaryWashMixTemperature, SecondaryWashMagnetizationTime, NumberOfMagneticBeadSeparationSecondaryWashes, MagneticBeadSeparationSecondaryWashAirDry, MagneticBeadSeparationSecondaryWashAirDryTime, MagneticBeadSeparationTertiaryWash, MagneticBeadSeparationTertiaryWashSolution, MagneticBeadSeparationTertiaryWashMix, MagneticBeadSeparationTertiaryWashMixType, MagneticBeadSeparationTertiaryWashMixTime, MagneticBeadSeparationTertiaryWashMixRate, NumberOfMagneticBeadSeparationTertiaryWashMixes, MagneticBeadSeparationTertiaryWashMixTemperature, TertiaryWashMagnetizationTime, NumberOfMagneticBeadSeparationTertiaryWashes, MagneticBeadSeparationTertiaryWashAirDry, MagneticBeadSeparationTertiaryWashAirDryTime, MagneticBeadSeparationQuaternaryWash, MagneticBeadSeparationQuaternaryWashSolution, MagneticBeadSeparationQuaternaryWashMix, MagneticBeadSeparationQuaternaryWashMixType, MagneticBeadSeparationQuaternaryWashMixTime, MagneticBeadSeparationQuaternaryWashMixRate, NumberOfMagneticBeadSeparationQuaternaryWashMixes, MagneticBeadSeparationQuaternaryWashMixTemperature, QuaternaryWashMagnetizationTime, NumberOfMagneticBeadSeparationQuaternaryWashes, MagneticBeadSeparationQuaternaryWashAirDry, MagneticBeadSeparationQuaternaryWashAirDryTime, MagneticBeadSeparationQuinaryWash, MagneticBeadSeparationQuinaryWashSolution, MagneticBeadSeparationQuinaryWashMix, MagneticBeadSeparationQuinaryWashMixType, MagneticBeadSeparationQuinaryWashMixTime, MagneticBeadSeparationQuinaryWashMixRate, NumberOfMagneticBeadSeparationQuinaryWashMixes, MagneticBeadSeparationQuinaryWashMixTemperature, QuinaryWashMagnetizationTime, NumberOfMagneticBeadSeparationQuinaryWashes, MagneticBeadSeparationQuinaryWashAirDry, MagneticBeadSeparationQuinaryWashAirDryTime, MagneticBeadSeparationElution, MagneticBeadSeparationElutionSolution, MagneticBeadSeparationElutionMix, MagneticBeadSeparationElutionMixType, MagneticBeadSeparationElutionMixTime, MagneticBeadSeparationElutionMixRate, NumberOfMagneticBeadSeparationElutionMixes, MagneticBeadSeparationElutionMixTemperature, ElutionMagnetizationTime, NumberOfMagneticBeadSeparationElutions
    };


(* ::Subsection::Closed:: *)
(*$NeutralizationOptionMap*)

$NeutralizationOptionMap = {
  NeutralizationSeparationTechnique -> SeparationTechnique,
  NeutralizationReagent -> PrecipitationReagent,
  NeutralizationReagentVolume -> PrecipitationReagentVolume,
  NeutralizationReagentTemperature -> PrecipitationReagentTemperature,
  NeutralizationReagentEquilibrationTime -> PrecipitationReagentEquilibrationTime,
  NeutralizationMixType -> PrecipitationMixType,
  NeutralizationMixTemperature -> PrecipitationMixTemperature,
  NeutralizationMixInstrument -> PrecipitationMixInstrument,
  NeutralizationMixRate -> PrecipitationMixRate,
  NeutralizationMixTime -> PrecipitationMixTime,
  NumberOfNeutralizationMixes -> NumberOfPrecipitationMixes,
  NeutralizationMixVolume -> PrecipitationMixVolume,
  NeutralizationSettlingInstrument -> PrecipitationInstrument,
  NeutralizationSettlingTemperature -> PrecipitationTemperature,
  NeutralizationSettlingTime -> PrecipitationTime,
  NeutralizationFiltrationTechnique -> FiltrationTechnique,
  NeutralizationFiltrationInstrument -> FiltrationInstrument,
  NeutralizationFilter -> Filter,
  NeutralizationPoreSize -> PoreSize,
  NeutralizationMembraneMaterial -> MembraneMaterial,
  NeutralizationFilterPosition -> FilterPosition,
  NeutralizationFilterCentrifugeIntensity -> FilterCentrifugeIntensity,
  NeutralizationFiltrationPressure -> FiltrationPressure,
  NeutralizationFiltrationTime -> FiltrationTime,
  NeutralizationFilterStorageCondition -> FilterStorageCondition,
  NeutralizationPelletVolume -> PelletVolume,
  NeutralizationPelletInstrument -> PelletCentrifuge,
  NeutralizationPelletCentrifugeIntensity -> PelletCentrifugeIntensity,
  NeutralizationPelletCentrifugeTime -> PelletCentrifugeTime,
  NeutralizedSupernatantTransferVolume -> SupernatantVolume,
  NeutralizedPelletStorageCondition -> PrecipitatedSampleStorageCondition,
  NeutralizedPelletLabel -> PrecipitatedSampleLabel,
  NeutralizedPelletContainerLabel -> PrecipitatedSampleContainerLabel
};


(* ::Subsection::Closed:: *)
(* $PlasmidDNANeutralizationOptions *)
$PlasmidDNANeutralizationOptions = {NeutralizationSeparationTechnique, NeutralizationReagent, NeutralizationReagentVolume, NeutralizationReagentTemperature, NeutralizationReagentEquilibrationTime, NeutralizationMixType, NeutralizationMixTemperature, NeutralizationMixInstrument, NeutralizationMixRate, NeutralizationMixTime, NumberOfNeutralizationMixes, NeutralizationMixVolume, NeutralizationSettlingTime, NeutralizationSettlingInstrument, NeutralizationSettlingTemperature, NeutralizationFiltrationTechnique, NeutralizationFiltrationInstrument, NeutralizationFilter, NeutralizationPoreSize, NeutralizationMembraneMaterial, NeutralizationFilterPosition, NeutralizationFilterCentrifugeIntensity, NeutralizationFiltrationPressure, NeutralizationFiltrationTime, NeutralizationFilterStorageCondition, NeutralizationPelletInstrument, NeutralizationPelletCentrifugeIntensity, NeutralizationPelletCentrifugeTime, NeutralizedSupernatantTransferVolume, NeutralizedPelletStorageCondition, NeutralizedPelletLabel, NeutralizedPelletContainerLabel};


(* ::Subsection::Closed:: *)
(*ExperimentExtractPlasmidDNA*)

(* - Container to Sample Overload - *)

ExperimentExtractPlasmidDNA[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
  {cache, listedOptions, listedContainers, outputSpecification, output, gatherTests, containerToSampleResult,
    containerToSampleOutput, samples, sampleOptions, containerToSampleTests, simulation,
    containerToSampleSimulation},

  (* Determine the requested return value from the function *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output, Tests];

  (* Remove temporal links and named objects. *)
  {listedContainers, listedOptions} = removeLinks[ToList[myContainers], ToList[myOptions]];

  (* Fetch the cache from listedOptions. *)
  cache = ToList[Lookup[listedOptions, Cache, {}]];
  simulation = ToList[Lookup[listedOptions, Simulation, {}]];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
      ExperimentExtractPlasmidDNA,
      listedContainers,
      listedOptions,
      Output -> {Result, Tests, Simulation},
      Simulation -> simulation
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
        ExperimentExtractPlasmidDNA,
        listedContainers,
        listedOptions,
        Output -> {Result, Simulation},
        Simulation -> simulation
      ],
      $Failed,
      {Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
    ]
  ];


  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult, $Failed],
    (* containerToSampleOptions failed - return $Failed *)
    outputSpecification /. {
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null
    },
    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples, sampleOptions} = containerToSampleOutput;

    (* Call our main function with our samples and converted options. *)
    ExperimentExtractPlasmidDNA[samples, ReplaceRule[sampleOptions, Simulation -> simulation]]
  ]
];


(* - Main Overload - *)

ExperimentExtractPlasmidDNA[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[]] := Module[
  {
    cache, cacheBall, collapsedResolvedOptions, allDownloadValues, samplePacketFields, sampleModelPacketFields, methodPacketFields, containerObjectFields, containerObjectPacketFields, containerModelPacketFields, sampleFields, sampleModelFields, containerModelFields, expandedSafeOps, gatherTests, inheritedOptions, expandedSafeOpsWithoutPurification, expandedSafeOpsWithoutSolventAdditions, listedOptions, listedSamples, messages, output,outputSpecification, performSimulationQ, protocolObject, preResolvedOptions, resolvedOptionsResult, preResolvedOptionsTests, resourceResult, resourcePacketTests, returnEarlyPostResourcePacketsQ, returnEarlyQ, safeOps, safeOptions, safeOptionTests, templatedOptions, templateTests, resolvedPreparation, simulatedProtocol, roboticSimulation, runTime, resolvedOptions, inheritedSimulation, userSpecifiedObjects, objectsExistQs, objectsExistTests, validLengths, validLengthTests, simulation, listedSanitizedSamples, listedSanitizedOptions, containerModelObjects, containerObjects
  },

  (* Determine the requested return value from the function (Result, Options, Tests, or multiple). *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests (Output contains Test). *)
  gatherTests = MemberQ[output, Tests];
  messages = !gatherTests;

  (* Remove links and temporal links (turn them into just objects). *)
  {listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Call SafeOptions to make sure all options match the option patterns. *)
  {safeOptions, safeOptionTests} = If[gatherTests,
    SafeOptions[ExperimentExtractPlasmidDNA, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[ExperimentExtractPlasmidDNA, listedOptions, AutoCorrect -> False], {}}
  ];

  (* Call sanitize-inputs to clean any named objects (all object Names to object IDs). *)
  {listedSanitizedSamples, safeOps, listedSanitizedOptions} = sanitizeInputs[listedSamples, safeOptions, listedOptions];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths, validLengthTests} = If[gatherTests,
    ValidInputLengthsQ[ExperimentExtractPlasmidDNA, {listedSanitizedSamples}, listedSanitizedOptions, Output -> {Result, Tests}],
    {ValidInputLengthsQ[ExperimentExtractPlasmidDNA, {listedSanitizedSamples}, listedSanitizedOptions], Null}
  ];

  (* If the specified options don't match their patterns return $Failed *)
  If[MatchQ[safeOps, $Failed],
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> safeOptionTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOptionTests, validLengthTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions, templateTests} = If[gatherTests,
    ApplyTemplateOptions[ExperimentExtractPlasmidDNA, {listedSanitizedSamples}, listedSanitizedOptions, Output -> {Result, Tests}],
    {ApplyTemplateOptions[ExperimentExtractPlasmidDNA, {listedSanitizedSamples}, listedSanitizedOptions], Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions, $Failed],
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOptionTests, validLengthTests, templateTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions = ReplaceRule[safeOps, templatedOptions];

  (* Expand index-matching options *)
  expandedSafeOpsWithoutPurification = Last[ExpandIndexMatchedInputs[ExperimentExtractPlasmidDNA, {listedSanitizedSamples}, inheritedOptions]];

  (* Correct expansion of Purification option. *)
  expandedSafeOpsWithoutSolventAdditions = Experiment`Private`expandPurificationOption[inheritedOptions, expandedSafeOpsWithoutPurification, listedSanitizedSamples];

  (* Correct expansion of SolventAdditions if not Automatic. *)
  (* NOTE:This is needed because SolventAdditions is not correctly expanded by ExpandIndexMatchedInputs. *)
  expandedSafeOps = Experiment`Private`expandSolventAdditionsOption[mySamples, inheritedOptions, expandedSafeOpsWithoutSolventAdditions, LiquidLiquidExtractionSolventAdditions, NumberOfLiquidLiquidExtractions];

  (* Fetch the cache from expandedSafeOps *)
  cache = Lookup[expandedSafeOps, Cache, {}];
  inheritedSimulation = Lookup[expandedSafeOps, Simulation, Null];

  (* Disallow Upload->False and Confirm->True. *)
  (* Not making a test here because Upload is a hidden option and we don't currently make tests for hidden options. *)
  If[MatchQ[Lookup[safeOps, Upload], False] && TrueQ[Lookup[safeOps, Confirm]],
    Message[Error::ConfirmUploadConflict];
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Flatten[{safeOptionTests, validLengthTests}],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Make sure that all of our objects exist. *)
  userSpecifiedObjects = DeleteDuplicates@Cases[
    Flatten[{ToList[mySamples], ToList[myOptions]}],
    ObjectReferenceP[]
  ];

  objectsExistQs = DatabaseMemberQ[userSpecifiedObjects, Simulation -> inheritedSimulation];

  (* Build tests for object existence *)
  objectsExistTests = If[gatherTests,
    MapThread[
      Test[StringTemplate["Specified object `1` exists in the database:"][#1], #2, True]&,
      {userSpecifiedObjects, objectsExistQs}
    ],
    {}
  ];

  (* If objects do not exist, return failure *)
  If[!(And @@ objectsExistQs),
    If[!gatherTests,
      Message[Error::ObjectDoesNotExist, PickList[userSpecifiedObjects, objectsExistQs, False]];
      Message[Error::InvalidInput, PickList[userSpecifiedObjects, objectsExistQs, False]]
    ];
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOptionTests, validLengthTests, templateTests, objectsExistTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

  (* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)

  (* - DOWNLOAD - *)

  (* Download fields from samples that are required.*)
  (* NOTE: All fields downloaded below should already be included in the cache passed down to us by the main function. *)
  sampleFields = DeleteDuplicates[Flatten[{Name, Status, Model, Composition, CellType, Living, CultureAdhesion, Volume, Analytes, Density, Container, Position, SamplePreparationCacheFields[Object[Sample]]}]];
  samplePacketFields = Packet @@ sampleFields;
  sampleModelFields = DeleteDuplicates[Flatten[{Name, Composition, Density, Deprecated}]];
  sampleModelPacketFields = Packet @@ sampleModelFields;
  methodPacketFields = Packet[All];
  containerObjectFields = {Contents, Model, Name};
  containerObjectPacketFields = Packet @@ containerObjectFields;
  containerModelFields = {VolumeCalibrations, MaxCentrifugationForce, Footprint, MaxVolume, Positions, Name};
  containerModelPacketFields = Packet @@ containerModelFields;

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


  allDownloadValues = Download[
    {
      listedSanitizedSamples,
      listedSanitizedSamples,
      Cases[Lookup[expandedSafeOps, Method], ObjectP[]],
      listedSanitizedSamples,
      listedSanitizedSamples,
      containerModelObjects,
      containerObjects
    },
    Evaluate[{
      {samplePacketFields},
      {Packet[Model[sampleModelFields]]},
      {methodPacketFields},
      {Packet[Container[containerObjectFields]]},
      {Packet[Container[Model][containerModelFields]]},
      {containerModelPacketFields, Packet[VolumeCalibrations[{CalibrationFunction}]]},
      {containerObjectPacketFields, Packet[Model[containerModelFields]], Packet[Model[VolumeCalibrations][{CalibrationFunction}]]}
    }],
    Cache -> cache,
    Simulation -> inheritedSimulation
  ];

  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  cacheBall = FlattenCachePackets[{cache, allDownloadValues}];

  (* Build the pre-resolved options (options are actually resolved in RCP call in resource packets). *)
  resolvedOptionsResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {preResolvedOptions, preResolvedOptionsTests} = resolveExperimentExtractPlasmidDNAOptions[
      ToList[Download[mySamples, Object]],
      expandedSafeOps,
      Cache -> cacheBall,
      Simulation -> inheritedSimulation,
      Output -> {Result, Tests}
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests" -> preResolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      {preResolvedOptions, preResolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {preResolvedOptions, preResolvedOptionsTests} = {
        resolveExperimentExtractPlasmidDNAOptions[
          ToList[Download[mySamples, Object]],
          expandedSafeOps,
          Cache -> cacheBall,
          Simulation -> inheritedSimulation
        ],
        {}
      },
      $Failed,
      {Error::InvalidInput, Error::InvalidOption}
    ]
  ];

  (* Run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  returnEarlyQ = Which[
    MatchQ[resolvedOptionsResult, $Failed],
      True,
    gatherTests,
      Not[RunUnitTest[<|"Tests" -> preResolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
    True,
      False
  ];

  (* Determine if a simulation is requested. *)
  performSimulationQ = MemberQ[output, Result | Simulation];

  (* If option resolution failed (and a simulation hasn't been requested), return early. *)
  If[returnEarlyQ && !performSimulationQ,
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOptionTests, validLengthTests, templateTests, preResolvedOptionsTests],
      Options -> RemoveHiddenOptions[ExperimentExtractPlasmidDNA, preResolvedOptions],
      Preview -> Null,
      Simulation -> Simulation[]
    }]
  ];

  (* Build packets with resources *)
  (* NOTE: If our resource packets function, if Preparation->Robotic, we call RSP in order to get the robotic unit operation *)
  (* packets. We also get a robotic simulation at the same time. *)
  {{resourceResult, roboticSimulation, runTime, resolvedOptions}, resourcePacketTests} = Module[{fullResourceResult, resourceTests},
    Which[
      MatchQ[resolvedOptionsResult, $Failed],
        {{$Failed, $Failed, $Failed, $Failed}, {}},
      gatherTests,
        {fullResourceResult, resourceTests} = extractPlasmidDNAResourcePackets[
          ToList[Download[mySamples, Object]],
          templatedOptions,
          preResolvedOptions,
          Cache -> cacheBall,
          Simulation -> inheritedSimulation,
          Output -> {Result, Tests}
        ];

        (* Therefore, we have to run the tests to see if we encountered a failure. *)
        If[RunUnitTest[<|"Tests" -> resourceTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
          {fullResourceResult, resourceTests},
          {{$Failed, $Failed, $Failed, $Failed}, {}}
        ],
      True,
        (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
        Check[
          {
            extractPlasmidDNAResourcePackets[
              ToList[Download[mySamples, Object]],
              templatedOptions,
              preResolvedOptions,
              Cache -> cacheBall,
              Simulation -> inheritedSimulation
            ],
            {}
          },
          {{$Failed, $Failed, $Failed, $Failed}, {}},
          {Error::InvalidInput, Error::InvalidOption}
        ]
    ]
  ];

  (* Run all the tests from creating the resource packets; if any of them were False, then we should return early here *)
  (* NOTE: This needs to be done here again because there is option error checking after the resource packets for this function. *)
  (* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  returnEarlyPostResourcePacketsQ = Which[
    MatchQ[resourceResult, $Failed],
      True,
    gatherTests,
      Not[RunUnitTest[<|"Tests" -> resourcePacketTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
    True,
      False
  ];

  (* If resources packet building failed, return early. *)
  If[returnEarlyPostResourcePacketsQ,
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOptionTests, validLengthTests, templateTests, preResolvedOptionsTests, resourcePacketTests],
      Options -> RemoveHiddenOptions[ExperimentExtractPlasmidDNA, preResolvedOptions],
      Preview -> Null,
      Simulation -> Simulation[]
    }]
  ];

  (* Collapse the resolved options *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentExtractPlasmidDNA,
    resolvedOptions,
    Ignore -> ToList[myOptions],
    Messages -> False
  ];

  (* Lookup our resolved Preparation option. *)
  resolvedPreparation = Lookup[resolvedOptions, Preparation];

  (* If we were asked for a simulation, also return a simulation. *)
  {simulatedProtocol, simulation} = If[performSimulationQ,
    simulateExperimentExtractPlasmidDNA[
      If[MatchQ[resourceResult, $Failed],
        $Failed,
        resourceResult[[1]] (* protocolPacket *)
      ],
      If[MatchQ[resourceResult, $Failed],
        $Failed,
        Flatten[ToList[Rest[resourceResult]]] (* allUnitOperationPackets *)
      ],
      ToList[Download[mySamples, Object]],
      resolvedOptions,
      Cache -> cacheBall,
      Simulation -> roboticSimulation,
      ParentProtocol -> Lookup[safeOps, ParentProtocol]
    ],
    {Null, Null}
  ];

  (* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
  If[!MemberQ[output, Result],
    Return[outputSpecification /. {
      Result -> Null,
      Tests -> Flatten[{safeOptionTests, validLengthTests, templateTests, preResolvedOptionsTests, resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentExtractPlasmidDNA, collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> simulation,
      RunTime -> runTime
    }]
  ];

  (* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
  protocolObject = Which[
    (* If our resource packets failed, we can't upload anything. *)
    MatchQ[resourceResult, $Failed],
      $Failed,

    (* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
    (* Upload->False. *)
    MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[safeOps, Upload], False],
      Rest[resourceResult], (* unitOperationPackets *)

    (* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticSamplePreparation with our primitive. *)
    True,
      Module[{primitive, nonHiddenOptions, experimentFunction},
        (* Create our primitive to feed into RoboticSamplePreparation. *)
        primitive = ExtractPlasmidDNA @@ Join[
          {
            Sample -> Download[ToList[mySamples], Object]
          },
          RemoveHiddenPrimitiveOptions[ExtractPlasmidDNA, ToList[myOptions]]
        ];

        (* Remove any hidden options before returning. *)
        nonHiddenOptions = RemoveHiddenOptions[ExperimentExtractPlasmidDNA, collapsedResolvedOptions];

        (* Memoize the value of ExperimentExtractPlasmidDNA so the framework doesn't spend time resolving it again. *)
        Internal`InheritedBlock[{ExperimentExtractPlasmidDNA, $PrimitiveFrameworkResolverOutputCache},
          $PrimitiveFrameworkResolverOutputCache = <||>;

          DownValues[ExperimentExtractPlasmidDNA] = {};

          ExperimentExtractPlasmidDNA[___, options : OptionsPattern[]] := Module[{frameworkOutputSpecification},
            (* Lookup the output specification the framework is asking for. *)
            frameworkOutputSpecification = Lookup[ToList[options], Output];

            frameworkOutputSpecification /. {
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
            Name -> Lookup[safeOps, Name],
            Upload -> Lookup[safeOps, Upload],
            Confirm -> Lookup[safeOps, Confirm],
            ParentProtocol -> Lookup[safeOps, ParentProtocol],
            Priority -> Lookup[safeOps, Priority],
            StartDate -> Lookup[safeOps, StartDate],
            HoldOrder -> Lookup[safeOps, HoldOrder],
            QueuePosition -> Lookup[safeOps, QueuePosition],
            Cache -> cacheBall
          ]
        ]
      ]
  ];

  (* Return requested output *)
  outputSpecification /. {
    Result -> protocolObject,
    Tests -> Flatten[{safeOptionTests, validLengthTests, templateTests, preResolvedOptionsTests, resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentExtractPlasmidDNA, collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> simulation,
    RunTime -> runTime
  }
];


(* ::Subsection:: *)
(* resolveExtractPlasmidDNAWorkCell *)

DefineOptions[resolveExtractPlasmidDNAWorkCell,
  SharedOptions :> {
    ExperimentExtractPlasmidDNA,
    CacheOption,
    SimulationOption,
    OutputOption
  }
];

resolveExtractPlasmidDNAWorkCell[
  myContainersAndSamples : ListableP[Automatic | ObjectP[{Object[Sample], Object[Container]}]],
  myOptions : OptionsPattern[]
] := Module[{mySamples, samplePackets},

  mySamples = Cases[myContainersAndSamples, ObjectP[Object[Sample]], Infinity];

  samplePackets = Download[mySamples, Packet[CellType]];

  (* NOTE: due to the mechanism by which the primitive framework resolves WorkCell, we can't just resolve it on our own and then tell *)
  (* the framework what to use. So, we resolve using the CellType option if specified, or the CellType field in the input sample(s). *)

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
    (*Otherwise, the bioSTAR or microbioSTAR can be used.*)
    True,
      {bioSTAR, microbioSTAR}
  ]

];

(* ::Subsection::Closed:: *)
(*resolveExperimentExtractPlasmidDNAOptions*)

DefineOptions[
  resolveExperimentExtractPlasmidDNAOptions,
  Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentExtractPlasmidDNAOptions[mySamples : {ObjectP[Object[Sample]]...}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentExtractPlasmidDNAOptions]] := Module[
  {
    (*Option Setup and Cache Setup*)
    outputSpecification, output, gatherTests, messages, cache, listedOptions, currentSimulation, optionPrecisions, roundedExperimentOptions,

    (*Precision Tests*)
    optionPrecisionTests, preResolvedPreCorrectionMapThreadFriendlyOptions, mapThreadFriendlyOptionsWithoutSolventAdditions, mapThreadFriendlyOptions,

    (*Downloads*)
    samplePackets, sampleModelPackets, methodPackets, sampleContainerPackets, sampleContainerModelPackets,cacheBall, fastCacheBall, methodObjects,

    (*Input Validation*)
    discardedInvalidInputs, discardedTest, deprecatedSamplePackets, deprecatedInvalidInputs, deprecatedTest, solidMediaInvalidInputs, solidMediaTest, invalidInputs, optionCheckPreCorrectionMapThreadFriendlyOptions, optionCheckMapThreadFriendlyOptionsWithoutSolventAdditions, optionCheckMapThreadFriendlyOptions, invalidOptions, methodConflictingOptions, methodConflictingOptionsTest,

    (*General*)
    resolvedRoboticInstrument, resolvedWorkCell,

    (*Lysing*)
    preResolvedLysisOptions, resolvedLyse, resolvedLysisTime, resolvedLysisTemperature, resolvedLysisAliquot, resolvedClarifyLysateBool, preResolvedCellType, preResolvedNumberOfLysisSteps, preResolvedPreLysisPellet, preResolvedPreLysisPelletingIntensity, preResolvedPreLysisPelletingTime, preResolvedLysisSolution, preResolvedLysisMixType, preResolvedLysisMixRate, preResolvedLysisMixTime, preResolvedNumberOfLysisMixes, preResolvedLysisMixTemperature, preResolvedSecondaryLysisSolution, preResolvedSecondaryLysisMixType, preResolvedSecondaryLysisMixRate, preResolvedSecondaryLysisMixTime, preResolvedSecondaryNumberOfLysisMixes, preResolvedSecondaryLysisMixTemperature, preResolvedSecondaryLysisTime, preResolvedSecondaryLysisTemperature, preResolvedTertiaryLysisSolution, preResolvedTertiaryLysisMixType, preResolvedTertiaryLysisMixRate, preResolvedTertiaryLysisMixTime, preResolvedTertiaryNumberOfLysisMixes, preResolvedTertiaryLysisMixTemperature, preResolvedTertiaryLysisTime, preResolvedTertiaryLysisTemperature, preResolvedClarifyLysateIntensity, preResolvedClarifyLysateTime,preResolvedLysisAliquotContainer, preResolvedClarifiedLysateContainer, preResolvedClarifiedLysateContainerLabel,

    (*Neutralization*)
    preResolvedNeutralizationSeparationTechnique, preResolvedNeutralizationReagent, preResolvedNeutralizationReagentVolume, preResolvedNeutralizationReagentTemperature, preResolvedNeutralizationReagentEquilibrationTime, preResolvedNeutralizationMixType, preResolvedNeutralizationMixTemperature, preResolvedNeutralizationMixInstrument, preResolvedNeutralizationMixRate, preResolvedNeutralizationMixTime, preResolvedNumberOfNeutralizationMixes, preResolvedNeutralizationMixVolume, preResolvedNeutralizationSettlingInstrument, preResolvedNeutralizationSettlingTemperature, preResolvedNeutralizationSettlingTime, preResolvedNeutralizationFiltrationTechnique, preResolvedNeutralizationFiltrationInstrument, preResolvedNeutralizationFilter, preResolvedNeutralizationPoreSize, preResolvedNeutralizationMembraneMaterial, preResolvedNeutralizationFilterPosition, preResolvedNeutralizationFilterCentrifugeIntensity, preResolvedNeutralizationFiltrationPressure, preResolvedNeutralizationFiltrationTime, preResolvedNeutralizationFilterStorageCondition, preResolvedNeutralizationPelletVolume, preResolvedNeutralizationPelletInstrument, preResolvedNeutralizationPelletCentrifugeIntensity, preResolvedNeutralizationPelletCentrifugeTime, preResolvedNeutralizedSupernatantTransferVolume, preResolvedNeutralizedPelletStorageCondition, preResolvedNeutralizedPelletLabel, preResolvedNeutralizedPelletContainerLabel, preResolvedNeutralizedSolutionLabel, preResolvedNeutralizedSolutionContainer, preResolvedNeutralizedSolutionContainerLabel, neutralizationPreResolvedOptions, resolvedNeutralize,

    (* Solid Phase Extraction *)
    resolvedSolidPhaseExtractionCartridge, resolvedSolidPhaseExtractionSorbent, resolvedSolidPhaseExtractionSeparationMode, resolvedSolidPhaseExtractionWashSolution, resolvedSecondarySolidPhaseExtractionWashSolution, resolvedTertiarySolidPhaseExtractionWashSolution, resolvedSolidPhaseExtractionElutionSolution,

    (*Purification Options*)
    resolvedPurification, preResolvedPurificationOptions, purificationReadyExperimentOptions, preCorrectionPurificationReadyExperimentMapThreadFriendlyOptions, purificationReadyMapThreadFriendlyOptionsWithoutSolventAdditions, purificationReadyExperimentMapThreadFriendlyOptions,

    (*Container Out*)
    preResolvedContainersOutWithWellsRemoved, userSpecifiedLabels, resolvedExtractedPlasmidDNALabel, preResolvedExtractedPlasmidDNAContainerLabel, preResolvedContainerOutWell, preResolvedIndexedContainerOut, preResolvedRoundedExperimentOptions, preResolvedMapThreadFriendlyOptionsWithoutSolventAdditions, preResolvedMapThreadFriendlyOptions,

    (*Post-resolution*)
    resolvedPostProcessingOptions, preResolvedOptions, methodValidityTest, invalidExtractionMethodOptions, solidPhaseExtractionConflictingOptionsTests, solidPhaseExtractionConflictingOptions, mbsMethodsConflictingOptionsTest, mbsMethodsConflictingOptions, purificationTests, purificationInvalidOptions

  },


  (* - SETUP USER SPECIFIED OPTIONS AND CACHE - *)

  (* Determine the requested output format of this function. *)
  outputSpecification = OptionValue[Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output, Tests];
  messages = !gatherTests;

  (* Fetch our cache from the parent function. *)
  (* Make fast association to look up things from cache quickly.*)
  cacheBall = Lookup[ToList[myResolutionOptions], Cache, {}];
  fastCacheBall = makeFastAssocFromCache[cacheBall];

  (* ToList our options. *)
  listedOptions = ToList[myOptions];

  (* Lookup our simulation. *)
  currentSimulation = Lookup[ToList[myResolutionOptions], Simulation];

  (* - RESOLVE PREPARATION OPTION - *)
  (* Usually, we resolve our Preparation option here, but since we can only do Preparation -> Robotic, there is no need to. *)

  (* - DOWNLOAD - *)

  (* gather the methods we Downloaded, and the containers, and the contianer models *)
  methodObjects = Replace[Lookup[myOptions, Method], {Custom -> Null}, 2];

  samplePackets = fetchPacketFromFastAssoc[#, fastCacheBall]& /@ mySamples;
  sampleModelPackets = fetchPacketFromFastAssoc[fastAssocLookup[fastCacheBall, #, Model], fastCacheBall]& /@ mySamples;
  methodPackets = If[NullQ[#], Null, fetchPacketFromFastAssoc[#, fastCacheBall]]& /@ methodObjects;
  sampleContainerPackets = fetchPacketFromFastAssoc[fastAssocLookup[fastCacheBall, #, Container], fastCacheBall]& /@ mySamples;
  sampleContainerModelPackets = fetchPacketFromFastAssoc[fastAssocLookup[fastCacheBall, #, {Container, Model}], fastCacheBall]& /@ mySamples;

  (* - INPUT VALIDATION CHECKS - *)

  (*-- DISCARDED SAMPLE CHECK --*)

  {discardedInvalidInputs, discardedTest} = checkDiscardedSamples[samplePackets, messages, Cache -> cacheBall];


  (* -- DEPRECATED MODEL CHECK -- *)

  (* Get the samples from samplePackets that are discarded. *)
  deprecatedSamplePackets = Select[Flatten[sampleModelPackets], If[MatchQ[#, Except[Null]], MatchQ[Lookup[#, Deprecated], True]]&];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  deprecatedInvalidInputs = Lookup[deprecatedSamplePackets, Object, {}];

  (* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
  If[Length[deprecatedInvalidInputs] > 0 && messages,
    Message[Error::DeprecatedModels, ObjectToString[deprecatedInvalidInputs, Cache -> cacheBall]]
  ];

  (* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
  deprecatedTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[deprecatedInvalidInputs] == 0,
        Nothing,
        Test["The input samples " <> ObjectToString[deprecatedInvalidInputs, Cache -> cacheBall] <> " do not have deprecated models:", True, False]
      ];
      passingTest = If[Length[deprecatedInvalidInputs] == Length[mySamples],
        Nothing,
        Test["The input samples " <> ObjectToString[Complement[mySamples, deprecatedInvalidInputs], Cache -> cacheBall] <> " do not have deprecated models:", True, True]
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

  optionPrecisions = Sequence @@@ {$CellLysisOptionsPrecisions, $ExtractionLiquidLiquidSharedOptionsPrecisions, $PrecipitationSharedOptionsPrecisions, $ExtractionSolidPhaseSharedOptionsPrecisions, $ExtractionMagneticBeadSharedOptionsPrecisions};

  (* There are still a few options that we need to check the precisions of though. *)
  {roundedExperimentOptions, optionPrecisionTests} = If[gatherTests,
    (*If we are gathering tests *)
    RoundOptionPrecision[Association @@ listedOptions, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
    (* Otherwise *)
    {RoundOptionPrecision[Association @@ listedOptions, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]]], {}}
  ];


  (* - RESOLVE EXPERIMENT OPTIONS - *)

  (* --- mapThreadFriendly Option Conversion --- *)

  (* Convert our options into a MapThread friendly version. *)
  preResolvedPreCorrectionMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, roundedExperimentOptions];

  mapThreadFriendlyOptionsWithoutSolventAdditions = Experiment`Private`makePurificationMapThreadFriendly[mySamples, roundedExperimentOptions, preResolvedPreCorrectionMapThreadFriendlyOptions];

  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  mapThreadFriendlyOptions = Experiment`Private`mapThreadFriendlySolventAdditions[roundedExperimentOptions, mapThreadFriendlyOptionsWithoutSolventAdditions, LiquidLiquidExtractionSolventAdditions];


  (* -- RESOLVE NON-MAPTHREAD, NON-CONTAINER OPTIONS -- *)

  (* Resolve the RoboticInstrument.*)
  resolvedRoboticInstrument = Which[
    (*If user-set, then use set value.*)
    MatchQ[Lookup[myOptions, RoboticInstrument], Except[Automatic]],
      Lookup[myOptions, RoboticInstrument],
    (*If CellType option for all Samples are Mammalian (set or from the field in their sample object), then the bioSTAR is used.*)
    Or[MatchQ[Lookup[myOptions, CellType], {Mammalian..}], MatchQ[Lookup[samplePackets, CellType], {Mammalian..}]],
      Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"], (*Model[Instrument, LiquidHandler, "bioSTAR"]*)
    (*Otherwise, use the microbioSTAR.*)
    True,
      Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"] (*Model[Instrument, LiquidHandler, "microbioSTAR"]*)
  ];

  (* Resolve the WorkCell.*)
  resolvedWorkCell = Which[
    (*If user-set, then use set value.*)
    MatchQ[Lookup[myOptions, WorkCell], Except[Automatic]],
      Lookup[myOptions, WorkCell],
    (*If not user-set, then set based on the RoboticInstrument.*)
    MatchQ[resolvedRoboticInstrument, ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]]],
      bioSTAR,
    MatchQ[resolvedRoboticInstrument, ObjectP[Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]]],
      microbioSTAR,
    (*If CellType option for all Samples are non-microbial (set or from the field in their sample object), then the bioSTAR is used.*)
    Or[MatchQ[Lookup[myOptions, CellType], {Mammalian..}], MatchQ[Lookup[samplePackets, CellType], {Mammalian..}]],
      bioSTAR,
    (*Otherwise, use the microbioSTAR.*)
    True,
      microbioSTAR
  ];

  (* -- CONTAINER, LABELS, AND PURIFICATION -- *)
  (* NOTE: Need labels and Purification to be resolved before options to thread in final container/label into regular options. *)
  (* e.g. If Lysis with clarification is last step, then ClarifiedLysateContainerLabel needs to match ExtractedPlasmidDNAContainerLabel. *)

  (* resolve the purification master switch option *)
  resolvedPurification = resolvePurification[mapThreadFriendlyOptions, Lookup[myOptions, Method]];

  (* Get all of the user specified labels. *)
  userSpecifiedLabels = DeleteDuplicates@Cases[
    Flatten@Lookup[
      Association @@ myOptions,
      {

        (* General *)
        ExtractedPlasmidDNALabel, ExtractedPlasmidDNAContainerLabel,

        (* Lysis *)
        PreLysisSupernatantLabel, PreLysisSupernatantContainerLabel, PostClarificationPelletLabel, PostClarificationPelletContainerLabel,

        (* Neutralization *)
        NeutralizedPelletLabel, NeutralizedPelletContainerLabel,

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

  (* Resolve the output label and container output label. *)
  resolvedExtractedPlasmidDNALabel = MapThread[
    Function[{sample, options},
      Which[
        (* If specified by user, then use that value. *)
        MatchQ[Lookup[options, ExtractedPlasmidDNALabel], Except[Automatic]],
          Lookup[options, ExtractedPlasmidDNALabel],
        (* If the sample has a label from an upstream unit operation, then use that. *)
        MatchQ[LookupObjectLabel[currentSimulation, Download[sample, Object]], _String],
          LookupObjectLabel[currentSimulation, Download[sample, Object]],
        (* If the sample does not already have a label and one is not specified by the user, then set to the default. *)
        True,
          CreateUniqueLabel["extracted plasmid DNA sample", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]
      ]
    ],
    {mySamples, mapThreadFriendlyOptions}
  ];

  (* Remove any wells from user-specified container out inputs according to their widget patterns. *)
  preResolvedContainersOutWithWellsRemoved = Map[
    Which[
      (* If the user specified ContainerOut using the "Container with Well" widget format, remove the well. *)
      MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container], Model[Container]}]}],
        Last[#],
      (* If the user specified ContainerOut using the "Container with Well and Index" widget format, remove the well. *)
      MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container], Model[Container]}]}}],
        Last[#],
      (* If the user specified ContainerOut any other way, we don't have to mess with it here. *)
      True,
        #
    ]&,
    Lookup[roundedExperimentOptions, ContainerOut]
  ];

  (* Resolve the container labels based on the information that we have prior to simulation. *)
  preResolvedExtractedPlasmidDNAContainerLabel = Module[{sampleContainersToGroupedLabels, sampleContainersToUserSpecifiedLabels},

    (* Make association of containers to their label(s). *)
    (* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
    sampleContainersToGroupedLabels = GroupBy[
      Rule @@@ Transpose[{preResolvedContainersOutWithWellsRemoved, Lookup[roundedExperimentOptions, ExtractedPlasmidDNAContainerLabel]}],
      First -> Last
    ];

    sampleContainersToUserSpecifiedLabels = (#[[1]] -> FirstCase[#[[2]], _String, Null]&) /@ Normal[sampleContainersToGroupedLabels];

    MapThread[
      Function[{container, userSpecifiedLabel},
        Which[
          (* User specified the option. *)
          MatchQ[userSpecifiedLabel, _String],
            userSpecifiedLabel,
          (* All Model[Container]s are unique and recieve unique labels. *)
          MatchQ[container, ObjectP[Model[Container]]],
            CreateUniqueLabel["extracted plasmid DNA sample container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
          (* User specified the option for another index that this container shows up. *)
          MatchQ[Lookup[sampleContainersToUserSpecifiedLabels, Key[container]], _String],
            Lookup[sampleContainersToUserSpecifiedLabels, Key[container]],
          (* The user has labeled this container upstream in another unit operation. *)
          MatchQ[container, ObjectP[Object[Container]]] && MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[container, Object]], _String],
            LookupObjectLabel[currentSimulation, Download[container, Object]],
          (* If a container is specified, make a new label for this container and add it to the container-to-label association. *)
          MatchQ[container, Except[Automatic]],
            Module[{},
              sampleContainersToUserSpecifiedLabels = ReplaceRule[
                sampleContainersToUserSpecifiedLabels,
                container -> CreateUniqueLabel["extracted plasmid DNA sample container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]
              ];

              Lookup[sampleContainersToUserSpecifiedLabels, Key[container]]
            ],
          (* Otherwise, make a new label to be assigned to the container that is resolved in RCP. *)
          True,
            CreateUniqueLabel["extracted plasmid DNA sample container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]
        ]
      ],
      {preResolvedContainersOutWithWellsRemoved, Lookup[listedOptions, ExtractedPlasmidDNAContainerLabel]}
    ]
  ];

  (* Pre-resolve the ContainerOutWell and the indexed version of the container out (without a well). *)
  (* Needed for threading user-specified ContainerOut into unit operations for simulation/protocol.  *)
  {preResolvedContainerOutWell, preResolvedIndexedContainerOut} = Module[
    {wellsFromContainersOut, uniqueContainers, containerToFilledWells, containerToWellOptions, containerToIndex},

    (* Get any wells from user-specified container out inputs according to their widget patterns. *)
    wellsFromContainersOut = Map[
      Which[
        (* If ContainerOut specified using the "Container with Well" widget format, extract the well. *)
        MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container], Model[Container]}]}],
          First[#],
        (* If ContainerOut specified using the "Container with Well and Index" widget format, extract the well. *)
        MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container], Model[Container]}]}}],
         First[#],
        (* Otherwise, there isn't a well specified and we set this to automatic. *)
        True,
          Automatic
      ]&,
      Lookup[roundedExperimentOptions, ContainerOut]
    ];

    (*Make an association of the containers with their already specified wells.*)
    uniqueContainers = DeleteDuplicates[Cases[preResolvedContainersOutWithWellsRemoved, Alternatives[ObjectP[Object[Container]], ObjectP[Model[Container]], {_Integer, ObjectP[Model[Container]]}]]];

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
              {wellsFromContainersOut, preResolvedContainersOutWithWellsRemoved}
            ];

            (*Return rule in the form of indexed container model to Filled wells.*)
            If[
              MatchQ[#[[1]], _Integer],
              # -> uniqueContainerWells,
              {1, #} -> uniqueContainerWells
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
        {containerModel},

        (*Get the container model to look up the available wells.*)
        containerModel =
            Which[
              (*If the container without a well is just a container model, then that can be used directly.*)
              MatchQ[#, ObjectP[Model[Container]]],
                #,
              (*If the container is an object, then the model is downloaded from the cache.*)
              MatchQ[#, ObjectP[Object[Container]]],
                Download[#, Model],
              (*If the container is an indexed container model, then the model is the second element.*)
              True,
                #[[2]]
            ];

        (*The well options are downloaded from the cache from the container model.*)
        # -> Flatten[Transpose[AllWells[containerModel]]]

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
        {well, container},
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
                    KeyExistsQ[containerToFilledWells, {Lookup[containerToIndex, container], container}],
                    containerToIndex = ReplaceRule[containerToIndex, container -> (Lookup[containerToIndex, container] + 1)]
                  ];

                  {Lookup[containerToIndex, container], container}

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
                {filledWells, wellOptions, availableWells, selectedWell},

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
                  MatchQ[availableWells, {}] && !MatchQ[container, ObjectP[Object[Container]] | {_Integer, ObjectP[Model[Container]]}],
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
                  ReplaceRule[containerToFilledWells, {indexedContainer -> Append[filledWells, selectedWell]}],
                  Append[containerToFilledWells, indexedContainer -> Append[filledWells, selectedWell]]
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
      {wellsFromContainersOut, preResolvedContainersOutWithWellsRemoved}
    ]]

  ];

  (* Add in pre-resolved labels into options and make mapThreadFriendly for further resolutions. *)
  preResolvedRoundedExperimentOptions = Merge[
    {
      roundedExperimentOptions,
      <|
        Purification -> resolvedPurification,
        ExtractedPlasmidDNALabel -> resolvedExtractedPlasmidDNALabel,
        ExtractedPlasmidDNAContainerLabel -> preResolvedExtractedPlasmidDNAContainerLabel
      |>
    },
    Last
  ];

  (* Convert our options into a MapThread friendly version. *)
  preResolvedPreCorrectionMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, preResolvedRoundedExperimentOptions];

  preResolvedMapThreadFriendlyOptionsWithoutSolventAdditions = Experiment`Private`makePurificationMapThreadFriendly[mySamples, preResolvedRoundedExperimentOptions, preResolvedPreCorrectionMapThreadFriendlyOptions];

  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  preResolvedMapThreadFriendlyOptions = Experiment`Private`mapThreadFriendlySolventAdditions[preResolvedRoundedExperimentOptions, preResolvedMapThreadFriendlyOptionsWithoutSolventAdditions, LiquidLiquidExtractionSolventAdditions];

  (* -- MAPTHREAD-- *)

  (* TODO::Add label threading in MapThread if any purifications are the last step. *)
  (*Resolve and pre-resolve options that are either ExperimentExtractPlasmidDNA-specific or have defaults and thus cannot be Automatic for simulation.*)
  {
    (*Lysing*)
    resolvedLyse,
    resolvedLysisTime,
    resolvedLysisTemperature,
    resolvedLysisAliquot,
    resolvedClarifyLysateBool,
    preResolvedCellType,
    preResolvedNumberOfLysisSteps,
    preResolvedPreLysisPellet,
    preResolvedPreLysisPelletingIntensity,
    preResolvedPreLysisPelletingTime,
    preResolvedLysisSolution,
    preResolvedLysisMixType,
    preResolvedLysisMixRate,
    preResolvedLysisMixTime,
    preResolvedNumberOfLysisMixes,
    preResolvedLysisMixTemperature,
    preResolvedSecondaryLysisSolution,
    preResolvedSecondaryLysisMixType,
    preResolvedSecondaryLysisMixRate,
    preResolvedSecondaryLysisMixTime,
    preResolvedSecondaryNumberOfLysisMixes,
    preResolvedSecondaryLysisMixTemperature,
    preResolvedSecondaryLysisTime,
    preResolvedSecondaryLysisTemperature,
    preResolvedTertiaryLysisSolution,
    preResolvedTertiaryLysisMixType,
    preResolvedTertiaryLysisMixRate,
    preResolvedTertiaryLysisMixTime,
    preResolvedTertiaryNumberOfLysisMixes,
    preResolvedTertiaryLysisMixTemperature,
    preResolvedTertiaryLysisTime,
    preResolvedTertiaryLysisTemperature,
    preResolvedClarifyLysateIntensity,
    preResolvedClarifyLysateTime,
    preResolvedLysisAliquotContainer,
    preResolvedClarifiedLysateContainer,
    preResolvedClarifiedLysateContainerLabel,
    (*NOTE:The rest of the lysing options are resolved outside of the MapThread by feeding them into ExperimentLyseCells.*)

    (*Neutralization*)
    resolvedNeutralize,
    preResolvedNeutralizationSeparationTechnique, preResolvedNeutralizationReagent,
    preResolvedNeutralizationReagentVolume,
    preResolvedNeutralizationReagentTemperature,
    preResolvedNeutralizationReagentEquilibrationTime,
    preResolvedNeutralizationMixType,
    preResolvedNeutralizationMixTemperature,
    preResolvedNeutralizationMixInstrument,
    preResolvedNeutralizationMixRate,
    preResolvedNeutralizationMixTime,
    preResolvedNumberOfNeutralizationMixes,
    preResolvedNeutralizationMixVolume,
    preResolvedNeutralizationSettlingInstrument,
    preResolvedNeutralizationSettlingTemperature,
    preResolvedNeutralizationSettlingTime,
    preResolvedNeutralizationFiltrationTechnique,
    preResolvedNeutralizationFiltrationInstrument,
    preResolvedNeutralizationFilter,
    preResolvedNeutralizationPoreSize,
    preResolvedNeutralizationMembraneMaterial,
    preResolvedNeutralizationFilterPosition,
    preResolvedNeutralizationFilterCentrifugeIntensity,
    preResolvedNeutralizationFiltrationPressure,
    preResolvedNeutralizationFiltrationTime,
    preResolvedNeutralizationFilterStorageCondition,
    preResolvedNeutralizationPelletVolume,
    preResolvedNeutralizationPelletInstrument,
    preResolvedNeutralizationPelletCentrifugeIntensity,
    preResolvedNeutralizationPelletCentrifugeTime,
    preResolvedNeutralizedSupernatantTransferVolume,
    preResolvedNeutralizedPelletStorageCondition,
    preResolvedNeutralizedPelletLabel,
    preResolvedNeutralizedPelletContainerLabel,
    preResolvedNeutralizedSolutionLabel,
    preResolvedNeutralizedSolutionContainer,
    preResolvedNeutralizedSolutionContainerLabel

  } = Transpose@MapThread[
    Function[{samplePacket, methodPacket, options},
      Module[
        {
          methodSpecifiedQ,

          (*Lysing*)
          lyse,
          lysisTime,
          lysisTemperature,
          lysisAliquot,
          clarifyLysateBool,
          cellType,
          numberOfLysisSteps,
          preLysisPellet,
          preLysisPelletingIntensity,
          preLysisPelletingTime,
          lysisSolution,
          lysisMixType,
          lysisMixRate,
          lysisMixTime,
          numberOfLysisMixes,
          lysisMixTemperature,
          secondaryLysisSolution,
          secondaryLysisMixType,
          secondaryLysisMixRate,
          secondaryLysisMixTime,
          secondaryNumberOfLysisMixes,
          secondaryLysisMixTemperature,
          secondaryLysisTime,
          secondaryLysisTemperature,
          tertiaryLysisSolution,
          tertiaryLysisMixType,
          tertiaryLysisMixRate,
          tertiaryLysisMixTime,
          tertiaryNumberOfLysisMixes,
          tertiaryLysisMixTemperature,
          tertiaryLysisTime,
          tertiaryLysisTemperature,
          clarifyLysateIntensity,
          clarifyLysateTime,
          lysisAliquotContainer,
          clarifiedLysateContainer,
          clarifiedLysateContainerLabel,
          (*NOTE:No other lysing options need to be covered in the MapThread because the are not included in methods and have resolution (rather than a default value).*)

          (* Neutralization *)
          neutralize,
          neutralizationSeparationTechnique,
          neutralizationReagent,
          neutralizationReagentVolume,
          neutralizationReagentTemperature,
          neutralizationReagentEquilibrationTime,
          resolvedNeutralizationMixOptions,
          neutralizationMixType,
          neutralizationMixTemperature,
          neutralizationMixInstrument,
          neutralizationMixRate,
          neutralizationMixTime,
          numberOfNeutralizationMixes,
          neutralizationMixVolume,
          neutralizationSettlingInstrument,
          neutralizationSettlingTemperature,
          neutralizationSettlingTime,
          neutralizationFiltrationTechnique,
          neutralizationFiltrationInstrument,
          neutralizationFilter,
          neutralizationPoreSize,
          neutralizationMembraneMaterial,
          neutralizationFilterPosition,
          neutralizationFilterCentrifugeIntensity,
          neutralizationFiltrationPressure,
          neutralizationFiltrationTime,
          neutralizationFilterStorageCondition,
          neutralizationPelletVolume,
          neutralizationPelletInstrument,
          neutralizationPelletCentrifugeIntensity,
          neutralizationPelletCentrifugeTime,
          neutralizedSupernatantTransferVolume,
          neutralizedPelletStorageCondition,
          neutralizedPelletLabel,
          neutralizedPelletContainerLabel,
          neutralizedSolutionLabel,
          neutralizedSolutionContainer,
          neutralizedSolutionContainerLabel,

          (* Purification *)
          purification

        },

        (* Setup a boolean to determine if there is a method set or not. *)
        methodSpecifiedQ = MatchQ[Lookup[options, Method], ObjectP[Object[Method, Extraction, PlasmidDNA]]];


        (* --- MASTERSWITCH RESOLUTIONS --- *)

        (*Resolve the Lyse option.*)
        lyse = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, Lyse], Except[Automatic]],
            Lookup[options, Lyse],
          (*Sets Lyse to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, Lyse, Null], Except[Null]],
            Lookup[methodPacket, Lyse],
          (*Sets Lyse to True if any other lysing options are set (neither Null nor Automatic) or if cells are living.*)
          Or[
            (*Check if any lysing options are set (neither Null nor Automatic).*)
            MemberQ[
              Map[
                MatchQ[Lookup[options, #], Except[Null | Automatic]]&,
                Cases[$LysisSharedOptions, Except[TargetCellularComponent | NumberOfLysisReplicates]]
              ],
              True
            ],
            (*Check if samples are living.*)
            MatchQ[Lookup[samplePacket, Living], True]
          ],
            True,
          (*If no lysing options set and cells are dead (Living->False), then no lysing required.*)
          True,
            False
        ];

        (*Resolve the Neutralize option.*)
        neutralize = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, Neutralize], Except[Automatic]],
            Lookup[options, Neutralize],
          (*Sets Neutralize to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, Neutralize, Null], Except[Null]],
            Lookup[methodPacket, Neutralize],
          (*Sets Neutralize to True if any other neutralization options are set (neither Null nor Automatic) or if the sample is a lysate (which is often neutralized in plasmid DNA extraction).*)
          Or[
            (*Check if lyse is true.*)
            MatchQ[lyse, True],
            (*Check to see if the sample is not living, but has a cell type, indicating that the sample is a lysate.*)
            And[
              MatchQ[Lookup[samplePacket, Living], False],
              MatchQ[Lookup[samplePacket, CellType], Except[Null]]
            ],
            (*Check to see if the sample contains a Model[Lysate] indicating that the sample is a lysate.*)
            MemberQ[
              {Lookup[samplePacket, Composition][[All, 2]], Lookup[samplePacket, Model]},
              ObjectP[Model[Lysate]],
              2
            ],
            (*Check if any other neutralization options set.*)
            MemberQ[
              Map[
                MatchQ[Lookup[options, #], Except[Null | Automatic]]&,
                {NeutralizationSeparationTechnique, NeutralizationReagent, NeutralizationReagentVolume, NeutralizationReagentTemperature, NeutralizationReagentEquilibrationTime, NeutralizationMixType, NeutralizationMixTemperature, NeutralizationMixInstrument, NeutralizationMixRate, NeutralizationMixTime, NumberOfNeutralizationMixes, NeutralizationMixVolume, NeutralizationSettlingInstrument, NeutralizationSettlingTemperature, NeutralizationSettlingTime, NeutralizationFiltrationTechnique, NeutralizationFiltrationInstrument, NeutralizationFilter, NeutralizationPoreSize, NeutralizationMembraneMaterial, NeutralizationFilterPosition, NeutralizationFilterCentrifugeIntensity, NeutralizationFiltrationPressure, NeutralizationFiltrationTime, NeutralizationFilterStorageCondition, NeutralizationPelletInstrument, NeutralizationPelletCentrifugeIntensity, NeutralizationPelletCentrifugeTime, NeutralizedSupernatantTransferVolume, NeutralizedPelletStorageCondition, NeutralizedPelletLabel, NeutralizedPelletContainerLabel}
              ],
              True
            ]
          ],
            True,
          (*If no other neutralization options are set and cells aren't living or lysate, neutralization not required, so set to False.*)
          True,
            False
        ];

        (* Resolve the Purification option. *)
        (* NOTE: This is resolved later, however we need this info to determine where to integrate ContainerOut, so *)
        (* it's also resolved here to be used locally in the mapthread.*)
        purification = Which[
          (* Is the purification options already specified by the user? *)
          MatchQ[Lookup[options, Purification], Except[Automatic]],
            Lookup[options, Purification],
          (*Sets Purification to the value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, Purification, Null], Except[Null]],
            Lookup[methodPacket, Purification],
          (* Are any LLE, Precipitation, SPE, or MBS options set? If not, then defaults to LLE followed by Precipitation. *)
          !Or @@ (
            MemberQ[ToList[Lookup[options, #, Null]], Except[Automatic | Null | False | {Automatic, Automatic}]]
                &) /@ Keys[Join[$LLEPurificationOptionMap, $PrecipitationSharedOptionMap, $SPEPurificationOptionMap, $MBSPurificationOptionMap]],
            {LiquidLiquidExtraction, Precipitation},
          True,
            {
              (* Are any of the LLE options set? *)
              Module[{lleSpecifiedQ},
                lleSpecifiedQ = Or @@ (
                  MemberQ[ToList[Lookup[options, #, Null]], Except[Automatic | Null | False | {Automatic, Automatic}]]
                      &) /@ Keys[$LLEPurificationOptionMap];

                If[lleSpecifiedQ,
                  LiquidLiquidExtraction,
                  Nothing
                ]
              ],
              (* Are any of the Precipitation options set? *)
              Module[{precipitationSpecifiedQ},
                precipitationSpecifiedQ = Or @@ (
                  MemberQ[ToList[Lookup[options, #, Null]], Except[Automatic | Null | False | {Automatic, Automatic}]]
                      &) /@ Keys[$PrecipitationSharedOptionMap];

                If[precipitationSpecifiedQ,
                  Precipitation,
                  Nothing
                ]
              ],
              (* Are any of the SPE options set? *)
              Module[{speSpecifiedQ},
                speSpecifiedQ = Or @@ (
                  MemberQ[ToList[Lookup[options, #, Null]], Except[Automatic | Null | False | {Automatic, Automatic}]]
                      &) /@ Keys[$SPEPurificationOptionMap];

                If[speSpecifiedQ,
                  SolidPhaseExtraction,
                  Nothing
                ]
              ],
              (* Are any of the MBS options set? *)
              Module[{mbsSpecifiedQ},
                mbsSpecifiedQ = Or @@ (
                  MemberQ[ToList[Lookup[options, #, Null]], Except[Automatic | Null | False | {Automatic, Automatic}]]
                      &) /@ Keys[$MBSPurificationOptionMap];

                If[mbsSpecifiedQ,
                  MagneticBeadSeparation,
                  Nothing
                ]
              ]
            }
        ];

        (* --- LYSIS OPTION RESOLUTIONS --- *)

        lysisTime = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, LysisTime], Except[Automatic]],
            Lookup[options, LysisTime],
          (*Sets LysisTime to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, LysisTime, Null], Except[Null]],
            Lookup[methodPacket, LysisTime],
          (*If the sample will not be lysed, then LysisTime is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (*If the sample will be lysed and LysisTime is Automatic, then is set to the default.*)
          True,
            15 Minute
        ];

        lysisTemperature = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, LysisTemperature], Except[Automatic]],
            Lookup[options, LysisTemperature],
          (*Sets LysisTemperature to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, LysisTemperature, Null], Except[Null]],
            Lookup[methodPacket, LysisTemperature],
          (*If the sample will not be lysed, then LysisTemperature is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (*If the sample will be lysed and LysisTemperature is Automatic, then is set to the default.*)
          True,
            Ambient
        ];

        (* Resolve LysisAliquot switch. *)
        lysisAliquot = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, LysisAliquot], BooleanP],
            Lookup[options, LysisAliquot],
          (*If the sample will not be lysed, then LysisTemperature is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Set LysisAliquot to True if any of LysisAliquotAmount, LysisAliquotContainer, TargetCellCount or TargetCellConcentration are specified *)
          MemberQ[Lookup[options, {LysisAliquotAmount, LysisAliquotContainer, TargetCellCount, TargetCellConcentration}], Except[Null | Automatic]],
            True,
          (* Otherwise, set to False *)
          True,
            False
        ];

        clarifyLysateBool = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, ClarifyLysate], BooleanP],
            Lookup[options, ClarifyLysate],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, ClarifyLysate, Null], Except[Null]],
            Lookup[methodPacket, ClarifyLysate],
          (*If the sample will not be lysed, then LysisTemperature is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Set to True if any of the dependent options are set *)
          MemberQ[Lookup[options, {ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, ClarifiedLysateContainer, PostClarificationPelletStorageCondition}], Except[Null | Automatic]],
            True,
          (* Otherwise, this is False *)
          True,
            False
        ];

        lysisAliquotContainer = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, LysisAliquotContainer], Except[Automatic]],
            Lookup[options, LysisAliquotContainer],
          (*If the sample will not be lysed, then LysisTemperature is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (*If the sample will be lysed and nothing else and the sample will be aliquotted but not clarified, then set to the ContainerOut.*)
          MatchQ[lyse, True] && MatchQ[{neutralize, purification}, {False, None}] && MatchQ[{lysisAliquot, clarifyLysateBool}, {True, False}],
            Lookup[options, ContainerOut],
          (*Otherwise, should be resolved by ExperimentLyseCells.*)
          True,
            Automatic
        ];

        cellType = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, CellType], Except[Automatic]],
            Lookup[options, CellType],
          (*Sets CellType to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, CellType, Null], Except[Null]],
            Lookup[methodPacket, CellType],
          (*If the sample will not be lysed, then CellType is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        numberOfLysisSteps = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NumberOfLysisSteps], Except[Automatic]],
            Lookup[options, NumberOfLysisSteps],
          (*Sets NumberOfLysisSteps to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NumberOfLysisSteps, Null], Except[Null]],
            Lookup[methodPacket, NumberOfLysisSteps],
          (*If the sample will not be lysed, then NumberOfLysisSteps is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        preLysisPellet = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, PreLysisPellet], Except[Automatic]],
            Lookup[options, PreLysisPellet],
          (*Sets PreLysisPellet to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, PreLysisPellet, Null], Except[Null]],
            Lookup[methodPacket, PreLysisPellet],
          (*If the sample will not be lysed, then PreLysisPellet is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        preLysisPelletingIntensity = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, PreLysisPelletingIntensity], Except[Automatic]],
            Lookup[options, PreLysisPelletingIntensity],
          (*Sets PreLysisPelletingIntensity to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, PreLysisPelletingIntensity, Null], Except[Null]],
            Lookup[methodPacket, PreLysisPelletingIntensity],
          (*If the sample will not be lysed, then PreLysisPelletingIntensity is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        preLysisPelletingTime = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, PreLysisPelletingTime], Except[Automatic]],
            Lookup[options, PreLysisPelletingTime],
          (*Sets PreLysisPelletingTime to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, PreLysisPelletingTime, Null], Except[Null]],
            Lookup[methodPacket, PreLysisPelletingTime],
          (*If the sample will not be lysed, then PreLysisPelletingTime is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        lysisSolution = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, LysisSolution], Except[Automatic]],
            Lookup[options, LysisSolution],
          (*Sets LysisSolution to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, LysisSolution, Null], Except[Null]],
            Lookup[methodPacket, LysisSolution],
          (*If the sample will not be lysed, then LysisSolution is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        lysisMixType = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, LysisMixType], Except[Automatic]],
            Lookup[options, LysisMixType],
          (*Sets LysisMixType to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, LysisMixType, Null], Except[Null]],
            Lookup[methodPacket, LysisMixType],
          (*If the sample will not be lysed, then LysisMixType is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        lysisMixRate = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, LysisMixRate], Except[Automatic]],
            Lookup[options, LysisMixRate],
          (*Sets LysisMixRate to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, LysisMixRate, Null], Except[Null]],
            Lookup[methodPacket, LysisMixRate],
          (*If the sample will not be lysed, then LysisMixRate is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        lysisMixTime = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, LysisMixTime], Except[Automatic]],
            Lookup[options, LysisMixTime],
          (*Sets LysisMixTime to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, LysisMixTime, Null], Except[Null]],
            Lookup[methodPacket, LysisMixTime],
          (*If the sample will not be lysed, then LysisMixTime is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        numberOfLysisMixes = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NumberOfLysisMixes], Except[Automatic]],
            Lookup[options, NumberOfLysisMixes],
          (*Sets NumberOfLysisMixes to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NumberOfLysisMixes, Null], Except[Null]],
            Lookup[methodPacket, NumberOfLysisMixes],
          (*If the sample will not be lysed, then NumberOfLysisMixes is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        lysisMixTemperature = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, LysisMixTemperature], Except[Automatic]],
            Lookup[options, LysisMixTemperature],
          (*Sets LysisMixTemperature to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, LysisMixTemperature, Null], Except[Null]],
            Lookup[methodPacket, LysisMixTemperature],
          (*If the sample will not be lysed, then LysisMixTemperature is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        secondaryLysisSolution = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, SecondaryLysisSolution], Except[Automatic]],
            Lookup[options, SecondaryLysisSolution],
          (*Sets SecondaryLysisSolution to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, SecondaryLysisSolution, Null], Except[Null]],
            Lookup[methodPacket, SecondaryLysisSolution],
          (*If the sample will not be lysed, then SecondaryLysisSolution is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        secondaryLysisMixType = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, SecondaryLysisMixType], Except[Automatic]],
            Lookup[options, SecondaryLysisMixType],
          (*Sets SecondaryLysisMixType to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, SecondaryLysisMixType, Null], Except[Null]],
            Lookup[methodPacket, SecondaryLysisMixType],
          (*If the sample will not be lysed, then SecondaryLysisMixType is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        secondaryLysisMixRate = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, SecondaryLysisMixRate], Except[Automatic]],
            Lookup[options, SecondaryLysisMixRate],
          (*Sets SecondaryLysisMixRate to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, SecondaryLysisMixRate, Null], Except[Null]],
            Lookup[methodPacket, SecondaryLysisMixRate],
          (*If the sample will not be lysed, then SecondaryLysisMixRate is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        secondaryLysisMixTime = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, SecondaryLysisMixTime], Except[Automatic]],
            Lookup[options, SecondaryLysisMixTime],
          (*Sets SecondaryLysisMixTime to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, SecondaryLysisMixTime, Null], Except[Null]],
            Lookup[methodPacket, SecondaryLysisMixTime],
          (*If the sample will not be lysed, then SecondaryLysisMixTime is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        secondaryNumberOfLysisMixes = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, SecondaryNumberOfLysisMixes], Except[Automatic]],
            Lookup[options, SecondaryNumberOfLysisMixes],
          (*Sets SecondaryNumberOfLysisMixes to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, SecondaryNumberOfLysisMixes, Null], Except[Null]],
            Lookup[methodPacket, SecondaryNumberOfLysisMixes],
          (*If the sample will not be lysed, then SecondaryNumberOfLysisMixes is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        secondaryLysisMixTemperature = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, SecondaryLysisMixTemperature], Except[Automatic]],
            Lookup[options, SecondaryLysisMixTemperature],
          (*Sets SecondaryLysisMixTemperature to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, SecondaryLysisMixTemperature, Null], Except[Null]],
            Lookup[methodPacket, SecondaryLysisMixTemperature],
          (*If the sample will not be lysed, then SecondaryLysisMixTemperature is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        secondaryLysisTime = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, SecondaryLysisTime], Except[Automatic]],
            Lookup[options, SecondaryLysisTime],
          (*Sets SecondaryLysisTime to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, SecondaryLysisTime, Null], Except[Null]],
            Lookup[methodPacket, SecondaryLysisTime],
          (*If the sample will not be lysed, then SecondaryLysisTime is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        secondaryLysisTemperature = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, SecondaryLysisTemperature], Except[Automatic]],
            Lookup[options, SecondaryLysisTemperature],
          (*Sets SecondaryLysisTemperature to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, SecondaryLysisTemperature, Null], Except[Null]],
            Lookup[methodPacket, SecondaryLysisTemperature],
          (*If the sample will not be lysed, then SecondaryLysisTemperature is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        tertiaryLysisSolution = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, TertiaryLysisSolution], Except[Automatic]],
            Lookup[options, TertiaryLysisSolution],
          (*Sets TertiaryLysisSolution to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, TertiaryLysisSolution, Null], Except[Null]],
            Lookup[methodPacket, TertiaryLysisSolution],
          (*If the sample will not be lysed, then TertiaryLysisSolution is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        tertiaryLysisMixType = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, TertiaryLysisMixType], Except[Automatic]],
            Lookup[options, TertiaryLysisMixType],
          (*Sets TertiaryLysisMixType to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, TertiaryLysisMixType, Null], Except[Null]],
            Lookup[methodPacket, TertiaryLysisMixType],
          (*If the sample will not be lysed, then TertiaryLysisMixType is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        tertiaryLysisMixRate = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, TertiaryLysisMixRate], Except[Automatic]],
            Lookup[options, TertiaryLysisMixRate],
          (*Sets TertiaryLysisMixRate to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, TertiaryLysisMixRate, Null], Except[Null]],
            Lookup[methodPacket, TertiaryLysisMixRate],
          (*If the sample will not be lysed, then TertiaryLysisMixRate is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        tertiaryLysisMixTime = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, TertiaryLysisMixTime], Except[Automatic]],
            Lookup[options, TertiaryLysisMixTime],
          (*Sets TertiaryLysisMixTime to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, TertiaryLysisMixTime, Null], Except[Null]],
            Lookup[methodPacket, TertiaryLysisMixTime],
          (*If the sample will not be lysed, then TertiaryLysisMixTime is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        tertiaryNumberOfLysisMixes = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, TertiaryNumberOfLysisMixes], Except[Automatic]],
            Lookup[options, TertiaryNumberOfLysisMixes],
          (*Sets TertiaryNumberOfLysisMixes to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, TertiaryNumberOfLysisMixes, Null], Except[Null]],
            Lookup[methodPacket, TertiaryNumberOfLysisMixes],
          (*If the sample will not be lysed, then TertiaryNumberOfLysisMixes is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        tertiaryLysisMixTemperature = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, TertiaryLysisMixTemperature], Except[Automatic]],
            Lookup[options, TertiaryLysisMixTemperature],
          (*Sets TertiaryLysisMixTemperature to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, TertiaryLysisMixTemperature, Null], Except[Null]],
            Lookup[methodPacket, TertiaryLysisMixTemperature],
          (*If the sample will not be lysed, then TertiaryLysisMixTemperature is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        tertiaryLysisTime = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, TertiaryLysisTime], Except[Automatic]],
            Lookup[options, TertiaryLysisTime],
          (*Sets TertiaryLysisTime to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, TertiaryLysisTime, Null], Except[Null]],
            Lookup[methodPacket, TertiaryLysisTime],
          (*If the sample will not be lysed, then TertiaryLysisTime is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        tertiaryLysisTemperature = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, TertiaryLysisTemperature], Except[Automatic]],
            Lookup[options, TertiaryLysisTemperature],
          (*Sets TertiaryLysisTemperature to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, TertiaryLysisTemperature, Null], Except[Null]],
            Lookup[methodPacket, TertiaryLysisTemperature],
          (*If the sample will not be lysed, then TertiaryLysisTemperature is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        clarifyLysateIntensity = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, ClarifyLysateIntensity], Except[Automatic]],
            Lookup[options, ClarifyLysateIntensity],
          (*Sets ClarifyLysateIntensity to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, ClarifyLysateIntensity, Null], Except[Null]],
            Lookup[methodPacket, ClarifyLysateIntensity],
          (*If the sample will not be lysed, then ClarifyLysateIntensity is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        clarifyLysateTime = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, ClarifyLysateTime], Except[Automatic]],
            Lookup[options, ClarifyLysateTime],
          (*Sets ClarifyLysateTime to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, ClarifyLysateTime, Null], Except[Null]],
            Lookup[methodPacket, ClarifyLysateTime],
          (*If the sample will not be lysed, then ClarifyLysateTime is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
          True,
            Automatic
        ];

        clarifiedLysateContainer = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, ClarifiedLysateContainer], Except[Automatic]],
            Lookup[options, ClarifiedLysateContainer],
          (*If the sample will not be lysed, then LysisTemperature is set to Null.*)
          MatchQ[lyse, False],
            Null,
          (*If the sample will be lysed and nothing else and the sample will clarified, then set to the ContainerOut.*)
          MatchQ[lyse, True] && MatchQ[{neutralize, purification}, {False, None}] && MatchQ[clarifyLysateBool, True],
            Lookup[options, ContainerOut],
          (*Otherwise, should be resolved by ExperimentLyseCells.*)
          True,
            Automatic
        ];

        clarifiedLysateContainerLabel = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, ClarifiedLysateContainerLabel], Except[Automatic]],
            Lookup[options, ClarifiedLysateContainerLabel],
          (*If the sample will be lysed and nothing else and the sample will clarified, then set to the ContainerOutLabel.*)
          MatchQ[lyse, True] && MatchQ[{neutralize, purification}, {False, None}] && MatchQ[clarifyLysateBool, True],
            Lookup[options, ExtractedPlasmidDNAContainerLabel],
          (*Otherwise, should be resolved by ExperimentLyseCells.*)
          True,
            Automatic
        ];

        (* --- NEUTRALIZATION OPTION RESOLUTIONS --- *)

        (*Resolve the NeutralizationSeparationTechnique option.*)
        neutralizationSeparationTechnique = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationSeparationTechnique], Except[Automatic | Null]],
            Lookup[options, NeutralizationSeparationTechnique],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationSeparationTechnique, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationSeparationTechnique],
          (*If Neutralize is False, then no need to set to value since step isn't being used.*)
          MatchQ[neutralize, False],
            Null,
          (*Set to Filter if any neutralization filter options are set.*)
          MemberQ[
            Map[
              MatchQ[Lookup[options, #], Except[Automatic | Null]]&,
              {NeutralizationFiltrationTechnique, NeutralizationFiltrationInstrument, NeutralizationFilter, NeutralizationPoreSize, NeutralizationMembraneMaterial, NeutralizationFilterPosition, NeutralizationFilterCentrifugeIntensity, NeutralizationFiltrationPressure, NeutralizationFiltrationTime, NeutralizationFilterStorageCondition}
            ],
            True
          ],
            Filter,
          (*If no neutralization filter options are set, then defaults to Pellet.*)
          True,
            Pellet
        ];

        (*Resolve the NeutralizationReagent option.*)
        neutralizationReagent = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationReagent], Except[Automatic | Null]],
            Lookup[options, NeutralizationReagent],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationReagent, Null], Except[Null]],
            Download[Lookup[methodPacket, NeutralizationReagent], Object],
          (*If Neutralize is False, then no need to set to value since step isn't being used.*)
          MatchQ[neutralize, False],
            Null,
          (*If no neutralization reagent options are set, then defaults to sodium acetate solution.*)
          True,
            Model[Sample, StockSolution, "id:Vrbp1jKWrmjW"] (*Model[Sample, StockSolution, "3M Sodium Acetate"]*)
        ];

        (*Resolve (or pre-resolve) the NeutralizationReagentVolume option.*)
        neutralizationReagentVolume = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationReagentVolume], Except[Automatic | Null]],
            Lookup[options, NeutralizationReagentVolume],
          (*If Neutralize is False, then no need to set to value since step isn't being used.*)
          MatchQ[neutralize, False],
            Null,
          (*If the neutralization reagent volume option is not set, then set to automatic and will be resolved by ExperimentPrecipitate later.*)
          True,
            Automatic
        ];

        (*Resolve the NeutralizationReagentTemperature option.*)
        neutralizationReagentTemperature = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationReagentTemperature], Except[Automatic | Null]],
            Lookup[options, NeutralizationReagentTemperature],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationReagentTemperature, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationReagentTemperature],
          (*If Neutralize is False, then no need to set to value since step isn't being used.*)
          MatchQ[neutralize, False],
            Null,
          (*If the neutralization reagent temperature option is not set, then set to Ambient by default.*)
          True,
            Ambient
        ];

        (*Resolve the NeutralizationReagentEquilibrationTime option.*)
        neutralizationReagentEquilibrationTime = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationReagentEquilibrationTime], Except[Automatic | Null]],
            Lookup[options, NeutralizationReagentEquilibrationTime],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationReagentEquilibrationTime, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationReagentEquilibrationTime],
          (*If Neutralize is False, then no need to set to value since step isn't being used.*)
          MatchQ[neutralize, False],
            Null,
          (*If the neutralization reagent equilibration time option is not set, then set to 5 minutes by default.*)
          True,
            5 * Minute
        ];

        (* Resolve the neutralization mix options.*)
        resolvedNeutralizationMixOptions = preResolveExtractMixOptions[
          options,
          methodPacket,
          neutralize,
          {
            MixType -> NeutralizationMixType,
            MixTemperature -> NeutralizationMixTemperature,
            MixInstrument -> NeutralizationMixInstrument,
            MixRate -> NeutralizationMixRate,
            MixTime -> NeutralizationMixTime,
            NumberOfMixes -> NumberOfNeutralizationMixes,
            MixVolume -> NeutralizationMixVolume
          },
          DefaultMixType -> None,
          DefaultMixTemperature -> Ambient,
          DefaultMixRate -> 300 RPM,
          DefaultMixTime -> 15 * Minute,
          DefaultNumberOfMixes -> 10
        ];

        (*Assign the resolved liquid-liquid extraction mix options to their local variables.*)
        {
          neutralizationMixType,
          neutralizationMixTemperature,
          neutralizationMixInstrument,
          neutralizationMixRate,
          neutralizationMixTime,
          numberOfNeutralizationMixes,
          neutralizationMixVolume
        } = Map[
          Lookup[resolvedNeutralizationMixOptions, #]&,
          {
            NeutralizationMixType,
            NeutralizationMixTemperature,
            NeutralizationMixInstrument,
            NeutralizationMixRate,
            NeutralizationMixTime,
            NumberOfNeutralizationMixes,
            NeutralizationMixVolume
          }
        ];

        (*Resolve the NeutralizationSettlingTime option.*)
        neutralizationSettlingTime = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationSettlingTime], Except[Automatic | Null]],
            Lookup[options, NeutralizationSettlingTime],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationSettlingTime, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationSettlingTime],
          (*If Neutralize is False, then no need to set to value since neutralization is not being used.*)
          MatchQ[neutralize, False],
            Null,
          (*Otherwise, set to 15 minutes by default.*)
          True,
            15 * Minute
        ];

        (*Resolve the NeutralizationSettlingInstrument option.*)
        neutralizationSettlingInstrument = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationSettlingInstrument], Except[Automatic | Null]],
            Lookup[options, NeutralizationSettlingInstrument],
          (*If Neutralize is False or the NeutralizationSettlingTime is 0 Minute (no settling), then no need to set to value since neutralization or settling are not being used.*)
          Or[
            MatchQ[neutralize, False],
            EqualQ[neutralizationSettlingTime, 0 * Minute]
          ],
            Null,
          (*If the neutralization settling time option is greater than 0 minutes, then set to the Hamilton Heater Cooler HeatBlock by default.*)
          True,
            Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"] (*Model[Instrument, HeatBlock, "Hamilton Heater Cooler"]*)
        ];

        (*Resolve the NeutralizationSettlingTemperature option.*)
        neutralizationSettlingTemperature = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationSettlingTemperature], Except[Automatic | Null]],
            Lookup[options, NeutralizationSettlingTemperature],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationSettlingTemperature, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationSettlingTemperature],
          (*If Neutralize is False or the NeutralizationSettlingTime is 0 Minute (no settling), then no need to set to value since neutralization or settling aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            EqualQ[neutralizationSettlingTime, 0 * Minute]
          ],
            Null,
          (*Otherwise, set to Ambient by default.*)
          True,
            Ambient
        ];

        (*Resolve the NeutralizationFiltrationTechnique option.*)
        neutralizationFiltrationTechnique = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationFiltrationTechnique], Except[Automatic | Null]],
            Lookup[options, NeutralizationFiltrationTechnique],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationFiltrationTechnique, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationFiltrationTechnique],
          (*If Neutralize is False or the NeutralizationSeparationTechnique is Pellet, then no need to set to value since neutralization or filtration aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Pellet]
          ],
            Null,
          (*Otherwise, set to AirPressure by default.*)
          True,
            AirPressure
        ];

        (*Resolve the NeutralizationFiltrationInstrument option.*)
        neutralizationFiltrationInstrument = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationFiltrationInstrument], Except[Automatic | Null]],
            Lookup[options, NeutralizationFiltrationInstrument],
          (*If Neutralize is False or the NeutralizationSeparationTechnique is Pellet, then no need to set to value since neutralization or filtration aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Pellet]
          ],
            Null,
          (*If the filtration technique is centrifuge, selects the centrifuge instrument in the workcell (the HiG4).*)
          MatchQ[neutralizationFiltrationTechnique, Centrifuge],
            Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (*Model[Instrument,Centrifuge,"HiG4"]*)
          (*Otherwise, set to the pressure manifold (MPE2) by default.*)
          True,
            Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"] (*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
        ];

        (*Resolve (or pre-resolve) the NeutralizationFilter option.*)
        neutralizationFilter = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationFilter], Except[Automatic | Null]],
            Lookup[options, NeutralizationFilter],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationFilter, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationFilter],
          (*If Neutralize is False or the NeutralizationSeparationTechnique is Pellet, then no need to set to value since neutralization or filtration aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Pellet]
          ],
            Null,
          (*Otherwise, set to Automatic to be resolved by the precipitation resolver later.*)
          True,
            Automatic
        ];

        (*Resolve (or pre-resolve) the NeutralizationPoreSize option.*)
        neutralizationPoreSize = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationPoreSize], Except[Automatic | Null]],
            Lookup[options, NeutralizationPoreSize],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationPoreSize, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationPoreSize],
          (*If Neutralize is False or the NeutralizationSeparationTechnique is Pellet, then no need to set to value since neutralization or filtration aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Pellet]
          ],
            Null,
          (*Otherwise, set to Automatic to be resolved by the precipitation resolver later.*)
          True,
            Automatic
        ];

        (*Resolve (or pre-resolve) the NeutralizationMembraneMaterial option.*)
        neutralizationMembraneMaterial = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationMembraneMaterial], Except[Automatic | Null]],
            Lookup[options, NeutralizationMembraneMaterial],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationMembraneMaterial, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationMembraneMaterial],
          (*If Neutralize is False or the NeutralizationSeparationTechnique is Pellet, then no need to set to value since neutralization or filtration aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Pellet]
          ],
            Null,
          (*Otherwise, set to Automatic to be resolved by the precipitation resolver later.*)
          True,
            Automatic
        ];

        (*Resolve (or pre-resolve) the NeutralizationFilterPosition option.*)
        neutralizationFilterPosition = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationFilterPosition], Except[Automatic | Null]],
            Lookup[options, NeutralizationFilterPosition],
          (*If Neutralize is False or the NeutralizationSeparationTechnique is Pellet, then no need to set to value since neutralization or filtration aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Pellet]
          ],
            Null,
          (*Otherwise, set to Automatic to be resolved by the precipitation resolver later.*)
          True,
            Automatic
        ];

        (*Resolve the NeutralizationFilterCentrifugeIntensity option.*)
        neutralizationFilterCentrifugeIntensity = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationFilterCentrifugeIntensity], Except[Automatic | Null]],
            Lookup[options, NeutralizationFilterCentrifugeIntensity],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationFilterCentrifugeIntensity, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationFilterCentrifugeIntensity],
          (*If Neutralize is False or the NeutralizationFilterTechnique is AirPressure, then no need to set to value since neutralization or centrifugation aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationFiltrationTechnique, AirPressure]
          ],
            Null,
          (*Otherwise, set to 3600 g.*)
          True,
            3600 * GravitationalAcceleration
        ];

        (*Resolve the NeutralizationFiltrationPressure option.*)
        neutralizationFiltrationPressure = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationFiltrationPressure], Except[Automatic | Null]],
            Lookup[options, NeutralizationFiltrationPressure],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationFiltrationPressure, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationFiltrationPressure],
          (*If Neutralize is False or the NeutralizationFilterTechnique is Centrifuge, then no need to set to value since neutralization or pressure aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationFiltrationTechnique, Centrifuge]
          ],
            Null,
          (*Otherwise, set to 40 PSI.*)
          True,
            40 * PSI
        ];

        (*Resolve the NeutralizationFiltrationTime option.*)
        neutralizationFiltrationTime = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationFiltrationTime], Except[Automatic | Null]],
            Lookup[options, NeutralizationFiltrationTime],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationFiltrationTime, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationFiltrationTime],
          (*If Neutralize is False or the NeutralizationSeparationTechnique is set to Pellet, then no need to set to value since neutralization or pressure aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Pellet]
          ],
            Null,
          (*Otherwise, set to 10 minutes.*)
          True,
            10 * Minute
        ];

        (*Resolve the NeutralizationFilterStorageCondition option.*)
        neutralizationFilterStorageCondition = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationFilterStorageCondition], Except[Automatic | Null]],
            Lookup[options, NeutralizationFilterStorageCondition],
          (*If Neutralize is False or the NeutralizationSeparationTechnique is set to Pellet, then no need to set to value since neutralization or pressure aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Pellet]
          ],
            Null,
          (*Otherwise, set to disposal by default.*)
          True,
            Disposal
        ];

        (*Resolve the NeutralizationPelletVolume option.*)
        neutralizationPelletVolume = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationPelletVolume], Except[Automatic | Null]],
            Lookup[options, NeutralizationPelletVolume],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationPelletVolume, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationPelletVolume],
          (*If Neutralize is False or the NeutralizationSeparationTechnique is set to Filter, then no need to set to value since neutralization or pelleting aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Filter]
          ],
            Null,
          (*Otherwise, set to 1*Microliter.*)
          True,
            1 * Microliter
        ];

        (*Resolve the NeutralizationPelletInstrument option.*)
        neutralizationPelletInstrument = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationPelletInstrument], Except[Automatic | Null]],
            Lookup[options, NeutralizationPelletInstrument],
          (*If Neutralize is False or the NeutralizationSeparationTechnique is set to Filter, then no need to set to value since neutralization or pelleting aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Filter]
          ],
            Null,
          (*Otherwise, set to the HiG4.*)
          True,
            Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"] (*Model[Instrument, Centrifuge, "HiG4"]*)
        ];

        (*Resolve the NeutralizationPelletCentrifugeIntensity option.*)
        neutralizationPelletCentrifugeIntensity = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationPelletCentrifugeIntensity], Except[Automatic | Null]],
            Lookup[options, NeutralizationPelletCentrifugeIntensity],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationPelletCentrifugeIntensity, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationPelletCentrifugeIntensity],
          (*If Neutralize is False or the NeutralizationSeparationTechnique is set to Filter, then no need to set to value since neutralization or pelleting aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Filter]
          ],
            Null,
          (*Otherwise, set to 3600 g.*)
          True,
            3600 * GravitationalAcceleration
        ];

        (*Resolve the NeutralizationPelletCentrifugeTime option.*)
        neutralizationPelletCentrifugeTime = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizationPelletCentrifugeTime], Except[Automatic | Null]],
            Lookup[options, NeutralizationPelletCentrifugeTime],
          (*Set to value specified in the Method object if selected.*)
          methodSpecifiedQ && MatchQ[Lookup[methodPacket, NeutralizationPelletCentrifugeTime, Null], Except[Null]],
            Lookup[methodPacket, NeutralizationPelletCentrifugeTime],
          (*If Neutralize is False or the NeutralizationSeparationTechnique is set to Filter, then no need to set to value since neutralization or pelleting aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Filter]
          ],
            Null,
          (*Otherwise, set to 10 minutes.*)
          True,
            10 * Minute
        ];

        (*Resolve (or pre-resolve) the NeutralizedSupernatantTransferVolume option.*)
        neutralizedSupernatantTransferVolume = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizedSupernatantTransferVolume], Except[Automatic | Null]],
            Lookup[options, NeutralizedSupernatantTransferVolume],
          (*If Neutralize is False or the NeutralizationSeparationTechnique is set to Filter, then no need to set to value since neutralization or pelleting aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Filter]
          ],
            Null,
          (*Otherwise, set to Automatic to be determined by ExperimentPrecipitate simulation and set to 90% of the neutralization solution.*)
          True,
            Automatic
        ];

        (*Resolve the NeutralizedPelletStorageCondition option.*)
        neutralizedPelletStorageCondition = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizedPelletStorageCondition], Except[Automatic | Null]],
            Lookup[options, NeutralizedPelletStorageCondition],
          (*If Neutralize is False or the NeutralizationSeparationTechnique is set to Filter, then no need to set to value since neutralization or pelleting aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Filter]
          ],
            Null,
          (*Otherwise, set to Disposal.*)
          True,
            Disposal
        ];

        (*Resolve (or pre-resolve) the NeutralizedPelletLabel option.*)
        neutralizedPelletLabel = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizedPelletLabel], Except[Automatic | Null]],
            Lookup[options, NeutralizedPelletLabel],
          (*If Neutralize is False, NeutralizationSeparationTechnique is set to Filter, or NeutralizedPelletStorageCondition is Disposal, then no need to set to value since neutralization or pelleting aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Filter],
            MatchQ[neutralizedPelletStorageCondition, Disposal]
          ],
            Null,
          (*Otherwise, generate a label for the neutralized pellet.*)
          True,
            CreateUniqueLabel["neutralized pellet", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]
        ];

        (*Resolve (or pre-resolve) the NeutralizedPelletContainerLabel option.*)
        neutralizedPelletContainerLabel = Which[
          (*If user-set, then use set value.*)
          MatchQ[Lookup[options, NeutralizedPelletContainerLabel], Except[Automatic | Null]],
            Lookup[options, NeutralizedPelletContainerLabel],
          (*If Neutralize is False, NeutralizationSeparationTechnique is set to Filter, or NeutralizedPelletStorageCondition is Disposal, then no need to set to value since neutralization or pelleting aren't being used.*)
          Or[
            MatchQ[neutralize, False],
            MatchQ[neutralizationSeparationTechnique, Filter],
            MatchQ[neutralizedPelletStorageCondition, Disposal]
          ],
            Null,
          (*Otherwise, set to Automatic to be resolved later.*)
          True,
            CreateUniqueLabel["neutralized pellet container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]
        ];

        neutralizedSolutionLabel = Which[
          (*If neutralization is the last step, then use the final sample label as the neutralization sample out label.*)
          MatchQ[neutralize, True] && MatchQ[Lookup[options, Purification], None],
            Lookup[options, ExtractedPlasmidDNALabel],
          (*Otherwise, set to Automatic and will be resolved by ExperimentPrecipitate.*)
          True,
            Automatic
        ];

        neutralizedSolutionContainer = Which[
          (*If neutralization is the last step, then use the container out as the neutralization container out.*)
          MatchQ[neutralize, True] && MatchQ[Lookup[options, Purification], None],
            Lookup[options, ContainerOut],
          (*Otherwise, set to Automatic and will be resolved by ExperimentPrecipitate.*)
          True,
            Automatic
        ];

        neutralizedSolutionContainerLabel = Which[
          (*If neutralization is the last step, then use the final container out label as the neutralization container out label.*)
          MatchQ[neutralize, True] && MatchQ[Lookup[options, Purification], None],
            Lookup[options, ExtractedPlasmidDNAContainerLabel],
          (*Otherwise, set to Automatic and will be resolved by ExperimentPrecipitate.*)
          True,
            Automatic
        ];


        {
          lyse,
          lysisTime,
          lysisTemperature,
          lysisAliquot,
          clarifyLysateBool,
          cellType,
          numberOfLysisSteps,
          preLysisPellet,
          preLysisPelletingIntensity,
          preLysisPelletingTime,
          lysisSolution,
          lysisMixType,
          lysisMixRate,
          lysisMixTime,
          numberOfLysisMixes,
          lysisMixTemperature,
          secondaryLysisSolution,
          secondaryLysisMixType,
          secondaryLysisMixRate,
          secondaryLysisMixTime,
          secondaryNumberOfLysisMixes,
          secondaryLysisMixTemperature,
          secondaryLysisTime,
          secondaryLysisTemperature,
          tertiaryLysisSolution,
          tertiaryLysisMixType,
          tertiaryLysisMixRate,
          tertiaryLysisMixTime,
          tertiaryNumberOfLysisMixes,
          tertiaryLysisMixTemperature,
          tertiaryLysisTime,
          tertiaryLysisTemperature,
          clarifyLysateIntensity,
          clarifyLysateTime,
          lysisAliquotContainer,
          clarifiedLysateContainer,
          clarifiedLysateContainerLabel,
          neutralize,
          neutralizationSeparationTechnique,
          neutralizationReagent,
          neutralizationReagentVolume,
          neutralizationReagentTemperature,
          neutralizationReagentEquilibrationTime,
          neutralizationMixType,
          neutralizationMixTemperature,
          neutralizationMixInstrument,
          neutralizationMixRate,
          neutralizationMixTime,
          numberOfNeutralizationMixes,
          neutralizationMixVolume,
          neutralizationSettlingInstrument,
          neutralizationSettlingTemperature,
          neutralizationSettlingTime,
          neutralizationFiltrationTechnique,
          neutralizationFiltrationInstrument,
          neutralizationFilter,
          neutralizationPoreSize,
          neutralizationMembraneMaterial,
          neutralizationFilterPosition,
          neutralizationFilterCentrifugeIntensity,
          neutralizationFiltrationPressure,
          neutralizationFiltrationTime,
          neutralizationFilterStorageCondition,
          neutralizationPelletVolume,
          neutralizationPelletInstrument,
          neutralizationPelletCentrifugeIntensity,
          neutralizationPelletCentrifugeTime,
          neutralizedSupernatantTransferVolume,
          neutralizedPelletStorageCondition,
          neutralizedPelletLabel,
          neutralizedPelletContainerLabel,
          neutralizedSolutionLabel,
          neutralizedSolutionContainer,
          neutralizedSolutionContainerLabel
        }

      ]
    ],
    {samplePackets, methodPackets, preResolvedMapThreadFriendlyOptions}
  ];

  (* -- RESOLVE LYSIS OPTIONS -- *)

  (*Gather a list of pre-resolved lysis options from the mapthread.*)
  preResolvedLysisOptions = {
    LysisTime -> resolvedLysisTime,
    LysisTemperature -> resolvedLysisTemperature,
    LysisAliquot -> resolvedLysisAliquot,
    ClarifyLysate -> resolvedClarifyLysateBool,
    CellType -> preResolvedCellType,
    NumberOfLysisSteps -> preResolvedNumberOfLysisSteps,
    PreLysisPellet -> preResolvedPreLysisPellet,
    PreLysisPelletingIntensity -> preResolvedPreLysisPelletingIntensity,
    PreLysisPelletingTime -> preResolvedPreLysisPelletingTime,
    LysisSolution -> preResolvedLysisSolution,
    LysisMixType -> preResolvedLysisMixType,
    LysisMixRate -> preResolvedLysisMixRate,
    LysisMixTime -> preResolvedLysisMixTime,
    NumberOfLysisMixes -> preResolvedNumberOfLysisMixes,
    LysisMixTemperature -> preResolvedLysisMixTemperature,
    SecondaryLysisSolution -> preResolvedSecondaryLysisSolution,
    SecondaryLysisMixType ->  preResolvedSecondaryLysisMixType,
    SecondaryLysisMixRate ->  preResolvedSecondaryLysisMixRate,
    SecondaryLysisMixTime -> preResolvedSecondaryLysisMixTime,
    SecondaryNumberOfLysisMixes -> preResolvedSecondaryNumberOfLysisMixes,
    SecondaryLysisMixTemperature -> preResolvedSecondaryLysisMixTemperature,
    SecondaryLysisTime -> preResolvedSecondaryLysisTime,
    SecondaryLysisTemperature -> preResolvedSecondaryLysisTemperature,
    TertiaryLysisSolution -> preResolvedTertiaryLysisSolution,
    TertiaryLysisMixType -> preResolvedTertiaryLysisMixType,
    TertiaryLysisMixRate -> preResolvedTertiaryLysisMixRate,
    TertiaryLysisMixTime -> preResolvedTertiaryLysisMixTime,
    TertiaryNumberOfLysisMixes -> preResolvedTertiaryNumberOfLysisMixes,
    TertiaryLysisMixTemperature -> preResolvedTertiaryLysisMixTemperature,
    TertiaryLysisTime -> preResolvedTertiaryLysisTime,
    TertiaryLysisTemperature -> preResolvedTertiaryLysisTemperature,
    ClarifyLysateIntensity -> preResolvedClarifyLysateIntensity,
    ClarifyLysateTime -> preResolvedClarifyLysateTime,
    LysisAliquotContainer -> preResolvedLysisAliquotContainer,
    ClarifiedLysateContainer -> preResolvedClarifiedLysateContainer,
    ClarifiedLysateContainerLabel -> preResolvedClarifiedLysateContainerLabel
  };

  (* -- RESOLVE NEUTRALIZATION OPTIONS -- *)

  (*Gather a list of pre-resolved neutralization options from the mapthread.*)
  neutralizationPreResolvedOptions = {
    WorkCell -> resolvedWorkCell,
    RoboticInstrument -> resolvedRoboticInstrument,
    NeutralizationSeparationTechnique -> preResolvedNeutralizationSeparationTechnique,
    NeutralizationReagent -> preResolvedNeutralizationReagent,
    NeutralizationReagentVolume -> preResolvedNeutralizationReagentVolume,
    NeutralizationReagentTemperature -> preResolvedNeutralizationReagentTemperature,
    NeutralizationReagentEquilibrationTime -> preResolvedNeutralizationReagentEquilibrationTime,
    NeutralizationMixType -> preResolvedNeutralizationMixType,
    NeutralizationMixTemperature -> preResolvedNeutralizationMixTemperature,
    NeutralizationMixInstrument -> preResolvedNeutralizationMixInstrument,
    NeutralizationMixRate -> preResolvedNeutralizationMixRate,
    NeutralizationMixTime -> preResolvedNeutralizationMixTime,
    NumberOfNeutralizationMixes -> preResolvedNumberOfNeutralizationMixes,
    NeutralizationMixVolume -> preResolvedNeutralizationMixVolume,
    NeutralizationSettlingInstrument -> preResolvedNeutralizationSettlingInstrument,
    NeutralizationSettlingTemperature -> preResolvedNeutralizationSettlingTemperature,
    NeutralizationSettlingTime -> preResolvedNeutralizationSettlingTime,
    NeutralizationFiltrationTechnique -> preResolvedNeutralizationFiltrationTechnique,
    NeutralizationFiltrationInstrument -> preResolvedNeutralizationFiltrationInstrument,
    NeutralizationFilter -> preResolvedNeutralizationFilter,
    NeutralizationPoreSize -> preResolvedNeutralizationPoreSize,
    NeutralizationMembraneMaterial -> preResolvedNeutralizationMembraneMaterial,
    NeutralizationFilterPosition -> preResolvedNeutralizationFilterPosition,
    NeutralizationFilterCentrifugeIntensity -> preResolvedNeutralizationFilterCentrifugeIntensity,
    NeutralizationFiltrationPressure -> preResolvedNeutralizationFiltrationPressure,
    NeutralizationFiltrationTime -> preResolvedNeutralizationFiltrationTime,
    NeutralizationFilterStorageCondition -> preResolvedNeutralizationFilterStorageCondition,
    NeutralizationPelletVolume -> preResolvedNeutralizationPelletVolume,
    NeutralizationPelletInstrument -> preResolvedNeutralizationPelletInstrument,
    NeutralizationPelletCentrifugeIntensity -> preResolvedNeutralizationPelletCentrifugeIntensity,
    NeutralizationPelletCentrifugeTime -> preResolvedNeutralizationPelletCentrifugeTime,
    NeutralizedSupernatantTransferVolume -> preResolvedNeutralizedSupernatantTransferVolume,
    NeutralizedPelletStorageCondition -> preResolvedNeutralizedPelletStorageCondition,
    NeutralizedPelletLabel -> preResolvedNeutralizedPelletLabel,
    NeutralizedPelletContainerLabel -> preResolvedNeutralizedPelletContainerLabel
  };

  (* Pre-resolve purification options in the general biology purification option pre-resolver. *)
  preResolvedPurificationOptions = preResolvePurificationSharedOptions[mySamples, Normal[preResolvedRoundedExperimentOptions, Association], preResolvedMapThreadFriendlyOptions, TargetCellularComponent -> ConstantArray[PlasmidDNA, Length[mySamples]]];

  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

  (* Overwrite our rounded options with our resolved options.*)
  preResolvedOptions = ReplaceRule[
    Normal[preResolvedRoundedExperimentOptions, Association],
    Flatten[{
      (*General Options*)
      RoboticInstrument -> resolvedRoboticInstrument,
      WorkCell -> resolvedWorkCell,
      (*Lysis, Neutralization, and Purification Options*)
      Lyse -> resolvedLyse,
      Neutralize -> resolvedNeutralize,
      Purification -> resolvedPurification,
      ExtractedPlasmidDNALabel -> resolvedExtractedPlasmidDNALabel,
      ExtractedPlasmidDNAContainerLabel -> preResolvedExtractedPlasmidDNAContainerLabel,
      ContainerOutWell -> preResolvedContainerOutWell,
      IndexedContainerOut -> preResolvedIndexedContainerOut,
      preResolvedLysisOptions,
      neutralizationPreResolvedOptions,
      resolvedPostProcessingOptions,
      preResolvedPurificationOptions
    }]
  ];

  (* - FINAL ERRORS AND ASSIGNMENTS - *)

  (*Check that LLE, Precipitation, SPE, and MBS have all options set to Null if not called in Purification.*)
  {methodValidityTest, invalidExtractionMethodOptions} = extractionMethodValidityTest[
    mySamples,
    preResolvedOptions,
    gatherTests,
    Cache -> cacheBall
  ];

  (*Check that all of the SPE options work*)
  {solidPhaseExtractionConflictingOptionsTests, solidPhaseExtractionConflictingOptions} = solidPhaseExtractionConflictingOptionsChecks[
    mySamples,
    preResolvedOptions,
    gatherTests,
    Cache -> cacheBall
  ];

  (*Check that the non-index matching shared MBS options SelectionStrategy and SeparationMode are not different by methods or user-method conflict*)
  {mbsMethodsConflictingOptionsTest, mbsMethodsConflictingOptions} = mbsMethodsConflictingOptionsTests[
    mySamples,
    preResolvedOptions,
    gatherTests,
    Cache -> cacheBall
  ];

  (*Make sure there are not more than 3 of each type of purification in the purification option.*)
  {purificationTests, purificationInvalidOptions} = purificationSharedOptionsTests[
    mySamples,
    samplePackets,
    preResolvedOptions,
    gatherTests,
    Cache -> cacheBall
  ];

  (* -- INVALID INPUT CHECK -- *)

  (*Gather a list of all invalid inputs from all invalid input tests.*)
  invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs, deprecatedInvalidInputs, solidMediaInvalidInputs}]];

  (*Throw Error::InvalidInput if there are any invalid inputs.*)
  If[!gatherTests && Length[invalidInputs] > 0,
    Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
  ];

  (* -- INVALID OPTIONS CHECK -- *)

  (* Convert our options into a MapThread friendly version. *)
  optionCheckPreCorrectionMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, preResolvedOptions];

  optionCheckMapThreadFriendlyOptionsWithoutSolventAdditions = Experiment`Private`makePurificationMapThreadFriendly[mySamples, Association[preResolvedOptions], optionCheckPreCorrectionMapThreadFriendlyOptions];

  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  optionCheckMapThreadFriendlyOptions = Experiment`Private`mapThreadFriendlySolventAdditions[preResolvedOptions, optionCheckMapThreadFriendlyOptionsWithoutSolventAdditions, LiquidLiquidExtractionSolventAdditions];

  (* --- methodConflictingOptionsTest --- *)

  (* If a method is specified, all corresponding options should match with that method. *)
  methodConflictingOptions = MapThread[
    Function[{sample, methodPacket, methodOption, resolvedOptions, index},
      Module[{conflictingOptions},
        If[
          (* If a method is not set, then no need to check if the options line up with the method object.*)
          If[
            MatchQ[methodOption, Except[Custom]],
            (* Check if each option that the method can specify matches what is in the method object. *)
            Module[{informedFields},

              (* Pull out non-Null fields from method packets. *)
              informedFields = Select[$PlasmidDNAMethodFields,MatchQ[Lookup[methodPacket,#],Except[Null|{}]]&];

              (* Determine if value of method matches the resolved option. *)
              conflictingOptions = Map[
                If[
                  !MatchQ[Lookup[methodPacket, #],Lookup[resolvedOptions, #]],
                  #,
                  Nothing
                ]&,
                informedFields
              ];

              If[Length[conflictingOptions] > 0,
                True,
                False
              ]

            ],
            False
          ],
          {
            sample,
            conflictingOptions,
            methodOption,
            index
          },
          Nothing
        ]
      ]
    ],
    {mySamples, methodPackets, Lookup[roundedExperimentOptions, Method], optionCheckMapThreadFriendlyOptions, Range[Length[mySamples]]}
  ];

  If[Length[methodConflictingOptions] > 0 && messages,
    Message[
      Error::MethodOptionConflict,
      ObjectToString[methodConflictingOptions[[All, 1]], Cache -> cacheBall],
      methodConflictingOptions[[All, 2]],
      methodConflictingOptions[[All, 3]],
      methodConflictingOptions[[All, 4]]
    ];
  ];

  methodConflictingOptionsTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = methodConflictingOptions[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " have all options specified in their method set correctly:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " have all options specified in their method set correctly:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  invalidOptions = DeleteDuplicates[Flatten[
    {
      If[Length[methodConflictingOptions] > 0,
        {Method, methodConflictingOptions[[All,2]]},
        {}
      ],
      Sequence @@ {invalidExtractionMethodOptions, solidPhaseExtractionConflictingOptions, mbsMethodsConflictingOptions, purificationInvalidOptions}
    }
  ]];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions] > 0 && !gatherTests,
    Message[Error::InvalidOption, invalidOptions]
  ];

  (* -- RESOLVED RETURN -- *)

  (* Return our resolved options and/or tests. *)
  outputSpecification /. {
    Result -> preResolvedOptions,
    Tests -> Flatten[{
      optionPrecisionTests,
      methodValidityTest,
      solidPhaseExtractionConflictingOptionsTests,
      mbsMethodsConflictingOptionsTest,
      purificationTests,
      methodConflictingOptionsTest
    }]
  }

];

(* ::Subsection::Closed:: *)
(* extractPlasmidDNAResourcePackets *)


(* --- extractPlasmidDNAResourcePackets --- *)

DefineOptions[
  extractPlasmidDNAResourcePackets,
  Options :> {
    HelperOutputOption,
    CacheOption,
    SimulationOption
  }
];

extractPlasmidDNAResourcePackets[mySamples : ListableP[ObjectP[Object[Sample]]], myTemplatedOptions : {(_Rule | _RuleDelayed)...}, myResolvedOptions : {(_Rule | _RuleDelayed)..}, ops : OptionsPattern[]] := Module[
  {
    expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages,
    inheritedCache, samplePackets, methodObjects, methodPackets, uniqueSamplesInResources, resolvedPreparation, mapThreadFriendlyOptions, samplesInResources,
    sampleContainersIn, uniqueSampleContainersInResources, containersInResources, protocolPacket, allResourceBlobs,
    resourcesOk, resourceTests, previewRule, optionsRule, testsRule, resultRule, allUnitOperationPackets, currentSimulation,
    userSpecifiedLabels, runTime, unitOperationResolvedOptions, containerOutMapThreadFriendlyOptions, resolvedContainerOut,
    resolvedContainersOutWithWellsRemoved, resolvedContainerOutWell, resolvedIndexedContainerOut, fullyResolvedOptions, fastCacheBall,
    noPlasmidDNAExtractionStepSamples, noPlasmidDNAExtractionStepsUsedTest, mapThreadFriendlyResolvedOptionsWithoutSolventAdditions,
    mapThreadFriendlyResolvedOptions, lysisConflictingOptions, lysisConflictingOptionsTest,
    conflictingLysisOutputOptions, conflictingLysisOutputOptionsTest, neutralizeMismatchedOptionsResult, neutralizeMismatchedOptionsTest,
    purificationConflictingOptions, purificationConflictingOptionTests, lleTests,
    lleInvalidOptions, invalidOptions
  },


  (* get the inherited cache *)
  inheritedCache = Lookup[ToList[ops], Cache, {}];
  fastCacheBall = makeFastAssocFromCache[inheritedCache];

  (* Get the simulation *)
  currentSimulation = Lookup[ToList[ops], Simulation, {}];

  (* Lookup the resolved Preparation option. *)
  resolvedPreparation = Lookup[myResolvedOptions, Preparation];

  (* expand the resolved options if they weren't expanded already *)
  {expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentExtractPlasmidDNA, {mySamples}, myResolvedOptions];

  (* Correct expansion of SolventAdditions. *)
  (* NOTE:This is needed because SolventAdditions is not correctly expanded by ExpandIndexMatchedInputs. *)
  expandedResolvedOptions = Experiment`Private`expandSolventAdditionsOption[mySamples, myResolvedOptions, expandedResolvedOptions, LiquidLiquidExtractionSolventAdditions, NumberOfLiquidLiquidExtractions];

  (* Get the resolved collapsed index matching options that don't include hidden options *)
  resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
    ExperimentExtractPlasmidDNA,
    RemoveHiddenOptions[ExperimentExtractPlasmidDNA, fullyResolvedOptions],
    Ignore -> myTemplatedOptions,
    Messages -> False
  ];

  (* Determine the requested return value from the function *)
  outputSpecification = OptionDefault[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests; if True, then silence the messages *)
  gatherTests = MemberQ[output, Tests];
  messages = !gatherTests;

  (* Download *)
  samplePackets = fetchPacketFromFastAssoc[#, fastCacheBall]& /@ mySamples;

  methodObjects = Replace[Lookup[myResolvedOptions, Method], {Custom -> Null}, 2];
  methodPackets = If[NullQ[#], Null, fetchPacketFromFastAssoc[#, fastCacheBall]]& /@ methodObjects;

  (* Create resources for our samples in. *)
  uniqueSamplesInResources = (# -> Resource[Sample -> #, Name -> CreateUUID[]]&) /@ DeleteDuplicates[Download[mySamples, Object]];
  samplesInResources = (Download[mySamples, Object]) /. uniqueSamplesInResources;

  (* Create resources for our containers in. *)
  sampleContainersIn = Lookup[samplePackets, Container];
  uniqueSampleContainersInResources = (# -> Resource[Sample -> #, Name -> CreateUUID[]]&) /@ DeleteDuplicates[sampleContainersIn];
  containersInResources = (Download[sampleContainersIn, Object]) /. uniqueSampleContainersInResources;

  (* Get our map thread friendly options. *)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
    ExperimentExtractPlasmidDNA,
    myResolvedOptions
  ];

  (* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  mapThreadFriendlyOptions = Experiment`Private`mapThreadFriendlySolventAdditions[myResolvedOptions, mapThreadFriendlyOptions, LiquidLiquidExtractionSolventAdditions];

  (* Get our user specified labels. *)
  userSpecifiedLabels = DeleteDuplicates@Cases[
    Flatten@Lookup[
      Association @@ myResolvedOptions,
      {

        (* General *)
        ExtractedPlasmidDNALabel, ExtractedPlasmidDNAContainerLabel,

        (* Lysis *)
        PreLysisSupernatantLabel, PreLysisSupernatantContainerLabel, PostClarificationPelletLabel, PostClarificationPelletContainerLabel,

        (* Neutralization *)
        NeutralizedPelletLabel, NeutralizedPelletContainerLabel,

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
      sampleInLabels, extractedPlasmidDNALabels, extractedPlasmidDNAContainerLabels, labelSamplesInUnitOperations, workingSamples, lysisUnitOperations, neutralizationUnitOperations, purificationUnitOperations, labelSampleOutUnitOperation, primitives, roboticUnitOperationPackets, roboticRunTime, roboticSimulation, outputUnitOperationPacket
    },

    (* Initial Labeling *)
    (* Create a list of sample-in labels to be used internally *)
    sampleInLabels = Table[
      CreateUniqueLabel["ExtractPlasmidDNA SampleIn", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
      {x, 1, Length[mySamples]}
    ];

    (*Get resolved ExtractedPlasmidDNALabels and ExtractedPlasmidDNAContainerLabels*)
    extractedPlasmidDNALabels = Lookup[myResolvedOptions, ExtractedPlasmidDNALabel];
    extractedPlasmidDNAContainerLabels = Lookup[myResolvedOptions, ExtractedPlasmidDNAContainerLabel];

    (* LabelContainer and LabelSample *)
    labelSamplesInUnitOperations = {
      (* label samples *)
      LabelSample[
        Label -> sampleInLabels,
        Sample -> mySamples
      ]
    };

    (* Set up workingSamples to be updated as we move through each unit operations. *)
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
            TargetCellularComponent -> PlasmidDNA,
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

    (* Neutralization Unit Operation *)

    (* If Neutralize is set to true call the Precipitate primitive using the sample. *)
    {workingSamples, neutralizationUnitOperations} = Module[{neutralizeBools},

      neutralizeBools = Lookup[myResolvedOptions, Neutralize];

      If[MemberQ[neutralizeBools, True],
        Module[{neutralizedSamples, preFilteredNeutralizationOptions, neutralizationOptions},

          neutralizedSamples = MapThread[
            Function[{sample, neutralizeQ},
              If[
                MatchQ[neutralizeQ, True],
                CreateUniqueLabel["neutralized sample", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
                sample
              ]
            ],
            {
              workingSamples,
              neutralizeBools
            }
          ];

          (* gather the options we're passing into the Neutralization UO; any Automatics that Lyse doesn't like as Automatic are changed to the default *)
          preFilteredNeutralizationOptions = <|
            Sample -> PickList[workingSamples, neutralizeBools],
            Sequence @@ KeyValueMap[
              Function[{key, value},
                value -> PickList[Lookup[expandedResolvedOptions, key], neutralizeBools](*Lookup[options, key]*)
              ],
              Association @ $NeutralizationOptionMap
            ],
            TargetPhase -> Liquid,
            NumberOfWashes -> 0,
            Sterile -> True,
            UnprecipitatedSampleLabel -> PickList[neutralizedSamples, neutralizeBools]
          |>;

          neutralizationOptions = removeConflictingNonAutomaticOptions[Precipitate, Normal[preFilteredNeutralizationOptions, Association]];

          {
            neutralizedSamples,
            Precipitate[neutralizationOptions]
          }
        ],
        {workingSamples, {}}
      ]
    ];

    (* Purification Unit Operations *)

    {workingSamples, purificationUnitOperations} = If[
      MatchQ[Lookup[myResolvedOptions, Purification], ListableP[Null | None]],
      {workingSamples, {}},
      buildPurificationUnitOperations[
        workingSamples,
        myResolvedOptions,
        mapThreadFriendlyOptions,
        ExtractedPlasmidDNAContainerLabel,
        ExtractedPlasmidDNALabel,
        Cache -> inheritedCache,
        Simulation -> currentSimulation
      ]
    ];

    (* Combine the unit operations together *)
    primitives = Flatten[{
      labelSamplesInUnitOperations,
      lysisUnitOperations,
      neutralizationUnitOperations,
      purificationUnitOperations
    }];

    (* Set this internal variable to unit test the unit operations that are created by this function. *)
    $PlasmidDNAOperations = primitives;

    (* Get our robotic unit operation packets. *)
    {{roboticUnitOperationPackets, roboticRunTime}, roboticSimulation} = ExperimentRoboticCellPreparation[
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
    ];

    (* Create our own output unit operation packet, linking up the "sub" robotic unit operation objects. *)
    outputUnitOperationPacket = UploadUnitOperation[
      Module[{nonHiddenOptions},
        (* Only include non-hidden options from ExtractPlasmidDNA. *)
        nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, ExtractPlasmidDNA]];

        (* Override any options with resource. *)
        ExtractPlasmidDNA@Join[
          Cases[myResolvedOptions, Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
          {
            Sample -> samplesInResources,
            RoboticUnitOperations -> If[Length[roboticUnitOperationPackets] == 0,
              {},
              (Link /@ Lookup[roboticUnitOperationPackets, Object])
            ]
          }
        ]
      ],
      UnitOperationType -> Output,
      Upload -> False
    ];

    (* Simulate the resources for our main UO since it's now the only thing that doesn't have resources. *)
    (* NOTE: Should probably use SimulateResources[...] here but this is quicker. *)
    roboticSimulation = UpdateSimulation[
      roboticSimulation,
      Simulation[<|Object -> Lookup[outputUnitOperationPacket, Object], Sample -> (Link /@ mySamples)|>]
    ];

    (* Return back our packets and simulation. *)
    {
      Null,
      Flatten[{outputUnitOperationPacket, roboticUnitOperationPackets}],
      roboticSimulation,
      (roboticRunTime + 10Minute)
    }
  ];

  (* Pull out options from unit operation packets. *)
  unitOperationResolvedOptions = Module[{lysedSamples, neutralizedSamples, lleSamples, speSamples, mbsSamples, optionsWithoutPrecipitation, precipitationOptions, nonCollapsedOptions},

    (* Get the samples that were used in each step. *)
    (* Get the samples that were lysed and the samples that were neutralized. *)
    lysedSamples = PickList[mySamples, Lookup[expandedResolvedOptions, Lyse]];
    neutralizedSamples = PickList[mySamples, Lookup[expandedResolvedOptions, Neutralize]];

    (* Get the samples for each purification step (minus precipitation due to neutralization using the same *)
    (* unit operation type. *)
    {
      lleSamples,
      speSamples,
      mbsSamples
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
        MagneticBeadSeparation
      }
    ];

    (* Call shared function to pull out resolved options from unit operations and change *)
    (* Automatics to Nulls for any steps that are not used *)
    optionsWithoutPrecipitation = Flatten[optionsFromUnitOperation[
      allUnitOperationPackets,
      {
        Object[UnitOperation, LyseCells],
        Object[UnitOperation, Precipitate],
        Object[UnitOperation, LiquidLiquidExtraction],
        Object[UnitOperation, SolidPhaseExtraction],
        Object[UnitOperation, MagneticBeadSeparation]
      },
      mySamples,
      {
        lysedSamples,
        neutralizedSamples,
        lleSamples,
        speSamples,
        mbsSamples
      },
      myResolvedOptions,
      mapThreadFriendlyOptions,
      {
        Normal[KeyDrop[$LyseCellsSharedOptionsMap, {Method, RoboticInstrument, SampleOutLabel}], Association],
        $NeutralizationOptionMap,
        $LLEPurificationOptionMap,
        $SPEPurificationOptionMap,
        $MBSPurificationOptionMap
      },
      {
        MemberQ[Lookup[myResolvedOptions, Lyse], True],
        MemberQ[Lookup[myResolvedOptions, Neutralize], True],
        MemberQ[Flatten[ToList[Lookup[myResolvedOptions, Purification]]], ListableP[LiquidLiquidExtraction]],
        MemberQ[Flatten[ToList[Lookup[myResolvedOptions, Purification]]], ListableP[SolidPhaseExtraction]],
        MemberQ[Flatten[ToList[Lookup[myResolvedOptions, Purification]]], ListableP[MagneticBeadSeparation]]
      }
    ]];

    (* Pull out the precipitation options for each sample. *)
    precipitationOptions = If[
      MemberQ[Flatten[ToList[Lookup[myResolvedOptions, Purification]]], Precipitation],
      Module[{unitOperationTypes, precipitationSamples, precipitationSamplePositions, precipitationUnitOperationPosition, precipitationUnitOperationOptions, precipitationResolvedOptions},

        (* Pull out unit operation types. *)
        unitOperationTypes = Lookup[#, Type] & /@ allUnitOperationPackets;

        (* Determine which samples undergo precipitation. *)
        precipitationSamples = MapThread[
          Function[{sample, options},
            If[
              MemberQ[Lookup[options, Purification], Precipitation],
              sample,
              Nothing
            ]
          ],
          {mySamples, mapThreadFriendlyOptions}
        ];

        (* Determine the position of samples that undergo precipitation in all samples. *)
        precipitationSamplePositions = Flatten[Position[mySamples, #]& /@ precipitationSamples];

        (* Find the position of the precipitation UO. *)
        (* NOTE: If Neutralization is used, then Precipitation is the second. *)
        precipitationUnitOperationPosition = If[MemberQ[Lookup[myResolvedOptions, Neutralize], True],
          {Flatten[Position[unitOperationTypes, Object[UnitOperation, Precipitate]]][[2]]},
          {First[Flatten[Position[unitOperationTypes, Object[UnitOperation, Precipitate]]]]}
        ];

        (* Find the resolved options of the precipitation UO. *)
        precipitationUnitOperationOptions = Lookup[Extract[allUnitOperationPackets, precipitationUnitOperationPosition], ResolvedUnitOperationOptions];

        (* Pull out the options that we want and change their names to the shared names. *)
        (* Not using ReplaceAll to avoid replacing e.g. Model[Container, Plate, Filter] with Model[Container, Plate, PrecipitationFilter]*)
        precipitationResolvedOptions = Replace[
          Map[
            If[
              MemberQ[Values[$PrecipitationSharedOptionMap], Keys[#]],
              #,
              Nothing
            ]&,
            precipitationUnitOperationOptions
          ],
          Reverse /@ $PrecipitationSharedOptionMap,
          2
        ];

        (* For each shared precipitation option, replace Automatics with resolved options (if precipitation used) or Null (if precipitation not used). *)
        Map[
          Function[{optionName},
            Module[{optionValue},

              (* Build the fully resolved value for this shared option name. *)
              optionValue = MapThread[
                Function[{sampleIndex, sample, options},
                  If[
                    MemberQ[precipitationSamplePositions, sampleIndex],
                    (* If precipitation is used, then use resolved option. *)
                    Module[{resolvedOptionValue},

                      resolvedOptionValue = Extract[
                        Lookup[precipitationResolvedOptions, optionName],
                        Position[precipitationSamples, sample]
                      ][[1]];

                      Lookup[options, optionName] /. (Automatic -> resolvedOptionValue)

                    ],
                    (* If precipitation is not used, use Null. *)
                    Lookup[options, optionName] /. (Automatic -> Null)
                  ]
                ],
                {Range[Length[mySamples]], mySamples, mapThreadFriendlyOptions}
              ];

              optionName -> optionValue

            ]
          ],
          Keys[$PrecipitationSharedOptionMap]
        ]

      ],
      Map[
        # -> Lookup[myResolvedOptions, #] /. (Automatic -> Null)&,
        Keys[$PrecipitationSharedOptionMap]
      ]
    ];

    (* Combine options to make the final option list. *)
    ReplaceRule[
      Flatten[{
        optionsWithoutPrecipitation,
        precipitationOptions
      }],
      {
        SolidPhaseExtractionLoadingSampleVolume -> Lookup[optionsWithoutPrecipitation, SolidPhaseExtractionLoadingSampleVolume][[1]]
      }
    ]

  ];

  (* -- RESOLVE OUTPUT & LABELING OPTIONS -- *)

  (* Combine already resolved options and make them mapThreadFriendly. *)
  containerOutMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
    ExperimentExtractPlasmidDNA,
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
          Module[{lyseQ, neutralizeQ, purificationOption},

            (* Pull out master switch resolutions (for each step of the extraction). *)
            {lyseQ, neutralizeQ, purificationOption} = Lookup[options, {Lyse, Neutralize, Purification}];

            (* Go into that step's options (from the pulled out options or unit operation) and pull out the final container. *)
            Which[
              (* If Lysis is the last step and the lysate is neither aliquotted nor clarified, then it stays in *)
              (* it's original container. *)
              And[
                MatchQ[{lyseQ, neutralizeQ, purificationOption}, {True, False, None}],
                MatchQ[Lookup[options, {LysisAliquot, ClarifyLysate}], {False, False}]
              ],
                {Download[sample, Well, Cache -> inheritedCache], Download[Download[sample, Container, Cache -> inheritedCache], Object]},
              (* If Lysis is the last step and the lysate is aliquotted but not clarified, then the *)
              (* sample is last in the LysisAliquotContainer. *)
              And[
                MatchQ[{lyseQ, neutralizeQ, purificationOption}, {True, False, None}],
                MatchQ[Lookup[options, {LysisAliquot, ClarifyLysate}], {True, False}]
              ],
                Lookup[options, LysisAliquotContainer],
              (* If Lysis is the last step and the lysate is clarified, then the *)
              (* sample is last in the ClarifiedLysateContainer. *)
              And[
                MatchQ[{lyseQ, neutralizeQ, purificationOption}, {True, False, None}],
                MatchQ[Lookup[options, ClarifyLysate], True]
              ],
                Lookup[options, ClarifiedLysateContainer],
              (* If Neutralization is the last step, then the container is pulled out of the precipitation unit operation. *)
              And[
                MatchQ[{neutralizeQ, purificationOption}, {True, None}]
              ],
                Module[{allUnitOperations, neutralizedSamples, unitOperationPosition, unitOperationOptions},

                  (* Pull out unit operation types. *)
                  allUnitOperations = Lookup[#, Type] & /@ allUnitOperationPackets;

                  (* Pull out all neutralized samples. *)
                  neutralizedSamples = PickList[mySamples, Lookup[expandedResolvedOptions, Neutralize]];

                  (* Find the position of the UO of interest. *)
                  unitOperationPosition = {First[Flatten[Position[allUnitOperations, Object[UnitOperation, Precipitate]]]]};

                  (* Find the resolved options of the UO. *)
                  unitOperationOptions = Lookup[Extract[allUnitOperationPackets, unitOperationPosition], ResolvedUnitOperationOptions];

                  (* Pull out the final container of the Neutralization step for this sample. *)
                  If[
                    (Length[neutralizedSamples] > 1),
                    Extract[
                      Lookup[unitOperationOptions, UnprecipitatedSampleContainerOut],
                      Position[neutralizedSamples, sample]
                    ][[1]],
                    Lookup[unitOperationOptions, UnprecipitatedSampleContainerOut]
                  ]

                ],
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

                  (* Pull out the final container of the Neutralization step for this sample. *)
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
              (* If Precipitation is the last step and the target is liquid, *)
              (* then ContainerOut is the UnprecipitatedSampleContainerOut. *)
              And[
                MatchQ[Last[ToList[purificationOption]], Precipitation],
                MatchQ[Lookup[options, PrecipitationTargetPhase], Liquid]
              ],
                Lookup[options, UnprecipitatedSampleContainerOut],
              (* If Precipitation is the last step, the target is solid, filtration is used, *)
              (* and the solid will not be resuspended, then the ContainerOut *)
              (* is the PrecipitationFilter. *)
              And[
                MatchQ[Last[ToList[purificationOption]], Precipitation],
                MatchQ[Lookup[options, PrecipitationTargetPhase], Solid],
                MatchQ[Lookup[options, PrecipitationSeparationTechnique], Filter],
                MatchQ[Lookup[options, PrecipitationResuspensionBuffer], (None|Null)]
              ],
                {Lookup[options, PrecipitationFilterPosition], Lookup[options, PrecipitationFilter]},
              (* If Precipitation is the last step, the target is solid, pelleting is used, *)
              (* and the solid will not be resuspended, then the ContainerOut *)
              (* is the container of the sample going into precipitation. *)
              (* NOTE: This could easily be solved with PrecipitationContainer option or something, *)
              (* but not currently and option. *)
              And[
                MatchQ[Last[ToList[purificationOption]], Precipitation],
                MatchQ[Lookup[options, PrecipitationTargetPhase], Solid],
                MatchQ[Lookup[options, PrecipitationSeparationTechnique], Pellet],
                MatchQ[Lookup[options, PrecipitationResuspensionBuffer], (None|Null)]
              ],
                {Download[sample, Well, Cache -> inheritedCache], Download[Download[sample, Container, Cache -> inheritedCache], Object]},
              (* Otherwise, if Precipitation is the last step and the target is solid, *)
              (* then ContainerOut is the PrecipitatedSampleContainerOut. *)
              And[
                MatchQ[Last[ToList[purificationOption]], Precipitation],
                MatchQ[Lookup[options, PrecipitationTargetPhase], Solid]
              ],
                Lookup[options, PrecipitatedSampleContainerOut],
              (* If SPE is the last step and ExtractionStrategy is Positive, *)
              (* then ContainerOut is removed from the unit operation options. *)
              And[
                MatchQ[Last[ToList[purificationOption]], SolidPhaseExtraction],
                MatchQ[Lookup[options, SolidPhaseExtractionStrategy], Positive]
              ],
                Module[{allUnitOperations, speSamples, unitOperationPosition, unitOperationOptions},

                  (* Pull out unit operation types. *)
                  allUnitOperations = Lookup[#, Type] & /@ allUnitOperationPackets;

                  (* Pull out all samples that use LLE. *)
                  speSamples = PickList[mySamples, Map[MemberQ[#, SolidPhaseExtraction]&, Lookup[expandedResolvedOptions, Purification]]];

                  (* Find the position of the UO of interest. *)
                  unitOperationPosition = {Last[Flatten[Position[allUnitOperations, Object[UnitOperation, SolidPhaseExtraction]]]]};

                  (* Find the resolved options of the UO. *)
                  unitOperationOptions = Lookup[Extract[allUnitOperationPackets, unitOperationPosition], ResolvedUnitOperationOptions];

                  (* Pull out the final container of the Neutralization step for this sample. *)
                  Extract[
                    Lookup[unitOperationOptions, ElutingSolutionCollectionContainer],
                    Position[speSamples, sample]
                  ][[1]]

                ],
              (* If SPE is the last step and ExtractionStrategy is Negative, *)
              (* then ContainerOut is the SolidPhaseExtractionLoadingFlowthroughContainerOut. *)
              And[
                MatchQ[Last[ToList[purificationOption]], SolidPhaseExtraction],
                MatchQ[Lookup[options, SolidPhaseExtractionStrategy], Negative]
              ],
                Lookup[options, SolidPhaseExtractionLoadingFlowthroughContainerOut],
              (* If MBS is the last step and SelectionStrategy is Positive, *)
              (* then ContainerOut is the ElutionCollectionContainer. *)
              And[
                MatchQ[Last[ToList[purificationOption]], MagneticBeadSeparation],
                MatchQ[Lookup[options, MagneticBeadSeparationSelectionStrategy], Positive]
              ],
                Lookup[options, MagneticBeadSeparationElutionCollectionContainer],
              (* If MBS is the last step and SelectionStrategy is Negative, *)
              (* then ContainerOut is the LoadingCollectionContainer. *)
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
      MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container], Model[Container]}]}],
        Last[#],
      (* If the user specified ContainerOut using the "Container with Well and Index" widget format, remove the well. *)
      MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container], Model[Container]}]}}],
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
        MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container], Model[Container]}]}],
          First[#],
        (* If ContainerOut specified using the "Container with Well and Index" widget format, extract the well. *)
        MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container], Model[Container]}]}}],
          First[#],
        (* Otherwise, there isn't a well specified and we set this to automatic. *)
        True,
          Automatic
      ]&,
      resolvedContainerOut
    ];

    (*Make an association of the containers with their already specified wells.*)
    uniqueContainers = DeleteDuplicates[Cases[resolvedContainersOutWithWellsRemoved, Alternatives[ObjectP[Object[Container]], ObjectP[Model[Container]], {_Integer, ObjectP[Model[Container]]}]]];

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
              {1, #} -> uniqueContainerWells
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
        {containerModel},

        (*Get the container model to look up the available wells.*)
        containerModel =
            Which[
              (*If the container without a well is just a container model, then that can be used directly.*)
              MatchQ[#, ObjectP[Model[Container]]],
                #,
              (*If the container is an object, then the model is downloaded from the cache.*)
              MatchQ[#, ObjectP[Object[Container]]],
                Download[#, Model],
              (*If the container is an indexed container model, then the model is the second element.*)
              True,
                #[[2]]
            ];

        (*The well options are downloaded from the cache from the container model.*)
        # -> Flatten[Transpose[AllWells[containerModel]]]

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
        {well, container},
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
                  KeyExistsQ[containerToFilledWells, {Lookup[containerToIndex, container], container}],
                  containerToIndex = ReplaceRule[containerToIndex, container -> (Lookup[containerToIndex, container] + 1)]
                ];

                {Lookup[containerToIndex, container], container}

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
              {filledWells, wellOptions, availableWells, selectedWell},

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
                MatchQ[availableWells, {}] && !MatchQ[container, ObjectP[Object[Container]] | {_Integer, ObjectP[Model[Container]]}],
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
                ReplaceRule[containerToFilledWells, {indexedContainer -> Append[filledWells, selectedWell]}],
                Append[containerToFilledWells, indexedContainer -> Append[filledWells, selectedWell]]
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

  (* Add resolved options back into pre-resolved options. *)
  fullyResolvedOptions = ReplaceRule[
    myResolvedOptions,
    Flatten[{
      unitOperationResolvedOptions,
      ContainerOut -> resolvedContainerOut,
      ContainerOutWell -> resolvedContainerOutWell,
      IndexedContainerOut -> resolvedIndexedContainerOut
    }]
  ];


  (* -- CONFLICTING OPTIONS CHECK -- *)

  (*Make our resolved options mapThreadFriendly for easier conflict checking.*)
  mapThreadFriendlyResolvedOptionsWithoutSolventAdditions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, fullyResolvedOptions];

  (* Correctly make SolventAdditions mapThreadFriendly. *)
  (* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
  mapThreadFriendlyResolvedOptions = Experiment`Private`mapThreadFriendlySolventAdditions[fullyResolvedOptions, mapThreadFriendlyResolvedOptionsWithoutSolventAdditions, LiquidLiquidExtractionSolventAdditions];

  (* --- General Conflicting Options --- *)

  (* --- noPlasmidDNAExtractionStepsUsedTest --- *)

  (* If a method is specified, all corresponding options should match with that method. *)
  noPlasmidDNAExtractionStepSamples = MapThread[
    Function[{sample, lyseQ, neutralizeQ, purification, index},
      If[
        MatchQ[lyseQ, False] && MatchQ[neutralizeQ, False] && MatchQ[purification, None],
        {
          sample,
          index
        },
        Nothing
      ]
    ],
    {mySamples, Sequence @@ Map[Lookup[fullyResolvedOptions, #]&, {Lyse, Neutralize, Purification}], Range[Length[mySamples]]}
  ];

  If[Length[noPlasmidDNAExtractionStepSamples] > 0 && messages,
    Message[
      Error::NoPlasmidDNAExtractionStepsSet,
      ObjectToString[noPlasmidDNAExtractionStepSamples[[All, 1]], Cache -> inheritedCache],
      noPlasmidDNAExtractionStepSamples[[All, 2]]
    ];
  ];

  noPlasmidDNAExtractionStepsUsedTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = noPlasmidDNAExtractionStepSamples[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> inheritedCache] <> " have at least one step (Lysis, Neutralization, Purification) set in order to extract plasmid DNA from the sample:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> inheritedCache] <> " have at least one step (Lysis, Neutralization, Purification) set in order to extract plasmid DNA from the sample:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* --- Lysis Conflicting Options --- *)

  (*Check that if Lyse is False, that all lysing options are set to Null.*)
  {lysisConflictingOptions, lysisConflictingOptionsTest} = checkLysisConflictingOptions[
    mySamples,
    mapThreadFriendlyResolvedOptions,
    messages,
    Cache -> inheritedCache
  ];

  (* - conflictingLysisOutputOptionsTest - *)

  (* Find any samples for which Lyse is False but lysis options are set *)
  conflictingLysisOutputOptions = MapThread[
    Function[{sample, samplePacket, options, index},
      Module[{lyseLastStepQ, startingContainer},

        lyseLastStepQ = MatchQ[Lookup[options, {Lyse, Neutralize, Purification}], {True, False, None}];

        startingContainer = {Lookup[samplePacket, Position], Download[Lookup[samplePacket, Container], Object]};

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
          lyseLastStepQ && MatchQ[Lookup[options, ClarifyLysate], True] && !MatchQ[Lookup[options, {ClarifiedLysateContainer, ClarifiedLysateContainerLabel}], Lookup[options, {ContainerOut, ExtractedPlasmidDNAContainerLabel}]],
            {
              sample,
              index,
              Lookup[options, LysisAliquot],
              Lookup[options, ClarifyLysate],
              {ClarifiedLysateContainer, ClarifiedLysateContainerLabel},
              Lookup[options, {ClarifiedLysateContainer, ClarifiedLysateContainerLabel}],
              {ContainerOut, ExtractedPlasmidDNAContainerLabel},
              Lookup[options, {ContainerOut, ExtractedPlasmidDNAContainerLabel}]
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
      ObjectToString[conflictingLysisOutputOptions[[All, 1]], Cache -> inheritedCache],
      conflictingLysisOutputOptions[[All, 2]],
      conflictingLysisOutputOptions[[All, 3]],
      conflictingLysisOutputOptions[[All, 4]],
      conflictingLysisOutputOptions[[All, 5]],
      conflictingLysisOutputOptions[[All, 6]],
      conflictingLysisOutputOptions[[All, 7]],
      conflictingLysisOutputOptions[[All, 8]]
    ]
  ];

  conflictingLysisOutputOptionsTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = conflictingLysisOutputOptions[[All, 1]];

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

  (* --- Neutralization Conflicting Options --- *)

  (* ---- neutralizeMismatchedOptionsTest --- *)

  (* If Neutralize is False, then all of the Neutralize options should be set to Null. *)
  neutralizeMismatchedOptionsResult = MapThread[
    Function[{sample, options, index},
      (*If any LLE options are not null, then return which options are not null.*)
      If[
        (MatchQ[Lookup[options, Neutralize], False]) && (MemberQ[Lookup[options, $PlasmidDNANeutralizationOptions], Except[Null]]),
        {
          sample,
          Lookup[options, Neutralize],
          PickList[$PlasmidDNANeutralizationOptions, Lookup[options, $PlasmidDNANeutralizationOptions], Except[Null]],
          index
        },
        Nothing
      ]
    ],
    {mySamples, mapThreadFriendlyResolvedOptions, Range[Length[mySamples]]}
  ];

  If[Length[neutralizeMismatchedOptionsResult] > 0 && messages,
    Message[
      Error::NeutralizeOptionMismatch,
      ObjectToString[neutralizeMismatchedOptionsResult[[All, 1]], Cache -> inheritedCache],
      neutralizeMismatchedOptionsResult[[All, 2]],
      neutralizeMismatchedOptionsResult[[All, 3]],
      neutralizeMismatchedOptionsResult[[All, 4]]
    ];
  ];

  neutralizeMismatchedOptionsTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = neutralizeMismatchedOptionsResult[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> inheritedCache] <> " have all of their neutralization options set to Null since Neutralize is set to False:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> inheritedCache] <> " have all of their neutralization options set to Null since Neutralize is set to False:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (*Check that LLE, Precipitation, SPE, and MBS have all options set to Null if not called in Purification.*)
  {purificationConflictingOptions, purificationConflictingOptionTests} = checkPurificationConflictingOptions[
    mySamples,
    mapThreadFriendlyResolvedOptions,
    messages,
    Cache -> inheritedCache
  ];

  (*Check that all of the LLE options are valid.*)
  {lleTests, lleInvalidOptions} = liquidLiquidExtractionSharedOptionsTests[
    mySamples,
    samplePackets,
    fullyResolvedOptions,
    gatherTests,
    Cache -> inheritedCache
  ];

  (* -- INVALID OPTION CHECK -- *)

  invalidOptions = DeleteDuplicates[Flatten[{
    If[Length[noPlasmidDNAExtractionStepSamples] > 0,
      {Lyse, Neutralize, Purification},
      {}
    ],
    If[Length[conflictingLysisOutputOptions] > 0,
      {Sequence @@ {conflictingLysisOutputOptions[[All, 5]], conflictingLysisOutputOptions[[All, 7]]}},
      {}
    ],
    If[Length[neutralizeMismatchedOptionsResult] > 0,
      {neutralizeMismatchedOptionsResult[[All, 3]]},
      {}
    ],
    Sequence @@ {lysisConflictingOptions, purificationConflictingOptions, lleInvalidOptions}
  }]];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions] > 0 && !gatherTests,
    Message[Error::InvalidOption, invalidOptions]
  ];

  (* make list of all the resources we need to check in FRQ *)
  allResourceBlobs = If[MatchQ[resolvedPreparation, Manual],
    DeleteDuplicates[Cases[Flatten[Values[protocolPacket]], _Resource, Infinity]],
    {}
  ];

  (* Verify we can satisfy all our resources *)
  {resourcesOk, resourceTests} = Which[
    (* NOTE: If we're robotic, the framework will call FRQ for us. *)
    MatchQ[$ECLApplication, Engine] || MatchQ[resolvedPreparation, Robotic],
      {True, {}},
    gatherTests,
      Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Cache -> inheritedCache, Simulation -> currentSimulation],
    True,
      {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Messages -> messages, Cache -> inheritedCache, Simulation -> currentSimulation], Null}
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
  testsRule = Tests -> If[gatherTests,
    Flatten[{
      resourceTests,
      noPlasmidDNAExtractionStepsUsedTest,
      lysisConflictingOptionsTest,
      conflictingLysisOutputOptionsTest,
      neutralizeMismatchedOptionsTest,
      purificationConflictingOptionTests,
      lleTests
    }],
    {}
  ];

  (* generate the Result output rule *)
  (* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
  resultRule = Result -> If[MemberQ[output, Result] && TrueQ[resourcesOk],
    {Flatten[{protocolPacket, allUnitOperationPackets}], currentSimulation, runTime, fullyResolvedOptions},
    $Failed
  ];

  (* Return the output as we desire it *)
  outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}
];


(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
  simulateExperimentExtractPlasmidDNA,
  Options :> {CacheOption, SimulationOption, ParentProtocolOption}
];

(*Do not need myProtocolPacket input since its robotic only*)
simulateExperimentExtractPlasmidDNA[
  myProtocolPacket : (PacketP[Object[Protocol, ExtractPlasmidDNA], {Object, ResolvedOptions}] | $Failed | Null),
  myUnitOperationPackets : ({PacketP[]..} | $Failed),
  mySamples : {ObjectP[Object[Sample]]..},
  myResolvedOptions : {_Rule...},
  myResolutionOptions : OptionsPattern[simulateExperimentExtractPlasmidDNA]
] := Module[
  {
    cache, simulation, resolvedPreparation, protocolObject, currentSimulation, unitOperationField, simulationWithLabels
  },

  (* Lookup our cache and simulation and make our fast association *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

  (* NOTE: Plasmid DNA only supports Robotic preparation currently, but will eventually be the resolved Preparation option. *)
  (* preparation = Lookup[myResolvedOptions, Preparation]; *)
  resolvedPreparation = Robotic;

  (* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
  protocolObject = Which[
    (* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
    (* simulate an ID here in the simulation function in order to call SimulateResources. *)
    MatchQ[resolvedPreparation, Robotic],
      SimulateCreateID[Object[Protocol, RoboticSamplePreparation]],
    (* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
    MatchQ[myProtocolPacket, $Failed],
      SimulateCreateID[Object[Protocol, ExtractPlasmidDNA]],
    True,
      Lookup[myProtocolPacket, Object]
  ];

  (* Uploaded Labels *)
  simulationWithLabels = Simulation[
    LabelFields -> If[MatchQ[resolvedPreparation, Manual],
      Join[
        (* SampleContainerLabel here? Would need a SampleContainerLink field, but not needed until manual preparation included. *)
        Rule @@@ Cases[
          Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&) /@ Range[Length[mySamples]]}],
          {_String, _}
        ],
        Rule @@@ Cases[
          Transpose[{Lookup[myResolvedOptions, ExtractedPlasmidDNAContainerLabel], (Field[ContainerOutLink[[#]]]&) /@ Range[Length[mySamples]]}],
          {_String, _}
        ]
      ],
      {}
    ]
  ];

  (* Merge our packets with our labels. *)
  {
    protocolObject,
    UpdateSimulation[simulation, simulationWithLabels]
  }

];