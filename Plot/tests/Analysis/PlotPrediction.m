(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*PlotPrediction*)


DefineTests[PlotPrediction,{

	Example[{Basic,"Plot predicted y-value from fixed x-value:"},
		PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter],
		ValidGraphicsP[]
	],
	Example[{Basic,"Plot predicted y-value from uncertain x-value:"},
		PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],NormalDistribution[2.5,0.05]],
		ValidGraphicsP[]
	],

	(* Options *)
	Example[{Options,ConfidenceLevel,"Display 67% confidence interval:"},
		PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,ConfidenceLevel->67Percent],
		ValidGraphicsP[]
	],

	Example[{Options,Display,"Display PredictionInterval:"},
		PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,Display->PredictionInterval],
		ValidGraphicsP[]
	],

	Example[{Options,Frame,"Display without frames:"},
		PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,Frame->False],
		ValidGraphicsP[]
	],

	Example[{Options,LabelStyle,"Display with italic plot labels:"},
		PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,LabelStyle->{Italic,FontFamily->"Arial"}],
		ValidGraphicsP[]
	],

	Example[{Options,Direction,"Specifies whether the direction of the prediction is forward (predict y-value for a given x-value) or inverse (prediction x-value for a given y-value):"},
		PlotPrediction[Object[Analysis, Fit, "id:1ZA60vwODJnM"],0.5*Meter,Direction->Inverse],
		ValidGraphicsP[]
	],

	Example[{Options,PredictionMethod,"Display with setting the prediction method used for inverse prediction:"},
		PlotPrediction[Object[Analysis, Fit, "id:1ZA60vwODJnM"],0.5*Meter,Direction->Inverse,PredictionMethod->Mean],
		ValidGraphicsP[]
	],

	Example[{Options,TargetUnits,"Specify the target units which affect the frame label:"},
		PlotPrediction[Object[Analysis, Fit, "id:o1k9jAKp3b7E"],1.5*Inch,TargetUnits->{Inch, Milliliter},PredictionMethod->Mean],
		ValidGraphicsP[]
	],

	Example[{Options,PlotRangeClipping,"Specifies whether graphics objects should be clipped at the edge of the region defined by PlotRange, or should be allowed to extend to the actual edge of the image:"},
		PlotPrediction[Object[Analysis, Fit, "id:eGakld09W8bq"],35,PlotRangeClipping->False],
		ValidGraphicsP[]
	],

	Example[{Options,ImageSize,"Size of the plot:"},
		Table[PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2*Centimeter,ImageSize->size],{size,{200,500}}],
		ConstantArray[ValidGraphicsP[],2]
	],

	Example[{Options,Joined,"Specifies whether points in each dataset should be joined into a line, or should be plotted as separate points:"},
		PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],1.5*Centimeter,Joined->True],
		ValidGraphicsP[]
	],

	Example[{Options,Legend,"Specify if the legend should be shown for the plot:"},
		PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],1.5*Centimeter,Legend->False],
		ValidGraphicsP[]
	],

	(* PlotStyle *)
	Example[{Options,PlotStyle,"Plot the fit:"},
		PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,PlotStyle->Fit],
		ValidGraphicsP[]
	],
	Example[{Options,PlotStyle,"Plot the error:"},
		PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,PlotStyle->Error],
		ValidGraphicsP[]
	],

	(* Tests *)
	Test["Given packet:",
		PlotPrediction[Download[Object[Analysis, Fit, "id:R8e1PjRDze7K"]],2.5*Centimeter],
		ValidGraphicsP[]
	],

	Test["Given link:",
		PlotPrediction[Link[Object[Analysis, Fit, "id:R8e1PjRDze7K"],Reference],2.5*Centimeter],
		ValidGraphicsP[]
	],

	Test[
		"Setting Output to Preview displays the image:",
		PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,Output->Preview],
		ValidGraphicsP[]
	],

	Test[
		"Setting Output to Options returns the resolved options:",
		PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,Output->Options],
		ops_/;MatchQ[ops,OptionsPattern[PlotPrediction]]
	],

	Test[
		"Setting Output to Tests returns a list of tests or Null if it is empty:",
		PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,Output->Tests],
		{(_EmeraldTest|_Example)...}|Null
	],

	Test[
		"Setting Output to {Result,Options} displays the image and returns all resolved options:",
		PlotPrediction[Object[Analysis, Fit, "id:R8e1PjRDze7K"],2.5*Centimeter,Output->{Result,Options}],
		output_List/;MatchQ[First@output,ValidGraphicsP[]]&&MatchQ[Last@output,OptionsPattern[PlotPrediction]]
	]

}];
