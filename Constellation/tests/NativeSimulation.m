(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineTests[
  CreateNativeSimulation,
  {
    Example[{Basic, "Create an empty Simulation in Telescope:"},
      CreateNativeSimulation[],
      _String
    ],
    Example[{Basic, "Create an empty Simulation in Telescope with a specific ID:"},
      CreateNativeSimulation[CreateUUID[]],
      _String
    ]
  },
  SetUp :> Map[DeleteNativeSimulation,Map[Lookup["ID"], ListNativeSimulations[]]],
  TearDown :> Map[DeleteNativeSimulation,Map[Lookup["ID"], ListNativeSimulations[]]]
];

DefineTests[
  ListNativeSimulations,
  {
    Example[{Basic, "List all Simulations in Telescope:"},
      Module[{},
        CreateNativeSimulation[];
        CreateNativeSimulation[];
        ListNativeSimulations[]
      ],
      {OrderlessPatternSequence[KeyValuePattern[{"ID"->_String}],KeyValuePattern[{"ID"->_String}]]}
    ]
  },
  SetUp :> {
    Map[DeleteNativeSimulation,Map[Lookup["ID"], ListNativeSimulations[]]]
  },
  TearDown :> Map[DeleteNativeSimulation,Map[Lookup["ID"], ListNativeSimulations[]]]
];

DefineTests[
  GetNativeSimulation,
  {
    Example[{Basic, "Get information on the specified Simulation in Telescope:"},
      Module[{id},
        id=CreateNativeSimulation[];
        GetNativeSimulation[id]
      ],
      KeyValuePattern[{"ID"->_String}]
    ],
    Example[{Basic, "Returns $Failed if no Simulation with the given ID exists in Telescope:"},
      Module[{id},
        id="5be0a825-5b45-4880-bad9-13ece168ee1a";
        GetNativeSimulation[id]
      ],
      $Failed,
      Messages :> {NativeSimulation::CacheIDDoesNotExist}
    ]
  },
  SetUp :> {
    Map[DeleteNativeSimulation,Map[Lookup["ID"], ListNativeSimulations[]]]
  },
  TearDown :> Map[DeleteNativeSimulation,Map[Lookup["ID"], ListNativeSimulations[]]]
];

DefineTests[
  UpdateNativeSimulation,
  {
    Example[{Basic, "Update the specified Simulation in Telescope:"},
      Module[{id,firstUpdateOk,number},
        id=CreateNativeSimulation[];
        firstUpdateOk=UpdateNativeSimulation[id,{<|Object->Object[Example,Data,"id:123"],Number->42|>}];
        number=Download[Object[Example,Data,"id:123"],Number,Simulation->Simulation[Updated->True,NativeSimulationID->id]];
        {firstUpdateOk,number}
      ],
      {True,42}
    ],
    Example[{Basic, "Returns $Failed if no Simulation with the given ID exists in Telescope:"},
      Module[{id},
        id="5be0a825-5b45-4880-bad9-13ece168ee1a";
        UpdateNativeSimulation[id, {}]
      ],
      $Failed,
      Messages :> {NativeSimulation::CacheIDDoesNotExist}
    ],
    Example[{Messages, "BadCache", "Throws a warning if the provided packets are malformed."},
      Module[{id,firstUpdateOk,secondUpdateOk},
        id=CreateNativeSimulation[];
        firstUpdateOk=UpdateNativeSimulation[id, {}];
        secondUpdateOk=UpdateNativeSimulation[id,{<|Type->Object[Example],Object->"This shouldn't be a string!"|>}];
        {firstUpdateOk,secondUpdateOk}
      ],
      {True,True},
      Messages :> {Download::BadCache}
    ]
  },
  SetUp :> {
    Map[DeleteNativeSimulation,Map[Lookup["ID"], ListNativeSimulations[]]]
  },
  TearDown :> Map[DeleteNativeSimulation,Map[Lookup["ID"], ListNativeSimulations[]]]
];

DefineTests[
  DeleteNativeSimulation,
  {
    Example[{Basic, "Delete the specified Simulation from Telescope:"},
      Module[{id,simulationInfoAfterCreation,ok,simulationInfoAfterDeletion},
        id=CreateNativeSimulation[];
        simulationInfoAfterCreation=GetNativeSimulation[id];
        ok=DeleteNativeSimulation[id];
        simulationInfoAfterDeletion=GetNativeSimulation[id];
        {simulationInfoAfterCreation,ok,simulationInfoAfterDeletion}
      ],
      {KeyValuePattern[{}],True,$Failed},
      Messages :> {NativeSimulation::CacheIDDoesNotExist}
    ]
  },
  SetUp :> {
    Map[DeleteNativeSimulation,Map[Lookup["ID"], ListNativeSimulations[]]]
  },
  TearDown :> Map[DeleteNativeSimulation,Map[Lookup["ID"], ListNativeSimulations[]]]
];

DefineTests[
  CloneNativeSimulation,
  {
    Example[{Basic, "Clone an existing simulation in Telescope:"},
      Module[{originalID,responseID},
        originalID=CreateNativeSimulation[];
        responseID=CloneNativeSimulation[originalID];
        !MatchQ[responseID,originalID]
      ],
      True
    ]
  },
  SetUp :> Map[DeleteNativeSimulation,Map[Lookup["ID"], ListNativeSimulations[]]],
  TearDown :> Map[DeleteNativeSimulation,Map[Lookup["ID"], ListNativeSimulations[]]]
];