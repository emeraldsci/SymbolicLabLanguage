(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: xu.yi *)
(* :Date: 2025-01-28 *)


(* ::Subsection:: *)
(*PlotAdjustpH*)


DefineOptions[PlotAdjustpH,
    Options:>{
      {
        OptionName->Display,
        Default->AcidAndBaseAddition,
        AllowNull->True,
        Description->"Indicates if the acid/base addition or the pH will be displayed on the plot.",
        Widget->Widget[Type->Enumeration,Pattern :> AcidAndBaseAddition|pH],
        Category->"Plot Style"
      },
      {
        OptionName->Tooltip,
        Default->False,
        AllowNull->False,
        Description->"Indicates if addition volume or pH value will be displayed with tooltip.",
        Widget->Widget[Type->Enumeration,Pattern :> BooleanP],
        Category->"Plot Style"
      },
      {
        OptionName->TargetpH,
        Default->True,
        AllowNull->False,
        Description->"Indicates if target pH will be displayed on the plot.",
        Widget->Widget[Type->Enumeration,Pattern :> BooleanP],
        Category->"Plot Style"
      },
      {
        OptionName->Cycles,
        Default->All,
        AllowNull->False,
        Description->"Indicates the cycles of titration that will be displayed on the plot.",
        Widget->Alternatives[
          Span[
            Widget[Type->Number, Pattern:>GreaterP[0,1]],
            Widget[Type->Number, Pattern:>GreaterP[0,1]]
          ],
          Widget[Type->Enumeration,Pattern:>Alternatives[All]]
        ],
        Category->"Plot Style"
      },
      OutputOption,
      CacheOption
    }
];


(* ::Subsection::Closed:: *)
(*Messages*)

PlotAdjustpH::NoAdjustpHDataToPlot = "The protocol object does not contain any associated pH Adjustment data.";
PlotAdjustpH::pHAdjustmentDataNotPlotted = "The data objects were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted.";
PlotAdjustpH::pHAdjustmentSampleMissing = "The data object cannot be plotted because sample object is missing.";
PlotAdjustpH::pHAdjustmentTargetpHMissing = "The data object cannot be plotted because nominal pH is missing.";

(* protocol overload *)
PlotAdjustpH[
  obj:ObjectP[Object[Protocol,AdjustpH]],
  ops:OptionsPattern[PlotAdjustpH]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

  (* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
  safeOps=SafeOptions[PlotAdjustpH, ToList[ops]];

  (* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
  output = ToList[Lookup[safeOps, Output]];

  (* Download the data from the input protocol *)
  (* Only take Object[Data, pHAdjustment]. Robotic AdjustpH protocols will contain Object[Data, pH], too *)
  data = Cases[Download[obj, Data], ObjectP[Object[Data, pHAdjustment]]];

  (* Return an error if there is no data or it is not the correct data type *)
  If[!MatchQ[data, {ObjectP[Object[Data, pHAdjustment]]..}],
    Message[PlotAdjustpH::NoAdjustpHDataToPlot];
    Return[$Failed]
  ];

  (* If Preview is requested, return a list of plots with all of the data objects in the protocol *)
  previewPlot = If[MemberQ[output, Preview],
    PlotAdjustpH[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
    Null
  ];
  (* If Options is requested, only call data overload once since our options will be the same no matter how many samples *)
  resolvedOptions = If[MemberQ[output, Options],
    PlotAdjustpH[data, Sequence @@ ReplaceRule[safeOps, Output -> Options]],
    Null
  ];

  (* If either Result is requested, map over the data objects.*)
  plots = If[MemberQ[output, Result],
    PlotAdjustpH[#, Sequence @@ ReplaceRule[safeOps, Output -> Result]]& /@ data,
    {}
  ];

  (* If all of the data objects failed to plot, return an error *)
  If[MatchQ[plots, (ListableP[{}] | ListableP[$Failed])] && MatchQ[previewPlot, (Null | $Failed)] && MatchQ[resolvedOptions, (Null | $Failed)],
    Return[$Failed],
    Nothing
  ];

  (* If Result was requested, output the plots in slide view, unless there is only one plot then we can just show it not in slide view. *)
  outputPlot = If[MemberQ[output, Result],
    If[Length[plots] > 1,
      SlideView[plots],
      First[plots]
    ]
  ];

  (* If Options were requested, return the resolved options. *)
  outputOptions = If[MemberQ[output, Options],
    Flatten[ToList[resolvedOptions]]
  ];

  (* Prepare our final result *)
  finalResult = output /. {
    Result -> outputPlot,
    Options -> outputOptions,
    Preview -> previewPlot,
    Tests -> {}
  };

  (* Return the result *)
  If[
    Length[finalResult] == 1,
    First[finalResult],
    finalResult
  ]
];

PlotAdjustpH[input:ListableP[ObjectP[Object[Data,pHAdjustment]]],inputOptions:OptionsPattern[]]:=Module[
  {
    listedOptions,outputSpecification,output,gatherTests,outputOptions,safeOptions,safeOptionTests,dataObjects,rawPackets, nominalpHs, acidModels, baseModels, rawpHLogs, logpHs, pHPackets, acidNamePackets, baseNamePackets, logAdditionAmountsPre, logAdditionModelsPre, adjustpHPlots, logAdditionModels, logAdditionAmounts, requestedCycles, requestedTargetpH, requestedDisplay, requestedTooltip, fullOptions, finalResult, outputPlot, outputOption, samplesIn
  },

  (* Make sure we're working with a list of options *)
  listedOptions = ToList[inputOptions];

  (* Determine the requested return value from the function *)
  outputSpecification = OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output, Tests];

  (* Determine if we should output the resolved options *)
  outputOptions = MemberQ[output, Options];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOptions,safeOptionTests}=If[gatherTests,
    SafeOptions[PlotAdjustpH,listedOptions,Output->{Result,Tests},AutoCorrect->False],
    {SafeOptions[PlotAdjustpH,listedOptions,AutoCorrect->False],Null}
  ];

  If[MatchQ[safeOptions,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOptionTests,
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  dataObjects = ToList[input];

  requestedCycles = Lookup[safeOptions, Cycles];
  requestedTooltip = Lookup[safeOptions, Tooltip];
  requestedTargetpH = Lookup[safeOptions, TargetpH];
  requestedDisplay = Lookup[safeOptions, Display];

  (* Quiet MissingField error since raw data will be put in a packet which will not necessarily have all these fields *)
  rawPackets =Quiet[
    Download[
      dataObjects,
      {
        Packet[SamplesIn, NominalpH, TitratingAcidModel, TitratingBaseModel, pHLog, pHAchieved, pH],
        Packet[TitratingAcidModel[Name]],
        Packet[TitratingBaseModel[Name]],
        SamplesIn[Object]
      }
    ],
    Download::MissingField
  ];

  pHPackets = rawPackets[[All, 1]];
  acidNamePackets = rawPackets[[All, 2]];
  baseNamePackets = rawPackets[[All, 3]];
  samplesIn = rawPackets[[All, 4]];

  (* Extract the fields of data object *)
  {nominalpHs, acidModels, baseModels, rawpHLogs} = Transpose@Lookup[pHPackets, {NominalpH, TitratingAcidModel, TitratingBaseModel, pHLog}];

  (* If SamplesIn is missing, return an error *)
  If[!MatchQ[samplesIn, ListableP[{ObjectP[]}]],
    Message[PlotAdjustpH::pHAdjustmentSampleMissing];
    Return[$Failed]
  ];
  (* If nominalpH is missing, return an error *)
  If[!MatchQ[nominalpHs, ListableP[_?NumericQ]],
    Message[PlotAdjustpH::pHAdjustmentTargetpHMissing];
    Return[$Failed]
  ];
  (* If no pH log found in the pHAdjustment object, return empty list since there is nothing to plot *)
  If[MatchQ[rawpHLogs, (ListableP[{}] | ListableP[Null])],
    Message[PlotAdjustpH::pHAdjustmentDataNotPlotted];
    Return[$Failed]
  ];

  (* pHLog of Object[Data, pHAdjustment] contains both pHLog and TransfersIn *)
  (* The pHLog of Object[Data, pHAdjustment] is "A record of the sample(s) added during pH adjustment and their effect on the pH" --{"Addition Model","Addition Sample", "Amount", "pH","pH Data"} *)
  logpHs = rawpHLogs[[All, requestedCycles, 4]];
  logAdditionAmountsPre = rawpHLogs[[All, requestedCycles, 3]];
  logAdditionModelsPre = rawpHLogs[[All, requestedCycles, 1]];

  (* In PlotAdjustpH, we plot the pH in points with arrows showing NEXT addition, so need to modify the order of additions to match with pH index *)
  logAdditionAmounts = Append[Rest[#], 0 Milliliter]&/@logAdditionAmountsPre;
  logAdditionModels = Append[Rest[#], Null]&/@logAdditionModelsPre;

  adjustpHPlots = MapThread[
    Function[{logAdditionModel, logAdditionAmount, logpH, nominalpH, sample},
      Module[{cycleNumbers, additionTuples, additionSplitTuples, arrowStart, updatedArrowStart, arrowSize, updatedArrowSize, arrowEnd, arrow, plotRange, cycleRange, plottingContents, labeling, legendPositionX, legendPositionY, cycleFrame,  cycleFrameStyle},
        cycleNumbers = If[MatchQ[requestedCycles, All],
          Range[Length[logpH]],
          Range[requestedCycles[[1]], requestedCycles[[-1]], 1]
        ];
        (* create tuples and split into three groups: 1. Acid additions; 2. Base additions 3. No addition *)
        additionTuples = Transpose[{Download[logAdditionModel, Object], cycleNumbers, logpH, logAdditionAmount}];
        additionSplitTuples = GatherBy[additionTuples, First];

        (* The arrow starting point is the pH data point*)
        arrowStart = #[[All, 2;;3]] & /@ additionSplitTuples;
        (* Flatten the list so the updatedArrowStart is a list of {cycleNumber, pHValue} in the order of acid addition, base addition, no addition *)
        updatedArrowStart = Flatten[arrowStart, 1];
        arrowSize = Unitless[#[[All, 4]] & /@ additionSplitTuples, 0.01 Milliliter];
        updatedArrowSize =Switch[Length[arrowSize],
          (* If we add both acid and base, there will be three sub groups *)
          3,
          Join[-arrowSize[[1]]-0.3, arrowSize[[2]]+0.3, arrowSize[[3]]],
          (* If we add only acid or base, there will be two sub groups *)
          2,
          If[logpH[[1]] > nominalpH,
            (* Only add acid *)
            Join[-arrowSize[[1]]-0.3, arrowSize[[2]]],
            (* Only add base *)
            Join[arrowSize[[1]]+0.3, arrowSize[[2]]]
          ],
          (* If we did not make any addition, there will be only one sub group *)
          1,
          arrowSize[[1]]
        ];
        arrowEnd = Transpose[{updatedArrowStart[[All, 1]], updatedArrowStart[[All, 2]] + updatedArrowSize}];
        arrow = Transpose[{updatedArrowStart, arrowEnd}];

        (* define the Y positions of legend *)
        legendPositionY = Max[logpH] + 1;
        (* define an increment to determine the legend position on x axis so it won't look weird when number of cycles is too large or small *)
        legendPositionX =  0.1 * Last[cycleNumbers];

        (* define the x, y ranges *)
        plotRange = {Min[logpH] - 2, Max[logpH] + 2};
        cycleRange = {First[cycleNumbers] - legendPositionX, Last[cycleNumbers] + 6 * legendPositionX};

        plottingContents = Switch[{requestedDisplay, requestedTooltip},
          (* addition volume *)
          {AcidAndBaseAddition, False},
          Labeled[
            additionTuples[[All, 2;;3]],
            additionTuples[[All, 4]],
            additionTuples[[All, 2;;3]],
            LabelStyle -> Directive[RGBColor["#4E65FF"], 7, Bold],
            Background -> None
          ],
          {AcidAndBaseAddition, True},
          additionTuples[[All, 2 ;; 3]] -> additionTuples[[All, 4]],
          (* pH *)
          {pH, False},
          Labeled[
            additionTuples[[All, 2;;3]],
            additionTuples[[All, 3]],
            additionTuples[[All, 2;;3]],
            LabelStyle -> Directive[RGBColor["#49B37E"], 8],
            Background -> None
          ],
          {pH, True},
          additionTuples[[All, 2 ;; 3]] -> additionTuples[[All, 3]],
          (* No marker *)
          {Null, _},
          additionTuples[[All, 2 ;; 3]]
        ];
        (* tooltip *)
        labeling =Switch[{requestedDisplay, requestedTooltip},
          {AcidAndBaseAddition, False},
          None,
          {AcidAndBaseAddition, True},
          Tooltip,
          {pH, False},
          None,
          {pH, True},
          Tooltip,
          {Null, _},
          None
        ];
        (* we only show x axis as cycle numbers if Cycles option is specified as a span *)
        {cycleFrame,  cycleFrameStyle} = If[MatchQ[requestedCycles, All],
          {{False, False}, {False, None}},
          {{True, False}, {cycleNumbers, None}}
        ];

        ListPlot[
          plottingContents,
          LabelingFunction -> labeling,
          PlotStyle -> {RGBColor["#377EB8"], Dashing[Tiny], Thick},
          Joined -> True,
          PlotRange -> {cycleRange, plotRange},
          ImageSize -> Medium,
          Frame -> {{True, False}, cycleFrame},
          FrameTicks -> {{True, None}, cycleFrameStyle},
          FrameTicksStyle -> {Directive[RGBColor["#5E6770"], 12], None},
          FrameLabel -> {None, Style["pH", RGBColor["#5E6770"], Bold, 12]},
          PlotLabel -> Style["pH titration curve of " <> ToString[First[sample]], RGBColor["#5E6770"], Bold, 12],
          (* Target pH line *)
          GridLines -> {{}, If[requestedTargetpH, {0, nominalpH}, {}]},
          GridLinesStyle -> Directive[RGBColor["#800080"], Dashing[Large], Thick, Opacity[0.3]],
          Epilog -> Join[
            (* Target pH marker *)
            If[requestedTargetpH, {Inset[Style[" Target pH ", RGBColor["#800080"], Bold, Opacity[0.5], Background -> White], {Last[cycleNumbers] + 5 * legendPositionX, nominalpH}]}, {}],

            If[MatchQ[requestedDisplay, AcidAndBaseAddition],
              (* Addition Arrow *)
              {{Blue,
                Dashed,
                Opacity[0.6],
                Arrowheads[0.017],
                Thickness[0.0035],
                Arrow[arrow]},
                (* Addition Legend *)
                {Blue,
                  Dashed,
                  Opacity[0.6],
                  Arrowheads[0.017],
                  Thickness[0.0035],
                  Arrow[{{{Last[cycleNumbers] + 3 * legendPositionX, legendPositionY + 0.1}, {Last[cycleNumbers] + 3 * legendPositionX, legendPositionY + 0.5}},
                    {{Last[cycleNumbers] + 3 * legendPositionX, legendPositionY - 0.1}, {Last[cycleNumbers] + 3 * legendPositionX, legendPositionY - 0.5}}}]},
                {Style[Text["Base Addition", {Last[cycleNumbers] + 4.2 * legendPositionX, legendPositionY + 0.3}], 6]},
                {Style[Text["Acid Addition", {Last[cycleNumbers] + 4.2 * legendPositionX, legendPositionY - 0.3}], 6]}},
              (* We do not need legend or arrow if we do not display Additions *)
              {}
            ]
          ]
        ]
      ]
    ],
    {
      logAdditionModels,
      logAdditionAmounts,
      logpHs,
      nominalpHs,
      samplesIn
    }
  ];

  fullOptions=Normal[Association[safeOptions]];

  (* If Options were requested, just take the unique set of options since they are the same for all plots. Make it a List first just in case there is only one option set. *)
  outputOption = If[MemberQ[output, Options],
    DeleteDuplicates[Flatten[ToList[fullOptions]]]
  ];

  (* If Result was requested, output the plots in slide view, unless there is only one plot then we can just show it not in slide view. *)
  outputPlot = If[MemberQ[output, Result],
    If[Length[adjustpHPlots] > 1,
      SlideView[adjustpHPlots],
      First[adjustpHPlots]
    ]
  ];

  (* Return the result *)
  finalResult = outputSpecification/.{
    Result->outputPlot,
    Preview->adjustpHPlots,
    Options->outputOption,
    Tests->safeOptionTests
  }

];




