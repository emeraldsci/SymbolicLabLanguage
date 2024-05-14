(* ::Package:: *)

DefineObjectType[Object[Qualification, EngineBenchmark],{
	Description -> "Stores information and parameters for a mock Rosetta procedure which utilizes every task type to test Rosetta's speed and integration behavior.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {

		(* -- Method Information-- *)
		OperatingSystem -> {
			Format -> Single,
			Class -> String,
			Pattern :> MathematicaOperatingSystemP,
			Description -> "Operating system on which this Qualification is run.",
			Category -> "General"
		},
		GitCommit -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _String,
			Description -> "The commit hash on which this Qualification is run.",
			Category -> "General"
		},
		GitBranch -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _String,
			Description -> "The name of the branch on which this Qualification is run.",
			Category -> "General"
		},
		RunTimes -> {
			Format -> Multiple,
			Class -> {Expression,Real},
			Pattern :> {_Symbol, TimeP},
			Units -> {None, Second},
			Description -> "The times required for the functions to complete at the time this Qualification was run.",
			Category -> "General",
			Headers -> {"Function Tested", "Run Time"}
		},

		(* -- Scanning Tests -- *)
		DoesNotExistObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Part],
				Object[Container],
				Model[Sample],
				Model[Part],
				Object[Item],
				Model[Item],
				Model[Container],
				Model[Plumbing],
				Object[Plumbing],
				Model[Wiring],
				Object[Wiring]
			],
			Description -> "Models that cannot be fulfilled by resource picking until a special function (given in the procedure as an instruction) is run. Used to test the resiliency of the resource picking related tasks inside of a DangerZone (should not let the operator exit).",
			Category -> "Scanning Tests"
		},
		VerificationObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Part],
				Object[Container],
				Model[Sample],
				Model[Part],
				Object[Item],
				Model[Item],
				Model[Container],
				Model[Plumbing],
				Object[Plumbing],
				Model[Wiring],
				Object[Wiring]
			],
			Description -> "The objects which are scanned in a verification task.",
			Category -> "Scanning Tests"
		},
		SelectedInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The instruments which are selected via an instrument selection task.",
			Category -> "Scanning Tests"
		},
		Parts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part],
				Model[Part]
			],
			Description -> "The parts which are selected via a resource picking task.",
			Category -> "Scanning Tests"
		},
		Tools -> {
			Format -> Multiple,
			Class -> {
				Screwdriver -> Link,
				RubberMallet -> Link
			},
			Pattern :> {
				Screwdriver -> _Link,
				RubberMallet -> _Link
			},
			Relation -> {
				Screwdriver -> Alternatives[Model[Item, Screwdriver], Object[Item, Screwdriver]],
				RubberMallet -> Alternatives[Model[Item, RubberMallet], Object[Item, RubberMallet]]
			},
			Description -> "The parts which are selected via a resource picking task that come from a named multiple.",
			Category -> "Scanning Tests"
		},
		Hammer -> {
			Format -> Single,
			Class -> {
				RubberMallet -> Link,
				Color -> Expression
			},
			Pattern :> {
				RubberMallet -> _Link,
				Color -> MalletHeadColorP
			},
			Relation -> {
				RubberMallet -> Alternatives[Model[Item, RubberMallet], Object[Item, RubberMallet]],
				Color -> Null
			},
			Description -> "The rubber mallet that is selected via a resource picking task that come from a named single.",
			Category -> "Scanning Tests"
		},
		WaterSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The water samples which are dispensed and selected during a resource picking task.",
			Category -> "Scanning Tests"
		},
		FluidSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Item],
				Model[Item]
			],
			Description -> "The fluid samples whose containers are selected via a resource picking task.",
			Category -> "Scanning Tests"
		},
		SelfContainedSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample], (* TODO: Remove Object[Sample] here after item migration *)
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "The discrete samples which are selected via a resource picking task.",
			Category -> "Scanning Tests"
		},
		Containers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The containers which are selected via a resource picking task.",
			Category -> "Scanning Tests"
		},
		Tips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample], (* TODO: Remove Object[Sample] here after item migration *)
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "The tips which are selected via a tip refill task.",
			Category -> "Scanning Tests"
		},
		MovedItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Item],
				Object[Container],
				Object[Part]
			],
			Description -> "The list of items moved in a partial orderless movement task.",
			Category -> "Scanning Tests"
		},
		(* -- PDU Tests -- *)
		PDUPoweredInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The instrument which is turned on with a PDU during the PDU task.",
			Category -> "PDU Tests"
		},
		PDUTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Second],
			Units -> Minute,
			Description -> "The length of time for which the PDU is turned on during the PDU task.",
			Category -> "PDU Tests"
		},
		
		(* -- DangerZone Tests -- *)
		DangerZoneTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Second],
			Units -> Minute,
			Description -> "The length of time for various Dangerzone options.",
			Category -> "DangerZone Tests"
		},
		
		(* -- Sensor Tests -- *)
		Sensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor],
			Description -> "The sensor whose current value is queried during the record and monitor sensor tasks.",
			Category -> "Sensor Tests"
		},
		RecordedSensorData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Qualifications],
			Description -> "Data recorded during a RecordSensor task.",
			Category -> "Sensor Tests"
		},
		SelectedSensorData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Qualifications],
			Description -> "Data recorded at the end of a MonitorSensor task.",
			Category -> "Sensor Tests"
		},

		(* -- User Input Tests -- *)
		Condenser -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The text which appears in the ECL Condenser app.",
			Category -> "User Input Tests"
		},
		MultipleChoiceAnswer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "The value selected in the initial multiple choice task.",
			Category -> "User Input Tests"
		},
		EnteredText -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The text entered by the user during the text entry task.",
			Category -> "User Input Tests"
		},

		(* -- Storage Tests -- *)
		SingleUseObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container],
				Model[Sample],
				Model[Container],
				Object[Item],
				Model[Item]
			],
			Description -> "Objects which are discarded during the clean up task.",
			Category -> "Storage Tests"
		},
		ReusableObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container],
				Object[Part],
				Object[Item],
				Model[Sample],
				Model[Container],
				Model[Part],
				Model[Item]
			],
			Description -> "Objects which are placed into storage during the storage task.",
			Category -> "Storage Tests"
		},
		AutomatedStorageObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "Objects specifically designed to test facets of the automated storage system (such as sticky rack splitting in cases of limited storage and rack resource picking for non-self standing samples).",
			Category -> "Storage Tests"
		},

		(* -- Movement Tests -- *)
		DeckPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {
				Alternatives[
					Object[Container],
					Object[Sample],
					Model[Container],
					Model[Sample],
					Object[Item],
					Model[Item]
				],
				Null
			},
			Description -> "A specification of where the listed containers are placed during the deck placement task.",
			Headers -> {"Container", "Placement Tree"},
			Category -> "Movement Tests",
			Developer -> True
		},
		Deck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The parent container into which objects will be placed during the deck placement task.",
			Category -> "Movement Tests"
		},
		ContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link,Link,String},
			Pattern :> {_Link,_Link,_String},
			Relation -> {
				Alternatives[
					Object[Container],
					Object[Sample],
					Object[Part],
					Model[Container],
					Model[Sample],
					Model[Part],
					Object[Item],
					Model[Item]
				],
				Alternatives[
					Object[Container],
					Model[Container]
				],
				Null
			},
			Description -> "A specification of containers to place and their placment location.",
			Headers -> {"Source Container", "Destination Container","Destination Position"},
			Category -> "Movement Tests"
		},

		(* -- Subprotocol Tests -- *)
		SamplePrep -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "A sample manipulation protocol generated the test the sample manipulation task.",
			Category -> "Subprotocol Tests"
		},
		SamplePreparationProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "Protocols used to prepare the SamplesIn and/or AliquotSamples prior to starting the experiment.",
			Category -> "Sample Preparation"
		},

		(* -- Looping Tests -- *)
		QualificationPrograms -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Program][Qualification]
			],
			Description -> "Progams which are looped over to test the Rosetta's looping support.",
			Category -> "Looping Tests"
		},
		(* -- Connection Tests --*)
		SourceConnections-> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {
				Alternatives[
					Model[Plumbing],
					Object[Plumbing],
					Model[Instrument],
					Object[Instrument],
					Model[Container],
					Object[Container],
					Model[Part],
					Object[Part],
					Model[Item],
					Object[Item]
				],
				Null,
				Alternatives[
					Model[Plumbing],
					Object[Plumbing],
					Model[Instrument],
					Object[Instrument],
					Model[Container],
					Object[Container],
					Model[Part],
					Object[Part],
					Model[Item],
					Object[Item]
				],
				Null
			},
			Description -> "The connection information for attaching source bottles to the instrument.",
			Headers -> {"Object to Connect A","Connector Name A","Object to Connect B","Connector Name B"},
			Category -> "Plumbing Information",
			Developer -> True
		},
		SourceDisconnections -> {
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, ConnectorNameP},
			Relation -> {Object[Plumbing]|Object[Instrument]|Object[Container]|Object[Part]|Object[Item], Null},
			Description -> "The disconnection information for moving source buffer lines back to reservoir.",
			Headers -> {"Object to Connect A", "Connector Name A"},
			Category -> "Plumbing Information",
			Developer -> True
		},
		ConnectedLocation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument]|Object[Container],
			Description -> "The nearest object of known location to which the connected plumbing or wiring component will be, either directly or indirectly.",
			Category -> "Plumbing Information",
			Developer -> True
		},
		ReplacedParts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing]|Object[Wiring]|Object[Instrument]|Object[Container]|Object[Part]|Object[Item],
			Description -> "The plumbing or wiring parts that would be replaced in this maintenance.",
			Category -> "Plumbing Information",
			Developer -> True
		},
		SourceValvePosition -> {
			Format -> Single,
			Class -> {Link, String},
			Pattern :> {_Link, _String},
			Relation -> {Object[Plumbing]|Object[Instrument]|Object[Container]|Object[Part]|Object[Item], Null},
			Description -> "The valve position information for switching gas valve.",
			Headers -> {"Object", "Valve Position"},
			Category -> "Plumbing Information",
			Developer -> True
		},
		SourceValvePositions -> {
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, _String},
			Relation -> {Object[Plumbing]|Object[Instrument]|Object[Container]|Object[Part]|Object[Item], Null},
			Description -> "The information to open, close, or change the flow of a valve.",
			Headers -> {"Object","Valve Position"},
			Category -> "Plumbing Information",
			Developer -> True
		},
		SourceValves -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing],
			Description -> "The valve whose position will be changed.",
			Category -> "Plumbing Information",
			Developer -> True
		},
		SourceValve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing],
			Description -> "The valve whose position will be changed.",
			Category -> "Plumbing Information",
			Developer -> True
		},
		SourceDestination->{
			Format -> Single,
			Class -> {Link,String},
			Pattern :> {_Link, _String},
			Relation -> {Object[Instrument]|Object[Container], Null},
			Description -> "The source destination information for the replaced parts.",
			Headers -> {"Object", "Position"},
			Category -> "Plumbing Information",
			Developer -> True
		},
		(* -- WiringConnection Tests --*)
		SourceWiringConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,WiringConnectorNameP,_Link,WiringConnectorNameP},
			Relation -> {
				Alternatives[
					Model[Wiring],
					Object[Wiring],
					Model[Instrument],
					Object[Instrument],
					Model[Container],
					Object[Container],
					Model[Part],
					Object[Part],
					Model[Item],
					Object[Item]
				],
				Null,
				Alternatives[
					Model[Wiring],
					Object[Wiring],
					Model[Instrument],
					Object[Instrument],
					Model[Container],
					Object[Container],
					Model[Part],
					Object[Part],
					Model[Item],
					Object[Item]
				],
				Null
			},
			Description -> "The wiring connection information for attaching wiring components.",
			Headers -> {"Object to Connect A","WiringConnector Name A","Object to Connect B","WiringConnector Name B"},
			Category -> "Wiring Information",
			Developer -> True
		},
		SourceWiringDisconnections -> {
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, WiringConnectorNameP},
			Relation -> {Object[Wiring]|Object[Instrument]|Object[Container]|Object[Part]|Object[Item], Null},
			Description -> "The disconnection information for removing wiring components.",
			Headers -> {"Object to Connect A", "WiringConnector Name A"},
			Category -> "Wiring Information",
			Developer -> True
		}
	}
}];
