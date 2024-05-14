

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section::Closed:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validCompanyQTests*)


validCompanyQTests[packet:PacketP[Object[Company]]] := {
	NotNullFieldTest[packet, Name],
	AnyInformedTest[packet, {Phone, Website,OutOfBusiness}]
};


(* ::Subsection::Closed:: *)
(*validCompanySupplierQTests*)


validCompanySupplierQTests[packet:PacketP[Object[Company,Supplier]]]:={};


(* ::Subsection::Closed:: *)
(*validCompanyShipperQTests*)


validCompanyShipperQTests[packet:PacketP[Object[Company,Shipper]]]:={
	RequiredTogetherTest[packet,{APIEndpoints,ShippingSpeedCodes}],
	
	(* Make sure each API / Test combination appears only once *)
	Test[
		"Each API / Test combination appears only once:",
		DuplicateFreeQ[Lookup[
			Lookup[packet, APIEndpoints], 
			{API, Test}
		]],
		True
	]
};

(* ::Subsection::Closed:: *)
(*validCompanyServiceQTests*)


validCompanyServiceQTests[packet:PacketP[Object[Company,Service]]]:={};

(* ::Subsection::Closed:: *)
(* Test Registration *)

registerValidQTestFunction[Object[Company],validCompanyQTests];
registerValidQTestFunction[Object[Company, Shipper],validCompanyShipperQTests];
registerValidQTestFunction[Object[Company, Supplier],validCompanySupplierQTests];
registerValidQTestFunction[Object[Company, Service],validCompanyServiceQTests];
