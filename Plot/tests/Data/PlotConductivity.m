(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotConductivity*)

DefineTests[PlotConductivity,
  {
    Example[
      {Basic,"Plot multiple conductivity data on the same plot:"},
      PlotConductivity[{Object[Data, Conductivity, "id:Vrbp1jKr3rae"], Object[Data, Conductivity, "id:XnlV5jKnanO3"]}],
      _?ValidGraphicsQ,
      TimeConstraint->120
    ],
    Example[
      {Basic,"Plots conductivity data when given a conductivity data object when given a data link:"},
      PlotConductivity[Link[Object[Data, Conductivity, "id:Vrbp1jKr3rae"],Protocol]],
      _?ValidGraphicsQ,
      TimeConstraint->120
    ],
    Example[
      {Basic,"Plots conductivity data when given a conductivity data object:"},
      PlotConductivity[Object[Data, Conductivity, "id:Vrbp1jKr3rae"]],
      _?ValidGraphicsQ
    ],
    Example[
      {Options,TargetUnits,"Specify units for the XY axes:"},
      PlotConductivity[Object[Data, Conductivity, "id:Vrbp1jKr3rae"], TargetUnits -> Automatic],
      _?ValidGraphicsQ
    ],
    Example[
      {Options,Zoomable,"Disallow interactive zooming by setting Zoomable->False:"},
      PlotConductivity[Object[Data, Conductivity, "id:Vrbp1jKr3rae"],Zoomable->False],
      _?ValidGraphicsQ,
      TimeConstraint->120
    ],
    Example[
      {Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
      PlotConductivity[Object[Data, Conductivity, "id:Vrbp1jKr3rae"],LegendPlacement->Right],
      _?ValidGraphicsQ
    ],
    Example[{Options, PlotLabel, "Provide a title for the plot:"},
      PlotConductivity[Object[Data, Conductivity, "id:Vrbp1jKr3rae"],PlotLabel -> "my conductivity data"],
      _?ValidGraphicsQ
    ],
    Example[{Options, FrameLabel, "Specify custom x and y-axis labels:"},
      PlotConductivity[Object[Data, Conductivity, "id:Vrbp1jKr3rae"],FrameLabel -> {"conductivity Value",None, None, None}],
      _?ValidGraphicsQ
    ],
    Example[
      {Options,Legend,"Display a legend with the plot:"},
      PlotConductivity[Object[Data, Conductivity, "id:Vrbp1jKr3rae"],Legend->{"My Data"}],
      _?ValidGraphicsQ
    ],
    Example[{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
      PlotConductivity[Object[Data, Conductivity, "id:Vrbp1jKr3rae"],
        Boxes -> True
      ],
      _?ValidGraphicsQ,
      TimeConstraint->120
    ],
    Example[{Options,Frame,"Change the border around the figure:"},
      PlotConductivity[Object[Data, Conductivity, "id:Vrbp1jKr3rae"],Frame -> {True, True, True, True}],
      ValidGraphicsP[]
    ],
    Example[{Options,ChartLabels,"Change the text underneath each bar:"},
      PlotConductivity[{Object[Data, Conductivity, "id:Vrbp1jKr3rae"], Object[Data, Conductivity, "id:XnlV5jKnanO3"]},ChartLabels -> {"data 1","data 2"}],
      ValidGraphicsP[]
    ],
    Example[{Options,Option,"Return a list of options when Output->Option:"},
      PlotConductivity[Object[Data, Conductivity, "id:Vrbp1jKr3rae"],Output -> Options],
      OptionsPattern[]
    ],
    Example[{Options,Option,"Return a list of options when Output->Option:"},
      PlotConductivity[Object[Data, Conductivity, "id:Vrbp1jKr3rae"],Output -> Options],
      OptionsPattern[]
    ],
    Example[{Options,Option,"Return a figure when Output->Preview:"},
      PlotConductivity[Object[Data, Conductivity, "id:Vrbp1jKr3rae"],Output -> Preview],
      ValidGraphicsP[]
    ],
    Example[{Options,Option,"Return an empty list when Output->Tests:"},
      PlotConductivity[Object[Data, Conductivity, "id:Vrbp1jKr3rae"],Output -> Tests],
      {}
    ]
  }
];