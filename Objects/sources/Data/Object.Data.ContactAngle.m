(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data,ContactAngle],{
	Description->"Measurements of the contact angle of a fiber sample in a fluid sample.",
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
			Description->"The fiber sample that is contacted by the wetting liquid in order to measure the contact angle between them.",
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
			Description->"The liquid sample that is contacted by the fiber sample in order to measure the contact angle between them.",
			Category->"General"
		},
		CycleNumber->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Units->None,
			Description->"The number of times the fiber sample is immersed in and pulled from the fluid sample.",
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
			Format->Multiple,
			Class->{QuantityArray,QuantityArray},
			Pattern:>{QuantityArrayP[{{Second,Celsius}..}],QuantityArrayP[{{Second,Celsius}..}]},
			Units->{{Second,Celsius},{Second,Celsius}},
			Description->"For each member of CycleNumber, the temperature of the wetting liquid during measurement.",
			Headers->{"Advancing","Receding"},
			IndexMatching->CycleNumber,
			Category->"Experimental Results"
		},
		ForceMeasured->{
			Format->Multiple,
			Class->{QuantityArray,QuantityArray},
			Pattern:>{QuantityArrayP[{{Millimeter,Milli Newton}..}],QuantityArrayP[{{Millimeter,Milli Newton}..}]},
			Units->{{Millimeter,Milli Newton},{Millimeter,Milli Newton}},
			Description->"For each member of CycleNumber, the force measurements at each immersion step as the fiber is immersed into and pulled out of the fluid sample.",
			Headers->{"Advancing","Receding"},
			IndexMatching->CycleNumber,
			Category->"Experimental Results"
		},
		AdvancingContactAngle->{
			Format->Multiple,
			Class->{Real,Real},
			Pattern:>{GreaterP[0 AngularDegree],RangeP[0,1]},
			Units->{AngularDegree,None},
			Headers->{"Contact Angle","R-Squared"},
			Description->"For each member of CycleNumber, the advancing contact angle of the fiber sample with the fluid sample fitted from the force measurements during phase when the fiber is immersing into wetting liquid and the R-Squared value of the fitting.",
			IndexMatching->CycleNumber,
			Category->"Analysis & Reports"
		},
		RecedingContactAngle->{
			Format->Multiple,
			Class->{Real,Real},
			Pattern:>{GreaterP[0 AngularDegree],RangeP[0,1]},
			Units->{AngularDegree,None},
			Headers->{"Contact Angle","R-Squared"},
			Description->"For each member of CycleNumber, the receding contact angle of the fiber sample with the fluid sample fitted from the force measurements during phase when the fiber is exiting from wetting liquid and the R-Squared value of the fitting.",
			IndexMatching->CycleNumber,
			Category->"Analysis & Reports"
		},
		AdvancingContactAngleFitAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"For each member of CycleNumber, the linear regression analyses for Advancing Contact Angle.",
			IndexMatching->CycleNumber,
			Category->"Analysis & Reports"
		},
		RecedingContactAngleFitAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"For each member of CycleNumber, the linear regression analyses for Receding Contact Angle.",
			IndexMatching->CycleNumber,
			Category->"Analysis & Reports"
		}
	}
}];