(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,MeasureLiquidHandlerDeckAccuracy],{
	Description->"A protocol that verifies the deck offsets of the liquid handler target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		SBSCalibrationTools->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Plate],Object[Container,Plate]],
			Description->"Calibration tools used to measure the physical position of the SBS plate positions.",
			Category->"General"
		},
		TipCalibrationTools->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Plate],Object[Container,Plate]],
			Description->"Calibration tools used to measure the physical position of the tip positions.",
			Category->"General"
		},
		LiquidHandler->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Instrument,LiquidHandler],
				Model[Instrument,LiquidHandler]
			],
			Description->"The liquid handler work cell used to perform the protocol.",
			Category->"General"
		},
		DeckPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			(* NOTE: This can be a Model[Container] if we have a liquid handler adapter that we need to use. *)
			Relation->{Model[Container] | Object[Container] | Object[Sample] | Object[Item],Null},
			Description->"A list of deck placements used to set-up the robotic liquid handler deck.",
			Headers->{"Object to Place","Placement Tree"},
			Category->"Placements",
			Developer->True
		},
		NumberOfWells->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[4,1],
			Units->None,
			Description->"Number of individual wells per plate that will be used to characterize the position of the plate in space.",
			Category->"General"
		},
		NumberOfPositions->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"The number of positions on which we will measure how close the perfect theoretical coordinates of the carrier positions to the experimental positions.",
			Category->"General"
		},
		HamiltonManipulationsFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The method file used to perform the robotic manipulations on the Hamilton liquid handler as specified in the OutputUnitOperations.",
			Category->"General"
		},
		CarrierPositionOffsets->{
			Format->Multiple,
			Class->{
				Item->Link,
				LiquidHandlerCarrierPrefix->String,
				OffsetType->String,
				Position->String,
				XOffset->Real,
				YOffset->Real,
				ZOffset->Real,
				ZRotation->Real
			},
			Pattern:>{
				Item->_Link,
				LiquidHandlerCarrierPrefix->_String,
				OffsetType->_String,
				Position->_String,
				XOffset->DistanceP,
				YOffset->DistanceP,
				ZOffset->DistanceP,
				ZRotation->RangeP[-360 AngularDegree,0 AngularDegree]
			},
			Relation->{
				Item->Alternatives[Model[Container,Rack],Model[Instrument]],
				LiquidHandlerCarrierPrefix->Null,
				OffsetType->Null,
				Position->Null,
				XOffset->Null,
				YOffset->Null,
				ZOffset->Null,
				ZRotation->Null
			},
			Units->{
				Item->None,
				LiquidHandlerCarrierPrefix->None,
				OffsetType->None,
				Position->None,
				XOffset->Millimeter,
				YOffset->Millimeter,
				ZOffset->Millimeter,
				ZRotation->AngularDegree
			},
			Description->"A set of physical adjustments for the plate/tips positions on the carriers created to account for the instrument variation. The Rotational adjustments are performed  clockwise in the plane perpendicular to the mentioned axis (in xy plane for ZRotation for example) with the rotation axis going through the middle of the A1 well.",
			Category->"Dimensions & Positions"
		},
		(* ProtocolKey field is used here instead of QualificationKey here in Object[Qualification,VerifyHamiltonLabware] so we can share procedures with RSP/SM more easily *)
		ProtocolKey->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The protocol key used to identify the method file name.",
			Category->"Instrument Processing",
			Developer->True
		},
		ProcessRecording -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A video recording taken during the entire robotic execution of this qualification.",
			Category -> "Instrument Specifications"
		},
		HamiltonDeckFiles -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The archive containing labware and deck file used in this method.",
			Category -> "General",
			Developer->True
		},
		DataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the raw unprocessed measurements of the well coordinates as well as theoretical positions of those wells without any offsets.",
			Category -> "General"
		},
		RunTime -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?TimeQ,
			Description -> "The estimated time for completion of the liquid handling portion of the protocol.",
			Category -> "General"
		},
		VerificationCode -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The object used to verify that the run was completed on the instrument.",
			Category -> "Instrument Processing",
			Developer -> True
		}
	}
}];