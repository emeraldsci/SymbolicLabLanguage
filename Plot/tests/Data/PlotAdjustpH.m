(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: XuYi *)
(* :Date: 2025-02-12 *)

(* ::Subsection:: *)
(*PlotAdjustpH*)


DefineTests[PlotAdjustpH,
  {
    Example[
      {Basic,"Plots pH adjustment data when given a pHAdjustment data object:"},
      PlotAdjustpH[Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"]],
      ValidGraphicsP[],
      TimeConstraint->120
    ],
    Test[
      "Given a packet:",
      PlotAdjustpH[Download[Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"]]],
      ValidGraphicsP[],
      TimeConstraint->120
    ],
    Example[
      {Basic,"Plots pH adjustment data when given a pHAdjustment data link:"},
      PlotAdjustpH[Link[Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"],Protocol]],
      ValidGraphicsP[],
      TimeConstraint->120
    ],
    Example[
      {Basic,"Plots pH Adjustment data when given an AdjustpH protocol object:"},
      PlotAdjustpH[Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"][Protocol]],
      SlideView[{ValidGraphicsP[] ..}],
      TimeConstraint->120
    ],

    Example[
      {Basic,"Plots of multiple data objects:"},
      PlotAdjustpH[
        {Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"], Object[Data, pHAdjustment, "id:eGakldenwL4e"], Object[Data, pHAdjustment, "id:01G6nvDDVR1A"]}
      ],
      SlideView[{ValidGraphicsP[]..}],
      TimeConstraint->120
    ],
    Example[
      {Options,Cycles,"Set Cycle->Span to plot only specified cycles of titration:"},
      PlotAdjustpH[
        {Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"], Object[Data, pHAdjustment, "id:eGakldenwL4e"], Object[Data, pHAdjustment, "id:01G6nvDDVR1A"]},
        Cycles -> Span[1, 3]
      ],
      SlideView[{ValidGraphicsP[]..}],
      TimeConstraint->120
    ],
    Example[
      {Options,TargetpH,"Set TargetpH to be False to turn off the target pH line:"},
      PlotAdjustpH[Object[Data, pHAdjustment, "id:eGakldenwL4e"], TargetpH -> False],
      ValidGraphicsP[],
      TimeConstraint->120
    ],
    Example[
      {Options,Display,"Generate a plot with Acid and Base addition volume displayed:"},
      PlotAdjustpH[{Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"],Object[Data, pHAdjustment, "id:eGakldenwL4e"]}, Display -> AcidAndBaseAddition],
      SlideView[{ValidGraphicsP[]..}],
      TimeConstraint->120
    ],
    Example[
      {Options,Display,"Generate a plot with pH value displayed:"},
      PlotAdjustpH[{Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"],Object[Data, pHAdjustment, "id:eGakldenwL4e"]}, Display -> pH],
      SlideView[{ValidGraphicsP[]..}],
      TimeConstraint->120
    ],
    Example[
      {Options,Display,"Generate a plot with no marker displayed:"},
      PlotAdjustpH[{Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"],Object[Data, pHAdjustment, "id:eGakldenwL4e"]}, Display -> Null],
      SlideView[{ValidGraphicsP[]..}],
      TimeConstraint->120
    ],
    Example[
      {Options,Tooltip,"Generate a plot with point makers shown with toop tip:"},
      PlotAdjustpH[Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"],Tooltip-> True],
      ValidGraphicsP[],
      TimeConstraint->120
    ],
    Example[
      {Options,Tooltip,"Generate a plot with point makers shown with toop tip:"},
      PlotAdjustpH[Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"],Display -> Null, Tooltip-> True],
      ValidGraphicsP[],
      TimeConstraint->120
    ],

    Example[{Messages,"pHAdjustmentDataNotPlotted","If the pHAdjustmentData of the AdjustpH protocol does not contain valid pHLog, return an error:"},
      PlotAdjustpH[Object[Protocol, AdjustpH, "AdjustpH Protocol 1 For PlotAdjustpH Test " <> $SessionUUID]],
      $Failed,
      Messages:>{PlotAdjustpH::pHAdjustmentDataNotPlotted}
    ],

    Example[{Messages,"pHAdjustmentDataNotPlotted","If the pHAdjustmentData does not contain valid pHLog, return an error:"},
      PlotAdjustpH[Object[Data, pHAdjustment, "pHAdjustment Data For PlotAdjustpH Test " <> $SessionUUID]],
      $Failed,
      Messages:>{PlotAdjustpH::pHAdjustmentDataNotPlotted}
    ],

    Example[{Messages,"NoAdjustpHDataToPlot","If the AdjustpH protocol does not contain any pHAdjustment object, return an error:"},
      PlotAdjustpH[Object[Protocol, AdjustpH, "AdjustpH Protocol 2 For PlotAdjustpH Test " <> $SessionUUID]],
      $Failed,
      Messages:>{PlotAdjustpH::NoAdjustpHDataToPlot}
    ],

    Example[{Messages,"pHAdjustmentSampleMissing","If the pHAdjustmentData is missing sample object, return an error:"},
      PlotAdjustpH[Object[Data, pHAdjustment, "pHAdjustment Data For PlotAdjustpH Test " <> $SessionUUID]],
      $Failed,
      Messages:>{PlotAdjustpH::pHAdjustmentSampleMissing},
      SetUp :> {
        Upload[<|
          Object -> Object[Data, pHAdjustment, "pHAdjustment Data For PlotAdjustpH Test " <> $SessionUUID],
          Replace[SamplesIn] -> {}
        |>]
      },
      TearDown :> {
        Upload[<|
          Object -> Object[Data, pHAdjustment, "pHAdjustment Data For PlotAdjustpH Test " <> $SessionUUID],
          Replace[SamplesIn] -> {Link[Object[Sample, "pHAdjustment SamplesIn For PlotAdjustpH Test " <> $SessionUUID], Data]}
        |>]
      }
    ],

    Example[{Messages,"pHAdjustmentTargetpHMissing","If the pHAdjustmentData is missing nominal pH, return an error:"},
      PlotAdjustpH[Object[Data, pHAdjustment, "pHAdjustment Data For PlotAdjustpH Test " <> $SessionUUID]],
      $Failed,
      Messages:>{PlotAdjustpH::pHAdjustmentTargetpHMissing},
      SetUp :> {
        Upload[<|
          Object -> Object[Data, pHAdjustment, "pHAdjustment Data For PlotAdjustpH Test " <> $SessionUUID],
          NominalpH -> Null
        |>]
      },
      TearDown :> {
        Upload[<|
          Object -> Object[Data, pHAdjustment, "pHAdjustment Data For PlotAdjustpH Test " <> $SessionUUID],
          NominalpH -> 7
        |>]
      }
    ],

    (* Output tests *)
    Test[
      "Setting Output to Result returns the plot:",
      PlotAdjustpH[Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"],Output->Result],
      ValidGraphicsP[],
      TimeConstraint->120
    ],

    Test[
      "Setting Output to Preview returns the plot:",
      PlotAdjustpH[Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"],Output->Preview],
      {ValidGraphicsP[]..},
      TimeConstraint->120
    ],

    Test[
      "Setting Output to Options returns the resolved options:",
      PlotAdjustpH[Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"],Output->Options],
      ops_/;MatchQ[ops,OptionsPattern[PlotAdjustpH]],
      TimeConstraint->120
    ],

    Test[
      "Setting Output to Tests returns a list of tests:",
      PlotAdjustpH[Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"],Output->Tests],
      {(_EmeraldTest|_Example)...},
      TimeConstraint->120
    ],

    Test[
      "Setting Output to {Result,Options} returns the plot along with all resolved options for data object input:",
      PlotAdjustpH[Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"],Output->{Result,Options}],
      output_List/;MatchQ[First@output,ValidGraphicsP[]]&&MatchQ[Last@output,OptionsPattern[PlotAdjustpH]]
    ],

    Test[
      "Setting Output to Options returns all of the defined options:",
      Sort@Keys@PlotAdjustpH[Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"],Output->Options],
      Sort@Keys@SafeOptions@PlotAdjustpH,
      TimeConstraint->120
    ]
  },
  Variables:>{dynamicSample},
  SetUp:>(
    dynamicSample={
      Object[Data, pHAdjustment, "id:R8e1PjBmzp1v"],
      Object[Data, pHAdjustment, "id:eGakldenwL4e"],
      Object[Data, pHAdjustment, "id:01G6nvDDVR1A"]
    };
  ),
  SymbolSetUp :> (

    $CreatedObjects={};

    (* Gather and erase all pre-existing objects created in SymbolSetUp *)
    Module[
      {
        allObjects, existingObjects, protocol1, protocol2, data1, model1, model2, object1
      },

      (* All data objects generated for unit tests *)

      allObjects=
          {
            Object[Protocol, AdjustpH, "AdjustpH Protocol 1 For PlotAdjustpH Test " <> $SessionUUID],
            Object[Protocol, AdjustpH, "AdjustpH Protocol 2 For PlotAdjustpH Test " <> $SessionUUID],
            Object[Data, pHAdjustment, "pHAdjustment Data For PlotAdjustpH Test " <> $SessionUUID],
            Object[Sample, "pHAdjustment SamplesIn For PlotAdjustpH Test " <> $SessionUUID]
          };

      (* Check whether the names we want to give below already exist in the database *)
      existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

      (* Erase any test objects and models that we failed to erase in the last unit test *)
      Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

      {protocol1, protocol2, data1, model1, model2, object1} = CreateID[{
          Object[Protocol, AdjustpH],
          Object[Protocol, AdjustpH],
          Object[Data, pHAdjustment],
          Model[Sample],
          Model[Sample],
          Object[Sample]
        }];

      Upload[
        <|
          Name -> "pHAdjustment Data For PlotAdjustpH Test " <> $SessionUUID,
          Object -> data1,
          Type -> Object[Data, pHAdjustment],
          TitratingAcidModel -> Link[model1],
          TitratingBaseModel -> Link[model2],
          NominalpH -> 7,
          Replace[SamplesIn] -> {Link[object1, Data]}
        |>
      ];
      Upload[
        <|
          Name -> "AdjustpH Protocol 1 For PlotAdjustpH Test " <> $SessionUUID,
          Object -> protocol1,
          Type -> Object[Protocol, AdjustpH],
          Replace[Data] -> {Link[data1, Protocol]}
        |>
      ];
      Upload[
        <|
          Name -> "AdjustpH Protocol 2 For PlotAdjustpH Test " <> $SessionUUID,
          Object -> protocol2,
          Type -> Object[Protocol, AdjustpH]
        |>
      ];
      Upload[
        <|
          Name -> "pHAdjustment SamplesIn For PlotAdjustpH Test " <> $SessionUUID,
          Object -> object1,
          Type -> Object[Sample]
        |>
      ]
    ];
  ),
  SymbolTearDown :> Module[{objects},
    objects = {
      Object[Protocol, AdjustpH, "AdjustpH Protocol 1 For PlotAdjustpH Test " <> $SessionUUID],
      Object[Protocol, AdjustpH, "AdjustpH Protocol 2 For PlotAdjustpH Test " <> $SessionUUID],
      Object[Data, pHAdjustment, "pHAdjustment Data For PlotAdjustpH Test " <> $SessionUUID],
      Object[Sample, "pHAdjustment SamplesIn For PlotAdjustpH Test " <> $SessionUUID]
    };

    EraseObject[
      PickList[objects,DatabaseMemberQ[objects],True],
      Verbose->False,
      Force->True
    ]
  ]
];
