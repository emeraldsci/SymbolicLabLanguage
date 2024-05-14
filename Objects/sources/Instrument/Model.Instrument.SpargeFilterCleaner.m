(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument,SpargeFilterCleaner],{
	Description->"Model information for a cleaning unit used to clean the sparge filters after a dynamic foam analysis experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		PumpType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> VacuumPumpTypeP,
			Description -> "Type of vacuum pump. Options include Oil, Diaphragm, Rocker, or Scroll.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		VacuumPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Atmosphere, 1*Atmosphere],
			Units -> Torr,
			Description -> "Minimum absolute pressure (zero-referenced against perfect vacuum) that this pump can achieve.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinFilterDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Millimeter],
			Units->Millimeter,
			Description->"The minimum diameter of the sparge filter that can be cleaned on this cleaner.",
			Category->"Operating Limits"
		},
		MaxFilterDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Millimeter],
			Units->Millimeter,
			Description->"The maximum diameter of the sparge filter that can be cleaned on this cleaner.",
			Category->"Operating Limits"
		}
	}
}];
