(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Scientific Education : Tests*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(* TransfersInGraph *)

DefineTests[TransfersInGraph,
  Flatten[{
    (*Single Input*)
    Example[{Basic,"Generates visual maps that show the transfers of source samples into a destination Sample through multiple transfer levels:"},
      TransfersInGraph[Object[Sample, "id:N80DNjv0raXN"]],
      _Column
    ],

    (*List input*)
    Example[{Basic,"Generates visual maps that show the transfers of source samples into destination Samples through multiple transfer levels:"},
      TransfersInGraph[{Object[Sample, "id:N80DNjv0raXN"],Object[Sample, "id:jLq9jXq1j851"]}],
      _Column
    ],


    (*Single Container. Now is stubbed as a discarded sample will no longer be linked to the container. Downloading at the given data will make sure that the sample is not discarded.*)
    Example[{Basic,"Generates visual maps that show the transfers of source samples into destination Samples listed under Contents in the input container:"},
      TransfersInGraph[Object[Container, Vessel, "id:XnlV5jlWxNxP"], Date -> DateObject[{2025, 1, 6, 9, 55,21.8046853`9.09112475490413}, "Instant", "Gregorian", -5.`]],
      _Column
    ],

    (*Example without TransfersIn*)
    Example[{Basic,"Generates a graph displaying the product if the SamplesIn field of the input sample is empty:"},
      TransfersInGraph[Object[Sample, "id:O81aEB13E74e"]],
      _Column,
      Messages:>{Warning::NoTransfersIntoSample}
    ],


    (*Example with date Now*)
    Example[{Options,Date,"Generates visual maps that show the transfers of source samples into a Sample before the given date:"},
      TransfersInGraph[Object[Sample, "id:xRO9n3EOjNN5"], Date -> Now],
      _Column
    ],

    (*Example with date in the past*)
    Example[{Options,Date,"Generates visual maps that show the transfers of source samples into a Sample before the given date in the past:"},
      TransfersInGraph[Object[Sample,"id:xRO9n3EOjNN5"],Date -> DateObject[{2024,11,6,23,27,37.`},"Instant","Gregorian",-5.`]],
      _Column
    ],

    (*Comparison between now and a date in the past*)
    Example[{Options,Date,"Generates two graphs that shows the effect of selecting different dates for the transfers of source samples into a Sample:"},
      TransfersInGraph[{Object[Sample, "id:xRO9n3EOjNN5"],Object[Sample,"id:xRO9n3EOjNN5"]},Date -> {Now,DateObject[{2024,11,6,23,27,37.`},"Instant","Gregorian",-5.`]}],
      _Column
    ],

    (*Using yesterday*)
    Example[{Options,Date,"Generates visual maps that show the transfers of source samples into a Sample before the given day specification:"},
      TransfersInGraph[Object[Sample, "id:xRO9n3EOjNN5"],Date -> Yesterday],
      _Column
    ],

    (*Using tomorrow*)
    Example[{Options,Date,"give an warning if the specified date is in the future, and Generates visual maps that show the transfers of source samples into a Sample using Now for the date:"},
      TransfersInGraph[Object[Sample, "id:xRO9n3EOjNN5"],Date -> Tomorrow],
      _Column,
      Messages:>{Warning::DateInFuture}
    ],

    (*Using Date before creation date*)
    Example[{Options,Date,"give an warning if the specified date is before the object creation date, and Generates visual maps that show the transfers of source samples into a Sample using Now for the date:"},
      TransfersInGraph[Object[Sample, "id:xRO9n3EOjNN5"],Date -> DateObject[
        List[2023, 11, 6, 20, 42, 21.840768`], "Instant", "Gregorian", -4.`]],
      _Column,
      Messages:>{Warning::DateBeforeCreation}
    ],

    (*2 LevelsDown*)
    Example[{Options,LevelsDown,"Generates a graph showing a single level of transfers:"},
      TransfersInGraph[Object[Sample, "id:WNa4ZjMaoA6D"],LevelsDown -> 1],
      _Column
    ],


    (*All Levels*)
    Example[{Options,LevelsDown,"Generates a graph showing a tree of all transfers into a sample. Each additional level captures further layers of transfers, where each level represents transfers made into the source samples of the previous level:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"],LevelsDown -> All],
      _Column
    ],

    (*10 Levels*)
    Example[{Options,LevelsDown,"Generates a graph showing a tree of up to 10 levels. The function runs until no more TransfersIn are recorded or 10 levels are reached:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"],LevelsDown -> 10],
      _Column
    ],

    (*create examples of Layouts*)
    Example[{Options,GraphLayout,"Generates a graph using Automatic for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> Automatic],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using LayeredEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "LayeredEmbedding"],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using LayeredDigraphEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "LayeredDigraphEmbedding"],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using RadialEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "RadialEmbedding"],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using BalloonEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "BalloonEmbedding"],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using CircularEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "CircularEmbedding"],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using GridEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "GridEmbedding"],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using SpectralEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "SpectralEmbedding"],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using SpringEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "SpringEmbedding"],
      _Column
    ],Example[{Options,GraphLayout,"Generates a graph using TutteEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "TutteEmbedding"],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using StarEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "StarEmbedding"],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using SpringElectricalEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "SpringElectricalEmbedding"],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using GravityEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "GravityEmbedding"],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using MultipartiteEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "MultipartiteEmbedding"],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using LinearEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "LinearEmbedding"],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using CircularMultipartiteEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "CircularMultipartiteEmbedding"],
      _Column
    ],
    Example[{Options,GraphLayout,"Generates a graph using DiscreteSpiralEmbedding for the GraphLayout option:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"], GraphLayout -> "DiscreteSpiralEmbedding"],
      _Column
    ],

    (*Layout as a list*)
    Example[{Options,GraphLayout,"Generates a graph using LayeredEmbedding and Automatic for the layout:"},
      TransfersInGraph[{Object[Sample,"id:WNa4ZjMaoA6D"],Object[Sample,"id:WNa4ZjMaoA6D"]},GraphLayout -> {{"LayeredEmbedding"},{Automatic}}],
      _Column
    ],

    Example[{Options,ProgressIndicator,"Turn off progress updates as the function evaluates by specifying ProgressIndicator -> False:"},
      TransfersInGraph[Object[Sample,"id:WNa4ZjMaoA6D"],ProgressIndicator -> False],
      _Column
    ],

    (*Check the heads to make sure there are no unexpected changes*)
    Test["Determine if output heads are as expected:",
      Module[{graph,heads},
        graph=TransfersInGraph[Object[Sample, "id:N80DNjv0raXN"]];
        heads = {graph[[1]],graph[[1,1]],graph[[1,1,1]]}
      ],
      {_List,_Legended,_Graph}
    ],

    Test["Return early if no transfers can be plotted due to a time discrepancy between a sample's DateCreated and the date of the earliest transfer into the sample:",
      TransfersInGraph[Object[Sample, "id:vXl9j5W5bawe"], LevelsDown -> All],
      _String
    ],

    Test["Determine if legend is as expected:",
      Module[{graph,legendColors},
        graph=TransfersInGraph[Object[Sample, "id:N80DNjv0raXN"]];
        legendColors = graph[[1, 1, 2]]
      ],
      SwatchLegend[
        List[
          XYZColor[List[0.23065`,0.36735`,0.33475`]],
          XYZColor[List[0.27165`,0.26511`,0.87685`]],
          XYZColor[List[0.32986`,0.24668`,0.45669`]],
          XYZColor[List[0.4687`,0.31762`,0.06145`]]
        ],
        List[
          Grid[List[List["Input Sample"]],Rule[ItemSize,List[Automatic,1.75`]],Rule[Alignment,List[Automatic,Center]]],
          Grid[List[List["Preparable sample\nStockSolution, Media, or Matrix)"]],Rule[ItemSize,List[Automatic,3]],Rule[Alignment,List[Automatic,Center]]],
          Grid[List[List["Intermediate sample without a Model\n(prepared through explicit operations such as Transfer or Mix)"]],Rule[ItemSize,List[Automatic,3]],Rule[Alignment,List[Automatic,Center]]],
          Grid[List[List["Non-preparable sample\n(sourced sample, e.g. commercial or user supplied sample)"]],Rule[ItemSize,List[Automatic,3]],Rule[Alignment,List[Automatic,Center]]]
        ],
        Rule[LegendLabel,"Sample Type"]]
    ],

    Test["Determine if vertex and edge settings are as expected:",
      Module[{graph, vertexOptions},
        graph = TransfersInGraph[Object[Sample, "id:N80DNjv0raXN"]];
        vertexOptions =
            Lookup[graph[[1, 1, 1]] // AbsoluteOptions,
              {EdgeStyle, EdgeShapeFunction, VertexSize}]],
      List[List[RGBColor[0.6`, 0.6`, 0.6`]], "Arrow", List[Medium]]]  }
  ]
];