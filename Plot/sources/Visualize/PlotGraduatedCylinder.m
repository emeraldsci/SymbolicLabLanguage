
(* ::Subsection:: *)
(*PlotGraduatedCylinder*)

DefineOptions[PlotGraduatedCylinder,
  Options :> {
    {
      OptionName -> FieldOfView,
      Description -> "Indicates if the whole graduated cylinder should be displayed or just the region around any meniscus.",
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

(* PlotGraduatedCylinder Messages *)
Error::UnableToPlotGraduatedCylinderModel = "Unable to plot `1`. Please contact ECL to set up the model for plotting.";


(* No Volume Overload: *)
PlotGraduatedCylinder[myObject:ObjectP[{Model[Container, GraduatedCylinder], Object[Container, GraduatedCylinder]}], myOptions:OptionsPattern[PlotGraduatedCylinder]] := Quiet[PlotGraduatedCylinder[myObject, 0 Milliliter, myOptions], {Warning::VolumeOutsideOfGraduations}];

(* Main Overload: PlotGraduatedCylinder *)
PlotGraduatedCylinder[myObject:ObjectP[{Model[Container, GraduatedCylinder], Object[Container, GraduatedCylinder]}], myVolume:UnitsP[Milliliter], myOptions:OptionsPattern[PlotGraduatedCylinder]] := Module[
  {
    safeOptions, fieldOfView, cache, graduations, graduationTypes, graduationLabels, maxStringLength, graduatedCylinderGraphic, secondNearestVolumeLabel, verticalRange, plotRange, liquidFunction, ratio,
    graduationGraphicFunction, graduationGraphics, liquidGraphic, arrowGraphic, arrowText, textScaleFactor, positionInGradutionsOfVolume, specifiedVolumeLabledQ, ticksAbove, ticksBelow, lowerLabeledGraduation, upperLabeledGraduation, labeledGraduationsAbove, labeledGraduationsBelow,
    lowerTickArrow, upperTickArrow
  },

  (* Get the SafeOptions. *)
  safeOptions = SafeOptions[PlotGraduatedCylinder, ToList[myOptions]];

  (* Lookup our options. *)
  {fieldOfView, cache} = Lookup[safeOptions, {FieldOfView, Cache}];

  (* Download the Graduations, GraduationTypes, and GraduationLabels. *)
  {graduations, graduationTypes, graduationLabels} = If[MatchQ[myObject, ObjectP[Model[Container]]],
    Download[myObject,
      {Graduations, GraduationTypes, GraduationLabels},
      Cache -> cache
    ],
    (* Download through model if given the object. *)
    Download[myObject,
      Model[{Graduations, GraduationTypes, GraduationLabels}],
      Cache -> cache
    ]
  ];

  (* Crude error check to make sure we can plot. If we cannot plot, throw a message and return $Failed. *)
  If[Or[MatchQ[graduations, {}], MatchQ[graduationTypes, {}], MatchQ[graduationLabels, {}], Length[graduations]!=Length[graduationTypes], Length[graduations] != Length[graduationLabels]],
    Message[Error::UnableToPlotGraduatedCylinderModel, ECL`InternalUpload`ObjectToString[myObject]];
    Return[$Failed]
  ];

  (* Determine the MaxStringLength for scaling *)
  (* Note the last graduation doesn't matter.. *)
  maxStringLength = Max[If[MatchQ[#, _String], StringLength[#], 0]& /@ graduationLabels[[ ;; -2]]];

  (* Need additional text scale factor for when 'Lower Part of Meniscus' text is shown. *)
  textScaleFactor = Which[GreaterQ[myVolume, 0 Milliliter] && MatchQ[fieldOfView, All], 0.5, GreaterQ[myVolume, 0 Milliliter], 0.35, True, 1];

  (* The graduations will go up to a height of 25 MM graphics units. *)
  ratio = 25/Max[graduations];

  (* Determine the plot range based on the given FieldOfView. *)
  plotRange = If[MatchQ[fieldOfView, All],
    All,
    (* Otherwise find our nearest two label. *)
    secondNearestVolumeLabel = Last[Nearest[PickList[graduations, graduationTypes, Labeled], myVolume, 2]];
    verticalRange = 1.3*Abs[secondNearestVolumeLabel - myVolume]*ratio;
    {{-8, If[MatchQ[fieldOfView, All], 12, 8]}, {myVolume*ratio - verticalRange, myVolume*ratio + verticalRange}}
  ];

  (* Determine if we should display ticks above/ticks below. *)
  positionInGradutionsOfVolume = First[Flatten[Position[graduations, EqualP[myVolume]]] /. {} -> {Null}];

  (* Determine if the specified volume would be to a labeled graduation. *)
  specifiedVolumeLabledQ = If[NullQ[positionInGradutionsOfVolume], False, MatchQ[Part[graduationTypes, positionInGradutionsOfVolume], Labeled]];

  (* If not calculate the number of ticks above and below. *)
  {ticksAbove, ticksBelow, lowerLabeledGraduation, upperLabeledGraduation} = If[!specifiedVolumeLabledQ && !MatchQ[positionInGradutionsOfVolume, Null],
    {labeledGraduationsBelow, labeledGraduationsAbove} = {
      PickList[graduations[[;;positionInGradutionsOfVolume]], graduationTypes[[;;positionInGradutionsOfVolume]], Labeled],
      PickList[graduations[[positionInGradutionsOfVolume;;]], graduationTypes[[positionInGradutionsOfVolume;;]], Labeled]
    };
    Which[MatchQ[{labeledGraduationsBelow, labeledGraduationsAbove}, {{},{}}],
      {Null, Null, Null, Null},
      MatchQ[labeledGraduationsAbove, {}],
      {positionInGradutionsOfVolume - First[Flatten[Position[graduations, labeledGraduationsBelow[[-1]]]]], Null, labeledGraduationsBelow[[-1]], Null},
      MatchQ[labeledGraduationsBelow, {}],
      {Null, First[Flatten[Position[graduations, labeledGraduationsAbove[[1]]]]] - positionInGradutionsOfVolume, Null, labeledGraduationsAbove[[1]]},
      True,
      {positionInGradutionsOfVolume - First[Flatten[Position[graduations, labeledGraduationsBelow[[-1]]]]], First[Flatten[Position[graduations, labeledGraduationsAbove[[1]]]]] - positionInGradutionsOfVolume, labeledGraduationsBelow[[-1]], labeledGraduationsAbove[[1]]}
    ],
    {Null, Null, Null, Null}
  ];

  (* Throw an error and return $Failed if the we cannot display the input volume. *)
  If[Or[myVolume < 0 Milliliter, myVolume > 28/ratio],
    Message[Error::VolumeOutsidePlottableRange, ToString[myVolume], ToString[28/ratio]];
    Return[$Failed]
  ];

  (* Throw a warning if the input volume is outside of the measurable range of the graduations . *)
  If[Or[myVolume < Min[graduations], myVolume > Max[graduations]],
    Message[Warning::VolumeOutsideOfGraduations, ToString[myVolume], ToString[Min[graduations]], ToString[Max[graduations]]]
  ];

  (* Define a generic graduated cylinder shape. *)
  graduatedCylinderGraphic = Line[{
    {{2, 0}, {-2, 0}},
    {{-3, -0.75}, {3, -0.75}},
    {{-2, 0}, {-3, -0.25}},
    {{-3, -0.25}, {-3, -0.75}},
    {{3, -0.75}, {3, -0.25`}},
    {{3, -0.25}, {2, 0}},
    {{2, 0}, {2, 30}},
    {{2, 30}, {-2.5, 30}},
    {{-2.5, 30}, {-2, 29}},
    {{-2, 29}, {-2, 0}}
  }];

  (* Helper function to convert graduations to MM graphics. *)
  graduationGraphicFunction[volume_, style_, label_] := Module[{xMin, xMax},
    {xMin, xMax} = Which[MatchQ[style, Labeled],
      {-2, 2},
      MatchQ[style, Long],
      {-1, 0.75},
      True,
      {-0.75, 0.75}
    ];
    {Line[{{xMin, volume*ratio}, {xMax, volume*ratio}}], If[MatchQ[style, Labeled], Text[Style[label, Bold, FontSize -> Scaled[textScaleFactor * 0.25/maxStringLength]], {1.8, volume*ratio + 1/maxStringLength}, {1, 0}]]}
  ];

  (* Apply the function to the graduations*)
  graduationGraphics = Flatten[MapThread[graduationGraphicFunction, {graduations, graduationTypes, graduationLabels}]];

  (* Helper function to make a polygon graphic for the input volume (if specified). *)
  liquidFunction[volume_] := Module[{yCoordinate},
  If[LessEqualQ[volume, 0 Milliliter], Nothing,
      yCoordinate = volume*ratio;
      {
        RGBColor[0.4, 0.6, 1.],
        Polygon[{
          {-2, 0},
          {-2, 0.7639320225002102 + yCoordinate},
          {-1.8316500509315627, 0.6240669010002811 + yCoordinate},
          {-1.6535508478285599, 0.49684806820571614 + yCoordinate},
          {-1.4666503525429422, 0.3829526669573462 + yCoordinate},
          {-1.2719433732296845, 0.28298692397384784 + yCoordinate},
          {-1.070466269319272, 0.19748292311185356 + yCoordinate},
          {-0.8632914353267827, 0.1268957732634508 + yCoordinate},
          {-0.6515215928584205, 0.07160118596540421 + yCoordinate},
          {-0.43628392119716725, 0.03189347561364908 + yCoordinate},
          {-0.21872405770850506, 0.007983992927255823 + yCoordinate},
          {0, yCoordinate},
          {0.21872405770850403, 0.007983992927256267 + yCoordinate},
          {0.4362839211971663, 0.03189347561364908 + yCoordinate},
          {0.6515215928584193, 0.07160118596540421 + yCoordinate},
          {0.8632914353267815, 0.1268957732634508 + yCoordinate},
          {1.0704662693192684, 0.19748292311185267 + yCoordinate},
          {1.2719433732296834, 0.2829869239738483 + yCoordinate},
          {1.4666503525429408, 0.3829526669573471 + yCoordinate},
          {1.653550847828556, 0.49684806820571525 + yCoordinate},
          {1.8316500509315594, 0.6240669010002806 + yCoordinate},
          {2, 0.7639320225002102 + yCoordinate},
          {2, 0}
        }]
      }
    ]
  ];

  (* Apply the helper function to the specified volume. *)
  liquidGraphic = liquidFunction[myVolume];

  (* Make annotations. *)
  arrowGraphic = If[GreaterQ[myVolume, 0 Milliliter],
    {Red, Arrowheads[0.05], Arrow[{{-3, myVolume*ratio}, {-2.1, myVolume*ratio}}], Arrowheads[0.05], Arrow[{{3, myVolume*ratio}, {2.1, myVolume*ratio}}], Dashed, Thickness[0.01], Line[{{-2, myVolume*ratio}, {2, myVolume*ratio}}]},
    Nothing
  ];

  lowerTickArrow = If[NullQ[lowerLabeledGraduation], Nothing, {Gray, Arrow[{{-4, lowerLabeledGraduation*ratio}, {-4, myVolume*ratio}}], Text[Style[ToString[ticksAbove] <> " Tick" <> If[GreaterQ[ticksAbove,1], "s", ""], Bold], {-5.5, ratio*(myVolume+lowerLabeledGraduation)/2}]}];
  upperTickArrow = If[NullQ[upperLabeledGraduation], Nothing, {Gray, Arrow[{{-4, upperLabeledGraduation*ratio}, {-4, myVolume*ratio}}], Text[Style[ToString[ticksBelow] <> " Tick" <> If[GreaterQ[ticksBelow,1], "s", ""], Bold], {-5.5, ratio*(myVolume+upperLabeledGraduation)/2}]}];

  (* Make Text for annotations. *)
  arrowText = If[GreaterQ[myVolume, 0 Milliliter],
    {Red, Text[Style["Lower Part\nof Meniscus", Bold], {If[MatchQ[fieldOfView, All], 6, 5], myVolume*ratio}]},
    Nothing
  ];

  (*Return all the graphics, *)
  Graphics[{liquidGraphic, lowerTickArrow, upperTickArrow, arrowGraphic, arrowText, Dashing[None], Thickness[Which[GreaterQ[myVolume, 0 Milliliter] && MatchQ[fieldOfView, All], 0.01, GreaterQ[myVolume, 0 Milliliter], 0.005, True, 0.005]], Black, graduatedCylinderGraphic, graduationGraphics}, PlotRange -> plotRange]
];