

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section::Closed:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validCatalogQTests*)


validCatalogQTests[packet:PacketP[Object[Catalog]]] := {
	NotNullFieldTest[packet, {Folder,Contents}],

	Test["If Sites field is populated, it is the same length as Contents:",
		Or[
			MatchQ[Lookup[packet,Sites],Null|{}|{Null}],
			Length[Lookup[packet,Sites]]==Length[Lookup[packet,Contents]]
		],
		True
	]
};

(* ::Subsection::Closed:: *)
(* Test Registration *)

registerValidQTestFunction[Object[Catalog],validCatalogQTests];