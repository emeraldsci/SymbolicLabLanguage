

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

(* ::Title:: *)
(*ValidObjectQ: Tests*)








(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(* ValidObjectQ *)


DefineTests[ValidObjectQ,
	{
		Example[{Basic,"Takes in a list of objects and returns a boolean indicating if all have passed:"},
			ValidObjectQ[{Object[Sample, "id:-1"],Object[Sample, "id:-2"]}],
			True
		],
		Example[{Basic,"Takes in a type and returns a boolean indicating if all recent objects of that type have passed:"},
			ValidObjectQ[Object[Sample]],
			True,
			Stubs:>{
				selectObjectsToTest[Object[Sample]] := {Object[Sample, "id:-1"],Object[Sample, "id:-2"]}
			}
		],

		Example[{Basic,"Takes in mixed input and returns a single boolean indicating if objects found in the input have passed:"},
			ValidObjectQ[{BufferA->Object[Sample, "id:-1"],BufferB->Object[Sample, "id:-2"],FlowRate->300 Microliter/Second}],
			True
		],

		Example[{Messages,"BadObjects","If Messages->True, prints a message describing which objects are invalid:"},
			ValidObjectQ[{Object[Sample, "id:-1"],Object[Sample, "id:-2"]},Messages->True,OutputFormat->Boolean],
			{False,True},
			Messages:>{
				ValidObjectQ::BadObjects
			},
			Stubs:>{
				Download[Object[Sample, "id:-1"]]:=Association[
					Type->Object[Sample],
					Status->Available,
					Flammable->False
				]
			}
		],

		Example[{Options,Messages,"Set Messages->True to print a message about the invalid objects. By default no message will be printed:"},
			ValidObjectQ[{Object[Sample, "id:-1"],Object[Sample, "id:-2"]},Messages->True,OutputFormat->Boolean],
			{False,True},
			Messages:>{
				ValidObjectQ::BadObjects
			},
			Stubs:>{
				Download[Object[Sample, "id:-1"]]:=Association[
					Type->Object[Sample],
					Status->Available,
					Flammable->False
				]
			}
		],

		Test["When OutputFormat->Boolean, returns a boolean for each object indicating if the object passed or failed all its tests:",
			ValidObjectQ[{Object[Sample, "id:-1"],Object[Sample, "id:-2"]},OutputFormat->Boolean],
			{True,True}
		],
		
		Test["When OutputFormat->Boolean and Association->True, returns an association with objects as the keys and results as the values:",
			ValidObjectQ[{Object[Sample, "id:-1"],Object[Sample, "id:-2"]},OutputFormat->Boolean,Association->True],
			Association[Object[Sample, "id:-1"]->True,Object[Sample, "id:-2"]->True]
		],
		
		Test["Takes in a single object and always returns a single boolean:",
			ValidObjectQ[Object[Sample, "id:-1"]],
			True
		]
	},
	Stubs:>{
		validQTestFunctions = Association[
			Object[Sample]->fakeSampleTests,
			Object[Sample]->fakeSampleChemicalTests
		],
		
		fakeSampleTests[packet:PacketP[Object[Sample]]]:={
			Test["Status is Available",
				Lookup[packet,Status],
				Available
			]
		},
		fakeSampleChemicalTests[packet:PacketP[Object[Sample]]]:={
			Test["Flammable is True",
				Lookup[packet,Flammable],
				True
			]
		},
		
		Download[objects:{ObjectP[]..},ops___]:=Download/@objects,
		Download[ObjectP[Object[Sample]],ops___]:=Association[
			Type->Object[Sample],
			Status->Available,
			Flammable->True
		]
	}
];

(* ::Subsection:: *)
(* registerValidQTestFunction *)


DefineTests[
	registerValidQTestFunction,
	{
		Example[{Basic,"Register a test function for Object[Protocol,HPLC] objects:"},
			registerValidQTestFunction[Object[Protocol,HPLC],myHPLCValidQTests],
			myHPLCValidQTests
		],
		Example[{Basic,"Register a test function for a super type:"},
			registerValidQTestFunction[Object[Sample],mySampleTests],
			mySampleTests
		],

		Test["Adds key to validQTestFunctions Association:",
			(
				registerValidQTestFunction[Object[Protocol,HPLC],myHPLCValidQTests];
				Lookup[validQTestFunctions,Object[Protocol,HPLC]]
			),
			myHPLCValidQTests
		],

		Example[{Messages,"DownValues","Throws a message and returns $Failed if test function has no DownValues:"},
			registerValidQTestFunction[Object[Protocol,HPLC],functionWithoutDownValues],
			$Failed,
			Messages:>{
				Message[registerValidQTestFunction::DownValues,Object[Protocol,HPLC],functionWithoutDownValues]
			}
		]
	},
	Stubs:>{
		validQTestFunctions=Association[],
		myHPLCValidQTests[obj:ObjectP[Object[Protocol, HPLC]]]:={},
		mySampleTests[obj:ObjectP[Object[Sample]]]:={}
	}
];




(* ::Subsection::Closed:: *)
(*Test Functions*)


(* ::Subsubsection::Closed:: *)
(*NotNullFieldTest*)


DefineTests[NotNullFieldTest,
	{
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due the field being not-Null:"},
			NotNullFieldTest[Download[Object[Protocol, PNASynthesis, "id:01G6nvkJW43A"]],ContainersOut],
			{_EmeraldTest?(RunTest[#][Passed]&)}
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should fail due the field being Null:"},
			NotNullFieldTest[Download[Object[Instrument, PeptideSynthesizer, "id:01G6nvkJWBzE"]],ArgonPressureSensor],
			{_EmeraldTest?(!(RunTest[#][Passed])&)}
		],
		Example[{Basic,"Generate a set of EmeraldTest Objects on a Packet for each of the fields being tested:"},
			NotNullFieldTest[Download[Model[Sample, "id:Z1lqpMGJb3BV"]],{Composition,BoilingPoint}],
			{
				_EmeraldTest?(RunTest[#][Passed]&),
				_EmeraldTest?(!(RunTest[#][Passed])&)
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*NullFieldTest*)
DefineTests[NullFieldTest,
	{
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due the specified field being Null:"},
			NullFieldTest[Download[Object[Protocol, PNASynthesis, "id:01G6nvkJW43A"]],ContainersIn],
			{_EmeraldTest?(RunTest[#][Passed]&)}
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should fail due the specified field being not Null:"},
			NullFieldTest[Download[Object[Instrument, PeptideSynthesizer, "id:01G6nvkJWBzE"]],CrossSectionalShape],
			{_EmeraldTest?(!(RunTest[#][Passed])&)}
		],
		Example[{Basic,"Generate a set of EmeraldTest Objects on a Packet for each of the fields being tested:"},
			NullFieldTest[Download[Model[Sample, "id:Z1lqpMGJb3BV"]],{Composition,BoilingPoint}],
			{
				_EmeraldTest?(!(RunTest[#][Passed])&),
				_EmeraldTest?((RunTest[#][Passed])&)
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*RequiredTogetherTest*)


DefineTests[RequiredTogetherTest,
	{
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due the all of the specified fields being informed:"},
			RunTest[
				RequiredTogetherTest[Download[Model[Instrument, PlateReader, "id:O81aEB4rE61j"]],{MinTemperature,MaxTemperature,Name}]
			][Passed],
			True
		],

		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due the all of the specified fields being Null:"},
			RunTest[
				RequiredTogetherTest[Download[Model[Instrument, PlateReader, "id:bq9LA0dDAz1m"]],{MinTemperature,MaxTemperature,Name}]
			][Passed],
			True
		],

		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should fail due to some but not all of the specified fields being Null:"},
			RunTest[
				RequiredTogetherTest[Download[Model[Instrument, PlateReader, "id:KBL5DvYkDGPx"]],{MinTemperature,MaxTemperature,Name}]
			][Passed],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*FieldSyncTest*)


DefineTests[FieldSyncTest,
	{
		Example[{Basic,"Generate an EmeraldTest Object on Objects that should pass due the specified field containing the same information in both objects:"},
		FieldSyncTest[{
			Download[Object[Protocol, FluorescenceKinetics, "id:qdkmxz0RdldM"]],
			Download[Object[Data, FluorescenceKinetics, "id:1ZA60vwOZNZD"]]
		}, NumberOfReadings],
		_EmeraldTest?(RunTest[#][Passed]&)
	],
		Example[{Basic,"Generate an EmeraldTest Object on Objects that should fail due to one of the fields not being informed:"},
			FieldSyncTest[{
				Download[Object[Protocol, FluorescenceKinetics, "id:WNa4ZjR1NW7L"]],
				Download[Object[Data, FluorescenceKinetics, "id:01G6nvkq1oar"]]
			}, NumberOfReadings],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		],

		Example[{Basic,"Generate an EmeraldTest Object on Objects that should fail due the specified field containing different information in both objects:"},
			FieldSyncTest[{
				Download[Object[Product, "id:54n6evKYKELN"]],
				Download[Model[Sample, "id:8qZ1VWNmdLBD"]]
			}, Name],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		]
	}

];



(* ::Subsubsection::Closed:: *)
(*ObjectTypeTest*)


DefineTests[ObjectTypeTest,
	{
		Example[{Basic,"Generate an EmeraldTest that should pass due all of its Objects being of the same subtype:"},
			ObjectTypeTest[Download[Model[Instrument, FumeHood, "Fake Fume Hood"]], Objects],
			_EmeraldTest?(RunTest[#][Passed]&)
		],

		Example[{Basic,"Generate an EmeraldTest that should failed due all of its SamplesIn not being of the same subtype:"},
			ObjectTypeTest[Download[Object[Protocol, ImageSample, "id:pZx9jo87OJJe"]], SamplesIn],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		],

		Example[{Basic,"If the field provided has not been informed, the test generated will automatically pass:"},
			ObjectTypeTest[Download[Model[Sample, StockSolution, "Fake StockSolution Model for Testing"]],Products],
			_EmeraldTest?(RunTest[#][Passed]&)
		],

		Example[{Additional,"If the field provided does not exist in the given object, a test returned will automatically fail:"},
			ObjectTypeTest[Download[Model[Sample, StockSolution, "Fake StockSolution Model for Testing"]],Target],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*FieldComparisonTest*)


DefineTests[FieldComparisonTest,
	{
		Example[{Basic, "Generate an EmeraldTest Object on a Packet that should pass due the first supplied Field being less than the second:"},
			FieldComparisonTest[Download[Model[Instrument, Incubator, "id:aXRlGnZPGGRO"]], {MinTemperature, MaxTemperature}, Less],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic, "Generate an EmeraldTest Object on a Packet that should fail due to the first supplied Field NOT being greater than the second:"},
			FieldComparisonTest[Download[Model[Instrument, Incubator, "id:aXRlGnZPGGRO"]], {MinTemperature, MaxTemperature}, Greater],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		],
		Example[{Basic, "Generate an EmeraldTest Object on a Packet that should pass by default due to one of the supplied fields being Null:"},
			FieldComparisonTest[Download[Model[Instrument, Incubator, "id:dORYzZn8zzdA"]], {MinTemperature, MaxTemperature}, Less],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Additional, "Any number of fields (>= 2) can be compared at once:"},
			FieldComparisonTest[Download[Object[Protocol, ImageSample, "id:1ZA60vLMLVO8"]], {DateCreated, DateConfirmed, DateStarted, DateCompleted}, LessEqual],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Messages, "InvalidComparison", "If the contents of the provided fields are not Null but also cannot be compared, a failing test is returned:"},
			FieldComparisonTest[Download[Object[Instrument, Incubator, "id:qdkmxz0RxxGx"]], {MinTemperature, Name}, Less],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		],
		Example[{Messages, "InvalidFields", "If any of the provided fields do not exist in the provided Object, a failing test is returned:"},
			FieldComparisonTest[Download[Object[Instrument, Incubator, "id:qdkmxz0RxxGx"]], {MinTemperature, CakePreference}, Less],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		],
		Example[{Messages, "InvalidComparison", "If the provided fields are a mix of singleton and multiple fields, a failing test is returned:"},
			FieldComparisonTest[<|Type -> Object[Example, Data], Number -> 1, Random -> {1, 2, 3} |>, {Number, Random}, Less],
				_EmeraldTest?(!(RunTest[#][Passed])&)
			],
		Example[{Messages, "InvalidComparison", "If the provided fields multiple fields have a different number of elements, a failing test is returned:"},
			FieldComparisonTest[<|Type -> Object[Example, Data], Random -> {1, 2, 3}, Replace -> {1, 2}|>, {Random, Replace}, Less],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*UniqueFieldTest*)


DefineTests[UniqueFieldTest,
	{
		Example[{Basic,"Generates a test which passes because the value is unique:"},
			UniqueFieldTest[Download[Model[Instrument, PlateReader, "id:kEJ9mqaWmdKE"]], PCICard],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generates a test which fails because the value is not unique:"},
			UniqueFieldTest[Download[Model[Instrument, PlateReader, "id:pZx9jonXj5Zj"]], AbsorbanceDetector],
			_EmeraldTest?(!RunTest[#][Passed]&)
		],
		Example[{Basic,"Generates a test which passes because the value is null:"},
			UniqueFieldTest[Download[Model[Instrument, PlateReader, "id:pZx9jonXj5Zj"]], PlateReaderMode],
			_EmeraldTest?(RunTest[#][Passed]&)
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*AnyInformedTest*)


DefineTests[AnyInformedTest,
	{
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due to all fields being non-Null:"},
			AnyInformedTest[Download[Object[Instrument, PeptideSynthesizer, "id:01G6nvkJWBzE"]], {CrossSectionalShape,PowerType}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due at least one field being non-Null:"},
			AnyInformedTest[Download[Object[Instrument, PeptideSynthesizer, "id:01G6nvkJWBzE"]], {CrossSectionalShape, Enclosures}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should fail due to all of the fields being Null:"},
			AnyInformedTest[Download[Object[Instrument, PeptideSynthesizer, "id:01G6nvkJWBzE"]],{ArgonPressureSensor, CO2PressureSensor}],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*UniquelyInformedTest*)


DefineTests[UniquelyInformedTest,
	{
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due to only one field being non-Null:"},
			UniquelyInformedTest[Download[Object[Instrument, PeptideSynthesizer, "id:01G6nvkJWBzE"]], {CrossSectionalShape, Enclosures}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should fail due to all of the fields being Null:"},
			UniquelyInformedTest[Download[Object[Instrument, PeptideSynthesizer, "id:01G6nvkJWBzE"]],{ArgonPressureSensor, CO2PressureSensor}],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should fail due to more then one fields being non-Null:"},
			UniquelyInformedTest[Download[Object[Instrument, PeptideSynthesizer, "id:01G6nvkJWBzE"]],{CrossSectionalShape,PowerType}],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		],
		Example[{Basic, "Generate an EmeraldTest Object on a Packet that should pass due to there being only one field that is non-Null where another parent field matches a pattern"},
			UniquelyInformedTest[<|Type -> Object[Protocol, LCMS], AcquisitionModes -> {MS1FullScan, MultipleReactionMonitoring}, FragmentMinMass -> {Null, 100 Gram/Mole}, FragmentMassSelections -> {Null, Null}|>, {FragmentMinMass, FragmentMassSelections}, AcquisitionModes, Alternatives[MultipleReactionMonitoring]],
			_EmeraldTest?((RunTest[#][Passed])&)
		],
		Example[{Basic, "Generate an EmeraldTest Object on a Packet that should fail due to there being two fields that are non-Null where another parent field matches a pattern"},
			UniquelyInformedTest[<|Type -> Object[Protocol, LCMS], AcquisitionModes -> {MS1FullScan, MultipleReactionMonitoring}, FragmentMinMass -> {Null, 100 Gram/Mole}, FragmentMassSelections -> {Null, 200 Gram/Mole}|>, {FragmentMinMass, FragmentMassSelections}, AcquisitionModes, Alternatives[MultipleReactionMonitoring]],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*RequiredWhenCompleted*)


DefineTests[RequiredWhenCompleted,
	{
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due to Status being Completed and the field of interest being informed:"},
			RequiredWhenCompleted[Download[Object[Protocol, ImageSample, "id:o1k9jAK434d7"]], {FieldsOfView}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due to Status not being Completed:"},
			RequiredWhenCompleted[Download[Object[Protocol, ImageSample, "id:54n6evKY1Yw9"]], {FieldsOfView}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should fail due to Status being Completed, but the field of interest not being informed:"},
			RequiredWhenCompleted[Download[Object[Protocol, ImageSample, "id:n0k9mGzeLeZn"]], {FieldsOfView}],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		],

		Example[{Additional,"Also works when given a single field:"},
			RequiredWhenCompleted[Download[Object[Protocol, ImageSample, "id:o1k9jAK434d7"]], FieldsOfView],
			_EmeraldTest?(RunTest[#][Passed]&)
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ResolvedWhenCompleted*)


DefineTests[ResolvedWhenCompleted,
	{
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due to Status being Completed and the field of interest being resolved:"},
			ResolvedWhenCompleted[Download[Object[Protocol, ImageSample, "id:o1k9jAK434d7"]], {Imager}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due to Status not being Completed:"},
			ResolvedWhenCompleted[Download[Object[Protocol, ImageSample, "id:54n6evKY1Yw9"]], {Imager}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should fail due to Status being Completed, but the field of interest not being resolved:"},
			ResolvedWhenCompleted[Download[Object[Protocol, ImageSample, "id:n0k9mGzeLeZn"]], {Imager}],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		],
		Example[{Additional,"Also works when given a single field:"},
			RequiredWhenCompleted[Download[Object[Protocol, ImageSample, "id:o1k9jAK434d7"]], Imager],
			_EmeraldTest?(RunTest[#][Passed]&)
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*UniquelyInformedIndexTest*)


DefineTests[UniquelyInformedIndexTest,
	{
		Example[{Basic, "Generate an EmeraldTest Object on a Packet that should pass due to having two or more uniquely-informed index-matched multiple fields:"},
			UniquelyInformedIndexTest[<|Type -> Object[Protocol, LCMS], MinMasses -> {100 Gram/Mole, Null}, MassSelections -> {Null, 200 Gram/Mole}|>, {MinMasses, MassSelections}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic, "Generate an EmeraldTest Object on a Packet that should fail due to having a two or more index-matched multiple field informed at the same index:"},
			UniquelyInformedIndexTest[<|Type -> Object[Protocol, LCMS], MinMasses -> {100 Gram/Mole, 100 Gram/Mole}, MassSelections -> {Null, 200 Gram/Mole}|>, {MinMasses, MassSelections}],
			_EmeraldTest?(!RunTest[#][Passed]&)
		],
		Test["Generate an EmeraldTest Object on a Packet that should fail (without throwing a Transpose::nmtx message) due to lack of index-matching:",
			UniquelyInformedIndexTest[<|Type -> Object[Protocol, LCMS], MinMasses -> {100 Gram/Mole}, MassSelections -> {Null, 200 Gram/Mole}|>,  {MinMasses, MassSelections}],
			_EmeraldTest?(!RunTest[#][Passed]&)
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*URLFieldAccessibleTest*)


DefineTests[URLFieldAccessibleTest,
	{
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due to having an accessible URL within a field:"},
			URLFieldAccessibleTest[<|Type -> Object[Product], ProductURL -> "https://google.com" |>, ProductURL],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass when no URL was specified:"},
			URLFieldAccessibleTest[<|Type -> Object[Product], ProductURL -> Null |>, ProductURL],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due to having accessible URLs within a few fields:"},
			URLFieldAccessibleTest[<|Type -> Object[Example, Data], URL -> "https://google.com", ProductURL -> Null |>, {URL, ProductURL}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should fail due to having inaccessible URLs within at least one field:"},
			URLFieldAccessibleTest[<|Type -> Object[Example, Data], URL -> "https://google.com", ProductURL -> "https://www.emeraldcloudlab.com/nopage" |>, {URL, ProductURL}],
		_EmeraldTest?(!RunTest[#][Passed]&)
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*RequiredAfterCheckpoint*)


DefineTests[RequiredAfterCheckpoint,
	{
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due to a CheckPoint being completed and FieldOfView being informed:"},
			RequiredAfterCheckpoint[Download[Object[Protocol, ImageSample, "id:kEJ9mqaWlWlP"]], "Imaging Samples", {FieldsOfView}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due to a CheckPoint having not started:"},
			RequiredAfterCheckpoint[Download[Object[Protocol, ImageSample, "id:01G6nvkq9qa4"]], "Imaging Samples", {FieldsOfView}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due to a CheckPoint having started but not completed:"},
			RequiredAfterCheckpoint[Download[Object[Protocol, ImageSample, "id:o1k9jAK404dx"]], "Imaging Samples", {FieldsOfView}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should fail due to a CheckPoint label being completed but FieldOfView not being informed:"},
			RequiredAfterCheckpoint[Download[Object[Protocol, ImageSample, "id:vXl9j5qkVkNB"]], "Imaging Samples", {FieldsOfView}],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		],
		Example[{Additional,"A singleton field can be specified:"},
			RequiredAfterCheckpoint[Download[Object[Protocol, ImageSample, "id:vXl9j5qkVkNB"]], "Imaging Samples", FieldsOfView],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ResolvedAfterCheckpoint*)


DefineTests[ResolvedAfterCheckpoint,
	{
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due to a CheckPoint being completed and Imager being resolved:"},
			ResolvedAfterCheckpoint[Download[Object[Protocol, ImageSample, "id:Y0lXejGpapBV"]], "Imaging Samples", {Imager}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due to a CheckPoint having not started:"},
			ResolvedAfterCheckpoint[Download[Object[Protocol, ImageSample, "id:qdkmxz0RZRbm"]], "Imaging Samples", {Imager}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should pass due to a CheckPoint having started but not completed:"},
			ResolvedAfterCheckpoint[Download[Object[Protocol, ImageSample, "id:Y0lXejGpapdv"]], "Imaging Samples", {Imager}],
			_EmeraldTest?(RunTest[#][Passed]&)
		],
		Example[{Basic,"Generate an EmeraldTest Object on a Packet that should fail due to a CheckPoint being completed but Imager not being resolved:"},
			ResolvedAfterCheckpoint[Download[Object[Protocol, ImageSample, "id:P5ZnEj4K3K84"]], "Imaging Samples", {Imager}],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		],
		Example[{Additional,"A singleton field can be specified:"},
			ResolvedAfterCheckpoint[Download[Object[Protocol, ImageSample, "id:P5ZnEj4K3K84"]], "Imaging Samples", Imager],
			_EmeraldTest?(!(RunTest[#][Passed])&)
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*fetchPacketFromCacheOrDownload*)

DefineTests[fetchPacketFromCacheOrDownload,
	{
		Example[{Basic, "Function will first find objects by travelling through the field lists starting from the main packet, then fetch packets of these objects from cache:"},
			pacs = Download[{Object[Sample, "fetchPacketFromCacheOrDownload test sample 1" <> $SessionUUID], Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID], Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]}];
			fetchPacketFromCacheOrDownload[{{Container, Container}, {Container}}, First[pacs], pacs],
			{PacketP[Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]], PacketP[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID]]},
			Variables :> {pacs}
		],
		Example[{Basic, "If the desired packets can't be found from cache, function will download the packets from Constellation:"},
			pacs = Download[{Object[Sample, "fetchPacketFromCacheOrDownload test sample 1" <> $SessionUUID]}];
			fetchPacketFromCacheOrDownload[{{Container, Container}, {Container}}, First[pacs], pacs],
			{PacketP[Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]], PacketP[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID]]},
			Variables :> {pacs}
		],
		Test["Function can operate on multiple field lists to generate different packets:",
			pacs = Download[{Object[Sample, "fetchPacketFromCacheOrDownload test sample 1" <> $SessionUUID], Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID], Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]}];
			fetchPacketFromCacheOrDownload[{{Container, Container}, {Container}}, First[pacs], pacs],
			{PacketP[Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]], PacketP[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID]]},
			Variables :> {pacs}
		],
		Test["Function can travel through layers of fields to fetch the packets:",
			pacs = Download[{Object[Sample, "fetchPacketFromCacheOrDownload test sample 1" <> $SessionUUID], Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID], Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]}];
			fetchPacketFromCacheOrDownload[{Container, Container}, First[pacs], pacs],
			PacketP[Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]],
			Variables :> {pacs}
		],
		Test["If the desired packets cannot be found from supplied cache, a download will happen to fetch the packet:",
			pac = Download[Object[Sample, "fetchPacketFromCacheOrDownload test sample 1" <> $SessionUUID]];
			fetchPacketFromCacheOrDownload[{Container, Container}, pac, {}],
			PacketP[Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]],
			Variables :> {pac}
		],
		Test["If some of the desird packets are available in cache, some are not, function will try to fetch packet locally first, then attempt to download the missing ones:",
			pacs = Download[{Object[Sample, "fetchPacketFromCacheOrDownload test sample 1" <> $SessionUUID], Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID]}, Packet[Name, Container, Model]];
			fetchPacketFromCacheOrDownload[{{Container, Container}, {Container}}, First[pacs], pacs],
			(* Idea of this test is that cached packets only contains a few fields, but downloads from Constellation should have all *)
			(* One can thus tell where the resulted packet come from *)
			{
				PacketP[Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]],
				AssociationMatchP[<|
					Object -> Download[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID], Object],
					ID -> Download[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID], ID],
					Name -> "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID,
					Type -> Object[Container, Vessel],
					Model -> LinkP[Model[Container, Vessel, "2mL Tube"]],
					Container -> LinkP[Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]]
				|>]
			},
			Variables :> {pacs}
		],
		Test["For a given field list, if it will result in multiple packets, and only some of those are available in cache, then the entire field list will be downloaded from constellation:",
			pacs = Download[{Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID], Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID]}, Packet[Contents]];
			fetchPacketFromCacheOrDownload[{Field[Contents[[All, 2]]]}, First[pacs], pacs],
			(* Idea of this test is that cached packets only contains a few fields, but downloads from Constellation should have all *)
			(* Therefore cached packets won't match to the AssoicationP below because they are missing the Model and Container field *)
			{
				AssociationMatchP[
					<|
						Object -> Download[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID], Object],
						Type -> Object[Container, Vessel],
						Model -> LinkP[Model[Container, Vessel, "2mL Tube"]],
						Container -> LinkP[Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]]
					|>,
					AllowForeignKeys -> True
				],
				AssociationMatchP[
					<|
						Object -> Download[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 2" <> $SessionUUID], Object],
						Type -> Object[Container, Vessel],
						Model -> LinkP[Model[Container, Vessel, "2mL Tube"]],
						Container -> LinkP[Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]]
					|>,
					AllowForeignKeys -> True
				]
			},
			Variables :> {pacs}
		],
		Test["A Packet[field names...] entry can be specified as the last element of field lists. If so, resulted packets will only contain the fields specified, plus Name, ID, Object, Type fields:",
			pacs = Download[{Object[Sample, "fetchPacketFromCacheOrDownload test sample 1" <> $SessionUUID], Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID], Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]}];
			fetchPacketFromCacheOrDownload[{Container, Container, Packet[Contents]}, First[pacs], pacs],
			AssociationMatchP[<|
				Object -> Download[Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID], Object],
				ID -> Download[Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID], ID],
				Type -> Object[Container, Bench],
				Name -> "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID,
				Contents -> {
					{"Work Surface", LinkP[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID]]},
					{"Work Surface", LinkP[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 2" <> $SessionUUID]]}
				}
			|>],
			Variables :> {pacs}
		],
		Test["A Field[fieldName[[partSpec]]] entry can be specified anywhere of field lists. The partSpec indicates that only part of the fields will be fetched, and objects from that will be used to download the next field or packet:",
			pacs = Download[{Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID], Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID], Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 2" <> $SessionUUID]}];
			fetchPacketFromCacheOrDownload[{Field[Contents[[All, 2]]], Field[Contents[[1,2]]]}, First[pacs], pacs],
			{
				PacketP[Object[Sample, "fetchPacketFromCacheOrDownload test sample 1" <> $SessionUUID]],
				PacketP[Object[Sample, "fetchPacketFromCacheOrDownload test sample 2" <> $SessionUUID]]
			},
			Variables :> {pacs}
		],
		Test["A Repeated[fieldName] entry can be specified anywhere of field lists. It functions similar to the syntax in Download function, basically the linked field will be 'downloaded' repeatedly until the last link is found:",
			pacs = Quiet[Download[{Object[Sample, "fetchPacketFromCacheOrDownload test sample 1" <> $SessionUUID], Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID], Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]}, Packet[Container, Contents, Name]]];
			fetchPacketFromCacheOrDownload[{Repeated[Container], Packet[Contents]}, First[pacs], pacs],
			{
				AssociationMatchP[<|
					Object -> Download[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID], Object],
					ID -> Download[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID], ID],
					Type -> Object[Container, Vessel],
					Name -> "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID,
					Contents -> {
						{"A1", LinkP[Object[Sample, "fetchPacketFromCacheOrDownload test sample 1" <> $SessionUUID]]}
					}
				|>],
				AssociationMatchP[<|
					Object -> Download[Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID], Object],
					ID -> Download[Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID], ID],
					Type -> Object[Container, Bench],
					Name -> "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID,
					Contents -> {
						{"Work Surface", LinkP[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID]]},
						{"Work Surface", LinkP[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 2" <> $SessionUUID]]}
					}
				|>]
			},
			Variables :> {pacs}
		],
		Test["A Repeated[Field[fieldName[[partSpec]]]] entry can be specified anywhere of field lists. It functions similar to the syntax in Download function, basically the linked field will be 'downloaded' repeatedly until the last link is found:",
			pacs = Download[{Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID]}];
			fetchPacketFromCacheOrDownload[{Repeated[Field[Contents[[All, 2]]]]}, First[pacs], pacs],
			{
				PacketP[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID]],
				PacketP[Object[Sample, "fetchPacketFromCacheOrDownload test sample 1" <> $SessionUUID]],
				PacketP[Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 2" <> $SessionUUID]],
				PacketP[Object[Sample, "fetchPacketFromCacheOrDownload test sample 2" <> $SessionUUID]]
			},
			Variables :> {pacs}
		]
	},
	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID],
					Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID],
					Object[Container, Vessel, "fetchPacketFromCacheOrDownload test container 2" <> $SessionUUID],
					Object[Sample, "fetchPacketFromCacheOrDownload test sample 1" <> $SessionUUID],
					Object[Sample, "fetchPacketFromCacheOrDownload test sample 2" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[
			{fakeBench, container, container2, sample, sample2},

			fakeBench = Upload[
				<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Bench for fetchPacketFromCacheOrDownload tests" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>
			];

			(* set up containers *)
			{
				container,
				container2
			} = ECL`InternalUpload`UploadSample[
				{
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"]
				},
				{
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench}
				},
				Status -> Available,
				Name -> {
					"fetchPacketFromCacheOrDownload test container 1" <> $SessionUUID,
					"fetchPacketFromCacheOrDownload test container 2" <> $SessionUUID
				}
			];

			(*set up samples*)
			{
				sample,
				sample2
			} = ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, StockSolution, "70% Ethanol"]
				},
				{
					{"A1", container},
					{"A1", container2}
				},
				InitialAmount -> {
					1 Milliliter,
					1 Milliliter
				},
				Name -> {
					"fetchPacketFromCacheOrDownload test sample 1" <> $SessionUUID,
					"fetchPacketFromCacheOrDownload test sample 2" <> $SessionUUID
				}
			];

			Upload[Flatten[{
				<|
					Object -> sample2,
					Replace[Analytes] -> {
						Link[Model[Molecule, "Water"]],
						Link[Model[Molecule, "Ethanol"]]
					}
				|>,
				<|Object -> #, DeveloperObject -> True|> & /@ Cases[Flatten[{container, container2, sample, sample2}], ObjectP[]]
			}]];
		]
	}
];


(* ::Section::Closed:: *)
(*End Test Package*)
