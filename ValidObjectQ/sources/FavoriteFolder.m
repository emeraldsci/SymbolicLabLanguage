(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(*validFavoriteQTests*)
validFavoriteQTests[packet:PacketP[Object[Favorite]]]:={};
(* ::Subsection::Closed:: *)

(* ::Subsection:: *)
(*validFavoriteFolderQTests*)

validFavoriteFolderQTests[packet:PacketP[Object[Favorite, Folder]]]:= {
  NotNullFieldTest[packet, {
    DisplayName
  }]

};

(* ::Subsection::Closed:: *)
(* Test Registration *)
registerValidQTestFunction[Object[Favorite],validFavoriteQTests];
registerValidQTestFunction[Object[Favorite, Folder],validFavoriteFolderQTests];
