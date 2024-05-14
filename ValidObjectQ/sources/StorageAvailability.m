(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*validStorageAvailabilityQTests*)


validStorageAvailabilityQTests[packet:PacketP[Object[StorageAvailability]]]:={

  (* General fields filled in *)
  NotNullFieldTest[packet,
    {
      MaxPositionDepth, MaxPositionWidth, Full, Position, Container,
      StorageFormat, ProvidedStorageCondition, Status
    }
  ],

  (* verify that the position is a valid position in the container *)
  Test["The Position exists in the Container's model:",
    Module[{positions},
      positions = Download[Lookup[packet, Container], Model[Positions]];
      If[MatchQ[positions,_List],
        MemberQ[Lookup[positions, Name], Lookup[packet, Position]],
        False
      ]
    ],
    True
  ],

  (* -- Pile -- *)
  RequiredTogetherTest[packet,{ModelPiled, NumberOfPiledObjects, AvailablePileCapacity}],

  (* If we are a Pile, do not populate 2D fields *)
  Test["If StorageFormat is Pile then TransverseAvailableSpaceDimensions and AvailableSpaceDimensions are not informed:",
    If[MatchQ[Lookup[packet,StorageFormat],Pile],
      Lookup[packet,{TransverseAvailableSpaceDimensions,AvailableSpaceDimensions}],
      {Null, Null}
    ],
    {Null, Null}
  ],

  (* If we are a Pile, populate all pile fields *)
  Test["If StorageFormat is Pile then ModelPiled, NumberOfPiledObjects, and AvailablePileCapacity are informed:",
    If[MatchQ[Lookup[packet,StorageFormat],Pile],
      !MemberQ[Lookup[packet,{ModelPiled, NumberOfPiledObjects, AvailablePileCapacity}], Null],
      True
    ],
    True
  ],

  (* -- 2D pack -- *)
  RequiredTogetherTest[packet,{ModelPiled, NumberOfPiledObjects, AvailablePileCapacity}],

  (* If we are Open, do not populate pile fields *)
  Test["If StorageFormat is Open then ModelPiled, NumberOfPiledObjects, and AvailablePileCapacity are not informed:",
    If[MatchQ[Lookup[packet,StorageFormat],Open],
      Lookup[packet,{ModelPiled, NumberOfPiledObjects, AvailablePileCapacity}],
      {Null, Null, Null}
    ],
    {Null, Null, Null}
  ],

  Test["If StorageFormat is Open then TransverseAvailableSpaceDimensions, AvailableSpaceDimensions are informed:",
    If[MatchQ[Lookup[packet,StorageFormat],Open],
      !MemberQ[Lookup[packet,{TransverseAvailableSpaceDimensions, AvailableSpaceDimensions}], Null],
      True
    ],
    True
  ],

  (* -- Footprint -- *)
  (* If we are Footprinted, what things are Null and what things are populated? *)
  Test["If StorageFormat is Footprinted then TransverseAvailableSpaceDimensions,AvailableSpaceDimensions,ModelPiled, NumberOfPiledObjects, and AvailablePileCapacity are not informed:",
    If[MatchQ[Lookup[packet,StorageFormat],Footprint],
      Lookup[packet,
        {
          TransverseAvailableSpaceDimensions,
          AvailableSpaceDimensions,
          ModelPiled,
          NumberOfPiledObjects,
          AvailablePileCapacity
        }
      ],
      {Null, Null, Null, Null, Null}
    ],
    {Null, Null, Null, Null, Null}
  ],

  Test["If the StorageFormat is Footprint, Footprint must not be Null|Open:",
    !MatchQ[Lookup[packet, {StorageFormat, Footprint}], {Footprint, (Null|Open)}],
    True
  ],

  (* -- Undefined -- *)
  Test["If StorageFormat is Undefined then TransverseAvailableSpaceDimensions, AvailableSpaceDimensions, and TotalVolume are informed:",
    If[MatchQ[Lookup[packet,StorageFormat],Undefined],
      !MemberQ[Lookup[packet,{TransverseAvailableSpaceDimensions, AvailableSpaceDimensions, TotalVolume}], Null],
      True
    ],
    True
  ],
  Test["If StorageFormat is Undefined then ModelPiled, NumberOfPiledObjects, and AvailablePileCapacity are not informed and the Footprint is Open|Null:",
    If[MatchQ[Lookup[packet,StorageFormat],Undefined],
      Lookup[packet,{ModelPiled, NumberOfPiledObjects, AvailablePileCapacity, Footprint}],
      {Null, Null, Null, (Open|Null)}
    ],
    {Null, Null, Null, (Open|Null)}
  ]
};


registerValidQTestFunction[Object[StorageAvailability],validStorageAvailabilityQTests];
