(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validRepairQTests*)


validRepairQTests[packet : ObjectP[Object[Repair]]] := {
	NotNullFieldTest[packet, {
		Headline,
		Description,
		Instrument,
		Status,
		StatusLog,
		Vendor,
		Author
	}]
};



(* ::Subsection::Closed:: *)
(* Test Registration *)

registerValidQTestFunction[Object[Repair], validRepairQTests];
