(* ::Package:: *)

(* ::Text:: *)
(* \[Copyright] 2011-2023 Emerald Cloud Lab, Inc. *)

(* ::Subsection:: *)
(* CellExtractionSharedOptions *)

DefineOptionSet[
  CellExtractionSharedOptions :> {
    RoboticInstrumentOption,
    {
      OptionName -> Method,
      Default -> Custom,
      AllowNull -> False,
      Widget -> Alternatives[
        Widget[Type -> Enumeration, Pattern :> Alternatives[Custom]],
        Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Method, Extraction], Object[Method, LyseCells]}],
          OpenPaths -> {
            {Object[Catalog, "Root"],
              "Materials",
              "Reagents"(*,
              "Cell Culture",
              "Extraction Methods"*)
            } (* TODO::Add "Extraction Methods" to Catalog. *)
          }
        ]
      ],
      Description -> "The set of reagents and recommended operating conditions which are used to lyse the cell sample and to perform subsequent extraction unit operations. Custom indicates that all reagents and conditions are individually selected by the user. Oftentimes, these can come from kit manufacturer recommendations.",
      Category -> "General"
    },
    {
      OptionName -> ContainerOut,
      Default -> Automatic,
      AllowNull -> False,
      Widget -> Alternatives[
        "Container" -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Container], Model[Container]}]
        ],
        "Container with Index" -> {
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
          "Index and Container" -> {
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
        }
      ],
      Description -> "The container into which the output sample resulting from the protocol is transferred.",
      ResolutionDescription -> "Automatically set to the container in which the final unit operation of the extraction protocol is performed.",
      Category -> "General"
    },
    {
      OptionName -> ContainerOutWell,
      Default -> Automatic,
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
        PatternTooltip -> "Enumeration must be any well from A1 to P24."
      ],
      Description -> "The well of the container into which the output sample resulting from the protocol is transferred.",
      ResolutionDescription -> "Automatically set to the first empty well in the ContainerOut.",
      Category -> "General",
      Category -> "Hidden"
    },
    {
      OptionName -> IndexedContainerOut,
      Default -> Automatic,
      AllowNull -> False,
      Widget -> Alternatives[
        "Container with Index" -> {
          "Index" -> Widget[
            Type -> Number,
            Pattern :> GreaterEqualP[1,1]
          ],
          "Container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Model[Container], Object[Container]}],
            PreparedSample -> False,
            PreparedContainer -> False
          ]
        }
      ],
      Description -> "The index and container of the sample determined from the ContainerOut option.",
      ResolutionDescription -> "Automatically set to the indicated index & container from the ContainerOut option. If only a model is specified in ContainerOut, then a new index is assigned to it. If an object is specified in ContainerOut, then it gets an index of one (since there is only one object that can be acted upon).",
      Category -> "General",
      Category -> "Hidden"
    }
  }
];

(* ::Subsection:: *)
(* Purification shared options precisions *)

(* - SHARED OPTIONS PRECISIONS - *)
$CellLysisOptionsPrecisions = {
  {TargetCellCount, 1 EmeraldCell},
  {TargetCellConcentration, 10^-1 EmeraldCell / Milliliter},
  {LysisAliquotAmount, 10^-1 Microliter},
  {PreLysisPelletingIntensity, 1 GravitationalAcceleration},
  {PreLysisPelletingTime, 1 Second},
  {PreLysisSupernatantVolume, 10^-1 Microliter},
  {PreLysisDilutionVolume, 10^-1 Microliter},
  {LysisSolutionVolume, 10^-1 Microliter},
  {LysisMixRate, 1 RPM}, {LysisMixTime, 1 Second},
  {LysisMixVolume, 10^-1 Microliter},
  {LysisMixTemperature, 10^-1 Celsius},
  {LysisTime, 1 Second},
  {LysisTemperature, 10^-1 Celsius},
  {SecondaryLysisSolutionVolume, 10^-1 Microliter},
  {SecondaryLysisMixRate, 1 RPM},
  {SecondaryLysisMixTime, 1 Second},
  {SecondaryLysisMixVolume, 10^-1 Microliter},
  {SecondaryLysisMixTemperature, 10^-1 Celsius},
  {SecondaryLysisTime, 1 Second},
  {SecondaryLysisTemperature, 10^-1 Celsius},
  {TertiaryLysisSolutionVolume, 10^-1 Microliter},
  {TertiaryLysisMixRate, 1 RPM},
  {TertiaryLysisMixTime, 1 Second},
  {TertiaryLysisMixVolume, 10^-1 Microliter},
  {TertiaryLysisMixTemperature, 10^-1 Celsius},
  {TertiaryLysisTime, 1 Second},
  {TertiaryLysisTemperature, 10^-1 Celsius},
  {ClarifyLysateIntensity, 1 GravitationalAcceleration},
  {ClarifyLysateTime, 1 Second},
  {ClarifiedLysateVolume, 10^-1 Microliter}
};

$ExtractionLiquidLiquidSharedOptionsPrecisions = {
  {AqueousSolventVolume, 10^-1 Microliter},
  {AqueousSolventRatio, 10^-2},
  {OrganicSolventVolume, 10^-1 Microliter},
  {OrganicSolventRatio, 10^-2},
  {DemulsifierAmount, 10^-1 Microliter},
  {LiquidLiquidExtractionTemperature, 10^-1 Celsius},
  {LiquidLiquidExtractionMixTime, 1 Second},
  {LiquidLiquidExtractionMixRate, 1 RPM},
  {LiquidLiquidExtractionMixVolume, 10^-1 Microliter},
  {LiquidLiquidExtractionSettlingTime, 1 Second},
  {LiquidLiquidExtractionCentrifugeIntensity, 1 GravitationalAcceleration},
  {LiquidLiquidExtractionCentrifugeTime, 1 Second},
  {LiquidBoundaryVolume, 10^-1 Microliter}
};

$PrecipitationSharedOptionsPrecisions = {
  {PrecipitationReagentVolume, 10^-1 Microliter},
  {PrecipitationReagentTemperature, 10^-1 Celsius},
  {PrecipitationReagentEquilibrationTime, 1 Second},
  {PrecipitationMixRate, 1 RPM},
  {PrecipitationMixTemperature, 10^-1 Celsius},
  {PrecipitationMixTime, 1 Second},
  {PrecipitationMixVolume, 10^-1 Microliter},
  {PrecipitationTime, 1 Second},
  {PrecipitationTemperature, 10^-1 Celsius},
  {PrecipitationPrefilterPoreSize, 10^-2 Micron},
  {PrecipitationPoreSize, 10^-2 Micron},
  {PrecipitationFilterCentrifugeIntensity, 1 GravitationalAcceleration},
  {PrecipitationFiltrationPressure, 1 PSI},
  {PrecipitationFiltrationTime, 1 Second},
  {PrecipitationFiltrateVolume, 10^-1 Microliter},
  {PrecipitationPelletCentrifugeIntensity, 1 GravitationalAcceleration},
  {PrecipitationPelletCentrifugeTime, 1 Second},
  {PrecipitationSupernatantVolume, 10^-1 Microliter},
  {PrecipitationWashSolutionVolume, 10^-1 Microliter},
  {PrecipitationWashSolutionTemperature, 10^-1 Celsius},
  {PrecipitationWashSolutionEquilibrationTime, 1 Second},
  {PrecipitationWashMixRate, 1 RPM},
  {PrecipitationWashMixTemperature, 10^-1 Celsius},
  {PrecipitationWashMixTime, 1 Second},
  {PrecipitationWashMixVolume, 10^-1 Microliter},
  {PrecipitationWashPrecipitationTime, 1 Second},
  {PrecipitationWashPrecipitationTemperature, 10^-1 Celsius},
  {PrecipitationWashCentrifugeIntensity, 1 GravitationalAcceleration},
  {PrecipitationWashPressure, 1 PSI},
  {PrecipitationWashSeparationTime, 1 Second},
  {PrecipitationDryingTemperature, 10^-1 Celsius},
  {PrecipitationDryingTime, 1 Second},
  {PrecipitationResuspensionBufferVolume, 10^-1 Microliter},
  {PrecipitationResuspensionBufferTemperature, 10^-1 Celsius},
  {PrecipitationResuspensionBufferEquilibrationTime, 1 Second},
  {PrecipitationResuspensionMixRate, 1 RPM},
  {PrecipitationResuspensionMixTemperature, 10^-1 Celsius},
  {PrecipitationResuspensionMixTime, 1 Second},
  {PrecipitationResuspensionMixVolume, 10^-1 Microliter}
};

$ExtractionSolidPhaseSharedOptionsPrecisions = {
  {SolidPhaseExtractionLoadingSampleVolume, 10^-1 Microliter},
  {SolidPhaseExtractionLoadingTemperature, 10^-1 Celsius},
  {SolidPhaseExtractionLoadingTemperatureEquilibrationTime, 1 Second},
  {SolidPhaseExtractionLoadingCentrifugeIntensity, 1 GravitationalAcceleration},
  {SolidPhaseExtractionLoadingPressure, 1 PSI},
  {SolidPhaseExtractionLoadingTime, 1 Second},
  {SolidPhaseExtractionWashSolutionVolume, 10^-1 Microliter},
  {SolidPhaseExtractionWashTemperature, 10^-1 Celsius},
  {SolidPhaseExtractionWashTemperatureEquilibrationTime, 1 Second},
  {SolidPhaseExtractionWashCentrifugeIntensity, 1 GravitationalAcceleration},
  {SolidPhaseExtractionWashPressure, 1 PSI},
  {SolidPhaseExtractionWashTime, 10^-1 Celsius},
  {SecondarySolidPhaseExtractionWashSolutionVolume, 10^-1 Microliter},
  {SecondarySolidPhaseExtractionWashTemperature, 10^-1 Celsius},
  {SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime, 1 Second},
  {SecondarySolidPhaseExtractionWashCentrifugeIntensity, 1 GravitationalAcceleration},
  {SecondarySolidPhaseExtractionWashPressure, 1 PSI},
  {SecondarySolidPhaseExtractionWashTime, 1 Second},
  {TertiarySolidPhaseExtractionWashSolutionVolume, 10^-1 Microliter},
  {TertiarySolidPhaseExtractionWashTemperature, 10^-1 Celsius},
  {TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime, 1 Second},
  {TertiarySolidPhaseExtractionWashCentrifugeIntensity, 1 GravitationalAcceleration},
  {TertiarySolidPhaseExtractionWashPressure, 1 PSI},
  {TertiarySolidPhaseExtractionWashTime, 1 Second},
  {SolidPhaseExtractionElutionSolutionVolume, 10^-1 Microliter},
  {SolidPhaseExtractionElutionSolutionTemperature, 10^-1 Celsius},
  {SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime, 1 Second},
  {SolidPhaseExtractionElutionCentrifugeIntensity, 1 GravitationalAcceleration},
  {SolidPhaseExtractionElutionPressure, 1 PSI},
  {SolidPhaseExtractionElutionTime, 1 Second}
};

$ExtractionMagneticBeadSharedOptionsPrecisions = {
  {MagneticBeadSeparationSampleVolume, 10^-1 Microliter},
  {MagneticBeadVolume, 10^-1 Microliter},
  {MagneticBeadSeparationPreWashSolutionVolume, 10^-1 Microliter},
  {MagneticBeadSeparationPreWashMixTime, 1 Second},
  {MagneticBeadSeparationPreWashMixRate, 1 RPM},
  {MagneticBeadSeparationPreWashMixVolume, 10^-1 Microliter},
  {MagneticBeadSeparationPreWashMixTemperature, 10^-1 Celsius},
  {PreWashMagnetizationTime, 1 Second},
  {MagneticBeadSeparationPreWashAspirationVolume, 10^-1 Microliter},
  {MagneticBeadSeparationPreWashAirDryTime, 1 Second},
  {MagneticBeadSeparationEquilibrationSolutionVolume, 10^-1 Microliter},
  {MagneticBeadSeparationEquilibrationMixTime, 1 Second},
  {MagneticBeadSeparationEquilibrationMixRate, 1 RPM},
  {MagneticBeadSeparationEquilibrationMixVolume, 10^-1 Microliter},
  {MagneticBeadSeparationEquilibrationMixTemperature, 10^-1 Celsius},
  {EquilibrationMagnetizationTime, 1 Second},
  {MagneticBeadSeparationEquilibrationAspirationVolume, 10^-1 Microliter},
  {MagneticBeadSeparationEquilibrationAirDryTime, 1 Second},
  {MagneticBeadSeparationLoadingMixTime, 1 Second},
  {MagneticBeadSeparationLoadingMixRate, 1 RPM},
  {MagneticBeadSeparationLoadingMixVolume, 10^-1 Microliter},
  {MagneticBeadSeparationLoadingMixTemperature, 10^-1 Celsius},
  {LoadingMagnetizationTime, 1 Second},
  {MagneticBeadSeparationLoadingAspirationVolume, 10^-1 Microliter},
  {MagneticBeadSeparationLoadingAirDryTime, 1 Second},
  {MagneticBeadSeparationWashSolutionVolume, 10^-1 Microliter},
  {MagneticBeadSeparationWashMixTime, 1 Second},
  {MagneticBeadSeparationWashMixRate, 1 RPM},
  {MagneticBeadSeparationWashMixVolume, 10^-1 Microliter},
  {MagneticBeadSeparationWashMixTemperature, 10^-1 Celsius},
  {WashMagnetizationTime, 1 Second},
  {MagneticBeadSeparationWashAspirationVolume, 10^-1 Microliter},
  {MagneticBeadSeparationWashAirDryTime, 1 Second},
  {MagneticBeadSeparationSecondaryWashSolutionVolume, 10^-1 Microliter},
  {MagneticBeadSeparationSecondaryWashMixTime, 1 Second},
  {MagneticBeadSeparationSecondaryWashMixRate, 1 RPM},
  {MagneticBeadSeparationSecondaryWashMixVolume, 10^-1 Microliter},
  {MagneticBeadSeparationSecondaryWashMixTemperature, 10^-1 Celsius},
  {SecondaryWashMagnetizationTime, 1 Second},
  {MagneticBeadSeparationSecondaryWashAspirationVolume, 10^-1 Microliter},
  {MagneticBeadSeparationSecondaryWashAirDryTime, 1 Second},
  {MagneticBeadSeparationTertiaryWashSolutionVolume, 10^-1 Microliter},
  {MagneticBeadSeparationTertiaryWashMixTime, 1 Second},
  {MagneticBeadSeparationTertiaryWashMixRate, 1 RPM},
  {MagneticBeadSeparationTertiaryWashMixVolume, 10^-1 Microliter},
  {MagneticBeadSeparationTertiaryWashMixTemperature, 10^-1 Celsius},
  {TertiaryWashMagnetizationTime, 1 Second},
  {MagneticBeadSeparationTertiaryWashAspirationVolume, 10^-1 Microliter},
  {MagneticBeadSeparationTertiaryWashAirDryTime, 1 Second},
  {MagneticBeadSeparationQuaternaryWashSolutionVolume, 10^-1 Microliter},
  {MagneticBeadSeparationQuaternaryWashMixTime, 1 Second},
  {MagneticBeadSeparationQuaternaryWashMixRate, 1 RPM},
  {MagneticBeadSeparationQuaternaryWashMixVolume, 10^-1 Microliter},
  {MagneticBeadSeparationQuaternaryWashMixTemperature, 10^-1 Celsius},
  {QuaternaryWashMagnetizationTime, 1 Second},
  {MagneticBeadSeparationQuaternaryWashAspirationVolume, 10^-1 Microliter},
  {MagneticBeadSeparationQuaternaryWashAirDryTime, 1 Second},
  {MagneticBeadSeparationQuinaryWashSolutionVolume, 10^-1 Microliter},
  {MagneticBeadSeparationQuinaryWashMixTime, 1 Second},
  {MagneticBeadSeparationQuinaryWashMixRate, 1 RPM},
  {MagneticBeadSeparationQuinaryWashMixVolume, 10^-1 Microliter},
  {MagneticBeadSeparationQuinaryWashMixTemperature, 10^-1 Celsius},
  {QuinaryWashMagnetizationTime, 1 Second},
  {MagneticBeadSeparationQuinaryWashAspirationVolume, 10^-1 Microliter},
  {MagneticBeadSeparationQuinaryWashAirDryTime, 1 Second},
  {MagneticBeadSeparationElutionSolutionVolume, 10^-1 Microliter},
  {MagneticBeadSeparationElutionMixTime, 1 Second},
  {MagneticBeadSeparationElutionMixRate, 1 RPM},
  {MagneticBeadSeparationElutionMixVolume, 10^-1 Microliter},
  {MagneticBeadSeparationElutionMixTemperature, 10^-1 Celsius},
  {ElutionMagnetizationTime, 1 Second},
  {MagneticBeadSeparationElutionAspirationVolume, 10^-1 Microliter}
};

(* ::Subsection:: *)
(* preResolveExtractMixOptions Options *)

(* - SHARED HELPER FUNCTIONS - *)

(* -- PRERESOLVE MIX OPTIONS -- *)

(*NOTE: All defaults set to automatic to avoid option conflicts if everything defaults.*)
DefineOptions[
  preResolveExtractMixOptions,
  Options:>
      {
        {
          OptionName -> DefaultMixType,
          Default -> Automatic,
          Pattern -> Shake|Pipette|None|Automatic,
          AllowNull -> False,
          Description -> "The default mix type that will be set if no other extraction mix options are set and if there is not a user-set value nor a method-set value."
        },
        {
          OptionName -> DefaultMixRate,
          Default -> Automatic,
          Pattern -> RangeP[$MinRoboticMixRate, $MaxRoboticMixRate]|Automatic,
          AllowNull -> False,
          Description -> "The default mix rate that will be set if there is not a user-set value nor a method-set value and a value is required."
        },
        {
          OptionName -> DefaultMixTime,
          Default -> Automatic,
          Pattern -> RangeP[0*Second, $MaxExperimentTime]|Automatic,
          AllowNull -> False,
          Description -> "The default mix time that will be set if there is not a user-set value nor a method-set value and a value is required."
        },
        {
          OptionName -> DefaultNumberOfMixes,
          Default -> Automatic,
          Pattern -> RangeP[1, $MaxNumberOfMixes, 1]|Automatic,
          AllowNull -> False,
          Description -> "The default number of mixes that will be set if there is not a user-set value nor a method-set value and a value is required."
        },
        {
          OptionName -> DefaultMixVolume,
          Default -> Automatic,
          Pattern -> RangeP[0 Milliliter, $MaxRoboticSingleTransferVolume]|Automatic,
          AllowNull -> False,
          Description -> "The default mix volume that will be set if there is not a user-set value nor a method-set value and a value is required."
        },
        {
          OptionName -> DefaultMixTemperature,
          Default -> Automatic,
          Pattern -> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature]|Ambient|Automatic,
          AllowNull -> False,
          Description -> "The default mix temperature that will be set if there is not a user-set value nor a method-set value."
        }
      }
];

(* ::Subsection:: *)
(* preResolveExtractMixOptions function *)

preResolveExtractMixOptions[optionsList_Association,methodPacket:PacketP[Object[Method]]|Null,mixStepUsedQ:BooleanP,mixOptionNameMap:{_Rule..},myOptions:OptionsPattern[preResolveExtractMixOptions]]:=Module[
  {safeOps, defaultMixType, defaultMixRate, defaultMixTime, defaultNumberOfMixes, defaultMixVolume, defaultMixTemperature, mixTypeOptionName, mixRateOptionName, mixTimeOptionName, numberOfMixesOptionName, mixVolumeOptionName, mixTemperatureOptionName, mixInstrumentOptionName, methodSpecifiedQ, resolvedMixType, resolvedMixRate, resolvedMixTime, resolvedNumberOfMixes, resolvedMixVolume, resolvedMixTemperature, resolvedMixInstrument},

  (*Get the safe options.*)
  safeOps = SafeOptions[preResolveExtractMixOptions,ToList[myOptions], AutoCorrect->False];

  (*Pull out relevant default options.*)
  {defaultMixType, defaultMixRate, defaultMixTime, defaultNumberOfMixes, defaultMixVolume, defaultMixTemperature} = Lookup[safeOps,{DefaultMixType, DefaultMixRate, DefaultMixTime, DefaultNumberOfMixes, DefaultMixVolume, DefaultMixTemperature}];

  (*Find the names of each mix option from the mixOptionNameMap.*)
  {mixTypeOptionName, mixRateOptionName, mixTimeOptionName, numberOfMixesOptionName, mixVolumeOptionName, mixTemperatureOptionName, mixInstrumentOptionName} = Map[
    If[
      KeyExistsQ[mixOptionNameMap, #],
      Lookup[mixOptionNameMap, #],
      Null
    ]&,
    {MixType, MixRate, MixTime, NumberOfMixes, MixVolume, MixTemperature, MixInstrument}
  ];

  (* Setup a boolean to determine if there is a method set or not. *)
  methodSpecifiedQ = MatchQ[methodPacket, ObjectP[Object[Method]]];
  
  (* Resolve the MixType *)
  resolvedMixType = Which[
    (*If there is not an input MixType name, then no need to resolve and will be set to Null.*)
    MatchQ[mixTypeOptionName,Null],
      Null,
    (*If user-set, then use set value.*)
    MatchQ[Lookup[optionsList, mixTypeOptionName], Except[Automatic]],
      Lookup[optionsList, mixTypeOptionName],
    (*Set to value specified in the Method object if selected.*)
    methodSpecifiedQ && MatchQ[Lookup[methodPacket, mixTypeOptionName], Except[Null]],
     Lookup[methodPacket, mixTypeOptionName],
    (*If the overarching step for the mix options is not used, then the mix options are not needed.*)
    !mixStepUsedQ,
     Null,
    (*If shaking options are set, then the type will be set to Shake.*)
    Or[
      MatchQ[Lookup[optionsList, mixRateOptionName],Except[Automatic|Null]],
      MatchQ[Lookup[optionsList, mixTimeOptionName],Except[Automatic|Null]]
    ],
     Shake,
    (*If pipetting options are set, then the type will be set to Pipette.*)
    Or[
      MatchQ[Lookup[optionsList, mixVolumeOptionName],Except[Automatic|Null]],
      MatchQ[Lookup[optionsList, numberOfMixesOptionName],Except[Automatic|Null]]
    ],
     Pipette,
    (*Otherwise, set to the specified default value.*)
    True,
     defaultMixType
  ];

  (* Resolve the MixRate *)
  resolvedMixRate = Which[
    (*If there is not an input MixRate name, then no need to resolve and will be set to Null.*)
    MatchQ[mixRateOptionName,Null],
      Null,
    (*If user-set, then use set value.*)
    MatchQ[Lookup[optionsList, mixRateOptionName], Except[Automatic]],
     Lookup[optionsList, mixRateOptionName],
    (*Set to value specified in the Method object if selected.*)
    methodSpecifiedQ && MatchQ[Lookup[methodPacket, mixRateOptionName], Except[Null]],
     Lookup[methodPacket, mixRateOptionName],
    (*If the overarching step for the mix options is not used, then the mix options are not needed.*)
    (*Also not needed if the mixing type is pipette (since mix rate is Shake-specific) or none.*)
    Or[
      !mixStepUsedQ,
      MatchQ[resolvedMixType,Pipette|None]
    ],
     Null,
    (*Otherwise, set to the specified default.*)
    True,
      defaultMixRate
  ];

  (* Resolve the MixTime *)
  resolvedMixTime = Which[
    (*If there is not an input MixTime name, then no need to resolve and will be set to Null.*)
    MatchQ[mixTimeOptionName,Null],
      Null,
    (*If user-set, then use set value.*)
    MatchQ[Lookup[optionsList, mixTimeOptionName], Except[Automatic]],
     Lookup[optionsList, mixTimeOptionName],
    (*Set to value specified in the Method object if selected.*)
    methodSpecifiedQ && MatchQ[Lookup[methodPacket, mixTimeOptionName], Except[Null]],
     Lookup[methodPacket, mixTimeOptionName],
    (*If the overarching step for the mix options is not used, then the mix options are not needed.*)
    (*Also not needed if the mixing type is pipette (since mix time is Shake-specific) or none.*)
    Or[
      !mixStepUsedQ,
      MatchQ[resolvedMixType,Pipette|None]
    ],
     Null,
    (*Otherwise, set to the specified default.*)
    True,
      defaultMixTime
  ];

  (* Resolve the NumberOfMixes *)
  resolvedNumberOfMixes = Which[
    (*If there is not an input NumberOfMixes name, then no need to resolve and will be set to Null.*)
    MatchQ[numberOfMixesOptionName,Null],
      Null,
    (*If user-set, then use set value.*)
    MatchQ[Lookup[optionsList, numberOfMixesOptionName], Except[Automatic]],
      Lookup[optionsList, numberOfMixesOptionName],
    (*Set to value specified in the Method object if selected.*)
    methodSpecifiedQ && MatchQ[Lookup[methodPacket, numberOfMixesOptionName], Except[Null]],
      Lookup[methodPacket, numberOfMixesOptionName],
    (*If the overarching step for the mix options is not used, then the mix options are not needed.*)
    (*Also not needed if the mixing type is Shake (since number of mixes is Pipette-specific) or none.*)
    Or[
      !mixStepUsedQ,
      MatchQ[resolvedMixType,Shake|None]
    ],
      Null,
    (*Otherwise, set to the specified default.*)
    True,
      defaultNumberOfMixes
  ];

  (* Resolve the MixVolume *)
  resolvedMixVolume = Which[
    (*If there is not an input MixVolume name, then no need to resolve and will be set to Null.*)
    MatchQ[mixVolumeOptionName,Null],
      Null,
    (*If user-set, then use set value.*)
    MatchQ[Lookup[optionsList, mixVolumeOptionName], Except[Automatic]],
     Lookup[optionsList, mixVolumeOptionName],
    (*If the overarching step for the mix options is not used, then the mix options are not needed.*)
    (*Also not needed if the mixing type is Shake (since mix volume is Pipette-specific) or none.*)
    Or[
      !mixStepUsedQ,
      MatchQ[resolvedMixType,Shake|None]
    ],
      Null,
    (*Otherwise, set to the specified default.*)
    True,
      defaultMixVolume
  ];

  (* Resolve MixTemperature *)
  resolvedMixTemperature = Which[
    (*If there is not an input MixTemperature name, then no need to resolve and will be set to Null.*)
    MatchQ[mixTemperatureOptionName,Null],
      Null,
    (* Use the user-specified values, if any *)
    MatchQ[Lookup[optionsList,mixTemperatureOptionName], Except[Automatic]],
     Lookup[optionsList,mixTemperatureOptionName],
    (* Use the Method-specified values, if any *)
    methodSpecifiedQ && MatchQ[Lookup[methodPacket, mixTemperatureOptionName], Except[Null]],
      Lookup[methodPacket,mixTemperatureOptionName],
    (*If the overarching step for the mix options is not used, then the mix options are not needed.*)
    (*Also not needed if the mixing type is none.*)
    Or[
      !mixStepUsedQ,
      MatchQ[resolvedMixType,None]
    ],
      Null,
    (*Otherwise, set to the specified default.*)
    True,
      defaultMixTemperature
  ];

  (* Resolve MixInstrument *)
  resolvedMixInstrument = Which[
    (*If there is not an input MixInstrument name, then no need to resolve and will be set to Null.*)
    MatchQ[mixInstrumentOptionName,Null],
      Null,
    (*If user-set, then use set value.*)
    MatchQ[Lookup[optionsList,mixInstrumentOptionName], Except[Automatic]],
      Lookup[optionsList,mixInstrumentOptionName],
    (*If the overarching step for the mix options is not used, then the mix options are not needed.*)
    (*Also not needed if the mixing type is Pipette or None.*)
    Or[
      !mixStepUsedQ,
      MatchQ[resolvedMixType, Pipette|None]
    ],
      Null,
    (* Set to the Inheco ThermoshakeAC if the MixRate falls outside the other shaker's RPM range *)
    !MatchQ[resolvedMixRate, RangeP[400 RPM, 1800 RPM]] && MatchQ[resolvedMixRate, Except[Automatic]],
      Model[Instrument, Shaker, "id:pZx9jox97qNp"], (*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
    (* Set to the Inheco ThermoshakeAC if the MixTemperature is less than or equal to 70 degrees C *)
    MatchQ[resolvedMixTemperature, LessEqualP[70 Celsius]] || MatchQ[resolvedMixTemperature, Ambient],
      Model[Instrument, Shaker, "id:pZx9jox97qNp"], (*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
    (* Set to the Inheco Incubator Shaker if the MixTemperature is greater than 70 degrees C and it's within the 400-1800 RPM mix rate range.*)
    MatchQ[resolvedMixTemperature, GreaterP[70 Celsius]] && MatchQ[resolvedMixRate, RangeP[400 RPM, 1800 RPM]],
      Model[Instrument, Shaker, "id:eGakldJkWVnz"], (*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
    (* Otherwise, if no mix options provided, not resolved (to be resolved elsewhere).*)
    True,
      Automatic
  ];

  (*Gather resolved options and make into a list of rules with the input option names to create the function output.*)
  {
    mixTypeOptionName->resolvedMixType,
    mixRateOptionName->resolvedMixRate,
    mixTimeOptionName->resolvedMixTime,
    numberOfMixesOptionName->resolvedNumberOfMixes,
    mixVolumeOptionName->resolvedMixVolume,
    mixTemperatureOptionName->resolvedMixTemperature,
    mixInstrumentOptionName->resolvedMixInstrument
  }

];

(* ::Subsection:: *)
(* resolveExtractMixOptions Options *)

(* -- RESOLVE MIX OPTIONS -- *)

(*Default for mixing is Shaking at 300 RPM for 30 seconds.*)
DefineOptions[
  resolveExtractMixOptions,
  Options:>
      {
        {
          OptionName -> DefaultMixType,
          Default -> Shake,
          Pattern -> Shake|Pipette|None,
          AllowNull -> False,
          Description -> "The default mix type that will be set if no other extraction mix options are set and if there is not a user-set value nor a method-set value."
        },
        {
          OptionName -> DefaultMixRate,
          Default -> 300 RPM,
          Pattern -> RangeP[$MinRoboticMixRate, $MaxRoboticMixRate],
          AllowNull -> False,
          Description -> "The default mix rate that will be set if there is not a user-set value nor a method-set value and a value is required."
        },
        {
          OptionName -> DefaultMixTime,
          Default -> 30 Second,
          Pattern -> RangeP[0*Second, $MaxExperimentTime],
          AllowNull -> False,
          Description -> "The default mix time that will be set if there is not a user-set value nor a method-set value and a value is required."
        },
        {
          OptionName -> DefaultNumberOfMixes,
          Default -> 10,
          Pattern -> RangeP[1, $MaxNumberOfMixes, 1],
          AllowNull -> False,
          Description -> "The default number of mixes that will be set if there is not a user-set value nor a method-set value and a value is required."
        },
        {
          OptionName -> DefaultMixVolume,
          Default -> Automatic,
          Pattern -> RangeP[$MinRoboticTransferVolume, $MaxRoboticSingleTransferVolume]|Automatic,
          AllowNull -> False,
          Description -> "The default mix volume that will be set if there is not a user-set value nor a method-set value and a value is required.",
          ResolutionDescription -> "Automatically set to the lesser of 1/2 of the input volume (if specified and greater than the minimum robotic transfer volume) and 970 Microliter (the maximum amount of volume that can be transferred in a single pipetting step on the liquid handling robot). If 1/2 of the input volume is less than the minimum robotic transfer volume, then it is set to the minimum robotic transfer volume. Otherwise, set to 0.5 Microliter."
        },
        {
          OptionName -> InputVolume,
          Default -> Null,
          Pattern -> RangeP[0.5 Microliter, 200 Milliliter],
          AllowNull -> True,
          Description -> "The default mix volume that will be set if there is not a user-set value nor a method-set value and a value is required.",
          ResolutionDescription -> "Automatically set to the lesser of 1/2 of the input volume (if specified) and 970 Microliter (the maximum amount of volume that can be transferred in a single pipetting step on the liquid handling robot). Otherwise, set to 0.5 Microliter."
        },
        {
          OptionName -> DefaultMixTemperature,
          Default -> Ambient,
          Pattern -> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature]|Ambient,
          AllowNull -> False,
          Description -> "The default mix temperature that will be set if there is not a user-set value nor a method-set value."
        }
      }
];

(* ::Subsection:: *)
(* resolveExtractMixOptions function *)

resolveExtractMixOptions[optionsList_Association,methodPacket:PacketP[Object[Method]]|Null,mixStepUsedQ:BooleanP,mixOptionNameMap:{_Rule..},myOptions:OptionsPattern[preResolveExtractMixOptions]]:=Module[
  {safeOps, defaultMixType, defaultMixRate, defaultMixTime, defaultNumberOfMixes, defaultMixVolume, defaultMixTemperature, inputVolume, mixTypeOptionName, mixRateOptionName, mixTimeOptionName, numberOfMixesOptionName, mixVolumeOptionName, mixTemperatureOptionName, mixInstrumentOptionName, methodSpecifiedQ, resolvedMixType, resolvedMixRate, resolvedMixTime, resolvedNumberOfMixes, resolvedMixVolume, resolvedMixTemperature, resolvedMixInstrument},

  (*Get the safe options.*)
  safeOps = SafeOptions[resolveExtractMixOptions,ToList[myOptions], AutoCorrect->False];

  (*Pull out relevant default options.*)
  {defaultMixType, defaultMixRate, defaultMixTime, defaultNumberOfMixes, defaultMixVolume, defaultMixTemperature, inputVolume} = Lookup[safeOps,{DefaultMixType, DefaultMixRate, DefaultMixTime, DefaultNumberOfMixes, DefaultMixVolume, DefaultMixTemperature, InputVolume}];

  (*Find the names of each mix option from the mixOptionNameMap.*)
  {mixTypeOptionName, mixRateOptionName, mixTimeOptionName, numberOfMixesOptionName, mixVolumeOptionName, mixTemperatureOptionName, mixInstrumentOptionName} = Map[
    If[
      KeyExistsQ[mixOptionNameMap, #],
      Lookup[mixOptionNameMap, #],
      Null
    ]&,
    {MixType, MixRate, MixTime, NumberOfMixes, MixVolume, MixTemperature, MixInstrument}
  ];

  (* Setup a boolean to determine if there is a method set or not. *)
  methodSpecifiedQ = MatchQ[methodPacket, ObjectP[Object[Method]]];

  (* Resolve the MixType *)
  resolvedMixType = Which[
    (*If there is not an input MixType name, then no need to resolve and will be set to Null.*)
    MatchQ[mixTypeOptionName,Null],
      Null,
    (*If user-set, then use set value.*)
    MatchQ[Lookup[optionsList, mixTypeOptionName], Except[Automatic]],
      Lookup[optionsList, mixTypeOptionName],
    (*Set to value specified in the Method object if selected.*)
    methodSpecifiedQ && MatchQ[Lookup[methodPacket, mixTypeOptionName], Except[Null]],
     Lookup[methodPacket, mixTypeOptionName],
    (*If the overarching step for the mix options is not used, then the mix options are not needed.*)
    !mixStepUsedQ,
      Null,
    (*If shaking options are set, then the type will be set to Shake.*)
    Or[
      MatchQ[Lookup[optionsList, mixRateOptionName],Except[Automatic|Null]],
      MatchQ[Lookup[optionsList, mixTimeOptionName],Except[Automatic|Null]]
    ],
      Shake,
    (*If pipetting options are set, then the type will be set to Pipette.*)
    Or[
      MatchQ[Lookup[optionsList, mixVolumeOptionName],Except[Automatic|Null]],
      MatchQ[Lookup[optionsList, numberOfMixesOptionName],Except[Automatic|Null]]
    ],
      Pipette,
    (*Otherwise, set to the specified default value.*)
    True,
      defaultMixType
  ];

  (* Resolve the MixRate *)
  resolvedMixRate = Which[
    (*If there is not an input MixRate name, then no need to resolve and will be set to Null.*)
    MatchQ[mixRateOptionName,Null],
      Null,
    (*If user-set, then use set value.*)
    MatchQ[Lookup[optionsList, mixRateOptionName], Except[Automatic]],
     Lookup[optionsList, mixRateOptionName],
    (*Set to value specified in the Method object if selected.*)
    methodSpecifiedQ && MatchQ[Lookup[methodPacket, mixRateOptionName], Except[Null]],
     Lookup[methodPacket, mixRateOptionName],
    (*If the overarching step for the mix options is not used, then the mix options are not needed.*)
    (*Also not needed if the mixing type is pipette (since mix rate is Shake-specific) or none.*)
    Or[
      !mixStepUsedQ,
      MatchQ[resolvedMixType,Pipette|None]
    ],
     Null,
    (*Otherwise, set to the specified default.*)
    True,
     defaultMixRate
  ];

  (* Resolve the MixTime *)
  resolvedMixTime = Which[
    (*If there is not an input MixTime name, then no need to resolve and will be set to Null.*)
    MatchQ[mixTimeOptionName,Null],
     Null,
    (*If user-set, then use set value.*)
    MatchQ[Lookup[optionsList, mixTimeOptionName], Except[Automatic]],
     Lookup[optionsList, mixTimeOptionName],
    (*Set to value specified in the Method object if selected.*)
    methodSpecifiedQ && MatchQ[Lookup[methodPacket, mixTimeOptionName], Except[Null]],
    Lookup[methodPacket, mixTimeOptionName],
    (*If the overarching step for the mix options is not used, then the mix options are not needed.*)
    (*Also not needed if the mixing type is pipette (since mix time is Shake-specific) or none.*)
    Or[
      !mixStepUsedQ,
      MatchQ[resolvedMixType,Pipette|None]
    ],
     Null,
    (*Otherwise, set to the specified default.*)
    True,
     defaultMixTime
  ];

  (* Resolve the NumberOfMixes *)
  resolvedNumberOfMixes = Which[
    (*If there is not an input NumberOfMixes name, then no need to resolve and will be set to Null.*)
    MatchQ[numberOfMixesOptionName,Null],
     Null,
    (*If user-set, then use set value.*)
    MatchQ[Lookup[optionsList, numberOfMixesOptionName], Except[Automatic]],
     Lookup[optionsList, numberOfMixesOptionName],
    (*Set to value specified in the Method object if selected.*)
    methodSpecifiedQ && MatchQ[Lookup[methodPacket, numberOfMixesOptionName], Except[Null]],
     Lookup[methodPacket, numberOfMixesOptionName],
    (*If the overarching step for the mix options is not used, then the mix options are not needed.*)
    (*Also not needed if the mixing type is Shake (since number of mixes is Pipette-specific) or none.*)
    Or[
      !mixStepUsedQ,
      MatchQ[resolvedMixType,Shake|None]
    ],
      Null,
    (*Otherwise, set to the specified default.*)
    True,
     defaultNumberOfMixes
  ];

  (* Resolve the MixVolume *)
  resolvedMixVolume = Which[
    (*If there is not an input MixVolume name, then no need to resolve and will be set to Null.*)
    MatchQ[mixVolumeOptionName,Null],
     Null,
    (*If user-set, then use set value.*)
    MatchQ[Lookup[optionsList, mixVolumeOptionName], Except[Automatic]],
     Lookup[optionsList, mixVolumeOptionName],
    (*If the overarching step for the mix options is not used, then the mix options are not needed.*)
    (*Also not needed if the mixing type is Shake (since mix volume is Pipette-specific) or none.*)
    Or[
      !mixStepUsedQ,
      MatchQ[resolvedMixType,Shake|None]
    ],
     Null,
    (*If there is a default mix volume set, then use that.*)
    MatchQ[defaultMixVolume, Except[Automatic]],
      defaultMixVolume,
    (*If Automatic and input volume is provided, then calculate the mix volume.*)
    (*The lesser of 1/2 the input volume (if greater than min pipetting volume) and 970 Microliter will be used.*)
    MatchQ[inputVolume, Except[Null]] && MatchQ[defaultMixVolume, Automatic] && ((inputVolume/2)<(970*Microliter)) && ((inputVolume/2)>(0.5*Microliter)),
      (inputVolume/2),
    MatchQ[inputVolume, Except[Null]] && MatchQ[defaultMixVolume, Automatic] && ((inputVolume/2)<(970*Microliter)) && ((inputVolume/2)<=(0.5*Microliter)),
      $MinRoboticTransferVolume,
    MatchQ[inputVolume, Except[Null]] && MatchQ[defaultMixVolume, Automatic] && ((inputVolume/2)>=(970*Microliter)),
      970*Microliter,
    (*If DefaultMixVolume is Automatic, but no input volume is provided, then defaults to 0.5 Microliter.*)
    MatchQ[inputVolume, Null] && MatchQ[defaultMixVolume, Automatic],
      $MinRoboticTransferVolume
  ];

  (* Resolve MixTemperature *)
  resolvedMixTemperature = Which[
    (*If there is not an input MixTemperature name, then no need to resolve and will be set to Null.*)
    MatchQ[mixTemperatureOptionName,Null],
      Null,
    (* Use the user-specified values, if any *)
    MatchQ[Lookup[optionsList,mixTemperatureOptionName], Except[Automatic]],
      Lookup[optionsList,mixTemperatureOptionName],
    (* Use the Method-specified values, if any *)
    methodSpecifiedQ && MatchQ[Lookup[methodPacket, mixTemperatureOptionName], Except[Null]],
      Lookup[methodPacket,mixTemperatureOptionName],
    (*If the overarching step for the mix options is not used, then the mix options are not needed.*)
    (*Also not needed if the mixing type is none.*)
    Or[
      !mixStepUsedQ,
      MatchQ[resolvedMixType,None]
    ],
      Null,
    (*Otherwise, set to the specified default.*)
    True,
      defaultMixTemperature
  ];

  (* Resolve MixInstrument *)
  resolvedMixInstrument = Which[
    (*If there is not an input MixInstrument name, then no need to resolve and will be set to Null.*)
    MatchQ[mixInstrumentOptionName,Null],
      Null,
    (*If user-set, then use set value.*)
    MatchQ[Lookup[optionsList,mixInstrumentOptionName], Except[Automatic]],
     Lookup[optionsList,mixInstrumentOptionName],
    (* Set to Null if MixType is anything but Shake *)
    MatchQ[resolvedMixType, Except[Shake]],
     Null,
    (* Set to the Inheco ThermoshakeAC if the MixRate falls outside the other shaker's RPM range *)
    !MatchQ[resolvedMixRate, RangeP[400 RPM, 1800 RPM]] && MatchQ[resolvedMixRate, Except[Automatic]],
     Model[Instrument, Shaker, "id:pZx9jox97qNp"], (*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
    (* Set to the Inheco ThermoshakeAC if the MixTemperature is less than or equal to 70 degrees C *)
    MatchQ[resolvedMixTemperature, LessEqualP[70 Celsius]] || MatchQ[resolvedMixTemperature, Ambient],
     Model[Instrument, Shaker, "id:pZx9jox97qNp"], (*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
    (* Set to the Inheco Incubator Shaker if the MixTemperature is greater than 70 degrees C and it's within the 400-1800 RPM mix rate range.*)
    True,
     Model[Instrument, Shaker, "id:eGakldJkWVnz"] (*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
  ];

  (*Gather resolved options and make into a list of rules with the input option names to create the function output.*)
  {
    mixTypeOptionName->resolvedMixType,
    mixRateOptionName->resolvedMixRate,
    mixTimeOptionName->resolvedMixTime,
    numberOfMixesOptionName->resolvedNumberOfMixes,
    mixVolumeOptionName->resolvedMixVolume,
    mixTemperatureOptionName->resolvedMixTemperature,
    mixInstrumentOptionName->resolvedMixInstrument
  }

];


(* ::Subsection:: *)
(* extractionMethodValidityTest *)

Error::InvalidExtractionMethod = "For sample(s), `1`, at indices, `3`, the selected method(s), `2`, are not valid method objects. Please make sure that your method is passing ValidObjectQ before using it for an extraction";

DefineOptions[
  extractionMethodValidityTest,
  Options :> {CacheOption}
];

extractionMethodValidityTest[mySamples : {ObjectP[Object[Sample]]...}, myResolvedOptions : {_Rule...}, gatherTestsQ : BooleanP, myResolutionOptions : OptionsPattern[extractionMethodValidityTest]] := Module[
  {safeOps, cache, messages, methodOptionValues, uniqueMethodObjects, validObjectResults, validMethodObjectAssociation, invalidMethodOptions, invalidExtractionMethodTest, invalidMethodOption},

  (*Pull out the safe options.*)
  safeOps = SafeOptions[extractionMethodValidityTest, ToList[myResolutionOptions]];

  (* Lookup our cache and simulation. *)
  cache = Lookup[ToList[safeOps], Cache, {}];

  (* Determine if we should keep a running list of tests (Output contains Test). *)
  messages = !gatherTestsQ;

  (*Pull out the method option and method objects.*)
  methodOptionValues = Download[Lookup[Association @@ myResolvedOptions, Method] /. {Custom -> Null}, Object, Cache -> cache];
  uniqueMethodObjects = DeleteDuplicates[Cases[methodOptionValues, ObjectP[Object[Method, Extraction]]]];

  (* ---- extractionMethodValidityTest --- *)

  (* Run ValidObjectQ on all method objects. *)
  validObjectResults = ValidObjectQ[uniqueMethodObjects, OutputFormat -> Boolean];

  (* Associate each method object with it's ValidObjectQ result. *)
  validMethodObjectAssociation = Association @@ MapThread[
    Function[{methodObject, validObjectResult},
      methodObject -> validObjectResult
    ],
    {uniqueMethodObjects, validObjectResults}
  ];

  (*Check if each samples' method object passed ValidObjectQ.*)
  invalidMethodOptions = MapThread[
    Function[{sample, methodOptionValue, index},
      If[
        MatchQ[methodOptionValue, ObjectP[Object[Method, Extraction]]] && !Lookup[validMethodObjectAssociation, methodOptionValue, True],
        {
          sample,
          methodOptionValue,
          index
        },
        Nothing
      ]
    ],
    {mySamples, methodOptionValues, Range[Length[mySamples]]}
  ];

  If[Length[invalidMethodOptions] > 0 && messages,
    Message[
      Error::InvalidExtractionMethod,
      ObjectToString[invalidMethodOptions[[All, 1]], Cache -> cache],
      invalidMethodOptions[[All, 2]],
      invalidMethodOptions[[All, 3]]
    ];
  ];

  invalidExtractionMethodTest = If[gatherTestsQ,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = invalidMethodOptions[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " have a valid extraction method selected:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " do not have a valid extraction method selected:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  invalidMethodOption = If[Length[invalidMethodOptions] > 0,
    {Method},
    {}
  ];

  {
    {
      invalidExtractionMethodTest
    },
    invalidMethodOption
  }

];

(* Authors definition for Experiment`Private`extractionMethodValidityTest *)
Authors[Experiment`Private`extractionMethodValidityTest]:={"taylor.hochuli"};

