(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validPackageQTests*)


validPackageQTests[packet:PacketP[Object[Package]]]:={

	(* --------- Shared field shaping --------- *)
	NotNullFieldTest[packet,{Status, Site, Size}],
	
	Test["If the Status of the package is Receiving, DateReceived must be Null:",
			Lookup[packet,{Status,DateReceived}],
			{Receiving,Null}|{Except[Receiving],_}
		]
};


(* ::Subsection:: *)
(*Test Registration *)


registerValidQTestFunction[Object[Package],validPackageQTests];
