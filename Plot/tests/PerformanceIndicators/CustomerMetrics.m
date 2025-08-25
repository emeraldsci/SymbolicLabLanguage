(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*CustomerMetrics*)


(* ::Subsubsection::Closed:: *)
(*ReportCustomerMetrics*)

(* ::Subsection::Closed:: *)
(* ReportCustomerMetrics *)
DefineTests[ReportCustomerMetrics,
    {
        Example[{Basic,"Generate a report object when ReportCustomerMetrics is called on a valid input (single financing team):"},
            ReportCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}]],
			ObjectP[Object[Report,CustomerMetrics]]
		],
	    Example[{Basic,"Generate report objects when ReportCustomerMetrics is called on a valid input (multiple financing teams):"},
		    ReportCustomerMetrics[{Object[Team,Financing,"Emerald Therapeutics"],Object[Team,Financing,"Emerald Therapeutics"]},DateObject[{2023,10,01}],DateObject[{2023,10,07}]],
		    {ObjectP[Object[Report,CustomerMetrics]],ObjectP[Object[Report,CustomerMetrics]]}
	    ],
	    Example[{Basic,"Generate a report object when ReportCustomerMetrics is called on a valid input (a single date translated as date input up to Today-1 Day):"},
		    ReportCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],Today-8 Day],
		    ObjectP[Object[Report,CustomerMetrics]]
	    ],
	    Example[{Basic,"Generate a report object when ReportCustomerMetrics is called on a valid input: (no date translated as most recent week before Today)"},
		    ReportCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"]],
		    ObjectP[Object[Report,CustomerMetrics]],
		    TimeConstraint->500
	    ],
	    Example[{Basic,"Generate a packet output when Upload is False:"},
		    ReportCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],Upload->False],
		    PacketP[]
	    ],
	    Example[{Messages, "TeamNotFound", "The Object[Team, Financing] the report is requested for must exist in the database:"},
		    ReportCustomerMetrics[Object[Team,Financing,"Non-Existent Team"<>$SessionUUID],DateObject[{2023,10,01}],DateObject[{2023,10,07}],Upload->False],
		    $Failed,
		    Messages :> {
			    Error::TeamNotFound
		    }
	    ],
	    Example[{Messages, "InvalidDateRange", "StartDate and EndDate should be no later than 1 Day before current date:"},
		    ReportCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],Today +1 Day,Today + 2 Day],
		    $Failed,
		    Messages :> {
			    Error::InvalidDateRange
		    }
	    ],
	    (*
	    Example[{Messages, "NoProtocolsCompleted", "If no completed parent protocols are found for the report period, return $Failed and an error message:"},
		    ReportCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,04,01}],DateObject[{2023,04,02}]],
		    $Failed,
		    Messages :> {
			    Error::NoProtocolsCompleted
		    }
	    ],
	    *)
	    Example[{Options, ActivityLimit, "ActivityLimit can be specified as a time quantity to specify the minimum continuous activity required for user activity:"},
		    ReportCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],ActivityLimit->15 Minute],
		    ObjectP[Object[Report,CustomerMetrics]]
	    ],
	    Example[{Options, InactivityBuffer, "InactivityBuffer can be specified as a time quantity to specify the amount of buffer time aloted for user activity:"},
		    ReportCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],InactivityBuffer->10 Minute],
		    ObjectP[Object[Report,CustomerMetrics]]
	    ]
    },
	Stubs:>{
		(*$RequiredSearchName = "ReportCustomerMetrics",*)
		$DeveloperSearch = True
	},
	SetUp:>(
		$CreatedObjects = {};
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects]
	)(*,
	SymbolSetUp:>Module[{
	
	},

		$CreatedObjects={};
		
		
	]
	*)
	
]

(* ::Subsubsection::Closed:: *)
(*PlotCustomerMetrics*)


(* ::Subsection::Closed:: *)
(* PlotCustomerMetrics *)
DefineTests[PlotCustomerMetrics,
	{
		Example[{Basic,"PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object for dates that have protocols completed:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2024,01,01}],DateObject[{2024,01,14}]],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Basic,"PlotCustomerMetrics generate the notebook and pdf reports and update the team financing objects for multiple financing team inputs:"},
			PlotCustomerMetrics[{Object[Team,Financing,"Emerald Therapeutics"],Object[Team,Financing,"Emerald Therapeutics"]},DateObject[{2024,01,01}],DateObject[{2024,01,14}]],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Basic,"PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object for dates that have no protocols completed:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}]],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Basic,"PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object for date range that involve multiple report objects:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,29}],DateObject[{2023,11,14}]],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Messages, "TooManyDays", "PlotCustomerMetrics returns $Failed when date range is more than 365 days:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2022,10,01}],DateObject[{2024,10,07}]],
			$Failed,
			Messages :> {
				Error::TooManyDays
			}
		],
		Example[{Messages, "MissingReports", "PlotCustomerMetrics returns $Failed when there are missing reports for one or more days included in the date range input:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2024,04,01}],DateObject[{2024,04,07}]],
			$Failed,
			Messages :> {
				Error::MissingReports
			}
		],
		Example[{Options, Target, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when Target is specified as Company:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],Target->Company],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, ThreadUtilization, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when ThreadUtilization is specified as Number:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],ThreadUtilization->Number],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, ChartStyle, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when ChartStyle is specified as Stack:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],ChartStyle->Stack],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, MaxThreads, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when MaxThreads is specified as an integer:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],MaxThreads->5],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, QueueTimesRange, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when QueueTimesRange is specified as Cumulative:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],QueueTimesRange->Cumulative],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, QueueTimesProtocol, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when QueueTimesProtocol is specified as Protocol:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],QueueTimesProtocol->Protocol],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, TurnaroundTimes, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when TurnaroundTimes is specified as True:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],TurnaroundTimes->True],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, TurnaroundTimeLimit, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when TurnaroundTimeLimit is specified as an integer:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],TurnaroundTimeLimit->10],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, IncludedTurnaroundStatus, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when IncludedTurnaroundStatus is specified as a list of ProtocolStatusP|OperationStatusP:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],IncludedTurnaroundStatus->{OperatorStart, OperatorReady, OperatorProcessing, InstrumentProcessing}],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, UserUtilizationProtocol, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when UserUtilizationProtocol is specified as Experiment:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],UserUtilizationProtocol->Experiment],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, InstrumentWorkingHours, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when InstrumentWorkingHours is specified as True:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],InstrumentWorkingHours->True],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, InstrumentSavings, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when InstrumentSavings is specified as Finance:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],InstrumentSavings->Finance],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, RealEstateRate, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when RealEstateRate is specified as a rate in USD/Feet^2:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],RealEstateRate->50*(USD/Power["Feet",2])],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, EmailRecipients, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when EmailRecipients is specified:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],EmailRecipients->{Sales}],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, EmailBcc, "PlotCustomerMetrics generate the notebook and pdf reports and update the team financing object when EmailBcc is specified:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],EmailBcc->{Sales}],
			{{ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[EmeraldCloudFile]]..}, {ObjectP[Object[Team, Financing]]..}}
		],
		Example[{Options, Upload, "PlotCustomerMetrics generate the notebook, pdf and financing team object packet when Upload is set to False:"},
			PlotCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,07}],Upload->False],
			{{PacketP[Object[EmeraldCloudFile]]..}, {PacketP[Object[EmeraldCloudFile]]..}, {PacketP[Object[Team, Financing]]..}}
		],
		Example[{Options, Upload, "PlotCustomerMetrics generate the notebook, pdf and financing team object packets for multiple team inputs when Upload is set to False:"},
			PlotCustomerMetrics[{Object[Team,Financing,"Emerald Therapeutics"],Object[Team,Financing,"Emerald Therapeutics"]},DateObject[{2023,10,01}],DateObject[{2023,10,07}],Upload->False],
			{{PacketP[Object[EmeraldCloudFile]]..}, {PacketP[Object[EmeraldCloudFile]]..}, {PacketP[Object[Team, Financing]]..}}
		]
		
	},
	Stubs:>{
		$PublicPath=$TemporaryDirectory,
		Search[Object[Report,CustomerMetrics],_]=Search[
			Object[Report,CustomerMetrics],
			FinancingTeam==Object[Team,Financing,"Emerald Therapeutics"]&&Name==(___~~$SessionUUID)
		]
	},
	HardwareConfiguration -> HighRAM,
	SetUp:>(
		$CreatedObjects = {};
		Off[LinkObject::linkn];
		Off[LinkObject::linkd];
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects];
		On[LinkObject::linkn];
		On[LinkObject::linkd];
	),
	SymbolSetUp:>(Module[
		{
			objects,
			existsFilter,
			reportObject1,
			reportObject2,
			reportObject3
		},
		
		objects ={
			Object[Report,CustomerMetrics,"Test Report Object 1 for PlotCustomerMetrics"<>$SessionUUID],
			Object[Report,CustomerMetrics,"Test Report Object 2 for PlotCustomerMetrics"<>$SessionUUID],
			Object[Report,CustomerMetrics,"Test Report Object 3 for PlotCustomerMetrics"<>$SessionUUID]
		};
		
		(* Check whether the names we want to give below already exist in the database *)
		existsFilter = DatabaseMemberQ[objects];
		
		(* Erase any objects that we failed to erase in the last unit test. *)
		Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		
		$CreatedObjects={};
		
		reportObject1 = ReportCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,10,01}],DateObject[{2023,10,31}]];
		
		Upload[<|
			Object->reportObject1,
			Name->"Test Report Object 1 for PlotCustomerMetrics"<>$SessionUUID
		|>];
		
		reportObject2 = ReportCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2023,11,01}],DateObject[{2023,11,30}]];
		
		Upload[<|
			Object->reportObject2,
			Name->"Test Report Object 2 for PlotCustomerMetrics"<>$SessionUUID
		|>];
		
		reportObject3 = ReportCustomerMetrics[Object[Team,Financing,"Emerald Therapeutics"],DateObject[{2024,01,01}],DateObject[{2024,01,31}]];
		
		Upload[<|
			Object->reportObject3,
			Name->"Test Report Object 3 for PlotCustomerMetrics"<>$SessionUUID
		|>];
		
	];),
	SymbolTearDown:>(
		Module[
			{objects,existsFilter},
			
			objects ={
				Object[Report,CustomerMetrics,"Test Report Object 1 for PlotCustomerMetrics"<>$SessionUUID],
				Object[Report,CustomerMetrics,"Test Report Object 2 for PlotCustomerMetrics"<>$SessionUUID],
				Object[Report,CustomerMetrics,"Test Report Object 3 for PlotCustomerMetrics"<>$SessionUUID]
			};
			
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];
			
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];
	)
]


(* ::Subsection::Closed:: *)
(* PlotCommandCenterActivity *)

DefineTests[PlotCommandCenterActivity,
	{
		Example[{Basic, "Display a plot of user Command Center activity on a team over a one-week period:"},
			PlotCommandCenterActivity[Object[Team, Financing, "ECL User Training"], DateObject[{2025,02,17}],DateObject[{2025,02,21}]],
			_TabView
		],
		Example[{Options, OutputFormat, "Display a table of cumulative user Command Center activity on a team over the past week:"},
			PlotCommandCenterActivity[Object[Team, Financing, "ECL User Training"], DateObject[{2025,02,17}],DateObject[{2025,02,21}], OutputFormat->Table],
			_Pane
		],
		Example[{Options, HideInactiveUsers, "Display a plot of cumulative user Command Center activity on a team over the past week, showing all users regardless of activity level:"},
			PlotCommandCenterActivity[Object[Team, Financing, "ECL User Training"], DateObject[{2025,02,17}],DateObject[{2025,02,21}], HideInactiveUsers->False],
			_TabView
		],
		Example[{Options, HideInactiveUsers, "Display a plot of cumulative user Command Center activity on a team over the past week, omitting users with less than 10 percent of the cumulative activity of the most active user in their functional group:"},
			PlotCommandCenterActivity[Object[Team, Financing, "ECL User Training"], DateObject[{2025,02,17}],DateObject[{2025,02,21}], InactiveUserThreshold->10 Percent],
			_TabView
		],
		Example[{Options, UserDepartments, "Display a plot of cumulative user Command Center activity on a team over the past week, labeling users by department:"},
			PlotCommandCenterActivity[Object[Team, Financing, "ECL User Training"], DateObject[{2025,02,17}],DateObject[{2025,02,21}], UserDepartments->{Object[User, "ben+ecl-training"]->"Scientific Education", Object[User, "malav.desai%2Becl-training%40emeraldcloudlab.com"]->"Solutions"}],
			_TabView
		],
		Example[{Messages, "DateRangeInvalid", "Throws a message and returns $Failed if the start date is after the end date:"},
			PlotCommandCenterActivity[Object[Team, Financing, "ECL User Training"], Today - 1 Day, Today - 3 Day],
			$Failed,
			Messages:>{Error::DateRangeInvalid}
		],
		Example[{Messages, "DateRangeTooShort", "Throws a message and returns $Failed if the date range is less than 3 days:"},
			PlotCommandCenterActivity[Object[Team, Financing, "ECL User Training"], Today - 2 Day, Today - 1 Day],
			$Failed,
			Messages:>{Error::DateRangeTooShort}
		],
		Example[{Messages, "MissingReports", "Throws a message and returns $Failed if part of the specified date range is not covered by existing Object[Report, CustomerMetrics]:"},
			PlotCommandCenterActivity[Object[Team, Financing, "ECL User Training"], DateObject[{2025,02,17}],DateObject[{2025,03,03}]],
			$Failed,
			Messages:>{Error::MissingReports}
		],
		Example[{Messages, "MissingReports", "Throws a message and returns $Failed if no reports cover the specified date range:"},
			PlotCommandCenterActivity[Object[Team, Financing, "ECL User Training"], DateObject[{2025,03,03}],DateObject[{2025,03,10}]],
			$Failed,
			Messages:>{Error::MissingReports}
		],
		Example[{Messages, "TeamNotFound", "Throws a message and returns $Failed if the provided financing team does not exist in Constellation:"},
			PlotCommandCenterActivity[Object[Team, Financing, "NonexistentTeam"<>$SessionUUID], DateObject[{2025,03,03}],DateObject[{2025,03,10}]],
			$Failed,
			Messages:>{Error::TeamNotFound}
		],
		Test["Hiding inactive users functions as expected:",
			Length /@ Cases[
				{
					PlotCommandCenterActivity[Object[Team, Financing, "ECL User Training"], DateObject[{2025,02,17}],DateObject[{2025,02,21}], HideInactiveUsers->False, OutputFormat->Table],
					PlotCommandCenterActivity[Object[Team, Financing, "ECL User Training"], DateObject[{2025,02,17}],DateObject[{2025,02,21}], HideInactiveUsers->True, OutputFormat->Table]
				},
				Grid[gridContents_, __] :> gridContents, 
				Infinity
			],
			{3,2}
		]
	},
	Stubs :> {},
	SymbolSetUp:>Module[
		{
			objects,
			existsFilter,
			reportObject
		},
		
		objects ={
			Object[Report,CustomerMetrics,"Test Report Object for PlotCommandCenterActivity"<>$SessionUUID]
		};
		
		(* Check whether the names we want to give below already exist in the database *)
		existsFilter = DatabaseMemberQ[objects];
		
		(* Erase any objects that we failed to erase in the last unit test. *)
		Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		
		$CreatedObjects={};
		
		reportObject = ReportCustomerMetrics[Object[Team,Financing,"ECL User Training"],DateObject[{2025,02,01}],DateObject[{2025,02,28}]];
		
		Upload[<|
			Object->reportObject,
			Name->"Test Report Object for PlotCommandCenterActivity"<>$SessionUUID
		|>];
	],
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	]
]
