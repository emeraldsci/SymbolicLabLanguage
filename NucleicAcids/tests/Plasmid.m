DefineTests[PlotPlasmid,
  {
    (* -- Basic -- *)
    Example[{Basic, "Generate a basic plasmid map from a GenBank file:"},
      PlotPlasmid[Object[EmeraldCloudFile, "test GenBank file for PlotPlasmid"]],
      ValidGraphicsP[]
    ],

    (* -- Options -- *)
    Example[{Options, SiteLabels, "Generate a basic plasmid map from a GenBank file with site labels off:"},
      PlotPlasmid[Object[EmeraldCloudFile, "test GenBank file for PlotPlasmid"], SiteLabels->False],
      ValidGraphicsP[]
    ],

    Example[{Options, SiteMarkers, "Generate a basic plasmid map from a GenBank file with site markers off:"},
      PlotPlasmid[Object[EmeraldCloudFile, "test GenBank file for PlotPlasmid"], SiteMarkers->False],
      ValidGraphicsP[]
    ],

   (* -- Messages -- *)
    Example[{Messages, "InvalidOptions", "Options for SiteLabels and SiteMarkers must be booleans; any invalid options will be ignored, and the default value will be used:"},
      PlotPlasmid[Object[EmeraldCloudFile, "test GenBank file for PlotPlasmid"], SiteLabels->"InvalidOpValue", SiteMarkers->"InvalidOpValue"],
      ValidGraphicsP[],
      Messages :> {Warning::OptionPattern}
    ]
  }
];
