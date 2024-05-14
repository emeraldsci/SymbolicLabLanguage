(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldListPlot3D*)

(*
NOTE:Options that are available in ListPlot3D but don't seem to be useful for EmeraldListPlot3D:
	ListPlot:
	ColorFunctionScaling,DataRange,ColorOutput,ContentSelectable,CoordinatesToolOptions,ImagePadding,
	ImageSizeRaw,Method,PreserveImageOptions,AlignmentPoint,BaselinePosition

	ListPlot3D:
	AutomaticImageSize,ControllerLinking, ControllerMethod,ControllerPath,SphericalRegion,
	TextureCoordinateFunction,TextureCoordinateScaling,TouchscreenAutoZoom,ViewCenter,ViewMatrix
*)


DefineOptions[EmeraldListPlot3D,
	Options:>	{

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
		ModifyOptions[ListPlotOptions,{PlotLabel},Category->"Plot Labeling"],
		ModifyOptions[ListPlot3DOptions,{AxesLabel}],
		ModifyOptions[ListPlotOptions,{LabelStyle}],

		(*** Legend Options ***)
		ModifyOptions[ListPlotOptions,{PlotLegends},Category->"Legend"],

		(*** Data Specification options ***)
		ModifyOptions[ListPlot3DOptions,{ClipPlanes,ClipPlanesStyle,RegionFunction,TargetUnits}],

		(*** Plot Style Options ***)
		ModifyOptions[ListPlotOptions,{Background},Category->"Plot Style"],
		ModifyOptions[ListPlot3DOptions,{BoundaryStyle}],
		ModifyOptions[ListPlotOptions,{ColorFunction,Filling,FillingStyle,InterpolationOrder}],
		ModifyOptions[ListPlotOptions,{PlotStyle}],
		{
			OptionName->ShowPoints,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Show the data points over the mesh.",
			Category->"Plot Style"
		},

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
		ModifyOptions[ListPlotOptions,{MeshShading,MeshStyle,MaxPlotPoints},Category->"Mesh"],

		(*** 3D View Options ***)
		ModifyOptions[ListPlot3DOptions,{ViewAngle,ViewPoint,ViewProjection,ViewRange,ViewVector,ViewVertical}],

		(*** General Options ***)
		ModifyOptions[ListPlotOptions,{PerformanceGoal,Prolog,Epilog},Category->"General"],

		(*** Hidden Options ***)

		(* Options from ListPlotOptions which should be hidden *)
		ModifyOptions[ListPlotOptions,
			{
				AlignmentPoint,BaselinePosition,BaseStyle,ColorFunctionScaling,ColorOutput,ContentSelectable,
				CoordinatesToolOptions,DataRange,DisplayFunction,FormatType,
				ImageMargins,ImagePadding,ImageSizeRaw,
				LabelingSize,Method,PlotLabels,PlotRangePadding,PlotRegion,
				PlotTheme,PreserveImageOptions,ScalingFunctions,Ticks,TicksStyle
			},
			Category->"Hidden"
		],

		(* Options from ListPlot3DOptions which should be hidden *)
		ModifyOptions[ListPlot3DOptions,
			{
				AutomaticImageSize,AxesUnits,ControllerLinking,ControllerMethod,ControllerPath,
				Lighting,NormalsFunction,RotationAction,SphericalRegion,
				TextureCoordinateFunction,TextureCoordinateScaling,TouchscreenAutoZoom,
				VertexColors,VertexNormals,ViewCenter,ViewMatrix
			},
			Category->"Hidden"
		],

		(* Output option for command builder *)
		OutputOption
	}
];


EmeraldListPlot3D[in:ListableP[nullComplexQuantity3DP],ops: OptionsPattern[EmeraldListPlot3D]]:=Catch[Module[
	{
		resolvedOps, primaryDataFull, numObjects, numPrimaryPer, primarDataFullUnitless, primaryTargetUnits,fig,
		colors,pointFig,internalMMPlotOps,mostlyResolvedOps,finalFigure,unresolveableOps,optionsRule,originalOps,
		safeOps,output
	},

	(* Convert the original options into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[EmeraldListPlot3D,checkForNullOptions[originalOps]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* Filter options for the internal call to ListPlot3D, replacing options with our resolved values. *)
	internalMMPlotOps = If[MatchQ[in,nullComplexQuantity3DP],
		resolveListPlot3DOptions[in,ToList[ops]],
		resolveListPlot3DOptions[in[[1]],ToList[ops]]
	];

	primaryTargetUnits = Lookup[internalMMPlotOps,TargetUnits];

	(* Convert the data if primaryTargetUnits is not Null and look for unit compatibility problems *)
	primarDataFullUnitless = Check[
		If[MatchQ[primaryTargetUnits,Null],
			in,
			If[MatchQ[in,nullComplexQuantity3DP],
				Unitless[in, primaryTargetUnits],
				If[MatchQ[#,{{(_?NumericQ|Null),(_?NumericQ|Null),(_?NumericQ|Null)}..}], #, Unitless[#, primaryTargetUnits]] &/@in
			]
		],
		Null,
		{Quantity::compat}
	];

	(* Mostly resolved options to emerald plot function, using ReplaceRule to ensure all options have been kept. *)
	mostlyResolvedOps=ReplaceRule[safeOps,ToList[internalMMPlotOps]];

	(* 3D plot of the primary data using ListPlot3D. Converting options that are converted to Null for CC, back to Automatic when passing to MM functions *)
	fig = If[MatchQ[primarDataFullUnitless,Null],
		Null,
		ListPlot3D[primarDataFullUnitless, PassOptions[EmeraldListPlot3D,ListPlot3D,internalMMPlotOps]]
	];

	(* Adding points if ShowPoints is True *)
	finalFigure=If[And[MatchQ[fig,_Graphics3D],TrueQ[Lookup[mostlyResolvedOps,ShowPoints]]],
		colors = Cases[fig,d:Directive[Specularity[_, _], color_, ___] :> d, Infinity];
		pointFig = ListPointPlot3D[primarDataFullUnitless,PlotStyle->colors];
		If[MatchQ[pointFig,_Graphics3D],
			Show[fig,pointFig],
			fig
		],
		fig
	];

	(*
		Resolving MM options using the output figure and AbsoluteOptions
	*)

	(* Finding the mathematica's resolved options and using them instead of unresolved ones in partiallyResolvedOptions *)
	resolvedOps=resolvedPlotOptions[fig,mostlyResolvedOps,ListPlot3D];

	(* Check that all options have been resolved *)
	unresolveableOps=Select[resolvedOps,!FreeQ[#,Automatic]&];

	(* Warning message if any of the resolved options are either Automatic or contain Automatic *)
	(* If[Length[unresolveableOps]>0,
		Message[Warning::UnresolvedPlotOps,First/@unresolveableOps];
	]; *)

	(* Generate the options rule for output*)
	optionsRule=If[MemberQ[ToList[output],Options],
		Options->resolvedOps,
		Options->Null
	];

	(* Return the requested outputs *)
	output/.{
		Result->finalFigure,
		optionsRule,
		Preview->finalFigure/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Tests->{}
	}

]];

resolveListPlot3DOptions[primaryDataToPlot_,unresolvedOps_List]:=Module[
	{safeOps, unitMethod, firstUnit, secondUnit, thirdUnit, axesUnits, firstAxesUnit, secondAxesUnit, thirdAxesUnit, axesLabel, firstAxesLabel, secondAxesLabel, thirdAxesLabel, plotRange, firstRange, secondRange, thirdRange, findUnits, targetUnits},

	safeOps = SafeOptions[EmeraldListPlot3D, unresolvedOps];

	findUnits[dataVector:(_List|_?ArrayQ)]:=Module[{firstNotNull},
		firstNotNull = First[DeleteCases[dataVector, Null]];
		If[MatchQ[firstNotNull,_?QuantityQ], Units[firstNotNull], Null]
	];
	findUnits[fail_]:=Null;

	unitMethod = Lookup[safeOps,TargetUnits,Automatic];
	firstUnit = Switch[unitMethod,
		Automatic, findUnits[primaryDataToPlot[[All,1]]],
		{Automatic, _, _}, findUnits[primaryDataToPlot[[All,1]]],
		{_?UnitsQ, _, _}, unitMethod[[1]]
	];
	secondUnit = Switch[unitMethod,
		Automatic, findUnits[primaryDataToPlot[[All,2]]],
		{_, Automatic, _}, findUnits[primaryDataToPlot[[All,2]]],
		{_, _?UnitsQ, _}, unitMethod[[2]]
	];
	thirdUnit = Switch[unitMethod,
		Automatic, findUnits[primaryDataToPlot[[All,3]]],
		{_, _, Automatic}, findUnits[primaryDataToPlot[[All,3]]],
		{_, _, _?UnitsQ}, unitMethod[[3]]
	];
	targetUnits = If[MatchQ[firstUnit,Null] || MatchQ[secondUnit,Null] || MatchQ[thirdUnit,Null],
		Null,
		{firstUnit, secondUnit, thirdUnit}
	];

	axesUnits = Lookup[safeOps,AxesUnits,Automatic];
	firstAxesUnit = Switch[axesUnits,
		None, None,
		Automatic, If[MatchQ[firstUnit,_?QuantityQ]," " <> ToString[Last[firstUnit]],None],
		{Automatic, _, _}, If[MatchQ[firstUnit,_?QuantityQ]," " <> ToString[Last[firstUnit]],None],
		{_?UnitsQ, _, _}, " " <> ToString[Last[axesUnits[[1]]]],
		{_String, _, _}, axesUnits[[1]],
		_List, axesUnits[[1]],
		_, axesUnits
	];
	secondAxesUnit = Switch[axesUnits,
		None, None,
		Automatic, If[MatchQ[secondUnit,_?QuantityQ]," " <> ToString[Last[secondUnit]],None],
		{_, Automatic, _}, If[MatchQ[secondUnit,_?QuantityQ]," " <> ToString[Last[secondUnit]],None],
		{_, _?UnitsQ, _}, " " <> ToString[Last[axesUnits[[2]]]],
		{_, _String, _}, axesUnits[[2]],
		_List, axesUnits[[2]],
		_, axesUnits
	];
	thirdAxesUnit = Switch[axesUnits,
		None, None,
		Automatic, If[MatchQ[thirdUnit,_?QuantityQ]," " <> ToString[Last[thirdUnit]],None],
		{_, _, Automatic}, If[MatchQ[thirdUnit,_?QuantityQ]," " <> ToString[Last[thirdUnit]],None],
		{_, _, _?UnitsQ}, " " <> ToString[Last[axesUnits[[3]]]],
		{_, _, _String}, axesUnits[[3]],
		_List, axesUnits[[3]],
		_, axesUnits
	];

	axesLabel = Lookup[safeOps,AxesLabel,Automatic];
	firstAxesLabel = Switch[axesLabel,
		None, None,
		{None, _, _}, None,
		Automatic, If[MatchQ[firstAxesUnit,None],None,firstAxesUnit],
		{Automatic, _, _}, If[MatchQ[firstAxesUnit,None],None,firstUnit],
		{_String, _, _}, axesLabel[[1]] <> If[MatchQ[firstAxesUnit,None],"",firstAxesUnit]
	];
	secondAxesLabel = Switch[axesLabel,
		None, None,
		{_, None, _}, None,
		Automatic, If[MatchQ[secondAxesUnit,None],None,secondAxesUnit],
		{_, Automatic, _}, If[MatchQ[secondAxesUnit,None],None,secondAxesUnit],
		{_, _String, _}, axesLabel[[2]] <> If[MatchQ[secondAxesUnit,None],"",secondAxesUnit]
	];
	thirdAxesLabel = Switch[axesLabel,
		None, None,
		{_, _, None}, None,
		Automatic, If[MatchQ[thirdAxesUnit,None],None,thirdAxesUnit],
		{_, _, Automatic}, If[MatchQ[thirdAxesUnit,None],None,thirdAxesUnit],
		{_, _,_String}, axesLabel[[3]] <> If[MatchQ[thirdAxesUnit,None],"",thirdAxesUnit]
	];

	plotRange = Lookup[safeOps,PlotRange,Automatic];
	firstRange = Switch[plotRange,
		{{_?QuantityQ...}, _, _}, Unitless[#,firstUnit] & /@ plotRange[[1]],
		_List, plotRange[[1]],
		_, plotRange
	];
	secondRange = Switch[plotRange,
		{_, {_?QuantityQ...}, _}, Unitless[#,secondUnit] & /@ plotRange[[2]],
		_List, plotRange[[2]],
		_, plotRange
	];
	thirdRange = Switch[plotRange,
		{_, _, {_?QuantityQ...}}, Unitless[#,thirdUnit] & /@ plotRange[[3]],
		_List, plotRange[[3]],
		_, plotRange
	];

	ReplaceRule[safeOps,
		{
			TargetUnits -> targetUnits,
			AxesLabel -> {firstAxesLabel, secondAxesLabel, thirdAxesLabel},
			AxesUnits -> {firstAxesUnit, secondAxesUnit, thirdAxesUnit},
			PlotRange -> {firstRange, secondRange, thirdRange}
		}
	]
];
