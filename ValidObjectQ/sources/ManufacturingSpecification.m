(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validManufacturingSpecificationQTests*)


validManufacturingSpecificationQTests[packet:PacketP[Object[ManufacturingSpecification]]] :={

	(* Authors and Company must be informed *)
	NotNullFieldTest[packet,{Authors,Company}],

	(* If Products is informed, every member of it must share the same product type *)
	Test["Products must have entries sharing the same Object[Product] SubType:",
		Module[
			{allProductTypes,uniqueProductTyeps,numberOfUniqueProductTypes,validProductTypeNumberQ},
			allProductTypes=Map[#[Type]&,packet[Products]];
			uniqueProductTyeps=DeleteDuplicates[allProductTypes];
			numberOfUniqueProductTypes=Length[uniqueProductTyeps];
			validProductTypeNumberQ=TrueQ[numberOfUniqueProductTypes<=1]
		],
		True
	],

	(* If Products in informed, every member of it must be from the Company field *)
	Test["Products must be from the Company:",
		Module[
			{allProductSuppliers,validAllProductSupplierQ,validProductSupplierQ},
			allProductSuppliers=Map[#[SupplierName]&,packet[Products]];
			validAllProductSupplierQ=Map[MatchQ[#,packet[Company][Name]]&,allProductSuppliers];
			validProductSupplierQ=And@@validAllProductSupplierQ
		],
		True
	]

};


(* ::Subsection:: *)
(*validManufacturingSpecificationCapillaryELISACartridgeQTests*)


validManufacturingSpecificationCapillaryELISACartridgeQTests[packet:PacketP[Object[ManufacturingSpecification,CapillaryELISACartridge]]] :={

  (* Shared field that cannot be Null *)
  NotNullFieldTest[packet,{Name,SpecificationSheet,ProductWebsite}],

  (* Unique fields that cannot be Null *)
  NotNullFieldTest[packet,{AnalyteName,AnalyteMolecule,CartridgeType,EstimatedLeadTime,MinOrderQuantity,Species,RecommendedMinDilutionFactor,RecommendedDiluent}]

};


(* ::Subsection::Closed:: *)
(* Test Registration *)


registerValidQTestFunction[Object[ManufacturingSpecification],validManufacturingSpecificationQTests];
registerValidQTestFunction[Object[ManufacturingSpecification,CapillaryELISACartridge],validManufacturingSpecificationCapillaryELISACartridgeQTests];
