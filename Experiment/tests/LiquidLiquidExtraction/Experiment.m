(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection:: *)
(*ExperimentLiquidLiquidExtraction *)

DefineTests[
  ExperimentLiquidLiquidExtraction,
  {
    Example[{Basic,"Basic liquid liquid extraction with an aqueous sample with ExtractionTechnique->PhaseSeparator:"},
      ExperimentLiquidLiquidExtraction[
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
        ExtractionTechnique -> PhaseSeparator,
        SelectionStrategy -> Positive,
        TargetPhase -> Organic,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
        KeyValuePattern[{
          ExtractionTechnique -> PhaseSeparator,
          ExtractionDevice -> ObjectP[Model[Container, Plate, PhaseSeparator]],
          SamplePhase -> Aqueous,
          SolventAdditions -> {
            {
              Model[Sample, "id:eGakld01zzXo"],
              Model[Sample, "id:eGakld01zzXo"],
              Model[Sample, "id:eGakld01zzXo"]
            }
          }
        }]
      }
    ],
    Example[{Basic,"Basic liquid liquid extraction with an aqueous sample with ExtractionTechnique->Pipette:"},
      ExperimentLiquidLiquidExtraction[
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
        ExtractionTechnique -> Pipette,
        SelectionStrategy -> Positive,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
        KeyValuePattern[{
          ExtractionTechnique -> Pipette,
          ExtractionDevice -> Null,
          SamplePhase -> Aqueous,
          SolventAdditions -> {
            {
              Model[Sample, "id:9RdZXvKBeeGK"],
              Model[Sample, "id:9RdZXvKBeeGK"],
              Model[Sample, "id:9RdZXvKBeeGK"]
            }
          },
          TargetAnalyte -> ObjectP[Model[Molecule, "Taxol"]]
        }]
      }
    ],
    Example[{Additional,"Accepts {position, container} as inputs:"},
      ExperimentLiquidLiquidExtraction[
        {"A1", Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLiquidLiquidExtraction "<>$SessionUUID]},
        ExtractionTechnique -> Pipette,
        SelectionStrategy -> Positive,
        Output -> Result
      ],
      ObjectP[Object[Protocol, RoboticSamplePreparation]]
    ],
    Test["If the user tells us that a solution is Organic when we think it is Aqueous, believe them and treat it as Organic:",
      Module[{},
        ExperimentLiquidLiquidExtraction[
          {
            Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
          },
          SamplePhase -> Organic,
          ExtractionTechnique -> Pipette,
          SelectionStrategy -> Positive,
          TargetPhase -> Aqueous,
          TargetLayer -> {Bottom, Bottom, Bottom},
          NumberOfExtractions -> 3,
          ExtractionMixType -> Pipette,
          NumberOfExtractionMixes -> 15,
          ExtractionMixVolume -> 100 Microliter,
          Output -> Options
        ];

        Experiment`Private`$LLEUnitOperations
      ],
      {
        ___,
        (* ROUND 1 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        (* ROUND 2 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        (* ROUND 3 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        Verbatim[LabelSample][___]
      }
    ],

    Test["Test the exact unit operations that LLE creates for an Aqueous solution, negative selection, and being extracted via pipette with 3 rounds of extraction, with centrifugation specified:",
      Module[{},
        ExperimentLiquidLiquidExtraction[
          {
            Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
          },
          SamplePhase -> Aqueous,
          ExtractionTechnique -> Pipette,
          SelectionStrategy -> Negative,
          TargetPhase -> Aqueous,
          TargetLayer -> {Top, Top, Top},
          NumberOfExtractions -> 3,
          ExtractionMixType -> Pipette,
          NumberOfExtractionMixes -> 15,
          ExtractionMixVolume -> 100 Microliter,
          Centrifuge -> True,
          Output -> Options
        ];

        Experiment`Private`$LLEUnitOperations
      ],
      {
        ___,
        (* ROUND 1 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {ObjectP[Object[Sample]]},
            Destination -> {{"A1", _String}}
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:9RdZXvKBeeGK"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Centrifuge][
          KeyValuePattern[{
            Sample -> {_String}
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        (* ROUND 2 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:9RdZXvKBeeGK"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Centrifuge][
          KeyValuePattern[{
            Sample -> {_String}
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        (* ROUND 3 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:9RdZXvKBeeGK"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Centrifuge][
          KeyValuePattern[{
            Sample -> {_String}
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        Verbatim[LabelSample][___]
      }
    ],

    Test["Test the exact unit operations that LLE creates for an Aqueous solution, negative selection, and being extracted via phase separator with 3 rounds of extraction:",
      Module[{},
        ExperimentLiquidLiquidExtraction[
          {
            Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
          },
          SamplePhase -> Aqueous,
          ExtractionTechnique -> PhaseSeparator,
          SelectionStrategy -> Negative,
          TargetPhase -> Aqueous,
          TargetLayer -> {Top, Top, Top},
          NumberOfExtractions -> 3,
          ExtractionMixType -> Pipette,
          NumberOfExtractionMixes -> 15,
          ExtractionMixVolume -> 100 Microliter,
          Output -> Options
        ];

        Experiment`Private`$LLEUnitOperations
      ],
      {
        ___,
        (* ROUND 1 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:eGakld01zzXo"]],(*Model[Sample, Chloroform]*)
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            CollectionContainer -> _String
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        (* ROUND 2 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:eGakld01zzXo"]],(*Model[Sample, Chloroform]*)
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"B1", _String},
            CollectionContainer -> _String
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"B1", _String},
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"B1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        (* ROUND 3 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:eGakld01zzXo"]],(*Model[Sample, Chloroform]*)
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"C1", _String},
            CollectionContainer -> _String
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"C1", _String},
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"C1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        Verbatim[LabelSample][___]
      }
    ],

    Test["Test the exact unit operations that LLE creates for an Aqueous solution, negative selection, and being extracted via pipette with 3 rounds of extraction:",
      Module[{},
        ExperimentLiquidLiquidExtraction[
          {
            Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
          },
          SamplePhase -> Aqueous,
          ExtractionTechnique -> Pipette,
          SelectionStrategy -> Negative,
          TargetPhase -> Aqueous,
          TargetLayer -> {Bottom, Bottom, Bottom},
          NumberOfExtractions -> 3,
          ExtractionMixType -> Pipette,
          NumberOfExtractionMixes -> 15,
          ExtractionMixVolume -> 100 Microliter,
          Output -> Options
        ];

        Experiment`Private`$LLEUnitOperations
      ],
      {
        ___,
        (* ROUND 1 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:9RdZXvKBeeGK"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        (* ROUND 2 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:9RdZXvKBeeGK"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        (* ROUND 3 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:9RdZXvKBeeGK"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        Verbatim[LabelSample][___]
      }
    ],

    Test["Test the exact unit operations that LLE creates for an Aqueous solution, positive selection, and being extracted via pipette with 3 rounds of extraction:",
      Module[{},
        ExperimentLiquidLiquidExtraction[
          {
            Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
          },
          SamplePhase -> Aqueous,
          ExtractionTechnique -> Pipette,
          SelectionStrategy -> Positive,
          TargetPhase -> Aqueous,
          TargetLayer -> {Bottom, Bottom, Bottom},
          NumberOfExtractions -> 3,
          ExtractionMixType -> Pipette,
          NumberOfExtractionMixes -> 15,
          ExtractionMixVolume -> 100 Microliter,
          Output -> Options
        ];

        Experiment`Private`$LLEUnitOperations
      ],
      {
        ___,
        (* ROUND 1 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:9RdZXvKBeeGK"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        (* ROUND 2 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        (* ROUND 3 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        Verbatim[LabelSample][___]
      }
    ],

    Test["Test the exact unit operations that LLE creates for an Aqueous solution being extracted via pipette with 1 round of extraction:",
      Module[{},
        ExperimentLiquidLiquidExtraction[
          {
            Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
          },
          SamplePhase -> Aqueous,
          ExtractionTechnique -> Pipette,
          TargetPhase -> Aqueous,
          TargetLayer -> {Bottom},
          NumberOfExtractions -> 1,
          ExtractionMixType -> Pipette,
          NumberOfExtractionMixes -> 15,
          ExtractionMixVolume -> 100 Microliter,
          Output -> Options
        ];

        Experiment`Private`$LLEUnitOperations
      ],
      {
        ___,
        (* ROUND 1 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:9RdZXvKBeeGK"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        Verbatim[LabelSample][___]
      }
    ],

    Test["Test the exact unit operations that LLE creates for an Organic solution, negative selection, and being extracted via pipette with 3 rounds of extraction:",
      Module[{},
        ExperimentLiquidLiquidExtraction[
          {
            Object[Sample, "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
          },
          SamplePhase -> Organic,
          ExtractionTechnique -> Pipette,
          SelectionStrategy -> Negative,
          TargetPhase -> Aqueous,
          TargetLayer -> {Bottom, Bottom, Bottom},
          NumberOfExtractions -> 3,
          ExtractionMixType -> Pipette,
          NumberOfExtractionMixes -> 15,
          ExtractionMixVolume -> 100 Microliter,
          Output -> Options
        ];

        Experiment`Private`$LLEUnitOperations
      ],
      (* NOTE: In this example, the target container is the same as the input container so there's no switcheroo necessary. *)
      {
        ___,
        (* ROUND 1 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],(*Model[Sample, "Milli-Q water"]*)
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        (* ROUND 2 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:9RdZXvKBeeGK"]],(*Model[Sample, "Ethyl acetate, HPLC Grade"]*)
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        (* ROUND 3 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:9RdZXvKBeeGK"]],(*Model[Sample, "Ethyl acetate, HPLC Grade"]*)
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        Verbatim[LabelSample][___]
      }
    ],

    Test["Test the exact unit operations that LLE creates for an Organic solution, positive selection, and being extracted via pipette with 3 rounds of extraction:",
      Module[{},
        ExperimentLiquidLiquidExtraction[
          {
            Object[Sample, "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
          },
          SamplePhase -> Organic,
          ExtractionTechnique -> Pipette,
          SelectionStrategy -> Positive,
          TargetPhase -> Aqueous,
          TargetLayer -> {Bottom, Bottom, Bottom},
          NumberOfExtractions -> 3,
          ExtractionMixType -> Pipette,
          NumberOfExtractionMixes -> 15,
          ExtractionMixVolume -> 100 Microliter,
          Output -> Options
        ];

        Experiment`Private`$LLEUnitOperations
      ],
      {
        ___,
        (* ROUND 1 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        (* ROUND 2 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        (* ROUND 3 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        Verbatim[LabelSample][___]
      }
    ],

    Test["Test the exact unit operations that LLE creates for an Organic solution being extracted via pipette with 1 round of extraction:",
      Module[{},
        ExperimentLiquidLiquidExtraction[
          {
            Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
          },
          SamplePhase -> Organic,
          ExtractionTechnique -> Pipette,
          TargetPhase -> Organic,
          TargetLayer -> {Bottom},
          NumberOfExtractions -> 1,
          ExtractionMixType -> Pipette,
          NumberOfExtractionMixes -> 15,
          ExtractionMixVolume -> 100 Microliter,
          Output -> Options
        ];

        Experiment`Private`$LLEUnitOperations
      ],
      {
        ___,
        (* ROUND 1 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        Verbatim[LabelSample][___]
      }
    ],

    Test["Test the exact unit operations that LLE creates for an Unknown solution, positive selection, and being extracted via pipette with 3 rounds of extraction:",
      Module[{},
        ExperimentLiquidLiquidExtraction[
          {
            Object[Sample, "Sample in DMSO (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
          },
          SamplePhase -> Unknown,
          ExtractionTechnique -> Pipette,
          SelectionStrategy -> Positive,
          TargetPhase -> Aqueous,
          TargetLayer -> {Bottom, Bottom, Bottom},
          NumberOfExtractions -> 3,
          ExtractionMixType -> Pipette,
          NumberOfExtractionMixes -> 15,
          ExtractionMixVolume -> 100 Microliter,
          Output -> Options
        ];

        Experiment`Private`$LLEUnitOperations
      ],
      {
        ___,
        (* ROUND 1 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:9RdZXvKBeeGK"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        (* ROUND 2 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        (* ROUND 3 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        Verbatim[LabelSample][___]
      }
    ],

    Test["Test the exact unit operations that LLE creates for an Unknown solution, negative selection, and being extracted via pipette with 3 rounds of extraction:",
      Module[{},
        ExperimentLiquidLiquidExtraction[
          {
            Object[Sample, "Sample in DMSO (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
          },
          SamplePhase -> Unknown,
          ExtractionTechnique -> Pipette,
          SelectionStrategy -> Negative,
          TargetPhase -> Organic,
          TargetLayer -> {Top, Top, Top},
          NumberOfExtractions -> 3,
          ExtractionMixType -> Pipette,
          NumberOfExtractionMixes -> 15,
          ExtractionMixVolume -> 100 Microliter,
          Output -> Options
        ];

        Experiment`Private`$LLEUnitOperations
      ],
      {
        ___,
        (* ROUND 1 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:9RdZXvKBeeGK"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        (* ROUND 2 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        (* ROUND 3 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        Verbatim[LabelSample][___]
      }
    ],

    Test["Test the exact unit operations that LLE creates for a biphasic solution, negative selection, and being extracted via pipette with 3 rounds of extraction:",
      Module[{},
        ExperimentLiquidLiquidExtraction[
          {
            Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID]
          },
          SamplePhase -> Biphasic,
          ExtractionTechnique -> Pipette,
          SelectionStrategy -> Negative,
          TargetPhase -> Organic,
          TargetLayer -> {Top, Top, Top},
          NumberOfExtractions -> 3,
          ExtractionMixType -> Pipette,
          NumberOfExtractionMixes -> 15,
          ExtractionMixVolume -> 100 Microliter,
          Output -> Options
        ];

        Experiment`Private`$LLEUnitOperations
      ],
      {
        ___,
        (* ROUND 1 *)
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        (* ROUND 2 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String}
          }]
        ],

        (* ROUND 3 *)
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> ObjectP[Model[Sample]],
            Destination -> {"A1", _String}
          }]
        ],
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],

        Verbatim[LabelSample][___]
      }
    ],

    Test["Test the exact unit operations that LLE creates for a biphasic solution, negative selection, and being extracted via pipette with 1 round of extraction:",
      Module[{},
        ExperimentLiquidLiquidExtraction[
          {
            Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID]
          },
          SamplePhase -> Biphasic,
          ExtractionTechnique -> Pipette,
          SelectionStrategy -> Negative,
          TargetPhase -> Organic,
          TargetLayer -> {Top},
          NumberOfExtractions -> 1,
          ExtractionMixType -> Pipette,
          NumberOfExtractionMixes -> 15,
          ExtractionMixVolume -> 100 Microliter,
          Output -> Options
        ];

        Experiment`Private`$LLEUnitOperations
      ],
      {
        ___,
        Verbatim[Mix][
          KeyValuePattern[{
            ECL`Sample -> {"A1", _String},
            ECL`MixType -> ECL`Pipette,
            ECL`Time -> Null,
            ECL`MixRate -> Null,
            NumberOfMixes -> 15,
            MixVolume -> 100 Microliter
          }]
        ],
        Verbatim[Wait][
          KeyValuePattern[{
            Duration -> Quantity[1, "Minutes"]
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[Transfer][
          KeyValuePattern[{
            Source -> {"A1", _String},
            Destination -> {"A1", _String},
            AspirationPosition -> LiquidLevel
          }]
        ],
        Verbatim[LabelSample][___]
      }
    ],

    Example[{Messages,"WeakTargetAnalytePhaseAffinity","Throw a warning if the target analytes specified have a weak affinity (according to the XLogP algorithm or experimentally measured LogP) to both the Aqueous and Organic phase and a TargetPhase isn't specified:"},
      ExperimentLiquidLiquidExtraction[
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
        TargetAnalyte -> Model[Molecule, "Caffeine"]
      ],
      ObjectP[Object[Protocol, RoboticSamplePreparation]],
      Messages:>{
        Warning::WeakTargetAnalytePhaseAffinity
      }
    ],

    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentLiquidLiquidExtraction[Object[Sample, "Nonexistent sample"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentLiquidLiquidExtraction[Object[Container, Vessel, "Nonexistent container"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentLiquidLiquidExtraction[Object[Sample, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentLiquidLiquidExtraction[Object[Container, Vessel, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],

    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Vessel,"50mL Tube"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Water"]}},
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 500 Microliter
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentLiquidLiquidExtraction[sampleID, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Vessel,"50mL Tube"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Water"]}},
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 500 Microliter
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentLiquidLiquidExtraction[containerID, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],

    Example[{Messages,"ConflictingMixParametersForLLE","Return an error if there are conflicting mix options specified:"},
      ExperimentLiquidLiquidExtraction[
        {
          Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID],
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID]
        },
        ExtractionMixType->Pipette,
        NumberOfExtractionMixes->Null
      ],
      $Failed,
      Messages:>{
        Error::ConflictingMixParametersForLLE,
        Error::InvalidOption
      }
    ],

    Example[{Messages,"ConflictingCentrifugeContainerParametersForLLE","Return an error if there are conflicting centrifugation options specified:"},
      ExperimentLiquidLiquidExtraction[
        {
          Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID],
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID]
        },
        ExtractionContainer -> {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
        Centrifuge->True,
        CentrifugeIntensity -> {1000 GravitationalAcceleration, 1200 GravitationalAcceleration}
      ],
      $Failed,
      Messages:>{
        Error::ConflictingCentrifugeContainerParametersForLLE,
        Error::InvalidOption
      }
    ],

    Example[{Messages,"ConflictingCentrifugeParametersForLLE","Return an error if there are conflicting mix options specified:"},
      ExperimentLiquidLiquidExtraction[
        {
          Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID],
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID]
        },
        Centrifuge->False,
        CentrifugeIntensity -> {1000 GravitationalAcceleration, 1200 GravitationalAcceleration}
      ],
      $Failed,
      Messages:>{
        Error::ConflictingCentrifugeParametersForLLE,
        Error::InvalidOption
      }
    ],

    Example[{Messages,"ConflictingTemperaturesForLLE","Return an error if there are conflicting temperature options specified:"},
      ExperimentLiquidLiquidExtraction[
        {
          Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID],
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID]
        },
        ExtractionContainer -> {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
        Temperature -> {30 Celsius, 40 Celsius}
      ],
      $Failed,
      Messages:>{
        Error::ConflictingTemperaturesForLLE,
        Error::InvalidOption
      }
    ],

    Example[{Messages,"ExtractionOptionMismatch","Return an error if there are conflicting extraction options specified:"},
      ExperimentLiquidLiquidExtraction[
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID],
        ExtractionTechnique -> Pipette,
        ExtractionDevice -> Model[Container, Plate, PhaseSeparator, "id:jLq9jXqrWW11"]
      ],
      $Failed,
      Messages:>{
        Error::ExtractionOptionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages,"DemulsifierSpecifiedConflict","Return an error if there is a conflict between the DemulsifierAdditions and Demulsifier options:"},
      ExperimentLiquidLiquidExtraction[
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID],
        Demulsifier -> Model[Sample, StockSolution, "id:AEqRl954GJb6"],
        DemulsifierAdditions -> {Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
        NumberOfExtractions -> 3
      ],
      $Failed,
      Messages:>{
        Error::DemulsifierSpecifiedConflict,
        Error::InvalidOption
      }
    ],

    Example[{Messages,"InvalidSolventAdditions","Return an error if the Solvents specified will be inadequate to create a biphasic solution for liquid liquid extraction:"},
      ExperimentLiquidLiquidExtraction[
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID],
        SamplePhase->Aqueous,
        OrganicSolvent -> None
      ],
      $Failed,
      Messages:>{
        Error::InvalidSolventAdditions,
        Error::InvalidOption
      }
    ],

    Example[{Messages,"SolventAdditionsMismatch","Return an error if the Solvents specified will be inadequate to create a biphasic solution for liquid liquid extraction:"},
      ExperimentLiquidLiquidExtraction[
        Object[Sample, "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID],
        SamplePhase->Organic,
        TargetPhase->Aqueous,
        SelectionStrategy->Positive,
        AqueousSolvent->Model[Sample, "Milli-Q water"],
        SolventAdditions->{{Model[Sample, "RO Water"]}, {Model[Sample, "RO Water"]}, {Model[Sample, "RO Water"]}}
      ],
      $Failed,
      Messages:>{
        Error::InvalidSolventAdditions,
        Error::SolventAdditionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages,"InvalidExtractionRoundLengths","Return an error if the length of the SolventAdditions option does not match the NumberOfExtractions option:"},
      ExperimentLiquidLiquidExtraction[
        Object[Sample, "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID],
        SamplePhase->Organic,
        TargetPhase->Aqueous,
        SelectionStrategy->Positive,
        AqueousSolvent->Model[Sample, "Milli-Q water"],
        SolventAdditions->{{Model[Sample, "Milli-Q water"]}, {Model[Sample, "Milli-Q water"]}}
      ],
      $Failed,
      Messages:>{
        Error::InvalidExtractionRoundLengths,
        Error::InvalidOption
      }
    ],

    Example[{Messages,"OrganicSolventDensityPhaseSeparator","Return an error if the user requests to use a PhaseSeparator but the Organic layer will be on top of the Aqueous layer and therefore will not be able to pass through the hydrophobic frit:"},
      ExperimentLiquidLiquidExtraction[
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
        SamplePhase -> Aqueous,
        ExtractionTechnique -> PhaseSeparator,
        SelectionStrategy -> Positive,
        TargetPhase -> Aqueous,
        TargetLayer -> {Bottom, Bottom, Bottom}
      ],
      $Failed,
      Messages:>{
        Error::OrganicSolventDensityPhaseSeparator,
        Error::InvalidOption
      }
    ],

    Example[{Options, ExtractionBoundaryVolume, "ExtractionBoundaryVolume is set to the smaller of 10% of the predicted volume of ExtractionTransferLayer or 5 mm the volume that corresponds with a 5 Millimeter tall cross-section of the ExtractionContainer at the position of the boundary between aqueous and organic layers if ExtractionTransferLayer -> Top or at the bottom of the container if ExtractionTransferLayer -> Bottom:"},
      ExperimentLiquidLiquidExtraction[
        {
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID]
        },
        SamplePhase -> Biphasic,
        ExtractionTechnique -> Pipette,
        SelectionStrategy -> Negative,
        TargetPhase -> Organic,
        NumberOfExtractions -> 1,
        Output -> Options
      ],
      KeyValuePattern[{
        ExtractionBoundaryVolume -> {VolumeP}
      }]
    ],

    Example[{Options, TargetLayer, "The TargetLayer will resolve to Top if the TargetPhase's solvent is less dense than the impurity phase:"},
      ExperimentLiquidLiquidExtraction[
        {
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) " <> $SessionUUID]
        },
        SamplePhase -> Biphasic,
        ExtractionTechnique -> Pipette,
        SelectionStrategy -> Negative,
        TargetPhase -> Organic,
        NumberOfExtractions -> 1,
        Output -> Options
      ],
      KeyValuePattern[{
        TargetLayer -> {Top}
      }]
    ],

    Test["The TargetLayer will resolve to Bottom if the TargetPhase's solvent is more dense than the impurity phase:",
      ExperimentLiquidLiquidExtraction[
        {
          Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
        },
        TargetPhase -> Aqueous,
        AqueousSolvent -> Model[Sample,"Milli-Q water"],
        OrganicSolvent -> Model[Sample,"Ethyl acetate, HPLC Grade"],
        Output -> Options
      ],
      KeyValuePattern[{
        TargetLayer -> {Bottom, Bottom, Bottom}
      }]
    ],

    Example[{Options, SolventAdditions, "No solvent is added during the first round and Organic solvent is added during the rest of the rounds if the input sample is biphasic, the target phase is aqueous, and we're doing negative selection (using the target phase in future rounds of extraction):"},
      ExperimentLiquidLiquidExtraction[
        {
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
        },
        SamplePhase->Biphasic,
        ExtractionTechnique->Pipette,
        SelectionStrategy->Negative,
        TargetPhase->Aqueous,
        Output -> Options
      ],
      KeyValuePattern[{
        SolventAdditions->{
          None,
          Model[Sample, "id:9RdZXvKBeeGK"],
          Model[Sample, "id:9RdZXvKBeeGK"]
        }
      }]
    ],
    Example[{Options, SolventAdditions, "No solvent is added during the first round and Aqueous solvent is added during the rest of the rounds if the input sample is biphasic, the target phase is organic, and we're doing negative selection (using the target phase in future rounds of extraction):"},
      ExperimentLiquidLiquidExtraction[
        {
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
        },
        SamplePhase->Biphasic,
        ExtractionTechnique->Pipette,
        SelectionStrategy->Negative,
        TargetPhase->Organic,
        Output -> Options
      ],
      KeyValuePattern[{
        SolventAdditions->{
          None,
          Model[Sample, "id:8qZ1VWNmdLBD"],
          Model[Sample, "id:8qZ1VWNmdLBD"]
        }
      }]
    ],
    Example[{Options, AqueousSolvent, "Aqueous solvent is not needed if the sample is aqueous, the target phase is aqueous, and we're doing negative selection (using the target phase in future rounds of extraction):"},
      ExperimentLiquidLiquidExtraction[
        {
          Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
        },
        ExtractionTechnique->PhaseSeparator,
        SelectionStrategy->Negative,
        TargetPhase->Aqueous,
        Output -> Options
      ],
      KeyValuePattern[{
        SolventAdditions->{{Model[Sample, "id:eGakld01zzXo"], Model[Sample, "id:eGakld01zzXo"], Model[Sample, "id:eGakld01zzXo"]}}
      }]
    ],
    Example[{Options, OrganicSolvent, "Only Organic solvent is needed if the sample is aqueous, the target phase is aqueous, and we're doing negative selection (using the target layer in future rounds of extraction):"},
      ExperimentLiquidLiquidExtraction[
        {
          Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
        },
        ExtractionTechnique -> PhaseSeparator,
        SelectionStrategy -> Negative,
        TargetPhase -> Aqueous,
        Output -> Options
      ],
      KeyValuePattern[{
        SolventAdditions->{{Model[Sample, "id:eGakld01zzXo"], Model[Sample, "id:eGakld01zzXo"], Model[Sample, "id:eGakld01zzXo"]}}
      }]
    ],
    Example[{Options, ExtractionMixVolume, "The ExtractionMixVolume is set to the lesser of 1/2 of the smallest extraction volume (the sample volume plus the volume of the added aqueous solvent, organic solvent, and demulsifier if specified) and 970 microliters:"},
      ExperimentLiquidLiquidExtraction[
        {
          Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
        },
        ExtractionMixType -> Pipette,
        OrganicSolventVolume -> 0.5 Milliliter,
        NumberOfExtractions -> 1,
        Output -> Options
      ],
      KeyValuePattern[{
        ExtractionMixVolume -> EqualP[0.5 Milliliter]
      }]
    ],
    Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared (robotic is implied):"},
      {options,result} = ExperimentLiquidLiquidExtraction[
        Model[Sample, "id:D8KAEvG0r7qL"](* Gram's Iodine Solution *),
        PreparedModelContainer -> Model[Container, Vessel, "id:bq9LA0dBGGR6"](* 50mL Tube *),
        PreparedModelAmount ->1 Milliliter,
        ExtractionTechnique -> PhaseSeparator,
        TargetPhase->Organic,
        Output ->{Options,Result}
      ];
      outputUOs = Download[result, OutputUnitOperations];
      robotUOs = Download[outputUOs[[1]], RoboticUnitOperations];
      prepUOs = Lookup[options, PreparatoryUnitOperations];
      {
        prepUOs[[-1, 1]][Sample],
        prepUOs[[-1, 1]][Container],
        prepUOs[[-1, 1]][Amount],
        prepUOs[[-1, 1]][Well],
        prepUOs[[-1, 1]][ContainerLabel],
        Download[outputUOs[[1]], SampleLink],
        robotUOs
      },
      {
        {ObjectP[Model[Sample, "id:D8KAEvG0r7qL"]]},
        {ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]},
        {EqualP[1 Milliliter]},
        {"A1"},
        {_String},
        {ObjectP[Model[Sample, "id:D8KAEvG0r7qL"]]},
        (* TODO update that these have everything we need *)
        {
          ObjectP[Object[UnitOperation, LabelSample]],
          ObjectP[Object[UnitOperation, LabelContainer]],
          ObjectP[Object[UnitOperation, LabelSample]],
          ObjectP[Object[UnitOperation, LabelContainer]],
          ObjectP[Object[UnitOperation, Transfer]],
          ObjectP[Object[UnitOperation, Mix]],
          ObjectP[Object[UnitOperation, Transfer]],
          ObjectP[Object[UnitOperation, Wait]],
          ObjectP[Object[UnitOperation, Transfer]],
          ObjectP[Object[UnitOperation, Mix]],
          ObjectP[Object[UnitOperation, Transfer]],
          ObjectP[Object[UnitOperation, Wait]],
          ObjectP[Object[UnitOperation, Transfer]],
          ObjectP[Object[UnitOperation, Mix]],
          ObjectP[Object[UnitOperation, Transfer]],
          ObjectP[Object[UnitOperation, Wait]],
          ObjectP[Object[UnitOperation, Transfer]],
          ObjectP[Object[UnitOperation, LabelSample]]
        }
      },
      Variables :> {options, prepUOs, result}
    ],
    Test["The ExtractionMixVolume is set to 970 microliters if 1/2 of the smallest extraction volume (the sample volume plus the volume of the added aqueous solvent, organic solvent, and demulsifier if specified) is greater than 970 microliters:",
      ExperimentLiquidLiquidExtraction[
        {
          Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID]
        },
        ExtractionMixType -> Pipette,
        OrganicSolventVolume -> 1.5 Milliliter,
        Output -> Options
      ],
      KeyValuePattern[{
        ExtractionMixVolume -> EqualP[970 Microliter]
      }]
    ]
  },
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects]
  ),
  SymbolSetUp :> Module[{existsFilter, tube0, tube1, tube2, tube3, tube4, tube5, tube6, tube7, sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7},
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Object[Sample, "Large Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
      Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
      Object[Sample, "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
      Object[Sample, "Sample in DMSO (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
      Object[Sample, "Sample with Water in Composition (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
      Object[Sample, "Sample with Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
      Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
      Object[Sample, "Sample with No Composition or Solvent Information (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 6 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 7 for ExperimentLiquidLiquidExtraction "<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Sample, "Large Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
          Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
          Object[Sample, "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
          Object[Sample, "Sample in DMSO (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
          Object[Sample, "Sample with Water in Composition (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
          Object[Sample, "Sample with Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
          Object[Sample, "Sample with No Composition or Solvent Information (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 6 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 7 for ExperimentLiquidLiquidExtraction "<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];


    {tube0, tube1, tube2, tube3, tube4, tube5, tube6, tube7} = Upload[{
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 0 for ExperimentLiquidLiquidExtraction "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 1 for ExperimentLiquidLiquidExtraction "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 2 for ExperimentLiquidLiquidExtraction "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 3 for ExperimentLiquidLiquidExtraction "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 4 for ExperimentLiquidLiquidExtraction "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 5 for ExperimentLiquidLiquidExtraction "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 6 for ExperimentLiquidLiquidExtraction "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 7 for ExperimentLiquidLiquidExtraction "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>
    }];

    (* Create some samples for testing purposes *)
    {sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7} = UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Water"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Water"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Ethyl acetate"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Dimethyl sulfoxide"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Water"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Ethyl acetate"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {35 VolumePercent, Model[Molecule, "Water"]}, {65 VolumePercent, Model[Molecule, "Ethyl acetate"]}},
        {{Null, Null}}
      },
      {
        {"A1", tube0},
        {"A1", tube1},
        {"A1", tube2},
        {"A1", tube3},
        {"A1", tube4},
        {"A1", tube5},
        {"A1", tube6},
        {"A1", tube7}
      },
      Name -> {
        "Large Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID,
        "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID,
        "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID,
        "Sample in DMSO (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID,
        "Sample with Water in Composition (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID,
        "Sample with Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID,
        "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID,
        "Sample with No Composition or Solvent Information (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID
      },
      InitialAmount -> {
        10 Milliliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter
      },
      State -> Liquid,
      FastTrack -> True
    ];

    (* Make some changes to our samples for testing purposes *)
    Upload[<|Object -> #, Status -> Available, DeveloperObject -> True|>& /@ {sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7}];

    Upload[{
      <|
        Object -> sample2,
        Solvent -> Link[Model[Sample, "Ethyl acetate, Reagent Grade"]]
      |>,
      <|
        Object -> sample3,
        Solvent -> Link[Model[Sample, "DMSO, anhydrous"]]
      |>,
      <|
        Object -> sample4,
        Solvent -> Null
      |>,
      <|
        Object -> sample5,
        Solvent -> Null
      |>,
      <|
        Object -> sample6,
        Solvent -> Null
      |>
    }];
  ],

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects, existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects= Cases[Flatten[{
        Object[Sample, "Large Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
        Object[Sample, "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
        Object[Sample, "Sample in DMSO (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
        Object[Sample, "Sample with Water in Composition (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
        Object[Sample, "Sample with Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
        Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
        Object[Sample, "Sample with No Composition or Solvent Information (Test for ExperimentLiquidLiquidExtraction) "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 6 for ExperimentLiquidLiquidExtraction "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 7 for ExperimentLiquidLiquidExtraction "<>$SessionUUID]
      }], ObjectP[]];

      (* Erase any objects that we failed to erase in the last unit test *)
      existsFilter=DatabaseMemberQ[allObjects];

      Quiet[EraseObject[
        PickList[
          allObjects,
          existsFilter
        ],
        Force->True,
        Verbose->False
      ]];
    ]
  ),
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  }
];

(* ::Subsubsection:: *)
(*LiquidLiquidExtraction *)

DefineTests[
  LiquidLiquidExtraction,
  {
    Example[{Basic,"Placeholder test for LiquidLiquidExtraction:"},
      True,
      True
    ]
  }
];
