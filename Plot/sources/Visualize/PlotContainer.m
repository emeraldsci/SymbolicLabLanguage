(* ::Subsection:: *)
(*PlotContainer*)
(* we always plot *)

DefineOptions[PlotContainer,
	Options :> {
		{
			OptionName -> FieldOfView,
			Description -> "Indicates if the whole container should be displayed or just the region around any meniscus.",
			Default -> All,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[All, MeniscusPoint]],
			Category -> "General"
		},
		CacheOption
	}
];

(* PlotContainer Messages *)
Error::VolumeOutsidePlottableRange = "The specified volume `1` is outside of the inclusive range from 0 Milliliter to `2` and cannot be displayed.";
Error::UnableToPlotContainerModel = "Unable to plot `1` because one (or more) of the following reason(s): `2`. Please contact ECL to set up the model for plotting.";
Warning::VolumeOutsideOfGraduations = "The specified volume `1` is outside of the graduation range from `2` to `3`.";


(* No Volume Overload: *)
PlotContainer[myObject:ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}], myOptions:OptionsPattern[PlotContainer]] := Quiet[PlotContainer[myObject, 0 Milliliter, myOptions], {Warning::VolumeOutsideOfGraduations}];

(* Main Overload: PlotContainer *)
PlotContainer[myObject:ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}], myVolume:UnitsP[Milliliter], myOptions:OptionsPattern[PlotContainer]] := Module[
	{
		safeOptions, fieldOfView, cache, graduations, graduationTypes, graduationLabels, maxStringLength, plotRange, liquidFunction, ratio,
		graduationGraphicFunction, graduationGraphics, liquidGraphic, arrowGraphic, arrowText, textScaleFactor, positionInGradutionsOfVolume, specifiedVolumeLabledQ, ticksAbove, ticksBelow, lowerLabeledGraduation, upperLabeledGraduation, labeledGraduationsAbove, labeledGraduationsBelow,
		lowerTickArrow, upperTickArrow, secondNearestVolumeLabel, verticalRange, unableToPlotStrings, formattedUnableToPlotStrings,
		dimensions, crossSectionShape, height, aspectRatio, halfWidth, genericContainerGraphic
	},

	(* Get the SafeOptions. *)
	safeOptions = SafeOptions[PlotContainer, ToList[myOptions]];

	(* Lookup our options. *)
	{fieldOfView, cache} = Lookup[safeOptions, {FieldOfView, Cache}];

	(* Download the Graduations, GraduationTypes, and GraduationLabels. *)
	{graduations, graduationTypes, graduationLabels, dimensions, crossSectionShape} = If[MatchQ[myObject, ObjectP[Model[Container]]],
		Download[myObject,
			{Graduations, GraduationTypes, GraduationLabels, Dimensions, CrossSectionalShape},
			Cache -> cache
		],
		(* Download through model if given the object. *)
		Download[myObject,
			Model[{Graduations, GraduationTypes, GraduationLabels, Dimensions, CrossSectionalShape}],
			Cache -> cache
		]
	];

	(* Crude error check to make sure we can plot. If we cannot plot, throw a message and return $Failed. *)
	unableToPlotStrings = {
		If[MatchQ[graduations, {}], "Field[Graduations] is not populated.", Nothing],
		If[MatchQ[graduationTypes, {}], "Field[GraduationTypes] is not populated.", Nothing],
		If[MatchQ[graduationLabels, {}], "Field[GraduationLabels] is not populated.", Nothing],
		If[Length[graduations] != Length[graduationTypes], "Field[Graduations] and Field[GraduationTypes] are not the same length.", Nothing],
		If[Length[graduations] != Length[graduationLabels], "Field[Graduations] and Field[GraduationLabels] are not the same length.", Nothing],
		If[!MatchQ[crossSectionShape, Circle], "The container cross section is not circle (check Field[CrossSectionalShape]).", Nothing]
	};
	formattedUnableToPlotStrings = If[Length[unableToPlotStrings] > 0,
		StringJoin @@ MapThread[
			Function[{text, index},
				ToString[index]<>". "<>text
			],
			{unableToPlotStrings, Range[Length[unableToPlotStrings]]}
		],
		""
	];
	If[
		Length[unableToPlotStrings] > 0,
		Message[Error::UnableToPlotContainerModel, ECL`InternalUpload`ObjectToString[myObject], formattedUnableToPlotStrings];
		Return[$Failed]
	];

	(* Determine the MaxStringLength for scaling *)
	(* Note the last graduation doesn't matter.. *)
	maxStringLength = Max[If[MatchQ[#, _String], StringLength[#], 0]& /@ graduationLabels[[ ;;-2]]];

	(* height of the container, hard code to be 30 for now *)
	height = 30;

	(* get aspect ratio of the container *)
	aspectRatio = dimensions[[1]] / dimensions[[3]];

	(* get the half width of the container *)
	halfWidth = height * aspectRatio / 2;

	(* Need additional text scale factor for when 'Lower Part of Meniscus' text is shown. *)
	textScaleFactor = Which[
		GreaterQ[myVolume, 0 Milliliter] && MatchQ[fieldOfView, All],
			0.5,
		GreaterQ[myVolume, 0 Milliliter],
			0.35,
		True,
			1
	];

	(* The graduations will go up to a height of 25 MM graphics units. *)
	ratio = 25 / Max[graduations];

	(* Determine the plot range based on the given FieldOfView. *)
	(* if we do not have any labels on the container, the FieldOfView has to be All b/c we wouldn't know where the field of view is right? *)
	plotRange = If[MatchQ[fieldOfView, All] || Length[PickList[graduations, graduationTypes, Labeled]] == 0,
		All,
		(* Otherwise find our nearest two label. *)
		secondNearestVolumeLabel = Last[Nearest[PickList[graduations, graduationTypes, Labeled], myVolume, 2]];
		verticalRange = 1.3 * Abs[secondNearestVolumeLabel - myVolume] * ratio;
		{{-8, If[MatchQ[fieldOfView, All], 12, 8]}, {myVolume * ratio - verticalRange, myVolume * ratio + verticalRange}}
	];

	(* Determine if we should display ticks above/ticks below. *)
	positionInGradutionsOfVolume = First[Flatten[Position[graduations, EqualP[myVolume]]] /. {} -> {Null}];

	(* Determine if the specified volume would be to a labeled graduation. *)
	specifiedVolumeLabledQ = If[NullQ[positionInGradutionsOfVolume], False, MatchQ[Part[graduationTypes, positionInGradutionsOfVolume], Labeled]];

	(* If not calculate the number of ticks above and below. *)
	{ticksAbove, ticksBelow, lowerLabeledGraduation, upperLabeledGraduation} = If[!specifiedVolumeLabledQ && !MatchQ[positionInGradutionsOfVolume, Null],
		{labeledGraduationsBelow, labeledGraduationsAbove} = {
			PickList[graduations[[;;positionInGradutionsOfVolume]], graduationTypes[[;;positionInGradutionsOfVolume]], Labeled],
			PickList[graduations[[positionInGradutionsOfVolume;;]], graduationTypes[[positionInGradutionsOfVolume;;]], Labeled]
		};
		Which[MatchQ[{labeledGraduationsBelow, labeledGraduationsAbove}, {{}, {}}],
			{Null, Null, Null, Null},
			MatchQ[labeledGraduationsAbove, {}],
			{positionInGradutionsOfVolume - First[Flatten[Position[graduations, labeledGraduationsBelow[[-1]]]]], Null, labeledGraduationsBelow[[-1]], Null},
			MatchQ[labeledGraduationsBelow, {}],
			{Null, First[Flatten[Position[graduations, labeledGraduationsAbove[[1]]]]] - positionInGradutionsOfVolume, Null, labeledGraduationsAbove[[1]]},
			True,
			{positionInGradutionsOfVolume - First[Flatten[Position[graduations, labeledGraduationsBelow[[-1]]]]], First[Flatten[Position[graduations, labeledGraduationsAbove[[1]]]]] - positionInGradutionsOfVolume, labeledGraduationsBelow[[-1]], labeledGraduationsAbove[[1]]}
		],
		{Null, Null, Null, Null}
	];

	(* Throw an error and return $Failed if the we cannot display the input volume. *)
	If[Or[myVolume < 0 Milliliter, myVolume > 28 / ratio],
		Message[Error::VolumeOutsidePlottableRange, ToString[myVolume], ToString[28 / ratio]];
		Return[$Failed]
	];

	(* Throw a warning if the input volume is outside of the measurable range of the graduations . *)
	If[Or[myVolume < Min[graduations], myVolume > Max[graduations]],
		Message[Warning::VolumeOutsideOfGraduations, ToString[myVolume], ToString[Min[graduations]], ToString[Max[graduations]]]
	];

	(* Define a generic container, this is basically a rectangle with same aspect ratio as the container *)
	genericContainerGraphic = Line[{
		{{halfWidth, 0}, {halfWidth, height}},
		{{-halfWidth, 0}, {-halfWidth, height}},
		{{-halfWidth, 0}, {halfWidth, 0}},
		{{-halfWidth, height}, {halfWidth, height}}
	}];

	(* Helper function to convert graduations to MM graphics. *)
	graduationGraphicFunction[volume_, style_, label_] := Module[{xMin, xMax},
		{xMin, xMax} = Which[MatchQ[style, Labeled],
			{-0.7 * halfWidth, 0.7 * halfWidth},
			MatchQ[style, Long],
			{-0.7 * halfWidth, 0.7 * halfWidth},
			True,
			{-0.375 * halfWidth, 0.375 * halfWidth}
		];
		{Line[{{xMin, volume * ratio}, {xMax, volume * ratio}}], If[MatchQ[style, Labeled], Text[Style[label, Bold, FontSize -> Scaled[textScaleFactor * 0.35 / maxStringLength]], {0.8 * halfWidth, volume * ratio}, {0, -1}]]}
	];

	(* Apply the function to the graduations*)
	graduationGraphics = Flatten[MapThread[graduationGraphicFunction, {graduations, graduationTypes, graduationLabels}]];

	(* Helper function to make a polygon graphic for the input volume (if specified). *)
	liquidFunction[volume_] := If[LessEqualQ[volume, 0 Milliliter],
		Nothing,
		Module[{yCoordinate, scaledXs, scaledYs},
			yCoordinate = volume * ratio;

			(* coordinates a scaled concaved polygon *)
			scaledXs = {-2, -2, -1.83165, -1.65355, -1.46665, -1.27194, -1.07047, -0.863291, -0.651522, -0.436284, -0.218724, 0, 0.218724, 0.436284, 0.651522, 0.863291, 1.07047, 1.27194, 1.46665, 1.65355, 1.83165, 2, 2} * halfWidth / 2;
			scaledYs = {
				0, 0.763932 + yCoordinate,
				0.624067 + yCoordinate,
				0.496848 + yCoordinate,
				0.382953 + yCoordinate,
				0.282987 + yCoordinate,
				0.197483 + yCoordinate,
				0.126896 + yCoordinate,
				0.0716012 + yCoordinate,
				0.0318935 + yCoordinate,
				0.00798399 + yCoordinate,
				yCoordinate,
				0.00798399 + yCoordinate,
				0.0318935 + yCoordinate,
				0.0716012 + yCoordinate,
				0.126896 + yCoordinate,
				0.197483 + yCoordinate,
				0.282987 + yCoordinate,
				0.382953 + yCoordinate,
				0.496848 + yCoordinate,
				0.624067 + yCoordinate,
				0.763932 + yCoordinate,
				0
			};

			{
				RGBColor[0.4, 0.6, 1.],
				Polygon[Transpose[{scaledXs, scaledYs}]]
			}
		]
	];

	(* Apply the helper function to the specified volume. *)
	liquidGraphic = liquidFunction[myVolume];

	(* Make annotations. *)
	arrowGraphic = If[GreaterQ[myVolume, 0 Milliliter],
		{Red, Arrowheads[0.05], Arrow[{{-(halfWidth + 1), myVolume * ratio}, {-(halfWidth + 0.1), myVolume * ratio}}], Arrowheads[0.05], Arrow[{{halfWidth + 1, myVolume * ratio}, {halfWidth + 0.1, myVolume * ratio}}], Dashed, Thickness[0.01], Line[{{-halfWidth, myVolume * ratio}, {halfWidth, myVolume * ratio}}]},
		Nothing
	];

	lowerTickArrow = If[NullQ[lowerLabeledGraduation], Nothing, {Gray, Arrow[{{-(halfWidth + 2), lowerLabeledGraduation * ratio}, {-(halfWidth + 2), myVolume * ratio}}], Text[Style[ToString[ticksAbove]<>" Tick"<>If[GreaterQ[ticksAbove, 1], "s", ""], Bold], {-(halfWidth + 3.5), ratio * (myVolume + lowerLabeledGraduation) / 2}]}];
	upperTickArrow = If[NullQ[upperLabeledGraduation], Nothing, {Gray, Arrow[{{-(halfWidth + 2), upperLabeledGraduation * ratio}, {-(halfWidth + 2), myVolume * ratio}}], Text[Style[ToString[ticksBelow]<>" Tick"<>If[GreaterQ[ticksBelow, 1], "s", ""], Bold], {-(halfWidth + 3.5), ratio * (myVolume + upperLabeledGraduation) / 2}]}];

	(* Make Text for annotations. *)
	arrowText = If[GreaterQ[myVolume, 0 Milliliter],
		{Red, Text[Style["Liquid Level", Bold], {If[MatchQ[fieldOfView, All], halfWidth + 4, halfWidth + 3], myVolume * ratio}]},
		Nothing
	];

	(* Return all the graphics *)
	Graphics[{liquidGraphic, lowerTickArrow, upperTickArrow, arrowGraphic, arrowText, Dashing[None], Thickness[Which[GreaterQ[myVolume, 0 Milliliter] && MatchQ[fieldOfView, All], 0.01, GreaterQ[myVolume, 0 Milliliter], 0.005, True, 0.005]], Black, genericContainerGraphic, graduationGraphics}, PlotRange -> plotRange]
];