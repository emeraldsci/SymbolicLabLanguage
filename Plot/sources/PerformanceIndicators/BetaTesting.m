(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*Beta Testing*)

(* List any experiments in beta testing or entering into beta testing here *)
(* Follow the format: functionName -> list of options to send to PlotBetaTesting *)
(* Typically no options are required for PlotBetaTesting - the most likely option to provide is SearchCriteria and Name
	- SearchCriteria is used if modifying an existing function and need to specify search conditions to find only your protocols
	- Name is often used with SearchCriteria if the exact changes are unclear (for instance if you want to indicate a specific feature added to RSP
*)
$BetaExperimentFunctions = <|
	"ExperimentLiquidLiquidExtraction" -> {
		StartDate -> DateObject[{2024, 6, 15}],
		SearchCriteria -> Any[InputUnitOperations[Type] == Object[UnitOperation, LiquidLiquidExtraction]],
		UnusedProcedures -> {
			"RCP QPix",
			"Robotic Sample Preparation Select LiquidHandler With RequiredInstruments",
			"RCP Select any Tips",
			"Sample Preparation Primary Plate Reader Setup",
			"Sample Preparation Secondary Plate Reader Setup",
			"CellPreparation Microscope Temperature Setting",
			"CellPreparation Microscope Carbon dioxide Setting",
			"Sample Manipulation HPLC Vial Rack Handling",
			"Integrated Plate Sealer Empty Trash",
			"Integrated Plate Sealer Check Magazine",
			"Robotic Keep Enclosure Closed Instruction",
			"Integrated Plate Sealer Check Seal Stickers",
			"Integrated Plate Sealer Sort Seals",
			"Integrated Plate Sealer Discard Seal Stickers",
			"Integrated Plate Seal Magazine Check position",
			"Integrated HMotion go to Home Position",
			"Sterilize bioSTAR",
			"Robotic Pick Cell Containers",
			"Load MALDI Plate on Hamilton",
			"MetaXpress Software Initialization",
			"Open Robotic Sample and Cell Preparation BioStar Method",
			"Integrated instrument Power cycle",
			"Sample Manipulation Robot Wait For Completion",
			"SampleManipulation Wait For Cool Down",
			"RCP Careful with Dyne Plates",
			"Close Uncle Capillary Clips",
			"MetaXpress Software Shutdown",
			"CellPreparation Restore Microscope Temperature",
			"CellPreparation Microscope Carbon dioxide Shutdown",
			"bioSTAR Turn Off HEPA",
			"Qualification VerifyHamiltonLabware TopLight PDU Off",
			"Check Lunatic loading",
			"Qualification VerifyHamiltonLabware TopLight PDU",
			"Troubleshooting Catch-All",
			"Biostar decontaminate enclosure",
			"Biostar decontamination gather wipes",
			"Biostar enclosure close all doors and light UV",
			"Hamilton Initialization Failure Restart",
			"Hamilton Method Start Check Necessary Options",
			"HMotion Gripper Angle adjustment",
			"HMotion Rail Position adjustment",
			"HMotion Z Height adjustment",
			"Initial plate adjustment",
			"Initial plate adjustment loop",
			"Integrated Centrifuge Power cycle",
			"Integrated FlowCytometer power cycle",
			"Integrated Heater Cooler Power cycle",
			"Integrated HeaterCoolerShaker Power cycle",
			"Integrated Heater Shaker Power cycle",
			"Integrated HMotion Power cycle",
			"Integrated Incubator Power cycle",
			"Integrated Microscope Power cycle",
			"Integrated MPE Power cycle",
			"Integrated Nephelometer Door Check",
			"Integrated Plate Reader Door Check",
			"Integrated PlateReader drive reinstall",
			"Integrated PlateSealer Power cycle",
			"Integrated Thermocycler Power cycle",
			"Integrated TiltModule Power cycle",
			"Liquid handler align remove racks left",
			"Plate Reader Door Click No",
			"Plate Reader Door Click Yes",
			"QualLiquidHandler Gilson Branch",
			"QualLiquidHandler Hamilton bioSTAR Branch",
			"VerifyHamiltonLabware Integrated instrument Power cycle"
		}
	},
	"ExperimentELISA" -> {StartDate -> DateObject["July 1 2025"]},
	"ExperimentCrossFlowFiltration" -> {StartDate -> DateObject[{2024, 9, 13}]},
	"ExperimentInoculateLiquidMedia" -> {
		StartDate -> DateObject[{2024, 12, 2}],
		UnusedProcedures -> {
			"CORE2 Check channel alignment",
			"VerifyHamitonLabware pick COREII tips"
		}
	},
	"ExperimentIncubateCells" -> {
		StartDate -> DateObject[{2024, 12, 2}],
		UnusedProcedures -> {
			"IncubateCells Cytomat HERAcell 240i TT 10 for Mammalian Plates",
			"MaintenanceRefillReservoir Check Dispenser Volume",
			"MaintenanceRefillReservoir Check Uncle Internal Reservoir Volume",
			"MaintenanceRefillReservoir Check QX One Volumes",
			"MaintenanceRefillReservoir Check SpeedVac Trap Volume",
			"MaintenanceRefillReservoir Check Desiccant Condition",
			"MaintenanceRefillReservoir FragmentAnalysis ResourcePicking",
			"MaintenanceRefillReservoir Reserve Instrument",
			"MaintenanceRefillReservoir Empty Trap Resource Picking",
			"MaintenanceRefillReservoir Resource Pick Cryo Gloves",
			"MaintenanceRefillReservoir Spectrophotometer",
			"MaintenanceRefillReservoir Sonicator",
			"MaintenanceRefillReservoir GilsonBufferLine",
			"MaintenanceRefillReservoir TCHood WaterReservoir",
			"MaintenanceRefillReservoir SquirtBottlesReservoir",
			"MaintenanceRefillReservoir FPLCWashBufferDeck",
			"MaintenanceRefillReservoir FPLCBufferLineReservoir",
			"MaintenanceRefillReservoir Bufferbot WaterReservoir",
			"MaintenanceRefillReservoir Bufferbot AcetoneReservoir",
			"MaintenanceRefillReservoir LCMSReservoirDeck",
			"MaintenanceRefillReservoir UncleInternalReservoir",
			"MaintenanceRefillReservoir QX One Reader Bottle",
			"MaintenanceRefillReservoir Carboy",
			"MaintanceRefillReservoir ZE5 SheathFluid",
			"MaintenanceRefillReservoir ZE5 Cleaner",
			"MaintenanceRefillReservoir ZE5 QC beads",
			"MaintenanceRefillReservoir FragmentAnalysis CapillaryStorageSolutionPlate",
			"MaintenanceRefillReservoir Echo 650 Coupling Fluid",
			"MaintenanceRefillReservoir Empty SpeedVac Trap",
			"MaintenanceRefillReservoir Replace Desiccant",
			"MaintenanceRefillReservoir SciEx Echo MassSpec Coupling Fluid",
			"Empty SpeedVac Trap",
			"MaintenanceRefillReservoir Echo 650 Replace Coupling Fluid Panel",
			"MaintenanceRefillReservoir ReleaseInstrument",
			"MaintenanceRefillReservoir_Clean Up for Spectrophotometer",
			"MaintenanceRefillReservoir_Clean Up for Sonicator",
			"MaintenanceRefillReservoir_Clean Up for LiquidWasteAndWasteContainer",
			"MaintenanceRefillReserovir_Clean Up for QX One",
			"MaintenanceRefillReservoir Clean up Fill Liquid",
			"MaintenanceRefillReservoir Cleanup SpeedVac Cryo Trap",
			"MaintenanceRefillReservoir Cleanup Desiccator"
		}
	},
	"ExperimentImageCells" -> {StartDate -> DateObject[{2024, 11, 1}]},
	"ExperimentQuantifyCells" -> {
		StartDate -> DateObject[{2024, 12, 2}],
		UnusedProcedures -> {
			(* Only care about replacing filter of BMG instruments *)
			"MaintenanceReplaceFilter_HPLC buffer inlet filters",
			"MaintenanceReplaceFilter_MilliporeElixMillipak",
			"MaintenanceReplaceFilter_MilliQIntegral3BioPak",
			"MaintenanceReplaceFilter_MilliQIntegral3ProgardPack",
			"MaintenanceReplaceFilter_MilliQIntegral3QuantumCartridge",
			"MaintenanceReplaceFilter_MilliQIntegral3VentFilter",
			"MaintenanceReplaceFilter_MilliQIQ7010Biopak",
			"MaintenanceReplaceFilter_MilliQIQ7010IPAKGard",
			"MaintenanceReplaceFilter_MilliQIQ7010IPAKQuanta",
			"MaintenanceReplaceFilter_MilliQIQ7010Or7015VentFilter",
			"MaintenanceReplaceFilter_ProteinSimpleMaurice",
			
			(* AlphaScreen qual is currently turned off (and not relevant to cell bio) *)
			"AlphaScreen Qualification Procedure"
		}
	},
	"ExperimentQuantifyColonies" -> {
		StartDate -> DateObject[{2024, 12, 2}],
		SearchCriteria -> {
			Any[InputUnitOperations[Type] == Object[UnitOperation, QuantifyColonies]], (* For RCP *)
			True(* For Object[Protocol,QuantifyColonies] *)
		},
		UnusedProcedures -> {
			"RCP Hamilton", "PickColonies OutputUnitOperation", "SpreadCells OutputUnitOperation",
			"QPix Insert PrimaryWashSolution", "QPix Insert SecondaryWashSolution", "QPix Insert TertiaryWashSolution",
			"QPix Dispose PrimaryWashSolution", "QPix Dispose SecondaryWashSolution", "QPix Dispose TertiaryWashSolution",
			"QPixPrepUnitOperationLoop", "PickColonies OutputUnitOperation Prep", "PickColonies Plate Preparation",
			"SpreadStreak Plate Preparation", "SpreadCells OutputUnitOperation Prep", "SpreadStreak Sample Resuspension"
		}
	},
	"ExperimentPickColonies" -> {
		StartDate -> DateObject[{2024, 12, 2}],
		SearchCriteria -> Any[InputUnitOperations[Type] == Object[UnitOperation, PickColonies]],
		UnusedProcedures -> {
			"RCP Hamilton", "SpreadCells OutputUnitOperation", "ImageColonies OutputUnitOperation",
			"Qpix Swap Tip Rack", "QPix final tip return"
		}
	},
	"ExperimentSpreadCells" -> {
		StartDate -> DateObject[{2024, 12, 2}],
		SearchCriteria -> Any[InputUnitOperations[Type] == Object[UnitOperation, SpreadCells]],
		UnusedProcedures -> {
			"RCP Hamilton", "PickColonies OutputUnitOperation", "ImageColonies OutputUnitOperation"
		}
	},
	"ExperimentStreakCells" -> {
		StartDate -> DateObject[{2024, 12, 2}],
		SearchCriteria -> Any[InputUnitOperations[Type] == Object[UnitOperation, StreakCells]],
		UnusedProcedures -> {
			"RCP Hamilton", "PickColonies OutputUnitOperation", "ImageColonies OutputUnitOperation"
		}
	},
	"ExperimentWashCells" -> {
		StartDate -> DateObject[{2024, 12, 2}],
		SearchCriteria -> Any[InputUnitOperations[Type] == Object[UnitOperation, WashCells]],
		UnusedProcedures -> {
			(*General branches not relavant to WashCells, which is essentially a list of Label, Transfer, Pellet UOs*)
			"RCP QPix",
			"Sample Preparation Primary Plate Reader Setup", "Sample Preparation Secondary Plate Reader Setup",
			"CellPreparation Microscope Temperature Setting", "CellPreparation Microscope Carbon dioxide Setting",
			"Sample Manipulation HPLC Vial Rack Handling", "Liquid Handler STAR GoPro Turn On",
			"Open SampleManipulation Starlet Method", "Open SampleManipulation SuperStar Method",
			"Troubleshooting Catch-All", "MetaXpress Software Initialization", "MetaXpress Software Shutdown",
			"CellPreparation Restore Microscope Temperature", "CellPreparation Microscope Carbon dioxide Shutdown",
			"Liquid Handling Measure Volume", "Liquid Handling Measure Weight",
			"Liquid Handling Image Sample", "RCP Careful with Dyne Plates", "Check Lunatic loading",
			(*"RCP Hamilton" procedure branches that are error-triggered. We are not actively testing those.*)
			"Integrated instrument Power cycle", "Integrated HMotion Power cycle",
			"Integrated PlateSealer Power cycle", "Integrated Thermocycler Power cycle",
			"Integrated MPE Power cycle", "Integrated Centrifuge Power cycle",
			"Integrated Heater Shaker Power cycle", "Integrated Heater Cooler Power cycle",
			"Integrated HeaterCoolerShaker Power cycle", "Integrated Incubator Power cycle",
			"Integrated Microscope Power cycle", "Integrated TiltModule Power cycle",
			"Power cycle new HEPA", "Power cycle old HEPA", "Hamilton Initialization Failure"
		}
	},
	"ExperimentLyseCells" -> {
		StartDate -> DateObject[{2024, 12, 2}],
		SearchCriteria -> Any[InputUnitOperations[Type] == Object[UnitOperation, LyseCells]],
		UnusedProcedures -> {
			(*General branches not relavant to LyseCells, which is essentially a list of Label, Transfer, Pellet UOs*)
			"RCP QPix",
			"Sample Preparation Primary Plate Reader Setup", "Sample Preparation Secondary Plate Reader Setup",
			"CellPreparation Microscope Temperature Setting", "CellPreparation Microscope Carbon dioxide Setting",
			"Sample Manipulation HPLC Vial Rack Handling", "Liquid Handler STAR GoPro Turn On",
			"Open SampleManipulation Starlet Method", "Open SampleManipulation SuperStar Method",
			"Troubleshooting Catch-All", "MetaXpress Software Initialization", "MetaXpress Software Shutdown",
			"CellPreparation Restore Microscope Temperature", "CellPreparation Microscope Carbon dioxide Shutdown",
			"Liquid Handling Measure Volume", "Liquid Handling Measure Weight",
			"Liquid Handling Image Sample", "RCP Careful with Dyne Plates", "Check Lunatic loading",
			(*"RCP Hamilton" procedure branches that are error-triggered. We are not actively testing those.*)
			"Integrated instrument Power cycle", "Integrated HMotion Power cycle",
			"Integrated PlateSealer Power cycle", "Integrated Thermocycler Power cycle",
			"Integrated MPE Power cycle", "Integrated Centrifuge Power cycle",
			"Integrated Heater Shaker Power cycle", "Integrated Heater Cooler Power cycle",
			"Integrated HeaterCoolerShaker Power cycle", "Integrated Incubator Power cycle",
			"Integrated Microscope Power cycle", "Integrated TiltModule Power cycle",
			"Power cycle new HEPA", "Power cycle old HEPA", "Hamilton Initialization Failure"
		}
	},
	"ExperimentFreezeCells" -> {StartDate -> DateObject[{2024, 12, 2}]},
	"ExperimentMedia" -> {
		StartDate -> DateObject[{2024, 12, 2}],
		SearchCriteria -> Any[StockSolutionModels[Type] == Model[Sample, Media]],
		UnusedProcedures -> {"Stock Solution Plate Media"}
	},
	"ExperimentPlateMedia" -> {StartDate -> DateObject[{2024, 12, 2}]}
|>;

(*$ErrorCategoriesToExclude*)
(* error categories that should not be counted against the beta testing ticket rate *)
$ErrorCategoriesToExclude = {
	"Works as Designed",
	"Physical Storage Limitation",
	"Gas Supply (N2, Argon, Helium, ...)",
	"Building Infrastructure",
	"Engine Front Bug",
	"Power Outage",
	"Wifi/Connectivity Issue",
	"Individual Mistake (Internal)",
	"Unavailable Equipment/Instrument",
	"Missing Items"
};

(* ::Subsubsection::Closed:: *)
(*PlotBetaTesting*)
DefineOptions[PlotBetaTesting,Options:>{
	{StartDate->(Now - 3 Month),_DateObject,"The first time to consider protocols."},
	{SearchCriteria->Automatic,True|_And|_Or|_Equal|_Unequal|_,"Additional elements to be included in the And used to find protocols to assess during beta testing (for instance specify protocols run on only certain instrument models). If the critieria is a list, the length of the list must equal to the length of protocol types."},
	{Name->Null,Null|_String,"A short description of the change being beta tested."},
	{Email->True,BooleanP,"Indicates if the respective parties should be emailed the results of the beta testing notebooks. If False, summary tables are returned in the notebook."},
	{OutputFormat->Notebook,ListableP[(Notebook|SummaryTable|SummaryData)],"Indicates how the beta testing plots should be displayed."},
	{UnusedProcedures->{},{_String...},"Procedure branches that should not be checked when calculating TaskCoverage."}
}];

PlotBetaTesting::TypeLookup="You must add your experiment to Experiment'Private'experimentFunctionTypeLookup (for experiments) or to ProcedureFramework'Private'experimentFunctionTypeLookup (for qualifications and maintenances) in order to use this function.";
PlotBetaTesting::MissingProcedureDefinitions="Procedure Definitions are missing. Please make sure ProcedureDefinitions package is correctly loaded. You can call ReloadPackage[\"ProcedureDefinitions'\"] to load this separately or load all of SLL'Dev' before using this function.";


PlotBetaTesting[experimentFunction_Symbol,ops:OptionsPattern[PlotBetaTesting]]:=Module[
	{
		namedObject, checkpointPercentage, safeOps, rawStartDate, outputFormat, searchCriteriaQ, userSearchCriteria, name,
		unusedProcedures, startDate, protocols, rawProtocolType, protocolTypes, protocolQ, protocolOrQualQ,
		helpFileOptions, instrumentModels, instrumentKnown, expandedSearchTypes, searchResults, tickets, quals, maintenances,
		protocolDownload, listedTicketPackets, instrumentDownload, ticketPackets, rawTicketPackets,
		protocolQualMaintenancePackets, allSubprotocolPackets, protocolPackets, qualPackets, maintenancePackets, resourcePackets,
		resourceModelPackets, resourceProductInventoryPackets, resourceStockSolutionInventoryPackets, encounteredProcedures,
		encounteredSubprotocolProcedures, protocolTargetModelPackets, instrumentModelPackets, qualModelTypes, qualObjectTypes,
		maintenanceTypes, qualTypes, allProtocolProcedures, allQualProcedures, allMaintenanceProcedures, allProcedures,
		allProcedureEventsEncountered, allProceduresEncountered, allUntestedProcedures, untestedProtocolProcedures, untestedQualProcedures,
		untestedMaintenanceProcedures, procedureCoverage, procedureCoverageTable, untestedProcedureTable, parserFunction,
		functionSet, executeFunctions, executeTasks, protocolData, meanProtocolStatusTimes, meanQualStatusTimes, meanMaintenanceStatusTimes,
		meanProtocolStatusTable, meanQualStatusTable,meanMaintenanceStatusTable, protocolsCreated, protocolCreationPlot,
		protocolStatusTallies, qualStatusTallies, maintenanceStatusTallies, currentProtocolStatusTable, currentQualStatusTable,
		currentMaintenanceStatusTable, completedProtocolPackets, numberOfCompletedProtocols, actualCheckpointsPerProtocol,
		estimatedCheckpointsPerProtocol, trueCheckpointTime, checkPointSummaryTuples, checkPointGroups, checkpointComparisons,
		checkpointComparisonTable, longTaskPackets, longTaskInfo, groupedLongTasks, longTaskTableData, longTaskTable,
		inventoryTuples, noInventories, inventoryData, noInventoryTable, inventoryTable, primaryAuthor,
		protocolVOQBooleans, dataVOQBooleans, allVOQPassing, voqSummaryTable, validDocsPercentage, validDocumentationTable,
		websiteAddress, statusCode, websiteLine, lastProtocols, directTickets, directTicketPackets, meaningTicketPackets,
		currentSupportPercentage, unresolvedTicketTable, resolvedTicketTable, relevantTargetModelPackets, qualificationRequired,
		qualificationFrequency, qualScheduled, qualScheduleTable, maintenanceScheduled, maintenanceScheduleTable, qualResultPackets,
		sortedQualResultPackets, qualPassing, qualResultsTable, subprotocolTasks, subprotocolFunctions, subprotocolSupport,
		statusCaption, passingOverall, safeRound, summaryData, summaryTable, outputForms, statusFollowUpString, cloudFile,
		outputRules, allData, validDocumentationBooleans, previewExperiment, optionsExperiment, validExperiment, compilerFunction,
		supportTimeline, fileName, resolvedTicketDisplay, unresolvedTicketDisplay, lastNoInventories, checkpointProtocolPackets,
		taskCoverage, untestedTaskCounts, allTaskCounts, allQualPackets, allMaintenancePackets,
		recentlyCompletedProtocolPackets, numberOfRecentlyCompletedProtocols, exampleNotebookExistsQ
	},

	Echo["Creating Beta Testing Notebook for "<>ToString[experimentFunction]ProgressIndicator[Appearance -> "Ellipsis"]];

	(* Make our own little NamedObject - since we know exactly what to expect it's faster *)
	namedObject[packet:PacketP[]]:=If[!MatchQ[Lookup[packet,Name],Null],
		Append[Lookup[packet,Type],Lookup[packet,Name]],
		Lookup[packet,Object]
	];

	(* Define constant indicating how close checkpoint estimates should be to actual checkpoints *)
	checkpointPercentage=20;

	(* TODO add ValidOpenPathsQ to the table *)

	(* Pull out our specified options *)
	safeOps=SafeOptions[PlotBetaTesting,ToList[ops]];
	{rawStartDate,outputFormat,searchCriteriaQ,name,unusedProcedures}=Lookup[safeOps,{StartDate,OutputFormat,SearchCriteria,Name,UnusedProcedures}];

	userSearchCriteria = If[MatchQ[searchCriteriaQ, Automatic],
		(* If SearchCriteria is True, we lookup $BetaExperimentFunctions for criteria first *)
		(* If there is SearchCriteria specified inside of $BetaExperimentFunctions, use that *)
		(* Note if SearchCriteria is specified in option, it will override the value in $BetaExperimentFunctions *)
		If[MemberQ[Keys@$BetaExperimentFunctions, ToString@experimentFunction],
			Lookup[Association@Lookup[$BetaExperimentFunctions, ToString@experimentFunction], SearchCriteria, True],
			True
		],
		searchCriteriaQ
	];
	(* If given a day convert to an exact time to avoid comparison issues *)
	startDate=CurrentDate[rawStartDate,"Instant"];

	(* Find the protocol type associated with this experiment function so that we can search for existing options *)
	rawProtocolType=Lookup[ProcedureFramework`Private`experimentFunctionTypeLookup,experimentFunction,$Failed];

	(* Some protocols can return MSP or RSP. We don't want to consider these here since we are expecting the direct protocols to be tested *)
	protocolTypes=Replace[
		Cases[
			ToList[rawProtocolType],
			Except[Alternatives[Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation], Object[Notebook, Script]]]
		],
		{} -> {Object[Protocol, RoboticSamplePreparation]},
		{0}
	];

	(* If we're running on a protocol, qual or maintenance we'll show some different information/need to pull info from different sources *)
	protocolQ=MemberQ[protocolTypes,TypeP[Object[Protocol]]];
	protocolOrQualQ=MemberQ[protocolTypes,TypeP[{Object[Protocol],Object[Qualification]}]];

	(* Return early if we don't know the type of protocol created by this experiment since we don't be able to find associated protocols *)
	If[!MatchQ[protocolTypes,{TypeP[]..}],
		Message[PlotBetaTesting::TypeLookup];
		Return[$Failed]
	];

	(* Look-up instruments from the help file *)
	(* Keep in mind that quals and maintenances won't have help files in this format *)
	helpFileOptions=Lookup[ECL`$HelpFileOptions,experimentFunction,{}];
	instrumentModels=Cases[Flatten[Lookup[helpFileOptions,InstrumentModels,{}],1],ObjectP[Model[Instrument]]];
	instrumentKnown=!MatchQ[instrumentModels,{}];

	Echo["Searching for related objects.."];
	(* Search for:
		- last unit test suite to find if experiment tests and co. are passing
		- recent protocols of type to find operations statistics, etc.
		- support tickets associated with protocol
		- quals run on associated instrument (if relevant)
		- maintenance run on associated instrument (if relevant)
	*)
	expandedSearchTypes = Append[ToList /@ protocolTypes, {Object[SupportTicket, Operations]}];
	searchResults = With[
		{
			(* Generate a searchCriteria for each protocol type and add support ticket search criteria here as well *)
			(* Assemble criteria, not this is not being held as it would be directly inside search*)
			expandedSearchCriteria = If[MatchQ[userSearchCriteria, _List],
				Append[
					(* Protocol *)
					(DateCreated>(startDate) && #)&/@ userSearchCriteria,
					(* Tickets *)
					SourceProtocol[Type]==(Alternatives @@ protocolTypes) && DateCreated>(startDate)
				],
				Append[
					(* Protocol *)
					ConstantArray[DateCreated>(startDate) && userSearchCriteria, Length[protocolTypes]],
					(* Tickets *)
					SourceProtocol[Type]==(Alternatives @@ protocolTypes) && DateCreated>(startDate)
				]
			]
		},
		(* Note: a valid search can contain type-criteria pairs, types and criteria should have the same length *)
		(* For example, Search[{{protocolType1},{protocolType2}},{criteriaForProtocol1, criteriaForProtocol2}] *)
		Search[
			expandedSearchTypes,
			expandedSearchCriteria
		]
	];

	(* Assign names to our search results *)
	tickets = Last[searchResults];
	protocols = Flatten@Most[searchResults];

	instrumentDownload=Download[instrumentModels,{
		Packet[Name,QualificationFrequency,MaintenanceFrequency,QualificationRequired],
		Packet[Objects[QualificationLog][[All, 2]][{Object, DateCreated}]],
		Packet[Objects[MaintenanceLog][[All, 2]][{Object, DateCreated}]]
	}];

	(* Do separate download to avoid downloading through so many levels of links *)
	(* We were previously searching for these but that proved to be a very expensive several minutes long search *)
	{instrumentModelPackets,allQualPackets,allMaintenancePackets}=If[MatchQ[instrumentDownload,{}],
		{{},{},{}},
		{
			instrumentDownload[[All,1]],
			Cases[Flatten[instrumentDownload[[All,2]],2],PacketP[]],
			Cases[Flatten[instrumentDownload[[All,3]],2],PacketP[]]
		}
	];

	quals=Lookup[Select[allQualPackets,(Lookup[#,DateCreated]>startDate)&],Object,{}];
	maintenances=Lookup[Select[allMaintenancePackets,(Lookup[#,DateCreated]>startDate)&],Object,{}];

	Echo["Downloading related objects.."];
	ManifoldEcho[{protocols, quals, maintenances,tickets},"core download objects"];
	(* Download test suite data, protocol data, op data, ticket data and qual/maintenance data *)
	{protocolDownload, listedTicketPackets} = Quiet[Download[
		{
			Join[protocols, quals, maintenances],
			tickets
		},
		{
			{
				Packet[Data, DateCreated, DateCompleted, Status, Checkpoints, CheckpointProgress, Result, Subprotocols, ProtocolSpecificInternalCommunications, Model, Target],
				Packet[Subprotocols[DateStarted, DateCompleted]],

				(* Resource checking *)
				Packet[SubprotocolRequiredResources[{DateCreated, Purchase}]],
				Packet[SubprotocolRequiredResources[Models][[1]][Name]],
				Packet[SubprotocolRequiredResources[Models][[1]][Products][Inventories][{Status, ReorderAmount, ReorderThreshold}]],
				Packet[SubprotocolRequiredResources[Models][[1]][Inventories][{Status, ReorderAmount, ReorderThreshold}]],

				(* Procedure Logs *)
				(* Download for test coverage information. Get subprotocols to find when our type as run as a sub in one of its quals *)
				(* This assumes we don't have any relevant deeper subs *)
				Packet[ProcedureLog[Protocol, Procedure, BranchObjects, ProtocolStatus]],
				Packet[Subprotocols[ProcedureLog][Protocol, Procedure, BranchObjects, ProtocolStatus]],

				(* For quals and maintenances, see if they're scheduled *)
				Packet[Target[Model][Name, QualificationFrequency, MaintenanceFrequency, QualificationRequired]]
			},
			{Packet[Resolved, Headline, Description, SupportTicketSource, SourceProtocol, ReportedOperatorError, ErrorCategory]}
		}
	], {Download::NotLinkField, Download::FieldDoesntExist, Download::Part}];

	(* Flatten out our ticket and protocol data *)
	rawTicketPackets=listedTicketPackets[[All,1]];
	protocolQualMaintenancePackets=protocolDownload[[All,1]];
	allSubprotocolPackets=protocolDownload[[All,2]];

	(* We're going to call our type associated with the input function the protocol *)
	(* Technically this could be a qualification or a maintenance *)
	protocolPackets=Cases[protocolQualMaintenancePackets,ObjectP[protocolTypes]];

	(* Get associated quals and maintenances that have run on the instruments listed in the help file *)
	qualPackets=Cases[protocolQualMaintenancePackets,ObjectP[Object[Qualification]],{}];
	maintenancePackets=Cases[protocolQualMaintenancePackets,ObjectP[Object[Maintenance]],{}];

	(* Pull out resource information from all protocols, quals and maintenance *)
	resourcePackets=protocolDownload[[All,3]];
	resourceModelPackets=protocolDownload[[All,4]];
	resourceProductInventoryPackets=protocolDownload[[All,5]];
	resourceStockSolutionInventoryPackets=protocolDownload[[All,6]];

	(* Extract all procedures we went down *)
	encounteredProcedures=Flatten[protocolDownload[[All,7]],1];
	encounteredSubprotocolProcedures=Flatten[protocolDownload[[All,8]],2];

	protocolTargetModelPackets=protocolDownload[[All,9]];

	(* Grab our data objects *)
	protocolData=Lookup[protocolPackets,Data,{}];

	ticketPackets=Select[rawTicketPackets, MemberQ[Lookup[protocolQualMaintenancePackets,Object], Lookup[#, SourceProtocol][Object]] &];

	(* Get models of quals and maintenances we're set to run periodically *)
	qualModelTypes=Download[
		Flatten[Lookup[instrumentModelPackets,{MaintenanceFrequency,QualificationFrequency},{}],2][[All,1]],
		Type
	];

	(* Convert qual/maintenance model types to object types *)
	qualObjectTypes=Object@@#&/@qualModelTypes;

	(* Get a flat list of all qual and maintenance types *)
	(* 'quals' and 'maintenances' come from finding Object[Qualification/Maintenance] which have their Target set to one our known instrument models *)
	qualTypes=DeleteDuplicates[Join[Download[quals,Type],Cases[qualObjectTypes,TypeP[Object[Qualification]],{}]]];
	maintenanceTypes=DeleteDuplicates[Join[Download[maintenances,Type],Cases[qualObjectTypes,TypeP[Object[Maintenance]],{}]]];

	(* -- Procedure Log Parsing -- *)

	Echo["Checking Procedure Coverage.."];

	ManifoldEcho[{protocolTypes,qualTypes,maintenanceTypes},"types"];

	(* For each type find all procedures it could encounter will running in Engine *)
	allProtocolProcedures=Flatten[procedureTree[#,unusedProcedures]& /@ protocolTypes];
	allQualProcedures=If[MatchQ[qualTypes,{}|Null],{},Flatten[procedureTree[#,unusedProcedures]&/@DeleteDuplicates[qualTypes],1]];
	allMaintenanceProcedures=If[MatchQ[maintenanceTypes,{}|Null],{},Flatten[procedureTree[#,unusedProcedures]&/@DeleteDuplicates[maintenanceTypes],1]];
	allProcedures=DeleteDuplicates[Join[allProtocolProcedures,allQualProcedures,allMaintenanceProcedures]];

	allTaskCounts=taskCountInProcedure/@allProcedures;

	(* Get all procedures we've actually tested in Engine *)
	allProcedureEventsEncountered=Join[encounteredProcedures,Flatten[encounteredSubprotocolProcedures,1]];

	(* Not every event has an associated procedure, get only those that do *)
	allProceduresEncountered=DeleteCases[DeleteDuplicates[Lookup[allProcedureEventsEncountered, Procedure, {}]],Null];
	ManifoldEcho[allProceduresEncountered,"encountered procedures"];

	(* Figure out this procedures haven't been tested in Engine *)
	{untestedProtocolProcedures,untestedQualProcedures,untestedMaintenanceProcedures}=Map[
		Complement[#,allProceduresEncountered]&,
		{allProtocolProcedures,allQualProcedures,allMaintenanceProcedures}
	];

	allUntestedProcedures = DeleteDuplicates[Join[untestedProtocolProcedures, untestedQualProcedures, untestedMaintenanceProcedures]];

	untestedTaskCounts=taskCountInProcedure/@allUntestedProcedures;

	(* Calculate task coverage *)
	taskCoverage = If[SameQ[allProcedures, {}],
		"N/A",
		With[{coverage=100 Percent * N[1 - Total[untestedTaskCounts] / Total[allTaskCounts]]},
			Which[
				(* If somehow the coverage failed to evaluate, don't output unevaluated code *)
				!MatchQ[coverage, _Quantity],
					"N/A",
				MatchQ[unusedProcedures,Except[{}]],
					coverage,
				True,
					UnitForm[coverage, Round -> .1] <> " (testing subset)"
			]
		]
	];

	(* Calculate procedure coverage *)
	procedureCoverage = If[SameQ[allProcedures, {}],
		"N/A",
		100 Percent * N[1 - Length[allUntestedProcedures] / Length[allProcedures]]
	];

	(* Make our plots, showing information differently if we are a qual *)
	{procedureCoverageTable,untestedProcedureTable}=If[protocolQ,
		{
			PlotTable[
				{{
					Length[allProtocolProcedures],
					Length[allQualProcedures],
					Length[allMaintenanceProcedures],
					Length[allProcedures],
					Length[allProcedures] - Length[allUntestedProcedures],
					procedureCoverage,
					taskCoverage
				}},
				Round->0.1,
				TableHeadings->{Automatic,{"Protocol Subprocedures","Qualification Subprocedures","Maintenance Subprocedures","All Subprocedures","Subprocedures Tested","Procedure Coverage Percentage","Task Coverage Percentage"}},
				Title->"Subprocedure Testing Coverage"
			],
			PlotTable[
				Transpose[PadRight[{untestedProtocolProcedures,untestedQualProcedures,untestedMaintenanceProcedures},Automatic,""]],
				TableHeadings->{Automatic,{"Protocol Subprocedures","Qualification Subprocedures","Maintenance Subprocedures"}},
				Title->"Untested Subprocedures"
			]
		},
		{
			PlotTable[
				{{
					Length[allProtocolProcedures],
					Length[allProcedures] - Length[allUntestedProcedures],
					procedureCoverage,
					taskCoverage
				}},
				Round->1,
				TableHeadings->{Automatic,{"Subprocedures","Subprocedures Tested","Procedure Coverage Percentage","Task Coverage Percentage"}},
				Title->"Subprocedure Testing Coverage"
			],
			PlotTable[
				Transpose[{untestedProtocolProcedures}],
				TableHeadings->{Automatic,{"Subprocedures"}},
				Title->"Untested Subprocedures"
			]
		}
	];

	(* -- Protocol Statuses -- *)

	Echo["Checking protocols run.."];

	(* Determine how much time our protocols have spent in different states during operation *)
	(* Remove statuses that aren't related to actual operation of the protocol *)
	{meanProtocolStatusTimes,meanQualStatusTimes,meanMaintenanceStatusTimes}=Map[
		Merge[KeyDrop[ParseLog[#,StatusLog],{InCart,Canceled,Aborted}],Mean]&,
		{protocols,quals,maintenances}
	];

	(* Make a separate summary table for protocols, quals and maintenances in these operation statuses *)
	{meanProtocolStatusTable,meanQualStatusTable,meanMaintenanceStatusTable}=MapThread[
		If[MatchQ[#1,<||>],
			failedSymbolStyle[
				"No processing/completed "<>#2<>" found",
				("No processing/completed protocols found" | "No processing/completed qualifications found"),
				"No processing/completed maintenances found"
			],
			PlotTable[
				{Values[#1]},
				TableHeadings->{Automatic,Keys[#1]},
				Round->True,
				Title->"Average Time in Status (for "<>Capitalize[#2]<>")"
			]
		]&,
		{
			{meanProtocolStatusTimes,meanQualStatusTimes,meanMaintenanceStatusTimes},
			{"protocols","qualifications","maintenances"}
		}
	];

	(* Check when protocols are getting created *)
	protocolsCreated=Lookup[protocolPackets,DateCreated,{}];
	protocolCreationPlot=DateHistogram[protocolsCreated,PlotLabel->"# Created"];

	(* Tally the current Status for our protocols *)
	(* This lets us see # of protocols completed, enqueued, etc. *)
	{protocolStatusTallies,qualStatusTallies,maintenanceStatusTallies}=Map[
		Tally[Lookup[#,Status,{}]]&,
		{protocolPackets,qualPackets,maintenancePackets}
	];

	(* Make a separate summary table for current states of protocols, quals and maintenances *)
	{currentProtocolStatusTable,currentQualStatusTable,currentMaintenanceStatusTable}=MapThread[
		If[MatchQ[#1,{}],
			(* Show no qual found as an error, no maintenance as a warning *)
			failedSymbolStyle["No "<>#2<>" found","No qualification found","No maintenance found"],
			PlotTable[
				#1,
				Title->Capitalize[#2]<>" in a given state:",
				TableHeadings -> {Automatic,{"Status","Number in Status"}}
			]
		]&,
		{
			{protocolStatusTallies,qualStatusTallies,maintenanceStatusTallies},
			{"protocols","qualifications","maintenance"}
		}
	];

	(* - Checkpoint Comparisons - *)

	(* Get our completed protocols *)
	completedProtocolPackets=Select[protocolPackets,MatchQ[Lookup[#,Status],Completed]&];
	numberOfCompletedProtocols=Length[completedProtocolPackets];

	(* get the number of recently completed protocols ("recently" here defined as in the last 2 weeks) *)
	recentlyCompletedProtocolPackets = Select[completedProtocolPackets, DateObjectQ[Lookup[#, DateCompleted]] && Lookup[#, DateCompleted] > (Now - 2 Week)&];
	numberOfRecentlyCompletedProtocols = Length[recentlyCompletedProtocolPackets];

	(* Get actual checkpoint times and expected checkpoint times *)
	checkpointProtocolPackets=Take[Reverse[completedProtocolPackets],UpTo[3]];
	actualCheckpointsPerProtocol=Lookup[checkpointProtocolPackets,CheckpointProgress,{}];
	estimatedCheckpointsPerProtocol=Lookup[checkpointProtocolPackets,Checkpoints,{}];

	(* Define helper: trueCheckpointTime, remove time in subprotocols from checkpoint time *)
	trueCheckpointTime[packet:PacketP[ProtocolTypes[]],checkpointStart_,checkpointEnd_]:=Module[
		{subprotocols,subprotocolPackets,subsInCheckpoint,subEnds},

		(* Get info for any subprotocols for this protocol *)
		subprotocols=Lookup[packet,Subprotocols];
		subprotocolPackets=Experiment`Private`fetchPacketFromCache[#,Flatten[allSubprotocolPackets]]&/@subprotocols;

		(* Find any subs that started within our current checkpoint *)
		subsInCheckpoint=Select[subprotocolPackets,(checkpointStart < Lookup[#,DateStarted] < checkpointEnd)&];

		(* We expected all subs end in this checkpoint, but just in case they don't use checkpoint end *)
		subEnds=Min[#,checkpointEnd]&/@Lookup[subsInCheckpoint,DateCompleted,{}];

		checkpointEnd-checkpointStart-Total[subEnds-Lookup[subsInCheckpoint,DateStarted,{}]]
	];

	(* See how closely our checkpoint estimates match with what actually happened *)
	(* Return as {{checkpoint name, est check time, true time, time difference}..} *)
	checkPointSummaryTuples=MapThread[
		Function[{actualTimes,expectedTimes,completedProtocolPacket},
			(* Actual stored as: {Name, Start, End}; Estimates as {Name, Time, Description, Operator} *)
			(* Make sure our actual and expected checkpoint names match otherwise we can't compare *)
			If[MatchQ[actualTimes[[All,1]],expectedTimes[[All,1]]],
				Transpose@{
					(* Checkpoint Name *)
					expectedTimes[[All,1]],
					(* Estimated Time *)
					expectedTimes[[All,2]],
					trueCheckpointTime[completedProtocolPacket, actualTimes[[All,2]], actualTimes[[All,3]]],
					(* Time over estimate: (actual end - actual start) - estimated time *)
					(* We correct for any subs that happened since these shouldn't count against our estimates *)
					trueCheckpointTime[completedProtocolPacket, actualTimes[[All,2]], actualTimes[[All,3]]] - expectedTimes[[All,2]]
				},
				(* It's possible checkpoints changed during run but this should only be if we're under active development *)
				Null
			]
		],
		{actualCheckpointsPerProtocol,estimatedCheckpointsPerProtocol,checkpointProtocolPackets}
	];

	(* Gather up our found checkpoint tuples which have the same name - e.g. all instances of 'Picking Resources' are gathered in a list of tuples *)
	(* We flatten and remove null so we just have a pure list of checkpoint tuples in the form {{{checkpoint name 1, est check time, true time, time difference},..}, ..} *)
	checkPointGroups=GatherBy[Flatten[DeleteCases[checkPointSummaryTuples,Null],1],First];

	(* Get our average estimated times and our average actual times for each unique checkpoint name *)
	(* In the form: {{checkpoint name, avg. est time, avg. true time, avg. time difference}..} *)
	checkpointComparisons=Map[
		{
			(* All checkpoints in this group have the same name, pull them out from out first tuple *)
			#[[1,1]],
			Round[UnitScale[Mean[#[[All,2]]]], 0.1],
			Round[UnitScale[Mean[#[[All,3]]]], 0.1],
			Round[UnitScale[Mean[#[[All,4]]]], 0.1]
		}&,
		checkPointGroups
	];

	(* Compare checkpoint accuracy *)
	checkpointComparisonTable = PlotTable[
		(* Remove checkpoint names from data and show as a header instead *)
		Rest /@ checkpointComparisons,
		TableHeadings -> {checkpointComparisons[[All, 1]], {"Avg. Expected Time", "Avg. Actual Time", "Time Above Estimate"}},
		Title -> "Checkpoint Comparisons"
	];

	(* - Long tasks - *)

	Echo["Checking for long tasks.."];

	(* Pull any tickets marked as long tasks out *)
	longTaskPackets=Select[ticketPackets,MatchQ[Lookup[#,SupportTicketSource],LongTask]&];

	(* Parse out info about the long task from the ticket description - ultimately will move this to fields *)
	(* In the form: {{task type, procedure, task ID}..}*)
	longTaskInfo=MapThread[
		{
			StringReplace[#2,___~~"\"TaskType\" -> \""~~type:WordCharacter..~~___:>type],
			StringReplace[#2,___~~"\"Procedure\" -> \""~~procedure:(WordCharacter|WhitespaceCharacter|DigitCharacter|"-"|"_")..~~___:>procedure],
			(* ID may be Null, need to remove leading quotation mark *)
			StringReplace[#2,___ ~~ "\"ID\" -> " ~~ id : ("\"" | WordCharacter | "-") .. ~~ ___ :> StringTrim[id, "\""]],
			#1
		}&,
		{Lookup[longTaskPackets,Object,{}],Lookup[longTaskPackets,Description,{}]}
	];

	(* Gather up by task ID and type (for ID null case) so we can see if we're having a repeated issue with a particular task *)
	groupedLongTasks=GatherBy[longTaskInfo,#[[{1,3}]]&];

	(* Convert our long task data into one line per task ID - since we've grouped by ID lots of info will be the same and we can just take first entry *)
	longTaskTableData=Map[
		{
			(* Number of times we've seen this task ID show up as a long task *)
			Length[#],
			(* Task Type *)
			#[[1,1]],
			(* Procedure *)
			#[[1,2]],
			(* Task ID, with tooltip to see full task *)
			tooltipStyle[Tooltip[#[[1,3]],findTasks[allProcedures,ID->#[[1,3]]]]],
			(* Long task tickets *)
			#[[All,4]]
		}&,
		groupedLongTasks
	];

	(* Final long task summary table *)
	longTaskTable=If[MatchQ[longTaskTableData,{}],
		Style["No long tasks found",Bold],
		PlotTable[
			longTaskTableData,
			TableHeadings->{Automatic,{"# of Occurrences","Task Type","Procedure","ID","Long Task Tickets"}},
			Title->"Long Tasks"
		]
	];

	(* -- Inventory Tracking -- *)

	Echo["Checking for standing orders.."];

	(* Pull out correct inventory object - stock solution or product - based on resource model and form into tuples *)
	(* In the form {{requested model, inventory packet, date created, purchase bool}..} *)
	inventoryTuples=MapThread[
		Function[{resourcePacket,modelPacket,productInventoryPackets,ssInventoryPacket},
			(* We have operator, instrument, etc. resources in our source list resulting in $Failed *)
			If[MatchQ[modelPacket,$Failed],
				Nothing,
				{
					namedObject[modelPacket],
					(* Get our first real inventory object - we might have multiple products *)
					Module[{packets},
						packets=Cases[Flatten[{productInventoryPackets,ssInventoryPacket},2],PacketP[]];
						FirstCase[packets, KeyValuePattern[{Status -> Active}], First[packets,Null]]
					],
					resourcePacket,
					Lookup[resourcePacket,Purchase]
				}
			]
		],
		{Join@@resourcePackets,Join@@resourceModelPackets,Join@@resourceProductInventoryPackets,Join@@resourceStockSolutionInventoryPackets}
	];

	(* For models which do have inventory requests, look up key info from the inventory. Show each model only once *)
	inventoryData=Map[
		{#[[1]],Lookup[#[[2]],Status],Lookup[#[[2]],ReorderAmount],Lookup[#[[2]],ReorderThreshold],Lookup[#[[2]],Object]}&,
		DeleteDuplicatesBy[Cases[inventoryTuples,{_,Except[Null],_,_}],#[[1]]&]
	];

	(* Get models which don't have associated inventory objects, keep our name and purchase boolean, dropping the non-existent inventory *)
	(* Remove water resources since we don't need inventory for them *)
	noInventories=GatherBy[
		Cases[inventoryTuples,{Except[WaterModelP],Null,_,_}],
		#[[1]]&
	];

	(* For our last request of each model see if we rented the thing or not *)
	(* This isn't perfect because a model could be rented for two distinct reasons and rented in only one case, but should better reflect corrections *)
	lastNoInventories=Map[
		Function[inventoryModelGroups,
			Module[{lastResourceTuple},
				lastResourceTuple=Last[SortBy[inventoryModelGroups,Lookup[#[[3]],DateCreated]&]];
				{lastResourceTuple[[1]],Lookup[lastResourceTuple[[3]],Object],lastResourceTuple[[4]]}
			]
		],
		noInventories
	];

	(* Summary table for requested models which don't have associated inventory and were purchased (likely bad) *)
	noInventoryTable = If[MatchQ[lastNoInventories,{}],
		Style["No resources without standing orders were found",Bold],
		PlotTable[
			failedSymbolStyle[DeleteDuplicates[SortBy[lastNoInventories/.Null->False,Last]],$Failed,True],
			TableHeadings->{Automatic,{"Model Used","Last Requesting Resource","Purchased?"}},
			Title->"Objects With No Standing Orders"
		]
	];

	(* Summary table for requested models that do have inventory set-up (good!) *)
	inventoryTable = If[MatchQ[inventoryData,{}],
		Style["No resources with standing orders were found",Red,Bold],
		PlotTable[
			failedSymbolStyle[SortBy[inventoryData,#[[2]]&],$Failed,Inactive],
			Title->"Objects With Standing Orders",
			TableHeadings->{Automatic,{"Model Used","Standing Order Status","Reorder Amount","Reorder Threshold","Inventory Object"}}
		]
	];

	(* -- VOQ -- *)

	Echo["Checking object validity.."];

	(* Check VOQ for our protocol type - quiet any errors and consider the check $Failed since VOQ should never throw errors *)
	protocolVOQBooleans=Quiet[
		Check[
			ValidObjectQ[protocols,OutputFormat->SingleBoolean],
			$Failed
		]
	];
	ManifoldEcho[{protocols,protocolVOQBooleans},"protocol VOQ data"];

	(* Check VOQ for our protocols' data. Again we don't expect any errors and consider this $Failed *)
	allData=Flatten[protocolData,2];
	dataVOQBooleans = If[
		Length[allData] === 0,
		True,
		Quiet[
			Check[
				ValidObjectQ[allData, OutputFormat -> SingleBoolean],
				$Failed
			]
		]
	];
	ManifoldEcho[{allData,dataVOQBooleans},"data VOQ data"];

	(* See if all VOQ are passing for global summary *)
	allVOQPassing=MatchQ[{protocolVOQBooleans,dataVOQBooleans},{True..}];

	(* General VOQ summary table *)
	voqSummaryTable=PlotTable[
		failedSymbolStyle[{{protocolVOQBooleans,dataVOQBooleans},{Length[protocols],Length[allData]}},False|$Failed],
		Title->"ValidObjectQ Results",
		TableHeadings->{{"Result","Number of Objects"},{ToString[protocolTypes],"Data"}}
	];

	(* -- ValidDocumentationQ -- *)

	Echo["Checking documentation.."];

	(* Expected Sister Functions Defined *)
	previewExperiment=ToExpression[ToString[experimentFunction]<>"Preview"];
	optionsExperiment=ToExpression[ToString[experimentFunction]<>"Options"];
	validExperiment=ToExpression["Valid"<>ToString[experimentFunction]<>"Q"];

	(* Get compilers and parsers if we have them *)
	compilerFunction=Lookup[ECL`CompilerLookup,protocolTypes,Nothing];
	parserFunction=Lookup[ECL`ParserLookup,protocolTypes,Nothing];

	(* Find the association containing all the tasks for our current protocol/procedure, then grab those tasks *)
	executeTasks=Flatten[findTasks[#,TaskType->"Execute"]&/@allProcedures,1];
	executeFunctions=ReleaseHold/@Lookup[Lookup[executeTasks,"Args",{}],"Function",{}];

	(* Make our master list of expected functions - quals and maintenances don't have sister functions *)
	functionSet=DeleteDuplicates[
		Join[
			Flatten[{experimentFunction,compilerFunction,parserFunction}],
			executeFunctions,
			If[protocolQ,
				{previewExperiment,optionsExperiment,validExperiment},
				{}
			]
		]
	];

	(* Check if all our identified functions have valid docs *)
	validDocumentationBooleans=ECL`ValidDocumentationQ[functionSet,OutputFormat->Boolean];
	ManifoldEcho[{functionSet,validDocumentationBooleans},"documentation info"];

	(* See what percent of docs are passing for global summary *)
	validDocsPercentage=100 Percent * N[Count[validDocumentationBooleans,True]/Length[validDocumentationBooleans]];

	(* Make VDQ summary table *)
	validDocumentationTable=PlotTable[
		Transpose[{functionSet,failedSymbolStyle[validDocumentationBooleans]}],
		TableHeadings->{Automatic,{"Function","Docs Valid?"}},
		Title->"Documentation Passing?"
	];

	(*Check if the docs can be found at the standard web address *)
	websiteAddress="https://www.emeraldcloudlab.com/helpfiles/"<>ToLowerCase[ToString[experimentFunction]];

	statusCode=URLRead[HTTPRequest[websiteAddress]]["StatusCode"];

	websiteLine=If[MatchQ[statusCode,404],
		Style["Website documentation is not synced.",Red,Bold],
		With[{address=websiteAddress},Button["Web Help File", SystemOpen[address]]]
	];

	(* -- ExampleResults Notebook -- *)

	(* if we do have a new help file, determine whether we have an ExampleResults notebook *)
	(* if we're a maintenance or qual then this is irrelevant *)
	exampleNotebookExistsQ = If[protocolQ,
		MatchQ[Lookup[Lookup[$HelpFileOptions, experimentFunction, {}], ExampleResults], ObjectP[Object[EmeraldCloudFile]]],
		True
	];

	(* -- Scientific Support -- *)

	Echo["Checking scientific support.."];

	(* Calculate scientific support percentage for the last 3 completed protocols, excluding monitoring tickets *)
	lastProtocols=Take[Reverse[completedProtocolPackets],UpTo[3]];
	directTickets=Flatten[Lookup[lastProtocols,ProtocolSpecificInternalCommunications],1];
	directTicketPackets=Cases[ticketPackets,ObjectP[directTickets]];

	(* ignoring the tickets that are:  *)
	meaningTicketPackets = Select[
		directTicketPackets,
		!Or[
			(* monitor type ticket *)
			MatchQ[Lookup[#, SupportTicketSource], Alternatives @@ MonitoringTicketTypes],
			(* accidental reported by operator *)
			TrueQ[Lookup[#, ReportedOperatorError]],
			(* any non-development error is excluded *)
			MatchQ[Lookup[#, ErrorCategory], Alternatives @@ $ErrorCategoriesToExclude]
		]&
	];
	currentSupportPercentage=If[Length[lastProtocols]==0,
		"N/A",
		100 Percent * N[Length[meaningTicketPackets] / Length[lastProtocols]]
	];

	(* Plot # of scientific support tickets per protocol over time *)
	(* Note: if userSearchCriteria is a list, each element is corresponding to each protocol type *)
	(* For example, {criteriaForProtocol1, criteriaForProtocol2}. If userSearchCriteria is not a list, *)
	(* the same criteria for all protocol types. *)
	supportTimeline = If[MatchQ[userSearchCriteria, _List],
		MapThread[
			Quiet[
				Check[
					PlotSupportTimeline[#1, startDate, Now, SearchCriteria -> #2, Display -> Both, ExcludedCategories -> $ErrorCategoriesToExclude],
					Style["No recent protocols found", Bold]
				],
				PlotSupportTimeline::NoProtocols
			]&,
			{protocolTypes, userSearchCriteria}
		],
		Map[
			Quiet[
				Check[
					PlotSupportTimeline[#, startDate, Now, SearchCriteria -> userSearchCriteria, Display -> Both, ExcludedCategories -> $ErrorCategoriesToExclude],
					Style["No recent protocols found", Bold]
				],
				PlotSupportTimeline::NoProtocols
			]&,
			protocolTypes
		]
	];

	(* Create tables of resolved and unresolved TS tickets *)
	unresolvedTicketTable = Quiet[
		Replace[TroubleshootingTable[protocols, startDate, Now, Resolved -> False, ExcludedCategories -> $ErrorCategoriesToExclude], {} -> Style["No tickets found", Bold]],
		TroubleshootingTable::NoTicketsFound
	];

	unresolvedTicketDisplay = If[MatchQ[unresolvedTicketTable, Null],
		Style["No unresolved tickets found", Bold],
		unresolvedTicketTable
	];

	resolvedTicketTable = Quiet[
		Replace[TroubleshootingTable[protocols, startDate, Now, Resolved -> True, ExcludedCategories -> $ErrorCategoriesToExclude], {} -> Style["No tickets found", Bold]],
		TroubleshootingTable::NoTicketsFound
	];

	resolvedTicketDisplay = If[MatchQ[resolvedTicketTable, Null],
		Style["No resolved tickets found", Bold],
		resolvedTicketTable
	];

	(* -- Qualification and Maintenance -- *)

	Echo["Checking associated qualifications and maintenances.."];

	(* Not we won't have any of this information if we are running PlotBetaTesting for a qual or maintenance type or if we couldn't find instruments in the experiment help file *)
	relevantTargetModelPackets=If[protocolQ,
		instrumentModelPackets,
		DeleteDuplicates[Cases[protocolTargetModelPackets,PacketP[Model]]]
	];

	qualificationRequired=Lookup[relevantTargetModelPackets,QualificationRequired,{}];
	qualificationFrequency=Lookup[relevantTargetModelPackets,QualificationFrequency,{}];
	ManifoldEcho[Lookup[relevantTargetModelPackets,Object,Null],"target models"];

	(* See if we have any quals scheduled for our master summary table *)
	(* We're assuming each instrument needs only one call scheduled *)
	qualScheduled=And@@MapThread[
		(MatchQ[#1,False]||MemberQ[#2[[All,2]],TimeP])&,
		{qualificationRequired,qualificationFrequency}
	];

	(* Plot the scheduling info for quals if we have any *)
	qualScheduleTable=If[MatchQ[relevantTargetModelPackets,{}],
		Style["No linked instruments found", Bold],
		PlotTable[
			Transpose@{
				Lookup[relevantTargetModelPackets,Object],
				qualificationRequired,
				If[MatchQ[#,{}],None,PlotTable[#,Round->True]]&/@Replace[qualificationFrequency,{},{1}]
			},
			TableHeadings->{Automatic,{"Object","QualificationRequired","Qualifications"}},
			Title->"Scheduled Qualifications"
		]
	];

	(* See if we have any maintenance scheduled for our master summary table *)
	(* We only care if this is running for a Maintenance since we otherwise can't say if maintenance is required *)
	maintenanceScheduled=MatchQ[Flatten[Lookup[relevantTargetModelPackets,MaintenanceFrequency,{}][[All,All,2]],1],{TimeP..}];

	(* Plot the scheduling info for maintenances if we have any *)
	maintenanceScheduleTable=If[MatchQ[relevantTargetModelPackets,{}],
		Style["No linked instruments found", Bold],
		PlotTable[
			Transpose@{
				Lookup[relevantTargetModelPackets,Object],
				failedSymbolStyle[If[MatchQ[#,{}],None,PlotTable[#,Round->True]],$Failed,None]&/@Replace[Lookup[relevantTargetModelPackets,MaintenanceFrequency],{},{1}]
			},
			TableHeadings->{Automatic,{"Object","Maintenances"}},
			Title->"Scheduled Maintenance"
		]
	];

	(* If we're running this for an experiment find its associated qual, otherwise act directly on our protocol packets *)
	qualResultPackets=If[protocolQ,
		Select[qualPackets,MatchQ[Lookup[#,DateCompleted],GreaterP[startDate]]&],
		completedProtocolPackets
	];

	(* Order by date completed *)
	sortedQualResultPackets=SortBy[qualResultPackets,{Download[Lookup[#,Target],Object],Download[Lookup[#,Model],Object],Lookup[#,DateCompleted]}&];

	(* Qual is either not required or last qual must be marked as a Pass *)
	qualPassing=MatchQ[qualificationRequired,False]||MatchQ[Lookup[Last[sortedQualResultPackets,<||>],Result],Pass];

	(* Summary table of qual results *)
	qualResultsTable=If[MatchQ[sortedQualResultPackets,{}],
		failedSymbolStyle["No Qualification Results",_],
		PlotTable[
			failedSymbolStyle[Lookup[sortedQualResultPackets,{DateCompleted,Object,Model,Target,Result}],Fail],
			TableHeadings->{Automatic,{"Date Completed","Qualification","Model","Target","Result"}},
			Title->"Qualification Results"
		]
	];

	(* -- Base Protocol TS Rates -- *)

	Echo["Checking subprotocol scientific support.."];

	(* For quals and maintenances we want to understand if there are key subprotocols with TS problems *)
	(* Find the association containing all the tasks for our current protocol/procedure, then grab those tasks *)
	subprotocolTasks=Flatten[findTasks[#,TaskType->"Subprotocol"]&/@allProtocolProcedures,1];
	subprotocolFunctions=DeleteDuplicates[ReleaseHold/@Lookup[Lookup[subprotocolTasks,"Args",{}],"ExperimentFunction",{}]];

	subprotocolSupport=If[protocolQ,
		Null,
		PlotSupportTimeline[Lookup[ProcedureFramework`Private`experimentFunctionTypeLookup,#,$Failed],Display->Both]&/@subprotocolFunctions
	];

	(* -- Authorship -- *)

	Echo["Checking Authorship.."];

	(* get the primary author for the experiment *)
	primaryAuthor = FirstOrDefault[Authors[experimentFunction], None];

	(*  -- Results -- *)

	passingOverall=And[
		EqualQ[validDocsPercentage,100Percent],
		(*EqualQ[unitTestPassingPercentage,100Percent],*)
		StringQ[primaryAuthor],
		allVOQPassing,
		numberOfCompletedProtocols>=10,
		procedureCoverage>70Percent,
		If[protocolOrQualQ,qualScheduled,True],
		If[protocolOrQualQ,qualPassing,True],
		If[!protocolOrQualQ,maintenanceScheduled,True],
		EqualQ[currentSupportPercentage,0 Percent]
	];

	(* Define Helper: safeRound - Ignore any non unit values *)
	(* We may end up with the occasional N/A that we want to ignore *)
	safeRound[value:UnitsP[]]:=Round[value];
	safeRound[value:UnitsP[],increment_]:=Round[value,increment];
	safeRound[value_]:=value;
	safeRound[value_,increment_]:=value;

	summaryData=Transpose@{
		{failedSymbolStyle[safeRound[validDocsPercentage],LessP[100 Percent]],100 Percent},
		(*{failedSymbolStyle[safeRound[unitTstPassingPercentage],LessP[100 Percent]],100 Percent},*)
		{failedSymbolStyle[primaryAuthor, None], "Not None"},
		{failedSymbolStyle[allVOQPassing],True},
		{failedSymbolStyle[numberOfCompletedProtocols,LessP[10]],">=10"},
		{failedSymbolStyle[numberOfRecentlyCompletedProtocols], ""},
		{failedSymbolStyle[safeRound[taskCoverage],LessP[70 Percent]],">=70%"},
		{failedSymbolStyle[exampleNotebookExistsQ], True},
		If[protocolOrQualQ, {failedSymbolStyle[qualScheduled],True}, Nothing],
		If[protocolOrQualQ, {failedSymbolStyle[qualPassing],True},Nothing],
		If[!protocolOrQualQ, {failedSymbolStyle[maintenanceScheduled],True}, Nothing],
		{failedSymbolStyle[safeRound[currentSupportPercentage],GreaterP[0 Percent]],"0%"},
		{resultSymbolStyle[passingOverall],True}
	};

	summaryTable=betaTestSummaryTable[{summaryData},{experimentFunction},{name}];

	outputForms=ToList[outputFormat];

	statusCaption="Consider the average time the relevant protocols, qualifications or maintenances spent in different processing states. OperatorProcessing represents the time operators were directly working on the protocol. If this time exceeds 24 hours verify that the procedure does not have any unnecessary steps or subprotocol calls, tasks that effectively map download, long running executes or repeated long tasks. OperatorStart and OperatorReady represent time when operators are either unavailable or unable to enter the protocol due to resource constraints.";

	statusFollowUpString="A high number of protocols aborted or in shipping materials suggests there may be problems suggest a closer look at the support tickets or the inventory objects may be required.";

	cloudFile=If[MemberQ[outputForms,Notebook],
		Module[{},
			fileName=ToString[experimentFunction]<>" Beta Testing Report "<>StringReplace[DateString[],":"->"_"];

			ExportReport[fileName,{
				{Title,"Beta Testing Report for "<>functionWithName[experimentFunction,name]},
				(* Include the search criteria if something was actually specified (defaults to True - i.e. no additional conditions) *)
				If[!MatchQ[userSearchCriteria,True|{True..}],
					{Subsubsection,"Protocol Search Criteria: "<>ToString[userSearchCriteria]<>" for protocol types "<>ToString[protocolTypes]},
					Nothing
				],
				summaryTable,
				{Section,"Function Validity Checks"},
					{Subsection,"Documentation Checks"},
						validDocumentationTable,
						captionStyle["ValidDocumentationQ is run on the experiment, its sister functions and functions used in the procedure. Run ValidDocumentationQ with Verbose->Failures on any failing functions to learn the causes of the failures."],
					{Subsection,"Help File"},
						websiteLine,
						captionStyle["Documentation should be synced to the website by calling RebuildDocs. The helpfile is expected to be located at "<>websiteAddress],
				{Section,"Object Validity Checks"},
					voqSummaryTable,
					captionStyle["All protocols and associated data must pass ValidObjectQ. If errors are thrown while calling ValidObjectQ, $Failed will be returned in place of a result. ValidObjectQ was run on "<>ToString[Download[Join[allData,protocols],Object],InputForm]],

				Sequence@@Which[
					protocolQ, {
						{Section,"Qualifications and Maintenance"},
						{Subsection,"Scheduling"},
							qualScheduleTable,
							captionStyle["The QualificationFrequency field in the instrument model must point to the qualification and have a time interval set. An exception is made if the Director of Instrumentation indicates QualificationRequired can be set to False."],
							maintenanceScheduleTable,
							captionStyle["Instruments aren't explicitly required to have associated maintenance, but all maintenance recommended in the instrument manual, by the manufacturer, etc. should be considered."],
						{Subsection,"Results"},
							qualResultsTable,
							captionStyle["Instruments associated with experiment must have a passing qualification."],
						{Subsection,"Execution"},
							{Subsubsection,"Status Checks"},
								currentQualStatusTable,
								currentMaintenanceStatusTable,
								captionStyle["Check the current statuses of all maintenance and qualifications to see testing progression. "<>statusFollowUpString],
							{Subsubsection,"Processing Times"},
								meanQualStatusTable,
								meanMaintenanceStatusTable,
								captionStyle[statusCaption]
					},

					(* Running on qual function *)
					MemberQ[protocolTypes,TypeP[Object[Qualification]]], {
						{Subsection,"Scheduling"},
							qualScheduleTable,
							captionStyle["The QualificationFrequency field in the instrument model must point to the qualification and have a time interval set."],
						{Subsection,"Results"},
							qualResultsTable,
							captionStyle["The qualification under consideration should be passing before it leaves beta testing. The developer should receieve Asana tasks to evaluate their qualifications. These tasks include instructions on how to do so."]
					},

					(* Running on maintenance function *)
					MemberQ[protocolTypes,TypeP[Object[Maintenance]]], {
						{Section,"Scheduling"},
						maintenanceScheduleTable,
						captionStyle["The MaintenanceFrequency field in the instrument model must point to the qualification and have a time interval set."]
					}
				],

				Sequence@@If[MemberQ[protocolTypes,TypeP[{Object[Qualification],Object[Maintenance]}]],
					{
						{Section,"Dependent Subprotocols"},
						Sequence@@subprotocolSupport,
						captionStyle["Check the subprotocols used by "<>ToString[experimentFunction]<>" to see what the qualification/maintenance is reliant on."]
					},
					{}
				],

				{Section,"Inventory"},
					inventoryTable,
					noInventoryTable,
					captionStyle["All samples, containers, etc. should be kept in stock if they are routinely consumed during qualifications or standard experiments. For instance, reagents and qualification input samples must be kept in stock unless they can be rented or have very short shelf lives. To rent reusable samples sent Rent->True in the resource object. To create standing orders call UploadInventory."],

				{Section,"Running Protocols"},
					{Subsection,"Protocols Created Over Time"},
						protocolCreationPlot,
					{Subsection,"Status Checks"},
						currentProtocolStatusTable,
						captionStyle["Check the current statuses of all protocols to see testing progression. "<>statusFollowUpString],
					{Subsection,"Checkpoint Accuracy"},
						checkpointComparisonTable,
						captionStyle["Checkpoint estimates should be within "<>ToString[checkpointPercentage]<>"% of the actual value. Checkpoint estimates should not include subprotocols. Subprotocol times have been removed from the actual checkpoint times recorded in CheckpointProgress."],
					{Subsection,"Long Tasks"},
						longTaskTable,
						captionStyle["Long tasks are tasks that took an operator more than 1 hour to complete. This is usually indicative of a poorly designed task (perhaps operators are confused by the instruction, multiple attempts are required a step goes through, operators have to contact their shift manager for help, etc.). Unless the task is a ResourcePicking or Storage task with a large number of involved samples try splitting apart the task, rephrasing, adding error handling or otherwise updating the instructions/images."],
					{Subsection,"Processing Times"},
						meanProtocolStatusTable,
						captionStyle[statusCaption],
					{Subsection,"Procedure Coverage"},
						procedureCoverageTable,
						untestedProcedureTable,
						captionStyle["All procedures that can be entered (for instance every procedure in a branch task) are found. These are compared to the procedures that have actually been entered according to the ProcedureLog of protocols, qualifications and maintenance found since the provided StartDate. All procedures should be tested with the exception of troubleshooting procedures which are only expected to be entered when a given error occurs."],
				{Section,"Support Rates"},
					supportTimeline,
					captionStyle["In order to pass beta testing at least 10 protocols must be run with the last 3 protocols having no associated support tickets. Monitoring tickets, such as those tracking long tasks are excluded from the tickets shown here."],
					{Subsection,"Unresolved Tickets"},
						unresolvedTicketTable,
						captionStyle["Unresolved tickets still need a root cause fix. Monitoring tickets, such as those tracking long tasks are excluded from this list."],
					{Subsection,"Resolved Tickets"},
						resolvedTicketTable,
						captionStyle["Resolved tickets have been closed and should have their root cause fixed. Again monitoring tickets are excluded from this list."]
			}]
		]
	];

	outputRules={
		Notebook -> (SystemOpen[fileName];cloudFile),
		SummaryTable -> summaryTable,
		SummaryData -> summaryData
	};

	outputFormat/.outputRules
];

(*::Subsubsection::Closed::*)
(*PlotBetaTestingSupportRate*)


DefineOptions[PlotBetaTestingSupportRate,
	Options :> {
		{StartDate->(Now - 1 Year),_DateObject,"The first time to consider protocols."},
		{SearchCriteria->Automatic,True|_And|_Or|_Equal|_Unequal|_,"Additional elements to be included in the And used to find protocols to assess during beta testing (for instance specify protocols run on only certain instrument models). If the critieria is a list, the length of the list must equal to the length of protocol types."},
		{Smooth -> Automatic, True|False|Automatic, {"Indicates if the data should be smoothed using AnalyzeSmoothing with Radius set according to the SmoothingRadius option.", "Automatically set to True if SmoothRadius is set to a value greater than 1. Otherwise set to False."}},
		{SmoothingRadius -> Automatic, Automatic | Null | GreaterP[0, 1], {"Indicates the value that should be passed to AnalyzeSmoothing if Smooth is set to True.  A higher SmoothingRadius will create less stochastic data, but will also smooth out nuances that may be desired.", "Automatically set to the smaller of 3 and half the total number of protocols if Smooth is set to True."}}
	}
];

PlotBetaTestingSupportRate[myExperimentFunction_Symbol, ops:OptionsPattern[PlotBetaTestingSupportRate]]:=Module[
	{safeOps, rawStartDate, searchCriteriaQ, userSearchCriteria, startDate, rawProtocolType, protocolTypes, expandedSearchTypes, searchResults,
		tickets, protocols, protocolPackets, ticketPackets, allDownloadValues, completedProtocolPackets, directTicketsPerProtocol,
		meaningTicketPackets, ticketsPerProtocol,partitionedSupportTicketRate,runningAverageSupportTicketRate,
		oneToNumTickets, protocolsPerNumber, protocolsVsTime, blockingTicketsPerProtocol, blockingTimesPerTicket, blockingTicketRatePerProtocol,
		blockingTimePerProtocol, rawTicketsPerProtocolData, rawBlockingTicketsPerProtocolData, rawBlockingTimePerProtocolData,
		smoothedTicketsPerProtocolData, smoothedBlockingTicketsPerProtocolData, smoothedBlockingTimePerProtocolData,
		smooth,smoothingRadius, resolvedSmooth, resolvedSmoothingRadius},

	safeOps=SafeOptions[PlotBetaTestingSupportRate,ToList[ops]];
	{rawStartDate,searchCriteriaQ,smooth,smoothingRadius}=Lookup[safeOps,{StartDate,SearchCriteria,Smooth,SmoothingRadius}];

	userSearchCriteria = If[MatchQ[searchCriteriaQ, Automatic],
		(* If SearchCriteria is True, we lookup $BetaExperimentFunctions for criteria first *)
		(* If there is SearchCriteria specified inside of $BetaExperimentFunctions, use that *)
		(* Note if SearchCriteria is specified in option, it will override the value in $BetaExperimentFunctions *)
		If[MemberQ[Keys@$BetaExperimentFunctions, ToString@myExperimentFunction],
			Lookup[Association@Lookup[$BetaExperimentFunctions, ToString@myExperimentFunction], SearchCriteria, True],
			True
		],
		searchCriteriaQ
	];

	startDate=CurrentDate[rawStartDate,"Instant"];

	(* Find the protocol type associated with this experiment function so that we can search for existing options *)
	rawProtocolType=Lookup[ProcedureFramework`Private`experimentFunctionTypeLookup,myExperimentFunction,$Failed];

	(* Some protocols can return MSP or RSP. We don't want to consider these here since we are expecting the direct protocols to be tested *)
	protocolTypes=Replace[
		Cases[
			ToList[rawProtocolType],
			Except[Alternatives[Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation], Object[Notebook, Script]]]
		],
		{} -> {Object[Protocol, RoboticSamplePreparation]},
		{0}
	];
	expandedSearchTypes = Append[ToList /@ protocolTypes, {Object[SupportTicket, Operations]}];
	searchResults = With[
		{
			(* Generate a searchCriteria for each protocol type and add support ticket search criteria here as well *)
			(* Assemble criteria, not this is not being held as it would be directly inside search*)
			expandedSearchCriteria = If[MatchQ[userSearchCriteria, _List],
				Append[
					(* Protocol *)
					(DateCreated>(startDate) && #)&/@ userSearchCriteria,
					(* Tickets *)
					SourceProtocol[Type]==(Alternatives @@ protocolTypes) && DateCreated>(startDate)
				],
				Append[
					(* Protocol *)
					ConstantArray[DateCreated > (startDate) && userSearchCriteria, Length[protocolTypes]],
					(* Tickets *)
					SourceProtocol[Type] == (Alternatives @@ protocolTypes) && DateCreated > (startDate)
				]
			]
		},
		(* Note: a valid search can contain type-criteria pairs, types and criteria should have the same length *)
		(* For example, Search[{{protocolType1},{protocolType2}},{criteriaForProtocol1, criteriaForProtocol2}] *)
		Search[
			expandedSearchTypes,
			expandedSearchCriteria
		]
	];

	tickets = Last[searchResults];
	protocols = Flatten@Most[searchResults];

	allDownloadValues = Download[
		{
			protocols,
			tickets
		},
		{
			{Packet[ProtocolSpecificInternalCommunications, Status, Subprotocols, DateCreated, DateCompleted]},
			{Packet[Resolved, Headline, Description, SupportTicketSource, SourceProtocol, ReportedOperatorError, ErrorCategory, BlockedLog]}
		}
	];
	protocolPackets = allDownloadValues[[1, All, 1]];
	ticketPackets = allDownloadValues[[2, All, 1]];

	(* get the completed packets and sort them by when they were completed *)
	completedProtocolPackets = SortBy[Select[protocolPackets, MatchQ[Lookup[#, Status], Completed]&], Lookup[#, DateCompleted]&];

	directTicketsPerProtocol = Map[
		Function[{protocolPacket},
			Cases[ticketPackets, ObjectP[Lookup[protocolPacket, ProtocolSpecificInternalCommunications]]]
		],
		completedProtocolPackets
	];

	(* ignore tickets that are clearly not the fault of the function in question *)
	meaningTicketPackets = Map[
		Function[{ticketPackets},
			Select[
				ticketPackets,
				!Or[
					(* monitor type ticket *)
					MatchQ[Lookup[#, SupportTicketSource], Alternatives @@ MonitoringTicketTypes],
					(* accidental reported by operator *)
					TrueQ[Lookup[#, ReportedOperatorError]],
					(* any non-development error is excluded *)
					MatchQ[Lookup[#, ErrorCategory], Alternatives @@ $ErrorCategoriesToExclude]
				]&
			]
		],
		directTicketsPerProtocol
	];

	(* get the number of tickets per protocol *)
	ticketsPerProtocol = Length /@ meaningTicketPackets;

	(* get the blocking tickets for each protocol *)
	blockingTicketsPerProtocol = Map[
		Function[{ticketPackets},
			Select[ticketPackets, MemberQ[Lookup[#, BlockedLog][[All, 3]], True]&]
		],
		meaningTicketPackets
	];

	(* get the length of time where each ticket was blocking *)
	blockingTimesPerTicket = Map[
		Function[{blockingTicketPackets},
			Module[{blockedLog, partitionedBlockedLog, blockingTimeSlots},
				blockedLog = Lookup[blockingTicketPackets, BlockedLog, {}];

				(* partition the blocked log with the offset of 1 so we get {a, b, c, d} -> {{a, b}, {b, c}, {c, d}}*)
				(* doing this so we can measure the times where we were going from Blocked -> True to Blocked -> False *)
				partitionedBlockedLog = Partition[blockedLog, 2, 1];
				blockingTimeSlots = Select[partitionedBlockedLog, TrueQ[#[[1, 3]]] && MatchQ[#[[2, 3]], False]&];

				(* get the times from the end of blocking - start of blocking and combine them in case a ticket has multiple blockings *)
				Total[Map[
					#[[2, 1]] - #[[1, 1]]&,
					blockingTimeSlots
				]]
			]
		],
		blockingTicketsPerProtocol,
		(* this levelspec {2} makes every iteration of the map be a single ticket *)
		{2}
	];

	(* get the blocking ticket rate per protocol and the total amount of time *)
	(* need to do /. shenanigans so that Total[{}] gives us 0 Hour and not just 0 *)
	blockingTicketRatePerProtocol = Length /@ blockingTicketsPerProtocol * 100. Percent;
	blockingTimePerProtocol = Convert[Total /@ blockingTimesPerTicket /. {0 -> 0 Hour}, Hour];

	(* doing this Range call a lot; this is just 1 up to the number of tickets *)
	oneToNumTickets = Range[Length[meaningTicketPackets]];

	(* make the raw data for tickets per protocol *)
	rawTicketsPerProtocolData = Transpose[{oneToNumTickets, ticketsPerProtocol}];
	rawBlockingTicketsPerProtocolData = Transpose[{oneToNumTickets, blockingTicketRatePerProtocol}];
	rawBlockingTimePerProtocolData = Transpose[{oneToNumTickets, blockingTimePerProtocol}];

	(* resolve the smoothing options *)
	{resolvedSmooth, resolvedSmoothingRadius} = Switch[{smooth, smoothingRadius},
		{Automatic, Automatic|Null}, {False, Null},
		{Automatic, _}, {True, smoothingRadius},
		(* radius can't be greater than half the number of protocols, but also can't be zero *)
		{True, Automatic}, {smooth, Min[3, Max[Quotient[Length[meaningTicketPackets],2], 1]]},
		{False, Automatic}, {smooth, Null},
		{_, _}, {smooth, smoothingRadius}
	];


	(* smooth the data; if we're not smoothing then this is just the same as the raw data (and saves us a conditional later) *)
	(* need to do this Min so that we don't error if we don't have enough *)
	smoothedTicketsPerProtocolData = If[resolvedSmooth && Length[meaningTicketPackets] >= 1,
		Lookup[
			AnalyzeSmoothing[rawTicketsPerProtocolData, Radius -> resolvedSmoothingRadius, Method -> Gaussian, Upload -> False],
			SmoothedDataPoints
		],
		rawTicketsPerProtocolData
	];
	smoothedBlockingTicketsPerProtocolData = If[resolvedSmooth && Length[meaningTicketPackets] >= 1,
		Lookup[
			AnalyzeSmoothing[rawBlockingTicketsPerProtocolData, Radius -> resolvedSmoothingRadius, Method -> Gaussian, Upload -> False],
			SmoothedDataPoints
		],
		rawBlockingTicketsPerProtocolData
	];
	smoothedBlockingTimePerProtocolData = If[resolvedSmooth && Length[meaningTicketPackets] >= 1,
		Lookup[
			AnalyzeSmoothing[rawBlockingTimePerProtocolData, Radius -> resolvedSmoothingRadius, Method -> Gaussian, Upload -> False],
			SmoothedDataPoints
		],
		rawBlockingTimePerProtocolData
	];

	(* partition the support ticket rate into overlapping groups of 3.  This will split {1, 2, 3, 4, 5, 6, 7, 8, 9, 10} into {{Null, Null, 1}, {Null, 1,2},{1,2,3},{2,3,4},{3,4,5},{4,5,6},{5,6,7},{6,7,8},{7,8,9},{8,9,10}} so we can get a running average *)
	(* doing [[;;-3]] ensures here that we are always counting the current + previous two protocols; if we don't have two previous protocols then we get away with not having that *)
	(* if we have fewer than 3, don't bother averaging; we have so little data anyway*)
	(* not actually using this for now because frezza prefers to use AnalyzeSmoothing.  That's fine I guess (though I would argue it doesn't give as much insight because the Radius option includes future smoothing data and not just past smoothing data (and so as we run more protocols, the past graph will change) *)
	partitionedSupportTicketRate = If[Length[ticketsPerProtocol] < 3,
		ToList /@ ticketsPerProtocol,
		Partition[ticketsPerProtocol, UpTo[3], 1, {-1, 1}, {Null, Null}][[;;-3]]
	];
	runningAverageSupportTicketRate = Mean[DeleteCases[#, Null]]& /@ partitionedSupportTicketRate;

	protocolsPerNumber = EmeraldListLinePlot[
		{
			smoothedTicketsPerProtocolData,
			smoothedBlockingTicketsPerProtocolData
		},
		(* doing these shenanigans so that we inherit the optimized-for-us options from EmeraldListLinePlot, but can still use ListLinePlot *)
		(* ListLinePlot lets us use tooltips on specific points which ELLP seemingly doesn't, so for now using this *)
		{
			PlotLabel -> ToString[myExperimentFunction],
			Zoomable -> True,
			SecondYCoordinates -> smoothedBlockingTimePerProtocolData,
			SecondYRange -> {0 Hour, Max[Flatten[{0 Hour, smoothedBlockingTimePerProtocolData[[All, 2]]}]]},
			(* not sure if it's possible to put the secondary data into the legend; couldn't figure it out at my attempt *)
			Legend -> {"Ticket Count", "Blocking Ticket Count"},
			LegendPlacement -> Right,
			SecondYUnit -> Hour
		}
	];

	(* this one looks a lot uglier and not really that much more informative; will keep it around in case we decide to do something here, but not returning it for now *)
	protocolsVsTime = EmeraldDateListPlot[
		{
			Transpose[{Lookup[completedProtocolPackets, DateCompleted, {}], ticketsPerProtocol}],
			Transpose[{Lookup[completedProtocolPackets, DateCompleted, {}], runningAverageSupportTicketRate}]
		},
		PlotLabel -> "Number of Support Tickets Per Protocol Over Time"
	];

	protocolsPerNumber

];

(* ::Subsubsection::Closed:: *)
(*PlotBetaTesting helpers*)

(* PlotBetaTesting helper: Convert False, $Failed or provided pattern into a red string for highlighting in tables *)
betaTestingErrorStyle = {Bold, Red};
betaTestingWarningStyle = Orange;

failedSymbolStyle[input_] := failedSymbolStyle[input, False | $Failed];
failedSymbolStyle[input_?QuantityQ, errorPattern_] := input /. errorPattern :> Style[UnitForm[input], betaTestingErrorStyle];
failedSymbolStyle[input_?QuantityQ, errorPattern_, warningPattern_] := input /. {errorPattern :> Style[UnitForm[input], betaTestingErrorStyle], warningPattern :> Style[UnitForm[input], betaTestingWarningStyle]};
failedSymbolStyle[input_, errorPattern_] := ReplaceAll[input, in:errorPattern :> Style[ToString[in], betaTestingErrorStyle]];
failedSymbolStyle[input_, errorPattern_,warningPattern_] := ReplaceAll[input, {in:errorPattern :> Style[ToString[in], betaTestingErrorStyle], in:warningPattern :> Style[ToString[in], betaTestingWarningStyle]}];

resultSymbolStyle[input_] := ReplaceAll[input, {False|$Failed:>Style[ToString[input],betaTestingErrorStyle],True:>Style[ToString[input],Bold,RGBColor[0.32, 0.69, 0.53]]}];

(* PlotBetaTesting helpers: Format text for notebook display *)
captionStyle[input_]:=Style[input,Italic,FontSize->12];
tooltipStyle[input_]:=Style[input,Italic,Darker[Blue]];

(* Tiny helper so we always format function 'Name' option in the same way *)
(* note that StringJoin-ing does work with lists; it will just string join the contents *)
(* thus, if we do {}, we are de facto StringJoin-ing "" so we have to account for that *)
functionWithName[function_, name_] := If[MatchQ[name, "" | Null | {}],
	ToString[function],
	ToString[function] <> " (" <> name <> ")"
];


(* procedureTree: Find all procedures called by a another procedure by recursively following references *)
procedureTree[protocol:TypeP[]]:=procedureTree[protocol,{protocol},{}];
procedureTree[protocol:TypeP[],unusedProcedures_]:=procedureTree[protocol,{protocol},unusedProcedures];
procedureTree[protocol:(TypeP[]|_String),trackedSubs_,unusedProcedures_]:=Module[{procedureDefinition, tasks, procedures},

	(* Don't recurse if we've already encountered our current protocol (this suggests we have a loop with a procedure pointing to itself *)
	If[Count[trackedSubs,protocol]>1,
		Return[trackedSubs]
	];

	(* Find the association containing all the tasks for our current protocol/procedure, then grab those tasks *)
	If[SameQ[ProcedureFramework`Private`procedures,<||>],
		Message[PlotBetaTesting::MissingProcedureDefinitions];
	];
	procedureDefinition=SelectFirst[ProcedureFramework`Private`procedures,MatchQ[Lookup[#,"Name"], ToString[protocol]]&];

	If[MatchQ[procedureDefinition,_Missing],
		Return[{}]
	];

	tasks=Lookup[procedureDefinition,"Tasks"];

	(* Recursively find all procedures referenced in other procedures *)
	procedures=Map[
		Function[task,
			Module[{taskArgs,sub,subs},
				taskArgs=Lookup[task,"Args"];
				Which[
					(* "LoopInsertion" and "ProcedureInsertion" tasks store a subprocedure in Procedure key *)
					MatchQ[Lookup[task,"TaskType"],"LoopInsertion"|"ProcedureInsertion"],
					sub=ReleaseHold[Lookup[taskArgs,"Procedure"]];
					If[MemberQ[unusedProcedures,sub],
						Nothing,
						procedureTree[sub,Join[trackedSubs,{sub}],unusedProcedures]
					],

					(* "Branch" and "MultipleChoiceBranch" tasks store subprocedures in Rules key *)
					MatchQ[Lookup[task,"TaskType"],"Branch"|"MultipleChoiceBranch"],
					subs=DeleteCases[ReleaseHold[Lookup[taskArgs,"Rules"]][[All,2]],None|Continue];
					If[MemberQ[unusedProcedures,#],
						Nothing,
						procedureTree[#,Join[trackedSubs,subs],unusedProcedures]
					]&/@subs,

					(* All other tasks have no procedures to consider *)
					True,
					Nothing
				]
			]
		],
		tasks
	];

	DeleteDuplicates@DeleteCases[ToString/@Join[Flatten[procedures,2],trackedSubs],Alternatives@@unusedProcedures]
];

(*findTasks: Given a procedure name or type, recursively find tasks within *)
DefineOptions[findTasks,Options:>{
	{TaskType->All,All|_String,"Indicates the Engine task being selected for."},
	{ID->All,All|_String,"Indicates the ID of the Engine task being selected for."}
}];

(* findTask: Listable overload *)
findTasks[procedure:{(TypeP[]|_String)..},ops_]:=Flatten[findTasks[#,ops]&/@procedure,1];

(* findTasks: Main overload *)
findTasks[procedure:(TypeP[]|_String),ops_]:=Module[{safeOps,taskType,id,procedureDefinition,tasks,tasksByType,tasksByID},
	safeOps=SafeOptions[findTasks,ToList[ops]];
	{taskType,id}=Lookup[safeOps,{TaskType,ID}];

	procedureDefinition=SelectFirst[ProcedureFramework`Private`procedures,MatchQ[Lookup[#,"Name"], ToString[procedure]]&];

	tasks=Lookup[procedureDefinition,"Tasks",{}];

	tasksByType=If[MatchQ[taskType,All],
		tasks,
		Select[tasks,MatchQ[Lookup[#,"TaskType"],taskType]&]
	];

	tasksByID=If[MatchQ[id,All],
		tasksByType,
		Select[tasksByType,MatchQ[Lookup[#,"ID"],id]&]
	]
];

taskCountInProcedure[procedureName_]:=Module[{procedureDefinition,tasks},
	procedureDefinition=SelectFirst[ProcedureFramework`Private`procedures,MatchQ[Lookup[#,"Name"], ToString[procedureName]]&];

	tasks=Lookup[procedureDefinition,"Tasks",{}];

	Length[tasks]
];

(* betaTestSummaryTable: Empty overload *)
betaTestSummaryTable[data:{},function:{},name:{}]:=Null;

(* betaTestSummaryTable: Main overload *)
(* Convert beta summary values for a protocol (list) or series of protocols (list of lists) into a display *)
(* This is a funny helper because we can't just return a table from within the body of PlotBetaTesting -
 we need to merge the table for the case where we're looking at multiple protocols *)
betaTestSummaryTable[rawData_,rawFunctions:{___},rawNames:{___}]:=Module[
	{data,functions,names,functionDescriptions,failedFunctions, failedNames,failedDescriptions,failedPlot,mergedData,
		columnHeaders,successPlot},

	(* Split out into $Failed and successful runs *)
	data=DeleteCases[rawData,$Failed];
	functions=PickList[rawFunctions,rawData,Except[$Failed]];
	names=PickList[rawNames,rawData,Except[$Failed]];
	functionDescriptions=MapThread[functionWithName,{functions,names}];

	failedFunctions=PickList[rawFunctions,rawData,$Failed];
	failedNames=PickList[rawNames,rawData,$Failed];
	failedDescriptions=MapThread[functionWithName,{failedFunctions,failedNames}];

	(* Plot types where we PlotBetaTesting didn't return expected values or returned $Failed *)
	failedPlot=If[MatchQ[failedFunctions,{}],
		Nothing,
		PlotTable[{failedSymbolStyle[#,_Symbol]}&/@failedDescriptions, Title -> "Unable to Generate Beta Testing Reports for:"]
	];

	(* Return early if we only have failed plots *)
	If[MatchQ[data,{}],
		Return[failedPlot]
	];

	(* We're joining multiple summary tables and want only the actual data and not the required values after every entry *)
	(* Add the required values as our very last entry *)
	mergedData=Append[data[[All,1]],data[[1,2]]];

	(* Column headers match up with the data values returned by PlotBetaTesting and these two must be kept in sync *)
	(* Maintenance don't have all the same values and thus also have different headers *)
	columnHeaders = Join[
		{"Documentation Passing (%)","Primary Author", "VOQ Passing?","Completed Protocols", "Recent Protocols", "Task Coverage", "Example Notebook"},
		If[MatchQ[With[{func = First[functions]},FunctionPackage[func]],"Maintenance`"],
			{"Maintenance Scheduled?"},
			{"Qualification Scheduled?","Qualification Passing?"}
		],
		{"Current Support Rate","Beta Testing Passing?"}
	];

	(* Plot types for which we have results (doesn't need beta testing is passing) *)
	successPlot=PlotTable[
		mergedData,
		TableHeadings->{
			(* Label the lest row to indicate it's just showing the expected numbers *)
			Append[functionDescriptions,"Required Values"],
			columnHeaders
		},
		Round->True,
		HorizontalScrollBar->False,
		Title->"Summary Table"
	];

	Grid[{{successPlot},{failedPlot}}]
];


PlotBetaTesting[ops:OptionsPattern[PlotBetaTesting]]:=Module[
	{email, rawBetaResults, betaResults, functions, functionOptions, failedFunctions,
		notebooks,summaryDataSets,protocolTypes,authorNames,authors,dataTuples,maintenanceTuples,
		qualificationTuples,protocolTuples,maintenanceSummary,qualificationSummary,protocolSummary,protocolAuthors,qualificationAuthors,
		maintenanceAuthors,maintenancePNG,qualPNG,protocolPNG,instrumentationPeople,sciDevPeople,allInstrumentPeople,allProtocolPeople,
		downloadedEmails,downloadedInstrumentEmails,downloadedProtocolEmails,defaultProtocolEmails,defaultEmails,
		finalProtocolEmails,finalInstrumentEmails,formatMessage,protocolMessage,qualMessage,generalPeople},

	(* Pull out the Email option *)
	email = Lookup[ToList[ops],Email,True];

	(* Pull out our functions being tested *)
	functions=ToExpression/@Keys[$BetaExperimentFunctions];
	functionOptions=Values[$BetaExperimentFunctions];

	(* $BetaExperimentFunctions is structured as <|"ExperimentName" -> {testing options} ... |> *)
	(* Call PlotBetaTesting on all listed functions *)
	rawBetaResults=KeyValueMap[
		PlotBetaTesting[ToExpression[#1],ReplaceRule[#2,OutputFormat->{Notebook,SummaryData}]]&,
		$BetaExperimentFunctions
	];

	(* Pull out our successful calls and associated functions *)
	betaResults=Replace[rawBetaResults, {Except[{ObjectP[], _}] -> {$Failed, $Failed}}, {1}];
	failedFunctions=PickList[functions,rawBetaResults,Except[{ObjectP[],_}]];

	(* OutputFormat asked for notebook, summary data - extract them now *)
	notebooks=betaResults[[All,1]];
	summaryDataSets=betaResults[[All,2]];

	(* Lookup types associated with our functions *)
	protocolTypes=Lookup[ProcedureFramework`Private`experimentFunctionTypeLookup,#,$Failed]&/@functions;

	(* Lookup function author objects *)
	authorNames=First[Authors[#],Null]&/@functions;
	authors=If[MatchQ[#,Null],Null,Object[User, Emerald, Developer, #]]&/@authorNames;

	(* Make result tuples *)
	dataTuples=Transpose[{protocolTypes,summaryDataSets,functions,functionOptions,notebooks,authors}];

	(* Split into maintenance, qual and protocol results since we want to present separately *)
	maintenanceTuples = Cases[dataTuples,{TypeP[Object[Maintenance]],___}];
	qualificationTuples = Cases[dataTuples,{TypeP[Object[Qualification]],___}];
	(* Note: for protocolTypes, it is possible it is a list of protocols instead of a singleton *)
	protocolTuples = Cases[dataTuples,{(TypeP[Object[Protocol]]|{TypeP[Object[Protocol]]..}),___}];

	(* Join up the results from each experiment into a single table *)
	maintenanceSummary = betaTestSummaryTable[maintenanceTuples[[All,2]], maintenanceTuples[[All,3]], Lookup[maintenanceTuples[[All,-3]],Name,{}]];
	qualificationSummary = betaTestSummaryTable[qualificationTuples[[All,2]], qualificationTuples[[All,3]], Lookup[qualificationTuples[[All,-3]],Name,{}]];
	protocolSummary = betaTestSummaryTable[protocolTuples[[All,2]], protocolTuples[[All,3]], Lookup[protocolTuples[[All,-3]],Name,{}]];

	(* If we are not emailing, return immediately *)
	If[MatchQ[email,False],
		Return[
			Grid[
				{
					{
						Transpose[{maintenanceTuples[[All,-4]],maintenanceTuples[[All,-2]]}],
						maintenanceSummary
					},
					{
						Transpose[{qualificationTuples[[All,-4]],qualificationTuples[[All,-2]]}],
						qualificationSummary
					},
					{
						Transpose[{protocolTuples[[All,-4]],protocolTuples[[All,-2]]}],
						protocolSummary
					}
				}
			]
		]
	];

	(* Grab our authors so we can email them *)
	protocolAuthors=protocolTuples[[All,-1]];
	qualificationAuthors=qualificationTuples[[All,-1]];
	maintenanceAuthors=maintenanceTuples[[All,-1]];

	(* Convert summary tables into pngs - leave as null if we don't have any protocols of the type *)
	{maintenancePNG,qualPNG,protocolPNG}=MapThread[
		If[!NullQ[#2],Export[#1<>".png",#2]]&,
		{
			{"Maintenance Beta Testing","Qualification Beta Testing","Protocol Beta Testing"},
			{maintenanceSummary,qualificationSummary,protocolSummary}
		}
	];

	(* Lookup folks who should always receive these reports *)
	{instrumentationPeople, sciDevPeople, generalPeople} = Search[
		{Object[User, Emerald],Object[User, Emerald], Object[User, Emerald]},
		{
			Status==Active && (Department==(ScientificInstrumentation) || Position=="Director of Operations"),
			Status==Active && Department==Development && Position=="Scientific Developer",
			Status==Active && Position==("Director of Scientific Development" | "Sales Leader" | "Account Manager" | "Director of Operations" | "Scientific Developer")
		}
	];

	(* Get full list of report recipient objects *)
	allInstrumentPeople=DeleteDuplicates[DeleteCases[Join[instrumentationPeople,maintenanceAuthors,qualificationAuthors],Null]];
	allProtocolPeople=DeleteDuplicates[DeleteCases[Join[sciDevPeople,protocolAuthors,generalPeople],Null]];

	(* Get emails for report recipients *)
	downloadedEmails=Download[Join[allInstrumentPeople,allProtocolPeople],Email];
	{downloadedInstrumentEmails,downloadedProtocolEmails}=TakeList[downloadedEmails,{Length[allInstrumentPeople],Length[allProtocolPeople]}];

	(* Hardcode a list of people who always want to receive emails *)
	defaultProtocolEmails = {
		"ben@emeraldcloudlab.com",
		"malav.desai@emeraldcloudlab.com",
		"andrew.heywood@emeraldcloudlab.com"
	};

	defaultEmails = {
		"hayley@emeraldcloudlab.com",
		"frezza@emeraldcloudlab.com",
		"harrison.gronlund@emeraldcloudlab.com",
		"dima@emeraldcloudlab.com"
	};

	(* Final email lists *)
	finalProtocolEmails=DeleteDuplicates[Join[downloadedProtocolEmails,defaultProtocolEmails,defaultEmails]];
	finalInstrumentEmails=DeleteDuplicates[Join[downloadedInstrumentEmails,defaultEmails]];

	(* Helper function: formatMessage - create email body *)
	formatMessage[messageData:{},header_String]:="There are no "<>header<>" currently in beta testing";
	formatMessage[messageData_,header_String]:=Module[{innerStrings,experiments,cloudFiles,names,experimentLines},

		experiments=messageData[[All,-4]];
		cloudFiles=messageData[[All,-2]];

		(* Lookup name option from options sent to PlotBetaTesting *)
		names=Lookup[#,Name,Null]&/@messageData[[All,-3]];

		experimentLines=MapThread[
			(functionWithName[#1,#2]<>"\n"<>ToString[#3,InputForm])&,
			{experiments,names,cloudFiles}
		];

		"Beta Functions with their Full Notebooks\n\n"<>StringRiffle[experimentLines, "\n\n"]
	];

	(* Create our email bodies *)
	protocolMessage=formatMessage[protocolTuples,"protocols"];
	qualMessage=formatMessage[Join[maintenanceTuples,qualificationTuples],"qualifications or maintenance"];

	(* Send Protocol Email *)
	If[!MatchQ[protocolMessage,Null],
		Email[
			finalProtocolEmails,
			Subject -> "Protocol Beta Testing",
			Message -> protocolMessage,
			Attachments -> Cases[{protocolPNG}, FilePathP]
		]
	];

	(* Send Maintenance and Quals Email *)
	If[!MatchQ[qualMessage,Null],
		Email[
			finalInstrumentEmails,
			Subject -> "Qualification and Maintenance Beta Testing",
			Message -> qualMessage,
			Attachments -> Cases[{maintenancePNG,qualPNG}, FilePathP]
		]
	];

	(* Return results for all the protocols, quals and maintenance tested *)
	dataTuples
];
