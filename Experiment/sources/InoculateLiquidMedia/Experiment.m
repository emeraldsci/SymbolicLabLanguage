(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection::Closed:: *)
(* Define Global Variables *)
$SolidMediaOptionSymbols = {
  Populations,
  MinRegularityRatio,
  MaxRegularityRatio,
  MinCircularityRatio,
  MaxCircularityRatio,
  MinDiameter,
  MaxDiameter,
  MinColonySeparation,
  ImagingChannels,
  ExposureTimes,
  ColonyHandlerHeadCassetteApplication,
  HeadDiameter,
  HeadLength,
  NumberOfHeads,
  ColonyPickingTool,
  ColonyPickingDepth,
  PickCoordinates,
  DestinationFillDirection,
  MaxDestinationNumberOfColumns,
  MaxDestinationNumberOfRows,
  PrimaryWash,
  PrimaryWashSolution,
  NumberOfPrimaryWashes,
  PrimaryDryTime,
  SecondaryWash,
  SecondaryWashSolution,
  NumberOfSecondaryWashes,
  SecondaryDryTime,
  TertiaryWash,
  TertiaryWashSolution,
  NumberOfTertiaryWashes,
  TertiaryDryTime,
  QuaternaryWash,
  QuaternaryWashSolution,
  NumberOfQuaternaryWashes,
  QuaternaryDryTime
};

$LiquidMediaOptionSymbols = {
  Volume,
  SourceMix,
  NumberOfSourceMixes,
  SourceMixVolume,
  PipettingMethod
};

(* ::Subsection::Closed:: *)
(*Define Options*)


(* ::Code::Initialization:: *)
DefineOptions[ExperimentInoculateLiquidMedia,

  Options :> {
	  {
      OptionName->InoculationSource,
      Default->Automatic,
      Description->"The type of the media (Solid, Liquid, or AgarStab) where the source cells are stored before the experiment.",
      ResolutionDescription->"If the source cells are in liquid media, automatically set to LiquidMedia. Otherwise if the source container is a plate, automatically set to SolidMedia, and if the source container is a vial or tube, automatically set to AgarStab.",
      AllowNull->False,
      Widget->Widget[
        Type->Enumeration,
        Pattern:>InoculationSourceP (* SolidMedia | LiquidMedia | AgarStab *)
      ],
      Category->"General"
    },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      (* General Index Matching Options *)
      {
        OptionName->Instrument,
        Default->Automatic,
        Description->"The instrument that is used to move cells to fresh liquid media from solid media, liquid media, or a bacterial stab.",
        ResolutionDescription->"If the source cells are on solid media and in a Object[Container,Plate], set to Object[Instrument,ColonyHandler,\"Pinhead\"]. If the source cells are in liquid media and Preparation->Robotic set to Null. If the source cells are in liquid media and Preparation->Manual, set to the smallest Microbial pipette that fits the Volume. If the source cells are in an agar stab and Preparation->Manual, set to a Pipette that fits 1000 Microliter Microbial tip if that will reach the bottom of DestinationMediaContainer. If that tip does not reach use a serological pipette",
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{Model[Instrument,ColonyHandler],Object[Instrument,ColonyHandler],Object[Instrument,Pipette],Model[Instrument,Pipette]}]
        ],
        Category->"General"
      },
      {
        OptionName->TransferEnvironment,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{Model[Instrument, BiosafetyCabinet],Object[Instrument, BiosafetyCabinet]}],
          PreparedContainer->False
        ],
        Description->"For each sample, the environment in which the inoculation will be performed. Containers involved in the inoculation will first be moved into the TransferEnvironment (with covers on), uncovered inside of the TransferEnvironment, then covered after the inoculation has finished -- before they're moved back onto the operator cart. This option is only applicable if InoculationSource is LiquidMedia or AgarStab and Preparation->Manual.",
        ResolutionDescription->"If InoculationSource is LiquidMedia or AgarStab and Preparation->Manual, Automatically set to a biosafety Cabinet.",
        Category->"General"
      },
		  ModifyOptions[ExperimentPickColonies,
        OptionName->DestinationMediaContainer,
        Description->"For each Sample, the desired container to have cells transferred to.",
        ResolutionDescription->"Automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] if the sample will fit. Otherwise set to the PreferredContainer[] of the output sample.",
        NestedIndexMatching->True,
        Category->"General"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->DestinationMix,
        Default->True,
        Description->"For each sample, indicates if mixing will occur after the cells are dispensed into the destination container.",
        NestedIndexMatching->True,
        Category->"General"
      ],
      {
        OptionName->DestinationMixType,
        Default->Automatic,
        AllowNull->True,
        Description->"For each sample, the type of mixing that will occur immediately after the cells are dispensed into the destination container. Pipette performs DestinationNumberOfMixes aspiration/dispense cycle(s) of DestinationMixVolume using a pipette. Swirl has the operator place the container on the surface of the TransferEnvironment and perform DestinationNumberOfMixes clockwise rotations of the container. Shake moves the pin on the ColonyHandlerHeadCassette used to pick the colony in a circular motion DestinationNumberOfMixes times in the DestinationWell. If InoculationSource is SolidMedia, Shake is applicable. If InoculationSource is LiquidMedia or AgarStab and Prepartion->Robotic, Pipette is applicable. If InoculationSource is LiquidMedia or AgarStab and Prepartion->Manual, Pipette and Swirl are applicable. See the below table.",
        ResolutionDescription->"If DestinationMix->True, automatically set based on InoculationSource. If InoculationSource is SolidMedia, set to shake. If InoculationSource is LiquidMedia or AgarStab, set to Pipette.",
        Widget->Widget[
          Type->Enumeration,
          Pattern:>InoculationMixTypeP (* Shake | Pipette | Swirl *)
        ],
        NestedIndexMatching->True,
        Category->"General"
      },
      ModifyOptions[ExperimentPickColonies,
        OptionName->DestinationNumberOfMixes,
        Description->"For each sample, the number of times the colonies will be mixed in the destination container.",
        NestedIndexMatching->True,
        Category->"General"
      ],
      ModifyOptions[ExperimentTransfer,
        OptionName->DispenseMixVolume,
        ModifiedOptionName->DestinationMixVolume,
        Description->"For each sample, the volume that will be repeatedly aspirated and dispensed via pipette from the destination sample in order to mix the destination sample immediately after the inoculation occurs. The same pipette and tips used in the inoculation will be used to mix the destination sample. This option is only applicable if InoculationSource is LiquidMedia or AgarStab.",
        ResolutionDescription->"If InoculationSource is LiquidMedia or Agar Stab, automatically set to 1/2 the volume of the destination sample or the maximum volume of the pipette being used, depending on which value is smaller.",
        Category->"General"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->MediaVolume,
        Description->"For each sample, the starting amount of liquid media in which the source colonies are deposited prior to the colonies being added.",
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to the RecommendedFillVolume of the Destination container, or 40% of the MaxVolume if the field is not populated. Otherwise set to Null",
        NestedIndexMatching->True,
        Category->"General"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->DestinationMedia,
        AllowNull -> True,
        Description->"For each Sample, the media in which the source colonies should be placed.",
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to the value in the PreferredLiquidMedia field for the first Model[Cell] in the input sample Composition. If there is no PreferredLiquidMedia, automatically set to Model[Sample, Media, \"LB Broth, Miller\"].",
        NestedIndexMatching->True,
        Category->"General"
      ],

      (* Inoculate From Solid Media Only Options *)
      ModifyOptions[ExperimentPickColonies,
        OptionName->Populations,
        AllowNull -> True,
        Description->"For each sample, the criteria used to group colonies together into a population to pick. Criteria are based on the ordering of colonies by the desired feature(s): diameter, regularity, circularity, isolation, fluorescence, and absorbance. For more information see documentation on colony selection Unit Operations: Diameter, Isolation, Regularity, Circularity, Fluorescence, Absorbance, MultiFeatured, and AllColonies. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, and if the Model[Cell] information in the sample object matches one of the fluorescent excitation and emission pairs of the colony picking instrument, Populations will group the fluorescent colonies into a population. Otherwise, Populations will be set to All.",
        NestedIndexMatching->True,
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->MinDiameter,
        Description->"For each sample, the smallest diameter value from which colonies will be included. The diameter is defined as the diameter of a circle with the same area as the colony. This option is only applicable if InoculationSource is SolidMedia.",
        Default->Automatic,
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to 0.5 Millimeter.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->MaxDiameter,
        Description->"For each sample, the largest diameter value from which colonies will be included. The diameter is defined as the diameter of a circle with the same area as the colony. This option is only applicable if InoculationSource is SolidMedia.",
        Default->Automatic,
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to 2 Millimeter.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->MinColonySeparation,
        Description->"For each sample, the closest distance included colonies can be from each other from which colonies will be included. The separation of a colony is the shortest path between the perimeter of the colony and the perimeter of any other colony. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, set to 0.2 Millimeter.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->MinRegularityRatio,
        Description->"For each sample, the smallest regularity ratio from which colonies will be included. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio. This option is only applicable if InoculationSource is SolidMedia.",
        Default->Automatic,
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to 0.65.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->MaxRegularityRatio,
        Description->"For each sample, the largest regularity ratio from which colonies will be included. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio. This option is only applicable if InoculationSource is SolidMedia.",
        Default->Automatic,
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to 1.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->MinCircularityRatio,
        Description->"For each sample, the smallest circularity ratio from which colonies will be included. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio. This option is only applicable if InoculationSource is SolidMedia.",
        Default->Automatic,
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to 0.65.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->MaxCircularityRatio,
        Description->"For each sample, the largest circularity ratio from which colonies will be included. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio. This option is only applicable if InoculationSource is SolidMedia.",
        Default->Automatic,
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to 1.",
        Category->"Inoculate From Solid Media"
      ],

      ModifyOptions[ExperimentPickColonies,
        OptionName->ImagingChannels,
        AllowNull -> True,
        Description->"For each sample, how to expose the colonies to light/and measure light from the colonies when capturing images of the colonies. Images can be taken even if they are not used during Analysis. This option is only applicable if InoculationSource is SolidMedia.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->ExposureTimes,
        AllowNull -> True,
        Description->"For each Sample and for each AdditionalImagingChannel, length of time to expose the sample to the channel. An increased ExposureTime leads to brighter images based on a linear scale. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, " (* copy sci comps alg description *),
        Category->"Inoculate From Solid Media"
      ],

      ModifyOptions[ExperimentPickColonies,
        OptionName->ColonyPickingTool,
        AllowNull -> True,
        Description->"For each sample, the part used to collect the source colonies and deposit them into a destination well. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, if the DestinationContainer has 24 wells, set to Model[Part,ColonyHandlerHeadCassette, \"Qpix 24 pin picking head - E. coli\" ]. If the DestinationContainer has 96 or 384 wells, or is an OmniTray, will use the PreferredColonyHanderHeadCassette of the first Model[Cell] in the composition of the input sample. If the Composition field is not filled or there are not Model[Cell]'s in the composition, this option is automatically set to Model[Part,ColonyHandlerHeadCassette, \" Qpix 96 pin picking head, deepwell - E. coli\"] if the destination is a deep well plate and Model[Part,ColonyHandlerHeadCassette, \" Qpix 96 pin picking head, deepwell - E. coli\"] otherwise.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->HeadDiameter,
        AllowNull -> True,
        Description->"For each sample, the width of the metal probe that will pick the colonies. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, resolves from the ColonyPickingTool[HeadDiameter].",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->HeadLength,
        AllowNull -> True,
        Description->"For each sample, the length of the metal probe that will pick the colonies. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, resolves from the ColonyPickingTool[HeadLength].",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->NumberOfHeads,
        AllowNull -> True,
        Description->"For each sample, the number of metal probes on the ColonyHandlerHeadCassette that will pick the colonies. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, resolves from the ColonyPickingTool[NumberOfHeads].",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->ColonyHandlerHeadCassetteApplication,
        AllowNull -> True,
        Description->"For each sample, the designed use of the ColonyPickingTool. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, resolves from the ColonyPickingTool[Application].",
        Category->"Inoculate From Solid Media"
      ],

      ModifyOptions[ExperimentPickColonies,
        OptionName->ColonyPickingDepth,
        AllowNull -> True,
        Description->"For each sample, the deepness to reach into the agar when collecting a colony. This option is only applicable if InoculationSource is SolidMedia.",
        Default->Automatic,
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to 2 Millimeter.",
        NestedIndexMatching->True,
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->PickCoordinates,
        AllowNull -> True,
        Description->"For each sample, the coordinates, in Millimeters, from which colonies will be collected from the source plate where {0 Millimeter, 0 Millimeter} is the center of the source well. This option is only applicable if InoculationSource is SolidMedia.",
        Category->"Inoculate From Solid Media"
      ]
    ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->DestinationFillDirection,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> RowColumnP (* Row|Column *)
        ],
        Description->"For each Sample, indicates if the destination will be filled with picked colonies in row order or column order. This option is only applicable if InoculationSource is SolidMedia.",
        Default->Automatic,
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to Row.",
        Category->"Inoculate From Solid Media"
      ],
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      ModifyOptions[ExperimentPickColonies,
        OptionName->MaxDestinationNumberOfColumns,
        Description->"For each sample, the number of columns of colonies to deposit in the destination container. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set based on the below Table.",
        NestedIndexMatching->True,
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->MaxDestinationNumberOfRows,
        Description->"For each sample, the number of rows of colonies to deposit in the destination container. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set based on the below Table.",
        NestedIndexMatching->True,
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->PrimaryWash,
        AllowNull -> True,
        Description->"For each sample, whether the PrimaryWash stage should be turned on during the sanitization process. This option is only applicable if InoculationSource is SolidMedia.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->PrimaryWashSolution,
        Description->"For each sample, the first wash solution that is used during the sanitization process prior to each round of picking. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to Model[Sample,StockSolution,\"70% Ethanol\"], if PrimaryWash -> True.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->NumberOfPrimaryWashes,
        Description->"For each sample, the number of times the ColonyHandlerHeadCassette moves in a circular motion in the PrimaryWashSolution to clean any material off the head. This option is only applicable if InoculationSource is SolidMedia.",
        Default->Automatic,
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to 5.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->PrimaryDryTime,
        Description->"For each sample, the length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in PrimaryWashSolution.. This option is only applicable if InoculationSource is SolidMedia.",
        Default->Automatic,
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to 10 Second.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->SecondaryWash,
        AllowNull -> True,
        Description->"For each sample, whether the SecondaryWash stage should be turned on during the sanitization process. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to False if PrimaryWash is False.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->SecondaryWashSolution,
        Description->"For each sample, the second wash solution that can be used during the sanitization process prior to each round of picking. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to Model[Sample,\"Milli-Q water\"].",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->NumberOfSecondaryWashes,
        Description->"For each sample, the number of times the ColonyHandlerHeadCassette moves in a circular motion in the SecondaryWashSolution to clean any material off the head. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to 5.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->SecondaryDryTime,
        Description->"For each sample, the length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in SecondaryWashSolution. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to 10 Second.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->TertiaryWash,
        AllowNull -> True,
        Description->"For each sample, whether the TertiaryWash stage should be turned on during the sanitization process. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to False if SecondaryWash is False.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->TertiaryWashSolution,
        Description->"For each sample, the third wash solution that can be used during the sanitization process prior to each round of picking. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to Model[Sample, StockSolution, \"10% Bleach\"].",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->NumberOfTertiaryWashes,
        Description->"For each sample, the number of times the ColonyHandlerHeadCassette moves in a circular motion in the TertiaryWashSolution to clean any material off the head. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to 5.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->TertiaryDryTime,
        Description->"For each sample, length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in TertiaryWashSolution. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to 10 Second.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->QuaternaryWash,
        AllowNull -> True,
        Description->"For each sample, whether the QuaternaryWash stage should be turned on during the sanitization process. This option is only applicable if InoculationSource is SolidMedia.",
        ResolutionDescription->"If InoculationSource is SolidMedia, automatically set to False if TertiaryWash is False.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->QuaternaryWashSolution,
        Description->"For each sample, the fourth wash solution that can be used during the process prior to each round of picking. This option is only applicable if InoculationSource is SolidMedia.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->NumberOfQuaternaryWashes,
        Description->"For each sample, the number of times the ColonyHandlerHeadCassette moves in a circular motion in the QuaternaryWashSolution to clean any material off the head. This option is only applicable if InoculationSource is SolidMedia.",
        Category->"Inoculate From Solid Media"
      ],
      ModifyOptions[ExperimentPickColonies,
        OptionName->QuaternaryDryTime,
        Description->"For each sample, the length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in QuaternaryWashSolution. This option is only applicable if InoculationSource is SolidMedia.",
        Category->"Inoculate From Solid Media"
      ],

      (* Inoculate From Liquid Media Only Options *)
      {
        OptionName->Volume,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Specific Volume" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0.1 Microliter, $MaxTransferVolume],
            Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
          ],
          "All" -> Widget[
            Type->Enumeration,
            Pattern:>Alternatives[All]
          ]
        ],
        Description->"For each sample, if the source cells are in liquid media, the amount of source cells to transfer to the destination container.",
        ResolutionDescription->"If InoculationSource is LiquidMedia, automatically set to 10 Microliter.",
        Category->"Inoculate From Liquid Media"
      },
      ModifyOptions[ExperimentTransfer,
        OptionName->DestinationWell,
        AllowNull->True,
        Description->"For each sample, the position in the destination container in which the source cells be moved to. This option is only applicable if InoculationSource is LiquidMedia or AgarStab.",
        ResolutionDescription->"If InoculationSource is LiquidMedia or AgarStab, automatically set to the first empty position of the Destination.",
        Category->"Inoculate From Liquid Media"
      ],
      ModifyOptions[ExperimentTransfer,
        OptionName->Tips,
        Description->"For each sample, the pipette tips used to aspirate and dispense the cells. This option is only applicable if InoculationSource is LiquidMedia.",
        ResolutionDescription->"If InoculationSource is LiquidMedia, automatically set to a tip that does not conflict with the incompatible materials of the cells that the tip will come in contact with, the amount being inoculated, and the source and destination containers of the inoculation (accessibility). For more information, please refer to the function TransferDevices[]..",
        Category->"Inoculate From Liquid Media"
      ],
      ModifyOptions[ExperimentTransfer,
        OptionName->TipType,
        Description->"For each sample, the type of pipette tips used to aspirate and dispense the cells during the inoculation. This option is only applicable if InoculationSource is LiquidMedia.",
        ResolutionDescription->"If InoculationSource is LiquidMedia, automatically set to the TipType field of the calculated Tips that will be used to perform the inoculation.",
        Category->"Inoculate From Liquid Media"
      ],
      ModifyOptions[ExperimentTransfer,
        OptionName->TipMaterial,
        Description->"For each sample, the material of the pipette tips used to aspirate and dispense the cells during the inoculation. This option is only applicable if InoculationSource is LiquidMedia.",
        ResolutionDescription->"If InoculationSource is LiquidMedia, automatically set to the chemistry of the calculated Tips that will be used to perform the inoculation.",
        Category->"Inoculate From Liquid Media"
      ],
      ModifyOptions[ExperimentTransfer,
        OptionName->AspirationMix,
        ModifiedOptionName->SourceMix,
        AllowNull->True,
        Description->"For each sample, indicates if mixing of the cells in liquid media will occur during aspiration from the source sample. This option is only applicable if InoculationSource is LiquidMedia.",
        ResolutionDescription->"If InoculationSource is LiquidMedia, automatically set to True if any of the other SourceMix options are set. ",
        Category->"Inoculate From Liquid Media"
      ],
      ModifyOptions[ExperimentTransfer,
        OptionName->AspirationMixType,
        ModifiedOptionName->SourceMixType,
        Description->"For each sample, the type of mixing of the cells that will occur immediately before aspiration from the source container. Pipette performs NumberOfSourceMixes aspiration/dispense cycle(s) of SourceMixVolume using a pipette. Swirl has the operator place the container on the surface of the TransferEnvironment and perform DestinationNumberOfMixes clockwise rotations of the container. This option is only applicable if InoculationSource is LiquidMedia. Swirl is only applicable if Preparation->Manual.",
        ResolutionDescription->"If InoculationSource is LiquidMedia, automatically set to Pipette if any of the other SourceMix options are set.",
        Widget -> Widget[
          Type->Enumeration,
          Pattern:>Pipette|Swirl
        ],
        Category->"Inoculate From Liquid Media"
      ],
      ModifyOptions[ExperimentTransfer,
        OptionName->NumberOfAspirationMixes,
        ModifiedOptionName->NumberOfSourceMixes,
        Description->"For each sample, the number of times that the source cells will be mixed during aspiration. This option is only applicable if InoculationSource is LiquidMedia.",
        ResolutionDescription->"If InoculationSource is LiquidMedia, automatically set to 5 if any of the other SourceMix options are set.",
        Category->"Inoculate From Liquid Media"
      ],
      ModifyOptions[ExperimentTransfer,
        OptionName->AspirationMixVolume,
        ModifiedOptionName->SourceMixVolume,
        Description->"For each sample, the volume that will be repeatedly aspirated and dispensed via pipette from the source cells in order to mix the source cells immediately before the inoculation occurs. The same pipette and tips used in the inoculation will be used to mix the source cells. This option is only applicable if InoculationSource is LiquidMedia.",
        ResolutionDescription->"If InoculationSource is LiquidMedia, and SourceMixType is Pipette, automatically set to 1/2 the volume of the source cells or the maximum volume of the pipette being used, depending on which value is smaller.",
        Category->"Inoculate From Liquid Media"
      ],
      ModifyOptions[ExperimentTransfer,
        OptionName->PipettingMethod,
        Description->"For each sample, the pipetting parameters used to manipulate the source cells. If other pipetting options are specified, the parameters from the method here are overwritten. This option can only be specified if InoculationSource is LiquidMedia and Preparation->Robotic.",
        ResolutionDescription->"If InoculationSource is LiquidMedia, automatically set to the PipettingMethod of the model of the sample if available.",
        Category->"Inoculate From Liquid Media"
      ],
      {
        OptionName->SampleLabel,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[Type->String,Pattern:>_String,Size->Line],
        Description->"For each sample, the label of the sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
        Category->"General",
        UnitOperation->True
      },
      {
        OptionName->SampleContainerLabel,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[Type->String,Pattern:>_String,Size->Line],
        Description->"For each sample, the label of the sample's container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
        Category->"General",
        UnitOperation->True
      },
      {
        OptionName->SampleOutLabel,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Single Label" -> Widget[Type -> String,Pattern :> _String,Size -> Line],
          "Multiple Labels" -> Adder[Widget[Type -> String,Pattern :> _String,Size -> Line]]
        ],
        Description->"For each sample, the label of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
        Category->"General",
        NestedIndexMatching->True, (* Matches to Populations *)
        UnitOperation->True
      },
      {
        OptionName->ContainerOutLabel,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Label of Single Object Container" -> Widget[Type -> String,Pattern :> _String,Size -> Line],
          "Label of Multiple Object Containers or Model Container" -> Adder[Widget[Type -> String,Pattern :> _String,Size -> Line]]
        ],
        Description->"For each sample, the label of the container of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
        Category->"General",
        NestedIndexMatching->True, (* Matches to Populations *)
        UnitOperation->True
      },
      {
        OptionName -> SamplesOutStorageCondition,
        Default -> Null,
        Description -> "The non-default conditions under which any new samples generated by this experiment should be stored after the protocol is completed. If left unset, the new samples will be stored according to their Models' DefaultStorageCondition.",
        AllowNull -> True,
        Category -> "Post Experiment",
        (* Null indicates the storage conditions will be inherited from the model *)
        Widget -> Alternatives[
          Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
        ],
        NestedIndexMatching -> True (* Matches to Populations *)
      }
    ],
    {
      OptionName->NumberOfReplicates,
      Default->Null,
      Description->"The number of destination containers to inoculate from a source colony.",
      AllowNull->True,
      Category->"General",
      Widget->Widget[Type->Number,Pattern:>GreaterEqualP[2,1]]
    },
    {
      OptionName -> WorkCell,
      Widget -> Widget[Type -> Enumeration,Pattern :> WorkCellP],
      AllowNull -> True,
      Default -> Automatic,
      Description -> "Indicates the work cell that this primitive will be run on if Preparation->Robotic.",
      Category -> "General",
      ResolutionDescription -> "Automatically set to microbioSTAR if Preparation->Robotic and InoculationSource is LiquidMedia. Automatically set to qPix if Preparation is Robotic and InoculationSource is SolidMedia. Otherwise set to Null."
    },

    ProtocolOptions,
    SubprotocolDescriptionOption,
    PreparationOption,
    SimulationOption,
    SamplesInStorageOptions,
    PostProcessingOptions
  }
];


(* ::Subsection:: *)
(*Warning and Error Messages*)


(* ::Code::Initialization:: *)
Error::MultipleInoculationSourceInInput = "Across the input samples, there are different types of InoculationSources, `1`. Please only have a single type of InoculationSource in the input samples.";
Error::InoculationSourceInputMismatch="The specified input samples, `1`, have a state that does not match InoculationSource, `2`. Please change InoculationSource to match the state of the input samples or allow this option to be resolved automatically.";
Error::InoculationSourceOptionMismatch="InoculationSource is set to `1`, however, the following options `2`, cannot be set when InoculationSource is `1`. Please look at the ExperimentInoculateLiquidMedia help file to see what options can be specified when InoculationSource is `1`, or allow the options to be resolved automatically";
Error::InvalidInstrument="The specified Instrument(s), `1`, cannot be used when InoculationSource `2`. Please specify a different Instrument, or allow this option to be resolved automatically.";
Error::MultipleDestinationMediaContainers="The input samples, `1`, have InoculationSource as LiquidMedia or AgarStab and DestinationMediaContainer as a list of Objects. Please specify a single DestinationMediaContainer when InoculationSource is LiquidMedia or AgarStab or allow this option to be resolved automatically.";
Error::InvalidMixType="The input samples, `1`, have a non Shake DestinationMixType and InoculationSource is SolidMedia. If InoculationSource is SolidMedia, the only valid DestinationMixType is Shake. Please set DestinationMixType to Shake or allow it to be resolved automatically.";
Error::NoTipsFound = "For the input samples, `1`, no Model[Item,Tips] that match the specified TipMaterial and TipType can also touch the top of the sample in the source container and the bottom of the DestinationMediaContainer. Please specify a different TipMaterial, TipType, or DestinationMediaContainer, or allow these options to be resolved automatically.";
Error::TipOptionMismatch = "For the input samples, `1`, the specified TipType or TipMaterial does not match the TipType or Material of the specified Tips. Please align these options or allow them to be resolved automatically.";
Warning::NoPreferredLiquidMedia = "The input samples, `1`, either do not have Model[Cell]'s in their composition or the Model[Cell]'s in the Composition do not have a PreferredLiquidMedia. DestinationMedia will be resolved to Model[Sample, \"Nutrient Broth\"]";
Error::InvalidDestinationWellPosition = "The input samples, `1`, have specified a DestinationWell that is not a Position in DestinationMediaContainer. Please specify a valid Position in DestinationMediaContainer or allow this option to resolve automatically.";
Error::MixMismatch = "The input samples, `1`, have DestinationMix set to True and either DestinationNumberOfMixes or DestinationMixVolume set to Null. Or DestinationMix set to False and either DestinationNumberOfMixes or DestinationMixVolume not set to Null. Please align these options or allow them to be resolved automatically.";
Error::TipConnectionMismatch = "The input samples, `1`, have a specified Instrument and Tips that do not have the same TipConnectionType. Please specify Instruments and Tips with the same TipConnectionType or allow these options to be resolved automatically.";

(* ::Subsection::Closed:: *)
(*Experiment Function*)
(* CORE Overload *)
(* ::Code::Initialization:: *)
ExperimentInoculateLiquidMedia[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
  {
    outputSpecification,output,gatherTests,listedSamplesNamed,listedOptionsNamed,safeOpsNamed,safeOpsTests,
    listedSamples,safeOps,validLengths,validLengthTests,returnEarlyQ,performSimulationQ,
    templatedOptions,templateTests,simulation,currentSimulation,inheritedOptions,expandedSafeOps,
    inoculateLiquidMediaOptionsAssociation,destinationMediaContainer,preferredDestinationMediaContainers,
    possibleDefaultTips,allDestinationMediaContainersNoLink,allDestinationMediaContainerModels,
    allDestinationMediaContainerObjects,sampleObjectDownloadPacket,sampleContainerObjectDownloadPacket,
    sampleContainerModelDownloadPacket,destinationMediaContainerObjectPacket,containerDownloadPacket,containerModelDownloadPacket,
    tipObjectDownloadPacket,tipModelDownloadPacket,pipetteObjectDownloadPacket,
    pipetteModelDownloadPacket,transferEnvironmentDownloadPacket,transferEnvironmentPipetteModelDownloadPacket,
    cacheBall,resolvedOptionsResult,roboticSimulation,protocolPacket,unitOperationPacket,batchedUnitOperationPackets,
    resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,resolvedPreparation,
    protocolObject,roboticRunTime,resourcePacketTests,
    simulatedProtocol,simulatedProtocolSimulation,uploadQ
  },

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Remove temporal links. *)
  {listedSamplesNamed, listedOptionsNamed}=removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOpsNamed,safeOpsTests}=If[gatherTests,
    SafeOptions[ExperimentInoculateLiquidMedia,listedOptionsNamed,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ExperimentInoculateLiquidMedia,listedOptionsNamed,AutoCorrect->False],{}}
  ];

  (* replace all objects referenced by Name to ID *)
  {listedSamples, safeOps} = sanitizeInputs[listedSamplesNamed, safeOpsNamed];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths,validLengthTests}=If[gatherTests,
    ValidInputLengthsQ[ExperimentInoculateLiquidMedia,{listedSamples},safeOps,Output->{Result,Tests}],
    {ValidInputLengthsQ[ExperimentInoculateLiquidMedia,{listedSamples},safeOps],Null}
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions,templateTests}=If[gatherTests,
    ApplyTemplateOptions[ExperimentInoculateLiquidMedia,{ToList[listedSamples]},safeOps,Output->{Result,Tests}],
    {ApplyTemplateOptions[ExperimentInoculateLiquidMedia,{ToList[listedSamples]},safeOps],Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests,templateTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Lookup simulation if it exists *)
  simulation = Lookup[safeOps,Simulation];

  (* Initialize the simulation if it does not exist *)
  currentSimulation = If[MatchQ[simulation,SimulationP],
    simulation,
    Simulation[]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions=ReplaceRule[safeOps,templatedOptions];

  (* Expand index-matching options *)
  expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentInoculateLiquidMedia,{ToList[listedSamples]},inheritedOptions,SingletonClassificationPreferred->DestinationMediaContainer]];

  (* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
  inoculateLiquidMediaOptionsAssociation = Association[myOptions];

  (* Lookup the options to Download From *)
  {
    destinationMediaContainer
  } = Lookup[
    expandedSafeOps,
    {
      DestinationMediaContainer
    }
  ];

  (* Possible DestinationMediaContainers from PreferredContainer*)
  (* TODO: Change this to an actual PreferredContainer call *)
  preferredDestinationMediaContainers = {
    Model[Container,Vessel,"id:AEqRl9KXBDoW"], (* Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"] *)
    Model[Container,Vessel,"id:xRO9n3vk115Y"], (* Model[Container, Vessel, "50mL Erlenmeyer Flask"] *)
    Model[Container,Vessel,"id:N80DNjlYwwjo"], (* Model[Container, Vessel, "125mL Erlenmeyer Flask"] *)
    Model[Container,Vessel,"id:jLq9jXY4kkXE"], (* Model[Container, Vessel, "250mL Erlenmeyer Flask"] *)
    Model[Container,Vessel,"id:bq9LA0dBGG0b"], (* Model[Container, Vessel, "500mL Erlenmeyer Flask"] *)
    Model[Container,Vessel,"id:8qZ1VWNmddWR"], (* Model[Container, Vessel, "1000mL Erlenmeyer Flask"] *)
    Model[Container,Vessel,"id:mnk9jORem9vw"], (* Model[Container, Vessel, "2000 mL Erlenmeyer Flask, Narrow Mouth"] *)
    Model[Container, Plate, "id:1ZA60vAn9RVP"], (* Model[Container, Plate, "96-well Greiner Tissue Culture Plate, Untreated"] *)
    Model[Container, Plate, "id:L8kPEjkmLbvW"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
    Model[Container, Plate, "id:O81aEBZjRXvx"]  (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
  };

  (* Default Tips to use *)
  (* TODO: Change this to a search *)
  possibleDefaultTips = {
    Model[Item,Tips,"id:rea9jl1or6YL"], (* Model[Item, Tips, "20 uL barrier tips, sterile"] *)
    Model[Item,Tips,"id:P5ZnEj4P88jR"], (* Model[Item, Tips, "200 uL tips, sterile"] *)
    Model[Item,Tips,"id:n0k9mGzRaaN3"], (* Model[Item, Tips, "1000 uL reach tips, sterile"] *)
    Model[Item,Tips,"id:WNa4ZjRr5ljD"], (* Model[Item, Tips, "1 mL glass barrier serological pipets, sterile"] *)
    Model[Item,Tips,"id:01G6nvkKr5Em"], (* Model[Item, Tips, "2 mL glass barrier serological pipets, sterile"] *)
    Model[Item,Tips,"id:zGj91aR3d6MJ"], (* Model[Item, Tips, "5 mL glass barrier serological pipets, sterile"] *)
    Model[Item,Tips,"id:R8e1PjRDbO7d"], (* Model[Item, Tips, "10 mL glass barrier serological pipets, sterile"] *)
    Model[Item,Tips,"id:P5ZnEj4P8q8L"], (* Model[Item, Tips, "25 mL glass barrier serological pipets, sterile"] *)
    Model[Item,Tips,"id:aXRlGnZmOJdv"]  (* Model[Item, Tips, "50 mL glass barrier serological pipets, sterile"] *)
  };

  (* Get the objects from options to download from *)
  allDestinationMediaContainersNoLink = Download[Cases[destinationMediaContainer,ObjectP[],Infinity],Object];
  allDestinationMediaContainerModels = DeleteDuplicates[Cases[allDestinationMediaContainersNoLink,ObjectP[Model[Container]]]];
  allDestinationMediaContainerObjects = DeleteDuplicates[Cases[allDestinationMediaContainersNoLink,ObjectP[Object[Container]]]];

  (* Define the packets we need to extract from the downloaded cache *)
  sampleObjectDownloadPacket=Packet[SamplePreparationCacheFields[Object[Sample],Format->Sequence],Anhydrous];
  sampleContainerObjectDownloadPacket=Packet[Container[SamplePreparationCacheFields[Object[Container],Format->List]]];
  sampleContainerModelDownloadPacket=Packet[Container[Model[SamplePreparationCacheFields[Model[Container],Format->List]]]];
  destinationMediaContainerObjectPacket=Packet[SamplePreparationCacheFields[Object[Container],Format->Sequence]];
  containerDownloadPacket=Packet[Model[SamplePreparationCacheFields[Model[Container],Format->List]]];
  containerModelDownloadPacket=Packet[SamplePreparationCacheFields[Model[Container],Format->Sequence]];
  tipObjectDownloadPacket=Packet[Model[PipetteType,Material,WideBore, Aspirator, Filtered, GelLoading,MaxVolume,AspirationDepth,Diameter3D,TipConnectionType]];
  tipModelDownloadPacket=Packet[NumberOfTips, PipetteType,Material,WideBore, Aspirator, Filtered, GelLoading,MaxVolume,AspirationDepth,Diameter3D,TipConnectionType];
  pipetteObjectDownloadPacket=Packet[Model[TipConnectionType]];
  pipetteModelDownloadPacket=Packet[TipConnectionType];
  transferEnvironmentDownloadPacket=Packet[Pipettes];
  transferEnvironmentPipetteModelDownloadPacket=Packet[Pipettes[Model]];

  (* Download from cache and simulation *)
  cacheBall=DeleteCases[Quiet[
    Flatten[
      Download[
        {
          listedSamples,
          preferredDestinationMediaContainers,
          allDestinationMediaContainerModels,
          allDestinationMediaContainerObjects,
          possibleDefaultTips,
          DeleteDuplicates@Cases[KeyDrop[inoculateLiquidMediaOptionsAssociation, {Cache, Simulation}], ObjectP[Model[Item, Tips]], Infinity],
          DeleteDuplicates@Cases[KeyDrop[inoculateLiquidMediaOptionsAssociation, {Cache, Simulation}], ObjectP[Object[Item, Tips]], Infinity],
          DeleteDuplicates@Cases[KeyDrop[inoculateLiquidMediaOptionsAssociation, {Cache, Simulation}], ObjectP[Model[Instrument, Pipette]], Infinity],
          DeleteDuplicates@Cases[KeyDrop[inoculateLiquidMediaOptionsAssociation, {Cache, Simulation}], ObjectP[Object[Instrument, Pipette]], Infinity],
          DeleteDuplicates@Cases[KeyDrop[inoculateLiquidMediaOptionsAssociation, {Cache, Simulation}], ObjectP[{Object[Instrument, BiosafetyCabinet], Model[Instrument,BiosafetyCabinet]}], Infinity]
        },
        {
          {
            sampleObjectDownloadPacket,
            Packet[Composition[[All,2]][{CellType,PreferredLiquidMedia}]],
            sampleContainerObjectDownloadPacket,
            sampleContainerModelDownloadPacket
          },
          {
            containerModelDownloadPacket
          },
          {
            containerModelDownloadPacket
          },
          {
            destinationMediaContainerObjectPacket,
            containerDownloadPacket,
            Packet[Model,RecommendedFillVolume,Notebook]
          },
          {
            tipModelDownloadPacket
          },
          {
            tipModelDownloadPacket
          },
          {
            tipObjectDownloadPacket,
            Packet[Model]
          },
          {
            pipetteModelDownloadPacket
          },
          {
            pipetteObjectDownloadPacket,
            Packet[Model]
          },
          {
            transferEnvironmentDownloadPacket,
            transferEnvironmentPipetteModelDownloadPacket
          }
        },
        Cache->Lookup[expandedSafeOps, Cache, {}],
        Simulation->simulation
      ]
    ],
    Download::FieldDoesntExist
  ],$Failed];

  (* Build the resolved options *)
  resolvedOptionsResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions,resolvedOptionsTests}=resolveExperimentInoculateLiquidMediaOptions[ToList[mySamples],expandedSafeOps,Cache->cacheBall,Simulation->currentSimulation,Output->{Result,Tests}];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {resolvedOptions,resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {resolvedOptions,resolvedOptionsTests}={resolveExperimentInoculateLiquidMediaOptions[ToList[mySamples],expandedSafeOps,Cache->cacheBall,Simulation->currentSimulation],{}},
      $Failed,
      {Error::InvalidInput,Error::InvalidOption}
    ]
  ];

  (* Collapse the resolved options *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentInoculateLiquidMedia,
    resolvedOptions,
    Ignore->ToList[myOptions],
    Messages->False
  ];

  (* Lookup our resolved Preparation option. *)
  resolvedPreparation = Lookup[resolvedOptions, Preparation];

  (* If option resolution failed, return early. *)
  If[MatchQ[resolvedOptionsResult,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentInoculateLiquidMedia,collapsedResolvedOptions],
      Preview->Null
    }]
  ];

  (* run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  returnEarlyQ = Which[
    MatchQ[resolvedOptionsResult, $Failed],
      True,
    gatherTests,
      Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
    True,
      False
  ];

  (* Figure out if we need to perform our simulation. *)
  (* NOTE: We need to perform simulation if Result is asked for in Inoculate since it's part of the CellPreparation experiments. *)
  (* This is because we pass down our simulation to ExperimentRCP (in the case of Preparation -> Robotic). *)
  performSimulationQ=MemberQ[output, Result|Simulation];

  (* If option resolution failed and we aren't asked for the simulation or output, return early. *)
  If[returnEarlyQ && !performSimulationQ,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentInoculateLiquidMedia,collapsedResolvedOptions],
      Preview->Null,
      Simulation->Simulation[]
    }]
  ];

  (* Build packets with resources *)
  (* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
  {{protocolPacket, unitOperationPacket, batchedUnitOperationPackets, roboticSimulation, roboticRunTime},resourcePacketTests}=If[returnEarlyQ,
    {{$Failed, $Failed, $Failed, $Failed, $Failed}, {}},
    If[gatherTests,
      inoculateLiquidMediaResourcePackets[ToList[mySamples],listedOptionsNamed,resolvedOptions,Cache->cacheBall,Simulation->currentSimulation,Output->{Result,Tests}],
      {inoculateLiquidMediaResourcePackets[ToList[mySamples],listedOptionsNamed,resolvedOptions,Cache->cacheBall,Simulation->currentSimulation],{}}
    ]
  ];

  (* If we were asked for a simulation, also return a simulation. *)
  {simulatedProtocol, simulatedProtocolSimulation} = Which[
    (* If Preparation -> Manual, we have to simulate the sample movements *)
    performSimulationQ && MatchQ[resolvedPreparation, Manual],
      simulateInoculateLiquidMedia[
        If[MatchQ[protocolPacket, $Failed],
          $Failed,
          protocolPacket
        ],
        ToList[mySamples],
        resolvedOptions,
        Cache->cacheBall,
        Simulation->currentSimulation,
        ParentProtocol->Lookup[safeOps, ParentProtocol]
      ],
    performSimulationQ && MatchQ[resolvedPreparation, Robotic] && MatchQ[batchedUnitOperationPackets, {PacketP[]..}],
      simulateExperimentPickColonies[
        unitOperationPacket,listedSamples,resolvedOptions,ExperimentInoculateLiquidMedia, Cache->cacheBall,Simulation->currentSimulation
      ],
    (* If Preparation -> Robotic, we can use the roboticSimulation from the ResourcePackets *)
    performSimulationQ && MatchQ[resolvedPreparation, Robotic] && MatchQ[roboticSimulation, SimulationP],
      {Null, roboticSimulation},
    (* Otherwise, we don't have to return a simulation *)
    True,
      {Null, Null}
  ];

  (* If Result does not exist in the output, return everything without uploading *)
  If[!MemberQ[output,Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentInoculateLiquidMedia,collapsedResolvedOptions],
      Preview -> Null,
      Simulation->simulatedProtocolSimulation,
      RunTime -> If[MatchQ[resolvedPreparation, Robotic],
        roboticRunTime,
        inoculateLiquidMediaRunTime[mySamples]
      ]
    }]
  ];

  (* Lookup if we are supposed to upload *)
  uploadQ = Lookup[safeOps,Upload];

  (* We have to return the result. Call UploadProtocol[..] to prepare our protocol packet (and upload it if asked) *)
  protocolObject = Which[
    (* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
    MatchQ[protocolPacket,$Failed] || MatchQ[unitOperationPacket,$Failed] || MatchQ[resolvedOptionsResult,$Failed],
      $Failed,

    (* If Preparation is Robotic, return the unit operation packets back without RequireResources called if *)
    (* Upload -> False *)
    MatchQ[resolvedPreparation, Robotic] && !uploadQ,
      Flatten[{unitOperationPacket,batchedUnitOperationPackets}],

    (* If we're doing Preparation -> Robotic and Upload -> True, call ExperimentRoboticCellPreparation with our primitive *)
    MatchQ[resolvedPreparation, Robotic],
      Module[
        {
          primitive,nonHiddenOptions
        },
        (* Create the InoculateLiquidMedia primitive to feed into RoboticCellPreparation *)
        primitive=InoculateLiquidMedia@@Join[
          {
            Sample->Download[ToList[mySamples],Object]
          },
          RemoveHiddenPrimitiveOptions[InoculateLiquidMedia,ToList[myOptions]]
        ];

        (* Remove any hidden options before returning *)
        nonHiddenOptions=RemoveHiddenOptions[ExperimentInoculateLiquidMedia,collapsedResolvedOptions];

        (* Memoize the value of ExperimentInoculateLiquidMedia so the framework doesn't spend time resolving it again. *)
        Block[{ExperimentInoculateLiquidMedia,$PrimitiveFrameworkResolverOutputCache},
          $PrimitiveFrameworkResolverOutputCache=<||>;

          ExperimentInoculateLiquidMedia[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
            (* Lookup the output specification the framework is asking for *)
            frameworkOutputSpecification=Lookup[ToList[options],Output];

            frameworkOutputSpecification/.{
              Result -> Flatten[{unitOperationPacket,batchedUnitOperationPackets}],
              Options -> nonHiddenOptions,
              Preview -> Null,
              Simulation -> simulatedProtocolSimulation,
              RunTime -> roboticRunTime
            }
          ];

          ExperimentRoboticCellPreparation[
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
      ],

    (* Otherwise, upload an Object[Protocol, InoculateLiquidMedia] *)
    True,
      UploadProtocol[
        protocolPacket, (* Protocol packet *)
        Upload->Lookup[safeOps,Upload],
        Confirm->Lookup[safeOps,Confirm],
        ParentProtocol->Lookup[safeOps,ParentProtocol],
        Priority->Lookup[safeOps,Priority],
        StartDate->Lookup[safeOps,StartDate],
        HoldOrder->Lookup[safeOps,HoldOrder],
        QueuePosition->Lookup[safeOps,QueuePosition],
        ConstellationMessage->Object[Protocol,MagneticBeadSeparation],
        Cache->cacheBall,
        Simulation -> simulatedProtocolSimulation
      ]
  ];

  (* Return requested output *)
  outputSpecification/.{
    Result -> protocolObject,
    Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests(*,resourcePacketTests*)}],
    Options -> RemoveHiddenOptions[ExperimentInoculateLiquidMedia,collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> simulatedProtocolSimulation,
    RunTime -> If[MatchQ[resolvedPreparation, Robotic],
      roboticRunTime,
      inoculateLiquidMediaRunTime[mySamples]
    ]
  }
];

(* Container Overload *)
ExperimentInoculateLiquidMedia[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
  {
    outputSpecification,output,gatherTests,listedContainers,listedOptions,simulation,
    containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests
  },

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Remove temporal links. *)
  {listedContainers, listedOptions}=removeLinks[ToList[myContainers], ToList[myOptions]];

  (* Lookup simulation option if it exists *)
  simulation = Lookup[listedOptions,Simulation,Null];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput,containerToSampleTests}=containerToSampleOptions[
      ExperimentInoculateLiquidMedia,
      listedContainers,
      listedOptions,
      Output->{Result,Tests},
      Simulation->simulation
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      containerToSampleOutput=containerToSampleOptions[
        ExperimentInoculateLiquidMedia,
        listedContainers,
        listedOptions,
        Output->Result,
        Simulation->simulation
      ],
      $Failed,
      {Error::EmptyContainer}
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
    ExperimentInoculateLiquidMedia[samples,ReplaceRule[sampleOptions,Simulation->simulation]]
  ]
];


(* ::Subsection:: *)
(*RunTime Resolver*)
inoculateLiquidMediaRunTime[mySamples_] := 5 Minute * Length[mySamples];

(* ::Subsection:: *)
(*Method Resolver*)

DefineOptions[resolveInoculateLiquidMediaMethod,
  SharedOptions:>{
    ExperimentInoculateLiquidMedia,
    CacheOption,
    SimulationOption,
    OutputOption
  }
];

resolveInoculateLiquidMediaMethod[mySamples:Automatic|ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
  {
    safeOptions,cache,simulation,outputSpecification, output, gatherTests,inputSamplePackets,inputContainerPackets,
    flattenedCachePackets,combinedFastAssoc,manualRequirementStrings, roboticRequirementStrings,
    result,tests
  },

  (* Get our safe options. *)
  safeOptions = SafeOptions[resolveInoculateLiquidMediaMethod, ToList[myOptions]];

  (* Specificially lookup the cache and simulation *)
  cache = Lookup[ToList[myOptions], Cache, {}];
  simulation = Lookup[ToList[myOptions], Simulation, Null];

  (* Determine the requested return value from the function *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Download information from input samples *)
  {
    inputSamplePackets,
    inputContainerPackets
  }=Quiet[Download[
    {
      DeleteDuplicates@Cases[Flatten[ToList[mySamples]], ObjectP[Object[Sample]]],
      DeleteDuplicates@Cases[Flatten[ToList[mySamples]], ObjectP[Object[Container]]]
    },
    {
      Packet[Container,State],
      Packet[Contents[[All,2]]]
    },
    Cache->cache,
    Simulation->simulation
  ],
    Download::FieldDoesntExist
  ];

  (* Flatten cache packets and make fast lookup association *)
  flattenedCachePackets = FlattenCachePackets[{inputSamplePackets,inputContainerPackets}];
  combinedFastAssoc = Experiment`Private`makeFastAssocFromCache[flattenedCachePackets];

  (* Create a list of reasons why we need Preparation -> Manual *)
  manualRequirementStrings = {
    If[MatchQ[Lookup[safeOptions,InoculationSource],AgarStab],
      "the InoculationSource is AgarStab, which can only occur manually",
      Nothing
    ],
    Module[{agarStabSamples},
      
      (* Get the samples that are considered AgarStabs (samples that are solid but are not in an Object[Container,Plate] *)
      agarStabSamples = Select[mySamples,MatchQ[fastAssocLookup[combinedFastAssoc,#,State],Solid]&&!MatchQ[fastAssocLookup[combinedFastAssoc,#,Container],ObjectP[Object[Container,Plate]]]&];

      If[Length[agarStabSamples] > 0,
        "the samples, " <> ObjectToString[agarStabSamples,Cache->cache] <> " are considered agar stabs and having an agar stab source can only occur manually",
        Nothing
      ]
    ],
    If[MatchQ[Lookup[safeOptions,Instrument],ListableP[ObjectP[{Model[Instrument,Pipette],Object[Instrument,Pipette]}]]],
      "pipette Instruments can only be used manually",
      Nothing
    ],
    If[MatchQ[Lookup[safeOptions, Preparation], Manual],
      "the Preparation option is set to Manual by the user",
      Nothing
    ]
  };

  (* Create a list of reasons why we need Preparation -> Robotic *)
  roboticRequirementStrings = {
    If[MatchQ[Lookup[safeOptions,InoculationSource],SolidMedia],
      "the InoculationSource is SolidMedia, which can only occur robotically",
      Nothing
    ],
    Module[{optionsToCheck,optionDefinition,roboticOnlyOptions},
      
      (* Get the options that only pertain to SolidMedia InoculationSource *)
      optionsToCheck = KeyTake[Association@safeOptions,Join[$SolidMediaOptionSymbols,{PipettingMethod}]];

      (* Get the option definition of the function *)
      optionDefinition = OptionDefinition[ExperimentInoculateLiquidMedia];

      (* Mark any that do not match their default or Null *)
      roboticOnlyOptions = KeyValueMap[
        Function[{symbol,value},

          (* If the option matches its Default or Null, do Nothing *)
          If[MatchQ[value,ListableP[ListableP[ReleaseHold[Lookup[First[Cases[optionDefinition,KeyValuePattern["OptionSymbol"->symbol]]],"Default"]] | Null]]],
            Nothing,
            symbol
          ]
        ],
        optionsToCheck
      ];

      If[Length[roboticOnlyOptions] > 0,
        "the following options only apply when InoculationSource is SolidMedia, " <> ToString[roboticOnlyOptions] <> ". Colony picking is only supported on ColonyHandlers.",
        Nothing
      ]
    ],
    If[MatchQ[Lookup[safeOptions,Instrument],ListableP[ObjectP[{Model[Instrument,LiquidHandler],Object[Instrument,LiquidHandler],Model[Instrument,ColonyHandler],Object[Instrument,ColonyHandler]}]]],
      "the ColonyHandlers and LiquidHandlers are robotic instruments",
      Nothing
    ],
    Module[{solidMediaSamples},

      (* Get the samples that are considered SolidMedia (samples that are solid and are  in an Object[Container,Plate] *)
      solidMediaSamples = Select[mySamples,MatchQ[fastAssocLookup[combinedFastAssoc,#,State],Solid]&&MatchQ[fastAssocLookup[combinedFastAssoc,#,Container],ObjectP[Object[Container,Plate]]]&];

      If[Length[solidMediaSamples] > 0,
        "the samples, " <> ObjectToString[solidMediaSamples,Cache->cache] <> " are considered in SolidMedia and colonies can only be picked off of them robotically",
        Nothing
      ]
    ],
    If[MatchQ[Lookup[safeOptions, Preparation], Robotic],
      "the Preparation option is set to Robotic by the user",
      Nothing
    ]
  };

  (* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
  If[Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0 && !gatherTests,
    (* NOTE: Blocking $MessagePrePrint stops our error message from being truncated with ... if it gets too long. *)
    Block[{$MessagePrePrint},
      Message[
        Error::ConflictingUnitOperationMethodRequirements,
        listToString[manualRequirementStrings],
        listToString[roboticRequirementStrings]
      ]
    ]
  ];

  (* Return our result and tests. *)
  result=Which[
    !MatchQ[Lookup[safeOptions, Preparation], Automatic],
      Lookup[safeOptions, Preparation],
    Length[manualRequirementStrings]>0,
      Manual,
    Length[roboticRequirementStrings]>0,
      Robotic,
    True,
      {Manual, Robotic}
  ];

  (* Gather tests if needed *)
  tests=If[MatchQ[gatherTests, False],
    {},
    {
      Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the InoculateLiquidMedia primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
    }
  ];

  (* Return as necessary *)
  outputSpecification/.{Result->result, Tests->tests}

];


(* ::Subsection::Closed:: *)
(*Option Resolver*)
(*resolveInoculateLiquidMediaOptions*)


(* ::Code::Initialization:: *)
DefineOptions[
  resolveInoculateLiquidMediaOptions,
  Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentInoculateLiquidMediaOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveInoculateLiquidMediaOptions]]:=Module[
  {
    (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
    outputSpecification,output,gatherTests,messages,cache,simulation,currentSimulation,optionDefinition,inoculateLiquidMediaOptionsAssociation,
    destinationMediaContainer,preferredDestinationMediaContainers,possibleDefaultTips,allDestinationMediaContainersNoLink,allDestinationMediaContainerModels,
    allDestinationMediaContainerObjects,
    sampleObjectDownloadPacket,sampleContainerObjectDownloadPacket,sampleContainerModelDownloadPacket,destinationMediaContainerObjectPacket,
    containerDownloadPacket,containerModelDownloadPacket,tipObjectDownloadPacket,tipModelDownloadPacket,
    pipetteObjectDownloadPacket,pipetteModelDownloadPacket,transferEnvironmentDownloadPacket,transferEnvironmentPipetteModelPacket,
    samplePackets,preferredDestinationMediaContainerPackets,destinationMediaContainerModelPackets,
    destinationMediaContainerObjectPackets,possibleDefaultTipsModelPackets,tipModelPackets,tipObjectPackets,pipetteModelPackets,pipetteObjectPackets,
    transferEnvironmentPackets,flattenedCachePackets,combinedCache,combinedFastAssoc,
    preparationResult,allowedPreparation,preparationTest,resolvedPreparation,allowedWorkCells,resolvedWorkCell,resolvedNumberOfReplicates,
    resolvedSamplesInStorageCondition,resolvedSamplesOutStorageCondition,

    (*-- INPUT VALIDATION CHECKS --*)
    discardedSamplePackets,discardedInvalidInputs,discardedTest,
    solidMediaSamples,liquidMediaSamples,agarStabMediaSamples,multipleSourceSampleTypes,
    multipleInoculationSourceInInputInputs,multipleInoculationSourceInInputTests,
    inoculationSourceInputSampleMismatchInputs,inoculationSourceInputSampleMismatchOptions,inoculationSourceInputSampleMismatchTest,

    (*-- OPTION PRECISION CHECKS --*)
    optionPrecisions,roundedInoculateLiquidMediaOptions,optionPrecisionTests,

    (*-- RESOLVE INDEPENDENT OPTIONS --*)
    inoculationSource,resolvedInoculationSource,
    inoculationSourceOptionMismatchOptions,inoculationSourceOptionMismatchTests,
    inoculationSourceError,
    
    (* -- Big Switch -- *)
    invalidInstrumentErrors,multipleDestinationMediaContainersErrors,invalidMixTypeErrors,
    noTipsFoundErrors,
    tipOptionMismatchErrors,
    noPreferredLiquidMediaWarnings,
    invalidDestinationWellErrors,
    mixMismatchErrors,
    tipConnectionMismatchErrors,

    resolvedOptions,switchInvalidOptions,

    (* -- Error Throwing -- *)
    invalidInstrumentOptions,invalidInstrumentTests,
    multipleDestinationMediaContainersOptions,multipleDestinationMediaContainersTests,
    invalidMixTypeOptions,invalidMixTypeTests,
    noTipsFoundOptions,noTipsFoundTests,
    tipOptionMismatchOptions,tipOptionMismatchTests,
    invalidDestinationWellOptions,invalidDestinationWellTests,
    mixMismatchOptions,mixMismatchTests,
    tipConnectionMismatchOptions,tipConnectionMismatchTests,

    (* -- RETURN -- *)
    invalidInputs,invalidOptions,resolvedPostProcessingOptions
  },

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];
  messages = Not[gatherTests];

  (* Fetch our cache from the parent function. *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation=Lookup[ToList[myResolutionOptions],Simulation];

  (* Initialize the simulation if it is not initialized *)
  currentSimulation = If[MatchQ[simulation,SimulationP],
    simulation,
    Simulation[]
  ];

  (* Get the option definition of the function *)
  optionDefinition = OptionDefinition[ExperimentInoculateLiquidMedia];

  (* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
  inoculateLiquidMediaOptionsAssociation = Association[myOptions];

  (* Lookup the options to Download From *)
  {
    destinationMediaContainer
  } = Lookup[
    myOptions,
    {
      DestinationMediaContainer
    }
  ];

  (* Possible DestinationMediaContainers from PreferredContainer*)
  (* TODO: Change this to an actual PreferredContainer call *)
  preferredDestinationMediaContainers = {
    Model[Container,Vessel,"id:AEqRl9KXBDoW"], (* Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"] *)
    Model[Container,Vessel,"id:xRO9n3vk115Y"], (* Model[Container, Vessel, "50mL Erlenmeyer Flask"] *)
    Model[Container,Vessel,"id:N80DNjlYwwjo"], (* Model[Container, Vessel, "125mL Erlenmeyer Flask"] *)
    Model[Container,Vessel,"id:jLq9jXY4kkXE"], (* Model[Container, Vessel, "250mL Erlenmeyer Flask"] *)
    Model[Container,Vessel,"id:bq9LA0dBGG0b"], (* Model[Container, Vessel, "500mL Erlenmeyer Flask"] *)
    Model[Container,Vessel,"id:8qZ1VWNmddWR"], (* Model[Container, Vessel, "1000mL Erlenmeyer Flask"] *)
    Model[Container,Vessel,"id:mnk9jORem9vw"], (* Model[Container, Vessel, "2000 mL Erlenmeyer Flask, Narrow Mouth"] *)
    Model[Container, Plate, "id:1ZA60vAn9RVP"], (* Model[Container, Plate, "96-well Greiner Tissue Culture Plate, Untreated"] *)
    Model[Container, Plate, "id:L8kPEjkmLbvW"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
    Model[Container, Plate, "id:O81aEBZjRXvx"]  (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
  };

  (* Default Tips to use *)
  (* TODO: Change this to a search *)
  possibleDefaultTips = {
    Model[Item,Tips,"id:rea9jl1or6YL"], (* Model[Item, Tips, "20 uL barrier tips, sterile"] *)
    Model[Item,Tips,"id:P5ZnEj4P88jR"], (* Model[Item, Tips, "200 uL tips, sterile"] *)
    Model[Item,Tips,"id:n0k9mGzRaaN3"], (* Model[Item, Tips, "1000 uL reach tips, sterile"] *)
    Model[Item,Tips,"id:WNa4ZjRr5ljD"], (* Model[Item, Tips, "1 mL glass barrier serological pipets, sterile"] *)
    Model[Item,Tips,"id:01G6nvkKr5Em"], (* Model[Item, Tips, "2 mL glass barrier serological pipets, sterile"] *)
    Model[Item,Tips,"id:zGj91aR3d6MJ"], (* Model[Item, Tips, "5 mL glass barrier serological pipets, sterile"] *)
    Model[Item,Tips,"id:R8e1PjRDbO7d"], (* Model[Item, Tips, "10 mL glass barrier serological pipets, sterile"] *)
    Model[Item,Tips,"id:P5ZnEj4P8q8L"], (* Model[Item, Tips, "25 mL glass barrier serological pipets, sterile"] *)
    Model[Item,Tips,"id:aXRlGnZmOJdv"]  (* Model[Item, Tips, "50 mL glass barrier serological pipets, sterile"] *)
  };

  (* Get the objects from options to download from *)
  allDestinationMediaContainersNoLink = Download[Cases[destinationMediaContainer,ObjectP[],Infinity],Object];
  allDestinationMediaContainerModels = Cases[allDestinationMediaContainersNoLink,ObjectP[Model[Container]]];
  allDestinationMediaContainerObjects = Cases[allDestinationMediaContainersNoLink,ObjectP[Object[Container]]];

  (* Define the packets we need to extract from the downloaded cache *)
  sampleObjectDownloadPacket=Packet[SamplePreparationCacheFields[Object[Sample],Format->Sequence],Anhydrous];
  sampleContainerObjectDownloadPacket=Packet[Container[SamplePreparationCacheFields[Object[Container],Format->List]]];
  sampleContainerModelDownloadPacket=Packet[Container[Model[SamplePreparationCacheFields[Model[Container],Format->List]]]];
  destinationMediaContainerObjectPacket=Packet[SamplePreparationCacheFields[Object[Container],Format->Sequence]];
  containerDownloadPacket=Packet[Model[SamplePreparationCacheFields[Model[Container],Format->List]]];
  containerModelDownloadPacket=Packet[SamplePreparationCacheFields[Model[Container],Format->Sequence]];
  tipObjectDownloadPacket=Packet[Model[PipetteType,Material,WideBore, Aspirator, Filtered, GelLoading,MaxVolume,AspirationDepth,Diameter3D,TipConnectionType]];
  tipModelDownloadPacket=Packet[PipetteType,Material,WideBore, Aspirator, Filtered, GelLoading,MaxVolume,AspirationDepth,Diameter3D,TipConnectionType];
  pipetteObjectDownloadPacket=Packet[Model[TipConnectionType]];
  pipetteModelDownloadPacket=Packet[TipConnectionType];
  transferEnvironmentDownloadPacket=Packet[Pipettes];
  transferEnvironmentPipetteModelPacket=Packet[Pipettes[Model]];
  
  (* Download from cache and simulation *)
  {
    samplePackets,
    preferredDestinationMediaContainerPackets,
    destinationMediaContainerModelPackets,
    destinationMediaContainerObjectPackets,
    possibleDefaultTipsModelPackets,
    tipModelPackets,
    tipObjectPackets,
    pipetteModelPackets,
    pipetteObjectPackets,
    transferEnvironmentPackets
  }=Quiet[
    Download[
      {
        mySamples,
        preferredDestinationMediaContainers,
        allDestinationMediaContainerModels,
        allDestinationMediaContainerObjects,
        possibleDefaultTips,
        DeleteDuplicates@Cases[KeyDrop[inoculateLiquidMediaOptionsAssociation, {Cache, Simulation}], ObjectP[Model[Item, Tips]], Infinity],
        DeleteDuplicates@Cases[KeyDrop[inoculateLiquidMediaOptionsAssociation, {Cache, Simulation}], ObjectP[Object[Item, Tips]], Infinity],
        DeleteDuplicates@Cases[KeyDrop[inoculateLiquidMediaOptionsAssociation, {Cache, Simulation}], ObjectP[Model[Instrument, Pipette]], Infinity],
        DeleteDuplicates@Cases[KeyDrop[inoculateLiquidMediaOptionsAssociation, {Cache, Simulation}], ObjectP[Object[Instrument, Pipette]], Infinity],
        DeleteDuplicates@Cases[KeyDrop[inoculateLiquidMediaOptionsAssociation, {Cache, Simulation}], ObjectP[Object[Instrument, BiosafetyCabinet], Model[Instrument,BiosafetyCabinet]], Infinity]
      },
      {
        {
          sampleObjectDownloadPacket,
          Packet[Composition[[All,2]][{CellType,PreferredLiquidMedia}]],
          sampleContainerObjectDownloadPacket,
          sampleContainerModelDownloadPacket
        },
        {
          containerModelDownloadPacket
        },
        {
          containerModelDownloadPacket
        },
        {
          destinationMediaContainerObjectPacket,
          containerDownloadPacket,
          Packet[Model,AllowedPositions,Notebook,RecommendedFillVolume]
        },
        {
          tipModelDownloadPacket
        },
        {
          tipModelDownloadPacket
        },
        {
          tipObjectDownloadPacket,
          Packet[Model]
        },
        {
          pipetteModelDownloadPacket
        },
        {
          pipetteObjectDownloadPacket,
          Packet[Model]
        },
        {
          transferEnvironmentDownloadPacket,
          transferEnvironmentPipetteModelPacket
        }
      },
      Cache->cache,
      Simulation->simulation
    ],
    Download::FieldDoesntExist
  ];

  (* combine the cache packets *)
  flattenedCachePackets = FlattenCachePackets[
    {
      samplePackets,
      preferredDestinationMediaContainerPackets,
      destinationMediaContainerModelPackets,
      destinationMediaContainerObjectPackets,
      possibleDefaultTipsModelPackets,
      tipModelPackets,
      tipObjectPackets,
      pipetteModelPackets,
      pipetteObjectPackets,
      transferEnvironmentPackets
    }
  ];

  (* Create combined fast assoc *)
  combinedCache=FlattenCachePackets[{flattenedCachePackets,cache}];
  combinedFastAssoc=Experiment`Private`makeFastAssocFromCache[combinedCache];

  (* Resolve our preparation option. *)
  preparationResult=Check[
    {allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
      {
        resolveInoculateLiquidMediaMethod[mySamples, ReplaceRule[myOptions, {Cache->combinedCache, Output->Result}]],
        {}
      },
      resolveInoculateLiquidMediaMethod[mySamples, ReplaceRule[myOptions, {Cache->combinedCache, Output->{Result, Tests}}]]
    ],
    $Failed
  ];

  (* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
  (* options so that OptimizeUnitOperations can perform primitive grouping. *)
  resolvedPreparation=If[MatchQ[allowedPreparation, _List],
    First[allowedPreparation],
    allowedPreparation
  ];

  (* Resolve the work cell that we're going to operator on. *)
  allowedWorkCells=resolveInoculateLiquidMediaWorkCell[mySamples, ReplaceRule[myOptions, {Cache->combinedCache, Output->Result}]];

  resolvedWorkCell=Which[
    (* keep the workcell specified *)
    MatchQ[Lookup[myOptions, WorkCell], Except[Automatic]],
      Lookup[myOptions, WorkCell],
    (* If Preparation is Manual, we don't need a workCell *)
    MatchQ[resolvedPreparation, Manual],
      Null,
    (* If workCell is automatic, use the first allowed workcell *)
    Length[allowedWorkCells]>0,
      First[allowedWorkCells],
    (* Default to the microbioSTAR if necessary *)
    True,
      microbioSTAR
  ];

  (* No resolution necessary for NumberOfReplicates *)
  resolvedNumberOfReplicates = Lookup[myOptions,NumberOfReplicates];

  (* No resolution necessary for samples Storage condition options *)
  resolvedSamplesInStorageCondition = Lookup[myOptions,SamplesInStorageCondition];
  resolvedSamplesOutStorageCondition = Lookup[myOptions, SamplesOutStorageCondition];


  (*-- INPUT VALIDATION CHECKS --*)

  (* Discarded Sample Checks *)
  (* Get the samples from mySamples that are discarded. *)
  discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
    {},
    Lookup[discardedSamplePackets,Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs]>0&&!gatherTests,
    Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->combinedCache]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  discardedTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[discardedInvalidInputs]==0,
        Nothing,
        Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->combinedCache]<>" are not discarded:",True,False]
      ];

      passingTest=If[Length[discardedInvalidInputs]==Length[mySamples],
        Nothing,
        Test["Our input samples "<>ObjectToString[Complement[mySamples,discardedInvalidInputs],Cache->combinedCache]<>" are not discarded:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* Multiple Input Sample State checks *)
  (* Classify each sample as a SolidMedia source sample, LiquidMedia source sample, AgarStab source sample *)
  {
    solidMediaSamples,
    liquidMediaSamples,
    agarStabMediaSamples
  }=Transpose[Map[
    Function[{sample},
      Module[{sampleContainer,sampleState},

        (* Get the sample container *)
        sampleContainer = fastAssocLookup[combinedFastAssoc,sample,Container];

        (* Get the sample state *)
        sampleState = fastAssocLookup[combinedFastAssoc,sample,State];

        Switch[{sampleContainer,sampleState},

          (* If the state is solid and the container is a plate -> SolidMedia source (can pick off of) *)
          {ObjectP[Object[Container,Plate]],Solid},
            {sample,Null,Null},

          (* Otherwise if the state is solid but the container is not a plate -> AgarStab *)
          {_,Solid},
            {Null,Null,sample},

          (* Else if the state is liquid it is a LiquidMedia source *)
          {_,Liquid},
            {Null,sample,Null},

          (* Catchall - put as liquid *)
          _,
            {Null,sample,Null}
        ]
      ]
    ],
    mySamples
  ]]/.{Null->Nothing};

  (* Mark if we have multiple source sample types - This is an important flag/major error *)
  multipleSourceSampleTypes = Or[
    Length[solidMediaSamples] > 0 && Length[liquidMediaSamples] > 0,
    Length[solidMediaSamples] > 0 && Length[agarStabMediaSamples] > 0,
    Length[agarStabMediaSamples] > 0 && Length[liquidMediaSamples] > 0
  ];

  (* Throw an error if there are multiple source sample types *)
  multipleInoculationSourceInInputInputs = If[multipleSourceSampleTypes && messages,

    (* Throw an error and mark the bad inputs *)
    Message[Error::MultipleInoculationSourceInInput,mySamples];
    {mySamples},
    {}
  ];

  (* Create a test if we are gathering tests *)
  multipleInoculationSourceInInputTests = If[multipleSourceSampleTypes && gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = mySamples;

      (* Get the passing inputs *)
      passingInputs = {};

      (* Create the passing test *)
      passingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have only a single source type among them:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have only a single source type among them:",True,False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* InoculationSource Input sample mismatch checks *)
  inoculationSourceInputSampleMismatchInputs = Switch[Lookup[inoculateLiquidMediaOptionsAssociation,InoculationSource],

    (* If InoculationSource is Automatic, no samples can be mismatched with it *)
    Automatic,
      {},
    (* Otherwise if InoculationSource is set, check against the other two types *)
    SolidMedia,
      Join[liquidMediaSamples,agarStabMediaSamples],
    LiquidMedia,
      Join[solidMediaSamples,agarStabMediaSamples],
    AgarStab,
      Join[solidMediaSamples,liquidMediaSamples]
  ];

  inoculationSourceInputSampleMismatchOptions = If[Length[inoculationSourceInputSampleMismatchInputs] > 0 && messages,
    Message[Error::InoculationSourceInputMismatch,inoculationSourceInputSampleMismatchInputs,Lookup[inoculateLiquidMediaOptionsAssociation,InoculationSource]];
    {InoculationSource},
    {}
  ];

  inoculationSourceInputSampleMismatchTest = If[Length[inoculationSourceInputSampleMismatchInputs] > 0 && gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = inoculationSourceInputSampleMismatchInputs;

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have a state that corresponds with InoculationSource:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have a state that corresponds with InoculationSource:",True,False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (*-- OPTION PRECISION CHECKS --*)
  (* First, define the option precisions that need to be checked for InoculateLiquidMedia *)
  optionPrecisions={
    {ColonyPickingDepth,10^-2*Millimeter},
    {ExposureTimes,10^0*Millisecond},
    {PrimaryDryTime,10^0*Second},
    {SecondaryDryTime,10^0*Second},
    {TertiaryDryTime,10^0*Second},
    {QuaternaryDryTime,10^0*Second}
  };

  (* Check the precisions of these options. *)
  {roundedInoculateLiquidMediaOptions,optionPrecisionTests}=If[gatherTests,
    (*If we are gathering tests *)
    RoundOptionPrecision[inoculateLiquidMediaOptionsAssociation,optionPrecisions[[All,1]],optionPrecisions[[All,2]],Output->{Result,Tests}],
    (* Otherwise *)
    {RoundOptionPrecision[inoculateLiquidMediaOptionsAssociation,optionPrecisions[[All,1]],optionPrecisions[[All,2]]],{}}
  ];

  (*-- RESOLVE INDEPENDENT OPTIONS --*)

  (* Lookup the options that are being resolved independently *)
  {
    inoculationSource
  }=Lookup[
    roundedInoculateLiquidMediaOptions,
    {
      InoculationSource
    }
  ];

  (* Resolve InoculationSource *)
  resolvedInoculationSource = If[MatchQ[inoculationSource,Automatic],
    (* If the option is Automatic, resolve it based on the type of input samples *)
    Which[
      (* If there are multiple types of source samples, short circuit to Null *)
      multipleSourceSampleTypes,
        Null,

      (* Otherwise, set based off of the input samples  *)
      Length[solidMediaSamples] > 0,
        SolidMedia,
      Length[liquidMediaSamples] > 0,
        LiquidMedia,
      Length[agarStabMediaSamples] > 0,
        AgarStab
    ],
    (* Otherwise keep the option as is *)
    inoculationSource
  ];

  (* Check for specified options that do not correspond to the resolvedInoculationSource *)
  inoculationSourceOptionMismatchOptions = Which[

    (* If there are multipleSourceSampleTypes no need to check for this error *)
    multipleSourceSampleTypes,
      {InoculationSource},

    (* There are options which can only be set for InoculationSource -> SolidMedia *)
    MatchQ[resolvedInoculationSource,LiquidMedia],
      Module[{badOptions},
        (* Get the mismatched options *)
        badOptions = Map[Function[{symbol},
          Module[{optionValue,optionDefault},

            (* Lookup the option *)
            optionValue = Lookup[roundedInoculateLiquidMediaOptions,symbol];

            (* Lookup the options default *)
            optionDefault = First[Lookup[Cases[optionDefinition,KeyValuePattern["OptionSymbol"->symbol]],"Default"]];

            (* See if the option matches ListableP[ListableP[default]] *)
            If[MatchQ[optionValue,ListableP[ListableP[ReleaseHold[optionDefault] | Null]]],
              Nothing,
              symbol
            ]
          ]
        ],
          $SolidMediaOptionSymbols
        ];

        (* Add InoculationSource if there are mismatched options *)
        If[Length[badOptions] > 0,
          Join[{InoculationSource},badOptions],
          badOptions
        ]
      ],

    (* There are options which can only be set for InoculationSource -> LiquidMedia *)
    MatchQ[resolvedInoculationSource,SolidMedia],
      Module[{badOptions},
        (* Get the mismatched options *)
        badOptions = Map[Function[{symbol},
          Module[{optionValue,optionDefault},

            (* Lookup the option *)
            optionValue = Lookup[roundedInoculateLiquidMediaOptions,symbol];

            (* Lookup the options default *)
            optionDefault = First[Lookup[Cases[optionDefinition,KeyValuePattern["OptionSymbol"->symbol]],"Default"]];

            (* See if the option matches ListableP[ListableP[default]] *)
            If[MatchQ[optionValue,ListableP[ListableP[ReleaseHold[optionDefault] | Null]]],
              Nothing,
              symbol
            ]
          ]
        ],
          $LiquidMediaOptionSymbols
        ];

        (* Add InoculationSource if there are mismatched options *)
        If[Length[badOptions] > 0,
          Join[{InoculationSource},badOptions],
          badOptions
        ]
      ],

    MatchQ[resolvedInoculationSource,AgarStab],
      Module[{badOptions},
        (* Get the mismatched options *)
        badOptions = Map[Function[{symbol},
          Module[{optionValue,optionDefault},

            (* Lookup the option *)
            optionValue = Lookup[roundedInoculateLiquidMediaOptions,symbol];

            (* Lookup the options default *)
            optionDefault = First[Lookup[Cases[optionDefinition,KeyValuePattern["OptionSymbol"->symbol]],"Default"]];

            (* See if the option matches ListableP[ListableP[default]] *)
            If[MatchQ[optionValue,ListableP[ListableP[ReleaseHold[optionDefault] | Null]]],
              Nothing,
              symbol
            ]
          ]
        ],
          Join[$SolidMediaOptionSymbols,$LiquidMediaOptionSymbols]
        ];

        (* Add InoculationSource if there are mismatched options *)
        If[Length[badOptions] > 0,
          Join[{InoculationSource},badOptions],
          badOptions
        ]
      ]
  ];

  If[Length[inoculationSourceOptionMismatchOptions] > 1 && messages,
    Message[Error::InoculationSourceOptionMismatch,resolvedInoculationSource,inoculationSourceOptionMismatchOptions]
  ];

  (* Create a test if we are gathering tests *)
  inoculationSourceOptionMismatchTests = If[gatherTests,
    If[Length[inoculationSourceOptionMismatchOptions] > 0,
      (* If there are failing options *)
      Test["The specified options, " <> ToString[inoculationSourceOptionMismatchOptions] <> " are valid options for the specified InoculationSource:",True,False],

      (* If there are not failing options *)
      Test["The specified options are valid options for the specified InoculationSource:",True,True]
    ],
    Nothing
  ];

  (* Detect if there is any sort of error with InoculationSource - we cannot continue if there is  *)
  inoculationSourceError = Or[
    multipleSourceSampleTypes,
    Length[inoculationSourceInputSampleMismatchInputs] > 0,
    Length[inoculationSourceOptionMismatchOptions] > 1
  ];

  (* Big main switch off of InoculationSource where we will call other option resolvers as necessary *)
  {
    (* Error messages *)
    invalidInstrumentErrors,
    multipleDestinationMediaContainersErrors,
    invalidMixTypeErrors,
    noTipsFoundErrors,
    tipOptionMismatchErrors,
    noPreferredLiquidMediaWarnings,
    invalidDestinationWellErrors,
    mixMismatchErrors,
    tipConnectionMismatchErrors,

    resolvedOptions,
    switchInvalidOptions
  } = Which[
    
    (* Call PickColonies resolver *)
    MatchQ[resolvedInoculationSource,SolidMedia]&&!inoculationSourceError,
      Module[
        {
          pickOptions,solidMediaMapThreadFriendlyOptions,solidMediaInvalidInstrumentErrors,solidMediaMultipleDestinationMediaContainersErrors,solidMediaInvalidMixTypeErrors,
          pickInstrument,pickColonyPickingDepth,pickDestinationFillDirection,pickDestinationMixType,pickMinDiameter,
          pickMaxDiameter, pickMinColonySeparation, pickMinRegularityRatio, pickMaxRegularityRatio, pickMinCircularityRatio,
          pickMaxCircularityRatio,singlePickInstrument,
          allPickOptions,invalidPickOptions,pickOutput,pickTests,numSamples,nonPickOptions,keysToDrop,resolvedPickOptions,solidMediaNoTipsFoundErrors,
          solidMediaTipOptionMismatchErrors, solidMediaNoPreferredLiquidMediaWarnings, solidMediaInvalidDestinationWellErrors, solidMediaMixMismatchErrors,
          solidMediaTipConnectionMismatchErrors
        },

        (* Section: Pre-Process options (any specific defaults that Pick would not normally do) *)

        (* Lookup options to have Pick resolve *)
        pickOptions = Normal@KeyTake[
          roundedInoculateLiquidMediaOptions,
          Join[
            $SolidMediaOptionSymbols,
            {
              DestinationMediaContainer,
              DestinationMix,
              DestinationNumberOfMixes,
              DestinationMedia,
              MediaVolume
            }
          ]
        ];
        
        (* Get mapThreadFriendlyOptions *)
        solidMediaMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentInoculateLiquidMedia,roundedInoculateLiquidMediaOptions];

        (* Do a mapthread to pre-resolve some options and get them into a form that is suitable for ExperimentPickColonies *)
        {
          (* Error Messages *)
          solidMediaInvalidInstrumentErrors,
          solidMediaMultipleDestinationMediaContainersErrors,
          solidMediaInvalidMixTypeErrors,
          
          (* Options *)
          pickInstrument,
          pickColonyPickingDepth,
          pickDestinationMixType,
          pickMinDiameter,
          pickMaxDiameter,
          pickMinColonySeparation,
          pickMinRegularityRatio,
          pickMaxRegularityRatio,
          pickMinCircularityRatio,
          pickMaxCircularityRatio
        }=Transpose[MapThread[
          Function[{sample,mapThreadOptions},
            Module[
              {
                (* Error messages *)
                invalidInstrumentError, invalidMixTypeError, multipleDestinationMediaContainersError,
                
                (* Unresolved options *)
                instrument, colonyPickingDepth, destinationMixType,
                minDiameter,
                maxDiameter,
                minColonySeparation,
                minRegularityRatio,
                maxRegularityRatio,
                minCircularityRatio,
                maxCircularityRatio,
                
                (* Resolved options *)
                resolvedInstrument, resolvedColonyPickingDepth, resolvedDestinationMixType,
                resolvedMinDiameter,
                resolvedMaxDiameter,
                resolvedMinColonySeparation,
                resolvedMinRegularityRatio,
                resolvedMaxRegularityRatio,
                resolvedMinCircularityRatio,
                resolvedMaxCircularityRatio
              },
              
              (* Initialize error tracking variables *)
              {
                invalidInstrumentError,
                invalidMixTypeError,
                multipleDestinationMediaContainersError
              } = ConstantArray[False,3];
              
              (* Lookup the options we need *)
              {
                instrument,
                colonyPickingDepth,
                destinationMixType,
                minDiameter,
                maxDiameter,
                minColonySeparation,
                minRegularityRatio,
                maxRegularityRatio,
                minCircularityRatio,
                maxCircularityRatio
              } = Lookup[mapThreadOptions,
                {
                  Instrument,
                  ColonyPickingDepth,
                  DestinationMixType,
                  MinDiameter,
                  MaxDiameter,
                  MinColonySeparation,
                  MinRegularityRatio,
                  MaxRegularityRatio,
                  MinCircularityRatio,
                  MaxCircularityRatio
                }
              ];
              
              (* Resolve the instrument option *)
              resolvedInstrument = If[MatchQ[instrument,Automatic],
                (* If Instrument is Automatic, resolve it to Model[Instrument, ColonyHandler, "QPix 420 HT"] *)
                Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"],
                (* If it is set, check to make sure it is a ColonyHandler *)
                If[!MatchQ[instrument,ObjectP[{Object[Instrument,ColonyHandler],Model[Instrument,ColonyHandler]}]],
                  invalidInstrumentError = True;
                  instrument,
                  instrument
                ]
              ];

              (* Resolve ColonyPickingDepth - Map because colony picking depth can nested index match with Populations *)
              resolvedColonyPickingDepth = Map[
                Function[If[MatchQ[#,Automatic],
                  (* If colonyPickingDepth is Automatic, resolve it to 2 mm to get it to match an acceptable pattern for PickColonies *)
                  2 Millimeter,
                  (* Otherwise leave it as is *)
                  #
                ]],
                ToList[colonyPickingDepth]
              ];

              (* Check for DestinationMixTypeErrors *)
              resolvedDestinationMixType = Map[
                If[MatchQ[#,Automatic],
                  (* If DestinationMixType is Automatic, resolve it to Shake *)
                  Shake,
                  (* If it is set, and not equal to Shake, mark an error *)
                  If[!MatchQ[#,Shake],
                    invalidMixTypeError = True;
                    #,
                    (* Otherwise just leave as is *)
                    #
                  ]
                ]&,
                ToList[destinationMixType]
              ];

              resolvedMinDiameter = If[MatchQ[minDiameter,Automatic],
                0.5 Millimeter,
                minDiameter
              ];

              resolvedMaxDiameter = If[MatchQ[maxDiameter,Automatic],
                2 Millimeter,
                maxDiameter
              ];

              resolvedMinColonySeparation = If[MatchQ[minColonySeparation,Automatic],
                0.2 Millimeter,
                minColonySeparation
              ];

              resolvedMinRegularityRatio = If[MatchQ[minRegularityRatio,Automatic],
                0.65,
                minRegularityRatio
              ];

              resolvedMaxRegularityRatio = If[MatchQ[maxRegularityRatio,Automatic],
                1.0,
                maxRegularityRatio
              ];

              resolvedMinCircularityRatio = If[MatchQ[minCircularityRatio,Automatic],
                0.65,
                minCircularityRatio
              ];

              resolvedMaxCircularityRatio = If[MatchQ[maxCircularityRatio,Automatic],
                1.0,
                maxCircularityRatio
              ];


              (* Having Multiple DestinationMediaContainers is ok for SolidMedia *)
              multipleDestinationMediaContainersError = False;

              (* Return *)
              {
                (* Errors *)
                invalidInstrumentError,
                multipleDestinationMediaContainersError,
                invalidMixTypeError,

                (* Resolved options *)
                resolvedInstrument,
                resolvedColonyPickingDepth,
                resolvedDestinationMixType,
                resolvedMinDiameter,
                resolvedMaxDiameter,
                resolvedMinColonySeparation,
                resolvedMinRegularityRatio,
                resolvedMaxRegularityRatio,
                resolvedMinCircularityRatio,
                resolvedMaxCircularityRatio
              }
            ]
          ],
          {mySamples,solidMediaMapThreadFriendlyOptions}
        ]];

        (* Get the instrument option in a form that is acceptable for Pick *)
        singlePickInstrument = Which[
          (* If the pickInstrument is not a colony handler, set to Automatic so resolution does not fail *)
          MemberQ[solidMediaInvalidInstrumentErrors,True],
            Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"], (* QPIX *)
          (* Otherwise just take the single colony handler *)
          True,
            First@DeleteDuplicates[pickInstrument]
        ];

        (* Resolve DestinationFillDirection outside the mapthread because it is not index matching *)
        (* Resolve DestinationFillDirection *)
        pickDestinationFillDirection = If[MatchQ[Lookup[roundedInoculateLiquidMediaOptions,DestinationFillDirection],ListableP[Automatic]],
          (* If destinationFillDirection is Automatic, resolve it to Row to get it to match an acceptable pattern for PickColonies *)
          Row,
          (* Otherwise leave it as is *)
          Lookup[roundedInoculateLiquidMediaOptions,DestinationFillDirection]
        ];

        (* Add the options we have already resolved *)
        allPickOptions = ReplaceRule[
          pickOptions,
          {
            Instrument -> singlePickInstrument,
            DestinationMediaType -> LiquidMedia,
            DestinationCoordinates -> Null,
            ColonyPickingDepth -> pickColonyPickingDepth,
            DestinationFillDirection -> pickDestinationFillDirection,
            MinDiameter -> pickMinDiameter,
            MaxDiameter -> pickMaxDiameter,
            MinColonySeparation -> pickMinColonySeparation,
            MinRegularityRatio -> pickMinRegularityRatio,
            MaxRegularityRatio -> pickMaxRegularityRatio,
            MinCircularityRatio -> pickMinCircularityRatio,
            MaxCircularityRatio -> pickMaxCircularityRatio
          }
        ];
        (* Section: Call ExperimentPickColonies muted *)

        (* Initialize a boolean to check if an error was thrown in PickColonies *)
        invalidPickOptions = False;

        (* Call ExperimentPickColonies with the necessary options *)
        {pickOutput,pickTests} = If[gatherTests,
          ExperimentPickColonies[mySamples,Sequence@@allPickOptions,Output->{Options,Tests}],
          {
            Module[{invalidOptionsBool,resolvedOptions},

              (* Run the analysis function to get the resolved options *)
              {resolvedOptions,invalidOptionsBool} = ModifyFunctionMessages[
                ExperimentPickColonies,
                {mySamples},
                "",
                {},
                {Sequence@@allPickOptions,Output -> Options},
                Simulation -> currentSimulation,
                Cache -> combinedCache,
                Output -> {Result, Boolean}
              ];

              (* Set the invalid analysis option boolean if appropriate *)
              If[invalidOptionsBool,
                invalidPickOptions = True
              ];

              (* Return the options *)
              resolvedOptions
            ],
            {}
          }
        ];

        (* Section: Post-Process options (combine newly resolved and those set to Null) and return *)

        (* Get the number of samples to expand to *)
        numSamples = Length[mySamples];
        
        (* Gather the nonPick options and resolve them to Null *)
        nonPickOptions = {
          TransferEnvironment -> ConstantArray[Null,numSamples],
          DestinationMixVolume -> ConstantArray[Null,numSamples],
          Volume -> ConstantArray[Null,numSamples],
          DestinationWell -> ConstantArray[Null,numSamples],
          Tips -> ConstantArray[Null,numSamples],
          TipType -> ConstantArray[Null,numSamples],
          TipMaterial -> ConstantArray[Null,numSamples],
          SourceMix -> ConstantArray[Null,numSamples],
          NumberOfSourceMixes -> ConstantArray[Null,numSamples],
          SourceMixVolume -> ConstantArray[Null,numSamples],
          PipettingMethod -> ConstantArray[Null,numSamples]
        };

        (* Drop a couple options that are defined for PickColonies but not InoculateLiquidMedia *)
        keysToDrop = {DestinationMediaType,DestinationCoordinates,Instrument,SamplesInStorageCondition};
        resolvedPickOptions = Normal@KeyDrop[Association@pickOutput,keysToDrop];

        (* These errors do not apply for SolidMedia *)
        solidMediaNoTipsFoundErrors = ConstantArray[False,numSamples];
        solidMediaTipOptionMismatchErrors = ConstantArray[False,numSamples];
        solidMediaNoPreferredLiquidMediaWarnings = ConstantArray[False,numSamples];
        solidMediaInvalidDestinationWellErrors = ConstantArray[False,numSamples];
        solidMediaMixMismatchErrors = ConstantArray[False,numSamples];
        solidMediaTipConnectionMismatchErrors = ConstantArray[False,numSamples];

        {
          solidMediaInvalidInstrumentErrors,
          solidMediaMultipleDestinationMediaContainersErrors,
          solidMediaInvalidMixTypeErrors,
          solidMediaNoTipsFoundErrors,
          solidMediaTipOptionMismatchErrors,
          solidMediaNoPreferredLiquidMediaWarnings,
          solidMediaInvalidDestinationWellErrors,
          solidMediaMixMismatchErrors,
          solidMediaTipConnectionMismatchErrors,
          Join[
            resolvedPickOptions,
            nonPickOptions,
            {
              DestinationMixType->pickDestinationMixType,
              Instrument->pickInstrument,
              InoculationSource->resolvedInoculationSource,
              Preparation->resolvedPreparation,
              SamplesInStorageCondition -> resolvedSamplesInStorageCondition,
              SamplesOutStorageCondition -> resolvedSamplesOutStorageCondition
            }
          ],
          If[TrueQ[invalidPickOptions],{Populations},{}]
        }
      ],
    
    (* Call Transfer resolver *)
    MatchQ[resolvedInoculationSource,LiquidMedia]&&!inoculationSourceError,
      Module[
        {
          liquidMediaMapThreadFriendlyOptions,
          liquidMediaNoTipsFoundErrors,
          liquidMediaTipOptionMismatchErrors, liquidMediaNoPreferredLiquidMediaWarnings, liquidMediaInvalidDestinationWellErrors, liquidMediaMixMismatchErrors,
          liquidMediaTipConnectionMismatchErrors,
          liquidMediaInvalidInstrumentErrors,liquidMediaMultipleDestinationMediaContainersErrors,liquidMediaInvalidMixTypeErrors,
          preResolvedTransferEnvironments,preResolvedVolumes,preResolvedInstruments,preResolvedDestinationMediaContainers,preResolvedDestinationMixes,
          preResolvedDestinationMixTypes,preResolvedDestinationNumberOfMixes, preResolvedSourceMixes,transferOptions,optionRenamingRules,
          correctlyNamedTransferOptions,invalidTransferOptions,
          destinationsForTransfer,instrumentsForTransfer,transferOutput,transferTests, numSamples,nonTransferOptions,keysToTake,
          resolvedTransferOptions,correctlyNamedResolvedTransferOptions
        },
        
        (* Section: Pre-Process options (any specific defaults that Transfer would not normally do) *)
        (* Preprocess some options ahead of call to Transfer so we default correctly *)
        liquidMediaMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentInoculateLiquidMedia,roundedInoculateLiquidMediaOptions,AmbiguousNestedResolution->IndexMatchingOptionPreferred];

        {
          (* Errors *)
          (* Error Messages *)
          liquidMediaInvalidInstrumentErrors,
          liquidMediaMultipleDestinationMediaContainersErrors,
          liquidMediaInvalidMixTypeErrors,

          (* Pre-resolved options *)
          preResolvedTransferEnvironments,
          preResolvedVolumes,
          preResolvedInstruments,
          preResolvedDestinationMediaContainers,
          preResolvedDestinationMixes,
          preResolvedDestinationMixTypes,
          preResolvedDestinationNumberOfMixes,
          preResolvedSourceMixes
        } = Transpose[MapThread[
          Function[{sample,mapThreadOptions},
            Module[
              {
                (* Error-Tracking *)
                liquidMediaInvalidInstrumentError,liquidMediaMultipleDestinationMediaContainersError,liquidMediaInvalidMixTypeError,

                (* Unresolved Options *)
                transferEnvironment,volume,instrument,destinationMediaContainer,destinationMix,destinationMixType,sourceMix,destinationNumberOfMixes,

                (* Pre-resolved options *)
                preResolvedTransferEnvironment,preResolvedVolume,preResolvedInstrument,unnestedDestinationMediaContainer,
                preResolvedDestinationMediaContainer,preResolvedDestinationMixType,
                preResolvedDestinationNumberOfMixes,preResolvedDestinationMix,preResolvedSourceMix
              },

              (* Set Up error tracking variables *)
              {
                liquidMediaInvalidInstrumentError,
                liquidMediaMultipleDestinationMediaContainersError,
                liquidMediaInvalidMixTypeError
              }=ConstantArray[False,3];

              (* Extract the necessary options *)
              {
                transferEnvironment,
                volume,
                instrument,
                destinationMediaContainer,
                destinationMix,
                destinationMixType,
                destinationNumberOfMixes,
                sourceMix
              } = Lookup[mapThreadOptions,
                {
                  TransferEnvironment,
                  Volume,
                  Instrument,
                  DestinationMediaContainer,
                  DestinationMix,
                  DestinationMixType,
                  DestinationNumberOfMixes,
                  SourceMix
                }
              ];

              (* Pre-Resolve TransferEnvironment *)
              preResolvedTransferEnvironment = If[MatchQ[transferEnvironment,Automatic],
                (* If TransferEnvironment is Automatic, resolve it to the microbial BSC if Preparation is Manual *)
                If[MatchQ[resolvedPreparation,Manual],
                  Model[Instrument, BiosafetyCabinet, "id:WNa4ZjKZpBeL"], (* Model[Instrument, BiosafetyCabinet, "Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Microbial)"] *)

                  (* Otherwise set to Null *)
                  Null
                ],

                (* Otherwise leave it as is *)
                transferEnvironment
              ];
              
              (* Pre-resolve Volume *)
              preResolvedVolume = If[MatchQ[volume,Automatic],
                (* If the option is automatic, resolve it to 1/10th of the volume of the input sample (but no less than 1 Microliter)*)
                Max[
                  1 Microliter,
                  N[fastAssocLookup[combinedFastAssoc,sample,Volume] / 10]
                ],

                (* If the option is set, keep it *)
                volume
              ];

              (* DestinationMediaContainer is nested because of the PickColonies case, remove the nesting here *)
              unnestedDestinationMediaContainer = First[ToList[destinationMediaContainer]];

              (* Pre-resolve DestinationMediaContainer *)
              preResolvedDestinationMediaContainer = If[MatchQ[unnestedDestinationMediaContainer,Automatic],
                (* If DestinationMediaContainer is Automatic, resolve based on the PreferredContainer of the Volume being transferred *)
                If[MatchQ[resolvedPreparation,Manual],
                  (* TODO: Handle case when preferred container does not give a container *)
                  First@ToList[PreferredContainer[preResolvedVolume,Sterile->True]],
                  First@ToList[PreferredContainer[preResolvedVolume,LiquidHandlerCompatible->True,Sterile->True]]
                ],
                (* Otherwise leave it as is *)
                unnestedDestinationMediaContainer
              ];
              (* Check if destination media container is a list of objects (it is only allowed to be a single object or model if InoculationSource is LiquidMedia) *)
              liquidMediaMultipleDestinationMediaContainersError = And[
                MatchQ[destinationMediaContainer,{ObjectP[]..}],
                Length[destinationMediaContainer] > 1
              ];

              (* Pre-resolve Instrument *)
              preResolvedInstrument = If[MatchQ[instrument,Automatic],
                (* If instrument is Automatic, resolve it based on the preparation *)
                If[MatchQ[resolvedPreparation,Robotic],
                  Null,

                  (* Choose the pipette based on the volume being transferred *)
                  Which[
                    LessQ[preResolvedVolume,2 Microliter],
                      Model[Instrument, Pipette, "id:BYDOjvGzwBZD"], (*"Eppendorf Research Plus P2.5, Microbial"*)
                    LessQ[preResolvedVolume,20 Microliter],
                      Model[Instrument, Pipette, "id:kEJ9mqRlbZxV"], (*  "Eppendorf Research Plus P20, Microbial" *)
                    LessQ[preResolvedVolume,200 Microliter],
                      Model[Instrument, Pipette, "id:vXl9j57VBAjN"], (* "Eppendorf Research Plus P200, Microbial" *)
                    LessQ[preResolvedVolume,1000 Microliter],
                      Model[Instrument, Pipette, "id:GmzlKjP3boWe"], (* "Eppendorf Research Plus P1000, Microbial" *)
                    LessQ[preResolvedVolume,5000 Microliter],
                      Model[Instrument, Pipette, "id:qdkmxzqdM4xm"], (* "Eppendorf Research Plus P5000, Microbial" *)
                    True,
                      Model[Instrument, Pipette, "id:4pO6dM51ljY5"] (*"pipetus, Microbial"*)
                  ]
                ],

                (* Otherwise, keep the instrument  *)
                instrument
              ];

              (* Check for invalid instrument *)
              liquidMediaInvalidInstrumentError = Or[
                MatchQ[resolvedPreparation,Robotic]&&!MatchQ[preResolvedInstrument,Null],
                MatchQ[resolvedPreparation,Manual]&&!MatchQ[preResolvedInstrument,ObjectP[{Object[Instrument,Pipette],Model[Instrument,Pipette]}]]
              ];

              (* Pre-resolve DestinationMix (Strip the nested index matching) *)
              preResolvedDestinationMix = First[ToList[destinationMix]];

              (* Pre-resolve DestinationMixType *)
              (* First, strip the nested index matching *)
              destinationMixType = First[ToList[destinationMixType]];
              (* Pre-Resolve *)
              preResolvedDestinationMixType = If[MatchQ[destinationMixType,Automatic],
                (* If DestinationMixType is Automatic, pre resolve it to Pipette if DestinationMix is True or Automatic*)
                If[MatchQ[preResolvedDestinationMix,True|Automatic],
                  Pipette,
                  Automatic
                ],
                (* Otherwise leave it as is *)
                destinationMixType
              ];

              (* Pre-resolve DestinationNumberOfMixes (Strip the nested index matching) *)
              preResolvedDestinationNumberOfMixes = First[ToList[destinationNumberOfMixes]];

              (* There is no MixType error in this case *)
              liquidMediaInvalidMixTypeError = False;

              (* Pre-resolve SourceMix *)
              preResolvedSourceMix = If[MatchQ[sourceMix,Automatic],
                (* If SourceMix is Automatic, pre resolve it to True *)
                True,
                (* Otherwise leave it as is *)
                sourceMix
              ];

              (* Return the pre-resolved options *)
              {
                (* Errors *)
                liquidMediaInvalidInstrumentError,
                liquidMediaMultipleDestinationMediaContainersError,
                liquidMediaInvalidMixTypeError,

                (* Options *)
                preResolvedTransferEnvironment,
                preResolvedVolume,
                preResolvedInstrument,
                preResolvedDestinationMediaContainer,
                preResolvedDestinationMix,
                preResolvedDestinationMixType,
                preResolvedDestinationNumberOfMixes,
                preResolvedSourceMix
              }

            ]
          ],
          {mySamples,liquidMediaMapThreadFriendlyOptions}
        ]];

        (* Create a list of options to send to Transfer *)
        transferOptions = Join[
          Normal@KeyTake[roundedInoculateLiquidMediaOptions,{
            DestinationMixVolume,
            DestinationWell,
            Tips,
            TipType,
            TipMaterial,
            NumberOfSourceMixes,
            SourceMixVolume,
            PipettingMethod
          }],
          {
            TransferEnvironment -> preResolvedTransferEnvironments,
            Instrument -> preResolvedInstruments,
            DestinationMix -> preResolvedDestinationMixes,
            DestinationMixType -> preResolvedDestinationMixTypes,
            DestinationNumberOfMixes -> preResolvedDestinationNumberOfMixes,
            SourceMix -> preResolvedSourceMixes,
            AspirationMixType -> preResolvedSourceMixes/.{True->Pipette,False->Null},
            Preparation -> resolvedPreparation
          }
        ];
        
        (* Create a list of rules to map from the namespace of InoculateLiquidMedia to the namespace of Transfer *)
        optionRenamingRules = {
          DestinationMix -> DispenseMix,
          DestinationMixType -> DispenseMixType,
          DestinationNumberOfMixes -> NumberOfDispenseMixes,
          DestinationMixVolume -> DispenseMixVolume,
          SourceMix -> AspirationMix,
          SourceMixType -> AspirationMixType,
          NumberOfSourceMixes -> NumberOfAspirationMixes,
          SourceMixVolume -> AspirationMixVolume,
          SampleLabel -> SourceLabel,
          SampleContainerLabel -> SourceContainerLabel,
          SampleOutLabel -> DestinationLabel,
          ContainerOutLabel -> DestinationContainerLabel
        };
        
        (* Apply the name swap *)
        correctlyNamedTransferOptions = transferOptions/.optionRenamingRules;

        (* Section: Call ExperimentTransfer muted *)
        (* Initialize a boolean to check if an error was thrown in Transfer *)
        invalidTransferOptions = False;

        (* If we could not preresolve the containers correctly - just use the first given container so Transfer does not crash *)
        destinationsForTransfer = MapThread[
          Function[{container,multipleContainerError},
            Which[
              multipleContainerError,
                container,
              MatchQ[container,_List],
                First[container],
              True,
                container
            ]
          ],
          {
            preResolvedDestinationMediaContainers,
            liquidMediaMultipleDestinationMediaContainersErrors
          }
        ];

        (* If Instrument is not valid, set it to Automatic so Transfer does not crash *)
        instrumentsForTransfer = MapThread[
          Function[{instrument,liquidMediaInvalidInstrumentErrors},
            If[liquidMediaInvalidInstrumentErrors,
              Automatic,
              instrument
            ]
          ],
          {
            preResolvedInstruments,
            liquidMediaInvalidInstrumentErrors
          }
        ];

        (* Call ExperimentTransfer with the necessary options *)
        {transferOutput,transferTests} = If[gatherTests,
          ExperimentTransfer[mySamples,destinationsForTransfer,preResolvedVolumes,Sequence@@ReplaceRule[correctlyNamedTransferOptions,Instrument->instrumentsForTransfer],Output->{Options,Tests}],
          {
            Module[{invalidOptionsBool,resolvedOptions},

              (* Run the analysis function to get the resolved options *)
              {resolvedOptions,invalidOptionsBool} = ModifyFunctionMessages[
                ExperimentTransfer,
                {mySamples,destinationsForTransfer,preResolvedVolumes},
                "",
                {},
                {Sequence@@ReplaceRule[correctlyNamedTransferOptions,Instrument->instrumentsForTransfer], Output -> Options},
                Simulation -> currentSimulation,
                Cache -> combinedCache,
                Output -> {Result, Boolean}
              ];

              (* Set the invalid analysis option boolean if appropriate *)
              If[invalidOptionsBool,
                invalidTransferOptions = True
              ];

              (* Return the options *)
              resolvedOptions
            ],
            {}
          }
        ];
        (* Section: Post-Process options (remap options into InoculateLiquidMedia name space) and return *)

        (* Get the number of samples to expand to *)
        numSamples = Length[mySamples];

        (* Gather the nonTransfer options and resolve them to Null *)
        nonTransferOptions = {
          Populations -> ConstantArray[Null,numSamples],
          MinRegularityRatio -> ConstantArray[Null,numSamples],
          MaxRegularityRatio -> ConstantArray[Null,numSamples],
          MinCircularityRatio -> ConstantArray[Null,numSamples],
          MaxCircularityRatio -> ConstantArray[Null,numSamples],
          MinDiameter -> ConstantArray[Null,numSamples],
          MaxDiameter -> ConstantArray[Null,numSamples],
          MinColonySeparation -> ConstantArray[Null,numSamples],
          ImagingChannels -> ConstantArray[Null,numSamples],
          ExposureTimes -> ConstantArray[Null,numSamples],
          ColonyHandlerHeadCassetteApplication -> ConstantArray[Null,numSamples],
          HeadDiameter -> ConstantArray[Null,numSamples],
          HeadLength -> ConstantArray[Null,numSamples],
          NumberOfHeads -> ConstantArray[Null,numSamples],
          ColonyPickingTool -> ConstantArray[Null,numSamples],
          ColonyPickingDepth -> ConstantArray[Null,numSamples],
          PickCoordinates -> ConstantArray[Null,numSamples],
          DestinationMedia -> ConstantArray[Null,numSamples],
          MediaVolume -> ConstantArray[Null,numSamples],
          DestinationFillDirection -> Null, (* This option is not index matching so its not a list *)
          MaxDestinationNumberOfColumns -> ConstantArray[Null,numSamples],
          MaxDestinationNumberOfRows -> ConstantArray[Null,numSamples],
          PrimaryWash -> ConstantArray[Null,numSamples],
          PrimaryWashSolution -> ConstantArray[Null,numSamples],
          NumberOfPrimaryWashes -> ConstantArray[Null,numSamples],
          PrimaryDryTime -> ConstantArray[Null,numSamples],
          SecondaryWash -> ConstantArray[Null,numSamples],
          SecondaryWashSolution -> ConstantArray[Null,numSamples],
          NumberOfSecondaryWashes -> ConstantArray[Null,numSamples],
          SecondaryDryTime -> ConstantArray[Null,numSamples],
          TertiaryWash -> ConstantArray[Null,numSamples],
          TertiaryWashSolution -> ConstantArray[Null,numSamples],
          NumberOfTertiaryWashes -> ConstantArray[Null,numSamples],
          TertiaryDryTime -> ConstantArray[Null,numSamples],
          QuaternaryWash -> ConstantArray[Null,numSamples],
          QuaternaryWashSolution -> ConstantArray[Null,numSamples],
          NumberOfQuaternaryWashes -> ConstantArray[Null,numSamples],
          QuaternaryDryTime -> ConstantArray[Null,numSamples]
        };

        (* Take the keys that apply from the Transfer output *)
        keysToTake = {
          SourceLabel,
          SourceContainerLabel,
          DestinationLabel,
          DestinationContainerLabel,
          DispenseMix,
          DispenseMixType,
          NumberOfDispenseMixes,
          DispenseMixVolume,
          AspirationMix,
          AspirationMixType,
          NumberOfAspirationMixes,
          AspirationMixVolume,
          DestinationWell,
          Tips,
          TipType,
          TipMaterial,
          PipettingMethod,
          TransferEnvironment,
          Preparation
        };
        resolvedTransferOptions = Normal@KeyTake[Association@transferOutput,keysToTake];

        (* Map the option names back to the inoculate namespace *)
        correctlyNamedResolvedTransferOptions = resolvedTransferOptions /. (Reverse/@optionRenamingRules);

        (* These errors do not apply for liquid media *)
        liquidMediaNoTipsFoundErrors = ConstantArray[False,numSamples];
        liquidMediaTipOptionMismatchErrors = ConstantArray[False,numSamples];
        liquidMediaNoPreferredLiquidMediaWarnings = ConstantArray[False,numSamples];
        liquidMediaInvalidDestinationWellErrors = ConstantArray[False,numSamples];
        liquidMediaMixMismatchErrors = ConstantArray[False,numSamples];
        liquidMediaTipConnectionMismatchErrors = ConstantArray[False,numSamples];

        (* Return *)
        {
          liquidMediaInvalidInstrumentErrors,
          liquidMediaMultipleDestinationMediaContainersErrors,
          liquidMediaInvalidMixTypeErrors,
          liquidMediaNoTipsFoundErrors,
          liquidMediaTipOptionMismatchErrors,
          liquidMediaNoPreferredLiquidMediaWarnings,
          liquidMediaInvalidDestinationWellErrors,
          liquidMediaMixMismatchErrors,
          liquidMediaTipConnectionMismatchErrors,
          Join[
            correctlyNamedResolvedTransferOptions,
            nonTransferOptions,
            {
              Instrument->preResolvedInstruments,
              Volume->preResolvedVolumes,
              DestinationMediaContainer -> If[MemberQ[liquidMediaMultipleDestinationMediaContainersErrors,True],
                Lookup[myOptions, DestinationMediaContainer],
                preResolvedDestinationMediaContainers
              ],
              InoculationSource->resolvedInoculationSource,
              Preparation->resolvedPreparation
            }
          ],
          If[TrueQ[invalidTransferOptions],{Volume},{}]
        }
      ],

    (* Do own resolution *)
    MatchQ[resolvedInoculationSource,AgarStab]&&!inoculationSourceError,
      Module[
        {
          agarStabMapThreadFriendlyOptions,
          
          (* Error tracking variables *)
          agarStabInvalidInstrumentErrors,
          agarStabNoTipsFoundErrors,
          agarStabTipOptionMismatchErrors,
          agarStabNoPreferredLiquidMediaWarnings,
          agarStabInvalidDestinationWellErrors,
          agarStabMixMismatchErrors,
          agarStabTipConnectionMismatchErrors,
          agarStabMultipleDestinationMediaContainersErrors,
          agarStabInvalidMixTypeErrors,
          
          (* Resolved Options *)
          resolvedInstruments,
          resolvedDestinationMediaContainers,
          resolvedDestinationWells,
          resolvedTransferEnvironments,
          resolvedDestinationMixes,
          resolvedDestinationMixTypes,
          resolvedDestinationNumberOfMixes,
          resolvedDestinationMixVolumes,
          resolvedTips,
          resolvedTipTypes,
          resolvedTipMaterials,
          resolvedDestinationMedia,
          resolvedMediaVolumes,
          resolvedSampleLabels,
          resolvedSampleContainerLabels,
          resolvedSampleOutLabels,
          resolvedContainerOutLabels,
          
          (* Gather all optionso *)
          numSamples,nonAgarStabOptions,agarStabOptions
        },

        (* Resolve main options in a mapthread *)
        (* Get mapThreadFriendlyOptions *)
        agarStabMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentInoculateLiquidMedia,roundedInoculateLiquidMediaOptions,AmbiguousNestedResolution->IndexMatchingOptionPreferred];

        {
          (* Error tracking variables *)
          agarStabInvalidInstrumentErrors,
          agarStabMultipleDestinationMediaContainersErrors,
          agarStabNoTipsFoundErrors,
          agarStabTipOptionMismatchErrors,
          agarStabNoPreferredLiquidMediaWarnings,
          agarStabInvalidDestinationWellErrors,
          agarStabMixMismatchErrors,
          agarStabTipConnectionMismatchErrors,
          
          (* Resolved options *)
          resolvedInstruments,
          resolvedDestinationMediaContainers,
          resolvedDestinationWells,
          resolvedTransferEnvironments,
          resolvedDestinationMixes,
          resolvedDestinationMixTypes,
          resolvedDestinationNumberOfMixes,
          resolvedDestinationMixVolumes,
          resolvedTips,
          resolvedTipTypes,
          resolvedTipMaterials,
          resolvedDestinationMedia,
          resolvedMediaVolumes
        } = Transpose[MapThread[
          Function[{mySample,mapThreadOptions},
            Module[
              {
                (* Error-tracking variables *)
                agarStabInvalidInstrumentError,
                agarStabMultipleDestinationMediaContainersError,
                agarStabNoTipsFoundError,
                agarStabTipOptionMismatchError,
                agarStabNoPreferredLiquidMediaWarning,
                agarStabInvalidDestinationWellError,
                agarStabMixMismatchError,
                agarStabTipConnectionMismatchError,
                
                (* Unresolved options *)
                destinationMediaContainer,
                destinationWell,
                instrument,
                transferEnvironment,
                destinationMix,
                destinationMixType,
                destinationNumberOfMixes,
                destinationMixVolume,
                tips,
                tipType,
                tipMaterial,
                destinationMedia,
                mediaVolume,
                
                (* Resolved options *)
                resolvedDestinationMediaContainer,
                resolvedDestinationWell,
                resolvedInstrument,
                resolvedTransferEnvironment,
                resolvedDestinationMix,
                resolvedDestinationMixType,
                resolvedDestinationNumberOfMixes,
                resolvedDestinationMixVolume,
                resolvedTips,
                resolvedTipType,
                resolvedTipMaterial,
                resolvedDestinationMedia,
                resolvedMediaVolume
              },
             
              (* InitializeError tracking variables *)
              {
                agarStabInvalidInstrumentError,
                agarStabMultipleDestinationMediaContainersError,
                agarStabNoTipsFoundError,
                agarStabTipOptionMismatchError,
                agarStabNoPreferredLiquidMediaWarning,
                agarStabInvalidDestinationWellError,
                agarStabMixMismatchError,
                agarStabTipConnectionMismatchError
              } = ConstantArray[False,8];
              
              (* Lookup needed options *)
              {
                destinationMediaContainer,
                destinationWell,
                instrument,
                transferEnvironment,
                destinationMix,
                destinationMixType,
                destinationNumberOfMixes,
                destinationMixVolume,
                tips,
                tipType,
                tipMaterial,
                destinationMedia,
                mediaVolume
              } = Lookup[
                mapThreadOptions,
                {
                  DestinationMediaContainer,
                  DestinationWell,
                  Instrument,
                  TransferEnvironment,
                  DestinationMix,
                  DestinationMixType,
                  DestinationNumberOfMixes,
                  DestinationMixVolume,
                  Tips,
                  TipType,
                  TipMaterial,
                  DestinationMedia,
                  MediaVolume
                }
              ];

              (* Because some of these options are also used in PickColonies, they are NestedIndexMatching. Here, we have no *)
              (* use for the extra nestedness, so strip it from the options that are nested *)
              {
                destinationMix,
                destinationMixType,
                destinationNumberOfMixes,
                destinationMedia,
                mediaVolume
              } = (First[ToList[#]])&/@{
                destinationMix,
                destinationMixType,
                destinationNumberOfMixes,
                destinationMedia,
                mediaVolume
              };

              (* Resolve DestinationMediaContainer *)
              resolvedDestinationMediaContainer = Which[
                (* If destinationMediaContainer is Automatic, use PreferredContainer to get a valid container *)
                MatchQ[destinationMediaContainer,Automatic|{Automatic}],
                  If[MatchQ[mediaVolume,Automatic|{Automatic}],
                    (* If mediaVolume is also Automatic, default to "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap" *)
                    Model[Container, Vessel, "id:AEqRl9KXBDoW"],
                    (* Otherwise use PreferredContainer[mediaVolume] to get a container that fits *)
                    First@ToList[PreferredContainer[mediaVolume,CellType->Microbial]]
                  ],
                
                (* If the option is a list of multiple items, mark an error and take the first *)
                MatchQ[destinationMediaContainer,_List]&&Length[destinationMediaContainer] > 1,
                  Module[{},
                    agarStabMultipleDestinationMediaContainersError = True;
                    First[destinationMediaContainer]
                  ],

                (* If the option is a list of a single option - take the first *)
                MatchQ[destinationMediaContainer,_List] && Length[destinationMediaContainer] == 1,
                  First[destinationMediaContainer],

                (* If the option is already an object - keep it *)
                MatchQ[destinationMediaContainer,ObjectP[{Object[Container],Model[Container]}]],
                  destinationMediaContainer,

                (* Otherwise, default to a dwp so we don't crash *)
                True,
                  Model[Container, Plate, "id:L8kPEjkmLbvW"] (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)

              ];

              (* Resolve DestinationWell *)
              resolvedDestinationWell = If[MatchQ[destinationWell,Automatic],
                (* If destinationWell is Automatic, set to "A1" *)
                (* TODO: Default this to the first open position in the destination container if one exists, if not then just do A1 *)
                "A1",
                (* Otherwise, make sure the specified well is a valid position of resolvedDestinationMediaContainer *)
                Module[{containerPositions},

                  containerPositions = If[MatchQ[resolvedDestinationMediaContainer,ObjectP[Object[Container]]],
                    List@@(fastAssocLookup[combinedFastAssoc,resolvedDestinationMediaContainer,{Model,Positions}][Name]),
                    List@@(fastAssocLookup[combinedFastAssoc,resolvedDestinationMediaContainer,Positions][Name])
                  ];

                  If[MemberQ[containerPositions,destinationWell],
                    destinationWell,
                    agarStabInvalidDestinationWellError = True;
                    destinationWell
                  ]
                ]
              ];

              (* Resolve Instrument and Tips together*)
              {resolvedInstrument,resolvedTips} = If[MatchQ[instrument,Automatic],
                (* If Instrument is Automatic, resolve it and Tips*)
                Which[
                  (* If Tips is specified - Find a pipette instrument that fits the tips *)
                  !MatchQ[tips,ReleaseHold[Lookup[First[Cases[optionDefinition,KeyValuePattern["OptionSymbol"->Tips]]],"Default"]]],
                    Module[{tipConnectionType, connectionTypeLookup},
                      
                      (* Get the connection type of the specified tips *)
                      tipConnectionType = fastAssocLookup[combinedFastAssoc,tips,TipConnectionType];
                      
                      (* Create a lookup from ConnectionType to Instrument *)
                      connectionTypeLookup = {
                        P10 -> Model[Instrument, Pipette, "Eppendorf Research Plus P2.5, Microbial"],
                        P20 -> Model[Instrument, Pipette, "Eppendorf Research Plus P20, Microbial"],
                        P200 -> Model[Instrument, Pipette, "Eppendorf Research Plus P200, Microbial"],
                        P1000 -> Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Microbial"],
                        P5000 -> Model[Instrument, Pipette, "Eppendorf Research Plus P5000, Microbial"],
                        Serological -> Model[Instrument, Pipette, "pipetus, Microbial"]
                      };
                      
                      (* Use the lookup to find the instrument *)
                      {tipConnectionType/.connectionTypeLookup,tips}
                      
                    ],
                  
                  (* If either TipMaterial or TipType is set - if they are try to choose a pipette that works with them *)
                  Or[
                    !MatchQ[tipMaterial,ReleaseHold[Lookup[First[Cases[optionDefinition,KeyValuePattern["OptionSymbol"->TipMaterial]]],"Default"]]],
                    !MatchQ[tipType,ReleaseHold[Lookup[First[Cases[optionDefinition,KeyValuePattern["OptionSymbol"->TipType]]],"Default"]]]
                  ],
                    Module[
                      {
                        partiallyResolvedTipMaterial,
                        partiallyResolvedTipType,
                        possibleTips,
                        sampleContainerModelPacket,
                        sampleVolume,
                        destinationMediaContainerPacket,
                        tipPackets,
                        tipsCanTouchSampleQ,
                        tipsCanTouchDestinationBottomQ,
                        validTips,
                        tipsToChoose,
                        chosenTipsConnectionType,
                        tipConnectionTypeLookup
                      },

                    (* Partially resolve the tip options so we can pass them to TransferDevices *)
                    partiallyResolvedTipMaterial = If[MatchQ[tipMaterial,Automatic],
                      (* If tipMaterial is Automatic, set it to All *)
                      All,
                      (* otherwise leave it as is *)
                      tipMaterial
                    ];

                    partiallyResolvedTipType = If[MatchQ[tipType,Automatic],
                      (* If tipType is Automatic, set it to All *)
                      All,
                      (* otherwise leave it as is *)
                      tipType
                    ];

                    (* If tips is not set, call TransferDevices to get valid tip models that match the tip material and tip type *)
                    possibleTips = If[MatchQ[tips,Automatic],
                      TransferDevices[
                        Model[Item,Tips],
                        All,
                        TipMaterial -> partiallyResolvedTipMaterial,
                        TipType -> partiallyResolvedTipType,
                        Sterile -> True,
                        CultureHandling -> Microbial
                      ][[All,1]],
                      (* Otherwise leave Tips as is *)
                      tips
                    ];

                    (* If there are no possible tips, mark an error and return early *)
                    If[Length[possibleTips] == 0,
                      agarStabNoTipsFoundError = True;
                      {Null,Null},

                      (* If there are tips, see if they are going to fit in the source and destination containers *)
                      (* Get the information we need for tipsCanAspirateQ *)
                      (* Get the sample container packet *)
                      sampleContainerModelPacket = fetchPacketFromCache[fastAssocLookup[combinedFastAssoc,mySample,{Container,Model}],flattenedCachePackets];

                      (* Get the source Volume *)
                      sampleVolume = If[MatchQ[fastAssocLookup[combinedFastAssoc,mySample,Volume],VolumeP],
                        fastAssocLookup[combinedFastAssoc,mySample,Volume],
                        (* Otherwise look up the mass and use the density of Agar to calculate volume *)
                        fastAssocLookup[combinedFastAssoc,mySample,Mass] / (1.033 Gram / Milliliter) (* Density of Model[Molecule,Agarose] *)
                      ];

                      (* Get the destination packet *)
                      destinationMediaContainerPacket = If[MatchQ[resolvedDestinationMediaContainer,ObjectP[Model[Container]]],
                        fetchPacketFromCache[resolvedDestinationMediaContainer,combinedCache],
                        fetchPacketFromCache[Download[fastAssocLookup[combinedFastAssoc,resolvedDestinationMediaContainer,Model],Object],combinedCache]
                      ];

                      (* Get all the possible tip packets *)
                      tipPackets = fetchPacketFromCache[#,combinedCache]&/@possibleTips;

                      (* See if the tips can "aspirate" from the source and "dispense" into the destination *)
                      tipsCanTouchSampleQ = (Experiment`Private`tipsCanAspirateQ[
                        (* Tip Object *)
                        Lookup[#,Object],
                        (* Contianer of interest Packet *)
                        sampleContainerModelPacket,
                        (* We just need to touch the top of the sample *)
                        sampleVolume,
                        (* We are "aspirating" 0 volume - just need to touch the top *)
                        0 Milliliter,
                        (* Tip Packet *)
                        {#},
                        (* Volume calibration packet *)
                        {}
                      ])&/@tipPackets;

                      tipsCanTouchDestinationBottomQ = (Experiment`Private`tipsCanAspirateQ[
                        (* Tip Object *)
                        Lookup[#,Object],
                        (* Container of interest Packet *)
                        destinationMediaContainerPacket,
                        (* We always want to be able to touch the bottom of the container *)
                        0 Milliliter,
                        (* We are "aspirating" 0 volume - just need to touch the top *)
                        0 Milliliter,
                        (* Tip packet *)
                        {#},
                        (* Volume calibration packet *)
                        {}
                      ])&/@tipPackets;

                      (* Filter the possibleTips *)
                      validTips = PickList[possibleTips,Transpose[{tipsCanTouchSampleQ,tipsCanTouchDestinationBottomQ}],{True,True}];
                      (* If there are no valid tips - mark an error and return *)
                      If[Length[validTips] == 0,
                        agarStabNoTipsFoundError = True;
                        {Null,Null},

                        (* If there are valid tips left, choose the smallest (first) one *)
                        tipsToChoose = First[validTips];

                        (* Find the microbial pipette that fits the chosen tips *)
                        chosenTipsConnectionType = fastAssocLookup[combinedFastAssoc,tipsToChoose,TipConnectionType];

                        (* Define connectionType Lookup table *)
                        tipConnectionTypeLookup = {
                          P10 -> Model[Instrument, Pipette, "Eppendorf Research Plus P2.5, Microbial"],
                          P20 -> Model[Instrument, Pipette, "Eppendorf Research Plus P20, Microbial"],
                          P200 -> Model[Instrument, Pipette, "Eppendorf Research Plus P200, Microbial"],
                          P1000 -> Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Microbial"],
                          P5000 -> Model[Instrument, Pipette, "Eppendorf Research Plus P5000, Microbial"],
                          Serological -> Model[Instrument, Pipette, "pipetus, Microbial"]
                        };

                        (* Lookup the pipette model to use *)
                        {tipConnectionTypeLookup /. chosenTipsConnectionType,tipsToChoose}
                      ]
                    ]
                  ],

                  (* If none of the tip options are set, try to use the P1000 pipette and then a serological pipette *)
                  True,
                    Module[
                    {
                      sampleContainerModelPacket, sampleVolume, destinationMediaContainerPacket,
                      p1000Packet,p1000CanTouchSampleQ,p1000CanTouchDestinationBottomQ,
                      serologicalTipModel,serologicalPacket,serologicalCanTouchSampleQ,serologicalCanTouchDestinationBottomQ
                    },

                    (* Get the information we need for tipsCanAspirateQ *)
                    (* Get the sample container packet *)
                    sampleContainerModelPacket = fetchPacketFromCache[fastAssocLookup[combinedFastAssoc,mySample,{Container,Model}],combinedCache];

                    (* Get the source Volume *)
                    sampleVolume = If[MatchQ[fastAssocLookup[combinedFastAssoc,mySample,Volume],VolumeP],
                      fastAssocLookup[combinedFastAssoc,mySample,Volume],
                      (* Otherwise look up the mass and use the density of Agar to calculate volume *)
                      fastAssocLookup[combinedFastAssoc,mySample,Mass] / (1.033 Gram / Milliliter) (* Density of Model[Molecule,Agarose] *)
                    ];

                    (* Get the destination packet *)
                    destinationMediaContainerPacket = If[MatchQ[resolvedDestinationMediaContainer,ObjectP[Model[Container]]],
                      fetchPacketFromCache[resolvedDestinationMediaContainer,combinedCache],
                      fetchPacketFromCache[Download[fastAssocLookup[combinedFastAssoc,resolvedDestinationMediaContainer,Model],Object],combinedCache]
                    ];

                    (* Get all the possible tip packets *)
                    p1000Packet = fetchPacketFromCache[Model[Item, Tips, "id:n0k9mGzRaaN3"],combinedCache]; (* Model[Item, Tips, "1000 uL reach tips, sterile"] *)

                    (* See if the tips can "aspirate" from the source and "dispense" into the destination *)
                    p1000CanTouchSampleQ = Experiment`Private`tipsCanAspirateQ[
                      (* Tip Object *)
                      Model[Item, Tips, "id:n0k9mGzRaaN3"],(* Model[Item, Tips, "1000 uL reach tips, sterile"] *)
                      (* Contianer of interest Packet *)
                      sampleContainerModelPacket,
                      (* We just need to touch the top of the sample *)
                      sampleVolume,
                      (* We are "aspirating" 0 volume - just need to touch the top *)
                      0 Milliliter,
                      (* Tip Packet *)
                      {p1000Packet},
                      (* Volume calibration packet *)
                      {}
                    ];

                    p1000CanTouchDestinationBottomQ = Experiment`Private`tipsCanAspirateQ[
                      (* Tip Object *)
                      Model[Item, Tips, "id:n0k9mGzRaaN3"], (* Model[Item, Tips, "1000 uL reach tips, sterile"] *)
                      (* Container of interest Packet *)
                      destinationMediaContainerPacket,
                      (* We always want to be able to touch the bottom of the container *)
                      0 Milliliter,
                      (* We are "aspirating" 0 volume - just need to touch the top *)
                      0 Milliliter,
                      (* Tip packet *)
                      {p1000Packet},
                      (* Volume calibration packet *)
                      {}
                    ];

                    (* If the P1000 works, use it! *)
                    If[MatchQ[{p1000CanTouchSampleQ,p1000CanTouchDestinationBottomQ},{True,True}],

                      {
                        Model[Instrument, Pipette, "id:GmzlKjP3boWe"], (* Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Microbial"] *)
                        Model[Item, Tips, "id:n0k9mGzRaaN3"] (* Model[Item, Tips, "1000 uL reach tips, sterile"] *)
                      },
                      
                      (* Otherwise check a serological pipette  *)
                      serologicalTipModel = Model[Item, Tips, "id:WNa4ZjRr5ljD"]; (* Model[Item, Tips, "1 mL glass barrier serological pipets, sterile"] *)

                      (* Get all the possible tip packets *)
                      serologicalPacket = fetchPacketFromCache[serologicalTipModel,combinedCache];

                      (* See if the tips can "aspirate" from the source and "dispense" into the destination *)
                      serologicalCanTouchSampleQ = Experiment`Private`tipsCanAspirateQ[
                        (* Tip Object *)
                        serologicalTipModel,
                        (* Contianer of interest Packet *)
                        sampleContainerModelPacket,
                        (* We just need to touch the top of the sample *)
                        sampleVolume,
                        (* We are "aspirating" 0 volume - just need to touch the top *)
                        0 Milliliter,
                        (* Tip Packet *)
                        {serologicalPacket},
                        (* Volume calibration packet *)
                        {}
                      ];

                      serologicalCanTouchDestinationBottomQ = Experiment`Private`tipsCanAspirateQ[
                        (* Tip Object *)
                        serologicalTipModel,
                        (* Container of interest Packet *)
                        destinationMediaContainerPacket,
                        (* We always want to be able to touch the bottom of the container *)
                        0 Milliliter,
                        (* We are "aspirating" 0 volume - just need to touch the top *)
                        0 Milliliter,
                        (* Tip packet *)
                        {serologicalPacket},
                        (* Volume calibration packet *)
                        {}
                      ];

                      (* If the serological will work, use it *)
                      If[And[serologicalCanTouchSampleQ,serologicalCanTouchDestinationBottomQ],
                        {
                          Model[Instrument, Pipette, "id:4pO6dM51ljY5"], (* Model[Instrument, Pipette, "pipetus, Microbial"] *)
                          Model[Item, Tips, "id:n0k9mGzRaaN3"] (* Model[Item, Tips, "1000 uL reach tips, sterile"] *)
                        },
                        (* Otherwise, mark an error and return Null *)
                        Module[{},
                          agarStabNoTipsFoundError = True;
                          {Null,Null}
                        ]
                      ]
                    ]
                  ]
                ],
                
                (* If Instrument is not Automatic keep it and resolve Tips *)
                Which[
                  (* If Tips is specified *)
                  !MatchQ[tips,ReleaseHold[Lookup[First[Cases[optionDefinition,KeyValuePattern["OptionSymbol"->Tips]]],"Default"]]],
                    (* If the instrument is a pipette *)
                    If[MatchQ[instrument,ObjectP[{Object[Instrument,Pipette],Model[Instrument,Pipette]}]],
                      (* See if the connection types match *)
                      Module[
                        {
                          tipConnectionType,pipetteConnectionType
                        },
                        (* Get the tips connection type *)
                        tipConnectionType = If[MatchQ[tips,ObjectP[Model[Item,Tips]]],
                          fastAssocLookup[combinedFastAssoc,tips,TipConnectionType],
                          fastAssocLookup[combinedFastAssoc,tips,{Model,TipConnectionType}]
                        ];

                        (* Get the pipette connection type  *)
                        pipetteConnectionType = If[MatchQ[instrument,ObjectP[Model[Instrument,Pipette]]],
                          fastAssocLookup[combinedFastAssoc,instrument,TipConnectionType],
                          fastAssocLookup[combinedFastAssoc,instrument,{Model,TipConnectionType}]
                        ];

                        (* Mark an error if the connection types do not match *)
                        If[!MatchQ[tipConnectionType,pipetteConnectionType],
                          agarStabTipConnectionMismatchError = True;
                          {instrument,tips},
                          {instrument,tips}
                        ]
                      ],

                      (* Otherwise mark an invalid instrument error and return *)
                      agarStabInvalidInstrumentError = True;
                      {instrument,tips}
                    ],

                  
                  (* Otherwise, try to find Tips that fit all the specifications *)
                  True,
                    Module[
                      {
                        pipetteConnectionType,partiallyResolvedTipMaterial,partiallyResolvedTipType,possibleTips,
                        sampleContainerModelPacket,sampleVolume,destinationMediaContainerPacket,tipPackets,
                        tipsCanTouchSampleQ,tipsCanTouchDestinationBottomQ,validTips
                      },

                      (* Get the connection type from the pipette *)
                      pipetteConnectionType = Which[
                        (* If the pipette is a model, directly look up the connection type *)
                        MatchQ[instrument,ObjectP[Model[Instrument,Pipette]]],
                          fastAssocLookup[combinedFastAssoc,instrument,TipConnectionType],

                        (* If the pipette is an object, look up the connection type through the model *)
                        MatchQ[instrument,ObjectP[Object[Instrument,Pipette]]],
                          fastAssocLookup[combinedFastAssoc,instrument,{Model,TipConnectionType}],

                        (* Otherwise, mark an invalid instrument error and return the instrument *)
                        True,
                          agarStabInvalidInstrumentError = True;
                          Null
                      ];

                      (* Partially resolve the tip options so we can pass them to TransferDevices *)
                      partiallyResolvedTipMaterial = If[MatchQ[tipMaterial,Automatic],
                        (* If tipMaterial is Automatic, set it to All *)
                        All,
                        (* otherwise leave it as is *)
                        tipMaterial
                      ];

                      partiallyResolvedTipType = If[MatchQ[tipType,Automatic],
                        (* If tipType is Automatic, set it to All *)
                        All,
                        (* otherwise leave it as is *)
                        tipType
                      ];

                      (* Get possible tips that work with the instrument *)
                      possibleTips = If[!agarStabInvalidInstrumentError,
                        TransferDevices[
                          Model[Item,Tips],
                          All,
                          TipMaterial -> partiallyResolvedTipMaterial,
                          TipType -> partiallyResolvedTipType,
                          TipConnectionType -> pipetteConnectionType,
                          Sterile -> True,
                          CultureHandling -> Microbial
                        ][[All,1]],
                        TransferDevices[
                          Model[Item,Tips],
                          All,
                          TipMaterial -> partiallyResolvedTipMaterial,
                          TipType -> partiallyResolvedTipType,
                          Sterile -> True,
                          CultureHandling -> Microbial
                        ][[All,1]]
                      ];

                      (* If there are no possible tips, mark an error and return *)
                      If[Length[possibleTips]==0,
                        agarStabNoTipsFoundError = True;
                        {instrument,Null},

                        (* Otherwise, find which tips can "aspirate" and "dispense" at the needed locations *)
                        (* Get the information we need for tipsCanAspirateQ *)
                        (* Get the sample container packet *)
                        sampleContainerModelPacket = fetchPacketFromCache[fastAssocLookup[combinedFastAssoc,mySample,{Container,Model}],flattenedCachePackets];

                        (* Get the source Volume *)
                        sampleVolume = If[MatchQ[fastAssocLookup[combinedFastAssoc,mySample,Volume],VolumeP],
                          fastAssocLookup[combinedFastAssoc,mySample,Volume],
                          (* Otherwise look up the mass and use the density of Agar to calculate volume *)
                          fastAssocLookup[combinedFastAssoc,mySample,Mass] / (1.033 Gram / Milliliter) (* Density of Model[Molecule,Agarose] *)
                        ];

                        (* Get the destination packet *)
                        destinationMediaContainerPacket = If[MatchQ[resolvedDestinationMediaContainer,ObjectP[Model[Container]]],
                          fetchPacketFromCache[resolvedDestinationMediaContainer,combinedCache],
                          fetchPacketFromCache[Download[fastAssocLookup[combinedFastAssoc,resolvedDestinationMediaContainer,Model],Object],combinedCache]
                        ];

                        (* Get all the possible tip packets *)
                        tipPackets = fetchPacketFromCache[#,combinedCache]&/@possibleTips;

                        (* See if the tips can "aspirate" from the source and "dispense" into the destination *)
                        tipsCanTouchSampleQ = (Experiment`Private`tipsCanAspirateQ[
                          (* Tip Object *)
                          Lookup[#,Object],
                          (* Contianer of interest Packet *)
                          sampleContainerModelPacket,
                          (* We just need to touch the top of the sample *)
                          sampleVolume,
                          (* We are "aspirating" 0 volume - just need to touch the top *)
                          0 Milliliter,
                          (* Tip Packet *)
                          {#},
                          (* Volume calibration packet *)
                          {}
                        ])&/@tipPackets;

                        tipsCanTouchDestinationBottomQ = (Experiment`Private`tipsCanAspirateQ[
                          (* Tip Object *)
                          Lookup[#,Object],
                          (* Container of interest Packet *)
                          destinationMediaContainerPacket,
                          (* We always want to be able to touch the bottom of the container *)
                          0 Milliliter,
                          (* We are "aspirating" 0 volume - just need to touch the top *)
                          0 Milliliter,
                          (* Tip packet *)
                          {#},
                          (* Volume calibration packet *)
                          {}
                        ])&/@tipPackets;

                        (* Filter the possibleTips *)
                        validTips = PickList[possibleTips,Transpose[{tipsCanTouchSampleQ,tipsCanTouchDestinationBottomQ}],{True,True}];

                        (* If there are valid tips, return the first one *)
                        If[Length[validTips] > 0,
                          {instrument,First[validTips]},
                          (* Otherwise, mark an error and return Null *)
                          agarStabNoTipsFoundError = True;
                          {instrument,Null}
                        ]
                      ]
                    ]
                ]
              ];
              
              (* Resolve TipMaterial *)
              resolvedTipMaterial = If[MatchQ[tipMaterial,Automatic],
                (* If tipMaterial is Automatic, look it up from the resolved tips *)
                If[!NullQ[resolvedTips],
                  fastAssocLookup[combinedFastAssoc,resolvedTips,Material],
                  Null
                ],
                (* Otherwise, check for conflict error *)
                If[!NullQ[resolvedTips]&&!MatchQ[tipMaterial,fastAssocLookup[combinedFastAssoc,resolvedTips,Material]],
                  agarStabTipOptionMismatchError = True;
                  tipMaterial,
                  tipMaterial
                ]                
              ];

              (* Resolve TipType *)
              resolvedTipType = Module[{resolvedTipsAllTipTypes,resolvedTipsTipType},
                (* Get all of the tip types from the resolved tips *)
                resolvedTipsAllTipTypes = Which[
                  (* If we did not find any tips resolve to Null *)
                  NullQ[resolvedTips],{},

                  (* If the tips is an object *)
                  MatchQ[resolvedTips,ObjectP[Object[Item,Tips]]],
                    (* Find the first type of tips in the downloaded model information *)
                  PickList[
                    {WideBore, Aspirator, Filtered, GelLoading},
                    (fastAssocLookup[combinedFastAssoc, resolvedTips, {Model,#}])&/@ {WideBore, Aspirator, Filtered, GelLoading}
                  ],

                  (* If the tips are a model *)
                  True,
                    (* Find the first type of tips in the downloaded info *)
                  PickList[
                    {WideBore, Aspirator, Filtered, GelLoading},
                    (fastAssocLookup[combinedFastAssoc, resolvedTips, #])&/@ {WideBore, Aspirator, Filtered, GelLoading}
                  ]
                ] /. {Filtered -> Barrier};

                (* Isolate a single tip type to use *)
                resolvedTipsTipType = If[NullQ[resolvedTips],
                  Null,
                  FirstCase[resolvedTipsAllTipTypes,_Symbol,Normal]
                ] ;

                Which[
                  (* If the specified tip type is Automatic, resolve to the resolvedTipsTipType *)
                  MatchQ[tipType, Automatic],
                    resolvedTipsTipType,

                  (* If the specified tip type is not a member of the resolved tip types, mark an error *)
                  !MemberQ[resolvedTipsAllTipTypes, tipType],
                    Module[{},
                      agarStabTipOptionMismatchError = True;
                      tipType
                    ],

                  (* Otherwise, we are good! keep the specified tip type *)
                  True,
                    tipType
                ]
              ];

              (* Resolve TransferEnvironment *)
              resolvedTransferEnvironment = If[MatchQ[transferEnvironment,Automatic],
                (* If transferEnvironment is Automatic, set it to the microbial BSC *)
                Model[Instrument, BiosafetyCabinet, "id:WNa4ZjKZpBeL"], (* Model[Instrument, BiosafetyCabinet, "Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Microbial)"] *)
                (* Otherwise leave it as is *)
                transferEnvironment
              ];
              
              (* Resolve DestinationMedia *)
              resolvedDestinationMedia = If[MatchQ[destinationMedia,Automatic],
                (* If DestinationMedia is Automatic, set to the PreferredLiquidMedia of the first model cell in the input sample if it exists, otherwise default to Model[Sample, "Nutrient Broth"] *)
                Module[{modelCell,preferredLiquidMedia},

                  (* Get the first model cell in the composition *)
                  modelCell = Download[FirstCase[fastAssocLookup[combinedFastAssoc,mySample,Composition][[All,2]],ObjectP[Model[Cell]],Null],Object];
                  preferredLiquidMedia = Download[fastAssocLookup[combinedFastAssoc,modelCell,PreferredLiquidMedia],Object];
                  (* Get the PreferredLiquidMedia *)
                  If[NullQ[modelCell],
                    agarStabNoPreferredLiquidMediaWarning = True;
                    Model[Sample, "id:Y0lXejMdBNRE"], (* Model[Sample, "Nutrient Broth"] *)
                    If[NullQ[preferredLiquidMedia],
                      agarStabNoPreferredLiquidMediaWarning = True;
                      Model[Sample, "id:Y0lXejMdBNRE"], (* Model[Sample, "Nutrient Broth"] *)
                      preferredLiquidMedia
                    ]
                  ]
                ],
                (* Otherwise leave the media as is *)
                destinationMedia
              ];

              (* Resolve MediaVolume *)
              resolvedMediaVolume = If[MatchQ[mediaVolume,Automatic],
                (* If MediaVolume is Automatic, set based on the type of container *)
                Switch[resolvedDestinationMediaContainer,
                  (* If its a plate, take the recommended fill volume *)
                  ObjectP[{Object[Container,Plate],Model[Container,Plate]}],
                    fastAssocLookup[combinedFastAssoc,resolvedDestinationMediaContainer,RecommendedFillVolume],
                  (* Otherwise, take 40% of the MaxVolume of the DestinationMediaContainer *)
                  ObjectP[Object[Container]],
                    fastAssocLookup[combinedFastAssoc,resolvedDestinationMediaContainer,{Model,MaxVolume}]*0.4,
                  ObjectP[Model[Container]],
                    fastAssocLookup[combinedFastAssoc,resolvedDestinationMediaContainer,MaxVolume]*0.4
                ],

                (* Otherwise leave the option as is *)
                mediaVolume
              ];

              (* Resolve DestinationMix *)
              resolvedDestinationMix = If[MatchQ[destinationMix,Automatic],
                (* If DestinationMix is Automatic, resolve it to True *)
                True,
                (* Otherwise leave it as is *)
                destinationMix
              ];

              (* Resolve DestinationMixType *)
              resolvedDestinationMixType = If[MatchQ[destinationMixType,Automatic],
                (* If DestinationMixType is automatic, set to Pipette if DestinationMix is turned on *)
                If[MatchQ[resolvedDestinationMix,True],
                  Pipette,
                  Null
                ],
                (* If it is set, check for a mismatch with resolvedDestinationMix *)
                If[MatchQ[resolvedDestinationMix,True]&&NullQ[destinationMixType],
                  agarStabMixMismatchError = True;
                  destinationMixType,
                  destinationMixType
                ]
              ];

              (* Resolve DestinationNumberOfMixes *)
              resolvedDestinationNumberOfMixes = If[MatchQ[destinationNumberOfMixes,Automatic],
                (* If destinationNumberOfMixes is Automatic, resolve to 10 if resolvedDestinationMix is True, otherwise Null *)
                If[MatchQ[resolvedDestinationMix,True],
                  10,
                  Null
                ],
                (* If it is set, check for a mismatch with resolvedDestinationMix *)
                If[MatchQ[resolvedDestinationMix,True]&&NullQ[destinationNumberOfMixes],
                  agarStabMixMismatchError = True;
                  destinationNumberOfMixes,
                  destinationNumberOfMixes
                ]
              ];

              (* Resolve DestinationMixVolume *)
              resolvedDestinationMixVolume = If[MatchQ[destinationMixVolume,Automatic],
                (* If destinationMixVolume is Automatic, resolve to the minimum of half of the media volume and the max tip volume if resolvedDestinationMix is True, otherwise set to Null *)
                If[MatchQ[resolvedDestinationMix,True],
                  Min[
                    N[resolvedMediaVolume/2],
                    If[NullQ[resolvedTips],
                      50 Milliliter, (* 50 mL is the max pipette volume we have *)
                      fastAssocLookup[combinedFastAssoc,resolvedTips,MaxVolume]
                    ]
                  ],
                  Null
                ],
                (* If it is set, check for a mismatch with resolvedDestinationMix *)
                If[MatchQ[resolvedDestinationMix,True]&&NullQ[destinationMixVolume],
                  agarStabMixMismatchError = True;
                  destinationMixVolume,
                  destinationMixVolume
                ]
              ];

              (* Return necessary values *)
              {
                (* Error tracking variables *)
                agarStabInvalidInstrumentError,
                agarStabMultipleDestinationMediaContainersError,
                agarStabNoTipsFoundError,
                agarStabTipOptionMismatchError,
                agarStabNoPreferredLiquidMediaWarning,
                agarStabInvalidDestinationWellError,
                agarStabMixMismatchError,
                agarStabTipConnectionMismatchError,

                (* Resolved options *)
                resolvedInstrument,
                resolvedDestinationMediaContainer,
                resolvedDestinationWell,
                resolvedTransferEnvironment,
                resolvedDestinationMix,
                resolvedDestinationMixType,
                resolvedDestinationNumberOfMixes,
                resolvedDestinationMixVolume,
                resolvedTips,
                resolvedTipType,
                resolvedTipMaterial,
                resolvedDestinationMedia,
                resolvedMediaVolume
              }
            ]
          ],
          {mySamples,agarStabMapThreadFriendlyOptions}
        ]];

        (* Resolve SampleLabel *)
        resolvedSampleLabels=Module[{uniqueSamples,sampleLabelLookup},
          (* get the unique samples in *)
          uniqueSamples=DeleteDuplicates[mySamples];

          (* create a lookup of unique sample to label *)
          sampleLabelLookup=(#->CreateUniqueLabel["ExperimentInoculateLiquidMedia" <> " Sample"])&/@uniqueSamples;

          (* replace samples with their label *)
          mySamples/.sample:ObjectP[Object[Sample]]:>Lookup[sampleLabelLookup,sample]
        ];

        (* Resolve SampleContainerLabel *)
        resolvedSampleContainerLabels=Module[{uniqueSamples,sampleContainerLookup,containerLabelLookup},

          (* get the unique samples in containers *)
          uniqueSamples=DeleteDuplicates[mySamples];

          (* create a lookup of sample to container *)
          sampleContainerLookup=(#->Download[fastAssocLookup[combinedFastAssoc,#,Container],Object])&/@uniqueSamples;

          (* create a lookup of container to label *)
          containerLabelLookup=(#->CreateUniqueLabel["ExperimentInoculateLiquidMedia" <> " SampleContainer"])&/@Values[sampleContainerLookup];

          (* replace samples with their container's label *)
          mySamples/.sample:ObjectP[Object[Sample]]:>Lookup[containerLabelLookup,Lookup[sampleContainerLookup,sample]]
        ];

        (* If sampleOutLabels is Automatic, resolve it *)
        resolvedSampleOutLabels=Map[
          Function[{sampleOutLabel},
            If[
              (* If the given label is not automatic, leave it alone *)
              MatchQ[sampleOutLabel,Except[Automatic]],
              sampleOutLabel,

              (* Otherwise create a label *)
              CreateUniqueLabel["ExperimentInoculateLiquidMedia Sample Out"]
            ]
          ],
          Lookup[roundedInoculateLiquidMediaOptions,SampleOutLabel]
        ];

        (* Resolve ContainerOutLabel *)
        resolvedContainerOutLabels=Module[{containerOutObjectLookup},

          (* Define a unique container out object lookup *)
          (* NOTE: Has the structure <|Object -> Label|> *)
          containerOutObjectLookup = <||>;

          (* Loop over the resolved containers and dilution strategies *)
          MapThread[
            Function[{containerOutLabel, destinationContainer},
              If[
                (* If the given label is not automatic, leave it alone *)
                MatchQ[containerOutLabel,Except[Automatic]],
                Module[{},
                  (* If the container is an object add it to the lookup *)
                  If[MatchQ[destinationContainer,ObjectP[Object[Container]]],
                    containerOutObjectLookup[destinationContainer] = containerOutLabel
                  ];

                  (* Return the given label *)
                  containerOutLabel
                ],

                (* If it is automatic, create a label *)
                Module[{label},

                  (* Create or find the new label *)
                  label = If[!NullQ[Lookup[containerOutObjectLookup,destinationContainer,Null]],
                    Lookup[containerOutObjectLookup,destinationContainer,Null],
                    CreateUniqueLabel["ExperimentInoculateLiquidMedia Container Out"]
                  ];

                  (* If the container is an object add it to the lookup *)
                  If[MatchQ[destinationContainer,ObjectP[Object[Container]]],
                    containerOutObjectLookup[destinationContainer] = label
                  ];

                  (* Return the label *)
                  label
                ]
              ]
            ],
            {
              Lookup[roundedInoculateLiquidMediaOptions,ContainerOutLabel],
              resolvedDestinationMediaContainers
            }
          ]
        ];

        (* Get the number of samples *)
        numSamples = Length[mySamples];
        
        (* Gather all non AgarStab options and return *)
        nonAgarStabOptions = {
          Populations -> ConstantArray[Null,numSamples],
          MinRegularityRatio -> ConstantArray[Null,numSamples],
          MaxRegularityRatio -> ConstantArray[Null,numSamples],
          MinCircularityRatio -> ConstantArray[Null,numSamples],
          MaxCircularityRatio -> ConstantArray[Null,numSamples],
          MinDiameter -> ConstantArray[Null,numSamples],
          MaxDiameter -> ConstantArray[Null,numSamples],
          MinColonySeparation -> ConstantArray[Null,numSamples],
          ImagingChannels -> ConstantArray[Null,numSamples],
          ExposureTimes -> ConstantArray[Null,numSamples],
          ColonyHandlerHeadCassetteApplication -> ConstantArray[Null,numSamples],
          HeadDiameter -> ConstantArray[Null,numSamples],
          HeadLength -> ConstantArray[Null,numSamples],
          NumberOfHeads -> ConstantArray[Null,numSamples],
          ColonyPickingTool -> ConstantArray[Null,numSamples],
          ColonyPickingDepth -> ConstantArray[Null,numSamples],
          PickCoordinates -> ConstantArray[Null,numSamples],
          DestinationFillDirection -> Null,
          MaxDestinationNumberOfColumns -> ConstantArray[Null,numSamples],
          MaxDestinationNumberOfRows -> ConstantArray[Null,numSamples],
          PrimaryWash -> ConstantArray[Null,numSamples],
          PrimaryWashSolution -> ConstantArray[Null,numSamples],
          NumberOfPrimaryWashes -> ConstantArray[Null,numSamples],
          PrimaryDryTime -> ConstantArray[Null,numSamples],
          SecondaryWash -> ConstantArray[Null,numSamples],
          SecondaryWashSolution -> ConstantArray[Null,numSamples],
          NumberOfSecondaryWashes -> ConstantArray[Null,numSamples],
          SecondaryDryTime -> ConstantArray[Null,numSamples],
          TertiaryWash -> ConstantArray[Null,numSamples],
          TertiaryWashSolution -> ConstantArray[Null,numSamples],
          NumberOfTertiaryWashes -> ConstantArray[Null,numSamples],
          TertiaryDryTime -> ConstantArray[Null,numSamples],
          QuaternaryWash -> ConstantArray[Null,numSamples],
          QuaternaryWashSolution -> ConstantArray[Null,numSamples],
          NumberOfQuaternaryWashes -> ConstantArray[Null,numSamples],
          QuaternaryDryTime -> ConstantArray[Null,numSamples],
          Volume -> ConstantArray[Null,numSamples],
          SourceMix -> ConstantArray[Null,numSamples],
          NumberOfSourceMixes -> ConstantArray[Null,numSamples],
          SourceMixVolume -> ConstantArray[Null,numSamples],
          PipettingMethod -> ConstantArray[Null,numSamples]
        };
        
        (* Gether all AgarStab options *)
        agarStabOptions = {
          Instrument -> resolvedInstruments,
          DestinationMediaContainer -> resolvedDestinationMediaContainers,
          DestinationWell -> resolvedDestinationWells,
          TransferEnvironment -> resolvedTransferEnvironments,
          DestinationMix -> resolvedDestinationMixes,
          DestinationMixType -> resolvedDestinationMixTypes,
          DestinationNumberOfMixes -> resolvedDestinationNumberOfMixes,
          DestinationMixVolume -> resolvedDestinationMixVolumes,
          Tips -> resolvedTips,
          TipType -> resolvedTipTypes,
          TipMaterial -> resolvedTipMaterials,
          DestinationMedia -> resolvedDestinationMedia,
          MediaVolume -> resolvedMediaVolumes,
          InoculationSource -> resolvedInoculationSource,
          SampleLabel -> resolvedSampleLabels,
          SampleContainerLabel -> resolvedSampleContainerLabels,
          SampleOutLabel -> resolvedSampleOutLabels,
          ContainerOutLabel -> resolvedContainerOutLabels
        };
        
        (* This error do not apply to AgarStab *)
        agarStabInvalidMixTypeErrors = ConstantArray[False,numSamples];
        
        {
          agarStabInvalidInstrumentErrors,
          agarStabMultipleDestinationMediaContainersErrors,
          agarStabInvalidMixTypeErrors,
          agarStabNoTipsFoundErrors,
          agarStabTipOptionMismatchErrors,
          agarStabNoPreferredLiquidMediaWarnings,
          agarStabInvalidDestinationWellErrors,
          agarStabMixMismatchErrors,
          agarStabTipConnectionMismatchErrors,
          Join[
            nonAgarStabOptions,
            agarStabOptions
          ],
          {}
        }
      ],
    
    (* We are not resolving any more options at this point - Return everything as Null. Options the user set will be replace in the parent function *)
    MatchQ[resolvedInoculationSource,Null] || inoculationSourceError,
      {
        (* Set all error checking variables to False *)
        ConstantArray[False,Length[mySamples]],
        ConstantArray[False,Length[mySamples]],
        ConstantArray[False,Length[mySamples]],
        ConstantArray[False,Length[mySamples]],
        ConstantArray[False,Length[mySamples]],
        ConstantArray[False,Length[mySamples]],
        ConstantArray[False,Length[mySamples]],
        ConstantArray[False,Length[mySamples]],
        ConstantArray[False,Length[mySamples]],

        {
          InoculationSource -> resolvedInoculationSource,
          Instrument -> Null,
          TransferEnvironment -> Null,
          DestinationMediaContainer -> Null,
          DestinationMix -> Null,
          DestinationMixType -> Null,
          DestinationNumberOfMixes -> Null,
          DestinationMixVolume -> Null,
          Populations -> Null,
          MinRegularityRatio -> Null,
          MaxRegularityRatio -> Null,
          MinCircularityRatio -> Null,
          MaxCircularityRatio -> Null,
          MinDiameter -> Null,
          MaxDiameter -> Null,
          MinColonySeparation -> Null,
          ImagingChannels -> Null,
          ExposureTimes -> Null,
          ColonyHandlerHeadCassetteApplication -> Null,
          HeadDiameter -> Null,
          HeadLength -> Null,
          NumberOfHeads -> Null,
          ColonyPickingTool -> Null,
          ColonyPickingDepth -> Null,
          PickCoordinates -> Null,
          DestinationMedia -> Null,
          MediaVolume -> Null,
          DestinationFillDirection -> Null,
          MaxDestinationNumberOfColumns -> Null,
          MaxDestinationNumberOfRows -> Null,
          PrimaryWash -> Null,
          PrimaryWashSolution -> Null,
          NumberOfPrimaryWashes -> Null,
          PrimaryDryTime -> Null,
          SecondaryWash -> Null,
          SecondaryWashSolution -> Null,
          NumberOfSecondaryWashes -> Null,
          SecondaryDryTime -> Null,
          TertiaryWash -> Null,
          TertiaryWashSolution -> Null,
          NumberOfTertiaryWashes -> Null,
          TertiaryDryTime -> Null,
          QuaternaryWash -> Null,
          QuaternaryWashSolution -> Null,
          NumberOfQuaternaryWashes -> Null,
          QuaternaryDryTime -> Null,
          Volume -> Null,
          DestinationWell -> Null,
          Tips -> Null,
          TipType -> Null,
          TipMaterial -> Null,
          SourceMix -> Null,
          NumberOfSourceMixes -> Null,
          SourceMixVolume -> Null,
          PipettingMethod -> Null

        },
        {}
      }
  ];

  (* Check for errors *)

  (* InvalidInstrument *)
  invalidInstrumentOptions = If[MemberQ[invalidInstrumentErrors,True]&&messages,
    Message[Error::InvalidInstrument, PickList[Lookup[resolvedOptions,Instrument],invalidInstrumentErrors],resolvedInoculationSource];
    {InoculationSource,Instrument},
    {}
  ];

  invalidInstrumentTests = If[MemberQ[invalidInstrumentErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,invalidInstrumentErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have a specified instrument that corresponds to InoculationSource:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have a specified instrument that corresponds to InoculationSource:",True,False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* MultipleDestinationMediaContainersErrors *)
  multipleDestinationMediaContainersOptions = If[MemberQ[multipleDestinationMediaContainersErrors,True]&&messages,
    Message[Error::MultipleDestinationMediaContainers, PickList[mySamples,multipleDestinationMediaContainersErrors]];
    {InoculationSource,Instrument},
    {}
  ];

  multipleDestinationMediaContainersTests = If[MemberQ[multipleDestinationMediaContainersErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,multipleDestinationMediaContainersErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have InocultionSource->LiquidMedia or AgarStab and have only a single Object or single Model DestinationMediaContainer:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have InocultionSource->LiquidMedia or AgarStab and have only a single Object or single Model DestinationMediaContainer:",True,False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* invalidMixTypeErrors *)
  invalidMixTypeOptions = If[MemberQ[invalidMixTypeErrors,True]&&messages,
    Message[Error::InvalidMixType, PickList[mySamples,invalidMixTypeErrors]];
    {InoculationSource,MixType},
    {}
  ];

  invalidMixTypeTests = If[MemberQ[invalidMixTypeErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,invalidMixTypeErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have DestinationMixType->Shake when InoculationSource is SolidMedia:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have DestinationMixType->Shake when InoculationSource is SolidMedia:",True,False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* noTipsFoundErrors *)
  noTipsFoundOptions = If[MemberQ[noTipsFoundErrors,True]&&messages,
    Message[Error::NoTipsFound, PickList[mySamples,noTipsFoundErrors]];
    {DestinationMediaContainer,Tips,TipMaterial,TipType},
    {}
  ];

  noTipsFoundTests = If[MemberQ[noTipsFoundErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,noTipsFoundErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have Tips that match TipMaterial and TipType, can reach the sample in the source container and can touch the bottom of the DestinationMediaContainer:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have Tips that match TipMaterial and TipType, can reach the sample in the source container and can touch the bottom of the DestinationMediaContainer:",True,False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];


  (* tipOptionMismatch *)
  tipOptionMismatchOptions = If[MemberQ[tipOptionMismatchErrors,True]&&messages,
    Message[Error::TipOptionMismatch, PickList[mySamples,tipOptionMismatchErrors]];
    {Tips,TipMaterial,TipType},
    {}
  ];

  tipOptionMismatchTests = If[MemberQ[tipOptionMismatchErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,tipOptionMismatchErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have Tips -> Model[Item,Tips] and both TipMaterial and TipType set or Tips -> Null and neither TipMaterial or TipType set:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have Tips -> Model[Item,Tips] and both TipMaterial and TipType set or Tips -> Null and neither TipMaterial or TipType set:",True,False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];


  (* noPreferredLiquidMediaWarnings *)
  If[MemberQ[noPreferredLiquidMediaWarnings,True]&&messages,
    Message[Warning::NoPreferredLiquidMedia, PickList[mySamples,noPreferredLiquidMediaWarnings]]
  ];

  (* invalidDestinationWellErrors *)
  invalidDestinationWellOptions = If[MemberQ[invalidDestinationWellErrors,True]&&messages,
    Message[Error::InvalidDestinationWellPosition, PickList[mySamples,invalidDestinationWellErrors]];
    {DestinationWell},
    {}
  ];

  invalidDestinationWellTests = If[MemberQ[invalidDestinationWellErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,invalidDestinationWellErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have a Destination well that is a valid Position in DestinationMediaContainer:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have a Destination well that is a valid Position in DestinationMediaContainer:",True,False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* mixMismatchErrors *)
  mixMismatchOptions = If[MemberQ[mixMismatchErrors,True]&&messages,
    Message[Error::MixMismatch, PickList[mySamples,mixMismatchErrors]];
    {DestinationMix,DestinationMixType, DestinationNumberOfMixes, DestinationMixVolume},
    {}
  ];

  mixMismatchTests = If[MemberQ[mixMismatchErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,mixMismatchErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have DestinationMix -> True and both DestinationNumberOfMixes and DestinationMixVolume set or DestinationMix -> False and neither DestinationNumberOfMixes nor DestinationMixVolume set:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" have DestinationMix -> True and both DestinationNumberOfMixes and DestinationMixVolume set or DestinationMix -> False and neither DestinationNumberOfMixes nor DestinationMixVolume set:",True,False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* tipConnectionMismatchErrors *)
  tipConnectionMismatchOptions = If[MemberQ[tipConnectionMismatchErrors,True]&&messages,
    Message[Error::TipConnectionMismatch, PickList[mySamples,tipConnectionMismatchErrors]];
    {Instrument,Tips},
    {}
  ];

  tipConnectionMismatchTests = If[MemberQ[tipConnectionMismatchErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,tipConnectionMismatchErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" specified Instrument and Tips have a compatible TipConnectionType:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples "<>ObjectToString[passingInputs, Cache->cache]<>" specified Instrument and Tips have a compatible TipConnectionType:",True,False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  invalidInputs=DeleteDuplicates[Flatten[
    {
      discardedInvalidInputs,
      multipleInoculationSourceInInputInputs
    }
  ]];

  invalidOptions=DeleteDuplicates[Flatten[
    {
      inoculationSourceOptionMismatchOptions,
      inoculationSourceInputSampleMismatchOptions,
      switchInvalidOptions,
      invalidInstrumentOptions,
      multipleDestinationMediaContainersOptions,
      invalidMixTypeOptions,
      noTipsFoundOptions,
      tipOptionMismatchOptions,
      invalidDestinationWellOptions,
      mixMismatchOptions,
      tipConnectionMismatchOptions
    }
  ]];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  (* NOTE: Quiet General::stop when throwing InvalidInput/InvalidOptions because they do not get quieted in ModifyFunctionMessages *)
  Quiet[
    If[Length[invalidInputs]>0&&!gatherTests,
      Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cache]]
    ],
    General::stop
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  (* NOTE: Quiet General::stop when throwing InvalidInput/InvalidOptions because they do not get quieted in ModifyFunctionMessages *)
  Quiet[
    If[Length[invalidOptions]>0&&!gatherTests,
      Message[Error::InvalidOption,invalidOptions]
    ],
    General::stop
  ];

  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

  (* Return our resolved options and/or tests. *)
  outputSpecification/.{
    Result -> ReplaceRule[
      myOptions,
      Flatten[{
        Preparation -> resolvedPreparation,
        NumberOfReplicates -> resolvedNumberOfReplicates,
        SamplesInStorageCondition -> resolvedSamplesInStorageCondition,
        SamplesOutStorageCondition -> resolvedSamplesOutStorageCondition,
        resolvedPostProcessingOptions,
        resolvedOptions
      }]
    ],

    Tests -> Flatten[{
      discardedTest,
      inoculationSourceInputSampleMismatchTest,
      multipleInoculationSourceInInputTests,
      optionPrecisionTests,
      inoculationSourceOptionMismatchTests,
      invalidInstrumentTests,
      multipleDestinationMediaContainersTests,
      invalidMixTypeTests,
      noTipsFoundTests,
      tipOptionMismatchTests,
      invalidDestinationWellTests,
      mixMismatchTests,
      tipConnectionMismatchTests
    }]
  }

];


(* ::Subsection:: *)
(*Resource Packets*)
DefineOptions[inoculateLiquidMediaResourcePackets,
  Options :> {
    HelperOutputOption,
    CacheOption,
    SimulationOption
  }
];

inoculateLiquidMediaResourcePackets[
  mySamples:{ObjectP[Object[Sample]]..},
  myUnresolvedOptions:{_Rule...},
  myResolvedOptions:{_Rule...},
  ops:OptionsPattern[inoculateLiquidMediaResourcePackets]
] := Module[
  {
    unresolvedOptionsNoHidden,resolvedOptionsNoHidden,outputSpecification,output,
    gatherTests,messages,inheritedCache,simulation,combinedFastAssoc,currentSimulation,resolvedPreparation,

    (* Resolved options *)
    resolvedInoculationSource,
    resolvedInstrument,
    resolvedTransferEnvironment,
    resolvedDestinationMediaContainer,
    resolvedDestinationMix,
    resolvedDestinationMixType,
    resolvedDestinationNumberOfMixes,
    resolvedDestinationMixVolume,
    resolvedMediaVolume,
    resolvedDestinationMedia,
    resolvedPopulations,
    resolvedMinDiameter,
    resolvedMaxDiameter,
    resolvedMinColonySeparation,
    resolvedMinRegularityRatio,
    resolvedMaxRegularityRatio,
    resolvedMinCircularityRatio,
    resolvedMaxCircularityRatio,
    resolvedImagingChannels,
    resolvedExposureTimes,
    resolvedColonyPickingTool,
    resolvedHeadDiameter,
    resolvedHeadLength,
    resolvedNumberOfHeads,
    resolvedColonyHandlerHeadCassetteApplication,
    resolvedColonyPickingDepth,
    resolvedPickCoordinates,
    resolvedDestinationFillDirection,
    resolvedMaxDestinationNumberOfColumns,
    resolvedMaxDestinationNumberOfRows,
    resolvedPrimaryWash,
    resolvedPrimaryWashSolution,
    resolvedNumberOfPrimaryWashes,
    resolvedPrimaryDryTime,
    resolvedSecondaryWash,
    resolvedSecondaryWashSolution,
    resolvedNumberOfSecondaryWashes,
    resolvedSecondaryDryTime,
    resolvedTertiaryWash,
    resolvedTertiaryWashSolution,
    resolvedNumberOfTertiaryWashes,
    resolvedTertiaryDryTime,
    resolvedQuaternaryWash,
    resolvedQuaternaryWashSolution,
    resolvedNumberOfQuaternaryWashes,
    resolvedQuaternaryDryTime,
    resolvedVolume,
    resolvedDestinationWell,
    resolvedTips,
    resolvedTipType,
    resolvedTipMaterial,
    resolvedSourceMix,
    resolvedSourceMixType,
    resolvedNumberOfSourceMixes,
    resolvedSourceMixVolume,
    resolvedPipettingMethod,
    resolvedNumberOfReplicates,
    parentProtocol,

    protocolPacket, unitOperationPackets, batchedUnitOperationPackets,roboticRunTime,

    (* FRQ and Return *)
    rawResourceBlobs,resourcesWithoutName,resourceToNameReplaceRules,
    allResourceBlobs,fulfillable,frqTests,previewRule,optionsRule,resultRule,testsRule
  },

  (* Get the collapsed unresolved index-matching options that don't include hidden options *)
  unresolvedOptionsNoHidden=RemoveHiddenOptions[ExperimentInoculateLiquidMedia,myUnresolvedOptions];

  (* Get the collapsed resolved index-matching options that don't include hidden options *)
  (* Ignore to collapse those options that are set in expandedsafeoptions *)
  resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
    ExperimentInoculateLiquidMedia,
    RemoveHiddenOptions[ExperimentInoculateLiquidMedia,myResolvedOptions],
    Ignore->myUnresolvedOptions,
    Messages->False
  ];

  (* Determine the requested output format of this function *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user *)
  gatherTests=MemberQ[output,Tests];
  messages=!gatherTests;

  (* Get the inherited cache *)
  inheritedCache=Lookup[ToList[ops],Cache,{}];
  simulation=Lookup[ToList[ops],Simulation,{}];

  (* Initialize the simulation if it does not exist *)
  currentSimulation = If[MatchQ[simulation,SimulationP],
    simulation,
    Simulation[]
  ];

  (* Get the resolved preparation scale *)
  resolvedPreparation=Lookup[myResolvedOptions,Preparation];

  (* Extract the necessary resolved options *)
  {
    resolvedInoculationSource,
    resolvedInstrument,
    resolvedTransferEnvironment,
    resolvedDestinationMediaContainer,
    resolvedDestinationMix,
    resolvedDestinationMixType,
    resolvedDestinationNumberOfMixes,
    resolvedDestinationMixVolume,
    resolvedMediaVolume,
    resolvedDestinationMedia,
    resolvedPopulations,
    resolvedMinDiameter,
    resolvedMaxDiameter,
    resolvedMinColonySeparation,
    resolvedMinRegularityRatio,
    resolvedMaxRegularityRatio,
    resolvedMinCircularityRatio,
    resolvedMaxCircularityRatio,
    resolvedImagingChannels,
    resolvedExposureTimes,
    resolvedColonyPickingTool,
    resolvedHeadDiameter,
    resolvedHeadLength,
    resolvedNumberOfHeads,
    resolvedColonyHandlerHeadCassetteApplication,
    resolvedColonyPickingDepth,
    resolvedPickCoordinates,
    resolvedDestinationFillDirection,
    resolvedMaxDestinationNumberOfColumns,
    resolvedMaxDestinationNumberOfRows,
    resolvedPrimaryWash,
    resolvedPrimaryWashSolution,
    resolvedNumberOfPrimaryWashes,
    resolvedPrimaryDryTime,
    resolvedSecondaryWash,
    resolvedSecondaryWashSolution,
    resolvedNumberOfSecondaryWashes,
    resolvedSecondaryDryTime,
    resolvedTertiaryWash,
    resolvedTertiaryWashSolution,
    resolvedNumberOfTertiaryWashes,
    resolvedTertiaryDryTime,
    resolvedQuaternaryWash,
    resolvedQuaternaryWashSolution,
    resolvedNumberOfQuaternaryWashes,
    resolvedQuaternaryDryTime,
    resolvedVolume,
    resolvedDestinationWell,
    resolvedTips,
    resolvedTipType,
    resolvedTipMaterial,
    resolvedSourceMix,
    resolvedSourceMixType,
    resolvedNumberOfSourceMixes,
    resolvedSourceMixVolume,
    resolvedPipettingMethod,
    resolvedNumberOfReplicates,
    parentProtocol
  } = Lookup[
    myResolvedOptions,
    {
      InoculationSource,
      Instrument,
      TransferEnvironment,
      DestinationMediaContainer,
      DestinationMix,
      DestinationMixType,
      DestinationNumberOfMixes,
      DestinationMixVolume,
      MediaVolume,
      DestinationMedia,
      Populations,
      MinDiameter,
      MaxDiameter,
      MinColonySeparation,
      MinRegularityRatio,
      MaxRegularityRatio,
      MinCircularityRatio,
      MaxCircularityRatio,
      ImagingChannels,
      ExposureTimes,
      ColonyPickingTool,
      HeadDiameter,
      HeadLength,
      NumberOfHeads,
      ColonyHandlerHeadCassetteApplication,
      ColonyPickingDepth,
      PickCoordinates,
      DestinationFillDirection,
      MaxDestinationNumberOfColumns,
      MaxDestinationNumberOfRows,
      PrimaryWash,
      PrimaryWashSolution,
      NumberOfPrimaryWashes,
      PrimaryDryTime,
      SecondaryWash,
      SecondaryWashSolution,
      NumberOfSecondaryWashes,
      SecondaryDryTime,
      TertiaryWash,
      TertiaryWashSolution,
      NumberOfTertiaryWashes,
      TertiaryDryTime,
      QuaternaryWash,
      QuaternaryWashSolution,
      NumberOfQuaternaryWashes,
      QuaternaryDryTime,
      Volume,
      DestinationWell,
      Tips,
      TipType,
      TipMaterial,
      SourceMix,
      SourceMixType,
      NumberOfSourceMixes,
      SourceMixVolume,
      PipettingMethod,
      NumberOfReplicates,
      ParentProtocol
    }
  ];

  (* Case on resolvedPreparation *)
  {protocolPacket, unitOperationPackets, batchedUnitOperationPackets, currentSimulation, roboticRunTime} = If[MatchQ[resolvedPreparation,Manual],
    Module[
      {
        sampleContainerObjects,tipPackets,flattenedTipPackets,samplesInResources,
        containersIn,uniqueContainersIn,transferEnvironmentResources,allSharedInstruments,sharedInstrumentResources,
        instrumentResources,allTips,talliedTips,tipToResourceListLookup,popTipResource,tipResources,
        uniqueDestinationContainerObjects,destinationContainerObjectResourceLookup,destinationContainerResources,
        destMediaContainerFootprints, destMediaContainerPackets, combinedCache, plateSealToUse
      },

      (* If we are doing manual we can either have a Liquid-Liquid transfer or an AgarStab transfer *)
      (* Either way we will make an Object[Protocol,InoculateLiquidMedia] *)

      (* Download information *)
      (* Split the destination containers into models and objects *)
      {
        sampleContainerObjects,
        tipPackets,
        destMediaContainerPackets
      } = Quiet[
        Download[
          {
            mySamples,
            resolvedTips,
            Flatten[resolvedDestinationMediaContainer]
          },
          {
            {
              Packet[Container[Object]]
            },
            {
              Packet[NumberOfTips]
            },
            {
              Packet[Model[Footprint]],
              Packet[Footprint, Model]
            }
          },
          Cache -> inheritedCache,
          Simulation -> currentSimulation
        ],
        {Download::FieldDoesntExist}
      ];

      (* Flatten the tip packets *)
      flattenedTipPackets = FlattenCachePackets[tipPackets];

      (* Create a fast assoc *)
      combinedCache = FlattenCachePackets[{tipPackets, destMediaContainerPackets, inheritedCache}];
      combinedFastAssoc = makeFastAssocFromCache[combinedCache];

      (* Create the resources *)

      (* 1. Make resources for our SamplesIn *)
      samplesInResources = If[MatchQ[resolvedInoculationSource, LiquidMedia],
        Module[
          {
            samplesInVolumesRequired,samplesInAndVolumes,samplesInResourceReplaceRules
          },
          (* Calculate the total volume we need of each sample in. It is just the volume we are transferring  *)
          samplesInVolumesRequired = resolvedVolume;

          (* Pair up each sample with its volume *)
          samplesInAndVolumes = Merge[MapThread[Association[#1->#2]&, {mySamples, samplesInVolumesRequired}],Total];

          (* Create a resource rule for each unique sample *)
          samplesInResourceReplaceRules = KeyValueMap[Function[{sample,volume},
            If[MatchQ[volume, All],
              sample -> Resource[Sample -> sample, Name -> CreateUUID[]],
              sample -> Resource[Sample -> sample, Amount -> volume, Name -> CreateUUID[]]
            ]
          ],
            samplesInAndVolumes
          ];

          (* Use the replace rules *)
          mySamples /. samplesInResourceReplaceRules
        ],
        Module[
          {
            samplesInResourceReplaceRules
          },
          (* Create a resource rule for each unique sampleIn *)
          samplesInResourceReplaceRules = (#->Resource[Sample -> #, Name -> CreateUUID[]])&/@DeleteDuplicates[mySamples];

          (* Use the replace rules *)
          mySamples /. samplesInResourceReplaceRules
        ]
      ];

      (* 2. Make Resources for our ContainersIn *)
      containersIn = Lookup[FlattenCachePackets[sampleContainerObjects],Object];

      (* get the unique container in *)
      uniqueContainersIn=DeleteDuplicates[Flatten[containersIn]];

      (* 3. Create TransferEnvironment Resources *)
      (* If multiple transfer environment resources are the same back to back, they should be the same resource object for BSCs. *)
      (* This is because only 1 operator can use a BSC at the same time. *)
      transferEnvironmentResources = Module[{splitTransferEnvironments},

        (* Get runs of the same BSC's *)
        splitTransferEnvironments=Split[Download[resolvedTransferEnvironment, Object]];

        (* Map over the runs of BSC's *)
        Flatten@Map[
          Function[{transferEnvironmentList},
            ConstantArray[
              Resource[
                Instrument->First[transferEnvironmentList],
                Time->10*Minute*Length[transferEnvironmentList],
                Name->CreateUUID[]
              ],
              Length[transferEnvironmentList]
            ]
          ],
          splitTransferEnvironments
        ]
      ];

      (* 4. Create Instrument Resources *)
      allSharedInstruments=Download[Cases[
        resolvedInstrument,
        ObjectP[{Model[Instrument, Pipette], Object[Instrument, Pipette]}]
      ], Object];

      sharedInstrumentResources=(
        Download[#, Object]->Resource[Instrument->#, Name->CreateUUID[], Time->(5 Minute + (5 Minute * Count[allSharedInstruments, ObjectP[#]]))]&
      )/@DeleteDuplicates[allSharedInstruments];

      instrumentResources = resolvedInstrument /. sharedInstrumentResources;

      (* 5. Create tip resources  *)
      (* Create resources for all of the tips. *)
      (* NOTE: We only take into account tip box partitioning in the Manual case because in the Robotic case, the framework handles it *)
      (* for us by replacing our tip resources in-situ. *)
      allTips=Download[Cases[resolvedTips, ObjectP[{Model[Item, Tips], Object[Item, Tips]}]],Object];
      talliedTips=Tally[allTips];

      tipToResourceListLookup=Association@Map[
        Function[{tipInformation},
          Module[{tipObject, numberOfTipsNeeded, numberOfTipsPerBox},
            (* Pull out from our tip information. *)
            tipObject=tipInformation[[1]];
            numberOfTipsNeeded=tipInformation[[2]];

            (* Lookup the number of tips per box. *)
            (* NOTE: This can be one if they're individually wrapped. *)
            numberOfTipsPerBox=(Lookup[fetchPacketFromCache[tipObject, flattenedTipPackets],NumberOfTips]/.{Null|$Failed->1});

            (* Return a list that we will pop off of everytime we take a tip. *)
            (* NOTE: If NumberOfTips->1, that means that this tip model is individually wrapped and we shouldn't include *)
            (* the Amount key in the resource. *)
            Download[tipObject, Object]->If[MatchQ[numberOfTipsPerBox, 1],
              Table[
                Resource[
                  Sample->tipObject,
                  Name->CreateUUID[]
                ],
                {x, 1, numberOfTipsNeeded}
              ],
              Flatten@{
                Table[ (* Resources for full boxes of tips. *)
                  ConstantArray[
                    Resource[
                      Sample->tipObject,
                      Amount->numberOfTipsPerBox,
                      Name->CreateUUID[]
                    ],
                    numberOfTipsPerBox
                  ],
                  {x, 1, IntegerPart[numberOfTipsNeeded/numberOfTipsPerBox]}
                ],
                ConstantArray[ (* Resources for the tips in the non-full box. *)
                  Resource[
                    Sample->tipObject,
                    Amount->Mod[numberOfTipsNeeded, numberOfTipsPerBox],
                    Name->CreateUUID[]
                  ],
                  Mod[numberOfTipsNeeded, numberOfTipsPerBox]
                ]
              }
            ]
          ]
        ],
        talliedTips
      ];

      (* Helper function to pop a tip resource off of a given stack. *)
      popTipResource[tipObject_]:=Module[{oldResourceList},
        If[MatchQ[tipObject, Null],
          Null,
          oldResourceList=Lookup[tipToResourceListLookup, Download[tipObject, Object]];

          tipToResourceListLookup[Download[tipObject, Object]]=Rest[oldResourceList];

          First[oldResourceList]
        ]
      ];

      (* Use the helper and resource list to get the resources *)
      tipResources = popTipResource /@ resolvedTips;

      (* 6. Create DestinationContainer Resources *)
      uniqueDestinationContainerObjects = DeleteDuplicates[Cases[Flatten[resolvedDestinationMediaContainer],ObjectP[Object[Container]]]];

      destinationContainerObjectResourceLookup = # -> Resource[Sample -> #, Name -> "ExperimentInoculateLiquidMedia DestinationContainer " <> CreateUUID[]]&/@uniqueDestinationContainerObjects;

      destinationContainerResources = Map[
        Function[{container},
          Which[
            MatchQ[container,ObjectP[Object[Container]]],
              container /. destinationContainerObjectResourceLookup,
            MatchQ[container, ObjectP[Model[Container]]],
              Resource[Sample -> container, Name -> "ExperimentInoculateLiquidMedia DestinationContainer " <> CreateUUID[]],
            (* We have a listable case *)
            True,
              Map[Function[{innerContainer},
                If[MatchQ[innerContainer,ObjectP[Object[Container]]],
                  container /. destinationContainerObjectResourceLookup,
                  Resource[Sample -> container, Name -> "ExperimentInoculateLiquidMedia DestinationContainer " <> CreateUUID[]]
                ]
              ],
                container
              ]
          ]
        ],
        resolvedDestinationMediaContainer
      ];

      (* decide if we want to use a special plate seal or not *)
      destMediaContainerFootprints = Map[
        Switch[#,
          ObjectP[Object[Container]], fastAssocLookup[combinedFastAssoc, #, {Model, Footprint}],
          ObjectP[Model[Container]], fastAssocLookup[combinedFastAssoc, #, Footprint],
          _, Null
        ]&,
        resolvedDestinationMediaContainer
      ];
      plateSealToUse = If[MemberQ[destMediaContainerFootprints, Plate],
        Model[Item, PlateSeal, "id:BYDOjvG74Abm"], (* Model[Item, PlateSeal, "AeraSeal Plate Seal, Breathable Sterile"] *)
        Null
      ];

      (* 8. Switch on InoculationSource and create the protocol packet *)
      Switch[resolvedInoculationSource,
        LiquidMedia,
          Module[{inoculateProtocolPacket},
            (* Create the protocol packet *)
            inoculateProtocolPacket = <|

              (* General *)
              Object -> CreateID[Object[Protocol,InoculateLiquidMedia]],
              Type -> Object[Protocol, InoculateLiquidMedia],
              Replace[SamplesIn] -> Map[Link[#,Protocols]&,samplesInResources],
              Replace[ContainersIn] -> Map[Function[{container},Link[container,Protocols]],uniqueContainersIn],
              ParentProtocol-> If[MatchQ[parentProtocol,ObjectP[ProtocolTypes[]]],
                Link[parentProtocol,Subprotocols]
              ],
              Name->Lookup[myResolvedOptions,Name],

              (* Organizational Information *)
              Author-> If[MatchQ[parentProtocol,Null],
                Link[$PersonID,ProtocolsAuthored]
              ],

              (* Options Handling *)
              UnresolvedOptions->RemoveHiddenOptions[ExperimentInoculateLiquidMedia,myUnresolvedOptions],
              ResolvedOptions->myResolvedOptions,

              (* Resources *)
              Replace[Checkpoints]->{
                {"Picking Resources",15 Minute,"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 1"],Time->45 Minute]]},
                {"Performing Transfers",inoculateLiquidMediaRunTime[mySamples],"Cells are transferred.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 1"],Time->3 Hour]]},
                {"Returning Materials",15 Minute,"Samples are returned to storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 1"],Time->1 Hour]]}
              },

              (* Sample Storage *)
              Replace[SamplesInStorageCondition] -> Lookup[myResolvedOptions,SamplesInStorageCondition],
              (* NOTE: We flatten here because this option is NestedIndexMatching for the PickColonies case - but for the manual cases that is not wanted *)
              Replace[SamplesOutStorageCondition] -> Flatten[Lookup[myResolvedOptions,SamplesOutStorageCondition]],

              (* General *)
              InoculationSource -> resolvedInoculationSource,
              Replace[TransferEnvironments] -> Link/@transferEnvironmentResources,
              Replace[Instruments] -> Link/@instrumentResources,

              (* Stab *)
              Replace[StabTips] -> Null,
              Replace[StabTipTypes] -> Null,
              Replace[StabTipMaterials] -> Null,

              (* Aspirate *)
              Replace[TransferVolumes] -> resolvedVolume,
              Replace[Tips] -> Link/@tipResources,
              Replace[TipTypes] -> resolvedTipType,
              Replace[TipMaterials] -> resolvedTipMaterial,
              Replace[PipettingMethods] -> Link/@resolvedPipettingMethod,
              Replace[SourceMixTypes] -> resolvedSourceMixType,
              Replace[NumberOfSourceMixes] -> resolvedNumberOfSourceMixes,
              Replace[SourceMixVolumes] -> resolvedSourceMixVolume,

              (* Deposit *)
              Replace[DestinationMedia] -> Null,
              Replace[MediaVolumes] -> Null,
              Replace[DestinationMediaContainers] -> Link/@destinationContainerResources,
              Replace[DestinationWells] -> resolvedDestinationWell,
              Replace[DestinationMixTypes] -> resolvedDestinationMixType,
              Replace[DestinationNumberOfMixes] -> resolvedDestinationNumberOfMixes,
              Replace[DestinationMixVolumes] -> resolvedDestinationMixVolume,
              PlateSeal -> Link[plateSealToUse],
              MeasureVolume -> False,
              ImageSample -> False,
              MeasureWeight -> False
            |>;

            (* Return the protocol packet *)
            {
              inoculateProtocolPacket,
              Null,
              Null,
              currentSimulation,
              Null
            }
          ],
        AgarStab,
          Module[
            {
              mediaVolumeAssociations,mediaToVolumeLookup,mediaResourceLookup,mediaResources,
              availablePipetteObjectsAndModels,resourcesNotToPickUpFront,setUpTransferEnvironmentBools,
              tearDownTransferEnvironmentBools,pipetteReleaseBools,tipReleaseBools,coverDestinationContainerBools,
              inoculateProtocolPacket,fullInoculateProtocolPacket
            },

            (* Create DestinationMedia Resources *)
            (* Get the volume of media we need for each input sample *)
            mediaVolumeAssociations = MapThread[<|#1->#2|>&,{Download[Lookup[myResolvedOptions,DestinationMedia],Object], Lookup[myResolvedOptions,MediaVolume]}];

            (* Total the media volumes across all input samples *)
            mediaToVolumeLookup = Merge[mediaVolumeAssociations,Total];

            (* Create a resource lookup for each unique media *)
            mediaResourceLookup = KeyValueMap[
              Function[{object,volume},
                (* need to specify a container if we're doing water prep *)
                (* otherwise we want to minimize transfers and thus don't want to specify container; just pick it in whatever it's already in *)
                object -> If[MatchQ[object, WaterModelP],
                  Resource[Sample->object, Container -> PreferredContainer[volume], Amount -> volume, Name -> "ExperimentInoculateLiquidMedia DestinationMedia " <> CreateUUID[]],
                  Resource[Sample->object, Amount -> volume, Name -> "ExperimentInoculateLiquidMedia DestinationMedia " <> CreateUUID[]]
                ]
              ],
              mediaToVolumeLookup
            ];

            (* Use the media lookup to create get the ordered list of resources *)
            mediaResources = Lookup[myResolvedOptions, DestinationMedia] /. mediaResourceLookup;

            (* Determine the RequriedObjects and RequiredResources - we do not want to pick all of the resources up front because some will already be inside the BSCs *)
            (* Right now, these only include pipettes and pipette tips *)
            (* if we're in the BSC/glove box since we stash pipettes in these transfer environments. *)
            (* NOTE: We do this at experiment time to try to avoid any un-linking of resources at experiment time. *)
            (* This can be a little inaccurate since things can change between experiment and procedure time but generally, *)
            (* we don't expect the types of pipettes to change. Additionally, the operator is still given free-reign to *)
            (* pick whatever they want so they can still pick something from the VLM if there aren't enough stashed in the box. *)

            (* Figure out what pipette objects and models are available in each of the BSCs that we have. *)
            availablePipetteObjectsAndModels=Map[
              Function[{transferEnvironment},
                (* Figure out what pipette objects/models are available in our transfer environment. *)
                Download[transferEnvironment, Object]->Switch[Download[transferEnvironment, Object],
                  ObjectP[{Object[Instrument, BiosafetyCabinet],Model[Instrument,BiosafetyCabinet]}],
                  Module[{allPipetteObjects},

                    (* Get all pipette objects. *)
                    allPipetteObjects=Cases[
                      Download[fastAssocLookup[combinedFastAssoc,transferEnvironment, Pipettes],Object],
                      ObjectP[Object[Instrument, Pipette]]
                    ];

                    (* Include all objects and models. *)
                    Download[
                      Flatten[{
                        allPipetteObjects,
                        fastAssocLookup[combinedFastAssoc,allPipetteObjects,Model]
                      }],
                      Object
                    ]
                  ],
                  _,
                  {}
                ]
              ],
              DeleteDuplicates[Download[Lookup[myResolvedOptions, TransferEnvironment], Object]]
            ];

            (* These are the resources that should not be put into RequiredInstruments/Objects to be picked up front. *)
            resourcesNotToPickUpFront = DeleteDuplicates@Flatten@Join[
              (* Never pick our transfer environments up front. *)
              Cases[transferEnvironmentResources,_Resource,All],
              (* Do not pick the pipette (and corresponding pipette tips) up front *)
              (* if we think that we can fulfill it from the stash inside of the box. *)
              MapThread[
                Function[{transferEnvironment, pipetteObject, pipetteResource, tipResource},
                  Module[{availablePipettes},

                    (* Get the pipettes that are in the transfer environment *)
                    availablePipettes=Lookup[availablePipetteObjectsAndModels, Download[transferEnvironment, Object]];

                    (* If the specified pipette is in the transfer environment, we don't want to pick it *)
                    If[MemberQ[availablePipettes, ObjectP[pipetteObject]],
                      {
                        pipetteResource,
                        tipResource
                      },
                      Nothing
                    ]
                  ]
                ],
                {resolvedTransferEnvironment, resolvedInstrument, instrumentResources, tipResources}
              ]
            ];

            (* Determine when we need to set up transfer environments *)
            setUpTransferEnvironmentBools = MapThread[
              Function[{transferEnvironmentResource,index},
                Which[
                  (* If this is the first sample, we have to set up *)
                  MatchQ[index, 1], True,

                  (* If the transfer environment is not the same as the previous transfer environment, we have to set up *)
                  !MatchQ[transferEnvironmentResource, transferEnvironmentResources[[index - 1]]], True,

                  (* Otherwise, we will use the already set up transfer environment *)
                  True, False
                ]
              ],
              {
                transferEnvironmentResources,
                Range[Length[transferEnvironmentResources]]
              }
            ];

            (* Determine when we need to tear down transfer environments  *)
            tearDownTransferEnvironmentBools = MapThread[
              Function[{transferEnvironmentResource,index},
                Which[
                  (* If this is the last sample, we have to tear down *)
                  MatchQ[index, Length[transferEnvironmentResources]], True,

                  (* If the transfer environment is not the same as the next transfer environment, we have to tear down *)
                  !MatchQ[transferEnvironmentResource, transferEnvironmentResources[[index + 1]]], True,

                  (* Otherwise, we will keep this transfer environment set up *)
                  True, False
                ]
              ],
              {
                transferEnvironmentResources,
                Range[Length[transferEnvironmentResources]]
              }
            ];

            (* Determine when we need to release the pipettes *)
            pipetteReleaseBools = MapThread[
              Function[{pipetteResource,index},
                Which[
                  (* If this is the last sample, we have to release *)
                  MatchQ[index, Length[instrumentResources]], True,

                  (* If this is the last time we use this pipette, we have to release *)
                  !MemberQ[instrumentResources[[(index + 1);;]],pipetteResource], True,

                  (* Otherwise, we will keep this pipette *)
                  True, False
                ]
              ],
              {
                instrumentResources,
                Range[Length[instrumentResources]]
              }
            ];

            (* Determine when we need to release the pipettes *)
            tipReleaseBools = MapThread[
              Function[{tipResource,index},
                Which[
                  (* If this is the last sample, we have to release *)
                  MatchQ[index, Length[tipResource]], True,

                  (* If this is the last time we use this pipette, we have to release *)
                  !MemberQ[tipResources[[(index + 1);;]],tipResource], True,

                  (* Otherwise, we will keep this pipette *)
                  True, False
                ]
              ],
              {
                tipResources,
                Range[Length[tipResources]]
              }
            ];

            coverDestinationContainerBools = MapThread[
              Function[{destinationContainer,index},
                Which[
                  (* If this is the last sample, we have to cover *)
                  MatchQ[index, Length[destinationContainerResources]], True,

                  (* If the container is never used as a destination container again, cover *)
                  !MemberQ[destinationContainerResources[[(index + 1);;]], destinationContainer], True,

                  (* Otherwise, we will keep this transfer environment set up *)
                  True, False
                ]
              ],
              {
                destinationContainerResources,
                Range[Length[destinationContainerResources]]
              }
            ];

            (* Create the protocol packet *)
            inoculateProtocolPacket = <|

              (* General *)
              Object -> CreateID[Object[Protocol,InoculateLiquidMedia]],
              Type -> Object[Protocol, InoculateLiquidMedia],
              Replace[SamplesIn] -> Map[Link[#,Protocols]&,samplesInResources],
              Replace[ContainersIn] -> Map[Function[{container},Link[container,Protocols]],uniqueContainersIn],
              ParentProtocol-> If[MatchQ[parentProtocol,ObjectP[ProtocolTypes[]]],
                Link[parentProtocol,Subprotocols]
              ],
              Name->Lookup[myResolvedOptions,Name],

              (* Organizational Information *)
              Author-> If[MatchQ[parentProtocol,Null],
                Link[$PersonID,ProtocolsAuthored]
              ],

              (* Options Handling *)
              UnresolvedOptions->RemoveHiddenOptions[ExperimentInoculateLiquidMedia,myUnresolvedOptions],
              ResolvedOptions->myResolvedOptions,

              (* Resources *)
              Replace[Checkpoints]->{
                {"Picking Resources",15 Minute,"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 1"],Time->45 Minute]]},
                {"Performing Inoculations",5 Minute * Length[mySamples],"The Inoculations are performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 1"],Time->3 Hour]]},
                {"Returning Materials",15 Minute,"Samples are returned to storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 1"],Time->1 Hour]]}
              },

              (* Sample Storage *)
              Replace[SamplesInStorageCondition] -> Lookup[myResolvedOptions,SamplesInStorageCondition],
              (* NOTE: We flatten here because this option is NestedIndexMatching for the PickColonies case - but for the manual cases that is not wanted *)
              Replace[SamplesOutStorageCondition] -> Flatten[Lookup[myResolvedOptions,SamplesOutStorageCondition]],

              (* General *)
              InoculationSource -> resolvedInoculationSource,
              Replace[TransferEnvironments] -> Link/@transferEnvironmentResources,
              Replace[Instruments] -> Link/@instrumentResources,

              (* Stab *)
              Replace[StabTips] -> Link/@tipResources,
              Replace[StabTipTypes] -> resolvedTipType,
              Replace[StabTipMaterials] -> resolvedTipMaterial,

              (* Aspirate *)
              Replace[TransferVolumes] -> Null,
              Replace[Tips] -> Null,
              Replace[TipTypes] -> Null,
              Replace[TipMaterials] -> Null,
              Replace[PipettingMethods] -> Null,
              Replace[SourceMixTypes] -> Null,
              Replace[NumberOfSourceMixes] -> Null,
              Replace[SourceMixVolumes] -> Null,

              (* Deposit *)
              Replace[DestinationMedia] -> Link/@mediaResources,
              Replace[MediaVolumes] -> resolvedMediaVolume,
              Replace[DestinationMediaContainers] -> Link/@destinationContainerResources,
              Replace[DestinationWells] -> resolvedDestinationWell,
              Replace[DestinationMixTypes] -> resolvedDestinationMixType,
              Replace[DestinationNumberOfMixes] -> resolvedDestinationNumberOfMixes,
              Replace[DestinationMixVolumes] -> resolvedDestinationMixVolume,
              PlateSeal -> Link[plateSealToUse],

              (* Developer *)
              Replace[SetUpTransferEnvironments] -> setUpTransferEnvironmentBools,
              Replace[TearDownTransferEnvironments] -> tearDownTransferEnvironmentBools,
              Replace[ReleaseInstruments] -> pipetteReleaseBools,
              Replace[ReleaseTips] -> tipReleaseBools,
              Replace[CoverDestinationContainers] -> coverDestinationContainerBools
            |>;

            (* Add the RequiredObjects and RequiredInstruments Keys *)
            fullInoculateProtocolPacket = Merge[{
              inoculateProtocolPacket,
              <|
                (* NOTE: These are all resource picked at once so that we can minimize trips to the VLM -- EXCEPT for resources that live in other transfer environments *)
                (* like the BSC. *)
                Replace[RequiredObjects]->DeleteDuplicates[
                  Cases[
                    Cases[
                      DeleteDuplicates[Cases[Normal[inoculateProtocolPacket,Association],_Resource,Infinity]],
                      Resource[KeyValuePattern[Type->Object[Resource, Sample]]]
                    ],
                    Except[Alternatives@@resourcesNotToPickUpFront]
                  ]
                ],
                (* NOTE: We pick all of our instruments at once -- make sure to not include transfer environment instruments like *)
                (* the glove box or BSC. *)
                Replace[RequiredInstruments]->DeleteDuplicates[
                  Cases[
                    Cases[
                      DeleteDuplicates[Cases[Normal[inoculateProtocolPacket,Association],_Resource,Infinity]],
                      Resource[KeyValuePattern[Type->Object[Resource, Instrument]]]
                    ],
                    Except[Alternatives@@resourcesNotToPickUpFront]
                  ]
                ]
              |>
            },First];

            (* Return the protocol packet *)
            {
              fullInoculateProtocolPacket,
              Null,
              Null,
              currentSimulation,
              Null
            }
          ]
      ]
    ],
    Module[{},
      (* If we are robotic then we can only be SolidMedia or LiquidMedia *)
      Switch[resolvedInoculationSource,
        SolidMedia,
        Module[{},

          (* Call the pick resource packets to get the batched unit operation packets *)
          pickColoniesResourcePackets[
            mySamples,
            myUnresolvedOptions,
            myResolvedOptions,
            ExperimentInoculateLiquidMedia,
            Output -> outputSpecification,
            Cache -> inheritedCache,
            Simulation -> currentSimulation
          ]
        ],
        LiquidMedia,
        Module[
          {
            transferPrimitive,roboticUnitOperationPackets,roboticSimulation,runTime,
            outputUnitOperationPacket
          },

          (* Make the transfer primitive *)
          transferPrimitive = Transfer[
            Source -> mySamples,
            Destination -> resolvedDestinationMediaContainer,
            Amount -> resolvedVolume,
            TransferEnvironment -> resolvedTransferEnvironment,
            DispenseMix -> resolvedDestinationMix,
            DispenseMixType -> resolvedDestinationMixType,
            DispenseMixVolume -> resolvedDestinationMixVolume,
            NumberOfDispenseMixes -> resolvedDestinationNumberOfMixes,
            DestinationWell -> resolvedDestinationWell,
            Tips -> resolvedTips,
            TipType -> resolvedTipType,
            TipMaterial -> resolvedTipMaterial,
            AspirationMix -> resolvedSourceMix,
            AspirationMixType -> resolvedSourceMixType,
            AspirationMixVolume -> resolvedSourceMixVolume,
            NumberOfAspirationMixes -> resolvedNumberOfSourceMixes,
            PipettingMethod -> resolvedPipettingMethod
          ];

          (* Get our robotic unit operation packets. *)
          {{roboticUnitOperationPackets,runTime}, roboticSimulation}=ExperimentRoboticCellPreparation[
            transferPrimitive,
            UnitOperationPackets -> True,
            Output->{Result, Simulation},
            FastTrack -> Lookup[myResolvedOptions, FastTrack],
            ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol],
            Name -> Lookup[myResolvedOptions, Name],
            Simulation -> currentSimulation,
            Upload -> False,
            ImageSample -> Lookup[myResolvedOptions, ImageSample],
            MeasureVolume -> Lookup[myResolvedOptions, MeasureVolume],
            MeasureWeight -> Lookup[myResolvedOptions, MeasureWeight],
            Priority -> Lookup[myResolvedOptions, Priority],
            StartDate -> Lookup[myResolvedOptions, StartDate],
            HoldOrder -> Lookup[myResolvedOptions, HoldOrder],
            QueuePosition -> Lookup[myResolvedOptions, QueuePosition]
          ];

          (* Create our own output unit operation packet, linking up the "sub" robotic unit operation objects. *)
          outputUnitOperationPacket=UploadUnitOperation[
            Module[{nonHiddenOptions},
              nonHiddenOptions=allowedKeysForUnitOperationType[Object[UnitOperation,InoculateLiquidMedia]];
              (* Override any options with resource. *)
              InoculateLiquidMedia@Join[
                Cases[Normal[myResolvedOptions], Verbatim[Rule][Alternatives@@nonHiddenOptions, _]],
                {
                  Sample->mySamples,
                  RoboticUnitOperations->(Link/@Lookup[roboticUnitOperationPackets, Object])
                }
              ]
            ],
            UnitOperationType->Output,
            Upload->False
          ];

          (* Get the final updated simulation *)
          roboticSimulation=UpdateSimulation[
            roboticSimulation,
            Module[{protocolPacket},
              protocolPacket=<|
                Object->SimulateCreateID[Object[Protocol,RoboticCellPreparation]],
                Replace[OutputUnitOperations]->(Link[Lookup[outputUnitOperationPacket,Object], Protocol]),
                ResolvedOptions->{}
              |>;

              SimulateResources[protocolPacket, {outputUnitOperationPacket}, ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null], Simulation->currentSimulation]
            ]
          ];

          (* Return the packets and simulation *)
          {
            Null,
            Flatten[{outputUnitOperationPacket,roboticUnitOperationPackets}],
            {},
            roboticSimulation,
            (* Add 10 mins to the robotic run time *)
            (runTime + 10 Minute)
          }
        ]
      ]
    ]
  ];

  (*--Gather all the resource symbolic representations--*)

  (* Need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
  rawResourceBlobs=Which[
    MatchQ[resolvedPreparation,Robotic] && MatchQ[resolvedInoculationSource, SolidMedia],
      DeleteDuplicates[Cases[{unitOperationPackets,batchedUnitOperationPackets},_Resource,Infinity]],
    MatchQ[resolvedPreparation,Robotic] && MatchQ[resolvedInoculationSource, LiquidMedia],
      {},
    True,
      DeleteDuplicates[Cases[Flatten[Values[protocolPacket]],_Resource,Infinity]]
  ];

  (* Get all resources without a name *)
  resourcesWithoutName=DeleteDuplicates[Cases[rawResourceBlobs,Resource[_?(MatchQ[KeyExistsQ[#,Name],False]&)]]];
  resourceToNameReplaceRules=MapThread[#1->#2&,{resourcesWithoutName,(Resource[Append[#[[1]],Name->CreateUUID[]]]&)/@resourcesWithoutName}];
  allResourceBlobs=rawResourceBlobs/.resourceToNameReplaceRules;


  (*---Call fulfillableResourceQ on all the resources we created---*)
  {fulfillable,frqTests}=Which[
    MatchQ[$ECLApplication,Engine],{True,{}},
    (* When Preparation->Robotic, the framework will call FRQ for us *)
    MatchQ[resolvedPreparation,Robotic],{True,{}},
    gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Cache->inheritedCache,Simulation->simulation],
    True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Messages->messages,Cache->inheritedCache,Simulation->simulation],Null}
  ];


  (*---Return our options, packets, and tests---*)

  (* Generate the preview output rule; Preview is always Null *)
  previewRule=Preview->Null;

  (* Generate the options output rule *)
  optionsRule=Options->If[MemberQ[output,Options],
    resolvedOptionsNoHidden,
    Null
  ];

  (* Generate the result output rule: if not returning result, or the resources are not fulfillable, result rule is just $Failed *)
  resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
    {protocolPacket, unitOperationPackets, batchedUnitOperationPackets, currentSimulation, roboticRunTime}/.resourceToNameReplaceRules,
    $Failed
  ];

  (* Generate the tests output rule *)
  testsRule=Tests->If[gatherTests,
    frqTests,
    {}
  ];

  (* Return the output as we desire it *)
  outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}

];


(* ::Subsection:: *)
(*Simulation Function*)
DefineOptions[simulateInoculateLiquidMedia,
  Options :> {
    CacheOption, SimulationOption, ParentProtocolOption
  }
];

simulateInoculateLiquidMedia[
  myProtocolPacket : PacketP[Object[Protocol, InoculateLiquidMedia]] | $Failed,
  mySamples : {ObjectP[Object[Sample]]..},
  myResolvedOptions : {_Rule..},
  myResolutionOptions : OptionsPattern[simulateInoculateLiquidMedia]
] := Module[
  {
    inheritedCache,currentSimulation,inheritedFastAssoc,protocolObject, resolvedPreparation,inoculationSource,
    destinationMediaContainers,destinationMedia,containerContentsPackets,sampleContainerPackets,
    sanitizedDestinationMediaContainers,sanitizedDestinationMedia,containerFastAssoc,
    resolvedInoculationSource, resolvedDestinationWell,resolvedMediaVolume,resolvedVolumes,
    destsNoSample, uploadSamplePackets,containerPackets, destinationSamples,
    mediaTransferTuples,sampleTransferTuples,allTuples,uploadSampleTransferPackets,
    simulatedSamplesOut,simulatedLabels, destinationMediaContainerFootprints, plateSeal,
    destContainerToPlateSealRules, coverSimulation
  },

  (* Get simulation and cache *)
  {inheritedCache, currentSimulation} = Lookup[ToList[myResolutionOptions],{Cache, Simulation},{}];

  (* Create a faster version of the cache to improve speed *)
  inheritedFastAssoc = makeFastAssocFromCache[inheritedCache];

  (* Get our protocol ID. This should already be in the protocol packet, unless option resolver or  *)
  (* resource packets failed, then we have to simulate a new id *)
  protocolObject = If[MatchQ[myProtocolPacket, $Failed],
    SimulateCreateID[Object[Protocol,InoculateLiquidMedia]],
    Lookup[myProtocolPacket,Object]
  ];

  (* Lookup the resolved preparation (it should always be Manual) *)
  resolvedPreparation = Lookup[myResolvedOptions, Preparation];

  (* Lookup the InoculationSource *)
  inoculationSource = Lookup[myResolvedOptions,InoculationSource];

  (* Simulate the fulfillment of all resources by the procedure *)
  currentSimulation = Which[
    (* If we have a $Failed for the protocol packet, that means we had a problem in option resolver *)
    (* and skipped resource packet generation. *)
    MatchQ[myProtocolPacket,$Failed],
      Module[
        {
          samplesInResources, containersIn, uniqueContainersIn, containersInResources,
          mediaVolumeAssociations,mediaToVolumeLookup,mediaResourceLookup,mediaResources,
          uniqueDestinationContainerObjects,destinationContainerObjectResourceLookup,destinationContainerResources,
          protocolPacket
        },
        (* Just create a shell of a protocol object so we can return something back *)
        (* We do this by creating (and then simulating) the resources we need to simulate the movement *)
        (* Of samples by the end of the experiment *)

        (* 0. Download any information needed to create the resources *)
        {
          containersIn
        } = Quiet[
          Download[
            {
              mySamples
            },
            {
              Container[Object]
            },
            Cache->inheritedCache,
            Simulation->currentSimulation
          ],
          {Download::FieldDoesntExist}
        ];

        (* 1. Make resources for our SamplesIn *)
        (* NOTE: This step is copied from the resource packets *)
        samplesInResources = If[MatchQ[Lookup[myResolvedOptions, InoculationSource], LiquidMedia],
          Module[
            {
              samplesInVolumesRequired,samplesInAndVolumes,samplesInResourceReplaceRules
            },
            (* Calculate the total volume we need of each sample in. It is just the volume we are transferring  *)
            samplesInVolumesRequired = resolvedVolume;

            (* Pair up each sample with its volume *)
            samplesInAndVolumes = Merge[MapThread[Association[#1->#2]&, {mySamples, samplesInVolumesRequired}],Total];

            (* Create a resource rule for each unique sample *)
            samplesInResourceReplaceRules = KeyValueMap[Function[{sample,volume},
              sample -> Resource[Sample -> sample, Amount -> volume, Name -> CreateUUID[]]
            ],
              samplesInAndVolumes
            ];

            (* Use the replace rules *)
            mySamples /. samplesInResourceReplaceRules;
          ],
          Module[
            {
              samplesInResourceReplaceRules
            },
            (* Create a resource rule for each unique sampleIn *)
            samplesInResourceReplaceRules = (#->Resource[Sample -> #, Name -> CreateUUID[]])&/@DeleteDuplicates[mySamples];

            (* Use the replace rules *)
            mySamples /. samplesInResourceReplaceRules;
          ]
        ];

        (* 2. Make Resources for our ContainersIn *)
        (* NOTE: This step is copied from the resource packets *)
        (* Get the unique container in *)
        uniqueContainersIn=DeleteDuplicates[Flatten[containersIn]];

        (* Create container in resources *)
        containersInResources = Map[Function[{container},Link[container,Protocols]],uniqueContainersIn];

        (* 3. Create DestinationMedia Resources *)
        (* NOTE: This step is copied from the resource packets *)
        (* Get the volume of media we need for each input sample *)
        mediaVolumeAssociations = MapThread[<|#1->#2|>&,{Download[Lookup[myResolvedOptions,DestinationMedia],Object], Lookup[myResolvedOptions,MediaVolume]}];

        (* Total the media volumes across all input samples *)
        mediaToVolumeLookup = Merge[mediaVolumeAssociations,Total];

        (* Create a resource lookup for each unique media *)
        mediaResourceLookup = KeyValueMap[
          Function[{object,volume},
            (* need to specify a container if we're doing water prep *)
            (* otherwise we want to minimize transfers and thus don't want to specify container; just pick it in whatever it's already in *)
            object -> If[MatchQ[object, WaterModelP],
              Resource[Sample->object, Container -> PreferredContainer[volume], Amount -> volume, Name -> "ExperimentInoculateLiquidMedia DestinationMedia " <> CreateUUID[]],
              Resource[Sample->object, Amount -> volume, Name -> "ExperimentInoculateLiquidMedia DestinationMedia " <> CreateUUID[]]
            ];

          ],
          mediaToVolumeLookup
        ];

        (* Use the media lookup to create get the ordered list of resources *)
        mediaResources = Lookup[myResolvedOptions, DestinationMedia] /. mediaResourceLookup;

        (* 4. Create DestinationContainer Resources *)
        (* Get the Unique DestinationContainer Objects *)
        (* NOTE: Have the extra replace rule to handle the case of a list of objects. (this will have errored in the option resolver, but can't crash here) *)
        uniqueDestinationContainerObjects = DeleteDuplicates[Cases[Lookup[myResolvedOptions,DestinationMediaContainer]/.{x_List :> First[x]},ObjectP[Object[Container]]]];

        (* Create a resource lookup for the unique containers *)
        destinationContainerObjectResourceLookup = # -> Resource[Sample -> #, Name -> "ExperimentInoculateLiquidMedia DestinationContainer " <> CreateUUID[]]&/@uniqueDestinationContainerObjects;

        (* Get a list of destination container resources - Each Model[Container] gets its own resource *)
        destinationContainerResources = Map[
          Function[{container},
            If[MatchQ[container,ObjectP[Object[Container]]],
              container /. destinationContainerObjectResourceLookup,
              Resource[Sample -> container, Name -> "ExperimentInoculateLiquidMedia DestinationContainer " <> CreateUUID[]]
            ]
          ],
          Lookup[myResolvedOptions,DestinationMediaContainer]
        ];

        (* Put together a shell of a protocol *)
        protocolPacket = <|
          (* Organizational Information *)
          Object -> protocolObject,
          Type -> Object[Protocol, InoculateLiquidMedia],
          ResolvedOptions -> myResolvedOptions,
          Replace[SamplesIn] -> Map[Link[#,Protocols]&,samplesInResources],
          Replace[ContainersIn] -> containersInResources,

          (* Destination Information *)
          Replace[DestinationMedia] -> Link /@ mediaResources,
          Replace[DestinationMediaContainers] -> Link /@ destinationContainerResources
        |>;

        (* Simulate the Resources and return *)
        SimulateResources[
          protocolPacket,
          Simulation -> currentSimulation
        ]

      ],
    (* Otherwise, resource packets went fine. Just Simulate the resource picking *)
    True,
      SimulateResources[
        myProtocolPacket,
        ParentProtocol -> Lookup[ToList[myResolutionOptions], ParentProtocol, Null],
        Simulation -> currentSimulation
      ]
  ];

  (* We need to create a series of upload sample transfer tuples *)
  (* First, if InoculationSource is AgarStab, we need to transfer the destination media into the destination well of the destination media container *)
  (* Then we need to either transfer a small (5 Microliter) amount, or volume of sample into the *)
  (* destination well of the destination media container *)

  (* 1. First, extract our simulated resources from the protocol object *)
  {
    {{
      destinationMediaContainers,
      destinationMediaContainerFootprints,
      destinationMedia,
      containerContentsPackets,
      plateSeal
    }},
    sampleContainerPackets
  } = Quiet[
    Download[
      {
        {protocolObject},
        mySamples
      },
      {
        {
          DestinationMediaContainers,
          DestinationMediaContainers[Model][Footprint],
          DestinationMedia,
          Packet[DestinationMediaContainers[Contents]],
          PlateSeal
        },
        {Packet[Container]}
      },
      Cache -> inheritedCache,
      Simulation -> currentSimulation
    ],
    {Download::FieldDoesntExist}
  ];

  (* Sanitize the download output  *)
  sanitizedDestinationMediaContainers = Download[Flatten[destinationMediaContainers],Object];
  sanitizedDestinationMedia = Download[Flatten[destinationMedia],Object];

  (* Create a fast lookup of the container contents *)
  containerFastAssoc = makeFastAssocFromCache[FlattenCachePackets[{containerContentsPackets,sampleContainerPackets}]];

  (* 2. Extract any other info from the resolved options *)
  {
    resolvedInoculationSource,
    resolvedDestinationWell,
    resolvedMediaVolume,
    resolvedVolumes
  } = Lookup[
    myResolvedOptions,
    {
      InoculationSource,
      DestinationWell,
      MediaVolume,
      Volume
    }
  ];

  (* 3. Make sure all destinations have an Object[Sample]  *)
  (* First, pick out any destinations that do not have an object sample *)
  destsNoSample = MapThread[
    Function[{container,well},
      Module[{containerContents},
        (* Lookup the contents of the container *)
        containerContents = fastAssocLookup[containerFastAssoc,container,Contents];

        (* If there is an object sample at the well in question, skip, otherwise *)
        (* record the well, container pairing *)
        If[!NullQ[FirstCase[containerContents, {well, ObjectP[Object[Sample]]}, Null]],
          Nothing,
          {well, container}
        ]
      ]
    ],
    {
      sanitizedDestinationMediaContainers,
      resolvedDestinationWell
    }
  ];

  (* Upload an empty sample to all of those locations *)
  uploadSamplePackets = UploadSample[
    ConstantArray[{}, Length[destsNoSample]],
    destsNoSample,
    State -> Liquid,
    InitialAmount -> ConstantArray[Null, Length[destsNoSample]],
    UpdatedBy -> protocolObject,
    Simulation -> currentSimulation,
    SimulationMode -> True,
    FastTrack -> True,
    Upload -> False
  ];

  (* Update the simulation *)
  currentSimulation = UpdateSimulation[currentSimulation,Simulation[uploadSamplePackets]];

  (* Retrieve samples inside all containers of interest *)
  containerPackets = Download[
    sanitizedDestinationMediaContainers,
    Packet[Contents],
    Cache -> inheritedCache,
    Simulation -> currentSimulation
  ];

  (* Convert, {well, container} pairs to the corresponding sample *)
  destinationSamples = MapThread[
    Function[{containerPacket,well},
      Download[Last[FirstCase[Lookup[containerPacket,Contents], {well, _}]],Object]
    ],
    {
      containerPackets,
      resolvedDestinationWell
    }
  ];

  (* 4. Create the first set of transfer tuples (Media into destination container) if - Necessary *)
  mediaTransferTuples = If[MatchQ[inoculationSource, AgarStab],
    MapThread[
      Function[{mediaObject, destinationSample, mediaVolume},
        {mediaObject, destinationSample, mediaVolume}
      ],
      {
        sanitizedDestinationMedia,
        destinationSamples,
        resolvedMediaVolume
      }
    ],
    {}
  ];

  (* 5. Create the second set of transfer tuples (Sample into destination container) *)
  (* If InoculationSource is LiquidMedia, transfer the given volume *)
  (* If InoculationSouce is anything else (should only be AgarStab, but in the case of errors *)
  (* could be SolidMedia or Null, transfer 5 Microliter *)
  sampleTransferTuples = Module[{volumesToTransfer},

    (* Determine the volume to use (described above) *)
    volumesToTransfer = If[MatchQ[resolvedInoculationSource, LiquidMedia],
      resolvedVolumes,
      ConstantArray[5 Microliter, Length[mySamples]]
    ];

    (* Create the tuples *)
    MapThread[{#1,#2,#3}&,{mySamples,destinationSamples,volumesToTransfer}]
  ];

  (* 6. Combine the tuples and call UploadSampleTransfer *)
  allTuples = Join[mediaTransferTuples,sampleTransferTuples];

  uploadSampleTransferPackets = UploadSampleTransfer[
    allTuples[[All,1]],
    allTuples[[All,2]],
    allTuples[[All,3]],
    Upload -> False,
    FastTrack -> True,
    Simulation -> currentSimulation
  ];

  (* Update the simulation *)
  currentSimulation = UpdateSimulation[currentSimulation, Simulation[uploadSampleTransferPackets]];

  (* 7. make sure the destination containers are covered.  If it's a plate, then use PlateSeal; otherwise stick with Automatic *)
  destContainerToPlateSealRules = DeleteDuplicates[MapThread[
    If[MatchQ[#2, Plate],
      #1 -> plateSeal,
      #1 -> Automatic
    ]&,
    {destinationMediaContainers, destinationMediaContainerFootprints}
  ]];
  coverSimulation = ExperimentCover[
    destinationMediaContainers,
    Cover -> destinationMediaContainers /. destContainerToPlateSealRules,
    Simulation -> currentSimulation,
    Output -> Simulation,
    FastTrack -> True
  ];

  (* Update the simulation, but ONLY the simulation packets.  Basically, I want to make sure the containers have covers on them, but I don't want to complicate things with the labels ExperimentCover comes up with *)
  currentSimulation = UpdateSimulation[currentSimulation, Simulation[Lookup[coverSimulation[[1]], Packets]]];

  (* 8. Update Labels *)
  (* The simulatedSamplesOut are the destination samples *)
  simulatedSamplesOut = destinationSamples;

  (* Label options *)
  simulatedLabels = Simulation[
    Labels->Join[
      Rule@@@Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], mySamples}],
        {_String, ObjectP[]}
      ],
      Rule@@@Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], fastAssocLookup[containerFastAssoc,#,Container]&/@mySamples}],
        {_String, ObjectP[]}
      ],
      Rule@@@Cases[
        Transpose[{Flatten@ToList[Lookup[myResolvedOptions, SampleOutLabel]], Flatten@simulatedSamplesOut}],
        {_String, ObjectP[]}
      ],
      Rule@@@Cases[
        Transpose[{Flatten@ToList[Lookup[myResolvedOptions, ContainerOutLabel]],sanitizedDestinationMediaContainers}],
        {_String, ObjectP[]}
      ]
    ],
    LabelFields->If[MatchQ[resolvedPreparation, Manual],
      Join[
        Rule@@@Cases[
          Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], (Field[Subprotocol[SampleResources][[#]]]&)/@Range[Length[mySamples]]}],
          {_String, _}
        ],
        Rule@@@Cases[
          Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], (Field[Subprotocol[SampleResources][[#]][Container]]&)/@Range[Length[mySamples]]}],
          {_String, _}
        ],
        Rule@@@Cases[
          Transpose[{Flatten@ToList[Lookup[myResolvedOptions, SampleOutLabel]], (Field[Subprotocol[SamplesOut[[#]]]]&)/@Range[Length[simulatedSamplesOut]]}],
          {_String, _}
        ],
        Rule@@@Cases[
          Transpose[{Flatten@ToList[Lookup[myResolvedOptions, ContainerOutLabel]], (Field[Subprotocol[ContainersOut][[#]]]&)/@Range[Length[simulatedSamplesOut]]}],
          {_String, _}
        ]
      ],
      {}
    ]
  ];

  (* Final update simulation and return *)
  {
    protocolObject,
    UpdateSimulation[currentSimulation,simulatedLabels]
  }

];


(* ::Subsection:: *)
(*workCellResolver Function*)
resolveInoculateLiquidMediaWorkCell[
  myInputs:ListableP[ObjectP[{Object[Sample],Object[Container]}]],
  myOptions:OptionsPattern[]
]:=Module[
  {workCell,cache,simulation,cacheLookup,inputStatesAndContainers},

  (* Lookup the workcell option *)
  workCell=Lookup[myOptions,WorkCell,Automatic];

  (* Lookup the cache and simulation *)
  cache = Lookup[myOptions,Cache,{}];
  simulation = Lookup[myOptions,Simulation,Null];

  (* Make fast assoc lookup from the cache *)
  cacheLookup = Experiment`Private`makeFastAssocFromCache[cache];

  (* Get the states of the input samples *)
  inputStatesAndContainers = If[MatchQ[cache,{}],
    (* If the cache is empty, default to Null (LiquidHandler) *)
    Null,

    (* Otherwise, Lookup the state of the input samples *)
    Module[{containerInputs,allSamples,sampleStates,sampleContainers},

      containerInputs = Cases[ToList[myInputs],ObjectP[Object[Container]]];

      (* Get all the samples (even those specified as containers) *)
      allSamples = Join[
        Cases[ToList[myInputs],ObjectP[Object[Sample]]],
        Quiet[Download[Cases[Flatten[fastAssocLookup[cacheLookup,containerInputs,Contents][[All,All,2]]],ObjectP[Object[Sample]]],Object]]
      ];

      (* Get the state from all of the input samples *)
      sampleStates = fastAssocLookup[cacheLookup,allSamples,State];
      sampleContainers = fastAssocLookup[cacheLookup,allSamples,Container];

      (* Filter out the bad states - an error for this will be thrown later *)
      MapThread[
        Function[{state,container},
          (* Ignore if the state is not Liquid or Solid *)
          If[!MatchQ[state,Liquid|Solid],
            Nothing,
            {state,Download[container,Object]}
          ]
        ],
        {sampleStates,sampleContainers}
      ]
    ]

  ];

  (* Determine the WorkCell that can be used *)
  If[MatchQ[workCell,Except[Automatic]],
    {workCell},
    Which[
      (* If the InoculationSource is SolidMedia - use the qPix *)
      MatchQ[Lookup[myOptions,InoculationSource],SolidMedia],
        {qPix},
      (* If the InoculationSource is LiquidMedia, use the microbioSTAR *)
      MatchQ[Lookup[myOptions,InoculationSource],LiquidMedia],
        {microbioSTAR},
      (* Only solid state and plates in the input *)
      MatchQ[inputStatesAndContainers,ListableP[{Solid,ObjectP[Object[Container,Plate]]}]],
        {qPix},
      (* Only Liquid state in the input *)
      MatchQ[inputStatesAndContainers,ListableP[{Liquid,_}]],
        {microbioSTAR},
      (* Anything else is an error so just default to the microbioSTAR *)
      True,
        {}
    ]
  ]
];
(* ::Subsection:: *)
(* Sister Functions *)

(* ::Subsubsection:: *)
(* ExperimentInoculateLiquidMediaOptions *)
DefineOptions[ExperimentInoculateLiquidMediaOptions,
  Options:>{
    {
      OptionName->OutputFormat,
      Default->Table,
      AllowNull->False,
      Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
      Description->"Indicates whether the function returns a table or a list of the options."
    }
  },
  SharedOptions:>{ExperimentInoculateLiquidMedia}
];


ExperimentInoculateLiquidMediaOptions[
  myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
  myOptions:OptionsPattern[ExperimentInoculateLiquidMediaOptions]
]:=Module[
  {listedOptions,preparedOptions,resolvedOptions},

  (*Get the options as a list*)
  listedOptions=ToList[myOptions];

  (*Send in the correct Output option and remove the OutputFormat option*)
  preparedOptions=Normal[KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}],Association];

  resolvedOptions=ExperimentInoculateLiquidMedia[myInputs,preparedOptions];

  (*Return the option as a list or table*)
  If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
    LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentInoculateLiquidMedia],
    resolvedOptions
  ]
];

(* ::Subsubsection:: *)
(* ValidExperimentInoculateLiquidMediaQ *)
DefineOptions[ValidExperimentInoculateLiquidMediaQ,
  Options:>{VerboseOption,OutputFormatOption},
  SharedOptions:>{ExperimentInoculateLiquidMedia}
];


ValidExperimentInoculateLiquidMediaQ[
  myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
  myOptions:OptionsPattern[ValidExperimentInoculateLiquidMediaQ]
]:=Module[
  {listedOptions,preparedOptions,experimentInoculateLiquidMediaTests,initialTestDescription,allTests,verbose,outputFormat},

  (*Get the options as a list*)
  listedOptions=ToList[myOptions];

  (*Remove the output option before passing to the core function because it doesn't make sense here*)
  preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

  (*Call the ExperimentInoculateLiquidMedia function to get a list of tests*)
  experimentInoculateLiquidMediaTests=Quiet[
    ExperimentInoculateLiquidMedia[myInputs,Append[preparedOptions,Output->Tests]],
    {LinkObject::linkd,LinkObject::linkn}
  ];

  (*Define the general test description*)
  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (*Make a list of all of the tests, including the blanket test*)
  allTests=If[MatchQ[experimentInoculateLiquidMediaTests,$Failed],
    {Test[initialTestDescription,False,True]},
    Module[{initialTest,validObjectBooleans,voqWarnings},

      (*Generate the initial test, which should pass if we got this far*)
      initialTest=Test[initialTestDescription,True,True];

      (*Create warnings for invalid objects*)
      validObjectBooleans=ValidObjectQ[Cases[Flatten[myInputs],ObjectP[]],OutputFormat->Boolean];

      voqWarnings=MapThread[
        Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
          #2,
          True
        ]&,
        {Cases[Flatten[myInputs],ObjectP[]],validObjectBooleans}
      ];

      (*Get all the tests/warnings*)
      Cases[Flatten[{initialTest,experimentInoculateLiquidMediaTests,voqWarnings}],_EmeraldTest]
    ]
  ];

  (*Look up the test-running options*)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (*Run the tests as requested*)
  Lookup[RunUnitTest[<|"ValidExperimentInoculateLiquidMediaQ"->allTests|>,Verbose->verbose,
    OutputFormat->outputFormat],"ValidExperimentInoculateLiquidMediaQ"]
];