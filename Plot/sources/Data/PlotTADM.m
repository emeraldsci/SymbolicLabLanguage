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
			Category -> "General",
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
			Pattern :> Alternatives[
				All,
				{WellP, ObjectP[Object[Container]]}
			]
		},
		{
			OptionName -> Source,
			Default -> All,
			Description -> "Only display TADM traces for the specified source well.",
			AllowNull -> False,
			Category -> "General",
			Pattern :> Alternatives[
				All,
				ObjectP[Object[Sample]],
				ObjectP[Object[Container]],
				{WellP, ObjectP[Object[Container]]}
			]
		},
		ModifyOptions[EmeraldListLinePlot, {ImageSize}],
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
PlotTADM::NoData = "No pressure data available to plot. Verify the requested protocol has completed and that the transfer unit operations have AspirationPressure and DispensePressure values.";
PlotTADM::ValueNotFound = "The `1`, {`2`}, cannot be found in the Transfer unit operations for this protocol.";
PlotTADM::IndexOutOfRange = "The requested indices {`1`} are higher than the total number of transfers: `2`";


(* ------------------------------------------------ *)
(* -- Object[Protocol, SampleManipulation] input -- *)
(* ------------------------------------------------ *)


(* core function for SM legacy support *)
PlotTADM[protocol:ObjectP[Object[Protocol, SampleManipulation]], ops:OptionsPattern[PlotTADM]]:= Module[
	{safeOps, requestedIndices, requestedDestinations, requestedSources,safeRequestedIndices, defaultPattern, selectedTransfers, transfers, destinationTransferBool, sourceTransferBool, imageSize,
		allAspirationData, allDispenseData, aspirationPlots, dispensePlots, destinations, sources, output, finalPlot},

	(* -- set up and download -- *)
	(* get the safe options and pull out the OutputFormat option *)
	safeOps=ECL`OptionsHandling`SafeOptions[PlotTADM, ToList[ops]];
	{requestedIndices, requestedDestinations, requestedSources, output, imageSize}=Lookup[safeOps, {Index, Destination, Source, Output, ImageSize}];
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

	(* get the transfer of interest from the options *)
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
	aspirationPlots = MapThread[EmeraldListLinePlot[#1, Legend -> ToString/@#2, ImageSize -> imageSize]&, {allAspirationData, sources}];
	dispensePlots = MapThread[EmeraldListLinePlot[#1, Legend -> ToString/@#2, ImageSize -> imageSize]&, {allDispenseData, destinations}];

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


(* --------------------------------------- *)
(* -- core function for RSPs -- *)
(* --------------------------------------- *)

(* core function to view all traces *)
PlotTADM[protocol:ObjectP[Object[Protocol, RoboticSamplePreparation]], ops:OptionsPattern[PlotTADM]]:= Module[
	{
		safeOps, requestedIndices, requestedDestinations, requestedSources,safeRequestedIndices, defaultPattern,
		aspirationPressure, dispensePressure, sourceSample, destinationSample, sourceWell, destinationWell, amount,
		sourceContainer, destinationContainer, parentUO, childUO, sourceLabel, sourceContainerLabel,
		destinationLabel, destinationContainerLabel, groupedSelectedData, groupedPartedSelectedData, plotsTables,
		allDataList, destinationTransferPositions, sourceTransferPositions, selectedData, imageSize, containerToModelRules,
		iconFileRules, iconRules, output, allTransferPackets, aspirationErrorMessage, aspirationDate, dispenseDate,
		dispenseErrorMessage, parentUOPackets, childUOPackets, allUOPackets, playButton, streamPackets,
		helpButtonGraphic, helpFileObject, helpFileButton, sourceContainerModels, destinationContainerModels,
		subSourceContainerModels, subDestinationContainerModels, containerToModelList, zoomBool
	},

	(* -- set up and download -- *)
	(* get the safe options *)
	safeOps=ECL`OptionsHandling`SafeOptions[PlotTADM,ToList[ops]];

	(* pull out all the options *)
	{requestedIndices, requestedDestinations, requestedSources, output, imageSize}=ReplaceAll[
		Lookup[safeOps, {Index, Destination, Source, Output, ImageSize}],
		x:ObjectP[]:>Download[x,Object]
	];

	(* Make sure we have a list of indices *)
	safeRequestedIndices=If[MatchQ[requestedIndices, _Integer], ToList[requestedIndices], requestedIndices];

	(* Default for when it comes up *)
	defaultPattern=(All | Null);

	(* Exit if our protocol is not real *)
	If[!DatabaseMemberQ[protocol],
		Message[Error::ObjectDoesNotExist, ECL`InternalUpload`ObjectToString[protocol]];
		Return[$Failed]
	];

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


	(* download the things AspirationPressure, DispensePressure, SourceLink, DestinationLink, SourceWell, DestinationWell, AmountVariableUnit*)
	{
		streamPackets,
		parentUOPackets,
		childUOPackets,
		sourceContainerModels,
		destinationContainerModels,
		subSourceContainerModels,
		subDestinationContainerModels
	}=Quiet[
		Download[
			protocol,
			{
				Packet[Streams][VideoFile, StartTime, EndTime],
				Packet[OutputUnitOperations][
					SourceLink,
					SourceLabel,
					SourceWell,
					SourceContainer,
					SourceContainerLabel,

					DestinationLink,
					DestinationLabel,
					DestinationWell,
					DestinationContainer,
					DestinationContainerLabel,

					AmountVariableUnit,

					AspirationPressure,
					DispensePressure,

					AspirationErrorMessage,
					DispenseErrorMessage,

					AspirationDate,
					DispenseDate
				],
				Packet[OutputUnitOperations][RoboticUnitOperations][
					SourceLink,
					SourceLabel,
					SourceWell,
					SourceContainer,
					SourceContainerLabel,

					DestinationLink,
					DestinationLabel,
					DestinationWell,
					DestinationContainer,
					DestinationContainerLabel,

					AmountVariableUnit,

					AspirationPressure,
					DispensePressure,

					AspirationErrorMessage,
					DispenseErrorMessage,

					AspirationDate,
					DispenseDate
				],
				OutputUnitOperations[SourceContainer][{Object, Model[Object], Model[Name]}],
				OutputUnitOperations[DestinationContainer][{Object, Model[Object], Model[Name]}],
				OutputUnitOperations[RoboticUnitOperations][SourceContainer][{Object, Model[Object], Model[Name]}],
				OutputUnitOperations[RoboticUnitOperations][DestinationContainer][{Object, Model[Object], Model[Name]}]
			}
		],
		{Download::FieldDoesntExist}
	];


	(* clean up and combine the lists into a single one so we can create rules in the next few lines *)
	(*containerToModelList = DeleteDuplicates[
		Flatten[
			DeleteCases[{sourceContainerModels, destinationContainerModels, subSourceContainerModels, subDestinationContainerModels}, $Failed, Infinity],
			3
		]
	];*)

	(* compile a set of rules to easily convert container object to its named model *)
	(*containerToModelRules = Map[
		(#[[1]] -> ReplacePart[#[[2]], -1 -> #[[3]]])&,
		containerToModelList
	];*)

	(* Assemble a giant list of UO packets; if we have sub-UOs, we take those *)
	allUOPackets=Flatten[MapThread[
		Function[{singleParent, singleChild},
			If[MatchQ[singleChild, {}],
				Join[
					singleParent,
					<|
						"Parent UO"->ConstantArray[Lookup[singleParent, Object], Length[Lookup[singleParent, SourceLink]]],
						"Child UO"->ConstantArray[Lookup[singleParent, Object], Length[Lookup[singleParent, SourceLink]]]
					|>
				],
				Join[
					#,
					<|
						"Parent UO"->ConstantArray[Lookup[singleParent, Object], Length[Lookup[#, SourceLink]]],
						"Child UO"->ConstantArray[Lookup[#, Object], Length[Lookup[#, SourceLink]]]
					|>
				]&/@singleChild
			]
		],
		{parentUOPackets, childUOPackets}
	]];

	(* Now let's isolate all the transfers *)
	allTransferPackets=Cases[allUOPackets, PacketP[Object[UnitOperation, Transfer]]];

	(* If no transfer packets are found, we need to exit *)
	If[Length[allTransferPackets]==0,
		Message[PlotTADM::NoData];
		Return[$Failed]
	];


	(* Create flat list of every value that we've downloaded *)
	{

		sourceSample,
		sourceLabel,
		sourceWell,
		sourceContainer,
		sourceContainerLabel,

		destinationSample,
		destinationLabel,
		destinationWell,
		destinationContainer,
		destinationContainerLabel,

		amount,

		parentUO,
		childUO,

		aspirationPressure,
		dispensePressure,

		aspirationErrorMessage,
		dispenseErrorMessage,

		aspirationDate,
		dispenseDate
	}=Flatten[#, 1]&/@Transpose[Lookup[allTransferPackets,
		{
			SourceLink,
			SourceLabel,
			SourceWell,
			SourceContainer,
			SourceContainerLabel,

			DestinationLink,
			DestinationLabel,
			DestinationWell,
			DestinationContainer,
			DestinationContainerLabel,

			AmountVariableUnit,

			"Parent UO",
			"Child UO",

			AspirationPressure,
			DispensePressure,

			AspirationErrorMessage,
			DispenseErrorMessage,

			AspirationDate,
			DispenseDate
		}
	]];

	(* if there is no data, return early *)
	If[Or[MatchQ[aspirationPressure, {}|NullP], MatchQ[dispensePressure, {}|NullP]],
		Message[PlotTADM::NoData];
		Return[$Failed]
	];


	(* Create a mega list with indices so we can easily filter/select data *)
	allDataList = Transpose[{
		(* 1*) Range[Length[sourceSample]],

		(* 2*) Download[sourceSample, Object],
		(* 3*) sourceLabel,
		(* 4*) Transpose[{sourceWell, Download[sourceContainer, Object]}],
		(* 5*) Transpose[{sourceWell, sourceContainerLabel}],

		(* 6*) Download[destinationSample, Object],
		(* 7*) destinationLabel,
		(* 8*) Transpose[{destinationWell, Download[destinationContainer, Object]}],
		(* 9*) Transpose[{destinationWell, destinationContainerLabel}],

		(*10*) amount,

		(*11*) parentUO,
		(*12*) childUO,

		(*13*) aspirationPressure,
		(*14*) dispensePressure,

		(*15*) aspirationErrorMessage,
		(*16*) dispenseErrorMessage,

		(*17*) aspirationDate,
		(*18*) dispenseDate
	}];

	(* -- extract traces -- *)

	(* Get the indices of the user-requested destination - this can only be in {well, container} format *)
	destinationTransferPositions = If[MatchQ[requestedDestinations, defaultPattern],
		{},
		Flatten[
			Position[
				allDataList[[All, 8]],
				{requestedDestinations[[1]], Download[requestedDestinations[[2]], Object]}
			]
		]
	];

	(* Get the indices of the user-requested source - this can either be sample or {well, container} format *)
	sourceTransferPositions = Switch[requestedSources,
		(* handle single sample *)
		ObjectP[Object[Sample]],
			Flatten[
				Position[allDataList[[All, 2]], Download[requestedSources, Object]]
			],
		(* handle single container *)
		ObjectP[Object[Container]],
			Flatten[
				Position[allDataList[[All, 4]], {_, Download[requestedSources, Object]}]
			],
		(* handle well, container objects *)
		{_String, ObjectP[Object[Container]]},
			Flatten[
				Position[
					allDataList[[All, 4]],
					{requestedSources[[1]], Download[requestedSources[[2]], Object]}
				]
			],
		(* when it's default, we don't have any indices *)
		_, {}
	];

	(* -- error checking -- *)
	(* These should probably throw an actual error *)
	(* return an message if the destination does not exist in primitives *)
	If[
		MatchQ[destinationTransferPositions, {}]&&!MatchQ[requestedDestinations, defaultPattern],
		Message[PlotTADM::ValueNotFound, "destination", ECL`InternalUpload`ObjectToString[requestedDestinations[[1]]]];
		Return[$Failed]
	];

	(* return an message if the source does not exist in primitives *)
	If[
		MatchQ[sourceTransferPositions, {}]&&!MatchQ[requestedSources, defaultPattern],
		Module[{returnOutput},
			(* When the source is a single object, we can just print that, but it can also be {position, container} *)
			returnOutput = If[
				MatchQ[requestedSources, ObjectP[{Object[Sample], Object[Container]}]],
				ECL`InternalUpload`ObjectToString[Download[requestedSources, Object]],
				StringJoin[requestedSources[[1]],",",ECL`InternalUpload`ObjectToString[Download[requestedSources[[2]],Object]]]
			];
			(* Return the error string *)
			Message[PlotTADM::ValueNotFound, "source", returnOutput];
			Return[$Failed]
		]
	];

	(* if a bad element is requested, send it to the other overload *)
	If[
		Nor[
			MatchQ[safeRequestedIndices, All],
			Max[safeRequestedIndices]<=Length[allDataList]
		],
		Message[PlotTADM::IndexOutOfRange, ToString[Select[safeRequestedIndices, #>Length[allDataList]&]], ToString[Length[allDataList]]];
		Return[$Failed]
	];

	(* get the transfer of interest from the options *)
	selectedData = Which[

		(* we have requested destinations *)
		Length[destinationTransferPositions]>0,
			allDataList[[destinationTransferPositions]],

		(* we have requested sources *)
		Length[sourceTransferPositions]>0,
		allDataList[[sourceTransferPositions]],

		(* we have requested indices *)
		MatchQ[safeRequestedIndices, {_Integer..}],
			(* pull out the elements of interest *)
			allDataList[[safeRequestedIndices]],

		(* all options are defaulted *)
		True,
			allDataList
	];


	(*-- Get the data ready to generate the display --*)
	(* Group the selected data by the parent UO *)
	groupedSelectedData = GroupBy[selectedData, #[[11]]&];

	(* For each group, partition the data into groups of max 5 transfers *)
	groupedPartedSelectedData = Map[Partition[#, UpTo[5]]&, groupedSelectedData];

	(*-- Get our buttons and images ready to be used in the final display --*)
	(*- Icons -*)
	(* Set rules to get the unit operation icons for each unit operation type - these will be used as labels in TabView *)
	iconFileRules = {
		Object[UnitOperation, Transfer] -> "TransferIcon.png",
		Object[UnitOperation, Aliquot] -> "AliquotIcon.png",
		Object[UnitOperation, MagneticBeadSeparation] -> "MoveToMagnetIcon.png",
		Object[UnitOperation, Filter] -> "FilterIcon.png",
		Object[UnitOperation, Dilute] -> "AliquotIcon.png",
		Object[UnitOperation, SerialDilute] -> "AliquotIcon.png",
		Object[UnitOperation, Consolidate] -> "ConsolidateIcon.png",
		Object[UnitOperation, Resuspend] -> "ResuspendIcon.png",
		Object[UnitOperation, Pellet] -> "Pellet.png",
		Object[UnitOperation, LiquidLiquidExtraction] -> "LiquidLiquidExtraction.png",
		Object[UnitOperation, SolidPhaseExtraction] -> "SolidPhaseExtraction.png"
	};


	(* Import the images and replace the values *)
	iconRules = Keys[#] -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", Values[#]}]]& /@ iconFileRules;

	(*- Play button -*)
	(* Create a play button graphic *)
	playButton = Graphics[
		{
			(* Set some transparency so the image can be seen through the graphic *)
			Opacity[0.7],
			(* Ccreate the circle using ECL approved gray *)
			LCHColor[0.8, 0, 0], Disk[{1, 3.5}, 6],
			(* Next we put a white triangle on top *)
			LCHColor[1, 0, 0], Triangle[{{-0.5, 0}, {-0.5, 7}, {3.5, 3.5}}]
		},
		(* Scale the graphic to be 0.5x of the smaller image dimension *)
		ImageSize -> 15
	];

	(*- Help file button -*)
	(* Create the help button graphic *)
	helpButtonGraphic = Graphics[
		{
			LCHColor[0.6, 0, 0], Disk[{0, 0}, 1],
			White, Text[Style["?", Bold, 10], {-0.1, 0}]
		},
		ImageSize -> 16
	];

	(* Help file with TADM basics and possible errors *)
	helpFileObject = Object[EmeraldCloudFile, "Hamilton TADM Basics"];

	(* Create the button IF the above file exists, otherwise we don't have anything to display.
		This is a fallback in case the file name changes. Once the updates are on stable, we can hotfix the production version of the cloud file object *)
	helpFileButton = If[DatabaseMemberQ[helpFileObject],
		(* doing it this way so that the cloud file blob generation does not slow down the rending by front end *)
		With[{helpFileValue = helpFileObject},
			Button[
				Tooltip[helpButtonGraphic, "TADM guide"],
				OpenCloudFile[helpFileValue],
				Method -> "Queued",
				Appearance -> "Frameless"
			]
		],
		""
	];

	(* We cannot use zoomable on plots generated on Manifold, so here we figure out the value for Zoomable *)
	zoomBool = !TrueQ[ECL`$ManifoldRuntime];


	(* -- generate plots and tables -- *)
	(* Map over the selected data and create a table with information about the transfer and a TADM plot
		There are 3 levels of mapping. Starting from the outermost level:
		1. TabView requires Label -> SlideView of the information relevant to the parent UO. Each UO is represented by its icon and the index of the parent. Currently we only show the Transfer-relevant UOs along with their actual index in OutputUnitOperations.
		2. SlideView that contains 1 or more "slides" - grid of each partition. We can change the size of the partition when 'groupedPartedSelectedData' is set
		3. Grid of a partition - Each row of the grid contains {Transfer Index, Table with Source/Destination/Amount, Plot of TADM for that transfer}
	*)
	plotsTables = With[
		{
			groupedPartedSelectedData = groupedPartedSelectedData,
			parentUOPackets = parentUOPackets,
			helpFileButton = helpFileButton
		},
		(* 1. KeyValueMap *)
		TabView[KeyValueMap[
			Function[{singleGroupKey, singleGroupValue},
				Module[{parentIndex, tabGraphic, uoContentDescription, tadmSlideView},
					(* get the index of the parent unit operation *)
					parentIndex = First[FirstPosition[Lookup[parentUOPackets, Object], singleGroupKey]];

					(* tab graphic *)
					tabGraphic = Row[{
						Style[ToString[parentIndex]<>" ", 22, Bold, LCHColor[0.4, 0, 0], "Helvetica"],
						Lookup[parentUOPackets[[parentIndex]], Type] /. iconRules
					}, Alignment -> Bottom];

					(* content descriptor *)
					uoContentDescription = Style[
						StringJoin[
							"Information for OutputUnitOperations[[",
							ToString[parentIndex],
							"]] : ",
							ECL`InternalUpload`ObjectToString[singleGroupKey]
						],
						Bold,
						"Helvetica",
						LCHColor[0.4, 0, 0]
					];

					(* SlideView content generation by mapping over each partition within the parent UO *)
					(* 2. Map *)
					tadmSlideView = SlideView[Map[
						Function[singlePartition,
							(* 3. Map *)
							Grid[Map[
								Module[{uoButton, aspirationDispenseTimes, relevantStreamButtons},

									(* set up a button to copy the unit operation - this is required to avoid slowdowns from front end trying to generate each unit operation blob individually *)
									uoButton = With[{unitOperationString = ECL`InternalUpload`ObjectToString[#[[12]]]},
										Button[
											Tooltip[
												Style[unitOperationString, 12, FontFamily -> "Helvetica", LCHColor[0.4, 0, 0]],
												"Copy to clipboard"
											],
											CopyToClipboard[ToExpression[unitOperationString]],
											Method -> "Queued",
											Appearance -> "Frameless"
										]
									];

									(* get the aspiration and dispense times *)
									aspirationDispenseTimes = {
										#[[17]],
										#[[18]]
									};

									(* get the stream packet that matches our aspiration and dispense times and create a button *)
									relevantStreamButtons = Map[
										Function[currentTime,
											Module[
												(* local variables *)
												{selectedStream, videoStartSeconds},

												(* find the stream packet *)
												selectedStream = If[!NullQ[currentTime],
													SelectFirst[
														streamPackets,
														Function[currentPacket,
															And[
																currentTime >= Lookup[currentPacket, StartTime],
																currentTime <= Lookup[currentPacket, EndTime]
															]
														],
														(*default*)
														<||>
													],
													(*default*)
													<||>
												];

												(* calculate time from start of video in seconds *)
												videoStartSeconds = If[!MatchQ[selectedStream, <||>],
													SafeRound[AbsoluteTime[currentTime] - AbsoluteTime[Lookup[selectedStream, StartTime]], 1]
												];

												(* Create a button if we found a stream packet*)
												If[MatchQ[Lookup[selectedStream, VideoFile, Null], LinkP[Object[EmeraldCloudFile]]],
													With[
														{
															streamObject = Lookup[selectedStream, Object],
															playButtonGraphic = playButton,
															playStartTime = videoStartSeconds
														},
														Button[
															Tooltip[playButtonGraphic, "Play"],
															ECL`WatchProtocol[streamObject, playStartTime],
															Method -> "Queued",
															Appearance -> "Frameless"
														]
													],
													(* default output instead of Null so nothing shows up in the table *)
													""
												]
											]
										],
										aspirationDispenseTimes
									];

									(* '#' is a single row of all the information for this anonymous function. See allDataList above for reference *)
									{
										(* transfer index *)
										Style[#[[1]], 18, Bold, LCHColor[0.4, 0, 0], "Helvetica"],
										(* table *)
										Grid[
											{
												{"Source", ClickToCopy[Tooltip[#[[3]], #[[2]]], #[[2]]]},
												{"Source Container", ClickToCopy[Tooltip[#[[5]], #[[4]](*Column[{#[[4]], #[[4, 2]]/.containerToModelRules}]*)], #[[4]]]},
												{"Destination", ClickToCopy[Tooltip[#[[7]], #[[6]]], #[[6]]]},
												{"Destination Container", ClickToCopy[Tooltip[#[[9]], #[[8]](*Column[{#[[8]], #[[8, 2]]/.containerToModelRules}]*)], #[[8]]]},
												{"Amount", ClickToCopy[UnitForm[#[[10]], Brackets -> False, Round -> 0.1], UnitScalse[#[[10]]]]},
												{"Aspiration Time", Row[{aspirationDispenseTimes[[1]], "\t", relevantStreamButtons[[1]]}]},
												{"Dispense Time", Row[{aspirationDispenseTimes[[2]], "\t", relevantStreamButtons[[2]]}]},
												If[!NullQ[#[[15]]], {"Aspiration Error", #[[15]]}, Nothing],
												If[!NullQ[#[[16]]], {"Dispense Error", #[[16]]}, Nothing],
												{Pane["Unit Operation"], uoButton} (* unclear why, but without Pane, "Unit Operation" appears higher vertically *)
											},
											Background -> {None, {{White, LCHColor[0.95, 0, 0]}}},
											Alignment -> {{Right, Center}},
											Dividers -> {False, {{True}}},
											FrameStyle -> RGBColor[0.6, 0.6, 0.6],
											ItemStyle -> {{
												Directive[Bold, LCHColor[0.4, 0, 0], FontFamily -> "Helvetica"],
												Directive[LCHColor[0.4, 0, 0], FontFamily -> "Helvetica"]
											}}
										],
										(* plot *)
										EmeraldListLinePlot[#[[13 ;; 14]],
											Legend -> {"Aspiration", "Dispense"},
											PlotStyle -> {LCHColor[0.6, 1, 0.7], LCHColor[0.8, 1, 0.2]},
											LegendPlacement -> Right,
											ImageSize -> imageSize,
											Zoomable -> zoomBool,
											LabelStyle -> {14, Bold, LCHColor[0.4, 0, 0], FontFamily -> "Helvetica"}
										]
									}
								]&,
								singlePartition
							], Dividers -> {False, {{True}}}, Spacings -> 1]
						],
						singleGroupValue
					], AppearanceElements -> {"FirstSlide", "PreviousSlide", "NextSlide", "LastSlide", "SlideNumber", "SlideTotal"}, ControlPlacement -> {Top, Center}];

					tabGraphic -> Grid[
						{
							{uoContentDescription, helpFileButton},
							{tadmSlideView, SpanFromLeft}
						},
						Alignment -> Center,
						ItemSize -> {{Automatic, Scaled[0.02]}}
					]
				]
			],
			groupedPartedSelectedData
		], Appearance -> {"Limited", 7}, ControlPlacement -> {Top, Center}]
	];

	(* Return the requested outputs *)
	output/.{
		Result->plotsTables,
		(*there is currently no option resolution*)
		Options->safeOps,
		Preview->plotsTables,
		Tests->{}
	}
];