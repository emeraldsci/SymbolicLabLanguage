(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Sequence: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*P's & Q's*)


(* ::Subsubsection:: *)
(*ValidSequenceQ*)


DefineTests[ValidSequenceQ,{

	Example[{Basic,"Tests if a given input is a oligomer sequence:"},
		ValidSequenceQ["ATGATA"],
		True
	],
	Example[{Basic,"Works on any polymer type including RNA:"},
		ValidSequenceQ["AUGUCUAC"],
		True
	],
	Example[{Basic,"Or even peptides:"},
		ValidSequenceQ["HisHisLysArgArg"],
		True
	],
	Example[{Basic,"But will return false for anything that's not a known oligomer sequence:"},
		ValidSequenceQ["ABCDEFGHIJKLMNOP"],
		False
	],

	Example[{Additional,"Can recognize both explicitly and implicitly typed sequences:"},
		ValidSequenceQ[DNA["ATGATA"]],
		True
	],
	Example[{Additional,"Named motifs are accepted by sequence as well:"},
		ValidSequenceQ[DNA["ATGATA","X"]],
		True
	],
	Example[{Additional,"Numeric sequences are also OK:"},
		ValidSequenceQ[DNA[5]],
		True
	],

	Example[{Options,Polymer,"Providing the polymer type will test of the sequence is composed of only Monomers in the polymer's alphabet:"},
		ValidSequenceQ["ATGCATA",Polymer->DNA],
		True
	],
	Example[{Options,Polymer,"If the provided type doesn't match the sequence, ValidSequenceQ will return false:"},
		ValidSequenceQ["ATGCATA",Polymer->RNA],
		False
	],
	Example[{Options,Polymer,"Works with explicitly typed sequence as well:"},
		ValidSequenceQ[RNA["AUGAC"],Polymer->RNA],
		True
	],
	Example[{Options,Polymer,"Peptides for instance work as well:"},
		ValidSequenceQ["LysHisArgLysArg",Polymer->Peptide],
		True
	],
	Example[{Options,Exclude,"Exclude takes a list of Monomers that should not be permitted in the sequence:"},
		ValidSequenceQ["ATGATAC",Exclude->{"A"}],
		False
	],
	Example[{Options,Exclude,"Exclude takes a list of Monomers that should not be permitted in the sequence:"},
		ValidSequenceQ["TGCTT",Exclude->{"A"}],
		True
	],
	Example[{Options,Degeneracy,"If Degeneracy is set to true then degenerate Monomers will be permitted in the sequence:"},
		ValidSequenceQ["ATGNNNN",Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"If Degeneracy is set to false, then degenerate Monomers will not be permitted in the sequence:"},
		ValidSequenceQ["ATGNNNN",Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Numeric sequences are rejected when Degeneracy is set to False:"},
		ValidSequenceQ[DNA[5],Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Numeric sequences are accepted when Degeneracy is set to True:"},
		ValidSequenceQ[DNA[5],Degeneracy->True],
		True
	],
	Example[{Options,AlternativeEncodings,"Alternative coding alphabets for the polymer will be checked when AlternativeEncodings is set to True:"},
		ValidSequenceQ[Peptide["CATHERINE"],AlternativeEncodings->True],
		True
	],
	Example[{Options,AlternativeEncodings,"If AlternativeEncodings is set to False, then alternative coding alphabets for the polymer will not be permitted in the sequence:"},
		ValidSequenceQ[Peptide["CATHERINE"],AlternativeEncodings->False],
		False
	],

	Example[{Attributes,Listable,"List input:"},
		ValidSequenceQ[{"ATGATA",RNA["AUGUCU"],DNA["GCAGAT"]}],
		{True,True,True}
	],
	Example[{Attributes,Listable,"List input with polymer option:"},
		ValidSequenceQ[{"ATGATA",RNA["AUGUCU"],DNA["GCAGAT"]},Polymer->DNA],
		{True,False,True}
	]


}];



(* ::Subsection:: *)
(*Motif*)


(* ::Subsubsection::Closed:: *)
(*MotifPolymer*)


DefineTests[MotifPolymer,{

	Example[{Basic,"Pull polymer type from a motif:"},
		MotifPolymer[DNA["ATCG"]],
		DNA
	],
	Example[{Basic,"Pull polymer type from a motif with a label:"},
		MotifPolymer[DNA["ATCG","Label"]],
		DNA
	],
	Example[{Basic,"Pull polymer type from a peptide motif:"},
		MotifPolymer[Peptide["LysHisArg"]],
		Peptide
	]


}];


(* ::Subsubsection::Closed:: *)
(*MotifSequence*)


DefineTests[MotifSequence,{

	Example[{Basic,"Pull sequence from a motif:"},
		MotifSequence[DNA["ATCG"]],
		"ATCG"
	],
	Example[{Basic,"Pull sequence from a motif with a label:"},
		MotifSequence[DNA["ATCG","Label"]],
		"ATCG"
	],
	Example[{Basic,"Pull sequence from a peptide motif:"},
		MotifSequence[Peptide["LysHisArg"]],
		"LysHisArg"
	]


}];


(* ::Subsubsection::Closed:: *)
(*MotifLabel*)


DefineTests[MotifLabel,{

	Example[{Basic,"Pull label from a motif:"},
		MotifLabel[DNA["ATCG","Label"]],
		"Label"
	],
	Example[{Basic,"Given motif with no label, returns empty string:"},
		MotifLabel[DNA["ATCG"]],
		""
	],
	Example[{Basic,"Pull label from a peptide motif:"},
		MotifLabel[Peptide["LysHisArg","Harold"]],
		"Harold"
	]


}];


(* ::Subsubsection:: *)
(*ValidMotifQ*)


DefineTests[ValidMotifQ,{

	Example[{Basic,"Tests if a given input is a DNA motif:"},
		ValidMotifQ[DNA["ATGATA"]],
		True
	],
	Example[{Basic,"Works on any polymer type including RNA:"},
		ValidMotifQ[RNA["AUGUCUAC"]],
		True
	],
	Example[{Basic,"Or even peptides:"},
		ValidMotifQ[Peptide["LysHis"]],
		True
	],
	Example[{Basic,"But will return false for anything that's not a known DNA motif:"},
		ValidMotifQ[DNA["ABCDEFGHIJKLMNOP"]],
		False
	],

	Example[{Additional,"Named motifs are accepted by sequence as well:"},
		ValidMotifQ[DNA["ATGATA","X"]],
		True
	],
	Example[{Additional,"Numeric motifs are also OK:"},
		ValidMotifQ[DNA[5]],
		True
	],

	Example[{Options,Polymer,"Providing the polymer type will test of the motif is composed of only Monomers in the polymer's alphabet:"},
		ValidMotifQ[DNA["ATGCATA"],Polymer->DNA],
		True
	],
	Example[{Options,Polymer,"If the provided type doesn't match the sequence, ValidMotifQ will return false:"},
		ValidMotifQ[DNA["ATGCATA"],Polymer->RNA],
		False
	],
	Example[{Options,Polymer,"Works with explicitly typed sequence as well:"},
		ValidMotifQ[RNA["AUGAC"],Polymer->RNA],
		True
	],
	Example[{Options,Polymer,"Peptides for instance work as well:"},
		ValidMotifQ[Peptide["LysHisArgLysArg"],Polymer->Peptide],
		True
	],
	Example[{Options,Exclude,"Exclude takes a list of Monomers that should not be permitted in the motif:"},
		ValidMotifQ[DNA["ATGATAC"],Exclude->{"A"}],
		False
	],
	Example[{Options,Exclude,"Exclude takes a list of Monomers that should not be permitted in the motif:"},
		ValidMotifQ[DNA["TGCTT"],Exclude->{"A"}],
		True
	],
	Example[{Options,Degeneracy,"If Degeneracy is set to true then degenerate Monomers will be permitted in the motif:"},
		ValidMotifQ[DNA["ATGNNNN"],Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"If Degeneracy is set to false, then degenerate Monomers will not be permitted in the motif:"},
		ValidMotifQ[DNA["ATGNNNN"],Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Numeric sequences are rejected when Degeneracy is set to False:"},
		ValidMotifQ[DNA[5],Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Numeric sequences are accepted when Degeneracy is set to True:"},
		ValidMotifQ[DNA[5],Degeneracy->True],
		True
	],
	Example[{Options,AlternativeEncodings,"Alternative coding alphabets for the polymer will be checked when AlternativeEncodings is set to True:"},
		ValidMotifQ[Peptide["CATHERINE"],AlternativeEncodings->True],
		True
	],
	Example[{Options,AlternativeEncodings,"If AlternativeEncodings is set to False, then alternative coding alphabets for the polymer will not be permitted in the motif:"},
		ValidMotifQ[Peptide["CATHERINE"],AlternativeEncodings->False],
		False
	],

	Example[{Attributes,Listable,"List input:"},
		ValidMotifQ[{DNA["ATGATA"],RNA["AUGUCU"],DNA["GCAGAT"]}],
		{True,True,True}
	],
	Example[{Attributes,Listable,"List input with polymer option:"},
		ValidMotifQ[{DNA["ATGATA"],RNA["AUGUCU"],DNA["GCAGAT"]},Polymer->DNA],
		{True,False,True}
	]


}];



(* ::Section:: *)
(*End Test Package*)
