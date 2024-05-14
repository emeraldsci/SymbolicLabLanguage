(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*QueueTime*)


Module[
	{
		setup1, setup2, setup3, setup4, setup5, setup6, setup7, setup8, setup9
	},
	DefineTests[
		QueueTime,
		{
			Example[
				{Basic, "Estimate the time for which a protocol will remain in the queue:"},
				QueueTime[Object[Protocol, MassSpectrometry, "id:qdkmxz0RXddp"]],
				19.40 Hour,
				Stubs :> {
					Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x_, DateCreated > y_, DateCreated > z_}, MaxResults -> 1]=Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x && DeveloperObject == True, DateCreated > y && DeveloperObject == True, DateCreated > z && DeveloperObject == True}, MaxResults -> 1]
				},
				EquivalenceFunction -> (Equal[Round[#1, 0.01], Round[#2, 0.01]]&)
			],
			Example[{Basic, "Estimate the times for which multiple protocols will remain in the queue:"},
				QueueTime[{Object[Protocol, MassSpectrometry, "id:qdkmxz0RXddp"], Object[Protocol, AbsorbanceQuantification, "id:AEqRl950XE4a"]}],
				{19.40 Hour, 12.39 Hour},
				Stubs :> {
					Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x_, DateCreated > y_, DateCreated > z_}, MaxResults -> 1]=Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x && DeveloperObject == True, DateCreated > y && DeveloperObject == True, DateCreated > z && DeveloperObject == True}, MaxResults -> 1]
				},
				EquivalenceFunction -> (Equal[Round[#1, 0.01], Round[#2, 0.01]]&)
			],
			Example[{Basic, "The minimum queue time is returned if the already elapsed wait time is greater than the estimated queue time for the input protocol type:"},
				QueueTime[Object[Protocol, MassSpectrometry, "id:1ZA60vwOlZZ6"]],
				1 Hour,
				Stubs :> {
					Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x_, DateCreated > y_, DateCreated > z_}, MaxResults -> 1]=Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x && DeveloperObject == True, DateCreated > y && DeveloperObject == True, DateCreated > z && DeveloperObject == True}, MaxResults -> 1]
				},
				EquivalenceFunction -> (Equal[Round[#1, 0.01], Round[#2, 0.01]]&)
			],
			Example[{Basic, "The average queue time across all protocol types is returned if the input protocol type has not been recently run:"},
				QueueTime[Object[Protocol, DNASynthesis, "id:qdkmxzqeXVVx"]],
				UnitScale[47.74 Hour],
				Stubs :> {
					Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x_, DateCreated > y_, DateCreated > z_}, MaxResults -> 1]=Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x && DeveloperObject == True, DateCreated > y && DeveloperObject == True, DateCreated > z && DeveloperObject == True}, MaxResults -> 1]
				},
				EquivalenceFunction -> (Equal[Round[#1, 0.01], Round[#2, 0.01]]&)
			],
			Example[
				{Additional, "To estimate the time until a backlogged protocol is started, the backlog time and queue time can be summed:"},
				BacklogTime[Object[Protocol, MeasureVolume, "Backlogged Protocol"]] + QueueTime[Object[Protocol, MeasureVolume, "Backlogged Protocol"]],
				137.17 Hour,
				Stubs :> {
					Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x_, DateCreated > y_, DateCreated > z_}, MaxResults -> 1]=Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x && DeveloperObject == True, DateCreated > y && DeveloperObject == True, DateCreated > z && DeveloperObject == True}, MaxResults -> 1],
					(* Stub BacklogTime since we only want to test QueueTime in these tests *)
					BacklogTime[Object[Protocol, MeasureVolume, "Backlogged Protocol"]]:=5.3 Day
				},
				EquivalenceFunction -> (Equal[Round[Convert[#1, Hour], 0.01], Round[Convert[#2, Hour], 0.01]]&)
			],
			Example[{Messages, "NonEnqueuedProtocols", "Requesting a queue time estimate for a protocol which is not in the backlog or the queue will fail:"},
				QueueTime[Object[Protocol, HPLC, "id:4pO6dMWLY10L"]],
				$Failed,
				Messages :> Experiment::NonProcessingProtocols
			],
			Example[{Messages, "NoQueueTimesReportFound", "If No Object[Report,QueueTimes] can be found for the last month, default times will be used:"},
				QueueTime[{Object[Protocol, MassSpectrometry, "id:qdkmxz0RXddp"], Object[Protocol, AbsorbanceQuantification, "id:AEqRl950XE4a"]}],
				{24 Hour, 24 Hour},
				Messages :> Experiment::NoQueueTimesReportFound,
				Stubs :> {
					Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x_, DateCreated > y_, DateCreated > z_}, MaxResults -> 1]={{}, {}, {}}
				},
				EquivalenceFunction -> (Equal[Round[#1, 0.01], Round[#2, 0.01]]&)
			],
			Test["Empty list input returns empty list:",
				QueueTime[{}],
				{}
			],
			Test["Accepts protocol links as input:",
				QueueTime[{Link[Object[Protocol, MassSpectrometry, "id:qdkmxz0RXddp"], Subprotocols, "linkID"], Link[Object[Protocol, AbsorbanceQuantification, "id:AEqRl950XE4a"], Subprotocols, "linkID"]}],
				{19.40 Hour, 12.39 Hour},
				Stubs :> {
					Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x_, DateCreated > y_, DateCreated > z_}, MaxResults -> 1]=Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x && DeveloperObject == True, DateCreated > y && DeveloperObject == True, DateCreated > z && DeveloperObject == True}, MaxResults -> 1]
				},
				EquivalenceFunction -> (Equal[Round[#1, 0.01], Round[#2, 0.01]]&)
			],
			Test["Accepts protocol packets as input:",
				QueueTime[Download[{Object[Protocol, MassSpectrometry, "id:qdkmxz0RXddp"], Object[Protocol, AbsorbanceQuantification, "id:AEqRl950XE4a"]}]],
				{19.40 Hour, 12.39 Hour},
				Stubs :> {
					Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x_, DateCreated > y_, DateCreated > z_}, MaxResults -> 1]=Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x && DeveloperObject == True, DateCreated > y && DeveloperObject == True, DateCreated > z && DeveloperObject == True}, MaxResults -> 1]
				},
				EquivalenceFunction -> (Equal[Round[#1, 0.01], Round[#2, 0.01]]&)
			],
			Test["Searches up to 1 week back for Object[Report,QueueTimes] if nothing found in past 25 hours:",
				QueueTime[Object[Protocol, DNASynthesis, "id:qdkmxzqeXVVx"]],
				UnitScale[47.74 Hour],
				SetUp :> {
					Upload[<|Object -> Object[Report, QueueTimes, "id:6V0npvmJ54Xw"], DateCreated -> DateObject[{2018, 5, 1, 15, 41, 51.}, "Instant", "Gregorian", -7.]|>]
				},
				TearDown :> {
					Upload[<|Object -> Object[Report, QueueTimes, "id:6V0npvmJ54Xw"], DateCreated -> DateObject[{2018, 5, 3, 1, 0, 0}, "Instant", "Gregorian", -7.]|>]
				},
				Stubs :> {
					Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x_, DateCreated > y_, DateCreated > z_}, MaxResults -> 1]=Search[{Object[Report, QueueTimes], Object[Report, QueueTimes], Object[Report, QueueTimes]}, {DateCreated > x && DeveloperObject == True, DateCreated > y && DeveloperObject == True, DateCreated > z && DeveloperObject == True}, MaxResults -> 1]
				},
				EquivalenceFunction -> (Equal[Round[#1, 0.01], Round[#2, 0.01]]&)
			]
		},
		Stubs :> {
			Now=DateObject[{2018, 5, 3, 15, 41, 51.}, "Instant", "Gregorian", -7.]
		}
	]
];


