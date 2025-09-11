(* ::Section::Closed:: *)
(* Shared Options *)

(* NOTE: The Batches option is not shared because that should be set in your MAIN experiment function, in relation to *)
(* what your main experiment is doing. *)



(* ::Subsection::Closed:: *)
(*Biology Shared Options*)
DefineOptionSet[
  BiologySharedOptions:>{
    ProtocolOptions,
    SamplesInStorageOption,
    SimulationOption,
    BiologyPostProcessingOptions
  }
];



(* ::Subsection::Closed:: *)
(* WashCellOptions *)

(With[{insertMe=#}, DefineOptionSet[insertMe:>Evaluate@{
  (* -- WASHING -- *)
  {
    OptionName->Wash,
    Default->Automatic,
    AllowNull->False,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates whether the cells should be washed, before they're combined with fresh media.",
    ResolutionDescription->"Automatically set to True when dealing with Mammalian cells, otherwise set to False.",
    Category->"Washing"
  },
  {
    OptionName->NumberOfWashes,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[Type->Number,Pattern:>RangeP[1,25,1]],
    Description->"The number of times that the cells should be washed with WashSolution.",
    ResolutionDescription->"Automatically set to 1 when Wash->True.",
    Category->"Washing"
  },
  (* NOTE: We have a separate option set when developers want to use the Wash options but the cells can't possibly be adherent. *)
  (* Ex. After coming out of a thaw. *)
  {
    OptionName->WashType,
    Default->Automatic,
    AllowNull->True,
    Widget->If[MatchQ[insertMe, WashCellNoAdherentMethodOptions],
      Widget[
        Type->Enumeration,
        Pattern:>Alternatives[Pellet|Null]
      ],
      Widget[
        Type->Enumeration,
        Pattern:>Alternatives[Pellet|Adherent|Null]
      ]
    ],
    Description->"The method by which the cells should be washed.",
    ResolutionDescription->"Automatically set to Pellet when Wash->True, unless any Filter-related options are set.",
    Category->"Washing"
  },
  {
    OptionName->WashSolution,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Sample],
        Object[Sample]
      }]
    ],
    Description->"The solution that is used to wash the cells.",
    ResolutionDescription->"Automatically set to an appropriate media for the cell type given.",
    Category->"Washing"
  },
  {
    OptionName->WashSolutionContainer,
    Default -> Automatic,
    ResolutionDescription -> "Automatically resolves to an Object[Container] if an Object[Sample] is specified. Otherwise, automatically resolves to a Model[Container] on any existing samples that can be used to fulfill the Model[Sample] request or based on the container that the default product for the Model[Sample] comes in.",
    AllowNull -> True,
    Widget -> Alternatives[
      "Existing Container"->Widget[
        Type -> Object,
        Pattern :> ObjectP[Object[Container]]
      ],
      "New Container"->Widget[
        Type -> Object,
        Pattern :> ObjectP[Model[Container]]
      ]
    ],
    Description -> "The container that the wash solution will be located in during the transfer.",
    Category->"Hidden"
  },
  {
    OptionName->WashSolutionPipette,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Instrument, Pipette],
        Object[Instrument, Pipette]
      }]
    ],
    Description->"The pipette that will be used to transfer the WashSolution into the WashContainer. If this pipette is the same model as the Pipette option, the same pipette will be used.",
    ResolutionDescription->"Automatically set based on the container of the WashSolution and the WashVolume specified.",
    Category->"Washing"
  },
  {
    OptionName->WashSolutionTips,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Item, Tips],
        Object[Item, Tips]
      }]
    ],
    Description->"The tips used to transfer the WashSolution into the WashContainer.",
    ResolutionDescription->"Automatically set based on the container of the WashSolution and the WashVolume specified.",
    Category->"Washing"
  },
  {
    OptionName->WashContainer,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[Model[Container]]
    ],
    Description->"The container that the cells will be placed in when they are washed.",
    ResolutionDescription->"Automatically set to a container that can hold the WashVolume and is compatible with the WashType chosen (ex. compatible with the centrifuge instrument).",
    Category->"Washing"
  },
  {
    OptionName->WashVolume,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>RangeP[0 Milliliter, 50 Milliliter],
      Units->Alternatives[Microliter, Milliliter]
    ],
    Description->"The amount of wash solution that is added to the WashContainer when the cells are washed.",
    ResolutionDescription->"Automatically set to 3/4 of the MaxVolume of the chosen WashContainer.",
    Category->"Washing"
  },
  ModifyOptions[
    SourceTemperatureOptions,
    SourceTemperature,
    {
      Description->"The temperature to heat/cool the wash solution to before the washing occurs.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the washing method for the cell line.",
      Category->"Washing"
    }
  ]/.{SourceTemperature->WashSolutionTemperature},
  ModifyOptions[
    SourceTemperatureOptions,
    SourceEquilibrationTime,
    {
      Description->"The duration of time for which the wash solution will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if WashSolutionTemperature is not set to Ambient.",
      Category->"Washing"
    }
  ]/.{SourceEquilibrationTime->WashSolutionEquilibrationTime},
  ModifyOptions[
    SourceTemperatureOptions,
    MaxSourceEquilibrationTime,
    {
      Description->"The maximum duration of time for which the samples will be heated/cooled to the target WashSolutionTemperature, if they do not reach the WashSolutionTemperature after WashSolutionEquilibrationTime.",
      ResolutionDescription -> "Automatically set to 30 Minute if WashSolutionTemperature is not set to Ambient.",
      Category->"Washing"
    }
  ]/.{MaxSourceEquilibrationTime->MaxWashSolutionEquilibrationTime},
  ModifyOptions[
    SourceTemperatureOptions,
    SourceEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the wash solution before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a WashSolutionTemperature is indicated.",
      Category->"Washing"
    }
  ]/.{SourceEquilibrationCheck->WashSolutionEquilibrationCheck},

  ModifyOptions[
    DestinationTemperatureOptions,
    DestinationTemperature,
    {
      Description->"The temperature to heat/cool the wash container to before the washing occurs.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the washing method for the cell line.",
      Category->"Washing"
    }
  ]/.{DestinationTemperature->WashContainerTemperature},
  ModifyOptions[
    DestinationTemperatureOptions,
    DestinationEquilibrationTime,
    {
      Description->"The duration of time for which the wash container will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if WashContainerTemperature is not set to Ambient.",
      Category->"Washing"
    }
  ]/.{DestinationEquilibrationTime->WashContainerEquilibrationTime},
  ModifyOptions[
    DestinationTemperatureOptions,
    MaxDestinationEquilibrationTime,
    {
      Description->"The maximum duration of time for which the wash container will be heated/cooled to the target WashContainerTemperature, if they do not reach the WashContainerTemperature after WashContainerEquilibrationTime.",
      ResolutionDescription -> "Automatically set to 30 Minute if WashContainerTemperature is not set to Ambient.",
      Category->"Washing"
    }
  ]/.{MaxDestinationEquilibrationTime->MaxWashContainerEquilibrationTime},
  ModifyOptions[
    DestinationTemperatureOptions,
    DestinationEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the wash container before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a WashContainerTemperature is indicated.",
      Category->"Washing"
    }
  ]/.{DestinationEquilibrationCheck->WashContainerEquilibrationCheck},

  {
    OptionName->WashSolutionAspirationMix,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to True if any of the other WashSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if mixing should occur during aspiration from the wash solution.",
    Category->"Washing"
  },
  {
    OptionName->WashSolutionAspirationMixType,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to Pipette if any of the other WashSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>TransferMixTypeP
    ],
    Description->"The type of mixing that should occur during aspiration from the wash solution.",
    Category->"Washing"
  },
  {
    OptionName->NumberOfWashSolutionAspirationMixes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 5 if any of the other WashSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the wash solution should be mixed during aspiration.",
    Category->"Washing"
  },
  {
    OptionName->WashSolutionDispenseMix,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to True if any of the other WashSolutionDispenseMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if mixing should occur after the cells are dispensed into the wash solution.",
    Category->"Washing"
  },
  {
    OptionName->WashSolutionDispenseMixType,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to Pipette if any of the other WashSolutionDispenseMix options are set and we're using a pipette to do the transfer. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>TransferMixTypeP
    ],
    Description->"The type of mixing that should occur after the cells are dispensed into the wash solution.",
    Category->"Washing"
  },
  {
    OptionName->NumberOfWashSolutionDispenseMixes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 5 if any of the other WashSolutionDispenseMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the cell/wash solution suspension should be mixed after dispension.",
    Category->"Washing"
  },

  {
    OptionName->WashSolutionIncubation,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if the cells should be incubated and/or mixed after the wash solution is added.",
    ResolutionDescription->"Automatically set to True if Washing is turned on (defaults to 3 swirls).",
    Category->"Washing"
  },
  {
    OptionName -> WashSolutionIncubationInstrument,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[
      Type->Object,
      Pattern :> ObjectP[
        {
          Model[Instrument,Shaker],
          Object[Instrument,Shaker],
          Model[Instrument,HeatBlock],
          Object[Instrument,HeatBlock]
        }
      ]
    ],
    Description -> "The instrument used to perform the Mixing and/or Incubation of the WashSolution.",
    ResolutionDescription -> "Automatically sets based on the options Mix, Temperature, MixType and container of the sample.",
    Category->"Washing"
  },
  {
    OptionName->WashSolutionIncubationTime,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
    Description->"The amount of time that the cells should be incubated/mixed with the wash solution.",
    ResolutionDescription->"Automatically sets based on the WashSolutionMixType and the WashContainer.",
    Category->"Washing"
  },
  (* NOTE: We're only allowing for shaking and heat blocks here so the temperature range is lowered. *)
  {
    OptionName->WashSolutionIncubationTemperature,
    Default->Automatic,
    AllowNull->True,
    Widget->Alternatives[
      Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, 180 Celsius],Units :> Celsius],
      Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
    ],
    Description->"The temperature of the mix instrument while mixing/incubating the cells with the wash solution.",
    ResolutionDescription->"Automatically sets based on the WashSolutionMixType and the WashContainer.",
    Category->"Washing"
  },
  {
    OptionName -> WashSolutionMix,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
    Description -> "Indicates if this cells and wash solution should be mixed during WashSolutionIncubation.",
    ResolutionDescription -> "Automatically set based on any wash solution mixing options that are set.",
    Category->"Washing"
  },
  (* NOTE: We do NOT allow all mix types here because not all make sense for mixing cell samples during washing. *)
  {
    OptionName -> WashSolutionMixType,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake]],
    Description -> "Indicates the style of motion used to mix the sample.",
    ResolutionDescription -> "Automatically sets based on the container of the sample and the Mix option.",
    Category->"Washing"
  },
  (* NOTE: The only MixRate related mixing that we're allowing for here is Shake -- which has a range of 35-1800 RPM. *)
  {
    OptionName -> WashSolutionMixRate,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[Type -> Quantity, Pattern :> RangeP[35 RPM, 1800 RPM], Units->RPM],
    Description -> "Frequency of rotation of the mixing instrument should use to mix the cells/wash solution.",
    ResolutionDescription -> "Automatically set based on the WashSolutionIncubationInstrument and WashSolutionMixType selected.",
    Category->"Washing"
  },

  (* -- WASHING VIA PELLET -- *)
  (* Copy over the following pelleting options and prepend "WashPellet" to the option names. *)
  (* NOTE: We don't include the resuspension options because resuspension is the same the wash solution transfer. *)
  Sequence@@(
    (
      ReplaceRule[
        ModifyOptions[
          ExperimentPellet,
          #,
          {
            Default->Automatic,
            Category->"Washing"
          }
        ],
        OptionName->ToExpression["WashPellet"<>ToString[#]]
      ]
          &)/@{
      Instrument, Intensity, Time, Temperature
    }
  )

  (* -- WASHING VIA FILTRATION -- *)
  (* TODO: Put in these options once Steven finishes the new version of Filter. *)
}]]&)/@{WashCellOptions, WashCellNoAdherentMethodOptions};

DefineOptionSet[PreDissociationWashOptions:>Evaluate@{
  (* -- PREDISSOCIATION WASH -- *)
  {
    OptionName->PreDissociationWash,
    Default->Automatic,
    AllowNull->False,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if the cell samples should be washed with a PreDissociationWashSolution before Dissociation occurs. This option cannot be set if dealing with non-adherent cells.",
    ResolutionDescription->"Automatically set to True if dealing with Adherent cells.",
    Category->"PreDissociation Wash"
  },
  {
    OptionName->PreDissociationWashSolution,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Sample],
        Object[Sample]
      }]
    ],
    Description->"The solution that is used to wash the cell samples, before Dissociation occurs.",
    Category->"PreDissociation Wash"
  },
  {
    OptionName->PreDissociationWashSolutionContainer,
    Default -> Automatic,
    ResolutionDescription -> "Automatically resolves to an Object[Container] if an Object[Sample] is specified. Otherwise, automatically resolves to a Model[Container] on any existing samples that can be used to fulfill the Model[Sample] request or based on the container that the default product for the Model[Sample] comes in.",
    AllowNull -> True,
    Widget -> Alternatives[
      "Existing Container"->Widget[
        Type -> Object,
        Pattern :> ObjectP[Object[Container]]
      ],
      "New Container"->Widget[
        Type -> Object,
        Pattern :> ObjectP[Model[Container]]
      ]
    ],
    Description -> "The container that the Predissociation wash solution will be located in during the transfer.",
    Category->"Hidden"
  },
  {
    OptionName->NumberOfPreDissociationWashes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 1 if PreDissociationWash is set to True. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the cell samples should be washed before dissociation occurs.",
    Category->"PreDissociation Wash"
  },
  {
    OptionName->PreDissociationWashVolume,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>GreaterP[0 Microliter],
      Units->Alternatives[Microliter, Milliliter]
    ],
    Description->"The amount of PreDissociationWash solution that should be applied to the cell samples.",
    Category->"PreDissociation Wash"
  },
  {
    OptionName->PreDissociationWashPipette,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Instrument, Pipette],
        Object[Instrument, Pipette]
      }]
    ],
    Description->"The pipette that will be used to transfer the PreDissociationWashSolution into the ContainerIn. If this pipette is the same model as the Pipette option, the same pipette will be used.",
    ResolutionDescription->"Automatically set based on the container of the PreDissociationWashSolution and the PreDissociationWashVolume specified.",
    Category->"PreDissociation Wash"
  },
  {
    OptionName->PreDissociationWashTips,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Item, Tips],
        Object[Item, Tips]
      }]
    ],
    Description->"The tips used to transfer the PreDissociationWashSolution into the ContainerIn.",
    ResolutionDescription->"Automatically set based on the container of the PreDissociationWashSolution and the PreDissociationWashVolume specified.",
    Category->"PreDissociation Wash"
  },
  ModifyOptions[
    SourceTemperatureOptions,
    SourceTemperature,
    {
      Description->"The temperature to heat/cool the PreDissociationWashSolution to before the PreDissociationWash occurs.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the method for the cell line.",
      Category->"PreDissociation Wash"
    }
  ]/.{SourceTemperature->PreDissociationWashSolutionTemperature},
  ModifyOptions[
    SourceTemperatureOptions,
    SourceEquilibrationTime,
    {
      Description->"The duration of time for which the PreDissociationWashSolution will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if PreDissociationWashSolutionTemperature is not set to Ambient.",
      Category->"PreDissociation Wash"
    }
  ]/.{SourceEquilibrationTime->PredissociationWashSolutionEquilibrationTime},
  ModifyOptions[
    SourceTemperatureOptions,
    MaxSourceEquilibrationTime,
    {
      Description->"The maximum duration of time for which the samples will be heated/cooled to the target PreDissociationWashSolutionTemperature, if they do not reach the PreDissociationWashSolutionTemperature after PreDissociationWashSolutionEquilibrationTime.",
      ResolutionDescription -> "Automatically set to 30 Minute if PreDissociationWashSolutionTemperature is not set to Ambient.",
      Category->"PreDissociation Wash"
    }
  ]/.{MaxSourceEquilibrationTime->MaxPredissociationWashSolutionEquilibrationTime},
  ModifyOptions[
    SourceTemperatureOptions,
    SourceEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the PreDissociationWash solution before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a PreDissociationWashSolutionTemperature is indicated.",
      Category->"PreDissociation Wash"
    }
  ]/.{SourceEquilibrationCheck->PreDissociationWashSolutionEquilibrationCheck},

  {
    OptionName->PreDissociationWashSolutionAspirationMix,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to True if any of the other PreDissociationWashSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if mixing should occur during aspiration from the PreDissociationWash solution.",
    Category->"PreDissociation Wash"
  },
  {
    OptionName->PreDissociationWashSolutionAspirationMixType,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to Pipette if any of the other PreDissociationWashSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>TransferMixTypeP
    ],
    Description->"The type of mixing that should occur during aspiration from the PreDissociationWash solution.",
    Category->"PreDissociation Wash"
  },
  {
    OptionName->NumberOfPreDissociationWashSolutionAspirationMixes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 5 if any of the other PreDissociationWashSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the PreDissociationWash solution should be mixed during aspiration.",
    Category->"PreDissociation Wash"
  },
  {
    OptionName->PreDissociationWashSolutionDispenseMix,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to True if any of the other PreDissociationWashSolutionDispenseMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if mixing should occur after the PreDissociationWashSolution is dispensed into the ContainerIn.",
    Category->"PreDissociation Wash"
  },
  {
    OptionName->PreDissociationWashSolutionDispenseMixType,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to Pipette if any of the other PreDissociationWashSolutionDispenseMix options are set and we're using a pipette to do the transfer. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>TransferMixTypeP
    ],
    Description->"The type of mixing that should occur after the PreDissociationWashSolution is dispensed into the ContainerIn.",
    Category->"PreDissociation Wash"
  },
  {
    OptionName->NumberOfPreDissociationWashSolutionDispenseMixes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 5 if any of the other PreDissociationWashSolutionDispenseMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the PreDissociationWashSolution should be mixed after the PreDissociationWashSolution is dispensed into the ContainerIn.",
    Category->"PreDissociation Wash"
  }
}];

DefineOptionSet[DissociationOptions:>Evaluate@{

  (* -- Dissociation -- *) (*TODO: NonMechanicalDissociation*)
  {
    OptionName->Dissociation,
    Default->Automatic,
    AllowNull->False,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if the cell samples are adherent and first need to be dissociated from the flask/plate surface before they can be split.",
    ResolutionDescription->"Automatically set to True for adherent cells. Otherwise, is set to False.",
    Category->"Dissociation"
  },
  {
    OptionName->DissociationPellet,
    Default->Automatic,
    AllowNull->False,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if the cell suspension is centrifuged, and supernatent aspirated before DissociationSolution is added to resuspend the cells.",
    ResolutionDescription->"Automatically set to True if Dissociation is True. Set to False if performing SplitCells for AdherentCells.",
    Category->"Dissociation"
  },
  {
    OptionName->DissociationSolution,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Sample],
        Object[Sample]
      }]
    ],
    Description->"The solution that is used to dissociate the cells from the ContainerIn..",
    ResolutionDescription->"Automatically set to Model[Sample, \"Trypsin-EDTA (0.25%), phenol red\"] if Dissociation->True.",
    Category->"Dissociation"
  },
  {
    OptionName->DissociationSolutionContainer,
    Default -> Automatic,
    ResolutionDescription -> "Automatically resolves to an Object[Container] if an Object[Sample] is specified. Otherwise, automatically resolves to a Model[Container] on any existing samples that can be used to fulfill the Model[Sample] request or based on the container that the default product for the Model[Sample] comes in.",
    AllowNull -> True,
    Widget -> Alternatives[
      "Existing Container"->Widget[
        Type -> Object,
        Pattern :> ObjectP[Object[Container]]
      ],
      "New Container"->Widget[
        Type -> Object,
        Pattern :> ObjectP[Model[Container]]
      ]
    ],
    Description -> "The container that the Dissociation solution will be located in during the transfer.",
    Category->"Hidden"
  },
  {
    OptionName->DissociationSolutionVolume,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>GreaterP[0 Microliter],
      Units->Alternatives[Microliter, Milliliter]
    ],
    Description->"The amount of Dissociation solution that should be applied to the cell samples.",
    ResolutionDescription->"Automatically sets based on the container that the cells are currently in, in order to fully coat the entire container surface for dissociation.",
    Category->"Dissociation"
  },
  {
    OptionName->DissociationSolutionTransferPipette,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Instrument, Pipette],
        Object[Instrument, Pipette]
      }]
    ],
    Description->"The pipette that will be used to transfer the DissociationSolution into the ContainerIn. If this pipette is the same model as the Pipette option, the same pipette will be used.",
    ResolutionDescription->"Automatically set based on the container of the DissociationSolution and the DissociationVolume specified.",
    Category->"Dissociation"
  },
  {
    OptionName->DissociationSolutionTransferTips,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Item, Tips],
        Object[Item, Tips]
      }]
    ],
    Description->"The tips used to transfer the DissociationSolution into the ContainerIn.",
    ResolutionDescription->"Automatically set based on the container of the DissociationSolution and the DissociationVolume specified.",
    Category->"Dissociation"
  },
  ModifyOptions[
    SourceTemperatureOptions,
    SourceTemperature,
    {
      Description->"The temperature to heat/cool the Dissociation solution to before the Dissociation occurs.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the method for the cell line.",
      Category->"Dissociation"
    }
  ]/.{SourceTemperature->DissociationSolutionTemperature},
  ModifyOptions[
    SourceTemperatureOptions,
    SourceEquilibrationTime,
    {
      Description->"The duration of time for which the Dissociation solution will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if DissociationSolutionTemperature is not set to Ambient.",
      Category->"Dissociation"
    }
  ]/.{SourceEquilibrationTime->DissociationSolutionEquilibrationTime},
  ModifyOptions[
    SourceTemperatureOptions,
    MaxSourceEquilibrationTime,
    {
      Description->"The maximum duration of time for which the samples will be heated/cooled to the target DissociationSolutionTemperature, if they do not reach the DissociationSolutionTemperature after DissociationSolutionEquilibrationTime.",
      ResolutionDescription -> "Automatically set to 30 Minute if DissociationSolutionTemperature is not set to Ambient.",
      Category->"Dissociation"
    }
  ]/.{MaxSourceEquilibrationTime->MaxDissociationSolutionEquilibrationTime},
  ModifyOptions[
    SourceTemperatureOptions,
    SourceEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the Dissociation solution before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a DissociationSolutionTemperature is indicated.",
      Category->"Dissociation"
    }
  ]/.{SourceEquilibrationCheck->DissociationSolutionEquilibrationCheck},

  {
    OptionName->DissociationSolutionAspirationMix,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to True if any of the other DissociationSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if mixing should occur during aspiration from the Dissociation solution.",
    Category->"Dissociation"
  },
  {
    OptionName->DissociationSolutionAspirationMixType,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to Pipette if any of the other DissociationSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>TransferMixTypeP
    ],
    Description->"The type of mixing that should occur during aspiration from the Dissociation solution.",
    Category->"Dissociation"
  },
  {
    OptionName->NumberOfDissociationSolutionAspirationMixes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 5 if any of the other DissociationSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the Dissociation solution should be mixed during aspiration.",
    Category->"Dissociation"
  },
  {
    OptionName->DissociationSolutionDispenseMix,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to True if any of the other DissociationSolutionDispenseMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if mixing should occur after the cells are dispensed into the Dissociation solution.",
    Category->"Dissociation"
  },
  {
    OptionName->DissociationSolutionDispenseMixType,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to Pipette if any of the other DissociationSolutionDispenseMix options are set and we're using a pipette to do the transfer. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>TransferMixTypeP
    ],
    Description->"The type of mixing that should occur after the cells are dispensed into the Dissociation solution.",
    Category->"Dissociation"
  },
  {
    OptionName->NumberOfDissociationSolutionDispenseMixes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 5 if any of the other DissociationSolutionDispenseMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the cell/Dissociation solution suspension should be mixed after dispension.",
    Category->"Dissociation"
  },

  {
    OptionName->IncubateUntilDetached,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[Type -> Enumeration, Pattern :> BooleanP],
    Description->"Indicates if the dissociation should be continued up to the MaxDissociationTime (after DissociationTime has passed), in an attempt dissociate the cells from the ContainerIn surface.",
    ResolutionDescription->"Automatically set to True, unless MaxDissociationTime is specifically set to Null.",
    Category->"Dissociation"
  },
  {
    OptionName->DissociationIncubationTime,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
    Description->"The amount of time that the cells should be incubated with the Dissociation solution.",
    ResolutionDescription->"Automatically set to 5 minutes if DissociationSolutionIncubation is set to True.",
    Category->"Dissociation"
  },
  {
    OptionName->MaxDissociationIncubationTime,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
    Description->"The maximum amount of time that the cells should be incubated with the Dissociation solution.",
    ResolutionDescription->"Automatically set to 10 minutes if DissociationSolutionIncubation is set to True.",
    Category->"Dissociation"
  }
}];

DefineOptionSet[DissociationInactivationOptions:>Evaluate@{

  (* -- Dissociation Inactivation -- *)
  {
    OptionName->DissociationInactivation,
    Default->Automatic,
    AllowNull->False,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if the sample should have a DissociationInactivationSolution added after the Dissociation step to inactive the DissociationSolution.",
    ResolutionDescription->"Automatically set to True if Dissociation->True. Otherwise, is set to False.",
    Category->"Dissociation Inactivation"
  },
  {
    OptionName->DissociationInactivationSolution,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Sample],
        Object[Sample]
      }]
    ],
    Description->"The solution that is used to inactivate the DissociationSolution after DissociationTime has passed.",
    ResolutionDescription->"Automatically set to the Media that will be used to plate the cells.",
    Category->"Dissociation Inactivation"
  },
  {
    OptionName->DissociationInactivationSolutionContainer,
    Default -> Automatic,
    ResolutionDescription -> "Automatically resolves to an Object[Container] if an Object[Sample] is specified. Otherwise, automatically resolves to a Model[Container] on any existing samples that can be used to fulfill the Model[Sample] request or based on the container that the default product for the Model[Sample] comes in.",
    AllowNull -> True,
    Widget -> Alternatives[
      "Existing Container"->Widget[
        Type -> Object,
        Pattern :> ObjectP[Object[Container]]
      ],
      "New Container"->Widget[
        Type -> Object,
        Pattern :> ObjectP[Model[Container]]
      ]
    ],
    Description -> "The container that the DissociationInactivation solution will be located in during the transfer.",
    Category->"Hidden"
  },
  {
    OptionName->DissociationInactivationVolume,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>GreaterP[0 Microliter],
      Units->Alternatives[Microliter, Milliliter]
    ],
    Description->"The amount of DissociationInactivation solution that should be applied to the ContainerIn.",
    ResolutionDescription->"Automatically set based on the volume of the container that the cells are currently in.",
    Category->"Dissociation Inactivation"
  },
  {
    OptionName->DissociationInactivationPipette,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Instrument, Pipette],
        Object[Instrument, Pipette]
      }]
    ],
    Description->"The pipette that will be used to transfer the DissociationInactivationSolution into the ContainerIn. If this pipette is the same model as the Pipette option, the same pipette will be used.",
    ResolutionDescription->"Automatically set based on the container of the DissociationInactivationSolution and the DissociationInactivationVolume specified.",
    Category->"Dissociation Inactivation"
  },
  {
    OptionName->DissociationInactivationTips,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Item, Tips],
        Object[Item, Tips]
      }]
    ],
    Description->"The tips used to transfer the DissociationInactivationSolution into the ContainerOut.",
    ResolutionDescription->"Automatically set based on the container of the DissociationInactivationSolution and the DissociationInactivationVolume specified.",
    Category->"Dissociation Inactivation"
  },
  ModifyOptions[
    SourceTemperatureOptions,
    SourceTemperature,
    {
      Description->"The temperature to heat/cool the Dissociation solution to before the Dissociation occurs.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the method for the cell line.",
      Category->"Dissociation Inactivation"
    }
  ]/.{SourceTemperature->DissociationInactivationSolutionTemperature},
  ModifyOptions[
    SourceTemperatureOptions,
    SourceEquilibrationTime,
    {
      Description->"The duration of time for which the Dissociation solution will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if DissociationInactivationSolutionTemperature is not set to Ambient.",
      Category->"Dissociation Inactivation"
    }
  ]/.{SourceEquilibrationTime->DissociationInactivationSolutionEquilibrationTime},
  ModifyOptions[
    SourceTemperatureOptions,
    MaxSourceEquilibrationTime,
    {
      Description->"The maximum duration of time for which the samples will be heated/cooled to the target DissociationInactivationSolutionTemperature, if they do not reach the DissociationInactivationSolutionTemperature after DissociationInactivationSolutionEquilibrationTime.",
      ResolutionDescription -> "Automatically set to 30 Minute if DissociationInactivationSolutionTemperature is not set to Ambient.",
      Category->"Dissociation Inactivation"
    }
  ]/.{MaxSourceEquilibrationTime->MaxDissociationInactivationSolutionEquilibrationTime},
  ModifyOptions[
    SourceTemperatureOptions,
    SourceEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the Dissociation solution before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a DissociationInactivationSolutionTemperature is indicated.",
      Category->"Dissociation Inactivation"
    }
  ]/.{SourceEquilibrationCheck->DissociationInactivationSolutionEquilibrationCheck},

  {
    OptionName->DissociationInactivationSolutionAspirationMix,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to True if any of the other DissociationInactivationSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if mixing should occur during aspiration from the Dissociation Inactivation solution.",
    Category->"Dissociation Inactivation"
  },
  {
    OptionName->DissociationInactivationSolutionAspirationMixType,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to Pipette if any of the other DissociationInactivationSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>TransferMixTypeP
    ],
    Description->"The type of mixing that should occur during aspiration from the Dissociation Inactivation solution.",
    Category->"Dissociation Inactivation"
  },
  {
    OptionName->NumberOfDissociationInactivationSolutionAspirationMixes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 5 if any of the other DissociationInactivationSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the Dissociation Inactivation solution should be mixed during aspiration.",
    Category->"Dissociation Inactivation"
  },
  {
    OptionName->DissociationInactivationSolutionDispenseMix,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to True, unless any other DissociationInactivationSolutionDispenseMix options are set to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if mixing should occur after the cells are dispensed into the Dissociation Inactivation solution.",
    Category->"Dissociation Inactivation"
  },
  {
    OptionName->DissociationInactivationSolutionDispenseMixType,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to Pipette, unless any other DissociationInactivationSolutionDispenseMix options are set to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>TransferMixTypeP
    ],
    Description->"The type of mixing that should occur after the cells are dispensed into the Dissociation Inactivation solution.",
    Category->"Dissociation Inactivation"
  },
  {
    OptionName->NumberOfDissociationInactivationSolutionDispenseMixes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 5, unless any other DissociationInactivationSolutionDispenseMix options are set to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the cell/Dissociation Inactivation solution suspension should be mixed after dispension.",
    Category->"Dissociation Inactivation"
  }
}];

DefineOptionSet[ScrapeCellsOptions:>Evaluate@{
  {
    OptionName->ScrapeCells,
    Default->Automatic,
    AllowNull->False,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if a cell scraper should be used in order to help the dissociation of the adherent cells from the bottom of the cell flask.",
    ResolutionDescription->"Automatically set to True if any of the other ScrapeCell options are set. Otherwise, set to False.",
    Category->"Cell Scraping"
  },
  {
    OptionName->Scraper,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Item, CellScraper],
        Object[Item, CellScraper]
      }]
    ],
    Description->"The scraper that should be used to physically help dissociate the adherent cells from the bottom of the cell flask.",
    ResolutionDescription->"Automatically set to a Model[Item, CellScraper] if ScrapeCells->True.",
    Category->"Cell Scraping"
  },
  {
    OptionName->NumberOfScrapes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 1 if aliquoting adherent cells. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that Scraper will be glided across ContainerIn. Null indicates cells will be fully scraped off the plate.",
    Category->"Cell Scraping"
  },
  {
    OptionName->ScrapingRatio,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>Alternatives[1/8,1/4,1/2,3/4,7/8]
    ],
    Description->"The ratio of the ContainerIn surface area that is scraped. Only applicable to AliquotCells for adherent cultures.",
    ResolutionDescription->"Automatically round Ratio*NumberOfReplicates to the nearest allowed number (1/8,1/4,1/2,3/4,7/8).",
    Category->"Cell Scraping",
    NestedIndexMatching->True
  }
}];

DefineOptionSet[MechanicalDisruptionOptions:>Evaluate@{

  (* -- Mechanical Disruption -- *)
  {
    OptionName->MechanicalDisruption,
    Default->Automatic,
    AllowNull->False,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if the cells should be pipetted up-and-down to aid cell dissociation.",
    ResolutionDescription->"Automatically set to True for adherent cells. Otherwise, is set to False.",
    Category->"Dissociation"
  },
  {
    OptionName->DisruptionPipette,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Instrument, Pipette],
        Object[Instrument, Pipette]
      }]
    ],
    Description->"The pipette that will be used to perform the mechanical disruption.",
    ResolutionDescription->"Automatically set based on the volume of sample at the time when mechanical disruption takes place.",
    Category->"Dissociation"
  },
  {
    OptionName->DisruptionTips,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Item, Tips],
        Object[Item, Tips]
      }]
    ],
    Description->"The tips used to perform the mechanical disruption.",
    ResolutionDescription->"Automatically set based on the volume of sample at the time when mechanical disruption takes place.",
    Category->"Dissociation"
  },
  {
    OptionName->DisruptionVolume,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>GreaterP[0 Microliter],
      Units->Alternatives[Microliter, Milliliter]
    ],
    Description->"The amount of liquid that will be pipetted during MechanicalDisruption.",
    ResolutionDescription->"Automatically set to the volume of sample at the time when mechanical disruption takes place.",
    Category->"Dissociation"
  },
  {
    OptionName->NumberOfDisruptions,
    Default->Automatic,
    ResolutionDescription->"Automatically sets to 10 if any of the other DissociationSolutionDispenseMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the sample will be pipetted up-and-down.",
    Category->"Dissociation"
  },
  {
    OptionName->DisruptUntilEven,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[Type->Enumeration, Pattern :> BooleanP],
    Description->"Indicates if the dissociation should be continued up to the MaxNumberOfDisruptions, in an attempt to dissociate the cells until no clumps are visible in the solution.",
    ResolutionDescription->"Automatically set to True, unless MaxDissociationTime is specifically set to Null.",
    Category->"Dissociation"
  },
  {
    OptionName->MaxNumberOfDisruptions,
    Default->Automatic,
    ResolutionDescription->"Automatically sets to 20 if any of the other DisruptUntilEven->True. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the cell/Dissociation solution suspension should be mixed after dispension.",
    Category->"Dissociation"
  }
}];

DefineOptionSet[CoatingOptions:>Evaluate@{

  (* -- COATING -- *)
  (* Note: coating and coating wash should not aspire in the end *)
  {
    OptionName->Coating,
    Default->Automatic,
    AllowNull->False,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if the ContainerOut should first be coated with a CoatingSolution before the cells are plated.",
    Category->"Coating"
  },
  {
    OptionName->CoatingSolution,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Sample],
        Object[Sample]
      }]
    ],
    Description->"The solution that is used to coat the ContainerOut.",
    Category->"Coating"
  },
  {
    OptionName->CoatingSolutionContainer,
    Default -> Automatic,
    ResolutionDescription -> "Automatically resolves to an Object[Container] if an Object[Sample] is specified. Otherwise, automatically resolves to a Model[Container] on any existing samples that can be used to fulfill the Model[Sample] request or based on the container that the default product for the Model[Sample] comes in.",
    AllowNull -> True,
    Widget -> Alternatives[
      "Existing Container"->Widget[
        Type -> Object,
        Pattern :> ObjectP[Object[Container]]
      ],
      "New Container"->Widget[
        Type -> Object,
        Pattern :> ObjectP[Model[Container]]
      ]
    ],
    Description -> "The container that the coating solution will be located in during the transfer.",
    Category->"Hidden"
  },
  {
    OptionName->CoatingVolume,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>GreaterP[0 Microliter],
      Units->Alternatives[Microliter, Milliliter]
    ],
    Description->"The amount of coating solution that should be applied to the ContainerOut.",
    Category->"Coating"
  },
  {
    OptionName->CoatingPipette,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Instrument, Pipette],
        Object[Instrument, Pipette]
      }]
    ],
    Description->"The pipette that will be used to transfer the CoatingSolution into the ContainerOut. If this pipette is the same model as the Pipette option, the same pipette will be used.",
    ResolutionDescription->"Automatically set based on the container of the CoatingSolution and the CoatingVolume specified.",
    Category->"Coating"
  },
  {
    OptionName->CoatingTips,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Item, Tips],
        Object[Item, Tips]
      }]
    ],
    Description->"The tips used to transfer the CoatingSolution into the ContainerOut.",
    ResolutionDescription->"Automatically set based on the container of the CoatingSolution and the CoatingVolume specified.",
    Category->"Coating"
  },
  ModifyOptions[
    SourceTemperatureOptions,
    SourceTemperature,
    {
      Description->"The temperature to heat/cool the coating solution to before the coating occurs.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the method for the cell line.",
      Category->"Coating"
    }
  ]/.{SourceTemperature->CoatingSolutionTemperature},
  ModifyOptions[
    SourceTemperatureOptions,
    SourceEquilibrationTime,
    {
      Description->"The duration of time for which the coating solution will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if CoatingSolutionTemperature is not set to Ambient.",
      Category->"Coating"
    }
  ]/.{SourceEquilibrationTime->CoatingSolutionEquilibrationTime},
  ModifyOptions[
    SourceTemperatureOptions,
    MaxSourceEquilibrationTime,
    {
      Description->"The maximum duration of time for which the samples will be heated/cooled to the target CoatingSolutionTemperature, if they do not reach the CoatingSolutionTemperature after CoatingSolutionEquilibrationTime.",
      ResolutionDescription -> "Automatically set to 30 Minute if CoatingSolutionTemperature is not set to Ambient.",
      Category->"Coating"
    }
  ]/.{MaxSourceEquilibrationTime->MaxCoatingSolutionEquilibrationTime},
  ModifyOptions[
    SourceTemperatureOptions,
    SourceEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the coating solution before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a CoatingSolutionTemperature is indicated.",
      Category->"Coating"
    }
  ]/.{SourceEquilibrationCheck->CoatingSolutionEquilibrationCheck},

  ModifyOptions[
    DestinationTemperatureOptions,
    DestinationTemperature,
    {
      Description->"The temperature to heat/cool the wash container to before the coating occurs.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the method for the cell line.",
      Category->"Coating"
    }
  ]/.{DestinationTemperature->CoatingContainerOutTemperature},
  ModifyOptions[
    DestinationTemperatureOptions,
    DestinationEquilibrationTime,
    {
      Description->"The duration of time for which the wash container will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if WashContainerTemperature is not set to Ambient.",
      Category->"Coating"
    }
  ]/.{DestinationEquilibrationTime->CoatingContainerOutEquilibrationTime},
  ModifyOptions[
    DestinationTemperatureOptions,
    MaxDestinationEquilibrationTime,
    {
      Description->"The maximum duration of time for which the wash container will be heated/cooled to the target WashContainerTemperature, if they do not reach the WashContainerTemperature after WashContainerEquilibrationTime.",
      ResolutionDescription -> "Automatically set to 30 Minute if WashContainerTemperature is not set to Ambient.",
      Category->"Coating"
    }
  ]/.{MaxDestinationEquilibrationTime->MaxCoatingContainerOutEquilibrationTime},
  ModifyOptions[
    DestinationTemperatureOptions,
    DestinationEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the wash container before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a WashContainerTemperature is indicated.",
      Category->"Coating"
    }
  ]/.{DestinationEquilibrationCheck->CoatingContainerOutEquilibrationCheck},

  {
    OptionName->CoatingSolutionAspirationMix,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to True if any of the other CoatingSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if mixing should occur during aspiration from the coating solution.",
    Category->"Coating"
  },
  {
    OptionName->CoatingSolutionAspirationMixType,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to Pipette if any of the other CoatingSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>TransferMixTypeP
    ],
    Description->"The type of mixing that should occur during aspiration from the coating solution.",
    Category->"Coating"
  },
  {
    OptionName->NumberOfCoatingSolutionAspirationMixes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 5 if any of the other CoatingSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the coating solution should be mixed during aspiration.",
    Category->"Coating"
  },
  {
    OptionName->CoatingSolutionDispenseMix,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to True if any of the other CoatingSolutionDispenseMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if mixing should occur after the cells are dispensed into the coating solution.",
    Category->"Coating"
  },
  {
    OptionName->CoatingSolutionDispenseMixType,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to Pipette if any of the other CoatingSolutionDispenseMix options are set and we're using a pipette to do the transfer. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>TransferMixTypeP
    ],
    Description->"The type of mixing that should occur after the cells are dispensed into the coating solution.",
    Category->"Coating"
  },
  {
    OptionName->NumberOfCoatingSolutionDispenseMixes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 5 if any of the other CoatingSolutionDispenseMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the cell/coating solution suspension should be mixed after dispension.",
    Category->"Coating"
  },

  {
    OptionName->CoatingSolutionIncubation,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if the cells should be incubated and/or mixed after the coating solution is added.",
    ResolutionDescription->"Automatically set to True if Coating is turned on (defaults to incubation at 37 Celsius for 5 minutes).",
    Category->"Coating"
  },
  {
    OptionName -> CoatingSolutionIncubationInstrument,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[
      Type->Object,
      Pattern :> ObjectP[
        {
          Model[Instrument,Shaker],
          Object[Instrument,Shaker],
          Model[Instrument,HeatBlock],
          Object[Instrument,HeatBlock],
          Model[Instrument,BiosafetyCabinet],
          Object[Instrument,BiosafetyCabinet],
          Model[Instrument,Incubator],
          Object[Instrument,Incubator],
          Model[Instrument,Refrigerator],
          Object[Instrument,Refrigerator]
        }
      ]
    ],
    Description -> "The instrument used to perform the Mixing and/or Incubation of the CoatingSolution.",
    ResolutionDescription -> "Automatically sets based on the options Mix, Temperature, MixType and container of the sample.",
    Category->"Coating"
  },
  {
    OptionName->CoatingSolutionIncubationTime,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
    Description->"The amount of time that the cells should be incubated/mixed with the coating solution.",
    ResolutionDescription->"Automatically sets based on the CoatingSolutionMixType and the WashContainer.",
    Category->"Coating"
  },
  (* NOTE: We're only allowing for shaking and heat blocks here so the temperature range is lowered. *)
  {
    OptionName->CoatingSolutionIncubationTemperature,
    Default->Automatic,
    AllowNull->True,
    Widget->Alternatives[
      Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, 180 Celsius],Units :> Celsius],
      Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
    ],
    Description->"The temperature of the mix instrument while mixing/incubating the cells with the coating solution.",
    ResolutionDescription->"Automatically sets based on the CoatingSolutionMixType and the WashContainer.",
    Category->"Coating"
  },
  {
    OptionName -> CoatingSolutionMix,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
    Description -> "Indicates if this cells and coating solution should be mixed during CoatingSolutionIncubation.",
    ResolutionDescription -> "Automatically set based on any coating solution mixing options that are set.",
    Category->"Coating"
  },
  (* NOTE: We do NOT allow all mix types here because not all make sense for mixing cell samples during coating. *)
  {
    OptionName -> CoatingSolutionMixType,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake]],
    Description -> "Indicates the style of motion used to mix the sample.",
    ResolutionDescription -> "Automatically sets based on the container of the sample and the Mix option.",
    Category->"Coating"
  },
  (* NOTE: The only MixRate related mixing that we're allowing for here is Shake -- which has a range of 35-1800 RPM. *)
  {
    OptionName -> CoatingSolutionMixRate,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[Type -> Quantity, Pattern :> RangeP[35 RPM, 1800 RPM], Units->RPM],
    Description -> "Frequency of rotation of the mixing instrument should use to mix the cells/coating solution.",
    ResolutionDescription -> "Automatically set based on the CoatingSolutionIncubationInstrument and CoatingSolutionMixType selected.",
    Category->"Coating"
  }
}];

DefineOptionSet[CoatingWashOptions:>Evaluate@{
  (* -- COATING WASH -- *)
  {
    OptionName->CoatingWash,
    Default->Automatic,
    AllowNull->False,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if the ContainerOut should be washed with a CoatingWashSolution after it has been Coated and before the cells are plated.",
    Category->"Coating Wash"
  },
  {
    OptionName->CoatingWashSolution,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Sample],
        Object[Sample]
      }]
    ],
    Description->"The solution that is used to wash the ContainerOut, after it has been coated.",
    Category->"Coating Wash"
  },
  {
    OptionName->CoatingWashSolutionContainer,
    Default -> Automatic,
    ResolutionDescription -> "Automatically resolves to an Object[Container] if an Object[Sample] is specified. Otherwise, automatically resolves to a Model[Container] on any existing samples that can be used to fulfill the Model[Sample] request or based on the container that the default product for the Model[Sample] comes in.",
    AllowNull -> True,
    Widget -> Alternatives[
      "Existing Container"->Widget[
        Type -> Object,
        Pattern :> ObjectP[Object[Container]]
      ],
      "New Container"->Widget[
        Type -> Object,
        Pattern :> ObjectP[Model[Container]]
      ]
    ],
    Description -> "The container that the coating wash solution will be located in during the transfer.",
    Category->"Hidden"
  },
  {
    OptionName->CoatingWashVolume,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>GreaterP[0 Microliter],
      Units->Alternatives[Microliter, Milliliter]
    ],
    Description->"The amount of CoatingWash solution that should be applied to the ContainerOut.",
    Category->"Coating Wash"
  },
  {
    OptionName->CoatingWashPipette,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Instrument, Pipette],
        Object[Instrument, Pipette]
      }]
    ],
    Description->"The pipette that will be used to transfer the CoatingWashSolution into the ContainerOut. If this pipette is the same model as the Pipette option, the same pipette will be used.",
    ResolutionDescription->"Automatically set based on the container of the CoatingWashSolution and the CoatingWashVolume specified.",
    Category->"Coating Wash"
  },
  {
    OptionName->CoatingWashTips,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Item, Tips],
        Object[Item, Tips]
      }]
    ],
    Description->"The tips used to transfer the CoatingWashSolution into the ContainerOut.",
    ResolutionDescription->"Automatically set based on the container of the CoatingWashSolution and the CoatingWashVolume specified.",
    Category->"Coating Wash"
  },
  ModifyOptions[
    SourceTemperatureOptions,
    SourceTemperature,
    {
      Description->"The temperature to heat/cool the CoatingWashSolution to before the CoatingWash occurs.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the method for the cell line.",
      Category->"Coating Wash"
    }
  ]/.{SourceTemperature->CoatingWashSolutionTemperature},
  ModifyOptions[
    SourceTemperatureOptions,
    SourceEquilibrationTime,
    {
      Description->"The duration of time for which the CoatingWashSolution will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if CoatingWashSolutionTemperature is not set to Ambient.",
      Category->"Coating Wash"
    }
  ]/.{SourceEquilibrationTime->CoatingWashSolutionEquilibrationTime},
  ModifyOptions[
    SourceTemperatureOptions,
    MaxSourceEquilibrationTime,
    {
      Description->"The maximum duration of time for which the samples will be heated/cooled to the target CoatingWashSolutionTemperature, if they do not reach the CoatingWashSolutionTemperature after CoatingWashSolutionEquilibrationTime.",
      ResolutionDescription -> "Automatically set to 30 Minute if CoatingWashSolutionTemperature is not set to Ambient.",
      Category->"Coating Wash"
    }
  ]/.{MaxSourceEquilibrationTime->MaxCoatingWashSolutionEquilibrationTime},
  ModifyOptions[
    SourceTemperatureOptions,
    SourceEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the CoatingWash solution before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a CoatingWashSolutionTemperature is indicated.",
      Category->"Coating Wash"
    }
  ]/.{SourceEquilibrationCheck->CoatingWashSolutionEquilibrationCheck},

  ModifyOptions[
    DestinationTemperatureOptions,
    DestinationTemperature,
    {
      Description->"The temperature to heat/cool the wash container to before the CoatingWash occurs.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the method for the cell line.",
      Category->"Coating Wash"
    }
  ]/.{DestinationTemperature->CoatingWashContainerOutTemperature},
  ModifyOptions[
    DestinationTemperatureOptions,
    DestinationEquilibrationTime,
    {
      Description->"The duration of time for which the wash container will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if WashContainerTemperature is not set to Ambient.",
      Category->"Coating Wash"
    }
  ]/.{DestinationEquilibrationTime->CoatingWashContainerOutEquilibrationTime},
  ModifyOptions[
    DestinationTemperatureOptions,
    MaxDestinationEquilibrationTime,
    {
      Description->"The maximum duration of time for which the wash container will be heated/cooled to the target WashContainerTemperature, if they do not reach the WashContainerTemperature after WashContainerEquilibrationTime.",
      ResolutionDescription -> "Automatically set to 30 Minute if WashContainerTemperature is not set to Ambient.",
      Category->"Coating Wash"
    }
  ]/.{MaxDestinationEquilibrationTime->MaxCoatingWashContainerOutEquilibrationTime},
  ModifyOptions[
    DestinationTemperatureOptions,
    DestinationEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the wash container before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a WashContainerTemperature is indicated.",
      Category->"Coating Wash"
    }
  ]/.{DestinationEquilibrationCheck->CoatingWashContainerOutEquilibrationCheck},

  {
    OptionName->CoatingWashSolutionAspirationMix,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to True if any of the other CoatingWashSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if mixing should occur during aspiration from the CoatingWash solution.",
    Category->"Coating Wash"
  },
  {
    OptionName->CoatingWashSolutionAspirationMixType,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to Pipette if any of the other CoatingWashSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>TransferMixTypeP
    ],
    Description->"The type of mixing that should occur during aspiration from the CoatingWash solution.",
    Category->"Coating Wash"
  },
  {
    OptionName->NumberOfCoatingWashSolutionAspirationMixes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 5 if any of the other CoatingWashSolutionAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the CoatingWash solution should be mixed during aspiration.",
    Category->"Coating Wash"
  },
  {
    OptionName->CoatingWashSolutionDispenseMix,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to True if any of the other CoatingWashSolutionDispenseMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if mixing should occur after the CoatingWashSolution is dispensed into the ContainerOut.",
    Category->"Coating Wash"
  },
  {
    OptionName->CoatingWashSolutionDispenseMixType,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to Pipette if any of the other CoatingWashSolutionDispenseMix options are set and we're using a pipette to do the transfer. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>TransferMixTypeP
    ],
    Description->"The type of mixing that should occur after the CoatingWashSolution is dispensed into the ContainerOut.",
    Category->"Coating Wash"
  },
  {
    OptionName->NumberOfCoatingWashSolutionDispenseMixes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 5 if any of the other CoatingWashSolutionDispenseMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the CoatingWashSolution should be mixed after the CoatingWashSolution is dispensed into the ContainerOut.",
    Category->"Coating Wash"
  },

  {
    OptionName->CoatingWashSolutionIncubation,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if the cells should be incubated and/or mixed after the CoatingWash solution is added.",
    ResolutionDescription->"Automatically set to True if CoatingWash is turned on (defaults to 3 swirls).",
    Category->"Coating Wash"
  },
  {
    OptionName -> CoatingWashSolutionIncubationInstrument,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[
      Type->Object,
      Pattern :> ObjectP[
        {
          Model[Instrument,Shaker],
          Object[Instrument,Shaker],
          Model[Instrument,HeatBlock],
          Object[Instrument,HeatBlock]
        }
      ]
    ],
    Description -> "The instrument used to perform the Mixing and/or Incubation of the CoatingWashSolution.",
    ResolutionDescription -> "Automatically sets based on the options Mix, Temperature, MixType and container of the sample.",
    Category->"Coating Wash"
  },
  {
    OptionName->CoatingWashSolutionIncubationTime,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
    Description->"The amount of time that coated ContainerOut should be incubated with the CoatingWash solution.",
    ResolutionDescription->"Automatically sets based on the CoatingWashSolutionMixType and the WashContainer.",
    Category->"Coating Wash"
  },
  (* NOTE: We're only allowing for shaking and heat blocks here so the temperature range is lowered. *)
  {
    OptionName->CoatingWashSolutionIncubationTemperature,
    Default->Automatic,
    AllowNull->True,
    Widget->Alternatives[
      Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, 180 Celsius],Units :> Celsius],
      Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
    ],
    Description->"The temperature of the mix instrument while mixing/incubating the coated ContainerOut with the CoatingWash solution.",
    ResolutionDescription->"Automatically sets based on the CoatingWashSolutionMixType and the WashContainer.",
    Category->"Coating Wash"
  },
  {
    OptionName -> CoatingWashSolutionMix,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
    Description -> "Indicates if this ContainerOut/CoatingWashSolution should be mixed during CoatingWashSolutionIncubation.",
    ResolutionDescription -> "Automatically set based on any CoatingWash solution mixing options that are set.",
    Category->"Coating Wash"
  },
  (* NOTE: We do NOT allow all mix types here because not all make sense for mixing cell samples during CoatingWash. *)
  {
    OptionName -> CoatingWashSolutionMixType,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake]],
    Description -> "Indicates the style of motion used to mix the ContainerOut/CoatingWashSolution.",
    ResolutionDescription -> "Automatically sets based on the container of the sample and the Mix option.",
    Category->"Coating Wash"
  },
  (* NOTE: The only MixRate related mixing that we're allowing for here is Shake -- which has a range of 35-1800 RPM. *)
  {
    OptionName -> CoatingWashSolutionMixRate,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[Type -> Quantity, Pattern :> RangeP[35 RPM, 1800 RPM], Units->RPM],
    Description -> "Frequency of rotation of the mixing instrument should use to mix the ContainerOut/CoatingWashSolution.",
    ResolutionDescription -> "Automatically set based on the CoatingWashSolutionIncubationInstrument and CoatingWashSolutionMixType selected.",
    Category->"Coating Wash"
  }
}];

DefineOptionSet[DryCoatingOptions:>Evaluate@{
  (* -- Dry coating -- *)
  {
    OptionName->AspirateFromCoatedContainer,
    Default->Automatic,
    AllowNull->False,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if any liquid is aspirated from the coated (and washed, if specified) plate.",
    ResolutionDescription->"Automatically set to False.",
    Category->"Dry Coating"
  },
  {
    OptionName->DryCoating,
    Default->Automatic,
    AllowNull->False,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if the coated plate is left drying for a period of time.",
    ResolutionDescription->"Automatically set to False.",
    Category->"Dry Coating"
  },
  {
    OptionName->DryWithLidOpen,
    Default->Automatic,
    AllowNull->False,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if the lid of the coated plate ContainerOut is left open during drying of the plate. ",
    ResolutionDescription->"Automatically set to True if Drying Temperature is set to Ambient.",
    Category->"Dry Coating"
  },
  {
    OptionName->DryingTime,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
    Description->"The amount of time that coated ContainerOut is dried. Null or 0 Minute indicates the plate with liquid aspired will be immediately stored.",
    ResolutionDescription->"Automatically set to 30Minute if DryCoating is true.",
    Category->"Dry Coating"
  }
}];

DefineOptionSet[CoatedContainerStorageOption:>Evaluate@{

  {
    OptionName->CoatedContainerStorageCondition,
    Default->Null,
    Description->"The condition under which the coated (and washed) ContainerOut is temporarily stored until cells are plated. Ambient or Null indicates the coated plate is left in the TransferEnvironment until used.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>SampleStorageTypeP
    ],
    Category->"Coated Plate Storage"
  }
}];

DefineOptionSet[AddMediaOptions:>Evaluate@{
  (* -- MEDIA ADDITION AND PLATING -- *)
  {
    OptionName->AddMedia,
    Default->True,
    AllowNull->False,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if fresh media should be added to the container where the sample is located before plating.",
    ResolutionDescription->"Automatically set to True if Washing is immediately before Quantification and Plating.",
    Category->"Media Addition and Plating"
  },
  {
    OptionName->PelletBeforeAddingMedia,
    Default->Automatic,
    AllowNull->False,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if the cell suspension is centrifuged, and supernatent aspirated before Media is added to resuspend the cells.",
    ResolutionDescription->"Automatically set to True if Dissociation is True. Set to False if performing SplitCells for AdherentCells.",
    Category->"Dissociation"
  },
  {
    OptionName->Media,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Sample],
        Object[Sample]
      }]
    ],
    Description->"The media that is used to grow the washed/media-changed/split/aliquoted cells.",
    ResolutionDescription->"Automatically set to an appropriate media for the cell type given.",
    Category->"Media Addition and Plating"
  },
  {
    OptionName->MediaContainer,
    Default -> Automatic,
    ResolutionDescription -> "Automatically resolves to an Object[Container] if an Object[Sample] is specified. Otherwise, automatically resolves to a Model[Container] on any existing samples that can be used to fulfill the Model[Sample] request or based on the container that the default product for the Model[Sample] comes in.",
    AllowNull -> True,
    Widget -> Alternatives[
      "Existing Container"->Widget[
        Type -> Object,
        Pattern :> ObjectP[Object[Container]]
      ],
      "New Container"->Widget[
        Type -> Object,
        Pattern :> ObjectP[Model[Container]]
      ]
    ],
    Description -> "The container that the media will be located in during the transfer.",
    Category->"Hidden"
  },
  {
    OptionName->MediaVolume,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>GreaterP[0 Milliliter],
      Units->Alternatives[Microliter, Milliliter]
    ],
    Description->"The amount of media that should be used to plate the cells.",
    ResolutionDescription->"Automatically set to a volume that will cover the bottom of the chosen ContainerOut.",
    Category->"Media Addition and Plating",
    NestedIndexMatching->True
  },
  {
    OptionName->MediaPipette,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Instrument, Pipette],
        Object[Instrument, Pipette]
      }]
    ],
    Description->"The pipette that will be used to transfer the media/washed cells into the ContainerOut. If this pipette is the same model as the Pipette option, the same pipette will be used.",
    ResolutionDescription->"Automatically set based on the WashContainer, Media, and the MediaVolume specified.",
    Category->"Media Addition and Plating"
  },
  {
    OptionName->MediaTips,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Object,
      Pattern:>ObjectP[{
        Model[Item, Tips],
        Object[Item, Tips]
      }]
    ],
    Description->"The tips used to transfer the Media into the ContainerOut.",
    ResolutionDescription->"Automatically set based on the WashContainer, Media, and the MediaVolume specified.",
    Category->"Media Addition and Plating"
  },
  ModifyOptions[
    SourceTemperatureOptions,
    SourceTemperature,
    {
      Description->"The temperature to heat/cool the media to before the washing occurs.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the parameters for the cell line.",
      Category->"Media Addition and Plating"
    }
  ]/.{SourceTemperature->MediaTemperature},
  ModifyOptions[
    SourceTemperatureOptions,
    SourceEquilibrationTime,
    {
      Description->"The duration of time for which the media will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if MediaTemperature is not set to Ambient.",
      Category->"Media Addition and Plating"
    }
  ]/.{SourceEquilibrationTime->MediaEquilibrationTime},
  ModifyOptions[
    SourceTemperatureOptions,
    MaxSourceEquilibrationTime,
    {
      Description->"The maximum duration of time for which the media will be heated/cooled to the target MediaTemperature, if they do not reach the MediaTemperature after MediaEquilibrationTime.",
      ResolutionDescription -> "Automatically set to 30 Minute if MediaTemperature is not set to Ambient.",
      Category->"Media Addition and Plating"
    }
  ]/.{MaxSourceEquilibrationTime->MaxMediaEquilibrationTime},
  ModifyOptions[
    SourceTemperatureOptions,
    SourceEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the media before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a MediaTemperature is indicated.",
      Category->"Media Addition and Plating"
    }
  ]/.{SourceEquilibrationCheck->MediaEquilibrationCheck},

  ModifyOptions[
    DestinationTemperatureOptions,
    DestinationTemperature,
    {
      Description->"The temperature to heat/cool the ContainerOut to before the washing occurs.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the washing method for the cell line.",
      Category->"Media Addition and Plating"
    }
  ]/.{DestinationTemperature->ContainerOutTemperature},
  ModifyOptions[
    DestinationTemperatureOptions,
    DestinationEquilibrationTime,
    {
      Description->"The duration of time for which the ContainerOut will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if ContainerOutTemperature is not set to Ambient.",
      Category->"Media Addition and Plating"
    }
  ]/.{DestinationEquilibrationTime->ContainerOutEquilibrationTime},
  ModifyOptions[
    DestinationTemperatureOptions,
    MaxDestinationEquilibrationTime,
    {
      Description->"The maximum duration of time for which the ContainerOut will be heated/cooled to the target ContainerOutTemperature, if they do not reach the ContainerOutTemperature after ContainerOutEquilibrationTime.",
      ResolutionDescription -> "Automatically set to 30 Minute if ContainerOutTemperature is not set to Ambient.",
      Category->"Media Addition and Plating"
    }
  ]/.{MaxDestinationEquilibrationTime->MaxContainerOutEquilibrationTime},
  ModifyOptions[
    DestinationTemperatureOptions,
    DestinationEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the ContainerOut before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a ContainerOutTemperature is indicated.",
      Category->"Media Addition and Plating"
    }
  ]/.{DestinationEquilibrationCheck->ContainerOutEquilibrationCheck},
  {
    OptionName->MediaAspirationMix,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to True if any of the other MediaAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if mixing should occur during aspiration from the original media container.",
    Category->"Media Addition and Plating"
  },
  {
    OptionName->MediaAspirationMixType,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to Pipette if any of the other MediaAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>TransferMixTypeP
    ],
    Description->"The type of mixing that should occur during aspiration from the original media container.",
    Category->"Media Addition and Plating"
  },
  {
    OptionName->NumberOfMediaAspirationMixes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 5 if any of the other MediaAspirationMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the media should be mixed during aspiration.",
    Category->"Media Addition and Plating"
  },
  {
    OptionName->MediaDispenseMix,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to True if any of the other MediaDispenseMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>BooleanP
    ],
    Description->"Indicates if mixing should occur after the media is dispensed into the washed cells.",
    Category->"Media Addition and Plating"
  },
  {
    OptionName->MediaDispenseMixType,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to Pipette if any of the other MediaDispenseMix options are set and we're using a pipette to do the transfer. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>TransferMixTypeP
    ],
    Description->"The type of mixing that should occur after the media is dispensed into the washed cells.",
    Category->"Media Addition and Plating"
  },
  {
    OptionName->NumberOfMediaDispenseMixes,
    Default->Automatic,
    ResolutionDescription -> "Automatically sets to 5 if any of the other MediaDispenseMix options are set. Otherwise, sets to Null.",
    AllowNull->True,
    Widget->Widget[
      Type->Number,
      Pattern:>RangeP[0, 50, 1]
    ],
    Description->"The number of times that the cell/media suspension should be mixed after dispension.",
    Category->"Media Addition and Plating"
  }
}];

(*QuantifyCells Options*)

DefineOptionSet[QuantifyCellsOptions:>Evaluate@{
    IndexMatching[
      IndexMatchingInput->"experiment samples",
    {
      OptionName->CellQuantification,
      Default->Automatic,
      AllowNull->False,
      Widget->Widget[
        Type->Enumeration,
        Pattern:>BooleanP
      ],
      Description->"Indicates if cell number per volume is counted experimentally.",
      ResolutionDescription->"Automatically set to True when NumberOfCells or CellConcentration are specified.",
      Category->"Quantification"
    },
      {
        OptionName->QuantificationType, (*TODO: only LiveDead and CellCount if SplitCells or AliquotCells*)
        Default->Automatic,
        Description -> "Indicates purpose of the quantification such as to count cells or to analyze other aspects of microscopic images. CellCount: the number of cells without live-dead dye. Turbidity: the opaqueness of a cell suspension solution measured with Nephlometer or Spectrometer. Confluency: the area of tissue culture surface that is covered by cells. Circularity: how close the shape of each cell is to a circle, Area: the size of cell that covers the tissue culture container surface. Fluorescence: the fluorescent intensity of cell samples. LiveDead: the living cell- dead cell ratio.",
        ResolutionDescription -> "Automatically set to CellCount if NumberOfCells or CellConcentration is specified for SplitCells or AliquotCells. In SplitCells and AliquotCells, only LiveDead, CellCount, and Turbidity are allowed",
        AllowNull->True,
        Widget->Widget[Type->Enumeration,Pattern:>Alternatives[CellCount,Turbidity,LiveDead,Confluency,Circularity,Area,Fluorescence]],
        Category->"Quantification"
      },
      {
        OptionName->QuantificationMethod,
        Default->Automatic,
        Description -> "The way cell number per volume is counted or microscopic images are analysized. Hemocytometer: using images acquired with a hemocytometer under a microscope for CellCount and LiveDead quantifcation. FlowCytometry, using data acquired with a flow-cytometer for CellCount and LiveDead quantifications. Microscope: using images of cells in their original tissue-culture containers acquired under a microscope for CellCount, LiveDead, Confluency, Circularity, Area,or Fluorescence quantifications. Nephlometer: using a nephlometer for Turbidity quantification of cell suspensions. Nephlometer: using a spectrometer for Turbidity quantification of cell suspensions.",
        ResolutionDescription -> "Automatically set to Hemocytometer if NumberOfCells or CellConcentration is specified for SplitCells or AliquotCells. Otherwise set to Microscope",
        AllowNull->True,
        Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Hemocytometer,FlowCytometer,Microscope,Nephlometer,Spectrometer]], (*TODO: Add ExperiemntNephlometry and ExperimentAbsorbanceIntensity options*)
        Category->"Quantification"
      },
      {
        OptionName->QuantificationInstrument,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            Model[Instrument,Microscope],
            Object[Instrument,Microscope],
            Model[Instrument, FlowCytometer],
            Object[Instrument, FlowCytometer],
            Model[Instrument, PlateReader],
            Object[Instrument, PlateReader]
          }]
        ],
        Description->"The microscope, flow cytometer, or plate reader to be used for cell quantification.",
        ResolutionDescription->"Automatically set to an instrument compatible with QuantificationMethod.",
        Category->"Quantification"
      },

      (*Quantification resuspension*)
      {
        OptionName->QuantificationResuspension,
        Default->True,
        AllowNull->False,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>BooleanP
        ],
        Description->"Indicates if cells should be pelleted, supernatant aspirated, and fresh media added to the container and mixed where the sample is located before Quantification.",
        ResolutionDescription->"Automatically set to True if CellQuantification is True.",
        Category->"Quantification"
      },
      {
        OptionName->ResuspensionSolution,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            Model[Sample],
            Object[Sample]
          }]
        ],
        Description->"The solution that is used to resuspend cells for quantification. Media will be added in addition to this solution after quantification and before cells are transfered to ContainerOut (if needed).",
        ResolutionDescription->"Automatically set to the PreferredLiquidMedia for the cell type given if Quantification is True.",
        Category->"Quantification"
      },
      {
        OptionName->ResuspensionVolume,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0 Milliliter,20Liter], (*TODO:$MaxTransferVolume*)
          Units->Alternatives[Microliter, Milliliter]
        ],
        Description->"The amount of ResuspensionSolution that should be used to resuspend the cells.",
        ResolutionDescription->"When Quantification is True, automatically set to 1 Milliliter or 25% of the container's MaxVolume (AliquotContainer, or StrainingContainer is Straining is True), whichever is lower.",
        Category->"Quantification",
        NestedIndexMatching->True
      },
      {
        OptionName->ResuspensionPipette,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            Model[Instrument, Pipette],
            Object[Instrument, Pipette]
          }]
        ],
        Description->"The pipette that will be used to transfer ResuspensionSolution into the cell pellet.",
        ResolutionDescription->"Automatically set based on the ResuspensionVolume: 1-2.5ul: \"Eppendorf Research Plus P2.5, Tissue Culture\", 2.5-20ul: \"Eppendorf Research Plus P20, Tissue Culture\", 20-200ul: \"Eppendorf Research Plus P200, Tissue Culture\", 200-1000ul: \"Eppendorf Research Plus P1000, Tissue Culture\", >1000ul: \"pipetus, Tissue Culture\".",
        Category->"Quantification"
      },
      {
        OptionName->ResuspensionTips,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            Model[Item, Tips],
            Object[Item, Tips]
          }]
        ],
        Description->"The pipette tips that will be used to transfer ResuspensionSolution into the cell pellet.",
        ResolutionDescription->"Automatically set based on the QuantificationResuspensionVolume specified: 1-2.5ul: \"10 uL reach tips, sterile\", 2.5-20ul: \"20 uL barrier tips, sterile\", 20-200ul: \"200 uL tips, sterile\", 200-1000ul: \"1000 uL reach tips, sterile\", 1-5ml: \"5 mL plastic barrier serological pipets, sterile\". 5-10ml: \"10 mL plastic barrier serological pipets, sterile\". 10-25ml: \"25 mL plastic barrier serological pipets, sterile\". 25-50ml: \"50 mL plastic barrier serological pipets, sterile\".",
        Category->"Quantification"
      },
      {
        OptionName->PreResuspensionMix,
        Default->Automatic,
        ResolutionDescription -> "Automatically set to True if any PreResuspensionMix options are set. Otherwise, sets to Null.",
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>BooleanP
        ],
        Description->"Indicates if ResuspensionSolution is mixed immediately prior to being drawn into ResuspensionTips.",
        Category->"Quantification"
      },
      {
        OptionName->PreResuspensionMixType,
        Default->Automatic,
        ResolutionDescription -> "Automatically sets to Pipette if any of PreResuspensionMix options is set. Otherwise, sets to Null.",
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>TransferMixTypeP
        ],
        Description->"The type of mixing that should occur during aspirating ResuspensionSolution from the original container. If specified as Pipette, mixing will occure during aspiration with the same tip and pipette; otherwise, mixing occures before pelleting.",
        Category->"Quantification"
      },
      {
        OptionName->NumberOfPreResuspensionMixes,
        Default->Automatic,
        ResolutionDescription -> "Automatically sets to 5 if any of PreResuspensionMix options is set. Otherwise, sets to Null.",
        AllowNull->True,
        Widget->Widget[
          Type->Number,
          Pattern:>RangeP[0, 50, 1]
        ],
        Description->"The number of times that the ResuspensionSolution should be mixed during aspiration.",
        Category->"Quantification"
      },
      (*TODO: add other mixing options here and all other mixing places*)
      {
        OptionName->PostResuspensionMix,
        Default->Automatic,
        ResolutionDescription -> "Automatically sets to True if any of the other PostResuspensionMix options are set. Otherwise, sets to Null.",
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>BooleanP
        ],
        Description->"Indicates if mixing should occur immediately after ResuspensionSolution is dispensed into the cells pellet",
        Category->"Quantification"
      },
      {
        OptionName->PostResuspensionMixType,
        Default->Automatic,
        ResolutionDescription -> "Automatically sets to Pipette if any of the other PostResuspensionMix options are set. Otherwise, sets to Null.",
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>TransferMixTypeP
        ],
        Description->"The type of mixing that should occur after the media is dispensed into the cells. If specified as Pipette, mix will occur during dispensing with the same transfer pipette and tips. Otherwise, mixing will occur after transfer.",
        Category->"Quantification"
      },
      {
        OptionName->NumberOfPostResuspensionMixes,
        Default->Automatic,
        ResolutionDescription -> "Automatically sets to 5 if any of the other PostResuspensionMix options are set. Otherwise, sets to Null.",
        AllowNull->True,
        Widget->Widget[
          Type->Number,
          Pattern:>RangeP[0, 50, 1]
        ],
        Description->"The number of times that the cell/media suspension should be mixed after dispension.",
        Category->"Quantification"
      },
      ModifyOptions[
        SourceTemperatureOptions,
        SourceTemperature,
        {
          Description->"The temperature to heat/cool the ResuspensionSolution to before the resuspension occurs.",
          ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the resuspension method for the cell line.",
          Category->"Quantification"
        }
      ]/.{SourceTemperature->ResuspensionSolutionTemperature},
      ModifyOptions[
        SourceTemperatureOptions,
        SourceEquilibrationTime,
        {
          Description->"The duration of time for which the ResuspensionSolution will be heated/cooled to the target temperature.",
          ResolutionDescription -> "Automatically set to 5 Minute if ResuspensionSolutionTemperature is not set to Ambient/Null.",
          Category->"Quantification"
        }
      ]/.{SourceEquilibrationTime->ResuspensionSolutionEquilibrationTime},
      ModifyOptions[
        SourceTemperatureOptions,
        MaxSourceEquilibrationTime,
        {
          Description->"The maximum duration of time for which the samples will be heated/cooled to the target ResuspensionSolutionTemperature, if they do not reach the ResuspensionSolutionTemperature after ResuspensionSolutionEquilibrationTime.",
          ResolutionDescription -> "Automatically set to 30 Minute if ResuspensionSolutionTemperature is not set to Ambient/Null.",
          Category->"Quantification"
        }
      ]/.{MaxSourceEquilibrationTime->MaxResuspensionSolutionEquilibrationTime},
      ModifyOptions[
        SourceTemperatureOptions,
        SourceEquilibrationCheck,
        {
          Description->"The method by which to verify the temperature of the ResuspensionSolution before the transfer is performed.",
          ResolutionDescription -> "Automatically set to IRThermometer if a ResuspensionSolutionTemperature is indicated.",
          Category->"Quantification"
        }
      ]/.{SourceEquilibrationCheck->ResuspensionSolutionEquilibrationCheck},

      ModifyOptions[
        DestinationTemperatureOptions,
        DestinationTemperature,
        {
          Description->"The temperature to heat/cool the container to before the transfer occurs.",
          ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the resuspension method for the cell line.",
          Category->"Quantification"
        }
      ]/.{DestinationTemperature->ResuspensionContainerTemperature},
      ModifyOptions[
        DestinationTemperatureOptions,
        DestinationEquilibrationTime,
        {
          Description->"The duration of time for which the container where cells are resuspended will be heated/cooled to the target temperature.",
          ResolutionDescription -> "Automatically set to 5 Minute if ResuspensionContainerTemperature is not set to Ambient.",
          Category->"Quantification"
        }
      ]/.{DestinationEquilibrationTime->ResuspensionContainerEquilibrationTime},
      ModifyOptions[
        DestinationTemperatureOptions,
        MaxDestinationEquilibrationTime,
        {
          Description->"The maximum duration of time for which the resuspension container will be heated/cooled to the target ResuspensionContainerTemperature, if they do not reach the ResuspensionContainerTemperature after ResuspensionContainerEquilibrationTime.",
          ResolutionDescription -> "Automatically set to 30 Minute if ResuspensionContainerTemperature is not set to Ambient.",
          Category->"Quantification"
        }
      ]/.{MaxDestinationEquilibrationTime->MaxResuspensionContainerEquilibrationTime},
      ModifyOptions[
        DestinationTemperatureOptions,
        DestinationEquilibrationCheck,
        {
          Description->"The method by which to verify the temperature of the resuspension container before the transfer is performed.",
          ResolutionDescription -> "Automatically set to IRThermometer if a ResuspensionContainerTemperature is indicated.",
          Category->"Quantification"
        }
      ]/.{DestinationEquilibrationCheck->ResuspensionContainerEquilibrationCheck},


      (*Quantification main*)

    {
      OptionName->QuantificationDye,
      Default->Automatic,
      AllowNull->True,
      Widget->Widget[
        Type->Object,
        Pattern:>ObjectP[{
          Model[Sample],
          Object[Sample]
        }]
      ],
      Description->"The stain or label that is used to label desired cell types.",
      ResolutionDescription->"Automatically set to Model[Sample,\"10x TrypanBlue \"] when QuantificationMethod is Hemocytometer, and  Model[Sample,\"1000x DAPI \"] when QuantificationMethod is FlowCytometer.", (*TODO: figure out the working concentration for these dyes, make the objects and put them in an independent section in catalog.*)
      Category->"Quantification"
    },
    {
      OptionName->QuantificationDyeRatio,
      Default->Automatic,
      AllowNull->True,
      Widget->Widget[
        Type->Expression,
        Pattern:>RatioP,
        Size->Word
      ],
      Description->"The ratio of the volumes between the QuantificationDye the sample to be quantified.",
      ResolutionDescription->"Automatically set to the dilution ratio specified by QuantificationDye Model, defaulting to 1/2 if not specified in the Model.",
      Category->"Quantification"
    },
    {
      OptionName->QuantificationDyeVolume,
      Default->Automatic,
      AllowNull->True,
      Widget->Adder[
        Widget[
          Type->Quantity,
          Pattern:>RangeP[0 Milliliter, 50 Milliliter],
          Units->Alternatives[Microliter, Milliliter]
        ]
      ],
      Description->"The volume of QuantificationDye to be mixed with the sample aliquoted for quantification. QuantificationDyeVolume is combined with QuantificationSampleVolume and mixed prior to Hemocytometer or FlowCytometry quantification.",
      ResolutionDescription->"Automatically set to the volume to achieve QuantificationDyeRatio if QuantificationDye is specified.",
      Category->"Quantification"
    },
    {
      OptionName->QuantificationSampleVolume,
      Default->Automatic,
      AllowNull->True,
      Widget->Adder[
        Widget[
          Type->Quantity,
          Pattern:>RangeP[0 Milliliter, 50 Milliliter],
          Units->Alternatives[Microliter, Milliliter]
        ]
      ],
      Description->"The volume of cell suspension that will be used to quantify the cell sample. QuantificationDyeVolume is combined with QuantificationSampleVolume and mixed prior to Hemocytometer or FlowCytometry quantification.",
      ResolutionDescription->"Automatically set to 10 Microliter if QuantificationDye is specified and QuantificationMethod is Hemocytometer, to 1 Milliliter if QuantificationMethod is FlowCytometry.",
      Category->"Quantification"
    },
      (*ImageCells option*)
      (* --------------- *)
      (* Required Option *)
      (* --------------- *)
      {
        OptionName->ImagingMode,
        Default->Automatic,
        AllowNull->False,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>MicroscopeModeP
        ],
        Description->"The type of microscopy technique used to acquire an image of a sample. BrightField is the simplest type of microscopy technique that uses white light to illuminate the sample, resulting in an image in which the specimen is darker than the surrounding areas that are devoid of it. Bright-field microscopy is useful for imaging samples stained with dyes or samples with intrinsic colors. PhaseContrast microscopy increases the contrast between the sample and its background, allowing it to produce highly detailed images from living cells and transparent biological samples. The contrast is enhanced such that the boundaries of the sample and its structures appear much darker than the surrounding medium. Epifluorescence microscopy uses light at a specific wavelength range to excite a fluorophore of interest in the sample and capture the resulting emitted fluorescence to generate an image. ConfocalFluorescence microscopy employs a similar principle as Epifluorescence to illuminate the sample and capture the emitted fluorescence along with pinholes in the light path to block out-of-focus light in order to increase optical resolution. Confocal microscopy is often used to image thick samples or to clearly distinguish structures that vary in height along the z-axis.",
        ResolutionDescription->"Automatically set to Epifluorescence if any fluorophore is present in DetectionLabels Field of the sample's identity model. Otherwise, set to BrightField if DetectionLabels is an empty list.",
        Category->"Image Acquisition"
      },

      (* --------------- *)
      (* DetectionLabels *)
      (* --------------- *)
      {
        OptionName->ImagingDetectionLabels,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          Widget[
            Type->Object,
            Pattern:>ObjectP[Model[Molecule]]
          ],
          Adder[
            Widget[
              Type->Object,
              Pattern:>ObjectP[Model[Molecule]]
            ]
          ]
        ],
        Description->"Indicates the tags, including fluorescent or non-fluorescent chemical compounds or proteins, attached to the sample that will be imaged.",
        ResolutionDescription->"Automatically set to an object or a list of objects present in the DetectionLabels Field of the sample's identity model that does not exist in other AcquireImage primitives.",
        Category->"Image Acquisition"
      },

      (* ----------------------------------------------- *)
      (* General optics setup options for the microscope *)
      (* ----------------------------------------------- *)
      {
        (* Long Automatic: not resolved at experiment time. *)
        OptionName->ImagingFocalHeight,
        Default->Automatic,
        AllowNull->False,
        Widget->Alternatives[
          Widget[
            Type->Quantity,
            Pattern:>GreaterP[0 Millimeter], (*TODO: find out what is the max*)
            Units->Alternatives[Micrometer,Millimeter]
          ],
          Widget[
            Type->Enumeration,
            Pattern:>Alternatives[Autofocus,Manual]
          ]
        ],
        Description->"The distance between the top of the objective lens and the bottom of the sample when the imaging plane is in focus. If set to Autofocus, the microscope will obtain a small stack of images along the z-axis of the sample and determine the best focal plane based on the image in the stack that shows the highest contrast. FocalHeight is then calculated from the location of the best focal plane on the z-axis. If set to Manual, the FocalHeight will be adjutsted manually.",
        ResolutionDescription->"Automatically set to Autofocus if the selected instrument supports autofocusing. Otherwise, set to Manual.",
        Category->"Image Acquisition"
      },
      {
        (* Long Automatic: not resolved at experiment time. *)
        OptionName->ImagingExposureTime,
        Default->AutoExpose,
        AllowNull->False,
        Widget->Alternatives[
          Widget[
            Type->Quantity,
            Pattern:>GreaterP[0 Millisecond], (*TODO: find out what is the max*)
            Units->Alternatives[Microsecond,Millisecond,Second]
          ],
          Widget[
            Type->Enumeration,
            Pattern:>Alternatives[AutoExpose]
          ]
        ],
        Description->"The length of time that the camera collects the signal from the sample. The longer the exposure time, the more photons the detector can collect, resulting in a brighter image. Selecting AutoExpose will prevent the pixels from becoming saturated by allowing the microscope software to determine the exposure time such that the brightest pixel is 75% of the maximum gray level that the camera can obtain.",
        Category->"Image Acquisition"
      },
      {
        OptionName->TargetMaxImagingIntensity,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Number,
          Pattern:>RangeP[0,65535]
        ],
        Description->"Specifies the intensity that the instrument should attempt to attain for the brightest pixel in the image to be acquired. Maximum intensity is defined as 2^16-1.",
        ResolutionDescription->"Automatically set to 33000 if ExposureTime is set to Automatic.",
        Category->"Image Acquisition"
      },



      (* --------------------- *)
      (* Fluorescence Settings *)
      (* --------------------- *)
      {
        OptionName->ImagingChannel,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>MicroscopeImagingChannelP
        ],
        Description->"Indicates the imaging channel pre-defined by the instrument that should be used to acquire images from the sample.",
        ResolutionDescription->"If none of the options in Fluorescence Imaging or BrightField and PhaseContrast Imaging is specified, automatically set to the instrument's imaging channel with ExcitationWavelength and EmissionWavelength capable if illuminating and detecting signal from DetectionLabels.",
        Category->"Image Acquisition"
      },
      {
        OptionName->ImagingExcitationWavelength,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0 Nanometer,1200 Nanometer],
          Units->Nanometer
        ],
        Description->"The wavelength of excitation light used to illuminate the sample when imaging with ConfocalFluorescence or Epifluorescence Mode.",
        ResolutionDescription->"Automatically set to the wavelength capable of exciting the DetectionLabels.",
        Category->"Image Acquisition"
      },
      {
        OptionName->ImagingEmissionWavelength,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0 Nanometer,1200 Nanometer],
          Units->Nanometer
        ],
        Description->"The wavelength at which the fluorescence emission of the DetectionLabels should be imaged.",
        ResolutionDescription->"Automatically set to the wavelength closest to the fluorescence emission wavelength of the DetectionLabels.",
        Category->"Image Acquisition"
      },
      {
        OptionName->ImagingExcitationPower,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0 Percent,100 Percent],
          Units->Percent
        ],
        Description->"The percent of maximum intensity of the light source that should be used to illuminate the sample. Higher intensity will excite more fluorescent molecules in the sample, resulting in more signal being produced, but will also increase the chance of bleaching the fluorescent molecules.",
        ResolutionDescription->"Set to 100% if ImagingMode is ConfocalFluorescence or Epifluorescence but not on a high content imager. Set to 20% if if ImagingMode is ConfocalFluorescence or Epifluorescence and a high content imager is selected as instrument. Otherwise set to Null.", (*TODO: clarify with varoth*)
        Category->"Image Acquisition"
      },
      {
        OptionName->ImagingDichroicFilterWavelength,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0 Nanometer,1200 Nanometer],
          Units->Nanometer
        ],
        Description->"Specifies the wavelength that should be passed by the filter to illuminate the sample and excite the DetectionLabels.",
        ResolutionDescription->"Automatically set to wavelength closest to the fluorescence excitation wavelength of the DetectionLabels.", (*TODO: clarify with varoth-- should it be in between?*)
        Category->"Image Acquisition"
      },
      {
        OptionName->ImageCorrection,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>MicroscopeImageCorrectionP
        ],
        Description->"The correction step(s) that will be automatically applied to the image. BackgroundCorrection removes stray light that is unrelated to light that reaches the sample. ShadingCorrection mitigates the uneven illumination of the sample that is visible around the edges of the image.",
        ResolutionDescription->"Automatically apply both BackgroundCorrection AND ShadingCorrection to the image if the high content imager is selected as Instrument and Mode is either ConfocalFluorescence or Epifluorescence. Otherwise, set to ShadingCorrection when Mode is BrightField.",
        Category->"Image Acquisition"
      },
      {
        OptionName->ImageDeconvolution,
        Default->False,
        AllowNull->False,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>BooleanP
        ],
        Description->"Indicates if a deconvolution algorithm should be used to enhance contrast, improve image resolution, and sharpen the image.",
        Category->"Image Acquisition"
      },
      {
        OptionName->ImageDeconvolutionKFactor,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Number,
          Pattern:>RangeP[0,2]
        ],
        Description->"Specifies the factor used by the Wiener Filter in the deconvolution algorithm to determine image sharpness. Lower values increase sharpness and higher values reduce noise.",
        ResolutionDescription->"Automatically set to 1 if ImageDeconvolution is True.", (*TODO: Object[Report,Literature] and upload PDF*)
        Category->"Image Acquisition"
      },

      (* -------------------------------------- *)
      (* Brightfield and PhaseContrast Settings *)
      (* -------------------------------------- *)
      {
        (* leave this out in the primitive *)
        OptionName->TransmittedLightPower,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0 Percent,100 Percent],
          Units->Percent
        ],
        Description->"The percent of maximum intensity of the transmitted light that should be used to illuminate the sample. This option will set the percent maximum of the voltage applied to the light source, with higher percentages indicating higher intensities.",
        ResolutionDescription->"If Mode is BrightField or PhaseConstrast, automatically set to 20% for a high content inager, or 100% for any other inverted microscope.",
        Category->"Image Acquisition"
      },
      {
        (* leave this out in the primitive *)
        OptionName->TransmittedLightColorCorrection,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>BooleanP
        ],
        Description->"Indicates if a neutral color balance filter will be placed into the transmitted light path to correct the color temperature during BrightField and PhaseContrast imaging.",
        ResolutionDescription->"Automatically set to True if an inverted microscope is selected as Instrument.",
        Category->"Image Acquisition"
      },


    (** Hemocytometer Specifications **)
      {
        OptionName->Hemocytometer,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            Model[Container,Hemocytometer],
            Object[Container,Hemocytometer]
          }]
        ],
        Description->"The chamber slide with grids which is used to count cells.",
        ResolutionDescription->"Automatically set to Model[Container, Hemocytometer,\"2-Chip Disposable Hemocytometer\"] when QuantificationMethod is Hemocytometer.",
        Category->"Hemocytometer Quantification"
      },
    {
      OptionName -> GridPattern,
      Default -> Automatic,
      Description -> "Indicates the grid pattern of the hemocytometer that the images are aquired from. There exists different standard grid patterns which differ in the number of sub-squares they contain and also the mesh size.",
      ResolutionDescription -> "If QuantificationMethod is set to Hemocytometer, automatically set to the GridPattern of the Hemocytometer, otherwise to Null.",
      AllowNull ->True,
      Widget ->Widget[Type->Enumeration, Pattern:>HemocytometerGridPatternP],
      Category->"Hemocytometer Quantification"
    },
    {
      OptionName -> HemocytometerSquarePosition,
      Default -> Automatic,
      Description -> "Indicates the position of the sub-square within the grid pattern that is cropped and used for cell counting, where {1,1} is the bottom left square and {n,n} is the top right square.",
      ResolutionDescription -> "If QuantificationMethod is set to Hemocytometer, automatically set to {1,1}, otherwise to Null.",
      AllowNull ->False,
      Widget ->{
        "X index"->Widget[Type->Number, Pattern:>RangeP[1,4,1]],
        "Y index"->Widget[Type->Number, Pattern:>RangeP[1,4,1]]
      },
      Category->"Hemocytometer Quantification"
    },

    (** Fluorescence Specifications **)
    {
      OptionName -> FluorescenceThreshold,
      Default -> Automatic,
      Description -> "Indicates the normalized fluoresence threshold (0-1 value) to use for filtering the counted cells and intensity analysis.",
      ResolutionDescription -> "If Automatic and the ImagingChannel is Null, this will be set to Null. If Automatic and the ImagingChannel is provided, the default will be 0.5.",
      AllowNull ->True,
      Widget ->Widget[Type->Number,Pattern:>RangeP[0,1]],
      Category->"Hemocytometer Quantification"
    },

    (** Cell Size **)
    {
      OptionName -> AreaThreshold,
      Default -> Automatic,
      Description -> "Indicates the minimum area of the cells that will be included in the counting. All conncected components with area below this value are excluded.",
      ResolutionDescription -> "The value is selected based on the instrument.",
      AllowNull ->False,
      Widget ->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
      Category->"Hemocytometer Quantification"
    },
    {
      OptionName -> MinCellRadius,
      Default -> Automatic,
      Description -> "Indicates the minimum radius of the cells that will be included in the counting. All conncected components with radius below this value are excluded.",
      ResolutionDescription -> "The value is selected by instrument specifications.",
      AllowNull ->False,
      Widget ->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
      Category->"Hemocytometer Quantification"
    },
    {
      OptionName -> MaxCellRadius,
      Default -> Automatic,
      Description -> "Indicates the maximum radius of the cells that will be included in the counting. All connected components with radius greater than this value are excluded.",
      ResolutionDescription -> "The value is selected by instrument specifications.",
      AllowNull ->False,
      Widget ->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
      Category->"Hemocytometer Quantification"
    }(*TODO:Add these options when the patterns and primitives exist,

    (** Image Adjustments **)
    {
      OptionName->ImageAdjustment,
      Default->Automatic,
      AllowNull->False,
      Widget->Alternatives[
        Widget[Type->Primitive,Pattern:>ImageAdjustmentPrimitiveP],
        Adder[Widget[Type->Primitive,Pattern:>ImageAdjustmentPrimitiveP]]
      ],
      Description->"A set of adjustment primitives that are performed prior to the segmentation of the image.",
      ResolutionDescription->"If Automatic, set values of CellType, CultureAdhesion, Hemocytometer, ImagingChannel and MicroscopeMode will be used to identify the adjustment steps.",
      Category->"Hemocytometer Quantification"
    },

    (** Image Segmentation **)
    {
      OptionName->ImageSegmentation,
      Default->Automatic,
      AllowNull->False,
      Widget->Alternatives[
        Widget[Type->Primitive,Pattern:>ImageSegmentationPrimitiveP],
        Adder[Widget[Type->Primitive,Pattern:>ImageSegmentationPrimitiveP]]
      ],
      Description->"A set of primitives that are performed in order to segment the image and find the cells.",
      ResolutionDescription->"If Automatic, set values of CellType, CultureAdhesion, Hemocytometer, ImagingChannel and MicroscopeMode will be used to identify the segmentation steps.",
      Category->"Hemocytometer Quantification"
    }*)]
  }
];

DefineOptionSet[SplitOptions:>Evaluate@{
  (* For adherent cells: SplitRatio = (WashContainerSplitVolume/SampleIn[Volume]) * (ContainerIn[SurfaceArea]/ContainerOut[SurfaceArea]) *)
  (* For suspension cells: SplitRatio = (SplitVolume/SampleIn[Volume]) *)
  {
    OptionName->Ratio,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Expression,
      Pattern:>RatioP,
      Size->Word
    ],
    Description->"The ratio of the cells in the cell sample that should be plated in the ContainerOut.",
    ResolutionDescription->"Automatically set based on NumberOfReplicates and SplitVolume.",
    Category->"Splitting and Aliquoting",
    NestedIndexMatching->True
  },
  (* NOTE: SplitVolume is when you are transferring suspension cells directly from the SampleIn to the SampleOut.*)
  {
    OptionName->Volume,
    Default->Automatic,
    AllowNull->True,
    Widget->Adder[
      Widget[
        Type->Quantity,
        Pattern:>RangeP[0 Milliliter, 50 Milliliter],
        Units->Alternatives[Microliter, Milliliter]
      ]
    ],
    Description->"The volume of cell suspension, from the SampleIn, that will be plated in the ContainerOut, for each replicate. This option only applies to suspension cells that are not being washed.",
    ResolutionDescription->"Automatically set based on the given SplitRatio. If dealing with an Adherent cell culture or when Washing, automatically is set to Null.",
    Category->"Splitting and Aliquoting",
    NestedIndexMatching->True
  },
  {
    OptionName->NumberOfCells,
    Default->Automatic,
    Description -> "The number of Cells that is to be transferred to ContainerOut.",
    ResolutionDescription -> "Automatically set based on Volume and CellConcentration.",
    AllowNull->True,
    Widget->Widget[Type->Number,Pattern:>GreaterP[0,1]],
    Category->"Splitting and Aliquoting",
    NestedIndexMatching->True
  },
  {
    OptionName->CellConcentration,
    Default->Automatic,
    Description -> "The number of cells per volume or plate area that is to be transferred to ContainerOut.",
    ResolutionDescription -> "Automatically set based on Volume and NumberOfCells.",
    AllowNull->True,
    Widget->Alternatives[
      Widget[Type->Quantity,Pattern:>GreaterP[0 Centimeter^(-2)],Units->(Centimeter^(-2))],
      Widget[Type->Quantity,Pattern:>GreaterP[0 Milliliter^(-1)],Units->(0 Milliliter^(-1))]

    ],
    Category->"Splitting and Aliquoting",
    NestedIndexMatching->True
  },
  {
    OptionName->InsufficientCellNumberResponse,
    Default->Automatic,
    Description -> "The follow-up operation if the resolting number of cells cannot reach the specified NumberOfCells.",
    ResolutionDescription -> "Automatically set to Continue if CellConcentration or NumberOfCells are specified.",
    AllowNull->True,
    Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Continue,CellFreezer,Discard]],
    Category->"Splitting and Aliquoting"
  },
  {
    OptionName->ContainerInMedia,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>GreaterP[0 Milliliter],
      Units->Alternatives[Microliter, Milliliter]
    ],
    Description->"The media that should be added to ContainerIn.",
    Category->"Splitting and Aliquoting",
    NestedIndexMatching->True
  },
  {
    OptionName->ContainerInMediaVolume,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>GreaterP[0 Milliliter],
      Units->Alternatives[Microliter, Milliliter]
    ],
    Description->"The amount of media to add to the ContainerIn before splitting or aliquoting, when the cells are not to be washed.",
    Category->"Hidden"
  },
  {
    OptionName->ContainerInSplitVolume,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>GreaterP[0 Milliliter],
      Units->Alternatives[Microliter,Milliliter]
    ],
    Description->"The amount of sample that should be taken out of the ContainerIn and added to the ContainerOut in SplitCells. This option is index-matched to SplitRatio and is set to Null for cells being washed. This option is based on ContainerInMediaVolume.",
    Category->"Hidden",
    NestedIndexMatching->True
  },
  {
    OptionName->ContainerInMediaReplenishmentVolume,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>GreaterP[0 Milliliter],
      Units->Alternatives[Microliter, Milliliter]
    ],
    Description->"The amount of ContainerInMedia that should be added to the ContainerIn after aliquoting.",
    Category->"Splitting and Aliquoting",
    NestedIndexMatching->True
  },
  {
    OptionName->WashContainerMediaVolume,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>GreaterP[0 Milliliter],
      Units->Alternatives[Microliter, Milliliter]
    ],
    Description->"The amount of media to add to the wash container, after the cells have been finished washing. This will always be Min[Total[ToList[MediaVolume]] (taking into account replicates), WashContainer[MaxVolume]].",
    Category->"Hidden"
  },
  {
    OptionName->WashContainerSplitVolume,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>GreaterP[0 Milliliter],
      Units->Alternatives[Microliter, Milliliter]
    ],
    Description->"The amount of sample that should be taken out of the WashContainer and added to the ContainerOut in SplitCells. This option is index-matched to SplitRatio and is set to Null for cells not being washed. This option is based on WashContainerMediaVolume.",
    Category->"Hidden",
    NestedIndexMatching->True
  },
  {
    OptionName->ContainerOutMediaVolume,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Quantity,
      Pattern:>GreaterP[0 Milliliter],
      Units->Alternatives[Microliter, Milliliter]
    ],
    Description->"The amount of Media to add to each ContainerOut, taking into account the previous WashContainerMediaVolume that has already been added to the WashContainer and the NumberOfReplicates.",
    Category->"Hidden",
    NestedIndexMatching->True
  }
}];

DefineOptionSet[ContainerOutOptions:>Evaluate@{ (*TODO Change with Container-Index blitz*)
  IndexMatching[
    IndexMatchingInput -> "experiment samples",
    (* NOTE: ContainerOut and ContainerOutWell are pooled to the length of NumberOfReplicates. *)
    {
      OptionName->ContainerOut,
      Default->Automatic,
      AllowNull->True,
      Widget->Alternatives[
        "New Container"->Widget[
          Type->Object,
          Pattern:>ObjectP[{Model[Container],Object[Container]}]
        ],
        "New Container with Index"->{
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
      Description->"The container that will be used to plate the washed cells and new media.",
      ResolutionDescription->"Automatically set based on the CellType and MediaVolume.",
      Category->"Media Addition and Plating",
      NestedIndexMatching->True
    },
    (* NOTE: We fill up wells in the same container out *)
    {
      OptionName->ContainerOutWell,
      Default->Automatic,
      AllowNull->True,
      Widget->Alternatives[
        Widget[
          Type -> Enumeration,
          Pattern :> Alternatives@@Flatten[AllWells[]],
          PatternTooltip -> "Enumeration must be any well from A1 to H12."
        ],
        Widget[
          Type -> String,
          Pattern :> LocationPositionP,
          PatternTooltip -> "Any valid container position.",
          Size->Line
        ]
      ],
    Description->"The well in the ContainerOut in which the washed cells and new media will be plated.",
    ResolutionDescription->"Automatically set to the first empty well in the ContainerOut.",
    Category->"Media Addition and Plating",
    NestedIndexMatching->True
  },
  {
    OptionName -> ContainerOutLabel,
    Default -> Automatic,
    Description -> "A user defined word or phrase used to identify the ContainerOut that contains the plated cells with media, for use in downstream unit operations.",
    AllowNull -> True,
    Widget->Widget[
      Type->String,
      Pattern:>_String,
      Size->Line
    ],
    Category->"Hidden",
    NestedIndexMatching->True,
    UnitOperation->True
  },
  {
    OptionName -> SampleOutLabel,
    Default -> Automatic,
    Description -> "A user defined word or phrase used to identify the plated cells with media in the ContainerOut, for use in downstream unit operations.",
    ResolutionDescription->"Resolves to a unique label used to refer to the plated cell sample.",
    AllowNull -> True,
    Widget->Widget[
      Type->String,
      Pattern:>_String,
      Size->Line
    ],
    Category->"Hidden",
    NestedIndexMatching->True,
    UnitOperation -> True
  }]
}];



(* ::Subsection::Closed:: *)
(* StainCells *)


(* ::Subsubsection::Closed:: *)
(* StainOptions *)

DefineOptionSet[StainOptions :> {
  IndexMatching[
    IndexMatchingInput -> "experiment samples",
    {
      OptionName -> StainingMethod,
      Default -> Automatic,
      Description -> "The type of staining involving a set of stains, mordants, decolorizers, and counter stains used to increase the contrast between certain cells, cell structures, or species within cells for improved viewing via microscope or quantification. See Figure XX for details on stains, mordants, decolorizers, and counter stains, and the intended target or purpose of the StainingMethod.",
      ResolutionDescription->"Automatically set based on CellType of the samples. If CellType->Bacterial, StainingMethod will be set to GramStain. If CellType->Mammalian, StainingMethod will be set to HEStain.",
      AllowNull -> True,
      Widget -> Alternatives[
        Widget[Type -> Enumeration, Pattern :> CellStainingMethodP],
        Widget[
          Type -> Object,
          Pattern :> ObjectP[Object[Method,StainCells]]                           (* TODO create a folder in Catalog with all common methods- OpenPaths *)   (* TODO create Method objects for StainCells *)
        ]
      ],
      Category->"General"
    },


    (* ------Stain Preparation------- *)
    {
      OptionName->Stain,
      Default->Automatic,
      Description->"The chemical reagent or stock solution added to cells to color them for better visualization or quantification.",
      ResolutionDescription->"Automatically set based on StainingMethod. Figure XX details the Stain set for each StainingMethod.",
      AllowNull->True,
      Widget-> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Sample],Object[Sample]}]
      ],
      Category->"Stain Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName->StainVolume,
      Default->Automatic,
      Description->"The volume of the Stain to add to the cells to color them.",
      ResolutionDescription->"Automatically set to the StainVolume set in the StainingMethod, or set to the volume needed to reach the desired StainConcentration if specified, otherwise set to 10% of the MaxVolume of the container the cell samples are in.",
      AllowNull->False,
      Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,$TCMaxInoculationVolume],Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}],
      Category->"Stain Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName -> StainConcentration,
      Default -> Automatic,
      ResolutionDescription -> "Automatically set to the StainConcentration set in the StainingMethod, or set to Null if cells are not suspended in solution, or set to the calculated concentration of the StainAnalyte in the Stain as specified in the StainingMethod.",
      Description -> "The final concentration of the StainAnalyte in the cell suspension after dilution of the Stain in the media the cells are suspended in.",
      AllowNull->True,
      Widget -> Alternatives[
        "Concentration"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Molar, 10 Molar],
          Units -> {1, {Micromolar, {Nanomolar, Micromolar, Millimolar, Molar}}}
        ],
        "Mass Concentration"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Gram/Liter, 1000 Gram/Liter],
          Units -> CompoundUnit[
            {1, {Milligram, {Microgram, Milligram, Gram}}},
            {-1, {Liter, {Microliter, Milliliter, Liter}}}
          ]
        ],
        "Volume Percent"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 VolumePercent, 100 VolumePercent],
          Units -> VolumePercent
        ],
        "Mass Percent"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 MassPercent, 100 MassPercent],
          Units -> MassPercent
        ]
      ],
      Category -> "Stain Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName->StainAnalyte,
      Default->Automatic,
      Description->"The active substance of interest which causes staining and whose concentration in the final cell and stain mixture is specified by the StainConcentration option.",
      ResolutionDescription->"Automatically set to the StainAnalyte set in the StainingMethod, or set to the first analyte in the Composition field of the Stain determined using the Analytes field of the Model[Sample], or if none exist, the first identity model of any kind in the Composition field.",
      AllowNull->True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[List @@ IdentityModelTypeP]
      ],
      Category->"Stain Preparation",
      NestedIndexMatching -> True
    },

    {
      OptionName -> StainSourceTemperature,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Alternatives[
        Widget[Type -> Quantity, Pattern :> RangeP[25 Celsius, 90 Celsius],Units :> Celsius],
        Widget[Type->Enumeration,Pattern:>Alternatives[CryogenicStorage,DeepFreezer,Freezer,Refrigerator,Ambient]]
      ],
      Description -> "The desired temperature of the Stain prior to transferring to the cell samples.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the StainingMethod for the cell line.",
      Category -> "Stain Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName -> StainSourceEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description -> "The minimum duration of time for which the Stain will be heated/cooled to the target StainSourceTemperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if StainSourceTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName -> MaxStainSourceEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description->"The maximum duration of time for which the Stain will be heated/cooled to the target StainSourceEquilibrationTemperature. If they do not reach the StainSourceTemperature in the StainSourceEquilibrationTime, the sample will be checked in cycles of the StainSourceEquilibrationTime up to the MaxStainSourceEquilibrationTime. If the StainSourceTemperature is never reached, it is indicated in the StainSourceTemperatureReached field in the protocol object.",
      ResolutionDescription -> "Automatically set to 30 Minute if StainSourceTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName->StainSourceEquilibrationCheck,
      Default->Automatic,
      AllowNull->True,
      Widget->Widget[
        Type->Enumeration,
        Pattern:>EquilibrationCheckP
      ],
      Description->"The method by which to verify the temperature of the Stain before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a StainSourceTemperature is indicated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Preparation",
      NestedIndexMatching -> True
    },

    {
      OptionName -> StainDestinationTemperature,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Alternatives[
        Widget[Type -> Quantity, Pattern :> RangeP[25 Celsius, 90 Celsius],Units :> Celsius],
        Widget[Type->Enumeration,Pattern:>Alternatives[CryogenicStorage,DeepFreezer,Freezer,Refrigerator,Ambient]]
      ],
      Description -> "The desired temperature of the cells prior to transferring the Stain to them.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the StainingMethod for the cell line.",
      Category -> "Stain Preparation"
    },
    {
      OptionName -> StainDestinationEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description -> "The minimum duration of time for which the cell samples will be heated/cooled to the target StainDestinationTemperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if StainDestinationTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Preparation"
    },
    {
      OptionName -> MaxStainDestinationEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description->"The maximum duration of time for which the cell samples will be heated/cooled to the target StainDestinationEquilibrationTemperature. If they do not reach the StainDestinationTemperature in the StainDestinationEquilibrationTime, the sample will be checked in cycles of the StainDestinationEquilibrationTime up to the MaxStainDestinationEquilibrationTime. If the StainDestinationTemperature is never reached, it is indicated in the StainDestinationTemperatureReached field in the protocol object.",
      ResolutionDescription -> "Automatically set to 30 Minute if StainDestinationTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Preparation"
    },
    {
      OptionName->StainDestinationEquilibrationCheck,
      Default->Automatic,
      AllowNull->True,
      Widget->Widget[
        Type->Enumeration,
        Pattern:>EquilibrationCheckP
      ],
      Description->"The method by which to verify the temperature of the cell samples before adding the Stain.",
      ResolutionDescription -> "Automatically set to IRThermometer if a StainDestinationTemperature is indicated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Preparation"
    }
  ]
}];

(* ::Subsubsection::Closed:: *)
(* StainMixOptions *)

DefineOptionSet[StainMixOptions :> {
  (* --- Stain Mix --- *)
  ModifyOptions[
    ExperimentIncubate,
    Mix,
    {
      Description -> "Indicates if the cell samples should be mixed and/or incubated after adding the Stain.",
      ResolutionDescription -> "Automatically set to True if any StainMix related options are set, otherwise set to False, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Staining"
    }
  ]/.{Mix->StainMix},
  ModifyOptions[
    ExperimentIncubate,
    MixType,
    {
      Widget -> Widget[Type -> Enumeration, Pattern :> CellMixTypeP],   (*Roll | Vortex | Pipette | Invert | Shake | Swirl | Nutate*)
      Description -> "Indicates the style of motion used to mix the cell sample with Stain added to it.",
      ResolutionDescription -> "Automatically set based on the container of the sample and the StainMix option, unless otherwise specified in the StainingMethod for the cell line. Specifically, if StainMix is set to False, the option is set to Null. If StainMixInstrument is specified, the option is set based on the specified StainMixInstrument.  If StainMixRate and StainTime are Null, when StainMixVolume is Null or larger than 50ml, the option is set to Invert, otherwise set to Pipette. If StainMixRate is set, the option is set base on any instrument that is capable of mixing the sample at the specified StainMixRate.",
      Category->"Staining"
    }
  ]/.{MixType->StainMixType},
  {
    OptionName -> StainMixInstrument,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[
      Type->Object,
      Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]
    ],
    Description -> "The instrument used to perform the StainMix and/or Incubation.",
    ResolutionDescription -> "Automatically set based on the options StainMix, StainTemperature, StainMixType and container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",                 (* TODO add table of mix logic here *)
    Category->"Staining"
  },
  ModifyOptions[
    ExperimentIncubate,
    Time,
    {
      Description -> "Duration of time for which the cell samples will be mixed with the Stain.",
      ResolutionDescription -> "Automatically set based on the StainMixType and container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Staining"
    }
  ]/.{Time->StainTime},
  ModifyOptions[
    ExperimentIncubate,
    MixRate,
    {
      Description -> "Frequency of rotation the StainMixInstrument will use to mix the cell samples with Stain added to them.",
      ResolutionDescription -> "Automatically set based on the StainMixInstrument model and the container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Staining"
    }
  ]/.{MixRate->StainMixRate},
  ModifyOptions[
    ExperimentIncubate,
    MixRateProfile,
    {
      Description -> "Frequency of rotation the StainMixInstrument will use to mix the cell samples with Stain added to them, over the course of time.",
      ResolutionDescription -> "Automatically set if the StainMixInstrument is set to Model[Instrument,Shaker,\"Torrey Pines\"], otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Staining"
    }
  ]/.{MixRateProfile->StainMixRateProfile},
  ModifyOptions[
    ExperimentIncubate,
    NumberOfMixes,
    {
      Description -> "Number of times the cell samples should be mixed with Stain if StainMixType->Pipette or Invert.",
      ResolutionDescription -> "Automatically set based on the StainMixType as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Staining"
    }
  ]/.{NumberOfMixes->StainNumberOfMixes},
  ModifyOptions[
    ExperimentIncubate,
    MixVolume,
    {
      Description -> "The volume of the cell sample and Stain that should be pipetted up and down to mix if StainMixType->Pipette.",
      ResolutionDescription -> "Automatically set based on the StainMixType as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Staining"
    }
  ]/.{MixVolume->StainMixVolume},
  ModifyOptions[
    ExperimentIncubate,
    Temperature,
    {
      Description -> "The temperature of the device at which to hold the cell samples after adding the Stain.",
      ResolutionDescription -> "Automatically set based on the StainMixType as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Staining"
    }
  ]/.{Temperature->StainTemperature},
  ModifyOptions[
    ExperimentIncubate,
    TemperatureProfile,
    {
      Description -> "The temperature of the device at which to hold the cell samples after adding the Stain, over the course of time.",
      ResolutionDescription -> "Automatically set based on the StainMixInstrument as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Staining"
    }
  ]/.{TemperatureProfile->StainTemperatureProfile},
  ModifyOptions[
    ExperimentIncubate,
    AnnealingTime,
    {
      Description->"Minimum duration for which the cell samples after adding the Stain should remain in the incubator allowing the system to settle to room temperature after the StainTime has passed.",
      ResolutionDescription->"Automatically set to to 0 Minute if other incubation options are set, or to Null in cases where the sample is not being incubated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Staining"
    }
  ]/.{AnnealingTime->StainAnnealingTime},
  ModifyOptions[
    ExperimentIncubate,
    ResidualIncubation,
    {
      Description->"Indicates if the incubation should continue after StainTime has finished while waiting to progress to the next step in the protocol.",
      ResolutionDescription->"Automatically set to to True if the cell samples have non-ambient TransportTemperature and non-ambient StainTemperature, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Staining"
    }
  ]/.{ResidualIncubation->StainResidualIncubation}
}];

(* ::Subsubsection::Closed:: *)
(* StainWashOptions *)

DefineOptionSet[StainWashOptions :> {
  (* --- Stain Wash Options --- *)
  ModifyOptions[
    WashCellOptions,
    Wash,
    {
      Description->"Indicates whether the cell samples with Stain should be washed after incubation.",
      ResolutionDescription->"Automatically set based on StainingMethod, and detailed in Figure XX.",
      Category->"Stain Washing"
    }
  ]/.{Wash->StainWash},
  ModifyOptions[
    WashCellOptions,
    NumberOfWashes,
    {
      Description->"The number of times that the cell samples with Stain should be washed with StainWashSolution.",
      ResolutionDescription->"Automatically set to 3 when StainWash->True, unless otherwise specified in the StainingMethod for the cell line.",                 (* TODO determine the ideal number of washes to fully remove the Stain- should it be different for Stains v Mordants etc? *)
      Category->"Stain Washing"
    }
  ]/.{NumberOfWashes->NumberOfStainWashes},
  ModifyOptions[
    WashCellOptions,
    WashType,
    {
      Description->"The method by which the cell samples with Stain should be washed.",
      ResolutionDescription->"Automatically set to Adherent when Wash->True, unless any Pellet-related options are set, then set to Suspension, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashType->StainWashType},
  ModifyOptions[
    WashCellOptions,
    WashSolution,
    {
      Description->"The solution that is used to wash the cell samples with Stain.",
      ResolutionDescription->"Automatically set based on StainingMethod, and detailed in Figure XX.",
      Category->"Stain Washing"
    }
  ]/.{WashSolution->StainWashSolution},
  ModifyOptions[
    WashCellOptions,
    WashSolutionContainer
  ]/.{WashSolutionContainer->StainWashSolutionContainer},
  ModifyOptions[
    WashCellOptions,
    WashContainer,
    {
      ResolutionDescription->"Automatically set to a container with a MaxVolume less than the StainWashVolume if StainWashType->Suspension, unless otherwise specified in the StainingMethod for the cell line. If StainWashType->Adherent, set to Null.",
      Category->"Stain Washing"
    }
  ]/.{WashContainer->StainWashContainer},
  ModifyOptions[
    WashCellOptions,
    WashSolutionPipette,
    {
      Description->"The pipette that will be used to transfer the StainWashSolution into the StainWashContainer if StainWashType->Suspension, or the current container of cell sample and Stain if StainWashType->Adherent.",
      ResolutionDescription->"Automatically set to the smallest pipette capable of transferring the specified StainWashVolume, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashSolutionPipette->StainWashSolutionPipette},
  ModifyOptions[
    WashCellOptions,
    WashSolutionTips,
    {
      Description->"The tips used to transfer the StainWashSolution into the StainWashContainer if StainWashType->Suspension, or the current container of cell sample and Stain if StainWashType->Adherent.",
      ResolutionDescription->"Automatically set to the smallest tips with a MaxTransferVolume higher than the specified StainWashVolume, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashSolutionTips->StainWashSolutionTips},
  ModifyOptions[
    WashCellOptions,
    WashVolume,
    {
      Description->"The amount of StainWashSolution that is added to the StainWashContainer when the cells are washed if StainWashType->Suspension, or the current container of cell sample and Stain if StainWashType->Adherent.",
      ResolutionDescription->"Automatically set to 3/4 of the MaxVolume of the StainWashContainer, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashVolume->StainWashVolume},
  ModifyOptions[
    WashCellOptions,
    WashSolutionTemperature,
    {
      Description->"The temperature to heat/cool the StainWashSolution to before the washing occurs.",
      ResolutionDescription -> "Automatically set to 5 Minute if StainWashSolutionTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashSolutionTemperature->StainWashSolutionTemperature},
  ModifyOptions[
    WashCellOptions,
    WashSolutionEquilibrationTime,
    {
      Description->"The duration of time for which the StainWashSolution will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if StainWashSolutionTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashSolutionEquilibrationTime->StainWashSolutionEquilibrationTime},
  ModifyOptions[
    WashCellOptions,
    MaxWashSolutionEquilibrationTime,
    {
      Description->"The maximum duration of time for which the samples will be heated/cooled to the target StainWashSolutionEquilibrationTemperature. If they do not reach the StainWashSolutionTemperature in the StainWashSolutionEquilibrationTime, the sample will be checked in cycles of the StainWashSolutionEquilibrationTime up to the MaxStainWashSolutionEquilibrationTime. If the StainWashSolutionTemperature is never reached, it is indicated in the StainWashSolutionTemperatureReached field in the protocol object.",
      ResolutionDescription -> "Automatically set to 30 Minute if StainWashSolutionTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{MaxWashSolutionEquilibrationTime->MaxStainWashSolutionEquilibrationTime},
  ModifyOptions[
    WashCellOptions,
    WashSolutionEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the StainWashSolution before the transfer to the cell samples and Stain is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a StainWashSolutionTemperature is indicated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashSolutionEquilibrationCheck->StainWashSolutionEquilibrationCheck},

  (* StainWashSolution Mixing *)
  ModifyOptions[
    WashCellOptions,
    WashSolutionAspirationMix,
    {
      ResolutionDescription -> "Automatically set to True if any of the other StainWashSolutionAspirationMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashSolutionAspirationMix->StainWashSolutionAspirationMix},
  ModifyOptions[
    WashCellOptions,
    WashSolutionAspirationMixType,
    {
      ResolutionDescription -> "Automatically set to Pipette if any of the other StainWashSolutionAspirationMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashSolutionAspirationMixType->StainWashSolutionAspirationMixType},
  ModifyOptions[
    WashCellOptions,
    NumberOfWashSolutionAspirationMixes,
    {
      ResolutionDescription -> "Automatically set to 5 if any of the other StainWashSolutionAspirationMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{NumberOfWashSolutionAspirationMixes->NumberOfStainWashSolutionAspirationMixes},
  ModifyOptions[
    WashCellOptions,
    WashSolutionDispenseMix,
    {
      Description->"Indicates if mixing should occur after the StainWashSolution is dispensed into the cell sample with Stain.",
      ResolutionDescription -> "Automatically set to True if any of the other StainWashSolutionDispenseMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashSolutionDispenseMix->StainWashSolutionDispenseMix},
  ModifyOptions[
    WashCellOptions,
    WashSolutionDispenseMixType,
    {
      Description->"The type of mixing that should occur after the StainWashSolution is dispensed into the cell sample with Stain.",
      ResolutionDescription -> "Automatically set to Pipette if any of the other StainWashSolutionDispenseMix options are set and a pipette is being used to do the transfer; otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashSolutionDispenseMixType->StainWashSolutionDispenseMixType},
  ModifyOptions[
    WashCellOptions,
    NumberOfWashSolutionDispenseMixes,
    {
      Description->"The number of times that the cell/StainWashSolution mixture should be mixed after dispensing the StainWashSolution into the cell sample with Stain.",
      ResolutionDescription -> "Automatically set to 5 if any of the other StainWashSolutionDispenseMix options are set, unless otherwise specified in the StainingMethod for the cell line. Otherwise, set to Null.",
      Category->"Stain Washing"
    }
  ]/.{NumberOfWashSolutionDispenseMixes->NumberOfStainWashSolutionDispenseMixes},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubation,
    {
      Description->"Indicates if the cells with Stain should be incubated after the StainWashSolution is added.",
      ResolutionDescription->"Automatically set to True if StainWash->True, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashSolutionIncubation->StainWashSolutionIncubation},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubationInstrument,
    {
      Description->"The instrument used to perform the incubation of the cell sample with the StainWashSolution.",
      ResolutionDescription -> "Automatically set based on the options StainWashSolutionMix, StainWashSolutionIncubationTemperature, StainWashSolutionMixType, and container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"                                                    (* TODO add incubation logic table here *)
    }
  ]/.{WashSolutionIncubationInstrument->StainWashSolutionIncubationInstrument},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubationTime,
    {
      Description->"The amount of time that the cells should be incubated with the StainWashSolution.",
      ResolutionDescription->"Automatically set based on the StainWashSolutionMixType and the StainWashContainer, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashSolutionIncubationTime->StainWashSolutionIncubationTime},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubationTemperature,
    {
      Description->"The temperature of the mix instrument while incubating the cells with the StainWashSolution.",
      ResolutionDescription->"Automatically set based on the StainWashSolutionMixType and the StainWashContainer, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashSolutionIncubationTemperature->StainWashSolutionIncubationTemperature},
  ModifyOptions[
    WashCellOptions,
    WashSolutionMix,
    {
      Description->"Indicates if the cells and StainWashSolution should be mixed during StainWashSolutionIncubation.",
      ResolutionDescription -> "Automatically set to True if any StainWashMix options are set, unless otherwise specified in the StainingMethod for the cell line, otherwise set to False.",
      Category->"Stain Washing"
    }
  ]/.{WashSolutionMix->StainWashSolutionMix},
  ModifyOptions[
    WashCellOptions,
    WashSolutionMixType,
    {
      Description->"Indicates the style of motion used to mix the cell sample with StainWashSolution.",
      ResolutionDescription -> "Automatically set to Shake if StainWashSolutionMix->True, unless otherwise specified in the StainingMethod for the cell line, otherwise set to Null.",
      Category->"Stain Washing"
    }
  ]/.{WashSolutionMixType->StainWashSolutionMixType},
  ModifyOptions[
    WashCellOptions,
    WashSolutionMixRate,
    {
      Description->"Frequency of rotation of the mixing instrument should use to mix the cells with StainWashSolution added to them.",
      ResolutionDescription -> "Automatically set to XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"                                       (* TODO determine what the speed is set to *)
    }
  ]/.{WashSolutionMixRate->StainWashSolutionMixRate},


  (* --- Stain Wash Pellet Options --- *)
  {
    OptionName -> StainWashPellet,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
    Description -> "Indicates if the cells and StainWashSolution should be centrifuged to create a pellet after StainWashSolutionIncubation to be able to safely aspirate the StainWashSolution from the cells.",
    ResolutionDescription -> "Automatically set to True if any StainWashPellet options are set, unless otherwise specified in the StainingMethod for the cell line.",
    Category->"Stain Washing"
  },
  ModifyOptions[
    WashCellOptions,
    WashPelletInstrument,
    {
      AllowNull -> True,
      Description->"The centrifuge that will be used to spin the cell samples with StainWashSolution added to them after StainWashSolutionIncubation.",
      ResolutionDescription -> "Automatically set to a centrifuge that can attain the specified intensity, time, and temperature that is compatible with the StainWashContainer, detailed in Figure XX, if StainWashPellet->True, unless otherwise specified in the StainingMethod for the cell line; otherwise set to Null.",
      Category->"Stain Washing"
    }
  ]/.{WashPelletInstrument->StainWashPelletInstrument},
  ModifyOptions[
    WashCellOptions,
    WashPelletIntensity,
    {
      AllowNull -> True,
      Description->"The rotational speed or the force that will be applied to the cell samples with StainWashSolution by centrifugation in order to create a pellet.",
      ResolutionDescription->"Automatically set to one fifth of the maximum rotational rate of the centrifuge, rounded to the nearest attainable centrifuge precision, if StainWashPellet->True, unless otherwise specified in the StainingMethod for the cell line; otherwise set to Null.",
      Category->"Stain Washing"
    }
  ]/.{WashPelletIntensity->StainWashPelletIntensity},
  ModifyOptions[
    WashCellOptions,
    WashPelletTime,
    {
      Default -> Automatic,
      AllowNull -> True,
      Description->"The amount of time that the cell samples with StainWashSolution will be centrifuged to create a pellet.",
      ResolutionDescription->"Automatically set to 5 minutes if StainWashPellet->True, unless otherwise specified in the StainingMethod for the cell line, otherwise set to Null.",
      Category->"Stain Washing"
    }
  ]/.{WashPelletTime->StainWashPelletTime},
  ModifyOptions[
    WashCellOptions,
    WashPelletTemperature,
    {
      Default -> Automatic,
      AllowNull -> True,
      Description->"The temperature at which the centrifuge chamber will be held while the cell samples with StainWashSolution are being centrifuged.",
      ResolutionDescription->"Automatically set to Ambient if StainWashPellet->True, otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{WashPelletTemperature->StainWashPelletTemperature},
  ModifyOptions[
    ExperimentPellet,
    SupernatantVolume,
    {
      Default -> Automatic,
      AllowNull -> True,
      Description->"The amount of supernatant that will be aspirated from the cell samples with StainWashSolution after centrifugation created a cell pellet.",
      ResolutionDescription->"Automatically set to All if StainWashPellet->True, otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{SupernatantVolume->StainWashPelletSupernatantVolume},
  ModifyOptions[
    ExperimentPellet,
    SupernatantDestination,
    {
      Default -> Automatic,
      AllowNull -> True,
      ResolutionDescription->"Automatically set to Waste if StainWashPellet->True, otherwise set to Null.",
      Description->"The container that the supernatant should be dispensed into after aspiration from the pelleted cell sample, unless otherwise specified in the StainingMethod for the cell line. If the supernatant will not be used for further experimentation, the destination should be set to Waste.",
      Category->"Stain Washing"
    }
  ]/.{SupernatantDestination->StainWashPelletSupernatantDestination},
  ModifyOptions[
    ExperimentPellet,
    SupernatantTransferInstrument,
    {
      AllowNull -> True,
      Description->"The pipette that will be used to transfer off the supernatant (StainWashSolution and Stain) from the pelleted cell sample.",
      ResolutionDescription->"Automatically set to the smallest pipette that can aspirate the volume of the pelleted cell sample and can fit into the container of the pelleted cell sample if StainWashPellet->True, otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Stain Washing"
    }
  ]/.{SupernatantTransferInstrument->StainWashPelletSupernatantTransferInstrument}
}];


(* ::Subsubsection::Closed:: *)
(* MordantOptions *)

DefineOptionSet[MordantOptions :> {
  IndexMatching[
    IndexMatchingInput -> "experiment samples",
    {
      OptionName->Mordant,
      Default->Automatic,
      Description->"The chemical reagent or stock solution added to cells to fix dyes to the cells and intensify the Stain.",
      ResolutionDescription->"Automatically set based on StainingMethod. Figure XX details the Mordant set for each StainingMethod.",
      AllowNull->True,
      Widget-> Alternatives[
        Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Sample],Object[Sample]}]
        ],
        Widget[Type->Enumeration,Pattern:>Alternatives[None]]
      ],
      Category->"Mordant Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName->MordantVolume,
      Default->Automatic,
      Description->"The volume of the Mordant to add to the cells to aid in staining them.",
      ResolutionDescription->"Automatically set to the MordantVolume set in the StainingMethod, or set to the volume needed to reach the desired MordantConcentration if specified, otherwise set to 10% of the MaxVolume of the container the cell samples are in.",
      AllowNull->True,
      Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,$TCMaxInoculationVolume],Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}],
      Category->"Mordant Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName -> MordantConcentration,
      Default -> Automatic,
      ResolutionDescription -> "Automatically set to the MordantConcentration set in the StainingMethod, or set to Null if cells are not suspended in solution, or set to the calculated concentration of the MordantAnalyte in the Mordant as specified in the StainingMethod.",
      Description -> "The final concentration of the MordantAnalyte in the cell suspension after dilution of the Mordant in the media the cells are suspended in.",
      AllowNull->True,
      Widget -> Alternatives[
        "Concentration"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Molar, 10 Molar],
          Units -> {1, {Micromolar, {Nanomolar, Micromolar, Millimolar, Molar}}}
        ],
        "Mass Concentration"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Gram/Liter, 1000 Gram/Liter],
          Units -> CompoundUnit[
            {1, {Milligram, {Microgram, Milligram, Gram}}},
            {-1, {Liter, {Microliter, Milliliter, Liter}}}
          ]
        ],
        "Volume Percent"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 VolumePercent, 100 VolumePercent],
          Units -> VolumePercent
        ],
        "Mass Percent"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 MassPercent, 100 MassPercent],
          Units -> MassPercent
        ]
      ],
      Category -> "Mordant Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName->MordantAnalyte,
      Default->Automatic,
      Description->"The active substance of interest which intensifies the Stain and whose concentration in the final cell and Mordant mixture is specified by the MordantConcentration option.",
      ResolutionDescription->"Automatically set to the MordantAnalyte set in the StainingMethod, or set to the first analyte in the Composition field of the Mordant determined using the Analytes field of the Model[Sample], or if none exist, the first identity model of any kind in the Composition field.",
      AllowNull->True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[List @@ IdentityModelTypeP]
      ],
      Category->"Mordant Preparation",
      NestedIndexMatching -> True
    },

    {
      OptionName -> MordantSourceTemperature,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Alternatives[
        Widget[Type -> Quantity, Pattern :> RangeP[25 Celsius, 90 Celsius],Units :> Celsius],
        Widget[Type->Enumeration,Pattern:>Alternatives[CryogenicStorage,DeepFreezer,Freezer,Refrigerator,Ambient]]
      ],
      Description -> "The desired temperature of the Mordant prior to transferring to the cell samples.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the StainingMethod for the cell line.",
      Category -> "Mordant Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName -> MordantSourceEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description -> "The minimum duration of time for which the Mordant will be heated/cooled to the target MordantSourceTemperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if MordantSourceTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName -> MaxMordantSourceEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description->"The maximum duration of time for which the Mordant will be heated/cooled to the target MordantSourceEquilibrationTemperature. If they do not reach the MordantSourceTemperature in the MordantSourceEquilibrationTime, the sample will be checked in cycles of the MordantSourceEquilibrationTime up to the MaxMordantSourceEquilibrationTime. If the MordantSourceTemperature is never reached, it is indicated in the MordantSourceTemperatureReached field in the protocol object.",
      ResolutionDescription -> "Automatically set to 30 Minute if MordantSourceTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName->MordantSourceEquilibrationCheck,
      Default->Automatic,
      AllowNull->True,
      Widget->Widget[
        Type->Enumeration,
        Pattern:>EquilibrationCheckP
      ],
      Description->"The method by which to verify the temperature of the Mordant before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a MordantSourceTemperature is indicated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Preparation",
      NestedIndexMatching -> True
    },

    {
      OptionName -> MordantDestinationTemperature,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Alternatives[
        Widget[Type -> Quantity, Pattern :> RangeP[25 Celsius, 90 Celsius],Units :> Celsius],
        Widget[Type->Enumeration,Pattern:>Alternatives[CryogenicStorage,DeepFreezer,Freezer,Refrigerator,Ambient]]
      ],
      Description -> "The desired temperature of the cells prior to transferring the Mordant to them.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the StainingMethod for the cell line.",
      Category -> "Mordant Preparation"
    },
    {
      OptionName -> MordantDestinationEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description -> "The minimum duration of time for which the cell samples will be heated/cooled to the target MordantDestinationTemperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if MordantDestinationTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Preparation"
    },
    {
      OptionName -> MaxMordantDestinationEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description->"The maximum duration of time for which the cell samples will be heated/cooled to the target MordantDestinationEquilibrationTemperature. If they do not reach the MordantDestinationTemperature in the MordantDestinationEquilibrationTime, the sample will be checked in cycles of the MordantDestinationEquilibrationTime up to the MaxMordantDestinationEquilibrationTime. If the MordantDestinationTemperature is never reached, it is indicated in the MordantDestinationTemperatureReached field in the protocol object.",
      ResolutionDescription -> "Automatically set to 30 Minute if MordantDestinationTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Preparation"
    },
    {
      OptionName->MordantDestinationEquilibrationCheck,
      Default->Automatic,
      AllowNull->True,
      Widget->Widget[
        Type->Enumeration,
        Pattern:>EquilibrationCheckP
      ],
      Description->"The method by which to verify the temperature of the cell samples before adding the Mordant.",
      ResolutionDescription -> "Automatically set to IRThermometer if a MordantDestinationTemperature is indicated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Preparation"
    }
  ]
}];


(* ::Subsubsection::Closed:: *)
(* MordantMixOptions *)

DefineOptionSet[MordantMixOptions :> {
  (* --- Mordant Mix --- *)
  ModifyOptions[
    ExperimentIncubate,
    Mix,
    {
      Description -> "Indicates if the cell samples should be mixed and/or incubated after adding the Mordant.",
      ResolutionDescription -> "Automatically set to True if any MordantMix related options are set, otherwise set to False, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordanting"
    }
  ]/.{Mix->MordantMix},
  ModifyOptions[
    ExperimentIncubate,
    MixType,
    {
      Widget -> Widget[Type -> Enumeration, Pattern :> CellMixTypeP],   (*Roll | Vortex | Pipette | Invert | Shake | Swirl | Nutate*)
      Description -> "Indicates the style of motion used to mix the cell sample with Mordant added to it.",
      ResolutionDescription -> "Automatically set based on the container of the sample and the MordantMix option, unless otherwise specified in the StainingMethod for the cell line. Specifically, if MordantMix is set to False, the option is set to Null. If MordantMixInstrument is specified, the option is set based on the specified MordantMixInstrument.  If MordantMixRate and MordantTime are Null, when MordantMixVolume is Null or larger than 50ml, the option is set to Invert, otherwise set to Pipette. If MordantMixRate is set, the option is set base on any instrument that is capable of mixing the sample at the specified MordantMixRate.",
      Category->"Mordanting"
    }
  ]/.{MixType->MordantMixType},
  {
    OptionName -> MordantMixInstrument,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[
      Type->Object,
      Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]
    ],
    Description -> "The instrument used to perform the MordantMix and/or Incubation.",
    ResolutionDescription -> "Automatically set based on the options MordantMix, MordantTemperature, MordantMixType and container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",                 (* TODO add table of mix logic here *)
    Category->"Mordanting"
  },
  ModifyOptions[
    ExperimentIncubate,
    Time,
    {
      Description -> "Duration of time for which the cell samples will be mixed with the Mordant.",
      ResolutionDescription -> "Automatically set based on the MordantMixType and container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordanting"
    }
  ]/.{Time->MordantTime},
  ModifyOptions[
    ExperimentIncubate,
    MixRate,
    {
      Description -> "Frequency of rotation the MordantMixInstrument will use to mix the cell samples with Mordant added to them.",
      ResolutionDescription -> "Automatically set based on the MordantMixInstrument model and the container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordanting"
    }
  ]/.{MixRate->MordantMixRate},
  ModifyOptions[
    ExperimentIncubate,
    MixRateProfile,
    {
      Description -> "Frequency of rotation the MordantMixInstrument will use to mix the cell samples with Mordant added to them, over the course of time.",
      ResolutionDescription -> "Automatically set if the MordantMixInstrument is set to Model[Instrument,Shaker,\"Torrey Pines\"], otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordanting"
    }
  ]/.{MixRateProfile->MordantMixRateProfile},
  ModifyOptions[
    ExperimentIncubate,
    NumberOfMixes,
    {
      Description -> "Number of times the cell samples should be mixed with Mordant if MordantMixType->Pipette or Invert.",
      ResolutionDescription -> "Automatically set based on the MordantMixType as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordanting"
    }
  ]/.{NumberOfMixes->MordantNumberOfMixes},
  ModifyOptions[
    ExperimentIncubate,
    MixVolume,
    {
      Description -> "The volume of the cell sample and Mordant that should be pipetted up and down to mix if MordantMixType->Pipette.",
      ResolutionDescription -> "Automatically set based on the MordantMixType as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordanting"
    }
  ]/.{MixVolume->MordantMixVolume},
  ModifyOptions[
    ExperimentIncubate,
    Temperature,
    {
      Description -> "The temperature of the device at which to hold the cell samples after adding the Mordant.",
      ResolutionDescription -> "Automatically set based on the MordantMixType as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordanting"
    }
  ]/.{Temperature->MordantTemperature},
  ModifyOptions[
    ExperimentIncubate,
    TemperatureProfile,
    {
      Description -> "The temperature of the device at which to hold the cell samples after adding the Mordant, over the course of time.",
      ResolutionDescription -> "Automatically set based on the MordantMixInstrument as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordanting"
    }
  ]/.{TemperatureProfile->MordantTemperatureProfile},
  ModifyOptions[
    ExperimentIncubate,
    AnnealingTime,
    {
      Description->"Minimum duration for which the cell samples after adding the Mordant should remain in the incubator allowing the system to settle to room temperature after the MordantTime has passed.",
      ResolutionDescription->"Automatically set to to 0 Minute if other incubation options are set, or to Null in cases where the sample is not being incubated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordanting"
    }
  ]/.{AnnealingTime->MordantAnnealingTime},
  ModifyOptions[
    ExperimentIncubate,
    ResidualIncubation,
    {
      Description->"Indicates if the incubation should continue after MordantTime has finished while waiting to progress to the next step in the protocol.",
      ResolutionDescription->"Automatically set to to True if MordantTemperature is non-Ambient and the cell samples being incubated have non-ambient TransportTemperature, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordanting"
    }
  ]/.{ResidualIncubation->MordantResidualIncubation}
}];



(* ::Subsubsection::Closed:: *)
(* MordantWashOptions *)

DefineOptionSet[MordantWashOptions :> {
  (* --- Mordant Wash Options --- *)
  ModifyOptions[
    WashCellOptions,
    Wash,
    {
      Description->"Indicates whether the cell samples with Mordant should be washed after incubation.",
      ResolutionDescription->"Automatically set based on StainingMethod, and detailed in Figure XX.",
      Category->"Mordant Washing"
    }
  ]/.{Wash->MordantWash},
  ModifyOptions[
    WashCellOptions,
    NumberOfWashes,
    {
      Description->"The number of times that the cell samples with Mordant should be washed with MordantWashSolution.",
      ResolutionDescription->"Automatically set to 3 when MordantWash->True, unless otherwise specified in the StainingMethod for the cell line.",                 (* TODO determine the ideal number of washes to fully remove the Mordant- should it be different for Mordants v Mordants etc? *)
      Category->"Mordant Washing"
    }
  ]/.{NumberOfWashes->NumberOfMordantWashes},
  ModifyOptions[
    WashCellOptions,
    WashType,
    {
      Description->"The method by which the cell samples with Mordant should be washed.",
      ResolutionDescription->"Automatically set to Adherent when Wash->True, unless any Pellet-related options are set, then set to Suspension, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashType->MordantWashType},
  ModifyOptions[
    WashCellOptions,
    WashSolution,
    {
      Description->"The solution that is used to wash the cell samples with Mordant.",
      ResolutionDescription->"Automatically set based on StainingMethod, and detailed in Figure XX.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolution->MordantWashSolution},
  ModifyOptions[
    WashCellOptions,
    WashSolutionContainer
  ]/.{WashSolutionContainer->MordantWashSolutionContainer},
  ModifyOptions[
    WashCellOptions,
    WashContainer,
    {
      ResolutionDescription->"Automatically set to a container with a MaxVolume less than the MordantWashVolume if MordantWashType->Suspension, unless otherwise specified in the StainingMethod for the cell line. If MordantWashType->Adherent, set to Null.",
      Category->"Mordant Washing"
    }
  ]/.{WashContainer->MordantWashContainer},
  ModifyOptions[
    WashCellOptions,
    WashSolutionPipette,
    {
      Description->"The pipette that will be used to transfer the MordantWashSolution into the MordantWashContainer if MordantWashType->Suspension, or the current container of cell sample and Mordant if MordantWashType->Adherent.",
      ResolutionDescription->"Automatically set to the smallest pipette capable of transferring the specified MordantWashVolume, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolutionPipette->MordantWashSolutionPipette},
  ModifyOptions[
    WashCellOptions,
    WashSolutionTips,
    {
      Description->"The tips used to transfer the MordantWashSolution into the MordantWashContainer if MordantWashType->Suspension, or the current container of cell sample and Mordant if MordantWashType->Adherent.",
      ResolutionDescription->"Automatically set to the smallest tips with a MaxTransferVolume higher than the specified MordantWashVolume, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolutionTips->MordantWashSolutionTips},
  ModifyOptions[
    WashCellOptions,
    WashVolume,
    {
      Description->"The amount of MordantWashSolution that is added to the MordantWashContainer when the cells are washed if MordantWashType->Suspension, or the current container of cell sample and Mordant if MordantWashType->Adherent.",
      ResolutionDescription->"Automatically set to 3/4 of the MaxVolume of the MordantWashContainer, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashVolume->MordantWashVolume},
  ModifyOptions[
    WashCellOptions,
    WashSolutionTemperature,
    {
      Description->"The temperature to heat/cool the MordantWashSolution to before the washing occurs.",
      ResolutionDescription -> "Automatically set to 5 Minute if MordantWashSolutionTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolutionTemperature->MordantWashSolutionTemperature},
  ModifyOptions[
    WashCellOptions,
    WashSolutionEquilibrationTime,
    {
      Description->"The duration of time for which the MordantWashSolution will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if MordantWashSolutionTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolutionEquilibrationTime->MordantWashSolutionEquilibrationTime},
  ModifyOptions[
    WashCellOptions,
    MaxWashSolutionEquilibrationTime,
    {
      Description->"The maximum duration of time for which the samples will be heated/cooled to the target MordantWashSolutionEquilibrationTemperature. If they do not reach the MordantWashSolutionTemperature in the MordantWashSolutionEquilibrationTime, the sample will be checked in cycles of the MordantWashSolutionEquilibrationTime up to the MaxMordantWashSolutionEquilibrationTime. If the MordantWashSolutionTemperature is never reached, it is indicated in the MordantWashSolutionTemperatureReached field in the protocol object.",
      ResolutionDescription -> "Automatically set to 30 Minute if MordantWashSolutionTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{MaxWashSolutionEquilibrationTime->MaxMordantWashSolutionEquilibrationTime},
  ModifyOptions[
    WashCellOptions,
    WashSolutionEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the MordantWashSolution before the transfer to the cell samples and Mordant is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a MordantWashSolutionTemperature is indicated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolutionEquilibrationCheck->MordantWashSolutionEquilibrationCheck},

  (* Mordant wash solution mixing *)
  ModifyOptions[
    WashCellOptions,
    WashSolutionAspirationMix,
    {
      ResolutionDescription -> "Automatically set to True if any of the other MordantWashSolutionAspirationMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolutionAspirationMix->MordantWashSolutionAspirationMix},
  ModifyOptions[
    WashCellOptions,
    WashSolutionAspirationMixType,
    {
      ResolutionDescription -> "Automatically set to Pipette if any of the other MordantWashSolutionAspirationMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolutionAspirationMixType->MordantWashSolutionAspirationMixType},
  ModifyOptions[
    WashCellOptions,
    NumberOfWashSolutionAspirationMixes,
    {
      ResolutionDescription -> "Automatically set to 5 if any of the other MordantWashSolutionAspirationMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{NumberOfWashSolutionAspirationMixes->NumberOfMordantWashSolutionAspirationMixes},
  ModifyOptions[
    WashCellOptions,
    WashSolutionDispenseMix,
    {
      Description->"Indicates if mixing should occur after the MordantWashSolution is dispensed into the cell sample with Mordant.",
      ResolutionDescription -> "Automatically set to True if any of the other MordantWashSolutionDispenseMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolutionDispenseMix->MordantWashSolutionDispenseMix},
  ModifyOptions[
    WashCellOptions,
    WashSolutionDispenseMixType,
    {
      Description->"The type of mixing that should occur after the MordantWashSolution is dispensed into the cell sample with Mordant.",
      ResolutionDescription -> "Automatically set to Pipette if any of the other MordantWashSolutionDispenseMix options are set and a pipette is being used to do the transfer; otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolutionDispenseMixType->MordantWashSolutionDispenseMixType},
  ModifyOptions[
    WashCellOptions,
    NumberOfWashSolutionDispenseMixes,
    {
      Description->"The number of times that the cell/MordantWashSolution mixture should be mixed after dispensing the MordantWashSolution into the cell sample with Mordant.",
      ResolutionDescription -> "Automatically set to 5 if any of the other MordantWashSolutionDispenseMix options are set, unless otherwise specified in the StainingMethod for the cell line. Otherwise, set to Null.",
      Category->"Mordant Washing"
    }
  ]/.{NumberOfWashSolutionDispenseMixes->NumberOfMordantWashSolutionDispenseMixes},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubation,
    {
      Description->"Indicates if the cells with Mordant should be incubated after the MordantWashSolution is added.",
      ResolutionDescription->"Automatically set to True if MordantWash->True, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolutionIncubation->MordantWashSolutionIncubation},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubationInstrument,
    {
      Description->"The instrument used to perform the incubation of the cell sample with the MordantWashSolution.",
      ResolutionDescription -> "Automatically set based on the options MordantWashSolutionMix, MordantWashSolutionIncubationTemperature, MordantWashSolutionMixType, and container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"                                                    (* TODO add incubation logic table here *)
    }
  ]/.{WashSolutionIncubationInstrument->MordantWashSolutionIncubationInstrument},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubationTime,
    {
      Description->"The amount of time that the cells should be incubated with the MordantWashSolution.",
      ResolutionDescription->"Automatically set based on the MordantWashSolutionMixType and the MordantWashContainer, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolutionIncubationTime->MordantWashSolutionIncubationTime},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubationTemperature,
    {
      Description->"The temperature of the mix instrument while incubating the cells with the MordantWashSolution.",
      ResolutionDescription->"Automatically set based on the MordantWashSolutionMixType and the MordantWashContainer, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolutionIncubationTemperature->MordantWashSolutionIncubationTemperature},
  ModifyOptions[
    WashCellOptions,
    WashSolutionMix,
    {
      Description->"Indicates if the cells and MordantWashSolution should be mixed during MordantWashSolutionIncubation.",
      ResolutionDescription -> "Automatically set to True if any MordantWashMix options are set, unless otherwise specified in the StainingMethod for the cell line, otherwise set to False.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolutionMix->MordantWashSolutionMix},
  ModifyOptions[
    WashCellOptions,
    WashSolutionMixType,
    {
      Description->"Indicates the style of motion used to mix the cell sample with MordantWashSolution.",
      ResolutionDescription -> "Automatically set to Shake if MordantWashSolutionMix->True, unless otherwise specified in the StainingMethod for the cell line, otherwise set to Null.",
      Category->"Mordant Washing"
    }
  ]/.{WashSolutionMixType->MordantWashSolutionMixType},
  ModifyOptions[
    WashCellOptions,
    WashSolutionMixRate,
    {
      Description->"Frequency of rotation of the mixing instrument should use to mix the cells with MordantWashSolution added to them.",
      ResolutionDescription -> "Automatically set to XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"                                       (* TODO determine what the speed is set to *)
    }
  ]/.{WashSolutionMixRate->MordantWashSolutionMixRate},


  (* --- Mordant Wash Pellet Options --- *)
  {
    OptionName -> MordantWashPellet,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
    Description -> "Indicates if the cells and MordantWashSolution should be centrifuged to create a pellet after MordantWashSolutionIncubation to be able to safely aspirate the MordantWashSolution from the cells.",
    ResolutionDescription -> "Automatically set to True if any MordantWashPellet options are set, unless otherwise specified in the StainingMethod for the cell line.",
    Category->"Mordant Washing"
  },
  ModifyOptions[
    WashCellOptions,
    WashPelletInstrument,
    {
      AllowNull -> True,
      Description->"The centrifuge that will be used to spin the cell samples with MordantWashSolution added to them after MordantWashSolutionIncubation.",
      ResolutionDescription -> "Automatically set to a centrifuge that can attain the specified intensity, time, and temperature that is compatible with the MordantWashContainer, detailed in Figure XX, if MordantWashPellet->True, unless otherwise specified in the StainingMethod for the cell line; otherwise set to Null.",
      Category->"Mordant Washing"
    }
  ]/.{WashPelletInstrument->MordantWashPelletInstrument},
  ModifyOptions[
    WashCellOptions,
    WashPelletIntensity,
    {
      AllowNull -> True,
      Description->"The rotational speed or the force that will be applied to the cell samples with MordantWashSolution by centrifugation in order to create a pellet.",
      ResolutionDescription->"Automatically set to one fifth of the maximum rotational rate of the centrifuge, rounded to the nearest attainable centrifuge precision, if MordantWashPellet->True, unless otherwise specified in the StainingMethod for the cell line; otherwise set to Null.",
      Category->"Mordant Washing"
    }
  ]/.{WashPelletIntensity->MordantWashPelletIntensity},
  ModifyOptions[
    WashCellOptions,
    WashPelletTime,
    {
      Default -> Automatic,
      AllowNull -> True,
      Description->"The amount of time that the cell samples with MordantWashSolution will be centrifuged to create a pellet.",
      ResolutionDescription->"Automatically set to 5 minutes if MordantWashPellet->True, unless otherwise specified in the StainingMethod for the cell line, otherwise set to Null.",
      Category->"Mordant Washing"
    }
  ]/.{WashPelletTime->MordantWashPelletTime},
  ModifyOptions[
    WashCellOptions,
    WashPelletTemperature,
    {
      Default -> Automatic,
      AllowNull -> True,
      Description->"The temperature at which the centrifuge chamber will be held while the cell samples with MordantWashSolution are being centrifuged.",
      ResolutionDescription->"Automatically set to Ambient if MordantWashPellet->True, otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{WashPelletTemperature->MordantWashPelletTemperature},
  ModifyOptions[
    ExperimentPellet,
    SupernatantVolume,
    {
      Default -> Automatic,
      AllowNull -> True,
      Description->"The amount of supernatant that will be aspirated from the cell samples with MordantWashSolution after centrifugation created a cell pellet.",
      ResolutionDescription->"Automatically set to All if MordantWashPellet->True, otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{SupernatantVolume->MordantWashPelletSupernatantVolume},
  ModifyOptions[
    ExperimentPellet,
    SupernatantDestination,
    {
      Default -> Automatic,
      AllowNull -> True,
      ResolutionDescription->"Automatically set to Waste if MordantWashPellet->True, otherwise set to Null.",
      Description->"The container that the supernatant should be dispensed into after aspiration from the pelleted cell sample, unless otherwise specified in the StainingMethod for the cell line. If the supernatant will not be used for further experimentation, the destination should be set to Waste.",
      Category->"Mordant Washing"
    }
  ]/.{SupernatantDestination->MordantWashPelletSupernatantDestination},
  ModifyOptions[
    ExperimentPellet,
    SupernatantTransferInstrument,
    {
      AllowNull -> True,
      Description->"The pipette that will be used to transfer off the supernatant (MordantWashSolution and Mordant) from the pelleted cell sample.",
      ResolutionDescription->"Automatically set to the smallest pipette that can aspirate the volume of the pelleted cell sample and can fit into the container of the pelleted cell sample if MordantWashPellet->True, otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Mordant Washing"
    }
  ]/.{SupernatantTransferInstrument->MordantWashPelletSupernatantTransferInstrument}
}];


(* ::Subsubsection::Closed:: *)
(* DecolorizerOptions *)

DefineOptionSet[DecolorizerOptions :> {
  IndexMatching[
    IndexMatchingInput -> "experiment samples",
    {
      OptionName->Decolorizer,
      Default->Automatic,
      Description->"The chemical reagent or stock solution added to cells to remove any excess Stain and prevent overstaining.",
      ResolutionDescription->"Automatically set based on StainingMethod. Figure XX details the Decolorizer set for each StainingMethod.",
      AllowNull->True,
      Widget-> Alternatives[
        Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Sample],Object[Sample]}]
        ],
        Widget[Type->Enumeration, Pattern:>Alternatives[None]]
      ],
      Category->"Decolorizer Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName->DecolorizerVolume,
      Default->Automatic,
      Description->"The volume of the Decolorizer to add to the cells to remove excess Stain.",
      ResolutionDescription->"Automatically set to the DecolorizerVolume set in the StainingMethod, or set to the volume needed to reach the desired DecolorizerConcentration if specified, otherwise set to 10% of the MaxVolume of the container the cell samples are in.",
      AllowNull->False,
      Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,$TCMaxInoculationVolume],Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}],
      Category->"Decolorizer Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName -> DecolorizerConcentration,
      Default -> Automatic,
      ResolutionDescription -> "Automatically set to the DecolorizerConcentration set in the StainingMethod, or set to Null if cells are not suspended in solution, or set to the calculated concentration of the DecolorizerAnalyte in the Decolorizer as specified in the StainingMethod.",
      Description -> "The final concentration of the DecolorizerAnalyte in the cell suspension after dilution of the Decolorizer in the media the cells are suspended in.",
      AllowNull->True,
      Widget -> Alternatives[
        "Concentration"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Molar, 10 Molar],
          Units -> {1, {Micromolar, {Nanomolar, Micromolar, Millimolar, Molar}}}
        ],
        "Mass Concentration"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Gram/Liter, 1000 Gram/Liter],
          Units -> CompoundUnit[
            {1, {Milligram, {Microgram, Milligram, Gram}}},
            {-1, {Liter, {Microliter, Milliliter, Liter}}}
          ]
        ],
        "Volume Percent"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 VolumePercent, 100 VolumePercent],
          Units -> VolumePercent
        ],
        "Mass Percent"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 MassPercent, 100 MassPercent],
          Units -> MassPercent
        ]
      ],
      Category -> "Decolorizer Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName->DecolorizerAnalyte,
      Default->Automatic,
      Description->"The active substance of interest which causes decolorizing and whose concentration in the final cell and Decolorizer mixture is specified by the DecolorizerConcentration option.",
      ResolutionDescription->"Automatically set to the DecolorizerAnalyte set in the StainingMethod, or set to the first analyte in the Composition field of the Decolorizer determined using the Analytes field of the Model[Sample], or if none exist, the first identity model of any kind in the Composition field.",
      AllowNull->True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[List @@ IdentityModelTypeP]
      ],
      Category->"Decolorizer Preparation",
      NestedIndexMatching -> True
    },

    {
      OptionName -> DecolorizerSourceTemperature,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Alternatives[
        Widget[Type -> Quantity, Pattern :> RangeP[25 Celsius, 90 Celsius],Units :> Celsius],
        Widget[Type->Enumeration,Pattern:>Alternatives[CryogenicStorage,DeepFreezer,Freezer,Refrigerator,Ambient]]
      ],
      Description -> "The desired temperature of the Decolorizer prior to transferring to the cell samples.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the StainingMethod for the cell line.",
      Category -> "Decolorizer Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName -> DecolorizerSourceEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description -> "The minimum duration of time for which the Decolorizer will be heated/cooled to the target DecolorizerSourceTemperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if DecolorizerSourceTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName -> MaxDecolorizerSourceEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description->"The maximum duration of time for which the Decolorizer will be heated/cooled to the target DecolorizerSourceEquilibrationTemperature. If they do not reach the DecolorizerSourceTemperature in the DecolorizerSourceEquilibrationTime, the sample will be checked in cycles of the DecolorizerSourceEquilibrationTime up to the MaxDecolorizerSourceEquilibrationTime. If the DecolorizerSourceTemperature is never reached, it is indicated in the DecolorizerSourceTemperatureReached field in the protocol object.",
      ResolutionDescription -> "Automatically set to 30 Minute if DecolorizerSourceTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName->DecolorizerSourceEquilibrationCheck,
      Default->Automatic,
      AllowNull->True,
      Widget->Widget[
        Type->Enumeration,
        Pattern:>EquilibrationCheckP
      ],
      Description->"The method by which to verify the temperature of the Decolorizer before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a DecolorizerSourceTemperature is indicated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Preparation",
      NestedIndexMatching -> True
    },

    {
      OptionName -> DecolorizerDestinationTemperature,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Alternatives[
        Widget[Type -> Quantity, Pattern :> RangeP[25 Celsius, 90 Celsius],Units :> Celsius],
        Widget[Type->Enumeration,Pattern:>Alternatives[CryogenicStorage,DeepFreezer,Freezer,Refrigerator,Ambient]]
      ],
      Description -> "The desired temperature of the cells prior to transferring the Decolorizer to them.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the StainingMethod for the cell line.",
      Category -> "Decolorizer Preparation"
    },
    {
      OptionName -> DecolorizerDestinationEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description -> "The minimum duration of time for which the cell samples will be heated/cooled to the target DecolorizerDestinationTemperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if DecolorizerDestinationTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Preparation"
    },
    {
      OptionName -> MaxDecolorizerDestinationEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description->"The maximum duration of time for which the cell samples will be heated/cooled to the target DecolorizerDestinationEquilibrationTemperature. If they do not reach the DecolorizerDestinationTemperature in the DecolorizerDestinationEquilibrationTime, the sample will be checked in cycles of the DecolorizerDestinationEquilibrationTime up to the MaxDecolorizerDestinationEquilibrationTime. If the DecolorizerDestinationTemperature is never reached, it is indicated in the DecolorizerDestinationTemperatureReached field in the protocol object.",
      ResolutionDescription -> "Automatically set to 30 Minute if DecolorizerDestinationTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Preparation"
    },
    {
      OptionName->DecolorizerDestinationEquilibrationCheck,
      Default->Automatic,
      AllowNull->True,
      Widget->Widget[
        Type->Enumeration,
        Pattern:>EquilibrationCheckP
      ],
      Description->"The method by which to verify the temperature of the cell samples before adding the Decolorizer.",
      ResolutionDescription -> "Automatically set to IRThermometer if a DecolorizerDestinationTemperature is indicated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Preparation"
    }
  ]
}];


(* ::Subsubsection::Closed:: *)
(* DecolorizerMixOptions *)

DefineOptionSet[DecolorizerMixOptions :> {
  ModifyOptions[
    ExperimentIncubate,
    Mix,
    {
      Description -> "Indicates if the cell samples should be mixed and/or incubated after adding the Decolorizer.",
      ResolutionDescription -> "Automatically set to True if any DecolorizerMix related options are set, otherwise set to False, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizing"
    }
  ]/.{Mix->DecolorizerMix},
  ModifyOptions[
    ExperimentIncubate,
    MixType,
    {
      Widget -> Widget[Type -> Enumeration, Pattern :> CellMixTypeP],   (*Roll | Vortex | Pipette | Invert | Shake | Swirl | Nutate*)
      Description -> "Indicates the style of motion used to mix the cell sample with Decolorizer added to it.",
      ResolutionDescription -> "Automatically set based on the container of the sample and the DecolorizerMix option, unless otherwise specified in the StainingMethod for the cell line. Specifically, if DecolorizerMix is set to False, the option is set to Null. If DecolorizerMixInstrument is specified, the option is set based on the specified DecolorizerMixInstrument.  If DecolorizerMixRate and DecolorizerTime are Null, when DecolorizerMixVolume is Null or larger than 50ml, the option is set to Invert, otherwise set to Pipette. If DecolorizerMixRate is set, the option is set base on any instrument that is capable of mixing the sample at the specified DecolorizerMixRate.",
      Category->"Decolorizing"
    }
  ]/.{MixType->DecolorizerMixType},
  {
    OptionName -> DecolorizerMixInstrument,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[
      Type->Object,
      Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]
    ],
    Description -> "The instrument used to perform the DecolorizerMix and/or Incubation.",
    ResolutionDescription -> "Automatically set based on the options DecolorizerMix, DecolorizerTemperature, DecolorizerMixType and container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",                 (* TODO add table of mix logic here *)
    Category->"Decolorizing"
  },
  ModifyOptions[
    ExperimentIncubate,
    Time,
    {
      Description -> "Duration of time for which the cell samples will be mixed with the Decolorizer.",
      ResolutionDescription -> "Automatically set based on the DecolorizerMixType and container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizing"
    }
  ]/.{Time->DecolorizerTime},
  ModifyOptions[
    ExperimentIncubate,
    MixRate,
    {
      Description -> "Frequency of rotation the DecolorizerMixInstrument will use to mix the cell samples with Decolorizer added to them.",
      ResolutionDescription -> "Automatically set based on the DecolorizerMixInstrument model and the container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizing"
    }
  ]/.{MixRate->DecolorizerMixRate},
  ModifyOptions[
    ExperimentIncubate,
    MixRateProfile,
    {
      Description -> "Frequency of rotation the DecolorizerMixInstrument will use to mix the cell samples with Decolorizer added to them, over the course of time.",
      ResolutionDescription -> "Automatically set if the DecolorizerMixInstrument is set to Model[Instrument,Shaker,\"Torrey Pines\"], otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizing"
    }
  ]/.{MixRateProfile->DecolorizerMixRateProfile},
  ModifyOptions[
    ExperimentIncubate,
    NumberOfMixes,
    {
      Description -> "Number of times the cell samples should be mixed with Decolorizer if DecolorizerMixType->Pipette or Invert.",
      ResolutionDescription -> "Automatically set based on the DecolorizerMixType as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizing"
    }
  ]/.{NumberOfMixes->DecolorizerNumberOfMixes},
  ModifyOptions[
    ExperimentIncubate,
    MixVolume,
    {
      Description -> "The volume of the cell sample and Decolorizer that should be pipetted up and down to mix if DecolorizerMixType->Pipette.",
      ResolutionDescription -> "Automatically set based on the DecolorizerMixType as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizing"
    }
  ]/.{MixVolume->DecolorizerMixVolume},
  ModifyOptions[
    ExperimentIncubate,
    Temperature,
    {
      Description -> "The temperature of the device at which to hold the cell samples after adding the Decolorizer.",
      ResolutionDescription -> "Automatically set based on the DecolorizerMixType as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizing"
    }
  ]/.{Temperature->DecolorizerTemperature},
  ModifyOptions[
    ExperimentIncubate,
    TemperatureProfile,
    {
      Description -> "The temperature of the device at which to hold the cell samples after adding the Decolorizer, over the course of time.",
      ResolutionDescription -> "Automatically set based on the DecolorizerMixInstrument as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizing"
    }
  ]/.{TemperatureProfile->DecolorizerTemperatureProfile},
  ModifyOptions[
    ExperimentIncubate,
    AnnealingTime,
    {
      Description->"Minimum duration for which the cell samples after adding the Decolorizer should remain in the incubator allowing the system to settle to room temperature after the DecolorizerTime has passed.",
      ResolutionDescription->"Automatically set to to 0 Minute if other incubation options are set, or to Null in cases where the sample is not being incubated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizing"
    }
  ]/.{AnnealingTime->DecolorizerAnnealingTime},
  ModifyOptions[
    ExperimentIncubate,
    ResidualIncubation,
    {
      Description->"Indicates if the incubation should continue after DecolorizerTime has finished while waiting to progress to the next step in the protocol.",
      ResolutionDescription->"Automatically set to to True if DecolorizerTemperature is non-Ambient and the cell samples being incubated have non-Ambient TransportTemperature, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizing"
    }
  ]/.{ResidualIncubation->DecolorizerResidualIncubation}
}];



(* ::Subsubsection::Closed:: *)
(* DecolorizerWashOptions *)

DefineOptionSet[DecolorizerWashOptions :> {
  ModifyOptions[
    WashCellOptions,
    Wash,
    {
      Description->"Indicates whether the cell samples with Decolorizer should be washed after incubation.",
      ResolutionDescription->"Automatically set based on StainingMethod, and detailed in Figure XX.",
      Category->"Decolorizer Washing"
    }
  ]/.{Wash->DecolorizerWash},
  ModifyOptions[
    WashCellOptions,
    NumberOfWashes,
    {
      Description->"The number of times that the cell samples with Decolorizer should be washed with DecolorizerWashSolution.",
      ResolutionDescription->"Automatically set to 3 when DecolorizerWash->True, unless otherwise specified in the StainingMethod for the cell line.",                 (* TODO determine the ideal number of washes to fully remove the Decolorizer- should it be different for Decolorizers v Mordants etc? *)
      Category->"Decolorizer Washing"
    }
  ]/.{NumberOfWashes->NumberOfDecolorizerWashes},
  ModifyOptions[
    WashCellOptions,
    WashType,
    {
      Description->"The method by which the cell samples with Decolorizer should be washed.",
      ResolutionDescription->"Automatically set to Adherent when Wash->True, unless any Pellet-related options are set, then set to Suspension, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashType->DecolorizerWashType},
  ModifyOptions[
    WashCellOptions,
    WashSolution,
    {
      Description->"The solution that is used to wash the cell samples with Decolorizer.",
      ResolutionDescription->"Automatically set based on StainingMethod, and detailed in Figure XX.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolution->DecolorizerWashSolution},
  ModifyOptions[
    WashCellOptions,
    WashSolutionContainer
  ]/.{WashSolutionContainer->DecolorizerWashSolutionContainer},
  ModifyOptions[
    WashCellOptions,
    WashContainer,
    {
      ResolutionDescription->"Automatically set to a container with a MaxVolume less than the DecolorizerWashVolume if DecolorizerWashType->Suspension, unless otherwise specified in the StainingMethod for the cell line. If DecolorizerWashType->Adherent, set to Null.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashContainer->DecolorizerWashContainer},
  ModifyOptions[
    WashCellOptions,
    WashSolutionPipette,
    {
      Description->"The pipette that will be used to transfer the DecolorizerWashSolution into the DecolorizerWashContainer if DecolorizerWashType->Suspension, or the current container of cell sample and Decolorizer if DecolorizerWashType->Adherent.",
      ResolutionDescription->"Automatically set to the smallest pipette capable of transferring the specified DecolorizerWashVolume, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolutionPipette->DecolorizerWashSolutionPipette},
  ModifyOptions[
    WashCellOptions,
    WashSolutionTips,
    {
      Description->"The tips used to transfer the DecolorizerWashSolution into the DecolorizerWashContainer if DecolorizerWashType->Suspension, or the current container of cell sample and Decolorizer if DecolorizerWashType->Adherent.",
      ResolutionDescription->"Automatically set to the smallest tips with a MaxTransferVolume higher than the specified DecolorizerWashVolume, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolutionTips->DecolorizerWashSolutionTips},
  ModifyOptions[
    WashCellOptions,
    WashVolume,
    {
      Description->"The amount of DecolorizerWashSolution that is added to the DecolorizerWashContainer when the cells are washed if DecolorizerWashType->Suspension, or the current container of cell sample and Decolorizer if DecolorizerWashType->Adherent.",
      ResolutionDescription->"Automatically set to 3/4 of the MaxVolume of the DecolorizerWashContainer, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashVolume->DecolorizerWashVolume},
  ModifyOptions[
    WashCellOptions,
    WashSolutionTemperature,
    {
      Description->"The temperature to heat/cool the DecolorizerWashSolution to before the washing occurs.",
      ResolutionDescription -> "Automatically set to 5 Minute if DecolorizerWashSolutionTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolutionTemperature->DecolorizerWashSolutionTemperature},
  ModifyOptions[
    WashCellOptions,
    WashSolutionEquilibrationTime,
    {
      Description->"The duration of time for which the DecolorizerWashSolution will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if DecolorizerWashSolutionTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolutionEquilibrationTime->DecolorizerWashSolutionEquilibrationTime},
  ModifyOptions[
    WashCellOptions,
    MaxWashSolutionEquilibrationTime,
    {
      Description->"The maximum duration of time for which the samples will be heated/cooled to the target DecolorizerWashSolutionEquilibrationTemperature. If they do not reach the DecolorizerWashSolutionTemperature in the DecolorizerWashSolutionEquilibrationTime, the sample will be checked in cycles of the DecolorizerWashSolutionEquilibrationTime up to the MaxDecolorizerWashSolutionEquilibrationTime. If the DecolorizerWashSolutionTemperature is never reached, it is indicated in the DecolorizerWashSolutionTemperatureReached field in the protocol object.",
      ResolutionDescription -> "Automatically set to 30 Minute if DecolorizerWashSolutionTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{MaxWashSolutionEquilibrationTime->MaxDecolorizerWashSolutionEquilibrationTime},
  ModifyOptions[
    WashCellOptions,
    WashSolutionEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the DecolorizerWashSolution before the transfer to the cell samples and Decolorizer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a DecolorizerWashSolutionTemperature is indicated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolutionEquilibrationCheck->DecolorizerWashSolutionEquilibrationCheck},

  (* DecolorizerWashSolution Mixing *)
  ModifyOptions[
    WashCellOptions,
    WashSolutionAspirationMix,
    {
      ResolutionDescription -> "Automatically set to True if any of the other DecolorizerWashSolutionAspirationMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolutionAspirationMix->DecolorizerWashSolutionAspirationMix},
  ModifyOptions[
    WashCellOptions,
    WashSolutionAspirationMixType,
    {
      ResolutionDescription -> "Automatically set to Pipette if any of the other DecolorizerWashSolutionAspirationMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolutionAspirationMixType->DecolorizerWashSolutionAspirationMixType},
  ModifyOptions[
    WashCellOptions,
    NumberOfWashSolutionAspirationMixes,
    {
      ResolutionDescription -> "Automatically set to 5 if any of the other DecolorizerWashSolutionAspirationMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{NumberOfWashSolutionAspirationMixes->NumberOfDecolorizerWashSolutionAspirationMixes},
  ModifyOptions[
    WashCellOptions,
    WashSolutionDispenseMix,
    {
      Description->"Indicates if mixing should occur after the DecolorizerWashSolution is dispensed into the cell sample with Decolorizer.",
      ResolutionDescription -> "Automatically set to True if any of the other DecolorizerWashSolutionDispenseMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolutionDispenseMix->DecolorizerWashSolutionDispenseMix},
  ModifyOptions[
    WashCellOptions,
    WashSolutionDispenseMixType,
    {
      Description->"The type of mixing that should occur after the DecolorizerWashSolution is dispensed into the cell sample with Decolorizer.",
      ResolutionDescription -> "Automatically set to Pipette if any of the other DecolorizerWashSolutionDispenseMix options are set and a pipette is being used to do the transfer; otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolutionDispenseMixType->DecolorizerWashSolutionDispenseMixType},
  ModifyOptions[
    WashCellOptions,
    NumberOfWashSolutionDispenseMixes,
    {
      Description->"The number of times that the cell/DecolorizerWashSolution mixture should be mixed after dispensing the DecolorizerWashSolution into the cell sample with Decolorizer.",
      ResolutionDescription -> "Automatically set to 5 if any of the other DecolorizerWashSolutionDispenseMix options are set, unless otherwise specified in the StainingMethod for the cell line. Otherwise, set to Null.",
      Category->"Decolorizer Washing"
    }
  ]/.{NumberOfWashSolutionDispenseMixes->NumberOfDecolorizerWashSolutionDispenseMixes},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubation,
    {
      Description->"Indicates if the cells with Decolorizer should be incubated after the DecolorizerWashSolution is added.",
      ResolutionDescription->"Automatically set to True if DecolorizerWash->True, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolutionIncubation->DecolorizerWashSolutionIncubation},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubationInstrument,
    {
      Description->"The instrument used to perform the incubation of the cell sample with the DecolorizerWashSolution.",
      ResolutionDescription -> "Automatically set based on the options DecolorizerWashSolutionMix, DecolorizerWashSolutionIncubationTemperature, DecolorizerWashSolutionMixType, and container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"                                                    (* TODO add incubation logic table here *)
    }
  ]/.{WashSolutionIncubationInstrument->DecolorizerWashSolutionIncubationInstrument},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubationTime,
    {
      Description->"The amount of time that the cells should be incubated with the DecolorizerWashSolution.",
      ResolutionDescription->"Automatically set based on the DecolorizerWashSolutionMixType and the DecolorizerWashContainer, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolutionIncubationTime->DecolorizerWashSolutionIncubationTime},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubationTemperature,
    {
      Description->"The temperature of the mix instrument while incubating the cells with the DecolorizerWashSolution.",
      ResolutionDescription->"Automatically set based on the DecolorizerWashSolutionMixType and the DecolorizerWashContainer, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolutionIncubationTemperature->DecolorizerWashSolutionIncubationTemperature},
  ModifyOptions[
    WashCellOptions,
    WashSolutionMix,
    {
      Description->"Indicates if the cells and DecolorizerWashSolution should be mixed during DecolorizerWashSolutionIncubation.",
      ResolutionDescription -> "Automatically set to True if any DecolorizerWashMix options are set, unless otherwise specified in the StainingMethod for the cell line, otherwise set to False.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolutionMix->DecolorizerWashSolutionMix},
  ModifyOptions[
    WashCellOptions,
    WashSolutionMixType,
    {
      Description->"Indicates the style of motion used to mix the cell sample with DecolorizerWashSolution.",
      ResolutionDescription -> "Automatically set to Shake if DecolorizerWashSolutionMix->True, unless otherwise specified in the StainingMethod for the cell line, otherwise set to Null.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashSolutionMixType->DecolorizerWashSolutionMixType},
  ModifyOptions[
    WashCellOptions,
    WashSolutionMixRate,
    {
      Description->"Frequency of rotation of the mixing instrument should use to mix the cells with DecolorizerWashSolution added to them.",
      ResolutionDescription -> "Automatically set to XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"                                       (* TODO determine what the speed is set to *)
    }
  ]/.{WashSolutionMixRate->DecolorizerWashSolutionMixRate},


  (* --- Decolorizer Wash Pellet Options --- *)
  {
    OptionName -> DecolorizerWashPellet,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
    Description -> "Indicates if the cells and DecolorizerWashSolution should be centrifuged to create a pellet after DecolorizerWashSolutionIncubation to be able to safely aspirate the DecolorizerWashSolution from the cells.",
    ResolutionDescription -> "Automatically set to True if any DecolorizerWashPellet options are set, unless otherwise specified in the StainingMethod for the cell line.",
    Category->"Decolorizer Washing"
  },
  ModifyOptions[
    WashCellOptions,
    WashPelletInstrument,
    {
      AllowNull -> True,
      Description->"The centrifuge that will be used to spin the cell samples with DecolorizerWashSolution added to them after DecolorizerWashSolutionIncubation.",
      ResolutionDescription -> "Automatically set to a centrifuge that can attain the specified intensity, time, and temperature that is compatible with the DecolorizerWashContainer, detailed in Figure XX, if DecolorizerWashPellet->True, unless otherwise specified in the StainingMethod for the cell line; otherwise set to Null.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashPelletInstrument->DecolorizerWashPelletInstrument},
  ModifyOptions[
    WashCellOptions,
    WashPelletIntensity,
    {
      AllowNull -> True,
      Description->"The rotational speed or the force that will be applied to the cell samples with DecolorizerWashSolution by centrifugation in order to create a pellet.",
      ResolutionDescription->"Automatically set to one fifth of the maximum rotational rate of the centrifuge, rounded to the nearest attainable centrifuge precision, if DecolorizerWashPellet->True, unless otherwise specified in the StainingMethod for the cell line; otherwise set to Null.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashPelletIntensity->DecolorizerWashPelletIntensity},
  ModifyOptions[
    WashCellOptions,
    WashPelletTime,
    {
      Default -> Automatic,
      AllowNull -> True,
      Description->"The amount of time that the cell samples with DecolorizerWashSolution will be centrifuged to create a pellet.",
      ResolutionDescription->"Automatically set to 5 minutes if DecolorizerWashPellet->True, unless otherwise specified in the StainingMethod for the cell line, otherwise set to Null.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashPelletTime->DecolorizerWashPelletTime},
  ModifyOptions[
    WashCellOptions,
    WashPelletTemperature,
    {
      Default -> Automatic,
      AllowNull -> True,
      Description->"The temperature at which the centrifuge chamber will be held while the cell samples with DecolorizerWashSolution are being centrifuged.",
      ResolutionDescription->"Automatically set to Ambient if DecolorizerWashPellet->True, otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{WashPelletTemperature->DecolorizerWashPelletTemperature},
  ModifyOptions[
    ExperimentPellet,
    SupernatantVolume,
    {
      Default -> Automatic,
      AllowNull -> True,
      Description->"The amount of supernatant that will be aspirated from the cell samples with DecolorizerWashSolution after centrifugation created a cell pellet.",
      ResolutionDescription->"Automatically set to All if DecolorizerWashPellet->True, otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{SupernatantVolume->DecolorizerWashPelletSupernatantVolume},
  ModifyOptions[
    ExperimentPellet,
    SupernatantDestination,
    {
      Default -> Automatic,
      AllowNull -> True,
      ResolutionDescription->"Automatically set to Waste if DecolorizerWashPellet->True, otherwise set to Null.",
      Description->"The container that the supernatant should be dispensed into after aspiration from the pelleted cell sample, unless otherwise specified in the StainingMethod for the cell line. If the supernatant will not be used for further experimentation, the destination should be set to Waste.",
      Category->"Decolorizer Washing"
    }
  ]/.{SupernatantDestination->DecolorizerWashPelletSupernatantDestination},
  ModifyOptions[
    ExperimentPellet,
    SupernatantTransferInstrument,
    {
      AllowNull -> True,
      Description->"The pipette that will be used to transfer off the supernatant (DecolorizerWashSolution and Decolorizer) from the pelleted cell sample.",
      ResolutionDescription->"Automatically set to the smallest pipette that can aspirate the volume of the pelleted cell sample and can fit into the container of the pelleted cell sample if DecolorizerWashPellet->True, otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Decolorizer Washing"
    }
  ]/.{SupernatantTransferInstrument->DecolorizerWashPelletSupernatantTransferInstrument}
}];



(* ::Subsubsection::Closed:: *)
(* CounterStainOptions *)

DefineOptionSet[CounterStainOptions :> {
  IndexMatching[
    IndexMatchingInput -> "experiment samples",
    {
      OptionName->CounterStain,
      Default->Automatic,
      Description->"The chemical reagent or stock solution added to cells with a contrasting color to the principal Stain to stain contrasting features in the cells for improved visibility.",
      ResolutionDescription->"Automatically set based on StainingMethod. Figure XX details the CounterStain set for each StainingMethod.",
      AllowNull->True,
      Widget-> Alternatives[
        Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Sample],Object[Sample]}]
        ],
        Widget[Type->Enumeration,Pattern:>Alternatives[None]]
      ],
      Category->"CounterStain Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName->CounterStainVolume,
      Default->Automatic,
      Description->"The volume of the CounterStain to add to the cells to color them in a contrasting color.",
      ResolutionDescription->"Automatically set to the CounterStainVolume set in the StainingMethod, or set to the volume needed to reach the desired CounterStainConcentration if specified, otherwise set to 10% of the MaxVolume of the container the cell samples are in.",
      AllowNull->False,
      Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,$TCMaxInoculationVolume],Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}],
      Category->"CounterStain Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName -> CounterStainConcentration,
      Default -> Automatic,
      ResolutionDescription -> "Automatically set to the CounterStainConcentration set in the StainingMethod, or set to Null if cells are not suspended in solution, or set to the calculated concentration of the CounterStainAnalyte in the CounterStain as specified in the StainingMethod.",
      Description -> "The final concentration of the CounterStainAnalyte in the cell suspension after dilution of the CounterStain in the media the cells are suspended in.",
      AllowNull->True,
      Widget -> Alternatives[
        "Concentration"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Molar, 10 Molar],
          Units -> {1, {Micromolar, {Nanomolar, Micromolar, Millimolar, Molar}}}
        ],
        "Mass Concentration"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Gram/Liter, 1000 Gram/Liter],
          Units -> CompoundUnit[
            {1, {Milligram, {Microgram, Milligram, Gram}}},
            {-1, {Liter, {Microliter, Milliliter, Liter}}}
          ]
        ],
        "Volume Percent"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 VolumePercent, 100 VolumePercent],
          Units -> VolumePercent
        ],
        "Mass Percent"->Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 MassPercent, 100 MassPercent],
          Units -> MassPercent
        ]
      ],
      Category -> "CounterStain Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName->CounterStainAnalyte,
      Default->Automatic,
      Description->"The active substance of interest which causes contrasting staining and whose concentration in the final cell and stain mixture is specified by the CounterStainConcentration option.",
      ResolutionDescription->"Automatically set to the CounterStainAnalyte set in the StainingMethod, or set to the first analyte in the Composition field of the CounterStain determined using the Analytes field of the Model[Sample], or if none exist, the first identity model of any kind in the Composition field.",
      AllowNull->True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[List @@ IdentityModelTypeP]
      ],
      Category->"CounterStain Preparation",
      NestedIndexMatching -> True
    },

    {
      OptionName -> CounterStainSourceTemperature,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Alternatives[
        Widget[Type -> Quantity, Pattern :> RangeP[25 Celsius, 90 Celsius],Units :> Celsius],
        Widget[Type->Enumeration,Pattern:>Alternatives[CryogenicStorage,DeepFreezer,Freezer,Refrigerator,Ambient]]
      ],
      Description -> "The desired temperature of the CounterStain prior to transferring to the cell samples.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the StainingMethod for the cell line.",
      Category -> "CounterStain Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName -> CounterStainSourceEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description -> "The minimum duration of time for which the CounterStain will be heated/cooled to the target CounterStainSourceTemperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if CounterStainSourceTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName -> MaxCounterStainSourceEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description->"The maximum duration of time for which the CounterStain will be heated/cooled to the target CounterStainSourceEquilibrationTemperature. If they do not reach the CounterStainSourceTemperature in the CounterStainSourceEquilibrationTime, the sample will be checked in cycles of the CounterStainSourceEquilibrationTime up to the MaxCounterStainSourceEquilibrationTime. If the CounterStainSourceTemperature is never reached, it is indicated in the CounterStainSourceTemperatureReached field in the protocol object.",
      ResolutionDescription -> "Automatically set to 30 Minute if CounterStainSourceTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Preparation",
      NestedIndexMatching -> True
    },
    {
      OptionName->CounterStainSourceEquilibrationCheck,
      Default->Automatic,
      AllowNull->True,
      Widget->Widget[
        Type->Enumeration,
        Pattern:>EquilibrationCheckP
      ],
      Description->"The method by which to verify the temperature of the CounterStain before the transfer is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a CounterStainSourceTemperature is indicated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Preparation",
      NestedIndexMatching -> True
    },

    {
      OptionName -> CounterStainDestinationTemperature,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Alternatives[
        Widget[Type -> Quantity, Pattern :> RangeP[25 Celsius, 90 Celsius],Units :> Celsius],
        Widget[Type->Enumeration,Pattern:>Alternatives[CryogenicStorage,DeepFreezer,Freezer,Refrigerator,Ambient]]
      ],
      Description -> "The desired temperature of the cells prior to transferring the CounterStain to them.",
      ResolutionDescription -> "Automatically set to Null (Ambient), unless otherwise specified in the StainingMethod for the cell line.",
      Category -> "CounterStain Preparation"
    },
    {
      OptionName -> CounterStainDestinationEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description -> "The minimum duration of time for which the cell samples will be heated/cooled to the target CounterStainDestinationTemperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if CounterStainDestinationTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Preparation"
    },
    {
      OptionName -> MaxCounterStainDestinationEquilibrationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description->"The maximum duration of time for which the cell samples will be heated/cooled to the target CounterStainDestinationEquilibrationTemperature. If they do not reach the CounterStainDestinationTemperature in the CounterStainDestinationEquilibrationTime, the sample will be checked in cycles of the CounterStainDestinationEquilibrationTime up to the MaxCounterStainDestinationEquilibrationTime. If the CounterStainDestinationTemperature is never reached, it is indicated in the CounterStainDestinationTemperatureReached field in the protocol object.",
      ResolutionDescription -> "Automatically set to 30 Minute if CounterStainDestinationTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Preparation"
    },
    {
      OptionName->CounterStainDestinationEquilibrationCheck,
      Default->Automatic,
      AllowNull->True,
      Widget->Widget[
        Type->Enumeration,
        Pattern:>EquilibrationCheckP
      ],
      Description->"The method by which to verify the temperature of the cell samples before adding the CounterStain.",
      ResolutionDescription -> "Automatically set to IRThermometer if a CounterStainDestinationTemperature is indicated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Preparation"
    }
  ]
}];


(* ::Subsubsection::Closed:: *)
(* CounterStainMixOptions *)

DefineOptionSet[CounterStainMixOptions :> {
  (* --- CounterStain Mix --- *)
  ModifyOptions[
    ExperimentIncubate,
    Mix,
    {
      Description -> "Indicates if the cell samples should be mixed and/or incubated after adding the CounterStain.",
      ResolutionDescription -> "Automatically set to True if any CounterStainMix related options are set, otherwise set to False, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Counter Staining"
    }
  ]/.{Mix->CounterStainMix},
  ModifyOptions[
    ExperimentIncubate,
    MixType,
    {
      Widget -> Widget[Type -> Enumeration, Pattern :> CellMixTypeP],   (*Roll | Vortex | Pipette | Invert | Shake | Swirl | Nutate*)
      Description -> "Indicates the style of motion used to mix the cell sample with CounterStain added to it.",
      ResolutionDescription -> "Automatically set based on the container of the sample and the CounterStainMix option, unless otherwise specified in the StainingMethod for the cell line. Specifically, if CounterStainMix is set to False, the option is set to Null. If CounterStainMixInstrument is specified, the option is set based on the specified CounterStainMixInstrument.  If CounterStainMixRate and CounterStainTime are Null, when CounterStainMixVolume is Null or larger than 50ml, the option is set to Invert, otherwise set to Pipette. If CounterStainMixRate is set, the option is set base on any instrument that is capable of mixing the sample at the specified CounterStainMixRate.",
      Category->"Counter Staining"
    }
  ]/.{MixType->CounterStainMixType},
  {
    OptionName -> CounterStainMixInstrument,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[
      Type->Object,
      Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]
    ],
    Description -> "The instrument used to perform the CounterStainMix and/or Incubation.",
    ResolutionDescription -> "Automatically set based on the options CounterStainMix, CounterStainTemperature, CounterStainMixType and container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",                 (* TODO add table of mix logic here *)
    Category->"Counter Staining"
  },
  ModifyOptions[
    ExperimentIncubate,
    Time,
    {
      Description -> "Duration of time for which the cell samples will be mixed with the CounterStain.",
      ResolutionDescription -> "Automatically set based on the CounterStainMixType and container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Counter Staining"
    }
  ]/.{Time->CounterStainTime},
  ModifyOptions[
    ExperimentIncubate,
    MixRate,
    {
      Description -> "Frequency of rotation the CounterStainMixInstrument will use to mix the cell samples with CounterStain added to them.",
      ResolutionDescription -> "Automatically set based on the CounterStainMixInstrument model and the container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Counter Staining"
    }
  ]/.{MixRate->CounterStainMixRate},
  ModifyOptions[
    ExperimentIncubate,
    MixRateProfile,
    {
      Description -> "Frequency of rotation the CounterStainMixInstrument will use to mix the cell samples with CounterStain added to them, over the course of time.",
      ResolutionDescription -> "Automatically set if the CounterStainMixInstrument is set to Model[Instrument,Shaker,\"Torrey Pines\"], otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Counter Staining"
    }
  ]/.{MixRateProfile->CounterStainMixRateProfile},
  ModifyOptions[
    ExperimentIncubate,
    NumberOfMixes,
    {
      Description -> "Number of times the cell samples should be mixed with CounterStain if CounterStainMixType->Pipette or Invert.",
      ResolutionDescription -> "Automatically set based on the CounterStainMixType as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Counter Staining"
    }
  ]/.{NumberOfMixes->CounterStainNumberOfMixes},
  ModifyOptions[
    ExperimentIncubate,
    MixVolume,
    {
      Description -> "The volume of the cell sample and CounterStain that should be pipetted up and down to mix if CounterStainMixType->Pipette.",
      ResolutionDescription -> "Automatically set based on the CounterStainMixType as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Counter Staining"
    }
  ]/.{MixVolume->CounterStainMixVolume},
  ModifyOptions[
    ExperimentIncubate,
    Temperature,
    {
      Description -> "The temperature of the device at which to hold the cell samples after adding the CounterStain.",
      ResolutionDescription -> "Automatically set based on the CounterStainMixType as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Counter Staining"
    }
  ]/.{Temperature->CounterStainTemperature},
  ModifyOptions[
    ExperimentIncubate,
    TemperatureProfile,
    {
      Description -> "The temperature of the device at which to hold the cell samples after adding the CounterStain, over the course of time.",
      ResolutionDescription -> "Automatically set based on the CounterStainMixInstrument as detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Counter Staining"
    }
  ]/.{TemperatureProfile->CounterStainTemperatureProfile},
  ModifyOptions[
    ExperimentIncubate,
    AnnealingTime,
    {
      Description->"Minimum duration for which the cell samples after adding the CounterStain should remain in the incubator allowing the system to settle to room temperature after the CounterStainTime has passed.",
      ResolutionDescription->"Automatically set to to 0 Minute if other incubation options are set, or to Null in cases where the sample is not being incubated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Counter Staining"
    }
  ]/.{AnnealingTime->CounterStainAnnealingTime},
  ModifyOptions[
    ExperimentIncubate,
    ResidualIncubation,
    {
      Description->"Indicates if the incubation should continue after CounterStainTime has finished while waiting to progress to the next step in the protocol.",
      ResolutionDescription->"Automatically set to to True if CounterStainTemperature is non-Ambient and the cell samples being incubated have non-Ambient TransportTemperature, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"Counter Staining"
    }
  ]/.{ResidualIncubation->CounterStainResidualIncubation}
}];



(* ::Subsubsection::Closed:: *)
(* CounterStainWashOptions *)

DefineOptionSet[CounterStainWashOptions :> {
  (* --- CounterStain Wash Options --- *)
  ModifyOptions[
    WashCellOptions,
    Wash,
    {
      Description->"Indicates whether the cell samples with CounterStain should be washed after incubation.",
      ResolutionDescription->"Automatically set based on StainingMethod, and detailed in Figure XX.",
      Category->"CounterStain Washing"
    }
  ]/.{Wash->CounterStainWash},
  ModifyOptions[
    WashCellOptions,
    NumberOfWashes,
    {
      Description->"The number of times that the cell samples with CounterStain should be washed with CounterStainWashSolution.",
      ResolutionDescription->"Automatically set to 3 when CounterStainWash->True, unless otherwise specified in the StainingMethod for the cell line.",                 (* TODO determine the ideal number of washes to fully remove the CounterStain- should it be different for CounterStains v Mordants etc? *)
      Category->"CounterStain Washing"
    }
  ]/.{NumberOfWashes->NumberOfCounterStainWashes},
  ModifyOptions[
    WashCellOptions,
    WashType,
    {
      Description->"The method by which the cell samples with CounterStain should be washed.",
      ResolutionDescription->"Automatically set to Adherent when Wash->True, unless any Pellet-related options are set, then set to Suspension, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashType->CounterStainWashType},
  ModifyOptions[
    WashCellOptions,
    WashSolution,
    {
      Description->"The solution that is used to wash the cell samples with CounterStain.",
      ResolutionDescription->"Automatically set based on StainingMethod, and detailed in Figure XX.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolution->CounterStainWashSolution},
  ModifyOptions[
    WashCellOptions,
    WashSolutionContainer
  ]/.{WashSolutionContainer->CounterStainWashSolutionContainer},
  ModifyOptions[
    WashCellOptions,
    WashContainer,
    {
      ResolutionDescription->"Automatically set to a container with a MaxVolume less than the CounterStainWashVolume if CounterStainWashType->Suspension, unless otherwise specified in the StainingMethod for the cell line. If CounterStainWashType->Adherent, set to Null.",
      Category->"CounterStain Washing"
    }
  ]/.{WashContainer->CounterStainWashContainer},
  ModifyOptions[
    WashCellOptions,
    WashSolutionPipette,
    {
      Description->"The pipette that will be used to transfer the CounterStainWashSolution into the CounterStainWashContainer if CounterStainWashType->Suspension, or the current container of cell sample and CounterStain if CounterStainWashType->Adherent.",
      ResolutionDescription->"Automatically set to the smallest pipette capable of transferring the specified CounterStainWashVolume, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolutionPipette->CounterStainWashSolutionPipette},
  ModifyOptions[
    WashCellOptions,
    WashSolutionTips,
    {
      Description->"The tips used to transfer the CounterStainWashSolution into the CounterStainWashContainer if CounterStainWashType->Suspension, or the current container of cell sample and CounterStain if CounterStainWashType->Adherent.",
      ResolutionDescription->"Automatically set to the smallest tips with a MaxTransferVolume higher than the specified CounterStainWashVolume, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolutionTips->CounterStainWashSolutionTips},
  ModifyOptions[
    WashCellOptions,
    WashVolume,
    {
      Description->"The amount of CounterStainWashSolution that is added to the CounterStainWashContainer when the cells are washed if CounterStainWashType->Suspension, or the current container of cell sample and CounterStain if CounterStainWashType->Adherent.",
      ResolutionDescription->"Automatically set to 3/4 of the MaxVolume of the CounterStainWashContainer, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashVolume->CounterStainWashVolume},
  ModifyOptions[
    WashCellOptions,
    WashSolutionTemperature,
    {
      Description->"The temperature to heat/cool the CounterStainWashSolution to before the washing occurs.",
      ResolutionDescription -> "Automatically set to 5 Minute if CounterStainWashSolutionTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolutionTemperature->CounterStainWashSolutionTemperature},
  ModifyOptions[
    WashCellOptions,
    WashSolutionEquilibrationTime,
    {
      Description->"The duration of time for which the CounterStainWashSolution will be heated/cooled to the target temperature.",
      ResolutionDescription -> "Automatically set to 5 Minute if CounterStainWashSolutionTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolutionEquilibrationTime->CounterStainWashSolutionEquilibrationTime},
  ModifyOptions[
    WashCellOptions,
    MaxWashSolutionEquilibrationTime,
    {
      Description->"The maximum duration of time for which the samples will be heated/cooled to the target CounterStainWashSolutionEquilibrationTemperature. If they do not reach the CounterStainWashSolutionTemperature in the CounterStainWashSolutionEquilibrationTime, the sample will be checked in cycles of the CounterStainWashSolutionEquilibrationTime up to the MaxCounterStainWashSolutionEquilibrationTime. If the CounterStainWashSolutionTemperature is never reached, it is indicated in the CounterStainWashSolutionTemperatureReached field in the protocol object.",
      ResolutionDescription -> "Automatically set to 30 Minute if CounterStainWashSolutionTemperature is not set to Ambient, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{MaxWashSolutionEquilibrationTime->MaxCounterStainWashSolutionEquilibrationTime},
  ModifyOptions[
    WashCellOptions,
    WashSolutionEquilibrationCheck,
    {
      Description->"The method by which to verify the temperature of the CounterStainWashSolution before the transfer to the cell samples and CounterStain is performed.",
      ResolutionDescription -> "Automatically set to IRThermometer if a CounterStainWashSolutionTemperature is indicated, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolutionEquilibrationCheck->CounterStainWashSolutionEquilibrationCheck},

  (* stain wash solution mixing *)
  ModifyOptions[
    WashCellOptions,
    WashSolutionAspirationMix,
    {
      ResolutionDescription -> "Automatically set to True if any of the other CounterStainWashSolutionAspirationMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolutionAspirationMix->CounterStainWashSolutionAspirationMix},
  ModifyOptions[
    WashCellOptions,
    WashSolutionAspirationMixType,
    {
      ResolutionDescription -> "Automatically set to Pipette if any of the other CounterStainWashSolutionAspirationMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolutionAspirationMixType->CounterStainWashSolutionAspirationMixType},
  ModifyOptions[
    WashCellOptions,
    NumberOfWashSolutionAspirationMixes,
    {
      ResolutionDescription -> "Automatically set to 5 if any of the other CounterStainWashSolutionAspirationMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{NumberOfWashSolutionAspirationMixes->NumberOfCounterStainWashSolutionAspirationMixes},
  ModifyOptions[
    WashCellOptions,
    WashSolutionDispenseMix,
    {
      Description->"Indicates if mixing should occur after the CounterStainWashSolution is dispensed into the cell sample with CounterStain.",
      ResolutionDescription -> "Automatically set to True if any of the other CounterStainWashSolutionDispenseMix options are set, otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolutionDispenseMix->CounterStainWashSolutionDispenseMix},
  ModifyOptions[
    WashCellOptions,
    WashSolutionDispenseMixType,
    {
      Description->"The type of mixing that should occur after the CounterStainWashSolution is dispensed into the cell sample with CounterStain.",
      ResolutionDescription -> "Automatically set to Pipette if any of the other CounterStainWashSolutionDispenseMix options are set and a pipette is being used to do the transfer; otherwise, set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolutionDispenseMixType->CounterStainWashSolutionDispenseMixType},
  ModifyOptions[
    WashCellOptions,
    NumberOfWashSolutionDispenseMixes,
    {
      Description->"The number of times that the cell/CounterStainWashSolution mixture should be mixed after dispensing the CounterStainWashSolution into the cell sample with CounterStain.",
      ResolutionDescription -> "Automatically set to 5 if any of the other CounterStainWashSolutionDispenseMix options are set, unless otherwise specified in the StainingMethod for the cell line. Otherwise, set to Null.",
      Category->"CounterStain Washing"
    }
  ]/.{NumberOfWashSolutionDispenseMixes->NumberOfCounterStainWashSolutionDispenseMixes},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubation,
    {
      Description->"Indicates if the cells with CounterStain should be incubated after the CounterStainWashSolution is added.",
      ResolutionDescription->"Automatically set to True if CounterStainWash->True, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolutionIncubation->CounterStainWashSolutionIncubation},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubationInstrument,
    {
      Description->"The instrument used to perform the incubation of the cell sample with the CounterStainWashSolution.",
      ResolutionDescription -> "Automatically set based on the options CounterStainWashSolutionMix, CounterStainWashSolutionIncubationTemperature, CounterStainWashSolutionMixType, and container of the sample, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"                                                    (* TODO add incubation logic table here *)
    }
  ]/.{WashSolutionIncubationInstrument->CounterStainWashSolutionIncubationInstrument},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubationTime,
    {
      Description->"The amount of time that the cells should be incubated with the CounterStainWashSolution.",
      ResolutionDescription->"Automatically set based on the CounterStainWashSolutionMixType and the CounterStainWashContainer, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolutionIncubationTime->CounterStainWashSolutionIncubationTime},
  ModifyOptions[
    WashCellOptions,
    WashSolutionIncubationTemperature,
    {
      Description->"The temperature of the mix instrument while incubating the cells with the CounterStainWashSolution.",
      ResolutionDescription->"Automatically set based on the CounterStainWashSolutionMixType and the CounterStainWashContainer, detailed in Figure XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolutionIncubationTemperature->CounterStainWashSolutionIncubationTemperature},
  ModifyOptions[
    WashCellOptions,
    WashSolutionMix,
    {
      Description->"Indicates if the cells and CounterStainWashSolution should be mixed during CounterStainWashSolutionIncubation.",
      ResolutionDescription -> "Automatically set to True if any CounterStainWashMix options are set, unless otherwise specified in the StainingMethod for the cell line, otherwise set to False.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolutionMix->CounterStainWashSolutionMix},
  ModifyOptions[
    WashCellOptions,
    WashSolutionMixType,
    {
      Description->"Indicates the style of motion used to mix the cell sample with CounterStainWashSolution.",
      ResolutionDescription -> "Automatically set to Shake if CounterStainWashSolutionMix->True, unless otherwise specified in the StainingMethod for the cell line, otherwise set to Null.",
      Category->"CounterStain Washing"
    }
  ]/.{WashSolutionMixType->CounterStainWashSolutionMixType},
  ModifyOptions[
    WashCellOptions,
    WashSolutionMixRate,
    {
      Description->"Frequency of rotation of the mixing instrument should use to mix the cells with CounterStainWashSolution added to them.",
      ResolutionDescription -> "Automatically set to XX, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"                                       (* TODO determine what the speed is set to *)
    }
  ]/.{WashSolutionMixRate->CounterStainWashSolutionMixRate},


  (* --- CounterStain Wash Pellet Options --- *)
  {
    OptionName -> CounterStainWashPellet,
    Default -> Automatic,
    AllowNull -> True,
    Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
    Description -> "Indicates if the cells and CounterStainWashSolution should be centrifuged to create a pellet after CounterStainWashSolutionIncubation to be able to safely aspirate the CounterStainWashSolution from the cells.",
    ResolutionDescription -> "Automatically set to True if any CounterStainWashPellet options are set, unless otherwise specified in the StainingMethod for the cell line.",
    Category->"CounterStain Washing"
  },
  ModifyOptions[
    WashCellOptions,
    WashPelletInstrument,
    {
      AllowNull -> True,
      Description->"The centrifuge that will be used to spin the cell samples with CounterStainWashSolution added to them after CounterStainWashSolutionIncubation.",
      ResolutionDescription -> "Automatically set to a centrifuge that can attain the specified intensity, time, and temperature that is compatible with the CounterStainWashContainer, detailed in Figure XX, if CounterStainWashPellet->True, unless otherwise specified in the StainingMethod for the cell line; otherwise set to Null.",
      Category->"CounterStain Washing"
    }
  ]/.{WashPelletInstrument->CounterStainWashPelletInstrument},
  ModifyOptions[
    WashCellOptions,
    WashPelletIntensity,
    {
      AllowNull -> True,
      Description->"The rotational speed or the force that will be applied to the cell samples with CounterStainWashSolution by centrifugation in order to create a pellet.",
      ResolutionDescription->"Automatically set to one fifth of the maximum rotational rate of the centrifuge, rounded to the nearest attainable centrifuge precision, if CounterStainWashPellet->True, unless otherwise specified in the StainingMethod for the cell line; otherwise set to Null.",
      Category->"CounterStain Washing"
    }
  ]/.{WashPelletIntensity->CounterStainWashPelletIntensity},
  ModifyOptions[
    WashCellOptions,
    WashPelletTime,
    {
      Default -> Automatic,
      AllowNull -> True,
      Description->"The amount of time that the cell samples with CounterStainWashSolution will be centrifuged to create a pellet.",
      ResolutionDescription->"Automatically set to 5 minutes if CounterStainWashPellet->True, unless otherwise specified in the StainingMethod for the cell line, otherwise set to Null.",
      Category->"CounterStain Washing"
    }
  ]/.{WashPelletTime->CounterStainWashPelletTime},
  ModifyOptions[
    WashCellOptions,
    WashPelletTemperature,
    {
      Default -> Automatic,
      AllowNull -> True,
      Description->"The temperature at which the centrifuge chamber will be held while the cell samples with CounterStainWashSolution are being centrifuged.",
      ResolutionDescription->"Automatically set to Ambient if CounterStainWashPellet->True, otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{WashPelletTemperature->CounterStainWashPelletTemperature},
  ModifyOptions[
    ExperimentPellet,
    SupernatantVolume,
    {
      Default -> Automatic,
      AllowNull -> True,
      Description->"The amount of supernatant that will be aspirated from the cell samples with CounterStainWashSolution after centrifugation created a cell pellet.",
      ResolutionDescription->"Automatically set to All if CounterStainWashPellet->True, otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{SupernatantVolume->CounterStainWashPelletSupernatantVolume},
  ModifyOptions[
    ExperimentPellet,
    SupernatantDestination,
    {
      Default -> Automatic,
      AllowNull -> True,
      ResolutionDescription->"Automatically set to Waste if CounterStainWashPellet->True, otherwise set to Null.",
      Description->"The container that the supernatant should be dispensed into after aspiration from the pelleted cell sample, unless otherwise specified in the StainingMethod for the cell line. If the supernatant will not be used for further experimentation, the destination should be set to Waste.",
      Category->"CounterStain Washing"
    }
  ]/.{SupernatantDestination->CounterStainWashPelletSupernatantDestination},
  ModifyOptions[
    ExperimentPellet,
    SupernatantTransferInstrument,
    {
      AllowNull -> True,
      Description->"The pipette that will be used to transfer off the supernatant (CounterStainWashSolution and CounterStain) from the pelleted cell sample.",
      ResolutionDescription->"Automatically set to the smallest pipette that can aspirate the volume of the pelleted cell sample and can fit into the container of the pelleted cell sample if CounterStainWashPellet->True, otherwise set to Null, unless otherwise specified in the StainingMethod for the cell line.",
      Category->"CounterStain Washing"
    }
  ]/.{SupernatantTransferInstrument->CounterStainWashPelletSupernatantTransferInstrument}
}];





(* ::Subsection::Closed:: *)
(*CellMixOptions*)
DefineOptionSet[CellMixOptions :> {
  IndexMatching[
    IndexMatchingInput -> "experiment samples",
    {
      OptionName -> Mix,
      Default -> Automatic,
      AllowNull -> False,
      Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
      Description -> "Indicates if this sample should be mixed.",
      ResolutionDescription -> "Automatically resolves to True if any Mix related options are set. Otherwise, resolves to False.",
      Category->"Mix"
    },
    {
      OptionName -> MixType,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Enumeration, Pattern :> CellMixTypeP],
      Description -> "Indicates the style of motion used to mix the sample.",
      ResolutionDescription -> "Automatically sets based on the container of the sample and the Mix option. Specifically, if Mix is set to False, the option is set to Null. If MixInstrument is specified, the option is set based on the specified MixInstrument.  If MixRate and Time are Null, when MixVolume is Null or larger than 50ml, the option is set to Invert, otherwise set to Pipette. If Amplitude, MaxTemperature, or DutyCycle is not Null, the option is set to Homogenizer. If MixRate is set, the option is set base on any instrument that is capable of mixing the sample at the specified MixRate.",
      Category->"Mix"
    },
    {
      OptionName -> MixUntilDissolved,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Enumeration, Pattern :> (BooleanP)],
      Description -> "Indicates if the mix should be continued up to the MaxTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute.",
      ResolutionDescription -> "Automatically resolves to True if MaxTime or MaxNumberOfMixes is set.",
      Category->"Mix"
    },
    {
      OptionName -> MixInstrument,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type->Object,
        Pattern :> ObjectP[Join[CellMixInstrumentModels,CellMixInstruments]]
      ],
      Description -> "The instrument used to perform the Mix and/or Incubation.",
      ResolutionDescription -> "Automatically resolves based on the options Mix, Temperature, MixType and container of the sample.",
      Category->"Mix"
    },
    {
      OptionName -> MixTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description -> "Duration of time for which the samples will be mixed.",
      ResolutionDescription -> "Automatically resolves based on the mix Type and container of the sample.",
      Category->"Mix"
    },
    {
      OptionName -> MaxMixTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
      Description -> "Maximum duration of time for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Shake, Roll, Vortex or Sonicate.",
      ResolutionDescription -> "Automatically resolves based on the mix Type and container of the sample.",
      Category->"Mix"
    },
    {
      OptionName -> MixRate,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[$MinMixRate, $MaxMixRate], Units->RPM],
      Description -> "Frequency of rotation the mixing instrument should use to mix the samples.",
      ResolutionDescription -> "Automatically, resolves based on the sample container and instrument instrument model.",
      Category->"Mix"
    },
    {
      OptionName -> NumberOfMixes,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type->Number, Pattern :> RangeP[1, 50, 1]],
      Description -> "Number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
      ResolutionDescription -> "Automatically, resolves based on the mix Type.",
      Category -> "Mix"
    },
    {
      OptionName -> MaxNumberOfMixes,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type->Number, Pattern :> RangeP[1, 250, 1]],
      Description -> "Maximum number of times for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Pipette or Invert.",
      ResolutionDescription -> "Automatically resolves based on the mix Type and container of the sample.",
      Category -> "Mix"
    },
    {
      OptionName -> MixVolume,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Microliter, 50 Milliliter],Units :> {1,{Milliliter,{Microliter,Milliliter}}}],
      Description -> "The volume of the sample that should be pipetted up and down to mix if mix Type: Pipette, is chosen.",
      Category -> "Mix"
    },
    {
      OptionName->MixTemperature,
      Default->Automatic,
      AllowNull->True,
      Widget->Alternatives[
        Widget[Type->Quantity,Pattern:>RangeP[$MinIncubationTemperature,100 Celsius],Units:>Celsius],
        Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
      ],
      Description->"The temperature of the device that should be used to mix/incubate the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn will automatically adjust if the measured temperature of the sample exceeds this set temperature.",
      Category->"Mix"
    },
    {
      OptionName -> OscillationAngle,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 AngularDegree, 15 AngularDegree],Units :> AngularDegree],
      Description -> "The angle of oscillation of the mixing motion when a wrist action shaker is used.",
      Category -> "Mix"
    },
    {
      OptionName->ResidualIncubation,
      Default->Automatic,
      AllowNull->True,
      Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
      Description->"Indicates if the incubation and/or mixing should continue after Time/MaxTime has finished while waiting to progress to the next step in the protocol.",
      ResolutionDescription->"Automatically resolves to True if Temperature is non-Ambient and the samples being incubated have non-ambient TransportTemperature.",
      Category->"Mix"
    }
  ]
}];


(* ::Subsection:: *)
(*RecoverySharedOptions*)
(* Note; descriptions written for TransformCells. Modify as needed for other experiments *)

DefineOptionSet[RecoverySharedOptions :> {
  IndexMatching[
    IndexMatchingInput->"experiment samples",
    {
      OptionName->RecoveryMedia,
      Default->Automatic,
      AllowNull->False,
      Widget->Widget[
        Type->Object,
        Pattern:>ObjectP[{
          Model[Sample],Object[Sample],
          Model[Sample,StockSolution]
        }]
      ],
      Description->"The recovery media to add to the cell mixture after either heat shock or electroporation is performed.",
      ResolutionDescription->"If no options are provided, will be taken from the method object if set, or else will be set to Model[Sample,Media,\"SOC Medium\"] if TransformationType is HeatShock, or to the PreferredLiquidMedia of the Model[Cell] if TransformationType is Electroporation.",
      Category->"Recovery"
    },

    (* If this is Null, we add the media in the current container the cells are in. *)
    (* Otherwise, we add the media, and then transfer all to the RecoveryContainer. *)
    {
      OptionName->RecoveryContainer,
      Default->Automatic,
      AllowNull->True,
      Widget->Widget[
        Type->Object,
        Pattern:>ObjectP[{
          Object[Container],
          Model[Container]
        }]
      ],
      Description->"The recovery container to transfer the cells into after either heat shock or electroporation is performed. If this is Null, then the recovery media will be added to the current container the cells are in. If this is set, then the media will be added, and then the entire mixture subsequently transferred over to the specified RecoveryContainer.",
      ResolutionDescription->"If no options are provided, will be taken from the method object if set. Alternatively, if no method object is set and TransformationType is HeatShock, will set to Null if there is sufficient volume to add the RecoveryMediaVolume. If there is insufficient volume, will set to the smallest container that can accomodate the total cell mixture volume and RecoveryMediaVolume. If no method object is set and TransformationType is Electroporation, will resolve to the smallest container that can accomodate the total cell mixture volume and the RecoveryMediaVolume.",
      Category->"Recovery"
    },
    {
      OptionName->RecoveryMediaVolume,
      Default->Automatic,
      Widget->Widget[
        Type->Quantity,
        Pattern :> RangeP[1 Microliter, 50 Milliliter],
        Units :> {1,{Milliliter,{Microliter,Milliliter}}}
      ],
      AllowNull->False,
      Description->"The volume of the recovery media that should be added to the sample after either heat shock or electroporation is performed.",
      ResolutionDescription->"If no options are provided, will be taken from the method object if set, or else will be set to 950 microliter if TransformationType is HeatShock, or to 1 milliliter if TransformationType is Electroporation.",
      Category->"Recovery"
    },

    (* cargo source options: modify from shared *)
    ModifyOptions[
      SourceTemperatureOptions,
      SourceTemperature,
      {
        Description->"The temperature to heat/cool the recovery media to before any transfers are performed.",
        ResolutionDescription -> "If no options are provided, will be taken from the method object if set, or else will be set to Null (Ambient).",
        Category->"Cargo"
      }
    ]/.{SourceTemperature->RecoveryMediaTemperature},

    ModifyOptions[
      SourceTemperatureOptions,
      SourceEquilibrationTime,
      {
        Description->"The duration of time for which the recovery media will be heated/cooled to the target RecoveryMediaTemperature before any transfers are preformed.",
        ResolutionDescription -> "If no options are provided, will be taken from the method object if set, or else will be set to 5 Minute if RecoveryMediaTemperature is not set to Ambient or Null.",
        Category->"Cargo"
      }
    ]/.{SourceEquilibrationTime->RecoveryMediaEquilibrationTime},

    ModifyOptions[
      SourceTemperatureOptions,
      MaxSourceEquilibrationTime,
      {
        Description->"The maximum duration of time for which the recovery media will be heated/cooled to the target RecoveryMediaTemperature before any transfers are performed, if they do not reach the RecoveryMediaTemperature after RecoveryMediaEquilibrationTime. MaxRecoveryMediaEquilibrationTime will only be used if RecoveryMediaEquilibrationCheck is set, in order to extend the equilibration time past the initial RecoveryMediaEquilibrationTime if RecoveryMediaTemperature has not been reached. Performing an equilibration check will require stopping the experiment and verifying the temperature before moving on; this may add experiment time and may result in loss of sample through evaporation, and is only recommended for use in cases where temperature precision or temperature data is required.",
        ResolutionDescription -> "If no options are provided, will be taken from the method object if set, or else will be set to 30 Minute if RecoveryMediaEquilibrationCheck is set.",
        Category->"Cargo"
      }
    ]/.{MaxSourceEquilibrationTime->MaxRecoveryMediaEquilibrationTime},

    ModifyOptions[
      SourceTemperatureOptions,
      SourceEquilibrationCheck,
      {
        Description->"The method by which to verify the temperature of the recovery media before any transfers are performed. Performing an equilibration check will require stopping the experiment and verifying the temperature before moving on; this may add experiment time and may result in loss of sample through evaporation, and is only recommended for use in cases where temperature precision or temperature data is required.",
        ResolutionDescription -> "If no options are provided, will be taken from the method object if set, or else will be set to Surface if a RecoveryMediaTemperature is indicated.",
        Category->"Cargo"
      }
    ]/.{SourceEquilibrationCheck->RecoveryMediaEquilibrationCheck},

    {
      OptionName->RecoveryIncubationMix,
      Default->Automatic,
      Description->"Indicates if the recovery media and cells should be mixed prior to incubation.",
      ResolutionDescription->"If no options are provided, will be taken from the method object if set, or else will be set to True if RecoveryMedia is set.",
      AllowNull->False,
      Widget->Widget[
        Type->Enumeration,
        Pattern:>BooleanP
      ],
      Category->"Recovery"
    },
    {
      OptionName->RecoveryIncubationMixType,
      Widget->
          Widget[Type->Enumeration,Pattern:>GentleCellMixTypeP],
      AllowNull->False,
      Default->Automatic,
      Description->"The type of mixture used to mix the recovery media and cells after combining and prior to RecoveryIncubation.",
      ResolutionDescription->"If no options are provided, will be taken from the method object if set, or else will be set based on the MixTolerance of the Model[Cell].",
      Category->"Recovery"
    },
    {
      OptionName->RecoveryIncubationInstrument,
      Default->Automatic,
      Description->"The instrument used to mix and incubate the recovery media and cells after they have been added together.",
      ResolutionDescription->"If no options are provided, will be taken from the method object if set, or else will be set based on the RecoveryIncubationMixType selected.",
      AllowNull->False,
      Widget->Widget[
        Type->Object,
        Pattern:>ObjectP[{Model[Instrument,Incubator],Object[Instrument,Incubator]}]
      ],
      Category->"Recovery"
    },
    {
      OptionName->RecoveryIncubationTemperature,
      Default->Automatic,
      Widget->Alternatives[
        Widget[Type->Quantity,Pattern:>RangeP[$MinIncubationTemperature,$MaxIncubationTemperature],Units->{Celsius,{Celsius,Fahrenheit,Kelvin}}],
        Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
      ],
      AllowNull->False,
      Description->"The temperature that the recovery media and cells mixture should be incubated at in the RecoveryContainer.",
      ResolutionDescription->"If no options are provided, will be taken from the method object if set, or else will be set to the IdealGrowthTemperature in the Model[Cell].",
      Category->"Recovery"
    },
    {
      OptionName->RecoveryIncubationNumberOfMixes,
      Default->Automatic,
      Widget->Widget[
        Type->Number,
        Pattern:>RangeP[1,$MaxNumberOfMixes]
      ],
      AllowNull->False,
      Description->"The number of mixes that will be used to mix the recovery media and cells after they have been added together.",
      ResolutionDescription->"If no options are provided, will be taken from the method object if set, or else will be set to 5 if RecoveryIncubationMix is True.",
      Category->"Recovery"
    },
    {
      OptionName -> RecoveryIncubationMixRate,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[$MinMixRate, $MaxMixRate],
        Units->RPM
      ],
      Description -> "Frequency of rotation the mixing instrument should use to mix the recovery media and the cell samples.",
      ResolutionDescription -> "If no options are provided, will be taken from the method object if set, or else will be set based on the RecoveryIncubationInstrument model and the container of the sample.",
      Category->"Mix"
    },
    {
      OptionName->RecoveryIncubationTime,
      Default->Automatic,
      Widget->Widget[
        Type->Quantity,
        Pattern:>RangeP[0 Minute,$MaxExperimentTime],
        Units->{1,{Hour,{Second,Minute,Hour}}}
      ],
      AllowNull->False,
      Description->"The time that the recovery media and cells will be incubated in the RecoveryContainer after they have been added together and (optionally) mixed.",
      ResolutionDescription -> "If no options are provided, will be taken from the method object if set, or else will be set to 5 minutes if any of the recovery incubation options are set.",
      Category->"Recovery"
    }
  ]
}];


(* ::Subsection:: *)
(* CellLabelOptions *)


DefineOptionSet[CellLabelSharedOptions :> {

  IndexMatching[
    IndexMatchingInput -> "experiment samples",
    {
      OptionName->CellSampleLabel,
      Default->Automatic,
      Description->"A user defined word or phrase used to identify the cell samples that are being used in the experiment, which is used for identification elsewhere in cell preparation.",
      AllowNull->False,
      Widget->Widget[
        Type->String,
        Pattern:>_String,
        Size->Word
      ],
      Category->"General",
      UnitOperation -> True
    },
    {
      OptionName->CellSampleContainerLabel,
      Default->Automatic,
      Description->"A user defined word or phrase used to identify the cell sample's container that are being used in the experiment, which is used for identification elsewhere in cell preparation.",
      AllowNull->False,
      Widget->Widget[
        Type->String,
        Pattern:>_String,
        Size->Word
      ],
      Category->"General",
      UnitOperation -> True
    }
  ]
}];


(* ::Subsection:: *)
(* PreparationMethodSharedOption *)


DefineOptionSet[PreparationMethodSharedOption :> {
  IndexMatching[
    IndexMatchingInput -> "experiment samples",
    {
      OptionName->PreparationMethod,
      Default->Automatic,
      AllowNull->False,
      Widget->Widget[
        Type->Enumeration,
        Pattern:>CellPreparationMethodP
      ],
      Description -> "The method by which this experiment should be executed in the laboratory. Manual experiments are executed by a laboratory operator and robotic primitives are executed by a liquid handling work cell.",
      ResolutionDescription->"If no options are provided, will be taken from the Method object if available. If none are available, will set based on whether any manual or robotic options have been set in the experiment. If no options are set, will set to Robotic.",
      Category->"General"
    }
  ]
}];


(* ::Subsection::Closed:: *)
(* RoboticInstrumentOption *)


DefineOptionSet[
  RoboticInstrumentOption :> {
    {
      OptionName -> RoboticInstrument,
      Default -> Automatic,
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Instrument, LiquidHandler],Model[Instrument, LiquidHandler]}],
        OpenPaths -> {
          {Object[Catalog,"Root"],
            "Instruments",
            "Liquid Handling"}
        }
      ],
      Description -> "The robotic liquid handler used (along with integrated instrumentation for heating, mixing, and other functions) to manipulate the cell sample in order to extract and purify targeted cellular components.",
      ResolutionDescription -> "Automatically set to a robotic liquid handler compatible with the specified temperatures, mix types, and mix rates required by the extraction experiment, as well as the container and CellType of the sample. See the function MixDevices for integrated mixing instruments compatible with a given sample. See the function IncubationDevices for integrated heating instruments compatible with a given sample.",
      Category->"General"
    }
  }];

(* ::Subsection::Closed:: *)
(* CellTypeOption *)
DefineOptionSet[
  CellTypeOption :> {
    {
      OptionName -> CellType,
      Default -> Automatic,
      Description->"The taxon of the organism or cell line from which the cell sample originates. Options include Bacterial, Mammalian, and Yeast.",
      ResolutionDescription -> "Automatically set to the CellType field of the input sample. If the CellType field of the input sample is Unspecified, automatically set to the majority cell type of the input sample based on its composition.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[Mammalian, Bacterial, Yeast]
      ],
      Category -> "General"
    }
  }
];

(* ::Subsection::Closed:: *)
(* CultureAdhesionOption *)
DefineOptionSet[
  CultureAdhesionOption :> {
    {
      OptionName -> CultureAdhesion,
      Default -> Automatic,
      Description -> "Indicates how the input cell sample physically interacts with its container. Options include Adherent and Suspension (including any microbial liquid media).",
      ResolutionDescription -> "Automatically set to the CultureAdhesion field of the input samples.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> CultureAdhesionP
      ],
      Category -> "General"
    }
  }
];

(* ::Subsection::Closed:: *)
(* TargetCellularComponentOption *)
DefineOptionSet[
  TargetCellularComponentOption :> {
    {
      OptionName -> TargetCellularComponent,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[CellularComponentP, Unspecified]],
      Description -> "The class of biomolecule whose purification is desired following lysis of the cell sample and any subsequent extraction operations. Options include CytosolicProtein, PlasmaMembraneProtein, NuclearProtein, SecretoryProtein, TotalProtein, RNA, GenomicDNA, PlasmidDNA, Organelle, Virus and Unspecified.",
      Category -> "General"
    }
  }
];

DefineOptionSet[
  CellExtractionSharedOptions:>{
    RoboticInstrumentOption,
    {
      OptionName->Method,
      Default->Custom,
      AllowNull->False,
      Widget->Alternatives[
        Widget[Type->Enumeration,Pattern:>Alternatives[Custom]],
        Widget[
          Type->Object,
          Pattern:>ObjectP[Object[Method]],
          OpenPaths->{
            {Object[Catalog,"Root"],
              "Materials",
              "Reagents"(*,
              "Cell Culture",
              "Extraction Methods"*)
            } (* TODO::Add "Extraction Methods" to Catalog. *)
          }
        ]
      ],
      Description->"The set of reagents and recommended operating conditions which are used to lyse the cell sample and to perform subsequent extraction unit operations. Custom indicates that all reagents and conditions are individually selected by the user. Oftentimes, these can come from kit manufacturer recommendations.",
      Category -> "General"
    },
    {
      OptionName->ContainerOut,
      Default->Automatic,
      AllowNull->False,
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
      Description->"The container into which the output sample resulting from the protocol is transferred.",
      ResolutionDescription->"Automatically set to the container in which the final unit operation of the extraction protocol is performed.",
      Category->"General"
    },
    {
      OptionName -> ContainerOutWell,
      Default->Automatic,
      AllowNull -> False,
      Widget->Widget[
        Type -> Enumeration,
        Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
        PatternTooltip -> "Enumeration must be any well from A1 to P24."
      ],
      Description->"The well of the container into which the output sample resulting from the protocol is transferred.",
      ResolutionDescription->"Automatically set to the first empty well in the ContainerOut.",
      Category -> "General"
      (* TODO:: change to Hidden *)
      (*Category -> "Hidden"*)
    },
    {
      OptionName -> IndexedContainerOut,
      Default->Automatic,
      AllowNull -> False,
      Widget->Alternatives[
        "Container with Index" -> {
          "Index"->Widget[
            Type->Number,
            Pattern:>GreaterEqualP[1,1]
          ],
          "Container"->Widget[
            Type->Object,
            Pattern:>ObjectP[{Model[Container],Object[Container]}],
            PreparedSample->False,
            PreparedContainer->False
          ]
        }
      ],
      Description->"The index and container of the sample determined from the ContainerOut option.",
      ResolutionDescription->"Automatically set to the indicated index & container from the ContainerOut option. If only a model is specified in ContainerOut, then a new index is assigned to it. If an object is specified in ContainerOut, then it gets an index of one (since there is only one object that can be acted upon).",
      Category -> "General"
      (* TODO:: change to Hidden *)
      (*Category -> "Hidden"*)
    }
  }
];

(* ::Subsection:: *)
(* BiologySharedMessages *)

Error::InvalidSolidMediaSample = "The following object(s) are in solid media and therefore cannot be used in this experiment: `1`.  Please check the CultureAdhesion field of the samples in question, or provide alternative samples that are not in solid media.";
Warning::UnlysedCellsInput = "The sample(s), `1`, at indices `2` have the Living field set to True, but Lyse is not set to True. It is recommended that Living cells are lysed prior to extracting cellular components.";
Error::LysisConflictingOptions = "For the following input samples: `1`, at the following indices:`2`, the following lysis options are set even though Lyse is set to False: `3`. Either all lysis options must be set to Null or Lyse must be set to True.";
Error::PrecipitationConflictingOptions = "For the input samples `1` at indices `2`, the following precipitation options are set even though Purification does not include Precipitation: `3`. Either all precipitation options must be set to Null or Purification must contain Precipitation.";
Error::MagneticBeadSeparationConflictingOptions = "For the input samples `1` at indices `2`, the following magnetic bead separation options are set even though Purification does not include MagneticBeadSeparation: `3`. Either all magnetic bead separation options must be set to Null or Purification must contain MagneticBeadSeparation.";
Error::SolidPhaseExtractionConflictingOptions = "For the input samples `1` at indices `2`, the following solid phase extraction options are set even though Purification does not include SolidPhaseExtraction: `3`. Either all solid phase extraction options must be set to Null or Purification must contain SolidPhaseExtraction.";
Error::LiquidLiquidExtractionConflictingOptions = "For the input samples `1` at indices `2`, the following liquid-liquid extraction options are set even though Purification does not include LiquidLiquidExtraction: `3`. Either all magnetic bead separation options must be set to Null or Purification must contain LiquidLiquidExtraction.";

(* -- SOLID MEDIA CHECK -- *)
(* NOTE: to test if the Samples are in solid media (and therefore cannot be transferred properly).*)

DefineOptions[
  checkSolidMedia,
  Options:>{CacheOption}
];

checkSolidMedia[mySamplePackets:{PacketP[Object[Sample]]..},messagesQ:BooleanP,myOptions:OptionsPattern[checkSolidMedia]]:=Module[{solidMediaSamplePackets,solidMediaInvalidInputs,solidMediaTest,safeOptions,cache},

  safeOptions = SafeOptions[checkSolidMedia,ToList[myOptions]];

  cache = Lookup[safeOptions,Cache];

  (* Get the samples from samplePackets that are in solid media. *)
  solidMediaSamplePackets = Select[Flatten[mySamplePackets], MatchQ[Lookup[#, CultureAdhesion], SolidMedia]&];

  (* Set solidMediaInvalidInputs to the input objects whose CultureAdhesion are SolidMedia *)
  solidMediaInvalidInputs = Lookup[solidMediaSamplePackets, Object, {}];

  (* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
  If[Length[solidMediaInvalidInputs] > 0 && messagesQ,
    Message[Error::InvalidSolidMediaSample, ObjectToString[solidMediaInvalidInputs, Cache -> cache]];
  ];

  (* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
  solidMediaTest = If[!messagesQ,
    Module[{failingTest, passingTest},
      failingTest = If[Length[solidMediaInvalidInputs] == 0,
        Nothing,
        Test["The input samples "<>ObjectToString[solidMediaInvalidInputs, Cache -> cache]<>" are not in solid media:", True, False]
      ];
      passingTest = If[Length[solidMediaInvalidInputs] == Length[mySamplePackets],
        Nothing,
        Test["The input samples "<>ObjectToString[Complement[mySamplePackets, solidMediaInvalidInputs], Cache -> cache]<>" are not in solid media:", True, True]
      ];
      {failingTest, passingTest}
    ],
    Null
  ];

  {solidMediaInvalidInputs,solidMediaTest}
];