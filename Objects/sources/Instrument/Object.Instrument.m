(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument], {
	Description->"A piece of scientific instrumentation used to perform experiments on the ECL.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the instrument.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		ModelName -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Name]],
			Pattern :> _String,
			Description -> "The name of the model of instrument that defines this instrument.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		CurrentProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][CurrentInstruments],
				Object[Maintenance][CurrentInstruments],
				Object[Qualification][CurrentInstruments]
			],
			Description -> "The experiment, maintenance, or Qualification that is currently using this instrument.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> InstrumentStatusP,
			Description -> "The current status of the instrument.",
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
		StatusLog -> {
			Format -> Multiple,
			Class -> {Expression, Expression, Link},
			Pattern :> {_?DateObjectQ, InstrumentStatusP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Qualification] | Object[Maintenance] | Object[Protocol]},
			Description -> "A log of changes made to the instrument's status.",
			Headers -> {"Date","Status","Responsible Party"},
			Category -> "Organizational Information"
		},
		ImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "A photo of this instrument.",
			Category -> "Organizational Information"
		},
		UserManualFiles -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],UserManualFiles]],
			Pattern :> PDFFileP,
			Description -> "PDFs for the manuals or instruction guides for this model of instrument.",
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
		DatePurchased -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the order for the instrument was placed with the supplier.",
			Category -> "Organizational Information",
			Developer -> True
		},
		DateInstalled -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the instrument was installed on site in the ECL.",
			Category -> "Organizational Information"
		},
		DateRetired -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the instrument was shut down and removed from use on site.",
			Category -> "Organizational Information"
		},
		AlternativeModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument][AlternativeObjects],
			Developer -> True,
			Description -> "Theoretical model that this object can also be defined as in addition to the Model field.  If two instruments are almost identical save for small differences, then the Model field of these two instruments will be shared. The AlternativeModel field, however, will be populated as well with the model that completely accurately describes the instrument object if that is not what is in the Model field.",
			Category -> "Organizational Information"
		},
		LocalCacheStorage -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this object it currently in a local cache beside an instrument and not in a typical inventory storage.",
			Category -> "Storage Information"
		},
		StoragePositions->{
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, LocationPositionP},
			Relation -> {Object[Container]|Object[Instrument], Null},
			Description -> "The specific containers and positions in which this container is to be stored, allowing more granular organization within storage locations for this container's storage condition.",
			Category -> "Storage Information",
			Headers->{"Storage Container", "Storage Position"},
			Developer -> True
		},
		StorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The conditions under which this mobile instrument should be kept when not in use by an experiment.",
			Category -> "Storage Information"
		},
		StorageConditionLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Model[StorageCondition], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "A record of changes made to the conditions under which this instrument should be kept when not in use by an experiment.",
			Headers -> {"Date","Condition","Responsible Party"},
			Category -> "Storage Information"
		},

		(* --- Instrument Specifications --- *)
		PowerType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PowerType]],
			Pattern :> {PowerTypeP...},
			Description -> "The type(s) of the power source(s) used by the instrument.",
			Category -> "Instrument Specifications"
		},
		PowerConsumption -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PowerConsumption]],
			Pattern :> GreaterEqualP[0*Watt],
			Description -> "Estimated power consumption rate of the instrument.",
			Category -> "Instrument Specifications"
		},
		CO2Valve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Valve][ConnectedInstrument],
			Description -> "The gas valve that regulates the flow of carbon dioxide gas to this instrument.",
			Category -> "Instrument Specifications",
			Developer->True
		},
		NitrogenValve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Valve][ConnectedInstrument],
			Description -> "The gas valve that regulates the flow of nitrogen gas to this instrument.",
			Category -> "Instrument Specifications",
			Developer->True
		},
		ArgonValve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Valve][ConnectedInstrument],
			Description -> "The gas valve that regulates the flow of argon gas to this instrument.",
			Category -> "Instrument Specifications",
			Developer->True
		},
		HeliumValve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing,Valve][ConnectedInstrument],
			Description -> "The gas valve that regulates the flow of argon gas to this instrument.",
			Category -> "Instrument Specifications"
		},
		Computer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,Computer][Instruments],
			Description -> "Links to the computer object that drives this instrument.",
			Category -> "Instrument Specifications"
		},
		VideoCaptureComputer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,Computer][Instruments],
			Description -> "Links to the computer object that captures video for this instrument.",
			Category -> "Instrument Specifications"
		},
		OperatingSystem -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],OperatingSystem]],
			Pattern :> OperatingSystemP,
			Description -> "Operating system that the instrument's acquisition software runs on.",
			Category -> "Instrument Specifications"
		},
		(*This is being replaced with Instrument Software - will be deleted with a later update*)
		Software -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The acquisition software and version currently in use on the instrument.",
			Category -> "Instrument Specifications"
		},
		InstrumentSoftware -> {
			Format -> Multiple,
			Class -> {Expression, String},
			Pattern :> {InstrumentSoftwareP, _String},
			Description -> "The instrument-specific software that this computer has installed.",
			Category -> "Instrument Specifications",
			Headers -> {"Software Name", "Version Number"}
		},
		IP -> {
			Format -> Single,
			Class -> String,
			Pattern :> IpP,
			Description -> "The IP of the instrument itself on the network.",
			Category -> "Instrument Specifications"
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file path in $PublicPath to which the instrument directly exports any data it generates. This value overrides that specified by the model's DefaultDataFilePath.",
			Category -> "Instrument Specifications",
			Developer->True
		},
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file path in $PublicPath from which the instrument directly imports any methods it uses to run protocols. This value overrides that specified by the model's DefaultMethodFilePath.",
			Category -> "Instrument Specifications",
			Developer->True
		},
		ProgramFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file path from which the instrument directly runs any programs it uses to run methods. This value overrides that specified by the model's DefaultProgramFilePath.",
			Category -> "Instrument Specifications",
			Developer->True
		},
		PDU -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, PowerDistributionUnit][ConnectedInstruments, 1],
			Description -> "The PDU that this instrument is connected to.",
			Category -> "Instrument Specifications"
		},
		PDUIP -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDU]}, Download[Field[PDU],IP]],
			Pattern :> IpP,
			Description -> "The IP address of the PDU this instrument is connected to.",
			Category -> "Instrument Specifications"
		},
		PDUPort -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDU], Field[Object]}, Computables`Private`getPDUPort[Field[Object], Field[PDU], PDUInstrument]],
			Pattern :> PDUPortP,
			Description -> "The specific PDU port this instrument is connected to.",
			Category -> "Instrument Specifications"
		},
		WasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container connected to the instrument used to collect any liquid waste produced by the instrument during operation.",
			Category -> "Instrument Specifications"
		},
		Dongle -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Dongle]],
			Pattern :> BooleanP,
			Description -> "Indicates if the instrument requires a security dongle in the computer to run.",
			Category -> "Instrument Specifications"
		},
		MovementLock -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MovementLock]],
			Pattern :> BooleanP,
			Description -> "Indicates if the instrument has a locking position for movement around the facility or while in shipping.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		Balances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, Balance],
			Description -> "The balances that are contained within this instrument for weighing purposes.",
			Category -> "Instrument Specifications"
		},
		Weight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Weight]],
			Class -> Real,
			Pattern :> GreaterP[0 Kilo Gram],
			Units -> Kilo Gram,
			Description -> "The approximate weight of the instrument.",
			Category -> "Instrument Specifications"
		},

		(* --- Storage --- *)
		ProvidedStorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The physical conditions such as temperature and humidity this instrument provides for samples stored long term within it.",
			Category -> "Storage Information"
		},
		TopLevelStorageDestination -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the instrument can provide a different storage condition than its container.",
			Category -> "Storage Information"
		},

		(* --- Container Specifications --- *)
		Container -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container][Contents, 2],
				Object[Instrument][Contents, 2]
			],
			Description -> "The container which houses this instrument.",
			Category -> "Container Specifications"
		},
		Position -> {
			Format -> Single,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "The name of the position this instrument occupies in or on its container.",
			Category -> "Container Specifications"
		},
		Decks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "Decks of this instrument used to contain or manipulate samples.",
			Category -> "Container Specifications"
		},
		LocationLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link, String, Link},
			Pattern :> {_?DateObjectQ, In | Out, _Link, _String, _Link},
			Relation -> {Null, Null, Object[Container][ContentsLog, 3] | Object[Instrument][ContentsLog, 3], Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "The locations previously occupied by this instrument.",
			Headers -> {"Date","Change Type","Container","Position","Responsible Party"},
			Category -> "Container Specifications"
		},
		Site -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The ECL site at which this instrument currently resides.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		ResourcePickingGrouping->{
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
		Contents -> {
			Format -> Multiple,
			Class -> {Expression, Link},
			Pattern :> {LocationPositionP, _Link},
			Relation -> {Null, Object[Container][Container] | Object[Instrument][Container] | Object[Sample][Container] | Object[Sensor][Container] | Object[Part][Container] |  Object[Item][Container] | Object[Plumbing][Container] | Object[Wiring][Container]},
			Description -> "A list of everything stored in this instrument.",
			Category -> "Container Specifications",
			Headers -> {"Position","Object in Position"}
		},
		ContentsLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link, String, Link},
			Pattern :> {_?DateObjectQ, In | Out, _Link, _String, _Link},
			Relation -> {
				Null,
				Null,
				Alternatives[
					Object[Sample][LocationLog, 3],
					Object[Container][LocationLog, 3],
					Object[Instrument][LocationLog, 3],
					Object[Part][LocationLog, 3],
					Object[Item][LocationLog, 3],
					Object[Plumbing][LocationLog, 3],
					Object[Wiring][LocationLog, 3],
					Object[Sensor][LocationLog, 3]
				],
				Null,
				Alternatives[
					Object[User],
					Object[Protocol],
					Object[Qualification],
					Object[Maintenance]
				]
			},
			Description -> "The record of items moved into and out of this instrument.",
			Headers -> {"Date","Change Type","Content","Position","Responsible Party"},
			Category -> "Container Specifications"
		},
		StorageAvailability -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {LocationPositionP, _Link},
			Relation -> {None, Object[StorageAvailability][Container]},
			Description -> "The capacity to perform long-term storage in each position of this instrument.",
			Category -> "Dimensions & Positions",
			Developer -> True,
			Headers -> {"Position","Availability"}
		},
		DeckLayout -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[DeckLayout][ConfiguredInstruments],
			Description -> "The current configuration of container models in specified positions on this instrument.",
			Category -> "Dimensions & Positions"
		},
		LocalCache -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Containers located near this instrument that hold items required for standard operation.",
			Category -> "Storage Information"
		},

		(* --- Plumbing Information --- *)
		Connectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression, Real, Real, Expression},
			Pattern :> {ConnectorNameP, ConnectorP, ThreadP|GroundGlassJointSizeP|None, GreaterP[0 Inch], GreaterP[0 Inch], ConnectorGenderP|None},
			Units -> {None, None, None, Inch, Inch, None},
			Description -> "Specifications for the interfaces on this instrument that may connect to other plumbing components or instrument ports.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name", "Connector Type","Thread Type","Inner Diameter","Outer Diameter","Gender"}
		},
		Nuts -> {
			Format -> Multiple,
			Class -> {String, Link, Expression},
			Pattern :> {ConnectorNameP, _Link, ConnectorGenderP|None},
			Relation -> {Null, Object[Part,Nut][InstalledLocation], Null},
			Description -> "A list of the ferrule-compressing connector components that have been attached to the connecting ports on this instrument.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name", "Installed Nut", "Connector Gender"}
		},
		Ferrules -> {
			Format -> Multiple,
			Class -> {String, Link, Real},
			Pattern :> {ConnectorNameP, _Link, GreaterP[0*Milli*Meter]},
			Relation -> {Null, Object[Part,Ferrule][InstalledLocation], Null},
			Units -> {None, None, Milli Meter},
			Description -> "A list of the compressible sealing rings that have been attached to the connecting ports on this instrument.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name", "Installed Ferrule","Ferrule Offset"}
		},
		Connections -> {
			Format -> Multiple,
			Class -> {String, Link, String},
			Pattern :> {ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {
				Null,
				Alternatives[
					Object[Plumbing][Connections, 2],
					Object[Instrument][Connections, 2],
					Object[Part][Connections,2],
					Object[Container][Connections, 2],
					Object[Item][Connections, 2]
				],
				Null
			},
			Description -> "A list of the plumbing components to which this instrument is directly connected to allow flow of liquids/gases.",
			Headers -> {"Connector Name","Connected Object","Object Connector Name"},
			Category -> "Plumbing Information"
		},
		ConnectionLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, String, Link, String, Link},
			Pattern :> {_?DateObjectQ, Connect | Disconnect, ConnectorNameP, _Link, ConnectorNameP, _Link},
			Relation -> {
				Null,
				Null,
				Null,
				Object[Plumbing][ConnectionLog, 4] | Object[Part][ConnectionLog, 4] | Object[Item][ConnectionLog, 4] | Object[Instrument][ConnectionLog, 4] | Object[Container][ConnectionLog, 4],
				Null,
				Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]
			},
			Description -> "The plumbing connection history of this instrument's ports.",
			Headers -> {"Date","Change Type","Connector Name","Connected Object","Object Connector Name","Responsible Party"},
			Category -> "Plumbing Information"
		},
		ConnectedPlumbing -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Plumbing][ConnectedLocation],Object[Item,Cap][ConnectedLocation]],
			Description -> "All plumbing components that are most closely associated with this instrument's plumbing system.",
			Category -> "Plumbing Information"
		},
		PlumbingFittingsLog -> {
			Format -> Multiple,
			Class -> {Date, String, Expression, Link, Link, Real, Link},
			Pattern :> {_?DateObjectQ, ConnectorNameP, ConnectorGenderP|None, _Link, _Link, GreaterP[0*Milli*Meter], _Link},
			Relation -> {Null, Null, Null, Object[Part,Nut], Object[Part,Ferrule], Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Units -> {None, None, None, None, None, Milli*Meter, None},
			Description -> "The history of the connection type present at each connector on this instrument.",
			Headers -> {"Date", "Connector Name", "Connector Gender", "Installed Nut", "Installed Ferrule", "Ferrule Offset", "Responsible Party"},
			Category -> "Plumbing Information"
		},
		GasSources -> {
			Format -> Multiple,
			Class -> {Expression, Link},
			Pattern :> {GasP, _Link},
			Relation -> {
				Null,
				Object[Container][ConnectedInstruments]
			},
			Description -> "A list of containers that supply this instrument with gas through plumbing connections.",
			Headers -> {"Gas Type", "Source Container"},
			Category -> "Plumbing Information"
		},
		GasSourceLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Expression, Link, Link},
			Pattern :> {_?DateObjectQ, Connect | Disconnect, GasP, _Link, _Link},
			Relation -> {
				Null,
				Null,
				Null,
				Object[Container][ConnectedInstrumentLog,3],
				Alternatives[
					Object[User],
					Object[Protocol],
					Object[Qualification],
					Object[Maintenance]
				]
			},
			Description -> "The record of containers that supply this instrument with gas through plumbing connections.",
			Headers -> {"Date", "Change Type", "Gas Type", "Source Container", "Responsible Party"},
			Category -> "Plumbing Information"
		},

		(* --- Wiring Information --- *)
		WiringConnectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression},
			Pattern :> {WiringConnectorNameP, WiringConnectorP, ConnectorGenderP|None},
			Headers -> {"Wiring Connector Name", "Wiring Connector Type", "Gender"},
			Description -> "Specifications for the wiring interfaces of this instrument that may plug into and conductively connect to other items, parts or instruments.",
			Category -> "Wiring Information"
		},
		WiringConnections -> {
			Format -> Multiple,
			Class -> {String, Link, String},
			Pattern :> {WiringConnectorNameP, _Link, WiringConnectorNameP},
			Relation -> {
				Null,
				Alternatives[
					Object[Wiring][WiringConnections, 2],
					Object[Instrument][WiringConnections, 2],
					Object[Item][WiringConnections, 2],
					Object[Part][WiringConnections, 2],
					Object[Container][WiringConnections, 2]
				],
				Null
			},
			Headers -> {"Wiring Connector Name", "Connected Object", "Object Wiring Connector Name"},
			Description -> "A list of the wiring components to which this instrument is directly connected to allow the flow of electricity.",
			Category -> "Wiring Information"
		},
		WiringConnectionLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, String, Link, String, Link},
			Pattern :> {_?DateObjectQ, Connect|Disconnect, WiringConnectorNameP, _Link, WiringConnectorNameP, _Link},
			Relation -> {
				Null,
				Null,
				Null,
				Alternatives[
					Object[Wiring][WiringConnectionLog, 4],
					Object[Instrument][WiringConnectionLog, 4],
					Object[Item][WiringConnectionLog, 4],
					Object[Part][WiringConnectionLog, 4],
					Object[Container][WiringConnectionLog, 4]
				],
				Null,
				Alternatives[Object[User], Object[Protocol], Object[Qualification], Object[Maintenance]]
			},
			Headers -> {"Date", "Change Type", "Wiring Connector Name", "Connected Object", "Object Wiring Connector Name", "Responsible Party"},
			Description -> "The wiring connection history of this instrument.",
			Category -> "Wiring Information"
		},
		ConnectedWiring -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Wiring][ConnectedLocation],
			Description -> "All wiring components that are most closely associated with this instrument's wiring system.",
			Category -> "Wiring Information"
		},

		(* --- Compatibility --- *)
		AllowedPositions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AllowedPositions]],
			Pattern :> _Alternatives,
			Description -> "A pattern representing all the valid position names for this instrument.",
			Category -> "Compatibility"
		},


		(* --- Dimensions & Positions --- *)
		Dimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Dimensions]],
			Pattern :> {GreaterP[0*Meter], GreaterP[0*Meter], GreaterP[0*Meter]},
			Description -> "The external dimensions of this instrument.",
			Category -> "Dimensions & Positions"
		},
		CrossSectionalShape -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CrossSectionalShape]],
			Pattern :> CrossSectionalShapeP,
			Description -> "The shape of this instrument in the X-Y plane.",
			Category -> "Dimensions & Positions"
		},
		Cameras -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {_String, _Link},
			Relation -> {Null,Object[Part, Camera][MonitoredLocation]},
			Description -> "Cameras monitoring the positions on this instrument.",
			Category -> "Dimensions & Positions",
			Headers -> {"Position","Cameras monitoring each positions"}
		},
		ContainerImage2DFile -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ContainerImage2DFile]],
			Pattern :> ImageFileP,
			Description -> "A top-down (X-Y plane) image of this model of instrument which can be overlaid on a 2D container plot.",
			Category -> "Dimensions & Positions"
		},
		Shape2D -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Shape2D]],
			Pattern :> _Polygon | _Circle,
			Description -> "A Graphics primitive corresponding to the 2D shape of this instrument.",
			Category -> "Dimensions & Positions"
		},
		Shape3D -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Shape3D]],
			Pattern :> _Polygon,
			Description -> "A Graphics primitive corresponding to the 3D shape of this instrument.",
			Category -> "Dimensions & Positions"
		},

		(* --- Sensor Information --- *)
		LevelSensorType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LevelSensorTypeP,
			Description -> "The type of aspiration cap connector installed on the volume sensors of this instrument's buffer slots.",
			Category -> "Sensor Information"
		},
		ArgonPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Sensor used to monitor the pressure of the argon gas source (before any pressure reduction stage).",
			Category -> "Sensor Information"
		},
		ArgonPressureRegulators -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,PressureRegulator][ConnectedInstruments],
			Description -> "The pressure regaultor used to control argon gas flow into this instrument.",
			Category -> "Sensor Information"
		},
		CO2PressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Sensor used to monitor the pressure of the carbon dioxide gas source (before any pressure reduction stage).",
			Category -> "Sensor Information"
		},
		CO2PressureRegulators -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,PressureRegulator][ConnectedInstruments],
			Description -> "The pressure regaultor used to control CO2 gas flow into this instrument.",
			Category -> "Sensor Information"
		},
		HeliumPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Sensor used to monitor the pressure of the helium gas source (before any pressure reduction stage).",
			Category -> "Sensor Information"
		},
		HeliumPressureRegulators -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,PressureRegulator][ConnectedInstruments],
			Description -> "The pressure regaultor used to control helium gas flow into this instrument.",
			Category -> "Sensor Information"
		},
		NitrogenPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Sensor used to monitor the pressure of the nitrogen gas source (before any pressure reduction stage).",
			Category -> "Sensor Information"
		},
		NitrogenPressureRegulators -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,PressureRegulator][ConnectedInstruments],
			Description -> "The pressure regaultor used to control nitrogen gas flow into this instrument.",
			Category -> "Sensor Information"
		},
		WasteScale -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Weight sensor used by this instrument to measure the waste fill level.",
			Category -> "Sensor Information",
			Developer -> True
		},
		Development -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this instrument is in the process of being brought online.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		Qualified -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this instrument has passed its most recent qualification.",
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
			Description -> "A record of the qualifications run on this instrument and their results.",
			Category -> "Qualifications & Maintenance"
		},
		(* --- Qualifications & Maintenance --- *)
		QualificationFrequency -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Computables`Private`qualificationFrequency[Field[Model]]],
			Pattern :> {{ObjectReferenceP[Model[Qualification]], GreaterP[0*Day] | Null}...},
			Description -> "The frequencies of the Qualifications targeting this instrument.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Qualification Model","Time Interval"}
		},
		RecentQualifications -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Qualification], Model[Qualification]},
			Description -> "List of the most recent Qualifications run on this instrument.",
			Headers -> {"Date","Qualification","Qualification Model"},
			Category -> "Qualifications & Maintenance",
			Abstract -> True
		},
		QualificationLog -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Qualification], Model[Qualification]},
			Description -> "All Qualifications run on this instrument over time.",
			Headers -> {"Date","Qualification","Qualification Model"},
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		NextQualificationDate -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, _?DateObjectQ},
			Relation -> {Model[Qualification], Null},
			Description -> "A list of the dates on which the next qualifications will be enqueued for this instrument.",
			Headers -> {"Qualification Model","Date"},
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		QualificationExtensionLog -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression, Link, Expression, String},
			Pattern :> {_Link, _?DateObjectQ, _?DateObjectQ, _Link, QualificationExtensionCategoryP, _String},
			Relation -> {Model[Qualification], Null, Null, Object[User], Null, Null},
			Description -> "A list of amendments made to the regular qualification schedule of this instrument, and the reason for the deviation.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Qualification Model", "Original Due Date","Revised Due Date","Responsible Party","Extension Category","Extension Reason"}
		},
		MaintenanceFrequency -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Computables`Private`maintenanceFrequency[Field[Model]]],
			Pattern :> {{ObjectReferenceP[Model[Maintenance]], GreaterP[0*Day] | Null}...},
			Description -> "A list of the maintenances which are run on this instrument.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Maintenance Model","Time Interval"}
		},
		RecentMaintenance -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Maintenance], Model[Maintenance]},
			Description -> "List of the most recent maintenance runs on this instrument.",
			Headers -> {"Date","Maintenance","Maintenance Model"},
			Category -> "Qualifications & Maintenance",
			Abstract -> True
		},
		MaintenanceLog -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Maintenance], Model[Maintenance]},
			Description -> "All maintenance runs on this instrument over time.",
			Headers -> {"Date","Maintenance","Maintenance Model"},
			Category -> "Qualifications & Maintenance"
		},
		NextMaintenanceDate -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, _?DateObjectQ},
			Relation -> {Model[Maintenance], Null},
			Description -> "A list of the dates on which the next maintenance runs will be enqueued for this instrument.",
			Headers -> {"Maintenance Model", "Date"},
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		MaintenanceExtensionLog -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression, Link, Expression, String},
			Pattern :> {_Link, _?DateObjectQ, _?DateObjectQ, _Link, MaintenanceExtensionCategoryP, _String},
			Relation -> {Model[Maintenance], Null, Null, Object[User], Null, Null},
			Description -> "A list of amendments made to the regular maintenance schedule of this instrument, and the reason for the deviation.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Maintenance Model", "Original Due Date","Revised Due Date","Responsible Party","Extension Category","Extension Reason"}
		},
		Parts -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[ContentsLog], Field[Contents]}, Computables`Private`partsCurrentComputable[Field[ContentsLog], Field[Contents]]],
			Pattern :> {{ObjectReferenceP[Object[Part]], _?DateObjectQ | Null, Null | GreaterEqualP[0*Day]}...},
			Description -> "Parts currently installed on this instrument. For parts that have NumberOfHours tracked (e.g. lamps), this is displayed in the Time on Instrument key.",
			Headers -> {"Part","Date Installed","Time on Instrument"},
			Category -> "Qualifications & Maintenance"
		},
		SharedParts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part][SharedInstruments]|Object[Plumbing][SharedInstruments]|Object[Wiring][SharedInstruments],
			Description -> "Parts currently shared among multiple instruments.",
			Category -> "Qualifications & Maintenance"
		},
		PartsLog -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{{Field[ContentsLog], Field[Parts]}}, Computables`Private`partsHistoryComputable[Field[ContentsLog], Field[Parts]]],
			Pattern :> {{ObjectReferenceP[Object[Part]], _?DateObjectQ | Null, _?DateObjectQ | Null}...},
			Description -> "A log of the parts that were previously installed on this instrument.",
			Headers -> {"Part","Date Installed","Date Removed"},
			Category -> "Qualifications & Maintenance"
		},
		PreventativeMaintenanceLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Company, Supplier], Object[EmeraldCloudFile]},
			Description -> "A record of the preventative maintenance that has been performed on this instrument.",
			Headers -> {"Date","Vendor","Documentation"},
			Category -> "Qualifications & Maintenance"
		},
		OperationsSupportTickets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[SupportTicket, Operations][AffectedInstrument],
			Description -> "Support tickets associated with the execution of this top-level protocol.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		(* == Fields to Be Replaced, should be removed April 2024 post migration to SupportTicket ==*)
		TroubleshootingTickets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Troubleshooting, Ticket][AffectedInstrument],
			Description -> "Troubleshooting tickets that triggered maintenance on this instrument.",
			Category -> "Qualifications & Maintenance"
		},
		(*====*)

		VentilationVerificationLog  -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Qualification], Model[Qualification]},
			Headers -> {"Date","Qualification","Qualification Model"},
			Description -> "A record of ventilation tests performed for this instrument.",
			Category -> "Qualifications & Maintenance"
		},
		FailsafeImageLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Part, InformationTechnology],Object[User]},
			Headers -> {"Date", "HardDrive Object", "Cloned By"},
			Description -> "A record of the hard drive clones made for this instrument and its associated computers.",
			Category -> "Instrument Specifications"
		},
		Certificates -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {_String, _Link},
			Relation -> {Null, Object[EmeraldCloudFile]},
			Description -> "All instrument-related certificates received from vendors.",
			Headers -> {"Name","Certificate"},
			Category -> "Qualifications & Maintenance"
		},
	(* --- Health & Safety --- *)
		HazardCategories -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],HazardCategories]],
			Pattern :> {HazardCategoryP...},
			Description -> "Hazards to be aware of during operation of this instrument.",
			Category -> "Health & Safety"
		},
		SampleHandlingCategories -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],SampleHandlingCategories]],
			Pattern :> {HandlingCategoryP...},
			Description -> "Specifies the types of handling classifications that need to be undertaken for this instrument and items on this instrument.",
			Category -> "Health & Safety"
		},

		(* --- Sensor Information --- *)
		EnvironmentalSensors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Any additional external sensors that are monitoring this particular instrument.",
			Category -> "Sensor Information"
		},
		Enclosures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> EnclosureTypeP,
			Description -> "The types of physical enclosures that surround this instrument.",
			Category -> "Sensor Information"
		},

		(* --- Inventory --- *)
		Receiving -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance, ReceiveInventory][Items],
			Description -> "The MaintenanceReceiveInventory in which this instrument was received.",
			Category -> "Inventory"
		},
		Manufacturer -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Manufacturer]],
			Pattern :> ObjectReferenceP[Object[Company, Supplier]],
			Description -> "The company that manufactured the instrument.",
			Category -> "Inventory",
			Abstract -> True
		},
		SerialNumbers -> {
			Format -> Multiple,
			Class -> {String, String},
			Pattern :> {_String, _String},
			Description -> "A list of serial numbers of the instrument and/or its modules.",
			Headers -> {"Component Name","Serial Number"},
			Category -> "Inventory"
		},
		Cost -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*USD],
			Units -> USD,
			Description -> "The amount paid to the vendor on an initial purchase order for this instrument, not including services or taxes.",
			Category -> "Inventory",
			Developer -> True
		},
		Mobile -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that this instrument is portable and its location must be updated and tracked within the lab as it is moved.",
			Category -> "Inventory",
			Developer -> True
		},
		(* --- Resources --- *)
		RequestedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource, Instrument][RequestedInstrument],
			Description -> "The list of resource requests for this instrument that have not yet been Fulfilled.",
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
		IntegratedVacuumPumps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,VacuumPump][IntegratedInstrument],
			Description -> "The vacuum pumps that are connected to this instrument.",
			Category -> "Integrations"
		}
	}
}];
