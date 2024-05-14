(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validNotebookQTests*)

validNotebookQTests[packet:ObjectP[Object[LaboratoryNotebook]]]:={
	NotNullFieldTest[packet, {
		Name,
		Public,
		Financers
	}],

	Test["There must always be a notebook administrator:",
		Length@Lookup[packet, Administrators],
		GreaterP[0]
	],

	Test["Administrators should all be viewers or editors:",
		Module[{cache, admins, editors, viewers},
			cache = Download[packet, { Administrators[Object], Editors[Members][Object], Viewers[Members][Object] }];
			admins = cache[[1]];
			editors = Flatten@cache[[2]];
			viewers = Flatten@cache[[3]];

			AllTrue[admins, ( MemberQ[editors, #] || MemberQ[viewers, #] ) &]
		],
		True
	]
};

(* ::Subsection::Closed:: *)
(* Test Registration *)
registerValidQTestFunction[Object[LaboratoryNotebook],validNotebookQTests];
