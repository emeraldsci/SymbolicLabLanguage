(* ::Subsection:: *)
(*PlotSyringe*)

DefineOptions[PlotSyringe,
	Options :> {
		{
			OptionName -> FieldOfView,
			Description -> "Indicates if the whole syringe should be displayed or just the region around the plunger.",
			Default -> All,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[All, MeniscusPoint]],
			Category -> "General"
		},
		CacheOption
	}
];

(* PlotSyringe Messages *)
Error::UnableToPlotSyringeModelTypesFilled = "Unable to plot `1`, as the fields Graduations, GraduationLabels, and/or GraduationTypes are not currently populated. Please contact ECL to set up the model for plotting.";
Error::UnableToPlotSyringeModelMismatchedLengths = "Unable to plot `1`, as the lengths of fields Graduations, GraduationLabels, and/or GraduationTypes are mismatched. Please contact ECL to check these model fields for plotting.";

(* No Volume Overload: *)
PlotSyringe[myObject:ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}], myOptions:OptionsPattern[PlotSyringe]] := Quiet[PlotSyringe[myObject, 0 Milliliter, myOptions], {Warning::VolumeOutsideOfGraduations}];
(* Main Overload: PlotSyringe *)
PlotSyringe[myObject:ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}], myVolume:UnitsP[Milliliter], myOptions:OptionsPattern[PlotSyringe]] := Module[
	{
		safeOptions, fieldOfView, cache, graduations, graduationTypes, graduationLabels, maxStringLength, syringeGraphic, secondNearestVolumeLabel, verticalRange, plotRange, liquidFunction, ratio,
		graduationGraphicFunction, graduationGraphics, liquidGraphic, arrowGraphic, arrowText, textScaleFactor,
		yMin, xOffset0, alignments, barrelHeight, yBarrelTop, syringeParts,
		imageHeight, yMinPlotRange, yMaxPlotRange, plotHeight, basePt, fontScale
	},

	(* Get the SafeOptions. *)
	safeOptions = SafeOptions[PlotSyringe, ToList[myOptions]];

	(* Lookup our options. *)
	{fieldOfView, cache} = Lookup[safeOptions, {FieldOfView, Cache}];

	(* Download the Graduations, GraduationTypes, and GraduationLabels. *)
	{graduations, graduationTypes, graduationLabels} = If[MatchQ[myObject, ObjectP[Model[Container]]],
		Download[myObject,
			{Graduations, GraduationTypes, GraduationLabels},
			Cache -> cache
		],
		(* Download through model if given the object. *)
		Download[myObject,
			Model[{Graduations, GraduationTypes, GraduationLabels}],
			Cache -> cache
		]
	];

	(* Crude error check to make sure we can plot based on what fields are populated. If we cannot plot, throw a message and return $Failed. *)
	If[Or[MatchQ[graduations, {}], MatchQ[graduationTypes, {}], MatchQ[graduationLabels, {}]],
		Message[Error::UnableToPlotSyringeModelTypesFilled, ECL`InternalUpload`ObjectToString[myObject]];
		Return[$Failed]
	];

	(* Crude error check to make sure we can plot based on matching lengths of populated fields. If we cannot plot, throw a message and return $Failed. *)
	If[Or[Length[graduations]!=Length[graduationTypes], Length[graduations] != Length[graduationLabels]],
		Message[Error::UnableToPlotSyringeModelMismatchedLengths, ECL`InternalUpload`ObjectToString[myObject]];
		Return[$Failed]
	];

	(* Determine the MaxStringLength for scaling *)
	(* Note the last graduation doesn't matter.. *)
	maxStringLength = Max[If[MatchQ[#, _String], StringLength[#], 0]& /@ graduationLabels[[ ;; -2]]];

	(* Need additional text scale factor for when 'Lower Part of Meniscus' text is shown. *)
	textScaleFactor = Which[GreaterQ[myVolume, 0 Milliliter] && MatchQ[fieldOfView, All], 0.5, GreaterQ[myVolume, 0 Milliliter], 0.35, True, 1];

	(* The graduations will go up to a height of 25 MM graphics units. *)
	ratio = 25/Max[graduations];

	(* Determine the plot range based on the given FieldOfView. *)
	plotRange = If[MatchQ[fieldOfView, All],
		All,
		(* Otherwise find our nearest two label. *)
		secondNearestVolumeLabel = Last[Nearest[PickList[graduations, graduationTypes, Labeled], myVolume, 2]];
		verticalRange = 1.3*Abs[secondNearestVolumeLabel - myVolume]*ratio;
		{{-8, If[MatchQ[fieldOfView, All], 12, 8]}, {myVolume*ratio - verticalRange, myVolume*ratio + verticalRange}}
	];

	(* TODO Check here what volume is minimum we want *)
	(* Throw an error and return $Failed if the we cannot display the input volume. *)
	If[Or[myVolume < 0 Milliliter, myVolume > 28/ratio],
		Message[Error::VolumeOutsidePlottableRange, ToString[myVolume], ToString[28/ratio]];
		Return[$Failed]
	];

	(* Throw a warning if the input volume is outside of the measurable range of the graduations. *)
	If[Or[myVolume < Min[graduations], myVolume > Max[graduations]],
		Message[Warning::VolumeOutsideOfGraduations, ToString[myVolume], ToString[Min[graduations]], ToString[Max[graduations]]]
	];

	(* set required constants *)
	yMin = -2;
	xOffset0 = 0;
	alignments = ConstantArray[Left, Length[graduations]];

	(* Define a generic syringe shape. *)
	barrelHeight = Max[graduations] * ratio;
	yBarrelTop   = yMin + 1.05 * barrelHeight;

	(* helper to define the separate parts of the syringe graphic *)
	syringeParts[xOffset_, volume_] := Module[
		{
			yPlungerTip, yPlungerHandle, plungerThickness, numericGrads, minorStep,
			barrel, brace, handle, shaft, hub, needle, bottom
		},

		(* convert required values in pure numbers (strip the units) *)
		yPlungerTip    = Min[yBarrelTop, yMin + QuantityMagnitude[ratio*volume]];
		yPlungerHandle = yBarrelTop + 2;

		(* define how small the graduation spacing to get a thickness to draw the plunger *)
		numericGrads = QuantityMagnitude @ UnitConvert[graduations, "Milliliters"];
		minorStep = numericGrads[[2]] - numericGrads[[1]];
		plungerThickness = minorStep * 0.5;

		(* 3) build the six parts of the syringe graphic with only numeric coordinates *)
		(* syringe barrel *)
		barrel = Line[{
			{-1 + xOffset, yBarrelTop},
			{ 1 + xOffset, yBarrelTop},
			{ 1 + xOffset, yMin     },
			{-1 + xOffset, yMin     },
			{-1 + xOffset, yBarrelTop}
		}];

		(* finger brace *)
		brace = Line[{
			{-1.75 + xOffset, yBarrelTop},
			{ 1.75 + xOffset, yBarrelTop}
		}];

		(* plunger handle/top *)
		handle = Line[{
			{-1 + xOffset, yPlungerHandle},
			{ 1 + xOffset, yPlungerHandle}
		}];

		(* plunger shaft *)
		shaft = Line[{
			{0 + xOffset, yPlungerHandle},
			{0 + xOffset, yPlungerTip   }
		}];

		(* plunger bottom *)
		bottom =
			{
				Black,
				Rectangle[
					{-1 + xOffset0, yPlungerTip},
					{ 1 + xOffset0, yPlungerTip + plungerThickness/2}
				]
			};

		(* needle connection hub *)
		hub = Line[{
			{-0.25 + xOffset, yMin},
			{ 0.25 + xOffset, yMin},
			{ 0.25 + xOffset, yMin - 0.5},
			{-0.25 + xOffset, yMin - 0.5},
			{-0.25 + xOffset, yMin}
		}];

		(* needle shaft *)
		needle = Line[{
			{0 + xOffset, yMin},
			{0 + xOffset, yMin - 4}
		}];

		(* 4) return them *)
		{barrel, brace, handle, shaft, bottom, hub, needle}
	];

	(* wrapper to construct the full syringe graphic *)
	syringeGraphic[xOffset_, volume_] := Sequence @@ syringeParts[xOffset, volume];

	(* we need to dynamically scale the graphic text and labels such that they shrink/grow when FieldOfView -> All versus MeniscusPoint *)
	(* lock the image's height in pixels *)
	imageHeight = 400;

	(* either extract or compute the vertical span *)
	{yMinPlotRange, yMaxPlotRange} =
		Which[
			(* FieldOfView -> All: graduations goes from first to last *)
			plotRange === All,
			{First@graduations, Last@graduations},
			(* standard two-element PlotRange: {{xMin,xMax},{yMin,yMax}} *)
			ListQ[plotRange] && Length[plotRange] >= 2 && ListQ[plotRange[[2]]],
			plotRange[[2]],
			(* Else: min & max are in a flat list *)
			True,
			{Min @ graduations, Max @ graduations}
		];

	(* calculate plot height in the same units as graduations *)
	plotHeight = yMinPlotRange - yMaxPlotRange;

	(* set a base for the text font at full view, which scales as the plotHeight changes *)
	basePt = 0.6;
	fontScale = QuantityMagnitude[basePt * (imageHeight/plotHeight)];

	(* Helper function to convert graduations to MM graphics. *)
	graduationGraphicFunction[
		volume_, style_, label_, xOffset_, alignment_
	] := Module[
		{xMin, xMax, yPos, fs, textX, anchor},

		(* 1) Vertical position of this tick *)
		yPos = yMin + ratio*volume;

		(* 2) Choose tick endpoints (mimic Long size for Labeled) *)
		{xMin, xMax} = Switch[{style, alignment},
			{Labeled, Left},  {0, 1},
			{Labeled, Right}, {-1, 0},
			{Long,    Left},  {0, 1},
			{Long,    Right}, {-1, 0},
			{_,       Right}, {-1, -0.5},
			{_,       Left},  {0.5, 1}
		];

		(* 3) Label font size *)
		(* dynamic font size: bigger if full‐view, smaller if zoomed *)
		fs = If[
			fieldOfView === All,
			Scaled[0.07],   (* 7% of the graphic’s height *)
			Scaled[0.025]   (* 2.5% when zoomed in *)
		];

		(* 4) Compute text position just inside barrel *)
		textX = If[alignment === Left,
			xMin + xOffset - 0.1,   (* at x = –0.1 when xMin=0 *)
			xMax + xOffset + 0.1    (* at x = –0.9 when xMax=–1 *)
		];
		anchor = {If[alignment === Left, 1, -1], 0};

		(* 5) Build the primitives *)
		{
			Line[{{xMin + xOffset, yPos}, {xMax + xOffset, yPos}}],
			If[
				style === Labeled,
				Text[
					Style[label, Bold, FontSize -> fs],
					{textX, yPos},
					anchor
				]
			]
		}
	];

	(* build the graphics for these ticks *)
	graduationGraphics = Flatten[
		MapThread[
			graduationGraphicFunction,
			{
				graduations,                                  (* every tick position *)
				graduationTypes,                              (* Labeled or Unlabeled *)
				graduationLabels,                             (* their text labels *)
				ConstantArray[xOffset0, Length @ graduations],  (* same xOffset for all *)
				alignments                                    (* Left/Right alignments *)
			}
		]
	];

	(* Helper function to make a polygon graphic for the input volume (if specified) *)
	liquidFunction[volume_, xOffset_] := Module[{yTop},
		If[LessEqualQ[volume, 0 Milliliter],
			Nothing,
			yTop = yMin + ratio*volume;
			{
				RGBColor[0.4, 0.6, 1.0, 0.7],
				Rectangle[{xOffset - 1, yMin}, {xOffset + 1, yTop}]
			}
		]
	];

	(* Apply the helper function to the specified volume. *)
	liquidGraphic = Evaluate[liquidFunction[myVolume, xOffset0]];

	(* Make annotations. *)
	arrowGraphic = If[GreaterQ[myVolume, 0 Milliliter],
		{Red, Arrowheads[0.05], Arrow[{{-3, yMin + (myVolume*ratio)}, {-2.1, yMin + (myVolume*ratio)}}], Arrowheads[0.05], Arrow[{{3, yMin + (myVolume*ratio)}, {2.1, yMin + (myVolume*ratio)}}], Dashed, Thickness[0.01], Line[{{-2, yMin + (myVolume*ratio)}, {2, yMin + (myVolume*ratio)}}]},
		Nothing
	];

	(* Make Text for annotations. *)
	arrowText = If[GreaterQ[myVolume, 0 Milliliter],
		{Red, Text[Style["Lower Part\nof Plunger", Bold, FontSize -> fontScale], {If[MatchQ[fieldOfView, All], 6, 5], yMin + (myVolume*ratio)}]},
		Nothing
	];

	(* Return all of the graphics *)
	Graphics[
		{
			(* 1) Solid strokes & dynamic thickness rule *)
			Dashing[None],
			Thickness[
				Which[
					GreaterQ[myVolume, 0 Milliliter] && fieldOfView === All,
					Scaled[0.006],   (* thicker when full‐view & nonzero *)
					GreaterQ[myVolume, 0 Milliliter],
					Scaled[0.003],   (* a bit thinner when zoomed in *)
					True,
					Scaled[0.003]
				]
			],
			Black,
			liquidGraphic,
			syringeGraphic[xOffset0, myVolume],
			graduationGraphics,
			arrowGraphic,
			arrowText
		},
		PlotRange -> plotRange,
		(* fix pixel height so thickness/font scaling is consistent *)
		ImageSize -> {Automatic, imageHeight}
	]
];