(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Strand: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Sequence Manipulation*)


(* ::Subsubsection:: *)
(*resolveSequence*)


DefineTests[NucleicAcids`Private`resolveSequence,{
	Example[{Basic,"It can resolve any given sequence to its corresponding typed sequence, defaults to DNA:"},
		NucleicAcids`Private`resolveSequence[{"ATCGG", "UUCGA", DNA["ATTCG"], "LysHis"}, f],
		{DNA["ATCGG"],RNA["UUCGA"],DNA["ATTCG"],Peptide["LysHis"]}
	],
	Example[{Basic,"If the motif name is present, it will preserve the name:"},
		NucleicAcids`Private`resolveSequence[{"ATCGG", RNA["UUCGA"], DNA["ATTCG", "A"], "LysHis"}, f],
		{DNA["ATCGG"],RNA["UUCGA"],DNA["ATTCG","A"],Peptide["LysHis"]}
	],
	Example[{Basic,"If the motif name is present, it will preserve the name:"},
		NucleicAcids`Private`resolveSequence[{"ATCGG", RNA["UUCGA"], DNA["ATTCG", "A"], "LysHis"}, f],
		{DNA["ATCGG"],RNA["UUCGA"],DNA["ATTCG","A"],Peptide["LysHis"]}
	],
	Example[{Options,Polymer,"Polymer option can be supplied to specify the type:"},
		NucleicAcids`Private`resolveSequence["CGGCA", f, Polymer->RNA],
		RNA["CGGCA"]
	],
	Example[{Options,FastTrack,"(always resolve now) If FastTrack goes to true, will not resolve and will directly return the raw input:"},
		NucleicAcids`Private`resolveSequence[{"ATCGG", RNA["UUCGA"], DNA["ATTCG", "A"], "LysHis"}, f, FastTrack->True],
		{DNA["ATCGG"],RNA["UUCGA"],DNA["ATTCG","A"],Peptide["LysHis"]}
	],
	Example[{Messages,"missMatchPolymer","Return Failed if cannot be resolved due to mismatching types:"},
		NucleicAcids`Private`resolveSequence[DNA["AUUCG"], f],
		$Failed,
		Messages:>Message[f::missMatchPolymer, ToString[DNA["AUUCG"]], "DNA"]
	],
	Example[{Messages,"missMatchPolymer","Return Failed if cannot be resolved due to mismatching the given polymer type:"},
		NucleicAcids`Private`resolveSequence["ATTCG", f, Polymer->RNA],
		$Failed,
		Messages:>Message[f::missMatchPolymer, "ATTCG", "RNA"]
	],
	Example[{Messages,"unknownPolymer","Return Failed if the polymer type is unknown:"},
		NucleicAcids`Private`resolveSequence[UNA["ATTCGH"], f],
		$Failed,
		Messages:>Message[f::unknownPolymer, UNA["ATTCGH"]]
	],
	Test["Any input remains unevaluated if not providing a certain function:",
		NucleicAcids`Private`resolveSequence[Fish],
		_NucleicAcids`Private`resolveSequence
	],
	Test["Any input remains unevaluated if not providing a certain function:",
		NucleicAcids`Private`resolveSequence["ATCGC"],
		_NucleicAcids`Private`resolveSequence
	]
}];


(* ::Subsubsection:: *)
(*SequenceQ*)


DefineTests[SequenceQ,{
	Example[{Basic,"Tests if a given input is a oligomer sequence:"},
		SequenceQ["ATGATA"],
		True
	],
	Example[{Basic,"Works on any polymer type including RNA:"},
		SequenceQ["AUGUCUAC"],
		True
	],
	Example[{Basic,"Or even peptides:"},
		SequenceQ["HisHisLysArgArg"],
		True
	],
	Example[{Basic,"But will return false for anything that's not a known oligomer sequence:"},
		SequenceQ["Taco"],
		False
	],
	Example[{Additional,"Can recognize both explicitly and implicitly typed sequences:"},
		SequenceQ[DNA["ATGATA"]],
		True
	],
	Example[{Additional,"Named motifs are accepted by sequence as well:"},
		SequenceQ[DNA["ATGATA","X"]],
		True
	],
	Example[{Additional,"Numeric sequences are also OK:"},
		SequenceQ[DNA[5]],
		True
	],
	Example[{Options,Polymer,"Providing the polymer type will test of the sequence is composed of only Monomers in the polymer's alphabet:"},
		SequenceQ["ATGCATA",Polymer->DNA],
		True
	],
	Example[{Options,Polymer,"If the provided type doesn't match the sequence, SequenceQ will return false:"},
		SequenceQ["ATGCATA",Polymer->RNA],
		False
	],
	Example[{Options,Polymer,"Works with explicitly typed sequence as well:"},
		SequenceQ[RNA["AUGAC"],Polymer->RNA],
		True
	],
	Example[{Options,Polymer,"Peptides for instance work as well:"},
		SequenceQ["LysHisArgLysArg",Polymer->Peptide],
		True
	],
	Example[{Options,Exclude,"Exclude takes a list of Monomers that should not be permitted in the sequence:"},
		SequenceQ["ATGATAC",Exclude->{"A"}],
		False
	],
	Example[{Options,Exclude,"Exclude takes a list of Monomers that should not be permitted in the sequence:"},
		SequenceQ["TGCTT",Exclude->{"A"}],
		True
	],
	Example[{Options,Degeneracy,"If Degeneracy is set to true then degenerate Monomers will be permitted in the sequence:"},
		SequenceQ["ATGNNNN",Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"If Degeneracy is set to false, then degenerate Monomers will not be permitted in the sequence:"},
		SequenceQ["ATGNNNN",Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Numeric sequences are rejected when Degeneracy is set to False:"},
		SequenceQ[DNA[5],Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Numeric sequences are accepted when Degeneracy is set to True:"},
		SequenceQ[DNA[5],Degeneracy->True],
		True
	],
	Example[{Options,AlternativeEncodings,"Alternative coding alphabets for the polymer will be checked when AlternativeEncodings is set to True:"},
		SequenceQ[Peptide["CATHERINE"],AlternativeEncodings->True],
		True
	],
	Example[{Options,AlternativeEncodings,"If AlternativeEncodings is set to False, then alternative coding alphabets for the polymer will not be permitted in the sequence:"},
		SequenceQ[Peptide["CATHERINE"],AlternativeEncodings->False],
		False
	],
	Example[{Options,Map,"If Map is set to True, listable behavior works as normal:"},
		SequenceQ[{DNA["ATGCATA"],RNA["AUGUCUA"],DNA["TGGTT"]},Map->True],
		{True,True,True}
	],
	Example[{Options,Map,"If Map is set to False, will test to see if all of the sequences are of the same polymer:"},
		SequenceQ[{DNA["ATGCATA"],DNA["ATGTCTA"],DNA["TGGTT"]},Map->False],
		True
	],
	Example[{Options,Map,"If Map is set to False, will test to see if all of the sequences are of the same polymer:"},
		SequenceQ[{DNA["ATGCATA"],RNA["AUGUCUA"],DNA["TGGTT"]},Map->False],
		False
	],
	Example[{Attributes,"Listable","The Function is listable:"},
		SequenceQ[{"ATGATA",RNA["AUGUCU"],DNA["GCAGAT"]}],
		{True,True,True}
	],
	Example[{Attributes,"Listable","The function is listable:"},
		SequenceQ[{"ATGATA",RNA["AUGUCU"],DNA["GCAGAT"]},Polymer->DNA],
		{True,False,True}
	],
	Test["Testing FastTrack definition:",
		SequenceQ["ATGCATGATA",FastTrack->True],
		True
	],
	Test["Testing FastTrack definition ignores the internals of strings:",
		SequenceQ["Cats",FastTrack->True],
		True
	],
	Test["Testing FastTrack with Explicitly typed sequences:",
		SequenceQ[DNA["ATGCATGATA"],FastTrack->True],
		True
	],
	Test["Numeric sequences are also accepted by FastTrack:",
		SequenceQ[DNA[5],FastTrack->True],
		True
	],
	Test["Map works with named Motifs:",
		SequenceQ[{DNA["ATGCAGA","A"],DNA["GGCAGA","B"]},Map->False],
		True
	]
}];


(* ::Subsubsection::Closed:: *)
(*SameSequenceQ*)


DefineTests[SameSequenceQ,{
	Example[{Basic,"Tests to see if two sequence are the same sequences:"},
		SameSequenceQ["ATGCA","ATGCA"],
		True
	],
	Example[{Basic,"Tests to see if two sequence could be the same sequences:"},
		SameSequenceQ["ATGCA","ANNCA"],
		True
	],
	Example[{Basic,"If provided a list of sequences, checks to see if they could all be the same sequence:"},
		SameSequenceQ[{"ATGCA",DNA["ATGCA"],"ANNCA","ATGCA"}],
		True
	],
	Example[{Basic,"Tests to see if two sequence could be the same sequences:"},
		SameSequenceQ[DNA[4],"TGCA"],
		True
	],
	Example[{Basic,"Tests to see if two sequence could be the same sequences:"},
		SameSequenceQ[DNA["NNN"],"YNY"],
		True
	],
	Example[{Additional,"Tests to see if two modifications could be the same sequences:"},
		SameSequenceQ[Modification["TamraDabcyl"],"TamraDabcyl"],
		True
	],
	Example[{Options,Polymer,"Polymer option much match the input sequences:"},
		SameSequenceQ["GCACA","GCACA",Polymer->RNA],
		True
	],
	Example[{Options,Degeneracy,"Degeneracy option set to true will check to see if degenrate sequences could be the same:"},
		SameSequenceQ["GCACA","GCNCA",Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"Degeneracy option set to false will not accept degenerate Monomers:"},
		SameSequenceQ["GCACA","GCNCA",Degeneracy->False],
		False
	]

}];


(* ::Subsubsection:: *)
(*DNAQ*)


DefineTests[DNAQ,{
	Example[{Basic,"Works on untyped sequences:"},
		DNAQ["ATGATA"],
		True
	],
	Example[{Basic,"Checks to ensure the monomes used only Monomers in the polymer alphabet:"},
		DNAQ["AUGATU"],
		False
	],
	Example[{Additional,"These are also not the correct type:"},
		DNAQ["LysHis"],
		False
	],
	Test["Non polymers should fail:",
		DNAQ["Fish"],
		False
	],
	Example[{Additional,"Works on explicitly typed sequences as well:"},
		DNAQ[DNA["ATGATA"]],
		True
	],
	Example[{Additional,"Regardless of motif names:"},
		DNAQ[DNA["ATGATA","B"]],
		True
	],
	Test["If the explicitly type doesnt match the Monomers DNAQ will return false:",
		DNAQ[RNA["ATGATA"]],
		False
	],
	Example[{Attributes,"Listable","The function is listable:"},
		DNAQ[{"ATGATA",DNA["ATATAGACA"],"GTAGAC","GGAGACTT"}],
		{True,True,True,True}
	],
	Test["Listable with non polymers:",
		DNAQ[{"ATGCAT","AUGUC","FISH"}],
		{True,False,False}
	],
	Example[{Options,Degeneracy,"Can accomidate degeneracy in the sequence:"},
		DNAQ[DNA["NNNN"]],
		True
	],
	Test["Degeneracy works with implicitly typed sequences:",
		DNAQ["NNNN"],
		True
	],
	Test["Listable degeneracy:",
		DNAQ[{"NNNN","NN",DNA["NNNNN"],DNA[12]}],
		{True,True,True,True}
	],
	Test["Degeneracy off still accepts non degenerate sequences:",
		SequenceQ[DNA["ATGACA"],Degeneracy->False],
		True
	],
	Test["More degeneracy tests with implicity typing:",
		SequenceQ["ATGACA",Degeneracy->False],
		True
	],
	Example[{Options,Degeneracy,"Degeneracy option allows for degenerate sequences:"},
		DNAQ[DNA[12],Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"Degeneracy set to false will not accept numeric sequences:"},
		DNAQ[DNA[12],Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Degeneracy set to false does not accept any degnerate bases in the sequence:"},
		DNAQ[DNA["ATGACANN"],Degeneracy->False],
		False
	],
	Test["Checking for degeneracy:",
		SequenceQ["ATGACNA",Degeneracy->False],
		False
	],
	Example[{Basic,"Overloaded to work on strands as well using StrandQ:"},
		DNAQ[Strand[DNA["ATGTATAGAGAT"]]],
		True
	],
	Example[{Basic,"Checks that all the sequences in the Strand are the correct type:"},
		DNAQ[Strand[DNA["ATGTATAGAGAT"],DNA["AGCATGG"]]],
		True
	],
	Example[{Options,CheckMotifs,"Check motifs checks that the sequences set by the motifs match:"},
		DNAQ[Strand[DNA["ATGATAG","A"],DNA["ATGATAG","A"],DNA[20,"B"],DNA["CTATCAT","A'"]],CheckMotifs->True],
		True
	],
	Test["Checks the Strand for polymer type:",
		DNAQ[Strand[RNA["ACGUAUCUCA"]]],
		False
	],
	Test["Even if internal sequence matches type, if the explicit type doesn't match it will be rejected:",
		DNAQ[Strand[PNA["ATGTATAGAGAT"]]],
		False
	],
	Example[{Options,Exclude,"Exclude option used to not examine polymer types in the context of strands:"},
		DNAQ[Strand[DNA["ATGTATAGAGAT"],Modification["Dabcyl"]],Exclude->Modification],
		True
	],
	Example[{Options,Exclude,"If Exclude is left blank, will strictly except only the matching polymer type:"},
		DNAQ[Strand[DNA["ATGTATAGAGAT"],Modification["Dabcyl"]],Exclude->{}],
		False
	],
	Example[{Options,Polymer,"Polymer type is given:"},
		DNAQ["CCGGC",Polymer->DNA],
		True
	],
	Example[{Options,Map,"Test on each sequence:"},
		DNAQ[{"CCGGC", "ATCGU"},Map->True],
		{True,False}
	],
	Example[{Options,Map,"Test each sequence and return one combined result:"},
		DNAQ[{"CCGGC", "ATCGU"},Map->False],
		False
	],
	Example[{Options,AlternativeEncodings,"Alternative coding alphabets for the polymer will be checked when AlternativeEncodings is set to True:"},
		DNAQ[DNA["CCGTa"],AlternativeEncodings->True],
		True
	],
	Example[{Options,AlternativeEncodings,"If AlternativeEncodings is set to False, then alternative coding alphabets for the polymer will not be permitted in the sequence:"},
		DNAQ[DNA["CCGTa"],AlternativeEncodings->False],
		False
	],
	Test["Works with strands where the motifs are named:",
		DNAQ[Strand[DNA["ATGTATAGAGAT","A"],DNA["AGCAGCCACA","B"],Modification["Dabcyl"]]],
		True
	]
}];


(* ::Subsubsection:: *)
(*RNAQ*)


DefineTests[RNAQ,{
	Example[{Basic,"Works on untyped sequences:"},
		RNAQ["AUGAUA"],
		True
	],
	Example[{Basic,"Checks to ensure the monomes used only Monomers in the polymer alphabet:"},
		RNAQ["AUGATU"],
		False
	],
	Example[{Basic,"These are also not the correct type:"},
		RNAQ["LysHis"],
		False
	],
	Test["Non polymers should fail:",
		RNAQ["Fish"],
		False
	],
	Example[{Additional,"Works on explicitly typed sequences as well:"},
		RNAQ[RNA["AUGAUA"]],
		True
	],
	Example[{Additional,"Regardless of motif names:"},
		RNAQ[RNA["AUGAUA","B"]],
		True
	],
	Test["If the explicitly type doesnt match the Monomers DNAQ will return false:",
		RNAQ[DNA["AUGAUA"]],
		False
	],
	Example[{Attributes,"Listable","The function is listable:"},
		RNAQ[{"AUGAUA",RNA["AUAUAGACA"],"GUAGAC","GGAGACUU"}],
		{True,True,True,True}
	],
	Test["Listable with non polymers:",
		RNAQ[{"AUGCAU","ATGTC","FISH"}],
		{True,False,False}
	],
	Example[{Options,Degeneracy,"Can accomidate degeneracy in the sequence:"},
		RNAQ[RNA["NNNN"]],
		True
	],
	Test["Degeneracy works with implicitly typed sequences:",
		RNAQ["NNNN"],
		True
	],
	Test["Listable degeneracy:",
		RNAQ[{"NNNN","NN",RNA["NNNNN"],RNA[12]}],
		{True,True,True,True}
	],
	Example[{Options,Degeneracy,"Degeneracy option allows for degenerate sequences:"},
		RNAQ[RNA[12],Degeneracy->True],
		True
	],
	Example[{Options,"Degeneracy set to false will not accept numeric sequences:"},
		RNAQ[RNA[12],Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Degeneracy set to false does not accept any degnerate bases in the sequence:"},
		RNAQ[RNA["AUGACANN"],Degeneracy->False],
		False
	],
	Example[{Options,CheckMotifs,"Check motifs checks that the sequences set by the motifs match:"},
		RNAQ[Strand[RNA["AUGAUAG","A"],RNA["AUGAUAG","A"],RNA[20,"B"],RNA["CUAUCAU","A'"]],CheckMotifs->True],
		True
	],
	Example[{Basic,"Overloaded to work on strands as well using StrandQ:"},
		RNAQ[Strand[RNA["AUGUAUAGAGAU"]]],
		True
	],
	Example[{Basic,"Checks that all the sequences in the Strand are the correct type:"},
		RNAQ[Strand[RNA["AUGUAUAGAGAU"],RNA["AGCAUGG"]]],
		True
	],
	Test["Checks the Strand for polymer type:",
		RNAQ[Strand[DNA["ACGUAUCUCA"]]],
		False
	],
	Example[{Options,Exclude,"Exclude option used to not examine polymer types in the context of strands:"},
		RNAQ[Strand[RNA["AUGUAUAGAGAU"],Modification["Dabcyl"]],Exclude->Modification],
		True
	],
	Example[{Options,Exclude,"If Exclude is left blank, will strictly except only the matching polymer type:"},
		RNAQ[Strand[RNA["AUGUAUAGAGAU"],Modification["Dabcyl"]],Exclude->{}],
		False
	],
	Example[{Options,Polymer,"Polymer type is given:"},
		RNAQ["CCGGC",Polymer->RNA],
		True
	],
	Example[{Options,Map,"Test on each sequence:"},
		RNAQ[{"CCGGC", "ATCGU"},Map->True],
		{True,False}
	],
	Example[{Options,Map,"Test each sequence and return one combined result:"},
		RNAQ[{"CCGGC", "ATCGU"},Map->False],
		False
	],
	Example[{Options,AlternativeEncodings,"Alternative coding alphabets for the polymer will be checked when AlternativeEncodings is set to True:"},
		RNAQ[RNA["CCGUa"],AlternativeEncodings->True],
		True
	],
	Example[{Options,AlternativeEncodings,"If AlternativeEncodings is set to False, then alternative coding alphabets for the polymer will not be permitted in the sequence:"},
		RNAQ[RNA["CCGUa"],AlternativeEncodings->False],
		False
	],
	Test["Works with strands where the motifs are named:",
		RNAQ[Strand[RNA["AUGUAUAGAGAU","A"],RNA["AGCAGCCACA","B"],Modification["Dabcyl"]]],
		True
	]
}];


(* ::Subsubsection:: *)
(*PNAQ*)


DefineTests[PNAQ,{
	Example[{Basic,"Works on untyped sequences:"},
		PNAQ["ATGATA"],
		True
	],
	Example[{Basic,"Checks to ensure the monomes used only Monomers in the polymer alphabet:"},
		PNAQ["AUGATU"],
		False
	],
	Example[{Basic,"These are also not the correct type:"},
		PNAQ["LysHis"],
		False
	],
	Test["Non polymers should fail:",
		PNAQ["Fish"],
		False
	],
	Example[{Additional,"Works on explicitly typed sequences as well:"},
		PNAQ[PNA["ATGATA"]],
		True
	],
	Example[{Additional,"Regardless of motif names:"},
		PNAQ[PNA["ATGATA","B"]],
		True
	],
	Test["If the explicitly type doesnt match the Monomers DNAQ will return false:",
		PNAQ[DNA["ATGATA"]],
		False
	],
	Example[{Attributes,"Listable","The function is listable:"},
		PNAQ[{"ATGATA",PNA["ATATAGACA"],"GTAGAC","GGAGACTT"}],
		{True,True,True,True}
	],
	Test["Listable with non polymers:",
		PNAQ[{"ATGCAT","AUGUC","FISH"}],
		{True,False,False}
	],
	Example[{Options,Degeneracy,"Can accomidate degeneracy in the sequence:"},
		PNAQ[PNA["NNNN"]],
		True
	],
	Test["Degeneracy works with implicitly typed sequences:",
		PNAQ["NNNN"],
		True
	],
	Test["Listable degeneracy:",
		PNAQ[{"NNNN","NN",PNA["NNNNN"],PNA[12]}],
		{True,True,True,True}
	],
	Example[{Options,Degeneracy,"Degeneracy option allows for degenerate sequences:"},
		PNAQ[PNA[12],Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"Degeneracy set to false will not accept numeric sequences:"},
		PNAQ[PNA[12],Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Degeneracy set to false does not accept any degnerate bases in the sequence:"},
		PNAQ[PNA["ATGACANN"],Degeneracy->False],
		False
	],
	Example[{Options,CheckMotifs,"Check motifs checks that the sequences set by the motifs match:"},
		PNAQ[Strand[PNA["ATGATAG","A"],PNA["ATGATAG","A"],PNA[20,"B"],PNA["CTATCAT","A'"]],CheckMotifs->True],
		True
	],
	Example[{Basic,"Overloaded to work on strands as well using StrandQ:"},
		PNAQ[Strand[PNA["ATGTATAGAGAT"]]],
		True
	],
	Example[{Basic,"Checks that all the sequences in the Strand are the correct type:"},
		PNAQ[Strand[PNA["ATGTATAGAGAT"],PNA["AGCATGG"]]],
		True
	],
	Test["Checks the Strand for polymer type:",
		PNAQ[Strand[PNA["ACGUAUCUCA"]]],
		False
	],
	Test["Even if internal sequence matches type, if the explicit type doesn't match it will be rejected:",
		PNAQ[Strand[DNA["ATGTATAGAGAT"]]],
		False
	],
	Example[{Options,Exclude,"Exclude option used to not examine polymer types in the context of strands:"},
		PNAQ[Strand[PNA["ATGTATAGAGAT"],Modification["Dabcyl"]],Exclude->Modification],
		True
	],
	Example[{Options,Exclude,"If Exclude is left blank, will strictly except only the matching polymer type:"},
		PNAQ[Strand[PNA["ATGTATAGAGAT"],Modification["Dabcyl"]],Exclude->{}],
		False
	],
	Example[{Options,Polymer,"Polymer type is given:"},
		PNAQ["CCGGC",Polymer->PNA],
		True
	],
	Example[{Options,Map,"Test on each sequence:"},
		PNAQ[{"CCGGC", "ATCGU"},Map->True],
		{True,False}
	],
	Example[{Options,Map,"Test each sequence and return one combined result:"},
		PNAQ[{"CCGGC", "ATCGU"},Map->False],
		False
	],
	Example[{Options,AlternativeEncodings,"Alternative coding alphabets for the polymer will be checked when AlternativeEncodings is set to True:"},
		PNAQ[PNA["CCGTa"],AlternativeEncodings->True],
		True
	],
	Example[{Options,AlternativeEncodings,"If AlternativeEncodings is set to False, then alternative coding alphabets for the polymer will not be permitted in the sequence:"},
		PNAQ[PNA["CCGTa"],AlternativeEncodings->False],
		False
	],
	Test["Works with strands where the motifs are named:",
		PNAQ[Strand[PNA["ATGTATAGAGAT","A"],PNA["AGCAGCCACA","B"],Modification["Dabcyl"]]],
		True
	]
}];


(* ::Subsubsection:: *)
(*GammaLeftPNAQ*)


DefineTests[GammaLeftPNAQ,{
	Example[{Basic,"Works on untyped sequences:"},
		GammaLeftPNAQ["ATGATA"],
		True
	],
	Example[{Basic,"Checks to ensure the monomes used only Monomers in the polymer alphabet:"},
		GammaLeftPNAQ["AUGATU"],
		False
	],
	Example[{Basic,"These are also not the correct type:"},
		GammaLeftPNAQ["LysHis"],
		False
	],
	Test["Non polymers should fail:",
		GammaLeftPNAQ["Fish"],
		False
	],
	Example[{Additional,"Works on explicitly typed sequences as well:"},
		GammaLeftPNAQ[GammaLeftPNA["ATGATA"]],
		True
	],
	Example[{Additional,"Regardless of motif names:"},
		GammaLeftPNAQ[GammaLeftPNA["ATGATA","B"]],
		True
	],
	Test["If the explicitly type doesnt match the Monomers DNAQ will return false:",
		GammaLeftPNAQ[DNA["ATGATA"]],
		False
	],
	Example[{Attributes,"Listable","The function is listable:"},
		GammaLeftPNAQ[{"ATGATA",GammaLeftPNA["ATATAGACA"],"GTAGAC","GGAGACTT"}],
		{True,True,True,True}
	],
	Test["Listable with non polymers:",
		GammaLeftPNAQ[{"ATGCAT","AUGUC","FISH"}],
		{True,False,False}
	],
	Example[{Options,Degeneracy,"Can accomidate degeneracy in the sequence:"},
		GammaLeftPNAQ[GammaLeftPNA["NNNN"]],
		True
	],
	Test["Degeneracy works with implicitly typed sequences:",
		GammaLeftPNAQ["NNNN"],
		True
	],
	Test["Listable degeneracy:",
		GammaLeftPNAQ[{"NNNN","NN",GammaLeftPNA["NNNNN"],GammaLeftPNA[12]}],
		{True,True,True,True}
	],
	Example[{Options,Degeneracy,"Degeneracy option allows for degenerate sequences:"},
		GammaLeftPNAQ[GammaLeftPNA[12],Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"Degeneracy set to false will not accept numeric sequences:"},
		GammaLeftPNAQ[GammaLeftPNA[12],Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Degeneracy set to false does not accept any degnerate bases in the sequence:"},
		GammaLeftPNAQ[GammaLeftPNA["ATGACANN"],Degeneracy->False],
		False
	],
	Example[{Basic,"Overloaded to work on strands as well using StrandQ:"},
		GammaLeftPNAQ[Strand[GammaLeftPNA["ATGTATAGAGAT"]]],
		True
	],
	Example[{Basic,"Checks that all the sequences in the Strand are the correct type:"},
		GammaLeftPNAQ[Strand[GammaLeftPNA["ATGTATAGAGAT"],GammaLeftPNA["AGCATGG"]]],
		True
	],
	Test["Checks the Strand for polymer type:",
		GammaLeftPNAQ[Strand[GammaLeftPNA["ACGUAUCUCA"]]],
		False
	],
	Test["Even if internal sequence matches type, if the explicit type doesn't match it will be rejected:",
		GammaLeftPNAQ[Strand[PNA["ATGTATAGAGAT"]]],
		False
	],
	Example[{Options,CheckMotifs,"Check motifs checks that the sequences set by the motifs match:"},
		GammaLeftPNAQ[Strand[GammaLeftPNA["ATGATAG","A"],GammaLeftPNA["ATGATAG","A"],GammaLeftPNA[20,"B"],GammaLeftPNA["CTATCAT","A'"]],CheckMotifs->True],
		True
	],
	Example[{Options,Exclude,"Exclude option used to not examine polymer types in the context of strands:"},
		GammaLeftPNAQ[Strand[GammaLeftPNA["ATGTATAGAGAT"],Modification["Dabcyl"]],Exclude->Modification],
		True
	],
	Example[{Options,Exclude,"If Exclude is left blank, will strictly except only the matching polymer type:"},
		GammaLeftPNAQ[Strand[GammaLeftPNA["ATGTATAGAGAT"],Modification["Dabcyl"]],Exclude->{}],
		False
	],Example[{Options,Polymer,"Polymer type is given:"},
		GammaLeftPNAQ["CCGGC",Polymer->GammaLeftPNA],
		True
	],
	Example[{Options,Map,"Test on each sequence:"},
		GammaLeftPNAQ[{"CCGGC", "ATCGU"},Map->True],
		{True,False}
	],
	Example[{Options,Map,"Test each sequence and return one combined result:"},
		GammaLeftPNAQ[{"CCGGC", "ATCGU"},Map->False],
		False
	],
	Example[{Options,AlternativeEncodings,"Alternative coding alphabets for the polymer will be checked when AlternativeEncodings is set to True:"},
		GammaLeftPNAQ[GammaLeftPNA["CCGTa"],AlternativeEncodings->True],
		True
	],
	Example[{Options,AlternativeEncodings,"If AlternativeEncodings is set to False, then alternative coding alphabets for the polymer will not be permitted in the sequence:"},
		GammaLeftPNAQ[GammaLeftPNA["CCGTa"],AlternativeEncodings->False],
		False
	],
	Test["Works with strands where the motifs are named:",
		GammaLeftPNAQ[Strand[GammaLeftPNA["ATGTATAGAGAT","A"],GammaLeftPNA["AGCAGCCACA","B"],Modification["Dabcyl"]]],
		True
	]
}];


(* ::Subsubsection:: *)
(*GammaRightPNAQ*)


DefineTests[GammaRightPNAQ,{
	Example[{Basic,"Works on untyped sequences:"},
		GammaRightPNAQ["ATGATA"],
		True
	],
	Example[{Basic,"Checks to ensure the monomes used only Monomers in the polymer alphabet.:"},
		GammaRightPNAQ["AUGATU"],
		False
	],
	Example[{Basic,"These are also not the correct type:"},
		GammaRightPNAQ["LysHis"],
		False
	],
	Test["Non polymers should fail:",
		GammaRightPNAQ["Fish"],
		False
	],
	Example[{Additional,"Works on explicitly typed sequences as well:"},
		GammaRightPNAQ[GammaRightPNA["ATGATA"]],
		True
	],
	Example[{Additional,"Regardless of motif names:"},
		GammaRightPNAQ[GammaRightPNA["ATGATA","B"]],
		True
	],
	Test["If the explicitly type doesnt match the Monomers DNAQ will return false:",
		GammaRightPNAQ[DNA["ATGATA"]],
		False
	],
	Example[{Attributes,"Listable","The function is listable:"},
		GammaRightPNAQ[{"ATGATA",GammaRightPNA["ATATAGACA"],"GTAGAC","GGAGACTT"}],
		{True,True,True,True}
	],
	Test["Listable with non polymers:",
		GammaRightPNAQ[{"ATGCAT","AUGUC","FISH"}],
		{True,False,False}
	],
	Example[{Options,Degeneracy,"Can accomidate degeneracy in the sequence:"},
		GammaRightPNAQ[GammaRightPNA["NNNN"]],
		True
	],
	Test["Degeneracy works with implicitly typed sequences:",
		GammaRightPNAQ["NNNN"],
		True
	],
	Test["Listable degeneracy:",
		GammaRightPNAQ[{"NNNN","NN",GammaRightPNA["NNNNN"],GammaRightPNA[12]}],
		{True,True,True,True}
	],
	Example[{Options,Degeneracy,"Degeneracy option allows for degenerate sequences:"},
		GammaRightPNAQ[GammaRightPNA[12],Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"Degeneracy set to false will not accept numeric sequences:"},
		GammaRightPNAQ[GammaRightPNA[12],Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Degeneracy set to false does not accept any degnerate bases in the sequence:"},
		GammaRightPNAQ[GammaRightPNA["ATGACANN"],Degeneracy->False],
		False
	],
	Example[{Basic,"Overloaded to work on strands as well using StrandQ:"},
		GammaRightPNAQ[Strand[GammaRightPNA["ATGTATAGAGAT"]]],
		True
	],
	Example[{Basic,"Checks that all the sequences in the Strand are the correct type:"},
		GammaRightPNAQ[Strand[GammaRightPNA["ATGTATAGAGAT"],GammaRightPNA["AGCATGG"]]],
		True
	],
	Example[{Options,CheckMotifs,"Check motifs checks that the sequences set by the motifs match:"},
		GammaRightPNAQ[Strand[GammaRightPNA["ATGATAG","A"],GammaRightPNA["ATGATAG","A"],GammaRightPNA[20,"B"],GammaRightPNA["CTATCAT","A'"]],CheckMotifs->True],
		True
	],
	Test["Checks the Strand for polymer type:",
		GammaRightPNAQ[Strand[GammaRightPNA["ACGUAUCUCA"]]],
		False
	],
	Test["Even if internal sequence matches type, if the explicit type doesn't match it will be rejected:",
		GammaRightPNAQ[Strand[DNA["ATGTATAGAGAT"]]],
		False
	],
	Example[{Options,Exclude,"Exclude option used to not examine polymer types in the context of strands:"},
		GammaRightPNAQ[Strand[GammaRightPNA["ATGTATAGAGAT"],Modification["Dabcyl"]],Exclude->Modification],
		True
	],
	Example[{Options,Exclude,"If Exclude is left blank, will strictly except only the matching polymer type:"},
		GammaRightPNAQ[Strand[GammaRightPNA["ATGTATAGAGAT"],Modification["Dabcyl"]],Exclude->{}],
		False
	],
	Example[{Options,Polymer,"Polymer type is given:"},
		GammaRightPNAQ["CCGGC",Polymer->GammaRightPNA],
		True
	],
	Example[{Options,Map,"Test on each sequence:"},
		GammaRightPNAQ[{"CCGGC", "ATCGU"},Map->True],
		{True,False}
	],
	Example[{Options,Map,"Test each sequence and return one combined result:"},
		GammaRightPNAQ[{"CCGGC", "ATCGU"},Map->False],
		False
	],
	Example[{Options,AlternativeEncodings,"Alternative coding alphabets for the polymer will be checked when AlternativeEncodings is set to True:"},
		GammaRightPNAQ[GammaRightPNA["CCGTa"],AlternativeEncodings->True],
		True
	],
	Example[{Options,AlternativeEncodings,"If AlternativeEncodings is set to False, then alternative coding alphabets for the polymer will not be permitted in the sequence:"},
		GammaRightPNAQ[GammaRightPNA["CCGTa"],AlternativeEncodings->False],
		False
	],
	Test["Works with strands where the motifs are named:",
		GammaRightPNAQ[Strand[GammaRightPNA["ATGTATAGAGAT","A"],GammaRightPNA["AGCAGCCACA","B"],Modification["Dabcyl"]]],
		True
	]
}];


(* ::Subsubsection:: *)
(*PeptideQ*)


DefineTests[PeptideQ,{
	Example[{Basic,"Works on untyped sequences:"},
		PeptideQ["LysHisArg"],
		True
	],
	Example[{Basic,"Checks to ensure the monomes used only Monomers in the polymer alphabet.:"},
		PeptideQ["AUGATU"],
		False
	],
	Example[{Basic,"These are also not the correct type:"},
		PeptideQ["ATCGAGA"],
		False
	],
	Test["Non polymers should fail:",
		PeptideQ["Fish"],
		False
	],
	Example[{Additional,"Works on explicitly typed sequences as well:"},
		PeptideQ[Peptide["LysHisArg"]],
		True
	],
	Example[{Additional,"Regardless of motif names:"},
		PeptideQ[Peptide["LysHisArg","B"]],
		True
	],
	Example[{Options,AlternativeEncodings,"Works on sequences using alternative coding alphabets when AlternativeEncodings is set to True:"},
		PeptideQ[Peptide["CATHERINE"],AlternativeEncodings->True],
		True
	],
	Test["If the explicitly type doesnt match the Monomers will return false:",
		PeptideQ[DNA["ATGATA"]],
		False
	],
	Example[{Attributes,"Listable","The function is listable:"},
		PeptideQ[{"LysHisArg",Peptide["LysHisArg"],"ArgArgArg","HisArg"}],
		{True,True,True,True}
	],
	Test["Listable with non polymers:",
		PeptideQ[{"ArgHis","AUGUC","FISH"}],
		{True,False,False}
	],
	Example[{Options,Degeneracy,"Can accomidate degeneracy in the sequence:"},
		PeptideQ[Peptide["AnyAnyAny"]],
		True
	],
	Test["Degeneracy works with implicitly typed sequences:",
		PeptideQ["AnyAnyAny"],
		True
	],
	Test["Listable degeneracy:",
		PeptideQ[{"AnyAnyAny","AnyAny",Peptide["AnyAnyAny"],Peptide[12]}],
		{True,True,True,True}
	],
	Example[{Options,Degeneracy,"Degeneracy option allows for degenerate sequences:"},
		PeptideQ[Peptide[12],Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"Degeneracy set to false will not accept numeric sequences:"},
		PeptideQ[Peptide[12],Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Degeneracy set to false does not accept any degnerate bases in the sequence:"},
		PeptideQ[Peptide["LysArgArgHisAny"],Degeneracy->False],
		False
	],
	Example[{Options,CheckMotifs,"Check motifs checks that the sequences set by the motifs match:"},
		PeptideQ[Strand[Peptide["LysHisArg","A"],Peptide["LysHisArg","A"]],CheckMotifs->True],
		True
	],
	Example[{Basic,"Overloaded to work on strands as well using StrandQ:"},
		PeptideQ[Strand[Peptide["LysHisArg"]]],
		True
	],
	Example[{Basic,"Checks that all the sequences in the Strand are the correct type:"},
		PeptideQ[Strand[Peptide["LysHisArg"],Peptide["LysLysArgArg"]]],
		True
	],
	Test["Checks the Strand for polymer type:",
		PeptideQ[Strand[PNA["ACGUAUCUCA"]]],
		False
	],
	Test["Even if internal sequence matches type, if the explicit type doesn't match it will be rejected:",
		PeptideQ[Strand[RNA["LysHisArg"]]],
		False
	],
	Example[{Options,Exclude,"Exclude option used to not examine polymer types in the context of strands:"},
		PeptideQ[Strand[Peptide["LysHisArg"],Modification["Dabcyl"]],Exclude->Modification],
		True
	],
	Example[{Options,Exclude,"If Exclude is left blank, will strictly except only the matching polymer type:"},
		PeptideQ[Strand[Peptide["LysHisArg"],Modification["Dabcyl"]],Exclude->{}],
		False
	],
	Example[{Options,Map,"Test on each sequence:"},
		PeptideQ[{"LysHisArg", "ATCGU"},Map->True],
		{True,False}
	],
	Example[{Options,Map,"Test each sequence and return one combined result:"},
		PeptideQ[{"LysHisArg", "ATCGU"},Map->False],
		False
	],
	Example[{Options,AlternativeEncodings,"Alternative coding alphabets for the polymer will be checked when AlternativeEncodings is set to True:"},
		PeptideQ[Peptide["LysHisArgA"],AlternativeEncodings->True],
		True
	],
	Example[{Options,AlternativeEncodings,"If AlternativeEncodings is set to False, then alternative coding alphabets for the polymer will not be permitted in the sequence:"},
		PeptideQ[Peptide["LysHisArgA"],AlternativeEncodings->False],
		False
	],
	Test["Works with strands where the motifs are named:",
		PeptideQ[Strand[Peptide["LysArgArgHis","A"],Peptide["ArgArgHisLys","B"],Modification["Dabcyl"]]],
		True
	]
}];


(* ::Subsubsection:: *)
(*LNAChimeraQ*)


DefineTests[LNAChimeraQ,{
	Example[{Basic,"Works on untyped sequences:"},
		LNAChimeraQ["+AmUmGfAfU+A"],
		True
	],
	Example[{Basic,"Checks to ensure the monomes used only Monomers in the polymer alphabet:"},
		LNAChimeraQ["AT"],
		False
	],
	Example[{Basic,"These are also not the correct type:"},
		LNAChimeraQ["LysHis"],
		False
	],
	Test["Non polymers should fail:",
		LNAChimeraQ["Fish"],
		False
	],
	Example[{Additional,"Works on explicitly typed sequences as well:"},
		LNAChimeraQ[LNAChimera["+AmG"]],
		True
	],
	Example[{Additional,"Regardless of motif names:"},
		LNAChimeraQ[LNAChimera["+AmC","B"]],
		True
	],
	Test["If the explicitly type doesnt match the Monomers LNAChimera will return false:",
		LNAChimeraQ[DNA["+AmU"]],
		False
	],
	Example[{Attributes,"Listable","The function is listable:"},
		LNAChimeraQ[{"+AmUfGfA+U+A",LNAChimera["fAmU+A+UmAfGmAfC+A"],"+G+UfAfGmAfC","fGfGmA+G+AfCmUmU"}],
		{True,True,True,True}
	],
	Test["Listable with non polymers:",
		LNAChimeraQ[{"mAmUfGfC+A+T","mAfTfGmTfC","FISH"}],
		{True,False,False}
	],
	Example[{Options,Degeneracy,"Can accomidate degeneracy in the sequence:"},
		LNAChimeraQ[LNAChimera["NNNN"]],
		True
	],
	Test["Degeneracy works with implicitly typed sequences:",
		LNAChimeraQ["NNNN"],
		True
	],
	Test["Listable degeneracy:",
		LNAChimeraQ[{"NNNN","NN",LNAChimera["NNNNN"],LNAChimera[12]}],
		{True,True,True,True}
	],
	Example[{Options,Degeneracy,"Degeneracy option allows for degenerate sequences:"},
		LNAChimeraQ[LNAChimera[12],Degeneracy->True],
		True
	],
	Example[{Options,"Degeneracy set to false will not accept numeric sequences:"},
		LNAChimeraQ[LNAChimera[12],Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Degeneracy set to false does not accept any degnerate bases in the sequence:"},
		LNAChimeraQ[LNAChimera["+AfUNN"],Degeneracy->False],
		False
	],
	Example[{Options,CheckMotifs,"Check motifs checks that the sequences set by the motifs match:"},
		LNAChimeraQ[Strand[LNAChimera["mAmUfGfA+UmAmG","A"],LNAChimera["mAmUfGfA+UmAmG","A"],LNAChimera[20,"B"],LNAChimera["mCmU+AfUfCmAmU","A'"]],CheckMotifs->True],
		True
	],
	Example[{Basic,"Overloaded to work on strands as well using StrandQ:"},
		LNAChimeraQ[Strand[LNAChimera["mAmUfGfA+UmAmG"]]],
		True
	],
	Example[{Basic,"Checks that all the sequences in the Strand are the correct type:"},
		LNAChimeraQ[Strand[LNAChimera["mAmUfGfA+UmAmG"],LNAChimera["mAfGfC+AfUfGfG"]]],
		True
	],
	Test["Checks the Strand for polymer type:",
		LNAChimeraQ[Strand[DNA["mAmUfGfA+UmAmG"]]],
		False
	],
	Example[{Options,Exclude,"Exclude option used to not examine polymer types in the context of strands:"},
		LNAChimeraQ[Strand[LNAChimera["mAmUfGfA+UmAmG"],Modification["Dabcyl"]],Exclude->Modification],
		True
	],
	Example[{Options,Exclude,"If Exclude is left blank, will strictly except only the matching polymer type:"},
		LNAChimeraQ[Strand[LNAChimera["mAmUfGfA+UmAmG"],Modification["Dabcyl"]],Exclude->{}],
		False
	],
	Example[{Options,Polymer,"Polymer type is given:"},
		LNAChimeraQ["mAmUfGfA+UmAmG",Polymer->LNAChimera],
		True
	],
	Example[{Options,Map,"Test on each sequence:"},
		LNAChimeraQ[{"mAmUfGfA+UmAmG", "mAmUfGfA+UmTmG"},Map->True],
		{True,False}
	],
	Example[{Options,Map,"Test each sequence and return one combined result:"},
		LNAChimeraQ[{"mAmUfGfA+UmAmG", "mAmUfGfA+UmTmG"},Map->False],
		False
	],
	Example[{Options,AlternativeEncodings,"Alternative coding alphabets for the polymer will be checked when AlternativeEncodings is set to True:"},
		LNAChimeraQ[LNAChimera["fCfCmGfU+a"],AlternativeEncodings->True],
		True
	],
	Example[{Options,AlternativeEncodings,"If AlternativeEncodings is set to False, then alternative coding alphabets for the polymer will not be permitted in the sequence:"},
		LNAChimeraQ[LNAChimera["fCfCmGfU+a"],AlternativeEncodings->False],
		False
	],
	Test["Works with strands where the motifs are named:",
		LNAChimeraQ[Strand[LNAChimera["mAmUfGfA+UmAmG","A"],LNAChimera["fAfUfGfA+UmAmG","B"],Modification["Dabcyl"]]],
		True
	]
}];

(* ::Subsubsection:: *)
(*ModificationQ*)


DefineTests[ModificationQ,{
	Example[{Basic,"Works on untyped sequences:"},
		ModificationQ["FluoresceinCyfiveCyfivePhosphorylated"],
		True
	],
	Example[{Basic,"Checks to ensure the monomes used only Monomers in the polymer alphabet:"},
		ModificationQ["AUGATU"],
		False
	],
	Example[{Basic,"These are also not the correct type:"},
		ModificationQ["ATCGAGA"],
		False
	],
	Test["Non polymers should fail:",
		ModificationQ["Fish"],
		False
	],
	Example[{Additional,"Works on explicitly typed sequences as well:"},
		ModificationQ[Modification["FluoresceinCyfiveCyfivePhosphorylated"]],
		True
	],
	Example[{Additional,"Regardless of motif names:"},
		ModificationQ[Modification["FluoresceinCyfiveCyfivePhosphorylated","B"]],
		True
	],
	Test["If the explicitly type doesnt match the Monomers will return false:",
		ModificationQ[DNA["ATGATA"]],
		False
	],
	Example[{Attributes,"Listable","The function is listable:"},
		ModificationQ[{"FluoresceinCyfiveCyfivePhosphorylated",Modification["FluoresceinCyfiveCyfivePhosphorylated"],"FluoresceinCyfiveCyfive","FluoresceinCyfivePhosphorylated"}],
		{True,True,True,True}
	],
	Test["Listable with non polymers:",
		ModificationQ[{"FluoresceinCyfiveCyfivePhosphorylated","AUGUC","FISH"}],
		{True,False,False}
	],
	Example[{Options,Degeneracy,"Can accomidate degeneracy in the sequence:"},
		ModificationQ[Modification["AnyAnyAny"]],
		True
	],
	Test["Degeneracy works with implicitly typed sequences:",
		ModificationQ["AnyAnyAny"],
		True
	],
	Test["Listable degeneracy:",
		ModificationQ[{"AnyAnyAny","AnyAny",Modification["AnyAnyAny"],Modification[12]}],
		{True,True,True,True}
	],
	Example[{Options,Degeneracy,"Degeneracy option allows for degenerate sequences:"},
		ModificationQ[Modification[12],Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"Degeneracy set to false will not accept numeric sequences:"},
		ModificationQ[Modification[12],Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Degeneracy set to false does not accept any degnerate bases in the sequence:"},
		ModificationQ[Modification["FluoresceinCyfiveCyfivePhosphorylatedAnyAny"],Degeneracy->False],
		False
	],
	Example[{Options,CheckMotifs,"Check motifs checks that the sequences set by the motifs match:"},
		ModificationQ[Strand[Modification["FluoresceinCyfive","A"],Modification["FluoresceinCyfive","A"]],CheckMotifs->True],
		True
	],
	Example[{Options,Exclude,"Exclude option provides a polymer type or list of polymer types to ignore when checking that its a modification:"},
		ModificationQ[Strand[Modification["FluoresceinCyfive","A"],DNA["ATGATACA"],Modification["FluoresceinCyfive","A"]],Exclude->{DNA}],
		True
	],
	Example[{Options,Exclude,"Exclude option provides a polymer type or list of polymer types to ignore when checking that its a modification:"},
		ModificationQ[Strand[Modification["FluoresceinCyfive","A"],DNA["ATGATACA"],Modification["FluoresceinCyfive","A"]],Exclude->{}],
		False
	],
	Example[{Options,Polymer,"Polymer type is given:"},
		ModificationQ["FluoresceinCyfive",Polymer->Modification],
		True
	],
	Example[{Options,Map,"Test on each sequence:"},
		ModificationQ[{"FluoresceinCyfive", "ATCGU"},Map->True],
		{True,False}
	],
	Example[{Options,Map,"Test each sequence and return one combined result:"},
		ModificationQ[{"FluoresceinCyfive", "ATCGU"},Map->False],
		False
	],
	Example[{Basic,"Overloaded to work on strands as well using StrandQ:"},
		ModificationQ[Strand[Modification["FluoresceinCyfive"]]],
		True
	],
	Example[{Basic,"Checks that all the sequences in the Strand are the correct type:"},
		ModificationQ[Strand[Modification["FluoresceinCyfive"],Modification["CyfivePhosphorylated"]]],
		True
	],
	Test["Checks the Strand for polymer type:",
		ModificationQ[Strand[PNA["FluoresceinCyfive"]]],
		False
	],
	Test["Even if internal sequence matches type, if the explicit type doesn't match it will be rejected:",
		ModificationQ[Strand[DNA["FluoresceinCyfive"]]],
		False
	],
	Test["Works with strands where the motifs are named:",
		ModificationQ[Strand[Modification["FluoresceinCyfive","A"],Modification["FluoresceinCyfiveCyfivePhosphorylated","B"],Modification["Dabcyl"]]],
		True
	]
}];


(* ::Subsubsection:: *)
(*PolymerType*)


DefineTests[PolymerType,{
	Example[{Basic,"Given a sequence, will attempt to determine what Polymer typ eit might be:"},
		PolymerType["ATAGATA"],
		DNA
	],
	Example[{Basic,"Given a sequence, will attempt to determine what Polymer type it might be:"},
		PolymerType["ACUAU"],
		RNA
	],
	Example[{Basic,"When provided with a Strand, returns a list of Polymers for each run of sequence:"},
		PolymerType[Strand[DNA["ATGCAGATGA","A"],Peptide["LysArgHis"],RNA["GGACAG"]]],
		{DNA,Peptide,RNA}
	],
	Example[{Additional,"Works on explicitly typed sequences as well:"},
		PolymerType[RNA["ACAGACA","A"]],
		RNA
	],
	Test["Works with explicitly typed sequences sans a motif name:",
		PolymerType[RNA["ACAGACA"]],
		RNA
	],
	Example[{Additional,"Works on degenerate sequences as well:"},
		PolymerType[Peptide[10]],
		Peptide
	],
	Example[{Issues,"If ambigious what polymer type the sequence could be, the function will default to DNA:"},
		PolymerType["ACGCAGCAG"],
		DNA
	],
	Example[{Issues,"Providing a polymer option can be used to disambiguate:"},
		PolymerType["ACGCAGCAG",Polymer->RNA],
		RNA
	],
	Example[{Options,Polymer,"Providing a Polymer option will suggest what polymer type should return:"},
		PolymerType["AAAAAAAAAAA",Polymer->RNA],
		RNA
	],
	Example[{Options,Polymer,"Not providing a Polymer option will return default polymer types:"},
		PolymerType[{"CGG", "AGG"}],
		{DNA,DNA}
	],
	Example[{Options,Polymer,"Providing a Polymer option will suggest what polymer type should return:"},
		PolymerType[{"CGG", "AGG"}, Polymer->RNA],
		{RNA,RNA}
	],
	Example[{Options,Map,"If Map is set to True, listability will work as expected by maping over the inputs:"},
		PolymerType[{"ACACAGCA","AUCAUC","AGGCAC"},Map->True],
		{DNA,RNA,DNA}
	],
	Example[{Options,Map,"If Map is set to False, the function will return a single polymer that could match all of the provided input:"},
		PolymerType[{"ACACAGCA","ATCATC","AGGCAC"},Map->False],
		DNA
	],
	(*Example[{Options,FastTrack,"(always resolve now) If FastTrack is set to True, the function will assume legal inputs and directly evaluate:"},
		PolymerType[{"Tacos!", DNA["ATT"]}, FastTrack->True],
		{$Failed,DNA}
	],*)
	Example[{Options,Consolidate,"If Consolidate is set to True, stretches of sequenes of like polymers will be consolidated into a single entry:"},
		PolymerType[Strand[DNA["ATGCAGATGA","A"],DNA["GTCTG","C"],Peptide["LysArgHis"],DNA["GGACAG"],DNA["AGCAGACAG"]],Consolidate->True],
		{DNA,Peptide,DNA}
	],
	Example[{Options,Consolidate,"If Consolidate is set to False, a polymer type is returned for each sequence in the Strand:"},
		PolymerType[Strand[DNA["ATGCAGATGA","A"],DNA["GTCTG","C"],Peptide["LysArgHis"],DNA["GGACAG"],DNA["AGCAGACAG"]],Consolidate->False],
		{DNA,DNA,Peptide,DNA,DNA}
	],
	Example[{Attributes,"Listable","The function is listable:"},
		PolymerType[{RNA[10],"ATGATA","LysHisArg"}],
		{RNA,DNA,Peptide}
	],
	Example[{Messages,"unConsensus","If the map option is True but the polymer types are not consensus, the unConsensus message is thrown:"},
		PolymerType[{DNA["ATT"],RNA["AUU"]}, Map->False],
		$Failed,
		Messages:>Message[PolymerType::unConsensus]
	],
	Example[{Messages,"unknownPolymer","If the sequences does not match any of the known polymer types, the unknownPolymer message is thrown:"},
		PolymerType[{"Tacos!", DNA["ATT"]}],
		{$Failed,DNA},
		Messages:>Message[PolymerType::unknownPolymer, "Tacos!"]
	],
	Example[{Messages,"missMatchPolymer","If the provided sequence does not match the provided Polymer option, the missMatchPolymer message is thrown:"},
		PolymerType["ATCGATACA",Polymer->RNA],
		$Failed,
		Messages:>Message[PolymerType::missMatchPolymer, "ATCGATACA","RNA"]
	],
	Example[{Messages,"missMatchPolymer","If the provided sequence does not match the head, the missMatchPolymer message is thrown:"},
		PolymerType[RNA["ATCGATACA"]],
		$Failed,
		Messages:>Message[PolymerType::missMatchPolymer, ToString[RNA["ATCGATACA"]],"RNA"]
	],
	Example[{Messages,"missMatchPolymer","If the provided sequence does not match the head, the missMatchPolymer message is thrown:"},
		PolymerType[{RNA["AUU"], DNA["ATT"]}, Polymer->RNA],
		{RNA,$Failed},
		Messages:>Message[PolymerType::missMatchPolymer,ToString[DNA["ATT"]],"RNA"]
	],
	Test["Symbolic input remains unevaluated:",
		PolymerType[Fish],
		_PolymerType
	],
	Test["Empty strings return no polymer type:",
		PolymerType[""],
		$Failed,
		Messages:>Message[PolymerType::unknownPolymer, ""]
	]
}];


(* ::Subsubsection::Closed:: *)
(*UnTypeSequence*)


DefineTests[UnTypeSequence,{
	Example[{Basic,"Removes type from a sequence:"},
		UnTypeSequence[DNA["ATGATA"]],
		"ATGATA"
	],
	Example[{Basic,"Remove type and motif from a sequence:"},
		UnTypeSequence[DNA["ATGATA","Cat"]],
		"ATGATA"
	],
	Example[{Basic,"Returns wildcard sequences if Monomers are unspecified:"},
		UnTypeSequence[DNA[5,"Cat"]],
		"NNNNN"
	],
	Example[{Basic,"Returns the original sequence if the input is not explicitly typed:"},
		UnTypeSequence["ATGATA"],
		"ATGATA"
	],
	Example[{Additional,"Returns the wildcard sequence of Modification:"},
		UnTypeSequence[Modification[1]],
		"Any"
	],
	Example[{Attributes,Listable,"Remove the type of a list of sequences:"},
		UnTypeSequence[{"ATGATA",DNA["ATGATA"],DNA[5],DNA["ATGATA"]}],
		{"ATGATA","ATGATA","NNNNN","ATGATA"}
	]
}];


(* ::Subsubsection::Closed:: *)
(*ExplicitlyTypedQ*)


DefineTests[ExplicitlyTypedQ,{
	Example[{Basic,"Returns True if a sequence does not have an explicitly associated type:"},
		ExplicitlyTypedQ[DNA["ATGATATA"]],
		True
	],
	Example[{Basic,"Returns False if a sequence does not have an explicitly associated type:"},
		ExplicitlyTypedQ["ATGATATA"],
		False
	],
	Test["Returns false for untyped strings:",
		ExplicitlyTypedQ["Fish"],
		False
	],
	Example[{Attributes,Listable,"Checks if a list of sequences have types:"},
		ExplicitlyTypedQ[{"ATGATATA",DNA["AGAGA"],DNA[5]}],
		{False,True,True}
	]
}];


(* ::Subsubsection:: *)
(*ExplicitlyType*)


DefineTests[ExplicitlyType,{
	Example[{Basic,"The function can be used to safely wrap a sequences in its Polymer type:"},
		ExplicitlyType["ATGATA",ExplicitlyTyped->True],
		DNA["ATGATA"]
	],
	Example[{Basic,"The function can also be used to safely strip off the polymer type:"},
		ExplicitlyType[DNA["ATGATA"],ExplicitlyTyped->False],
		"ATGATA"
	],
	Example[{Basic,"If given two sequences, the typing status of the first sequence will serve as the template for weather or not to type the second sequence:"},
		ExplicitlyType[DNA["ATGATA"],"AGGCA"],
		DNA["AGGCA"]
	],
	Example[{Basic,"So if the first sequence lacks an explict type, it will strip off the typing from the second sequence:"},
		ExplicitlyType["ATGATA",DNA["AGGCA"]],
		"AGGCA"
	],
	Example[{Additional,"Even when the polymer type is already absent, its safe to request it be stripped off:"},
		ExplicitlyType["ATGATA",ExplicitlyTyped->False],
		"ATGATA"
	],
	Example[{Additional,"Explicitly typeing sequences which already have type is a safe operation:"},
		ExplicitlyType[DNA["ATGATA"],ExplicitlyTyped->True],
		DNA["ATGATA"]
	],
	Example[{Additional,"The function will attempt to implicitly determine the polymer type if one is not provided:"},
		ExplicitlyType["AUGUCUA",ExplicitlyTyped->True],
		RNA["AUGUCUA"]
	],
	Example[{Additional,"Can automatically determine any non-ambigious polymer type:"},
		ExplicitlyType["LysArgGly",ExplicitlyTyped->True],
		Peptide["LysArgGly"]
	],
	Example[{Additional,"If there is any ambiguity, it will assume DNA by default:"},
		ExplicitlyType["AGCA",ExplicitlyTyped->True],
		DNA["AGCA"]
	],
	Example[{Additional,"If there is any motif name present, it will preserve the name:"},
		ExplicitlyType[{DNA[5, "A"], "ATCG", RNA["UUCG", "B"], DNA["ATTCC"]}],
		{DNA["NNNNN","A"],"ATCG",RNA["UUCG","B"],DNA["ATTCC"]}
	],
	Example[{Options,Polymer,"The polymer type can be provided to the function to resolve any ambiguity in the typing:"},
		ExplicitlyType["AGGCACCA",Polymer->RNA,ExplicitlyTyped->True],
		RNA["AGGCACCA"]
	],
	Example[{Options,ExplicitlyTyped,"The ExplicitlyTyped option will dominate over the template's typing when two sequences are provided:"},
		ExplicitlyType["ATGATA",DNA["AGGCA"],ExplicitlyTyped->True],
		DNA["AGGCA"]
	],
	Example[{Options,ExplicitlyTyped,"The ExplicitlyTyped option will dominate over the template's typing when two sequences are provided:"},
		ExplicitlyType[DNA["ATGATA"],DNA["AGGCA"],ExplicitlyTyped->False],
		"AGGCA"
	],
	Example[{Attributes,"Listable","The function is listable:"},
		ExplicitlyType[{"ATGATAC",DNA["ATGAA"],"AGUCUA",Peptide[3]},ExplicitlyTyped->True],
		{DNA["ATGATAC"],DNA["ATGAA"],RNA["AGUCUA"],Peptide["AnyAnyAny"]}
	],
	Example[{Issues,"If requested to stripe the type from a numeric sequence, uses the Wildcard monmer definition to Convert to a equivelent string:"},
		ExplicitlyType[DNA[5],ExplicitlyTyped->False],
		"NNNNN"
	],
	Example[{Issues,"This works regardless of the Wildcard monomer definition for the polymer:"},
		ExplicitlyType[Peptide[3],ExplicitlyTyped->False],
		"AnyAnyAny"
	],
	Example[{Issues,"Will attempt to match the typeTemplate's type to the output type and thus requires the polymers to be the same for both:"},
		ExplicitlyType[DNA["ATGATA"],"LysArg"],
		$Failed,
		Messages:>Message[ExplicitlyType::missMatchPolymer,"LysArg","DNA"]
	],
	Example[{Messages,"missMatchPolymer","Provided sequence does not match the provided polymer type:"},
		ExplicitlyType["LysArg",Polymer->DNA],
		$Failed,
		Messages:>Message[ExplicitlyType::missMatchPolymer,"LysArg","DNA"]
	],
	Example[{Messages,"unknownPolymer","Unknown sequence will throw a message:"},
		ExplicitlyType[""],
		$Failed,
		Messages:>Message[ExplicitlyType::unknownPolymer,""]
	],
	Test["Testing preservation of motif:",ExplicitlyType[DNA["NNNNN","A"]],
		DNA["NNNNN","A"]
	],
	Test["Testing that symbols remain unevaluated:",
		ExplicitlyType[Fish],
		_ExplicitlyType
	],
	Test["Empty list of sequences:",
		ExplicitlyType[{}],
		{}
	],
	Test["Reference sequence with empty list:",
		ExplicitlyType["ATCG",{}],
		{}
	]
}];


(* ::Subsubsection::Closed:: *)
(*ToDNA*)


DefineTests[ToDNA,{
	Example[{Basic,"The function is used to Convert any sequene into its equivalent DNA sequence:"},
		ToDNA["AUCUAGU"],
		"ATCTAGT"
	],
	Example[{Basic,"The function can also Convert strands into all DNA sequence versions of that Strand:"},
		ToDNA[Strand[DNA["ATGTATAC"],RNA["AUCUAUC"]]],
		Strand[DNA["ATGTATACATCTATC"]]
	],
	Example[{Additional,"It can handle implicitly or explicitly typed input sequences:"},
		ToDNA[RNA["AUCUAUG"]],
		DNA["ATCTATG"]
	],
	Example[{Additional,"Preserves any motif naming as part of the conversion:"},
		ToDNA[RNA["AUCUAUG","B"]],
		DNA["ATCTATG","B"]
	],
	Example[{Additional,"Works with degenerate sequences as well:"},
		ToDNA[PNA[5]],
		DNA["NNNNN"]
	],
	Example[{Additional,"While perserving motif names as well:"},
		ToDNA[PNA[5,"B"]],
		DNA["NNNNN","B"]
	],
	Example[{Additional,"Converting to DNA for LNAChimera:"},
		ToDNA[LNAChimera["+A+TmGfC+U"]],
		DNA["ATGCT"]
	],
	Example[{Issues,"Converts sequences for which there is a cognite watson-crick pair into an empty string:"},
		ToDNA[Peptide["LysArgHis"]],
		""
	],
	Example[{Options,Consolidate,"Consolidate will turn the Strand into a single long DNA motif upon conversion:"},
		ToDNA[Strand[DNA["ATGTATAC","A"],RNA["AUCUAUC","B"]],Consolidate->True],
		Strand[DNA["ATGTATACATCTATC"]]
	],
	Example[{Options,Consolidate,"However, if Consolidate is set to false, consolidate will leave the individual motifs in tact:"},
		ToDNA[Strand[DNA["ATGTATAC","A"],RNA["AUCUAUC","B"]],Consolidate->False],
		Strand[DNA["ATGTATAC","A"],DNA["ATCTATC","B"]]
	],
	Example[{Options,ExplicitlyTyped,"The ExplicitlyTyped option can be used to control the typing of the output:"},
		ToDNA["AUGUCUA",ExplicitlyTyped->True],
		DNA["ATGTCTA"]
	],
	Example[{Attributes,"Listable","The function is listable by sequence:"},
		ToDNA[{"ATGAT","AUCUA",DNA[5],RNA["ACUA"]}],
		{"ATGAT","ATCTA",DNA["NNNNN"],DNA["ACTA"]}
	],
	Test["Symbolic input remains unevaluated:",
		ToDNA[Fish],
		_ToDNA
	],
	Test["Detyping numeric input provides degenerate sequences:",
		ToDNA[RNA[5],ExplicitlyTyped->False],
		"NNNNN"
	]
}];


(* ::Subsubsection:: *)
(*ToPeptide*)


DefineTests[ToPeptide,{
	Example[{Basic,"Convert a single implicitly typed protein sequence in the single letter amino acid form into an explicitly typed Peptide in the triple letter abbreviation form:"},
		ToPeptide["CATHERINE"],
		"CysAlaThrHisGluArgIleAsnGlu"
	],
	Example[{Basic,"Convert a single explicitly typed protein sequence in the single letter amino acid form into an explicitly typed Peptide in the triple letter abbreviation form:"},
		ToPeptide[Peptide["CATHERINE"]],
		Peptide["CysAlaThrHisGluArgIleAsnGlu"]
	],
	Example[{Additional,"The function can handle peptide sequences specified in a mix of the single letter and triple letter amino acid abbreviation forms:"},
		ToPeptide["CysATHEArgINE"],
		"CysAlaThrHisGluArgIleAsnGlu"
	],
	Example[{Attributes,"Listable","Convert several single protein sequences in the single letter amino acid form into explicitly typed Peptides in the triple letter abbreviation form:"},
		ToPeptide[{"CATHERINE","KITTY"}],
		{"CysAlaThrHisGluArgIleAsnGlu","LysIleThrThrTyr"}
	],
	Example[{Options,ExplicitlyTyped,"Return a peptide sequence that is explicitly typed:"},
		ToPeptide["CATHERINE",ExplicitlyTyped->True],
		Peptide["CysAlaThrHisGluArgIleAsnGlu"]
	],
	Example[{Options,ExplicitlyTyped,"Return a peptide sequence that is explicitly typed:"},
		ToPeptide[Peptide["CATHERINE"],ExplicitlyTyped->True],
		Peptide["CysAlaThrHisGluArgIleAsnGlu"]
	],
	Example[{Options,ExplicitlyTyped,"Return an explicitly typed peptide sequence from a provided explicitly typed peptide sequence with a motif name:"},
		ToPeptide[Peptide["CATHERINE","motifA"],ExplicitlyTyped->True],
		Peptide["CysAlaThrHisGluArgIleAsnGlu","motifA"]
	],
	Example[{Options,Consolidate,"If set to true, will consolidate sequences in a strand into a single sequence:"},
		ToPeptide[Strand["CysAlaThrHisGluArgIleAsnGlu","HisAnyAny"], Consolidate->True],
		Strand[Peptide["CysAlaThrHisGluArgIleAsnGluHisAnyAny"]]
	],
	Example[{Options,Consolidate,"If set to false, will leave rge sequences and motif infomation in place:"},
		ToPeptide[Strand["CysAlaThrHisGluArgIleAsnGlu","HisAnyAny"], Consolidate->False],
		Strand[Peptide["CysAlaThrHisGluArgIleAsnGlu"], Peptide["HisAnyAny"]]
	],
	Example[{Options,AlternativeEncodings,"Alternative coding alphabets for the polymer will be checked when AlternativeEncodings is set to True:"},
		ToPeptide["CATHERINE",AlternativeEncodings->True],
		"CysAlaThrHisGluArgIleAsnGlu"
	],
	Example[{Options,AlternativeEncodings,"If AlternativeEncodings is set to False, then alternative coding alphabets for the polymer will not be permitted in the sequence:"},
		ToPeptide["CATHERINE",AlternativeEncodings->False],
		$Failed,
		Messages:>Message[ToPeptide::missMatchPolymer, "CATHERINE", "Peptide"]
	]
}];


(* ::Subsubsection::Closed:: *)
(*ToRNA*)


DefineTests[ToRNA,{
	Example[{Basic,"The function is used to Convert any sequene into its equivalent DNA sequence:"},
		ToRNA["ATCTAGT"],
		"AUCUAGU"
	],
	Example[{Basic,"The function can also Convert strands into all DNA sequence versions of that Strand:"},
		ToRNA[Strand[DNA["ATGTATAC"],RNA["AUCUAUC"]]],
		Strand[RNA["AUGUAUACAUCUAUC"]]
	],
	Example[{Additional,"It can handle implicitly or explicitly typed input sequences:"},
		ToRNA[DNA["ATCTATG"]],
		RNA["AUCUAUG"]
	],
	Example[{Additional,"Preserves any motif naming as part of the conversion:"},
		ToRNA[DNA["ATCTATG","B"]],
		RNA["AUCUAUG","B"]
	],
	Example[{Additional,"Works with degenerate sequences as well:"},
		ToRNA[PNA[5]],
		RNA["NNNNN"]
	],
	Example[{Additional,"While perserving motif names as well:"},
		ToRNA[PNA[5,"B"]],
		RNA["NNNNN","B"]
	],
	Example[{Additional,"Converting to RNA for LNAChimera:"},
		ToRNA[LNAChimera["+A+TmGfC+U"]],
		RNA["AUGCU"]
	],
	Example[{Issues,"Converts sequences for which there is a cognite watson-crick pair into an empty string:"},
		ToRNA[Peptide["LysArgHis"]],
		""
	],
	Example[{Options,Consolidate,"Consolidate will turn the Strand into a single long DNA motif upon conversion:"},
		ToRNA[Strand[DNA["ATGTATAC","A"],RNA["AUCUAUC","B"]],Consolidate->True],
		Strand[RNA["AUGUAUACAUCUAUC"]]
	],
	Example[{Options,Consolidate,"However, if Consolidate is set to false, consolidate will leave the individual motifs in tact:"},
		ToRNA[Strand[DNA["ATGTATAC","A"],RNA["AUCUAUC","B"]],Consolidate->False],
		Strand[RNA["AUGUAUAC","A"],RNA["AUCUAUC","B"]]
	],
	Example[{Options,ExplicitlyTyped,"The ExplicitlyTyped option can be used to control the typing of the output:"},
		ToRNA["ATGTCTA",ExplicitlyTyped->True],
		RNA["AUGUCUA"]
	],
	Example[{Attributes,"Listable","The function is listable by sequence:"},
		ToRNA[{"ATGAT","AUCUA",DNA[5],RNA["ACUA"]}],
		{"AUGAU","AUCUA",RNA["NNNNN"],RNA["ACUA"]}
	],
	Test["Symbolic input remains unevaluated:",
		ToRNA[Fish],
		_ToRNA
	],
	Test["Detyping numeric input provides degenerate sequences:",
		ToRNA[DNA[5],ExplicitlyTyped->False],
		"NNNNN"
	]
}];


(* ::Subsubsection::Closed:: *)
(*ToLRNA*)


DefineTests[ToLRNA,{
	Example[{Basic,"The function is used to Convert any sequene into its equivalent DNA sequence:"},
		ToLRNA["ATCTAGT"],
		"AUCUAGU"
	],
	Example[{Basic,"The function can also Convert strands into all LRNA sequence versions of that Strand:"},
		ToLRNA[Strand[DNA["ATGTATAC"],RNA["AUCUAUC"]]],
		Strand[LRNA["AUGUAUACAUCUAUC"]]
	],
	Example[{Additional,"It can handle implicitly or explicitly typed input sequences:"},
		ToLRNA[DNA["ATCTATG"]],
		LRNA["AUCUAUG"]
	],
	Example[{Additional,"Preserves any motif naming as part of the conversion:"},
		ToLRNA[DNA["ATCTATG","B"]],
		LRNA["AUCUAUG","B"]
	],
	Example[{Additional,"Works with degenerate sequences as well:"},
		ToLRNA[PNA[5]],
		LRNA["NNNNN"]
	],
	Example[{Additional,"While perserving motif names as well:"},
		ToLRNA[PNA[5,"B"]],
		LRNA["NNNNN","B"]
	],
	Example[{Additional,"Converting to RNA for LNAChimera:"},
		ToLRNA[LNAChimera["+A+TmGfC+U"]],
		LRNA["+A+UGC+U"]
	],
	Example[{Issues,"Converts sequences for which there is a cognite watson-crick pair into an empty string:"},
		ToLRNA[Peptide["LysArgHis"]],
		""
	],
	Example[{Options,Consolidate,"Consolidate will turn the Strand into a single long LRNA motif upon conversion:"},
		ToLRNA[Strand[DNA["ATGTATAC","A"],RNA["AUCUAUC","B"]],Consolidate->True],
		Strand[LRNA["AUGUAUACAUCUAUC"]]
	],
	Example[{Options,Consolidate,"However, if Consolidate is set to false, consolidate will leave the individual motifs in tact:"},
		ToLRNA[Strand[DNA["ATGTATAC","A"],RNA["AUCUAUC","B"]],Consolidate->False],
		Strand[LRNA["AUGUAUAC","A"],LRNA["AUCUAUC","B"]]
	],
	Example[{Options,ExplicitlyTyped,"The ExplicitlyTyped option can be used to control the typing of the output:"},
		ToLRNA["ATGTCTA",ExplicitlyTyped->True],
		LRNA["AUGUCUA"]
	],
	Example[{Attributes,"Listable","The function is listable by sequence:"},
		ToLRNA[{"ATGAT","AUCUA",DNA[5],RNA["ACUA"]}],
		{"AUGAU","AUCUA",LRNA["NNNNN"],LRNA["ACUA"]}
	],
	Test["Symbolic input remains unevaluated:",
		ToLRNA[Fish],
		_ToLRNA
	],
	Test["Detyping numeric input provides degenerate sequences:",
		ToLRNA[DNA[5],ExplicitlyTyped->False],
		"NNNNN"
	]
}];


(* ::Subsubsection:: *)
(*Monomers*)


DefineTests[Monomers,{
	Example[{Basic,"Splits a polymer into a list of its Monomers:"},
		Monomers["CATCAGCTCAGCTTAAGGAG"],
		{"C","A","T","C","A","G","C","T","C","A","G","C","T","T","A","A","G","G","A","G"}
	],
	Example[{Additional,"Works on RNA:"},
		Monomers["AUGAGUA"],
		{"A","U","G","A","G","U","A"}
	],
	Example[{Additional,"Worsk for peptides:"},
		Monomers["AlaTrpSerValSerThrCysPheHisTrp"],
		{"Ala","Trp","Ser","Val","Ser","Thr","Cys","Phe","His","Trp"}
	],
	Example[{Messages,"unknownPolymer","Invalid/Unknown sequence will throw a message:"},
		Monomers[{"CATCAGCTCAGCTTAAGGAG","AlaTrpSerValSerThrCysPheHisTrp","Fish"}],
		{{"C","A","T","C","A","G","C","T","C","A","G","C","T","T","A","A","G","G","A","G"},{"Ala","Trp","Ser","Val","Ser","Thr","Cys","Phe","His","Trp"},$Failed},
		Messages:>Message[Monomers::unknownPolymer,"Fish"]
	],
	(*Example[{Messages,"unResolved","If FastTrack is set to be True, but provided sequence is untyped, cannot resolve and throw a message:"},
		Monomers["LysArgArg", FastTrack->True],
		$Failed,
		Messages:>Message[Monomers::unResolved,"LysArgArg"]
	],*)
	Example[{Basic,"Splits explicitly typed polymers into explicitly typed Monomers:"},
		Monomers[DNA["ATGATA"]],
		{DNA["A"],DNA["T"],DNA["G"],DNA["A"],DNA["T"],DNA["A"]}
	],
	Example[{Additional,"Works with named strands:"},Monomers[DNA["ATGATA","Pony"]],{DNA["A"],DNA["T"],DNA["G"],DNA["A"],DNA["T"],DNA["A"]}],
	Test["Works with explicitly typed RNA:",Monomers[RNA["AUGAUA"]],{RNA["A"],RNA["U"],RNA["G"],RNA["A"],RNA["U"],RNA["A"]}],
	Test["Works with explicitly typed peptides:",Monomers[Peptide["LysArgHis"]],{Peptide["Lys"],Peptide["Arg"],Peptide["His"]}],
	Test["Works with named peptides:",Monomers[Peptide["LysArgHis","cat"]],{Peptide["Lys"],Peptide["Arg"],Peptide["His"]}],
	Example[{Attributes,Listable,"Maps over lists of both typed and untyped sequences:"},
		Monomers[{Peptide["LysArgHis"],DNA["ATGATA"],"ATGATATA","LysHisArgHisArg"}],
		{{Peptide["Lys"],Peptide["Arg"],Peptide["His"]},{DNA["A"],DNA["T"],DNA["G"],DNA["A"],DNA["T"],DNA["A"]},{"A","T","G","A","T","A","T","A"},{"Lys","His","Arg","His","Arg"}}
	],
	Example[{Options,ExplicitlyTyped,"When True, always returns explicitly typed Monomers:"},
		Monomers["ATGATA",ExplicitlyTyped->True],
		{DNA["A"],DNA["T"],DNA["G"],DNA["A"],DNA["T"],DNA["A"]}
	],
	Example[{Options,ExplicitlyTyped,"When False, only returns lists of untyped Monomers:"},
		Monomers[DNA["ATGATA"],ExplicitlyTyped->False],
		{"A","T","G","A","T","A"}
	],
	Example[{Additional,"Works with wildcard Monomers:"},
		Monomers[RNA[12]],
		{RNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"]}
	],
	Test["Works with wildcard peptides:",Monomers[Peptide[12]],{Peptide["Any"],Peptide["Any"],Peptide["Any"],Peptide["Any"],Peptide["Any"],Peptide["Any"],Peptide["Any"],Peptide["Any"],Peptide["Any"],Peptide["Any"],Peptide["Any"],Peptide["Any"]}],
	Test["Works with named wildcards:",Monomers[DNA[12,"Cats"]],{DNA["N"],DNA["N"],DNA["N"],DNA["N"],DNA["N"],DNA["N"],DNA["N"],DNA["N"],DNA["N"],DNA["N"],DNA["N"],DNA["N"]}],
	Test["Works with combined wildcards and Monomers:",Monomers["ATGACNNNACCNCANN"],{"A","T","G","A","C","N","N","N","A","C","C","N","C","A","N","N"}],
	Example[{Basic,"Splits a Strand into its Monomers:"},
		Monomers[Strand[DNA["ATGATA"]]],
		{DNA["A"],DNA["T"],DNA["G"],DNA["A"],DNA["T"],DNA["A"]}
	],
	Test["Splits wildcard Strand into wildcard Monomers:",
		Monomers[Strand[DNA[5]]],
		{DNA["N"],DNA["N"],DNA["N"],DNA["N"],DNA["N"]}
	],
	Test["Works with multiple polymer types in one Strand:",
		Monomers[Strand[DNA[5],PNA[5],RNA[5]]],
		{DNA["N"],DNA["N"],DNA["N"],DNA["N"],DNA["N"],PNA["N"],PNA["N"],PNA["N"],PNA["N"],PNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"]}
	],
	Test["Works with multiple polymer types and wildcards in a Strand:",
		Monomers[Strand[DNA["NNTGNN"],PNA[5],RNA[5]]],
		{DNA["N"],DNA["N"],DNA["T"],DNA["G"],DNA["N"],DNA["N"],PNA["N"],PNA["N"],PNA["N"],PNA["N"],PNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"]}
	],
	Example[{Additional,"Splits starnds with multiple polymer types into Monomers:"},
		Monomers[Strand[DNA["ATGCAT","Cat"],RNA[5,"Fish"]]],
		{DNA["A"],DNA["T"],DNA["G"],DNA["C"],DNA["A"],DNA["T"],RNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"]}
	],
	Example[{Additional,"Splitting two modifications:"},
		Monomers[Modification["TamraDabcyl"]],
		{Modification["Tamra"], Modification["Dabcyl"]}
	],
	Example[{Attributes,"Listable","Maps across lists of strands:"},
		Monomers[{Strand[DNA["ATGCAT","Cat"],RNA[5,"Fish"]],Strand[DNA[5],PNA[5],RNA[5]]}],
		{{DNA["A"],DNA["T"],DNA["G"],DNA["C"],DNA["A"],DNA["T"],RNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"]},{DNA["N"],DNA["N"],DNA["N"],DNA["N"],DNA["N"],PNA["N"],PNA["N"],PNA["N"],PNA["N"],PNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"],RNA["N"]}}
	],
	Example[{Options,Polymer,"Set the polymer type:"},
		Monomers["AGCGCA",Polymer->RNA,ExplicitlyTyped->True],
		{RNA["A"],RNA["G"],RNA["C"],RNA["G"],RNA["C"],RNA["A"]}
	]

}];


(* ::Subsubsection:: *)
(*Dimers*)


DefineTests[Dimers,
{




	Example[{Basic,"Returns overlapping Dimers given an explicitly typed sequence:"},Dimers[DNA["ATGATA"]],{DNA["AT"],DNA["TG"],DNA["GA"],DNA["AT"],DNA["TA"]}],
	Example[{Basic,"Returns overlapping Dimers given an implicitly typed sequence:"},Dimers["LysHisArgHisArg"],{"LysHis","HisArg","ArgHis","HisArg"}],

	Example[{Attributes,Listable,"Returns a list of Dimers for each input sequence:"},Dimers[{"CATCAGCTCAGCTTAAGGAG","AlaTrpSerValSerThrCysPheHisTrp"}],{{"CA","AT","TC","CA","AG","GC","CT","TC","CA","AG","GC","CT","TT","TA","AA","AG","GG","GA","AG"},{"AlaTrp","TrpSer","SerVal","ValSer","SerThr","ThrCys","CysPhe","PheHis","HisTrp"}}],

	Example[{Options,Polymer,"Specify the polymer type for the input:"},Dimers["ATTGGCTGTAGC",Polymer->DNA],{"AT","TT","TG","GG","GC","CT","TG","GT","TA","AG","GC"}],

	Example[{Options,ExplicitlyTyped,"If ExplicitlyTyped->True, the output will be explicitly typed:"},Dimers["ATTGGCTGTAGC",ExplicitlyTyped->True],{DNA["AT"],DNA["TT"],DNA["TG"],DNA["GG"],DNA["GC"],DNA["CT"],DNA["TG"],DNA["GT"],DNA["TA"],DNA["AG"],DNA["GC"]}],

	Example[{Options,ExplicitlyTyped,"If ExplicitlyTyped->False, the output will be implicitly typed:"},Dimers[DNA["ATTGGCTGTAGC"],ExplicitlyTyped->False],{"AT","TT","TG","GG","GC","CT","TG","GT","TA","AG","GC"}],


	Test["Accepts an implicitly typed DNA sequence:",Dimers["ATGATATA"],{"AT","TG","GA","AT","TA","AT","TA"}],
	Test["Accepts an implicitly typed DNA sequence:",Dimers["CATCAGCTCAGCTTAAGGAG"],{"CA","AT","TC","CA","AG","GC","CT","TC","CA","AG","GC","CT","TT","TA","AA","AG","GG","GA","AG"}],
	Test["Accepts an implicitly typed RNA sequence:",Dimers["AUGAGUA"],{"AU","UG","GA","AG","GU","UA"}],

	Test["Ignores motif name in explicitly typed DNA sequence:",Dimers[DNA["ATGATA","Pony"]],{DNA["AT"],DNA["TG"],DNA["GA"],DNA["AT"],DNA["TA"]}],
	Test["Accepts an explicitly typed RNA sequence:",Dimers[RNA["AUGAUA"]],{RNA["AU"],RNA["UG"],RNA["GA"],RNA["AU"],RNA["UA"]}],
	Test["Accepts an explicitly typed Peptide sequence:",Dimers[Peptide["LysArgHis"]],{Peptide["LysArg"],Peptide["ArgHis"]}],
	Test["Ignores motif name in explicitly typed Peptide sequences:",Dimers[Peptide["LysArgHis","cat"]],{Peptide["LysArg"],Peptide["ArgHis"]}],
	Test["Listable with a mixture of polymer types and implicit/explicitly defined:",Dimers[{Peptide["LysArgHis"],DNA["ATGATA"],"ATGATATA","LysHisArgHisArg"}],{{Peptide["LysArg"],Peptide["ArgHis"]},{DNA["AT"],DNA["TG"],DNA["GA"],DNA["AT"],DNA["TA"]},{"AT","TG","GA","AT","TA","AT","TA"},{"LysHis","HisArg","ArgHis","HisArg"}}],
	Test["Accepts an implicitly typed DNA sequence with degeneracy:",Dimers["ATGNCNNNNACC"],{"AT","TG","GN","NC","CN","NN","NN","NN","NA","AC","CC"}],
	Test["Accepts an explicitly typed DNA sequence with degeneracy:",Dimers[DNA[10]],{DNA["NN"],DNA["NN"],DNA["NN"],DNA["NN"],DNA["NN"],DNA["NN"],DNA["NN"],DNA["NN"],DNA["NN"]}],
	Test["Accepts an explicitly typed RNA sequence with degeneracy:",Dimers[RNA[10]],{RNA["NN"],RNA["NN"],RNA["NN"],RNA["NN"],RNA["NN"],RNA["NN"],RNA["NN"],RNA["NN"],RNA["NN"]}],
	Test["Accepts an implicitly typed peptide sequence with degeneracy:",Dimers["LysAnyLysArg"],{"LysAny","AnyLys","LysArg"}],
	Example[{Options,Polymer,"Specify the polymer type for the input - throw a message if the sequence is not valid for that polymer type:"},
			Dimers["ATTGGCTGTAGC",Polymer->Peptide],
			$Failed,
			Messages:>Message[Monomers::missMatchPolymer,"ATTGGCTGTAGC","Peptide"]],
	Example[{Messages, "missMatchPolymer", "Return failed on mismatched explicit typing and sequence contents:"},
			Dimers[DNA["LysArgArg"]],
			$Failed,
			Messages:>Message[Monomers::missMatchPolymer,ToString[DNA["LysArgArg"]],"DNA"]
			],
	(*Example[{Messages, "unResolved", "FastTrack:"},
			Dimers["LysArgArg",FastTrack->True],
			$Failed,
			Messages:>Message[Monomers::unResolved,"LysArgArg"]
		],*)
	Example[{Messages, "unknownPolymer", "Return failed when given a non-sequence:"},
			Dimers["Fish"],
			$Failed,
			Messages:>Message[Monomers::unknownPolymer,"Fish"]
		]
}];


(* ::Subsubsection:: *)
(*ReverseSequence*)


DefineTests[ReverseSequence,List[
	Example[{Basic,"Gives the reverse sequence of the provided sequence:"},
		ReverseSequence["AGAGG"],
		"GGAGA"
	],
	Example[{Basic,"When provided with a Strand, gives a Strand with complementary sequences:"},
		ReverseSequence[Strand[DNA["AGAGG"],RNA["AGCUA"]]],
		Strand[RNA["AUCGA"],DNA["GGAGA"]]
	],
	Example[{Basic,"Can handle explicitly typed sequences as well as implicitly typed sequences:"},
		ReverseSequence[DNA["AGAGG"]],
		DNA["GGAGA"]
	],
	Example[{Additional,"Can handle LNAChimera with or without header:"},
		ReverseSequence[{LNAChimera["+TfG"], "+GfU"}],
		{LNAChimera["fG+T"],"fU+G"}
	],
	Example[{Options,Polymer,"The Polymer option can be used to spesify what type of sequence is provided:"},
		ReverseSequence["ACAGA",Polymer->RNA],
		"AGACA"
	],
	Example[{Options,ExplicitlyTyped,"Explicit or implicitly typed output can be requested using the ExplicitlyTyped option:"},
		ReverseSequence["AGAGG",ExplicitlyTyped->True],
		DNA["GGAGA"]
	],
	Example[{Attributes,"Listable","The function is listable by Strand or by sequence:"},
		ReverseSequence[{"AGCAT","GCAGG","TGATT"}],
		{"TACGA","GGACG","TTAGT"}
	],
	Example[{Issues,"Calling ReverseSequence will strip off any motif information:"},
		ReverseSequence[DNA["AGAGG","B"]],
		DNA["GGAGA"]
	],
	Test["Symbolic input remains unevaluated:",
		ReverseSequence[Fish],
		_ReverseSequence
	],
	Test["Detyping numeric input provides degenerate sequences:",
		ReverseSequence[DNA[5],ExplicitlyTyped->False],
		"NNNNN"
	],
	Test["Testing explicitly typing with strands:",
		ReverseSequence[Strand[DNA["ATGCA"]],ExplicitlyTyped->False],
		Strand[DNA["ACGTA"]]
	]
]];


(* ::Subsubsection:: *)
(*ReverseSequenceQ*)


DefineTests[ReverseSequenceQ,{
	Example[{Basic,"Check if two sequences are the reverse of eachother:"},
		ReverseSequenceQ["ATGC","CGTA"],
		True
	],
	Example[{Basic,"The function works with polymers that have non-single base Monomers:"},
		ReverseSequenceQ["LysArgHis","HisArgLys"],
		True
	],
	Example[{Basic,"Strands can be used as inputs in addition to sequences:"},
		ReverseSequenceQ[Strand[DNA["ATGC"],Modification["Fluorescein"]],Strand[Modification["Fluorescein"],DNA["CGTA"]]],
		True
	],
	Example[{Additional,"Works with explicitly typed and implicitly typed sequences:"},
		ReverseSequenceQ[DNA["ATGC"],DNA["CGTA"]],
		True
	],
	Example[{Additional,"Can also mix and match explicitly typed and implicitly typed sequences:"},
		ReverseSequenceQ[DNA["ATGC"],"CGTA"],
		True
	],
	Example[{Options,Degeneracy,"The Degeneracy option can be used to allow degenerate sequences to match:"},
		ReverseSequenceQ["ATGCA","ACGNN",Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"If set to False the Degeneracy option can be used to require a strict match:"},
		ReverseSequenceQ["ATGCA","ACGNN",Degeneracy->False],
		False
	],
	Example[{Options,CanonicalPairing,"The CanonicalPairing option can be used to allow for matches across RNA/DNA polymers:"},
		ReverseSequenceQ["ATGC","CGUA",CanonicalPairing->True],
		True
	],
	Example[{Options,CanonicalPairing,"Or if set to False, the CanonicalPairing option will require a strict match across polymers:"},
		ReverseSequenceQ["ATGC","CGUA",CanonicalPairing->False],
		False
	],
	Example[{Options,Polymer,"The Polymer option is used to establish the polymer types of implicitly typed sequences:"},
		ReverseSequenceQ["ACGA","AGCA",Polymer->RNA],
		True
	],
	Example[{Attributes,"Listable","The function is listable by sequences:"},
		ReverseSequenceQ["ATGC",{"CGTA","TGCA","ATAT"}],
		{True,False,False}
	],
	Example[{Attributes,"Listable","The function MapThreads over pairs of lists:"},
		ReverseSequenceQ[{"ATGC","ACGT","TTTT"},{"CGTA","TGCA","ATAT"}],
		{True,True,False}
	],
	Test["Symbolic input remains unevaluated:",
		ReverseSequenceQ["ArgHisHisArg",Fish],
		_ReverseSequenceQ
	]
}];


(* ::Subsubsection:: *)
(*ComplementSequence*)


DefineTests[ComplementSequence,{
	Example[{Basic,"Gives the complementary sequence by Watson-Crick Pairing:"},
		ComplementSequence["AGAGG"],
		"TCTCC"
	],
	Example[{Basic,"When provided with a Strand, gives a Strand with complementary sequences:"},
		ComplementSequence[Strand[DNA["AGAGG"],RNA["AGCUA"]]],
		Strand[DNA["TCTCC"],RNA["UCGAU"]]
	],
	Example[{Basic,"Can handle explicitly typed sequences as well as implicitly typed sequences:"},
		ComplementSequence[DNA["AGAGG"]],
		DNA["TCTCC"]
	],
	Example[{Options,Polymer,"The Polymer option can be used to spesify what type of sequence is provided:"},
		ComplementSequence["ACAGA",Polymer->RNA],
		"UGUCU"
	],
	Example[{Options,ExplicitlyTyped,"Explicit or implicitly typed output can be requested using the ExplicitlyTyped option:"},
		ComplementSequence["AGAGG",ExplicitlyTyped->True],
		DNA["TCTCC"]
	],
	Example[{Attributes,"Listable","The function is listable by Strand or by sequence:"},
		ComplementSequence[{"AGCAT","GCAGG","TGATT"}],
		{"TCGTA","CGTCC","ACTAA"}
	],
	Example[{Issues,"Calling ComplementSequence will strip off any motif information:"},
		ComplementSequence[DNA["AGAGG","B"]],
		DNA["TCTCC"]
	],
	Test["Symbolic input remains unevaluated:",
		ComplementSequence[Fish],
		_ComplementSequence
	],
	Test["Detyping numeric input provides degenerate sequences:",
		ComplementSequence[DNA[5],ExplicitlyTyped->False],
		"NNNNN"
	],
	Test["Testing explicitly typing with strands:",
		ComplementSequence[Strand[DNA["ATGCA"]],ExplicitlyTyped->False],
		Strand[DNA["TACGT"]]
	],

	Test["Modification remains untouched:",
		ComplementSequence["Fluorescein"],
		"Fluorescein"
	],
	Test["Peptide remains untouched:",
		ComplementSequence["LysHisArg"],
		"LysHisArg"
	],
	Test["Explicitly typded Modification remains untouched:",
		ComplementSequence[Modification["Fluorescein"],IncludeModification->True],
		Modification["Fluorescein"]
	],
	Example[{Messages,"RemoveModification","Return Null for cases where modification is asked to be removed but cannot:"},
		ComplementSequence[Modification["Fluorescein"],IncludeModification->False],
		Null,
		Messages:>Message[ComplementSequence::RemoveModification]
	],
	Test["Return Null if given just modification or Peptide and not including it:",
		ComplementSequence[Peptide["LysHisArg"],IncludeModification->False],
		Null,
		Messages:>Message[ComplementSequence::RemoveModification]
	],
	Test["Modification in strand remains untouched:",
		ComplementSequence[Strand[Modification["Fluorescein"]],IncludeModification->True],
		Strand[Modification["Fluorescein"]]
	],
	Test["Modification in strand remains untouched:",
		ComplementSequence[Strand[Modification["Fluorescein"]],IncludeModification->False],
		Strand[]
	],
	Example[{Options,IncludeModification,"Leave modifications as they are in the strand:"},
		ComplementSequence[Strand[DNA["AAAA"],Modification["Fluorescein"],RNA["CCC"],Peptide["LysHisArg"]],IncludeModification->True],
		Strand[DNA["TTTT"],Modification["Fluorescein"],RNA["GGG"],Peptide["LysHisArg"]]
	],
	Example[{Options,IncludeModification,"Remove any modifications:"},
		ComplementSequence[Strand[DNA["AAAA"],Modification["Fluorescein"],RNA["CCC"],Peptide["LysHisArg"]],IncludeModification->False],
		Strand[DNA["TTTT"],RNA["GGG"]]
	]
}];



(* ::Subsubsection:: *)
(*ComplementSequenceQ*)


DefineTests[ComplementSequenceQ,{
	Example[{Basic,"Check if two sequences are the Watson-Crick compliment of eachother:"},
		ComplementSequenceQ["ATGC","TACG"],
		True
	],
	Example[{Basic,"Sequences can be implicity or explicitly typed:"},
		ComplementSequenceQ[DNA["ATGC"],DNA["TACG"]],
		True
	],
	Example[{Basic,"Strands can be used as inputs in addition to sequences:"},
		ComplementSequenceQ[Strand[DNA["ATGC"],RNA["AUGC"]],Strand[DNA["TACG"],RNA["UACG"]]],
		True
	],
	Example[{Additional,"Can also mix and match explicitly typed and implicitly typed sequences:"},
		ComplementSequenceQ[DNA["ATGC"],"TACG"],
		True
	],
	Example[{Additional,"Non-Pairing sequences are not considered complements:"},
		ComplementSequenceQ["HisLysLysHis","HisLysLysHis"],
		False
	],
	Example[{Options,Degeneracy,"The Degeneracy option can be used to allow degenerate sequences to match:"},
		ComplementSequenceQ["ATGCA","TACNN",Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"Or if set to False the Degeneracy option can be used to require a strict match:"},
		ComplementSequenceQ["ATGCA","TACNN",Degeneracy->False],
		False
	],
	Example[{Options,CanonicalPairing,"The CanonicalPairing option can be used to allow for matches across RNA/DNA polymers:"},
		ComplementSequenceQ["ATGC","UACG",CanonicalPairing->True],
		True
	],
	Example[{Options,CanonicalPairing,"Or if set to False, the CanonicalPairing option will require a strict match across polymers:"},
		ComplementSequenceQ["ATGC","UACG",CanonicalPairing->False],
		False
	],
	Example[{Options,Polymer,"The Polymer option is used to establish the polymer types of implicitly typed sequences when considering a match:"},
		ComplementSequenceQ["ACGA","TGCT",CanonicalPairing->False,Polymer->DNA],
		True
	],
	Example[{Options,Polymer,"And thus it can be used to require strict matching of the polymer in a comparison:"},
		ComplementSequenceQ["ACGA","TGCT",CanonicalPairing->False,Polymer->RNA],
		False
	],
	Example[{Attributes,"Listable","The function is listable by sequences:"},
		ComplementSequenceQ["ATGC",{"TACG","GCCT","TTAT"}],
		{True,False,False}
	],
	Example[{Attributes,"Listable","The function MapThreads over pairs of lists:"},
		ComplementSequenceQ[{"ATGC","ACGT","TTTT"},{"TACG","TGCA","ATAT"}],
		{True,True,False}
	],
	Test["Symbolic input remains unevaluated:",
		ComplementSequenceQ["ATGCA",Fish],
		_ComplementSequenceQ
	],
	Test["Sequences that do not pair are considered False:",
		ComplementSequenceQ["ArgArg","Lys"],
		False
	],
	Test["CanonicalPairing set to True will allow DNA/RNA matches across strands:",
		ComplementSequenceQ[Strand[DNA["ATATAGCA"],DNA["GCTATCTG"]],Strand[DNA["TATATCGT"],RNA["CGAUAGAC"]],CanonicalPairing->True],
		True
	],
	Test["CanonicalPairing set to Falase will not allow DNA/RNA matches across strands:",
		ComplementSequenceQ[Strand[DNA["ATATAGCA"],DNA["GCTATCTG"]],Strand[DNA["TATATCGT"],RNA["CGAUAGAC"]],CanonicalPairing->False],
		False
	]
}];


(* ::Subsubsection:: *)
(*ReverseComplementSequence*)


DefineTests[ReverseComplementSequence,
	{
		Example[{Basic,"Given a sequence input will return the reverse complementary sequence:"},
			ReverseComplementSequence["ATGCG"],
			"CGCAT"
		],
		Example[{Basic,"If provided a Strand, the function returns a reverse complementary Strand:"},
			ReverseComplementSequence[Strand[DNA["ATGCA","A"],DNA["GCAGAT","B"]]],
			Strand[DNA["ATCTGC","B'"],DNA["TGCAT","A'"]]
		],
		Example[{Basic,"If provided a motif name, returns the reverse complimentary motif (' signify reverse complementarity):"},
			{ReverseComplementSequence["Cat"],ReverseComplementSequence["Cat'"]},
			{"Cat'","Cat"}
		],
		Example[{Additional,"The function can handle degenerate sequences as well:"},
			ReverseComplementSequence[DNA[25,"A'"]],
			DNA["NNNNNNNNNNNNNNNNNNNNNNNNN","A"]
		],
		Example[{Additional,"The reverse complement for LNAChimera:"},
			ReverseComplementSequence[LNAChimera["+A+TmG"]],
			LNAChimera["mC+A+T"]
		],
		Example[{Options,ExplicitlyTyped,"The ExplicitlyTyped option can be used to request that the output be explicitly typed:"},
			ReverseComplementSequence["AGCAUC",ExplicitlyTyped->True],
			RNA["GAUGCU"]
		],
		Example[{Options,Polymer,"The Polymer option can be used to disambiguate input:"},
			{ReverseComplementSequence["AGCAGG",Polymer->RNA,ExplicitlyTyped->True],ReverseComplementSequence["AGCAGG",Polymer->DNA,ExplicitlyTyped->True]},
			{RNA["CCUGCU"],DNA["CCTGCT"]}
		],
		Example[{Options,ExplicitlyTyped,"If ExplicitlyTyped is set to automatic, will match the typing of the input:"},
			{ReverseComplementSequence["AGCAUC"],ReverseComplementSequence[RNA["AGCAUC"]]},
			{"GAUGCU",RNA["GAUGCU"]}
		],
		Example[{Options,Motif,"The motif option can be used to indicate that a string input is a motif rather than a sequence:"},
			{ReverseComplementSequence["A",Motif->False],ReverseComplementSequence["A",Motif->True]},
			{"T","A'"}
		],
		Example[{Attributes,"Listable","The function is listable across sequences, strands, or motifs:"},
			ReverseComplementSequence[{"ATGAT","GCAGG","TGCAG"}],
			{"ATCAT","CCTGC","CTGCA"}
		],
		Test["Explicit typing can not be stripped from a Strand:",
			ReverseComplementSequence[Strand[DNA["ATGATA"]],ExplicitlyTyped->False],
			Strand[DNA["TATCAT"]]
		],

		Test["Modification remains untouched:",
			ReverseComplementSequence["Fluorescein"],
			"Fluorescein"
		],
		Test["Peptide remains uncomped:",
			ReverseComplementSequence["LysHisArg"],
			"ArgHisLys"
		],
		Test["Explicitly typded Modification remains untouched:",
			ReverseComplementSequence[Modification["Fluorescein"],IncludeModification->True],
			Modification["Fluorescein"]
		],
		Example[{Messages,"RemoveModification","Return Null for cases where modification is asked to be removed but cannot:"},
			ReverseComplementSequence[Modification["Fluorescein"],IncludeModification->False],
			Null,
			Messages:>{ComplementSequence::RemoveModification}
		],
		Test["Return Null if given just modification or Peptide and not including it:",
			ReverseComplementSequence[Peptide["LysHisArg"],IncludeModification->False],
			Null,
			Messages:>{ComplementSequence::RemoveModification}
		],
		Test["Modification in strand remains untouched:",
			ReverseComplementSequence[Strand[Modification["Fluorescein"]],IncludeModification->True],
			Strand[Modification["Fluorescein"]]
		],
		Test["Modification in strand remains untouched:",
			ReverseComplementSequence[Strand[Modification["Fluorescein"]],IncludeModification->False],
			Strand[]
		],
		Example[{Options,IncludeModification,"Leave modifications as they are in the strand:"},
			ReverseComplementSequence[Strand[DNA["AAAA"],Modification["Fluorescein"],RNA["CCC"],Peptide["LysHisArg"]],IncludeModification->True],
			Strand[Peptide["ArgHisLys"],RNA["GGG"],Modification["Fluorescein"],DNA["TTTT"]]
		],
		Example[{Options,IncludeModification,"Remove any modifications:"},
			ReverseComplementSequence[Strand[DNA["AAAA"],Modification["Fluorescein"],RNA["CCC"],Peptide["LysHisArg"]],IncludeModification->False],
			Strand[RNA["GGG"],DNA["TTTT"]]
		]
	}
];


(* ::Subsubsection:: *)
(*ReverseComplementSequenceQ*)


DefineTests[ReverseComplementSequenceQ,{
	Example[{Basic,"The function ReverseComplementSequenceQ is used to check if two sequences are the reverse complement of eachother:"},
		ReverseComplementSequenceQ["ATGGC","GCCAT"],
		True
	],
	Example[{Basic,"The function also works on strands as well as sequences:"},
		ReverseComplementSequenceQ[Strand[DNA["ATGGC"],RNA["AUUG"]],Strand[RNA["CAAU"],DNA["GCCAT"]]],
		True
	],
	Example[{Basic,"Motif names can also be exampined to see if they are reverse complementary by checking for a tick mark:"},
		ReverseComplementSequenceQ["Stem","Stem'"],
		True
	],
	Example[{Additional,"Works with explicitly typed and implicitly typed sequences:"},
		ReverseComplementSequenceQ[DNA["ATGC"],DNA["GCAT"]],
		True
	],
	Example[{Additional,"Can also mix and match explicitly typed and implicitly typed sequences:"},
		ReverseComplementSequenceQ[DNA["ATGC"],"GCAT"],
		True
	],
	Example[{Additional,"Non-Pairing sequences are not considered reverse complements:"},
		ReverseComplementSequenceQ["HisLysLysHis","HisLysLysHis"],
		False
	],
	Example[{Additional,"Test the reverse complement for LNAChimera:"},
		ReverseComplementSequenceQ[LNAChimera["+A+TmG"],LNAChimera["fC+A+T"]],
		True
	],
	Example[{Options,Degeneracy,"The Degeneracy option can be used to allow degenerate sequences to match:"},
		ReverseComplementSequenceQ["ATGCA","TGCNN",Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"Or if set to False the Degeneracy option can be used to require a strict match:"},
		ReverseComplementSequenceQ["ATGCA","TGCNN",Degeneracy->False],
		False
	],
	Example[{Options,Degeneracy,"Degenerate numeric sequences are considered matches when Degeneracy is set to True:"},
		ReverseComplementSequenceQ[DNA[12],DNA[12],Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"Degenerate numeric sequences are not considered matches when Degeneracy is set to False:"},
		ReverseComplementSequenceQ[DNA[12],DNA[12],Degeneracy->False],
		False
	],
	Example[{Options,CanonicalPairing,"The CanonicalPairing option can be used to allow for matches across RNA/DNA polymers:"},
		ReverseComplementSequenceQ["ATGC","GCAU",CanonicalPairing->True],
		True
	],
	Example[{Options,CanonicalPairing,"Or if set to False, the CanonicalPairing option will require a strict match across polymers:"},
		ReverseComplementSequenceQ["ATGC","GCAU",CanonicalPairing->False],
		False
	],
	Example[{Options,Polymer,"The Polymer option is used to establish the polymer types of implicitly typed sequences when considering a match:"},
		ReverseComplementSequenceQ["ACGA","TCGT",CanonicalPairing->False,Polymer->DNA],
		True
	],
	Example[{Options,Polymer,"And thus it can be used to require strict matching of the polymer in a comparison:"},
		ReverseComplementSequenceQ["ACGA","TCGT",CanonicalPairing->False,Polymer->RNA],
		False
	],
	Example[{Options,Motif,"The Motif options is used to disambiguate cases where a the inputs could be sequences or motifs:"},
		ReverseComplementSequenceQ["Cat","Cat'",Motif->True],
		True
	],
	Example[{Options,Motif,"If the Motif option is set to False, the function will assume its considering sequences:"},
		ReverseComplementSequenceQ["AT","AT",Motif->False],
		True
	],
	Example[{Options,Motif,"If the Motif option is set to True, the function will assume its considering motif names:"},
		{ReverseComplementSequenceQ["AT","AT",Motif->True],ReverseComplementSequenceQ["AT","AT'",Motif->True]},
		{False,True}
	],
	Example[{Options,Motif,"If the Motif option is set to Automatic and the case is ambigous, the function assumes its considering sequences:"},
		ReverseComplementSequenceQ["AT","AT",Motif->Automatic],
		True
	],
	Example[{Options,Motif,"In the context of a sequence, motif names are ignored by ReverseComplementSequenceQ:"},
		ReverseComplementSequenceQ[DNA["ATGCA","Fish"],DNA["TGCAT"]],
		True
	],
	Example[{Attributes,"Listable","The function is listable by sequences:"},
		ReverseComplementSequenceQ["ATGC",{"GCAT","GCCT","TTAT"}],
		{True,False,False}
	],
	Example[{Attributes,"Listable","The function MapThreads over pairs of lists:"},
		ReverseComplementSequenceQ[{"ATGC","ACGT","TTTT"},{"GCAT","ACGT","ATAT"}],
		{True,True,False}
	],
	Test["Symbolic input remains unevaluated:",
		ReverseComplementSequenceQ["ATGCA",Fish],
		_ReverseComplementSequenceQ
	],
	Test["Sequences that do not pair are considered False:",
		ReverseComplementSequenceQ["ArgArg",""],
		False
	],
	Test["CanonicalPairing set to True will allow DNA/RNA matches across strands:",
		ReverseComplementSequenceQ[Strand[DNA["ATATAGCA"],RNA["GCUAUCUG"]],Strand[RNA["CAGAUAGC"],DNA["TGCTATAT"]],CanonicalPairing->True],
		True
	]
}];


(* ::Subsubsection:: *)
(*SequencePalindromeQ*)


DefineTests[SequencePalindromeQ,{
	Example[{Options,Polymer,"Return False if polymer type does not match the given one:"},
		SequencePalindromeQ["GGGTGGCCGTACGGCCACCC",Polymer->RNA],
		False
	],
	Example[{Options,Degeneracy,"Allow degeneracy if this option is set to True:"},
		SequencePalindromeQ["GGGTGGCCGTACGGCCANNC",Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"Doesn't allow degeneracy if this option is set to False:"},
		SequencePalindromeQ["GGGTGGCCGTACGGCCANNC",Degeneracy->False],
		False
	],
	Test["Test 1:", SequencePalindromeQ["ATGATAGA"], False],
	Test["Test 2:", SequencePalindromeQ["AUGUCUUGUA"], False],
	Test["Test 3:", SequencePalindromeQ["ATCACACTATTAGTGTGATA"], False],
	Test["Test 5:", SequencePalindromeQ["AGTGTAAGGAAGGAATGTGA"], False],
	Test["Test 6:", SequencePalindromeQ["GGGTGGCCGTACGGCCACCC"], True],
	Test["Test 7:", SequencePalindromeQ["AUACCGGUACGUACCGGUAU"], True],
	Test["Test 8:", SequencePalindromeQ["HisLysLysHis"], False],
	Test["Test 9:", SequencePalindromeQ[{"ATGATATA","ATAGAC","GUUGACGCAUAUGCGUCAAC","AGTACATCTATGAGACA","TGGTAGTGGGCCCACTACCA"}],{False,False,True,False,True}],
	Test["Test 10:", SequencePalindromeQ[DNA["GGGTGGCCGTACGGCCACCC"]], True],
	Test["Test 11:", SequencePalindromeQ[DNA["GGGTGGCCGTACGGCCACCC","Catfish"]], True],
	Test["Test 12:", SequencePalindromeQ[RNA["AUACCGGUACGUACCGGUAU"]], True],
	Test["Test 13:", SequencePalindromeQ[RNA["AUACCGGUACGUACCGGUAU","Devil dog'"]], True],
	Test["Test 14:", SequencePalindromeQ[{"ATGATATA",DNA["ATAGAC"],RNA["GUUGACGCAUAUGCGUCAAC"],"AGTACATCTATGAGACA","TGGTAGTGGGCCCACTACCA"}],{False,False,True,False,True}],
	Test["Test 15:", SequencePalindromeQ["AGCNNATNNGCT"], True],
	Test["Test 16:", SequencePalindromeQ[DNA["AGCNNATNNGCT"]], True],
	Test["Test 17:", SequencePalindromeQ[DNA[12]], True],
	Test["Test 18:", SequencePalindromeQ[DNA[12],Degeneracy->False], False],
	Test["Test 19:", SequencePalindromeQ[DNA[5]], False],
	Test["Test 20:", SequencePalindromeQ["ANATTT"], True],
	Test["Test 21:", SequencePalindromeQ["ANATTT",Degeneracy->False], False],
	Test["Test 22:", SequencePalindromeQ[PNA["ANATTT"]], True],
	Test["Test 23:", SequencePalindromeQ[PNA["ANATTT"],Degeneracy->False], False],
	Test["Test 24:", SequencePalindromeQ[PNA["NNN"]], False]
}];


(* ::Subsubsection::Closed:: *)
(*SequenceLength*)


DefineTests[SequenceLength,{
	Example[{Basic,"Returns the length of any polymer in terms of the length of Monomers:"},
		SequenceLength["ATGCATAGGCATAGA"],
		15
	],
	Example[{Basic,"Works with explicitly typed sequences as well:"},
		SequenceLength[DNA["ATGCATAGGCATAGA"]],
		15
	],
	Example[{Basic,"Also works with degenerate sequences:"},
		SequenceLength[DNA[25]],
		25
	],
	Example[{Basic,"Works with non-monospaced polymers as well:"},
		SequenceLength[Peptide["AlaCysValPositiveTrpHisHydrophobic"]],
		7
	],
	Example[{Additional,"The sequence length for LNAChimera:"},
		SequenceLength[LNAChimera["+A+TmG+TfA+TmA"]],
		7
	],
	Example[{Options,Polymer,"The Polymer option can be used to identify the polymer type when implicitly typed:"},
		SequenceLength["AGCAGCA",Polymer->RNA],
		7
	],
	Example[{Attributes,"Listable","The functional is listable:"},
		SequenceLength[{"ATGTATA",DNA["NCAN"],RNA[12],"HisLysArg"}],
		{7,4,12,3}
	],
	Test["Empty strings are considered length 0:",
		SequenceLength[""],
		0
	],
	Test["Symbolic input remains unevaluated:",
		SequenceLength[Fish],
		_SequenceLength
	]
}];


(* ::Subsubsection:: *)
(*SequenceJoin*)


DefineTests[SequenceJoin,{
	Example[{Basic,"Given a list of sequence, the function will combin them in order to form a single sequence:"},
		SequenceJoin[{"ATGCATA","TGCACC","GGGCAT"}],
		"ATGCATATGCACCGGGCAT"
	],
	Example[{Basic,"Works on Sequences of sequences as well:"},
		SequenceJoin["ATGCATA","TGCACC","GGGCAT"],
		"ATGCATATGCACCGGGCAT"
	],
	Example[{Additional,"If explicitly provide a type and works, will join according to that type:"},
		SequenceJoin[{"ACCG", RNA["CCUUG"]}, Polymer->RNA],
		RNA["ACCGCCUUG"]
	],
	Example[{Messages,"invalidSeqs","If the sequences contains invalid sequence, a message will throw:"},
		SequenceJoin[{DNA["ATGCATA"], DNA["AUUCG"]}],
		$Failed,
		Messages:>Message[SequenceJoin::missMatchPolymer,ToString[DNA["AUUCG"]],"DNA"]
	],
	Example[{Messages,"missMatchPolymerType","If the sequences contains unmatching polymers, a message will throw:"},
		SequenceJoin[{DNA["ATGCATA"], RNA["AUUCG"]}],
		$Failed,
		Messages:>Message[SequenceJoin::unConsensus]
	],
	Example[{Options,Degeneracy,"The Degeneracy option can be used to allow degenerate sequences to match:"},
		SequenceJoin["ATGCA","TGCNN",Degeneracy->True],
		"ATGCATGCNN"
	],
	Example[{Options,ExplicitlyTyped,"Explicit or implicitly typed output can be requested using the ExplicitlyTyped option:"},
		SequenceJoin["AGAGG", "ATGCA",ExplicitlyTyped->True],
		DNA["AGAGGATGCA"]
	],
	Example[{Options,Polymer,"Works with explicitly typed sequence as well:"},
		SequenceJoin["CGGCA", "GGAUC",Polymer->RNA],
		"CGGCAGGAUC"
	]
}];


(* ::Subsubsection::Closed:: *)
(*SequenceFirst*)


DefineTests[SequenceFirst,List[
	Example[{Basic,"Extracts the first monomer from the sequence:"},
		SequenceFirst["ATGATAGATA"],
		"A"
	],
	Example[{Basic,"Works for any known polymer type:"},
		SequenceFirst["LysArgArgHisLys"],
		"Lys"
	],
	Example[{Basic,"Works on explicitly typed sequences as well:"},
		SequenceFirst[DNA["TGCAT"]],
		DNA["T"]
	],
	Example[{Basic,"Works for any known polymer type:"},
		SequenceFirst["LysArgArgHisLys"],
		"Lys"
	],
	Example[{Additional,"Numeric sequences work as well:"},
		SequenceFirst[DNA[10]],
		DNA["N"]
	],
	Example[{Options,ExplicitlyTyped,"When set to True, ExplicitlyTyped will wrap the output in its polymer type:"},
		SequenceFirst["TGCAT",ExplicitlyTyped->True],
		DNA["T"]
	],
	Example[{Options,ExplicitlyTyped,"When set to False, ExplicitlyTyped will strip the return the resulitng sequence sans the type:"},
		SequenceFirst[DNA["TGCAT"],ExplicitlyTyped->False],
		"T"
	],
	Example[{Options,ExplicitlyTyped,"If set to Automatic ExplicitlyTyped will preserve the input's explicitly typed status:"},
		SequenceFirst[DNA["TGCAT"],ExplicitlyTyped->Automatic],
		DNA["T"]
	],
	Example[{Options,ExplicitlyTyped,"If set to Automatic ExplicitlyTyped will preserve the input's explicitly typed status:"},
		SequenceFirst["TGCAT",ExplicitlyTyped->Automatic],
		"T"
	],
	Example[{Options,Polymer,"The polymer option can be used to force the type:"},
		SequenceFirst["AGCCAA",Polymer->RNA,ExplicitlyTyped->True],
		RNA["A"]
	],
	Example[{Options,Polymer,"The polymer option can be used to specify the type:"},
		SequenceFirst["AGCCAA",Polymer->DNA,ExplicitlyTyped->True],
		DNA["A"]
	],
	Example[{Issues,"Stripping the type from a numeric sequence will use the degenerate monomer to fill in:"},
		SequenceFirst[DNA[5],ExplicitlyTyped->False],
		"N"
	],
	Example[{Attributes,"Listable","The function is listable:"},
		SequenceFirst[{"ATGGCA",DNA["ATGCA"],"LysHisHisArg"}],
		{"A",DNA["A"],"Lys"}
	],
	Test["Symbols remain unevaluated:",
		SequenceFirst[Taco],
		_SequenceFirst
	]
]];


(* ::Subsubsection::Closed:: *)
(*SequenceLast*)


DefineTests[SequenceLast,List[
	Example[{Basic,"Extracts the last monomer from the sequence:"},
		SequenceLast["ATGATAGATA"],
		"A"
	],
	Example[{Basic,"Works for any known polymer type:"},
		SequenceLast["LysArgArgHisLys"],
		"Lys"
	],
	Example[{Basic,"Works on explicitly typed sequences as well:"},
		SequenceLast[DNA["TGCAT"]],
		DNA["T"]
	],
	Example[{Basic,"Works for any known polymer type:"},
		SequenceLast["LysArgArgHisLys"],
		"Lys"
	],
	Example[{Additional,"Numeric sequences work as well:"},
		SequenceLast[DNA[10]],
		DNA["N"]
	],
	Example[{Options,ExplicitlyTyped,"When set to True, ExplicitlyTyped will wrap the output in its polymer type:"},
		SequenceLast["TGCAT",ExplicitlyTyped->True],
		DNA["T"]
	],
	Example[{Options,ExplicitlyTyped,"When set to False, ExplicitlyTyped will strip the return the resulitng sequence sans the type:"},
		SequenceLast[DNA["TGCAT"],ExplicitlyTyped->False],
		"T"
	],
	Example[{Options,ExplicitlyTyped,"If set to Automatic ExplicitlyTyped will preserve the input's explicitly typed status:"},
		SequenceLast[DNA["TGCAT"],ExplicitlyTyped->Automatic],
		DNA["T"]
	],
	Example[{Options,ExplicitlyTyped,"If set to Automatic ExplicitlyTyped will preserve the input's explicitly typed status:"},
		SequenceLast["TGCAT",ExplicitlyTyped->Automatic],
		"T"
	],
	Example[{Options,Polymer,"The polymer option can be used to force the type:"},
		SequenceLast["AGCCAA",Polymer->RNA,ExplicitlyTyped->True],
		RNA["A"]
	],
	Example[{Options,Polymer,"The polymer option can be used to specify the type:"},
		SequenceLast["AGCCAA",Polymer->DNA,ExplicitlyTyped->True],
		DNA["A"]
	],
	Example[{Issues,"Stripping the type from a numeric sequence will use the degenerate monomer to fill in:"},
		SequenceLast[DNA[5],ExplicitlyTyped->False],
		"N"
	],
	Example[{Attributes,"Listable","The function is listable:"},
		SequenceLast[{"ATGGCA",DNA["ATGCA"],"LysHisHisArg"}],
		{"A",DNA["A"],"Arg"}
	],
	Test["Symbols remain unevaluated:",
		SequenceLast[Taco],
		_SequenceLast
	]
]];


(* ::Subsubsection::Closed:: *)
(*SequenceRest*)


DefineTests[SequenceRest,{
	Example[{Basic,"Extracts the all but the first monomer from the sequence:"},
		SequenceRest["ATGATAGATA"],
		"TGATAGATA"
	],
	Example[{Basic,"Works for any known polymer type:"},
		SequenceRest["LysArgArgHisLys"],
		"ArgArgHisLys"
	],
	Example[{Basic,"Works on explicitly typed sequences as well:"},
		SequenceRest[DNA["TGCAT"]],
		DNA["GCAT"]
	],
	Example[{Basic,"Works for any known polymer type:"},
		SequenceRest["LysArgArgHisLys"],
		"ArgArgHisLys"
	],
	Example[{Additional,"Numeric sequences work as well:"},
		SequenceRest[DNA[10]],
		DNA["NNNNNNNNN"]
	],
	Example[{Options,ExplicitlyTyped,"When set to True, ExplicitlyTyped will wrap the output in its polymer type:"},
		SequenceRest["TGCAT",ExplicitlyTyped->True],
		DNA["GCAT"]
	],
	Example[{Options,ExplicitlyTyped,"When set to False, ExplicitlyTyped will strip the return the resulitng sequence sans the type:"},
		SequenceRest[DNA["TGCAT"],ExplicitlyTyped->False],
		"GCAT"
	],
	Example[{Options,ExplicitlyTyped,"If set to Automatic ExplicitlyTyped will preserve the input's explicitly typed status:"},
		SequenceRest[DNA["TGCAT"],ExplicitlyTyped->Automatic],
		DNA["GCAT"]
	],
	Example[{Options,ExplicitlyTyped,"If set to Automatic ExplicitlyTyped will preserve the input's explicitly typed status:"},
		SequenceRest["TGCAT",ExplicitlyTyped->Automatic],
		"GCAT"
	],
	Example[{Options,Polymer,"The polymer option can be used to force the type:"},
		SequenceRest["AGCCAA",Polymer->RNA,ExplicitlyTyped->True],
		RNA["GCCAA"]
	],
	Example[{Options,Polymer,"The polymer option can be used to specify the type:"},
		SequenceRest["AGCCAA",Polymer->DNA,ExplicitlyTyped->True],
		DNA["GCCAA"]
	],
	Example[{Issues,"Stripping the type from a numeric sequence will use the degenerate monomer to fill in:"},
		SequenceRest[DNA[5],ExplicitlyTyped->False],
		"NNNN"
	],
	Example[{Attributes,"Listable","The function is listable:"},
		SequenceRest[{"ATGGCA",DNA["ATGCA"],"LysHisHisArg"}],
		{"TGGCA",DNA["TGCA"],"HisHisArg"}
	],
	Test["Symbols remain unevaluated:",
		SequenceRest[Taco],
		_SequenceRest
	]
}];


(* ::Subsubsection::Closed:: *)
(*SequenceMost*)


DefineTests[SequenceMost,{
	Example[{Basic,"Extracts the all but the first monomer from the sequence:"},
		SequenceMost["ATGATAGATA"],
		"ATGATAGAT"
	],
	Example[{Basic,"Works for any known polymer type:"},
		SequenceMost["LysArgArgHisLys"],
		"LysArgArgHis"
	],
	Example[{Basic,"Works on explicitly typed sequences as well:"},
		SequenceMost[DNA["TGCAT"]],
		DNA["TGCA"]
	],
	Example[{Basic,"Works for any known polymer type:"},
		SequenceMost["LysArgArgHisLys"],
		"LysArgArgHis"
	],
	Example[{Additional,"Numeric sequences work as well:"},
		SequenceMost[DNA[10]],
		DNA["NNNNNNNNN"]
	],
	Example[{Options,ExplicitlyTyped,"When set to True, ExplicitlyTyped will wrap the output in its polymer type:"},
		SequenceMost["TGCAT",ExplicitlyTyped->True],
		DNA["TGCA"]
	],
	Example[{Options,ExplicitlyTyped,"When set to False, ExplicitlyTyped will strip the return the resulitng sequence sans the type:"},
		SequenceMost[DNA["TGCAT"],ExplicitlyTyped->False],
		"TGCA"
	],
	Example[{Options,ExplicitlyTyped,"If set to Automatic ExplicitlyTyped will preserve the input's explicitly typed status:"},
		SequenceMost[DNA["TGCAT"],ExplicitlyTyped->Automatic],
		DNA["TGCA"]
	],
	Example[{Options,ExplicitlyTyped,"If set to Automatic ExplicitlyTyped will preserve the input's explicitly typed status:"},
		SequenceMost["TGCAT",ExplicitlyTyped->Automatic],
		"TGCA"
	],
	Example[{Options,Polymer,"The polymer option can be used to force the type:"},
		SequenceMost["AGCCAA",Polymer->RNA,ExplicitlyTyped->True],
		RNA["AGCCA"]
	],
	Example[{Options,Polymer,"The polymer option can be used to specify the type:"},
		SequenceMost["AGCCAA",Polymer->DNA,ExplicitlyTyped->True],
		DNA["AGCCA"]
	],
	Example[{Issues,"Stripping the type from a numeric sequence will use the degenerate monomer to fill in:"},
		SequenceMost[DNA[5],ExplicitlyTyped->False],
		"NNNN"
	],
	Example[{Attributes,"Listable","The function is listable:"},
		SequenceMost[{"ATGGCA",DNA["ATGCA"],"LysHisHisArg"}],
		{"ATGGC",DNA["ATGC"],"LysHisHis"}
	],
	Test["Symbols remain unevaluated:",
		SequenceMost[Taco],
		_SequenceMost
	]
}];


(* ::Subsubsection::Closed:: *)
(*SequenceTake*)


DefineTests[SequenceTake,{
	Example[{Basic,"Take 'n' Monomers from the front of a sequence:"},
		SequenceTake["ATGTACAT",5],
		"ATGTA"
	],
	Example[{Basic,"Take 'n' Monomers from the back of a sequence:"},
		SequenceTake["ATGTACAT",-5],
		"TACAT"
	],
	Example[{Basic,"Take 'n' though 'm' Monomers of a sequence:"},
		SequenceTake["ATGACAGTAGCA",Span[3,8]],
		"GACAGT"
	],
	Example[{Additional,"Works on explicitly typed sequences:"},
		SequenceTake[DNA["ATGTACAT"],5],
		DNA["ATGTA"]
	],
	Example[{Additional,"Works with numeric sequences as well:"},
		SequenceTake[DNA[20],5],
		DNA["NNNNN"]
	],
	Example[{Options,ExplicitlyTyped,"Setting ExplicitlyTyped to True will ensure that the output is typed:"},
		SequenceTake["ATGCAG",3,ExplicitlyTyped->True],
		DNA["ATG"]
	],
	Example[{Options,ExplicitlyTyped,"Setting ExplicitlyTyped to False will ensure that the output is not typed:"},
		SequenceTake["ATGCAG",3,ExplicitlyTyped->False],
		"ATG"
	],
	Example[{Options,ExplicitlyTyped,"Setting ExplicitlyTyped to Automatic will type the output if the input is typed:"},
		SequenceTake["ATGCAG",3,ExplicitlyTyped->Automatic],
		"ATG"
	],
	Example[{Options,ExplicitlyTyped,"Setting ExplicitlyTyped to Automatic will type the output if the input is typed:"},
		SequenceTake[DNA["ATGCAG"],3,ExplicitlyTyped->Automatic],
		DNA["ATG"]
	],
	Example[{Options,Polymer,"Polymer option can be used to specificity the explicit typing:"},
		SequenceTake["AGAAGAAACA",3,ExplicitlyTyped->True,Polymer->RNA],
		RNA["AGA"]
	],
	Example[{Options,Polymer,"Polymer option can be used to specificity the explicit typing:"},
		SequenceTake["AGAAGAAACA",3,ExplicitlyTyped->True,Polymer->DNA],
		DNA["AGA"]
	],
	Example[{Attributes,"Listable","The function is listable across the input sequences:"},
		SequenceTake[{"ATGACA","TCACGGC","GTGCAA"},3],
		{"ATG","TCA","GTG"}
	],
	Example[{Attributes,"Listable","The function is listable across 'n':"},
		SequenceTake["ATGATAGAAACA",Range[5]],
		{"A","AT","ATG","ATGA","ATGAT"}
	],
	Example[{Issues,"When ExplicitTyping is removed from numeric sequences, the degenerate monomer is used:"},
		SequenceTake[DNA[15],5,ExplicitlyTyped->False],
		"NNNNN"
	],
	Example[{Messages,"unmMatchLength","If input multiple sequences and indices but their lengths don't match, a message will throw:"},
		SequenceTake[{DNA["ATGCATA"], RNA["AUUCG"]}, {2,3,4}],
		$Failed,
		Messages:>Message[SequenceTake::unmMatchLength, 2, 3]
	]
}];


(* ::Subsubsection::Closed:: *)
(*SequenceDrop*)


DefineTests[SequenceDrop,{
	Example[{Basic,"Drops 'n' Monomers from the front of a sequence:"},
		SequenceDrop["ATGTACAT",5],
		"CAT"
	],
	Example[{Basic,"Drops 'n' Monomers from the back of a sequence:"},
		SequenceDrop["ATGTACAT",-5],
		"ATG"
	],
	Example[{Basic,"Drops the 'n' though 'm' Monomers of a sequence:"},
		SequenceDrop["ATGACAGTAGCA",Span[3,8]],
		"ATAGCA"
	],
	Example[{Additional,"Works on explicitly typed sequences:"},
		SequenceDrop[DNA["ATGTACAT"],5],
		DNA["CAT"]
	],
	Example[{Additional,"Works with numeric sequences as well:"},
		SequenceDrop[DNA[20],5],
		DNA["NNNNNNNNNNNNNNN"]
	],
	Example[{Options,ExplicitlyTyped,"Setting ExplicitlyTyped to True will ensure that the output is typed:"},
		SequenceDrop["ATGCAG",3,ExplicitlyTyped->True],
		DNA["CAG"]
	],
	Example[{Options,ExplicitlyTyped,"Setting ExplicitlyTyped to False will ensure that the output is not typed:"},
		SequenceDrop["ATGCAG",3,ExplicitlyTyped->False],
		"CAG"
	],
	Example[{Options,ExplicitlyTyped,"Setting ExplicitlyTyped to Automatic will type the output if the input is typed:"},
		SequenceDrop["ATGCAG",3,ExplicitlyTyped->Automatic],
		"CAG"
	],
	Example[{Options,ExplicitlyTyped,"Setting ExplicitlyTyped to Automatic will type the output if the input is typed:"},
		SequenceDrop[DNA["ATGCAG"],3,ExplicitlyTyped->Automatic],
		DNA["CAG"]
	],
	Example[{Options,Polymer,"Polymer option can be used to specificity the explicit typing:"},
		SequenceDrop["AGAAGAAACA",3,ExplicitlyTyped->True,Polymer->RNA],
		RNA["AGAAACA"]
	],
	Example[{Options,Polymer,"Polymer option can be used to specificity the explicit typing:"},
		SequenceDrop["AGAAGAAACA",3,ExplicitlyTyped->True,Polymer->DNA],
		DNA["AGAAACA"]
	],
	Example[{Attributes,"Listable","The function is listable across the input sequences:"},
		SequenceDrop[{"ATGACA","TCACGGC","GTGCAA"},3],
		{"ACA","CGGC","CAA"}
	],
	Example[{Attributes,"Listable","The function is listable across 'n':"},
		SequenceDrop["ATGATAGAAACA",Range[5]],
		{"TGATAGAAACA","GATAGAAACA","ATAGAAACA","TAGAAACA","AGAAACA"}
	],
	Example[{Issues,"When ExplicitTyping is removed from numeric sequences, the degenerate monomer is used:"},
		SequenceDrop[DNA[15],5,ExplicitlyTyped->False],
		"NNNNNNNNNN"
	],
	Example[{Messages,"unmMatchLength","If input multiple sequences and indices but their lengths don't match, a message will throw:"},
		SequenceDrop[{DNA["ATGCATA"], RNA["AUUCG"]}, {2,3,4}],
		$Failed,
		Messages:>Message[SequenceDrop::unmMatchLength, 2, 3]
	]
}];


(* ::Subsubsection:: *)
(*SequenceRotateRight*)


DefineTests[SequenceRotateRight,{
	Example[{Basic,"Rotating to the right will move the last monomer in the sequence to the front of the sequence:"},
		SequenceRotateRight["ATGGC"],
		"CATGG"
	],
	Example[{Basic,"Rotating to the right by 2 will move the last two bases to the front of the sequence:"},
		SequenceRotateRight["ATGGC",2],
		"GCATG"
	],
	Example[{Basic,"Rotation is on the basis of the number of Monomers rather then the number of characters in a string:"},
		SequenceRotateRight["LysHisArgGlnThr",2],
		"GlnThrLysHisArg"
	],
	Example[{Additional,"Rotataion works with degenerate sequences as well:"},
		SequenceRotateRight[DNA[5],2],
		DNA["NNNNN"]
	],
	Example[{Additional,"Rotating a sequence with a motif label will remove the label (since is sequence will no longer match the motif):"},
		SequenceRotateRight[DNA["ATGCAT","B"],2],
		DNA["ATATGC"]
	],
	Example[{Basic,"Rotation is on the basis of the number of Monomers rather then the number of characters in a string for LNAChimera:"},
		SequenceRotateRight["mAfC+CfAmG",2],
		"fAmGmAfC+C"
	],
	Example[{Options,ExplicitlyTyped,"Setting the ExplicitlyTyped option to true will return the sequence wrapped in its type:"},
		SequenceRotateRight["ACCA",ExplicitlyTyped->True],
		DNA["AACC"]
	],
	Example[{Options,Polymer,"The Polymer option can be set so as to spesifiy what polymer you're working with in an implicily typed sequence:"},
		SequenceRotateRight["ACCA",Polymer->RNA,ExplicitlyTyped->True],
		RNA["AACC"]
	],
	Example[{Issues,"Rotating a sequence will remove its motif name:"},
		SequenceRotateRight[DNA["ATGCA","B"],2],
		DNA["CAATG"]
	],
	Example[{Issues,"Unless you rotate it around back to where you started, returning the same sequence:"},
		SequenceRotateRight[DNA["ATGCA","B"],5],
		DNA["ATGCA","B"]
	],
	Example[{Attributes,"Listable","The function is listable by n:"},
		SequenceRotateRight["ATGCA",Range[3]],
		{"AATGC","CAATG","GCAAT"}
	],
	Example[{Attributes,"Listable","The function is also listable by sequence:"},
		SequenceRotateRight[{"ATGCA","TGCAG","AGCA"},3],
		{"GCAAT","CAGTG","GCAA"}
	],
	Test["Symbolic input remains unevaluated:",
		SequenceRotateRight[Fish],
		_SequenceRotateRight
	]
}];


(* ::Subsubsection:: *)
(*SequenceRotateLeft*)


DefineTests[SequenceRotateLeft,{
	Example[{Basic,"Rotating to the right will move the last monomer in the sequence to the front of the sequence:"},
		SequenceRotateLeft["ATGGC"],
		"TGGCA"
	],
	Example[{Basic,"Rotating to the right by 2 will move the last two bases to the front of the sequence:"},
		SequenceRotateLeft["ATGGC",2],
		"GGCAT"
	],
	Example[{Basic,"Rotation is on the basis of the number of Monomers rather then the number of characters in a string:"},
		SequenceRotateLeft["LysHisArgGlnThr",2],
		"ArgGlnThrLysHis"
	],
	Example[{Additional,"Rotataion works with degenerate sequences as well:"},
		SequenceRotateLeft[DNA[5],2],
		DNA["NNNNN"]
	],
	Example[{Additional,"Rotating a sequence with a motif label will remove the label (since is sequence will no longer match the motif):"},
		SequenceRotateLeft[DNA["ATGCAT","B"],2],
		DNA["GCATAT"]
	],
	Example[{Basic,"Rotation is on the basis of the number of Monomers rather then the number of characters in a string:"},
		SequenceRotateLeft["+AmCfCmA",2],
		"fCmA+AmC"
	],
	Example[{Options,ExplicitlyTyped,"Setting the ExplicitlyTyped option to true will return the sequence wrapped in its type:"},
		SequenceRotateLeft["ACCA",ExplicitlyTyped->True],
		DNA["CCAA"]
	],
	Example[{Options,Polymer,"The Polymer option can be set so as to spesifiy what polymer you're working with in an implicily typed sequence:"},
		SequenceRotateLeft["ACCA",Polymer->RNA,ExplicitlyTyped->True],
		RNA["CCAA"]
	],
	Example[{Issues,"Rotating a sequence will remove its motif name:"},
		SequenceRotateLeft[DNA["ATGCA","B"],2],
		DNA["GCAAT"]
	],
	Example[{Issues,"Unless you rotate it around back to where you started, returning the same sequence:"},
		SequenceRotateLeft[DNA["ATGCA","B"],5],
		DNA["ATGCA","B"]
	],
	Example[{Attributes,"Listable","The function is listable by n:"},
		SequenceRotateLeft["ATGCA",Range[3]],
		{"TGCAA","GCAAT","CAATG"}
	],
	Example[{Attributes,"Listable","The function is also listable by sequence:"},
		SequenceRotateLeft[{"ATGCA","TGCAG","AGCA"},3],
		{"CAATG","AGTGC","AAGC"}
	],
	Test["Symbolic input remains unevaluated:",
		SequenceRotateLeft[Fish],
		_SequenceRotateLeft
	]
}];



(* ::Subsubsection:: *)
(*Truncate*)


DefineTests[Truncate,{
	Example[{Basic,"The function returns the input sequence with a list of synthetic truncations:"},
		Truncate[DNA["ATGCAG"],2],
		{Strand[DNA["ATGCAG"]],Strand[Modification["Acetylated"],DNA["TGCAG"]],Strand[Modification["Acetylated"],DNA["GCAG"]]}
	],
	Example[{Basic,"It works on strands in addition to sequences:"},
		Truncate[Strand[DNA["ATGCAG"],Modification["Dabcyl"]],2],
		{Strand[DNA["ATGCAG"],Modification["Dabcyl"]],Strand[Modification["Acetylated"],DNA["TGCAG"],Modification["Dabcyl"]],Strand[Modification["Acetylated"],DNA["GCAG"],Modification["Dabcyl"]]}
	],
	Example[{Basic,"And on peptides as well:"},
		Truncate[Peptide["LysHisArgArg"],2],
		{Strand[Peptide["LysHisArgArg"]],Strand[Modification["Acetylated"],Peptide["HisArgArg"]],Strand[Modification["Acetylated"],Peptide["ArgArg"]]}
	],
	Example[{Options,Polymer,"The polymer option can be used to specify the polymer type of ambigious sequences:"},
		Truncate["AGCAG",2,Polymer->RNA],
		{Strand[RNA["AGCAG"]],Strand[Modification["Acetylated"],RNA["GCAG"]],Strand[Modification["Acetylated"],RNA["CAG"]]}
	],
	Example[{Options,Cap,"An alternative capping monomer to Acetylation can be provided:"},
		Truncate["ATGATA",1,Cap->RNA["U"]],
		{Strand[DNA["ATGATA"]],Strand[RNA["U"],DNA["TGATA"]]}
	],
	Example[{Attributes,Listable,"The function is listable by sequences or strands:"},
		Truncate[{"GCAGA","ATGATA","CCACATG"},1],
		{{Strand[DNA["GCAGA"]],Strand[Modification["Acetylated"],DNA["CAGA"]]},{Strand[DNA["ATGATA"]],Strand[Modification["Acetylated"],DNA["TGATA"]]},{Strand[DNA["CCACATG"]],Strand[Modification["Acetylated"],DNA["CACATG"]]}}
	],
	Example[{Attributes,Listable,"Its also listable by truncation number:"},
		Truncate[DNA["ATGCAG"],{1,2,3}],
		{{Strand[DNA["ATGCAG"]],Strand[Modification["Acetylated"],DNA["TGCAG"]]},{Strand[DNA["ATGCAG"]],Strand[Modification["Acetylated"],DNA["TGCAG"]],Strand[Modification["Acetylated"],DNA["GCAG"]]},{Strand[DNA["ATGCAG"]],Strand[Modification["Acetylated"],DNA["TGCAG"]],Strand[Modification["Acetylated"],DNA["GCAG"]],Strand[Modification["Acetylated"],DNA["CAG"]]}}
	],
	Example[{Messages,"TooShort","The TooShort error is thrown when truncations beyond the length of the input sequence:"},
		Truncate[DNA["ATGC"],5],
		_,
		Messages:>{Truncate::TooShort}
	]
}];


(* ::Subsection:: *)
(*P's & Q's*)


(* ::Subsubsection:: *)
(*ValidStrandQ*)


DefineTests[ValidStrandQ,{

	Example[{Basic,"The function tests to see if a Strand is composed of valid sequences:"},
		ValidStrandQ[Strand[Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]]],
		True
	],
	Example[{Basic,"But if any sequences are invalid, StrandQ will return false:"},
		ValidStrandQ[Strand[DNA["ATGCAT"],DNA["LysArgHis"]]],
		False
	],


	Example[{Additional,"Works with degeneracy:"},
		ValidStrandQ[Strand[DNA[12,"Q"]]],
		True
	],


	Example[{Options,Polymer,"The polymer option can be used to specify which polymer type the sequences can belong to:"},
		ValidStrandQ[Strand[RNA["AUCG"],RNA["AUCG"]],Polymer->RNA],
		True
	],
	Example[{Options,Polymer,"If any of the sequences in the Strand don't match the allowed polymer types, it will return false:"},
		ValidStrandQ[Strand[RNA["AUCG"],DNA["ATCG"]],Polymer->RNA],
		False
	],

	Example[{Options,Exclude,"The Exclude option can be used to specify which polymer types are ignored in the polymer type check:"},
		ValidStrandQ[Strand[RNA["AUCG"],DNA["ATCG"]],Polymer->RNA,Exclude->DNA],
		True
	],
	Example[{Options,Exclude,"Multiple polymer types can be included in the exclusion:"},
		ValidStrandQ[Strand[RNA["AUCG"],DNA["ATCG"],Peptide["LysHis"]],Polymer->RNA,Exclude->{DNA,Peptide}],
		True
	],
	Example[{Options,Exclude,"Will exclude modifications by default:"},
		ValidStrandQ[Strand[Modification["Fluorescein","F"],DNA["ATGTAGATA","A"]],Polymer->DNA],
		True
	],

	Example[{Options,CheckMotifs,"If the CheckMotifs option is active, StrandQ will check to see that the sequences specified by matching motifs appropriately match:"},
		ValidStrandQ[Strand[DNA["ATGTAGA","A"],DNA["ATGTAGA","A"],DNA["TCTACAT","A'"]],CheckMotifs->True],
		True
	],
	Example[{Options,CheckMotifs,"If any sequences do not match, but should according to the motif, StrandQ returns False:"},
		ValidStrandQ[Strand[DNA["ATGTAGA","A"],DNA["GGGGG","A"],DNA["TCTACAT","A'"]],CheckMotifs->True],
		False
	],

	Example[{Options,Degeneracy,"The Degeneracy option will allow for degenerate Monomers within the motifs:"},
		ValidStrandQ[Strand[DNA["ATNNTC","A"]],Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"If Degeneracy is set to False, degeneracy is not permitted in the sequences:"},
		ValidStrandQ[Strand[DNA["ATNNTC","A"]],Degeneracy->False],
		False
	],


	Example[{Attributes,Listable,"The function is listable:"},
		ValidStrandQ[{Strand[RNA["AUCG"],RNA["AUCG"]],Strand[DNA["ATCG"],DNA["ATCG"]],Strand[DNA["ATGCAT"],DNA["LysArgHis"]]}],
		{True,True,False}
	],


	Example[{Issues,"Non-Pairing polymers (such as peptides), are considered to be their own reverse complement:"},
		SameSequenceQ[Peptide["LysHisArg","B"],Peptide["LysHisArg","B'"]],
		True
	],


	Test["Function returns false for nonsense input:",
		ValidStrandQ["Fish"],
		False
	],
	Test["CheckMotifs is OK with non canonical polymers:",
		ValidStrandQ[Strand[Peptide["LysHisArg","A"],Peptide["LysHisArg","A"]],CheckMotifs->True],
		True
	]
}];


(* ::Subsection:: *)
(*Strand Manipulation*)


(* ::Subsubsection:: *)
(*StrandQ*)


DefineTests[StrandQ,{
	Example[{Basic,"The function tests to see if a Strand is composed of valid sequences:"},
		StrandQ[Strand[Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]]],
		True
	],
	Example[{Basic,"But if any sequences are invalid, StrandQ will return false:"},
		StrandQ[Strand[DNA["ATGCAT"],DNA["LysArgHis"]]],
		False
	],
	Example[{Additional,"Works with degeneracy:"},
		StrandQ[Strand[DNA[12,"Q"]]],
		True
	],
	Example[{Options,Polymer,"The polymer option can be used to specify which polymer type the sequences can belong to:"},
		StrandQ[Strand[RNA["AUCG"],RNA["AUCG"]],Polymer->RNA],
		True
	],
	Example[{Options,Polymer,"If any of the sequences in the Strand don't match the allowed polymer types, it will return false:"},
		StrandQ[Strand[RNA["AUCG"],DNA["ATCG"]],Polymer->RNA],
		False
	],
	Example[{Options,Exclude,"The Exclude option can be used to specify which polymer types are ignored in the polymer type check:"},
		StrandQ[Strand[RNA["AUCG"],DNA["ATCG"]],Polymer->RNA,Exclude->DNA],
		True
	],
	Example[{Options,Exclude,"Multiple polymer types can be included in the exclusion:"},
		StrandQ[Strand[RNA["AUCG"],DNA["ATCG"],Peptide["LysHis"]],Polymer->RNA,Exclude->{DNA,Peptide}],
		True
	],
	Example[{Options,Exclude,"Will exclude modifications by default:"},
		StrandQ[Strand[Modification["Fluorescein","F"],DNA["ATGTAGATA","A"]],Polymer->DNA],
		True
	],
	Example[{Options,CheckMotifs,"If the CheckMotifs option is active, StrandQ will check to see that the sequences specified by matching motifs appropriately match:"},
		StrandQ[Strand[DNA["ATGTAGA","A"],DNA["ATGTAGA","A"],DNA["TCTACAT","A'"]],CheckMotifs->True],
		True
	],
	Example[{Options,CheckMotifs,"If any sequences do not match, but should according to the motif, StrandQ returns False:"},
		StrandQ[Strand[DNA["ATGTAGA","A"],DNA["GGGGG","A"],DNA["TCTACAT","A'"]],CheckMotifs->True],
		False
	],
	Example[{Options,Degeneracy,"The Degeneracy option will allow for degenerate Monomers within the motifs:"},
		StrandQ[Strand[DNA["ATNNTC","A"]],Degeneracy->True],
		True
	],
	Example[{Options,Degeneracy,"If Degeneracy is set to False, degeneracy is not permitted in the sequences:"},
		StrandQ[Strand[DNA["ATNNTC","A"]],Degeneracy->False],
		False
	],
	Example[{Options,CanonicalPairing,"If CanonicalPairing is set to False, canonical pairing is allowed in the sequences:"},
		StrandQ[Strand[RNA["AUGAUA","A"],DNA[20,"B"],DNA["TANNAT","A'"]], CheckMotifs->True, CanonicalPairing->True],
		True
	],
	Example[{Attributes,Listable,"The function is listable:"},
		StrandQ[{Strand[RNA["AUCG"],RNA["AUCG"]],Strand[DNA["ATCG"],DNA["ATCG"]],Strand[DNA["ATGCAT"],DNA["LysArgHis"]]}],
		{True,True,False}
	],
	Example[{Issues,"Non-Pairing polymers (such as peptides), are considered to be their own reverse complement:"},
		SameSequenceQ[Peptide["LysHisArg","B"],Peptide["LysHisArg","B'"]],
		True
	],
	Test["Function returns false for nonsense input:",
		StrandQ["Fish"],
		False
	],
	Test["CheckMotifs is OK with non canonical polymers:",
		StrandQ[Strand[Peptide["LysHisArg","A"],Peptide["LysHisArg","A"]],CheckMotifs->True],
		True
	]
}];


(* ::Subsubsection:: *)
(*StrandLength*)


DefineTests[StrandLength,
{
		Example[
			{Basic,"Counts total number of Monomers in a Strand:"},
			StrandLength[Strand[PNA["CCCGATTATGACTTTGCCT"]]],
			19
		],
		Example[
			{Basic,"Adds across motifs:"},
			StrandLength[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]]],
			26
		],
		Test[
			"Test 1:",
			StrandLength[Strand[Peptide["LysHisLysArg"]]],
			4
		],
		Test[
			"Test 2:",
			StrandLength["Cow"],
			_StrandLength
		],
		Example[
			{Basic,"Maps over lists:"},
			{StrandLength[Strand[PNA["CCCGATTATGACTTTGCCT"]]],StrandLength[Strand[Peptide["LysHisLysArg"]]]},
			{19,4}
		],
		Test[
			"Test 3:",
			StrandLength[Strand[DNA["ATCG","X"],Peptide["Lys","Y"],Modification["Tamra","Z"]]],
			6
		],
		Example[
			{Options,Total,"Return lengths of motifs within Strand:"},
			StrandLength[Strand[DNA["ATCG","X"],Peptide["Lys","Y"],Modification["Tamra","Z"]],Total->False],
			{4,1,1}
		],
		Test[
			"Test 4:",
			StrandLength[{Strand[DNA["ATCG","X"],Peptide["Lys","Y"]],Strand[RNA["AUUUU","Z"]]}],
			{5,5}
		],
		Example[
			{Options,Total,"Return lengths of motifs within each Strand:"},
			StrandLength[{Strand[DNA["ATCG","X"],Peptide["Lys","Y"]],Strand[RNA["AUUUU","Z"]]},Total->False],
			{{4,1},{5}}
		]
}];


(* ::Subsubsection:: *)
(*StrandTake*)


DefineTests[StrandTake,
{
		Example[
			{Basic,"Take first 20 Monomers in Strand:"},
			StrandTake[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT",""],Peptide["Lys",""]],20],
			Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTT"]]
		],
		Example[
			{Basic,"Take last 5 Monomers in Strand:"},
			StrandTake[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]],-5],
			Strand[PNA["GCCT"],Peptide["Lys"]]
		],
		Test[
			"Take first 3:",
			StrandTake[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]],3],
			Strand[DNA["GAT"]]
		],
		Example[
			{Messages, "invalidSpan", "Throw an error if asked for more Monomers than exist in the Strand:"},
			StrandTake[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]],75],
			$Failed,
			Messages:>Message[StrandTake::invalidSpan, "1", "75"]
		],
		Test[
			"Return $Failed and throw an error if input an invalid span:",
			StrandTake[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]],-75],
			$Failed,
			Messages:>Message[StrandTake::invalidSpan, "-48", "26"]
		],
		Test[
			"Take last 10:",
			StrandTake[Strand[Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"]],-10],
			Strand[PNA["GACTTTGCCT"]]
		],
		Example[
			{Basic,"Specify monomer span to take:"},
			StrandTake[Strand[DNA["ATCGATCG"],RNA["AUUU"],DNA["ATATA"]],2;;4],
			Strand[DNA["TCG"]]
		],
		Example[
			{Basic,"Speicfy monomer spand and motif index:"},
			StrandTake[Strand[DNA["ATCGATCG"],RNA["AUUU"],DNA["ATATA"]],{3,2;;4}],
			Strand[DNA["TAT"]]
		],
		Test[
			"Take first 2:",
			StrandTake[Strand[DNA["ATCGATCG","A"],DNA["ATGATACCCC","B"]],2],
			Strand[DNA["AT"]]
		]
}];


(* ::Subsubsection:: *)
(*StrandDrop*)


DefineTests[StrandDrop,
{
		Example[
			{Basic,"Drop first two Monomers from Strand:"},
			StrandDrop[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]],2],
			Strand[DNA["TAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]]
		],
		Example[
			{Basic,"Drop last two Monomers from Strand:"},
			StrandDrop[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]],-2],
			Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCC"]]
		],
		Test[
			"Drop first 10:",
			StrandDrop[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]],10],
			Strand[PNA["ATTATGACTTTGCCT"],Peptide["Lys"]]
		],
		Example[
			{Messages, "invalidSpan", "Throw an error if asked to drop more Monomers than exist in the Strand:"},
			StrandDrop[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]],50],
			$Failed,
			Messages:>Message[StrandDrop::invalidSpan, "1", "50"]
		],
		Test[
			"Return $Failed and throw an error if input an invalid span:",
			StrandDrop[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]],-50],
			$Failed,
			Messages:>Message[StrandDrop::invalidSpan, "-23", "26"]
		]
}];


(* ::Subsubsection:: *)
(*StrandFirst*)


DefineTests[StrandFirst,
{
		Example[
			{Basic,"Return Strand containing only first monomer:"},
			StrandFirst[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]]],
			Strand[DNA["G"]]
		],
		Example[
			{Basic,"Return Strand containing only first monomer:"},
			StrandFirst[Strand[Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]]],
			Strand[Modification["Acetylated"]]
		],
		Example[
			{Basic,"Return Strand containing only first monomer:"},
			StrandFirst[Strand[DNA["ATCGATCG","A"],DNA["ATGATACCCC","B"]]],
			Strand[DNA["A"]]
		]
}];


(* ::Subsubsection:: *)
(*StrandLast*)


DefineTests[StrandLast,
{
		Example[
			{Basic,"Return Strand containing only last monomer:"},
			StrandLast[Strand[Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]]],
			Strand[Peptide["Lys"]]
		],
		Example[
			{Basic,"Return Strand containing only last monomer:"},
			StrandLast[Strand[Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"]]],
			Strand[PNA["T"]]
		],
		Example[
			{Basic,"Return Strand containing only first monomer:"},
			StrandLast[Strand[DNA["ATCGATCG","A"],DNA["ATGATACCCC","B"]]],
			Strand[DNA["C"]]
		]
}];


(* ::Subsubsection:: *)
(*StrandRest*)


DefineTests[StrandRest,
{
		Example[
			{Basic,"Drop first monomer from Strand:"},
			StrandRest[Strand[Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"]]],
			Strand[PNA["CCCGATTATGACTTTGCCT"]]
		],
		Example[
			{Basic,"Drop first monomer from Strand:"},
			StrandRest[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["LysHis"]]],
			Strand[DNA["ATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["LysHis"]]
		],
		Example[
			{Basic,"Return Strand containing only first monomer:"},
			StrandRest[Strand[DNA["ATCGATCG","A"],DNA["ATGATACCCC","B"]]],
			Strand[DNA["TCGATCG"], DNA["ATGATACCCC", "B"]]
		]
}];


(* ::Subsubsection:: *)
(*StrandMost*)


DefineTests[StrandMost,
{
		Example[
			{Basic,"Drop last monomer from Strand:"},
			StrandMost[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["LysHis"]]],
			Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]]
		],
		Example[
			{Basic,"Drop last monomer from Strand:"},
			StrandMost[Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"],Peptide["Lys"]]],
			Strand[DNA["GATAG"],Modification["Acetylated"],PNA["CCCGATTATGACTTTGCCT"]]
		],
		Example[
			{Basic,"Return Strand containing only first monomer:"},
			StrandMost[Strand[DNA["ATCGATCG","A"],DNA["ATGATACCCC","B"]]],
			Strand[DNA["ATCGATCG", "A"], DNA["ATGATACCC"]]
		]
}];


(* ::Subsubsection:: *)
(*DefineMotifs*)


DefineTests[DefineMotifs,{
	Example[{Basic,"Replace sequence-less motifs with sequences:"},
		DefineMotifs[Strand[DNA[20,"X"],DNA[20,"Z"]],{"X"->"ATCGATCG","Z"->"GGCCTTAA"}],
		Strand[DNA["ATCGATCG","X"],DNA["GGCCTTAA","Z"]]
	],
	Example[{Basic,"Revcomps given sequences when necessary:"},
		DefineMotifs[Strand[DNA[20,"X"],DNA[20,"X'"]],{"X"->"ATCGATCG"}],
		Strand[DNA["ATCGATCG","X"],DNA["CGATCGAT","Xp"]]
	],
	Example[{Messages,"MissingMotifs","Gives warning and substitutes in 'N' for motifs not specified:"},
		DefineMotifs[Strand[DNA[20,"X"],DNA[20,"Y"],DNA[20,"X'"]],{"X"->"ATCGATCG","Z"->"GGGGGGGGGG"}],
		Strand[DNA["ATCGATCG","X"],DNA["NNNNNNNNNNNNNNNNNNNN","Y"],DNA["CGATCGAT","Xp"]],
		Messages:>{DefineMotifs::MissingMotifs}
	],
	Test["Missing motifs:",
		DefineMotifs[Structure[{Strand[DNA[20,"X"],DNA[20,"Y"],DNA[20,"X'"]],Strand[DNA[20,"A"],DNA[20,"Z"]]},{}],{"X"->"ATCGATCG","Z"->"GGGGGGGGGG"}],
		Structure[{Strand[DNA["ATCGATCG","X"],DNA["NNNNNNNNNNNNNNNNNNNN","Y"],DNA["CGATCGAT","Xp"]],Strand[DNA["NNNNNNNNNNNNNNNNNNNN","A"],DNA["GGGGGGGGGG","Z"]]},{}],
		Messages:>{DefineMotifs::MissingMotifs,DefineMotifs::MissingMotifs}
	],
	Example[{Messages,"NonPairingMotifs","Gives warning if structure contains invalid bonds after substituting in motif sequences:"},
		DefineMotifs[	Structure[{Strand[DNA[5, "A"]],	Strand[DNA["CC", "A'"]]}, {Bond[{1, 1}, {2, 1}]}], {"A" ->	"TTTTT"}],
		Structure[{Strand[DNA["TTTTT", "A"]], Strand[DNA["CC", "A'"]]}, {Bond[{1, 1}, {2, 1}]}],
		Messages:>{DefineMotifs::NonPairingMotifs}
	]
}];


(* ::Subsubsection:: *)
(*StrandJoin*)


DefineTests[StrandJoin,
{
		Example[
			{Basic,"Join two strands:"},
			StrandJoin[Strand[DNA[3]],Strand[DNA[4]]],
			Strand[DNA[3],DNA[4]]
		],
		Example[
			{Basic,"Join many strands of different types:"},
			StrandJoin[Strand[DNA["ATCGATCG","Name"],DNA[3],RNA["AUUUU"]],Strand[DNA[3],RNA["AUUUU"],Peptide["LysHis"],Modification[1]],Strand[Modification[1]]],
			Strand[DNA["ATCGATCG","Name"],DNA[3],RNA["AUUUU"],DNA[3],RNA["AUUUU"],Peptide["LysHis"],Modification[1],Modification[1]]
		],
		Example[
			{Basic,"Return Strand containing only first monomer:"},
			StrandJoin[Strand[DNA["ATCGATCG","A"],DNA["ATGATACCCC","B"]], Strand[DNA["ATCGATCG","C"],DNA["ATGATACCCC","D"]]],
			Strand[DNA["ATCGATCG", "A"], DNA["ATGATACCCC", "B"], DNA["ATCGATCG", "C"], DNA["ATGATACCCC", "D"]]
		]
}];


(* ::Subsubsection::Closed:: *)
(*strandNames*)


DefineTests[strandNames,
{
		Example[
			{Basic,"Pull names from strands:"},
			strandNames[Strand[DNA["ATCG","Brad"],DNA[3],RNA[5,"cow"],PNA["ATCG"]]],
			{"Brad","","cow",""}
		],
		Example[
			{Basic,"Given list of strands:"},
			strandNames[{Strand[DNA[3,"hi"],DNA[4]],Strand[DNA[5],RNA["AUUU","moo"]]}],
			{{"hi",""},{"","moo"}}
		]
}];


(* ::Subsubsection:: *)
(*StrandFlatten*)


DefineTests[StrandFlatten,{
	Example[{Basic,"Joins consecutive stretches of like polymer types:"},
		StrandFlatten[Strand[DNA["ATGAT","Fish"],DNA["GCACAG"]]],
		Strand[DNA["ATGATGCACAG"]]
	],
	Example[{Basic, "Includes modifications in the output Strand:"},
		StrandFlatten[Strand[Modification["Dabcyl"],DNA["ATGCAGA","A"],DNA["GGCAGA","B"],Modification["Fluorescein"]]],
		Strand[Modification["Dabcyl"],DNA["ATGCAGAGGCAGA"],Modification["Fluorescein"]]
	],
	Example[{Basic, "Does not join separated stretches of a polymer type:"},
		StrandFlatten[Strand[DNA[5],RNA[5],DNA[5],DNA[5],DNA[5]]],
		Strand[DNA["NNNNN"],RNA["NNNNN"],DNA["NNNNNNNNNNNNNNN"]]
	],
	Example[{Additional,"Works with wildcard sequences:"},
		StrandFlatten[Strand[DNA["ATGATA"],DNA[5]]],
		Strand[DNA["ATGATANNNNN"]]
	],
	Test["Does not evaluate on strings:",
		StrandFlatten["ATGATATA"],
		_StrandFlatten
	],
	Test["Does not evaluate on sequences:",
		StrandFlatten[DNA["ATGATA"]],
		_StrandFlatten
	]
}];


(* ::Subsection:: *)
(*Strand*)


(* ::Subsubsection::Closed:: *)
(*Strand*)


DefineTests[Strand,{
	Example[{Basic,"A strand with one DNA motif:"},
		Strand[DNA["ATCG"]],
		StrandP
	],
	Example[{Basic,"Given an untyped sequence, it gets typed:"},
		Strand["ATCG"],
		Strand[DNA["ATCG"]]
	],
	Example[{Basic,"A strand with multiple motifs and labels:"},
		Strand[DNA["ATCG","X"],RNA["AUUU","Y"],Modification["Fluorescein"]],
		StrandP
	],
	Example[{Basic,"A strand with mixed sequences and lengths:"},
		Strand[DNA[6],DNA["ATCGATCG"],RNA[4]],
		StrandP
	],
	Example[{Basic,"Given a mixture of typed and untyped sequences:"},
		Strand["ATCG",RNA["UU","Name"],"UAA",Modification["Dabcyl"]],
		Strand[DNA["ATCG"], RNA["UU", "Name"], RNA["UAA"], Modification["Dabcyl"]]
	],

	Example[{Additional,"Properties","See the list of properties that can be dereferenced from a strand:"},
		Keys[Strand["ATCG",RNA["UU","Name"],"UAA",Modification["Dabcyl"]]],
		{_Symbol..}
	],
	Example[{Additional,"Properties","Extract the list of sequences:"},
		Strand["ATCG",RNA["UU","Name"],"UAA",Modification["Dabcyl"]][Sequences],
		{"ATCG", "UU", "UAA", "Dabcyl"}
	],
	Example[{Additional,"Properties","Extract the list of polymers:"},
		Strand["ATCG",RNA["UU","Name"],"UAA",Modification["Dabcyl"]][Polymers],
		{DNA, RNA, RNA, Modification}
	],
	Example[{Additional,"Properties","Extract the list of motifs:"},
		Strand["ATCG",RNA["UU","Name"],"UAA",Modification["Dabcyl"]][Motifs],
		{DNA["ATCG"], RNA["UU", "Name"], RNA["UAA"], Modification["Dabcyl"]}
	],
	Example[{Additional,"Properties","Extract the list of names:"},
		Strand["ATCG",RNA["UU","Name"],"UAA",Modification["Dabcyl"]][Names],
		{"", "Name", "", ""}
	],
	Example[{Additional,"Properties","Extract the list of sequences and polymers:"},
		Strand["ATCG",RNA["UU","Name"],"UAA",Modification["Dabcyl"]][{Sequences,Polymers}],
		{{"ATCG","UU","UAA","Dabcyl"},{DNA,RNA,RNA,Modification}}
	],
	Example[{Additional,"Properties","Extract the sequences from a list of strands:"},
		{Strand["ATCG",RNA["UU","Name"],"UAA",Modification["Dabcyl"]],Strand[DNA["ATCG","X"],RNA["AUUU","Y"],Modification["Fluorescein"]]}[Sequences],
		{{"ATCG","UU","UAA","Dabcyl"},{"ATCG","AUUU","Fluorescein"}}
	],
	Example[{Additional,"MotifForm representation of a strand:"},
		MotifForm[Strand[DNA["ATCG","X"],RNA["AUUU","Y"],Modification["Fluorescein"]]],
		_Interpretation
	],

	Example[{Additional,"Motifs can be optionally labeled:"},
		Strand[DNA[6,"Start"],DNA["ATCGATCG","Middle"],RNA[4,"End"]],
		StrandP
	]

}];


(* ::Subsection:: *)
(*Strand*)


(* ::Subsubsection::Closed:: *)
(*ParseStrand*)


DefineTests[ParseStrand,{

	Example[{Basic,"Parse a strand into its motif name, rec comp, sequence, and polymers:"},
		ParseStrand[Strand[DNA["ATCG","A"]]],
		{{"A",False,"ATCG",DNA}}
	],
	Example[{Basic,"Parse a mixed polymer strand:"},
		ParseStrand[Strand[RNA["AUUUG","B"],DNA["ATCG","A"]]],
		{{"B",False,"AUUUG",RNA},{"A",False,"ATCG",DNA}}
	],
	Example[{Basic,"Parse a strand containing a revcomp motif:"},
		ParseStrand[Strand[DNA["ATCG","A'"]]],
		{{"A",True,"ATCG",DNA}}
	],
	Example[{Basic,"Parse a strand containing degenerate motif:"},
		ParseStrand[{Strand[DNA["ATCG","A"]],Strand[RNA[25,"B"],DNA["ATCG","A"]]}],
		{{{"A",False,"ATCG",DNA}},{{"B",False,25,RNA},{"A",False,"ATCG",DNA}}}
	]
}];



(* ::Subsubsection::Closed:: *)
(*unparseStrand*)


DefineTests[unparseStrand,{
	Test[unparseStrand[{{"X",False,"ATCG",DNA},{"Y",False,"AUUUU",RNA}}],
		Strand[DNA["ATCG","X"],RNA["AUUUU","Y"]]],
	Test[unparseStrand[{{{"A",False,"ATCG",DNA}},{{"B",False,"AUUUG",RNA},{"A",False,"ATCG",DNA}}}],
		{Strand[DNA["ATCG","A"]],Strand[RNA["AUUUG","B"],DNA["ATCG","A"]]}]
}];


(* ::Subsection:: *)
(*Motif*)


(* ::Subsubsection::Closed:: *)
(*motifPositionToStrandPosition*)


DefineTests[motifPositionToStrandPosition,{
	Test[motifPositionToStrandPosition[Strand[DNA["ATCG","X"],DNA["XYZ","Y"],DNA["ABCDEFG","Z"]],1,2;;4],2;;4],
	Test[motifPositionToStrandPosition[Strand[DNA["ATCG","X"],DNA["XYZ","Y"],DNA["ABCDEFG","Z"]],2,2;;4],6;;8],
	Test[motifPositionToStrandPosition[Strand[DNA["ATCG","X"],DNA["XYZ","Y"],DNA["ABCDEFG","Z"]],3,2;;4],9;;11]
}];
