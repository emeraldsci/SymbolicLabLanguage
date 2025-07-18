(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDissolvedOxygen*)

DefineTests[PlotDissolvedOxygen,
  {
    Example[
      {Basic,"Plot multiple DissolvedOxygen data on the same plot:"},
      PlotDissolvedOxygen[{Object[Data, DissolvedOxygen, "id:7X104vn3knjk"], Object[Data, DissolvedOxygen, "id:P5ZnEjdJ1wal"]}],
      _?ValidGraphicsQ,
      TimeConstraint->120
    ],
    Example[
      {Basic,"Plots DissolvedOxygen data when given a DissolvedOxygen data object when given a data link:"},
      PlotDissolvedOxygen[Link[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"],Protocol]],
      _?ValidGraphicsQ,
      TimeConstraint->120
    ],
    Example[
      {Basic,"Plots DissolvedOxygen data when given a DissolvedOxygen data object:"},
      PlotDissolvedOxygen[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"]],
      _?ValidGraphicsQ
    ],
    Example[
      {Basic,"Plots DissolvedOxygen data when given a DissolvedOxygen protocol object:"},
      PlotDissolvedOxygen[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"][Protocol]],
      _?ValidGraphicsQ
    ],
    Example[
      {Options,TargetUnits,"Specify units for the XY axes:"},
      PlotDissolvedOxygen[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"], TargetUnits -> Automatic],
      _?ValidGraphicsQ
    ],
    Example[
      {Options,Zoomable,"Disallow interactive zooming by setting Zoomable->False:"},
      PlotDissolvedOxygen[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"],Zoomable->False],
      _?ValidGraphicsQ,
      TimeConstraint->120
    ],
    Example[
      {Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
      PlotDissolvedOxygen[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"],LegendPlacement->Right],
      _?ValidGraphicsQ
    ],
    Example[{Options, PlotLabel, "Provide a title for the plot:"},
      PlotDissolvedOxygen[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"],PlotLabel -> "my DissolvedOxygen data"],
      _?ValidGraphicsQ
    ],
    Example[{Options, FrameLabel, "Specify custom x and y-axis labels:"},
      PlotDissolvedOxygen[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"],FrameLabel -> {"DissolvedOxygen Value",None, None, None}],
      _?ValidGraphicsQ
    ],
    Example[
      {Options,Legend,"Display a legend with the plot:"},
      PlotDissolvedOxygen[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"],Legend->{"My Data"}],
      _?ValidGraphicsQ
    ],
    Example[{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
      PlotDissolvedOxygen[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"],
        Boxes -> True
      ],
      _?ValidGraphicsQ,
      TimeConstraint->120
    ],
    Example[{Options,Frame,"Change the border around the figure:"},
      PlotDissolvedOxygen[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"],Frame -> {True, True, True, True}],
      ValidGraphicsP[]
    ],
    Example[{Options,ChartLabels,"Change the text underneath each bar:"},
      PlotDissolvedOxygen[{Object[Data, DissolvedOxygen, "id:7X104vn3knjk"], Object[Data, DissolvedOxygen, "id:P5ZnEjdJ1wal"]},ChartLabels -> {"data 1","data 2"}],
      ValidGraphicsP[]
    ],
    Example[{Options,Option,"Return a list of options when Output->Option:"},
      PlotDissolvedOxygen[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"],Output -> Options],
      OptionsPattern[]
    ],
    Example[{Options,Option,"Return a list of options when Output->Option:"},
      PlotDissolvedOxygen[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"],Output -> Options],
      OptionsPattern[]
    ],
    Example[{Options,Option,"Return a figure when Output->Preview:"},
      PlotDissolvedOxygen[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"],Output -> Preview],
      ValidGraphicsP[]
    ],
    Example[{Options,Option,"Return an empty list when Output->Tests:"},
      PlotDissolvedOxygen[Object[Data, DissolvedOxygen, "id:7X104vn3knjk"],Output -> Tests],
      {}
    ]
  }
];