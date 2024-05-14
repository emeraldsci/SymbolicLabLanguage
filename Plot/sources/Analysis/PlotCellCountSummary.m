(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotCellCountSummary*)


DefineOptions[PlotCellCountSummary,
	Options :> {

		ModifyOptions[ListPlotOptions,
			{
				OptionName->ImageSize,
				Default->500,

				(* Limit widget to numeric ImageSize values *)
				Widget->Alternatives[
					"Size"->Widget[Type->Number,Pattern:>GreaterP[0.],PatternTooltip->"Set the image width and height in pixels:"],
					"Width and Height"->{
						"Width"->Widget[Type->Number,Pattern:>GreaterP[0.],PatternTooltip->"Set the image width in pixels:"],
						"Height"->Widget[Type->Number,Pattern:>GreaterP[0.],PatternTooltip->"Set the image height in pixels:"]
					},
					"Other"->Widget[Type->Expression,Pattern:>GreaterP[0.]|{GreaterP[0.],GreaterP[0.]},Size->Line]
				]
			}
		],

		OutputOption

	}
];


PlotCellCountSummary[packet:ObjectP[Object[Analysis,CellCount]], ops:OptionsPattern[PlotCellCountSummary]]:=Module[
	{safeOps,imageSize,output,finalPlot},

	(* Get safe options and ImageSize *)
	safeOps=SafeOptions[PlotCellCountSummary,ToList@ops];
	imageSize=Lookup[safeOps,ImageSize];

	(* Generate plot *)
	finalPlot=Column[
		{
			Grid[
				{{
					(* Scale each subplot to half the specified image size *)
					PlotCellCount[packet, PlotType->Overlay, ImageSize->imageSize/2],
					PlotCellCount[packet, PlotType->PieChart, SingleCell->True, ImageSize->imageSize/2]
				}}
			],
			PlotCellCount[packet, PlotType->Text]
		},
		Alignment->Center
	];

	(* Return the result, according to the output option. No option resolution occurred so just return safeOps *)
	output=Lookup[safeOps,Output];
	output/.{
		Result->finalPlot,
		Preview->finalPlot,
		Tests->{},
		Options->safeOps
	}
];
