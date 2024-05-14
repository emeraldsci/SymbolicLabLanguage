(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validBillQTests*)

validBillQTests[packet:PacketP[Object[Bill]]]:={

	NotNullFieldTest[packet,
		{
			PricingScheme,
			Organization,
			DateStarted
		}
	],

	FieldComparisonTest[packet, {DateStarted, DateCompleted}, Less]
};

(* ::Subsection::Closed:: *)
(* Test Registration *)

registerValidQTestFunction[Object[Bill], validBillQTests];