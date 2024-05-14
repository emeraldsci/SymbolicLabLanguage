(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotState*)


DefineOptions[PlotState,

	Options :> {

		ModifyOptions[EmeraldPieChart,
			{
				{
					OptionName->ChartStyle,
					Default->ColorDataFunction[97, "Indexed", {1, Infinity, 1}, (ToColor[If[1 <= #1 <= 10, {RGBColor[0.368417, 0.506779, 0.709798], RGBColor[0.880722, 0.611041, 0.142051], RGBColor[0.560181, 0.691569, 0.194885], RGBColor[0.922526, 0.385626, 0.209179], RGBColor[0.528488, 0.470624, 0.701351], RGBColor[0.772079, 0.431554, 0.102387], RGBColor[0.363898, 0.618501, 0.782349], RGBColor[1, 0.75, 0], RGBColor[0.647624, 0.37816, 0.614037], RGBColor[0.571589, 0.586483, 0.]}[[#1]], Blend[{RGBColor[0.915, 0.3325, 0.2125], RGBColor[0.83, 0.46, 0.], RGBColor[0.9575, 0.545, 0.11475], RGBColor[1., 0.7575, 0.], RGBColor[0.6175, 0.715, 0.], RGBColor[0.15, 0.715, 0.595], RGBColor[0.3625, 0.545, 0.85], RGBColor[0.575, 0.4175, 0.85], RGBColor[0.677, 0.358, 0.595], RGBColor[0.7875, 0.358, 0.425], RGBColor[0.915, 0.3325, 0.2125]}, FractionalPart[(-10 + #1 - 1)/GoldenRatio]]], RGBColor] & )[Floor[#1 - 1, 1] + 1]&]
				},
				{
					OptionName->ImageSize,
					Default->300
				},
				{
					OptionName->Frame,
					Default->False,
					Category->"Hidden"
				},
				{
					OptionName->FrameLabel,
					Default->None
				},

				{
					OptionName->ChartElementFunction,
					Default->Automatic,
					Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,(Sequence@@ChartElementData["PieChart"])]]
				},

				{
					OptionName->SectorOrigin,
					Widget->Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
						"Angle"->Widget[Type->Expression,Pattern:>_?NumericQ,Size->Word],
						"Angle and Direction"->{
							"Angle"->Widget[Type->Expression,Pattern:>_?NumericQ,Size->Word],
							"Direction"->Widget[Type->Enumeration,Pattern:>("Clockwise"|"Counterclockwise")]
						}
					]
				}
			}
		],

		(* Hide irrelevant options *)
		ModifyOptions[EmeraldPieChart,{ChartBaseStyle,ChartLayout,SectorSpacing,FrameStyle,FrameTicks,FrameTicksStyle,TargetUnits,GridLines,GridLinesStyle,LabelingFunction},Category->"Hidden"]

	},

	SharedOptions :> {

		(* Inherit all PieChart options from EmeraldPieChart (intersection of option sets), excluding ChartLegends *)
		{EmeraldPieChart,{Output,AlignmentPoint,AspectRatio,Axes,AxesLabel,AxesOrigin,AxesStyle,Background,BaselinePosition,BaseStyle,ChartBaseStyle,ChartElementFunction,ChartLabels,ChartLayout,ChartStyle,ColorFunction,ColorFunctionScaling,ColorOutput,ContentSelectable,CoordinatesToolOptions,DisplayFunction,Epilog,FormatType,Frame,FrameLabel,FrameStyle,FrameTicks,FrameTicksStyle,GridLines,GridLinesStyle,ImageMargins,ImagePadding,ImageSize,ImageSizeRaw,LabelingFunction,LabelingSize,LabelStyle,LegendAppearance,Method,PerformanceGoal,PlotLabel,PlotRange,PlotRangeClipping,PlotRangePadding,PlotRegion,PlotTheme,PolarAxes,PolarAxesOrigin,PolarGridLines,PolarTicks,PreserveImageOptions,Prolog,RotateLabel,SectorOrigin,SectorSpacing,TargetUnits,Ticks,TicksStyle}}

	}
];


(* Messages *)
Warning::InputLengthMismatch="The number of concentrations (`1`) does not match the number of species (`2`). Please ensure that both inputs are of the same length. Padding both inputs to match the greater of the two lengths.";


PlotState[in:(ObjectReferenceP[Object[Simulation,Equilibrium]]|LinkP[Object[Simulation,Equilibrium]]),ops:OptionsPattern[PlotState]]:=
	PlotState[Download[in,EquilibriumState],ops];

PlotState[in:PacketP[Object[Simulation,Equilibrium]],ops:OptionsPattern[PlotState]]:=
		PlotState[Lookup[in,EquilibriumState],ops];

(* Overloads for Concentrations/Species input *)
PlotState[concentrations:{(ConcentrationP|NumericP|AmountP)..},species:{ReactionSpeciesP..},ops:OptionsPattern[PlotState]]:=
	PlotState[{concentrations,species},ops];

(* --- Core Function --- *)
PlotState[in:{concentrations:{(ConcentrationP|NumericP|AmountP)..},species_List},ops:OptionsPattern[PlotState]]:=If[

	(* If concentrations/species lengths are mismatched, throw a warning and pad both inputs to match *)
	Length@concentrations!=Length@species,
	Message[Warning::InputLengthMismatch,Length@concentrations,Length@species];
	PlotState[
		ToState[
			PadRight[species,Max[Length@concentrations,Length@species], ""],
			PadRight[concentrations,Max[Length@concentrations,Length@species], 0 Molar]
		],
		ops
	],

	(* Otherwise, pass them along as a State *)
	PlotState[ToState[species,concentrations],ops]

];


(* --- Core Function --- *)
PlotState[st:StateP,ops:OptionsPattern[PlotState]]:=Module[
	{safeOps,plotPoints,legends,stateQuants,stateSpecies,valueTooltips,finalPlot,finalGraphics,output},

	safeOps=SafeOptions[PlotState, ToList[ops]];

	(* Extract state information *)
	stateQuants = st["Quantities"];
	stateSpecies = st["Species"];

	(* Resolve ChartLegends *)
	legends = Map[
		If[MatchQ[#,(StructureP|StrandP|_?SequenceQ)],
			Tooltip[StructureForm[#,ImageSize->75],StructureForm[#,ImageSize->300]],
			Tooltip[#,#]
		]&,
		stateSpecies
	];

	(* Resolve primary data *)
	valueTooltips = Map[
		Round[#,.01]&,
		UnitScale[stateQuants]
	];

	plotPoints=MapThread[Tooltip[#1,#2]&,{Unitless[stateQuants,Units[First[stateQuants]]],valueTooltips}];

	(* Generate final plot *)
	finalPlot=PieChart[plotPoints,ChartLegends->legends,PassOptions[PlotState,PieChart,safeOps]];

	(* Extract final graphics *)
	finalGraphics=First@Cases[ToList@finalPlot,_Graphics,-1];

	(* Return the result, according to the output option *)
	output=Lookup[safeOps,Output];
	output/.{
		Result->finalPlot,

		(* Frame Preview so legend displays in command builder *)
		Preview->Framed[
			Pane[
				Framed[finalPlot,FrameStyle->White],
				ImageSize->{800,Full},
				Alignment->{Center,Automatic},
				ImageSizeAction->"ResizeToFit"
			],
			FrameStyle->White
		],

		Tests->{},

		(* Update the resolved options before returning them *)
		Options->ReplaceRule[safeOps,Last@finalGraphics]
	}

];


(* Listable overload *)
PlotState[ins:{(ObjectP[Object[Simulation,Equilibrium]]|{concentrations:{(ConcentrationP|NumericP|AmountP)..},species_List}|StateP)..},ops:OptionsPattern[]]:=consolidateOutputs[PlotState,ins,ops];
