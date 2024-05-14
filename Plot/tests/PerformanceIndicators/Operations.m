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
			ProtocolDelayTime[Object[Protocol, SampleManipulation, Aliquot, "id:wqW9BP7ObV1V"]],
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