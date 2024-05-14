(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*NativeTypes*)

(* Write the type definitions to the supplied location during distro building so that they can be used to speedier loading *)
If[
  MatchQ[ECL`$ECLApplication, ECL`DistroBuilder],
  Export[
    FileNameJoin[{ECL`$EmeraldPath, "ConstellationViewers", "resources", "typeDefinitions.json"}],
    ExportAssociationToJSON[<|"Types" -> ECL`GoLink`ParseSLLTypeDefinitions["memoization"]|>], "Text"]
];
