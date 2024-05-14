(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validObjectSoftwareDocumentationBundleQTests*)


validObjectSoftwareDocumentationBundleQTests[packet:PacketP[Object[Software,DocumentationBundle]]]:= {
	(* General fields filled in *)
	NotNullFieldTest[packet, {Commit, DateCreated, DateDocumentationCreated, IndexBundle, StorageBucketName, SymbolDocumentationPath, TutorialsPath, GuidesPath }]
};

(* ::Subsection::Closed:: *)
(*validObjectSoftwareDatabaseRefreshQTests*)

validObjectSoftwareDatabaseRefreshQTests[packet:PacketP[Object[Software,DatabaseRefresh]]]:= {
	(* General fields filled in *)
	NotNullFieldTest[packet, {Name, Status }]
};

(* ::Subsection::Closed:: *)
(*validObjectSoftwareQTests*)

validObjectSoftwareQTests[packet:PacketP[Object[Software,DatabaseRefresh]]]:= {
};

(* ::Subsection::Closed:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Software,DatabaseRefresh],validObjectSoftwareDatabaseRefreshQTests];
registerValidQTestFunction[Object[Software],validObjectSoftwareQTests];