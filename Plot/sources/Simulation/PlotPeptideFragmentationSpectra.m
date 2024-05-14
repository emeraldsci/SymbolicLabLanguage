(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotPeptideFragmentationSpectra*)


(* ::Subsection:: *)
(* Options Definition *)

DefineOptions[PlotPeptideFragmentationSpectra,
  Options :> {
    {
      OptionName->Collapse,
      Default->False,
      Description->"Indicates if the data from the list of inputs should be collapsed onto a single plot.",
      AllowNull->False,
      Widget->Widget[Type->Enumeration, Pattern:> BooleanP]
    },
    {
      OptionName->Title,
      Default->Automatic,
      Description->"Sets the title of the plot.",
      ResolutionDescription -> "By default, the title will be the name of the object being plotted, unless Collpase->True, in which case the title will 'Fragmentation Spectrum'.",
      AllowNull->False,
      Widget->Widget[Type->String,Pattern:>_String, Size -> Line]
    },
    (* Output option for command builder. *)
    OutputOption
  },
  SharedOptions :> {
    ModifyOptions[ListPlotOptions,
      {
        {OptionName -> Frame, Default -> {True, True, True, True}},
        {OptionName -> LabelStyle, Default -> {Bold, 16, FontFamily -> "Arial"}},
        {OptionName -> Filling, Default -> Axis},
        {OptionName -> Joined, Default -> False},
        {OptionName -> ImageSize, Default -> 800},
        {OptionName -> PlotMarkers, Default -> {Automatic, 5.}},
        {OptionName -> PlotStyle, Default -> Lighter[LCHColor[0.2, 1, 0.6], .4]},
        {OptionName -> PlotRange, Default -> {Automatic, {-0.005,1.005}}}
      }
    ],
    ListPlotOptions
  }
];


(* ::Subsection:: *)
(* Graphics Variables *)

$aminoAcidSize = 8;
$aminoAcidPadding = 0;
$aminoAcidXSpacingFactor = 2.5;
$aminoAcidYSpacingFactor = 1;
$aminoAcidFontSize = Scaled[0.8];
$bondLineThickness = Thick;
$bondLineColor = LCHColor[0.4, 0, 0];

$upperPanelEmptyFractionLeft = 0.05;
$upperPanelFragmentFraction = 0.75;
$upperPanelTextFraction = 0.15;
$upperPanelTextImagePadding = {{10, 10}, {0,0}};
$upperPanelHeightFraction = 0.15;

$gridFrame = {None, None, {{1,1}, {2,3}}->True}; (* Rows 1 to 1, Columns 2 to 3. *)
$frameColor = LCHColor[0.75, 0, 0];
$ionTextFontSize = Scaled[0.125];
$fontColor = LCHColor[0.4, 0, 0];

$highlightColor = LCHColor[0.7, 1, 0.1];
$highlightDiskSize = Scaled[0.025];
$highlightLineThickness = Thickness[0.005];

aminoAcidColor["G" | "A" | "S" | "T"] := Lighter[LCHColor[0.9, 1, 0.2], .4]; (* Yellow *)
aminoAcidColor["C" | "V" | "I" | "L" | "P" | "F" | "Y" | "M" | "W"] := Lighter[LCHColor[0.6, 1, 0.5], .4]; (* Green *)
aminoAcidColor["N" | "Q" | "H"] := Lighter[LCHColor[0.7, 0.9, 1], .4]; (* Pink *)
aminoAcidColor["D" | "E"] := Lighter[LCHColor[0.7, 1, 0.1], .4]; (* Red *)
aminoAcidColor["K" | "R"] := Lighter[LCHColor[0.6, 1, 0.7], .4]; (* Blue *)


(* ::Subsection:: *)
(* PlotPeptideFragmentationSpectra *)

(* Input Patterns *)
plotPeptideFragmentationSpectraSingletonP = ObjectP[{
  Object[Simulation, FragmentationSpectra],
  Object[MassFragmentationSpectrum]
}];
plotPeptideFragmentationSpectraListableP = {plotPeptideFragmentationSpectraSingletonP..};
plotPeptideFragmentationSpectraP = plotPeptideFragmentationSpectraSingletonP | plotPeptideFragmentationSpectraListableP;


(* Singleton Overload *)
PlotPeptideFragmentationSpectra[in:plotPeptideFragmentationSpectraSingletonP, ops:OptionsPattern[]] := Module[
  {
    coordsAndAssocs, data, graphPacket,
    finalOps, finalPlot, outputValue
  },

  (* Batch download the data. *)
  coordsAndAssocs = downloadAndFormatData[in, ops];
  {data, graphPacket} = First@coordsAndAssocs;

  (* Pass to main function. *)
  {finalOps, finalPlot} = plotPeptideFragmentationSpectra[in, data, graphPacket, ops];

  (* Format output based on output option. *)
  outputValue = Lookup[finalOps, Output];
  outputValue /. {
    Result->finalPlot,
    Options->RemoveHiddenOptions[ListPlot,finalOps],
    Preview->finalPlot,
    Tests->{}
  }

];

(* Listable Overload *)
PlotPeptideFragmentationSpectra[in:plotPeptideFragmentationSpectraListableP, ops:OptionsPattern[]] := Module[
  {
    coordsAndAssocs, collapseQ,
    data, graphPacket,
    finalOps, finalPlots, outputValue
  },

  (* Batch download the data. *)
  coordsAndAssocs = downloadAndFormatData[in, ops];

  (* If Collapse option is True, call First rather than transpose, and don't use Map or Slide view. *)
  collapseQ = Lookup[{ops}, Collapse, False];
  If[collapseQ,
    (* Collapsed Case *)
    (
      (* Unpack data and graphPackets. *)
      {data, graphPacket} = First@coordsAndAssocs;

      (* Pass to main function. *)
      {finalOps, finalPlots} = plotPeptideFragmentationSpectra[in, data, graphPacket, ops];

      (* Format output based on output option. *)
      outputValue = Lookup[finalOps, Output];
      outputValue /. {
        Result->finalPlots,
        Options->RemoveHiddenOptions[ListPlot,finalOps],
        Preview->finalPlots,
        Tests->{}
      }

    ),

    (* Non-collapsed Case*)
    (
      (* Unpack data and graphPackets. *)
      {data, graphPacket} = Transpose[coordsAndAssocs];

      (* Map the plot function over the inputs. *)
      {finalOps, finalPlots} = Transpose[MapThread[plotPeptideFragmentationSpectra[#1, #2, #3, ops]&, {in, data, graphPacket}]];

      (* Format output based on output option. *)
      (* Output option will be the same across all option sets. *)
      outputValue = Lookup[finalOps[[1]], Output];
      outputValue /. {
        Result->SlideView[finalPlots],
        Options->Map[RemoveHiddenOptions[ListPlot,#]&, finalOps],
        Preview->SlideView[finalPlots],
        Tests->{}
      }

    )
  ]

];

(* Main Function *)
plotPeptideFragmentationSpectra[in_, data_, graphPacket_, ops:OptionsPattern[]] := Module[
  {
    safeOps, listPlotOptions,
    imageSize, labelStyle,
    leftSpaceFillGraphic,
    title, plotTitle,
    finalPlot
  },

  (* Generate ListPlotOptions. *)
  {safeOps, listPlotOptions} = resolveOptions[{ops}];

  (* Lookup specific option values used in other parts of the code. *)
  imageSize = Lookup[listPlotOptions, ImageSize];
  labelStyle = Lookup[listPlotOptions, LabelStyle];
  title = Lookup[safeOps, Title];

  (* Use the input to generate a title, if not already specified via options. Add new line to title for spacing. *)
  plotTitle = If[MatchQ[title, Automatic],
    generateTitle[in],
    title
  ];
  plotTitle = StringJoin["\n", ToString[plotTitle]];

  (* Create empty graphics to help align elements of the plot. *)
  leftSpaceFillGraphic = Graphics[{}, ImageSize->{
    $upperPanelEmptyFractionLeft*imageSize,
    $upperPanelHeightFraction*imageSize
  }];

  (* Start the dynamic module containing the event handler that tracks mouse clicks at a given position. *)
  finalPlot = DynamicModule[

    (* Dynamic Vars *)
    {
      (* With initial values. *)
      fragmentGraphic = "Right-click on a point to display the fragment.",
      textGraphic = "",
      mousePosition = {0., 0.},
      highlightPosition = {0,0},
      highlightColor = RGBColor[0,0,0,0], (* Fully transparent to start. *)

      (* Without initial values. *)
      dynamicListPlotOptions,
      pointDataAssoc,
      fragment, ionLabel, mz, mass, charge,
      sequenceSingleLetterForm
    },

    (* Dynamic Expression *)
    (* Make a dynamic epilog in the list plot. *)
    dynamicListPlotOptions = appendToEpilog[
      listPlotOptions,

      (* Highlight the selected point. *)
      {
        Inset[
          Graphics[
            {Dynamic[highlightColor], Disk[]}
          ],
          Dynamic[highlightPosition],
          {0,0}, $highlightDiskSize
        ],
        Dynamic[highlightColor], $highlightLineThickness, Line[{{Dynamic[highlightPosition[[1]]], 0}, Dynamic[highlightPosition]}]
      }

    ];


    (* Generate the graphic. *)
    (*
      The main graphic is a 3x2 grid, in which the top graphics are: a blank spacing graphic, the fragment metadata,
      and the fragment graphic. The bottom graphic is the spectrum plot (all cells merged).
    *)
    Grid[
      {
        (* Upper two panels. *)
        {leftSpaceFillGraphic, Dynamic[textGraphic], Dynamic[fragmentGraphic]},

        (* Lower Panel. *)
        {EventHandler[

          (* Expression - Update the Zoomable Plot.*)
          Zoomable[
            Labeled[
              ListPlot[data, dynamicListPlotOptions],
              {plotTitle}, {Top}, LabelStyle->Join[labelStyle, {FontColor -> $fontColor}]
            ]
          ],

          (* Events *)
          {
            (* Event 1 - Right Mouse Button Clicked. *)
            {"MouseClicked", 2} :> (
              (* Get mouse position when clicked. *)
              mousePosition = MousePosition["Graphics"];

              (* Find MS Properties based on mouse position. *)
              highlightColor = $highlightColor;
              {pointDataAssoc, highlightPosition} = findMSProperty[mousePosition, data, graphPacket];
              {fragment, ionLabel, mz, mass, charge} = Lookup[pointDataAssoc, {"Ions", "IonLabels", "MassToChargeRatios", "Masses", "Charges"}];

              (* Create the fragment graphic. *)
              (* Convert the Strand form of the fragment into a string of single letter code for generating graphics. *)
              sequenceSingleLetterForm = StringJoin@buildingBlocksFromStrand[fragment];
              {fragmentGraphic, textGraphic} = createFragmentGraphic[sequenceSingleLetterForm, ionLabel, mz, mass, charge, imageSize];
            )

          }
        ], SpanFromLeft}
      },
      Frame->$gridFrame, FrameStyle->$frameColor, Alignment->Center
    ]

  ];

  {safeOps, finalPlot}

];


(* ::Subsection:: *)
(* Helper Functions *)

(* ::Subsubsection:: *)
(* Options Resolution *)

resolveOptions[ops_] := Module[
  {
    safeOps, listPlotOptions
  },

  (* Generate the SafeOptions. *)
  safeOps = SafeOptions[PlotPeptideFragmentationSpectra, ops];

  (* Update specific non-user-facing plot options. *)
  safeOps = ReplaceRule[safeOps, FrameLabel -> {"Mass To Charge Ratio [Dalton]", "Relative Intensity"}];

  (* Generate the listPlotOptions using safeOps. Wrap in list. *)
  listPlotOptions = {PassOptions[PlotPeptideFragmentationSpectra, ListPlot, safeOps]};

  (* Return safeOps and listPlotOptions. *)
  {safeOps, listPlotOptions}

];


(* ::Subsubsection:: *)
(* Batch Download Helper Functions *)

(*
 Download the fields directly from the object.
 Fields are doubly listed so that the downloaded data is formatted identically to linked field download.
*)
getDownloadFields[ObjectP[Object[MassFragmentationSpectrum]]] :=
    {{IonLabels, Ions, Masses, Charges, MassToChargeRatios, RelativeIntensities}};

(*
  Download from the linked objects in MassFragmentationSpectra.
  Must have the {} inside the [] for SpectraFields, else it just downloads the first field.
*)
getDownloadFields[ObjectP[Object[Simulation, FragmentationSpectra]]] :=
    MassFragmentationSpectra[{IonLabels, Ions, Masses, Charges, MassToChargeRatios, RelativeIntensities}];

formatData[in_] := Module[
  {
    ionLabels, ions, masses, charges, mz, ints,
    xyCoordData, xyFullDataAssoc
  },

  (*
    The incoming data is formatted as a ragged list like {{ionLabels, ions, masses, charges, mz, ints}..}.
    Transpose the data to {{ionLabels..}, {ions..}, {masses..}, {charges..}, {mz..}, {ints..}},
    then flatten the lists {ionLabels, ions, masses, charges, mz, ints}.
  *)

  {ionLabels, ions, masses, charges, mz, ints}  = Map[Flatten, Transpose@in];
  xyCoordData = Transpose[{mz, ints}];
  xyFullDataAssoc = <|
    "IonLabels" -> ionLabels,
    "Ions" -> ions,
    "Masses" -> masses,
    "Charges" -> charges,
    "MassToChargeRatios" -> mz,
    "RelativeIntensities" -> ints
  |>;

  {xyCoordData, xyFullDataAssoc}

];

downloadAndFormatData[in_, ops:OptionsPattern[]] := Module[
  {
    collapseQ,
    downloadFields, dataRaw,
    mfsPositions, mfsObjects, mfsDownloadFields, mfsDataRaw,
    simPositions, simObjects, simDownloadFields, simDataRaw,
    newOrdering, disorderedDataRaw,
    dataRawReshaped,
    dataFormatted
  },

  (*
    We will massage the download call in all cases so that the data returned has the dimensions:
       {# primary objects, # secondary objects, # fields, _}.
    MassSpec Objects don't actually have a secondary object, so we use listedness to get this to 1.
    We then flatten the secondary object data into a single list, giving the dimensions:
       {# primary objects, # fields, _}.
    'in' is the Object or list of Objects passed to the function.
  *)

  (* Check if we are dealing with a singleton or listable input. *)
  Switch[in,

    (* Singleton Case *)
    ObjectP[],
    (
      (* Add extra list. *)
      downloadFields = {getDownloadFields[in]};
      dataRaw = Download[in, downloadFields];
    ),

    (* Listable Case *)
    {ObjectP[]..},
    (
      (* Map will add extra list. *)
      downloadFields = Map[getDownloadFields, in];

      (*
        List formatting when downloading through linked fields is wierd, and its messy to format a batch download for
        both types simultaneously, and requires more wierd post-processing to correct list dimensions.
        Instead, just do two separate batch downloads, one for each type, and rejoin into a list of data.
      *)
      (* MassFragmentationSpectrum Objects Download. *)
      mfsPositions = Map[First, Position[in, ObjectP[Object[MassFragmentationSpectrum]], {1}]];
      mfsObjects = Part[in, mfsPositions];
      mfsDownloadFields = Part[downloadFields, mfsPositions];
      mfsDataRaw = Download[mfsObjects, mfsDownloadFields];

      (* Simulation, FragmentationSpectra Objects Download. *)
      simPositions = Map[First, Position[in, ObjectP[Object[Simulation, FragmentationSpectra]], {1}]];
      simObjects = Part[in, simPositions];
      simDownloadFields = Part[downloadFields, simPositions];
      (* Fix bad listedness by calling First on the simDownloadFields. Need to call outside of Download because of Holds. *)
      simDownloadFields = First[Part[downloadFields, simPositions], {}];
      simDataRaw = Download[simObjects, simDownloadFields];

      (* Join the data back together. *)
      newOrdering = Ordering[Join[mfsPositions, simPositions]];
      disorderedDataRaw = Join[mfsDataRaw, simDataRaw];
      dataRaw = disorderedDataRaw[[newOrdering]];

      (*
        Lookup Collapse option from Options.
        The check happens BEFORE safe options is resolved, so the option may not be present.
        This option only affects listed inputs.
      *)
      collapseQ = Lookup[{ops}, Collapse, False];
      If[collapseQ,
        (*
          At this point, we have lists of:
              {# primary objects, # secondary objects, # fields, _}.,
          and we need to get to:
              {# fields, # primary objects, # secondary objects, _}
          so that we can completely flatten (collpase) the data.
          Transpose will always swap first two dimensions, so map transpose on the data to get to:
              {# primary objects, # fields, # secondary objects, _}
          and then transpose all of that to finally get to:
              {# fields, # primary objects, # secondary objects, _}.
        *)
        dataRawReshaped =  Transpose[Map[Transpose, dataRaw]];
        (*
          Map flatten to get one list per field, and add back the two outer lists to return us to a form approximating:
              {# primary objects, # secondary objects, # fields, _}
          where # primary objects and # secondary objects both equal 1 (since we collapsed the data).
        *)
        dataRaw = {{Map[Flatten, dataRawReshaped]}};
      ];
    )

  ];

  (* Format the data and Return. *)
  dataFormatted = Map[formatData, dataRaw]

];


(* ::Subsubsection:: *)
(* Transform Data and Select Points *)

getXYFeatures[xyData_]:=Module[
  {
    xVals, yVals,
    xRange, yRange
  },

  (* Get list of all x and y values. *)
  {xVals, yVals} = Transpose[xyData];

  (* Get range (min and max value) of the data. *)
  xRange = MinMax[xVals];
  yRange = MinMax[yVals];

  {xVals, yVals, xRange, yRange}

];

generateXYTransformationFunction[xyData_] := Module[
  {
    xVals, yVals, xRange, yRange,
    xLowerBound, xSpan, yLowerBound, ySpan,
    transformationFunction
  },

  (* Get key features from the xyData. *)
  (* xVals and yVals are unused, but there is not good throwaway var in MM. *)
  {xVals, yVals, xRange, yRange} = getXYFeatures[xyData];

  (* Calculate the bounds and spans. Remove units since this works with mouse position, which is always unitless. *)
  (* xVals = MassToChargeRatios *)
  {xLowerBound, xSpan} = {
    Unitless[xRange[[1]]],
    Unitless[xRange[[2]] - xRange[[1]]]
  };

  (* yVals = RelativeIntensities. *)
  (*
    It is common for the RelativeIntensities to all be 1, in which case we do not want to transform the yValues.
    This can be achieved by replacing yLowerBound with 0 and ySpan with 1.
  *)
  {yLowerBound, ySpan} = If[ContainsOnly[yVals, {1, 1.}],
    {0, 1},
    {
      Unitless[yRange[[1]]],
      Unitless[yRange[[2]] - yRange[[1]]]
    }
  ];

  (* Generate the Transformation Function. *)
  (* With is required because the vars are in a function. *)
  transformationFunction = With[
    {
      xLowerBound = xLowerBound, xSpan = xSpan,
      yLowerBound = yLowerBound, ySpan = ySpan
    },
    Function[xyPoint,
      {
        (xyPoint[[1]] - xLowerBound) / xSpan,
        (xyPoint[[2]] - yLowerBound) / ySpan
      }
    ]
  ];

  (* Return the Transformation Function. *)
  transformationFunction

];

transformXYDataAndPoint[xyData_, xyPoint_] := Module[
  {
    transformationFunction,
    transformedData, transformedPoint
  },

  (* The data will be transformed such that the smallest values will start at 0, and the largest values end at 1. *)
  transformationFunction = generateXYTransformationFunction[xyData];

  (* Map the transformation function over the xyData and the xyPoint (i.e., mouse position). *)
  (* Call Unitless on xyData, since transformation function is unitless. *)
  transformedData =  Map[transformationFunction, Unitless[xyData]];
  transformedPoint = transformationFunction[xyPoint];

  (* Return the transformed data and point. *)
  {transformedData, transformedPoint}

];

findMSProperty[mousePosition_, xyData_, graphData_] := Module[
  {
    xVal, yVal,
    transformedData, transformedPosition,
    nearestPoint, nearestPointIndex,
    pointDataAssoc
  },

  (*
    This is the function called in the dynamic module responsible for updating the plot.
      mousePosition = {x,y} value of the mouse position
      fullDataList = a list of lists of {x,y} values
      graphData = an list of associations of the spectrum properties
  *)

  (* Unpack mouse position. *)
  {xVal, yVal} = mousePosition;

  (*
    Use the Nearest function to find all the {x,y} pairs closest to the mouse position.
    Note:
     - Nearest returns a list of points, in case multiple points are within the same distance.
     - Nearest assumes x and y data have the same scale, so we need to transform the data to select the points correctly.
     - Nearest will always return a point, which may be undesirable in some instances, but use it for now.
  *)
  {transformedData, transformedPosition} = transformXYDataAndPoint[xyData, mousePosition];
  nearestPoint = First[Nearest[transformedData, transformedPosition]];
  nearestPointIndex = First[Position[transformedData, nearestPoint, Heads -> False]];

  (* Lookup feature data associated with that point, Put into new association. *)
  pointDataAssoc = KeyValueMap[#1 -> Part[#2, Sequence@@nearestPointIndex] &, graphData];

  (* Return feature data as association and original untransformed point. *)
  {
    pointDataAssoc,
    Unitless@xyData[[Sequence@@nearestPointIndex]]
  }

];


(* ::Subsubsection:: *)
(* Graphics Helper Functions *)

ionCharge[ion_] := Module[
  {chargeString, chargeMagnitude},

  (*
    Since charges in the ion string are represented by +++ or --, then we just need the sign and magnitude, which is
    the length and the first character of the charge string.
  *)

  (* Get the substring of +++ or -- from the ion string (something like "y3++"). *)
  (* Longest is important because StringCases is usually greedy and will return the shortest matching substring *)
  chargeString = First[StringCases[ion, Longest[("+" ..) | ("-" ..)]]];

  (* the length of the string is its magnitude *)
  chargeMagnitude = StringLength[chargeString];

  (* next we just need to check for the sign and adjust the sign of the magnitude accordingly before returning *)
  If[StringFirst[chargeString] === "-",
    -1*chargeMagnitude,
    chargeMagnitude
  ]
];

createAminoAcidPrimitive[char_, position_] := Module[{},

  Inset[
    Graphics[
      {
        (* Use helper which sets color of the amino acids. *)
        aminoAcidColor[char],
        Disk[{0, 0}, $aminoAcidSize],
        $fontColor, FontSize -> $aminoAcidFontSize, Text[char, {0, 0}]
      }
    ],
    position,
    Center,
    2 * $aminoAcidSize
  ]

];

createFragmentGraphic[sequence_, ionLabel_, mz_, mass_, charge_,  imageSize_] := Module[
  {
    (* Position and Plot Range Parameters *)
    chars, xPositions, sequenceYPosition, positions,
    yTop, yBottom, xLeft, xRight,

    (* Graphics Primitives *)
    aminoAcidPrimitives, bondLinePrimitives, fragmentPrim,
    resolvedmz, resolvedMass,
    fragmentText, textPrim
  },

  (* Separate the sequence into a list of characters to create graphics primitives for each one. *)
  chars = Characters[sequence];

  (* Calculate the positions for each character. *)
  xPositions = Range[0, $aminoAcidXSpacingFactor*$aminoAcidSize * (Length[chars] - 1), $aminoAcidXSpacingFactor*$aminoAcidSize];
  sequenceYPosition = 0;
  positions = {#, sequenceYPosition} & /@ xPositions;

  (* Calculate the plot ranges. *)
  yTop = sequenceYPosition + $aminoAcidSize;
  yBottom = sequenceYPosition-$aminoAcidSize*$aminoAcidYSpacingFactor;
  xLeft = First[xPositions] - $aminoAcidSize - $aminoAcidPadding;
  xRight = Last[xPositions] + $aminoAcidSize + $aminoAcidPadding;

  (* Create amino acid and bond line primitives and join together. *)
  aminoAcidPrimitives = MapThread[createAminoAcidPrimitive[#1, #2] &, {chars, positions}];
  bondLinePrimitives = {$bondLineThickness , $bondLineColor, Line[{First[positions], Last[positions]}]};
  fragmentPrim = {bondLinePrimitives, aminoAcidPrimitives};

  (* Resolve the mass by rounding it to the thousandths digit, and removing any units *)
  resolvedmz = Round[Unitless[mz], 0.001];
  resolvedMass = Round[Unitless[mass], 0.001];

  (* Create the text containing information about the fragment. *)
  fragmentText = Text[
    StringJoin[
      "Name: ", ionLabel,
      "\nm/z: ", ToString[resolvedmz], " Da",
      "\nMass: ", ToString[resolvedMass], " Da",
      "\nCharge: ", StringJoin["+", ToString[charge]]
    ],
    Alignment -> {Center, Center}
  ];

  (* Create a primitive for the text. *)
  textPrim = {FontSize -> $ionTextFontSize, FontColor -> $fontColor, Style[fragmentText]};

  (* Wrap both fragment and text primitives in Pane and return. *)
  (*
    Need ImageSize in both Pane and Graphics for scrollbars to be useful.
    Graphics image size must be larger than Pane image size.
  *)
  {
    (* Fragment Graphic *)
    Pane[
      Graphics[
        fragmentPrim,
        PlotRange -> {{xLeft, xRight}, {yBottom, yTop}},
        ImageSize -> 2*{xRight - xLeft, yTop - yBottom}
      ],
      Scrollbars -> {True, False},
      AppearanceElements -> None,
      ImageSize -> {$upperPanelFragmentFraction*imageSize, $upperPanelHeightFraction*imageSize},
      Alignment->{Left, Center}
    ],
    (* Text Graphic *)
    Pane[
      Graphics[
        textPrim,
        ImageSize -> {$upperPanelTextFraction*imageSize, $upperPanelHeightFraction*imageSize},
        ImagePadding -> $upperPanelTextImagePadding
      ]
    ]
  }

];


(* ::Subsubsection:: *)
(* Misc. Helper Functions *)
generateTitle[in_] := Module[
  {
    plotTitle
  },

  (* Generate the title text. *)
  plotTitle = If[MatchQ[in, PacketP[]],
    Lookup[in, Object],
    in
  ];

  (* Return as a String. *)
  ToString[plotTitle]

];

appendToEpilog[ops_List, epilogValue_] := Module[
  {newEpilog},
  newEpilog = Append[Lookup[ops, Epilog], epilogValue];
  ReplaceRule[ops, Epilog -> newEpilog]
];

threeLetterCodeToSingleLetterCode = {
  "Ala" -> "A", "Arg" -> "R", "Asn" -> "N", "Asp" -> "D",
  "Asx" -> "B", "Cys" -> "C", "Glu" -> "E", "Gln" -> "Q",
  "Glx" -> "Z", "Gly" -> "G", "His" -> "H", "Ile" -> "I",
  "Leu" -> "L", "Lys" -> "K", "Met" -> "M", "Phe" -> "F",
  "Pro" -> "P", "Ser" -> "S", "Thr" -> "T", "Trp" -> "W",
  "Tyr" -> "Y", "Val" -> "V"
};

buildingBlocksFromStrand[strand_] := Module[
  {
    motifHeads, sequencesRaw, sequencesSplit, threeLetterCodesSplit, buildingBlocks, singleLetterCodes
  },

  (* Get subsequences adn split the strings every 3 characters (the characters are still separate). *)
  (* Ex. {"LysArgGlu", "LysArg"} becomes {{{"L", "y", "s"}, {"A", "r", "g"}, {"G", "l", "u"}}, {{"L", "y", "s"}, {"A", "r", "g"}}} *)
  motifHeads = Map[Head, strand[Motifs]];
  sequencesRaw = strand[Sequences];
  sequencesSplit = MapThread[
    If[MatchQ[#1, Modification], StringTake[#2, 3], #2]&,
    {motifHeads,sequencesRaw}
  ];
  threeLetterCodesSplit= Map[Partition[Characters[#], 3] &, sequencesSplit];

  (* Flatten the list and join the individual characters. The list becomes {"Lys", "Arg", "Glu", "Lys", "Arg"} *)
  buildingBlocks = Map[StringJoin[#]&, Flatten[threeLetterCodesSplit, 1]];

  (* Return the building blocks. *)
  singleLetterCodes = buildingBlocks /. threeLetterCodeToSingleLetterCode;
  Join[singleLetterCodes]

];
