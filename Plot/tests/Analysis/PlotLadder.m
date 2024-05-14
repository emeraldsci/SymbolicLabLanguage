(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*PlotLadder*)


DefineTests[PlotLadder,
{
	Example[{Basic,"Plot standard object:"},
		PlotLadder[Object[Analysis, Ladder, "id:wqW9BP4Yrva9"]],
		_?ValidGraphicsQ
	],
	Example[{Additional,"Plot another standard:"},
		PlotLadder[{10->1.813333`,15->6.386667`,20->14.673333`,25->20.873333`,30->23.8`,35->27.353333`,40->28.886667`,45->31.193333`,50->32.36`,60->34.926667`}],
		_?ValidGraphicsQ
	],
	Example[{Basic,"Plot a ladder analysis link:"},
		PlotLadder[Link[Object[Analysis, Ladder, "id:wqW9BP4Yrva9"],Reference]],
		_?ValidGraphicsQ
	],
	Test["Given packet:",
		PlotLadder[Download[Object[Analysis, Ladder, "id:wqW9BP4Yrva9"]]],
		_?ValidGraphicsQ
	],

	Example[{Options,PlotType,"Plot peaks with ladder markers:"},
		PlotLadder[Object[Analysis, Ladder, "id:wqW9BP4Yrva9"],PlotType->Peaks],
		_?ValidGraphicsQ
	],
	Test["Plot peaks with ladder markers for page:",
		PlotLadder[Object[Analysis, Ladder, "id:kEJ9mqa1G3xp"], PlotType -> Peaks],
		_?ValidGraphicsQ
	],
	Example[{Options,ExpectedSize,"Specify length function using position:"},
		PlotLadder[FragmentPeaks/.Download@Object[Analysis, Ladder, "id:wqW9BP4Yrva9"],ExpectedSize->(ExpectedSize/. Download@Object[Analysis, Ladder, "id:J8AY5jwzLjjD"])],
		_?ValidGraphicsQ
	],
	Example[{Options,ExpectedPosition,"Specify length function using size:"},
		PlotLadder[FragmentPeaks/.Download@Object[Analysis, Ladder, "id:wqW9BP4Yrva9"],ExpectedPosition->(ExpectedPosition/. Download@Object[Analysis, Ladder, "id:J8AY5jwzLjjD"])],
		_?ValidGraphicsQ
	],
	Example[{Options,Display,"Specify display:"},
		PlotLadder[FragmentPeaks/.Download@Object[Analysis, Ladder, "id:wqW9BP4Yrva9"],Display->ExpectedPosition],
		_?ValidGraphicsQ
	],
	Example[{Options,PositionUnit,"Specify units for position:"},
		PlotLadder[FragmentPeaks/.Download@Object[Analysis, Ladder, "id:wqW9BP4Yrva9"],PositionUnit->Second],
		_?ValidGraphicsQ
	],
	Example[{Options,SizeUnit,"Specify units for size:"},
		PlotLadder[FragmentPeaks/.Download@Object[Analysis, Ladder, "id:wqW9BP4Yrva9"],SizeUnit->Kilo Nucleotide],
		_?ValidGraphicsQ
	],
	Example[{Options,AxesUnits,"Specify units for both axes:"},
		PlotLadder[FragmentPeaks/.Download@Object[Analysis, Ladder, "id:wqW9BP4Yrva9"],AxesUnits->{Second,Kilo Nucleotide}],
		_?ValidGraphicsQ
	],
	Example[{Additional,"Specify length function and display:"},
		PlotLadder[FragmentPeaks/.Download@Object[Analysis, Ladder, "id:wqW9BP4Yrva9"],ExpectedSize->(ExpectedSize/. Download@Object[Analysis, Ladder, "id:J8AY5jwzLjjD"]),Display->ExpectedPosition],
		_?ValidGraphicsQ
	]
}];


(* ::Section:: *)
(*End Test Package*)
