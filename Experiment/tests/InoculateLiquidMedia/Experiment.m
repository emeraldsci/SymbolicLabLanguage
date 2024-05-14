(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)
(* ::Subsection:: *)
(* ExperimentInoculateLiquidMedia *)
DefineTests[ExperimentInoculateLiquidMedia,
  {
    (* --- Basic --- *)

    Example[{Basic,"Generate a RoboticCellPreparation protocol from a single plate:"},
      ExperimentInoculateLiquidMedia[Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID]],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ],
    Example[{Basic,"Generate a RoboticCellPreparation protocol from 2 plates:"},
      ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
        }
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ],
    Example[{Basic,"Generate a RoboticCellPreparation protocol if Preparation -> Robotic and the sample is State -> Liquid:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        Preparation->Robotic
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ],
    Example[{Basic,"Generate an InoculateLiquidMedia protocol if Preparation -> Manual and the sample is State -> Liquid:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        Preparation->Manual
      ],
      ObjectP[Object[Protocol,InoculateLiquidMedia]]
    ],
    Example[{Basic,"Generate an InoculateLiquidMedia protocol if the source is an AgarStab:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID]
      ],
      ObjectP[Object[Protocol,InoculateLiquidMedia]]
    ],
    Example[{Basic,"Generate a RoboticCellPreparation protocol using a container as input:"},
      ExperimentInoculateLiquidMedia[Object[Container,Plate, "ExperimentInoculateLiquidMedia" <> " test omniTray 1 " <> $SessionUUID]],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ],

    (* Section: ---------------------------------------------------- Options ----------------------------------------------------------------------- *)

    (* Section: InoculationSource *)
    Example[{Options,InoculationSource,"InoculationSource is automatically set to SolidMedia if the state of the input sample is Solid and in a Plate:"},
      protocol = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID]
      ];
      protocol[OutputUnitOperations][[1]][InoculationSource],
      SolidMedia
    ],
    Example[{Options,InoculationSource,"InoculationSource is automatically set to LiquidMedia if the state of the input sample is Liquid:"},
      protocol = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID]
      ];
      Download[protocol,InoculationSource],
      LiquidMedia
    ],
    Example[{Options,InoculationSource,"InoculationSource is automatically set to AgarStab if the state of the input sample is Solid and in a Vessel:"},
      protocol = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID]
      ];
      Download[protocol,InoculationSource],
      AgarStab
    ],

    (* Section: Instrument *)

    Example[{Options,Instrument,"If InoculationSource is SolidMedia, Instrument is automatically set to Model[Instrument, ColonyHandler, \"id:mnk9jORxz0El\"]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output->Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"]] (* Model[Instrument, ColonyHandler, "QPix 420 HT"] *)
    ],

    Example[{Options,Instrument,"If InoculationSource is LiquidMedia and Preparation->Manual, Instrument is automatically set to a Model[Instrument,Pipette]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Output->Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "Eppendorf Research Plus P200, Microbial"]]
    ],

    Example[{Options,Instrument,"If InoculationSource is LiquidMedia and Preparation->Robotic, Instrument is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Preparation -> Robotic,
          Output->Options
        ],
        Instrument
      ],
      Null
    ],

    Example[{Options,Instrument,"If InoculationSource is AgarStab, Instrument is automatically set to a Model[Instrument,Pipette]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> AgarStab,
          Output->Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "id:GmzlKjP3boWe"]] (* Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Microbial"] *)
    ],

    Example[{Options,Instrument,"Specify an Object[Instrument,ColonyHandler] or Model[Instrument,ColonyHandler]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Instrument->Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"],
          Output->Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"]]
    ],

    Example[{Options,Instrument,"Specify a Model[Instrument,Pipette]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> AgarStab,
          Instrument -> Model[Instrument, Pipette, "id:1ZA60vL547EM"],
          Output->Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "id:1ZA60vL547EM"]] (* Model[Instrument, Pipette, "Eppendorf Research Plus P1000"] *)
    ],

    Example[{Options,Instrument,"Specify an Instrument for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 2 in cryoVial " <> $SessionUUID]
          },
          InoculationSource -> AgarStab,
          Instrument -> {
            Model[Instrument, Pipette, "id:1ZA60vL547EM"],(* Model[Instrument, Pipette, "Eppendorf Research Plus P1000"] *)
            Model[Instrument, Pipette, "id:01G6nvwRpbLd"] (* Model[Instrument, Pipette, "Eppendorf Research Plus P200"] *)
          },
          Output->Options
        ],
        Instrument
      ],
      {ObjectP[Model[Instrument, Pipette, "id:1ZA60vL547EM"]],ObjectP[Model[Instrument, Pipette, "id:01G6nvwRpbLd"]]}
    ],

    (* Section: TransferEnvironment *)

    Example[{Options,TransferEnvironment,"TransferEnvironment automatically resolves to Model[Instrument, BiosafetyCabinet, \"Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Microbial)\"] if InoculationSource is LiquidMedia and Preparation is Manual:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Preparation->Manual,
          Output->Options
        ],
        TransferEnvironment
      ],
      ObjectP[Model[Instrument, BiosafetyCabinet, "id:WNa4ZjKZpBeL"]] (* Model[Instrument, BiosafetyCabinet, "Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Microbial)"] *)
    ],

    Example[{Options,TransferEnvironment,"TransferEnvironemnt is Null if InoculationSource is SolidMedia:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output->Options
        ],
        TransferEnvironment
      ],
      Null
    ],
    Example[{Options,TransferEnvironment,"TransferEnvironemnt is Null if InoculationSource is LiquidMedia and Preparation is Robotic:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Preparation -> Robotic,
          Output->Options
        ],
        TransferEnvironment
      ],
      Null
    ],
    Example[{Options,TransferEnvironment,"TransferEnvironemnt is Model[Instrument, BiosafetyCabinet, \"Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Microbial)\"] if InoculationSource is AgarStab:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> AgarStab,
          Output->Options
        ],
        TransferEnvironment
      ],
      ObjectP[Model[Instrument, BiosafetyCabinet, "id:WNa4ZjKZpBeL"]] (* Model[Instrument, BiosafetyCabinet, "Thermo Scientific 1300 Series Class II,Type A2 Biosafety Cabinet (Microbial)"] *)
    ],

    (* Section: DestinationMediaContainer *)

    Example[{Options,DestinationMediaContainer,"If InoculationSource is Solid Media, specify a Model[Container] for a population to signify as many picked colonies of that population will be deposited into as many plates of that model that can fit on the deck:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> Diameter[],
          DestinationMediaContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
          Output->Options
        ],
        DestinationMediaContainer
      ],
      ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]
    ],

    Example[{Options,DestinationMediaContainer,"If InoculationSource is Solid Media, specify an Object[Container] for a population to signify as many picked colonies of that population that can fit will be deposited into that specific plate only:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> Diameter[],
          DestinationMediaContainer -> Object[Container,Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 7 " <> $SessionUUID],
          Output->Options
        ],
        DestinationMediaContainer
      ],
      {ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 7 " <> $SessionUUID]]}
    ],

    Example[{Options,DestinationMediaContainer,"If InoculationSource is Solid Media, specify multiple Object[Container]s for a population to signify as many picked colonies of that population that can fit will be deposited into those specific plates only:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> Diameter[],
          DestinationMediaContainer -> {{{
            Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 5 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 6 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 7 " <> $SessionUUID]
          }}},
          Output->Options
        ],
        DestinationMediaContainer
      ],
      {{{
        ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 5 " <> $SessionUUID]],
        ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 6 " <> $SessionUUID]],
        ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 7 " <> $SessionUUID]]
      }}}
    ],

    Example[{Options,DestinationMediaContainer,"If InoculationSource is Solid Media, specify destination media containers for each population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> {{
            Diameter[],
            Fluorescence[NumberOfColonies->10],
            Circularity[]
          }},
          DestinationMediaContainer -> {{
            Model[Container, Plate, "id:L8kPEjkmLbvW"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
            Model[Container, Plate, "id:L8kPEjkmLbvW"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
            {
              Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 5 " <> $SessionUUID],
              Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 6 " <> $SessionUUID],
              Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 7 " <> $SessionUUID]
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
          ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 5 " <> $SessionUUID]],
          ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 6 " <> $SessionUUID]],
          ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 7 " <> $SessionUUID]]
        }
      }}
    ],

    Example[{Options,DestinationMediaContainer,"If InoculationSource is Solid Media, specify destination media containers for each population when there are multiple input samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 3 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          Populations -> {
            {MultiFeatured[Features->{Fluorescence, Diameter},NumberOfColonies->10]},
            {Fluorescence[NumberOfColonies->10]},
            {MultiFeatured[Features->{Regularity, Circularity}]}
          },
          DestinationMediaContainer -> {
            Model[Container, Plate, "id:L8kPEjkmLbvW"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
            Model[Container, Plate, "id:L8kPEjkmLbvW"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
            {
              Object[Container,Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 5 " <> $SessionUUID],
              Object[Container,Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 6 " <> $SessionUUID]
            }
          },
          Output->Options
        ],
        DestinationMediaContainer
      ],
      {
        {ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]}, (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
        {ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]}, (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
        {{
          ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 5 " <> $SessionUUID]],
          ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 6 " <> $SessionUUID]]
        }}
      }
    ],

    Example[{Options,DestinationMediaContainer,"If InoculationSource is LiquidMedia, specify a container:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          DestinationMediaContainer -> Object[Container,Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 1 " <> $SessionUUID],
          Output->Options
        ],
        DestinationMediaContainer
      ],
      {ObjectP[Object[Container, Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 1 " <> $SessionUUID]]}
    ],

    Example[{Options,DestinationMediaContainer,"If InoculationSource is AgarStab, specify a container:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          DestinationMediaContainer -> Object[Container,Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 1 " <> $SessionUUID],
          Output->Options
        ],
        DestinationMediaContainer
      ],
      {ObjectP[Object[Container,Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 1 " <> $SessionUUID]]}
    ],

    Example[{Options,DestinationMediaContainer,"If InoculationSource is AgarStab, specify a container for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 2 in cryoVial " <> $SessionUUID]
          },
          InoculationSource->AgarStab,
          DestinationMediaContainer -> {
            {Object[Container, Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 1 " <> $SessionUUID]},
            {Object[Container, Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 2 " <> $SessionUUID]}
          },
          Output->Options
        ],
        DestinationMediaContainer
      ],
      {
        ObjectP[Object[Container,Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 1 " <> $SessionUUID]],
        ObjectP[Object[Container,Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 2 " <> $SessionUUID]]
      }
    ],

    Example[{Options,DestinationMediaContainer,"If InoculationSource is LiquidMedia, specify a container for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource->LiquidMedia,
          DestinationMediaContainer -> {
            Object[Container, Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 1 " <> $SessionUUID],
            Object[Container, Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 2 " <> $SessionUUID]
          },
          Output->Options
        ],
        DestinationMediaContainer
      ],
      {
        ObjectP[Object[Container, Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 1 " <> $SessionUUID]],
        ObjectP[Object[Container, Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 2 " <> $SessionUUID]]
      }
    ],

    (* Section: DestinationMix *)
    Example[{Options,DestinationMix,"DestinationMix automatically gets set to True:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output->Options
        ],
        DestinationMix
      ],
      True
    ],

    Example[{Options,DestinationMix,"Set DestinationMix for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource->LiquidMedia,
          DestinationMix->{True,False},
          Output->Options
        ],
        DestinationMix
      ],
      {True,False}
    ],

    Example[{Options,DestinationMix,"If InoculationSource is SolidMedia, set DestinationMix for each population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations ->{
            {Diameter[],Fluorescence[]},
            {Diameter[]}
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
    
    (* Section: DestinationMixType *) 
    
    Example[{Options,DestinationMixType,"If InoculationSource is LiquidMedia, DestinationMixType is automatically set to Pipette:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        DestinationMixType
      ],
      Pipette
    ],

    Example[{Options,DestinationMixType,"If InoculationSource is SolidMedia, DestinationMixType is automatically set to Shake:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        DestinationMixType
      ],
      Shake
    ],

    Example[{Options,DestinationMixType,"If InoculationSource is AgarStab, DestinationMixType is automatically set to Pipette:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        DestinationMixType
      ],
      Pipette
    ],

    Example[{Options,DestinationMixType,"Set DestinationMixType for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource->LiquidMedia,
          DestinationMixType->{Pipette,Swirl},
          Output->Options
        ],
        DestinationMixType
      ],
      {Pipette,Swirl}
    ],

    Example[{Options,DestinationMixType,"If InoculationSource is SolidMedia, set DestinationMixType for each population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations ->{
            {Diameter[],Fluorescence[NumberOfColonies->20]},
            {Diameter[]}
          },
          DestinationMixType->{
            {Shake,Shake},
            {Shake}
          },
          Output->Options
        ],
        DestinationMixType
      ],
      {
        {Shake,Shake},
        {Shake}
      }
    ],

    (* Section: DestinationNumberOfMixes *)
    Example[{Options,DestinationNumberOfMixes,"DestinationNumberOfMixes is automatically set to 10:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          Output->Options
        ],
        DestinationNumberOfMixes
      ],
      10
    ],

    Example[{Options,DestinationNumberOfMixes,"Set DestinationNumberOfMixes for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 2 in cryoVial " <> $SessionUUID]
          },
          InoculationSource->AgarStab,
          DestinationNumberOfMixes->{10,20},
          Output->Options
        ],
        DestinationNumberOfMixes
      ],
      {10,20}
    ],

    Example[{Options,DestinationNumberOfMixes,"If InoculationSource is SolidMedia, set DestinationNumberOfMixes for each population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations ->{
            {Diameter[],Fluorescence[NumberOfColonies->10]},
            {Diameter[]}
          },
          DestinationNumberOfMixes->{
            {3,20},
            {30}
          },
          Output->Options
        ],
        DestinationNumberOfMixes
      ],
      {
        {3,20},
        {30}
      }
    ],

    (* Section: DestinationMixVolume *)
    Example[{Options,DestinationMixVolume,"If InoculationSource->SolidMedia DestinationMixVolume is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        DestinationMixVolume
      ],
      Null
    ],

    Example[{Options,DestinationMixVolume,"If InoculationSource->LiquidMedia DestinationMixVolume is equal to or greater than 1 Microliter (minimum Transfer mix volume):"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        DestinationMixVolume
      ],
      GreaterEqualP[1 Microliter]
    ],

    (* TODO: this is probably not how we want to do this *)
    Example[{Options,DestinationMixVolume,"If InoculationSource->AgarStab DestinationMixVolume is automatically set to 1 Microliter:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        DestinationMixVolume
      ],
      1 Microliter
    ],

    (* Section: Populations *)
    Example[{Options,Populations,"If InoculationSource is LiquidMedia Populations is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        Populations
      ],
      Null
    ],

    Example[{Options,Populations,"If InoculationSource is AgarStab Populations is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        Populations
      ],
      Null
    ],

    Example[{Options,Populations,"If InoculationSource is SolidMedia use the Populations option to specify a single population that describes the colonies to pick:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> Diameter[],
          Output->Options
        ],
        Populations
      ],
      DiameterPrimitiveP
    ],

    Example[{Options,Populations,"If InoculationSource is SolidMedia use the select option to specify multiple populations per sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> {{
            Diameter[],
            Fluorescence[]
          }},
          Output->Options
        ],
        Populations
      ],
      {{DiameterPrimitiveP,FluorescencePrimitiveP}}
    ],

    Example[{Options,Populations,"If InoculationSource is SolidMedia use the select option to specify populations with multiple features:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations ->MultiFeatured[
            Features->{Diameter, Fluorescence}
          ],
          Output->Options
        ],
        Populations
      ],
      MultiFeaturedPrimitiveP
    ],

    Example[{Options,Populations,"If InoculationSource is SolidMedia use the Populations option to select a specific division of colonies when they are divided into more than 2 groups:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations ->MultiFeatured[
            Features->{Diameter, Fluorescence},
            NumberOfDivisions->{5, Null}
          ],
          Output->Options
        ],
        Populations
      ],
      MultiFeaturedPrimitiveP
    ],
    Example[{Options,Populations,"If InoculationSource is SolidMedia if the pick coordinates are already known, set Populations to CustomCoordinates and specify PickCoordinates:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations ->CustomCoordinates,
          PickCoordinates->ConstantArray[{0 Millimeter,0 Millimeter},30],
          Output->Options
        ],
        Populations
      ],
      CustomCoordinates
    ],

    Example[{Options,Populations,"If InoculationSource is SolidMedia if Populations ->Automatic, will resolve to a Fluorescence population based on the fields in the Model[Cell]'s of the input sample composition:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations ->Automatic,
          Output->Options
        ],
        Populations
      ],
      FluorescencePrimitiveP
    ],

    Example[{Options,Populations,"If InoculationSource is SolidMedia select a single population from multiple samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          Populations ->Diameter[],
          Output->Options
        ],
        Populations
      ],
      DiameterPrimitiveP
    ],

    Example[{Options,Populations,"If InoculationSource is SolidMedia select multiple populations per sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          Populations ->{
            {
              Diameter[]
            },
            {
              Diameter[],
              Fluorescence[NumberOfColonies->10]
            }
          },
          Output->Options
        ],
        Populations
      ],
      {{DiameterPrimitiveP},{DiameterPrimitiveP,FluorescencePrimitiveP}}
    ],

    Example[{Options,Populations,"If InoculationSource is SolidMedia select a single type of colony from the first plate and select known colony coordinates on a second plate:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          Populations ->{
            Diameter[],
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
    
    (* Section: ColonyPickingTool *)

    Example[{Options,ColonyPickingTool,"If InoculationSource is LiquidMedia ColonyPickingTool is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        ColonyPickingTool
      ],
      Null
    ],

    Example[{Options,ColonyPickingTool,"If InoculationSource is AgarStab ColonyPickingTool is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        ColonyPickingTool
      ],
      Null
    ],

    Example[{Options,ColonyPickingTool,"If InoculationSource is SolidMedia the ColonyPickingTool will automatically resolve to a PreferredColonyHandlerHeadCassette of a Model[Cell] in the composition of the input sample that also fits the DestinationMediaContainer:"},
      preferredHeads =
          (* Get the PreferredColonyHandlerHeadCassettes of the input sample *)
          Cases[Download[
            Flatten@Quiet[
              Download[
                Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
                Composition[[All, 2]][PreferredColonyHandlerHeadCassettes]
              ]
            ],
            Object
          ],
            ObjectP[]
          ];
      selectedHead = Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        ColonyPickingTool
      ];
      MemberQ[preferredHeads,selectedHead],
      True,
      Variables:>{preferredHeads,selectedHead}
    ],

    Example[{Options,ColonyPickingTool,"If InoculationSource is SolidMedia the ColonyPickingTool can be specified by Model[Part,ColonyHandlerHeadCassette] or Object[Part,ColonyHandlerHeadCassette]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          DestinationMediaContainer -> Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"],
          ColonyPickingTool->{Object[Part, ColonyHandlerHeadCassette, "id:bq9LA09Wkwav"],Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli"]},
          Output->Options
        ],
        ColonyPickingTool
      ],
      {ObjectP[Object[Part, ColonyHandlerHeadCassette, "id:bq9LA09Wkwav"]],ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli"]]}
    ],
    
    (* Section: HeadDiameter *)

    Example[{Options,HeadDiameter,"If InoculationSource is LiquidMedia HeadDiameter is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        HeadDiameter
      ],
      Null
    ],

    Example[{Options,HeadDiameter,"If InoculationSource is AgarStab HeadDiameter is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        HeadDiameter
      ],
      Null
    ],

    Example[{Options,HeadDiameter,"If InoculationSource is SolidMedia, only ColonyPickingTools with the specified HeadDiameter will be used:"},
      colonyPickingTool=Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
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

    (* Section: HeadLength *)

    Example[{Options,HeadLength,"If InoculationSource is LiquidMedia HeadLength is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        HeadLength
      ],
      Null
    ],

    Example[{Options,HeadLength,"If InoculationSource is AgarStab HeadLength is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        HeadLength
      ],
      Null
    ],

    Example[{Options,HeadLength,"If InoculationSource is SolidMedia, only ColonyPickingTools with the specified HeadLength will be used:"},
      colonyPickingTool=Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          HeadLength->19.4 Millimeter,
          Output->Options
        ],
        ColonyPickingTool
      ];
      Download[colonyPickingTool,HeadLength],
      RangeP[19.4  Millimeter],
      Variables:>{colonyPickingTool},
      Messages :> {}
    ],


    (* Section: NumberOfHeads *)

    Example[{Options,NumberOfHeads,"If InoculationSource is LiquidMedia NumberOfHeads is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        NumberOfHeads
      ],
      Null
    ],

    Example[{Options,NumberOfHeads,"If InoculationSource is AgarStab NumberOfHeads is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        NumberOfHeads
      ],
      Null
    ],

    Example[{Options,NumberOfHeads,"If InoculationSource is SolidMedia, only ColonyPickingTools with the specified NumberOfHeads will be used:"},
      colonyPickingTool=Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          NumberOfHeads->96,
          Output->Options
        ],
        ColonyPickingTool
      ];
      Download[colonyPickingTool,NumberOfHeads],
      96,
      Variables:>{colonyPickingTool}
    ],

    (* Section: ColonyHandlerHeadCassetteApplication *)

    Example[{Options,ColonyHandlerHeadCassetteApplication,"If InoculationSource is LiquidMedia ColonyHandlerHeadCassetteApplication is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        ColonyHandlerHeadCassetteApplication
      ],
      Null
    ],

    Example[{Options,ColonyHandlerHeadCassetteApplication,"If InoculationSource is AgarStab ColonyHandlerHeadCassetteApplication is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        ColonyHandlerHeadCassetteApplication
      ],
      Null
    ],

    Example[{Options,ColonyHandlerHeadCassetteApplication,"If InoculationSource is SolidMedia, only ColonyPickingTools with the specified ColonyHandlerHeadCassetteApplication will be used:"},
      colonyPickingTool=Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          ColonyHandlerHeadCassetteApplication->Pick,
          Output->Options
        ],
        ColonyPickingTool
      ];
      Download[colonyPickingTool,Application],
      Pick,
      Variables:>{colonyPickingTool}
    ],

    (* Section: ColonyPickingDepth *)
    Example[{Options,ColonyPickingDepth,"If InoculationSource is LiquidMedia ColonyPickingDepth is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        ColonyPickingDepth
      ],
      Null
    ],

    Example[{Options,ColonyPickingDepth,"If InoculationSource is AgarStab ColonyPickingDepth is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        ColonyPickingDepth
      ],
      Null
    ],

    Example[{Options,ColonyPickingDepth,"If InoculationSource is SolidMedia, the ColonyPickingDepth is automatically set to 2 Millimeter:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        ColonyPickingDepth
      ],
      2 Millimeter
    ],

    Example[{Options,ColonyPickingDepth,"If InoculationSource is SolidMedia, the ColonyPickingDepth can be specified for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          ColonyPickingDepth -> {2 Millimeter, 1.5 Millimeter},
          Output->Options
        ],
        ColonyPickingDepth
      ],
      {{2 Millimeter}, {1.5 Millimeter}}
    ],

    (* Section: ImagingChannels *)

    Example[{Options,ImagingChannels,"If InoculationSource is LiquidMedia ImagingChannels is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        ImagingChannels
      ],
      Null
    ],

    Example[{Options,ImagingChannels,"If InoculationSource is AgarStab ImagingChannels is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        ImagingChannels
      ],
      Null
    ],

    Example[{Options,ImagingChannels,"If InoculationSource is SolidMedia, imagingChannels automatically gets resolved to the imaging channels specified in Populations + Brightfield:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations ->MultiFeatured[
            Features->{Fluorescence,Fluorescence},
            NumberOfColonies->10,
            ExcitationWavelength->{457 Nanometer, 531 Nanometer},
            EmissionWavelength->{536 Nanometer, 593 Nanometer}
          ],
          Output->Options
        ],
        ImagingChannels
      ],
      {BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer}}
    ],

    Example[{Options,ImagingChannels,"If InoculationSource is SolidMedia, specify the ImagingChannels that are specified as Features in Populations:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> MultiFeatured[
            Features->{Fluorescence,Fluorescence},
            NumberOfColonies->10,
            ExcitationWavelength->{457 Nanometer, 531 Nanometer},
            EmissionWavelength->{536 Nanometer, 593 Nanometer}
          ],
          ImagingChannels->{BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer}},
          Output->Options
        ],
        ImagingChannels
      ],
      {BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer}}
    ],

    Example[{Options,ImagingChannels,"If InoculationSource is SolidMedia, specify additional ImagingChannels that are not specified as Features in Populations:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> MultiFeatured[
            Features->{Fluorescence,Fluorescence},
            NumberOfColonies->10,
            ExcitationWavelength->{457 Nanometer, 531 Nanometer},
            EmissionWavelength->{536 Nanometer, 593 Nanometer}
          ],
          ImagingChannels->{BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer},{531 Nanometer, 624 Nanometer}},
          Output->Options
        ],
        ImagingChannels
      ],
      {BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer},{531 Nanometer, 624 Nanometer}}
    ],

    (* Section: ExposureTimes *)
    Example[{Options,ExposureTimes,"If InoculationSource is LiquidMedia ExposureTimes is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        ExposureTimes
      ],
      Null
    ],

    Example[{Options,ExposureTimes,"If InoculationSource is AgarStab ExposureTimes is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        ExposureTimes
      ],
      Null
    ],

    Example[{Options,ExposureTimes,"If InoculationSource is SolidMedia, ExposureTimes automatically gets set to AutoExpose as they get optimized at RunTime:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations ->MultiFeatured[
            Features->{Fluorescence,Fluorescence},
            NumberOfColonies->10,
            ExcitationWavelength->{457 Nanometer, 531 Nanometer},
            EmissionWavelength->{536 Nanometer, 593 Nanometer}
          ],
          Output->Options
        ],
        ExposureTimes
      ],
      {AutoExpose,AutoExpose,AutoExpose}
    ],

    Example[{Options,ExposureTimes,"If InoculationSource is SolidMedia, control the ExposureTimes of Imaging Channels specified in Populations:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations ->MultiFeatured[
            Features->{Fluorescence,Fluorescence},
            NumberOfColonies->10,
            ExcitationWavelength->{457 Nanometer, 531 Nanometer},
            EmissionWavelength->{536 Nanometer, 593 Nanometer}
          ],
          ImagingChannels->{BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer}},
          ExposureTimes->{5 Millisecond,10 Millisecond,30 Millisecond},
          Output->Options
        ],
        ExposureTimes
      ],
      {5 Millisecond,10 Millisecond,30 Millisecond}
    ],
    
    (* Section: DestinationMedia *)

    Example[{Options,DestinationMedia,"If InoculationSource is LiquidMedia DestinationMedia is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        DestinationMedia
      ],
      Null
    ],

    Example[{Options,DestinationMedia,"If InoculationSource is AgarStab DestinationMedia is automatically set to the PreferredLiquidMedia of a Model[Cell] in the Composition of the input sample:"},
      destMedia=Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        DestinationMedia
      ];
      prefLiquidMedia = Cases[
        Download[
          Flatten@Quiet[
            Download[
              Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
              Composition[[All, 2]][PreferredLiquidMedia]
            ]
          ],
          Object
        ],
        ObjectP[]
      ];
      MemberQ[prefLiquidMedia,destMedia],
      True,
      Variables :> {destMedia,prefLiquidMedia}
    ],

    Example[{Options,DestinationMedia,"If InoculationSource is SolidMedia, DestinationMedia will automatically resolve to a PreferredLiquidMedia or PreferredSolidMedia of a Model[Cell] in the composition in the input sample:"},
      prefLiquidMedia = Cases[Download[
        Flatten@Quiet[
          Download[
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
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
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Composition[[All, 2]][PreferredSolidMedia]
          ]
        ],
        Object
      ],
        ObjectP[]
      ];
      resolvedDestMedia = Download[Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        DestinationMedia
      ],Object];
      MemberQ[Flatten[{prefLiquidMedia,prefSolidMedia}],resolvedDestMedia],
      True,
      Variables :> {prefLiquidMedia,prefSolidMedia,resolvedDestMedia}
    ],

    Example[{Options,DestinationMedia,"If InoculationSource is SolidMedia, DestinationMedia can be specified as an Object[Sample]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          DestinationMedia -> Object[Sample, "ExperimentInoculateLiquidMedia" <> " test LB Broth in 500 mL flask " <> $SessionUUID],
          Output->Options
        ],
        DestinationMedia
      ],
      ObjectP[Object[Sample, "ExperimentInoculateLiquidMedia" <> " test LB Broth in 500 mL flask " <> $SessionUUID]]
    ],

    Example[{Options,DestinationMedia,"If InoculationSource is SolidMedia, DestinationMedia can be specified as an Model[Sample]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          DestinationMedia -> Object[Sample, "ExperimentInoculateLiquidMedia" <> " test LB Broth in 4L amber glass flask " <> $SessionUUID],
          Output->Options
        ],
        DestinationMedia
      ],
      ObjectP[Object[Sample, "ExperimentInoculateLiquidMedia" <> " test LB Broth in 4L amber glass flask " <> $SessionUUID]]
    ],
    
    (* Section: DestinationFillDirection *)
    Example[{Options,DestinationFillDirection,"If InoculationSource is LiquidMedia DestinationFillDirection is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        DestinationFillDirection
      ],
      Null
    ],

    Example[{Options,DestinationFillDirection,"If InoculationSource is AgarStab DestinationFillDirection is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        DestinationFillDirection
      ],
      Null
    ],

    Example[{Options,DestinationFillDirection,"If InoculationSource is SolidMedia, if DestinationFillDirection->Automatic, it will resolve to filling the destination container by Rows:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        DestinationFillDirection
      ],
      Row
    ],

    Example[{Options,DestinationFillDirection,"If InoculationSource is SolidMedia, set the DestinationFillDirection to fill the destination in row order:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          DestinationFillDirection->Row,
          Output->Options
        ],
        DestinationFillDirection
      ],
      Row
    ],

    Example[{Options,DestinationFillDirection,"If InoculationSource is SolidMedia, set the DestinationFillDirection to fill the destination in column order:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          DestinationFillDirection->Column,
          Output->Options
        ],
        DestinationFillDirection
      ],
      Column
    ],
    
    (* Section: MaxDestinationNumberOfColumns *)
    Example[{Options,MaxDestinationNumberOfColumns,"If InoculationSource is LiquidMedia MaxDestinationNumberOfColumns is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        MaxDestinationNumberOfColumns
      ],
      Null
    ],

    Example[{Options,MaxDestinationNumberOfColumns,"If InoculationSource is AgarStab MaxDestinationNumberOfColumns is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        MaxDestinationNumberOfColumns
      ],
      Null
    ],

    Example[{Options,MaxDestinationNumberOfColumns,"If InoculationSource is SolidMedia, MaxDestinationNumberOfColumns is left as Automatic because the optimal number of columns is determined once the number of colonies to pick is known:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        MaxDestinationNumberOfColumns
      ],
      Automatic
    ],

    Example[{Options,MaxDestinationNumberOfColumns,"If InoculationSource is SolidMedia, use MaxDestinationNumberOfColumns to limit the number of columns of deposited colonies to 8:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          MaxDestinationNumberOfColumns->8,
          Output->Options
        ],
        MaxDestinationNumberOfColumns
      ],
      8
    ],

    Example[{Options,MaxDestinationNumberOfColumns,"If InoculationSource is SolidMedia, use MaxDestinationNumberOfColumns to limit the number of columns of deposited colonies for each population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          Populations ->{
            {Diameter[]},
            {Diameter[],Fluorescence[NumberOfColonies->10]}
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

    (* Section: MaxDestinationNumberOfRows *)
    Example[{Options,MaxDestinationNumberOfRows,"If InoculationSource is LiquidMedia MaxDestinationNumberOfRows is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        MaxDestinationNumberOfRows
      ],
      Null
    ],

    Example[{Options,MaxDestinationNumberOfRows,"If InoculationSource is AgarStab MaxDestinationNumberOfRows is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        MaxDestinationNumberOfRows
      ],
      Null
    ],

    Example[{Options,MaxDestinationNumberOfRows,"If InoculationSource is SolidMedia, MaxDestinationNumberOfRows is left as Automatic because the optimal number of Rows is determined once the number of colonies to pick is known:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        MaxDestinationNumberOfRows
      ],
      Automatic
    ],

    Example[{Options,MaxDestinationNumberOfRows,"If InoculationSource is SolidMedia, use MaxDestinationNumberOfRows to limit the number of Rows of deposited colonies to 8:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          MaxDestinationNumberOfRows->8,
          Output->Options
        ],
        MaxDestinationNumberOfRows
      ],
      8
    ],

    Example[{Options,MaxDestinationNumberOfRows,"If InoculationSource is SolidMedia, use MaxDestinationNumberOfRows to limit the number of Rows of deposited colonies for each population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          Populations ->{
            {Diameter[]},
            {Diameter[],Fluorescence[NumberOfColonies->10]}
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

    (* Section: MediaVolume *)
    Example[{Options,MediaVolume,"If InoculationSource is LiquidMedia MediaVolume is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        MediaVolume
      ],
      Null
    ],

    Example[{Options,MediaVolume,"If InoculationSource is AgarStab, MediaVolume will resolve to the recommended fill volume or 40% of the MaxVolume of the DestinationMediaContainer:"},
      {mediaVolume,destinationMediaContainer}=Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        {MediaVolume,DestinationMediaContainer}
      ];
      mediaVolume,
      Download[destinationMediaContainer,MaxVolume]*0.4,
      Variables :> {mediaVolume,destinationMediaContainer}
    ],

    Example[{Options,MediaVolume,"If InoculationSource is SolidMedia, MediaVolume will resolve to the recommended fill volume or 40% of the MaxVolume of the DestinationMediaContainer:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          DestinationMediaContainer-> Object[Container,Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 3 " <> $SessionUUID],
          Output->Options
        ],
        MediaVolume
      ],
      RangeP[$MaxRoboticSingleTransferVolume]
    ],


    Example[{Options,MediaVolume,"If InoculationSource is SolidMedia, use MediaVolume to specify the amount of liquid media in which to deposit picked colonies:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          MediaVolume->1 Milliliter,
          Output->Options
        ],
        MediaVolume
      ],
      RangeP[1 Milliliter]
    ],

    Example[{Options,MediaVolume,"If InoculationSource is SolidMedia, specify MediaVolume for each population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          Populations ->{
            {Diameter[],Fluorescence[NumberOfColonies->10]},
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
    
    (* Section: PrimaryWash *)

    Example[{Options,PrimaryWash,"If InoculationSource is LiquidMedia PrimaryWash is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        PrimaryWash
      ],
      Null
    ],

    Example[{Options,PrimaryWash,"If InoculationSource is AgarStab PrimaryWash is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        PrimaryWash
      ],
      Null
    ],

    Example[{Options,PrimaryWash,"If InoculationSource is SolidMedia, PrimaryWash will default to True if not specified:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        PrimaryWash
      ],
      True
    ],

    Example[{Options,PrimaryWash,"If InoculationSource is SolidMedia, setting PrimaryWash to False will turn off the other PrimaryWash options:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          PrimaryWash->False,
          Output->Options
        ],
        {PrimaryWash,PrimaryWashSolution,NumberOfPrimaryWashes,PrimaryDryTime}
      ],
      {False,Null,Null,Null}
    ],

    Example[{Options,PrimaryWash,"If InoculationSource is SolidMedia, have different PrimaryWash specifications for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          PrimaryWash->{True,False},
          Output->Options
        ],
        PrimaryWash
      ],
      {True,False}
    ],
    
    (* Section: PrimaryWashSolution *)
    Example[{Options,PrimaryWashSolution,"If InoculationSource is LiquidMedia PrimaryWashSolution is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        PrimaryWashSolution
      ],
      Null
    ],

    Example[{Options,PrimaryWashSolution,"If InoculationSource is AgarStab PrimaryWashSolution is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        PrimaryWashSolution
      ],
      Null
    ],

    Example[{Options,PrimaryWashSolution,"If InoculationSource is SolidMedia, the PrimaryWashSolution will automatically be set to Model[Sample,StockSolution,\"70% Ethanol\"]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        PrimaryWashSolution
      ],
      ObjectP[Model[Sample,StockSolution,"70% Ethanol"]]
    ],

    Example[{Options,PrimaryWashSolution,"If InoculationSource is SolidMedia, the PrimaryWashSolution will automatically be set to Null if PrimaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          PrimaryWash->False,
          Output->Options
        ],
        PrimaryWashSolution
      ],
      Null
    ],

    Example[{Options,PrimaryWashSolution,"If InoculationSource is SolidMedia, have different PrimaryWashSolutions for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          PrimaryWashSolution->{Model[Sample,StockSolution,"70% Ethanol"],Model[Sample, "Milli-Q water"]},
          Output->Options
        ],
        PrimaryWashSolution
      ],
      {ObjectP[Model[Sample,StockSolution,"70% Ethanol"]],ObjectP[Model[Sample, "Milli-Q water"]]}
    ],
    
    (* Section: NumberOfPrimaryWashes *)
    Example[{Options,NumberOfPrimaryWashes,"If InoculationSource is LiquidMedia NumberOfPrimaryWashes is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        NumberOfPrimaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfPrimaryWashes,"If InoculationSource is AgarStab NumberOfPrimaryWashes is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        NumberOfPrimaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfPrimaryWashes,"If InoculationSource is SolidMedia, NumberOfPrimaryWashes will automatically be set to 5:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        NumberOfPrimaryWashes
      ],
      5
    ],

    Example[{Options,NumberOfPrimaryWashes,"If InoculationSource is SolidMedia, the NumberOfPrimaryWashes will automatically be set to Null if PrimaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          PrimaryWash->False,
          Output->Options
        ],
        NumberOfPrimaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfPrimaryWashes,"If InoculationSource is SolidMedia, have different NumberOfPrimaryWashes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          NumberOfPrimaryWashes->{8,10},
          Output->Options
        ],
        NumberOfPrimaryWashes
      ],
      {8,10}
    ],
    
    (* Section: PrimaryDryTime *)
    Example[{Options,PrimaryDryTime,"If InoculationSource is LiquidMedia PrimaryDryTime is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        PrimaryDryTime
      ],
      Null
    ],

    Example[{Options,PrimaryDryTime,"If InoculationSource is AgarStab PrimaryDryTime is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        PrimaryDryTime
      ],
      Null
    ],

    Example[{Options,PrimaryDryTime,"If InoculationSource is SolidMedia, PrimaryDryTime will automatically be set to 10 Seconds:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        PrimaryDryTime
      ],
      10 Second
    ],

    Example[{Options,PrimaryDryTime,"If InoculationSource is SolidMedia, the PrimaryDryTime will automatically be set to Null if PrimaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          PrimaryWash->False,
          Output->Options
        ],
        PrimaryDryTime
      ],
      Null
    ],

    Example[{Options,PrimaryDryTime,"If InoculationSource is SolidMedia, have different PrimaryDryTimes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          PrimaryDryTime->{8 Second,30 Second},
          Output->Options
        ],
        PrimaryDryTime
      ],
      {8 Second,30 Second}
    ],

    (* Section: SecondaryWash *)

    Example[{Options,SecondaryWash,"If InoculationSource is LiquidMedia SecondaryWash is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        SecondaryWash
      ],
      Null
    ],

    Example[{Options,SecondaryWash,"If InoculationSource is AgarStab SecondaryWash is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        SecondaryWash
      ],
      Null
    ],

    Example[{Options,SecondaryWash,"If InoculationSource is SolidMedia, SecondaryWash will default to True if not specified:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        SecondaryWash
      ],
      True
    ],

    Example[{Options,SecondaryWash,"If InoculationSource is SolidMedia, setting SecondaryWash to False will turn off the other SecondaryWash options:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          SecondaryWash->False,
          Output->Options
        ],
        {SecondaryWash,SecondaryWashSolution,NumberOfSecondaryWashes,SecondaryDryTime}
      ],
      {False,Null,Null,Null}
    ],

    Example[{Options,SecondaryWash,"If InoculationSource is SolidMedia, have different SecondaryWash specifications for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          SecondaryWash->{True,False},
          Output->Options
        ],
        SecondaryWash
      ],
      {True,False}
    ],

    (* Section: SecondaryWashSolution *)
    Example[{Options,SecondaryWashSolution,"If InoculationSource is LiquidMedia SecondaryWashSolution is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        SecondaryWashSolution
      ],
      Null
    ],

    Example[{Options,SecondaryWashSolution,"If InoculationSource is AgarStab SecondaryWashSolution is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        SecondaryWashSolution
      ],
      Null
    ],

    Example[{Options,SecondaryWashSolution,"If InoculationSource is SolidMedia, the SecondaryWashSolution will automatically be set to Model[Sample,StockSolution,\"70% Ethanol\"]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        SecondaryWashSolution
      ],
      ObjectP[Model[Sample, "Milli-Q water"]]
    ],

    Example[{Options,SecondaryWashSolution,"If InoculationSource is SolidMedia, the SecondaryWashSolution will automatically be set to Null if SecondaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          SecondaryWash->False,
          Output->Options
        ],
        SecondaryWashSolution
      ],
      Null
    ],

    Example[{Options,SecondaryWashSolution,"If InoculationSource is SolidMedia, have different SecondaryWashSolutions for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          SecondaryWashSolution->{Model[Sample,StockSolution,"70% Ethanol"],Model[Sample, "Milli-Q water"]},
          Output->Options
        ],
        SecondaryWashSolution
      ],
      {ObjectP[Model[Sample,StockSolution,"70% Ethanol"]],ObjectP[Model[Sample, "Milli-Q water"]]}
    ],

    (* Section: NumberOfSecondaryWashes *)
    Example[{Options,NumberOfSecondaryWashes,"If InoculationSource is LiquidMedia NumberOfSecondaryWashes is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        NumberOfSecondaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfSecondaryWashes,"If InoculationSource is AgarStab NumberOfSecondaryWashes is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        NumberOfSecondaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfSecondaryWashes,"If InoculationSource is SolidMedia, NumberOfSecondaryWashes will automatically be set to 5:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        NumberOfSecondaryWashes
      ],
      5
    ],

    Example[{Options,NumberOfSecondaryWashes,"If InoculationSource is SolidMedia, the NumberOfSecondaryWashes will automatically be set to Null if SecondaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          SecondaryWash->False,
          Output->Options
        ],
        NumberOfSecondaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfSecondaryWashes,"If InoculationSource is SolidMedia, have different NumberOfSecondaryWashes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          NumberOfSecondaryWashes->{8,10},
          Output->Options
        ],
        NumberOfSecondaryWashes
      ],
      {8,10}
    ],

    (* Section: SecondaryDryTime *)
    Example[{Options,SecondaryDryTime,"If InoculationSource is LiquidMedia SecondaryDryTime is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        SecondaryDryTime
      ],
      Null
    ],

    Example[{Options,SecondaryDryTime,"If InoculationSource is AgarStab SecondaryDryTime is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        SecondaryDryTime
      ],
      Null
    ],

    Example[{Options,SecondaryDryTime,"If InoculationSource is SolidMedia, SecondaryDryTime will automatically be set to 10 Seconds:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        SecondaryDryTime
      ],
      10 Second
    ],

    Example[{Options,SecondaryDryTime,"If InoculationSource is SolidMedia, the SecondaryDryTime will automatically be set to Null if SecondaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          SecondaryWash->False,
          Output->Options
        ],
        SecondaryDryTime
      ],
      Null
    ],

    Example[{Options,SecondaryDryTime,"If InoculationSource is SolidMedia, have different SecondaryDryTimes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          SecondaryDryTime->{8 Second,30 Second},
          Output->Options
        ],
        SecondaryDryTime
      ],
      {8 Second,30 Second}
    ],

    (* Section: TertiaryWash *)

    Example[{Options,TertiaryWash,"If InoculationSource is LiquidMedia TertiaryWash is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        TertiaryWash
      ],
      Null
    ],

    Example[{Options,TertiaryWash,"If InoculationSource is AgarStab TertiaryWash is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        TertiaryWash
      ],
      Null
    ],

    Example[{Options,TertiaryWash,"If InoculationSource is SolidMedia, TertiaryWash will default to True if not specified:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        TertiaryWash
      ],
      True
    ],

    Example[{Options,TertiaryWash,"If InoculationSource is SolidMedia, setting TertiaryWash to False will turn off the other TertiaryWash options:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          TertiaryWash->False,
          Output->Options
        ],
        {TertiaryWash,TertiaryWashSolution,NumberOfTertiaryWashes,TertiaryDryTime}
      ],
      {False,Null,Null,Null}
    ],

    Example[{Options,TertiaryWash,"If InoculationSource is SolidMedia, have different TertiaryWash specifications for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          TertiaryWash->{True,False},
          Output->Options
        ],
        TertiaryWash
      ],
      {True,False}
    ],

    (* Section: TertiaryWashSolution *)
    Example[{Options,TertiaryWashSolution,"If InoculationSource is LiquidMedia TertiaryWashSolution is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        TertiaryWashSolution
      ],
      Null
    ],

    Example[{Options,TertiaryWashSolution,"If InoculationSource is AgarStab TertiaryWashSolution is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        TertiaryWashSolution
      ],
      Null
    ],

    Example[{Options,TertiaryWashSolution,"If InoculationSource is SolidMedia, the TertiaryWashSolution will automatically be set to Model[Sample, StockSolution, \"10% Bleach\"]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        TertiaryWashSolution
      ],
      ObjectP[Model[Sample, StockSolution, "10% Bleach"]]
    ],

    Example[{Options,TertiaryWashSolution,"If InoculationSource is SolidMedia, the TertiaryWashSolution will automatically be set to Null if TertiaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          TertiaryWash->False,
          Output->Options
        ],
        TertiaryWashSolution
      ],
      Null
    ],

    Example[{Options,TertiaryWashSolution,"If InoculationSource is SolidMedia, have different TertiaryWashSolutions for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          TertiaryWashSolution->{Model[Sample,StockSolution,"70% Ethanol"],Model[Sample, "Milli-Q water"]},
          Output->Options
        ],
        TertiaryWashSolution
      ],
      {ObjectP[Model[Sample,StockSolution,"70% Ethanol"]],ObjectP[Model[Sample, "Milli-Q water"]]}
    ],

    (* Section: NumberOfTertiaryWashes *)
    Example[{Options,NumberOfTertiaryWashes,"If InoculationSource is LiquidMedia NumberOfTertiaryWashes is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        NumberOfTertiaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfTertiaryWashes,"If InoculationSource is AgarStab NumberOfTertiaryWashes is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        NumberOfTertiaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfTertiaryWashes,"If InoculationSource is SolidMedia, NumberOfTertiaryWashes will automatically be set to 5:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        NumberOfTertiaryWashes
      ],
      5
    ],

    Example[{Options,NumberOfTertiaryWashes,"If InoculationSource is SolidMedia, the NumberOfTertiaryWashes will automatically be set to Null if TertiaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          TertiaryWash->False,
          Output->Options
        ],
        NumberOfTertiaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfTertiaryWashes,"If InoculationSource is SolidMedia, have different NumberOfTertiaryWashes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          NumberOfTertiaryWashes->{8,10},
          Output->Options
        ],
        NumberOfTertiaryWashes
      ],
      {8,10}
    ],

    (* Section: TertiaryDryTime *)
    Example[{Options,TertiaryDryTime,"If InoculationSource is LiquidMedia TertiaryDryTime is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        TertiaryDryTime
      ],
      Null
    ],

    Example[{Options,TertiaryDryTime,"If InoculationSource is AgarStab TertiaryDryTime is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        TertiaryDryTime
      ],
      Null
    ],

    Example[{Options,TertiaryDryTime,"If InoculationSource is SolidMedia, TertiaryDryTime will automatically be set to 10 Seconds:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        TertiaryDryTime
      ],
      10 Second
    ],

    Example[{Options,TertiaryDryTime,"If InoculationSource is SolidMedia, the TertiaryDryTime will automatically be set to Null if TertiaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          TertiaryWash->False,
          Output->Options
        ],
        TertiaryDryTime
      ],
      Null
    ],

    Example[{Options,TertiaryDryTime,"If InoculationSource is SolidMedia, have different TertiaryDryTimes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          TertiaryDryTime->{8 Second,30 Second},
          Output->Options
        ],
        TertiaryDryTime
      ],
      {8 Second,30 Second}
    ],
    
    (* Section: QuaternaryWash *)
    Example[{Options,QuaternaryWash,"If InoculationSource is LiquidMedia QuaternaryWash is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        QuaternaryWash
      ],
      Null
    ],

    Example[{Options,QuaternaryWash,"If InoculationSource is AgarStab QuaternaryWash is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        QuaternaryWash
      ],
      Null
    ],

    Example[{Options,QuaternaryWash,"If InoculationSource is SolidMedia, QuaternaryWash will default to False if not specified:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        QuaternaryWash
      ],
      False
    ],

    Example[{Options,QuaternaryWash,"If InoculationSource is SolidMedia, setting QuaternaryWash to False will turn off the other QuaternaryWash options:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          QuaternaryWash->False,
          Output->Options
        ],
        {QuaternaryWash,QuaternaryWashSolution,NumberOfQuaternaryWashes,QuaternaryDryTime}
      ],
      {False,Null,Null,Null}
    ],

    Example[{Options,QuaternaryWash,"If InoculationSource is SolidMedia, have different QuaternaryWash specifications for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          QuaternaryWash->{True,False},
          Output->Options
        ],
        QuaternaryWash
      ],
      {True,False}
    ],
    
    (* Section: QuaternaryWashSolution *)
    Example[{Options,QuaternaryWashSolution,"If InoculationSource is LiquidMedia QuaternaryWashSolution is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        QuaternaryWashSolution
      ],
      Null
    ],

    Example[{Options,QuaternaryWashSolution,"If InoculationSource is AgarStab QuaternaryWashSolution is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        QuaternaryWashSolution
      ],
      Null
    ],

    Example[{Options,QuaternaryWashSolution,"If InoculationSource is SolidMedia, the QuaternaryWashSolution will automatically be set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        QuaternaryWashSolution
      ],
      Null
    ],

    Example[{Options,QuaternaryWashSolution,"If InoculationSource is SolidMedia, the QuaternaryWashSolution will automatically be set to Model[Sample,StockSolution,\"70% Ethanol\"] if QuaternaryWash is True:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          QuaternaryWash->True,
          Output->Options
        ],
        QuaternaryWashSolution
      ],
      ObjectP[Model[Sample,StockSolution,"70% Ethanol"]]
    ],


    Example[{Options,QuaternaryWashSolution,"If InoculationSource is SolidMedia, have different QuaternaryWashSolutions for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          QuaternaryWashSolution->{Model[Sample,StockSolution,"70% Ethanol"],Model[Sample, "Milli-Q water"]},
          Output->Options
        ],
        QuaternaryWashSolution
      ],
      {ObjectP[Model[Sample,StockSolution,"70% Ethanol"]],ObjectP[Model[Sample, "Milli-Q water"]]}
    ],
    
    (* Section: NumberOfQuaternaryWashes *)
    Example[{Options,NumberOfQuaternaryWashes,"If InoculationSource is LiquidMedia NumberOfQuaternaryWashes is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        NumberOfQuaternaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfQuaternaryWashes,"If InoculationSource is AgarStab NumberOfQuaternaryWashes is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        NumberOfQuaternaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfQuaternaryWashes,"If InoculationSource is SolidMedia, numberOfQuaternaryWashes will automatically be set to 5, if QuaternaryWash is True:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          QuaternaryWash->True,
          Output->Options
        ],
        NumberOfQuaternaryWashes
      ],
      5
    ],

    Example[{Options,NumberOfQuaternaryWashes,"If InoculationSource is SolidMedia, the NumberOfQuaternaryWashes will automatically be set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          QuaternaryWash->False,
          Output->Options
        ],
        NumberOfQuaternaryWashes
      ],
      Null
    ],

    Example[{Options,NumberOfQuaternaryWashes,"If InoculationSource is SolidMedia, have different NumberOfQuaternaryWashes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          NumberOfQuaternaryWashes->{8,10},
          Output->Options
        ],
        NumberOfQuaternaryWashes
      ],
      {8,10}
    ],

    (* Section: QuaternaryDryTime *)
    Example[{Options,QuaternaryDryTime,"If InoculationSource is LiquidMedia QuaternaryDryTime is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        QuaternaryDryTime
      ],
      Null
    ],

    Example[{Options,QuaternaryDryTime,"If InoculationSource is AgarStab QuaternaryDryTime is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        QuaternaryDryTime
      ],
      Null
    ],

    Example[{Options,QuaternaryDryTime,"If InoculationSource is SolidMedia, QuaternaryDryTime will automatically be set to 10 Seconds if QuaternaryWash is True:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          QuaternaryWash->True,
          Output->Options
        ],
        QuaternaryDryTime
      ],
      10 Second
    ],

    Example[{Options,QuaternaryDryTime,"If InoculationSource is SolidMedia, the QuaternaryDryTime will automatically be set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          QuaternaryWash->False,
          Output->Options
        ],
        QuaternaryDryTime
      ],
      Null
    ],

    Example[{Options,QuaternaryDryTime,"If InoculationSource is SolidMedia, have different QuaternaryDryTimes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          QuaternaryDryTime->{8 Second,30 Second},
          Output->Options
        ],
        QuaternaryDryTime
      ],
      {8 Second,30 Second}
    ],

    (* Section: MinRegularityRatio *)
    Example[{Options,MinRegularityRatio,"If InoculationSource is LiquidMedia MinRegularityRatio is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        MinRegularityRatio
      ],
      Null
    ],

    Example[{Options,MinRegularityRatio,"If InoculationSource is AgarStab MinRegularityRatio is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        MinRegularityRatio
      ],
      Null
    ],

    Example[{Options,MinRegularityRatio,"If InoculationSource is SolidMedia, MinRegularityRatio is automatically set to 0.65:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        MinRegularityRatio
      ],
      0.65
    ],

    Example[{Options,MinRegularityRatio,"If InoculationSource is SolidMedia, set MinRegularityRatio for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          MinRegularityRatio->{0.4,0.8},
          Output->Options
        ],
        MinRegularityRatio
      ],
      {0.4,0.8}
    ],
    
    (* Section: MaxRegularityRatio *)
    Example[{Options,MaxRegularityRatio,"If InoculationSource is LiquidMedia MaxRegularityRatio is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        MaxRegularityRatio
      ],
      Null
    ],

    Example[{Options,MaxRegularityRatio,"If InoculationSource is AgarStab MaxRegularityRatio is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        MaxRegularityRatio
      ],
      Null
    ],

    Example[{Options,MaxRegularityRatio,"If InoculationSource is SolidMedia, MaxRegularityRatio is automatically set to 1:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        MaxRegularityRatio
      ],
      RangeP[1]
    ],

    Example[{Options,MaxRegularityRatio,"If InoculationSource is SolidMedia, set MaxRegularityRatio for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          MaxRegularityRatio->{0.8,0.9},
          Output->Options
        ],
        MaxRegularityRatio
      ],
      {0.8,0.9}
    ],

    (* Section: MinCircularityRatio *)
    Example[{Options,MinCircularityRatio,"If InoculationSource is LiquidMedia MinCircularityRatio is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        MinCircularityRatio
      ],
      Null
    ],

    Example[{Options,MinCircularityRatio,"If InoculationSource is AgarStab MinCircularityRatio is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        MinCircularityRatio
      ],
      Null
    ],

    Example[{Options,MinCircularityRatio,"If InoculationSource is SolidMedia, MinCircularityRatio is automatically set to 0.65:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        MinCircularityRatio
      ],
      0.65
    ],

    Example[{Options,MinCircularityRatio,"If InoculationSource is SolidMedia, set MinCircularityRatio for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          MinCircularityRatio->{0.4,0.8},
          Output->Options
        ],
        MinCircularityRatio
      ],
      {0.4,0.8}
    ],
    
    (* Section: MaxCircularityRatio *)
    Example[{Options,MaxCircularityRatio,"If InoculationSource is LiquidMedia MaxCircularityRatio is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        MaxCircularityRatio
      ],
      Null
    ],

    Example[{Options,MaxCircularityRatio,"If InoculationSource is AgarStab MaxCircularityRatio is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        MaxCircularityRatio
      ],
      Null
    ],

    Example[{Options,MaxCircularityRatio,"If InoculationSource is SolidMedia, MaxCircularityRatio is automatically set to 1:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        MaxCircularityRatio
      ],
      RangeP[1]
    ],

    Example[{Options,MaxCircularityRatio,"If InoculationSource is SolidMedia, set MaxCircularityRatio for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          MaxCircularityRatio->{0.8,0.9},
          Output->Options
        ],
        MaxCircularityRatio
      ],
      {0.8,0.9}
    ],
    
    (* Section: MinDiameter *)
    Example[{Options,MinDiameter,"If InoculationSource is LiquidMedia MinDiameter is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        MinDiameter
      ],
      Null
    ],

    Example[{Options,MinDiameter,"If InoculationSource is AgarStab MinDiameter is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        MinDiameter
      ],
      Null
    ],

    Example[{Options,MinDiameter,"If InoculationSource is SolidMedia, MinDiameter is automatically set to 0.5 Millimeter:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        MinDiameter
      ],
      0.5 Millimeter
    ],

    Example[{Options,MinDiameter,"If InoculationSource is SolidMedia, set MinDiameter for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          MinDiameter->{0.4 Millimeter,0.8 Millimeter},
          Output->Options
        ],
        MinDiameter
      ],
      {0.4 Millimeter,0.8 Millimeter}
    ],
    
    (* Section: MaxDiameter *)
    Example[{Options,MaxDiameter,"If InoculationSource is LiquidMedia MaxDiameter is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        MaxDiameter
      ],
      Null
    ],

    Example[{Options,MaxDiameter,"If InoculationSource is AgarStab MaxDiameter is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        MaxDiameter
      ],
      Null
    ],

    Example[{Options,MaxDiameter,"If InoculationSource is SolidMedia, MaxDiameter is automatically set to 2 Millimeter:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        MaxDiameter
      ],
      RangeP[2 Millimeter]
    ],

    Example[{Options,MaxDiameter,"If InoculationSource is SolidMedia, set MaxDiameter for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          MaxDiameter->{10 Millimeter,6 Millimeter},
          Output->Options
        ],
        MaxDiameter
      ],
      {10 Millimeter,6 Millimeter}
    ],
    
    (* Section: MinColonySeparation *)
    Example[{Options,MinColonySeparation,"If InoculationSource is LiquidMedia MinColonySeparation is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        MinColonySeparation
      ],
      Null
    ],

    Example[{Options,MinColonySeparation,"If InoculationSource is AgarStab MinColonySeparation is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        MinColonySeparation
      ],
      Null
    ],

    Example[{Options,MinColonySeparation,"If InoculationSource is SolidMedia, MinColonySeparation is automatically set to 0.2 Millimeter:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        MinColonySeparation
      ],
      0.2 Millimeter
    ],

    Example[{Options,MinColonySeparation,"If InoculationSource is SolidMedia, set MinColonySeparation for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource->SolidMedia,
          MinColonySeparation->{0.4 Millimeter,0.8 Millimeter},
          Output->Options
        ],
        MinColonySeparation
      ],
      {0.4 Millimeter,0.8 Millimeter}
    ],
    
    Example[{Options,Name,"Name of the output protocol object can be specified:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        Name->"ExperimentInoculateLiquidMedia name test protocol"<> $SessionUUID
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation,"ExperimentInoculateLiquidMedia name test protocol"<> $SessionUUID]]
    ],

    (* TODO: Add Template option test *)

    Example[{Options,SamplesInStorageCondition,"SamplesInStorageCondition can be specified:"},
      options=ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        SamplesInStorageCondition->Refrigerator,
        Output->Options
      ];
      Lookup[options,SamplesInStorageCondition],
      Refrigerator,
      Variables:>{options}
    ],

    Example[{Options,SamplesOutStorageCondition,"SamplesOutStorageCondition can be specified:"},
      options=ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        SamplesOutStorageCondition->BacterialIncubation,
        Output->Options
      ];
      Lookup[options,SamplesOutStorageCondition],
      BacterialIncubation,
      Variables:>{options}
    ],
    Example[{Options,Preparation,"Preparation is always set to Robotic as this experiment can only happen on the qPix:"},
      options=ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        Output->Options
      ];
      Lookup[options,Preparation],
      Robotic,
      Variables:>{options}
    ],

    Example[{Options,WorkCell,"WorkCell is always set to qPix as this experiment can only happen on the qPix:"},
      options=ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        Output->Options
      ];
      Lookup[options,WorkCell],
      qPix,
      Variables:>{options}
    ],

    Example[{Options,MeasureWeight,"Set the MeasureWeight option:"},
      options=ExperimentInoculateLiquidMedia[Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],MeasureWeight->True,Output->Options];
      Lookup[options,MeasureWeight],
      True,
      Variables:>{options}
    ],
    Example[{Options,MeasureVolume,"Set the MeasureVolume option:"},
      options=ExperimentInoculateLiquidMedia[Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],MeasureVolume->True,Output->Options];
      Lookup[options,MeasureVolume],
      True,
      Variables:>{options}
    ],
    Example[{Options,ImageSample,"Set the ImageSample option:"},
      options=ExperimentInoculateLiquidMedia[Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],ImageSample->True,Output->Options];
      Lookup[options,ImageSample],
      True,
      Variables:>{options}
    ],
    
    (* Section: Volume *)
    Example[{Options,Volume,"If InoculationSource is SolidMedia, Volume automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        Volume
      ],
      Null
    ],

    Example[{Options,Volume,"If InoculationSource is AgarStab, Volume automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        Volume
      ],
      Null
    ],

    Example[{Options,Volume,"If InoculationSource is LiquidMedia, Volume automatically resolves to the maximum of 1/10th of the volume of the input sample and 1 Microliter:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        Volume
      ],
      RangeP[1 Microliter]
    ],

    Example[{Options,Volume,"If InoculationSource is LiquidMedia, set Volume to All to transfer all of the media in the input sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Volume -> All,
          Output->Options
        ],
        Volume
      ],
      All
    ],

    Example[{Options,Volume,"If InoculationSource is LiquidMedia, specify a different Volume for each input sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource->LiquidMedia,
          Volume->{0.5 Milliliter, 0.3 Milliliter},
          Output->Options
        ],
        Volume
      ],
      {0.5 Milliliter, 0.3 Milliliter}
    ],
    
    (* Section: DestinationWell *)
    Example[{Options,DestinationWell,"If InoculationSource is SolidMedia, DestinationWell automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        DestinationWell
      ],
      Null
    ],
    
    Example[{Options,DestinationWell,"If InoculationSource is LiquidMedia, specify a DestinationWell along with a DestinationMediaContainer:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          DestinationMediaContainer -> Object[Container,Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 1 " <> $SessionUUID],
          DestinationWell -> "A1",
          Output->Options
        ],
        DestinationWell
      ],
      "A1"
    ],

    Example[{Options,DestinationWell,"If InoculationSource is AgarStab, specify a DestinationWell along with a DestinationMediaContainer:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          DestinationMediaContainer -> Object[Container,Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 1 " <> $SessionUUID],
          DestinationWell -> "A1",
          Output->Options
        ],
        DestinationWell
      ],
      "A1"
    ],

    Example[{Options,DestinationWell,"Specify different DestinationWells for each input sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 2 in cryoVial " <> $SessionUUID]
          },
          InoculationSource->AgarStab,
          DestinationMediaContainer -> Object[Container,Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 6 " <> $SessionUUID],
          DestinationWell -> {"A1","B1"},
          Output->Options
        ],
        DestinationWell
      ],
      {"A1","B1"}
    ],

    (* Section: Tips *)
    Example[{Options,Tips,"If InoculationSource is SolidMedia, Tips automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        Tips
      ],
      Null
    ],

    Example[{Options,Tips,"If InoculationSource is AgarStab, Tips automatically resolves to Model[Item, Tips, \"1000 uL reach tips, sterile\"]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        Tips
      ],
      ObjectP[Model[Item, Tips, "id:n0k9mGzRaaN3"]] (* Model[Item, Tips, "1000 uL reach tips, sterile"] *)
    ],

    Example[{Options,Tips,"If InoculationSource is LiquidMedia, specify the Tips to use for the inoculation:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Volume -> 0.5 Milliliter,
          Tips -> Model[Item, Tips, "id:n0k9mGzRaaN3"],
          Output->Options
        ],
        Tips
      ],
      ObjectP[Model[Item, Tips, "id:n0k9mGzRaaN3"]] (* Model[Item, Tips, "1000 uL reach tips, sterile"] *)
    ],

    Example[{Options,Tips,"If InoculationSource is LiquidMedia, specify the Tips to use for the inoculation for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource->LiquidMedia,
          Volume -> 0.1 Milliliter,
          Tips -> {Model[Item, Tips, "id:n0k9mGzRaaN3"],Model[Item, Tips, "id:P5ZnEj4P88jR"]},
          Output->Options
        ],
        Tips
      ],
      {ObjectP[Model[Item, Tips, "id:n0k9mGzRaaN3"]],ObjectP[Model[Item, Tips, "id:P5ZnEj4P88jR"]]} (* Model[Item, Tips, "1000 uL reach tips, sterile"], Model[Item, Tips, "200 uL tips, sterile"] *)
    ],

    (* Section: TipType *)
    Example[{Options,TipType,"If InoculationSource is SolidMedia, TipType automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        TipType
      ],
      Null
    ],

    Example[{Options,TipType,"If InoculationSource is AgarStab, TipType automatically resolves to Barrier:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        TipType
      ],
      Barrier
    ],

    Example[{Options,TipType,"If InoculationSource is LiquidMedia, specify the TipType to use for the inoculation:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Volume -> 0.5 Milliliter,
          TipType -> Barrier,
          Output->Options
        ],
        TipType
      ],
      Barrier
    ],

    Example[{Options,TipType,"If InoculationSource is LiquidMedia, specify the TipType to use for the inoculation for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource->LiquidMedia,
          Volume -> 0.5 Milliliter,
          TipType -> {Barrier,Barrier},
          Output->Options
        ],
        TipType
      ],
      {Barrier,Barrier}
    ],

    (* Section: TipMaterial *)

    Example[{Options,TipMaterial,"If InoculationSource is SolidMedia, TipMaterial automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        TipMaterial
      ],
      Null
    ],

    Example[{Options,TipMaterial,"If InoculationSource is AgarStab, TipMaterial automatically resolves to Polypropylene:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        TipMaterial
      ],
      Polypropylene
    ],

    Example[{Options,TipMaterial,"If InoculationSource is LiquidMedia, specify the TipMaterial to use for the inoculation:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Volume -> 0.5 Milliliter,
          TipMaterial -> Polypropylene,
          Output->Options
        ],
        TipMaterial
      ],
      Polypropylene
    ],

    Example[{Options,TipMaterial,"If InoculationSource is LiquidMedia, specify the TipMaterial to use for the inoculation for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource->LiquidMedia,
          Volume -> 0.5 Milliliter,
          TipMaterial -> {Polypropylene,Polypropylene},
          Output->Options
        ],
        TipMaterial
      ],
      {Polypropylene,Polypropylene}
    ],

    (* Section: SourceMix *)
    Example[{Options,SourceMix,"If InoculationSource is SolidMedia, SourceMix automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        SourceMix
      ],
      Null
    ],

    Example[{Options,SourceMix,"If InoculationSource is AgarStab, SourceMix automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        SourceMix
      ],
      Null
    ],

    Example[{Options,SourceMix,"If InoculationSource is LiquidMedia, SourceMix is automatically set to True:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        SourceMix
      ],
      True
    ],

    Example[{Options,SourceMix,"If InoculationSource is LiquidMedia, specify SourceMix for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource->LiquidMedia,
          SourceMix->{True,False},
          Output->Options
        ],
        SourceMix
      ],
      {True,False}
    ],

    (* Section: NumberOfSourceMixes *)
    Example[{Options,NumberOfSourceMixes,"If InoculationSource is SolidMedia, NumberOfSourceMixes automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        NumberOfSourceMixes
      ],
      Null
    ],

    Example[{Options,NumberOfSourceMixes,"If InoculationSource is AgarStab, NumberOfSourceMixes automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        NumberOfSourceMixes
      ],
      Null
    ],

    Example[{Options,NumberOfSourceMixes,"If InoculationSource is LiquidMedia, NumberOfSourceMixes is automatically set to 10:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        NumberOfSourceMixes
      ],
      10
    ],

    Example[{Options,NumberOfSourceMixes,"If InoculationSource is LiquidMedia, specify NumberOfSourceMixes for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource->LiquidMedia,
          NumberOfSourceMixes->{8,20},
          Output->Options
        ],
        NumberOfSourceMixes
      ],
      {8,20}
    ],

    (* Section: SourceMixVolume *)
    Example[{Options,SourceMixVolume,"If InoculationSource is SolidMedia, SourceMixVolume automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        SourceMixVolume
      ],
      Null
    ],

    Example[{Options,SourceMixVolume,"If InoculationSource is AgarStab, SourceMixVolume automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        SourceMixVolume
      ],
      Null
    ],

    Example[{Options,SourceMixVolume,"If InoculationSource is LiquidMedia, SourceMixVolume is automatically set to the Min(max tip volume, max of Volume and 1/4th of the input sample volume):"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        SourceMixVolume
      ],
      RangeP[200 Microliter]
    ],

    Example[{Options,SourceMixVolume,"If InoculationSource is LiquidMedia, specify SourceMixVolume for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource->LiquidMedia,
          SourceMixVolume->{100 Microliter,300 Microliter},
          Output->Options
        ],
        SourceMixVolume
      ],
      {100 Microliter,300 Microliter}
    ],

    (* Section: PipettingMethod *)
    Example[{Options,PipettingMethod,"If InoculationSource is SolidMedia, PipettingMethod automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output->Options
        ],
        PipettingMethod
      ],
      Null
    ],

    Example[{Options,PipettingMethod,"If InoculationSource is AgarStab, PipettingMethod automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output->Options
        ],
        PipettingMethod
      ],
      Null
    ],

    Example[{Options,PipettingMethod,"If InoculationSource is LiquidMedia, PipettingMethod is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Output->Options
        ],
        PipettingMethod
      ],
      Null
    ],

    Example[{Options,PipettingMethod,"If InoculationSource is LiquidMedia, specify PipettingMethod for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource->LiquidMedia,
          PipettingMethod->{Model[Method, Pipetting, "id:qdkmxzqkJlw1"],Model[Method, Pipetting, "id:wqW9BP7WbvjG"]},
          Output->Options
        ],
        PipettingMethod
      ],
      {ObjectP[Model[Method, Pipetting, "id:qdkmxzqkJlw1"]],ObjectP[Model[Method, Pipetting, "id:wqW9BP7WbvjG"]]}(* {Model[Method, Pipetting, "Aqueous"],Model[Method, Pipetting, "Aqueous Low Volume"]} *)
    ],

    (* ------------------------------------------------- Messages ------------------------------------------------- *)

    Example[{Messages,"NonOmniTrayContainer","If InoculationSource is SolidMedia, return $Failed if the input samples are not in an omnitray:"},
      ExperimentInoculateLiquidMedia[Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in dwp " <> $SessionUUID]],
      $Failed,
      Messages :> {Error::NonOmniTrayContainer,Error::InvalidOption}
    ],
    Example[{Messages,"TooManyInputContainers","If InoculationSource is SolidMedia, return $Failed if the input samples are contained in more than 4 unique containers:"},
      ExperimentInoculateLiquidMedia[
        {
          Object[Container,Plate, "ExperimentInoculateLiquidMedia" <> " test omniTray 1 " <> $SessionUUID],
          Object[Container,Plate, "ExperimentInoculateLiquidMedia" <> " test omniTray 2 " <> $SessionUUID],
          Object[Container,Plate, "ExperimentInoculateLiquidMedia" <> " test omniTray 3 " <> $SessionUUID],
          Object[Container,Plate, "ExperimentInoculateLiquidMedia" <> " test omniTray 4 " <> $SessionUUID],
          Object[Container,Plate, "ExperimentInoculateLiquidMedia" <> " test omniTray 5 " <> $SessionUUID],
          Object[Container,Plate, "ExperimentInoculateLiquidMedia" <> " test omniTray 6 " <> $SessionUUID]
        },
        InoculationSource->SolidMedia
      ],
      $Failed,
      Messages :> {Error::TooManyInputContainers,Error::InvalidOption}
    ],
    Example[{Messages,"PrimaryWashMismatch","If InoculationSource is SolidMedia, if PrimaryWash->True and other PrimaryWash options are Null, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          PrimaryWash->True,
          NumberOfPrimaryWashes->Null,
          Output -> Options
        ],
        PrimaryWash
      ],
      True,
      Messages :> {Error::PrimaryWashMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"SecondaryWashMismatch","If InoculationSource is SolidMedia, if SecondaryWash->True and other SecondaryWash options are Null, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          SecondaryWash->True,
          NumberOfSecondaryWashes->Null,
          Output -> Options
        ],
        SecondaryWash
      ],
      True,
      Messages :> {Error::SecondaryWashMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"TertiaryWashMismatch","If InoculationSource is SolidMedia, if TertiaryWash->True and other TertiaryWash options are Null, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          TertiaryWash->True,
          NumberOfTertiaryWashes->Null,
          Output -> Options
        ],
        TertiaryWash
      ],
      True,
      Messages :> {Error::TertiaryWashMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"QuaternaryWashMismatch","If InoculationSource is SolidMedia, if QuaternaryWash->True and other QuaternaryWash options are Null, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          QuaternaryWash->True,
          NumberOfQuaternaryWashes->Null,
          Output -> Options
        ],
        QuaternaryWash
      ],
      True,
      Messages :> {Error::QuaternaryWashMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"TooManyWashSolutions","If InoculationSource is SolidMedia, if there are more than 3 different sample models across PrimaryWashSolution, SecondaryWashSolution, TertiaryWashSolution, and QuaternaryWashSolution, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
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
    Example[{Messages,"OutOfOrderWashStages","If InoculationSource is SolidMedia, if a wash stage is specified but not all of the prerequisite stages are specified, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          PrimaryWash -> False,
          SecondaryWash -> True,
          Output -> Options
        ],
        PrimaryWash
      ],
      False,
      Messages :> {Error::OutOfOrderWashStages,Error::InvalidOption}
    ],
    Example[{Messages,"PickCoordinatesMissing","If InoculationSource is SolidMedia, if Populations ->CustomCoordinates and PickCoordinates are not specified an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> CustomCoordinates,
          Output -> Options
        ],
        Populations
      ],
      CustomCoordinates,
      Messages :> {Error::PickCoordinatesMissing,Error::InvalidOption}
    ],
    Example[{Messages,"MultiplePopulationMethods","If InoculationSource is SolidMedia, if Populations -> Population and PickCoordinates are specified an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> Diameter[],
          PickCoordinates -> ConstantArray[{0 Millimeter, 0 Millimeter},10],
          Output -> Options
        ],
        Populations
      ],
      DiameterPrimitiveP,
      Messages :> {Error::MultiplePopulationMethods,Error::InvalidOption}
    ],
    Example[{Messages,"AnalysisOptionsMismatch","If InoculationSource is SolidMedia, if Populations -> CustomCoordinates and any of the global filtering options are set an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
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
    Example[{Messages,"PopulationMismatch","If InoculationSource is SolidMedia, if Populations is specified as a mix of Populations, Unknown, or CustomCoordinates for a single sample, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> {{CustomCoordinates, Diameter}},
          Output -> Options
        ],
        Populations
      ],
      {{CustomCoordinates, DiameterPrimitiveP}},
      Messages :> {Error::PopulationMismatch,Error::InvalidOption}
    ],

    Example[{Messages,"IndexMatchingPrimitive","If InoculationSource is SolidMedia, if the options within a population don't index match, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> MultiFeatured[
            Features->{Diameter, Fluorescence},
            NumberOfDivisions->{5}
          ],
          Output -> Options
        ],
        Populations
      ],
      MultiFeaturedPrimitiveP,
      Messages :> {Error::IndexMatchingPrimitive, Error::InvalidOption}
    ],
    Example[{Messages,"NoAutomaticWavelength","If InoculationSource is SolidMedia, if for a Fluorescence population and no fluorescent wavelength is given or can be found in the composition of the input sample, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli no fluorescent wavelengths sample 1 in omniTray" <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> Fluorescence[NumberOfColonies->5],
          Output -> Options
        ],
        Populations
      ],
      {{_Fluorescence}},
      Messages :> {Error::NoAutomaticWavelength, Error::InvalidOption}
    ],
    Example[{Messages,"RepeatedPopulationNames","If InoculationSource is SolidMedia, if the same PopulationName is used in multiple Populations, an error will be thrown :"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> {{
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

    Example[{Messages,"ImagingOptionMismatch","If InoculationSource is SolidMedia, if ImagingChannels and ExposureTimes are set to different lengths, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          ImagingChannels -> {BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer}},
          ExposureTimes -> {3 Millisecond, 5 Millisecond},
          Output -> Options
        ],
        ExposureTimes
      ],
      {3 Millisecond, 5 Millisecond},
      Messages :> {Error::ImagingOptionMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"MissingImagingChannels","If InoculationSource is SolidMedia, if there are imaging channels specified in a Population that are not specified in ImagingChannels, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> Fluorescence[ExcitationWavelength -> 457 Nanometer, EmissionWavelength -> 536 Nanometer],
          ImagingChannels -> {BrightField,{377 Nanometer,447 Nanometer},{531 Nanometer, 593 Nanometer}},
          Output -> Options
        ],
        ImagingChannels
      ],
      {BrightField,{377 Nanometer,447 Nanometer},{531 Nanometer, 593 Nanometer}},
      Messages :> {Error::MissingImagingChannels,Error::InvalidOption}
    ],
    Example[{Messages,"DuplicateImagingChannels","If InoculationSource is SolidMedia, if an imaging channel is specified multiple times in ImagingChannels, a warning will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> Automatic,
          ImagingChannels -> {BrightField,{377 Nanometer,447 Nanometer},BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer}},
          Output -> Options
        ],
        ImagingChannels
      ],
      {BrightField,{377 Nanometer,447 Nanometer},BrightField,{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer}},
      Messages :> {Warning::DuplicateImagingChannels}
    ],
    Example[{Messages,"InvalidDestinationMediaState","If InoculationSource is SolidMedia, if the DestinationMedia has a non Liquid or Solid State, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          DestinationMedia -> Object[Sample, "ExperimentInoculateLiquidMedia" <> " test gas sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output -> Options
        ],
        DestinationMedia
      ],
      ObjectP[Object[Sample, "ExperimentInoculateLiquidMedia" <> " test gas sample 1 in omniTray " <> $SessionUUID]],
      Messages :> {Error::InvalidDestinationMediaState,Error::InvalidOption}
    ],
    Example[{Messages,"InvalidDestinationMediaContainer","If InoculationSource is SolidMedia, if the DestinationMediaContainer does not have 1, 24, or 96 wells or is deep well but does not have 96 wells, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          DestinationMediaContainer -> Object[Container,Plate,"ExperimentInoculateLiquidMedia" <> " test 24-well Round Bottom Deep Well Plate " <> $SessionUUID],
          Output -> Options
        ],
        DestinationMediaContainer
      ],
      {ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test 24-well Round Bottom Deep Well Plate " <> $SessionUUID]]},
      Messages :> {Error::InvalidDestinationMediaContainer,Error::InvalidOption}
    ],
    Example[{Messages,"TooManyDestinationMediaContainers","If InoculationSource is SolidMedia, if there are more than 6 unique DestinationMediaContainers, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Populations -> {{
            Diameter[],
            Circularity[],
            Fluorescence[NumberOfColonies -> 10],
            Isolation[],
            Regularity[],
            Absorbance[NumberOfColonies->12],
            Absorbance[NumberOfColonies->14]
          }},
          DestinationMediaContainer -> {
            Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 1 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 2 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 3 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 4 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 5 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 6 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentInoculateLiquidMedia" <> " test dwp 7 " <> $SessionUUID]
          },
          Output -> Options
        ],
        InoculationSource
      ],
      SolidMedia,
      Messages :> {Error::TooManyDestinationMediaContainers,Error::InvalidOption}
    ],

    Example[{Messages,"DestinationMixMismatch","If DestinationMix->False and another DestinationMix option is set, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          DestinationMix -> False,
          DestinationNumberOfMixes -> 10,
          Output -> Options
        ],
        DestinationMix
      ],
      False,
      Messages :> {Error::DestinationMixMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"PickingToolIncompatibleWithDestinationMediaContainer","If InoculationSource is SolidMedia, if the specified ColonyPickingTool is incompatible with a DestinationMediaContainer, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli"],
          DestinationMediaContainer -> Object[Container,Plate, "ExperimentInoculateLiquidMedia" <> " test 24-well Plate " <> $SessionUUID],
          Output -> Options
        ],
        ColonyPickingTool
      ],
      ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli"]],
      Messages :> {Error::PickingToolIncompatibleWithDestinationMediaContainer,Error::InvalidOption}
    ],
    Example[{Messages,"NoAvailablePickingTool","If InoculationSource is SolidMedia, if there is no ColonyPickingTool that satisfies the colony picking tool parameter options, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          NumberOfHeads -> 384,
          Output -> Options
        ],
        NumberOfHeads
      ],
      384,
      Messages :> {Error::NoAvailablePickingTool,Error::NumberOfHeadsMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"NotPreferredColonyHandlerHead","If InoculationSource is SolidMedia, if the specified ColonyPickingTool is not preferred for the cell type in the input sample, a warning will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for Phage - Deep well"],
          Output -> Options
        ],
        ColonyPickingTool
      ],
      ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for Phage - Deep well"]],
      Messages :> {Warning::NotPreferredColonyHandlerHead}
    ],
    Example[{Messages,"HeadDiameterMismatch","If InoculationSource is SolidMedia, if the specified HeadDiameter does not match the value in the HeadDiameter field of the specified ColonyPickingTool, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"],
          HeadDiameter -> 1 Millimeter,
          Output -> Options
        ],
        ColonyPickingTool
      ],
      ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"]],
      Messages :> {Error::HeadDiameterMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"HeadLengthMismatch","If InoculationSource is SolidMedia, if the specified HeadLength does not match the value in the HeadLength field of the specified ColonyPickingTool, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"],
          HeadLength -> 9.4 Millimeter,
          Output -> Options
        ],
        ColonyPickingTool
      ],
      ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"]],
      Messages :> {Error::HeadLengthMismatch,Error::PickingToolIncompatibleWithDestinationMediaContainer,Error::InvalidOption}
    ],
    Example[{Messages,"NumberOfHeadsMismatch","If InoculationSource is SolidMedia, if the specified NumberOfHeads does not match the value in the NumberOfHeads field of the specified ColonyPickingTool, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"],
          NumberOfHeads -> 24,
          Output -> Options
        ],
        ColonyPickingTool
      ],
      ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"]],
      Messages :> {Error::NumberOfHeadsMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"ColonyHandlerHeadCassetteApplicationMismatch","If InoculationSource is SolidMedia, if the specified ColonyHandlerHeadCassetteApplication does not match the value in the Application field of the specified ColonyPickingTool, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"],
          ColonyHandlerHeadCassetteApplication -> Spread,
          Output -> Options
        ],
        ColonyPickingTool
      ],
      ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"]],
      Messages :> {Error::ColonyHandlerHeadCassetteApplicationMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"InvalidColonyPickingDepths","If InoculationSource is SolidMedia, if the specified ColonyPickingDepth is greater than the depth of a well of an input container, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          ColonyPickingDepth -> 15 Millimeter,
          Output -> Options
        ],
        ColonyPickingDepth
      ],
      15 Millimeter,
      Messages :> {Error::InvalidColonyPickingDepths,Error::InvalidOption}
    ],

    Example[{Messages,"OverAspiratedTransfer","If InoculationSource is LiquidMedia, if Volume is more than will be in the container/well of the input sample at the time of the transfer, a warning is thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Volume -> 2 Milliliter,
          Output -> Options
        ],
        Volume
      ],
      2 Milliliter,
      Messages :> {Warning::OveraspiratedTransfer,Error::NoCompatibleTips,Error::InvalidOption}
    ],

    Example[{Messages,"InvalidTransferWellSpecification","If InoculationSource is LiquidMedia, a message is thrown if a bogus DestinationWell is given:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          DestinationMediaContainer->Object[Container,Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 1 " <> $SessionUUID],
          DestinationWell -> "A2",
          Output -> Options
        ],
        DestinationWell
      ],
      "A2",
      Messages :> {Error::InvalidTransferWellSpecification, Error::InvalidOption}
    ],
       
    Example[{Messages,"NoCompatibleTips","If InoculationSource is LiquidMedia, a reasonable message is thrown if asked to transfer using tip requirements for which there are no engine default tips in the lab:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Volume->All,
          TipMaterial -> Graphite,
          Output -> Options
        ],
        Volume
      ],
      All,
      Messages :> {Error::NoCompatibleTips, Error::InvalidOption}
    ],

    Example[{Messages,"MultipleInoculationSourceInInput","A message is thrown if different input samples have different InoculationSourceTypes:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID]},
          Output -> Options
        ],
        InoculationSource
      ],
      Null,
      Messages :> {Error::MultipleInoculationSourceInInput,Error::InvalidInput,Error::InvalidOption}
    ],

    Example[{Messages,"InoculationSourceInputMismatch","A message is thrown if InoculationSource does not match the state of the input sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Output -> Options
        ],
        InoculationSource
      ],
      SolidMedia,
      Messages :> {Error::InoculationSourceInputMismatch,Error::InvalidOption}
    ],

    Example[{Messages,"InoculationSourceOptionMismatch","If InoculationSource is SolidMedia and options are set that are only valid for LiquidMedia or AgarStab, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          SourceMix->True,
          Output -> Options
        ],
        InoculationSource
      ],
      SolidMedia,
      Messages :> {Error::InoculationSourceOptionMismatch,Error::InvalidOption}
    ],

    Example[{Messages,"InoculationSourceOptionMismatch","If InoculationSource is LiquidMedia and options are set that are only valid for SolidMedia or AgarStab, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Populations ->Diameter[],
          Output -> Options
        ],
        InoculationSource
      ],
      LiquidMedia,
      Messages :> {Error::InoculationSourceOptionMismatch,Error::InvalidOption}
    ],

    Example[{Messages,"InvalidInstrument","If InoculationSource is SolidMedia and Instrument is not a ColonyHandler, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          Instrument->Model[Instrument, Pipette, "id:vXl9j57VBAjN"],
          Output -> Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "id:vXl9j57VBAjN"]] (* Model[Instrument, Pipette, "Eppendorf Research Plus P200, Microbial"] *),
      Messages :> {Error::InvalidInstrument,Error::InvalidOption,Error::ConflictingUnitOperationMethodRequirements}
    ],

    Example[{Messages,"InvalidInstrument","If InoculationSource is LiquidMedia and Instrument is a ColonyHandler, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          Instrument->Object[Instrument, ColonyHandler, "id:E8zoYvNkqjEv"],
          Output -> Options
        ],
        Instrument
      ],
      ObjectP[Object[Instrument, ColonyHandler, "id:E8zoYvNkqjEv"]], (* Object[Instrument, ColonyHandler, "Pinhead"] *)
      Messages :> {Error::InvalidInstrument,Error::InvalidOption}
    ],

    Example[{Messages,"InvalidInstrument","If InoculationSource is AgarStab and Instrument is not a pipette, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Instrument->Object[Instrument, ColonyHandler, "id:E8zoYvNkqjEv"],
          Output -> Options
        ],
        Instrument
      ],
      ObjectP[Object[Instrument, ColonyHandler, "id:E8zoYvNkqjEv"]], (* Object[Instrument, ColonyHandler, "Pinhead"] *)
      Messages :> {Error::ConflictingUnitOperationMethodRequirements,Error::InvalidInstrument,Error::InvalidOption}
    ],
       
    Example[{Messages,"MultipleDestinationMediaContainers","If InoculationSource is AgarStab or LiquidMedia, if DestinationMediaContainer is specified as a list of Object[Container]s, an error is thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource->LiquidMedia,
          DestinationMediaContainer -> {{
            Object[Container, Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 1 " <> $SessionUUID],
            Object[Container, Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 2 " <> $SessionUUID],
            Object[Container, Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 3 " <> $SessionUUID]
          }},
          Output -> Options
        ],
        DestinationMediaContainer
      ],
      {{
        ObjectP[Object[Container, Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 1 " <> $SessionUUID]],
        ObjectP[Object[Container, Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 2 " <> $SessionUUID]],
        ObjectP[Object[Container, Vessel, "ExperimentInoculateLiquidMedia" <> " test destination 5mL tube 3 " <> $SessionUUID]]
      }},
      Messages :> {Error::MultipleDestinationMediaContainers,Error::InvalidOption}
    ],
       
    Example[{Messages,"InvalidMixType","If InoculationSource is SolidMedia and DestinationMixType is not Shake, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource->SolidMedia,
          DestinationMixType->Pipette,
          Output -> Options
        ],
        DestinationMixType
      ],
      Pipette,
      Messages :> {Error::InvalidMixType,Error::InvalidOption}
    ],

    Example[{Messages,"NoTipsFound","If InoculationSource is AgarStab, an error is thrown if there are no Tips that match the required specifications:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          TipMaterial -> NaturalRubber,
          TipType -> Normal,
          Output -> Options
        ],
        TipType
      ],
      Normal,
      Messages :> {Error::NoTipsFound,Error::InvalidOption,Error::TipOptionMismatch}
    ],

    Example[{Messages,"TipOptionMismatch","If InoculationSource is AgarStab, if the options TipMaterial and TipType do not match the value of the specified Tips an error is thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource->AgarStab,
          Tips -> Model[Item,Tips,"id:n0k9mGzRaaN3"],
          TipMaterial -> NaturalRubber,
          TipType -> Normal,
          Output -> Options
        ],
        TipType
      ],
      Normal,
      Messages :> {Error::TipOptionMismatch,Error::InvalidOption}
    ],
    
    Example[{Messages,"NoPreferredLiquidMedia","If InoculationSource is AgarStab, if the input sample contains a Model[Cell] in its composition that does not have a PreferredLiquidMedia, a warning is thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 5 in cryoVial - no PreferredLiquidMedia " <> $SessionUUID],
          InoculationSource->AgarStab,
          Output -> Options
        ],
        DestinationMedia
      ],
      ObjectP[Model[Sample, "id:Y0lXejMdBNRE"]], (* Model[Sample, "Nutrient Broth"] *)
      Messages :> {Warning::NoPreferredLiquidMedia}
    ],

    Example[{Messages,"InvalidDestinationWellPosition","If InoculationSource is AgarStab, if the specified DestinationWell is not a Position in the DestinationMediaContainer, an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          DestinationWell -> "A3",
          Output -> Options
        ],
        DestinationWell
      ],
      "A3",
      Messages :> {Error::InvalidDestinationWellPosition,Error::InvalidOption}
    ],

    Example[{Messages,"MixMismatch","If InoculationSource is AgarStab, if only some of the DestinationMix options are set (and others are Null), an error will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          DestinationMix -> True,
          DestinationNumberOfMixes -> Null,
          Output -> Options
        ],
        DestinationNumberOfMixes
      ],
      Null,
      Messages :> {Error::MixMismatch,Error::InvalidOption}
    ],

    Example[{Messages,"TipConnectionMismatch","If InoculationSource is AgarStab, if the specified Instrument and specified Tips do not have the same TipConnectionType, an error is thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
          Instrument -> Model[Instrument, Pipette, "id:GmzlKjP3boWe"], (* "Eppendorf Research Plus P1000, Microbial" *)
          Tips -> Model[Item, Tips, "id:WNa4ZjRr5ljD"], (* Model[Item, Tips, "1 mL glass barrier serological pipets, sterile"] *)
          Output -> Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "id:GmzlKjP3boWe"]],
      Messages :> {Error::TipConnectionMismatch,Error::InvalidOption}
    ],
    Example[{Options,SamplesInStorageCondition,"SamplesInStorageCondition can be specified:"},
      options=ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        SamplesInStorageCondition->Refrigerator,
        Output->Options
      ];
      Lookup[options,SamplesInStorageCondition],
      Refrigerator,
      Variables:>{options}
    ],
    Example[{Messages,"InstrumentPrecision","If a ColonyPickingDepth with a greater precision than 0.01 Millimeter is given, it is rounded:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
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
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
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
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
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
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
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
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
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
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
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
    Example[{Messages,"IncompatibleMaterials","If a wash solution is not compatible with the wetted materials of the instrument, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        PrimaryWashSolution -> Model[Sample, "ExperimentInoculateLiquidMedia" <> " test incompatible sample model " <> $SessionUUID],
        SecondaryWash -> False,
        Output->Options
      ],
      _List,
      Messages :> {Warning::IncompatibleMaterials}
    ],
    Example[{Messages,"IncompatibleMaterials","If the input sample is not compatible with the wetted materials of the instrument, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia" <> " test incompatible input sample in omnitray " <> $SessionUUID],
        Output->Options
      ],
      _List,
      Messages :> {Warning::IncompatibleMaterials,Warning::NotPreferredColonyHandlerHead}
    ]
  },
  SymbolSetUp:>(
    inoculateLiquidMediaSymbolSetUp["ExperimentInoculateLiquidMedia"]
  ),
  SymbolTearDown :> (
    inoculateLiquidMediaObjectErasure["ExperimentInoculateLiquidMedia", True]
  )
];

(* ::Subsection:: *)
(* ExperimentInoculateLiquidMediaOptions *)
DefineTests[ExperimentInoculateLiquidMediaOptions,
  {
    Example[{Basic,"Display the option values which will be used in the experiment:"},
      ExperimentInoculateLiquidMediaOptions[Object[Sample, "ExperimentInoculateLiquidMediaOptions" <> " test e.coli sample 1 in omniTray " <> $SessionUUID]],
      _Grid
    ],
    Example[{Basic,"Basic pick colonies with InoculationSource -> AgarStab:"},
      ExperimentInoculateLiquidMediaOptions[Object[Sample, "ExperimentInoculateLiquidMediaOptions" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID]
      ],
      _Grid
    ],
    Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
      ExperimentInoculateLiquidMediaOptions[Object[Sample, "ExperimentInoculateLiquidMediaOptions" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> SolidMedia
      ],
      _Grid,
      Messages :> {Error::ConflictingUnitOperationMethodRequirements,Error::InoculationSourceInputMismatch,Error::InvalidOption}
    ],

    Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
      ExperimentInoculateLiquidMediaOptions[Object[Sample, "ExperimentInoculateLiquidMediaOptions" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
        OutputFormat -> List
      ],
      {(_Rule|_RuleDelayed)..}
    ]
  },
  SymbolSetUp:>(
    inoculateLiquidMediaSymbolSetUp["ExperimentInoculateLiquidMediaOptions"]
  ),
  SymbolTearDown :> (
    inoculateLiquidMediaObjectErasure["ExperimentInoculateLiquidMediaOptions", True]
  )
];

(* ::Subsection:: *)
(* ValidExperimentInoculateLiquidMediaQ *)
DefineTests[ValidExperimentInoculateLiquidMediaQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentInoculateLiquidMediaQ[Object[Sample, "ValidExperimentInoculateLiquidMediaQ" <> " test e.coli sample 1 in omniTray " <> $SessionUUID]],
      True
    ],
    Example[{Basic,"Return False if there are problems with the inputs or options:"},
      ValidExperimentInoculateLiquidMediaQ[Object[Sample, "ValidExperimentInoculateLiquidMediaQ" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> SolidMedia
      ],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentInoculateLiquidMediaQ[Object[Sample, "ValidExperimentInoculateLiquidMediaQ" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentInoculateLiquidMediaQ[Object[Sample, "ValidExperimentInoculateLiquidMediaQ" <> " test e.coli sample 1 in omniTray " <> $SessionUUID],Verbose->True],
      True
    ]
  },
  SymbolSetUp:>(
    inoculateLiquidMediaSymbolSetUp["ValidExperimentInoculateLiquidMediaQ"]
  ),
  SymbolTearDown :> (
    inoculateLiquidMediaObjectErasure["ValidExperimentInoculateLiquidMediaQ", True]
  )
];

(* ::Subsection:: *)
(* InoculateLiquidMedia *)
DefineTests[InoculateLiquidMedia,
  {
    Example[{Basic,"Form an inoculate liquid media unit operation:"},
      InoculateLiquidMedia[
        InoculationSource -> SolidMedia,
        DestinationMix -> True,
        DestinationNumberOfMixes -> 5
      ],
      InoculateLiquidMediaP
    ],
    Example[{Basic,"Specifying a key incorrectly will not form a unit operation:"},
      primitive=InoculateLiquidMedia[
        InoculationSource -> SolidMedia,
        DestinationMix -> True,
        DestinationNumberOfMixes -> "cat"
      ];
      MatchQ[primitive,InoculateLiquidMediaP],
      False
    ],
    Example[{Basic,"A RoboticCellPreparation protocol is generated when InoculationSource is AgarStab:"},
      ExperimentRoboticCellPreparation[
        {
          InoculateLiquidMedia[
            Sample -> Object[Sample, "InoculateLiquidMedia" <> " test e.coli sample 1 in omniTray " <> $SessionUUID]
          ]
        }
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ],
    Example[{Basic,"A RoboticCellPreparation protocol is generated when InoculationSource is LiquidMedia:"},
      ExperimentRoboticCellPreparation[
        {
          InoculateLiquidMedia[
            Sample -> Object[Sample, "InoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID]
          ]
        }
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]]
    ],
    Example[{Basic,"A ManualCellPreparation protocol is generated when InoculationSource is LiquidMedia:"},
      ExperimentManualCellPreparation[
        {
          InoculateLiquidMedia[
            Sample -> Object[Sample, "InoculateLiquidMedia" <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID]
          ]
        }
      ],
      ObjectP[Object[Protocol,ManualCellPreparation]]
    ],
    Example[{Basic,"A ManualCellPreparation protocol is generated when InoculationSource is AgarStab:"},
      ExperimentManualCellPreparation[
        {
          InoculateLiquidMedia[
            Sample -> Object[Sample, "InoculateLiquidMedia" <> " test e.coli stab 1 in cryoVial " <> $SessionUUID]
          ]
        }
      ],
      ObjectP[Object[Protocol,ManualCellPreparation]]
    ]
  },
  SymbolSetUp:>(
    inoculateLiquidMediaSymbolSetUp["InoculateLiquidMedia"]
  ),
  SymbolTearDown :> (
    inoculateLiquidMediaObjectErasure["InoculateLiquidMedia", True]
  )
];
(* ::Subsection:: *)
(* Setup and Teardown *)
inoculateLiquidMediaObjectErasure[functionName_String, tearDownBool:BooleanP] := Module[
  {namedObjects,allObjects,existingObjs},

  namedObjects = Quiet[Cases[
    Flatten[{
      (* Colony Handler *)
      Model[Instrument,ColonyHandler, "Test Colony Handler Instrument Model Shell for " <> functionName <> " " <> $SessionUUID],

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
      Object[Container,Plate, functionName <> " test 24-well Round Bottom Deep Well Plate " <> $SessionUUID],
      Object[Container,Vessel, functionName <> " test cryoVial 1 " <> $SessionUUID],
      Object[Container,Vessel, functionName <> " test cryoVial 2 " <> $SessionUUID],
      Object[Container,Vessel, functionName <> " test cryoVial 3 " <> $SessionUUID],
      Object[Container,Vessel, functionName <> " test cryoVial 4 " <> $SessionUUID],
      Object[Container,Vessel, functionName <> " test cryoVial 5 " <> $SessionUUID],
      Object[Container,Vessel, functionName <> " test destination 5mL tube 1 " <> $SessionUUID],
      Object[Container,Vessel, functionName <> " test destination 5mL tube 2 " <> $SessionUUID],
      Object[Container,Vessel, functionName <> " test destination 5mL tube 3 " <> $SessionUUID],
      Object[Container,Vessel, functionName <> " test destination 5mL tube 4 " <> $SessionUUID],
      Object[Container,Vessel, functionName <> " test 4L amber glass bottle 1 " <> $SessionUUID],
      Object[Container,Vessel, functionName <> " test 4L amber glass bottle 2 " <> $SessionUUID],
      Object[Container,Vessel, functionName <> " test unaspiratable 2mL tube " <> $SessionUUID],
      Object[Container,Vessel, functionName <> " test undispensable 2mL tube " <> $SessionUUID],

      (* Media *)
      Model[Sample,Media, functionName <> " test solid LB agar media model " <> $SessionUUID],
      Model[Sample,Media, functionName <> " test liquid LB Broth media model " <> $SessionUUID],

      (* Bacteria *)
      Model[Cell,Bacteria, functionName <> " test e.coli model - gfp Positive " <> $SessionUUID],
      Model[Cell,Bacteria, functionName <> " test e.coli no fluorescent wavelengths model - gfp Positive " <> $SessionUUID],
      Model[Cell,Bacteria, functionName <> " test e.coli half match fluorescent wavelengths model - gfp Positive " <> $SessionUUID],
      Model[Cell,Bacteria, functionName <> " test e.coli model - gfp Positive - no PreferredLiquidMedia " <> $SessionUUID],

      (* Model[Sample]s *)
      Model[Sample, functionName <> " test e.coli and LB agar sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test e.coli no fluorescent wavelengths and LB agar sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test e.coli half match fluorescent wavelengths and LB agar sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test gas sample model " <> $SessionUUID],
      Model[Sample, functionName <> " test liquid e.coli culture model " <> $SessionUUID],
      Model[Sample, functionName <> " test e.coli no preferred liquid media and LB agar sample Model " <> $SessionUUID],
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
      Object[Sample, functionName <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
      Object[Sample, functionName <> " test liquid e.coli culture 2 in dwp " <> $SessionUUID],
      Object[Sample, functionName <> " test liquid e.coli culture 3 in dwp " <> $SessionUUID],
      Object[Sample, functionName <> " test liquid e.coli culture 4 in dwp " <> $SessionUUID],
      Object[Sample, functionName <> " test gas sample 1 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test LB Broth in 500 mL flask " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli no fluorescent wavelengths sample 1 in omniTray" <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli half match fluorescent wavelengths sample 1 in omniTray" <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli stab 2 in cryoVial " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli stab 3 in cryoVial " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli stab 4 in cryoVial " <> $SessionUUID],
      Object[Sample, functionName <> " test LB Broth in 4L amber glass flask " <> $SessionUUID],
      Object[Sample, functionName <> " test unaspiratable LB Broth sample in 2mL Tube " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli stab 5 in cryoVial - no PreferredLiquidMedia " <> $SessionUUID],
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

    (* Turn on the relevant messages *)
    On[Warning::SamplesOutOfStock]
  ];
];

inoculateLiquidMediaSymbolSetUp[functionName_String] := Module[{},

  (* Turn off some irrelevant messages *)
  Off[Warning::SamplesOutOfStock];

  (* Initialize Created Objects variable *)
  $CreatedObjects = {};

  (* Erase any named objects so we don't try to create duplicates *)
  inoculateLiquidMediaObjectErasure[functionName, False];

  (* Set up our test objects *)
  Module[
    {
      (* Colony Handler *)
      testColonyHandlerShell,

      (* Containers *)
      dwp1,dwp2,dwp3,dwp4,dwp5,dwp6,dwp7,
      omniTray1,omniTray2,omniTray3,omniTray4,omniTray5,omniTray6,omniTray7,omniTray8,omniTray9,omniTray10,omniTray11,
      flask500mL,plate24Well,plate24DeepWell,
      cryoVial1,cryoVial2,cryoVial3,cryoVial4,cryoVial5,
      destTube1, destTube2, destTube3, destTube4,
      amberGlassBottle4L1,amberGlassBottle4L2,unaspiratable2mLTube,undispensable2mLTube,

      (* Medias *)
      testSolidLBMedia,testLBBroth,

      (* Bacterias *)
      testEColi,testEColiNoFluorescentWavelengths,testEColiHalfMatchFluorescentWavelengths,testEColiNoPreferredLiquidMedia,

      (* Model[Sample]s *)
      testEColiSampleModel,testEColiNoFluorescentWavelengthsSampleModel,testEColiHalfMatchFluorescentWavelengthsSampleModel,
      testEColiSampleModelNoPreferredLiquidMedia,testGasSampleModel,testEColiLiquidCultureSampleModel,testIncompatibleSampleModel,

      (* Samples *)
      eColiSample1,eColiSample2,eColiSample3,eColiSample4,eColiSample5,eColiSample6,
      sampleInDwp,liquidCultureSample,gasSample,testLBBrothSample,eColiSampleNoFluorescentWavelengths,
      eColiSampleHalfMatchFluorescentWavelengths,eColiLiquidCulture1,eColiLiquidCulture2,eColiLiquidCulture3,eColiLiquidCulture4,
      agarStab1,agarStab2,agarStab3,agarStab4,liquidCultureSample3L,unaspiratableSample,noPreferredLiquidMediaSample,
      testIncompatibleInputSample,

      developerObjectPackets
    },

    (* Create a test colony handler *)
    testColonyHandlerShell = Upload[<|
      Type -> Model[Instrument,ColonyHandler],
      Name -> "Test Colony Handler Instrument Model Shell for " <> functionName <> " " <> $SessionUUID,
      DeveloperObject -> True
    |>];

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
      plate24DeepWell,
      cryoVial1,
      cryoVial2,
      cryoVial3,
      cryoVial4,
      cryoVial5,
      destTube1,
      destTube2,
      destTube3,
      destTube4,
      unaspiratable2mLTube,
      undispensable2mLTube,
      amberGlassBottle4L1,
      amberGlassBottle4L2
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
      |>,
      Sequence@@Table[
        <|
          Type -> Object[Container,Vessel],
          Model -> Link[Model[Container, Vessel, "id:vXl9j5qEnnOB"],Objects], (* Model[Container, Vessel, "2mL Cryogenic Vial"] *)
          Name -> functionName <> " test cryoVial "<> ToString[i] <>" " <> $SessionUUID,
          DeveloperObject -> True
        |>,
        {i,1,5}
      ],
      Sequence@@Table[
        <|
          Type -> Object[Container,Vessel],
          Model -> Link[Model[Container, Vessel, "id:BYDOjv1VAAxz"],Objects], (* Model[Container, Vessel, "5mL Tube"] *)
          Name -> functionName <> " test destination 5mL tube " <> ToString[i] <> " " <> $SessionUUID,
          DeveloperObject -> True
        |>,
        {i,1,4}
      ],
      <|
        Type -> Object[Container,Vessel],
        Model -> Link[Model[Container, Vessel, "id:xRO9n3BzE6nY"],Objects], (* Model[Container, Vessel, "2mL skirted self standing clear plastic tube "] *)
        Name -> functionName <> " test unaspiratable 2mL tube " <> $SessionUUID,
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container,Vessel],
        Model -> Link[Model[Container, Vessel, "id:xRO9n3BzE6nY"],Objects], (* Model[Container, Vessel, "2mL skirted self standing clear plastic tube "] *)
        Name -> functionName <> " test undispensable 2mL tube " <> $SessionUUID,
        DeveloperObject -> True
      |>,
      Sequence@@Table[
        <|
          Type -> Object[Container,Vessel],
          Model -> Link[Model[Container, Vessel, "id:Vrbp1jG800Zm"],Objects], (* Model[Container, Vessel, "Amber Glass Bottle 4 L"] *)
          Name -> functionName <> " test 4L amber glass bottle " <> ToString[i] <> " " <> $SessionUUID,
          DeveloperObject -> True
        |>,
        {i,1,2}
      ]
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

    testLBBroth = UploadStockSolution[
      {
        {20 Gram, Model[Sample, "LB Broth"]},
        {1 Liter, Model[Sample, "Milli-Q water"]}
      },
      Type -> Media,
      Autoclave -> False,
      DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
      Preparable -> False,
      Name -> functionName <> " test liquid LB Broth media model " <> $SessionUUID,
      ShelfLife -> 6 Month
    ];

    (* Create test Model[Cell]s *)
    {
      testEColi,
      testEColiHalfMatchFluorescentWavelengths,
      testEColiNoFluorescentWavelengths,
      testEColiNoPreferredLiquidMedia
    }=UploadBacterialCell[
      {
        functionName <> " test e.coli model - gfp Positive " <> $SessionUUID,
        functionName <> " test e.coli half match fluorescent wavelengths model - gfp Positive " <> $SessionUUID,
        functionName <> " test e.coli no fluorescent wavelengths model - gfp Positive " <> $SessionUUID,
        functionName <> " test e.coli model - gfp Positive - no PreferredLiquidMedia " <> $SessionUUID
      },
      Morphology -> Bacilli,
      CellLength -> 2 Micrometer,
      IncompatibleMaterials -> {None},
      CellType -> Bacterial,
      BiosafetyLevel -> "BSL-2",
      MSDSRequired -> False,
      CultureAdhesion -> SolidMedia,
      PreferredSolidMedia -> Link[testSolidLBMedia],
      PreferredLiquidMedia -> {
        Link[testLBBroth],
        Link[testLBBroth],
        Link[testLBBroth],
        Null
      },
      PreferredColonyHandlerHeadCassettes -> {
        Link[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"]],
        Link[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli"]],
        Link[Model[Part, ColonyHandlerHeadCassette, "24-pin picking head for E. coli"]]
      },
      FluorescentExcitationWavelength -> {
        {452 Nanometer, 505 Nanometer},
        {300 Nanometer, 505 Nanometer},
        Null,
        Null
      },
      FluorescentEmissionWavelength -> {
        {490 Nanometer, 545 Nanometer},
        {300 Nanometer, 400 Nanometer},
        Null,
        Null
      }
    ];

    (* Modify the output object because pour plate functionality is not currently implemented *)
    Upload[
      {
        <|
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
        |>,
        <|
          Object->testLBBroth,
          Replace[CellTypes] -> {
            Link[testEColi,PreferredLiquidMedia],
            Link[testEColiNoFluorescentWavelengths,PreferredLiquidMedia],
            Link[testEColiHalfMatchFluorescentWavelengths,PreferredLiquidMedia]
          },
          OrganismType -> Microbial,
          MSDSRequired -> False,
          State -> Liquid,
          DeveloperObject -> True
        |>
      }
    ];

    (* Create a solid media with eColi test sample model *)
    {
      testEColiSampleModel,
      testEColiNoFluorescentWavelengthsSampleModel,
      testEColiHalfMatchFluorescentWavelengthsSampleModel,
      testEColiSampleModelNoPreferredLiquidMedia,
      testGasSampleModel,
      testEColiLiquidCultureSampleModel,
      testIncompatibleSampleModel
    } = UploadSampleModel[
      {
        functionName <> " test e.coli and LB agar sample Model " <> $SessionUUID,
        functionName <> " test e.coli no fluorescent wavelengths and LB agar sample Model " <> $SessionUUID,
        functionName <> " test e.coli half match fluorescent wavelengths and LB agar sample Model " <> $SessionUUID,
        functionName <> " test e.coli no preferred liquid media and LB agar sample Model " <> $SessionUUID,
        functionName <> " test gas sample model " <> $SessionUUID,
        functionName <> " test liquid e.coli culture model " <> $SessionUUID,
        functionName <> " test incompatible sample model " <> $SessionUUID
      },
      Composition->{
        {
          {(1 Milligram)/(1000 Milliliter), testEColi},
          {100 VolumePercent, Model[Molecule, "Water"]},
          {(3 Gram)/(193 Milliliter), Model[Molecule, "Agarose"]}
        },
        {
          {(1 Milligram)/(1000 Milliliter), testEColiNoFluorescentWavelengths},
          {100 VolumePercent, Model[Molecule, "Water"]},
          {(3 Gram)/(193 Milliliter), Model[Molecule, "Agarose"]}
        },
        {
          {(1 Milligram)/(1000 Milliliter), testEColiHalfMatchFluorescentWavelengths},
          {100 VolumePercent, Model[Molecule, "Water"]},
          {(3 Gram)/(193 Milliliter), Model[Molecule, "Agarose"]}
        },
        {
          {(1 Milligram)/(1000 Milliliter), testEColiNoPreferredLiquidMedia},
          {100 VolumePercent, Model[Molecule, "Water"]},
          {(3 Gram)/(193 Milliliter), Model[Molecule, "Agarose"]}
        },
        {
          {100 VolumePercent, Model[Molecule, "Water"]}
        },
        {
          {90 MassPercent, Model[Molecule, "Nutrient Broth"]},
          {10 MassPercent, testEColi}
        },
        {
          {100 VolumePercent, Model[Molecule, "Water"]}
        }
      },
      Expires->{True,True,True,True,False,True,False},
      ShelfLife -> {2 Week,2 Week,2 Week,2 Week, Null,2 Week,Null},
      UnsealedShelfLife -> {1 Hour,1 Hour,1 Hour,1 Hour,Null,1 Hour,Null},
      DefaultStorageCondition->{
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Ambient Storage"]],
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Ambient Storage"]]
      },
      State->{Solid,Solid,Solid,Solid,Liquid,Liquid,Solid},
      BiosafetyLevel -> "BSL-1",
      Flammable -> False,
      MSDSRequired -> False,
      IncompatibleMaterials -> {
        {None},
        {None},
        {None},
        {None},
        {None},
        {None},
        {Nylon}
      },
      Living -> {True,True,True,True,False,True,False}
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
      eColiLiquidCulture1,
      eColiLiquidCulture2,
      eColiLiquidCulture3,
      eColiLiquidCulture4,
      agarStab1,
      agarStab2,
      agarStab3,
      agarStab4,
      liquidCultureSample3L,
      unaspiratableSample,
      noPreferredLiquidMediaSample,
      testIncompatibleInputSample
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
        testEColiLiquidCultureSampleModel,
        testEColiLiquidCultureSampleModel,
        testEColiLiquidCultureSampleModel,
        testEColiLiquidCultureSampleModel,
        testEColiSampleModel,
        testEColiSampleModel,
        testEColiSampleModel,
        testEColiSampleModel,
        testEColiLiquidCultureSampleModel,
        testEColiLiquidCultureSampleModel,
        testEColiSampleModelNoPreferredLiquidMedia,
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
        {"A1", dwp2},
        {"A1", dwp3},
        {"A1", dwp4},
        {"A1", dwp5},
        {"A1", cryoVial1},
        {"A1", cryoVial2},
        {"A1", cryoVial3},
        {"A1", cryoVial4},
        {"A1", amberGlassBottle4L1},
        {"A1", unaspiratable2mLTube},
        {"A1", cryoVial5},
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
          functionName <> " test e.coli half match fluorescent wavelengths sample 1 in omniTray" <> $SessionUUID
        },
        Table[
          functionName <> " test liquid e.coli culture " <> ToString[i] <>" in dwp " <> $SessionUUID,
          {i,1,4}
        ],
        Table[
          functionName <> " test e.coli stab " <> ToString[i] <>" in cryoVial " <> $SessionUUID,
          {i,1,4}
        ],
        {
          functionName <> " test LB Broth in 4L amber glass flask " <> $SessionUUID,
          functionName <> " test unaspiratable LB Broth sample in 2mL Tube " <> $SessionUUID,
          functionName <> " test e.coli stab 5 in cryoVial - no PreferredLiquidMedia " <> $SessionUUID,
          functionName <> " test incompatible input sample in omnitray " <> $SessionUUID
        }
      ],
      InitialAmount -> Join[
        ConstantArray[1 Gram, 8],
        {5 Milliliter},
        {400 Milliliter},
        {1 Gram},
        {1 Gram},
        ConstantArray[1 Milliliter, 4],
        ConstantArray[1 Gram, 4],
        {200 Milliliter},
        {2 Milliliter},
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
      eColiLiquidCulture1,
      eColiLiquidCulture2,
      eColiLiquidCulture3,
      eColiLiquidCulture4,
      agarStab1,
      agarStab2,
      agarStab3,
      agarStab4,
      liquidCultureSample3L,
      unaspiratableSample,
      noPreferredLiquidMediaSample,
      testIncompatibleInputSample
    };
    Upload[developerObjectPackets];
  ];
];