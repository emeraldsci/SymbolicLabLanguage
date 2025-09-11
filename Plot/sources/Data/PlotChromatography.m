(* ::Package:: *)

(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(* Helper functions *)


highlightFractions[infs:_,ops:_]:=Module[{fractionsPicked, object, finalFractionsPicked},
	fractionsPicked = Flatten[lookupWithUnits[infs,FractionsPicked],1];

	(* infs may not have fractionsPicked saved unless Upload is specifically called when AnalyzeFraction is used. *)
	(* Previously, FractionsPicked is uploaded to data object even if Upload is not called. So, we will directly check *)
	(* Since only the first data object is highlighted when more than one data is plotted, we just need to check the first one *)
	finalFractionsPicked = If[MatchQ[fractionsPicked, {}] || (Length[fractionsPicked]>1 && MatchQ[fractionsPicked[[1]], {}]),
		object = Lookup[infs, Object][[1]];
		Download[object,FractionPickingAnalysis[FractionsPicked]],
		fractionsPicked
	];
	{FractionHighlights->finalFractionsPicked}
];


labelFractions[infs:_,ops:_]:=Module[{fractionLabels},
  fractionLabels = Which[
		MatchQ[infs, _Association],{Lookup[infs, SamplesOut, Null]}/.{l_Link:>First[l]},
		MatchQ[infs, {_Association..}],(Lookup[#, SamplesOut, Null]&/@infs)/.{l_Link:>First[l]},
    (* If the infs aren't a packet or list of packets, then defer to the old "goofy" code. Original comments below *)
		(* need to do it this way to avoid some goofy shenanigans with Download and the infs not actually existing sometimes *)
		(* not going to take longer since the Downloading Object does not talk to the database *)
		(* quieting this message since this way is bonkers anyway and at least this lets it work properly *)
		True,Quiet[Download[Download[infs, SamplesOut], Object], {Download::MissingField, Download::NotLinkField}]
	];
	{FractionLabels->fractionLabels}
];


formatSecondYAxis[infs:_,ops:_]:=Module[
	{secondYData,firstSecondYData,gradientAlternatives,gradientLabel,yRanges,yRangeRule},

	secondYData = ops[SecondaryData];

	If[MatchQ[Length[secondYData],0],
		Return[{}]
	];

	firstSecondYData = FirstOrDefault[ops[SecondaryData]];
	gradientAlternatives = (GradientA|GradientB|GradientC|GradientD| GradientE | GradientF | GradientG | GradientH );
	gradientLabel = If[MatchQ[firstSecondYData,gradientAlternatives],
		makeColoredGradientLabel[infs,secondYData,ops],
		{}
	];

	yRanges = Replace[secondYData/.
		 {
			gradientAlternatives->{0,100}Percent
		},
		{_Symbol->Automatic},1];
	yRangeRule = {SecondYRange -> yRanges};

	Join[gradientLabel,yRangeRule]
];


makeColoredGradientLabel[infs_,secondYFields_,ops_]:=Module[
	{nonNullSecondYFields,gradientAlternatives,gradientNames,secondYColors,gradientPositions,gradientColors,coloredGradientNames,gradientString},

	gradientAlternatives = (GradientA|GradientB|GradientC|GradientD| GradientE | GradientF | GradientG | GradientH );
	nonNullSecondYFields = DeleteCases[secondYFields, _?(MatchQ[# /. infs, NullP] &)];
	If[Not[MemberQ[nonNullSecondYFields,gradientAlternatives]],
		Return[{}]
	];

	gradientNames = Cases[nonNullSecondYFields,gradientAlternatives]/. {GradientA -> "%A", GradientB -> "%B", GradientC -> "%C", GradientD -> "%D",
		GradientE -> "%E", GradientF -> "%F", GradientG -> "%G", GradientH -> "%H"};

	secondYColors = First[resolveSecondYColors[Automatic, {nonNullSecondYFields}]];
	gradientPositions = Position[nonNullSecondYFields,gradientAlternatives];
	gradientColors = secondYColors[[Flatten@gradientPositions]];

	coloredGradientNames = MapThread[Style[#1, #2] &, {gradientNames, gradientColors}];
	gradientString = Row[Riffle[coloredGradientNames,", "]];

	{FrameLabel->{Automatic,Automatic,Automatic,gradientString},FrameUnits->{Automatic,Automatic,Automatic,None}}
];


(* ::Subsection:: *)
(*PlotChromatography*)


(* ::Subsubsection::Closed:: *)
(*Options*)


DefineOptions[PlotChromatography,
	Options :> {
		IndexMatching[
			{
				OptionName -> PlotLabel,
				Default -> Automatic,
				Description -> "The label to place on the plot.",
				ResolutionDescription -> "If Automatic, the object ID will be used.",
				AllowNull -> False,
				Category->"Plot Style",
				Widget -> Widget[
					Type -> Expression,
					Pattern :> _?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|_String|_Pane|_Style|Automatic,
					Size -> Line
				]
			},
			IndexMatchingInput->"dataObject"
		],
		{
			OptionName -> Display,
			Default -> {Peaks,Ladder,AirAlarms},
			Description -> "Additional data to overlay on top of the plot.",
			AllowNull -> False,
			Category -> "Data Specifications",
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				Widget[
					Type -> MultiSelect,
					Pattern :> DuplicateFreeListableP[Peaks|Fractions|Ladder|AirAlarms]
				]
			]
		},
		{
			OptionName -> PrimaryData,
			Default -> Automatic,
			Description -> "The field name containing the data to be plotted. All data chosen for this option must be in the same units. To include data in a different unit in this plot, use the SecondaryData option.",
			AllowNull -> False,
			Category -> "Data Specifications",
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[FlowRates | GradientA | GradientB | GradientC | GradientD | Chromatogram |
						Absorbance | Absorbance3D | SecondaryAbsorbance | TertiaryAbsorbance | Fluorescence | SecondaryFluorescence | TertiaryFluorescence | QuaternaryFluorescence |
						Scattering | MultiAngleLightScattering22Degree | MultiAngleLightScattering28Degree | MultiAngleLightScattering32Degree | MultiAngleLightScattering38Degree | MultiAngleLightScattering44Degree | MultiAngleLightScattering50Degree | MultiAngleLightScattering57Degree | MultiAngleLightScattering64Degree | MultiAngleLightScattering72Degree | MultiAngleLightScattering81Degree | MultiAngleLightScattering90Degree | MultiAngleLightScattering99Degree | MultiAngleLightScattering108Degree | MultiAngleLightScattering117Degree | MultiAngleLightScattering126Degree | MultiAngleLightScattering134Degree | MultiAngleLightScattering141Degree | MultiAngleLightScattering147Degree | DynamicLightScattering | DynamicLightScatteringCorrelationFunction |
						RefractiveIndex | CircularDichroism | Charge |
						Pressure | Temperature |
						Conductance | ConductivityFlowCellTemperature | pH | pHFlowCellTemperature |
						MassSpectrum | IonAbundance | IonAbundance3D | FIDResponse |
						SamplePressure | PreColumnPressure | PostColumnPressure | DeltaColumnPressure]
				],
				Adder[
					Widget[
						Type -> Enumeration,
						Pattern :> ListableP[FlowRates | GradientA | GradientB | GradientC | GradientD | Chromatogram |
							Absorbance | Absorbance3D | SecondaryAbsorbance | TertiaryAbsorbance | Fluorescence | SecondaryFluorescence | TertiaryFluorescence | QuaternaryFluorescence |
							Scattering | MultiAngleLightScattering22Degree | MultiAngleLightScattering28Degree | MultiAngleLightScattering32Degree | MultiAngleLightScattering38Degree | MultiAngleLightScattering44Degree | MultiAngleLightScattering50Degree | MultiAngleLightScattering57Degree | MultiAngleLightScattering64Degree | MultiAngleLightScattering72Degree | MultiAngleLightScattering81Degree | MultiAngleLightScattering90Degree | MultiAngleLightScattering99Degree | MultiAngleLightScattering108Degree | MultiAngleLightScattering117Degree | MultiAngleLightScattering126Degree | MultiAngleLightScattering134Degree | MultiAngleLightScattering141Degree | MultiAngleLightScattering147Degree | DynamicLightScattering | DynamicLightScatteringCorrelationFunction |
							RefractiveIndex | CircularDichroism | Charge |
							Pressure | Temperature |
							Conductance | ConductivityFlowCellTemperature | pH | pHFlowCellTemperature |
							MassSpectrum | IonAbundance | IonAbundance3D | FIDResponse |
							SamplePressure | PreColumnPressure | PostColumnPressure | DeltaColumnPressure
						]
					]
				]
			]
		},
		{
			OptionName -> SecondaryData,
			Default -> Automatic,
			Description -> "Additional fields to display along with the primary data. The first item in the list determines the second Y axis specifications.",
			ResolutionDescription -> "Available data from the data object will be automatically chosen.",
			AllowNull -> False,
			Category -> "Data Specifications",
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[FlowRates | GradientA | GradientB | GradientC | GradientD  | Chromatogram |
							Absorbance | Absorbance3D | SecondaryAbsorbance | TertiaryAbsorbance | Fluorescence | SecondaryFluorescence | TertiaryFluorescence | QuaternaryFluorescence |
							Scattering | MultiAngleLightScattering22Degree | MultiAngleLightScattering28Degree | MultiAngleLightScattering32Degree | MultiAngleLightScattering38Degree | MultiAngleLightScattering44Degree | MultiAngleLightScattering50Degree | MultiAngleLightScattering57Degree | MultiAngleLightScattering64Degree | MultiAngleLightScattering72Degree | MultiAngleLightScattering81Degree | MultiAngleLightScattering90Degree | MultiAngleLightScattering99Degree | MultiAngleLightScattering108Degree | MultiAngleLightScattering117Degree | MultiAngleLightScattering126Degree | MultiAngleLightScattering134Degree | MultiAngleLightScattering141Degree | MultiAngleLightScattering147Degree | DynamicLightScattering | DynamicLightScatteringCorrelationFunction |
							RefractiveIndex | CircularDichroism | Charge |
							Pressure | Temperature |
							Conductance | ConductivityFlowCellTemperature | pH | pHFlowCellTemperature |
							MassSpectrum | IonAbundance | IonAbundance3D | FIDResponse |
							SamplePressure | PreColumnPressure | PostColumnPressure | DeltaColumnPressure
					]
				],
				Adder[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[FlowRates | GradientA | GradientB | GradientC | GradientD  | Chromatogram |
								Absorbance | Absorbance3D | SecondaryAbsorbance | TertiaryAbsorbance | Fluorescence | SecondaryFluorescence | TertiaryFluorescence | QuaternaryFluorescence |
								Scattering | MultiAngleLightScattering22Degree | MultiAngleLightScattering28Degree | MultiAngleLightScattering32Degree | MultiAngleLightScattering38Degree | MultiAngleLightScattering44Degree | MultiAngleLightScattering50Degree | MultiAngleLightScattering57Degree | MultiAngleLightScattering64Degree | MultiAngleLightScattering72Degree | MultiAngleLightScattering81Degree | MultiAngleLightScattering90Degree | MultiAngleLightScattering99Degree | MultiAngleLightScattering108Degree | MultiAngleLightScattering117Degree | MultiAngleLightScattering126Degree | MultiAngleLightScattering134Degree | MultiAngleLightScattering141Degree | MultiAngleLightScattering147Degree | DynamicLightScattering | DynamicLightScatteringCorrelationFunction |
								RefractiveIndex | CircularDichroism | Charge |
								Pressure | Temperature |
								Conductance | ConductivityFlowCellTemperature | pH | pHFlowCellTemperature |
								MassSpectrum | IonAbundance | IonAbundance3D | FIDResponse |
								SamplePressure | PreColumnPressure | PostColumnPressure | DeltaColumnPressure
						]
					]
				]
			]
		},
		{
			OptionName -> LinkedObjects,
			Default -> {},
			Description -> "Fields containing objects which should be pulled from the input object and plotted alongside it.",
			AllowNull -> False,
			Category -> "Data Specifications",
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				Adder[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Replicates|StandardData|Analytes]
					]
				]
			]
		},
		TargetUnitsOption,
		UnitsOption,
		{
			OptionName->Zoomable,
			Default->True,
			AllowNull->False,
			Category -> "Plot Style",
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Description->"Indicates if a dynamic plot which can be zoomed in or out will be returned."
		},
		MapOption,
		{
			OptionName -> OptionFunctions,
			Default -> {highlightFractions,formatSecondYAxis,labelFractions},
			Description -> "A list of functions which take in a list of info packets and plot options and return a list of new options.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> {_Symbol...},
				Size -> Line
			]
		},
		{
			OptionName -> Absorbance,
			Default -> Null,
			Description -> "The absorbance chromatogram trace to display on the plot.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> _?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size -> Paragraph
			]
		},
		{
			OptionName -> Conductance,
			Default -> Null,
			Description -> "The conductance trace to display on the plot.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> _?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size -> Paragraph
			]
		},
		{
			OptionName -> FlowRates,
			Default -> Null,
			Description -> "The flow rates trace to display on the plot.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> _?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size -> Paragraph
			]
		},
		FractionsOption,
		{
			OptionName -> GradientA,
			Default -> Null,
			Description -> "The gradient a trace to display on the plot.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> _?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size -> Paragraph
			]
		},
		{
			OptionName -> GradientB,
			Default -> Null,
			Description -> "The gradient b trace to display on the plot.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> _?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size -> Paragraph
			]
		},
		{
			OptionName -> GradientC,
			Default -> Null,
			Description -> "The gradient c trace to display on the plot.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> _?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size -> Paragraph
			]
		},
		{
			OptionName -> GradientD,
			Default -> Null,
			Description -> "The gradient d trace to display on the plot.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> _?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size -> Paragraph
			]
		},
		PeaksOption,
		{
			OptionName -> Pressure,
			Default -> Null,
			Description -> "The pressure trace to display on the plot.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> _?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size -> Paragraph
			]
		},
		{
			OptionName -> SecondaryChromatogram,
			Default -> Null,
			Description -> "The secondary chromatogram trace to display on the plot.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> _?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size -> Paragraph
			]
		},
		{
			OptionName -> Temperature,
			Default -> Null,
			Description -> "The temperature trace to display on the plot.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> _?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size -> Paragraph
			]
		},
		{
			OptionName -> Filling,
			Default -> Bottom,
			Description -> "Indicates how the region under the chromatogram should be shaded.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> _,
				Size -> Word
			]
		},
		{
			OptionName -> PlotType,
			Default -> Automatic,
			Description -> "Indicates how the data should be presented.",
			ResolutionDescription -> "Use type with respect to data format.",
			AllowNull -> False,
			Category -> "Plot Style",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Automatic|ListLinePlot|ContourPlot|DensityPlot|ListPlot3D
			]
		},
		{
			OptionName -> Wavelength,
			Default -> Automatic,
			Description -> "Indicates the wavelength for which data should be plotted.",
			ResolutionDescription -> "Use wavelength associated with data.",
			AllowNull -> False,
			Category -> "Data Specifications",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Nanometer,1000 Nanometer],
				Units -> Alternatives[Nanometer]
			]
		},
		{
			OptionName -> Mass,
			Default -> Automatic,
			Description -> "Indicates the mass (ion) by m/z for which data should be plotted.",
			ResolutionDescription -> "Use mass associated with data (IonAbundanceMass in the data object).",
			AllowNull -> False,
			Category -> "Data Specifications",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Nanometer,1000 Nanometer],
				Units -> Alternatives[Nanometer]
			]
		},
		{
			OptionName -> SamplingRate,
			Default -> Automatic,
			Description -> "Specify that every nth data point should be included in the 3D plot or that all data should be plotted.",
			ResolutionDescription -> "Use default sampling rate.",
			AllowNull -> True,
			Category -> "Data Specifications",
			Widget -> Alternatives[
				Widget[
					Type -> Number,
					Pattern :> GreaterP[0,1]
				],
				Widget[Type->Enumeration,Pattern:>Alternatives[All]]
			]
		},
		{
			OptionName -> TransformX,
			Default -> Null,
			Description -> "When specified as Volume, will transform the x-axis from units of time to units of volume.",
			ResolutionDescription -> "Defaults the units of the x-axis to Daltons if plotting Mass Spec data and Minutes otherwise.",
			AllowNull -> True,
			Category -> "Data Specifications",
			Widget -> Widget[Type->Enumeration,Pattern:>Alternatives[Volume]]
		},
		OutputOption
	},
	SharedOptions :> {
		EmeraldListLinePlot
	}
];


(* ::Subsubsection::Closed:: *)
(*Unique Messages*)


(* Other messages are defined in PlotData file as they are shared among the other functions there *)
Warning::CannotTransform3DData="The x-axis of the data cannot be transformed if the data is 3D. Plot will be generated without the transform.";
Warning::CannotTransformMassSpecData="Cannot transform the x-axis of the mass spec data to be volume. Plot will be generated without the transform.";
Warning::InvalidTargetUnits="The target units specified `1` do not match the option TransformX. Plot will be generated without the transform.";
Warning::UndefinedFlowRate="The flow rate is not specified. Plot will be generated without the transform.";
Error::DimensionMismatch="Cannot make 3D plot using 2D data.";
Error::NoChromatographyDataToPlot = "The protocol object does not contain any associated chromatography data.";
Error::ChromatographyProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotChromatography or PlotObject on an individual data object to identify the missing values.";


(* ::Subsubsection::Closed:: *)
(*Code*)

(* pre-evaluate so UnitCoordinatesQ is faster *)
 millisiemenPerCentimeer = Millisiemen/Centimeter;

(* Raw Definition *)
PlotChromatography[primaryData:rawPlotInputP,inputOptions:OptionsPattern[]]:=rawToPacket[
	primaryData,
	Object[Data,Chromatography],
	PlotChromatography,
	(*we need to check if the primary data was specified, if not then we need to figure out what kind of data is present instead of just assuming absorbance*)
	Module[{safeOptions,primaryDataOption},
		safeOptions=SafeOptions[PlotChromatography, ToList[inputOptions]];

		(*is the primary data still automatic?*)
		primaryDataOption=Lookup[safeOptions,PrimaryData];

		(*if so try to figure out what should be plotted, otherwise leave as is*)
		If[MatchQ[primaryDataOption,Automatic],
			(* see the units of the primary data*)
			Switch[primaryData,
				(*if they are in pA as would be expected of FID data, *)
				_?(UnitCoordinatesQ[#1, {Minute, Picoampere}] &) | {_?(UnitCoordinatesQ[#1, {Minute, Picoampere}] &) ..} | {{_?(UnitCoordinatesQ[#1, {Minute, Picoampere}] &) ..} ..},
					ReplaceRule[safeOptions,PrimaryData->FIDResponse],

				(*if they are in mS/cm as would be expected of conductance data *)
				_?(UnitCoordinatesQ[#1, {Minute, millisiemenPerCentimeer}] &) | {_?(UnitCoordinatesQ[#1, {Minute, millisiemenPerCentimeer}] &) ..} | {{_?(UnitCoordinatesQ[#1, {Minute, millisiemenPerCentimeer}] &) ..} ..},
					ReplaceRule[safeOptions,PrimaryData->Conductance],

				(* otherwise safely assume absorbance *)
				_,ReplaceRule[safeOptions,PrimaryData->Absorbance]
			],
			(* and if not automatic just go with whatever the specification was *)
			safeOptions
		]
	]
];

(* Protocol Overload *)
PlotChromatography[
	obj: ObjectP[{
		Object[Protocol, HPLC],
		Object[Protocol, FPLC],
		Object[Protocol, GasChromatography],
		Object[Protocol, IonChromatography],
		Object[Protocol, LCMS],
		Object[Protocol, SupercriticalFluidChromatography]
	}],
	ops: OptionsPattern[PlotChromatography]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotChromatography, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, Alternatives[{ObjectP[Object[Data, Chromatography]]..}, {ObjectP[Object[Data, ChromatographyMassSpectra]]..}]],
		Message[Error::NoChromatographyDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotChromatography[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotChromatography[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::ChromatographyProtocolDataNotPlotted];
		Return[$Failed],
		Nothing
	];

	(* If Result was requested, output the plots in slide view, unless there is only one plot then we can just show it not in slide view. *)
	outputPlot = If[MemberQ[output, Result],
		If[Length[plots] > 1,
			SlideView[plots],
			First[plots]
		]
	];

	(* If Options were requested, just take the first set of options since they are the same for all plots. Make it a List first just in case there is only one option set. *)
	outputOptions = If[MemberQ[output, Options],
		First[ToList[resolvedOptions]]
	];

	(* Prepare our final result *)
	finalResult = output /. {
		Result -> outputPlot,
		Options -> outputOptions,
		Preview -> previewPlot,
		Tests -> {}
	};

	(* Return the result *)
	If[
		Length[finalResult] == 1,
		First[finalResult],
		finalResult
	]
];

PlotChromatography[input:ListableP[ObjectP[Object[Data,Chromatography]]]|ListableP[ObjectP[Object[Data,ChromatographyMassSpectra]]],inputOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,outputSpecification,output,gatherTests,safeOptions,safeOptionTests,dataObjects,requestedPlotType,requestedWavelength,
		plotTypes3D,primaryFields,secondaryFields,standardFields,requestedDisplay,epilogFields,downloadFields,outputOptions,
		rawPackets,packets,minWavelengths,maxWavelengths,wavelengths,chromatograms,chromatogram3Ds,best3Dfield,
		changingGradientQ,detectors,bestPrimaryField,bestSecondaryField,analysisFields,massSpecDataQ,populatedPrimaryFields,
		resolvedPlotType,requestedWavelengthInRange,resolvedWavelength,sideLabels,options3D,full3DOptions,gradientB,requestedPrimaryData,
		resolvedPrimaryData,requestedSecondaryData,resolvedSecondaryData,resolvedOps,result,options,zoomablePlot,
		minMasses, maxMasses, targetMasses,flowRates,requestedTransformX,resolvedTransformX,validTransformXQ,xAxisUnit,
		validTransformUnitsQ,almostResolvedTargetUnits,xTransformationFunctions,resolvedGradientPackets,resolvedTransformPackets,
		fluidTypes, secondaryDataLookup, airAlarms, newDisplayOptions, airAlarmEpilog, airAlarmsTransformed, verticalLineOption,verticalLineEpilog
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[inputOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[OptionValue[Output]];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Determine if we should output the resolved options *)
	outputOptions = MemberQ[output, Options];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[PlotChromatography,listedOptions,Output->{Result,Test},AutoCorrect->False],
		{SafeOptions[PlotChromatography,listedOptions,AutoCorrect->False],Null}
	];

	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	dataObjects = ToList[input];

	(*figure out we're working with just Chromatography, or ChromatographyMS*)
	massSpecDataQ=MatchQ[First@dataObjects,ObjectP[Object[Data,ChromatographyMassSpectra]]];

	(* Don't call safeOps since packetToELLP will distribute listed options *)
	requestedPlotType = OptionDefault[OptionValue[PlotType]];
	requestedWavelength = OptionDefault[OptionValue[Wavelength]];
	requestedPrimaryData = OptionDefault[OptionValue[PrimaryData]];
	secondaryDataLookup = OptionDefault[OptionValue[SecondaryData]];
	requestedSecondaryData = If[MatchQ[secondaryDataLookup,Except[Automatic]],ToList@secondaryDataLookup, secondaryDataLookup];
	requestedTransformX=OptionDefault[OptionValue[TransformX]];

	plotTypes3D = ContourPlot|DensityPlot|ListPlot3D;

	(* Shape download *)
	primaryFields = If[MatchQ[requestedPrimaryData,Automatic],
		(*adjust the primary fields based on whether mass spec data available*)
		If[!massSpecDataQ,
			{Absorbance, Scattering, Fluorescence, FIDResponse, Conductance, DynamicLightScattering, MultiAngleLightScattering22Degree, RefractiveIndex, Charge},
			{Absorbance, Absorbance3D, IonAbundance, MassSpectrum, TotalIonAbundance}
		],
		ToList@requestedPrimaryData
	];

	(* Secondary fields *)
	secondaryFields=If[MatchQ[requestedSecondaryData,Automatic],
		If[!massSpecDataQ,
			{Pressure, SecondaryFluorescence, TertiaryFluorescence, QuaternaryFluorescence, Conductance, pH},
			{Pressure}
		],
		ToList@requestedSecondaryData
	];

	(*specify the other standard fields*)
	standardFields = If[!massSpecDataQ,
		{Detectors,MinAbsorbanceWavelength,MaxAbsorbanceWavelength,AbsorbanceWavelength,GradientB,FlowRates,GradientStartTime},
		{Detectors,MinAbsorbanceWavelength,MaxAbsorbanceWavelength,AbsorbanceWavelength,GradientB,MinMass,MaxMass,IonAbundanceMass,MassSelection,AbsorbanceSelection,FluidType}
	];

	requestedDisplay=ToList[OptionDefault[OptionValue[Display]]];

	epilogFields= If[!massSpecDataQ,
		DeleteCases[Join[
			optionNameToFieldName[requestedDisplay, Object[Data, Chromatography], First[primaryFields]],
			If[Length[primaryFields] > 1,
				optionNameToFieldName[requestedDisplay, Object[Data, Chromatography], primaryFields[[2]]], (*remove after data migraton*)
				{Null}
			],
			If[MemberQ[requestedDisplay, Fractions],
				{SamplesOut, FractionsPicked},
				{SamplesOut}
			]
		], Null],
		(*no epilog fields currently for mass spec data*)
		{}
	];

	analysisFields= If[!massSpecDataQ,
		{StandardAnalyses, ScatteringPeaksAnalyses, QuaternaryFluorescencePeaksAnalyses, TertiaryFluorescencePeaksAnalyses,
			SecondaryFluorescencePeaksAnalyses, FluorescencePeaksAnalyses, Absorbance3DPeaksAnalyses,	SecondaryAbsorbancePeaksAnalyses, AbsorbancePeaksAnalyses,
			FIDResponsePeaksAnalyses, ConductancePeaksAnalyses, ChargePeaksAnalyses},
		{IonAbundancePeaksAnalyses, MassSpectrumPeaksAnalyses, AbsorbancePeaksAnalyses, Absorbance3DPeaksAnalyses}
	];

	(*if the user requests a 3D plot, we should chose the correct 3D field. For mass spec data, this is presumed to be the ion abundance*)
	best3Dfield=Which[
		MatchQ[requestedPrimaryData,Except[Automatic]],ToList[requestedPrimaryData],
		massSpecDataQ, {Absorbance3D},
		True,{Absorbance3D}
	];

	(* Download 3D Chromatogram only if requesting data at a specific wavelength or 3D plot *)
	downloadFields = If[MatchQ[requestedPlotType,plotTypes3D]||!MatchQ[requestedWavelength,Automatic],
		Packet@@DeleteDuplicates@Join[standardFields,primaryFields,secondaryFields,epilogFields,analysisFields,best3Dfield],
		Packet@@DeleteDuplicates@Join[standardFields,primaryFields,secondaryFields,epilogFields,analysisFields,{Absorbance}]
	];

	(* Quiet MissingField error since raw data will be put in a packet which will not necessarily have all these fields *)
	rawPackets = Quiet[Download[dataObjects,downloadFields],Download::MissingField];

	(* An ordered list of informed primary fields identified in rawPackets *)
	populatedPrimaryFields=If[MatchQ[Lookup[rawPackets,Object],{$Failed..}],
		{},
		(* A list of all fields in primaryFields which are populated, retaining the order of primaryFields *)
		Cases[primaryFields,_?(MatchQ[Lookup[First@rawPackets,#,Null],Except[Null|{}|$Failed]]&)]
	];

	(* Drop Object key if $Failed, since packetToELLP can't handle this *)
	packets = If[MatchQ[Lookup[rawPackets,Object],{$Failed..}],
		KeyDrop[rawPackets,Object],
		rawPackets
	];

	fluidTypes = Lookup[packets,FluidType];
	minWavelengths = Lookup[packets,MinAbsorbanceWavelength];
	maxWavelengths = Lookup[packets,MaxAbsorbanceWavelength];
	wavelengths = Lookup[packets,AbsorbanceWavelength];
	minMasses = Lookup[packets,MinMass,ConstantArray[Null,Length[packets]]];
	maxMasses = Lookup[packets,MaxMass,ConstantArray[Null,Length[packets]]];
	targetMasses = Lookup[packets,IonAbundanceMass,ConstantArray[Null,Length[packets]]];
	chromatograms = Lookup[packets,Absorbance];
	chromatogram3Ds = Lookup[packets,First@best3Dfield];
	flowRates = Lookup[packets,FlowRates];
	airAlarms = Lookup[packets,AirDetectedAlarms,{}]/.$Failed->{};

	(* get the gradient B as a potential secondary data *)
	gradientB=Lookup[packets,GradientB];

	(*do we have a changing gradient b?*)
	changingGradientQ=If[MatchQ[gradientB,{($Failed|Null)..}],
		False,
		Not[Apply[SameQ,First@gradientB[[All,All,2]]]]
	];

	(*get the detectors used*)
	(* this is a little bit goofy; ideally we want the detectors that were used in _all_ the packets so we don't have a weird case where detectors in the first packet that aren't in any other ones *)
	(* if we don't have _any_ that are universal to all (not counting Pressure/Temperature), then yeah just take the first ones *)
	detectors=With[{allDetectors = Lookup[packets, Detectors]},
		Which[
			(* if we have raw data this is $Failed and that is fine for below *)
			MatchQ[allDetectors, {$Failed..}], $Failed,
			MemberQ[Intersection @@ allDetectors, Except[Pressure | Temperature]], Intersection @@ allDetectors,
			True, First[allDetectors]
		]
	];

	(* NOTE: if you update the below, make sure the fields you add are included in "secondaryFields" and "primaryFields". *)
	(* Automatic resolution of best primary and secondary fields.*)
	{bestPrimaryField,bestSecondaryField}=Which[
    (*chance we working with raw data, in which case stick to the defaults.*)
    MatchQ[Values[KeyDrop[First@packets, {Type, ID}]], {$Failed ..}],{{Absorbance},{}},
		(*if we have data with mass spec data then we do a further check *)
		massSpecDataQ,
		(* depending on the fluid type we will handle this differently for now *)
		Switch[
			fluidTypes,
			(* if we're dealing with GCMS data, we want to plot the TIC *)
			{___,Gas,___},
			{{TotalIonAbundance},{}},
			_,
			If[First[minMasses]==First[maxMasses],
				(*if it's just one mass, then pretty easy*)
				{{IonAbundance},{Absorbance}},
				(*otherwise, we'll presume the mass spectrum. No secondary data because it actually can't be place on*)

				If[MatchQ[Lookup[packets,MassSpectrum],NullP],

					{{Absorbance3D},{}},

					{{MassSpectrum},{}}
				]
			]
		],

		(*check which detector we have and advise based on that*)
		MemberQ[detectors,EvaporativeLightScattering],{{Scattering},If[changingGradientQ,{Absorbance,GradientB},{Absorbance}]},
		MemberQ[detectors,Fluorescence],{{Fluorescence},If[changingGradientQ,{Absorbance,GradientB},{Absorbance}]},
		MemberQ[detectors,DynamicLightScattering],{{DynamicLightScattering},If[changingGradientQ,{Absorbance,GradientB},{Absorbance}]},
		MemberQ[detectors,MultiAngleLightScattering],{{MultiAngleLightScattering22Degree},If[changingGradientQ,{Absorbance,GradientB},{Absorbance}]},
		MemberQ[detectors,RefractiveIndex],{{RefractiveIndex},If[changingGradientQ,{Absorbance,GradientB},{Absorbance}]},
		MemberQ[detectors,ElectrochemicalDetector],{{Charge},If[changingGradientQ,{Absorbance,GradientB},{Absorbance}]},
		MemberQ[detectors,Absorbance] && MemberQ[detectors,Conductance],{{Absorbance},If[changingGradientQ,{Conductance,GradientB},{Conductance}]},
		MemberQ[detectors,Absorbance] && MemberQ[detectors,pH],{{Absorbance},If[changingGradientQ,{pH,GradientB},{pH}]},

		(* no secondary field for FID and Conductance and pH *)
		MemberQ[detectors,FlameIonizationDetector],{{FIDResponse},{}},
		MemberQ[detectors,Conductance],{{Conductance},{}},
		MemberQ[detectors,pH],{{pH},{}},

		(* Use the first non-empty field encountered in primary field, defaulting to Absorbance if none are found. *)
		True,{
			If[MatchQ[populatedPrimaryFields,{_Symbol..}],
				{First[populatedPrimaryFields]},
				{Absorbance}
			],
			If[changingGradientQ,{GradientB},{Pressure}]
		}
	];

	(*now, let's resolve the primary and secondary data at the same time*)
	{resolvedPrimaryData,resolvedSecondaryData}=Switch[{requestedPrimaryData,requestedSecondaryData},
			(*check to see if both are specified, in which case our job is easy*)
			{Except[Automatic],Except[Automatic]},{{requestedPrimaryData},{SecondaryData->requestedSecondaryData}},
			(*check if the primary is chosen, then we'll suggest*)
			{Except[Automatic],Automatic},{{requestedPrimaryData},{SecondaryData->Complement[bestSecondaryField,ToList@requestedPrimaryData]}},
			(*the weird case of the secondary selected but not the primary*)
			{Automatic,Except[Automatic]},{List@First@Complement[Union[bestPrimaryField,bestSecondaryField],requestedSecondaryData],{SecondaryData->requestedSecondaryData}},
			(*if neither then stick with the best options*)
			_,{bestPrimaryField,{SecondaryData->bestSecondaryField}}
	];

	(* -- Resolve PlotType -- *)
	resolvedPlotType = Which[
		(* Resolve Automatic *)
		(*If there is a requested wavelength, we want to give a 2D slice*)
		MatchQ[requestedPlotType,Automatic]&&MatchQ[resolvedPrimaryData,{Absorbance3D}]&&!MatchQ[requestedWavelength,Automatic],ListLinePlot,
		MatchQ[requestedPlotType,Automatic]&&MatchQ[resolvedPrimaryData,{Absorbance3D}],ContourPlot,
		MatchQ[requestedPlotType,Automatic],ListLinePlot,

		(* No 3D data, can't do a 3D plot, roll on and do a 2D plot. *)
		MatchQ[chromatogram3Ds,{Null..}] || Length[chromatogram3Ds[[1,1]]] !=3 && MatchQ[requestedPlotType,plotTypes3D],Module[{},
			Message[Error::DimensionMismatch];
			Message[Error::InvalidOption,"PlotType"];
			ListLinePlot
		],

		True,requestedPlotType
	];

	(* Resolve TransformX *)
	resolvedTransformX=Which[
		MatchQ[requestedTransformX,Volume],True,
		MatchQ[requestedTransformX,Null],False
	];

	(* Transform is valid if option is requested, there is not mass spec data and there is not 3D data *)
	validTransformXQ=Which[
		resolvedTransformX&&MemberQ[flowRates,{}],Message[Warning::UndefinedFlowRate];False,
		resolvedTransformX&&massSpecDataQ,Message[Warning::CannotTransformMassSpecData];False,
		resolvedTransformX&&(MatchQ[requestedPlotType,plotTypes3D]),Message[Warning::CannotTransform3DData];False,
		resolvedTransformX&&!massSpecDataQ&&!(MatchQ[requestedPlotType,plotTypes3D]),True,
		True,False
	];

	(* -- Resolve Wavelength -- *)

	requestedWavelengthInRange = Or[
		MatchQ[requestedWavelength,Automatic],
		MatchQ[Round[wavelengths],{Round[requestedWavelength]..}],
		And@@MapThread[RangeQ[requestedWavelength,{#1,#2}]&,{minWavelengths,maxWavelengths}]
	];

	resolvedWavelength = Which[
		(* 3D plot, shouldn't specify wavelength *)
		MatchQ[resolvedPlotType,plotTypes3D]&&MatchQ[requestedWavelength,DistanceP],Message[Warning::AllWavelengths],

		(* 2D plot, specifed wavelength in range *)
		MatchQ[resolvedPlotType,ListLinePlot]&&MatchQ[requestedWavelength,DistanceP]&&requestedWavelengthInRange,requestedWavelength,

		(* 2D plot, specifed wavelength out of range *)
		MatchQ[resolvedPlotType,ListLinePlot]&&MatchQ[requestedWavelength,DistanceP]&&!requestedWavelengthInRange,Module[{closestWavelength},
			closestWavelength = Round@First[MinimalBy[Join[minWavelengths,maxWavelengths],Abs[requestedWavelength-#]&]];
			Message[Warning::WavelengthUnavailable,closestWavelength];
			Message[Error::InvalidOption,"Wavelength"];
			closestWavelength
		],

		(* Resolve automatic *)
		True,If[And@@MapThread[RangeQ[280 Nanometer,{#1,#2}]&,{minWavelengths,maxWavelengths}],
			(* Use 280 if in range *)
			280 Nanometer,
			(* Otherwise find the wavelength in the center of the range *)
			Round[Mean[Intersection@@Range[Unitless[minWavelengths,Nanometer],Unitless[maxWavelengths,Nanometer]]]]*Nanometer
		]
	];

	(* Standard 3D plotting options *)
	sideLabels = MapThread[
		makeFrameLabel[#1,#2,defaultLabelColor]&,
		{
			{safeUnitDimension[Minute], "Wavelength", safeUnitDimension[Milli AbsorbanceUnit]},
			{Minute, Nanometer, Milli AbsorbanceUnit}
		}
	];

	options3D = Association[
		PlotLabel -> If[MatchQ[Quiet[Download[Replace[dataObjects,{singleItem_}:>singleItem],Object],Download::MissingField],$Failed|{$Failed..}],
			Null,
			autoResolvePlotLabel[ToString[Download[Replace[dataObjects,{singleItem_}:>singleItem],Object], InputForm],{Bold, 14, FontFamily -> "Arial"},600]
		],
		If[MatchQ[resolvedPlotType,ContourPlot|DensityPlot],
			FrameLabel -> sideLabels[[{1,2}]],
			AxesLabel -> sideLabels
		],
		PlotLegends -> Placed[BarLegend[Automatic, LegendLabel -> Placed[Rotate[sideLabels[[3]],Pi/2],Right],LabelStyle -> {Bold, 14, FontFamily -> "Arial",defaultLabelColor}],Right],
		PlotRange -> All,
		LabelStyle -> {Bold, 14, FontFamily -> "Arial"},
		AspectRatio -> 1/GoldenRatio,
		ImageSize -> 600
	];

	(* Use 3D options only if something else wasn't specified in the input *)
	full3DOptions = Normal@Join[options3D,Association[ToList[inputOptions]/.{Null -> {}}]];

	(*pass the resolved Primary Data in*)
	resolvedOps = ReplaceRule[ToList[inputOptions],Join[{PrimaryData->resolvedPrimaryData},resolvedSecondaryData]];

	{result,options}=Which[
		(* Are we dealing with a ListLinePlot? *)
		MatchQ[resolvedPlotType,ListLinePlot],Module[
			{unitsForResolved,targetUnits,resolvedTargetUnits,updatedPackets,resolvedOpsWithOutput,ellpResult,listLinePlot,listLinePlotOptions,fullOptions,allResolvedOptions,validResolvedOptions},

			(*figure out the units for our plot*)
			xAxisUnit=Which[
				massSpecDataQ&&MatchQ[First[Flatten@resolvedPrimaryData],MassSpectrum],Dalton,
				validTransformXQ,Milli Liter,
				True,Minute
			];

			unitsForResolved=Switch[First[Flatten@resolvedPrimaryData],
				(*if an absorbance*)
				Chromatogram | Absorbance|SecondaryAbsorbance|Absorbance3D,{xAxisUnit,Milli AbsorbanceUnit},
				IonAbundance, {xAxisUnit,ArbitraryUnit},
				TotalIonAbundance, {xAxisUnit,ArbitraryUnit},
				MassSpectrum, {xAxisUnit,ArbitraryUnit},
				pH, {xAxisUnit, NoUnit},
				(*fluorescence*)
				Fluorescence|SecondaryFluorescence|TertiaryFluorescence|QuaternaryFluorescence,{xAxisUnit,RFU},
				(*scattering*)
				Scattering, {xAxisUnit,LSU},
				MultiAngleLightScattering22Degree | MultiAngleLightScattering28Degree | MultiAngleLightScattering32Degree | MultiAngleLightScattering38Degree | MultiAngleLightScattering44Degree | MultiAngleLightScattering50Degree | MultiAngleLightScattering57Degree | MultiAngleLightScattering64Degree | MultiAngleLightScattering72Degree | MultiAngleLightScattering81Degree | MultiAngleLightScattering90Degree | MultiAngleLightScattering99Degree | MultiAngleLightScattering108Degree | MultiAngleLightScattering117Degree | MultiAngleLightScattering126Degree | MultiAngleLightScattering134Degree | MultiAngleLightScattering141Degree | MultiAngleLightScattering147Degree, {xAxisUnit,Volt},
				DynamicLightScattering | DynamicLightScatteringCorrelationFunction, {xAxisUnit,Hertz},
				(*the more exotic stuff*)
				Pressure,{xAxisUnit,PSI},
				SamplePressure,{xAxisUnit,PSI},
				PreColumnPressure,{xAxisUnit,PSI},
				DeltaColumnPressure,{xAxisUnit,PSI},
				PostColumnPressure,{xAxisUnit,PSI},
				Temperature | ConductivityFlowCellTemperature | pHFlowCellTemperature,{xAxisUnit, Celsius},
				Conductance,{xAxisUnit, (Milli Siemens)/(Centi Meter)},
				RefractiveIndex,{xAxisUnit,RefractiveIndexUnit},
				CircularDichroism,{xAxisUnit,Absorbance},
				GradientA | GradientB | GradientC | GradientD, {xAxisUnit,Percent},
				FlowRates, {xAxisUnit, (Liter Milli)/Minute},
				Charge, {xAxisUnit, Nano Coulomb},
				(* Flame Ionization Detector *)
				FIDResponse, {xAxisUnit, Pico*Ampere}
			];

			targetUnits=Lookup[safeOptions,TargetUnits];

			almostResolvedTargetUnits=Switch[targetUnits,
				Automatic|{Automatic,Automatic},unitsForResolved,
				{Automatic,_},{xAxisUnit,Last[targetUnits]},
				{_,Automatic},{First[targetUnits],Last[unitsForResolved]},
				_,targetUnits
			];

			(* Check if target units match transform *)
			{resolvedTargetUnits,validTransformUnitsQ}=Which[
				validTransformXQ&&!MatchQ[First[almostResolvedTargetUnits],VolumeP],{Message[Warning::InvalidTargetUnits,First[almostResolvedTargetUnits]];{Minute,Last[almostResolvedTargetUnits]},False},
				!validTransformXQ&&!MatchQ[First[almostResolvedTargetUnits],TimeP|Dalton],{Message[Warning::InvalidTargetUnits,First[almostResolvedTargetUnits]];{Minute,Last[almostResolvedTargetUnits]},False},
				True,{almostResolvedTargetUnits,True}
			];

			(* Shift gradients to correct place *)
			resolvedGradientPackets=Map[
				Function[{packet},Module[{flowRate,volume,gradientStartTime,data,gradientP,gradientPositions,transformedData,updatedData,dataToPlot},

					(* Get the actual start time of the gradient *)
					gradientStartTime=If[MatchQ[Lookup[packet,GradientStartTime],NullP|_Missing],
						0 Minute,
						Lookup[packet,GradientStartTime]];

					(* Data to be plotted *)
					dataToPlot=Flatten[Join[resolvedPrimaryData,SecondaryData/.First[resolvedSecondaryData]]];

					(* Lookup all of the Data *)
					data=Lookup[packet,dataToPlot];

					(* Define the pattern describing a Gradient *)
					gradientP=GradientA|GradientB|GradientC|GradientD|GradientE|GradientF|GradientG|GradientH;

					(* Get the Indices of the Gradients in the secondary data *)
					gradientPositions=Position[dataToPlot,gradientP];

					(* Add the gradientStartTime to all of the x-values of the Gradient data *)
					transformedData=MapAt[Transpose[{#[[All,1]]+gradientStartTime,#[[All,2]]}]&,data,gradientPositions];

					(* Put back into an association and merge *)
					updatedData=MapThread[Function[{name,data},name->data],{dataToPlot,transformedData}];
					Join[packet,Association@@updatedData]
				]],
				packets
			];

			(* Transform the x-axis if transform is valid *)
			{resolvedTransformPackets,xTransformationFunctions}=Transpose[MapThread[
				Function[{packet,flowRate},Module[{dataToTransform,data,transformedData,namedTransformedData,transformationFunction},

					(* If transform is valid *)
					If[validTransformUnitsQ&&validTransformXQ,

						(* Data to be transformed *)
						dataToTransform=Flatten[Join[resolvedPrimaryData,SecondaryData/.First[resolvedSecondaryData]]];

						(* Lookup all of the Data *)
						data=Lookup[packet,dataToTransform];

						(* Transform the data *)
						transformedData=elutedVolume[#,flowRate,First[resolvedTargetUnits]]&/@data;

						(* Get the Transformation Function *)
						transformationFunction=elutedVolume[First[data],flowRate,First[resolvedTargetUnits],returnTransform->True];

						(* Put data back into assocation and join *)
						namedTransformedData=MapThread[Function[{name,data},name->data],{dataToTransform,transformedData}];
						{Join[packet,Association@@namedTransformedData],transformationFunction},

						(* Otherwise keep packets the same *)
						{packet,Null}
					]

				]],
				{resolvedGradientPackets,flowRates}
			]];

			(*we may have to update our packets depending on the absorbance data*)
			updatedPackets = MapThread[
				Function[{chromatogram3D,packet,wavelength},
					Which[
						(*if all the values are failed then just leave as is -- this done during the raw data transformation*)
						MatchQ[Values[KeyDrop[packet, {Type, ID}]], {$Failed ..}],packet,
						(*otherwise have to check if 3D, make sure chromatogram3D is actually more than 2 dimensions*)
						MatchQ[chromatogram3D,QuantityArrayP[]]&&UnsameQ[wavelength,resolvedWavelength]&&Length[chromatogram3D[[1]]]>2,
						Module[{chromatogram3DUnitless,chromatogram2DUnitless,chromatogram2D},
							chromatogram3DUnitless = MapAt[Round,QuantityMagnitude[chromatogram3D,{Minute, Nanometer, Milli AbsorbanceUnit}],{All,2}];
							chromatogram2DUnitless = Cases[chromatogram3DUnitless,{_,Unitless[resolvedWavelength,Nanometer],_}][[All,{1,3}]];
							(* If none of the data points were measured at the resolved wavelength, i.e. if chromatogram2DUnitless is an empty list, return the packet as is *)
							If[MatchQ[chromatogram2DUnitless,{}],
								packet,
								(* Otherwise, replace the Chromatogram field with the values at the resolved wavelength *)
								chromatogram2D = QuantityArray[chromatogram2DUnitless,{Minute,AbsorbanceUnit Milli}];
								Merge[{packet,<|Chromatogram -> chromatogram2D,Absorbance->chromatogram2D|>},Last]
							]
						],
						(*otherwise, don't need to do anything*)
						True,packet
					]
				],
				{chromatogram3Ds,resolvedTransformPackets,wavelengths}
			];

			(* Parse the air alarm data *)
			(* Perform the x-transform if required *)
			airAlarmsTransformed=MapThread[
				Function[{alarms,transform},
					If[NullQ[transform],
						(* If the transform is Null, return the air alarms unchanged *)
						alarms,

						(* If the transform is not Null, transform the air alarms, working out the units *)
						((transform/.T->Unitless[#,Minute]) Milliliter)&/@alarms
					]
				],
				{airAlarms,xTransformationFunctions}
			];

			(* Create the epilog for ELLP *)
			airAlarmEpilog=If[OptionValue[Map],
				Map[Function[time, {time, 25 Percent, "Air Alarm", Darker[Yellow]}], airAlarmsTransformed, {2}]/.{}->Null,
				Map[Function[time, {time, 25 Percent, "Air Alarm", Darker[Yellow]}], Flatten[airAlarmsTransformed]]/.{}->Null
			];

			(* Get the existing vertical line specification *)
			verticalLineOption=Lookup[safeOptions,VerticalLine];

			(* Combine the air alarms with the specified vertical lines *)
			verticalLineEpilog=If[OptionValue[Map],
				Switch[{#,verticalLineOption},
					{NullP,NullP},
					Null,
					{_,NullP},
					#,
					{NullP,_},
					verticalLineOption,
					_,
					Join[#,ToList[verticalLineOption]]
				]&/@airAlarmEpilog,

				Switch[{airAlarmEpilog,verticalLineOption},
					{NullP,NullP},
					Null,
					{_,NullP},
					airAlarmEpilog,
					{NullP,_},
					verticalLineOption,
					_,
					Join[airAlarmEpilog,ToList[verticalLineOption]]
				]
			];


			(* Process Display Option *)
			newDisplayOptions = If[MemberQ[requestedDisplay, AirAlarms],
				{VerticalLine -> verticalLineEpilog, Display -> DeleteCases[requestedDisplay, AirAlarms]},
				{}
			];

			(* Force output of Result and Options *)
			resolvedOpsWithOutput=ReplaceRule[
				resolvedOps,
				Join[
					{TargetUnits->resolvedTargetUnits,Output->{Result,Options},XTransformationFunction->xTransformationFunctions},
					If[MatchQ[Quiet[Download[Replace[dataObjects,{singleItem_}:>singleItem],Object],Download::MissingField],$Failed|{$Failed..}],{PlotLabel->Null},{}],
					(* We may have been sent 3D data to plot at a specific wavelength, transform approriately *)
					{PrimaryData->(resolvedPrimaryData/.Absorbance3D->Absorbance)},
					newDisplayOptions
				]
			];

			(* Call EmeraldListLinePlot with these resolved options, forcing Output\[Rule]{Result,Options}. *)
			ellpResult=packetToELLP[updatedPackets,PlotChromatography,resolvedOpsWithOutput];

			(* If the result from ELLP was Null or $Failed, return $Failed. *)
			If[MatchQ[ellpResult,Null|$Failed],
				{$Failed,$Failed},

				(* Check to see if we're mapping. If so, then we have to Transpose our result. *)
				{listLinePlot,listLinePlotOptions}=If[OptionValue[Map],
					Module[{transposedResult,plots,ellpOptions},
						(* Transpose needs to still work even if we have Null values *)
						(* only replacing at level 1 because don't want to mess with Nulls deeper in the plot *)
						transposedResult=Transpose[Replace[ellpResult, Null -> {$Failed, {}}, 1]];

						(* The plots are simply the first element in the list. *)
						plots=First[transposedResult];

						(* We are given back a list of options. (Options for each plot). We can't really return multiple so just pick the first. *)
						ellpOptions=transposedResult[[2]][[1]];

						{plots,ellpOptions}
					],
					(* There is no mapping going on. Don't transpose anything. *)
					If[Not[MatchQ[ellpResult,_List]],
						{ellpResult,{}},
						ellpResult
					]
				];

				(* Before we return, make sure that we include all of our safe options. *)
				(* Overwrite our SafeOptions with our resolved EmeraldListLinePlot options. *)
				fullOptions=Normal[Join[Association[safeOptions],Association[resolvedSecondaryData],<|PlotType->resolvedPlotType,Wavelength->resolvedWavelength|>,Association[listLinePlotOptions],<|SamplingRate->Null|>,If[MemberQ[requestedDisplay, AirAlarms],<|Display->requestedDisplay,VerticalLine->verticalLineOption|>,<||>]]];

				(* Return our result and options. *)
				{listLinePlot,fullOptions}
			]
		],

		(* Are we dealing with a 3D Plot? *)
		MatchQ[resolvedPlotType,plotTypes3D],Module[
			{samplingRate,maxLength,timePoints,timeInterval,maxPoints,resolvedSamplingRate ,sampledChromatograms,timeUnit,
			wavelengthUnit,absorbanceUnit,unitlessPlotRange,optionsWithRange,plots,plotListCorrect,allResolvedOptions,validResolvedOptions},

			samplingRate = OptionDefault[OptionValue[SamplingRate]];

			maxLength = Max[Length/@chromatogram3Ds];

			(*Above this number of points plotting gets really slow *)
			maxPoints = 45000;

			(* Determine the time resolution to have about the maxNumber of points *)
			resolvedSamplingRate = If[MatchQ[samplingRate,Automatic],
				If[maxLength<maxPoints,
					All,
					Round[maxLength/maxPoints]
				],
				samplingRate
			];

			(* Select data gathered at the time resolution - i.e if 0.1 Minute take data for 0.1 minute, 0.2 minute, ... but not at 0.11 minute *)
			(* There's certainly a better way to do this *)
			sampledChromatograms = If[MatchQ[resolvedSamplingRate,All],
				chromatogram3Ds,
				Map[
					Module[{unitlessChromatogram,sampledChromatogramUnitless},
						unitlessChromatogram = QuantityMagnitude[#1, If[MatchQ[best3Dfield,{IonAbundance3D}], {Minute, Gram/Mole, ArbitraryUnit}, {Minute, Nanometer, Milli AbsorbanceUnit}]];
						sampledChromatogramUnitless = SortBy[unitlessChromatogram,#[[2]]&][[Range[1,Length[unitlessChromatogram],resolvedSamplingRate]]];
						QuantityArray[sampledChromatogramUnitless,If[MatchQ[best3Dfield,{IonAbundance3D}], {Minute, Gram/Mole, ArbitraryUnit}, {Minute, Nanometer, Milli AbsorbanceUnit}]]
					]&,
					chromatogram3Ds
				]
			];

			(* There's a MM bug which causes plot ranges with units to be ignored (instead range gets set from -1..1)
				Replace any units with their unitless counterparts
			*)
			{timeUnit,wavelengthUnit,absorbanceUnit}=Units[sampledChromatograms[[1,1]]];
			unitlessPlotRange=ReplaceAll[Lookup[full3DOptions,PlotRange],{
				x:TimeP:>Unitless[x,timeUnit],
				x:UnitsP[AbsorbanceUnit]:>Unitless[x,absorbanceUnit],
				x:DistanceP:>Unitless[x,wavelengthUnit]
			}];
			optionsWithRange=ReplaceRule[full3DOptions,PlotRange->unitlessPlotRange];

			plots = Switch[resolvedPlotType,
				ContourPlot, EmeraldListContourPlot[#,PassOptions[PlotChromatography,EmeraldListContourPlot,optionsWithRange]]&/@sampledChromatograms,
				DensityPlot, ListDensityPlot[#,PassOptions[PlotChromatography,ListDensityPlot,optionsWithRange]]&/@sampledChromatograms,
				(* Sending in full options from PassOptions makes the plot appear bizarre *)
				ListPlot3D, ListPlot3D[#,Normal@KeyTake[optionsWithRange,Keys[Options[ListPlot3D]]]]&/@sampledChromatograms
			];

			plotListCorrect = If[MatchQ[input,ObjectP[]],
				First[plots],
				plots
			];

			(* Extra step to check if we have an extra options spec being passed through *)
			If[MatchQ[plotListCorrect, {_, {_Rule..}}],
				plotListCorrect = FirstOrDefault[plotListCorrect, $Failed];
			];

			zoomablePlot=If[TrueQ[OptionDefault[OptionValue[Zoomable]]],
				Zoomable[plotListCorrect],
				plotListCorrect
			];

			(* Get the resolved options from the plot. *)
			allResolvedOptions=Join[
				safeOptions,
				{SamplingRate->resolveSamplingRate},
				Quiet[AbsoluteOptions[Unzoomable@plotListCorrect]]
			];

			validResolvedOptions=(ToExpression[#[[1]]]->#[[2]]&)/@ToList[PassOptions[PlotChromatography,allResolvedOptions]];

			(* Force output of Result and Options *)
			{zoomablePlot,validResolvedOptions}
		],

		True,$Failed
	];

	outputSpecification/.{
		Result->result,
		Preview->result,
		Options->options,
		Tests->Join[
			safeOptionTests,
			{
				Test["Specified wavelength must be available in input data.", MatchQ[resolvedPlotType,ListLinePlot]&&MatchQ[requestedWavelength,DistanceP]&&!requestedWavelengthInRange, False],
				Test["Wavelength option should not be specified if doing 3D plot.", MatchQ[resolvedPlotType,plotTypes3D]&&MatchQ[requestedWavelength,DistanceP], False],
				Test["If a plot of 3D chromatography data was requested, 3D data is available.", MatchQ[chromatogram3Ds,{Null..}] && MatchQ[requestedPlotType,plotTypes3D], False]
			}
		]
	}
];

(* Doubly listed oveerload *)
PlotChromatography[input:{{ObjectP[]..}..},inputOptions:OptionsPattern[PlotChromatography]]:=PlotChromatography[#,inputOptions]&/@input;
