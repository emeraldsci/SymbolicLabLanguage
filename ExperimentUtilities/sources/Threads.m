(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*OpenThreads*)


(* ::Subsubsection::Closed:: *)
(*OpenThreads Options and Messages*)


DefineOptions[OpenThreads,
	Options :> {CacheOption}
];


(* ::Subsubsection::Closed:: *)
(*OpenThreads*)


(* Empty list case returns an empty list *)
OpenThreads[{}, OptionsPattern[]]:={};

(* If no input is given, run the function on the person ID that is calling the function *)
OpenThreads[myOptions:OptionsPattern[]]:=OpenThreads[$PersonID, myOptions];

(* Overload that takes in a user object *)
OpenThreads[myUser:ObjectP[Object[User]], myOptions:OptionsPattern[]]:=Module[{safeOptions, cacheOption, teamPackets,
	teams, passedCache},

	(* default any incorrectly specified or unspecified options *)
	safeOptions=SafeOptions[OpenThreads, ToList[myOptions]];

	(* extract out the cache option *)
	cacheOption=Lookup[safeOptions, Cache];

	(* Download the financing teams of the user *)
	teamPackets=Download[myUser, Packet[FinancingTeams[NotebooksFinanced]], Cache -> cacheOption];

	(* Pull out the team objects *)
	teams=Download[teamPackets, Object];

	(* Join the cache and the newly downloaded packets to pass to main OpenThreads overload *)
	passedCache=Join[cacheOption, teamPackets];

	OpenThreads[teams, Cache -> passedCache]
];

(* Singleton case returns singleton value *)
OpenThreads[myTeam:ObjectP[Object[Team, Financing]], myOptions:OptionsPattern[]]:=First[OpenThreads[{myTeam}, myOptions]];

(* List case *)
OpenThreads[myTeams : {ObjectP[Object[Team, Financing]]..}, myOptions : OptionsPattern[]] := Module[
	{safeOptions, cacheOption, protocolPacketsPerTeam, openThreads, allQueuePackets, processingSubprotocolsPerTeam,
		cache, fastAssoc},

	(* default any incorrectly specified or unspecified options *)
	safeOptions = SafeOptions[OpenThreads, ToList[myOptions]];

	(* extract out the cache option *)
	cacheOption = Lookup[safeOptions, Cache];

	(* Download the protocols in each team's queue. *)
	allQueuePackets = Quiet[
		Download[
			myTeams,
			{
				Packet[Queue[{OperationStatus, Status, Type, Subprotocols, Incubators}]],
				Packet[Queue[Incubators][ProvidedStorageCondition]],
				Packet[Queue[Subprotocols]..[{Incubators, Status, OperationStatus}]],
				Packet[Queue[Subprotocols]..[Incubators][ProvidedStorageCondition]]
			}
		],
		Download::FieldDoesntExist
	];

	(* get the complicated mess of the above Download into an easily-accessed fastAssoc hash table *)
	cache = Experiment`Private`FlattenCachePackets[{cacheOption, allQueuePackets}];
	fastAssoc = Experiment`Private`makeFastAssocFromCache[cache];

	(* get all the root protocol packets from the queue.  That's simple enough *)
	protocolPacketsPerTeam = allQueuePackets[[All, 1]];

	(* get all the subprotocols that are processing.  This is a little goofier but still doable *)
	processingSubprotocolsPerTeam = Map[
		Function[{subprotsPerTeam},
			Map[
				Function[{subProtsPerQueueProt},
					Cases[Flatten[subProtsPerQueueProt], KeyValuePattern[Status -> Processing]]
				],
				subprotsPerTeam
			]
		],
		allQueuePackets[[All, 3]]
	];

	(* We use a thread if we're not ShippingMaterials, not OperatorStart, and not incubating cells (except the custom incubators, which DO count towards thread usage). *)
	openThreads = MapThread[
		Function[{teamProtPackets, teamSubprotPackets},
			MapThread[
				Function[{protPacket, subprotPackets},
					Which[
						(* if the protocol is not processing, do not count it against the current thread count *)
						MatchQ[Lookup[protPacket, Status], Except[Processing]], Nothing,
						(* if the protocol or subprotocol type is IncubateCells and it is not using a custom incubator (i.e., all incubators have a ProvidedStorageCondition), do not count the thread against their current usage *)
						With[{incubateCellsProtPacket = FirstCase[Flatten[{protPacket, subprotPackets}], PacketP[Object[Protocol, IncubateCells]], Null]},
							And[
								Not[NullQ[incubateCellsProtPacket]],
								MatchQ[Lookup[incubateCellsProtPacket, OperationStatus], InstrumentProcessing],
								MatchQ[Experiment`Private`fastAssocLookup[fastAssoc, Lookup[incubateCellsProtPacket, Object], {Incubators, ProvidedStorageCondition}], {ObjectP[Model[StorageCondition]]..}]
							]
						], Nothing,
						(* Do not count Qualifications and Maintenances *)
						MatchQ[Lookup[protPacket, Type], Except[TypeP[Object[Protocol]]]], Nothing,
						(* In all other cases, if the protocol is processing, show the thread as occupied *)
						True, protPacket

					]
				],
				{teamProtPackets, teamSubprotPackets}
			]
		],
		{protocolPacketsPerTeam, processingSubprotocolsPerTeam}
	];

	(* Return our protocols using threads. *)
	Lookup[#, Object, {}]& /@ openThreads
];



(* ::Subsection:: *)
(*AvailableThreads*)


(* ::Subsubsection::Closed:: *)
(*AvailableThreads Options and Messages*)


DefineOptions[AvailableThreads,
	Options :> {
		{
			AllowNegative -> False,
			BooleanP,
			"Indicates if the AvailableThreads can be negative (i.e., include the overclocking protocols)."
		},
		CacheOption
	}
];



(* ::Subsubsection:: *)
(*AvailableThreads*)


(* Empty list case returns an empty list *)
AvailableThreads[{}, OptionsPattern[]]:={};

(* If no input is given, run the function on the person ID that is calling the function *)
AvailableThreads[myOptions:OptionsPattern[]]:=AvailableThreads[$PersonID, myOptions];

(* Overload that takes in a user object *)
AvailableThreads[myUser:ObjectP[Object[User]], myOptions:OptionsPattern[]]:= Module[
	{safeOptions, cacheOption, teamPackets, teams, passedCache, allowNegative},

	(* default any incorrectly specified or unspecified options *)
	safeOptions = SafeOptions[AvailableThreads, ToList[myOptions]];

	(* extract out the cache option *)
	{allowNegative, cacheOption} = Lookup[safeOptions, {AllowNegative, Cache}];

	(* Download the financing teams of the user *)
	teamPackets = Download[myUser, Packet[FinancingTeams[{MaxThreads, NotebooksFinanced, Queue}]]];

	(* Pull out the team objects *)
	teams = Download[teamPackets, Object];

	(* Join the cache and the newly downloaded packets to pass to main OpenThreads overload *)
	passedCache = Join[cacheOption, teamPackets];

	AvailableThreads[teams, Cache -> passedCache, AllowNegative -> allowNegative]

];

(* Singleton case returns singleton value *)
AvailableThreads[myTeam : ObjectP[Object[Team, Financing]], myOptions : OptionsPattern[]] := First[AvailableThreads[{myTeam}, myOptions]];

(* List case *)
AvailableThreads[myTeams : {ObjectP[Object[Team, Financing]]..}, myOptions : OptionsPattern[]] := Module[
	{safeOptions, cacheOption, maxThreads, nonBlockedParentProtocols, teamPackets, notebooks, passedCache, allowNegative},

	(* default any incorrectly specified or unspecified options *)
	safeOptions = SafeOptions[AvailableThreads, ToList[myOptions]];

	(* extract out the needed options *)
	{allowNegative, cacheOption} = Lookup[safeOptions, {AllowNegative, Cache}];

	(* If we can't find any of our teams, return 0 as the result. *)
	If[MemberQ[DatabaseMemberQ[myTeams], False],
		Return[ConstantArray[0, Length[myTeams]]];
	];

	(* Download call to get the max threads and notebooks of each team. (Downloading the notebook because we will pass it in the cache to OpenThreads). *)
	teamPackets = Download[Download[myTeams, Object], Packet[MaxThreads, NotebooksFinanced, Queue]];
	notebooks = Lookup[teamPackets, NotebooksFinanced];

	(* Join the cache and the newly downloaded packets to pass to OpenThreads *)
	passedCache = Join[cacheOption, teamPackets];

	(* Pull how the max number of threads for each time*)
	maxThreads = Lookup[teamPackets, MaxThreads];

	(* Get a list of protocols using threads *)
	nonBlockedParentProtocols = OpenThreads[myTeams, Cache -> passedCache];

	(* Determine the remaining available threads for each team which is:
	  - total max threads they can use
	  - minus number of currently running protocols/recently completed protocols (from OpenThreads)
	  - if we have a negative number, this is because of Overclock -> True protocols and can be allowed; return a negative number if desired
	*)
	If[allowNegative,
		#& /@ (maxThreads - (Length /@ nonBlockedParentProtocols)),
		Max[#, 0]& /@ (maxThreads - (Length /@ nonBlockedParentProtocols))
	]

];