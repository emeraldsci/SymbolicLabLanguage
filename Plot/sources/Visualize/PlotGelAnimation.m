(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotGelAnimation*)

Error::GelAnimationFileNotFound = "`1` does not have animation files.";

PlotGelAnimation[input:Alternatives[
  ObjectP[Object[Data,PAGE]],
  ObjectP[Object[Data,AgaroseGelElectrophoresis]],
  ObjectP[Object[Protocol,PAGE]],
  ObjectP[Object[Protocol,AgaroseGelElectrophoresis]]],
  ops:OptionsPattern[]] := Module[
  {dataObject, redGIFFiles, blueGIFFiles, combinedGIFFiles, redGIF, blueGIF, combinedGIF, numberOfPlates, protocol},

  (* determine data object *)
  dataObject = Which[
    (* for data object input *)
    MatchQ[input, ObjectP[Object[Data]]], input,

    (* for protocol input, just take the first data object *)
    MatchQ[input, ObjectP[Object[Protocol]]],  input[Data][[1]]
  ];

  (* get cloudfile links *)
  {redGIFFiles, blueGIFFiles, combinedGIFFiles} = Download[dataObject, {RedAnimationFiles,BlueAnimationFiles, CombinedAnimationFiles}];

  (* throw a message and exit early if no animation files are found *)
  If[MatchQ[{redGIFFiles, blueGIFFiles, combinedGIFFiles},{{},{},{}}],
    (* generate input-dependent error message *)
    Which[
      (* if input is data, need to extract protocol first *)
      MatchQ[input, ObjectP[Object[Data]]],
        protocol = Download[input, Protocol][[1]];
        Message[Error::GelAnimationFileNotFound, protocol],

      (* if input is protocol *)
      MatchQ[input, ObjectP[Object[Protocol]]], Message[Error::GelAnimationFileNotFound, input]
    ];
    Return[$Failed]
  ];

  (* determine the total number of plates *)
  numberOfPlates = Length[redGIFFiles];

  (* download cloudfiles *)
  {redGIF, blueGIF, combinedGIF} = ImportCloudFile[#]&/@{redGIFFiles, blueGIFFiles, combinedGIFFiles};

  (* generate animation for all colors and for each plate *)
  Array[
    TabView[
    {
      "Plate_"<>ToString[#]<>" Red"->ListAnimate[redGIF[[#]]],
      "Blue"->ListAnimate[blueGIF[[#]]],
      "Combined"->ListAnimate[combinedGIF[[#]]]
    }
  ]&, numberOfPlates]
]