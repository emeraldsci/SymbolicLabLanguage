(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotNephelometryKinetics*)


(* ::Subsection::Closed:: *)
(*PlotNephelometryKinetics*)


DefineTests[PlotNephelometryKinetics,{

	Example[
		{Basic,"Plot the results of an NephelometryKinetics using a data object as input:"},
		PlotNephelometryKinetics[Object[Data,NephelometryKinetics,"PlotNephelometryKinetics Test Data"]],
		ValidGraphicsP[]
	],

	Example[
		{Basic,"Plot the results of an NephelometryKinetics using several data objects as input:"},
		PlotNephelometryKinetics[{Object[Data, NephelometryKinetics, "PlotNephelometryKinetics Test Data"],Object[Data,NephelometryKinetics,"PlotNephelometryKinetics Test Data"]}],
		ValidGraphicsP[]
	],

	Example[
		{Options,PlotType,"PlotType can be specified:"},
		PlotNephelometryKinetics[Object[Data,NephelometryKinetics,"PlotNephelometryKinetics Test Dilutions and Blanks Data"],PlotType->ListLinePlot],
		ValidGraphicsP[]
	],

	Example[
		{Options,DataType,"DataType can be specified:"},
		PlotNephelometryKinetics[Object[Data,NephelometryKinetics,"PlotNephelometryKinetics Test Dilutions and Blanks Data"],DataType->DilutedConcentrationTurbidity],
		ValidGraphicsP[]
	],

	Example[
		{Messages,"PlotNephelometryKineticsObjectNotFound","An error will be shown if the specified input cannot be found in the database:"},
		PlotNephelometryKinetics[
			Object[Data,NephelometryKinetics,"Not In Database For Sure"]
		],
		$Failed,
		Messages:>Error::PlotNephelometryKineticsObjectNotFound
	],

	Example[
		{Messages,"PlotNephelometryKineticsNoAssociatedObject","A error will be shown if the specified data object has no associated protocol object:"},
		PlotNephelometryKinetics[
			Object[Data,NephelometryKinetics,"NephelometryKinetics Data Without Protocol"]
		],
		$Failed,
		Messages:>Error::PlotNephelometryKineticsNoAssociatedObject
	],

	Example[
		{Messages,"Data2D","A warning will be shown if the specified data object has no dilutions data and cannot be plotted with a 3D data type:"},
		PlotNephelometryKinetics[
			Object[Data,NephelometryKinetics,"PlotNephelometryKinetics Test Data"],
			PlotType->ContourPlot
		],
		ValidGraphicsP[],
		Messages:>Warning::Data2D
	],

	Example[
		{Messages,"PlotNephelometryKineticsDataTypeNotAvailable","An error will be shown if the specified input does not have dilutions data, but a dilutions DataType was specified:"},
		PlotNephelometryKinetics[
			Object[Data,NephelometryKinetics,"PlotNephelometryKinetics Test Data"],
			DataType->DilutedConcentrationTurbidityTrajectory
		],
		$Failed,
		Messages:>Error::PlotNephelometryKineticsDataTypeNotAvailable
	],

	Example[
		{Messages,"PlotNephelometryKineticsDataTypeNotAvailable","An error will be shown if the specified input does not have blank data, but an unblanked DataType was specified:"},
		PlotNephelometryKinetics[
			Object[Data,NephelometryKinetics,"PlotNephelometryKinetics Test Data"],
			DataType->UnblankedTurbidityTrajectory
		],
		$Failed,
		Messages:>Error::PlotNephelometryKineticsDataTypeNotAvailable
	]

	(* TODO add tests for options, plot dilutions and blanks data *)
	
},
	SymbolSetUp:>{
		Module[{namedObjects,existsFilter, fakeBench, emptyTestContainer, testSampleContainerObject},

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Test objects we will create *)
			namedObjects={
				Object[Container, Bench,"Fake bench for PlotNephelometryKinetics tests"],
				Object[Container,Plate,"PlotNephelometryKinetics test 96-well plate 1"],
				Object[Sample,"PlotNephelometryKinetics test blank sample 1"],
				Object[Protocol,NephelometryKinetics,"NephelometryKinetics Protocol Without Data"],
				Object[Data,NephelometryKinetics,"NephelometryKinetics Data Without Protocol"],
				Object[Protocol,NephelometryKinetics,"PlotNephelometryKinetics Test Protocol with data"],
				Object[Data,NephelometryKinetics,"PlotNephelometryKinetics Test Data"],
				Object[Protocol,NephelometryKinetics,"PlotNephelometryKinetics Test Protocol with dilutions and blanks data"],
				Object[Data, NephelometryKinetics,"PlotNephelometryKinetics Test Dilutions and Blanks Data"]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];

			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];

			(*fakeBench = Upload[
				<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Fake bench for PlotNephelometryKinetics tests",
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>
			];*)

			(*Make some empty test container objects*)
			(*emptyTestContainer=UploadSample[
				Model[Container, Plate, "96-well UV-Star Plate"],
				{"Work Surface", fakeBench},
				Status -> Available,
				Name -> "PlotNephelometryKinetics test 96-well plate 1"
			];*)

			(*Make some test sample objects in the test container objects*)
			(*testSampleContainerObject=UploadSample[
				Model[Sample,"Milli-Q water"], 
				{"A1",Object[Container,Plate,"PlotNephelometryKinetics test 96-well plate 1"]},
				Name-> "PlotNephelometryKinetics test blank sample 1",
				InitialAmount->200*Microliter
			];*)

			(* Upload the objects *)
			Upload[
				{
					<|
						Type->Object[Protocol,NephelometryKinetics],
						Name->"NephelometryKinetics Protocol Without Data",
						DeveloperObject->True
					|>,
					<|
						Type->Object[Data,NephelometryKinetics],
						Name->"NephelometryKinetics Data Without Protocol",
						DeveloperObject->True
					|>,
					<|
						Type->Object[Protocol,NephelometryKinetics],
						Name->"PlotNephelometryKinetics Test Protocol with data",
						DeveloperObject->True
					|>,
					<|
						Type->Object[Protocol,NephelometryKinetics],
						Name->"PlotNephelometryKinetics Test Protocol with dilutions and blanks data",
						Replace[Blanks]->Link[Model[Sample,"Milli-Q water"]],
						DeveloperObject->True
					|>
				}
			];

			Upload[{
				<|
					Type -> Object[Data, NephelometryKinetics],
					Name -> "PlotNephelometryKinetics Test Data",
					Protocol -> Link[Object[Protocol, NephelometryKinetics, "PlotNephelometryKinetics Test Protocol with data"], Data],
					Replace[Wells] -> "A1",
					Replace[TurbidityTrajectories] -> QuantityArray[{{0, 100000}, {20, 100000}, {40, 1000000}}, {Second, RelativeNephelometricUnit}],
					InputConcentration -> 10Micromolar,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Data, NephelometryKinetics],
					Name -> "PlotNephelometryKinetics Test Dilutions and Blanks Data",
					Protocol -> Link[Object[Protocol, NephelometryKinetics, "PlotNephelometryKinetics Test Protocol with dilutions and blanks data"], Data],
					Replace[Dilutions]->{
						{Quantity[250, "Microliters"], Quantity[30, "Microliters"]}, 
						{Quantity[200, "Microliters"], Quantity[60, "Microliters"]}, 
						{Quantity[150, "Microliters"], Quantity[90, "Microliters"]}, 
						{Quantity[100, "Microliters"], Quantity[120, "Microliters"]}
					},
					Replace[Wells]->{"B2", "B3", "B4", "B5"},
					Replace[InputDilutedConcentrations]->{400Micromolar,200Micromolar,100Micromolar,50Micromolar},
					Replace[UnblankedTurbidityTrajectories]->{
						StructuredArray[QuantityArray, {4, 2}, StructuredArray`StructuredData[QuantityArray, {{0, 1.992079*^6}, {20, 2.000111*^6}, {40, 2.00011*^6}, {60, 2.00011*^6}}, {"Seconds", IndependentUnit["RelativeNephelometricUnits"]}, {{1}, {2}}]],
						StructuredArray[QuantityArray, {4, 2}, StructuredArray`StructuredData[QuantityArray, {{0, 2.00011*^6}, {20, 2.00011*^6}, {40, 2.00011*^6}, {60, 2.000111*^6}}, {"Seconds", IndependentUnit["RelativeNephelometricUnits"]}, {{1}, {2}}]],
						StructuredArray[QuantityArray, {4, 2}, StructuredArray`StructuredData[QuantityArray, {{0, 1.969719*^6}, {20, 2.00011*^6}, {40, 1.997022*^6}, {60, 2.00011*^6}}, {"Seconds", IndependentUnit["RelativeNephelometricUnits"]}, {{1}, {2}}]],
						StructuredArray[QuantityArray, {4, 2}, StructuredArray`StructuredData[QuantityArray, {{0, 1.788153*^6}, {20, 1.692146*^6}, {40, 1.684568*^6}, {60, 1.673248*^6}}, {"Seconds", IndependentUnit["RelativeNephelometricUnits"]}, {{1}, {2}}]]
					},
					Replace[TurbidityTrajectories]->{
						StructuredArray[QuantityArray, {4, 2}, StructuredArray`StructuredData[QuantityArray, {{0, 1.984494*^6}, {20, 1.992505*^6}, {40, 1.992468*^6}, {60, 1.992503*^6}}, {"Seconds", IndependentUnit["RelativeNephelometricUnits"]}, {{1}, {2}}]],
						StructuredArray[QuantityArray, {4, 2}, StructuredArray`StructuredData[QuantityArray, {{0, 1.992525*^6}, {20, 1.992504*^6}, {40, 1.992468*^6}, {60, 1.992504*^6}}, {"Seconds", IndependentUnit["RelativeNephelometricUnits"]}, {{1}, {2}}]],
						StructuredArray[QuantityArray, {4, 2}, StructuredArray`StructuredData[QuantityArray, {{0, 1.962134*^6}, {20, 1.992504*^6}, {40, 1.98938*^6}, {60, 1.992503*^6}}, {"Seconds", IndependentUnit["RelativeNephelometricUnits"]}, {{1}, {2}}]],
						StructuredArray[QuantityArray, {4, 2}, StructuredArray`StructuredData[QuantityArray, {{0, 1.780568*^6}, {20, 1.68454*^6}, {40, 1.676926*^6}, {60, 1.665641*^6}}, {"Seconds", IndependentUnit["RelativeNephelometricUnits"]}, {{1}, {2}}]]
					},
					Replace[Temperatures]->{
						StructuredArray[QuantityArray, {4, 2}, StructuredArray`StructuredData[QuantityArray, {{0, 25}, {20, 25}, {40, 25}, {60, 25}}, {"Seconds", "DegreesCelsius"}, {{1}, {2}}]],
						StructuredArray[QuantityArray, {4, 2}, StructuredArray`StructuredData[QuantityArray, {{0, 25}, {20, 25}, {40, 25}, {60, 25}}, {"Seconds", "DegreesCelsius"}, {{1}, {2}}]],
						StructuredArray[QuantityArray, {4, 2}, StructuredArray`StructuredData[QuantityArray, {{0, 25}, {20, 25}, {40, 25}, {60, 25}}, {"Seconds", "DegreesCelsius"}, {{1}, {2}}]],
						StructuredArray[QuantityArray, {4, 2}, StructuredArray`StructuredData[QuantityArray, {{0, 25}, {20, 25}, {40, 25}, {60, 25}}, {"Seconds", "DegreesCelsius"}, {{1}, {2}}]]
					},
					InputConcentration -> 800Micromolar,
					DeveloperObject -> True
				|>
			}];

		]
	},

	SymbolTearDown:>{

		(* Erase all created objects *)
		EraseObject[$CreatedObjects,Force->True,Verbose->False];

		(* Unset $CreatedObjects *)
		$CreatedObjects=.;
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];