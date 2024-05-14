(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*PlotImage Messages*)


Error::MixedMeasurementLineDimensions="The provided MeasurementLine coordinates have inconsistent dimensions (`1`). Please ensure that all MeasurementLine points are either unitless or of the same dimension.";
Warning::UnusedPlotImageOption="The options, `1`, are not used in PlotImage when plotting images.";

(* ::Subsection:: *)
(*PlotImage*)


(* ::Subsubsection:: *)
(*PlotImage*)


DefineOptions[PlotImage,

	Options :> {

		(* Additional options to be inherited from the ListPlotOptions shared option set, without modification *)
		ModifyOptions[ListPlotOptions,
			{
				{
				OptionName->TargetUnits,
				Description->"The units to use for the frame rulers.",
				Default->Automatic,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives@@Join[Automatic,UnitsP[Pixel],DistanceUnits]],
					Widget[
						Type->Expression,
						Pattern:>ListableP[(UnitsP[Meter]|UnitsP[Pixel]|Automatic),2],
						Size->Line]
				],
				Category->"Plot Labeling"

				},
				{
				OptionName->AspectRatio,
				Default->Automatic
				}
			}
		],
		
		(* InteractiveImageOptions *)
		InteractiveImageOptions,

		(* Image Options *)
		ImageOptions,

		(* Output option *)
		OutputOption

	},
	SharedOptions:>{

		(* Standard Graphics options to be inherited from the ListPlotOptions shared option set, without modification *)
		{EmeraldListLinePlot,
			{AlignmentPoint,Axes,AxesLabel,AxesOrigin,AxesStyle,Background,BaselinePosition,
			BaseStyle,ColorOutput,ContentSelectable,CoordinatesToolOptions,DisplayFunction,Epilog,FormatType,
			FrameStyle,ImageMargins,ImagePadding,ImageSize,ImageSizeRaw,LabelStyle,Method,PlotLabel,
			PlotRangePadding,PlotRegion,PreserveImageOptions,Prolog,RotateLabel,Ticks,TicksStyle,PlotRange}
		}
	}
];



(* ::Text:: *)
(*Given list of images, overlay them*)


oneImageInputP = Alternatives[
	_Image,
	_Graphics,
	EmeraldCloudFileP,
	ObjectP[{Object[Data, Microscope], Object[Data, PAGE], Object[Data, Appearance], Object[EmeraldCloudFile], Model[Container]}]
];

oneImageInputPNewZoomable = Alternatives[
	_Graphics,
	EmeraldCloudFileP,
	ObjectP[{Object[Data, Microscope], Object[Data, PAGE], Object[Data, Appearance], Object[EmeraldCloudFile], Model[Container]}]
];

(* Match on list of images even if ECL`$CCD is true and oneImageInputP does not have _Image *)
PlotImage[inputList:{oneImageInputP..},ops:OptionsPattern[]]/;Not[ECL`$CCD]:=Module[{imgList,img,scaleRule},
	(* If $CCD is False this will convert images to graphics, otherwise they will stay images *)
	imgList = Map[getImageFromInput,inputList];
	img=Fold[ImageCompose[#1,{#2,0.5}]&,First[imgList],Rest[imgList]];
	scaleRule = If[OptionValue[Scale]===Automatic,
		Scale->getScaleFromInput[First[inputList]],
		Scale->OptionValue[Scale]
	];
	PlotImage[img,Sequence@@ReplaceRule[ToList[ops],scaleRule]]
];

PlotImage[inputList:{oneImageInputPNewZoomable..}|{_Image..},ops:OptionsPattern[]]/;ECL`$CCD:=Module[{imgList,img,scaleRule},
	(* If $CCD is False this will convert images to graphics, otherwise they will stay images *)
	imgList = Map[getImageFromInput,inputList];
	img=Fold[ImageCompose[#1,{#2,0.5}]&,First[imgList],Rest[imgList]];
	scaleRule = If[OptionValue[Scale]===Automatic,
		Scale->getScaleFromInput[First[inputList]],
		Scale->OptionValue[Scale]
	];
	PlotImage[img,Sequence@@ReplaceRule[ToList[ops],scaleRule]]
];



(* ::Text:: *)
(*Given one non-_Graphics thing, put it in a list and call overlay definition*)


PlotImage[in:Except[_Graphics,oneImageInputP],ops:OptionsPattern[]]/;Not[ECL`$CCD]:=PlotImage[{in},ops];
PlotImage[in:Except[_Graphics,oneImageInputPNewZoomable],ops:OptionsPattern[]]/;ECL`$CCD:=PlotImage[{in},ops];


(* ::Text:: *)

(* Base definition for InteractiveImage *)
PlotImage[img_Image,ops:OptionsPattern[]]/;ECL`$CCD := Module[
	{
		unresolvedOptions, safeOps, unresolvedOptionKeys, ignoredInteractiveImageOptions,
		unusedOptions, contentSize, plotRange, scale, targetUnits, epilog, output, frameLabel,
		scrollZoom, preserveAspectRatio, autoDownsampling, interactiveImageOptions,
		interactiveImage, title, background
	},
	
	(* convert input options to a list *)
	unresolvedOptions = ToList[ops];
	
	(* Extract safe options *)
	safeOps = SafeOptions[PlotImage, ToList[ops]];
	
	(* pull out the keys *)
	unresolvedOptionKeys = Keys[unresolvedOptions];
	
	(* ignored options *)
	ignoredInteractiveImageOptions = {
		AlignmentPoint, AspectRatio, Axes, AxesOrigin, AxesLabel, AxesStyle,
		BaselinePosition, BaseStyle, ColorOutput, ContentSelectable,
		CoordinatesToolOptions, DisplayFunction, FormatType, ImageMargins,
		ImagePadding, ImageSizeRaw, LabelStyle, MeasurementLabel,
		MeasurementLines, Method, PlotRangePadding, PlotRegion,
		PreserveImageOptions, Prolog, RulerType, Ticks, TicksStyle
	};
	
	(* Find Intersection with the list that we are ignoring *)
	unusedOptions = Intersection[unresolvedOptionKeys, ignoredInteractiveImageOptions];
	
	(* Write a warning that those messages are ignored *)
	(* If[Length[unusedOptions] > 0,
		Message[Warning::UnusedPlotImageOption, unusedOptions]
	]; *)
	
	
	(* Pull used options out of safeops *)
	{
		contentSize, plotRange, scale, targetUnits, epilog, output, frameLabel,
		scrollZoom, preserveAspectRatio, autoDownsampling, title, background
	} = Lookup[safeOps,
		{
			ImageSize, PlotRange, Scale, TargetUnits, Epilog, Output, FrameLabel,
			ScrollZoom, PreserveAspectRatio, AutoDownsampling, PlotLabel, Background
		}
	];
	
	(* resolve scale and targetUnits simultaneously *)
	scale = resolveScale[scale, targetUnits];
	
	(* Combine options that will be passed to interactive image. Most options are ignored *)
	interactiveImageOptions = {
		ContentSize -> contentSize/.{Small -> 200, Medium-> 400, Large -> 600},
		PlotRange -> plotRange,
		ImageScale -> scale,
		FrameLabel -> frameLabel,
		ZoomMethod -> scrollZoom/.{True->{"Scroll", "Click"}, False->{"Click"}},
		PreserveAspectRatio -> preserveAspectRatio,
		AutoDownsampling -> autoDownsampling,
		Background -> background/.None->RGBColor[1,1,1],
		Title -> title
	};
	
	(* Not sure why all the context is needed *)
	(* Epilog is passed as the second argument, not as an option *)
	interactiveImage = ECL`SciCompFramework`InteractiveImage[img, Graphics[epilog],
		interactiveImageOptions
	];
	
	(* Return the requested results *)
	output/.{
		Result->interactiveImage,
		Preview -> interactiveImage,
		Options -> safeOps,
		Tests -> {}
	}
	
];

(* scale and target units resolver into scale *)
resolveScale[scale:UnitsP[Meter], Automatic]:=scale/Pixel;
resolveScale[scale:UnitsP[1/Meter], Automatic]:=Pixel*scale;
resolveScale[scale:UnitsP[Pixel/Meter], Automatic]:=scale;
resolveScale[scale:UnitsP[Meter/Pixel], Automatic]:=scale;
resolveScale[scale:UnitsP[Meter], units:UnitsP[Meter]]:=UnitConvert[scale, units]/Pixel;
resolveScale[scale:UnitsP[1/Meter], units:UnitsP[Meter]]:=Pixel*UnitConvert[scale, 1/units];
resolveScale[scale:UnitsP[Pixel/Meter], units:UnitsP[Meter]]:=UnitConvert[scale, Pixel/units];
resolveScale[scale:UnitsP[Meter/Pixel], units:UnitsP[Meter]]:=UnitConvert[scale, units/Pixel];
resolveScale[_, _]:=None;


(*Base definition, given Graphics*)
PlotImage[graph_Graphics,ops:OptionsPattern[]]/;ECL`$CCD:=PlotImage[Rasterize[graph], ops];
PlotImage[graph_Graphics,ops:OptionsPattern[]]:=Module[
	{safeOps,output,finalPlot,resolveOps,resolvedOps,measurementLines,
	originalOptions,originalPlotRange,originalFrameTicks,makePlotImageFrameLabel,
	resolvedScales,resolvedFrame,resolvedRulerType,  makePlotImageFrameTicks, resolvedUnits, 
	imgDims, graphicsOps, lines, label, plotImageFrameFromPosition,listedOps},

	listedOps = ToList[ops];

	(* log the names of any explicitly specified options *)
	ECL`Web`TagTrace[
		"sll.options.unresolved.names", 
		ToString[Keys[listedOps],InputForm]
	];

	(* Extract safe options *)
	safeOps = SafeOptions[PlotImage, listedOps];

	(* Check that MeasurementLines unit dimensions are compatible, throwing an error if they are not *)
	measurementLines=ToList@Lookup[safeOps,MeasurementLines];
	If[
		CountDistinct@UnitDimension[Flatten[measurementLines]]>1,
		Message[Error::MixedMeasurementLineDimensions,UnitDimension[Flatten[measurementLines]]];
		Message[Error::InvalidOption,MeasurementLines];
		Return[$Failed]
	];

	(* Extract the graphics original options *)
	originalOptions=Sequence@@Options[graph];

	(* resolve PlotRange *)
	originalPlotRange=Which[
		NullQ[Lookup[ToList@ops,PlotRange,Null]], PlotRange/.Options[graph,PlotRange],
		MatchQ[Lookup[safeOps,PlotRange], Automatic], {0,#}&/@ImageDimensions[graph],
		True, Lookup[safeOps,PlotRange]
	];

	(* Extract FrameTicks from the original graphics *)
	originalFrameTicks=FrameTicks/.Options[graph,FrameTicks];

	(* Resolve initial Graphics options  *)
	{resolvedScales,resolvedUnits} = resolveFrameRulerScalesWithTargetUnits[Lookup[safeOps,Scale],Lookup[safeOps,TargetUnits],ImageDimensions[graph]];

	resolvedRulerType = Lookup[safeOps,RulerType];
	

	plotImageFrameFromPosition = Function[val,Module[{specifiedRules, rulesWithDefault},
			(* turn on any requested frames *)
			specifiedRules = Thread[Rule[Flatten[{val}],True]];
			(* anything else will be off *)
			rulesWithDefault = Append[specifiedRules,_Symbol->False];
			Replace[{{Left,Right},{Bottom,Top}} , rulesWithDefault ,{2} 
		]]];

	resolvedFrame = plotImageFrameFromPosition[Flatten[{Lookup[safeOps,RulerPlacement]}]];

	(* these are pure functions to guarantee their values make it into the dynamic plot *)
	makePlotImageFrameLabel = With[
		{
			(* strip off independent unit so things look pretty *)
			ru = ReplaceAll[resolvedUnits, IndependentUnit[u_]:>u],
			style = Sequence[Black,Bold,13]	
		},
		(* style everything at level 2 *)
		Function[{range,frame,scales},  
			Map[Style[#,style]&,  ru,	{2} ]
		]
	];


	makePlotImageFrameTicks = Function[{bounds, scales, rulerType},Module[{
				xm, xM, ym, yM, defaultTicksX, defaultTicksY, adjustTickLabel, plotForTicks	
			},
		
			(* min and max for x and y *)
			{{xm,xM},{ym,yM}} = bounds;
			(* if Relative ticks, zooming updates the ticks to always start at zero *)
			adjustTickLabel[ tick:{ val_, tickLabel_, rest___ }, Absolute, min_] := tick; (* if Absolute ticks, do nothing *)
			adjustTickLabel[ tick:{ val_, "", rest___ }, Relative, min_] := tick; (* if no label present, do nothing *)
			adjustTickLabel[ tick:{ val_, tickLabel_, rest___ }, Relative, min_] := { val, val-min, rest};  (* rescale the label based on the relative zero *)
			
			(* make a "plot" with just the extreme points from the data, and let mathematica generate ticks for us*)
			plotForTicks = Graphics[ Map[Point,Transpose@bounds], Axes->True ];
			(* get the ticks from the plot.  we will reuse these tick values.  *)
			(* Note: AbsoluteOptions is weird and breaks if you try to use FrameTicks instead of just Ticks *)
			{defaultTicksX,defaultTicksY} = Lookup[ AbsoluteOptions[plotForTicks, Ticks], Ticks];
			{ 
			(* adjust the tick labels if necessary *)
			(* we do left/right and top/bottom separately because they can be different (e.g. left is Inches right is Centimeters) *)
				{
					 Map[adjustTickLabel[#,rulerType,ym*scales[[2,1]]]&,defaultTicksY],  (* left *)
					 Map[adjustTickLabel[#,rulerType,ym*scales[[2,2]]]&,defaultTicksY]  (* right *)
				}, 
				{
					 Map[adjustTickLabel[#,rulerType,xm*scales[[1,1]]]&,defaultTicksX], (* bottom *)
					 Map[adjustTickLabel[#,rulerType,xm*scales[[1,2]]]&,defaultTicksX] (* top *)
				} 
			}

		]
	];

	(* Define helper function that assembles resolved options for a specified PlotRange *)
	resolveOps[plotRange_]:=ReplaceRule[safeOps,{
		PlotRange->plotRange,
		Frame->resolvedFrame,
		FrameTicks -> makePlotImageFrameTicks[plotRange,resolvedScales,resolvedRulerType],
		FrameLabel->makePlotImageFrameLabel[plotRange,resolvedFrame,resolvedScales],
		PlotRangeClipping->True,
		FrameTicksStyle->Directive[Black,Bold,11],
		ImageSize->OptionValue[ImageSize],
		originalOptions
		}
	];

	(* Compute inital (static) resolved options *)
	resolvedOps=resolveOps[originalPlotRange];

	(* Extract graphics image dimensions *)
	imgDims=ImageDimensions[graph];

	(* Extract static resolved graphics options *)
	graphicsOps=KeyValueMap[Rule,KeyDrop[ToList@PassOptions[Graphics,resolvedOps],{PlotRange,FrameTicks,FrameLabel}]];

	(* Extract measurement lines and label *)
	lines=Lookup[safeOps,MeasurementLines];
	label=Lookup[safeOps,MeasurementLabel];


	finalPlot=dynamicImagePlot[originalPlotRange, graph, resolvedScales,
		label, resolvedFrame, resolvedRulerType, graphicsOps, imgDims, lines,
		makePlotImageFrameLabel, makePlotImageFrameTicks
	 ];

	(* Extract output *)
	output = Lookup[safeOps, Output];

	(* Return the result, according to the output option. *)
	output/.{
		Result->finalPlot,
		Preview->finalPlot,
		Tests->{},

		(* Exclude dynamically defined options as they are not user-specified *)
		Options -> Normal[KeyDrop[
				resolveOps[originalPlotRange],
			(*FrameLabel is exempted here in order to pass a test function in PlotMicroscopeOverlay*)
				{Frame,FrameTicks,FrameTicksStyle,PlotRangeClipping}
			]]

	}
];

	(* Dynamic Module for the Plot Dragging. NOTE: The first two entries in module variables must be PlotRange and FrameTicks for Unzoomable to work. *)
dynamicImagePlot[defaultPlotRange_, graph_, scales_, label_, frame_, rulerType_, graphicsOps_, 
	imgDims_, lines_, makePlotImageFrameLabel_, makePlotImageFrameTicks_]:= DynamicModule[
		{
			range=defaultPlotRange,
			dragging=False,
			(*Need to initialize 'first' and 'second' with values to avoid pink boxes*)
			first={0.,0.},second={0.,0.},firstCtrol,newSecond,
			pointPairs, (* { {ptA1, ptA2}, {ptB1,ptB2}, ...}  -- each pair reprents the end of a ruler line, and each point is a coordinate, e.g. ptA1 = {xA1,yA1} *)
			indxy,closestIndex,ptSize, findClosestPoint, 
			dragging2=False, resolveOneMeasurementLine, unitsP,  
			controlKeyDownQ,leftButtonDownAction,leftButtonDragAction,leftButtonUpAction,rightButtonClickAction,
			closestMeasurementTool, closestMeasurementToolPoint, addMeasurementPair,
			removeMeasurementPair, updateMeasurementLine, drawRulers, drawOneRuler, resolveMeasurementLineOption
		},

		(* can't use UnitsP -- no emerald stuff allowed in here *)
		unitsP = _?NumericQ|_Quantity;
		resolveMeasurementLineOption[vals_,scale_] := Map[ resolveOneMeasurementLine[#,scale]&, vals];
		(* if no units, leave the points alone *)
		resolveOneMeasurementLine[val:{ {_?NumericQ,_?NumericQ}, un:{_?NumericQ,_?NumericQ} },scale_] := val;
		(* if there are units, scale by 'scale' *)
		resolveOneMeasurementLine[val:{ {unitsP,unitsP}, {unitsP,unitsP} },scale_]:= val / scale;

		(* given list of points and target point, find point in list that's closest to target *)
		findClosestPoint[targetPoint_,testPointList_] := First[ 
			MinimalBy[testPointList, EuclideanDistance[#,targetPoint]&, UpTo[1] ], 
			Null 
		];
		

		(* find the INDEX of the closest measurement line, based on distance from the click to all the end points *)
		closestMeasurementTool[targetPoint_, testPointList_]:=Module[{closestEndPoint},
			(* find closest end point of all lines, then figure out which line it came from *)
			closestEndPoint = findClosestPoint[targetPoint,Flatten[testPointList,1]];
			(* find the top level position of the end point in the pairs list *)
			First[FirstPosition[ testPointList, closestEndPoint, Null ], Null]
		];

		(* given the closest line, find the INDEX of which endpoint we are closer to (result will be 1 or 2) *)
		closestMeasurementToolPoint[testPoint_, {endPointA_, endPointB_}]:=Module[{},
			If[
				(* if we're closer to the first end point, return 1*)
				EuclideanDistance[testPoint,endPointA] < EuclideanDistance[testPoint, endPointB],
					1,
				(* else closer to second end point*)
					2
			]
		];
		
		
		(* randomly place two points on the image and add that new pair to the list of measurementLines *)
		addMeasurementPair[range:{{xa_,xb_},{ya_,yb_}},pos_]:=Append[pointPairs,{
			pos,
			{
				RandomReal[{0.7,0.8}]*(xa-xb)+xb,
				RandomReal[{0.45,0.55}]*(ya-yb)+yb
			}
		} ];


		(* remove the closest set of points from the endpoint list *)
		removeMeasurementPair[pos_]:=If[pointPairs==={}, {}, Delete[pointPairs,closestIndex]];

		(* update the value of a saved endpoint *)
		updateMeasurementLine[pos_]:=Which[
			MatchQ[closestIndex,Null], pointPairs,
			MatchQ[indxy,Null], pointPairs,
			True, ReplacePart[pointPairs, {closestIndex,indxy} -> pos]
		];

		(* make epilogs for the measurement lines -- a line with dots at the ends *)
		drawRulers[]:=Map[drawOneRuler[#]&,pointPairs];
		drawOneRuler[endPoints:{ptA_,ptB_}]:=With[
			(* length of line, used for label *)
			{dist=N@(EuclideanDistance@@endPoints)*scales[[1,1]]},
			{
				(* the end dots *)
				{Red,Disk[ptA,ptSize],Disk[ptB,ptSize]},
			{
				Red,
				Thick,
				(* the line, with label positioned in the middle *)
				If[label,
					{Line[endPoints],Text[Row[{" ",NumberForm[dist,3]," "}],Mean[endPoints],Background->White]},
					Tooltip[Line[endPoints],dist]
				]
			}
		}];


		(* Q function that returns True if Control key is pressed in Windows, or Command key is pressed in OSX *)
		controlKeyDownQ[]:=Switch[
			$OperatingSystem,
			"MacOSX",CurrentValue["CommandKey"],
			_,CurrentValue["ControlKey"]
		];

		ptSize = Mean[range.{-1,1}]/100.;
		pointPairs = resolveMeasurementLineOption[lines,scales[[1,1]]];

		(* Draw zoom rectangle *)
		leftButtonDragAction[ctrl:False,safePos_]:=(
			dragging=True;
			newSecond=MousePosition["Graphics"];
			If[MatchQ[newSecond,None],
				dragging=False;,
				second=newSecond;
			]
		);
		(* zoom by changing plot range *)
		leftButtonUpAction[ctrl:False,drag:True,safePos_]:=(
			dragging=False;
			range=Map[Sort,Transpose[{first,second}]];
			ptSize = Mean[range.{-1,1}]/100.;
			first={0.,0.};second={0.,0.};
		);

		(* Reset zoom *)
		leftButtonDownAction[ctrl:False,safePos_]:=(first=safePos;second=safePos);
		leftButtonUpAction[ctrl:False,drag:False,safePos_]:=(
			range=defaultPlotRange;
			ptSize = Mean[range.{-1,1}]/100.;
			first={0.,0.};second={0.,0.};
		);

		(* Add measurement line *)
		leftButtonDownAction[ctrl:True,safePos_]:=(
			closestIndex=closestMeasurementTool[safePos, pointPairs];
			indxy=If[closestIndex===Null,
				Null,
				closestMeasurementToolPoint[safePos, pointPairs[[closestIndex]]]
			];
		);
		leftButtonUpAction[ctrl:True,drag:False,safePos_]:=(
			pointPairs=addMeasurementPair[range,safePos];
			first={0.,0.};second={0.,0.};
		);

		(* Reposition measurement line *)
		leftButtonDragAction[ctrl:True,safePos_]:=(
			dragging=True;
			pointPairs=updateMeasurementLine[safePos]
		);
		leftButtonUpAction[ctrl:True,drag:True,safePos_]:=(
			dragging=False;
			first={0.,0.};second={0.,0.};
		);

		(* Remove measurement line *)
		rightButtonClickAction[ctrl:True,safePos_]:=(
				dragging=False;
				closestIndex=closestMeasurementTool[safePos, pointPairs];
				pointPairs=removeMeasurementPair[safePos];
		);
	

		(* Start event handler *)
		EventHandler[
			Dynamic[
				Graphics[
					{
						{	(*Main image*)
							First@graph,
							(*The zoom-rectangle shown upon click-drag-release*)
							{Opacity[0.25],
								EdgeForm[{Thin,Dashing[Small],Opacity[0.5]}],
								FaceForm[RGBColor[0.89013625`,0.8298584999999999`,0.762465`]],
								Rectangle[first,second]
							}
						},
						drawRulers[]
					},
					PlotRange->range,
					FrameTicks -> makePlotImageFrameTicks[range,scales,rulerType],
					FrameLabel->makePlotImageFrameLabel[range,frame,scales],
					graphicsOps
				]
			],
			{
				{"MouseDown",1}:>leftButtonDownAction[controlKeyDownQ[],Replace[MousePosition["Graphics"],None->first]],
				{"MouseDragged",1}:>leftButtonDragAction[controlKeyDownQ[],Replace[MousePosition["Graphics"],None->first]],
				{"MouseUp",1}:>leftButtonUpAction[controlKeyDownQ[],dragging,Replace[MousePosition["Graphics"],None->first]],
				{"MouseClicked",2}:>rightButtonClickAction[controlKeyDownQ[],Replace[MousePosition["Graphics"],None->first]]
			}
		]
	]






resolveFrameRulerScalesWithTargetUnits[scale0_,targetUnit0_,imgDims_]:=Module[{scales,units,vals},
	scales = resolveFrameRulerScales[scale0];
	units = resolveFrameRulerScales[targetUnit0];
	vals = MapThread[resolveOneFrameRulerScaleWithTargetUnit[#1,#2]&,{scales,units},2];
	{
		Unitless@vals,
		Map[QuantityUnit,vals,{2}]
	}
];

resolveOneFrameRulerScaleWithTargetUnit[scale:Automatic,unit:Automatic]:= Pixel;
resolveOneFrameRulerScaleWithTargetUnit[scale:UnitsP[1/Meter],unit:Automatic]:= 1/scale;
resolveOneFrameRulerScaleWithTargetUnit[scale:UnitsP[Meter],unit:Automatic]:= scale;
resolveOneFrameRulerScaleWithTargetUnit[scale_?NumericQ,unit:Automatic]:= scale;
resolveOneFrameRulerScaleWithTargetUnit[scale_,unit:UnitsP[Pixel]]:= Pixel;
resolveOneFrameRulerScaleWithTargetUnit[scale_,unit_]:= Convert[scale,unit];


resolveFrameRulerScales[val:(Automatic|UnitsP[])]:=resolveFrameRulerScales[{{val,val},{val,val}}];
resolveFrameRulerScales[{valA:(UnitsP[]|Automatic),valB:(UnitsP[]|Automatic)}] := resolveFrameRulerScales[{{valA,valA},{valB,valB}}];
resolveFrameRulerScales[vals:{{(UnitsP[]|Automatic),(UnitsP[]|Automatic)},{(UnitsP[]|Automatic),(UnitsP[]|Automatic)}}]:=Map[resolveOneFrameRulerScale,vals,{2}];

resolveOneFrameRulerScale[Automatic]:=Automatic; (* leave unresolved, will get handled later by Scale unit *)
resolveOneFrameRulerScale[val:UnitsP[1/Meter]]:= 1 / val;
resolveOneFrameRulerScale[val:UnitsP[Meter]]:= val;
resolveOneFrameRulerScale[val:UnitsP[Pixel]]:= val;
resolveOneFrameRulerScale[val_?NumericQ]:= val;
resolveOneFrameRulerScale[val:UnitsP[Pixel/Meter]]:= Pixel / val;
resolveOneFrameRulerScale[val:UnitsP[Meter/Pixel]]:= Pixel * val;




(* ::Subsubsection::Closed:: *)
(*getImageFromInput*)

(* if using $CCD, rasterize the image, otherwise work with the show *)
getImageFromInput[g_Graphics]:=g;
getImageFromInput[g_Graphics]/;ECL`$CCD:=Rasterize[g];
(* if using $CCD, return the image, otherwise convert to Grpahic with Show *)
getImageFromInput[img_Image]/;ECL`$CCD:=img;
getImageFromInput[img_Image]:=Show[img];
getImageFromInput[cloudFile_EmeraldCloudFile]:=getImageFromInput[ImportCloudFile[cloudFile]];
getImageFromInput[cloudFile:ObjectP[Object[EmeraldCloudFile]]]:=getImageFromInput[ImportCloudFile[cloudFile]];
getImageFromInput[obj:ObjectP[Object[Data,Microscope]]]:=getImageFromInput[obj[PhaseContrastImage]];
getImageFromInput[obj:ObjectP[Object[Data,PAGE]]]:=getImageFromInput[obj[OptimalGelImage]];
getImageFromInput[obj:ObjectP[Object[Data,Appearance]]]:=getImageFromInput[obj[Image]];
getImageFromInput[obj:ObjectP[Model[Container]]] := getImageFromInput[obj[ImageFile]];


(* ::Subsubsection::Closed:: *)
(*getScaleFromInput*)


getScaleFromInput[obj:ObjectP[{Object[Data,PAGE],Object[Data,Microscope],Object[Data,Appearance]}]]:=If[NullQ[obj[Scale]],Automatic,obj[Scale]];
getScaleFromInput[obj:ObjectP[Model[Container]]] := If[NullQ[obj[ImageFileScale]],Automatic,obj[ImageFileScale]];
getScaleFromInput[other_]:=Automatic;


(* ::Subsection::Closed:: *)
(*PlotImageOptions*)


DefineOptions[PlotImageOptions,
	SharedOptions :> {PlotImage}
];

PlotImageOptions[myInput_,myOps:OptionsPattern[]]:=PlotImage[myInput,myOps,Output->Options];


(* ::Subsection::Closed:: *)
(*PlotImagePreview*)


DefineOptions[PlotImagePreview,
	SharedOptions :> {PlotImage}
];

PlotImagePreview[myInput_,myOps:OptionsPattern[]]:=PlotImage[myInput,myOps,Output->Preview];


(* ::Section:: *)
(*End*)


plotImageP = _?plotImageQ

plotImageQ[in_]/;ECL`$CCD:= ValidGraphicsQ[in];
plotImageQ[in_]:= ValidGraphicsQ[Staticize[in]];
