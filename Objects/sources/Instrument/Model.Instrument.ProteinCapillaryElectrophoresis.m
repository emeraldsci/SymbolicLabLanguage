(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument,ProteinCapillaryElectrophoresis],{
	Description->"A capillary electrophoresis instrument that will be used by the protocol. The instrument accepts the cartridge carrying a capillary and buffers that separates proteins by their size or charge. Required solutions are loaded with either pressure caps, that facilitate capillary conditioning and washing by forced pressure, or pierceable caps that allow sampling by vacuum or electrokinetic injection. Samples can be in 96-well inserts or sampling vials with inserts and the sample tray can be kept at varying temperatures. OnBoardMixing of samples and a master mix is available for some experiments and is recommended for sensitive samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		OnBoardMixing->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if instrument equipped to perform onboard mixing for cIEF.",
			Category->"Operating Limits"
		},
		AntibodyDrugConjugateFilter->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if instrument equipped with 458nm filter for specific Antibody-Drug Conjugate assays.",
			Category->"Operating Limits"
		},
		MinVoltage->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"Minimum voltage that can be applied by the instrument.",
			Category->"Operating Limits"
		},
		MaxVoltage->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"Maximum voltage that can be applied by instrument.",
			Category->"Operating Limits"
		},
		MaxVoltageSteps->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"Maximum number of steps in voltage profiles that can be applied on instrument.",
			Category->"Operating Limits"
		}
	}
}];