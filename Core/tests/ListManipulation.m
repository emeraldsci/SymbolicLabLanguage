(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Title:: *)
(*Verbose: Tests*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*FirstOrDefault*)

DefineTests[
	FirstOrDefault,
	{
		Example[{Basic, "Returns the first element of a list:"},
			FirstOrDefault[{1, 2, 3}],
			1
		],

		Example[{Basic, "Returns Null if expression is of length 0 and no default value given:"},
			FirstOrDefault[{}],
			Null
		],

		Example[{Basic, "Returns default value if expression is of length 0:"},
			FirstOrDefault[{}, 2000],
			2000
		],

		Example[{Additional, "Operates on the Values of Associations:"},
			FirstOrDefault[<|1 -> 2, 4 -> 6|>],
			2
		],

		Example[{Additional, "Operates on arbitrary expressions:"},
			FirstOrDefault[Taco[1, 2, 3]],
			1
		],

		Test["Does not throw a message is given an Atom:",
			FirstOrDefault[1, 20],
			20
		]
	}
];

(* ::Subsection::Closed:: *)
(*LastOrDefault*)

DefineTests[
	LastOrDefault,
	{
		Example[{Basic, "Returns the last element of a list:"},
			LastOrDefault[{1, 2, 3}],
			3
		],

		Example[{Basic, "Returns Null if expression is of length 0 and no default value given:"},
			LastOrDefault[{}],
			Null
		],

		Example[{Basic, "Returns default value if expression is of length 0:"},
			LastOrDefault[{}, 2000],
			2000
		],

		Example[{Additional, "Operates on the Values of Associations:"},
			LastOrDefault[<|1 -> 2, 4 -> 6|>],
			6
		],

		Example[{Additional, "Operates on arbitrary expressions:"},
			LastOrDefault[Taco[1, 2, 3]],
			3
		],

		Test["Does not throw a message is given an Atom:",
			LastOrDefault[1, 20],
			20
		]
	}
];

(* ::Subsection::Closed:: *)
(*MostOrDefault*)

DefineTests[
	MostOrDefault,
	{
		Example[{Basic, "Returns the list with the last element removed:"},
			MostOrDefault[{1, 2, 3}],
			{1, 2}
		],

		Example[{Basic, "Returns Null if expression is of length 0 and no default value given:"},
			MostOrDefault[{}],
			Null
		],

		Example[{Basic, "Returns default value if expression is of length 0:"},
			MostOrDefault[{}, 2000],
			2000
		],

		Example[{Additional, "Operates on Associations:"},
			MostOrDefault[<|1 -> 2, 4 -> 6|>],
			_Association?(And[
				Length[#] == 1,
				#[1] == 2
			]&)
		],

		Example[{Additional, "Operates on arbitrary expressions:"},
			MostOrDefault[Taco[1, 2, 3]],
			Taco[1, 2]
		],

		Test["Does not throw a message is given an Atom:",
			MostOrDefault[1, 20],
			20
		]
	}
];

(* ::Subsection::Closed:: *)
(*RestOrDefault*)

DefineTests[
	RestOrDefault,
	{
		Example[{Basic, "Returns the list with the first element removed:"},
			RestOrDefault[{1, 2, 3}],
			{2, 3}
		],

		Example[{Basic, "Returns Null if expression is of length 0 and no default value given:"},
			RestOrDefault[{}],
			Null
		],

		Example[{Basic, "Returns default value if expression is of length 0:"},
			RestOrDefault[{}, 2000],
			2000
		],

		Example[{Additional, "Operates on Associations:"},
			RestOrDefault[<|1 -> 2, 4 -> 6|>],
			_Association?(And[
				Length[#] == 1,
				#[4] == 6
			]&)
		],

		Example[{Additional, "Operates on arbitrary expressions:"},
			RestOrDefault[Taco[1, 2, 3]],
			Taco[2, 3]
		],

		Test["Does not throw a message is given an Atom:",
			RestOrDefault[1, 20],
			20
		]
	}
];


(* ::Subsection::Closed:: *)
(*DeleteNestedDuplicates*)

DefineTests[
	DeleteNestedDuplicates,
	{
		Example[
			{Basic, "Delete duplicate non-list elements to arbitrary depth:"},
			DeleteNestedDuplicates[{{1, 2, 3}, {3, 4, 5}, {6, 7, 1}}],
			{{1, 2, 3}, {4, 5}, {6, 7}}
		],
		Example[
			{Basic, "Duplicates are ordered depth-first and all but the first instance are removed:"},
			DeleteNestedDuplicates[{{1, 2}, 1}],
			{{1, 2}}
		],
		Example[
			{Basic, "Lists with no duplicate items are returned unmodified:"},
			DeleteNestedDuplicates[{{"taco", "cat"}, {"aman", "aplan", "acanal", "panama"}}],
			{{"taco", "cat"}, {"aman", "aplan", "acanal", "panama"}}
		],
		Example[
			{Additional, "An empty list is left if the last item in a given list is deleted:"},
			DeleteNestedDuplicates[{{"thing1", "thing2"}, {"thing1"}}],
			{{"thing1", "thing2"}, {}}
		]
	}
];

(* ::SubSection:: *)
(* ParseLog *)
DefineTests[
	ParseLog,
	{
		Example[{Basic,"Return a list of times an instrument spent in each status to the present time, downloading from the object:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog
			],
			AssociationMatchP[
				<|
					Available->EqualP[17.75 Hour],
					Running->EqualP[50.5 Hour]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Options,StartDate,"Specify the beginning of the time period over which you want to analyze the log:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				StartDate->DateObject[{2020,8,11,12,0,0},"Instant","Gregorian",-7.]
			],
			AssociationMatchP[
				<|
					Available->EqualP[1.25 Hour],
					Running->EqualP[26.75 Hour]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Options,EndDate,"Specify the end of the time period over which you want to analyze the log:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				EndDate->DateObject[{2020,8,11,12,0,0},"Instant","Gregorian",-7.]
			],
			AssociationMatchP[
				<|
					Available->EqualP[16.5 Hour],
					Running->EqualP[23.75 Hour]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Options,Units,"Specify the units to output times in:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				Units->Hour
			],
			AssociationMatchP[
				<|
					Available->17.75 Hour,
					Running->50.5 Hour
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Options,OutputFormat,"Specify the format of the output to return a list of the statuses that occurred during the time period:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				OutputFormat->List
			],
			{Available,Running},
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Options,OutputFormat,"Specify the format of the output to return an association of the times spent in each status that occurred during the time period:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				OutputFormat->Times
			],
			AssociationMatchP[
				<|
					Available->EqualP[17.75 Hour],
					Running->EqualP[50.5 Hour]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Options,OutputFormat,"Specify the format of the output to return an association of the time percent spent in each status that occurred during the time period:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				OutputFormat->Percent
			],
			AssociationMatchP[
				<|
					Available->EqualP[26.01 Percent],
					Running->EqualP[73.99 Percent]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Options,OutputFormat,"Specify the format of the output to return a list of date ranges spent in each status that occurred during the time period:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				OutputFormat->DateRange
			],
			AssociationMatchP[
				<|
					Available->{
						{EqualP[DateObject[{2020,8,9,19,45,0},"Instant","Gregorian",-7.]],EqualP[DateObject[{2020,8,9,20,0,0},"Instant","Gregorian",-7.]]},
						{EqualP[DateObject[{2020,8,10,19,45,0},"Instant","Gregorian",-7.]],EqualP[DateObject[{2020,8,11,12,30,0},"Instant","Gregorian",-7.]]},
						{EqualP[DateObject[{2020,8,12,15,15,0},"Instant","Gregorian",-7.]],EqualP[DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]]}
					},
					Running->{
						{EqualP[DateObject[{2020,8,9,20,0,0},"Instant","Gregorian",-7.]],EqualP[DateObject[{2020,8,10,19,45,0},"Instant","Gregorian",-7.]]},
						{EqualP[DateObject[{2020,8,11,12,30,0},"Instant","Gregorian",-7.]],EqualP[DateObject[{2020,8,12,15,15,0},"Instant","Gregorian",-7.]]}
					}
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Options,OutputFormat,"Specify the format of the output to return a pattern that matches the date ranges spent in each status that occurred during the time period:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				OutputFormat->Pattern
			],
			AssociationMatchP[
				<|
					Available->Alternatives[__],
					Running->Alternatives[__]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Options,ClosedLog,"Specify that the final entry in the log closes the log, and therefore it should not be considered to extend until Now:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				ClosedLog->True
			],
			AssociationMatchP[
				<|
					Available->EqualP[17.0 Hour],
					Running->EqualP[50.5 Hour]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Options,DateColumn,"Manually specify the column of the log that contains the dates of the entries:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				DateColumn->1
			],
			AssociationMatchP[
				<|
					Available->EqualP[17.75 Hour],
					Running->EqualP[50.5 Hour]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Options,StatusColumn,"Manually specify the column of the log that contains the status of the entries:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				StatusColumn->2
			],
			AssociationMatchP[
				<|
					Available->EqualP[17.75 Hour],
					Running->EqualP[50.5 Hour]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Options,IdentifierColumn,"Manually specify the column of the log that contains the object or other identifier to group the log entries by:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				IdentifierColumn->2
			],
			AssociationMatchP[
				<|
					Available->EqualP[17.75 Hour],
					Running->EqualP[50.5 Hour]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Options,OutputColumn,"Manually specify the column or columns to analyze the output by:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				OutputColumn->{2,3}
			],
			AssociationMatchP[
				<|
					{Available,$PersonID}->EqualP[15 Minute],
					{Running,protocol1}->EqualP[23.75 Hour],
					{Available,protocol1}->EqualP[16.75 Hour],
					{Running,protocol2}->EqualP[26.75 Hour],
					{Available,protocol2}->EqualP[0.75 Hour]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]},
			SetUp:>{
				(* Convert to ID form *)
				protocol1=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 1 for ParseLog Tests"<>$SessionUUID][ID]],
				protocol2=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 2 for ParseLog Tests"<>$SessionUUID][ID]]
			},
			Variables:>{protocol1,protocol2,protocol3,protocol4}
		],
		Example[{Options,InactiveStatuses,"Specify statuses where that period of time should not be associated with the party that set that status. In this example, parsing the responsible party of a status log, times when the party sets the instrument to Available should not be attributed to that party:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				IdentifierColumn->3,
				OutputColumn->3,
				InactiveStatuses->{Available}
			],
			AssociationMatchP[
				<|
					protocol1->EqualP[23.75 Hour],
					protocol2->EqualP[26.75 Hour]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]},
			SetUp:>{
				(* Convert to ID form *)
				protocol1=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 1 for ParseLog Tests"<>$SessionUUID][ID]],
				protocol2=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 2 for ParseLog Tests"<>$SessionUUID][ID]]
			},
			Variables:>{protocol1,protocol2,protocol3,protocol4}
		],
		Example[{Options,SingleStatus,"Manually specify if the log contains entries for one or more objects, and therefore whether each subsequent line in the log supersedes the previous one:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				SingleStatus->True
			],
			AssociationMatchP[
				<|
					Available->EqualP[17.75 Hour],
					Running->EqualP[50.5 Hour]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Options,CountOverlap,"For multi-status fields, specify whether to attribute overlap periods to all active objects, or only the most recent to set the status. Relevant for operator's ProtocolLogs where they may be in multiple protocols simultaneously because of an interrupt, but are only working on one actively:"},
			ParseLog[
				Object[User,Emerald,Operator,"Test operator 2 for ParseLog Tests"<>$SessionUUID],
				ProtocolLog,
				CountOverlap->True
			],
			AssociationMatchP[
				<|
					protocol1->EqualP[Quantity[1,"Hours"]],
					protocol2->EqualP[Quantity[5,"Hours"]],
					protocol3->EqualP[Quantity[1,"Hours"]],
					protocol4->EqualP[Quantity[1,"Hours"]]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			SetUp:>{
				(* Convert to ID form *)
				protocol1=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 7 for ParseLog Tests"<>$SessionUUID][ID]],
				protocol2=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 8 for ParseLog Tests"<>$SessionUUID][ID]],
				protocol3=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 9 for ParseLog Tests"<>$SessionUUID][ID]],
				protocol4=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 10 for ParseLog Tests"<>$SessionUUID][ID]]
			},
			Variables:>{protocol1,protocol2,protocol3,protocol4}
		],
		Example[{Messages,"InvalidField","Throw an error if the field specified is not one of the fields of the object:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				CatPictureLog
			],
			Null|$Failed,
			Messages:>{ParseLog::InvalidField}
		],
		Example[{Messages,"InvalidLogField","Throw an error if the field specified is not a log field:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				Name
			],
			Null|$Failed,
			Messages:>{ParseLog::InvalidLogField}
		],
		Example[{Messages,"ParseLogCountOverlapConflict","CountOverlap cannot be set to True when the StatusColumn and IdentifierColumn are set to the same thing:"},
			ParseLog[
				Object[User,Emerald,Operator,"Test operator 2 for ParseLog Tests"<>$SessionUUID],
				ProtocolLog,
				StatusColumn->2,
				IdentifierColumn->2,
				CountOverlap->True
			],
			$Failed,
			Messages:>{ParseLog::ParseLogCountOverlapConflict}
		],
		Example[{Additional,"Return a list of times an Instrument spent in each InstrumentStatus, directly providing the contents of the StatusLog field, and specifying all parsing parameters manually:"},
			ParseLog[
				{
					{DateObject[{2020,8,9,19,45,0},"Instant","Gregorian",-7.],Available,Link[Object[User,Emerald,Developer,"id:wqW9BP7Ko5Kw"],"pZx9jo1WkbK4"]},
					{DateObject[{2020,8,9,20,0,0},"Instant","Gregorian",-7.],Running,Link[Object[Protocol,GasChromatography,"id:54n6evLej1zY"],"rea9jldW3EkB"]},
					{DateObject[{2020,8,10,19,45,0},"Instant","Gregorian",-7.],Available,Link[Object[Protocol,GasChromatography,"id:54n6evLej1zY"],"eGakldRnP9rz"]},
					{DateObject[{2020,8,11,12,30,0},"Instant","Gregorian",-7.],Running,Link[Object[Protocol,GasChromatography,"id:P5ZnEjdaYbJ0"],"4pO6dM1lOPMX"]},
					{DateObject[{2020,8,12,15,15,0},"Instant","Gregorian",-7.],Available,Link[Object[Protocol,GasChromatography,"id:P5ZnEjdaYbJ0"],"O81aEBDblGzj"]}
				},
				1,2,2,2,
				True,False,
				{Available}
			],
			AssociationMatchP[
				<|
					Available->EqualP[17.75 Hour],
					Running->EqualP[50.5 Hour]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2020,8,12,16,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Additional,"Return a list of times an Instrument spent in each protocol, directly providing the contents of the StatusLog field, and specifying all parsing parameters manually:"},
			ParseLog[
				{
					{DateObject[{2020,8,9,19,45,0},"Instant","Gregorian",-7.],Available,Link[Object[User,Emerald,Developer,"id:wqW9BP7Ko5Kw"],"pZx9jo1WkbK4"]},
					{DateObject[{2020,8,9,20,0,0},"Instant","Gregorian",-7.],Running,Link[Object[Protocol,GasChromatography,"id:54n6evLej1zY"],"rea9jldW3EkB"]},
					{DateObject[{2020,8,10,19,45,0},"Instant","Gregorian",-7.],Available,Link[Object[Protocol,GasChromatography,"id:54n6evLej1zY"],"eGakldRnP9rz"]},
					{DateObject[{2020,8,11,12,30,0},"Instant","Gregorian",-7.],Running,Link[Object[Protocol,GasChromatography,"id:P5ZnEjdaYbJ0"],"4pO6dM1lOPMX"]},
					{DateObject[{2020,8,12,15,15,0},"Instant","Gregorian",-7.],Available,Link[Object[Protocol,GasChromatography,"id:P5ZnEjdaYbJ0"],"O81aEBDblGzj"]}
				},
				1,2,3,3,
				True,False,
				{Available}
			],
			AssociationMatchP[
				<|
					Object[Protocol,GasChromatography,"id:54n6evLej1zY"]->EqualP[23.75 Hour],
					Object[Protocol,GasChromatography,"id:P5ZnEjdaYbJ0"]->EqualP[26.75 Hour]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			]
		],
		Example[{Additional,"Parse a qualification results log (default parameters):"},
			ParseLog[
				{
					<|Date->DateObject[{2020,11,12,0,0,0},"Instant","Gregorian",-7.],Qualification->Link[Object[Qualification,LCMS,"id:jLq9jXvLv37W"],"jLq9jXX97A5E"],Result->Fail|>,
					<|Date->DateObject[{2020,11,19,0,0,0},"Instant","Gregorian",-7.],Qualification->Link[Object[Qualification,LCMS,"id:XnlV5jKnJqjP"],"7X104vv0MPw9"],Result->Pass|>,
					<|Date->DateObject[{2020,12,16,0,0,0},"Instant","Gregorian",-7.],Qualification->Link[Object[Qualification,LCMS,"id:54n6evL4AwdG"],"N80DNjjDWkMo"],Result->Pass|>,
					<|Date->DateObject[{2021,1,11,0,0,0},"Instant","Gregorian",-7.],Qualification->Link[Object[Qualification,LCMS,"id:BYDOjvGWk0e9"],"vXl9j559R41k"],Result->Pass|>,
					<|Date->DateObject[{2021,2,3,0,0,0},"Instant","Gregorian",-7.],Qualification->Link[Object[Qualification,LCMS,"id:3em6ZvLBWVpV"],"xRO9n339GXMY"],Result->Fail|>,
					<|Date->DateObject[{2021,2,17,0,0,0},"Instant","Gregorian",-7.],Qualification->Link[Object[Qualification,LCMS,"id:J8AY5jDLkpVE"],"6V0npvvnNAo8"],Result->Pass|>,
					<|Date->DateObject[{2021,4,26,0,0,0},"Instant","Gregorian",-7.],Qualification->Link[Object[Qualification,LCMS,"id:Vrbp1jKYAjqW"],"9RdZXvvZa9L6"],Result->Pass|>
				},
				1,3,3,3,
				True,False,
				{}
			],
			AssociationMatchP[
				<|
					Fail->EqualP[21 Day],
					Pass->EqualP[180 Day]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2021,6,1,0,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Additional,"Parse a restricted log (default parameters):"},
			ParseLog[
				{
					{DateObject[{2021,3,12,12,30,0},"Instant","Gregorian",-7.],True,Link[Object[Maintenance,ReceiveInventory,"id:1ZA60vLlOXp5"],"eGakldkrN0Dz"]},
					{DateObject[{2021,3,12,13,53,0},"Instant","Gregorian",-7.],True,Link[Object[Maintenance,ReceiveInventory,"id:1ZA60vLlOXp5"],"aXRlGnlKwjz0"]},
					{DateObject[{2021,3,12,18,7,0},"Instant","Gregorian",-7.],False,Link[Object[Maintenance,ParameterizeContainer,"id:J8AY5jDLEG37"],"n0k9mG9WJxzn"]}
				},
				1,2,2,2,
				True,False,
				{False}
			],
			AssociationMatchP[
				<|
					True->EqualP[337 Minute],
					False->EqualP[353 Minute]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2021,3,13,0,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Additional,"Parse a location log (default parameters):"},
			ParseLog[
				{
					{DateObject[{2021,8,30,22,17,0},"Instant","Gregorian",-7.],Out,Link[Object[Container,OperatorCart,"id:1ZA60vLVONZD"],ContentsLog,3,"Z1lqpM4zm3eM"],"Tray Slot",Link[Object[Maintenance,Clean,Freezer,"id:O81aEBZMDz8N"],"dORYzZlJpeoe"]},
					{DateObject[{2021,8,30,22,17,0},"Instant","Gregorian",-7.],In,Link[Object[Container,Shelf,"id:7X104vK9Arvd"],ContentsLog,3,"eGakldLJ8pzB"],"B1",Link[Object[Maintenance,Clean,Freezer,"id:O81aEBZMDz8N"],"pZx9jor8AlJM"]},
					{DateObject[{2021,9,12,19,57,0},"Instant","Gregorian",-7.],Out,Link[Object[Container,Shelf,"id:7X104vK9Arvd"],ContentsLog,3,"3em6ZvWEvnno"],"B1",Link[Object[Maintenance,Clean,Freezer,"id:pZx9jo8B14Xn"],"D8KAEv7Ov99k"]},
					{DateObject[{2021,9,12,19,57,0},"Instant","Gregorian",-7.],In,Link[Object[Container,OperatorCart,"id:aXRlGn6lo3Vk"],ContentsLog,3,"aXRlGnAwnvvm"],"Tray Slot",Link[Object[Maintenance,Clean,Freezer,"id:pZx9jo8B14Xn"],"wqW9BPmoPnnA"]},
					{DateObject[{2021,9,12,20,38,0},"Instant","Gregorian",-7.],Out,Link[Object[Container,OperatorCart,"id:aXRlGn6lo3Vk"],ContentsLog,3,"XnlV5jewk3ez"],"Tray Slot",Link[Object[Maintenance,Clean,Freezer,"id:pZx9jo8B14Xn"],"qdkmxzbXL5b0"]},
					{DateObject[{2021,9,12,20,38,0},"Instant","Gregorian",-7.],In,Link[Object[Container,Rack,"id:P5ZnEj4PA0EO"],ContentsLog,3,"R8e1Pj7wol7p"],"B1",Link[Object[Maintenance,Clean,Freezer,"id:pZx9jo8B14Xn"],"O81aEB73OA71"]},
					{DateObject[{2021,9,14,0,17,0},"Instant","Gregorian",-7.],Out,Link[Object[Container,Rack,"id:P5ZnEj4PA0EO"],ContentsLog,3,"qdkmxzbmkXmm"],"B1",Link[Object[Maintenance,Clean,Freezer,"id:1ZA60vLqJL30"],"R8e1Pj71ew1j"]},
					{DateObject[{2021,9,14,0,17,0},"Instant","Gregorian",-7.],In,Link[Object[Container,Shelf,"id:1ZA60vwjV0lP"],ContentsLog,3,"O81aEB7a13aO"],"Front Slot",Link[Object[Maintenance,Clean,Freezer,"id:1ZA60vLqJL30"],"GmzlKj7lzolM"]},
					{DateObject[{2021,9,14,0,49,0},"Instant","Gregorian",-7.],Out,Link[Object[Container,Shelf,"id:1ZA60vwjV0lP"],ContentsLog,3,"Y0lXej5XroNV"],"Front Slot",Link[Object[Maintenance,Clean,Freezer,"id:1ZA60vLqJL30"],"kEJ9mqD98xLe"]},
					{DateObject[{2021,9,14,0,49,0},"Instant","Gregorian",-7.],In,Link[Object[Container,Rack,"id:P5ZnEj4PA0EO"],ContentsLog,3,"P5ZnEjBnxp9O"],"B1",Link[Object[Maintenance,Clean,Freezer,"id:1ZA60vLqJL30"],"3em6ZvW6rXno"]},
					{DateObject[{2021,9,27,3,1,0},"Instant","Gregorian",-7.],Out,Link[Object[Container,Rack,"id:P5ZnEj4PA0EO"],ContentsLog,3,"qdkmxzbV1Za4"],"B1",Link[Object[Maintenance,Clean,Freezer,"id:54n6evLAeKEl"],"R8e1Pj7EYNZ4"]},
					{DateObject[{2021,9,27,3,1,0},"Instant","Gregorian",-7.],In,Link[Object[Container,Shelf,"id:7X104vK9A4Bw"],ContentsLog,3,"n0k9mGJ5KnP3"],"Front Slot",Link[Object[Maintenance,Clean,Freezer,"id:54n6evLAeKEl"],"01G6nvWJP9RK"]},
					{DateObject[{2021,9,27,3,25,0},"Instant","Gregorian",-7.],Out,Link[Object[Container,Shelf,"id:7X104vK9A4Bw"],ContentsLog,3,"XnlV5jeapqxo"],"Front Slot",Link[Object[Maintenance,Clean,Freezer,"id:54n6evLAeKEl"],"qdkmxzbVEnW3"]},
					{DateObject[{2021,9,27,3,25,0},"Instant","Gregorian",-7.],In,Link[Object[Container,Shelf,"id:7X104vK9Arvd"],ContentsLog,3,"R8e1Pj7EndxX"],"B1",Link[Object[Maintenance,Clean,Freezer,"id:54n6evLAeKEl"],"n0k9mGJ57jW1"]}
				},
				1,2,3,{3,4},
				True,False,
				{Out}
			],
			AssociationMatchP[
				<|
					{Object[Container,Shelf,"id:7X104vK9Arvd"],"B1"}->EqualP[24135 Minute],
					{Object[Container,OperatorCart,"id:aXRlGn6lo3Vk"],"Tray Slot"}->EqualP[41 Minute],
					{Object[Container,Rack,"id:P5ZnEj4PA0EO"],"B1"}->EqualP[20511 Minute],
					{Object[Container,Shelf,"id:1ZA60vwjV0lP"],"Front Slot"}->EqualP[32 Minute],
					{Object[Container,Shelf,"id:7X104vK9A4Bw"],"Front Slot"}->EqualP[24 Minute]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			Stubs:>{Now=DateObject[{2021,10,1,0,0,0},"Instant","Gregorian",-7.]}
		],
		Example[{Additional,"Parse a connection log by connector:"},
			ParseLog[
				{
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"M8n3rxRxr1vM"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"WNa4ZjkjZOzL"]},
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"54n6evOvelW7"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"n0k9mGEGmvK6"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"7X104vAzPZl6"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"N80DNjOXkwVk"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"vXl9j5rM4n6Z"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"xRO9n3rMX16x"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"XnlV5jVbYrB3"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"qdkmxzmA4YB4"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"R8e1Pj1DA3M4"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"n0k9mG9RdlB3"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"mnk9jO9dDlPK"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"BYDOjvO5AKEk"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"M8n3rx3A5ebO"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"WNa4Zj4D50nE"]}
				},
				1,2,3,3,
				False,False,
				{Disconnect}
			],
			AssociationMatchP[
				<|
					"Column Inlet"->EqualP[3763 Minute],
					"Column Outlet"->EqualP[3763 Minute]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			]
		],
		Example[{Additional,"Parse a connection log by connector directly from the object, using options:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				ConnectionLog,
				OutputColumn->3
			],
			AssociationMatchP[
				<|
					"Column Inlet"->EqualP[3763 Minute],
					"Column Outlet"->EqualP[3763 Minute]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			]
		],
		Example[{Additional,"Parse a connection log by connected object:"},
			ParseLog[
				{
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"M8n3rxRxr1vM"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"WNa4ZjkjZOzL"]},
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"54n6evOvelW7"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"n0k9mGEGmvK6"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"7X104vAzPZl6"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"N80DNjOXkwVk"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"vXl9j5rM4n6Z"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"xRO9n3rMX16x"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"XnlV5jVbYrB3"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"qdkmxzmA4YB4"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"R8e1Pj1DA3M4"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"n0k9mG9RdlB3"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"mnk9jO9dDlPK"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"BYDOjvO5AKEk"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"M8n3rx3A5ebO"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"WNa4Zj4D50nE"]}
				},
				1,2,4,4,
				False,False,
				{Disconnect}
			],
			AssociationMatchP[
				<|
					Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"]->EqualP[2692 Minute],
					Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"]->EqualP[3763 Minute],
					Object[Item,Column,"id:GmzlKjP36vBN"]->EqualP[1071 Minute]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			]
		],
		Example[{Additional,"Parse a connection log by connected object directly from the object, using options:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				ConnectionLog,
				OutputColumn->4,
				IdentifierColumn->4
			],
			AssociationMatchP[
				<|
					tubing1->EqualP[2692 Minute],
					tubing2->EqualP[3763 Minute],
					column->EqualP[1071 Minute]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			SetUp:>{
				tubing1=Object[Plumbing,Tubing,Object[Plumbing,Tubing,"Test tubing 1 for ParseLogTests"<>$SessionUUID][ID]],
				tubing2=Object[Plumbing,Tubing,Object[Plumbing,Tubing,"Test tubing 2 for ParseLogTests"<>$SessionUUID][ID]],
				column=Object[Item,Column,Object[Item,Column,"Test column 1 for ParseLogTests"<>$SessionUUID][ID]]
			},
			Variables:>{tubing1,tubing2,column}
		],
		Example[{Additional,"Parse a connection log by connector and connected object (default parameters):"},
			ParseLog[
				{
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"M8n3rxRxr1vM"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"WNa4ZjkjZOzL"]},
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"54n6evOvelW7"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"n0k9mGEGmvK6"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"7X104vAzPZl6"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"N80DNjOXkwVk"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"vXl9j5rM4n6Z"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"xRO9n3rMX16x"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"XnlV5jVbYrB3"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"qdkmxzmA4YB4"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"R8e1Pj1DA3M4"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"n0k9mG9RdlB3"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"mnk9jO9dDlPK"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"BYDOjvO5AKEk"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"M8n3rx3A5ebO"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"WNa4Zj4D50nE"]}
				},
				1,2,3,{3,4},
				False,False,
				{Disconnect}
			],
			AssociationMatchP[
				<|
					{"Column Inlet",Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"]}->EqualP[2692 Minute],
					{"Column Inlet",Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"]}->EqualP[1071 Minute],
					{"Column Outlet",Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"]}->EqualP[2692 Minute],
					{"Column Outlet",Object[Item,Column,"id:GmzlKjP36vBN"]}->EqualP[1071 Minute]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			]
		],
		Example[{Additional,"Parse a connection log by connector and connected object, directly from the object, using default options:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				ConnectionLog
			],
			AssociationMatchP[
				<|
					{"Column Inlet",tubing1}->EqualP[2692 Minute],
					{"Column Inlet",tubing2}->EqualP[1071 Minute],
					{"Column Outlet",tubing2}->EqualP[2692 Minute],
					{"Column Outlet",column}->EqualP[1071 Minute]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			SetUp:>{
				tubing1=Object[Plumbing,Tubing,Object[Plumbing,Tubing,"Test tubing 1 for ParseLogTests"<>$SessionUUID][ID]],
				tubing2=Object[Plumbing,Tubing,Object[Plumbing,Tubing,"Test tubing 2 for ParseLogTests"<>$SessionUUID][ID]],
				column=Object[Item,Column,Object[Item,Column,"Test column 1 for ParseLogTests"<>$SessionUUID][ID]]
			},
			Variables:>{tubing1,tubing2,column}
		],
		Example[{Additional,"Parse a connection log and return a list of connectors used:"},
			ParseLog[
				{
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"M8n3rxRxr1vM"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"WNa4ZjkjZOzL"]},
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"54n6evOvelW7"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"n0k9mGEGmvK6"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"7X104vAzPZl6"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"N80DNjOXkwVk"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"vXl9j5rM4n6Z"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"xRO9n3rMX16x"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"XnlV5jVbYrB3"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"qdkmxzmA4YB4"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"R8e1Pj1DA3M4"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"n0k9mG9RdlB3"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"mnk9jO9dDlPK"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"BYDOjvO5AKEk"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"M8n3rx3A5ebO"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"WNa4Zj4D50nE"]}
				},
				1,2,3,3,
				False,False,
				{Disconnect},
				OutputFormat->List
			],
			{"Column Inlet","Column Outlet"}
		],
		Example[{Additional,"Parse a connection log and return a list of connector used, directly from the object, using options:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				ConnectionLog,
				IdentifierColumn->3,
				OutputColumn->3,
				OutputFormat->List
			],
			{"Column Inlet","Column Outlet"}
		],
		Example[{Additional,"Parse a connection log and return a list of objects connected:"},
			ParseLog[
				{
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"M8n3rxRxr1vM"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"WNa4ZjkjZOzL"]},
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"54n6evOvelW7"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"n0k9mGEGmvK6"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"7X104vAzPZl6"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"N80DNjOXkwVk"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"vXl9j5rM4n6Z"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"xRO9n3rMX16x"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"XnlV5jVbYrB3"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"qdkmxzmA4YB4"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"R8e1Pj1DA3M4"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"n0k9mG9RdlB3"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"mnk9jO9dDlPK"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"BYDOjvO5AKEk"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"M8n3rx3A5ebO"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"WNa4Zj4D50nE"]}
				},
				1,2,4,4,
				False,False,
				{Disconnect},
				OutputFormat->List
			],
			{
				Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],
				Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],
				Object[Item,Column,"id:GmzlKjP36vBN"]
			}
		],
		Example[{Additional,"Parse a connection log and return a list of objects connected, directly from the object, using options:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				ConnectionLog,
				IdentifierColumn->4,
				OutputColumn->4,
				OutputFormat->List
			],
			{
				tubing1,
				tubing2,
				column
			},
			SetUp:>{
				tubing1=Object[Plumbing,Tubing,Object[Plumbing,Tubing,"Test tubing 1 for ParseLogTests"<>$SessionUUID][ID]],
				tubing2=Object[Plumbing,Tubing,Object[Plumbing,Tubing,"Test tubing 2 for ParseLogTests"<>$SessionUUID][ID]],
				column=Object[Item,Column,Object[Item,Column,"Test column 1 for ParseLogTests"<>$SessionUUID][ID]]
			},
			Variables:>{tubing1,tubing2,column}
		],
		Example[{Additional,"Parse a connection log and return a list of objects connected with their ports:"},
			ParseLog[
				{
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"M8n3rxRxr1vM"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"WNa4ZjkjZOzL"]},
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"54n6evOvelW7"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"n0k9mGEGmvK6"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"7X104vAzPZl6"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"N80DNjOXkwVk"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"vXl9j5rM4n6Z"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"xRO9n3rMX16x"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"XnlV5jVbYrB3"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"qdkmxzmA4YB4"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"R8e1Pj1DA3M4"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"n0k9mG9RdlB3"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"mnk9jO9dDlPK"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"BYDOjvO5AKEk"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"M8n3rx3A5ebO"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"WNa4Zj4D50nE"]}
				},
				1,2,4,{4,5},
				False,False,
				{Disconnect},
				OutputFormat->List
			],
			{
				{Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],"Super Flangeless Nut Port"},
				{Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],"Super Flangeless Nut Port"},
				{Object[Item,Column,"id:GmzlKjP36vBN"],"Column Inlet"}
			}
		],
		Example[{Additional,"Parse a connection log and return a list of objects connected with their ports, directly from the object, using options:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				ConnectionLog,
				IdentifierColumn->4,
				OutputColumn->{4,5},
				OutputFormat->List
			],
			{
				{tubing1,"Super Flangeless Nut Port"},
				{tubing2,"Super Flangeless Nut Port"},
				{column,"Column Inlet"}
			},
			SetUp:>{
				tubing1=Object[Plumbing,Tubing,Object[Plumbing,Tubing,"Test tubing 1 for ParseLogTests"<>$SessionUUID][ID]],
				tubing2=Object[Plumbing,Tubing,Object[Plumbing,Tubing,"Test tubing 2 for ParseLogTests"<>$SessionUUID][ID]],
				column=Object[Item,Column,Object[Item,Column,"Test column 1 for ParseLogTests"<>$SessionUUID][ID]]
			},
			Variables:>{tubing1,tubing2,column}
		],
		Example[{Additional,"Parse a connection log by connected object and return the times as percentages over the log time period:"},
			ParseLog[
				{
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"M8n3rxRxr1vM"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"WNa4ZjkjZOzL"]},
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"54n6evOvelW7"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"n0k9mGEGmvK6"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"7X104vAzPZl6"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"N80DNjOXkwVk"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"vXl9j5rM4n6Z"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"xRO9n3rMX16x"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"XnlV5jVbYrB3"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"qdkmxzmA4YB4"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"R8e1Pj1DA3M4"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"n0k9mG9RdlB3"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"mnk9jO9dDlPK"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"BYDOjvO5AKEk"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"M8n3rx3A5ebO"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"WNa4Zj4D50nE"]}
				},
				1,2,4,4,
				False,True,
				{Disconnect},
				OutputFormat->Percent
			],
			AssociationMatchP[
				<|
					Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"]->EqualP[3.89 Percent],
					Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"]->EqualP[5.44 Percent],
					Object[Item,Column,"id:GmzlKjP36vBN"]->EqualP[1.55 Percent]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			]
		],
		Example[{Additional,"Parse a connection log by connected object and return the times as percentages of the log time period, directly from the object, using options:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				ConnectionLog,
				IdentifierColumn->4,
				OutputColumn->4,
				OutputFormat->Percent,
				ClosedLog->True
			],
			AssociationMatchP[
				<|
					tubing1->EqualP[3.89 Percent],
					tubing2->EqualP[5.44 Percent],
					column->EqualP[1.55 Percent]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			SetUp:>{
				tubing1=Object[Plumbing,Tubing,Object[Plumbing,Tubing,"Test tubing 1 for ParseLogTests"<>$SessionUUID][ID]],
				tubing2=Object[Plumbing,Tubing,Object[Plumbing,Tubing,"Test tubing 2 for ParseLogTests"<>$SessionUUID][ID]],
				column=Object[Item,Column,Object[Item,Column,"Test column 1 for ParseLogTests"<>$SessionUUID][ID]]
			},
			Variables:>{tubing1,tubing2,column}
		],
		Example[{Additional,"Parse a connection log by connected object and return the times as patterns:"},
			ParseLog[
				{
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"M8n3rxRxr1vM"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"WNa4ZjkjZOzL"]},
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"54n6evOvelW7"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"n0k9mGEGmvK6"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"7X104vAzPZl6"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"N80DNjOXkwVk"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"vXl9j5rM4n6Z"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"xRO9n3rMX16x"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"XnlV5jVbYrB3"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"qdkmxzmA4YB4"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"R8e1Pj1DA3M4"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"n0k9mG9RdlB3"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"mnk9jO9dDlPK"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"BYDOjvO5AKEk"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"M8n3rx3A5ebO"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"WNa4Zj4D50nE"]}
				},
				1,2,4,4,
				False,False,
				{Disconnect},
				OutputFormat->Pattern
			],
			AssociationMatchP[
				<|
					Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"]->_,
					Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"]->_,
					Object[Item,Column,"id:GmzlKjP36vBN"]->_
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			]
		],
		Example[{Additional,"Parse a connection log by connected object and return the times as patterns, directly from the object, using options:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				ConnectionLog,
				IdentifierColumn->4,
				OutputColumn->4,
				OutputFormat->Pattern
			],
			AssociationMatchP[
				<|
					tubing1->_,
					tubing2->_,
					column->_
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			SetUp:>{
				tubing1=Object[Plumbing,Tubing,Object[Plumbing,Tubing,"Test tubing 1 for ParseLogTests"<>$SessionUUID][ID]],
				tubing2=Object[Plumbing,Tubing,Object[Plumbing,Tubing,"Test tubing 2 for ParseLogTests"<>$SessionUUID][ID]],
				column=Object[Item,Column,Object[Item,Column,"Test column 1 for ParseLogTests"<>$SessionUUID][ID]]
			},
			Variables:>{tubing1,tubing2,column}
		],
		Example[{Additional,"Parse a connection log by connected object and return the times as date ranges:"},
			ParseLog[
				{
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"M8n3rxRxr1vM"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"WNa4ZjkjZOzL"]},
					{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"54n6evOvelW7"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"n0k9mGEGmvK6"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"],ConnectionLog,4,"7X104vAzPZl6"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"N80DNjOXkwVk"]},
					{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"vXl9j5rM4n6Z"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:kEJ9mqRZGvNz"],"xRO9n3rMX16x"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"XnlV5jVbYrB3"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"qdkmxzmA4YB4"]},
					{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"R8e1Pj1DA3M4"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"n0k9mG9RdlB3"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"],ConnectionLog,4,"mnk9jO9dDlPK"],"Super Flangeless Nut Port",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"BYDOjvO5AKEk"]},
					{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[Object[Item,Column,"id:GmzlKjP36vBN"],ConnectionLog,4,"M8n3rx3A5ebO"],"Column Inlet",Link[Object[Protocol,LCMS,"id:4pO6dM5RYaxz"],"WNa4Zj4D50nE"]}
				},
				1,2,4,4,
				False,False,
				{Disconnect},
				OutputFormat->DateRange
			],
			AssociationMatchP[
				<|
					Object[Plumbing,Tubing,"id:AEqRl9Ko6v1R"]->{
						{EqualP[DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.]],EqualP[DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.]]}
					},
					Object[Plumbing,Tubing,"id:kEJ9mqRl70YE"]->{
						{EqualP[DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.]],EqualP[DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.]]},
						{EqualP[DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.]],EqualP[DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.]]}
					},
					Object[Item,Column,"id:GmzlKjP36vBN"]->{
						{EqualP[DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.]],EqualP[DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.]]}
					}
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			]
		],
		Example[{Additional,"Parse a connection log by connected object and return the times as date ranges, directly from the object, using options:"},
			ParseLog[
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				ConnectionLog,
				IdentifierColumn->4,
				OutputColumn->4,
				OutputFormat->DateRange
			],
			AssociationMatchP[
				<|
					tubing1->{
						{EqualP[DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.]],EqualP[DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.]]}
					},
					tubing2->{
						{EqualP[DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.]],EqualP[DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.]]},
						{EqualP[DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.]],EqualP[DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.]]}
					},
					column->{
						{EqualP[DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.]],EqualP[DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.]]}
					}
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			SetUp:>{
				tubing1=Object[Plumbing,Tubing,Object[Plumbing,Tubing,"Test tubing 1 for ParseLogTests"<>$SessionUUID][ID]],
				tubing2=Object[Plumbing,Tubing,Object[Plumbing,Tubing,"Test tubing 2 for ParseLogTests"<>$SessionUUID][ID]],
				column=Object[Item,Column,Object[Item,Column,"Test column 1 for ParseLogTests"<>$SessionUUID][ID]]
			},
			Variables:>{tubing1,tubing2,column}
		],
		Example[{Additional,"Parse a user's protocol log, returning the total times a user has spent in each protocol:"},
			ParseLog[
				Object[User,Emerald,Operator,"Test operator 1 for ParseLog Tests"<>$SessionUUID],
				ProtocolLog
			],
			AssociationMatchP[
				<|
					protocol1->EqualP[Quantity[6.197222222222222`,"Hours"]],
					protocol2->EqualP[Quantity[2.5591666666666666`,"Hours"]],
					protocol3->EqualP[Quantity[94.01666666666667`,"Minutes"]],
					protocol4->EqualP[Quantity[1.4344444444444444`,"Hours"]]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			SetUp:>{
				(* Convert to ID form *)
				protocol1=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 3 for ParseLog Tests"<>$SessionUUID][ID]],
				protocol2=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 4 for ParseLog Tests"<>$SessionUUID][ID]],
				protocol3=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 5 for ParseLog Tests"<>$SessionUUID][ID]],
				protocol4=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 6 for ParseLog Tests"<>$SessionUUID][ID]]
			},
			Variables:>{protocol1,protocol2,protocol3,protocol4}
		],
		Example[{Additional,"Parse a user's protocol log, returning the total time a user has spent in all protocols:"},
			ParseLog[
				Object[User,Emerald,Operator,"Test operator 1 for ParseLog Tests"<>$SessionUUID],
				ProtocolLog,
				OutputColumn->2
			],
			AssociationMatchP[
				<|
					Enter->EqualP[Quantity[705.4666666666666`,"Minutes"]]
				|>,
				AllowForeignKeys->True,
				RequireAllKeys->True
			]
		],
		Example[{Additional,"Parse a user's protocol log, avoiding double-counting any overlap periods where an operator is interrupted by default:"},
			ParseLog[
				Object[User,Emerald,Operator,"Test operator 2 for ParseLog Tests"<>$SessionUUID],
				ProtocolLog
			],
			AssociationMatchP[
				<|
					protocol1->EqualP[Quantity[1,"Hours"]],
					protocol2->EqualP[Quantity[3,"Hours"]],
					protocol3->EqualP[Quantity[1,"Hours"]],
					protocol4->EqualP[Quantity[1,"Hours"]]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			],
			SetUp:>{
				(* Convert to ID form *)
				protocol1=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 7 for ParseLog Tests"<>$SessionUUID][ID]],
				protocol2=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 8 for ParseLog Tests"<>$SessionUUID][ID]],
				protocol3=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 9 for ParseLog Tests"<>$SessionUUID][ID]],
				protocol4=Object[Protocol,Degas,Object[Protocol,Degas,"Test protocol 10 for ParseLog Tests"<>$SessionUUID][ID]]
			},
			Variables:>{protocol1,protocol2,protocol3,protocol4}
		],
		Test["Dates are parsed correctly if the StartDate specified coincides with a log entry:",
			ParseLog[Object[Protocol,Degas,"Test protocol 13 for ParseLog Tests"<>$SessionUUID],
				StatusLog,
				StartDate->DateObject[{2022,9,15,7,33,0},"Instant","Gregorian",-7.]
			],
			AssociationMatchP[
				<|
					OperatorProcessing->EqualP[Quantity[4.016666666666667`,"Hours"]]
				|>,
				AllowForeignKeys->False,
				RequireAllKeys->True
			]
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{
		$CreatedObjects={};

		Module[
			{
				allObjects,existsFilter,
				instrumentIDs,protocolIDs,userIDs,tubingIDs,columnIDs,
				instrumentPackets,protocolPackets,operatorPackets,miscPackets
			},

			allObjects={
				Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
				Object[Protocol,Degas,"Test protocol 1 for ParseLog Tests"<>$SessionUUID],
				Object[Protocol,Degas,"Test protocol 2 for ParseLog Tests"<>$SessionUUID],
				Object[Protocol,Degas,"Test protocol 3 for ParseLog Tests"<>$SessionUUID],
				Object[Protocol,Degas,"Test protocol 4 for ParseLog Tests"<>$SessionUUID],
				Object[Protocol,Degas,"Test protocol 5 for ParseLog Tests"<>$SessionUUID],
				Object[Protocol,Degas,"Test protocol 6 for ParseLog Tests"<>$SessionUUID],
				Object[Protocol,Degas,"Test protocol 7 for ParseLog Tests"<>$SessionUUID],
				Object[Protocol,Degas,"Test protocol 8 for ParseLog Tests"<>$SessionUUID],
				Object[Protocol,Degas,"Test protocol 9 for ParseLog Tests"<>$SessionUUID],
				Object[Protocol,Degas,"Test protocol 10 for ParseLog Tests"<>$SessionUUID],
				Object[Protocol,Degas,"Test protocol 11 for ParseLog Tests"<>$SessionUUID],
				Object[Protocol,Degas,"Test protocol 12 for ParseLog Tests"<>$SessionUUID],
				Object[Protocol,Degas,"Test protocol 13 for ParseLog Tests"<>$SessionUUID],
				Object[User,Emerald,Operator,"Test operator 1 for ParseLog Tests"<>$SessionUUID],
				Object[User,Emerald,Operator,"Test operator 2 for ParseLog Tests"<>$SessionUUID],
				Object[User,Emerald,Operator,"Test operator 3 for ParseLog Tests"<>$SessionUUID],
				Object[User,Emerald,Operator,"Test operator 4 for ParseLog Tests"<>$SessionUUID],
				Object[User,Emerald,Operator,"Test operator 5 for ParseLog Tests"<>$SessionUUID],
				Object[Plumbing,Tubing,"Test tubing 1 for ParseLogTests"<>$SessionUUID],
				Object[Plumbing,Tubing,"Test tubing 2 for ParseLogTests"<>$SessionUUID],
				Object[Item,Column,"Test column 1 for ParseLogTests"<>$SessionUUID]
			};


			(* Erase any objects that we failed to erase in the last unit test. *)
			existsFilter=DatabaseMemberQ[allObjects];

			EraseObject[PickList[allObjects,existsFilter],Force->True,Verbose->False];

			(* Create object IDs *)
			instrumentIDs=CreateID[Repeat[Object[Instrument,SchlenkLine],Count[allObjects,ObjectReferenceP[Object[Instrument,SchlenkLine]]]]];
			protocolIDs=CreateID[Repeat[Object[Protocol,Degas],Count[allObjects,ObjectReferenceP[Object[Protocol,Degas]]]]];
			userIDs=CreateID[Repeat[Object[User,Emerald,Operator],Count[allObjects,ObjectReferenceP[Object[User,Emerald,Operator]]]]];
			tubingIDs=CreateID[Repeat[Object[Plumbing,Tubing],Count[allObjects,ObjectReferenceP[Object[Plumbing,Tubing]]]]];
			columnIDs=CreateID[Repeat[Object[Item,Column],Count[allObjects,ObjectReferenceP[Object[Item,Column]]]]];

			(* Create the packets *)
			instrumentPackets={
				<|
					Object->instrumentIDs[[1]],
					Name->"Test object 1 for ParseLog Tests"<>$SessionUUID,
					Replace[StatusLog]->{
						{DateObject[{2020,8,9,19,45,0},"Instant","Gregorian",-7.],Available,Link[$PersonID]},
						{DateObject[{2020,8,9,20,0,0},"Instant","Gregorian",-7.],Running,Link[protocolIDs[[1]]]},
						{DateObject[{2020,8,10,19,45,0},"Instant","Gregorian",-7.],Available,Link[protocolIDs[[1]]]},
						{DateObject[{2020,8,11,12,30,0},"Instant","Gregorian",-7.],Running,Link[protocolIDs[[2]]]},
						{DateObject[{2020,8,12,15,15,0},"Instant","Gregorian",-7.],Available,Link[protocolIDs[[2]]]}
					},
					Replace[ConnectionLog]->{
						{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[tubingIDs[[1]],ConnectionLog,4],"Super Flangeless Nut Port",Link[protocolIDs[[11]]]},
						{DateObject[{2021,2,18,11,0,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[tubingIDs[[2]],ConnectionLog,4],"Super Flangeless Nut Port",Link[protocolIDs[[11]]]},
						{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[tubingIDs[[1]],ConnectionLog,4],"Super Flangeless Nut Port",Link[protocolIDs[[11]]]},
						{DateObject[{2021,2,20,7,52,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[tubingIDs[[2]],ConnectionLog,4],"Super Flangeless Nut Port",Link[protocolIDs[[11]]]},
						{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Inlet",Link[tubingIDs[[2]],ConnectionLog,4],"Super Flangeless Nut Port",Link[protocolIDs[[12]]]},
						{DateObject[{2021,4,6,17,46,0},"Instant","Gregorian",-7.],Connect,"Column Outlet",Link[columnIDs[[1]],ConnectionLog,4],"Column Inlet",Link[protocolIDs[[12]]]},
						{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Inlet",Link[tubingIDs[[2]],ConnectionLog,4],"Super Flangeless Nut Port",Link[protocolIDs[[12]]]},
						{DateObject[{2021,4,7,11,37,0},"Instant","Gregorian",-7.],Disconnect,"Column Outlet",Link[columnIDs[[1]],ConnectionLog,4],"Column Inlet",Link[protocolIDs[[12]]]}
					},
					DeveloperObject->True
				|>
			};

			protocolPackets={
				<|
					Object->protocolIDs[[1]],
					Name->"Test protocol 1 for ParseLog Tests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->protocolIDs[[2]],
					Name->"Test protocol 2 for ParseLog Tests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->protocolIDs[[3]],
					Name->"Test protocol 3 for ParseLog Tests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->protocolIDs[[4]],
					Name->"Test protocol 4 for ParseLog Tests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->protocolIDs[[5]],
					Name->"Test protocol 5 for ParseLog Tests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->protocolIDs[[6]],
					Name->"Test protocol 6 for ParseLog Tests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->protocolIDs[[7]],
					Name->"Test protocol 7 for ParseLog Tests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->protocolIDs[[8]],
					Name->"Test protocol 8 for ParseLog Tests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->protocolIDs[[9]],
					Name->"Test protocol 9 for ParseLog Tests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->protocolIDs[[10]],
					Name->"Test protocol 10 for ParseLog Tests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->protocolIDs[[11]],
					Name->"Test protocol 11 for ParseLog Tests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->protocolIDs[[12]],
					Name->"Test protocol 12 for ParseLog Tests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->protocolIDs[[13]],
					Name->"Test protocol 13 for ParseLog Tests"<>$SessionUUID,
					Replace[StatusLog]->{
						{DateObject[{2022,9,15,6,55,0},"Instant","Gregorian",-7.],InCart,Link[userIDs[[3]]]},
						{DateObject[{2022,9,15,6,55,0},"Instant","Gregorian",-7.],OperatorStart,Link[userIDs[[3]]]},
						{DateObject[{2022,9,15,6,58,0},"Instant","Gregorian",-7.],OperatorProcessing,Link[userIDs[[4]]]},
						{DateObject[{2022,9,15,7,22,0},"Instant","Gregorian",-7.],OperatorProcessing,Link[userIDs[[5]]]},
						{DateObject[{2022,9,15,7,32,0},"Instant","Gregorian",-7.],OperatorReady,Link[protocolIDs[[13]]]},
						{DateObject[{2022,9,15,7,33,0},"Instant","Gregorian",-7.],OperatorProcessing,Link[userIDs[[5]]]},
						{DateObject[{2022,9,15,8,14,0},"Instant","Gregorian",-7.],OperatorProcessing,Link[userIDs[[4]]]},
						{DateObject[{2022,9,15,11,34,0},"Instant","Gregorian",-7.],Completed,Link[protocolIDs[[13]]]}
					},
					DateCompleted->DateObject[{2022,9,15,11,34,0},"Instant","Gregorian",-7.],
					DeveloperObject->True
				|>
			};

			miscPackets={
				<|
					Object->tubingIDs[[1]],
					Name->"Test tubing 1 for ParseLogTests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->tubingIDs[[2]],
					Name->"Test tubing 2 for ParseLogTests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->columnIDs[[1]],
					Name->"Test column 1 for ParseLogTests"<>$SessionUUID,
					DeveloperObject->True
				|>
			};

			operatorPackets={
				<|
					Object->userIDs[[1]],
					Name->"Test operator 1 for ParseLog Tests"<>$SessionUUID,
					Model->Link[Model[User,Emerald,Operator,"id:lYq9jRxGDv6O"],Objects],
					Replace[ProtocolLog]->{
						{DateObject[{2022,5,2,13,20,39.`},"Instant","Gregorian",-7.`],Enter,Link[protocolIDs[[3]]]},
						{DateObject[{2022,5,2,17,10,58.`},"Instant","Gregorian",-7.`],Exit,Link[protocolIDs[[3]]]},
						{DateObject[{2022,5,2,18,10,19.`},"Instant","Gregorian",-7.`],Enter,Link[protocolIDs[[3]]]},
						{DateObject[{2022,5,2,20,31,50.`},"Instant","Gregorian",-7.`],Exit,Link[protocolIDs[[3]]]},
						{DateObject[{2022,5,3,12,54,45.`},"Instant","Gregorian",-7.`],Enter,Link[protocolIDs[[4]]]},
						{DateObject[{2022,5,3,15,28,18.`},"Instant","Gregorian",-7.`],Exit,Link[protocolIDs[[4]]]},
						{DateObject[{2022,5,3,15,42,26.`},"Instant","Gregorian",-7.`],Enter,Link[protocolIDs[[5]]]},
						{DateObject[{2022,5,3,16,56,56.`},"Instant","Gregorian",-7.`],Exit,Link[protocolIDs[[5]]]},
						{DateObject[{2022,5,3,18,26,6.`},"Instant","Gregorian",-7.`],Enter,Link[protocolIDs[[5]]]},
						{DateObject[{2022,5,3,18,45,37.`},"Instant","Gregorian",-7.`],Exit,Link[protocolIDs[[5]]]},
						{DateObject[{2022,5,3,19,0,3.`},"Instant","Gregorian",-7.`],Enter,Link[protocolIDs[[6]]]},
						{DateObject[{2022,5,3,20,26,7.`},"Instant","Gregorian",-7.`],Exit,Link[protocolIDs[[6]]]}
					}
				|>,
				<|
					Object->userIDs[[2]],
					Name->"Test operator 2 for ParseLog Tests"<>$SessionUUID,
					Model->Link[Model[User,Emerald,Operator,"id:lYq9jRxGDv6O"],Objects],
					Replace[ProtocolLog]->{
						{DateObject[{2022,5,1,0,0,0},"Instant","Gregorian",-7.`],Enter,Link[protocolIDs[[7]]]},
						{DateObject[{2022,5,1,1,0,0},"Instant","Gregorian",-7.`],Exit,Link[protocolIDs[[7]]]},
						{DateObject[{2022,5,1,2,0,0},"Instant","Gregorian",-7.`],Enter,Link[protocolIDs[[8]]]},
						{DateObject[{2022,5,1,3,0,0},"Instant","Gregorian",-7.`],Enter,Link[protocolIDs[[9]]]},
						{DateObject[{2022,5,1,4,0,0},"Instant","Gregorian",-7.`],Exit,Link[protocolIDs[[9]]]},
						{DateObject[{2022,5,1,5,0,0},"Instant","Gregorian",-7.`],Enter,Link[protocolIDs[[10]]]},
						{DateObject[{2022,5,1,6,0,0},"Instant","Gregorian",-7.`],Exit,Link[protocolIDs[[10]]]},
						{DateObject[{2022,5,1,7,0,0},"Instant","Gregorian",-7.`],Exit,Link[protocolIDs[[8]]]}
					}
				|>,
				<|
					Object->userIDs[[3]],
					Name->"Test operator 3 for ParseLog Tests"<>$SessionUUID,
					Model->Link[Model[User,Emerald,Operator,"id:lYq9jRxGDv6O"],Objects]
				|>,
				<|
					Object->userIDs[[4]],
					Name->"Test operator 4 for ParseLog Tests"<>$SessionUUID,
					Model->Link[Model[User,Emerald,Operator,"id:lYq9jRxGDv6O"],Objects]
				|>,
				<|
					Object->userIDs[[5]],
					Name->"Test operator 5 for ParseLog Tests"<>$SessionUUID,
					Model->Link[Model[User,Emerald,Operator,"id:lYq9jRxGDv6O"],Objects]
				|>
			};

			Upload[Flatten[{instrumentPackets,protocolPackets,operatorPackets,miscPackets}]];


		]
	},
	SymbolTearDown:>{
		Module[{allObjects,existingObjects},

			(* Make a list of all of the fake objects we uploaded for these tests *)
			allObjects=Join[
				{
					Object[Instrument,SchlenkLine,"Test object 1 for ParseLog Tests"<>$SessionUUID],
					Object[Protocol,Degas,"Test protocol 1 for ParseLog Tests"<>$SessionUUID],
					Object[Protocol,Degas,"Test protocol 2 for ParseLog Tests"<>$SessionUUID],
					Object[Protocol,Degas,"Test protocol 3 for ParseLog Tests"<>$SessionUUID],
					Object[Protocol,Degas,"Test protocol 4 for ParseLog Tests"<>$SessionUUID],
					Object[Protocol,Degas,"Test protocol 5 for ParseLog Tests"<>$SessionUUID],
					Object[Protocol,Degas,"Test protocol 6 for ParseLog Tests"<>$SessionUUID],
					Object[Protocol,Degas,"Test protocol 7 for ParseLog Tests"<>$SessionUUID],
					Object[Protocol,Degas,"Test protocol 8 for ParseLog Tests"<>$SessionUUID],
					Object[Protocol,Degas,"Test protocol 9 for ParseLog Tests"<>$SessionUUID],
					Object[Protocol,Degas,"Test protocol 10 for ParseLog Tests"<>$SessionUUID],
					Object[Protocol,Degas,"Test protocol 11 for ParseLog Tests"<>$SessionUUID],
					Object[Protocol,Degas,"Test protocol 12 for ParseLog Tests"<>$SessionUUID],
					Object[Protocol,Degas,"Test protocol 13 for ParseLog Tests"<>$SessionUUID],
					Object[User,Emerald,Operator,"Test operator 1 for ParseLog Tests"<>$SessionUUID],
					Object[User,Emerald,Operator,"Test operator 2 for ParseLog Tests"<>$SessionUUID],
					Object[User,Emerald,Operator,"Test operator 3 for ParseLog Tests"<>$SessionUUID],
					Object[User,Emerald,Operator,"Test operator 4 for ParseLog Tests"<>$SessionUUID],
					Object[User,Emerald,Operator,"Test operator 5 for ParseLog Tests"<>$SessionUUID],
					Object[Plumbing,Tubing,"Test tubing 1 for ParseLogTests"<>$SessionUUID],
					Object[Plumbing,Tubing,"Test tubing 2 for ParseLogTests"<>$SessionUUID],
					Object[Item,Column,"Test column 1 for ParseLogTests"<>$SessionUUID]
				},
				$CreatedObjects
			];

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

		];
	}
];

(* ::Section::Closed:: *)
(*End Test Package*)
