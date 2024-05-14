(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation,MeasureContactAngle],{
	Description->"A unit operation describing the measurement of the contact angle between a fiber and a liquid sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* Sample-related fields *)
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument,Tensiometer]|Model[Instrument,Tensiometer],
			Description->"The tensiometer that is used to measure the contact angle between the fiber and liquid sample.",
			Category->"General",
			Abstract->True
		},
		SampleLink->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Container],
				Model[Container]
			],
			Description->"Fiber samples to be immersed in WettingLiquids in this experiment.",
			Category->"General",
			Migration->SplitField
		},
		SampleString->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Relation->Null,
			Description->"Fiber samples to be immersed in WettingLiquids in this experiment.",
			Category->"General",
			Migration->SplitField
		},
		WettingLiquidLink->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			IndexMatching->SampleLink,
			Description->"For each member of SampleLink, the liquid samples that are contacted by the fiber samples in order to measure the contact angle between them.",
			Category->"General",
			Migration->SplitField
		},
		WettingLiquidString->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			IndexMatching->SampleLink,
			Description->"For each member of SampleLink, the liquid samples that are contacted by the fiber samples in order to measure the contact angle between them.",
			Category->"General",
			Migration->SplitField
		},
		SampleLabel->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Relation->Null,
			Description->"For each member of SampleLink, a user defined word or phrase used to identify the sample that is used in the experiment, for use in downstream unit operations.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		SampleContainerLabel->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Relation->Null,
			Description->"For each member of SampleLink, a user defined word or phrase used to identify the container of the sample that is used in the experiment, for use in downstream unit operations.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		WettingLiquids->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"For each member of SampleLink, the wetting liquid that is used in the experiment, for use in downstream unit operations.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		WettingLiquidLabel->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Relation->Null,
			Description->"For each member of SampleLink, a user defined word or phrase used to identify the wetting liquid that is used in the experiment, for use in downstream unit operations.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		WettingLiquidContainerLabel->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Relation->Null,
			Description->"For each member of SampleLink, a user defined word or phrase used to identify the container of the wetting liquid that is used in the experiment, for use in downstream unit operations.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		WettedLengthMeasurementLiquids->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"For each member of SampleLink, the wetting liquid that is used for WettedLengthMeasurement in the experiment, for use in downstream unit operations.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		(* MeasureContactAngle options *)
		NumberOfCycles->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"For each member of SampleLink, number of times that the sample stage is raised and lowered such that the advancing contact angle is measured when raising and receding contact angle is measured when lowering.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		ContactDetectionSpeed->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter/Minute],
			Units->Millimeter/Minute,
			Description->"For each member of SampleLink, the surface or interface is automatically detected before the measurement is carried out. This parameter specifies the speed at which the sample stage moves upwards during detection.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		ContactDetectionSensitivity->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Gram],
			Units->Gram,
			Description->"For each member of SampleLink, the minimum change in the value measured by the sensor that is used to determine if solid and liquid contact. The larger the value, the lower the sensitivity, and vice versa.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		MeasuringSpeed->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter/Minute],
			Units->Millimeter/Minute,
			Description->"For each member of SampleLink, speed of movement of the sample stage while measuring the contact angle.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		AcquisitionStep->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"For each member of SampleLink, this parameter specifies position resolution for the measurement. The number of measuring points per section is obtained from the length of the section and this parameter.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		EndImmersionDepth->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"For each member of SampleLink, the maximum immersion depth of the solid when measuring the advancing contact angle.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		StartImmersionDepth->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"For each member of SampleLink, the minimum immersion depth of the solid when measuring the contact angle.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		EndImmersionDelay->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Second],
			Units->Second,
			Description->"For each member of SampleLink, the waiting time before the start of the return of the sample stage (upper position).",
			IndexMatching->SampleLink,
			Category->"General"
		},
		StartImmersionDelay->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Second],
			Units->Second,
			Description->"For each member of SampleLink, the waiting time before the start of the next cycle (lower position).",
			IndexMatching->SampleLink,
			Category->"General"
		},
		Temperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of SampleLink, the temperature of sample stage temperature jacket, which is controlled by an external circulating bath.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		Volume->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Milliliter],
			Units->Milliliter,
			Description->"For each member of SampleLink, the amount of wetting liquid to use in the ImmersionContainer.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		ImmersionContainer->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container,Vessel],
				Object[Container,Vessel]
			],
			Description->"For each member of SampleLink, the container that holds test liquid into which the fiber is immersed.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		WettedLengthMeasurement->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SampleLink, indicates if the perimeter of the wetted fiber is measured before contact angle measurement.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		FiberSampleHolder->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container,FiberSampleHolder],
			Description->"For each member of SampleLink, the container model that holds the solid fiber sample and is mounted onto the force sensor of instrument.",
			IndexMatching->SampleLink,
			Category->"General"
		}
	}
}];
