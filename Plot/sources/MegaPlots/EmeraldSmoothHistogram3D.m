(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldSmoothHistogram3D*)


DefineOptions[EmeraldSmoothHistogram3D,
	Options :> {

		(*** Image Format Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->AspectRatio,Default->Automatic},
				{OptionName->ImageSize}
			}
		],

		(*** Plot Range Options ***)
		ModifyOptions[ListPlot3DOptions,{PlotRange}],
		ModifyOptions[ListPlotOptions,{ClippingStyle}],


		(*** Plot Labeling Options ***)
		ModifyOptions[ListPlotOptions,{PlotLabel}],
		ModifyOptions[ListPlot3DOptions,{AxesLabel}],
		ModifyOptions[ListPlotOptions,{LabelStyle}],

		(*** Legend Options ***)
		ModifyOptions[ListPlotOptions,{PlotLegends},Category->"Legend"],

		(*** Data Specification options ***)
		ModifyOptions[ListPlot3DOptions,{ClipPlanes,ClipPlanesStyle}],
		ModifyOptions[ChartOptions,{DistributionFunction},Default->"Intensity"],
		ModifyOptions[ListPlot3DOptions,{RegionFunction}],

		(*** Plot Style Options ***)
		ModifyOptions[ListPlotOptions,{Background},Category->"Plot Style"],
		ModifyOptions[ListPlot3DOptions,{BoundaryStyle}],
		ModifyOptions[ListPlotOptions,{ColorFunction,ColorFunctionScaling,Filling,FillingStyle}],
		ModifyOptions[ListPlot3DOptions,{Lighting}],
		ModifyOptions[ListPlotOptions,{PlotStyle}],

		(*** Axes Options ***)
		ModifyOptions[ListPlot3DOptions,{Axes,AxesEdge}],
		ModifyOptions[ListPlotOptions,{AxesOrigin,AxesStyle},Category->"Axes"],

		(*** Box Options ***)
		ModifyOptions[ListPlot3DOptions,{Boxed,BoxRatios,BoxStyle,FaceGrids,FaceGridsStyle}],

		(*** Mesh Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->Mesh,Default->Automatic,Category->"Mesh"},
				{OptionName->MeshFunctions,Default->{#1&,#2&},Category->"Mesh"}
			}
		],
		ModifyOptions[ListPlotOptions,{MeshShading,MeshStyle},Category->"Mesh"],

		(*** 3D View Options ***)
		ModifyOptions[ListPlot3DOptions,{ViewAngle,ViewPoint,ViewProjection,ViewRange,ViewVector,ViewVertical}],

		(*** General Options ***)
		ModifyOptions[SmoothHistogramOptions,{MaxRecursion,PlotPoints,WorkingPrecision}],
		ModifyOptions[ListPlotOptions,{PerformanceGoal,Prolog,Epilog},Category->"General"],

		(*** Hidden Options ***)

		(* Options from ListPlotOptions which should be hidden *)
		ModifyOptions[ListPlotOptions,
			{
				AlignmentPoint,BaselinePosition,BaseStyle,ColorOutput,ContentSelectable,
				CoordinatesToolOptions,DataRange,DisplayFunction,FormatType,
				ImageMargins,ImagePadding,ImageSizeRaw,
				LabelingSize,Method,PlotRangePadding,PlotRegion,
				PlotTheme,PreserveImageOptions,ScalingFunctions,Ticks,TicksStyle
			},
			Category->"Hidden"
		],

		(* Options from ListPlot3DOptions which should be hidden *)
		ModifyOptions[ListPlot3DOptions,
			{
				AutomaticImageSize,AxesUnits,ControllerMethod,ControllerPath,
				NormalsFunction,RotationAction,SphericalRegion,
				TextureCoordinateFunction,TextureCoordinateScaling,TouchscreenAutoZoom,
				ViewCenter,ViewMatrix
			},
			Category->"Hidden"
		],
		ModifyOptions[ListPlot3DOptions,
			{
				{OptionName->ControllerLinking,Default->All}
			}
		],

		(* Output option for command builder *)
		OutputOption
	}
];


EmeraldSmoothHistogram3D[in_,ops:OptionsPattern[EmeraldSmoothHistogram3D]]:=Module[
	{
		plotType,originalOps,safeOps,output,plot,internalMMPlotOps,
		resolvedOps,unresolveableOps,optionsRule,finalPlot,distributionFunction,
		plotIn, dimensionsLength, qaUnits, qaMags
	},

	(* Set the plot type for internal resolutions *)
	plotType=SmoothHistogram3D;

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[EmeraldSmoothHistogram3D,checkForNullOptions[originalOps]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* EmeraldHistogram3D calls MM's Histogram3D directly *)
	internalMMPlotOps=FilterRules[safeOps,Options[plotType]]/.{
		(* Workaround for weird handling of the PlotTheme option under the hood in MM *)
		RuleDelayed[PlotTheme,$PlotTheme]->Rule[PlotTheme,Automatic]
	};

	(* The distribution function to use for the histogram *)
	distributionFunction=Lookup[safeOps,DistributionFunction];
	
	(* in MM 1331, SmoothHistorgram3D issues a warning about incompatible units in a QA even if they are on different axes *)
	plotIn = If[$VersionNumber > 13.2 && QuantityArrayQ[in],
		
		(*
			if the input is a quantity array we need to pull out the units and convert them to a list of quantities,
		 	otherwise MM will not run SmoothHistogram3D
		*)
		dimensionsLength = Length[Dimensions[in]];
		qaUnits = Map[ToString, QuantityUnit[in], {dimensionsLength}];
		qaMags = QuantityMagnitude[in];
		MapThread[Quantity[#1, #2] &, {qaMags, qaUnits}, dimensionsLength],
		
		in
	];

	(* Generate the plot *)
	(** TODO: The third place is the estimator that can take bandwidth and {bandwidth,kernel} **)
	plot=If[$VersionNumber > 13.2,
		(*
			Quiet incompatible units errors which are a bug.
			If one axis is Meters and the other is Seconds an error is thrown, 
   			even though that is valid for two independent variables
		*)
		Quiet[
			plotType[plotIn,Automatic,distributionFunction,internalMMPlotOps],
			{Quantity::compat, Quantity::unkunit}
		],
		
		plotType[plotIn,Automatic,distributionFunction,internalMMPlotOps]
	];

	(* Use the ResolvedPlotOptions helper to extract resolved options from the MM Plot (e.g. PlotRange) *)
	resolvedOps=ReplaceRule[resolvedPlotOptions[plot,internalMMPlotOps,plotType],{DistributionFunction->distributionFunction}]/.{
		(* TargetUnits doesn't have an effect in histogram because the output is a unitless count. Unit conversions are handled in SmoothHistogram3D. *)
		Rule[TargetUnits,Automatic]->Rule[TargetUnits,Null]
	};

	(* Check that all options have been resolved *)
	unresolveableOps=Select[resolvedOps,MatchQ[Last[#],Automatic]&];

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
