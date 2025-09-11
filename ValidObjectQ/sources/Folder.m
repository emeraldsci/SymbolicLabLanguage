

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section::Closed:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validFolderQTests*)


validCatalogQTests[packet:PacketP[Object[Folder]]] := {
	NotNullFieldTest[packet, {Label}],

	Test["Must not contain a cycle in the Contents field:",
		(* don't have a great way of determining this; the best way I have so far is just Download like 5 levels deep and if we don't have a repeat there, just assume we don't have it at all *)
		Module[{contents1, contents2, contents3, contents4, contents5},
			{
				contents1,
				contents2,
				contents3,
				contents4,
				contents5
			} = Quiet[Download[
				Lookup[packet, Object],
				{
					Contents[Object],
					Contents[Contents][Object],
					Contents[Contents][Contents][Object],
					Contents[Contents][Contents][Contents][Object],
					Contents[Contents][Contents][Contents][Contents][Object],
				}
			]];

			Not[MemberQ[Flatten[{contents1, contents2, contents3, contents4, contents5}], Lookup[packet, Object]]]
		],
		True
	]
};

(* ::Subsection::Closed:: *)
(* Test Registration *)

registerValidQTestFunction[Object[Folder],validFolderQTests];