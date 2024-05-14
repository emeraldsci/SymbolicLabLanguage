(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validModelProtocolQTests*)


validModelProtocolQTests[packet:ObjectP[Model[Protocol]]]:={
	NotNullFieldTest[packet,{
		Authors
	}]
};

registerValidQTestFunction[Model[Protocol],validModelProtocolQTests];