(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAgarose*)


DefineTests[PlotAgarose,
	{
		(* -- BASIC -- *)
		Example[{Basic,"Given an AgaroseGelElectrophoresis data object, creates a plot for the SampleElectropherogram:"},
			PlotAgarose[
				Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]
			],
			_?ValidGraphicsQ
		],
  
		Example[{Basic,"Plot a AgaroseGelElectrophoresis data in a link:"},
			PlotAgarose[Link[Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"],Protocol]],
			_?ValidGraphicsQ
		],
        
        Example[{Basic, "Plot AgaroseGelElectrophoresis data after calling AnalyzePeaks:"},
            AnalyzePeaks[Object[Data, AgaroseGelElectrophoresis, "AgaroseGelElectrophoresis AnalyzePeaks and PlotAgarose"<>$SessionUUID]];
            PlotAgarose[Object[Data, AgaroseGelElectrophoresis, "AgaroseGelElectrophoresis AnalyzePeaks and PlotAgarose"<>$SessionUUID]],
            _?ValidGraphicsQ,
            SetUp :> (
                $CreatedObjects = {};
                Module[{sampleElectropherogramData},
                    sampleElectropherogramData=QuantityArray[
                        {
                            {-2.92913423631004, 0.330195027499277}, {-1.88703492791978, 0.41773644606198906`}, {-0.844935619529525, 0.313742106563199},
                            {0.19716368886067398`, 0.207730038139712}, {1.2409914776889899`, 0.31793295907579}, {2.29273386947461, 0.526387221638745},
                            {3.3525649085713294`, 0.463990768045525}, {4.42066378006044, 0.4190817988198591}, {5.49721500096489, 0.482202626942377},
                            {6.58240862006086, 0.367860701750125}, {7.676440426743319, 0.325849080535597}
                        },
                        {IndependentUnit["Basepairs"], IndependentUnit["Rfus"]}
                    ];
                    Upload[
                        <|
                            Type->Object[Data,AgaroseGelElectrophoresis],
                            Name->"AgaroseGelElectrophoresis AnalyzePeaks and PlotAgarose"<>$SessionUUID,
                            SampleElectropherogram->sampleElectropherogramData
                        |>
                    ]
                ]
            ),
            TearDown :> (
                EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
                Unset[$CreatedObjects]
            )
        ],

		(* -- OPTIONS -- *)
		Example[{Options, ImageSize, "Set the image size for the output plots:"},
			PlotAgarose[
				Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"],
				ImageSize -> 800
			],
			_?ValidGraphicsQ
		],
		Example[{Options,PrimaryData,"The field name containing the data to be plotted:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},PrimaryData->{SampleElectropherogram}],
			_?ValidGraphicsQ
		],
		Example[{Options,SecondaryData,"Additional fields to display along with the primary data:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},SecondaryData->{MarkerElectropherogram}],
			_?ValidGraphicsQ
		],
		Example[{Options,Display,"Additional data to overlay on top of the plot:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},Display->{Peaks}],
			_?ValidGraphicsQ
		],
		Example[{Options,IncludeReplicates,"When set to true, the average of PrimaryData will be be plotted with error bars:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},IncludeReplicates->False],
			_?ValidGraphicsQ
		],
		Example[{Options,TargetUnits,"The units of the x and y axes. If these are distinct from the units currently associated with the data, unit conversions will occur before plotting:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},TargetUnits -> {BasePair, RFU}],
			_?ValidGraphicsQ
		],
		Example[{Options,Zoomable,"Indicates if a dynamic plot which can be zoomed in or out will be returned:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},Zoomable->True],
			_?ValidGraphicsQ
		],
		Example[{Options,LegendPlacement,"Specifies where the legend will be placed relative to the plot:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},LegendPlacement->Right],
			_?ValidGraphicsQ
		],
		Example[{Options,Boxes,"If true, the legend will pair each label with a colored box. If false, the labels will be paired with a colored line:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},Boxes->True],
			_?ValidGraphicsQ
		],
		Example[{Options,FrameLabel,"The label to place on top of the frame:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},FrameLabel->{"band size (mm)","fluorescent intensity (arbitrary unit)",None,None}],
			_?ValidGraphicsQ
		],
		Example[{Options,PlotLabel,"Specifies an overall label for a plot:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},PlotLabel->"my experiment"],
			_?ValidGraphicsQ
		],
		Example[{Options,Peaks,"Specification of peaks for primary data:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},Peaks->Object[Analysis, Peaks, "Peak analysis object for PlotAgarose testing"]],
			_?ValidGraphicsQ
		],
		Example[{Options,MarkerElectropherogram,"The sample electropherogram trace to display on the plot:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},MarkerElectropherogram->Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"][MarkerElectropherogram]],
			_?ValidGraphicsQ
		],
		Example[{Options,PostSelectionElectropherogram,"The post selection electropherogram trace to display on the plot:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},PostSelectionElectropherogram->Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"][PostSelectionElectropherogram]],
			_?ValidGraphicsQ
		],
		Example[{Options,SampleElectropherogram,"The sample electropherogram trace to display on the plot:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},SampleElectropherogram->Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"][SampleElectropherogram]],
			_?ValidGraphicsQ
		],
		Example[{Options,OptionFunctions,"A list of functions which take in a list of info packets and plot options and return a list of new options:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},OptionFunctions -> {}],
			_?ValidGraphicsQ
		],
		Example[{Options,Legend,"A list of text descriptions of each data set in the plot:"},
			PlotAgarose[{Object[Data, AgaroseGelElectrophoresis, "Data object for PlotAgarose testing"]},Legend->{"sample"}],
			_?ValidGraphicsQ
		]
	}

];
