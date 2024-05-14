(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Report, ReviewExperiment], {
	Description->"A report on the estimated shipping prices from a source site to a representative set of ZIP codes.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ReviewNotebook -> {
			Format -> Single,
			Class -> Link,
			Pattern :> LinkP[],
			Relation -> Object[EmeraldCloudFile],
			Description -> "The notebook page visualizing this report.",
			Category -> "Organizational Information"			
		},
		
		(* --- "Environment and Feed Utilities" Category --- *)
		SensorAnomalies -> {
			Format -> Multiple,
			Class -> {
				Date -> Date,
				Alert -> Link,
				Sensor -> Link,
				AlertCategory -> Expression
			},
			Pattern :> {
				Date -> _DateObject,
				Alert -> _Link,
				Sensor -> _Link,
				AlertCategory -> AlertCategoryP
			},
			Relation -> {
				Date -> Null,
				Alert -> Object[Notification],
				Sensor -> Object[Sensor],
				AlertCategory -> Null
			},
			Description -> "Any suspect sensor values.",
			Category -> "Organizational Information"
		},
		PriorCalibrations -> {
				Format -> Multiple,
				Class -> {Date,Link,Link},
				Pattern :> {_DateObject,_Link,_Link},
				Relation -> {Null,Object[Instrument]|Object[Sensor],Object[Maintenance]},
				Headers -> {"Date","Instrument","Calibration"},
				Description -> "Relevant instrument calibrations before this protocol was run.",
				Category -> "Organizational Information"
		},
		SubsequentCalibrations -> {
				Format -> Multiple,
				Class -> {Date,Link,Link},
				Pattern :> {_DateObject,_Link,_Link},
				Relation -> {Null,Object[Instrument]|Object[Sensor],Object[Maintenance]},
				Headers -> {"Date","Instrument","Calibration"},
				Description -> "Relevant instrument calibrations after this protocol was run.",
				Category -> "Organizational Information"
		},
		GasSources -> {
			Format -> Multiple,
			Class -> {
				SuppliedInstrumentField -> Expression,
				SuppliedInstrument -> Link,
				GasType -> Expression,
				GasSample -> Link,
				GasRegulator -> Link,
				GasModel -> Link,
				GasRegulatorModel -> Link,
				LocalPressureTrace -> Link,
				SourcePressureTrace -> Link,
				Protocol -> Link
			},
			Pattern :> {
				SuppliedInstrumentField -> FieldP[],
				SuppliedInstrument -> _Link,
				GasType -> DegasGasP,
				GasSample -> _Link,
				GasRegulator -> _Link,
				GasModel -> _Link,
				GasRegulatorModel -> _Link,
				LocalPressureTrace -> _Link, (* Call ReadSensor[sensor, protocol start, protocol end *)
				SourcePressureTrace -> _Link, (* Call ReadSensor[sensor, protocol start, protocol end *)
				Protocol -> _Link
			},
			Relation -> {
				SuppliedInstrumentField -> Null,
				SuppliedInstrument -> Object[Instrument],
				GasType -> Null,
				GasSample -> Object[Sample],
				GasRegulator -> Object[Part],
				GasModel -> Model[Sample],
				GasRegulatorModel -> Model[Part],
				LocalPressureTrace -> Object[Data,Pressure], (* Call ReadSensor[sensor, protocol start, protocol end *)
				SourcePressureTrace -> Object[Data,Pressure], (* Call ReadSensor[sensor, protocol start, protocol end *)
				Protocol -> (Object[Protocol]|Object[Maintenance]|Object[Qualification])
			},
			Description -> "Relevant gas usage during this protocol.",
			Category -> "Organizational Information"
		},
		WaterSources -> {
				Format -> Multiple,
				Class -> {
 		     RequestingField -> Expression,
 		     WaterPurifier -> Link,
 		     WaterPurifierLogbook -> Link,
 		     WaterSample -> Link,
 		     WaterModel -> Link,
 		     WaterFilter -> Link,
 		     FilterChangeDate -> Date,
 		     PurgeFrequency -> Expression,
 		     PreviousWaterDispense -> Expression,
 		     Protocol -> Link
 		   },
			 Pattern :> {
				 RequestingField -> FieldP[],
		     WaterPurifier -> _Link,
		     WaterPurifierLogbook -> _Link,
		     WaterSample -> _Link,
		     WaterModel -> _Link,
		     WaterFilter -> _Link,
		     FilterChangeDate -> _DateObject,
		     PurgeFrequency -> TimeP[], (* Can we get real data? *)
		     PreviousWaterDispense -> {_DateObject,ObjectP[Object[Protocol]],VolumeP}, (* Can we see the ID if this is another user's protocol? *)
		     (* TODO - add remaining filter fields. Prefilter, etc.? *)
		     (* TODO - add tracking fields, conductivity, TOC, etc. *)
		     Protocol -> _Link
			 },
			 Relation -> {
				RequestingField -> Null,
				WaterPurifier -> Object[Instrument,WaterPurifier],
				WaterPurifierLogbook -> Object[EmeraldCloudFile],
				WaterSample -> Object[Sample],
				WaterModel -> Model[Sample],
				WaterFilter -> Object[Part],
				FilterChangeDate -> Null,
				PurgeFrequency -> Null, (* Can we get real data? *)
				PreviousWaterDispense -> Null, (* Can we see the ID if this is another user's protocol? *)
				(* TODO - add remaining filter fields. Prefilter, etc.? *)
				(* TODO - add tracking fields, conductivity, TOC, etc. *)
				Protocol -> (Object[Protocol]|Object[Maintenance]|Object[Qualification])
			},
			Description -> "Relevant water usage during this protocol.",
 			Category -> "Organizational Information"
		},
		
		(* --- "Instrument Check" Category --- *)

		(* Bookend the instrument use date with the closest previous qual and the closest following qual (Null if not available) *)
		(* Headers: {Instrument, Previous Qual, Subsequent Qual} *)
		PriorQualifications -> {
			Format -> Multiple,
			Class -> {Date,Link,Link,Expression},
			Pattern :> {_DateObject,_Link,_Link,QualificationResultP},
			Relation -> {Null,Object[Instrument],Object[Qualification],Null},
			Headers -> {"Date","Instrument","Qualification","Result"},
			Description -> "Qualifications run on relevant instruments at the closest date prior to this protocol.",
 			Category -> "Organizational Information"
		},
		SubsequentQualifications -> {
			Format -> Multiple,
			Class -> {Date,Link,Link,Expression},
			Pattern :> {_DateObject,_Link,_Link,QualificationResultP},
			Relation -> {Null,Object[Instrument],Object[Qualification],Null},
			Headers -> {"Date","Instrument","Qualification","Result"},
			Description -> "Qualifications run on relevant instruments at the closest date after to this protocol.",
 			Category -> "Organizational Information"
		},
		
		PreventativeMaintenance -> {
			Format -> Multiple,
			Class -> {Date,Link,Link},
			Pattern :> {_DateObject,_Link,_Link},
			Relation -> {Null,Object[Instrument],Object[Maintenance]},
			Headers -> {"Date","Instrument","Maintenance"},
			Description -> "The last three preventative maintenances run prior to the protocol for each relevant instrument.",
 			Category -> "Organizational Information"
		},
		
		SanitizationMaintenance -> {
			Format -> Multiple,
			Class -> {Date,Link,Link},
			Pattern :> {_DateObject,_Link,_Link},
			Relation -> {Null,Object[Instrument],Object[Maintenance]},
			Headers -> {"Date","Instrument","Maintenance"},
			Description -> "The last three sanitization maintenances run prior to the protocol for each relevant instrument.",
 			Category -> "Organizational Information"
		},
		
		InstrumentLogbooks -> {
			Format -> Multiple,
			Class -> {Link,Link},
			Pattern :> {_Link,_Link},
			Relation -> {Object[Instrument],Object[EmeraldCloudFile]},
			Headers -> {"Instrument","Logbook"},
			Description -> "Relevant instrument logbooks.",
 			Category -> "Organizational Information"
		},
		
		
		(* --- "Materials Check" Category --- *)
				
		ResourceTable -> {
			Format -> Multiple,
			Class -> {
				FieldName -> Expression,
				Item -> Link,
				Model -> Link,
				Protocol -> Link
			},
			Pattern :> {
				FieldName -> _Symbol,
				Item -> _Link,
				Model -> _Link,
				Protocol -> _Link
			},
			Relation -> {
				FieldName -> Null,
				Item -> Alternatives[
					Object[Sample],
					Object[Container],
					Object[Part],
					Object[Plumbing],
					Object[Item],
					Object[Sensor],
					Object[Wiring]
				],
				Model -> Alternatives[
					Model[Sample],
					Model[Container],
					Model[Part],
					Model[Plumbing],
					Model[Item],
					Model[Sensor],
					Model[Wiring]
				],
				Protocol -> Alternatives[
					Object[Protocol],
					Object[Maintenance],
					Object[Qualification],
					Object[Program],
					Object[UnitOperation]
				]
			},
			Description -> "Resources used in this experiment.",
 			Category -> "Organizational Information"
		},
		
		ExpirationCheck -> {
			Format -> Multiple,
			Class -> {
				FieldName -> Expression,
				Item -> Link,
				Model -> Link,
				ExpirationDate -> Date,
				DateUsed -> Date,
				TimeRemaining -> Expression,
				DateStocked -> Date,
				ShelfLife -> Expression,
				DateUnsealed -> Date,
				UnsealedShelfLife -> Expression,
				Protocol -> Link
			},
			Pattern :> {
				FieldName -> _Symbol,
				Item -> _Link,
				Model -> _Link,
				ExpirationDate -> _DateObject,
				DateUsed -> _DateObject,
				TimeRemaining -> TimeP,
				DateStocked -> _DateObject,
				ShelfLife -> TimeP,
				DateUnsealed -> _DateObject,
				UnsealedShelfLife -> TimeP,
				Protocol -> _Link
			},
			Relation -> {
				FieldName -> Null,
				Item -> Alternatives[
					Object[Sample],
					Object[Container],
					Object[Part],
					Object[Plumbing],
					Object[Item],
					Object[Sensor],
					Object[Wiring]
				],
				Model -> Alternatives[
					Model[Sample],
					Model[Container],
					Model[Part],
					Model[Plumbing],
					Model[Item],
					Model[Sensor],
					Model[Wiring]
				],
				ExpirationDate -> Null,
				DateUsed -> Null,
				TimeRemaining -> Null,
				DateStocked -> Null,
				ShelfLife -> Null,
				DateUnsealed -> Null,
				UnsealedShelfLife -> Null,
				Protocol -> Alternatives[
					Object[Protocol],
					Object[Maintenance],
					Object[Qualification],
					Object[Program],
					Object[UnitOperation]
				]
			},
			Description -> "Expiration date information for resources used in this experiment.",
 			Category -> "Organizational Information"
		},
		AppearanceCheck -> {
			Format -> Multiple,
			Class -> {
				FieldName -> Expression,
				Sample -> Link,
				Model -> Link,
				Appearance -> Link,
				Protocol -> Link
			},
			Pattern :> {
				FieldName -> _Symbol,
				Sample -> _Link,
				Model -> _Link,
				Appearance -> _Link,
				Protocol -> _Link
			},
			Relation -> {
				FieldName -> Null,
				Sample -> Alternatives[
					Object[Sample],
					Object[Container],
					Object[Part],
					Object[Plumbing],
					Object[Item],
					Object[Sensor],
					Object[Wiring]
				],
				Model -> Alternatives[
					Model[Sample],
					Model[Container],
					Model[Part],
					Model[Plumbing],
					Model[Item],
					Model[Sensor],
					Model[Wiring]
				],
				Appearance -> Object[EmeraldCloudFile],
				Protocol -> Alternatives[
					Object[Protocol],
					Object[Maintenance],
					Object[Qualification],
					Object[Program],
					Object[UnitOperation]
				]
			},
			Description -> "Appearance information for resources used in this experiment.",
 			Category -> "Organizational Information"
			
		},
		
		FullyDissolvedCheck -> {
			Format -> Multiple,
			Class -> {
				FieldName -> Expression,
				Sample -> Link,
				Model -> Link,
				FullyDissolved -> Boolean,
				Protocol -> Link
			},
			Pattern :> {
				FieldName -> _Symbol,
				Sample -> _Link,
				Model -> _Link,
				FullyDissolved -> BooleanP,
				Protocol -> _Link
			},
			Relation -> {
				FieldName -> Null,
				Sample -> Alternatives[
					Object[Sample],
					Object[Container],
					Object[Part],
					Object[Plumbing],
					Object[Item],
					Object[Sensor],
					Object[Wiring]
				],
				Model -> Alternatives[
					Model[Sample],
					Model[Container],
					Model[Part],
					Model[Plumbing],
					Model[Item],
					Model[Sensor],
					Model[Wiring]
				],
				FullyDissolved -> Null,
				Protocol -> Alternatives[
					Object[Protocol],
					Object[Maintenance],
					Object[Qualification],
					Object[Program],
					Object[UnitOperation]
				]
			},
			Description -> "Dissolution information for resources used in this experiment.",
 			Category -> "Organizational Information"
		},
		
		pHAdjustmentCheck -> {
			Format -> Multiple,
			Class -> {
				FieldName -> Expression,
				Sample -> Link,
				Model -> Link,
				pHAchieved -> Boolean,
				Protocol -> Link
			},
			Pattern :> {
				FieldName -> _Symbol,
				Sample -> _Link,
				Model -> _Link,
				pHAchieved -> BooleanP,
				Protocol -> _Link
			},
			Relation -> {
				FieldName -> Null,
				Sample -> Alternatives[
					Object[Sample],
					Object[Container],
					Object[Part],
					Object[Plumbing],
					Object[Item],
					Object[Sensor],
					Object[Wiring]
				],
				Model -> Alternatives[
					Model[Sample],
					Model[Container],
					Model[Part],
					Model[Plumbing],
					Model[Item],
					Model[Sensor],
					Model[Wiring]
				],
				pHAchieved -> Null,
				Protocol -> Alternatives[
					Object[Protocol],
					Object[Maintenance],
					Object[Qualification],
					Object[Program],
					Object[UnitOperation]
				]
			},
			Description -> "Information regarding pH for resources used in this experiment.",
 			Category -> "Organizational Information"
		},

		NumberOfUses -> {
			Format -> Multiple,
			Class -> {
				FieldName -> Expression,
				Sample -> Link,
				Model -> Link,
				StartNumberOfUses -> Integer,
				EndNumberOfUses -> Integer,
				MaxNumberOfUses -> Integer,
				Protocol -> Link
			},
			Pattern :> {
				FieldName -> _Symbol,
				Sample -> _Link,
				Model -> _Link,
				StartNumberOfUses -> _Integer,
				EndNumberOfUses -> _Integer,
				MaxNumberOfUses -> _Integer,
				Protocol -> _Link
			},
			Relation -> {
				FieldName -> Null,
				Sample -> Alternatives[
					Object[Sample],
					Object[Container],
					Object[Part],
					Object[Plumbing],
					Object[Item],
					Object[Sensor],
					Object[Wiring]
				],
				Model -> Alternatives[
					Model[Sample],
					Model[Container],
					Model[Part],
					Model[Plumbing],
					Model[Item],
					Model[Sensor],
					Model[Wiring]
				],
				StartNumberOfUses -> Null,
				EndNumberOfUses -> Null,
				MaxNumberOfUses -> Null,
				Protocol -> Alternatives[
					Object[Protocol],
					Object[Maintenance],
					Object[Qualification],
					Object[Program],
					Object[UnitOperation]
				]
			},
			Description -> "Number of uses information for resources used in this experiment.",
 			Category -> "Organizational Information"
		},
		
		FreezeThawHistory -> {
			Format -> Multiple,
			Class -> {
				FieldName -> Expression,
				Sample -> Link,
				Model -> Link,
				NumberOfThaws -> Integer,
				Protocol -> Link
			},
			Pattern :> {
				FieldName -> _Symbol,
				Sample -> _Link,
				Model -> _Link,
				NumberOfThaws -> _Integer,
				Protocol -> _Link
			},
			Relation -> {
				FieldName -> Null,
				Sample -> Alternatives[
					Object[Sample],
					Object[Container],
					Object[Part],
					Object[Plumbing],
					Object[Item],
					Object[Sensor],
					Object[Wiring]
				],
				Model -> Alternatives[
					Model[Sample],
					Model[Container],
					Model[Part],
					Model[Plumbing],
					Model[Item],
					Model[Sensor],
					Model[Wiring]
				],
				NumberOfThaws -> Null,
				Protocol -> Alternatives[
					Object[Protocol],
					Object[Maintenance],
					Object[Qualification],
					Object[Program],
					Object[UnitOperation]
				]
			},
			Description -> "Freeze-thaw information for resources used in this experiment.",
 			Category -> "Organizational Information"
		},
		
		SampleHistory -> {
			Format -> Multiple,
			Class -> {
				FieldName -> Expression,
				Sample -> Link,
				Model -> Link,
				SampleHistory -> Expression,
				Protocol -> Link
			},
			Pattern :> {
				FieldName -> _Symbol,
				Sample -> _Link,
				Model -> _Link,
				SampleHistory -> {SampleHistoryP..},
				Protocol -> _Link
			},
			Relation -> {
				FieldName -> Null,
				Sample -> Alternatives[
					Object[Sample],
					Object[Container],
					Object[Part],
					Object[Plumbing],
					Object[Item],
					Object[Sensor],
					Object[Wiring]
				],
				Model -> Alternatives[
					Model[Sample],
					Model[Container],
					Model[Part],
					Model[Plumbing],
					Model[Item],
					Model[Sensor],
					Model[Wiring]
				],
				SampleHistory -> Null,
				Protocol -> Alternatives[
					Object[Protocol],
					Object[Maintenance],
					Object[Qualification],
					Object[Program],
					Object[UnitOperation]
				]
			},
			Description -> "Sample history information for resources used in this experiment.",
 			Category -> "Organizational Information"
		},
		
		EnvironmentalLifecycle -> {
			Format -> Multiple,
			Class -> {
				FieldName -> Expression,
				Sample -> Link,
				Model -> Link,
				TemperatureLifecycle -> Link,
				Protocol -> Link
			},
			Pattern :> {
				FieldName -> _Symbol,
				Sample -> _Link,
				Model -> _Link,
				TemperatureLifecycle -> _Link,
				Protocol -> _Link
			},
			Relation -> {
				FieldName -> Null,
				Sample -> Alternatives[
					Object[Sample],
					Object[Container],
					Object[Part],
					Object[Plumbing],
					Object[Item],
					Object[Sensor],
					Object[Wiring]
				],
				Model -> Alternatives[
					Model[Sample],
					Model[Container],
					Model[Part],
					Model[Plumbing],
					Model[Item],
					Model[Sensor],
					Model[Wiring]
				],
				TemperatureLifecycle -> Object[Data,Temperature],
				Protocol -> Alternatives[
					Object[Protocol],
					Object[Maintenance],
					Object[Qualification],
					Object[Program],
					Object[UnitOperation]
				]
			},
			Description -> "Environmental information for resources used in this experiment.",
 			Category -> "Organizational Information"
		},

		(* --- "Training Check" Category --- *)

		LaboratoryTraining -> {
			Format -> Multiple,
			Class -> {
				Operator -> Link,
				Date -> Date,
				TrainingType -> Expression,
				TrainingResult -> Expression,
				Witness -> Link
			},
			Pattern :> {
				Operator -> _Link,
				Date -> _DateObject,
				TrainingType -> LabTechniqueTrainingP,
				TrainingResult -> Pass|Fail,
				Witness -> _Link
			},
			Relation -> {
				Operator -> Object[User],
				Date -> Null,
				TrainingType -> Null,
				TrainingResult -> Null,
				Witness -> Object[User]
			},
			Description -> "Laboratory operator training information for operators used in this experiment.",
 			Category -> "Organizational Information"
		},
		
		PriorOperatorQualifications -> {
			Format -> Multiple,
			Class -> {
				Operator -> Link,
				QualificationDate -> Date,
				Qualification -> Link,
				QualificationResult -> Expression
			},
			Pattern :> {
				Operator -> _Link,
				QualificationDate -> _DateObject,
				Qualification -> _Link,
				QualificationResult -> QualificationResultP
			},
			Relation -> {
				Operator -> Object[User],
				QualificationDate -> Null,
				Qualification -> Object[User],
				QualificationResult ->Null
			},
			Description -> "Laboratory operator qualification information for qualifications executed before this experiment.",
 			Category -> "Organizational Information"
		},
		
		SubsequentOperatorQualifications -> {
			Format -> Multiple,
			Class -> {
				Operator -> Link,
				QualificationDate -> Date,
				Qualification -> Link,
				QualificationResult -> Expression
			},
			Pattern :> {
				Operator -> _Link,
				QualificationDate -> _DateObject,
				Qualification -> _Link,
				QualificationResult -> QualificationResultP
			},
			Relation -> {
				Operator -> Object[User],
				QualificationDate -> Null,
				Qualification -> Object[User],
				QualificationResult ->Null
			},
			Description -> "Laboratory operator qualification information for qualifications executed after this experiment.",
 			Category -> "Organizational Information"
		},


		(* --- "Protocol Execution Check" Category --- *)
		
		TransferCheck -> {
			Format -> Multiple,
			Class -> {
				Protocol -> Link,
				Primitive -> Expression,
				UnitOperation -> Link,
				SourceSampleField -> Expression,
				SourceProtocol -> Link,
				SourceSample -> Link,
				SourceSampleModel -> Link,
				DestinationSampleField -> Expression,
				DestinationProtocol -> Link,
				DestinationSample -> Link,
				DestinationSampleModel -> Link,
				NominalAmount -> Expression,
				SourceInitialAmountDetermination -> Expression,
				SourceInitialAmount -> Expression,
				SourceCalculatedInitialAmount -> Expression,
				DestinationInitialAmountDetermination -> Expression,
				DestinationInitialAmount -> Expression,
				DestinationCalculatedInitialAmount -> Expression,
				TransferAmount -> Expression,
				PercentTransferred -> Expression,
				SourceFinalAmount -> Expression,
				DestinationFinalAmount -> Expression,
				AspirationPressure -> Expression,
				DispensePressure -> Expression,
				PipettingMethod -> Link
			},
			Pattern :> {
				Protocol -> _Link,
				Primitive -> _Transfer,
				UnitOperation -> _Link,
				SourceSampleField -> _Symbol,
				SourceProtocol -> _Link,
				SourceSample -> _Link,
				SourceSampleModel -> _Link, 
				DestinationSampleField -> _Symbol,
				DestinationProtocol -> _Link,
				DestinationSample -> _Link,
				DestinationSampleModel -> _Link,
				NominalAmount -> MassP|VolumeP|_Integer,
				SourceInitialAmountDetermination -> VolumeMeasurementTypeP | InitialManufacturerAmount,
				SourceInitialAmount -> MassP|VolumeP|_Integer,
				SourceCalculatedInitialAmount -> MassP|VolumeP|_Integer,
				DestinationInitialAmountDetermination -> VolumeMeasurementTypeP | InitialManufacturerAmount,
				DestinationInitialAmount -> MassP|VolumeP|_Integer,
				DestinationCalculatedInitialAmount -> MassP|VolumeP|_Integer,
				TransferAmount -> MassP|VolumeP|_Integer,
				PercentTransferred -> PercentP,
				SourceFinalAmount -> MassP|VolumeP|_Integer,
				DestinationFinalAmount -> MassP|VolumeP|_Integer,
				AspirationPressure -> QuantityCoordinatesP[{Millisecond, Pascal}],
				DispensePressure -> QuantityCoordinatesP[{Millisecond, Pascal}],
				PipettingMethod -> _Link
			},
			Relation -> {
				Protocol -> Object[Protocol,ManualSamplePreparation]|Object[Protocol,RoboticSamplePreparation]|Object[Protocol,SampleManipulation],
				Primitive -> Null,
				UnitOperation -> Object[UnitOperation],
				SourceSampleField -> Null,
				SourceProtocol -> Alternatives[
					Object[Protocol],
					Object[Maintenance],
					Object[Qualification],
					Object[Program],
					Object[UnitOperation]
				],
				SourceSample -> Object[Sample],
				SourceSampleModel -> Model[Sample],
				DestinationSampleField -> Null,
				DestinationProtocol -> Alternatives[
					Object[Protocol],
					Object[Maintenance],
					Object[Qualification],
					Object[Program],
					Object[UnitOperation]
				],
				DestinationSample -> Object[Sample],
				DestinationSampleModel -> Model[Sample],
				NominalAmount -> Null,
				SourceInitialAmountDetermination -> Null,
				SourceInitialAmount -> Null,
				SourceCalculatedInitialAmount -> Null,
				DestinationInitialAmountDetermination -> Null,
				DestinationInitialAmount -> Null,
				DestinationCalculatedInitialAmount -> Null,
				TransferAmount -> Null,
				PercentTransferred -> Null,
				SourceFinalAmount -> Null,
				DestinationFinalAmount -> Null,
				AspirationPressure -> Null,
				DispensePressure -> Null,
				PipettingMethod -> Model[Method, Pipetting]
			},
			Description -> "Transfer information for any aspirations and dispenses done during this protocol.",
 			Category -> "Organizational Information"
		}
	}
}];
