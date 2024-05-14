(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotBioLayerInterferometry*)

DefineOptions[PlotBioLayerInterferometry,
  Options:>{
    {
      OptionName ->Channels,
      Default -> Null,
      Description -> "Select specific channels for which the entirety of the assay will be plotted.",
      Category -> "General",
      AllowNull -> True,
      Widget -> Alternatives[
        "All or None" -> Widget[Type -> Enumeration, Pattern :> Alternatives[All, Null]],
        "Select Channels" -> Adder[Widget[Type -> Number, Pattern:>RangeP[1,8,1]]]
      ]
    }
  },
  (*TODO: modify the PlotLabel and Legend to be automatic*)
  SharedOptions:>{
    EmeraldListLinePlot
  }
];

Error::MixedBLIPlotDataTypes="The data objects have different types: `1`";
Error::BLIPlotTooManyRequestedChannels = "When Channels is specified, the input must be a single data object.";
Error::NoBLIDataToPlot = "The protocol object does not contain any association bio layer interferometry data.";

(* protocol overload *)
PlotBioLayerInterferometry[
  obj:ObjectP[Object[Protocol,BioLayerInterferometry]],
  ops:OptionsPattern[PlotBioLayerInterferometry]
]:= Module[{data},
  data = Download[obj, Data];

  If[MatchQ[data, {ObjectP[Object[Data, BioLayerInterferometry]]..}],
    PlotBioLayerInterferometry[data, ops],
    Message[Error::NoBLIDataToPlot];
    $Failed
  ]
];

(* singleton overload *)
PlotBioLayerInterferometry[
  obj:ObjectP[Object[Data,BioLayerInterferometry]],
  ops:OptionsPattern[PlotBioLayerInterferometry]
]:= PlotBioLayerInterferometry[{obj}, ops];

(*Function for plotting unanalyzed BLI data objects*)
PlotBioLayerInterferometry[
  obj:{ObjectP[Object[Data,BioLayerInterferometry]]..},
  ops:OptionsPattern[PlotBioLayerInterferometry]
]:=Module[{packet, dataType, safeDataType, safeKineticsData, safeQuantitationData, kineticsAssociationData, kineticsDissociationData,
  competitionData, competingSolutions, wellData, wellInformation, requestedChannels, channelDataToPlot, samplesIn, listOps, safeOptions,
  safeOptionTests, plotOptions, fieldsToDownload, allOptions, output, plot, resolvedOptions,
  resolvedPlotLabel, resolvedFrameLabel, resolvedLegend,
  stepsPerAssay, numberOfAssays, cleanedChannelData, groupedChannelData,
  assayGroupedChannelData, channelLegend,channelToolTips},

  (* make the options a list *)
  listOps = ToList[ops];

  (* Call SafeOptions to make sure all options match pattern - dont gather tests *)
  {safeOptions, safeOptionTests} = {SafeOptions[PlotBioLayerInterferometry, listOps, AutoCorrect -> False], Null};

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=outputSpecification;

  (* remove the channel option for pass through options to EmeraldListLinePlot *)
  plotOptions = DeleteCases[safeOptions, Channels->_];

  (* download all the fields that have data in them *)
  fieldsToDownload = Packet[
    DataType, KineticsAssociation, KineticsDissociation, QuantitationAnalyteDetection,
    WellInformation, WellData, SamplesIn, MeasuredWellPositions, CompetingSolutions, CompetitionData
  ];

  (* download the fields that have data in them *)
  packet = Download[
    obj,
    fieldsToDownload,
    Date->Now
  ];

  (* lookup the dataTypes and the data to plot *)
  {
    dataType,
    samplesIn,
    kineticsAssociationData,
    kineticsDissociationData,
    safeQuantitationData,
    competitionData,
    competingSolutions,
    wellData,
    wellInformation
  } = Transpose[
    Lookup[packet,
      {
        DataType,
        SamplesIn,
        KineticsAssociation,
        KineticsDissociation,
        QuantitationAnalyteDetection,
        CompetitionData,
        CompetingSolutions,
        WellData,
        WellInformation
      }
    ]
  ];

  (* determine the data type *)
  safeDataType = DeleteDuplicates[dataType];

  (* if theres multiple data types just exit *)
  If[MatchQ[Length[safeDataType], GreaterP[1]],
    Message[Error::MixedBLIPlotDataTypes, dataType];
    Return[$Failed],
    Null
  ];

  (* if we are plotting all steps, grab those *)
  requestedChannels = Lookup[safeOptions, Channels];

  (* if theres multiple objects, exit if they want look at channels *)
  If[MatchQ[Length[obj], GreaterP[1]]&&MatchQ[requestedChannels, Except[Null]],
    Message[Error::BLIPlotTooManyRequestedChannels];
    Return[$Failed],
    Null
  ];

  (* determine the channels that we want to plot *)
  channelDataToPlot = Flatten[
    MapThread[
      Function[{data, info},
        Which[
          MatchQ[requestedChannels, Null],
          {},

          MatchQ[requestedChannels, All],
          Map[PickList[data, info, {_,_,_,#,_,_}]&,Range[8]],

          MatchQ[requestedChannels, {_Integer..}],
          Map[PickList[data, info, {_,_,_,#,_,_}]&, requestedChannels]
        ]
      ],
      {wellData, wellInformation}
    ],
    1
  ];

  (* determine how many to partition based on the numebr of steps per assay *)
  stepsPerAssay = Max[wellInformation[[1, All,2]]];
  numberOfAssays = Max[wellInformation[[1, All,1]]];

  (*Return[channelDataToPlot];*)
  (* clean up the channel data and group it for better visibility *)
  (*note that we ned ot partition with UpTo since in pre-condition cases the last one will be shorter than the others*)
  If[MatchQ[channelDataToPlot, Except[{}]],
    cleanedChannelData = Flatten[Partition[#, UpTo[stepsPerAssay]]&/@channelDataToPlot,1];
    groupedChannelData = Join@@#&/@cleanedChannelData;

    (*regroup these by number of assays*)
    assayGroupedChannelData = Partition[groupedChannelData, numberOfAssays];

    (* make the legend *)
    channelLegend = ("Channel "<>ToString[#])&/@(requestedChannels/.{All -> Range[8], Null -> {}});

    (* make the tootip *)
    channelToolTips = Map[Table[# <> ": Assay " <> ToString[x], {x, 1, numberOfAssays}]&, channelLegend];
  ];



  (* clean up the kinetics data *)
  safeKineticsData = MapThread[
    If[MemberQ[{#1, #2}, Null],

      (* if one of these is missing just remove it *)
      DeleteCases[{#1, #2}, Null],

      (* pair up the dissociation adn associaiton data *)
      Join/@Transpose[{#1, #2}]
    ]&,
    {kineticsAssociationData, kineticsDissociationData}
  ];

  (* resolve the plot options based on the option type *)
  resolvedFrameLabel = Lookup[plotOptions, FrameLabel]/.Automatic -> {"Time (Seconds)","Biolayer Thickness (Nanometers)"};

  (* resolve the legend to interpret the plot *)
  resolvedLegend = Which[
    MatchQ[requestedChannels, Null]&&MatchQ[First[safeDataType], Quantitation],
    Lookup[plotOptions, Legend]/.{Automatic -> (ToString[First[#]]&/@Download[samplesIn, Object])},

    MatchQ[requestedChannels, Null]&&MatchQ[First[safeDataType], EpitopeBinning],
    Lookup[plotOptions, Legend]/.{Automatic -> Download[competingSolutions,ID]},

    MatchQ[requestedChannels, Except[Null]],
    Lookup[plotOptions, Legend]/.{Automatic -> Map["Channel "<>ToString[#]&, (requestedChannels/.All->Range[8])]},

    True,
    Null
  ];

  (* resolve the plot label to somethign informative *)
  resolvedPlotLabel = Which[
    MatchQ[requestedChannels, Null]&&MatchQ[First[safeDataType], Kinetics],
    Lookup[plotOptions, PlotLabel]/.{Automatic -> "Kinetic binding traces"},

    MatchQ[requestedChannels, Null]&&MatchQ[First[safeDataType], Quantitation],
    Lookup[plotOptions, PlotLabel]/.{Automatic -> "Quantitation binding traces"},

    MatchQ[requestedChannels, Null]&&MatchQ[First[safeDataType], EpitopeBinning],
    Lookup[plotOptions, PlotLabel]/.{Automatic -> "Competition with bound species: " <> Download[samplesIn, ID]},

    MatchQ[requestedChannels, Except[Null]],
    Lookup[plotOptions, PlotLabel]/.{Automatic -> "Data from channels: "<>ToString[requestedChannels]},

    True,
    Null
  ];



  (* output the plots *)
  {plot, resolvedOptions} = If[MatchQ[requestedChannels, Null],

    (* plot based on the data type *)
    Which[

      (* since Kinetics may generate multiple plots, need to transpose *)
      MatchQ[First[safeDataType], Kinetics],
      Transpose[
        Map[
          EmeraldListLinePlot[
            #,
            Sequence@@ReplaceRule[
              plotOptions,
              {Output -> {Result, Options},
                PlotLabel -> resolvedPlotLabel,
                Legend ->resolvedLegend,
                FrameLabel->resolvedFrameLabel
              }
            ]
          ]&,
          safeKineticsData
        ]
      ],

      MatchQ[First[safeDataType], Quantitation],
      EmeraldListLinePlot[
        safeQuantitationData,
        Sequence@@ReplaceRule[
          plotOptions,
          {Output -> {Result, Options},
            PlotLabel -> resolvedPlotLabel,
            Legend ->resolvedLegend,
            FrameLabel->resolvedFrameLabel
          }
        ]
      ],

      MatchQ[First[safeDataType], EpitopeBinning],
      EmeraldListLinePlot[
        competitionData,
        Sequence@@ReplaceRule[
          plotOptions,
          {Output -> {Result, Options},
            PlotLabel -> resolvedPlotLabel,
            Legend ->resolvedLegend,
            FrameLabel->resolvedFrameLabel
          }
        ]
      ],

      MatchQ[First[safeDataType], Development],
      {"Development plot not currently available", plotOptions}
    ],

    (* give the more general raw data plot *)
    EmeraldListLinePlot[
      assayGroupedChannelData,
      Sequence@@ReplaceRule[
        plotOptions,
        {Output -> {Result, Options},
          Tooltip -> channelToolTips,
          PlotLabel -> resolvedPlotLabel,
          Legend ->resolvedLegend,
          FrameLabel->resolvedFrameLabel
        }
      ]
    ]
  ];


  (* collect the resolved plot options - not that Kinetics plots should all resolve the same, so just grab the first instance *)
  allOptions = If[MatchQ[First[safeDataType], Kinetics]&&MatchQ[requestedChannels, Null],
    ReplaceRule[First[resolvedOptions], {Output -> output, Channels -> requestedChannels}],
    ReplaceRule[resolvedOptions, {Output -> output, Channels -> requestedChannels}]
  ];

  (*output*)
  output/.{
    Result->plot,
    Options->RemoveHiddenOptions[PlotBioLayerInterferometry, allOptions],
    Preview->plot,
    Tests->{}
  }
];
