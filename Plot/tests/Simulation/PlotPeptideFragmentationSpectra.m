(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotPeptideFragmentationSpectra*)


DefineTests[PlotPeptideFragmentationSpectra,

  (*
    Created test object by running the following:
      SimulatePeptideFragmentationSpectra[Object[Sample, "id:eGakldaZrXvz"], MaxCharge -> 3, MaxIsotopes -> 4, IncludedIons -> {AIon, BIon, XIon, YIon }]

    Created objects are:
      {
         Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"],
         Object[MassFragmentationSpectrum, "id:BYDOjvDrEA6E"],
         Object[MassFragmentationSpectrum, "id:M8n3rxnZb56E"],
         Object[MassFragmentationSpectrum, "id:mnk9jOkvPDrN"],
         Object[Simulation, FragmentationSpectra, "id:6V0npv0O41lw"]
      }
  *)

  {
    (* --- Basic Tests --- *)
    Example[{Basic,"Generate a plot for a single Object[MassFragmentationSpectrum]:"},
      PlotPeptideFragmentationSpectra[Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"]],
      _DynamicModule
    ],
    Example[{Basic,"Generate a plot for a single Object[Simulation, FragmentationSpectra], which downloads from multiple Object[MassFragmentationSpectrum]:"},
      PlotPeptideFragmentationSpectra[Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"]],
      _DynamicModule
    ],
    Example[{Basic,"Generate a plot for a multiple Object[MassFragmentationSpectrum], which puts the individual plots into SlideView:"},
      PlotPeptideFragmentationSpectra[{
        Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"],
        Object[MassFragmentationSpectrum, "id:BYDOjvDrEA6E"]
      }],
      _SlideView
    ],
    Example[{Basic,"Generate a plot for a multiple Object[Simulation, FragmentationSpectra], which puts the individual plots into SlideView:"},
      PlotPeptideFragmentationSpectra[{
        Object[Simulation, FragmentationSpectra, "id:6V0npv0O41lw"],
        Object[Simulation, FragmentationSpectra, "id:6V0npv0O41lw"]
      }],
      _SlideView
    ],
    Example[{Basic,"Generate a plot for a multiple objects of both types, which puts the individual plots into SlideView:"},
      PlotPeptideFragmentationSpectra[{
        Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"],
        Object[Simulation, FragmentationSpectra, "id:6V0npv0O41lw"]
      }],
      _SlideView
    ],
    Example[{Basic,"Generate a plot for a single packet of an Object[MassFragmentationSpectrum]:"},
      packet = Download[Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"]];
      PlotPeptideFragmentationSpectra[packet],
      _DynamicModule
    ],

    (* --- Options Tests --- *)
    (* Note most options are inherited from list plot. These tests are only for new or modified options. *)
    Example[{Options, Frame, "Turn off Frame and it labels:"},
      PlotPeptideFragmentationSpectra[Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"], Frame->{False, False, False, False}],
      _DynamicModule
    ],
    Example[{Options, LabelStyle, "Adjust the font in LabelStyle:"},
      PlotPeptideFragmentationSpectra[Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"], LabelStyle->{Italic, 24, FontFamily -> "Helvetica"}],
      _DynamicModule
    ],
    Example[{Options, Filling, "Disable Filling option, which removes the lines connecting points to the x axis:"},
      PlotPeptideFragmentationSpectra[Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"], Filling->None],
      _DynamicModule
    ],
    Example[{Options, Joined, "Connect the points by enabling the Joined Option:"},
      PlotPeptideFragmentationSpectra[Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"], Joined->True],
      _DynamicModule
    ],
    Example[{Options, ImageSize, "Specify the ImageSize:"},
      PlotPeptideFragmentationSpectra[Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"], ImageSize->600],
      _DynamicModule
    ],
    Example[{Options, PlotMarkers, "Modify the PlotMarkers:"},
      PlotPeptideFragmentationSpectra[Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"], PlotMarkers->{Automatic, 10}],
      _DynamicModule
    ],
    Example[{Options, PlotMarkers, "Specify the PlotStyle:"},
      PlotPeptideFragmentationSpectra[Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"], PlotStyle->Green],
      _DynamicModule
    ],
    Example[{Options, PlotMarkers, "Specify the PlotRange:"},
      PlotPeptideFragmentationSpectra[Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"], PlotRange->{{0.1,0.8}, {0, 3000}}],
      _DynamicModule
    ],
    Example[{Options, Collapse, "Plot the list of objects onto a single plot:"},
      PlotPeptideFragmentationSpectra[{Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"], Object[MassFragmentationSpectrum, "id:BYDOjvDrEA6E"]}, Collapse->True],
      _DynamicModule
    ],
    Example[{Options, Title, "Manually set the title:"},
      PlotPeptideFragmentationSpectra[Object[MassFragmentationSpectrum, "id:9RdZXvdoqelJ"], Title->"I'm a new title!"],
      _DynamicModule
    ]

    (* --- Message Tests --- *)
    (* Currently no messages thrown specifically by PlotPeptideFragmentationSpectra. *)

  }

];
