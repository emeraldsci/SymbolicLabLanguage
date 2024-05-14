(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*PlotThermodynamics*)


DefineOptions[PlotThermodynamics,
	Options	:> {
		OutputOption
	},
	SharedOptions :> {
		{PlotFit,
			{
				PlotStyle, PlotType, Display, Exclude, Outliers, OutlierDistance, StandardDeviation,
				SamplePoints, PointSize, ImageSize, AlignmentPoint, AspectRatio, Axes, AxesLabel, AxesOrigin, AxesStyle,
				Background, BaselinePosition, BaseStyle, ClippingStyle, ColorFunction, ColorFunctionScaling, ColorOutput,
				ContentSelectable, CoordinatesToolOptions, DataRange, DisplayFunction, Epilog, Filling, FillingStyle, FormatType,
				Frame, FrameLabel, FrameStyle, FrameTicks, FrameTicksStyle, GridLines, GridLinesStyle, ImageMargins, ImagePadding,
				ImageSizeRaw, InterpolationOrder, Joined, LabelStyle, MaxPlotPoints, Mesh, MeshFunctions, MeshShading, MeshStyle,
				Method, PerformanceGoal, PlotLabel, PlotLegends, PlotMarkers, PlotRange, PlotRangeClipping, PlotRangePadding,
				PlotRegion, PreserveImageOptions, Prolog, RotateLabel, TargetUnits, Ticks, TicksStyle
			}
		}
	}
];


Error::NoFit="No fit is referenced in the thermodynamics object `1`.";


(* listable objects *)
PlotThermodynamics[
	analysisObj:ListableP[(ObjectReferenceP[Object[Analysis,Thermodynamics]]|LinkP[Object[Analysis,Thermodynamics]])],
	ops:OptionsPattern[PlotThermodynamics]
]:=PlotThermodynamics[Download[analysisObj],ops];

(* infos *)
PlotThermodynamics[
	analysisInfos:{PacketP[Object[Analysis,Thermodynamics]]..},
	ops:OptionsPattern[PlotThermodynamics]
]:=Module[
	{originalOps,safeOps,output,plots,returnedPlotOps,mergedReturnedOps,resolvedOps},

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[PlotThermodynamics,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* Place all figures into a slide show *)
	{plots,returnedPlotOps}=Transpose[
		Map[
			PlotThermodynamics[#,Sequence@@ReplaceRule[safeOps,{Output->{Result,Options}}]]&,
			analysisInfos
		]
	];

	(* Options are aggregated into a single list by preserving those that were resolved to the same value for all inputs. Any options resolved to different values between inputs are set to Automatic. *)
	mergedReturnedOps=MapThread[If[CountDistinct[List@##]>1,First@#->Automatic,First@DeleteDuplicates[List@##]]&,returnedPlotOps];

	(* The final resolved options based on safeOps and the returned options from ELLP calls *)
	resolvedOps=ReplaceRule[safeOps,Prepend[mergedReturnedOps,Output->output]];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result->plots,
		Preview->(If[Length[plots] === 1, First[plots], SlideView[plots]]),
		Tests->{},
		Options->resolvedOps
	}

];

(* core *)
PlotThermodynamics[
	analysisInfo:PacketP[Object[Analysis,Thermodynamics]],
	ops:OptionsPattern[PlotThermodynamics]
]:=Module[
	{
		originalOps,safeOps,output,internalPlotFitOps,plotFitPlot,plotFitOptions,resolvedOps
	},

	(* Exit and throw an error if the thermodynamics object has no Fit referenced *)
	If[!MatchQ[Fit/.analysisInfo,ObjectP[Object[Analysis,Fit]]],
		Message[Error::NoFit,Object/.analysisInfo];Return[$Failed]
	];

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* default the options *)
	safeOps=SafeOptions[PlotThermodynamics,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* The options to pass to PlotFit *)
	internalPlotFitOps=ToList@PassOptions[PlotThermodynamics,PlotFit,
		ReplaceRule[safeOps,
			{
				PlotLabel->"van't Hoff Plot",
				PlotType->Linear,
				FrameLabel->{"\!\(\*FractionBox[\(1\), \(Temperature\)]\) (Kelvin)","Log[Ka]",None,None},
				Output->{Result,Options}
			}
		]
	];

	(* The result and options from calling the PlotFit function *)
	{plotFitPlot,plotFitOptions}=PlotFit[Fit/.analysisInfo,Sequence@@internalPlotFitOps];

	(* The final resolved options based on safeOps and the return from PlotFit giving precedence to internalShowOps *)
	resolvedOps=ReplaceRule[safeOps,Prepend[plotFitOptions,Output->output]];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result->plotFitPlot,
		Preview->plotFitPlot,
		Tests->{},
		Options->resolvedOps
	}
];
