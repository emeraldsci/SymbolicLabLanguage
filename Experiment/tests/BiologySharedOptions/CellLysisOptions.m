(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(* checkLysisConflictingOptions *)

DefineTests[checkLysisConflictingOptions,
  {
    Example[{Basic, "Given inputs with no conflicting lysis options and messagesQ set to True, returns empty list of options, Null test, and no message:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkLysisConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkLysisConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Lyse->{True,False},LysisMixTime->{1 Minute,Null}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkLysisConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkLysisConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkLysisConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          True
        ]
      ],
      {{},Null}
    ],

    Example[{Basic,"Given inputs with conflicting options and messagesQ->True, returns list of conflicting options, Null test, and Error::LysisConflictingOptions "},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkLysisConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkLysisConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Lyse->{False,False},LysisMixTime->{1 Minute,Null}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkLysisConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkLysisConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkLysisConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          True
        ]
      ],
      {{LysisMixTime},Null},
      Messages :> {Error::LysisConflictingOptions}
    ],

    Example[{Basic,"Given inputs with no conflicting options and messagesQ->False, returns empty list of options, a passing test, and no message:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkLysisConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkLysisConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Lyse->{True,False},LysisMixTime->{1 Minute,Null}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkLysisConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkLysisConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkLysisConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          False
        ]
      ],
      {{}, {TestP}}
    ],

    Example[{Basic,"Given inputs with conflicting options and messagesQ->False, returns lists of conflicting options and a list of passing and failing tests"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkLysisConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkLysisConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Lyse->{False,False},LysisMixTime->{1 Minute,Null}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkLysisConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkLysisConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkLysisConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          False
        ]
      ],
      {{LysisMixTime}, {TestP,TestP}}
    ]
  },

  Stubs :> {
    $DeveloperUpload = True,
    $EmailEnabled = False
  },

  SymbolSetUp :> (
    Module[{allTestObjects, existsFilter, plate1, sample1, sample2},
      $CreatedObjects = {};
      Off[Warning::SamplesOutOfStock];
      Off[Warning::InstrumentUndergoingMaintenance];
      Off[Warning::DeprecatedProduct];

      allTestObjects = {
        Object[Container, Plate, "Test 96-well plate 1 (Test for checkLysisConflictingOptions) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 1 (Test for checkLysisConflictingOptions) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 2 (Test for checkLysisConflictingOptions) "<>$SessionUUID]
      };

      existsFilter = DatabaseMemberQ[allTestObjects];

      EraseObject[
        PickList[
          allTestObjects,
          existsFilter
        ],
        Force -> True,
        Verbose -> False
      ];

      plate1 = Upload[
        <|
          Type -> Object[Container, Plate],
          Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
          Name -> "Test 96-well plate 1 (Test for checkLysisConflictingOptions) "<>$SessionUUID,
          DeveloperObject -> True
        |>
      ];

      {sample1, sample2} = UploadSample[
        {
          {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
          {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}}
        },
        {
          {"A1", plate1},
          {"A2", plate1}
        },
        Name -> {
          "Suspension bacterial cell sample 1 (Test for checkLysisConflictingOptions) "<>$SessionUUID,
          "Suspension bacterial cell sample 2 (Test for checkLysisConflictingOptions) "<>$SessionUUID
        },
        InitialAmount -> {
          0.5 Milliliter,
          0.5 Milliliter
        },
        CellType -> {
          Microbial,
          Microbial
        },
        CultureAdhesion -> {
          Suspension,
          Suspension
        },
        Living -> {
          True,
          True
        },
        State -> Liquid,
        FastTrack -> True
      ];
      Upload[<|Object -> #, Status -> Available, DeveloperObject -> True|>& /@ {sample1, sample2}];
    ]
  ),

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];

    Module[{allTestObjects, existsFilter},
      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allTestObjects = Cases[Flatten[{
        Object[Container, Plate, "Test 96-well plate 1 (Test for checkLysisConflictingOptions) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 1 (Test for checkLysisConflictingOptions) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 2 (Test for checkLysisConflictingOptions) "<>$SessionUUID]
      }],ObjectP[]];

      (* Erase any objects that we failed to erase in the last unit test *)
      existsFilter = DatabaseMemberQ[allTestObjects];

      Quiet[EraseObject[
        PickList[
          allTestObjects,
          existsFilter
        ],
        Force -> True,
        Verbose -> False
      ]];
    ]
  )

]