(* Options *)
DefineOptions[resolveWaitPrimitive,
  Options:>{
    (* NOTE: This is a special Output option because we use this function for BOTH the manual and work cell versions. *)
    {
      OptionName->Output,
      Default->Options,
      AllowNull->False,
      Widget->Alternatives[
        Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, RunTime, Simulation, Resources]],
        Adder[Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, RunTime, Simulation, Resources]]]
      ],
      Description->"Indicate what the function should return.",
      Category->"Hidden"
    },

    PreparationOption,
    SimulationOption,
    CacheOption,
    UploadOption,
    ParentProtocolOption
  }
];

(* Source Code *)

(* NOTE: This is a silly function, but is needed for our primitive to slot into the framework. Wait can ALWAYS be done *)
(* manually or on a work cell. *)
resolveWaitMethod[myDuration:TimeP, myOptions:OptionsPattern[]]:={Manual, Robotic};
resolveWaitWorkCell[myDuration:TimeP, myOptions:OptionsPattern[]]:={STAR, bioSTAR, microbioSTAR};

(* NOTE: If you're looking for a primitive to template off of, do NOT pick this one. *)
resolveWaitPrimitive[myDuration:TimeP,myOptions:OptionsPattern[]]:=Module[
  {outputSpecification, output, unitOperationPacket},

  (* Determine the requested return value from the function *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Get our unit operation packet. *)
  unitOperationPacket=UploadUnitOperation[
    Wait[Duration->myDuration],

    UnitOperationType->Output,
    Preparation->Lookup[ToList[myOptions], Preparation],
    FastTrack->True,
    Upload->False
  ];

  (* Return requested output *)
  outputSpecification/.{
    Result->unitOperationPacket,
    Options -> {},
    Simulation -> Simulation[unitOperationPacket],
    RunTime -> myDuration,
    Tests -> {}
  }
];