(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsubsection::Closed:: *)
(* billing team *)

billingTeam:=billingTeam=Search[Object[User,Emerald,Developer],Status==Active&&Department==ScientificSolutions];

(* ::Subsubsection::Closed:: *)
(* runSyncBilling *)

DefineOptions[runSyncBilling,
	Options :> {
		{Notify -> True, True | False, "Indicates if an asana task should be created when the functions run successfully or fail."},
		{Verbose -> False, True | False, "Indicates if progress updates will be returned. Currently disabled, no updates returned even if Verbose -> True."}
	}
];


(* runSyncBilling is a wrapper that goes around SyncBilling when it is run as a nightly script *)
(* it checks the timing, looks for failed instances, and returns an asana task with a summary of how the SyncBilling function has worked *)

(* single input and empty list overloads *)
runSyncBilling[team:ObjectP[Object[Team, Financing]], ops:OptionsPattern[runSyncBilling]]:=runSyncBilling[{team}, ops];
runSyncBilling[teams:{ObjectP[Object[Team, Financing]]..}, ops:OptionsPattern[runSyncBilling]]:=runSyncBillingCore[teams, ops];

(* empty list overload *)
runSyncBilling[{}, ops:OptionsPattern[runSyncBilling]]:=Module[{safeOps, notifyQ},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[runSyncBilling, ToList[ops]];
	notifyQ=Lookup[safeOps, Notify];

	(* return either an asana task or text *)
	If[notifyQ && ProductionQ[],
		ECL`CreateAsanaTask[<|
			Name -> "runSyncBilling: no active teams",
			Completed -> False,
			Notes -> "The runSyncBilling run at: "<>DateString[Now]<>" did not find any active Object[Team, Financing].\n"<>"Computation Object: "<>ToString[$ManifoldComputation,InputForm],
			Projects -> {"Business Operations"},
			Tags -> {"P5"},
			DueDate -> (Now + 3 Day)
		|>],
		"The runSyncBilling run at: "<>DateString[Now]<>" did not find any active Object[Team, Financing]."
	]
];

(* main overload that searches *)
runSyncBilling[All, ops:OptionsPattern[runSyncBilling]]:=Module[{allActiveTeams},
	(* find any financing teams that are active and are on this pricing scheme*)
	allActiveTeams=Search[Object[Team, Financing], Status == Active && CurrentPriceSchemes != (Null|{})];
	runSyncBilling[allActiveTeams, ops]
];

(* CORE function *)
runSyncBillingCore[teams:{ObjectP[Object[Team, Financing]]..}, ops:OptionsPattern[runSyncBilling]]:=Module[
	{
		outputTuples, goodOutputBools, timeoutBools, times, outputDataHeader, tableOutput,
		safeOps, notifyQ, goodOutputEntries, goodOutputTable, badOutputEntries, badOutputTable,
		startTime, endTime
	},

	(* get our safe options *)
	(* we always want to run this nightly overload with Verbose -> True so we can track progress *)
	safeOps=SafeOptions[runSyncBilling, ReplaceRule[ToList[ops],Verbose->True]];
	notifyQ=Lookup[safeOps, Notify];
	startTime = Now;

	(* run the check for mismatches in the Object[Bill] and the Model[Pricing] associated with it *)
	(* pass the same notification option that SyncBilling is getting *)
	(* there is no reason this should hang, but since we dont want to prevent SyncBilling from running make it time constrained *)
	TimeConstrained[billPricingMatchQ[CreateTask -> notifyQ], 300];


	(* run the SyncBilling function on all active teams *)
	outputTuples=Map[
		AbsoluteTiming[
			TimeConstrained[
				SyncBilling[#, Notify -> True],
				7200
			]
		]&,
		teams
	];

	(* figure out if the function actually ran or if it timed out *)
	{goodOutputBools, timeoutBools}=Transpose[
		Map[
			Which[
				(* good output *)
				MatchQ[#, {ObjectP[]..}],
				{True, False},

				(* bad output due to timeout *)
				MatchQ[#, $Aborted],
				{False, True},

				(* bad output, but not because of timeout *)
				True,
				{False, False}
			]&,
			outputTuples[[All, 2]]
		]
	];

	(* get the amount of time it took to run this function *)
	times=outputTuples[[All, 1]];

	endTime = Now;

	(* format the data for output *)
	outputDataHeader="Financing Team\t\tSuccessful Run\t\tTimeout\t\tTotal Time\n";
	goodOutputEntries = Cases[Transpose@{teams, goodOutputBools, timeoutBools, times},{_, True, False, _}];
	goodOutputTable=If[Length[goodOutputEntries]==0,
		"",
		"\n\n"<>outputDataHeader<>Map[
			StringJoin[{
				ToString[Download[#[[1]], ID]],
				"\t\t",
				ToString[#[[2]]],
				"\t\t",
				ToString[#[[3]]],
				"\t\t",
				ToString[#[[4]]],
				"\n"}]&,
			goodOutputEntries]
	];
	badOutputEntries = Cases[Transpose@{teams, goodOutputBools, timeoutBools, times},Except[{_, True, False, _}]];
	badOutputTable = If[Length[badOutputEntries]==0,
		"",
		"\n\n"<>outputDataHeader<>Map[
			StringJoin[{
				ToString[Download[#[[1]], ID]],
				"\t\t",
				ToString[#[[2]]],
				"\t\t",
				ToString[#[[3]]],
				"\t\t",
				ToString[#[[4]]],
				"\n"}]&,
			badOutputEntries]
	];

	(* also format the output if we decide to not make asana task *)
	tableOutput=PlotTable[Transpose[{teams, goodOutputBools, timeoutBools, times}], TableHeadings -> {None, {"Financing Team", "Successful Run", "Timeout", "Total Time"}}];

	(* generate the output either as an asana task or a table *)
	If[notifyQ && ProductionQ[] && MemberQ[goodOutputBools, False],
		ECL`CreateAsanaTask[<|
			Name -> "runSyncBilling completed at "<>DateString[Now],
			Completed -> False,
			Notes -> StringJoin[
				"runSyncBilling has completed. Please find a summary of the runSyncBilling results below and contact the development team to address any Timeout and Result failures.\n This computation",
				goodOutputTable,
				"\n\n",
				badOutputTable,
				"\n\n",
				"Start Time:\t", DateString[startTime],
				"\n",
				"End Time:\t", DateString[endTime],
				"\n",
				"Duration:\t", ToString[Unitless[UnitConvert[endTime-startTime, "Hours"]]],"Hours",
				"\n",
				"Computation Object:\t", ToString[$ManifoldComputation, InputForm]
				],
			Followers -> billingTeam,
			Projects -> {"Business Operations"},
			Tags -> {"P5"},
			DueDate -> (Now + 3 Day)
		|>]
	];

	(* always return a table - even if we made asana task we want a table for Script purposes *)
	tableOutput
];





(* ::Subsection:: *)
(*SyncBilling*)


(* ::Subsubsection::Closed:: *)
(*SyncBilling*)

DefineOptions[SyncBilling,
	Options :> {
		{Notify -> False, True | False, "Indicates if notification will be send to financing when a bill has completed."},
		{Fail -> False, True | False, "Indicates if we should fail a Pricing function for testing reasons.", Category -> Hidden},
		{Verbose -> False, True | False, "Indicates if progress updates will be returned."},
		UploadOption,
		CacheOption
	}
];
SyncBilling::FinancingTeamDoesNotExist="The provided object `1` does not exist in the database.";
SyncBilling::ActiveTeamsOnly="SyncBilling can not create new bills on non-active teams.";
SyncBilling::PricingFunctionFailed="The following pricing functions were not able to properly evaluate: `1`. Investigate the specific error messages and contact ECL for assistance.";
SyncBilling::NotConfiguredTeam="SyncBilling can not create new bills for a team without CurrentPricingScheme or NextBillingCycle.";

SyncBilling::PriceStorage="PriceStorage returned some unexpected values. Outputs must match `1`. Check `2`";
SyncBilling::PriceTransactions="PriceTransactions returned some unexpected values. Outputs must match `1`. Check `2`";
SyncBilling::PriceCleaning="PriceCleaning returned some unexpected values. Outputs must match `1`. Check `2`";
SyncBilling::PriceStocking="PriceStocking returned some unexpected values. Outputs must match `1`. Check `2`";
SyncBilling::PriceMaterials="PriceMaterials returned some unexpected values. Outputs must match `1`. Check `2`";
SyncBilling::PriceWaste="PriceWaste returned some unexpected values. Outputs must match `1`. Check `2`";
SyncBilling::PriceOperatorTime="PriceOperatorTime returned some unexpected values. Outputs must match `1`. Check `2`";
SyncBilling::PriceInstrumentTime="PriceInstrumentTime returned some unexpected values. Outputs must match `1`. Check `2`";
SyncBilling::PriceProtocol="PriceProtocol returned some unexpected values. Outputs must match `1`. Check `2`";

(* Sync Billing should determine when a bill was last synced, and run PriceExperiment on the timeframe from that date to now *)
(* it should take the output from PriceExperiment, sort it by the billing category, and upload to the appropriate field *)
(* it also needs to call PriceTransaction and PriceShipping to make sure that those fields are added *)
(* if the bill is closed, we need to make sure to subtract their InstrumentTime etc allowance and not charge them for it *)
(* the output of SyncBilling is a list of all the bills that were modified (either created or updated) *)
(* when a bill is due, SyncBilling creates an Asana task to the Financing team so they know what to charge the customer *)
SyncBilling[financingTeam:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]]:=Module[
	{
		safeOps,teamPacket,uploadQ,cache,failQ,debugQ,messagesThrownQ,messagesThrown,
		activeTeamQ,newBillsQ,notifyQ,billFieldDefinitions,
		newBillPackets,closingBillQ,currentBillingHistory,updatedBillingHistory,newBill,flatMessagesThrown,

		(* housekeeping updates *)
		objectTeamUpdates,currentBillsUpdatePackets,allUpdatePackets,dateCompleted,startDate,closingBillHistoryUpdate,
		updatedConstellationUsageLog,timeSpan,pricingUpdatePackets,
		failedHelpers,

		(* pricing packets *)
		protocolPricingPackets,instrumentPricingPackets,operatorPricingPackets,wastePricingPackets,materialsPricingPackets,
		stockingPricingPackets,cleaningPricingPackets,transactionsPricingPackets,dataPricingPackets,storagePricingPackets,
		groupedProtocolPricingPackets,groupedInstrumentPricingPackets, groupedOperatorPricingPackets,groupedWastePricingPackets,
		groupedMaterialsPricingPackets,groupedStockingPricingPackets,groupedCleaningPricingPackets,groupedTransactionsPricingPackets,
		groupedStoragePricingPackets,groupedDataPricingPackets,

		(* discounting and formatting *)
		totalCharges,

		(* notebook formatting *)
		notebook,

		(* debugging values *)
		postProcessingStart,validUpload,
		priceSchemePackets,currentBillPackets
	},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[SyncBilling, ToList[ops]];
	uploadQ=Lookup[safeOps, Upload];
	notifyQ=Lookup[safeOps, Notify];
	cache=Lookup[safeOps, Cache, {}];
	failQ=Lookup[safeOps, Fail];
	debugQ=Lookup[safeOps, Verbose];

	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]],
		Echo[financingTeam,"Financing team:"]
	];

	(* kill switch up front since theres not point proceeding if the object is bad *)
	If[!DatabaseMemberQ[financingTeam],
		Message[SyncBilling::FinancingTeamDoesNotExist, financingTeam];
		Return[$Failed]
	];

	(* Update the Object[Bill] in case we have changed the number of threads or any related things *)
	(* helper is separated so we can properly test the functionality *)
	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]],
		Echo["Updating discounts:"]
	];

	updateCurrentBillDiscounts[financingTeam];
	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]],
		Echo["Update complete:"]
	];

	(*perform our big download*)
	{
		teamPacket,
		priceSchemePackets,
		currentBillPackets,
		notebook
	}=Quiet[Download[
		financingTeam,
		{
			Packet[Name, Status, NextBillingCycle, BillingCycleLog, BillingHistory, CurrentBills, CurrentPriceSchemes, ConstellationUsageLog, DefaultExperimentSite, ExperimentSites],
			Packet[CurrentPriceSchemes[[All,1]][All]],
			Packet[CurrentBills[[All,1]][All]],
			NotebooksFinanced[[1]][Object]
		},
		Cache -> cache
	], {Download::Part}];

	(*check if the team is active*)
	activeTeamQ=MatchQ[Lookup[teamPacket, Status], Active];

	(* if the team isn't active, we dont need to bill them *)
	If[MatchQ[activeTeamQ, Except[True]],
		Message[SyncBilling::ActiveTeamsOnly];
		Return[$Failed],
		Null
	];

	(* ------------------- *)
	(* -- Open New Bill -- *)
	(* ------------------- *)

	(*we then check whether to start a new bill - if the date is past the NextBillingCycle we need to*)
	newBillsQ=If[activeTeamQ && !NullQ[Lookup[teamPacket, NextBillingCycle]],
		MatchQ[Now, GreaterP[Lookup[teamPacket, NextBillingCycle]]],
		False
	];

	(* we need this to add Replace[] later on *)
	billFieldDefinitions=ECL`Fields /. LookupTypeDefinition[Object[Bill]];

	(*if we're making a new bill, then we make a completely new packet, and inherit everything from the current pricing scheme*)
	(*Do not try to inherit the Valid key*)
	newBillPackets=If[newBillsQ,
		Map[Function[{priceSchemePacket},
			KeyDrop[
				Association[
					Object->CreateID[Object[Bill]],
					Status->Open,
					DateStarted->If[!NullQ[Lookup[teamPacket,NextBillingCycle]],
						Lookup[teamPacket,NextBillingCycle],
						Now
					],
					PricingScheme->Link[Lookup[priceSchemePacket,Object]],
					Transfer[Notebook]->Link[notebook,Objects],
					(*map through and instantiate everything from the model*)
					KeyValueMap[
						Function[{fieldName,fieldValue},
							If[MatchQ[Lookup[Lookup[billFieldDefinitions,fieldName],Format],Multiple],
								Replace[fieldName]->fieldValue,
								fieldName->fieldValue
							]/.{x_Link:>RemoveLinkID[x]}
						],
						KeyTake[priceSchemePacket,$SharedPricingFields]
					]
				],
				Valid
			]],
			priceSchemePackets]
	];

	(*DO NOT call PriceExperiment etc. on the freshly made Bill. It is not uploaded until the end and will cause the pricing functions to fail. *)
	(* This function is going to run nightly, so its fine to wait 24 hours to start tracking *)

	(* ------------------------------------- *)
	(* -- Update (and Close) Current Bill -- *)
	(* ------------------------------------- *)

	(* In this section, we update the existing bill and determine if it is finished *)
	(* We have two choices for billing, either we can track each time it syncs (and append to fields just for that time period), or we can always sync billing for the latest time for the billing cycle (replace)   *)

	(* -- check if we are closing the bill -- *)

	(*check if we're closing the previous bills*)
	closingBillQ=If[!NullQ[Lookup[teamPacket, NextBillingCycle]],
		Now > Lookup[teamPacket, NextBillingCycle],
		False
	];

	(*define the closing date if needed*)
	dateCompleted=If[closingBillQ, Lookup[teamPacket, NextBillingCycle]];

	(*update the current bills with non pricing updates*)
	currentBillsUpdatePackets=If[!MatchQ[Lookup[teamPacket, CurrentBills],{}|Null|{Null}],
		Map[Function[{currentBillPacket},
			Association[
				Object->Lookup[currentBillPacket,Object],
				DateCompleted->dateCompleted,

				(* if we are closing the bill, update the Status *)
				If[closingBillQ,
					Status->Outstanding,
					Nothing
				]
			]],
			currentBillPackets]
	];

	(* in order to be flexible with the billing time span (mid-month onboarding or changing billing cycles) we need to look at the  most recent closed bill*)
	(*Note: we need to be really careful with teh way MM handles "1 Month" - as long as bills start on the 1st there are no issues, but bills that are closed at the end of the month will cause an issue. *)
	(*There is now a way to easily update NextBillingCycle to the first so we can avoid this issue*)
	(* this is not site-specific since all bills share the start/closing date across sites *)
	startDate=Module[{startDateFromLastBill},

		(*closed bills have *)
		startDateFromLastBill=LastOrDefault[Cases[Lookup[teamPacket, BillingHistory], {_?DateObjectQ, _, _, _}]];

		(* if there are no closed bills to look at then lets take the closing date minus 1 month *)
		If[MatchQ[startDateFromLastBill, Null],
			(Lookup[teamPacket, NextBillingCycle] - 1 Month),

			(*if we do have a closed bill, make sure that this isn't a returning client - if the date of closing is over a month old, do not use it*)
			(*also, if we are doing a trick to regenerate an old bill, Now may be blocked to a date prior to the end date of the last closed bill. In that case, just bill the previous month*)
			If[MatchQ[(Now - startDateFromLastBill[[1]]), Alternatives[GreaterP[1.2 Month], LessP[0 Month]]],
				(Lookup[teamPacket, NextBillingCycle] - 1 Month),
				startDateFromLastBill[[1]]
			]
		]
	];

	(* determine the span of time for which we are pricing - this will always start at the beginning of the billing cycle, and end either now or the end of the cycle if that has passed *)
	timeSpan=Span[
		startDate,
		Min[Now, Lookup[teamPacket, NextBillingCycle]]
	];
	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print[timeSpan]];

	(* ---------------------- *)
	(* -- Price Activities -- *)
	(* ---------------------- *)

	(* start collecting messages *)
	messagesThrown={};

	(* note that the outputs are already matching the bill fields, so just call the helpers individually. Price Experiment is a tool to price experiments but not needed here *)
	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["Starting PriceProtocol"]];
	protocolPricingPackets=If[MatchQ[currentBillPackets, {PacketP[]..}],
		Module[{evaluationData, messages, priceProtocolResult,badPriceProtocolPackets},
			evaluationData=EvaluationData[PriceProtocol[financingTeam, timeSpan, OutputFormat -> Association]];
			messages=Lookup[evaluationData, "MessagesText"];
			(* add messages to a full gathered list *)
			AppendTo[messagesThrown, messages];
			(* if we are debugging, print how long it took *)
			If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["It took: "<>ToString@Lookup[evaluationData, "AbsoluteTiming"]]];
			(* grab the results *)
			priceProtocolResult=Lookup[evaluationData, "Result"];
			(* check that the priceProtocolResult is a list of valid pricing packets *)
			badPriceProtocolPackets=Cases[priceProtocolResult,Except[ProtocolPriceTableP]];
			If[MatchQ[badPriceProtocolPackets, {}],
				priceProtocolResult,
				(Message[SyncBilling::PriceProtocol,"ProtocolPriceTableP",badPriceProtocolPackets]; Return[$Failed, Module])
			]
		],
		{}
	];

	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["Starting PriceInstrumentTime"]];
	instrumentPricingPackets=If[MatchQ[currentBillPackets, {PacketP[]..}],
		Module[{evaluationData, messages, priceInstrumentTimeResult,badPriceInstrumentPackets},
			evaluationData=EvaluationData[PriceInstrumentTime[financingTeam, timeSpan, OutputFormat -> Association, Fail -> failQ]];
			messages=Lookup[evaluationData, "MessagesText"];
			(* add messages to a full gathered list *)
			AppendTo[messagesThrown, messages];
			(* if we are debugging, print how long it took *)
			If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["It took: "<>ToString@Lookup[evaluationData, "AbsoluteTiming"]]];
			(* grab the results *)
			priceInstrumentTimeResult=Lookup[evaluationData, "Result"];
			(* check that the result is a list of valid pricing packets *)
			badPriceInstrumentPackets=Cases[priceInstrumentTimeResult,Except[InstrumentPriceTableP]];
			If[MatchQ[badPriceInstrumentPackets, {}],
				priceInstrumentTimeResult,
				(Message[SyncBilling::PriceInstrumentTime,"InstrumentPriceTableP",badPriceInstrumentPackets]; Return[$Failed, Module])
			]
		],
		{}
	];

	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["Starting PriceOperatorTime"]];
	operatorPricingPackets=If[MatchQ[currentBillPackets, {PacketP[]..}],
		Module[{evaluationData, messages, priceOperatorTimeResult,badPriceOperatorPackets},
			evaluationData=EvaluationData[PriceOperatorTime[financingTeam, timeSpan, OutputFormat -> Association]];
			messages=Lookup[evaluationData, "MessagesText"];
			(* add messages to a full gathered list *)
			AppendTo[messagesThrown, messages];
			(* if we are debugging, print how long it took *)
			If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["It took: "<>ToString@Lookup[evaluationData, "AbsoluteTiming"]]];
			(* grab the results *)
			priceOperatorTimeResult=Lookup[evaluationData, "Result"];
			(* check that the result is a list of valid pricing packets *)
			badPriceOperatorPackets=Cases[priceOperatorTimeResult,Except[OperatorPriceTableP]];
			If[MatchQ[badPriceOperatorPackets, {}],
				priceOperatorTimeResult,
				(Message[SyncBilling::PriceOperatorTime,"OperatorPriceTableP",badPriceOperatorPackets];Return[$Failed, Module])
			]
		],
		{}
	];

	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["Starting PriceWaste"]];
	wastePricingPackets=If[MatchQ[currentBillPackets, {PacketP[]..}],
		Module[{evaluationData, messages, priceWasteResult,badPriceWastePackets},
			evaluationData=EvaluationData[PriceWaste[financingTeam, timeSpan, OutputFormat -> Association]];
			messages=Lookup[evaluationData, "MessagesText"];
			(* add messages to a full gathered list *)
			AppendTo[messagesThrown, messages];
			(* if we are debugging, print how long it took *)
			If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["It took: "<>ToString@Lookup[evaluationData, "AbsoluteTiming"]]];
			(* grab the results *)
			priceWasteResult=Lookup[evaluationData, "Result"];
			(* check that the result is a list of valid pricing packets *)
			badPriceWastePackets=Cases[priceWasteResult,Except[WastePriceTableP]];
			If[MatchQ[badPriceWastePackets, {}],
				priceWasteResult,
				(Message[SyncBilling::PriceWaste,"WastePriceTableP",badPriceWastePackets]; Return[$Failed, Module])
			]
		],
		{}
	];

	If[debugQ, Print["Starting PriceMaterials"]];
	materialsPricingPackets=If[MatchQ[currentBillPackets, {PacketP[]..}],
		Module[{evaluationData, messages, priceMaterialsResult, badPriceMaterialsPackets},
			evaluationData=EvaluationData[PriceMaterials[financingTeam, timeSpan, OutputFormat -> Association]];
			messages=Lookup[evaluationData, "MessagesText"];
			(* add messages to a full gathered list *)
			AppendTo[messagesThrown, messages];
			(* if we are debugging, print how long it took *)
			If[debugQ, Print["It took: "<>ToString@Lookup[evaluationData, "AbsoluteTiming"]]];
			(* grab the results *)
			priceMaterialsResult=Lookup[evaluationData, "Result"];
			(* check that the result is a list of valid pricing packets *)
			badPriceMaterialsPackets=Cases[priceMaterialsResult,Except[MaterialsPriceTableP]];
			If[MatchQ[badPriceMaterialsPackets, {}],
				priceMaterialsResult,
				(Message[SyncBilling::PriceMaterials,"MaterialsPriceTableP",badPriceMaterialsPackets]; Return[$Failed, Module])
			]
		],
		{}
	];

	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["Starting PriceStocking"]];
	stockingPricingPackets=If[MatchQ[currentBillPackets, {PacketP[]..}],
		Module[{evaluationData, messages, priceStockingResult, badPriceStockingPackets},
			evaluationData=EvaluationData[PriceStocking[financingTeam, timeSpan, OutputFormat -> Association]];
			messages=Lookup[evaluationData, "MessagesText"];
			(* add messages to a full gathered list *)
			AppendTo[messagesThrown, messages];
			(* if we are debugging, print how long it took *)
			If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["It took: "<>ToString@Lookup[evaluationData, "AbsoluteTiming"]]];
			(* grab the results *)
			priceStockingResult=Lookup[evaluationData, "Result"];
			(* check that the result is a list of valid pricing packets *)
			badPriceStockingPackets=Cases[priceStockingResult,Except[StockingPriceTableP]];
			If[MatchQ[badPriceStockingPackets, {}],
				priceStockingResult,
				(Message[SyncBilling::PriceStocking,"StockingPriceTableP",badPriceStockingPackets]; Return[$Failed, Module])
			]
		],
		{}
	];

	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["Starting PriceCleaning"]];
	cleaningPricingPackets=If[MatchQ[currentBillPackets, {PacketP[]..}],
		Module[{evaluationData, messages, priceCleaningResult, badPriceCleaningPackets},
			evaluationData=EvaluationData[PriceCleaning[financingTeam, timeSpan, OutputFormat -> Association]];
			messages=Lookup[evaluationData, "MessagesText"];
			(* add messages to a full gathered list *)
			AppendTo[messagesThrown, messages];
			(* if we are debugging, print how long it took *)
			If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["It took: "<>ToString@Lookup[evaluationData, "AbsoluteTiming"]]];
			(* grab the results *)
			priceCleaningResult=Lookup[evaluationData, "Result"];
			(* check that the result is a list of valid pricing packets *)
			badPriceCleaningPackets=Cases[priceCleaningResult,Except[CleaningPriceTableP]];
			If[MatchQ[badPriceCleaningPackets, {}],
				priceCleaningResult,
				(Message[SyncBilling::PriceCleaning,"CleaningPriceTableP",badPriceCleaningPackets]; Return[$Failed, Module])
			]
		],
		{}
	];

	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["Starting PriceTransactions"]];
	transactionsPricingPackets=If[MatchQ[currentBillPackets, {PacketP[]..}],
		Module[{evaluationData, messages, priceTransactionsResult, badPriceTransactionsPackets},
			evaluationData=EvaluationData[PriceTransactions[financingTeam, timeSpan, OutputFormat -> Association]];
			messages=Lookup[evaluationData, "MessagesText"];
			(* add messages to a full gathered list *)
			AppendTo[messagesThrown, messages];
			(* if we are debugging, print how long it took *)
			If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["It took: "<>ToString@Lookup[evaluationData, "AbsoluteTiming"]]];
			(* grab the results *)
			priceTransactionsResult=Lookup[evaluationData, "Result"];
			(* check that the result is a list of valid pricing packets *)
			badPriceTransactionsPackets=Cases[priceTransactionsResult,Except[TransactionsPriceTableP]];
			If[MatchQ[badPriceTransactionsPackets, {}],
				priceTransactionsResult,
				(Message[SyncBilling::PriceTransactions,"TransactionsPriceTableP",badPriceTransactionsPackets]; Return[$Failed, Module])
			]
		],
		{}
	];

	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["Starting PriceStorage"]];
	storagePricingPackets=If[MatchQ[currentBillPackets, {PacketP[]..}],
		Module[{evaluationData, messages, priceStorageResult, badPriceStoragePackets},
			evaluationData=EvaluationData[PriceStorage[financingTeam, timeSpan, OutputFormat -> Association]];
			messages=Lookup[evaluationData, "MessagesText"];
			(* add messages to a full gathered list *)
			AppendTo[messagesThrown, messages];
			(* if we are debugging, print how long it took *)
			If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["It took: "<>ToString@Lookup[evaluationData, "AbsoluteTiming"]]];
			(* grab the results *)
			priceStorageResult=Lookup[evaluationData, "Result"];
			(* check that the result is a list of valid pricing packets *)
			badPriceStoragePackets=Cases[priceStorageResult,Except[StoragePriceTableP]];
			If[MatchQ[badPriceStoragePackets, {}],
				priceStorageResult,
				(Message[SyncBilling::PriceStorage,"StoragePriceTableP",badPriceStoragePackets]; Return[$Failed, Module])
			]
		],
		{}
	];

	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["Starting PriceData"]];
	(* data uses the current data, which we will use the end date of the billing cycle or now *)
	dataPricingPackets=If[MatchQ[currentBillPackets, {PacketP[]..}],
		Module[{evaluationData, messages, priceDataResult, badPriceDataPackets},
			evaluationData=EvaluationData[PriceData[financingTeam, Min[Now, Lookup[teamPacket, NextBillingCycle]], OutputFormat -> Association]];
			messages=Lookup[evaluationData, "MessagesText"];
			(* add messages to a full gathered list *)
			AppendTo[messagesThrown, messages];
			(* if we are debugging, print how long it took *)
			If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["It took: "<>ToString@Lookup[evaluationData, "AbsoluteTiming"]]];
			(* grab the results *)
			priceDataResult=Lookup[evaluationData, "Result"];
			(* check that the result is a list of valid pricing packets *)
			badPriceDataPackets=Cases[priceDataResult,Except[DataPriceTableP]];
			If[MatchQ[badPriceDataPackets, {}],
				priceDataResult,
				(Message[SyncBilling::PriceData,"DataPriceTableP",badPriceDataPackets]; Return[$Failed, Module])
			]
		],
		{}
	];

	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["Starting post-processing"];postProcessingStart=AbsoluteTime[];];

	(* determine if any of the sub functions filed *)
	failedHelpers=PickList[
		{PriceProtocol, PriceInstrumentTime, PriceOperatorTime, PriceWaste, PriceMaterials, PriceStocking, PriceCleaning, PriceTransactions, PriceStorage, PriceData},
		{protocolPricingPackets, instrumentPricingPackets, operatorPricingPackets, wastePricingPackets, materialsPricingPackets, stockingPricingPackets, cleaningPricingPackets, transactionsPricingPackets, storagePricingPackets, dataPricingPackets},
		$Failed
	];

	messagesThrownQ=Length[Flatten@messagesThrown] > 0;

	(* if any of these guys failed, exit early *)
	If[!MatchQ[failedHelpers,{}],
		Message[SyncBilling::PricingFunctionFailed,failedHelpers];
		(* make tasks only on production *)
		If[ProductionQ[],
			With[{teamString=ToString[NamedObject[financingTeam],InputForm]},
				ECL`CreateAsanaTask[<|
					Name->"Bill update failed for "<>teamString,
					Completed->False,
					Notes->"Bill for the "<>teamString<>" has failed. Failed helpers: "<>ToString[failedHelpers,InputForm],
					Projects->{"Business Operations"},
					Tags->{"P5"},
					DueDate->(Now + 3 Day)
				|>]]
		];
		Return[$Failed]
	];

	(*-- verify that we are multi-site OK and sort things into appropriate buckets --*)
	{
		groupedProtocolPricingPackets, groupedInstrumentPricingPackets, groupedOperatorPricingPackets, groupedWastePricingPackets,
		groupedMaterialsPricingPackets, groupedStockingPricingPackets, groupedCleaningPricingPackets, groupedTransactionsPricingPackets,
		groupedStoragePricingPackets, groupedDataPricingPackets
	} = Map[GroupBy[#,Lookup[#,Site]&]&,
		{
			protocolPricingPackets, instrumentPricingPackets, operatorPricingPackets, wastePricingPackets,
			materialsPricingPackets, stockingPricingPackets, cleaningPricingPackets, transactionsPricingPackets,
			storagePricingPackets, dataPricingPackets
		}];

	(* ----------------------- *)
	(* -- Make Bill Updates -- *)
	(* ----------------------- *)
	pricingUpdatePackets=Map[With[{currentSite=Download[Lookup[#,Site],Object]},
		generateBillUpdates[#,
			notebook,
			Lookup[groupedProtocolPricingPackets,currentSite,{}],
			Lookup[groupedInstrumentPricingPackets, currentSite,{}],
			Lookup[groupedOperatorPricingPackets, currentSite,{}],
			Lookup[groupedWastePricingPackets, currentSite,{}],
			Lookup[groupedMaterialsPricingPackets, currentSite,{}],
			Lookup[groupedStockingPricingPackets, currentSite,{}],
			Lookup[groupedCleaningPricingPackets, currentSite,{}],
			Lookup[groupedTransactionsPricingPackets, currentSite,{}],
			Lookup[groupedStoragePricingPackets, currentSite,{}],
			Lookup[groupedDataPricingPackets, currentSite,{}]
		]]&,currentBillPackets];

	(* ----------------------- *)
	(* -- Make Team Updates -- *)
	(* ----------------------- *)

	(* -- Update the BillingHistory as needed -- *)

	(*get the current billing history*)
	currentBillingHistory=Lookup[teamPacket, BillingHistory] /. {x_Link :> RemoveLinkID[x]};
	(* pull the site of the Bill, for the transition period, assume that if we don't have one populated we can use $Site *)

	(*make any changes to the billing history that are needed*)
	updatedBillingHistory=If[NullQ[currentBillingHistory] || MatchQ[currentBillingHistory,{}],

		(*if this is the first time, then we make completely new*)
		MapThread[
			{Null,Link[Download[#1,Object],Organization],Link[Download[#2,Object]],Link[Download[Lookup[#1,Site],Object]]}&,
			{newBillPackets,priceSchemePackets}
		],

		(*otherwise we check to see if we need to update the billing history*)
		(
			closingBillHistoryUpdate=If[closingBillQ,
				Module[{closingBillPositions,closingBillTuples,updatedClosingBillTuples},

					(*if we're closing a bill, we'll want to update the tuple in the billing history so extract the position of the current bill that we are closing*)
					closingBillPositions=Map[First@FirstPosition[currentBillingHistory,{_,LinkP[Download[#,Object]],_,_}]&,currentBillPackets];

					(*get the tuple using the position*)
					closingBillTuples=currentBillingHistory[[closingBillPositions]];

					(*update the date within it*)
					updatedClosingBillTuples=ReplacePart[#,1->dateCompleted]&/@closingBillTuples;

					(*update the billing history*)
					ReplacePart[currentBillingHistory,Rule@@@Transpose[{closingBillPositions,updatedClosingBillTuples}]]
				],
				(*if not closing a bill, just return the current one*)
				currentBillingHistory
			];

			(*check if we need to instantiate the new bill*)
			If[newBillsQ,
				Join[
					closingBillHistoryUpdate,
					MapThread[
						{Null,Link[Download[#1,Object],Organization],Link[Download[#2,Object]],Link[Download[Lookup[#1,Site],Object]]}&,
						{newBillPackets,priceSchemePackets}]
				],
				(*otherwise, don't do anything*)
				closingBillHistoryUpdate
			]
		)
	];


	(* -- Update the CurrentBills and Billing History -- *)

	(*update the constellation usage log - this counts how many objects they are currently storing*)
	updatedConstellationUsageLog={
		Min[Now, Lookup[teamPacket, NextBillingCycle]],
		First[ToList[Lookup[dataPricingPackets, NumberOfObjects, 0]]]
	};

	(*make our team updates if needed*)
	objectTeamUpdates=Association[
		Object -> financingTeam,
		(*take care of the current bill if needed*)
		Which[
			newBillsQ, Replace[CurrentBills] -> Map[{Link[Lookup[#,Object]],Link[Download[Lookup[#,Site],Object]]}&,newBillPackets],
			(*if just closing, i.e. a team going inactive, set to Null*)
			(* NOTE: right now, there is no spec for supporting stopping billing at only _some_ of the sites for a team, this might change in the future *)
			closingBillQ, Replace[CurrentBills] ->{},
			True, Nothing
		],
		Replace[BillingHistory] -> updatedBillingHistory,
		(*if we're starting a new bill*)
		If[newBillsQ,
			(* this is OK to be  *)
			NextBillingCycle -> FirstCase[Lookup[newBillPackets, DateStarted],_?DateObjectQ] + 1 Month,
			Nothing
		],
		Append[ConstellationUsageLog] -> updatedConstellationUsageLog
	];

	(*assemble all of our packets*)
	allUpdatePackets=Cases[
		Flatten[{newBillPackets, currentBillsUpdatePackets, objectTeamUpdates, pricingUpdatePackets}],
		PacketP[]
	];

	(* check if the upload is valid *)
	validUpload = ValidUploadQ[allUpdatePackets];

	(* flatten all the message lists into one *)
	flatMessagesThrown=ToString/@Flatten@{messagesThrown,If[validUpload, Nothing, "Upload is not valid"]};

	(*create asana task if we either got messages or closed a bill*)
	Switch[{notifyQ, newBillsQ, flatMessagesThrown},
		{True, True, _},
		billingAsanaTask[financingTeam, Status -> Success, Message -> flatMessagesThrown],
		{True, False, Except[{}|""]},
		billingAsanaTask[financingTeam, Status -> Failure, Message -> flatMessagesThrown]
	];

	(* We want to notify Andrew when an AlaCarte customer hits a bill of > $10k such that he can 
	kindly suggest they switch to a subscription plan. *)
	If[!MatchQ[currentBillPackets,{}|{Null}],
		totalCharges=With[{relevantPackets=Cases[pricingUpdatePackets,_?(KeyExistsQ[#,TotalCharge]&)]},
			Map[
				Function[{packet},
					If[MatchQ[packet,PacketP[]],
						Lookup[Cases[pricingUpdatePackets,_?(KeyExistsQ[#,TotalCharge]&)],TotalCharge,Null],
						0USD
					]
				],
				relevantPackets
			]/.{}->ConstantArray[Null, Length[currentBillPackets]]
		];
		MapThread[notifyLargeUsage[notifyQ,#1,teamPacket,#2,#3]&,{priceSchemePackets,currentBillPackets,totalCharges}];
	];

	(*upload the updates if necessary*)
	newBill=If[uploadQ,
		Upload[allUpdatePackets],
		(*otherwise return everything*)
		allUpdatePackets
	];

	(* clean up notebook file and the directory *)
	Quiet[DeleteDirectory[FileNameJoin[{$TemporaryDirectory, ObjectToFilePath[financingTeam]}], DeleteContents->True]];

	(* Note - we are no longer changing the notebook for the Bill and BillSummaryNotebook here. That is done at the time of the initial Upload calls/packet creation now *)
	If[Or[debugQ,TrueQ[ECL`$ManifoldRunTime]], Print["Finished post-processing in "];Print[AbsoluteTime[] - postProcessingStart]];
	(* return new bill if we have created one *)
	newBill
];
(* ::Subsection::Closed:: *)
(*updateCurrentBillDiscounts*)
(* helper to update existing Object[Bill] to make sure they are in sync with the # of threads the team has *)

Authors[updateCurrentBillDiscounts]={"dima", "steven"};

DefineOptions[updateCurrentBillDiscounts,
	Options:>{UploadOption}
];

updateCurrentBillDiscounts[financingTeam:ObjectP[Object[Team,Financing]],ops:OptionsPattern[updateCurrentBillDiscounts]]:=Module[
	{teamPacket,currentBillsPackets,pricingSchemePackets,billingCycleEnd,bills,billUpdatePackets,safeOps,upload,cleanPackets},

	(* if the pricing scheme has entries in the NumberOfThreadsLog, update Object[Bill] to have proper discounts *)
	{teamPacket,currentBillsPackets,pricingSchemePackets}=Download[financingTeam,{
		Packet[NextBillingCycle,CurrentPriceSchemes,CurrentBills],
		Packet[CurrentBills[[All,1]][{NumberOfThreads,IncludedPriorityProtocols,IncludedInstrumentHours,IncludedCleanings,IncludedStockingFees,IncludedWasteDisposalFees,IncludedStorage,IncludedShipmentFees,DateStarted}]],
		Packet[CurrentPriceSchemes[[All,1]][{NumberOfThreads,NumberOfThreadsLog,IncludedPriorityProtocols,IncludedInstrumentHours,IncludedCleanings,IncludedStockingFees,IncludedWasteDisposalFees,IncludedStorage,IncludedShipmentFees,Site}]]
	}];

	safeOps=SafeOptions[updateCurrentBillDiscounts,ToList@ops];
	upload=Lookup[safeOps,Upload];

	(* pull the bill end cycle *)
	billingCycleEnd=Lookup[teamPacket,NextBillingCycle];

	(* check that we have the info to go forward - when we need to close the bill and billing information *)
	If[Or[
		NullQ[billingCycleEnd],
		!MemberQ[Flatten@Lookup[teamPacket,CurrentPriceSchemes,{}],LinkP[Model[Pricing]]]
	],
		Message[SyncBilling::NotConfiguredTeam];Return[$Failed]
	];

	(* if we don't have Object[Bill] (s) created, we exit now *)
	If[MatchQ[Lookup[teamPacket,CurrentBills],{} | {Null}],Return[Null,Module]];

	(* get the current bills *)
	bills=Download[Lookup[teamPacket,CurrentBills][[All,1]],Object];

	billUpdatePackets=MapThread[
		Function[{bill,billPacket,priceSchemePacket},
			Module[{
				billDuration,relevantLogEntries,billStartTime,relevantLogEntriesPositions,threadPairs,currentNumberOfThreads,
				observedThreadsAmount,newDiscountsNumber,newDiscountsNonNumber,currentNumberOfThreadsLog
			},

				currentNumberOfThreadsLog=Lookup[priceSchemePacket,NumberOfThreadsLog];
				currentNumberOfThreads=Lookup[priceSchemePacket,NumberOfThreads];

				(* if there is nothing in the log return early *)
				If[Length[currentNumberOfThreadsLog]<2,Return[Null,Module]];

				(* bill start time *)
				billStartTime=Lookup[billPacket,DateStarted];

				(* find an expected duration of the bill *)
				billDuration=AbsoluteTime[billingCycleEnd] - AbsoluteTime[billStartTime];

				(* get positions of all relevant entries for this billing period *)
				relevantLogEntriesPositions=Flatten@Position[currentNumberOfThreadsLog,_?((#[[1]]<billingCycleEnd) && #[[1]]>billStartTime&),{1},Heads->False];

				(* return early if there are no relevant changes to the # of threads*)
				If[Length[relevantLogEntriesPositions]==0,Return[Nothing,Module]];

				(* check that we have had a change in the # of threads inside this bill *)
				relevantLogEntries=currentNumberOfThreadsLog[[Prepend[relevantLogEntriesPositions,Min[relevantLogEntriesPositions] - 1]]];

				(* return early if there are no relevant changes to the # of threads*)
				If[Length[relevantLogEntries]==1,Return[Nothing,Module]];

				(* get  *)
				threadPairs=Module[{partitioned},
					(* split in pairs after adding the last entry to the list *)
					partitioned=Partition[Append[relevantLogEntries,{billingCycleEnd,relevantLogEntries[[-1,2]]}],2,1];

					(* For each pair, calculate the duration by subtracting the end date from the start date for each period *)
					(* we need to make sure to replace the date in the first entry with the time fo the bill start *)
					{
						#[[1,2]],(* # of threads *)
						AbsoluteTime[#[[2,1]]] - AbsoluteTime@If[#[[1,1]]<billStartTime,billStartTime,#[[2,1]]] (* duration *)
					}&/@partitioned
				];

				(* calculate the "observed" threads the team had - total of the number of threads * duration *)
				(* if the team had 3 threads for half of the period and 5 for the other half the result will be 4 *)
				observedThreadsAmount=N@Total[Map[#[[1]] * #[[2]] / billDuration&,threadPairs]];

				(* generate rules to update the discounts in the Object[Bill] *)
				(*also be sure to default Null to a number in this case or upload will be unhappy*)
				newDiscountsNonNumber=Association@MapThread[
					#1->(Lookup[priceSchemePacket,#1]/.Null->#2) / currentNumberOfThreads * observedThreadsAmount&,
					{
						{IncludedInstrumentHours,IncludedStockingFees,IncludedWasteDisposalFees,IncludedStorage,IncludedShipmentFees},
						{0 Hour,0 USD,0 USD,0 Centimeter^3,0 USD}
					}
				];

				(*integers need to stay integers*)
				newDiscountsNumber=Association@Map[
					#->Round[(Lookup[priceSchemePacket,#]/.Null->0) / currentNumberOfThreads * observedThreadsAmount,1]&,
					{IncludedPriorityProtocols,IncludedCleanings}
				];

				(* return new discounts to the relevant fields *)
				Join[<|Object->bill|>,newDiscountsNonNumber,newDiscountsNumber]
			]
		],
		{bills,currentBillsPackets,pricingSchemePackets}
	];

	(* clean up packets *)
	cleanPackets=Cases[billUpdatePackets,PacketP[]];

	(* return the packets or do the Upload *)
	If[TrueQ[upload],
		Upload@cleanPackets,
		cleanPackets
	]
];

(* ::Subsection::Closed:: *)
(*notifyLargeUsage*)

notifyLargeUsage[notifyQ:(True|False),priceSchemePacket:PacketP[Model[Pricing]],teamPacket:PacketP[Object[Team,Financing]],billPacket:(ObjectP[Object[Bill]]|Null),totalCharge:GreaterP[0USD]]:=With[
	{financingTeam=Lookup[teamPacket,Object]},
	If[
		And[
			notifyQ,
			MatchQ[Lookup[priceSchemePacket,PlanType],AlaCarte],
			Or[
				(* If there is no current bill but the charge is >$10k *)
				And[
					!MatchQ[billPacket,PacketP[]],
					(totalCharge>12500 USD)
				],
				(* Or if there is a current bill but they just now crossed the $10k threshold *)
				And[
					MatchQ[billPacket,PacketP[]],
					(Lookup[billPacket,TotalCharge]<=12500 USD),
					(totalCharge>12500 USD)
				]
			],
			ProductionQ[]
		],
		(
			Echo["Notifying about large AlaCarte bill for "<>ToString[financingTeam,InputForm]];
			ECL`CreateAsanaTask[
				Association[
					Name->"Large AlaCarte bill created for team: "<>ToString[Download[financingTeam,Object],InputForm]<>" ("<>ToString[Lookup[teamPacket,Name],InputForm]<>")",
					Completed->False,
					Notes->ToString[Download[financingTeam,Object],InputForm]<>" ("<>ToString[Lookup[teamPacket,Name],InputForm]<>")"<>"'s latest bill is over $12,500"<>" ($"<>ToString[Unitless[totalCharge]]<>"). They are on an AlaCarte plan type. Perhaps they should subscribe.",
					Assignee->Object[User,Emerald,Developer,"Andrew.Heywood"],
					Followers->{Object[User,Emerald,Developer,"Andrew.Heywood"]},
					Projects->{"Billing & Invoicing"}
				]
			]
		)
	]];

(* ::Subsection::Closed:: *)
(*generateBillUpdates*)
(* helper that works on a singular Site/Bill to generate appropriate update packets *)
generateBillUpdates[currentBillPacket:(PacketP[Object[Bill]]|Null),
	notebook:ObjectP[Object[LaboratoryNotebook]],
	protocolPricingPackets_List,
	instrumentPricingPackets_List,
	operatorPricingPackets_List,
	wastePricingPackets_List,
	materialsPricingPackets_List,
	stockingPricingPackets_List,
	cleaningPricingPackets_List,
	transactionsPricingPackets_List,
	storagePricingPackets_List,
	dataPricingPackets_List
]:=Module[{
	noCurrentBillQ,currentBillSite,
	composedProtocolValues,protocolsRun,composedInstrumentValues,composedOperatorValues,composedOperatorValuesNotebook,
	composedCleaningValues,composedStockingValues,composedWasteValues,composedStorageValues,composedMaterialValues,
	composedShippingValues,composedConstellationUsage,composedConstellationDiscount,composedConstellationStorage,
	composedConstellationObjects,composedCertificationCharges,pairedValuePriceIndex,chargesFromPackets,
	composedOtherCharges,notebookPackets,composedSubtotals,totalCleaningCharge,totalInstrumentCharge,
	totalMaterialsCharge,totalOperatorCharge,totalProtocolCharge,totalShippingCharge,totalStockingCharge,
	totalStorageCharge,totalWasteCharge,totalCharge,pricingUpdatePacket,allBillUpdatePackets,rawConstellationStorage
},

	(* ------------------------- *)
	(* -- FORMAT AND DISCOUNT -- *)
	(* ------------------------- *)

	(* if there is no current bill packet, we can skip all of this and just return Nulls *)

	(* make a boolean to check if we do have the current bills packet(s) *)
	noCurrentBillQ=MatchQ[currentBillPacket,Null];
	currentBillSite=If[noCurrentBillQ,Null,Download[Lookup[currentBillPacket,Site],Object]];

	(* -- Experiment Charge -- *)
	composedProtocolValues=If[noCurrentBillQ || MatchQ[protocolPricingPackets,{}],
		Null,
		Module[
			{
				formattedProtocolPricingPackets,formattedPriorityProtocolPricingPackets,formattedNormalProtocolPricingPackets,
				sortedProtocolPricingPackets,discountedPriorityProtocolPricingPackets,
				includedPriorityProtocols,pricePerExperiment,pricePerPriorityExperiment
			},

			(* convert the helper output into the correct fields for upload *)
			formattedProtocolPricingPackets=Lookup[protocolPricingPackets,{Source,DateCompleted,Author,Priority,Price}]/.{"Priority"->True,"Regular"->False};

			(* determine their protocol allowance anc price *)
			{includedPriorityProtocols,pricePerExperiment,pricePerPriorityExperiment}=Lookup[
				currentBillPacket,
				{IncludedPriorityProtocols,PricePerExperiment,PricePerPriorityExperiment}
			];

			(* separate the priority and non priority protocols *)
			formattedPriorityProtocolPricingPackets=Cases[formattedProtocolPricingPackets,{_,_,_,True,_}];
			formattedNormalProtocolPricingPackets=Cases[formattedProtocolPricingPackets,{_,_,_,False | Null,_}];

			(* order protocols by price, discount the most expensive ones *)
			sortedProtocolPricingPackets=Reverse[SortBy[formattedPriorityProtocolPricingPackets,Last]];

			(* discount the protocols by adjusting the cost for the discounted protocols *)
			discountedPriorityProtocolPricingPackets=MapIndexed[
				If[MatchQ[First[#2],LessEqualP[includedPriorityProtocols]] && pricePerPriorityExperiment>0 USD,
					(* only charge the normal fee - do it by multiplication in case this was refunded *)
					Append[#1,Last[#1] * pricePerExperiment / pricePerPriorityExperiment],
					(* charge whatever was charged; or if pricePerPriorityExperiment is 0, this should return to 0 USD *)
					Append[#1,Last[#1]]
				]&,
				sortedProtocolPricingPackets
			];

			(* recombine the priority and non priority packets, sort by date *)
			SortBy[
				Join[
					discountedPriorityProtocolPricingPackets,
					Map[Append[#,Last[#]]&,formattedNormalProtocolPricingPackets]
				],
				#[[2]]&
			]
		]
	];
	protocolsRun=Length[composedProtocolValues];


	(* -- Instrument Charge -- *)
	composedInstrumentValues=If[noCurrentBillQ || MatchQ[instrumentPricingPackets,{}],
		Null,
		Module[
			{
				formattedInstrumentPricingPackets,sortedInstrumentPricingPackets,cumulativeInstrumentTimes,
				includedInstrumentTime,discountedPackets,notDiscountedPackets,possiblyChargedTime,updatedDiscountedPackets,
				updatedNonDiscountedPackets,sortedData,groupedData
			},

			(* look up the fields from the helper function association *)
			formattedInstrumentPricingPackets=Lookup[
				instrumentPricingPackets,
				{DateCompleted,Source,Instrument,PricingTier,Time,Price},
				Nothing
			];

			(* sort the instruments by tier *)
			sortedInstrumentPricingPackets=ReverseSortBy[formattedInstrumentPricingPackets,#[[4]]&];

			(* get the total amount of time spend for each *)
			cumulativeInstrumentTimes=FoldList[Plus,sortedInstrumentPricingPackets[[All,5]]];

			(* lookup the included hours *)
			includedInstrumentTime=Lookup[currentBillPacket,IncludedInstrumentHours];

			(* use the included instrument time to zero out all of the included hours *)
			discountedPackets=PickList[sortedInstrumentPricingPackets,cumulativeInstrumentTimes,LessP[includedInstrumentTime]];
			notDiscountedPackets=PickList[sortedInstrumentPricingPackets,cumulativeInstrumentTimes,GreaterEqualP[includedInstrumentTime]];

			(* find the cumulative time for the first charged packet, subtract the free time *)
			possiblyChargedTime=((FirstCase[cumulativeInstrumentTimes,GreaterEqualP[includedInstrumentTime]]/.{}->0 Minute) - includedInstrumentTime);

			(* update the discounted packets by zeroing them and recording the discounted time *)
			updatedDiscountedPackets=If[MatchQ[discountedPackets,{}],
				{},
				Map[Join[#,{Last[#],0 * USD}]&,Most/@discountedPackets]
			];

			(* the first element of the nonDiscounted might be discounted *)
			updatedNonDiscountedPackets=If[!MatchQ[notDiscountedPackets,{}],
				(* we want to charge the fraction of the time that was not free = chargedTime/actual time *)
				Prepend[
					Map[Join[#[[1;;5]],{0 Hour,#[[6]]}]&,Rest[notDiscountedPackets]],
					Join[
						Most[First[notDiscountedPackets]],
						{
							Round[Abs[(notDiscountedPackets[[1,5]] - possiblyChargedTime)],1 Minute],
							Round[Last[First[notDiscountedPackets]] * (possiblyChargedTime / notDiscountedPackets[[1,5]]),0.01 USD]
						}
					]
				],
				{}
			];

			(* sort by date to finish it off *)
			sortedData=SortBy[Join[updatedDiscountedPackets,updatedNonDiscountedPackets],First];

			(* group by protocol and instrument *)
			groupedData=GatherBy[sortedData,#[[2;;3]]&];

			(* collapse all protocols:instrument into one line so that only one line per protocol shows up - price per operator is the same *)
			Map[Flatten[{#[[1,1;;4]],Table[Total[#[[;;,n]]],{n,5,7}]}]&,groupedData]
		]
	];


	(* -- Operator Charge -- *)
	composedOperatorValues=If[noCurrentBillQ || MatchQ[operatorPricingPackets,{}],
		(* update Object, what do I do with the data migration? *)
		Null,
		Module[
			{
				formattedOperatorPricingPackets,sortedOperatorPricingPackets,
				updatedNonDiscountedPackets,sortedResults,groupedResults
			},

			(* look up the fields from the helper function association *)
			formattedOperatorPricingPackets=Lookup[
				operatorPricingPackets,
				{DateCompleted,Source,ModelName,Time,Price,PricePerHour},
				Nothing
			];

			(* sort the Operators by tier *)
			sortedOperatorPricingPackets=Reverse[SortBy[formattedOperatorPricingPackets,Last]];

			(* the first element of the nonDiscounted might be discounted *)
			updatedNonDiscountedPackets=If[!MatchQ[sortedOperatorPricingPackets,{}],
				(* we want to charge the fraction of the time that was not free = chargedTime/actual time *)
				Map[Join[#[[1;;4]],{0.0 Hour,#[[5]]}]&,sortedOperatorPricingPackets],
				{}
			];

			(* sort by date to finish it off *)
			sortedResults=SortBy[updatedNonDiscountedPackets,First];

			(* group by protocol *)
			groupedResults=GatherBy[sortedResults,#[[2]]&];

			(* collapse all protocols into one line so that only one line per protocol shows up - price per operator is the same *)
			Map[Flatten[{#[[1,1;;3]],Table[Total[#[[;;,n]]],{n,4,6}]}]&,groupedResults]
		]
	];

	(* Drop QualificationLevel for the notebook *)
	composedOperatorValuesNotebook=If[NullQ[composedOperatorValues],Null,Drop[composedOperatorValues,None,{3}]];

	(* -- Cleaning Charge -- *)
	composedCleaningValues=If[noCurrentBillQ || MatchQ[cleaningPricingPackets,{}],
		Null,
		Module[
			{
				formattedPackets,sortedPackets,includedCleanings,discountedPackets
			},

			(* convert the helper output into the correct fields for upload *)
			formattedPackets=Lookup[cleaningPricingPackets,{Date,Container,Source,CleaningCategory,Price}];

			(* lookup included Cleanings *)
			includedCleanings=Lookup[currentBillPacket,IncludedCleanings];

			(* order cleanings by price, discount the most expensive ones *)
			sortedPackets=Reverse[SortBy[formattedPackets,Last]];

			(* discount the protocols by setting the cost to 0 for the discounted protocols *)
			discountedPackets=MapIndexed[
				If[MatchQ[First[#2],LessEqualP[includedCleanings]],
					(* its free *)
					Append[#1,0 USD],
					(* charge whatever was charged *)
					Append[#1,Last[#1]]
				]&,
				sortedPackets
			];

			(* sort by date *)
			SortBy[discountedPackets,First]
		]
	];


	(* -- Stocking Charge -- *)
	composedStockingValues=If[noCurrentBillQ || MatchQ[stockingPricingPackets,{}],
		Null,
		Module[
			{
				formattedPackets,discountedPackets,notDiscountedPackets,cumulativeCost,
				updatedDiscountedPackets,possiblyChargedFee,updatedNonDiscountedPackets,includedStockingFees
			},

			(* convert the helper output into the correct fields for upload *)
			formattedPackets=Lookup[stockingPricingPackets,{Material,Volume,Source,StorageCondition,Price}];

			(* lookup included Stocking *)
			includedStockingFees=Lookup[currentBillPacket,IncludedStockingFees];

			(* get the cumulative costs *)
			cumulativeCost=FoldList[Plus,formattedPackets[[All,5]]];

			(* determine which ones need discounting *)
			(* use the included Operator time to zero out all of the included hours *)
			discountedPackets=PickList[formattedPackets,cumulativeCost,LessP[includedStockingFees]];
			notDiscountedPackets=PickList[formattedPackets,cumulativeCost,GreaterEqualP[includedStockingFees]];

			(* find the cumulative fee for the first charged packet, subtract the free amount *)
			possiblyChargedFee=((FirstCase[cumulativeCost,GreaterEqualP[includedStockingFees]]/.{}->0) - includedStockingFees);

			(* update the discounted packets by zeroing them *)
			updatedDiscountedPackets=If[MatchQ[discountedPackets,{}],
				{},
				Map[Join[#,{Last[#],0 * USD}]&,discountedPackets]
			];

			(* the first element of the nonDiscounted might be discounted *)
			updatedNonDiscountedPackets=If[MatchQ[notDiscountedPackets,Except[{}]],
				(* we want to charge the difference for that particular case *)
				Prepend[
					Map[Join[#,{0 * USD,#[[5]]}]&,notDiscountedPackets],
					Join[First[notDiscountedPackets],{Round[notDiscountedPackets[[1,5]] - possiblyChargedFee,0.01 * USD],possiblyChargedFee}]
				],
				notDiscountedPackets
			];

			(* sort by source to finish it off *)
			SortBy[Join[updatedDiscountedPackets,updatedNonDiscountedPackets],#[[3]]&]
		]
	];


	(* -- Waste Charge -- *)
	composedWasteValues=If[noCurrentBillQ || MatchQ[wastePricingPackets,{}],
		Null,
		Module[
			{
				formattedPackets,discountedPackets,notDiscountedPackets,cumulativeCost,
				updatedDiscountedPackets,possiblyChargedFee,updatedNonDiscountedPackets,includedWasteFees
			},

			(* convert the helper output into the correct fields for upload *)
			formattedPackets=Lookup[wastePricingPackets,{Date,Source,WasteType,Price}];

			(* lookup included Waste *)
			includedWasteFees=Lookup[currentBillPacket,IncludedWasteDisposalFees];

			(* get the cumulative costs *)
			cumulativeCost=FoldList[Plus,formattedPackets[[All,4]]];

			(* determine which ones need discounting *)
			(* use the included Operator time to zero out all of the included hours *)
			discountedPackets=PickList[formattedPackets,cumulativeCost,LessP[includedWasteFees]];
			notDiscountedPackets=PickList[formattedPackets,cumulativeCost,GreaterEqualP[includedWasteFees]];

			(* find the cumulative fee for the first charged packet, subtract the free amount *)
			possiblyChargedFee=((FirstCase[cumulativeCost,GreaterEqualP[includedWasteFees]]/.{}->0) - includedWasteFees);

			(* update the discounted packets by zeroing them *)
			updatedDiscountedPackets=If[MatchQ[discountedPackets,{}],
				{},
				Map[Append[#,0 * USD]&,discountedPackets]
			];

			(* the first element of the nonDiscounted might be discounted *)
			updatedNonDiscountedPackets=If[MatchQ[notDiscountedPackets,Except[{}]],
				(* we want to charge the difference for that particular case *)
				Prepend[
					Map[Append[#,Last[#]]&,notDiscountedPackets],
					Append[First[notDiscountedPackets],possiblyChargedFee]
				],
				notDiscountedPackets
			];

			(* sort by date to finish it off *)
			SortBy[Join[updatedDiscountedPackets,updatedNonDiscountedPackets],First]
		]
	];


	(* -- Storage Charge -- *)
	composedStorageValues=If[noCurrentBillQ || MatchQ[storagePricingPackets,{}],
		Null,
		Module[
			{
				realStoragePricingPackets,formattedPackets,discountedPackets,notDiscountedPackets,cumulativeVolume,possiblyChargedVolume,
				updatedDiscountedPackets,updatedNonDiscountedPackets,includedStorage,sortedPackets
			},

			(* This is a safeguard that we should not ever trigger, but in a name of defensive programming we will make sure that we have some volume for the items *)
			realStoragePricingPackets=DeleteCases[storagePricingPackets,KeyValuePattern[Volume->Quantity[0,"Centimeters"^3]]];

			(* convert the helper output into the correct fields for upload *)
			formattedPackets=Lookup[realStoragePricingPackets,{DateLastUsed,Object,Source,StorageCondition,Volume,Time,Price,PricingRate}];

			(* sort by the Pricing Rate so we apply discount to the most expensive storage first *)
			sortedPackets=ReverseSortBy[formattedPackets,PricingRate][[All,1;;7]];

			(* lookup included Storage *)
			includedStorage=Lookup[currentBillPacket,IncludedStorage];

			(* get the cumulative costs *)
			cumulativeVolume=FoldList[Plus,sortedPackets[[All,5]]];

			(* determine which ones need discounting *)
			(* use the included storage space to zero out all of the included volumes *)
			discountedPackets=PickList[sortedPackets,cumulativeVolume,LessP[includedStorage]];
			notDiscountedPackets=PickList[sortedPackets,cumulativeVolume,GreaterEqualP[includedStorage]];

			(* find the cumulative volume for the first charged packet, subtract the free amount *)
			possiblyChargedVolume=((FirstCase[cumulativeVolume,GreaterEqualP[includedStorage]]/.{}->0) - includedStorage);

			(* update the discounted packets by zeroing them *)
			updatedDiscountedPackets=If[MatchQ[discountedPackets,{}],
				{},
				Map[Join[#,{Last[#],0 * USD}]&,discountedPackets[[All,1;;7]]]
			];

			(* the first element of the nonDiscounted might be discounted *)
			updatedNonDiscountedPackets=If[MatchQ[notDiscountedPackets,Except[{}]],
				(* we want to charge the fraction of the time that was not free = chargedVolume/actual volume *)
				Prepend[
					Map[Join[#,{0 * USD,Last[#]}]&,Rest[notDiscountedPackets]],
					Join[
						First[notDiscountedPackets],
						{
							Round[Last[First[notDiscountedPackets]] * (1 - (possiblyChargedVolume / notDiscountedPackets[[1,5]])),0.01 USD],
							Round[Last[First[notDiscountedPackets]] * (possiblyChargedVolume / notDiscountedPackets[[1,5]]),0.01 USD]
						}
					]
				],
				notDiscountedPackets
			];

			(* sort by date to finish it off *)
			SortBy[Join[updatedDiscountedPackets,updatedNonDiscountedPackets],First]
		]
	];


	(* -- Materials Charge -- *)
	composedMaterialValues=If[noCurrentBillQ || MatchQ[materialsPricingPackets,{}],
		Null,
		Module[
			{
				formattedPackets,formattedPacketsPartOne,allAmounts,formattedPacketsPartTwo
			},

			(* convert the helper output into the correct fields for upload *)
			(*this is done a little weird because the Amount may need ot get a unit and put in the middle position*)
			formattedPacketsPartOne=Lookup[materialsPricingPackets,{DateCompleted,Material,Source,Notebook}];
			formattedPacketsPartTwo=Lookup[materialsPricingPackets,{PricePerUnit,Price}];
			allAmounts=Map[If[NumericQ[#],# * Unit,#] &,Lookup[materialsPricingPackets,Amount]];

			formattedPackets=MapThread[Join[#1,{#2},#3]&,{formattedPacketsPartOne,allAmounts,formattedPacketsPartTwo}];

			(* sort by date *)
			SortBy[formattedPackets,First]
		]
	];

	(* -- Shipping/Transactions Charge -- *)
	composedShippingValues=If[noCurrentBillQ || MatchQ[transactionsPricingPackets,{}],
		Null,
		Module[
			{
				formattedPackets,discountedPackets,notDiscountedPackets,cumulativeCost,
				updatedDiscountedPackets,updatedNonDiscountedPackets,includedShipmentFees,
				possiblyChargedFee
			},

			(* convert the helper output into the correct fields for upload *)
			formattedPackets=Lookup[transactionsPricingPackets,{DateCompleted,Source,Weight,Price,Tax}];

			(* lookup included Waste *)
			includedShipmentFees=Lookup[currentBillPacket,IncludedShipmentFees];

			(* get the cumulative costs *)
			cumulativeCost=FoldList[Plus,Total/@formattedPackets[[All,4;;5]]];

			(* determine which ones are overweight and are not eligible for discounting *)
			discountedPackets=PickList[formattedPackets,cumulativeCost,LessP[includedShipmentFees]];
			notDiscountedPackets=PickList[formattedPackets,cumulativeCost,GreaterEqualP[includedShipmentFees]];

			(* find the cumulative fee for the first charged packet, subtract the free amount *)
			possiblyChargedFee=((FirstCase[cumulativeCost,GreaterEqualP[includedShipmentFees]]/.{}->0) - includedShipmentFees);

			(* update the discounted packets by zeroing them *)
			updatedDiscountedPackets=If[MatchQ[discountedPackets,{}],
				{},
				Map[Join[#,{Total[#[[4;;5]]],0 * USD}]&,discountedPackets]
			];

			(* the first element of the nonDiscounted might be discounted *)
			updatedNonDiscountedPackets=If[MatchQ[notDiscountedPackets,Except[{}]],
				(* we want to charge the difference for that particular case *)
				Prepend[
					Map[Join[#,{0 * USD,Total[#[[4;;5]]]}]&,notDiscountedPackets],
					Join[First[notDiscountedPackets],{Round[Total[notDiscountedPackets[[1,4;;5]]] - possiblyChargedFee,0.01 * USD],possiblyChargedFee}]
				],
				notDiscountedPackets
			];

			(* sort by date to finish it off *)
			SortBy[Join[updatedDiscountedPackets,updatedNonDiscountedPackets],First]
		]
	];

	(* -- Data Charge -- *)

	(*this was originally outside the module and I didnt move the variables inside but its fine*)
	If[noCurrentBillQ,

		(* jut return the safe values - these will get reset in the next sync billing run *)
		{
			composedConstellationUsage,
			composedConstellationDiscount,
			composedConstellationStorage,
			composedConstellationObjects
		}={
			Quantity[0,"Gigabytes"],
			Quantity[0,"Gigabytes"],
			0 USD,
			0
		},

		(*its not a new bill so we need to actually get the constellation info*)
		Module[{includedConstellationObjects,constellationPricingRate,constellationDiscount},
			(* get the constellation charge and number of objects from PriceData *)
			rawConstellationStorage=First[Lookup[dataPricingPackets,Total,{0 USD}]];
			composedConstellationObjects=First[Lookup[dataPricingPackets,NumberOfObjects,{0}]];

			(* do the data discounting using the ConstellationPrice and IncludedConstellationStorage, which is in number of objects (not TB) *)
			{includedConstellationObjects,constellationPricingRate}=Lookup[currentBillPacket,{IncludedConstellationStorage,ConstellationPrice}];
			constellationDiscount=(includedConstellationObjects/.Null->0 Unit) * constellationPricingRate;
			composedConstellationStorage=(rawConstellationStorage - constellationDiscount)/.(LessP[0 USD]->0 USD);

			(* format number of objects into TB or GB *)
			composedConstellationUsage=With[{storage=Quantity[(First@ToList@composedConstellationObjects) * 0.05 / (10^6),"Terabytes"]},
				If[
					storage>=Quantity[1.,"Terabytes"],
					Round[UnitConvert[storage,"Terabytes"],Quantity[0.01,"Terabytes"]],
					Round[UnitConvert[storage,"Gigabytes"],Quantity[0.01,"Gigabytes"]]
				]
			];

			(*format the discounted number of objects into TB or GB*)
			composedConstellationDiscount=With[{constDiscount=Quantity[Unitless[(includedConstellationObjects/.Null->0)] * 0.05 / (10^6),"Terabytes"]},
				If[
					constDiscount>=Quantity[1.,"Terabytes"],
					Round[UnitConvert[constDiscount,"Terabytes"],Quantity[0.01,"Terabytes"]],
					Round[UnitConvert[constDiscount,"Gigabytes"],Quantity[0.01,"Gigabytes"]]
				]
			]
		]
	];


	(* -- Certification Charge -- *)
	composedCertificationCharges=If[noCurrentBillQ,
		If[MatchQ[Lookup[currentBillPacket,CertificationCharges],Except[({} | Null | $Failed)]],
			Lookup[currentBillPacket,CertificationCharges][[All,4]],
			0 USD
		],
		0 USD
	];

	(* pair the packets with the index holding the price *)
	pairedValuePriceIndex={
		{composedMaterialValues,7},
		{composedProtocolValues,6},
		{composedOperatorValues,6},
		{composedInstrumentValues,7},
		{composedCleaningValues,6},
		{composedStockingValues,6},
		{composedWasteValues,5},
		{composedStorageValues,9},
		{composedShippingValues,7}
	};

	(* extract the prices from values that have price *)
	chargesFromPackets=MapThread[
		If[MatchQ[#1,{} | Null],
			0 USD,
			#1[[All,#2]]
		]&,
		Transpose[pairedValuePriceIndex]
	];

	(* note: protocolsRun is now an association *)
	(* other prices that we can only figure out if there is a bill *)
	composedOtherCharges=If[!noCurrentBillQ,
		{
			If[protocolsRun>=1,Lookup[currentBillPacket,LabAccessFee],0 * USD],
			Lookup[currentBillPacket,CommandCenterPrice] * Lookup[currentBillPacket,NumberOfAdditionalUsers]
		}
	];

	(* ----------------------------- *)
	(* -- PREPARE NOTEBOOK OUTPUT -- *)
	(* ----------------------------- *)
	notebookPackets=Module[
		{
			(* the total* variables are in a more global Module since we reuse them later on *)
			planSummaryTable,reformattedBillingInformation,labAccessFee,recurringData,recurringLabels,
			recurringSortOrder,recurringTable,utilizationData,utilizationLabels,utilizationSortOrder,
			safeComposedOperatorValues,safeComposedInstrumentValues,safeComposedProtocolValues,safeComposedCleaningValues,
			safeComposedStockingValues,safeComposedWasteValues,safeComposedMaterialValues,safeComposedShippingValues,
			safeComposedStorageValues,totalMaterialsPrice,totalMaterialsDiscount,totalProtocolPrice,totalProtocolDiscount,
			priorityProtocols,priorityProtocolsDiscounted,priorityProtocolsCharged,totalOperatorTime,discountedOperatorTime,
			totalInstrumentTime,discountedInstrumentTime,totalCleaningPrice,totalCleaningDiscount,totalStockingDiscount,
			totalStockingPrice,totalWastePrice,totalWasteDiscount,totalStoragePrice,totalStorageDiscount,
			totalShippingPrice,totalShippingDiscount,instrumentTiersSubtotals,certificationCharges,privateTutoringFee,
			formattedExtraUsers,formattedDiscountTuples,formattedDiscountTags,discountCharges,discountTags,
			utilizationTable,protocolSpecificBilling,nonProtocolCharges,billingInformation,notebookContents,
			outputFileName,billingNotebookPacket,updateBillWithNotebookPacket
		},
		If[noCurrentBillQ,
			{},
			(* make Nulls into {} for this section *)
			{
				safeComposedOperatorValues,safeComposedInstrumentValues,
				safeComposedProtocolValues,safeComposedCleaningValues,
				safeComposedStockingValues,safeComposedWasteValues,
				safeComposedStorageValues,safeComposedMaterialValues,
				safeComposedShippingValues
			}=Replace[
				{
					composedOperatorValuesNotebook,composedInstrumentValues,
					composedProtocolValues,composedCleaningValues,
					composedStockingValues,composedWasteValues,
					composedStorageValues,composedMaterialValues,
					composedShippingValues
				},
				{Null->{}},
				1
			];

			(* -- Format the values for the user -- *)
			(* Plan Summary *)

			planSummaryTable={
				PlotTable[
					Transpose[{
						Prepend[
							Lookup[currentBillPacket,{PlanType,CommitmentLength,NumberOfThreads,NumberOfBaselineUsers}],
							DateString[DateObject[Lookup[currentBillPacket,DateStarted],"Day"]]
						]
					}],
					TableHeadings->{{"Billing Start Date","Plan Type","Commitment Length","Number Of Threads","Number Of Baseline Users"},None},
					Title->"Plan Overview",
					UnitForm->False
				],
				"Output"
			};

			(*Materials*)
			{totalMaterialsPrice,totalMaterialsDiscount,totalMaterialsCharge}={
				Total[safeComposedMaterialValues[[All,-1]]],
				0 * USD,
				Total[safeComposedMaterialValues[[All,-1]]]
			};

			(* Protocol *)
			{totalProtocolPrice,totalProtocolDiscount,totalProtocolCharge}=If[MatchQ[safeComposedProtocolValues,{}],{0 * USD,0 * USD,0 * USD},
				{
					Total[safeComposedProtocolValues[[All,-2]]],
					(Total[safeComposedProtocolValues[[All,-2]]] - Total[safeComposedProtocolValues[[All,-1]]]),
					Total[safeComposedProtocolValues[[All,-1]]]
				}];

			{priorityProtocols,priorityProtocolsDiscounted,priorityProtocolsCharged}=If[MatchQ[safeComposedProtocolValues,{}],{0,0,0 * USD},Module[
				{totalPriorityProtocols,includedPriorityProtocols,discountedProtocols,chargedProtocols},

				totalPriorityProtocols=Total[safeComposedProtocolValues[[All,4]]/.{True->1,False->0}];
				includedPriorityProtocols=Lookup[currentBillPacket,IncludedPriorityProtocols];

				discountedProtocols=If[
					includedPriorityProtocols>=totalPriorityProtocols,
					totalPriorityProtocols,
					includedPriorityProtocols
				];

				chargedProtocols=If[
					includedPriorityProtocols>=totalPriorityProtocols,
					0,
					(totalPriorityProtocols - includedPriorityProtocols)
				];

				{totalPriorityProtocols,discountedProtocols,chargedProtocols}
			]];

			(* operator *)
			{totalOperatorTime,discountedOperatorTime,totalOperatorCharge}=
				If[MatchQ[safeComposedOperatorValues,{}],{0 * Hour,0 * Hour,0 * USD},{
					Total[safeComposedOperatorValues[[All,-3]]],
					Total[safeComposedOperatorValues[[All,-2]]],
					Total[safeComposedOperatorValues[[All,-1]]]
				}];

			(*instrument*)
			{totalInstrumentTime,discountedInstrumentTime,totalInstrumentCharge}=If[
				MatchQ[safeComposedInstrumentValues,{}],
				{0 * Hour,0 * Hour,0 * USD},
				{
					Total[safeComposedInstrumentValues[[All,-3]]],
					Total[safeComposedInstrumentValues[[All,-2]]],
					Total[safeComposedInstrumentValues[[All,-1]]]
				}];

			(* cleanup *)
			{totalCleaningPrice,totalCleaningDiscount,totalCleaningCharge}=If[
				MatchQ[safeComposedCleaningValues,{}],
				{0 * USD,0 * USD,0 * USD},
				{
					Total[safeComposedCleaningValues[[All,-2]]],
					(Total[safeComposedCleaningValues[[All,-2]]] - Total[safeComposedCleaningValues[[All,-1]]]),
					Total[safeComposedCleaningValues[[All,-1]]]
				}];

			(* stocking *)
			{totalStockingPrice,totalStockingDiscount,totalStockingCharge}=If[
				MatchQ[safeComposedStockingValues,{}],
				{0 * USD,0 * USD,0 * USD},
				{
					Total[safeComposedStockingValues[[All,-3]]],
					Total[safeComposedStockingValues[[All,-2]]],
					Total[safeComposedStockingValues[[All,-1]]]
				}];

			(*Waste*)
			{totalWastePrice,totalWasteDiscount,totalWasteCharge}=If[
				MatchQ[safeComposedWasteValues,{}],
				{0 * USD,0 * USD,0 * USD},
				{
					Total[safeComposedWasteValues[[All,-2]]],
					(Total[safeComposedWasteValues[[All,-2]]] - Total[safeComposedWasteValues[[All,-1]]]),
					Total[safeComposedWasteValues[[All,-1]]]
				}];

			(*Storage*)
			{totalStoragePrice,totalStorageDiscount,totalStorageCharge}=If[
				MatchQ[safeComposedStorageValues,{}],
				{0 * USD,0 * USD,0 * USD},
				{
					Total[safeComposedStorageValues[[All,-3]]],
					Total[safeComposedStorageValues[[All,-2]]],
					Total[safeComposedStorageValues[[All,-1]]]
				}];

			(*Shipping*)
			{totalShippingPrice,totalShippingDiscount,totalShippingCharge}=If[
				MatchQ[safeComposedShippingValues,{}],
				{0 * USD,0 * USD,0 * USD},
				{
					Total[Total/@safeComposedShippingValues[[All,-3;;-4]]],
					Total[safeComposedShippingValues[[All,-2]]],
					Total[safeComposedShippingValues[[All,-1]]]
				}];

			(* make subtotals for each instrument tier separately *)
			instrumentTiersSubtotals=Module[{groupedData},
				groupedData=GatherBy[SortBy[safeComposedInstrumentValues,(#[[4]]&)],(#[[4]]&)];
				{"Subtotal","","",#[[1,4]],"","",Total[#[[All,7]]]}&/@groupedData
			];


			(* -------------------------- *)
			(* -- Make Notebook Tables -- *)
			(* -------------------------- *)

			(* -- One-time charges -- *)

			{certificationCharges,privateTutoringFee}=Lookup[currentBillPacket,{CertificationCharges,PrivateTutoringFee}];

			(* -- Subscription Charges -- *)

			(* Subscription:  LabAccessFee, SubscriptionDiscounts, NumberOfBaselineUsers, CommandCenterPrice, NumberOfAdditionalUsers *)
			formattedExtraUsers=Module[{ccPrice,safeAdditionalUsers},
				ccPrice=Lookup[currentBillPacket,CommandCenterPrice];
				safeAdditionalUsers=Lookup[currentBillPacket,NumberOfAdditionalUsers]/.(Null->0);

				(* format for the notebook table *)
				{"",safeAdditionalUsers,ccPrice * safeAdditionalUsers}
			];

			(* the discounts are in the form {"discount tag", Amount} *)
			{formattedDiscountTuples,formattedDiscountTags}=Module[{rawDiscounts},
				(* look up any discounts from the bill *)
				rawDiscounts=Lookup[currentBillPacket,SubscriptionDiscounts];

				(* format the discounts *)
				If[MatchQ[rawDiscounts,({} | Null)],

					(* if there are no discounts, return empty lists *)
					{{},{}},

					(* make the discounts in the format of {description, 1, charge} *)
					(* make sure that the discount comes out negative, in case it was entered as a positive value by accident or by convention *)
					{
						Map[
							{
								#[[2]],
								1,
								Minus[Abs[#[[1]]]]
							}&,
							rawDiscounts
						],
						ConstantArray["Subscription Discount",Length[rawDiscounts]]
					}
				]
			];

			(*total up all the charges*)
			totalCharge=Total[
				Cases[
					Flatten[{
						composedOtherCharges,
						composedCertificationCharges,
						composedConstellationStorage,
						chargesFromPackets,
						formattedDiscountTuples
					}],
					UnitsP[USD]
				]
			];


			(* -- Recurring -- *)

			labAccessFee=If[protocolsRun>=1,Lookup[currentBillPacket,LabAccessFee],0 * USD];

			recurringData={
				{"","",labAccessFee},(* lab access *)
				{"","",composedCertificationCharges},(* certification *)
				{"","",privateTutoringFee},(* private tutoring *)
				{"","",Last[formattedExtraUsers]}
			};

			recurringLabels={
				"Lab Access",
				"Certification",
				"Private Tutoring",
				"Additional Users"
			};

			recurringSortOrder=OrderingBy[recurringData,-Last[#,Null]&];

			(*materials, times add: ConstellationStorage, ConstellationUsage, ConstellationPrice*)
			recurringTable={
				PlotTable[
					Join[
						recurringData[[recurringSortOrder]],
						{{
							"",
							"",
							Total[
								Replace[
									Flatten@{
										labAccessFee,
										composedCertificationCharges,privateTutoringFee,Last[formattedExtraUsers]
									},
									{0->0 USD},(* If any weird formatting comes up in the total table, this is the place to fix them *)
									1
								]
							]
						}}
					],
					Title->"Recurring Charges Overview",
					TableHeadings->{
						Join[
							recurringLabels[[recurringSortOrder]],
							{"Total"}
						],
						{"Price","Credit","Charged Cost"}
					},
					UnitForm->False,
					Round->0.01
				],
				"Output"
			};


			(* -- Utilization -- *)

			discountCharges={"","",Last[#]}&/@formattedDiscountTuples;
			discountTags=First[#]&/@formattedDiscountTuples;

			utilizationData={
				{totalProtocolPrice,totalProtocolDiscount,totalProtocolCharge},
				{totalMaterialsPrice,totalMaterialsDiscount,totalMaterialsCharge},
				{totalWastePrice,totalWasteDiscount,totalWasteCharge},
				{totalCleaningPrice,totalCleaningDiscount,totalCleaningCharge},
				{totalStoragePrice,totalStorageDiscount,totalStorageCharge},
				{totalStockingPrice,totalStockingDiscount,totalStockingCharge},
				{totalShippingPrice,totalShippingDiscount,totalShippingCharge},
				{UnitConvert[totalOperatorTime,"Hours"],UnitConvert[discountedOperatorTime,"Hours"],totalOperatorCharge},
				{UnitConvert[totalInstrumentTime,"Hours"],UnitConvert[discountedInstrumentTime,"Hours"],totalInstrumentCharge},
				{composedConstellationUsage,composedConstellationDiscount,composedConstellationStorage},
				{priorityProtocols,priorityProtocolsDiscounted,priorityProtocolsCharged}
			};

			utilizationLabels={
				"Experiment Fee",
				"Materials",
				"Waste",
				"Cleaning",
				"Storage",
				"Stocking",
				"Shipping",
				"Operator Time",
				"Instrument Time",
				"Constellation Storage",
				"Priority Experiments"
			};

			(* Sort total charges from high to low *)
			utilizationSortOrder=OrderingBy[utilizationData,-Last[#,Null]&];

			utilizationTable={
				PlotTable[
					Join[
						(* Sort *)
						utilizationData[[utilizationSortOrder]],
						discountCharges,(* discounts *)
						{{
							"",
							"",
							Total[
								Replace[
									Flatten@{
										totalProtocolCharge,totalMaterialsCharge,totalWasteCharge,totalCleaningCharge,
										totalStorageCharge,totalStockingCharge,totalShippingCharge,totalOperatorCharge,
										totalInstrumentCharge,composedConstellationStorage,discountCharges[[All,-1]]
									},
									{0->0 USD},(* If any weird formatting comes up in the total table, this is the place to fix them *)
									1
								]
							]
						}}],
					Title->"Utilization Overview",
					TableHeadings->{
						Join[
							utilizationLabels[[utilizationSortOrder]],
							discountTags,
							{"Total"}
						],
						{"Price","Discount","Charged Cost"}
					},
					UnitForm->False,
					Round->0.01
				],
				"Output"
			};

			(* -- cost breakdown -- *)

			(* combine all the results for notebook output *)
			protocolSpecificBilling=Sequence[
				{
					PlotTable[
						If[MatchQ[composedProtocolValues,Null],
							{{"","","","",0 USD,0 USD}},
							Append[
								composedProtocolValues,
								{"Total","","","","",Total[composedProtocolValues[[All,-1]]]}
							]
						],
						TableHeadings->{None,{"Protocol","Date Completed","Protocol Author","Priority","Price","Charge"}},
						Title->"Experiment Fees",
						UnitForm->False,
						Round->0.01
					],
					"Output"
				},
				{
					PlotTable[
						If[MatchQ[composedMaterialValues,Null],
							{{"","","","",0,"",0 USD}},
							Append[
								composedMaterialValues,
								{Total,"","","","","",Total[composedMaterialValues[[All,-1]]]}
							]
						],
						TableHeadings->{None,{"Date Purchased","Materials","Protocol/Transaction","Notebook","Amount","Price Per Unit","Total Cost"}},
						Title->"Material Purchases",
						UnitForm->False,
						Round->0.01
					],
					"Output"
				},
				{
					PlotTable[
						If[MatchQ[composedWasteValues,Null],
							{{"","","",0 USD,0 USD}},
							Append[
								composedWasteValues,
								{"Total","","","",Total[composedWasteValues[[All,-1]]]}
							]
						],
						TableHeadings->{None,{"Date Disposed","Associated Protocol","Waste Type","Price","Charge"}},
						Title->"Waste",
						UnitForm->False,
						Round->0.01
					],
					"Output"
				},
				{
					PlotTable[
						If[MatchQ[composedCleaningValues,Null],
							{{"","","","",0 USD,0 USD}},
							Append[
								composedCleaningValues,
								{"Total","","","","",Total[composedCleaningValues[[All,-1]]]}
							]
						],
						TableHeadings->{None,{"Date Cleaned","Material Cleaned","Associated Protocol/Maintenance","Cleaning Type","Price","Charge"}},
						Title->"Cleaning",
						UnitForm->False,
						Round->0.01
					],
					"Output"
				},
				{
					PlotTable[
						If[MatchQ[composedStockingValues,Null],
							{{"","","","",0 USD,0 USD}},
							Append[
								Map[Flatten@{#[[1]],N@#[[2]],#[[3;;]]}&,composedStockingValues],
								{"Total","","","","","",Total[composedStockingValues[[All,-1]]]}
							]
						],
						TableHeadings->{None,{"Material Stocked","Volume","Stocking Protocol/Maintenance","Storage Condition","Price","Discount","Charge"}},
						Title->"Stocking",
						UnitForm->False,
						Round->0.01
					],
					"Output"
				},
				{
					PlotTable[
						If[MatchQ[composedOperatorValuesNotebook,Null],
							{{"","","",0 Hour,0 Hour,0 USD}},
							Append[
								composedOperatorValuesNotebook,
								{"Total","","","",Total[composedOperatorValuesNotebook[[All,-1]]]}
							]
						],
						TableHeadings->{None,{"Date Completed","Protocol","Operator Time","Discounted Time","Charge"}},
						Title->"Operator Time",
						UnitForm->False,
						Round->0.01
					],
					"Output"
				},
				{
					PlotTable[
						If[MatchQ[composedInstrumentValues,Null],
							{{"","","","",0 Hour,0 Hour,0 USD}},
							(* scale units for Time and round them *)
							Join[
								Map[Flatten@{#[[1;;4]],UnitScale[#[[5]]],UnitScale[#[[6]]],#[[7]]}&,composedInstrumentValues],
								instrumentTiersSubtotals,
								{{"Total","","","","","",Total[composedInstrumentValues[[All,-1]]]}}
							]
						],
						TableHeadings->{None,{"Date Completed","Protocol","Instrument","Instrument Tier","Instrument Time","Discounted Time","Charge"}},
						Title->"Instrument Time",
						UnitForm->False,
						Round->0.01
					],
					"Output"
				}
			];

			(* non- protocol specific billing: shipping and data *)
			nonProtocolCharges=Sequence[
				{
					PlotTable[
						If[MatchQ[composedShippingValues,Null],
							{{"","","",0 USD,0 USD,0 USD,0 USD}},
							Append[
								composedShippingValues,
								{"Total","","","","","",Total[composedShippingValues[[All,-1]]]}
							]
						],
						TableHeadings->{None,{"Date of Shipment","Shipment","Shipment Weight","Price","Tax","Discount","Charge"}},
						Title->"Shipping",
						UnitForm->False,
						Round->0.01
					],
					"Output"
				},
				{
					PlotTable[
						{
							{Round[composedConstellationObjects * (50) / (1000000),0.01],rawConstellationStorage,composedConstellationStorage}
						},
						TableHeadings->{None,{"Storage (GB)","Price","Charge"}},
						Title->"Constellation Storage",
						UnitForm->False,
						Round->0.01
					],
					"Output"
				},
				{
					PlotTable[
						If[MatchQ[composedStorageValues,Null],
							{{"","","","","","",0 USD,0 USD}},
							(* scale units for Volume and Time and round them *)
							Append[
								Map[{#[[1]],#[[2]],#[[3]],#[[4]],UnitScale[#[[5]]],UnitScale[#[[6]]],#[[7]],#[[8]],#[[9]]}&,composedStorageValues],
								{"Total","","","","","","","",Total[composedStorageValues[[All,-1]]]}
							]
						],
						TableHeadings->{None,{"DateLastUsed","Object","Source","Storage Condition","Volume","Time in Storage","Price","Discount","Charge"}},
						Title->"Storage",
						UnitForm->False,
						Round->0.01
					],
					"Output"
				}
			];


			(* -------------------------- *)
			(* -- Compose the notebook -- *)
			(* -------------------------- *)

			(* Gather the information *)
			billingInformation={
				{
					StringJoin[
						"Summary for billing from ",
						DateString[Lookup[currentBillPacket,DateStarted]/.(Null->Now)],
						" to ",
						If[MatchQ[Lookup[currentBillPacket,DateCompleted],_?DateObjectQ],
							DateString[Min[Lookup[currentBillPacket,DateCompleted],Now]],
							DateString[Now]
						]
					],
					"Title"
				},

				(* -- cover page summary -- *)
				{"This notebook summarizes the charges and discounts applied to "<>ToString[Lookup[currentBillPacket,Object]]<>".","Text"},
				{"Billing Summary","Section"},
				{"Overview","Subsection"},

				{"Plan Summary","Subsubsection"},
				planSummaryTable,

				{"Recurring Charges","Subsubsection"},
				recurringTable,

				{"Utilization Charges","Subsubsection"},
				utilizationTable,

				{"Utilization Charge Details","Subsection"},
				{"Protocol Incurred Charges","Subsubsection"},
				{"A summary of charges incurred via protocol-specific events such as the usage of instrument time, operator time, cleaning, and materials:","Text"},
				protocolSpecificBilling,

				{"Non - Protocol Incurred Charges","Subsubsection"},
				{"A summary of charges incurred via events not resulting from specific protocol:","Text"},
				nonProtocolCharges
			};

			(* remove Links and replace IDs with Names when possible *)
			reformattedBillingInformation=removeLinksAddNames[billingInformation];

			(* create notebook cells for the headers *)
			notebookContents=billingNotebookCell@@@reformattedBillingInformation;

			(* create a filename for the output notebook *)
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory,ObjectToFilePath[Download[Lookup[currentBillPacket,Organization],Object]]}]]];
			outputFileName=FileNameJoin[{$TemporaryDirectory,ObjectToFilePath[Download[Lookup[currentBillPacket,Organization],Object]],CreateUUID[]<>".nb"}];

			(* export the file *)
			Export[outputFileName,
				Notebook[
					notebookContents,
					WindowSize->{1024,800},
					WindowMargins->{{0,Automatic},{Automatic,0}},
					StyleDefinitions->"CommandCenter.nb"
				]
			];

			(* create packet to upload bill notebook object. The notebook option of UploadCloudFile does not work, when it is patched this will be fine because Upload can handle duplicate keys *)
			billingNotebookPacket=Append[
				UploadCloudFile[outputFileName,Notebook->notebook,Upload->False,Name->"Billing Notebook"],
				Transfer[Notebook]->Link[notebook,Objects]
			];

			(* add the notebook update packet *)
			updateBillWithNotebookPacket=If[!noCurrentBillQ,
				Association[
					Object->Lookup[currentBillPacket,Object],
					BillSummaryNotebook->Link[Lookup[billingNotebookPacket,Object]]
				],
				{}
			];

			(* output the update packets *)
			{billingNotebookPacket,updateBillWithNotebookPacket}
		]
	];

	composedSubtotals={
		{"Experiment Fee",totalProtocolCharge},
		{"Materials",totalMaterialsCharge},
		{"Waste",totalWasteCharge},
		{"Cleaning",totalCleaningCharge},
		{"Storage",totalStorageCharge},
		{"Stocking",totalStockingCharge},
		{"Shipping",totalShippingCharge},
		{"Operator Time",totalOperatorCharge},
		{"Instrument Time",totalInstrumentCharge},
		{"Constellation Storage",composedConstellationStorage}
	};


	(* ------------------------ *)
	(* -- Main Upload Packet -- *)
	(* ------------------------ *)

	(* -- generate pricing based update packets -- *)
	pricingUpdatePacket=If[!noCurrentBillQ,
		Association[
			Object->Lookup[currentBillPacket,Object],

			(* update the pricing, Null if needed *)
			ConstellationStorage->composedConstellationStorage,
			ConstellationUsage->composedConstellationObjects,

			Replace[MaterialPurchases]->composedMaterialValues/.(x:ObjectP[]:>Link[x]),
			Replace[ExperimentsCharged]->composedProtocolValues/.(x:ObjectP[]:>Link[x]),
			Replace[OperatorTimeCharges]->composedOperatorValues/.(x:ObjectP[]:>Link[x]),
			Replace[InstrumentTimeCharges]->composedInstrumentValues/.(x:ObjectP[]:>Link[x]),
			Replace[CleanUpCharges]->composedCleaningValues/.(x:ObjectP[]:>Link[x]),
			Replace[StockingCharges]->composedStockingValues/.(x:ObjectP[]:>Link[x]),
			Replace[WasteDisposalCharges]->composedWasteValues/.(x:ObjectP[]:>Link[x]),
			Replace[StorageCharges]->composedStorageValues/.(x:ObjectP[]:>Link[x]),
			Replace[ShippingCharges]->composedShippingValues/.(x:ObjectP[]:>Link[x]),
			Replace[SubtotalCharges]->composedSubtotals,
			TotalCharge->totalCharge
		]
	];

	(* gather all output that we need *)
	allBillUpdatePackets=Flatten[{pricingUpdatePacket,notebookPackets}]
];

(* ::Subsection::Closed:: *)
(*billingNotebookCell*)


(* ::Subsubsection:: *)
(*billingNotebookCell*)

Authors[billingNotebookCell]={"dima", "alou"};

billingNotebookCell[
	input_,
	style:(
		"Title" | "Chapter" | "Subchapter" | "Section" | "Subsection" | "Subsubsection" | "Text" | "Input" |
			"CodeText" | "Output" | "Subtitle" | "Subsubtitle" | "Item" | "ItemParagraph" | "Subitem" |
			"SubitemParagraph" | "Subsubitem" | "SubsubitemParagraph" | "ItemNumbered" | "SubitemNumbered" |
			"SubsubitemNumbered"
	),
	inputOptions:OptionsPattern[]
]:=Module[{optionsList, validOptions, finalOptions},

	(* turn options sequence into a list *)
	optionsList=ToList[inputOptions];

	(* test if the options provided are valid Cell options *)
	validOptions=Quiet[
		SafeOptions[Cell, optionsList, AutoCorrect -> False],
		Symbol::string
	];

	(* if the options provided aren't valid ignore all of them *)
	finalOptions=If[FailureQ[validOptions],
		{},
		optionsList
	];

	(* create a cell based on the style provided as the second argument *)
	Which[
		MatchQ[style, "Output"], Cell[BoxData[ToBoxes[input, StandardForm]], "Output", Sequence @@ finalOptions],
		MatchQ[style, "Input"], Cell[BoxData[ToBoxes[input, StandardForm]], "Input", Sequence @@ finalOptions],
		True, Cell[TextData[input], style, Sequence @@ finalOptions]
	]
];


(* ::Subsection:: *)
(*billingAsanaTask*)


(* ::Subsubsection::Closed:: *)
(*billingAsanaTask*)

Authors[billingAsanaTask]={"dima", "alou"};

DefineOptions[billingAsanaTask,
	Options :> {
		{Status -> Success, Success | Failure, "Indicates if an this task creation will be for a successful run or a failure."},
		{Message -> "", Null | _String | {_String...}, "Text that will be places in the comment section of the created task."}
	}
];

billingAsanaTask[team:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]]:=Module[
	{
		finance, asanaPacket, safeOps, status, message, failQ, safeMessages, teamString
	},

	(* get the options for the function *)
	safeOps=SafeOptions[billingAsanaTask, ToList[ops]];
	{status, message}=Lookup[safeOps, {Status, Message}];
	failQ=MatchQ[status, Failure];

	(* search for finance folks to vet and create invoice *)
	(* temporary hardcoded Addie and Lauren since the GeneralAndAdministrative team is too broad. If there is a Finance Department added, then we could search and remove the hardcoding *)
	finance=billingTeam;

	safeMessages=If[NullQ[message], "", message];
	teamString = ECL`InternalUpload`ObjectToString[team];

	(* make asana packet *)
	asanaPacket=If[failQ,
		<|
			Name -> "Bill update failed for "<>teamString,
			Completed -> False,
			Notes -> "Bill for the "<>teamString<>" has failed. Additional information:\n"<>safeMessages,
			Projects -> {"Business Operations"},
			Tags -> {"P5"},
			DueDate -> (Now + 3 Day)
		|>,
		<|
			Name -> "Bill Ready: "<>teamString,
			Completed -> False,
			Notes -> "Team "<>teamString<>" has their latest bill completed. You can find the ID for it by checking the latest entry in the Billing History field for the team. If execution of the function created any messages they are listed below.\n\n"<>safeMessages,
			(* Followers -> finance, *)
			Projects -> {"Business Operations"},
			Tags -> {"P3"},
			DueDate -> (Now + 7 Day)
		|>];

	(* create the asana task or output the packet if we are on test db *)
	If[
		ECL`ProductionQ[],
		ECL`CreateAsanaTask[asanaPacket],
		asanaPacket
	]
];

(* ::Subsection:: *)
(*ExportBillingData*)


(* ::Subsubsection::Closed:: *)
(*ExportBillingData*)

Authors[ExportBillingData]={"alou", "robert", "dima"};

Warning::BillNotFinished="Input Bill has Status of Open, please keep it in mind.";

DefineOptions[ExportBillingData,
	Options :> {
		{Notebook -> False, True | False, "Indicates if Notebook column would be added to the exported document."}
	}
];

(* list input overload *)
ExportBillingData[bills:{ObjectReferenceP[Object[Bill]]...}, filePath_String, ops:OptionsPattern[]]:=Map[ExportBillingData[#, filePath, ops]&, bills];

(* single bill input overload *)
ExportBillingData[bill:ObjectReferenceP[Object[Bill]], filePath_String, ops:OptionsPattern[]]:=Module[
	{
		rawDownloadData, reformattedDownload, safeOps, notebookQ,
		billStatus, organizationName, dateCompleted,
		operatorTimeCharges, instrumentTimeCharges, cleanUpCharges, stockingCharges,
		wasteDisposalCharges, storageCharges, shippingCharges, certificationCharges,
		operatorTimeChargesFormatted, instrumentTimeChargesFormatted, cleanUpChargesFormatted,
		stockingChargesFormatted, wasteDisposalChargesFormatted, storageChargesFormatted,
		shippingChargesFormatted, certificationChargesFormatted, materialPurchases,
		materialPurchasesFormatted, experimentsCharged, experimentsChargedFormatted,
		objectModelMap, instrumentTimeChargesCollapsedFormatted,
		storageChargesCollapsedFormatted, materialsChargesCollapsedFormatted,
		summaryPage, constellationCharge
	},

	(* get the options *)
	safeOps=SafeOptions[ExportBillingData, ToList[ops]];
	notebookQ=TrueQ[Lookup[safeOps, Notebook]];

	(* Download data for exporting *)
	ClearDownload[];
	(* Object Does Not Exist is for cases when an item became private while after it was used by this team *)
	rawDownloadData=Quiet[Download[bill,
		{
			Status,
			Organization[Name],
			DateCompleted,
			OperatorTimeCharges,
			InstrumentTimeCharges,
			CleanUpCharges,
			StockingCharges,
			WasteDisposalCharges,
			StorageCharges,
			ShippingCharges,
			CertificationCharges,
			MaterialPurchases,
			ExperimentsCharged,
			ConstellationStorage
		}],{Download::ObjectDoesNotExist}];
	ClearDownload[];

	(* assign downloaded items that don't need processing *)
	{
		billStatus,
		organizationName,
		dateCompleted
	}=rawDownloadData[[1;;3]];

	constellationCharge=rawDownloadData[[14]];

	(* reformat the data - remove Link and use ObjectToString *)
	reformattedDownload=If[notebookQ,
		(* add Notebook to the data for line items *)
		Module[
			{
				operatorTimeChargesNb, instrumentTimeChargesNb, cleanUpChargesNb, stockingChargesNb, wasteDisposalChargesNb,
				storageChargesNb, shippingChargesNb, certificationChargesNb, materialPurchasesNb, experimentsChargedNb,
				uniqueObjectsNotebook, allNotebooks, noLinksNotebooks, notebookRules
			},

			(* remove links *)
			noLinksNotebooks=rawDownloadData[[4;;13]] /. {x:LinkP[] :> Download[x, Object]};
			(* collect unique objects *)
			uniqueObjectsNotebook=DeleteDuplicates[Flatten[Cases[noLinksNotebooks, ObjectReferenceP[], Infinity]]];
			(* download notebooks for these objects*)
			(* Object Does Not Exist is for cases when an item became private while after it was used by this team *)
			allNotebooks=Flatten@Quiet[Download[uniqueObjectsNotebook, Notebook[Object]], {Download::NotLinkField, Download::ObjectDoesNotExist}];
			ClearDownload[];
			(* create rules for object->notebook *)
			notebookRules=MapThread[#1 -> #2&, {uniqueObjectsNotebook, allNotebooks}];

			(* adding Notebook as a last column to the data if data does not have it already*)
			operatorTimeChargesNb=Map[
				Flatten[{#, (#[[2]] /. notebookRules)}]&,
				noLinksNotebooks[[1]]
			];
			instrumentTimeChargesNb=Map[
				Flatten[{#, (#[[2]] /. notebookRules)}]&,
				noLinksNotebooks[[2]]
			];
			cleanUpChargesNb=Map[
				Flatten[{#, (#[[3]] /. notebookRules)}]&,
				noLinksNotebooks[[3]]
			];
			stockingChargesNb=Map[
				Flatten[{#, (#[[3]] /. notebookRules)}]&,
				noLinksNotebooks[[4]]
			];
			wasteDisposalChargesNb=Map[
				Flatten[{#, (#[[2]] /. notebookRules)}]&,
				noLinksNotebooks[[5]]
			];
			storageChargesNb=Map[
				Flatten[{#, (#[[2]] /. notebookRules)}]&,
				noLinksNotebooks[[6]]
			];
			shippingChargesNb=Map[
				Flatten[{#, (#[[2]] /. notebookRules)}]&,
				noLinksNotebooks[[7]]
			];
			certificationChargesNb=noLinksNotebooks[[8]];
			materialPurchasesNb=noLinksNotebooks[[9]];
			experimentsChargedNb=Map[
				Flatten[{#, (#[[1]] /. notebookRules)}]&,
				noLinksNotebooks[[10]]
			];

			(* return data after adding Names *)
			removeLinksAddNames[#]& /@
				{
					operatorTimeChargesNb,
					instrumentTimeChargesNb,
					cleanUpChargesNb,
					stockingChargesNb,
					wasteDisposalChargesNb,
					storageChargesNb,
					shippingChargesNb,
					certificationChargesNb,
					materialPurchasesNb,
					experimentsChargedNb
				}
		],
		removeLinksAddNames[#]& /@ Part[rawDownloadData, 4;;13]
	];

	(* assign reformatted data to the appropriate variables *)
	{
		operatorTimeCharges,
		instrumentTimeCharges,
		cleanUpCharges,
		stockingCharges,
		wasteDisposalCharges,
		storageCharges,
		shippingCharges,
		certificationCharges,
		materialPurchases,
		experimentsCharged
	}=reformattedDownload;

	(* download information to convert Objects of the Instruments into Models*)
	objectModelMap=Module[
		{allObject, allModels, allObjectsStrings},

		(* all Objects for Instruments and Containers *)
		allObjectsStrings=Flatten[{instrumentTimeCharges[[All, 3]], storageCharges[[All, 2]]}];

		(* convert all strings to expressions *)
		allObject=If[MatchQ[#, _String], ToExpression[#], #]& /@ allObjectsStrings;

		(* models for the container and Instruments *)
		allModels=Flatten[Download[allObject, Model[Object]]];
		ClearDownload[];

		MapThread[#1 -> #2&, {allObjectsStrings, allModels}]
	];

	(* if our Bill is Open, throw a warning *)
	If[MatchQ[billStatus, Open], Message[Warning::BillNotFinished]];

	(* for empty data fields add a message *)
	(* reformat data so it will be usable in Excel *)
	operatorTimeChargesFormatted=If[MatchQ[operatorTimeCharges, {}],
		{"No Data in the Object for this type of Charges"},
		Module[{titles, data, gatheredData, subtotals, total},
			titles={{
				"Date Completed",
				"Protocol",
				If[notebookQ, "Notebook", Nothing],
				"Operator Time (Hours)",
				"Discounted Time (Hours)",
				"Charge (USD)"}};
			data=Map[
				{
					DateString[#[[1]]],
					#[[2]],
					If[notebookQ, #[[-1]], Nothing],
					N@Unitless[UnitConvert[#[[4]], "Hours"]],
					N@Unitless[UnitConvert[#[[5]], "Hours"]],
					N@Unitless[#[[6]]]
				}&,
				operatorTimeCharges];
			gatheredData=GatherBy[data, #[[3]]&];
			subtotals=If[notebookQ, Map[Flatten@{"Total", "", #[[1, 3]], Round[Unitless[Total[#[[All, 4]]]], 0.01], Round[Unitless[Total[#[[All, 5]]]], 0.01], Round[Unitless[Total[#[[All, 6]]]], 0.01]}&, gatheredData], {}];
			total={Flatten@{"Total", ConstantArray["", Length[data[[1]]] - 2], Round[Unitless[Total[data[[;;, -1]]]], 0.01]}};
			If[notebookQ, Join[titles, data, subtotals, total], Join[titles, data, total]]
		]];

	instrumentTimeChargesFormatted=If[MatchQ[instrumentTimeCharges, {}],
		{"No Data in the Object for this type of Charges"},
		Module[{titles, data, gatheredData, subtotals, total},
			titles={{
				"Date Completed",
				"Protocol",
				If[notebookQ, "Notebook", Nothing],
				"Instrument",
				"Instrument Tier",
				"Instrument Time (Hours)",
				"Discounted Time (Hours)",
				"Charge (USD)"}};
			data=Map[
				{
					DateString[#[[1]]],
					#[[2]],
					If[notebookQ, #[[-1]], Nothing],
					#[[3]],
					#[[4]],
					N@Unitless[UnitConvert[#[[5]], "Hours"]],
					N@Unitless[UnitConvert[#[[6]], "Hours"]],
					N@Unitless[#[[7]]]
				}&,
				instrumentTimeCharges];
			gatheredData=GatherBy[data, #[[3]]&];
			subtotals=If[notebookQ, Map[Flatten@{"Total", "", #[[1, 3]], "", "", Round[Unitless[Total[#[[All, 6]]]], 0.01], Round[Unitless[Total[#[[All, 7]]]], 0.01], Round[Unitless[Total[#[[All, 8]]]], 0.01]}&, gatheredData], {}];
			total={Flatten@{"Total", ConstantArray["", Length[data[[1]]] - 2], Round[Unitless[Total[data[[;;, -1]]]], 0.01]}};
			If[notebookQ, Join[titles, data, subtotals, total], Join[titles, data, total]]
		]];

	instrumentTimeChargesCollapsedFormatted=If[MatchQ[instrumentTimeCharges, {}],
		{"No Data in the Object for this type of Charges"},
		Module[
			{modelsData, groupedData, collapsedData, collapsedNamedData, fullData},

			(* change instrument Objects to Models *)
			modelsData=instrumentTimeCharges[[All, 3]] /. (x_ :> Lookup[objectModelMap, x]);

			(* reassemble the data list *)
			fullData=MapThread[Flatten[{#1, #2[[4;;]]}]&, {modelsData, instrumentTimeCharges}];

			(*collapse all the data based on the Instrument Model and filter data*)
			groupedData=If[notebookQ,
				GatherBy[SortBy[fullData, Last], {First[#], Last[#]}&],
				GatherBy[fullData, First]
			];

			(* collapse all the data based on the Instrument Model *)
			collapsedData=Map[{
				#[[1, 1]], (* instrument model *)
				#[[1, 2]], (* instrument tier *)
				Total[#[[All, 3]]], (* total time *)
				Total[#[[All, 4]]], (* total Discounted time *)
				Total[#[[All, 5]]], (* total charge *)
				If[notebookQ, #[[1, -1]], Nothing] (* notebook *)
			}&, groupedData];

			(* substitute IDs to Names when possible *)
			collapsedNamedData=ExperimentUtilities`Private`removeLinksAddNames[collapsedData];

			Join[
				{{
					"Instrument Model",
					If[notebookQ, "Notebook", Nothing],
					"Instrument Tier",
					"Instrument Time (Hours)",
					"Discounted Time (Hours)",
					"Charge (USD)"}},
				Map[
					{
						#[[1]],
						If[notebookQ, #[[-1]], Nothing],
						#[[2]],
						N@Unitless[UnitConvert[#[[3]], "Hours"]],
						N@Unitless[UnitConvert[#[[4]], "Hours"]],
						N@Unitless[#[[5]]]
					}&,
					collapsedNamedData]
			]]
	];

	cleanUpChargesFormatted=If[MatchQ[cleanUpCharges, {}],
		{"No Data in the Object for this type of Charges"},
		Module[{titles, data, gatheredData, subtotals, total},
			titles={{
				"Date Cleaned",
				"Material Cleaned",
				If[notebookQ, "Notebook", Nothing],
				"Associated Protocol/Maintenance",
				"Cleaning Type",
				"Price (USD)",
				"Charge (USD)"}};
			data=Map[
				{
					DateString[#[[1]]],
					#[[2]],
					If[notebookQ, #[[-1]], Nothing],
					#[[3]],
					#[[4]],
					N@Unitless[#[[5]]],
					N@Unitless[#[[6]]]
				}&,
				cleanUpCharges];
			gatheredData=GatherBy[data, #[[3]]&];
			subtotals=If[notebookQ, Map[Flatten@{"Total", "", #[[1, 3]], "", "", Round[Unitless[Total[#[[All, 6]]]], 0.01], Round[Unitless[Total[#[[All, 7]]]], 0.01]}&, gatheredData], {}];
			total={Flatten@{"Total", ConstantArray["", Length[data[[1]]] - 2], Round[Unitless[Total[data[[;;, -1]]]], 0.01]}};
			If[notebookQ, Join[titles, data, subtotals, total], Join[titles, data, total]]
		]];

	stockingChargesFormatted=If[MatchQ[stockingCharges, {}],
		{"No Data in the Object for this type of Charges"},
		Module[{titles, data, gatheredData, subtotals, total},
			titles={{
				"Material Stocked",
				"Volume (cm^3)",
				If[notebookQ, "Notebook", Nothing],
				"Stocking Protocol/Maintenance",
				"Storage Condition",
				"Price (USD)",
				"Discount (USD)",
				"Charge (USD)"}};
			data=Map[
				{
					#[[1]],
					N@Unitless[UnitConvert[#[[2]], "cm^3"]],
					If[notebookQ, #[[-1]], Nothing],
					#[[3]],
					#[[4]],
					N@Unitless[#[[5]]],
					N@Unitless[#[[6]]],
					N@Unitless[#[[7]]]
				}&,
				stockingCharges];
			gatheredData=GatherBy[data, #[[3]]&];
			subtotals=If[notebookQ, Map[Flatten@{"Total", "", #[[1, 3]], "", "", Round[Unitless[Total[#[[All, 6]]]], 0.01], Round[Unitless[Total[#[[All, 7]]]], 0.01], Round[Unitless[Total[#[[All, 8]]]], 0.01]}&, gatheredData], {}];
			total={Flatten@{"Total", ConstantArray["", Length[data[[1]]] - 2], Round[Unitless[Total[data[[;;, -1]]]], 0.01]}};
			If[notebookQ, Join[titles, data, subtotals, total], Join[titles, data, total]]
		]];

	wasteDisposalChargesFormatted=If[MatchQ[wasteDisposalCharges, {}],
		{"No Data in the Object for this type of Charges"},
		Module[{titles, data, gatheredData, subtotals, total},
			titles={{
				"Date Disposed",
				"Associated Protocol",
				If[notebookQ, "Notebook", Nothing],
				"Waste Type",
				"Price (USD)",
				"Charge (USD)"}};
			data=Map[
				{
					DateString[#[[1]]],
					#[[2]],
					If[notebookQ, #[[-1]], Nothing],
					#[[3]],
					N@Unitless[#[[4]]],
					N@Unitless[#[[5]]]
				}&,
				wasteDisposalCharges];
			gatheredData=GatherBy[data, #[[3]]&];
			subtotals=If[notebookQ, Map[Flatten@{"Total", "", #[[1, 3]], "", Round[Unitless[Total[#[[All, 5]]]], 0.01], Round[Unitless[Total[#[[All, 6]]]], 0.01]}&, gatheredData], {}];
			total={Flatten@{"Total", ConstantArray["", Length[data[[1]]] - 2], Round[Unitless[Total[data[[;;, -1]]]], 0.01]}};
			If[notebookQ, Join[titles, data, subtotals, total], Join[titles, data, total]]
		]];

	storageChargesFormatted=If[MatchQ[storageCharges, {}],
		{"No Data in the Object for this type of Charges"},
		Module[{titles, data, gatheredData, subtotals, total},
			titles={{
				"Date Last Used",
				"Material",
				If[notebookQ, "Notebook", Nothing],
				"Origin",
				"Storage Condition",
				"Capacity Taken (cm^3)",
				"Storage Time (Hours)",
				"Price (USD)",
				"Discount (USD)",
				"Charge (USD)"}};
			data=Map[
				{
					DateString[#[[1]]],
					#[[2]],
					If[notebookQ, #[[-1]], Nothing],
					#[[3]],
					#[[4]],
					N@Unitless[UnitConvert[#[[5]], "cm^3"]],
					N@Unitless[UnitConvert[#[[6]], "Hours"]],
					N@Unitless[#[[7]]],
					N@Unitless[#[[8]]],
					N@Unitless[#[[9]]]
				}&,
				storageCharges];
			gatheredData=GatherBy[data, #[[3]]&];
			subtotals=If[notebookQ, Map[Flatten@{"Total", "", #[[1, 3]], "", "", "", "", Round[Unitless[Total[#[[All, 8]]]], 0.01], Round[Unitless[Total[#[[All, 9]]]], 0.01], Round[Unitless[Total[#[[All, 10]]]], 0.01]}&, gatheredData], {}];
			total={Flatten@{"Total", ConstantArray["", Length[data[[1]]] - 2], Round[Unitless[Total[data[[;;, -1]]]], 0.01]}};
			If[notebookQ, Join[titles, data, subtotals, total], Join[titles, data, total]]
		]];


	storageChargesCollapsedFormatted=If[MatchQ[storageCharges, {}],
		{"No Data in the Object for this type of Charges"},
		Module[
			{modelsData, groupedData, collapsedData, collapsedNamedData, fullData},

			(* change instrument Objects to Models *)
			modelsData=storageCharges[[All, 2]] /. (x_ :> Lookup[objectModelMap, x]);

			(* reassemble the data *)
			fullData=MapThread[Flatten[{#1, #2[[{4, 5, 6, 8}]], Last[#2]}]&, {modelsData, storageCharges}];

			(*collapse all the data based on the Instrument Model and filter data*)
			groupedData=If[notebookQ,
				GatherBy[SortBy[fullData, Last], {#[[1;;2]], Last[#]}&],
				GatherBy[fullData, #[[1;;2]]&]];

			(* collapse all the data based on the Storage Condition and container Model *)
			collapsedData=Map[{
				#[[1, 2]], (* storage condition *)
				#[[1, 1]], (* container Model *)
				Total[Times[#[[3]] * #[[4]]]& /@ #], (* total time-volume used *)
				Total[#[[All, 6]]], (* total charge *)
				If[notebookQ, #[[1, -1]], Nothing] (* notebook *)
			}&, groupedData];

			(* substitute IDs to Names when possible *)
			collapsedNamedData=removeLinksAddNames[collapsedData];

			Join[
				{{
					"Storage Condition",
					If[notebookQ, "Notebook", Nothing],
					"Container Model",
					"Time-Capacity taken (cm^3*Hour)",
					"Charge (USD)"}},
				Map[
					{
						#[[1]],
						If[notebookQ, #[[-1]], Nothing],
						#[[2]],
						N@Unitless[UnitConvert[#[[3]], "cm^3*Hours"]],
						N@Unitless[#[[4]]]
					}&,
					collapsedNamedData]
			]]
	];

	shippingChargesFormatted=If[MatchQ[shippingCharges, {}],
		{"No Data in the Object for this type of Charges"},
		Module[{titles, data, gatheredData, subtotals, total},
			titles={{
				"Date of Shipment",
				"Shipment",
				If[notebookQ, "Notebook", Nothing],
				"Shipment Weight (kg)",
				"Price (USD)",
				"Tax (USD)",
				"Discount (USD)",
				"Charge (USD)"}};
			data=Map[
				{
					DateString[#[[1]]],
					#[[2]],
					If[notebookQ, #[[-1]], Nothing],
					N@Unitless[UnitConvert[#[[3]], "Kilograms"]],
					N@Unitless[#[[4]]],
					N@Unitless[#[[5]]],
					N@Unitless[#[[6]]],
					N@Unitless[#[[7]]]
				}&,
				shippingCharges];
			gatheredData=GatherBy[data, #[[3]]&];
			subtotals=If[notebookQ, Map[Flatten@{
				"Total",
				"",
				#[[1, 3]],
				"",
				Round[Unitless[Total[#[[All, 5]]]], 0.01],
				Round[Unitless[Total[#[[All, 6]]]], 0.01],
				Round[Unitless[Total[#[[All, 7]]]], 0.01],
				Round[Unitless[Total[#[[All, 8]]]], 0.01]
			}&, gatheredData], {}];
			total={Flatten@{"Total", ConstantArray["", Length[data[[1]]] - 2], Round[Unitless[Total[data[[;;, -1]]]], 0.01]}};
			If[notebookQ, Join[titles, data, subtotals, total], Join[titles, data, total]]
		]];

	certificationChargesFormatted=If[MatchQ[certificationCharges, {}],
		{"No Data in the Object for this type of Charges"},
		Module[{titles, data, gatheredData, total},
			titles={{
				"Date of Certification",
				"Certified User",
				"Certification Level",
				"Charge (USD)"}};
			data=Map[
				{
					DateString[#[[1]]],
					#[[2]],
					#[[3]],
					N@Unitless[#[[4]]]
				}&,
				certificationCharges];
			gatheredData=GatherBy[data, #[[3]]&];
			total={Flatten@{"Total", ConstantArray["", Length[data[[1]]] - 2], Round[Unitless[Total[data[[;;, -1]]]], 0.01]}};
			Join[titles, data, total]
		]];

	materialPurchasesFormatted=If[MatchQ[materialPurchases, {}],
		{"No Data in the Object for this type of Charges"},
		Module[{titles, data, gatheredData, subtotals, total},
			titles={{
				"Date Purchased",
				"Materials",
				"Protocol/Transaction",
				"Notebook",
				"Amount",
				"Units",
				"Price Per Unit",
				"Price Per Unit Units",
				"Total Cost (USD)"}};
			data=Map[
				{
					DateString[#[[1]]],
					#[[2]],
					#[[3]],
					#[[4]],
					N@Unitless[UnitScale[#[[5]]]],
					StringReplace[ToString@Units[UnitScale[#[[5]]]], {"1 " -> "", "US dollar" -> "USD", " per " -> "/", "unity" -> ""}],
					N@Unitless[#[[6]]],
					StringReplace[ToString@Units[#[[6]]], {"1 " -> "", "US dollar" -> "USD", " per " -> "/"}],
					N@Unitless[#[[7]]]
				}&,
				materialPurchases
			];
			gatheredData=GatherBy[data, #[[4]]&];
			subtotals=If[notebookQ, Map[Flatten@{"Total", "", "", #[[1, 4]], "", "", "", "", Round[Unitless[Total[#[[All, 9]]]], 0.01]}&, gatheredData], {}];
			total={Flatten@{"Total", ConstantArray["", Length[data[[1]]] - 2], Round[Unitless[Total[data[[;;, -1]]]], 0.01]}};
			If[notebookQ, Join[titles, data, subtotals, total], Join[titles, data, total]]
		]];

	(* collapse Material charges by Model *)
	materialsChargesCollapsedFormatted=If[MatchQ[materialPurchases, {}],
		{"No Data in the Object for this type of Charges"},
		Module[
			{modelsData, groupedData, collapsedData, collapsedNamedData, fullData},

			(* change instrument Objects to Models *)
			modelsData=materialPurchases[[All, 2]];

			(* reassemble the data *)
			fullData=MapThread[Flatten[{#1, #2[[{5, 7}]], #2[[4]]}]&, {modelsData, materialPurchases}];

			(*collapse all the data based on the Instrument Model and filter data*)
			groupedData=If[notebookQ,
				GatherBy[SortBy[fullData, Last], {#[[1]], Switch[#[[2]], _?VolumeQ, "volume", _?MassQ, "mass", _, "unitless"], Last[#]}&],
				GatherBy[fullData, {#[[1]], Switch[#[[2]], _?VolumeQ, "volume", _?MassQ, "mass", _, "unitless"]}&]];

			(* collapse all the data based on the Storage Condition and container Model *)
			collapsedData=Map[{
				#[[1, 1]], (* material *)
				Total[#[[All, 2]]] / 2, (* total amount purchased - divide by 2 since the tax has been previously broken out as a line item *)
				Total[#[[All, 3]]], (* total charge *)
				If[notebookQ, #[[1, -1]], Nothing] (* notebook *)
			}&, groupedData];

			(* substitute IDs to Names when possible *)
			collapsedNamedData=removeLinksAddNames[collapsedData];

			Join[
				{{
					"Materials",
					If[notebookQ, "Notebook", Nothing],
					"Amount",
					"Units",
					"Total Cost (USD)"}},
				Map[
					{
						#[[1]], (* material *)
						If[notebookQ, #[[-1]], Nothing], (* notebook *)
						Round[Unitless[UnitScale[#[[2]]]], 0.01], (* total amount purchased *)
						StringReplace[ToString@Units[UnitScale[#[[2]]]], {"1 " -> "", "US dollar" -> "USD", " per " -> "/", "unity" -> ""}],
						N@Unitless[#[[3]]] (* total charge *)
					}&,
					collapsedNamedData]
			]]
	];

	experimentsChargedFormatted=If[MatchQ[experimentsCharged, {}],
		{"No Data in the Object for this type of Charges"},
		Module[{titles, data, gatheredData, subtotals, total},
			titles={{
				"Protocol",
				If[notebookQ, "Notebook", Nothing],
				"Date Completed",
				"Protocol Author",
				"Priority",
				"Price (USD)",
				"Charge (USD)"}};
			data=Map[
				{
					#[[1]],
					If[notebookQ, #[[-1]], Nothing],
					DateString[#[[2]]],
					#[[3]],
					#[[4]],
					N@Unitless[#[[5]]],
					N@Unitless[#[[6]]]
				}&,
				experimentsCharged];
			gatheredData=GatherBy[data, #[[2]]&];
			subtotals=If[notebookQ, Map[Flatten@{"Total", #[[1, 2]], "", "", "", "", Round[Unitless[Total[#[[All, 7]]]], 0.01]}&, gatheredData], {}];
			total={Flatten@{"Total", ConstantArray["", Length[data[[1]]] - 2], Round[Unitless[Total[data[[;;, -1]]]], 0.01]}};
			If[notebookQ, Join[titles, data, subtotals, total], Join[titles, data, total]]
		]];

	(* make a summary page *)
	summaryPage=Module[{totalSummary, perNotebookSummaries, allNotebooks, emptyCheck},

		totalSummary={
			{"Category", "Total (USD)"},
			{"Experiment Fee", If[Length[experimentsChargedFormatted] == 1, 0, experimentsChargedFormatted[[-1, -1]]]},
			{"Materials", If[Length[materialPurchasesFormatted] == 1, 0, materialPurchasesFormatted[[-1, -1]]]},
			{"Waste", If[Length[wasteDisposalChargesFormatted] == 1, 0, wasteDisposalChargesFormatted[[-1, -1]]]},
			{"Cleaning", If[Length[cleanUpChargesFormatted] == 1, 0, cleanUpChargesFormatted[[-1, -1]]]},
			{"Storage", If[Length[storageChargesFormatted] == 1, 0, storageChargesFormatted[[-1, -1]]]},
			{"Stocking", If[Length[stockingChargesFormatted] == 1, 0, stockingChargesFormatted[[-1, -1]]]},
			{"Shipping", If[Length[shippingChargesFormatted] == 1, 0, shippingChargesFormatted[[-1, -1]]]},
			{"Operator Time", If[Length[operatorTimeChargesFormatted] == 1, 0, operatorTimeChargesFormatted[[-1, -1]]]},
			{"Instrument Time", If[Length[instrumentTimeChargesFormatted] == 1, 0, instrumentTimeChargesFormatted[[-1, -1]]]},
			{"Constellation Storage", Round[Unitless[constellationCharge] /. Null -> 0, 0.01]},
			{"Certification Charges", If[Length[certificationChargesFormatted] == 1, 0, certificationChargesFormatted[[-1, -1]]]}};

		allNotebooks=If[Length[storageChargesFormatted] == 1, {}, DeleteCases[DeleteDuplicates[storageChargesFormatted[[All, 3]]], ("Notebook" | Nothing | "")]];

		emptyCheck[x_]:=If[Length[x] <= 1, 0, x[[-1, -1]]];

		perNotebookSummaries=If[notebookQ,
			Flatten[Function[{notebook},
				{
					{},
					{"Data for:", notebook},
					{"Category", "Total (USD)"},
					{"Experiment Fee", If[Length[experimentsChargedFormatted] == 1, 0, emptyCheck[Cases[experimentsChargedFormatted, _?(MatchQ[#[[2]], notebook]&)]]]},
					{"Materials", If[Length[materialPurchasesFormatted] == 1, 0, emptyCheck[Cases[materialPurchasesFormatted, _?(MatchQ[#[[4]], notebook]&)]]]},
					{"Waste", If[Length[wasteDisposalChargesFormatted] == 1, 0, emptyCheck[Cases[wasteDisposalChargesFormatted, _?(MatchQ[#[[4]], notebook]&)]]]},
					{"Cleaning", If[Length[cleanUpChargesFormatted] == 1, 0, emptyCheck[Cases[cleanUpChargesFormatted, _?(MatchQ[#[[3]], notebook]&)]]]},
					{"Storage", If[Length[storageChargesFormatted] == 1, 0, emptyCheck[Cases[storageChargesFormatted, _?(MatchQ[#[[3]], notebook]&)]]]},
					{"Stocking", If[Length[stockingChargesFormatted] == 1, 0, emptyCheck[Cases[stockingChargesFormatted, _?(MatchQ[#[[3]], notebook]&)]]]},
					{"Shipping", If[Length[shippingChargesFormatted] == 1, 0, emptyCheck[Cases[shippingChargesFormatted, _?(MatchQ[#[[3]], notebook]&)]]]},
					{"Operator Time", If[Length[operatorTimeChargesFormatted] == 1, 0, emptyCheck[Cases[operatorTimeChargesFormatted, _?(MatchQ[#[[3]], notebook]&)]]]},
					{"Instrument Time", If[Length[instrumentTimeChargesFormatted] == 1, 0, emptyCheck[Cases[instrumentTimeChargesFormatted, _?(MatchQ[#[[3]], notebook]&)]]]}}] /@ allNotebooks, 1],
			Nothing];

		If[notebookQ, Join[totalSummary, perNotebookSummaries], totalSummary]
	];

	(* export the data *)
	Export[FileNameJoin[{filePath, ToString[organizationName]<>DateString[If[NullQ[dateCompleted], (Now - Quantity[1, "Days"]), (dateCompleted - Quantity[1, "Days"])], {"Year", "MonthName", "Day"}]<>".xlsx"}],
		"Sheets" -> {
			"Bill overview" -> summaryPage,
			"Collapsed Instrument Time" -> instrumentTimeChargesCollapsedFormatted,
			"Collapsed Materials" -> materialsChargesCollapsedFormatted,
			"Stocking" -> stockingChargesFormatted,
			"Collapsed Storage" -> storageChargesCollapsedFormatted,
			"Clean Up" -> cleanUpChargesFormatted,
			"Experiments" -> experimentsChargedFormatted,
			"Operator Time" -> operatorTimeChargesFormatted,
			"Waste Disposal" -> wasteDisposalChargesFormatted,
			"Shipping" -> shippingChargesFormatted,
			"Certification" -> certificationChargesFormatted,
			"Instrument Time" -> instrumentTimeChargesFormatted,
			"Storage" -> storageChargesFormatted,
			"Materials" -> materialPurchasesFormatted
		},
		"Rules"]
];

(* helper function to remove the links and replace ID with Name *)
removeLinksAddNames[input_]:=Module[
	{
		noLinks, newCache, uniqueObjects, objectNameMap, namedData,
		objectToPacket
	},
	(* remove all Links to have only Objects exposed *)
	noLinks=input /. {x:LinkP[] :> Download[x, Object]};

	(*-- change all Objects to be displayed by Name if available --*)
	(* get all Objects that are present in the billing Information *)
	uniqueObjects=DeleteDuplicates[Cases[noLinks, ObjectReferenceP[], Infinity]];

	(* make a Download call to grab all names for objects *)
	(* Object Does Not Exist is for cases when an item became private while after it was used by this team *)
	newCache=Quiet[Download[uniqueObjects, Packet[Name]],{Download::ObjectDoesNotExist}];

	(* form an association of Object to Packets *)
	objectToPacket=Association[MapThread[#1 -> #2&, {uniqueObjects, newCache}]];

	(* construct a replacement map *)
	objectNameMap=Map[Function[{objectID},
		Module[{objectPacket, resultName},

			(* grab a packet *)
			objectPacket=Lookup[objectToPacket, objectID];

			(* make an output *)
			resultName=If[NullQ[Lookup[objectPacket, Name]],
				Nothing,
				objectID -> ToString[
					InputForm[objectID /. {Lookup[objectPacket, ID] -> Lookup[objectPacket, Name]}]
				]
			];

			KeyDropFrom[objectToPacket, objectID];
			resultName
		]
	],
		uniqueObjects
	];

	(* clear Download cache to save some memory *)
	ClearDownload[];

	(* replace the objects to Names *)
	namedData=noLinks /. objectNameMap
];


(* ----------------------- *)
(* -- billPricingMatchQ -- *)
(* ----------------------- *)

(* billPricingMatchQ *)

(*a function run nightly that looks at open bills and checks if the pricing in the bills matches the pricing in the Model[Pricing] from which is was supposedly generated*)
(*if a difference is found, an asana task is made with the fields that do not match*)

(* -- Options and messages -- *)
DefineOptions[billPricingMatchQ,
	Options :> {
		{CreateTask -> True, True | False, "Indicates if an Asana task should be generated when bills and their pricing schemes are mismatched."},
		VerboseOption
	}
];
billPricingMatchQ::BillNotOpen="The following bills are not open and will not be checked by this function: `1`";

(* -- singleton Overload -- *)
billPricingMatchQ[bill:ObjectP[Object[Bill]], ops:OptionsPattern[billPricingMatchQ]]:=billPricingMatchQ[{bill}, ops];

(* -- empty input overload -- *)
billPricingMatchQ[ops:OptionsPattern[billPricingMatchQ]]:=Module[
	{allOpenBills},
	(*find all open bills - these are the only ones we want to check. Maybe in the future I can make a historical version of this function if there is a need for it*)
	(* add a conditional to prevent this from finding any sloppy test db objects during unit testing *)
	allOpenBills=Search[Object[Bill], Status == Open&&PricingScheme!=Null];
	billPricingMatchQ[allOpenBills, ops]
];

(* -- other inputs -- *)
billPricingMatchQ[emptyInput:Alternatives[Null, {}], ops:OptionsPattern[billPricingMatchQ]]:=True;

(*core function*)
billPricingMatchQ[bills:{ObjectP[Object[Bill]] ..}, ops:OptionsPattern[billPricingMatchQ]]:=Module[
	{
		safeOps, verbose, createTask, billDownloadFields, pricingPackets, billPackets, financingTeams,
		allBills, allPricingModels, teamNames, billTuples, pricingTuples, misMatchedFields,
		allBillStatus, composedTuples, results
	},

	(* -- Download and setup -- *)

	(*add status to the download packet fields so we can check if a bill is Open*)
	billDownloadFields=Packet[Sequence @@ (Append[$SharedPricingFields, Status])];

	(*get packets for the bill, and Model[Pricing] and the financing team name*)
	{pricingPackets, billPackets, financingTeams}=Transpose[
		Download[
			bills,
			{
				Packet[PricingScheme[$SharedPricingFields]],
				billDownloadFields,
				Organization[Name]
			}
		]
	];

	(*look up the safe options*)
	safeOps=SafeOptions[billPricingMatchQ, ToList[ops]];
	{verbose, createTask}=Lookup[safeOps, {Verbose, CreateTask}];

	(*get the information we want to display to make the task easy to act on*)
	allBillStatus=Lookup[billPackets, Status];
	allBills=Lookup[billPackets, Object];
	allPricingModels=Lookup[pricingPackets, Object];
	teamNames=If[MatchQ[#,_String], #, ToString[#]]&/@financingTeams;

	(*do the big lookup outside of the map - strip links so that MatchQ will work*)
	billTuples=Lookup[billPackets, $SharedPricingFields] /. x:LinkP[] :> Download[x, Object];
	pricingTuples=Lookup[pricingPackets, $SharedPricingFields] /. x:LinkP[] :> Download[x, Object];

	(* -- early warnings -- *)

	(*throw a warning for non-open bills*)
	If[MatchQ[Cases[allBillStatus, Except[Open]], Except[{}]],
		Message[billPricingMatchQ::BillNotOpen, PickList[allBills, allBillStatus, Except[Open]]]
	];

	(* -- check for field mismatches -- *)
	misMatchedFields=MapThread[
		Function[
			{billValues, pricingValues, field, status},

			(* do a quick up front check to look if everything is the same, if not then check each element *)
			(*also dont check if there is an non open bill since it wont make sense to check that anyway*)
			If[Or[MatchQ[billValues, pricingValues], MatchQ[status, Except[Open]]],
				{},
				PickList[field, MapThread[MatchQ[#1, #2] &, {billValues, pricingValues}], False]
			]
		],
		{billTuples, pricingTuples, ConstantArray[$SharedPricingFields, Length[allBillStatus]], allBillStatus}
	];

	(*if there are no bad fields, short circuit to the end*)
	If[MatchQ[Flatten[misMatchedFields], {}],
		Return[True]
	];

	(* -- generate the task -- *)

	(*get the tuples together to send the task*)
	composedTuples=Cases[
		Transpose[{misMatchedFields, teamNames, allBills, allPricingModels}], {Except[{}], ___}
	];

	(*get the boolean results for "verbose" output*)
	results=Replace[misMatchedFields, {{} -> True, Except[{}] -> False}, 1];

	(* generate the tasks if we are doing that*)
	If[TrueQ[createTask],
		Map[
			CreateTask[
				Association[
					Name -> StringJoin["Bill/PricingModel mismatch for: ", ToString[#[[2]]]],
					Notes -> StringJoin["To pricing model (", ToString[#[[4]]] , ") is not consistent with the current Bill (", ToString[#[[3]]], "). The following fields are mismatched: ", ToString[#[[1]]]],
					Projects -> {"Billing & Invoicing"},
					Sections -> {"P5 - Code"},
					Tags -> {"P5"}
				]
			] &,
			composedTuples
		]
	];

	(*if the verbose option is on, print some additional information, other wise just print results*)
	Switch[verbose,
		(False | Null),
		Nothing,

		Failures,
		Print[Transpose[{composedTuples[[All, 2]], composedTuples[[All, 3]], composedTuples[[All, 1]], ConstantArray[False, Length[composedTuples]]}]],

		True,
		Print[Transpose[{allBills, teamNames, results}]]
	];

	(*if we've gotten this far, we need to return False*)
	False
];