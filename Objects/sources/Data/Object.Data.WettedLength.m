(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data,WettedLength],{
	Description->"Measurements of the wetted length of a fiber sample in a fluid sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Sample->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Object[Item,WilhelmyPlate]
			],
			Description->"The fiber sample that is contacted by the wetting liquid in order to measure the wetted length of fiber sample.",
			Category->"General"
		},
		WettingLiquid->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"The liquid sample that is contacted by the fiber sample in order to measure the wetted length of fiber sample.",
			Category->"General"
		},
		Temperature->{
			Format->Single,
			Class->Distribution,
			Pattern:>DistributionP[Celsius],
			Units->Celsius,
			Description->"The empirical distribution of temperature readings during the whole measurement.",
			Category->"Experimental Results"
		},
		TemperatureTrace->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Second,Celsius}..}],
			Units->{Second,Celsius},
			Description->"For each member of CycleNumber, the temperature of the wetting liquid during measurement.",
			Category->"Experimental Results"
		},
		ForceMeasured->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Millimeter,Milli Newton}..}],
			Units->{Millimeter,Milli Newton},
			Description->"For each member of CycleNumber, the force measurements at each immersion step as the fiber is immersed into and pulled out of the fluid sample.",
			Category->"Experimental Results"
		},
		CalculatedWettedLength->{
			Format->Single,
			Class->{Real,Real},
			Pattern:>{GreaterP[0 Millimeter],RangeP[0,1]},
			Units->{Millimeter,None},
			Headers->{"Wetted Length","R-Squared"},
			Description->"The calculated wetted length from linear regression of ForceMeasured.",
			Category->"Analysis & Reports"
		},
		FitAnalyses->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"Linear regression analyses conducted on this data.",
			Category->"Analysis & Reports"
		}
	}
}];