
(* ::Subsection:: *)
(*PlotSerologicalPipette*)

DefineOptions[PlotSerologicalPipette,
  Options :> {
    {
      OptionName -> FieldOfView,
      Description -> "Indicates if the whole pipette should be displayed or just the region around any meniscus.",
      Default -> All,
      AllowNull -> False,
      Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[All, MeniscusPoint]],
      Category -> "General"
    },

    (*{
      OptionName -> Meniscus,
      Description -> "Indicates whether any displayed meniscus should be concave (typical for aqueous solutions) or convex.",
      Default -> Concave,
      AllowNull -> False,
      Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Concave, Convex]],
      Category -> "Hidden"
    },*)
    CacheOption
  }
];

(* PlotSerologicalPipette Messages *)
(* NOTE: some messages are shared with PlotGraduateCylinder *)
Error::InvalidPipetteType = "The input `1` must be a serological pipette.";
Error::UnableToPlotTipModel = "Unable to plot `1`. Please contact ECL to set up the model for plotting.";

(* No Volume Overload: *)
PlotSerologicalPipette[myObject:ObjectP[{Model[Item, Tips], Object[Item, Tips]}], myOptions:OptionsPattern[PlotSerologicalPipette]] := Quiet[PlotSerologicalPipette[myObject, 0 Milliliter, myOptions], {Warning::VolumeOutsideOfGraduations}];

(* Main Overload: PlotGraduatedCylinder *)
PlotSerologicalPipette[myObject:ObjectP[{Model[Item, Tips], Object[Item, Tips]}], myVolume:UnitsP[Milliliter], myOptions:OptionsPattern[PlotSerologicalPipette]] := Module[
  {
    safeOptions, fieldOfView, cache, pipetteType, maxVolume, minVolume, ascendingGraduations, ascendingGraduationTypes, ascendingGraduationLabels,
    descendingGraduations, descendingGraduationTypes, descendingGraduationLabels, scaleMin, scaleMax, scaleToShow,
    maxStringLength, serologicalPipetteGraphic, secondNearestAscendingVolumeLabel, secondNearestDescendingVolumeLabel, secondNearestVolumeLabel, verticalRange, plotRange, liquidFunction, ratio,
    graduationGraphicFunction, graduationGraphics, liquidGraphic, arrowGraphic, arrowText, textScaleFactor, positionInAscendingGradutionsOfVolume, positionInDescendingGradutionsOfVolume,
    specifiedVolumeAscendingLabeledQ, specifiedVolumeDescendingLabeledQ,
    ascendingTicksAbove, ascendingTicksBelow, ascendingLowerLabeledGraduation, ascendingUpperLabeledGraduation,
    descendingTicksAbove, descendingTicksBelow, descendingLowerLabeledGraduation, descendingUpperLabeledGraduation,
    labeledGraduationsAbove, labeledGraduationsBelow, graduationScaleLabels,
    ascendingLowerTickArrow, ascendingUpperTickArrow, serologicalPipetteGraphicFunction, descendingLowerTickArrow, descendingUpperTickArrow
  },

  (* Get the SafeOptions. *)
  safeOptions = SafeOptions[PlotSerologicalPipette, ToList[myOptions]];

  (* Lookup our options. *)
  {fieldOfView, cache} = Lookup[safeOptions, {FieldOfView, Cache}];

  (* Download the PipetteType, and ascending and descending Graduations, GraduationTypes, and GraduationLabels. *)
  {
    pipetteType, maxVolume, minVolume,
    ascendingGraduations, ascendingGraduationTypes, ascendingGraduationLabels,
    descendingGraduations, descendingGraduationTypes, descendingGraduationLabels
  } = If[MatchQ[myObject, ObjectP[Model[Item]]],
    Download[myObject,
      {
        PipetteType, MaxVolume, MinVolume,
        AscendingGraduations, AscendingGraduationTypes, AscendingGraduationLabels,
        DescendingGraduations, DescendingGraduationTypes, DescendingGraduationLabels
      },
      Cache -> cache
    ],
    (* Download through model if given the object. *)
    Download[myObject,
      Model[{
        PipetteType, MaxVolume, MinVolume,
        AscendingGraduations, AscendingGraduationTypes, AscendingGraduationLabels,
        DescendingGraduations, DescendingGraduationTypes, DescendingGraduationLabels
      }],
      Cache -> cache
    ]
  ];

  (* If the PipetteType is not Serological, throw a message and return $Failed. *)
  If[!MatchQ[pipetteType, Serological],
    Message[Error::InvalidPipetteType, ObjectToString[myObject]];
    Return[$Failed]
  ];

  (* Crude error check to make sure we can plot. If we cannot plot, throw a message and return $Failed. *)
  If[Or[MatchQ[{ascendingGraduations, descendingGraduations}, {{}, {}}], MatchQ[{ascendingGraduationTypes, descendingGraduationTypes}, {{}, {}}], MatchQ[{ascendingGraduationLabels, descendingGraduationLabels}, {{}, {}}],
    Length[ascendingGraduations]!=Length[ascendingGraduationTypes], Length[ascendingGraduations] != Length[ascendingGraduationLabels],
    Length[descendingGraduations]!=Length[descendingGraduationTypes], Length[descendingGraduations] != Length[descendingGraduationLabels]
  ],
    Message[Error::UnableToPlotTipModel, ObjectToString[myObject]];
    Return[$Failed]
  ];

  scaleToShow = Which[
    ascendingGraduations == {}, Descending,
    descendingGraduations == {}, Ascending,
    True, Both
  ];

  scaleMax = Max[ascendingGraduations[[-1]], maxVolume - descendingGraduations[[-1]]];
  scaleMin = Min[ascendingGraduations[[1]], minVolume];

  (* Determine the MaxStringLength for scaling *)
  (* Note the last graduation doesn't matter.. *)
  maxStringLength = Max[If[MatchQ[#, _String], StringLength[#], 0]& /@ Join[ascendingGraduationLabels[[ ;; -2]], descendingGraduationLabels[[ ;; -2]]]];

  (* Need additional text scale factor for when 'Lower Part of Meniscus' text is shown. *)
  textScaleFactor = If[MatchQ[fieldOfView, All], 0.1, 0.125];

  (* The graduations will go up to a height of 25 MM graphics units. *)
  ratio = 25/(scaleMax - scaleMin);

  (* Determine the plot range based on the given FieldOfView. *)
  plotRange = Which[MatchQ[{fieldOfView, scaleToShow, myVolume}, {All, Both, LessEqualP[0 Milliliter]}],
    {{-2, 7}, All},
    MatchQ[{fieldOfView, scaleToShow}, {All, Both}],
    {{-4, 9}, All},
    MatchQ[fieldOfView, All],
    {-2, 2},
    True,
    (* Otherwise find our nearest two label. *)
    secondNearestAscendingVolumeLabel = If[MatchQ[scaleToShow, Alternatives[Ascending, Both]],
      If[myVolume >= Max[PickList[ascendingGraduations, ascendingGraduationTypes, Labeled]] || myVolume <= Min[PickList[ascendingGraduations, ascendingGraduationTypes, Labeled]],
        Last[Nearest[PickList[ascendingGraduations, ascendingGraduationTypes, Labeled], myVolume, 1]],
        Last[Nearest[PickList[ascendingGraduations, ascendingGraduationTypes, Labeled], myVolume, 2]]
      ],
      myVolume
    ];
    secondNearestDescendingVolumeLabel = If[MatchQ[scaleToShow, Alternatives[Descending, Both]],
      If[myVolume >= Max[PickList[maxVolume - descendingGraduations, descendingGraduationTypes, Labeled]] || maxVolume <= Min[PickList[maxVolume - descendingGraduations, descendingGraduationTypes, Labeled]],
        Last[Nearest[PickList[maxVolume - descendingGraduations, descendingGraduationTypes, Labeled], myVolume, 1]],
        Last[Nearest[PickList[maxVolume - descendingGraduations, descendingGraduationTypes, Labeled], myVolume, 2]]
      ],
      maxVolume - myVolume
    ];

    secondNearestVolumeLabel = Last[Nearest[{secondNearestAscendingVolumeLabel, secondNearestDescendingVolumeLabel}, myVolume, 2]];
    verticalRange = Max[1.3*Abs[secondNearestVolumeLabel - myVolume]*ratio, 2];
    {{-4, 9}, {myVolume*ratio - verticalRange, myVolume*ratio + verticalRange}}
  ];

  (* Determine if we should display ticks above/ticks below. *)
  positionInAscendingGradutionsOfVolume = First[Flatten[Position[ascendingGraduations, EqualP[myVolume]]] /. {} -> {Null}];
  positionInDescendingGradutionsOfVolume = First[Flatten[Position[descendingGraduations, EqualP[maxVolume - myVolume]]] /. {} -> {Null}];

  (* Determine if the specified volume would be to a labeled graduation. *)
  specifiedVolumeAscendingLabeledQ = If[NullQ[positionInAscendingGradutionsOfVolume], False, MatchQ[Part[ascendingGraduationTypes, positionInAscendingGradutionsOfVolume], Labeled]];
  specifiedVolumeDescendingLabeledQ = If[NullQ[positionInDescendingGradutionsOfVolume], False, MatchQ[Part[descendingGraduationTypes, positionInDescendingGradutionsOfVolume], Labeled]];

  (* If not calculate the number of ticks above and below. *)
  {ascendingTicksAbove, ascendingTicksBelow, ascendingLowerLabeledGraduation, ascendingUpperLabeledGraduation} = If[!specifiedVolumeAscendingLabeledQ && !MatchQ[positionInAscendingGradutionsOfVolume, Null],
    {labeledGraduationsBelow, labeledGraduationsAbove} = {
      PickList[ascendingGraduations[[;;positionInAscendingGradutionsOfVolume]], ascendingGraduationTypes[[;;positionInAscendingGradutionsOfVolume]], Labeled],
      PickList[ascendingGraduations[[positionInAscendingGradutionsOfVolume;;]], ascendingGraduationTypes[[positionInAscendingGradutionsOfVolume;;]], Labeled]
    };
    Which[MatchQ[{labeledGraduationsBelow, labeledGraduationsAbove}, {{},{}}],
      {Null, Null, Null, Null},
      MatchQ[labeledGraduationsAbove, {}],
      {positionInAscendingGradutionsOfVolume - First[Flatten[Position[ascendingGraduations, labeledGraduationsBelow[[-1]]]]], Null, labeledGraduationsBelow[[-1]], Null},
      MatchQ[labeledGraduationsBelow, {}],
      {Null, First[Flatten[Position[ascendingGraduations, labeledGraduationsAbove[[1]]]]] - positionInAscendingGradutionsOfVolume, Null, labeledGraduationsAbove[[1]]},
      True,
      {positionInAscendingGradutionsOfVolume - First[Flatten[Position[ascendingGraduations, labeledGraduationsBelow[[-1]]]]], First[Flatten[Position[ascendingGraduations, labeledGraduationsAbove[[1]]]]] - positionInAscendingGradutionsOfVolume, labeledGraduationsBelow[[-1]], labeledGraduationsAbove[[1]]}
    ],
    {Null, Null, Null, Null}
  ];

  (* If not calculate the number of ticks above and below. *)
  {descendingTicksAbove, descendingTicksBelow, descendingLowerLabeledGraduation, descendingUpperLabeledGraduation} = If[!specifiedVolumeDescendingLabeledQ && !MatchQ[positionInDescendingGradutionsOfVolume, Null],
    {labeledGraduationsBelow, labeledGraduationsAbove} = {
      PickList[descendingGraduations[[;;positionInDescendingGradutionsOfVolume]], descendingGraduationTypes[[;;positionInDescendingGradutionsOfVolume]], Labeled],
      PickList[descendingGraduations[[positionInDescendingGradutionsOfVolume;;]], descendingGraduationTypes[[positionInDescendingGradutionsOfVolume;;]], Labeled]
    };
    Which[MatchQ[{labeledGraduationsBelow, labeledGraduationsAbove}, {{},{}}],
      {Null, Null, Null, Null},
      MatchQ[labeledGraduationsAbove, {}],
      {positionInDescendingGradutionsOfVolume - First[Flatten[Position[descendingGraduations, labeledGraduationsBelow[[-1]]]]], Null, labeledGraduationsBelow[[-1]], Null},
      MatchQ[labeledGraduationsBelow, {}],
      {Null, First[Flatten[Position[descendingGraduations, labeledGraduationsAbove[[1]]]]] - positionInDescendingGradutionsOfVolume, Null, labeledGraduationsAbove[[1]]},
      True,
      {positionInDescendingGradutionsOfVolume - First[Flatten[Position[descendingGraduations, labeledGraduationsBelow[[-1]]]]], First[Flatten[Position[descendingGraduations, labeledGraduationsAbove[[1]]]]] - positionInDescendingGradutionsOfVolume, labeledGraduationsBelow[[-1]], labeledGraduationsAbove[[1]]}
    ],
    {Null, Null, Null, Null}
  ];

  (* Throw an error and return $Failed if the we cannot display the input volume. *)
  If[Or[myVolume < 0 Milliliter, myVolume > 29/ratio],
    Message[Error::VolumeOutsidePlottableRange, ToString[myVolume], ToString[29/ratio]];
    Return[$Failed]
  ];

  (* Throw a warning if the input volume is outside of the measurable range of the graduations . *)
  If[Or[myVolume < scaleMin, myVolume > scaleMax],
    Message[Warning::VolumeOutsideOfGraduations, ToString[myVolume], ToString[scaleMin], ToString[scaleMax]]
  ];

  (* Define a generic graduated cylinder shape. *)
  serologicalPipetteGraphicFunction[xOffset_] := Line[{
    {-0.5 + xOffset, 0.5}, {-0.5 + xOffset, 30}, {0.5 + xOffset, 30},
    {0.5 + xOffset, 0.5}, {0.1 + xOffset, -0.25}, {0.1 + xOffset, -0.5},
    {-0.1 + xOffset, -0.5}, {-0.1 + xOffset, -0.25}, {-0.5 + xOffset, 0.5}
  }];

  serologicalPipetteGraphic = If[MatchQ[scaleToShow, Both],
    {serologicalPipetteGraphicFunction[0], serologicalPipetteGraphicFunction[5]},
    serologicalPipetteGraphicFunction[0]
  ];

  (* Helper function to convert graduations to MM graphics. *)
  graduationGraphicFunction[volume_, style_, label_, xOffset_, alignment_] := Module[{xMin, xMax},
    {xMin, xMax} = Which[MatchQ[style, Labeled],
      {-0.5, 0.5},
      MatchQ[{style, alignment}, {Long, Left}],
      {0, 0.5},
      MatchQ[{style, alignment}, {Long, Right}],
      {-0.5, 0},
      MatchQ[alignment, Right],
      {-0.5, -0.2},
      MatchQ[alignment, Left],
      {0.2, 0.5}
    ];
    {Line[{{xMin + xOffset, volume*ratio}, {xMax + xOffset, volume*ratio}}], If[MatchQ[style, Labeled], Text[Style[label, Bold, FontSize -> Scaled[0.8/(maxStringLength*(plotRange[[1,2]] - plotRange[[1,1]]))]], {If[MatchQ[alignment, Right], 0.45, 0] + xOffset, volume*ratio + 0.45/maxStringLength}, {1, 0}]]}
  ];

  (* Apply the function to the graduations*)
  graduationGraphics = Which[MatchQ[scaleToShow, Both],
    Flatten[{
      MapThread[graduationGraphicFunction, {ascendingGraduations, ascendingGraduationTypes, ascendingGraduationLabels, ConstantArray[0, Length[ascendingGraduations]], ConstantArray[Left, Length[ascendingGraduations]]}],
      MapThread[graduationGraphicFunction, {maxVolume - descendingGraduations, descendingGraduationTypes, descendingGraduationLabels, ConstantArray[5, Length[descendingGraduations]], ConstantArray[Right, Length[descendingGraduations]]}]
    }],
    MatchQ[scaleToShow, Ascending],
    MapThread[graduationGraphicFunction, {ascendingGraduations, ascendingGraduationTypes, ascendingGraduationLabels, ConstantArray[0, Length[ascendingGraduations]], ConstantArray[Left, Length[ascendingGraduations]]}],
    True,
    MapThread[graduationGraphicFunction, {maxVolume - descendingGraduations, descendingGraduationTypes, descendingGraduationLabels, ConstantArray[0, Length[descendingGraduations]], ConstantArray[Right, Length[descendingGraduations]]}]
  ];

  (* Helper function to make a polygon graphic for the input volume (if specified). *)
  liquidFunction[volume_, xOffset_] := Module[{yCoordinate},
    If[LessEqualQ[volume, 0 Milliliter], Nothing,
      yCoordinate = volume*ratio;
      {
        RGBColor[0.4, 0.6, 1.],
        Polygon[{
          {0.5 + xOffset, 0.5}, {0.1 + xOffset, -0.25}, {0.1 + xOffset, -0.5},
          {-0.1 + xOffset, -0.5}, {-0.1 + xOffset, -0.25}, {-0.5 + xOffset, 0.5},
          {-0.5 + xOffset, 0.5 + yCoordinate},
          {-0.493844 + xOffset, 0.42178 + yCoordinate},
          {-0.475528 + xOffset, 0.34549 + yCoordinate},
          {-0.445503 + xOffset, 0.273 + yCoordinate},
          {-0.404508 + xOffset, 0.20611 + yCoordinate},
          {-0.353553 + xOffset, 0.14645 + yCoordinate},
          {-0.293893 + xOffset, 0.09549 + yCoordinate},
          {-0.226995 + xOffset, 0.0545 + yCoordinate},
          {-0.154508 + xOffset, 0.02447 + yCoordinate},
          {-0.0782172 + xOffset, 0.00616 + yCoordinate},
          {0 + xOffset, yCoordinate},
          {0.0782172 + xOffset, 0.00616 + yCoordinate},
          {0.154508 + xOffset, 0.02447 + yCoordinate},
          {0.226995 + xOffset, 0.0545 + yCoordinate},
          {0.293893 + xOffset, 0.09549 + yCoordinate},
          {0.353553 + xOffset, 0.14645 + yCoordinate},
          {0.404508 + xOffset, 0.20611 + yCoordinate},
          {0.445503 + xOffset, 0.273 + yCoordinate},
          {0.475528 + xOffset, 0.34549 + yCoordinate},
          {0.493844 + xOffset, 0.42178 + yCoordinate},
          {0.5 + xOffset, 0.5 + yCoordinate},
          {0.5 + xOffset, 0}
        }]
      }
    ]
  ];

  (* Apply the helper function to the specified volume. *)
  liquidGraphic = If[MatchQ[scaleToShow, Both],
    {liquidFunction[myVolume, 0], liquidFunction[myVolume, 5]},
    liquidFunction[myVolume, 0]
  ];

  (* Make annotations. *)
  arrowGraphic = If[GreaterQ[myVolume, 0 Milliliter],
    {Red, (*Arrowheads[0.05], Arrow[{{-2, myVolume*ratio}, {-0.5, myVolume*ratio}}], Arrowheads[0.05], Arrow[{{If[MatchQ[scaleToShow, Both], 7, 2], myVolume*ratio}, {If[MatchQ[scaleToShow, Both], 5.5, 0], myVolume*ratio}}],*) Dashed, Thickness[0.005], Line[{{-0.5, myVolume*ratio}, {If[MatchQ[scaleToShow, Both], 5.5, 2], myVolume*ratio}}]},
    Nothing
  ];

  ascendingLowerTickArrow = If[NullQ[ascendingLowerLabeledGraduation], Nothing, {Gray, Arrow[{{-2, ascendingLowerLabeledGraduation*ratio}, {-2, myVolume*ratio}}], Text[Style[ToString[ascendingTicksAbove] <> " Tick" <> If[GreaterQ[ascendingTicksAbove,1], "s", ""], Bold, FontSize -> If[MatchQ[fieldOfView, All], 6, 12]], {-3, ratio*(myVolume+ascendingLowerLabeledGraduation)/2}]}];
  ascendingUpperTickArrow = If[NullQ[ascendingUpperLabeledGraduation], Nothing, {Gray, Arrow[{{-2, ascendingUpperLabeledGraduation*ratio}, {-2, myVolume*ratio}}], Text[Style[ToString[ascendingTicksBelow] <> " Tick" <> If[GreaterQ[ascendingTicksBelow,1], "s", ""], Bold, FontSize -> If[MatchQ[fieldOfView, All], 6, 12]], {-3, ratio*(myVolume+ascendingUpperLabeledGraduation)/2}]}];

  If[MatchQ[scaleToShow, Descending],
    (* If we only have a descending scale put the tick arrows on the right hand side. *)
    descendingLowerTickArrow = If[NullQ[descendingLowerLabeledGraduation], Nothing, {Gray, Arrow[{{-2, (maxVolume-descendingLowerLabeledGraduation)*ratio}, {-2, myVolume*ratio}}], Text[Style[ToString[descendingTicksAbove] <> " Tick" <> If[GreaterQ[descendingTicksAbove,1], "s", ""], Bold, FontSize -> If[MatchQ[fieldOfView, All], 6, 12]], {-3, ratio*(myVolume+(maxVolume-descendingLowerLabeledGraduation))/2}]}];
    descendingUpperTickArrow = If[NullQ[descendingUpperLabeledGraduation], Nothing, {Gray, Arrow[{{-2, (maxVolume-descendingUpperLabeledGraduation)*ratio}, {-2, myVolume*ratio}}], Text[Style[ToString[descendingTicksBelow] <> " Tick" <> If[GreaterQ[descendingTicksBelow,1], "s", ""], Bold, FontSize -> If[MatchQ[fieldOfView, All], 6, 12]], FontSize -> If[MatchQ[fieldOfView, All], 8, 12], {-3, ratio*(myVolume+(maxVolume-descendingUpperLabeledGraduation))/2}]}],
    (* Otherwise, put them on the left hand side. *)
    descendingLowerTickArrow = If[NullQ[descendingLowerLabeledGraduation], Nothing, {Gray, Arrow[{{7, (maxVolume-descendingLowerLabeledGraduation)*ratio}, {7, myVolume*ratio}}], Text[Style[ToString[descendingTicksAbove] <> " Tick" <> If[GreaterQ[descendingTicksAbove,1], "s", ""], Bold, FontSize -> If[MatchQ[fieldOfView, All], 6, 12]], {8, ratio*(myVolume+(maxVolume-descendingLowerLabeledGraduation))/2}]}];
    descendingUpperTickArrow = If[NullQ[descendingUpperLabeledGraduation], Nothing, {Gray, Arrow[{{7, (maxVolume-descendingUpperLabeledGraduation)*ratio}, {7, myVolume*ratio}}], Text[Style[ToString[descendingTicksBelow] <> " Tick" <> If[GreaterQ[descendingTicksBelow,1], "s", ""], Bold, FontSize -> If[MatchQ[fieldOfView, All], 6, 12]], {8, ratio*(myVolume+(maxVolume-descendingUpperLabeledGraduation))/2}]}]
  ];

  (* Make Text for annotations. *)
  arrowText = If[GreaterQ[myVolume, 0 Milliliter],
    {Red, Text[Style["Lower Part\nof Meniscus", Bold, FontSize -> If[MatchQ[fieldOfView, All], 8, 12]], {2.5, myVolume*ratio}]},
    Nothing
  ];

  graduationScaleLabels = If[MatchQ[scaleToShow, Both],
    {
      Rotate[Text[Style["Ascending \[Rule]", FontSize -> If[MatchQ[fieldOfView, All], 8, 12]], {-1, If[MatchQ[fieldOfView, All], 15, myVolume*ratio]}], Pi/2],
      Rotate[Text[Style["Descending \[Rule]", FontSize -> If[MatchQ[fieldOfView, All], 8, 12]], {6, If[MatchQ[fieldOfView, All], 15, myVolume*ratio]}], Pi/2]
    },
    Nothing
  ];

  (*Return all the graphics, *)
  Graphics[
    {
      liquidGraphic,
      graduationScaleLabels,
      ascendingLowerTickArrow,
      ascendingUpperTickArrow,
      descendingLowerTickArrow,
      descendingUpperTickArrow,
      arrowGraphic,
      arrowText,
      Dashing[None], Thickness[0.005],
      Black, serologicalPipetteGraphic,
      graduationGraphics
    }, PlotRange -> plotRange
  ]
];