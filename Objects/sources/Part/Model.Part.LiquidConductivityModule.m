(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, LiquidConductivityModule], {
	Description->"Model information for a liquid conductivity module used in a dynamic foam analysis instrument. The Liquid Conductivity Module is an attachment for the Dynamic Foam Analyzer instrument that provides information on the liquid content and drainage dynamics over time at various positions along the foam column; this is achieved by recording changes in conductivity of the foam over time, which provides information on the amount of liquid vs gas that is present.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* --- data sampling --- *)
		SensorHeights->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Millimeter],
			Units->Millimeter,
			Description->"The fixed heights of the liquid conductivity sensors as measured from the base of the column. The liquid conductivity sensors are made of 35 micrometer gold-finished copper, and measures electrical resistance in Ohm.",
			Category->"Dimensions & Positions"
		},
		MinResistanceMeasurement->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Ohm],
			Units->Ohm,
			Description->"The manufacturer's reported minimum resistance that can be recorded by the liquid conductivity sensors.",
			Category->"Operating Limits"
		},
		MaxResistanceMeasurement->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Ohm],
			Units->Ohm,
			Description->"The manufacturer's reported maximum resistance that can be recorded by the liquid conductivity sensors.",
			Category->"Operating Limits"
		},
		MinResistanceSamplingFrequency->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[Unit/Second],
			Units->Unit/Second,
			Description->"The minimum data sampling rate that can be performed by the Liquid Conductivity Module for liquid content and drainage analysis. The data recorded for the Liquid Conductivity Method are the resistances at sensors spaced along the length of the foam column.",
			Category->"Operating Limits"
		},
		MaxResistanceSamplingFrequency->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[Unit/Second],
			Units->Unit/Second,
			Description->"The maximum data sampling rate that can be performed by the Liquid Conductivity Module for liquid content and drainage analysis. The data recorded for the Liquid Conductivity Method are the resistances at sensors spaced along the length of the foam column.",
			Category->"Operating Limits"
		},

		(* --- Column specifications --- *)
		MinColumnHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[Millimeter],
			Units->Millimeter,
			Description->"The minimum height of the foam column that can be used with the Liquid Conductivity Module.",
			Category->"Operating Limits"
		},
		MaxColumnHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[Millimeter],
			Units->Millimeter,
			Description->"The maximum height of the foam column that can be used with the Liquid Conductivity Module.",
			Category->"Operating Limits"
		}
	}
}];
