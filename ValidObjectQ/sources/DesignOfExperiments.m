(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*DesignOfExperiments*)

validDesignOfExperimentsQTests[myPacket:PacketP[Object[DesignOfExperiment]]]:={

(* General fields filled in *)
  NotNullFieldTest[myPacket,
    {
    Name,
    DateCreated,
    Authors,
    ProtocolType,
    ObjectiveFunction,
    OptimizationParameters,
    OptimizationRanges
    }
  ],
  Test["DateCreated is in the past:",
    Lookup[myPacket,DateCreated],
    _?(#<=Now&)|Null
  ],
  Test["Optimization ranges are at least length 2:",
    Min[Length /@ Lookup[myPacket, OptimizationRanges]],
    _?(#>=2&)|Null
  ]

};

registerValidQTestFunction[Object[DesignOfExperiment],validDesignOfExperimentsQTests];
