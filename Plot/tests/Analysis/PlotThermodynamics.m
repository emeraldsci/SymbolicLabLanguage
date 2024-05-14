(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*PlotThermodynamics*)


DefineTests[PlotThermodynamics,{

	(* Basic *)
	Example[
		{Basic,"Plot a thermodynamics analysis object:"},
		PlotThermodynamics[Object[Analysis,Thermodynamics,"id:R8e1PjRvkRVd"]],
		ValidGraphicsP[]
	],
	Example[
		{Basic,"Plot a thermodynamics analysis object with only fitted curve and no errorbars:"},
		PlotThermodynamics[Object[Analysis,Thermodynamics,"id:R8e1PjRvkRVd"],Display->{Fit}],
		ValidGraphicsP[]
	],
	Example[
		{Basic,"Can take any PlotFit option:"},
		PlotThermodynamics[Object[Analysis,Thermodynamics,"id:R8e1PjRvkRVd"],PlotLabel->"van't Hoff Plot of Object[Analysis, Thermodynamics, \"id:R8e1PjRvkRVd \"]"],
		ValidGraphicsP[]
	],

	Example[
		{Attributes,"Listable","Plot a list of thermodynamics analysis info objects:"},
		PlotThermodynamics[{Object[Analysis,Thermodynamics,"id:R8e1PjRvkRVd"],Object[Analysis,Thermodynamics,"id:R8e1PjRvkRVd"]}],
		{ValidGraphicsP[],ValidGraphicsP[]}
	],
	Example[
		{Messages,"NoFit","If no fit is available in the object, an error is thrown:"},
		PlotThermodynamics[Association[{Type->Object[Analysis,Thermodynamics]}]],
		$Failed,
		Messages:>{Error::NoFit}
	],

	(* Tests *)
	Test[
		"Given a link:",
		PlotThermodynamics[Link[Object[Analysis,Thermodynamics,"id:R8e1PjRvkRVd"],Reference]],
		ValidGraphicsP[]
	],
	Test[
		"Given a packet:",
		PlotThermodynamics[Download[Object[Analysis,Thermodynamics,"id:R8e1PjRvkRVd"]]],
		ValidGraphicsP[]
	],

	Test[
		"Setting Output to Preview displays the image:",
		PlotThermodynamics[Object[Analysis,Thermodynamics,"id:R8e1PjRvkRVd"],Output->Preview],
		ValidGraphicsP[]
	],

	Test[
		"Setting Output to Options returns the resolved options:",
		PlotThermodynamics[Object[Analysis,Thermodynamics,"id:R8e1PjRvkRVd"],Output->Options],
		ops_/;MatchQ[ops,OptionsPattern[PlotThermodynamics]]
	],

	Test[
		"Setting Output to Tests returns a list of tests or Null if it is empty:",
		PlotThermodynamics[Object[Analysis,Thermodynamics,"id:R8e1PjRvkRVd"],Output->Tests],
		{(_EmeraldTest|_Example)...}|Null
	],

	Test[
		"Setting Output to {Result,Options} displays the image and returns all resolved options:",
		PlotThermodynamics[Object[Analysis,Thermodynamics,"id:R8e1PjRvkRVd"],Output->{Result,Options}],
		output_List/;MatchQ[First@output,ValidGraphicsP[]]&&MatchQ[Last@output,OptionsPattern[PlotThermodynamics]]
	]

}];
