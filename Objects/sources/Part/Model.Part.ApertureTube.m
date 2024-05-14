(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part,ApertureTube],{
	Description->"Model of a hollow glass tube with a small aperture near the bottom. Connecting an aperture tube to the coulter counter allows for counting and sizing particles in a sample by suspending them in a conductive electrolyte solution, pumping them through an aperture, and measuring the corresponding electrical resistance change caused by particles in place of the ions passing through the aperture.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*------------------------------Part Specifications------------------------------*)
		ApertureDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer],
			Units->Micrometer,
			Description->"The nominal diameter of the aperture that is located in the bottom of the aperture tube, which dictates the accessible size window for particle size measurement.",
			Category->"Part Specifications",
			Abstract->True
		},
		(*------------------------------Operating Limits------------------------------*)
		MaxCurrent->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Microampere],
			Units->Microampere,
			Description->"The maximum value of the constant current to apply to this aperture tube model during electrical resistance measurement to avoid damage.  The constant current is applied in order to register the momentary electrical resistance change per particle passage as voltage pulse to the electronics.",
			Category->"Operating Limits"
		},
		MinParticleSize->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer],
			Units->Micrometer,
			Description->"The minimum particle size the coulter counter instrument can detect when this aperture tube model is connected.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxParticleSize->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer],
			Units->Micrometer,
			Description->"The maximum particle size the coulter counter instrument can detect when this aperture tube model is connected.",
			Category->"Operating Limits",
			Abstract->True
		},
		FlowRateToPressureStandardCurve->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis,Fit],
			Description->"The standard curves used to convert FlowRate to Pressure used in MS4e software.",
			Developer->True,
			Category->"Analysis & Reports"
		},
		PressureToFlowRateStandardCurve->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis,Fit],
			Description->"The standard curves used to convert Pressure used in MS4e software to FlowRate.",
			Developer->True,
			Category->"Analysis & Reports"
		}
	}
}];

