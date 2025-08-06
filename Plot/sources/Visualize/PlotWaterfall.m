(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*PlotWaterfall Messages*)


Warning::LabelsLengthMismatch="Length of CountourLabels (`1`) does not match the number of contours (`2`). The contour z-coordinate values will be used as labels instead. If custom labels are desired, please try adding or removing some labels until the lengths match.";
Warning::ParallelProjectionInvalid="Parallel projection of a single contour is not supported. In the current plot, WaterfallProjection has instead been set to Perspective. If parallel projection is desired, please try adding more contours.";
Warning::ViewPointUnitMismatch="A dimension of the specified ViewPoint (`1`) has units that are incompatible with the same dimension of the input data (`2`). Please check that the ViewPoint units are consistent with the input data, or specify a unitless numerical value. Defaulting to the provided numerical value (`3`).";


(* ::Subsection::Closed:: *)
(*PlotWaterfall Patterns*)


(* Define pattern to match lists of 2D coordinate pairs that are not strings *)
coordinatesP=myInput_?UnitCoordinatesQ/;MatchQ[myInput,Except[{{_String,_String}..}]];

(* Define pattern to match sparse 3D data in paired-list form {Z,{{X,Y}..}} *)
sparseStackedDataP={(_?QuantityQ|_?NumericQ),UnitCoordinatesP[]};


(* ::Subsection:: *)
(*PlotWaterfall Options*)


DefineOptions[PlotWaterfall,
	Options:>{
		{
			OptionName->PrimaryData,
			Description->"Specifies which object field contains the 2-D data to be plotted.",
			ResolutionDescription->"Retrieves the value of PrimaryData from a pre-compiled table when set to Automatic.",
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Expression, Pattern:>_, Size->Word]
			],
			Category->"Data Specifications"
		},
		{
			OptionName->LabelField,
			Description->"Specifies the object attribute used to set the z-value for each contour in the waterfall.",
			ResolutionDescription->"If set to Automatic, LabelField will default to None unless the input data are in paired list form, in which case the z-coodinate values are used as labels.",
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
				Widget[Type->Enumeration, Pattern:>Alternatives[None]],
				Widget[Type->Expression, Pattern:>_, Size->Word]
			],
			(* Hide this option until Placed[]/Callout[] is supported by command builder *)
			Category->If[TrueQ[$BuilderPreviewNoCallouts],"Hidden","Data Specifications"]			
		},
		{
			OptionName->ContourSpacing,
			Default->Index,
			AllowNull->False,
			Description->"Contours are positioned at regular intervals along the Z-axis when set to Index. When set to Value, contours are positioned in accordance with the Z-coordinates extracted from the input.",
			Widget->Widget[Type->Enumeration, Pattern:>Index|Value],
			Category->"Data Specifications"
		},
		{
			OptionName->ContourLabels,
			Description->"Places custom annotations next to each contour in the waterfall when set to a list of strings. Annotations are ommitted if this is set to None.",
			ResolutionDescription->"ContourLabels defaults to the paired Z-coordinate values in the input data if set to Automatic.",
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,None]],
				Widget[Type->Expression,Pattern:>_,Size->Word,PatternTooltip->"Annotation text."]
			],
			(* Hide this option until Placed[]/Callout[] is supported by command builder *)
			Category->If[TrueQ[$BuilderPreviewNoCallouts],"Hidden","Plot Labeling"]
		},
		{
			OptionName->ContourLabelPositions,
			Description->"Specifies where annotations are displayed relative to the waterfall.",
			Default->After,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>After|Before|Above|Below|Top|Bottom|Right|Left],
			Category->"Plot Labeling"
		},
		{
			OptionName->ContourLabelStyle,
			Description->"Applies formatting to the waterfall annotations when set to a list of directives.",
			Default->{Bold, 14, FontFamily->"Arial"},
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Category->"Plot Labeling"
		},
		{
			OptionName->WaterfallProjection,
			Description->"Sets the method used to construct a two dimensional image of a three dimensional waterfall. When set to Perspective, the waterfall is visualized using a coordinate system with a vanishing horizon. When set to Orthographic, the waterfall is visualized using an oblique transformation in which points are mapped along lines that run parallel to the observer's line of sight. When set to Parallel, the waterfall is visualized using an oblique transformation whose angle and depth are set by ProjectionAngle and ProjectionDepth.",
			Default->Perspective,
			AllowNull->False,
			Widget->
			Widget[Type->Enumeration,
			Pattern:>Perspective|Orthographic|Parallel],
			Category->"3D View"
		},
		{
			OptionName->ProjectionDepth,
			Description->"Sets the length of the z-axis relative to the length of the y-axes. This serves to adjust the spacing between adjacent contours in the waterfall.",
			Default->1,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:>RangeP[0.01, 5],Min->0.01,Max->5],
			Category->"3D View"
		},
		{
			OptionName->ProjectionAngle,
			Description->"Sets the number of radians between the z-axis and the xy-plane when WaterfallProjection is set to Parallel.",
			ResolutionDescription->"The angle between the z-axis and the xy-plane is set to Pi/8 radians when ProjectionAngle is set to Automatic.",
			Default->Automatic,
			AllowNull->True,
			Widget->With[{pi=N@Pi},
				Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
					Widget[Type->Number, Pattern:>RangeP[-pi/3,pi/3],Min->-pi/3,Max->pi/3],
					Widget[Type->Quantity,Pattern:>RangeP[-pi/3 Radian,pi/3 Radian],Units->Radian|AngularDegree]
				]
			],
			Category->"3D View"
		},

		(* Include output option *)
		OutputOption,

		(* Override default option values inherited from ListPlot3DOptions *)
		ModifyOptions[ListPlotOptions,{
			{
				(* Set updated Filling description and default to Bottom *)
				OptionName->Filling,
				Description->"Specifies how the area above or below each contour in the waterfall is displayed.",
				Default->Bottom
			},
			{
				OptionName->InterpolationOrder,
				Category->"Hidden"
			}

		}
		],

		(* Override default option values inherited from ListPlot3DOptions *)
		ModifyOptions[ListPlot3DOptions,{
			{
				(* Expand ViewPoint to accept both quantities and raw numbers *)
				OptionName->ViewPoint,
				Default->Automatic,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
					{
						"Z"->Alternatives[
							Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							Widget[Type->Expression, Pattern:>UnitsP[],Size->Word]
							],
						"X"->Alternatives[
							Widget[Type->Number,Pattern:>RangeP[-Infinity, Infinity]],
							Widget[Type->Expression, Pattern:>UnitsP[],Size->Word]
							],
						"Y"->Alternatives[
							Widget[Type->Number,Pattern:>RangeP[-Infinity, Infinity]],
							Widget[Type->Expression, Pattern:>UnitsP[],Size->Word]
							]
					}
				]
			},
			{
				OptionName->Axes,
				Default->Automatic,
				Widget->Alternatives[
					"All"->Widget[Type->Enumeration,Pattern:>Automatic|True|False],
					"ZXY"->{
						"Z"->Widget[Type->Enumeration,Pattern:>Automatic|True|False],
						"X"->Widget[Type->Enumeration,Pattern:>Automatic|True|False],
						"Y"->Widget[Type->Enumeration,Pattern:>Automatic|True|False]
					},
					"Other"->Widget[Type->Expression,Pattern:>{Repeated[(True|False|Automatic),{1,4}]}|{(True|False|Automatic)|{True|False|Automatic},True|False|Automatic|{True|False|Automatic}},Size->Line]
				]
				(*ResolutionDescription->"The bottom and left sides of the bounding box are shown if the input consists of raw numeric data. If the input contains data object references, suitable axes are inferred from the data type."   *)
			},
			{
				OptionName->AxesEdge,
				Default->Automatic,
				Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[None|Automatic]],
					{
						"Z Edge"->
							Alternatives[
								Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
								{
									"Z First Edge"->Widget[Type->Enumeration, Pattern:>Alternatives[-1|-1.|1.|1|Automatic]],
									"Z Last Edge"->Widget[Type->Enumeration, Pattern:>Alternatives[-1|-1.|1.|1|Automatic]]
								}
							],
						"X Edge"->
							Alternatives[
								Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
								{
									"X First Edge"->Widget[Type->Enumeration, Pattern:>Alternatives[-1|-1.|1.|1|Automatic]],
									"X Last Edge"->Widget[Type->Enumeration, Pattern:>Alternatives[-1|-1.|1.|1|Automatic]]
								}
							],
						"Y Edge"->
							Alternatives[
								Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
								{
									"Y First Edge"->Widget[Type->Enumeration, Pattern:>Alternatives[-1|-1.|1.|1|Automatic]],
									"Y Last Edge"->Widget[Type->Enumeration, Pattern:>Alternatives[-1|-1.|1.|1|Automatic]]
								}
							]
					}
				]
				(*ResolutionDescription->"The x-, y-, and z-axis lines and tick marks are positioned on the bottom, left, and right sides of the waterfall when AxesEdge is set to Automatic."*)
			},
			{
				OptionName->AxesLabel,
				Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[None,Automatic]],
					{
						"Z Label"->Alternatives[
							Widget[Type->Enumeration, Pattern:>Alternatives[None,Automatic]],
							Widget[Type->String, Pattern:>_,Size->Line]
					],
						"X Label"->Alternatives[
							Widget[Type->Enumeration, Pattern:>Alternatives[None,Automatic]],
							Widget[Type->String, Pattern:>_,Size->Line]
					],
						"Y Label"->Alternatives[
							Widget[Type->Enumeration, Pattern:>Alternatives[None,Automatic]],
							Widget[Type->String, Pattern:>_,Size->Line]
					]
					}
				]
			},
			{
				OptionName->AxesUnits,
				Description->"The units of the Z and X and Y axes.",
				Widget->Alternatives[
					{
						"Z Unit"->Alternatives[
							Widget[Type->Expression, Pattern:>_?UnitsQ,Size->Line],
							Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
							Widget[Type->Enumeration, Pattern:>Alternatives[None]]
						],
						"X Unit"->Alternatives[
							Widget[Type->Expression, Pattern:>_?UnitsQ,Size->Line],
							Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
							Widget[Type->Enumeration, Pattern:>Alternatives[None]]
						],
						"Y Unit"->Alternatives[
							Widget[Type->Expression, Pattern:>_?UnitsQ,Size->Line],
							Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
							Widget[Type->Enumeration, Pattern:>Alternatives[None]]
						]
					},
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
					Widget[Type->Enumeration, Pattern:>Alternatives[None]]
				]
			},
			{
				OptionName->PlotRange,
				Widget -> Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
					{
					  "Z Range"->Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
						Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
						Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word,PatternTooltip->"Any valid quantity that matches _?UnitsQ."],
						{
						  "Z Range Minimum"->Alternatives[
							Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
							Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word,PatternTooltip->"Any valid quantity that matches _?UnitsQ."]
						  ],
						  "Z Range Maximum"->Alternatives[
							Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
							Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word,PatternTooltip->"Any valid quantity that matches _?UnitsQ."]
						  ]
						}
					  ],
					  "X Range"->Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
						Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
						Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word,PatternTooltip->"Any valid quantity that matches _?UnitsQ."],
						{
						  "X Range Minimum"->Alternatives[
							Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
							Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word,PatternTooltip->"Any valid quantity that matches _?UnitsQ."]
						  ],
						  "X Range Maximum"->Alternatives[
							Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
							Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word,PatternTooltip->"Any valid quantity that matches _?UnitsQ."]
						  ]
						}
					  ],
					  "Y Range"->Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
						Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
						Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word,PatternTooltip->"Any valid quantity that matches _?UnitsQ."],
						{
						  "Y Range Minimum"->Alternatives[
							Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
							Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word,PatternTooltip->"Any valid quantity that matches _?UnitsQ."]
						  ],
						  "Y Range Maximum"->Alternatives[
							Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
							Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word,PatternTooltip->"Any valid quantity that matches _?UnitsQ."]
						  ]
						}
					  ]
					},
					(* Can resolve to weird nested lists. *)
					Widget[Type->Expression, Pattern:>_, Size->Line]
				  ]
			},
			{
				OptionName->TargetUnits,
				Widget->Alternatives[
					"Set Units"->{
						"Z"->Widget[Type->Expression,Pattern:>Automatic|_?UnitsQ,Size->Word],
						"X"->Widget[Type->Expression,Pattern:>Automatic|_?UnitsQ,Size->Word],
						"Y"->Widget[Type->Expression,Pattern:>Automatic|_?UnitsQ,Size->Word]
					},
					"Default"->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]]
				]
			},
			{
				OptionName->FaceGrids,
				Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[All,None]],
					"Faces"->Adder[
						{
							"Z-Direction"->Widget[Type->Enumeration, Pattern:>Alternatives[0,1,-1]],
							"X-Direction"->Widget[Type->Enumeration, Pattern:>Alternatives[0,1,-1]],
							"Y-Direction"->Widget[Type->Enumeration, Pattern:>Alternatives[0,1,-1]]
						}
					],
					"Faces with GridLines" ->Adder[
						{
							"Face"->
								{
									"Z-Direction"->Widget[Type->Enumeration, Pattern:>Alternatives[0,1,-1]],
									"X-Direction"->Widget[Type->Enumeration, Pattern:>Alternatives[0,1,-1]],
									"Y-Direction"->Widget[Type->Enumeration, Pattern:>Alternatives[0,1,-1]]
								},
							"GridLines"->
								Alternatives[
									Widget[Type->Enumeration,Pattern:>Alternatives[None,Automatic]],
									{
										"X GridLines"->Adder[
											Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
										],
										"Y GridLines"->Adder[
											Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
										]
									},
									{
										"X GridLines"->Adder[
											{
												"Position"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
												"Style"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid style specification."]
											}
										],
										"Y GridLines"->Adder[
											{
												"Position"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
												"Style"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid style specification."]
											}
										]
									},
									Widget[Type->Expression, Pattern:>_, Size->Line, PatternTooltip->"For more information about valid grid line values, evaluate ?GridLines in the notebook."]
								]
						}
					]
				],
				Category->"Hidden"
			},
			{
				OptionName->FaceGridsStyle,
				Category->"Hidden"
			},
			{
				OptionName->ViewCenter,
				Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
					{
						"Z"->Widget[Type->Number,Pattern:>RangeP[0,1],Min->0,Max->1],
						"X"->Widget[Type->Number,Pattern:>RangeP[0,1],Min->0,Max->1],
						"Y"->Widget[Type->Number,Pattern:>RangeP[0,1],Min->0,Max->1]
					}
				]
			},
			{
				OptionName->ViewVector,
				Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
					"Direction"->
						{
							"Z"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
						},
					"Position and Direction"->
					{
						"Position"->
							{
								"Z"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							},
						"Direction"->
							{
								"Z"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
					}
				]
			},
			{
				OptionName->ViewVertical,
				Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
					{
						"Z"->Widget[Type->Number,Pattern:>RangeP[0.,1.]],
						"X"->Widget[Type->Number,Pattern:>RangeP[0.,1.]],
						"Y"->Widget[Type->Number,Pattern:>RangeP[0.,1.]]
					}
				],
				Category->"Hidden"
			},
			{
				OptionName->ViewProjection,
				Category->"Hidden"
			},
			{
				OptionName->Boxed,
				Default->False
			},
			{
				OptionName->ClipPlanes,
				Category->"Hidden"
			},
			{
				OptionName->ClipPlanesStyle,
				Category->"Hidden"
			},
			{
				OptionName->BoxRatios,
				Category->"Hidden"
			}
		}
		]
	},

	SharedOptions:>{

		(* Inherit the 2D EmeraldListLinePlot options PlotWaterfall can support *)
		{EmeraldListLinePlot,{AspectRatio,Legend,LegendLabel,MaxPlotPoints,Normalize,PerformanceGoal,PlotLabels,PlotLayout,PlotRangeClipping,Reflected,RotateLabel,Scale}},

		(* Inherit the 3D EmeraldListLinePlot options PlotWaterfall can support *)
		{EmeraldListPointPlot3D,{AlignmentPoint,AutomaticImageSize,AxesOrigin,AxesStyle,Background,BaselinePosition,BaseStyle,BoxStyle,ColorOutput,ContentSelectable,ControllerLinking,ControllerMethod,ControllerPath,CoordinatesToolOptions,DataRange,DisplayFunction,Epilog,FaceGridsStyle,FillingStyle,FormatType,ImageMargins,ImagePadding,ImageSize,ImageSizeRaw,LabelingSize,LabelStyle,LegendPlacement,Lighting,Method,PlotLabel,PlotLegends,PlotRangePadding,PlotRegion,PlotStyle,PlotTheme,PreserveImageOptions,Prolog,RotationAction,ScalingFunctions,SphericalRegion,Ticks,TicksStyle,TouchscreenAutoZoom,ViewAngle,ViewCenter,ViewMatrix,ViewRange,ViewVector,ViewVertical}}

	}
];


(* ::Subsection::Closed:: *)
(*PlotWaterfall Helper Functions*)


(* Define helper Q function that checks whether the input is a list of quantities *)
quantityListQ=Function[{myList}, And @@ (QuantityQ /@ Flatten@ToList[myList])];

(* Define helper function for converting listed coordinates to stacked data, e.g. {{{X,Y}..}..}-->{{Z,{{X,Y}..}}..} *)
listToStack[myData:{UnitCoordinatesP[]..}]:=MapIndexed[{First@#2, #1} &, ToList@myData];

(* Define helper function to extract first {Z,X,Y} point from sparse stacked data *)
extractFirstPoint=Function[{x}, Prepend[x[[1, 2, 1]], x[[1, 1]]]];

(* Define a helper function for downsampling a list of points while preserving the beginning/end *)
downsamplePoints[pts_,dspec_]:=Module[
	{head,body,tail,bodyDownsampled},

	(* Split the polygon's points into head/body/tail segments *)
	head=pts[[;;4]];
	body=pts[[5;;-5]];
	tail=pts[[-4;;]];

	(* Downsample the body *)
	bodyDownsampled=ArrayResample[body,dspec,Antialiasing->False];

	(* Rejoin the head and tail with the downsampled body *)
	Join[head,bodyDownsampled,tail]

];


(* Define helper function that takes a paired list of z-coordinates and xy-coordinate pairs and returns a 3D line plot *)
listLinePlot3D[myData:{sparseStackedDataP..},ops2D:OptionsPattern[EmeraldListLinePlot]]:=Module[
	{plotOutput,legendContent,maxPolygonPoints,graphics,graphicsData2D,graphicsData3D,graphics3D,
	transformLineRules,transformPolygonRules,transformTextRules,transformPointRules,buildOffsetTransformation},

	(* Plot stacked data in 2D *)
	plotOutput=EmeraldListLinePlot[myData[[All,2]],ToList[ops2D]];

	(* If figure is Legended, extract legend content (Placed) from Graphics so we can re-use it later *)
	legendContent=If[MatchQ[Head@plotOutput,Legended],Last@plotOutput,None];

	(* Extract Graphics object, using Normal@ to unpack GraphicsComplex data into dense form *)
	graphics=Normal@First@Cases[ToList@plotOutput,_Graphics,-1];

	(* Extract graphics data from 2D plot, downsampling polygons with many points to speed up rendering. When Filling is set to Axis this doesn't help because many polygons are fragmented, so we wind up with many thousands of small polygons to render.  *)
	maxPolygonPoints=1000;
	graphicsData2D=First@(graphics/.(Polygon[pts_]:>Polygon[If[Length@pts>maxPolygonPoints,downsamplePoints[pts,{maxPolygonPoints,2}],pts]]));

	(* Compile rules mapping each position of Line in 2D graphics data to a 3D version of Line *)
	transformLineRules=Module[
		{linePositions,linesPerContour,zValues},

		(* Locate Line pattern within graphics data *)
		linePositions=Position[graphicsData2D,_Line];
		
		(*
			in MM 13.3.1 some new lines are added from the new interactivity,
			but contain Key[Primitives] in the position e.g.
			{1,3, Key[Primitives], 5,1} instead of {3,1,2}, so we remove those
		*)
		linePositions = Cases[linePositions, {_Integer..}];

		(* Depending on how many Line instances were found, compile an index-matched list of z-values for each *)
		zValues=Which[

			(* If there aren't any Line instances, return an empty list (no z-values needed) *)
			Length@linePositions==0,{},

			(* If the matching Line instances are the same length as the z-values, return the z-values *)
			Length@linePositions==Length@myData,QuantityMagnitude@myData[[All,1]],

			(* If there are more Line directives than z-values, partition Line objects by their parent list to determine how many lines belong to each contour *)
			Length@linePositions>Length@myData,
			linesPerContour=Length@Cases[#,_Line]&/@Cases[graphicsData2D,{___,_Line..,___},-1];
			QuantityMagnitude@Part[myData[[All,1]],Flatten@MapIndexed[ConstantArray[#2,#1]&,linesPerContour]],

			(* If there are and they are not the same length as the z-values, return an empty list *)
			True,{}

		];

		(* Compile transformation rules mapping Line positions to 3D Line instances *)
		MapThread[#2 ->Part[graphicsData2D,Sequence@@#2]/.{x_?AtomQ,y_?AtomQ}:>{#1,x,y} &,{zValues,linePositions}]

	];

	(* Compile rules mapping each position of a Polygon-containing GraphicsGroup in 2D graphics data to a 3D equivalent *)
	transformPolygonRules=Module[
		{filterForPolygons,graphicsGroupPositions,polygonGroupPositions,numGroupsPerContour,zValues},

		(* Define helper function that takes a list of GraphicsGroup instances and returns those containing a list of Polygons  *)
		filterForPolygons=Function[{groups},Select[groups,Length@Cases[#,{_Polygon..},-1]>0&]];

		(* Locate all GraphicsGroup instances within graphics data *)
		graphicsGroupPositions=Position[graphicsData2D,_GraphicsGroup];

		(* Limit selection to those including lists of polygons *)
		polygonGroupPositions=Select[graphicsGroupPositions,Length@Cases[Part[graphicsData2D,Sequence@@#],{_Polygon..},-1]>0&];

		(* Depending on how many Polygon-containing GraphicsGroup instances were found, compile an index-matched list of z-values for each *)
		zValues=Which[

			(* If there aren't any matches, return an empty list (no z-values needed) *)
			Length@polygonGroupPositions == 0,{},

			(* If the matching directives are the same length as the z-values, return the z-values *)
			Length@polygonGroupPositions == Length@myData,QuantityMagnitude@myData[[All,1]],

			(* If there are more Polygon-containing GraphicsGroup instances than z-values, generate separate plots for each contour to figure out how many each one has *)
			Length@polygonGroupPositions > Length@myData,
			numGroupsPerContour=Module[
				{subPlots},
				subPlots=Quiet[EmeraldListLinePlot[#,ops2D]&/@myData[[All,2]],{Callout::copos}];
				Length@filterForPolygons[Cases[#,_GraphicsGroup,-1]]&/@subPlots
			];
			QuantityMagnitude@Part[myData[[All,1]],Flatten@MapIndexed[ConstantArray[#2,#1] &,numGroupsPerContour]],

			(* Otherwise, return an empty list (this is an error) *)
			True,{}

		];

		(* Compile transformation rules mapping GraphicsGroup positions to transformed coordinates *)
		MapThread[#2 ->Part[graphicsData2D,Sequence@@#2] /. {x_?AtomQ,y_?AtomQ}:>{#1,x,y} &,{zValues,polygonGroupPositions}]

	];

	(* Transform Text *)
	transformTextRules=Module[
		{graphicsGroupPositions,textGroupPositions,zValues},

		(* Locate all GraphicsGroup instances within graphics data *)
		graphicsGroupPositions=Position[graphicsData2D,_GraphicsGroup];

		(* Limit selection to those including Text and lists of Offsets *)
		textGroupPositions=Select[graphicsGroupPositions,Length@Cases[Part[graphicsData2D,Sequence@@#],_Text|{_Offset..},-1]>0&];

		(* Depending on how many Text-containing GraphicsGroup instances were found, compile an index-matched list of z-values for each *)
		zValues=Which[

			(* If there aren't any matches, return an empty list (no z-values needed) *)
			Length@textGroupPositions == 0,{},

			(* If the matching directives are the same length as the z-values, return the z-values *)
			Length@textGroupPositions == Length@myData,QuantityMagnitude@myData[[All,1]],

			(* Otherwise, return as many Z-values as there are matches (occurs if user provides fewer labels than contours)  *)
			True,QuantityMagnitude@myData[[;;Length@textGroupPositions,1]]

		];

		(* Define helper function that takes a Z value and returns a transformation rule mapping listed 2D Offset instances to 3D *)
		buildOffsetTransformation=Function[
			{zValue},
			Module[{transformOffset},
				transformOffset=(Offset[dx_,xy_]:>Prepend[xy,zValue]);
				offsets:{_Offset..}:>((#/.transformOffset)&/@offsets)
			]
		];

		(* Compile transformation rules mapping GraphicsGroup positions to transformed coordinates *)
		MapThread[#2->Part[graphicsData2D,Sequence@@#2]/.{
			Text[text_,Offset[dx_,xy_],offset_]:>Text[text,Prepend[xy,#1],offset],
			buildOffsetTransformation[#1]
			}&,{zValues,textGroupPositions}
		]

	];

	(* Transform Points (mesh) *)
	transformPointRules=Module[
		{pointsListPositions,zValues,combinePointsRule},

		(* Locate all lists of Points within graphics data *)
		pointsListPositions=Position[graphicsData2D,{_Directive,___,{_Point..},___}];

		(* Depending on how many Text-containing GraphicsGroup instances were found, compile an index-matched list of z-values for each *)
		zValues=Which[

			(* If there aren't any matches, return an empty list (no z-values needed) *)
			Length@pointsListPositions == 0,{},

			(* If the matching directives are the same length as the z-values, return the z-values *)
			Length@pointsListPositions == Length@myData,QuantityMagnitude@myData[[All,1]],

			(* Otherwise, return an empty list (this is an error) *)
			True,{}

		];

		(* Compile transformation rules mapping {Directive,___,{Point..},___} positions to transformed coordinates *)
		combinePointsRule=ptList:{_Point..}:>Point@@Flatten[List@@@ptList,{2}];
		MapThread[#2 ->(Part[graphicsData2D,Sequence@@#2]/.combinePointsRule)/.({x_?AtomQ,y_?AtomQ}:>{#1,x,y})&,{zValues,pointsListPositions}]

	];

	(* Convert all 2D Graphics Data to 3D by applying transformation rules *)
	graphicsData3D=ReplacePart[graphicsData2D,Join[transformLineRules,transformPolygonRules,transformTextRules,transformPointRules]];

	(* Return the 3D graphic along with any legend content, using mathematica's resolved 2D plot range for the XY plane *)
	graphics3D=Graphics3D[graphicsData3D,PlotRange->Prepend[PlotRange/.Last@graphics,All]];
	{graphics3D,legendContent}

];


(* Define helper function that computes a ViewMatrix for oblique parallel projection of a set of ZXY coordinates at a specified angle, depth, and XY aspect ratio *)
parallelProjectionMatrix[myData:{sparseStackedDataP..},angle_?NumericQ,depth_?NumericQ,aspect_?NumericQ]:=Module[
	{marginPad,xPad,yPad,xBounds,yBounds,zBounds,dataRange,alpha,
	rescaleToUnitCube,scaleDepth,transformationMatrix,
	frontView,obliqueProjection,projectionMatrix},

	(* Define additional margin padding to preserve room for axes labels *)
	marginPad=0.3;

	(* Re-scale projection angle to account for aspect ratio *)
	alpha=ArcTan[Tan[angle]/aspect];

	(* Compute relative offset due to oblique projection in each direction, using the larger of the two to preserve the XY aspect ratio *)
	xPad={Scaled[marginPad],Scaled[marginPad + Max[{depth*Cos[alpha],depth*Sin[alpha]}]]};
	yPad={Scaled[marginPad],Scaled[marginPad + Max[{depth*Cos[alpha],depth*Sin[alpha]}]]};

	(* Compute data range, padding each range to account for projection depth and inverting Z-range *)
	zBounds=Reverse@MinMax[myData[[All,1]],{Scaled[marginPad+(1/depth)],Scaled[marginPad]}];
	{xBounds,yBounds}=MapThread[MinMax[#1,#2]&,{Transpose@Flatten[myData[[All,2]],1],{xPad,yPad}}];
	dataRange=QuantityMagnitude/@{zBounds,xBounds,yBounds};

	(* Compile transformation matrix mapping data to a unit cube *)
	rescaleToUnitCube=RescalingTransform[dataRange];
	scaleDepth=ScalingTransform[{1,1,1}];
	transformationMatrix=TransformationMatrix@Composition[scaleDepth,rescaleToUnitCube];

	(* Define oblique projection matrix *)
	frontView={{0,1,0,0},{0,0,1,0},{1,0,0,0},{0,0,0,1}};
	obliqueProjection={{1,0,Cos[alpha],0},{0,1,Sin[alpha],0},{0,0,1,0},{0,0,0,1}};
	projectionMatrix=obliqueProjection.frontView;

	(* Return ViewMatrix *)
	{transformationMatrix,projectionMatrix}

];


(* ::Subsection::Closed:: *)
(*PlotWaterfall Overloads*)


(* Accept standalone 2D data, e.g. {{X,Y}..} by wrapping it in a list *)
PlotWaterfall[myData:coordinatesP,ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfall[listToStack@{myData},ops];

(* Accept listed 2D data, e.g. {{{X,Y}..}..} by appending an index *)
PlotWaterfall[myData:{UnitCoordinatesP[]..},ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfall[listToStack@myData,ops];

(* Accept single-layer stacked data, e.g. {Z,{{X,Y}..}} *)
PlotWaterfall[myData:sparseStackedDataP,ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfall[{myData},ops];


(* ::Subsection::Closed:: *)
(*PlotWaterfall Main Function*)


(* Main Entrypoint to PlotWaterfall: multi-layer stacked data, e.g. {{Z,{{X,Y}..}}..} *)
PlotWaterfall[myData:{sparseStackedDataP..},ops:OptionsPattern[]]:=Module[
	{safeOps,resolvedInputs,resolvedData,resolvedOps,finalPlot,axesLabel},

	safeOps=SafeOptions[PlotWaterfall,ToList@ops];

	(* Resolve all inputs and options *)
	Check[
		resolvedInputs=resolvePlotWaterfallInputs[myData,ops],
		Return[$Failed],
		{Error::RepeatedOption}
	];
	{resolvedData,resolvedOps}=resolvedInputs;

	(* Generate Graphics3D *)
	finalPlot=plotWaterfall[resolvedData,ReplaceRule[resolvedOps,Output->Result]];

	(* Return AxesLabel before any rotation/styling/units are applied *)
	axesLabel=Replace[Lookup[safeOps,AxesLabel],Automatic->None];

	(* Return requested Output - either as a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	Lookup[resolvedOps,Output]/.{
		Result:>finalPlot,
		Options:>ReplaceRule[
			resolvedOps,
			Join[
				{AxesLabel->axesLabel},
				Cases[ToList@finalPlot,_Graphics3D,-1][[1,2]]
			],
			Append->False
		],
		(* Remove Text[] from Preview - temporary measure to avert crashing command builder *)
		Preview:>(
			finalPlot/.{
				Rule[ImageSize,_]:>Rule[ImageSize,Full]
			}
		),		
		Tests:>{}
	}
];


(* ::Subsection::Closed:: *)
(*PlotWaterfall Overload for Object[Data] input*)


(* ::Subsubsection::Closed:: *)
(*Messages*)


Error::MixedDataTypes="You are trying to plot data with types `1`. Only one type of data can be plotted at a time.";
Error::UnsupportedDataObject="No fields containing 2-D or 3-D data suitable for constructing a waterfall plot were found within the input object type (`1`). Please try specifying the desired field using the PrimaryData option, or manually provide the stacked coordinates directly to PlotWaterfall.";
Error::PrimaryDataEmpty="The specified PrimaryData field (`1`) is empty for one or more of the input data objects. Please check that the correct PrimaryData field is specified.";
Warning::PrimaryDataInvalid="One or more of the input data objects do not contain 2-D or 3-D data within the PrimaryData field (`1`). Please check that PrimaryData refers to a field containing 2-D data or 3-D data suitable for plotting. Defaulting to the first available field containing valid data.";
Warning::LabelFieldNotFound="The specified LabelField (`1`) was not found within the input data type (`2`). Please check that the field name is correct, and please see the Labels option for specifying manual contour labels. Defaulting to using the contour indices as labels.";
Warning::NonNumericLabelField="The specified LabelField (`1`) does not contain a number or quantity for one or more of the input data objects. If ContourSpacing is set to Value, the values obtained from LabelField will not be used to set each contour's Z-coordinate. They will still be used to set the value of ContourLabels if ContourLabels is set to Automatic.";
Warning::LabelFieldInvalid="The specified LabelField (`1`) does not contain a list of labels. Please check that the field name is correct, or please consider using the ContourLabels option to set the contour labels directly. Defaulting LabelField to None.";
Warning::LabelFieldLengthMismatch="The specified LabelField (`1`) contains a list of labels whose length does not match the 3D input data. Please check that the field name is correct, or please consider using the ContourLabels option to set the contour labels directly. Defaulting LabelField to None.";


(* ::Subsubsection::Closed:: *)
(*Object Patterns*)


(* Define helper function that returns True if its input is the ID of a valid Object[Data] *)
dataObjectIDQ[x_]:=MatchQ[Object[x],ObjectReferenceP[Object[Data]]]&&StringQ[x];

(* Define patterns for matching standalone or listed data object references *)
dataObjectP=ObjectP[Object[Data]]|_?dataObjectIDQ;
dataObjectsP=ListableP[dataObjectP,1];


(* ::Subsubsection::Closed:: *)
(*Helper Function for Resolving Object Data*)


(* Define helper function for resolving data and options for list of Object[Data] input packets *)
resolveObjectInputs[myPackets:{PacketP[Object[Data]]..},primaryData_,labelField_]:=Module[
	{safeOps,dataTypes,dataType,fields2D,fields3D,possibleFields,resolvedPrimaryData,resolvedAxes,
	resolvedAxesLabel,contourData,stackedData,resolvedLabelField,formatLabel,labels,resolvedLabels},

	(* Make sure all packets are of the same type, throwing an error if they're not *)
	dataTypes=Lookup[#,Type]&/@myPackets;
	dataType=If[
		Length[DeleteDuplicates[dataTypes]]>1,
		(Message[Error::MixedDataTypes, dataTypes];Message[Error::InvalidInput,dataTypes];Return[$Failed]),
		First[dataTypes]
	];

	(* Retrieve all potentially plottable 2D and 3D fields for the object type *)
	fields2D=PickList[Keys@First@myPackets,MatchQ[#,UnitCoordinatesP[]]&/@Values@First@myPackets];
	fields3D=PickList[Keys@First@myPackets,MatchQ[#,{sparseStackedDataP..}]&/@Values@First@myPackets];

	(* If only a single packet was provided, Append any fields containing 3D data. Otherwise just return the 2D fields. *)
	possibleFields=If[Length@myPackets==1,Join[fields3D,fields2D],fields2D];

	(* If the user-specified PrimaryData field is invalid, issue a warning and default to the first viable field (Automatic behavior). *)
	If[
		!SameQ[primaryData,Automatic]&&!MemberQ[possibleFields,primaryData],
		Message[Warning::PrimaryDataInvalid,primaryData]
	];

	(* Resolve PrimaryField *)
	resolvedPrimaryData=If[

		(* If the specified primary data field is valid, use it. *)
		MemberQ[possibleFields, primaryData], primaryData,

		(* Otherwise, look up the primary data field for the object type (e.g. Resolve Automatic) *)
		Switch[dataType,

			Object[Data, AbsorbanceSpectroscopy], AbsorbanceSpectrum,
			Object[Data, MeltingCurve], {CoolingCurve, MeltingCurve},
			Object[Data, DifferentialScanningCalorimetry], HeatingCurves,
			Object[Data, FluorescenceKinetics], EmissionTrajectories,
			Object[Data, FluorescenceSpectroscopy], EmissionSpectrum,
			Object[Data, FluorescenceThermodynamics], {CoolingCurve,MeltingCurve},
			Object[Data, LuminescenceKinetics], EmissionTrajectories,
			Object[Data, LuminescenceSpectroscopy], EmissionSpectrum,
			Object[Data, MassSpectrometry], MassSpectrum,
			Object[Data, NMR],If[Length@myPackets==1&&Length@Lookup[First@myPackets,TimedNMRSpectra]>0,TimedNMRSpectra,NMRSpectrum],
			Object[Data, PAGE], OptimalLaneIntensity,
			Object[Data, qPCR], AmplificationCurves,
			Object[Data, Western], MassSpectrum,
			Object[Data, AgaroseGelElectrophoresis], SampleElectropherogram,
			Object[Data, IRSpectroscopy], TransmittanceSpectrum,
			Object[Data, Conductivity], {Conductivity, Temperature},
			Object[Data, Chromatography], Absorbance,

			(* For object types not listed above, lookup the first possible field. If None exist, throw an error. *)
			_,
			If[
				Length@possibleFields>0,
				First@possibleFields,
				Message[Error::UnsupportedDataObject,dataType];Message[Error::InvalidInput,dataType];$Failed
			]

		]
	];

	(* Resolve Axes and AxesLabels *)
	{resolvedAxes,resolvedAxesLabel} = Switch[dataType,

		(* Resolve known data types *)
		Object[Data,NMR],{{False,True,False},{None,"Chemical Shift",None}},
		Object[Data,Chromatography],{{False,True,True},Automatic},

		(* Otherwise, only show X-axis and set AxesLabels to Automatic *)
		_,{{False,True,False},Automatic}

	];

	(* Extract primary data from each packet, flattening nested 3D data and throwing an error if any of the data are empty *)
	contourData=Module[{data},
		data=Lookup[#, resolvedPrimaryData];
		If[
			NullQ@data||Length@data==0,
			Message[Error::PrimaryDataEmpty,resolvedPrimaryData];Message[Error::InvalidInput,
			resolvedPrimaryData];Return[$Failed]
		];
		data] & /@ myPackets;
	contourData=If[MatchQ[First@contourData,{sparseStackedDataP..}],First@contourData,contourData];

	(* Resolve label field - If data came in stacked form, use the z-coordinate values *)
	resolvedLabelField=Replace[labelField,Automatic->If[MatchQ[contourData,{sparseStackedDataP..}],Automatic,None]];

	(* Resolve Labels *)
	resolvedLabels=Which[

		(* If data came in stacked form, pass along Automatic so PlotWaterfall uses the z-coordinate values *)
		SameQ[resolvedLabelField,Automatic],Automatic,

		(* If no LabelField was specified, set ContourLabels to None *)
		SameQ[resolvedLabelField,None], None,

		(* If LabelField was specified, retrieve ContourLabels from the data object packets *)
		MemberQ[Keys@First@myPackets,resolvedLabelField],
		Module[
			{labels2D,labels3D},

			labels2D=Lookup[#,resolvedLabelField]&/@myPackets;
			If[
				!MatchQ[contourData, {sparseStackedDataP..}],

				(* For listed 2D data, return the values from the LabelField *)
				labels2D,

				(* For 3D data, check that LabelField values are a list the same length as the data. *)
				labels3D=First@labels2D;
				Switch[labels3D,

					(* If LabelField values are None, pass along None *)
					None, None,

					(* If they aren't a list throw a warning and set ContourLabels to None *)
					Except[_List],
					Message[Warning::LabelFieldInvalid, resolvedLabelField]; None,

					(* If they are a list but aren't the same length as data, throw a warning and set ContourLabels to None *)
					_List,
					If[Length[labels3D]==Length@(contourData),labels3D,Message[Warning::LabelFieldLengthMismatch,resolvedLabelField];None]

				]
			]
		],

		(* If LabelField wasn't found within the data object packets, throw a warning and set ContourLabels to None *)
		True,
		Message[Warning::LabelFieldNotFound, resolvedLabelField, dataType]; None

	];

	(* Resolve stacked data *)
	stackedData=Which[

		(* If the contour data contain a single 3D dataset, return it *)
		MatchQ[contourData,{sparseStackedDataP..}],contourData,

		(* If ContourLabels are None or Automatic return the plain contour data *)
		MatchQ[resolvedLabels,None|Automatic],listToStack@contourData,

		(* If labels are not all numbers or quantitities, throw a warning that they will only be used as ContourLabels *)
		!AllTrue[resolvedLabels,MatchQ[#,UnitsP[]]&],
		Message[Warning::NonNumericLabelField,labelField]; listToStack@contourData,

		(* Otherwise, thread the contour data with the labels. *)
		True, Thread[{resolvedLabels, contourData}]

	];

	(* Return stacked data along with the resolved PrimaryData field and resolved labels in string format *)
	{stackedData,resolvedPrimaryData,resolvedLabels,resolvedAxes,resolvedAxesLabel,resolvedLabelField}

];


(* ::Subsubsection:: *)
(*PlotWaterfall Object[Data] Overload*)


(* Accept a list of data objects or references of the same type, passing on the stacked 2D data for each to PlotWaterfall *)
PlotWaterfall[myObjects:dataObjectsP,ops:OptionsPattern[PlotWaterfall]]:=Module[
	{safeOps,objects,objectPackets,resolvedObjectInputs,objectData,objectLabels,resolvedPrimaryData,resolvedLabelField,
	contourLabels,resolvedContourLabels,axes,objectAxes,resolvedAxes,axesLabel,objectAxesLabel,resolvedAxesLabel},

	safeOps=SafeOptions[PlotWaterfall, ToList@ops];

	(* Convert ID strings to objects *)
	objects=If[MatchQ[#,_String],Object[#],#]&/@ToList@myObjects;

	(* Download each object, throwing an error if any are not found *)
	Check[
		objectPackets=Download[objects],
		With[
			{missingObjects=Select[objects,Quiet[MatchQ[Download[#],$Failed],{Download::ObjectDoesNotExist}]&]},
			Message[Error::InvalidInput,missingObjects];Return[$Failed]
		],
		{Download::ObjectDoesNotExist}
	];

	(* Extract stacked data and labels from object packets, returning $Failed if any errors were encountered *)
	Check[
		resolvedObjectInputs=resolveObjectInputs[objectPackets,Lookup[safeOps,PrimaryData],Lookup[safeOps,LabelField]],
		Return[$Failed],
		{Error::MixedDataTypes,Error::UnsupportedDataObject,Error::PrimaryDataEmpty,Error::InvalidInput}
	];
	{objectData,resolvedPrimaryData,objectLabels,objectAxes,objectAxesLabel,resolvedLabelField}=resolvedObjectInputs;

	(* If ContourLabels was explicitly defined, override the objectLabels inferred from LabelField *)
	contourLabels=Lookup[safeOps, ContourLabels];
	resolvedContourLabels=If[SameQ[contourLabels,Automatic],objectLabels,contourLabels];

	(* If Axes was explicitly defined, override the objectAxes inferred from the object data type *)
	axes=Lookup[safeOps,Axes];
	resolvedAxes=If[SameQ[axes,Automatic],objectAxes,axes];

	(* If AxesLabel was explicitly defined, override the objectAxesLabel inferred from the object data type *)
	axesLabel=Lookup[safeOps,AxesLabel];
	resolvedAxesLabel=If[SameQ[axesLabel,Automatic],objectAxesLabel,axesLabel];

	(* Call PlotWaterfall *)
	PlotWaterfall[objectData,
		ReplaceRule[safeOps,{
			PrimaryData->resolvedPrimaryData,
			ContourLabels->resolvedContourLabels,
			LabelField->resolvedLabelField,
			Axes->resolvedAxes,
			AxesLabel->resolvedAxesLabel
			}
		]
	]
];


(* ::Subsection::Closed:: *)
(*PlotWaterfall Option Resolution*)


resolvePlotWaterfallInputs[myData:{sparseStackedDataP..},myOptions:OptionsPattern[PlotWaterfall]]:=Module[
	{safeOps,ops3D,emerald3Dfigure,resolvedOps3D,resolvedData,resolvedOps,includeUnits,validLabelsQ,formatLabel,
	plotRange,plotRange3D,scalingFunction,scalingFunction3D,scale,xScaling,yScaling,resolvedScalingFunction,
	plotLabels,resolvedPlotLabels,contourLabels,resolvedContourLabels,stringContourLabels,targetUnits,zTargetUnits,zValues,indexUnits,
	waterfallProjection,resolvedWaterfallProjection,projectionAngle,resolvedProjectionAngle,
	projectionDepth,resolvedProjectionDepth,aspectRatio,boxRatios,viewPoint,resolvedViewPoint,
	viewMatrix,resolvedViewMatrix,axes,resolvedAxes,axesEdge,resolvedAxesEdge,plotStyle,resolvedPlotStyle,
	plotRangePadding,resolvedPlotRangePadding,lighting,resolvedLighting,axesLabel,resolvedAxesLabel,method,resolvedMethod,
	resolvedPrimaryData,resolvedLegend,resolvedTargetUnits,resolvedAxesUnits},

	(* Extract safe options for PlotWaterfall, throwing an error if any are repeated *)
	Check[
		safeOps=SafeOptions[PlotWaterfall,ToList@myOptions],
		Return[$Failed],
		{Error::RepeatedOption}
	];

	(* Define helper function to check that provided list of labels are valid *)
	validLabelsQ[labels_]:=(Length[labels]==Length@myData);

	(* Convert Z-values to specified units *)
	targetUnits=Lookup[safeOps,TargetUnits];
	zTargetUnits=If[MatchQ[targetUnits,{_,_,_}],First@targetUnits,targetUnits];
	zValues=If[!SameQ[zTargetUnits,Automatic],Convert[myData[[All,1]],zTargetUnits],myData[[All,1]]];

	(* Resolve ContourLabels - Automatic defaults to using the z-values as labels *)
	contourLabels=Lookup[safeOps, ContourLabels];
	resolvedContourLabels=Switch[contourLabels,

		(* Null/None uses blank labels *)
		None|_?NullQ,None,

		(* Automatic uses Z coordinate value *)
		Automatic,zValues,

		(* Custom list of labels *)
		_?validLabelsQ,contourLabels,

		(* Invalid labels pattern issues warning and uses automatic labels *)
		_,Message[Warning::LabelsLengthMismatch,Length@contourLabels,Length@myData]; zValues

	];

	(* Define helper function for formatting each item in ContourLabels *)
	formatLabel=Switch[#,

		_String,#,

		_?QuantityQ,ToString[QuantityForm[#,"Abbreviation"],FormatType->TraditionalForm],

		_DateObject,DateString[#,"Time"],

		_,ToString[#,FormatType->TraditionalForm]

		]&;

	(* Convert each label to string form *)
	stringContourLabels=formatLabel/@resolvedContourLabels;

	(* Resolve PlotLabels *)
	resolvedPlotLabels=If[
		MatchQ[stringContourLabels,Except[None]],

		(* If ContourLabels is not None, PlotLabels is set to ContourLabels *)
		Placed[stringContourLabels,{ToList@Lookup[safeOps,ContourLabelPositions]},LabelStyle->Lookup[safeOps,ContourLabelStyle]],

		(* Otherwise, resolve PlotLabels. We will feed each label to EmeraldListLinePlot as a Placed[] instance with a double-nested position directive (e.g. {{After}}), otherwise mathematica will move the labels around in its own attempt to prevent them from overlapping, which we don't want because we're moving them to separate points in the z-plane anyway. *)
		plotLabels=Lookup[safeOps,PlotLabels];
		Switch[plotLabels,

			(* Return None if no plot labels were provided *)
			None|_?NullQ,None,

			(* For Placed/Callout or a list there of, ensure the position directive is within a nested list  *)
			_Placed|_Callout,ReplacePart[plotLabels,2->{{Flatten@Part[plotLabels,2]}}],
			{_Placed|_Callout..},ReplacePart[#,2->{{Flatten@Part[#,2]}}]&/@plotLabels,

			(* For a list of labels, put them within a Placed[] wrapper *)
			_List,Placed[plotLabels,{{After}}],

			(* If no patterns were recognized, pass along the values for mathematica to resolve *)
			_,plotLabels

		]

		(* In MM v12.0, {{After}} will error if the label is a single string or list of length 1, this is a workaround *)
		(* Problem persists in 13.2 even with multiple strings, but a single {After} always works, so just replace with that. *)
		]/.{Placed[labels:{__},{{After}},rest___]:>Placed[labels,{After},rest]};

	(* Check whether XY data have attached units *)
	includeUnits=quantityListQ[myData[[All, -1]]];

	(* Set index to use the Z-axis units *)
	indexUnits=If[
		QuantityQ[First@zValues],
		QuantityUnit[First@zValues],

		(* If Z-values have no units, but XY data do, use an ArbitraryUnit *)
		If[includeUnits,ArbitraryUnit,"DimensionlessUnit"]
	];

	(* Resolve data by replacing z-coordinate values in accordance with ContourSpacing - if XY data have units,
	we have to add an arbitrary unit to Z because EmeraldListPointPlot3D doesn't allow mixed numbers/quantities *)
	resolvedData=If[

		(* Space by index *)
		MatchQ[Lookup[safeOps,ContourSpacing],Index],
		MapIndexed[{Quantity[First@#2,indexUnits],Last@#1}&,myData,1],

		(* Space by value *)
		If[
			includeUnits&&!quantityListQ[myData[[All,1]]],
			Map[{First@# ArbitraryUnit, Last@#}&,myData,1],
			Thread[{zValues,myData[[All,2]]}]
		]
	];

	(* Resolve TargetUnits - Automatic defaults to {Automatic, X Units, Y Units} *)
	resolvedTargetUnits=If[
		SameQ[targetUnits,Automatic],
		Join[{Automatic},If[QuantityQ@Units[#],Units[#],Automatic]&/@resolvedData[[1,2,1]]],
		targetUnits
	];

	(* Resolve AxesUnits - Automatic defaults to resolved TargetUnits *)
	resolvedAxesUnits=If[
		SameQ[Lookup[safeOps,AxesUnits],Automatic],
		resolvedTargetUnits,
		Lookup[safeOps,AxesUnits]
	];

	(* Resolve WaterfallProjection (built-in string based version of WaterfallProjection) *)
	waterfallProjection=Lookup[safeOps,WaterfallProjection];
	resolvedWaterfallProjection=If[
		SameQ[waterfallProjection,Parallel]&&Length@resolvedData==1,
		Message[Warning::ParallelProjectionInvalid]; Perspective,
		waterfallProjection
	];

	(* Resolve ViewPoint - Automatic defaults to {3,0,0.5} when WaterfallProjection is set to Perspective or Orthographic. ViewPoint is superseded by ViewMatrix when WaterfallProjection is set to Parallel. *)
	viewPoint=Lookup[safeOps, ViewPoint];
	resolvedViewPoint=If[

		(* If WaterfallProjection is Parallel, set ViewPoint to Front because it will be superseded by ViewMatrix anyway *)
		SameQ[resolvedWaterfallProjection, Parallel], Front,

		(* Otherwise, resolve the viewpoint specification *)
		Switch[viewPoint,

			(* Automatic defaults to {3,0,0.5} by default *)
			Automatic,{3,0,0.5},

			(* Otherwise, ensure ViewPoint is either dimensionless or consistent with input data units *)
			_,
			MapThread[
				Which[

				(* Convert provided units to the input dimension scale *)
				UnitsQ[#1, #2], QuantityMagnitude@Convert[#1, #2],

				(* Pass numerical values straight through *)
				NumericQ[#1], #1,

				(* If units are inconsistent with the input data, warn the user and use the dimensionless value *)
				QuantityQ[#1],
				Message[Warning::ViewPointUnitMismatch,#1,#2,QuantityMagnitude@#1]; QuantityMagnitude@#1

				]&,{viewPoint,Units@extractFirstPoint[resolvedData]}
			]
		]
	];

	(* Resolve ProjectionAngle - Automatic defaults to Pi/6 when WaterfallProjection is set to Parallel. *)
	projectionAngle=Lookup[safeOps, ProjectionAngle];
	resolvedProjectionAngle=If[
		SameQ[resolvedWaterfallProjection, Parallel],
		If[
			SameQ[projectionAngle, Automatic],
			Pi/6,

			(* Convert user provided values to radians and strip units *)
			If[QuantityQ[projectionAngle],QuantityMagnitude[projectionAngle,Radian],projectionAngle]

		],
		Null
	];

	(* Resolve BoxRatios - used to set aspect ratio when WaterfallProjection is set to Perspective, otherwise set to {0.2,1,1} to preserve tick lengths *)
	projectionDepth=Lookup[safeOps, ProjectionDepth];
	aspectRatio=Lookup[safeOps, AspectRatio];
	boxRatios=If[
		SameQ[resolvedWaterfallProjection,Parallel],
		{0.2,1,1},
		{projectionDepth, 1, aspectRatio}
	];

	(* Resolve ViewMatrix - Automatic yields a calculated projection matrix when WaterfallProjection is set to Parallel *)
	viewMatrix=Lookup[safeOps, ViewMatrix];
	resolvedViewMatrix=Which[

		(* If the user specified ViewMatrix, use the provided values *)
		! SameQ[viewMatrix,Automatic],viewMatrix,

		(* Otherwise, if ViewProjection is parallel compute and use the oblique parallel view matrix. ProjectionDepth is scaled down 5x to maintain parity with perspective projection *)
		SameQ[resolvedWaterfallProjection,Parallel],
		parallelProjectionMatrix[resolvedData,resolvedProjectionAngle,projectionDepth/5,aspectRatio],

		(* Otherwise pass through Automatic and let EmeraldListPointPlot3D resolve it *)
		True, Automatic

	];

	(* Resolve Axes - Automatic defaults to Left/Bottom *)
	axes=Lookup[safeOps,Axes];
	resolvedAxes=If[SameQ[axes,Automatic],{False,True,True},axes];

	(* Resolve AxesEdge - Automatic defaults to Left/Bottom/Right axes *)
	axesEdge=Lookup[safeOps, AxesEdge];
	resolvedAxesEdge=If[SameQ[axesEdge, Automatic],{{-1,1},{1,-1},{1,-1}},axesEdge];

	(* Resolve PlotStyle - Automatic defaults to thick lines and a rainbow color gradient *)
	plotStyle=Lookup[safeOps, PlotStyle];
	resolvedPlotStyle=If[
		SameQ[plotStyle, Automatic],
		{Thick,ColorData["Rainbow"][#]}&/@(Range[0,Length@resolvedData]/Length@resolvedData),
		plotStyle
	];

	(* Resolve PlotRangePadding - Automatic defaults to 4% on all sides *)
	plotRangePadding=Lookup[safeOps,PlotRangePadding];
	resolvedPlotRangePadding=If[SameQ[plotRangePadding,Automatic],Scaled[0.04],plotRangePadding];

	(* Convert 2D PlotRange specification to 3D *)
	plotRange=Lookup[safeOps,PlotRange];
	plotRange3D=If[MatchQ[plotRange,{_,_}],Prepend[plotRange,All],plotRange];

	(* Resolve scaling functions for z-, y-, and x-axes. Several options redundantly affect these *)
	(* We prioritize Reflected > Scale > ScalingFunctions *)

	(* Convert 2D ScalingFunctions specification to 3D (lowest priority) *)
	scalingFunction=Lookup[safeOps,ScalingFunctions];
	scalingFunction3D=Switch[scalingFunction,
		None,{None,None,None},
		{_,_},Prepend[scalingFunction,None],
		_,scalingFunction
	];

	(* Resolve X/Y scaling function from Scale (highest priority for Y, middle priority for X) *)
	scale=Switch[Lookup[safeOps,Scale],
		Linear,{None,None},
		Log|LinearLog,{None,"Log10"},
		LogLinear,{"Log10",None},
		LogLog,{"Log10","Log10"}
	];

	(* Resolve X-scaling from Reflected (highest priority) *)
	xScaling=Which[
		TrueQ@Lookup[safeOps,Reflected],"Reverse",
		MatchQ[First@scale,Except[None]],First@scale,
		True,scalingFunction3D[[2]]
	];
	yScaling=If[MatchQ[Last@scale,Except[None]],Last@scale,Last@scalingFunction3D];
	resolvedScalingFunction={First@scalingFunction3D,xScaling,yScaling};

	(* Compile 3D plot options. This entails replacing potentially 2D options with 3D alternatives,
	setting Output to Result so we get back fully resolved Graphics3D instance, and replacing any
	unused options whose values might not conform to the pattern expected by EmeraldListPointPlot3D (e.g. ViewPoint) *)
	ops3D=PassOptions[EmeraldListPointPlot3D,
		Join[
			{
				PlotRange->plotRange3D,
				ScalingFunctions->resolvedScalingFunction,
				ViewPoint->resolvedViewPoint
			},
			ReplaceRule[safeOps,Output->Result]
		]
	];

	(* Feed a single point to EmeraldListPointPlot3D to leverage its option resolution for formatting 3D graphics *)
	emerald3Dfigure=EmeraldListPointPlot3D[QuantityArray@{extractFirstPoint[resolvedData]},ops3D];

	(* Extract the resolved Graphics3D options from the plot generated by EmeraldListPointPlot3D *)
	resolvedOps3D=Last@First@Cases[ToList@emerald3Dfigure,_Graphics3D,-1];

	(* Resolve Lighting - invert lighting if WaterfallProjection is Parallel *)
	lighting=Lookup[resolvedOps3D, Lighting];
	resolvedLighting=If[
		SameQ[resolvedWaterfallProjection, Parallel],
		lighting/.img:ImageScaled[{_?NumericQ..}]:>ImageScaled[-First@img],
		lighting
	];

	(* Resolve AxesLabel - rotate the y-axis label so it's vertical *)
	axesLabel=AxesLabel/.resolvedOps3D;
	resolvedAxesLabel=If[Lookup[safeOps,RotateLabel],Append[Most@axesLabel,Rotate[Last@axesLabel,90 Degree]],axesLabel];

	(* Resolve Method - when WaterfallProjection is Parallel, shrink-wrap the plot to remove any excess margin padding *)
	method=Lookup[resolvedOps3D, Method];
	resolvedMethod=If[SameQ[method,Automatic]&&SameQ[resolvedWaterfallProjection,Parallel],{"ShrinkWrap"->True},method];

	(* Resolve PrimaryData by setting Automatic to Null *)
	resolvedPrimaryData=Replace[Lookup[safeOps,PrimaryData],Automatic->Null];

	(* Resolve Legend by setting Automatic to None *)
	resolvedLegend=Replace[Lookup[safeOps,Legend],Automatic->None];

	(* Update options, prioritizing locally resolved options over resolved Emerald ops *)
	resolvedOps=ReplaceRule[safeOps,
		Join[
			{
				Output->Lookup[safeOps,Output],
				PrimaryData->resolvedPrimaryData,
				TargetUnits->resolvedTargetUnits,
				AxesUnits->resolvedAxesUnits,
				WaterfallProjection->resolvedWaterfallProjection,
				ViewProjection->ToString[resolvedWaterfallProjection],
				ViewPoint->resolvedViewPoint,
				ViewMatrix->resolvedViewMatrix,
				ProjectionAngle->resolvedProjectionAngle,
				BoxRatios->boxRatios,
				Axes->resolvedAxes,
				AxesEdge->resolvedAxesEdge,
				ContourLabels->resolvedContourLabels,
				PlotLabels->resolvedPlotLabels,
				PlotStyle->resolvedPlotStyle,
				PlotRangePadding->resolvedPlotRangePadding,
				ScalingFunctions->resolvedScalingFunction,
				Lighting->resolvedLighting,
				AxesLabel->resolvedAxesLabel,
				Method->resolvedMethod,
				Legend->resolvedLegend
			},
			resolvedOps3D
		]
	];

	(* Return resolved data and options *)
	{resolvedData,resolvedOps}

];


(* ::Subsection:: *)
(*PlotWaterfall Core Function*)


(* Define private core function for plotting stacked lines in 3D while preserving all of Emerald's Graphics3D formatting options. Function takes sparse stacked data in {{Z,{{X,Y}..}}..} form and returns a Graphics3D object. *)
plotWaterfall[myData:{sparseStackedDataP..},resolvedOps:OptionsPattern[PlotWaterfall]]:=Module[
	{ops2D,excluded2DOps,linesGraphic,legendContent,projectionDepth,projectionAngle,
	plotRange,plotRange2D,plotRange3D,resolvedPlotRange2D,
	scalingFunction,scalingFunction2D,scalingFunction3D,
	targetUnits,targetUnits2D,
	graphics3D},

	(* Reconcile 2D vs 3D input for PlotRange *)
	plotRange=Lookup[resolvedOps, PlotRange];
	plotRange2D=If[MatchQ[plotRange,{_,_,_}],Rest@plotRange,plotRange];

	(* Reconcile 2D vs 3D input for ScalingFunctions *)
	scalingFunction=Lookup[resolvedOps, ScalingFunctions];
	scalingFunction2D=If[MatchQ[scalingFunction,{_,_,_}],Rest@scalingFunction,scalingFunction];
	scalingFunction3D=If[MatchQ[scalingFunction,{_,_}],Prepend[scalingFunction,None],scalingFunction];

	(* Reconcile 2D vs 3D input for TargetUnits *)
	targetUnits=Lookup[resolvedOps, TargetUnits];
	targetUnits2D=If[MatchQ[targetUnits,{_,_,_}],Rest@targetUnits,targetUnits];

	(* Compile list of options excluded from EmeraldListLinePlot *)
	excluded2DOps={Prolog,Epilog,Reflected,Scale,ImageSize};

	(* Replace 3D options with 2D counterparts *)
	ops2D=PassOptions[EmeraldListLinePlot,
		Join[
			{
				PlotRange->plotRange2D,
				ScalingFunctions->scalingFunction2D,
				TargetUnits->targetUnits2D,
				AxesUnits->Automatic
			},
			Select[resolvedOps,!MemberQ[excluded2DOps,First@#]&]
		]
	];

	(* Call listLinePlot3D helper function to construct 3D line graphic as well as any legend content *)
	{linesGraphic,legendContent}=listLinePlot3D[myData,ops2D];

	(* Extract the resolved XY plot range from the lines graphic, then combine it with the specified Z-range *)
	plotRange3D=Join[{If[MatchQ[plotRange,_List],First@plotRange,plotRange]},Rest@PlotRange[linesGraphic]];

	(* Render lines using resolved options for Graphics3D *)
	graphics3D=Show[
		linesGraphic,
		PassOptions[Graphics3D,ReplaceRule[resolvedOps,PlotRange->plotRange3D]]
	];

	(* Return the final graphics3D object, wrapped with any legend content that was extracted by listLinePlot3D  *)
	If[
		MatchQ[legendContent,Except[None]],
		Legended[graphics3D,legendContent],
		graphics3D
	]
];


(* ::Subsection::Closed:: *)
(*PlotWaterfall Sister Functions*)


(* ::Subsubsection::Closed:: *)
(*PlotWaterfallOptions*)


(* Accept standalone 2D data, e.g. {{X,Y}..} by wrapping it in a list *)
PlotWaterfallOptions[myData:coordinatesP,ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfallOptions[listToStack@{myData},ops];

(* Accept listed 2D data, e.g. {{{X,Y}..}..} by appending an index *)
PlotWaterfallOptions[myData:{UnitCoordinatesP[]..},ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfallOptions[listToStack@myData,ops];

(* Accept single-layer stacked data, e.g. {Z,{{X,Y}..}} *)
PlotWaterfallOptions[myData:sparseStackedDataP,ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfallOptions[{myData},ops];

(* Accept multi-layer stacked data, e.g. {{Z,{{X,Y}..}}..} *)
PlotWaterfallOptions[myData:{sparseStackedDataP..},ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfall[myData,ops,Output->Options];

(* Accept listable Object[Data] inputs *)
PlotWaterfallOptions[myObjects:dataObjectsP,ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfall[myObjects,ops,Output->Options];


(* ::Subsubsection::Closed:: *)
(*PlotWaterfallPreview*)


(* Accept standalone 2D data, e.g. {{X,Y}..} by wrapping it in a list *)
PlotWaterfallPreview[myData:coordinatesP,ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfallPreview[listToStack@{myData},ops];

(* Accept listed 2D data, e.g. {{{X,Y}..}..} by appending an index *)
PlotWaterfallPreview[myData:{UnitCoordinatesP[]..},ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfallPreview[listToStack@myData,ops];

(* Accept single-layer stacked data, e.g. {Z,{{X,Y}..}} *)
PlotWaterfallPreview[myData:sparseStackedDataP,ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfallPreview[{myData},ops];

(* Accept multi-layer stacked data, e.g. {{Z,{{X,Y}..}}..} *)
PlotWaterfallPreview[myData:{sparseStackedDataP..},ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfall[myData,ops,Output->Preview];

(* Accept listable Object[Data] inputs *)
PlotWaterfallPreview[myObjects:dataObjectsP,ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfall[myObjects,ops,Output->Preview];


(* ::Subsubsection::Closed:: *)
(*PlotWaterfallTests*)


(* Accept standalone 2D data, e.g. {{X,Y}..} by wrapping it in a list *)
PlotWaterfallTests[myData:coordinatesP,ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfallTests[listToStack@{myData},ops];

(* Accept listed 2D data, e.g. {{{X,Y}..}..} by appending an index *)
PlotWaterfallTests[myData:{UnitCoordinatesP[]..},ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfallTests[listToStack@myData,ops];

(* Accept single-layer stacked data, e.g. {Z,{{X,Y}..}} *)
PlotWaterfallTests[myData:sparseStackedDataP,ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfallTests[{myData},ops];

(* Accept multi-layer stacked data, e.g. {{Z,{{X,Y}..}}..} *)
PlotWaterfallTests[myData:{sparseStackedDataP..},ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfall[myData,ops,Output->Tests];

(* Accept listable Object[Data] inputs *)
PlotWaterfallTests[myObjects:dataObjectsP,ops:OptionsPattern[PlotWaterfall]]:=PlotWaterfall[myObjects,ops,Output->Tests];
