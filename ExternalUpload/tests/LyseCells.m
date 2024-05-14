(*::Subsection::*)
(*UploadLyseCellsMethod*)

DefineTests[
  UploadLyseCellsMethod,
  {
    Example[{Basic, "Create a method to lyse cells:"},
      UploadLyseCellsMethod[
        "My Lyse Cells Method (Test for UploadLyseCellsMethod) "<>$SessionUUID,
        CellType -> Mammalian,
        TargetCellularComponent -> TotalProtein,
        PreLysisPellet -> False,
        MixType -> Pipette,
        LysisTemperature -> 37 Celsius
      ],
      ObjectP[Object[Method, LyseCells]],
      SetUp :> {
        If[DatabaseMemberQ[Object[Method, LyseCells, "My Lyse Cells Method (Test for UploadLyseCellsMethod) "<>$SessionUUID]],
          EraseObject[Object[Method, LyseCells, "My Lyse Cells Method (Test for UploadLyseCellsMethod) "<>$SessionUUID], Force -> True, Verbose -> False]
        ];
      },
      TearDown :> {
        If[DatabaseMemberQ[Object[Method, LyseCells, "My Lyse Cells Method (Test for UploadLyseCellsMethod) "<>$SessionUUID]],
          EraseObject[Object[Method, LyseCells, "My Lyse Cells Method (Test for UploadLyseCellsMethod) "<>$SessionUUID], Force -> True, Verbose -> False]
        ];
      }
    ]
  }
];

(*::Subsection::*)
(*UploadLyseCellsMethodOptions*)

DefineTests[
  UploadLyseCellsMethodOptions,
  {
    Example[{Basic, "Create a method to lyse cells:"},
      UploadLyseCellsMethodOptions[
        "My Lyse Cells Method (Test for UploadLyseCellsMethodOptions) "<> $SessionUUID,
        OutputFormat -> List
      ],
      {__Rule}
    ],
    Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options:"},
      UploadLyseCellsMethodOptions[
        "My Lyse Cells Method (Test for UploadLyseCellsMethodOptions) "<> $SessionUUID,
        OutputFormat -> List
      ],
      {__Rule}
    ]
  },
  SymbolSetUp :> {
    If[DatabaseMemberQ[Object[Method, LyseCells, "My Lyse Cells Method (Test for UploadLyseCellsMethodOptions) " <> $SessionUUID]],
      EraseObject[Object[Method, LyseCells, "My Lyse Cells Method (Test for UploadLyseCellsMethodOptions) " <> $SessionUUID], Force -> True, Verbose -> False]
    ];
  },
  SymbolTearDown :> {
    If[DatabaseMemberQ[Object[Method, LyseCells, "My Lyse Cells Method (Test for UploadLyseCellsMethodOptions) " <> $SessionUUID]],
      EraseObject[Object[Method, LyseCells, "My Lyse Cells Method (Test for UploadLyseCellsMethodOptions) " <> $SessionUUID], Force -> True, Verbose -> False]
    ];
  }
];


(*::Subsection::*)
(*ValidUploadLyseCellsMethodQ*)

DefineTests[
  ValidUploadLyseCellsMethodQ,
  {
    Example[{Basic, "Create a method to lyse cells:"},
      ValidUploadLyseCellsMethodQ[
        "My Lyse Cells Method (Test for ValidUploadLyseCellsMethodQ) " <> $SessionUUID
      ],
      True
    ],
    Example[{Options, Verbose, "If Verbose -> Failures, any invalid options will be printed in the notebook:"},
      ValidUploadLyseCellsMethodQ[
        "My Lyse Cells Method (Test for ValidUploadLyseCellsMethodQ) " <> $SessionUUID,
        Verbose -> Failures
      ],
      True
    ],
    Example[{Options, OutputFormat, "If OutputFormat -> EmeraldTestSummary, return an emerald test summary:"},
      ValidUploadLyseCellsMethodQ[
        "My Lyse Cells Method (Test for ValidUploadLyseCellsMethodQ) " <> $SessionUUID,
        OutputFormat -> TestSummary
      ],
      _EmeraldTestSummary
    ]
  },
  SymbolSetUp :> {
    If[DatabaseMemberQ[Object[Method, LyseCells, "My Lyse Cells Method (Test for ValidUploadLyseCellsMethodQ) " <> $SessionUUID]],
      EraseObject[Object[Method, LyseCells, "My Lyse Cells Method (Test for ValidUploadLyseCellsMethodQ) " <> $SessionUUID], Force -> True, Verbose -> False]
    ];
  },
  SymbolTearDown :> {
    If[DatabaseMemberQ[Object[Method, LyseCells, "My Lyse Cells Method (Test for ValidUploadLyseCellsMethodQ) " <> $SessionUUID]],
      EraseObject[Object[Method, LyseCells, "My Lyse Cells Method (Test for ValidUploadLyseCellsMethodQ) " <> $SessionUUID], Force -> True, Verbose -> False]
    ];
  }
];

