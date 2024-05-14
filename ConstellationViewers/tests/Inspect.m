(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*PlotData: Tests*)


(* ::Section:: *)
(*Unit Testing*)

DefineTests[
	TwelveHourDateString,
	{
		Example[{Basic,"Prints out tasks from \"Sample Preparation\" with new UUIDs:"},
			TwelveHourDateString[DateObject[List[2022, 4, 26, 14, 35, 49.334739`8.445727810752373], "Instant", "Gregorian", -7.`]],
			"Tuesday 26 April 2022 02:35:49 pm"
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*Inspect*)

DefineTests[Inspect,
	{
		Example[{Basic, "Inspect the database entry for NMR Data:"},
			Inspect[Object[Data, NMR, "id:aXRlGnZm8OK9"]],
			_DynamicModule,
			TimeConstraint -> 1000
		],
		Example[{Basic, "Inspect the database entry for an HPLC Protocol:"},
			Inspect[Object[Protocol, HPLC, "id:XnlV5jma11aM"]],
			_DynamicModule,
			TimeConstraint -> 1000
		],
		Example[{Basic, "Inspect the database structure for an oligomer molecule:"},
			Inspect[Model[Molecule, Oligomer]],
			_Grid,
			TimeConstraint -> 1000
		],
		Example[{Basic, "Inspect the database entry for an oligomer sample:"},
			Inspect[Object[Sample, "id:o1k9jAKpkA0G"]],
			_DynamicModule,
			TimeConstraint -> 1000
		],
		Example[{Additional, "Inspect the database entry for Chromatography data:"},
			Inspect[Object[Data, Chromatography, "id:mnk9jO3dkpeK"]],
			_DynamicModule,
			TimeConstraint -> 1000
		],
		Example[{Additional, "Inspect the database entry for a literature reference:"},
			Inspect[Object[Report, Literature, "id:4pO6dMWKNJPw"]],
			_DynamicModule,
			TimeConstraint -> 1000
		],
		Example[{Additional, "Inspect works on packets as well as objects:"},
			Inspect[Download[Object[Data, Chromatography, "id:mnk9jO3dkpeK"]]],
			_DynamicModule,
			TimeConstraint -> 1000
		],
		Example[{Additional, "As well as on Links:"},
			Inspect[Link[Object[Data, Chromatography, "id:mnk9jO3dkpeK"], ChromatogramPeaksAnalyses, "Vrbp1jK4z1rE"]],
			_DynamicModule,
			TimeConstraint -> 1000
		],
		Example[{Options, Abstract, "Show only the abstract fields (sans the plot) using the Abstract option:"},
			Inspect[Object[Data, Chromatography, "id:mnk9jO3dkpeK"], Abstract -> True],
			_DynamicModule,
			TimeConstraint -> 1000
		],
		Example[{Options, Abstract, "Shows only the abstract field definitions:"},
			Inspect[Object[Data, Chromatography], Abstract -> True],
			_Grid,
			TimeConstraint -> 1000
		],
		Example[{Options, Date, "Inspect the state of the object at a specified date and time:"},
			Inspect[Object[Data, Chromatography, "id:mnk9jO3dkpeK"], Date -> (Now - 2 Day)],
			_DynamicModule,
			TimeConstraint -> 1000
		],
		Example[{Options, Developer, "Reveal the hidden developer fields using the developer option:"},
			Inspect[Object[Data, Chromatography, "id:mnk9jO3dkpeK"], Developer -> True],
			_DynamicModule,
			TimeConstraint -> 1000
		],
		Example[{Options, Developer, "Reveal the hidden developer fields in the definitions:"},
			Inspect[Object[Data, Chromatography], Developer -> True],
			_Grid,
			TimeConstraint -> 1000
		],
		Example[{Options, Developer, "Automatic developer option resolves to True when the logged in user is a Developer:"},
			Inspect[Object[Protocol, DNASynthesis, "id:lYq9jRzZnGK3"]],
			_DynamicModule,
			TimeConstraint -> 1000,
			Stubs :> {
				$PersonID=Object[User, Emerald, Developer, "id:E8zoYvNLok4N"]
			}
		],
		Example[{Options, Developer, "Automatic developer option resolves to False when the logged in user is not a Developer:"},
			Inspect[Object[Protocol, DNASynthesis, "id:lYq9jRzZnGK3"]],
			_DynamicModule,
			TimeConstraint -> 1000,
			Stubs :> {
				$PersonID=Object[User, Emerald, "id:1ZA60vLNPVEM"]
			}
		],
		Example[{Options, Developer, "Automated developer option resolution is overridden by option specification:"},
			Inspect[Object[Protocol, DNASynthesis, "id:lYq9jRzZnGK3"], Developer -> False],
			_DynamicModule,
			TimeConstraint -> 1000,
			Stubs :> {
				$PersonID=Object[User, Emerald, Developer, "id:E8zoYvNLok4N"]
			}
		],
		Example[{Options, TimeConstraint, "Using the TimeConstraint option will leave fields unevaluated when taking longer then the provided TimeConstraint to evaluate:"},
			Inspect[Object[Report, Literature, "id:4pO6dMWKNJPw"], TimeConstraint -> 1 Second],
			_DynamicModule,
			TimeConstraint -> 1000
		],
		Example[{Messages, "TooManyObjects", "Fails if too many objects are passed:"},
			Inspect[{$PersonID, $PersonID, $PersonID, $PersonID, $PersonID, $PersonID, $PersonID, $PersonID, $PersonID, $PersonID, $PersonID}],
			$Failed,
			Messages :> {Inspect::TooManyObjects},
			Stubs :> {
				$PersonID=Object[User, Emerald, Developer, "id:E8zoYvNLok4N"]
			}
		],
		Test["Inspect properly removes columns from named multiple field when all their values are Null:",
			Inspect[Object[Analysis, Peaks, "id:54n6evLEdPk7"]],
			_DynamicModule,
			TimeConstraint -> 1000,
			Stubs :> {
				$PersonID=Object[User, Emerald, Developer, "id:E8zoYvNLok4N"]
			}
		],
		Test["Inspect properly removes columns from named multiple field where some columns are null:",
			Inspect[Object[Protocol, ThermalShift, "id:E8zoYvNmOPNN"]],
			_DynamicModule,
			TimeConstraint -> 1000,
			Stubs :> {
				$PersonID=Object[User, Emerald, Developer, "id:E8zoYvNLok4N"]
			}
		],
		Test["Inspect does not throw a warning when a large byte array field is not downloaded:",
			Inspect[Object[Data, Chromatography, "id:Y0lXejMkMGAa"]],
			_DynamicModule,
			TimeConstraint -> 1000,
			Stubs :> {
				$PersonID=Object[User, Emerald, Developer, "id:E8zoYvNLok4N"]
			}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*evaluationButton*)

DefineTests[evaluationButton,
	{
		Example[
			{Basic, "Create a button turns into the result of the given expression when clicked:"},
			evaluationButton[ListPlot[RandomReal[{-1, 1}, {10, 2}]]],
			_DynamicModule
		],
		Example[
			{Basic, "Create a button turns into the result of the given expression when clicked:"},
			evaluationButton[Print[{1, 2, 3, 4, 5}];"Printing:"],
			_DynamicModule
		],
		Example[
			{Basic, "Create a button turns into the result of the given expression when clicked:"},
			evaluationButton[Name /. Download[Object[User, Emerald, Developer, "brad"]]],
			_DynamicModule
		]
	}];
