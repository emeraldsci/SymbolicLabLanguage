(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotpH*)

DefineTests[PlotpH,
  {
    Example[
      {Basic,"Plot multiple pH data on the same plot:"},
      PlotpH[{Object[Data, pH, "id:xRO9n3BGjmRw"], Object[Data, pH, "id:vXl9j57R8mXB"]}],
      _?ValidGraphicsQ,
      TimeConstraint->120
    ],
    Example[
      {Basic,"Plots pH data when given a pH data object when given a data link:"},
      PlotpH[Link[Object[Data, pH, "id:xRO9n3BGjmRw"],Protocol]],
      _?ValidGraphicsQ,
      TimeConstraint->120
    ],
    Example[
      {Basic,"Plots pH data when given a pH data object:"},
      PlotpH[Object[Data, pH, "id:xRO9n3BGjmRw"]],
      _?ValidGraphicsQ
    ],
    Example[
      {Options,TargetUnits,"Specify units for the XY axes:"},
      PlotpH[Object[Data, pH, "id:xRO9n3BGjmRw"], TargetUnits -> Automatic],
      _?ValidGraphicsQ
    ],
    Example[
      {Options,Zoomable,"Disallow interactive zooming by setting Zoomable->False:"},
      PlotpH[Object[Data, pH, "id:xRO9n3BGjmRw"],Zoomable->False],
      _?ValidGraphicsQ,
      TimeConstraint->120
    ],
    Example[
      {Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
      PlotpH[Object[Data, pH, "id:xRO9n3BGjmRw"],LegendPlacement->Right],
      _?ValidGraphicsQ
    ],
    Example[{Options, PlotLabel, "Provide a title for the plot:"},
      PlotpH[Object[Data, pH, "id:xRO9n3BGjmRw"],PlotLabel -> "my pH Data"],
      _?ValidGraphicsQ
    ],
    Example[{Options, FrameLabel, "Specify custom x and y-axis labels:"},
      PlotpH[Object[Data, pH, "id:xRO9n3BGjmRw"],FrameLabel -> {"pH Value",None, None, None}],
      _?ValidGraphicsQ
    ],
    Example[
      {Options,Legend,"Display a legend with the plot:"},
      PlotpH[Object[Data, pH, "id:xRO9n3BGjmRw"],Legend->{"My Data"}],
      _?ValidGraphicsQ
    ],
    Example[{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
      PlotpH[Object[Data, pH, "id:xRO9n3BGjmRw"],
        Boxes -> True
      ],
      _?ValidGraphicsQ,
      TimeConstraint->120
    ],
    Example[{Options,Frame,"Change the border around the figure:"},
      PlotpH[Object[Data, pH, "id:xRO9n3BGjmRw"],Frame -> {True, True, True, True}],
      ValidGraphicsP[]
    ],
    Example[{Options,ChartLabels,"Change the text underneath each bar:"},
      PlotpH[{Object[Data, pH, "id:xRO9n3BGjmRw"], Object[Data, pH, "id:vXl9j57R8mXB"]},ChartLabels -> {"data 1","data 2"}],
      ValidGraphicsP[]
    ],
    Example[{Options,Option,"Return a list of options when Output->Option:"},
      PlotpH[Object[Data, pH, "id:xRO9n3BGjmRw"],Output -> Options],
      OptionsPattern[]
    ],
    Example[{Options,Option,"Return a list of options when Output->Option:"},
      PlotpH[Object[Data, pH, "id:xRO9n3BGjmRw"],Output -> Options],
      OptionsPattern[]
    ],
    Example[{Options,Option,"Return a figure when Output->Preview:"},
      PlotpH[Object[Data, pH, "id:xRO9n3BGjmRw"],Output -> Preview],
      ValidGraphicsP[]
    ],
    Example[{Options,Option,"Return an empty list when Output->Tests:"},
      PlotpH[Object[Data, pH, "id:xRO9n3BGjmRw"],Output -> Tests],
      {}
    ]
  }
];