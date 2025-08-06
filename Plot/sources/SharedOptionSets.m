(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Shared Options*)



(* ::Subsubsection:: *)
(*Search Function*)


(* Helper function takes a symbolic option name as input and returns a list of predefined option sets containing its definition statement *)
findParentOptionSet[optionName_Symbol]:=Module[
	{optionSets,search,results},

	(* Define helper function to search an individual option set for the specified option *)
	search=Function[
		{name,set},

		Module[
			{listedOptionDefinitions,matches},

			(* Compile list of option definitions for the option set *)
			listedOptionDefinitions=MapThread[Rule,{Keys@#,Values@#}]&/@OptionDefinition@set;

			(* Filter for the option with the specified name *)
			matches=Select[listedOptionDefinitions,SameQ["OptionName"/.#,ToString@name]&];
			If[Length@matches==0,None,First@matches]
		]
	];

	(* Search all option sets *)
	optionSets={ListPlotOptions,ChartOptions,BarChartOptions,PieChartOptions,SmoothHistogramOptions,ListPlot3DOptions};
	results=(#->search[optionName,#]&/@optionSets);

	(* Return positive matches *)
	Select[results,!MatchQ[Last@#,None]&]

];


(* ::Subsubsection::Closed:: *)
(*ListPlotOptions*)


DefineOptionSet[
	ListPlotOptions :> {
		(* Image Format Options *)
		{
			OptionName->AspectRatio,
			Default->1/GoldenRatio,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Number, Pattern:>GreaterP[0.]],
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]]
			],
			Description->"The ratio of height to width for this plot.",
			Category->"Image Format"
		},
		{
			OptionName -> ImageSize,
			Default -> 600,
			Description -> "Sets the size of the resulting plot.",
			AllowNull -> False,
			Category -> "Image Format",
			Widget->Alternatives[
				"Size"->Widget[Type->Number,Pattern:>GreaterP[0.],PatternTooltip->"Set n, where image size is n x n pixels:"],
				"Width and Height"->{
					"Width"->Widget[Type->Number,Pattern:>GreaterP[0.],PatternTooltip->"Set w, where image size is w x h pixels:"],
					"Height"->Widget[Type->Number,Pattern:>GreaterP[0.],PatternTooltip->"Set h, where image size is w x h pixels:"]
				},
				"Presets"->Widget[Type->Enumeration,Pattern:>Tiny|Small|Medium|Large|Full],
				"Other"->Widget[Type->Expression, Pattern:>ImageSizeP, Size->Line]
			]
		},

		(* Plot Range Options *)
		{
			OptionName -> PlotRange,
			Default -> Automatic,
			Description -> "PlotRange specification for the primary data.  PlotRange units must be compatible with units of primary data.",
			AllowNull -> False,
			Category -> "Plot Range",
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
				{
					"X Range"->Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
						Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
						Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word,PatternTooltip->"Any valid quantity that matches _?UnitsQ."],
						{
							"X Range Minimum"->Alternatives[
								Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
								Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word,PatternTooltip->"Any valid quantity that matches _?UnitsQ."],
								Widget[Type->Date,Pattern:>_?DateObjectQ,PatternTooltip->"Any valid date.",TimeSelector->True]
							],
							"X Range Maximum"->Alternatives[
								Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
								Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								Widget[Type->Date,Pattern:>_?DateObjectQ,PatternTooltip->"Any valid date.",TimeSelector->True]
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
			OptionName->PlotRangeClipping,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True, False]],
			Description->"Specifies whether graphics objects should be clipped at the edge of the region defined by PlotRange, or should be allowed to extend to the actual edge of the image.",
			Category->"Plot Range"
		},
		{
			OptionName->ClippingStyle,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[None,Automatic,Opacity[0.25],Opacity[0.5],Opacity[0.75]]],
				Widget[Type->Color,Pattern:>ColorP],
				Widget[Type->Expression, Pattern:>_, Size->Line, PatternTooltip->"The clipping style can be set to any valid graphics directive. For more information, evaluate ?ClippingStyle in the notebook."]
			],
			Description->"The style of the curves or surfaces that extend beyond the plot range.",
			Category->"Plot Range"
		},

		(* Plot Labeling *)
		{
			OptionName->PlotLabel,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				"String"->Widget[Type->String,Pattern:>_String,Size->Line,PatternTooltip->"A String, styled according to LabelStyle."],
				"Styled String"->Widget[Type->Expression,Pattern:>_Style,Size->Line,BoxText->"Style[\"label\",<directives>]"],
				"Other"->Widget[Type->Expression,Pattern:>_,Size->Paragraph]
			],
			Description->"Specifies an overall label for a plot.",
			Category->"Plot Labeling"
		},
		{
			OptionName->FrameLabel,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
					{
						"Horizontal Labels"->{
							"Left Label"->Alternatives[
								Widget[Type->Enumeration,Pattern:>Alternatives[None]],
								Widget[Type->Expression,Pattern:>_,Size->Line]
							],
							"Right Label"->Alternatives[
								Widget[Type->Enumeration,Pattern:>Alternatives[None]],
								Widget[Type->Expression,Pattern:>_,Size->Line]
							]
						},
						"Vertical Labels"->{
							"Bottom Label"->Alternatives[
								Widget[Type->Enumeration,Pattern:>Alternatives[None]],
								Widget[Type->Expression,Pattern:>_,Size->Line]
							],
							"Top Label"->Alternatives[
								Widget[Type->Enumeration,Pattern:>Alternatives[None]],
								Widget[Type->Expression,Pattern:>_,Size->Line]
							]
						}
					},
					{
						"Bottom Label"->Alternatives[
							Widget[Type->Enumeration,Pattern:>Alternatives[None]],
							Widget[Type->Expression,Pattern:>_,Size->Line]
						],
						"Left Label"->Alternatives[
							Widget[Type->Enumeration,Pattern:>Alternatives[None]],
							Widget[Type->Expression,Pattern:>_,Size->Line]
						]
					},
					{
						"Bottom Label"->Alternatives[
							Widget[Type->Enumeration,Pattern:>Alternatives[None]],
							Widget[Type->Expression,Pattern:>_,Size->Line]
						],
						"Left Label"->Alternatives[
							Widget[Type->Enumeration,Pattern:>Alternatives[None]],
							Widget[Type->Expression,Pattern:>_,Size->Line]
						],
						"Top Label"->Alternatives[
							Widget[Type->Enumeration,Pattern:>Alternatives[None]],
							Widget[Type->Expression,Pattern:>_,Size->Line]
						],
						"Right Label"->Alternatives[
							Widget[Type->Enumeration,Pattern:>Alternatives[None]],
							Widget[Type->Expression,Pattern:>_,Size->Line]
						]
					},
					Widget[Type->Expression,Pattern:>_,Size->Line]
			],
			Description -> "The label to place on top of the frame.",
			ResolutionDescription -> "If Automatic, the x and y axes will be labeled with the names and units of the x and y values being plotted.",
			Category->"Plot Labeling"
		},
		{
			OptionName->RotateLabel,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Description->"Whether to rotate the vertical label on the frame of the plot.",
			Category->"Plot Labeling"
		},
		{
			OptionName->LabelingFunction,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[(Callout[#1, Automatic] &),(Placed[Panel[#1, FrameMargins -> 0], Automatic] &),Center,Top,Bottom,Left,Right,Automatic]],
				Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"LabelingFunction can be any pure function that returns a Labeling directive. For more information, evaluate ?LabelingFunction in the notebook."]
			],
			Description->"Specifies how points on this plot should be labeled.",
			Category->"Plot Labeling"
		},
		{
			OptionName -> LabelStyle,
			Default -> {14,Bold,FontFamily->"Arial"},
			Description -> "The styling which should be used for the plot title.",
			AllowNull -> False,
			Category -> "Plot Labeling",
			Widget ->Alternatives[
				"Color"->Widget[Type->Enumeration,Pattern:>Alternatives[Red,Green,Blue,Black,White,Gray,Cyan,Magenta,Yellow,Brown,Orange,Pink,Purple]],
				"Font Styling"->{
					"Font Size"->Widget[Type->Number,Pattern:>GreaterP[0]],
					"Font Type"->Alternatives[
						Widget[Type->Expression,Pattern:>_,Size->Line],
						Widget[Type->Enumeration,Pattern:>Alternatives[Bold,Italic,Underlined]],
						Widget[Type->Color,Pattern:>ColorP]
					],
					"Font Family"->Alternatives[
						Widget[Type->Expression,Pattern:>_Rule,Size->Line,PatternTooltip->"The font family of the label, in the form FontFamily->_String."]
					]
				},
				"Other"->Widget[Type -> Expression, Pattern :>_, Size -> Line, PatternTooltip->"The LabelStyle can be set to any valid graphics directive. Evaluate ?LabelStyle in the notebook for more information."]
			]
		},

		(* Data Specifications Options *)
		{
			OptionName->TargetUnits,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression,Pattern:>ListableP[(_?UnitsQ|_?KnownUnitQ|Automatic)],Size->Line],
			Category->"Data Specifications",
			Description -> "The units of the x and y axes. If these are distinct from the units currently associated with the data, unit conversions will occur before plotting.",
			ResolutionDescription -> "If Automatic, the units currently associated with the data will be used."
		},

		(* Plot Style Options *)
		{
			OptionName->Background,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				"Color"->Widget[Type->Color,Pattern:>ColorP],
				Widget[Type->Enumeration,Pattern:>Alternatives[None]],
				"Other"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"The Background can be set to any valid color directive. Evaluate ?Background in the notebook for more information."]
			],
			Description->"Specifies the background color of the plot.",
			Category->"Plot Style"
		},
		{
			OptionName->ColorFunction,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Preset"->Widget[Type->Enumeration, Pattern:>
					Alternatives[
						None,"AlpineColors", "Aquamarine", "ArmyColors", "AtlanticColors",
						"AuroraColors", "AvocadoColors", "BeachColors", "BlueGreenYellow",
						"BrassTones", "BrightBands", "BrownCyanTones", "CandyColors",
						"CherryTones", "CMYKColors", "CoffeeTones", "DarkBands",
						"DarkRainbow", "DarkTerrain", "DeepSeaColors", "FallColors",
						"FruitPunchColors", "FuchsiaTones", "GrayTones", "GrayYellowTones",
						"GreenBrownTerrain", "GreenPinkTones", "IslandColors", "LakeColors",
						"LightTemperatureMap", "LightTerrain", "MintColors", "NeonColors",
						"Pastel", "PearlColors", "PigeonTones", "PlumColors", "Rainbow",
						"RedBlueTones", "RedGreenSplit", "RoseColors", "RustTones",
						"SandyTerrain", "SiennaTones", "SolarColors", "SouthwestColors",
						"StarryNightColors", "SunsetColors", "TemperatureMap",
						"ThermometerColors", "ValentineTones", "WatermelonColors", Automatic
					]
				],
				"Pure Function"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any function that takes in the data points as input (ex. {x,y}) and returns a valid graphics directive. For more information, evaluate ?ColorFunction in the notebook."]
			],
			Description->"A function to apply to determine colors of elements in the plot.",
			Category->"Plot Style"
		},
		{
			OptionName->ColorFunctionScaling,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
			Description->"Scales the arguments to the color function between 0 and 1.",
			Category->"Plot Style"
		},
		{
			OptionName->Filling,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				"Preset"->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,None,Axis,Bottom,Top]],
				"y-Value"->Widget[Type->Number, Pattern:>RangeP[-Infinity,Infinity]],
				"Other"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Filling can also be specified for each curve in the plot. For more information, evaluate ?Filling in the notebook."]
			],
			Description->"The region of the plot that should be filled under points, curves, and surfaces.",
			Category->"Plot Style"
		},
		{
			OptionName->FillingStyle,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Opacity"->Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,Opacity[0.25],Opacity[0.5],Opacity[0.75]]],
				"Other"->Widget[Type->Expression,Pattern:>_,Size->Line]
			],
			Description->"The default style of filling to be used.",
			Category->"Plot Style"
		},
		{
			OptionName->InterpolationOrder,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[None]],
				Widget[Type->Number,Pattern:>GreaterEqualP[0]]
			],
			Description->"Specifies the order of interpolation to use when the points of the dataset are joined together.",
			Category->"Plot Style"
		},
		{
			OptionName->Joined,
			Default->True,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic,BooleanP]],
				Adder[Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic,BooleanP]]]
			],
			Description->"Specifies whether points in each dataset should be joined into a line, or should be plotted as separate points.",
			Category->"Plot Style"
		},
		{
			OptionName->PlotMarkers,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,System`\[FilledSquare],System`\[EmptySquare],System`\[FilledCircle],System`\[EmptyCircle],System`\[FilledDiamond]]],
				Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid graphics directive."]
			],
			Description->"Specifies what markers to draw at the points plotted.",
			Category->"Plot Style"
		},
		{
			OptionName->PlotStyle,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Color,Pattern:>ColorP],
				Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[Alternatives[Automatic,Thick,Dashed,Thin]]],
				Widget[Type->Expression,Pattern:>_,Size->Line]
			],
			Description->"A PlotStyle describing the general styling of the plot. Any direct specifications of plot styling will overide the default in the theme. Evaluate ?PlotStyle in the notebook for more information.",
			Category->"Plot Style"
		},

		(* Frame Options *)
		{
			OptionName -> Frame,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Alternatives[
				{
					"Horizontal Frame"->{
						"Left"->Widget[Type->Enumeration,Pattern:>BooleanP],
						"Right"->Widget[Type->Enumeration,Pattern:>BooleanP]
					},
					"Vertical Frame"->{
						"Bottom"->Widget[Type->Enumeration,Pattern:>BooleanP],
						"Top"->Widget[Type->Enumeration,Pattern:>BooleanP]
					}
				},
				Widget[Type->Enumeration,Pattern:>Alternatives[True,False]],
				Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"For more information about valid Frame specifications, evaluate ?Frame in the notebook."]
			],
			Description -> "Specifies how to construct the frame of the plot.",
			Category->"Frame"
		},
		{
			OptionName->FrameStyle,
			Default->{},
			AllowNull->False,
			Widget->Alternatives[
				"Single Color"->Widget[Type->Color,Pattern:>ColorP],
				"Multiple"->{
					"Horizontal Frame"->{
						"Left"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"For more information about valid Frame specifications, evaluate ?FrameStyle in the notebook."],
						"Right"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"For more information about valid Frame specifications, evaluate ?FrameStyle in the notebook."]
					},
					"Vertical Frame"->{
						"Bottom"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"For more information about valid Frame specifications, evaluate ?FrameStyle in the notebook."],
						"Top"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"For more information about valid Frame specifications, evaluate ?FrameStyle in the notebook."]
					}
				},
				"Other"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"For more information about valid Frame specifications, evaluate ?FrameStyle in the notebook."]
			],
			Description->"Style specifications for the frame of the plot.",
			Category->"Frame"
		},
		{
			OptionName->FrameTicks,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				{
					"Horizontal Frame"->{
						"Left Frame"->Alternatives[
							Adder[
								{
									"Position"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
									"Label"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"The label of this frame tick."],
									"Size"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"The size of this frame tick."]
								}
							],
							Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid ticks expression."]
						],
						"Right Frame"->Alternatives[
							Adder[
								{
									"Position"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
									"Label"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"The label of this frame tick."],
									"Size"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"The size of this frame tick."]
								}
							],
							Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid ticks expression."]
						]
					},
					"Vertical Frame"->{
						"Bottom Frame"->Alternatives[
							Adder[
								{
									"Position"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
									"Label"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"The label of this frame tick."],
									"Size"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"The size of this frame tick."]
								}
							],
							Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid ticks expression."]
						],
						"Top Frame"->Alternatives[
							Adder[
								{
									"Position"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
									"Label"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"The label of this frame tick."],
									"Size"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"The size of this frame tick."]
								}
							],
							Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid ticks expression."]
						]
					}
				},
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,True,None,All]],
				Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"For more information about valid Frame specifications, evaluate ?Frame in the notebook."]
			],
			Description->"Specifies the location of tick marks on the frame of the plot.",
			Category->"Frame"
		},
		{
			OptionName->FrameTicksStyle,
			Default->{},
			AllowNull->False,
			Widget->Alternatives[
				{
					"Horizontal Frame"->{
						"Left Frame"->Alternatives[
							Widget[Type->Color,Pattern:>ColorP],
							Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid style directive. For more information, evaluate ?FrameTicksStyle in the notebook."]
						],
						"Right Frame"->Alternatives[
							Widget[Type->Color,Pattern:>ColorP],
							Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid style directive. For more information, evaluate ?FrameTicksStyle in the notebook."]
						]
					},
					"Vertical Frame"->{
						"Bottom Frame"->Alternatives[
							Widget[Type->Color,Pattern:>ColorP],
							Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid style directive. For more information, evaluate ?FrameTicksStyle in the notebook."]
						],
						"Top Frame"->Alternatives[
							Widget[Type->Color,Pattern:>ColorP],
							Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid style directive. For more information, evaluate ?FrameTicksStyle in the notebook."]
						]
					}
				},
				Widget[Type->Color,Pattern:>ColorP],
				Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid style directive. For more information, evaluate ?FrameTicksStyle in the notebook."]
			],
			Description->"Style specifications for frame ticks.",
			Category->"Frame"
		},

		(* Grid Options *)
		{
			OptionName->GridLines,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				"Automatic Grid"->Widget[Type->Enumeration,Pattern:>Alternatives[None,Automatic]],
				"Explicit Grid"->{
					"X Grid Lines"->Adder[
						Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
					],
					"Y Grid Lines"->Adder[
						Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
					]
				},
				"Explicit Styled Grid"->{
					"X Grid Lines"->Adder[
						{
							"Position"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							"Style"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid style specification."]
						}
					],
					"Y Grid Lines"->Adder[
						{
							"Position"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							"Style"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid style specification."]
						}
					]
				},
				"Other"->Widget[Type->Expression, Pattern:>_, Size->Line, PatternTooltip->"For more information about valid grid line values, evaluate ?GridLines in the notebook."]
			],
			Description->"Grid lines that should be drawn on the plot. When set to Automatic, the grid lines resolve to reasonably spaced grid lines, depending on the range of the plot.",
			Category->"Grid"
		},
		{
			OptionName->GridLinesStyle,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				"Presets"->Widget[Type->Enumeration,Pattern:>Alternatives[None,Thick,Dashed,DotDashed,Dotted]],
				"Color"->Widget[Type->Color,Pattern:>ColorP],
				"Other"->Widget[Type->Expression, Pattern:>_, Size->Line,PatternTooltip->"For more information about valid grid line styles, evaluate ?GridLinesStyle in the notebook."]
			],
			Description->"Style specifications for grid lines of the plot.",
			Category->"Grid"
		},

		(* General Options *)
		{
			OptionName->Prolog,
			Default->{},
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Paragraph, PatternTooltip->"Prolog is a list of graphics primitives or graphics-like objects to render before the main plot."],
			Description->"Primitives rendered before the main plot.",
			Category->"General"
		},
		{
			OptionName->Epilog,
			Default->{},
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Paragraph, PatternTooltip->"Epilog is a list of graphics primitives or graphics-like objects to render after the main plot."],
			Description->"Primitives rendered after the main plot .",
			Category->"General"
		},

		(* HIDDEN OPTIONS - NOT SHOWN TO USER *)
		{
			OptionName->DataRange,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression,Pattern:>_,Size->Line],
			Description->"The range of values to plot for the given data.",
			Category->"Hidden"
		},
		{
			OptionName->AxesStyle,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[{},Thick,Thin,Dashed,Dotted]],
				Widget[Type->Color,Pattern:>ColorP],
				Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"The axes style can be set to any valid graphics directive. For more information, evaluate ?AxesStyle in the notebook."]
			],
			Description->"Style specifications for the axes of this plot.",
			Category->"Hidden"
		},
		{
			OptionName->AxesLabel,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[None]],
				"Single Label"->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[None]],
					Widget[Type->Expression, Pattern:>_,Size->Line]
				],
				{
					"X Label"->Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[None]],
						Widget[Type->Expression, Pattern:>_,Size->Line]
					],
					"Y Label"->Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[None]],
						Widget[Type->Expression, Pattern:>_,Size->Line]
					]
				}
			],
			Description->"The labels of the X and Y and Z axes.",
			Category->"Hidden"
		},
		{
			OptionName->Axes,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Expression,Pattern:>True | False | Automatic | {Repeated[(True | False | Automatic),{1,4}]} |  { (True | False | Automatic) | {True | False | Automatic}, True | False | Automatic | {True | False | Automatic}},Size->Line],
			Description->"Specifies whether axes should be drawn for this plot.",
			Category->"Hidden"
		},
		{
			OptionName->AxesUnits,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
				Widget[Type->Enumeration, Pattern:>Alternatives[None]],
				{
					"X Unit"->Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
						Widget[Type->Enumeration, Pattern:>Alternatives[None]],
						Widget[Type->Expression, Pattern:>_?UnitsQ,Size->Line]
					],
					"Y Unit"->Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
						Widget[Type->Enumeration, Pattern:>Alternatives[None]],
						Widget[Type->Expression, Pattern:>_?UnitsQ,Size->Line]
					]
				}
			],
			Description->"The units of the X and Y and Z axes.",
			Category->"Hidden"
		},
		{
			OptionName->PlotTheme,
			Default->$PlotTheme,
			AllowNull->False,
			Widget->Alternatives[
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[
						Automatic,
						"Business",
						"Detailed",
						"Marketing",
						"Minimal",
						"Monochrome",
						"Scientific",
						"Web",
						"Classic"
					]
				],
				Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"The plot theme can be set to any valid graphics directive. For more information, evaluate ?PlotTheme in the notebook."]
			],
			Description->"A PlotTheme describing the general styling of the plot. Any direct specifications of plot styling will overide the default in the theme.",
			Category->"Hidden"
		},
		{
			OptionName->ScalingFunctions,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[None,"Log","Reverse","Reciprocal","Log10","Log2"]],
				Widget[Type->Expression, Pattern:>_, Size->Paragraph, PatternTooltip->"The scaling function can also be specified for each data dimension {f1, f2, f3...}. For more information, evaluate ?ScalingFunctions in the notebook."]
			],
			Description->"Specifies what scaling functions should be used on the given data.",
			Category->"Hidden"
		},
		{
			OptionName->Mesh,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				"Single"->Alternatives[
					"Presets"->Widget[Type->Enumeration,Pattern:>Alternatives[None,All,Full]],
					"Number"->Widget[Type->Number,Pattern:>GreaterEqualP[0]]
				],
				"Multiple"->Adder[
					Alternatives[
						"Presets"->Widget[Type->Enumeration,Pattern:>Alternatives[None,All,Full]],
						"Number"->Widget[Type->Number,Pattern:>GreaterEqualP[0]]
					]
				],
				"Other"->Widget[Type->Expression, Pattern:>_, Size->Paragraph, PatternTooltip->"Any other valid mesh input."]
			],
			Description->"The type of mesh that should be drawn. Can be specified for all meshes in the plot, or can be index matched to each mesh in the plot.",
			Category->"Hidden"
		},
		{
			OptionName->MeshFunctions,
			Default->{#1&,#2&},
			AllowNull->False,
			Widget->Alternatives[
				"3D Data"->{
					"X"->Widget[Type->Expression, Pattern:>_Function, Size->Line],
					"Y"->Widget[Type->Expression, Pattern:>_Function, Size->Line]
				},
				"Other"->Widget[Type->Expression, Pattern:>{_Function..}, Size->Line]
			],
			Description->"Specify what functions to use to determine Mesh divisions.",
			Category->"Hidden"
		},
		{
			OptionName->MeshShading,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				"Colors"->{
					"X"->{
						"1"->Widget[Type->Color,Pattern:>ColorP],
						"2"->Widget[Type->Color,Pattern:>ColorP]
					},
					"Y"->{
						"1"->Widget[Type->Color,Pattern:>ColorP],
						"2"->Widget[Type->Color,Pattern:>ColorP]
					}
				},
				"Other"->Widget[Type->Expression,Pattern:>_,Size->Line]
			],
			Description->"Specify the colors used to render the areas between mesh lines.",
			Category->"Hidden"
		},
		{
			OptionName->MeshStyle,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Opacity"->Widget[Type->Enumeration, Pattern:>Alternatives[None,Automatic,Opacity[0.25],Opacity[0.5],Opacity[0.75]]],
				"Single Color"->Widget[Type->Color,Pattern:>ColorP],
				"Two Colors"->{
					"X-mesh"->Widget[Type->Color,Pattern:>ColorP],
					"Y-mesh"->Widget[Type->Color,Pattern:>ColorP]
				},
				"Other"->Widget[Type->Expression, Pattern:>_, Size->Line, PatternTooltip->"The mesh style can be set to any valid graphics directive. For more information, evaluate ?MeshStyle in the notebook."]
			],
			Description->"Specify the style in which the mesh should be drawn.",
			Category->"Hidden"
		},
		{
			OptionName->AxesOrigin,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				"{x,y,z}"->{
					"x"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
					"y"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
					"z"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word]
				},
				"Other"->Widget[Type->Expression, Pattern:>_, Size->Line]
			],
			Description->"The location at which the axes should cross on this plot.",
			Category->"Hidden"
		},
		{
			OptionName->BaselinePosition,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"What to align with a surrounding text baseline.",
			Category->"Hidden"
		},
		{
			OptionName->BaseStyle,
			Default->{},
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"Base style specifications for the grid.",
			Category->"Hidden"
		},
		{
			OptionName->AlignmentPoint,
			Default->Center,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"The default point in the graphic to align with .",
			Category->"Hidden"
		},
		{
			OptionName->ColorOutput,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"Deprecated option that sometimes shows up, hidden from the user.",
			Category->"Hidden"
		},
		{
			OptionName->ContentSelectable,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"Whether to allow contents to be selected.",
			Category->"Hidden"
		},
		{
			OptionName->CoordinatesToolOptions,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"Detailed behavior of the coordinates tool.",
			Category->"Hidden"
		},
		{
			OptionName->DisplayFunction,
			Default->$DisplayFunction,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"DisplayFunction.",
			Category->"Hidden"
		},
		{
			OptionName->FormatType,
			Default->TraditionalForm,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"The default format type for text .",
			Category->"Hidden"
		},
		{
			OptionName->ImageMargins,
			Default->0.,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"The margins to leave around the graphic .",
			Category->"Hidden"
		},
		{
			OptionName->ImagePadding,
			Default->All,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"What extra padding to allow for labels etc.",
			Category->"Hidden"
		},
		{
			OptionName->ImageSizeRaw,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"ImageSizeRaw.",
			Category->"Hidden"
		},
		{
			OptionName->MaxPlotPoints,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[2]],
			Description->"The maximum number of plot points which will explicitly be included in the output.",
			Category->"Hidden"
		},
		{
			OptionName->Method,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"Details of graphics methods to use.",
			Category->"Hidden"
		},
		{
			OptionName->PlotRangePadding,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"How much to pad the range of values .",
			Category->"Hidden"
		},
		{
			OptionName->PlotRegion,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"The final display region to be filled .",
			Category->"Hidden"
		},
		{
			OptionName->PreserveImageOptions,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression,Pattern:>_,Size->Line],
			Description->"Whether to preserve image options when displaying new versions of the same graphic.",
			Category->"Hidden"
		},
		{
			OptionName->Ticks,
			Default->True,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[True]],
				Widget[Type->Enumeration,Pattern:>Alternatives[False]],
				"Individual Axes"->{
					"X axis"->Widget[Type->Enumeration,Pattern:>Alternatives[True,False]],
					"Y axis"->Widget[Type->Enumeration,Pattern:>Alternatives[True,False]],
					"Z axis"->Widget[Type->Enumeration,Pattern:>Alternatives[True,False]]
				},
				"Other"->Widget[Type->Expression,Pattern:>_,Size->Line]
			],
			Description->"Specify the location of Tick marks on the Axes of the Plot.",
			Category->"Hidden"
		},
		{
			OptionName->TicksStyle,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				"Single Color"->Widget[Type->Color,Pattern:>ColorP],
				"Single Style Directive"->Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid style directive. For more information, evaluate ?FrameTicksStyle in the notebook."],
				"Individual Axes"->{
					"X axis"->Alternatives[
						Widget[Type->Color,Pattern:>ColorP],
						Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid style directive. For more information, evaluate ?FrameTicksStyle in the notebook."]
					],
					"Y axis"->Alternatives[
						Widget[Type->Color,Pattern:>ColorP],
						Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid style directive. For more information, evaluate ?FrameTicksStyle in the notebook."]
					],
					"Z axis"->Alternatives[
						Widget[Type->Color,Pattern:>ColorP],
						Widget[Type->Expression,Pattern:>_,Size->Line,PatternTooltip->"Any valid style directive. For more information, evaluate ?FrameTicksStyle in the notebook."]
					]
				},
				"Other"->Widget[Type->Expression,Pattern:>_,Size->Line]
			],
			Description->"Style specifications for axes ticks.",
			Category->"Hidden"
		},
		{
			OptionName->PlotLabels,
			Default->None,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"Labels for data.",
			Category->"Hidden"
		},
		{
			OptionName->PlotLayout,
			Default->"Overlaid",
			AllowNull->False,
			Widget->Widget[Type->Expression,Pattern:>_,Size->Line],
			Description->"How to position data.",
			Category->"Hidden"
		},
		{
			OptionName->PlotLegends,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				"Entries"->Adder[Alternatives[
					"String"->Widget[Type->String,Pattern:>_String,Size->Word],
					"Styled String"->Widget[Type->Expression,Pattern:>_Style,Size->Line,BoxText->"Style[\"label\",<directives>]"],
					Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
				]],
				"Other"->Widget[Type->Expression,Pattern:>_,Size->Line]
			],
			Description->"A list of text descriptions of each data set in the plot.",
			Category->"Hidden"
		},
		{
			OptionName->LabelingSize,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression,Pattern:>_,Size->Line],
			Description->"Maximum size of callouts and labels.",
			Category->"Hidden"
		},
		{
			OptionName->PerformanceGoal,
			Default->$PerformanceGoal,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives["Quality"]],
				Widget[Type->Enumeration,Pattern:>Alternatives["Speed"]],
				"Other"->Widget[Type->Expression,Pattern:>_,Size->Line]
			],
			Description->"Use \"Quality\" to prioritize plot quality, and \"Speed\" to prioritize performance.",
			Category->"Hidden"
		},
		{
			OptionName->IntervalMarkers,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,None,"Bars","Fences","Bands","Ellipses","Points"]],
			Description->"Specifies how to represent uncertainty intervals.",
			Category->"Hidden"
		},
		{
			OptionName->IntervalMarkersStyle,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression,Pattern:>_,Size->Line],
			Description->"Specifies styles in which uncertainty intervals are drawn.",
			Category->"Hidden"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ChartOptions*)


DefineOptionSet[
	ChartOptions :> {
		{
			OptionName->DistributionFunction,
			Default->"Intensity",
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives["PDF","Intensity","CDF","SF","HF","CHF"]],
			Description->"Different distribution functions that can be used for smooth histogram presentation.",
			Category->"Data Specifications"
		},
		{
			OptionName->ChartBaseStyle,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Opacity"->Widget[Type->Enumeration, Pattern:>Alternatives[None,Automatic,"Pastel",Opacity[0.25],Opacity[0.5],Opacity[0.75]]],
				"Color"->Alternatives[
					"Single Color"->Widget[Type->Color,Pattern:>ColorP],
					"Color List"->Adder[Widget[Type->Color,Pattern:>ColorP]],
					"Color Data"->Widget[Type->Enumeration,Pattern:>Alternatives[Sequence@@ColorData["Charting"]]]
				],
				"EdgeForm"->Widget[Type->Enumeration,Pattern:>Alternatives[Sequence@@(EdgeForm/@{Dashed,Dotted,DotDashed})]],
				"Others"->Widget[Type->Expression, Pattern:>_, Size->Line, PatternTooltip->"The chart base style can be set to any valid graphics directive. For more information, evaluate ?ChartBaseStyle in the notebook."]
			],
			Description->"Specifies the base style for all chart elements.",
			Category->"Plot Style"
		},
		{
			OptionName->ChartElements,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Graphics Head"->Widget[Type->Expression,Pattern:>Alternatives[Graphics,Graphics3D],Size->Line,PatternTooltip->"Any valid input with Graphic or Graphic3D header."],
				"Others"->Widget[Type->Expression, Pattern:>_, Size->Line, PatternTooltip->"The chart element can be any valid graphics input."]
			],
			Description->"Specifies the graphics to use as the basis for bars or other chart elements.",
			Category->"Plot Style"
		},
		{
			OptionName->ChartElementFunction,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"BarChart"->Widget[Type->Enumeration,Pattern:>Alternatives[(Sequence@@ChartElementData["BarChart"])]],
				"BarChart3D"->Widget[Type->Enumeration,Pattern:>Alternatives[(Sequence@@ChartElementData["BarChart3D"])]],
				"PieChart"->Widget[Type->Enumeration,Pattern:>Alternatives[(Sequence@@ChartElementData["PieChart"])]],
				"PieChart3D"->Widget[Type->Enumeration,Pattern:>Alternatives[(Sequence@@ChartElementData["PieChart3D"])]],
				"Others"->Widget[Type->Expression, Pattern:>_, Size->Line, PatternTooltip->"The chart element function can be any valid pure or delayed function. For more information, evaluate ?ChartElementFunction in the notebook."]
			],
			Description->"Specifies a function to use to generate the primitives for rendering each chart element.",
			Category->"Plot Style"
		},
		{
			OptionName->ChartLabels,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				"String"->Alternatives[
					"Single Level"->Widget[Type->Expression, Pattern:>{_String..}, Size->Line, BoxText->"{\"A\",\"B\",...}", PatternTooltip->"A list of strings."],
					"Multi Levels"->Adder[
						Alternatives[
							Widget[Type->Expression, Pattern:>{_String..}, Size->Line, BoxText->"{\"A\",\"B\",...}", PatternTooltip->"A list of strings."],
							Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,None]]
						]
					]
				],
				"Placed Head"->Alternatives[
					"Single Level"->Widget[Type->Expression, Pattern:>Placed[_], Size->Line, BoxText->"Placed[{\"A\",\"B\",...},\"RadialCallout\"|\"RadialCenter\"...]", PatternTooltip->"A valid set of strings with Placed head, Placed[]."],
					"Multi Levels"->Adder[
						Widget[Type->Expression, Pattern:>Placed[_], Size->Line, BoxText->"Placed[{\"A\",\"B\",...},\"RadialCallout\"|\"RadialCenter\"...]", PatternTooltip->"A valid set of strings with Placed head, Placed[]."]
					]
				],
				"Other"->Widget[Type->Expression, Pattern:>_, Size->Line]
			],
			Description->"Labels for the chart.",
			Category->"Plot Labeling"
		},
		{
			OptionName->ChartLayout,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,"Grouped","Stepped","Stacked","Overlapped","Percentile"]],
			Description->"Specifies the overall layout to use.",
			Category->"Plot Style"
		},
		{
			OptionName->ChartLegends,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				"Default"->Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,None]],
				"String"->Alternatives[
					"Single Level"->Widget[Type->Expression, Pattern:>{_String..}, Size->Line, PatternTooltip->"A list of strings."],
					"Multi Levels"->Adder[
						Alternatives[
							Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,None]],
							Widget[Type->Expression, Pattern:>{_String..}, Size->Line, PatternTooltip->"A list of strings."]
						]
					]
				],
				"Placed Head"->Alternatives[
					"Single Level"->Widget[Type->Expression, Pattern:>Placed[_], Size->Line, PatternTooltip->"A valid set of strings with Placed head, Placed[]."],
					"Multi Levels"->Adder[
						Alternatives[
							Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,None]],
							Widget[Type->Expression, Pattern:>Placed[_], Size->Line, PatternTooltip->"A valid set of strings with Placed head, Placed[]."]
						]
					]
				],
				"Others"->Widget[Type->Expression, Pattern:>_, Size->Line]
			],
			Description->"Legends for the chart.",
			Category->"Legend"
		},
		{
			OptionName->ChartStyle,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Opacity"->Widget[Type->Enumeration, Pattern:>Alternatives[None,Automatic,"Pastel",Opacity[0.25],Opacity[0.5],Opacity[0.75]]],
				"Color"->Alternatives[
					"Single Color"->Widget[Type->Color,Pattern:>ColorP],
					"Color List"->Adder[Widget[Type->Color,Pattern:>ColorP]],
					"Color Data"->Widget[Type->Enumeration,Pattern:>Alternatives[Sequence@@ColorData["Charting"]]]
				],
				"EdgeForm"->Widget[Type->Enumeration,Pattern:>Alternatives[Sequence@@(EdgeForm/@{Dashed,Dotted,DotDashed})]],
				"Others"->Widget[Type->Expression, Pattern:>_, Size->Line, PatternTooltip->"The chart style can be set to any valid graphics directive. For more information, evaluate ?ChartBaseStyle in the notebook."]
			],
			Description->"Specifies the style for individual chart elements.",
			Category->"Plot Style"
		},
		{
			OptionName->LegendAppearance,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,"Row","Column"]],
			Description->"Specifies the appearance of the legend.",
			Category->"Legend"
		}
	}
];



(* ::Subsubsection::Closed:: *)
(*BarChartOptions*)


DefineOptionSet[
	BarChartOptions :> {
		{
			OptionName->BarOrigin,
			Default->Bottom,
			AllowNull->False,
			Widget->Alternatives[
				"2D"->Widget[Type->Enumeration,Pattern:>Alternatives[Left,Right,Bottom,Top]],
				"3D"->Widget[Type->Enumeration,Pattern:>Alternatives[Left,Right,Bottom,Top,Front,Back]]
			],
			Description->"Specifies the origin placement for bars.",
			Category->"Plot Style"
		},
		{
			OptionName->BarSpacing,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				"Spacings"->Adder[Alternatives[
					"Keyword"->Widget[Type->Enumeration,Pattern:>None|Tiny|Small|Medium|Large],
					"Numeric"->Widget[Type->Number,Pattern:>GreaterEqualP[-1.0]]
				]],
				"Default"->Widget[Type->Expression,Pattern:>Automatic|None|Tiny|Small|Medium|Large|_?NumericQ,Size->Word]
			],
			Description->"Specifies the spacing between bars.",
			Category->"Plot Style"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*PieChartOptions*)


DefineOptionSet[
	PieChartOptions :> {
		{
			OptionName->PolarAxes,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,BooleanP]],
			Description->"Specifies whether polar axes should be drawn.",
			Category->"Hidden"
		},
		{
			OptionName->PolarAxesOrigin,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Expression,Pattern:>{{Alternatives[Left,Right,Bottom,Top,Automatic],Alternatives[Left,Right,Bottom,Top,Automatic]},GreaterEqualP[0.]},Size->Line,PatternTooltip->"Should be specified as {{Left or Right or Bottom or Top,Left or Right or Bottom or Top},number}."]
			],
			Description->"Specifies where polar axes should be drawn.",
			Category->"Hidden"
		},
		{
			OptionName->PolarGridLines,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,None]],
				Widget[Type->Expression,Pattern:>{{RangeP[0,2*N@Pi]..},{GreaterP[0.]}},Size->Line,PatternTooltip->"Two joined lists {{p1,p2,..},{r1,r2,..}} where p is 0-2pi and r>0."]
			],
			Description->"Specifies the grid lines for polar axes.",
			Category->"Hidden"
		},
		{
			OptionName->PolarTicks,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				"Drop Head"->Widget[Type->Expression,Pattern:>{Drop[_],Automatic},Size->Line,PatternTooltip->"With Drop head, {Drop[..],Automatic}."],
				"Others"->Widget[Type->Expression,Pattern:>_,Size->Line]
			],
			Description->"Specifies where polar axes ticks should be drawn.",
			Category->"Hidden"
		},
		{
			OptionName->SectorOrigin,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Angle"->Widget[Type->Expression,Pattern:>_?NumericQ,Size->Word],
				"Angle and Direction"->{
					"Angle"->Widget[Type->Expression,Pattern:>_?NumericQ,Size->Word],
					"Direction"->Widget[Type->Enumeration,Pattern:>("Clockwise"|"Counterclockwise")]
				}
			],
			Description->"Specifies the origin of the sectors given a starting angle in radians, and a direction to draw new sectors.",
			Category->"Plot Style"
		},
		{
			OptionName->SectorSpacing,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				"Single Spacing"->Widget[Type->Enumeration,Pattern:>Alternatives[None|Automatic|Tiny|Small|Medium|Large]],
				"Numerical Spacing"->Widget[Type->Number,Pattern:>GreaterEqualP[0.]],
				"Multiple Spacings"->Adder[Alternatives[
					"Preset"->Widget[Type->Enumeration,Pattern:>Alternatives[None|Automatic|Tiny|Small|Medium|Large]],
					"Explicit"->Widget[Type->Number,Pattern:>GreaterEqualP[0.]]
				]]
			],
			Description->"Specifies the spacing between sectors.",
			Category->"Plot Style"
		}

	}
];


(* ::Subsubsection::Closed:: *)
(*SmoothHistogramOptions*)


DefineOptionSet[
	SmoothHistogramOptions :> {
		{
			OptionName->MaxRecursion,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Number, Pattern:>GreaterEqualP[0,1]]
			],
			Description->"Specifies how many recursive subdivisions can be made.",
			Category->"General"
		},
		{
			OptionName->RegionFunction,
			Default->(True&),
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				"Pure Function"->Widget[Type->Expression,Pattern:>_Function,Size->Line],
				"Others"->Widget[Type->Expression, Pattern:>_,Size->Line,PatternTooltip->"Any valid pure or delayed function."]
			],
			Description->"Specifies the region to include in the plot drawn. Function should take an {x,y,z} data point as input and return a boolean.",
			Category->"Data Specifications"
		},
		{
			OptionName->PlotPoints,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Number, Pattern:>GreaterEqualP[2,1]]
			],
			Description->"The initial number of sample points.",
			Category->"General"
		},
		{
			OptionName->WorkingPrecision,
			Default->MachinePrecision,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[MachinePrecision]],
				Widget[Type->Number, Pattern:>GreaterP[0,1]]
			],
			Description->"Specifies how many digits of precision should be maintained in internal computations.",
			Category->"General"
		}

	}
];


(* ::Subsubsection::Closed:: *)
(*ListPlot3DOptions*)


DefineOptionSet[
	ListPlot3DOptions :> {

		{
			OptionName->AutomaticImageSize,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
			Description->"If True, enables automatic imagesize.",
			Category->"Hidden"
		},
		{
			OptionName->AxesLabel,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"xyz"->{
					"X Label"->Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
						Widget[Type->Enumeration, Pattern:>Alternatives[None]],
						Widget[Type->Expression, Pattern:>_,Size->Line]
					],
					"Y Label"->Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
						Widget[Type->Enumeration, Pattern:>Alternatives[None]],
						Widget[Type->Expression, Pattern:>_,Size->Line]
					],
					"Z Label"->Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
						Widget[Type->Enumeration, Pattern:>Alternatives[None]],
						Widget[Type->Expression, Pattern:>_,Size->Line]
					]
				},
				"xy only"->{
					"X Label"->Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
						Widget[Type->Enumeration, Pattern:>Alternatives[None]],
						Widget[Type->Expression, Pattern:>_,Size->Line]
					],
					"Y Label"->Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
						Widget[Type->Enumeration, Pattern:>Alternatives[None]],
						Widget[Type->Expression, Pattern:>_,Size->Line]
					]
				},
				Widget[Type->Enumeration, Pattern:>Alternatives[None]],
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]]
			],
			Description->"The labels of the X and Y and Z axes.",
			Category->"Plot Labeling"
		},
		{
			OptionName->Axes,
			Default->True,
			AllowNull->False,
			Widget->Alternatives[
				"All"->Widget[Type->Enumeration,Pattern:>Automatic|True|False],
				"xyz"->{
					"x"->Widget[Type->Enumeration,Pattern:>True|False],
					"y"->Widget[Type->Enumeration,Pattern:>True|False],
					"z"->Widget[Type->Enumeration,Pattern:>True|False]
				},
				"Other"->Widget[Type->Expression,Pattern:>{Repeated[(True|False|Automatic),{1,4}]}|{(True|False|Automatic)|{True|False|Automatic},True|False|Automatic|{True|False|Automatic}},Size->Line]
			],
			Description->"Specifies whether and which axes should be drawn for this plot.",
			Category->"Axes"
		},
		{
			OptionName->AxesUnits,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				{
					"X Unit"->Alternatives[
						Widget[Type->Expression, Pattern:>_?UnitsQ,Size->Line],
						Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
						Widget[Type->Enumeration, Pattern:>Alternatives[None]]
					],
					"Y Unit"->Alternatives[
						Widget[Type->Expression, Pattern:>_?UnitsQ,Size->Line],
						Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
						Widget[Type->Enumeration, Pattern:>Alternatives[None]]
					],
					"Z Unit"->Alternatives[
						Widget[Type->Expression, Pattern:>_?UnitsQ,Size->Line],
						Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
						Widget[Type->Enumeration, Pattern:>Alternatives[None]]
					]
				},
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
				Widget[Type->Enumeration, Pattern:>Alternatives[None]]
			],
			Description->"The units of the X and Y and Z axes.",
			Category->"Plot Labeling"
		},
		{
			OptionName->AxesEdge,
			Default->{{-1, -1}, {-1, -1}, {-1, -1}},
			AllowNull->False,
			Widget->Alternatives[
				{
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
						],
					"Z Edge"->
						Alternatives[
							Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
							{
								"Z First Edge"->Widget[Type->Enumeration, Pattern:>Alternatives[-1|-1.|1.|1|Automatic]],
								"Z Last Edge"->Widget[Type->Enumeration, Pattern:>Alternatives[-1|-1.|1.|1|Automatic]]
							}
						]
				},
				Widget[Type->Enumeration,Pattern:>Alternatives[None]],
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
			],
			Description->"The axis' edge of the X and Y and Z axes.",
			Category->"Axes"
		},
		{
			OptionName->BoundaryStyle,
			Default->Black,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Enumeration,Pattern:>Alternatives[None]],
				"Color"->Widget[Type->Color,Pattern:>ColorP],
				"Lines"->Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[Alternatives[Automatic,Thick,Dashed,Thin]]],
				"Others"->Widget[Type->Expression,Pattern:>_,Size->Line]
			],
			Description->"Specifies the style in which boundaries of regions should be drawn.",
			Category->"Plot Style"
		},
		{
			OptionName->Boxed,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
			Description->"Specifies whether to draw the edges of the bounding box in a three-dimensional picture.",
			Category->"Box"
		},
		{
			OptionName->BoxRatios,
			Default->{1.,1.,0.4},
			AllowNull->False,
			Widget->Alternatives[
				"XYZ"->{
					"X"->Widget[Type->Number,Pattern:>GreaterP[0.]],
					"Y"->Widget[Type->Number,Pattern:>GreaterP[0.]],
					"Z"->Widget[Type->Number,Pattern:>GreaterP[0.]]
				},
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]]
			],
			Description->"Specifies the ratios of side lengths for the bounding box of the three-dimensional picture.",
			Category->"Box"
		},
		{
			OptionName->BoxStyle,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Color"->Widget[Type->Color,Pattern:>ColorP],
				"Lines"->Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[Alternatives[Automatic,Thick,Dashed,Thin]]],
				"Others"->Widget[Type->Expression,Pattern:>_,Size->Line]
			],
			Description->"Specifies how the bounding box should be rendered.",
			Category->"Box"
		},
		{
			OptionName->ClipPlanes,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				"Infinite Planes"->Adder[Widget[Type->Expression, Pattern:>InfinitePlane[ConstantArray[ConstantArray[_?NumericQ, 3], 3]],PatternTooltip->"InfinitePlane[{p1,p2,p3}], where pts are {x,y,z} points.",Size->Line]],
				"Others"->Widget[Type->Expression, Pattern:>_,PatternTooltip->"Any valid clip plane specification. Run ?ClipPlanes in the notebook for more info.",Size->Line]
			],
			Description->"Specifies a list of clipping planes that can cut away portions of a 3D scene from the resulting view.",
			Category->"Data Specifications"
		},
		{
			OptionName->ClipPlanesStyle,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Opacity"->Widget[Type->Enumeration, Pattern:>Alternatives[None,Automatic,Opacity[0.25],Opacity[0.5],Opacity[0.75]]],
				"Color"->Widget[Type->Color,Pattern:>ColorP],
				"Others"->Widget[Type->Expression, Pattern:>_, Size->Line, PatternTooltip->"The clipping style can be set to any valid graphics directive. For more information, evaluate ?ClipPlanesStyle in the notebook."]
			],
			Description->"Specifies how clipping planes defined with the ClipPlanes option should be rendered.",
			Category->"Data Specifications"
		},
		{
			OptionName->ControllerLinking,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,All,Full,True,False]],
			Description->"For Manipulate 3D functions, specifies whether to allow interactive control by external controllers.",
			Category->"Hidden"
		},
		{
			OptionName->ControllerMethod,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,None,"Absolute"]],
			Description->"For Manipulate 3D functions, specifies the default way that controls on an external controller device should apply.",
			Category->"Hidden"
		},
		{
			OptionName->ControllerPath,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,All,"Gamepad","Joystick","Detachable","BuiltIn"]],
			Description->"Specifies a list of external controllers or classes of controllers to try for functions such as ControllerState, Manipulate, and Graphics3D.",
			Category->"Hidden"
		},
		{
			OptionName->FaceGrids,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[All,None]],
				"Faces"->Adder[
					{
						"X-Direction"->Widget[Type->Enumeration, Pattern:>Alternatives[0,1,-1]],
						"Y-Direction"->Widget[Type->Enumeration, Pattern:>Alternatives[0,1,-1]],
						"Z-Direction"->Widget[Type->Enumeration, Pattern:>Alternatives[0,1,-1]]
					}
				],
				"Faces with GridLines" ->Adder[
					{
						"Face"->
							{
								"X-Direction"->Widget[Type->Enumeration, Pattern:>Alternatives[0,1,-1]],
								"Y-Direction"->Widget[Type->Enumeration, Pattern:>Alternatives[0,1,-1]],
								"Z-Direction"->Widget[Type->Enumeration, Pattern:>Alternatives[0,1,-1]]
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
			Description->"Specifies grid lines to draw on the faces of the bounding box.",
			Category->"Box"
		},
		{
			OptionName->FaceGridsStyle,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Presets"->Widget[Type->Enumeration,Pattern:>Alternatives[None,Thick,Dashed,DotDashed,Dotted]],
				"Color"->Widget[Type->Color,Pattern:>ColorP],
				"Other"->Widget[Type->Expression, Pattern:>_, Size->Line,PatternTooltip->"For more information about valid grid line styles, evaluate ?GridLinesStyle in the notebook."]
			],
			Description->"Specifies how face grids should be rendered.",
			Category->"Box"
		},
		{
			OptionName->Lighting,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,"Standard","Neutral"]],
				"Multiple Sources"->Adder[
					Alternatives[
						"Ambient"->Widget[Type->Expression, Pattern:>{"Ambient",ColorP},PatternTooltip->"Ambient with a color, {''Ambient'',col}.",Size->Line],
						"Directional Point to Center"->Widget[Type->Expression, Pattern:>{"Directional",ColorP,ConstantArray[_?NumericQ,3]|Scaled[ConstantArray[_?NumericQ,3]]|ImageScaled[ConstantArray[_?NumericQ,3]]},PatternTooltip->"Directional with color from point to center, {''Directional'',col,pt}.",Size->Line],
						"Directional Point1 to Point2"->Widget[Type->Expression, Pattern:>{"Directional",ColorP,ConstantArray[ConstantArray[_?NumericQ,3]|Scaled[ConstantArray[_?NumericQ,3]]|ImageScaled[ConstantArray[_?NumericQ,3]],2]},PatternTooltip->"Directional with color from point1 to point2, {''Directional'',col,pt1,pt2}.",Size->Line],
						"Spherical Point"->Widget[Type->Expression, Pattern:>{"Point",ColorP,ConstantArray[_?NumericQ,3]|Scaled[ConstantArray[_?NumericQ,3]]|ImageScaled[ConstantArray[_?NumericQ,3]]},PatternTooltip->"Spherical point with color at point, {''Point'',col,pt}.",Size->Line],
						"Spherical Point with Attenuation"->Widget[Type->Expression, Pattern:>{"Point",ColorP,ConstantArray[_?NumericQ,3]|Scaled[ConstantArray[_?NumericQ,3]]|ImageScaled[ConstantArray[_?NumericQ,3]],_},PatternTooltip->"Spherical point with color at point with attenuation, {''Point'',col,pt,att}.",Size->Line],
						"Spotlight at Point"->Widget[Type->Expression, Pattern:>{"Spot",ColorP,ConstantArray[_?NumericQ,3]|Scaled[ConstantArray[_?NumericQ,3]]|ImageScaled[ConstantArray[_?NumericQ,3]],_},PatternTooltip->"Spotlight point with color at point with half angle, {''Spot'',col,pt,alpha}.",Size->Line],
						"Spotlight at Point aimed at Target"->Widget[Type->Expression, Pattern:>{"Spot",ColorP,ConstantArray[ConstantArray[_?NumericQ,3]|Scaled[ConstantArray[_?NumericQ,3]]|ImageScaled[ConstantArray[_?NumericQ,3]],2],_},PatternTooltip->"Spotlight point with color at point aimed at target with half angle, {''Spot'',col,{pt,tr},alpha}.",Size->Line],
						"Spotlight at Point aimed at Target with Attenuation"->Widget[Type->Expression, Pattern:>{"Spot",ColorP,ConstantArray[ConstantArray[_?NumericQ,3]|Scaled[ConstantArray[_?NumericQ,3]]|ImageScaled[ConstantArray[_?NumericQ,3]],2],{_,_},_},PatternTooltip->"Spotlight point with color at point with half angle, {''Spot'',col,{pt,tr},{alpha,s},att}.",Size->Line]
					]
				]
			],
			Description->"Specifies how face grids should be rendered.",
			Category->"Hidden"
		},
		{
			OptionName->NormalsFunction,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,None]],
				"Pure Function"->Widget[Type->Expression, Pattern:>_Function,Size->Line],
				"Others"->Widget[Type->Expression, Pattern:>_,Size->Line,PatternTooltip->"Any valid pure or delayed function."]
			],
			Description->"Specifies a function to apply to determine the effective surface normals at every point.",
			Category->"Hidden"
		},
		{
			OptionName -> PlotRange,
			Default -> All,
			Description -> "PlotRange specification for the 3D primary data.  PlotRange units must be compatible with units of primary data.",
			AllowNull -> False,
			Category -> "Plot Range",
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
				{
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
					],
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
					]
				},
				(* Can resolve to weird nested lists. *)
				Widget[Type->Expression, Pattern:>_, Size->Line]
			]
		},
		{
			OptionName->RegionFunction,
			Default->(True&),
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				"Pure Function"->Widget[Type->Expression,Pattern:>_Function,Size->Line],
				"Others"->Widget[Type->Expression, Pattern:>_,Size->Line,PatternTooltip->"Any valid pure or delayed function."]
			],
			Description->"Specifies the region to include in the plot drawn. Function should take an {x,y,z} data point as input and return a boolean.",
			Category->"Data Specifications"
		},
		{
			OptionName->RotationAction,
			Default->"Fit",
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives["Clip","Fit"]],
			Description->"Specifies how to render 3D objects when they are interactively rotated.",
			Category->"Hidden"
		},
		{
			OptionName->SphericalRegion,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
			Description->"If True, the final image should be scaled so that a sphere drawn around the three-dimensional bounding box would fit in the display area specified.",
			Category->"Hidden"
		},
		{
			OptionName->TargetUnits,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Set Units"->{
					"x"->Widget[Type->Expression,Pattern:>Automatic|_?UnitsQ,Size->Word],
					"y"->Widget[Type->Expression,Pattern:>Automatic|_?UnitsQ,Size->Word],
					"z"->Widget[Type->Expression,Pattern:>Automatic|_?UnitsQ,Size->Word]
				},
				"Default"->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]]
			],
			Category->"Data Specifications",
			Description -> "The units of the x, y and z axes. If these are distinct from the units currently associated with the data, unit conversions will occur before plotting.",
			ResolutionDescription -> "If Automatic, the units currently associated with the data will be used."
		},
		{
			OptionName->TextureCoordinateFunction,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Pure Function"->Widget[Type->Expression, Pattern:>_Function,Size->Line],
				"Others"->Widget[Type->Expression, Pattern:>_,Size->Line,PatternTooltip->"Any valid pure or delayed function."]
			],
			Description->"Specifies a function that computes texture coordinates.",
			Category->"Hidden"
		},
		{
			OptionName->TextureCoordinateScaling,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,BooleanP]],
			Description->"Specifies whether arguments supplied to a texture coordinate function should be scaled to lie between 0 and 1.",
			Category->"Hidden"
		},
		{
			OptionName->TouchscreenAutoZoom,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,BooleanP]],
			Description->"If True, enables touchscreen autozoom.",
			Category->"Hidden"
		},
		{
			OptionName->VertexColors,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
				"Color"->Alternatives[
					"Single Color"->Widget[Type->Color,Pattern:>ColorP],
					"Color List"->Adder[Widget[Type->Color,Pattern:>ColorP]]
				],
				"Others"->Widget[Type->Expression, Pattern:>_,Size->Line]
			],
			Description->"Specifies the colors to assign to vertices.",
			Category->"Hidden"
		},
		{
			OptionName->VertexNormals,
			Default->False,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
				"Single Vertex"->Widget[Type->Expression,Pattern:>ConstantArray[_?NumericQ,3],Size->Word,PatternTooltip->"A vector with three components."],
				"Multiple Vertices"->Adder[Widget[Type->Expression,Pattern:>ConstantArray[_?NumericQ,3],Size->Word,PatternTooltip->"A vector with three components."]],
				"Others"->Widget[Type->Expression, Pattern:>_,Size->Line]
			],
			Description->"Specifies the normal directions to assign to 3D vertices.",
			Category->"Hidden"
		},
		{
 			OptionName->ViewAngle,
 			Description->"Specifies the opening angle for a simulated camera used to view the three-dimensional scene.",
		 	Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Enumeration,Pattern:>Alternatives[All]],
				"Radian" -> Alternatives[
					Widget[Type->Number,Pattern:>RangeP[0,N@Pi],Min->0,Max->N@Pi],
					Widget[Type->Quantity,Pattern:>RangeP[0*Radian,(N@Pi)*Radian],Units->Radian]
				],
				"Degree" -> Widget[Type->Quantity,Pattern:>RangeP[0*AngularDegree,180*AngularDegree],Units->AngularDegree],
				"Others"-> Widget[Type->Expression, Pattern:>_,Size->Line]
			],
			Category->"3D View"
		},
		{
			OptionName->ViewCenter,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
				{
					"X"->Widget[Type->Number,Pattern:>RangeP[0,1],Min->0,Max->1],
					"Y"->Widget[Type->Number,Pattern:>RangeP[0,1],Min->0,Max->1],
					"Z"->Widget[Type->Number,Pattern:>RangeP[0,1],Min->0,Max->1]
				}
			],
			Description->"Specifies the scaled coordinates of the point which should appear at the center of the final image.",
			Category->"Hidden"
		},
		{
			OptionName->ViewMatrix,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression,Pattern:>_,Size->Line],
			Description->"Specifies a pair of explicit homogeneous transformation and projection matrices for 3D coordinates.",
			Category->"Hidden"
		},
		{
			OptionName->ViewPoint,
			Default->{1.3,-2.4,2.},
			AllowNull->False,
			Widget->Alternatives[
				"3D Point"->{
					"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
					"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
					"Z"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
				},
				Widget[Type->Enumeration, Pattern:>Alternatives[Above]],
				Widget[Type->Enumeration, Pattern:>Alternatives[Front]]
			],
			Description->"Specifies the point in space from which three-dimensional objects are to be viewed.",
			Category->"3D View"
		},
		{
			OptionName->ViewProjection,
			Default->"Perspective",
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic|"Perspective"|"Orthographic"]],
			Description->"Specifies the projection to use for the graphic.",
			Category->"3D View"
		},
		{
			OptionName->ViewRange,
			Default->All,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[All]],
				{
					"Min"->Widget[Type->Number,Pattern:>GreaterEqualP[0.]],
					"Max"->Widget[Type->Number,Pattern:>GreaterP[0.]]
				}
			],
			Description->"Specifies the range of distances from the view point to be included in displaying a three-dimensional scene.",
			Category->"3D View"
		},
		{
			OptionName->ViewVector,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
				"Direction"->
					{
						"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
						"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
						"Z"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
					},
				"Position and Direction"->
				{
					"Position"->
						{
							"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							"Z"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
						},
					"Direction"->
						{
							"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							"Z"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
						}
				}
			],
			Description->"Specifies the position and direction of a simulated camera used to view three-dimensional objects.",
			Category->"3D View"
		},
		{
			OptionName->ViewVertical,
			Default->{0.,0.,1.},
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
				{
					"X"->Widget[Type->Number,Pattern:>RangeP[0.,1.]],
					"Y"->Widget[Type->Number,Pattern:>RangeP[0.,1.]],
					"Z"->Widget[Type->Number,Pattern:>RangeP[0.,1.]]
				}
			],
			Description->"Specifies the vector direction which should be treated as vertical in the three-dimensional graphics object.",
			Category->"3D View"
		}

	}
];

(* ::Subsubsection::Closed:: *)
(*PrimaryDataOption*)


DefineOptionSet[
	PrimaryDataOption :> {
		{
			OptionName->PrimaryData,
			Default->{},
			AllowNull->False,
			Widget->Adder[Widget[Type->FieldReference, Pattern:>FieldReferenceP[{Object[Analysis],Object[Data]}]]],
			Description->"The field name containing the data to be plotted."
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*MapOption*)


DefineOptionSet[
	MapOption :> {
		{
			OptionName->Map,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Description->"Indicates if a list of plots corresponding to each trace will be created, or if all traces within a list will be overlayed on the same plot.",
			Category->"Hidden"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ZoomableOption*)


DefineOptionSet[
	ZoomableOption :> {
		{
			OptionName->Zoomable,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Description->"Indicates if a dynamic plot which can be zoomed in or out will be returned."
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*FrameLabelOption*)


DefineOptionSet[
	FrameLabelOption :> {
		{
			OptionName->FrameLabel,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
					Widget[Type->Expression, Pattern:>({(_String|_Style|None|_Row|Automatic)..}|{{(_String|_Style|None|_Row|Automatic)..},{(_String|_Style|None|_Row|Automatic)..}}), Size->Line]
				],
			Category->"Plot Labeling",
			Description -> "The label to place on top of the frame.",
			ResolutionDescription -> "If Automatic, the x and y axes will be labeled with the names and units of the x and y values being plotted."
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*FrameUnitsOption*)


DefineOptionSet[
	FrameUnitsOption :> {
		{
			OptionName->FrameUnits,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
					"{{l,r},{b,t}}"->{
						"Horizontal Labels"->{
							"Left Label"->Alternatives[
								Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word],
								Widget[Type->Enumeration,Pattern:>None|Automatic]
							],
							"Right Label"->Alternatives[
								Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word],
								Widget[Type->Enumeration,Pattern:>None|Automatic]
							]
						},
						"Vertical Labels"->{
							"Bottom Label"->Alternatives[
								Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word],
								Widget[Type->Enumeration,Pattern:>None|Automatic]
							],
							"Top Label"->Alternatives[
								Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word],
								Widget[Type->Enumeration,Pattern:>None|Automatic]
							]
						}
					},
					"{b,l,t,r}"->{
						"Bottom Label"->Alternatives[
							Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word],
							Widget[Type->Enumeration,Pattern:>None|Automatic]
						],
						"Left Label"->Alternatives[
							Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word],
							Widget[Type->Enumeration,Pattern:>None|Automatic]
						],
						"Top Label"->Alternatives[
							Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word],
							Widget[Type->Enumeration,Pattern:>None|Automatic]
						],
						"Right Label"->Alternatives[
							Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word],
							Widget[Type->Enumeration,Pattern:>None|Automatic]
						]
					},
					"{b,l}"->{
						"Bottom Label"->Alternatives[
							Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word],
							Widget[Type->Enumeration,Pattern:>None|Automatic]
						],
						"Left Label"->Alternatives[
							Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Word],
							Widget[Type->Enumeration,Pattern:>None|Automatic]
						]
					},
					"All"->Widget[Type->Enumeration,Pattern:>Automatic|None]
			],
			Category->"Plot Labeling",
			Description -> "Units to append to FrameLabels. If None, no units will be added. FrameUnits will override the units of input data.",
			ResolutionDescription -> "If Automatic, the x and y axes will be labeled units of the x and y values being plotted."
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*PlotLabelOption*)


DefineOptionSet[
	PlotLabelOption :> {
		{
			OptionName->PlotLabel,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
					Widget[Type->Expression, Pattern:>(NullP|_String|_Pane|_Style), Size->Line]
				],
			Category->"Plot Labeling",
			Description->"The label to place on the plot. If Automatic, the object ID will be used."
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*LinkedObjectsOption*)


DefineOptionSet[
	LinkedObjectsOption :> {
		{
			OptionName->LinkedObjects,
			Default->{},
			AllowNull->False,
			Widget->Adder[Widget[Type->FieldReference, Pattern:>FieldReferenceP[{Object[Analysis],Object[Data]}]]],
			Description->"Fields containing objects which should be pulled from the input object and plotted alongside it."
		}
	}
];


(* ::Subsubsection:: *)
(*OptionFunctionsOption*)


DefineOptionSet[
	OptionFunctionsOption :> {
		{
			OptionName->OptionFunctions,
			Default->{},
			AllowNull->False,
			Widget->Alternatives[
				Adder[Widget[Type->Expression, Pattern:>_Symbol, Size->Line]],
				Widget[Type->Expression,Pattern:>Alternatives[{}],Size->Word]
			],
			Description->"A list of functions which take in a list of info packets and plot options and return a list of new options."
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*PlotThemeOption*)


DefineOptionSet[
	PlotThemeOption :> {
		{
			OptionName->PlotTheme,
			Default->Null,
			AllowNull->True,
			Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Null]],
					Widget[Type->Expression, Pattern:>(NullP|{(_String|_Symbol)..}|(_String|_Symbol)), Size->Line]
				],
			Description->"A PlotTheme describing the general styling of the plot. Any direct specifications of plot styling will overide the default in the theme."
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*LegendOption*)


DefineOptionSet[
	LegendOption :> {
		{
			OptionName->Legend,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
					"Entries"->Adder[Alternatives[
						"String"->Widget[Type->String,Pattern:>_String,Size->Word],
						"Styled String"->Widget[Type->Expression,Pattern:>_Style,Size->Line,BoxText->"Style[\"label\",<directives>]"],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					]],
					"Other"->Widget[Type->Expression,Pattern:>NullP|Automatic|ListableP[(_String|_Style|Null),2]|None,Size->Line]
			],
			Description->"A list of text descriptions of each data set in the plot.",
			Category->"Legend"
		}
	}
];



(* ::Subsubsection::Closed:: *)
(*LegendLabel*)


DefineOptionSet[
	LegendLabelOption :> {
		{
			OptionName->LegendLabel,
			Default->None,
			AllowNull->True,
			Widget->Alternatives[
				"String"->Widget[Type->String,Pattern:>_String,Size->Word],
				"Other"->Widget[Type->Expression, Pattern:>_, Size->Line]
			],
			Description->"A label for the legend.",
			Category -> "Legend"
		}	}
];


(* ::Subsubsection::Closed:: *)
(*LegendPlacementOption*)


DefineOptionSet[
	LegendPlacementOption :> {
		{
			OptionName->LegendPlacement,
			Default->Bottom,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[Bottom,Top,Left,Right]],
			Description->"Specifies where the legend will be placed relative to the plot.",
			Category->"Legend"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*BoxesOption*)


DefineOptionSet[
	BoxesOption :> {
		{
			OptionName->Boxes,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Description->"If true, the legend will pair each label with a colored box. If false, the labels will be paired with a colored line.",
			Category->"Legend"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*IncludeReplicatesOption*)


DefineOptionSet[
	IncludeReplicatesOption :> {
		{
			OptionName->IncludeReplicates,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Description->"When set to true, the average of PrimaryData will be be plotted with error bars."
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*TargetUnitsOption*)


DefineOptionSet[
	TargetUnitsOption :> {
		{
			OptionName->TargetUnits,
			Default->Automatic,
			AllowNull->True,
			Widget->Adder[
					Widget[Type->Expression, Pattern:>(_?UnitsQ|_?KnownUnitQ|Automatic), Size->Line]
			],
			Category->"Data Specifications",
			Description -> "The units of the x and y axes. If these are distinct from the units currently associated with the data, unit conversions will occur before plotting.",
			ResolutionDescription -> "If Automatic, the units currently associated with the data will be used."
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*UnitsOption*)


DefineOptionSet[
	UnitsOption :> {
		{
			OptionName->Units,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
					Widget[Type->Expression, Pattern:>{_Rule..}, Size->Line]
				],
			Category->"Hidden",
			Description -> "The list of units currently associated with each piece of data being plotted.",
			ResolutionDescription -> "If Automatic, the units will be pulled from the data object."
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*SecondaryDataOption*)


DefineOptionSet[
	SecondaryDataOption :> {
		{
			OptionName->SecondaryData,
			Default->{},
			AllowNull->False,
			Widget->Alternatives[
				"Enter field(s):"->Widget[Type->Expression,Pattern:>{FieldP[{Object[Analysis],Object[Data]},Output->Short]...},Size->Line],
				"Select field(s):"->Adder[Widget[Type->FieldReference, Pattern:>FieldReferenceP[{Object[Analysis],Object[Data]}]]]
			],
			Description->"Additional fields to display along with the primary data. The first item in the list determines the second Y axis specifications."
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*DisplayOption*)


DefineOptionSet[
	DisplayOption :> {
		{
			OptionName->Display,
			Default->{},
			AllowNull->False,
			Widget->Alternatives[
				Adder[Widget[Type->Enumeration, Pattern:>Alternatives[Peaks,Fractions,Ladder]]],
				Widget[Type->Expression,Pattern:>{}|{(Fractions|Peaks|Ladder)..},Size->Line]
			],
			Description->"Additional data to overlay on top of the plot."
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ImagesOption*)


DefineOptionSet[
	ImagesOption :> {
		{
			OptionName->Images,
			Default->Null,
			AllowNull->False,
			Widget->Alternatives[
					Adder[Widget[Type->FieldReference, Pattern:>FieldReferenceP[{Object[Analysis],Object[Data]}]]],
					Widget[Type->Enumeration, Pattern:>Alternatives[Null]]
				],
			Description->"A list of fields containing images which should be placed at the top of the plot."
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*PeaksOption*)


DefineOptionSet[
	PeaksOption :> {
		{
			OptionName -> Peaks,
			Default -> Null,
			Description -> "Specification of peaks for primary data.  Peaks must have units that are compatible with the primary data.",
			AllowNull -> True,
			Category -> "Raw Data",
			Widget -> Alternatives[
				Adder[Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Analysis, Peaks]]
					],
					Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
				]],
				Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Analysis, Peaks]]
					],
					Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
				],
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]]
			]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*FractionsOption*)


DefineOptionSet[
	FractionsOption :> {
		{
			OptionName -> Fractions,
			Default -> Null,
			Description -> "Fractions to display on the plot.  Number of fraction sets does not need to match up wtih size of primary data list.",
			AllowNull -> True,
			Category -> "Raw Data",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> {}|NullP|{({}|NullP|FractionP)...}|{({FractionP ...} | NullP|{}) ...}|{{({}|NullP|FractionP)...}...}|{{({FractionP ...} | NullP|{}) ...}...}|_?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({_?UnitsQ,_?UnitsQ,_String?(StringMatchQ[#1,DigitCharacter...~~LetterCharacter~~DigitCharacter..]&)}|_?(MatchQ[Flatten[ToList[#1]],{Null..}]&))|{({_?UnitsQ,_?UnitsQ,_String?(StringMatchQ[#1,DigitCharacter...~~LetterCharacter~~DigitCharacter..]&)}|_?(MatchQ[Flatten[ToList[#1]],{Null..}]&))..}|{{({_?UnitsQ,_?UnitsQ,_String?(StringMatchQ[#1,DigitCharacter...~~LetterCharacter~~DigitCharacter..]&)}|_?(MatchQ[Flatten[ToList[#1]],{Null..}]&))..}..}),
				Size -> Paragraph
			]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*LadderOption*)


DefineOptionSet[
	LadderOption :> {
		{
			OptionName -> Ladder,
			Default -> Null,
			Description -> "Specification of ladders for primary data. Ladders must have units that are compatible with the primary data.",
			AllowNull -> True,
			Category -> "Raw Data",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> NullP|ListableP[Null|{{_?NumericQ,_?UnitsQ}..}]|ListableP[Null|{Rule[_Integer,_?UnitsQ]..}],
				Size -> Paragraph
			]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*PlotRangeOption*)


DefineOptionSet[
	PlotRangeOption :> {
		{
			OptionName -> PlotRange,
			Default -> Automatic,
			Description -> "PlotRange specification for the primary data.  PlotRange units must be compatible with units of primary data.",
			AllowNull -> False,
			Category -> "Plot Style",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> Automatic|All|Full| { Automatic|All|Full|_?UnitsQ|_?NumericQ| { Automatic|All|Full|_?UnitsQ|_?NumericQ, Automatic|All|Full|_?UnitsQ|_?NumericQ},Automatic|All|Full|_?UnitsQ|_?NumericQ| { Automatic|All|Full|_?UnitsQ|_?NumericQ, Automatic|All|Full|_?UnitsQ|_?NumericQ }},
				Size -> Line
			]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*NormalizeOption*)


DefineOptionSet[
	NormalizeOption :> {
		{
			OptionName->Normalize,
			Default->False,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
				Widget[Type->Expression, Pattern:>_?UnitsQ, Size -> Word]
			],
			Description->"If specified, all primary data will be normalized to this value. Otherwise leave data unscaled. Normalize value must have units that are compatible with primary data's units.",
			Category->"Hidden"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ReflectedOption*)


DefineOptionSet[
	ReflectedOption :> {
		{
			OptionName->Reflected,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Description->"Indicates if values should be reflected around the y-axis. FrameTicks will be adjusted to have their original correct values.",
			Category->"Data Specifications"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ScaleOption*)


DefineOptionSet[
	ScaleOption :> {
		{
			OptionName->Scale,
			Default->Linear,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[Linear,Log,LogLinear,LinearLog,LogLog]],
			Description->"Determines scaling transformations of x and y data to create log plots.",
			Category->"Data Specifications"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*TooltipOption*)


DefineOptionSet[
	TooltipOption :> {
		{
			OptionName->Tooltip,
			Default->None,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Expression, Pattern:>_List, Size -> Line],
				Widget[Type->Enumeration, Pattern:>Alternatives[None]],
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]]
			],
			Description->"Tooltips to associate with primary data.",
			Category->"Plot Labeling"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ErrorBarsOption*)


DefineOptionSet[
	ErrorBarsOption :> {
		{
			OptionName->ErrorBars,
			Default->True,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Description->"If True, error bars are added on top of replicate data.",
			Category->"Data Specifications"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ErrorTypeOption*)


DefineOptionSet[
	ErrorTypeOption :> {
		{
			OptionName->ErrorType,
			Default->StandardDeviation,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[StandardDeviation, StandardError]],
			Description->"Determines which value error bars represent for Replicates or DataDistributions.  Parametric distributions always display StandardDeviation because StandardError is only defined for sampled data.",
			Category->"Data Specifications"
		}
	}
];


(* ::Subsection:: *)
(*Grid Options*)


(* ::Subsubsection::Closed:: *)
(*AlignmentOption*)


DefineOptionSet[
	AlignmentOption :> {
		{
			OptionName->Alignment,
			Default->{Center, Baseline},
			AllowNull->False,
			Widget->Alternatives[
					{
						"Horizontal"->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,Left,Right,Top,Bottom,Baseline,Center]],
						"Vertical"->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,Left,Right,Top,Bottom,Baseline,Center]]
					},
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,Left,Right,Top,Bottom,Baseline,Center]]
				],
			Description->"Horizontal and vertical alignment of items.",
			Category->"Plot Style"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*AllowedDimensionsOption*)


DefineOptionSet[
	AllowedDimensionsOption :> {
		{
			OptionName->AllowedDimensions,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
					{
						"Col"->Widget[Type->Number, Pattern:>GreaterP[0,1]],
						"Row"->Widget[Type->Number, Pattern:>GreaterP[0,1]]
					},
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
					Widget[Type->Expression, Pattern:>_List,Size->Line]
				],
			Description->"Restrictions on number of rows or columns.",
			Category->"Data Specifications"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*AutoDeleteOption*)


DefineOptionSet[
	AutoDeleteOption :> {
		{
			OptionName->AutoDelete,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Description->"Whether to remove the grid structure if only one item remains.",
			Category->"Plot Style"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*BackgroundOption*)


DefineOptionSet[
	BackgroundOption :> {
		{
			OptionName->Background,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[None]],
				Adder[Widget[Type->Color,Pattern:>ColorP]],
				Widget[Type->Expression, Pattern:> (ColorP | None | _List),Size->Word]
			],
			Description->"What background colors to use.",
			Category->"Plot Style"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*BaselinePositionOption*)


DefineOptionSet[
	BaselinePositionOption :> {
		{
			OptionName->BaselinePosition,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,Bottom,Top,Center,Axis,Baseline]],
			Description->"What to align with a surrounding text baseline.",
			Category->"Plot Style"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*BaseStyleOption*)


DefineOptionSet[
	BaseStyleOption :> {
		{
			OptionName->BaseStyle,
			Default->White,
			AllowNull->False,
			Widget->Alternatives[
				"Enter individual elements"->Adder[
					Alternatives[
						Widget[Type->Color,Pattern:>ColorP],
						Widget[Type->Expression, Pattern:>(_Style | ColorP | _String), Size->Word]
					]
				],
				"Enter a complete BaseStyle"->Widget[Type->Expression, Pattern:>(_Style | ColorP | _String), Size->Line]
			],
			Description->"Base style specifications for the grid.",
			Category->"Plot Style"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*DefaultElementOption*)


DefineOptionSet[
	DefaultElementOption :> {
		{
			OptionName->DefaultElement,
			Default->"\[Placeholder]",
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_String, Size->Word],
			Description->"What element to insert in an empty item.",
			Category->"Data Specifications"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*DividersOption*)


DefineOptionSet[
	DividersOption :> {
		{
			OptionName->Dividers,
			Default->{},
			AllowNull->False,
			Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[All,None,False,True,Center]],
					Widget[Type->Expression, Pattern:>({BooleanP, BooleanP} | {({BooleanP..}|BooleanP)..}), Size->Line]
				],
			Description->"Where to draw divider lines in the grid.",
			Category->"Plot Style"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*FrameOption*)


DefineOptionSet[
	FrameOption :> {
		{
			OptionName->Frame,
			Default->None,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[All,None,False,True]],
			Description->"Where to draw frames in the grid.",
			Category->"Plot Style"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*FrameStyleOption*)


DefineOptionSet[
	FrameStyleOption :> {
		{
			OptionName->FrameStyle,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				"Enter a Style or Directive"->Widget[Type->Expression, Pattern:>(_Style | _Directive | Automatic), Size->Line]
			],
			Description->"Style to use for frames.",
			Category->"Plot Style"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ItemSizeOption*)


DefineOptionSet[
	ItemSizeOption :> {
		{
			OptionName->ItemSize,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Alternatives[
					{
						"Column Width"->Widget[Type->Number,Pattern:>GreaterP[0]],
						"Row Height"->Widget[Type->Number,Pattern:>GreaterP[0]]
					},
					{
						"Column Widths"->Adder[Widget[Type->Number,Pattern:>GreaterP[0]]],
						"Row Heights"->Adder[Widget[Type->Number,Pattern:>GreaterP[0]]]
					}
				],
				Widget[Type->Expression, Pattern:>(GreaterP[0,1] | _List | Full | All | Automatic), Size->Line]
			],
			Description->"Width and height of each item.",
			Category->"Plot Style"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ItemStyleOption*)


DefineOptionSet[
	ItemStyleOption :> {
		{
			OptionName->ItemStyle,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				"Enter individual elements"->Adder[
					Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives["Button","Menu","Section","Subsection","SmallText","Text","Title"]],
						Widget[Type->Color,Pattern:>ColorP],
						Widget[Type->Expression, Pattern:>(_Style | ColorP | None | _List | _String), Size->Word]
					]
				],
				"Enter a complete ItemStyle"->Widget[Type->Expression, Pattern:>(_Style | ColorP | None | _List | _String), Size->Line]
			],
			Description->"Styles for columns and rows.",
			Category->"Plot Style"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*SpacingsOption*)


DefineOptionSet[
	SpacingsOption :> {
		{
			OptionName->Spacings,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>(GreaterP[0,1]| Automatic | _List), Size->Line],
			Description->"Horizontal and vertical spacings.",
			Category->"Plot Style"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*GridOption*)


DefineOptionSet[
	GridOption :> {
		AlignmentOption,
		AllowedDimensionsOption,
		AutoDeleteOption,
		BackgroundOption,
		BaselinePositionOption,
		BaseStyleOption,
		DefaultElementOption,
		DividersOption,
		FrameOption,
		FrameStyleOption,
		ItemSizeOption,
		ItemStyleOption,
		SpacingsOption
	}

];



(* ::Subsubsection::Closed:: *)
(*SecondYOptions*)


DefineOptionSet[
	SecondYOptions :> {
		{
			OptionName -> SecondYCoordinates,
			Default -> None,
			Description -> "Data to display on second-y (right) axis.  The x-units of all secondary data must be compatible with the x-units of the primary data.",
			AllowNull -> False,
			Category -> "Secondary Data",
			Widget -> Alternatives[
				"Coordinate Set"->Widget[Type -> Expression, Pattern :> None|UnitCoordinatesP[]|{({}|ListableP[{}|Null|UnitCoordinatesP[]])..}, Size -> Paragraph],
				"Single Coordinate List"->Adder[
					{
						"x"->Widget[Type->Expression,Pattern:>UnitsP[]|_?DateObjectQ,Size->Word],
						"y"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word]
					}
				],
				"Nested Coordinate List"->Adder[
					Adder[
						{
							"x"->Widget[Type->Expression,Pattern:>UnitsP[]|_?DateObjectQ,Size->Word],
							"y"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word]
						}
					]
				]
			]
		},
		{
			OptionName -> SecondYColors,
			Default -> Automatic,
			Description -> "Colors to associate with second-y data.",
			ResolutionDescription -> "Use default color scheme",
			AllowNull -> False,
			Category -> "Secondary Data",
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				Adder[
					Widget[Type->Color,Pattern:>ColorP]
				]
			]
		},
		{
			OptionName -> SecondYUnit,
			Default -> Automatic,
			Description -> "The first secondary data dimension will be converted to this unit before plotting.  If Automatic, units are taken from the first secondary data set.  Note that this only control the y-unit, as the x-unit for secondary data is taken from the TargetUnits of the primary data.",
			AllowNull -> False,
			Category -> "Secondary Data",
			Widget -> Widget[Type -> Expression, Pattern :> Automatic|Null|_?UnitsQ, Size -> Line]
		},
		{
			OptionName -> SecondYRange,
			Default -> Automatic,
			Description -> "Y Range for second Y axis.  If Automatic, range is taken to include all data points.",
			AllowNull -> False,
			Category -> "Secondary Data",
			Widget -> Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,Full,All]],
				{
					"Y Minimum"->Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,Full,All]],
						Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Line,PatternTooltip->"Any valid number or quantity."]
					],
					"Y Maximum"->Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,Full,All]],
						Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Line,PatternTooltip->"Any valid number or quantity."]
					]
				},
				Adder[
					Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,Full,All]],
						{
							"Y Minimum"->Alternatives[
								Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,Full,All]],
								Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Line,PatternTooltip->"Any valid number or quantity."]
							],
							"Y Maximum"->Alternatives[
								Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,Full,All]],
								Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Line,PatternTooltip->"Any valid number or quantity."]
							]
						}
					]
				]
			]
		},
		{
			OptionName -> SecondYStyle,
			Default -> None,
			Description -> "Style to associate with second-y data.",
			AllowNull -> False,
			Category -> "Secondary Data",
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[None,Thick,Thin,Dashed,Dotted,DotDashed]],
				Adder[
					Widget[Type->Enumeration,Pattern:>Alternatives[Thick,Thin,Dashed,Dotted,DotDashed]]
				],
				Widget[Type->Expression,Pattern:>_Thickness,Size->Line]
			]
		}
	}
];

(* ::Subsubsection::Closed:: *)
(*InteractiveImageOptions*)

DefineOptionSet[
	InteractiveImageOptions :> {
		{
			OptionName -> FrameLabel,
			Default -> None,
			AllowNull -> False,
			Description -> "The titles for the x and y axes of the image. If units are specified in the Scale option, they are included in the title.",
			Category -> "Plot Labeling",
			Widget -> Alternatives[
				{
					"X-Label" -> Widget[Type->String,Pattern:>_String|None,Size->Line],
					"Y-Label" -> Widget[Type->String,Pattern:>_String|None,Size->Line]
				},
				Widget[Type->Enumeration,Pattern:>Alternatives[None]]
			]
		},
		{
			OptionName -> ScrollZoom,
			Default -> True,
			AllowNull -> False,
			Description -> "Indicates if zooming with the mouse wheel is enabled on the image.",
			Category -> "Plot Interaction",
			Widget -> Widget[Type->Enumeration, Pattern:>BooleanP]
		},
		{
			OptionName -> PreserveAspectRatio,
			Default -> True,
			AllowNull -> False,
			Description -> "Indicates if all zooming will retain the same ratio of height to width as the input image.",
			Category -> "Plot Interaction",
			Widget -> Widget[Type->Enumeration, Pattern:>BooleanP]
		},
		{
			OptionName -> AutoDownsampling,
			Default -> True,
			AllowNull -> False,
			Description -> "Indicates if the number of pixels shown in the image should be reduced when completely zoomed out and then subsequently added back in as smaller portions of the image are magnified. This will enhance the smoothness of zooming, especially for large images.",
			Category -> "Plot Interaction",
			Widget -> Widget[Type->Enumeration, Pattern:>BooleanP]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ImageOptions*)


DefineOptionSet[
	ImageOptions :> {
		{
			OptionName -> Scale,
			Default -> Automatic,
			Description -> "The ratio of pixels to physical distance, which is used to compute the ruler markings and distances.",
			AllowNull -> False,
			Category -> "Plot Labeling",
			Widget -> Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
				Widget[Type->Quantity,Pattern:>GreaterP[0 Meter]|GreaterP[0/Meter],Units->Alternatives@@Join[DistanceUnits,1/DistanceUnits]],
				Widget[Type->Expression, Pattern:>UnitsP[Meter/Pixel]|UnitsP[Pixel/Meter], Size->Word]
			]
		},
		{
			OptionName -> RulerPlacement,
			Default -> {Bottom, Left, Top, Right},
			Description -> "Specify which frames will be labeled with rulers.",
			AllowNull -> False,
			Category -> "Plot Labeling",
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>None|Bottom|Left|Right|Top],
				Adder@Widget[Type->Enumeration,Pattern:>Bottom|Left|Right|Top]
			]
		},
		{
			OptionName -> RulerType,
			Default -> Relative,
			Description -> "Relative measurements reset the ruler to start at zero after zooming, while Absolute measurements preserve the absolute coordinate positions when zooming.",
			AllowNull -> False,
			Category -> "Plot Labeling",
			Widget -> Widget[Type->Enumeration, Pattern:>Absolute|Relative]
		},
		{
			OptionName -> MeasurementLines,
			Default -> {},
			Description -> "Place interactive lines on the image that can be dragged and positioned to measure distances on the image.",
			AllowNull -> False,
			Category -> "Plot Labeling",
			Widget -> Alternatives[
				Adder[
					{
						"Point 1"->{
							"X1"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
							"Y1"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word]
						},
						"Point 2"->{
							"X2"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
							"Y2"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word]
						}
					}
				],
				Widget[Type->Expression,Pattern:>{{{UnitsP[],UnitsP[]},{UnitsP[],UnitsP[]}}...},Size->Line]
			]
		},
		{
			OptionName -> MeasurementLabel,
			Default -> True,
			Description -> "If True, measurement lines are labeled with their length.  Otherwise labels are only visible on mouseover as tooltips.",
			AllowNull -> False,
			Category -> "Plot Labeling",
			Widget -> Widget[Type->Enumeration, Pattern:>BooleanP]
		}
	}
];

(* ::Subsubsection:: *)
(*ImageSelectOptions*)

DefineOptionSet[
	ImageSelectOptions :> {
		IndexMatching[
			{
				OptionName->Instrument,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Instrument,Microscope],Object[Instrument,Microscope]}]
					],
					Adder[Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Instrument,Microscope],Object[Instrument,Microscope]}]
					]]
				],
				Description->"The microscope used to acquire the images.",
				Category->"Instrument"
			},
			{
				OptionName->ProtocolBatchNumber,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					],
					Adder[Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					]]
				],
				Description->"Indicates the batch number of the protocol in which the images were acquired.",
				Category->"Organizational Information"
			},
			{
				OptionName->DateAcquired,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Date,
						Pattern:>_?DateObjectQ,
						TimeSelector->True
					],
					Adder[Widget[
						Type->Date,
						Pattern:>_?DateObjectQ,
						TimeSelector->True
					]],
					Span[
						Widget[Type->Date,Pattern:>_?DateObjectQ,TimeSelector->True],
						Widget[Type->Date,Pattern:>_?DateObjectQ,TimeSelector->True]
					]
				],
				Description->"Indicates the dates on which the images were acquired.",
				Category->"Organizational Information"
			},
			{
				OptionName->Mode,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All,MicroscopeModeP]
					],
					Adder[Widget[
						Type->Enumeration,
						Pattern:>MicroscopeModeP
					]]
				],
				Description->"Indicates the type of microscopy technique used to acquire an image of a sample.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->ObjectiveMagnification,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Number,
						Pattern:>GreaterP[0]
					],
					Adder[Widget[
						Type->Number,
						Pattern:>GreaterP[0]
					]],
					Span[
						Widget[Type->Number,Pattern:>GreaterP[0]],
						Widget[Type->Number,Pattern:>GreaterP[0]]
					]
				],
				Description->"The magnification power of the objective lens used to acquire the images.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->ObjectiveNumericalAperture,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Number,
						Pattern:>GreaterP[0]
					],
					Adder[Widget[
						Type->Number,
						Pattern:>GreaterP[0]
					]],
					Span[
						Widget[Type->Number,Pattern:>GreaterP[0]],
						Widget[Type->Number,Pattern:>GreaterP[0]]
					]
				],
				Description->"The numerical aperture of the objective used to acquire the images.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->Objective,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Part,Objective],Model[Part,Objective]}]
					],
					Adder[Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Part,Objective],Model[Part,Objective]}]
					]]
				],
				Description->"The objective lens used to acquire the images.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->ImageTimepoint,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					],
					Adder[Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					]],
					Span[
						Widget[Type->Number,Pattern:>GreaterP[0,1]],
						Widget[Type->Number,Pattern:>GreaterP[0,1]]
					]
				],
				Description->"Indicates the index of timepoints at which the images were acquired.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->ImageZStep,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					],
					Adder[Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					]],
					Span[
						Widget[Type->Number,Pattern:>GreaterP[0,1]],
						Widget[Type->Number,Pattern:>GreaterP[0,1]]
					]
				],
				Description->"Indicates the index of positions the sample's z-axis at which the images were acquired.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->ImagingSite,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					],
					Adder[Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					]],
					Span[
						Widget[Type->Number,Pattern:>GreaterP[0,1]],
						Widget[Type->Number,Pattern:>GreaterP[0,1]]
					]
				],
				Description->"Indicates the index of regions within the sample at which the images were acquired.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->ExcitationWavelength,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Null,All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Nanometer],
						Units->Nanometer
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Nanometer],
						Units->Nanometer
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterP[0 Nanometer],Units->Nanometer],
						Widget[Type->Quantity,Pattern:>GreaterP[0 Nanometer],Units->Nanometer]
					]
				],
				Description->"Indicates the wavelength of excitation light used to illuminate the sample when the images were acquired.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->EmissionWavelength,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Null,All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Nanometer],
						Units->Nanometer
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Nanometer],
						Units->Nanometer
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterP[0 Nanometer],Units->Nanometer],
						Widget[Type->Quantity,Pattern:>GreaterP[0 Nanometer],Units->Nanometer]
					]
				],
				Description->"Indicates the wavelength at which fluorescence emitted from the sample was acquired.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->DichroicFilterWavelength,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Null,All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Nanometer],
						Units->Nanometer
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Nanometer],
						Units->Nanometer
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterP[0 Nanometer],Units->Nanometer],
						Widget[Type->Quantity,Pattern:>GreaterP[0 Nanometer],Units->Nanometer]
					]
				],
				Description->"Indicates the wavelength passed by the dichroic filter to illuminate the sample when the images were acquired.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->EmissionFilter,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Null,All]
					],
					Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Part,OpticalFilter],Model[Part,OpticalFilter]}]
					],
					Adder[Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Part,OpticalFilter],Model[Part,OpticalFilter]}]
					]]
				],
				Description->"Indicates the optical filter used in the light path at the time the images were acquired to selectively pass fluorescence emitted from the sample.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->DichroicFilter,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Null,All]
					],
					Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Part,OpticalFilter],Model[Part,OpticalFilter]}]
					],
					Adder[Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Part,OpticalFilter],Model[Part,OpticalFilter]}]
					]]
				],
				Description->"Indicates the dichroic filter used in the light path at the time the image was acquired to selectively pass fluorescence emitted from the sample and reflect excitation light.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->ExcitationPower,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Null,All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Percent],
						Units->Percent
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Percent],
						Units->Percent
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterP[0 Percent],Units->Percent],
						Widget[Type->Quantity,Pattern:>GreaterP[0 Percent],Units->Percent]
					]
				],
				Description->"Indicates the percent of maximum intensity of the light source used to illuminate the sample.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->TransmittedLightPower,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Null,All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Percent],
						Units->Percent
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Percent],
						Units->Percent
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterP[0 Percent],Units->Percent],
						Widget[Type->Quantity,Pattern:>GreaterP[0 Percent],Units->Percent]
					]
				],
				Description->"Indicates the percent of maximum intensity of the transmitted light used to illuminate the sample.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->ExposureTime,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Null,All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Millisecond],
						Units->Alternatives[Microsecond,Millisecond,Second]
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Millisecond],
						Units->Alternatives[Microsecond,Millisecond,Second]
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterP[0 Millisecond],Units->Alternatives[Microsecond,Millisecond,Second]],
						Widget[Type->Quantity,Pattern:>GreaterP[0 Millisecond],Units->Alternatives[Microsecond,Millisecond,Second]]
					]
				],
				Description->"Indicates the length of time that the camera collects the signal from the sample.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->FocalHeight,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Null,All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Millimeter],
						Units->Alternatives[Micrometer,Millimeter]
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Millimeter],
						Units->Alternatives[Micrometer,Millimeter]
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterP[0 Millimeter],Units->Alternatives[Micrometer,Millimeter]],
						Widget[Type->Quantity,Pattern:>GreaterP[0 Millimeter],Units->Alternatives[Micrometer,Millimeter]]
					]
				],
				Description->"Indicates the length of time that the camera collects the signal from the sample.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->ImageCorrection,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All,MicroscopeImageCorrectionP]
					],
					Adder[Widget[
						Type->Enumeration,
						Pattern:>MicroscopeImageCorrectionP
					]]
				],
				Description->"Indicates the correction method applied to the image after acquisition to remove stray light or mitigate the uneven illumination.",
				Category->"Acquisition Parameters"
			},
			{
				OptionName->ImageSizeX,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Pixel],
						Units->Pixel
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Pixel],
						Units->Pixel
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterP[0 Pixel],Units->Pixel],
						Widget[Type->Quantity,Pattern:>GreaterP[0 Pixel],Units->Pixel]
					]
				],
				Description->"Indicates the size of the image in X direction (Width) measure in pixel.",
				Category->"Image Properties"
			},
			{
				OptionName->ImageSizeY,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Pixel],
						Units->Pixel
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Pixel],
						Units->Pixel
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterP[0 Pixel],Units->Pixel],
						Widget[Type->Quantity,Pattern:>GreaterP[0 Pixel],Units->Pixel]
					]
				],
				Description->"Indicates the size of the image in Y direction (Length) measured in pixel.",
				Category->"Image Properties"
			},
			{
				OptionName->ImageScaleX,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Micrometer/Pixel],
						Units->Micrometer/Pixel
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Micrometer/Pixel],
						Units->Micrometer/Pixel
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterP[0 Micrometer/Pixel],Units->Micrometer/Pixel],
						Widget[Type->Quantity,Pattern:>GreaterP[0 Micrometer/Pixel],Units->Micrometer/Pixel]
					]
				],
				Description->"Indicates the size of each pixel in X direction (Width) of the image.",
				Category->"Image Properties"
			},
			{
				OptionName->ImageScaleY,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Micrometer/Pixel],
						Units->Micrometer/Pixel
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Micrometer/Pixel],
						Units->Micrometer/Pixel
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterP[0 Micrometer/Pixel],Units->Micrometer/Pixel],
						Widget[Type->Quantity,Pattern:>GreaterP[0 Micrometer/Pixel],Units->Micrometer/Pixel]
					]
				],
				Description->"Indicates the size of each pixel in Y direction (Length) of the image.",
				Category->"Image Properties"
			},
			{
				OptionName->ImageBitDepth,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					],
					Adder[Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					]],
					Span[
						Widget[Type->Number,Pattern:>GreaterP[0,1]],
						Widget[Type->Number,Pattern:>GreaterP[0,1]]
					]
				],
				Description->"Indicates the binary range of possible grayscale values stored in each pixel of the image.",
				Category->"Image Properties"
			},
			{
				OptionName->PixelBinning,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					],
					Adder[Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					]],
					Span[
						Widget[Type->Number,Pattern:>GreaterP[0,1]],
						Widget[Type->Number,Pattern:>GreaterP[0,1]]
					]
				],
				Description->"Indicates the binning of pixels in the images.",
				Category->"Image Properties"
			},
			{
				OptionName->StagePositionX,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterEqualP[0 Micrometer],
						Units->Alternatives[Micrometer,Millimeter]
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterEqualP[0 Micrometer],
						Units->Alternatives[Micrometer,Millimeter]
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Micrometer],Units->Alternatives[Micrometer,Millimeter]],
						Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Micrometer],Units->Alternatives[Micrometer,Millimeter]]
					]
				],
				Description->"Indicates the X value of the stage at the time the image was acquired.",
				Category->"Imaging Region"
			},
			{
				OptionName->StagePositionY,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterEqualP[0 Micrometer],
						Units->Alternatives[Micrometer,Millimeter]
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterEqualP[0 Micrometer],
						Units->Alternatives[Micrometer,Millimeter]
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Micrometer],Units->Alternatives[Micrometer,Millimeter]],
						Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Micrometer],Units->Alternatives[Micrometer,Millimeter]]
					]
				],
				Description->"Indicates the Y value of the stage at the time the image was acquired.",
				Category->"Imaging Region"
			},
			{
				OptionName->ImagingSiteRow,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					],
					Adder[Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					]],
					Span[
						Widget[Type->Number,Pattern:>GreaterP[0,1]],
						Widget[Type->Number,Pattern:>GreaterP[0,1]]
					]
				],
				Description->"Indicates the row of the grid representing all the imaging sites that the image was acquired from. Row 1 is the top row of the grid.",
				Category->"Imaging Region"
			},
			{
				OptionName->ImagingSiteColumn,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					],
					Adder[Widget[
						Type->Number,
						Pattern:>GreaterP[0,1]
					]],
					Span[
						Widget[Type->Number,Pattern:>GreaterP[0,1]],
						Widget[Type->Number,Pattern:>GreaterP[0,1]]
					]
				],
				Description->"Indicates the column of the grid representing all the imaging sites that the image was acquired from. Column 1 is the left most column of the grid.",
				Category->"Imaging Region"
			},
			{
				OptionName->ImagingSiteRowSpacing,
				Default->All,
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Quantity,
						Pattern:>RangeP[-85 Millimeter,85 Millimeter],
						Units->Alternatives[Micrometer,Millimeter]
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>RangeP[-85 Millimeter,85 Millimeter],
						Units->Alternatives[Micrometer,Millimeter]
					]],
					Span[
						Widget[Type->Quantity,Pattern:>RangeP[-85 Millimeter,85 Millimeter],Units->Alternatives[Micrometer,Millimeter]],
						Widget[Type->Quantity,Pattern:>RangeP[-85 Millimeter,85 Millimeter],Units->Alternatives[Micrometer,Millimeter]]
					]
				],
				Description->"The distance between each column of images to be acquired. Negative distances indicate overlapping regions between adjacent rows.",
				Category->"Imaging Region"
			},
			{
				OptionName->ImagingSiteColumnSpacing,
				Default->All,
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Quantity,
						Pattern:>RangeP[-127 Millimeter,127 Millimeter],
						Units->Alternatives[Micrometer,Millimeter]
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>RangeP[-127 Millimeter,127 Millimeter],
						Units->Alternatives[Micrometer,Millimeter]
					]],
					Span[
						Widget[Type->Quantity,Pattern:>RangeP[-127 Millimeter,127 Millimeter],Units->Alternatives[Micrometer,Millimeter]],
						Widget[Type->Quantity,Pattern:>RangeP[-127 Millimeter,127 Millimeter],Units->Alternatives[Micrometer,Millimeter]]
					]
				],
				Description->"The distance between each column of images to be acquired. Negative values indicate overlapping regions between adjacent columns.",
				Category->"Imaging Region"
			},
			{
				OptionName->WellCenterOffsetX,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterEqualP[-500 Millimeter],
						Units->Alternatives[Micrometer,Millimeter]
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterEqualP[-500 Millimeter],
						Units->Alternatives[Micrometer,Millimeter]
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterEqualP[-500 Millimeter],Units->Alternatives[Micrometer,Millimeter]],
						Widget[Type->Quantity,Pattern:>GreaterEqualP[-500 Millimeter],Units->Alternatives[Micrometer,Millimeter]]
					]
				],
				Description->"Indicates the position at which the image was acquired in the X direction relative to the center of the well which has coordinates of (0,0).",
				Category->"Imaging Region"
			},
			{
				OptionName->WellCenterOffsetY,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterEqualP[-500 Millimeter],
						Units->Alternatives[Micrometer,Millimeter]
					],
					Adder[Widget[
						Type->Quantity,
						Pattern:>GreaterEqualP[-500 Millimeter],
						Units->Alternatives[Micrometer,Millimeter]
					]],
					Span[
						Widget[Type->Quantity,Pattern:>GreaterEqualP[-500 Millimeter],Units->Alternatives[Micrometer,Millimeter]],
						Widget[Type->Quantity,Pattern:>GreaterEqualP[-500 Millimeter],Units->Alternatives[Micrometer,Millimeter]]
					]
				],
				Description->"Indicates the position at which the image was acquired in the Y direction relative to the center of the well which has coordinates of (0,0).",
				Category->"Imaging Region"
			},
			IndexMatchingInput->"Microscope data"
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PeakEpilogOptions*)


DefineOptionSet[
	PeakEpilogOptions :> {
		{
			OptionName -> Display,
			Default -> {Gradient, Fractions, Peaks},
			Description -> "Additional data to overlay on top of the plot.",
			AllowNull -> False,
			Category -> "Data Specifications",
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				Widget[
					Type -> MultiSelect,
					Pattern :> ListableP[Peaks|PeakWidths|Fractions|Ladder|Gradient]
				]
			]
		},
		{
			OptionName -> SecondYUnscaled,
			Default -> {},
			Description -> "If there is data plotted on a second Y axis, that data is in raw form.  If listable version used, must match list dimensions.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				Adder[
					{
						"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
						"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
					}
				]
			]
		},
		{
			OptionName -> SecondYScaled,
			Default -> {},
			Description -> "If there is data plotted on a second Y axis, the data plotted on that axis is re-scaled to the primary axes.  If listable version used, must match list dimensions.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				Adder[
					{
						"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
						"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
					}
				]
			]
		},
		{
			OptionName -> Yaxis,
			Default -> True,
			Description ->  "Draws lines and labels to the Yaxes on mouseover if set to true.",
			AllowNull -> False,
			Category -> "Data Specifications",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> PeakPointSize,
			Default -> 0.015,
			Description -> "Size of the points on the picked peaks.",
			AllowNull -> False,
			Category -> "Data Specifications",
			Widget -> Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
		},
		{
			OptionName -> PeakPointColor,
			Default -> RGBColor[0., 0.5, 1.],
			Description -> "Color of the peak points.",
			AllowNull -> False,
			Category -> "Data Specifications",
			Widget -> Widget[Type->Color,Pattern:>ColorP]
		},
		{
			OptionName -> PeakWidthColor,
			Default -> RGBColor[0.5, 0, 0.5],
			Description -> "Color of the peak width bars.",
			AllowNull -> False,
			Category -> "Data Specifications",
			Widget -> Widget[Type->Color,Pattern:>ColorP]
		},
		{
			OptionName -> PeakAreaColor,
			Default -> RGBColor[0., 0.5, 1.],
			Description -> "Color of the peak areas.",
			AllowNull -> False,
			Category -> "Data Specifications",
			Widget -> Widget[Type->Color,Pattern:>ColorP]
		},
		{
			OptionName->PeakSplitting,
			Default->Automatic,
			AllowNull->False,
			Category->"Hidden",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"True for visualization of NMR peak splitting, False otherwise."
		}
	}
];
