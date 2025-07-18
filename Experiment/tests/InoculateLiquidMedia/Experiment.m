(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Section::Closed:: *)
(* Unit Testing *)

(* ::Subsection::Closed:: *)
(* ExperimentInoculateLiquidMedia *)

DefineTests[ExperimentInoculateLiquidMedia,
  {
    (* --- Basic --- *)
    Example[{Basic, "Generate a RoboticCellPreparation protocol for SolidMedia bacterial cells on a single plate:"},
      ExperimentInoculateLiquidMedia[Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID]],
      ObjectP[Object[Protocol, RoboticCellPreparation]]
    ],
    Example[{Basic, "Generate a RoboticCellPreparation protocol for SolidMedia bacterial cells on multiple plates:"},
      ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]]
    ],
    Example[{Basic, "Generate a RoboticCellPreparation protocol using a single bacterial SolidMedia plate as input:"},
      ExperimentInoculateLiquidMedia[Object[Container, Plate, "ExperimentInoculateLiquidMedia test omniTray 1 " <> $SessionUUID]],
      ObjectP[Object[Protocol, RoboticCellPreparation]]
    ],
    Example[{Basic, "Generate a RoboticCellPreparation protocol using multiple single bacterial SolidMedia plates as input:"},
      ExperimentInoculateLiquidMedia[
        {
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test omniTray 1 " <> $SessionUUID],
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test omniTray 2 " <> $SessionUUID]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]]
    ],
    Example[{Basic, "Generate a RoboticCellPreparation protocol using a SolidMedia plate with well position as input:"},
      ExperimentInoculateLiquidMedia[
        {
          "A1",
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test omniTray 1 " <> $SessionUUID]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]]
    ],
    Example[{Basic, "Generate a RoboticCellPreparation protocol for LiquidMedia bacterial cells in a single plate:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        Preparation -> Robotic
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]]
    ],
    Example[{Basic, "Generate an InoculateLiquidMedia protocol for LiquidMedia bacterial cells in a single plate:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        Preparation -> Manual
      ],
      ObjectP[Object[Protocol, InoculateLiquidMedia]]
    ],
    Example[{Basic, "Generate an InoculateLiquidMedia protocol for bacterial cells in AgarStab:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, InoculateLiquidMedia]]
    ],
    Example[{Basic, "Generate an InoculateLiquidMedia protocol for FreezeDried bacterial cells:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, InoculateLiquidMedia]]
    ],
    Example[{Basic, "Generate an InoculateLiquidMedia protocol for bacterial cells in FrozenGlycerol:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, InoculateLiquidMedia]]
    ],
    Example[{Basic, "Generate an InoculateLiquidMedia protocol for mammalian cells in FrozenGlycerol:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test Mammalian sample in frozen glycerol in cryoVial " <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, InoculateLiquidMedia]]
    ],
    Example[{Basic, "Generate an InoculateLiquidMedia protocol if the source is a model of FreezeDried sample:"},
      ExperimentInoculateLiquidMedia[
        Model[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli sample Model " <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, InoculateLiquidMedia]],
      (* Need to populate the products of the model for it to work *)
      SetUp :> {
        UploadProduct[
          Name -> "ExperimentInoculateLiquidMedia test freeze dried e.coli sample Model Product " <> $SessionUUID,
          Packaging -> Single,
          SampleType -> Vial,
          ProductModel -> Model[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli sample Model " <> $SessionUUID],
          NumberOfItems -> 1,
          Amount -> 1 Gram,
          DefaultContainerModel -> Model[Container, Vessel, "5mL small glass vial aluminum cap"],
          CatalogNumber -> "88888",
          Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
          Price -> 100 USD,
          CatalogDescription -> "Test Ecoli FreezeDried product"
        ],
        UploadNotebook[Object[Product, "ExperimentInoculateLiquidMedia test freeze dried e.coli sample Model Product " <> $SessionUUID], Null]
      },
      TearDown :> (EraseObject[
        {Object[Product, "ExperimentInoculateLiquidMedia test freeze dried e.coli sample Model Product " <> $SessionUUID]},
        Force -> True,
        Verbose -> False
      ])
    ],
    Example[{Basic, "Generate an InoculateLiquidMedia protocol if the source is a model of AgarStab sample:"},
      ExperimentInoculateLiquidMedia[
        Model[Sample, "ExperimentInoculateLiquidMedia test e.coli and LB agar sample Model " <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, InoculateLiquidMedia]],
      (*Need to populate the products of the model for it to work*)
      SetUp :> {
        UploadProduct[
          Name -> "ExperimentInoculateLiquidMedia test e.coli and LB agar sample Model Product " <> $SessionUUID,
          Packaging -> Single,
          SampleType -> Vial,
          ProductModel -> Model[Sample, "ExperimentInoculateLiquidMedia test e.coli and LB agar sample Model " <> $SessionUUID],
          NumberOfItems -> 1,
          Amount -> 1 Gram,
          DefaultContainerModel -> Model[Container, Vessel, "id:vXl9j5qEnnOB"], (* Model[Container, Vessel, "2mL Cryogenic Vial"] *)
          CatalogNumber -> "88888",
          Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
          Price -> 100 USD,
          CatalogDescription -> "Test Ecoli AgarStab product"
        ],
        UploadNotebook[Object[Product, "ExperimentInoculateLiquidMedia test e.coli and LB agar sample Model Product " <> $SessionUUID], Null]
      },
      TearDown :> (EraseObject[
        {Object[Product, "ExperimentInoculateLiquidMedia test e.coli and LB agar sample Model Product " <> $SessionUUID]},
        Force -> True,
        Verbose -> False
      ])
    ],
    Example[{Basic, "Generate an InoculateLiquidMedia protocol if the source is a model of FrozenGlycerol sample:"},
      ExperimentInoculateLiquidMedia[
        Model[Sample, "ExperimentInoculateLiquidMedia test e.coli in 50% frozen glycerol sample Model " <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, InoculateLiquidMedia]],
      (*Need to populate the products of the model for it to work*)
      SetUp :> {
        UploadProduct[
          Name -> "ExperimentInoculateLiquidMedia test e.coli in 50% frozen glycerol sample Model Product " <> $SessionUUID,
          Packaging -> Single,
          SampleType -> Vial,
          ProductModel -> Model[Sample, "ExperimentInoculateLiquidMedia test e.coli in 50% frozen glycerol sample Model " <> $SessionUUID],
          NumberOfItems -> 1,
          Amount -> 1 Gram,
          DefaultContainerModel -> Model[Container, Vessel, "id:vXl9j5qEnnOB"], (* Model[Container, Vessel, "2mL Cryogenic Vial"] *)
          CatalogNumber -> "88888",
          Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
          Price -> 100 USD,
          CatalogDescription -> "Test Ecoli frozen glycerol product"
        ],
        UploadNotebook[Object[Product, "ExperimentInoculateLiquidMedia test e.coli in 50% frozen glycerol sample Model Product " <> $SessionUUID], Null]
      },
      TearDown :> (EraseObject[
        {Object[Product, "ExperimentInoculateLiquidMedia test e.coli in 50% frozen glycerol sample Model Product " <> $SessionUUID]},
        Force -> True,
        Verbose -> False
      ])
    ],

    (* Section: ---------------------------------------------------- Options ----------------------------------------------------------------------- *)
    (* Unit tests for options are displayed in the same order as their appearance in DefineOptions *)
    (* InoculationSource *)
    Example[{Options, InoculationSource, "InoculationSource is automatically set to SolidMedia if the state of the input sample is Solid and in a Plate:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        Output -> Options
      ],
      KeyValuePattern[{
        InoculationSource -> SolidMedia
      }]
    ],
    Example[{Options, InoculationSource, "InoculationSource is automatically set to LiquidMedia if the state of the input sample is Liquid:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        Output -> Options
      ],
      KeyValuePattern[{
        InoculationSource -> LiquidMedia
      }]
    ],
    Example[{Options, InoculationSource, "InoculationSource is automatically set to AgarStab if the state of the input sample is Solid and in a Vessel:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
        Output -> Options
      ],
      KeyValuePattern[{
        InoculationSource -> AgarStab
      }]
    ],
    Example[{Options, InoculationSource, "InoculationSource is automatically set to FreezeDried if the state of the input sample is Solid and in a hermetic or Ampoule container:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        Output -> Options
      ],
      KeyValuePattern[{
        InoculationSource -> FreezeDried
      }]
    ],
    Example[{Options, InoculationSource, "InoculationSource is automatically set to FrozenGlycerol if the state of the input sample is Solid and kept in deep freezer or cryogenic storage condition:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
        Output -> Options
      ],
      KeyValuePattern[{
        InoculationSource -> FrozenGlycerol
      }]
    ],
    (* Instrument *)
    Example[{Options, Instrument, "Specify a Model[Instrument,Pipette]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> AgarStab,
          Instrument -> Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Microbial"],
          Output -> Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Microbial"]]
    ],
    Example[{Options, Instrument, "Specify an Instrument for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 2 in cryoVial " <> $SessionUUID]
          },
          InoculationSource -> AgarStab,
          Instrument -> {
            Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Microbial"],
            Model[Instrument, Pipette, "Eppendorf Research Plus P200, Microbial"]
          },
          Output -> Options
        ],
        Instrument
      ],
      {ObjectP[Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Microbial"]], ObjectP[Model[Instrument, Pipette, "Eppendorf Research Plus P200, Microbial"]]}
    ],
    Example[{Options, Instrument, "If InoculationSource is SolidMedia, Instrument is automatically set to a ColonyHandler:"},
      {options, protocol} = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        Output -> {Options, Result}
      ];
      {Lookup[options, Instrument], Download[protocol, ColonyHandler]},
      (* Make sure the option input is indexmatching, while also able to generate the protocol with ColonyHandler populated with a single colony handler *)
      {
        ObjectP[Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"]],
        ObjectP[Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"]] (* Model[Instrument, ColonyHandler, "QPix 420 HT"] *)
      },
      Variables :> {options, protocol}
    ],
    Example[{Options, Instrument, "If InoculationSource is LiquidMedia and Preparation is Robotic, Instrument is automatically set to a LiquidHandler:"},
      {options, protocol} = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        Preparation -> Robotic,
        Output -> {Options, Result}
      ];
      {Lookup[options, Instrument], Download[protocol, LiquidHandler]},
      (* Make sure the option input is indexmatching, while also able to generate the protocol with ColonyHandler populated with a single liquid handler *)
      {
        ObjectP[Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]],
        ObjectP[Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]] (* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
      },
      Variables :> {options, protocol}
    ],
    Example[{Options, Instrument, "If InoculationSource is LiquidMedia and Preparation is Manual, Instrument is automatically set to a Model[Instrument,Pipette] based on Volume:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          Volume -> 100 Microliter,
          InoculationSource -> LiquidMedia,
          Output -> Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "Eppendorf Research Plus P200, Microbial"]]
    ],
    Example[{Options, Instrument, "If InoculationSource is LiquidMedia and InoculationTips is specified, Instrument is automatically set to corresponding Model[Instrument,Pipette]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          InoculationTips -> Model[Item, Tips, "200 uL tips, sterile"],
          Output -> Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "Eppendorf Research Plus P200, Microbial"]]
    ],
    Example[{Options, Instrument, "If InoculationSource is AgarStab, Instrument is automatically set to a Model[Instrument,Pipette]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> AgarStab,
          Output -> Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "id:GmzlKjP3boWe"]] (* Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Microbial"] *)
    ],
    Example[{Options, Instrument, "If InoculationSource is FreezeDried, Instrument is automatically set to a P1000 Pipette:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          InoculationSource -> FreezeDried,
          Output -> Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Microbial"]]
    ],
    Example[{Options, Instrument, "If InoculationSource is FrozenGlycerol and sample cell type is Microbial, Instrument is automatically set to Eppendorf Research Plus P1000, Microbial:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> FrozenGlycerol,
          Output -> Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "id:GmzlKjP3boWe"]] (* Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Microbial"] *)
    ],
    Example[{Options, Instrument, "If InoculationSource is FrozenGlycerol and sample cell type is Mammalian, Instrument is automatically set to Eppendorf Research Plus P1000, Tissue Culture:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test Mammalian sample in frozen glycerol in cryoVial " <> $SessionUUID],
          InoculationSource -> FrozenGlycerol,
          Output -> Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "id:AEqRl9Ko8XWR"]] (* Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Tissue Culture"] *)
    ],
    (* TransferEnvironment *)
    Example[{Options, TransferEnvironment, "TransferEnvironment automatically resolves to Null if InoculationSource is SolidMedia:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        TransferEnvironment
      ],
      Null
    ],
    Example[{Options, TransferEnvironment, "TransferEnvironment automatically resolves to Null if Preparation is Robotic:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Preparation -> Robotic,
          Output -> Options
        ],
        TransferEnvironment
      ],
      Null
    ],
    Example[{Options, TransferEnvironment, "TransferEnvironment automatically resolves to Model[Instrument, BiosafetyCabinet, \"Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Microbial)\"] if InoculationSource is LiquidMedia, input sample cell type is microbial, and Preparation is Manual:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Preparation -> Manual,
          Output -> Options
        ],
        TransferEnvironment
      ],
      ObjectP[Model[Instrument, BiosafetyCabinet, "id:WNa4ZjKZpBeL"]](* Model[Instrument, BiosafetyCabinet, "Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Microbial)"] *)
    ],
    Example[{Options, TransferEnvironment, "TransferEnvironment automatically resolves to Model[Instrument, BiosafetyCabinet, \"Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Tissue Culture)\"] if InoculationSource is LiquidMedia, input sample cell type is not microbial, and Preparation is Manual:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid Mammalian sample in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Preparation -> Manual,
          Output -> Options
        ],
        TransferEnvironment
      ],
      ObjectP[Model[Instrument, BiosafetyCabinet, "id:dORYzZJzEBdE"]](* Model[Instrument, BiosafetyCabinet, "Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Tissue Culture)"] *)
    ],
    Example[{Options, TransferEnvironment, "TransferEnvironment is Model[Instrument, BiosafetyCabinet, \"Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Microbial)\"] if cell type is Microbial and Preparation is Manual:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> AgarStab,
          Output -> Options
        ],
        TransferEnvironment
      ],
      ObjectP[Model[Instrument, BiosafetyCabinet, "id:WNa4ZjKZpBeL"]] (* Model[Instrument, BiosafetyCabinet, "Thermo Scientific 1300 Series Class II,Type A2 Biosafety Cabinet (Microbial)"] *)
    ],
    Example[{Options, TransferEnvironment, "TransferEnvironment is Model[Instrument, BiosafetyCabinet, \" Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Tissue Culture) \"] if input sample cell type is non-microbial and Preparation is Manual:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test FreezeDried Mammalian sample in ampoule " <> $SessionUUID],
          InoculationSource -> FreezeDried,
          Output -> Options
        ],
        TransferEnvironment
      ],
      ObjectP[Model[Instrument, BiosafetyCabinet, "id:dORYzZJzEBdE"]](* Model[Instrument, BiosafetyCabinet, "Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Tissue Culture)"] *)
    ],
    (* Section: InoculationTips *)
    Example[{Options, InoculationTips, "If InoculationSource is SolidMedia, InoculationTips automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        InoculationTips
      ],
      Null
    ],
    Example[{Options, InoculationTips, "Specify the InoculationTips to use for the inoculation:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Volume -> 0.5 Milliliter,
          InoculationTips -> Model[Item, Tips, "id:n0k9mGzRaaN3"],
          Output -> Options
        ],
        InoculationTips
      ],
      ObjectP[Model[Item, Tips, "id:n0k9mGzRaaN3"]] (* Model[Item, Tips, "1000 uL reach tips, sterile"] *)
    ],
    Example[{Options, InoculationTips, "Specify the InoculationTips to use for the inoculation for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource -> LiquidMedia,
          Volume -> 0.1 Milliliter,
          InoculationTips -> {Model[Item, Tips, "id:n0k9mGzRaaN3"], Model[Item, Tips, "id:P5ZnEj4P88jR"]},
          Output -> Options
        ],
        InoculationTips
      ],
      {ObjectP[Model[Item, Tips, "id:n0k9mGzRaaN3"]], ObjectP[Model[Item, Tips, "id:P5ZnEj4P88jR"]]} (* Model[Item, Tips, "1000 uL reach tips, sterile"], Model[Item, Tips, "200 uL tips, sterile"] *)
    ],
    Example[{Options, InoculationTips, "If InoculationSource is not SolidMedia, InoculationTips is automatically resolve to the matching tips for specified Instrument:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource -> LiquidMedia,
          Volume -> 0.1 Milliliter,
          Instrument -> {
            Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Microbial"],
            Model[Instrument, Pipette, "Eppendorf Research Plus P200, Microbial"]
          },
          Output -> Options
        ],
        InoculationTips
      ],
      {ObjectP[Model[Item, Tips, "id:n0k9mGzRaaN3"]], ObjectP[Model[Item, Tips, "id:P5ZnEj4P88jR"]]} (* Model[Item, Tips, "1000 uL reach tips, sterile"], Model[Item, Tips, "200 uL tips, sterile"] *)
    ],
    Example[{Options, {Instrument, InoculationTips}, "If InoculationSource is AgarStab, InoculationTips automatically resolves to a P1000 pipette if it can reach the bottom of DestinationMediaContainer:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> AgarStab,
          DestinationMediaContainer -> Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
          Output -> Options
        ],
        {Instrument, InoculationTips}
      ],
      {
        ObjectP[Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Microbial"]],
        ObjectP[Model[Item, Tips, "1000 uL reach tips, sterile"]]
      }
    ],
    Example[{Options, {Instrument, InoculationTips}, "If InoculationSource is AgarStab, InoculationTips automatically resolves to a serological pipette if DestinationMediaContainer is deep:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> AgarStab,
          DestinationMediaContainer -> Model[Container, Vessel, "1000mL Erlenmeyer Flask"],
          Output -> Options
        ],
        {Instrument, InoculationTips}
      ],
      {
        ObjectP[Model[Instrument, Pipette, "pipetus, Microbial"]],
        ObjectP[Model[Item, Tips, "1 mL glass barrier serological pipets, sterile"]]
      }
    ],
    Example[{Options, Instrument, "If InoculationSource is FreezeDried, InoculationTips automatically resolves to 1000 uL reach tips, sterile:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          InoculationSource -> FreezeDried,
          Output -> Options
        ],
        InoculationTips
      ],
      ObjectP[Model[Item, Tips, "1000 uL reach tips, sterile"]]
    ],
    Example[{Options, Instrument, "If InoculationSource is FrozenGlycerol, InoculationTips automatically resolves to 1000 uL reach tips, sterile:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test Mammalian sample in frozen glycerol in cryoVial " <> $SessionUUID],
          InoculationSource -> FrozenGlycerol,
          Output -> Options
        ],
        InoculationTips
      ],
      ObjectP[Model[Item, Tips, "1000 uL reach tips, sterile"]]
    ],
    (* Section: Volume *)
    Example[{Options, Volume, "If InoculationSource is LiquidMedia, automatically set Volume to 1/12th of the MaxVol of DestinationMediaContainer if 1/10th of sample volume is bigger:"},
      {options, protocol} = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in 500 mL flask " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        DestinationMediaContainer -> Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
        Output -> {Options, Result}
      ];
      (* Make sure the option input is respected, while also able to generate the protocol with TransferVolumes populated with an actual volume *)
      {
        Lookup[options, Volume],
        Download[protocol, TransferVolumes]
      },
      {
        RangeP[1.1 Milliliter, 1.2 Milliliter],
        {RangeP[1.1 Milliliter, 1.2 Milliliter]}
      },
      Variables :> {options, protocol}
    ],
    Example[{Options, Volume, "If InoculationSource is LiquidMedia, automatically set Volume to 1/10th of sample volume if 1/12th of the MaxVol of DestinationMediaContainer is bigger:"},
      {options, protocol} = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        DestinationMediaContainer -> Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
        Output -> {Options, Result}
      ];
      (* Make sure the option input is respected, while also able to generate the protocol with TransferVolumes populated with an actual volume *)
      {
        Lookup[options, Volume],
        Download[protocol, TransferVolumes]
      },
      {
        EqualP[0.1 Milliliter],
        {EqualP[0.1 Milliliter]}
      },
      Variables :> {options, protocol}
    ],
    Example[{Options, Volume, "If InoculationSource is LiquidMedia, set Volume to All to transfer all of the media in the input sample:"},
      {options, protocol} = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        Volume -> All,
        Output -> {Options, Result}
      ];
      (* Make sure the option input is respected, while also able to generate the protocol with TransferVolumes populated with an actual volume *)
      {
        Lookup[options, Volume],
        Download[protocol, TransferVolumes]
      },
      {
        All,
        {EqualP[1 Milliliter]}
      },
      Variables :> {options, protocol}
    ],
    Example[{Options, Volume, "If InoculationSource is LiquidMedia, specify a different Volume for each input sample:"},
      {options, protocol} = ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 2 in dwp " <> $SessionUUID]
        },
        InoculationSource -> LiquidMedia,
        Volume -> {0.5 Milliliter, 0.3 Milliliter},
        Output -> {Options, Result}
      ];
      (* Make sure the option input is respected, while also able to generate the protocol with TransferVolumes populated with an actual volume *)
      {
        Lookup[options, Volume],
        Download[protocol, TransferVolumes]
      },
      {
        {EqualP[0.5 Milliliter], EqualP[0.3 Milliliter]},
        {EqualP[0.5 Milliliter], EqualP[0.3 Milliliter]}
      }
    ],
    Example[{Options, Volume, "If InoculationSource is FreezeDried, automatically set Volume to All to transfer all of the resuspension if only one DestinationMediaContainer:"},
      {options, protocol} = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        InoculationSource -> FreezeDried,
        DestinationMediaContainer -> Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
        Output -> {Options, Result}
      ];
      (* Make sure the option input is respected, while also able to generate the protocol with TransferVolumes populated with an actual volume *)
      {
        Lookup[options, Volume],
        Download[protocol, TransferVolumes]
      },
      {
        All,
        {VolumeP}
      },
      Variables :> {options, protocol}
    ],
    Example[{Options, Volume, "If InoculationSource is FreezeDried, automatically set Volume to ResuspensionMediaVolume divided equally by the number of DestinationMediaContainer:"},
      {options, protocol} = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        InoculationSource -> FreezeDried,
        ResuspensionMediaVolume -> 1 Milliliter,
        DestinationMediaContainer -> {{Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"], Model[Container, Vessel, "50mL Tube"]}},
        Output -> {Options, Result}
      ];
      (* Make sure the option input is respected, while also able to generate the protocol with TransferVolumes populated with an actual volume *)
      {
        Lookup[options, Volume],
        Download[protocol, TransferVolumes]
      },
      {
        EqualP[0.5 Milliliter],
        {EqualP[0.5 Milliliter], EqualP[0.5 Milliliter]}
      },
      Variables :> {options, protocol}
    ],
    (* Section: DestinationMedia related options for all inoculation sources *)
    Test["If InoculationSource is SolidMedia, Destination options are fully nested:",
      protocol = ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
        },
        DestinationMix -> {True, False}
      ];
      Download[
        protocol[OutputUnitOperations][[1]],
        {
          DestinationMediaExpression,
          MediaVolumeExpression,
          DestinationMix,
          DestinationMixType,
          DestinationMixVolumeExpression,
          DestinationNumberOfMixesExpression,
          DestinationMediaContainerExpression,
          DestinationWell
        }
      ],
      {
        {{ObjectP[]}, {ObjectP[]}},
        {{VolumeP}, {VolumeP}},
        {{True}, {False}},
        {{Shake}, {Null}},
        {{Null}, {Null}},
        {{5}, {Null}},
        {{ObjectP[]}, {ObjectP[]}},
        {{Null}, {Null}}
      },
      Variables :> {protocol}
    ],
    Test["If InoculationSource is LiquidMedia, Destination options are fully nested:",
      protocol = ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 2 in dwp " <> $SessionUUID]
        },
        DestinationMix -> {True, False}
      ];
      Lookup[
        protocol[ResolvedOptions],
        {
          DestinationMedia,
          MediaVolume,
          DestinationMix,
          DestinationMixType,
          DestinationMixVolume,
          DestinationNumberOfMixes,
          DestinationMediaContainer,
          DestinationWell
        }
      ],
      {
        {{ObjectP[]}, {ObjectP[]}},
        {{VolumeP}, {VolumeP}},
        {{True}, {False}},
        {{Pipette}, {Null}},
        {{VolumeP}, {Null}},
        {{5}, {Null}},
        {{ObjectP[]}, {ObjectP[]}},
        {{"A1"}, {"A1"}}
      },
      Variables :> {protocol}
    ],
    Test["If InoculationSource is AgarStab, Destination options are fully nested:",
      protocol = ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 2 in cryoVial " <> $SessionUUID]
        },
        DestinationMedia -> {
          Model[Sample, Media, "ExperimentInoculateLiquidMedia test liquid LB Broth media model " <> $SessionUUID],
          Model[Sample, Media, "LB Broth, Miller"]
        }
      ];
      Lookup[
        protocol[ResolvedOptions],
        {
          DestinationMedia,
          MediaVolume,
          DestinationMix,
          DestinationMixType,
          DestinationMixVolume,
          DestinationNumberOfMixes,
          DestinationMediaContainer,
          DestinationWell
        }
      ],
      {
        {{ObjectP[]}, {ObjectP[]}},
        {{VolumeP}, {VolumeP}},
        {{True}, {True}},
        {{Pipette}, {Pipette}},
        {{VolumeP}, {VolumeP}},
        {{5}, {5}},
        {{ObjectP[]}, {ObjectP[]}},
        {{"A1"}, {"A1"}}
      },
      Variables :> {protocol}
    ],
    Test["If InoculationSource is FreezeDried, Destination options are fully nested:",
      protocol = ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 2 in ampoule " <> $SessionUUID]
        },
        DestinationMix -> {True, False}
      ];
      Lookup[
        protocol[ResolvedOptions],
        {
          DestinationMedia,
          MediaVolume,
          DestinationMix,
          DestinationMixType,
          DestinationMixVolume,
          DestinationNumberOfMixes,
          DestinationMediaContainer,
          DestinationWell
        }
      ],
      {
        {{ObjectP[]}, {ObjectP[]}},
        {{VolumeP}, {VolumeP}},
        {{True}, {False}},
        {{Pipette}, {Null}},
        {{VolumeP}, {Null}},
        {{5}, {Null}},
        {{ObjectP[]}, {ObjectP[]}},
        {{"A1"}, {"A1"}}
      },
      Variables :> {protocol}
    ],
    Test["If InoculationSource is FreezeDried and multiple DestinationMediaContainers are specified, SamplesIn are expanded:",
      protocol = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        ResuspensionMediaVolume -> 1 Milliliter,
        Volume -> 0.5 Milliliter,
        DestinationMediaContainer -> {{
          Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
          Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"]
        }},
        DestinationMix -> {{True, False}}
      ];
      Download[
        protocol,
        {
          SamplesIn,
          DestinationMedia,
          MediaVolumes,
          DestinationMixTypes,
          DestinationMixVolumes,
          DestinationNumberOfMixes,
          DestinationMediaContainers,
          DestinationWells
        }
      ],
      {
        {ObjectP[Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID]], ObjectP[Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID]]},
        {ObjectP[], ObjectP[]},
        {VolumeP, VolumeP},
        {Pipette, Null},
        {VolumeP, Null},
        {5, Null},
        {ObjectP[], ObjectP[]},
        {"A1", "A1"}
      },
      Variables :> {protocol}
    ],
    Test["If InoculationSource is FrozenGlycerol, Destination options are fully nested:",
      protocol = ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 2 in cryoVial " <> $SessionUUID]
        },
        DestinationMedia -> {
          Model[Sample, Media, "ExperimentInoculateLiquidMedia test liquid LB Broth media model " <> $SessionUUID],
          Model[Sample, Media, "LB Broth, Miller"]
        }
      ];
      Lookup[
        protocol[ResolvedOptions],
        {
          DestinationMedia,
          MediaVolume,
          DestinationMix,
          DestinationMixType,
          DestinationMixVolume,
          DestinationNumberOfMixes,
          DestinationMediaContainer,
          DestinationWell
        }
      ],
      {
        {{ObjectP[Model[Sample, Media, "ExperimentInoculateLiquidMedia test liquid LB Broth media model " <> $SessionUUID]]}, {ObjectP[Model[Sample, Media, "LB Broth, Miller"]]}},
        {{VolumeP}, {VolumeP}},
        {{True}, {True}},
        {{Pipette}, {Pipette}},
        {{EqualP[1000Microliter]}, {EqualP[1000Microliter]}},
        {{5}, {5}},
        {{ObjectP[]}, {ObjectP[]}},
        {{"A1"}, {"A1"}}
      },
      Variables :> {protocol}
    ],
    Example[{Options, DestinationMix, "DestinationMix defaults to True for any type of InoculationSource:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          Output -> Options
        ],
        DestinationMix
      ],
      True
    ],
    Example[{Options, DestinationMix, "Set DestinationMix for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource -> LiquidMedia,
          DestinationMix -> {True, False},
          Output -> Options
        ],
        DestinationMix
      ],
      {{True}, {False}}
    ],
    Example[{Options, DestinationMix, "If InoculationSource is SolidMedia, set DestinationMix for each population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations -> {
            {Diameter[], Fluorescence[]},
            {Diameter[]}
          },
          DestinationMix -> {
            {True, False},
            {True}
          },
          Output -> Options
        ],
        DestinationMix
      ],
      {
        {True, False},
        {True}
      }
    ],
    Example[{Options, DestinationMixType, "If InoculationSource is LiquidMedia, DestinationMixType is automatically set to Pipette:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Output -> Options
        ],
        DestinationMixType
      ],
      Pipette
    ],
    Example[{Options, DestinationMixType, "If InoculationSource is SolidMedia, DestinationMixType is automatically set to Shake:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        DestinationMixType
      ],
      Shake
    ],
    Example[{Options, DestinationMixType, "If InoculationSource is AgarStab, DestinationMixType is automatically set to Pipette:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> AgarStab,
          Output -> Options
        ],
        DestinationMixType
      ],
      Pipette
    ],
    Example[{Options, DestinationMixType, "If InoculationSource is FreezeDried, DestinationMixType is automatically set to Pipette:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          InoculationSource -> FreezeDried,
          Output -> Options
        ],
        DestinationMixType
      ],
      Pipette
    ],
    Example[{Options, DestinationMixType, "If InoculationSource is FrozenGlycerol, DestinationMixType is automatically set to Pipette:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> FrozenGlycerol,
          Output -> Options
        ],
        DestinationMixType
      ],
      Pipette
    ],
    Example[{Options, DestinationMixType, "Set DestinationMixType for each sample. Setting options not used by this mix type to Null would not trigger error messages:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource -> LiquidMedia,
          DestinationMixType -> {Pipette, Swirl},
          DestinationMixVolume -> {Automatic, Null},
          Output -> Options
        ],
        DestinationMixType
      ],
      {{Pipette}, {Swirl}}
    ],
    Example[{Options, DestinationMixType, "If InoculationSource is SolidMedia, set DestinationMixType for each population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations -> {
            {Diameter[], Fluorescence[NumberOfColonies -> 20]},
            {Diameter[]}
          },
          DestinationMix -> {
            {True, False},
            {True}
          },
          DestinationMixType -> {
            {Shake, Null},
            {Shake}
          },
          Output -> Options
        ],
        DestinationMixType
      ],
      {
        {Shake, Null},
        {Shake}
      }
    ],
    Example[{Options, DestinationNumberOfMixes, "DestinationNumberOfMixes is automatically set to 5 for all type of InoculationSource:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          Output -> Options
        ],
        DestinationNumberOfMixes
      ],
      5
    ],
    Example[{Options, DestinationNumberOfMixes, "Set DestinationNumberOfMixes for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 2 in cryoVial " <> $SessionUUID]
          },
          InoculationSource -> AgarStab,
          DestinationNumberOfMixes -> {10, 20},
          Output -> Options
        ],
        DestinationNumberOfMixes
      ],
      {{10}, {20}}
    ],
    Example[{Options, DestinationNumberOfMixes, "If InoculationSource is SolidMedia, set DestinationNumberOfMixes for each population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          Populations -> {
            {Diameter[], Fluorescence[NumberOfColonies -> 10]},
            {Diameter[]}
          },
          DestinationNumberOfMixes -> {
            {3, 20},
            {30}
          },
          Output -> Options
        ],
        DestinationNumberOfMixes
      ],
      {
        {3, 20},
        {30}
      }
    ],
    Example[{Options, DestinationMixVolume, "If InoculationSource is SolidMedia, DestinationMixVolume is automatically set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        DestinationMixVolume
      ],
      Null
    ],
    Example[{Options, DestinationMixVolume, "If InoculationSource is LiquidMedia and Preparation is Robotic, DestinationMixVolume is less than $MaxRoboticSingleTransferVolume:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Preparation -> Robotic,
          Output -> Options
        ],
        DestinationMixVolume
      ],
      LessEqualP[$MaxRoboticSingleTransferVolume]
    ],
    Example[{Options, DestinationMixVolume, "If InoculationSource is LiquidMedia and Preparation is Manual, DestinationMixVolume is less than the max vol of specified InoculationTips:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          InoculationTips -> Model[Item, Tips, "200 uL tips, sterile"],
          Output -> Options
        ],
        DestinationMixVolume
      ],
      LessEqualP[200 Microliter]
    ],
    Example[{Options, DestinationMixVolume, "If InoculationSource is AgarStab, DestinationMixVolume is automatically set to 1 Milliliter:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> AgarStab,
          Output -> Options
        ],
        DestinationMixVolume
      ],
      EqualP[1 Milliliter]
    ],
    Example[{Options, DestinationMixVolume, "If InoculationSource is FreezeDried, DestinationMixVolume is automatically set to 1 Milliliter:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          InoculationSource -> FreezeDried,
          Output -> Options
        ],
        DestinationMixVolume
      ],
      EqualP[1 Milliliter]
    ],
    Example[{Options, DestinationMixVolume, "If InoculationSource is FrozenGlycerol, DestinationMixVolume is automatically set to 1 Milliliter:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> FrozenGlycerol,
          Output -> Options
        ],
        DestinationMixVolume
      ],
      EqualP[1 Milliliter]
    ],
    Example[{Options, MediaVolume, "If InoculationSource is SolidMedia, specify MediaVolume for each population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          Populations -> {
            {Diameter[], Fluorescence[NumberOfColonies -> 10]},
            {Diameter[]}
          },
          MediaVolume -> {
            {0.7 Milliliter, 0.5 Milliliter},
            {1 Milliliter}
          },
          Output -> Options
        ],
        MediaVolume
      ],
      {
        {RangeP[0.7 Milliliter], RangeP[0.5 Milliliter]},
        {RangeP[1 Milliliter]}
      }
    ],
    Example[{Options, MediaVolume, "If InoculationSource is SolidMedia, MediaVolume is automatically resolve to the recommended fill volume or 40% of the MaxVolume of the DestinationMediaContainer:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          DestinationMediaContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
          Output -> Options
        ],
        MediaVolume
      ],
      LessEqualP[$MaxRoboticSingleTransferVolume]
    ],
    Example[{Options, MediaVolume, "If InoculationSource is LiquidMedia, MediaVolume is automatically set to 40% of the MaxVolume of the DestinationMediaContainer if 5 times Volume is bigger:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in 500 mL flask " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Volume -> 2 Milliliter,
          DestinationMediaContainer -> Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
          Output -> Options
        ],
        MediaVolume
      ],
      EqualP[5.6 Milliliter]
    ],
    Example[{Options, MediaVolume, "If InoculationSource is LiquidMedia, MediaVolume is automatically set to 5 times Volume if 40% of the MaxVolume of the DestinationMediaContainer is bigger:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Volume -> 1 Milliliter,
          DestinationMediaContainer -> Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
          Output -> Options
        ],
        MediaVolume
      ],
      EqualP[5 Milliliter]
    ],
    Example[{Options, MediaVolume, "If InoculationSource is AgarStab, MediaVolume is automatically set to 40% of the MaxVolume of the DestinationMediaContainer:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> AgarStab,
          DestinationMediaContainer -> Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
          Output -> Options
        ],
        MediaVolume
      ],
      EqualP[5.6 Milliliter]
    ],
    Example[{Options, MediaVolume, "If InoculationSource is FreezeDried, MediaVolume is automatically set to 5 times of Volume:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          InoculationSource -> FreezeDried,
          Volume -> 0.5 Milliliter,
          DestinationMediaContainer -> Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
          Output -> Options
        ],
        MediaVolume
      ],
      EqualP[2.5 Milliliter]
    ],
    Example[{Options, MediaVolume, "If InoculationSource is FrozenGlycerol, MediaVolume is automatically set to 40% of the MaxVolume of the DestinationMediaContainer:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> FrozenGlycerol,
          DestinationMediaContainer -> Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
          Output -> Options
        ],
        MediaVolume
      ],
      EqualP[5.6 Milliliter]
    ],
    Example[{Options, DestinationMedia, "If InoculationSource is SolidMedia, DestinationMedia will automatically resolve to a PreferredLiquidMedia a Model[Cell] in the composition in the input sample:"},
      prefLiquidMedia = Cases[
        Download[
          Flatten@Quiet[
            Download[
              Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
              Composition[[All, 2]][PreferredLiquidMedia]
            ]
          ],
          Object
        ],
        ObjectP[]
      ];
      resolvedDestMedia = Download[Flatten@Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        DestinationMedia
      ], Object];
      MatchQ[resolvedDestMedia, ObjectP[prefLiquidMedia]],
      True,
      Variables :> {prefLiquidMedia, resolvedDestMedia}
    ],
    Example[{Options, DestinationMedia, "If InoculationSource is SolidMedia, DestinationMedia can be specified as an Object[Sample]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          DestinationMedia -> Object[Sample, "ExperimentInoculateLiquidMedia test LB Broth in 500 mL flask " <> $SessionUUID],
          Output -> Options
        ],
        DestinationMedia
      ],
      ObjectP[Object[Sample, "ExperimentInoculateLiquidMedia test LB Broth in 500 mL flask " <> $SessionUUID]]
    ],
    Example[{Options, DestinationMedia, "If InoculationSource is LiquidMedia, DestinationMedia is automatically set to the PreferredLiquidMedia of a Model[Cell] in the Composition of the input sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Output -> Options
        ],
        DestinationMedia
      ],
      ObjectP[]
    ],
    Example[{Options, DestinationMedia, "If InoculationSource is AgarStab, DestinationMedia is automatically set to the PreferredLiquidMedia of a Model[Cell] in the Composition of the input sample:"},
      destMedia = Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> AgarStab,
          Output -> Options
        ],
        DestinationMedia
      ];
      prefLiquidMedia = Cases[
        Download[
          Flatten@Quiet[
            Download[
              Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
              Composition[[All, 2]][PreferredLiquidMedia]
            ]
          ],
          Object
        ],
        ObjectP[]
      ];
      MemberQ[prefLiquidMedia, destMedia],
      True,
      Variables :> {destMedia, prefLiquidMedia}
    ],
    Example[{Options, DestinationMedia, "If InoculationSource is FreezeDried, DestinationMedia is automatically set to the PreferredLiquidMedia of a Model[Cell] in the Composition of the input sample:"},
      destMedia = Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          InoculationSource -> FreezeDried,
          Output -> Options
        ],
        DestinationMedia
      ];
      prefLiquidMedia = Cases[
        Download[
          Flatten@Quiet[
            Download[
              Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
              Composition[[All, 2]][PreferredLiquidMedia]
            ]
          ],
          Object
        ],
        ObjectP[]
      ];
      MemberQ[prefLiquidMedia, destMedia],
      True,
      Variables :> {destMedia, prefLiquidMedia}
    ],
    Example[{Options, DestinationMedia, "If InoculationSource is FrozenGlycerol, DestinationMedia is automatically set to the PreferredLiquidMedia of a Model[Cell] in the Composition of the input sample:"},
      destMedia = Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> FrozenGlycerol,
          Output -> Options
        ],
        DestinationMedia
      ];
      prefLiquidMedia = Cases[
        Download[
          Flatten@Quiet[
            Download[
              Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
              Composition[[All, 2]][PreferredLiquidMedia]
            ]
          ],
          Object
        ],
        ObjectP[]
      ];
      MemberQ[prefLiquidMedia, destMedia],
      True,
      Variables :> {destMedia, prefLiquidMedia}
    ],
    Example[{Options, DestinationMediaContainer, "If InoculationSource is SolidMedia, automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate, Sterile\"]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> Diameter[],
          Output -> Options
        ],
        DestinationMediaContainer
      ],
      ObjectP[Model[Container, Plate, "id:n0k9mGkwbvG4"]](*"96-well 2mL Deep Well Plate, Sterile"*)
    ],
    Example[{Options, DestinationMediaContainer, "If InoculationSource is SolidMedia, specify an Object[Container] for a population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> Diameter[],
          DestinationMediaContainer -> Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 7 " <> $SessionUUID],
          Output -> Options
        ],
        DestinationMediaContainer
      ],
      {ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 7 " <> $SessionUUID]]}
    ],
    Example[{Options, DestinationMediaContainer, "If InoculationSource is SolidMedia, specify multiple Object[Container]s for a population to signify as many picked colonies of that population that can fit will be deposited into those specific plates only:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> Diameter[],
          DestinationMediaContainer -> {{{
            Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 5 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 6 " <> $SessionUUID],
            Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 7 " <> $SessionUUID]
          }}},
          Output -> Options
        ],
        DestinationMediaContainer
      ],
      {{{
        ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 5 " <> $SessionUUID]],
        ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 6 " <> $SessionUUID]],
        ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 7 " <> $SessionUUID]]
      }}}
    ],
    Example[{Options, DestinationMediaContainer, "If InoculationSource is SolidMedia, specify destination media containers for each population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> {{
            Diameter[],
            Fluorescence[NumberOfColonies -> 10],
            Circularity[]
          }},
          DestinationMediaContainer -> {
            {
              Model[Container, Plate, "id:n0k9mGkwbvG4"],(*"96-well 2mL Deep Well Plate, Sterile"*)
              Model[Container, Plate, "id:n0k9mGkwbvG4"],(*"96-well 2mL Deep Well Plate, Sterile"*)
              {
                Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 5 " <> $SessionUUID],
                Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 6 " <> $SessionUUID],
                Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 7 " <> $SessionUUID]
              }
            }
          },
          Output -> Options
        ],
        DestinationMediaContainer
      ],
      {
        {
          ObjectP[Model[Container, Plate, "id:n0k9mGkwbvG4"]], (*"96-well 2mL Deep Well Plate, Sterile"*)
          ObjectP[Model[Container, Plate, "id:n0k9mGkwbvG4"]], (*"96-well 2mL Deep Well Plate, Sterile"*)
          {
            ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 5 " <> $SessionUUID]],
            ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 6 " <> $SessionUUID]],
            ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 7 " <> $SessionUUID]]
          }
        }
      }
    ],
    Example[{Options, DestinationMediaContainer, "If InoculationSource is SolidMedia, specify destination media containers for each population when there are multiple input samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 3 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          Populations -> {
            {MultiFeatured[Features -> {Fluorescence, Diameter}, NumberOfColonies -> 10]},
            {Fluorescence[NumberOfColonies -> 10]},
            {MultiFeatured[Features -> {Regularity, Circularity}]}
          },
          DestinationMediaContainer -> {
            Model[Container, Plate, "id:n0k9mGkwbvG4"], (*"96-well 2mL Deep Well Plate, Sterile"*)
            Model[Container, Plate, "id:n0k9mGkwbvG4"], (*"96-well 2mL Deep Well Plate, Sterile"*)
            {
              Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 5 " <> $SessionUUID],
              Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 6 " <> $SessionUUID]
            }
          },
          Output -> Options
        ],
        DestinationMediaContainer
      ],
      {
        {ObjectP[Model[Container, Plate, "id:n0k9mGkwbvG4"]]}, (*"96-well 2mL Deep Well Plate, Sterile"*)
        {ObjectP[Model[Container, Plate, "id:n0k9mGkwbvG4"]]}, (*"96-well 2mL Deep Well Plate, Sterile"*)
        {{
          ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 5 " <> $SessionUUID]],
          ObjectP[Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 6 " <> $SessionUUID]]
        }}
      }
    ],
    Example[{Options, DestinationMediaContainer, "If InoculationSource is LiquidMedia, specify a container:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          DestinationMediaContainer -> Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 1 " <> $SessionUUID],
          Output -> Options
        ],
        DestinationMediaContainer
      ],
      {ObjectP[Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 1 " <> $SessionUUID]]}
    ],
    Example[{Options, DestinationMediaContainer, "If InoculationSource is LiquidMedia, specify a container for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource -> LiquidMedia,
          DestinationMediaContainer -> {
            Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 1 " <> $SessionUUID],
            Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 2 " <> $SessionUUID]
          },
          Output -> Options
        ],
        DestinationMediaContainer
      ],
      {
        {ObjectP[Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 1 " <> $SessionUUID]]},
        {ObjectP[Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 2 " <> $SessionUUID]]}
      }
    ],
    Example[{Options, DestinationMediaContainer, "If InoculationSource is AgarStab, specify a container:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> AgarStab,
          DestinationMediaContainer -> Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 1 " <> $SessionUUID],
          Output -> Options
        ],
        DestinationMediaContainer
      ],
      {ObjectP[Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 1 " <> $SessionUUID]]}
    ],
    Example[{Options, DestinationMediaContainer, "If InoculationSource is AgarStab, specify a container for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 2 in cryoVial " <> $SessionUUID]
          },
          InoculationSource -> AgarStab,
          DestinationMediaContainer -> {
            {Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 1 " <> $SessionUUID]},
            {Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 2 " <> $SessionUUID]}
          },
          Output -> Options
        ],
        DestinationMediaContainer
      ],
      {
        {ObjectP[Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 1 " <> $SessionUUID]]},
        {ObjectP[Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 2 " <> $SessionUUID]]}
      }
    ],
    Example[{Options, {DestinationWell, DestinationMediaContainer}, "If InoculationSource is FreezeDried, automatically place cells to A1 of Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          InoculationSource -> FreezeDried,
          Output -> Options
        ],
        {DestinationWell, DestinationMediaContainer}
      ],
      {{{"A1"}}, ObjectP[Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"]]}
    ],
    Example[{Options, {DestinationWell, DestinationMediaContainer}, "If InoculationSource is FrozenGlycerol, automatically place cells to A1 of Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> FrozenGlycerol,
          Output -> Options
        ],
        {DestinationWell, DestinationMediaContainer}
      ],
      {{{"A1"}}, ObjectP[Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"]]}
    ],
    Example[{Options, DestinationWell, "If InoculationSource is SolidMedia, DestinationWell automatically resolves to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        DestinationWell
      ],
      {{Null}}
    ],
    Example[{Options, DestinationWell, "If InoculationSource is LiquidMedia, specify a DestinationWell along with a DestinationMediaContainer:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          DestinationMediaContainer -> Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 1 " <> $SessionUUID],
          DestinationWell -> "A1",
          Output -> Options
        ],
        DestinationWell
      ],
      {{"A1"}}
    ],
    Example[{Options, DestinationWell, "If InoculationSource is AgarStab, specify a DestinationWell along with a DestinationMediaContainer:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> AgarStab,
          DestinationMediaContainer -> Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 1 " <> $SessionUUID],
          DestinationWell -> "A1",
          Output -> Options
        ],
        DestinationWell
      ],
      {{"A1"}}
    ],
    Example[{Options, DestinationWell, "Specify different DestinationWells for each input sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 2 in cryoVial " <> $SessionUUID]
          },
          InoculationSource -> AgarStab,
          DestinationMediaContainer -> Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 6 " <> $SessionUUID],
          DestinationWell -> {"A1", "B1"},
          Output -> Options
        ],
        DestinationWell
      ],
      {{"A1"}, {"B1"}}
    ],
    (* Section: FreezeDried specific options *)
    Example[{Options, {ResuspensionMedia, ResuspensionMediaVolume, ResuspensionMix, NumberOfResuspensionMixes, ResuspensionMixVolume}, "If the source is freeze dried, unless otherwise specified, 1) ResuspensionMedia is set to match the destination media, 2) ResuspensionMediaVolume is set to 1/4 of the source sample container's volume, 3) ResuspensionMix is set to True, 4) NumberOfResuspensionMixes is set to 5, and 5) ResuspensionMixVolume is set to the less between 1/2 the ResuspensionMediaVolume or 1/2 of the maximum volume of the tips:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          Output -> Options
        ],
        {
          ResuspensionMedia,
          ResuspensionMediaVolume,
          ResuspensionMix,
          NumberOfResuspensionMixes,
          ResuspensionMixVolume
        }
      ],
      {
        ObjectP[Model[Sample, Media]],
        EqualP[0.5 Milliliter],
        True,
        5,
        EqualP[0.25 Milliliter]
      }
    ],
    (* Section: FrozenGlycerol specific option *)
    Example[{Options, Populations, "If InoculationSource is FrozenGlycerol, NumberOfSourceScrapes is automatically set to 5:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
          InoculationSource -> FrozenGlycerol,
          Output -> Options
        ],
        NumberOfSourceScrapes
      ],
      EqualP[5]
    ],
    (* Section: SolidMedia specific options *)
    Example[{Options, Populations, "If InoculationSource is SolidMedia use the Populations option to specify a single population that describes the colonies to pick:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> Diameter[],
          Output -> Options
        ],
        Populations
      ],
      DiameterPrimitiveP
    ],
    Example[{Options, Populations, "If InoculationSource is SolidMedia use the select option to specify multiple populations per sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> {{
            Diameter[],
            Fluorescence[]
          }},
          Output -> Options
        ],
        Populations
      ],
      {{DiameterPrimitiveP, FluorescencePrimitiveP}}
    ],
    Example[{Options, Populations, "If InoculationSource is SolidMedia use the select option to specify populations with multiple features:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> MultiFeatured[
            Features -> {Diameter, Fluorescence}
          ],
          Output -> Options
        ],
        Populations
      ],
      MultiFeaturedPrimitiveP
    ],
    Example[{Options, Populations, "If InoculationSource is SolidMedia use the Populations option to select a specific division of colonies when they are divided into more than 2 groups:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> MultiFeatured[
            Features -> {Diameter, Fluorescence},
            NumberOfDivisions -> {5, 2}
          ],
          Output -> Options
        ],
        Populations
      ],
      MultiFeaturedPrimitiveP
    ],
    Example[{Options, Populations, "If InoculationSource is SolidMedia and if the pick coordinates are already known, set Populations to CustomCoordinates and specify PickCoordinates:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> CustomCoordinates,
          PickCoordinates -> ConstantArray[{0 Millimeter, 0 Millimeter}, 30],
          Output -> Options
        ],
        Populations
      ],
      CustomCoordinates
    ],
    Example[{Options, Populations, "If InoculationSource is SolidMedia if Populations ->Automatic, will resolve to a Fluorescence population based on the fields in the Model[Cell]'s of the input sample composition:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> Automatic,
          Output -> Options
        ],
        Populations
      ],
      FluorescencePrimitiveP
    ],
    Example[{Options, Populations, "If InoculationSource is SolidMedia select a single population from multiple samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          Populations -> Diameter[],
          Output -> Options
        ],
        Populations
      ],
      DiameterPrimitiveP
    ],
    Example[{Options, Populations, "If InoculationSource is SolidMedia select multiple populations per sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          Populations ->{
            {
              Diameter[]
            },
            {
              Diameter[],
              Fluorescence[NumberOfColonies -> 10]
            }
          },
          Output -> Options
        ],
        Populations
      ],
      {{DiameterPrimitiveP}, {DiameterPrimitiveP, FluorescencePrimitiveP}}
    ],
    Example[{Options, Populations, "If InoculationSource is SolidMedia select a single type of colony from the first plate and select known colony coordinates on a second plate:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          Populations -> {
            Diameter[],
            CustomCoordinates
          },
          PickCoordinates -> {
            Null,
            ConstantArray[{0 Millimeter, 0 Millimeter}, 10]
          },
          Output -> Options
        ],
        Populations
      ],
      {{DiameterPrimitiveP}, {CustomCoordinates}}
    ],
    Example[{Options, ColonyPickingTool, "If InoculationSource is SolidMedia the ColonyPickingTool will automatically resolve to a PreferredColonyHandlerHeadCassette of a Model[Cell] in the composition of the input sample that also fits the DestinationMediaContainer:"},
      preferredHeads = Cases[Download[
        (* Get the PreferredColonyHandlerHeadCassettes of the input sample *)
        Flatten@Quiet[
          Download[
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Composition[[All, 2]][PreferredColonyHandlerHeadCassettes]
          ]
        ],
        Object
      ],
        ObjectP[]
      ];
      selectedHead = Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        ColonyPickingTool
      ];
      MemberQ[preferredHeads, selectedHead],
      True,
      Variables :> {preferredHeads, selectedHead}
    ],
    Example[{Options, ColonyPickingTool, "If InoculationSource is SolidMedia the ColonyPickingTool can be specified by Model[Part,ColonyHandlerHeadCassette] or Object[Part,ColonyHandlerHeadCassette]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          DestinationMediaContainer -> Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"],
          ColonyPickingTool -> {
            Object[Part, ColonyHandlerHeadCassette, "id:bq9LA09Wkwav"],
            Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli"]
          },
          Output -> Options
        ],
        ColonyPickingTool
      ],
      {ObjectP[Object[Part, ColonyHandlerHeadCassette, "id:bq9LA09Wkwav"]], ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli"]]}
    ],
    Example[{Options, NumberOfHeads, "If InoculationSource is SolidMedia, only ColonyPickingTools with the specified NumberOfHeads will be used:"},
      colonyPickingTool = Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          NumberOfHeads -> 96,
          Output -> Options
        ],
        ColonyPickingTool
      ];
      Download[colonyPickingTool, NumberOfHeads],
      96,
      Variables :> {colonyPickingTool}
    ],
    Example[{Options, ColonyPickingDepth, "If InoculationSource is SolidMedia, the ColonyPickingDepth is automatically set to 2 Millimeter:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        ColonyPickingDepth
      ],
      2 Millimeter
    ],
    Example[{Options, ColonyPickingDepth, "If InoculationSource is SolidMedia, the ColonyPickingDepth can be specified for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          ColonyPickingDepth -> {2 Millimeter, 1.5 Millimeter},
          Output -> Options
        ],
        ColonyPickingDepth
      ],
      {{2 Millimeter}, {1.5 Millimeter}}
    ],
    Example[{Options, ImagingStrategies, "If InoculationSource is SolidMedia, ImagingStrategies automatically gets resolved to the imaging channels specified in Populations + Brightfield:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> MultiFeatured[
            Features -> {Fluorescence, Fluorescence},
            NumberOfColonies -> 10,
            ExcitationWavelength -> {457 Nanometer, 531 Nanometer},
            EmissionWavelength -> {536 Nanometer, 593 Nanometer}
          ],
          Output -> Options
        ],
        ImagingStrategies
      ],
      {BrightField, GreenFluorescence, OrangeFluorescence}
    ],
    Example[{Options, ImagingStrategies, "If InoculationSource is SolidMedia, specify the ImagingStrategies that are specified as Features in Populations:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> MultiFeatured[
            Features -> {Fluorescence, Fluorescence},
            NumberOfColonies -> 10,
            ExcitationWavelength -> {457 Nanometer, 531 Nanometer},
            EmissionWavelength -> {536 Nanometer, 593 Nanometer}
          ],
          ImagingStrategies -> {BrightField, GreenFluorescence, OrangeFluorescence},
          Output -> Options
        ],
        ImagingStrategies
      ],
      {BrightField, GreenFluorescence, OrangeFluorescence}
    ],
    Example[{Options, ImagingStrategies, "If InoculationSource is SolidMedia, specify additional ImagingStrategies that are not specified as Features in Populations:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> MultiFeatured[
            Features -> {Fluorescence, Fluorescence},
            NumberOfColonies -> 10,
            ExcitationWavelength -> {457 Nanometer, 531 Nanometer},
            EmissionWavelength -> {536 Nanometer, 593 Nanometer}
          ],
          ImagingStrategies -> {BrightField, GreenFluorescence, OrangeFluorescence, RedFluorescence},
          Output -> Options
        ],
        ImagingStrategies
      ],
      {BrightField, GreenFluorescence, OrangeFluorescence, RedFluorescence}
    ],
    Example[{Options, ExposureTimes, "If InoculationSource is SolidMedia, ExposureTimes automatically gets set to Automatic as they get optimized at RunTime:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> MultiFeatured[
            Features -> {Fluorescence, Fluorescence},
            NumberOfColonies -> 10,
            ExcitationWavelength -> {457 Nanometer, 531 Nanometer},
            EmissionWavelength -> {536 Nanometer, 593 Nanometer}
          ],
          Output -> Options
        ],
        ExposureTimes
      ],
      {Automatic, Automatic, Automatic}
    ],
    Example[{Options, ExposureTimes, "If InoculationSource is SolidMedia, control the ExposureTimes of Imaging Channels specified in Populations:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Populations -> MultiFeatured[
            Features -> {Fluorescence, Fluorescence},
            NumberOfColonies -> 10,
            ExcitationWavelength -> {457 Nanometer, 531 Nanometer},
            EmissionWavelength -> {536 Nanometer, 593 Nanometer}
          ],
          ImagingStrategies -> {BrightField, GreenFluorescence, OrangeFluorescence},
          ExposureTimes -> {5 Millisecond, 10 Millisecond, 30 Millisecond},
          Output -> Options
        ],
        ExposureTimes
      ],
      {5 Millisecond, 10 Millisecond, 30 Millisecond}
    ],
    Example[{Options, DestinationFillDirection, "If InoculationSource is SolidMedia, DestinationFillDirection automatic resolve to filling the destination container by Rows:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        DestinationFillDirection
      ],
      Row
    ],
    Example[{Options, DestinationFillDirection, "If InoculationSource is SolidMedia, set the DestinationFillDirection to fill the destination in row order:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          DestinationFillDirection -> Row,
          Output -> Options
        ],
        DestinationFillDirection
      ],
      Row
    ],
    Example[{Options, DestinationFillDirection, "If InoculationSource is SolidMedia, set the DestinationFillDirection to fill the destination in column order:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          DestinationFillDirection -> Column,
          Output -> Options
        ],
        DestinationFillDirection
      ],
      Column
    ],
    Example[{Options, MaxDestinationNumberOfColumns, "If InoculationSource is SolidMedia, MaxDestinationNumberOfColumns is left as Automatic because the optimal number of columns is determined once the number of colonies to pick is known:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        MaxDestinationNumberOfColumns
      ],
      Automatic
    ],
    Example[{Options, MaxDestinationNumberOfColumns, "If InoculationSource is SolidMedia, use MaxDestinationNumberOfColumns to limit the number of columns of deposited colonies to 8:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          MaxDestinationNumberOfColumns -> 8,
          Output -> Options
        ],
        MaxDestinationNumberOfColumns
      ],
      8
    ],
    Example[{Options, MaxDestinationNumberOfColumns, "If InoculationSource is SolidMedia, use MaxDestinationNumberOfColumns to limit the number of columns of deposited colonies for each population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          Populations ->{
            {Diameter[]},
            {Diameter[], Fluorescence[NumberOfColonies -> 10]}
          },
          MaxDestinationNumberOfColumns -> {
            {5},
            {8, 9}
          },
          Output -> Options
        ],
        MaxDestinationNumberOfColumns
      ],
      {{5}, {8, 9}}
    ],
    Example[{Options, MaxDestinationNumberOfRows, "If InoculationSource is SolidMedia, MaxDestinationNumberOfRows is left as Automatic because the optimal number of Rows is determined once the number of colonies to pick is known:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        MaxDestinationNumberOfRows
      ],
      Automatic
    ],
    Example[{Options, MaxDestinationNumberOfRows, "If InoculationSource is SolidMedia, use MaxDestinationNumberOfRows to limit the number of Rows of deposited colonies to 8:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          MaxDestinationNumberOfRows -> 8,
          Output -> Options
        ],
        MaxDestinationNumberOfRows
      ],
      8
    ],
    Example[{Options, MaxDestinationNumberOfRows, "If InoculationSource is SolidMedia, use MaxDestinationNumberOfRows to limit the number of Rows of deposited colonies for each population:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          Populations -> {
            {Diameter[]},
            {Diameter[], Fluorescence[NumberOfColonies -> 10]}
          },
          MaxDestinationNumberOfRows -> {
            {5},
            {8, 9}
          },
          Output -> Options
        ],
        MaxDestinationNumberOfRows
      ],
      {{5}, {8, 9}}
    ],
    Example[{Options, PrimaryWash, "If InoculationSource is SolidMedia, PrimaryWash is default to True if not specified:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        PrimaryWash
      ],
      True
    ],
    Example[{Options, PrimaryWash, "If InoculationSource is SolidMedia, setting PrimaryWash to False will turn off the other PrimaryWash options:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          PrimaryWash -> False,
          Output -> Options
        ],
        {PrimaryWash, PrimaryWashSolution, NumberOfPrimaryWashes, PrimaryDryTime}
      ],
      {False, Null, Null, Null}
    ],
    Example[{Options, PrimaryWash, "If InoculationSource is SolidMedia, have different PrimaryWash specifications for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          PrimaryWash -> {True, False},
          Output -> Options
        ],
        PrimaryWash
      ],
      {True, False}
    ],
    Example[{Options, PrimaryWashSolution, "If InoculationSource is SolidMedia, the PrimaryWashSolution will automatically be set to Model[Sample,StockSolution,\"70% Ethanol\"]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        PrimaryWashSolution
      ],
      ObjectP[Model[Sample, StockSolution, "70% Ethanol"]]
    ],
    Example[{Options, PrimaryWashSolution, "If InoculationSource is SolidMedia, the PrimaryWashSolution will automatically be set to Null if PrimaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          PrimaryWash -> False,
          Output -> Options
        ],
        PrimaryWashSolution
      ],
      Null
    ],
    Example[{Options, PrimaryWashSolution, "If InoculationSource is SolidMedia, have different PrimaryWashSolutions for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          PrimaryWashSolution -> {Model[Sample, StockSolution, "70% Ethanol"], Model[Sample, "Milli-Q water"]},
          Output -> Options
        ],
        PrimaryWashSolution
      ],
      {ObjectP[Model[Sample, StockSolution, "70% Ethanol"]], ObjectP[Model[Sample, "Milli-Q water"]]}
    ],
    Example[{Options, NumberOfPrimaryWashes, "If InoculationSource is SolidMedia, NumberOfPrimaryWashes will automatically be set to 5:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        NumberOfPrimaryWashes
      ],
      5
    ],
    Example[{Options, NumberOfPrimaryWashes, "If InoculationSource is SolidMedia, the NumberOfPrimaryWashes will automatically be set to Null if PrimaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          PrimaryWash -> False,
          Output -> Options
        ],
        NumberOfPrimaryWashes
      ],
      Null
    ],
    Example[{Options, NumberOfPrimaryWashes, "If InoculationSource is SolidMedia, have different NumberOfPrimaryWashes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          NumberOfPrimaryWashes -> {8, 10},
          Output -> Options
        ],
        NumberOfPrimaryWashes
      ],
      {8, 10}
    ],
    Example[{Options, PrimaryDryTime, "If InoculationSource is SolidMedia, PrimaryDryTime will automatically be set to 10 Seconds:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        PrimaryDryTime
      ],
      10 Second
    ],
    Example[{Options, PrimaryDryTime, "If InoculationSource is SolidMedia, the PrimaryDryTime will automatically be set to Null if PrimaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          PrimaryWash -> False,
          Output -> Options
        ],
        PrimaryDryTime
      ],
      Null
    ],
    Example[{Options, PrimaryDryTime, "If InoculationSource is SolidMedia, have different PrimaryDryTimes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          PrimaryDryTime -> {8 Second, 30 Second},
          Output -> Options
        ],
        PrimaryDryTime
      ],
      {8 Second, 30 Second}
    ],
    Example[{Options, SecondaryWash, "If InoculationSource is SolidMedia, SecondaryWash will default to True if not specified:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        SecondaryWash
      ],
      True
    ],
    Example[{Options, SecondaryWash, "If InoculationSource is SolidMedia, setting SecondaryWash to False will turn off the other SecondaryWash options:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          SecondaryWash -> False,
          Output -> Options
        ],
        {SecondaryWash, SecondaryWashSolution, NumberOfSecondaryWashes, SecondaryDryTime}
      ],
      {False, Null, Null, Null}
    ],
    Example[{Options, SecondaryWash, "If InoculationSource is SolidMedia, have different SecondaryWash specifications for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          SecondaryWash -> {True, False},
          Output -> Options
        ],
        SecondaryWash
      ],
      {True, False}
    ],
    Example[{Options, SecondaryWashSolution, "If InoculationSource is SolidMedia, the SecondaryWashSolution will automatically be set to Model[Sample,StockSolution,\"70% Ethanol\"]:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        SecondaryWashSolution
      ],
      ObjectP[Model[Sample, "Milli-Q water"]]
    ],
    Example[{Options, SecondaryWashSolution, "If InoculationSource is SolidMedia, the SecondaryWashSolution will automatically be set to Null if SecondaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          SecondaryWash -> False,
          Output -> Options
        ],
        SecondaryWashSolution
      ],
      Null
    ],
    Example[{Options, SecondaryWashSolution, "If InoculationSource is SolidMedia, have different SecondaryWashSolutions for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          SecondaryWashSolution -> {Model[Sample, StockSolution, "70% Ethanol"], Model[Sample, "Milli-Q water"]},
          Output -> Options
        ],
        SecondaryWashSolution
      ],
      {ObjectP[Model[Sample, StockSolution, "70% Ethanol"]], ObjectP[Model[Sample, "Milli-Q water"]]}
    ],
    Example[{Options, NumberOfSecondaryWashes, "If InoculationSource is SolidMedia, NumberOfSecondaryWashes will automatically be set to 5:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        NumberOfSecondaryWashes
      ],
      5
    ],
    Example[{Options, NumberOfSecondaryWashes, "If InoculationSource is SolidMedia, the NumberOfSecondaryWashes will automatically be set to Null if SecondaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          SecondaryWash -> False,
          Output -> Options
        ],
        NumberOfSecondaryWashes
      ],
      Null
    ],
    Example[{Options, NumberOfSecondaryWashes, "If InoculationSource is SolidMedia, have different NumberOfSecondaryWashes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          NumberOfSecondaryWashes -> {8, 10},
          Output -> Options
        ],
        NumberOfSecondaryWashes
      ],
      {8, 10}
    ],
    Example[{Options, SecondaryDryTime, "If InoculationSource is SolidMedia, SecondaryDryTime will automatically be set to 10 Seconds:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        SecondaryDryTime
      ],
      10 Second
    ],
    Example[{Options, SecondaryDryTime, "If InoculationSource is SolidMedia, the SecondaryDryTime will automatically be set to Null if SecondaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          SecondaryWash -> False,
          Output -> Options
        ],
        SecondaryDryTime
      ],
      Null
    ],
    Example[{Options, SecondaryDryTime, "If InoculationSource is SolidMedia, have different SecondaryDryTimes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          SecondaryDryTime -> {8 Second, 30 Second},
          Output -> Options
        ],
        SecondaryDryTime
      ],
      {8 Second, 30 Second}
    ],
    Example[{Options, TertiaryWash, "If InoculationSource is SolidMedia, TertiaryWash will default to False if not specified:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        TertiaryWash
      ],
      False
    ],
    Example[{Options, TertiaryWash, "If InoculationSource is SolidMedia, TertiaryWash will default to True if QuaternaryWash is specified as True:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          QuaternaryWash -> True,
          Output -> Options
        ],
        TertiaryWash
      ],
      True
    ],
    Example[{Options, TertiaryWash, "If InoculationSource is SolidMedia, setting TertiaryWash to False will turn off the other TertiaryWash options:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          TertiaryWash -> False,
          Output -> Options
        ],
        {TertiaryWash, TertiaryWashSolution, NumberOfTertiaryWashes, TertiaryDryTime}
      ],
      {False, Null, Null, Null}
    ],
    Example[{Options, TertiaryWash, "If InoculationSource is SolidMedia, have different TertiaryWash specifications for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          TertiaryWash -> {True,False},
          Output -> Options
        ],
        TertiaryWash
      ],
      {True, False}
    ],
    Example[{Options, TertiaryWashSolution, "If InoculationSource is SolidMedia, the TertiaryWashSolution will automatically be set to Model[Sample, StockSolution, \"10% Bleach\"] if TertiaryWash is True:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          TertiaryWash -> True,
          Output -> Options
        ],
        TertiaryWashSolution
      ],
      ObjectP[Model[Sample, StockSolution, "10% Bleach"]]
    ],
    Example[{Options, TertiaryWashSolution, "If InoculationSource is SolidMedia, the TertiaryWashSolution will automatically be set to Null if TertiaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          TertiaryWash -> False,
          Output -> Options
        ],
        TertiaryWashSolution
      ],
      Null
    ],
    Example[{Options, TertiaryWashSolution, "If InoculationSource is SolidMedia, have different TertiaryWashSolutions for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          TertiaryWashSolution -> {Model[Sample, StockSolution, "70% Ethanol"], Model[Sample, "Milli-Q water"]},
          Output -> Options
        ],
        TertiaryWashSolution
      ],
      {ObjectP[Model[Sample, StockSolution, "70% Ethanol"]], ObjectP[Model[Sample, "Milli-Q water"]]}
    ],
    Example[{Options, NumberOfTertiaryWashes, "If InoculationSource is SolidMedia, NumberOfTertiaryWashes will automatically be set to 5 if TertiaryWash is True:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          TertiaryWash -> True,
          Output -> Options
        ],
        NumberOfTertiaryWashes
      ],
      5
    ],
    Example[{Options, NumberOfTertiaryWashes, "If InoculationSource is SolidMedia, the NumberOfTertiaryWashes will automatically be set to Null if TertiaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          TertiaryWash -> False,
          Output -> Options
        ],
        NumberOfTertiaryWashes
      ],
      Null
    ],
    Example[{Options, NumberOfTertiaryWashes, "If InoculationSource is SolidMedia, have different NumberOfTertiaryWashes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          NumberOfTertiaryWashes -> {8, 10},
          Output -> Options
        ],
        NumberOfTertiaryWashes
      ],
      {8, 10}
    ],
    Example[{Options, TertiaryDryTime, "If InoculationSource is SolidMedia, TertiaryDryTime will automatically be set to 10 Seconds if TertiaryWash is True:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          TertiaryWash -> True,
          Output -> Options
        ],
        TertiaryDryTime
      ],
      10 Second
    ],
    Example[{Options, TertiaryDryTime, "If InoculationSource is SolidMedia, the TertiaryDryTime will automatically be set to Null if TertiaryWash is False:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          TertiaryWash -> False,
          Output -> Options
        ],
        TertiaryDryTime
      ],
      Null
    ],
    Example[{Options, TertiaryDryTime, "If InoculationSource is SolidMedia, have different TertiaryDryTimes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          TertiaryDryTime -> {8 Second, 30 Second},
          Output -> Options
        ],
        TertiaryDryTime
      ],
      {8 Second, 30 Second}
    ],
    Example[{Options, QuaternaryWash, "If InoculationSource is SolidMedia, QuaternaryWash will default to False if not specified:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        QuaternaryWash
      ],
      False
    ],
    Example[{Options, QuaternaryWash, "If InoculationSource is SolidMedia, setting QuaternaryWash to False will turn off the other QuaternaryWash options:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          QuaternaryWash -> False,
          Output -> Options
        ],
        {QuaternaryWash, QuaternaryWashSolution, NumberOfQuaternaryWashes, QuaternaryDryTime}
      ],
      {False, Null, Null, Null}
    ],
    Example[{Options, QuaternaryWash, "If InoculationSource is SolidMedia, have different QuaternaryWash specifications for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          QuaternaryWash -> {True, False},
          Output -> Options
        ],
        QuaternaryWash
      ],
      {True, False}
    ],
    Example[{Options, QuaternaryWashSolution, "If InoculationSource is SolidMedia, the QuaternaryWashSolution will automatically be set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        QuaternaryWashSolution
      ],
      Null
    ],
    Example[{Options, QuaternaryWashSolution, "If InoculationSource is SolidMedia, the QuaternaryWashSolution will automatically be set to Model[Sample,StockSolution,\"70% Ethanol\"] if QuaternaryWash is True:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          QuaternaryWash -> True,
          Output -> Options
        ],
        QuaternaryWashSolution
      ],
      ObjectP[Model[Sample, StockSolution, "70% Ethanol"]]
    ],
    Example[{Options, QuaternaryWashSolution, "If InoculationSource is SolidMedia, have different QuaternaryWashSolutions for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          QuaternaryWashSolution -> {Model[Sample, StockSolution, "70% Ethanol"], Model[Sample, "Milli-Q water"]},
          Output -> Options
        ],
        QuaternaryWashSolution
      ],
      {ObjectP[Model[Sample, StockSolution, "70% Ethanol"]], ObjectP[Model[Sample, "Milli-Q water"]]}
    ],
    Example[{Options, NumberOfQuaternaryWashes, "If InoculationSource is SolidMedia, numberOfQuaternaryWashes will automatically be set to 5, if QuaternaryWash is True:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          QuaternaryWash -> True,
          Output -> Options
        ],
        NumberOfQuaternaryWashes
      ],
      5
    ],
    Example[{Options, NumberOfQuaternaryWashes, "If InoculationSource is SolidMedia, the NumberOfQuaternaryWashes will automatically be set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          QuaternaryWash -> False,
          Output -> Options
        ],
        NumberOfQuaternaryWashes
      ],
      Null
    ],
    Example[{Options, NumberOfQuaternaryWashes, "If InoculationSource is SolidMedia, have different NumberOfQuaternaryWashes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          NumberOfQuaternaryWashes -> {8, 10},
          Output -> Options
        ],
        NumberOfQuaternaryWashes
      ],
      {8, 10}
    ],
    Example[{Options, QuaternaryDryTime, "If InoculationSource is SolidMedia, QuaternaryDryTime will automatically be set to 10 Seconds if QuaternaryWash is True:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          QuaternaryWash -> True,
          Output -> Options
        ],
        QuaternaryDryTime
      ],
      10 Second
    ],
    Example[{Options, QuaternaryDryTime, "If InoculationSource is SolidMedia, the QuaternaryDryTime will automatically be set to Null:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          QuaternaryWash -> False,
          Output -> Options
        ],
        QuaternaryDryTime
      ],
      Null
    ],
    Example[{Options, QuaternaryDryTime, "If InoculationSource is SolidMedia, have different QuaternaryDryTimes for different samples:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          QuaternaryDryTime -> {8 Second, 30 Second},
          Output -> Options
        ],
        QuaternaryDryTime
      ],
      {8 Second, 30 Second}
    ],
    Example[{Options, MinRegularityRatio, "If InoculationSource is SolidMedia, MinRegularityRatio is default to 0.65:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        MinRegularityRatio
      ],
      0.65
    ],
    Example[{Options, MinRegularityRatio, "If InoculationSource is SolidMedia, set MinRegularityRatio for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          MinRegularityRatio -> {0.4, 0.8},
          Output -> Options
        ],
        MinRegularityRatio
      ],
      {0.4, 0.8}
    ],
    Example[{Options, MaxRegularityRatio, "If InoculationSource is SolidMedia, MaxRegularityRatio is default to 1:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        MaxRegularityRatio
      ],
      RangeP[1]
    ],
    Example[{Options, MaxRegularityRatio, "If InoculationSource is SolidMedia, set MaxRegularityRatio for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          MaxRegularityRatio -> {0.8, 0.9},
          Output -> Options
        ],
        MaxRegularityRatio
      ],
      {0.8, 0.9}
    ],
    Example[{Options, MinCircularityRatio, "If InoculationSource is SolidMedia, MinCircularityRatio is default to 0.65:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        MinCircularityRatio
      ],
      0.65
    ],
    Example[{Options, MinCircularityRatio, "If InoculationSource is SolidMedia, set MinCircularityRatio for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          MinCircularityRatio -> {0.4, 0.8},
          Output -> Options
        ],
        MinCircularityRatio
      ],
      {0.4, 0.8}
    ],
    Example[{Options, MaxCircularityRatio, "If InoculationSource is SolidMedia, MaxCircularityRatio is default to 1:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        MaxCircularityRatio
      ],
      RangeP[1]
    ],
    Example[{Options, MaxCircularityRatio, "If InoculationSource is SolidMedia, set MaxCircularityRatio for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          MaxCircularityRatio -> {0.8, 0.9},
          Output -> Options
        ],
        MaxCircularityRatio
      ],
      {0.8, 0.9}
    ],
    Example[{Options, MinDiameter, "If InoculationSource is SolidMedia, MinDiameter is automatically set to 0.5 Millimeter:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        MinDiameter
      ],
      0.5 Millimeter
    ],
    Example[{Options, MinDiameter, "If InoculationSource is SolidMedia, set MinDiameter for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          MinDiameter -> {0.4 Millimeter, 0.8 Millimeter},
          Output -> Options
        ],
        MinDiameter
      ],
      {0.4 Millimeter,0.8 Millimeter}
    ],
    Example[{Options, MaxDiameter, "If InoculationSource is SolidMedia, MaxDiameter is default to 2 Millimeter:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        MaxDiameter
      ],
      RangeP[2 Millimeter]
    ],
    Example[{Options, MaxDiameter, "If InoculationSource is SolidMedia, set MaxDiameter for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          MaxDiameter -> {10 Millimeter, 6 Millimeter},
          Output -> Options
        ],
        MaxDiameter
      ],
      {10 Millimeter, 6 Millimeter}
    ],
    Example[{Options, MinColonySeparation, "If InoculationSource is SolidMedia, MinColonySeparation is default to 0.2 Millimeter:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        MinColonySeparation
      ],
      0.2 Millimeter
    ],
    Example[{Options, MinColonySeparation, "If InoculationSource is SolidMedia, set MinColonySeparation for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          },
          InoculationSource -> SolidMedia,
          MinColonySeparation -> {0.4 Millimeter, 0.8 Millimeter},
          Output -> Options
        ],
        MinColonySeparation
      ],
      {0.4 Millimeter, 0.8 Millimeter}
    ],
    (* LiquidMedia specific options *)
    Example[{Options, SourceMix, "If InoculationSource is LiquidMedia, SourceMix is automatically set to True:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Output -> Options
        ],
        SourceMix
      ],
      True
    ],
    Example[{Options, SourceMix, "If InoculationSource is LiquidMedia, specify SourceMix for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource -> LiquidMedia,
          SourceMix -> {True, False},
          Output -> Options
        ],
        SourceMix
      ],
      {True, False}
    ],
    Example[{Options, NumberOfSourceMixes, "If InoculationSource is LiquidMedia, NumberOfSourceMixes is automatically set to 10:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Output -> Options
        ],
        NumberOfSourceMixes
      ],
      10
    ],
    Example[{Options, NumberOfSourceMixes, "If InoculationSource is LiquidMedia, specify NumberOfSourceMixes for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource -> LiquidMedia,
          NumberOfSourceMixes -> {8, 20},
          Output -> Options
        ],
        NumberOfSourceMixes
      ],
      {8, 20}
    ],
    Example[{Options, SourceMixVolume, "If InoculationSource is LiquidMedia, SourceMixVolume is automatically set to the Min(max tip volume, max of Volume and 1/4th of the input sample volume):"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> LiquidMedia,
          Output -> Options
        ],
        SourceMixVolume
      ],
      RangeP[200 Microliter]
    ],
    Example[{Options, SourceMixVolume, "If InoculationSource is LiquidMedia, specify SourceMixVolume for each sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource -> LiquidMedia,
          SourceMixVolume -> {100 Microliter, 150 Microliter},
          Output -> Options
        ],
        SourceMixVolume
      ],
      {100 Microliter, 150 Microliter}
    ],
    (* Shared Options *)
    Example[{Options, Name, "Name of the output protocol object can be specified:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        Name -> "ExperimentInoculateLiquidMedia name test protocol"<> $SessionUUID
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation, "ExperimentInoculateLiquidMedia name test protocol" <> $SessionUUID]]
    ],
    Example[{Options, {SampleLabel, SampleContainerLabel}, "SampleLabel and SampleContainerLabel are automatically set to a list of strings:"},
      ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
        },
        Output -> Options
      ],
      KeyValuePattern[{
        SampleLabel -> {_String..},
        SampleContainerLabel -> {_String..}
      }]
    ],
    Example[{Options, {SampleOutLabel, ContainerOutLabel}, "If InoculationSource is SolidMedia, SampleOutLabel and ContainerOutLabel are nested indexmatching to populations:"},
      options = ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
        },
        Populations -> {{Diameter[NumberOfColonies->5]}, {Diameter[NumberOfColonies->2], Fluorescence[NumberOfColonies->3]}},
        Output -> Options
      ];
      {
        Lookup[options, SampleOutLabel],
        Lookup[options, ContainerOutLabel],
        Length/@Lookup[options, SampleOutLabel],
        Length/@Lookup[options, ContainerOutLabel]
      },
      {
        {{{_String..}}, {{_String..}, {_String..}}},
        {{{_String..}}, {{_String..}, {_String}}},
        {1, 2},
        {1, 2}
      }
    ],
    Example[{Options, {SampleOutLabel, ContainerOutLabel}, "If InoculationSource is LiquidMedia, SampleOutLabel and ContainerOutLabel are list of list:"},
      options = ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 2 in dwp " <> $SessionUUID]
        },
        Output -> Options
      ];
      {
        Lookup[options, SampleOutLabel],
        Lookup[options, ContainerOutLabel]
      },
      {
        {{_String..}, {_String..}},
        {{_String..}, {_String..}}
      }
    ],
    Example[{Options, {SampleOutLabel, ContainerOutLabel}, "If InoculationSource is AgarStab, SampleOutLabel and ContainerOutLabel are list of list:"},
      options = ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 2 in cryoVial " <> $SessionUUID]
        },
        Output -> Options
      ];
      {
        Lookup[options, SampleOutLabel],
        Lookup[options, ContainerOutLabel]
      },
      {
        {{_String..}, {_String..}},
        {{_String..}, {_String..}}
      }
    ],
    Example[{Options, SamplesInStorageCondition, "SamplesInStorageCondition can be specified:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        SamplesInStorageCondition -> Refrigerator,
        Output -> Options
      ];
      Lookup[options, SamplesInStorageCondition],
      Refrigerator,
      Variables :> {options}
    ],
    Example[{Options, SamplesInStorageCondition, "If InoculationSource is FreezeDried, SamplesInStorageCondition is automatically set to Disposal:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, SamplesInStorageCondition],
      Disposal,
      Variables :> {options}
    ],
    Example[{Options, SamplesOutStorageCondition, "SamplesOutStorageCondition can be specified:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        SamplesOutStorageCondition -> BacterialIncubation,
        Output -> Options
      ];
      Lookup[options, SamplesOutStorageCondition],
      BacterialIncubation,
      Variables :> {options}
    ],
    Example[{Options, Preparation, "Preparation is always set to Robotic when inoculation source is SolidMedia:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, Preparation],
      Robotic,
      Variables :> {options}
    ],
    Example[{Options, Preparation, "Preparation can set to Manual when inoculation source is LiquidMedia:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        Preparation -> Manual,
        Output -> Options
      ];
      Lookup[options, Preparation],
      Manual,
      Variables :> {options}
    ],
    Example[{Options, Preparation, "Preparation is automatically set to Manual when a pipette is specified as Instrument:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        Instrument -> Model[Instrument, Pipette, "Eppendorf Research Plus P200, Microbial"],
        Output -> Options
      ];
      Lookup[options, Preparation],
      Manual,
      Variables :> {options}
    ],
    Example[{Options, Preparation, "Preparation is automatically set to Manual when a manual pipette tip is specified as Tips:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationTips -> Model[Item, Tips, "200 uL tips, sterile"],
        Output -> Options
      ];
      Lookup[options, Preparation],
      Manual,
      Variables :> {options}
    ],
    Example[{Options, Preparation, "Preparation is automatically set to Manual when input container is not liquid handler compatible:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid Mammalian sample in cryoVial " <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, Preparation],
      Manual,
      Variables :> {options}
    ],
    Example[{Options, Preparation, "Preparation is automatically set to Manual when specified DestinationMediaContainer is not liquid handler compatible:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        DestinationMediaContainer -> Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
        Output -> Options
      ];
      Lookup[options, Preparation],
      Manual,
      Variables :> {options}
    ],
    Example[{Options, Preparation, "Preparation is automatically set to Manual when Swirl is specified as SourceMixType:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        SourceMixType -> Swirl,
        Output -> Options
      ];
      Lookup[options, Preparation],
      Manual,
      Variables :> {options}
    ],
    Example[{Options, Preparation, "Preparation is automatically set to Robotic for LiquidMedia sample when a Hamilton pipette tip is specified:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationTips -> Model[Item, Tips, "300 uL Hamilton barrier tips, sterile"],
        Output -> Options
      ];
      Lookup[options, Preparation],
      Robotic,
      Variables :> {options}
    ],
    Example[{Options, Preparation, "Preparation is automatically set to Robotic when any SolidMedia specific option is specified:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        MinDiameter -> 0.4 Millimeter,
        Output -> Options
      ];
      Lookup[options, Preparation],
      Robotic,
      Variables :> {options}
    ],
    Example[{Options, Preparation, "Preparation is automatically set to Robotic if DestinationMixType is Shake:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        DestinationMixType -> Shake,
        Output -> Options
      ];
      Lookup[options, Preparation],
      Robotic,
      Variables :> {options}
    ],
    Example[{Options, Preparation, "Preparation can set to Robotic when inoculation source is LiquidMedia:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        Preparation -> Robotic,
        Output -> Options
      ];
      Lookup[options, Preparation],
      Robotic,
      Variables :> {options}
    ],
    Example[{Options, Preparation, "Preparation is always set to Manual when inoculation source is Agar Stab:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, Preparation],
      Manual,
      Variables :> {options}
    ],
    Example[{Options, WorkCell, "WorkCell is always set to qPix when inoculation source is SolidMedia:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, WorkCell],
      qPix,
      Variables :> {options}
    ],
    Example[{Options, WorkCell, "WorkCell is can set to microbioSTAR when inoculation source is microbial cells in liquid media and Preparation is Robotic:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        Preparation -> Robotic,
        Output -> Options
      ];
      Lookup[options, WorkCell],
      microbioSTAR,
      Variables :> {options}
    ],
    Example[{Options, WorkCell, "WorkCell is can set to bioSTAR when inoculation source is mammalian cells in liquid media and Preparation is Robotic:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid Mammalian sample in dwp " <> $SessionUUID],
        Preparation -> Robotic,
        Output -> Options
      ];
      Lookup[options, WorkCell],
      bioSTAR ,
      Variables :> {options}
    ],
    Example[{Options, WorkCell, "WorkCell is Null when inoculation source is FreezeDried:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, WorkCell],
      Null,
      Variables :> {options}
    ],
    Example[{Options, WorkCell, "WorkCell is Null when inoculation source is FrozenGlycerol:"},
      options = ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 2 in cryoVial " <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, WorkCell],
      Null,
      Variables :> {options}
    ],
    Example[{Options, MeasureWeight, "Set the MeasureWeight option to True will cause an error because we expect the samples for post processing will be Living->True:"},
      ExperimentInoculateLiquidMedia[Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],MeasureWeight->True],
      $Failed,
      Messages :> {Error::PostProcessingLivingSamples, Error::InvalidOption}
    ],
    Example[{Options, MeasureVolume, "Set the MeasureVolume option to True will cause an error because we expect the samples for post processing will be Living->True:"},
      ExperimentInoculateLiquidMedia[Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],MeasureVolume->True],
      $Failed,
      Messages :> {Error::PostProcessingLivingSamples, Error::InvalidOption}
    ],
    Example[{Options, ImageSample, "Set the ImageSample option to True will cause an error because we expect the samples for post processing will be Living->True:"},
      ExperimentInoculateLiquidMedia[Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],ImageSample->True],
      $Failed,
      Messages :> {Error::PostProcessingLivingSamples, Error::InvalidOption}
    ],
    (* ------------------------------------------------- Additional ------------------------------------------------- *)
    Example[{Additional, "Generate the proper waste bin resources if InoculationSource is AgarStab:"},
      Module[{protocol},
        protocol = ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 2 in cryoVial " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 3 in cryoVial " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 4 in cryoVial " <> $SessionUUID]
          },
          InoculationSource -> AgarStab,
          TransferEnvironment -> {
            Object[Instrument, BiosafetyCabinet, "ExperimentInoculateLiquidMedia test bsc 1 " <> $SessionUUID],
            Object[Instrument, BiosafetyCabinet, "ExperimentInoculateLiquidMedia test bsc 1 " <> $SessionUUID],
            Object[Instrument, BiosafetyCabinet, "ExperimentInoculateLiquidMedia test bsc 2 " <> $SessionUUID],
            Object[Instrument, BiosafetyCabinet, "ExperimentInoculateLiquidMedia test bsc 2 " <> $SessionUUID]
          }
        ];

        Download[
          protocol,
          {
            (*1*)WasteBins,
            (*2*)WasteBags,
            (*3*)BiosafetyWasteBinPlacements,
            (*4*)BiosafetyWasteBagPlacements,
            (*5*)BiosafetyWasteBinTeardowns,
            (*6*)BiosafetyWasteBagTeardowns
          }
        ]
      ],
      {
        (*1*){
          ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 1 " <> $SessionUUID]],
          ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 1 " <> $SessionUUID]],
          ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 2 " <> $SessionUUID]],
          ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 2 " <> $SessionUUID]]
        },
        (*2*)ConstantArray[ObjectP[Model[Item, Consumable, "id:7X104v6oeYNJ"]], 4], (* Model[Item, Consumable, "Biohazard Waste Bags, 8x12"] *)
        (*3*){
          {
            ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 1 " <> $SessionUUID]],
            ObjectP[Object[Instrument, BiosafetyCabinet, "ExperimentInoculateLiquidMedia test bsc 1 " <> $SessionUUID]],
            "Waste Bin Slot"
          },
          {Null, Null, Null},
          {
            ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 2 " <> $SessionUUID]],
            ObjectP[Object[Instrument, BiosafetyCabinet, "ExperimentInoculateLiquidMedia test bsc 2 " <> $SessionUUID]],
            "Waste Bin Slot"
          },
          {Null, Null, Null}
        },
        (*4*){
          {ObjectP[Model[Item, Consumable, "id:7X104v6oeYNJ"]], ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 1 " <> $SessionUUID]], "A1"},
          {Null, Null, Null},
          {ObjectP[Model[Item, Consumable, "id:7X104v6oeYNJ"]], ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 2 " <> $SessionUUID]], "A1"},
          {Null, Null, Null}
        },
        (*5*){
          Null,
          ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 1 " <> $SessionUUID]],
          Null,
          ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 2 " <> $SessionUUID]]
        },
        (*6*){
          Null,
          ObjectP[Model[Item, Consumable, "id:7X104v6oeYNJ"]],
          Null,
          ObjectP[Model[Item, Consumable, "id:7X104v6oeYNJ"]]
        }
      }
    ],
    Test["Populate the CryogenicGloves field and the corresponding resource if InoculationSource is FrozenGlycerol:",
      Module[{protocol, cryoGloves, requiredResources, cryoGlovesResource},
        protocol = ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 2 in cryoVial " <> $SessionUUID]
          },
          InoculationSource -> FrozenGlycerol,
          TransferEnvironment -> {
            Object[Instrument, BiosafetyCabinet, "ExperimentInoculateLiquidMedia test bsc 1 " <> $SessionUUID],
            Object[Instrument, BiosafetyCabinet, "ExperimentInoculateLiquidMedia test bsc 2 " <> $SessionUUID]
          }
        ];

        {cryoGloves, requiredResources} = Download[protocol, {CryogenicGloves, RequiredResources}];
        cryoGlovesResource = Cases[
          Flatten[
            Cases[requiredResources, {_, CryogenicGloves, _, _}]
          ],
          ObjectP[]
        ];
        {cryoGloves, cryoGlovesResource}
      ],
      {
        ObjectP[Model[Item, Glove]],
        {ObjectP[Object[Resource, Sample]]}
      }
    ],
    Example[{Additional, "Generate the proper waste bin resources if InoculationSource is FrozenGlycerol:"},
      Module[{protocol},
        protocol = ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 2 in cryoVial " <> $SessionUUID]
          },
          InoculationSource -> FrozenGlycerol,
          TransferEnvironment -> {
            Object[Instrument, BiosafetyCabinet, "ExperimentInoculateLiquidMedia test bsc 1 " <> $SessionUUID],
            Object[Instrument, BiosafetyCabinet, "ExperimentInoculateLiquidMedia test bsc 2 " <> $SessionUUID]
          }
        ];

        Download[
          protocol,
          {
            (*1*)WasteBins,
            (*2*)WasteBags,
            (*3*)BiosafetyWasteBinPlacements,
            (*4*)BiosafetyWasteBagPlacements,
            (*5*)BiosafetyWasteBinTeardowns,
            (*6*)BiosafetyWasteBagTeardowns
          }
        ]
      ],
      {
        (*1*){
        ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 1 " <> $SessionUUID]],
        ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 2 " <> $SessionUUID]]
      },
        (*2*)ConstantArray[ObjectP[Model[Item, Consumable, "id:7X104v6oeYNJ"]], 2], (* Model[Item, Consumable, "Biohazard Waste Bags, 8x12"] *)
        (*3*){
          {
            ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 1 " <> $SessionUUID]],
            ObjectP[Object[Instrument, BiosafetyCabinet, "ExperimentInoculateLiquidMedia test bsc 1 " <> $SessionUUID]],
            "Waste Bin Slot"
          },
          {
            ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 2 " <> $SessionUUID]],
            ObjectP[Object[Instrument, BiosafetyCabinet, "ExperimentInoculateLiquidMedia test bsc 2 " <> $SessionUUID]],
            "Waste Bin Slot"
          }
        },
       (*4*){
          {ObjectP[Model[Item, Consumable, "id:7X104v6oeYNJ"]], ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 1 " <> $SessionUUID]], "A1"},
          {ObjectP[Model[Item, Consumable, "id:7X104v6oeYNJ"]], ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 2 " <> $SessionUUID]], "A1"}
        },
        (*5*){
        ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 1 " <> $SessionUUID]],
        ObjectP[Object[Container, WasteBin, "ExperimentInoculateLiquidMedia test biosafety waste bin 2 " <> $SessionUUID]]
        },
        (*6*){
          ObjectP[Model[Item, Consumable, "id:7X104v6oeYNJ"]],
          ObjectP[Model[Item, Consumable, "id:7X104v6oeYNJ"]]
        }
      }
    ],
    Example[{Additional, "Waste bin fields are not populated if InoculationSource is not AgarStab or FrozenGlycerol:"},
      Module[{protocol},
        protocol = ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID]
        ];

        Download[protocol, {WasteBins,WasteBags,BiosafetyWasteBinPlacements,BiosafetyWasteBagPlacements,BiosafetyWasteBinTeardowns,BiosafetyWasteBagTeardowns}]
      ],
      {
        {},
        {},
        {},
        {},
        {},
        {}
      }
    ],

    (* ------------------------------------------------- Messages ------------------------------------------------- *)
    (* Invalid Inputs *)
    Example[{Messages, "DiscardedSamples", "If any user-specified objects have the Status of Discarded, throw an error:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test discarded input sample in cryoVial " <> $SessionUUID]
      ],
      $Failed,
      Messages :> {
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "DeprecatedModels", "Throws an error if model sample is deprecated:"},
      ExperimentInoculateLiquidMedia[
        Model[Sample, "ExperimentInoculateLiquidMedia test deprecated frozen glycerol e.coli culture model " <> $SessionUUID],
        InoculationSource -> FrozenGlycerol
      ],
      $Failed,
      Messages :> {
        Error::DeprecatedModels,
        Error::InvalidInput
      },
      SetUp :> {
        UploadProduct[
          Name -> "ExperimentInoculateLiquidMedia test deprecated frozen glycerol e.coli model Product " <> $SessionUUID,
          Packaging -> Single,
          SampleType -> Vial,
          ProductModel -> Model[Sample, "ExperimentInoculateLiquidMedia test deprecated frozen glycerol e.coli culture model " <> $SessionUUID],
          NumberOfItems -> 1,
          Amount -> 5 Milligram,
          DefaultContainerModel -> Model[Container, Vessel, "id:vXl9j5qEnnOB"], (* Model[Container, Vessel, "2mL Cryogenic Vial"] *)
          CatalogNumber -> "88888",
          Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
          Price -> 100 USD,
          CatalogDescription -> "Test Ecoli FrozenGlycerol product"
        ],
        UploadNotebook[Object[Product, "ExperimentInoculateLiquidMedia test deprecated frozen glycerol e.coli model Product " <> $SessionUUID], Null]
      },
      TearDown :> (EraseObject[
        {Object[Product, "ExperimentInoculateLiquidMedia test deprecated frozen glycerol e.coli model Product " <> $SessionUUID]},
        Force -> True,
        Verbose -> False
      ])
    ],
    Example[{Messages, "DeprecatedModels", "Throws an error if model sample is deprecated:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test deprecated input sample in cryoVial " <> $SessionUUID],
        InoculationSource -> FrozenGlycerol
      ],
      $Failed,
      Messages :> {
        Error::DeprecatedModels,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "ConflictingInoculationSource", "A message is thrown if InoculationSource does not match the input container requirement:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test solid e.coli sample 1 in dwp " <> $SessionUUID],
        InoculationSource -> FreezeDried
      ],
      $Failed,
      Messages :> {
        Error::ConflictingInoculationSource,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "ConflictingInoculationSource", "A message is thrown if InoculationSource does not match the state of the input sample:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          Output -> Options
        ],
        InoculationSource
      ],
      SolidMedia,
      Messages :> {
        Error::ConflictingInoculationSource,
        Warning::ConflictingInoculationSource,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "ConflictingInoculationSource", "If InoculationSource is specified as SolidMedia but Agarose is not found in Composition, throw a warning:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages :> {Warning::ConflictingInoculationSource},
      SetUp :> (
        Upload[<|
          Object -> Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          Replace[Composition] -> {
            {1/1000 Milligram/Milliliter, Link[Model[Cell, Bacteria, "ExperimentInoculateLiquidMedia test e.coli model - gfp Positive " <> $SessionUUID]], Now},
            {100 VolumePercent, Link[Model[Molecule, "Water"]], Now}
          }
        |>]
      ),
      TearDown :> (
        Upload[<|
          Object -> Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          Replace[Composition] -> {
            {1/1000 Milligram/Milliliter, Link[Model[Cell, Bacteria, "ExperimentInoculateLiquidMedia test e.coli model - gfp Positive " <> $SessionUUID]], Now},
            {100 VolumePercent, Link[Model[Molecule, "Water"]], Now},
            {3/193 Gram/Milliliter, Link[Model[Molecule, "id:4pO6dM5l7lMX"]], Now}
          }
        |>]
      )
    ],
    Example[{Messages, "ConflictingInoculationSource", "If InoculationSource is specified as FrozenGlycerol but Glycerol is not found in Composition, throw a warning:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> FrozenGlycerol
      ],
      ObjectP[Object[Protocol, InoculateLiquidMedia]],
      Messages :> {Warning::ConflictingInoculationSource},
      SetUp :> (
        Upload[<|
          Object -> Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
          Replace[Composition] -> {
            {1/1000 Milligram/Milliliter, Link[Model[Cell, Bacteria, "ExperimentInoculateLiquidMedia test e.coli model - gfp Positive " <> $SessionUUID]], Now},
            {100 VolumePercent, Link[Model[Molecule, "Nutrient Broth"]], Now}
          }
        |>]
      ),
      TearDown :> (
        Upload[<|
          Object -> Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
          Replace[Composition] -> {
            {1/1000 Milligram/Milliliter, Link[Model[Cell, Bacteria, "ExperimentInoculateLiquidMedia test e.coli model - gfp Positive " <> $SessionUUID]], Now},
            {50 VolumePercent, Link[Model[Molecule, "Nutrient Broth"]], Now},
            {50 VolumePercent, Link[Model[Molecule, "id:WNa4ZjKVdbW7"]], Now}
          }
        |>]
      )
    ],
    Example[{Messages, "InvalidModelSampleInoculationSourceType", "If the input samples contain Model[Sample] and the model is evaluated to be of InoculationSource type of SolidMedia or LiquidMedia, throw an error:"},
      ExperimentInoculateLiquidMedia[
        {
          Model[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture model " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID]
        }
      ],
      $Failed,
      Messages :> {
        Error::InvalidModelSampleInoculationSourceType,
        Error::InvalidInput
      },
      SetUp :> {
        UploadProduct[
          Name -> "ExperimentInoculateLiquidMedia test liquid e.coli culture model Product " <> $SessionUUID,
          Packaging -> Single,
          SampleType -> Plate,
          ProductModel -> Model[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture model " <> $SessionUUID],
          NumberOfItems -> 1,
          Amount -> 5 Milliliter,
          DefaultContainerModel -> Model[Container, Plate, "id:jLq9jXY4kkMq"], (* Model[Container, Plate, "24-well Round Bottom Deep Well Plate"] *)
          CatalogNumber -> "88888",
          Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
          Price -> 100 USD,
          CatalogDescription -> "Test Ecoli LiquidMedia product"
        ],
        UploadNotebook[Object[Product, "ExperimentInoculateLiquidMedia test liquid e.coli culture model Product " <> $SessionUUID], Null]
      },
      TearDown :> (EraseObject[
        {Object[Product, "ExperimentInoculateLiquidMedia test liquid e.coli culture model Product " <> $SessionUUID]},
        Force -> True,
        Verbose -> False
      ])
    ],
    Example[{Messages, "UnsupportedInoculationSourceType", "If the input Model[Sample] is classified as FrozenLiquidMedia, throw an error:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID]
      ],
      $Failed,
      Messages :> {
        Error::UnsupportedInoculationSourceType,
        Error::InvalidInput
      },
      SetUp :> (
        Upload[<|
          Object -> Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
          Replace[Composition] -> {
            {1000 Cell/Milliliter, Link[Model[Cell, Bacteria, "ExperimentInoculateLiquidMedia test e.coli model - gfp Positive " <> $SessionUUID]], Now},
            {100 VolumePercent, Link[Model[Molecule, "Water"]], Now}
          }
        |>]
      ),
      TearDown :> (
        Upload[<|
          Object -> Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
          Replace[Composition] -> {
            {1000 Cell/Milliliter, Link[Model[Cell, Bacteria, "ExperimentInoculateLiquidMedia test e.coli model - gfp Positive " <> $SessionUUID]], Now},
            {50 VolumePercent, Link[Model[Molecule, "Water"]], Now},
            {50 VolumePercent, Link[Model[Molecule, "Glycerol"]], Now}
          }
        |>]
      )
    ],
    Example[{Messages, "MultipleInoculationSourceInInput", "If any user-specified objects have multiple types of inoculation sources, throw an error:"},
      ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID]
        }
      ],
      $Failed,
      Messages :> {
        Error::MultipleInoculationSourceInInput,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "DuplicatedFreezeDriedSamples", "If any user-specified objects have multiple types of inoculation sources, throw an error:"},
      ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID]
        }
      ],
      $Failed,
      Messages :> {
        Error::DuplicatedFreezeDriedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "UnsupportedCellTypes", "If an unsupported cell type is provided (not Bacterial, Mammalian, or Yeast), an error is thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test Insect pellet sample in dwp " <> $SessionUUID],
        InoculationSource -> FrozenGlycerol,
        DestinationMedia -> Model[Sample, Media, "LB Broth, Miller"]
      ],
      $Failed,
      Messages :> {
        Error::UnsupportedCellTypes,
        Warning::ConflictingInoculationSource,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "NonOmniTrayContainer", "If InoculationSource is SolidMedia, return $Failed if the input samples are not in an omnitray:"},
      ExperimentInoculateLiquidMedia[Object[Sample, "ExperimentInoculateLiquidMedia test solid e.coli sample 1 in dwp " <> $SessionUUID]],
      $Failed,
      Messages :> {
        Error::NonOmniTrayContainer,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "TooManyInputContainers", "If InoculationSource is SolidMedia, return $Failed if the input samples are contained in more than 4 unique containers:"},
      ExperimentInoculateLiquidMedia[
        {
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test omniTray 1 " <> $SessionUUID],
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test omniTray 2 " <> $SessionUUID],
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test omniTray 3 " <> $SessionUUID],
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test omniTray 4 " <> $SessionUUID],
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test omniTray 5 " <> $SessionUUID],
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test omniTray 6 " <> $SessionUUID]
        },
        InoculationSource -> SolidMedia
      ],
      $Failed,
      Messages :> {
        Error::TooManyInputContainers,
        Error::InvalidInput
      }
    ],
    (* Invalid Options *)
    Example[{Messages, "PreparedModelMissingProduct", "If the input Model[Sample] does not have Products populated, throw an error:"},
      ExperimentInoculateLiquidMedia[
        {
          Model[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli sample Model " <> $SessionUUID],
          Model[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli sample Model " <> $SessionUUID]
        }
      ],
      $Failed,
      Messages :> {Error::PreparedModelMissingProduct, Error::InvalidOption}
    ],
    Example[{Messages, "PreparedModelMissingProduct", "If the input Model[Sample] has product but is missing Amount or DefaultContainerModel information, throw an error:"},
      ExperimentInoculateLiquidMedia[
        Model[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli sample Model " <> $SessionUUID]
      ],
      $Failed,
      Messages :> {Error::PreparedModelMissingProduct, Error::InvalidOption},
      SetUp :> {
        UploadProduct[
          Name -> "ExperimentInoculateLiquidMedia test freeze dried e.coli sample Model Product " <> $SessionUUID,
          Packaging -> Single,
          SampleType -> Vial,
          ProductModel -> Model[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli sample Model " <> $SessionUUID],
          NumberOfItems -> 1,
          Amount -> 1 Gram,
          CatalogNumber -> "88888",
          Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
          Price -> 100 USD,
          CatalogDescription -> "Test Ecoli FreezeDriedproduct"
        ],
        UploadNotebook[Object[Product, "ExperimentInoculateLiquidMedia test freeze dried e.coli sample Model Product " <> $SessionUUID], Null]
      },
      TearDown :> (EraseObject[
        {Object[Product, "ExperimentInoculateLiquidMedia test freeze dried e.coli sample Model Product " <> $SessionUUID]},
        Force -> True,
        Verbose -> False
      ])
    ],
    Example[{Messages, "InstrumentPrecision", "If a Volume with a greater precision than 0.1 Microliter is given, it is rounded:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 2 in dwp " <> $SessionUUID]
          },
          InoculationSource -> LiquidMedia,
          Volume -> {All, 299.95 Microliter},
          Output -> Options
        ],
        Volume
      ],
      {All, RangeP[300.0 Microliter]},
      Messages :> {Warning::InstrumentPrecision}
    ],
    Example[{Messages, "InstrumentPrecision", "If a MediaVolume with a greater precision than 1 Microliter is given, it is rounded:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          DestinationMediaContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
          MediaVolume -> 1.66666 Milliliter,
          Output -> Options
        ],
        MediaVolume
      ],
      RangeP[1.667 Milliliter],
      Messages :> {Warning::InstrumentPrecision}
    ],
    Example[{Messages, "InstrumentPrecision", "If an ExposureTime with a greater precision than 1 Millisecond is given, it is rounded:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          ExposureTimes -> {1.5 Millisecond, 2 Millisecond},
          Output -> Options
        ],
        ExposureTimes
      ],
      {RangeP[2 Millisecond]..},
      Messages :> {Warning::InstrumentPrecision}
    ],
    Example[{Messages, "InstrumentPrecision", "If a PrimaryDryTime with a greater precision than 1 Second is given, it is rounded:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          PrimaryDryTime -> 1.5 Second,
          Output -> Options
        ],
        PrimaryDryTime
      ],
      RangeP[2 Second],
      Messages :> {Warning::InstrumentPrecision}
    ],
    Example[{Messages, "InstrumentPrecision", "If a ColonyPickingDepth with a greater precision than 0.01 Millimeter is given, it is rounded:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          ColonyPickingDepth -> 1.222 Millimeter,
          Output -> Options
        ],
        ColonyPickingDepth
      ],
      RangeP[1.22 Millimeter],
      Messages :> {Warning::InstrumentPrecision}
    ],
    Example[{Messages, "InstrumentPrecision", "If an ExposureTime with a greater precision than 1 Millisecond is given, it is rounded:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          ExposureTimes -> {1.5 Millisecond, 2 Millisecond},
          Output -> Options
        ],
        ExposureTimes
      ],
      {RangeP[2 Millisecond], RangeP[2 Millisecond]},
      Messages :> {Warning::InstrumentPrecision}
    ],
    Example[{Messages, "InstrumentPrecision", "If a PrimaryDryTime with a greater precision than 1 Second is given, it is rounded:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          PrimaryDryTime -> 1.5 Second,
          Output -> Options
        ],
        PrimaryDryTime
      ],
      RangeP[2 Second],
      Messages :> {Warning::InstrumentPrecision}
    ],
    Example[{Messages, "DuplicateName", "If Preparation is set to Robotic, and a RCP with the same name exists, throw an error:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        Preparation -> Robotic,
        Name -> "Duplicated Name for robotic protocol ExperimentInoculateLiquidMedia test " <> $SessionUUID
      ],
      $Failed,
      SetUp :> (
        Upload[<|Type -> Object[Protocol, RoboticCellPreparation], Name -> "Duplicated Name for robotic protocol ExperimentInoculateLiquidMedia test " <> $SessionUUID|>]
      ),
      TearDown :> (
        EraseObject[
          {Object[Protocol, RoboticCellPreparation, "Duplicated Name for robotic protocol ExperimentInoculateLiquidMedia test " <> $SessionUUID]},
          Force -> True,
          Verbose -> False
        ]
      ),
      Messages :> {
        Error::DuplicateName,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DuplicateName", "If Preparation is Manual, and a InoculateLiquidMedia with the same name exists, throw an error:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        Preparation -> Manual,
        Name -> "Duplicated Name for manual protocol ExperimentInoculateLiquidMedia test " <> $SessionUUID
      ],
      $Failed,
      SetUp :> (
        Upload[<|Type -> Object[Protocol, InoculateLiquidMedia], Name -> "Duplicated Name for manual protocol ExperimentInoculateLiquidMedia test " <> $SessionUUID|>]
      ),
      TearDown :> (
        EraseObject[
          {Object[Protocol, InoculateLiquidMedia, "Duplicated Name for manual protocol ExperimentInoculateLiquidMedia test " <> $SessionUUID]},
          Force -> True,
          Verbose -> False
        ]
      ),
      Messages :> {
        Error::DuplicateName,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingUnitOperationMethodRequirements", "If Preparation is set to Robotic for LiquidMedia sample but a manual pipette tip is specified:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationTips -> Model[Item, Tips, "200 uL tips, sterile"],
        Preparation -> Robotic
      ],
      $Failed,
      Messages :> {
        Error::ConflictingUnitOperationMethodRequirements,
        Error::IncompatibleTips,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingUnitOperationMethodRequirements", "If Preparation is Robotic, an error will be thrown when Instrument is a Pipette:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        Preparation -> Robotic,
        Instrument -> Model[Instrument, Pipette, "id:vXl9j57VBAjN"]
      ],
      $Failed,
      Messages :> {
        Error::ConflictingUnitOperationMethodRequirements,
        Error::InvalidInoculationInstrument,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingUnitOperationMethodRequirements", "If InoculationSource is SolidMedia and DestinationMixType is Swirl, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        DestinationMixType -> Swirl
      ],
      $Failed,
      Messages :> {
        Error::ConflictingUnitOperationMethodRequirements,
        Error::InoculationSourceOptionMismatch,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingUnitOperationMethodRequirements", "If Preparation is set to Robotic for LiquidMedia sample but input container is not liquid handler compatible:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid Mammalian sample in cryoVial " <> $SessionUUID],
        Preparation -> Robotic
      ],
      $Failed,
      Messages :> {
        Error::ConflictingUnitOperationMethodRequirements,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingUnitOperationMethodRequirements", "If Preparation is set to Robotic but a non-LiquidHandler compatible DestinationMediaContainer is specified:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        DestinationMediaContainer -> Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
        Preparation -> Robotic
      ],
      $Failed,
      Messages :> {
        Error::ConflictingUnitOperationMethodRequirements,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingUnitOperationMethodRequirements", "If Preparation is set to Manual for LiquidMedia sample but a hamilton pipette tip is specified:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationTips -> Model[Item, Tips, "300 uL Hamilton barrier tips, sterile"],
        Preparation -> Manual
      ],
      $Failed,
      Messages :> {
        Error::ConflictingUnitOperationMethodRequirements,
        Error::IncompatibleTips,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingUnitOperationMethodRequirements", "Preparation is set to Manual for LiquidMedia sample but DestinationMixType is specified as Shake:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        DestinationMixType -> Shake,
        Preparation -> Manual
      ],
      $Failed,
      Messages :> {
        Error::ConflictingUnitOperationMethodRequirements,
        Error::InoculationSourceOptionMismatch,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingUnitOperationMethodRequirements", "Preparation is set to Manual for LiquidMedia sample but WorkCell is specified:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        WorkCell -> microbioSTAR,
        Preparation -> Manual
      ],
      $Failed,
      Messages :> {
        Error::ConflictingWorkCellWithPreparation,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingWorkCellWithPreparation", "If Preparation is Robotic, an error will be thrown if WorkCell is Null:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        Preparation -> Robotic,
        WorkCell -> Null
      ],
      $Failed,
      Messages :> {
        Error::ConflictingWorkCellWithPreparation,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "InvalidInoculationInstrument", "If InoculationSource is SolidMedia and Instrument is a LiquidHandler, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        Instrument -> Model[Instrument, LiquidHandler, "GX-271 for Cleavage"]
      ],
      $Failed,
      Messages :> {
        Error::InvalidInoculationInstrument,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "InvalidInoculationInstrument", "If InoculationSource is LiquidMedia and Preparation is Robotic, an error will be thrown when Instrument is a solid handling LiquidHandler:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        Instrument -> Model[Instrument, LiquidHandler, "GX-271 for Cleavage"]
      ],
      $Failed,
      Messages :> {
        Error::InvalidInoculationInstrument,
        Error::IncompatibleInstrumentAndCellType,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "InvalidInoculationInstrument", "If InoculationSource is FreezeDried and Instrument is a serological pipette, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        InoculationSource -> FreezeDried,
        Instrument -> Model[Instrument, Pipette, "id:4pO6dM51ljY5"](* "pipetus, Microbial" *)
      ],
      $Failed,
      Messages :> {
        Error::InvalidInoculationInstrument,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "InvalidInoculationInstrument", "If InoculationSource is LiquidMedia and Preparation is Manual, an error will be thrown if Volume exceeds MaxVolume of pipette:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        Volume -> 150 Microliter,
        Instrument -> Model[Instrument, Pipette, "id:kEJ9mqRlbZxV"] (* "Eppendorf Research Plus P20, Microbial" *)
      ],
      $Failed,
      Messages :> {
        Error::InvalidInoculationInstrument,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "IncompatibleInstrumentAndCellType", "If using QPix colony handler, an error will be thrown when cell type is Mammalian:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test Mammalian sample in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        Instrument -> Model[Instrument, ColonyHandler, "QPix 420 HT"]
      ],
      $Failed,
      Messages :> {
        Error::IncompatibleInstrumentAndCellType,
        Warning::NotPreferredColonyHandlerHead,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "IncompatibleInstrumentAndCellType", "An error will be thrown if tissue culture pipette is selected for microbial samples:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        Volume -> 150 Microliter,
        Instrument -> Model[Instrument, Pipette, "Eppendorf Research Plus P200, Tissue Culture"]
      ],
      $Failed,
      Messages :> {
        Error::IncompatibleInstrumentAndCellType,
        Error::TransferEnvironmentInstrumentCombination,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "IncompatibleInstrumentAndCellType", "An error will be thrown if bioSTAR is selected for microbial samples:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        Instrument ->  Model[Instrument, LiquidHandler, "bioSTAR"]
      ],
      $Failed,
      Messages :> {
        Error::IncompatibleInstrumentAndCellType,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "IncompatibleBiosafetyCabinetAndCellType", "If TransferEnvironment model specified is not compatible with the cell type in the input sample, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        TransferEnvironment -> Model[Instrument, BiosafetyCabinet, "id:dORYzZJzEBdE"](* Model[Instrument, BiosafetyCabinet, "Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Tissue Culture)"] *)
      ],
      $Failed,
      Messages :> {
        Error::IncompatibleBiosafetyCabinetAndCellType,
        Error::TransferEnvironmentInstrumentCombination,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "IncompatibleBiosafetyCabinetAndCellType", "If TransferEnvironment object specified is not compatible with the cell type in the input sample, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        TransferEnvironment -> Object[Instrument, BiosafetyCabinet, "ExperimentInoculateLiquidMedia test tc bsc 1 " <> $SessionUUID]
      ],
      $Failed,
      Messages :> {
        Error::IncompatibleBiosafetyCabinetAndCellType,
        Error::TransferEnvironmentInstrumentCombination,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is SolidMedia and SourceMix (only valid for LiquidMedia) is specified, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        SourceMix -> True
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is SolidMedia but Populations is specified to Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        Populations -> Null
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is SolidMedia but DestinationMixType is specified as Pipette, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        DestinationMixType -> Pipette
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is SolidMedia but PrimaryWash is specified to Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        PrimaryWash -> Null
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is SolidMedia but SamplesInStorageCondition is specified to Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        SamplesInStorageCondition -> Null
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is SolidMedia but DestinationMedia is specified to Null for one of the Populations, an error with both messages will be thrown:"},
      ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
        },
        InoculationSource -> SolidMedia,
        Populations -> {
          {Diameter[], Fluorescence[]},
          {Diameter[]}
        },
        DestinationMedia -> {
          {Null, Model[Sample, Media, "LB Broth, Miller"]},
          {Model[Sample, Media, "LB Broth, Miller"]}
        }
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is SolidMedia but DestinationWell and DestinationMixVolume is specified to non-Null values, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        DestinationWell -> "A1",
        DestinationMixVolume -> 10 Microliter
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is SolidMedia but MediaVolume is specified to Null and SourceMix (LiquidMedia only option) is specified, an error with both messages will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        MediaVolume -> Null,
        SourceMix -> True
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is LiquidMedia and ImagingStrategies (only valid for SolidMedia) is specified, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        ImagingStrategies -> BrightField
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is LiquidMedia but DestinationMixType is specified as Shake, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        DestinationMixType -> Shake
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is LiquidMedia and MediaVolume is specified as Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        MediaVolume -> Null
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is LiquidMedia and Volume is specified as Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        MediaVolume -> Null
      ],
      $Failed,
      Messages :> {
        Error::InoculationSourceOptionMismatch,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is LiquidMedia and DestinationWell is specified as Null and NumberOfSourceScrapes (only valid for FrozenGlycerol) is specified, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        DestinationWell -> Null,
        NumberOfSourceScrapes -> 3
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is AgarStab and NumberOfSourceScrapes (only valid for FrozenGlycerol) is specified, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> AgarStab,
        NumberOfSourceScrapes -> 3
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is AgarStab and MediaVolume is specified as Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> AgarStab,
        MediaVolume -> Null
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is FreezeDried and NumberOfSourceScrapes (only valid for FrozenGlycerol) is specified, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        InoculationSource -> FreezeDried,
        NumberOfSourceScrapes -> 3
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is FreezeDried but ResuspensionMedia is specified as Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        InoculationSource -> FreezeDried,
        ResuspensionMedia -> Null
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is FreezeDried but SamplesInStorageCondition is specified as Refrigerator, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        InoculationSource -> FreezeDried,
        SamplesInStorageCondition -> Refrigerator
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is FrozenGlycerol but NumberOfSourceScrapes is specified as Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> FrozenGlycerol ,
        NumberOfSourceScrapes -> Null
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "InoculationSourceOptionMismatch", "If InoculationSource is FrozenGlycerol but Volume is specified (only valid for LiquidMedia or FreezeDried), an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> FrozenGlycerol ,
        Volume -> 1 Milliliter
      ],
      $Failed,
      Messages :> {Error::InoculationSourceOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "NoPreferredLiquidMedia", "If InoculationSource is AgarStab, if the input sample contains a Model[Cell] in its composition that does not have a PreferredLiquidMedia, a warning is thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 5 in cryoVial - no PreferredLiquidMedia " <> $SessionUUID],
          InoculationSource -> AgarStab,
          Output -> Options
        ],
        DestinationMedia
      ],
      ObjectP[Model[Sample, Media, "LB Broth, Miller"]],
      Messages :> {Warning::NoPreferredLiquidMedia}
    ],
    Example[{Messages, "InvalidDestinationMediaState", "If InoculationSource is SolidMedia, when the DestinationMedia is not Liquid, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        DestinationMedia -> Model[Sample, Media, "LB (Solid Agar)"],
        InoculationSource -> SolidMedia
      ],
      $Failed,
      Messages :> {Error::InvalidDestinationMediaState, Error::InvalidOption}
    ],
    Example[{Messages, "InvalidDestinationMediaState", "If InoculationSource is LiquidMedia, when the DestinationMedia is not Liquid, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        DestinationMedia -> Model[Sample, Media, "LB (Solid Agar)"]
      ],
      $Failed,
      Messages :> {Error::InvalidDestinationMediaState, Error::InvalidOption}
    ],
    Example[{Messages, "InvalidDestinationMediaState", "If InoculationSource is AgarStab, when the DestinationMedia is not Liquid, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> AgarStab,
        DestinationMedia -> Model[Sample, Media, "LB (Solid Agar)"]
      ],
      $Failed,
      Messages :> {Error::InvalidDestinationMediaState, Error::InvalidOption}
    ],
    Example[{Messages, "InvalidDestinationMediaState", "If InoculationSource is FreezeDried, when the DestinationMedia is not Liquid, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        InoculationSource -> FreezeDried,
        ResuspensionMedia -> Model[Sample, Media, "LB Broth, Miller"],
        DestinationMedia -> Model[Sample, Media, "LB (Solid Agar)"]
      ],
      $Failed,
      Messages :> {Error::InvalidDestinationMediaState, Error::InvalidOption}
    ],
    Example[{Messages, "InvalidDestinationMediaState", "If InoculationSource is FreezeDried, when the ResuspensionMedia is automatically set from a non-liquid DestinationMedia, only one error will be thrown for DestinationMedia:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          InoculationSource -> FreezeDried,
          ResuspensionMedia -> Automatic,
          DestinationMedia -> Model[Sample, Media, "LB (Solid Agar)"],
          Output -> Options
        ],
        {ResuspensionMedia, DestinationMedia}
      ],
      {ObjectP[Model[Sample, Media, "LB (Solid Agar)"]], ObjectP[Model[Sample, Media, "LB (Solid Agar)"]]},
      Messages :> {Error::InvalidDestinationMediaState, Error::InvalidOption}
    ],
    Example[{Messages, "InvalidDestinationMediaState", "If InoculationSource is FrozenGlycerol, when the DestinationMedia is not Liquid, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> FrozenGlycerol,
        DestinationMedia -> Model[Sample, Media, "LB (Solid Agar)"]
      ],
      $Failed,
      Messages :> {Error::InvalidDestinationMediaState, Error::InvalidOption}
    ],
    Example[{Messages, "DestinationMediaContainerOverfill", "If InoculationSource is SolidMedia, when the MediaVolume is more than MaxVolume of DestinationMediaContainer, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        MediaVolume -> 1 Milliliter,
        DestinationMediaContainer -> Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"]
      ],
      $Failed,
      Messages :> {Error::DestinationMediaContainerOverfill, Error::InvalidOption}
    ],
    Example[{Messages, "DestinationMediaContainerOverfill", "If InoculationSource is SolidMedia, when the MediaVolume is more than MaxVolume of DestinationMediaContainer for one of the Populations, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
        },
        InoculationSource -> SolidMedia,
        Populations -> {
          {Diameter[], Fluorescence[]},
          {Diameter[]}
        },
        MediaVolume -> {{0.3 Milliliter, 0.1 Milliliter}, {0.1 Milliliter}},
        DestinationMediaContainer -> Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"]
      ],
      $Failed,
      Messages :> {Error::DestinationMediaContainerOverfill, Error::InvalidOption}
    ],
    Example[{Messages, "DestinationMediaContainerOverfill", "If InoculationSource is LiquidMedia, when the MediaVolume plus Volume is more than MaxVolume of DestinationMediaContainer, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        MediaVolume -> 1.6 Milliliter,
        Volume -> 0.5 Milliliter,
        DestinationMediaContainer -> Model[Container, Vessel, "2mL Tube"]
      ],
      $Failed,
      Messages :> {Error::DestinationMediaContainerOverfill, Error::InvalidOption}
    ],
    Example[{Messages, "DestinationMediaContainerOverfill", "If InoculationSource is AgarStab, when the MediaVolume is more than MaxVolume of DestinationMediaContainer, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> AgarStab,
        MediaVolume -> 3 Milliliter,
        DestinationMediaContainer -> Model[Container, Vessel, "2mL Tube"]
      ],
      $Failed,
      Messages :> {Error::DestinationMediaContainerOverfill, Error::InvalidOption}
    ],
    Example[{Messages, "DestinationMediaContainerOverfill", "If InoculationSource is FreezeDried, when the MediaVolume is more than MaxVolume of one of the DestinationMediaContainer, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        InoculationSource -> FreezeDried,
        MediaVolume -> 3 Milliliter,
        DestinationMediaContainer -> {{Model[Container, Vessel, "2mL Tube"], Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"]}}
      ],
      $Failed,
      Messages :> {Error::DestinationMediaContainerOverfill, Error::InvalidOption}
    ],
    Example[{Messages, "DestinationMediaContainerOverfill", "If InoculationSource is FrozenGlycerol, when the MediaVolume is more than MaxVolume of DestinationMediaContainer, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> FrozenGlycerol,
        MediaVolume -> 3 Milliliter,
        DestinationMediaContainer -> Model[Container, Vessel, "2mL Tube"]
      ],
      $Failed,
      Messages :> {Error::DestinationMediaContainerOverfill, Error::InvalidOption}
    ],
    Example[{Messages, "OverAspiratedTransfer", "If InoculationSource is LiquidMedia, if Volume is more than will be in the container/well of the input sample at the time of the transfer, a warning is thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        Volume -> 2 Milliliter,
        Output -> Options
      ],
      _,
      Messages :> {Warning::OveraspiratedTransfer, Warning::InsufficientVolume}
    ],
    Example[{Messages, "MultipleDestinationMediaContainers", "If InoculationSource is LiquidMedia, when multiple DestinationMediaContainer are specified, an error is thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        DestinationMediaContainer -> {{
          Model[Container, Vessel, "50mL Tube"],
          Model[Container, Vessel, "50mL Tube"]
        }}
      ],
      $Failed,
      Messages :> {Error::MultipleDestinationMediaContainers, Error::InvalidOption}
    ],
    Example[{Messages, "MultipleDestinationMediaContainers", "If InoculationSource is LiquidMedia, when multiple MediaVolume are specified and DestinationMediaContainer is auto-expanded, an error is thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        MediaVolume -> {{
          5 Milliliter,
          5 Milliliter
        }}
      ],
      $Failed,
      Messages :> {Error::MultipleDestinationMediaContainers, Error::InvalidOption}
    ],
    Example[{Messages, "MultipleDestinationMediaContainers", "If InoculationSource is AgarStab, when multiple DestinationMediaContainer are specified, an error is thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> AgarStab,
        DestinationMediaContainer -> {{
          Model[Container, Vessel, "50mL Tube"],
          Model[Container, Vessel, "50mL Tube"]
        }}
      ],
      $Failed,
      Messages :> {Error::MultipleDestinationMediaContainers, Error::InvalidOption}
    ],
    Example[{Messages, "MultipleDestinationMediaContainers", "If InoculationSource is FrozenGlycerol, when multiple DestinationMediaContainer are specified, an error is thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> FrozenGlycerol,
        DestinationMediaContainer -> {{
          Model[Container, Vessel, "50mL Tube"],
          Model[Container, Vessel, "50mL Tube"]
        }}
      ],
      $Failed,
      Messages :> {Error::MultipleDestinationMediaContainers, Error::InvalidOption}
    ],
    Example[{Messages, "InvalidTransferWellSpecification", "If InoculationSource is LiquidMedia, a message is thrown if a bogus DestinationWell is given:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        DestinationMediaContainer -> Object[Container, Vessel, "ExperimentInoculateLiquidMedia test destination 5mL tube 1 " <> $SessionUUID],
        DestinationWell -> "A2"
      ],
      $Failed,
      Messages :> {Error::InvalidTransferWellSpecification, Error::InvalidOption}
    ],
    Example[{Messages, "InvalidDestinationWell", "If InoculationSource is AgarStab, when the specified DestinationWell is not a Position in the DestinationMediaContainer, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
        DestinationWell -> "A3"
      ],
      $Failed,
      Messages :> {Error::InvalidDestinationWell, Error::InvalidOption}
    ],
    Example[{Messages, "InvalidDestinationWell", "If InoculationSource is FreezeDried, when the specified DestinationWell is not a Position in the DestinationMediaContainer, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        InoculationSource -> FreezeDried,
        DestinationWell -> "A3"
      ],
      $Failed,
      Messages :> {Error::InvalidDestinationWell, Error::InvalidOption}
    ],
    Example[{Messages, "InvalidDestinationWell", "If InoculationSource is FrozenGlycerol, when the specified DestinationWell is not a Position in the DestinationMediaContainer, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> FrozenGlycerol,
        DestinationWell -> "A3"
      ],
      $Failed,
      Messages :> {Error::InvalidDestinationWell, Error::InvalidOption}
    ],
    Example[{Messages, "DestinationMixMismatch", "If InoculationSource is SolidMedia, when DestinationMix is set to False and but DestinationNumberOfMixes is set to a number, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        DestinationMix -> False,
        DestinationNumberOfMixes -> 10
      ],
      $Failed,
      Messages :> {Error::DestinationMixMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "DestinationMixMismatch", "If InoculationSource is SolidMedia, when DestinationMix is set to True and but DestinationMixType is set to Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        DestinationMix -> True,
        DestinationMixType -> Null
      ],
      $Failed,
      Messages :> {Error::DestinationMixMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "DestinationMixMismatch", "If InoculationSource is LiquidMedia, when DestinationMix is set to False and but DestinationNumberOfMixes is set to a number, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        DestinationMix -> False,
        DestinationNumberOfMixes -> 10
      ],
      $Failed,
      Messages :> {Error::DestinationMixMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "DestinationMixMismatch", "If InoculationSource is LiquidMedia, when DestinationMix is set to True and but DestinationMixType is set to Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID],
        InoculationSource -> LiquidMedia,
        DestinationMix -> True,
        DestinationMixType -> Null
      ],
      $Failed,
      Messages :> {Error::DestinationMixMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "DestinationMixMismatch", "If InoculationSource is AgarStab, when DestinationMix is set to True but DestinationNumberOfMixes is Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
        DestinationMix -> True,
        DestinationNumberOfMixes -> Null
      ],
      $Failed,
      Messages :> {Error::DestinationMixMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "DestinationMixMismatch", "If InoculationSource is FreezeDried, when DestinationMix is set to True but DestinationNumberOfMixes is Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        InoculationSource -> FreezeDried,
        DestinationMix -> True,
        DestinationMediaContainer -> {
          {
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"]
          }
        },
        DestinationNumberOfMixes -> {{Null, 5}}
      ],
      $Failed,
      Messages :> {Error::DestinationMixMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "DestinationMixMismatch", "If InoculationSource is FrozenGlycerol, when DestinationMix is set to True but DestinationNumberOfMixes is Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> FrozenGlycerol,
        DestinationMix -> True,
        DestinationNumberOfMixes -> Null
      ],
      $Failed,
      Messages :> {Error::DestinationMixMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "NoTipsFound", "If InoculationSource is AgarStab, an error is thrown if there are no InoculationTips that can reach the bottom of DestinationMediaContainer:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> AgarStab,
        DestinationMediaContainer -> Model[Container, Vessel, "20L Polypropylene Carboy, Sterile"]
      ],
      $Failed,
      Messages :> {Error::NoTipsFound, Error::InvalidOption}
    ],
    Example[{Messages, "NoTipsFound", "If InoculationSource is FreezeDried, an error is thrown if there are no InoculationTips that can reach the bottom of DestinationMediaContainer:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        InoculationSource -> FreezeDried,
        DestinationMediaContainer -> Model[Container, Vessel, "20L Polypropylene Carboy, Sterile"],
        DestinationMixType -> Pipette
      ],
      $Failed,
      Messages :> {Error::NoTipsFound, Error::InvalidOption}
    ],
    Example[{Messages, "NoTipsFound", "If InoculationSource is FreezeDried, no error is thrown if there are no InoculationTips that can reach the bottom of DestinationMediaContainer but DestinationMixType is not Pipette:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          InoculationSource -> FreezeDried,
          DestinationMediaContainer -> Model[Container, Vessel, "20L Polypropylene Carboy, Sterile"],
          DestinationMixType -> Swirl,
          Output -> Options
        ],
        InoculationTips
      ],
      ObjectP[Model[Item, Tips, "1000 uL reach tips, sterile"]]
    ],
    Example[{Messages, "NoTipsFound", "If InoculationSource is FrozenGlycerol, an error is thrown if there are no InoculationTips that can reach the bottom of DestinationMediaContainer:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> FrozenGlycerol,
        DestinationMediaContainer -> Model[Container, Vessel, "20L Polypropylene Carboy, Sterile"]
      ],
      $Failed,
      Messages :> {Error::NoTipsFound, Error::InvalidOption}
    ],
    Example[{Messages, "TipConnectionMismatch", "If InoculationSource is AgarStab, if the specified Instrument and specified Tips do not have the same TipConnectionType, an error is thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID],
          Instrument -> Model[Instrument, Pipette, "id:GmzlKjP3boWe"], (* "Eppendorf Research Plus P1000, Microbial" *)
          InoculationTips -> Model[Item, Tips, "id:WNa4ZjRr5ljD"], (* Model[Item, Tips, "1 mL glass barrier serological pipets, sterile"] *)
          Output -> Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "id:GmzlKjP3boWe"]],
      Messages :> {Error::TipConnectionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "TipConnectionMismatch", "If InoculationSource is FreezeDried, if the specified Instrument and specified Tips do not have the same TipConnectionType, an error is thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          Instrument -> Model[Instrument, Pipette, "id:GmzlKjP3boWe"], (* "Eppendorf Research Plus P1000, Microbial" *)
          InoculationTips -> Model[Item, Tips, "id:WNa4ZjRr5ljD"], (* Model[Item, Tips, "1 mL glass barrier serological pipets, sterile"] *)
          Output -> Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "id:GmzlKjP3boWe"]],
      Messages :> {Error::TipConnectionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "TipConnectionMismatch", "If InoculationSource is FrozenGlycerol, if the specified Instrument and specified Tips do not have the same TipConnectionType, an error is thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
          Instrument -> Model[Instrument, Pipette, "id:GmzlKjP3boWe"], (* "Eppendorf Research Plus P1000, Microbial" *)
          InoculationTips -> Model[Item, Tips, "id:WNa4ZjRr5ljD"], (* Model[Item, Tips, "1 mL glass barrier serological pipets, sterile"] *)
          Output -> Options
        ],
        Instrument
      ],
      ObjectP[Model[Instrument, Pipette, "id:GmzlKjP3boWe"]],
      Messages :> {Error::TipConnectionMismatch, Error::InvalidOption}
    ],
    (* InoculationSource type specific error *)
    Example[{Messages, "InvalidDestinationMediaContainer", "If the DestinationMediaContainer is not a plate for SolidMedia, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        DestinationMediaContainer -> Model[Container, Vessel, "15mL Tube"]
      ],
      $Failed,
      Messages :> {Error::InvalidDestinationMediaContainer, Error::InvalidOption}
    ],
    Example[{Messages, "InvalidDestinationMediaContainer", "If InoculationSource is SolidMedia, if the DestinationMediaContainer does not have 1, 24, or 96 wells or is deep well but does not have 96 wells, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        DestinationMediaContainer -> Object[Container, Plate, "ExperimentInoculateLiquidMedia test 24-well Round Bottom Deep Well Plate " <> $SessionUUID]
      ],
      $Failed,
      Messages :> {Error::InvalidDestinationMediaContainer, Error::InvalidOption}
    ],
    Example[{Messages, "TooManyDestinationMediaContainers", "If InoculationSource is SolidMedia, if there are more than 6 unique DestinationMediaContainers, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        Populations -> {{
          Diameter[],
          Circularity[],
          Fluorescence[NumberOfColonies -> 10],
          Isolation[],
          Regularity[],
          BlueWhiteScreen[NumberOfColonies -> 12],
          BlueWhiteScreen[NumberOfColonies -> 14]
        }},
        DestinationMediaContainer -> {
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 1 " <> $SessionUUID],
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 2 " <> $SessionUUID],
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 3 " <> $SessionUUID],
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 4 " <> $SessionUUID],
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 5 " <> $SessionUUID],
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 6 " <> $SessionUUID],
          Object[Container, Plate, "ExperimentInoculateLiquidMedia test dwp 7 " <> $SessionUUID]
        }
      ],
      $Failed,
      Messages :> {Error::TooManyDestinationMediaContainers, Error::InvalidOption}
    ],
    Example[{Messages, "InvalidColonyPickingDepths", "If InoculationSource is SolidMedia, if the specified ColonyPickingDepth is greater than the depth of a well of an input container, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        ColonyPickingDepth -> 15 Millimeter
      ],
      $Failed,
      Messages :> {Error::InvalidColonyPickingDepths, Error::InvalidOption}
    ],
    Example[{Messages, "PrimaryWashMismatch", "If InoculationSource is SolidMedia, if PrimaryWash -> True and other PrimaryWash options are Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        PrimaryWash -> True,
        NumberOfPrimaryWashes -> Null
      ],
      $Failed,
      Messages :> {Error::PrimaryWashMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "SecondaryWashMismatch", "If InoculationSource is SolidMedia, if SecondaryWash -> True and other SecondaryWash options are Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        SecondaryWash -> True,
        NumberOfSecondaryWashes -> Null
      ],
      $Failed,
      Messages :> {Error::SecondaryWashMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "TertiaryWashMismatch", "If InoculationSource is SolidMedia, if TertiaryWash -> True and other TertiaryWash options are Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        TertiaryWash -> True,
        NumberOfTertiaryWashes -> Null
      ],
      $Failed,
      Messages :> {Error::TertiaryWashMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "QuaternaryWashMismatch", "If InoculationSource is SolidMedia, if QuaternaryWash -> True and other QuaternaryWash options are Null, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        QuaternaryWash -> True,
        NumberOfQuaternaryWashes -> Null
      ],
      $Failed,
      Messages :> {Error::QuaternaryWashMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "TooManyWashSolutions", "If InoculationSource is SolidMedia, if there are more than 3 different sample models across PrimaryWashSolution, SecondaryWashSolution, TertiaryWashSolution, and QuaternaryWashSolution, an error will be thrown:"},
     ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        PrimaryWashSolution -> Model[Sample, StockSolution, "70% Ethanol"],
        SecondaryWashSolution -> Model[Sample, "Milli-Q water"],
        TertiaryWashSolution -> Model[Sample, "Bleach"],
        QuaternaryWashSolution -> Model[Sample, "Methanol"]
      ],
      $Failed,
      Messages :> {Error::TooManyWashSolutions, Error::InvalidOption}
    ],
    Example[{Messages, "OutOfOrderWashStages", "If InoculationSource is SolidMedia, if a wash stage is specified but not all of the prerequisite stages are specified, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        PrimaryWash -> False,
        SecondaryWash -> True
      ],
      $Failed,
      Messages :> {Error::OutOfOrderWashStages, Error::InvalidOption}
    ],
    Example[{Messages, "QPixWashSolutionInsufficientVolume", "If there is not sufficient volume (150mL) left in a specified Object[Sample] for any wash solution options, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        PrimaryWashSolution -> Object[Sample, "ExperimentInoculateLiquidMedia test wash solution (MilliQ) " <> $SessionUUID]
      ],
      $Failed,
      Messages :> {Error::QPixWashSolutionInsufficientVolume, Error::InvalidOption}
    ],
    Example[{Messages, "PickCoordinatesMissing", "If InoculationSource is SolidMedia, if Populations ->CustomCoordinates and PickCoordinates are not specified an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        Populations -> CustomCoordinates
      ],
      $Failed,
      Messages :> {Error::PickCoordinatesMissing, Error::InvalidOption}
    ],
    Example[{Messages, "MultiplePopulationMethods", "If InoculationSource is SolidMedia, if Populations -> Population and PickCoordinates are specified an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        Populations -> Diameter[],
        PickCoordinates -> ConstantArray[{0 Millimeter, 0 Millimeter}, 10]
      ],
      $Failed,
      Messages :> {Error::MultiplePopulationMethods, Error::InvalidOption}
    ],
    Example[{Messages, "OverlappingPopulations", "If InoculationSource is SolidMedia, if Populations is specified as a mix of Populations, Unknown, or CustomCoordinates for a single sample, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        Populations -> {{CustomCoordinates, Diameter}}
      ],
      $Failed,
      Messages :> {Error::OverlappingPopulations, Error::InvalidOption}
    ],
    Example[{Messages, "IndexMatchingPrimitive", "If InoculationSource is SolidMedia, if the options within a population don't index match, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        Populations -> MultiFeatured[
          Features -> {Diameter, Fluorescence},
          NumberOfDivisions -> {5}
        ]
      ],
      $Failed,
      Messages :> {Error::IndexMatchingPrimitive, Error::InvalidOption}
    ],
    Example[{Messages, "RepeatedPopulationNames", "If InoculationSource is SolidMedia, if the same PopulationName is used in multiple Populations, an error will be thrown :"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        Populations -> {{
          Diameter[PopulationName -> "AwesomePopulation"],
          Fluorescence[PopulationName -> "AwesomePopulation"]
        }}
      ],
      $Failed,
      Messages :> {Error::RepeatedPopulationNames, Error::InvalidOption}
    ],
    Example[{Messages, "ImagingOptionMismatch", "If InoculationSource is SolidMedia, if ImagingStrategies and ExposureTimes are set to different lengths, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        ImagingStrategies -> {BrightField, GreenFluorescence, OrangeFluorescence},
        ExposureTimes -> {3 Millisecond, 5 Millisecond}
      ],
      $Failed,
      Messages :> {Error::ImagingOptionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "MissingImagingStrategies", "If InoculationSource is SolidMedia, if there are imaging strategies specified in a Population that are not specified in ImagingStrategies, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        Populations -> Fluorescence[ExcitationWavelength -> 457 Nanometer, EmissionWavelength -> 536 Nanometer],
        ImagingStrategies -> {BrightField, OrangeFluorescence}
      ],
      $Failed,
      Messages :> {Error::MissingImagingStrategies, Error::InvalidOption}
    ],
    Example[{Messages, "PickingToolIncompatibleWithDestinationMediaContainer", "If InoculationSource is SolidMedia, if the specified ColonyPickingTool is incompatible with a DestinationMediaContainer, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli"],
        DestinationMediaContainer -> Object[Container, Plate, "ExperimentInoculateLiquidMedia test 24-well Plate " <> $SessionUUID]
      ],
      $Failed,
      Messages :> {Error::PickingToolIncompatibleWithDestinationMediaContainer, Error::InvalidOption}
    ],
    Example[{Messages, "NoAvailablePickingTool", "If InoculationSource is SolidMedia, if there is no ColonyPickingTool that satisfies the colony picking tool parameter options, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        NumberOfHeads -> 384
      ],
      $Failed,
      Messages :> {Error::NoAvailablePickingTool, Error::InvalidOption}
    ],
    Example[{Messages, "NotPreferredColonyHandlerHead", "If InoculationSource is SolidMedia, if the specified ColonyPickingTool is not preferred for the cell type in the input sample, a warning will be thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
          InoculationSource -> SolidMedia,
          ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for Phage - Deep well"],
          Output -> Options
        ],
        ColonyPickingTool
      ],
      ObjectP[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for Phage - Deep well"]],
      Messages :> {Warning::NotPreferredColonyHandlerHead}
    ],
    Example[{Messages, "NumberOfHeadsMismatch", "If InoculationSource is SolidMedia, if the specified NumberOfHeads does not match the value in the NumberOfHeads field of the specified ColonyPickingTool, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        ColonyPickingTool -> Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"],
        NumberOfHeads -> 24
      ],
      $Failed,
      Messages :> {Error::NumberOfHeadsMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "IncompatibleMaterials", "If a wash solution is not compatible with the wetted materials of the instrument, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
        PrimaryWashSolution -> Model[Sample, "ExperimentInoculateLiquidMedia test incompatible sample model " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        SecondaryWash -> False,
        Output -> Options
      ],
      _List,
      Messages :> {Error::IncompatibleMaterials, Error::InvalidOption}
    ],
    Example[{Messages, "IncompatibleMaterials", "If the input sample is not compatible with the wetted materials of the instrument, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test incompatible input sample in omnitray " <> $SessionUUID],
        InoculationSource -> SolidMedia,
        Output -> Options
      ],
      _List,
      Messages :> {Error::IncompatibleMaterials, Warning::ConflictingInoculationSource, Warning::NotPreferredColonyHandlerHead, Error::InvalidOption}
    ],
    (* FreezeDried Only *)
    Example[{Messages, "NoPreferredLiquidMediaForResuspension", "If InoculationSource is FreezeDried and ResuspensionMedia is not specified, when the input sample contains a Model[Cell] in its composition that does not have a PreferredLiquidMedia, a warning is thrown:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli in ampoule - no PreferredLiquidMedia " <> $SessionUUID],
          InoculationSource -> FreezeDried,
          ResuspensionMedia -> Automatic,
          DestinationMedia -> Null,
          Output -> Options
        ],
        ResuspensionMedia
      ],
      ObjectP[Model[Sample, Media, "LB Broth, Miller"]],
      Messages :> {Warning::NoPreferredLiquidMediaForResuspension}
    ],
    Example[{Messages, "InvalidResuspensionMediaState", "If InoculationSource is FreezeDried, when the ResuspensionMedia is not Liquid, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        InoculationSource -> FreezeDried,
        ResuspensionMedia -> Model[Sample, Media, "LB (Solid Agar)"],
        DestinationMedia -> Null
      ],
      $Failed,
      Messages :> {Error::InvalidResuspensionMediaState, Error::InvalidOption}
    ],
    Example[{Messages, "InvalidResuspensionMediaState", "If InoculationSource is FreezeDried, if the DestinationMedia is automatically set from a non-liquid ResuspensionMedia, only one error will be thrown for DestinationMedia:"},
      Lookup[
        ExperimentInoculateLiquidMedia[
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          InoculationSource -> FreezeDried,
          ResuspensionMedia -> Model[Sample, Media, "LB (Solid Agar)"],
          DestinationMedia -> Automatic,
          Output -> Options
        ],
        {ResuspensionMedia, DestinationMedia}
      ],
      {ObjectP[Model[Sample, Media, "LB (Solid Agar)"]], ObjectP[Model[Sample, Media, "LB (Solid Agar)"]]},
      Messages :> {Error::InvalidResuspensionMediaState, Error::InvalidOption}
    ],
    Example[{Messages, "ResuspensionMediaOverfill", "If InoculationSource is FreezeDried, when the ResuspensionMediaVolume is more than MaxVolume of source container, an error will be thrown:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        InoculationSource -> FreezeDried,
        ResuspensionMediaVolume -> 5 Milliliter
      ],
      $Failed,
      Messages :> {Error::ResuspensionMediaOverfill, Error::InvalidOption}
    ],
    Example[{Messages, "FreezeDriedUnusedSample", "If InoculationSource is FreezeDried, when the ResuspensionMediaVolume is more than the total Volume to be transferred to DestinationMediaContainer, an error is thrown:"},
      ExperimentInoculateLiquidMedia[Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        ResuspensionMediaVolume -> 1 Milliliter,
        Volume -> 0.5 Milliliter
      ],
      $Failed,
      Messages :> {Error::FreezeDriedUnusedSample, Error::InvalidOption}
    ],
    Example[{Messages, "InsufficientResuspensionMediaVolume", "If InoculationSource is FreezeDried, when the ResuspensionMediaVolume is more than the total Volume to be transferred to DestinationMediaContainer, an error is thrown:"},
      ExperimentInoculateLiquidMedia[
        {
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 2 in ampoule " <> $SessionUUID]
        },
        ResuspensionMediaVolume -> 1 Milliliter,
        Volume -> 0.5 Milliliter,
        DestinationMediaContainer -> {
          {
            Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
            Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"]
          },
          {
            Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
            Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"],
            Model[Container, Vessel, "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"]
          }
        }
      ],
      $Failed,
      Messages :> {Error::InsufficientResuspensionMediaVolume, Error::InvalidOption}
    ],
    Example[{Messages, "NoResuspensionMix", "A warning message is thrown if it is specified not to mix during resuspension when the source type is FreezeDried:"},
      Lookup[
        ExperimentInoculateLiquidMedia[Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
          ResuspensionMix -> False,
          Output -> Options
        ],
        {NumberOfResuspensionMixes, ResuspensionMixVolume}
      ],
      {Null, Null},
      Messages :> {Warning::NoResuspensionMix}
    ],
    Example[{Messages, "ResuspensionMixMismatch", "A message is thrown if there is mismatch in resuspension mix options:"},
      ExperimentInoculateLiquidMedia[
        Object[Sample, "ExperimentInoculateLiquidMedia test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
        ResuspensionMix -> True,
        ResuspensionMixVolume -> Null
      ],
      $Failed,
      Messages :> {Error::ResuspensionMixMismatch, Error::InvalidOption}
    ],
    (* ODNE tests *)
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentInoculateLiquidMedia[Object[Sample, "Nonexistent sample"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentInoculateLiquidMedia[Object[Container, Vessel, "Nonexistent container"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentInoculateLiquidMedia[Object[Sample, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentInoculateLiquidMedia[Object[Container, Vessel, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container, Plate, "id:O81aEBZjRXvx"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          Model[Sample, "ExperimentInoculateLiquidMedia test e.coli and LB agar sample Model " <> $SessionUUID],
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 1 Gram
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentInoculateLiquidMedia[sampleID, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container, Plate, "id:O81aEBZjRXvx"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          Model[Sample, "ExperimentInoculateLiquidMedia test e.coli and LB agar sample Model " <> $SessionUUID],
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 1 Gram
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentInoculateLiquidMedia[containerID, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Test["The generated RCP, requires the Magnetic Hazard Safety certification:",
      Module[{protocol,requiredCerts},
        protocol = ExperimentInoculateLiquidMedia[
          {
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID],
            Object[Sample, "ExperimentInoculateLiquidMedia test e.coli sample 2 in omniTray " <> $SessionUUID]
          }
        ];
        requiredCerts = Download[protocol,RequiredCertifications];
        MemberQ[requiredCerts,ObjectP[Model[Certification, "id:XnlV5jNAkGmM"]]]
      ],
      True
    ]
  },
  SymbolSetUp :> (
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
    Example[{Basic, "Display the option values which will be used in the experiment:"},
      ExperimentInoculateLiquidMediaOptions[Object[Sample, "ExperimentInoculateLiquidMediaOptions test e.coli sample 1 in omniTray " <> $SessionUUID]],
      _Grid
    ],
    Example[{Basic, "Basic pick colonies with InoculationSource -> AgarStab:"},
      ExperimentInoculateLiquidMediaOptions[Object[Sample, "ExperimentInoculateLiquidMediaOptions test e.coli stab 1 in cryoVial " <> $SessionUUID]],
      _Grid
    ],
    Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
      ExperimentInoculateLiquidMediaOptions[
        Object[Sample, "ExperimentInoculateLiquidMediaOptions test e.coli stab 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> SolidMedia
      ],
      _Grid,
      Messages :> {Error::ConflictingInoculationSource, Error::InvalidInput}
    ],

    Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options:"},
      ExperimentInoculateLiquidMediaOptions[
        Object[Sample, "ExperimentInoculateLiquidMediaOptions test e.coli sample 1 in omniTray " <> $SessionUUID],
        OutputFormat -> List
      ],
      {(_Rule|_RuleDelayed)..}
    ]
  },
  SymbolSetUp :> (
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
    Example[{Basic, "Verify that the experiment can be run without issues:"},
      ValidExperimentInoculateLiquidMediaQ[Object[Sample, "ValidExperimentInoculateLiquidMediaQ test e.coli sample 1 in omniTray " <> $SessionUUID]],
      True
    ],
    Example[{Basic, "Return False if there are problems with the inputs or options:"},
      ValidExperimentInoculateLiquidMediaQ[Object[Sample, "ValidExperimentInoculateLiquidMediaQ test e.coli stab 1 in cryoVial " <> $SessionUUID],
        InoculationSource -> SolidMedia
      ],
      False
    ],
    Example[{Options, OutputFormat, "Return a test summary:"},
      ValidExperimentInoculateLiquidMediaQ[Object[Sample, "ValidExperimentInoculateLiquidMediaQ test e.coli sample 1 in omniTray " <> $SessionUUID], OutputFormat -> TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options, Verbose, "Print verbose messages reporting test passage/failure:"},
      ValidExperimentInoculateLiquidMediaQ[Object[Sample, "ValidExperimentInoculateLiquidMediaQ test e.coli sample 1 in omniTray " <> $SessionUUID], Verbose -> True],
      True
    ]
  },
  SymbolSetUp :> (
    inoculateLiquidMediaSymbolSetUp["ValidExperimentInoculateLiquidMediaQ"]
  ),
  SymbolTearDown :> (
    inoculateLiquidMediaObjectErasure["ValidExperimentInoculateLiquidMediaQ", True]
  )
];

(* ::Subsection:: *)
(* ExperimentInoculateLiquidMediaPreview *)

DefineTests[
  ExperimentInoculateLiquidMediaPreview,
  {
    (* --- Basic Examples --- *)
    Example[{Basic, "Generate a preview for an ExperimentInoculateLiquidMedia call of a single sample (will always be Null:"},
      ExperimentInoculateLiquidMediaPreview[Object[Sample, "ExperimentInoculateLiquidMediaPreview test e.coli sample 1 in omniTray " <> $SessionUUID]],
      Null
    ],
    Example[{Basic, "Generate a preview for an ExperimentInoculateLiquidMedia call of two samples at the same time:"},
      ExperimentInoculateLiquidMediaPreview[{
        Object[Sample, "ExperimentInoculateLiquidMediaPreview test e.coli sample 1 in omniTray " <> $SessionUUID],
        Object[Sample, "ExperimentInoculateLiquidMediaPreview test e.coli sample 2 in omniTray " <> $SessionUUID]
      }],
      Null
    ],
    Example[{Basic, "Generate a preview for an ExperimentInoculateLiquidMedia call of a single container:"},
      ExperimentInoculateLiquidMediaPreview[Object[Container, Plate, "ExperimentInoculateLiquidMediaPreview" <> " test omniTray 1 " <> $SessionUUID]],
      Null
    ]
  },
  SymbolSetUp :> (
    inoculateLiquidMediaSymbolSetUp["ExperimentInoculateLiquidMediaPreview"]
  ),
  SymbolTearDown :> (
    inoculateLiquidMediaObjectErasure["ExperimentInoculateLiquidMediaPreview", True]
  )
];

(* ::Subsection:: *)
(* InoculateLiquidMedia *)

DefineTests[InoculateLiquidMedia,
  {
    Example[{Basic, "Form an inoculate liquid media unit operation:"},
      InoculateLiquidMedia[
        InoculationSource -> SolidMedia,
        DestinationMix -> True,
        DestinationNumberOfMixes -> 5
      ],
      InoculateLiquidMediaP
    ],
    Example[{Basic, "Specifying a key incorrectly will not form a unit operation:"},
      primitive = InoculateLiquidMedia[
        InoculationSource -> SolidMedia,
        DestinationMix -> True,
        DestinationNumberOfMixes -> "cat"
      ];
      MatchQ[primitive, InoculateLiquidMediaP],
      False
    ],
    Example[{Basic, "A RoboticCellPreparation protocol is generated when InoculationSource is SolidMedia:"},
      ExperimentRoboticCellPreparation[
        {
          InoculateLiquidMedia[
            Sample -> Object[Sample, "InoculateLiquidMedia test e.coli sample 1 in omniTray " <> $SessionUUID]
          ]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]]
    ],
    Example[{Basic, "A RoboticCellPreparation protocol is generated when InoculationSource is LiquidMedia:"},
      ExperimentRoboticCellPreparation[
        {
          InoculateLiquidMedia[
            Sample -> Object[Sample, "InoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID]
          ]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]]
    ],
    Example[{Basic, "A ManualCellPreparation protocol is generated when InoculationSource is LiquidMedia:"},
      ExperimentManualCellPreparation[
        {
          InoculateLiquidMedia[
            Sample -> Object[Sample, "InoculateLiquidMedia test liquid e.coli culture 1 in dwp " <> $SessionUUID]
          ]
        }
      ],
      ObjectP[Object[Protocol, ManualCellPreparation]]
    ],
    Example[{Basic, "A ManualCellPreparation protocol is generated when InoculationSource is AgarStab:"},
      ExperimentManualCellPreparation[
        {
          InoculateLiquidMedia[
            Sample -> Object[Sample, "InoculateLiquidMedia test e.coli stab 1 in cryoVial " <> $SessionUUID]
          ]
        }
      ],
      ObjectP[Object[Protocol, ManualCellPreparation]]
    ],
    Example[{Basic, "A ManualCellPreparation protocol is generated for multiple samples when DestinationMediaContainer is a labeled container:"},
      ExperimentManualCellPreparation[
        {
          LabelContainer[
            Label -> "inoculated plate",
            Container -> Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]
          ],
          InoculateLiquidMedia[
            Sample -> {
              Object[Sample, "InoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
              Object[Sample, "InoculateLiquidMedia test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID]
            },
            MediaVolume -> 5 Milliliter,
            DestinationMediaContainer -> "inoculated plate",
            InoculationSource -> FrozenGlycerol
          ]
        }
      ],
      ObjectP[Object[Protocol, ManualCellPreparation]]
    ],
    Example[{Basic, "A ManualCellPreparation protocol is generated when InoculationSource is AgarStab and the Sample is a model:"},
      ExperimentManualCellPreparation[
        {
          InoculateLiquidMedia[
            Sample -> Model[Sample, "InoculateLiquidMedia test e.coli and LB agar sample Model " <> $SessionUUID]
          ]
        }
      ],
      ObjectP[Object[Protocol, ManualCellPreparation]],
      (*Need to populate the products of the model for it to work*)
      SetUp :> {
        UploadProduct[
          Name -> "InoculateLiquidMedia test e.coli and LB agar sample Model Product " <> $SessionUUID,
          Packaging -> Single,
          SampleType -> Vial,
          ProductModel -> Model[Sample, "InoculateLiquidMedia test e.coli and LB agar sample Model " <> $SessionUUID],
          NumberOfItems -> 1,
          Amount -> 1 Gram,
          DefaultContainerModel -> Model[Container, Vessel, "id:vXl9j5qEnnOB"], (* Model[Container, Vessel, "2mL Cryogenic Vial"] *)
          CatalogNumber -> "88888",
          Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
          Price -> 100 USD,
          CatalogDescription -> "Test Ecoli AgarStab product"
        ],
        UploadNotebook[Object[Product, "InoculateLiquidMedia test e.coli and LB agar sample Model Product " <> $SessionUUID], Null]
      },
      TearDown :> (EraseObject[
        {Object[Product, "InoculateLiquidMedia test e.coli and LB agar sample Model Product " <> $SessionUUID]},
        Force -> True,
        Verbose -> False
      ])
    ],
    Example[{Basic, "A ManualCellPreparation protocol is generated when InoculationSource is FreezeDried and the Sample is a model:"},
      ExperimentManualCellPreparation[
        {
          InoculateLiquidMedia[
            Sample -> Model[Sample, "InoculateLiquidMedia test freeze dried e.coli sample Model " <> $SessionUUID]
          ]
        }
      ],
      ObjectP[Object[Protocol, ManualCellPreparation]],
      (*Need to populate the products of the model for it to work*)
      SetUp :> {
        UploadProduct[
          Name -> "InoculateLiquidMedia test freeze dried e.coli sample Model Product " <> $SessionUUID,
          Packaging -> Single,
          SampleType -> Vial,
          ProductModel -> Model[Sample, "InoculateLiquidMedia test freeze dried e.coli sample Model " <> $SessionUUID],
          NumberOfItems -> 1,
          Amount -> 1 Gram,
          DefaultContainerModel -> Model[Container, Vessel, "5mL small glass vial aluminum cap"],
          CatalogNumber -> "88888",
          Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
          Price -> 100 USD,
          CatalogDescription -> "Test Ecoli FreezeDriedproduct"
        ],
        UploadNotebook[Object[Product, "InoculateLiquidMedia test freeze dried e.coli sample Model Product " <> $SessionUUID], Null]
      },
      TearDown :> (EraseObject[
        {Object[Product, "InoculateLiquidMedia test freeze dried e.coli sample Model Product " <> $SessionUUID]},
        Force -> True,
        Verbose -> False
      ])
    ],
    Example[{Basic, "A ManualCellPreparation protocol is generated when InoculationSource is FrozenGlycerol and the Sample is a model:"},
       ExperimentManualCellPreparation[
        {
          InoculateLiquidMedia[
            Sample -> Model[Sample, "InoculateLiquidMedia test e.coli in 50% frozen glycerol sample Model " <> $SessionUUID]
          ]
        }
      ],
      ObjectP[Object[Protocol, ManualCellPreparation]],
      (*Need to populate the products of the model for it to work*)
      SetUp :> {
        UploadProduct[
          Name -> "InoculateLiquidMedia test e.coli in 50% frozen glycerol sample Model Product " <> $SessionUUID,
          Packaging -> Single,
          SampleType -> Vial,
          ProductModel -> Model[Sample, "InoculateLiquidMedia test e.coli in 50% frozen glycerol sample Model " <> $SessionUUID],
          NumberOfItems -> 1,
          Amount -> 1 Gram,
          DefaultContainerModel -> Model[Container, Vessel, "id:vXl9j5qEnnOB"], (* Model[Container, Vessel, "2mL Cryogenic Vial"] *)
          CatalogNumber -> "88888",
          Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
          Price -> 100 USD,
          CatalogDescription -> "Test Ecoli AgarStab product"
        ],
        UploadNotebook[Object[Product, "InoculateLiquidMedia test e.coli in 50% frozen glycerol sample Model Product " <> $SessionUUID], Null]
      },
      TearDown :> (EraseObject[
        {Object[Product, "InoculateLiquidMedia test e.coli in 50% frozen glycerol sample Model Product " <> $SessionUUID]},
        Force -> True,
        Verbose -> False
      ])
    ]
  },
  SymbolSetUp :> (
    inoculateLiquidMediaSymbolSetUp["InoculateLiquidMedia"]
  ),
  SymbolTearDown :> (
    inoculateLiquidMediaObjectErasure["InoculateLiquidMedia", True]
  )
];
(* ::Subsection:: *)
(* Setup and Teardown *)
inoculateLiquidMediaObjectErasure[functionName_String, tearDownBool: BooleanP] := Module[
  {namedObjects, allObjects, existingObjs},

  namedObjects = Quiet[Cases[
    Flatten[{
      (* Colony Handler *)
      Model[Instrument, ColonyHandler, "Test Colony Handler Instrument Model Shell for " <> functionName <> " " <> $SessionUUID],

      (* Containers *)
      Object[Container, Plate, functionName <> " test dwp 1 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test dwp 2 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test dwp 3 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test dwp 4 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test dwp 5 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test dwp 6 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test dwp 7 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test dwp 8 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test omniTray 1 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test omniTray 2 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test omniTray 3 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test omniTray 4 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test omniTray 5 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test omniTray 6 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test omniTray 7 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test omniTray 8 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test omniTray 9 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test omniTray 10 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test omniTray 11 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test omniTray 12 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test 500mL flask 1 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test 500mL flask 2 " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test 24-well Plate " <> $SessionUUID],
      Object[Container, Plate, functionName <> " test 24-well Round Bottom Deep Well Plate " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test cryoVial 1 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test cryoVial 2 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test cryoVial 3 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test cryoVial 4 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test cryoVial 5 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test cryoVial 6 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test cryoVial 7 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test cryoVial 8 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test cryoVial 9 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test cryoVial 10 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test cryoVial 11 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test destination 5mL tube 1 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test destination 5mL tube 2 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test destination 5mL tube 3 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test destination 5mL tube 4 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test 4L amber glass bottle 1 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test 4L amber glass bottle 2 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test 2mL amber glass ampoule 1 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test 2mL amber glass ampoule 2 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test 2mL amber glass ampoule 3 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test 2mL amber glass ampoule 4 " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test unaspiratable 2mL tube " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test undispensable 2mL tube " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test 50 mL tube " <> $SessionUUID],

      (* Media *)
      Model[Sample, Media, functionName <> " test solid LB agar media model " <> $SessionUUID],
      Model[Sample, Media, functionName <> " test liquid LB Broth media model " <> $SessionUUID],

      (* Bacteria *)
      Model[Cell, Bacteria, functionName <> " test e.coli model - gfp Positive " <> $SessionUUID],
      Model[Cell, Bacteria, functionName <> " test e.coli no fluorescent wavelengths model - gfp Positive " <> $SessionUUID],
      Model[Cell, Bacteria, functionName <> " test e.coli half match fluorescent wavelengths model - gfp Positive " <> $SessionUUID],
      Model[Cell, Bacteria, functionName <> " test e.coli model - gfp Positive - no PreferredLiquidMedia " <> $SessionUUID],

      (* Model[Sample]s *)
      Model[Sample, functionName <> " test e.coli and LB agar sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test freeze dried e.coli sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test e.coli in 50% frozen glycerol sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test e.coli no fluorescent wavelengths and LB agar sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test e.coli half match fluorescent wavelengths and LB agar sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test liquid e.coli culture model " <> $SessionUUID],
      Model[Sample, functionName <> " test deprecated frozen glycerol e.coli culture model " <> $SessionUUID],
      Model[Sample, functionName <> " test e.coli no preferred liquid media and LB agar sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test incompatible sample model " <> $SessionUUID],
      Model[Sample, functionName <> " test Mammalian and agar sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test liquid Mammalian sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test freezeDried Mammalian sample Model " <> $SessionUUID],
      Model[Sample, functionName <> " test Mammalian in 50% frozen glycerol sample Model " <> $SessionUUID],

      (* Samples *)
      Object[Sample, functionName <> " test e.coli sample 1 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli sample 2 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli sample 3 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli sample 4 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli sample 5 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli sample 6 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test solid e.coli sample 1 in dwp " <> $SessionUUID],
      Object[Sample, functionName <> " test liquid e.coli culture 1 in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test liquid e.coli culture 1 in dwp " <> $SessionUUID],
      Object[Sample, functionName <> " test liquid e.coli culture 2 in dwp " <> $SessionUUID],
      Object[Sample, functionName <> " test liquid e.coli culture 3 in dwp " <> $SessionUUID],
      Object[Sample, functionName <> " test liquid e.coli culture 4 in dwp " <> $SessionUUID],
      Object[Sample, functionName <> " test liquid e.coli culture 1 in 500 mL flask " <> $SessionUUID],
      Object[Sample, functionName <> " test LB Broth in 500 mL flask " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli no fluorescent wavelengths sample 1 in omniTray" <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli half match fluorescent wavelengths sample 1 in omniTray" <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli stab 1 in cryoVial " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli stab 2 in cryoVial " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli stab 3 in cryoVial " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli stab 4 in cryoVial " <> $SessionUUID],
      Object[Sample, functionName <> " test freeze dried e.coli 1 in ampoule " <> $SessionUUID],
      Object[Sample, functionName <> " test freeze dried e.coli 2 in ampoule " <> $SessionUUID],
      Object[Sample, functionName <> " test freeze dried e.coli in ampoule - no PreferredLiquidMedia " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli in frozen glycerol 1 in cryoVial " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli in frozen glycerol 2 in cryoVial " <> $SessionUUID],
      Object[Sample, functionName <> " test LB Broth in 4L amber glass flask " <> $SessionUUID],
      Object[Sample, functionName <> " test unaspiratable LB Broth sample in 2mL Tube " <> $SessionUUID],
      Object[Sample, functionName <> " test e.coli stab 5 in cryoVial - no PreferredLiquidMedia " <> $SessionUUID],
      Object[Sample, functionName <> " test incompatible input sample in omnitray " <> $SessionUUID],
      Object[Sample, functionName <> " test discarded input sample in cryoVial " <> $SessionUUID],
      Object[Sample, functionName <> " test deprecated input sample in cryoVial " <> $SessionUUID],
      Object[Sample, functionName <> " test Mammalian sample in omniTray " <> $SessionUUID],
      Object[Sample, functionName <> " test liquid Mammalian sample in dwp " <> $SessionUUID],
      Object[Sample, functionName <> " test FreezeDried Mammalian sample in ampoule " <> $SessionUUID],
      Object[Sample, functionName <> " test liquid Mammalian sample in cryoVial " <> $SessionUUID],
      Object[Sample, functionName <> " test Mammalian sample in frozen glycerol in cryoVial " <> $SessionUUID],
      Object[Sample, functionName <> " test wash solution (MilliQ) " <> $SessionUUID],
      Object[Sample, functionName <> " test Insect pellet sample in dwp " <> $SessionUUID],
      (* Waste bins *)
      Object[Container, WasteBin, functionName <> " test biosafety waste bin 1 " <> $SessionUUID],
      Object[Container, WasteBin, functionName <> " test biosafety waste bin 2 " <> $SessionUUID],
      Object[Container, WasteBin, functionName <> " test biosafety waste bin 3 " <> $SessionUUID],

      (* Instruments *)
      Object[Instrument, BiosafetyCabinet, functionName <> " test bsc 1 " <> $SessionUUID],
      Object[Instrument, BiosafetyCabinet, functionName <> " test bsc 2 " <> $SessionUUID],
      Object[Instrument, BiosafetyCabinet, functionName <> " test tc bsc 1 " <> $SessionUUID]
    }],
    ObjectP[]
  ]];

  allObjects = If[tearDownBool,
    Quiet[Cases[Flatten[{$CreatedObjects, namedObjects}], ObjectP[]]],
    namedObjects
  ];

  existingObjs = PickList[allObjects, DatabaseMemberQ[allObjects]];
  EraseObject[existingObjs, Force -> True, Verbose -> False];

  If[tearDownBool,
    Unset[$CreatedObjects];

    (* Turn on the relevant messages *)
    On[Warning::SamplesOutOfStock]
  ];
];

inoculateLiquidMediaSymbolSetUp[functionName_String] := Block[{$DeveloperUpload = True},
  (* Turn off some irrelevant messages *)
  Off[Warning::SamplesOutOfStock];

  (* Erase any named objects so we don't try to create duplicates *)
  inoculateLiquidMediaObjectErasure[functionName, False];

  (* Initialize Created Objects variable *)
  $CreatedObjects = {};

  (* Set up our test objects *)
  Module[
    {
      (* Colony Handler *)
      testColonyHandlerShell,
      (* Containers *)
      dwp1, dwp2, dwp3, dwp4, dwp5, dwp6, dwp7, dwp8, omniTray1, omniTray2, omniTray3, omniTray4, omniTray5, omniTray6, 
      omniTray7, omniTray8, omniTray9, omniTray10, omniTray11, omniTray12, flask500mL1, flask500mL2, plate24Well, plate24DeepWell,
      cryoVial1, cryoVial2, cryoVial3, cryoVial4, cryoVial5, cryoVial6, cryoVial7, cryoVial8, cryoVial9, cryoVial10, cryoVial11,
      destTube1, destTube2, destTube3 ,destTube4, washSolutionTube, unaspiratable2mLTube, undispensable2mLTube,
      amberGlassBottle4L1, amberGlassBottle4L2, ampoule1, ampoule2, ampoule3, ampoule4,
      (* Media *)
      testSolidLBMedia, testLBBroth,
      (* Model Cells *)
      testEColi, testEColiNoFluorescentWavelengths, testEColiHalfMatchFluorescentWavelengths, testEColiNoPreferredLiquidMedia,
      (* Model[Sample]s *)
      testEColiSampleModel, testEColiFreezeDriedModel, testEColiFrozenGlycerolModel, testEColiNoFluorescentWavelengthsSampleModel,
      testEColiHalfMatchFluorescentWavelengthsSampleModel, testEColiSampleModelNoPreferredLiquidMedia,
      testEColiLiquidCultureSampleModel, testIncompatibleSampleModel, testDeprecatedSampleModel, testDiscardedInputSample,
      testMammalianSampleModel, testMammalianLiquidCultureSampleModel, testMammalianFreezeDriedSampleModel,
      testMammalianFrozenGlycerolSampleModel, allSampleModels,
      (* Samples *)
      eColiSample1, eColiSample2, eColiSample3, eColiSample4, eColiSample5, eColiSample6, solidEColiSampleInDWP, liquidCultureSample,
      liquidCultureSampleInFlask, testLBBrothSample, eColiSampleNoFluorescentWavelengths, eColiSampleHalfMatchFluorescentWavelengths,
      eColiLiquidCulture1, eColiLiquidCulture2, eColiLiquidCulture3, eColiLiquidCulture4, agarStab1, agarStab2, agarStab3,
      agarStab4, liquidCultureSample3L, unaspiratableSample, noPreferredLiquidMediaSample, freezeDried1, freezeDried2,
      noPreferredFreezeDriedSample, frozenGlycerol1, frozenGlycerol2, testIncompatibleInputSample, testDeprecatedInputSample,
      mammalianSolidMediaSample, mammalianLiquidCultureSample, mammalianFreezeDriedSample, mammalianLiquidSampleInCryovial,
      mammalianFrozenGlycerolSample, testWashSolution, insectPelletSample
    },

    (* Create a test colony handler *)
    testColonyHandlerShell = Upload[<|
      Type -> Model[Instrument, ColonyHandler],
      Name -> "Test Colony Handler Instrument Model Shell for " <> functionName <> " " <> $SessionUUID
    |>];

    (* Set up test containers for our samples *)
    {
      dwp1,
      dwp2,
      dwp3,
      dwp4,
      dwp5,
      dwp6,
      dwp7,
      dwp8,
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
      omniTray12,
      flask500mL1,
      flask500mL2,
      plate24Well,
      plate24DeepWell,
      cryoVial1,
      cryoVial2,
      cryoVial3,
      cryoVial4,
      cryoVial5,
      cryoVial6,
      cryoVial7,
      cryoVial8,
      cryoVial9,
      cryoVial10,
      cryoVial11,
      destTube1,
      destTube2,
      destTube3,
      destTube4,
      washSolutionTube,
      unaspiratable2mLTube,
      undispensable2mLTube,
      amberGlassBottle4L1,
      amberGlassBottle4L2,
      ampoule1,
      ampoule2,
      ampoule3,
      ampoule4
    } = Upload[{
      Sequence@@Table[
        <|
          Type -> Object[Container, Plate],
          Model -> Link[Model[Container, Plate, "id:n0k9mGkwbvG4"], Objects],
          Name -> functionName <> " test dwp " <> ToString[i] <> " " <> $SessionUUID
        |>,
        {i,1,8}
      ],
      Sequence@@Table[
        <|
          Type -> Object[Container, Plate],
          Model -> Link[Model[Container, Plate, "id:O81aEBZjRXvx"], Objects],
          Name -> functionName <> " test omniTray " <> ToString[i] <> " " <> $SessionUUID
        |>,
        {i,1,12}
      ],
      Sequence@@Table[
        <|
          Type -> Object[Container, Vessel],
          Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGG0b"], Objects], (* Model[Container, Vessel, "500mL Erlenmeyer Flask"] *)
          Name -> functionName <> " test 500mL flask " <> ToString[i] <> " " <> $SessionUUID
        |>,
        {i,1,2}
      ],
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "id:1ZA60vLlZzrM"], Objects], (* Model[Container, Plate, "Nunc Non-Treated 24-well Plate"] *)
        Name -> functionName <> " test 24-well Plate " <> $SessionUUID
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "id:jLq9jXY4kkMq"], Objects], (* Model[Container, Plate, "24-well Round Bottom Deep Well Plate"] *)
        Name -> functionName <> " test 24-well Round Bottom Deep Well Plate " <> $SessionUUID
      |>,
      Sequence@@Table[
        <|
          Type -> Object[Container, Vessel],
          Model -> Link[Model[Container, Vessel, "id:vXl9j5qEnnOB"], Objects], (* Model[Container, Vessel, "2mL Cryogenic Vial"] *)
          Name -> functionName <> " test cryoVial "<> ToString[i] <>" " <> $SessionUUID
        |>,
        {i,1,11}
      ],
      Sequence@@Table[
        <|
          Type -> Object[Container, Vessel],
          Model -> Link[Model[Container, Vessel, "id:BYDOjv1VAAxz"], Objects], (* Model[Container, Vessel, "5mL Tube"] *)
          Name -> functionName <> " test destination 5mL tube " <> ToString[i] <> " " <> $SessionUUID,
          Sterile -> True,
          AsepticHandling -> True
        |>,
        {i,1,4}
      ],
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects], (* Model[Container, Vessel, "50mL Tube"] *)
        Name -> functionName <> " test 50 mL tube " <> $SessionUUID
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "id:xRO9n3BzE6nY"], Objects], (* Model[Container, Vessel, "2mL skirted self standing clear plastic tube "] *)
        Name -> functionName <> " test unaspiratable 2mL tube " <> $SessionUUID
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "id:xRO9n3BzE6nY"], Objects], (* Model[Container, Vessel, "2mL skirted self standing clear plastic tube "] *)
        Name -> functionName <> " test undispensable 2mL tube " <> $SessionUUID
      |>,
      Sequence@@Table[
        <|
          Type -> Object[Container, Vessel],
          Model -> Link[Model[Container, Vessel, "id:Vrbp1jG800Zm"], Objects], (* Model[Container, Vessel, "Amber Glass Bottle 4 L"] *)
          Name -> functionName <> " test 4L amber glass bottle " <> ToString[i] <> " " <> $SessionUUID
        |>,
        {i,1,2}
      ],
      Sequence@@Table[
        <|
          Type -> Object[Container, Vessel],
          Model -> Link[Model[Container, Vessel, "id:n0k9mGkp4OK6"], Objects], (* Model[Container, Vessel, "2mL amber glass ampoule"] *)
          Name -> functionName <> " test 2mL amber glass ampoule " <> ToString[i] <> " " <> $SessionUUID
        |>,
        {i,1,4}
      ]
    }];

    (* Create tests Medias *)
    testSolidLBMedia = UploadStockSolution[
      {
        {20 Gram, Model[Sample, "LB Broth powder,Lennox"]},
        {965 Milliliter, Model[Sample, "Milli-Q water"]},
        {15 Gram, Model[Sample, "Agarose I"]}
      },
      Type -> Media,
      Autoclave -> False,
      DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
      Preparable -> False,
      Name -> functionName <> " test solid LB agar media model " <> $SessionUUID,
      ShelfLife -> 6 Month
    ];

    testLBBroth = UploadStockSolution[
      {
        {20 Gram, Model[Sample, "LB Broth powder,Lennox"]},
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
    } = UploadBacterialCell[
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

    (* Create a solid media with eColi test sample model *)
    {
      testEColiSampleModel,
      testEColiFreezeDriedModel,
      testEColiFrozenGlycerolModel,
      testEColiNoFluorescentWavelengthsSampleModel,
      testEColiHalfMatchFluorescentWavelengthsSampleModel,
      testEColiSampleModelNoPreferredLiquidMedia,
      testEColiLiquidCultureSampleModel,
      testIncompatibleSampleModel,
      testDeprecatedSampleModel,
      (*Mammalian sample models*)
      testMammalianSampleModel,
      testMammalianLiquidCultureSampleModel,
      testMammalianFreezeDriedSampleModel,
      testMammalianFrozenGlycerolSampleModel
    } = UploadSampleModel[
      {
        functionName <> " test e.coli and LB agar sample Model " <> $SessionUUID,
        functionName <> " test freeze dried e.coli sample Model " <> $SessionUUID,
        functionName <> " test e.coli in 50% frozen glycerol sample Model " <> $SessionUUID,
        functionName <> " test e.coli no fluorescent wavelengths and LB agar sample Model " <> $SessionUUID,
        functionName <> " test e.coli half match fluorescent wavelengths and LB agar sample Model " <> $SessionUUID,
        functionName <> " test e.coli no preferred liquid media and LB agar sample Model " <> $SessionUUID,
        functionName <> " test liquid e.coli culture model " <> $SessionUUID,
        functionName <> " test incompatible sample model " <> $SessionUUID,
        functionName <> " test deprecated frozen glycerol e.coli culture model " <> $SessionUUID,
        functionName <> " test Mammalian and agar sample Model " <> $SessionUUID,
        functionName <> " test liquid Mammalian sample Model " <> $SessionUUID,
        functionName <> " test freezeDried Mammalian sample Model " <> $SessionUUID,
        functionName <> " test Mammalian in 50% frozen glycerol sample Model " <> $SessionUUID
      },
      Composition -> {
        {
          {(1 Milligram)/(1000 Milliliter), testEColi},
          {100 VolumePercent, Model[Molecule, "Water"]},
          {(3 Gram)/(193 Milliliter), Model[Molecule, "Agarose"]}
        },
        {
          {100 MassPercent, testEColi}
        },
        {
          {50 VolumePercent, Model[Molecule, "Nutrient Broth"]},
          {50 VolumePercent, Model[Molecule, "Glycerol"]},
          {(1000 EmeraldCell)/Milliliter, testEColi}
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
          {90 MassPercent, Model[Molecule, "Nutrient Broth"]},
          {10 MassPercent, testEColi}
        },
        {
          {100 VolumePercent, Model[Molecule, "Water"]}
        },
        {
          {10 MassPercent, testEColi},
          {40 MassPercent, Model[Molecule, "Water"]},
          {50 MassPercent, Model[Molecule, "Glycerol"]}
        },
        {
          {(1 Milligram)/(1000 Milliliter), Model[Cell, Mammalian, "id:eGakldJvLvzq"](*"HEK293"*)},
          {100 VolumePercent, Model[Molecule, "Water"]},
          {(3 Gram)/(193 Milliliter), Model[Molecule, "Agarose"]}
        },
        {
          {90 MassPercent, Model[Molecule, "Nutrient Broth"]},
          {10 MassPercent, Model[Cell, Mammalian, "id:eGakldJvLvzq"](*"HEK293"*)}
        },
        {
          {100 MassPercent, Model[Cell, Mammalian, "id:eGakldJvLvzq"](*"HEK293"*)}
        },
        {
          {50 VolumePercent, Model[Molecule, "Nutrient Broth"]},
          {50 VolumePercent, Model[Molecule, "Glycerol"]},
          {(1000 EmeraldCell)/Milliliter, Model[Cell, Mammalian, "id:eGakldJvLvzq"](*"HEK293"*)}
        }
      },
      Expires -> False,
      TransportTemperature -> {Null,Null,-20 Celsius,Null,Null,Null,Null,Null,Null,Null,Null,Null,-20 Celsius},
      DefaultStorageCondition -> {
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Deep Freezer"]],
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Ambient Storage"]],
        Link[Model[StorageCondition, "Deep Freezer"]],
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Refrigerator"]],
        Link[Model[StorageCondition, "Deep Freezer"]]
      },
      State -> {Solid,Solid,Solid,Solid,Solid,Solid,Liquid,Solid,Solid,Solid,Liquid,Solid,Solid},
      BiosafetyLevel -> "BSL-1",
      Flammable -> {False,False,True,False,False,False,False,False,False,False,False,False,True},
      MSDSRequired -> False,
      IncompatibleMaterials -> {
        {None},
        {None},
        {None},
        {None},
        {None},
        {None},
        {None},
        {Nylon},
        {None},
        {None},
        {None},
        {None},
        {None}
      },
      Living -> {True,True,True,True,True,True,True,False,True,True,True,True,True}
    ];
    Upload[<|Object -> testDeprecatedSampleModel, Deprecated -> True|>];
    allSampleModels = {
      testSolidLBMedia,
      testLBBroth,
      testEColiSampleModel,
      testEColiFreezeDriedModel,
      testEColiFrozenGlycerolModel,
      testEColiNoFluorescentWavelengthsSampleModel,
      testEColiHalfMatchFluorescentWavelengthsSampleModel,
      testEColiSampleModelNoPreferredLiquidMedia,
      testEColiLiquidCultureSampleModel,
      testIncompatibleSampleModel,
      testDeprecatedSampleModel,
      (*Mammalian sample models*)
      testMammalianSampleModel,
      testMammalianLiquidCultureSampleModel,
      testMammalianFreezeDriedSampleModel,
      testMammalianFrozenGlycerolSampleModel
    };
    (* Make all Model[Sample] public *)
    UploadNotebook[allSampleModels, Null];

    (* set up test samples *)
    {
      (*1*)eColiSample1,
      (*2*)eColiSample2,
      (*3*)eColiSample3,
      (*4*)eColiSample4,
      (*5*)eColiSample5,
      (*6*)eColiSample6,
      (*7*)solidEColiSampleInDWP,
      (*8*)liquidCultureSample,
      (*9*)liquidCultureSampleInFlask,
      (*10*)testLBBrothSample,
      (*11*)eColiSampleNoFluorescentWavelengths,
      (*12*)eColiSampleHalfMatchFluorescentWavelengths,
      (*13*)eColiLiquidCulture1,
      (*14*)eColiLiquidCulture2,
      (*15*)eColiLiquidCulture3,
      (*16*)eColiLiquidCulture4,
      (*17*)agarStab1,
      (*18*)agarStab2,
      (*19*)agarStab3,
      (*20*)agarStab4,
      (*21*)freezeDried1,
      (*22*)freezeDried2,
      (*23*)noPreferredFreezeDriedSample,
      (*24*)frozenGlycerol1,
      (*25*)frozenGlycerol2,
      (*26*)liquidCultureSample3L,
      (*27*)unaspiratableSample,
      (*28*)noPreferredLiquidMediaSample,
      (*29*)testIncompatibleInputSample,
      (*30*)testDeprecatedInputSample,
      (*31*)testDiscardedInputSample,
      (*Mammalian cell samples*)
      (*32*)mammalianSolidMediaSample,
      (*33*)mammalianLiquidCultureSample,
      (*34*)mammalianFreezeDriedSample,
      (*35*)mammalianLiquidSampleInCryovial,
      (*36*)mammalianFrozenGlycerolSample,
      (*37*)testWashSolution,
      (*Insect cell samples*)
      (*38*)insectPelletSample
    } = UploadSample[
      {
        (*1*)testEColiSampleModel,
        (*2*)testEColiSampleModel,
        (*3*)testEColiSampleModel,
        (*4*)testEColiSampleModel,
        (*5*)testEColiSampleModel,
        (*6*)testEColiSampleModel,
        (*7*)testEColiSampleModel,
        (*8*)testEColiLiquidCultureSampleModel,
        (*9*)testEColiLiquidCultureSampleModel,
        (*10*)Model[Sample, Media, "LB Broth, Miller"],
        (*11*)testEColiNoFluorescentWavelengthsSampleModel,
        (*12*)testEColiHalfMatchFluorescentWavelengthsSampleModel,
        (*13*)testEColiLiquidCultureSampleModel,
        (*14*)testEColiLiquidCultureSampleModel,
        (*15*)testEColiLiquidCultureSampleModel,
        (*16*)testEColiLiquidCultureSampleModel,
        (*17*)testEColiSampleModel,
        (*18*)testEColiSampleModel,
        (*19*)testEColiSampleModel,
        (*20*)testEColiSampleModel,
        (*21*)testEColiFreezeDriedModel,
        (*22*)testEColiFreezeDriedModel,
        (*23*)testEColiSampleModelNoPreferredLiquidMedia,
        (*24*)testEColiFrozenGlycerolModel,
        (*25*)testEColiFrozenGlycerolModel,
        (*26*)testEColiLiquidCultureSampleModel,
        (*27*)testEColiLiquidCultureSampleModel,
        (*28*)testEColiSampleModelNoPreferredLiquidMedia,
        (*29*)testIncompatibleSampleModel,
        (*30*)testDeprecatedSampleModel,
        (*31*)testEColiFrozenGlycerolModel,
        (*32*)testMammalianSampleModel,
        (*33*)testMammalianLiquidCultureSampleModel,
        (*34*)testMammalianFreezeDriedSampleModel,
        (*35*)testMammalianLiquidCultureSampleModel,
        (*36*)testMammalianFrozenGlycerolSampleModel,
        (*37*)Model[Sample, "id:8qZ1VWNmdLBD"],(*"Milli-Q water"*)
        (*38*)Model[Sample, "Insect cell membrane pellet"]
      },
      {
        (*1*){"A1", omniTray1},
        (*2*){"A1", omniTray2},
        (*3*){"A1", omniTray3},
        (*4*){"A1", omniTray4},
        (*5*){"A1", omniTray5},
        (*6*){"A1", omniTray6},
        (*7*){"A1", dwp1},
        (*8*){"A1", omniTray7},
        (*9*){"A1", flask500mL1},
        (*10*){"A1", flask500mL2},
        (*11*){"A1", omniTray9},
        (*12*){"A1", omniTray10},
        (*13*){"A1", dwp2},
        (*14*){"A1", dwp3},
        (*15*){"A1", dwp4},
        (*16*){"A1", dwp5},
        (*17*){"A1", cryoVial1},
        (*18*){"A1", cryoVial2},
        (*19*){"A1", cryoVial3},
        (*20*){"A1", cryoVial4},
        (*21*){"A1", ampoule1},
        (*22*){"A1", ampoule2},
        (*23*){"A1", ampoule3},
        (*24*){"A1", cryoVial6},
        (*25*){"A1", cryoVial7},
        (*26*){"A1", amberGlassBottle4L1},
        (*27*){"A1", unaspiratable2mLTube},
        (*28*){"A1", cryoVial5},
        (*29*){"A1", omniTray11},
        (*30*){"A1", cryoVial10},
        (*31*){"A1", cryoVial11},
        (*Mammalian samples*)
        (*32*){"A1", omniTray12},
        (*33*){"A1", dwp6},
        (*34*){"A1", ampoule4},
        (*35*){"A1", cryoVial8},
        (*36*){"A1", cryoVial9},
        (*Other*)
        (*37*){"A1", washSolutionTube},
        (*38*){"A1", dwp8}
      },
      Name -> Join[
        Table[
          functionName <> " test e.coli sample " <> ToString[i] <>" in omniTray " <> $SessionUUID,
          {i,1,6}
        ],
        {
          functionName <> " test solid e.coli sample 1 in dwp " <> $SessionUUID,
          functionName <> " test liquid e.coli culture 1 in omniTray " <> $SessionUUID,
          functionName <> " test liquid e.coli culture 1 in 500 mL flask " <> $SessionUUID,
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
        Table[
          functionName <> " test freeze dried e.coli " <> ToString[i] <>" in ampoule " <> $SessionUUID,
          {i,1,2}
        ],
        {
          functionName <> " test freeze dried e.coli in ampoule - no PreferredLiquidMedia " <> $SessionUUID
        },
        Table[
          functionName <> " test e.coli in frozen glycerol " <> ToString[i] <>" in cryoVial " <> $SessionUUID,
          {i,1,2}
        ],
        {
          functionName <> " test LB Broth in 4L amber glass flask " <> $SessionUUID,
          functionName <> " test unaspiratable LB Broth sample in 2mL Tube " <> $SessionUUID,
          functionName <> " test e.coli stab 5 in cryoVial - no PreferredLiquidMedia " <> $SessionUUID,
          functionName <> " test incompatible input sample in omnitray " <> $SessionUUID,
          functionName <> " test deprecated input sample in cryoVial " <> $SessionUUID,
          functionName <> " test discarded input sample in cryoVial " <> $SessionUUID
        },
        {
          functionName <> " test Mammalian sample in omniTray " <> $SessionUUID,
          functionName <> " test liquid Mammalian sample in dwp " <> $SessionUUID,
          functionName <> " test FreezeDried Mammalian sample in ampoule " <> $SessionUUID,
          functionName <> " test liquid Mammalian sample in cryoVial " <> $SessionUUID,
          functionName <> " test Mammalian sample in frozen glycerol in cryoVial " <> $SessionUUID,
          functionName <> " test wash solution (MilliQ) " <> $SessionUUID,
          functionName <> " test Insect pellet sample in dwp " <> $SessionUUID
        }
      ],
      InitialAmount -> Join[
        (*1-6*)ConstantArray[1 Gram, 6],
        (*7-12*){1 Gram, 5 Milliliter, 200 Milliliter, 400 Milliliter, 1 Gram, 1 Gram},
        (*13-16*)ConstantArray[1 Milliliter, 4],
        (*17-20*)ConstantArray[1 Gram, 4],
        (*21-23*)ConstantArray[100 Milligram, 3],
        (*24-25*)ConstantArray[1 Gram, 2],
        (*26-31*){200 Milliliter, 2 Milliliter, 1 Gram, 1 Gram, 1 Gram, 1 Gram},
        (*32-38*){1 Gram, 1 Milliliter, 100 Milligram, 1 Milliliter, 1 Gram, 45 Milliliter, 5 Gram}
      ]
    ];

    (* Do some final updates to the samples *)
    Upload[{
      (* Mark discarded sample *)
      <|Object -> testDiscardedInputSample, Status -> Discarded|>
    }];

    (* Create test waste bins *)
    Upload[{
      <|
        Type -> Object[Container, WasteBin],
        Model -> Link[Model[Container, WasteBin,  "Biohazard Waste Container, BSC (Microbial)"], Objects],
        Site -> Link[$Site],
        Status -> Available,
        Name ->  functionName <> " test biosafety waste bin 1 " <> $SessionUUID
      |>,
      <|
        Type -> Object[Container, WasteBin],
        Model -> Link[Model[Container, WasteBin,  "Biohazard Waste Container, BSC (Microbial)"], Objects],(*"Biohazard Waste Container, BSC (Microbial)"*)
        Site -> Link[$Site],
        Status -> Available,
        Name ->  functionName <> " test biosafety waste bin 2 " <> $SessionUUID
      |>,
      <|
        Type -> Object[Container, WasteBin],
        Model -> Link[Model[Container, WasteBin, "id:dORYzZd9e0X5"], Objects],(* "Biohazard Waste Container, BSC (Tissue Culture)"*)
        Site -> Link[$Site],
        Status -> Available,
        Name ->  functionName <> " test biosafety waste bin 3 " <> $SessionUUID
      |>
    }];

    (* Create test BSCs *)
    Upload[{
      <|
        Type -> Object[Instrument, BiosafetyCabinet],
        Model -> Link[Model[Instrument, BiosafetyCabinet, "id:WNa4ZjKZpBeL"], Objects],(* Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Microbial) *)
        Site -> Link[$Site],
        Status -> Available,
        Name ->  functionName <> " test bsc 1 " <> $SessionUUID,
        BiosafetyWasteBin -> Link[Object[Container, WasteBin, functionName <> " test biosafety waste bin 1 " <> $SessionUUID]]
      |>,
      <|
        Type -> Object[Instrument, BiosafetyCabinet],
        Model -> Link[Model[Instrument, BiosafetyCabinet, "id:WNa4ZjKZpBeL"], Objects],(* Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Microbial) *)
        Site -> Link[$Site],
        Status -> Available,
        Name ->  functionName <> " test bsc 2 " <> $SessionUUID,
        BiosafetyWasteBin -> Link[Object[Container, WasteBin, functionName <> " test biosafety waste bin 2 " <> $SessionUUID]]
      |>,
      <|
        Type -> Object[Instrument, BiosafetyCabinet],
        Model -> Link[Model[Instrument, BiosafetyCabinet, "id:dORYzZJzEBdE"], Objects],(* Thermo Scientific 1300 Series Class II, Type A2 Biosafety Cabinet (Tissue Culture) *)
        Site -> Link[$Site],
        Status -> Available,
        Name ->  functionName <> " test tc bsc 1 " <> $SessionUUID,
        BiosafetyWasteBin -> Link[Object[Container, WasteBin, functionName <> " test biosafety waste bin 3 " <> $SessionUUID]]
      |>
    }];
    
  ];
];
