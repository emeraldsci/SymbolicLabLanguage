(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Sensor], {
	Description->"A device used to interrogate the state of a sample or the surrounding environment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the sensor.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		CurrentProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][Resources],
				Object[Maintenance][Resources],
				Object[Qualification][Resources]
			],
			Description -> "The experiment, maintenance, or qualification that is currently using this sensor.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		CurrentSubprotocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol],
				Object[Maintenance],
				Object[Qualification]
			],
			Description -> "The specific protocol or subprotocol that is currently using this sensor.",
			Category -> "Organizational Information",
			Developer -> True
		},
		ModelName -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Name]],
			Pattern :> _String,
			Description -> "The name of model of sensor that defines this sensor.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SensorStatusP,
			Description -> "The currnet status of the sensor.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Missing -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object was not found at its database listed location and that troubleshooting will be required to locate it.",
			Category -> "Organizational Information",
			Developer -> True
		},
		DateMissing->{
			Format->Single,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"Date the sample was set Missing.",
			Category->"Organizational Information"
		},
		MissingLog->{
			Format->Multiple,
			Class->{Date, Boolean, Link},
			Pattern:>{_?DateObjectQ, BooleanP, _Link},
			Relation->{Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description->"A log of changes made to this sample's Missing status.",
			Headers->{"Date", "Restricted", "Responsible Party"},
			Category->"Organizational Information"
		},
		DateStocked -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the sensor was received and stocked in inventory.",
			Category -> "Organizational Information"
		},
		DateUnsealed -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the packaging on the sensor was first opened in the lab.",
			Category -> "Organizational Information"
		},
		DatePurchased -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description ->  "Date ownership of this sensor was transferred to the user.",
			Category -> "Inventory"
		},
		DateLastUsed -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date this sensor was last handled in any way.",
			Category -> "Inventory"
		},
		DateInstalled -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the sensor was installed on site.",
			Category -> "Organizational Information"
		},
		DateDiscarded -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the sensor was shut down and removed from use on site.",
			Category -> "Organizational Information"
		},
		ExpirationDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date by which the sensor should be replaced.",
			Category -> "Organizational Information"
		},
		Expires -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this sensor expires after a given amount of time.",
			Category -> "Storage Information",
			Abstract -> True
		},
		ShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateCreated this sensor is recommended for use before it should be discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		UnsealedShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateUnsealed this sensor is recommended for use before it should be discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		StatusLog -> {
			Format -> Multiple,
			Class -> {Expression, Expression, Link},
			Pattern :> {_?DateObjectQ, SensorStatusP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to the sensor's status.",
			Category -> "Organizational Information",
			Headers -> {"Date", "Status Change Type", "Person Responsible for Change"},
			Developer -> True
		},
		Restricted -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this sensor must be specified directly in order to be used in experiments or if instead it can be used by any experiments that request a model matching this sensor's model.",
			Category -> "Organizational Information"
		},
		RestrictedLog -> {
			Format -> Multiple,
			Class -> {Date, Boolean, Link},
			Pattern :> {_?DateObjectQ, BooleanP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to this sensor's restricted status.",
			Headers -> {"Date", "Restricted", "Responsible Party"},
			Category -> "Organizational Information"
		},
		ImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A photo of this sensor.",
			Category -> "Organizational Information"
		},
		UserManualFiles -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],UserManualFiles]],
			Pattern :> PDFFileP,
			Description -> "PDFs for the manuals or instruction guides for this model of sensor.",
			Category -> "Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		GMPQualified -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this object currently meets the requirements for Good Manufacturing Practices.",
			Category -> "Organizational Information",
			Developer -> True
		},

		(* --- Quality Assurance --- *)
		Certificates -> {
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Report, Certificate, Calibration][SensorCertified],
			Description->"The quality assurance documentation and data for this sensor.",
			Category->"Quality Assurance"
		},

		(* --- Sensor Information --- *)
		DevicesMonitored -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument][EnvironmentalSensors],
				Object[Container][EnvironmentalSensors],
				Object[Container, Site][NitrogenPressureSensor],
				Object[Container, Site][ArgonPressureSensor],
				Object[Container, Site][CarbonDioxidePressureSensor],
				Object[Instrument, LiquidLevelDetector][VolumeSensor],
				Object[Instrument, Balance][WeightSensor],
				Object[Instrument][WasteScale],
				Object[Instrument, DNASynthesizer][PrimaryWashSolutionScale],
				Object[Instrument, DNASynthesizer][SecondaryWashSolutionScale],
				Object[Instrument, DNASynthesizer][DeblockSolutionScale],
				Object[Instrument, DNASynthesizer][ArgonPressureSensor],
				Object[Instrument, DNASynthesizer][ChamberPressureSensor],
				Object[Instrument, DNASynthesizer][PurgePressureSensor],
				Object[Instrument, DNASynthesizer][AmiditeAndACNPressureSensor],
				Object[Instrument, DNASynthesizer][CapAndActivatorPressureSensor],
				Object[Instrument, DNASynthesizer][DeblockAndOxidizerPressureSensor],
				Object[Instrument, DissolutionApparatus][HeliumDeliveryPressureSensor],
				Object[Instrument, LiquidHandler][WashSolutionScale],
				Object[Instrument, LiquidHandler][PurgePressureSensor],
				Object[Instrument, LiquidHandler][OrganicWashSolutionScale],
				Object[Instrument, LiquidHandler][AqueousWashSolutionScale],
				Object[Instrument, PeptideSynthesizer][SecondaryWasteScale],
				Object[Instrument, PeptideSynthesizer][PurgePressureSensor],
				Object[Instrument, HeatBlock][TemperatureSensor],
				Object[Instrument, VerticalLift][TemperatureSensor],
				Object[Instrument, pHMeter][pHSensor],
				Object[Instrument, Sonicator][TemperatureSensor],
				Object[Instrument, Evaporator][TemperatureSensor],
				Object[Instrument, DistanceGauge][DistanceSensor],
				Object[Instrument][ArgonPressureSensor],
				Object[Instrument][CO2PressureSensor],
				Object[Instrument][NitrogenPressureSensor],
				Object[Instrument, Spectrophotometer][PurgePressureSensor],
				Object[Container, GasCylinder][PressureSensor],
				Object[Container, GasCylinder][LiquidLevelSensor],
				Object[Container, WasteBin][WasteScale],
				Object[Part, DispensingHead][VolumeSensor],
				Object[Instrument][HeliumPressureSensor],
				Object[Instrument, SchlenkLine][ChannelAGasPressureSensor],
				Object[Instrument, SchlenkLine][ChannelBGasPressureSensor],
				Object[Instrument, SchlenkLine][ChannelCGasPressureSensor],
				Object[Instrument, SchlenkLine][ChannelDGasPressureSensor],
				Object[Instrument, SchlenkLine][VacuumSensor],
				Object[Instrument, ControlledRateFreezer][TemperatureSensor],
				Object[Instrument, SampleInspector][TemperatureSensor],
				Object[Instrument, SampleInspector][LightSensor],
				Object[Instrument, SampleInspector][LightSensor],
				Object[Instrument, GloveBox][AntechamberSensors, 2],
				Object[Instrument, HandlingStation, GloveBox][AntechamberSensors, 2],
				Object[Instrument, GasChromatograph][HeliumTankPressureSensor],
				Object[Instrument, GasChromatograph][HeliumDeliveryPressureSensor],
				Object[Instrument, GasChromatograph][MethaneTankPressureSensor],
				Object[Instrument, GasChromatograph][MethaneDeliveryPressureSensor],
				Object[Instrument, GasChromatograph][AirPressureSensor],
				Object[Instrument, GasChromatograph][HydrogenPressureSensor],
				Object[Instrument, GasFlowSwitch][LeftInletPressureSensor],
				Object[Instrument, GasFlowSwitch][RightInletPressureSensor],
				Object[Instrument, GasFlowSwitch][OutletPressureSensor],
				Object[Instrument, Lyophilizer][BackfillGasPressureSensor],
				Object[Instrument, Lyophilizer][StopperingGasPressureSensor],
				Object[Instrument, MassSpectrometer][CollisionCellGasTankPressureSensor],
				Object[Instrument, MassSpectrometer][CollisionCellGasDeliveryPressureSensor],
				Object[Instrument, Spectrophotometer][PurgeGasTankPressureSensor],
				Object[Instrument, Spectrophotometer][PurgeGasDeliveryPressureSensor],
				Object[Instrument, PortableCooler][TemperatureSensor],
				Object[Instrument, KarlFischerTitrator][KarlFischerReagentWeightSensor],
				Object[Instrument, KarlFischerTitrator][MediumWeightSensor],
				Object[Instrument, PortableCooler][TemperatureSensor]
			],
			Description -> "All instruments and/or sensors that are being directly monitored by this sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		PowerInput -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PowerInput]],
			Pattern :> DirectCurrentP,
			Description -> "Describes the source of power for the sensor.",
			Category -> "Sensor Information"
		},
		SensorLogType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SensorLogTypeP,
			Description -> "The type of data log to which this sensor outputs data.",
			Category -> "Sensor Information"
		},
		SensorOutputSignal -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],SensorOutputSignal]],
			Pattern :> SensorOutputTypeP,
			Description -> "The type of signal with which the sensor outputs measurement data.",
			Category -> "Sensor Information"
		},
		PLCVariableName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the variable that refers to this sensor on the PLC that controls the sensor.",
			Category -> "Sensor Information"
		},
		IP -> {
			Format -> Single,
			Class -> String,
			Pattern :> IpP,
			Description -> "The IP of the sensor itself on the network.",
			Category -> "Sensor Information"
		},
		EmbeddedPC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, EmbeddedPC][ConnectedDevices],
			Description -> "Which Sensornet Ethernet PC is the device connected to.",
			Category -> "Sensor Information"
		},
		PLCVariableType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PLCVariableType]],
			Pattern :> PLCVariableTypeP,
			Description -> "The type of variable used to represent this sensor on the PLC that controls the sensor.",
			Category -> "Sensor Information"
		},
		ArchivedDaily -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Whether or not the sensor data is archived daily.",
			Category -> "Sensor Information"
		},
		LatestFitFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function,
			Description -> "Fit function that calculates the sensor output as a function of raw input.",
			Category -> "Sensor Information"
		},
		Dimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Dimensions]],
			Pattern :> {GreaterP[0*Meter], GreaterP[0*Meter], GreaterP[0*Meter]},
			Description -> "The external dimensions of this sensor, in the form: {DimensionX, DimensionY, DimensionZ}.",
			Category -> "Dimensions & Positions"
		},
		CrossSectionalShape -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CrossSectionalShape]],
			Pattern :> CrossSectionalShapeP,
			Description -> "The shape of this sensor in the X-Y plane.",
			Category -> "Dimensions & Positions"
		},
		Container -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container][Contents, 2],
				Object[Instrument][Contents, 2]
			],
			Description -> "The container which houses this sensor.",
			Category -> "Dimensions & Positions"
		},
		Position -> {
			Format -> Single,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "The name of the position this sensor occupies in its nearest Container.",
			Category -> "Dimensions & Positions"
		},
		Site -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The ECL site at which this sensor currently resides.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		SiteLog->{
			Format->Multiple,
			Headers->{"Date", "Site", "Responsible Party"},
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Object[Container,Site], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description->"The site history of the sensor.",
			Category->"Container Information"
		},
		ResourcePickingGrouping -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Object[Instrument]
			],
			Description->"The parent container of this object which can be used to give the object's approximate location and to see show its proximity to other objects which may be resource picked at the same time or in use by the same protocol.",
			Category->"Container Specifications"
		},
		Qualifications -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Qualification][Sensors],
				Object[Qualification][Target]
			],
			Description -> "The Qualification(s) this sensor is involved with.",
			Category -> "Qualifications & Maintenance"
		},
		QualificationLog -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Qualification], Model[Qualification]},
			Description -> "List of all the Qualifications that target this sensor and are not an unlisted protocol.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Date Run", "Qualification Object", "Qualification Object Model"},
			Developer -> True
		},
		QualificationFrequency -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Computables`Private`qualificationFrequency[Field[Model]]],
			Pattern :> {{ObjectReferenceP[Model[Qualification]], GreaterP[0*Day]}..},
			Description -> "A list of the Qualifications which should be run on this sensor and their required frequencies.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Model Qualification Object", "Time"}
		},
		RecentQualifications -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Qualification], Model[Qualification]},
			Description -> "List of the most recent Qualifications run on this sensor for each model Qualification in QualificationFrequency .",
			Category -> "Qualifications & Maintenance",
			Abstract -> True,
			Headers ->  {"Date Completed", "Qualification Object", "Qualification Model Object"}
		},
		NextQualificationDate -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, _?DateObjectQ},
			Relation -> {Model[Qualification], Null},
			Description -> "A list of the dates on which the next qualifications will be enqueued for this sensor.",
			Headers -> {"Qualification Model", "Date"},
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		Qualified -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this sensor has passed its most recent qualification.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		QualificationResultsLog -> {
			Format -> Multiple,
			Class -> {
				Date -> Date,
				Qualification -> Link,
				Result -> Expression
			},
			Pattern :> {
				Date -> _?DateObjectQ,
				Qualification -> _Link,
				Result -> QualificationResultP
			},
			Relation -> {
				Date -> Null,
				Qualification -> Object[Qualification],
				Result -> Null
			},
			Headers -> {
				Date -> "Date Evaluated",
				Qualification -> "Qualification",
				Result -> "Result"
			},
			Description -> "A record of the qualifications run on this sensor and their results.",
			Category -> "Qualifications & Maintenance"
		},
		QualificationExtensionLog -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression, Link, Expression, String},
			Pattern :> {_Link, _?DateObjectQ, _?DateObjectQ, _Link, QualificationExtensionCategoryP, _String},
			Relation -> {Model[Qualification], Null, Null, Object[User], Null, Null},
			Description -> "A list of amendments made to the regular qualification schedule of this sensor, and the reason for the deviation.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Qualification Model", "Original Due Date","Revised Due Date","Responsible Party","Extension Category","Extension Reason"}
		},
		Receiving -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance, ReceiveInventory][Items],
			Description -> "The MaintenanceReceiveInventory in which this sensor was received.",
			Category -> "Inventory"
		},
		Maintenance -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance][Target],
			Description -> "A list of all the maintenances that have used this sensor or were performed on this sensor.",
			Category -> "Qualifications & Maintenance"
		},
		Calibration -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration, Sensor][Target],
			Description -> "A list of all the calibrations that have used this sensor or were performed on this sensor.",
			Category -> "Qualifications & Maintenance"
		},
		MaintenanceLog -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Maintenance], Model[Maintenance]},
			Description -> "List of all the maintenances that target this sensor and are not an unlisted protocol.",
			Category -> "Qualifications & Maintenance",
			Headers ->  {"Date Run", "Maintenance Object", "Maintenance Object Model"}
		},
		MaintenanceFrequency -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Computables`Private`maintenanceFrequency[Field[Model]]],
			Pattern :> {{ObjectReferenceP[Model[Maintenance]], GreaterP[0*Day] | Null}..},
			Description -> "A list of the maintenances which are run on this sensor and their required frequencies.",
			Category -> "Qualifications & Maintenance",
			Headers ->  {"Model Maintenance Object", "Time"}
		},
		RecentMaintenance -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Maintenance], Model[Maintenance]},
			Description -> "List of the most recent maintenances run on this sensor for each modelMaintenance in MaintenanceFrequency.",
			Category -> "Qualifications & Maintenance",
			Abstract -> True,
			Headers -> {"Date","Maintenance","Maintenance Model"}
		},
		NextMaintenanceDate -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, _?DateObjectQ},
			Relation -> {Model[Maintenance], Null},
			Description -> "A list of the dates on which the next maintenance runs will be enqueued for this sensor.",
			Headers -> {"Maintenance Model", "Date"},
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		MaintenanceExtensionLog -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression, Link, Expression, String},
			Pattern :> {_Link, _?DateObjectQ, _?DateObjectQ, _Link, MaintenanceExtensionCategoryP, _String},
			Relation -> {Model[Maintenance], Null, Null, Object[User], Null, Null},
			Description -> "A list of amendments made to the regular maintenance schedule of this sensor, and the reason for the deviation.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Maintenance Model", "Original Due Date","Revised Due Date","Responsible Party","Extension Category","Extension Reason"}
		},
		Manufacturer -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Manufacturer]],
			Pattern :> ObjectReferenceP[Object[Company, Supplier]],
			Description -> "The company that manufactured the sensor.",
			Category -> "Inventory",
			Abstract -> True
		},
		SerialNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The manufacturer's serial number for this particular sensor.",
			Category -> "Inventory"
		},
		BatchNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Manufacturer batch the sensor belongs to.",
			Category -> "Inventory"
		},
		Method -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Method]],
			Pattern :> MeasurementMethodP,
			Description -> "Describes what is initially measured by this sensor (before any processing).",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Data -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Sensor],
			Description -> "All data obtained using this sensor.",
			Category -> "Sensor Information"
		},
		Product -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][Samples],
			Description -> "The product employed by this sensor.",
			Category -> "Inventory"
		},
		Order -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Transaction, Order],
				Object[Transaction, DropShipping]
			],
			Description -> "Order that this sensor was generated from.",
			Category -> "Inventory"
		},
		Source -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Transaction],
				Object[Protocol],
				Object[Protocol][PurchasedItems],
				Object[Qualification],
				Object[Qualification][PurchasedItems],
				Object[Maintenance],
				Object[Maintenance][PurchasedItems]
			],
			Description -> "The transaction or protocol that is responsible for generating this sensor.",
			Category -> "Inventory"
		},
		KitComponents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample][KitComponents],
				Object[Item][KitComponents],
				Object[Container][KitComponents],
				Object[Part][KitComponents],
				Object[Plumbing][KitComponents],
				Object[Wiring][KitComponents],
				Object[Sensor][KitComponents]
			],
			Description -> "All other samples that were received as part of the same kit as this sensor.",
			Category -> "Inventory"
		},
		(* --- Storage --- *)
		StorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The conditions under which this sensor should be kept when not in use by an experiment.",
			Category -> "Storage Information"
		},
		StorageConditionLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Model[StorageCondition], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "A record of changes made to the conditions under which this sensor should be kept when not in use by an experiment.",
			Headers -> {"Date","Condition","Responsible Party"},
			Category -> "Storage Information"
		},
		StorageSchedule -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Model[StorageCondition], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "The planned storage condition changes to be performed.",
			Headers -> {"Date", "Condition", "Responsible Party"},
			Category -> "Storage Information"
		},
		AwaitingStorageUpdate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this sensor has been scheduled for movement to a new storage condition.",
			Category -> "Storage Information",
			Developer -> True
		},
		AwaitingDisposal -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this sensor is marked for disposal once it is no longer required for any outstanding experiments.",
			Category -> "Storage Information"
		},
		DisposalLog -> {
			Format -> Multiple,
			Class -> {Expression, Boolean, Link},
			Pattern :> {_?DateObjectQ, BooleanP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to when this sensor is marked as awaiting disposal by the AwaitingDisposal Boolean.",
			Headers -> {"Date","Awaiting Disposal","Responsible Party"},
			Category -> "Storage Information"
		},
		StoragePositions->{
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, LocationPositionP},
			Relation -> {Object[Container]|Object[Instrument], Null},
			Description -> "The specific containers and positions in which this container is to be stored, allowing more granular organization within storage locations for this sensor's storage condition.",
			Category -> "Storage Information",
			Headers->{"Storage Container", "Storage Position"},
			Developer -> True
		},
		LocationLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link, String, Link},
			Pattern :> {_?DateObjectQ, In | Out, _Link, _String, _Link},
			Relation -> {
				Null,
				Null,
				Object[Container][ContentsLog, 3] | Object[Instrument][ContentsLog, 3],
				Null,
				Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "The location history of the part. Lines recording a movement to container and position of Null, Null respectively indicate the item being discarded.",
			Category -> "Storage Information",
			Headers ->  {"Date","In or Out","Container moved into or out of","Position moved into or out Of", "Person who moved the part"}
		},
		(* --- Resources --- *)
		RequestedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource, Sample][RequestedSample],
			Description -> "The list of resource requests for this sensor that have not yet been Fulfilled.",
			Category -> "Resources",
			Developer -> True
		},
		(* --- Migration Support --- *)
		NewStickerPrinted -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a new sticker with a hashphrase has been printed for this object and therefore the hashphrase should be shown in engine when scanning the object.",
			Category -> "Migration Support",
			Developer -> True
		},
		LegacyID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The SLL2 ID for this Object, if it was migrated from the old data store.",
			Category -> "Migration Support",
			Developer -> True
		},
		(* --- Sensor Monitoring --- *)
		AlertActive -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if routine monitoring of the readings from this sensor generates alerts in Asana.",
			Category -> "Sensor Monitoring",
			Developer -> True
		},
		LastAlertDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date and time at which the last alert was generated because the sensor reading was out of range.",
			Category -> "Sensor Monitoring",
			Developer -> True
		},
		MaxAlertFrequency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units :> Hour,
			Description -> "The minimum period of time allowed between creation of sequential alerts based on sensor reading in Asana.",
			Category -> "Sensor Monitoring",
			Developer -> True
		},
		GradientAlertActive -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if routine monitoring of the rate of change of readings from this sensor generates alerts in Asana.",
			Category -> "Sensor Monitoring",
			Developer -> True
		},
		LastGradientAlertDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date and time at which the last alert was generated because the sensor's rate of change of readings was out of range.",
			Category -> "Sensor Monitoring",
			Developer -> True
		},
		MaxGradientAlertFrequency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units :> Hour,
			Description -> "The minimum period of time allowed between creation of sequential alerts based on sensor rate of change in Asana.",
			Category -> "Sensor Monitoring",
			Developer -> True
		}
	}
}];
