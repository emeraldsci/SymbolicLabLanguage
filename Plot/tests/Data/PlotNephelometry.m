(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotNephelometry*)


(* ::Subsection::Closed:: *)
(*PlotNephelometry*)


DefineTests[PlotNephelometry,{

	Example[
		{Basic,"Plot the results of an ExperimentNephelometry using a protocol object as input:"},
		PlotNephelometry[Object[Protocol,Nephelometry,"PlotNephelometry Test Protocol with data"<>$SessionUUID]],
		{ValidGraphicsP[]..}
	],

	Example[
		{Basic,"Plot the results of an Nephelometry using a data object as input:"},
		PlotNephelometry[Object[Data,Nephelometry,"PlotNephelometry Test Data"<>$SessionUUID]],
		ValidGraphicsP[]
	],

	Example[
		{Messages,"PlotNephelometryObjectNotFound","An error will be shown if the specified input cannot be found in the database:"},
		PlotNephelometry[
			Object[Protocol,Nephelometry,"Not In Database For Sure"<>$SessionUUID]
		],
		$Failed,
		Messages:>Error::PlotNephelometryObjectNotFound
	],

	Example[
		{Messages,"PlotNephelometryNoData","An error will be shown if the specified protocol object has no associated data object:"},
		PlotNephelometry[
			Object[Protocol,Nephelometry,"Nephelometry Protocol Without Data"<>$SessionUUID]
		],
		$Failed,
		Messages:>Error::PlotNephelometryNoData
	],

	Example[
		{Messages,"PlotNephelometryNoAssociatedProtocol","A warning will be shown if the specified data object has no associated protocol object:"},
		PlotNephelometry[
			Object[Data,Nephelometry,"Nephelometry Data Without Protocol"<>$SessionUUID]
		],
		Null,
		Messages:>{Warning::PlotNephelometryNoAssociatedProtocol,Error::PlotNephelometryNoInputConc}
	],

	Example[
		{Messages,"PlotNephelometryNoInputConc","An error is thrown if neither dilutions nor input concentration is set:"},
		PlotNephelometry[
			Object[Data,Nephelometry,"PlotNephelometry Test Data no Input Conc"<>$SessionUUID]
		],
		Null,
		Messages:>{Error::PlotNephelometryNoInputConc}
	]
},
	SymbolSetUp:>{
		Module[{namedObjects,existsFilter, testData},

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Test objects we will create *)
			namedObjects={
				Object[Protocol,Nephelometry,"Nephelometry Protocol Without Data"<>$SessionUUID],
				Object[Data,Nephelometry,"Nephelometry Data Without Protocol"<>$SessionUUID],
				Object[Protocol,Nephelometry,"PlotNephelometry Test Protocol with data"<>$SessionUUID],
				Object[Protocol,Nephelometry,"PlotNephelometry Test Protocol with bad data"<>$SessionUUID]
				Object[Data,Nephelometry,"PlotNephelometry Test Data"<>$SessionUUID],
				Object[Data,Nephelometry,"PlotNephelometry Test Data no Input Conc"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];

			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];

			(* Upload the objects *)
			Upload[
				{
					<|
						Type->Object[Protocol,Nephelometry],
						Name->"Nephelometry Protocol Without Data"<>$SessionUUID,
						DeveloperObject->True
					|>,
					<|
						Type->Object[Data,Nephelometry],
						Name->"Nephelometry Data Without Protocol"<>$SessionUUID,
						DeveloperObject->True
					|>,
					<|
						Type->Object[Protocol,Nephelometry],
						Name->"PlotNephelometry Test Protocol with data"<>$SessionUUID,
						DeveloperObject->True
					|>,
					<|
						Type->Object[Protocol,Nephelometry],
						Name->"PlotNephelometry Test Protocol with bad data"<>$SessionUUID,
						DeveloperObject->True
					|>
				}
			];

			Upload[
				{
					<|
						Type->Object[Data,Nephelometry],
						Name->"PlotNephelometry Test Data"<>$SessionUUID,
						Protocol -> Link[Object[Protocol,Nephelometry, "PlotNephelometry Test Protocol with data"<>$SessionUUID], Data],
						Replace[Wells] -> "A1",
						Replace[Turbidities] -> {10000 RelativeNephelometricUnit},
						InputConcentration -> 10 Micromolar,
						DeveloperObject->True
					|>,
					<|
						Type->Object[Data,Nephelometry],
						Name->"PlotNephelometry Test Data no Input Conc"<>$SessionUUID,
						Protocol -> Link[Object[Protocol,Nephelometry, "PlotNephelometry Test Protocol with bad data"<>$SessionUUID], Data],
						Replace[Wells] -> "A1",
						Replace[Turbidities] -> {10000 RelativeNephelometricUnit},
						DeveloperObject->True
					|>
				}
			];

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
