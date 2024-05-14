(* ::Subsection:: *)
(*PlotGelAnimation*)

DefineTests[PlotGelAnimation,
  {
    Example[{Basic, "Given an AgaroseGelElectrophoresis data object, plot its gel animations:"},
      PlotGelAnimation[Object[Data,AgaroseGelElectrophoresis,"Test AgaroseGelElectrophoresis data object for PlotGelAnimation testing"<>$SessionUUID]],
      {_TabView}
    ],

    Example[{Basic, "Given a PAGE data object, plot its gel animations:"},PlotGelAnimation[Object[Data,PAGE,"Test PAGE data object for PlotGelAnimation testing"<>$SessionUUID]],
      {_TabView}
    ],

    Example[{Basic, "Given an AgaroseGelElectrophoresis protocol object, plot its gel animations:"},
      PlotGelAnimation[Object[Protocol,AgaroseGelElectrophoresis,"Test AgaroseGelElectrophoresis protocol object for PlotGelAnimation testing"<>$SessionUUID]],
      {_TabView}
    ],

    Example[{Basic, "Given a PAGE protocol object, plot its gel animations:"},
      PlotGelAnimation[Object[Protocol,PAGE,"Test PAGE protocol object for PlotGelAnimation testing"<>$SessionUUID]],
      {_TabView}
    ],

    Example[{Basic, "Can plot animations for multiple plates:"},
      PlotGelAnimation[Object[Data,AgaroseGelElectrophoresis,"Test AgaroseGelElectrophoresis data object 2 for PlotGelAnimation testing"<>$SessionUUID]],
      {_TabView,_TabView}
    ],

    Example[{Messages,"FileNotFound","Show an error and return $Failed if the input object does not have the necessary animation files:"},
      PlotGelAnimation[Object[Data,PAGE,"Test PAGE data object 2 for PlotGelAnimation testing"<>$SessionUUID]],
      $Failed,
      Messages:>{Error::GelAnimationFileNotFound}
    ]
  },

  SymbolSetUp:>(

    $CreatdObjects={};

    Quiet[EraseObject[
      {
        Object[Data,AgaroseGelElectrophoresis,"Test AgaroseGelElectrophoresis data object for PlotGelAnimation testing"<>$SessionUUID],
        Object[Data,AgaroseGelElectrophoresis,"Test AgaroseGelElectrophoresis data object 2 for PlotGelAnimation testing"<>$SessionUUID],
        Object[Protocol,AgaroseGelElectrophoresis,"Test AgaroseGelElectrophoresis protocol object for PlotGelAnimation testing"<>$SessionUUID],
        Object[Protocol,AgaroseGelElectrophoresis,"Test AgaroseGelElectrophoresis protocol object 2 for PlotGelAnimation testing"<>$SessionUUID],
        Object[Data,PAGE,"Test PAGE data object for PlotGelAnimation testing"<>$SessionUUID],
        Object[Data,PAGE,"Test PAGE data object 2 for PlotGelAnimation testing"<>$SessionUUID],
        Object[Protocol,PAGE,"Test PAGE protocol object for PlotGelAnimation testing"<>$SessionUUID],
        Object[Protocol,PAGE,"Test PAGE protocol object 2 for PlotGelAnimation testing"<>$SessionUUID]
      },
      Force -> True, Verbose -> False]
    ];

    (* create test data and test protocol objects *)
    {testAgarData, testAgarData2, testAgarProtocol, testAgarProtocol2, testPAGEData, testPAGEData2, testPAGEProtocol, testPAGEProtocol2} = CreateID[
      {
        Object[Data, AgaroseGelElectrophoresis],
        Object[Data, AgaroseGelElectrophoresis],
        Object[Protocol, AgaroseGelElectrophoresis],
        Object[Protocol, AgaroseGelElectrophoresis],
        Object[Data, PAGE],
        Object[Data, PAGE],
        Object[Protocol, PAGE],
        Object[Protocol, PAGE]
      }
    ];

    (* fill in necessary data fields and protocol links *)
    {testAgarData, testPAGEData, testPAGEData2, testAgarData2} = Upload[
      {
        <|
          Object -> testAgarData,
          Name -> "Test AgaroseGelElectrophoresis data object for PlotGelAnimation testing"<>$SessionUUID,
          Replace[Protocol] -> Link[testAgarProtocol, Data],
          Replace[RedAnimationFiles] -> {Link[Object[EmeraldCloudFile, "id:R8e1PjeeEqap"]]},
          Replace[BlueAnimationFiles] -> {Link[Object[EmeraldCloudFile, "id:qdkmxzkkV3D0"]]},
          Replace[CombinedAnimationFiles] -> {Link[Object[EmeraldCloudFile, "id:O81aEB11z6w1"]]}
        |>,
        <|
          Object -> testPAGEData,
          Name -> "Test PAGE data object for PlotGelAnimation testing"<>$SessionUUID,
          Replace[Protocol] -> Link[testPAGEProtocol, Data]
        |>,
        <|
          Object -> testPAGEData2,
          Name -> "Test PAGE data object 2 for PlotGelAnimation testing"<>$SessionUUID,
          Replace[Protocol] -> Link[testPAGEProtocol2, Data]
        |>,
        <|
          Object -> testAgarData2,
          Name -> "Test AgaroseGelElectrophoresis data object 2 for PlotGelAnimation testing"<>$SessionUUID,
          Replace[Protocol] -> Link[testAgarProtocol2, Data],
          Replace[RedAnimationFiles] -> {Link[Object[EmeraldCloudFile, "id:M8n3rxnna8NP"]], Link[Object[EmeraldCloudFile, "id:WNa4Zjaa1NXz"]]},
          Replace[BlueAnimationFiles] -> {Link[Object[EmeraldCloudFile, "id:mnk9jOkkZnKR"]], Link[Object[EmeraldCloudFile, "id:BYDOjvDDZY3D"]]},
          Replace[CombinedAnimationFiles] -> {Link[Object[EmeraldCloudFile, "id:54n6evnnY4qG"]], Link[Object[EmeraldCloudFile, "id:n0k9mGkke0jW"]]}
        |>
      }
    ];

    (* link protocols to data *)
    {testAgarProtocol, testAgarProtocol2, testPAGEProtocol,testPAGEProtocol2} = Upload[
      {
        <|
          Object -> testAgarProtocol,
          Name -> "Test AgaroseGelElectrophoresis protocol object for PlotGelAnimation testing"<>$SessionUUID,
          Replace[Data] -> {Link[testAgarData, Protocol]}
        |>,
        <|
          Object -> testAgarProtocol2,
          Name -> "Test AgaroseGelElectrophoresis protocol object 2 for PlotGelAnimation testing"<>$SessionUUID,
          Replace[Data] -> {Link[testAgarData2, Protocol]}
        |>,
        <|
          Object -> testPAGEProtocol,
          Name -> "Test PAGE protocol object for PlotGelAnimation testing"<>$SessionUUID,
          Replace[Data] -> {Link[testPAGEData, Protocol]},
          DataFile -> Link[Object[EmeraldCloudFile, "id:9RdZXvdKe6mL"]]
        |>,
        <|
          Object -> testPAGEProtocol2,
          Name -> "Test PAGE protocol object 2 for PlotGelAnimation testing"<>$SessionUUID,
          Replace[Data] -> {Link[testPAGEData2, Protocol]}
        |>
      }
   ];

   (* generate animations *)
   InternalExperiment`Private`gelGIFCreator[testPAGEProtocol]

  ),
   SymbolTearDown:>(

     Quiet[EraseObject[
       {
         Object[Data,AgaroseGelElectrophoresis,"Test AgaroseGelElectrophoresis data object for PlotGelAnimation testing"<>$SessionUUID],
         Object[Data,AgaroseGelElectrophoresis,"Test AgaroseGelElectrophoresis data object 2 for PlotGelAnimation testing"<>$SessionUUID],
         Object[Protocol,AgaroseGelElectrophoresis,"Test AgaroseGelElectrophoresis protocol object for PlotGelAnimation testing"<>$SessionUUID],
         Object[Protocol,AgaroseGelElectrophoresis,"Test AgaroseGelElectrophoresis protocol object 2 for PlotGelAnimation testing"<>$SessionUUID],
         Object[Data,PAGE,"Test PAGE data object for PlotGelAnimation testing"<>$SessionUUID],
         Object[Data,PAGE,"Test PAGE data object 2 for PlotGelAnimation testing"<>$SessionUUID],
         Object[Protocol,PAGE,"Test PAGE protocol object 2 for PlotGelAnimation testing"<>$SessionUUID],
         Object[Protocol,PAGE,"Test PAGE protocol object for PlotGelAnimation testing"<>$SessionUUID]

       },
       Force -> True, Verbose -> False]

     ];
     (* just to be sure, erase createdObjects *)
     EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
  )
]
