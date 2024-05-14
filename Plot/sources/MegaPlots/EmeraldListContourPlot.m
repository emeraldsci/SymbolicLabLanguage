(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldListContourPlot*)


DefineOptions[EmeraldListContourPlot,
	Options:>	{

		(*** Image Format Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->AspectRatio,Default->1.0},
				{OptionName->ImageSize}
			}
		],
		ModifyOptions[ZoomableOption,Default->False,Category->"Image Format"],

		(*** Plot Range Options ***)
		ModifyOptions[ListPlotOptions,{PlotRange,PlotRangeClipping,ClippingStyle}],

		(*** Plot Labeling Options ***)
		ModifyOptions[ListPlotOptions,{PlotLabel,FrameLabel,RotateLabel,LabelStyle}],

		(*** Legend Options ***)
		ModifyOptions[ListPlotOptions,{PlotLegends},Category->"Legend"],

		(*** Data Specification options ***)
		ModifyOptions[ListPlotOptions,{DataRange},Category->"Data Specifications"],
		ModifyOptions[ListPlot3DOptions,{RegionFunction},Category->"Data Specifications"],
		ModifyOptions[TargetUnitsOption,
			Widget->Alternatives[
				"Manual"->{
					"x"->Widget[Type->Expression,Pattern:>Automatic|_?UnitsQ,Size->Word],
					"y"->Widget[Type->Expression,Pattern:>Automatic|_?UnitsQ,Size->Word],
					"z"->Widget[Type->Expression,Pattern:>Automatic|_?UnitsQ,Size->Word]
				},
				"Default"->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]]
			],
			Description->"Primary data is converted to these units before plotting.  If Automatic, units are taken from the first primary data set.  TargetUnits must be compatible with units on primary data."
		],

		(*** Plot Style Options ***)
		ModifyOptions[ListPlotOptions,{Background,BaseStyle},Category->"Plot Style"],
		ModifyOptions[ListPlot3DOptions,{BoundaryStyle},Category->"Plot Style"],
		ModifyOptions[ListPlotOptions,{ColorFunction,ColorFunctionScaling},Category->"Plot Style"],
		{
			OptionName->Contours,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Default"->Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				"Number"->Widget[Type->Number,Pattern:>GreaterEqualP[0,1],PatternTooltip->"Number of equally spaced contours to use."],
				"Maximum Number"->{
					"Auto"->Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
					"Max Number"->Widget[Type->Number,Pattern:>GreaterEqualP[0,1],PatternTooltip->"Maximum number of automatically spaced contours to use."]
				},
				"Specific Contours"->Adder[
					Alternatives[
						"Contour Value"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
						"Contour Value and Style"->{
							"Value"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
							"Style"->Widget[Type->Expression,Pattern:>_,Size->Line,BoxText->"A valid style directive."]
						}
					]
				],
				"Function"->Widget[Type->Expression,Pattern:>_Function,Size->Line]
			],
			Description->"The number and/or values of the contours to use in this plot.",
			Category->"Plot Style"
		},
		{
			OptionName->ContourLabels,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Specification"->Widget[Type->Enumeration,Pattern:>Automatic|All|None],
				"Function"->Widget[Type->Expression,Pattern:>_Function,Size->Line]
			],
			Description->"Either a specification or a function determining if and how labels should be generated for contours.",
			Category->"Plot Style"
		},
		{
			OptionName->ContourShading,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Specification"->Widget[Type->Enumeration,Pattern:>Automatic|None],
				"List of Colors"->Adder[Widget[Type->Expression,Pattern:>ColorP,Size->Word]],
				"List of Colors with Style"->Widget[Type->Expression,Pattern:>{(_Directive|_Opacity|ColorP|{ColorP,__})..},Size->Paragraph]
			],
			Description->"Specify how the space between contours should be shaded.",
			Category->"Plot Style"
		},
		{
			OptionName->ContourStyle,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Specification"->Widget[Type->Enumeration,Pattern:>Automatic|None],
				"Single Style"->Widget[Type->Expression,Pattern:>_Symbol|ColorP|_Directive,BoxText->"A single style directive, such as Red, Dashed, or Directive[Blue,Thick]",Size->Line],
				"List of Styles"->Widget[Type->Expression,Pattern:>{(_Symbol|ColorP|_Directive|{_Symbol|ColorP|_Directive,__})..},Size->Paragraph]
			],
			Description->"Specify how contour lines should be drawn.",
			Category->"Plot Style"
		},
		ModifyOptions[ListPlotOptions,{InterpolationOrder,PlotTheme},Category->"Plot Style"],

		(*** Frame Options ***)
		ModifyOptions[ListPlotOptions,{Frame,FrameStyle,FrameTicks,FrameTicksStyle}],

		(*** Grid Options ***)
		ModifyOptions[ListPlotOptions,{GridLines,GridLinesStyle}],

		(*** Mesh Options ***)
		ModifyOptions[ListPlotOptions,{Mesh,MeshFunctions,MeshStyle,MaxPlotPoints},Category->"Mesh"],

		(*** General Options ***)
		ModifyOptions[ListPlotOptions,{PerformanceGoal,Prolog,Epilog},Category->"General"],

		(*** Hidden Options***)

		(* Hidden options which require no changes from their defaults in the shared option sets *)
		ModifyOptions[ListPlotOptions,
			{
				AlignmentPoint,Axes,AxesLabel,AxesOrigin,AxesStyle,
				BaselinePosition,ColorOutput,ContentSelectable,
				CoordinatesToolOptions,DisplayFunction,FormatType,
				ImageMargins,ImagePadding,ImageSizeRaw,
				LabelingSize,Method,PlotRangePadding,PlotRegion,
				PreserveImageOptions,ScalingFunctions,Ticks,TicksStyle
			}
		],

		(* Output option for command builder *)
		OutputOption
	}
];


EmeraldListContourPlot[in_,ops:OptionsPattern[EmeraldListContourPlot]]:=Module[
	{
		plotType,originalOps,safeOps,output,plot,internalMMPlotOps,
		resolvedOps,unresolveableOps,optionsRule,finalPlot
	},

	(* Set the plot type *)
	plotType=ListContourPlot;

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[EmeraldListContourPlot,checkForNullOptions[originalOps]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* EmeraldListContourPlot passes straight to ListContourPlot with minimal resolution*)
	internalMMPlotOps=FilterRules[safeOps,Options[ListContourPlot]]/.{
		(* Workaround for weird handling of the PlotTheme option under the hood in MM *)
		RuleDelayed[PlotTheme,$PlotTheme]->Rule[PlotTheme,Automatic]
	};

	(* Generate the plot, reverting our Null-hidden options to Automatic where appropriate *)
	plot=ListContourPlot[in,DeleteCases[internalMMPlotOps,PlotRange->Automatic]];

	(* Use the ResolvedPlotOptions helper to extract resolved options from the MM Plot (e.g. PlotRange) *)
	resolvedOps=resolvedPlotOptions[plot,internalMMPlotOps,plotType]/.{
		(* Workaround to handle a bug in MM ListContourPlot where PlotRangePadding can only be specified as a single value. *)
		Rule[PlotRangePadding,{{x_,_},{_,_}}]:>Rule[PlotRangePadding,x],

		(* DataRange is bugged in MM's ListContourPlot so disable it for now *)
		Rule[DataRange,Automatic]->Rule[DataRange,Null],

		(* TargetUnits is also bugged in ListContourPlot so disable it for now *)
		Rule[TargetUnits,Automatic]->Rule[TargetUnits,Null]
	};

	(* Check that all options have been resolved *)
	unresolveableOps=Select[resolvedOps,MatchQ[Last[#],Automatic]&];

	(* Warning message if any of the resolved options are either Automatic or contain Automatic *)
	(*If[Length[unresolveableOps]>0,
		Message[Warning::UnresolvedPlotOptions,First/@unresolveableOps];
	];*)

	(* Generate the options rule for output*)
	optionsRule=If[MemberQ[ToList[output],Options],
		Options->resolvedOps,
		Options->Null
	];

	(* Apply Zoomable if it was requested *)
	finalPlot=If[TrueQ[Lookup[safeOps,Zoomable]],
		Zoomable[plot],
		plot
	];

	(* Return the requested outputs *)
	output/.{
		Result->finalPlot,
		optionsRule,
		Preview->finalPlot/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Tests->{}
	}
];
