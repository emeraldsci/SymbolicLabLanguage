(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(* ExperimentStreakCells *)
DefineTests[ExperimentStreakCells,
  {
    Example[{Options,InoculationSource,"InoculationSource is automatically set to LiquidMedia if the state of the input sample is Liquid and the storage condition is not DeepFreezer or Cryogenic:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        StreakVolume -> 50 Microliter
      ];
      Download[protocol,OutputUnitOperations[[1]][InoculationSource]],
      LiquidMedia
    ],
    Example[{Options,InoculationSource,"InoculationSource is automatically set to FreezeDried if the state of the input sample is Solid and the sample container is an ampoule:"},
      protocol = ExperimentStreakCells[
        Object[Sample, "Test Sample 20 for ExperimentStreakCells (freeze dried cell 1 in ampoule 1)" <> $SessionUUID],
        StreakVolume -> 50 Microliter
      ];
      Download[protocol,OutputUnitOperations[[1]][InoculationSource]],
      FreezeDried
    ],
    Example[{Options,InoculationSource,"InoculationSource is automatically set to FrozenGlycerol if the state of the input sample is Liquid and the storage condition is DeepFreezer or Cryogenic:"},
      protocol = ExperimentStreakCells[
        Object[Sample, "Test Sample 22 for ExperimentStreakCells (cell 1 in frozen glycerol in cryoVial 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][InoculationSource]],
      FrozenGlycerol
    ],
    Example[{Options,{ResuspensionMedia, ResuspensionMediaVolume, ResuspensionContainer, ResuspensionContainerWell,ResuspensionMix, NumberOfResuspensionMixes, ResuspensionMixVolume, NumberOfSourceScrapes},"If the source is freeze dried, unless otherwise specified, 1) ResuspensionMedia is set to the PreferredLiquidMedia of the cell model, 2) ResuspensionMediaVolume is set to 1/4 of the sample container's max volume, 3) ResuspensionContainer is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate, Sterile\"] if ResuspensionMediaVolume is not specified, 4) ResuspensionContainerWell is set to the first available position in the container, 5) ResuspensionMix is set to True, 6) NumberOfResuspensionMixes is set to 5, 6) ResuspensionMixVolume is set to 1/2 of the ResuspensionMediaVolume, and 7) NumberOfSourceScrapes is set to Null:"},
     protocol = ExperimentStreakCells[Object[Sample, "Test Sample 20 for ExperimentStreakCells (freeze dried cell 1 in ampoule 1)" <> $SessionUUID]];
     Download[protocol, OutputUnitOperations[[1]][{ResuspensionMediaLink, ResuspensionMediaVolume, ResuspensionContainerLink, ResuspensionContainerWell,ResuspensionMix, NumberOfResuspensionMixes, ResuspensionMixVolume, NumberOfSourceScrapes}]],
      {
        {ObjectP[Model[Sample, Media, "id:XnlV5jlXbNx8"](*"LB Broth, Miller"*)]},
        {EqualP[0.5 Milliliter]}, {ObjectP[Model[Container, Plate, "id:4pO6dMmErzez"](*"Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"*)]}, {"A1"}, {True}, {EqualP[5]}, {EqualP[0.25 Milliliter]}, {Null}
      }
    ],
    Example[{Options,{ResuspensionMedia, ResuspensionMediaVolume, ResuspensionContainer, ResuspensionContainerWell,ResuspensionMix, NumberOfResuspensionMixes, ResuspensionMixVolume, NumberOfSourceScrapes},"If the source is frozen glycerol, unless otherwise specified, 1) ResuspensionMedia is set to the PreferredLiquidMedia of the cell model, 2) ResuspensionMediaVolume is set to 1/4 of the ResuspensionContainer's max volume, 3) ResuspensionContainer is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate, Sterile\"] if ResuspensionMediaVolume is not specified, 4) ResuspensionContainerWell is set to the first available position in the container, 5) ResuspensionMix is set to True, 6) NumberOfResuspensionMixes is set to 5, 6) ResuspensionMixVolume is set to 1/2 of the ResuspensionMediaVolume, and 7) NumberOfSourceScrapes is set to 5:"},
      protocol = ExperimentStreakCells[Object[Sample, "Test Sample 22 for ExperimentStreakCells (cell 1 in frozen glycerol in cryoVial 1)" <> $SessionUUID]];
      Download[protocol, OutputUnitOperations[[1]][{ResuspensionMediaLink, ResuspensionMediaVolume, ResuspensionContainerLink, ResuspensionContainerWell,ResuspensionMix, NumberOfResuspensionMixes, ResuspensionMixVolume, NumberOfSourceScrapes}]],
      {
        {ObjectP[Model[Sample, Media, "id:XnlV5jlXbNx8"](*"LB Broth, Miller"*)]},
        {EqualP[0.5 Milliliter]}, {ObjectP[Model[Container, Plate, "id:4pO6dMmErzez"](*"Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"*)]}, {"A1"}, {True}, {EqualP[5]}, {EqualP[0.25 Milliliter]}, {EqualP[5]}
      }
    ],
    Example[{Options,{ResuspensionMedia, ResuspensionMediaVolume, ResuspensionContainer, ResuspensionContainerWell,ResuspensionMix, NumberOfResuspensionMixes, ResuspensionMixVolume, NumberOfSourceScrapes},"If the source is liquid media, unless otherwise specified, all resuspension options are set to Null:"},
      protocol = ExperimentStreakCells[Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]];
      Download[protocol, OutputUnitOperations[[1]][{ResuspensionMediaLink, ResuspensionMediaVolume, ResuspensionContainerLink, ResuspensionContainerWell,ResuspensionMix, NumberOfResuspensionMixes, ResuspensionMixVolume, NumberOfSourceScrapes}]],
      {({Null}|{})..}
    ],
    Example[{Options,StreakVolume,"Specify the amount of cells in suspension to streak on the destination container:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        StreakVolume -> 50 Microliter
      ];
      Download[protocol,OutputUnitOperations[[1]][StreakVolume]],
      {RangeP[50 Microliter]}
    ],
    Example[{Options,SourceMix,"Specify whether cells in suspension are mixed by pipette before being streaked on the destination container:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        SourceMix -> True
      ];
      Download[protocol,OutputUnitOperations[[1]][SourceMix]],
      {True}
    ],
    Example[{Options,SourceMixVolume,"Specify the volume of cells in suspension to mix before being streaked on the destination container:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        SourceMixVolume -> 20 Microliter
      ];
      Download[protocol,OutputUnitOperations[[1]][SourceMixVolume]],
      {RangeP[20 Microliter]}
    ],
    Example[{Options,NumberOfSourceMixes,"Specify the number of times to mix the cells in suspension by pipette before being streaked on the destination container:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        NumberOfSourceMixes -> 3
      ];
      Download[protocol,OutputUnitOperations[[1]][NumberOfSourceMixes]],
      {3}
    ],
    Example[{Options,ColonyStreakingTool,"Specify the tool used to streak the cells in suspension on the destination container:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        ColonyStreakingTool -> Model[Part, ColonyHandlerHeadCassette, "1-pin spreading head"]
      ];
      Download[protocol,OutputUnitOperations[[1]][ColonyStreakingTool]],
      {ObjectP[Model[Part, ColonyHandlerHeadCassette, "1-pin spreading head"]]}
    ],
    Example[{Options,HeadDiameter,"Specify the diameter of the pin on the tool used to streak the cells in suspension on the destination container:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        HeadDiameter -> 3.52 Millimeter
      ];
      Download[protocol,OutputUnitOperations[[1]][HeadDiameter]],
      {RangeP[3.52 Millimeter]}
    ],
    Example[{Options,HeadLength,"Specify the length of the pin on the tool used to streak the cells in suspension on the destination container:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        HeadLength -> 10 Millimeter
      ];
      Download[protocol,OutputUnitOperations[[1]][HeadLength]],
      {RangeP[10 Millimeter]}
    ],
    Example[{Options,NumberOfHeads,"Specify the number of pins on the tool used to streak the cells in suspension on the destination container:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        NumberOfHeads -> 1
      ];
      Download[protocol,OutputUnitOperations[[1]][NumberOfHeads]],
      {1}
    ],
    Example[{Options,ColonyHandlerHeadCassetteApplication,"Specify the designed purpose of the tool used to streak the cells in suspension on the destination container:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        ColonyHandlerHeadCassetteApplication -> Spread
      ];
      Download[protocol,OutputUnitOperations[[1]][ColonyHandlerHeadCassetteApplication]],
      {Spread}
    ],
    Example[{Options,DispenseCoordinates,"Specify the designed purpose of the tool used to streak the cells in suspension on the destination container:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DispenseCoordinates -> {{1 Millimeter, 1 Millimeter}}
      ];
      Download[protocol,OutputUnitOperations[[1]][DispenseCoordinates]],
      {{{1 Millimeter, 1 Millimeter}}}
    ],
    Example[{Options,StreakPatternType,"Specify the pattern to streak the suspended colonies on the plate:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        StreakPatternType -> Radiant
      ];
      Download[protocol,OutputUnitOperations[[1]][StreakPatternType]],
      {Radiant}
    ],
    Example[{Options,CustomStreakPattern,"Specify a custom set of coordinates to describe how to streak the suspended colonies on the plate:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        StreakPatternType -> Custom,
        CustomStreakPattern -> Streak[{{1 Millimeter, 1 Millimeter},{2 Millimeter, 2 Millimeter}}]
      ];
      Download[protocol,OutputUnitOperations[[1]][CustomStreakPattern]],
      {Streak[{{1 Millimeter, 1 Millimeter}, {2 Millimeter, 2 Millimeter}}]}
    ],
    Example[{Options,CustomStreakPattern,"Specify a custom set of coordinates with multiple strokes to describe how to streak the suspended colonies on the plate:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        StreakPatternType -> Custom,
        CustomStreakPattern -> {
          Streak[{{1 Millimeter, 1 Millimeter},{2 Millimeter, 2 Millimeter}}],
          Streak[{{1 Millimeter, 1 Millimeter},{2 Millimeter, 2 Millimeter}}]
        }
      ];
      Download[protocol,OutputUnitOperations[[1]][CustomStreakPattern]],
      {
        {
          Streak[{{1 Millimeter, 1 Millimeter},{2 Millimeter, 2 Millimeter}}],
          Streak[{{1 Millimeter, 1 Millimeter},{2 Millimeter, 2 Millimeter}}]
        }
      }
    ],
    Example[{Options,DestinationContainer,"Specify the container to streak the suspended colonies in as an object:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DestinationContainer -> Object[Container,Plate,"Test Omnitray 1 for ExperimentStreakCells" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][DestinationContainerLink]],
      {ObjectP[Object[Container, Plate, "Test Omnitray 1 for ExperimentStreakCells" <> $SessionUUID]]}
    ],
    Example[{Options,DestinationContainer,"Specify the container to streak the suspended colonies in as a model:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DestinationContainer -> Model[Container, Plate, "id:O81aEBZjRXvx"]
      ];
      Download[protocol,OutputUnitOperations[[1]][DestinationContainerLink]],
      {ObjectP[Model[Container, Plate, "id:O81aEBZjRXvx"]]}
    ],
    Example[{Options,DestinationWell,"Specify the well in DestinationContainer the suspended colonies should be streaked in:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DestinationContainer -> Model[Container, Plate, "id:O81aEBZjRXvx"],
        DestinationWell -> "A1"
      ];
      Download[protocol,OutputUnitOperations[[1]][DestinationWell]],
      {"A1"}
    ],
    Example[{Options,DestinationMedia,"Specify the media to pour into the destination well of destination container which the colonies will be streaked on:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DestinationMedia -> Model[Sample, Media, "id:9RdZXvdwAEo6"]
      ];
      Download[protocol,OutputUnitOperations[[1]][DestinationMediaLink]],
      {ObjectP[Model[Sample, Media, "id:9RdZXvdwAEo6"]]}
    ],
    Example[{Options,SampleLabel,"Specify a label for the input sample:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        SampleLabel -> "My Favorite Sample"
      ];
      Download[protocol,OutputUnitOperations[[1]][SampleLabel]],
      {"My Favorite Sample"}
    ],
    Example[{Options,SampleContainerLabel,"Specify a label for the container of the input sample :"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        SampleContainerLabel -> "My Favorite Container"
      ];
      Download[protocol,OutputUnitOperations[[1]][SampleContainerLabel]],
      {"My Favorite Container"}
    ],
    Example[{Options,SampleOutLabel,"Specify labels for samples out:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        NumberOfDilutions -> 3,
        DilutionType -> Serial,
        DilutionStrategy -> Series,
        SampleOutLabel -> {
          "My sample 1","My sample 2","My sample 3","My sample 4"
        }
      ];
      Download[protocol,OutputUnitOperations[[1]][SampleOutLabel]],
      {{
        "My sample 1", "My sample 2", "My sample 3", "My sample 4"
      }}
    ],
    Example[{Options,ContainerOutLabel,"Specify labels for the containers out:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        NumberOfDilutions -> 3,
        DilutionType -> Serial,
        DilutionStrategy -> Series,
        ContainerOutLabel -> {
          "My container 1","My container 2","My container 3","My container 4"
        }
      ];
      Download[protocol,OutputUnitOperations[[1]][ContainerOutLabel]],
      {{
        "My container 1", "My container 2", "My container 3", "My container 4"
      }}
    ],
    (* Dilution Options *)
    Example[{Options,DilutionType,"DilutionType can be set to Linear:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Linear
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionType]],
      {Linear}
    ],
    Example[{Options,DilutionType,"DilutionType can be set to Serial:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionType]],
      {Serial}
    ],
    Example[{Options,NumberOfDilutions,"Perform multiple serial dilutions before streaking the cells:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        NumberOfDilutions -> 5
      ];
      Download[protocol,OutputUnitOperations[[1]][NumberOfDilutions]],
      {5}
    ],
    Example[{Options,NumberOfDilutions,"Perform multiple linear dilutions before streaking the cells (this essentially makes replicates):"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Linear,
        NumberOfDilutions -> 5
      ];
      Download[protocol,OutputUnitOperations[[1]][NumberOfDilutions]],
      {5}
    ],
    Example[{Options,DilutionStrategy,"Specify that the plating should be performed on the final output sample:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        DilutionStrategy -> Endpoint
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionStrategy]],
      {Endpoint}
    ],
    Example[{Options,DilutionStrategy,"Specify that the plating should be performed on the entire dilution series:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        DilutionStrategy -> Series
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionStrategy]],
      {Series}
    ],
    Example[{Options,DilutionTargetAnalyte,"Specify the cell model whose concentration should be taken into account when calculating dilutions prior to plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionTargetAnalyte -> Model[Cell,Bacteria,"Test Cell 1 for ExperimentStreakCells" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionTargetAnalyte]],
      {ObjectP[Model[Cell, Bacteria, "Test Cell 1 for ExperimentStreakCells" <> $SessionUUID]]}
    ],
    Example[{Options,CumulativeDilutionFactor,"Specify factor to dilute the cells by specifying the dilution factor in relation to the original sample:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        DilutionStrategy -> Endpoint,
        StreakVolume -> 10 Microliter,
        CumulativeDilutionFactor -> {{1.5,2,3}}
      ];
      Download[protocol,OutputUnitOperations[[1]][CumulativeDilutionFactor]],
      {{1.5,2,3}}
    ],
    Example[{Options,SerialDilutionFactor,"Specify factor to dilute the cells by specifying the dilution factor in relation to the previously diluted sample:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        DilutionStrategy -> Endpoint,
        StreakVolume -> 10 Microliter,
        SerialDilutionFactor -> {{1.1, 1.5, 2}}
      ];
      Download[protocol,OutputUnitOperations[[1]][SerialDilutionFactor]],
      {{1.1, 1.5, 2}}
    ],
    Example[{Options,DilutionTargetAnalyteConcentration,"Specify factor to dilute the cells by specifying the desired final concentration of the cells:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        DilutionStrategy -> Endpoint,
        StreakVolume -> 10 Microliter,
        DilutionTargetAnalyteConcentration -> {{2500 Cell/Milliliter, 1000 Cell/Milliliter}}
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionTargetAnalyteConcentration]],
      {{2500 Cell/Milliliter, 1000 Cell/Milliliter}}
    ],
    Example[{Options,DilutionTransferVolume,"Specify the volume of sample to transfer into each linear dilution for the dilutions before plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Linear,
        StreakVolume -> 10 Microliter,
        DilutionTransferVolume -> {{100 Microliter, 150 Microliter, 175 Microliter}}
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionTransferVolume]],
      {{100 Microliter, 150 Microliter, 175 Microliter}}
    ],
    Example[{Options,DilutionTransferVolume,"Specify the volume of sample to transfer from one stage to the next for the serial dilutions before plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        StreakVolume -> 10 Microliter,
        DilutionTransferVolume -> {{150 Microliter, 150 Microliter, 150 Microliter}}
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionTransferVolume]],
      {{150 Microliter, 150 Microliter, 150 Microliter}}
    ],
    Example[{Options,TotalDilutionVolume,"Specify the total sum of volume in each dilution sample (sum of sample, diluent, concentrated buffer, and concentrated buffer diluent) for the dilutions prior to plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        NumberOfDilutions -> 2,
        TotalDilutionVolume -> {{1 Milliliter, 1.5 Milliliter}}
      ];
      Download[protocol,OutputUnitOperations[[1]][TotalDilutionVolume]],
      {{1 Milliliter, 1.5 Milliliter}}
    ],
    Example[{Options,DilutionFinalVolume,"Specify the volume left in each sample at the end of the dilution series for the dilutions prior to plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        NumberOfDilutions -> 2,
        DilutionFinalVolume -> {{1 Milliliter, 1 Milliliter}}
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionFinalVolume]],
      {{1 Milliliter, 1 Milliliter}}
    ],
    Example[{Options,DilutionDiscardFinalTransfer,"Specify whether if for the last dilution in series, TransferVolume should be removed after the dilution, for the dilutions prior to plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        NumberOfDilutions -> 4,
        DilutionDiscardFinalTransfer -> False
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionDiscardFinalTransfer]],
      {False}
    ],
    Example[{Options,Diluent,"Specify the diluent to use to dilute the cells prior to plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        NumberOfDilutions -> 4,
        Diluent -> Model[Sample, Media, "LB (Liquid)"]
      ];
      Download[protocol,OutputUnitOperations[[1]][DiluentLink]],
      {ObjectP[Model[Sample, Media, "LB (Liquid)"]]}
    ],
    Example[{Options,DiluentVolume,"Specify the volume of diluent to use to dilute the cells prior to plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        NumberOfDilutions -> 4,
        StreakVolume -> 10 Microliter,
        DiluentVolume -> {{100 Microliter,100 Microliter,100 Microliter,100 Microliter}}
      ];
      Download[protocol,OutputUnitOperations[[1]][DiluentVolume]],
      {{100 Microliter, 100 Microliter, 100 Microliter, 100 Microliter}}
    ],
    Example[{Options,DilutionIncubate,"Specify whether the diluted samples should be mixed or incubated prior to plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        DilutionIncubate -> True
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionIncubate]],
      {True}
    ],
    Example[{Options,DilutionIncubationTime,"Specify the length of time the diluted samples should be mixed or incubated prior to plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        DilutionIncubationTime -> 1 Minute
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionIncubationTime]],
      {RangeP[1 Minute]}
    ],
    Example[{Options,DilutionIncubationInstrument,"Specify the instrument the diluted samples should be mixed or incubated with prior to plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Serial,
        DilutionIncubationInstrument -> Model[Instrument, Shaker, "Genie Temp-Shaker 300"]
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionIncubationInstrument]],
      {ObjectP[Model[Instrument, Shaker, "Genie Temp-Shaker 300"]]},
      Messages :> {Warning::AliquotRequired}
    ],
    Example[{Options,DilutionIncubationTemperature,"Specify the temperature the diluted samples should be mixed or incubated prior to plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Linear,
        DilutionIncubationTemperature -> 20 Celsius
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionIncubationTemperatureReal]],
      {RangeP[20 Celsius]}
    ],
    Example[{Options,DilutionMixType,"Specify how the diluted samples should be mixed prior to plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Linear,
        DilutionMixType -> Pipette
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionMixType]],
      {Pipette}
    ],
    Example[{Options,DilutionNumberOfMixes,"Specify the number of times diluted samples should be mixed or incubated prior to plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Linear,
        DilutionNumberOfMixes -> 10
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionNumberOfMixes]],
      {10}
    ],
    Example[{Options,DilutionMixRate,"Specify the rate the diluted samples should be mixed or incubated prior to plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Linear,
        DilutionMixRate -> 500 RPM,
        DilutionMixType -> Shake
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionMixRate]],
      {500 RPM}
    ],
    Example[{Options,DilutionMixOscillationAngle,"Specify the angle at which to mix by shaking the diluted samples should be mixed or incubated prior to plating:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 6 for ExperimentStreakCells (LB Broth in 50 mL Tube)" <> $SessionUUID],
        DilutionType -> Linear,
        DilutionIncubationInstrument -> Model[Instrument, Shaker, "Burrell Scientific Wrist Action Shaker"],
        DilutionMixOscillationAngle -> 8 AngularDegree
      ];
      Download[protocol,OutputUnitOperations[[1]][DilutionMixOscillationAngle]],
      {RangeP[8 AngularDegree]},
      Messages :> {Warning::AmbiguousAnalyte,Warning::AliquotRequired}
    ],
    (* Sanitization Options *)
    Example[{Options,PrimaryWash,"PrimaryWash will default to True if not specified:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][PrimaryWash]],
      {True}
    ],
    Example[{Options,PrimaryWash,"Setting PrimaryWash to False will turn off the other PrimaryWash options:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        PrimaryWash -> False
      ];
      Download[protocol,OutputUnitOperations[[1]][{PrimaryWash,PrimaryWashSolutionLink,NumberOfPrimaryWashes,PrimaryDryTime}]],
      {{False}, {Null}, {Null}, {Null}}
    ],
    Example[{Options,PrimaryWash,"Have different PrimaryWash specifications for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        PrimaryWash -> {True,False}
      ];
      Download[protocol,OutputUnitOperations[[1]][PrimaryWash]],
      {True, False}
    ],
    Example[{Options,PrimaryWashSolution,"The PrimaryWashSolution will automatically be set to Model[Sample,StockSolution,\"70% Ethanol\"]:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][PrimaryWashSolutionLink]],
      {ObjectP[Model[Sample, StockSolution, "70% Ethanol"]]}
    ],
    Example[{Options,PrimaryWashSolution,"Have different PrimaryWashSolution's for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        PrimaryWashSolution -> {Model[Sample,StockSolution,"70% Ethanol"],Model[Sample, "Milli-Q water"]}
      ];
      Download[protocol,OutputUnitOperations[[1]][PrimaryWashSolutionLink]],
      {ObjectP[Model[Sample, StockSolution, "70% Ethanol"]], ObjectP[Model[Sample, "Milli-Q water"]]}
    ],
    Example[{Options,NumberOfPrimaryWashes,"The NumberOfPrimaryWashes will automatically be set to 5:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][NumberOfPrimaryWashes]],
      {5}
    ],
    Example[{Options,NumberOfPrimaryWashes,"Have different NumberOfPrimaryWashes for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        NumberOfPrimaryWashes -> {3,2}
      ];
      Download[protocol,OutputUnitOperations[[1]][NumberOfPrimaryWashes]],
      {3,2}
    ],
    Example[{Options,PrimaryDryTime,"The PrimaryDryTime will automatically be set to 10 Seconds:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][PrimaryDryTime]],
      {RangeP[10 Second]}
    ],
    Example[{Options,PrimaryDryTime,"Have different PrimaryDryTime for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        PrimaryDryTime -> {2 Second, 5 Second}
      ];
      Download[protocol,OutputUnitOperations[[1]][PrimaryDryTime]],
      {RangeP[2 Second], RangeP[5 Second]}
    ],
    Example[{Options,SecondaryWash,"SecondaryWash will default to True if not specified:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][SecondaryWash]],
      {True}
    ],
    Example[{Options,SecondaryWash,"Setting SecondaryWash to False will turn off the other SecondaryWash options:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        SecondaryWash -> False
      ];
      Download[protocol,OutputUnitOperations[[1]][{SecondaryWash,SecondaryWashSolutionLink,NumberOfSecondaryWashes,SecondaryDryTime}]],
      {{False}, {Null}, {Null}, {Null}}
    ],
    Example[{Options,SecondaryWash,"Have different SecondaryWash specifications for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        SecondaryWash -> {True,False}
      ];
      Download[protocol,OutputUnitOperations[[1]][SecondaryWash]],
      {True, False}
    ],
    Example[{Options,SecondaryWashSolution,"The SecondaryWashSolution will automatically be set to Model[Sample, \"Milli-Q water\"]:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][SecondaryWashSolutionLink]],
      {ObjectP[Model[Sample, "Milli-Q water"]]}
    ],
    Example[{Options,SecondaryWashSolution,"Have different SecondaryWashSolution's for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        SecondaryWashSolution -> {Model[Sample,StockSolution,"70% Ethanol"],Model[Sample, "Milli-Q water"]}
      ];
      Download[protocol,OutputUnitOperations[[1]][SecondaryWashSolutionLink]],
      {ObjectP[Model[Sample, StockSolution, "70% Ethanol"]], ObjectP[Model[Sample, "Milli-Q water"]]}
    ],
    Example[{Options,NumberOfSecondaryWashes,"The NumberOfSecondaryWashes will automatically be set to 5:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][NumberOfSecondaryWashes]],
      {5}
    ],
    Example[{Options,NumberOfSecondaryWashes,"Have different NumberOfSecondaryWashes for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        NumberOfSecondaryWashes -> {3,2}
      ];
      Download[protocol,OutputUnitOperations[[1]][NumberOfSecondaryWashes]],
      {3, 2}
    ],
    Example[{Options,SecondaryDryTime,"The SecondaryDryTime will automatically be set to 10 Seconds:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][SecondaryDryTime]],
      {RangeP[10 Second]}
    ],
    Example[{Options,SecondaryDryTime,"Have different SecondaryDryTime for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        SecondaryDryTime -> {2 Second, 5 Second}
      ];
      Download[protocol,OutputUnitOperations[[1]][SecondaryDryTime]],
      {RangeP[2 Second], RangeP[5 Second]}
    ],
    Example[{Options,TertiaryWash,"TertiaryWash will default to False if not specified:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][TertiaryWash]],
      {False}
    ],
    Example[{Options,TertiaryWash,"TertiaryWash will default to True if QuaternaryWash is set to True:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        QuaternaryWash -> True
      ];
      Download[protocol,OutputUnitOperations[[1]][TertiaryWash]],
      {True}
    ],
    Example[{Options,TertiaryWash,"Setting TertiaryWash to False will turn off the other TertiaryWash options:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        TertiaryWash -> False
      ];
      Download[protocol,OutputUnitOperations[[1]][{TertiaryWash,TertiaryWashSolutionLink,NumberOfTertiaryWashes,TertiaryDryTime}]],
      {{False}, {Null}, {Null}, {Null}}
    ],
    Example[{Options,TertiaryWash,"Have different TertiaryWash specifications for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        TertiaryWash -> {True,False}
      ];
      Download[protocol,OutputUnitOperations[[1]][TertiaryWash]],
      {True, False}
    ],
    Example[{Options,TertiaryWashSolution,"The TertiaryWashSolution will automatically be set to Model[Sample, StockSolution, \"10% Bleach\"]:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        TertiaryWash -> True
      ];
      Download[protocol,OutputUnitOperations[[1]][TertiaryWashSolutionLink]],
      {ObjectP[Model[Sample, StockSolution, "10% Bleach"]]}
    ],
    Example[{Options,TertiaryWashSolution,"Have different TertiaryWashSolution's for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        TertiaryWashSolution -> {Model[Sample,StockSolution,"70% Ethanol"],Model[Sample, "Milli-Q water"]}
      ];
      Download[protocol,OutputUnitOperations[[1]][TertiaryWashSolutionLink]],
      {ObjectP[Model[Sample, StockSolution, "70% Ethanol"]], ObjectP[Model[Sample, "Milli-Q water"]]}
    ],
    Example[{Options,NumberOfTertiaryWashes,"The NumberOfTertiaryWashes will automatically be set to 5 if TertiaryWash is set to True:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        TertiaryWash -> True
      ];
      Download[protocol,OutputUnitOperations[[1]][NumberOfTertiaryWashes]],
      {5}
    ],
    Example[{Options,NumberOfTertiaryWashes,"Have different NumberOfTertiaryWashes for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        NumberOfTertiaryWashes -> {3,2}
      ];
      Download[protocol,OutputUnitOperations[[1]][NumberOfTertiaryWashes]],
      {3, 2}
    ],
    Example[{Options,TertiaryDryTime,"The TertiaryDryTime will automatically be set to 10 Seconds if TertiaryWash is set to True:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        TertiaryWash -> True
      ];
      Download[protocol,OutputUnitOperations[[1]][TertiaryDryTime]],
      {RangeP[10 Second]}
    ],
    Example[{Options,TertiaryDryTime,"Have different TertiaryDryTime for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        TertiaryDryTime -> {2 Second, 5 Second}
      ];
      Download[protocol,OutputUnitOperations[[1]][TertiaryDryTime]],
      {RangeP[2 Second], RangeP[5 Second]}
    ],
    Example[{Options,QuaternaryWash,"QuaternaryWash will default to False if not specified:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][QuaternaryWash]],
      {False}
    ],
    Example[{Options,QuaternaryWash,"Setting QuaternaryWash to False will turn off the other QuaternaryWash options:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        QuaternaryWash -> False
      ];
      Download[protocol,OutputUnitOperations[[1]][{QuaternaryWash,QuaternaryWashSolutionLink,NumberOfQuaternaryWashes,QuaternaryDryTime}]],
      {{False}, {Null}, {Null}, {Null}}
    ],
    Example[{Options,QuaternaryWash,"Have different QuaternaryWash specifications for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        QuaternaryWash -> {True,False}
      ];
      Download[protocol,OutputUnitOperations[[1]][QuaternaryWash]],
      {True, False}
    ],
    Example[{Options,QuaternaryWashSolution,"The QuaternaryWashSolution will automatically be set to Null:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][QuaternaryWashSolutionLink]],
      {Null}
    ],
    Example[{Options,QuaternaryWashSolution,"Have different QuaternaryWashSolution's for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        QuaternaryWashSolution -> {Model[Sample,StockSolution,"70% Ethanol"],Model[Sample, "Milli-Q water"]}
      ];
      Download[protocol,OutputUnitOperations[[1]][QuaternaryWashSolutionLink]],
      {ObjectP[Model[Sample, StockSolution, "70% Ethanol"]], ObjectP[Model[Sample, "Milli-Q water"]]}
    ],
    Example[{Options,NumberOfQuaternaryWashes,"The NumberOfQuaternaryWashes will automatically be set to Null:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][NumberOfQuaternaryWashes]],
      {Null}
    ],
    Example[{Options,NumberOfQuaternaryWashes,"Have different NumberOfQuaternaryWashes for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        NumberOfQuaternaryWashes -> {3,2}
      ];
      Download[protocol,OutputUnitOperations[[1]][NumberOfQuaternaryWashes]],
      {3, 2}
    ],
    Example[{Options,QuaternaryDryTime,"The QuaternaryDryTime will automatically be set to Null:"},
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][QuaternaryDryTime]],
      {Null}
    ],
    Example[{Options,QuaternaryDryTime,"Have different QuaternaryDryTime for different samples:"},
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID]
        },
        QuaternaryDryTime -> {2 Second, 5 Second}
      ];
      Download[protocol,OutputUnitOperations[[1]][QuaternaryDryTime]],
      {RangeP[2 Second], RangeP[5 Second]}
    ],

    (* Messages tests *)
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentStreakCells[Object[Sample, "Nonexistent sample"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentStreakCells[Object[Container, Vessel, "Nonexistent container"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentStreakCells[Object[Sample, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentStreakCells[Object[Container, Vessel, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container, Plate, "id:n0k9mGkwbvG4"],(* Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]*)
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          Model[Sample, "Test Sample Model 1 for ExperimentStreakCells (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID],
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 1 Milliliter,
          State -> Liquid
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentStreakCells[sampleID, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container, Plate, "id:n0k9mGkwbvG4"],(* Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]*)
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          Model[Sample, "Test Sample Model 1 for ExperimentStreakCells (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID],
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 1 Milliliter,
          State -> Liquid
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentStreakCells[containerID, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[{Messages,"MultipleInoculationSourceInInput","A message is thrown if different input samples have different InoculationSource types:"},
      ExperimentStreakCells[
        {Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],Object[Sample, "Test Sample 20 for ExperimentStreakCells (freeze dried cell 1 in ampoule 1)" <> $SessionUUID]}
      ],
      $Failed,
      Messages :> {Error::MultipleInoculationSourceInInput,Error::InvalidInput}
    ],
    Example[{Messages,"NoPreferredLiquidMediaForResuspension","If the input sample does not have cells in the composition, throw a warning:"},
      ExperimentStreakCells[
        Object[Sample, "Test Sample 24 for ExperimentStreakCells (freeze dried cell 2 in ampoule 3)" <> $SessionUUID], StreakVolume -> 50 Microliter
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]],
      Messages :> {Warning::NoPreferredLiquidMediaForResuspension}
    ],
    Example[{Messages,"NoResuspensionMix","A warning message is thrown if it is specified not to mix during resuspension when the source type is FreezeDried or FrozenGlycerol:"},
      protocol = ExperimentStreakCells[Object[Sample, "Test Sample 20 for ExperimentStreakCells (freeze dried cell 1 in ampoule 1)" <> $SessionUUID],
          ResuspensionMix ->False];
      Download[protocol,OutputUnitOperations[[1]][{NumberOfResuspensionMixes,ResuspensionMixVolume}]],
      {{Null}, {Null}},
      Messages :> {Warning::NoResuspensionMix}
    ],
    Example[{Messages,"ResuspensionMixMismatch","A message is thrown if there is mismatch in resuspension mix options:"},
      ExperimentStreakCells[
        Object[Sample, "Test Sample 20 for ExperimentStreakCells (freeze dried cell 1 in ampoule 1)" <> $SessionUUID],
        ResuspensionMix -> True,
        ResuspensionMixVolume -> Null
      ],
      $Failed,
      Messages :> {Error::ResuspensionMixMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"InvalidResuspensionContainerWellPosition","If InoculationSource is FreezeDried or FrozenGlycerol, if the specified ResuspensionContainerWell is not a Position in the ResuspensionContainer, an error will be thrown:"},
      ExperimentStreakCells[
        Object[Sample, "Test Sample 20 for ExperimentStreakCells (freeze dried cell 1 in ampoule 1)" <> $SessionUUID],
        ResuspensionContainerWell -> "A13"
      ],
      $Failed,
      Messages :> {Error::InvalidResuspensionContainerWellPosition,Error::InvalidOption}
    ],
    Example[{Messages,"ResuspensionOptionIncompatibleSource","If InoculationSource is LiquidMedia and any resuspension option is set, an error will be thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        ResuspensionMix -> True
      ],
      $Failed,
      Messages :> {Error::ResuspensionOptionIncompatibleSource,Error::InvalidOption}
    ],
    Example[{Messages,"ResuspensionOptionIncompatibleSource","If InoculationSource is FreezeDried and NumberOfSourceScrapes is set, an error will be thrown:"},
      ExperimentStreakCells[
        Object[Sample, "Test Sample 20 for ExperimentStreakCells (freeze dried cell 1 in ampoule 1)" <> $SessionUUID],
        NumberOfSourceScrapes -> 5
      ],
      $Failed,
      Messages :> {Error::ResuspensionOptionIncompatibleSource,Error::InvalidOption}
    ],
    Example[{Messages,"SourceMixMismatch","If SourceMix is True but either SourceMixVolume or NumberOfSourceMixes is Null, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        SourceMix -> True,
        NumberOfSourceMixes -> Null
      ],
      $Failed,
      Messages :> {Error::SourceMixMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"SourceMixMismatch","If SourceMix is False but either SourceMixVolume or NumberOfSourceMixes is specified, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        SourceMix -> False,
        SourceMixVolume -> 20 Microliter
      ],
      $Failed,
      Messages :> {Error::SourceMixMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"ColonyHandlerHeadCassetteMismatch","If HeadDiamter does not match the HeadDiameter of the Model of ColonyStreakingTool, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        ColonyStreakingTool -> Model[Part, ColonyHandlerHeadCassette, "1-pin spreading head"],
        HeadDiameter -> 4 Millimeter
      ],
      $Failed,
      Messages :> {Error::ColonyHandlerHeadCassetteMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"ColonyHandlerHeadCassetteMismatch","If HeadLength does not match the HeadLength of the Model of ColonyStreakingTool, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        ColonyStreakingTool -> Model[Part, ColonyHandlerHeadCassette, "1-pin spreading head"],
        HeadLength -> 15 Millimeter
      ],
      $Failed,
      Messages :> {Error::ColonyHandlerHeadCassetteMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"ColonyHandlerHeadCassetteMismatch","If NumberOfHeads does not match the NumberOfHeads of the Model of ColonyStreakingTool, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        ColonyStreakingTool -> Model[Part, ColonyHandlerHeadCassette, "1-pin spreading head"],
        NumberOfHeads -> 5
      ],
      $Failed,
      Messages :> {Error::ColonyHandlerHeadCassetteMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"ColonyHandlerHeadCassetteMismatch","If ColonyHandlerHeadCassetteApplication does not match the Application of the Model of ColonyStreakingTool, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        ColonyStreakingTool -> Model[Part, ColonyHandlerHeadCassette, "1-pin spreading head"],
        ColonyHandlerHeadCassetteApplication -> Pick
      ],
      $Failed,
      Messages :> {Error::ColonyHandlerHeadCassetteMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"NoColonyHandlerStreakingHeadFound","If the specified HeadDiameter, HeadLength, NumberOfHeads, or ColonyHandlerHeadCassetteApplication do not match any possible ColonyStreakingTool, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        HeadLength -> 15 Millimeter
      ],
      $Failed,
      Messages :> {Error::NoColonyHandlerStreakingHeadFound,Error::InvalidOption}
    ],
    Example[{Messages,"StreakPatternMismatch","If StreakPatternType is Custom and a CustomStreakPattern is not specified, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        StreakPatternType -> Custom,
        CustomStreakPattern -> Null
      ],
      $Failed,
      Messages :> {Error::StreakPatternMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"StreakPatternMismatch","If StreakPatternType is not Custom and a CustomStreakPattern is specified, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        StreakPatternType -> Radiant,
        CustomStreakPattern -> Streak[{{1 Millimeter, 1 Millimeter}}]
      ],
      $Failed,
      Messages :> {Error::StreakPatternMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"InvalidDestinationContainerType","If DilutionStrategy is Series and DestinationContainer is an Object[Container], an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionStrategy -> Series,
        DestinationContainer -> Object[Container,Plate,"Test Omnitray 1 for ExperimentStreakCells" <> $SessionUUID]
      ],
      $Failed,
      Messages :> {Error::InvalidDestinationContainerType,Error::InvalidOption,Error::ContainerOutLabelMismatch}
    ],
    Example[{Messages,"NoAvailablePositionsInContainer","If the specified DestinationContainer does not have valid positions (empty well) to streak colonies, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DestinationContainer -> Object[Container,Plate,"Test Omnitray 3 for ExperimentStreakCells" <> $SessionUUID],
        DestinationWell -> "A1"
      ],
      $Failed,
      Messages :> {Error::NoAvailablePositionsInContainer,Error::InvalidOption,Error::DestinationMediaNotSolid}
    ],
    Example[{Messages,"DilutionFinalVolumeTooSmall","If DilutionStrategy is Series, and a final dilution volume in the series is less than StreakVolume times the number of dispense locations, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionStrategy -> Series,
        NumberOfDilutions -> 3,
        StreakVolume -> 30 Microliter,
        DispenseCoordinates -> {{1 Millimeter, 1 Millimeter},{2 Millimeter, 2 Millimeter},{3 Millimeter, 3 Millimeter},{4 Millimeter, 5 Millimeter}},
        DilutionFinalVolume -> {{100 Microliter, 100 Microliter, 100 Microliter}}
      ],
      $Failed,
      Messages :> {Error::DilutionFinalVolumeTooSmall,Error::InvalidOption}
    ],
    Example[{Messages,"DilutionFinalVolumeTooSmall","If DilutionStrategy is Endpoint, and the final dilution volume in the series is less than StreakVolume times the number of dispense locations, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionStrategy -> Endpoint,
        NumberOfDilutions -> 3,
        StreakVolume -> 30 Microliter,
        DispenseCoordinates -> {{1 Millimeter, 1 Millimeter},{2 Millimeter, 2 Millimeter},{3 Millimeter, 3 Millimeter},{4 Millimeter, 5 Millimeter}},
        DilutionFinalVolume -> {{150 Microliter, 150 Microliter, 100 Microliter}}
      ],
      $Failed,
      Messages :> {Error::DilutionFinalVolumeTooSmall,Error::InvalidOption}
    ],
    Example[{Messages,"DilutionMismatch","If DilutionType is specified and another dilution option is Null, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Linear,
        NumberOfDilutions -> Null
      ],
      $Failed,
      Messages :> {Error::DilutionMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"SpreadingMultipleSamplesOnSamePlate","If DestinationContainer is the same Object[Container] for 2 input samples, an error is thrown:"},
      ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 2 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
        },
        DestinationContainer -> {
          Object[Container,Plate,"Test Omnitray 1 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 1 for ExperimentStreakCells" <> $SessionUUID]
        }
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]],
      Messages :> {Warning::SpreadingMultipleSamplesOnSamePlate}
    ],
    Example[{Messages,"InvalidDestinationContainer","If the DestinationContainer has more than 1 well, an error is thrown"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DestinationContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
      ],
      $Failed,
      Messages :> {Error::InvalidDestinationContainer,Error::InvalidOption}
    ],
    Example[{Messages,"InvalidDestinationWell","If the specified DestinationWell is not a position in DestinationContainer, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DestinationContainer -> Model[Container, Plate, "Omni Tray Sterile Media Plate"],
        DestinationWell -> "A2"
      ],
      $Failed,
      Messages :> {Error::InvalidDestinationWell,Error::InvalidOption}
    ],
    Example[{Messages,"ConflictingDestinationMedia","If the specified DestinationMedia is not the same Model as the sample in DestinationWell of DestinationContainer, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DestinationContainer -> Object[Container,Plate,"Test Omnitray 1 for ExperimentStreakCells" <> $SessionUUID],
        DestinationMedia -> Model[Sample,Media,"Test Solid Media for ExperimentStreakCells" <> $SessionUUID],
        DestinationWell -> "A1"
      ],
      $Failed,
      Messages :> {Error::ConflictingDestinationMedia,Error::InvalidOption}
    ],
    Example[{Messages,"DestinationMediaNotSolid","If the specified DestinationMedia does not have Solid State, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DestinationMedia -> Model[Sample, Media, "LB (Liquid)"]
      ],
      $Failed,
      Messages :> {Error::DestinationMediaNotSolid,Error::InvalidOption}
    ],
    Example[{Messages,"SampleOutLabelMismatch","If DilutionStrategy is Series and the length of SampleOutLabel is not NumberOfDilutions + 1, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionStrategy -> Series,
        NumberOfDilutions -> 3,
        SampleOutLabel -> {"my label 1","my label 2","my label 3"}
      ],
      $Failed,
      Messages :> {Error::SampleOutLabelMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"SampleOutLabelMismatch","If DilutionStrategy is Endpoint and the length of SampleOutLabel is not 1, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionStrategy -> Endpoint,
        NumberOfDilutions -> 3,
        SampleOutLabel -> {"my label 1","my label 2"}
      ],
      $Failed,
      Messages :> {Error::SampleOutLabelMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"SampleOutLabelMismatch","If DilutionStrategy is Null and the length of SampleOutLabel is not NumberOfDilutions, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Linear,
        DilutionStrategy -> Null,
        NumberOfDilutions -> 3,
        SampleOutLabel -> {"my label 1","my label 2"}
      ],
      $Failed,
      Messages :> {Error::SampleOutLabelMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"ContainerOutLabelMismatch","If DilutionStrategy is Series and the length of ContainerOutLabel is not NumberOfDilutions + 1, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionStrategy -> Series,
        NumberOfDilutions -> 3,
        ContainerOutLabel -> {"my label 1","my label 2","my label 3"}
      ],
      $Failed,
      Messages :> {Error::ContainerOutLabelMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"ContainerOutLabelMismatch","If DilutionStrategy is Endpoint and the length of ContainerOutLabel is not 1, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionStrategy -> Endpoint,
        NumberOfDilutions -> 3,
        ContainerOutLabel -> {"my label 1","my label 2"}
      ],
      $Failed,
      Messages :> {Error::ContainerOutLabelMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"ContainerOutLabelMismatch","If DilutionStrategy is Null and the length of ContainerOutLabel is not NumberOfDilutions, an error is thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Linear,
        DilutionStrategy -> Null,
        NumberOfDilutions -> 3,
        ContainerOutLabel -> {"my label 1","my label 2"}
      ],
      $Failed,
      Messages :> {Error::ContainerOutLabelMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"IncompatibleMaterials","If a wash solution is not compatible with the wetted materials of the instrument, an error will be thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        PrimaryWashSolution -> Model[Sample,"Test Incompatible Sample Model for ExperimentStreakCells " <> $SessionUUID],
        SecondaryWash -> False,
        Output->Options
      ],
      _List,
      Messages :> {Error::IncompatibleMaterials,Error::InvalidOption}
    ],
    Example[{Messages,"IncompatibleMaterials","If the input sample is not compatible with the wetted materials of the instrument, an error will be thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 19 for ExperimentStreakCells (Incompatible sample in DWP 11)" <> $SessionUUID],
        Output->Options
      ],
      _List,
      Messages :> {Error::IncompatibleMaterials}
    ],
    Example[{Messages,"QPixWashSolutionInsufficientVolume","If there is not sufficient volume (150mL) left in a specified Object[Sample] for any wash solution options, an error will be thrown:"},
      ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        PrimaryWashSolution -> Model[Sample, "id:8qZ1VWNmdLBD"],(*"Milli-Q water"*)
        SecondaryWashSolution -> Object[Sample,"Test Wash Solution for ExperimentStreakCells (MilliQ)" <> $SessionUUID]
      ],
      $Failed,
      Messages :> {Error::QPixWashSolutionInsufficientVolume,Error::InvalidOption}
    ],
    (* Batching tests *)
    Test["If there are more than 8 source plates, split into multiple physical batches:",
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 11 for ExperimentStreakCells (Test Cell 1 in LB in DWP 3)" <> $SessionUUID],
          Object[Sample,"Test Sample 12 for ExperimentStreakCells (Test Cell 1 in LB in DWP 4)" <> $SessionUUID],
          Object[Sample,"Test Sample 13 for ExperimentStreakCells (Test Cell 1 in LB in DWP 5)" <> $SessionUUID],
          Object[Sample,"Test Sample 14 for ExperimentStreakCells (Test Cell 1 in LB in DWP 6)" <> $SessionUUID],
          Object[Sample,"Test Sample 15 for ExperimentStreakCells (Test Cell 1 in LB in DWP 7)" <> $SessionUUID],
          Object[Sample,"Test Sample 16 for ExperimentStreakCells (Test Cell 1 in LB in DWP 8)" <> $SessionUUID],
          Object[Sample,"Test Sample 17 for ExperimentStreakCells (Test Cell 1 in LB in DWP 9)" <> $SessionUUID],
          Object[Sample,"Test Sample 18 for ExperimentStreakCells (Test Cell 1 in LB in DWP 10)" <> $SessionUUID]
        }
      ];
      Length[Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations]]],
      2
    ],
    Test["If samples have different Mixing options, split into multiple physical batches:",
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 2 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
        },
        SourceMix -> {True,False}
      ];
      Length[Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations]]],
      2
    ],
    Test["If samples have different streak pattern options, split into multiple physical batches:",
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 2 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
        },
        StreakPatternType -> {RotatedHatches, Radiant}
      ];
      Length[Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations]]],
      2
    ],
    Test["If samples have different dispense coordinates, split into multiple physical batches:",
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 2 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
        },
        DispenseCoordinates -> {
          {{1 Millimeter, 1 Millimeter}},
          {{2 Millimeter, 3 Millimeter}}
        }
      ];
      Length[Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations]]],
      2
    ],
    Test["If samples have different sanitization options, split into multiple physical batches:",
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 2 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
        },
        SecondaryDryTime -> {5 Second, 2 Second}
      ];
      Length[Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations]]],
      2
    ],
    Test["Split into multiple physical batches, if we have different source plate models:",
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 10 for ExperimentStreakCells (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID]
        }
      ];
      Length[Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations]]],
      2
    ],
    Test["Each Physical batch is partitioned into groups of up to 2:",
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        NumberOfDilutions -> 6
      ];
      Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations][[1]][BatchedDestinationContainerLengths]],
      {2,2,2,1}
    ],
    Test["Create no Riser placements if we have deep well plate source containers:",
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations][[1]][RiserDeckPlacements]],
      {}
    ],
    Test["Create Riser placements (front and back) if we have shallow well plate source containers:",
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 10 for ExperimentStreakCells (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations][[1]][RiserDeckPlacements]],
      {
        {ObjectP[Model[Container,Rack,"QPix Riser"]], {"QPix Track Slot 3"}},
        {ObjectP[Model[Container,Rack,"QPix Riser"]], {"QPix Track Rear Slot 3"}}
      }
    ],
    Test["Create Riser returns (front and back) if we have shallow well plate source containers in the first batch but not the second batch:",
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 10 for ExperimentStreakCells (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
        }
      ];
      Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations][[2]][RiserReturns]],
      {
        ObjectP[Model[Container,Rack,"QPix Riser"]],
        ObjectP[Model[Container,Rack,"QPix Riser"]]
      }
    ],
    Test["Only pick the carriers/risers needed for the protocol:",
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 10 for ExperimentStreakCells (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID]
      ];
      Length[Download[protocol,OutputUnitOperations[[1]][CarrierAndRiserInitialResources]]],
      3
    ],
    Test["Carriers are placed directly on deck if we have deep well source containers:",
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations][[1]][CarrierDeckPlacements]],
      {
        {ObjectP[Model[Container, Rack, "QPix Plate Carrier"]], {"QPix Track Slot 3"}}
      }
    ],
    Test["Carriers are placed on top of risers if we have shallow well source containers:",
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 10 for ExperimentStreakCells (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID]
      ];
      Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations][[1]][CarrierDeckPlacements]],
      {
        {ObjectP[Model[Container, Rack, "QPix Plate Carrier"]], {"QPix Track Slot 3", "A1"}}
      }
    ],
    Test["Create Carrier returns if we have to reconfigure the deck between batches:",
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 10 for ExperimentStreakCells (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
        }
      ];
      Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations][[2]][CarrierReturns]],
      {
        ObjectP[Model[Container, Rack, "QPix Plate Carrier"]]
      }
    ],
    Test["Always have a colony streaking tool add in the first physical batch:",
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 10 for ExperimentStreakCells (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
        }
      ];
      Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations][[1]][ColonyHandlerHeadCassettePlacement]],
      {
        ObjectP[Model[Part,ColonyHandlerHeadCassette]],
        ObjectP[Model[Instrument,ColonyHandler]],
        "QPix ColonyHandlerHeadCassette Slot"
      }
    ],
    Test["Have a colony streaking tool return in the second batch if it specifies a new head",
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 10 for ExperimentStreakCells (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
        },
        ColonyStreakingTool -> {
          Model[Part, ColonyHandlerHeadCassette, "1-pin spreading head"],
          Model[Part, ColonyHandlerHeadCassette, "8-pin spreading head"]
        }
      ];
      Download[protocol,OutputUnitOperations[[1]][BatchedUnitOperations][[2]][ColonyHandlerHeadCassetteReturn]],
      ObjectP[Model[Part,ColonyHandlerHeadCassette]]
    ],
    Test["Create placements for the destination containers on the light table (in the holder) and store them in the flat batching fields:",
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        NumberOfDilutions -> 2
      ];
      Download[protocol,{
        OutputUnitOperations[[1]][BatchedUnitOperations][[1]][FlatBatchedDestinationContainers],
        OutputUnitOperations[[1]][BatchedUnitOperations][[1]][FlatBatchedDestinationContainerPlacements],
        OutputUnitOperations[[1]][BatchedUnitOperations][[1]][BatchedDestinationContainerLengths]
      }],
      {
        {
          ObjectP[Model[Sample]],
          ObjectP[Model[Sample]],
          ObjectP[Model[Sample]]
        },
        {
          {ObjectP[Model[Sample]], {"QPix LightTable Slot", "A1", "A1"}},
          {ObjectP[Model[Sample]], {"QPix LightTable Slot", "A1", "B1"}},
          {ObjectP[Model[Sample]], {"QPix LightTable Slot", "A1", "A1"}}
        },
        {2,1}
      }
    ],
    Test["Create placements for the source containers on the carriers and store them in the batched unit operation:",
      protocol = ExperimentStreakCells[
        {
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 2 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 10 for ExperimentStreakCells (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID]
        }
      ];
      Download[protocol,{
        OutputUnitOperations[[1]][BatchedUnitOperations][[1]][IntermediateSourceContainerDeckPlacements],
        OutputUnitOperations[[1]][BatchedUnitOperations][[2]][IntermediateSourceContainerDeckPlacements]
      }],
      {
        {
          {ObjectP[Object[Container, Plate, "Test DWP 1 for ExperimentStreakCells" <> $SessionUUID]], {"QPix Track Slot 3", "D1"}}
        },
        {
          {ObjectP[Object[Container,Plate,"Test UV Star Plate 1 for ExperimentStreakCells" <> $SessionUUID]], {"QPix Track Slot 3","A1", "D1"}}
        }
      }
    ],
    Test["Create Tip Deck placements for the tip rack",
      protocol = ExperimentStreakCells[
        Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        NumberOfDilutions -> 3
      ];
      Download[protocol,{
        OutputUnitOperations[[1]][BatchedUnitOperations][[1]][TipRackDeckPlacements]
      }],
      {
        {{ObjectP[Model[Item, Tips, "QPix Tips"]], {"QPix Tip Slot"}}}
      }
    ],
    Test["Generate the protocol when both resuspension and dilution are performed for freeze dried input samples:",
      ExperimentStreakCells[
        Object[Sample, "Test Sample 20 for ExperimentStreakCells (freeze dried cell 1 in ampoule 1)" <> $SessionUUID],
        Diluent -> Model[Sample, Media, "LB (Liquid)"],
        NumberOfDilutions -> 3
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages :> {Warning::MissingTargetAnalyteInitialConcentration}(*This message is expected because we set a 100 MassPercent cells in freeze dried sample composition and start with with a mass. We don't know the cell count at the point before the first inoculation and measurement of the resulted culture*)
    ],
    Test["Generate the protocol when both resuspension and dilution are performed for frozen glycerol input samples:",
      ExperimentStreakCells[
        Object[Sample, "Test Sample 22 for ExperimentStreakCells (cell 1 in frozen glycerol in cryoVial 1)" <> $SessionUUID],
        Diluent -> Model[Sample, Media, "LB (Liquid)"],
        NumberOfDilutions -> 3
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]]
    ],
    Test["The generated RCP, requires the Magnetic Hazard Safety certification:",
      Module[{protocol,requiredCerts},
        protocol = ExperimentStreakCells[
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          StreakVolume -> 50 Microliter
        ];
        requiredCerts = Download[protocol,RequiredCertifications];
        MemberQ[requiredCerts,ObjectP[Model[Certification, "id:XnlV5jNAkGmM"]]]
      ],
      True
    ]
  },
  SymbolSetUp :> (
    Module[{objs,existingObjs},
      Off[Warning::SamplesOutOfStock];
      objs=Quiet[Cases[
        Flatten[{
          (* Bench *)
          Object[Container,Bench,"Bench for ExperimentStreakCells Testing"<>$SessionUUID],

          (* Containers *)
          Object[Container,Plate,"Test DWP 1 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 2 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 3 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 4 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 5 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 6 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 7 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 8 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 9 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 10 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 11 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 1 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 2 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 3 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL Tube 1 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL Tube 2 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test UV Star Plate 1 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Vessel, "Test 2mL amber glass ampoule 1 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Vessel, "Test 2mL amber glass ampoule 2 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Vessel, "Test 2mL amber glass ampoule 3 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Vessel, "Test cryoVial 1 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Vessel, "Test cryoVial 2 for ExperimentStreakCells" <> $SessionUUID],

          (* Cells *)
          Model[Cell,Bacteria,"Test Cell 1 for ExperimentStreakCells" <> $SessionUUID],
          Model[Cell,Bacteria,"Test Cell 1 for ExperimentStreakCells - no PrefSolidMedia" <> $SessionUUID],

          (* Media *)
          Model[Sample,Media,"Test Solid Media for ExperimentStreakCells" <> $SessionUUID],

          (* Sample Models *)
          Model[Sample,"Test Sample Model 1 for ExperimentStreakCells (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 2 for ExperimentStreakCells (5000 Cell/Milliliter Test Cell 2 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 3 for ExperimentStreakCells (5000 Cell/Milliliter Test Cell 1 in TB Broth)" <> $SessionUUID],
          Model[Sample, "Test freeze dried cells sample Model for ExperimentStreakCells" <> $SessionUUID],
          Model[Sample, "Test freeze dried cells sample Model 2 for ExperimentStreakCells" <> $SessionUUID],
          Model[Sample, "Test cells in 50% frozen glycerol sample Model for ExperimentStreakCells" <> $SessionUUID],
          Model[Sample,"Test Incompatible Sample Model for ExperimentStreakCells " <> $SessionUUID],

          (* Samples *)
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 2 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 4 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 5 for ExperimentStreakCells (LB Broth in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 6 for ExperimentStreakCells (LB Broth in 50 mL Tube)" <> $SessionUUID],
          Object[Sample,"Test Sample 7 for ExperimentStreakCells (Solid LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 8 for ExperimentStreakCells (Test Cell 1 in TB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 9 for ExperimentStreakCells (LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 10 for ExperimentStreakCells (Test Cell 1 in LB in UV Star 1)"<>$SessionUUID],
          Object[Sample,"Test Sample 11 for ExperimentStreakCells (Test Cell 1 in LB in DWP 3)" <> $SessionUUID],
          Object[Sample,"Test Sample 12 for ExperimentStreakCells (Test Cell 1 in LB in DWP 4)" <> $SessionUUID],
          Object[Sample,"Test Sample 13 for ExperimentStreakCells (Test Cell 1 in LB in DWP 5)" <> $SessionUUID],
          Object[Sample,"Test Sample 14 for ExperimentStreakCells (Test Cell 1 in LB in DWP 6)" <> $SessionUUID],
          Object[Sample,"Test Sample 15 for ExperimentStreakCells (Test Cell 1 in LB in DWP 7)" <> $SessionUUID],
          Object[Sample,"Test Sample 16 for ExperimentStreakCells (Test Cell 1 in LB in DWP 8)" <> $SessionUUID],
          Object[Sample,"Test Sample 17 for ExperimentStreakCells (Test Cell 1 in LB in DWP 9)" <> $SessionUUID],
          Object[Sample,"Test Sample 18 for ExperimentStreakCells (Test Cell 1 in LB in DWP 10)" <> $SessionUUID],
          Object[Sample,"Test Sample 19 for ExperimentStreakCells (Incompatible sample in DWP 11)" <> $SessionUUID],
          Object[Sample, "Test Sample 20 for ExperimentStreakCells (freeze dried cell 1 in ampoule 1)" <> $SessionUUID],
          Object[Sample, "Test Sample 21 for ExperimentStreakCells (freeze dried cell 1 in ampoule 2)" <> $SessionUUID],
          Object[Sample, "Test Sample 22 for ExperimentStreakCells (cell 1 in frozen glycerol in cryoVial 1)" <> $SessionUUID],
          Object[Sample, "Test Sample 23 for ExperimentStreakCells (cell 1 in frozen glycerol in cryoVial 2)" <> $SessionUUID],
          Object[Sample, "Test Sample 24 for ExperimentStreakCells (freeze dried cell 2 in ampoule 3)" <> $SessionUUID],
          Object[Sample,"Test Wash Solution for ExperimentStreakCells (MilliQ)" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs=PickList[objs,DatabaseMemberQ[objs]];
      EraseObject[existingObjs,Force->True,Verbose->False]
    ];
    Block[{$DeveloperUpload = True},
      Module[
        {
          testBench,inputPlate1,inputPlate2,inputPlate3, inputPlate4, inputPlate5, inputPlate6, inputPlate7, inputPlate8, inputPlate9,
          inputPlate10,inputPlate11,destinationPlate1,destinationPlate2,invalidDestinationPlate,diluentTube,washSolutionTube,uvStarPlate1,
          ampoule1, ampoule2, ampoule3, cryoVial1, cryoVial2,
          testCell1,testCell2NoPrefSolidMedia,testSolidMedia,
          testCell1InLB,testCell2InLB,testCell1InTB,testIncompatibleSampleModel,testFreezeDriedCell1,testFreezeDriedCell2,
          testFrozenGlycerolCell1,testCell1InLBSample1,testCell1InLBSample2,testCell2InLBSample2,testCell2InLBSample1,
          testCell1InTBSample1,lbBrothSample, lbBrothDiluentSample,destinationSample,invalidDestinationSample,testCell1inUVStar,
          testCell1InLBSample3, testCell1InLBSample4, testCell1InLBSample5, testCell1InLBSample6, testCell1InLBSample7, testCell1InLBSample8,
          testCell1InLBSample9, testCell1InLBSample10,testIncompatibleInput,testCell1FreezeDried1, testCell1FreezeDried2, testCell2FreezeDried1,
          testCell1FrozenGlycerol1, testCell1FrozenGlycerol2,testWashSolution
        },

        (* Create test bench for containers *)
        (* Upload bench *)
        testBench = Upload[
          <|
            Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
            Type->Object[Container,Bench],
            Name->"Bench for ExperimentStreakCells Testing"<>$SessionUUID
          |>
        ];

        (* Containers *)
        {
          inputPlate1,
          inputPlate2,
          inputPlate3,
          inputPlate4,
          inputPlate5,
          inputPlate6,
          inputPlate7,
          inputPlate8,
          inputPlate9,
          inputPlate10,
          inputPlate11,
          destinationPlate1,
          destinationPlate2,
          invalidDestinationPlate,
          diluentTube,
          washSolutionTube,
          uvStarPlate1,
          ampoule1,
          ampoule2,
          ampoule3,
          cryoVial1,
          cryoVial2
        } = UploadSample[
          {
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:O81aEBZjRXvx"], (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
            Model[Container, Plate, "id:O81aEBZjRXvx"], (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
            Model[Container, Plate, "id:O81aEBZjRXvx"], (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
            Model[Container, Vessel, "id:bq9LA0dBGGR6"], (* Model[Container, Vessel, "50mL Tube"] *)
            Model[Container, Vessel, "id:bq9LA0dBGGR6"], (* Model[Container, Vessel, "50mL Tube"] *)
            Model[Container, Plate, "id:n0k9mGzRaaBn"], (* Model[Container, Plate, "96-well UV-Star Plate"] *)
            Model[Container, Vessel, "id:n0k9mGkp4OK6"],(* Model[Container, Vessel, "2mL amber glass ampoule"] *)
            Model[Container, Vessel, "id:n0k9mGkp4OK6"],(* Model[Container, Vessel, "2mL amber glass ampoule"] *)
            Model[Container, Vessel, "id:n0k9mGkp4OK6"],(* Model[Container, Vessel, "2mL amber glass ampoule"] *)
            Model[Container, Vessel, "id:vXl9j5qEnnOB"],(* Model[Container, Vessel, "2mL Cryogenic Vial"] *)
            Model[Container, Vessel, "id:vXl9j5qEnnOB"](* Model[Container, Vessel, "2mL Cryogenic Vial"] *)
          },
          ConstantArray[{"Work Surface",testBench},22],
          Name -> {
            "Test DWP 1 for ExperimentStreakCells" <> $SessionUUID,
            "Test DWP 2 for ExperimentStreakCells" <> $SessionUUID,
            "Test DWP 3 for ExperimentStreakCells" <> $SessionUUID,
            "Test DWP 4 for ExperimentStreakCells" <> $SessionUUID,
            "Test DWP 5 for ExperimentStreakCells" <> $SessionUUID,
            "Test DWP 6 for ExperimentStreakCells" <> $SessionUUID,
            "Test DWP 7 for ExperimentStreakCells" <> $SessionUUID,
            "Test DWP 8 for ExperimentStreakCells" <> $SessionUUID,
            "Test DWP 9 for ExperimentStreakCells" <> $SessionUUID,
            "Test DWP 10 for ExperimentStreakCells" <> $SessionUUID,
            "Test DWP 11 for ExperimentStreakCells" <> $SessionUUID,
            "Test Omnitray 1 for ExperimentStreakCells" <> $SessionUUID,
            "Test Omnitray 2 for ExperimentStreakCells" <> $SessionUUID,
            "Test Omnitray 3 for ExperimentStreakCells" <> $SessionUUID,
            "Test 50 mL Tube 1 for ExperimentStreakCells" <> $SessionUUID,
            "Test 50 mL Tube 2 for ExperimentStreakCells" <> $SessionUUID,
            "Test UV Star Plate 1 for ExperimentStreakCells" <> $SessionUUID,
            "Test 2mL amber glass ampoule 1 for ExperimentStreakCells" <> $SessionUUID,
            "Test 2mL amber glass ampoule 2 for ExperimentStreakCells" <> $SessionUUID,
            "Test 2mL amber glass ampoule 3 for ExperimentStreakCells" <> $SessionUUID,
            "Test cryoVial 1 for ExperimentStreakCells" <> $SessionUUID,
            "Test cryoVial 2 for ExperimentStreakCells" <> $SessionUUID
          }
        ];

        (* Cells *)
        {
          testCell1,
          testCell2NoPrefSolidMedia
        } = UploadBacterialCell[
          {
            "Test Cell 1 for ExperimentStreakCells" <> $SessionUUID,
            "Test Cell 1 for ExperimentStreakCells - no PrefSolidMedia" <> $SessionUUID
          },
          Morphology -> Cocci,
          BiosafetyLevel -> "BSL-1",
          Flammable -> False,
          MSDSFile -> NotApplicable,
          IncompatibleMaterials -> {None},
          CellType -> Bacterial,
          CultureAdhesion -> Suspension,
          PreferredLiquidMedia -> {Model[Sample, Media, "id:XnlV5jlXbNx8"],Null},(* Model[Sample, Media, "LB Broth, Miller"] *)
          PreferredSolidMedia -> {Model[Sample, Media, "id:9RdZXvdwAEo6"] (* Model[Sample, Media, "LB (Solid Agar)"] *),Null}
        ];

        (* Media *)
        testSolidMedia = UploadStockSolution[
          {{Quantity[20,"Grams"],Model[Sample,"Agar"]},{Quantity[25,"Grams"],Model[Sample,"LB Broth Miller (Sigma Aldrich)"]},{Quantity[900,"Milliliters"],Model[Sample,"Milli-Q water"]}},
          Model[Sample,"Milli-Q water"],
          1 Liter,
          Name -> "Test Solid Media for ExperimentStreakCells" <> $SessionUUID,
          Type -> Media,
          DefaultStorageCondition -> AmbientStorage,
          Expires -> True
        ];
        (* Fix the state *)
        Upload[<|
          Object -> testSolidMedia,
          State -> Solid
        |>];

        (* Sample Models *)
        {
          testCell1InLB,
          testCell2InLB,
          testCell1InTB,
          testIncompatibleSampleModel,
          testFreezeDriedCell1,
          testFreezeDriedCell2,
          testFrozenGlycerolCell1
        } = UploadSampleModel[
          {
            "Test Sample Model 1 for ExperimentStreakCells (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID,
            "Test Sample Model 2 for ExperimentStreakCells (5000 Cell/Milliliter Test Cell 2 in LB Broth)" <> $SessionUUID,
            "Test Sample Model 3 for ExperimentStreakCells (5000 Cell/Milliliter Test Cell 1 in TB Broth)" <> $SessionUUID,
            "Test Incompatible Sample Model for ExperimentStreakCells " <> $SessionUUID,
            "Test freeze dried cells sample Model for ExperimentStreakCells" <> $SessionUUID,
            "Test freeze dried cells sample Model 2 for ExperimentStreakCells" <> $SessionUUID,
            "Test cells in 50% frozen glycerol sample Model for ExperimentStreakCells" <> $SessionUUID
          },
          Composition -> {
            {
              {5000 EmeraldCell/Milliliter, testCell1},
              {Quantity[95, IndependentUnit["VolumePercent"]], Model[Molecule, "Water"]},
              {Quantity[171.116, "Millimolar"], Model[Molecule, "Sodium Chloride"]},
              {Quantity[0.005, ("Grams")/("Milliliters")], Model[Molecule, "Yeast Extract"]}
            },
            {
              {5000 EmeraldCell/Milliliter, testCell2NoPrefSolidMedia},
              {Quantity[95, IndependentUnit["VolumePercent"]], Model[Molecule, "Water"]},
              {Quantity[171.116, "Millimolar"], Model[Molecule, "Sodium Chloride"]},
              {Quantity[0.005, ("Grams")/("Milliliters")], Model[Molecule, "Yeast Extract"]}
            },
            {
              {0.8 OD600, testCell1},
              {95 VolumePercent, Model[Molecule,"Water"]},
              {55 Millimolar, Model[Molecule, "Potassium Phosphate (Dibasic)"]},
              {10 Millimolar, Model[Molecule, "Potassium Phosphate (Monobasic)"]},
              {0.4 VolumePercent, Model[Molecule, "Glycerol"]},
              {0.024 Gram/Milliliter, Model[Molecule, "Yeast Extract"]}
            },
            {
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {100 MassPercent, testCell1}
            },
            {
              {100 MassPercent, testCell2NoPrefSolidMedia}
            },
            {
              {50 VolumePercent, Model[Molecule, "Nutrient Broth"]},
              {50 VolumePercent, Model[Molecule, "Glycerol"]},
              {(1000 EmeraldCell)/Milliliter, testCell1}
            }
          },
          IncompatibleMaterials -> {
            {None},
            {None},
            {None},
            {Nylon},
            {None},
            {None},
            {None}
          },
          Expires -> False,
          DefaultStorageCondition -> {
            Model[StorageCondition, "id:7X104vnR18vX"], (* Model[StorageCondition, "Ambient Storage"] *)
            Model[StorageCondition, "id:7X104vnR18vX"], (* Model[StorageCondition, "Ambient Storage"] *)
            Model[StorageCondition, "id:7X104vnR18vX"], (* Model[StorageCondition, "Ambient Storage"] *)
            Model[StorageCondition, "id:7X104vnR18vX"], (* Model[StorageCondition, "Ambient Storage"] *)
            Model[StorageCondition, "id:N80DNj1r04jW"],(*Model[StorageCondition, "Refrigerator"]*)
            Model[StorageCondition, "id:N80DNj1r04jW"],(*Model[StorageCondition, "Refrigerator"]*)
            Model[StorageCondition, "id:xRO9n3BVOe3z"](*Model[StorageCondition, "Deep Freezer"]*)
          },
          Flammable -> {False,False,False,False,False,False,True},
          MSDSFile -> NotApplicable,
          BiosafetyLevel -> "BSL-1",
          State -> {Liquid,Liquid,Liquid,Liquid,Solid,Solid,Liquid},
          UsedAsSolvent -> False,
          UsedAsMedia -> False,
          Living -> {True,True,True,False,True,True,True}
        ];

        (* Samples *)
        {
          testCell1InLBSample1,
          testCell1InLBSample2,
          testCell2InLBSample1,
          testCell2InLBSample2,
          testCell1InTBSample1,
          lbBrothSample,
          lbBrothDiluentSample,
          destinationSample,
          invalidDestinationSample,
          testCell1inUVStar,
          testCell1InLBSample3,
          testCell1InLBSample4,
          testCell1InLBSample5,
          testCell1InLBSample6,
          testCell1InLBSample7,
          testCell1InLBSample8,
          testCell1InLBSample9,
          testCell1InLBSample10,
          testIncompatibleInput,
          testCell1FreezeDried1,
          testCell1FreezeDried2,
          testCell2FreezeDried1,
          testCell1FrozenGlycerol1,
          testCell1FrozenGlycerol2,
          testWashSolution
        } = UploadSample[
          {
            testCell1InLB,
            testCell1InLB,
            testCell2InLB,
            testCell2InLB,
            testCell1InTB,
            Model[Sample, Media, "id:XnlV5jlXbNx8"], (* Model[Sample, Media, "LB Broth, Miller"] *)
            Model[Sample, Media, "id:XnlV5jlXbNx8"], (* Model[Sample, Media, "LB Broth, Miller"] *)
            Model[Sample, Media, "id:9RdZXvdwAEo6"], (* Model[Sample, Media, "LB (Solid Agar)"] *)
            Model[Sample, Media, "id:XnlV5jlXbNx8"], (* Model[Sample, Media, "LB Broth, Miller"] *)
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testIncompatibleSampleModel,
            testFreezeDriedCell1,
            testFreezeDriedCell1,
            testFreezeDriedCell2,
            testFrozenGlycerolCell1,
            testFrozenGlycerolCell1,
            Model[Sample, "id:8qZ1VWNmdLBD"](*"Milli-Q water"*)
          },
          {
            {"A1",inputPlate1},
            {"B1",inputPlate1},
            {"A1",inputPlate2},
            {"B1",inputPlate2},
            {"C1",inputPlate1},
            {"D1",inputPlate1},
            {"A1",diluentTube},
            {"A1",destinationPlate1},
            {"A1",invalidDestinationPlate},
            {"A1",uvStarPlate1},
            {"A1",inputPlate3},
            {"A1",inputPlate4},
            {"A1",inputPlate5},
            {"A1",inputPlate6},
            {"A1",inputPlate7},
            {"A1",inputPlate8},
            {"A1",inputPlate9},
            {"A1",inputPlate10},
            {"A1",inputPlate11},
            {"A1",ampoule1},
            {"A1",ampoule2},
            {"A1",ampoule3},
            {"A1",cryoVial1},
            {"A1",cryoVial2},
            {"A1",washSolutionTube}
          },
          Name -> {
            "Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID,
            "Test Sample 2 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID,
            "Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID,
            "Test Sample 4 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID,
            "Test Sample 8 for ExperimentStreakCells (Test Cell 1 in TB in DWP 1)" <> $SessionUUID,
            "Test Sample 5 for ExperimentStreakCells (LB Broth in DWP 1)" <> $SessionUUID,
            "Test Sample 6 for ExperimentStreakCells (LB Broth in 50 mL Tube)" <> $SessionUUID,
            "Test Sample 7 for ExperimentStreakCells (Solid LB Agar in Omnitray)" <> $SessionUUID,
            "Test Sample 9 for ExperimentStreakCells (LB Agar in Omnitray)" <> $SessionUUID,
            "Test Sample 10 for ExperimentStreakCells (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID,
            "Test Sample 11 for ExperimentStreakCells (Test Cell 1 in LB in DWP 3)" <> $SessionUUID,
            "Test Sample 12 for ExperimentStreakCells (Test Cell 1 in LB in DWP 4)" <> $SessionUUID,
            "Test Sample 13 for ExperimentStreakCells (Test Cell 1 in LB in DWP 5)" <> $SessionUUID,
            "Test Sample 14 for ExperimentStreakCells (Test Cell 1 in LB in DWP 6)" <> $SessionUUID,
            "Test Sample 15 for ExperimentStreakCells (Test Cell 1 in LB in DWP 7)" <> $SessionUUID,
            "Test Sample 16 for ExperimentStreakCells (Test Cell 1 in LB in DWP 8)" <> $SessionUUID,
            "Test Sample 17 for ExperimentStreakCells (Test Cell 1 in LB in DWP 9)" <> $SessionUUID,
            "Test Sample 18 for ExperimentStreakCells (Test Cell 1 in LB in DWP 10)" <> $SessionUUID,
            "Test Sample 19 for ExperimentStreakCells (Incompatible sample in DWP 11)" <> $SessionUUID,
            "Test Sample 20 for ExperimentStreakCells (freeze dried cell 1 in ampoule 1)" <> $SessionUUID,
            "Test Sample 21 for ExperimentStreakCells (freeze dried cell 1 in ampoule 2)" <> $SessionUUID,
            "Test Sample 24 for ExperimentStreakCells (freeze dried cell 2 in ampoule 3)" <> $SessionUUID,
            "Test Sample 22 for ExperimentStreakCells (cell 1 in frozen glycerol in cryoVial 1)" <> $SessionUUID,
            "Test Sample 23 for ExperimentStreakCells (cell 1 in frozen glycerol in cryoVial 2)" <> $SessionUUID,
            "Test Wash Solution for ExperimentStreakCells (MilliQ)" <> $SessionUUID
          },
          InitialAmount -> {
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1.5 Milliliter,
            1 Milliliter,
            1.23 Milliliter,
            20 Milliliter,
            10 Gram,
            20 Milliliter,
            500 Microliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            100 Milligram,
            100 Milligram,
            100 Milligram,
            1 Milliliter,
            1 Milliliter,
            45 Milliliter
          },
          State -> {
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Solid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Solid,
            Solid,
            Solid,
            Solid,
            Solid,
            Liquid
          },
          StorageCondition -> Join[
            ConstantArray[Model[StorageCondition, "Ambient Storage"],19],
            {
              Model[StorageCondition, "Refrigerator"],
              Model[StorageCondition, "Refrigerator"],
              Model[StorageCondition, "Refrigerator"],
              Model[StorageCondition, "Deep Freezer"],
              Model[StorageCondition, "Deep Freezer"],
              Model[StorageCondition, "Ambient Storage"]
            }
          ]
        ];

        (* Other info to upload/correct *)
        Upload[
          {
            <|
              Object -> Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 2 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 4 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 8 for ExperimentStreakCells (Test Cell 1 in TB in DWP 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "Terrific Broth"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 9 for ExperimentStreakCells (LB Agar in Omnitray)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "id:XnlV5jlXbNx8"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 10 for ExperimentStreakCells (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>
          }
        ]

      ]
    ]
  ),
  SymbolTearDown :> (
    Module[{objs,existingObjs},
      objs=Quiet[Cases[
        Flatten[{
          (* Bench *)
          Object[Container,Bench,"Bench for ExperimentStreakCells Testing"<>$SessionUUID],

          (* Containers *)
          Object[Container,Plate,"Test DWP 1 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 2 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 3 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 4 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 5 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 6 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 7 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 8 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 9 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 10 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 11 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 1 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 2 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 3 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL Tube 1 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL Tube 2 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Plate,"Test UV Star Plate 1 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Vessel, "Test 2mL amber glass ampoule 1 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Vessel, "Test 2mL amber glass ampoule 2 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Vessel, "Test 2mL amber glass ampoule 3 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Vessel, "Test cryoVial 1 for ExperimentStreakCells" <> $SessionUUID],
          Object[Container,Vessel, "Test cryoVial 2 for ExperimentStreakCells" <> $SessionUUID],

          (* Cells *)
          Model[Cell,Bacteria,"Test Cell 1 for ExperimentStreakCells" <> $SessionUUID],
          Model[Cell,Bacteria,"Test Cell 1 for ExperimentStreakCells - no PrefSolidMedia" <> $SessionUUID],

          (* Media *)
          Model[Sample,Media,"Test Solid Media for ExperimentStreakCells" <> $SessionUUID],

          (* Sample Models *)
          Model[Sample,"Test Sample Model 1 for ExperimentStreakCells (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 2 for ExperimentStreakCells (5000 Cell/Milliliter Test Cell 2 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 3 for ExperimentStreakCells (5000 Cell/Milliliter Test Cell 1 in TB Broth)" <> $SessionUUID],
          Model[Sample, "Test freeze dried cells sample Model for ExperimentStreakCells" <> $SessionUUID],
          Model[Sample, "Test freeze dried cells sample Model 2 for ExperimentStreakCells" <> $SessionUUID],
          Model[Sample, "Test cells in 50% frozen glycerol sample Model for ExperimentStreakCells" <> $SessionUUID],
          Model[Sample,"Test Incompatible Sample Model for ExperimentStreakCells " <> $SessionUUID],

          (* Samples *)
          Object[Sample,"Test Sample 1 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 2 for ExperimentStreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 4 for ExperimentStreakCells (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 5 for ExperimentStreakCells (LB Broth in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 6 for ExperimentStreakCells (LB Broth in 50 mL Tube)" <> $SessionUUID],
          Object[Sample,"Test Sample 7 for ExperimentStreakCells (Solid LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 8 for ExperimentStreakCells (Test Cell 1 in TB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 9 for ExperimentStreakCells (LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 10 for ExperimentStreakCells (Test Cell 1 in LB in UV Star 1)"<>$SessionUUID],
          Object[Sample,"Test Sample 11 for ExperimentStreakCells (Test Cell 1 in LB in DWP 3)" <> $SessionUUID],
          Object[Sample,"Test Sample 12 for ExperimentStreakCells (Test Cell 1 in LB in DWP 4)" <> $SessionUUID],
          Object[Sample,"Test Sample 13 for ExperimentStreakCells (Test Cell 1 in LB in DWP 5)" <> $SessionUUID],
          Object[Sample,"Test Sample 14 for ExperimentStreakCells (Test Cell 1 in LB in DWP 6)" <> $SessionUUID],
          Object[Sample,"Test Sample 15 for ExperimentStreakCells (Test Cell 1 in LB in DWP 7)" <> $SessionUUID],
          Object[Sample,"Test Sample 16 for ExperimentStreakCells (Test Cell 1 in LB in DWP 8)" <> $SessionUUID],
          Object[Sample,"Test Sample 17 for ExperimentStreakCells (Test Cell 1 in LB in DWP 9)" <> $SessionUUID],
          Object[Sample,"Test Sample 18 for ExperimentStreakCells (Test Cell 1 in LB in DWP 10)" <> $SessionUUID],
          Object[Sample,"Test Sample 19 for ExperimentStreakCells (Incompatible sample in DWP 11)" <> $SessionUUID],
          Object[Sample, "Test Sample 20 for ExperimentStreakCells (freeze dried cell 1 in ampoule 1)" <> $SessionUUID],
          Object[Sample, "Test Sample 21 for ExperimentStreakCells (freeze dried cell 1 in ampoule 2)" <> $SessionUUID],
          Object[Sample, "Test Sample 22 for ExperimentStreakCells (cell 1 in frozen glycerol in cryoVial 1)" <> $SessionUUID],
          Object[Sample, "Test Sample 23 for ExperimentStreakCells (cell 1 in frozen glycerol in cryoVial 2)" <> $SessionUUID],
          Object[Sample, "Test Sample 24 for ExperimentStreakCells (freeze dried cell 2 in ampoule 3)" <> $SessionUUID],
          Object[Sample,"Test Wash Solution for ExperimentStreakCells (MilliQ)" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs=PickList[objs,DatabaseMemberQ[objs]];
      EraseObject[existingObjs,Force->True,Verbose->False];
      On[Warning::SamplesOutOfStock];
    ]
  )
];

(* ::Subsection:: *)
(* ExperimentStreakCellsOptions *)
DefineTests[ExperimentStreakCellsOptions,
  {
    Example[{Basic,"Display the option values which will be used in the experiment:"},
      ExperimentStreakCellsOptions[
        Object[Sample,"Test Sample 1 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        StreakVolume -> 50 Microliter
      ],
      _Grid
    ],
    Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
      ExperimentStreakCellsOptions[
        Object[Sample,"Test Sample 1 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        SourceMix -> True,
        NumberOfSourceMixes -> Null
      ],
      _Grid,
      Messages :> {Error::SourceMixMismatch,Error::InvalidOption}
    ],

    Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
      ExperimentStreakCellsOptions[
        Object[Sample,"Test Sample 1 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        DilutionType -> Linear,
        OutputFormat -> List
      ],
      {(_Rule|_RuleDelayed)..}
    ]
  },
  SymbolSetUp :> (
    Module[{objs,existingObjs},
      objs=Quiet[Cases[
        Flatten[{
          (* Bench *)
          Object[Container,Bench,"Bench for ExperimentStreakCellsOptions Testing"<>$SessionUUID],

          (* Containers *)
          Object[Container,Plate,"Test DWP 1 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 2 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 3 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 4 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 5 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 6 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 7 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 8 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 9 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 10 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 1 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 2 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 3 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL Tube 1 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test UV Star Plate 1 for ExperimentStreakCellsOptions" <> $SessionUUID],

          (* Cells *)
          Model[Cell,Bacteria,"Test Cell 1 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Model[Cell,Bacteria,"Test Cell 1 for ExperimentStreakCellsOptions - no PrefSolidMedia" <> $SessionUUID],

          (* Media *)
          Model[Sample,Media,"Test Solid Media for ExperimentStreakCellsOptions" <> $SessionUUID],

          (* Sample Models *)
          Model[Sample,"Test Sample Model 1 for ExperimentStreakCellsOptions (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 2 for ExperimentStreakCellsOptions (5000 Cell/Milliliter Test Cell 2 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 3 for ExperimentStreakCellsOptions (5000 Cell/Milliliter Test Cell 1 in TB Broth)" <> $SessionUUID],

          (* Samples *)
          Object[Sample,"Test Sample 1 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 2 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCellsOptions (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 4 for ExperimentStreakCellsOptions (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 5 for ExperimentStreakCellsOptions (LB Broth in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 6 for ExperimentStreakCellsOptions (LB Broth in 50 mL Tube)" <> $SessionUUID],
          Object[Sample,"Test Sample 7 for ExperimentStreakCellsOptions (Solid LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 8 for ExperimentStreakCellsOptions (Test Cell 1 in TB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 9 for ExperimentStreakCellsOptions (LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 10 for ExperimentStreakCellsOptions (Test Cell 1 in LB in UV Star 1)"<>$SessionUUID],
          Object[Sample,"Test Sample 11 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 3)" <> $SessionUUID],
          Object[Sample,"Test Sample 12 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 4)" <> $SessionUUID],
          Object[Sample,"Test Sample 13 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 5)" <> $SessionUUID],
          Object[Sample,"Test Sample 14 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 6)" <> $SessionUUID],
          Object[Sample,"Test Sample 15 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 7)" <> $SessionUUID],
          Object[Sample,"Test Sample 16 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 8)" <> $SessionUUID],
          Object[Sample,"Test Sample 17 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 9)" <> $SessionUUID],
          Object[Sample,"Test Sample 18 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 10)" <> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjs=PickList[objs,DatabaseMemberQ[objs]];
      EraseObject[existingObjs,Force->True,Verbose->False]
    ];
    Block[{$DeveloperUpload = True},
      Module[
        {
          testBench,inputPlate1,inputPlate2,inputPlate3, inputPlate4, inputPlate5, inputPlate6, inputPlate7, inputPlate8, inputPlate9,
          inputPlate10,destinationPlate1,destinationPlate2,invalidDestinationPlate,diluentTube,uvStarPlate1,testCell1,testCell2NoPrefSolidMedia,testSolidMedia,
          testCell1InLB,testCell2InLB,testCell1InTB,testCell1InLBSample1,testCell1InLBSample2,testCell2InLBSample2,testCell2InLBSample1,
          testCell1InTBSample1,lbBrothSample, lbBrothDiluentSample,destinationSample,invalidDestinationSample,testCell1inUVStar,
          testCell1InLBSample3, testCell1InLBSample4, testCell1InLBSample5, testCell1InLBSample6, testCell1InLBSample7, testCell1InLBSample8,
          testCell1InLBSample9, testCell1InLBSample10
        },

        (* Create test bench for containers *)
        (* Upload bench *)
        testBench = Upload[
          <|
            Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
            Type->Object[Container,Bench],
            Name->"Bench for ExperimentStreakCellsOptions Testing"<>$SessionUUID
          |>
        ];

        (* Containers *)
        {
          inputPlate1,
          inputPlate2,
          inputPlate3,
          inputPlate4,
          inputPlate5,
          inputPlate6,
          inputPlate7,
          inputPlate8,
          inputPlate9,
          inputPlate10,
          destinationPlate1,
          destinationPlate2,
          invalidDestinationPlate,
          diluentTube,
          uvStarPlate1
        } = UploadSample[
          {
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:O81aEBZjRXvx"], (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
            Model[Container, Plate, "id:O81aEBZjRXvx"], (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
            Model[Container, Plate, "id:O81aEBZjRXvx"], (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
            Model[Container, Vessel, "id:bq9LA0dBGGR6"], (* Model[Container, Vessel, "50mL Tube"] *)
            Model[Container, Plate, "id:n0k9mGzRaaBn"] (* Model[Container, Plate, "96-well UV-Star Plate"] *)
          },
          ConstantArray[{"Work Surface",testBench},15],
          Name -> {
            "Test DWP 1 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test DWP 2 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test DWP 3 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test DWP 4 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test DWP 5 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test DWP 6 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test DWP 7 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test DWP 8 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test DWP 9 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test DWP 10 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test Omnitray 1 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test Omnitray 2 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test Omnitray 3 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test 50 mL Tube 1 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test UV Star Plate 1 for ExperimentStreakCellsOptions" <> $SessionUUID
          }
        ];

        (* Cells *)
        {
          testCell1,
          testCell2NoPrefSolidMedia
        } = UploadBacterialCell[
          {
            "Test Cell 1 for ExperimentStreakCellsOptions" <> $SessionUUID,
            "Test Cell 1 for ExperimentStreakCellsOptions - no PrefSolidMedia" <> $SessionUUID
          },
          Morphology -> Cocci,
          BiosafetyLevel -> "BSL-1",
          Flammable -> False,
          MSDSFile -> NotApplicable,
          IncompatibleMaterials -> {None},
          CellType -> Bacterial,
          CultureAdhesion -> Suspension,
          PreferredSolidMedia -> {Model[Sample, Media, "id:9RdZXvdwAEo6"] (* Model[Sample, Media, "LB (Solid Agar)"] *),Null}
        ];

        (* Media *)
        testSolidMedia = UploadStockSolution[
          {{Quantity[20,"Grams"],Model[Sample,"Agar"]},{Quantity[25,"Grams"],Model[Sample,"LB Broth Miller (Sigma Aldrich)"]},{Quantity[900,"Milliliters"],Model[Sample,"Milli-Q water"]}},
          Model[Sample,"Milli-Q water"],
          1 Liter,
          Name -> "Test Solid Media for ExperimentStreakCellsOptions" <> $SessionUUID,
          Type -> Media,
          DefaultStorageCondition -> AmbientStorage,
          Expires -> True
        ];
        (* Fix the state *)
        Upload[<|
          Object -> testSolidMedia,
          State -> Solid
        |>];

        (* Sample Models *)
        {
          testCell1InLB,
          testCell2InLB,
          testCell1InTB
        } = UploadSampleModel[
          {
            "Test Sample Model 1 for ExperimentStreakCellsOptions (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID,
            "Test Sample Model 2 for ExperimentStreakCellsOptions (5000 Cell/Milliliter Test Cell 2 in LB Broth)" <> $SessionUUID,
            "Test Sample Model 3 for ExperimentStreakCellsOptions (5000 Cell/Milliliter Test Cell 1 in TB Broth)" <> $SessionUUID
          },
          Composition -> {
            {
              {5000 Cell/Milliliter, testCell1},
              {Quantity[95, IndependentUnit["VolumePercent"]], Model[Molecule, "Water"]},
              {Quantity[171.116, "Millimolar"], Model[Molecule, "Sodium Chloride"]},
              {Quantity[0.005, ("Grams")/("Milliliters")], Model[Molecule, "Yeast Extract"]}
            },
            {
              {5000 Cell/Milliliter, testCell2NoPrefSolidMedia},
              {Quantity[95, IndependentUnit["VolumePercent"]], Model[Molecule, "Water"]},
              {Quantity[171.116, "Millimolar"], Model[Molecule, "Sodium Chloride"]},
              {Quantity[0.005, ("Grams")/("Milliliters")], Model[Molecule, "Yeast Extract"]}
            },
            {
              {0.8 OD600, testCell1},
              {95 VolumePercent, Model[Molecule,"Water"]},
              {55 Millimolar, Model[Molecule, "Potassium Phosphate (Dibasic)"]},
              {10 Millimolar, Model[Molecule, "Potassium Phosphate (Monobasic)"]},
              {0.4 VolumePercent, Model[Molecule, "Glycerol"]},
              {0.024 Gram/Milliliter, Model[Molecule, "Yeast Extract"]}
            }
          },
          IncompatibleMaterials -> {None},
          Expires -> False,
          DefaultStorageCondition -> {
            Model[StorageCondition, "id:7X104vnR18vX"], (* Model[StorageCondition, "Ambient Storage"] *)
            Model[StorageCondition, "id:7X104vnR18vX"], (* Model[StorageCondition, "Ambient Storage"] *)
            Model[StorageCondition, "id:7X104vnR18vX"] (* Model[StorageCondition, "Ambient Storage"] *)
          },
          Flammable -> False,
          MSDSFile -> NotApplicable,
          BiosafetyLevel -> "BSL-1",
          State -> Liquid,
          UsedAsSolvent -> False,
          UsedAsMedia -> False,
          Living -> True
        ];

        (* Samples *)
        {
          testCell1InLBSample1,
          testCell1InLBSample2,
          testCell2InLBSample1,
          testCell2InLBSample2,
          testCell1InTBSample1,
          lbBrothSample,
          lbBrothDiluentSample,
          destinationSample,
          invalidDestinationSample,
          testCell1inUVStar,
          testCell1InLBSample3,
          testCell1InLBSample4,
          testCell1InLBSample5,
          testCell1InLBSample6,
          testCell1InLBSample7,
          testCell1InLBSample8,
          testCell1InLBSample9,
          testCell1InLBSample10
        } = UploadSample[
          {
            testCell1InLB,
            testCell1InLB,
            testCell2InLB,
            testCell2InLB,
            testCell1InTB,
            Model[Sample, Media, "id:XnlV5jlXbNx8"], (* Model[Sample, Media, "LB Broth, Miller"] *)
            Model[Sample, Media, "id:XnlV5jlXbNx8"], (* Model[Sample, Media, "LB Broth, Miller"] *)
            Model[Sample, Media, "id:9RdZXvdwAEo6"], (* Model[Sample, Media, "LB (Solid Agar)"] *)
            Model[Sample, Media, "id:XnlV5jlXbNx8"], (* Model[Sample, Media, "LB Broth, Miller"] *)
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB
          },
          {
            {"A1",inputPlate1},
            {"B1",inputPlate1},
            {"A1",inputPlate2},
            {"B1",inputPlate2},
            {"C1",inputPlate1},
            {"D1",inputPlate1},
            {"A1",diluentTube},
            {"A1",destinationPlate1},
            {"A1",invalidDestinationPlate},
            {"A1",uvStarPlate1},
            {"A1",inputPlate3},
            {"A1",inputPlate4},
            {"A1",inputPlate5},
            {"A1",inputPlate6},
            {"A1",inputPlate7},
            {"A1",inputPlate8},
            {"A1",inputPlate9},
            {"A1",inputPlate10}
          },
          Name -> {
            "Test Sample 1 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 1)" <> $SessionUUID,
            "Test Sample 2 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 1)" <> $SessionUUID,
            "Test Sample 3 for ExperimentStreakCellsOptions (Test Cell 2 in LB in DWP 2)" <> $SessionUUID,
            "Test Sample 4 for ExperimentStreakCellsOptions (Test Cell 2 in LB in DWP 2)" <> $SessionUUID,
            "Test Sample 8 for ExperimentStreakCellsOptions (Test Cell 1 in TB in DWP 1)" <> $SessionUUID,
            "Test Sample 5 for ExperimentStreakCellsOptions (LB Broth in DWP 1)" <> $SessionUUID,
            "Test Sample 6 for ExperimentStreakCellsOptions (LB Broth in 50 mL Tube)" <> $SessionUUID,
            "Test Sample 7 for ExperimentStreakCellsOptions (Solid LB Agar in Omnitray)" <> $SessionUUID,
            "Test Sample 9 for ExperimentStreakCellsOptions (LB Agar in Omnitray)" <> $SessionUUID,
            "Test Sample 10 for ExperimentStreakCellsOptions (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID,
            "Test Sample 11 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 3)" <> $SessionUUID,
            "Test Sample 12 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 4)" <> $SessionUUID,
            "Test Sample 13 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 5)" <> $SessionUUID,
            "Test Sample 14 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 6)" <> $SessionUUID,
            "Test Sample 15 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 7)" <> $SessionUUID,
            "Test Sample 16 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 8)" <> $SessionUUID,
            "Test Sample 17 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 9)" <> $SessionUUID,
            "Test Sample 18 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 10)" <> $SessionUUID
          },
          InitialAmount -> {
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1.5 Milliliter,
            1 Milliliter,
            1.23 Milliliter,
            20 Milliliter,
            10 Gram,
            20 Milliliter,
            500 Microliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter
          },
          State -> {
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Solid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid
          },
          StorageCondition -> ConstantArray[Model[StorageCondition, "Ambient Storage"],18]
        ];

        (* Other info to upload/correct *)
        Upload[
          {
            <|
              Object -> Object[Sample,"Test Sample 1 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 2 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 3 for ExperimentStreakCellsOptions (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 4 for ExperimentStreakCellsOptions (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 8 for ExperimentStreakCellsOptions (Test Cell 1 in TB in DWP 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "Terrific Broth"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 9 for ExperimentStreakCellsOptions (LB Agar in Omnitray)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "id:XnlV5jlXbNx8"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 10 for ExperimentStreakCellsOptions (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>
          }
        ]

      ]
    ]
  ),
  SymbolTearDown :> (
    Module[{objs,existingObjs},
      objs=Quiet[Cases[
        Flatten[{
          (* Bench *)
          Object[Container,Bench,"Bench for ExperimentStreakCellsOptions Testing"<>$SessionUUID],

          (* Containers *)
          Object[Container,Plate,"Test DWP 1 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 2 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 3 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 4 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 5 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 6 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 7 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 8 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 9 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 10 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 1 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 2 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 3 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL Tube 1 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Object[Container,Plate,"Test UV Star Plate 1 for ExperimentStreakCellsOptions" <> $SessionUUID],

          (* Cells *)
          Model[Cell,Bacteria,"Test Cell 1 for ExperimentStreakCellsOptions" <> $SessionUUID],
          Model[Cell,Bacteria,"Test Cell 1 for ExperimentStreakCellsOptions - no PrefSolidMedia" <> $SessionUUID],

          (* Media *)
          Model[Sample,Media,"Test Solid Media for ExperimentStreakCellsOptions" <> $SessionUUID],

          (* Sample Models *)
          Model[Sample,"Test Sample Model 1 for ExperimentStreakCellsOptions (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 2 for ExperimentStreakCellsOptions (5000 Cell/Milliliter Test Cell 2 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 3 for ExperimentStreakCellsOptions (5000 Cell/Milliliter Test Cell 1 in TB Broth)" <> $SessionUUID],

          (* Samples *)
          Object[Sample,"Test Sample 1 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 2 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCellsOptions (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 4 for ExperimentStreakCellsOptions (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 5 for ExperimentStreakCellsOptions (LB Broth in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 6 for ExperimentStreakCellsOptions (LB Broth in 50 mL Tube)" <> $SessionUUID],
          Object[Sample,"Test Sample 7 for ExperimentStreakCellsOptions (Solid LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 8 for ExperimentStreakCellsOptions (Test Cell 1 in TB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 9 for ExperimentStreakCellsOptions (LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 10 for ExperimentStreakCellsOptions (Test Cell 1 in LB in UV Star 1)"<>$SessionUUID],
          Object[Sample,"Test Sample 11 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 3)" <> $SessionUUID],
          Object[Sample,"Test Sample 12 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 4)" <> $SessionUUID],
          Object[Sample,"Test Sample 13 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 5)" <> $SessionUUID],
          Object[Sample,"Test Sample 14 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 6)" <> $SessionUUID],
          Object[Sample,"Test Sample 15 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 7)" <> $SessionUUID],
          Object[Sample,"Test Sample 16 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 8)" <> $SessionUUID],
          Object[Sample,"Test Sample 17 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 9)" <> $SessionUUID],
          Object[Sample,"Test Sample 18 for ExperimentStreakCellsOptions (Test Cell 1 in LB in DWP 10)" <> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjs=PickList[objs,DatabaseMemberQ[objs]];
      EraseObject[existingObjs,Force->True,Verbose->False]
    ]
  )
]

(* ::Subsection:: *)
(* ValidExperimentStreakCellsQ *)
DefineTests[ValidExperimentStreakCellsQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentStreakCellsQ[
        Object[Sample,"Test Sample 1 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        StreakVolume -> 50 Microliter
      ],
      True
    ],
    Example[{Basic,"Return False if there are problems with the inputs or options:"},
      ValidExperimentStreakCellsQ[
        Object[Sample,"Test Sample 1 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        SourceMix -> True,
        NumberOfSourceMixes -> Null
      ],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentStreakCellsQ[
        Object[Sample,"Test Sample 1 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        StreakVolume -> 50 Microliter,
        OutputFormat -> TestSummary
      ],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentStreakCellsQ[
        Object[Sample,"Test Sample 1 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        StreakVolume -> 50 Microliter,
        Verbose -> True
      ],
      True
    ]
  },
  SymbolSetUp :> (
    Module[{objs,existingObjs},
      objs=Quiet[Cases[
        Flatten[{
          (* Bench *)
          Object[Container,Bench,"Bench for ValidExperimentStreakCellsQ Testing"<>$SessionUUID],

          (* Containers *)
          Object[Container,Plate,"Test DWP 1 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 2 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 3 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 4 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 5 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 6 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 7 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 8 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 9 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 10 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 1 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 2 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 3 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL Tube 1 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test UV Star Plate 1 for ValidExperimentStreakCellsQ" <> $SessionUUID],

          (* Cells *)
          Model[Cell,Bacteria,"Test Cell 1 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Model[Cell,Bacteria,"Test Cell 1 for ValidExperimentStreakCellsQ - no PrefSolidMedia" <> $SessionUUID],

          (* Media *)
          Model[Sample,Media,"Test Solid Media for ValidExperimentStreakCellsQ" <> $SessionUUID],

          (* Sample Models *)
          Model[Sample,"Test Sample Model 1 for ValidExperimentStreakCellsQ (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 2 for ValidExperimentStreakCellsQ (5000 Cell/Milliliter Test Cell 2 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 3 for ValidExperimentStreakCellsQ (5000 Cell/Milliliter Test Cell 1 in TB Broth)" <> $SessionUUID],

          (* Samples *)
          Object[Sample,"Test Sample 1 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 2 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ValidExperimentStreakCellsQ (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 4 for ValidExperimentStreakCellsQ (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 5 for ValidExperimentStreakCellsQ (LB Broth in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 6 for ValidExperimentStreakCellsQ (LB Broth in 50 mL Tube)" <> $SessionUUID],
          Object[Sample,"Test Sample 7 for ValidExperimentStreakCellsQ (Solid LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 8 for ValidExperimentStreakCellsQ (Test Cell 1 in TB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 9 for ValidExperimentStreakCellsQ (LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 10 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in UV Star 1)"<>$SessionUUID],
          Object[Sample,"Test Sample 11 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 3)" <> $SessionUUID],
          Object[Sample,"Test Sample 12 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 4)" <> $SessionUUID],
          Object[Sample,"Test Sample 13 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 5)" <> $SessionUUID],
          Object[Sample,"Test Sample 14 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 6)" <> $SessionUUID],
          Object[Sample,"Test Sample 15 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 7)" <> $SessionUUID],
          Object[Sample,"Test Sample 16 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 8)" <> $SessionUUID],
          Object[Sample,"Test Sample 17 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 9)" <> $SessionUUID],
          Object[Sample,"Test Sample 18 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 10)" <> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjs=PickList[objs,DatabaseMemberQ[objs]];
      EraseObject[existingObjs,Force->True,Verbose->False]
    ];
    Block[{$DeveloperUpload = True},
      Module[
        {
          testBench,inputPlate1,inputPlate2,inputPlate3, inputPlate4, inputPlate5, inputPlate6, inputPlate7, inputPlate8, inputPlate9,
          inputPlate10,destinationPlate1,destinationPlate2,invalidDestinationPlate,diluentTube,uvStarPlate1,testCell1,testCell2NoPrefSolidMedia,testSolidMedia,
          testCell1InLB,testCell2InLB,testCell1InTB,testCell1InLBSample1,testCell1InLBSample2,testCell2InLBSample2,testCell2InLBSample1,
          testCell1InTBSample1,lbBrothSample, lbBrothDiluentSample,destinationSample,invalidDestinationSample,testCell1inUVStar,
          testCell1InLBSample3, testCell1InLBSample4, testCell1InLBSample5, testCell1InLBSample6, testCell1InLBSample7, testCell1InLBSample8,
          testCell1InLBSample9, testCell1InLBSample10
        },

        (* Create test bench for containers *)
        (* Upload bench *)
        testBench = Upload[
          <|
            Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
            Type->Object[Container,Bench],
            Name->"Bench for ValidExperimentStreakCellsQ Testing"<>$SessionUUID
          |>
        ];

        (* Containers *)
        {
          inputPlate1,
          inputPlate2,
          inputPlate3,
          inputPlate4,
          inputPlate5,
          inputPlate6,
          inputPlate7,
          inputPlate8,
          inputPlate9,
          inputPlate10,
          destinationPlate1,
          destinationPlate2,
          invalidDestinationPlate,
          diluentTube,
          uvStarPlate1
        } = UploadSample[
          {
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:O81aEBZjRXvx"], (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
            Model[Container, Plate, "id:O81aEBZjRXvx"], (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
            Model[Container, Plate, "id:O81aEBZjRXvx"], (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
            Model[Container, Vessel, "id:bq9LA0dBGGR6"], (* Model[Container, Vessel, "50mL Tube"] *)
            Model[Container, Plate, "id:n0k9mGzRaaBn"] (* Model[Container, Plate, "96-well UV-Star Plate"] *)
          },
          ConstantArray[{"Work Surface",testBench},15],
          Name -> {
            "Test DWP 1 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test DWP 2 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test DWP 3 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test DWP 4 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test DWP 5 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test DWP 6 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test DWP 7 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test DWP 8 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test DWP 9 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test DWP 10 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test Omnitray 1 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test Omnitray 2 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test Omnitray 3 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test 50 mL Tube 1 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test UV Star Plate 1 for ValidExperimentStreakCellsQ" <> $SessionUUID
          }
        ];

        (* Cells *)
        {
          testCell1,
          testCell2NoPrefSolidMedia
        } = UploadBacterialCell[
          {
            "Test Cell 1 for ValidExperimentStreakCellsQ" <> $SessionUUID,
            "Test Cell 1 for ValidExperimentStreakCellsQ - no PrefSolidMedia" <> $SessionUUID
          },
          Morphology -> Cocci,
          BiosafetyLevel -> "BSL-1",
          Flammable -> False,
          MSDSFile -> NotApplicable,
          IncompatibleMaterials -> {None},
          CellType -> Bacterial,
          CultureAdhesion -> Suspension,
          PreferredSolidMedia -> {Model[Sample, Media, "id:9RdZXvdwAEo6"] (* Model[Sample, Media, "LB (Solid Agar)"] *),Null}
        ];

        (* Media *)
        testSolidMedia = UploadStockSolution[
          {{Quantity[20,"Grams"],Model[Sample,"Agar"]},{Quantity[25,"Grams"],Model[Sample,"LB Broth Miller (Sigma Aldrich)"]},{Quantity[900,"Milliliters"],Model[Sample,"Milli-Q water"]}},
          Model[Sample,"Milli-Q water"],
          1 Liter,
          Name -> "Test Solid Media for ValidExperimentStreakCellsQ" <> $SessionUUID,
          Type -> Media,
          DefaultStorageCondition -> AmbientStorage,
          Expires -> True
        ];
        (* Fix the state *)
        Upload[<|
          Object -> testSolidMedia,
          State -> Solid
        |>];

        (* Sample Models *)
        {
          testCell1InLB,
          testCell2InLB,
          testCell1InTB
        } = UploadSampleModel[
          {
            "Test Sample Model 1 for ValidExperimentStreakCellsQ (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID,
            "Test Sample Model 2 for ValidExperimentStreakCellsQ (5000 Cell/Milliliter Test Cell 2 in LB Broth)" <> $SessionUUID,
            "Test Sample Model 3 for ValidExperimentStreakCellsQ (5000 Cell/Milliliter Test Cell 1 in TB Broth)" <> $SessionUUID
          },
          Composition -> {
            {
              {5000 Cell/Milliliter, testCell1},
              {Quantity[95, IndependentUnit["VolumePercent"]], Model[Molecule, "Water"]},
              {Quantity[171.116, "Millimolar"], Model[Molecule, "Sodium Chloride"]},
              {Quantity[0.005, ("Grams")/("Milliliters")], Model[Molecule, "Yeast Extract"]}
            },
            {
              {5000 Cell/Milliliter, testCell2NoPrefSolidMedia},
              {Quantity[95, IndependentUnit["VolumePercent"]], Model[Molecule, "Water"]},
              {Quantity[171.116, "Millimolar"], Model[Molecule, "Sodium Chloride"]},
              {Quantity[0.005, ("Grams")/("Milliliters")], Model[Molecule, "Yeast Extract"]}
            },
            {
              {0.8 OD600, testCell1},
              {95 VolumePercent, Model[Molecule,"Water"]},
              {55 Millimolar, Model[Molecule, "Potassium Phosphate (Dibasic)"]},
              {10 Millimolar, Model[Molecule, "Potassium Phosphate (Monobasic)"]},
              {0.4 VolumePercent, Model[Molecule, "Glycerol"]},
              {0.024 Gram/Milliliter, Model[Molecule, "Yeast Extract"]}
            }
          },
          IncompatibleMaterials -> {None},
          Expires -> False,
          DefaultStorageCondition -> {
            Model[StorageCondition, "id:7X104vnR18vX"], (* Model[StorageCondition, "Ambient Storage"] *)
            Model[StorageCondition, "id:7X104vnR18vX"], (* Model[StorageCondition, "Ambient Storage"] *)
            Model[StorageCondition, "id:7X104vnR18vX"] (* Model[StorageCondition, "Ambient Storage"] *)
          },
          Flammable -> False,
          MSDSFile -> NotApplicable,
          BiosafetyLevel -> "BSL-1",
          State -> Liquid,
          UsedAsSolvent -> False,
          UsedAsMedia -> False,
          Living -> True
        ];

        (* Samples *)
        {
          testCell1InLBSample1,
          testCell1InLBSample2,
          testCell2InLBSample1,
          testCell2InLBSample2,
          testCell1InTBSample1,
          lbBrothSample,
          lbBrothDiluentSample,
          destinationSample,
          invalidDestinationSample,
          testCell1inUVStar,
          testCell1InLBSample3,
          testCell1InLBSample4,
          testCell1InLBSample5,
          testCell1InLBSample6,
          testCell1InLBSample7,
          testCell1InLBSample8,
          testCell1InLBSample9,
          testCell1InLBSample10
        } = UploadSample[
          {
            testCell1InLB,
            testCell1InLB,
            testCell2InLB,
            testCell2InLB,
            testCell1InTB,
            Model[Sample, Media, "id:XnlV5jlXbNx8"], (* Model[Sample, Media, "LB Broth, Miller"] *)
            Model[Sample, Media, "id:XnlV5jlXbNx8"], (* Model[Sample, Media, "LB Broth, Miller"] *)
            Model[Sample, Media, "id:9RdZXvdwAEo6"], (* Model[Sample, Media, "LB (Solid Agar)"] *)
            Model[Sample, Media, "id:XnlV5jlXbNx8"], (* Model[Sample, Media, "LB Broth, Miller"] *)
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB
          },
          {
            {"A1",inputPlate1},
            {"B1",inputPlate1},
            {"A1",inputPlate2},
            {"B1",inputPlate2},
            {"C1",inputPlate1},
            {"D1",inputPlate1},
            {"A1",diluentTube},
            {"A1",destinationPlate1},
            {"A1",invalidDestinationPlate},
            {"A1",uvStarPlate1},
            {"A1",inputPlate3},
            {"A1",inputPlate4},
            {"A1",inputPlate5},
            {"A1",inputPlate6},
            {"A1",inputPlate7},
            {"A1",inputPlate8},
            {"A1",inputPlate9},
            {"A1",inputPlate10}
          },
          Name -> {
            "Test Sample 1 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 1)" <> $SessionUUID,
            "Test Sample 2 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 1)" <> $SessionUUID,
            "Test Sample 3 for ValidExperimentStreakCellsQ (Test Cell 2 in LB in DWP 2)" <> $SessionUUID,
            "Test Sample 4 for ValidExperimentStreakCellsQ (Test Cell 2 in LB in DWP 2)" <> $SessionUUID,
            "Test Sample 8 for ValidExperimentStreakCellsQ (Test Cell 1 in TB in DWP 1)" <> $SessionUUID,
            "Test Sample 5 for ValidExperimentStreakCellsQ (LB Broth in DWP 1)" <> $SessionUUID,
            "Test Sample 6 for ValidExperimentStreakCellsQ (LB Broth in 50 mL Tube)" <> $SessionUUID,
            "Test Sample 7 for ValidExperimentStreakCellsQ (Solid LB Agar in Omnitray)" <> $SessionUUID,
            "Test Sample 9 for ValidExperimentStreakCellsQ (LB Agar in Omnitray)" <> $SessionUUID,
            "Test Sample 10 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID,
            "Test Sample 11 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 3)" <> $SessionUUID,
            "Test Sample 12 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 4)" <> $SessionUUID,
            "Test Sample 13 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 5)" <> $SessionUUID,
            "Test Sample 14 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 6)" <> $SessionUUID,
            "Test Sample 15 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 7)" <> $SessionUUID,
            "Test Sample 16 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 8)" <> $SessionUUID,
            "Test Sample 17 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 9)" <> $SessionUUID,
            "Test Sample 18 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 10)" <> $SessionUUID
          },
          InitialAmount -> {
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1.5 Milliliter,
            1 Milliliter,
            1.23 Milliliter,
            20 Milliliter,
            10 Gram,
            20 Milliliter,
            500 Microliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter
          },
          State -> {
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Solid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid
          },
          StorageCondition -> ConstantArray[Model[StorageCondition, "Ambient Storage"],18]
        ];

        (* Other info to upload/correct *)
        Upload[
          {
            <|
              Object -> Object[Sample,"Test Sample 1 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 2 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 3 for ValidExperimentStreakCellsQ (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 4 for ValidExperimentStreakCellsQ (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 8 for ValidExperimentStreakCellsQ (Test Cell 1 in TB in DWP 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "Terrific Broth"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 9 for ValidExperimentStreakCellsQ (LB Agar in Omnitray)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "id:XnlV5jlXbNx8"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 10 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>
          }
        ]

      ]
    ]
  ),
  SymbolTearDown :> (
    Module[{objs,existingObjs},
      objs=Quiet[Cases[
        Flatten[{
          (* Bench *)
          Object[Container,Bench,"Bench for ValidExperimentStreakCellsQ Testing"<>$SessionUUID],

          (* Containers *)
          Object[Container,Plate,"Test DWP 1 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 2 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 3 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 4 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 5 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 6 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 7 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 8 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 9 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 10 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 1 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 2 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 3 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL Tube 1 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Object[Container,Plate,"Test UV Star Plate 1 for ValidExperimentStreakCellsQ" <> $SessionUUID],

          (* Cells *)
          Model[Cell,Bacteria,"Test Cell 1 for ValidExperimentStreakCellsQ" <> $SessionUUID],
          Model[Cell,Bacteria,"Test Cell 1 for ValidExperimentStreakCellsQ - no PrefSolidMedia" <> $SessionUUID],

          (* Media *)
          Model[Sample,Media,"Test Solid Media for ValidExperimentStreakCellsQ" <> $SessionUUID],

          (* Sample Models *)
          Model[Sample,"Test Sample Model 1 for ValidExperimentStreakCellsQ (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 2 for ValidExperimentStreakCellsQ (5000 Cell/Milliliter Test Cell 2 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 3 for ValidExperimentStreakCellsQ (5000 Cell/Milliliter Test Cell 1 in TB Broth)" <> $SessionUUID],

          (* Samples *)
          Object[Sample,"Test Sample 1 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 2 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ValidExperimentStreakCellsQ (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 4 for ValidExperimentStreakCellsQ (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 5 for ValidExperimentStreakCellsQ (LB Broth in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 6 for ValidExperimentStreakCellsQ (LB Broth in 50 mL Tube)" <> $SessionUUID],
          Object[Sample,"Test Sample 7 for ValidExperimentStreakCellsQ (Solid LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 8 for ValidExperimentStreakCellsQ (Test Cell 1 in TB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 9 for ValidExperimentStreakCellsQ (LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 10 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in UV Star 1)"<>$SessionUUID],
          Object[Sample,"Test Sample 11 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 3)" <> $SessionUUID],
          Object[Sample,"Test Sample 12 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 4)" <> $SessionUUID],
          Object[Sample,"Test Sample 13 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 5)" <> $SessionUUID],
          Object[Sample,"Test Sample 14 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 6)" <> $SessionUUID],
          Object[Sample,"Test Sample 15 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 7)" <> $SessionUUID],
          Object[Sample,"Test Sample 16 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 8)" <> $SessionUUID],
          Object[Sample,"Test Sample 17 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 9)" <> $SessionUUID],
          Object[Sample,"Test Sample 18 for ValidExperimentStreakCellsQ (Test Cell 1 in LB in DWP 10)" <> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjs=PickList[objs,DatabaseMemberQ[objs]];
      EraseObject[existingObjs,Force->True,Verbose->False]
    ]
  )
];

(* ::Subsection:: *)
(* ExperimentStreakCellsPreview *)
DefineTests[
  ExperimentStreakCellsPreview,
  {
    (* --- Basic Examples --- *)
    Example[
      {Basic, "Generate a preview for an ExperimentStreakCells call to pick colonies from a single sample:"},
      ExperimentStreakCellsPreview[Object[Sample,"Test Sample 1 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]],
      Null
    ],
    Example[
      {Basic, "Generate a preview for an ExperimentStreakCells call to pick colonies from multiple samples:"},
      ExperimentStreakCellsPreview[{
        Object[Sample,"Test Sample 1 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
        Object[Sample,"Test Sample 2 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]
      }],
      Null
    ],
    Example[
      {Basic, "Generate a preview for an ExperimentStreakCells call to pick colonies from a single container:"},
      ExperimentStreakCellsPreview[Object[Container,Plate,"Test DWP 1 for ExperimentStreakCellsPreview" <> $SessionUUID]],
      Null
    ]
  },
  SymbolSetUp :> (
    Module[{objs,existingObjs},
      objs=Quiet[Cases[
        Flatten[{
          (* Bench *)
          Object[Container,Bench,"Bench for ExperimentStreakCellsPreview Testing"<>$SessionUUID],

          (* Containers *)
          Object[Container,Plate,"Test DWP 1 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 2 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 3 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 4 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 5 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 6 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 7 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 8 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 9 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 10 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 1 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 2 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 3 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL Tube 1 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test UV Star Plate 1 for ExperimentStreakCellsPreview" <> $SessionUUID],

          (* Cells *)
          Model[Cell,Bacteria,"Test Cell 1 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Model[Cell,Bacteria,"Test Cell 1 for ExperimentStreakCellsPreview - no PrefSolidMedia" <> $SessionUUID],

          (* Media *)
          Model[Sample,Media,"Test Solid Media for ExperimentStreakCellsPreview" <> $SessionUUID],

          (* Sample Models *)
          Model[Sample,"Test Sample Model 1 for ExperimentStreakCellsPreview (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 2 for ExperimentStreakCellsPreview (5000 Cell/Milliliter Test Cell 2 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 3 for ExperimentStreakCellsPreview (5000 Cell/Milliliter Test Cell 1 in TB Broth)" <> $SessionUUID],

          (* Samples *)
          Object[Sample,"Test Sample 1 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 2 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCellsPreview (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 4 for ExperimentStreakCellsPreview (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 5 for ExperimentStreakCellsPreview (LB Broth in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 6 for ExperimentStreakCellsPreview (LB Broth in 50 mL Tube)" <> $SessionUUID],
          Object[Sample,"Test Sample 7 for ExperimentStreakCellsPreview (Solid LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 8 for ExperimentStreakCellsPreview (Test Cell 1 in TB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 9 for ExperimentStreakCellsPreview (LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 10 for ExperimentStreakCellsPreview (Test Cell 1 in LB in UV Star 1)"<>$SessionUUID],
          Object[Sample,"Test Sample 11 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 3)" <> $SessionUUID],
          Object[Sample,"Test Sample 12 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 4)" <> $SessionUUID],
          Object[Sample,"Test Sample 13 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 5)" <> $SessionUUID],
          Object[Sample,"Test Sample 14 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 6)" <> $SessionUUID],
          Object[Sample,"Test Sample 15 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 7)" <> $SessionUUID],
          Object[Sample,"Test Sample 16 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 8)" <> $SessionUUID],
          Object[Sample,"Test Sample 17 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 9)" <> $SessionUUID],
          Object[Sample,"Test Sample 18 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 10)" <> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjs=PickList[objs,DatabaseMemberQ[objs]];
      EraseObject[existingObjs,Force->True,Verbose->False]
    ];
    Block[{$DeveloperUpload = True},
      Module[
        {
          testBench,inputPlate1,inputPlate2,inputPlate3, inputPlate4, inputPlate5, inputPlate6, inputPlate7, inputPlate8, inputPlate9,
          inputPlate10,destinationPlate1,destinationPlate2,invalidDestinationPlate,diluentTube,uvStarPlate1,testCell1,testCell2NoPrefSolidMedia,testSolidMedia,
          testCell1InLB,testCell2InLB,testCell1InTB,testCell1InLBSample1,testCell1InLBSample2,testCell2InLBSample2,testCell2InLBSample1,
          testCell1InTBSample1,lbBrothSample, lbBrothDiluentSample,destinationSample,invalidDestinationSample,testCell1inUVStar,
          testCell1InLBSample3, testCell1InLBSample4, testCell1InLBSample5, testCell1InLBSample6, testCell1InLBSample7, testCell1InLBSample8,
          testCell1InLBSample9, testCell1InLBSample10
        },

        (* Create test bench for containers *)
        (* Upload bench *)
        testBench = Upload[
          <|
            Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
            Type->Object[Container,Bench],
            Name->"Bench for ExperimentStreakCellsPreview Testing"<>$SessionUUID
          |>
        ];

        (* Containers *)
        {
          inputPlate1,
          inputPlate2,
          inputPlate3,
          inputPlate4,
          inputPlate5,
          inputPlate6,
          inputPlate7,
          inputPlate8,
          inputPlate9,
          inputPlate10,
          destinationPlate1,
          destinationPlate2,
          invalidDestinationPlate,
          diluentTube,
          uvStarPlate1
        } = UploadSample[
          {
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:O81aEBZjRXvx"], (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
            Model[Container, Plate, "id:O81aEBZjRXvx"], (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
            Model[Container, Plate, "id:O81aEBZjRXvx"], (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
            Model[Container, Vessel, "id:bq9LA0dBGGR6"], (* Model[Container, Vessel, "50mL Tube"] *)
            Model[Container, Plate, "id:n0k9mGzRaaBn"] (* Model[Container, Plate, "96-well UV-Star Plate"] *)
          },
          ConstantArray[{"Work Surface",testBench},15],
          Name -> {
            "Test DWP 1 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test DWP 2 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test DWP 3 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test DWP 4 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test DWP 5 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test DWP 6 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test DWP 7 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test DWP 8 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test DWP 9 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test DWP 10 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test Omnitray 1 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test Omnitray 2 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test Omnitray 3 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test 50 mL Tube 1 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test UV Star Plate 1 for ExperimentStreakCellsPreview" <> $SessionUUID
          }
        ];

        (* Cells *)
        {
          testCell1,
          testCell2NoPrefSolidMedia
        } = UploadBacterialCell[
          {
            "Test Cell 1 for ExperimentStreakCellsPreview" <> $SessionUUID,
            "Test Cell 1 for ExperimentStreakCellsPreview - no PrefSolidMedia" <> $SessionUUID
          },
          Morphology -> Cocci,
          BiosafetyLevel -> "BSL-1",
          Flammable -> False,
          MSDSFile -> NotApplicable,
          IncompatibleMaterials -> {None},
          CellType -> Bacterial,
          CultureAdhesion -> Suspension,
          PreferredSolidMedia -> {Model[Sample, Media, "id:9RdZXvdwAEo6"] (* Model[Sample, Media, "LB (Solid Agar)"] *),Null}
        ];

        (* Media *)
        testSolidMedia = UploadStockSolution[
          {{Quantity[20,"Grams"],Model[Sample,"Agar"]},{Quantity[25,"Grams"],Model[Sample,"LB Broth Miller (Sigma Aldrich)"]},{Quantity[900,"Milliliters"],Model[Sample,"Milli-Q water"]}},
          Model[Sample,"Milli-Q water"],
          1 Liter,
          Name -> "Test Solid Media for ExperimentStreakCellsPreview" <> $SessionUUID,
          Type -> Media,
          DefaultStorageCondition -> AmbientStorage,
          Expires -> True
        ];
        (* Fix the state *)
        Upload[<|
          Object -> testSolidMedia,
          State -> Solid
        |>];

        (* Sample Models *)
        {
          testCell1InLB,
          testCell2InLB,
          testCell1InTB
        } = UploadSampleModel[
          {
            "Test Sample Model 1 for ExperimentStreakCellsPreview (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID,
            "Test Sample Model 2 for ExperimentStreakCellsPreview (5000 Cell/Milliliter Test Cell 2 in LB Broth)" <> $SessionUUID,
            "Test Sample Model 3 for ExperimentStreakCellsPreview (5000 Cell/Milliliter Test Cell 1 in TB Broth)" <> $SessionUUID
          },
          Composition -> {
            {
              {5000 Cell/Milliliter, testCell1},
              {Quantity[95, IndependentUnit["VolumePercent"]], Model[Molecule, "Water"]},
              {Quantity[171.116, "Millimolar"], Model[Molecule, "Sodium Chloride"]},
              {Quantity[0.005, ("Grams")/("Milliliters")], Model[Molecule, "Yeast Extract"]}
            },
            {
              {5000 Cell/Milliliter, testCell2NoPrefSolidMedia},
              {Quantity[95, IndependentUnit["VolumePercent"]], Model[Molecule, "Water"]},
              {Quantity[171.116, "Millimolar"], Model[Molecule, "Sodium Chloride"]},
              {Quantity[0.005, ("Grams")/("Milliliters")], Model[Molecule, "Yeast Extract"]}
            },
            {
              {0.8 OD600, testCell1},
              {95 VolumePercent, Model[Molecule,"Water"]},
              {55 Millimolar, Model[Molecule, "Potassium Phosphate (Dibasic)"]},
              {10 Millimolar, Model[Molecule, "Potassium Phosphate (Monobasic)"]},
              {0.4 VolumePercent, Model[Molecule, "Glycerol"]},
              {0.024 Gram/Milliliter, Model[Molecule, "Yeast Extract"]}
            }
          },
          IncompatibleMaterials -> {None},
          Expires -> False,
          DefaultStorageCondition -> {
            Model[StorageCondition, "id:7X104vnR18vX"], (* Model[StorageCondition, "Ambient Storage"] *)
            Model[StorageCondition, "id:7X104vnR18vX"], (* Model[StorageCondition, "Ambient Storage"] *)
            Model[StorageCondition, "id:7X104vnR18vX"] (* Model[StorageCondition, "Ambient Storage"] *)
          },
          Flammable -> False,
          MSDSFile -> NotApplicable,
          BiosafetyLevel -> "BSL-1",
          State -> Liquid,
          UsedAsSolvent -> False,
          UsedAsMedia -> False,
          Living -> True
        ];

        (* Samples *)
        {
          testCell1InLBSample1,
          testCell1InLBSample2,
          testCell2InLBSample1,
          testCell2InLBSample2,
          testCell1InTBSample1,
          lbBrothSample,
          lbBrothDiluentSample,
          destinationSample,
          invalidDestinationSample,
          testCell1inUVStar,
          testCell1InLBSample3,
          testCell1InLBSample4,
          testCell1InLBSample5,
          testCell1InLBSample6,
          testCell1InLBSample7,
          testCell1InLBSample8,
          testCell1InLBSample9,
          testCell1InLBSample10
        } = UploadSample[
          {
            testCell1InLB,
            testCell1InLB,
            testCell2InLB,
            testCell2InLB,
            testCell1InTB,
            Model[Sample, Media, "id:XnlV5jlXbNx8"], (* Model[Sample, Media, "LB Broth, Miller"] *)
            Model[Sample, Media, "id:XnlV5jlXbNx8"], (* Model[Sample, Media, "LB Broth, Miller"] *)
            Model[Sample, Media, "id:9RdZXvdwAEo6"], (* Model[Sample, Media, "LB (Solid Agar)"] *)
            Model[Sample, Media, "id:XnlV5jlXbNx8"], (* Model[Sample, Media, "LB Broth, Miller"] *)
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB,
            testCell1InLB
          },
          {
            {"A1",inputPlate1},
            {"B1",inputPlate1},
            {"A1",inputPlate2},
            {"B1",inputPlate2},
            {"C1",inputPlate1},
            {"D1",inputPlate1},
            {"A1",diluentTube},
            {"A1",destinationPlate1},
            {"A1",invalidDestinationPlate},
            {"A1",uvStarPlate1},
            {"A1",inputPlate3},
            {"A1",inputPlate4},
            {"A1",inputPlate5},
            {"A1",inputPlate6},
            {"A1",inputPlate7},
            {"A1",inputPlate8},
            {"A1",inputPlate9},
            {"A1",inputPlate10}
          },
          Name -> {
            "Test Sample 1 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 1)" <> $SessionUUID,
            "Test Sample 2 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 1)" <> $SessionUUID,
            "Test Sample 3 for ExperimentStreakCellsPreview (Test Cell 2 in LB in DWP 2)" <> $SessionUUID,
            "Test Sample 4 for ExperimentStreakCellsPreview (Test Cell 2 in LB in DWP 2)" <> $SessionUUID,
            "Test Sample 8 for ExperimentStreakCellsPreview (Test Cell 1 in TB in DWP 1)" <> $SessionUUID,
            "Test Sample 5 for ExperimentStreakCellsPreview (LB Broth in DWP 1)" <> $SessionUUID,
            "Test Sample 6 for ExperimentStreakCellsPreview (LB Broth in 50 mL Tube)" <> $SessionUUID,
            "Test Sample 7 for ExperimentStreakCellsPreview (Solid LB Agar in Omnitray)" <> $SessionUUID,
            "Test Sample 9 for ExperimentStreakCellsPreview (LB Agar in Omnitray)" <> $SessionUUID,
            "Test Sample 10 for ExperimentStreakCellsPreview (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID,
            "Test Sample 11 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 3)" <> $SessionUUID,
            "Test Sample 12 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 4)" <> $SessionUUID,
            "Test Sample 13 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 5)" <> $SessionUUID,
            "Test Sample 14 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 6)" <> $SessionUUID,
            "Test Sample 15 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 7)" <> $SessionUUID,
            "Test Sample 16 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 8)" <> $SessionUUID,
            "Test Sample 17 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 9)" <> $SessionUUID,
            "Test Sample 18 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 10)" <> $SessionUUID
          },
          InitialAmount -> {
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1.5 Milliliter,
            1 Milliliter,
            1.23 Milliliter,
            20 Milliliter,
            10 Gram,
            20 Milliliter,
            500 Microliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter,
            1 Milliliter
          },
          State -> {
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Solid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid,
            Liquid
          },
          StorageCondition -> ConstantArray[Model[StorageCondition, "Ambient Storage"],18]
        ];

        (* Other info to upload/correct *)
        Upload[
          {
            <|
              Object -> Object[Sample,"Test Sample 1 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 2 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 3 for ExperimentStreakCellsPreview (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 4 for ExperimentStreakCellsPreview (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 8 for ExperimentStreakCellsPreview (Test Cell 1 in TB in DWP 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "Terrific Broth"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 9 for ExperimentStreakCellsPreview (LB Agar in Omnitray)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "id:XnlV5jlXbNx8"]]
            |>,
            <|
              Object -> Object[Sample,"Test Sample 10 for ExperimentStreakCellsPreview (Test Cell 1 in LB in UV Star 1)" <> $SessionUUID],
              Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
            |>
          }
        ]

      ]
    ]
  ),
  SymbolTearDown :> (
    Module[{objs,existingObjs},
      objs=Quiet[Cases[
        Flatten[{
          (* Bench *)
          Object[Container,Bench,"Bench for ExperimentStreakCellsPreview Testing"<>$SessionUUID],

          (* Containers *)
          Object[Container,Plate,"Test DWP 1 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 2 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 3 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 4 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 5 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 6 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 7 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 8 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 9 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test DWP 10 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 1 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 2 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 3 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL Tube 1 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Object[Container,Plate,"Test UV Star Plate 1 for ExperimentStreakCellsPreview" <> $SessionUUID],

          (* Cells *)
          Model[Cell,Bacteria,"Test Cell 1 for ExperimentStreakCellsPreview" <> $SessionUUID],
          Model[Cell,Bacteria,"Test Cell 1 for ExperimentStreakCellsPreview - no PrefSolidMedia" <> $SessionUUID],

          (* Media *)
          Model[Sample,Media,"Test Solid Media for ExperimentStreakCellsPreview" <> $SessionUUID],

          (* Sample Models *)
          Model[Sample,"Test Sample Model 1 for ExperimentStreakCellsPreview (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 2 for ExperimentStreakCellsPreview (5000 Cell/Milliliter Test Cell 2 in LB Broth)" <> $SessionUUID],
          Model[Sample,"Test Sample Model 3 for ExperimentStreakCellsPreview (5000 Cell/Milliliter Test Cell 1 in TB Broth)" <> $SessionUUID],

          (* Samples *)
          Object[Sample,"Test Sample 1 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 2 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 3 for ExperimentStreakCellsPreview (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 4 for ExperimentStreakCellsPreview (Test Cell 2 in LB in DWP 2)" <> $SessionUUID],
          Object[Sample,"Test Sample 5 for ExperimentStreakCellsPreview (LB Broth in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 6 for ExperimentStreakCellsPreview (LB Broth in 50 mL Tube)" <> $SessionUUID],
          Object[Sample,"Test Sample 7 for ExperimentStreakCellsPreview (Solid LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 8 for ExperimentStreakCellsPreview (Test Cell 1 in TB in DWP 1)" <> $SessionUUID],
          Object[Sample,"Test Sample 9 for ExperimentStreakCellsPreview (LB Agar in Omnitray)" <> $SessionUUID],
          Object[Sample,"Test Sample 10 for ExperimentStreakCellsPreview (Test Cell 1 in LB in UV Star 1)"<>$SessionUUID],
          Object[Sample,"Test Sample 11 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 3)" <> $SessionUUID],
          Object[Sample,"Test Sample 12 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 4)" <> $SessionUUID],
          Object[Sample,"Test Sample 13 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 5)" <> $SessionUUID],
          Object[Sample,"Test Sample 14 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 6)" <> $SessionUUID],
          Object[Sample,"Test Sample 15 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 7)" <> $SessionUUID],
          Object[Sample,"Test Sample 16 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 8)" <> $SessionUUID],
          Object[Sample,"Test Sample 17 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 9)" <> $SessionUUID],
          Object[Sample,"Test Sample 18 for ExperimentStreakCellsPreview (Test Cell 1 in LB in DWP 10)" <> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjs=PickList[objs,DatabaseMemberQ[objs]];
      EraseObject[existingObjs,Force->True,Verbose->False]
    ]
  )
];
(* ::Subsection:: *)
(* StreakCells *)
DefineTests[StreakCells,
  {
    Example[{Basic,"Form a streak cells unit operation:"},
      StreakCells[
        DilutionType -> Linear,
        TotalDilutionVolume -> 10 Milliliter,
        StreakVolume -> 40 Microliter
      ],
      StreakCellsP
    ],
    Example[{Basic,"Specifying a key incorrectly will not form a unit operation:"},
      primitive=StreakCells[
        DilutionType -> Linear,
        TotalDilutionVolume -> 10 Milliliter,
        StreakVolume -> 1000 Microliter
      ];
      MatchQ[primitive,StreakCellsP],
      False
    ],
    Example[{Basic,"A basic protocol is generated when the unit op is inside an RCP:"},
      ExperimentRoboticCellPreparation[
        {
          StreakCells[
            Sample -> Object[Sample,"Test Sample 1 for StreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
            DestinationContainer -> Object[Container,Plate,"Test Omnitray 1 for StreakCells unit tests " <> $SessionUUID]
          ]
        }
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ],
    Example[{Basic,"A  protocol is generated when a unit op that contains dilutions is inside an RCP:"},
      ExperimentRoboticCellPreparation[
        {
          StreakCells[
            Sample -> Object[Sample,"Test Sample 1 for StreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
            DilutionType -> Serial,
            DilutionStrategy -> Series,
            NumberOfDilutions -> 4
          ]
        }
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ],
    Example[{Basic,"A  protocol is generated when a unit op that contains a custom streak pattern is inside an RCP:"},
      ExperimentRoboticCellPreparation[
        {
          StreakCells[
            Sample -> Object[Sample,"Test Sample 1 for StreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
            DilutionType -> Serial,
            DilutionStrategy -> Series,
            NumberOfDilutions -> 4
          ]
        }
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ]
  },
  SymbolSetUp :> (
    Module[
      {namedObjects,existingObjs},

      namedObjects = Quiet[Cases[
        Flatten[{

          (* Bench *)
          Object[Container,Bench,"Test bench for StreakCells tests " <> $SessionUUID],

          (* Container *)
          Object[Container,Plate,"Test DWP 1 for StreakCells unit tests " <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 1 for StreakCells unit tests " <> $SessionUUID],

          (* Cells *)
          Model[Cell, Bacteria, "Test Cell 1 for StreakCells unit tests " <> $SessionUUID],

          (* Sample Models *)
          Model[Sample,"Test Sample Model 1 for StreakCells (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID],

          (* Samples *)
          Object[Sample,"Test Destination Sample for StreakCells unit tests " <> $SessionUUID],
          Object[Sample,"Test Sample 1 for StreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]


        }],
        ObjectP[]
      ]];

      existingObjs=PickList[namedObjects,DatabaseMemberQ[namedObjects]];
      EraseObject[existingObjs,Force->True,Verbose->False];
    ];
    Block[{$DeveloperUpload = True},
      Module[
        {
          testBench
        },

        (* Create a test bench *)
        testBench = Upload[
          <|
            Type->Object[Container,Bench],
            Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
            Name->"Test bench for StreakCells tests " <> $SessionUUID,
            DeveloperObject->True,
            StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
            Site -> Link[$Site]
          |>
        ];


        (* Containers *)
        UploadSample[
          {
            Model[Container, Plate, "id:4pO6dMmErzez"],(* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"]*)
            Model[Container, Plate, "id:O81aEBZjRXvx"] (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
          },
          {
            {"Work Surface",testBench},
            {"Work Surface",testBench}
          },
          Name -> {
            "Test DWP 1 for StreakCells unit tests " <> $SessionUUID,
            "Test Omnitray 1 for StreakCells unit tests " <> $SessionUUID
          }
        ];

        (* Populate the destination container with solid media *)
        UploadSample[
          Model[Sample, Media, "id:9RdZXvdwAEo6"], (* Model[Sample, Media, "LB (Solid Agar)"] *)
          {"A1",Object[Container,Plate,"Test Omnitray 1 for StreakCells unit tests " <> $SessionUUID]},
          Name -> "Test Destination Sample for StreakCells unit tests " <> $SessionUUID,
          InitialAmount -> 10 Gram
        ];

        (* Cells *)
        UploadBacterialCell[
          "Test Cell 1 for StreakCells unit tests " <> $SessionUUID,
          Morphology -> Cocci,
          BiosafetyLevel -> "BSL-1",
          Flammable -> False,
          MSDSFile -> NotApplicable,
          IncompatibleMaterials -> {None},
          CellType -> Bacterial,
          CultureAdhesion -> Suspension,
          PreferredSolidMedia -> Model[Sample, Media, "id:9RdZXvdwAEo6"] (* Model[Sample, Media, "LB (Solid Agar)"] *)
        ];

        (* Sample Model *)
        UploadSampleModel[
          "Test Sample Model 1 for StreakCells (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID,
          Composition -> {
            {
              {5000 Cell/Milliliter, Model[Cell, Bacteria, "Test Cell 1 for StreakCells unit tests " <> $SessionUUID]},
              {Quantity[95, IndependentUnit["VolumePercent"]], Model[Molecule, "Water"]},
              {Quantity[171.116, "Millimolar"], Model[Molecule, "Sodium Chloride"]},
              {Quantity[0.005, ("Grams")/("Milliliters")], Model[Molecule, "Yeast Extract"]}
            }
          },
          IncompatibleMaterials -> {None},
          Expires -> True,
          ShelfLife -> 2 Week,
          UnsealedShelfLife -> 1 Hour,
          DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX"], (* Model[StorageCondition, "Ambient Storage"] *)
          Flammable -> False,
          MSDSFile -> NotApplicable,
          BiosafetyLevel -> "BSL-1",
          State -> Liquid,
          UsedAsSolvent -> False,
          UsedAsMedia -> False,
          Living -> True
        ];

        (* Samples *)
        UploadSample[
          Model[Sample,"Test Sample Model 1 for StreakCells (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID],
          {"A1", Object[Container,Plate,"Test DWP 1 for StreakCells unit tests " <> $SessionUUID]},
          Name -> "Test Sample 1 for StreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID,
          InitialAmount -> 1 Milliliter,
          State -> Liquid
        ];

        (* Upload the media field *)
        Upload[<|
          Object -> Object[Sample,"Test Sample 1 for StreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID],
          Media -> Link[Model[Sample, Media, "LB (Liquid)"]]
        |>];
      ];
    ]
  ),
  SymbolTearDown :> (
    Module[
      {namedObjects,allObjects,existingObjs},

      namedObjects = Quiet[Cases[
        Flatten[{

          (* Bench *)
          Object[Container,Bench,"Test bench for StreakCells tests " <> $SessionUUID],

          (* Container *)
          Object[Container,Plate,"Test DWP 1 for StreakCells unit tests " <> $SessionUUID],
          Object[Container,Plate,"Test Omnitray 1 for StreakCells unit tests " <> $SessionUUID],

          (* Cells *)
          Model[Cell, Bacteria, "Test Cell 1 for StreakCells unit tests " <> $SessionUUID],

          (* Sample Models *)
          Model[Sample,"Test Sample Model 1 for StreakCells (5000 Cell/Milliliter Test Cell 1 in LB Broth)" <> $SessionUUID],

          (* Samples *)
          Object[Sample,"Test Destination Sample for StreakCells unit tests " <> $SessionUUID],
          Object[Sample,"Test Sample 1 for StreakCells (Test Cell 1 in LB in DWP 1)" <> $SessionUUID]


        }],
        ObjectP[]
      ]];

      allObjects = Quiet[Cases[
        Flatten[{
          $CreatedObjects,
          namedObjects
        }],
        ObjectP[]
      ]];

      existingObjs=PickList[allObjects,DatabaseMemberQ[allObjects]];
      EraseObject[existingObjs,Force->True,Verbose->False];

      Unset[$CreatedObjects];
    ];
  )
];