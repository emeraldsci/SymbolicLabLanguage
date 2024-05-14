(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*PlotProtein*)


DefineTests[PlotProtein,{
	Example[{Basic,"Visualize the structure of one model[Protein] object:"},
		PlotProtein[Model[Sample, "A2M"]],
		_?ValidGraphicsQ
	],
	Example[{Basic,"Visualize the structure of one ProteinData name of a protein:"},
		PlotProtein["2poi"],
		_?ValidGraphicsQ
	],
	Test["Visualize the structure of one model[Protein] object:",
		PlotProtein[Model[Sample, "A2M"]],
		_?ValidGraphicsQ
	],
	Example[{Attributes,"Listable","Visualize the structure of a list of model[Protein] objects:"},
		PlotProtein[{Model[Sample, "A2M"], Model[Molecule,Protein, "Bak"]}],
		{_?ValidGraphicsQ..}
	],
	Example[{Attributes,"Listable","Visualize the structure of a list of ProteinData names:"},
		PlotProtein[{"1bv8","2poi"}],
		{_?ValidGraphicsQ..}
	],
	Example[{Options,ImageSize,"Specify the image size:"},
		PlotProtein[Model[Sample, "A2M"],ImageSize->900],
		_?ValidGraphicsQ
	],
	Example[{Messages,"IncompleteInfo","The model[Protein] object should contain the ProteinData information:"},
		PlotProtein[Model[Sample, "GFP"]],
		Null,
		Messages:>{PlotProtein::IncompleteInfo,Error::InvalidInput}
	],
	Example[{Messages,"InvalidPDBID","The provided PDB Object must be valid:"},
		PlotProtein["cat"],
		Null,
		Messages:>{PlotProtein::InvalidPDBID,Error::InvalidInput}
	],
	Test["Given link:",
		PlotProtein[Link[Model[Sample, "A2M"],Reference]],
		_?ValidGraphicsQ
	],
	Test["Given packet:",
		PlotProtein[Download[Model[Sample, "A2M"]]],
		_?ValidGraphicsQ
	]
}];
