(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotTADM*)


DefineOptions[PlotTADM,
	Options:>{
		{
			OptionName -> Index,
			Default -> All,
			Description -> "Indicates which index in the manipulations should be displayed.",
			AllowNull -> True,
			Widget -> Alternatives[
				"All"->Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[All]
				],
				"Single index"->Widget[
					Type -> Number,
					Pattern :> GreaterP[0,1]
				],
				"Multiple indices"->Adder[
					Widget[
						Type -> Number,
						Pattern :> GreaterP[0,1]
					]
				]
			]
		},
		{
			OptionName -> Destination,
			Default -> All,
			Description -> "Only display TADM traces for the specified destination well.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Alternatives[
				"All"->Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[All]
				],
				"Container well" -> {
					"Well"->Widget[Type -> String, Pattern :> WellP, Size ->Word],
					"Container"->Widget[Type -> Object, Pattern :> ObjectP[{Object[Container]}], ObjectTypes -> {Object[Container]}]
				}
			]
		},
		{
			OptionName -> Source,
			Default -> All,
			Description -> "Only display TADM traces for the specified source well.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Alternatives[
				"All"->Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[All]
				],
				"Container well" -> {
					"Well"->Widget[Type -> String, Pattern :> WellP, Size ->Word],
					"Container"->Widget[Type -> Object, Pattern :> ObjectP[{Object[Container]}], ObjectTypes -> {Object[Container]}]
				},
				"Sample"-> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample]}], ObjectTypes -> {Object[Sample]}]
			]
		},
		{
			OptionName -> Labels,
			Default -> False,
			Description -> "Display the labels instead of the container objects.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> Protocol,
			Default -> Null,
			Description -> "Denotes a protocol this plotting is a part of (used for passing which protocol RoboticUnitOperation belongs to since the object does not have such reference).",
			AllowNull -> False,
			Category -> "Hidden",
			Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol]]]
		},
		OutputOption
	}
];


(* The purpose of this plot function is to help pinpoint which transfers may be failing in microSM and RoboticSamplePreparation *)
(* or verify that the correct transfers were performed in the event of downstream issues in the experiment workflow *)
(* therefore we should be able to clearly display all transfers with the source/destination clearly labeled *)
(* and should also allow the user to quickly look at a specific source or destination if they suspect it is an issue *)
(* for backwards compatibility, we are going to support SM as well as RSP *)

(*add option for channel and for source/destination*)

PlotTADM::IndexContainerConflict = "Index and Sources/Destinations options cannot be specified together. Please use Index to specify an index in the manipulations and Sources/Destinations to select a particular set of transfers.";
PlotTADM::DestinationsSourcesConflict = "Please only inform either Destinations or Sources.";
PlotTADM::InvalidSourceOptionForSampleManipulation = "Only use Object[Sample] as input to the Source option when calling PlotTADM on an Object[Protocol, SampleManipulation]";
PlotTADM::FieldLengthMismatch = "The unit operations could not be analyzed due to mismatched field lengths.";
PlotTADM::NoData = "No pressure data matches the option input. Verify the requested source, destination, index and if the manipulation has completed.";

Authors[PlotTADM]:={"alou", "robert"};

(* ------------------------------------------------ *)
(* -- Object[Protocol, SampleManipulation] input -- *)
(* ------------------------------------------------ *)


(* core function for SM legacy support *)
PlotTADM[protocol:ObjectP[Object[Protocol, SampleManipulation]], ops:OptionsPattern[]]:= Module[
	{safeOps, requestedIndices, requestedDestinations, requestedSources,safeRequestedIndices, defaultPattern, selectedTransfers, transfers, destinationTransferBool, sourceTransferBool,
		allAspirationData, allDispenseData, aspirationPlots, dispensePlots, destinations, sources, output, finalPlot},

	(* -- set up and download -- *)
	(* get the safe options and pull out the OutputFormat option *)
	safeOps=ECL`OptionsHandling`SafeOptions[PlotTADM, ToList[ops]];
	{requestedIndices, requestedDestinations, requestedSources, output}=Lookup[safeOps, {Index, Destination, Source, Output}];
	safeRequestedIndices = requestedIndices/.x_Integer:>{x};
	defaultPattern = (All|Null);

	(* check that only one of the options is specified *)
	Switch[
		{safeRequestedIndices, requestedDestinations, requestedSources},

		{Except[defaultPattern], Except[defaultPattern],_}|{Except[defaultPattern], _,Except[defaultPattern]},
		Message[PlotTADM::IndexContainerConflict];
		Return[$Failed],

		{_, Except[defaultPattern], Except[defaultPattern]},
		Message[PlotTADM::DestinationsSourcesConflict];
		Return[$Failed]
	];

	(* disallow {position, container} format for old transfers since these were formatted differently *)
	If[MatchQ[requestedSources, {_String, ObjectP[]}],
		Message[PlotTADM::InvalidSourceOptionForSampleManipulation];
		Return[$Failed]
	];


	(* download *)
	transfers = Cases[Download[protocol, ResolvedManipulations], _Transfer];

	(* -- extract traces -- *)

	(* Get the positions of relevant transfer in all transfers *)
	destinationTransferBool = If[MatchQ[requestedDestinations, Except[defaultPattern]],
		Map[
			Map[
				Function[
					target,
					MatchQ[Download[target[[1]],Object],Download[requestedDestinations[[2]],Object]]&&MatchQ[target[[2]],requestedDestinations[[1]]]
				],
				Flatten[#,1]
			]&,
			Lookup[transfers[[All,1]], Destination]
		],
		(* just return a safe value for error checking *)
		{True}
	];

	(* Get the positions of relevant transfer in all transfers *)
	sourceTransferBool = If[MatchQ[requestedSources, Except[defaultPattern]],
		Map[
			Map[
				Function[
					target,
					MatchQ[Download[target,Object],Download[requestedSources,Object]]
				],
				Flatten[#,1]
			]&,
			Lookup[transfers[[All,1]], Source]
		],
		(* just return a safe value for error checking *)
		{True}
	];

	(* -- error checking -- *)
	(*TODO: Update for actual messages*)
	(* return an message if the destination does not exist in primitives *)
	If[
		Count[Flatten[destinationTransferBool], True]==0,
		Return[StringJoin["The destination {",requestedDestinations[[1]],",",ToString[Download[requestedDestinations[[2]],Object]], "} does not exist in the Transfer primitives."]]
	];

	If[
		Count[Flatten[sourceTransferBool], True]==0,
		Return[StringJoin["The source {",requestedSources[[1]],",",ToString[Download[requestedSources[[2]],Object]], "} does not exist in the Transfer primitives."]]
	];

	(* if a bad element is requested, send it to the other overload *)
	If[
		!MatchQ[Max[requestedIndices/.(All|None)->{1}], RangeP[1,Length[transfers]]],
		Return[StringJoin["The index ", ToString[requestedIndices], " is larger than the number of Transfer primitives: ", ToString[Length[transfers]]]]
	];

	(* get teh transfer of interest from the options *)
	selectedTransfers = Which[

		(* we have requested destinations *)
		MatchQ[requestedDestinations, Except[defaultPattern]],
		MapThread[
			Function[{primitive, keepBool},
				KeyValueMap[
					Function[{key, values},
						key-> PickList[values, keepBool]],
					primitive
				]
			],
			{transfers[[All,1]], destinationTransferBool}
		],

		(* we have requested destinations *)
		MatchQ[requestedSources, Except[defaultPattern]],
		MapThread[
			Function[{primitive, keepBool},
				KeyValueMap[
					Function[{key, values},
						key-> PickList[values, keepBool]],
					primitive
				]
			],
			{transfers[[All,1]], sourceTransferBool}
		],

		(* we have requested indices *)
		MatchQ[safeRequestedIndices, Except[defaultPattern]],
		(* pull out the elements of interest *)
		transfers[[safeRequestedIndices]][[All,1]],

		(* all options are defaulted *)
		True,
		transfers[[All,1]]
	];

	(* extract the aspiration, dispense, source, and destination *)
	allAspirationData = Lookup[selectedTransfers, AspirationPressure, Null];
	allDispenseData = Lookup[selectedTransfers, DispensePressure, Null];
	sources = Lookup[selectedTransfers, Source];
	destinations = Lookup[selectedTransfers, Destination];

	(* -- error for missing data -- *)
	(* check both just in case we had a weird parsing issue. Also check that there is data*)
	If[Or[
		MatchQ[allAspirationData, Alternatives[{({}|Null)...}|Null]],
		MatchQ[allDispenseData, Alternatives[{({}|Null)...}|Null]],
		MatchQ[selectedTransfers, {}]
	],
		Message[PlotTADM::NoData];
		Return[$Failed]
	];

	(* -- generate plots -- *)
	aspirationPlots = MapThread[EmeraldListLinePlot[#1, Legend -> ToString/@#2]&, {allAspirationData, sources}];
	dispensePlots = MapThread[EmeraldListLinePlot[#1, Legend -> ToString/@#2]&, {allDispenseData, destinations}];

	(* plottable *)
	finalPlot=Zoomable[PlotTable[Transpose[{aspirationPlots, dispensePlots}], TableHeadings ->{Range[Length[aspirationPlots]],{"Aspiration Trace","Dispense Trace"}}]];

	(* Return the requested outputs *)
	output/.{
		Result->finalPlot,
		(*there is currently no option resolution*)
		Options->safeOps,
		Preview->finalPlot,
		Tests->{}
	}
];

(* ------------------ *)
(* -- RSP Overload -- *)
(* ------------------ *)

PlotTADM[protocol:ObjectP[Object[Protocol, RoboticSamplePreparation]], ops:OptionsPattern[]]:= Module[
	{allTransfers},

	(* find any transfer unit operations *)
	Block[{$UnitOperationBlobs=False},
		allTransfers = Cases[Download[protocol, OutputUnitOperations], ObjectP[{Object[UnitOperation, Transfer], Object[UnitOperation, Aliquot], Object[UnitOperation, MagneticBeadSeparation]}]];

		(* if there are no transfers for some reason, stop now *)
		If[MatchQ[Length[allTransfers], GreaterP[0]],

			(*check if this is an aliquot or a magnetic bead separation - if it is the actual Transfer UO is another layer deep in the RoboticUnitOperations field*)
			If[MatchQ[allTransfers, {ObjectP[{Object[UnitOperation,Aliquot], Object[UnitOperation, MagneticBeadSeparation]}]}],
				PlotTADM[Cases[Download[allTransfers[[1]], RoboticUnitOperations], ObjectP[{Object[UnitOperation, Transfer]}]][[1]], Append[ToList@ops,Protocol->protocol]],
				PlotTADM[allTransfers[[1]], Append[ToList@ops,Protocol->protocol]]
			],
			Null
		]
	]
];

(* ---------------------- *)
(* -- Aliquot Overload -- *)
(* ---------------------- *)

PlotTADM[protocol:ObjectP[Object[UnitOperation, Aliquot]], ops:OptionsPattern[]]:= Module[
	{allTransfers},

	(* find any transfer unit operations *)
	Block[{$UnitOperationBlobs=False},
		allTransfers = Cases[Download[protocol, RoboticUnitOperations], ObjectP[Object[UnitOperation, Transfer]]];

		(* if there are no transfers for some reason, stop now *)
		If[MatchQ[Length[allTransfers], GreaterP[0]],
			PlotTADM[allTransfers[[1]], ops],
			Null
		]
	]
];


(* --------------------------------------- *)
(* -- core function for unit operations -- *)
(* --------------------------------------- *)

(* TODO: this needs to be listable because there are multiple transfers that might occur in an RSP!  *)
(* core function to view all traces *)
PlotTADM[unitOperation:ObjectP[{Object[UnitOperation, Transfer]}], ops:OptionsPattern[]]:= Module[
	{
		safeOps, requestedIndices, requestedDestinations, requestedSources,safeRequestedIndices, defaultPattern,
		aspirationPressure, dispensePressure, sourceLink, destinationLink, sourceWell, destinationWell, amount,
		selectedAspirationPressure, selectedDispensePressure, selectedSourceLink, selectedDestinationLink,
		selectedSourceWell, selectedDestinationWell, selectedAmount, labeledObjects,
		tuples,destinationTransferPositions, sourceTransferPositions, selectedTuples,
		aspirationPlots, dispensePlots, finalPlot, output, protocol, labels, labelLookup,
		sourceColumn,destinationColumn
	},

	Block[{$UnitOperationBlobs=False},

		(* -- set up and download -- *)
		(* get the safe options and pull out the OutputFormat option *)
		safeOps=ECL`OptionsHandling`SafeOptions[PlotTADM,ToList[ops]];
		{requestedIndices,requestedDestinations,requestedSources,output,protocol,labels}=ReplaceAll[
			Lookup[safeOps,{Index,Destination,Source,Output,Protocol,Labels}],
			x:ObjectP[]:>Download[x,Object]
		];
		safeRequestedIndices=requestedIndices/.x_Integer:>{x};
		defaultPattern=(All | Null);

		(* check that only one of the options is specified *)
		Switch[
			{safeRequestedIndices, requestedDestinations, requestedSources},

			(* if both the index and either source/destination is informed, error *)
			{Except[defaultPattern], Except[defaultPattern],_}|{Except[defaultPattern], _,Except[defaultPattern]},
			Message[PlotTADM::IndexContainerConflict];
			Return[$Failed],

			(* if both source and destination are informed, error *)
			{_,Except[defaultPattern],Except[defaultPattern]},
			Message[PlotTADM::DestinationsSourcesConflict];
			Return[$Failed]
		];

		(* disallow sample format for new transfers since these are formatted differently *)
		If[MatchQ[requestedSources, ObjectP[Object[Sample]]],
			Message[PlotTADM::InvalidSourceOptionForSampleManipulation];
			Return[$Failed]
		];

		(*should we have optional display of pipetting parameters as well?*)
		(* download the things AspirationPressure, DispensePressure, SourceLink, DestinationLink, SourceWell, DestinationWell, AmountVariableUnit*)
		{
			{{
				aspirationPressure,
				dispensePressure,
				sourceLink,
				destinationLink,
				sourceWell,
				destinationWell,
				amount
			}},
			labeledObjects
		}=Download[
			{
				{unitOperation},
				{protocol}
			},
			{
				{
					AspirationPressure,
					DispensePressure,
					SourceLink,
					DestinationLink,
					SourceWell,
					DestinationWell,
					AmountVariableUnit
				},
				{LabeledObjects}
			}
		];
		labelLookup=If[MatchQ[labeledObjects,{}|{Null}],
			<||>,
			Rule@@@Reverse/@ReplaceAll[Flatten[labeledObjects,2],x:LinkP[]:>Download[x,Object]]
			];

		(* if there is no data, return early *)
		If[Or[MatchQ[aspirationPressure, {}], MatchQ[dispensePressure, {}]],
			Return[Null]
		];

		(* if any of the lengths dont match here, we cant continue *)
		If[!MatchQ[Length[DeleteDuplicates[Length/@{aspirationPressure, dispensePressure, sourceLink, destinationLink, sourceWell, destinationWell, amount}]],1],
			Message[PlotTADM::FieldLengthMismatch];
			Return[$Failed]
		];

		(* make tuples for easier handling later *)
		tuples = {aspirationPressure, dispensePressure, sourceLink/.x:ObjectP[]:>Download[x, Object], destinationLink/.x:ObjectP[]:>Download[x, Object], sourceWell, destinationWell, amount};

		(* -- extract traces -- *)

		(* Get the positions of relevant transfer in all transfers - DestinationWell and DestinationLink must match input. just return somethign safe if we dont have a destination informed*)
		destinationTransferPositions = If[MatchQ[requestedDestinations, defaultPattern],
			{},
			Flatten[Position[Transpose[{destinationWell, Download[destinationLink, Object]}], {requestedDestinations[[1]], Download[requestedDestinations[[2]],Object]}]]
		];

		(* Get the positions of relevant transfer in all transfers - SourceWell and SourceLink must match input. just return something safe if we dont have a destination informed*)
		sourceTransferPositions = If[MatchQ[requestedSources, defaultPattern],
			{},
			Flatten[Position[Transpose[{sourceWell, Download[sourceLink, Object]}], {requestedSources[[1]], Download[requestedSources[[2]],Object]}]]
		];

		(* -- error checking -- *)

		(* return an message if the destination does not exist in primitives *)
		If[
			MatchQ[destinationTransferPositions, {}]&&!MatchQ[requestedDestinations, defaultPattern],
			Return[StringJoin["The destination {",requestedDestinations[[1]],",",ToString[Download[requestedDestinations[[2]],Object]], "} does not exist in the Transfer unit operations."]]
		];

		(* return an message if the source does not exist in primitives *)
		If[
			MatchQ[sourceTransferPositions, {}]&&!MatchQ[requestedSources, defaultPattern],
			Return[StringJoin["The source {",requestedSources[[1]],",",ToString[Download[requestedSources[[2]],Object]], "} does not exist in the Transfer unit operations."]]
		];

		(* if a bad element is requested, send it to the other overload *)
		If[
			!MatchQ[Max[requestedIndices/.(All|None)->{1}], RangeP[1,Length[aspirationPressure]]],
			Return[StringJoin["The index ", ToString[requestedIndices], " is larger than the number of Transfer primitives: ", ToString[Length[aspirationPressure]]]]
		];

		(* get teh transfer of interest from the options *)
		selectedTuples = Which[

			(* we have requested destinations *)
			MatchQ[requestedDestinations, Except[defaultPattern]],
			tuples[[All,destinationTransferPositions]],

			(* we have requested destinations *)
			MatchQ[requestedSources, Except[defaultPattern]],
			tuples[[All,sourceTransferPositions]],

			(* we have requested indices *)
			MatchQ[safeRequestedIndices, Except[defaultPattern]],
			(* pull out the elements of interest *)
			tuples[[All,safeRequestedIndices]],

			(* all options are defaulted *)
			True,
			tuples
		];

		(* extract the aspiration, dispense, source, and destination etc *)
		{selectedAspirationPressure, selectedDispensePressure, selectedSourceLink, selectedDestinationLink, selectedSourceWell, selectedDestinationWell, selectedAmount} = selectedTuples;

		(* -- generate plots -- *)
		aspirationPlots = Map[EmeraldListLinePlot[#]&,selectedAspirationPressure];
		dispensePlots = Map[EmeraldListLinePlot[#]&,selectedDispensePressure];

		sourceColumn = With[{source=Download[selectedSourceLink,Object]},
			If[labels,
				(* if for some reason we can't find `source` in the lookup table, just show the `source` *)
				Map[Lookup[labelLookup,#,#]&,source],
				source
			]
		];
		destinationColumn = With[{destination=Download[selectedDestinationLink,Object]},
			If[labels,
				(* if for some reason we can't find `source` in the lookup table, just show the `source` *)
				Map[Lookup[labelLookup,#,#]&,destination],
				destination
			]
		];
		(* plottable *)
		finalPlot= Zoomable[
			PlotTable[
				Transpose[
					{
						Transpose[{selectedSourceWell,sourceColumn}],
						Transpose[{selectedDestinationWell,destinationColumn}],
						selectedAmount,
						aspirationPlots,
						dispensePlots
					}
				],
				TableHeadings->{Range[Length[aspirationPlots]],{"Source","Destination","Amount","Aspiration Trace","Dispense Trace"}}
			]
		];

		(* Return the requested outputs *)
		output/.{
			Result->finalPlot,
			(*there is currently no option resolution*)
			Options->safeOps,
			Preview->finalPlot,
			Tests->{}
		}
	]
];