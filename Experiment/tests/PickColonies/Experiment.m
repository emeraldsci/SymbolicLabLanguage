(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)
(* ::Subsection:: *)
(* ExperimentPickColonies *)
DefineTests[ExperimentPickColonies,
  {
    Example[{Basic,"Generate a RoboticCellPreparation protocol from a single plate"},
      ExperimentPickColonies[Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID]],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ],
    Example[{Basic,"Generate a RoboticCellPreparation protocol from 2 plates:"},
      ExperimentPickColonies[
        {
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
        }
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ],
    Example[{Basic,"Specify the colonies to Populations from the plate by a single Feature:"},
      ExperimentPickColonies[
        Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        Populations -> Diameter[]
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ],
    Example[{Basic,"Generate a robotic cell preparation protocol using a container as input:"},
      ExperimentPickColonies[Object[Container,Plate, "ExperimentPickColonies" <> " test omniTray 1 " <> $SessionUUID]],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ],

    (* --- Options --- *)
    Example[{Options,Instrument,"The Instrument option defaults to Model[Instrument, ColonyHandler, \"id:mnk9jORxz0El\"]:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"]]
    ],
       
    Example[{Options,Instrument,"Specify any Object[Instrument,ColonyHandler] or Model[Instrument,ColonyHandler]:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Instrument->Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"],
          Output->Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"]]
    ],

    Example[{Options,Populations,"Use the Populations option to specify a single population primitive that describes the colonies to pick:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> {Diameter[]},
          Output->Options
        ],
        Populations
      ],
      {{DiameterPrimitiveP}}
    ],

    Example[{Options,Populations,"Use the Populations option to specify multiple population primitives per sample:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations-> {{
            Diameter[],
            Fluorescence[NumberOfColonies -> 20]
          }},
          Output->Options
        ],
        Populations
      ],
      {{DiameterPrimitiveP,FluorescencePrimitiveP}}
    ],

    Example[{Options,Populations,"Use the Populations option to specify a MultiFeatured primitive:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations-> {MultiFeatured[
            Features -> {Fluorescence, Diameter},
            Select -> {Positive, Max},
            NumberOfColonies -> {10, 15}
          ]},
          Output->Options
        ],
        Populations
      ],
      {{MultiFeaturedPrimitiveP}}
    ],

    Example[{Options,Populations,"Use the Populations option to select a division of colonies when they are divided into more than 2 groups:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations-> {MultiFeatured[
            Features -> {Fluorescence, Diameter},
            Select -> {Max, Max},
            NumberOfDivisions -> {2, 5}
          ]},
          Output->Options
        ],
        Populations
      ],
      {{MultiFeaturedPrimitiveP}}
    ],

    Example[{Options,Populations,"If the contents of the input sample are unknown, set Populations to All:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations-> {AllColonies[]},
          Output->Options
        ],
        Populations
      ],
      {{AllColoniesPrimitiveP}}
    ],

    Example[{Options,Populations, "Use a Population Primitive to pick all colonies that have a Diameter greater than 2 Millimeter:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> {Diameter[ThresholdDiameter->2 Millimeter]},
          Output -> Options
        ],
        Populations
      ],
      {{DiameterPrimitiveP}}
    ],

    Example[{Options,Populations, "Use a Population Primitive to pick all colonies fluorescing from a particular dye:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> {Fluorescence[Dye->TxRed]},
          Output -> Options
        ],
        Populations
      ],
      {{FluorescencePrimitiveP}}
    ],
       
    Example[{Options,Populations,"If the pick coordinates are already known, set Populations to CustomCoordinates and specify PickCoordinates:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations->CustomCoordinates,
          PickCoordinates->ConstantArray[{0 Millimeter,0 Millimeter},30],
          Output->Options
        ],
        Populations
      ],
      CustomCoordinates
    ],
    
    Example[{Options,Populations,"If Populations->Automatic, will resolve to a Fluorescence Primitive based on the fields in the Model[Cell]'s of the input sample composition:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations->Automatic,
          Output->Options
        ],
        Populations
      ],
      FluorescencePrimitiveP
    ],
       
    Example[{Options,Populations,"Select a single population from multiple samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations-> Diameter[
            Select -> Min
          ],
          Output->Options
        ],
        Populations
      ],
      DiameterPrimitiveP
    ],

    Example[{Options,Populations,"Select multiple population primitives per sample:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations->{
            {
              Diameter[Select->Min]
            },
            {
              Diameter[],
              Fluorescence
            }
          },
          Output->Options
        ],
        Populations
      ],
      {{DiameterPrimitiveP},{DiameterPrimitiveP,FluorescencePrimitiveP}}
    ],

    Example[{Options,Populations,"Select a single type of colony from the first plate and Select known colony coordinates on a second plate:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations->{
            Diameter[Select->Min],
            CustomCoordinates
          },
          PickCoordinates->{
            Null,
            ConstantArray[{0 Millimeter,0 Millimeter},10]
          },
          Output->Options
        ],
        Populations
      ],
      {{DiameterPrimitiveP}, {CustomCoordinates}}
    ],
    
    Example[{Options,ColonyPickingTool,"The ColonyPickingTool will automatically resolve to a PreferredColonyHandlerHeadCassette of a Model[Cell] in the composition of the input sample that also fits the DestinationMediaContainer:"},
      preferredHeads =
        (* Get the PreferredColonyHandlerHeadCassettes of the input sample *)
        Cases[Download[
          Flatten@Quiet[
            Download[
              Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
              Composition[[All, 2]][PreferredColonyHandlerHeadCassettes]
            ]
          ],
          Object
        ],
          ObjectP[]
        ];
      selectedHead = Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        ColonyPickingTool
      ];
      MemberQ[preferredHeads,selectedHead],
      True,
      Variables:>{preferredHeads,selectedHead}
    ],

    Example[{Options,ColonyPickingTool,"The ColonyPickingTool can be specified by Model[Part,ColonyHandlerHeadCassette] or Object[Part,ColonyHandlerHeadCassette]:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          ColonyPickingTool->{Object[Part, ColonyHandlerHeadCassette, "id:bq9LA09Wkwav"],Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli"]},
          Output->Options
        ],
        ColonyPickingTool
      ],
      {ObjectP[Object[Part, ColonyHandlerHeadCassette, "id:bq9LA09Wkwav"]],ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli"]]}
    ],

    Example[{Options,HeadDiameter,"Only ColonyPickingTools with the specified HeadDiameter will be used:"},
      colonyPickingTool=Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          HeadDiameter->1 Millimeter,
          Output->Options
        ],
        ColonyPickingTool
      ];
      Download[colonyPickingTool,HeadDiameter],
      RangeP[1 Millimeter],
      Variables:>{colonyPickingTool},
      Messages :> {Warning::NotPreferredColonyHandlerHead}
    ],

    Example[{Options,HeadLength,"Only ColonyPickingTools with the specified HeadLength will be used:"},
      colonyPickingTool=Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          HeadLength->9.4 Millimeter,
          Output->Options
        ],
        ColonyPickingTool
      ];
      Download[colonyPickingTool,HeadLength],
      9.4 Millimeter,
      Variables:>{colonyPickingTool}
    ],

    Example[{Options,NumberOfHeads,"Only ColonyPickingTools with the specified NumberOfHeads will be used:"},
      colonyPickingTool=Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          NumberOfHeads->96,
          Output->Options
        ],
        ColonyPickingTool
      ];
      Download[colonyPickingTool,NumberOfHeads],
      96,
      Variables:>{colonyPickingTool}
    ],
    Example[{Options,ColonyHandlerHeadCassetteApplication,"Only ColonyPickingTools with the specified ColonyHandlerHeadCassetteApplication will be used:"},
      colonyPickingTool=Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          ColonyHandlerHeadCassetteApplication->Pick,
          Output->Options
        ],
        ColonyPickingTool
      ];
      Download[colonyPickingTool,Application],
      Pick,
      Variables:>{colonyPickingTool}
    ],

    Example[{Options,ColonyPickingDepth,"The ColonyPickingDepth is automatically set to 2 Millimeter:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        ColonyPickingDepth
      ],
      2 Millimeter
    ],

    Example[{Options,ColonyPickingDepth,"The ColonyPickingDepth can be specified for each sample:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          ColonyPickingDepth -> {2 Millimeter, 1.5 Millimeter},
          Output->Options
        ],
        ColonyPickingDepth
      ],
      {{RangeP[2 Millimeter]}, {RangeP[1.5 Millimeter]}}
    ],

    Example[{Options,ImagingChannels,"ImagingChannels automatically gets resolved to the imaging channels specified in Populations + Brightfield:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations-> {MultiFeatured[
            Features -> {Fluorescence, Fluorescence},
            Select -> {Positive, Positive},
            ExcitationWavelength -> {457 Nanometer, 531 Nanometer},
            EmissionWavelength -> {536 Nanometer, 593 Nanometer}
          ]},
          Output->Options
        ],
        ImagingChannels
      ],
      {BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer}}
    ],
       
    Example[{Options,ImagingChannels,"Specify the ImagingChannels that are specified as Features in Populations:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations-> {MultiFeatured[
            Features -> {Fluorescence, Fluorescence},
            Select -> {Positive, Positive},
            ExcitationWavelength -> {457 Nanometer, 531 Nanometer},
            EmissionWavelength -> {536 Nanometer, 593 Nanometer},
            NumberOfColonies -> {5, 5}
          ]},
          ImagingChannels->{BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer}},
          Output->Options
        ],
        ImagingChannels
      ],
      {BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer}}
    ],

    Example[{Options,ImagingChannels,"Specify additional ImagingChannels that are not specified as Features in Populations:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations-> {MultiFeatured[
            Features -> {Fluorescence, Fluorescence},
            Select -> {Positive, Positive},
            ExcitationWavelength -> {457 Nanometer, 531 Nanometer},
            EmissionWavelength -> {536 Nanometer, 593 Nanometer},
            NumberOfColonies -> {5, 5}
          ]},
          ImagingChannels->{BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer},{531 Nanometer, 624 Nanometer}},
          Output->Options
        ],
        ImagingChannels
      ],
      {BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer},{531 Nanometer, 624 Nanometer}}
    ],

    Example[{Options,ExposureTimes,"ExposureTimes automatically gets set to AutoExpose as they get optimized at RunTime:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations-> {MultiFeatured[
            Features -> {Fluorescence, Fluorescence},
            Select -> {Positive, Positive},
            ExcitationWavelength -> {457 Nanometer, 531 Nanometer},
            EmissionWavelength -> {536 Nanometer, 593 Nanometer},
            NumberOfColonies -> {5, 5}
          ]},
          Output->Options
        ],
        ExposureTimes
      ],
      {AutoExpose,AutoExpose,AutoExpose}
    ],

    Example[{Options,ExposureTimes,"Control the ExposureTimes of Imaging Channels specified in Populations:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations->{MultiFeatured[
            Features->{Fluorescence,Fluorescence},
            Select->{Positive,Positive},
            ExcitationWavelength -> {457 Nanometer, 531 Nanometer},
            EmissionWavelength -> {536 Nanometer, 593 Nanometer},
            NumberOfColonies -> {5, 5}
          ]},
          ImagingChannels->{BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer}},
          ExposureTimes->{5 Millisecond,10 Millisecond,30 Millisecond},
          Output->Options
        ],
        ExposureTimes
      ],
      {5 Millisecond,10 Millisecond,30 Millisecond}
    ],

    Example[{Options,DestinationMediaType,"The DestinationMediaType will automatically resolve to the State of DestinationMedia if DestinationMedia is specified:"},
      {
        Lookup[
          ExperimentPickColonies[
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            DestinationMedia->Model[Sample,Media, "ExperimentPickColonies" <> " test solid LB agar media model " <> $SessionUUID],
            Output->Options
          ],
          DestinationMediaType
        ],
        Download[Model[Sample,Media, "ExperimentPickColonies" <> " test solid LB agar media model " <> $SessionUUID],State]
      },
      {SolidMedia,Solid}
    ],

    Example[{Options,DestinationMediaType,"The DestinationMediaType will automatically resolve based on the PreferredSolidMedia and PreferredLiqudMedia fields of a Model[Cell] in the composition in the input sample if DestinationMedia not is specified:"},
      {
        Lookup[
          ExperimentPickColonies[
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Output->Options
          ],
          DestinationMediaType
        ],
        Quiet[
          Cases[
            Flatten@Download[Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],Composition[[All,2]][{PreferredSolidMedia,PreferredLiquidMedia}][Object]],
            ObjectP[]
          ]
        ]
      },
      {SolidMedia, {ObjectP[Model[Sample,Media, "ExperimentPickColonies" <> " test solid LB agar media model " <> $SessionUUID]]}}
    ],

    Example[{Options,DestinationMedia,"DestinationMedia will automatically resolve to a PreferredLiquidMedia or PreferredSolidMedia of a Model[Cell] in the composition in the input sample:"},
      prefLiquidMedia = Cases[Download[
        Flatten@Quiet[
          Download[
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Composition[[All, 2]][PreferredLiquidMedia]
          ]
        ],
        Object
      ],
        ObjectP[]
      ];
      prefSolidMedia = Cases[Download[
        Flatten@Quiet[
          Download[
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Composition[[All, 2]][PreferredSolidMedia]
          ]
        ],
        Object
      ],
        ObjectP[]
      ];
      resolvedDestMedia = Download[Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        DestinationMedia
      ],Object];
      MemberQ[Flatten[{prefLiquidMedia,prefSolidMedia}],resolvedDestMedia],
      True,
      Variables :> {prefLiquidMedia,prefSolidMedia,resolvedDestMedia}
    ],

    Example[{Options,DestinationMedia,"DestinationMedia can be specified as an Object[Sample]:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationMedia -> Object[Sample, "ExperimentPickColonies" <> " test LB Broth in 500 mL flask " <> $SessionUUID],
          Output->Options
        ],
        DestinationMedia
      ],
      ObjectP[Object[Sample, "ExperimentPickColonies" <> " test LB Broth in 500 mL flask " <> $SessionUUID]]
    ],

    Example[{Options,DestinationMedia,"DestinationMedia can be specified as an Model[Sample]:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationMedia -> Model[Sample,Media, "ExperimentPickColonies" <> " test solid LB agar media model " <> $SessionUUID],
          Output->Options
        ],
        DestinationMedia
      ],
      ObjectP[Model[Sample,Media, "ExperimentPickColonies" <> " test solid LB agar media model " <> $SessionUUID]]
    ],

    Example[{Options,DestinationMediaContainer,"Specify a Model[Container] for a population to signify as many picked colonies of that population will be deposited into as many plates of that model that can fit on the deck:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> {Diameter[]},
          DestinationMediaContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
          Output->Options
        ],
        DestinationMediaContainer
      ],
      ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]
    ],

    Example[{Options,DestinationMediaContainer,"Specify an Object[Container] for a population to signify as many picked colonies of that population that can fit will be deposited into that specific plate only:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> {Diameter[]},
          DestinationMediaContainer -> Object[Container,Plate, "ExperimentPickColonies" <> " test dwp 7 " <> $SessionUUID],
          Output->Options
        ],
        DestinationMediaContainer
      ],
      {ObjectP[Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 7 " <> $SessionUUID]]}
    ],

    Example[{Options,DestinationMediaContainer,"Specify multiple Object[Container]s for a population to signify as many picked colonies of that population that can fit will be deposited into those specific plates only:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> {{Diameter[]}},
          DestinationMediaContainer -> {{{
            Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 5 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 6 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 7 " <> $SessionUUID]
          }}},
          Output->Options
        ],
        DestinationMediaContainer
      ],
      {{{
        ObjectP[Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 5 " <> $SessionUUID]],
        ObjectP[Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 6 " <> $SessionUUID]],
        ObjectP[Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 7 " <> $SessionUUID]]
      }}}
    ],

    Example[{Options,DestinationMediaContainer,"Specify destination media containers for each population:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> {{
            Diameter[],
            Fluorescence[NumberOfColonies -> 20],
            Circularity[]
          }},
          DestinationMediaContainer -> {{
            Model[Container, Plate, "id:L8kPEjkmLbvW"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
            Model[Container, Plate, "id:L8kPEjkmLbvW"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
            {
              Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 5 " <> $SessionUUID],
              Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 6 " <> $SessionUUID],
              Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 7 " <> $SessionUUID]
            }
          }},
          Output->Options
        ],
        DestinationMediaContainer
      ],
      {{
        ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]], (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
        ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]], (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
        {
          ObjectP[Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 5 " <> $SessionUUID]],
          ObjectP[Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 6 " <> $SessionUUID]],
          ObjectP[Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 7 " <> $SessionUUID]]
        }
      }}
    ],

    Example[{Options,DestinationMediaContainer,"Specify destination media containers for each population when there are multiple input samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 3 in omniTray " <> $SessionUUID]
          },
          Populations -> {
            {Fluorescence[NumberOfColonies -> 20],Diameter[]},
            {Fluorescence[NumberOfColonies -> 20]},
            {MultiFeatured[Features->{Regularity,Circularity}]}
          },
          DestinationMediaContainer -> {
            {Model[Container, Plate, "id:L8kPEjkmLbvW"],Model[Container, Plate, "id:L8kPEjkmLbvW"]}, (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
            Model[Container, Plate, "id:L8kPEjkmLbvW"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
            {
              Object[Container,Plate, "ExperimentPickColonies" <> " test dwp 5 " <> $SessionUUID],
              Object[Container,Plate, "ExperimentPickColonies" <> " test dwp 6 " <> $SessionUUID]
            }
          },
          Output->Options
        ],
        DestinationMediaContainer
      ],
      {
        {ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]],ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]}, (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
        {ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]}, (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
        {{
          ObjectP[Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 5 " <> $SessionUUID]],
          ObjectP[Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 6 " <> $SessionUUID]]
        }}
      }
    ],

    Example[{Options,DestinationFillDirection,"If DestinationFillDirection->Automatic, it will resolve to filling the destination container by Rows:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        DestinationFillDirection
      ],
      Row
    ],

    Example[{Options,DestinationFillDirection,"Set the DestinationFillDirection to fill the destination in row order:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationFillDirection->Row,
          Output->Options
        ],
        DestinationFillDirection
      ],
      Row
    ],

    Example[{Options,DestinationFillDirection,"Set the DestinationFillDirection to fill the destination in column order:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationFillDirection->Column,
          Output->Options
        ],
        DestinationFillDirection
      ],
      Column
    ],
    
    Example[{Options,DestinationFillDirection,"Set DestinationFillDirection to CustomCoordinates to specify specific locations of where to deposit colonies:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationFillDirection->CustomCoordinates,
          DestinationCoordinates->ConstantArray[{0 Millimeter, 1 Millimeter},10],
          Output->Options
        ],
        DestinationFillDirection
      ],
      CustomCoordinates
    ],

    Example[{Options,MaxDestinationNumberOfColumns,"MaxDestinationNumberOfColumns is left as Automatic because the optimal number of columns is determined once the number of colonies to pick is known:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        MaxDestinationNumberOfColumns
      ],
      Automatic
    ],

    Example[{Options,MaxDestinationNumberOfColumns,"Use MaxDestinationNumberOfColumns to limit the number of columns of deposited colonies to 8:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          MaxDestinationNumberOfColumns->8,
          Output->Options
        ],
        MaxDestinationNumberOfColumns
      ],
      8
    ],

    Example[{Options,MaxDestinationNumberOfColumns,"Use MaxDestinationNumberOfColumns to limit the number of columns of deposited colonies for each population:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations->{
            {Diameter[]},
            {Diameter[],Fluorescence[NumberOfColonies -> 10]}
          },
          MaxDestinationNumberOfColumns->{
            {5},
            {8,9}
          },
          Output->Options
        ],
        MaxDestinationNumberOfColumns
      ],
      {{5},{8,9}}
    ],

    Example[{Options,MaxDestinationNumberOfRows,"MaxDestinationNumberOfRows is left as Automatic because the optimal number of rows is determined once the number of colonies to pick is known:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        MaxDestinationNumberOfRows
      ],
      Automatic
    ],

    Example[{Options,MaxDestinationNumberOfRows,"Use MaxDestinationNumberOfRows to limit the number of rows of deposited colonies to 8:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          MaxDestinationNumberOfRows->8,
          Output->Options
        ],
        MaxDestinationNumberOfRows
      ],
      8
    ],

    Example[{Options,MaxDestinationNumberOfRows,"Use MaxDestinationNumberOfRows to limit the number of rows of deposited colonies for each population:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations->{
            {Diameter[]},
            {Diameter[],Fluorescence[NumberOfColonies -> 10]}
          },
          MaxDestinationNumberOfRows->{
            {5},
            {8,9}
          },
          Output->Options
        ],
        MaxDestinationNumberOfRows
      ],
      {{5},{8,9}}
    ],

    Example[{Options,DestinationCoordinates,"DestinationCoordinates automatically resolves to Null if it is not specified:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        DestinationCoordinates
      ],
      Null
    ],

    Example[{Options,DestinationCoordinates,"Use DestinationCoordinates to specify specific coordinates to deposit colonies:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationCoordinates->ConstantArray[{0 Millimeter, 1 Millimeter},10],
          Output->Options
        ],
        DestinationCoordinates
      ],
      ConstantArray[{0 Millimeter, 1 Millimeter},10]
    ],

    Example[{Options,DestinationCoordinates,"Specify DestinationCoordinates for each population:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations->{
            {Diameter[]},
            {Diameter[],Fluorescence[NumberOfColonies -> 20]}
          },
          DestinationCoordinates->{
            {ConstantArray[{0 Millimeter, 0 Millimeter}, 10]},
            {ConstantArray[{0 Millimeter, 0 Millimeter},5],ConstantArray[{0 Millimeter, 0 Millimeter},20]}
          },
          Output->Options
        ],
        DestinationCoordinates
      ],
      {
        {ConstantArray[{0 Millimeter, 0 Millimeter}, 10]},
        {ConstantArray[{0 Millimeter, 0 Millimeter},5],ConstantArray[{0 Millimeter, 0 Millimeter},20]}
      }
    ],
    
    Example[{Options,MediaVolume,"MediaVolume will resolve to the recommended fill volume or 40% of the MaxVolume of the DestinationMediaContainer (capped at $MaxRoboticSingleTransferVolume):"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationMediaType->LiquidMedia,
          DestinationMediaContainer-> Object[Container,Plate, "ExperimentPickColonies" <> " test dwp 3 " <> $SessionUUID],
          Output->Options
        ],
        MediaVolume
      ],
      RangeP[$MaxRoboticSingleTransferVolume]
    ],
       

    Example[{Options,MediaVolume,"Use MediaVolume to specify the amount of liquid media in which to deposit picked colonies:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          MediaVolume->1 Milliliter,
          Output->Options
        ],
        MediaVolume
      ],
      RangeP[1 Milliliter]
    ],

    Example[{Options,MediaVolume,"Specify MediaVolume for each population:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations->{
            {Diameter[],Fluorescence[NumberOfColonies -> 20]},
            {Diameter[]}
          },
          MediaVolume->{
            {0.7 Milliliter,0.5 Milliliter},
            {1 Milliliter}
          },
          Output->Options
        ],
        MediaVolume
      ],
      {
        {0.7 Milliliter,0.5 Milliliter},
        {RangeP[1 Milliliter]}
      }
    ],

    Example[{Options,DestinationMix,"If DestinationMediaType resolves to SolidMedia, DestinationMix gets set to False:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationMediaType->SolidMedia,
          Output->Options
        ],
        DestinationMix
      ],
      False
    ],

    Example[{Options,DestinationMix,"If DestinationMediaType resolves to LiquidMedia, DestinationMix gets set to True:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationMediaType->LiquidMedia,
          Output->Options
        ],
        DestinationMix
      ],
      True
    ],

    Example[{Options,DestinationMix,"Set DestinationMix for each population:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations->{
            {Diameter[],Fluorescence[NumberOfColonies -> 20]},
            {Diameter[]}
          },
          DestinationMediaType->{
            {LiquidMedia,LiquidMedia},
            LiquidMedia
          },
          DestinationMix->{
            {True,False},
            {True}
          },
          Output->Options
        ],
        DestinationMix
      ],
      {
        {True,False},
        {True}
      }
    ],

    Example[{Options,DestinationNumberOfMixes,"DestinationNumberOfMixes will resolve to 5 if DestinationMix is True and resolve to Null if DestinationMix is False:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          DestinationMediaType->{
            LiquidMedia,
            LiquidMedia
          },
          DestinationMix->{
            False,
            True
          },
          Output->Options
        ],
        DestinationNumberOfMixes
      ],
      {{Null}, {5}}
    ],

    Example[{Options,DestinationNumberOfMixes,"DestinationNumberOfMixes can be set if DestinationMediaType is LiquidMedia:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationMediaType->LiquidMedia,
          DestinationNumberOfMixes->10,
          Output->Options
        ],
        DestinationNumberOfMixes
      ],
      10
    ],

    Example[{Options,DestinationNumberOfMixes,"Set DestinationNumberOfMixes for each population:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations->{
            {Diameter[],Fluorescence[NumberOfColonies -> 20]},
            {Diameter[]}
          },
          DestinationMediaType->{
            {LiquidMedia,LiquidMedia},
            {LiquidMedia}
          },
          DestinationNumberOfMixes->{
            7,
            {10}
          },
          Output->Options
        ],
        DestinationNumberOfMixes
      ],
      {
        {7,7},
        {10}
      }
    ],

    Example[{Options,PrimaryWash,"PrimaryWash will default to True if not specified:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        PrimaryWash
      ],
      True
    ],

    Example[{Options,PrimaryWash,"Setting PrimaryWash to False will turn off the other PrimaryWash options:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          PrimaryWash->False,
          Output->Options
        ],
        {PrimaryWash,PrimaryWashSolution,NumberOfPrimaryWashes,PrimaryDryTime}
      ],
      {False,Null,Null,Null}
    ],

    Example[{Options,PrimaryWash,"Have different PrimaryWash specifications for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          PrimaryWash->{True,False},
          Output->Options
        ],
        PrimaryWash
      ],
      {True,False}
    ],
    
    Example[{Options,PrimaryWashSolution,"The PrimaryWashSolution will automatically be set to Model[Sample,StockSolution,\"70% Ethanol\"]:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        PrimaryWashSolution
      ],
      ObjectP[Model[Sample,StockSolution,"70% Ethanol"]]
    ],

    Example[{Options,PrimaryWashSolution,"The PrimaryWashSolution will automatically be set to Null if PrimaryWash is False:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          PrimaryWash->False,
          Output->Options
        ],
        PrimaryWashSolution
      ],
      Null
    ],

    Example[{Options,PrimaryWashSolution,"Have different PrimaryWashSolutions for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          PrimaryWashSolution->{Model[Sample,StockSolution,"70% Ethanol"],Model[Sample, "Milli-Q water"]},
          Output->Options
        ],
        PrimaryWashSolution
      ],
      {ObjectP[Model[Sample,StockSolution,"70% Ethanol"]],ObjectP[Model[Sample, "Milli-Q water"]]}
    ],
    
    Example[{Options,NumberOfPrimaryWashes,"NumberOfPrimaryWashes will automatically be set to 5:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        NumberOfPrimaryWashes
      ],
      5
    ],
    
    Example[{Options,NumberOfPrimaryWashes,"The NumberOfPrimaryWashes will automatically be set to Null if PrimaryWash is False:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          PrimaryWash->False,
          Output->Options
        ],
        NumberOfPrimaryWashes
      ],
      Null
    ],
       
    Example[{Options,NumberOfPrimaryWashes,"Have different NumberOfPrimaryWashes for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          NumberOfPrimaryWashes->{8,10},
          Output->Options
        ],
        NumberOfPrimaryWashes
      ],
      {8,10}
    ],

    Example[{Options,PrimaryDryTime,"PrimaryDryTime will automatically be set to 10 Seconds:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        PrimaryDryTime
      ],
      10 Second
    ],

    Example[{Options,PrimaryDryTime,"The PrimaryDryTime will automatically be set to Null if PrimaryWash is False:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          PrimaryWash->False,
          Output->Options
        ],
        PrimaryDryTime
      ],
      Null
    ],

    Example[{Options,PrimaryDryTime,"Have different PrimaryDryTimes for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          PrimaryDryTime->{8 Second,30 Second},
          Output->Options
        ],
        PrimaryDryTime
      ],
      {8 Second,30 Second}
    ],

    Example[{Options,SecondaryWash,"SecondaryWash will default to True if not specified:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        SecondaryWash
      ],
      True
    ],

    Example[{Options,SecondaryWash,"SecondaryWash will automatically be set to False, if PrimaryWash is False:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          PrimaryWash->False,
          Output->Options
        ],
        SecondaryWash
      ],
      False
    ],

    Example[{Options,SecondaryWash,"Setting SecondaryWash to False will turn off the other SecondaryWash options:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          SecondaryWash->False,
          Output->Options
        ],
        {SecondaryWash,SecondaryWashSolution,NumberOfSecondaryWashes,SecondaryDryTime}
      ],
      {False,Null,Null,Null}
    ],

    Example[{Options,SecondaryWash,"Have different SecondaryWash specifications for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          SecondaryWash->{True,False},
          Output->Options
        ],
        SecondaryWash
      ],
      {True,False}
    ],

    Example[{Options,SecondaryWashSolution,"The SecondaryWashSolution will automatically be set to Model[Sample, \"Milli-Q water\"]:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        SecondaryWashSolution
      ],
      ObjectP[Model[Sample, "Milli-Q water"]]
    ],

    Example[{Options,SecondaryWashSolution,"The SecondaryWashSolution will automatically be set to Null if SecondaryWash is False:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          SecondaryWash->False,
          Output->Options
        ],
        SecondaryWashSolution
      ],
      Null
    ],

    Example[{Options,SecondaryWashSolution,"Have different SecondaryWashSolutions for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          SecondaryWashSolution->{Model[Sample,StockSolution,"70% Ethanol"],Model[Sample, "Milli-Q water"]},
          Output->Options
        ],
        SecondaryWashSolution
      ],
      {ObjectP[Model[Sample,StockSolution,"70% Ethanol"]],ObjectP[Model[Sample, "Milli-Q water"]]}
    ],

    Example[{Options,NumberOfSecondaryWashes,"NumberOfSecondaryWashes will automatically be set to 5:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        NumberOfSecondaryWashes
      ],
      5
    ],

    Example[{Options,NumberOfSecondaryWashes,"The NumberOfSecondaryWashes will automatically be set to Null if SecondaryWash is False:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          SecondaryWash->False,
          Output->Options
        ],
        NumberOfSecondaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfSecondaryWashes,"Have different NumberOfSecondaryWashes for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          NumberOfSecondaryWashes->{8,10},
          Output->Options
        ],
        NumberOfSecondaryWashes
      ],
      {8,10}
    ],

    Example[{Options,SecondaryDryTime,"SecondaryDryTime will automatically be set to 10 Seconds:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        SecondaryDryTime
      ],
      10 Second
    ],

    Example[{Options,SecondaryDryTime,"The SecondaryDryTime will automatically be set to Null if SecondaryWash is False:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          SecondaryWash->False,
          Output->Options
        ],
        SecondaryDryTime
      ],
      Null
    ],

    Example[{Options,SecondaryDryTime,"Have different SecondaryDryTimes for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          SecondaryDryTime->{8 Second,30 Second},
          Output->Options
        ],
        SecondaryDryTime
      ],
      {8 Second,30 Second}
    ],

    Example[{Options,TertiaryWash,"TertiaryWash will default to True if not specified:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        TertiaryWash
      ],
      True
    ],

    Example[{Options,TertiaryWash,"TertiaryWash will automatically be set to False, if SecondaryWash is False:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          SecondaryWash->False,
          Output->Options
        ],
        TertiaryWash
      ],
      False
    ],

    Example[{Options,TertiaryWash,"Setting TertiaryWash to False will turn off the other TertiaryWash options:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          TertiaryWash->False,
          Output->Options
        ],
        {TertiaryWash,TertiaryWashSolution,NumberOfTertiaryWashes,TertiaryDryTime}
      ],
      {False,Null,Null,Null}
    ],

    Example[{Options,TertiaryWash,"Have different TertiaryWash specifications for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          TertiaryWash->{True,False},
          Output->Options
        ],
        TertiaryWash
      ],
      {True,False}
    ],

    Example[{Options,TertiaryWashSolution,"The TertiaryWashSolution will automatically be set to MModel[Sample, StockSolution, \"10% Bleach\"]:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        TertiaryWashSolution
      ],
      ObjectP[Model[Sample, StockSolution, "10% Bleach"]]
    ],

    Example[{Options,TertiaryWashSolution,"The TertiaryWashSolution will automatically be set to Null if TertiaryWash is False:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          TertiaryWash->False,
          Output->Options
        ],
        TertiaryWashSolution
      ],
      Null
    ],

    Example[{Options,TertiaryWashSolution,"Have different TertiaryWashSolutions for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          TertiaryWashSolution->{Model[Sample,StockSolution,"70% Ethanol"],Model[Sample, "Milli-Q water"]},
          Output->Options
        ],
        TertiaryWashSolution
      ],
      {ObjectP[Model[Sample,StockSolution,"70% Ethanol"]],ObjectP[Model[Sample, "Milli-Q water"]]}
    ],

    Example[{Options,NumberOfTertiaryWashes,"NumberOfTertiaryWashes will automatically be set to 5:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        NumberOfTertiaryWashes
      ],
      5
    ],

    Example[{Options,NumberOfTertiaryWashes,"The NumberOfTertiaryWashes will automatically be set to Null if TertiaryWash is False:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          TertiaryWash->False,
          Output->Options
        ],
        NumberOfTertiaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfTertiaryWashes,"Have different NumberOfTertiaryWashes for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          NumberOfTertiaryWashes->{8,10},
          Output->Options
        ],
        NumberOfTertiaryWashes
      ],
      {8,10}
    ],

    Example[{Options,TertiaryDryTime,"TertiaryDryTime will automatically be set to 10 Seconds:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        TertiaryDryTime
      ],
      10 Second
    ],

    Example[{Options,TertiaryDryTime,"The TertiaryDryTime will automatically be set to Null if TertiaryWash is False:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          TertiaryWash->False,
          Output->Options
        ],
        TertiaryDryTime
      ],
      Null
    ],

    Example[{Options,TertiaryDryTime,"Have different TertiaryDryTimes for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          TertiaryDryTime->{8 Second,30 Second},
          Output->Options
        ],
        TertiaryDryTime
      ],
      {8 Second,30 Second}
    ],


    Example[{Options,QuaternaryWash,"QuaternaryWash will default to False if not specified:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        QuaternaryWash
      ],
      False
    ],

    Example[{Options,QuaternaryWash,"Setting QuaternaryWash to False will turn off the other QuaternaryWash options:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          QuaternaryWash->False,
          Output->Options
        ],
        {QuaternaryWash,QuaternaryWashSolution,NumberOfQuaternaryWashes,QuaternaryDryTime}
      ],
      {False,Null,Null,Null}
    ],

    Example[{Options,QuaternaryWash,"Have different QuaternaryWash specifications for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          QuaternaryWash->{True,False},
          Output->Options
        ],
        QuaternaryWash
      ],
      {True,False}
    ],

    Example[{Options,QuaternaryWashSolution,"The QuaternaryWashSolution will automatically be set to Null:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        QuaternaryWashSolution
      ],
      Null
    ],

    Example[{Options,QuaternaryWashSolution,"The QuaternaryWashSolution will automatically be set to Model[Sample,StockSolution,\"70% Ethanol\"] if QuaternaryWash is True:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          QuaternaryWash->True,
          Output->Options
        ],
        QuaternaryWashSolution
      ],
      ObjectP[Model[Sample,StockSolution,"70% Ethanol"]]
    ],


    Example[{Options,QuaternaryWashSolution,"Have different QuaternaryWashSolutions for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          QuaternaryWashSolution->{Model[Sample,StockSolution,"70% Ethanol"],Model[Sample, "Milli-Q water"]},
          Output->Options
        ],
        QuaternaryWashSolution
      ],
      {ObjectP[Model[Sample,StockSolution,"70% Ethanol"]],ObjectP[Model[Sample, "Milli-Q water"]]}
    ],

    Example[{Options,NumberOfQuaternaryWashes,"NumberOfQuaternaryWashes will automatically be set to 5, if QuaternaryWash is True:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          QuaternaryWash->True,
          Output->Options
        ],
        NumberOfQuaternaryWashes
      ],
      5
    ],

    Example[{Options,NumberOfQuaternaryWashes,"The NumberOfQuaternaryWashes will automatically be set to Null:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          QuaternaryWash->False,
          Output->Options
        ],
        NumberOfQuaternaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfQuaternaryWashes,"Have different NumberOfQuaternaryWashes for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          NumberOfQuaternaryWashes->{8,10},
          Output->Options
        ],
        NumberOfQuaternaryWashes
      ],
      {8,10}
    ],

    Example[{Options,QuaternaryDryTime,"QuaternaryDryTime will automatically be set to 10 Seconds if QuaternaryWash is True:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          QuaternaryWash->True,
          Output->Options
        ],
        QuaternaryDryTime
      ],
      10 Second
    ],

    Example[{Options,QuaternaryDryTime,"The QuaternaryDryTime will automatically be set to Null:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          QuaternaryWash->False,
          Output->Options
        ],
        QuaternaryDryTime
      ],
      Null
    ],

    Example[{Options,QuaternaryDryTime,"Have different QuaternaryDryTimes for different samples:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          QuaternaryDryTime->{8 Second,30 Second},
          Output->Options
        ],
        QuaternaryDryTime
      ],
      {8 Second,30 Second}
    ],

    Example[{Options,MinRegularityRatio,"MinRegularityRatio is automatically set to 0.65:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        MinRegularityRatio
      ],
      0.65
    ],

    Example[{Options,MinRegularityRatio,"Set MinRegularityRatio for each sample:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          MinRegularityRatio->{0.4,0.8},
          Output->Options
        ],
        MinRegularityRatio
      ],
      {0.4,0.8}
    ],

    Example[{Options,MaxRegularityRatio,"MaxRegularityRatio is automatically set to 1:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        MaxRegularityRatio
      ],
      RangeP[1]
    ],
    
    Example[{Options,MaxRegularityRatio,"Set MaxRegularityRatio for each sample:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          MaxRegularityRatio->{0.8,0.9},
          Output->Options
        ],
        MaxRegularityRatio
      ],
      {0.8,0.9}
    ],

    Example[{Options,MinCircularityRatio,"MinCircularityRatio is automatically set to 0.65:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        MinCircularityRatio
      ],
      RangeP[0.65]
    ],

    Example[{Options,MinCircularityRatio,"Set MinCircularityRatio for each sample:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          MinCircularityRatio->{0.4,0.8},
          Output->Options
        ],
        MinCircularityRatio
      ],
      {0.4,0.8}
    ],

    Example[{Options,MaxCircularityRatio,"MaxCircularityRatio is automatically set to 1:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        MaxCircularityRatio
      ],
      RangeP[1]
    ],

    Example[{Options,MaxCircularityRatio,"Set MaxCircularityRatio for each sample:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          MaxCircularityRatio->{0.8,0.9},
          Output->Options
        ],
        MaxCircularityRatio
      ],
      {0.8,0.9}
    ],

    Example[{Options,MinDiameter,"MinDiameter is automatically set to 0.5 Millimeter:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        MinDiameter
      ],
      0.5 Millimeter
    ],

    Example[{Options,MinDiameter,"Set MinDiameter for each sample:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          MinDiameter->{0.4 Millimeter,0.8 Millimeter},
          Output->Options
        ],
        MinDiameter
      ],
      {0.4 Millimeter,0.8 Millimeter}
    ],

    Example[{Options,MaxDiameter,"MaxDiameter is automatically set to 2 Millimeter:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        MaxDiameter
      ],
      RangeP[2 Millimeter]
    ],

    Example[{Options,MaxDiameter,"Set MaxDiameter for each sample:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          MaxDiameter->{10 Millimeter,6 Millimeter},
          Output->Options
        ],
        MaxDiameter
      ],
      {10 Millimeter,6 Millimeter}
    ],

    Example[{Options,MinColonySeparation,"MinColonySeparation is automatically set to 0.2 Millimeter:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        MinColonySeparation
      ],
      0.2 Millimeter
    ],

    Example[{Options,MinColonySeparation,"Set MinColonySeparation for each sample:"},
      Lookup[
        ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          MinColonySeparation->{0.4 Millimeter,0.8 Millimeter},
          Output->Options
        ],
        MinColonySeparation
      ],
      {0.4 Millimeter,0.8 Millimeter}
    ],

    Example[{Options,Name,"Name of the output protocol object can be specified:"},
      ExperimentPickColonies[
        Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        Name->"ExperimentPickColonies name test protocol"<> $SessionUUID
      ],
      Object[Protocol,RoboticCellPreparation,"ExperimentPickColonies name test protocol"<> $SessionUUID]
    ],

    (* TODO: Add Template option test *)

    Example[{Options,SamplesInStorageCondition,"SamplesInStorageCondition can be specified:"},
      options=ExperimentPickColonies[
        Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        SamplesInStorageCondition->Refrigerator,
        Output->Options
      ];
      Lookup[options,SamplesInStorageCondition],
      Refrigerator,
      Variables:>{options}
    ],

    Example[{Options,SamplesOutStorageCondition,"SamplesOutStorageCondition can be specified:"},
      options=ExperimentPickColonies[
        Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        SamplesOutStorageCondition->BacterialShakingIncubation,
        Output->Options
      ];
      Lookup[options,SamplesOutStorageCondition],
      BacterialShakingIncubation,
      Variables:>{options}
    ],
    Example[{Options,Preparation,"Preparation is always set to Robotic as this experiment can only happen on the qPix:"},
      options=ExperimentPickColonies[
        Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        Output->Options
      ];
      Lookup[options,Preparation],
      Robotic,
      Variables:>{options}
    ],

    Example[{Options,WorkCell,"WorkCell is always set to qPix as this experiment can only happen on the qPix:"},
      options=ExperimentPickColonies[
        Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        Output->Options
      ];
      Lookup[options,WorkCell],
      qPix,
      Variables:>{options}
    ],

    Example[{Options,MeasureWeight,"Set the MeasureWeight option:"},
      options=ExperimentPickColonies[Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],MeasureWeight->True,Output->Options];
      Lookup[options,MeasureWeight],
      True,
      Variables:>{options}
    ],
    Example[{Options,MeasureVolume,"Set the MeasureVolume option:"},
      options=ExperimentPickColonies[Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],MeasureVolume->True,Output->Options];
      Lookup[options,MeasureVolume],
      True,
      Variables:>{options}
    ],
    Example[{Options,ImageSample,"Set the ImageSample option:"},
      options=ExperimentPickColonies[Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],ImageSample->True,Output->Options];
      Lookup[options,ImageSample],
      True,
      Variables:>{options}
    ],

    
    (* --- Messages --- *)
    Example[{Messages,"NonSolidSamples","Return $Failed if the samples the colonies are being picked from are not solid:"},
      ExperimentPickColonies[Object[Sample, "ExperimentPickColonies" <> " test liquid e.coli culture 1 in omniTray " <> $SessionUUID]],
      $Failed,
      Messages :> {Error::NonSolidSamples,Error::InvalidInput}
    ],
    Example[{Messages,"NonOmniTrayContainer","Return $Failed if the input samples are not in an omnitray:"},
      ExperimentPickColonies[Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in dwp " <> $SessionUUID]],
      $Failed,
      Messages :> {Error::NonOmniTrayContainer,Error::InvalidInput}
    ],
    Example[{Messages,"TooManyInputContainers","Return $Failed if the input samples are contained in more than 4 unique containers:"},
      ExperimentPickColonies[
        {
          Object[Container,Plate, "ExperimentPickColonies" <> " test omniTray 1 " <> $SessionUUID],
          Object[Container,Plate, "ExperimentPickColonies" <> " test omniTray 2 " <> $SessionUUID],
          Object[Container,Plate, "ExperimentPickColonies" <> " test omniTray 3 " <> $SessionUUID],
          Object[Container,Plate, "ExperimentPickColonies" <> " test omniTray 4 " <> $SessionUUID],
          Object[Container,Plate, "ExperimentPickColonies" <> " test omniTray 5 " <> $SessionUUID],
          Object[Container,Plate, "ExperimentPickColonies" <> " test omniTray 6 " <> $SessionUUID]
        }
      ],
      $Failed,
      Messages :> {Error::TooManyInputContainers,Error::InvalidInput}
    ],
    Example[{Messages,"PrimaryWashMismatch","If PrimaryWash->True and other PrimaryWash options are Null, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          PrimaryWash->True,
          NumberOfPrimaryWashes->Null,
          Output -> Options
        ],
        PrimaryWash
      ],
      True,
      Messages :> {Error::PrimaryWashMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"SecondaryWashMismatch","If SecondaryWash->True and other SecondaryWash options are Null, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          SecondaryWash->True,
          NumberOfSecondaryWashes->Null,
          Output -> Options
        ],
        SecondaryWash
      ],
      True,
      Messages :> {Error::SecondaryWashMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"TertiaryWashMismatch","If TertiaryWash->True and other TertiaryWash options are Null, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          TertiaryWash->True,
          NumberOfTertiaryWashes->Null,
          Output -> Options
        ],
        TertiaryWash
      ],
      True,
      Messages :> {Error::TertiaryWashMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"QuaternaryWashMismatch","If QuaternaryWash->True and other QuaternaryWash options are Null, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          QuaternaryWash->True,
          NumberOfQuaternaryWashes->Null,
          Output -> Options
        ],
        QuaternaryWash
      ],
      True,
      Messages :> {Error::QuaternaryWashMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"TooManyWashSolutions","If there are more than 3 different sample models across PrimaryWashSolution, SecondaryWashSolution, TertiaryWashSolution, and QuaternaryWashSolution, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          PrimaryWashSolution -> Model[Sample,StockSolution,"70% Ethanol"],
          SecondaryWashSolution -> Model[Sample, "Milli-Q water"],
          TertiaryWashSolution -> Model[Sample, "Bleach"],
          QuaternaryWashSolution -> Model[Sample, "Methanol"],
          Output -> Options
        ],
        {
          PrimaryWashSolution,
          SecondaryWashSolution,
          TertiaryWashSolution,
          QuaternaryWashSolution
        }
      ],
      {ObjectP[Model[Sample,StockSolution,"70% Ethanol"]],ObjectP[Model[Sample, "Milli-Q water"]],ObjectP[Model[Sample, "Bleach"]],ObjectP[Model[Sample, "Methanol"]]},
      Messages :> {Error::TooManyWashSolutions,Error::InvalidOption}
    ],
    Example[{Messages,"OutOfOrderWashStages","If a wash stage is specified but not all of the prerequisite stages are specified, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          PrimaryWash -> False,
          SecondaryWash -> True,
          Output -> Options
        ],
        PrimaryWash
      ],
      False,
      Messages :> {Error::OutOfOrderWashStages,Error::InvalidOption}
    ],
    Example[{Messages,"PickCoordinatesMissing","If Populations->CustomCoordinates and PickCoordinates are not specified an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> CustomCoordinates,
          Output -> Options
        ],
        Populations
      ],
      CustomCoordinates,
      Messages :> {Error::PickCoordinatesMissing,Error::InvalidOption}
    ],
    Example[{Messages,"MultiplePopulationMethods","If Populations -> population primitive and PickCoordinates are specified an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> {Diameter[]},
          PickCoordinates -> ConstantArray[{0 Millimeter, 0 Millimeter},10],
          Output -> Options
        ],
        Populations
      ],
      {{DiameterPrimitiveP}},
      Messages :> {Error::MultiplePopulationMethods,Error::InvalidOption}
    ],
    Example[{Messages,"AnalysisOptionsMismatch","If Populations -> CustomCoordinates and any of the global filtering options are set an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> CustomCoordinates,
          PickCoordinates -> ConstantArray[{0 Millimeter, 0 Millimeter},10],
          MinCircularityRatio -> 0.3,
          Output -> Options
        ],
        Populations
      ],
      CustomCoordinates,
      Messages :> {Error::AnalysisOptionsMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"PopulationMismatch","If Populations is specified as a mix of population primitives and CustomCoordinates for a single sample, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> {{CustomCoordinates, Diameter[]}},
          Output -> Options
        ],
        Populations
      ],
      {{CustomCoordinates, DiameterPrimitiveP}},
      Messages :> {Error::PopulationMismatch,Error::InvalidOption}
    ],

    Example[{Messages,"IndexMatchingPrimitive","An error is thrown if some options in MultiFeatured are not index matched:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> {
            MultiFeatured[
              Features->{Diameter, Fluorescence},
              NumberOfDivisions->{5}
            ]
          },
          Output -> Options
        ],
        Populations
      ],
      {{MultiFeaturedPrimitiveP}},
      Messages :> {Error::IndexMatchingPrimitive, Error::InvalidOption}
    ],
    
    Example[{Messages,"NoAutomaticWavelength","If for a MultiFeatured population, Features -> Fluorescence and no fluorescent wavelength is given or can be found in the composition of the input sample, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli no fluorescent wavelengths sample 1 in omniTray" <> $SessionUUID],
          Populations -> {
            MultiFeatured[
              Features -> {Fluorescence,Diameter}
            ]
          },
          Output -> Options
        ],
        Populations
      ],
      {{MultiFeaturedPrimitiveP}},
      Messages :> {Error::NoAutomaticWavelength, Error::InvalidOption}
    ],
    (* Instrument Precision checks *)
    Example[{Messages,"InstrumentPrecision","If a ColonyPickingDepth with a greater precision than 0.01 Millimeter is given, it is rounded:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          ColonyPickingDepth -> 1.222 Millimeter,
          Output -> Options
        ],
        ColonyPickingDepth
      ],
      RangeP[1.22 Millimeter],
      Messages :> {Warning::InstrumentPrecision}
    ],

    Example[{Messages,"InstrumentPrecision","If an ExposureTime with a greater precision than 1 Millisecond is given, it is rounded:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          ExposureTimes -> {{1.5 Millisecond, 2 Millisecond}},
          Output -> Options
        ],
        ExposureTimes
      ],
      {{RangeP[2 Millisecond], RangeP[2 Millisecond]}},
      Messages :> {Warning::InstrumentPrecision}
    ],

    Example[{Messages,"InstrumentPrecision","If a PrimaryDryTime with a greater precision than 1 Second is given, it is rounded:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          PrimaryDryTime -> 1.5 Second,
          Output -> Options
        ],
        PrimaryDryTime
      ],
      RangeP[2 Second],
      Messages :> {Warning::InstrumentPrecision}
    ],

    Example[{Messages,"InstrumentPrecision","If a SecondaryDryTime with a greater precision than 1 Second is given, it is rounded:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          PrimaryWash -> True,
          SecondaryDryTime -> 1.5 Second,
          Output -> Options
        ],
        SecondaryDryTime
      ],
      RangeP[2 Second],
      Messages :> {Warning::InstrumentPrecision}
    ],

    Example[{Messages,"InstrumentPrecision","If a TertiaryDryTime with a greater precision than 1 Second is given, it is rounded:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          PrimaryWash -> True,
          SecondaryWash -> True,
          TertiaryDryTime -> 1.5 Second,
          Output -> Options
        ],
        TertiaryDryTime
      ],
      RangeP[2 Second],
      Messages :> {Warning::InstrumentPrecision}
    ],

    Example[{Messages,"InstrumentPrecision","If a QuaternaryDryTime with a greater precision than 1 Second is given, it is rounded:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          PrimaryWash -> True,
          SecondaryWash -> True,
          TertiaryWash -> True,
          QuaternaryDryTime -> 1.5 Second,
          Output -> Options
        ],
        QuaternaryDryTime
      ],
      RangeP[2 Second],
      Messages :> {Warning::InstrumentPrecision}
    ],

    Example[{Messages,"RepeatedPopulationNames","If the same PopulationName is used in multiple Populations, an error will be thrown :"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations-> {{
            Diameter[PopulationName -> "AwesomePopulation"],
            Fluorescence[PopulationName -> "AwesomePopulation"]
          }},
          Output -> Options
        ],
        Populations
      ],
      {{DiameterPrimitiveP,FluorescencePrimitiveP}},
      Messages :> {Error::RepeatedPopulationNames, Error::InvalidOption}
    ],

    Example[{Messages,"SingleAutomaticWavelength","If when trying to determine the fluorescent wavelength pair to use if it is not specified, and the Model[Cell] in the composition input sample only matches half of a wavelength pair, a warning will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli half match fluorescent wavelengths sample 1 in omniTray" <> $SessionUUID],
          Populations->Automatic,
          Output -> Options
        ],
        Populations
      ],
      FluorescencePrimitiveP,
      Messages :> {Warning::SingleAutomaticWavelength}
    ],

    Example[{Messages,"ImagingOptionMismatch","If ImagingChannels and ExposureTimes are set to different lengths, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          ImagingChannels -> {BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer}},
          ExposureTimes -> {3 Millisecond, 5 Millisecond},
          Output -> Options
        ],
        ExposureTimes
      ],
      {3 Millisecond, 5 Millisecond},
      Messages :> {Error::ImagingOptionMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"MissingImagingChannels","If there are imaging channels specified in a Population that are not specified in ImagingChannels, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> Fluorescence[ExcitationWavelength -> 457 Nanometer, EmissionWavelength -> 536 Nanometer],
          ImagingChannels -> {BrightField,{377 Nanometer,447 Nanometer},{531 Nanometer, 593 Nanometer}},
          Output -> Options
        ],
        ImagingChannels
      ],
      {BrightField,{377 Nanometer,447 Nanometer},{531 Nanometer, 593 Nanometer}},
      Messages :> {Error::MissingImagingChannels,Error::InvalidOption}
    ],
    Example[{Messages,"DuplicateImagingChannels","If an imaging channel is specified multiple times in ImagingChannels, a warning will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> Automatic,
          ImagingChannels -> {BrightField,{377 Nanometer,447 Nanometer},BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer}},
          Output -> Options
        ],
        ImagingChannels
      ],
      {BrightField,{377 Nanometer,447 Nanometer},BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer}},
      Messages :> {Warning::DuplicateImagingChannels}
    ],
    Example[{Messages,"InvalidDestinationMediaState","If the DestinationMedia has a non Liquid or Solid State, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationMedia -> Object[Sample, "ExperimentPickColonies" <> " test gas sample 1 in omniTray " <> $SessionUUID],
          Output -> Options
        ],
        DestinationMedia
      ],
      ObjectP[Object[Sample, "ExperimentPickColonies" <> " test gas sample 1 in omniTray " <> $SessionUUID]],
      Messages :> {Error::InvalidDestinationMediaState,Error::InvalidOption}
    ],
    Example[{Messages,"DestinationMediaTypeMismatch","If the State of DestinationMedia does not match DestinationMediaType, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationMediaType -> SolidMedia,
          DestinationMedia -> Object[Sample, "ExperimentPickColonies" <> " test LB Broth in 500 mL flask " <> $SessionUUID],
          Output -> Options
        ],
        DestinationMediaType
      ],
      SolidMedia,
      Messages :> {Error::DestinationMediaTypeMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"InvalidDestinationMediaContainer","If the DestinationMediaContainer does not have 1, 24, or 96 wells or is deep well but does not have 96 wells, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationMediaContainer -> Object[Container,Plate,"ExperimentPickColonies" <> " test 24-well Round Bottom Deep Well Plate " <> $SessionUUID],
          Output -> Options
        ],
        DestinationMediaContainer
      ],
      {ObjectP[Object[Container, Plate, "ExperimentPickColonies" <> " test 24-well Round Bottom Deep Well Plate " <> $SessionUUID]]},
      Messages :> {Error::InvalidDestinationMediaContainer,Error::InvalidOption}
    ],
    Example[{Messages,"TooManyDestinationMediaContainers","If there are more than 4 unique DestinationMediaContainers, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> {{
            Diameter[],
            Circularity[],
            Fluorescence[NumberOfColonies -> 20],
            Isolation[],
            Regularity[],
            Absorbance[],
            Absorbance[]
          }},
          DestinationMediaType -> LiquidMedia,
          DestinationMediaContainer -> {{
            Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 1 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 2 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 3 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 4 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 5 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 6 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentPickColonies" <> " test dwp 7 " <> $SessionUUID]
          }},
          Output -> Options
        ],
        DestinationMediaType
      ],
      LiquidMedia,
      Messages :> {Error::TooManyDestinationMediaContainers,Error::InvalidOption}
    ],
    Example[{Messages,"DestinationFillDirectionMismatch","If DestinationFillDirection->CustomCoordinates and MaxDestinationNumberOfColumns or MaxDestinationNumberOfRows is not Null, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationFillDirection->CustomCoordinates,
          MaxDestinationNumberOfColumns->5,
          DestinationCoordinates -> Repeat[{0 Millimeter, 0 Millimeter},10],
          Output -> Options
        ],
        DestinationFillDirection
      ],
      CustomCoordinates,
      Messages :> {Error::DestinationFillDirectionMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"MissingDestinationCoordinates","If DestinationFillDirection->CustomCoordinates and DestinationCoordinates are not specified, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationFillDirection->CustomCoordinates,
          Output -> Options
        ],
        DestinationFillDirection
      ],
      CustomCoordinates,
      Messages :> {Error::MissingDestinationCoordinates,Error::InvalidOption}
    ],
    Example[{Messages,"TooManyDestinationCoordinates","If the length of the specified DestinationCoordinates is longer than 384, a warning will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationFillDirection->CustomCoordinates,
          DestinationCoordinates -> Repeat[{0 Millimeter, 0 Millimeter},400],
          Output -> Options
        ],
        DestinationCoordinates
      ],
      Repeat[{0 Millimeter, 0 Millimeter},400],
      Messages :> {Warning::TooManyDestinationCoordinates}
    ],
    Example[{Messages,"DestinationMixMismatch","If DestinationMix->False and DestinationNumberOfMixes->an Integer, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationMediaType->LiquidMedia,
          DestinationMix -> False,
          DestinationNumberOfMixes -> 10,
          Output -> Options
        ],
        DestinationMix
      ],
      False,
      Messages :> {Error::DestinationMixMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"InvalidMixOption","If DestinationMediaType->SolidMedia and the DestinationMix gets set to True, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationMediaType -> SolidMedia,
          DestinationMix -> True,
          Output -> Options
        ],
        DestinationMediaType
      ],
      SolidMedia,
      Messages :> {Error::InvalidMixOption,Error::InvalidOption}
    ],
    Example[{Messages,"PickingToolIncompatibleWithDestinationMediaContainer","If the specified ColonyPickingTool is incompatible with a DestinationMediaContainer, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli"],
          DestinationMediaType -> LiquidMedia,
          DestinationMediaContainer -> Object[Container,Plate, "ExperimentPickColonies" <> " test 24-well Plate " <> $SessionUUID],
          Output -> Options
        ],
        ColonyPickingTool
      ],
      ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli"]],
      Messages :> {Error::PickingToolIncompatibleWithDestinationMediaContainer,Error::InvalidOption}
    ],
    Example[{Messages,"NoAvailablePickingTool","If there is no ColonyPickingTool that satisfies the colony picking tool parameter options, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationMediaType -> LiquidMedia,
          NumberOfHeads -> 384,
          Output -> Options
        ],
        NumberOfHeads
      ],
      384,
      Messages :> {Error::NoAvailablePickingTool,Error::NumberOfHeadsMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"NotPreferredColonyHandlerHead","If the specified ColonyPickingTool is not preferred for the cell type in the input sample, a warning will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationMediaType -> LiquidMedia,
          ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for Phage - Deep well"],
          Output -> Options
        ],
        ColonyPickingTool
      ],
      ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for Phage - Deep well"]],
      Messages :> {Warning::NotPreferredColonyHandlerHead}
    ],
    Example[{Messages,"HeadDiameterMismatch","If the specified HeadDiameter does not match the value in the HeadDiameter field of the specified ColonyPickingTool, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"],
          DestinationMediaType -> LiquidMedia,
          HeadDiameter -> 1 Millimeter,
          Output -> Options
        ],
        ColonyPickingTool
      ],
      ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"]],
      Messages :> {Error::HeadDiameterMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"HeadLengthMismatch","If the specified HeadLength does not match the value in the HeadLength field of the specified ColonyPickingTool, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"],
          DestinationMediaType -> LiquidMedia,
          HeadLength -> 9.4 Millimeter,
          Output -> Options
        ],
        ColonyPickingTool
      ],
      ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"]],
      Messages :> {Error::HeadLengthMismatch,Error::InvalidOption,Error::PickingToolIncompatibleWithDestinationMediaContainer}
    ],
    Example[{Messages,"NumberOfHeadsMismatch","If the specified NumberOfHeads does not match the value in the NumberOfHeads field of the specified ColonyPickingTool, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"],
          DestinationMediaType -> LiquidMedia,
          NumberOfHeads -> 24,
          Output -> Options
        ],
        ColonyPickingTool
      ],
      ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"]],
      Messages :> {Error::NumberOfHeadsMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"ColonyHandlerHeadCassetteApplicationMismatch","If the specified ColonyHandlerHeadCassetteApplication does not match the value in the Application field of the specified ColonyPickingTool, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"],
          DestinationMediaType -> LiquidMedia,
          ColonyHandlerHeadCassetteApplication -> Spread,
          Output -> Options
        ],
        ColonyPickingTool
      ],
      ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"]],
      Messages :> {Error::ColonyHandlerHeadCassetteApplicationMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"InvalidColonyPickingDepths","If the specified ColonyPickingDepth is greater than the depth of a well of an input container, an error will be thrown:"},
      Lookup[
        ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          ColonyPickingDepth -> 15 Millimeter,
          Output -> Options
        ],
        ColonyPickingDepth
      ],
      15 Millimeter,
      Messages :> {Error::InvalidColonyPickingDepths,Error::InvalidOption}
    ],
    Example[{Messages,"IncompatibleMaterials","If a wash solution is not compatible with the wetted materials of the instrument, an error will be thrown:"},
      ExperimentPickColonies[
        Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        PrimaryWashSolution -> Model[Sample, "ExperimentPickColonies" <> " test incompatible sample model " <> $SessionUUID],
        SecondaryWash -> False,
        Output->Options
      ],
      _List,
      Messages :> {Warning::IncompatibleMaterials}
    ],
    Example[{Messages,"IncompatibleMaterials","If the input sample is not compatible with the wetted materials of the instrument, an error will be thrown:"},
      ExperimentPickColonies[
        Object[Sample, "ExperimentPickColonies" <> " test incompatible input sample in omnitray " <> $SessionUUID],
        Output->Options
      ],
      _List,
      Messages :> {Warning::IncompatibleMaterials,Warning::NotPreferredColonyHandlerHead}
    ],
    Example[{Options,SamplesInStorageCondition,"Indicates how the input samples of the experiment should be stored:"},
      options=ExperimentPickColonies[Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],SamplesInStorageCondition->BacterialShakingIncubation,Output->Options];
      Lookup[options,SamplesInStorageCondition],
      BacterialShakingIncubation,
      Variables:>{options}
    ],
    Test["A resource for an optical filter is found the in the RequiredObjects of the rcp protocol, if there is an Absorbance population:",
      Module[{protocol},
        protocol = ExperimentPickColonies[
          Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Populations -> {{Diameter, Absorbance[NumberOfColonies->10]}}
        ];
        MemberQ[Download[protocol, RequiredObjects], ObjectP[Model[Part,OpticalFilter]]]
      ],
      True
    ],
    Test["The AbsorbanceFilter field is populated in the OutputUnitOperation if there is an Absorbance population anywhere in the Populations option:",
      Module[{protocol},
        protocol = ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations -> {{Diameter, Absorbance[NumberOfColonies->10]},{Circularity, Diameter}}
        ];
        Download[protocol, OutputUnitOperations[[1]][AbsorbanceFilter]]
      ],
      ObjectP[Model[Part,OpticalFilter]]
    ],
    Test["The AbsorbanceFilter field is not populated in the OutputUnitOperation if there are no Absorbance populations anywhere in the Populations option:",
      Module[{protocol},
        protocol = ExperimentPickColonies[
          {
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentPickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations -> {{Diameter, Fluorescence[NumberOfColonies->10]},{Circularity, Diameter}}
        ];
        Download[protocol, OutputUnitOperations[[1]][AbsorbanceFilter]]
      ],
      Null
    ]
  },
  SymbolSetUp:>(
    pickColoniesSymbolSetUp["ExperimentPickColonies"]
  ),
  SymbolTearDown :> (
    pickColoniesObjectErasure["ExperimentPickColonies", True]
  )
];

(* ::Subsection:: *)
(* ExperimentPickColoniesOptions *)
DefineTests[ExperimentPickColoniesOptions,
  {
    Example[{Basic,"Display the option values which will be used in the experiment:"},
      ExperimentPickColoniesOptions[Object[Sample, "ExperimentPickColoniesOptions" <> " test e.coli sample 1 in omniTray " <> $SessionUUID]],
      _Grid
    ],
    Example[{Basic,"Basic pick colonies with DestinationMediaType -> LiquidMedia:"},
      ExperimentPickColoniesOptions[Object[Sample, "ExperimentPickColoniesOptions" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        DestinationMediaType -> LiquidMedia
      ],
      _Grid
    ],
    Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
      ExperimentPickColoniesOptions[Object[Sample, "ExperimentPickColoniesOptions" <> " test liquid e.coli culture 1 in omniTray " <> $SessionUUID]],
      _Grid,
      Messages :> {Error::NonSolidSamples,Error::InvalidInput}
    ],

    Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
      ExperimentPickColoniesOptions[Object[Sample, "ExperimentPickColoniesOptions" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        OutputFormat -> List
      ],
      {(_Rule|_RuleDelayed)..}
    ]
  },
  SymbolSetUp:>(
    pickColoniesSymbolSetUp["ExperimentPickColoniesOptions"]
  ),
  SymbolTearDown :> (
    pickColoniesObjectErasure["ExperimentPickColoniesOptions", True]
  )
];

(* ::Subsection:: *)
(* ValidExperimentPickColoniesQ *)
DefineTests[ValidExperimentPickColoniesQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentPickColoniesQ[Object[Sample, "ValidExperimentPickColoniesQ" <> " test e.coli sample 1 in omniTray " <> $SessionUUID]],
      True
    ],
    Example[{Basic,"Return False if there are problems with the inputs or options:"},
      ValidExperimentPickColoniesQ[Object[Sample, "ValidExperimentPickColoniesQ" <> " test liquid e.coli culture 1 in omniTray " <> $SessionUUID]],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentPickColoniesQ[Object[Sample, "ValidExperimentPickColoniesQ" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentPickColoniesQ[Object[Sample, "ValidExperimentPickColoniesQ" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],Verbose->True],
      True
    ]
  },
  SymbolSetUp:>(
    pickColoniesSymbolSetUp["ValidExperimentPickColoniesQ"]
  ),
  SymbolTearDown :> (
    pickColoniesObjectErasure["ValidExperimentPickColoniesQ", True]
  )
];
(* ::Subsection:: *)
(* PickColonies *)
DefineTests[PickColonies,
  {
    Example[{Basic,"Form a pick colonies unit operation:"},
      PickColonies[
        DestinationMix -> True,
        DestinationNumberOfMixes -> 5
      ],
      PickColoniesP
    ],
    Example[{Basic,"Specifying a key incorrectly will not form a unit operation:"},
      primitive=PickColonies[
        DestinationMix -> True,
        DestinationNumberOfMixes -> 5,
        DestinationMixType -> Vortex
      ];
      MatchQ[primitive,PickColoniesP],
      False
    ],
    Example[{Basic,"A basic protocol is generated when the unit op is inside an RCP:"},
      ExperimentRoboticCellPreparation[
        {
          PickColonies[
            Sample -> Object[Sample, "PickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            DestinationMediaType -> LiquidMedia,
            Populations -> {{Diameter, Circularity}}
          ]
        }
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ],
    Example[{Basic,"A protocol is generated when the unit op that contains custom coordinates is inside an RCP:"},
      ExperimentRoboticCellPreparation[
        {
          PickColonies[
            Sample -> {
              Object[Sample, "PickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
              Object[Sample, "PickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
            },
            DestinationMediaType -> LiquidMedia,
            PickCoordinates -> {Null,{{1 Millimeter, 1 Millimeter}}}
          ]
        }
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ],
    Example[{Basic,"A protocol is generated when the unit op that specifies sanitization options, mixing options, and global cutoffs is inside an RCP:"},
      ExperimentRoboticCellPreparation[
        {
          PickColonies[
            Sample -> {
              Object[Sample, "PickColonies" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
              Object[Sample, "PickColonies" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
            },
            DestinationMediaType -> LiquidMedia,
            Populations -> {{Diameter, Circularity},{Fluorescence[NumberOfColonies->10]}},
            SecondaryWash -> False,
            DestinationMix -> False,
            MinColonySeparation -> 4 Millimeter
          ]
        }
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ]
  },
  SymbolSetUp:>(
    pickColoniesSymbolSetUp["PickColonies"]
  ),
  SymbolTearDown :> (
    pickColoniesObjectErasure["PickColonies", True]
  )
];
(* ::Subsection:: *)
(* Setup and Teardown *)
pickColoniesObjectErasure[functionName_String, tearDownBool:BooleanP] := Module[
  {namedObjects,allObjects,existingObjs},

  namedObjects = Quiet[Cases[
    Flatten[{
      (* Containers *)
      Object[Container,Plate, functionName <> " test dwp 1 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test dwp 2 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test dwp 3 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test dwp 4 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test dwp 5 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test dwp 6 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test dwp 7 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test omniTray 1 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test omniTray 2 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test omniTray 3 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test omniTray 4 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test omniTray 5 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test omniTray 6 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test omniTray 7 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test omniTray 8 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test omniTray 9 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test omniTray 10 " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test omniTray 11 " <> $SessionUUID],
      Object[Container,Vessel, functionName <> " test 500mL flask " <> $SessionUUID],
      Object[Container,Plate, functionName <> " test 24-well Plate " <> $SessionUUID],
      Object[Container,Plate,functionName <> " test 24-well Round Bottom Deep Well Plate " <> $SessionUUID],

      (* Media *)
      Model[Sample,Media, functionName <> " test solid LB agar media model " <> $SessionUUID],

      (* Bacteria *)
      Model[Cell,Bacteria, functionName <> " test e.coli model - gfp Positive " <> $SessionUUID],
      Model[Cell,Bacteria, functionName <> " test e.coli no fluorescent wavelengths model - gfp Positive " <> $SessionUUID],
      Model[Cell,Bacteria, functionName <> " test e.coli half match fluorescent wavelengths model - gfp Positive " <> $SessionUUID],

      (* Model[Sample]s *)
      Model[Sample, functionName <> " test e.coli and LB agar sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test e.coli no fluorescent wavelengths and LB agar sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test e.coli half match fluorescent wavelengths and LB agar sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test gas sample model " <> $SessionUUID],
      Model[Sample, functionName <> " test incompatible sample model " <> $SessionUUID],

      (* Samples *)
      Object[Sample, functionName <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli sample 2 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli sample 3 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli sample 4 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli sample 5 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli sample 6 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli sample 1 in dwp " <> $SessionUUID],
      Object[Sample, functionName <> " test liquid e.coli culture 1 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test gas sample 1 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test LB Broth in 500 mL flask " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli no fluorescent wavelengths sample 1 in omniTray" <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli half match fluorescent wavelengths sample 1 in omniTray" <> $SessionUUID],
      Object[Sample, functionName <> " test incompatible input sample in omnitray " <> $SessionUUID]
    }],
    ObjectP[]
  ]];

  allObjects = If[tearDownBool,
    Quiet[Cases[
      Flatten[{
        $CreatedObjects,
        namedObjects
      }],
      ObjectP[]
    ]],
    namedObjects
  ];

  existingObjs=PickList[allObjects,DatabaseMemberQ[allObjects]];
  EraseObject[existingObjs,Force->True,Verbose->False];

  If[tearDownBool,
    Unset[$CreatedObjects];
  ];
];

pickColoniesSymbolSetUp[functionName_String] := Module[{},

  (* Initialize Created Objects variable *)
  $CreatedObjects = {};

  (* Erase any named objects so we don't try to create duplicates *)
  pickColoniesObjectErasure[functionName, False];

  (* Set up our test objects *)
  Module[
    {
      (* Containers *)
      dwp1,dwp2,dwp3,dwp4,dwp5,dwp6,dwp7,
      omniTray1,omniTray2,omniTray3,omniTray4,omniTray5,omniTray6,omniTray7,omniTray8,omniTray9,omniTray10,omniTray11,
      flask500mL,plate24Well,plate24DeepWell,

      (* Medias *)
      testSolidLBMedia,

      (* Bacterias *)
      testEColi,testEColiNoFluorescentWavelengths,testEColiHalfMatchFluorescentWavelengths,

      (* Model[Sample]s *)
      testEColiSampleModel,testEColiNoFluorescentWavelengthsSampleModel,testEColiHalfMatchFluorescentWavelengthsSampleModel,
      testGasSampleModel,testIncompatibleSampleModel,

      (* Samples *)
      eColiSample1,eColiSample2,eColiSample3,eColiSample4,eColiSample5,eColiSample6,
      sampleInDwp,liquidCultureSample,gasSample,testLBBrothSample,eColiSampleNoFluorescentWavelengths,
      eColiSampleHalfMatchFluorescentWavelengths,testIncompatibleSample,

      developerObjectPackets
    },

    (* set up test containers for our samples *)
    {
      dwp1,
      dwp2,
      dwp3,
      dwp4,
      dwp5,
      dwp6,
      dwp7,
      omniTray1,
      omniTray2,
      omniTray3,
      omniTray4,
      omniTray5,
      omniTray6,
      omniTray7,
      omniTray8,
      omniTray9,
      omniTray10,
      omniTray11,
      flask500mL,
      plate24Well,
      plate24DeepWell
    }=Upload[{
      Sequence@@Table[
        <|
          Type -> Object[Container,Plate],
          Model -> Link[Model[Container, Plate, "id:L8kPEjkmLbvW"],Objects],
          Name -> functionName <> " test dwp " <> ToString[i] <> " " <> $SessionUUID,
          DeveloperObject -> True
        |>,
        {i,1,7}
      ],
      Sequence@@Table[
        <|
          Type -> Object[Container,Plate],
          Model -> Link[Model[Container, Plate, "id:O81aEBZjRXvx"],Objects],
          Name -> functionName <> " test omniTray "<> ToString[i] <>" " <> $SessionUUID,
          DeveloperObject -> True
        |>,
        {i,1,11}
      ],
      <|
        Type -> Object[Container,Vessel],
        Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGG0b"],Objects], (* Model[Container, Vessel, "500mL Erlenmeyer Flask"] *)
        Name -> functionName <> " test 500mL flask " <> $SessionUUID,
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container,Plate],
        Model -> Link[Model[Container, Plate, "id:1ZA60vLlZzrM"],Objects], (* Model[Container, Plate, "Nunc Non-Treated 24-well Plate"] *)
        Name -> functionName <> " test 24-well Plate " <> $SessionUUID,
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container,Plate],
        Model -> Link[Model[Container, Plate, "id:jLq9jXY4kkMq"],Objects], (* Model[Container, Plate, "24-well Round Bottom Deep Well Plate"] *)
        Name -> functionName <> " test 24-well Round Bottom Deep Well Plate " <> $SessionUUID,
        DeveloperObject -> True
      |>
    }];

    (* Create tests Medias *)
    testSolidLBMedia = UploadStockSolution[
      {
        {20 Gram, Model[Sample, "LB Broth"]},
        {965 Milliliter, Model[Sample, "Milli-Q water"]},
        {15 Gram, Model[Sample, "Agarose I"]}
      },
      Type->Media,
      Autoclave->False,
      DefaultStorageCondition->Model[StorageCondition, "Refrigerator"],
      Preparable->False,
      Name -> functionName <> " test solid LB agar media model " <> $SessionUUID,
      ShelfLife->6 Month
    ];

    (* Create test Model[Cell]s *)
    {
      testEColi,
      testEColiHalfMatchFluorescentWavelengths,
      testEColiNoFluorescentWavelengths
    }=UploadBacterialCell[
      {
        functionName <> " test e.coli model - gfp Positive " <> $SessionUUID,
        functionName <> " test e.coli half match fluorescent wavelengths model - gfp Positive " <> $SessionUUID,
        functionName <> " test e.coli no fluorescent wavelengths model - gfp Positive " <> $SessionUUID
      },
      Morphology -> Bacilli,
      CellLength -> 2 Micrometer,
      IncompatibleMaterials -> {None},
      CellType -> Bacterial,
      BiosafetyLevel -> "BSL-2",
      MSDSRequired -> False,
      CultureAdhesion -> SolidMedia,
      PreferredSolidMedia -> Link[testSolidLBMedia],
      PreferredColonyHandlerHeadCassettes -> {
        Link[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"]],
        Link[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli"]],
        Link[Model[Part, ColonyHandlerHeadCassette, "24-pin picking head for E. coli"]]
      },
      FluorescentExcitationWavelength -> {
        {452 Nanometer, 505 Nanometer},
        {300 Nanometer, 505 Nanometer},
        Null
      },
      FluorescentEmissionWavelength -> {
        {490 Nanometer, 545 Nanometer},
        {300 Nanometer, 400 Nanometer},
        Null
      }
    ];

    (* Modify the output object because pour plate functionality is not currently implemented *)
    Upload[<|
      Object->testSolidLBMedia,
      Replace[CellTypes] -> {
        Link[testEColi,PreferredSolidMedia],
        Link[testEColiNoFluorescentWavelengths,PreferredSolidMedia],
        Link[testEColiHalfMatchFluorescentWavelengths,PreferredSolidMedia]
      },
      OrganismType -> Microbial,
      MSDSRequired -> False,
      State -> Solid,
      DeveloperObject -> True
    |>];

    (* Create a solid media with eColi test sample model *)
    {
      testEColiSampleModel,
      testEColiNoFluorescentWavelengthsSampleModel,
      testEColiHalfMatchFluorescentWavelengthsSampleModel,
      testGasSampleModel,
      testIncompatibleSampleModel
    } = UploadSampleModel[
      {
        functionName <> " test e.coli and LB agar sample Model " <> $SessionUUID,
        functionName <> " test e.coli no fluorescent wavelengths and LB agar sample Model " <> $SessionUUID,
        functionName <> " test e.coli half match fluorescent wavelengths and LB agar sample Model " <> $SessionUUID,
        functionName <> " test gas sample model " <> $SessionUUID,
        functionName <> " test incompatible sample model " <> $SessionUUID
      },
      Composition->{
        {
          {10000 Cell/Milliliter, testEColi},
          {100 VolumePercent, Model[Molecule, "Water"]},
          {(3 Gram)/(193 Milliliter), Model[Molecule, "Agarose"]}
        },
        {
          {10000 Cell/Milliliter, testEColiNoFluorescentWavelengths},
          {100 VolumePercent, Model[Molecule, "Water"]},
          {(3 Gram)/(193 Milliliter), Model[Molecule, "Agarose"]}
        },
        {
          {10000 Cell/Milliliter, testEColiHalfMatchFluorescentWavelengths},
          {100 VolumePercent, Model[Molecule, "Water"]},
          {(3 Gram)/(193 Milliliter), Model[Molecule, "Agarose"]}
        },
        {
          {100 VolumePercent, Model[Molecule, "Water"]}
        },
        {
          {100 VolumePercent, Model[Molecule, "Water"]}
        }
      },
      Expires->{True,True,True,False,False},
      ShelfLife -> {2 Week,2 Week,2 Week,Null,Null},
      UnsealedShelfLife -> {1 Hour, 1 Hour, 1 Hour, Null,Null},
      DefaultStorageCondition->{
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Ambient Storage"]],
        Link[Model[StorageCondition, "Ambient Storage"]]
      },
      State->Solid,
      BiosafetyLevel -> "BSL-1",
      Flammable -> False,
      MSDSRequired -> False,
      IncompatibleMaterials -> {
        {None},
        {None},
        {None},
        {None},
        {Nylon}
      },
      Living -> {True,True,True,False,False},
      CellType -> {Bacterial,Bacterial,Bacterial,Null,Null}
    ];

    (* set up test samples *)
    {
      eColiSample1,
      eColiSample2,
      eColiSample3,
      eColiSample4,
      eColiSample5,
      eColiSample6,
      sampleInDwp,
      liquidCultureSample,
      gasSample,
      testLBBrothSample,
      eColiSampleNoFluorescentWavelengths,
      eColiSampleHalfMatchFluorescentWavelengths,
      testIncompatibleSample
    }=UploadSample[
      {
        testEColiSampleModel,
        testEColiSampleModel,
        testEColiSampleModel,
        testEColiSampleModel,
        testEColiSampleModel,
        testEColiSampleModel,
        testEColiSampleModel,
        testEColiSampleModel,
        testGasSampleModel,
        Model[Sample, "Nutrient Broth"],
        testEColiNoFluorescentWavelengthsSampleModel,
        testEColiHalfMatchFluorescentWavelengthsSampleModel,
        testIncompatibleSampleModel
      },
      {
        {"A1", omniTray1},
        {"A1", omniTray2},
        {"A1", omniTray3},
        {"A1", omniTray4},
        {"A1", omniTray5},
        {"A1", omniTray6},
        {"A1", dwp1},
        {"A1", omniTray7},
        {"A1", omniTray8},
        {"A1", flask500mL},
        {"A1", omniTray9},
        {"A1", omniTray10},
        {"A1", omniTray11}
      },
      Name->Join[
        Table[
          functionName <> " test e.coli sample " <> ToString[i] <>" in omniTray " <> $SessionUUID,
          {i,1,6}
        ],
        {
          functionName <> " test e.coli sample 1 in dwp " <> $SessionUUID,
          functionName <> " test liquid e.coli culture 1 in omniTray " <> $SessionUUID,
          functionName <> " test gas sample 1 in omniTray " <> $SessionUUID,
          functionName <> " test LB Broth in 500 mL flask " <> $SessionUUID,
          functionName <> " test e.coli no fluorescent wavelengths sample 1 in omniTray" <> $SessionUUID,
          functionName <> " test e.coli half match fluorescent wavelengths sample 1 in omniTray" <> $SessionUUID,
          functionName <> " test incompatible input sample in omnitray " <> $SessionUUID
        }
      ],
      InitialAmount -> Join[
        ConstantArray[1 Gram, 8],
        {5 Milliliter},
        {400 Milliliter},
        {1 Gram},
        {1 Gram},
        {1 Gram}
      ]
    ];

    (* Do some final updates to the samples *)
    Upload[{
      (* Make the gaseous sample, gaseous *)
      <|Object -> gasSample, State -> Gas|>,
      (* Make the liquid culture, liquid *)
      <|Object -> liquidCultureSample, State -> Liquid|>
    }];

    (* Make sure all objects are developer objects *)
    developerObjectPackets = <|Object->#,DeveloperObject->True|>&/@{
      testEColi,
      testEColiNoFluorescentWavelengthsSampleModel,
      testEColiHalfMatchFluorescentWavelengthsSampleModel,
      testIncompatibleSampleModel,
      eColiSample1,
      eColiSample2,
      eColiSample3,
      eColiSample4,
      eColiSample5,
      sampleInDwp,
      liquidCultureSample,
      gasSample,
      testLBBrothSample,
      eColiSampleNoFluorescentWavelengths,
      eColiSampleHalfMatchFluorescentWavelengths,
      testIncompatibleSample
    };
    Upload[developerObjectPackets];
  ];
];