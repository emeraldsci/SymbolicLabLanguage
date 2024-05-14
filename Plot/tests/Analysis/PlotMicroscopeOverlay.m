(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection:: *)
(*PlotMicroscopeOverlay*)


DefineTests[PlotMicroscopeOverlay,{

	Example[{Basic, "Plot a microscope overlay:"},
		PlotMicroscopeOverlay[Object[Analysis, MicroscopeOverlay, "id:4pO6dMWvYKJz"]],
		plotImageP
	],

	Example[{Basic, "Plot a microscope overlay from a link:"},
		PlotMicroscopeOverlay[Link[Object[Analysis, MicroscopeOverlay, "id:4pO6dMWvYKJz"],Reference]],
		plotImageP
	],

	Test["Given a packet:",
		PlotMicroscopeOverlay[Download[Object[Analysis, MicroscopeOverlay, "id:4pO6dMWvYKJz"]]],
		plotImageP
	],

	Example[{Additional, "Plot a microscope overlay including Red, Green, and Blue fluorescent channels:"},
		PlotMicroscopeOverlay[Object[Analysis, MicroscopeOverlay, "id:n0k9mGzREqP1"]],
		plotImageP
	],

	Example[{Options, ImageSize, "Resize the image:"},
		PlotMicroscopeOverlay[Object[Analysis, MicroscopeOverlay, "id:J8AY5jwzLEEj"], ImageSize->700],
		plotImageP
	],

	Example[{Options,MeasurementLines,"Add a measurement line to the image. Use Ctrl+LeftClick+Dragging (Cmd+LeftClick+Dragging on Mac) to move the points:"},
		PlotMicroscopeOverlay[Object[Analysis, MicroscopeOverlay, "id:J8AY5jwzLEEj"],MeasurementLines->{{{425,230},{425,100}}}],
		plotImageP
	],


	Example[{Options,MeasurementLabel,"Remove the distance label from each measurement line:"},
		PlotMicroscopeOverlay[Object[Analysis, MicroscopeOverlay, "id:J8AY5jwzLEEj"],MeasurementLines->{{{425,230},{425,100}},{{70,125},{430,125}}},MeasurementLabel->False],
		{},
		EquivalenceFunction->(MatchQ[Cases[Staticize[#1],_Text,Infinity],#2]&)
	],

	(* Messages *)
	Example[{Messages,"NoOverlay","Overlay analysis does not exist:"},
		PlotMicroscopeOverlay[<|Type->Object[Data, Microscope],MicroscopeOverlay->Null|>],
		Null,
		Messages:>Message[PlotMicroscopeOverlay::NoOverlay]
	],

	(* Output tests *)
	Test["Setting Output to Result returns the plot:",
		PlotMicroscopeOverlay[Object[Analysis, MicroscopeOverlay, "id:4pO6dMWvYKJz"],Output->Result],
		plotImageP
	],

	Test["Setting Output to Preview returns the plot:",
		PlotMicroscopeOverlay[Object[Analysis, MicroscopeOverlay, "id:4pO6dMWvYKJz"],Output->Preview],
		plotImageP
	],

	Test["Setting Output to Options returns the resolved options:",
		PlotMicroscopeOverlay[Object[Analysis, MicroscopeOverlay, "id:4pO6dMWvYKJz"],Output->Options],
		ops_/;MatchQ[ops,OptionsPattern[PlotMicroscopeOverlay]]
	],

	Test["Setting Output to Tests returns a list of tests:",
		PlotMicroscopeOverlay[Object[Analysis, MicroscopeOverlay, "id:4pO6dMWvYKJz"],Output->Tests],
		{(_EmeraldTest|_Example)...}
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options:",
		PlotMicroscopeOverlay[Object[Analysis, MicroscopeOverlay, "id:4pO6dMWvYKJz"],Output->{Result,Options}],
		output_List/;MatchQ[First@output,plotImageP]&&MatchQ[Last@output,OptionsPattern[PlotMicroscopeOverlay]]
	],

	Test["Setting Output to Options returns all of the defined options:",
		Sort@Keys@PlotMicroscopeOverlay[Object[Analysis, MicroscopeOverlay, "id:4pO6dMWvYKJz"],Output->Options],
		Sort@Keys@SafeOptions@PlotMicroscopeOverlay
	],

	Sequence@@If[Not@ECL`$CCD,
		{
			Example[{Options,MeasurementLines,"Specify two measurement lines.  Use Ctrl+LeftClick to add (Cmd+LeftClick on Mac) and Ctrl+RightClick to remove (Cmd+RightClick on Mac) measurement lines:"},
				PlotMicroscopeOverlay[Object[Analysis, MicroscopeOverlay, "id:J8AY5jwzLEEj"],MeasurementLines->{{{425,230},{425,100}},{{70,125},{430,125}}}],
				{Disk[{425,230},4.37`],Disk[{425,100},4.37`],Disk[{70,125},4.37`],Disk[{430,125},4.37`]},
				EquivalenceFunction->(MatchQ[Cases[Staticize[#1],_Disk,Infinity],#2]&)
			]
		}
	]
}];
