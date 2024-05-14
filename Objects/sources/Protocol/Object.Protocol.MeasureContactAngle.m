(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,MeasureContactAngle],{
	Description->"A protocol for measuring the contact angle between a fiber and a liquid sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		WettingLiquids->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"For each member of SamplesIn, the liquid samples that are contacted by the fiber samples in order to measure the contact angle between them.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument,Tensiometer]|Model[Instrument,Tensiometer],
			Description->"The tensiometer that is used to measure the contact angle between the fiber and liquid sample.",
			Category->"General",
			Abstract->True
		},
		ProjectName->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The project folder name of the contact angle measurement protocol used for the instrument software and data storage.",
			Category->"General",
			Developer->True
		},
		(* Accessory Resources *)
		ImmersionContainer->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container,Vessel],
				Object[Container,Vessel]
			],
			Description->"For each member of SamplesIn, the container that holds test liquid into which the fiber is immersed.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		FiberSampleHolder->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container,FiberSampleHolder],
				Object[Container,FiberSampleHolder]
			],
			Description->"For each member of SamplesIn, the fiber sample holder that holds fiber samples which is mounted onto the instrument.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		Tweezer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item],Object[Item]],
			Description->"The tweezer that will be used to handle the fiber samples.",
			Category->"General",
			Developer->True
		},
		Backdrop->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item],Object[Item]],
			Description->"The item that has white background and can help handling the fiber samples.",
			Category->"General",
			Developer->True
		},
		(* Procedural Parameters *)
		NumberOfCycles->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"For each member of SamplesIn, the number of times that the sample stage is raised and lowered such that the advancing contact angle is measured when raising and receding contact angle is measured when lowering.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		ContactDetectionSpeed->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter/Minute],
			Units->Millimeter/Minute,
			Description->"For each member of SamplesIn, the surface or interface is automatically detected before the measurement is carried out. This parameter specifies the speed at which the sample stage moves upwards during interface detection step.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		ContactDetectionSensitivity->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Gram],
			Units->Gram,
			Description->"For each member of SamplesIn, the minimum change in the value measured by the sensor that is used to determine if solid and liquid contact. The larger the value, the lower the sensitivity, and vice versa.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		ContactDetectionSensitivityAdjustmentLog->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>{QuantityArrayP[{Gram..}]..},
			Description->"For each member of SamplesIn, the adjustments made on Contact Detection Sensitivity when the original value is not ideal for the measurement.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		MeasuringSpeed->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter/Minute],
			Units->Millimeter/Minute,
			Description->"For each member of SamplesIn, the speed of movement of the sample stage while measuring the contact angle.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		AcquisitionStep->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"For each member of SamplesIn, this parameter specifies position resolution for the measurement. The number of measuring points per section is obtained from the distance between Max and StartImmersionDepth and this parameter.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		StartImmersionDepth->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"For each member of SamplesIn, the minimum immersion depth of the solid when measuring the contact angle.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		EndImmersionDepth->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"For each member of SamplesIn, the maximum immersion depth of the solid when measuring the advancing contact angle.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		StartImmersionDelay->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Second],
			Units->Second,
			Description->"For each member of SamplesIn, the waiting time before the start of the next cycle (lower position).",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		EndImmersionDelay->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Second],
			Units->Second,
			Description->"For each member of SamplesIn, the waiting time before the start of the return of the sample stage (upper position).",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		(* Recirculating Pump Settings *)
		Temperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of SamplesIn, the temperature of sample stage temperature jacket, which is controlled by an external circulating bath.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		RecirculatingPump->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Instrument,RecirculatingPump],Object[Instrument,RecirculatingPump]],
			Description->"The pump that chills or heats fluid and flows it through the temperature control column in order to regulate the temperature during the experiment.",
			Category->"Instrument Specifications"
		},
		Volume->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Milliliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the amount of wetting liquid to use in the ImmersionContainer.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		FiberSampleCount->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"For each member of SamplesIn, the number of fiber sample to use in the experiment.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		FiberSampleAppearance->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"For each member of SamplesIn, the image taken of the fiber sample while mounted.",
			Category->"General"
		},
		MeasurementTime->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the total amount of time it takes to complete all the contact angle measurement cycles.",
			IndexMatching->SamplesIn,
			Category->"General",
			Developer->True
		},
		MeasurementNames->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of SamplesIn, the measurement names of the contact angle measurements and the data file names generated at the conclusion of the experiment.",
			IndexMatching->SamplesIn,
			Category->"General",
			Developer->True
		},
		DataFileNames->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of SamplesIn, the file path of the contact angle measurements and data files generated at the conclusion of the experiment.",
			IndexMatching->SamplesIn,
			Category->"Data Processing",
			Developer->True
		},
		DataFileValidation->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the data file path is checked that it exists.",
			IndexMatching->SamplesIn,
			Category->"Data Processing",
			Developer->True
		},
		FiberSampleHolderPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Alternatives[Object[Container],Model[Container],Object[Item,WilhelmyPlate]],Null},
			Description->"For each member of SamplesIn, a list of placements used to place the fiber sample holders in their appropriate positions on the single fiber tensiometer.",
			IndexMatching->SamplesIn,
			Category->"Instrument Specifications",
			Developer->True,
			Headers->{"Object to Place","Placement Tree"}
		},
		ImmersionContainerPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Alternatives[Object[Container],Model[Container]],Null},
			Description->"For each member of SamplesIn, a list of placements used to place the immersion containers in their appropriate positions on the single fiber tensiometer.",
			IndexMatching->SamplesIn,
			Category->"Instrument Specifications",
			Developer->True,
			Headers->{"Object to Place","Placement Tree"}
		},
		WettedLengthMeasurement->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the perimeter of the wetted fiber is measured before contact angle measurement.",
			IndexMatching->SamplesIn,
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
			Description->"For each member of SamplesIn, the liquid samples that are contacted by the fiber samples in order to measure the wetted length of them.",
			IndexMatching->SamplesIn,
			Category->"General"
		},
		WettedLengthMeasurementNames->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of SamplesIn, if WettedLengthMeasurement is True, the measurement names of the wetted length measurements and the data file names generated at the conclusion of the experiment.",
			Category->"General",
			Developer->True,
			IndexMatching->SamplesIn
		},
		WettedLengthDataFileNames->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of SamplesIn, if WettedLengthMeasurement is True, the file path of the wetted length measurements and data files generated at the conclusion of the this step in a MeasureContactAngle experiment.",
			IndexMatching->SamplesIn,
			Category->"Data Processing",
			Developer->True
		},
		WettedLengthMeasurementContainerPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Alternatives[Object[Container],Model[Container]],Null},
			Description->"For each member of SamplesIn, a list of placements used to place the liquid containers for wetted length measurement in their appropriate positions on the single fiber tensiometer.",
			IndexMatching->SamplesIn,
			Category->"Instrument Specifications",
			Developer->True,
			Headers->{"Object to Place","Placement Tree"}
		},
		WettedLengthData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"For each member of SamplesIn, the object stores the wetted length data.",
			Category->"Experimental Results"
		},
		ContactAngleData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"For each member of SamplesIn, the object stores the contact angle data.",
			Category->"Experimental Results"
		}
	}
}];