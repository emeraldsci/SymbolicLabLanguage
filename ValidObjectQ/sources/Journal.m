(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validJournalQTests*)


validJournalQTests[packet:PacketP[Object[Journal]]]:={
	NotNullFieldTest[packet, {
		Name
	}],
	
	Test["The contents of the Name field is a member of the Synonyms field:",
		Module[{synonyms,name},
			{synonyms,name}= Lookup[packet,{Synonyms,Name}];
			MemberQ[synonyms,name]			
		],
		True
	]
};


(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Journal],validJournalQTests];
