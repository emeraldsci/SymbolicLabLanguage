(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*PlotTranscript*)


DefineTests[PlotTranscript,{
	Example[{Basic,"The function will provide a visualization of a model transcript by presenting its structure (if available):"},
		PlotTranscript[Model[Sample, "E2"]],
		ListableP[_Structure]
	],
	Example[{Basic,"If the structure is not available but the RNA sequence is, a raw visualization of the unfolded RNA will be returned:"},
		PlotTranscript[Model[Sample, "Mcl-1 1"]],
		ListableP[_Structure]
	],
	Example[{Basic,"Plot a transcript molecule model:"},
		PlotTranscript[Model[Molecule, Transcript, "GAPDH"]],
		ListableP[_Structure]
	],
	Example[{Attributes,"Listable","The function is listable by transcript:"},
		PlotTranscript[{Model[Sample, "E2"],Model[Molecule, Transcript, "GAPDH"]}],
		{ListableP[_Structure]..}
	]
}];
