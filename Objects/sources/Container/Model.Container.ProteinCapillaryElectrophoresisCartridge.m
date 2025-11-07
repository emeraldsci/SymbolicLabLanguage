(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container,ProteinCapillaryElectrophoresisCartridge],{
	Description->"Model information for a capillary electrophoresis cartridge that houses the capillary and buffers required for capillary electrophoresis experiments.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		CartridgeImageFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"A photo of this cartridge.",
			Category->"Organizational Information",
			Abstract->True
		},
		ExperimentType->{
			Format->Single,
			Class->Expression,
			Pattern:>CEApplicationP,(* cIEF|CESDS|CESDSPlus *)
			Description->"The experiment this cartridge is designed to perform.",
			Category->"Organizational Information",
			Abstract->True
		},
		(* Reagents *)
		OnBoardRunningBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item,Consumable],
			Description->"The running buffer solution loaded on the CESDS cartridge.",
			Category->"Reagents"
		},
		OnBoardInsert->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container,ProteinCapillaryElectrophoresisCartridgeInsert],
			Description->"The cartridge insert that houses the running buffer vial or cleanup vial in the CESDS cartridge.",
			Category->"Reagents"
		},
		OnBoardElectrolytes->{
			Format->Single,
			Class->{Link,Link},
			Pattern:>{_Link,_Link},
			Relation->{Model[Sample],Model[Sample]},
			Headers->{"Anolyte","Catholyte"},
			Description->"The electrolyte buffer solutions loaded on the cIEF cartridge.",
			Category->"Reagents"
		},
		(* Physical Properties *)
		CapillaryLength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Centimeter],
			Units->Centimeter,
			Description->"The effective linear distance of the capillary in the cartridge.",
			Category->"Physical Properties"
		},
		CapillaryDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Micrometer],
			Units->Micrometer,
			Description->"The internal distance from wall to wall of the capillary in the cartridge.",
			Category->"Physical Properties"
		},
		CapillaryMaterial->{
			Format->Single,
			Class->Expression,
			Pattern:>MaterialP,
			Description->"The substance that the capillary tube in the cartridge is composed of.",
			Category->"Physical Properties"
		},
		CapillaryCoating->{
			Format->Single,
			Class->Expression,
			Pattern:>CECoatingP,(* None|Fluorocarbon *) (* look up other pattern that might work *)
			Description->"The substance that coats the capillary in the cartridge.",
			Category->"Physical Properties"
		},
		Aperture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter Milli,
			Description -> "The minimum opening diameter encountered when aspirating from the container.",
			Category -> "Dimensions & Positions"
		},
		(* Operations Information *)
		MaxInjections->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"The maximum number of injections allowed with cartridge.",
			Category->"Operating Limits",
			Abstract->True
		},
		OptimalMaxInjections->{ (* Max number of usage in Item *)
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"The optimal maximum number of injections allowed with cartridge.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxInjectionsPerBatch->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"The maximum number of injections per batch allowed with cartridge.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxNumberOfBatches->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"The maximum number of injection batches allowed with cartridge.",
			Category->"Operating Limits",
			Abstract->True
		},
		MinVoltage->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"Minimum voltage that can be applied for this ExperimentType.",
			Category->"Operating Limits"
		},
		MaxVoltage->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"Maximum voltage that can be applied for this ExperimentType.",
			Category->"Operating Limits"
		},
		MinAssayVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0Microliter],
			Units->Microliter,
			Description->"Minimal assay volume for capillary electrophoresis.",
			Category->"Operating Limits"
		},
		MaxAssayVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[1Microliter],
			Units->Microliter,
			Description->"Maximal assay volume for capillary electrophoresis.",
			Category->"Operating Limits"
		},
		Sensitivity->{
			Format->Multiple,
			Class->{Expression,Real},
			Pattern:>{CEDetectionP,GreaterP[0*Milligram/Milliliter]},
			Units->{None,Milligram/Milliliter},
			Headers->{"Detection","Limit of detection"},
			Description->"Experimental Limits of detection, by detection system.",
			Category->"Operating Limits"
		},
		MinIsoelectricPointCIEF->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"Minimum pI analyte in linear range for the instrument.",
			Category->"Operating Limits"
		},
		MaxIsoelectricPointCIEF->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"Maximum pI analyte in linear range for the instrument.",
			Category->"Operating Limits"
		},
		MinMolecularWeightCESDS->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kilo*Dalton],
			Units->Kilo*Dalton,
			Description->"Minimum molecular weight analyte in linear range for the instrument.",
			Category->"Operating Limits"
		},
		MaxMolecularWeightCESDS->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kilo*Dalton],
			Units->Kilo*Dalton,
			Description->"Maximum molecular weight analyte in linear range for the instrument.",
			Category->"Operating Limits"
		},
		ProductsContained -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][DefaultContainerModel],
			Description -> "Products representing regularly ordered items that are delivered in this type of Container by default.",
			Category -> "Inventory",
			Developer->True
		}
	}
}
];