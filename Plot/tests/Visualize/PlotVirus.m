(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*PlotVirus*)


DefineTests[PlotVirus,{

	Example[{Basic,"Display the image of one virus:"},
		PlotVirus[Model[Sample, "HPV-16"]],
		_Image
	],
	Example[{Basic,"If no image is associated with the virus, the function will return Null:"},
		PlotVirus[Model[Sample, "KSHV"]],
		Null
	],
	Example[{Options,ImageSize,"Change the size of the displayed image:"},
		PlotVirus[Model[Sample, "HPV-16"],ImageSize->200],
		_Image
	],

	(* Messages *)
	Example[{Messages,"FieldDoesntExist","If the reference images does not exist:"},
		PlotVirus[Model[Sample, "Ramp HPV18E7"],ImageSize->200],
		$Failed,
		Messages:>{Error::FieldDoesntExist}
	],

	(* Output tests *)
	Test["Setting Output to Result returns the plot:",
		PlotVirus[Model[Sample, "HPV-16"],Output->Result],
		_Image
	],

	Test["Setting Output to Preview returns the plot:",
		PlotVirus[Model[Sample, "HPV-16"],Output->Preview],
		_Image
	],

	Test["Setting Output to Options returns the resolved options:",
		PlotVirus[Model[Sample, "HPV-16"],Output->Options],
		ops_/;MatchQ[ops,OptionsPattern[PlotVirus]]
	],

	Test["Setting Output to Tests returns a list of tests:",
		PlotVirus[Model[Sample, "HPV-16"],Output->Tests],
		{(_EmeraldTest|_Example)...}
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options:",
		PlotVirus[Model[Sample, "HPV-16"],Output->{Result,Options}],
		output_List/;MatchQ[First@output,_Image]&&MatchQ[Last@output,OptionsPattern[PlotVirus]]
	],

	Test["Setting Output to Options returns all of the defined options:",
		Sort@Keys@PlotVirus[Model[Sample, "HPV-16"],Output->Options],
		Sort@Keys@SafeOptions@PlotVirus
	]

}];
