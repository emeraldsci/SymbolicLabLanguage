(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(* ProtocolDelayTime *)


DefineTests[ProtocolDelayTime,
	{
		Example[{Basic,"Indicates the total amount of time a protocol was delayed beyond Emerald's estimates. Any time beyond the 24 hour starting goal and the total time in the protocol beyond checkpoint estimates is included:"},
			ProtocolDelayTime[Object[Protocol, PAGE, "id:dORYzZJNoDnR"]],
			_?(MatchQ[Round[#],17 Hour]&)
		],
		Example[{Basic,"Reports 0 Minute if the protocol is meeting or exceeding Emerald's estimates"},
			ProtocolDelayTime[Object[Protocol, ImageSample, "id:1ZA60vLBdlj5"]],
			0 Minute
		],
		Test["Handles the case where Checkpoints is empty:",
			ProtocolDelayTime[Object[Protocol, ImageSample, "id:54n6evLKEJ1Y"]],
			0 Minute
		],
		Test["If a protocol hasn't been started the delay will be calculated assuming it's just about to start:",
			ProtocolDelayTime[Object[Protocol, ManualSamplePreparation, "id:AEqRl9xjXr7d"]],
			GreaterP[2 Month]
		]
	},
	SymbolSetUp:>Module[{},
		$CreatedObjects={}
	],
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	]
];


(* ::Subsection::Closed:: *)
(* OperationsStatisticsTrends *)


DefineTests[OperationsStatisticsTrends,
    {
        Example[{Basic,"Returns a list of plots for key tracked metrics for HPLC qualifications run in January 2025:"},
            OperationsStatisticsTrends[
				Object[Qualification,HPLC],
				DateObject[{2025, 1, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				DateObject[{2025, 2, 1, 0, 0, 0}, "Instant", "Gregorian", -6.]
			],
            _Column
        ],
        Example[{Messages,"NoExperimentsFound","Returns $Failed if a specific experiment type is not found within the given time window:"},
			OperationsStatisticsTrends[
				Object[Maintenance,Autoclave],
				DateObject[{2025, 1, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				DateObject[{2025, 1, 3, 0, 0, 0}, "Instant", "Gregorian", -6.]
			],
			$Failed,
            Messages:>{OperationsStatisticsTrends::NoExperimentsFound}
        ],
        Example[{Options,Site,"Specify the Site for which experiments are considered:"},
			OperationsStatisticsTrends[
				Object[Qualification,Balance],
				DateObject[{2025, 1, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				DateObject[{2025, 3, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				Site->Object[Container,Site,"ECL-2"]
			]
			_Column
        ],
		Example[{Options,FinancingTeam,"Specify that only RoboticSamplePreparation protocols enqueued by the development team should be considered:"},
			OperationsStatisticsTrends[
				Object[Protocol,RoboticSamplePreparation],
				DateObject[{2025, 1, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				DateObject[{2025, 4, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				FinancingTeam->Object[Team, Financing, "Development"]
			]
			_Column
		],
		Example[{Options,Radius,"Provide a large radius to more heavily smooth out noise in the data:"},
			OperationsStatisticsTrends[
				Object[Qualification,Pipette],
				DateObject[{2025, 1, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				DateObject[{2025, 3, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				Radius->3 Week
			]
			_Column
		],
		Example[{Options,OutputFormat,"Use the OutputFormat option to export the datasets for each statistic:"},
			OperationsStatisticsTrends[
				Object[Maintenance,ReceiveInventory],
				DateObject[{2025, 1, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				DateObject[{2025, 1, 14, 0, 0, 0}, "Instant", "Gregorian", -6.],
				OutputFormat -> Export
			]
			_Column
		],
		Example[{Options,OutputFormat,"Return just the raw data for the QueueTime and the CycleTime:"},
			OperationsStatisticsTrends[
				Object[Qualification,Pipette],
				DateObject[{2025, 1, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				DateObject[{2025, 2, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				OutputFormat -> Dataset,
				ColumnDisplay -> False,
				OperationsStatistics -> QueueTime
			],
			{{{{_DateObject,TimeP}..}}}
		],
		Example[{Options,OperationsStatistics,"Set OperationStatistics to plot only the EffectiveTurnaroundTime:"},
			OperationsStatisticsTrends[
				Object[Qualification,Pipette],
				DateObject[{2025, 1, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				DateObject[{2025, 2, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				OperationsStatistics -> EffectiveTurnaroundTime
			],
			_Column
		],
		Example[{Options,OperationsStatistics,"Show plots indicating the QueueTime and ResourceAvailability trends:"},
			OperationsStatisticsTrends[
				Object[Qualification,Pipette],
				DateObject[{2025, 1, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				DateObject[{2025, 2, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				OperationsStatistics -> {QueueTime,ResourceAvailability}
			],
			_Column
		],
		Example[{Options,ColumnDisplay,"Return the output in a list:"},
			OperationsStatisticsTrends[
				Object[Qualification,Balance],
				DateObject[{2025, 1, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				DateObject[{2025, 2, 1, 0, 0, 0}, "Instant", "Gregorian", -6.],
				ColumnDisplay->False,
				OperationsStatistics -> EffectiveTurnaroundTime
			],
			{{_Grid}}
		]
    }
];


(* ::Subsection::Closed:: *)
(* UploadOperationsStatistics *)


DefineTests[UploadOperationsStatistics,
    {
        Example[{Basic,"Calculates operations metrics for a protocol, uploads the metrics to corresponding fields and returns the updated protocol:"},
            UploadOperationsStatistics[Object[Protocol, HPLC,"UploadOperationsStatistics Protocol 1 "<>$SessionUUID]],
			{ObjectP[Object[Protocol, HPLC,"UploadOperationsStatistics Protocol 1 "<>$SessionUUID]]}
        ],
		Example[{Basic,"Fields such as QueueTime, WaitingTime and TotalLeadTime are populated in the protocol:"},
			UploadOperationsStatistics[Object[Protocol, AbsorbanceSpectroscopy,"UploadOperationsStatistics Protocol 2 "<>$SessionUUID]];
			Download[Object[Protocol, AbsorbanceSpectroscopy,"UploadOperationsStatistics Protocol 2 "<>$SessionUUID],{QueueTime,WaitingTime,TotalLeadTime}],
			{1 Hour,0 Hour,6 Hour},
			EquivalenceFunction->Equal
		],
		Example[{Basic,"Effective times remove any time spent in non-processing statuses (ShippingMaterials, RepairingInstrumentation) after the protocol has been started:"},
			UploadOperationsStatistics[Object[Protocol, PAGE,"UploadOperationsStatistics Protocol 3 "<>$SessionUUID]];
			Download[Object[Protocol, PAGE,"UploadOperationsStatistics Protocol 3 "<>$SessionUUID],{TotalCompletionTime,EffectiveCompletionTime}],
			{32 Hour,8 Hour},
			EquivalenceFunction->Equal
		],
		Test["Calculates and populates all metrics correctly:",
			UploadOperationsStatistics[Object[Protocol, HPLC,"UploadOperationsStatistics Protocol 1 "<>$SessionUUID]];
			Download[
				Object[Protocol, HPLC,"UploadOperationsStatistics Protocol 1 "<>$SessionUUID],
				{
					QueueTime,
					QueueTimesBreakdown,
					CycleTime,
					TotalOperatorTime,
					OperationConstraintTime,
					WaitingTime,
					WaitingTimesBreakdown,
					TotalLeadTime,
					TotalTurnaroundTime,
					TotalCompletionTime,
					EffectiveTurnaroundTime,
					EffectiveCompletionTime
				}
			],
			{
				1 Hour,
				<|
					ResourceAvailability -> 0 Hour,
					MaterialsAvailability -> 0 Hour,
					ECLMaterialsAvailability -> 0 Hour,
					UserMaterialsAvailability -> 0 Hour,
					InstrumentAvailability -> 0 Hour,
					OperatorStart -> 30 Hour
				|>,
				32 Hour,
				28 Hour,
				3 Hour,
				27 Hour,
				<|
					ShippingMaterials -> 0 Hour,
					InstrumentRepairs -> 2 Hour,
					ScientificSupport -> 1 Hour,
					ResourceAvailability -> 0 Hour,
					MaterialsAvailability -> 0 Hour,
					ECLMaterialsAvailability -> 0 Hour,
					UserMaterialsAvailability -> 0 Hour,
					InstrumentAvailability -> 0 Hour,
					OperatorReturn -> 24 Hour
				|>,
				90 Hour,
				90 Hour,
				89 Hour,
				88 Hour,
				87 Hour
			},
			EquivalenceFunction->Equal
        ],
		Example[{Basic,"If any times in the protocol are corrupt such that a negative number is returned the value won't be populated:"},
			UploadOperationsStatistics[Object[Protocol, FPLC, "UploadOperationsStatistics Protocol 4 "<>$SessionUUID]];
			Download[Object[Protocol, FPLC, "UploadOperationsStatistics Protocol 4 "<>$SessionUUID],TotalCompletionTime],
			Null,
			EquivalenceFunction->Equal
		],
		Example[{Messages,"UnexpectedCalculation","When the Debug option is turned on, messages are printed about calculations that returned negative numbers indicating an issue with the underlying data:"},
			UploadOperationsStatistics[Object[Protocol, FPLC, "UploadOperationsStatistics Protocol 5 "<>$SessionUUID],Debug->True];
			Download[Object[Protocol, FPLC, "UploadOperationsStatistics Protocol 5 "<>$SessionUUID],{QueueTime,TotalLeadTime}],
			{TimeP,Null},
			Messages:>{UploadOperationsStatistics::UnexpectedCalculation}
		],
		Example[{Messages,"UnexpectedComparison","When statistics are incompatible due to manual changes made to date fields or the status log with each other nothing is populated:"},
			UploadOperationsStatistics[Object[Protocol, PAGE, "UploadOperationsStatistics Protocol 6 "<>$SessionUUID],Debug->True];
			Download[Object[Protocol, PAGE, "UploadOperationsStatistics Protocol 6 "<>$SessionUUID],{QueueTime,TotalLeadTime}],
			{Null,Null},
			Messages:>{UploadOperationsStatistics::UnexpectedComparison}
		],
		Example[{Messages,"ProtocolsIgnored","Statistics are only calculated for completed root protocols as many of the specific calculations don't apply to subprotocols or protocols that haven't/didn't run to completion:"},
			UploadOperationsStatistics[Object[Protocol, PAGE, "UploadOperationsStatistics Protocol 7 "<>$SessionUUID],Debug->True],
			{},
			Messages:>{UploadOperationsStatistics::ProtocolsIgnored}
		],
		Test["Calculates and populates all breakdown times correctly using the ready check log:",
			UploadOperationsStatistics[Object[Protocol, PAGE, "UploadOperationsStatistics Protocol 8 "<>$SessionUUID]];
			Download[
				Object[Protocol, PAGE, "UploadOperationsStatistics Protocol 8 "<>$SessionUUID],
				{
					QueueTime,
					QueueTimesBreakdown,
					WaitingTime,
					WaitingTimesBreakdown
				}
			],
			{
				2 Hour,
				<|
					ResourceAvailability -> 1 Hour,
					MaterialsAvailability -> 0 Hour,
					ECLMaterialsAvailability -> 0 Hour,
					UserMaterialsAvailability -> 0 Hour,
					InstrumentAvailability -> 1 Hour,
					OperatorStart -> 1 Hour
				|>,
				10 Hour,
				<|
					ShippingMaterials -> 0 Hour,
					InstrumentRepairs -> 0 Hour,
					ScientificSupport -> 0 Hour,
					ResourceAvailability -> 4 Hour,
					MaterialsAvailability -> 3 Hour,
					ECLMaterialsAvailability -> 3 Hour,
					UserMaterialsAvailability -> 1 Hour,
					InstrumentAvailability -> 1 Hour,
					OperatorReturn -> 6 Hour
				|>
			},
			EquivalenceFunction->Equal
		]
    },
    SymbolSetUp:>Module[{protocol1,protocol2,protocol3,protocol4,protocol5,protocol6,protocol7,protocol8},
		$CreatedObjects={};

		protocol1=<|
			Type -> Object[Protocol, HPLC],
			Name -> "UploadOperationsStatistics Protocol 1 "<>$SessionUUID,
			Status -> Completed,
			DateEnqueued -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateConfirmed -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateRequested -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateStarted -> DateObject[{2025, 2, 10, 15, 0, 0}],
			DateCompleted -> DateObject[{2025, 2, 14, 8, 0, 0}],
			Replace[StatusLog] -> {
				{DateObject[{2025, 2, 10, 14, 0, 0}], InCart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 15, 0, 0}], OperatorStart, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 21, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 22, 0, 0}], OperatorReady, Link[$PersonID]},
				{DateObject[{2025, 2, 12, 21, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 13, 9, 0, 0}], InstrumentProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 13, 13, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 14, 2, 0, 0}], ScientificSupport, Link[$PersonID]},
				{DateObject[{2025, 2, 14, 3, 0, 0}], RepairingInstrumentation, Link[$PersonID]},
				{DateObject[{2025, 2, 14, 5, 0, 0}], OperatorReady, Link[$PersonID]},
				{DateObject[{2025, 2, 14, 6, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 14, 8, 0, 0}], Completed, Link[$PersonID]}
			},
			Replace[ReadyCheckLog] -> {}
		|>;

		protocol2=<|
			Type -> Object[Protocol, AbsorbanceSpectroscopy],
			Name -> "UploadOperationsStatistics Protocol 2 "<>$SessionUUID,
			Status -> Completed,
			DateEnqueued -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateConfirmed -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateRequested -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateStarted -> DateObject[{2025, 2, 10, 15, 0, 0}],
			DateCompleted -> DateObject[{2025, 2, 10, 20, 0, 0}],
			Replace[StatusLog] -> {
				{DateObject[{2025, 2, 10, 14, 0, 0}], InCart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 14, 0, 0}], OperatorStart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 15, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 17, 0, 0}], InstrumentProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 18, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 20, 0, 0}], Completed, Link[$PersonID]}
			}
		|>;

		protocol3=<|
			Type -> Object[Protocol, PAGE],
			Name -> "UploadOperationsStatistics Protocol 3 "<>$SessionUUID,
			Status -> Completed,
			DateEnqueued -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateConfirmed -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateRequested -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateStarted -> DateObject[{2025, 2, 10, 15, 0, 0}],
			DateCompleted -> DateObject[{2025, 2, 11, 23, 0, 0}],
			Replace[StatusLog] -> {
				{DateObject[{2025, 2, 10, 14, 0, 0}], InCart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 14, 0, 0}], OperatorStart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 15, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 17, 0, 0}], InstrumentProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 18, 0, 0}], RepairingInstrumentation, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 18, 0, 0}], OperatorReady, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 20, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 23, 0, 0}], Completed, Link[$PersonID]}
			}
		|>;

		protocol4=<|
			Type -> Object[Protocol, FPLC],
			Name -> "UploadOperationsStatistics Protocol 4 "<>$SessionUUID,
			Status -> Completed,
			DateEnqueued -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateConfirmed -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateRequested -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateStarted -> DateObject[{2025, 2, 10, 15, 0, 0}],
			DateCompleted -> DateObject[{2025, 2, 9, 23, 0, 0}], (* Invalid Date that unexpectedly comes before our other dates *)
			Replace[StatusLog] -> {
				{DateObject[{2025, 2, 10, 14, 0, 0}], InCart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 14, 0, 0}], OperatorStart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 15, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 17, 0, 0}], InstrumentProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 18, 0, 0}], RepairingInstrumentation, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 18, 0, 0}], OperatorReady, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 20, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 9, 23, 0, 0}], Completed, Link[$PersonID]}
			}
		|>;

		protocol5=<|
			Type -> Object[Protocol, FPLC],
			Name -> "UploadOperationsStatistics Protocol 5 "<>$SessionUUID,
			Status -> Completed,
			DateEnqueued -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateConfirmed -> DateObject[{2025, 3, 12, 14, 0, 0}], (* Invalid Date that comes unexpectedly after our other dates *)
			DateRequested -> DateObject[{2025, 2, 10, 14, 0, 0}], 
			DateStarted -> DateObject[{2025, 2, 10, 15, 0, 0}],
			DateCompleted -> DateObject[{2025, 2, 11, 23, 0, 0}],
			Replace[StatusLog] -> {
				{DateObject[{2025, 2, 10, 14, 0, 0}], InCart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 14, 0, 0}], OperatorStart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 15, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 17, 0, 0}], InstrumentProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 18, 0, 0}], RepairingInstrumentation, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 18, 0, 0}], OperatorReady, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 20, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 23, 0, 0}], Completed, Link[$PersonID]}
			}
		|>;

		protocol6=<|
			Type -> Object[Protocol, PAGE],
			Name -> "UploadOperationsStatistics Protocol 6 "<>$SessionUUID,
			Status -> Completed,
			DateEnqueued -> DateObject[{2025, 2, 8, 14, 0, 0}],
			DateConfirmed -> DateObject[{2025, 2, 8, 14, 0, 0}],
			DateRequested -> DateObject[{2025, 2, 8, 14, 0, 0}],
			DateStarted -> DateObject[{2025, 2, 8, 15, 0, 0}],
			DateCompleted -> DateObject[{2025, 2, 8, 16, 0, 0}],
			Replace[StatusLog] -> {
				{DateObject[{2025, 2, 10, 14, 0, 0}], InCart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 14, 0, 0}], OperatorStart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 15, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 17, 0, 0}], InstrumentProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 18, 0, 0}], RepairingInstrumentation, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 18, 0, 0}], OperatorReady, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 20, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 23, 0, 0}], Completed, Link[$PersonID]}
			}
		|>;

		protocol7=<|
			Type -> Object[Protocol, PAGE],
			Name -> "UploadOperationsStatistics Protocol 7 "<>$SessionUUID,
			Status -> Aborted,
			DateEnqueued -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateConfirmed ->DateObject[{2025, 2, 10, 14, 0, 0}],
			DateRequested -> DateObject[{2025, 2, 10, 14, 0, 0}],
			DateStarted -> DateObject[{2025, 2, 10, 15, 0, 0}],
			DateCompleted -> DateObject[{2025, 2, 11, 23, 0, 0}],
			Replace[StatusLog] -> {
				{DateObject[{2025, 2, 10, 14, 0, 0}], InCart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 14, 0, 0}], OperatorStart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 15, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 17, 0, 0}], InstrumentProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 18, 0, 0}], RepairingInstrumentation, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 18, 0, 0}], OperatorReady, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 20, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 11, 23, 0, 0}], Completed, Link[$PersonID]}
			}
		|>;

		protocol8=<|
			Type -> Object[Protocol, PAGE],
			Name -> "UploadOperationsStatistics Protocol 8 "<>$SessionUUID,
			Status -> Completed,
			DateEnqueued -> DateObject[{2025, 2, 10, 0, 0, 0}],
			DateConfirmed -> DateObject[{2025, 2, 10, 0, 0, 0}],
			DateRequested -> DateObject[{2025, 2, 10, 0, 0, 0}],
			DateStarted -> DateObject[{2025, 2, 10, 2, 0, 0}],
			DateCompleted -> DateObject[{2025, 2, 10, 23, 0, 0}],
			Replace[StatusLog] -> {
				{DateObject[{2025, 2, 10, 0, 0, 0}], InCart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 0, 0, 0}], OperatorStart, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 2, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 3, 0, 0}], OperatorReady, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 13, 0, 0}], OperatorProcessing, Link[$PersonID]},
				{DateObject[{2025, 2, 10, 23, 0, 0}], Completed, Link[$PersonID]}
			},
			Replace[ReadyCheckLog] -> {
				{
					DateObject[{2025, 2, 9, 0, 0, 0}],
					False,
					<|ECLMaterialsAvailable -> True, UserMaterialsAvailable -> True, InstrumentsAvailable -> False, UnavailableMaterials -> {}, UnavailableInstruments -> {}|>
				},
				{
					DateObject[{2025, 2, 10, 1, 0, 0}],
					True,
					<|ECLMaterialsAvailable -> True, UserMaterialsAvailable -> True, InstrumentsAvailable -> True, UnavailableMaterials -> {}, UnavailableInstruments -> {}|>
				},
				{
					DateObject[{2025, 2, 10, 1, 30, 0}],
					True,
					<|ECLMaterialsAvailable -> True, UserMaterialsAvailable -> True, InstrumentsAvailable -> True, UnavailableMaterials -> {}, UnavailableInstruments -> {}|>
				},
				{
					DateObject[{2025, 2, 10, 2, 30, 0}],
					False,
					<|ECLMaterialsAvailable -> False, UserMaterialsAvailable -> True, InstrumentsAvailable -> True, UnavailableMaterials -> {}, UnavailableInstruments -> {}|>
				},
				{
					DateObject[{2025, 2, 10, 5, 0, 0}],
					False,
					<|ECLMaterialsAvailable -> False, UserMaterialsAvailable -> False, InstrumentsAvailable -> True, UnavailableMaterials -> {}, UnavailableInstruments -> {}|>
				},
				{
					DateObject[{2025, 2, 10, 6, 0, 0}],
					True,
					<|ECLMaterialsAvailable -> True, UserMaterialsAvailable -> True, InstrumentsAvailable -> True, UnavailableMaterials -> {}, UnavailableInstruments -> {}|>
				},
				{
					DateObject[{2025, 2, 10, 7, 0, 0}],
					False,
					<|ECLMaterialsAvailable -> True, UserMaterialsAvailable -> True, InstrumentsAvailable -> False, UnavailableMaterials -> {}, UnavailableInstruments -> {}|>
				},
				{
					DateObject[{2025, 2, 10, 8, 0, 0}],
					True,
					<|ECLMaterialsAvailable -> True, UserMaterialsAvailable -> True, InstrumentsAvailable -> True, UnavailableMaterials -> {}, UnavailableInstruments -> {}|>
				}
			}
		|>;

		Upload[{protocol1,protocol2,protocol3,protocol4,protocol5,protocol6,protocol7,protocol8}]

	],
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	]
]
