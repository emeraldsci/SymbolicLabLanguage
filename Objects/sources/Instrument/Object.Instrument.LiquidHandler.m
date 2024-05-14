(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, LiquidHandler], {
	Description->"Robotic liquid handler used for sample manipulation.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		TipType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TipType]],
			Pattern :> LiquidHandlerTipTypeP,
			Description -> "The type of tip used by the liquid handler. Options include: DisposableTip or FixedTip.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LiquidHandlerType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LiquidHandlerType]],
			Pattern :> LiquidHandlerTipTypeP,
			Description -> "The type of function that this liquid handler is capable of performing.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Scale -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Scale]],
			Pattern :> LiquidHandlingScaleP,
			Description -> "The volume range at which dispensing is being performed with this liquid handler (volume greater than 2ml is defined as Macro).",
			Category -> "Instrument Specifications"
		},
		TubingType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingType]],
			Pattern :> PlasticP,
			Description -> "Material the system tubing is composed of.",
			Category -> "Instrument Specifications"
		},
		SyringeVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],SyringeVolume]],
			Pattern :> GreaterP[0*Liter],
			Description -> "The capacity of the syringe pump used to dispense the fluid.",
			Category -> "Instrument Specifications"
		},
		TransferLoopVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Liter],
			Units->Milliliter,
			Description->"The capacity of the tubing which contains the fluid being transferred between the aspiration and dispense steps of the syringe pump cycle.",
			Category->"Instrument Specifications"
		},
		PrimeVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PrimeVolume]],
			Pattern :> GreaterP[0*Liter],
			Description -> "The amount of liquid needed to fill the liquid handler's lines prior to its use.",
			Category -> "Instrument Specifications"
		},
		LogFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "File path on network where Log files are stored.",
			Category -> "Instrument Specifications"
		},
		WashLineVessel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The vessel used to store the wash line when the instrument is not in use.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		NitrogenPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],NitrogenPressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The pressure of the nitrogen gas used for pressure pushing samples.",
			Category -> "Operating Limits"
		},
		MinFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinFlowRate]],
			Pattern :> GreaterP[(0*Liter)/Minute],
			Description -> "The minimum flow rate of tips when aspirating or dispensing.",
			Category -> "Operating Limits"
		},
		MaxFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxFlowRate]],
			Pattern :> GreaterP[(0*Liter)/Minute],
			Description -> "The maximum flow rate of the tips when aspirating or dispensing.",
			Category -> "Operating Limits"
		},
		MinVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinVolume]],
			Pattern :> GreaterP[0*Liter],
			Description -> "The minimum volume that the liquid handler can transfer accurately.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxVolume]],
			Pattern :> GreaterP[0*Liter],
			Description -> "The maximum volume that the liquid handler can transfer.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxHeight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxHeight]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Maximum allowed height from the deck to the traverse height of the probe (with tip) to avoid any collision.",
			Category -> "Operating Limits"
		},
		OffDeckShelves -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, ShelvingUnit],
			Description -> "The off deck shelves that can hold additional tip boxes or plates that can't fit onto the deck. When additional tips or plates are required, the HMotion arm will transport the tip box/plate onto the deck. The shelves in this field should be in the order of shelf 1-5 where shelf 5 is the closest to the liquid handling deck and shelf 1 is the furthest away from the deck.",
			Category -> "Integrations"
		},
		IntegratedCentrifuge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, Centrifuge][IntegratedLiquidHandler],
			Description -> "The centrifuge that is connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedExternalRobotArm -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, RobotArm][IntegratedLiquidHandler],
			Description -> "The robot arm that is capable of picking up or placing samples onto the deck of this liquid handler.",
			Category -> "Integrations"
		},
		IntegratedIncubator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, Incubator][IntegratedLiquidHandler],
			Description -> "The incubator that is connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedPressureManifold  -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, PressureManifold][IntegratedLiquidHandler],
			Description -> "The filtration device that is connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedShakers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, Shaker][IntegratedLiquidHandler],
			Description -> "The shakers that are connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedHeatBlocks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, HeatBlock][IntegratedLiquidHandler],
			Description -> "The heat blocks that are connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedPlateTilters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, PlateTilter][IntegratedLiquidHandler],
			Description -> "The plate tilters that are connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedPlateSealer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, PlateSealer][IntegratedLiquidHandler],
			Description -> "The plate seal that are connected to this liquid handler such that SBS microplate may be sealed robotically.",
			Category -> "Integrations"
		},
		IntegratedClearPlateSealMagazine -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, PlateSealMagazine][IntegratedLiquidHandler],
			Description -> "The plate sealer magazines loaded or to load optically clear plate seals that are connected to this liquid handler.",
			Category -> "Integrations"
		},
		IntegratedClearMagazineParkPosition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, MagazineParkPosition][IntegratedLiquidHandler],
			Description -> "The park positions for plate sealer magazines loaded or to load optically clear plate seals that are connected to this liquid handler.",
			Category -> "Integrations"
		},
		IntegratedFoilPlateSealMagazine -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, PlateSealMagazine][IntegratedLiquidHandler],
			Description -> "The plate sealer magazines loaded or to load aluminum plate seals that are connected to this liquid handler.",
			Category -> "Integrations"
		},
		IntegratedFoilMagazineParkPosition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, MagazineParkPosition][IntegratedLiquidHandler],
			Description -> "The park positions for plate sealer magazines loaded or to load aluminum plate seals that are connected to this liquid handler.",
			Category -> "Integrations"
		},
		IntegratedElectroporator->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, Electroporator][IntegratedLiquidHandler],
			Description -> "The electroporators that are connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedThermocyclers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, Thermocycler][IntegratedLiquidHandler],
			Description -> "The thermocyclers that are connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedMicroscopes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, Microscope][IntegratedLiquidHandler],
			Description -> "The microscopes that are connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedLiquidLevelDetector -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidLevelDetector][IntegratedLiquidHandler],
			Description -> "The liquid level detector that is connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedPlateReader -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, PlateReader][IntegratedLiquidHandler],
			Description -> "The plate reader that is connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedNephelometer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, Nephelometer][IntegratedLiquidHandler],
			Description -> "The nephelometer that is connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedPlateWasher -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, PlateWasher][IntegratedLiquidHandler],
			Description -> "The plate washer that is connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedUVLamps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Lamp][IntegratedLiquidHandler],
			Description -> "The UV lamp that is connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedHEPAFilters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, FanFilterUnit][IntegratedLiquidHandler],
			Description -> "The UV lamp that is connected to this liquid handler such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedMassSpectrometer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, MassSpectrometer][IntegratedLiquidHandler],
			Description -> "The mass spectrometer that uses this liquid handler to function as autosampler.",
			Category -> "Integrations"
		},
		(* IntegratedInstruments should contain all the integrations, like IntegratedPlateReader, IntegratedCentrifuge,... enforced by VOQ *)
		IntegratedInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "The instrument that are connected into this liquid handler such that samples may be passed between the instruments robotically.",
			Category -> "Integrations"
		},
		RecirculatingPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, RecirculatingPump][LiquidHandler],
			Description -> "The recirculating pump that is connected to this liquid handler instrument to regulate temperature of deck items.",
			Category -> "Instrument Specifications"
		},
		TubingOuterDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingOuterDiameter]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Outer diameter of the tubing that connects to the instrument.",
			Category -> "Dimensions & Positions"
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Description -> "The size of space inside the liquid handler in the form of: {X Direction (Width),Y Direction (Depth),Z Direction (Height)}.",
			Category -> "Dimensions & Positions"
		},
		CarrierPositionOffsets->{
			Format -> Multiple,
			Class -> {
				Item->Link,
				LiquidHandlerCarrierPrefix->String,
				OffsetType->String,
				Position->String,
				XOffset->Real,
				YOffset->Real,
				ZOffset->Real,
				ZRotation->Real
			},
			Pattern :> {
				Item->_Link,
				LiquidHandlerCarrierPrefix->_String,
				OffsetType->_String,
				Position->_String,
				XOffset->DistanceP,
				YOffset->DistanceP,
				ZOffset->DistanceP,
				ZRotation->RangeP[-360 AngularDegree, 0 AngularDegree]
			},
			Relation -> {
				Item->Alternatives[Model[Container, Rack],Model[Instrument]],
				LiquidHandlerCarrierPrefix->Null,
				OffsetType->Null,
				Position->Null,
				XOffset->Null,
				YOffset->Null,
				ZOffset->Null,
				ZRotation->Null
			},
			Units -> {
				Item->None,
				LiquidHandlerCarrierPrefix->None,
				OffsetType->None,
				Position->None,
				XOffset->Millimeter,
				YOffset->Millimeter,
				ZOffset->Millimeter,
				ZRotation->AngularDegree
			},
			Description -> "A set of physical adjustments for the plate/tips positions on the carriers created to account for the instrument variation. The Rotational adjustments are performed  clockwise in the plane perpendicular to the mentioned axis (in xy plane for ZRotation for example) with the rotation axis going through the middle of the A1 well.",
			Category -> "Dimensions & Positions"
		},
		WastePump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, VacuumPump][LiquidHandler],
				Object[Instrument, VacuumPump][SecondaryLiquidHandler]
			],
			Description -> "Waste pump that drains waste liquid into the carboy.",
			Category -> "Instrument Specifications"
		},
		BufferDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform which contains the liquids that are used as buffers/solvents by the instrument.",
			Category -> "Dimensions & Positions"
		},
		ReservoirDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform which contains the reservoir and storage containers that are used by the instrument.",
			Category -> "Dimensions & Positions"
		},
		WashSolutionScale -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Weight sensor used by this instrument to determine the amount of wash solution in the solvent drum.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		PurgePressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Pressure sensor used by this instrument to measure the purge pressure.",
			Category -> "Sensor Information"
		},
		AqueousWashSolutionScale-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Weight sensor used by this instrument to determine the amount of aqueous wash solution in the solvent drum.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		OrganicWashSolutionScale-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Weight sensor used by this instrument to determine the amount of organic wash solution in the solvent drum.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		EmbeddedPC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, EmbeddedPC][ConnectedDevices],
			Description -> "The CPU module used to control this liquid handler.",
			Category -> "Sensor Information"
		},
		CalibrationLog -> {
			Format -> Multiple,
			Class -> {Date, Link},
			Pattern :> {_?DateObjectQ, _Link},
			Relation ->{Null, Object[Calibration, Bufferbot][Target]},
			Description -> "A list of all the calibrations that were performed on this liquid handler.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Date", "Calibration Object"}
		},
		LabwareVerifications -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Qualification,VerifyHamiltonLabware][VerifiedLiquidHandler],
			Description -> "The qualification in which the Hamilton labware definition of this instrument is verified.",
			Category -> "Qualifications & Maintenance"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature at which the liquid handler can perform thermal incubation.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description ->"Maximum temperature at which the liquid handler can perform thermal incubation.",
			Category -> "Operating Limits"
		},
		MinStirRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinStirRate]],
			Pattern :> GreaterEqualP[0*RPM],
			Description -> "The slowest rotational speed at which the liquid handler's stirrer can operate.",
			Category -> "Operating Limits"
		},
		MaxStirRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxStirRate]],
			Pattern :> GreaterP[0*RPM],
			Description -> "The fastest rotational speed at which the liquid handler's stirrer can operate.",
			Category -> "Operating Limits"
		},
		SmallDispensingPort -> {
			Format -> Multiple,
			Class -> {Integer, Expression},
			Pattern :> {RangeP[1,5], _Link},
			Relation -> {Null, Object[Part, Fitting]},
			Units -> {None, None},
			Description -> "Dispensing port connected to the 10 ml pump of the macro liquid handler.",
			Category -> "Instrument Specifications",
			Headers -> {"Port Number", "Connected Part"}
		},
		MediumDispensingPort -> {
			Format -> Multiple,
			Class -> {Integer, Expression},
			Pattern :> {RangeP[1,6], _Link},
			Relation -> {Null, Object[Part, Fitting]},
			Units -> {None, None},
			Description -> "Dispensing port connected to the 100 ml pump of the macro liquid handler.",
			Category -> "Instrument Specifications",
			Headers -> {"Port Number", "Connected Part"}
		},
		LargeDispensingPort -> {
			Format -> Multiple,
			Class -> {Integer, Expression},
			Pattern :> {RangeP[1,6], _Link},
			Relation -> {Null, Object[Part, Fitting]},
			Units -> {None, None},
			Description -> "Dispensing port connected to the 1000 ml pump of the macro liquid handler.",
			Category -> "Instrument Specifications",
			Headers -> {"Port Number", "Connected Part"}
		},
		MediumCylinderSensorArrayAddress -> {
			Format -> Single,
			Class -> Integer,
			Pattern :>  GreaterP[0],
			Units -> None,
			Description -> "The sensor array address for communication with this instrument's 100ml cylinder.",
			Developer -> True,
			Category -> "Instrument Specifications"
		},
		LargeCylinderSensorArrayAddress -> {
			Format -> Single,
			Class -> Integer,
			Pattern :>  GreaterP[0],
			Units -> None,
			Description -> "The sensor array address for communication with this instrument's 1000ml cylinder.",
			Developer -> True,
			Category -> "Instrument Specifications"
		},
		AqueousWashSolutionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container connected to the instrument used to store the aqueous solution used to wash the lines in a macro liquid handler.",
			Category -> "Instrument Specifications"
		},
		OrganicWashSolutionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container connected to the instrument used to store the organic solution used to wash the lines in a macro liquid handler.",
			Category -> "Instrument Specifications"
		},
		AqueousWashSolutionInlets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing],
			Description -> "The tubings connecting aqueous wash solution container to the instrument to wash the lines in a macro liquid handler.",
			Category -> "Instrument Specifications"
		},
		OrganicWashSolutionInlets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing],
			Description -> "The tubings connecting organic wash solution container to the instrument to wash the lines in a macro liquid handler.",
			Category -> "Instrument Specifications"
		},
		TopLight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Lamp][ConnectedInstrument],
			Description -> "The lamp that is connected to this liquid handler instrument for illumination.",
			Category -> "Instrument Specifications"
		},
		InternalRobotArmPositionOffsets->{
			Format -> Multiple,
			Class -> {
				Name->String,
				XOffset->Real,
				YOffset->Real,
				ZOffset->Real,
				ZRotationOffset->Real
			},
			Pattern :> {
				Name->_String,
				XOffset->DistanceP,
				YOffset->DistanceP,
				ZOffset->DistanceP,
				ZRotationOffset->RangeP[-360 AngularDegree, 360 AngularDegree]

			},
			Relation -> {
				Name->Null,
				XOffset->Null,
				YOffset->Null,
				ZOffset->Null,
				ZRotationOffset->Null
			},
			Units -> {
				Name->None,
				XOffset->Millimeter,
				YOffset->Millimeter,
				ZOffset->Millimeter,
				ZRotationOffset->AngularDegree
			},
			Description ->"A set of physical adjustments for the positions of plate positions that can be reached by the internal robot arm of this liquid handler. The Rotational adjustments are performed clockwise in the plane perpendicular to the mentioned axis (in xy plane for ZRotation for example) with the rotation axis going through the middle of the A1 well.",
			Category -> "Dimensions & Positions"
		},
		ExternalRobotArmPathPositions ->{
			Format->Multiple,
			Class -> {
				Name->String,
				StartDevice->Link,
				EndDevice->Link,
				StartDeviceSlot->String,
				EndDeviceSlot->String
			},
			Pattern :> {
				Name->_String,
				StartDevice->_Link,
				EndDevice->_Link,
				StartDeviceSlot->LocationPositionP,
				EndDeviceSlot->LocationPositionP
			},
			Relation ->{
				Name->Null,
				StartDevice->Alternatives[Object[Container],Object[Instrument]],
				EndDevice->Alternatives[Object[Container],Object[Instrument]],
				StartDeviceSlot->Null,
				EndDeviceSlot->Null
			},
			Units ->{
				Name->None,
				StartDevice->None,
				EndDevice->None,
				StartDeviceSlot->None,
				EndDeviceSlot->None
			},
			Description -> "A list lookup table describing which physical positions are connected by a robot arm movement path. Name corresponds to path name in ExternalRobotArmPaths field of the model, Device and Slot corresponds to slot name and instrument or container object having the slot.",
			Category -> "Dimensions & Positions"
		},
		ExternalRobotArmWaypointOffsets->{
			Format -> Multiple,
			Class -> {
				Name->String,
				XOffset->Real,
				YOffset->Real,
				ZOffset->Real,
				ZRotationOffset->Real,
				RailPositionOffset->Real
			},
			Pattern :> {
				Name->_String,
				XOffset->DistanceP,
				YOffset->DistanceP,
				ZOffset->DistanceP,
				ZRotationOffset->RangeP[-360 AngularDegree, 360 AngularDegree],
				RailPositionOffset->DistanceP

			},
			Relation -> {
				Name->Null,
				XOffset->Null,
				YOffset->Null,
				ZOffset->Null,
				ZRotationOffset->Null,
				RailPositionOffset->Null
			},
			Units -> {
				Name->None,
				XOffset->Millimeter,
				YOffset->Millimeter,
				ZOffset->Millimeter,
				ZRotationOffset->AngularDegree,
				RailPositionOffset->Millimeter
			},
			Description -> "A set of physical offsets for locations of plate positions that can be reached by an external robot arm associated with this liquid handler. Positions are measured from the center of the corresponding position in ExternalRobotArmWaypoints. The Rotational location is measured clockwise in the plane perpendicular to the mentioned axis (in xy plane for ZRotation for example) with the rotation axis going through the center of the plate. Rail position offset determines the adjusted position of the robot arm's vertical tower and is positive when approaching the liquid handler.",
			Category -> "Dimensions & Positions"
		},
		BufferCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "The cap used to aspirate buffer for Gilson's liquid handler.",
			Category -> "Instrument Specifications"
		}
	}
}];
