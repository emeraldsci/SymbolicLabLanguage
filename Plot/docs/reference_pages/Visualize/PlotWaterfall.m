(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PlotWaterfall*)


DefineUsage[PlotWaterfall,{

	BasicDefinitions->{

		(* Define usage to accept paired-list of z-positions and coordinate pairs *)
		{
			Definition->{"PlotWaterfall[stackedData]","plot"},
			Description->"constructs a waterfall plot from 'stackedData', a collection of 2D coordinate pairs stacked in paired list form alongside their Z-coordinate values.",
			Inputs:>{
				IndexMatching[
					{
						InputName ->"stackedData",
						Description->"A collection of 2D coordinate pairs stacked in paired list form alongside their corresponding Z-coordinate values, e.g. {{Z,{{X,Y}..}}..}. Each set of 2D coordinates corresponds to an independent level in the waterfall, and its paired Z-coordinate value determines its position relative to the other contours.",
						Widget->Adder[
							{
							"Z Coordinate"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
							"XY Coordinates"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Line]
							}
						]
					},
					IndexName->"input contours"
				]
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"A 3D figure in which each 2D coordinate list in `stackedData` is visualized as a 2D contour in the waterfall. Each contour in the waterfall is confined to its own 2D plane, with its Z-coordinate determined by either its paired value or by its relative position in `stackedData`.",
					Pattern:>_?ValidGraphicsQ
				}
			}
		},

		(* Define usage to accept a list of object references *)
		{
			Definition->{"PlotWaterfall[dataObjects]","multiObjPlot"},
			Description->"constructs a waterfall plot from 'dataObjects', a list of references to data objects that each contain a list of 2D coordinate pairs.",
			MoreInformation->"Each referenced object must contain at least one set of 2D coordinate pairs. The field containing the 2D coordinates may be specified using the PrimaryData option, otherwise it will be inferred from the object type. Typical use cases may include visualizing any 2D data collected over a range of sequential conditions or timepoints.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"dataObjects",
						Description->"A list of Object[Data] references in the form {ObjectP[Object[Data]]..}. All referenced objects must be of the same type and must possess at least one field containing a set of 2D coordinate pairs.",
						Widget->Adder[
							Alternatives[
								Widget[Type->Object,Pattern:>ObjectP[{Object[Data]}],ObjectTypes->{Object[Data]}],
								Widget[Type->String,Pattern:>_?dataObjectIDQ,Size->Word]
							]
						]
					},
					IndexName->"input contours"
				]
			},

			Outputs:>{
				{
					OutputName->"multiObjPlot",
					Description->"A 3D figure in which the PrimaryData field of each object referenced in `dataObjects` is visualized as a 2D contour in the waterfall. Each contour in the waterfall is confined to its own 2D plane, with its Z-coordinate set in accordance with either the specified LabelField option or the contour's relative position in `dataObjects`.",
					Pattern:>_?ValidGraphicsQ
				}
			}
		},

		(* Define usage to accept a standalone 3D data object reference *)
		{
			Definition->{"PlotWaterfall[dataObject]","objPlot"},
			Description->"constructs a waterfall plot from 'dataObject', a single data object reference that contains a paired list of 2D coordinates and their associated Z-coordinate values.",
			MoreInformation->"The referenced object should contain at least one field whose values comprise a paired list of 2D coordinate pairs and their associated Z-values in the form {{Z,{{X,Y}..}}..}. The field containing the paired list of 2D coordinates may be specified using the PrimaryData option, otherwise it will be inferred from the object type.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"dataObject",
						Description->"A standalone Object[Data] reference of the form ObjectP[Object[Data]]. The referenced object must possess at least one field containing a paired list of 2D coordinate pairs and their associated Z-coordinate values, e.g. {{Z,{{X,Y}..}}..}.",
						Widget->Alternatives[
							Widget[Type->Object,Pattern:>ObjectP[{Object[Data]}],ObjectTypes->{Object[Data]}],
							Widget[Type->String,Pattern:>_?dataObjectIDQ,Size->Word]
						]
					},
					IndexName->"input contours"
				]
			},

			Outputs:>{
				{
					OutputName->"objPlot",
					Description->"A 3D figure in which each item in the paired-list retrieved from the PrimaryData field of `dataObject` is visualized as a 2D contour in the waterfall. Each contour in the waterfall is confined to its own 2D plane, with its Z-coordinate set in accordance with either the specified LabelField option or the contour's relative position in the paired list of coordinates.",
					Pattern:>_?ValidGraphicsQ
				}
			}
		}
	},
	SeeAlso->{
		"PlotWaterfallOptions",
		"PlotWaterfallPreview",
		"EmeraldListPointPlot3D",
		"Graphics3D",
		"PlotNMR"
	},
	Author->{"scicomp", "brad", "sebastian.bernasek"},
	Preview->True
	}
];


(* ::Subsubsection:: *)
(*PlotWaterfallOptions*)


DefineUsage[PlotWaterfallOptions,{

	BasicDefinitions->{

		(* Define usage to accept paired-list of z-positions and coordinate pairs *)
		{
			Definition->{"PlotWaterfallOptions[stackedData]","options"},
			Description->"returns the 'options' to construct a waterfall plot from 'stackedData', a collection of 2D coordinate pairs stacked in paired list form alongside their Z-coordinate values.",
			Inputs:>{
				IndexMatching[
					{
						InputName ->"stackedData",
						Description->"A collection of 2D coordinate pairs stacked in paired list form alongside their corresponding Z-coordinate values, e.g. {{Z,{{X,Y}..}}..}. Each set of 2D coordinates corresponds to an independent level in the waterfall, and its paired Z-coordinate value determines its position relative to the other contours.",
						Widget->Adder[
							{
								"Z Coordinate"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
								"XY Coordinates"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Line]
							}
						]
					},
					IndexName->"input contours"
				]
			},
			Outputs:>{
				{
					OutputName->"options",
					Description->"the options used to plot a waterfall plot from 'stackedData'.",
					Pattern:>_List
				}
			}
		},

		(* Define usage to accept a list of object references *)
		{
			Definition->{"PlotWaterfallOptions[dataObjects]","options"},
			Description->"returns the 'options' to construct a waterfall plot from 'dataObjects', a list of references to data objects that each contain a list of 2D coordinate pairs.",
			MoreInformation->"Each referenced object must contain at least one set of 2D coordinate pairs. The field containing the 2D coordinates may be specified using the PrimaryData option, otherwise it will be inferred from the object type. Typical use cases may include visualizing any 2D data collected over a range of sequential conditions or timepoints.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"dataObjects",
						Description->"A list of Object[Data] references in the form {ObjectP[Object[Data]]..}. All referenced objects must be of the same type and must possess at least one field containing a set of 2D coordinate pairs.",
						Widget->Adder[
							Alternatives[
								Widget[Type->Object,Pattern:>ObjectP[{Object[Data]}],ObjectTypes->{Object[Data]}],
								Widget[Type->String,Pattern:>_?dataObjectIDQ,Size->Word]
							]
						]
					},
					IndexName->"input contours"
				]
			},

			Outputs:>{
				{
					OutputName->"options",
					Description->"the options used to plot a waterfall plot from 'dataObjects'.",
					Pattern:>_List
				}
			}
		},

		(* Define usage to accept a standalone 3D data object reference *)
		{
			Definition->{"PlotWaterfallOptions[dataObject]","objPlot"},
			Description->"returns the 'options' to construct a waterfall plot from 'dataObject', a single data object reference that contains a paired list of 2D coordinates and their associated Z-coordinate values.",
			MoreInformation->"The referenced object should contain at least one field whose values comprise a paired list of 2D coordinate pairs and their associated Z-values in the form {{Z,{{X,Y}..}}..}. The field containing the paired list of 2D coordinates may be specified using the PrimaryData option, otherwise it will be inferred from the object type.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"dataObject",
						Description->"A standalone Object[Data] reference of the form ObjectP[Object[Data]]. The referenced object must possess at least one field containing a paired list of 2D coordinate pairs and their associated Z-coordinate values, e.g. {{Z,{{X,Y}..}}..}.",
						Widget->Alternatives[
							Widget[Type->Object,Pattern:>ObjectP[{Object[Data]}],ObjectTypes->{Object[Data]}],
							Widget[Type->String,Pattern:>_?dataObjectIDQ,Size->Word]
						]
					},
					IndexName->"input contours"
				]
			},

			Outputs:>{
				{
					OutputName->"options",
					Description->"the options used to plot a waterfall plot from 'dataObject'.",
					Pattern:>_List
				}
			}
		}
	},
	SeeAlso->{
		"PlotWaterfall",
		"PlotWaterfallPreview",
		"EmeraldListPointPlot3D",
		"Graphics3D",
		"PlotNMR"
	},
	Author->{"yanzhe.zhu", "sebastian.bernasek"},
	Preview->True
}
];

(* ::Subsubsection:: *)
(*PlotWaterfallPreview*)


DefineUsage[PlotWaterfallPreview,{

	BasicDefinitions->{

		(* Define usage to accept paired-list of z-positions and coordinate pairs *)
		{
			Definition->{"PlotWaterfallPreview[stackedData]","preview"},
			Description->"constructs a graphical preview for a waterfall plot from 'stackedData', a collection of 2D coordinate pairs stacked in paired list form alongside their Z-coordinate values.",
			Inputs:>{
				IndexMatching[
					{
						InputName ->"stackedData",
						Description->"A collection of 2D coordinate pairs stacked in paired list form alongside their corresponding Z-coordinate values, e.g. {{Z,{{X,Y}..}}..}. Each set of 2D coordinates corresponds to an independent level in the waterfall, and its paired Z-coordinate value determines its position relative to the other contours.",
						Widget->Adder[
							{
								"Z Coordinate"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
								"XY Coordinates"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[],Size->Line]
							}
						]
					},
					IndexName->"input contours"
				]
			},
			Outputs:>{
				{
					OutputName->"preview",
					Description->"A preview waterfall plot based on the data in `stackedData`.",
					Pattern:>_?ValidGraphicsQ
				}
			}
		},

		(* Define usage to accept a list of object references *)
		{
			Definition->{"PlotWaterfallPreview[dataObjects]","preview"},
			Description->"constructs a graphical preview for a waterfall plot from 'dataObjects', a list of references to data objects that each contain a list of 2D coordinate pairs.",
			MoreInformation->"Each referenced object must contain at least one set of 2D coordinate pairs. The field containing the 2D coordinates may be specified using the PrimaryData option, otherwise it will be inferred from the object type. Typical use cases may include visualizing any 2D data collected over a range of sequential conditions or timepoints.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"dataObjects",
						Description->"A list of Object[Data] references in the form {ObjectP[Object[Data]]..}. All referenced objects must be of the same type and must possess at least one field containing a set of 2D coordinate pairs.",
						Widget->Adder[
							Alternatives[
								Widget[Type->Object,Pattern:>ObjectP[{Object[Data]}],ObjectTypes->{Object[Data]}],
								Widget[Type->String,Pattern:>_?dataObjectIDQ,Size->Word]
							]
						]
					},
					IndexName->"input contours"
				]
			},

			Outputs:>{
				{
					OutputName->"preview",
					Description->"A preview waterfall plot based on the data in `dataObjects`.",
					Pattern:>_?ValidGraphicsQ
				}
			}
		},

		(* Define usage to accept a standalone 3D data object reference *)
		{
			Definition->{"PlotWaterfallPreview[dataObject]","preview"},
			Description->"constructs a graphical preview for a waterfall plot from 'dataObject', a single data object reference that contains a paired list of 2D coordinates and their associated Z-coordinate values.",
			MoreInformation->"The referenced object should contain at least one field whose values comprise a paired list of 2D coordinate pairs and their associated Z-values in the form {{Z,{{X,Y}..}}..}. The field containing the paired list of 2D coordinates may be specified using the PrimaryData option, otherwise it will be inferred from the object type.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"dataObject",
						Description->"A standalone Object[Data] reference of the form ObjectP[Object[Data]]. The referenced object must possess at least one field containing a paired list of 2D coordinate pairs and their associated Z-coordinate values, e.g. {{Z,{{X,Y}..}}..}.",
						Widget->Alternatives[
							Widget[Type->Object,Pattern:>ObjectP[{Object[Data]}],ObjectTypes->{Object[Data]}],
							Widget[Type->String,Pattern:>_?dataObjectIDQ,Size->Word]
						]
					},
					IndexName->"input contours"
				]
			},

			Outputs:>{
				{
					OutputName->"preview",
					Description->"A preview waterfall plot based on the data in `dataObject`.",
					Pattern:>_?ValidGraphicsQ
				}
			}
		}
	},
	SeeAlso->{
		"PlotWaterfallOptions",
		"PlotWaterfall",
		"EmeraldListPointPlot3D",
		"Graphics3D",
		"PlotNMR"
	},
	Author->{"yanzhe.zhu", "sebastian.bernasek"},
	Preview->True
}
];