(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container,ProteinCapillaryElectrophoresisCartridge],{
	Description->"A capillary electrophoresis cartridge that houses the capillary and buffers required for capillary electrophoresis experiments.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		(* General Information *)
		ExperimentType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ExperimentType]],
			Pattern:>CEApplicationP,(* cIEF|CESDS|CESDSPlus *)
			Description->"The experiment this cartridge is designed to perform.",
			Category->"Organizational Information",
			Abstract->True
		},
		(* Reagents *)
		OnBoardRunningBuffer->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],OnBoardRunningBuffer]],
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The running buffer solution loaded on the CESDS cartridge.",
			Category->"Reagents"
		},
		OnBoardInsert->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],OnBoardInsert]],
			Pattern:>_Link,
			Relation->Model[Container,ProteinCapillaryElectrophoresisCartridgeInsert],
			Description->"The cartridge insert that houses the running buffer vial or cleanup vial in the CESDS cartridge.",
			Category->"Reagents"
		},
		OnBoardElectrolytes->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],OnBoardElectrolytes]],
			Pattern:>{_Link,_Link},
			Relation->{Model[Sample],Model[Sample]},
			Headers->{"Anolyte","Catholyte"},
			Description->"The electrolyte buffer solutions loaded on the cIEF cartridge.",
			Category->"Reagents"
		},
		(* Physical Properties *)
		CapillaryLength->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],CapillaryLength]],
			Pattern:>GreaterP[0*Centimeter],
			Description->"The effective linear distance of the capillary in the cartridge.",
			Category->"Physical Properties",
			Abstract->True
		},
		CapillaryDiameter->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],CapillaryDiameter]],
			Pattern:>GreaterP[0*Micrometer],
			Description->"The internal distance from wall to wall of the capillary in the cartridge.",
			Category->"Physical Properties",
			Abstract->True
		},
		CapillaryMaterial->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],CapillaryMaterial]],
			Pattern:>MaterialP,
			Description->"The substance that the capillary tube in the cartridge is composed of.",
			Category->"Physical Properties",
			Abstract->True
		},
		CapillaryCoating->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],CapillaryCoating]],
			Pattern:>CECoatingP,(* None|Fluorocarbon *)
			Description->"The substance that coats the capillary in the cartridge.",
			Category->"Physical Properties",
			Abstract->True
		},

		(* Operations Information *)
		MaxInjections->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxInjections]],
			Pattern:>GreaterP[0,1],
			Description->"The maximum number of injections allowed with cartridge.",
			Category->"Operating Limits",
			Abstract->True
		},
		OptimalMaxInjections->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],OptimalMaxInjections]],
			Pattern:>GreaterP[0,1],
			Description->"The optimal maximum number of injections allowed with cartridge.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxInjectionsPerBatch->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxInjectionsPerBatch]],
			Pattern:>GreaterP[0,1],
			Description->"The maximum number of injections per batch allowed with cartridge.",
			Category->"Operating Limits",
			Abstract->True
		},
		MinVoltage->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinVoltage]],
			Pattern:>GreaterEqualP[0*Volt],
			Description->"Minimum voltage that can be applied for this ExperimentType.",
			Category->"Operating Limits"
		},
		MaxVoltage->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxVoltage]],
			Pattern:>GreaterEqualP[0*Volt],
			Description->"Maximum voltage that can be applied for this ExperimentType.",
			Category->"Operating Limits"
		},
		MinAssayVolume->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinAssayVolume]],
			Pattern:>GreaterP[0,1],
			Description->"Minimal assay volume for this ExperimentType.",
			Category->"Operating Limits"
		},
		MaxAssayVolume->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxAssayVolume]],
			Pattern:>GreaterP[0,1],
			Description->"Maximal assay volume for this ExperimentType.",
			Category->"Operating Limits"
		},
		Sensitivity->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Sensitivity]],
			Pattern:>{CEDetectionP,GreaterP[0*Milligram/Milliliter]},
			Headers->{"Detection","Limit of detection"},
			Description->"Experimental Limits of detection, by detection system.",
			Category->"Operating Limits"
		},
		MinIsoelectricPointCIEF->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinIsoelectricPointCIEF]],
			Pattern:>GreaterP[0],
			Description->"Minimum pI analyte in linear range for the instrument.",
			Category->"Operating Limits"
		},
		MaxIsoelectricPointCIEF->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxIsoelectricPointCIEF]],
			Pattern:>GreaterP[0],
			Description->"Maximum pI analyte in linear range for the instrument.",
			Category->"Operating Limits"
		},
		MinMolecularWeightCESDS->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinMolecularWeightCESDS]],
			Pattern:>GreaterP[0*Kilo*Dalton],
			Description->"Minimum molecular weight analyte in linear range for the instrument.",
			Category->"Operating Limits"
		},
		MaxMolecularWeightCESDS->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxMolecularWeightCESDS]],
			Pattern:>GreaterP[0*Kilo*Dalton],
			Description->"Maximum molecular weight analyte in linear range for the instrument.",
			Category->"Operating Limits"
		},
		(* injection logging *)
		NumberOfBatches->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0],
			Description->"Number of batches run using this cartridge.",
			Category->"Operations Information"
		},
		InjectionLog->{
			Format->Multiple,
			Class->{
				DateInjected->Date,
				Sample->Link, (* check order *)
				Protocol->Link,
				Data->Link
			},
			Pattern:>{
				DateInjected->_?DateObjectQ,
				Sample->_Link,
				Protocol->_Link,
				Data->_Link
			},
			Relation->{
				DateInjected->Null,
				Sample->Object[Sample],
				Protocol->Object[Protocol],
				Data->Object[Data]
			},
			Description->"The samples previously analyzed by this cartridge.",
			Category->"Operations Information"
		},
		CapillaryTipImageLog->{
			Format->Multiple,
			Class->{
				Date->Date,
				Image->Link,
				Protocol->Link
			},
			Pattern:>{
				Date->_?DateObjectQ,
				Image->_Link,
				Protocol->_Link
			},
			Relation->{
				Date->Null,
				Image->Object[EmeraldCloudFile],
				Protocol->Object[Protocol]
			},
			Description->"The CapillaryTipImages after each run using this cartridge.",
			Category->"Operations Information"
		}
	}
}
];
