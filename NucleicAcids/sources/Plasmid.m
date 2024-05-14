(* Graphics Function for Notebook Representations of Plasmids *)

(*
General Notes:
- Plasmids are always assumed to be plotted clockwise, whereas the mathematical convention is anti-clockwise. Functions
  are written for anti-clockwise, however negative angles can be used to get clockwise behavior. MMs graphics functions,
  such as Circle and Annulus, require angles in increasing order, and while negative angles are allowed, they will need
  to be reversed for those functions, and these helper functions, to use them.
- Plasmids are also assumed to start plotting at the top of the circle, thus a rotation of +90 degrees needs to be
  applied when calling these functions to generate that alignment. Currently, only the function basePairTicks applies
  this additional rotation by default.
- In order to give independent control over edge and hole color in hollowAnnulusWithArrow, and independent control
  over the line and text color in siteLabel, Color options were used in both (EdgeColor/HoleColor and LineColor/FontColor,
  respectively). Additionally, for the sake of consistency, a Color option was added to all other graphics functions.
  As a result, trying to set colors as: Graphics[{<color>, fxn}], will NOT work, since the color option value will be
  used instead.
*)

(*
Currently, colors, font sizes, and other graphics parameters are spread across options and various function calls.
Consider creating a master list of all graphics parameters at the top of the file for ease of control.
*)


(* ::Subsection:: *)
(* Main Function: PlotPlasmid *)
DefineOptions[PlotPlasmid,
  Options :> {
    {SiteLabels -> True, True | False, "Indicates if the primer binding site labels are drawn on the plasmid map."},
    {SiteMarkers -> True, True | False, "Indicates if the primer binding site sequence markers are drawn on the plasmid map."}
  }
];
PlotPlasmid[file:_String|ObjectP[Object[EmeraldCloudFile]], ops:OptionsPattern[]] := Module[
  {
    safeOptions,
    plasmid, plasmidName, numBasePairs, moleculeType,
    txtForNameGraphic, nameGraphic,
    tickFreq, tickGraphics,
    fullStrandGraphic,

    codingSequences, codingSequenceColor, codingSequenceGraphics,
    enhancers, enhancerColor, enhancerGraphics,
    replicationOrigins, replicationOriginColor, replicationOriginGraphics,
    proteinBindingSites, proteinBindingSiteColor, proteinBindingSiteGraphics,
    promoters, promoteColor, promoterGraphics,
    polyASignals, polyASignalColor, polyASignalGraphics,
    primerBindingSites, primerBindingSiteGraphics,
    topStrandGraphicsSite, topStrandGraphicsSequence, bottomStrandGraphicsSite, bottomStrandGraphicsSequence
  },

  (* Check Options *)
  safeOptions = Association @@ SafeOptions[PlotPlasmid, {ops}];

  (* Load the plasmid and unpack important values. *)
  plasmid = genBankImport[file];
  plasmidName = plasmid["Keywords"];
  numBasePairs = ToExpression@plasmid["Locus"]["SequenceLength"];
    (* This is imported as a string. Consider reformatting as part of the importer. *)
  moleculeType = plasmid["Locus"]["MoleculeType"];
    (* Check what the options are here. I'm assuming just ss-DNA and ds-DNA, but so far only seen the latter. *)

  (* -- Generate the Center Label *)
  (* Join name with number of base pairs for center graphic. *)
  txtForNameGraphic = StringJoin[plasmidName, "\[NewLine]", ToString[numBasePairs], " bp"];
  nameGraphic = Text[Style[txtForNameGraphic, FontFamily->"Bitstream Vera Sans Mono", FontSize->Scaled[0.03]], {0,0}];

  (* -- Generate the outer Full Strand Graphic *)
  fullStrandGraphic = hollowAnnulusWithArrow[{0,0}, {1.9, 2.1}, {0, 2*Pi}+Pi/2, Arrow->"Start", EdgeThickness->0.025, EdgeColor->GrayLevel[0.4]];

  (* -- Generate the Tick Graphic *)
  tickFreq = 1000;
  tickGraphics = basePairTicks[numBasePairs, tickFreq];

  (* - Generate the Annulus Feature Graphics *)
  (* - Coding Sequence - *)
  codingSequences = NestedLookup[plasmid, {"Features", "CodingSequence"}];
  codingSequenceColor = LCHColor[0.6, 1, 0.5];
  codingSequenceGraphics = generateAnnulusFeatureGraphics[codingSequences, numBasePairs,
    Color->codingSequenceColor, Radii->{1.4,1.6}];

  (* - Enhancers - *)
  enhancers = NestedLookup[plasmid, {"Features", "Enhancer"}];
  enhancerColor = GrayLevel[0.8];
  enhancerGraphics = generateAnnulusFeatureGraphics[enhancers, numBasePairs,
    Color->enhancerColor, Radii->{1.4,1.6}];

  (* - Replication Origins - *)
  replicationOrigins = NestedLookup[plasmid, {"Features", "ReplicationOrigin"}];
  replicationOriginColor = LCHColor[0.9, 1, 0.2];
  replicationOriginGraphics = generateAnnulusFeatureGraphics[replicationOrigins, numBasePairs,
    Color->replicationOriginColor, Radii->{1.4,1.6}];

  (* - Protein Binding Site - *)
  proteinBindingSites = NestedLookup[plasmid, {"Features", "ProteinBindingSite"}];
  proteinBindingSiteColor = LCHColor[0.6, 1, 0.7];
  proteinBindingSiteGraphics = generateAnnulusFeatureGraphics[proteinBindingSites, numBasePairs,
    Color->proteinBindingSiteColor, Radii->{1.4,1.6}];

  (* - Promoter - *)
  promoters = NestedLookup[plasmid, {"Features", "Promoter"}];
  promoteColor = LCHColor[0.7, 0.9, 1];
  promoterGraphics = generateAnnulusFeatureGraphics[promoters, numBasePairs,
    Color->promoteColor, Radii->{1.4,1.6}];

  (* - PolyASignal - *)
  polyASignals = NestedLookup[plasmid, {"Features", "PolyASignal"}];
  polyASignalColor = GrayLevel[0.4];
  polyASignalGraphics = generateAnnulusFeatureGraphics[polyASignals, numBasePairs,
    Color->polyASignalColor, Radii->{1.4,1.6}];


  (* - Generate Site Feature Graphics *)
  (* - Primer Binding Site - *)
  primerBindingSites = NestedLookup[plasmid, {"Features", "PrimerBindingSite"}];
  primerBindingSiteGraphics = generateSiteFeatureGraphics[primerBindingSites, numBasePairs];
  {topStrandGraphicsSite, topStrandGraphicsSequence, bottomStrandGraphicsSite, bottomStrandGraphicsSequence} = primerBindingSiteGraphics;

  (* Return Plasmid Map Graphics Object *)
  Graphics@{
    nameGraphic, fullStrandGraphic, tickGraphics,
    codingSequenceGraphics, enhancerGraphics, replicationOriginGraphics,
    proteinBindingSiteGraphics, promoterGraphics, polyASignalGraphics,
    (* Check if user wants site labels and/or sequence markers. Useful when using for MakeBoxes form on plasmid object. *)
    If[safeOptions[SiteLabels], {topStrandGraphicsSite, bottomStrandGraphicsSite}, Nothing],
    If[safeOptions[SiteMarkers], {topStrandGraphicsSequence, bottomStrandGraphicsSequence}, Nothing]
  }

];



(* ::Subsection:: *)
(* Primary Helper Functions *)

genBankImport[file:ObjectP[Object[EmeraldCloudFile]]] := Module[
  {
    downloadedFile
  },
  (* For some reason, keep appending NucleicAcids`Private` to DownloadCloudFile, so adding explicit context. *)
  downloadedFile = ECL`DownloadCloudFile[file, $TemporaryDirectory];
  genBankImport[downloadedFile]
];

genBankImport[file_String] := Module[
  {
    rawText, splitText, originLine, splitTextNew, rawTextNew,
    gbkTempFile, gbkWriteStream,
    fields, rawImport, assoc, containsFailed, featureKeys
  },

  (*
  Import specific fields from GenBank files and reformat to developer-friendly nested association.
  For whatever reason, the Import[] statement for GenBank files requires doubly-listed fields,
  hence the use of Import[file, {fields}] rather than Import[file, fields].
  *)

  (*
  Bug: The MM import function for GenBank files misses the last feature.
  AsanaTask for Bug: https://app.asana.com/0/1203936519415083/1204121841299926/f
  Inject text to create a fake last feature. Save as gbk file to temp directory.
  *)
  rawText = Import[file, "Text"];
  splitText = StringSplit[rawText, "\n"];
  originLine = First@First@Position[splitText, "ORIGIN"];
  (* The spaces before placeholder text are required.*)
  splitTextNew = Join[splitText[[1;;originLine-1]], {"     PLACEHOLDER_TEXT_FOR_FEATURE_PARSING"}, splitText[[originLine;;]]];
  rawTextNew = StringRiffle[splitTextNew, "\n"];
  gbkTempFile = FileNameJoin[{$TemporaryDirectory, generateRandomString[], ".gbk"}];
  CreateFile[gbkTempFile];
  gbkWriteStream = OpenWrite[gbkTempFile];
  WriteString[gbkWriteStream, rawTextNew];
  Close[gbkWriteStream];

  (* Load the new file. *)
  fields = {"Locus", "Keywords", "Features", "Sequence"};
  rawImport = Quiet[Import[gbkTempFile, {fields}], {Import::noelem, Part::partw}];

  (* Map fields to values in Association. *)
  assoc = Association@MapThread[#1 -> #2 &, {fields, rawImport}];

  (* Check for $Failed in association. "Keywords" is the only field which may have $Failed. *)
  (* ContainsAny checks for elements of list2 in list1, hence the use of {True}, rather than just True for second arg. *)
  containsFailed = ContainsAny[
    Map[MatchQ[#, $Failed]&, Lookup[assoc, {"Locus", "Features", "Sequence"}]],
    {True}];
  If[containsFailed,
    Return["Invalid GenBank File!"]
  ];

  (* Convert Locus and Features key-values to Associations *)
  assoc["Locus"] = Association@assoc["Locus"];
  assoc["Features"] = Association@assoc["Features"];

  (* Reformat the Features *)
  (*
  Features are already classified and grouped into the following Keys:
     CodingSequence, Enhancer, PolyASignal, PrimerBindingSite, Promoter, ProteinBindingSite, ReplicationOrigin, Source

  Map over the feature sets and convert each individual feature into an association. Note that if a feature set contains
  only one feature, MM returns a list rather than a list of lists. Check for this while mapping over feature sets, and
  if true, wrap set in additional list so all key-values are formatted identically.
  *)
  featureKeys = Keys[assoc["Features"]];

  (* Fix listedness and convert to associations. *)
  assoc["Features"] = Map[
    If[
      MatchQ[Head[#[[1]]], Rule], (* Dirty check for if list of rules (single feature) or list of lists. *)
      {Association[#]},
      (Association /@ #) (* Using Map Shorthand (/@) allows us to avoid writing out explicit functions in nested map. *)
    ]&,
    assoc["Features"]
  ];

  (* Return GenBank Association *)
  assoc

];

NestedLookup[assoc_Association, keys_List] := Fold[Lookup[#1, #2, $Failed]&, assoc, keys];

Options[generateAnnulusFeatureGraphics]  = {
  Arrow -> "Stop", ArrowHeight -> 0.5, Color -> GrayLevel[0.2],
  FontColor -> GrayLevel[0.2], FontFamily -> "Helvetica", FontSize -> Scaled[0.02], FontSpacing -> 0.055,
  Center -> {0, 0}, Radii -> {0, 2}, Labels -> True
};
generateAnnulusFeatureGraphics[features_, numBasePairs_, OptionsPattern[]] := Module[
  {
    featureLocations, featureDirections, featureLabels, featureStrands, featureAngles,
    arrowRules, featureAnnulusGraphics, featureLabelGraphics
  },

  If[MatchQ[features, $Failed], Return[Null]];

  {featureLocations, featureDirections, featureLabels} = Transpose[Lookup[features, {"Location", "Direction", "Label"}, Null]];
  featureLocations = featureLocations[[All, 1]];
  featureStrands = featureLocations[[All, 2]];
  (* Special check for features crossing origin. *)
  featureAngles = Map[
    If[#[[1]] <= #[[2]],
      ((-2*Pi*#/numBasePairs) + Pi/2),
      ((-2*Pi*#/numBasePairs) + Pi/2) + {2*Pi, 0}
    ]&,
    featureLocations
  ];

  arrowRules = {"RIGHT"->"Start", "LEFT"->"Stop", Null->"None"};
  featureAnnulusGraphics = MapThread[
    annulusWithArrow[OptionValue[Center], OptionValue[Radii], SortBy[#1, N], Color -> OptionValue[Color], Arrow->#2/.arrowRules]&,
    {featureAngles, featureDirections}
  ];

  featureLabelGraphics = MapThread[
    (* Rough check to see if feature label fits. *)
    If[StringLength[#2] <= Subtract@@#1/(Pi/48),
      sequenceLabel[#2, Mean[OptionValue[Radii]], Mean[#1]]
    ]&,
    {featureAngles, featureLabels}
  ];

  {featureAnnulusGraphics, If[OptionValue[Labels], featureLabelGraphics, Nothing]}

];

generateSiteFeatureGraphics[features_, numBasePairs_] := Module[
  {
    primerBindingSites,
    primerBindingSiteLabels, primerBindingSiteLocations, primerBindingSiteStrands,
    primerBindingSiteAngles, primerBindingSitexy, primerBindingSiteReformatted,
    inputLeft, fixedLabelsLeft, inputRight, fixedLabelsRight, fixedLabelsAll,
    primerBindingSitesTopStrand, primerBindingSitesBottomStrand,
    labelsTopStrand, anglesTopStrand, plotAnglesTopStrand,
    topStrandGraphicsSite, topStrandGraphicsSequence,
    labelsBottomStrand, anglesBottomStrand, plotAnglesBottomStrand,
    bottomStrandGraphicsSite, bottomStrandGraphicsSequence
  },

  (* Rename input features, and lookup key components. *)
  primerBindingSites = features;
  {primerBindingSiteLabels, primerBindingSiteLocations} = Transpose[Lookup[primerBindingSites, {"Label", "Location"}]];
  primerBindingSiteStrands = primerBindingSiteLocations[[All, 2]];

  (*
  Calculate the angle and corresponding unit circle xy at which the feature occurs.
  Reformat in new association needed for distribution algorithm.
  *)
  primerBindingSiteAngles = Map[(-2*Pi*Mean[#]/numBasePairs + Pi/2)&, primerBindingSiteLocations[[All, 1]]];
  primerBindingSitexy = Map[{Cos[#], Sin[#]}&, primerBindingSiteAngles];
  primerBindingSiteReformatted = MapThread[
    <|"Label"->#1, "Location"->#2, "Strand"-> #3, "Angle"->#4, "xPos"->#5[[1]], "yPos"->#5[[2]]|>&,
    {primerBindingSiteLabels, primerBindingSiteLocations, primerBindingSiteStrands, primerBindingSiteAngles, primerBindingSitexy}
  ];

  (* Get features on left half of graphic and distribute. *)
  inputLeft = Map[
    If[(Mod[Lookup[#, "Angle"], 2*Pi] >= Pi/2 && Mod[Lookup[#,"Angle"], 2*Pi] <= 3*Pi/2), #, Nothing]&,
    primerBindingSiteReformatted
  ];
  fixedLabelsLeft = setSiteLabelPositions[inputLeft];

  (* Get features on right half of graphic and distribute. *)
  inputRight = Map[
    If[(Mod[Lookup[#, "Angle"], 2*Pi] < Pi/2 || Mod[Lookup[#,"Angle"], 2*Pi] > 3*Pi/2), #, Nothing]&,
    primerBindingSiteReformatted
  ];
  fixedLabelsRight = setSiteLabelPositions[inputRight];

  (* Recombine and regroup into top/bottom strand features so we can adjust plot positions accordingly. *)
  fixedLabelsAll = Join[fixedLabelsLeft, fixedLabelsRight];
  primerBindingSitesTopStrand = Map[If[#["Strand"] == "TopStrand", #, Nothing]&, fixedLabelsAll];
  primerBindingSitesBottomStrand = Map[If[#["Strand"] == "BottomStrand", #, Nothing]&, fixedLabelsAll];

  (* Generate top strand labels and sequence markers. *)
  {labelsTopStrand, anglesTopStrand, plotAnglesTopStrand} =
      Transpose[Lookup[primerBindingSitesTopStrand, {"Label", "Angle", "PlotAngle"}]];
  topStrandGraphicsSite = MapThread[
    siteLabel[#1, #2, #3, FontColor->GrayLevel[0.2], RadiusPoints->{2.10, 2.15, 2.25}]&,
    {labelsTopStrand, anglesTopStrand, plotAnglesTopStrand}
  ];
  topStrandGraphicsSequence = generateAnnulusFeatureGraphics[primerBindingSitesTopStrand, numBasePairs,
    Radii->{2.12,2.14}, Color->GrayLevel[0.4], Labels->False];

  (* Generate bottom strand labels and sequence markers. *)
  {labelsBottomStrand, anglesBottomStrand, plotAnglesBottomStrand} =
      Transpose[Lookup[primerBindingSitesBottomStrand, {"Label", "Angle", "PlotAngle"}]];
  bottomStrandGraphicsSite = MapThread[
    siteLabel[#1, #2, #3, FontColor->GrayLevel[0.2], RadiusPoints->{1.85, 2.15, 2.25}]&,
    {labelsBottomStrand, anglesBottomStrand, plotAnglesBottomStrand}
  ];
  bottomStrandGraphicsSequence = generateAnnulusFeatureGraphics[primerBindingSitesBottomStrand, numBasePairs,
    Radii->{1.86,1.88}, Color->GrayLevel[0.4], Labels->False];

  (* Return graphics objects *)
  {topStrandGraphicsSite, topStrandGraphicsSequence, bottomStrandGraphicsSite, bottomStrandGraphicsSequence}

];


(* ::Subsection:: *)
(* Secondary Helper Functions *)
(* ::Subsubsection:: *)
(* Misc. *)
generateRandomString[] := Module[{validCharacters},
  (* 62^32 = 6.28e57 possible combination *)
  validCharacters = Flatten[
    {Alphabet[], ToUpperCase@Alphabet[],
      {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}}
  ];
  StringJoin@RandomChoice[validCharacters, 32]
];


(* ::Subsubsection:: *)
(* Graphics. *)

(* Arrow options are: Start, Stop, Both, None. *)
Options[annulusWithArrow] = {Arrow->"Stop", ArrowHeight->0.5, Color->GrayLevel[0.2]};
annulusWithArrow[center:{_, _}, radii:{_, _}, arcSpan:{_, _}, OptionsPattern[]] := Module[
  {
    rInner, rOuter, rMidpoint, arcStart, arcStop, arcBuffer,
    annulusGraphicStart, annulusGraphicStop, annulusGraphicBoth, annulusGraphicNone,
    arrowLinesStart, arrowGraphicStart, seamLineStart,
    arrowLinesStop, arrowGraphicStop, seamLineStop

  },

  {rInner, rOuter} = radii;
  rMidpoint = Mean[radii];
  {arcStart, arcStop} = arcSpan;

  (*
  The arcBuffer is an angle proportional to the thickness of the annulus (rOuter-rInner)
  and the radius (rMidpoint), such that the height (arc length) of the arrow is half the thickness of the annulus.
  *)
  arcBuffer = OptionValue[ArrowHeight]*(rOuter - rInner)/rMidpoint;
  arcBuffer = If[MatchQ[OptionValue[Arrow], "None"], 0, arcBuffer];

  (* Check if arcBuffer is longer than actual arc. For double-ended arrow, check if twice arcBuffer longer. *)
  If[(arcBuffer >= (arcStop-arcStart) && MatchQ[OptionValue[Arrow], Alternatives["Start", "Stop"]]),
    Return[arrowOnly[center, radii, arcSpan, Arrow->OptionValue[Arrow], Color->OptionValue[Color]]];
  ];
  If[(2*arcBuffer >= (arcStop-arcStart) && MatchQ[OptionValue[Arrow], "Both"]),
    Return[arrowOnly[center, radii, arcSpan, Arrow->OptionValue[Arrow], Color->OptionValue[Color]]];
  ];

  (*
  Create Annulus graphic, subtracting the arcBuffer angle from the original arc angle, such that the total
  angle of the resulting arc with arrow is equal to the original angle span.
  Create annulus graphics for all Arrow cases, and just return the needed one.
  *)
  annulusGraphicStart = Annulus[center, radii, arcSpan + {arcBuffer, 0}];
  annulusGraphicStop = Annulus[center, radii, arcSpan + {0, -arcBuffer}];
  annulusGraphicBoth = Annulus[center, radii, arcSpan + {arcBuffer, -arcBuffer}];
  annulusGraphicNone = Annulus[center, radii, arcSpan];

  (*
  Create lines for arrow graphics. Convert to a polygon.
  Calculate arrow lines for start and stop all times since not expensive and saves on repeated code in the 'Both' case.
  *)
  arrowLinesStart = Line[{
    rInner * {Cos[arcStart + arcBuffer], Sin[arcStart + arcBuffer]} ,
    rMidpoint * {Cos[arcStart], Sin[arcStart]},
    rOuter * {Cos[arcStart + arcBuffer], Sin[arcStart + arcBuffer]}
  }];
  arrowGraphicStart = Polygon[Join @@ arrowLinesStart];

  arrowLinesStop = Line[{
    rInner *{Cos[arcStop - arcBuffer], Sin[arcStop - arcBuffer]} ,
    rMidpoint *{Cos[arcStop], Sin[arcStop]},
    rOuter *{Cos[arcStop - arcBuffer], Sin[arcStop - arcBuffer ]}
  }];
  arrowGraphicStop = Polygon[Join @@ arrowLinesStop];

  (* Extra line at seam of annulus and arrow head to eliminate small gap between two graphics objects. *)
  seamLineStart = Line[{
    (rInner) *{Cos[arcStart + arcBuffer], Sin[arcStart + arcBuffer]},
    (rOuter) *{Cos[arcStart + arcBuffer], Sin[arcStart + arcBuffer]}
  }];

  seamLineStop = Line[{
    (rInner) *{Cos[arcStop - arcBuffer], Sin[arcStop - arcBuffer]},
    (rOuter) *{Cos[arcStop - arcBuffer], Sin[arcStop - arcBuffer]}
  }];

  (* Return set of objects to be wrapped in Graphics[], based on if we need arrows at Start, Stop, or Both. *)
  Which[
    MatchQ[OptionValue[Arrow], "Start"],
    {OptionValue[Color], annulusGraphicStart, arrowGraphicStart, seamLineStart},
    MatchQ[OptionValue[Arrow], "Stop"],
    {OptionValue[Color], annulusGraphicStop, arrowGraphicStop, seamLineStop},
    MatchQ[OptionValue[Arrow], "Both"],
    {OptionValue[Color], annulusGraphicBoth, arrowGraphicStart, seamLineStart, arrowGraphicStop, seamLineStop},
    MatchQ[OptionValue[Arrow], "None"],
    {OptionValue[Color], annulusGraphicNone}
  ]

];


Options[arrowOnly] = {Arrow->"Stop", Color->GrayLevel[0.8]};
arrowOnly[center:{_, _}, radii:{_, _}, arcSpan:{_, _}, OptionsPattern[]] := Module[
  {
    rInner, rOuter, rMidpoint, arcStart, arcStop, arcMidpoint,
    arrowLines, arrowGraphic
  },

  {rInner, rOuter} = radii;
  rMidpoint = Mean[radii];
  {arcStart, arcStop} = arcSpan;
  arcMidpoint = Mean[arcSpan];

  arrowLines = Which[
    MatchQ[OptionValue[Arrow], "Start"],
    Line[{
      rInner * {Cos[arcStop], Sin[arcStop]} ,
      rMidpoint * {Cos[arcStart], Sin[arcStart]},
      rOuter * {Cos[arcStop], Sin[arcStop]}
    }],

    MatchQ[OptionValue[Arrow], "Stop"],
    Line[{
      rInner * {Cos[arcStart], Sin[arcStart]},
      rMidpoint * {Cos[arcStop], Sin[arcStop]},
      rOuter * {Cos[arcStart], Sin[arcStart]}
    }],

    MatchQ[OptionValue[Arrow], "Both"],
    Line[{
      rMidpoint * {Cos[arcStart], Sin[arcStart]},
      rInner * {Cos[arcMidpoint], Sin[arcMidpoint]},
      rMidpoint * {Cos[arcStop], Sin[arcStop]},
      rOuter * {Cos[arcMidpoint], Sin[arcMidpoint]}
    }]
  ];

  arrowGraphic = Polygon[Join @@ arrowLines];
  {OptionValue[Color], arrowGraphic}

];


Options[hollowAnnulusWithArrow] = {Arrow->"Stop", ArrowHeight->0.5, EdgeThickness->0.025, EdgeColor->GrayLevel[0.2], HoleColor->White};
hollowAnnulusWithArrow[center:{_, _}, radii:{_, _}, arcSpan:{_, _}, OptionsPattern[]] := Module[
  {
    edgeThickness,
    rInner, rOuter, rMidpoint,
    arcBufferEdge, arcBufferHole, arcBufferDiff,
    edgeAnnulus, arcSpanHole, holeAnnulus
  },
  edgeThickness = OptionValue[EdgeThickness];

  (*
  Since the inner annulus is thinner, the arcBuffer is smaller, and the annulus edges become misaligned.
  Thus we compute the difference of the 'edge' and 'hole' arcBuffers so that we can realign the annulus edges.
  *)
  {rInner, rOuter} = radii;
  rMidpoint = Mean[radii];
  arcBufferEdge = OptionValue[ArrowHeight]*(rOuter - rInner)/rMidpoint;
  arcBufferHole = OptionValue[ArrowHeight]*(rOuter - rInner - 2*edgeThickness)/rMidpoint;
  If[arcBufferHole <= 0, Return[Nothing]];
  arcBufferDiff = arcBufferEdge - arcBufferHole;

  (*
  The angle for the hole annulus must be shifted by a specific amount proportional to its radius,
  (which for the inner hole radius is rInner+edgeThickness) and the edgeThickness to give the desired edge width.
  *)
  edgeAnnulus = annulusWithArrow[center, radii, arcSpan,
    Arrow->OptionValue[Arrow], ArrowHeight->OptionValue[ArrowHeight], Color->OptionValue[EdgeColor]];
  arcSpanHole = Which[
    MatchQ[OptionValue[Arrow], "Start"],
    arcSpan + {arcBufferDiff, -edgeThickness/(rInner + edgeThickness)},
    MatchQ[OptionValue[Arrow], "Stop"],
    arcSpan + {edgeThickness/(rInner + edgeThickness), -arcBufferDiff},
    MatchQ[OptionValue[Arrow], "Both"],
    arcSpan + {arcBufferDiff, -arcBufferDiff},
    MatchQ[OptionValue[Arrow], "None"],
    arcSpan + {arcBufferDiff, -arcBufferDiff}
  ];
  If[arcSpanHole[[1]] >= arcSpanHole[[2]],
    Return[{edgeAnnulus}]
  ];
  (* TODO: If hits arrowOnly overload, hole portion is not drawn. *)

  holeAnnulus = annulusWithArrow[center, radii + {edgeThickness, -edgeThickness}, arcSpanHole,
    Arrow->OptionValue[Arrow], ArrowHeight->OptionValue[ArrowHeight], Color->OptionValue[HoleColor]];

  (* Return set of objects to be wrapped in Graphics[]. *)
  {edgeAnnulus, holeAnnulus}

  (*
  (* Variant: Draw holeAnnulus and arrow explicitly, rather than using annulusWithArrow fxn because the hole annulus
  needs to be shifted differently than the fxn draws it to give correct edge thickness appearance. *)
  holeArrowLines = Line[{
    (rInner+edgeThickness)*{Cos[(arcSpan-arcBufferEdge)[[2]]], Sin[(arcSpan-arcBufferEdge)[[2]]]},
    rMidpoint*{Cos[(arcSpan-edgeThickness/rMidpoint)[[2]]], Sin[(arcSpan-edgeThickness/rMidpoint)[[2]]]},
    (rOuter-edgeThickness)*{Cos[(arcSpan-arcBufferEdge)[[2]]], Sin[(arcSpan-arcBufferEdge)[[2]]]}
  }];
  holeArrowGraphic = Polygon[Join @@ holeArrowLines];
  holeGraphic = Annulus[center, radii + {edgeThickness, -edgeThickness}, arcSpan + {arcBufferDiff, -arcBufferEdge}];

  (* Return set of objects to be wrapped in Graphics[]. *)
  {edgeAnnulus, LightBlue, holeGraphic, holeArrowGraphic}
  *)

];


Options[siteLabel] = {
  FontColor->GrayLevel[0.2], FontFamily->"Helvetica", FontSize->Scaled[0.02],
  LineColor->GrayLevel[0.2], LineThickness->0.001,
  RadiusPoints->{1.85, 2.15, 2.25}
};
siteLabel[txt_String, angle1_, angle2_, OptionsPattern[]] := Module[
  {
    rStart, rMid, rStop,
    startPoint, midPoint, modAngle, stopPoint, alignment
  },

  (* Site Label is for generating labels with label lines, which sit outside the plasmid circle plot. *)
  {rStart, rMid, rStop} = OptionValue[RadiusPoints];
  startPoint = rStart*{Cos[angle1], Sin[angle1]};
  midPoint = rMid*{Cos[angle1], Sin[angle1]};
  modAngle = Mod[angle1, 2*Pi];
  stopPoint = If[
    (modAngle > Pi/2 && modAngle < 3*Pi/2),
    rStop*{Cos[angle2], Sin[angle2]} + {-0.5, 0},
    rStop*{Cos[angle2], Sin[angle2]} + {0.5, 0}
  ];
  alignment = If[
    (modAngle > Pi/2 && modAngle < 3*Pi/2),
    {1, 0},
    {-1, 0}
  ];
  {
    Thickness[OptionValue[LineThickness]],
    OptionValue[LineColor],
    Line[{startPoint, midPoint, stopPoint}],
    Text[
      Style[txt, OptionValue[FontColor], FontFamily->"Helvetica", FontSize->OptionValue[FontSize]],
      stopPoint*{1.02,1},
      alignment
    ]
  }

];


Options[sequenceLabel] = {FontColor->GrayLevel[0.2], FontFamily->"Helvetica", FontSize->Scaled[0.02], FontSpacing->0.055};
sequenceLabel[txt_String, radius_, angle_, OptionsPattern[]] := Module[
  {
    numChars, sBar, dTheta, thetaRange, modAngle
  },

  (* Sequence Label is for generating labels which lay along the arcs within the plasmid circle plot. *)
  (* TODO: Add check for arc length of text vs arc length of sequence. Also Font Size, color etc. *)

  numChars = Length[Characters[txt]];
  sBar = OptionValue[FontSpacing]; (* Hard-coded spacing between characters. *)
  dTheta = sBar * numChars / radius; (* Angle span required by text. *)
  thetaRange = angle + {-0.5*dTheta, 0.5*dTheta}; (* Start/stop angle of text centered at angle. *)

  (*
  If angle position is on top half of circle, text should be concave down, and vice-versa.
  Use Mod to make the above check easy.
  *)
  modAngle = Mod[angle, 2*Pi];
  If[(modAngle > 0 && modAngle <= Pi),
    curvedTextDown[txt, radius, thetaRange, FontFamily->OptionValue[FontFamily], FontSize->OptionValue[FontSize]],
    curvedTextUp[txt, radius, thetaRange, FontFamily->OptionValue[FontFamily], FontSize->OptionValue[FontSize]]
  ]
];


Options[curvedTextDown] = {FontColor->GrayLevel[0.2], FontFamily->"Helvetica", FontSize->Scaled[0.02]};
curvedTextDown[txt_String, radius_, arcSpan:{_, _}, OptionsPattern[]] :=Module[
  {
    txtAsChars, numChars, arcStart, arcStop, range, coords
  },

  txtAsChars = Characters[txt];
  numChars = Length[txtAsChars];
  {arcStart, arcStop} = arcSpan;

  (* Get the angle of each individual character in the string, and convert to {x,y} coordinates. *)
  range = If[!MatchQ[numChars,1],
    Range[arcStart, arcStop, (arcStop - arcStart)/(numChars - 1)],
    {Mean[arcSpan]}
  ];
  coords = Map[radius*{Cos[#], Sin[#]}&, range];

  (* Map over each character, assigning position and rotation using above values. *)
  MapThread[
    Rotate[
      Text[Style[#1,  FontColor->OptionValue[FontColor], FontFamily->OptionValue[FontFamily], FontSize->OptionValue[FontSize]], #2],
      -Pi/2 + #3 (* Rotate by -90 degrees (clockwise), plus angle position to orient to center of circle. *)
    ]&,

    (* Reverse text since radians go counter-clockwise. *)
    {Reverse[txtAsChars], coords, range}
  ]
];


Options[curvedTextUp] = {FontColor->GrayLevel[0.2], FontFamily->"Helvetica", FontSize->Scaled[0.02]};
curvedTextUp[txt_String,  radius_, arcSpan:{_, _}, OptionsPattern[]] :=Module[
  {
    txtAsChars, numChars, arcStart, arcStop, range, coords
  },

  txtAsChars = Characters[txt];
  numChars = Length[txtAsChars];
  {arcStart, arcStop} = arcSpan;

  (* Get the angle of each individual character in the string, and convert to {x,y} coordinates. *)
  range = If[!MatchQ[numChars,1],
    Range[arcStart, arcStop, (arcStop - arcStart)/(numChars - 1)],
    {Mean[arcSpan]}
  ];
  coords = Map[radius*{Cos[#], Sin[#]}&, range];

  (* Map over each character, assigning position and rotation using above values. *)
  MapThread[
    Rotate[
      Text[Style[#1, FontColor->OptionValue[FontColor], FontFamily->OptionValue[FontFamily], FontSize->OptionValue[FontSize]], #2],
      -3*Pi/2 + #3 (* Rotate by -270 degrees (clockwise), plus angle position to orient to center of circle. *)
    ]&,

    (* Do NOT reverse text here, since we rotate extra above. *)
    {txtAsChars, coords, range}
  ]
];


Options[basePairTicks] = {
  FontColor->GrayLevel[0.2], FontFamily->"Helvetica", FontSize->Scaled[0.02], FontSpacing->0.055,
  TickHeight->0.05, TickThickness->0.0025, Radius->1.9
};
basePairTicks[numBasePairs_Integer, tickFreq_Integer, OptionsPattern[]] := Module[
  {
    r, tickValues, tickAngles, tickPositions, tickGraphics,
    tickLabels, tickLabelGraphics
  },

  r = OptionValue[Radius];

  (* Always add Tick at 1, regardless of tickFreq. *)
  tickValues = Join[{1},Range[tickFreq, numBasePairs, tickFreq]];
  tickAngles = -2*Pi*tickValues/numBasePairs + Pi/2;
  tickPositions = Map[{
    (r-OptionValue[TickHeight])*{Cos[#], Sin[#]},
    r*{Cos[#], Sin[#]}
  }&,tickAngles];
  tickGraphics = Map[Line[#]&, tickPositions];

  tickLabels = Map[ToString[#]&, tickValues];
  tickLabelGraphics = MapThread[
    sequenceLabel[#1, r-0.1-OptionValue[TickHeight], #2,
      FontColor->OptionValue[FontColor], FontFamily->OptionValue[FontFamily],
      FontSize->OptionValue[FontSize], FontSpacing->OptionValue[FontSpacing]]&,
    {tickLabels, tickAngles}];

  {OptionValue[FontColor], Thickness[OptionValue[TickThickness]], tickGraphics, tickLabelGraphics}

];


(* ::Subsubsection:: *)
(* Site Label Distribution Algorithm Functions *)

Options[SortAssocListBy] = {Reverse -> False};
SortAssocListBy[assocList_, key_, OptionsPattern[]] := Module[
  {
    ordering, orderedAssocList
  },
  (* Convert to numeric form with N@ so ordering is by numeric value rather than canonical order of Mathemtica expression. *)
  ordering = Ordering[N@Lookup[assocList, key]];
  ordering = If[OptionValue[Reverse], Reverse[ordering], ordering];
  orderedAssocList = assocList[[ordering]]
];
SortAssocListBy[{}, key_, OptionsPattern[]] := {};


binClump = Clump[{

  (* Save as Clumplate *)
  Clumplate -> True,
  SaveAs -> "PlasmidLabelBin",

  (* Set when initialized *)
  BinNumber, BinRange, BinCenter,

  (* Continually updated during label repositioning. *)
  Active -> {}, Up -> {}, Down -> {},

  (* Computed Properties *)
  <|
    Name -> BinCount,
    Expression :> Length[$This[Active]] + Length[$This[Up]] + Length[$This[Down]],
    Remember -> False
  |>

}];


createBinClump[binNumber_, binRange_] := Clump[{
  InheritFrom -> {"PlasmidLabelBin"},
  BinNumber -> binNumber, BinRange -> binRange, BinCenter -> Mean[binRange]
}];


createPlasmidSiteLabelBins[binSpan_, nBins_Integer] := Module[
  {
    binNumbers, binPoints, binRanges, bins, binManager
  },

  binNumbers = Range[nBins];
  binPoints = Subdivide[Sequence @@ binSpan, nBins];
  binRanges = Map[binPoints[[# ;; # + 1]] &, binNumbers];
  bins = MapThread[createBinClump[#1, #2] &, {binNumbers, binRanges}];

  binManager = Clump[{
    BinPoints -> binPoints,
    BinRange -> {Min[binPoints], Max[binPoints]},
    BinRanges -> binRanges,
    BinSpacing -> Abs[binRanges[[1, 2]] - binRanges[[1, 1]]],
    BinCenters -> Map[Mean[#] &, binRanges],
    NumberOfBins -> nBins,
    MapThread[#1 :> #2 &, {binNumbers, bins}]
  }]

];


BinListsBy[data_List, binspecs__List] := Module[
  (*
  Based on: https://community.wolfram.com/groups/-/m/t/1081009
  *)
  {
    binFxn, binParams, binnedIndicies, idata, out
  },

  binFxn = binspecs[[1]];
  binParams = binspecs[[2;;]];

  (* Map the binning function over the data set. *)
  idata = Transpose[{Map[binFxn, data], Range[Length[data]]}];

  (* Bin by the relevant data, and pseudo-bin by index. *)
  out = BinLists[idata, binParams, {0, Length[data]+1, Length[data]+1}];

  (* Grab the binned indicies. *)
  binnedIndicies = out[[All, 1, All, -1]];
  Map[data[[#]]&, binnedIndicies]

];


binSiteLabelsInitial[siteLabels_, binManager_] :=  Module[
  {
    binMin, binMax, binSpacing, binnedSites, binCenters, listsForActive, activePositions, nonActiveSiteIndicies
  },

  (* Do the initial binning using the BinListsBy. *)
  {binMin, binMax} = binManager[BinRange];
  binSpacing = binManager[BinSpacing];
  binnedSites = BinListsBy[siteLabels, {Lookup[#, "yPos"]&, binMin, binMax, binSpacing}];

  (* Add to the bin clumps, calculating Active, Up and Down labels for the recursive repositioning step. *)
  binCenters = binManager[BinCenters];
  listsForActive = Map[Lookup[#, "yPos", Null]&, binnedSites];
  activePositions = MapThread[
    If[!MatchQ[#1, Null],
      First[Position[Abs[#1 - #2], Min[Abs[#1 - #2]]]],
      {}
    ] &,
    {listsForActive, binCenters}
  ];

  (* Reset $MessageList as a quick-fix to supress ClumpGet::MessagesGenerated until proper fix implemented.
  Since $MessageList is protected, we must un-protect first/ then re-protect. *)
  Unprotect[$MessageList];
  $MessageList = {};
  Protect[$MessageList];

  MapThread[
    If[!MatchQ[#2, {}],
      (
        binManager[#1][Active] = binnedSites[[#1, #2]];
        (*binManager[#1, Active] = binnedSites[[#1, #2]];*)
        (* ^This syntax is also bugged, but will be preferred in future. *)
        (* Exclude non-active index so we can match on sites with same yPos. *)
        nonActiveSiteIndicies = Select[Range[Length[binnedSites[[#1]]]], Function[val, val=!=First@#2]];
        binManager[#1][Up] = SortAssocListBy[Map[
          Function[site, If[site["yPos"] >= binnedSites[[#1, First@#2]]["yPos"], site, Nothing]],
          binnedSites[[#1, nonActiveSiteIndicies]]], "yPos"];
        binManager[#1][Down] =  SortAssocListBy[Map[
          Function[site, If[site["yPos"] < binnedSites[[#1, First@#2]]["yPos"], site, Nothing]],
          binnedSites[[#1, nonActiveSiteIndicies]]], "yPos", Reverse -> True];
      )
    ] &,
    {Range[binManager[NumberOfBins]], activePositions}
  ];

  binCounts = Map[binManager[#][BinCount] &, Range[Length[binCenters]]];

];


repositionLabels[binManager_] := Module[
  {
    binNumbers, binCounts, mostFilledBinIndex
  },

  binNumbers = Range[binManager[NumberOfBins]];
  binCounts = Map[binManager[#][BinCount] &, binNumbers];

  While[Length[Cases[binCounts, GreaterP[1]]] > 0,
    mostFilledBinIndex = First@First@Position[binCounts, Max[binCounts]];
    (* Explicitly needs to be First@First@, rather than First@@, since there can be ties for most-filled. *)
    redistributeBinContents[binManager, mostFilledBinIndex];
    binCounts = Map[binManager[#][BinCount] &, binNumbers];
  ];

];


redistributeBinContents[binManager_, binIndex_] := Module[
  {
    activeLabel, downLabels, upLabels, allLabelsSorted,
    newUpLabels, newUpLabelsSorted,
    indiciesToMapOver,
    newDownLabels, newDownLabelsSorted
  },

  activeLabel = binManager[binIndex][Active];
  downLabels = binManager[binIndex][Down];
  upLabels = binManager[binIndex][Up];
  allLabelsSorted = SortAssocListBy[Join[downLabels, activeLabel, upLabels], "yPos"];

  (* Special cases for edge bins, where we can't shift both down and up. *)
  (* Bin Index = 1 -> Bottom Bin, Can't Shift Down. *)
  If[binIndex == 1,

    (* Get all the labels upstream of the bottom-most label, and sort by position. *)
    newUpLabels = allLabelsSorted[[2;;]];
    newUpLabelsSorted = SortAssocListBy[allLabelsSorted[[2;;]], "yPos"];

    (* Set the new active label for the bin. *)
    binManager[binIndex][Active] = {First@allLabelsSorted};
    binManager[binIndex][Down] = {};
    binManager[binIndex][Up] = {};

    (* Set the active labels for all upstream bins, and re-calculate the up/down. *)
    indiciesToMapOver = Range[binIndex + 1, binIndex + Length[newUpLabelsSorted]] /.
        {GreaterP[binManager[NumberOfBins]] -> binManager[NumberOfBins]};
    MapThread[newActiveLabelExternal[binManager, #1, #2] &, {indiciesToMapOver, newUpLabelsSorted}];

  ];

  (* Bin Index = NumberOfBins -> Top Bin, Can't Shift Up. *)
  If[binIndex == binManager[NumberOfBins],

    (* Get all the labels upstream of the bottom-most label, and sort by position. *)
    newDownLabels = allLabelsSorted[[;;-2]];
    newDownLabelsSorted = Reverse[SortAssocListBy[allLabelsSorted[[;;-2]], "yPos"]];

    (* Set the active labels for all upstream bins, and re calculate the up/down. *)
    indiciesToMapOver = Range[binIndex - 1, binIndex - Length[newDownLabelsSorted], -1] /. {LessP[1] -> 1};
    MapThread[newActiveLabelExternal[binManager, #1, #2] &, {indiciesToMapOver, newDownLabelsSorted}];

    (* Not guaranteed to have an up label. Need to combine all then sort then choose last. *)
    (* Set the new active label for the bin. *)
    binManager[binIndex][Active] = {Last@allLabelsSorted};
    binManager[binIndex][Down] = {};
    binManager[binIndex][Up] = {};

  ];

  (* MiddleBins, Only need to redistribute extra labels. *)
  If[binIndex =!= 1 && binIndex =!= binManager[NumberOfBins],

    binManager[binIndex][Down] = {};
    binManager[binIndex][Up] = {};

    (* Distribute Down *)
    indiciesToMapOver = Range[binIndex - 1, binIndex - Length[downLabels], -1] /. {LessP[1] -> 1};
    MapThread[newActiveLabelExternal[binManager, #1, #2] &, {indiciesToMapOver, downLabels}];

    (* Distribute Up *)
    indiciesToMapOver = Range[binIndex + 1, binIndex + Length[upLabels]] /.
        {GreaterP[binManager[NumberOfBins]] -> binManager[NumberOfBins]};
    MapThread[newActiveLabelExternal[binManager, #1, #2] &, {indiciesToMapOver, upLabels}];

  ];

];


newActiveLabelExternal[binManager_, binIndex_, newLabel_] := Module[
  {
    activeLabel, downLabels, upLabels, allOriginalLabels,
    newLabelyPos,
    newDownLabels, newDownLabelsSorted,
    newUpLabels, newUpLabelsSorted
  },

  (* Grab all the current labels in the bin and combine into a single list. *)
  activeLabel = binManager[binIndex][Active];
  downLabels = binManager[binIndex][Down];
  upLabels = binManager[binIndex][Up];
  allOriginalLabels = Join[activeLabel, downLabels, upLabels];

  (* Determine the new Down and Up labels relative to the to-be-assigned active label. *)
  (* Since the new label is not in the original labels, one of the two cases should be BlahEqualP. *)
  newLabelyPos = newLabel["yPos"];
  newDownLabels = Cases[allOriginalLabels, KeyValuePattern["yPos" -> LessP[newLabelyPos]]];
  newDownLabelsSorted = Reverse[SortAssocListBy[newDownLabels, "yPos"]];

  newUpLabels = Cases[allOriginalLabels, KeyValuePattern["yPos" -> GreaterEqualP[newLabelyPos]]];
  newUpLabelsSorted = SortAssocListBy[newUpLabels, "yPos"];

  (* Set the Active, Down, and Up Labels *)
  binManager[binIndex][Active] = {newLabel};
  binManager[binIndex][Down] = newDownLabelsSorted;
  binManager[binIndex][Up] = newUpLabelsSorted;

];


setSiteLabelPositions[siteLabels_] := Module[
  {
    binMin, binMax, nBins,
    binManager, labelsSorted, yPosFinal, plotAngle, xPosFinal,
    labelLabels, labelLocs, labelStrands, labelAngles
  },
  {binMin, binMax, nBins} = {-1, 1, 30};
  binManager = createPlasmidSiteLabelBins[{binMin, binMax}, nBins];
  binSiteLabelsInitial[siteLabels, binManager];
  repositionLabels[binManager];

  labelsSorted = Flatten[Map[If[binManager[#][Active] =!= {}, binManager[#][Active], Nothing]&, Range[nBins]]];
  yPosFinal = Map[If[binManager[#][Active] =!= {}, binManager[#][BinCenter], Nothing]&, Range[nBins]];
  plotAngle = MapThread[
    If[Mod[labelsSorted[[#1]]["Angle"],2*Pi] <= Pi/2 || Mod[labelsSorted[[#1]]["Angle"],2*Pi] >= 3*Pi/2,
      ArcSin[#2],
      Pi-ArcSin[#2]
    ]&, {Range[Length[yPosFinal]], yPosFinal}
  ];
  xPosFinal = Map[Cos[#]&, plotAngle];

  (* Associations are annoying bc of immutability, so grab all values and piece back together. *)
  {labelLabels, labelLocs, labelStrands, labelAngles} = Transpose[Lookup[labelsSorted, {"Label", "Location", "Strand", "Angle"}]];
  MapThread[<|"Label"->#1, "Location"->#2, "Strand"->#3, "Angle"->#4, "xPos"->#5, "yPos"->#6, "PlotAngle"->#7|>&,
    {labelLabels, labelLocs, labelStrands, labelAngles, xPosFinal, yPosFinal, plotAngle}]

];
